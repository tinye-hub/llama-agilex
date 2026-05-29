# GemvService64 — 通用 64-MAC GEMV 计算服务模块设计

> 本文档基于 [llama3.2-1b-arch-for-fpga-design.md](../../../../doc/llama3.2-1b-arch-for-fpga-design.md) 的 §6–§10 资源分析，以及现有 Scala RTL（`MulAddEngineNew`、`MulAddSGNew`、`DataPath`）的代码审阅，给出 Llama 3.2 1B FPGA 实现中**通用 GEMV 计算服务模块**的职责边界、接口设计和各调用点映射。
>
> **主线配置**：Agilex 5E 013B + 2 GB LPDDR4 @ 2133 MT/s，1K token，W4A16，KV FP16，Plan A（Embedding/LM head 共享 FP16 权重）。

---

## 1. 为什么需要通用 GEMV 服务模块

Llama 3.2 1B 的 decode 流水里，所有"大矩阵 × 向量"操作（线性投影、QK 点积、AV 加权、LM head）本质上都是**同一个算子**：

```
y[m] = Σ_{k} W[m,k] · x[k]    (m = 0..M-1,  k = 0..K-1)
```

这些操作在硬件上共享相同的 DSP 拓扑（FP16 mul × 64 lane + FP32 acc），只是 **M、K、权重来源、输入来源、输出去向**不同。  
如果为每个算子单独实例化一套 DSP 阵列，资源会成倍浪费；共用同一个"GEMV 服务模块"，按 descriptor 时分调度，DSP 利用率最高。

**现有 RTL 已经走在这个方向上**：`DataPath.scala` 只实例化了一套 `MulAddSGNew`（第 474 行），并把 attention、FFN、LM head、残差加等的数据流全部汇聚到这一个 engine 上。本文档是这一设计的显式规范化描述，并补充了 Llama 3.2 1B 参数维度、descriptor 格式、调用点映射和调度约束。

---

## 2. 64-MAC 与 bankLen=32 的关系

| 参数 | 值 | 说明 |
|:---|:---:|:---|
| `width` | 16 bit | FP16 |
| `bankLen` | 32 | 并行处理的 FP16 元素数 |
| 并行位宽 | 512 bit | `width × bankLen = 16 × 32` |
| 每块 DSP FP16 吞吐 | 2 MAC/cycle | Agilex 5E Variable Precision DSP 标准模式 |
| 32 lane × 2 MAC = **64 MAC/cycle** | — | 对应"64-MAC 引擎"的来源 |
| GEMV 乘法 DSP block 数 | 32 | `32 lane ÷ 2 MAC/block` |
| 含 FP32 acc + Softmax 辅助 | +6 | 详见 §7.10.2 of arch doc |
| **GEMV 引擎总 DSP block** | **38** | 占 Agilex 5E 013B 全部 188 块的 **20.2%** |

---

## 3. 各步骤的调用点分类

### 3.1 应由 GemvService64 处理（标准 GEMV/DOT）

以下步骤都是"大矩阵 × 向量"，内积长度大或输出行数大，适合由通用模块处理：

| 步骤 | 操作名 | 权重形状 `[M, K]` | 内积长度 K | 输出行数 M | 每 token DDR（INT4）|
|:---|:---|:---:|:---:|:---:|:---:|
| Attention Q 投影 | `W_Q · x` | `[2048, 2048]` | 2048 | 2048 | 2 MiB/层 |
| Attention K 投影 | `W_K · x` | `[512, 2048]` | 2048 | 512 | 512 KiB/层 |
| Attention V 投影 | `W_V · x` | `[512, 2048]` | 2048 | 512 | 512 KiB/层 |
| Attention QK 点积 | `q_h · K_cache^T` | KV cache | 64 (head\_dim) | t (seq len) | — |
| Attention AV 加权 | `softmax · V_cache` | KV cache | t (seq len) | 64 (head\_dim) | 32 MiB/token |
| Attention 输出投影 | `W_O · attn_out` | `[2048, 2048]` | 2048 | 2048 | 2 MiB/层 |
| FFN gate\_proj | `W_g · x` | `[8192, 2048]` | 2048 | 8192 | 8 MiB/层 |
| FFN up\_proj | `W_u · x` | `[8192, 2048]` | 2048 | 8192 | 8 MiB/层 |
| FFN down\_proj | `W_d · z` | `[2048, 8192]` | 8192 | 2048 | 8 MiB/层 |
| LM head | `W_out · h_norm` | `[128256, 2048]` | 2048 | 128256 | 501 MiB/token |

