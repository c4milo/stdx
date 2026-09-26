#!/usr/bin/env bash
#
# fuzz.sh: run Zig's fuzzer over every module that holds a fuzz test, for a fixed number of runs
# each (decisions 15 and 20), and write what it reported.
#
# Usage: tools/fuzz.sh <runs> [report.md]
#
# <runs> takes Zig's suffixes: 10K, 2M. The fuzz workflow runs long passes on a schedule, and
# tools/ci.sh a short one on every push.
#
# Zig 0.16.0's test runner does not compile in fuzz mode in Debug: it hands a builtin.StackTrace to
# std.debug.writeStackTrace, which takes a debug.StackTrace, on the error-return-trace path. That
# path exists only in Debug, so every fuzz run here builds ReleaseSafe, with -Drelease.

set -euo pipefail

# Every module whose tests hold a `std.testing.fuzz` call. A module gains its entry in the commit
# that adds its first fuzz test.
readonly fuzzed_modules=(codec checksum deflate zlib)

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: tools/fuzz.sh <runs> [report.md]" >&2
  exit 2
fi
readonly runs="$1"
readonly report="${2:-fuzz-report.md}"

cd "$(git rev-parse --show-toplevel)"

# The list above must name exactly the modules whose sources call std.testing.fuzz, so a module
# never gains a fuzz test that no run reaches.
found="$(grep -rl 'testing\.fuzz(' src | cut -d/ -f2 | sort -u | tr '\n' ' ')"
listed="$(printf '%s\n' "${fuzzed_modules[@]}" | sort -u | tr '\n' ' ')"
if [[ "$found" != "$listed" ]]; then
  echo "fuzz.sh: the modules with fuzz tests are [${found}], but the list names [${listed}]" >&2
  exit 1
fi

log="$(mktemp)"
trap 'rm -f "$log"' EXIT
{
  echo "# Fuzz report"
  echo
  echo "Runs per module: ${runs}. Host: $(uname -srm). Zig: $(zig version)."
  echo
} > "$report"

status=0
for module in "${fuzzed_modules[@]}"; do
  echo "== fuzz ${module}: ${runs} runs"
  if zig build "test-${module}" --fuzz="$runs" -Drelease >"$log" 2>&1; then
    verdict="no failure"
  else
    verdict="FAILED"
    status=1
  fi
  cat "$log"
  {
    echo "## ${module}: ${verdict}"
    echo
    echo '```text'
    sed -n '/FUZZING REPORT/,/^====/p' "$log"
    echo '```'
    echo
  } >> "$report"
done
cat "$report"
exit "$status"
