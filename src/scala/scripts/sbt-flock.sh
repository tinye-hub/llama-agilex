#!/usr/bin/env bash
# Wrap sbt with flock — parallel regression jobs share NFS project/target.
# Installed on PATH ahead of real sbt by sim-matrix-job.sh (see sim-matrix-batch-env.sh).
set -euo pipefail

repo_root="${LLAMA_REPO_ROOT:?LLAMA_REPO_ROOT unset}"
lock="${repo_root}/.cache/sbt.lock"
real_sbt="${SBT_REAL:-sbt}"

mkdir -p "${repo_root}/.cache"
exec flock -w 7200 "$lock" "$real_sbt" "$@"
