# Open a recorded Questa WLF (used by: make questa VIEW=1).
# Usage: cd work && vsim -do ../view_wave.do

onerror {quit -code 1}

if {![info exists env(DDR_AGENT_QUESTA_DIR)] || $env(DDR_AGENT_QUESTA_DIR) eq ""} {
    set _questa_dir [file dirname [info script]]
} else {
    set _questa_dir $env(DDR_AGENT_QUESTA_DIR)
}

set _work_dir [file join $_questa_dir work]
if {[info exists env(QUESTA_WLF)] && $env(QUESTA_WLF) ne ""} {
    set _wlf [file normalize $env(QUESTA_WLF)]
} else {
    set _wlf [file join $_work_dir tb_ddr_agent_m1.wlf]
}

if {![file exists $_wlf]} {
    echo "ERROR: missing $_wlf — run: make questa WAVE=1"
    exit 1
}

echo "Opening $_wlf"
vsim -view $_wlf
