# Compile Quartus FP IPs + LlamaM2aTop Verilog + M2a testbench.

if {![info exists QUESTA_DIR]} {
    if {![info exists env(LLAMA_M1_QUESTA_DIR)] || $env(LLAMA_M1_QUESTA_DIR) eq ""} {
        echo "ERROR: LLAMA_M1_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(LLAMA_M1_QUESTA_DIR)] paths.tcl]
}

set GEN_TOP_V [file join $TOP_DIR gen verilog LlamaM2aTop.v]
if {![file exists $GEN_TOP_V]} {
    echo "ERROR: missing $GEN_TOP_V — run: make verilog-m2a (from src/scala/top)"
    exit 1
}

set _k 2048
set _m 2048
if {[info exists env(LLAMA_M2A_DIM)] && $env(LLAMA_M2A_DIM) ne ""} { set _k $env(LLAMA_M2A_DIM) }
if {[info exists env(LLAMA_M2A_M)] && $env(LLAMA_M2A_M) ne ""} { set _m $env(LLAMA_M2A_M) }

if {![info exists ::LLAMA_M1_QUESTA_SKIP_IP]} {
    set _save_questa_dir $QUESTA_DIR
    set QUESTA_DIR $RMSNORM_QUESTA_DIR
    source [file join $RMSNORM_QUESTA_DIR compile_ips.tcl]
    set QUESTA_DIR $_save_questa_dir
}

vlog -work work -sv +define+GEMV_K=${_k} +define+GEMV_M=${_m} \
    -L altera_fp_functions_19110 \
    -L agilex_native_floating_point_dsp_100 \
    [file join $RMSNORM_QUESTA_DIR fp16_utils.sv] \
    [file join $DDRAGENT_QUESTA_DIR axi_read_mem.sv] \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_llama_m2a_top.sv]

echo "LlamaM2aTop DUT + TB compile done (K=${_k} M=${_m})."
