#!/usr/bin/env bash
# Questa simulation for DdrAgentM1 (generated Verilog + file-backed AXI DDR).
#
# Prerequisites:
#   source <repo>/set_env.sh   (questacoreprime)
#   make questa                  (verilog + sim)
#
# Usage:
#   ./run.sh compile
#   ./run.sh m1
#   QUESTA_WAVE=1 ./run.sh m1          # writes work/tb_ddr_agent_m1.wlf
#   DDR_IMAGE=/path/to.bin ./run.sh m1

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DDR_AGENT_QUESTA_DIR="$SCRIPT_DIR"
DDR_AGENT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$DDR_AGENT_DIR/../../.." && pwd)"
MODE="${1:-m1}"

if [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/set_env.sh"
fi

if ! command -v vsim >/dev/null 2>&1; then
  echo "vsim not in PATH — load questacoreprime module first." >&2
  exit 1
fi

GEN_V="$DDR_AGENT_DIR/gen/verilog/DdrAgentM1.v"
if [[ ! -f "$GEN_V" ]]; then
  echo "Missing $GEN_V — run: cd $DDR_AGENT_DIR && make verilog" >&2
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
