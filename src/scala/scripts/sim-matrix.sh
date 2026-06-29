#!/usr/bin/env bash
# Run verilator / questa across Spinal modules; print a PASS/FAIL summary table.
#
# Serial (default):  scripts/sim-matrix.sh <verilator|questa|sim>
#
# Parallel (batch):  PARALLEL=1 scripts/sim-matrix.sh <verilator|questa|sim>
#   One background nc job per module (NC_RUN_BG / Taskerlist:b 4GB 4 cores),
#   then nc wait, harvest logs under src/scala/out/logs/<run_id>/.
set -uo pipefail

usage() {
  echo "usage: sim-matrix.sh <verilator|questa|sim>" >&2
  echo "  PARALLEL=1   all targets via background nc run (NC_RUN_BG), then nc wait" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
MODE="$1"
case "$MODE" in
  verilator|questa|sim) ;;
  *) usage ;;
esac

PARALLEL="${PARALLEL:-0}"
SCALA_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$SCALA_ROOT/../.." && pwd)"
SCRIPTS="$SCALA_ROOT/scripts"
DDR_IMAGE="${DDR_IMAGE:-$REPO_ROOT/tools/ddr_pack/out/ddr_image_m1.bin}"
MAKE="${MAKE:-make}"
NC_RUN_BG="${NC_RUN_BG:-}"

PASS_RE='\*{10} PASS \*{10}'
FAIL_RE='\*{10} FAIL \*{10}'

declare -a SUMMARY=()
declare -a PAR_JOBS=()   # mod|make_target|display|log|jobid
FAIL_COUNT=0
PASS_COUNT=0
SKIP_COUNT=0

LOG_DIR=""
MANIFEST=""

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

parse_job_id() {
  sed -n 's/.*JobId[[:space:]]*=[[:space:]]*//p' | tr -d '[:space:]'
}

nc_job_status() {
  local jid="$1"
  nc info "$jid" 2>/dev/null | awk '/^Status[[:space:]]/{print $2; exit}'
}

evaluate_result() {
  local mod="$1" label="$2" log="$3" rc="${4:-0}" nc_status="${5:-}"

  local pass fail res notes
  pass=0
  fail=0
  if [[ -f "$log" ]]; then
    pass="$(count_banner "$log" "$PASS_RE")"
    fail="$(count_banner "$log" "$FAIL_RE")"
  fi

  if [[ "$nc_status" == Failed ]]; then
    res=FAIL
    notes="nc=${nc_status}"
  elif (( fail > 0 )) || (( rc != 0 )); then
    res=FAIL
    notes="exit=$rc"
    [[ -n "$nc_status" ]] && notes="${notes}, nc=${nc_status}"
    (( pass > 0 )) && notes="${notes}, ${pass}×PASS"
    (( fail > 0 )) && notes="${notes}, ${fail}×FAIL"
  elif (( pass > 0 )); then
    res=PASS
    if (( pass > 1 )); then
      notes="${pass}×PASS banner"
    else
      notes=""
    fi
    [[ -n "$nc_status" && "$nc_status" != Done ]] && notes="${notes:+$notes, }nc=${nc_status}"
  elif (( rc == 0 )) && [[ "$nc_status" == Done || -z "$nc_status" ]]; then
    res=PASS
    notes="${nc_status:+nc=${nc_status}}${nc_status:+, }exit 0, no banner"
    notes="${notes#, }"
  else
    res=FAIL
    notes="exit=$rc"
    [[ -n "$nc_status" ]] && notes="${notes}, nc=${nc_status}"
  fi

  [[ -f "$log" ]] && notes="${notes:+$notes, }log=$(basename "$log")"
  record "$mod" "$label" "$res" "$notes"
}

init_log_dir() {
  local run_id
  run_id="$(date +%Y%m%d_%H%M%S)"
  LOG_DIR="$SCALA_ROOT/out/logs/run_${run_id}"
  MANIFEST="$LOG_DIR/manifest.tsv"
  mkdir -p "$LOG_DIR"
  ln -sfn "run_${run_id}" "$SCALA_ROOT/out/logs/latest"
  echo "Batch logs: $LOG_DIR"
  echo "  NC_RUN_BG: ${NC_RUN_BG:-<unset>}"
  echo "  manifest:  $MANIFEST"
  echo ""
}

run_make_serial() {
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
  evaluate_result "$mod" "$display_target" "$log" "$rc"
  rm -f "$log"
}

