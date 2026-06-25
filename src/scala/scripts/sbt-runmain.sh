#!/usr/bin/env bash
# Run a Spinal sim App via sbt; print Questa-style colored PASS/FAIL on the shell terminal.
# Used by module Makefiles:  make verilator  →  scripts/sbt-runmain.sh package.Main
# Policy: doc/simulation-conventions.md
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: sbt-runmain.sh <package.Main> [sbt extra args...]" >&2
  exit 2
fi

MAIN="$1"
shift

SCALA_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCALA_ROOT"

if sbt -batch "runMain ${MAIN}" "$@"; then
  printf '\033[32m********** PASS **********\033[0m\n'
else
  printf '\033[31m********** FAIL **********\033[0m\n'
  exit 1
fi
