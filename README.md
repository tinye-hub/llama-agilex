# llama-agilex

Llama 3.2 1B on Intel Agilex 5 — SpinalHDL PL + HPS (GHRD).

## 里程碑

| 阶段 | 内容 | 状态 |
|:---|:---|:---:|
| **M1** | embed → RMSNorm L0 norm1 | ✓ |
| **M2a** | GemvService64 + L0 `W_Q` | ✓ Questa 毕业 |
| **M2b** | RoPE | 待做 |
| **M2c** | Incremental GQA + KV cache | 待做 |
| **M2d** | `W_O` + residual | 待做 |

详见 [doc/milestone-m2.md](doc/milestone-m2.md)。

### M1 / M2a 回归

M1：`token_id` → Scheduler → DdrAgent DDR read → RmsNorm L0 norm1 → 2048×FP16 out。

M2a：M1 路径 + L0 `W_Q` GEMV → `qOut`。

```bash
source activate.sh
make -C tools/ddr_pack pack-m1          # M1 镜像
make -C tools/ddr_pack pack             # M2a 全量镜像（含 INT4 W_Q）

cd src/scala
make regression                         # 6 项并行 nc 回归（Questa，推荐）
# 或单项：
cd src/scala/top && make questa         # M1 FP 毕业（Questa）
cd src/scala/top && make questa-m2a     # M2a 毕业
cd src/scala/llamaScheduler && make questa  # Scheduler 单元 TB
```

## 文档索引

| 模块 | 设计文档 |
|:---|:---|
| Top | [src/scala/top/doc/](src/scala/top/doc/)（M1 设计 + M2a 目录） |
| Quartus 评估 | [src/scala/top/quartus/](src/scala/top/quartus/) · [gemvService64/quartus/](src/scala/gemvService64/quartus/) |
| Scheduler | [src/scala/llamaScheduler/doc/llama-scheduler-design.md](src/scala/llamaScheduler/doc/llama-scheduler-design.md) |
| DdrAgent | [src/scala/ddrAgent/doc/ddr-agent-design.md](src/scala/ddrAgent/doc/ddr-agent-design.md) |
| DDR 地址 | [src/scala/ddrMemoryMap/doc/ddr-memory-map.md](src/scala/ddrMemoryMap/doc/ddr-memory-map.md) |
| RmsNorm | [src/scala/rmsNorm/doc/rms-norm-module-design.md](src/scala/rmsNorm/doc/rms-norm-module-design.md) |
| 架构背景 | [doc/llama3.2-1b-arch-for-fpga-design.md](doc/llama3.2-1b-arch-for-fpga-design.md) |
| Questa 策略 | [.cursor/rules/questa-simulation.mdc](.cursor/rules/questa-simulation.mdc) |
| 仿真约定 | [src/scala/doc/simulation-conventions.md](src/scala/doc/simulation-conventions.md) |
