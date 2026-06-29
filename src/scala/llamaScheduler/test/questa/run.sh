#!/usr/bin/env bash
# Questa simulation for LlamaSchedulerM1 (generated Verilog + mock MemCmd/MemDone).
#
# Usage:
#   ./run.sh compile
#   ./run.sh m1
#   QUESTA_WAVE=1 ./run.sh m1

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LLAMA_SCHED_QUESTA_DIR="$SCRIPT_DIR"
SCHED_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$SCHED_DIR/../../.." && pwd)"
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
  compile)
    GEN_V="$SCHED_DIR/gen/verilog/LlamaSchedulerM1.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $SCHED_DIR && make verilog" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_compile.do"
    ;;
  m1)
    GEN_V="$SCHED_DIR/gen/verilog/LlamaSchedulerM1.v"
    if [[ ! -f "$GEN_V" ]]; then
      echo "Missing $GEN_V — run: cd $SCHED_DIR && make verilog" >&2
      exit 1
    fi
    vsim -c -do "$SCRIPT_DIR/run_m1.do"
    ;;
  *)
    echo "Usage: $0 {compile|m1}" >&2
    exit 1
    ;;
esac
