#!/usr/bin/env bash
#
# fetch_packages.sh: fetch every package the build names, lazy ones included, before anything
# needs one (decisions 8 and 15). Zig's fetcher does not retry, and the hosts behind the corpora
# and the oracles have dropped connections and answered 500 on hosted runners, so this tries a few
# times, waiting longer after each failure. tools/ci.sh and bench/run.sh run it first.
#
# Usage: tools/fetch_packages.sh

set -euo pipefail

# The seconds to wait before each retry; one more attempt is made than there are waits.
readonly waits=(10 30 90)

cd "$(git rev-parse --show-toplevel)"
for wait in "${waits[@]}" 0; do
  if zig build --fetch=all -Doracles; then
    exit 0
  fi
  if [[ "$wait" -eq 0 ]]; then
    break
  fi
  echo "fetch_packages.sh: a fetch failed; trying again in ${wait} s" >&2
  sleep "$wait"
done
echo "fetch_packages.sh: every attempt failed" >&2
exit 1
