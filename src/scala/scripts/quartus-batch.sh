#!/usr/bin/env bash
# Run quartus_sh on the current node (login or nc batch worker).
# Invoked by quartus-run.sh — re-sources set_env.sh so module load restores
# Quartus LD_LIBRARY_PATH (libicui18n.so.69) on batch nodes where nc SNAPSHOT
# env alone is insufficient. Same pattern as test/questa/run.sh for vsim.
#
# Usage: quartus-batch.sh <quartus-project-dir> [quartus_sh args...]

set -eo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $(basename "$0") <quartus-project-dir> [quartus_sh args...]" >&2
  exit 1
fi

QUARTUS_DIR="$(cd "$1" && pwd)"
shift

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

if [[ -f "$REPO_ROOT/set_env.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/set_env.sh"
else
  echo "quartus-batch.sh: missing $REPO_ROOT/set_env.sh" >&2
  exit 1
fi

# Already on batch — do not re-dispatch via nc.
NC_RUN=""
export NC_RUN

if ! command -v quartus_sh >/dev/null 2>&1; then
  echo "quartus-batch.sh: quartus_sh not in PATH after set_env.sh (host=$(hostname))" >&2
  exit 1
fi

cd "$QUARTUS_DIR"
exec quartus_sh "$@"
