#!/usr/bin/env bash
#
# fuzz.sh: run Zig's fuzzer over every module that holds a fuzz test, for a fixed number of runs
# each (decisions 15 and 20), and write what it reported.
#
# Usage: tools/fuzz.sh <runs> [report.md [module]]
#        tools/fuzz.sh --list
#
# <runs> takes Zig's suffixes: 10K, 2M. Without a module it fuzzes every module in turn, as
# tools/ci.sh does for a short pass on every push; the fuzz workflow runs a long pass on a schedule,
# one job per module. `--list` prints the fuzzed modules as a JSON array, which that workflow's
# matrix reads, so the matrix and this list cannot drift apart.
#
# Zig 0.16.0's test runner does not compile in fuzz mode in Debug: it hands a builtin.StackTrace to
# std.debug.writeStackTrace, which takes a debug.StackTrace, on the error-return-trace path. That
# path exists only in Debug, so every fuzz run here builds ReleaseSafe, with -Drelease.
#
# Zig 0.16.0's build runner counts the failed steps before the fuzz phase starts. A test that fails
# while it is fuzzed prints `error: test '<name>' <how it ended>; input saved to '<path>'`
# (std/Build/Step/Run.zig), and `zig build` still exits 0. So a module fails when its run exits
# with another status, or when its log holds a line that begins `error: `. A run that passes prints
# no such line. tools/fuzz_check.sh checks the verdict.

set -euo pipefail

# Every module whose tests hold a `std.testing.fuzz` call. A module gains its entry in the commit
# that adds its first fuzz test.
readonly fuzzed_modules=(codec hash deflate gzip zlib zstd brotli json base64 regex)

# The most octets of a saved input that the report writes in hex. The report says when it cuts one.
readonly saved_input_len_max=4096

# Writes in hex the input that the fuzzer saved for a failed test, which a person makes a fixture
# and a named test (decision 15). $1 is the run's log.
print_saved_input() {
  local line path input_len
  line="$(grep -m 1 "; input saved to '" "$1")" || return 0
  path="${line##*; input saved to \'}"
  path="${path%\'}"
  if [[ ! -f "$path" ]]; then
    echo "The saved input ${path} is gone."
    return 0
  fi
  input_len="$(wc -c < "$path" | tr -d ' ')"
  echo "The saved input ${path} holds ${input_len} octets, in hex:"
  # macOS's od pads each octet to a wider field than GNU's. One space between octets makes the
  # report read the same on every host.
  head -c "$saved_input_len_max" "$path" | od -An -tx1 -v | tr -s ' '
  if [[ "$input_len" -gt "$saved_input_len_max" ]]; then
    echo "The report cuts the input at ${saved_input_len_max} octets."
  fi
}

if [[ $# -lt 1 || $# -gt 3 || ( "$1" == "--list" && $# -ne 1 ) ]]; then
  echo "usage: tools/fuzz.sh <runs> [report.md [module]] | tools/fuzz.sh --list" >&2
  exit 2
fi

cd "$(git rev-parse --show-toplevel)"

# The list above must name exactly the modules whose sources call std.testing.fuzz, so a module
# never gains a fuzz test that no run reaches.
# A module's folder is `src/<module>`, or `src/<category>/<module>` for the categories of decision 6
# as amended: `compress`, `encoding`, and `utf8` under `unicode`.
found="$(grep -rl 'testing\.fuzz(' src | awk -F/ '
  $2 == "compress" || $2 == "encoding" || ($2 == "unicode" && $3 == "utf8") { print $3; next }
  { print $2 }' | sort -u | tr '\n' ' ')"
listed="$(printf '%s\n' "${fuzzed_modules[@]}" | sort -u | tr '\n' ' ')"
if [[ "$found" != "$listed" ]]; then
  echo "fuzz.sh: the modules with fuzz tests are [${found}], but the list names [${listed}]" >&2
  exit 1
fi

if [[ "$1" == "--list" ]]; then
  printf '["%s"' "${fuzzed_modules[0]}"
  printf ',"%s"' "${fuzzed_modules[@]:1}"
  printf ']\n'
  exit 0
fi
readonly runs="$1"
readonly report="${2:-fuzz-report.md}"
modules=("${fuzzed_modules[@]}")
if [[ $# -eq 3 ]]; then
  if [[ " ${fuzzed_modules[*]} " != *" $3 "* ]]; then
    echo "fuzz.sh: $3 is not a fuzzed module; the list names [${listed}]" >&2
    exit 2
  fi
  modules=("$3")
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
for module in "${modules[@]}"; do
  echo "== fuzz ${module}: ${runs} runs"
  if zig build "test-${module}" --fuzz="$runs" -Drelease >"$log" 2>&1 && ! grep -q '^error: ' "$log"; then
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
    if [[ "$verdict" == "FAILED" ]]; then
      grep '^error: ' "$log" || true
      print_saved_input "$log"
      echo
    fi
    sed -n '/FUZZING REPORT/,/^====/p' "$log"
    echo '```'
    echo
  } >> "$report"
done
cat "$report"
exit "$status"
