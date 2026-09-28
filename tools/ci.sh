#!/usr/bin/env bash
#
# ci.sh: every check that needs no fixed machine, in one run, with a report (decision 19).
#
# .github/workflows/main.yml runs this on each push to main, and a person runs the same thing. A
# new check joins this script, never the workflow file, so the two never drift.
#
# Usage: tools/ci.sh [report.md]
#
# Every check runs even after one fails, so the report shows all of them. Exit status 0 when every
# check passed, 1 when any failed.

set -uo pipefail

readonly report="${1:-ci-report.md}"

cd "$(git rev-parse --show-toplevel)"

failures=0
rows=()

# Runs one check, prints its output, and records its verdict for the report.
run_check() {
  local name="$1"
  shift
  echo "== ${name}: $*"
  local started
  started="$(date +%s)"
  if "$@"; then
    rows+=("| ${name} | pass | $(( $(date +%s) - started )) s |")
  else
    rows+=("| ${name} | FAIL | $(( $(date +%s) - started )) s |")
    failures=$((failures + 1))
  fi
}

# Checks that docs/rfcs/ and docs/specs/ hold the RFCs and the specifications unmodified, with
# sha256sum on Linux and shasum on macOS.
check_copies() {
  local directory
  for directory in docs/rfcs docs/specs; do
    if command -v sha256sum >/dev/null 2>&1; then
      (cd "$directory" && sha256sum --check --quiet SHA256SUMS) || return 1
    else
      (cd "$directory" && shasum -a 256 --check --quiet SHA256SUMS) || return 1
    fi
  done
}

# Every package, lazy ones included, is fetched before any check runs, with retries, so a host that
# drops one connection does not fail a check that has nothing to do with the network.
run_check "fetch" tools/fetch_packages.sh
run_check "format" zig fmt --check build.zig bench build src tools
run_check "rfcs and specs" check_copies
run_check "corpus fetch pin" bash tools/corpus/fetch_check.sh
run_check "test" zig build test
# The unit tests built by Zig's own x86-64 backend, a caller's Debug default on x86-64 Linux: run
# there, and only compiled on every other runner. The summary shows which, module by module.
run_check "self-hosted backend" zig build test-self-hosted --summary all
run_check "oracle tests" zig build test-oracle -Doracles
# Every program the build installs, the benchmarks included: no check above compiles bench/zstd or
# bench/checksum, which run only when a person asks for numbers.
run_check "build" zig build -Doracles
run_check "fuzz, short" tools/fuzz.sh 20K fuzz-report.md
run_check "oracle self-test" zig build oracle-selftest -Doracles
run_check "differential checksum" zig build differential-checksum -Doracles
run_check "differential deflate" zig build differential-deflate -Doracles
run_check "differential encode" zig build differential-encode -Doracles
run_check "differential zstd" zig build differential-zstd -Doracles

{
  echo "# CI report"
  echo
  echo "| Field | Value |"
  echo "|---|---|"
  echo "| Commit | $(git rev-parse HEAD) |"
  echo "| Host | $(uname -srm) |"
  echo "| Zig | $(zig version) |"
  echo "| Runner | ${RUNNER_NAME:-by hand} ${ImageVersion:+(image ${ImageVersion})} |"
  echo
  echo "| Check | Verdict | Time |"
  echo "|---|---|---|"
  printf '%s\n' "${rows[@]}"
} > "$report"

cat "$report"
if [[ "$failures" -ne 0 ]]; then
  echo "ci.sh: ${failures} check(s) failed" >&2
  exit 1
fi
