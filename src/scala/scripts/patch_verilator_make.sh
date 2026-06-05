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
  sed -i '/VRmsNormAxiTop__Syms\.h/a #include "verilated.h"\nusing WData = EData;' "$f"
}

if [[ -n "$BUILD_DIR" ]]; then
  for f in \
    "${BUILD_DIR}/VRmsNormAxiTop__spinalWrapper.cpp" \
    "${BUILD_DIR}/../verilator/VRmsNormAxiTop__spinalWrapper.cpp" \
    "${BUILD_DIR}/verilator/VRmsNormAxiTop__spinalWrapper.cpp"
  do
    patch_wrapper "$f"
  done
fi

exec "$REAL_MAKE" "${args[@]}"
