# util — Altera floating-point IP wrappers

SpinalHDL BlackBox wrappers for Quartus-generated IPs under [`quartus_ip/`](../../quartus_ip/).

## Pattern (same as llama-fpga Xilinx)

1. **BlackBox** — port names match `quartus_ip/<name>/<name>_bb.v`; `setDefinitionName` equals the Quartus component name (e.g. `fp32MultAcc`). Clock/reset use `mapClockDomain` on the BlackBox; adapters must **not** assign `ip.io.clk` manually (same as llama-fpga Xilinx wrappers).
2. **Adapter Component** — maps Spinal `Flow` / `Stream` valid semantics onto IP ports (`en`, or fixed `ena`).
3. **Collection object** — factory methods (`mul`, `convert`, `serialAcc`, …) for injection into `RMSNormFp32`-style modules.
4. **Sim** — `*_sim` methods use `IntelFloatIPFlowIOSim` (valid delay only, no vendor netlist).

RTL is **not** referenced from Scala. Quartus links IP via `quartus_prj/GHRD/golden_top.qsf` `IP_FILE` entries.

## IP map

| Quartus name | Wrapper object | Methods |
|:---|:---|:---|
| `fp16ToFp32` | `fp16ToFp32` | `convert` |
| `fp32ToFp16` | `fp32ToFp16` | `convert` |
| `fp32Rsqrt` | `fp32Rsqrt` | `rsqrt` |
| `fp32MultAcc` | `fp32MultAcc` | `mul`, `mulStream`, `serialAcc` |
| `fp32Add` | `fp32Add` | `add` |

RMSNorm injection entry point: [`RmsNormAlteraIp.scala`](RmsNormAlteraIp.scala).

## Latencies

Documented as `latency` constants in `IntelFloatIPCollection.scala`. Native DSP values should be confirmed in ModelSim before closing timing on the full design.
