#!/usr/bin/env bash
set -euo pipefail
SCALA_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCALA_ROOT"

export PATH="${SCALA_ROOT}/scripts:${OSS_CAD_SUITE:-/userworkqum/tinye/apps/oss-cad-suite}/bin:${PATH}"
export RMSNORM_SIM_DIM="${RMSNORM_SIM_DIM:-16}"
unset SPINAL_VERILATOR_FLAGS
export VERILATOR_REAL_MAKE="${VERILATOR_REAL_MAKE:-/usr/bin/make}"

echo "RMSNORM_SIM_DIM=$RMSNORM_SIM_DIM"
command -v verilator >/dev/null && verilator --version | head -1 || true

make -C rmsNorm sim SIM_DIM="$RMSNORM_SIM_DIM"
