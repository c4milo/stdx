#!/usr/bin/env bash
#
# run.sh: measure docs/costs.md's rows on this host, pinned to one core, and record the run
# beside them (decision 20). The costs workflow runs it on each hosted runner; a person may run
# it on any Linux host.
#
# Usage: bench/costs/run.sh <report.md>

set -euo pipefail

# The core the measurement is pinned to. Core 0 takes most of the host's interrupts.
readonly core=1

if [[ $# -ne 1 ]]; then
  echo "usage: bench/costs/run.sh <report.md>" >&2
  exit 2
fi
readonly report="$1"

cd "$(git rev-parse --show-toplevel)"
zig build install

cpu_model="$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ *//' || true)"
if [[ -z "$cpu_model" ]]; then
  # Arm hosts name the part in lscpu rather than in /proc/cpuinfo.
  cpu_model="$(lscpu | grep -m1 'Model name' | cut -d: -f2- | sed 's/^ *//' || true)"
fi
run_url="${GITHUB_SERVER_URL:-}/${GITHUB_REPOSITORY:-}/actions/runs/${GITHUB_RUN_ID:-}"

{
  echo "# Costs"
  echo
  echo "| Field | Value |"
  echo "|---|---|"
  echo "| Runner label | ${RUNNER_LABEL:-by hand} |"
  echo "| Image version | ${ImageVersion:-none} |"
  echo "| CPU model | ${cpu_model:-unknown} |"
  echo "| Virtual CPUs | $(nproc) |"
  echo "| Kernel | $(uname -r) |"
  echo "| Zig version and build mode | $(zig version), ReleaseFast |"
  echo "| Run URL | ${GITHUB_RUN_ID:+${run_url}} |"
  echo "| Date | $(date -u +%Y-%m-%d) |"
  echo
  taskset -c "$core" zig-out/bin/costs
} > "$report"
cat "$report"
