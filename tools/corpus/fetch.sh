#!/usr/bin/env bash
#
# fetch.sh: download one corpus file that is not an archive, and refuse it unless its SHA-256 is
# the one pinned (decision 15). Zig's package fetcher takes archives and git repositories only, so
# a plain file such as the WHATWG HTML Standard's single page is fetched here instead, and pinned
# the same way a package is: by its hash.
#
# Usage: fetch.sh <url> <sha256> <output-path>
#
# The build runs this as a step whose output lands in the Zig cache, so the download happens once
# per cache. Exit status 0 when the file matches, 1 when the download fails or the hash differs,
# 2 on a usage error.

set -euo pipefail

# The number of times curl retries a failed transfer.
readonly retries=3

if [[ $# -ne 3 ]]; then
  echo "usage: fetch.sh <url> <sha256> <output-path>" >&2
  exit 2
fi
readonly url="$1"
readonly expected="$2"
readonly output="$3"

# Prints the SHA-256 of a file, with sha256sum on Linux and shasum on macOS.
sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

partial="${output}.partial"
curl --fail --silent --show-error --location --retry "$retries" --output "$partial" "$url"
actual="$(sha256_of "$partial")"
if [[ "$actual" != "$expected" ]]; then
  echo "fetch.sh: ${url} has SHA-256 ${actual}, but ${expected} is pinned" >&2
  rm -f "$partial"
  exit 1
fi
mv "$partial" "$output"
