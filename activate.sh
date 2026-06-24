#!/usr/bin/env bash
# Unified development environment for llama-agilex.
#
# Usage (must source, not execute):
#   source activate.sh
#   . activate.sh
#
# Replaces:
#   source ../apps/oss-cad-suite/environment
#   source set_env.sh
#   source env.sh

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "You must source this script: source ${0#$PWD/}" >&2
  exit 1
fi

_REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_APPS_ROOT="/userworkqum/tinye/apps"

# 1. Java / sbt / coursier (was: env.sh → apps/env.sh)
if [[ -f "$_APPS_ROOT/env.sh" ]]; then
  source "$_APPS_ROOT/env.sh"
else
  echo "activate.sh: missing $_APPS_ROOT/env.sh" >&2
  return 1 2>/dev/null || exit 1
fi

# 2. Quartus / Questa modules + NC_RUN (was: set_env.sh)
if [[ -f "$_REPO_ROOT/set_env.sh" ]]; then
  source "$_REPO_ROOT/set_env.sh"
else
  echo "activate.sh: missing $_REPO_ROOT/set_env.sh" >&2
  return 1 2>/dev/null || exit 1
fi

# 3. OSS CAD Suite — Verilator, yosys, etc. (was: env.sh tail + manual oss-cad source)
if [[ -f "$_APPS_ROOT/oss-cad-suite/environment" ]]; then
  source "$_APPS_ROOT/oss-cad-suite/environment"
else
  echo "activate.sh: missing $_APPS_ROOT/oss-cad-suite/environment" >&2
  return 1 2>/dev/null || exit 1
fi

unset _REPO_ROOT _APPS_ROOT