> **QK 和 AV 是"内积"而非大矩阵 GEMV**：这两步 K 维度是 head\_dim=64 或 seq\_len t，输入来自 KV cache，与权重矩阵 GEMV 的访问模式不同。可以由同一引擎处理，但需要 descriptor 中区分 `input_src=kv_cache` 和 `weight_src=w_ddr`。

### 3.2 不建议并入 GemvService64（专用算子）

这些步骤有特殊的计算形态，强行并入会增加调度复杂度，收益有限：

| 步骤 | 原因 | 推荐做法 |
|:---|:---|:---|
| Token Embedding 查表 | 随机读一行，无 MAC | 独立 DDR 行读取，不占 GEMV 引擎 |
| RMSNorm × 33 实例 | 平方归约→rsqrt→逐元素乘，非矩阵；内部 FP32 | `RMSNormFp32` 专用模块，可复用 FP32 acc 单元 |
| RoPE（SerialRoPE） | element-wise `x·cos + rot·sin`，形状固定 head\_dim=64 | `SerialRoPE` 专用，16 个 DSP block 独占 |
| SiLU + `gate * up`（UGMul） | 逐元素激活 + Hadamard 乘，8192 维 | `SiluFp32` + `UGMul` 专用，与 GEMV 流水衔接 |
| Softmax（SerialSafeSoftmax） | 找 max、exp LUT、归一化、安全数值 | 独立 Softmax 模块，少量 DSP（+2 block exp/div） |
| Sampling（GreedySampler） | 比较、LFSR、累积采样 | 独立，无 DSP |

---

## 4. 维度不一致问题：tile 化统一

所有 GEMV 无论 M/K 维度多大，都可以用固定 64-lane tile 表达，不存在维度冲突：

```
for out_row in 0 .. M-1:
    acc = FP32(0)
    for k_tile in 0 .. ceil(K / 64) - 1:
        acc += dot64(
            x[k_tile*64 : k_tile*64+63],
            W[out_row][k_tile*64 : k_tile*64+63]
        )
    y[out_row] = FP16(acc)
```

**各操作的 tile 数对比**：

| 操作 | M | K | tile 数 = ⌈K/64⌉ |
|:---|:---:|:---:|:---:|
| Q/K/V/O 投影 | 2048 / 512 | 2048 | **32** |
| QK attention（1 个 Q head） | t | 64 | **1** |
| AV attention（1 个 head）| 64 | t=1024 | **16** |
| FFN gate/up | 8192 | 2048 | **32** |
| FFN down | 2048 | 8192 | **128** |
| LM head | 128256 | 2048 | **32** |

因此 **GemvService64 只需要 M、K 两个动态参数** 就能支持 Llama 3.2 1B 所有大矩阵算子，无需为不同维度设计不同硬件。

> **LM head 的 M=128256 超出 16-bit（65535）**：`MulEngine.Config` 里的 `secondDim` 是 16-bit，**需要扩展或分段调度**。建议把 LM head 拆为 2 段（0..65535 + 65536..128255），或将 `outRows` 字段扩展到 17 bit。现有 `secondDim = data.take(16)` 仅支持到 65536，处理 LM head 时需注意。

---

## 5. Descriptor 格式设计

建议在现有 `MulEngine.Config`（32 bit 控制字）的基础上，扩展为支持完整 GEMV 的 **64-bit descriptor**：

```
Descriptor (64 bit)
 ┌─────────┬──────────┬──────────┬─────────┬─────────┬──────────┬──────────────────┐
 │ [63:58] │ [57:54]  │ [53:50]  │ [49:38] │ [37:32] │ [31:17]  │ [16:0]           │
 │  tag    │ weight_  │ input_   │ K       │ post_op │ M (17b)  │ K (17b)          │
 │ (6 bit) │ format   │ src      │ tile_cnt│ (6 bit) │          │                  │
 └─────────┴──────────┴──────────┴─────────┴─────────┴──────────┴──────────────────┘
```

