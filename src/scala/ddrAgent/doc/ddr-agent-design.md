# DdrAgent 设计说明

> **DdrAgent** 是 PL 侧唯一的 DDR 访问代理：接收 **LlamaScheduler** 的 `MemCmd`，翻译成 AXI4 burst 读写，按 `sink_id` 将读回数据路由到下游 AXI-Stream 或 FIFO。
>
> 调度与地址计算见 [llama-scheduler-design.md](../../llamaScheduler/doc/llama-scheduler-design.md)。  
> DDR 全局地址见 [ddr-memory-map.md](../../common/doc/ddr-memory-map.md)。

**主线配置**：2 GB LPDDR4，AXI burst ≥ 256 B，outstanding ≥ 8。

---

## 1. 职责边界

| 负责 | 不负责 |
|:---|:---|
| `MemCmd` → AXI4 `AR`/`AW`/`W`/`R`/`B` | 算法顺序 |
| Burst 切分、outstanding、反压 | `token_id` / `gamma_index` 地址计算 |
| `EMBED_ROW` sink → `RmsNorm.dataIn` | RMSNorm 计算 |
| `RMS_GAMMA` sink → `RmsNorm.weightIn` | HPS MMIO |
| `MemDone` 回报 | |

行缓冲、beat 序列化、`tlast`/`tuser` 均在各 **AxisSink** 适配器内完成。

---

## 2. 顶层互联

```text
                    MemCmd Stream
LlamaScheduler ──────────────────────► ┌─────────────┐      AXI4      ┌──────┐
                    MemDone Stream     │  DdrAgent   │ ◄──────────► │ DDR  │
◄────────────────────────────────────  │             │              └──────┘
                                       │  AxisSink   │
RmsNorm.dataIn   ◄── EMBED_ROW  ────── │  AxisSink   │
RmsNorm.weightIn ◄── RMS_GAMMA  ────── │  TileSink…  │
                                       └─────────────┘
```

---

## 3. MemCmd / MemDone

### 3.1 MemCmd（128 bit）

```text
 ┌──────────┬──────────┬────────────┬────────────┬────────────┬──────────────────┐
 │ [127:120]│ [119:112]│ [111:96]   │ [95:64]    │ [63:32]    │ [31:0]           │
 │ cmd_type │ sink_id  │ reserved   │ byte_len   │ ddr_addr   │ tag              │
 └──────────┴──────────┴────────────┴────────────┴────────────┴──────────────────┘
```

| 字段 | 说明 |
|:---|:---|
| `cmd_type` | `READ=0`, `WRITE=1` |
| `sink_id` | 见 §4 |
| `byte_len` | 字节数；embedding / γ 均为 **4096** |
| `ddr_addr` | 字节地址（Scheduler 已加各 `*_BASE`） |
| `tag` | 事务 ID |

**axis_ctx**（16 bit sideband，与 MemCmd 配对）：

```text
[14:11] layerId   [10:9] normKind   [8:0] tokenSeqLow
```

`busy` 位由 sink 按 beat 生成。

### 3.2 MemDone

```text
MemDone: tag, error, sink_id
```

在对应 sink 的 **2048 个 AXI-Stream beat 全部 handshake 完成** 后发出（非仅 AXI R 结束）。

---

## 4. sink_id 路由表

| sink_id | 名称 | 下游 | byte_len（典型） | 里程碑 |
|:---:|:---|:---|:---:|:---:|
| `0` | `EMBED_ROW` | `RmsNorm.dataIn` | 4096 | **1** |
| `1` | `RMS_GAMMA` | `RmsNorm.weightIn` | 4096 | **1** |
| `2` | `GEMV_WEIGHT` | GemvService64 tile FIFO | 变长 | 2 |
| `3` | `KV_READ` | Attention KV 路径 | 变长 | 2 |
| `4` | `KV_WRITE` | 来自 KV 写 stream | 变长 | 2 |
| `5` | `LM_HEAD` | GemvService64 顺序扫表 | 变长 | 3 |

---

## 5. AxisSink 通用行为（EMBED_ROW / RMS_GAMMA）

两个 sink 结构相同，仅输出接口不同：

```text
AXI R data ──► row_buffer[4096 B] ──► beat_serializer ──► Axi4Stream master
```

1. 收 `MemCmd`，发起 AXI 读，填满 `row_buffer`。
2. 按小端 FP16 输出 2048 beat，`tlast` 在 beat 2047。
3. `tuser` 来自 `axis_ctx`（`EMBED_ROW` 用 Profile A；`RMS_GAMMA` 的 `tuser` 仅调试）。
4. 末 beat 握手完成后发 `MemDone`。

### 5.1 反压

- 下游 `ready=0` 时暂停 beat 输出，保留 `row_buffer`。
- 同一 sink 上一条 vector 未排空前，不接收新 `MemCmd`（或 Scheduler 保证串行）。

### 5.2 里程碑 1 地址示例

| MemCmd | sink | ddr_addr |
|:---|:---|:---|
| embedding token 0 | `EMBED_ROW` | `0x0000_0000` |
| L0 norm1 γ | `RMS_GAMMA` | `0x1F50_0000` |
| L0 norm2 γ | `RMS_GAMMA` | `0x1F50_1000` |
| final_norm γ | `RMS_GAMMA` | `0x1F52_0000` |

---

## 6. AXI 读策略

1. 优先 **256 B** burst；`ARLEN`/`ARSIZE` 与 data width 对齐。
2. **outstanding ≥ 8**；允许多个 `MemCmd` 并行（如 embed + γ 同时读）。
3. cmd FIFO 在 sink 反压或信用耗尽时停止消费。

---

## 7. 里程碑 1 行为摘要

实现 `READ` + `EMBED_ROW` + `RMS_GAMMA`：

```text
1. 取 MemCmd（可连续两条：embed @ 0x0, gamma @ 0x1F50_0000）
2. 并行或流水 AXI 读
3. 分别串行化 → embedOut / gammaOut
4. 各发 MemDone
```

仿真检查：

- embed `token_id=1` → AR `0x1000`
- L0 norm1 γ → AR `0x1F50_0000`
- 两侧 2048 beat 与 DDR preload 一致

---

## 8. 实现分期

| 阶段 | 内容 |
|:---|:---|
| **M1** | `MemCmd`/`MemDone`、`AxiReader`、 `EmbedRowAxisSink`、`GammaAxisSink` |
| **M2** | `GEMV_WEIGHT`、`KV_READ`/`KV_WRITE` |
| **M3** | `LM_HEAD` 顺序扫描、写通路 |

---

## 9. 目录约定

```text
ddrAgent/
├── doc/
│   └── ddr-agent-design.md
├── scala/
│   ├── MemCmd.scala
│   ├── DdrAgent.scala
│   └── sinks/
│       ├── EmbedRowAxisSink.scala
│       └── GammaAxisSink.scala
└── test/
```
