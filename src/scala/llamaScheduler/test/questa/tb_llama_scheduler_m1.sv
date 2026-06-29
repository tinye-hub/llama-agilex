// Questa unit testbench for LlamaSchedulerM1 — mirrors llamaScheduler.LlamaSchedulerM1Sim.
// Validates MemCmd sequencing, axis_ctx, token_id OOB, and FSM completion.

`timescale 1ns/1ps

module tb_llama_scheduler_m1;

    localparam int ROW_BYTES     = 4096;
    localparam longint EMB_ADDR  = 64'h0000_0000;
    localparam longint GAMMA_ADDR = 64'h1F50_0000;
    localparam int SINK_EMBED    = 0;
    localparam int SINK_GAMMA    = 1;
    localparam int CMD_READ      = 0;
    localparam int VOCAB_SIZE    = 128256;
    localparam int ERR_TOKEN_OOB = 1;
    localparam int CLK_PERIOD_NS = 10;

    logic clk;
    logic reset;

    logic        io_jobStart;
    logic        io_jobAbort;
    logic        io_softResetSched;
    logic [16:0] io_tokenId;
    logic [9:0]  io_seqPos;
    logic [1:0]  io_jobPhase;
    logic [9:0]  io_promptLen;

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

    logic        io_rmsNormOutLast;

    logic        io_busy;
    logic        io_jobDoneSticky;
    logic        io_jobErrorSticky;
    logic [7:0]  io_errorCode;
    logic [3:0]  io_schedStateDbg;

    typedef struct packed {
        int sinkId;
        longint unsigned ddrAddr;
        int byteLen;
        int axisCtx;
    } captured_cmd_t;

    captured_cmd_t cmds[$];
    int fail_count;

    LlamaSchedulerM1 dut (
        .io_jobStart                   (io_jobStart),
        .io_jobAbort                   (io_jobAbort),
        .io_softResetSched             (io_softResetSched),
        .io_tokenId                    (io_tokenId),
        .io_seqPos                     (io_seqPos),
        .io_jobPhase                   (io_jobPhase),
        .io_promptLen                  (io_promptLen),
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
        .io_rmsNormOutLast             (io_rmsNormOutLast),
        .io_busy                       (io_busy),
        .io_jobDoneSticky              (io_jobDoneSticky),
        .io_jobErrorSticky             (io_jobErrorSticky),
        .io_errorCode                  (io_errorCode),
        .io_schedStateDbg              (io_schedStateDbg),
        .clk                           (clk),
        .reset                         (reset)
    );

    initial clk = 1'b0;
    always #(CLK_PERIOD_NS / 2) clk = ~clk;

    task automatic tick();
        @(posedge clk);
    endtask

    task automatic init_dut();
        io_jobStart       = 1'b0;
        io_jobAbort       = 1'b0;
        io_softResetSched = 1'b0;
        io_tokenId        = '0;
        io_seqPos         = '0;
        io_jobPhase       = '0;
        io_promptLen      = '0;
        io_memCmd_ready   = 1'b1;
        io_memDone_valid  = 1'b0;
        io_memDone_payload_tag    = '0;
        io_memDone_payload_error  = '0;
        io_memDone_payload_sinkId = '0;
        io_rmsNormOutLast = 1'b0;
    endtask

    task automatic pulse_job_start(input int token_id, input int seq_pos = 0);
        io_tokenId = token_id[16:0];
        io_seqPos  = seq_pos[9:0];
        tick();
        io_jobStart = 1'b1;
        tick();
        io_jobStart = 1'b0;
    endtask

    task automatic capture_mem_cmds(input int expected, input int max_cycles = 200);
        int timeout;
        captured_cmd_t c;
        timeout = 0;
        cmds.delete();
        while (cmds.size() < expected && timeout < max_cycles) begin
            if (io_memCmd_valid && io_memCmd_ready) begin
                if (io_memCmd_payload_cmdType !== CMD_READ[7:0]) begin
                    $display("FAIL: cmdType=%0d expected READ", io_memCmd_payload_cmdType);
                    fail_count++;
                end
                c.sinkId  = io_memCmd_payload_sinkId;
                c.ddrAddr = io_memCmd_payload_ddrAddr;
                c.byteLen = io_memCmd_payload_byteLen;
                c.axisCtx = io_memCmd_payload_axisCtx;
                cmds.push_back(c);
            end
            tick();
            timeout++;
        end
        if (cmds.size() !== expected) begin
            $display("FAIL: expected %0d MemCmd(s), got %0d (timeout=%0d)", expected, cmds.size(), timeout);
            fail_count++;
        end
    endtask

    task automatic drive_mem_dones(input int count);
        int done;
        done = 0;
        while (done < count) begin
            tick();
            if (io_memDone_ready) begin
                io_memDone_valid = 1'b1;
                io_memDone_payload_sinkId = done[7:0];
                tick();
                io_memDone_valid = 1'b0;
                done++;
            end
        end
    endtask

    task automatic await_sched_state(input int expected, input int max_cycles = 500);
        int timeout;
        timeout = 0;
        while (timeout < max_cycles) begin
            tick();
            timeout++;
            if (io_schedStateDbg === expected[3:0]) return;
        end
        $display("FAIL: timeout waiting schedStateDbg=%0d (got %0d)", expected, io_schedStateDbg);
        fail_count++;
    endtask

    task automatic check_eq_int(input string label, input int got, input int expected);
        if (got !== expected) begin
            $display("FAIL: %s: got %0d expected %0d", label, got, expected);
            fail_count++;
        end
    endtask

    task automatic check_eq_long(input string label, input longint unsigned got, input longint unsigned expected);
        if (got !== expected) begin
            $display("FAIL: %s: got %0h expected %0h", label, got, expected);
            fail_count++;
        end
    endtask

    initial begin
        int seq_pos;
        int expected_ctx;

        fail_count = 0;
        reset = 1'b1;
        init_dut();
        repeat (5) tick();
        reset = 1'b0;
        repeat (5) tick();

        // --- Happy path: token_id=0, seqPos=42 ---
        seq_pos = 42;
        pulse_job_start(0, seq_pos);
        capture_mem_cmds(2);

        if (cmds.size() >= 2) begin
            check_eq_int("sinkId embed", cmds[0].sinkId, SINK_EMBED);
            check_eq_long("ddrAddr embed", cmds[0].ddrAddr, EMB_ADDR);
            check_eq_int("byteLen embed", cmds[0].byteLen, ROW_BYTES);
            check_eq_int("sinkId gamma", cmds[1].sinkId, SINK_GAMMA);
            check_eq_long("ddrAddr gamma", cmds[1].ddrAddr, GAMMA_ADDR);
            check_eq_int("byteLen gamma", cmds[1].byteLen, ROW_BYTES);

            expected_ctx = (0 << 9) | seq_pos; // norm1=0
            check_eq_int("axis_ctx embed", cmds[0].axisCtx, expected_ctx);
            check_eq_int("axis_ctx gamma", cmds[1].axisCtx, expected_ctx);
        end

        drive_mem_dones(2);
        await_sched_state(3); // WAIT_RMSNORM

        io_rmsNormOutLast = 1'b1;
        tick();
        io_rmsNormOutLast = 1'b0;
        await_sched_state(4); // JOB_DONE

        if (!io_jobDoneSticky) begin
            $display("FAIL: job_done not sticky");
            fail_count++;
        end
        if (io_jobErrorSticky) begin
            $display("FAIL: unexpected job_error");
            fail_count++;
        end

        io_jobStart = 1'b0;
        tick();
        await_sched_state(0); // IDLE

        // --- OOB path: token_id = vocabSize ---
        pulse_job_start(VOCAB_SIZE);
        tick();
        if (!io_jobErrorSticky) begin
            $display("FAIL: job_error not set on OOB token_id");
            fail_count++;
        end
        check_eq_int("error_code OOB", io_errorCode, ERR_TOKEN_OOB);
        check_eq_int("schedState JOB_DONE on OOB", io_schedStateDbg, 4);
        if (io_memCmd_valid) begin
            $display("FAIL: MemCmd valid on OOB");
            fail_count++;
        end

        io_jobStart = 1'b0;
        tick();
        await_sched_state(0);

        if (fail_count == 0) begin
            $display("\033[32m********** PASS **********\033[0m");
        end else begin
            $display("\033[31m********** FAIL **********\033[0m (%0d checks)", fail_count);
        end
        $finish;
    end

endmodule
