// Questa testbench for GemvService64: full INT4_G128 GEMV with real Altera FP IPs.
//
// Exercises the complete multiplier path in context (back-to-back rows):
//   actIn (FP16 x) + scale preload (FP16) -> Job start
//   -> tileFetch / weightBeat (256b INT4) behavioral DDR responder
//   -> Int4Unpack -> GemvMacBeat (FP16->FP32 mul, FP32 tree, per-tile scale,
//      FP32 per-row accumulate) -> FP16 qOut
//
// Generated DUT: GEMV_DIM=K, GEMV_MAX_ROWS=M (see Makefile). TB +define+GEMV_K / GEMV_M.

`timescale 1ns/1ps

import rmsnorm_fp16_pkg::*;

module tb_gemv_service64;

`ifdef GEMV_K
  localparam int K = `GEMV_K;
`elsif GEMV_DIM
  localparam int K = `GEMV_DIM;
`else
  localparam int K = 2048;
`endif
`ifdef GEMV_M
  localparam int M = `GEMV_M;
`elsif GEMV_QUESTA_M
  localparam int M = `GEMV_QUESTA_M;
`else
  localparam int M = 2048;
`endif
`ifdef GEMV_MAX_ROWS
  localparam int MAX_ROWS = `GEMV_MAX_ROWS;
`else
  localparam int MAX_ROWS = M;
