# SerialSafeSoftmax 模块设计说明（审阅稿）

> **里程碑**：M2c — Incremental GQA attention 子路径中的 **per-head softmax**。  
> **上游**：`GqaAttention` QK 点积输出的未归一化分数 `s[0..N-1]`（FP16）。  
> **下游**：`GqaAttention` AV 加权使用的注意力权重 `a[0..N-1]`（FP16，行和 ≈ 1）。  
> **仿真**：仅 **Questa**（真实 Quartus FP IP + Agilex 5 simlib）；**不做 Verilator**。

**架构背景**：[llama3.2-1b-arch-for-fpga-design.md](../../../../doc/llama3.2-1b-arch-for-fpga-design.md) §6.3 步骤 2、§9.4、§11.5  
**里程碑总览**：[milestone-m2.md](../../../../doc/milestone-m2.md) M2c  
**接口风格参考**：[rms-norm-module-design.md](../../rmsNorm/doc/rms-norm-module-design.md)、[rope](../rope/) `RoPEAxisCfg`

---

## 1. 设计目标与边界

### 1.1 做什么

对 **变长** FP16 分数向量做 **数值稳定 softmax**（Serial + Safe）：

$$
a_i = \frac{\exp(s_i - s_{\max})}{\sum_{j=0}^{N-1}\exp(s_j - s_{\max})}, \quad i \in [0, N-1]
$$

| 项目 | 取值 |
|:---|:---|
| 主线上下文 | decode / Plan B prefill，**1K**（`maxPos = 1024`） |
| 单次调用长度 $N$ | $t+1$，$t \in [0, 1023]$ → **$N \in [1, 1025]$** |
| 每 token 调用次数 | 32 个 Q head × 16 层 = **512 次**（L0 里程碑可先测 1 head） |
| 输入/输出格式 | FP16 AXI4-Stream |
| 内部累加域 | **FP32**（与 RMSNorm / GEMV 主线一致） |
| temperature | **无**（attention softmax 不做温度缩放；LM head 另模块） |
| causal mask | **无**（decode 下 KV 长度本身保证因果性） |

### 1.2 不做什么（v1）

| 不做 | 归属 |
|:---|:---|
| QK 点积、AV 加权 | `GqaAttention` |
| KV cache DDR 读写 | `DdrAgent` KV sink |
| LM head 128256 维 softmax | M3+ `LmHeadSoftmax`（可复用本核，但 v1 不优化该尺度） |
| top-k / top-p / sampling | `GreedySampler` |
| Verilator smoke | 本模块策略：Questa only |
| 与 `GemvService64` 内嵌合并 | 架构定为**专用旁路模块** |

### 1.3 与 LM head Softmax 的关系

架构文档中 LM head 与 attention 共用 **exp LUT + 归一化** 思路，但：

| 维度 | Attention（本模块 v1） | LM head（未来） |
|:---|:---|:---|
| $N$ | 1 .. 1025 | 128256 |
| 调用频率 | 512 / token | 1 / token |
| 片上缓冲 | ≤ 2.1 KiB | 257 KiB logits 缓冲 |

v1 只为 attention 尺度优化；LM head 可 later 复用 `SoftmaxExpLut` + `fp32Div`，或换宽并行实现。

---

## 2. 数学与数值策略

### 2.1 Stable softmax（Safe）

标准三步，**全部在减去 $s_{\max}$ 之后** 做 exp，避免溢出：

```text
PASS_COLLECT : 流式读入 s[i]，更新 s_max，写入 scoreBuf[i]
PASS_EXP_SUM : 读 scoreBuf[i]，d = s[i] - s_max (FP32)，e = exp(d)，写 expBuf[i]，sum += e (FP32)
PASS_EMIT    : inv = 1/sum (FP32)，读 expBuf[i]，w = e * inv (FP32→FP16)，输出 a[i]
```

### 2.2 输入分数范围

QK 输出已含 $1/\sqrt{d_{\text{head}}}$ 缩放（$d_{\text{head}}=64$）。典型 $|s_i| \lesssim 10$；极端情况允许到 $\pm 20$。  
减 max 后 $d_i \le 0$，故 **exp 自变量非正**，适合 **有限区间 LUT**。

### 2.3 边界条件

