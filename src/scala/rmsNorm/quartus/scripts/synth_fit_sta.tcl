# Quartus: synthesis + fit + STA only (no Assembler / bitstream).
# Invoked by: make quartus  (from src/scala/rmsNorm)

set project_name "rmsnorm_top"

if {![file exists ${project_name}.qpf]} {
    post_message -type error "Run from quartus/ directory (missing ${project_name}.qpf)"
    exit 1
}

project_open -revision ${project_name} ${project_name}

# Ensure Spinal Verilog exists
set rtl "../gen/verilog/RmsNormAxiTop.v"
if {![file exists $rtl]} {
    post_message -type error "Missing $rtl — run: make verilog"
    exit 1
}

post_message "=== quartus_syn ==="
execute_module -tool syn

post_message "=== quartus_fit ==="
execute_module -tool fit

post_message "=== quartus_sta ==="
execute_module -tool sta

post_message "=== Done (no Assembler). See output_files/${project_name}.fit.rpt ==="
project_close
