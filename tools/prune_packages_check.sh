#!/usr/bin/env bash
#
# prune_packages_check.sh: the check behind tools/prune_packages.sh. It builds a zig-pkg of named,
# stale and transitively named packages, with directories of Zig's global cache beside them, and
# requires the script to delete exactly the entries that are not packages a build.zig.zon given
# names, and to delete nothing when a build.zig.zon names no package. tools/ci.sh runs it.

set -euo pipefail

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
script="$(cd "$(dirname "$0")" && pwd)/prune_packages.sh"
readonly script

# The build.zig.zon names one and two, two names three, the base names five, and stale names four.
# two_prefix is stale, and its hash starts two's.
readonly one="N-V-__8AAone"
readonly two="two-1.0.0-twotwotwo"
readonly two_prefix="two-1.0.0-two"
readonly three="N-V-__8AAthree"
readonly four="N-V-__8AAfour"
readonly five="N-V-__8AAfive"
readonly stale="stale-0.1.0-stalestale"
failures=0

# Writes a build.zig.zon that names each hash given.
write_zon() {
  local file="$1"
  shift
  local index=0
  local hash
  {
    echo '.{'
    echo '    .dependencies = .{'
    for hash in "$@"; do
      printf '        .package_%d = .{\n' "$index"
      printf '            .url = "https://example.com/%d.tar.gz",\n' "$index"
      printf '            .hash = "%s",\n' "$hash"
      echo '        },'
      index=$((index + 1))
    done
    echo '    },'
    echo '}'
  } > "$file"
}

# Builds the tree the script runs in, with its zig-pkg and the base's build.zig.zon.
build_tree() {
  rm -rf "${work}/tree"
  mkdir -p "${work}/tree/base" "${work}/tree/zig-pkg/p" "${work}/tree/zig-pkg/o/output"
  mkdir -p "${work}/tree/zig-pkg/tmp"
  local package
  for package in "$one" "$two" "$two_prefix" "$three" "$four" "$five" "$stale"; do
    mkdir -p "${work}/tree/zig-pkg/${package}"
  done
  write_zon "${work}/tree/build.zig.zon" "$one" "$two"
  write_zon "${work}/tree/base/build.zig.zon" "$five"
  write_zon "${work}/tree/zig-pkg/${two}/build.zig.zon" "$three"
  write_zon "${work}/tree/zig-pkg/${stale}/build.zig.zon" "$four"
  touch "${work}/tree/zig-pkg/p/${stale}.tar.gz"
}

# Counts a failure unless each entry of zig-pkg given is still there (kept) or gone (deleted).
expect() {
  local verdict="$1"
  shift
  local entry
  for entry in "$@"; do
    if [[ -e "${work}/tree/zig-pkg/${entry}" && "$verdict" == deleted ]] ||
      [[ ! -e "${work}/tree/zig-pkg/${entry}" && "$verdict" == kept ]]; then
      echo "prune_packages_check.sh: ${entry} was not ${verdict}" >&2
      failures=$((failures + 1))
    fi
  done
}

build_tree
(cd "${work}/tree" && bash "$script" build.zig.zon > /dev/null)
expect kept "$one" "$two" "$three"
expect deleted "$two_prefix" "$four" "$five" "$stale" o p tmp

build_tree
(cd "${work}/tree" && bash "$script" build.zig.zon base/build.zig.zon > /dev/null)
expect kept "$five"
expect deleted "$stale"

build_tree
write_zon "${work}/tree/base/build.zig.zon"
if (cd "${work}/tree" && bash "$script" build.zig.zon base/build.zig.zon > /dev/null 2>&1); then
  echo "prune_packages_check.sh: a build.zig.zon that names no package was accepted" >&2
  failures=$((failures + 1))
fi
expect kept "$stale" o

build_tree
rm -rf "${work}/tree/zig-pkg"
(cd "${work}/tree" && bash "$script" build.zig.zon)

if [[ "$failures" -ne 0 ]]; then
  exit 1
fi
echo "prune_packages_check.sh: prune_packages.sh keeps just the packages the build.zig.zon name"
