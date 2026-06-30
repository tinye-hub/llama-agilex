#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SOFTMAX_QUESTA_DIR="$SCRIPT_DIR"
SOFTMAX_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$SOFTMAX_DIR/../../../.." && pwd)"
MODE="${1:-axi}"
CASE="${SOFTMAX_CASE:-len16}"

if [[ -f "$REPO_ROOT/activate.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/activate.sh"
elif [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/set_env.sh"
fi

if ! command -v vsim >/dev/null 2>&1; then
  echo "vsim not in PATH" >&2
  exit 1
fi

GEN_V="$SOFTMAX_DIR/gen/verilog/SerialSafeSoftmaxAxiTop.v"
if [[ ! -f "$GEN_V" ]]; then
  echo "Missing $GEN_V — run: make verilog" >&2
  exit 1
fi

GOLDEN_SRC="$SCRIPT_DIR/golden_refs/$CASE"
GOLDEN_WORK="$SCRIPT_DIR/work/golden_refs"
if [[ ! -d "$GOLDEN_SRC" ]]; then
  echo "Missing golden case $GOLDEN_SRC — run: make golden" >&2
  exit 1
fi
mkdir -p "$SCRIPT_DIR/work"
rm -rf "$GOLDEN_WORK"
cp -a "$GOLDEN_SRC" "$GOLDEN_WORK"

export SOFTMAX_CASE="$CASE"
cd "$SCRIPT_DIR"
case "$MODE" in
  compile) vsim -c -do "$SCRIPT_DIR/run_compile.do" ;;
  axi)     vsim -c -do "$SCRIPT_DIR/run_axi.do" ;;
  *)       echo "Usage: $0 {compile|axi}" >&2; exit 1 ;;
esac