各字段语义：

| 字段 | 位宽 | 枚举值 |
|:---|:---:|:---|
| `tag` | 6 | 与 AXI tuser 对齐，用于路由输出流向各消费模块 |
| `weight_format` | 4 | `0=FP16, 1=INT4_G128, 2=INT8, 3=KV_FP16` |
| `input_src` | 4 | `0=act_buf, 1=q_buf, 2=softmax_buf, 3=kv_cache` |
| `post_op` | 6 | `0=none, 1=res_add, 2=sqrt_scale, 3=quant_write, 4=dequant, 5=fp16_out` |
| `M` | 17 | 输出行数（支持到 128256+，满足 LM head） |
| `K` | 17 | 内积长度 |

> 对于当前 32-bit 控制字（`firstDim` + `secondDim` + 标志位），只需后向兼容地把 `secondDim` 从 16-bit 扩展到 17-bit，即可支持 LM head，同时保留现有 Q/K/V/FFN 的调度逻辑不变。

---

## 6. Scheduler 调度约束

每个 token 的层内调度顺序（硬件时序约束）：

```
         Layer N
         ┌──────────────────────────────────────────────────────────────────────┐
         │                                                                      │
  DDR ──►│  attn_norm_γ  W_Q  W_K  W_V  KV_cache  W_O  ffn_norm_γ  W_G  W_U  W_D │──► DDR
         │     ↕          ↕    ↕    ↕       ↕       ↕       ↕        ↕    ↕    ↕  │
GEMV ────►  (skip)        ✓    ✓    ✓   QK+AV       ✓    (skip)      ✓    ✓    ✓  ├──►
         │                                                                      │
         └──────────────────────────────────────────────────────────────────────┘
                                                                ↓ (layer 16 后)
                                              final_norm_γ  LM_head (W_out)
                                                   ↕              ✓
                                               (skip)         GEMV 128256 行
```

**关键约束**：

1. **串行不可并行**：同一层内，W_Q 必须等 RMSNorm 完成后才能开始；W_K/W_V 可与 W_Q 流水（共享 activation x，按 head 分段发 descriptor）；W_O 必须等 AV 加权完成后才能开始。
2. **KV Cache 写与读必须在同一层内完成**：写（K_t, V_t）后才能用于当前 token 的 QK/AV。
3. **LM head 严格串行**：不能与下一个 token 的 Embedding 重叠（因果依赖，token N+1 的 id 要等 token N 的 sampling 完成才知道）。
4. **DDR-GEMV 天然重叠**：每读到一个 64 元素权重 tile 就立刻喂入计算，单个 GEMV 内部无需等待全部权重到齐。

---

## 7. 与现有 RTL 的对照

| 现有 Scala 模块 | GemvService64 的对应 | 改造建议 |
|:---|:---|:---|
| `MulEngine` | GEMV 乘法核（DOT 路径）| 保留，`secondDim` 扩至 17 bit 以支持 LM head |
| `AddEngineNew` | FP16 adder-tree + FP32 acc | 保留，FP32 acc 跨 tile 累加已实现 |
| `Fp32AccEngine` | 多 bank FP32 归约 + postScale | 保留，`postScale` 对应 INT4 反量化 scale |
| `MulAddEngineNew` | MulEngine + AddEngineNew 的组合 | 保留，已是"通用"内核 |
| `MulAddSGNew` | 多 split bank + Fp32AccEngine，DataPath 唯一引擎实例 | 保留，这就是 GemvService64 的 RTL 实体 |
| `DataPath` L474 `engine = new MulAddSGNew(...)` | GemvService64 实例化点 | 不改，只在此基础上规范化 descriptor 格式 |
| `GenMemCmdLenAlign` / `StateGen` | GEMV 的 descriptor 生成器和状态机 | 扩展支持 17-bit outRows，增加 LM head 分段 |

---

## 8. 各专用模块的 DSP 预算汇总

