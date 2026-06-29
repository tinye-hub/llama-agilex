// Questa testbench for DdrAgentM2 — M1 row sinks + GEMV_WEIGHT 32 B tile reads.
// Golden: ddr_fixture.bin (embed/gamma rows + W_Q(0) INT4 tiles).

`timescale 1ns/1ps

module tb_ddr_agent_m2a;

`ifdef DDR_AGENT_AXI_WIDTH
    localparam int AXI_DATA_W = `DDR_AGENT_AXI_WIDTH;
`else
    localparam int AXI_DATA_W = 256;
`endif

    localparam int DIM           = 2048;
    localparam int ROW_BYTES     = 4096;
    localparam int TILE_BYTES    = 32;
    localparam int TILE_COUNT    = 4;
    localparam longint EMBED_ADDR = 64'h0000_0000;
    localparam longint GAMMA_ADDR = 64'h1F50_0000;
    localparam longint WQ_BASE    = 64'h2000_0000;
    localparam int SINK_EMBED    = 0;
    localparam int SINK_GAMMA    = 1;
    localparam int SINK_GEMV     = 2;
    localparam int CMD_READ      = 0;
    localparam int CLK_PERIOD_NS = 10;
    localparam int MAX_DRAIN     = DIM * 200;

    logic clk;
    logic reset;

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

    logic                   io_weightBeat_valid;
    logic                   io_weightBeat_ready;
    logic [AXI_DATA_W-1:0]  io_weightBeat_payload;

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
    bit [AXI_DATA_W-1:0] golden_tiles [TILE_COUNT];
    bit [AXI_DATA_W-1:0] recv_tile;

    DdrAgentM2 dut (
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
        .io_weightBeat_valid           (io_weightBeat_valid),
        .io_weightBeat_ready           (io_weightBeat_ready),
        .io_weightBeat_payload         (io_weightBeat_payload),
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
        .io_axi_b_payload_resp         (io_axi_b_payload_resp),
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
        .io_axi_r_payload_resp         (io_axi_r_payload_resp),
        .io_axi_r_payload_last         (io_axi_r_payload_last),
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

    task automatic load_tile_goldens(input string path);
        int fd;
        int t, b;
        byte unsigned byte_val;
        begin
            fd = $fopen(path, "rb");
            if (fd == 0)
                $fatal(1, "Cannot open DDR image %s", path);
            for (t = 0; t < TILE_COUNT; t++) begin
                if ($fseek(fd, WQ_BASE + t * TILE_BYTES, 0) != 0)
                    $fatal(1, "fseek tile %0d failed", t);
                golden_tiles[t] = '0;
                for (b = 0; b < TILE_BYTES; b++) begin
                    if ($fread(byte_val, fd) != 1)
                        $fatal(1, "short read tile %0d byte %0d", t, b);
                    golden_tiles[t][8*b +: 8] = byte_val;
                end
            end
            $fclose(fd);
        end
    endtask

    task automatic push_mem_cmd(
        input int sink_id,
        input longint unsigned ddr_addr,
        input int byte_len,
        input int tag,
        input int axis_ctx
    );
        begin
            io_memCmd_valid               = 1'b1;
            io_memCmd_payload_cmdType     = CMD_READ[7:0];
            io_memCmd_payload_sinkId      = sink_id[7:0];
            io_memCmd_payload_byteLen     = byte_len[31:0];
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

            if (beat_count != DIM)
                $fatal(1, "%s: expected %0d beats, got %0d",
                       is_embed ? "embed" : "gamma", DIM, beat_count);
        end
    endtask

    task automatic drain_weight_beat(output bit [AXI_DATA_W-1:0] beat);
        int timeout;
        begin
            io_weightBeat_ready = 1'b1;
            timeout = 0;
            beat = '0;
            while (timeout < 50000) begin
                tick();
                timeout++;
                if (io_weightBeat_valid && io_weightBeat_ready) begin
                    beat = io_weightBeat_payload;
                    break;
                end
            end
            io_weightBeat_ready = 1'b0;
            if (timeout >= 50000)
                $fatal(1, "timeout waiting weightBeat");
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
            while (io_memDone_valid) begin
                tick();
            end
            io_memDone_ready = 1'b0;
            if (timeout >= 500000)
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
            $display("tb_ddr_agent_m2a %s: mismatches=%0d/%0d", name, mism, DIM);
            if (mism != 0)
                $fatal(1, "%s: %0d FP16 bit mismatches vs DDR image", name, mism);
            check_row = mism;
        end
    endfunction

    int n_embed;
    int n_gamma;
    int mism_embed;
    int mism_gamma;
    int tile_idx;
    int tile_ok;

    initial begin
        if (!$value$plusargs("DDR_IMAGE=%s", ddr_image_path))
            $fatal(1, "DDR_IMAGE plusarg missing — run via make questa-m2a or ./run.sh m2a");

        io_memCmd_valid           = 1'b0;
        io_memCmd_payload_cmdType = '0;
        io_memCmd_payload_sinkId  = '0;
        io_memCmd_payload_byteLen = '0;
        io_memCmd_payload_ddrAddr = '0;
        io_memCmd_payload_tag     = '0;
        io_memCmd_payload_axisCtx = '0;
        io_embedOut_ready         = 1'b0;
        io_gammaOut_ready         = 1'b0;
        io_weightBeat_ready       = 1'b0;
        io_memDone_ready          = 1'b0;

        reset = 1'b1;
        repeat (5) tick();
        reset = 1'b0;
        repeat (10) tick();

        load_row_golden(ddr_image_path, EMBED_ADDR, golden_embed);
        load_row_golden(ddr_image_path, GAMMA_ADDR, golden_gamma);
        load_tile_goldens(ddr_image_path);
        ddr_mem.load_region(ddr_image_path, EMBED_ADDR, ROW_BYTES);
        ddr_mem.load_region(ddr_image_path, GAMMA_ADDR, ROW_BYTES);
        ddr_mem.load_region(ddr_image_path, WQ_BASE, TILE_COUNT * TILE_BYTES);

        io_embedOut_ready = 1'b1;
        io_gammaOut_ready = 1'b1;

        push_mem_cmd(SINK_EMBED, EMBED_ADDR, ROW_BYTES, 1, 16'h0001);
        drain_axis(1'b1, recv_embed, n_embed);
        await_mem_done(SINK_EMBED);

        push_mem_cmd(SINK_GAMMA, GAMMA_ADDR, ROW_BYTES, 2, 16'h0002);
        drain_axis(1'b0, recv_gamma, n_gamma);
        await_mem_done(SINK_GAMMA);

        tile_ok = 0;
        for (tile_idx = 0; tile_idx < TILE_COUNT; tile_idx++) begin
            push_mem_cmd(SINK_GEMV, WQ_BASE + tile_idx * TILE_BYTES, TILE_BYTES,
                         10 + tile_idx, 16'h0000);
            drain_weight_beat(recv_tile);
            await_mem_done(SINK_GEMV);
            if (recv_tile !== golden_tiles[tile_idx]) begin
                $display("tile %0d mismatch: got %0h expected %0h",
                         tile_idx, recv_tile, golden_tiles[tile_idx]);
                $fatal(1, "GEMV tile %0d mismatch", tile_idx);
            end
            tile_ok++;
        end
        $display("tb_ddr_agent_m2a gemv tiles: %0d/%0d OK", tile_ok, TILE_COUNT);

        mism_embed = check_row(recv_embed, golden_embed, "embed");
        mism_gamma = check_row(recv_gamma, golden_gamma, "gamma");

        $display("\033[32m********** PASS **********\033[0m");
        #1;
        $finish;
    end

endmodule
