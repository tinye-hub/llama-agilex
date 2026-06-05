# rmsNorm 模块文档

| 文件 | 说明 |
|:---|:---|
| [rms-norm-module-design.md](rms-norm-module-design.md) | 功能、接口、IP 注入与实现计划 |

## 目录约定

```
rmsNorm/
├── doc/       设计文档
├── scala/     SpinalHDL 源码（综合用）
├── test/      仿真 testbench（Verilator）
├── gen/       生成物（Verilog、仿真工作区，不入库）
├── quartus/   本模块独立 Quartus 工程（仅综合/FIT/STA，不生成 bitstream）
└── Makefile   verilog / sim / quartus 入口
```
