# 里程碑 M2 — Attention 子层（M2a ~ M2d）

> M1 已完成：`token_id` → embed → RMSNorm L0 norm1 → 2048×FP16。  
> M2 目标：打通 **Pre-Attention RMSNorm → Q/K/V 投影 → RoPE → GQA → W_O** 整条 attention 子层。

**架构背景**：[llama3.2-1b-arch-for-fpga-design.md](llama3.2-1b-arch-for-fpga-design.md) §5–§6、§11.1  
**GEMV 规范**：[src/scala/gemvService64/doc/gemv-service-64-design.md](../src/scala/gemvService64/doc/gemv-service-64-design.md)  
**DDR 地址**：[src/scala/ddrMemoryMap/doc/ddr-memory-map.md](../src/scala/ddrMemoryMap/doc/ddr-memory-map.md)

---

## 总览

```text
M1 ✓  embed → RMSNorm

M2a   DdrAgent GEMV_WEIGHT + GemvService64
      └─ L0：RMSNorm 后 W_Q（可扩展 W_K / W_V）

M2b   SerialRoPE
      └─ cos/sin 表 + Q/K 旋转；Questa golden

M2c   Incremental GQA（decode-style）
      └─ KV_WRITE + KV_READ；QK → softmax → AV

M2d   W_O 投影 + residual add
      └─ 完成单层 attention 子层
```

| 里程碑 | 输入 | 输出 | 新增模块 / 扩展 | 毕业考试 |
|:---|:---|:---|:---|:---|
| **M2a** | RMSNorm 2048 FP16 | Q（及可选 K/V）向量 | `GemvService64`、`DdrAgent` TileSink、`Scheduler` GEMV 状态 | `gemvService64/make questa` + `top/make questa-m2a` |
| **M2b** | Q、K + `seq_pos` | RoPE(Q)、RoPE(K) | `SerialRoPE`、RoPE 表 | `rope/make questa` |
| **M2c** | RoPE Q/K、V、KV cache | per-head attn out（2048 维前） | `GqaAttention`、KV sink | `attention/make questa` |
| **M2d** | concat heads | attn 子层输出 + residual | `W_O` GEMV、`ResidualAdd` | `top/make questa-m2d` |

---

## M2a — GemvService64 + W_Q/K/V 投影

**范围**：`DdrAgent` 增加 `GEMV_WEIGHT` sink；新建 `gemvService64` 模块；`Scheduler` 在 RMSNorm 后发起 `W_Q`（L0）；可选同引擎跑 `W_K` / `W_V`。

**不在 M2a**：RoPE、KV cache、softmax、W_O、FFN。

**设计文档（Review v3）**：[gemv-m2a-design.md](../src/scala/gemvService64/doc/gemv-m2a-design.md) — **256b AXI / bankLen=64**、ActBuffer 窄写 1024b 宽读、`GemvMacBeat`、语义/机械地址、scale、FSM、a1–a4。

---

## M2b — RoPE

**范围**：`SerialRoPE` 对 Q、K 做 `head_dim=64` 旋转；1K 主线 cos/sin 表（256 KiB 片上或 DDR）。

**依赖**：M2a 输出的 Q、K stream。

---

## M2c — Incremental GQA

**范围**：decode / Plan B prefill 风格的 **增量注意力**（非全序列并行 mask）：

- 写当前 token 的 K/V 到 `KV_BASE`
- QK 点积（`q · K_cache^T / sqrt(64)`）
- `SerialSafeSoftmax`
- AV 加权

**依赖**：M2b 的 RoPE Q/K；M2a 的 V；`DdrAgent` `KV_READ` / `KV_WRITE`。

---

## M2d — W_O + Residual

**范围**：`W_O · concat(o_0..o_31)` + 与 RMSNorm 前 residual 相加。

**依赖**：M2c 的 attention 输出；M1 保存的 shortcut。

---

## DDR / 打包

| 里程碑 | DDR 镜像 | 说明 |
|:---|:---|:---|
| M1 | `make -C tools/ddr_pack pack-m1` | embed + γ |
| M2a+ | `make -C tools/ddr_pack pack` | + INT4 attn/ffn + metadata scales |

M2a 起启用 `ATTN_BASE`（`0x2000_0000`）与 `META_ATTN_SCALE_BASE`（`0x3F00_1000`）。

---

## 相关文档

| 文档 | 内容 |
|:---|:---|
| [ddr-agent-design.md](../src/scala/ddrAgent/doc/ddr-agent-design.md) | `GEMV_WEIGHT` sink |
| [llama-scheduler-design.md](../src/scala/llamaScheduler/doc/llama-scheduler-design.md) | 层内 GEMV 调度 |
| [llama-m1-top-design.md](../src/scala/top/doc/llama-m1-top-design.md) | M1 顶层（M2 扩展基线） |
