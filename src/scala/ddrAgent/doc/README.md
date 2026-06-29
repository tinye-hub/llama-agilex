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
| `../scala/DdrAgentM2.scala` | 里程碑 2a：M1 + `GEMV_WEIGHT` tile + `scalePreload` |
| `../scala/DdrAgentRowMem.scala` | 行缓冲：M20K 宽 beat RAM（`readAsync` + `writeBeat(enable=axi.r.fire)`） |
| `../test/DdrAgentM1Sim.scala` | Verilator M1（64-bit AXI；`VERILATOR_WAVE=1` 可选波形） |
| `../test/DdrAgentM2aSim.scala` | Verilator M2a（256-bit AXI；embed/gamma + W_Q tile） |
| `../test/questa/` | Questa：`tb_ddr_agent_m1.sv` / `tb_ddr_agent_m2a.sv` + `axi_read_mem.sv` |
| `../test/SimDdrImage.scala` | 加载 DDR bin（FP16 row + INT4 tile golden） |

由 `top/LlamaM1Top` / `LlamaM2aTop` 例化。

## 仿真

```bash
# M1 — embed + gamma rows
make -C tools/ddr_pack pack-m1
make -C src/scala/ddrAgent verilator          # Verilator DdrAgentM1Sim
make -C src/scala/ddrAgent questa-m1          # Questa M1（`make questa` 别名）

# M2a — GEMV_WEIGHT 32 B tile @ W_Q(0)
make -C tools/ddr_pack fixture                  # ddr_fixture.bin（含 4 个 W_Q tile）
make -C src/scala/ddrAgent verilator-m2a
make -C src/scala/ddrAgent questa-m2a           # 需 set_env.sh + questacoreprime
```

M1 preload：`tools/ddr_pack/out/ddr_image_m1.bin`  
M2a preload：`tools/ddr_pack/out/ddr_fixture.bin`（单元）或 `ddr_image.bin`（top 集成）  
Verilator M1 用 64-bit AXI；M2a / Questa / 综合默认 256-bit（`make verilog-m2a AXI_WIDTH=256`）。  
Verilator 默认不开波形（`VERILATOR_WAVE=1` 可选）；见 [simulation-conventions.md](../../doc/simulation-conventions.md)。

约定：[simulation-conventions.md](../../doc/simulation-conventions.md)

## 相关文档

- [llama-m1-top-design.md](../../top/doc/llama-m1-top-design.md)
- [top/test/questa/README.md](../../top/test/questa/README.md) — 端到端 M1 毕业（`make questa`）
