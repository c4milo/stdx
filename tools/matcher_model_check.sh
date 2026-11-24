#!/usr/bin/env bash
#
# matcher_model_check.sh: the Lean model of the matcher against `Matcher.find`, on programs a new
# seed draws (decision 86, design §8 part 22h).
#
# For each seed, `lake exe vectors --random` writes the programs the seed draws, some texts for
# each, and the answer that spec/lean/Stdx/Regex/MatcherAnswer.lean proves for each search.
# `zig build matcher-replay` builds the program that runs `Matcher.find` on each and requires the
# same span. A seed that fails is printed: give it again to see the same failure.
#
# Usage: tools/matcher_model_check.sh [seed...]
#
# With no seed, the seed is the time in seconds, so each run reads programs that no run read
# before. PROGRAMS sets the programs a seed draws, 4096 by default. It needs lake and zig.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
readonly programs="${PROGRAMS:-4096}"
if ! command -v lake >/dev/null 2>&1; then
  if [[ -x "${HOME}/.elan/bin/lake" ]]; then
    PATH="${HOME}/.elan/bin:${PATH}"
  else
    echo "matcher_model_check.sh: no lake on the path" >&2
    exit 2
  fi
fi
if [[ $# -eq 0 ]]; then
  set -- "$(date +%s)"
fi
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
zig build matcher-replay
for seed in "$@"; do
  if ! [[ "$seed" =~ ^[0-9]+$ ]]; then
    echo "matcher_model_check.sh: a seed is a number, and '${seed}' is none" >&2
    exit 2
  fi
  (cd spec/lean && lake exe vectors --random "$seed" "$programs") > "$work/vectors.txt"
  if ! ./zig-out/bin/matcher_replay "$work/vectors.txt"; then
    cp "$work/vectors.txt" "zig-out/matcher_vectors_seed_${seed}.txt"
    echo "matcher_model_check.sh: seed ${seed} failed; its vectors are zig-out/matcher_vectors_seed_${seed}.txt" >&2
    exit 1
  fi
  echo "matcher_model_check.sh: seed ${seed} passed"
done
