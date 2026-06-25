// FP16 helpers for Questa TBs. Matches rmsNorm.Fp16Sim (software float32 -> IEEE754 half).
// Questa $shortrealtobits() often returns 16'h0000; do not use it for stimulus.

package rmsnorm_fp16_pkg;

  function automatic logic [15:0] f32_to_fp16(input logic [31:0] bits);
    logic        sign;
    logic [7:0]  exp;
    logic [22:0] mant;
    logic [4:0]  new_exp;
    logic [9:0]  new_mant;
    begin
      sign = bits[31];
      exp  = bits[30:23];
      mant = bits[22:0];
      if (exp == 8'hff) begin
        f32_to_fp16 = {sign, 5'h1f, mant[22:13]};
      end else if (exp == 8'h00) begin
        f32_to_fp16 = {sign, 15'h0};
      end else begin
        new_exp = exp - 127 + 15;
        if (new_exp >= 31) begin
          f32_to_fp16 = {sign, 5'h1f, 10'h0};
        end else if (new_exp <= 0) begin
          f32_to_fp16 = {sign, 15'h0};
        end else begin
          new_mant = mant >> 13;
          f32_to_fp16 = {sign, new_exp[4:0], new_mant[9:0]};
        end
      end
    end
  endfunction

  // real is 64-bit IEEE in Questa; round to binary32 then pack to FP16.
  function automatic logic [31:0] real_to_f32_bits(input real val);
    bit [63:0] d;
    logic      sign;
    int        exp_d;
    logic [51:0] mant_d;
    logic [22:0] mant_f;
    int        exp_f;
    logic [31:0] bits;
    begin
      if (val == 0.0) return 32'h0;
      d      = $realtobits(val);
      sign   = d[63];
      exp_d  = int'(d[62:52]);
      mant_d = d[51:0];
      if (exp_d == 0) return 32'h0;
      if (exp_d >= 2047) return {sign, 8'hff, 23'h0};
      exp_f = exp_d - 1023 + 127;
      mant_f = mant_d[51:29];
      if (mant_d[28]) mant_f = mant_f + 1;
      if (mant_f[23]) begin
        mant_f = mant_f & 23'h7fffff;
        exp_f  = exp_f + 1;
      end
      if (exp_f >= 255) return {sign, 8'hff, 23'h0};
      if (exp_f <= 0) return {sign, 31'h0};
      bits = {sign, exp_f[7:0], mant_f[22:0]};
      return bits;
    end
  endfunction

  function automatic logic [15:0] real_to_fp16(input real val);
    return f32_to_fp16(real_to_f32_bits(val));
  endfunction

  // Expand IEEE FP16 to IEEE FP32 (same path as collect / emit fp16ToFp32).
  function automatic logic [31:0] fp16_to_f32_bits(input logic [15:0] h);
    logic        sign;
    logic [4:0]  exp;
    logic [9:0]  mant;
    logic [7:0]  e;
    logic [22:0] m;
    real         r;
    begin
      sign = h[15];
      exp  = h[14:10];
      mant = h[9:0];
      if (exp == 5'h00) begin
        if (mant == 10'h0)
          return {sign, 31'h0};
        r = real'(mant) / 1024.0;
        r = r * 2.0**(-14.0);
        if (sign) r = -r;
        return real_to_f32_bits(r);
      end
      if (exp == 5'h1f) begin
        if (mant == 10'h0)
          return {sign, 8'hff, 23'h0};
        return 32'h7fc00000;
      end
      e = exp - 15 + 127;
      m = mant << 13;
      fp16_to_f32_bits = {sign, e[7:0], m[22:0]};
    end
  endfunction

  function automatic real f32_bits_to_real(input logic [31:0] bits);
    return $bitstoshortreal(bits);
  endfunction

  function automatic shortreal fp16_to_shortreal(input logic [15:0] h);
    return f32_bits_to_real(fp16_to_f32_bits(h));
  endfunction

  // Divide FP32 by 2^right_shift via exponent only (matches util.Fp32ScaleDown).
  function automatic logic [31:0] fp32_scale_down(input logic [31:0] src, input int right_shift);
    logic [7:0] expo;
    logic [7:0] new_expo;
    begin
      expo = src[30:23];
      if (expo > right_shift)
        new_expo = expo - right_shift;
      else
        new_expo = 8'h00;
      fp32_scale_down = {src[31], new_expo, src[22:0]};
    end
  endfunction

  // Llama 3.2 1B RMSNorm epsilon in IEEE FP32 (util.Fp32Epsilon).
  localparam logic [31:0] FP32_EPS_RMSNORM = 32'h358637BD;

  function automatic logic [31:0] f32_mul_bits(input logic [31:0] a, input logic [31:0] b);
    return real_to_f32_bits(f32_bits_to_real(a) * f32_bits_to_real(b));
  endfunction

  function automatic logic [31:0] f32_add_bits(input logic [31:0] a, input logic [31:0] b);
    return real_to_f32_bits(f32_bits_to_real(a) + f32_bits_to_real(b));
  endfunction

  function automatic logic [31:0] f32_rsqrt_bits(input logic [31:0] a);
    real ra;
    ra = f32_bits_to_real(a);
    if (ra <= 0.0) return 32'h0;
    return real_to_f32_bits(1.0 / $sqrt(ra));
  endfunction

  // Golden from raw FP16 DDR bytes (no shortreal round-trip).
  function automatic void golden_rmsnorm_fp16(
    input  int d,
    input  logic [15:0] x_h_in[],
    input  logic [15:0] g_h_in[],
    output shortreal y[]
  );
    logic [31:0] acc, mean_sq, mean_eps, scale;
    int scale_shift;
    y = new[d];
    scale_shift = $clog2(d);
    acc = 32'h0;
    for (int i = 0; i < d; i++) begin
      logic [31:0] x_f32, sq;
      x_f32 = fp16_to_f32_bits(x_h_in[i]);
      sq    = f32_mul_bits(x_f32, x_f32);
      acc   = f32_add_bits(acc, sq);
    end
    mean_sq  = fp32_scale_down(acc, scale_shift);
    mean_eps = f32_add_bits(mean_sq, FP32_EPS_RMSNORM);
    scale    = f32_rsqrt_bits(mean_eps);
    for (int i = 0; i < d; i++) begin
      logic [31:0] x_f32, g_f32, x_gamma, out_f32;
      x_f32    = fp16_to_f32_bits(x_h_in[i]);
      g_f32    = fp16_to_f32_bits(g_h_in[i]);
      x_gamma  = f32_mul_bits(x_f32, g_f32);
      out_f32  = f32_mul_bits(x_gamma, scale);
      y[i]     = fp16_to_shortreal(f32_to_fp16(out_f32));
    end
  endfunction

  // Golden model mirroring RmsNormCore: FP16 I/O, FP32 square-sum / scale / emit muls.
  function automatic void golden_rmsnorm(
    input  int d,
    input  shortreal x_in[],
    input  shortreal gamma_in[],
    output shortreal y[]
  );
    logic [31:0] acc, mean_sq, mean_eps, scale;
    int scale_shift;
    y = new[d];
    scale_shift = $clog2(d);
    acc = 32'h0;
    for (int i = 0; i < d; i++) begin
      logic [15:0] x_h;
      logic [31:0] x_f32, sq;
      x_h   = real_to_fp16(real'(x_in[i]));
      x_f32 = fp16_to_f32_bits(x_h);
      sq    = f32_mul_bits(x_f32, x_f32);
      acc   = f32_add_bits(acc, sq);
    end
    mean_sq  = fp32_scale_down(acc, scale_shift);
    mean_eps = f32_add_bits(mean_sq, FP32_EPS_RMSNORM);
    scale    = f32_rsqrt_bits(mean_eps);
    for (int i = 0; i < d; i++) begin
      logic [15:0] x_h, g_h;
      logic [31:0] x_f32, g_f32, x_gamma, out_f32;
      x_h      = real_to_fp16(real'(x_in[i]));
      g_h      = real_to_fp16(real'(gamma_in[i]));
      x_f32    = fp16_to_f32_bits(x_h);
      g_f32    = fp16_to_f32_bits(g_h);
      x_gamma  = f32_mul_bits(x_f32, g_f32);
      out_f32  = f32_mul_bits(x_gamma, scale);
      y[i]     = fp16_to_shortreal(f32_to_fp16(out_f32));
    end
  endfunction

endpackage
