#!/usr/bin/env bash
# Questa simulation for GemvService64 / GemvMacBeat + Quartus FP IPs.
#
# Prerequisites:
#   source <repo>/set_env.sh          (quartus + questacoreprime)
#   make verilog-mac / make verilog   (from src/scala/gemvService64)
#   simlib compiled at simlib/quartus2025_1_1_agilex5_questa2024_3
#
# Usage:
#   ./run.sh compile                  # compile IP + DUT + TB (GEMV_DUT=mac default)
#   ./run.sh mac                      # GemvMacBeat FP golden
#   ./run.sh service                  # GemvService64 INT4 GEMV FP golden
#   GEMV_K=2048 GEMV_M=2048 ./run.sh service   # Llama 3.2 1B W_Q
#   QUESTA_WAVE=1 ./run.sh mac        # writes work/<tb>.wlf

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GEMV_QUESTA_DIR="$SCRIPT_DIR"
GEMV_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$GEMV_DIR/../../.." && pwd)"
MODE="${1:-mac}"

if [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/set_env.sh"
fi

if ! command -v vsim >/dev/null 2>&1; then
  echo "vsim not in PATH — load questacoreprime and quartus modules first." >&2
  exit 1
fi

SIMLIB="$REPO_ROOT/simlib/quartus2025_1_1_agilex5_questa2024_3/questa_device_mapping.tcl"
if [[ ! -f "$SIMLIB" ]]; then
  echo "Missing device simlib: $SIMLIB" >&2
  exit 1
fi

cd "$SCRIPT_DIR"

case "$MODE" in
  compile)
    export GEMV_DUT="${GEMV_DUT:-mac}"
    vsim -c -do "$SCRIPT_DIR/run_compile.do"
    ;;
  mac)
    export GEMV_DUT=mac
    vsim -c -do "$SCRIPT_DIR/run_sim.do"
    ;;
  service)
    export GEMV_DUT=service
    vsim -c -do "$SCRIPT_DIR/run_sim.do"
    ;;
  *)
    echo "Usage: $0 {compile|mac|service}" >&2
    exit 1
    ;;
esac
