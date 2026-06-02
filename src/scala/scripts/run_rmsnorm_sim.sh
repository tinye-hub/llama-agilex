#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export RMSNORM_SIM_DIM="${RMSNORM_SIM_DIM:-16}"
echo "RMSNORM_SIM_DIM=$RMSNORM_SIM_DIM"
sbt -batch "runMain rmsNorm.RmsNormCoreSim"
sbt -batch "runMain rmsNorm.RmsNormAxiTopSim"
