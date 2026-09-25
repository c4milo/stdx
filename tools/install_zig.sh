#!/usr/bin/env bash
#
# install_zig.sh: install the Zig release stdx builds with, checked against a pinned SHA-256, on a
# hosted Linux runner (decisions 19 and 20). It prints the directory to add to PATH.
#
# Usage: tools/install_zig.sh <install-dir>

set -euo pipefail

readonly version="0.16.0"
# SHA-256 of each tarball, from https://ziglang.org/download/index.json.
readonly sha256_x86_64="70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00"
readonly sha256_aarch64="ea4b09bfb22ec6f6c6ceac57ab63efb6b46e17ab08d21f69f3a48b38e1534f17"

if [[ $# -ne 1 ]]; then
  echo "usage: install_zig.sh <install-dir>" >&2
  exit 2
fi
readonly install_dir="$1"

case "$(uname -m)" in
  x86_64) arch="x86_64"; expected="$sha256_x86_64" ;;
  aarch64 | arm64) arch="aarch64"; expected="$sha256_aarch64" ;;
  *) echo "install_zig.sh: no pinned Zig for $(uname -m)" >&2; exit 1 ;;
esac

name="zig-${arch}-linux-${version}"
mkdir -p "$install_dir"
curl --fail --silent --show-error --location --retry 3 \
  --output "${install_dir}/${name}.tar.xz" "https://ziglang.org/download/${version}/${name}.tar.xz"
actual="$(sha256sum "${install_dir}/${name}.tar.xz" | cut -d' ' -f1)"
if [[ "$actual" != "$expected" ]]; then
  echo "install_zig.sh: ${name}.tar.xz has SHA-256 ${actual}, but ${expected} is pinned" >&2
  exit 1
fi
tar -xJf "${install_dir}/${name}.tar.xz" -C "$install_dir"
echo "${install_dir}/${name}"
