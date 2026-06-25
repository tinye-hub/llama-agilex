# llama-agilex

Llama 3.2 1B on Intel Agilex 5 — SpinalHDL PL + HPS (GHRD).

## 里程碑 1（当前）

`token_id` → Scheduler → DdrAgent DDR read → RmsNorm L0 norm1 → 2048×FP16 out。

```bash
source activate.sh
make -C tools/ddr_pack pack-m1
cd src/scala/top && make questa       # FP 毕业考试（Questa + Quartus IP）
cd src/scala/top && make verilator    # 控制流 smoke（Verilator）
```

## 文档索引

| 模块 | 设计文档 |
|:---|:---|
| Top | [src/scala/top/doc/llama-m1-top-design.md](src/scala/top/doc/llama-m1-top-design.md) |
| Scheduler | [src/scala/llamaScheduler/doc/llama-scheduler-design.md](src/scala/llamaScheduler/doc/llama-scheduler-design.md) |
| DdrAgent | [src/scala/ddrAgent/doc/ddr-agent-design.md](src/scala/ddrAgent/doc/ddr-agent-design.md) |
| DDR 地址 | [src/scala/ddrMemoryMap/doc/ddr-memory-map.md](src/scala/ddrMemoryMap/doc/ddr-memory-map.md) |
| RmsNorm | [src/scala/rmsNorm/doc/rms-norm-module-design.md](src/scala/rmsNorm/doc/rms-norm-module-design.md) |
| 架构背景 | [doc/llama3.2-1b-arch-for-fpga-design.md](doc/llama3.2-1b-arch-for-fpga-design.md) |
| Questa 策略 | [.cursor/rules/questa-simulation.mdc](.cursor/rules/questa-simulation.mdc) |
| 仿真约定 | [src/scala/doc/simulation-conventions.md](src/scala/doc/simulation-conventions.md) |
