#!/usr/bin/env bash
#
# fetch_check.sh: the check behind tools/corpus/fetch.sh's pin. It serves a small file to
# fetch.sh from a file:// URL, and requires the pinned hash to pass and any other hash to fail and
# leave no output behind. tools/ci.sh runs it.

set -euo pipefail

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
printf 'a corpus file\n' > "${work}/source"
if command -v sha256sum >/dev/null 2>&1; then
  right="$(sha256sum "${work}/source" | cut -d' ' -f1)"
else
  right="$(shasum -a 256 "${work}/source" | cut -d' ' -f1)"
fi
readonly wrong="0000000000000000000000000000000000000000000000000000000000000000"
readonly script="$(dirname "$0")/fetch.sh"

bash "$script" "file://${work}/source" "$right" "${work}/right"
cmp "${work}/source" "${work}/right"
if bash "$script" "file://${work}/source" "$wrong" "${work}/wrong" 2>/dev/null; then
  echo "fetch_check.sh: fetch.sh accepted a hash that is not the file's" >&2
  exit 1
fi
if [[ -e "${work}/wrong" || -e "${work}/wrong.partial" ]]; then
  echo "fetch_check.sh: fetch.sh left output behind after refusing a hash" >&2
  exit 1
fi
echo "fetch_check.sh: fetch.sh keeps the pinned hash and refuses any other"
