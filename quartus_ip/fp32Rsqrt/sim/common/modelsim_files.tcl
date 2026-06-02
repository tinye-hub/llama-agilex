
namespace eval fp32Rsqrt {
  proc get_design_libraries {} {
    set libraries [dict create]
    dict set libraries altera_fp_functions_19110 1
    dict set libraries fp32Rsqrt                 1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR QUARTUS_INSTALL_DIR} {
    set memory_files [list]
    lappend memory_files "[normalize_path "$QSYS_SIMDIR/../altera_fp_functions_19110/sim/fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC0_uid58_invSqrtTables_lutmem.hex"]"
    lappend memory_files "[normalize_path "$QSYS_SIMDIR/../altera_fp_functions_19110/sim/fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC1_uid61_invSqrtTables_lutmem.hex"]"
    lappend memory_files "[normalize_path "$QSYS_SIMDIR/../altera_fp_functions_19110/sim/fp32Rsqrt_altera_fp_functions_19110_5fbcymq_memoryC2_uid64_invSqrtTables_lutmem.hex"]"
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR QUARTUS_INSTALL_DIR} {
    set design_files [list]
    lappend design_files "-makelib altera_fp_functions_19110 \"[normalize_path "$QSYS_SIMDIR/../altera_fp_functions_19110/sim/dspba_library_ver.sv"]\"   -end"                          
    lappend design_files "-makelib altera_fp_functions_19110 \"[normalize_path "$QSYS_SIMDIR/../altera_fp_functions_19110/sim/fp32Rsqrt_altera_fp_functions_19110_5fbcymq.sv"]\"   -end"
    lappend design_files "-makelib fp32Rsqrt \"[normalize_path "$QSYS_SIMDIR/fp32Rsqrt.v"]\"   -end"                                                                                    
    return $design_files
  }
  
  proc get_non_duplicate_elab_option {ELAB_OPTIONS NEW_ELAB_OPTION} {
    set IS_DUPLICATE [string first $NEW_ELAB_OPTION $ELAB_OPTIONS]
    if {$IS_DUPLICATE == -1} {
      return $NEW_ELAB_OPTION
    } else {
      return ""
    }
  }
  
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc normalize_path {FILEPATH} {
      if {[catch { package require fileutil } err]} { 
          return $FILEPATH 
      } 
      set path [fileutil::lexnormalize [file join [pwd] $FILEPATH]]  
      if {[file pathtype $FILEPATH] eq "relative"} { 
          set path [fileutil::relative [pwd] $path] 
      } 
      return $path 
  } 
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
