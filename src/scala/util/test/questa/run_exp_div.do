# Full compile + simulate Fp32ExpDivSmokeTop.

onerror {quit -code 1}

if {![info exists env(UTIL_QUESTA_DIR)] || $env(UTIL_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh"
    exit 1
}
set QUESTA_DIR [file normalize $env(UTIL_QUESTA_DIR)]

source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_ips.tcl]
source [file join $QUESTA_DIR compile_dut.tcl]

set elab_libs [list \
    work \
    altera_fp_functions_19110 \
    agilex_native_floating_point_dsp_100 \
    lpm_ver sgate_ver altera_ver altera_mf_ver altera_lnsim_ver \
    tennm_ver tennm_hvio_ver tennm_sm_hps_ver tennm_sm4_hssi_ver \
    tennm_fmm3_hssi_ver tennm_revb_hvio_ver tennm_revb_io96_ver \
    tennm_agilex5_io96_ver tennm_agilex5_hssi_a_ver \
]

set elab_cmd "vsim -c -t 1ps"
foreach lib $elab_libs {
    append elab_cmd " -L $lib"
}
append elab_cmd " tb_fp32_exp_div"

echo $elab_cmd
eval $elab_cmd

run -all
quit -code 0
