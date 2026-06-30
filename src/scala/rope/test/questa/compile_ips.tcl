# Compile Quartus FP IPs (shared with rmsNorm / gemvService64).

source [file join $QUESTA_DIR compile_quartus_vhdl_libs.tcl]

proc ensure_lib {lib} {
    if {![file exists $lib]} {
        vlib $lib
    }
}

proc vcom_ip_vhdl {qip_dir top_vhd} {
    global QUARTUS_IP_DIR
    set base [file join $QUARTUS_IP_DIR $qip_dir altera_fp_functions_19110 synth]
    set lib altera_fp_functions_19110
    ensure_lib $lib
    vcom -work $lib -2008 -suppress 2583 [file join $base $top_vhd]
}

proc vlog_ip {qip_dir args} {
    global QUARTUS_IP_DIR
    set files {}
    foreach f $args {
        lappend files [file join $QUARTUS_IP_DIR $qip_dir $f]
    }
    vlog -work work -sv \
        -L altera_fp_functions_19110 \
        -L agilex_native_floating_point_dsp_100 \
        {*}$files
}

ensure_lib work
ensure_lib altera_fp_functions_19110
ensure_lib agilex_native_floating_point_dsp_100

set dspba_base [file join $QUARTUS_IP_DIR fp16ToFp32 altera_fp_functions_19110 synth]
vcom -work altera_fp_functions_19110 -2008 -suppress 2583 \
    [file join $dspba_base dspba_library_package.vhd] \
    [file join $dspba_base dspba_library.vhd]

vcom_ip_vhdl fp16ToFp32 fp16ToFp32_altera_fp_functions_19110_jikm5oq.vhd
vcom_ip_vhdl fp32ToFp16 fp32ToFp16_altera_fp_functions_19110_qtmnoha.vhd

vlog -work agilex_native_floating_point_dsp_100 \
    $QUARTUS_IP_DIR/fp32MultAcc/agilex_native_floating_point_dsp_100/synth/fp32MultAcc_agilex_native_floating_point_dsp_100_sa6roxq.v \
    $QUARTUS_IP_DIR/fp32Add/agilex_native_floating_point_dsp_100/synth/fp32Add_agilex_native_floating_point_dsp_100_m5fvifq.v

vlog_ip fp16ToFp32 synth/fp16ToFp32.v
vlog_ip fp32ToFp16 synth/fp32ToFp16.v
vlog_ip fp32MultAcc synth/fp32MultAcc.v
vlog_ip fp32Add synth/fp32Add.v

echo "RoPE IP compile done."
