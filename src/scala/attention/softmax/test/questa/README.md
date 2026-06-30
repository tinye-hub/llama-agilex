# SerialSafeSoftmax Questa simulation

Questa-only (no Verilator). Uses shared `src/scala/scripts/compile_altera_fp_ips.tcl`
and Agilex 5 simlib under `simlib/`.

## Prerequisites

```bash
source activate.sh   # repo root
make -C src/scala/attention/softmax verilog
make -C src/scala/attention/softmax golden
```

## Run

```bash
make -C src/scala/attention questa                    # umbrella → softmax
make -C src/scala/attention/softmax questa            # direct
SOFTMAX_CASE=len128 make -C src/scala/attention/softmax questa
```

Golden cases: `golden_refs/len{1,16,128}/` from `tools/attention_golden/gen_softmax_refs.py`.

Included in `make regression` via `scripts/sim-matrix.sh` (`attention/softmax questa`).
