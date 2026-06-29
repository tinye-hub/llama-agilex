# Quartus: synthesis + fit + STA only (no Assembler / bitstream).
# Invoked by: make quartus-m2a  (from src/scala/top)

set project_name "llama_m2a_top"

if {![file exists ${project_name}.qpf]} {
    post_message -type error "Run from quartus/ directory (missing ${project_name}.qpf)"
    exit 1
}

project_open -revision ${project_name} ${project_name}

set rtl "../gen/verilog/LlamaM2aTop.v"
if {![file exists $rtl]} {
    post_message -type error "Missing $rtl — run: make verilog-m2a (from src/scala/top)"
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