| 场景 | 期望行为 |
|:---|:---|
| $N=1$ | $a_0 = 1.0$（FP16） |
| 全 $-\infty$ / 极大负分 | $\sum \to 0$：**安全分支**输出均匀 $1/N$ 或全零（见 §6.4，需与 golden 对齐） |
| 两个相等 max | 正常；减 max 后均为 0 → exp=1 |
| 背压 / `valid` 间断 | 计数器仅在 `fire` 时推进 |
| 连续两次调用 | `tuser` 不串扰；内部 FSM 在输出 `tlast` 后回 IDLE |

### 2.4 Golden 参考（Python）

```python
import torch

def golden_softmax_fp16(scores_fp16: torch.Tensor) -> torch.Tensor:
    """scores: [N] FP16; returns [N] FP16 attention weights."""
    s = scores_fp16.float()
    s = s - s.max()
    e = torch.exp(s)
    return (e / e.sum()).half()
```

Questa 容差（初稿，IP 定稿后复测）：

| 阶段 | 准则 |
|:---|:---|
| 端到端 | 与 FP32 参考转 FP16 后 **≤ 1 ULP**，或 `rtol=1e-3, atol=1e-4` |
| 行和 | $\|\sum_i a_i - 1\| < 10^{-3}$（FP16 累加） |

---

## 3. 顶层互联

```text
GqaAttention (QK)
      │  scoresIn  AXI4-Stream (FP16 × N, tlast @ N-1)
      ▼
┌─────────────────────┐
│ SerialSafeSoftmax   │
│  AxiTop             │
│  ├ ScoreBuffer RAM  │
│  ├ max tracker      │
│  ├ exp path         │◄── §4 选型：Quartus IP 或 LUT
│  ├ fp32 sum acc     │◄── fp32Add (已有)
│  └ normalize        │◄── fp32Div / recip (§4)
└─────────────────────┘
      │  weightsOut AXI4-Stream (FP16 × N, tlast @ N-1)
      ▼
GqaAttention (AV)
```

本模块 **无 DDR、无 MMIO**；Scheduler 不直接驱动，由 `GqaAttention` 或 `LlamaM2cTop` 串联 Stream。

---

## 4. Quartus IP 选型（审阅重点）

仓库 **现有** `quartus_ip/`（与 rmsNorm / rope / gemv 共用）：

| IP | 用途 | 已有 |
|:---|:---|:---:|
| `fp16ToFp32` | 分数 → FP32 | ✓ |
| `fp32ToFp16` | 权重输出 | ✓ |
| `fp32Add` | FP32 累加 $\sum e_i$ | ✓ |
| `fp32MultAcc` | $e_i \times (1/\text{sum})$ | ✓ |
| `fp32Rsqrt` | RMSNorm（**不用于** $1/x$） | ✓ |
| **`fp32Exp`** | $\exp(d)$，$d \le 0$ | **已生成**，latency **31** |
| **`fp32Div`** | $1/\sum$ 或 $e/\sum$ | **已生成**，latency **30** |

架构文档口径（§7.10、§9.4）：**exp 用 LUT，div 用 IP**。与纯 IP 方案对比如下。

### 4.1 方案对比

| 方案 | exp | 归一化 $1/\sum$ | 新增 Quartus IP | 片上 ROM | 精度 | 推荐 |
|:---|:---|:---|:---:|:---:|:---|:---:|
| **A — 全 IP** | `fp32Exp` | `fp32Div` | 2 | ~0 | 最高，与 PyTorch 最接近 | 备选 |
| **B — LUT + Div**（架构一致） | **256×FP16 LUT** `[-16,0]` | `fp32Div` | **1** | **4 KiB**（1 M20K） | 减 max 后足够；LUT 区外钳位为 0 | **首选** |
| **C — 全 LUT** | LUT | 小 LUT / NR 倒数 | 0 | ~8 KiB | 需单独验证 $1/\sum$ | 不推荐 v1 |

### 4.2 首选方案 B 细节

#### exp：`SoftmaxExpLut`

| 项 | 值 |
|:---|:---|
| 表项数 | 256 |
| 自变量域 | $d \in [-16, 0]$（FP32 或 FP16 索引） |
| 表值 | FP16 $\exp(d)$（离线 Python 生成，与 `RoPETableInit` 同类） |
| $d < -16$ | 输出 0（下溢安全） |
| $d > 0$ | 不应出现；断言或钳位为 $\exp(0)=1$ |
| 插值 | v1 **不插值**（256 项对 attention 足够）；v2 可选线性插值 |

