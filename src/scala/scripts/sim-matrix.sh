#!/usr/bin/env bash
# Run verilator / questa across Spinal modules; print a PASS/FAIL summary table.
# Invoked from src/scala/Makefile:  make verilator | make questa | make sim
set -uo pipefail

usage() {
  echo "usage: sim-matrix.sh <verilator|questa|sim>" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
MODE="$1"
case "$MODE" in
  verilator|questa|sim) ;;
  *) usage ;;
esac

SCALA_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$SCALA_ROOT/../.." && pwd)"
DDR_IMAGE="${DDR_IMAGE:-$REPO_ROOT/tools/ddr_pack/out/ddr_image_m1.bin}"
MAKE="${MAKE:-make}"

PASS_RE='\*{10} PASS \*{10}'
FAIL_RE='\*{10} FAIL \*{10}'

declare -a SUMMARY=()
FAIL_COUNT=0
PASS_COUNT=0
SKIP_COUNT=0

strip_ansi() {
  sed -E 's/\x1b\[[0-9;]*[a-zA-Z]//g'
}

count_banner() {
  local log="$1" kind="$2"
  strip_ansi <"$log" | grep -Ec "$kind" || true
}

color_result() {
  local res="$1"
  case "$res" in
    PASS) printf '\033[32m%-8s\033[0m' "$res" ;;
    FAIL) printf '\033[31m%-8s\033[0m' "$res" ;;
    SKIP) printf '\033[33m%-8s\033[0m' "$res" ;;
    *)    printf '%-8s' "$res" ;;
  esac
}

record() {
  local mod="$1" label="$2" res="$3" notes="$4"
  SUMMARY+=("${mod}|${label}|${res}|${notes}")
  case "$res" in
    PASS) PASS_COUNT=$((PASS_COUNT + 1)) ;;
    FAIL) FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
    SKIP) SKIP_COUNT=$((SKIP_COUNT + 1)) ;;
  esac
}

run_make() {
  local mod="$1" make_target="$2" display_target="$3"
  local dir="$SCALA_ROOT/$mod"
  local log
  log="$(mktemp "${TMPDIR:-/tmp}/sim-matrix.XXXXXX")"

  echo ""
  echo "================================================================"
  echo "  $mod: make $make_target  (reported as: $display_target)"
  echo "================================================================"

  local rc=0
  if ! (cd "$dir" && "$MAKE" "$make_target") >"$log" 2>&1; then
    rc=$?
  fi
  cat "$log"

  local pass fail res notes
  pass="$(count_banner "$log" "$PASS_RE")"
  fail="$(count_banner "$log" "$FAIL_RE")"

  if (( fail > 0 )) || (( rc != 0 )); then
    res=FAIL
    notes="exit=$rc"
    if (( pass > 0 )); then
      notes="${notes}, ${pass}×PASS"
    fi
    if (( fail > 0 )); then
      notes="${notes}, ${fail}×FAIL"
    fi
  elif (( pass > 0 )); then
    res=PASS
    if (( pass > 1 )); then
      notes="${pass}×PASS banner"
    else
      notes=""
    fi
  elif (( rc == 0 )); then
    res=PASS
    notes="exit 0, no banner"
  else
    res=FAIL
    notes="exit=$rc, no banner"
  fi

  record "$mod" "$display_target" "$res" "$notes"
  rm -f "$log"
}

run_verilator_suite() {
  run_make rmsNorm verilator verilator
  run_make ddrAgent verilator verilator
  run_make top verilator verilator
  run_make llamaScheduler verilator verilator
}

run_questa_suite() {
  if [[ ! -f "$DDR_IMAGE" ]]; then
    echo "WARNING: missing $DDR_IMAGE"
    echo "         run: make -C $REPO_ROOT/tools/ddr_pack pack-m1"
    echo ""
  fi
  run_make rmsNorm questa questa
  run_make ddrAgent questa questa
  run_make top questa questa
  record llamaScheduler questa SKIP "no Questa TB"
}

print_summary() {
  local title="$1"
  echo ""
  echo "================================================================"
  echo "  $title"
  echo "================================================================"
  printf "%-18s %-12s %-8s %s\n" "Module" "Target" "Result" "Notes"
  printf "%-18s %-12s %-8s %s\n" "------------------" "------------" "--------" "-----"
  local row mod label res notes
  for row in "${SUMMARY[@]}"; do
    IFS='|' read -r mod label res notes <<<"$row"
    printf "%-18s %-12s " "$mod" "$label"
    color_result "$res"
    printf " %s\n" "$notes"
  done
  echo ""
  printf "Totals: %d PASS, %d FAIL" "$PASS_COUNT" "$FAIL_COUNT"
  if (( SKIP_COUNT > 0 )); then
    printf ", %d SKIP" "$SKIP_COUNT"
  fi
  echo ""
}

case "$MODE" in
  verilator)
    run_verilator_suite
    print_summary "Verilator regression summary"
    ;;
  questa)
    run_questa_suite
    print_summary "Questa regression summary"
    ;;
  sim)
    run_verilator_suite
    run_questa_suite
    print_summary "Full simulation summary (verilator + questa)"
    ;;
esac

if (( FAIL_COUNT > 0 )); then
  exit 1
fi
exit 0
