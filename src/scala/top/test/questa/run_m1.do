# Full compile + simulate LlamaM1Top M1 graduation test.
# Usage: vsim -c -do run_m1.do   (via run.sh m1)

onerror {quit -code 1}

set DO_WAVE 0
set WLF_FILE ""
if {[info exists env(QUESTA_WAVE)] && $env(QUESTA_WAVE) ne ""} {
    set DO_WAVE 1
}

if {![info exists env(LLAMA_M1_QUESTA_DIR)] || $env(LLAMA_M1_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh (sets LLAMA_M1_QUESTA_DIR)"
    exit 1
}
set QUESTA_DIR [file normalize $env(LLAMA_M1_QUESTA_DIR)]

source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_dut.tcl]

if {[info exists env(DDR_IMAGE)] && $env(DDR_IMAGE) ne ""} {
    set DDR_IMAGE [file normalize $env(DDR_IMAGE)]
} else {
    set DDR_IMAGE $DEFAULT_DDR_IMAGE
}
if {![file exists $DDR_IMAGE]} {
    echo "ERROR: DDR image not found: $DDR_IMAGE"
    echo "Run: make -C $REPO_ROOT/tools/ddr_pack pack-m1"
    exit 1
}
echo "DDR_IMAGE=$DDR_IMAGE"

set elab_libs [list \
    work \
    altera_fp_functions_19110 \
    agilex_native_floating_point_dsp_100 \
    lpm_ver sgate_ver altera_ver altera_mf_ver altera_lnsim_ver \
    tennm_ver tennm_hvio_ver tennm_sm_hps_ver tennm_sm4_hssi_ver \
    tennm_fmm3_hssi_ver tennm_revb_hvio_ver tennm_revb_io96_ver \
    tennm_agilex5_io96_ver tennm_agilex5_hssi_a_ver \
]

set elab_cmd "vsim -work work +DDR_IMAGE=$DDR_IMAGE"
foreach lib $elab_libs {
    append elab_cmd " -L $lib"
}
if {$DO_WAVE} {
    append elab_cmd " -voptargs=+acc"
    if {[info exists env(QUESTA_WLF)] && $env(QUESTA_WLF) ne ""} {
        set WLF_FILE [file normalize $env(QUESTA_WLF)]
    } else {
        set WLF_FILE [file join $WORK_DIR tb_llama_m1_top.wlf]
    }
    append elab_cmd " -wlf \"$WLF_FILE\""
}
append elab_cmd " tb_llama_m1_top"

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
