# llamaScheduler 模块文档

| 文件 | 说明 |
|:---|:---|
| [llama-scheduler-design.md](llama-scheduler-design.md) | 全局 FSM、HPS MMIO、`MemCmd` 生成 |

## Scala 源码

| 文件 | 说明 |
|:---|:---|
| `../scala/HpsJobCtrl.scala` | AXI4-Lite MMIO 寄存器（`AxiLite4SlaveFactory`） |
| `../scala/LlamaSchedulerM1.scala` | 里程碑 1 调度 FSM |
| `../scala/LlamaSchedulerM2a.scala` | 里程碑 2a：M1 + L0 W_Q GEMV 调度 |

| 测试 | 说明 |
|:---|:---|
| `../test/LlamaSchedulerM1Sim.scala` | Verilator 单元仿真（mock MemCmd / MemDone） |

由 `top/LlamaM1Top` / `LlamaM2aTop` 例化。

## 相关文档

- [ddr-memory-map.md](../../ddrMemoryMap/doc/ddr-memory-map.md)
- [llama-m1-top-design.md](../../top/doc/llama-m1-top-design.md)
- [top/test/questa/README.md](../../top/test/questa/README.md)
