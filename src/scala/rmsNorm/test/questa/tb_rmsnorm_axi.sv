// Questa testbench for RmsNormAxiTop + real Altera FP IPs.
// DIM must match Spinal elaboration (default 2048): make verilog RMSNORM_DIM=<DIM>.

`timescale 1ns/1ps

import rmsnorm_fp16_pkg::*;

module tb_rmsnorm_axi;

`ifdef RMSNORM_DIM
  localparam int DIM = `RMSNORM_DIM;
`else
  localparam int DIM = 2048;
`endif
  localparam int CLK_PERIOD_NS = 10;
  localparam real EPS = 1.0e-5;
  localparam int MAX_CYCLES = DIM * 800;
  // Heartbeat ~16 lines across the output-wait timeout (scales with DIM).
  // Too small (e.g. 100) floods Questa I/O; too large feels hung on slow IP sim.
  localparam int HEARTBEAT_CYCLES = MAX_CYCLES / 16;

  logic clk;
  logic reset;

  logic            io_dataIn_valid;
  logic            io_dataIn_ready;
  logic [15:0]     io_dataIn_payload_data;
  logic [1:0]      io_dataIn_payload_keep;
  logic            io_dataIn_payload_last;
  logic [31:0]     io_dataIn_payload_user;

  logic            io_weightIn_valid;
  logic            io_weightIn_ready;
  logic [15:0]     io_weightIn_payload_data;
  logic [1:0]      io_weightIn_payload_keep;
  logic            io_weightIn_payload_last;
  logic [31:0]     io_weightIn_payload_user;

  logic            io_dataOut_valid;
  logic            io_dataOut_ready;
  logic [15:0]     io_dataOut_payload_data;
  logic [1:0]      io_dataOut_payload_keep;
  logic            io_dataOut_payload_last;
  logic [31:0]     io_dataOut_payload_user;

  RmsNormAxiTop dut (
    .io_dataIn_valid          (io_dataIn_valid),
    .io_dataIn_ready          (io_dataIn_ready),
    .io_dataIn_payload_data   (io_dataIn_payload_data),
    .io_dataIn_payload_keep   (io_dataIn_payload_keep),
    .io_dataIn_payload_last   (io_dataIn_payload_last),
    .io_dataIn_payload_user   (io_dataIn_payload_user),
    .io_weightIn_valid        (io_weightIn_valid),
    .io_weightIn_ready        (io_weightIn_ready),
    .io_weightIn_payload_data (io_weightIn_payload_data),
    .io_weightIn_payload_keep (io_weightIn_payload_keep),
    .io_weightIn_payload_last (io_weightIn_payload_last),
    .io_weightIn_payload_user (io_weightIn_payload_user),
    .io_dataOut_valid         (io_dataOut_valid),
    .io_dataOut_ready         (io_dataOut_ready),
    .io_dataOut_payload_data  (io_dataOut_payload_data),
    .io_dataOut_payload_keep  (io_dataOut_payload_keep),
    .io_dataOut_payload_last  (io_dataOut_payload_last),
    .io_dataOut_payload_user  (io_dataOut_payload_user),
    .clk                      (clk),
    .reset                    (reset)
  );

  int sim_cycle;
  int hb_out_cnt;

  initial clk = 1'b0;
  always #(CLK_PERIOD_NS / 2) clk = ~clk;

  always @(posedge clk) begin
    sim_cycle++;
    if (sim_cycle == 1) begin
      $display("[tb] heartbeat every %0d cycles (output timeout %0d)", HEARTBEAT_CYCLES, MAX_CYCLES);
    end else if ((sim_cycle % HEARTBEAT_CYCLES) == 0) begin
      $display("[tb] t=%0t cycle=%0d out=%0d/%0d reset=%b dataIn_rdy=%b wtIn_rdy=%b dataOut_vld=%b",
               $time, sim_cycle, hb_out_cnt, DIM, reset,
               io_dataIn_ready, io_weightIn_ready, io_dataOut_valid);
    end
  end

  // Questa has no $abs for real (vsim-PLI-3003); use explicit compare.
  function automatic real abs_real(input real v);
    return (v < 0.0) ? -v : v;
  endfunction

  function automatic void golden_rmsnorm(
    input  shortreal x[],
    input  shortreal gamma[],
    input  real eps,
    output shortreal y[]
  );
    real sum;
    real scale;
    int d;
    d = x.size();
    y = new[d];
    sum = 0.0;
    for (int i = 0; i < d; i++) sum += real'(x[i]) * real'(x[i]);
    scale = 1.0 / $sqrt(sum / d + eps);
    for (int i = 0; i < d; i++) y[i] = shortreal'(real'(x[i]) * scale * real'(gamma[i]));
  endfunction

  // Drive DIM beats: random idle (0..GAP_MAX cycles), then 1..BURST_MAX consecutive fires if ready.
  task automatic drive_data_stream_jitter(input shortreal values[], input logic [31:0] user_ctx, input int seed);
    int idx, gap, burst, sent;
    localparam int BURST_MAX = 4;
    localparam int GAP_MAX   = 5;
    $srandom(seed);
    io_dataIn_valid = 1'b0;
    idx = 0;
    while (idx < DIM) begin
      gap = $urandom_range(0, GAP_MAX);
      repeat (gap) begin
        io_dataIn_valid = 1'b0;
        @(posedge clk);
      end
      burst = $urandom_range(1, BURST_MAX);
      sent  = 0;
      while (sent < burst && idx < DIM) begin
        if (!io_dataIn_valid) begin
          while (!io_dataIn_ready) begin
            @(posedge clk);
          end
          io_dataIn_payload_data = real_to_fp16(real'(values[idx]));
          io_dataIn_payload_keep = 2'b11;
          io_dataIn_payload_last = (idx == DIM - 1);
          io_dataIn_payload_user = (idx == 0) ? user_ctx : 32'h0;
          io_dataIn_valid        = 1'b1;
        end
        @(posedge clk);
        if (io_dataIn_valid && io_dataIn_ready) begin
          idx++;
          sent++;
          if (sent < burst && idx < DIM) begin
            io_dataIn_payload_data = real_to_fp16(real'(values[idx]));
            io_dataIn_payload_keep = 2'b11;
            io_dataIn_payload_last = (idx == DIM - 1);
            io_dataIn_payload_user = 32'h0;
          end else begin
            io_dataIn_valid = 1'b0;
          end
        end
      end
      io_dataIn_valid = 1'b0;
    end
    io_dataIn_valid = 1'b0;
  endtask

  task automatic drive_weight_stream_jitter(input shortreal values[], input int seed);
    int idx, gap, burst, sent;
    localparam int BURST_MAX = 4;
    localparam int GAP_MAX   = 5;
    $srandom(seed);
    io_weightIn_valid = 1'b0;
    idx = 0;
    while (idx < DIM) begin
      gap = $urandom_range(0, GAP_MAX);
      repeat (gap) begin
        io_weightIn_valid = 1'b0;
        @(posedge clk);
      end
      burst = $urandom_range(1, BURST_MAX);
      sent  = 0;
      while (sent < burst && idx < DIM) begin
        if (!io_weightIn_valid) begin
          while (!io_weightIn_ready) begin
            @(posedge clk);
          end
          io_weightIn_payload_data = real_to_fp16(real'(values[idx]));
          io_weightIn_payload_keep = 2'b11;
          io_weightIn_payload_last = (idx == DIM - 1);
          io_weightIn_payload_user = 32'h0;
          io_weightIn_valid        = 1'b1;
        end
        @(posedge clk);
        if (io_weightIn_valid && io_weightIn_ready) begin
          idx++;
          sent++;
          if (sent < burst && idx < DIM) begin
            io_weightIn_payload_data = real_to_fp16(real'(values[idx]));
            io_weightIn_payload_keep = 2'b11;
            io_weightIn_payload_last = (idx == DIM - 1);
            io_weightIn_payload_user = 32'h0;
          end else begin
            io_weightIn_valid = 1'b0;
          end
        end
      end
      io_weightIn_valid = 1'b0;
    end
    io_weightIn_valid = 1'b0;
  endtask

  initial begin
    shortreal x[DIM];
    shortreal gamma[DIM];
    shortreal out[DIM];
    shortreal golden[DIM];
    real max_err;
    int out_cnt;
    int cycles;

    sim_cycle  = 0;
    hb_out_cnt = 0;
    io_dataIn_valid  = 0;
    io_weightIn_valid = 0;
    io_dataOut_ready = 1;
    $display("[tb] reset and stimulus (dim=%0d)", DIM);
    reset = 1'b1;
    repeat (5) @(posedge clk);
    reset = 1'b0;
    repeat (5) @(posedge clk);

    for (int i = 0; i < DIM; i++) begin
      x[i]     = shortreal'((i + 1) * 0.25);
      gamma[i] = shortreal'(0.5 + (i + 1) * 0.125);
    end
    golden_rmsnorm(x, gamma, EPS, golden);

    $display("[tb] FP16 encodings: x[0]=%h x[1]=%h gamma[0]=%h gamma[1]=%h",
             real_to_fp16(real'(x[0])), real_to_fp16(real'(x[1])),
             real_to_fp16(real'(gamma[0])), real_to_fp16(real'(gamma[1])));

    $display("[tb] driving %0d data + weight beats (jittered valid, parallel)", DIM);
    fork
      drive_data_stream_jitter(x, 32'h0000_0123, 32'h1234_5678);
      drive_weight_stream_jitter(gamma, 32'h9abc_def0);
    join
    $display("[tb] stimulus done — waiting for %0d output beats (max %0d cycles)", DIM, MAX_CYCLES);

    out_cnt = 0;
    cycles  = 0;
    while (out_cnt < DIM && cycles < MAX_CYCLES) begin
      @(posedge clk);
      cycles++;
      if (io_dataOut_valid && io_dataOut_ready) begin
        out[out_cnt] = fp16_to_shortreal(io_dataOut_payload_data);
        out_cnt++;
        hb_out_cnt = out_cnt;
      end
    end
    $display("[tb] collected %0d/%0d outputs in %0d cycles", out_cnt, DIM, cycles);

    if (out_cnt != DIM) begin
      $fatal(1, "timeout: expected %0d output beats, got %0d", DIM, out_cnt);
    end

    max_err = 0.0;
    for (int i = 0; i < DIM; i++) begin
      real err;
      err = abs_real(real'(out[i]) - real'(golden[i]));
      if (err > max_err) max_err = err;
    end

    $display("RmsNormAxiTop Questa dim=%0d max abs err vs float ref = %0.6f", DIM, max_err);
    if (max_err > 0.25) begin
      $fatal(1, "RMSNorm mismatch (threshold 0.25 for FP16+IP pipeline)");
    end
    $display("PASS");
    $finish;
  end

endmodule
