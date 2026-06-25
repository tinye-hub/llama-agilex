// Golden reference vectors + file I/O for step-by-step RTL comparison in Questa TB.
// Line format: <32-bit hex> <decimal>   (FP16 values use zero-extended 32-bit hex)

package rmsnorm_golden_ref_pkg;

  import rmsnorm_fp16_pkg::*;

  typedef struct {
    int    fd;
    int    expect_cnt;
    int    seen;
    string tag;
    bit    as_fp16;
  } golden_chk_t;

  function automatic void golden_write_ref_line(int fd, logic [31:0] bits, bit as_fp16 = 0);
    logic [31:0] hex_val;
    real         dec_val;
    begin
      if (as_fp16) begin
        hex_val = {16'h0, bits[15:0]};
        dec_val = f32_bits_to_real(fp16_to_f32_bits(bits[15:0]));
      end else begin
        hex_val = bits;
        dec_val = f32_bits_to_real(bits);
      end
      $fwrite(fd, "%08h %0.9f\n", hex_val, dec_val);
    end
  endfunction

  function automatic void golden_ensure_dir(input string dir);
    int    rc;
    string cmd;
    cmd = {"mkdir -p ", dir};
    rc = $system(cmd);
    if (rc != 0) begin
      $fatal(1, "golden_ref: cannot create directory %s (mkdir rc=%0d)", dir, rc);
    end
  endfunction

  function automatic void golden_write_sqr_trace_line(
    int           fd,
    int           step,
    logic [31:0]  in_bits,
    logic [31:0]  sq_bits,
    logic [31:0]  acc_bits
  );
    begin
      $fwrite(fd, "%4d in=%08h %0.9f sq=%08h %0.9f acc=%08h %0.9f\n",
              step,
              in_bits,  f32_bits_to_real(in_bits),
              sq_bits,  f32_bits_to_real(sq_bits),
              acc_bits, f32_bits_to_real(acc_bits));
    end
  endfunction

  function automatic int golden_open_write_file(input string dir, input string fname);
    string path;
    int    fd;
    path = {dir, "/", fname};
    fd = $fopen(path, "w");
    if (fd == 0) begin
      $fatal(1, "golden_ref: cannot open %s for write", path);
    end
    return fd;
  endfunction

  // Compute all stage references (same datapath as RmsNormCore) and write txt files.
  task automatic golden_write_refs(
    input  int        d,
    input  shortreal  x_in[],
    input  shortreal  gamma_in[],
    input  string     out_dir,
    output shortreal  y_out[],
    output logic [15:0] emit_fp16_out[]
  );
    int           scale_shift;
    logic [31:0]  acc, mean_sq, mean_eps, scale;
    logic [31:0]  collect_fp32[];
    logic [31:0]  emit_x_fp32[];
    logic [31:0]  emit_g_fp32[];
    logic [31:0]  emit_x_gamma[];
    logic [31:0]  emit_scaled[];
    logic [15:0]  emit_fp16[];
    int           fd;
    int           fd_sqr_in;
    int           fd_sqr_acc;
    int           fd_sqr_trace;
    begin
      golden_ensure_dir(out_dir);
      y_out = new[d];
      emit_fp16_out = new[d];
      collect_fp32 = new[d];
      emit_x_fp32  = new[d];
      emit_g_fp32  = new[d];
      emit_x_gamma = new[d];
      emit_scaled  = new[d];
      emit_fp16    = new[d];

      fd_sqr_in    = golden_open_write_file(out_dir, "sqr_sum_in.txt");
      fd_sqr_acc   = golden_open_write_file(out_dir, "sqr_sum_acc.txt");
      fd_sqr_trace = golden_open_write_file(out_dir, "sqr_sum_trace.txt");
      $fwrite(fd_sqr_trace, "# step in_hex in_dec sq_hex sq_dec acc_hex acc_dec\n");

      scale_shift = $clog2(d);
      acc = 32'h0;
      for (int i = 0; i < d; i++) begin
        logic [15:0] x_h;
        logic [31:0] x_f32, sq;
        x_h   = real_to_fp16(real'(x_in[i]));
        x_f32 = fp16_to_f32_bits(x_h);
        collect_fp32[i] = x_f32;
        sq    = f32_mul_bits(x_f32, x_f32);
        if (i == 0)
          acc = sq;
        else
          acc = f32_add_bits(acc, sq);
        golden_write_ref_line(fd_sqr_in, x_f32);
        golden_write_ref_line(fd_sqr_acc, acc);
        golden_write_sqr_trace_line(fd_sqr_trace, i, x_f32, sq, acc);
      end
      $fclose(fd_sqr_in);
      $fclose(fd_sqr_acc);
      $fclose(fd_sqr_trace);

      mean_sq  = fp32_scale_down(acc, scale_shift);
      mean_eps = f32_add_bits(mean_sq, FP32_EPS_RMSNORM);
      scale    = f32_rsqrt_bits(mean_eps);

      for (int i = 0; i < d; i++) begin
        logic [15:0] x_h, g_h;
        logic [31:0] x_f32, g_f32, xg, out_f32;
        x_h   = real_to_fp16(real'(x_in[i]));
        g_h   = real_to_fp16(real'(gamma_in[i]));
        x_f32 = fp16_to_f32_bits(x_h);
        g_f32 = fp16_to_f32_bits(g_h);
        emit_x_fp32[i]  = x_f32;
        emit_g_fp32[i]  = g_f32;
        xg              = f32_mul_bits(x_f32, g_f32);
        emit_x_gamma[i] = xg;
        out_f32         = f32_mul_bits(xg, scale);
        emit_scaled[i]  = out_f32;
        emit_fp16[i]    = f32_to_fp16(out_f32);
        emit_fp16_out[i] = emit_fp16[i];
        y_out[i]        = fp16_to_shortreal(emit_fp16[i]);
      end

      fd = golden_open_write_file(out_dir, "collect_fp32.txt");
      for (int i = 0; i < d; i++) golden_write_ref_line(fd, collect_fp32[i]);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "mean_square.txt");
      golden_write_ref_line(fd, mean_sq);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "mean_eps.txt");
      golden_write_ref_line(fd, mean_eps);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "scale_lock.txt");
      golden_write_ref_line(fd, scale);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "emit_x_fp32.txt");
      for (int i = 0; i < d; i++) golden_write_ref_line(fd, emit_x_fp32[i]);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "emit_gamma_fp32.txt");
      for (int i = 0; i < d; i++) golden_write_ref_line(fd, emit_g_fp32[i]);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "emit_x_gamma.txt");
      for (int i = 0; i < d; i++) golden_write_ref_line(fd, emit_x_gamma[i]);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "emit_scaled_fp32.txt");
      for (int i = 0; i < d; i++) golden_write_ref_line(fd, emit_scaled[i]);
      $fclose(fd);

      fd = golden_open_write_file(out_dir, "emit_fp16.txt");
      for (int i = 0; i < d; i++) golden_write_ref_line(fd, {16'h0, emit_fp16[i]}, 1'b1);
      $fclose(fd);

      $display("[golden_ref] wrote stage refs to %s/ (*.txt, %0d lines per vector stage)", out_dir, d);
      $display("[golden_ref] sqr_sum per-step trace: %s/sqr_sum_trace.txt (in + sq + acc x %0d)", out_dir, d);
    end
  endtask

  function automatic golden_chk_t golden_chk_open(
    input string dir,
    input string fname,
    input int    expect_cnt,
    input bit    as_fp16 = 0
  );
    string path;
    begin
      path = {dir, "/", fname};
      golden_chk_open.fd         = $fopen(path, "r");
      golden_chk_open.expect_cnt = expect_cnt;
      golden_chk_open.seen       = 0;
      golden_chk_open.tag        = fname;
      golden_chk_open.as_fp16    = as_fp16;
      if (golden_chk_open.fd == 0) begin
        $fatal(1, "golden_chk: cannot open %s for read", path);
      end
    end
  endfunction

  // Read one line from sqr_sum_trace.txt (0-based step index).
  task automatic golden_read_sqr_trace_step(
    input  string       dir,
    input  int          step,
    output int          step_out,
    output logic [31:0] in_bits,
    output logic [31:0] sq_bits,
    output logic [31:0] acc_bits
  );
    int    fd;
    int    i;
    int    n;
    string line;
    real   in_dec, sq_dec, acc_dec;
    begin
      step_out = -1;
      in_bits  = 32'h0;
      sq_bits  = 32'h0;
      acc_bits = 32'h0;
      fd = $fopen({dir, "/sqr_sum_trace.txt"}, "r");
      if (fd == 0) begin
        $display("golden_read_sqr_trace_step: cannot open %s/sqr_sum_trace.txt", dir);
        return;
      end
      void'($fgets(line, fd));
      for (i = 0; i < step; i++) void'($fgets(line, fd));
      n = $fscanf(fd, "%d in=%h %f sq=%h %f acc=%h %f",
                  step_out, in_bits, in_dec, sq_bits, sq_dec, acc_bits, acc_dec);
      $fclose(fd);
      if (n != 7) begin
        $display("golden_read_sqr_trace_step: parse failed step=%0d n=%0d", step, n);
      end
    end
  endtask

  // Compare MAC acc on each io_accOut_valid; dump full in/sq/acc context on first mismatch.
  task automatic golden_chk_sqr_acc_sample(
    ref    golden_chk_t chk,
    input  string       golden_dir,
    input  logic        acc_out_valid,
    input  logic [31:0] rtl_in,
    input  logic [31:0] rtl_acc
  );
    logic [31:0] exp_acc_hex;
    logic [31:0] g_in, g_sq, g_acc, g_prev_acc;
    logic [31:0] prev_in, prev_sq;
    logic [31:0] rtl_sq_est;
    int          step_out, prev_step, prev_step_out;
    real         exp_acc_real;
    int          n;
    begin
      if (!acc_out_valid) return;
      n = $fscanf(chk.fd, "%h %f", exp_acc_hex, exp_acc_real);
      if (n != 2) begin
        $fatal(1, "golden_chk [%s]: read failed at step %0d (fscanf=%0d)",
               chk.tag, chk.seen, n);
      end
      if (rtl_acc !== exp_acc_hex) begin
        golden_read_sqr_trace_step(golden_dir, chk.seen, step_out, g_in, g_sq, g_acc);
        prev_step = chk.seen - 1;
        if (prev_step >= 0) begin
          golden_read_sqr_trace_step(golden_dir, prev_step, prev_step_out,
                                     prev_in, prev_sq, g_prev_acc);
        end else begin
          g_prev_acc = 32'h0;
        end
        rtl_sq_est = real_to_f32_bits(
          f32_bits_to_real(rtl_in) * f32_bits_to_real(rtl_in));
        $display("");
        $display("=== FIRST sqr_sum acc mismatch @ dut.core.sqrSumIn_sqrSum_adp.io_accOut_valid step %0d ===",
                 chk.seen);
        $display("  MAC input (RTL, %0d-cycle aligned): hex=%08h dec=%0.9f",
                 5, rtl_in, f32_bits_to_real(rtl_in));
        $display("  MAC input (GOLDEN):                   hex=%08h dec=%0.9f",
                 g_in, f32_bits_to_real(g_in));
        $display("  x^2 this step (GOLDEN):               hex=%08h dec=%0.9f",
                 g_sq, f32_bits_to_real(g_sq));
        $display("  x^2 this step (RTL est f32):          hex=%08h dec=%0.9f",
                 rtl_sq_est, f32_bits_to_real(rtl_sq_est));
        if (prev_step >= 0) begin
          $display("  acc after step %0d (GOLDEN):          hex=%08h dec=%0.9f",
                   prev_step, g_prev_acc, f32_bits_to_real(g_prev_acc));
        end
        $display("  acc after step %0d (RTL):             hex=%08h dec=%0.9f",
                 chk.seen, rtl_acc, f32_bits_to_real(rtl_acc));
        $display("  acc after step %0d (GOLDEN):          hex=%08h dec=%0.9f",
                 chk.seen, exp_acc_hex, exp_acc_real);
        $display("  acc delta (RTL - GOLDEN):             %0.9f",
                 f32_bits_to_real(rtl_acc) - exp_acc_real);
        $display("  trace file: %s/sqr_sum_trace.txt", golden_dir);
        $display("");
        $fatal(1, "golden_chk [%s] first mismatch at io_accOut_valid step %0d", chk.tag, chk.seen);
      end
      chk.seen++;
    end
  endtask

  task automatic golden_chk_sample(
    ref    golden_chk_t chk,
    input  logic        sample,
    input  logic [31:0] rtl_bits
  );
    logic [31:0] exp_hex;
    logic [31:0] rtl_hex;
    real         exp_real;
    int          n;
    begin
      if (!sample) return;
      n = $fscanf(chk.fd, "%h %f", exp_hex, exp_real);
      if (n != 2) begin
        $fatal(1, "golden_chk [%s]: read failed at sample %0d (fscanf=%0d)",
               chk.tag, chk.seen, n);
      end
      if (chk.as_fp16)
        rtl_hex = {16'h0, rtl_bits[15:0]};
      else
        rtl_hex = rtl_bits;
      if (rtl_hex !== exp_hex) begin
        $display("MISMATCH [%s] step %0d:", chk.tag, chk.seen);
        $display("  RTL    hex=%08h  dec=%0.9f", rtl_hex,
                 chk.as_fp16 ? f32_bits_to_real(fp16_to_f32_bits(rtl_bits[15:0]))
                               : f32_bits_to_real(rtl_bits));
        $display("  GOLDEN hex=%08h  dec=%0.9f", exp_hex, exp_real);
        if (chk.tag == "sqr_sum_acc.txt") begin
          $display("  (see golden_refs/sqr_sum_trace.txt line %0d for input/sq/acc context)", chk.seen);
        end
        $fatal(1, "golden_chk [%s] step %0d", chk.tag, chk.seen);
      end
      chk.seen++;
    end
  endtask

  function automatic void golden_chk_finish(input golden_chk_t chk);
    if (chk.seen != chk.expect_cnt) begin
      $fatal(1, "golden_chk [%s]: expected %0d samples, saw %0d",
             chk.tag, chk.expect_cnt, chk.seen);
    end
    $display("[golden_chk] PASS %s (%0d samples)", chk.tag, chk.seen);
  endfunction

endpackage
