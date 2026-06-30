// Questa testbench for SerialRoPEAxiTop + Altera FP IPs.
//
// Golden vectors: test/questa/golden_refs/ (from tools/rope_golden/gen_rope_tables.py)

`timescale 1ns/1ps

import rmsnorm_fp16_pkg::*;

module tb_serial_rope_axi;

`ifdef ROPE_HEAD_DIM
  localparam int HEAD_DIM = `ROPE_HEAD_DIM;
`else
  localparam int HEAD_DIM = 64;
`endif
`ifdef ROPE_MAX_POS
  localparam int MAX_POS = `ROPE_MAX_POS;
`else
  localparam int MAX_POS = 1024;
`endif
  localparam int CLK_NS = 10;
  localparam real TOL_ABS = 2.0e-2;
  localparam real TOL_REL = 1.0 / 64.0;
  localparam int MAX_CYCLES = HEAD_DIM * 500 + 50000;
  localparam string GOLDEN_DIR = "golden_refs";

  logic clk, reset;
  logic [9:0] io_seqPos;

  logic        io_dataIn_valid, io_dataIn_ready;
  logic [15:0] io_dataIn_payload_data;
  logic [1:0]  io_dataIn_payload_keep;
  logic        io_dataIn_payload_last;
  logic [31:0] io_dataIn_payload_user;

  logic        io_dataOut_valid, io_dataOut_ready;
  logic [15:0] io_dataOut_payload_data;
  logic [1:0]  io_dataOut_payload_keep;
  logic        io_dataOut_payload_last;
  logic [31:0] io_dataOut_payload_user;

  SerialRoPEAxiTop dut (
    .io_seqPos(io_seqPos),
    .io_dataIn_valid(io_dataIn_valid),
    .io_dataIn_ready(io_dataIn_ready),
    .io_dataIn_payload_data(io_dataIn_payload_data),
    .io_dataIn_payload_keep(io_dataIn_payload_keep),
    .io_dataIn_payload_last(io_dataIn_payload_last),
    .io_dataIn_payload_user(io_dataIn_payload_user),
    .io_dataOut_valid(io_dataOut_valid),
    .io_dataOut_ready(io_dataOut_ready),
    .io_dataOut_payload_data(io_dataOut_payload_data),
    .io_dataOut_payload_keep(io_dataOut_payload_keep),
    .io_dataOut_payload_last(io_dataOut_payload_last),
    .io_dataOut_payload_user(io_dataOut_payload_user),
    .clk(clk),
    .reset(reset)
  );

  initial clk = 1'b0;
  always #(CLK_NS/2) clk = ~clk;

  logic [15:0] x_in   [HEAD_DIM];
  logic [15:0] y_exp  [HEAD_DIM];
  logic [15:0] y_out  [HEAD_DIM];
  int          out_cnt;
  int          pos_val;
  int          errors;
  int          timeout;

  function automatic int read_meta_pos();
    int fd, ch, val, sign;
    begin
      fd = $fopen({GOLDEN_DIR, "/meta.txt"}, "r");
      if (fd == 0) begin
        $display("FAIL: cannot open %s/meta.txt", GOLDEN_DIR);
        $finish(1);
      end
      void'($fscanf(fd, "pos=%d", val));
      $fclose(fd);
      read_meta_pos = val;
    end
  endfunction

  task automatic load_hex_vec(input string fname, output logic [15:0] vec[HEAD_DIM]);
    int fd, d, code;
    reg [1023:0] line;
    begin
      fd = $fopen(fname, "r");
      if (fd == 0) begin
        $display("FAIL: cannot open %s", fname);
        $finish(1);
      end
      for (d = 0; d < HEAD_DIM; d++) begin
        code = $fgets(line, fd);
        if (code == 0) begin
          $display("FAIL: short file %s at line %0d", fname, d);
          $finish(1);
        end
        void'($sscanf(line, "%h", vec[d]));
      end
      $fclose(fd);
    end
  endtask

  task automatic drive_vector();
    int d;
    begin
      for (d = 0; d < HEAD_DIM; d++) begin
        @(posedge clk);
        while (!io_dataIn_ready) @(posedge clk);
        io_dataIn_valid              = 1'b1;
        io_dataIn_payload_data       = x_in[d];
        io_dataIn_payload_keep       = 2'b11;
        io_dataIn_payload_last       = (d == HEAD_DIM - 1);
        io_dataIn_payload_user       = 32'h0000_00A5;
        @(posedge clk);
        io_dataIn_valid              = 1'b0;
      end
    end
  endtask

  task automatic collect_outputs();
    begin
      out_cnt = 0;
      while (out_cnt < HEAD_DIM) begin
        @(posedge clk);
        timeout++;
        if (timeout > MAX_CYCLES) begin
          $display("FAIL: timeout waiting for output beat %0d", out_cnt);
          $finish(1);
        end
        if (io_dataOut_valid && io_dataOut_ready) begin
          y_out[out_cnt] = io_dataOut_payload_data;
          out_cnt++;
        end
      end
    end
  endtask

  initial begin
    io_dataIn_valid  = 1'b0;
    io_dataOut_ready = 1'b1;
    io_seqPos        = '0;
    reset            = 1'b1;
    errors           = 0;
    timeout          = 0;
    repeat (4) @(posedge clk);
    reset = 1'b0;
    repeat (8) @(posedge clk);

    pos_val = read_meta_pos();
    if (pos_val >= MAX_POS) begin
      $display("FAIL: golden pos=%0d exceeds MAX_POS=%0d", pos_val, MAX_POS);
      $finish(1);
    end
    io_seqPos = pos_val[9:0];

    load_hex_vec({GOLDEN_DIR, "/input_x.txt"}, x_in);
    load_hex_vec({GOLDEN_DIR, "/expected_y.txt"}, y_exp);

    fork
      drive_vector();
      collect_outputs();
    join

    for (int d = 0; d < HEAD_DIM; d++) begin
      real got, exp, diff, tol;
      got  = fp16_to_shortreal(y_out[d]);
      exp  = fp16_to_shortreal(y_exp[d]);
      diff = got > exp ? got - exp : exp - got;
      tol  = TOL_ABS + TOL_REL * (exp > 0 ? exp : -exp);
      if (diff > tol) begin
        errors++;
        if (errors <= 8)
          $display("MISMATCH d=%0d got=%0.6f exp=%0.6f diff=%0.6f", d, got, exp, diff);
      end
    end

    if (errors == 0) begin
      $display("\033[32m********** PASS **********\033[0m");
      $display("SerialRoPE head_dim=%0d pos=%0d — %0d beats OK", HEAD_DIM, pos_val, HEAD_DIM);
    end else begin
      $display("\033[31m********** FAIL **********\033[0m");
      $display("SerialRoPE — %0d mismatches (tol abs=%0.3f rel=%0.4f)", errors, TOL_ABS, TOL_REL);
      $finish(1);
    end
    $finish(0);
  end

endmodule
