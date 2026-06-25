# 模块仿真约定（Verilator / Questa）

各 Spinal 模块 Makefile 统一用**仿真器名称**作目标，避免 `sim` 歧义：

| 目标 | 仿真器 | 典型验证内容 |
|:---|:---|:---|
| `make verilator` | Verilator + IP 时序桩 | 握手、beat 计数、FSM；**不做 FP 数值 golden** |
| `make questa` | Questa + Quartus 真实 FP IP | FP16/FP32 golden、端到端数据路径 |

含 FP 黑盒的模块（`rmsNorm`、`top` 等）须 **Questa 毕业**；Verilator 仅 smoke test。见 `.cursor/rules/questa-simulation.mdc`。

## 全模块回归（`src/scala/Makefile`）

```bash
cd src/scala
make verilator    # 所有 Verilator smoke
make questa       # 所有 Questa FP golden
make sim          # 两者都跑，末尾打印 PASS/FAIL 汇总表
```

脚本 [`scripts/sim-matrix.sh`](scripts/sim-matrix.sh) 会依次调用各子模块 Makefile；单个失败不中断后续模块，最后根据输出中的 `********** PASS/FAIL **********` 汇总。

## Questa 变体（`WAVE` / `VIEW`）

与 `rmsNorm`、`top` 相同：

```bash
make questa              # 默认回归
make questa WAVE=1       # 录制 WLF（大、慢）
make questa VIEW=1       # Questa GUI 打开 WLF（需 DISPLAY）
make questa NC_RUN=      # 本机 license（不设则走 set_env.sh 的 batch nc）
```

`WAVE=1` 与 `VIEW=1` 互斥：`VIEW=1` 只打开已有波形，不重新跑仿真。

## Verilator 彩色 PASS / FAIL

sbt `fork` 会把子进程 stdout 包成 `[info] ...`，Scala 里 `\u001b[32m` **不会**在终端显示绿色（`/dev/tty` 在 fork 下也常 `ENXIO`）。

**做法**：模块 Makefile 的 `verilator` 目标调用 [`scripts/sbt-runmain.sh`](../scripts/sbt-runmain.sh)，在 sbt 退出后用 shell `printf` 打横幅（与 Questa TB 里 `\033[32m` 一致）：

```makefile
cd $(SCALA_ROOT) && DDR_IMAGE="$(DDR_IMAGE)" \
  $(SCALA_ROOT)/scripts/sbt-runmain.sh top.LlamaM1TopSim
```

- 成功：绿色 `********** PASS **********`
- 失败：红色 `********** FAIL **********`

Scala `*Sim` 内**不要**再打印同色 PASS 行，避免重复。

Questa TB 仍在 SV 里用 `$display("\033[32m********** PASS **********\033[0m")`（vsim 直连终端）。

## 各模块入口

| 模块 | Verilator | Questa |
|:---|:---|:---|
| `rmsNorm/` | `make verilator` | `make questa` |
| `top/` | `make verilator` | `make questa`（M1 毕业 TB：`test/questa/run.sh m1`） |
| `ddrAgent/` | `make verilator` | `make questa` |
| `llamaScheduler/` | `make verilator` | — |

## 共享脚本与资产

| 路径 | 用途 |
|:---|:---|
| `src/scala/scripts/sbt-runmain.sh` | Verilator 回归 + 彩色 PASS/FAIL |
| `src/scala/scripts/patch_verilator_make.sh` | Verilator 5.036+ `WData` 兼容 |
| `simlib/quartus*_agilex5_questa*/` | Questa 设备库（预编译） |
| `tools/ddr_pack/out/ddr_image_m1.bin` | M1 DDR preload（`top` / `ddrAgent` Questa） |
