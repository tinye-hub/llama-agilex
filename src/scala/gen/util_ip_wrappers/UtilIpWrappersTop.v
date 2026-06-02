// Generator : SpinalHDL v1.11.0    git head : 63852c61e498798f4e293594ce53fcb02c45eb6b
// Component : UtilIpWrappersTop
// Git hash  : 0f00dc3d0d56d8de8f3c2ec0a8156952ad6a9cb2

`timescale 1ns/1ps

module UtilIpWrappersTop (
  input  wire          a16_valid,
  input  wire [15:0]   a16_payload,
  input  wire          a32_valid,
  input  wire [31:0]   a32_payload,
  input  wire          b32_valid,
  input  wire [31:0]   b32_payload,
  input  wire          accIn_valid,
  input  wire          accIn_payload_last,
  input  wire [31:0]   accIn_payload_fragment,
  input  wire          sa_valid,
  output wire          sa_ready,
  input  wire [31:0]   sa_payload,
  input  wire          sb_valid,
  output wire          sb_ready,
  input  wire [31:0]   sb_payload,
  output wire          r16to32_valid,
  output wire [31:0]   r16to32_payload,
  output wire          r32to16_valid,
  output wire [15:0]   r32to16_payload,
  output wire          rsqrt_valid,
  output wire [31:0]   rsqrt_payload,
  output wire          rmul_valid,
  output wire [31:0]   rmul_payload,
  output wire          radd_valid,
  output wire [31:0]   radd_payload,
  output wire          racc_valid,
  output wire          racc_payload_last,
  output wire [31:0]   racc_payload_fragment,
  output wire          rmulS_valid,
  input  wire          rmulS_ready,
  output wire [31:0]   rmulS_payload,
  input  wire          reset,
  input  wire          clk
);

  wire                a16_convert_adp_io_r_valid;
  wire       [31:0]   a16_convert_adp_io_r_payload;
  wire                a32_convert_adp_io_r_valid;
  wire       [15:0]   a32_convert_adp_io_r_payload;
  wire                a32_rsqrt_adp_io_r_valid;
  wire       [31:0]   a32_rsqrt_adp_io_r_payload;
  wire                a32_mul_adp_io_r_valid;
  wire       [31:0]   a32_mul_adp_io_r_payload;
  wire                a32_add_adp_io_r_valid;
  wire       [31:0]   a32_add_adp_io_r_payload;
  wire                accIn_serialAcc_adp_io_accOut_valid;
  wire                accIn_serialAcc_adp_io_accOut_payload_last;
  wire       [31:0]   accIn_serialAcc_adp_io_accOut_payload_fragment;
  wire                sa_mulStream_adp_io_a_ready;
  wire                sa_mulStream_adp_io_b_ready;
  wire                sa_mulStream_adp_io_r_valid;
  wire       [31:0]   sa_mulStream_adp_io_r_payload;

  FpFunctionsUnaryAdapter a16_convert_adp (
    .io_a_valid   (a16_valid                         ), //i
    .io_a_payload (a16_payload[15:0]                 ), //i
    .io_r_valid   (a16_convert_adp_io_r_valid        ), //o
    .io_r_payload (a16_convert_adp_io_r_payload[31:0]), //o
    .reset        (reset                             ), //i
    .clk          (clk                               )  //i
  );
  FpFunctionsUnaryAdapter_1 a32_convert_adp (
    .io_a_valid   (a32_valid                         ), //i
    .io_a_payload (a32_payload[31:0]                 ), //i
    .io_r_valid   (a32_convert_adp_io_r_valid        ), //o
    .io_r_payload (a32_convert_adp_io_r_payload[15:0]), //o
    .reset        (reset                             ), //i
    .clk          (clk                               )  //i
  );
  FpFunctionsUnaryAdapter_2 a32_rsqrt_adp (
    .io_a_valid   (a32_valid                       ), //i
    .io_a_payload (a32_payload[31:0]               ), //i
    .io_r_valid   (a32_rsqrt_adp_io_r_valid        ), //o
    .io_r_payload (a32_rsqrt_adp_io_r_payload[31:0]), //o
    .reset        (reset                           ), //i
    .clk          (clk                             )  //i
  );
  FpMultAccMulAdapter a32_mul_adp (
    .io_a_valid   (a32_valid                     ), //i
    .io_a_payload (a32_payload[31:0]             ), //i
    .io_b_valid   (b32_valid                     ), //i
    .io_b_payload (b32_payload[31:0]             ), //i
    .io_r_valid   (a32_mul_adp_io_r_valid        ), //o
    .io_r_payload (a32_mul_adp_io_r_payload[31:0]), //o
    .clk          (clk                           ), //i
    .reset        (reset                         )  //i
  );
  FpAddAdapter a32_add_adp (
    .io_a_valid   (a32_valid                     ), //i
    .io_a_payload (a32_payload[31:0]             ), //i
    .io_b_valid   (b32_valid                     ), //i
    .io_b_payload (b32_payload[31:0]             ), //i
    .io_r_valid   (a32_add_adp_io_r_valid        ), //o
    .io_r_payload (a32_add_adp_io_r_payload[31:0]), //o
    .clk          (clk                           ), //i
    .reset        (reset                         )  //i
  );
  FpMultAccSerialAccAdapter accIn_serialAcc_adp (
    .io_accIn_valid             (accIn_valid                                         ), //i
    .io_accIn_payload_last      (accIn_payload_last                                  ), //i
    .io_accIn_payload_fragment  (accIn_payload_fragment[31:0]                        ), //i
    .io_accOut_valid            (accIn_serialAcc_adp_io_accOut_valid                 ), //o
    .io_accOut_payload_last     (accIn_serialAcc_adp_io_accOut_payload_last          ), //o
    .io_accOut_payload_fragment (accIn_serialAcc_adp_io_accOut_payload_fragment[31:0]), //o
    .clk                        (clk                                                 ), //i
    .reset                      (reset                                               )  //i
  );
  FpMultAccMulStreamAdapter sa_mulStream_adp (
    .io_a_valid   (sa_valid                           ), //i
    .io_a_ready   (sa_mulStream_adp_io_a_ready        ), //o
    .io_a_payload (sa_payload[31:0]                   ), //i
    .io_b_valid   (sb_valid                           ), //i
    .io_b_ready   (sa_mulStream_adp_io_b_ready        ), //o
    .io_b_payload (sb_payload[31:0]                   ), //i
    .io_r_valid   (sa_mulStream_adp_io_r_valid        ), //o
    .io_r_ready   (rmulS_ready                        ), //i
    .io_r_payload (sa_mulStream_adp_io_r_payload[31:0]), //o
    .clk          (clk                                ), //i
    .reset        (reset                              )  //i
  );
  assign r16to32_valid = a16_convert_adp_io_r_valid;
  assign r16to32_payload = a16_convert_adp_io_r_payload;
  assign r32to16_valid = a32_convert_adp_io_r_valid;
  assign r32to16_payload = a32_convert_adp_io_r_payload;
  assign rsqrt_valid = a32_rsqrt_adp_io_r_valid;
  assign rsqrt_payload = a32_rsqrt_adp_io_r_payload;
  assign rmul_valid = a32_mul_adp_io_r_valid;
  assign rmul_payload = a32_mul_adp_io_r_payload;
  assign radd_valid = a32_add_adp_io_r_valid;
  assign radd_payload = a32_add_adp_io_r_payload;
  assign racc_valid = accIn_serialAcc_adp_io_accOut_valid;
  assign racc_payload_last = accIn_serialAcc_adp_io_accOut_payload_last;
  assign racc_payload_fragment = accIn_serialAcc_adp_io_accOut_payload_fragment;
  assign sa_ready = sa_mulStream_adp_io_a_ready;
  assign sb_ready = sa_mulStream_adp_io_b_ready;
  assign rmulS_valid = sa_mulStream_adp_io_r_valid;
  assign rmulS_payload = sa_mulStream_adp_io_r_payload;

endmodule

module FpMultAccMulStreamAdapter (
  input  wire          io_a_valid,
  output wire          io_a_ready,
  input  wire [31:0]   io_a_payload,
  input  wire          io_b_valid,
  output wire          io_b_ready,
  input  wire [31:0]   io_b_payload,
  output wire          io_r_valid,
  input  wire          io_r_ready,
  output wire [31:0]   io_r_payload,
  input  wire          clk,
  input  wire          reset
);

  wire                mul_io_r_valid;
  wire       [31:0]   mul_io_r_payload;
  wire                outR_valid;
  wire                outR_ready;
  wire       [31:0]   outR_payload;
  reg                 held;
  reg        [31:0]   heldPayload;
  reg                 inFlight;
  wire                canAccept;
  wire                fire;
  wire                outR_fire;

  FpMultAccMulAdapter mul (
    .io_a_valid   (fire                  ), //i
    .io_a_payload (io_a_payload[31:0]    ), //i
    .io_b_valid   (fire                  ), //i
    .io_b_payload (io_b_payload[31:0]    ), //i
    .io_r_valid   (mul_io_r_valid        ), //o
    .io_r_payload (mul_io_r_payload[31:0]), //o
    .clk          (clk                   ), //i
    .reset        (reset                 )  //i
  );
  assign outR_valid = held;
  assign outR_payload = heldPayload;
  assign canAccept = ((! held) || outR_ready);
  assign fire = (((io_a_valid && io_b_valid) && canAccept) && (! inFlight));
  assign outR_fire = (outR_valid && outR_ready);
  assign io_a_ready = ((io_b_valid && canAccept) && (! inFlight));
  assign io_b_ready = ((io_a_valid && canAccept) && (! inFlight));
  assign io_r_valid = outR_valid;
  assign outR_ready = io_r_ready;
  assign io_r_payload = outR_payload;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      held <= 1'b0;
      inFlight <= 1'b0;
    end else begin
      if(fire) begin
        inFlight <= 1'b1;
      end
      if(mul_io_r_valid) begin
        held <= 1'b1;
        inFlight <= 1'b0;
      end
      if(outR_fire) begin
        held <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(mul_io_r_valid) begin
      heldPayload <= mul_io_r_payload;
    end
  end


endmodule

module FpMultAccSerialAccAdapter (
  input  wire          io_accIn_valid,
  input  wire          io_accIn_payload_last,
  input  wire [31:0]   io_accIn_payload_fragment,
  output wire          io_accOut_valid,
  output wire          io_accOut_payload_last,
  output wire [31:0]   io_accOut_payload_fragment,
  input  wire          clk,
  input  wire          reset
);

  wire                ip_accumulate;
  wire       [31:0]   ip_fp32_result;
  reg                 isFirst;
  reg                 io_accIn_valid_delay_1;
  reg                 io_accIn_valid_delay_2;
  reg                 io_accIn_valid_delay_3;
  reg                 io_accIn_valid_delay_4;
  reg                 _zz_io_accOut_payload_last;
  reg                 _zz_io_accOut_payload_last_1;
  reg                 _zz_io_accOut_payload_last_2;
  reg                 _zz_io_accOut_payload_last_3;
  reg        [31:0]   ip_fp32_result_delay_1;
  reg        [31:0]   ip_fp32_result_delay_2;
  reg        [31:0]   ip_fp32_result_delay_3;
  reg        [31:0]   ip_fp32_result_delay_4;

  fp32MultAcc ip (
    .accumulate  (ip_accumulate                  ), //i
    .fp32_mult_a (io_accIn_payload_fragment[31:0]), //i
    .fp32_mult_b (32'h3f800000                   ), //i
    .clk         (clk                            ), //i
    .ena         (3'b111                         ), //i
    .fp32_result (ip_fp32_result[31:0]           )  //o
  );
  assign ip_accumulate = (! isFirst);
  assign io_accOut_valid = io_accIn_valid_delay_4;
  assign io_accOut_payload_last = _zz_io_accOut_payload_last_3;
  assign io_accOut_payload_fragment = ip_fp32_result_delay_4;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      isFirst <= 1'b1;
      io_accIn_valid_delay_1 <= 1'b0;
      io_accIn_valid_delay_2 <= 1'b0;
      io_accIn_valid_delay_3 <= 1'b0;
      io_accIn_valid_delay_4 <= 1'b0;
      _zz_io_accOut_payload_last <= 1'b0;
      _zz_io_accOut_payload_last_1 <= 1'b0;
      _zz_io_accOut_payload_last_2 <= 1'b0;
      _zz_io_accOut_payload_last_3 <= 1'b0;
    end else begin
      if(io_accIn_valid) begin
        if(io_accIn_payload_last) begin
          isFirst <= 1'b1;
        end else begin
          isFirst <= 1'b0;
        end
      end
      io_accIn_valid_delay_1 <= io_accIn_valid;
      io_accIn_valid_delay_2 <= io_accIn_valid_delay_1;
      io_accIn_valid_delay_3 <= io_accIn_valid_delay_2;
      io_accIn_valid_delay_4 <= io_accIn_valid_delay_3;
      _zz_io_accOut_payload_last <= (io_accIn_payload_last && io_accIn_valid);
      _zz_io_accOut_payload_last_1 <= _zz_io_accOut_payload_last;
      _zz_io_accOut_payload_last_2 <= _zz_io_accOut_payload_last_1;
      _zz_io_accOut_payload_last_3 <= _zz_io_accOut_payload_last_2;
    end
  end

  always @(posedge clk) begin
    ip_fp32_result_delay_1 <= ip_fp32_result;
    ip_fp32_result_delay_2 <= ip_fp32_result_delay_1;
    ip_fp32_result_delay_3 <= ip_fp32_result_delay_2;
    ip_fp32_result_delay_4 <= ip_fp32_result_delay_3;
  end


endmodule

module FpAddAdapter (
  input  wire          io_a_valid,
  input  wire [31:0]   io_a_payload,
  input  wire          io_b_valid,
  input  wire [31:0]   io_b_payload,
  output wire          io_r_valid,
  output wire [31:0]   io_r_payload,
  input  wire          clk,
  input  wire          reset
);

  wire       [31:0]   ip_fp32_result;
  wire                fire;
  reg                 fire_delay_1;
  reg                 fire_delay_2;
  reg                 fire_delay_3;
  reg                 fire_delay_4;
  reg        [31:0]   ip_fp32_result_delay_1;
  reg        [31:0]   ip_fp32_result_delay_2;
  reg        [31:0]   ip_fp32_result_delay_3;
  reg        [31:0]   ip_fp32_result_delay_4;

  fp32Add ip (
    .fp32_adder_a (io_a_payload[31:0]  ), //i
    .fp32_adder_b (io_b_payload[31:0]  ), //i
    .clk          (clk                 ), //i
    .ena          (3'b111              ), //i
    .fp32_result  (ip_fp32_result[31:0])  //o
  );
  assign fire = (io_a_valid && io_b_valid);
  assign io_r_valid = fire_delay_4;
  assign io_r_payload = ip_fp32_result_delay_4;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fire_delay_1 <= 1'b0;
      fire_delay_2 <= 1'b0;
      fire_delay_3 <= 1'b0;
      fire_delay_4 <= 1'b0;
    end else begin
      fire_delay_1 <= fire;
      fire_delay_2 <= fire_delay_1;
      fire_delay_3 <= fire_delay_2;
      fire_delay_4 <= fire_delay_3;
    end
  end

  always @(posedge clk) begin
    ip_fp32_result_delay_1 <= ip_fp32_result;
    ip_fp32_result_delay_2 <= ip_fp32_result_delay_1;
    ip_fp32_result_delay_3 <= ip_fp32_result_delay_2;
    ip_fp32_result_delay_4 <= ip_fp32_result_delay_3;
  end


endmodule

//FpMultAccMulAdapter_1 replaced by FpMultAccMulAdapter

module FpFunctionsUnaryAdapter_2 (
  input  wire          io_a_valid,
  input  wire [31:0]   io_a_payload,
  output wire          io_r_valid,
  output wire [31:0]   io_r_payload,
  input  wire          reset,
  input  wire          clk
);

  wire       [0:0]    ip_en;
  wire       [31:0]   ip_q;
  reg                 io_a_valid_delay_1;
  reg                 io_a_valid_delay_2;
  reg                 io_a_valid_delay_3;
  reg                 io_a_valid_delay_4;
  reg                 io_a_valid_delay_5;
  reg                 io_a_valid_delay_6;
  reg                 io_a_valid_delay_7;
  reg                 io_a_valid_delay_8;
  reg                 io_a_valid_delay_9;
  reg                 io_a_valid_delay_10;
  reg                 io_a_valid_delay_11;
  reg                 io_a_valid_delay_12;
  reg                 io_a_valid_delay_13;
  reg                 io_a_valid_delay_14;
  reg        [31:0]   ip_q_delay_1;
  reg        [31:0]   ip_q_delay_2;
  reg        [31:0]   ip_q_delay_3;
  reg        [31:0]   ip_q_delay_4;
  reg        [31:0]   ip_q_delay_5;
  reg        [31:0]   ip_q_delay_6;
  reg        [31:0]   ip_q_delay_7;
  reg        [31:0]   ip_q_delay_8;
  reg        [31:0]   ip_q_delay_9;
  reg        [31:0]   ip_q_delay_10;
  reg        [31:0]   ip_q_delay_11;
  reg        [31:0]   ip_q_delay_12;
  reg        [31:0]   ip_q_delay_13;
  reg        [31:0]   ip_q_delay_14;

  fp32Rsqrt ip (
    .clk    (clk               ), //i
    .areset (reset             ), //i
    .en     (ip_en             ), //i
    .a      (io_a_payload[31:0]), //i
    .q      (ip_q[31:0]        )  //o
  );
  assign ip_en = io_a_valid;
  assign io_r_valid = io_a_valid_delay_14;
  assign io_r_payload = ip_q_delay_14;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      io_a_valid_delay_1 <= 1'b0;
      io_a_valid_delay_2 <= 1'b0;
      io_a_valid_delay_3 <= 1'b0;
      io_a_valid_delay_4 <= 1'b0;
      io_a_valid_delay_5 <= 1'b0;
      io_a_valid_delay_6 <= 1'b0;
      io_a_valid_delay_7 <= 1'b0;
      io_a_valid_delay_8 <= 1'b0;
      io_a_valid_delay_9 <= 1'b0;
      io_a_valid_delay_10 <= 1'b0;
      io_a_valid_delay_11 <= 1'b0;
      io_a_valid_delay_12 <= 1'b0;
      io_a_valid_delay_13 <= 1'b0;
      io_a_valid_delay_14 <= 1'b0;
    end else begin
      io_a_valid_delay_1 <= io_a_valid;
      io_a_valid_delay_2 <= io_a_valid_delay_1;
      io_a_valid_delay_3 <= io_a_valid_delay_2;
      io_a_valid_delay_4 <= io_a_valid_delay_3;
      io_a_valid_delay_5 <= io_a_valid_delay_4;
      io_a_valid_delay_6 <= io_a_valid_delay_5;
      io_a_valid_delay_7 <= io_a_valid_delay_6;
      io_a_valid_delay_8 <= io_a_valid_delay_7;
      io_a_valid_delay_9 <= io_a_valid_delay_8;
      io_a_valid_delay_10 <= io_a_valid_delay_9;
      io_a_valid_delay_11 <= io_a_valid_delay_10;
      io_a_valid_delay_12 <= io_a_valid_delay_11;
      io_a_valid_delay_13 <= io_a_valid_delay_12;
      io_a_valid_delay_14 <= io_a_valid_delay_13;
    end
  end

  always @(posedge clk) begin
    ip_q_delay_1 <= ip_q;
    ip_q_delay_2 <= ip_q_delay_1;
    ip_q_delay_3 <= ip_q_delay_2;
    ip_q_delay_4 <= ip_q_delay_3;
    ip_q_delay_5 <= ip_q_delay_4;
    ip_q_delay_6 <= ip_q_delay_5;
    ip_q_delay_7 <= ip_q_delay_6;
    ip_q_delay_8 <= ip_q_delay_7;
    ip_q_delay_9 <= ip_q_delay_8;
    ip_q_delay_10 <= ip_q_delay_9;
    ip_q_delay_11 <= ip_q_delay_10;
    ip_q_delay_12 <= ip_q_delay_11;
    ip_q_delay_13 <= ip_q_delay_12;
    ip_q_delay_14 <= ip_q_delay_13;
  end


endmodule

module FpFunctionsUnaryAdapter_1 (
  input  wire          io_a_valid,
  input  wire [31:0]   io_a_payload,
  output wire          io_r_valid,
  output wire [15:0]   io_r_payload,
  input  wire          reset,
  input  wire          clk
);

  wire       [0:0]    ip_en;
  wire       [15:0]   ip_q;
  reg                 io_a_valid_delay_1;
  reg                 io_a_valid_delay_2;
  reg        [15:0]   ip_q_delay_1;
  reg        [15:0]   ip_q_delay_2;

  fp32ToFp16 ip (
    .clk    (clk               ), //i
    .areset (reset             ), //i
    .en     (ip_en             ), //i
    .a      (io_a_payload[31:0]), //i
    .q      (ip_q[15:0]        )  //o
  );
  assign ip_en = io_a_valid;
  assign io_r_valid = io_a_valid_delay_2;
  assign io_r_payload = ip_q_delay_2;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      io_a_valid_delay_1 <= 1'b0;
      io_a_valid_delay_2 <= 1'b0;
    end else begin
      io_a_valid_delay_1 <= io_a_valid;
      io_a_valid_delay_2 <= io_a_valid_delay_1;
    end
  end

  always @(posedge clk) begin
    ip_q_delay_1 <= ip_q;
    ip_q_delay_2 <= ip_q_delay_1;
  end


endmodule

module FpFunctionsUnaryAdapter (
  input  wire          io_a_valid,
  input  wire [15:0]   io_a_payload,
  output wire          io_r_valid,
  output wire [31:0]   io_r_payload,
  input  wire          reset,
  input  wire          clk
);

  wire       [0:0]    ip_en;
  wire       [31:0]   ip_q;

  fp16ToFp32 ip (
    .clk    (clk               ), //i
    .areset (reset             ), //i
    .en     (ip_en             ), //i
    .a      (io_a_payload[15:0]), //i
    .q      (ip_q[31:0]        )  //o
  );
  assign ip_en = io_a_valid;
  assign io_r_valid = io_a_valid;
  assign io_r_payload = ip_q;

endmodule

module FpMultAccMulAdapter (
  input  wire          io_a_valid,
  input  wire [31:0]   io_a_payload,
  input  wire          io_b_valid,
  input  wire [31:0]   io_b_payload,
  output wire          io_r_valid,
  output wire [31:0]   io_r_payload,
  input  wire          clk,
  input  wire          reset
);

  wire       [31:0]   ip_fp32_result;
  wire                fire;
  reg                 fire_delay_1;
  reg                 fire_delay_2;
  reg                 fire_delay_3;
  reg                 fire_delay_4;
  reg        [31:0]   ip_fp32_result_delay_1;
  reg        [31:0]   ip_fp32_result_delay_2;
  reg        [31:0]   ip_fp32_result_delay_3;
  reg        [31:0]   ip_fp32_result_delay_4;

  fp32MultAcc ip (
    .accumulate  (1'b0                ), //i
    .fp32_mult_a (io_a_payload[31:0]  ), //i
    .fp32_mult_b (io_b_payload[31:0]  ), //i
    .clk         (clk                 ), //i
    .ena         (3'b111              ), //i
    .fp32_result (ip_fp32_result[31:0])  //o
  );
  assign fire = (io_a_valid && io_b_valid);
  assign io_r_valid = fire_delay_4;
  assign io_r_payload = ip_fp32_result_delay_4;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fire_delay_1 <= 1'b0;
      fire_delay_2 <= 1'b0;
      fire_delay_3 <= 1'b0;
      fire_delay_4 <= 1'b0;
    end else begin
      fire_delay_1 <= fire;
      fire_delay_2 <= fire_delay_1;
      fire_delay_3 <= fire_delay_2;
      fire_delay_4 <= fire_delay_3;
    end
  end

  always @(posedge clk) begin
    ip_fp32_result_delay_1 <= ip_fp32_result;
    ip_fp32_result_delay_2 <= ip_fp32_result_delay_1;
    ip_fp32_result_delay_3 <= ip_fp32_result_delay_2;
    ip_fp32_result_delay_4 <= ip_fp32_result_delay_3;
  end


endmodule
