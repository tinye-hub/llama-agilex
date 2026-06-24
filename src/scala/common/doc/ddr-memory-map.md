# DDR 全局地址规划（Plan A · DE25-Nano）

> **单一真相源**：离线打包脚本、LlamaScheduler 地址译码、DdrAgent、HPS 灌库程序均以此为准。  
> Scala 常量：`DdrMemoryMap.scala`（逻辑地址与本文一致）。

**模型**：Llama 3.2 1B Plan A · W4A16 · KV FP16 · FP16 embedding + FP16 RMSNorm γ · 1K context  
**目标板**：Terasic DE25-Nano（Agilex 5E 013B）· 2×1 GiB LPDDR4（LPDDR4A + LPDDR4B）

---

## 1. 两层地址：逻辑 vs 物理

| 层次 | 谁使用 | 说明 |
|:---|:---|:---|
| **逻辑地址** | Scheduler、`MemCmd.ddr_addr`、离线打包 | 自 `0x0000_0000` 起的 **PL 模型窗口**；各 `*_BASE` 常量不变 |
| **物理颗粒** | Qsys、HPS device tree、WeightLoader | DE25-Nano 上 **整块模型镜像落在 LPDDR4B**；LPDDR4A 仅 HPS |

```text
逻辑（PL 视角，不变）              物理（DE25-Nano 当前主线）
─────────────────────              ───────────────────────────
0x0000_0000 .. 0x3FFF_FFFF    →    LPDDR4B 字节 0 .. 1 GiB−1
0x4000_0000 .. 0x7FFF_FFFF    →    未映射（扩展预留；需第二 GB 或迁 A）
                                   LPDDR4A：HPS / Linux，不承载模型区
```

**DdrAgent** 在 DE25-Nano 上只接 **LPDDR4B Fabric EMIF**（256-bit AXI4）。`MemCmd` 中的逻辑地址即 B 片物理字节偏移（当前实现不做 bank 译码）。

---

## 2. DE25-Nano 物理划分

| 颗粒 | 容量 | 用途 |
|:---|:---:|:---|
| **LPDDR4A** | 1 GiB | HPS EMIF：U-Boot / Linux / 用户态；**不存放模型权重** |
| **LPDDR4B** | 1 GiB | Fabric EMIF：**全部模型逻辑区**（§3，含 Embedding） |

```text
        HPS (ARM)                         PL (Fabric)
            │                                  │
            │ 启动：SD/文件 → 灌库 → B 片       │ 推理：DdrAgent → LPDDR4B
            ▼                                  ▼
     ┌──────────────┐                   ┌──────────────┐
     │  LPDDR4A     │                   │  LPDDR4B     │
     │  Linux DDR   │                   │  Plan A 镜像 │
     │  (reserved)  │                   │  0x0..0x3FFF │
     └──────────────┘                   └──────────────┘
```

**启动**：HPS 将离线打包好的连续镜像写入 **B 片物理地址 0** 起（经 `hps2fpga` + WeightLoader / DMA 等，实现见 SoC 集成文档）。  
**推理**：HPS 经 `HpsJobCtrl` 下发 `token_id` / `job_start`；PL 经 **DdrAgent** 读 B 片（含 `EMBED_ROW`、`RMS_GAMMA` 等）。

板载 **128 MiB SDRAM** 不纳入本地址规划。

---

## 3. 逻辑地址总览（LPDDR4B 镜像布局）

逻辑区占用 `0x0000_0000` .. `0x3FFF_FFFF`（**1 GiB**），与 B 片容量对齐。

```text
0x0000_0000 ┌────────────────────────────────────────┐
            │  Embedding / LM head 共享表      501 MiB    │
0x1F4F_FFFF ├────────────────────────────────────────┤
0x1F50_0000 │  RMSNorm γ（33×2048 FP16）       132 KiB   │
0x1F52_0FFF ├────────────────────────────────────────┤
            │  对齐空洞（无 payload）         ~10.87 MiB  │
0x1FFF_FFFF ├────────────────────────────────────────┤
0x2000_0000 │  Attention INT4 权重             80 MiB   │
0x24FF_FFFF ├────────────────────────────────────────┤
0x2500_0000 │  FFN INT4 权重                  384 MiB   │
0x3CFF_FFFF ├────────────────────────────────────────┤
0x3D00_0000 │  KV Cache（1K, FP16）             32 MiB   │  运行时读写
0x3EFF_FFFF ├────────────────────────────────────────┤
0x3F00_0000 │  Metadata                        16 MiB   │
0x3FFF_FFFF └────────────────────────────────────────┘
0x4000_0000 ┌────────────────────────────────────────┐
            │  扩展预留（当前未用）            1024 MiB   │  → 需 overflow 策略
0x7FFF_FFFF └────────────────────────────────────────┘
```

