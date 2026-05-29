# RMSNorm 模块设计说明

> 本文档描述 Llama 3.2 1B 在 FPGA 上实现 RMSNorm 模块时的设计边界、数据通路、接口和验证要点。`llama-fpga-xilinx/scala/src/main/scala/norm` 下已有 `RMSNormFp32`、`RMSLayerNorm`、`SquareSum`、`NormBuffer` 等参考实现，但其中不少默认维度和多核切分方式来自旧模型；本设计以 Llama 3.2 1B 的 `dim = 2048` 为主线，不直接照搬旧实现的 `4096` 维假设。

## 1. 设计目标

RMSNorm 是 Llama 3.2 1B decode 流水中的专用逐元素归一化模块，不并入通用 GEMV 服务。它的职责是接收一个 2048 维 FP16 activation 向量，计算全向量 RMS 缩放因子，并输出同样 2048 维的 FP16 归一化向量。

Llama 3.2 1B 中共有 33 个 RMSNorm 权重实例：

| 位置 | 数量 | 每个 gamma 维度 | 合计参数 |
|:---|:---:|:---:|:---:|
| 每层 Pre-Attention `norm1` | 16 | 2048 | 32768 |
| 每层 Pre-FFN `norm2` | 16 | 2048 | 32768 |
| `final_norm` | 1 | 2048 | 2048 |
| **合计** | **33** | - | **67584** |

全部 gamma 使用 FP16 保存，总量为 `67584 * 2 B = 135168 B`，约 132 KiB。RMSNorm 参数的权威副本放在 DDR，由集中式命令生成/调度模块负责发起 DDR 读取，并在每次 RMSNorm 调用时把当前需要的 2048 个 gamma 通过 `weightIn` AXI4-Stream 送入 RMSNorm 模块。RMSNorm 模块本身不向外部仲裁器发 DDR 请求，也不需要长期保存全部 33 组 gamma；它只缓存当前向量对应的一组 2048 个 gamma。

主线约束：

| 项目 | 取值 |
|:---|:---|
| 模型 | Llama 3.2 1B |
| 向量维度 | `dim = 2048` |
| 输入/输出格式 | FP16 |
| 内部计算格式 | FP32 |
| epsilon | `1e-5` |
| gamma 格式 | FP16，DDR 存放权威副本，当前调用通过 `weightIn` 输入 |
| 对外接口 | AXI-Stream，和整个 Transformer 计算流水保持一致 |
| 调度方式 | 集中式 scheduler 选择本次 norm1/norm2/final_norm 对应的 activation 和 gamma，并分别送入 `dataIn` 与 `weightIn` |

## 2. 数学定义

对输入向量 `x[0..2047]`，RMSNorm 输出为：

$$
\operatorname{RMSNorm}(x)_i = x_i \cdot \operatorname{rsqrt}\left(\frac{1}{d}\sum_{j=0}^{d-1}x_j^2 + \epsilon\right) \cdot \gamma_i
$$

其中 Llama 3.2 1B 主线参数为：

$$
d = 2048, \qquad \epsilon = 10^{-5}, \qquad i \in [0, 2047]
$$

也可以拆成硬件更直接的三步：

$$
s = \sum_{j=0}^{2047}x_j^2
$$

$$
r = \operatorname{rsqrt}\left(\frac{s}{2048} + 10^{-5}\right)
$$

$$
y_i = x_i \cdot r \cdot \gamma_i
$$

对应到伪代码：

```text
mean_square = (sum(x_i * x_i) / 2048) + epsilon
scale       = rsqrt(mean_square)
y_i         = x_i * scale * gamma_i
```

等价公式：

```text
y_i = x_i * rsqrt((1 / dim) * sum(x_j^2) + eps) * gamma_i
```

RMSNorm 不计算均值，也没有 beta 偏置。硬件中必须等待整条 2048 维向量的平方和完成后，才能得到本向量共享的 `scale`；因此输入数据需要在本地缓存一遍，或由上游提供可重放的数据流。推荐使用本模块内部缓存，避免要求上游二次发送同一向量。

## 3. 与旧参考实现的关系

参考目录：`llama-fpga-xilinx/scala/src/main/scala/norm`

