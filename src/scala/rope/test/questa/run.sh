#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROPE_QUESTA_DIR="$SCRIPT_DIR"
ROPE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$ROPE_DIR/../../.." && pwd)"
MODE="${1:-axi}"

if [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/set_env.sh"
fi

if ! command -v vsim >/dev/null 2>&1; then
  echo "vsim not in PATH" >&2
  exit 1
fi

GEN_V="$REPO_ROOT/src/scala/rope/gen/verilog/SerialRoPEAxiTop.v"
if [[ ! -f "$GEN_V" ]]; then
  echo "Missing $GEN_V — run: make verilog" >&2
  exit 1
fi

cd "$SCRIPT_DIR"
case "$MODE" in
  compile) vsim -c -do "$SCRIPT_DIR/run_compile.do" ;;
  axi)     vsim -c -do "$SCRIPT_DIR/run_axi.do" ;;
  *)       echo "Usage: $0 {compile|axi}" >&2; exit 1 ;;
esac
