// Questa testbench for GemvMacBeat + real Altera FP IPs.
//
// Validates the FP datapath the user asked for: FP16 operands -> FP32 (fp16ToFp32)
// -> FP32 multiply (fp32MultAcc) -> FP32 balanced adder tree (fp32Add) -> FP32
// per-row serial accumulate -> FP16 output (fp32ToFp16).
//
// Rows are driven with an inter-row idle gap so the native-FP-DSP accumulator's
// first/last boundary settles between rows (the back-to-back boundary is an
// engine-level concern handled by GemvService64 / the tile fetch spacing).

`timescale 1ns/1ps

import rmsnorm_fp16_pkg::*;

module tb_gemv_mac_beat;

  localparam int BANK_LEN = 64;
  localparam int TILES    = 4;    // K-tiles per row (TILES*64 = K)
  localparam int ROWS     = 4;
`ifdef ROW_GAP_OVR
  localparam int ROW_GAP  = `ROW_GAP_OVR;
`else
  localparam int ROW_GAP  = 16;   // idle cycles between rows (>= acc latency)
`endif
  localparam int CLK_NS   = 10;
  localparam real TOL_ABS = 2.0e-2;
  localparam real TOL_REL = 1.0 / 128.0;
  localparam int MAX_CYCLES = (TILES + ROW_GAP + 64) * ROWS + 2000;
  localparam logic [31:0] SCALE_ONE = 32'h3F80_0000; // 1.0

  logic clk;
  logic reset;

  logic              io_beatValid;
  logic [1023:0]     io_xWide;
  logic [1023:0]     io_wWide;
  logic [31:0]       io_scaleFp32;
  logic              io_beatLast;
  logic              io_rowOut_valid;
  logic [15:0]       io_rowOut_payload;

  GemvMacBeat dut (
    .io_beatValid       (io_beatValid),
    .io_xWide           (io_xWide),
    .io_wWide           (io_wWide),
    .io_scaleFp32       (io_scaleFp32),
    .io_beatLast        (io_beatLast),
    .io_rowOut_valid    (io_rowOut_valid),
    .io_rowOut_payload  (io_rowOut_payload),
    .clk                (clk),
    .reset              (reset)
  );

  initial clk = 1'b0;
  always #(CLK_NS / 2) clk = ~clk;

  // stimulus storage
  logic [15:0] x_h [ROWS][TILES][BANK_LEN];
  logic [15:0] w_h [ROWS][TILES][BANK_LEN];
  logic [15:0] golden_fp16 [ROWS];
  logic [15:0] recv_fp16   [ROWS];
  int          recv_cnt;

  function automatic real rand_pm(input real mag);
    return (real'($urandom) / 4294967295.0) * (2.0 * mag) - mag;
  endfunction

  // balanced pairwise FP32 reduction matching GemvMacBeat.reduceTree
  function automatic logic [31:0] tree_reduce(input logic [31:0] vals[BANK_LEN]);
    logic [31:0] node[BANK_LEN];
    int m;
    begin
      for (int i = 0; i < BANK_LEN; i++) node[i] = vals[i];
      m = BANK_LEN;
      while (m > 1) begin
        for (int i = 0; i < m / 2; i++)
          node[i] = f32_add_bits(node[2*i], node[2*i+1]);
        if (m % 2 == 1) node[m/2] = node[m-1];
        m = (m + 1) / 2;
      end
      return node[0];
    end
  endfunction

  task automatic compute_golden();
    for (int r = 0; r < ROWS; r++) begin
      logic [31:0] acc;
      acc = 32'h0;
      for (int t = 0; t < TILES; t++) begin
        logic [31:0] prod[BANK_LEN];
        logic [31:0] tile_sum, tile_scaled;
        for (int j = 0; j < BANK_LEN; j++) begin
          prod[j] = f32_mul_bits(fp16_to_f32_bits(x_h[r][t][j]),
                                 fp16_to_f32_bits(w_h[r][t][j]));
        end
        tile_sum    = tree_reduce(prod);
        tile_scaled = f32_mul_bits(tile_sum, SCALE_ONE);
        acc         = f32_add_bits(acc, tile_scaled);
      end
      golden_fp16[r] = f32_to_fp16(acc);
    end
  endtask

  // drive one tile beat
  task automatic drive_beat(input int r, input int t);
    logic [1023:0] xw, ww;
    begin
      xw = '0;
      ww = '0;
      for (int j = 0; j < BANK_LEN; j++) begin
        xw[j*16 +: 16] = x_h[r][t][j];
        ww[j*16 +: 16] = w_h[r][t][j];
      end
      io_xWide     = xw;
      io_wWide     = ww;
      io_scaleFp32 = SCALE_ONE;
      io_beatLast  = (t == TILES - 1);
      io_beatValid = 1'b1;
      @(posedge clk);
      io_beatValid = 1'b0;
      io_beatLast  = 1'b0;
    end
  endtask

  // background collector
  initial begin
    recv_cnt = 0;
    forever begin
      @(posedge clk);
      if (!reset && io_rowOut_valid) begin
        if (recv_cnt < ROWS) recv_fp16[recv_cnt] = io_rowOut_payload;
        recv_cnt++;
      end
    end
  end

  initial begin
    real max_err;
    int  mismatches;
    int  cycles;

    io_beatValid = 1'b0;
    io_beatLast  = 1'b0;
    io_xWide     = '0;
    io_wWide     = '0;
    io_scaleFp32 = SCALE_ONE;

    $srandom(32'hA5A5_1234);
    for (int r = 0; r < ROWS; r++)
      for (int t = 0; t < TILES; t++)
        for (int j = 0; j < BANK_LEN; j++) begin
          x_h[r][t][j] = real_to_fp16(rand_pm(0.5));
          w_h[r][t][j] = real_to_fp16(rand_pm(0.5));
        end

    compute_golden();

    reset = 1'b1;
    repeat (5) @(posedge clk);
    reset = 1'b0;
    repeat (3) @(posedge clk);

    $display("[tb] driving %0d rows x %0d tiles (bank=%0d), gap=%0d", ROWS, TILES, BANK_LEN, ROW_GAP);
    for (int r = 0; r < ROWS; r++) begin
      for (int t = 0; t < TILES; t++) drive_beat(r, t);
      repeat (ROW_GAP) @(posedge clk);
    end

    // wait for all results to drain
    cycles = 0;
    while (recv_cnt < ROWS && cycles < MAX_CYCLES) begin
      @(posedge clk);
      cycles++;
    end

    if (recv_cnt != ROWS) begin
      $fatal(1, "timeout: expected %0d row results, got %0d", ROWS, recv_cnt);
    end

    max_err    = 0.0;
    mismatches = 0;
    for (int r = 0; r < ROWS; r++) begin
      real rr, rg, err, thr;
      bit  agree;
      err = fp16_abs_err(recv_fp16[r], golden_fp16[r], TOL_ABS, agree);
      rg  = real'(fp16_to_shortreal(golden_fp16[r]));
      rr  = real'(fp16_to_shortreal(recv_fp16[r]));
      thr = TOL_ABS;
      if ((rg >= 0.0 ? rg : -rg) * TOL_REL > thr) thr = (rg >= 0.0 ? rg : -rg) * TOL_REL;
      agree = (err <= thr);
      if (err > max_err) max_err = err;
      if (!agree) begin
        if (mismatches < 8)
          $display("  mismatch[row %0d]: recv=%h (%0.6g) golden=%h (%0.6g) err=%0.6g thr=%0.6g",
                   r, recv_fp16[r], rr, golden_fp16[r], rg, err, thr);
        mismatches++;
      end else begin
        $display("  row %0d: recv=%h (%0.6g) golden=%h (%0.6g) err=%0.6g OK",
                 r, recv_fp16[r], rr, golden_fp16[r], rg, err);
      end
    end

    $display("GemvMacBeat Questa: rows=%0d tiles=%0d", ROWS, TILES);
    $display("  max abs err: %0.8f   mismatches: %0d / %0d", max_err, mismatches, ROWS);
    if (mismatches == 0) begin
      $display("\033[32m********** PASS **********\033[0m");
      $finish;
    end else begin
      $display("\033[31m********** FAIL **********\033[0m");
      $fatal(1, "FAIL: %0d/%0d row mismatches", mismatches, ROWS);
    end
  end

endmodule
