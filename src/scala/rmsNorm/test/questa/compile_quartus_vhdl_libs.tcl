# VHDL support for altera_fp_functions vcom (altera_mf_components, tennm_components).
#
# Precompiled VHDL altera_mf + tennm live in simlib/ (mapped by questa_device_mapping.tcl).
# Do not vmap altera_mf/tennm to a local recompile here — that breaks vsim elab when combined
# with -L altera_mf -L tennm (Verilog defparam on tennm_fp_mac binds to VHDL, not tennm_ver).
#
# For vsim, use only *_ver libraries (see run_axi.do), matching Quartus msim_setup.tcl.

proc ensure_quartus_vhdl_support_libs {} {
    # Intentionally empty: simlib questa_device_mapping.tcl provides altera_mf and tennm.
}

ensure_quartus_vhdl_support_libs
