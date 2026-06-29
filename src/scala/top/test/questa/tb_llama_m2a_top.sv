// Questa testbench for LlamaM2aTop — M2a graduation: embed → RMSNorm → L0 W_Q GEMV.
//
// Golden: RMSNorm reference on embed/gamma + INT4_G128 GEMV on packed DDR weights.
// Requires full pack: make -C tools/ddr_pack pack
//
// Parameters: +define+GEMV_K / +define+GEMV_M (must match verilog-m2a LLAMA_M2A_*)

`timescale 1ns/1ps

import rmsnorm_fp16_pkg::*;

module tb_llama_m2a_top;

`ifdef GEMV_K
    localparam int K = `GEMV_K;
`else
    localparam int K = 2048;
`endif
`ifdef GEMV_M
    localparam int M = `GEMV_M;
`else
    localparam int M = 2048;
`endif

    localparam int  BANK          = 64;
    localparam int  TILES         = K / BANK;
    localparam int  GROUPS        = K / 128;
    localparam int  TPG           = 128 / BANK;
    localparam int  ROW_STRIDE    = K / 2;
    localparam int  TILE_STRIDE   = BANK / 2;
    localparam int  AXI_DATA_W    = 256;
    localparam int  CLK_PERIOD_NS = 10;
    localparam real TOL_ABS       = 2.0e-2;
    localparam real TOL_REL       = 1.0 / 64.0;
    localparam int  MAX_QOUT      = (M * TILES + M) * 5000 + 500000;
    localparam int  PROGRESS_ROW  = 10;

    localparam logic [7:0] ADDR_CTRL       = 8'h00;
    localparam logic [7:0] ADDR_STATUS     = 8'h04;
    localparam logic [7:0] ADDR_TOKEN_ID   = 8'h08;
    localparam logic [7:0] ADDR_SEQ_POS    = 8'h0C;
    localparam int CTRL_JOB_START = 0;
    localparam int CTRL_SOFT_RESET = 2;
    localparam int STATUS_BUSY = 0;
    localparam int STATUS_JOB_DONE = 1;
    localparam int STATUS_JOB_ERROR = 2;

    localparam longint EMBED_ADDR  = 64'h0000_0000;
    localparam longint GAMMA_ADDR  = 64'h1F50_0000;
    localparam longint WQ_BASE     = 64'h2000_0000;
    localparam longint SCALE_BASE  = 64'h3F00_1000;

    logic clk, reset;

    // HPS AXI4-Lite
    logic        io_hps_aw_valid, io_hps_aw_ready;
    logic [7:0]  io_hps_aw_payload_addr;
    logic [2:0]  io_hps_aw_payload_prot;
    logic        io_hps_w_valid, io_hps_w_ready;
    logic [31:0] io_hps_w_payload_data;
    logic [3:0]  io_hps_w_payload_strb;
    logic        io_hps_b_valid, io_hps_b_ready;
    logic [1:0]  io_hps_b_payload_resp;
    logic        io_hps_ar_valid, io_hps_ar_ready;
    logic [7:0]  io_hps_ar_payload_addr;
    logic [2:0]  io_hps_ar_payload_prot;
    logic        io_hps_r_valid, io_hps_r_ready;
    logic [31:0] io_hps_r_payload_data;
    logic [1:0]  io_hps_r_payload_resp;

    // DDR AXI
    logic        io_ddrAxi_ar_valid, io_ddrAxi_ar_ready;
    logic [31:0] io_ddrAxi_ar_payload_addr;
    logic [3:0]  io_ddrAxi_ar_payload_id;
    logic [7:0]  io_ddrAxi_ar_payload_len;
    logic [2:0]  io_ddrAxi_ar_payload_size;
    logic [1:0]  io_ddrAxi_ar_payload_burst;
    logic                    io_ddrAxi_r_valid, io_ddrAxi_r_ready;
    logic [AXI_DATA_W-1:0]  io_ddrAxi_r_payload_data;
    logic [3:0]              io_ddrAxi_r_payload_id;
    logic [1:0]              io_ddrAxi_r_payload_resp;
    logic                    io_ddrAxi_r_payload_last;
    logic        io_ddrAxi_aw_valid, io_ddrAxi_aw_ready;
    logic        io_ddrAxi_w_valid, io_ddrAxi_w_ready;
    logic        io_ddrAxi_b_valid, io_ddrAxi_b_ready;

    // rmsNormOut / qOut
    logic        io_rmsNormOut_valid, io_rmsNormOut_ready;
    logic [15:0] io_rmsNormOut_payload_data;
    logic [1:0]  io_rmsNormOut_payload_keep;
    logic        io_rmsNormOut_payload_last;
    logic [31:0] io_rmsNormOut_payload_user;

    logic        io_qOut_valid, io_qOut_ready;
    logic [15:0] io_qOut_payload_data;
    logic [1:0]  io_qOut_payload_keep;
    logic        io_qOut_payload_last;
    logic [31:0] io_qOut_payload_user;

    logic [15:0] INT_FP16 [16];
    initial begin
        INT_FP16[ 0]=16'hC800; INT_FP16[ 1]=16'hC700; INT_FP16[ 2]=16'hC600; INT_FP16[ 3]=16'hC500;
        INT_FP16[ 4]=16'hC400; INT_FP16[ 5]=16'hC200; INT_FP16[ 6]=16'hC000; INT_FP16[ 7]=16'hBC00;
        INT_FP16[ 8]=16'h0000; INT_FP16[ 9]=16'h3C00; INT_FP16[10]=16'h4000; INT_FP16[11]=16'h4200;
        INT_FP16[12]=16'h4400; INT_FP16[13]=16'h4500; INT_FP16[14]=16'h4600; INT_FP16[15]=16'h4700;
    end

    string       ddr_image_path;
    logic [15:0] golden_embed [K];
    logic [15:0] golden_gamma [K];
    shortreal    norm_ref     [K];
    logic [15:0] x_h          [K];
    logic [3:0]  w_nib        [M][K];
    logic [15:0] sc_h         [M][GROUPS];
    logic [15:0] golden_q     [M];
    logic [15:0] recv_q       [M];
    int          recv_cnt;

    LlamaM2aTop dut (
        .io_hps_aw_valid           (io_hps_aw_valid),
        .io_hps_aw_ready           (io_hps_aw_ready),
        .io_hps_aw_payload_addr    (io_hps_aw_payload_addr),
        .io_hps_aw_payload_prot    (io_hps_aw_payload_prot),
        .io_hps_w_valid            (io_hps_w_valid),
        .io_hps_w_ready            (io_hps_w_ready),
        .io_hps_w_payload_data     (io_hps_w_payload_data),
        .io_hps_w_payload_strb     (io_hps_w_payload_strb),
        .io_hps_b_valid            (io_hps_b_valid),
        .io_hps_b_ready            (io_hps_b_ready),
        .io_hps_b_payload_resp     (io_hps_b_payload_resp),
        .io_hps_ar_valid           (io_hps_ar_valid),
        .io_hps_ar_ready           (io_hps_ar_ready),
        .io_hps_ar_payload_addr    (io_hps_ar_payload_addr),
        .io_hps_ar_payload_prot    (io_hps_ar_payload_prot),
        .io_hps_r_valid            (io_hps_r_valid),
        .io_hps_r_ready            (io_hps_r_ready),
        .io_hps_r_payload_data     (io_hps_r_payload_data),
        .io_hps_r_payload_resp     (io_hps_r_payload_resp),
        .io_ddrAxi_aw_valid        (io_ddrAxi_aw_valid),
        .io_ddrAxi_aw_ready        (io_ddrAxi_aw_ready),
        .io_ddrAxi_w_valid         (io_ddrAxi_w_valid),
        .io_ddrAxi_w_ready         (io_ddrAxi_w_ready),
        .io_ddrAxi_b_valid         (io_ddrAxi_b_valid),
        .io_ddrAxi_b_ready         (io_ddrAxi_b_ready),
        .io_ddrAxi_ar_valid        (io_ddrAxi_ar_valid),
        .io_ddrAxi_ar_ready        (io_ddrAxi_ar_ready),
        .io_ddrAxi_ar_payload_addr (io_ddrAxi_ar_payload_addr),
        .io_ddrAxi_ar_payload_id   (io_ddrAxi_ar_payload_id),
        .io_ddrAxi_ar_payload_len  (io_ddrAxi_ar_payload_len),
        .io_ddrAxi_ar_payload_size (io_ddrAxi_ar_payload_size),
        .io_ddrAxi_ar_payload_burst(io_ddrAxi_ar_payload_burst),
        .io_ddrAxi_r_valid         (io_ddrAxi_r_valid),
        .io_ddrAxi_r_ready         (io_ddrAxi_r_ready),
        .io_ddrAxi_r_payload_data  (io_ddrAxi_r_payload_data),
        .io_ddrAxi_r_payload_id    (io_ddrAxi_r_payload_id),
        .io_ddrAxi_r_payload_resp  (io_ddrAxi_r_payload_resp),
        .io_ddrAxi_r_payload_last  (io_ddrAxi_r_payload_last),
        .io_rmsNormOut_valid       (io_rmsNormOut_valid),
        .io_rmsNormOut_ready       (io_rmsNormOut_ready),
        .io_rmsNormOut_payload_data(io_rmsNormOut_payload_data),
        .io_rmsNormOut_payload_keep(io_rmsNormOut_payload_keep),
        .io_rmsNormOut_payload_last(io_rmsNormOut_payload_last),
        .io_rmsNormOut_payload_user(io_rmsNormOut_payload_user),
        .io_qOut_valid             (io_qOut_valid),
        .io_qOut_ready             (io_qOut_ready),
        .io_qOut_payload_data      (io_qOut_payload_data),
        .io_qOut_payload_keep      (io_qOut_payload_keep),
        .io_qOut_payload_last      (io_qOut_payload_last),
        .io_qOut_payload_user      (io_qOut_payload_user),
        .clk                       (clk),
        .reset                     (reset)
    );

    axi_read_mem #(.DATA_W(AXI_DATA_W)) ddr_mem (
        .clk(clk), .reset(reset),
        .ar_ready(io_ddrAxi_ar_ready), .ar_valid(io_ddrAxi_ar_valid),
        .ar_addr(io_ddrAxi_ar_payload_addr), .ar_id(io_ddrAxi_ar_payload_id),
        .ar_len(io_ddrAxi_ar_payload_len), .ar_size(io_ddrAxi_ar_payload_size),
        .ar_burst(io_ddrAxi_ar_payload_burst),
        .r_valid(io_ddrAxi_r_valid), .r_ready(io_ddrAxi_r_ready),
        .r_data(io_ddrAxi_r_payload_data), .r_id(io_ddrAxi_r_payload_id),
        .r_resp(io_ddrAxi_r_payload_resp), .r_last(io_ddrAxi_r_payload_last)
    );

    assign io_ddrAxi_aw_ready = 1'b0;
    assign io_ddrAxi_w_ready  = 1'b0;
    assign io_ddrAxi_b_valid  = 1'b0;

    initial clk = 1'b0;
    always #(CLK_PERIOD_NS/2) clk = ~clk;

    task automatic tick(); @(posedge clk); endtask

    task automatic axil_write(input logic [7:0] addr, input logic [31:0] data);
        io_hps_aw_payload_addr = addr;
        io_hps_aw_payload_prot = 3'b000;
        io_hps_w_payload_data  = data;
        io_hps_w_payload_strb  = 4'hF;
        io_hps_aw_valid = 1'b1;
        io_hps_w_valid  = 1'b1;
        io_hps_b_ready  = 1'b1;
        do @(posedge clk); while (!(io_hps_aw_ready && io_hps_w_ready));
        io_hps_aw_valid = 1'b0;
        io_hps_w_valid  = 1'b0;
        do @(posedge clk); while (!io_hps_b_valid);
        io_hps_b_ready = 1'b0;
    endtask

    task automatic axil_read(input logic [7:0] addr, output logic [31:0] data);
        io_hps_ar_payload_addr = addr;
        io_hps_ar_payload_prot = 3'b000;
        io_hps_ar_valid = 1'b1;
        io_hps_r_ready  = 1'b1;
        do @(posedge clk); while (!io_hps_ar_ready);
        io_hps_ar_valid = 1'b0;
        do @(posedge clk); while (!io_hps_r_valid);
        data = io_hps_r_payload_data;
        io_hps_r_ready = 1'b0;
    endtask

    task automatic start_job(input int token_id, input int seq_pos);
        axil_write(ADDR_TOKEN_ID, token_id[31:0]);
        axil_write(ADDR_SEQ_POS,  seq_pos[31:0]);
        axil_write(ADDR_CTRL, 32'h1 << CTRL_JOB_START);
    endtask

    task automatic load_row_fp16(
        input string path, input longint unsigned byte_addr,
        output logic [15:0] row [K]
    );
        int fd; byte unsigned lo, hi;
        fd = $fopen(path, "rb");
        if (fd == 0) $fatal(1, "Cannot open %s", path);
        if ($fseek(fd, byte_addr, 0) != 0) $fatal(1, "fseek 0x%0h failed", byte_addr);
        for (int i = 0; i < K; i++) begin
            if ($fread(lo, fd) != 1 || $fread(hi, fd) != 1) $fatal(1, "short read row");
            row[i] = {hi, lo};
        end
        $fclose(fd);
    endtask

    task automatic load_wq_nibbles(input string path);
        int fd;
        fd = $fopen(path, "rb");
        if (fd == 0) $fatal(1, "Cannot open %s", path);
        for (int r = 0; r < M; r++)
            for (int k = 0; k < K; k++) begin
                byte unsigned b;
                longint unsigned off;
                off = WQ_BASE + r * ROW_STRIDE + (k >> 1);
                if ($fseek(fd, off, 0) != 0) $fatal(1, "fseek wq 0x%0h", off);
                if ($fread(b, fd) != 1) $fatal(1, "short read wq");
                w_nib[r][k] = (k[0]) ? b[7:4] : b[3:0];
            end
        $fclose(fd);
    endtask

    task automatic load_scales(input string path);
        int fd;
        fd = $fopen(path, "rb");
        if (fd == 0) $fatal(1, "Cannot open %s", path);
        for (int r = 0; r < M; r++)
            for (int g = 0; g < GROUPS; g++) begin
                byte unsigned lo, hi;
                longint unsigned off;
                off = SCALE_BASE + (r * GROUPS + g) * 2;
                if ($fseek(fd, off, 0) != 0) $fatal(1, "fseek scale 0x%0h", off);
                if ($fread(lo, fd) != 1 || $fread(hi, fd) != 1) $fatal(1, "short read scale");
                sc_h[r][g] = {hi, lo};
            end
        $fclose(fd);
    endtask

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

    task automatic compute_q_golden();
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
            golden_q[r] = f32_to_fp16(acc);
        end
    endtask

    initial begin
        recv_cnt = 0;
        forever begin
            @(posedge clk);
            if (!reset && io_qOut_valid && io_qOut_ready) begin
                if (recv_cnt < M) begin
                    recv_q[recv_cnt] = io_qOut_payload_data;
                    if (((recv_cnt + 1) % PROGRESS_ROW == 0) || (recv_cnt + 1 == M))
                        $display("[tb] qOut progress %0d/%0d @ %0t ns", recv_cnt + 1, M, $time);
                end
                recv_cnt++;
            end
        end
    end

    initial begin
        int mismatches;
        real max_err;
        logic [31:0] st;
        int timeout;

        if (!$value$plusargs("DDR_IMAGE=%s", ddr_image_path))
            $fatal(1, "DDR_IMAGE plusarg missing");

        io_hps_aw_valid = 0; io_hps_w_valid = 0; io_hps_b_ready = 0;
        io_hps_ar_valid = 0; io_hps_r_ready = 0;
        io_rmsNormOut_ready = 1'b1;
        io_qOut_ready       = 1'b1;

        reset = 1'b1;
        repeat (5) tick();
        reset = 1'b0;
        repeat (10) tick();

        $display("[tb] M2a top test K=%0d M=%0d", K, M);
        load_row_fp16(ddr_image_path, EMBED_ADDR, golden_embed);
        load_row_fp16(ddr_image_path, GAMMA_ADDR, golden_gamma);
        load_wq_nibbles(ddr_image_path);
        load_scales(ddr_image_path);

        ddr_mem.load_region(ddr_image_path, EMBED_ADDR, K * 2);
        ddr_mem.load_region(ddr_image_path, GAMMA_ADDR, K * 2);
        ddr_mem.load_region(ddr_image_path, WQ_BASE, M * ROW_STRIDE);
        ddr_mem.load_region(ddr_image_path, SCALE_BASE, M * GROUPS * 2);

        golden_rmsnorm_fp16(K, golden_embed, golden_gamma, norm_ref);
        for (int i = 0; i < K; i++)
            x_h[i] = real_to_fp16(real'(norm_ref[i]));

        compute_q_golden();

        recv_cnt = 0;
        start_job(0, 7);

        timeout = 0;
        axil_read(ADDR_STATUS, st);
        while (!st[STATUS_JOB_DONE] && timeout < MAX_QOUT) begin
            tick();
            timeout++;
            axil_read(ADDR_STATUS, st);
        end

        if (!st[STATUS_JOB_DONE])
            $fatal(1, "timeout waiting job_done (cycles=%0d recv_q=%0d/%0d)", timeout, recv_cnt, M);
        if (st[STATUS_JOB_ERROR])
            $fatal(1, "job_error set status=0x%0h", st);

        repeat (20) tick();

        if (recv_cnt < M)
            $fatal(1, "expected %0d qOut beats, got %0d", M, recv_cnt);

        max_err = 0.0; mismatches = 0;
        for (int r = 0; r < M; r++) begin
            real rr, rg, err, thr;
            bit agree;
            err = fp16_abs_err(recv_q[r], golden_q[r], TOL_ABS, agree);
            rg  = real'(fp16_to_shortreal(golden_q[r]));
            rr  = real'(fp16_to_shortreal(recv_q[r]));
            thr = TOL_ABS;
            if ((rg >= 0.0 ? rg : -rg) * TOL_REL > thr) thr = (rg >= 0.0 ? rg : -rg) * TOL_REL;
            agree = (err <= thr);
            if (err > max_err) max_err = err;
            if (!agree) begin
                if (mismatches < 8)
                    $display("  q mismatch[row %0d]: recv=%h (%0.6g) golden=%h (%0.6g) err=%0.6g",
                             r, recv_q[r], rr, golden_q[r], rg, err);
                mismatches++;
            end
        end

        $display("LlamaM2aTop: M=%0d K=%0d max_err=%0.8f mismatches=%0d/%0d",
                 M, K, max_err, mismatches, M);
        if (mismatches != 0)
            $fatal(1, "FAIL: %0d/%0d qOut mismatches", mismatches, M);

        $display("\033[32m********** PASS **********\033[0m");
        #1;
        $finish;
    end

endmodule
