#!/usr/bin/env bash
#
# run.sh: run one benchmark step on this host, pinned to one core, and record the run beside its
# numbers (decisions 10 and 20). The bench workflow runs it on each hosted runner; a person may
# run it on any Linux host.
#
# Usage: bench/run.sh <report.md> <step> [build options...]
#   bench/run.sh costs-report.md costs
#   bench/run.sh deflate-report.md bench-deflate -Doracles
#
# The first build compiles and fetches everything unpinned; the second, pinned, finds it all
# cached and runs only the benchmark.

set -euo pipefail

# The core the measurement is pinned to. Core 0 takes most of the host's interrupts.
readonly core=1

if [[ $# -lt 2 ]]; then
  echo "usage: bench/run.sh <report.md> <step> [build options...]" >&2
  exit 2
fi
readonly report="$1"
readonly step="$2"
shift 2

cd "$(git rev-parse --show-toplevel)"
zig build install "$@"

cpu_model="$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ *//' || true)"
if [[ -z "$cpu_model" ]]; then
  # Arm hosts name the part in lscpu rather than in /proc/cpuinfo.
  cpu_model="$(lscpu | grep -m1 'Model name' | cut -d: -f2- | sed 's/^ *//' || true)"
fi
run_url="${GITHUB_SERVER_URL:-}/${GITHUB_REPOSITORY:-}/actions/runs/${GITHUB_RUN_ID:-}"

{
  echo "# ${step}"
  echo
  echo "| Field | Value |"
  echo "|---|---|"
  echo "| Commit | $(git rev-parse --short HEAD) |"
  echo "| Runner label | ${RUNNER_LABEL:-by hand} |"
  echo "| Image version | ${ImageVersion:-none} |"
  echo "| CPU model | ${cpu_model:-unknown} |"
  echo "| Virtual CPUs | $(nproc) |"
  echo "| Kernel | $(uname -r) |"
  echo "| Zig version | $(zig version) |"
  echo "| Run URL | ${GITHUB_RUN_ID:+${run_url}} |"
  echo "| Date | $(date -u +%Y-%m-%d) |"
  echo
  taskset -c "$core" zig build "$step" "$@"
} > "$report"
cat "$report"
