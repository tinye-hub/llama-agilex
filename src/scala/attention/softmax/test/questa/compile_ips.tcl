# Compile Quartus FP IPs for attention softmax (shared script + Agilex DSP).

if {![info exists QUESTA_DIR]} {
    source [file join [file normalize $env(SOFTMAX_QUESTA_DIR)] paths.tcl]
}

compile_altera_fp_ips

echo "attention IP compile done."
