#!/usr/bin/env bash
# Questa simulation for DdrAgent M1 / M2a (generated Verilog + file-backed AXI DDR).
#
# Usage:
#   ./run.sh compile-m1 | compile-m2a
#   ./run.sh m1 | m2a
#   QUESTA_WAVE=1 ./run.sh m2a

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

cd "$SCRIPT_DIR"

case "$MODE" in
  compile-m1)
    GEN_V="$DDR_AGENT_DIR/gen/verilog/DdrAgentM1.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $DDR_AGENT_DIR && make verilog-m1" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_compile.do"
    ;;
  compile-m2a)
    GEN_V="$DDR_AGENT_DIR/gen/verilog/DdrAgentM2.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $DDR_AGENT_DIR && make verilog-m2a" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_compile_m2a.do"
    ;;
  m1)
    GEN_V="$DDR_AGENT_DIR/gen/verilog/DdrAgentM1.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $DDR_AGENT_DIR && make verilog-m1" >&2
      exit 1
    fi
    DDR_IMAGE="${DDR_IMAGE:-$REPO_ROOT/tools/ddr_pack/out/ddr_image_m1.bin}"
    DDR_IMAGE="$(cd "$(dirname "$DDR_IMAGE")" && pwd)/$(basename "$DDR_IMAGE")"
    export DDR_IMAGE
    if [[ ! -f "$DDR_IMAGE" ]]; then
      echo "Missing DDR image $DDR_IMAGE — run: make -C $REPO_ROOT/tools/ddr_pack pack-m1" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_m1.do"
    ;;
  m2a)
    GEN_V="$DDR_AGENT_DIR/gen/verilog/DdrAgentM2.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $DDR_AGENT_DIR && make verilog-m2a" >&2
      exit 1
    fi
    DDR_IMAGE="${DDR_IMAGE:-$REPO_ROOT/tools/ddr_pack/out/ddr_fixture.bin}"
    DDR_IMAGE="$(cd "$(dirname "$DDR_IMAGE")" && pwd)/$(basename "$DDR_IMAGE")"
    export DDR_IMAGE
    if [[ ! -f "$DDR_IMAGE" ]]; then
      echo "Missing DDR image $DDR_IMAGE — run: make -C $REPO_ROOT/tools/ddr_pack fixture" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_m2a.do"
    ;;
  compile)
    echo "Usage: $0 compile-m1 | compile-m2a (legacy 'compile' -> compile-m1)" >&2
    exec "$0" compile-m1
    ;;
  *)
    echo "Usage: $0 {compile-m1|compile-m2a|m1|m2a}" >&2
    exit 1
    ;;
esac
