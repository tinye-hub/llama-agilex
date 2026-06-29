# Repository paths for LlamaScheduler Questa simulation.
# QUESTA_DIR must come from run.sh (LLAMA_SCHED_QUESTA_DIR).

if {![info exists env(LLAMA_SCHED_QUESTA_DIR)] || $env(LLAMA_SCHED_QUESTA_DIR) eq ""} {
    echo "ERROR: LLAMA_SCHED_QUESTA_DIR not set — run via ./run.sh or export it before vsim -do"
    exit 1
}
set QUESTA_DIR [file normalize $env(LLAMA_SCHED_QUESTA_DIR)]
set SCHED_TEST_DIR [file dirname $QUESTA_DIR]
set SCHED_DIR [file dirname $SCHED_TEST_DIR]
set REPO_ROOT [file normalize [file join $SCHED_DIR ../../..]]

set GEN_VERILOG_DIR [file join $SCHED_DIR gen verilog]
set GEN_TOP_V [file join $GEN_VERILOG_DIR LlamaSchedulerM1.v]
set WORK_DIR [file join $QUESTA_DIR work]

if {![file exists $GEN_TOP_V]} {
    echo "ERROR: missing $GEN_TOP_V — run: make verilog (from src/scala/llamaScheduler)"
    exit 1
}

file mkdir $WORK_DIR
cd $WORK_DIR

if {![file exists work]} {
    vlib work
}

set ::env(LLAMA_SCHED_QUESTA_WORK) $WORK_DIR
