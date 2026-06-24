# Compile Spinal-generated DdrAgentM1 RTL + Questa testbench.

if {![info exists QUESTA_DIR]} {
    if {![info exists env(DDR_AGENT_QUESTA_DIR)] || $env(DDR_AGENT_QUESTA_DIR) eq ""} {
        echo "ERROR: DDR_AGENT_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(DDR_AGENT_QUESTA_DIR)] paths.tcl]
}

set _axi_w 256
if {[info exists env(DDR_AGENT_AXI_WIDTH)] && $env(DDR_AGENT_AXI_WIDTH) ne ""} {
    set _axi_w $env(DDR_AGENT_AXI_WIDTH)
}

vlog -work work -sv +define+QUESTA_SIM +define+DDR_AGENT_AXI_WIDTH=${_axi_w} \
    [file join $QUESTA_DIR axi_read_mem.sv] \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_ddr_agent_m1.sv]

echo "DUT + TB compile done (AXI width=${_axi_w})."
