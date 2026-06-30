# Compile Spinal-generated RoPE RTL + testbench.

if {![info exists QUESTA_DIR]} {
    source [file join [file normalize $env(ROPE_QUESTA_DIR)] paths.tcl]
}

source [file join $QUESTA_DIR compile_ips.tcl]

set _head 64
set _maxpos 1024
if {[info exists env(ROPE_HEAD_DIM)] && $env(ROPE_HEAD_DIM) ne ""} {
    set _head $env(ROPE_HEAD_DIM)
}
if {[info exists env(ROPE_MAX_POS)] && $env(ROPE_MAX_POS) ne ""} {
    set _maxpos $env(ROPE_MAX_POS)
}

vlog -work work -sv +define+QUESTA_SIM \
    +define+ROPE_HEAD_DIM=${_head} +define+ROPE_MAX_POS=${_maxpos} \
    -L altera_fp_functions_19110 \
    -L agilex_native_floating_point_dsp_100 \
    $FP16_UTILS \
    $GEN_TOP_V \
    [file join $QUESTA_DIR tb_serial_rope_axi.sv]

echo "RoPE DUT + TB compile done."
