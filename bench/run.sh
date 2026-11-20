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

# The version build.zig.zon pins for package $1: the release its URL names, or the first seven
# digits of the commit it names.
pinned() {
  local url
  url="$(sed -n "/^        \.$1 = \.{/,/}/s/.*\.url = \"\(.*\)\",/\1/p" build.zig.zon)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+(\.[0-9]+)?)\.tar\.gz$ ]]; then
    echo "${BASH_REMATCH[1]}"
  elif [[ "$url" =~ ([0-9a-f]{40}) ]]; then
    echo "${BASH_REMATCH[1]:0:7}"
  else
    echo unknown
  fi
}

# The version of crate $2 that the Cargo.lock in directory $1 pins, and the rustc that builds it
# there: rust-toolchain.toml names it to rustup.
crate() {
  local version rustc
  version="$(awk -v name="$2" '$0 == "name = \"" name "\"" { getline; gsub(/version = |"/, ""); print; exit }' "$1/Cargo.lock")"
  rustc="$(cd "$1" && rustc --version 2>/dev/null | cut -d' ' -f2 || true)"
  echo "${version}, rustc ${rustc:-none}"
}

# The Go that builds the module in directory $1: its go.mod's toolchain line names it.
go_release() {
  local release
  release="$(cd "$1" && go env GOVERSION 2>/dev/null || true)"
  echo "${release#go}"
}

# One row for each baseline that step $1 times, named as the report's columns name it.
baselines() {
  local zig
  zig="$(zig version)"
  case "$1" in
    bench-deflate | bench-checksum | bench-profile)
      echo "| zlib | $(pinned madler_zlib) |"
      echo "| zlib-ng | $(pinned zlib_ng) |"
      echo "| libdeflate | $(pinned libdeflate) |"
      echo "| Wuffs | $(pinned wuffs) |"
      ;;
  esac
  case "$1" in
    bench-zstd | bench-checksum | bench-profile) echo "| libzstd | $(pinned libzstd) |" ;;
  esac
  case "$1" in
    bench-brotli | bench-profile) echo "| Google | $(pinned google_brotli) |" ;;
  esac
  case "$1" in
    bench-json | bench-profile)
      echo "| simdjson | $(pinned simdjson) |"
      echo "| yyjson | $(pinned yyjson) |"
      echo "| std.json | ${zig} |"
      ;;
  esac
  case "$1" in
    bench-json)
      echo "| serde_json | $(crate bench/json/rust serde_json) |"
      echo "| Go jsontext | $(go_release bench/json/go) |"
      echo "| simdutf | $(pinned simdutf) |"
      ;;
    bench-base64)
      echo "| Rust base64 | $(crate bench/base64/rust base64) |"
      echo "| Go encoding/base64 | $(go_release bench/base64/go) |"
      echo "| std.base64 | ${zig} |"
      ;;
  esac
}

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
  baselines "$step"
  echo
  taskset -c "$core" zig build "$step" "$@"
} > "$report"
cat "$report"
