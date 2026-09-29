#!/usr/bin/env bash
#
# prune_packages.sh: delete from zig-pkg every package that no build.zig.zon given names, so that
# the entry the workflows keep in GitHub's cache holds no package a build no longer uses. A package
# is named when a build.zig.zon given, or the build.zig.zon of a named package, names its hash.
#
# Usage: tools/prune_packages.sh <build.zig.zon>...
#   tools/prune_packages.sh build.zig.zon
#   tools/prune_packages.sh build.zig.zon base/build.zig.zon
#
# The zig-pkg pruned is the one beside the first build.zig.zon.

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: prune_packages.sh <build.zig.zon>..." >&2
  exit 2
fi
packages="$(dirname "$1")/zig-pkg"
readonly packages
if [[ ! -d "$packages" ]]; then
  exit 0
fi

# Prints each package hash a build.zig.zon names, one a line.
hashes_named_by() {
  sed -nE 's/^.*\.hash[[:space:]]*=[[:space:]]*"([^"]+)".*$/\1/p' "$1"
}

# A build.zig.zon that names no package, or that failed to parse, would delete every package.
for zon in "$@"; do
  if [[ -z "$(hashes_named_by "$zon")" ]]; then
    echo "prune_packages.sh: ${zon} names no package, so nothing is pruned" >&2
    exit 1
  fi
done

# Each pass reads the build.zig.zon of every named package in zig-pkg and adds the hashes it names,
# until a pass adds none. Only a package that the pass before added can name a hash not yet named,
# so there are at most as many passes as entries in zig-pkg, plus two.
named="$(for zon in "$@"; do hashes_named_by "$zon"; done | sort -u)"
passes_max="$(( $(find "$packages" -mindepth 1 -maxdepth 1 | wc -l) + 2 ))"
settled=false
for (( pass = 0; pass < passes_max; pass++ )); do
  grown="$(
    {
      printf '%s\n' "$named"
      for hash in $named; do
        if [[ -f "${packages}/${hash}/build.zig.zon" ]]; then
          hashes_named_by "${packages}/${hash}/build.zig.zon"
        fi
      done
    } | sort -u
  )"
  if [[ "$grown" == "$named" ]]; then
    settled=true
    break
  fi
  named="$grown"
done
if [[ "$settled" != true ]]; then
  echo "prune_packages.sh: the named packages grew on every pass, so nothing is pruned" >&2
  exit 1
fi

# Zig names a package's directory by the package's hash, which holds a dash; the directories of its
# global cache (b, h, o, p, tmp, z), which the workflows keep in zig-pkg, hold none, and stay.
for entry in "$packages"/*-*; do
  if [[ ! -e "$entry" ]]; then
    continue
  fi
  hash="$(basename "$entry")"
  if ! grep -qxF -- "$hash" <<< "$named"; then
    echo "prune_packages.sh: deleting ${entry}, which no build.zig.zon given names"
    rm -rf -- "$entry"
  fi
done
