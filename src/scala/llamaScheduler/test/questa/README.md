# LlamaScheduler Questa unit simulation

Mirrors the former `LlamaSchedulerM1Sim` (Verilator) checks: MemCmd sequencing,
`axis_ctx`, token_id OOB, and FSM completion. No Quartus FP IP required.

## Quick start

```bash
cd src/scala/llamaScheduler
make questa          # verilog + run m1 TB
make questa WAVE=1   # record WLF
make questa VIEW=1   # open WLF in Questa GUI
```

From `test/questa/`:

```bash
./run.sh compile
./run.sh m1
```

## Layout

| File | Role |
|:---|:---|
| `paths.tcl` | Repo paths, work dir |
| `compile_dut.tcl` | `vlog` DUT + TB |
| `run_m1.do` | compile + `vsim -c` + `run -all` |
| `tb_llama_scheduler_m1.sv` | Mock MemCmd sink / MemDone source |

## Regression

Included in `make regression` via `scripts/sim-matrix.sh` (`llamaScheduler questa`).
