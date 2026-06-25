# Compile Quartus FP IPs + LlamaM1Top Verilog + testbench.

if {![info exists QUESTA_DIR]} {
    if {![info exists env(LLAMA_M1_QUESTA_DIR)] || $env(LLAMA_M1_QUESTA_DIR) eq ""} {
        echo "ERROR: LLAMA_M1_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(LLAMA_M1_QUESTA_DIR)] paths.tcl]
}

# Compile Quartus FP IPs by reusing rmsNorm's compile_ips.tcl.
# compile_ips.tcl internally calls "source [file join $QUESTA_DIR compile_quartus_vhdl_libs.tcl]",
# so QUESTA_DIR must point to rmsNorm/questa/ for the duration of that source call.
if {![info exists ::LLAMA_M1_QUESTA_SKIP_IP]} {
    set _save_questa_dir $QUESTA_DIR
    set QUESTA_DIR $RMSNORM_QUESTA_DIR
    source [file join $RMSNORM_QUESTA_DIR compile_ips.tcl]
    set QUESTA_DIR $_save_questa_dir
}

# Compile LlamaM1Top + fp16_utils + axi_read_mem + testbench.
vlog -work work -sv \
    -L altera_fp_functions_19110 \
    -L agilex_native_floating_point_dsp_100 \
    [file join $RMSNORM_QUESTA_DIR fp16_utils.sv] \
    [file join $DDRAGENT_QUESTA_DIR axi_read_mem.sv] \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_llama_m1_top.sv]

echo "LlamaM1Top DUT + TB compile done."
