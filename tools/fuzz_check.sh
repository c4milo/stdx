#!/usr/bin/env bash
#
# fuzz_check.sh: the check behind the verdict of tools/fuzz.sh. It runs the script for one module
# with a stand-in `zig` first on the path, which prints what Zig 0.16.0 prints and exits as it
# does. A test that fails while it is fuzzed prints an `error: ` line, and `zig build --fuzz` still
# exits 0. The script must fail that run and a run that exits 1, pass a clean run, and write the
# input the fuzzer saved into its report. tools/ci.sh runs it.

set -euo pipefail

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
script="$(cd "$(dirname "$0")" && pwd)/fuzz.sh"
readonly script
readonly module="base64"
failures=0

# The stand-in prints the lines of a case that STUB_CASE names, as Zig 0.16.0 printed them for the
# base64 module on arm64 in https://github.com/c4milo/stdx/actions/runs/44938438418.
mkdir -p "${work}/bin"
cat > "${work}/bin/zig" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1" == "version" ]]; then
  echo "0.16.0"
  exit 0
fi
test_name="base64_fuzz_test.test.fuzz base 64 against std.base64 and its own round trip"
report() {
  echo "======= FUZZING REPORT ======="
  echo "Step: run test base64"
  echo "Runs: 0 -> 7251"
  echo "=============================="
}
case "$STUB_CASE" in
  pass)
    # A line of a clean run may hold `error: ` past its start, as a test's name can.
    echo "Fuzz test: \"zstd_fuzz_test.test.fuzz the decoder's error: values\""
    report
    ;;
  error | signal)
    how="exited with code 1"
    [[ "$STUB_CASE" == "signal" ]] && how="terminated with signal ABRT"
    echo "test-base64"
    echo "+- run test base64 failure"
    echo "failed with error.InvalidPadding"
    echo "error: test '${test_name}' ${how}; input saved to '${STUB_INPUT}'"
    echo "failed command: ./.zig-cache/o/0/base64 --cache-dir=./.zig-cache --seed=0x5178b0e1"
    echo
    report
    ;;
  build)
    echo "src/base64/base64.zig:1:1: error: a compile error"
    exit 1
    ;;
esac
STUB
chmod +x "${work}/bin/zig"

# Runs the script under the stand-in. $1 is the case, $2 the status the script must exit with,
# and each later argument a line the report must hold, or, after a leading !, must not hold.
run_case() {
  local name="$1" expected_status="$2" status=0 line
  shift 2
  STUB_CASE="$name" STUB_INPUT="${work}/crash" PATH="${work}/bin:${PATH}" \
    bash "$script" 1 "${work}/report.md" "$module" > "${work}/out.txt" 2>&1 || status=$?
  if [[ "$status" -ne "$expected_status" ]]; then
    echo "FAIL ${name}: fuzz.sh exited ${status}, expected ${expected_status}" >&2
    failures=$((failures + 1))
  fi
  for line in "$@"; do
    if [[ "$line" == !* ]]; then
      if grep -qF -- "${line#!}" "${work}/report.md"; then
        echo "FAIL ${name}: the report holds '${line#!}'" >&2
        failures=$((failures + 1))
      fi
    elif ! grep -qF -- "$line" "${work}/report.md"; then
      echo "FAIL ${name}: the report lacks '${line}'" >&2
      failures=$((failures + 1))
    fi
  done
}

rm -f "${work}/crash"
run_case pass 0 "## ${module}: no failure" "!saved input"

printf 'abc' > "${work}/crash"
run_case error 1 "## ${module}: FAILED" "exited with code 1; input saved to" \
  "holds 3 octets, in hex:" " 61 62 63" "!cuts the input"

rm -f "${work}/crash"
run_case signal 1 "## ${module}: FAILED" "terminated with signal ABRT" "is gone"

# The most octets the report writes, which it writes whole.
head -c 4096 /dev/zero > "${work}/crash"
run_case error 1 "## ${module}: FAILED" "holds 4096 octets, in hex:" "!cuts the input"

# One octet past the most the report writes, so the report cuts the input and says so. The report
# must write octet 4096, 0xee, and not octet 4097, 0xff.
head -c 4095 /dev/zero > "${work}/crash"
printf '\356\377' >> "${work}/crash"
run_case error 1 "## ${module}: FAILED" "holds 4097 octets, in hex:" \
  "cuts the input at 4096 octets" " ee" "! ff"

run_case build 1 "## ${module}: FAILED"

if [[ "$failures" -ne 0 ]]; then
  echo "fuzz_check.sh: ${failures} failures" >&2
  exit 1
fi
echo "fuzz_check.sh: the verdict of fuzz.sh holds in 6 cases"
