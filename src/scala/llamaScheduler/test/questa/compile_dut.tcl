# Compile Spinal-generated LlamaSchedulerM1 RTL + Questa testbench.

if {![info exists QUESTA_DIR]} {
    if {![info exists env(LLAMA_SCHED_QUESTA_DIR)] || $env(LLAMA_SCHED_QUESTA_DIR) eq ""} {
        echo "ERROR: LLAMA_SCHED_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(LLAMA_SCHED_QUESTA_DIR)] paths.tcl]
}

vlog -work work -sv +define+QUESTA_SIM \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_llama_scheduler_m1.sv]

echo "DUT + TB compile done."
