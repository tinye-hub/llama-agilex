# rope Questa

`SerialRoPEAxiTop` + Quartus FP IP（`fp16ToFp32`、`fp32ToFp16`、`fp32MultAcc`、`fp32Add`）。

```bash
cd src/scala/rope
make questa              # default ROPE_MAX_POS=1024, ROPE_HEAD_DIM=64
make questa WAVE=1       # + WLF
```

Golden：`golden_refs/`（`tools/rope_golden/gen_rope_tables.py` 生成）。

Included in `make regression` via `scripts/sim-matrix.sh` (`rope questa`).