| 参考模块 | 可借鉴点 | Llama 3.2 1B 需要调整的点 |
|:---|:---|:---|
| `RMSNormFp32` | FP16 输入输出、内部 FP32、`Fp32ScaleDown(acc, log2Up(dim))`、`rsqrtOutLock` 锁存、输入缓存后逐元素输出 | 主线 `dim` 改为 2048；去掉不必要的旧 layer 类型分支时要确认调度仍能覆盖 `norm1/norm2/final_norm` |
| `RMSLayerNorm` | `Flow/Stream` 握手、`tuser` tag 传递、先收平方和再乘 gamma 的两阶段结构 | 偏 FP16 路径，精度不适合作为主线；旧示例维度为 4096 |
| `SquareSum` | 平方和可拆为独立阶段，tag 可随向量首元素进入 side-channel | 旧实现使用 FP16 缩放与累加，不满足内部 FP32 主线 |
| `NormBuffer` | 旧多核切分或重排时的片上缓存方式 | 本模块主线不采用多核切分，保留为历史参考，不进入第一版设计 |

建议先实现一个参数化的 `RMSNormFp32` 风格模块，再按系统调度需要包一层 AXI/Stream 适配器。不要从 `RMSLayerNorm + SquareSum` 的 FP16 两模块拆分方案开始，因为后续补 FP32 精度会牵动接口和缓存。

## 4. AXI-Stream 接口建议

如果整个 Transformer 的计算模块都使用 AXI4-Stream，RMSNorm 也应该把 AXI4-Stream 作为对外主接口。这里采用集中式命令生成/调度策略：外部 scheduler 负责决定当前执行哪个 RMSNorm 实例、从 DDR 读取哪一段 gamma、以及 activation 从哪里来；RMSNorm 模块只消费两条输入流并产生一条输出流，不需要额外控制输入，也不主动发起 DDR 请求。

全局 AXI-Stream 配置建议统一为：

```scala
import spinal.lib.bus.amba4.axistream._

val axisCfg = Axi4StreamConfig(
  dataWidth = 16,

  useKeep  = true,
  useStrb  = false,
  useLast  = true,

  useId    = false,
  useDest  = false,

  useUser  = true,
  userWidth = 16
)
```

其中 `tdata` 每 beat 承载 1 个 FP16 元素，`tkeep` 固定表示该 16-bit lane 有效，`tlast` 标记一个向量或一个逻辑 packet 的末 beat，`tuser[15]` 作为 packet 状态位，`tuser[14:0]` 作为全 Transformer 的紧凑上下文标签。

内部实现仍然可以拆成 SpinalHDL `Stream/Flow` 小模块，例如 `RmsNormAccumulator`、`RmsNormScale`、`RmsNormEmitter`。边界上用 wrapper 做 AXI-Stream 到内部流的转换即可。也就是说：对系统是 AXI-Stream-first，对核心计算是可测试的小流水。

### 4.1 对外 AXI-Stream 数据接口

建议顶层使用两条 slave AXI4-Stream 和一条 master AXI4-Stream：

```scala
val dataIn   = slave(Axi4Stream(dataCfg))    // activation, 2048 FP16 beats
val weightIn = slave(Axi4Stream(weightCfg))  // RMSNorm gamma, 2048 FP16 beats
val dataOut  = master(Axi4Stream(dataCfg))   // normalized activation, 2048 FP16 beats
```

建议对外接口语义：

| 接口 | 方向 | 类型 | 说明 |
|:---|:---:|:---|:---|
| `dataIn` | in | `Axi4Stream(dataCfg)` | 当前 activation 向量，每次调用 2048 beat |
| `weightIn` | in | `Axi4Stream(weightCfg)` | 当前 RMSNorm gamma 向量，每次调用 2048 beat，由集中式 scheduler/DDR reader 提供 |
| `dataOut` | out | `Axi4Stream(dataCfg)` | 归一化后的 activation 向量，每次调用 2048 beat |

不再额外暴露独立 `busy` 端口。RMSNorm 的忙闲状态写入 `dataOut.tuser[15]`：输出 packet 的非最后 beat 置 `1`，最后一个 beat 置 `0`。没有输出 beat 的阶段（收集输入、等待 rsqrt）由 AXI4-Stream 的 `ready` 背压表达，不另开 sideband 状态信号。

AXI-Stream 数据字段约定：

| 流 | `tdata` | `tuser` | `tlast` |
|:---|:---|:---|:---|
| `dataIn` | FP16 activation | 输入向量上下文标签，首 beat 采样后低 15 bit 透传到 `dataOut` | 第 2047 个 activation beat 置位 |
| `weightIn` | FP16 gamma | 可用于调试当前 layer/norm 类型；RMSNorm 核心不依赖它做控制 | 第 2047 个 gamma beat 置位 |
| `dataOut` | FP16 normalized activation | `tuser[15]` 写 busy，`tuser[14:0]` 默认透传 `dataIn` 首 beat 的上下文 | 第 2047 个输出 beat 置位 |

