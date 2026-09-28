#!/usr/bin/env bash
#
# install_lean.sh: install the Lean release spec/lean/lean-toolchain pins, checked against a pinned
# SHA-256, on the x86-64 Linux runner, where tools/ci.sh builds the proofs of decision 28. It prints
# the directory to add to PATH. A directory that already holds the release, restored from a cache,
# is kept as it is.
#
# Usage: tools/install_lean.sh <install-dir>
set -euo pipefail
readonly version="4.34.0"
# SHA-256 of lean-4.34.0-linux.tar.zst, the digest GitHub records for the release's asset.
readonly sha256_x86_64_linux="caaa98356098c85dc0fcbbd28e1ec66f39eb6551829972b752ff20e1286b646b"
if [[ $# -ne 1 ]]; then
  echo "usage: install_lean.sh <install-dir>" >&2
  exit 2
fi
readonly install_dir="$1"
cd "$(git rev-parse --show-toplevel)"
readonly pinned="$(cat spec/lean/lean-toolchain)"
if [[ "$pinned" != "leanprover/lean4:v${version}" ]]; then
  echo "install_lean.sh: spec/lean/lean-toolchain pins ${pinned}, and this script installs ${version}" >&2
  exit 1
fi
if [[ "$(uname -s) $(uname -m)" != "Linux x86_64" ]]; then
  echo "install_lean.sh: no pinned Lean for $(uname -s) on $(uname -m)" >&2
  exit 1
fi
if [[ -x "$install_dir/bin/lake" ]] && "$install_dir/bin/lean" --version | grep -q "version ${version},"; then
  echo "$install_dir/bin"
  exit 0
fi
archive="$(mktemp)"
trap 'rm -f "$archive"' EXIT
curl -sSfL --retry 3 -o "$archive" \
  "https://github.com/leanprover/lean4/releases/download/v${version}/lean-${version}-linux.tar.zst"
echo "${sha256_x86_64_linux}  ${archive}" | sha256sum --check --quiet
rm -rf "$install_dir"
mkdir -p "$install_dir"
tar --zstd -xf "$archive" -C "$install_dir" --strip-components=1
"$install_dir/bin/lake" --version >&2
echo "$install_dir/bin"
