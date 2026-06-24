# Full compile + simulate DdrAgentM1 with file-backed AXI DDR slave.
# Usage (from test/questa):  vsim -c -do run_m1.do
# Or: ./run.sh m1

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

set elab_cmd "vsim -work work +DDR_IMAGE=$DDR_IMAGE"
if {[info exists env(DDR_AGENT_DEBUG)] && $env(DDR_AGENT_DEBUG) ne ""} {
    append elab_cmd " +DDR_AGENT_DEBUG"
}
if {$DO_WAVE} {
    append elab_cmd " -voptargs=+acc"
    if {[info exists env(QUESTA_WLF)] && $env(QUESTA_WLF) ne ""} {
        set WLF_FILE [file normalize $env(QUESTA_WLF)]
    } else {
        set WLF_FILE [file join $WORK_DIR tb_ddr_agent_m1.wlf]
    }
    append elab_cmd " -wlf \"$WLF_FILE\""
}
append elab_cmd " tb_ddr_agent_m1"

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