所有输入、输出计数器只在对应流 `ready && valid` 时推进。`dataIn` 与 `weightIn` 是两条独立输入流，集中式 scheduler 必须保证它们属于同一次 RMSNorm 调用。RMSNorm 模块内部用两个计数器分别收集 activation 和 gamma：两边都收满 2048 beat，且 activation 的平方和完成后，才能进入输出阶段。

`tuser[15:0]` 固定把 bit 15 留给 `busy`，其余 15 bit 按流类型解释。16 bit 无法同时完整容纳 token、head、layer、sequence position 和 KV cache index 的最大范围，因此采用 profile overlay。RMSNorm 属于 layer-wide vector profile。

**Profile A：layer-wide vector（RMSNorm、Residual、FFN 输入输出）**

| 位段 | 字段 | 说明 |
|:---:|:---|:---|
| `[15]` | `busy` | `dataOut` 由 RMSNorm 写入：非最后 beat 为 1，最后 beat 为 0；`dataIn/weightIn` 可由 scheduler 置 0 或作调试 |
| `[14:11]` | `layerId` | 0..15；`final_norm` 可约定为 15 且 `normKind=2`，或由 scheduler 本地状态区分 |
| `[10:9]` | `normKind` | `0=norm1`、`1=norm2`、`2=final_norm`、`3=reserved` |
| `[8:0]` | `tokenSeqLow` | 当前 token / seq position / KV cache index 的低 9 bit；超过 512 的高位由集中式 scheduler 本地状态维护 |

**Profile B：attention head stream（Q/K/V、RoPE、QK、AV）**

| 位段 | 字段 | 说明 |
|:---:|:---|:---|
| `[15]` | `busy` | packet 级状态或调试位 |
| `[14:11]` | `layerId` | 0..15 |
| `[10:6]` | `headId` | 0..31；KV head/group 可用低编号或另行约定 |
| `[5:0]` | `seqKvLow` | sequence position / KV cache index 的低 6 bit；高位由 scheduler 本地状态维护 |

**Profile C：weight stream（RMSNorm `weightIn`）**

| 位段 | 字段 | 说明 |
|:---:|:---|:---|
| `[15]` | `busy` | 可置 0；RMSNorm 不依赖该位做控制 |
| `[14:11]` | `layerId` | 调试用 |
| `[10:9]` | `normKind` | 调试用，和 Profile A 一致 |
| `[8:0]` | `weightIndexLow` | 可选调试用；RMSNorm 按 beat 计数写 weight buffer，不依赖该字段 |

RMSNorm 不根据 `tuser` 选择权重。当前使用哪一个 `norm1/norm2/final_norm` gamma，完全由集中式 scheduler 通过 `weightIn` 的数据内容决定。

握手关系：

1. `IDLE` 状态等待新一组 `dataIn` 和 `weightIn` packet。
2. `COLLECT` 状态分别接收 2048 个 activation beat 和 2048 个 gamma beat；二者可以同速到达，也可以一边先到。
3. 两条输入流的第 2047 个 beat 都必须携带 `tlast=1`；若提前或延后出现 `tlast`，仿真中应报错或置 sticky error。
4. `EMIT` 输出 2048 个 beat，`dataOut.tuser[14:0]` 透传 `dataIn` 首 beat 的上下文；`dataOut.tuser[15]` 在 beat 0..2046 为 `1`，beat 2047 为 `0`；末 beat 置 `tlast=1`。
5. `dataOut.ready=0` 时输出阶段暂停，input buffer 读地址、weight buffer 读地址和输出计数器都保持不变。

这种设计让 RMSNorm 可以自然接入全 Transformer AXI-Stream fabric：数据靠 AXIS packet 边界表达向量，权重靠独立 AXIS packet 表达当前 gamma，所有跨算子的顺序和 DDR 访问都由集中式 scheduler 统一控制。

### 4.2 内部核心接口

AXI-Stream wrapper 内部可以继续用更轻的 `Stream/Flow` 连接计算子模块：

