#!/usr/bin/env bash
# Questa simulation for RmsNormAxiTop + Quartus FP IPs.
#
# Prerequisites:
#   source <repo>/set_env.sh   (quartus + questacoreprime)
#   make questa-axi            (verilog + sim, dim=2048)
#   simlib compiled at simlib/quartus2025_1_1_agilex5_questa2024_3
#
# Usage:
#   ./run.sh compile
#   ./run.sh axi
#   QUESTA_WAVE=1 ./run.sh axi          # writes work/tb_rmsnorm_axi.wlf
#   QUESTA_WLF=/path/to/custom.wlf QUESTA_WAVE=1 ./run.sh axi

# -u off: Questa/module env may reference unset vars (e.g. TCLSH) under nc.
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export RMSNORM_QUESTA_DIR="$SCRIPT_DIR"
RMSNORM_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$RMSNORM_DIR/../../.." && pwd)"
MODE="${1:-axi}"

if [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/set_env.sh"
fi

if ! command -v vsim >/dev/null 2>&1; then
  echo "vsim not in PATH — load questacoreprime and quartus modules first." >&2
  exit 1
fi

GEN_V="$REPO_ROOT/src/scala/rmsNorm/gen/verilog/RmsNormAxiTop.v"
if [[ ! -f "$GEN_V" ]]; then
  echo "Missing $GEN_V — run: cd $REPO_ROOT/src/scala/rmsNorm && make verilog" >&2
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
    vsim -c -do "$SCRIPT_DIR/run_compile.do"
    ;;
  axi)
    vsim -c -do "$SCRIPT_DIR/run_axi.do"
    ;;
  *)
    echo "Usage: $0 {compile|axi}" >&2
    exit 1
    ;;
esac
