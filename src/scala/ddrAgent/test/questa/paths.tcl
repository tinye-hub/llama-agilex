# Repository paths for DdrAgent Questa simulation.
# QUESTA_DIR must come from run.sh (DDR_AGENT_QUESTA_DIR).

if {![info exists env(DDR_AGENT_QUESTA_DIR)] || $env(DDR_AGENT_QUESTA_DIR) eq ""} {
    echo "ERROR: DDR_AGENT_QUESTA_DIR not set — run via ./run.sh or export it before vsim -do"
    exit 1
}
set QUESTA_DIR [file normalize $env(DDR_AGENT_QUESTA_DIR)]
set DDR_AGENT_TEST_DIR [file dirname $QUESTA_DIR]
set DDR_AGENT_DIR [file dirname $DDR_AGENT_TEST_DIR]
set REPO_ROOT [file normalize [file join $DDR_AGENT_DIR ../../..]]

set GEN_VERILOG_DIR [file join $DDR_AGENT_DIR gen verilog]
set GEN_TOP_V [file join $GEN_VERILOG_DIR DdrAgentM1.v]
set WORK_DIR [file join $QUESTA_DIR work]
set DEFAULT_DDR_IMAGE [file join $REPO_ROOT tools ddr_pack out ddr_image_m1.bin]

if {![file exists $GEN_TOP_V]} {
    echo "ERROR: missing $GEN_TOP_V — run: make verilog (from src/scala/ddrAgent)"
    exit 1
}

file mkdir $WORK_DIR
cd $WORK_DIR

if {![file exists work]} {
    vlib work
}

set ::env(DDR_AGENT_QUESTA_WORK) $WORK_DIR
