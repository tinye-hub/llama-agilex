# Compile Spinal-generated DdrAgentM2 RTL + Questa M2a testbench.

if {![info exists QUESTA_DIR]} {
    if {![info exists env(DDR_AGENT_QUESTA_DIR)] || $env(DDR_AGENT_QUESTA_DIR) eq ""} {
        echo "ERROR: DDR_AGENT_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(DDR_AGENT_QUESTA_DIR)] paths.tcl]
}

set GEN_TOP_V [file join $GEN_VERILOG_DIR DdrAgentM2.v]
if {![file exists $GEN_TOP_V]} {
    echo "ERROR: missing $GEN_TOP_V — run: make verilog-m2a (from src/scala/ddrAgent)"
    exit 1
}

set _axi_w 256
if {[info exists env(DDR_AGENT_AXI_WIDTH)] && $env(DDR_AGENT_AXI_WIDTH) ne ""} {
    set _axi_w $env(DDR_AGENT_AXI_WIDTH)
}

vlog -work work -sv +define+QUESTA_SIM +define+DDR_AGENT_AXI_WIDTH=${_axi_w} \
    [file join $QUESTA_DIR axi_read_mem.sv] \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_ddr_agent_m2a.sv]

echo "DdrAgentM2 + M2a TB compile done (AXI width=${_axi_w})."
