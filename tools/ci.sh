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

# Checks that docs/rfcs/ holds the RFCs unmodified, with sha256sum on Linux and shasum on macOS.
check_rfcs() {
  if command -v sha256sum >/dev/null 2>&1; then
    (cd docs/rfcs && sha256sum --check --quiet SHA256SUMS)
  else
    (cd docs/rfcs && shasum -a 256 --check --quiet SHA256SUMS)
  fi
}

# Every package, lazy ones included, is fetched before any check runs, with retries, so a host that
# drops one connection does not fail a check that has nothing to do with the network.
run_check "fetch" tools/fetch_packages.sh
run_check "format" zig fmt --check build.zig bench build src tools
run_check "rfcs" check_rfcs
run_check "corpus fetch pin" bash tools/corpus/fetch_check.sh
run_check "test" zig build test
run_check "oracle tests" zig build test-oracle -Doracles
run_check "fuzz, short" tools/fuzz.sh 20K fuzz-report.md
run_check "oracle self-test" zig build oracle-selftest -Doracles
run_check "differential checksum" zig build differential-checksum -Doracles
run_check "differential deflate" zig build differential-deflate -Doracles

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
