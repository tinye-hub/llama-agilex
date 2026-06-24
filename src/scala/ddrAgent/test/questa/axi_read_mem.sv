// Byte-sparse AXI4 read-only slave for DdrAgent Questa simulation.
//
// r_valid / r_data / r_last / ar_ready are combinational (no registered-output
// race); only the burst pointer (state / beat_idx / beat_addr) is sequential.
// Beat index 0..ar_len inclusive = ar_len+1 transfers per AXI4 spec.

`timescale 1ns/1ps

module axi_read_mem #(
    parameter int ADDR_W  = 32,
    parameter int DATA_W  = 256,
    parameter int ID_W    = 4
) (
    input  wire                   clk,
    input  wire                   reset,

    output logic                  ar_ready,
    input  wire                   ar_valid,
    input  wire [ADDR_W-1:0]      ar_addr,
    input  wire [ID_W-1:0]        ar_id,
    input  wire [7:0]             ar_len,
    input  wire [2:0]             ar_size,
    input  wire [1:0]             ar_burst,

    output logic                  r_valid,
    input  wire                   r_ready,
    output logic [DATA_W-1:0]     r_data,
    output logic [ID_W-1:0]       r_id,
    output logic [1:0]            r_resp,
    output logic                  r_last
);

    localparam int BEAT_BYTES = DATA_W / 8;

    typedef enum logic { ST_IDLE, ST_BURST } state_t;

    byte unsigned mem [longint unsigned];

    state_t            state;
    logic [7:0]        latched_len;
    logic [7:0]        beat_idx;
    longint unsigned   beat_addr;
    logic [ID_W-1:0]   hold_id;

    int ar_cnt;
    int r_cnt;
    bit dbg;

    function automatic logic [DATA_W-1:0] read_beat(input longint unsigned addr);
        logic [DATA_W-1:0] data;
        int b;
        begin
            data = '0;
            for (b = 0; b < BEAT_BYTES; b++) begin
                if (mem.exists(addr + longint'(b)))
                    data[b*8 +: 8] = mem[addr + longint'(b)];
            end
            read_beat = data;
        end
    endfunction

    task automatic load_region(input string path, input longint unsigned base, input int nbytes);
        int fd;
        int i;
        byte unsigned b;
        begin
            fd = $fopen(path, "rb");
            if (fd == 0)
                $fatal(1, "axi_read_mem: cannot open %s", path);
            if ($fseek(fd, base, 0) != 0)
                $fatal(1, "axi_read_mem: fseek to 0x%0h failed in %s", base, path);
            for (i = 0; i < nbytes; i++) begin
                if ($fread(b, fd) != 1)
                    $fatal(1, "axi_read_mem: short read @0x%0h+%0d in %s", base, i, path);
                mem[base + longint'(i)] = b;
            end
            $fclose(fd);
            $display("axi_read_mem: loaded %0d bytes @0x%0h from %s", nbytes, base, path);
        end
    endtask

    initial begin
        dbg = $test$plusargs("DDR_AGENT_DEBUG");
    end

    // --- Combinational outputs (no registered-output handshake race) ---------
    always_comb begin
        ar_ready = (state == ST_IDLE);
        if (state == ST_BURST) begin
            r_valid = 1'b1;
            r_data  = read_beat(beat_addr);
            r_last  = (beat_idx == latched_len);
        end else begin
            r_valid = 1'b0;
            r_data  = '0;
            r_last  = 1'b0;
        end
        r_id   = hold_id;
        r_resp = 2'b00;
    end

    // --- Sequential burst pointer --------------------------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= ST_IDLE;
            latched_len <= 8'd0;
            beat_idx    <= 8'd0;
            beat_addr   <= '0;
            hold_id     <= '0;
            ar_cnt      <= 0;
            r_cnt       <= 0;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (ar_valid) begin
                        state       <= ST_BURST;
                        latched_len <= ar_len;
                        beat_idx    <= 8'd0;
                        beat_addr   <= longint'(ar_addr);
                        hold_id     <= ar_id;
                        ar_cnt      <= ar_cnt + 1;
                        if (dbg)
                            $display("axi_read_mem: AR #%0d addr=0x%0h ar_len=%0d beats=%0d @%0t",
                                     ar_cnt, ar_addr, ar_len, ar_len + 1, $time);
                    end
                end

                ST_BURST: begin
                    // r_valid is combinationally high here; advance on real transfer.
                    if (r_ready) begin
                        r_cnt <= r_cnt + 1;
                        if (dbg && (r_cnt < 4 || beat_idx == latched_len))
                            $display("axi_read_mem: R #%0d idx=%0d/%0d addr=0x%0h last=%b @%0t",
                                     r_cnt + 1, beat_idx, latched_len,
                                     beat_addr, (beat_idx == latched_len), $time);

                        if (beat_idx == latched_len) begin
                            state <= ST_IDLE;
                        end else begin
                            beat_idx  <= beat_idx + 8'd1;
                            beat_addr <= beat_addr + longint'(BEAT_BYTES);
                        end
                    end
                end

                default: state <= ST_IDLE;
            endcase
        end
    end

endmodule
