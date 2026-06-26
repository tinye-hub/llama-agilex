# Full compile + simulate the selected GEMV DUT with Altera FP IPs.
# Usage (from test/questa):  GEMV_DUT=mac vsim -c -do run_sim.do
# Or: ./run.sh mac | ./run.sh service

onerror {quit -code 1}

set DO_WAVE 0
set WLF_FILE ""
if {[info exists env(QUESTA_WAVE)] && $env(QUESTA_WAVE) ne ""} {
    set DO_WAVE 1
}

if {![info exists env(GEMV_QUESTA_DIR)] || $env(GEMV_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh (sets GEMV_QUESTA_DIR)"
    exit 1
}
set QUESTA_DIR [file normalize $env(GEMV_QUESTA_DIR)]

set _dut mac
if {[info exists env(GEMV_DUT)] && $env(GEMV_DUT) ne ""} {
    set _dut $env(GEMV_DUT)
}
switch -- $_dut {
    mac     { set TB_TOP tb_gemv_mac_beat }
    service { set TB_TOP tb_gemv_service64 }
    default { echo "ERROR: unknown GEMV_DUT '$_dut'"; exit 1 }
}

source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_ips.tcl]
source [file join $QUESTA_DIR compile_dut.tcl]

# Elaborate with Verilog megafunction libs only (see rmsNorm run_axi.do rationale).
set elab_libs [list \
    work \
    altera_fp_functions_19110 \
    agilex_native_floating_point_dsp_100 \
    lpm_ver sgate_ver altera_ver altera_mf_ver altera_lnsim_ver \
    tennm_ver tennm_hvio_ver tennm_sm_hps_ver tennm_sm4_hssi_ver \
    tennm_fmm3_hssi_ver tennm_revb_hvio_ver tennm_revb_io96_ver \
    tennm_agilex5_io96_ver tennm_agilex5_hssi_a_ver \
]

set elab_cmd "vsim -work work"
foreach lib $elab_libs {
    append elab_cmd " -L $lib"
}
if {$DO_WAVE} {
    append elab_cmd " -voptargs=+acc"
    if {[info exists env(QUESTA_WLF)] && $env(QUESTA_WLF) ne ""} {
        set WLF_FILE [file normalize $env(QUESTA_WLF)]
    } else {
        set WLF_FILE [file join $WORK_DIR ${TB_TOP}.wlf]
    }
    append elab_cmd " -wlf \"$WLF_FILE\""
}
append elab_cmd " $TB_TOP"

echo $elab_cmd
eval $elab_cmd

if {$DO_WAVE} {
    echo "Recording waveform to $WLF_FILE"
    log -r /*
}

run -all

if {$DO_WAVE} {
    echo "Waveform saved: $WLF_FILE"
}
quit -code 0