索引：$d$ 为 FP32 时，可用 `floor((d + 16) / 16 * 255)` 或等价 exponent 提取（实现期定稿）。

#### 归一化：`fp32Div`（需新建 IP）

```text
invSum = fp32Div(1.0f, sum)        // 单次 per head
w_i    = fp32MultAcc(invSum, e_i)  // 逐元素，已有 IP
```

**为何不用 `fp32Rsqrt`**：$1/\sum$ 不是 rsqrt；强行 Newton 迭代会增加 DSP 与验证成本。

#### 减法 $s_i - s_{\max}$

```text
d_fp32 = fp32Add( toFp32(s_i), toFp32(-s_max) )   // 或专用 fp32Sub IP；可用 add( a, -b ) 组合
```

$s_{\max}$ 在 COLLECT 阶段用 **FP16 比较器** 或 **FP32 max**（转 FP32 后比较更稳，推荐后者）。

### 4.3 若选方案 A（全 IP）

在 Quartus **FP Functions** 向导中新增（Agilex 5、FP32、flow、与现有 IP 相同 clock enable）：

1. `fp32Exp` — `exp(x)`，输入 FP32  
2. `fp32Div` — `a/b`，用于 `1.0f / sum`

生成后放入 `quartus_ip/`，在 `util/IntelFloatIPCollection.scala` 增加 wrapper（仿 `fp32Rsqrt`）。  
Questa `compile_ips.tcl` 增加 VHDL 编译条目。

**优点**：与 RMSNorm 方法论一致，golden 最易对齐。  
**缺点**：多 1 个 IP 面积/许可；exp 输入恒 ≤0 时 LUT 更省。

### 4.4 需要你拍板的事项

| # | 决策 | 建议 |
|:---:|:---|:---|
| 1 | exp 实现 | **B：LUT**（符合架构 §9.4） |
| 2 | 是否新建 `fp32Div` | **是**（归一化必需，除非接受方案 C） |
| 3 | 是否同时新建 `fp32Exp` | **否**（首选 B）；若 LUT golden 偏差大再切 A |
| 4 | $\sum=0$ 安全分支 | 输出均匀 $1/N$（与 PyTorch `nan→0` 不同，需在 TB 标注） |
| 5 | IP latency（Agilex 5 @400 MHz 目标） | `fp32Exp`=**31**、`fp32Div`=**30**（见 `util/IntelFloatIPCollection.scala`） |

---

## 5. 微架构

### 5.1 三阶段 FSM

```text
        scoresIn.fire
IDLE ─────────────────► COLLECT ──(tlast)──► EXP_SUM ──(i==N-1)──► EMIT ──(tlast)──► IDLE
                           │                      │                    │
                     wr scoreBuf[i]           rd→exp→wr expBuf      rd expBuf→mul→out
                     upd s_max                acc sum_fp32
```

| 状态 | 周期数（量级） | 说明 |
|:---|:---:|:---|
| COLLECT | $N$ | 与上游 QK 流速率一致；可 backpressure |
| EXP_SUM | $N \times L_{\text{exp+add}}$ | 串行；$L$ 取决于 LUT(1) 或 IP(10–20) |
| EMIT | $N \times L_{\text{mul+to16}}$ | 与下游 AV 对接 |

**吞吐**：单 head、$N=1025$、@200 MHz 粗算 **≪ 1 ms**，32 head 串行 **≪ 32 ms**，相对 DDR-bound attention 可接受。

### 5.2 片上存储

| 块 | 深度 × 宽度 | 用途 | M20K |
|:---|:---|:---|:---:|
| `scoreBuf` | 1025 × 16 bit | COLLECT 写 FP16 分数 | 1 |
| `expBuf` | 1025 × 16 bit | EXP_SUM 写 FP16 $\exp$；可与 scoreBuf **分时复用** 同一物理 RAM | 0（复用） |
| `expLut` | 256 × 16 bit | 方案 B | &lt;1 |

**推荐**：单端口 RAM 1025×16，COLLECT 写 `[addr]=score`，EXP_SUM 读 score 写 `[addr]=exp`，EMIT 读 exp。  
`N` 由 COLLECT 末拍 `tlast` 锁存（`lenReg`），不必在 `tuser` 重复传长度。

