# GemvService64 Quartus 工程

独立工程，用于在 Agilex 5E 上对 `GemvService64`（64-lane INT4 GEMV：ActBuffer + ScaleRam + MacBeat + tile engine）做 **综合 + 布局布线 + 时序分析**，**不生成 bitstream**（QSF 中 `FLOW_DISABLE_ASSEMBLER ON`）。

可综合 RTL 与 Questa `GEMV_DUT=service` 对齐：Spinal 生成的 `GemvService64.v` + 仓库 `quartus_ip/` 中 Quartus FP IP。不包含仿真 TB（`tb_gemv_service64.sv` 等）。

顶层 I/O 全部设为虚拟管脚（`VIRTUAL_PIN ON -to *`），与 rmsNorm / top 资源评估工程一致。

## 文件清单

| 类型 | 路径 |
|:---|:---|
| Spinal 生成 RTL | `../gen/verilog/GemvService64.v` |
| FP IP | `../../../../quartus_ip/{fp16ToFp32,fp32ToFp16,fp32Rsqrt,fp32MultAcc,fp32Add}.ip` |
| 时序约束 | `constraints/gemv_service64.sdc` |

## 前置

1. 在 `src/scala/gemvService64` 执行 `make verilog`（默认 `K=2048`、`M=2048`；smoke 可 `M=4`）
2. 仓库根目录 `quartus_ip/` 中已生成 FP IP
3. 批处理节点：`source ../../../set_env.sh`（导出 `NC_RUN`，当前 `RAM/32GB CORES/8`）

## 用法

```bash
cd src/scala/gemvService64
make quartus
make quartus-report
```

或手动：

```bash
cd src/scala/gemvService64/quartus
quartus_sh -t scripts/synth_fit_sta.tcl
```

资源与利用率见 `output_files/gemv_service64.fit.rpt`。

## 与 top 分层评估

| 工程 | 顶层 | 典型 Verilog 规模 | 用途 |
|:---|:---|:---|:---|
| 本工程 | `GemvService64` | ~7K 行 | GEMV DSP/BRAM 基线 |
| `top/quartus` | `LlamaM2aTop` | ~550K 行 | 全系统集成（含 ddrAgent 等） |

MAC-only 资源评估可另跑 `make verilog-mac` 后在 GUI 中替换顶层为 `GemvMacBeat.v`（后续可加独立 revision）。