| 区域 | 基址 | 长度 | 属性 |
|:---|:---:|:---:|:---|
| Embedding / LM head | `EMB_BASE = 0x0000_0000` | 501 MiB | 启动写入；推理读（PL） |
| RMSNorm γ | `RMS_GAMMA_BASE = 0x1F50_0000` | 132 KiB | 启动写入；推理读 |
| Attention INT4 | `ATTN_BASE = 0x2000_0000` | 80 MiB | 启动写入；推理读 |
| FFN INT4 | `FFN_BASE = 0x2500_0000` | 384 MiB | 启动写入；推理读 |
| KV Cache | `KV_BASE = 0x3D00_0000` | 32 MiB | 推理读写 |
| Metadata | `META_BASE = 0x3F00_0000` | 16 MiB | 启动写入；GEMV 读 scale |

---

## 4. 容量核算（LPDDR4B 1 GiB）

### 4.1 实际数据字节

| 区域 | 字节 | MiB (1024²) |
|:---|---:|---:|
| Embedding | 525,336,576 | 501.00 |
| RMS γ | 135,168 | 0.13 |
| Attention | 83,886,080 | 80.00 |
| FFN | 402,653,184 | 384.00 |
| KV Cache | 33,554,432 | 32.00 |
| Metadata | 16,777,216 | 16.00 |
| **合计** | **1,062,342,656** | **1013.13** |

另：**对齐空洞**（`0x1F52_1000` .. `0x1FFF_FFFF`）占地址但不存 payload，约 **10.87 MiB**。

### 4.2 与 1 GiB 的关系

| 口径 | 大小 | 余量（vs 1 GiB） |
|:---|---:|---:|
| 逻辑地址跨度（含空洞） | 1024.00 MiB | **0** |
| 实际数据合计 | 1013.13 MiB | **~10.87 MiB** |

结论：**当前 Plan A 刚好落在单片 1 GiB 内，余量很小。** 扩展区 `0x4000_0000` 在 B 片上**无物理空间**；若未来不够，按 §9 迁部分区域到 LPDDR4A 或启用第二颗粒。

不含 Metadata 的静态 + KV（文档常引用的「997 MiB」）：

```text
501 + 0.13 + 80 + 384 + 32 ≈ 997.13 MiB
```

---

## 5. 通用常量

```text
VECTOR_DIM     = 2048
FP16_BYTES     = 2
ROW_BYTES      = 4096 = 0x1000        // embedding 行 / gamma 向量
VOCAB_SIZE     = 128256
GAMMA_COUNT    = 33
N_LAYERS       = 16
MAX_CONTEXT    = 1024                   // 1K（主线）
LAYOUT_MAGIC   = 0x4C4D3332           // "LM32"
LAYOUT_VERSION = 1                      // 逻辑布局版本；物理映射见 §2
```

---

## 6. Embedding / LM head

与 input embedding、LM head **共享**一份 FP16 表（Plan A weight tying）。

```text
EMB_BASE = 0x0000_0000
EMB_SIZE = VOCAB_SIZE * ROW_BYTES = 0x1F500000   // 501 MiB

emb_row_base(token_id) = EMB_BASE + token_id * ROW_BYTES
token_id : 0 .. 128255
```

| 场景 | 访问模式 | 执行方（DE25-Nano 主线） |
|:---|:---|:---|
| 输入 embedding | 按 `token_id` 读 **1 行**（4 KiB） | PL：`MemCmd` → DdrAgent `EMBED_ROW` |
| LM head | 顺序扫全表或分块 GEMV | PL（里程碑 3+）；或 hidden 交 HPS 在 ARM 上算 LM head |

---

## 7. RMSNorm γ

权威副本在 DDR；片上只缓存当前一组 2048 FP16。

```text
RMS_GAMMA_BASE = 0x1F50_0000
总量 = 33 * ROW_BYTES = 0x21000   // 132 KiB

normKind : 0=norm1, 1=norm2, 2=final_norm
gamma_index(layer, normKind) = (normKind == 2) ? 32 : (layer * 2 + normKind)
gamma_addr(layer, normKind) = RMS_GAMMA_BASE + gamma_index * ROW_BYTES
```

每 token 全层 decode：**33 × 4 KiB = 132 KiB** γ 读取（可与 embedding 读并行 outstanding）。

| 调用点 | 地址 |
|:---|:---|
| L0 norm1（里程碑 1） | `0x1F50_0000` |
| L0 norm2 | `0x1F50_1000` |
| final_norm | `0x1F52_0000` |

