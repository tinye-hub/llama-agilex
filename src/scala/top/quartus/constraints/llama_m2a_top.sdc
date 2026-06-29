# Clock for stand-alone LlamaM2aTop timing closure check (adjust to target frequency)
create_clock -name clk -period 2.500 [get_ports {clk}]

set_false_path -from [get_ports {reset}]
