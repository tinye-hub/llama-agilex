# Shared Quartus altera_fp_functions + Agilex native FP DSP compile for Questa.
# Sourced from module test/questa/compile_ips.tcl (rmsNorm, util, …).

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

# Symlink IP memory-init hex files into Questa work dir (altera_lnsim opens by basename).
proc link_fp_ip_hex_mems {work_dir qip_dir hex_names} {
    global QUARTUS_IP_DIR
    set mem_dir [file join $QUARTUS_IP_DIR $qip_dir altera_fp_functions_19110 synth]
    foreach hex $hex_names {
        set src [file join $mem_dir $hex]
        if {![file exists $src]} {
            echo "ERROR: missing memory init $src"
            exit 1
        }
        set dst [file join $work_dir $hex]
        if {![file exists $dst]} {
            file link -symbolic $dst $src
        }
    }
}

proc compile_altera_fp_ips {} {
    global QUARTUS_IP_DIR

    ensure_lib work
    ensure_lib altera_fp_functions_19110
    ensure_lib agilex_native_floating_point_dsp_100

    set dspba_base [file join $QUARTUS_IP_DIR fp16ToFp32 altera_fp_functions_19110 synth]
    vcom -work altera_fp_functions_19110 -2008 -suppress 2583 \
        [file join $dspba_base dspba_library_package.vhd] \
        [file join $dspba_base dspba_library.vhd]

    vcom_ip_vhdl fp16ToFp32 fp16ToFp32_altera_fp_functions_19110_jikm5oq.vhd
    vcom_ip_vhdl fp32ToFp16 fp32ToFp16_altera_fp_functions_19110_qtmnoha.vhd
    vcom_ip_vhdl fp32Rsqrt  fp32Rsqrt_altera_fp_functions_19110_5fbcymq.vhd
    vcom_ip_vhdl fp32Exp   fp32Exp_altera_fp_functions_19110_fz7lzha.vhd
    vcom_ip_vhdl fp32Div   fp32Div_altera_fp_functions_19110_etcsazy.vhd

    vlog -work agilex_native_floating_point_dsp_100 \
        $QUARTUS_IP_DIR/fp32MultAcc/agilex_native_floating_point_dsp_100/synth/fp32MultAcc_agilex_native_floating_point_dsp_100_sa6roxq.v \
        $QUARTUS_IP_DIR/fp32Add/agilex_native_floating_point_dsp_100/synth/fp32Add_agilex_native_floating_point_dsp_100_m5fvifq.v

    vlog_ip fp16ToFp32   synth/fp16ToFp32.v
    vlog_ip fp32ToFp16   synth/fp32ToFp16.v
    vlog_ip fp32Rsqrt    synth/fp32Rsqrt.v
    vlog_ip fp32Exp      synth/fp32Exp.v
    vlog_ip fp32Div      synth/fp32Div.v
    vlog_ip fp32MultAcc  synth/fp32MultAcc.v
    vlog_ip fp32Add      synth/fp32Add.v

    echo "altera_fp_ips compile done."
}