| 内部接口 | 建议类型 | 说明 |
|:---|:---|:---|
| `collectData` | `Stream[Bits(16 bits)]` | 已去掉 AXIS sideband 的 activation |
| `collectWeight` | `Stream[Bits(16 bits)]` | 已去掉 AXIS sideband 的当前 gamma |
| `sumOut` | `Flow[Bits(32 bits)]` | 2048 项平方和，或已经 scale-down 后的 mean square |
| `scaleOut` | `Flow[Bits(32 bits)]` | `rsqrt(mean_square + eps)` |
| `emitOut` | `Stream[Bits(16 bits)]` | 归一化后的 FP16 输出 |

内部用 `Flow` 的地方必须由 wrapper 或相邻模块保证不会丢 valid；凡是会遇到下游背压的路径都应使用 `Stream`。

### 4.3 当前权重缓存接口

RMSNorm 模块只需要缓存当前调用的 2048 个 gamma：

```text
weight_buffer[index]
index: 0..2047
```

`weightIn` 每次调用发送一组完整 gamma packet，长度固定为 2048 beat。该 packet 对应 layer `l` 的 `norm1.weight`、layer `l` 的 `norm2.weight` 或 `final_norm.weight`，具体选择由集中式 scheduler 在模块外完成。RMSNorm 模块只按 beat 顺序写 `weight_buffer[index]`，不关心它来自 33 组权重中的哪一组。

缓存需求：当前调用的 weight buffer 为 `2048 * 16 bit = 4 KiB`。同一个 token 完成一次 RMSNorm 后，要经过较长的 GEMV/Attention/FFN 路径才会再次使用 RMSNorm；单 buffer 足够覆盖当前调度节奏。

## 5. 数据通路设计

推荐把 RMSNorm 分为两个阶段：归约阶段和输出阶段。

```text
input FP16
   |
   |-- write input_buffer[index]
   |
   `-- fp16_to_fp32 -> square_fp32 -> acc_fp32 -> scale_down_by_2048
                                                  -> add_epsilon
                                                  -> rsqrt_fp32
                                                  -> scale_latch

input_buffer[index] -> fp16_to_fp32
weight_buffer[index] -> fp16_to_fp32
scale_latch
   |
   `-- mul_fp32(input, scale) -> mul_fp32(..., gamma) -> fp32_to_fp16 -> output
```

### 5.1 输入与权重缓存

缓存深度至少为 2048，宽度为 16 bit。单个 token 的 RMSNorm 必须先完成平方和，之后再回读输入缓存并逐元素输出。

因为 gamma 也通过 `weightIn` 流式输入，而输出阶段要在 `scale` 计算完成后才开始，所以当前调用的 2048 个 gamma 也需要缓存一遍。最小缓存为：

| 缓存 | 大小 | 用途 |
|:---|:---:|:---|
| input buffer | 4 KiB | 保存当前 activation，供输出阶段回读 |
| weight buffer | 4 KiB | 保存当前 gamma，供输出阶段回读 |

主线固定使用单 buffer：data 4 KiB + weight 4 KiB。RMSNorm 不是当前 decode 主瓶颈，不需要为了重叠下一条向量而增加额外缓存控制复杂度。

### 5.2 平方和归约

每个输入元素先从 FP16 转 FP32，再做 FP32 平方并累加。不要用 FP16 完成平方和，原因是 2048 项累加会明显损失尾数，小激活值平方也可能落入 FP16 次正规数范围。

主线固定使用串行 FP32 accumulator：每拍接收一个 FP32 平方值，2048 拍形成完整 `sum(x_i^2)`。decode 单 token 场景下 RMSNorm 调用间隔较长，串行累加面积最小、控制最直接。

已有 `RMSNormFp32` 使用 `acc_func(Flow[Fragment[Bits]])` 形式，`last` 标记向量结束；这是一个不错的抽象，后续可以替换不同 FP32 acc IP。

### 5.3 除以 dim 与 epsilon

Llama 3.2 1B 的 `dim = 2048 = 2^11`，因此 `sum / dim` 可以用 FP32 指数减 11 的方式实现，对齐旧实现中的 `Fp32ScaleDown(accOut.fragment, log2Up(dim))`。

`epsilon = 1e-5` 需要在 FP32 域加入：

```text
mean_square = Fp32ScaleDown(sum, 11) + fp32(1e-5)
```

旧实现如果只做 scale down 而没有显式加 epsilon，需要在 Llama 3.2 1B 主线中补上。epsilon 对接近零的输入向量很关键，不能省略。

### 5.4 Rsqrt 锁存

