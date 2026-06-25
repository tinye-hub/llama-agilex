# tokenEmbed 模块文档

本目录**只描述 Token Embedding 查表语义**（DDR 表布局、地址、数据格式、→ RMSNorm 的流约定）。**无独立 RTL 模块**。

| 文件 | 说明 |
|:---|:---|
| [token-embedding-design.md](token-embedding-design.md) | Embedding 表规格、地址公式、AXI-Stream 输出约定 |

## 相关模块

| 模块 | 文档 | 职责 |
|:---|:---|:---|
| DDR 地址规划 | [ddr-memory-map.md](../../common/doc/ddr-memory-map.md) | 全局 map、γ 区 `0x1F50_0000` |
| LlamaScheduler | [llama-scheduler-design.md](../../llamaScheduler/doc/llama-scheduler-design.md) | `MemCmd` 生成、FSM |
| DdrAgent | [ddr-agent-design.md](../../ddrAgent/doc/ddr-agent-design.md) | `EMBED_ROW` / `RMS_GAMMA` sink |
| RmsNorm | [rms-norm-module-design.md](../../rmsNorm/doc/rms-norm-module-design.md) | 归一化计算 |

## 目录约定

```
tokenEmbed/
└── doc/       设计文档（无 scala/ — 查表逻辑在 Scheduler + DdrAgent）
```
