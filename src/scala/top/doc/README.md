# Llama Top 设计（M1 / M2a）

| 文件 | 说明 |
|:---|:---|
| [llama-m1-top-design.md](llama-m1-top-design.md) | M1：Scheduler + DdrAgent + RMSNorm |
| [../quartus/README.md](../quartus/README.md) | M2a Quartus 资源/时序评估 |
| [../test/questa/README.md](../test/questa/README.md) | Questa M1 / M2a 毕业 TB |

## 目录约定

```
top/
├── doc/
├── scala/
│   ├── LlamaM1Generics.scala / LlamaM1Top.scala / LlamaM1Gen.scala   ← M1
│   ├── LlamaM2aGenerics.scala / LlamaM2aTop.scala / LlamaM2aGen.scala ← M2a
│   └── DdrCmdArb.scala          ← Scheduler ↔ Gemv tileFetch 仲裁
├── quartus/                     ← LlamaM2aTop syn/fit/sta（无 bitstream）
├── test/
│   ├── LlamaM1TopSim.scala      ← Verilator M1 smoke（VERILATOR_WAVE=1 可选）
│   └── questa/                  ← M1 + M2a FP golden
├── gen/verilog/                 make verilog / verilog-m2a
└── Makefile
```

子模块（由 top 例化）：

- `llamaScheduler/` — `HpsJobCtrl`、`LlamaSchedulerM1` / `LlamaSchedulerM2a`
- `ddrAgent/` — `DdrAgentM1` / `DdrAgentM2`（`DdrAgentRowMem` 行缓冲）
- `rmsNorm/` — `RmsNormAxiTop`
- `gemvService64/` — `GemvService64`（M2a）

## M2a 数据流（摘要）

```text
HPS → SchedulerM2a → MemCmd → DdrCmdArb ← tileFetch ← GemvService64
DdrAgentM2 → embed/gamma → RmsNorm → actIn → Gemv
           → scaleOut / weightBeat ──────────────► Gemv
Gemv.qOut → io.qOut
```

## 快速验证

```bash
make -C tools/ddr_pack pack-m1          # M1
make -C tools/ddr_pack pack             # M2a（ddr_image.bin）

cd src/scala/top
make verilator                          # M1 控制流 smoke
make questa                             # M1 FP 毕业
make questa-m2a                         # M2a（默认 M=2048；回归 batch 用 M=4）
make questa-m2a M=4                     # M2a smoke

make quartus-m2a                        # Quartus 资源/时序（需 verilog-m2a）
make quartus-m2a-report
```

仿真约定：[doc/simulation-conventions.md](../../doc/simulation-conventions.md)
