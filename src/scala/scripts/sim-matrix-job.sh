#!/usr/bin/env bash
# Run one module make target inside an nc batch job.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: sim-matrix-job.sh <module> <make_target>" >&2
  exit 2
fi

MOD="$1"
TARGET="$2"

SCALA_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$SCALA_ROOT/../.." && pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
JOB_TAG="${SIM_MATRIX_JOB_TAG:-${MOD}-${TARGET}-$$}"

# shellcheck source=sim-matrix-batch-env.sh
source "$SCRIPT_DIR/sim-matrix-batch-env.sh"
sim_matrix_batch_env "$REPO_ROOT" "$JOB_TAG"
sim_matrix_install_sbt_shim "$REPO_ROOT" "${SIM_MATRIX_LOCAL_ROOT}/bin" "$SCRIPT_DIR"
trap sim_matrix_batch_cleanup EXIT

export PATH="$SCALA_ROOT/scripts:$PATH"
export VERILATOR_REAL_MAKE=/usr/bin/make
export DDR_IMAGE="${DDR_IMAGE:-$REPO_ROOT/tools/ddr_pack/out/ddr_image_m1.bin}"
export DDR_AGENT_AXI_WIDTH="${DDR_AGENT_AXI_WIDTH:-256}"
export LLAMA_M2A_DIM="${LLAMA_M2A_DIM:-2048}"
export LLAMA_M2A_M="${LLAMA_M2A_M:-4}"
export NC_RUN=
export NC_RUN_GUI=

echo "[sim-matrix-job] host=$(hostname) mod=$MOD target=$TARGET job=$JOB_TAG"
echo "[sim-matrix-job] local=${SIM_MATRIX_LOCAL_ROOT} ivy=${REPO_ROOT}/.cache/ivy"

cd "$SCALA_ROOT/$MOD"
make "$TARGET"