---

## 8. Attention / FFN（INT4 payload）

权重区存 **INT4 裸 payload**；反量化用 §10 Metadata 中的 scale 表。

```text
ATTN_BASE = 0x2000_0000
ATTN_LAYER_STRIDE = 0x0050_0000   // 5 MiB / layer

attn_layer_base(l) = ATTN_BASE + l * ATTN_LAYER_STRIDE
W_Q(l) = attn_layer_base(l) + 0x0000_0000   // 2 MiB
W_K(l) = attn_layer_base(l) + 0x0020_0000   // 512 KiB
W_V(l) = attn_layer_base(l) + 0x0028_0000   // 512 KiB
W_O(l) = attn_layer_base(l) + 0x0030_0000   // 2 MiB
```

```text
FFN_BASE = 0x2500_0000
FFN_LAYER_STRIDE = 0x0180_0000   // 24 MiB / layer

ffn_layer_base(l) = FFN_BASE + l * FFN_LAYER_STRIDE
gate_proj(l) = ffn_layer_base(l) + 0x0000_0000   // 8 MiB
up_proj(l)   = ffn_layer_base(l) + 0x0080_0000
down_proj(l) = ffn_layer_base(l) + 0x0100_0000
```

GEMV tile：**64 个 INT4 权重 = 32 B payload**；建议 256 B+ AXI burst，经 unpack/dequant 后送入 FP16 MAC。

---

## 9. KV Cache（1K, FP16, token-major）

```text
KV_BASE = 0x3D00_0000
KV_LAYER_STRIDE = 0x0020_0000
KV_TOKEN_STRIDE = 0x0000_0800      // K 1 KiB + V 1 KiB

kv_token_base(l, t) = KV_BASE + l * KV_LAYER_STRIDE + t * KV_TOKEN_STRIDE
K_addr(l, t) = kv_token_base(l, t)
V_addr(l, t) = kv_token_base(l, t) + 0x0400
```

---

## 10. Metadata

```text
META_BASE = 0x3F00_0000

0x3F00_0000   GlobalHeader      4 KiB     magic, layout_version, 各 BASE 回显
0x3F00_1000   AttnScaleTable    2 MiB     Attention INT4 的 group scale/zero
0x3F20_0000   FfnScaleTable     8 MiB     FFN INT4 的 group scale/zero
0x3F80_0000   Reserved
```

| 子表 | 作用 |
|:---|:---|
| **GlobalHeader** | 打包校验；`layout_version` 变更时同步 RTL / 文档 |
| **AttnScaleTable** | 配合 `ATTN_BASE` 80 MiB INT4，GEMV 前 dequant |
| **FfnScaleTable** | 配合 `FFN_BASE` 384 MiB INT4 |

里程碑 1 **不使用** Metadata；里程碑 2+ GEMV 启用。

---

## 11. 未来扩展：LPDDR4A overflow

当 B 片 1 GiB 不足时（更长 KV、Plan B LM head、调试缓冲、`ext` 区等），**不改变逻辑地址语义**，仅增加 **物理 bank 译码**：

| 逻辑范围 | 当前物理 | overflow 选项 |
|:---|:---|:---|
| `0x0000_0000` .. `0x3FFF_FFFF` | LPDDR4B | 可将冷区（如 FFN 部分、`ext`）迁至 **LPDDR4A** reserved 区 |
| `0x4000_0000` .. `0x7FFF_FFFF` | 未映射 | 优先落 A 片，PL 经 **F2SDRAM** 读 |

实施时：递增 `layout_version`；`DdrAgent` 按逻辑地址选 B-EMIF 或 F2SDRAM；HPS device tree 为 A 片 overflow 区增加 `reserved-memory`。

---

## 12. 片上存储（非 DDR）

| 数据 | 存放 |
|:---|:---|
| RMSNorm γ 工作副本 | 片上（当前 beat）；权威在 DDR §7 |
| RoPE cos/sin | 片上 ~256 KiB @ 1K |
| logits 缓冲 | 片上 ~257 KiB |
| GEMV tile ping-pong | 片上 8–32 KiB |

---

## 13. 相关文档

| 文档 | 内容 |
|:---|:---|
| [token-embedding-design.md](../../tokenEmbed/doc/token-embedding-design.md) | Embedding 查表 |
| [llama-scheduler-design.md](../../llamaScheduler/doc/llama-scheduler-design.md) | MemCmd |
| [ddr-agent-design.md](../../ddrAgent/doc/ddr-agent-design.md) | sink / AXI |
| [llama-m1-top-design.md](../../top/doc/llama-m1-top-design.md) | 顶层互联 |