### 5.3 DSP / IP 预算（方案 B）

| 组件 | DSP block（估） |
|:---|:---:|
| FP16→FP32（分数路径） | 0（altera_fp_functions） |
| FP32 max / 减 | 0（LUT） |
| exp LUT | 0 |
| FP32 累加 | 0（`fp32Add` 在 DSP 或 fabric，与 RMSNorm 相同） |
| `fp32Div` | **~1** |
| FP32×FP32 → FP16 out | 0（`fp32MultAcc` + `fp32ToFp16`） |
| **合计** | **~1–2**（与架构 §7.10.2 “Softmax +2” 一致） |

---

## 6. AXI4-Stream 接口

### 6.1 配置（与 RoPE / RMSNorm 对齐）

```scala
Axi4StreamConfig(
  dataWidth = 16,      // 1 × FP16 / beat
  useKeep   = true,
  useStrb   = false,
  useLast   = true,
  useId     = false,
  useDest   = false,
  useUser   = true,
  userWidth = 16
)
```

### 6.2 端口

| 端口 | 方向 | 说明 |
|:---|:---|:---|
| `scoresIn` | slave | QK 未归一化分数；末 beat `tlast=1` |
| `weightsOut` | master | 注意力权重；末 beat `tlast=1` |

### 6.3 `tuser[15:0]` 编码（M2c 提案，与 GEMV `qOut` 风格一致）

```text
[15]     busy      — 输出：0..N-2 为 1，末 beat 为 0（与 RMSNorm 一致）
[14:11]  layerId   — M2c L0 固定 0
[10:6]   qHeadId   — 0..31
[5:3]    kvHeadId  — qHeadId / 4（GQA）；仅传递，模块不解析
[2:0]    reserved  — 0
```

**规则**：`scoresIn` 首 beat 锁存 `tuser`；`weightsOut` 首 beat 原样送出（`busy` 位按输出阶段重写）。

### 6.4 握手

遵循仓库 [stream-ready-valid](../../.cursor/rules/stream-ready-valid.mdc) 规则：

- `scoresIn.ready`：IDLE/COLLECT 且 buffer 未满  
- `weightsOut.valid`：EMIT 阶段由内部流水驱动，**不**依赖下游组合  
- FSM 仅在 `fire` 时推进 beat 计数

---

## 7. Scala 模块拆分

```
attention/
├── common/scala/
│   └── AttentionBundles.scala           # Generics, AxisCfg, Fp32Compare
├── softmax/
│   ├── doc/
│   │   └── serial-safe-softmax-design.md
│   ├── scala/
│   │   ├── SoftmaxScoreBuffer.scala
│   │   ├── SoftmaxCore.scala
│   │   ├── SoftmaxAlteraIp.scala
│   │   ├── SerialSafeSoftmaxAxiTop.scala
│   │   └── SoftmaxGen (in AxiTop file)  # runMain → gen/verilog/
│   ├── test/questa/
│   ├── Makefile
│   └── gen/verilog/
├── gqa/                                 # GqaAttention (pending)
│   ├── scala/
│   └── Makefile
└── Makefile                             # questa → softmax
```

**依赖注入**（与 `RmsNormCore` / `SerialRoPE` 相同模式）：

```scala
class SoftmaxCore(
  g: AttentionGenerics,
  toFp32: Flow[Bits] => Flow[Bits],
  addFp32: (Flow[Bits], Flow[Bits]) => Flow[Bits],
  mulFp32: (Flow[Bits], Flow[Bits]) => Flow[Bits],
  divFp32: (Flow[Bits], Flow[Bits]) => Flow[Bits],  // (1.0, sum) => invSum
  toFp16: Flow[Bits] => Flow[Bits],
  expLut: (Flow[Bits]) => Flow[Bits]                  // 或 fp32Exp IP
)
```

---

## 8. 验证计划（仅 Questa）

### 8.1 离线 golden

```bash
# 计划路径
python3 tools/attention_golden/gen_softmax_refs.py \
  --out-dir src/scala/attention/softmax/test/questa/golden_refs
```

生成用例（初稿）：

