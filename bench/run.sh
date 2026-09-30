#!/usr/bin/env bash
#
# run.sh: run one benchmark step on this host, pinned to one core, and record the run beside its
# numbers (decisions 10 and 20). The bench workflow runs it on each hosted runner; a person may
# run it on any Linux host.
#
# Usage: bench/run.sh <report.md> <step> [build options...]
#   bench/run.sh costs-report.md costs
#   bench/run.sh deflate-report.md bench-deflate -Doracles
#   bench/run.sh checksum-report.md bench-checksum -Doracles
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
tools/fetch_packages.sh
zig build install "$@"

cpu_model="$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ *//' || true)"
if [[ -z "$cpu_model" ]]; then
  # Arm hosts name the part in lscpu rather than in /proc/cpuinfo.
  cpu_model="$(lscpu | grep -m1 'Model name' | cut -d: -f2- | sed 's/^ *//' || true)"
fi
run_url="${GITHUB_SERVER_URL:-}/${GITHUB_REPOSITORY:-}/actions/runs/${GITHUB_RUN_ID:-}"

# Experiment (perf-brotli-x86-profile): CPU-clock samples of each brotli decoder over the small
# bodies, by function, and stdx's hottest functions on js-1k by instruction.
if [[ "$step" == "bench-profile" ]]; then
  # A `head` that closes a pipe early fails the pipeline under pipefail; the samples are kept anyway.
  set +e +o pipefail
  sudo apt-get update -qq > /dev/null 2>&1 || true
  sudo apt-get install -y -qq linux-tools-common "linux-tools-$(uname -r)" > /dev/null 2>&1 || true
  zig build corpus "$@"
  samples=/tmp/small-profile.data
  {
    echo "# small bodies, sampled"
    echo
    echo "| Field | Value |"
    echo "|---|---|"
    echo "| Commit | $(git rev-parse --short HEAD) |"
    echo "| Runner label | ${RUNNER_LABEL:-by hand} |"
    echo "| CPU model | ${cpu_model:-unknown} |"
    echo "| Kernel | $(uname -r) |"
    echo "| perf | $(perf --version 2>&1 | head -1) |"
    echo "| Run URL | ${GITHUB_RUN_ID:+${run_url}} |"
    echo
    echo "## js-1k, counted"
    echo
    echo '```text'
    for octets in 369 104; do
      for who in stdx google; do
        echo "### ${who}, first ${octets} octets"
        sudo perf stat -e cycles,instructions,branches,branch-misses -- taskset -c "$core" zig-out/bin/small_profile "$who" 3000 zig-out/corpus/http/js-1k "$octets" 2>&1 | grep -E 'decodes|cycles|instructions|branch'
      done
    done
    echo '```'
    echo
    for file in http/js-1k http/json-1k; do
      for who in stdx google; do
        echo "## ${file}, ${who}"
        echo
        echo '```text'
        sudo perf record -q -e cpu-clock -F 20000 -o "$samples" -- taskset -c "$core" zig-out/bin/small_profile "$who" 3000 "zig-out/corpus/$file" 2>&1
        sudo perf report -q -i "$samples" --stdio --no-children --sort sym --percent-limit 0.5 2>/dev/null | head -45
        echo '```'
        echo
      done
    done
    sudo perf record -q -e cpu-clock -F 20000 -o "$samples" -- taskset -c "$core" zig-out/bin/small_profile stdx 6000 zig-out/corpus/http/js-1k 2>&1
    sudo perf report -q -i "$samples" --stdio --no-children --sort sym 2>/dev/null | sed -E 's/^.*\[\.\] //' | head -10 |
      while IFS= read -r symbol; do
        echo "## js-1k, stdx: ${symbol}"
        echo
        echo '```text'
        sudo perf annotate -q -i "$samples" --stdio -s "$symbol" 2>/dev/null | grep -v '^\s*0.00 :' | head -260
        echo '```'
        echo
      done
  } > "$report"
  cat "$report"
  exit 0
fi

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
