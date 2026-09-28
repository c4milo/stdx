#!/usr/bin/env bash
#
# install_zig.sh: install the Zig release stdx builds with, checked against a pinned SHA-256, on a
# hosted runner of decisions 19 and 20: Linux on x86-64 and aarch64, macOS on arm64. It prints the
# directory to add to PATH.
#
# Usage: tools/install_zig.sh <install-dir>

set -euo pipefail

readonly version="0.16.0"
# SHA-256 of each tarball, from https://ziglang.org/download/index.json.
readonly sha256_x86_64_linux="70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00"
readonly sha256_aarch64_linux="ea4b09bfb22ec6f6c6ceac57ab63efb6b46e17ab08d21f69f3a48b38e1534f17"
readonly sha256_aarch64_macos="b23d70deaa879b5c2d486ed3316f7eaa53e84acf6fc9cc747de152450d401489"

if [[ $# -ne 1 ]]; then
  echo "usage: install_zig.sh <install-dir>" >&2
  exit 2
fi
readonly install_dir="$1"

case "$(uname -s) $(uname -m)" in
  "Linux x86_64") platform="x86_64-linux"; expected="$sha256_x86_64_linux" ;;
  "Linux aarch64" | "Linux arm64") platform="aarch64-linux"; expected="$sha256_aarch64_linux" ;;
  "Darwin arm64") platform="aarch64-macos"; expected="$sha256_aarch64_macos" ;;
  *) echo "install_zig.sh: no pinned Zig for $(uname -s) on $(uname -m)" >&2; exit 1 ;;
esac

# Prints the SHA-256 of a file, with sha256sum on Linux and shasum on macOS.
sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

name="zig-${platform}-${version}"
mkdir -p "$install_dir"
curl --fail --silent --show-error --location --retry 3 \
  --output "${install_dir}/${name}.tar.xz" "https://ziglang.org/download/${version}/${name}.tar.xz"
actual="$(sha256_of "${install_dir}/${name}.tar.xz")"
if [[ "$actual" != "$expected" ]]; then
  echo "install_zig.sh: ${name}.tar.xz has SHA-256 ${actual}, but ${expected} is pinned" >&2
  exit 1
fi
tar -xJf "${install_dir}/${name}.tar.xz" -C "$install_dir"

# Zig 0.16 on Linux writes a zip package's download into the global cache's tmp directory without
# creating it first, so the first fetch of a zip (Silesia's) fails with FileNotFound on a fresh
# machine. Creating the directory first is the whole fix; macOS is not affected.
mkdir -p "${ZIG_GLOBAL_CACHE_DIR:-${HOME}/.cache/zig}/tmp"
echo "${install_dir}/${name}"
