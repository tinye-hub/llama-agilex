# Compile Quartus FP IPs for util smoke test.

if {![info exists REPO_ROOT]} {
    echo "ERROR: compile_ips.tcl requires paths.tcl first"
    exit 1
}
if {![info exists SCALA_ROOT]} {
    set SCALA_ROOT [file normalize [file join $REPO_ROOT src scala]]
}
if {![info exists QUARTUS_IP_DIR]} {
    set QUARTUS_IP_DIR [file join $REPO_ROOT quartus_ip]
}

source [file join $SCALA_ROOT scripts compile_altera_fp_ips.tcl]
compile_altera_fp_ips
