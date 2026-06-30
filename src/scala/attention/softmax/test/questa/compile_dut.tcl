# Compile Spinal-generated SerialSafeSoftmax RTL + testbench.

if {![info exists QUESTA_DIR]} {
    source [file join [file normalize $env(SOFTMAX_QUESTA_DIR)] paths.tcl]
}

source [file join $QUESTA_DIR compile_ips.tcl]

vlog -work work -sv +define+QUESTA_SIM \
    -L altera_fp_functions_19110 \
    -L agilex_native_floating_point_dsp_100 \
    $FP16_UTILS \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_serial_safe_softmax_axi.sv]

echo "SerialSafeSoftmax DUT + TB compile done."
