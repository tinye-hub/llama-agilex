#!/usr/bin/env bash
# Questa simulation for LlamaM1Top / LlamaM2aTop.
#
# Usage:
#   ./run.sh compile-m1 | compile-m2a
#   ./run.sh m1 | m2a

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

cd "$SCRIPT_DIR"

case "$MODE" in
  compile-m1)
    GEN_V="$TOP_DIR/gen/verilog/LlamaM1Top.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $TOP_DIR && make verilog" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_compile.do"
    ;;
  compile-m2a)
    GEN_V="$TOP_DIR/gen/verilog/LlamaM2aTop.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $TOP_DIR && make verilog-m2a" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_compile_m2a.do"
    ;;
  m1)
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
    vsim -c -do "$SCRIPT_DIR/run_m1.do"
    ;;
  m2a)
    GEN_V="$TOP_DIR/gen/verilog/LlamaM2aTop.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $TOP_DIR && make verilog-m2a" >&2
      exit 1
    fi
    DDR_IMAGE="${DDR_IMAGE:-$REPO_ROOT/tools/ddr_pack/out/ddr_image.bin}"
    DDR_IMAGE="$(cd "$(dirname "$DDR_IMAGE")" && pwd)/$(basename "$DDR_IMAGE")"
    export DDR_IMAGE
    if [[ ! -f "$DDR_IMAGE" ]]; then
      echo "Missing DDR image $DDR_IMAGE — run: make -C $REPO_ROOT/tools/ddr_pack pack" >&2
      exit 1
    fi
    export LLAMA_M2A_DIM="${LLAMA_M2A_DIM:-2048}"
    export LLAMA_M2A_M="${LLAMA_M2A_M:-2048}"
    vsim -c -do "$SCRIPT_DIR/run_m2a.do"
    ;;
  compile)
    exec "$0" compile-m1
    ;;
  *)
    echo "Usage: $0 {compile-m1|compile-m2a|m1|m2a}" >&2
    exit 1
    ;;
esac
