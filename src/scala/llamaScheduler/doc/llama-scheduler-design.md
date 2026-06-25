# LlamaScheduler 设计说明

> **LlamaScheduler** 是 PL 侧全局编排模块：接收 HPS（ARM）的 token job 参数，维护 `layer` / `seq_pos` / `phase` 等上下文，向 **DdrAgent** 下发 `MemCmd`，在算子间路由 AXI-Stream，驱动整条 decode 流水线。  
> 不直接驱动 AXI `AR/AW` 通道。
>
> Token Embedding 查表语义见 [token-embedding-design.md](../../tokenEmbed/doc/token-embedding-design.md)。  
> DDR 命令翻译与 AXI master 见 [ddr-agent-design.md](../../ddrAgent/doc/ddr-agent-design.md)。  
> **DDR 地址规划**见 [ddr-memory-map.md](../../common/doc/ddr-memory-map.md)。

**主线配置**：Agilex 5E 013B，1K context，W4A16，KV FP16，Plan A。

---

## 1. 职责边界

| 负责 | 不负责 |
|:---|:---|
| 锁存 ARM job 参数（`token_id`, `seq_pos`, `phase`） | AXI burst 切分、outstanding |
| `token_id` → `emb_row_base`、`(layer,normKind)` → `gamma_addr` | DDR 读回字节的 beat 串行化（属 DdrAgent sink） |
| 产生 `MemCmd` / 消费 `MemDone` | RMSNorm 内部归一化计算 |
| 全局 layer 间 FSM、算子调用顺序 | GEMV 矩阵乘 |
| 向 HPS 回报 `job_done` / `job_error` / `next_token_id` | |

**RMSNorm γ 权威副本在 DDR**（`RMS_GAMMA_BASE`）；Scheduler 每次 RMSNorm 前发 `MemCmd(sink=RMS_GAMMA)`，由 DdrAgent 读 4 KiB 并驱动 `RmsNorm.weightIn`。

---

## 2. 顶层互联

```text
┌─────────────┐   AXI-Lite    ┌──────────────────┐  MemCmd   ┌─────────────┐
│ HPS (ARM)   │ ◄──────────► │  LlamaScheduler  │ ────────► │  DdrAgent   │ ◄──► DDR
│             │  job_done    │  + HpsJobCtrl      │ ◄─MemDone─│             │
└─────────────┘  next_token  └────────┬─────────┘           └──────┬──────┘
                                      │                              │
                                      │                    embedOut ─┼─► RmsNorm.dataIn
                                      │                    gammaOut ─┼─► RmsNorm.weightIn
                                      ▼                              │
                               RmsNormAxiTop ◄───────────────────────┘
```

Scheduler 拿到 `token_id` 后输出 **两条** `MemCmd`（embedding 行 + 对应 gamma 向量）；DdrAgent 分别经 `EMBED_ROW` / `RMS_GAMMA` sink 接到 RMSNorm 两条 AXI-Stream 输入。

---

## 3. HPS ↔ PL 控制面（HpsJobCtrl）

HpsJobCtrl 作为 LlamaScheduler 的 **AXI4-Lite Slave** 子模块（或紧耦合 IO），基址由 Platform Designer 导出。

### 3.1 互联

- HPS 经 **`lwhps2fpga`（Lightweight H2F，AXI4）** 访问 PL 寄存器；GHRD 见 `quartus_prj/GHRD/qsys_top.qsys`。
- `HpsJobCtrl` 为 **AXI4-Lite slave**（`addressWidth=8` 字节地址）；Platform Designer 将完整 AXI4 译码为 Lite。
- 大块权重（embedding、**RMSNorm γ**、attention、FFN）由 HPS 在**启动前**写入 DDR；推理中 PL 经 DdrAgent 读取 / 读写 KV。

### 3.1.1 `job_start` 脉冲（RTL 实现要点）

`job_start` 须在 AXI4-Lite 写 `CTRL(0x00)` bit0 的**同一事务**检测，用 `aw.fire && addr==0` 时的 `w.data(0)` 打一拍脉冲；勿依赖 `onWrite` 回调读 `ctrlReg(0)`（`readAndWrite` 更新顺序会导致漏脉冲）。