submit_nc_bg() {
  local mod="$1" make_target="$2" display_target="$3"
  local log="$LOG_DIR/${mod}-${display_target}.log"
  local jobname="sim-matrix-${mod}-${display_target}"
  local out jid

  echo "nc bg: $mod make $make_target"
  echo "  log: $log"
  echo "  cmd: bash $SCRIPTS/sim-matrix-job.sh $mod $make_target"

  if ! out=$($NC_RUN_BG -forcelog -F -l "$log" -J "$jobname" \
      env SIM_MATRIX_JOB_TAG="${mod}-${display_target}" \
      bash "$SCRIPTS/sim-matrix-job.sh" "$mod" "$make_target" 2>&1); then
    echo "$out"
    record "$mod" "$display_target" FAIL "nc submit failed"
    return
  fi

  jid="$(echo "$out" | parse_job_id)"
  if [[ -z "$jid" ]]; then
    echo "$out"
    record "$mod" "$display_target" FAIL "no JobId in nc output"
    return
  fi

  echo "  JobId=$jid"
  echo -e "${mod}\t${make_target}\t${display_target}\t${log}\t${jid}" >>"$MANIFEST"
  PAR_JOBS+=("${mod}|${make_target}|${display_target}|${log}|${jid}")
}

submit_verilator_jobs() {
  submit_nc_bg rmsNorm verilator verilator
  submit_nc_bg gemvService64 verilator verilator
  submit_nc_bg ddrAgent verilator verilator
  submit_nc_bg top verilator verilator
  submit_nc_bg llamaScheduler verilator verilator
}

submit_questa_jobs() {
  if [[ ! -f "$DDR_IMAGE" ]]; then
    echo "WARNING: missing $DDR_IMAGE"
    echo "         run: make -C $REPO_ROOT/tools/ddr_pack pack-m1"
    echo ""
  fi
  local m2a_ddr="$REPO_ROOT/tools/ddr_pack/out/ddr_image.bin"
  if [[ ! -f "$m2a_ddr" ]]; then
    echo "WARNING: missing $m2a_ddr (top questa-m2a)"
    echo "         run: make -C $REPO_ROOT/tools/ddr_pack pack"
    echo ""
  fi
  submit_nc_bg rmsNorm questa questa
  submit_nc_bg gemvService64 questa questa
  submit_nc_bg ddrAgent questa questa
  submit_nc_bg top questa questa
  submit_nc_bg top questa-m2a questa-m2a
  record llamaScheduler questa SKIP "no Questa TB"
}

wait_nc_jobs() {
  local -a jids=()
  local row mod _mt _dt log jid
  for row in "${PAR_JOBS[@]}"; do
    IFS='|' read -r mod _mt _dt log jid <<<"$row"
    jids+=("$jid")
  done

  if ((${#jids[@]} == 0)); then
    return
  fi

  local poll_ms="${NC_WAIT_POLL_MS:-5000}"
  local dot_sec="${NC_WAIT_DOT_SEC:-3}"

  echo ""
  echo "Submitted ${#jids[@]} nc job(s). Waiting: nc wait -q ${jids[*]}"
  echo "  running: ncjobs -r"
  echo "  done:    ncjobs -d -f"
  echo "  log:     nc info -l <JobId>"
  echo -n "  progress: "

  local wait_rc=0
  nc wait -q -poll "$poll_ms" "${jids[@]}" &
  local wait_pid=$!
  while kill -0 "$wait_pid" 2>/dev/null; do
    sleep "$dot_sec"
    printf '.'
  done
  wait "$wait_pid" || wait_rc=$?
  echo ""
  echo "nc wait finished (exit $wait_rc)"
}

harvest_nc_logs() {
  local row mod _mt display log jid status
  for row in "${PAR_JOBS[@]}"; do
    IFS='|' read -r mod _mt display log jid <<<"$row"
    status="$(nc_job_status "$jid")"
    echo ""
    echo "================================================================"
    echo "  $mod ($display)  JobId=$jid  nc Status=$status"
    echo "  log: $log"
    echo "================================================================"
    if [[ -f "$log" ]]; then
      cat "$log"
    else
      echo "WARNING: log file missing; fetching via nc info -l $jid"
      nc info -l "$jid" 2>/dev/null | tee "$log" || true
    fi
    local rc=0
    [[ "$status" == Failed ]] && rc=1
    evaluate_result "$mod" "$display" "$log" "$rc" "$status"
  done
}

# NC_RUN_BG comes from set_env.sh (via activate.sh). make regression may run without
# a prior manual source — load EDA modules here so nc snapshot is complete.
ensure_batch_env() {
  if [[ -n "${NC_RUN_BG:-}" ]] && command -v nc >/dev/null 2>&1; then
    return 0
  fi
  local activate="$REPO_ROOT/activate.sh"
  if [[ ! -f "$activate" ]]; then
    echo "PARALLEL=1 requires NC_RUN_BG; missing $activate" >&2
    exit 2
  fi
  echo "Sourcing $activate (NC_RUN_BG, Quartus/Questa modules)..."
  # shellcheck disable=SC1090
  source "$activate"
  NC_RUN_BG="${NC_RUN_BG:-}"
  export NC_RUN_BG
  if [[ -z "$NC_RUN_BG" ]]; then
    echo "PARALLEL=1: NC_RUN_BG still unset after activate.sh" >&2
    exit 2
  fi
  if ! command -v nc >/dev/null 2>&1; then
    echo "PARALLEL=1: nc not on PATH after activate.sh (need aap module)" >&2
    exit 2
  fi
}

run_nc_parallel() {
  ensure_batch_env
  init_log_dir
  PAR_JOBS=()

  echo "Pre-warming sbt project/ (login node, serial)..."
  (cd "$SCALA_ROOT" && sbt -batch "exit") || echo "WARNING: sbt warm-up failed" >&2
  echo ""

  case "$MODE" in
    verilator)
      submit_verilator_jobs
      ;;
    questa)
      submit_questa_jobs
      ;;
    sim)
      submit_verilator_jobs
      submit_questa_jobs
      ;;
  esac

  wait_nc_jobs
  harvest_nc_logs

  echo ""
  echo "Artifacts: $LOG_DIR"
}

