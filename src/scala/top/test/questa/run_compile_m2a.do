# Compile only (LlamaM2aTop + M2a TB).
onerror {quit -code 1}

if {![info exists env(LLAMA_M1_QUESTA_DIR)] || $env(LLAMA_M1_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh"
    exit 1
}
set QUESTA_DIR [file normalize $env(LLAMA_M1_QUESTA_DIR)]

source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_dut_m2a.tcl]

echo "M2a compile finished in $WORK_DIR"
quit -code 0