`rsqrt(mean_square)` 对整条 2048 维向量共用。`rsqrt` 输出 valid 后，将结果锁存在寄存器中，并在输出阶段保持稳定，直到 2048 个输出元素全部发完。

状态机语义：

```text
IDLE -> COLLECT -> WAIT_RSQRT -> EMIT -> IDLE
```

| 状态 | 行为 |
|:---|:---|
| `IDLE` | 等待新一组 `dataIn` / `weightIn` packet，准备清零计数器和 accumulator |
| `COLLECT` | 写 input buffer 和 weight buffer，同时对 activation 累计 FP32 square sum |
| `WAIT_RSQRT` | 等待 acc last、epsilon add、rsqrt valid |
| `EMIT` | 顺序读 input buffer 和 gamma，输出 2048 个元素，最后清除 scale valid |

旧 `RMSNormFp32` 中的 `rsqrtOutLock.valid` 和 `rsqrtCnt` 逻辑可以保留这个思路，但 `rsqrtCntOvf` 在 Llama 3.2 1B 主线固定比较 `dim - 1 = 2047`。

### 5.5 输出乘法顺序

输出推荐在 FP32 域计算：

```text
scaled = fp32(input_buffer[index]) * scale_latch
out32  = scaled * fp32(weight_buffer[index])
out16  = fp32_to_fp16(out32)
```

也可以先算 `gamma * scale` 后再乘 input，但 `gamma` 是逐元素变化的，无法把整条向量共享为一个常数。若 gamma 读口或 FP16->FP32 转换成为瓶颈，可考虑提前把当前 stage 的 gamma 转换流水插在输出阶段前一级。

## 6. 集中式调度接入

RMSNorm 在 Transformer 中是严格的 Pre-Norm：

```text
layer input -> norm1 -> Q/K/V GEMV -> attention -> residual add
           -> norm2 -> FFN GEMV/SwiGLU -> residual add -> next layer

layer 15 output -> final_norm -> LM head GEMV
```

因此集中式 scheduler 对 RMSNorm 的调用点如下：

| 调用点 | `dataIn` 来源 | `weightIn` 来源 | `dataOut` 去向 |
|:---|:---|:---|:---|
| layer `l` attention 前 | 当前 residual stream | DDR 中 layer `l` 的 `norm1.weight` | Q/K/V projection 输入 buffer |
| layer `l` FFN 前 | attention residual add 输出 | DDR 中 layer `l` 的 `norm2.weight` | gate/up projection 输入 buffer |
| LM head 前 | layer 15 final residual | DDR 中 `final_norm.weight` | LM head 输入 buffer |

RMSNorm 不是矩阵乘法，不走 GemvService64 descriptor。集中式 scheduler 已经知道当前 layer、norm 类型、token/seq position 和下游模块，因此它只需要在正确时间把 activation packet 送到 `dataIn`，把对应 gamma packet 送到 `weightIn`。RMSNorm 模块根据 AXI4-Stream packet 边界完成一次调用。

这意味着 RMSNorm 的控制面很薄：

| 控制职责 | 所属模块 |
|:---|:---|
| 判断当前执行 norm1、norm2 还是 final_norm | 集中式 scheduler |
| 从 DDR 读取对应 2048 个 gamma | 集中式 scheduler / DDR read path |
| activation 与 gamma packet 对齐 | 集中式 scheduler |
| 平方和、rsqrt、逐元素乘 gamma | RMSNorm 模块 |
| `tuser/tlast/ready` 语义维护 | RMSNorm AXI wrapper |

## 7. Agilex 5E013B 资源映射

本节说明如何把 RMSNorm 的 buffer、乘法器和浮点算子映射到 Agilex 5E013B 上的 M20K 和 DSP。

### 7.1 核心原则：FP16 不等于 16-bit 整数乘法

`Bits(16 bits)` 直接做乘法，综合器会生成整数乘法器，不会理解 IEEE FP16 浮点格式。映射到 Agilex DSP 的正确方式是通过 Intel Floating-Point IP 或 DSP Builder 生成 half/single precision 算子，然后在 SpinalHDL 里封装成 `BlackBox`，和 Xilinx 版本的处理方式一致。

### 7.2 对照 Xilinx 参考实现的做法

参考 [llama-fpga-xilinx/scala/src/main/scala/norm/RMSNormFp32.scala](../../../../llama-fpga-xilinx/scala/src/main/scala/norm/RMSNormFp32.scala)：

`RMSNormFp32` 通过构造参数注入所有浮点算子，模块本身不绑定任何厂商实现：

