#!/usr/bin/env bash
# Questa smoke test for fp32Exp + fp32Div Spinal adapters.
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export UTIL_QUESTA_DIR="$SCRIPT_DIR"
UTIL_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$UTIL_DIR/../../.." && pwd)"
MODE="${1:-exp_div}"

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

GEN_V="$UTIL_DIR/gen/verilog/Fp32ExpDivSmokeTop.v"
if [[ ! -f "$GEN_V" ]]; then
  echo "Missing $GEN_V — run: cd $UTIL_DIR && make verilog" >&2
  exit 1
fi

SIMLIB="$REPO_ROOT/simlib/quartus2025_1_1_agilex5_questa2024_3/questa_device_mapping.tcl"
if [[ ! -f "$SIMLIB" ]]; then
  echo "Missing simlib: $SIMLIB" >&2
  exit 1
fi

cd "$SCRIPT_DIR"

case "$MODE" in
  compile)
    vsim -c -do "$SCRIPT_DIR/run_compile.do"
    ;;
  exp_div)
    vsim -c -do "$SCRIPT_DIR/run_exp_div.do"
    ;;
  *)
    echo "Usage: $0 {compile|exp_div}" >&2
    exit 1
    ;;
esac