| 用例 | $N$ | 说明 |
|:---|:---:|:---|
| `len1` | 1 | 退化 |
| `len16` | 16 | 短序列 smoke |
| `len128` | 128 | 中期 |
| `len1025` | 1025 | 1K 主线最坏 |
| `uniform` | 64 | 全相同 → 均匀 |
| `sparse_max` | 32 | 单峰 |
| `large_negative` | 64 | 极端负分 |

### 8.2 毕业命令

```bash
source activate.sh
cd src/scala/attention
make questa          # verilog + Questa golden
make questa WAVE=1   # 可选波形
```

**不包含** `make verilator`。

### 8.3 `compile_ips.tcl` 依赖

与 `rmsNorm/test/questa/compile_ips.tcl` 相同基础集：

- `fp16ToFp32`, `fp32ToFp16`, `fp32Add`, `fp32MultAcc`  
- **+** `fp32Div`（方案 B/A 归一化）  
- **−** `fp32Rsqrt`（softmax 不需要，除非误用）

simlib：`simlib/quartus2025_1_1_agilex5_questa2024_3/`（仓库规则）。

### 8.4 集成测（M2c，本文档范围外）

`GqaAttention` 就绪后：`scores` 来自 QK golden 切片，端到端比对 AV 输入权重。  
不在 SerialSafeSoftmax 单元 TB 中测 QK/AV。

---

## 9. 资源与性能粗算

| 配置 | 值 |
|:---|:---|
| 最坏 $N$ | 1025 |
| 每 token softmax 次数 | 512 |
| 每 head 延迟（粗算） | $N \times (1 + L_{\text{exp}} + L_{\text{div}} + L_{\text{emit}})$ cycles |
| @200 MHz，$N=1025$，$L_{\text{tot}} \approx 30$ | **~0.15 ms / head** → 32 head **~5 ms**（仍小于 QK DDR 时延量级） |

片上 **~2 KiB** 缓冲 + **4 KiB** LUT，在 M20K 预算内（架构 §11.5 已预留 `ONCHIP_EXP_LUT`）。

---

## 10. 实现顺序（RTL 落地时）

1. **你审阅并拍板 §4 IP 方案**（尤其是否新建 `fp32Div`、exp 用 LUT 还是 IP）  
2. `AttentionBundles.scala` + `SoftmaxExpLut.scala`（若 LUT）  
3. Quartus 生成 `fp32Div` → `quartus_ip/` → `util` wrapper  
4. `SoftmaxScoreBuffer` + `SoftmaxCore` FSM（先用 `*_sim` stub 拉通状态机）  
5. 接入真实 IP，`SerialSafeSoftmaxAxiTop`  
6. `tools/attention_golden/` + Questa TB → `make questa` 毕业  

---

## 11. 设计检查清单

- [ ] $N$ 由输入流 `tlast` 决定，不硬编码 1025（除 RAM 深度上界）  
- [ ] Stable：必须先收齐再 exp，**禁止**边收边 exp  
- [ ] $\sum e_i$ 在 **FP32** 域累加  
- [ ] 输出权重 $\sum a_i \approx 1$（FP16 容差内）  
- [ ] `ready`/`valid` 不组合环路（stream-ready-valid 规则）  
- [ ] Questa 使用真实 `fp32Div`（或选定 IP），不用 `IntelFloatIPFlowIOSim` 做 FP 毕业  
- [ ] 无 Verilator target  
- [ ] `tuser` 透传与 `busy` 语义与 RMSNorm 一致  
- [ ] 新建 IP 加入 `quartus_ip/` 并更新顶层 `golden_top.qsf` / `compile_ips.tcl`（与 rmsNorm 流程一致）  

---

## 附录 A — `fp32Div` Quartus 生成参数（草案）

供 IP 向导参考（与现有 `fp32Rsqrt` 对齐）：

| 参数 | 值 |
|:---|:---|
| Family | Agilex 5 |
| Operation | Divide |
| Data type | FP32 |
| Input | `a`, `b` |
| Latency | 按 wizard 默认 pipeline（记录到 `SoftmaxAlteraIp.scala` 与 `_generation.rpt`） |
| Clock enables | Enabled |
| Reset | Synchronous |

实例名：`fp32Div` → `quartus_ip/fp32Div/`

---

## 附录 B — 修订记录

| 版本 | 日期 | 说明 |
|:---|:---|:---|
| v0.1 审阅稿 | 2026-06-30 | 初稿；待 IP 方案拍板 |
