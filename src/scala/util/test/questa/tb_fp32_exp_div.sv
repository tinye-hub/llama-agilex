// Questa smoke test for Quartus fp32Exp (latency 31) and fp32Div (latency 30).

`timescale 1ns/1ps
import util_fp32_pkg::*;

module tb_fp32_exp_div;

  localparam int EXP_LAT = 31;
  localparam int DIV_LAT = 30;
  localparam real RTOL   = 1.0e-4;
  localparam real ATOL   = 1.0e-5;

  logic clk;
  logic rst;

  logic        expInValid;
  logic [31:0] expInData;
  logic        expOutValid;
  logic [31:0] expOutData;

  logic        divAValid;
  logic [31:0] divAData;
  logic        divBValid;
  logic [31:0] divBData;
  logic        divOutValid;
  logic [31:0] divOutData;

  Fp32ExpDivSmokeTop dut (
    .clk              (clk),
    .reset            (rst),
    .io_expInValid    (expInValid),
    .io_expInData     (expInData),
    .io_expOutValid   (expOutValid),
    .io_expOutData    (expOutData),
    .io_divAValid     (divAValid),
    .io_divAData      (divAData),
    .io_divBValid     (divBValid),
    .io_divBData      (divBData),
    .io_divOutValid   (divOutValid),
    .io_divOutData    (divOutData)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  task automatic pulse_exp(input real x, input real expected);
    int timeout;
    begin
      expInValid = 1;
      expInData  = real_to_f32_bits(x);
      @(posedge clk);
      expInValid = 0;
      timeout = 0;
      while (!expOutValid && timeout < EXP_LAT + 20) begin
        @(posedge clk);
        timeout++;
      end
      if (!expOutValid) begin
        $fatal(1, "fp32Exp timeout for x=%0f", x);
      end
      if (!f32_near(expOutData, real_to_f32_bits(expected), RTOL, ATOL)) begin
        $fatal(1, "fp32Exp mismatch x=%0f got=%0f exp=%0f bits=%h/%h",
               x, f32_bits_to_real(expOutData), expected, expOutData, real_to_f32_bits(expected));
      end
      @(posedge clk);
    end
  endtask

  task automatic pulse_div(input real a, input real b, input real expected);
    int timeout;
    begin
      divAValid = 1;
      divAData  = real_to_f32_bits(a);
      divBValid = 1;
      divBData  = real_to_f32_bits(b);
      @(posedge clk);
      divAValid = 0;
      divBValid = 0;
      timeout = 0;
      while (!divOutValid && timeout < DIV_LAT + 20) begin
        @(posedge clk);
        timeout++;
      end
      if (!divOutValid) begin
        $fatal(1, "fp32Div timeout for %0f/%0f", a, b);
      end
      if (!f32_near(divOutData, real_to_f32_bits(expected), RTOL, ATOL)) begin
        $fatal(1, "fp32Div mismatch %0f/%0f got=%0f exp=%0f",
               a, b, f32_bits_to_real(divOutData), expected);
      end
      @(posedge clk);
    end
  endtask

  initial begin
    expInValid  = 0;
    divAValid   = 0;
    divBValid   = 0;
    rst = 1;
    repeat (5) @(posedge clk);
    rst = 0;
    repeat (EXP_LAT + 2) @(posedge clk);

    $display("[tb] fp32Exp / fp32Div smoke");
    pulse_exp(0.0,   1.0);
    pulse_exp(-1.0,  0.3678794412);
    pulse_exp(-8.0,  0.0003354626);

    pulse_div(1.0, 2.0, 0.5);
    pulse_div(1.0, 4.0, 0.25);
    pulse_div(3.0, 2.0, 1.5);

    $display("********** PASS **********");
    $finish;
  end

endmodule