```scala
class RMSNormFp32(
  ...
  toFp32_func:      Flow[Bits] => Flow[Bits],
  toFp16_func:      Flow[Bits] => Flow[Bits],
  mul_func:         (Flow[Bits], Flow[Bits]) => Flow[Bits],
  mul_func_block:   (Stream[Bits], Stream[Bits]) => Stream[Bits],
  acc_func:         Flow[Fragment[Bits]] => Flow[Fragment[Bits]],
  rsqrt_func:       Flow[Bits] => Flow[Bits]
) extends Component
```

这些函数来自 `util.fp32mul8`、`util.fp32acc22`、`util.fp32rsqrt32` 等 Xilinx Floating-Point IP wrapper，底层是 [XilinxFloatIPFlowIO.scala](../../../../llama-fpga-xilinx/scala/src/main/scala/util/XilinxFloatIPFlowIO.scala) 定义的 blackbox，接口按 Xilinx `s_axis_a`/`m_axis_result` AXI-Stream 风格命名。SpinalHDL 层只负责连线，厂商 IP 内部才把运算分配到 DSP Block。

Agilex 版本应照此模式，把 Xilinx IP wrapper 替换成 Intel IP wrapper。`RMSNormCore` Scala 逻辑保持相同，只换注入的函数：

```scala
// Xilinx
RmsNormCore(..., fp32mul8.mul, fp32acc22.acc, fp32rsqrt32.rsqrt, ...)

// Intel/Agilex 版
RmsNormCore(..., fp32mulIntel.mul, fp32accIntel.acc, fp32rsqrtIntel.rsqrt, ...)
```

参考 [util/Fp32ScaleDown.scala](../../../../llama-fpga-xilinx/scala/src/main/scala/util/Fp32ScaleDown.scala)：`sum / 2048` 的除法不需要 DSP，直接操作 FP32 的 exponent 字段即可：

```scala
object Fp32ScaleDown {
  def apply(src: Bits, rightShift: Int) = {
    val expo = src.drop(23).take(8).asUInt
    val newExpo = Mux(expo > rightShift, expo - rightShift, U(0)).asBits
    src.msb ## newExpo ## src.take(23)
  }
}
```

对 `dim = 2048 = 2^11`，调用 `Fp32ScaleDown(accOut, 11)` 即可，不消耗 DSP。

### 7.3 Intel/Agilex FP IP Wrapper 示例结构

参照 Xilinx 版本 `XilinxFloatIPFlowIO`，需要为 Agilex 写一套等价 wrapper，放到 `src/scala/util/`：

```scala
// src/scala/util/IntelFloatIP.scala
class AlteraFpFlowIO(
  val ipName:      String,
  val latency:     Int,
  val inputWidth:  Int,
  val outputWidth: Int,
  val numOps:      Int = 2
) extends BlackBox {
  val io = new Bundle {
    val clk    = in Bool()
    val a      = slave(Flow(Bits(inputWidth bits)))
    val b      = if (numOps >= 2) slave(Flow(Bits(inputWidth bits))) else null
    val result = master(Flow(Bits(outputWidth bits)))
  }
  mapClockDomain(clock = io.clk)
  this.setDefinitionName(ipName)
}

// FP32 mul wrapper，latency 约 8 clk（Altera fp32 mul IP）
object fp32mulAltera {
  def mul(a: Flow[Bits], b: Flow[Bits]): Flow[Bits] = new Composite(a, "mul") {
    val ip = new AlteraFpFlowIO("fp32_mul", latency = 8, inputWidth = 32, outputWidth = 32)
    ip.io.a << a
    ip.io.b << b
  }.ip.io.result
}

// FP32 accumulator，latency 约 11 clk
object fp32accAltera {
  def acc(a: Flow[Fragment[Bits]]): Flow[Fragment[Bits]] = new Composite(a, "acc") {
    // 同 Xilinx 版，但 BlackBox 对应 Altera altera_fp_functions IP
    ...
  }.ip.io.accOut
}

// FP32 rsqrt，latency 约 28 clk 或用 Newton-Raphson 定制
object fp32rsqrtAltera {
  def rsqrt(a: Flow[Bits]): Flow[Bits] = new Composite(a, "rsqrt") {
    ...
  }.ip.io.result
}
```

具体 IP 名称和延迟参见 Quartus IP Catalog 中的 `altera_fp_functions`（选 ALTFP_MULT/ALTFP_ADD/ALTFP_SQRT）或 DSP Builder Advanced Blockset 生成的核。

