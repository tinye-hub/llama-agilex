# Compile shared FP16 utils + Spinal-generated GEMV RTL + the selected testbench.
# Select DUT via env GEMV_DUT = mac | service (default mac).

if {![info exists QUESTA_DIR]} {
    if {![info exists env(GEMV_QUESTA_DIR)] || $env(GEMV_QUESTA_DIR) eq ""} {
        echo "ERROR: GEMV_QUESTA_DIR not set"
        exit 1
    }
    source [file join [file normalize $env(GEMV_QUESTA_DIR)] paths.tcl]
}

if {![info exists ::GEMV_QUESTA_SKIP_IP]} {
    source [file join $QUESTA_DIR compile_ips.tcl]
}

set _dut mac
if {[info exists env(GEMV_DUT)] && $env(GEMV_DUT) ne ""} {
    set _dut $env(GEMV_DUT)
}

# Shared FP16 helper package (rmsnorm_fp16_pkg) reused from rmsNorm.
vlog -work work -sv +define+QUESTA_SIM $FP16_UTILS

switch -- $_dut {
    mac {
        if {![file exists $GEN_MAC_V]} {
            echo "ERROR: missing $GEN_MAC_V — run: make verilog-mac (from src/scala/gemvService64)"
            exit 1
        }
        set _gapdef ""
        if {[info exists env(GEMV_ROW_GAP)] && $env(GEMV_ROW_GAP) ne ""} {
            set _gapdef "+define+ROW_GAP_OVR=$env(GEMV_ROW_GAP)"
        }
        vlog -work work -sv +define+QUESTA_SIM {*}$_gapdef \
            -L altera_fp_functions_19110 \
            -L agilex_native_floating_point_dsp_100 \
            $GEN_MAC_V \
            [file join $QUESTA_DIR tb_gemv_mac_beat.sv]
    }
    service {
        if {![file exists $GEN_SVC_V]} {
            echo "ERROR: missing $GEN_SVC_V — run: make verilog (from src/scala/gemvService64)"
            exit 1
        }
        set _k 2048
        set _m 2048
        if {[info exists env(GEMV_K)] && $env(GEMV_K) ne ""} {
            set _k $env(GEMV_K)
        } elseif {[info exists env(GEMV_DIM)] && $env(GEMV_DIM) ne ""} {
            set _k $env(GEMV_DIM)
        }
        if {[info exists env(GEMV_M)] && $env(GEMV_M) ne ""} {
            set _m $env(GEMV_M)
        } elseif {[info exists env(GEMV_MAX_ROWS)] && $env(GEMV_MAX_ROWS) ne ""} {
            set _m $env(GEMV_MAX_ROWS)
        }
        vlog -work work -sv +define+QUESTA_SIM \
            +define+GEMV_K=${_k} +define+GEMV_M=${_m} +define+GEMV_MAX_ROWS=${_m} \
            -L altera_fp_functions_19110 \
            -L agilex_native_floating_point_dsp_100 \
            $GEN_SVC_V \
            [file join $QUESTA_DIR tb_gemv_service64.sv]
    }
    default {
        echo "ERROR: unknown GEMV_DUT '$_dut' (expected mac|service)"
        exit 1
    }
}

echo "GEMV DUT ($_dut) + TB compile done."
