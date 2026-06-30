# Compile Fp32ExpDivSmokeTop + testbench.

if {![info exists QUESTA_DIR]} {
    if {![info exists env(UTIL_QUESTA_DIR)] || $env(UTIL_QUESTA_DIR) eq ""} {
        echo "ERROR: UTIL_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(UTIL_QUESTA_DIR)] paths.tcl]
}

if {![info exists ::UTIL_QUESTA_SKIP_IP]} {
    source [file join $QUESTA_DIR compile_ips.tcl]
}

vlog -work work -sv +define+QUESTA_SIM \
    -L altera_fp_functions_19110 \
    -L agilex_native_floating_point_dsp_100 \
    [file join $QUESTA_DIR fp32_utils.sv] \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_fp32_exp_div.sv]

echo "Fp32ExpDivSmokeTop DUT + TB compile done."
