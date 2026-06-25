# Llama M1 顶层设计（里程碑 1）

| 文件 | 说明 |
|:---|:---|
| [llama-m1-top-design.md](llama-m1-top-design.md) | Scheduler + DdrAgent + RMSNorm 互联、端口、仿真 |

## 目录约定

```
top/
├── doc/
├── scala/
│   ├── LlamaM1Generics.scala
│   ├── LlamaM1Top.scala      ← 里程碑 1 顶层
│   └── LlamaM1Gen.scala
├── test/
│   ├── LlamaM1TopSim.scala   ← Verilator 控制流 smoke test
│   └── questa/               ← Questa M1 毕业（FP golden）
├── gen/verilog/              make verilog
└── Makefile                  sim | questa-m1 | verilog
```

子模块（由 top 例化）：

- `llamaScheduler/` — `HpsJobCtrl`（AXI4-Lite）、`LlamaSchedulerM1`
- `ddrAgent/` — `DdrAgentM1`（`MemCmd` → AXI 读 → embed/gamma stream）
- `rmsNorm/` — `RmsNormAxiTop`

## 快速验证

```bash
make -C tools/ddr_pack pack-m1
cd src/scala/top && make sim          # Verilator 控制流
cd src/scala/top && make questa-m1    # Questa FP 毕业考试
```
