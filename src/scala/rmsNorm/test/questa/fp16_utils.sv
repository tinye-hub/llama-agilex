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

  function automatic shortreal fp16_to_shortreal(input logic [15:0] h);
    logic [31:0] sign, exp, mant, e, m, f32;
    begin
      sign = h[15];
      exp  = h[14:10];
      mant = h[9:0];
      if (exp == 0) return shortreal'(0.0);
      if (exp == 5'h1f) return shortreal'(0.0);
      e   = exp - 15 + 127;
      m   = mant << 13;
      f32 = {sign, e[7:0], m[22:0]};
      return $bitstoshortreal(f32);
    end
  endfunction

endpackage
