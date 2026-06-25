# Token Embedding 设计说明

> 本文档只描述 **Token Embedding 查表**本身：DDR 中的表布局、地址规则、数据格式，以及查表结果如何作为 RMSNorm 的输入。  
> 控制与调度见 [llama-scheduler-design.md](../../llamaScheduler/doc/llama-scheduler-design.md)；DDR 读写见 [ddr-agent-design.md](../../ddrAgent/doc/ddr-agent-design.md)。

**主线配置（已拍板）**：FP16 embedding（离线从 BF16 转换）、`EMB_BASE = 0x0000_0000`、与 LM head weight tying 共享同一张表。

---

## 1. 功能定义

Token Embedding 将离散 **token_id**（0..128255）映射为 **2048 维 FP16 向量**。无乘加运算，本质是 DDR 上的随机行读：

```text
x[0..2047] = DDR[ emb_row_base(token_id) .. +4095 ]
```

在 Llama 3.2 1B decode 流水线中，Embedding 是**每个 token job 的第一步**，输出直接作为 **layer 0 Pre-Attention RMSNorm（norm1）** 的 `dataIn`。

**本模块无独立 RTL**：查表由 `LlamaScheduler` 根据 `token_id` 生成 `MemCmd`，由 `DdrAgent` 执行 DDR 读并将读回数据串行化为 AXI-Stream 送入 `RmsNormAxiTop.dataIn`。

---

## 2. 权重表规格

| 参数 | 值 |
|:---|:---|
| `VOCAB_SIZE` | 128,256 |
| `EMB_DIM` | 2,048 |
| 元素格式 | **FP16**（2 B/elem） |
| `ROW_BYTES` | `2048 × 2 = 4096 B = 0x1000` |
| 表总大小 | `128256 × 0x1000 = 0x1F500000` = **501 MiB** |
| DDR 区域 | `0x0000_0000` .. `0x1F4F_FFFF` |
| 与 LM head | **共享**同一段 DDR（Plan A weight tying） |

PyTorch 对应：`nn.Embedding(128256, 2048)` 的 `weight[token_id]` 行。

---

## 3. 地址公式

```text
EMB_BASE    = 0x0000_0000        // 固定
ROW_BYTES   = 0x0000_1000

emb_row_base(token_id) = EMB_BASE + token_id * ROW_BYTES

约束:
  token_id  : 0 .. 128255   // 17 bit；≥128256 为非法，Scheduler 应报错、不发 MemCmd
  行内偏移  : 0 .. 0xFFF     // 由 DdrAgent 整行读取，不需单独指定
```

| token_id | 行基址 |
|:---:|:---|
| 0 | `0x0000_0000` |
| 1 | `0x0000_1000` |
| 128255 | `0x1F4FF000` |

完整 DDR 全局 map 见 [ddr-memory-map.md](../../ddrMemoryMap/doc/ddr-memory-map.md)。

---

## 4. DDR 行内布局

与 `model.embed_tokens.weight` 行主序一致，little-endian FP16：

```text
row[token_id]:
  [elem_0][elem_1] ... [elem_2047]
  每 elem 16 bit，共 4096 B
```

离线打包（伪代码）：

```python
for tid in range(128256):
    dst = tid * 0x1000
    write_ddr(dst, weight_bf16[tid].astype(fp16), 4096)
```

---

## 5. 每 token DDR 访问特征

| 项目 | 值 |
|:---|:---|
| 访问量 | **4 KiB** / token |
| 访问模式 | **随机读**（行间地址跳跃） |
| 行内模式 | 连续，适合 256 B AXI burst × 16 |
| Prefill / Decode | **相同**；均由 `token_id` 决定行地址，与 `JOB_PHASE` 无关 |

---

## 6. 输出 AXI-Stream 约定（→ RMSNorm `dataIn`）

读回数据由 **DdrAgent** 的 `EMBED_ROW` sink 直接驱动 `RmsNorm.dataIn`（不经独立 Reader 模块）。`tuser` 由 Scheduler 在 `MemCmd` 上下文中附带，DdrAgent 在输出首 beat 锁存。

**Profile A（layer-wide vector）**，作为 layer 0 norm1 输入：

| 位 | 字段 | 值 |
|:---:|:---|:---|
| `[15]` | `busy` | 非最后 beat = 1，最后 beat = 0 |
| `[14:11]` | `layerId` | `0` |
| `[10:9]` | `normKind` | `0`（norm1） |
| `[8:0]` | `tokenSeqLow` | `seq_pos[8:0]` |

- `tdata`：16-bit FP16，共 **2048 beat**，末 beat `tlast=1`。
- 详细握手语义见 [rms-norm-module-design.md](../../rmsNorm/doc/rms-norm-module-design.md)。

---

## 7. 端到端数据流（查表视角）

```text
ARM 写 token_id
    → LlamaScheduler 校验 token_id，计算 emb_row_base
    → MemCmd(READ, sink=EMBED_ROW, len=4096, addr, axis_ctx)
    → DdrAgent AXI 读 DDR → AXI-Stream 2048 beat → RmsNorm.dataIn
    （并行）MemCmd(READ, sink=RMS_GAMMA, len=4096, gamma_addr(0,0))
    → DdrAgent 读 DDR @ RMS_GAMMA_BASE → AXI-Stream 2048 beat → RmsNorm.weightIn
    → RmsNorm.dataOut → 后续 Attention
```

γ 的 DDR 布局见 [ddr-memory-map.md](../../ddrMemoryMap/doc/ddr-memory-map.md) §4。

---

## 8. 验证要点

| 用例 | 检查项 |
|:---|:---|
| token_id = 0 | AXI AR 地址 = `0x0`，长度 4096 B |
| token_id = 128255 | AR 地址 = `0x1F4FF000` |
| token_id = 128256 | `ERROR_CODE=token_id_oob`，无 DDR 请求 |
| 数值 | `dataIn` 2048 beat 与 DDR preload 一致；`dataOut` 与 Python `rms_norm(emb[tid] * gamma0)` 一致 |

仿真可在 DDR 模型 `0x0` 预置 2–3 行已知向量；不必实例化独立 Embedding RTL。

---

## 9. 相关文档

| 文档 | 内容 |
|:---|:---|
| [llama-scheduler-design.md](../../llamaScheduler/doc/llama-scheduler-design.md) | `token_id` 锁存、`MemCmd` 生成、里程碑 FSM、gamma 路由 |
| [ddr-agent-design.md](../../ddrAgent/doc/ddr-agent-design.md) | AXI burst、`EMBED_ROW` sink、DDR → AXI-Stream |
| [rms-norm-module-design.md](../../rmsNorm/doc/rms-norm-module-design.md) | RMSNorm 接口与 `tuser` |
