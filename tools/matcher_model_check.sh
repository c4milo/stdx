#!/usr/bin/env bash
#
# matcher_model_check.sh: the Lean model of the matcher against `Matcher.find` and
# `Searcher.find`, on programs a new seed draws (decision 86, design §8 part 22h).
#
# Each seed runs two parts, and `zig build matcher-replay` builds the program both run:
#
# 1. `lake exe vectors --random` writes programs the seed draws as instructions, some texts for
#    each, and the answer that spec/lean/Stdx/Regex/MatcherAnswer.lean proves for each search.
#    `matcher_replay` runs `Matcher.find` on each and requires the same span.
# 2. `matcher_replay dump` writes the programs that `compile` gives the patterns the seed draws,
#    with a text and its searches. `lake exe vectors --answers` answers each search, and checks
#    that each program and text pass the two hypotheses of the model's theorems
#    (spec/lean/Stdx/Regex/Hypotheses.lean). `matcher_replay` compiles each pattern again and
#    requires the answer of `Matcher.find` and of three searchers: one with every claim, one
#    with none, and one with every claim that read a long text first.
#
# A seed that fails is printed: give it again to see the same failure.
#
# Usage: tools/matcher_model_check.sh [seed...]
#
# With no seed, the seed is the time in seconds, so each run reads programs that no run read
# before. PROGRAMS sets the programs a seed draws as instructions, 4096 by default, and PATTERNS
# the patterns it draws, 4096 by default. It needs lake and zig.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
readonly programs="${PROGRAMS:-4096}"
readonly patterns="${PATTERNS:-4096}"
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

# Replays one file of vectors. A file that fails is kept under zig-out/, named for its seed.
replay() {
  local seed="$1" part="$2"
  if ./zig-out/bin/matcher_replay "$work/${part}.txt"; then
    return 0
  fi
  cp "$work/${part}.txt" "zig-out/matcher_${part}_seed_${seed}.txt"
  echo "matcher_model_check.sh: seed ${seed} failed; its vectors are zig-out/matcher_${part}_seed_${seed}.txt" >&2
  return 1
}

# The canary: a dump whose answers must hold each line `differs <what>`, which the replay must
# then refuse. It shows that a check of the Lean side can fail, and that its line fails a run.
canary() {
  local what
  cat > "$work/canary.txt"
  (cd spec/lean && lake exe vectors --answers "$work/canary.txt") > "$work/canary_answers.txt"
  for what in "$@"; do
    if ! grep -q "^differs ${what}\$" "$work/canary_answers.txt"; then
      echo "matcher_model_check.sh: the canary's answers hold no line 'differs ${what}'" >&2
      exit 1
    fi
  done
  if ./zig-out/bin/matcher_replay "$work/canary_answers.txt" 2>/dev/null; then
    echo "matcher_model_check.sh: the replay passed the canary of 'differs $1'" >&2
    exit 1
  fi
}

zig build matcher-replay
# A node whose two ranges both take `a`, and go to two instructions.
canary exact <<'DUMP'
program bytes 5 0 none
ranges 2
range 97 98 3
range 97 97 4
match
fail
text 1 97
search 0
DUMP
# `ab|a` from 0, and from 4 a reverse half that takes `b` alone.
canary reverses <<'DUMP'
program bytes 6 0 4
split 1 3
range 97 97 2
range 98 98 5
range 97 97 5
range 98 98 5
match
text 3 120 97 98
search 0
DUMP
# `[\x80-\xBF]*a` read as UTF-8, and its reverse half. In the bytes A9 61 a match starts at 1,
# since a match starts at no continuation byte. The program takes both bytes from 0, and the
# reverse scan reads back to 0.
canary starts "dfa 0 gives 0 2" <<'DUMP'
program utf8 8 0 4
split 1 2
range 128 191 0
range 97 97 3
match
range 97 97 5
split 6 7
range 128 191 5
match
text 2 169 97
search 0
DUMP
for seed in "$@"; do
  if ! [[ "$seed" =~ ^[0-9]+$ ]]; then
    echo "matcher_model_check.sh: a seed is a number, and '${seed}' is none" >&2
    exit 2
  fi
  (cd spec/lean && lake exe vectors --random "$seed" "$programs") > "$work/vectors.txt"
  replay "$seed" vectors
  ./zig-out/bin/matcher_replay dump "$seed" "$patterns" "$work/dump.txt"
  (cd spec/lean && lake exe vectors --answers "$work/dump.txt") > "$work/patterns.txt"
  replay "$seed" patterns
  echo "matcher_model_check.sh: seed ${seed} passed"
done
