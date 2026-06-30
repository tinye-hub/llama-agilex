// FP32 helpers for util Questa TBs (real -> IEEE754 binary32 bits).

package util_fp32_pkg;

  function automatic logic [31:0] real_to_f32_bits(input real val);
    bit [63:0] d;
    logic      sign;
    int        exp_d;
    logic [51:0] mant_d;
    logic [22:0] mant_f;
    int        exp_f;
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
      return {sign, exp_f[7:0], mant_f[22:0]};
    end
  endfunction

  function automatic real f32_bits_to_real(input logic [31:0] bits);
    logic sign;
    int  exp;
    real mant;
    begin
      sign = bits[31];
      exp  = bits[30:23];
      if (exp == 0) return 0.0;
      if (exp == 255) return 0.0;
      mant = 1.0 + real'(bits[22:0]) / real'(1 << 23);
      return (sign ? -1.0 : 1.0) * mant * (2.0 ** (exp - 127));
    end
  endfunction

  function automatic bit f32_near(input logic [31:0] got, input logic [31:0] exp,
                                  input real rtol, input real atol);
    real g;
    real e;
    real diff;
    real denom;
    begin
      g = f32_bits_to_real(got);
      e = f32_bits_to_real(exp);
      diff = (g > e) ? (g - e) : (e - g);
      denom = (e > 0.0) ? e : 1.0;
      return (diff <= atol) || (diff / denom <= rtol);
    end
  endfunction

endpackage
