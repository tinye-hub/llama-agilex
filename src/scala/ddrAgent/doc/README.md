# ddrAgent 模块文档

| 文件 | 说明 |
|:---|:---|
| [ddr-agent-design.md](ddr-agent-design.md) | `MemCmd`/`MemDone`、AXI master、sink 路由 |

## Scala 源码

| 文件 | 说明 |
|:---|:---|
| `../scala/DdrAgentBundles.scala` | `MemCmd`, `MemDone`, `DdrSinkId` |
| `../scala/DdrAgentAxi.scala` | AXI4 参数（256-bit 主线；仿真可用 64-bit） |
| `../scala/DdrAgentM1.scala` | 里程碑 1：`MemCmd` → AXI 读 → `embedOut` / `gammaOut` |
| `../test/DdrAgentM1Sim.scala` | Verilator 仿真（官方 `AxiMemorySim` 作 AXI slave） |
| `../test/questa/` | Questa 仿真（`tb_ddr_agent_m1.sv` + `axi_read_mem.sv`） |
| `../test/SimDdrImage.scala` | 加载 `ddr_image_m1.bin` |

由 `top/LlamaM1Top` 例化。

## 仿真

```bash
make -C tools/ddr_pack pack-m1
make -C src/scala/ddrAgent sim          # Verilator
make -C src/scala/ddrAgent questa-m1    # Questa (需 set_env.sh + questacoreprime)
```

默认 preload：`tools/ddr_pack/out/ddr_image_m1.bin`（可用 `DDR_IMAGE` 覆盖）。  
Verilator 仿真用 64-bit AXI；Questa / 综合默认 256-bit（`make verilog AXI_WIDTH=256`）。

## 相关文档

- [llama-m1-top-design.md](../../top/doc/llama-m1-top-design.md)