run_verilator_suite() {
  run_make_serial rmsNorm verilator verilator
  run_make_serial gemvService64 verilator verilator
  run_make_serial ddrAgent verilator verilator
  run_make_serial top verilator verilator
  run_make_serial llamaScheduler verilator verilator
}

run_questa_suite_serial() {
  if [[ ! -f "$DDR_IMAGE" ]]; then
    echo "WARNING: missing $DDR_IMAGE"
    echo "         run: make -C $REPO_ROOT/tools/ddr_pack pack-m1"
    echo ""
  fi
  local m2a_ddr="$REPO_ROOT/tools/ddr_pack/out/ddr_image.bin"
  if [[ ! -f "$m2a_ddr" ]]; then
    echo "WARNING: missing $m2a_ddr (top questa-m2a)"
    echo "         run: make -C $REPO_ROOT/tools/ddr_pack pack"
    echo ""
  fi
  run_make_serial rmsNorm questa questa
  run_make_serial gemvService64 questa questa
  run_make_serial ddrAgent questa questa
  run_make_serial top questa questa
  run_make_serial top questa-m2a questa-m2a
  record llamaScheduler questa SKIP "no Questa TB"
}

print_summary() {
  local title="$1"
  local -a sorted=()
  local row mod label res notes

  if ((${#SUMMARY[@]} > 0)); then
    mapfile -t sorted < <(printf '%s\n' "${SUMMARY[@]}" | LC_ALL=C sort -t'|' -k1,1 -k2,2)
  fi

  echo ""
  echo "================================================================"
  echo "  $title"
  echo "================================================================"
  printf "%-18s %-12s %-8s %s\n" "Module" "Target" "Result" "Notes"
  printf "%-18s %-12s %-8s %s\n" "------------------" "------------" "--------" "-----"
  for row in "${sorted[@]}"; do
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

summary_title() {
  case "$MODE" in
    verilator) echo "Verilator regression summary" ;;
    questa)    echo "Questa regression summary" ;;
    sim)       echo "Full simulation summary (verilator + questa)" ;;
  esac
}

parallel_suffix() {
  [[ "$PARALLEL" == 1 ]] && echo " [PARALLEL=1: NC_RUN_BG]" || echo ""
}

# --- main ---

if [[ "$PARALLEL" == 1 ]]; then
  run_nc_parallel
else
  case "$MODE" in
    verilator) run_verilator_suite ;;
    questa)    run_questa_suite_serial ;;
    sim)
      run_verilator_suite
      run_questa_suite_serial
      ;;
  esac
fi

print_summary "$(summary_title)$(parallel_suffix)"

if (( FAIL_COUNT > 0 )); then
  exit 1
fi
exit 0
