# Repository paths for RMSNorm Questa simulation.
# QUESTA_DIR must come from run.sh (RMSNORM_QUESTA_DIR). Do not rely on [info script]:
# vsim -do can resolve the .do file under $MODEL_TECH/../ (e.g. /mtitcl/vsim/).

if {![info exists env(RMSNORM_QUESTA_DIR)] || $env(RMSNORM_QUESTA_DIR) eq ""} {
    echo "ERROR: RMSNORM_QUESTA_DIR not set — run via ./run.sh or export it before vsim -do"
    exit 1
}
set QUESTA_DIR [file normalize $env(RMSNORM_QUESTA_DIR)]
set RMSNORM_TEST_DIR [file dirname $QUESTA_DIR]
set RMSNORM_DIR [file dirname $RMSNORM_TEST_DIR]
set REPO_ROOT [file normalize [file join $RMSNORM_DIR ../../..]]

set SIMLIB_DIR [file join $REPO_ROOT simlib quartus2025_1_1_agilex5_questa2024_3]
set QUARTUS_IP_DIR [file join $REPO_ROOT quartus_ip]
set GEN_VERILOG_DIR [file join $RMSNORM_DIR gen verilog]
set GEN_TOP_V [file join $GEN_VERILOG_DIR RmsNormAxiTop.v]
set WORK_DIR [file join $QUESTA_DIR work]

if {![file exists $SIMLIB_DIR/questa_device_mapping.tcl]} {
    echo "ERROR: missing simlib at $SIMLIB_DIR (questa_device_mapping.tcl)"
    exit 1
}
if {![file exists $GEN_TOP_V]} {
    echo "ERROR: missing $GEN_TOP_V — run: make verilog (from src/scala/rmsNorm)"
    exit 1
}

file mkdir $WORK_DIR
cd $WORK_DIR

# fp32Rsqrt rsqrt LUT tables: altera_lnsim opens these by basename from the sim cwd.
set _fp32rsqrt_mem [file join $QUARTUS_IP_DIR fp32Rsqrt altera_fp_functions_19110 synth]
foreach _hex {
    fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC0_uid58_invSqrtTables_lutmem.hex
    fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC1_uid61_invSqrtTables_lutmem.hex
    fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC2_uid64_invSqrtTables_lutmem.hex
} {
    set _src [file join $_fp32rsqrt_mem $_hex]
    if {![file exists $_src]} {
        echo "ERROR: missing fp32Rsqrt memory init $_src"
        exit 1
    }
    set _dst [file join $WORK_DIR $_hex]
    if {![file exists $_dst]} {
        file link -symbolic $_dst $_src
    }
}
unset _fp32rsqrt_mem _hex _src _dst

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

if {[info exists env(QUARTUS_ROOTDIR)]} {
    set QUARTUS_SIM_LIB_DIR [file join $env(QUARTUS_ROOTDIR) eda sim_lib]
} else {
    set QUARTUS_SIM_LIB_DIR /applicsqum/altera/quartus/pro_25_1_1/quartus/eda/sim_lib
}

set ::env(RMSNORM_QUESTA_WORK) $WORK_DIR