### 7.4 M20K 映射：input buffer 和 weight buffer

RMSNorm 的两个缓存都是 `2048 x 16 bit = 32768 bit`，每个约占 2 个 M20K（M20K 单块 20480 bit）。

在 SpinalHDL 中声明同步 RAM 并加 ramstyle 属性，Quartus 会优先推入 M20K：

```scala
val inputBuffer  = Mem(Bits(16 bits), 2048)
val weightBuffer = Mem(Bits(16 bits), 2048)

inputBuffer.addAttribute("ramstyle", "M20K")
weightBuffer.addAttribute("ramstyle", "M20K")
```

注意：
- 避免异步读（`inputBuffer(addr)`，不加时钟）；M20K 是同步 RAM，异步读会退到 MLAB 或 LE。
- 读写地址由状态机控制：写在 `COLLECT` 阶段，读在 `EMIT` 阶段，不同时发生，单端口足够。
- 综合后在 Quartus `.fit.rpt` 里确认 `M20K` 行显示 4（input + weight，各 2 块）。

### 7.5 DSP Block 用量估算

RMSNorm 串行数据通路的 DSP 需求如下：

| 算子 | DSP Block / IP 资源 | 说明 |
|:---|:---:|:---|
| FP16 -> FP32 | 0 DSP（逻辑实现）| exponent 扩展 + mantissa 补位，纯逻辑 |
| FP32 square（`x * x`）| 1 FP32 mul IP | 每拍计算 1 个平方值 |
| 串行 FP32 acc | 1 FP32 add/acc IP | 2048 拍完成平方和 |
| `/ 2048` | 0 DSP | `Fp32ScaleDown(sum, 11)` 直接改 exponent |
| `+ epsilon` | 1 FP32 add IP（可复用 acc IP）| 若 acc IP 支持无穷流，可在最后一拍加 epsilon |
| FP32 rsqrt | 1 FP32 rsqrt/sqrt IP | 单次计算，等待结果后锁存 |
| FP32 mul `x * scale` | 1 FP32 mul IP（可与上行 square 时分复用）| 输出阶段每拍 1 次 |
| FP32 mul `... * gamma` | 1 FP32 mul IP | 可与上行串联，或单独一级 |
| FP32 -> FP16 | 0 DSP（逻辑实现）| exponent 截断 + 舍入，纯逻辑 |

主线不时分复用时约需 **3~4 个 FP32 IP 实例（对应 ~10~15 个 DSP Block）**；若收集阶段和输出阶段分时复用 square/mul IP，可降至 2~3 个 FP32 IP 实例。Agilex 5E013B 共有 **140 个 DSP Blocks**，RMSNorm 单模块占比极小（约 7~11%），预算充裕。

### 7.6 资源总估算

以单元素/拍的串行核心估算：

| 资源 | 估算 |
|:---|:---|
| input buffer | 4 KiB，单 buffer，推 M20K，约 2 个 M20K |
| weight buffer | 4 KiB，单 buffer，推 M20K，约 2 个 M20K |
| FP16->FP32 | 输入路径 1 个，gamma 路径 1 个；纯逻辑，无 DSP |
| FP32 square/mul | 收集阶段 1 个，输出阶段 1~2 个；共 2~3 个 FP32 mul IP |
| FP32 accumulator | 1 个串行 FP32 acc IP |
| FP32 rsqrt | 1 个 FP32 rsqrt IP |
| FP32->FP16 | 输出路径 1 个；纯逻辑，无 DSP |
| **DSP Block 合计** | **约 10~15 个**（占 Agilex 5E013B 140 个 DSP 的约 7~11%）|
| **M20K 合计** | **约 4 个**（占 Agilex 5E013B 358 个 M20K 的约 1%）|

吞吐粗略为：输入收集 2048 拍 + acc/rsqrt 延迟（约 30~40 拍）+ 输出 2048 拍。对 decode 单 token 主线来说，RMSNorm 不是主要带宽瓶颈；优先保证精度、接口清晰和调度正确。

## 8. 精度与边界条件

> gamma 参数由集中式 scheduler/DDR read path 通过 `weightIn` 输入；RMSNorm 模块不主动发 DDR 请求，也不在片上长期保存全部 33 组 gamma。

必须覆盖以下边界：