| 模块 | DSP block 数 | 比例（188 总） | 备注 |
|:---|:---:|:---:|:---|
| **GemvService64**（`MulAddSGNew`）| **38** | **20.2%** | FP16 mul 32 + FP32 acc/adder-tree 3 + Softmax exp/div 2 + rsqrt 1 |
| `SerialRoPE` | 16 | 8.5% | Q/K 旋转，独占 |
| `RMSNormFp32` | ≤ 2 | 1.1% | rsqrt + FP32 acc，可复用 GemvService64 的 rsqrt 单元 |
| `SiluFp32` + `UGMul` | ≤ 4 | 2.1% | exp + mul，不占主 GEMV |
| `SerialSafeSoftmax` | 已含于 GemvService64 的 +2 | — | 共享 exp/div |
| `GreedySampler` | 0 | 0% | 纯 LUT 实现 |
| **已用小计** | **~60** | **~32%** | |
| **剩余可用** | **~128** | **~68%** | 用于 FIFO、仲裁、ping-pong buffer、timing closure 等 |

---

## 9. 片上 SRAM（M20K）小表预算

以下小表在推理启动时一次性预加载到片上，运行时不再访问 DDR：

| 数据 | 大小 | 类型 |
|:---|:---:|:---|
| 所有 RMSNorm γ（33 实例） | **132 KB** | FP16，片上 M20K |
| RoPE cos/sin 裁剪表（1K token） | **256 KB** | FP16，2 × 1024 × 64 × 2B |
| SiLU exp LUT | **4 KB** | FP16，256 entry |
| logits 缓冲（LM head 输出）| **257 KB** | FP16，128256 × 2B |
| ping-pong weight tile buffer | **~8 KB** | 2 × 4 KB，GemvService64 内部 |
| **合计** | **~657 KB** | Agilex 5E 013B M20K 总容量 ≈ 870 KB（358 个 M20K） |

> 657 KB / 870 KB = **75.5%** 的 M20K 片上容量被小表占用，剩余约 213 KB 可用于 FIFO 和控制逻辑。若需要扩展上下文（8K+），RoPE 表需搬回 DDR。

---

## 10. 总结：GemvService64 的定位

```
┌──────────────────────────────────────────────────────────────────┐
│                    Transformer Datapath                          │
│                                                                  │
│  Scheduler / StateGen                                            │
│       │  descriptor (64-bit: tag + format + src + M + K + post) │
│       ▼                                                          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GemvService64  (MulAddSGNew)                │   │
│  │  ┌──────────┐  ┌──────────────┐  ┌──────────────────┐   │   │
│  │  │ DDR tile │  │ INT4 unpack  │  │ 32×FP16 mul lane │   │   │
│  │  │ prefetch │→ │ + dequant    │→ │  = 64 MAC/cycle  │   │   │
│  │  └──────────┘  └──────────────┘  └────────┬─────────┘   │   │
│  │                                           │             │   │
│  │                                   ┌───────▼──────────┐  │   │
│  │                                   │ FP16 adder-tree  │  │   │
│  │                                   │  + FP32 cross-   │  │   │
│  │                                   │  tile accumulate │  │   │
│  │                                   └───────┬──────────┘  │   │
│  │                                           │             │   │
│  │                                   ┌───────▼──────────┐  │   │
│  │                                   │ post-op router   │  │   │
│  │                                   │ (by tag/stage)   │  │   │
│  └───────────────────────────────────┴──────────────────-┘  │   │
│       │                                                      │   │
│       └─────────────────────────────────────────────────     │   │
│         output → RoPE / KV writer / FFN / Softmax / LM head │   │
│                                                              │   │
│  专用旁路模块（不占用 GemvService64）：                        │   │
│    RMSNormFp32 · SerialRoPE · SiluFp32 · SerialSoftmax       │   │
│    UGMul · GreedySampler · ResidualBuffer · AllGather        │   │
└──────────────────────────────────────────────────────────────────┘
```

**一句话原则**：  
**所有"矩阵×向量"操作统一进 GemvService64；所有"逐元素/归一化/激活/采样"操作保留专用模块。** 两类之间通过 AXI-Stream tuser tag 路由，Scheduler 通过 descriptor 流控制调度顺序。
