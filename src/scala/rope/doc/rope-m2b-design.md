# M2b — SerialRoPE 设计（草案）

> 里程碑：[doc/milestone-m2.md](../../../../doc/milestone-m2.md)  
> 参考实现：`llama-fpga/.../scala/rope/`（`RoPERotate` + 在线 `CosSinGen`）  
> 本工程主线：离线 cos/sin 表 + 1K 上下文（见架构文档 §5.7）

## 范围

| 项目 | 说明 |
|:---|:---|
| 输入 | 单 head 向量 64×FP16 AXI-Stream + `seq_pos[9:0]` |
| 输出 | RoPE 后 64×FP16，流形与 Gemv `qOut` 一致 |
| 表 | `cos/sin[seq_pos][dim]` FP16，`max_pos=1024`（1K context） |
| 毕业 | `make -C src/scala/rope questa`；含于 `make regression` |

## 模块

```text
SerialRoPEAxiTop
  └── SerialRoPE
        ├── RoPECosSinRom   (offline RoPETableInit)
        └── RoPEPairPipe    (FP16 mul/add via Quartus IP)
```

## cos/sin 表

由 `tools/rope_golden/gen_rope_tables.py` 生成（**无需手工填表**）：

```bash
python3 tools/rope_golden/gen_rope_tables.py \
  --max-pos 1024 --head-dim 64 \
  --scala-out src/scala/rope/scala/RoPETableInit.scala
```

参数：`rope_theta=500_000`，`head_dim=64`（Llama 3.2 1B）。

`make tables` / `make verilog` 会自动调用（默认 `ROPE_MAX_POS=1024`）。

## 与 llama-fpga 的差异

| llama-fpga | llama-agilex M2b |
|:---|:---|
| 在线 `pos × invFreq` + 1/4 周期 sin ROM | 离线全表 `RoPECosSinRom` |
| Xilinx FP16 mul/add IP | Intel `fp16ToFp32` → `fp32MultAcc` / `fp32Add` → `fp32ToFp16` |
| `RoPERotate` 流水 | `RoPEPairPipe` 按维度对串行（64 in / 64 out） |

`RoPERotate.scala` 保留作参考移植，当前毕业路径使用 pair-wise 实现。

## 后续（不在本 PR）

- `LlamaM2bTop`：Gemv `qOut` / `kOut` → RoPE
- Scheduler `W_K` / `W_V`
- ~~回归矩阵加入 `rope`~~ ✓（`make regression` / `sim-matrix.sh`）
