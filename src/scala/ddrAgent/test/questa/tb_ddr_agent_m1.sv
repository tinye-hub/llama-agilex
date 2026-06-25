// Questa testbench for DdrAgentM1 — mirrors ddrAgent.DdrAgentM1Sim (Verilator).
// Golden vectors: ddr_image_m1.bin @ fixed DDR row addresses.

`timescale 1ns/1ps

module tb_ddr_agent_m1;

`ifdef DDR_AGENT_AXI_WIDTH
    localparam int AXI_DATA_W = `DDR_AGENT_AXI_WIDTH;
`else
    localparam int AXI_DATA_W = 256;
`endif

    localparam int DIM           = 2048;
    localparam int ROW_BYTES     = 4096;
    localparam longint EMBED_ADDR = 64'h0000_0000;
    localparam longint GAMMA_ADDR = 64'h1F50_0000;
    localparam int SINK_EMBED    = 0;
    localparam int SINK_GAMMA    = 1;
    localparam int CMD_READ      = 0;
    localparam int CLK_PERIOD_NS = 10;
    localparam int MAX_DRAIN     = DIM * 200;

    logic clk;
    logic reset;

    // MemCmd / MemDone
    logic        io_memCmd_valid;
    logic        io_memCmd_ready;
    logic [7:0]  io_memCmd_payload_cmdType;
    logic [7:0]  io_memCmd_payload_sinkId;
    logic [31:0] io_memCmd_payload_byteLen;
    logic [31:0] io_memCmd_payload_ddrAddr;
    logic [31:0] io_memCmd_payload_tag;
    logic [15:0] io_memCmd_payload_axisCtx;

    logic        io_memDone_valid;
    logic        io_memDone_ready;
    logic [31:0] io_memDone_payload_tag;
    logic [7:0]  io_memDone_payload_error;
    logic [7:0]  io_memDone_payload_sinkId;

    // embedOut / gammaOut (AXI-Stream)
    logic        io_embedOut_valid;
    logic        io_embedOut_ready;
    logic [15:0] io_embedOut_payload_data;
    logic [1:0]  io_embedOut_payload_keep;
    logic        io_embedOut_payload_last;
    logic [31:0] io_embedOut_payload_user;

    logic        io_gammaOut_valid;
    logic        io_gammaOut_ready;
    logic [15:0] io_gammaOut_payload_data;
    logic [1:0]  io_gammaOut_payload_keep;
    logic        io_gammaOut_payload_last;
    logic [31:0] io_gammaOut_payload_user;

    // AXI4 master (DUT) → read slave (memory model)
    logic                   io_axi_aw_valid;
    logic                   io_axi_aw_ready;
    logic [31:0]            io_axi_aw_payload_addr;
    logic [3:0]             io_axi_aw_payload_id;
    logic [7:0]             io_axi_aw_payload_len;
    logic [2:0]             io_axi_aw_payload_size;
    logic [1:0]             io_axi_aw_payload_burst;

    logic                   io_axi_w_valid;
    logic                   io_axi_w_ready;
    logic [AXI_DATA_W-1:0]  io_axi_w_payload_data;
    logic                   io_axi_w_payload_last;

    logic                   io_axi_b_valid;
    logic                   io_axi_b_ready;
    logic [3:0]             io_axi_b_payload_id;
    logic [1:0]             io_axi_b_payload_resp;

    logic                   io_axi_ar_valid;
    logic                   io_axi_ar_ready;
    logic [31:0]            io_axi_ar_payload_addr;
    logic [3:0]             io_axi_ar_payload_id;
    logic [7:0]             io_axi_ar_payload_len;
    logic [2:0]             io_axi_ar_payload_size;
    logic [1:0]             io_axi_ar_payload_burst;

    logic                   io_axi_r_valid;
    logic                   io_axi_r_ready;
    logic [AXI_DATA_W-1:0]  io_axi_r_payload_data;
    logic [3:0]             io_axi_r_payload_id;
    logic [1:0]             io_axi_r_payload_resp;
    logic                   io_axi_r_payload_last;

    string ddr_image_path;
    bit [15:0] golden_embed [DIM];
    bit [15:0] golden_gamma [DIM];
    bit [15:0] recv_embed  [DIM];
    bit [15:0] recv_gamma  [DIM];

    DdrAgentM1 dut (
        .io_memCmd_valid               (io_memCmd_valid),
        .io_memCmd_ready               (io_memCmd_ready),
        .io_memCmd_payload_cmdType     (io_memCmd_payload_cmdType),
        .io_memCmd_payload_sinkId      (io_memCmd_payload_sinkId),
        .io_memCmd_payload_byteLen     (io_memCmd_payload_byteLen),
        .io_memCmd_payload_ddrAddr     (io_memCmd_payload_ddrAddr),
        .io_memCmd_payload_tag         (io_memCmd_payload_tag),
        .io_memCmd_payload_axisCtx     (io_memCmd_payload_axisCtx),
        .io_memDone_valid              (io_memDone_valid),
        .io_memDone_ready              (io_memDone_ready),
        .io_memDone_payload_tag        (io_memDone_payload_tag),
        .io_memDone_payload_error      (io_memDone_payload_error),
        .io_memDone_payload_sinkId     (io_memDone_payload_sinkId),
        .io_embedOut_valid             (io_embedOut_valid),
        .io_embedOut_ready             (io_embedOut_ready),
        .io_embedOut_payload_data      (io_embedOut_payload_data),
        .io_embedOut_payload_keep      (io_embedOut_payload_keep),
        .io_embedOut_payload_last      (io_embedOut_payload_last),
        .io_embedOut_payload_user      (io_embedOut_payload_user),
        .io_gammaOut_valid             (io_gammaOut_valid),
        .io_gammaOut_ready             (io_gammaOut_ready),
        .io_gammaOut_payload_data      (io_gammaOut_payload_data),
        .io_gammaOut_payload_keep      (io_gammaOut_payload_keep),
        .io_gammaOut_payload_last      (io_gammaOut_payload_last),
        .io_gammaOut_payload_user      (io_gammaOut_payload_user),
        .io_axi_aw_valid               (io_axi_aw_valid),
        .io_axi_aw_ready               (io_axi_aw_ready),
        .io_axi_aw_payload_addr        (io_axi_aw_payload_addr),
        .io_axi_aw_payload_id          (io_axi_aw_payload_id),
        .io_axi_aw_payload_len         (io_axi_aw_payload_len),
        .io_axi_aw_payload_size        (io_axi_aw_payload_size),
        .io_axi_aw_payload_burst       (io_axi_aw_payload_burst),
        .io_axi_w_valid                (io_axi_w_valid),
        .io_axi_w_ready                (io_axi_w_ready),
        .io_axi_w_payload_data         (io_axi_w_payload_data),
        .io_axi_w_payload_last         (io_axi_w_payload_last),
        .io_axi_b_valid                (io_axi_b_valid),
        .io_axi_b_ready                (io_axi_b_ready),
        .io_axi_b_payload_id           (io_axi_b_payload_id),
        .io_axi_b_payload_resp       (io_axi_b_payload_resp),
        .io_axi_ar_valid               (io_axi_ar_valid),
        .io_axi_ar_ready               (io_axi_ar_ready),
        .io_axi_ar_payload_addr        (io_axi_ar_payload_addr),
        .io_axi_ar_payload_id          (io_axi_ar_payload_id),
        .io_axi_ar_payload_len         (io_axi_ar_payload_len),
        .io_axi_ar_payload_size        (io_axi_ar_payload_size),
        .io_axi_ar_payload_burst       (io_axi_ar_payload_burst),
        .io_axi_r_valid                (io_axi_r_valid),
        .io_axi_r_ready                (io_axi_r_ready),
        .io_axi_r_payload_data         (io_axi_r_payload_data),
        .io_axi_r_payload_id           (io_axi_r_payload_id),
        .io_axi_r_payload_resp       (io_axi_r_payload_resp),
        .io_axi_r_payload_last       (io_axi_r_payload_last),
        .clk                           (clk),
        .reset                         (reset)
    );

    axi_read_mem #(
        .DATA_W (AXI_DATA_W)
    ) ddr_mem (
        .clk          (clk),
        .reset        (reset),
        .ar_ready     (io_axi_ar_ready),
        .ar_valid     (io_axi_ar_valid),
        .ar_addr      (io_axi_ar_payload_addr),
        .ar_id        (io_axi_ar_payload_id),
        .ar_len       (io_axi_ar_payload_len),
        .ar_size      (io_axi_ar_payload_size),
        .ar_burst     (io_axi_ar_payload_burst),
        .r_valid      (io_axi_r_valid),
        .r_ready      (io_axi_r_ready),
        .r_data       (io_axi_r_payload_data),
        .r_id         (io_axi_r_payload_id),
        .r_resp       (io_axi_r_payload_resp),
        .r_last       (io_axi_r_payload_last)
    );

    assign io_axi_aw_ready = 1'b0;
    assign io_axi_w_ready  = 1'b0;
    assign io_axi_b_valid  = 1'b0;
    assign io_axi_b_payload_id   = '0;
    assign io_axi_b_payload_resp = '0;

    initial clk = 1'b0;
    always #(CLK_PERIOD_NS / 2) clk = ~clk;

    task automatic tick();
        @(posedge clk);
    endtask

    task automatic load_row_golden(
        input string path,
        input longint unsigned byte_addr,
        output bit [15:0] golden [DIM]
    );
        int fd;
        int i;
        byte unsigned lo, hi;
        begin
            fd = $fopen(path, "rb");
            if (fd == 0)
                $fatal(1, "Cannot open DDR image %s", path);
            if ($fseek(fd, byte_addr, 0) != 0)
                $fatal(1, "fseek to 0x%0h failed in %s", byte_addr, path);
            for (i = 0; i < DIM; i++) begin
                if ($fread(lo, fd) != 1 || $fread(hi, fd) != 1)
                    $fatal(1, "short read row @0x%0h beat %0d", byte_addr, i);
                golden[i] = {hi, lo};
            end
            $fclose(fd);
        end
    endtask

    task automatic push_mem_cmd(
        input int sink_id,
        input longint unsigned ddr_addr,
        input int tag,
        input int axis_ctx
    );
        begin
            io_memCmd_valid               = 1'b1;
            io_memCmd_payload_cmdType     = CMD_READ[7:0];
            io_memCmd_payload_sinkId      = sink_id[7:0];
            io_memCmd_payload_byteLen     = ROW_BYTES;
            io_memCmd_payload_ddrAddr     = ddr_addr[31:0];
            io_memCmd_payload_tag         = tag[31:0];
            io_memCmd_payload_axisCtx     = axis_ctx[15:0];
            while (!io_memCmd_ready) tick();
            tick();
            io_memCmd_valid = 1'b0;
        end
    endtask

    task automatic drain_axis(
        input  bit is_embed,
        output bit [15:0] beats [DIM],
        output int beat_count
    );
        int i;
        int timeout;
        begin
            beat_count = 0;
            timeout    = 0;
            if (is_embed)
                io_embedOut_ready = 1'b1;
            else
                io_gammaOut_ready = 1'b1;

            while (beat_count < DIM && timeout < MAX_DRAIN) begin
                tick();
                timeout++;
                if (is_embed) begin
                    if (io_embedOut_valid && io_embedOut_ready) begin
                        beats[beat_count] = io_embedOut_payload_data;
                        beat_count++;
                    end
                end else begin
                    if (io_gammaOut_valid && io_gammaOut_ready) begin
                        beats[beat_count] = io_gammaOut_payload_data;
                        beat_count++;
                    end
                end
            end

            if (is_embed)
                io_embedOut_ready = 1'b0;
            else
                io_gammaOut_ready = 1'b0;

            if (beat_count != DIM) begin
                dump_dut_status(is_embed ? "embed drain timeout" : "gamma drain timeout");
                $fatal(1, "%s: expected %0d beats, got %0d (timeout=%0d)",
                       is_embed ? "embed" : "gamma", DIM, beat_count, timeout);
            end
        end
    endtask

    task automatic await_mem_done(input int expected_sink);
        int timeout;
        begin
            io_memDone_ready = 1'b1;
            timeout = 0;
            while (!io_memDone_valid && timeout < 500000) begin
                tick();
                timeout++;
            end
            io_memDone_ready = 1'b0;
            if (!io_memDone_valid)
                $fatal(1, "timeout waiting MemDone sink=%0d", expected_sink);
            if (io_memDone_payload_sinkId != expected_sink[7:0])
                $fatal(1, "MemDone sink %0d != %0d",
                       io_memDone_payload_sinkId, expected_sink);
        end
    endtask

    function automatic int check_row(
        input bit [15:0] got [DIM],
        input bit [15:0] golden [DIM],
        input string name
    );
        int mism;
        int j;
        begin
            mism = 0;
            for (j = 0; j < DIM; j++)
                if (got[j] !== golden[j])
                    mism++;
            $display("tb_ddr_agent_m1 %s: mismatches=%0d/%0d", name, mism, DIM);
            if (mism != 0)
                $fatal(1, "%s: %0d FP16 bit mismatches vs DDR image", name, mism);
            check_row = mism;
        end
    endfunction

    int n_embed;
    int n_gamma;
    int mism_embed;
    int mism_gamma;

    // -------------------------------------------------------------------------
    // Log-based debug (enable: +DDR_AGENT_DEBUG or auto-dump on failure)
    // -------------------------------------------------------------------------
    int sim_cycle;
    int ar_fire_cnt;
    int r_fire_cnt;

    function automatic string state_name(input logic [2:0] st);
        case (st)
            3'd0: state_name = "IDLE";
            3'd1: state_name = "AXI_AR";
            3'd2: state_name = "AXI_R";
            3'd3: state_name = "STREAM";
            3'd4: state_name = "DONE";
            default: state_name = "?";
        endcase
    endfunction

    task automatic dump_dut_status(input string tag);
        begin
            $display("--- DUT status [%s] @%0t cycle=%0d ---", tag, $time, sim_cycle);
            $display("  state=%s bytesRead=%0d streamBeat=%0d sinkId=%0d",
                     state_name(dut.state_1), dut.bytesRead, dut.streamBeat, dut.sinkId);
            $display("  memCmd: valid=%b ready=%b  memDone: valid=%b ready=%b",
                     io_memCmd_valid, io_memCmd_ready, io_memDone_valid, io_memDone_ready);
            $display("  AXI AR: valid=%b ready=%b addr=0x%0h len=%0d",
                     io_axi_ar_valid, io_axi_ar_ready,
                     io_axi_ar_payload_addr, io_axi_ar_payload_len);
            $display("  AXI R:  valid=%b ready=%b last=%b  (fires: ar=%0d r=%0d)",
                     io_axi_r_valid, io_axi_r_ready, io_axi_r_payload_last,
                     ar_fire_cnt, r_fire_cnt);
            $display("  embedOut: valid=%b ready=%b  gammaOut: valid=%b ready=%b",
                     io_embedOut_valid, io_embedOut_ready,
                     io_gammaOut_valid, io_gammaOut_ready);
            $display("  cmdFifo pop_valid=%b pop_ready=%b occupancy=%0d",
                     dut.cmdFifo_io_pop_valid, dut.cmdFifo_io_pop_ready,
                     dut.cmdFifo_io_occupancy);
        end
    endtask

    always @(posedge clk) begin
        if (reset)
            sim_cycle <= 0;
        else
            sim_cycle <= sim_cycle + 1;
    end

    always @(posedge clk) begin
        if (!reset) begin
            if (io_axi_ar_valid && io_axi_ar_ready) begin
                ar_fire_cnt <= ar_fire_cnt + 1;
                if ($test$plusargs("DDR_AGENT_DEBUG"))
                    $display("TB: AR fire #%0d addr=0x%0h @%0t",
                             ar_fire_cnt + 1, io_axi_ar_payload_addr, $time);
            end
            if (io_axi_r_valid && io_axi_r_ready) begin
                r_fire_cnt <= r_fire_cnt + 1;
                if ($test$plusargs("DDR_AGENT_DEBUG") &&
                    (r_fire_cnt < 3 || io_axi_r_payload_last))
                    $display("TB: R fire #%0d last=%b bytesRead=%0d state=%s @%0t",
                             r_fire_cnt + 1, io_axi_r_payload_last,
                             dut.bytesRead, state_name(dut.state_1), $time);
            end
        end
    end

    initial begin
        if (!$value$plusargs("DDR_IMAGE=%s", ddr_image_path))
            $fatal(1, "DDR_IMAGE plusarg missing — run via make questa or ./run.sh m1");

        // Drive all DUT inputs before reset release (same as DdrAgentM1Sim.scala).
        io_memCmd_valid           = 1'b0;
        io_memCmd_payload_cmdType = '0;
        io_memCmd_payload_sinkId  = '0;
        io_memCmd_payload_byteLen = '0;
        io_memCmd_payload_ddrAddr = '0;
        io_memCmd_payload_tag     = '0;
        io_memCmd_payload_axisCtx = '0;
        io_embedOut_ready         = 1'b0;
        io_gammaOut_ready         = 1'b0;
        io_memDone_ready          = 1'b0;

        reset = 1'b1;
        ar_fire_cnt = 0;
        r_fire_cnt  = 0;
        repeat (5) tick();
        reset = 1'b0;
        repeat (10) tick();

        load_row_golden(ddr_image_path, EMBED_ADDR, golden_embed);
        load_row_golden(ddr_image_path, GAMMA_ADDR, golden_gamma);
        ddr_mem.load_region(ddr_image_path, EMBED_ADDR, ROW_BYTES);
        ddr_mem.load_region(ddr_image_path, GAMMA_ADDR, ROW_BYTES);

        io_embedOut_ready = 1'b1;
        io_gammaOut_ready = 1'b1;

        push_mem_cmd(SINK_EMBED, EMBED_ADDR, 1, 16'h0001);
        drain_axis(1'b1, recv_embed, n_embed);
        await_mem_done(SINK_EMBED);

        push_mem_cmd(SINK_GAMMA, GAMMA_ADDR, 2, 16'h0002);
        drain_axis(1'b0, recv_gamma, n_gamma);
        await_mem_done(SINK_GAMMA);

        mism_embed = check_row(recv_embed, golden_embed, "embed");
        mism_gamma = check_row(recv_gamma, golden_gamma, "gamma");

        $display("\033[32m********** PASS **********\033[0m");
        $finish;
    end

endmodule
