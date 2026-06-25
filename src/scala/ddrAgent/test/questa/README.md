# DdrAgent Questa simulation

Gate-level simulation of `DdrAgentM1` using Spinal-generated Verilog and a
file-backed AXI4 read slave (`axi_read_mem.sv`). Test vectors match
`ddrAgent.DdrAgentM1Sim` (Verilator).

仿真命名与 `WAVE`/`VIEW`/`DEBUG` 见 [simulation-conventions.md](../../../doc/simulation-conventions.md)。

## Prerequisites

```bash
source /userworkqum/tinye/llama-agilex/set_env.sh   # questacoreprime
make -C /userworkqum/tinye/llama-agilex/tools/ddr_pack pack-m1
cd /userworkqum/tinye/llama-agilex/src/scala/ddrAgent
make verilog    # AXI_WIDTH=256 (default) → gen/verilog/DdrAgentM1.v
```

Unlike `rmsNorm` Questa, **no Quartus FP IP or device simlib** is required —
pure Verilog DUT + SV testbench.

## Run

License tools on batch nodes via `NC_RUN` (see repo `set_env.sh`):

```bash
source set_env.sh
cd src/scala/ddrAgent
make questa       # wraps: $NC_RUN ./run.sh m1
```

Direct (local Questa license):

```bash
make questa NC_RUN=
# or: cd test/questa && ./run.sh m1
```

```bash
make questa WAVE=1                 # records test/questa/work/tb_ddr_agent_m1.wlf
make questa VIEW=1 NC_RUN=         # Questa GUI (needs DISPLAY)
make questa DEBUG=1                # verbose AXI/state log
make verilator                     # 64-bit AXI; colored PASS via sbt-runmain.sh
```

`DDR_IMAGE` overrides the default `tools/ddr_pack/out/ddr_image_m1.bin`.

Working directory: `test/questa/work/` (safe to delete).

## Files

| File | Role |
|------|------|
| `paths.tcl` | Repo paths, `vlib work` |
| `compile_dut.tcl` | `DdrAgentM1.v` + `tb_ddr_agent_m1.sv` |
| `run_m1.do` | Full compile + simulate |
| `axi_read_mem.sv` | Byte-sparse AXI4 read slave |
| `tb_ddr_agent_m1.sv` | Stimulus / checker (matches `DdrAgentM1Sim`) |

## Notes

- Default AXI data width is **256-bit** (`make verilog`, `make questa`).
- Verilator `make verilator` uses **64-bit** AXI internally (WData compat).
- Pass criteria: embed @ `0x0` + gamma @ `0x1F50_0000`, 2048 FP16 beats each, bit-exact vs DDR image.
