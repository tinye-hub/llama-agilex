# Repository paths for SerialSafeSoftmax Questa simulation.

if {![info exists env(SOFTMAX_QUESTA_DIR)] || $env(SOFTMAX_QUESTA_DIR) eq ""} {
    echo "ERROR: SOFTMAX_QUESTA_DIR not set — run via test/questa/run.sh"
    exit 1
}
set QUESTA_DIR [file normalize $env(SOFTMAX_QUESTA_DIR)]
set SOFTMAX_TEST_DIR [file dirname $QUESTA_DIR]
set SOFTMAX_DIR [file dirname $SOFTMAX_TEST_DIR]
set ATTN_DIR [file dirname $SOFTMAX_DIR]
set REPO_ROOT [file normalize [file join $SOFTMAX_DIR ../../../..]]
set SCALA_ROOT [file join $REPO_ROOT src scala]

set SIMLIB_DIR [file join $REPO_ROOT simlib quartus2025_1_1_agilex5_questa2024_3]
set QUARTUS_IP_DIR [file join $REPO_ROOT quartus_ip]
set GEN_TOP_V [file join $SOFTMAX_DIR gen verilog SerialSafeSoftmaxAxiTop.v]
set WORK_DIR [file join $QUESTA_DIR work]
set FP16_UTILS [file join $REPO_ROOT src scala rmsNorm test questa fp16_utils.sv]
set GOLDEN_DIR [file join $QUESTA_DIR golden_refs]

if {![file exists $SIMLIB_DIR/questa_device_mapping.tcl]} {
    echo "ERROR: missing simlib at $SIMLIB_DIR"
    exit 1
}
if {![file exists $GEN_TOP_V]} {
    echo "ERROR: missing $GEN_TOP_V — run: make verilog (from attention/softmax)"
    exit 1
}
if {![file exists $FP16_UTILS]} {
    echo "ERROR: missing $FP16_UTILS"
    exit 1
}

file mkdir $WORK_DIR
cd $WORK_DIR

if {![file exists golden_refs]} {
    file link -symbolic golden_refs $GOLDEN_DIR
}

source [file join $SCALA_ROOT scripts compile_altera_fp_ips.tcl]

link_fp_ip_hex_mems $WORK_DIR fp32Exp [list \
    fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_eA_uid100_fpExpETest_lutmem.hex \
    fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_kPPreZLow_uid67_fpExpETest_lutmem.hex \
    fp32Exp_altera_fp_functions_19110_fz7lzha_floatTable_kPPreZHigh_uid63_fpExpETest_lutmem.hex \
]

link_fp_ip_hex_mems $WORK_DIR fp32Div [list \
    fp32Div_altera_fp_functions_19110_etcsazy_memoryC0_uid146_invTables_lutmem.hex \
    fp32Div_altera_fp_functions_19110_etcsazy_memoryC1_uid149_invTables_lutmem.hex \
    fp32Div_altera_fp_functions_19110_etcsazy_memoryC2_uid152_invTables_lutmem.hex \
]

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

set ::env(SOFTMAX_QUESTA_WORK) $WORK_DIR
