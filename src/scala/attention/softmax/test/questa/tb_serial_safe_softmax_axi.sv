// Questa testbench for SerialSafeSoftmaxAxiTop + Altera FP IPs.
//
// Golden vectors: test/questa/golden_refs/len<N>/ (from tools/attention_golden/gen_softmax_refs.py)

`timescale 1ns/1ps

import rmsnorm_fp16_pkg::*;

module tb_serial_safe_softmax_axi;

  localparam int MAX_LEN   = 128;
  localparam int CLK_NS    = 10;
  localparam real TOL_ABS  = 5.0e-2;
  localparam real TOL_REL  = 1.0 / 32.0;
  localparam int MAX_CYCLES = 500000;
  localparam string GOLDEN_DIR = "golden_refs";

  logic clk, reset;

  logic        io_scoresIn_valid, io_scoresIn_ready;
  logic [15:0] io_scoresIn_payload_data;
  logic [1:0]  io_scoresIn_payload_keep;
  logic        io_scoresIn_payload_last;
  logic [31:0] io_scoresIn_payload_user;

  logic        io_weightsOut_valid, io_weightsOut_ready;
  logic [15:0] io_weightsOut_payload_data;
  logic [1:0]  io_weightsOut_payload_keep;
  logic        io_weightsOut_payload_last;
  logic [31:0] io_weightsOut_payload_user;

  SerialSafeSoftmaxAxiTop dut (
    .io_scoresIn_valid(io_scoresIn_valid),
    .io_scoresIn_ready(io_scoresIn_ready),
    .io_scoresIn_payload_data(io_scoresIn_payload_data),
    .io_scoresIn_payload_keep(io_scoresIn_payload_keep),
    .io_scoresIn_payload_last(io_scoresIn_payload_last),
    .io_scoresIn_payload_user(io_scoresIn_payload_user),
    .io_weightsOut_valid(io_weightsOut_valid),
    .io_weightsOut_ready(io_weightsOut_ready),
    .io_weightsOut_payload_data(io_weightsOut_payload_data),
    .io_weightsOut_payload_keep(io_weightsOut_payload_keep),
    .io_weightsOut_payload_last(io_weightsOut_payload_last),
    .io_weightsOut_payload_user(io_weightsOut_payload_user),
    .clk(clk),
    .reset(reset)
  );

  initial clk = 1'b0;
  always #(CLK_NS/2) clk = ~clk;

  logic [15:0] scores_in  [MAX_LEN];
  logic [15:0] weights_exp[MAX_LEN];
  logic [15:0] weights_out[MAX_LEN];
  int          vec_len;
  int          user_val;
  int          out_cnt;
  int          errors;
  int          timeout;

  function automatic int read_meta_len();
    int fd, val;
    begin
      fd = $fopen({GOLDEN_DIR, "/meta.txt"}, "r");
      if (fd == 0) begin
        $display("FAIL: cannot open %s/meta.txt", GOLDEN_DIR);
        $finish(1);
      end
      void'($fscanf(fd, "len=%d", val));
      $fclose(fd);
      read_meta_len = val;
    end
  endfunction

  function automatic int read_meta_user();
    int fd, val;
    begin
      fd = $fopen({GOLDEN_DIR, "/meta.txt"}, "r");
      if (fd == 0) begin
        $display("FAIL: cannot open %s/meta.txt", GOLDEN_DIR);
        $finish(1);
      end
      void'($fscanf(fd, "user=0x%x", val));
      $fclose(fd);
      read_meta_user = val;
    end
  endfunction

  task automatic load_hex_vec(input string fname, input int n, output logic [15:0] vec[MAX_LEN]);
    int fd, d, code;
    reg [1023:0] line;
    begin
      fd = $fopen(fname, "r");
      if (fd == 0) begin
        $display("FAIL: cannot open %s", fname);
        $finish(1);
      end
      for (d = 0; d < n; d++) begin
        code = $fgets(line, fd);
        if (code == 0) begin
          $display("FAIL: short file %s at line %0d (need %0d)", fname, d, n);
          $finish(1);
        end
        void'($sscanf(line, "%h", vec[d]));
      end
      $fclose(fd);
    end
  endtask

  task automatic drive_scores();
    int i;
    begin
      for (i = 0; i < vec_len; i++) begin
        @(posedge clk);
        while (!io_scoresIn_ready) @(posedge clk);
        io_scoresIn_valid              = 1'b1;
        io_scoresIn_payload_data       = scores_in[i];
        io_scoresIn_payload_keep       = 2'b11;
        io_scoresIn_payload_last       = (i == vec_len - 1);
        io_scoresIn_payload_user       = {17'b0, user_val[14:0]};
        @(posedge clk);
        io_scoresIn_valid              = 1'b0;
      end
    end
  endtask

  task automatic collect_weights();
    begin
      out_cnt = 0;
      while (out_cnt < vec_len) begin
        @(posedge clk);
        timeout++;
        if (timeout > MAX_CYCLES) begin
          $display("FAIL: timeout waiting for output beat %0d / %0d", out_cnt, vec_len);
          $finish(1);
        end
        if (io_weightsOut_valid && io_weightsOut_ready) begin
          if (io_weightsOut_payload_last != (out_cnt == vec_len - 1)) begin
            $display("FAIL: unexpected tlast at out beat %0d", out_cnt);
            $finish(1);
          end
          weights_out[out_cnt] = io_weightsOut_payload_data;
          out_cnt++;
        end
      end
    end
  endtask

  initial begin
    io_scoresIn_valid   = 1'b0;
    io_weightsOut_ready = 1'b1;
    reset               = 1'b1;
    errors              = 0;
    timeout             = 0;
    repeat (4) @(posedge clk);
    reset = 1'b0;
    repeat (8) @(posedge clk);

    vec_len  = read_meta_len();
    user_val = read_meta_user();
    if (vec_len < 1 || vec_len > MAX_LEN) begin
      $display("FAIL: golden len=%0d out of TB range 1..%0d", vec_len, MAX_LEN);
      $finish(1);
    end

    load_hex_vec({GOLDEN_DIR, "/input_scores.txt"}, vec_len, scores_in);
    load_hex_vec({GOLDEN_DIR, "/expected_weights.txt"}, vec_len, weights_exp);

    fork
      drive_scores();
      collect_weights();
    join

    for (int i = 0; i < vec_len; i++) begin
      real got, exp, diff, tol;
      got  = fp16_to_shortreal(weights_out[i]);
      exp  = fp16_to_shortreal(weights_exp[i]);
      diff = got > exp ? got - exp : exp - got;
      tol  = TOL_ABS + TOL_REL * (exp > 0 ? exp : -exp);
      if (diff > tol) begin
        errors++;
        if (errors <= 8)
          $display("MISMATCH i=%0d got=%0.6f exp=%0.6f diff=%0.6f", i, got, exp, diff);
      end
    end

    if (errors == 0) begin
      $display("\033[32m********** PASS **********\033[0m");
      $display("SerialSafeSoftmax len=%0d user=0x%04x — %0d beats OK", vec_len, user_val, vec_len);
    end else begin
      $display("\033[31m********** FAIL **********\033[0m");
      $display("SerialSafeSoftmax — %0d mismatches (tol abs=%0.3f rel=%0.4f)", errors, TOL_ABS, TOL_REL);
      $finish(1);
    end
    $finish(0);
  end

endmodule
