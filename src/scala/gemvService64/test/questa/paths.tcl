# Repository paths for GemvService64 Questa simulation.
# GEMV_QUESTA_DIR must come from run.sh. Do not rely on [info script]:
# vsim -do can resolve the .do file under $MODEL_TECH/../ (e.g. /mtitcl/vsim/).

if {![info exists env(GEMV_QUESTA_DIR)] || $env(GEMV_QUESTA_DIR) eq ""} {
    echo "ERROR: GEMV_QUESTA_DIR not set — run via ./run.sh or export it before vsim -do"
    exit 1
}
set QUESTA_DIR [file normalize $env(GEMV_QUESTA_DIR)]
set GEMV_TEST_DIR [file dirname $QUESTA_DIR]
set GEMV_DIR [file dirname $GEMV_TEST_DIR]
set REPO_ROOT [file normalize [file join $GEMV_DIR ../../..]]

set SIMLIB_DIR [file join $REPO_ROOT simlib quartus2025_1_1_agilex5_questa2024_3]
set QUARTUS_IP_DIR [file join $REPO_ROOT quartus_ip]
set GEN_VERILOG_DIR [file join $GEMV_DIR gen verilog]
set GEN_MAC_V [file join $GEN_VERILOG_DIR GemvMacBeat.v]
set GEN_SVC_V [file join $GEN_VERILOG_DIR GemvService64.v]
set WORK_DIR [file join $QUESTA_DIR work]

# fp16_utils.sv is shared with rmsNorm (FP16 <-> FP32 helpers, golden math).
set FP16_UTILS [file join $REPO_ROOT src scala rmsNorm test questa fp16_utils.sv]

if {![file exists $SIMLIB_DIR/questa_device_mapping.tcl]} {
    echo "ERROR: missing simlib at $SIMLIB_DIR (questa_device_mapping.tcl)"
    exit 1
}
if {![file exists $FP16_UTILS]} {
    echo "ERROR: missing shared fp16_utils.sv at $FP16_UTILS"
    exit 1
}

file mkdir $WORK_DIR
cd $WORK_DIR

# Precompiled Agilex 5 device libraries (quartus_sh --simlib_comp).
# questa_device_mapping.tcl has VHDL libs only; vsim elab needs *_ver for defparam/tennm_fp_mac.
source $SIMLIB_DIR/questa_device_mapping.tcl
set _simlib_libs [file join $SIMLIB_DIR libs]
foreach _vlib {
    lpm_ver sgate_ver altera_ver altera_mf_ver altera_lnsim_ver
    tennm_ver tennm_hvio_ver tennm_sm_hps_ver tennm_sm4_hssi_ver
    tennm_fmm3_hssi_ver tennm_revb_hvio_ver tennm_revb_io96_ver
    tennm_agilex5_io96_ver tennm_agilex5_hssi_a_ver
} {
    vmap $_vlib [file join $_simlib_libs $_vlib]
}
unset _simlib_libs _vlib

set ::env(GEMV_QUESTA_WORK) $WORK_DIR
