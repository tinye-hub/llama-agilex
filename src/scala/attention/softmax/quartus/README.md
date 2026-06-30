# SerialSafeSoftmax Quartus 工程

独立工程，在 Agilex 5E 上对 `SerialSafeSoftmaxAxiTop` 做 **综合 + 布局布线 + 时序分析**，不生成 bitstream。

## 用法

```bash
source activate.sh   # 仓库根目录
cd src/scala/attention/softmax
make quartus
make quartus-report
```

## 文件

| 类型 | 路径 |
|:---|:---|
| Spinal RTL | `../gen/verilog/SerialSafeSoftmaxAxiTop.v` |
| FP IP | `../../../../../quartus_ip/{fp16ToFp32,fp32ToFp16,fp32Add,fp32MultAcc,fp32Exp,fp32Div}.ip` |
| SDC | `constraints/serial_safe_softmax_axi_top.sdc`（clk 400 MHz） |
