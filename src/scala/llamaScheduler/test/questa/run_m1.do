# Full compile + simulate LlamaSchedulerM1 unit test.
# Usage (from test/questa):  vsim -c -do run_m1.do
# Or: ./run.sh m1

onerror {quit -code 1}

set DO_WAVE 0
set WLF_FILE ""
if {[info exists env(QUESTA_WAVE)] && $env(QUESTA_WAVE) ne ""} {
    set DO_WAVE 1
}

if {![info exists env(LLAMA_SCHED_QUESTA_DIR)] || $env(LLAMA_SCHED_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh (sets LLAMA_SCHED_QUESTA_DIR)"
    exit 1
}
set QUESTA_DIR [file normalize $env(LLAMA_SCHED_QUESTA_DIR)]

source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_dut.tcl]

set elab_cmd "vsim -work work"
if {$DO_WAVE} {
    append elab_cmd " -voptargs=+acc"
    if {[info exists env(QUESTA_WLF)] && $env(QUESTA_WLF) ne ""} {
        set WLF_FILE [file normalize $env(QUESTA_WLF)]
    } else {
        set WLF_FILE [file join $WORK_DIR tb_llama_scheduler_m1.wlf]
    }
    append elab_cmd " -wlf \"$WLF_FILE\""
}
append elab_cmd " tb_llama_scheduler_m1"

echo $elab_cmd
eval $elab_cmd

if {$DO_WAVE} {
    echo "Recording waveform to $WLF_FILE"
    log -r /*
}

run -all

if {$DO_WAVE} {
    echo "Waveform saved: $WLF_FILE"
}
quit -code 0
