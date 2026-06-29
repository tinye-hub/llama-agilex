# Compile only (DUT + TB). Useful after RTL edits without re-running sim.
onerror {quit -code 1}

if {![info exists env(LLAMA_SCHED_QUESTA_DIR)] || $env(LLAMA_SCHED_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh (sets LLAMA_SCHED_QUESTA_DIR)"
    exit 1
}
set QUESTA_DIR [file normalize $env(LLAMA_SCHED_QUESTA_DIR)]

source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_dut.tcl]

echo "Compile finished in $WORK_DIR"
quit -code 0
