#!/usr/bin/env bash
# SpinalHDL Verilator sim: patch JNI wrapper for Verilator 5.036+ (no WData typedef), then run make.
set -euo pipefail
# Must not use bare `make` — scripts/make may be first on PATH.
REAL_MAKE="${VERILATOR_REAL_MAKE:-/usr/bin/make}"
BUILD_DIR=""
args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -C)
      BUILD_DIR="$2"
      args+=("$1" "$2")
      shift 2
      ;;
    *)
      args+=("$1")
      shift
      ;;
  esac
done

patch_wrapper() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  if grep -q 'using WData = EData' "$f"; then
    return 0
  fi
  sed -i '/#include "verilated.h"/a using WData = EData;' "$f" 2>/dev/null || true
  if ! grep -q 'using WData = EData' "$f"; then
    sed -i '1a #include "verilated.h"\nusing WData = EData;' "$f"
  fi
}

if [[ -n "$BUILD_DIR" ]]; then
  while IFS= read -r -d '' f; do
    patch_wrapper "$f"
  done < <(find "${BUILD_DIR}" -name '*__spinalWrapper.cpp' -print0 2>/dev/null)
fi

exec "$REAL_MAKE" "${args[@]}"
