# rmsNorm Quartus 工程

独立工程，用于在 Agilex 5E 上对 `RmsNormAxiTop` 做 **综合 + 布局布线 + 时序分析**，**不生成 bitstream**（QSF 中 `FLOW_ENABLE_ASSEMBLER OFF`）。顶层 I/O 使用 `set_instance_assignment -name VIRTUAL_PIN ON -to * -entity RmsNormAxiTop`（与 ldpc 资源评估工程一致）。`FLOW_DISABLE_ASSEMBLER ON`，不生成 bitstream。

## 文件清单

| 类型 | 路径 |
|:---|:---|
| Spinal 生成 RTL | `../gen/verilog/RmsNormAxiTop.v` |
| FP IP | `../../../../quartus_ip/{fp16ToFp32,fp32ToFp16,fp32Rsqrt,fp32MultAcc,fp32Add}.ip` |
| 时序约束 | `constraints/rmsnorm_top.sdc` |

## 前置

1. 在 `src/scala/rmsNorm` 执行 `make verilog`，生成 `../gen/verilog/RmsNormAxiTop.v`
2. 仓库根目录 `quartus_ip/` 中已生成 FP IP（与 GHRD 共用）

## 用法

```bash
cd src/scala/rmsNorm
make quartus
make quartus-report
```

或手动：

```bash
cd src/scala/rmsNorm/quartus
quartus_sh -t scripts/synth_fit_sta.tcl
```

资源与利用率见 `output_files/rmsnorm_top.fit.rpt`。
