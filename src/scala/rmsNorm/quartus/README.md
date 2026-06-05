# rmsNorm Quartus 工程

独立工程，用于在 Agilex 5E 上对 `RmsNormAxiTop` 做 **综合 + 布局布线 + 时序分析**，**不生成 bitstream**（QSF 中 `FLOW_ENABLE_ASSEMBLER OFF`）。

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