### 3.2 寄存器 map（片内偏移）

#### 控制与状态

| 偏移 | 名称 | 位域 | R/W | 说明 |
|:---:|:---|:---|:---:|:---|
| `0x00` | `CTRL` | `[0]` job_start | RW | 写 1 启动；PL 在 `IDLE→RUN` 时清 0 |
| | | `[1]` job_abort | RW | 终止当前 job |
| | | `[2]` soft_reset_scheduler | RW | 复位 Scheduler + DdrAgent 状态 |
| `0x04` | `STATUS` | `[0]` busy | RO | job 进行中 |
| | | `[1]` job_done_sticky | RO/W1C | 本 token 完成 |
| | | `[2]` job_error_sticky | RO/W1C | 错误 |
| | | `[7:4]` scheduler_state_dbg | RO | FSM 调试 |
| `0x08` | `TOKEN_ID` | `[16:0]` | RW | 0..128255 |
| `0x0C` | `SEQ_POS` | `[9:0]` | RW | 0..1023，RoPE / KV |
| `0x10` | `JOB_PHASE` | `[1:0]` | RW | §4 |
| `0x14` | `PROMPT_LEN` | `[9:0]` | RW | prefill prompt 长度 |
| `0x18` | `NEXT_TOKEN_ID` | `[16:0]` | RO | PL → ARM（decode sampling） |
| `0x1C` | `ERROR_CODE` | `[7:0]` | RO | `1`=token_id_oob, `2`=ddr_timeout, … |

#### 只读配置（与 DDR layout 自检）

| 偏移 | 名称 | 说明 |
|:---:|:---|:---|
| `0x80` | `LAYOUT_MAGIC` | 如 `0x4C4D3332` |
| `0x84` | `LAYOUT_VERSION` | DDR map 版本 |
| `0x88` | `EMB_BASE_LO` | 固定 `0` |
| `0x8C` | `VOCAB_SIZE` | 固定 `128256` |
| `0x90` | `RMS_GAMMA_BASE_LO` | 固定 `0x1F500000` |

### 3.3 Job 握手

```c
void run_one_token(uint32_t token_id, uint32_t seq_pos, job_phase_t phase) {
    mmio_write(TOKEN_ID, token_id);
    mmio_write(SEQ_POS, seq_pos);
    mmio_write(JOB_PHASE, phase);
    mmio_write(STATUS_W1C, JOB_DONE | JOB_ERROR);
    mmio_write(CTRL, JOB_START);
    while (mmio_read(STATUS) & BUSY) { }
    if (mmio_read(STATUS) & JOB_ERROR)
        handle_error(mmio_read(ERROR_CODE));
}
```

`job_start` 上升沿锁存 job 参数到 Scheduler 内部；**运行中 ARM 不得修改**。

---

## 4. Prefill 与 Decode

### 4.1 Embedding / γ 路径：不区分 phase

每次 RMSNorm 前从 DDR 读 4 KiB γ；embedding 同为 4 KiB 随机行读。与 `JOB_PHASE` 无关。

### 4.2 `JOB_PHASE` 用途（流水线后半段）

| 编码 | 含义 |
|:---:|:---|
| `0` | PREFILL |
| `1` | DECODE |
| `2` | RESERVED |
| `3` | RESERVED |

**里程碑 1**：锁存 `phase`，embedding/γ 子状态不消费。

### 4.3 `token_id` vs `seq_pos`

| 信号 | 用途 |
|:---|:---|
| `token_id` | Embedding 行地址 |
| `seq_pos` | RoPE、KV cache、`tuser.tokenSeqLow` |

---

## 5. MemCmd 生成（Scheduler → DdrAgent）

格式见 [ddr-agent-design.md](../../ddrAgent/doc/ddr-agent-design.md)。地址常量见 [ddr-memory-map.md](../../common/doc/ddr-memory-map.md)。

### 5.1 Embedding 查表

```text
if (token_id > 128255) → ERROR_CODE=1

MemCmd:
  cmd_type  = READ
  sink_id   = EMBED_ROW
  byte_len  = 4096
  ddr_addr  = token_id * 0x1000
  axis_ctx  = { layerId=0, normKind=0, seqPosLow=seq_pos[8:0] }
```

