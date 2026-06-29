# LlamaM2aTop Quartus 工程

独立工程，用于在 Agilex 5E 上对 `LlamaM2aTop`（M2a：HPS MMIO + Scheduler + DdrAgent + RmsNorm + Gemv）做 **综合 + 布局布线 + 时序分析**，**不生成 bitstream**（QSF 中 `FLOW_DISABLE_ASSEMBLER ON`）。

可综合 RTL 与 Questa M2a 仿真对齐：Spinal 生成的 `LlamaM2aTop.v` + 仓库 `quartus_ip/` 中 5 个 Quartus FP IP（与 `rmsNorm/test/questa/compile_ips.tcl` 相同）。不包含仿真专用 TB（`tb_llama_m2a_top.sv`、`axi_read_mem.sv` 等）。

顶层 I/O 全部设为虚拟管脚（`VIRTUAL_PIN ON -to *`），与 rmsNorm 资源评估工程一致。DDR EMIF 尚未接入，`io_ddrAxi` AXI master 同样走虚拟管脚，仅作资源/时序评估。

## 文件清单

| 类型 | 路径 |
|:---|:---|
| Spinal 生成 RTL | `../gen/verilog/LlamaM2aTop.v` |
| FP IP | `../../../../quartus_ip/{fp16ToFp32,fp32ToFp16,fp32Rsqrt,fp32MultAcc,fp32Add}.ip` |
| 时序约束 | `constraints/llama_m2a_top.sdc` |

## 前置

1. 在 `src/scala/top` 执行 `make verilog-m2a`（默认 `LLAMA_M2A_DIM=2048`、`LLAMA_M2A_M=2048`）
2. 仓库根目录 `quartus_ip/` 中已生成 FP IP（与 GHRD 共用）
3. 批处理节点：`source ../../../set_env.sh`（导出 `NC_RUN`）

## 用法

```bash
cd src/scala/top
make quartus-m2a
make quartus-m2a-report
```

或手动：

```bash
cd src/scala/top/quartus
quartus_sh -t scripts/synth_fit_sta.tcl
```

资源与利用率见 `output_files/llama_m2a_top.fit.rpt`。
