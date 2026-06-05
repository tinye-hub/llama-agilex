# Compile Spinal-generated RMSNorm RTL + testbench.

if {![info exists QUESTA_DIR]} {
    if {![info exists env(RMSNORM_QUESTA_DIR)] || $env(RMSNORM_QUESTA_DIR) eq ""} {
        echo "ERROR: RMSNORM_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(RMSNORM_QUESTA_DIR)] paths.tcl]
}

if {![info exists ::RMSNORM_QUESTA_SKIP_IP]} {
    source [file join $QUESTA_DIR compile_ips.tcl]
}

set _dim 2048
if {[info exists env(RMSNORM_DIM)] && $env(RMSNORM_DIM) ne ""} {
    set _dim $env(RMSNORM_DIM)
}

vlog -work work -sv +define+QUESTA_SIM +define+RMSNORM_DIM=${_dim} \
    -L altera_fp_functions_19110 \
    -L agilex_native_floating_point_dsp_100 \
    [file join $QUESTA_DIR fp16_utils.sv] \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_rmsnorm_axi.sv]

echo "DUT + TB compile done."