`endif
  localparam int BANK     = 64;
  localparam int TILES    = K / BANK;
  localparam int GROUPS   = K / 128;
  localparam int TPG      = 128 / BANK;
  localparam int ROW_STRIDE = K / 2;
  localparam int TILE_STRIDE = BANK / 2;
  localparam int CLK_NS   = 10;
  localparam real TOL_ABS = 2.0e-2;
  localparam real TOL_REL = 1.0 / 64.0;
  localparam int MAX_CYCLES = (M * TILES + M) * 3000 + 50000;
  localparam int PROGRESS_ROW_STEP = 10;

  // FP16 encodings of integers -8..7 (matches Int4Unpack table).
  logic [15:0] INT_FP16 [16];
  initial begin
    INT_FP16[ 0]=16'hC800; INT_FP16[ 1]=16'hC700; INT_FP16[ 2]=16'hC600; INT_FP16[ 3]=16'hC500;
    INT_FP16[ 4]=16'hC400; INT_FP16[ 5]=16'hC200; INT_FP16[ 6]=16'hC000; INT_FP16[ 7]=16'hBC00;
    INT_FP16[ 8]=16'h0000; INT_FP16[ 9]=16'h3C00; INT_FP16[10]=16'h4000; INT_FP16[11]=16'h4200;
    INT_FP16[12]=16'h4400; INT_FP16[13]=16'h4500; INT_FP16[14]=16'h4600; INT_FP16[15]=16'h4700;
  end

  logic clk, reset;

  // ctrl
  logic [3:0]  io_ctrl_job_op, io_ctrl_job_layer;
  logic [16:0] io_ctrl_job_mRows, io_ctrl_job_kCols;
  logic [31:0] io_ctrl_job_wBase, io_ctrl_job_scaleBase;
  logic [2:0]  io_ctrl_job_weightFmt;
  logic [1:0]  io_ctrl_job_inputSrc;
  logic        io_ctrl_start, io_ctrl_done, io_ctrl_busy, io_ctrl_error;
  // actIn
  logic        io_actIn_valid, io_actIn_ready;
  logic [15:0] io_actIn_payload_data;
  logic [1:0]  io_actIn_payload_keep;
  logic        io_actIn_payload_last;
  logic [31:0] io_actIn_payload_user;
  // scaleLoad
  logic        io_scaleLoad_valid, io_scaleLoad_ready;
  logic [15:0] io_scaleLoad_payload;
  // weightBeat
  logic         io_weightBeat_valid, io_weightBeat_ready;
  logic [255:0] io_weightBeat_payload;
  // tileFetch
  logic        io_tileFetch_valid, io_tileFetch_ready;
  logic [31:0] io_tileFetch_payload_ddrAddr;
  logic [15:0] io_tileFetch_payload_byteLen;
  logic [7:0]  io_tileFetch_payload_reqTag;
  // qOut
  logic        io_qOut_valid, io_qOut_ready;
  logic [15:0] io_qOut_payload_data;
  logic [1:0]  io_qOut_payload_keep;
  logic        io_qOut_payload_last;
  logic [31:0] io_qOut_payload_user;
  logic        io_dbgOverflow;

  GemvService64 dut (
    .io_ctrl_job_op(io_ctrl_job_op), .io_ctrl_job_layer(io_ctrl_job_layer),
    .io_ctrl_job_mRows(io_ctrl_job_mRows), .io_ctrl_job_kCols(io_ctrl_job_kCols),
    .io_ctrl_job_wBase(io_ctrl_job_wBase), .io_ctrl_job_scaleBase(io_ctrl_job_scaleBase),
    .io_ctrl_job_weightFmt(io_ctrl_job_weightFmt), .io_ctrl_job_inputSrc(io_ctrl_job_inputSrc),
    .io_ctrl_start(io_ctrl_start), .io_ctrl_done(io_ctrl_done),
    .io_ctrl_busy(io_ctrl_busy), .io_ctrl_error(io_ctrl_error),
    .io_actIn_valid(io_actIn_valid), .io_actIn_ready(io_actIn_ready),
    .io_actIn_payload_data(io_actIn_payload_data), .io_actIn_payload_keep(io_actIn_payload_keep),
    .io_actIn_payload_last(io_actIn_payload_last), .io_actIn_payload_user(io_actIn_payload_user),
    .io_scaleLoad_valid(io_scaleLoad_valid), .io_scaleLoad_ready(io_scaleLoad_ready),
    .io_scaleLoad_payload(io_scaleLoad_payload),
    .io_weightBeat_valid(io_weightBeat_valid), .io_weightBeat_ready(io_weightBeat_ready),
    .io_weightBeat_payload(io_weightBeat_payload),
    .io_tileFetch_valid(io_tileFetch_valid), .io_tileFetch_ready(io_tileFetch_ready),
    .io_tileFetch_payload_ddrAddr(io_tileFetch_payload_ddrAddr),
    .io_tileFetch_payload_byteLen(io_tileFetch_payload_byteLen),
    .io_tileFetch_payload_reqTag(io_tileFetch_payload_reqTag),
    .io_qOut_valid(io_qOut_valid), .io_qOut_ready(io_qOut_ready),
    .io_qOut_payload_data(io_qOut_payload_data), .io_qOut_payload_keep(io_qOut_payload_keep),
    .io_qOut_payload_last(io_qOut_payload_last), .io_qOut_payload_user(io_qOut_payload_user),
    .io_dbgOverflow(io_dbgOverflow),
    .reset(reset), .clk(clk)
  );

  initial clk = 1'b0;
  always #(CLK_NS/2) clk = ~clk;

  // stimulus / reference
  logic [15:0] x_h   [K];
  logic [3:0]  w_nib [M][K];
  logic [15:0] sc_h  [M][GROUPS];
  logic [15:0] golden_fp16 [M];
  logic [15:0] recv_fp16   [M];
  int          recv_cnt;

  // First actIn beat -> last qOut beat (DUT in/out data span).
  time         gemv_t_first_in;
  time         gemv_t_last_out;
  bit          gemv_seen_first_in;

  int unsigned addrq[$];

  function automatic real rand_pm(input real mag);
    return (real'($urandom) / 4294967295.0) * (2.0 * mag) - mag;
  endfunction

  function automatic logic [31:0] tree_reduce(input logic [31:0] vals[BANK]);
    logic [31:0] node[BANK];
    int m;
    begin
      for (int i = 0; i < BANK; i++) node[i] = vals[i];
      m = BANK;
      while (m > 1) begin
        for (int i = 0; i < m/2; i++) node[i] = f32_add_bits(node[2*i], node[2*i+1]);
        if (m % 2 == 1) node[m/2] = node[m-1];
        m = (m + 1) / 2;
      end
      return node[0];
    end
  endfunction

  task automatic compute_golden();
    for (int r = 0; r < M; r++) begin
      logic [31:0] acc;
      acc = 32'h0;
      for (int t = 0; t < TILES; t++) begin
        logic [31:0] prod[BANK];
        logic [31:0] tile_sum, tile_scaled, scale_f32;
        for (int j = 0; j < BANK; j++) begin
          logic [15:0] wfp16;
          wfp16   = INT_FP16[w_nib[r][t*BANK + j]];
          prod[j] = f32_mul_bits(fp16_to_f32_bits(x_h[t*BANK + j]),
                                 fp16_to_f32_bits(wfp16));
        end
        tile_sum    = tree_reduce(prod);
        scale_f32   = fp16_to_f32_bits(sc_h[r][t / TPG]);
        tile_scaled = f32_mul_bits(tile_sum, scale_f32);
        acc         = f32_add_bits(acc, tile_scaled);
      end
      golden_fp16[r] = f32_to_fp16(acc);
    end
  endtask

  // weight beat for (m,t): 64 nibbles packed, nibble j at bits [j*4 +: 4]
  function automatic logic [255:0] pack_tile(input int r, input int t);
    logic [255:0] w;
    begin
      w = '0;
      for (int j = 0; j < BANK; j++)
        w[j*4 +: 4] = w_nib[r][t*BANK + j];
      return w;
    end
  endfunction

  // capture tileFetch requests
  always @(posedge clk) begin
    if (!reset && io_tileFetch_valid && io_tileFetch_ready)
      addrq.push_back(io_tileFetch_payload_ddrAddr);
  end

  // behavioral DDR weight responder (decode addr -> tile data)
  initial begin
    io_weightBeat_valid = 1'b0;
    io_weightBeat_payload = '0;
    forever begin
      if (addrq.size() > 0) begin
        int unsigned addr; int r, t;
        addr = addrq.pop_front();
        r = addr / ROW_STRIDE;
        t = (addr % ROW_STRIDE) / TILE_STRIDE;
        io_weightBeat_payload = pack_tile(r, t);
        io_weightBeat_valid   = 1'b1;
        do @(posedge clk); while (!io_weightBeat_ready);
        io_weightBeat_valid = 1'b0;
      end else begin
        @(posedge clk);
      end
    end
  end

  // qOut collector
  initial begin
    recv_cnt = 0;
    forever begin
      @(posedge clk);
      if (!reset && io_qOut_valid && io_qOut_ready) begin
        if (recv_cnt < M) begin
          int row_done;
          recv_fp16[recv_cnt] = io_qOut_payload_data;
          row_done = recv_cnt + 1;
          if (row_done % PROGRESS_ROW_STEP == 0 || row_done == M)
            $display("[tb] progress: row %0d/%0d qOut @ %0t ns", row_done, M, $time);
          if (row_done == M)
            gemv_t_last_out = $time;
        end
        recv_cnt++;
      end
    end
  end

  // overflow watchdog
  always @(posedge clk) if (!reset && io_dbgOverflow) $fatal(1, "qOut FIFO overflow");

  task automatic drive_actin();
    io_actIn_valid = 1'b0;
    for (int k = 0; k < K; k++) begin
      io_actIn_payload_data = x_h[k];
      io_actIn_payload_keep = 2'b11;
      io_actIn_payload_last = (k == K-1);
      io_actIn_payload_user = '0;
      io_actIn_valid        = 1'b1;
      do @(posedge clk); while (!io_actIn_ready);
      if (!gemv_seen_first_in) begin
        gemv_t_first_in    = $time;
        gemv_seen_first_in = 1'b1;
      end
    end
    io_actIn_valid = 1'b0;
  endtask

  task automatic drive_scales();
    io_scaleLoad_valid = 1'b0;
    for (int r = 0; r < M; r++)
      for (int g = 0; g < GROUPS; g++) begin
        io_scaleLoad_payload = sc_h[r][g];
        io_scaleLoad_valid   = 1'b1;
        do @(posedge clk); while (!io_scaleLoad_ready);
      end
    io_scaleLoad_valid = 1'b0;
  endtask

  initial begin
    real max_err;
    int  mismatches, cycles;

    if (M > MAX_ROWS)
      $fatal(1, "GEMV_M=%0d exceeds DUT maxRows=%0d — raise M", M, MAX_ROWS);
    if (K % 64 != 0 || K % 128 != 0)
      $fatal(1, "GEMV_K=%0d must be divisible by 64 and 128", K);

    gemv_seen_first_in = 1'b0;
    gemv_t_first_in    = 0;
    gemv_t_last_out    = 0;

    io_ctrl_start = 0;
    io_actIn_valid = 0; io_scaleLoad_valid = 0;
    io_tileFetch_ready = 1'b1;
    io_qOut_ready = 1'b1;
    io_ctrl_job_op = 0; io_ctrl_job_layer = 0;
    io_ctrl_job_mRows = M; io_ctrl_job_kCols = K;
    io_ctrl_job_wBase = 0; io_ctrl_job_scaleBase = 0;
    io_ctrl_job_weightFmt = 0; io_ctrl_job_inputSrc = 0;

    $srandom(32'hBEEF_2026);
    for (int k = 0; k < K; k++) x_h[k] = real_to_fp16(rand_pm(1.0));
    for (int r = 0; r < M; r++) begin
      for (int g = 0; g < GROUPS; g++) sc_h[r][g] = real_to_fp16(0.02 + (real'($urandom)/4294967295.0)*0.08);
      for (int k = 0; k < K; k++)      w_nib[r][k] = $urandom_range(0, 15);
    end

    compute_golden();

    reset = 1'b1;
    repeat (5) @(posedge clk);
    reset = 1'b0;
    repeat (3) @(posedge clk);

    $display("[tb] load act (%0d) + scales (%0d)", K, M*GROUPS);
    drive_actin();
    drive_scales();
    repeat (2) @(posedge clk);

    $display("[tb] start Job (M=%0d K=%0d)", M, K);
    io_ctrl_start = 1'b1;
    @(posedge clk);
    io_ctrl_start = 1'b0;

    cycles = 0;
    while (recv_cnt < M && cycles < MAX_CYCLES) begin
      @(posedge clk);
      cycles++;
    end
    repeat (4) @(posedge clk);

    if (recv_cnt < M)
      $fatal(1, "timeout: expected %0d qOut beats, got %0d (cycles=%0d max=%0d)",
             M, recv_cnt, cycles, MAX_CYCLES);

    if (gemv_seen_first_in && gemv_t_last_out >= gemv_t_first_in) begin
      time elapsed_ns;
      elapsed_ns = gemv_t_last_out - gemv_t_first_in;
      $display("[tb] DUT data span: first actIn @ %0t ns -> last qOut @ %0t ns",
               gemv_t_first_in, gemv_t_last_out);
      $display("[tb] elapsed %0.3f us (%0d clk cycles @ %0d ns)",
               elapsed_ns / 1000.0, elapsed_ns / CLK_NS, CLK_NS);
    end else begin
      $display("[tb] WARNING: DUT data span timestamps missing (first_in=%0d last_out=%0d)",
               gemv_seen_first_in, gemv_t_last_out);
    end

    max_err = 0.0; mismatches = 0;
    for (int r = 0; r < M; r++) begin
      real rr, rg, err, thr;
      bit agree;
      err = fp16_abs_err(recv_fp16[r], golden_fp16[r], TOL_ABS, agree);
      rg  = real'(fp16_to_shortreal(golden_fp16[r]));
      rr  = real'(fp16_to_shortreal(recv_fp16[r]));
      thr = TOL_ABS;
      if ((rg >= 0.0 ? rg : -rg) * TOL_REL > thr) thr = (rg >= 0.0 ? rg : -rg) * TOL_REL;
      agree = (err <= thr);
      if (err > max_err) max_err = err;
      if (!agree) begin
        $display("  mismatch[row %0d]: recv=%h (%0.6g) golden=%h (%0.6g) err=%0.6g thr=%0.6g",
                 r, recv_fp16[r], rr, golden_fp16[r], rg, err, thr);
        mismatches++;
      end
    end

    $display("GemvService64 Questa: M=%0d K=%0d (INT4_G128 GEMV)", M, K);
    $display("  max abs err: %0.8f   mismatches: %0d / %0d", max_err, mismatches, M);
    if (mismatches == 0) begin
      $display("\033[32m********** PASS **********\033[0m");
    end else begin
      $display("\033[31m********** FAIL **********\033[0m");
    end
    #1;
    if (mismatches != 0)
      $fatal(1, "FAIL: %0d/%0d row mismatches", mismatches, M);
    $finish;
  end

endmodule
