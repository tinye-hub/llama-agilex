onerror {quit -code 1}
source [file join [file normalize $env(ROPE_QUESTA_DIR)] paths.tcl]
source [file join $QUESTA_DIR compile_ips.tcl]
source [file join $QUESTA_DIR compile_dut.tcl]
quit -code 0
