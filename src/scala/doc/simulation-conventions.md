# 模块仿真约定（Questa）

各 Spinal 模块 Makefile 统一用 **`make questa`** 作正式仿真入口：

| 目标 | 仿真器 | 典型验证内容 |
|:---|:---|:---|
| `make questa` | Questa + Quartus 真实 FP IP（或纯 RTL） | FP16/FP32 golden、握手、FSM、端到端数据路径 |

含 FP 黑盒的模块（`rmsNorm`、`rope`、`top`、`gemvService64` 等）须 **Questa 毕业**。见 `.cursor/rules/questa-simulation.mdc`。

## 全模块回归（`src/scala/Makefile`）

```bash
cd src/scala
make questa          # 串行，末尾 PASS/FAIL 汇总表
make regression      # 全矩阵并行 nc（= make questa PARALLEL=1）
```

脚本 [`scripts/sim-matrix.sh`](scripts/sim-matrix.sh) 会依次调用各子模块 Makefile；单个失败不中断后续模块，最后根据输出中的 `********** PASS/FAIL **********` 汇总。

### 并行 batch（`PARALLEL=1` + `NC_RUN_BG`）

登录节点执行 `make regression`（或 `PARALLEL=1`）时，若尚未 `source activate.sh`，`sim-matrix.sh` 会**自动 source** 仓库根目录的 `activate.sh`（导出 `NC_RUN_BG` 并加载 Quartus/Questa 模块）。

```bash
cd src/scala
make regression           # 推荐：7 job 并行（Questa）
make questa PARALLEL=1
```

后台提交格式（`set_env.sh`）：

```bash
nc run -r Taskerlist:b OSREL:RHEL8 RAM/4GB CORES/4 CGROUP:CORES -jpp fastest,pack -- <command>
```

| 变量 | 用途 | 行为 |
|:---|:---|:---|
| `NC_RUN` | 子模块 `make questa` / `make quartus` | `-I` 阻塞，Taskerlist:i **RAM/32GB CORES/8** |
| `NC_RUN_BG` | `PARALLEL=1` 矩阵回归 | 无 `-I`，先全部提交再 `nc wait`，**RAM/4GB CORES/4** |

**Batch 注意**：nc SNAPSHOT 会带上登录节点的 `XDG_RUNTIME_DIR=/run/user/<uid>`，batch 节点无法写入，sbt 会报 `AccessDeniedException`。`sim-matrix-job.sh` 在 batch 节点 `/tmp/sm-<hash>/` 建短路径 runtime。

**工具链**：登录节点与 batch 节点均需 `source ../../activate.sh`（Java/sbt、Questa）。`sim-matrix.sh` 在提交前自动 source；`sim-matrix-job.sh` 在 batch 节点内再次 source。

**并行 sbt**：多 job 同时写 NFS 上 `src/scala/project/target` 会损坏元构建。batch job 经 `sbt-flock.sh` 对 `.cache/sbt.lock` 串行化 **sbt 调用**；vsim 编译仍并行。回归前在登录节点 pre-warm 一次 `sbt exit`。

- batch 节点内清空 `NC_RUN`，直接 `make`（避免 Questa 二次 nc）
- 完成判定：`nc wait` + `nc info Status` + log 中 PASS/FAIL；等待期间 `>> PASS` / `>> FAIL` 逐 job 打印
- 日志目录：`src/scala/out/logs/run_<timestamp>/`，`src/scala/out/logs/latest` 为符号链接

## Questa 变体（`WAVE` / `VIEW`）

```bash
make questa              # 默认回归
make questa WAVE=1       # 录制 WLF（大、慢）
make questa VIEW=1       # Questa GUI 打开 WLF（需 DISPLAY）
make questa NC_RUN=      # 本机 license（不设则走 set_env.sh 的 batch nc）
```

`WAVE=1` 与 `VIEW=1` 互斥：`VIEW=1` 只打开已有波形，不重新跑仿真。

## PASS / FAIL 横幅

Questa TB 在 SV 里用 `$display("\033[32m********** PASS **********\033[0m")`（vsim 直连终端）。`sim-matrix.sh` 据此汇总回归结果。

## 各模块入口

| 模块 | Questa |
|:---|:---|
| `rmsNorm/` | `make questa` |
| `gemvService64/` | `make questa` |
| `rope/` | `make questa`（SerialRoPEAxiTop，默认 `ROPE_MAX_POS=1024`） |
| `ddrAgent/` | `make questa`（M1+M2a 串行） |
| `top/` | `make questa`（M1）、`questa-m2a`（M2a W_Q） |
| `llamaScheduler/` | `make questa`（M1 单元 TB） |
| `attention/softmax/` | `make questa`（SerialSafeSoftmaxAxiTop，默认 `SOFTMAX_CASE=len16`） |

### 全矩阵回归（`make regression`）

| # | 模块 | 目标 | 说明 |
|:---:|:---|:---|:---|
| 1–8 | rmsNorm, gemvService64, rope, ddrAgent, top×2, llamaScheduler, attention/softmax | `questa` / `questa-m2a` / `softmax` | 8 个并行 nc job |

`top questa-m2a` 在 batch 中默认 `LLAMA_M2A_M=4`（smoke，全 K=2048）；本地完整 M 可 `make questa-m2a M=2048`。

## 相关脚本

| 脚本 | 用途 |
|:---|:---|
| `src/scala/scripts/sim-matrix.sh` | 全模块 Questa 回归 + 汇总表 |
| `src/scala/scripts/sim-matrix-job.sh` | 单模块 nc batch job |
| `src/scala/scripts/sbt-flock.sh` | 并行 sbt 文件锁 |
