# common 公共定义

| 文件 | 说明 |
|:---|:---|
| [ddr-memory-map.md](ddr-memory-map.md) | **DDR 全局地址规划**（文档规格） |

## 三层用法（不重复生成）

| 消费方 | 用什么 | 说明 |
|:---|:---|:---|
| SpinalHDL（Scheduler、DdrAgent） | `DdrMemoryMap.scala` | **直接 import**，综合时嵌进 RTL，无需再生成 |
| 手写 SV testbench / 混合仿真 | `make sv` → `ddr_memory_map_pkg.sv` | `import ddr_memory_map_pkg::*` |
| 离线打包 / HPS 软件 | `DdrMemoryMap.scala` 或文档 | Python 可抄同一组十六进制 |

**不要**再维护一份 `` `define `` `.vh`：与 package 里的 `localparam` 完全重复，且 `.vh` 无法带地址 `function`。

## Scala 源码

| 文件 | 说明 |
|:---|:---|
| `../DdrMemoryMap.scala` | 唯一逻辑来源 |
| `../DdrMemoryMapCheck.scala` | `make check` |
| `../DdrMemoryMapGen.scala` | `make sv` → 仅 SV package |

## RTL 生成

```bash
cd src/scala/common && make sv
```

```systemverilog
import ddr_memory_map_pkg::*;

logic [31:0] addr;
addr = emb_row_base(token_id);
addr = gamma_addr(4'd0, NORM_KIND_NORM1);
```