| 场景 | 期望 |
|:---|:---|
| 全零输入 | 输出全零，`epsilon` 防止 `rsqrt(0)` |
| 小幅值输入 | FP32 平方和不应下溢为 0 |
| 大幅值输入 | 平方和不应溢出；必要时在测试中约束输入范围与模型 activation 统计一致 |
| gamma 全 1 | 输出只反映 RMS 缩放 |
| gamma 非 1 | 每个 index 使用正确 gamma 地址 |
| 连续两次不同 RMSNorm 调用 | `dataIn` 和 `weightIn` packet 不串扰，第二次调用不会复用上一次 gamma |
| 背压/valid 间断 | 计数器只在 `ready && valid` 时推进，不能丢元素 |

与 PyTorch 对齐时，以 FP32 参考公式为 golden：

```python
def golden_rms_norm(x_fp16, gamma_fp16, eps=1e-5):
    x = x_fp16.float()
    gamma = gamma_fp16.float()
    scale = torch.rsqrt(x.pow(2).mean(dim=-1, keepdim=True) + eps)
    return (x * scale * gamma).half()
```

建议误差门限先按 FP16 输出设置：最大绝对误差不超过 1 到 2 个 ulp，或按下游容忍度设置 `atol=1e-3, rtol=1e-3`。最终门限应根据所用 FP IP 的舍入模式重新校准。

## 9. 实现拆分建议

建议按以下顺序落地 Scala/SpinalHDL 模块：

1. `RmsNormInputBuffer`：从 `dataIn` 接收 2048 个 activation，写入 input buffer，并向 accumulator 提供 FP16 数据。
2. `RmsNormWeightBuffer`：从 `weightIn` 接收 2048 个 gamma，写入 weight buffer。
3. `RmsNormAccumulator`：FP16 activation 转 FP32，平方，按 2048 项输出 `sum`。
4. `RmsNormScale`：`sum / 2048 + eps -> rsqrt`，输出单个 FP32 scale。
5. `RmsNormEmitter`：回读 input buffer 和 weight buffer，完成 `x * scale * gamma`，输出 FP16。
6. `RmsNormAxiTop`：作为对外顶层，封装 `dataIn/weightIn/dataOut`，处理 `tdata/tuser/tkeep/tlast` 和 backpressure。

第一版不要加入额外并行重排、宽向量 lane 或复杂控制协议。先把 2048 维、两条输入 AXI4-Stream、串行 FP32 accumulator、epsilon、当前 gamma 缓存和 backpressure 行为做对。

## 10. 设计检查清单

- `dim` 固定或默认是 2048，而不是旧示例的 4096。
- `log2Up(dim)` 对 2048 得到 11，`sum / dim` 使用 FP32 指数缩放或等价除法。
- `epsilon = 1e-5` 在 FP32 域加入。
- 平方、累加、rsqrt、输出乘法均在 FP32 域完成。
- 输入和输出是 FP16，gamma 是 FP16。
- gamma 参数由集中式 scheduler/DDR read path 通过 `weightIn` 输入；RMSNorm 模块不主动发 DDR 请求。
- 每条向量完整收集 2048 个元素后只生成一个 scale。
- 输出阶段 2048 个元素共享同一个 scale。
- `weightIn` 的第 `i` 个 gamma 与 `dataIn` 的第 `i` 个 activation 对齐。
- `dataIn` 首 beat 的 `tuser[14:0]` 随 `dataOut` 首 beat 正确传递。
- `dataOut.tuser[15]` 表达 busy：beat 0..2046 为 1，beat 2047 为 0；接口上不再有独立 `busy` 端口。
- `dataIn`、`weightIn`、`dataOut` 的 `tlast` 都只在第 2047 个 beat 置位。
- 计数器只在对应 AXI4-Stream 的 `ready && valid` 时推进，背压或 valid 间断时不误增。
- 对外所有数据通路使用 AXI-Stream 语义；内部 `Flow` 只用于无背压或被 wrapper 保护的短路径。
- `dataIn` 和 `weightIn` packet 都必须正好包含 2048 个 beat，`tlast` 位置错误要能在仿真中暴露。
- `inputBuffer` 和 `weightBuffer` 加 `ramstyle = "M20K"` 属性，综合后在 Quartus `.fit.rpt` 确认两个 buffer 各占 2 个 M20K。
- FP32 算子通过 Intel/Altera Floating-Point IP blackbox 注入，综合后确认 DSP Block 用量在约 10~15 个以内。
- 浮点算子通过构造参数注入，`RmsNormCore` 本身不绑定厂商 IP 名称。