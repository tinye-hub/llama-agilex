仿真命名与 `WAVE`/`VIEW` 见 [simulation-conventions.md](../../doc/simulation-conventions.md)。

Gate-level / IP-accurate simulation of `RmsNormAxiTop` with real Quartus FP IPs
(`quartus_ip/`) and precompiled Agilex 5 device libraries.

## Prerequisites

```bash
source /userworkqum/tinye/llama-agilex/set_env.sh   # quartus + questacoreprime
cd /userworkqum/tinye/llama-agilex/src/scala/rmsNorm
make verilog    # RMSNORM_DIM=2048 (default) → gen/verilog/RmsNormAxiTop.v
```

Device libraries: `simlib/quartus2025_1_1_agilex5_questa2024_3/` (Verilog `*_ver`, from `quartus_sh -mode quartus`).

VHDL `altera_mf` + `tennm` for compiling `altera_fp_functions` come from precompiled `simlib/` (not local `test/questa/libs/`). `vsim` must use Verilog `*_ver` libs only — do not pass `-L altera_mf` or `-L tennm` at elaboration.

## Run

License tools run on batch nodes via `NC_RUN` (see repo `set_env.sh`; no `-Ix` — `vsim -c` does not need `DISPLAY`):

```bash
source set_env.sh
cd src/scala/rmsNorm
make questa       # wraps: $NC_RUN ./run.sh axi
```

Direct (only if the node has Questa license):

```bash
make questa NC_RUN=
# or: cd test/questa && ./run.sh axi
```

```bash
make questa WAVE=1                # records test/questa/work/tb_rmsnorm_axi.wlf
make questa VIEW=1 NC_RUN=          # Questa GUI (needs DISPLAY)
```

`QUESTA_WLF` overrides the default WLF path. Waveform logging uses `vsim -wlf` + `log -r /*` (large, slower than plain `make questa`).

Working directory: `test/questa/work/` (created automatically; safe to delete).

## Files

| File | Role |
|------|------|
| `paths.tcl` | Repo paths, `cd work`, map device libs |
| `compile_ips.tcl` | VHDL `altera_fp_functions` + Verilog IP shells |
| `compile_dut.tcl` | `RmsNormAxiTop.v` + `tb_rmsnorm_axi.sv` |
| `run_axi.do` | Full flow |
| `tb_rmsnorm_axi.sv` | Stimulus / checker (matches `RmsNormAxiTopSim`) |

## Notes

- Default vector length is **2048** everywhere (`make verilog`, Questa TB `DIM`, Verilator `RMSNORM_SIM_DIM`).
- To use another dim: `make verilog DIM=<n>` and `make questa DIM=<n>` (TB picks up `+define+RMSNORM_DIM=<n>`).
- Control-flow only (no FP golden): `make verilator`.
- First compile can take several minutes (VHDL FP functions + large DUT).
