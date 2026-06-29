# LlamaM1Top — 里程碑 1 顶层设计

> PL 顶层：**HPS (AXI4-Lite)** → **LlamaSchedulerM1** → **DdrAgentM1** → **RmsNormAxiTop**  
> 对应文档：[ddr-memory-map.md](../../ddrMemoryMap/doc/ddr-memory-map.md)、[llama-scheduler-design.md](../../llamaScheduler/doc/llama-scheduler-design.md)、[ddr-agent-design.md](../../ddrAgent/doc/ddr-agent-design.md)、[rms-norm-module-design.md](../../rmsNorm/doc/rms-norm-module-design.md)

## 1. 互联图

```text
                    ┌─────────────────────────────────────────────────────────┐
  io.hps (AXI4-Lite)│ HpsJobCtrl                                              │
        slave ─────►│    jobStart / token_id / seq_pos …                        │
                    │         │                                               │
                    │         ▼                                               │
                    │ LlamaSchedulerM1 ──memCmd──► DdrAgentM1 ──io_ddrAxi──► DDR │
                    │         ▲                    │ embedOut ──┐   (256b AXI4) │
                    │         │ memDone            │ gammaOut ──┼──►          │
                    │    rmsNormOutLast            │            │   RmsNorm   │
                    │         │                    │            │   AxiTop    │
                    │         └────────────────────┴────────────┘      │    │
                    │                                                    ▼    │
                    │                                          io.rmsNormOut  │
                    └─────────────────────────────────────────────────────────┘

  HPS 启动：离线镜像 → 灌入 LPDDR4B 物理 0（逻辑 `EMB_BASE`）；LPDDR4A 仅 Linux。
```

逻辑地址与区域划分见 [ddr-memory-map.md](../../ddrMemoryMap/doc/ddr-memory-map.md)。

**GHRD 集成**：`quartus_prj/GHRD` 中 HPS→PL 控制面为 **`lwhps2fpga`（AXI4）**，非 APB。将 `io.hps` 经 Platform Designer interconnect 挂到 lightweight H2F slave；`io.ddrAxi` 接 LPDDR4B Fabric EMIF 或 `fpga2hps` 路径（按板级规划）。

## 2. 顶层端口

| 端口 | 类型 | 说明 |
|:---|:---|:---|
| `io.hps` | AXI4-Lite slave | HPS MMIO，`HpsJobCtrl` 寄存器 map（8-bit 字节地址，32-bit 数据） |
| `io.ddrAxi` | AXI4 master | `DdrAgentM1` DDR 读；综合/Questa 为 **256-bit** |
| `io.rmsNormOut` | AXI4-Stream master | L0 norm1 输出，2048×FP16 |

`MemCmd.ddr_addr` 为逻辑偏移，当前等于 B 片物理字节地址（见 `DdrMemoryMap`）。

## 3. 里程碑 1 数据流

**前提**：HPS 已将 Plan A 镜像写入 **LPDDR4B**（含 `EMB_BASE`、`RMS_GAMMA_BASE` 等；见 [ddr-memory-map.md §2–3](../../ddrMemoryMap/doc/ddr-memory-map.md)）。

1. HPS 写 `TOKEN_ID` / `SEQ_POS`，写 `CTRL.job_start`（AXI4-Lite 写 `0x00` bit0）。
2. `LlamaSchedulerM1` 校验 `token_id`，发 2 条 `MemCmd`（`EMBED_ROW` @ `embRowBase(token_id)` + `RMS_GAMMA` @ L0 norm1）。
3. `DdrAgentM1` 经 `io.ddrAxi` 读 DDR，`embedOut` / `gammaOut` 驱动 `RmsNorm.dataIn` / `weightIn`。
4. `RmsNormAxiTop` 输出 `rmsNormOut`；末 beat `tlast` 拉高 `rmsNormOutLast`。
5. Scheduler 进入 `JOB_DONE`，`STATUS.job_done` 置位。

**RTL 状态（已实现）**：`HpsJobCtrl`、`LlamaSchedulerM1`、`DdrAgentM1`、`RmsNormAxiTop` 均已例化于 `LlamaM1Top.scala`；端到端仿真见 §5。

## 4. Verilog 生成

```bash
cd src/scala/top
make verilog       # 综合用（Quartus FP IP，256-bit AXI）
make verilog-sim   # 仿真用（RmsNormAlteraIpSim 时序桩）
```

输出：`top/gen/verilog/LlamaM1Top.v`

## 5. 仿真

| 目标 | 命令 | 验证范围 |
|:---|:---|:---|
| Verilator 控制流 | `make verilator` | AXI4-Lite → Scheduler → DdrAgent → 2048 beats → `job_done`；**FP 数值无意义**（IP 桩输出 0） |
| Questa M1 毕业 | `make questa` | 同上 + **FP16 golden**（真实 Quartus IP）；test2 OOB `errorCode=1` |

变体：`make questa WAVE=1` 录波形；`make questa VIEW=1` 打开 WLF。Verilator 彩色 PASS/FAIL 由 `scripts/sbt-runmain.sh` 打印（见 [simulation-conventions.md](../../doc/simulation-conventions.md)）。

前提：`make -C tools/ddr_pack pack-m1` 生成 `ddr_image_m1.bin`；Questa 需 `source activate.sh`（simlib + questacoreprime）。

详见 [test/questa/README.md](../test/questa/README.md) 与 `.cursor/rules/questa-simulation.mdc`。

Verilator TB：`test/LlamaM1TopSim.scala`（`AxiLite4Driver` + `AxiMemorySim`，64-bit AXI）。默认不开 VCD；`VERILATOR_WAVE=1` 可选波形（见 simulation-conventions）。

## 7. 里程碑 2a 扩展

M2a 顶层为 `LlamaM2aTop`（`LlamaSchedulerM2a` + `DdrAgentM2` + `GemvService64` + `DdrCmdArb`）。设计与验证入口：

- [top/doc/README.md](README.md) — M2a 目录与命令
- [test/questa/README.md](../test/questa/README.md) — `questa-m2a` 毕业 TB
- [quartus/README.md](../quartus/README.md) — 资源/时序评估
- [gemv-m2a-design.md](../../gemvService64/doc/gemv-m2a-design.md) — GEMV 机械细节

## 6. 参数

| 环境变量 | 默认 | 说明 |
|:---|:---|:---|
| `LLAMA_M1_DIM` | 2048 | RMSNorm 向量维 |
| `LLAMA_M1_SIM_IP` | 0 | 1 → `verilog-sim` 用 `RmsNormAlteraIpSim` |
| `LLAMA_M1_GEN_DIR` | top/gen/verilog | 输出目录 |
| `DDR_IMAGE` | tools/ddr_pack/out/ddr_image_m1.bin | 仿真 DDR preload |

`LlamaM1Generics.axiDataWidth` 默认 256（综合/Questa）；Verilator `LlamaM1TopSim` 内部使用 64-bit 以加快迭代。
