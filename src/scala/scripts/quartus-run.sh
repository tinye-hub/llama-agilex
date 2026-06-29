#!/usr/bin/env bash
# Submit or run Quartus Prime from a module quartus/ directory.
#
# Usage:
#   quartus-run.sh <quartus-project-dir> [quartus_sh args...]
#
# After `source activate.sh`, NC_RUN submits to batch (32GB / 8 cores). The
# worker runs quartus-batch.sh, which re-sources set_env.sh — same as Questa
# run.sh — so Quartus ICU libs resolve on batch nodes.
#
# Local on login node (no nc):  NC_RUN= make quartus-m2a-all
# Agent (no prior activate):    make quartus-m2a-all  (this script sources set_env.sh)

set -eo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $(basename "$0") <quartus-project-dir> [quartus_sh args...]" >&2
  exit 1
fi

QUARTUS_DIR="$(cd "$1" && pwd)"
shift

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BATCH="$SCRIPT_DIR/quartus-batch.sh"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

if [[ ! -x "$BATCH" ]]; then
  echo "quartus-run.sh: missing $BATCH" >&2
  exit 1
fi

if [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/set_env.sh"
else
  echo "quartus-run.sh: missing $REPO_ROOT/set_env.sh" >&2
  exit 1
fi

# Fail-fast on submitter before nc wait (module + license on login node).
if ! quartus_sh --version >/dev/null 2>&1; then
  echo "quartus-run.sh: quartus_sh failed on submitter (libicui18n? re-source set_env.sh)" >&2
  exit 1
fi

if [[ -z "${NC_RUN}" ]]; then
  exec "$BATCH" "$QUARTUS_DIR" "$@"
fi

# shellcheck disable=SC2086
exec ${NC_RUN} "$BATCH" "$QUARTUS_DIR" "$@"
