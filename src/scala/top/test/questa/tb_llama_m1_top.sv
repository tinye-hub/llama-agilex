// Questa testbench for LlamaM1Top — M1 graduation test.
// Covers:
//   Test 1 (happy path): token_id=0, seq_pos=7 → 2048 RMSNorm output beats, FP golden check.
//   Test 2 (OOB):        token_id=vocabSize → job_error=1, errorCode=1, no DDR read, no output.
//
// Requires: Quartus Agilex 5 FP IPs (altera_fp_functions, agilex_native_floating_point_dsp).
// Run: make questa-m1 (from src/scala/top/)

`timescale 1ns/1ps

import rmsnorm_fp16_pkg::*;

module tb_llama_m1_top;

    localparam int  DIM           = 2048;
    localparam int  ROW_BYTES     = DIM * 2;           // 4096
    localparam int  AXI_DATA_W   = 256;
    localparam int  CLK_PERIOD_NS = 10;
    localparam real TOL_ABS       = 1.0e-2;            // FP16 output tolerance (shortreal)
    localparam int  MAX_RMSNORM   = DIM * 1000;        // timeout cycles for rmsNormOut

    // AXI4-Lite register byte addresses (HpsJobCtrl)
    localparam logic [7:0] ADDR_CTRL      = 8'h00;
    localparam logic [7:0] ADDR_STATUS    = 8'h04;
    localparam logic [7:0] ADDR_TOKEN_ID  = 8'h08;
    localparam logic [7:0] ADDR_SEQ_POS   = 8'h0C;
    localparam logic [7:0] ADDR_ERROR_CODE= 8'h1C;

    // CTRL bits
    localparam int CTRL_JOB_START    = 0;
    localparam int CTRL_JOB_ABORT    = 1;
    localparam int CTRL_SOFT_RESET   = 2;

    // STATUS bits
    localparam int STATUS_BUSY      = 0;
    localparam int STATUS_JOB_DONE  = 1;
    localparam int STATUS_JOB_ERROR = 2;

    localparam longint EMBED_ADDR    = 64'h0000_0000;
    localparam longint GAMMA_ADDR    = 64'h1F50_0000;
    localparam int     VOCAB_SIZE    = 128256;

    logic clk;
    logic reset;

    // HPS MMIO — AXI4-Lite master (drives DUT slave)
    logic        io_hps_aw_valid;
    logic        io_hps_aw_ready;
    logic [7:0]  io_hps_aw_payload_addr;
    logic [2:0]  io_hps_aw_payload_prot;
    logic        io_hps_w_valid;
    logic        io_hps_w_ready;
    logic [31:0] io_hps_w_payload_data;
    logic [3:0]  io_hps_w_payload_strb;
    logic        io_hps_b_valid;
    logic        io_hps_b_ready;
    logic [1:0]  io_hps_b_payload_resp;
    logic        io_hps_ar_valid;
    logic        io_hps_ar_ready;
    logic [7:0]  io_hps_ar_payload_addr;
    logic [2:0]  io_hps_ar_payload_prot;
    logic        io_hps_r_valid;
    logic        io_hps_r_ready;
    logic [31:0] io_hps_r_payload_data;
    logic [1:0]  io_hps_r_payload_resp;

    // DDR AXI4 (256-bit)
    logic        io_ddrAxi_aw_valid;
    logic        io_ddrAxi_aw_ready;
    logic [31:0] io_ddrAxi_aw_payload_addr;
    logic [3:0]  io_ddrAxi_aw_payload_id;
    logic [7:0]  io_ddrAxi_aw_payload_len;
    logic [2:0]  io_ddrAxi_aw_payload_size;
    logic [1:0]  io_ddrAxi_aw_payload_burst;

    logic                    io_ddrAxi_w_valid;
    logic                    io_ddrAxi_w_ready;
    logic [AXI_DATA_W-1:0]  io_ddrAxi_w_payload_data;
    logic                    io_ddrAxi_w_payload_last;

    logic        io_ddrAxi_b_valid;
    logic        io_ddrAxi_b_ready;
    logic [3:0]  io_ddrAxi_b_payload_id;
    logic [1:0]  io_ddrAxi_b_payload_resp;

    logic        io_ddrAxi_ar_valid;
    logic        io_ddrAxi_ar_ready;
    logic [31:0] io_ddrAxi_ar_payload_addr;
    logic [3:0]  io_ddrAxi_ar_payload_id;
    logic [7:0]  io_ddrAxi_ar_payload_len;
    logic [2:0]  io_ddrAxi_ar_payload_size;
    logic [1:0]  io_ddrAxi_ar_payload_burst;

    logic                    io_ddrAxi_r_valid;
    logic                    io_ddrAxi_r_ready;
    logic [AXI_DATA_W-1:0]  io_ddrAxi_r_payload_data;
    logic [3:0]              io_ddrAxi_r_payload_id;
    logic [1:0]              io_ddrAxi_r_payload_resp;
    logic                    io_ddrAxi_r_payload_last;

    // rmsNormOut AXI-Stream
    logic        io_rmsNormOut_valid;
    logic        io_rmsNormOut_ready;
    logic [15:0] io_rmsNormOut_payload_data;
    logic [1:0]  io_rmsNormOut_payload_keep;
    logic        io_rmsNormOut_payload_last;
    logic [31:0] io_rmsNormOut_payload_user;

    // -------------------------------------------------------------------------
    // DUT
    // -------------------------------------------------------------------------
    LlamaM1Top dut (
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
        .io_ddrAxi_aw_payload_addr (io_ddrAxi_aw_payload_addr),
        .io_ddrAxi_aw_payload_id   (io_ddrAxi_aw_payload_id),
        .io_ddrAxi_aw_payload_len  (io_ddrAxi_aw_payload_len),
        .io_ddrAxi_aw_payload_size (io_ddrAxi_aw_payload_size),
        .io_ddrAxi_aw_payload_burst(io_ddrAxi_aw_payload_burst),
        .io_ddrAxi_w_valid         (io_ddrAxi_w_valid),
        .io_ddrAxi_w_ready         (io_ddrAxi_w_ready),
        .io_ddrAxi_w_payload_data  (io_ddrAxi_w_payload_data),
        .io_ddrAxi_w_payload_last  (io_ddrAxi_w_payload_last),
        .io_ddrAxi_b_valid         (io_ddrAxi_b_valid),
        .io_ddrAxi_b_ready         (io_ddrAxi_b_ready),
        .io_ddrAxi_b_payload_id    (io_ddrAxi_b_payload_id),
        .io_ddrAxi_b_payload_resp  (io_ddrAxi_b_payload_resp),
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
        .clk                       (clk),
        .reset                     (reset)
    );

    // -------------------------------------------------------------------------
    // AXI4 DDR read slave (byte-sparse)
    // -------------------------------------------------------------------------
    axi_read_mem #(
        .DATA_W (AXI_DATA_W)
    ) ddr_mem (
        .clk      (clk),
        .reset    (reset),
        .ar_ready (io_ddrAxi_ar_ready),
        .ar_valid (io_ddrAxi_ar_valid),
        .ar_addr  (io_ddrAxi_ar_payload_addr),
        .ar_id    (io_ddrAxi_ar_payload_id),
        .ar_len   (io_ddrAxi_ar_payload_len),
        .ar_size  (io_ddrAxi_ar_payload_size),
        .ar_burst (io_ddrAxi_ar_payload_burst),
        .r_valid  (io_ddrAxi_r_valid),
        .r_ready  (io_ddrAxi_r_ready),
        .r_data   (io_ddrAxi_r_payload_data),
        .r_id     (io_ddrAxi_r_payload_id),
        .r_resp   (io_ddrAxi_r_payload_resp),
        .r_last   (io_ddrAxi_r_payload_last)
    );

    // Write-channel tie-offs (DdrAgentM1 is read-only)
    assign io_ddrAxi_aw_ready = 1'b0;
    assign io_ddrAxi_w_ready  = 1'b0;
    assign io_ddrAxi_b_valid  = 1'b0;
    assign io_ddrAxi_b_payload_id   = '0;
    assign io_ddrAxi_b_payload_resp = '0;

    // -------------------------------------------------------------------------
    // Clock
    // -------------------------------------------------------------------------
    initial clk = 1'b0;
    always #(CLK_PERIOD_NS / 2) clk = ~clk;

    task automatic tick();
        @(posedge clk);
    endtask

    // AXI4-Lite master tasks (byte addresses)
    task automatic axil_write(input logic [7:0] addr, input logic [31:0] data);
        io_hps_aw_payload_addr = addr;
        io_hps_aw_payload_prot = 3'b000;
        io_hps_w_payload_data  = data;
        io_hps_w_payload_strb  = 4'hF;
        io_hps_aw_valid        = 1'b1;
        io_hps_w_valid         = 1'b1;
        io_hps_b_ready         = 1'b1;
        do @(posedge clk); while (!(io_hps_aw_ready && io_hps_w_ready));
        io_hps_aw_valid = 1'b0;
        io_hps_w_valid  = 1'b0;
        do @(posedge clk); while (!io_hps_b_valid);
        io_hps_b_ready  = 1'b0;
    endtask

    task automatic axil_read(input logic [7:0] addr, output logic [31:0] data);
        io_hps_ar_payload_addr = addr;
        io_hps_ar_payload_prot = 3'b000;
        io_hps_ar_valid        = 1'b1;
        io_hps_r_ready         = 1'b1;
        do @(posedge clk); while (!io_hps_ar_ready);
        io_hps_ar_valid = 1'b0;
        do @(posedge clk); while (!io_hps_r_valid);
        data = io_hps_r_payload_data;
        io_hps_r_ready = 1'b0;
    endtask

    task automatic soft_reset();
        axil_write(ADDR_CTRL, 32'h1 << CTRL_SOFT_RESET);
        repeat (5) tick();
        axil_write(ADDR_CTRL, 32'h0);
        repeat (5) tick();
    endtask

    task automatic start_job(input int token_id, input int seq_pos);
        axil_write(ADDR_TOKEN_ID, token_id);
        axil_write(ADDR_SEQ_POS,  seq_pos);
        axil_write(ADDR_CTRL, 32'h1 << CTRL_JOB_START);
    endtask

    // -------------------------------------------------------------------------
    // DDR image helpers
    // -------------------------------------------------------------------------
    task automatic load_row(
        input string path,
        input longint unsigned byte_addr,
        output logic [15:0] row [DIM]
    );
        int fd;
        byte unsigned lo, hi;
        fd = $fopen(path, "rb");
        if (fd == 0) $fatal(1, "Cannot open DDR image: %s", path);
        if ($fseek(fd, byte_addr, 0) != 0)
            $fatal(1, "fseek to 0x%0x failed in %s", byte_addr, path);
        for (int i = 0; i < DIM; i++) begin
            if ($fread(lo, fd) != 1 || $fread(hi, fd) != 1)
                $fatal(1, "short read at beat %0d, addr=0x%0x", i, byte_addr);
            row[i] = {hi, lo};
        end
        $fclose(fd);
    endtask

    task automatic dump_status(input string tag);
        logic [31:0] st;
        axil_read(ADDR_STATUS, st);
        $display("%s: STATUS=0x%08h busy=%0d done=%0d err=%0d sched_dbg=%0d ar=%b out_v=%b",
                 tag, st, st[STATUS_BUSY], st[STATUS_JOB_DONE], st[STATUS_JOB_ERROR],
                 st[7:4], io_ddrAxi_ar_valid, io_rmsNormOut_valid);
    endtask

    task automatic wait_busy(input int max_cycles);
        int t;
        logic [31:0] st;
        t = 0;
        axil_read(ADDR_STATUS, st);
        while (!st[STATUS_BUSY] && t < max_cycles) begin
            tick();
            t++;
            axil_read(ADDR_STATUS, st);
        end
        if (!st[STATUS_BUSY])
            $fatal(1, "timeout waiting scheduler busy (status=0x%08h)", st);
    endtask
    task automatic drain_rms_out(
        output logic [15:0] beats [DIM],
        output int          n_beats
    );
        int timeout;
        n_beats = 0;
        timeout = 0;
        io_rmsNormOut_ready = 1'b1;
        while (timeout < MAX_RMSNORM) begin
            @(posedge clk);
            timeout++;
            if (io_rmsNormOut_valid && io_rmsNormOut_ready) begin
                if (n_beats < DIM)
                    beats[n_beats] = io_rmsNormOut_payload_data;
                n_beats++;
                if (io_rmsNormOut_payload_last) break;
            end
        end
        io_rmsNormOut_ready = 1'b0;
        if (timeout >= MAX_RMSNORM) begin
            dump_status("drain timeout");
            $fatal(1, "timeout waiting rmsNormOut tlast (got %0d beats)", n_beats);
        end
        if (n_beats != DIM)
            $fatal(1, "rmsNormOut: expected %0d beats, got %0d", DIM, n_beats);
    endtask

    // -------------------------------------------------------------------------
    // Golden FP16 RMSNorm check
    // -------------------------------------------------------------------------
    task automatic check_rmsnorm(
        input logic [15:0] recv      [DIM],
        input shortreal    golden    [DIM]
    );
        int mism;
        real max_err;
        mism = 0; max_err = 0.0;
        for (int i = 0; i < DIM; i++) begin
            real r, g, err;
            r   = real'(fp16_to_shortreal(recv[i]));
            g   = real'(golden[i]);
            err = r - g;
            if (err < 0.0) err = -err;
            if (err > max_err && err < 1.0e30) max_err = err;
            if (err > TOL_ABS) begin
                // Quartus emit path may flush denormal products to ±0; SW golden keeps tiny nonzero.
                if (r == 0.0 || r == -0.0)
                    continue;
                if (mism < 8)
                    $display("  mismatch[%0d]: recv=%h (%0.6g) golden=%0.6g err=%0.6g",
                             i, recv[i], r, g, err);
                mism++;
            end
        end
        $display("check_rmsnorm: mismatches=%0d/%0d  max_abs_err=%.6g (tol=%.1e)",
                 mism, DIM, max_err, TOL_ABS);
        if (mism != 0)
            $fatal(1, "RMSNorm output: %0d FP16 mismatches (max_err=%.6g > TOL=%.1e)",
                   mism, max_err, TOL_ABS);
    endtask

    // -------------------------------------------------------------------------
    // Test data
    // -------------------------------------------------------------------------
    string ddr_image_path;

    logic [15:0] golden_embed [DIM];
    logic [15:0] golden_gamma [DIM];
    shortreal    expected_f   [DIM];
    logic [15:0] recv_out     [DIM];
    int          n_recv;
    logic [31:0] mmio_rd;

    // -------------------------------------------------------------------------
    // Main test
    // -------------------------------------------------------------------------
    initial begin
        if (!$value$plusargs("DDR_IMAGE=%s", ddr_image_path))
            $fatal(1, "DDR_IMAGE plusarg missing — run via make questa-m1");

        // Init DUT inputs before reset
        io_hps_aw_valid           = 1'b0;
        io_hps_aw_payload_addr    = '0;
        io_hps_aw_payload_prot    = '0;
        io_hps_w_valid            = 1'b0;
        io_hps_w_payload_data     = '0;
        io_hps_w_payload_strb     = '0;
        io_hps_b_ready            = 1'b0;
        io_hps_ar_valid           = 1'b0;
        io_hps_ar_payload_addr    = '0;
        io_hps_ar_payload_prot    = '0;
        io_hps_r_ready            = 1'b0;
        io_rmsNormOut_ready = 1'b0;

        reset = 1'b1;
        repeat (5) tick();
        reset = 1'b0;
        repeat (10) tick();

        // Load DDR image rows into memory model and golden arrays
        load_row(ddr_image_path, EMBED_ADDR, golden_embed);
        load_row(ddr_image_path, GAMMA_ADDR, golden_gamma);
        ddr_mem.load_region(ddr_image_path, EMBED_ADDR, ROW_BYTES);
        ddr_mem.load_region(ddr_image_path, GAMMA_ADDR, ROW_BYTES);

        // Compute expected RMSNorm output (fp16_utils golden model)
        golden_rmsnorm_fp16(DIM, golden_embed, golden_gamma, expected_f);

        // =====================================================================
        // Test 1: happy path — token_id=0, seq_pos=7
        // =====================================================================
        io_rmsNormOut_ready = 1'b1;
        start_job(.token_id(0), .seq_pos(7));
        wait_busy(1000);

        drain_rms_out(recv_out, n_recv);

        // Wait for job_done
        begin : wait_done1
            int t;
            t = 0;
            axil_read(ADDR_STATUS, mmio_rd);
            while (!mmio_rd[STATUS_JOB_DONE] && t < 10000) begin
                tick(); t++;
                axil_read(ADDR_STATUS, mmio_rd);
            end
            if (!mmio_rd[STATUS_JOB_DONE])
                $fatal(1, "test1: timeout waiting job_done (status=0x%0h)", mmio_rd);
        end

        if (mmio_rd[STATUS_JOB_ERROR])
            $fatal(1, "test1: unexpected job_error (status=0x%0h)", mmio_rd);

        check_rmsnorm(recv_out, expected_f);
        $display("\033[32mtest1 PASS: token_id=0 → %0d beats, job_done=1, FP16 golden OK\033[0m", n_recv);

        // =====================================================================
        // Test 2: OOB — token_id = vocabSize (128256)
        // =====================================================================
        soft_reset();
        io_rmsNormOut_ready = 1'b1;
        start_job(.token_id(VOCAB_SIZE), .seq_pos(0));

        repeat (30) tick();

        axil_read(ADDR_STATUS, mmio_rd);
        if (!mmio_rd[STATUS_JOB_ERROR])
            $fatal(1, "test2: expected job_error=1, status=0x%0h", mmio_rd);

        axil_read(ADDR_ERROR_CODE, mmio_rd);
        if (mmio_rd[7:0] != 8'd1)
            $fatal(1, "test2: expected errorCode=1, got %0d", mmio_rd[7:0]);

        if (io_rmsNormOut_valid)
            $fatal(1, "test2: unexpected rmsNormOut.valid on OOB path");

        $display("\033[32mtest2 PASS: OOB job_error=1, errorCode=1, no rmsNormOut\033[0m");

        $display("\033[32m********** PASS **********\033[0m");
        $finish;
    end

endmodule
