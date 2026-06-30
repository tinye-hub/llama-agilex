# RoPE Quartus 工程

独立工程，用于在 Agilex 5E 上对 `SerialRoPEAxiTop`（64-dim FP16 RoPE，AXI-Stream 串行 pair-wise 旋转）做 **综合 + 布局布线 + 时序分析**，**不生成 bitstream**（QSF 中 `FLOW_DISABLE_ASSEMBLER ON`）。

可综合 RTL 与 Questa 对齐：Spinal 生成的 `SerialRoPEAxiTop.v` + 仓库 `quartus_ip/` 中 Quartus FP IP（`fp16ToFp32`、`fp32ToFp16`、`fp32MultAcc`、`fp32Add`）。不包含仿真 TB。

顶层 I/O 全部设为虚拟管脚（`VIRTUAL_PIN ON -to *`），与 rmsNorm / gemvService64 资源评估工程一致。

## 文件清单

| 类型 | 路径 |
|:---|:---|
| Spinal 生成 RTL | `../gen/verilog/SerialRoPEAxiTop.v` |
| FP IP | `../../../../quartus_ip/{fp16ToFp32,fp32ToFp16,fp32MultAcc,fp32Add}.ip` |
| 时序约束 | `constraints/serial_rope_axi_top.sdc` |

## 前置

1. 在 `src/scala/rope` 执行 `make verilog`（默认 `ROPE_MAX_POS=1024`、`ROPE_HEAD_DIM=64`）
2. 仓库根目录 `quartus_ip/` 中已生成 FP IP
3. 批处理节点：`source ../../../set_env.sh`（导出 `NC_RUN`）

## 用法

```bash
cd src/scala/rope
make quartus-all
make quartus-report
```

或手动：

```bash
cd src/scala/rope/quartus
quartus_sh -t scripts/synth_fit_sta.tcl
```

资源与利用率见 `output_files/serial_rope_axi_top.fit.rpt`；时序见 `output_files/serial_rope_axi_top.sta.rpt`。

## 时钟假设

SDC 默认 **400 MHz**（`create_clock -period 2.500`），与 rmsNorm / gemvService64 模块评估一致。`quartus-report` 中 Setup TNS = 0 表示在该频率下时序满足。

## 与 top 分层评估

| 工程 | 顶层 | 用途 |
|:---|:---|:---|
| 本工程 | `SerialRoPEAxiTop` | RoPE FP pipe + cos/sin ROM 基线 |
| `top/quartus` | `LlamaM2aTop` | 全系统集成（M2b 集成后另开 revision） |
