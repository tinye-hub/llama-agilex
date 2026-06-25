#!/usr/bin/env bash
# Batch-node environment for sim-matrix nc jobs (Verilator/sbt + Questa).
#
# 1) NC SNAPSHOT may set XDG_RUNTIME_DIR=/run/user/<uid> (missing on batch).
# 2) Parallel jobs on one host need distinct sbt boot sockets (EADDRINUSE).
# 3) AF_UNIX socket paths must be <= ~108 bytes — repo paths are too long.
#
# Use short per-job dirs under batch-node /tmp for runtime + sbt boot sockets.
# Ivy/coursier caches stay on shared repo .cache/ for reuse across jobs.
sim_matrix_batch_env() {
  local repo_root="${1:?repo_root required}"
  local job_tag="${2:?job_tag required}"

  local id local_root
  id="$(printf '%s' "$job_tag" | md5sum | awk '{print substr($1,1,8)}')"
  local_root="/tmp/sm-${id}-$$"

  unset XDG_RUNTIME_DIR
  export XDG_RUNTIME_DIR="${local_root}/rt"
  export TMPDIR="${local_root}/tmp"
  export SBT_TMPDIR="${local_root}/stmp"
  mkdir -p "$XDG_RUNTIME_DIR" "$TMPDIR" "$SBT_TMPDIR"
  chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null || true

  export SIM_MATRIX_LOCAL_ROOT="$local_root"

  export SBT_OPTS="-Dsbt.boot.directory=${local_root}/boot -Dsbt.global.base=${local_root}/g -Dsbt.supershell=false -Dsbt.ivy.home=${repo_root}/.cache/ivy -Dsbt.coursier.home=${repo_root}/.cache/coursier"
  export JAVA_TOOL_OPTIONS="-Djava.io.tmpdir=${TMPDIR}"

  export COURSIER_CACHE="${repo_root}/.cache/coursier"
}

# Put flock-wrapped sbt first on PATH (parallel jobs must not write project/target concurrently).
sim_matrix_install_sbt_shim() {
  local repo_root="${1:?repo_root required}"
  local shim_dir="${2:?shim_dir required}"
  local scripts_dir="${3:?scripts_dir required}"

  mkdir -p "$shim_dir"
  export LLAMA_REPO_ROOT="$repo_root"
  export SBT_REAL="$(command -v sbt)"
  ln -sf "${scripts_dir}/sbt-flock.sh" "${shim_dir}/sbt"
  export PATH="${shim_dir}:${PATH}"
}

sim_matrix_batch_cleanup() {
  [[ -n "${SIM_MATRIX_LOCAL_ROOT:-}" ]] && rm -rf "$SIM_MATRIX_LOCAL_ROOT"
}
