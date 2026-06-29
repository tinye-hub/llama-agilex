# Full compile + simulate DdrAgentM2 (M2a GEMV_WEIGHT tile reads).
# Usage: ./run.sh m2a

onerror {quit -code 1}

set DO_WAVE 0
set WLF_FILE ""
if {[info exists env(QUESTA_WAVE)] && $env(QUESTA_WAVE) ne ""} {
    set DO_WAVE 1
}

if {![info exists env(DDR_AGENT_QUESTA_DIR)] || $env(DDR_AGENT_QUESTA_DIR) eq ""} {
    echo "ERROR: run via test/questa/run.sh (sets DDR_AGENT_QUESTA_DIR)"
    exit 1
}
set QUESTA_DIR [file normalize $env(DDR_AGENT_QUESTA_DIR)]

source [file join $QUESTA_DIR paths.tcl]
source [file join $QUESTA_DIR compile_dut_m2a.tcl]

set DEFAULT_M2A_DDR [file join $REPO_ROOT tools ddr_pack out ddr_fixture.bin]

if {[info exists env(DDR_IMAGE)] && $env(DDR_IMAGE) ne ""} {
    set DDR_IMAGE [file normalize $env(DDR_IMAGE)]
} else {
    set DDR_IMAGE $DEFAULT_M2A_DDR
}
if {![file exists $DDR_IMAGE]} {
    echo "ERROR: DDR image not found: $DDR_IMAGE"
    echo "Run: make -C $REPO_ROOT/tools/ddr_pack fixture"
    exit 1
}
echo "DDR_IMAGE=$DDR_IMAGE"

set elab_cmd "vsim -work work +DDR_IMAGE=$DDR_IMAGE"
if {[info exists env(DDR_AGENT_DEBUG)] && $env(DDR_AGENT_DEBUG) ne ""} {
    append elab_cmd " +DDR_AGENT_DEBUG"
}
if {$DO_WAVE} {
    append elab_cmd " -voptargs=+acc"
    if {[info exists env(QUESTA_WLF)] && $env(QUESTA_WLF) ne ""} {
        set WLF_FILE [file normalize $env(QUESTA_WLF)]
    } else {
        set WLF_FILE [file join $WORK_DIR tb_ddr_agent_m2a.wlf]
    }
    append elab_cmd " -wlf \"$WLF_FILE\""
}
append elab_cmd " tb_ddr_agent_m2a"

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
