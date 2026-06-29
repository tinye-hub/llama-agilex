# DdrAgent Questa simulation

Gate-level simulation of `DdrAgentM1` / `DdrAgentM2` using Spinal-generated Verilog and a
file-backed AXI4 read slave (`axi_read_mem.sv`).

| Target | TB | DDR image |
|:---|:---|:---|
| M1 | `tb_ddr_agent_m1.sv` | `ddr_image_m1.bin` |
| M2a | `tb_ddr_agent_m2a.sv` | `ddr_fixture.bin` |

`make questa` runs **M1 then M2a** sequentially (matches `sim-matrix` regression).

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
make questa-m1      # M1 only
make questa-m2a     # M2a only（需 fixture）
make questa         # M1 + M2a（回归默认）
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
make verilator                     # M1, 64-bit AXI; VERILATOR_WAVE=1 可选波形
make verilator-m2a                 # M2a, 256-bit AXI
```

`DDR_IMAGE` overrides the default preload path.

M2a fixture:

```bash
make -C tools/ddr_pack fixture     # ddr_fixture.bin
```

Working directory: `test/questa/work/` (safe to delete).

## Files

| File | Role |
|------|------|
| `paths.tcl` | Repo paths, `vlib work` |
| `compile_dut.tcl` | `DdrAgentM1.v` + `tb_ddr_agent_m1.sv` |
| `compile_dut_m2a.tcl` | `DdrAgentM2.v` + `tb_ddr_agent_m2a.sv` |
| `run_m1.do` / `run_m2a.do` | Full compile + simulate |
| `axi_read_mem.sv` | Byte-sparse AXI4 read slave |
| `tb_ddr_agent_m1.sv` | M1 checker（embed + gamma） |
| `tb_ddr_agent_m2a.sv` | M2a checker（embed + gamma + GEMV tiles） |

## Notes

- Default AXI data width is **256-bit** (`make verilog`, `make questa`).
- Verilator `make verilator` uses **64-bit** AXI internally (WData compat).
- Pass criteria: embed @ `0x0` + gamma @ `0x1F50_0000`, 2048 FP16 beats each, bit-exact vs DDR image.
