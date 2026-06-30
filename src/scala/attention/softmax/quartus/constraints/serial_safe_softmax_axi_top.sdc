# Clock for stand-alone SerialSafeSoftmaxAxiTop timing closure check (400 MHz target)
create_clock -name clk -period 2.500 [get_ports {clk}]

set_false_path -from [get_ports {reset}]
