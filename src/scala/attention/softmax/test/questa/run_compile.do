onerror {quit -code 1}

if {![info exists env(SOFTMAX_QUESTA_DIR)] || $env(SOFTMAX_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh"
    exit 1
}
set QUESTA_DIR [file normalize $env(SOFTMAX_QUESTA_DIR)]
source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_dut.tcl]
quit -code 0
