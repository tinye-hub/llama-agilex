#!/usr/bin/env bash
# Questa simulation for LlamaM1Top — AXI4-Lite + DdrAgent + RmsNormAxiTop with real Quartus FP IPs.
#
# Prerequisites:
#   source <repo>/activate.sh        (quartus + questacoreprime)
#   make verilog (from src/scala/top) → top/gen/verilog/LlamaM1Top.v
#   make questa                      (or ./run.sh m1)
#   tools/ddr_pack/out/ddr_image_m1.bin
#   simlib at simlib/quartus2025_1_1_agilex5_questa2024_3/
#
# Usage:
#   ./run.sh compile
#   ./run.sh m1
#   QUESTA_WAVE=1 ./run.sh m1      # writes work/tb_llama_m1_top.wlf

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LLAMA_M1_QUESTA_DIR="$SCRIPT_DIR"
TOP_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$TOP_DIR/../../.." && pwd)"
MODE="${1:-m1}"

if [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  source "$REPO_ROOT/set_env.sh"
fi

if ! command -v vsim >/dev/null 2>&1; then
  echo "vsim not in PATH — load questacoreprime module first." >&2
  exit 1
fi

GEN_V="$TOP_DIR/gen/verilog/LlamaM1Top.v"
if [[ ! -f "$GEN_V" ]]; then
  echo "Missing $GEN_V — run: cd $TOP_DIR && make verilog" >&2
  exit 1
fi

DDR_IMAGE="${DDR_IMAGE:-$REPO_ROOT/tools/ddr_pack/out/ddr_image_m1.bin}"
DDR_IMAGE="$(cd "$(dirname "$DDR_IMAGE")" && pwd)/$(basename "$DDR_IMAGE")"
export DDR_IMAGE
if [[ ! -f "$DDR_IMAGE" ]]; then
  echo "Missing DDR image $DDR_IMAGE — run: make -C $REPO_ROOT/tools/ddr_pack pack-m1" >&2
  exit 1
fi

cd "$SCRIPT_DIR"

case "$MODE" in
  compile)
    vsim -c -do "$SCRIPT_DIR/run_compile.do"
    ;;
  m1)
    vsim -c -do "$SCRIPT_DIR/run_m1.do"
    ;;
  *)
    echo "Usage: $0 {compile|m1}" >&2
    exit 1
    ;;
esac