### 5.2 RMSNorm γ（DDR 权威副本）

```text
gamma_index = (normKind == 2) ? 32 : (layer * 2 + normKind)

MemCmd:
  cmd_type  = READ
  sink_id   = RMS_GAMMA
  byte_len  = 4096
  ddr_addr  = RMS_GAMMA_BASE + gamma_index * 0x1000    // 0x1F50_0000 + ...
  axis_ctx  = { layerId, normKind, seqPosLow }         // weightIn 调试用
```

**里程碑 1**（layer 0 norm1）：`layer=0`, `normKind=0` → `ddr_addr = 0x1F50_0000`。

两条 `MemCmd` 可在 `EMBED_REQ` 状态**连续推送**；DdrAgent 用 outstanding 并行读 DDR。Scheduler 须等 **两条 `MemDone`** 且 RMSNorm 两侧 stream 就绪后再进入 `WAIT_RMSNORM`。

---

## 6. 里程碑 1 子状态机

```text
IDLE
  │ job_start
  ▼
DDR_REQ ──推送 MemCmd(EMBED_ROW)──►
  │       推送 MemCmd(RMS_GAMMA, L0 norm1)
  ▼
WAIT_DDR ──等待两条 MemDone（DDR 读完成 + AXIS 排空）──►
  ▼
WAIT_RMSNORM ──等待 RmsNorm dataOut tlast──►
  ▼
JOB_DONE
  ▼
IDLE
```

说明：若 DdrAgent 的 `MemDone` 语义为「对应 sink 的 AXI-Stream 全部 handshake 完成」，则 `WAIT_DDR` 已隐含两侧 vector 灌入 RMSNorm；Scheduler 只需等 `MemDone`×2 + `dataOut` tlast。

### 6.1 时序概要

```text
T0:  ARM job_start
T1:  Scheduler → MemCmd(embed) + MemCmd(gamma@0x1F50_0000)
T2+: DdrAgent 并行 AXI 读 → embedOut → dataIn
                      γ 读 → gammaOut → weightIn
T*:  两条 MemDone
T*:  RmsNorm 计算 → dataOut
Tend: dataOut tlast → job_done
```

---

## 7. 与 RMSNorm 的衔接

依据 [rms-norm-module-design.md](../../rmsNorm/doc/rms-norm-module-design.md)：

1. RMSNorm **不读 DDR**；γ 由 DdrAgent `RMS_GAMMA` sink → `weightIn`。
2. `dataIn`（`EMBED_ROW`）与 `weightIn`（`RMS_GAMMA`）须对齐为同一次调用。
3. 流握手：计数器仅在 `fire` 时推进。

全量 decode 时，每层 norm1/norm2 及 final_norm 各发一次 `MemCmd(RMS_GAMMA)`，地址按 `gamma_addr(layer, normKind)` 递增（非连续层内步进 0x1000）。

---

## 8. 实现分期

### 里程碑 1（Embedding + RMSNorm L0）— **已完成**

| # | 任务 | 状态 |
|:---:|:---|:---:|
| 1 | `HpsJobCtrl`（AXI4-Lite）+ job 锁存 | ✓ |
| 2 | 双 `MemCmd`：`EMBED_ROW` + `RMS_GAMMA`（`0x1F50_0000`） | ✓ |
| 3 | 等待双 `MemDone` + `WAIT_RMSNORM` | ✓ |
| 4 | `job_done` / 错误回报（`errorCode=1` OOB） | ✓ |

集成验证：`top/make sim`（控制流）、`top/make questa-m1`（FP golden）。

### 后续

- 16 层 FSM，每层 2 次 γ 读 + final_norm
- `JOB_PHASE` 控制 LM head 跳过
- GemvService64 `MemCmd` 扩展

---

## 9. 目录约定

```text
llamaScheduler/
├── doc/
│   ├── README.md
│   └── llama-scheduler-design.md
├── scala/
│   ├── HpsJobCtrl.scala
│   └── LlamaSchedulerM1.scala
├── test/
│   └── LlamaSchedulerM1Sim.scala
└── Makefile                # make sim
```
