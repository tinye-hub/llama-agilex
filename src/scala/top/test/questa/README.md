# Llama Top Questa simulation

## M1 — `LlamaM1Top`

M1 毕业考试：`LlamaM1Top` 端到端仿真，含真实 Quartus Agilex 5 浮点 IP（`altera_fp_functions` + `agilex_native_floating_point_dsp`），数值精度可验证。

## M2a — `LlamaM2aTop`

M2a 毕业考试：M1 路径 + L0 `W_Q` GEMV（`GemvService64` + `DdrAgentM2` tile/scale 读）。

```bash
make -C tools/ddr_pack pack          # ddr_image.bin（含 INT4 W_Q + scales）
cd src/scala/top && make questa-m2a  # 默认 K=M=2048
make questa-m2a M=4                  # smoke：4 行输出，全 K
```

---

仿真命名与 `WAVE`/`VIEW` 约定见 [simulation-conventions.md](../../../doc/simulation-conventions.md)。

## 为什么必须用 Questa

Verilator **不支持**仿真 Quartus Agilex IP 黑盒子。
`IntelFloatIPFlowIOSim` 只是延迟桩（输出恒为 0），无法验证 FP 精度。
所有含乘法器、FP IP 的模块**必须用 Questa 做功能仿真**（见 `.cursor/rules/questa-simulation.mdc`）。

## 测试覆盖

| Test | 描述 | Pass 条件 |
|:---|:---|:---|
| test1 happy path | token_id=0, seq_pos=7 | 2048 rmsNormOut beats，FP16 golden 比对（tolerance 1e-2），job_done=1，job_error=0 |
| test2 OOB | token_id=128256 (vocabSize) | job_error=1，errorCode=1，无 DDR 读，无 rmsNormOut |

### M2a 附加（`tb_llama_m2a_top.sv`）

| 项 | 说明 |
|:---|:---|
| 路径 | M1 embed→RMSNorm + L0 `W_Q` GEMV |
| DDR | `ddr_image.bin`（`make -C tools/ddr_pack pack`） |
| Pass | rmsNormOut 2048 beat golden；`qOut` 行向量与参考比对；`job_done` |
| 回归 smoke | batch 默认 `LLAMA_M2A_M=4`（见 `sim-matrix-job.sh`） |

## 前提

```bash
source /userworkqum/tinye/llama-agilex/activate.sh   # quartus + questacoreprime
make -C tools/ddr_pack pack-m1                        # ddr_image_m1.bin
cd src/scala/top && make verilog                      # top/gen/verilog/LlamaM1Top.v
```

Simlib 必须在 `simlib/quartus2025_1_1_agilex5_questa2024_3/`（由 `quartus_sh --simlib_comp` 生成，与 rmsNorm Questa 共用）。

## 运行

```bash
cd src/scala/top
make questa-m1           # M1 毕业（`make questa` 别名）
make questa-m2a          # M2a 毕业
make questa-m1 WAVE=1    # 录制 WLF
make questa VIEW=1       # Questa GUI 打开波形（需 DISPLAY）
make questa NC_RUN=      # 本地 Questa license
make verilator           # M1 控制流 only（默认无 VCD；VERILATOR_WAVE=1 可选）
```

## 文件说明

| 文件 | 说明 |
|:---|:---|
| `run.sh` | 入口脚本（source set_env.sh，检查前提，vsim -c） |
| `paths.tcl` | 仓库路径、simlib mapping、work dir、fp32Rsqrt LUT symlinks |
| `compile_dut.tcl` | 编译 FP IP + `LlamaM1Top.v` + M1 TB |
| `compile_dut_m2a.tcl` | 编译 FP IP + `LlamaM2aTop.v` + M2a TB |
| `run_m1.do` / `run_m2a.do` | 编译 + 仿真 |
| `tb_llama_m1_top.sv` | M1 TB |
| `tb_llama_m2a_top.sv` | M2a TB（RMSNorm + GEMV Q 输出 golden） |

共享文件（不复制，通过 paths.tcl 路径引用）：

- `rmsNorm/test/questa/fp16_utils.sv` — FP16/FP32 转换包 + `golden_rmsnorm_fp16()`
- `ddrAgent/test/questa/axi_read_mem.sv` — AXI4 read-only 内存模型（256-bit）
- `rmsNorm/test/questa/compile_ips.tcl` — Quartus FP IP 编译（内部会 source `compile_quartus_vhdl_libs.tcl`）
