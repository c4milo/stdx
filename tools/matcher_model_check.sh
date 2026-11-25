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
#    that each program and text pass the hypotheses of the model's theorems
#    (spec/lean/Stdx/Regex/Hypotheses.lean). It also checks that a rule of claim R4 or the
#    rule of claim R14 holds for each literal a searcher took by it, a literal with a place
#    that folds among them (spec/lean/Stdx/Regex/Rules.lean, RulesSeparator.lean and
#    RulesInner.lean).
#    `matcher_replay` compiles each pattern again and requires the answer of `Matcher.find`
#    and of four searchers: one with every claim, one with none, one with every claim that
#    read a long text first, and one with every claim and a small cache. One case in eight
#    takes a text of up to 1,024 bytes.
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
# `[a-c]+ab` and its reverse half `ba[a-c]+`, with the claim that the literal `ab` ends every
# match under claim R4's first rule. The part before the literal takes `a`, so the rule fails.
canary "claim suffix" <<'DUMP'
program bytes 10 0 5
range 97 99 1
split 0 2
range 97 97 3
range 98 98 4
match
range 98 98 6
range 97 97 7
range 97 99 8
split 7 9
match
claim suffix 2 97 98
text 3 99 97 98
search 0
DUMP
# The same program, with the claim that a searcher took `ab` after it read enough text. The
# part before the literal takes one byte or more, and ends with no separator: neither the
# second rule nor the third holds.
canary "claim suffix-wide" <<'DUMP'
program bytes 10 0 5
range 97 99 1
split 0 2
range 97 97 3
range 98 98 4
match
range 98 98 6
range 97 97 7
range 97 99 8
split 7 9
match
claim suffix-wide 2 97 98
text 3 99 97 98
search 0
DUMP
# `[0-9A]+(?i:a)b` and its reverse half `b(?i:a)[0-9A]+`, with the claim that the literal `ab`
# ends every match under the first rule, its first place in either case. The part before the
# literal takes `A`, which that place takes, so the rule fails. It holds for `a` alone.
canary "claim suffix" <<'DUMP'
program bytes 18 0 9
ranges 2
range 48 57 3
range 65 65 3
split 0 4
split 5 6
range 97 97 7
range 65 65 7
range 98 98 8
match
range 98 98 10
split 11 12
range 97 97 13
range 65 65 13
ranges 2
range 48 57 16
range 65 65 16
split 13 17
match
claim suffix 2 97 98 folds 1
text 3 49 65 98
search 0
DUMP
# `[a-c]+@[a-c]+` and its reverse half, which has the same form. Every match holds `@`, and
# the reverse program stands at 9 after it. The claim names 10: the walk of the literal stands
# at no such instruction.
canary "claim inner" <<'DUMP'
program bytes 12 0 6
range 97 99 1
split 0 2
range 64 64 3
range 97 99 4
split 3 5
match
range 97 99 7
split 6 8
range 64 64 9
range 97 99 10
split 9 11
match
claim inner 10 1 64
text 4 97 98 64 99
search 0
DUMP
# `(?:a@|b)c` and its reverse half `c(?:@a|b)`. The reverse program takes `@` at 8 and stands at
# 9 after it, and the part before takes no `@`. A match of `bc` passes no `@`, so not every
# match passes 8.
canary "claim inner" <<'DUMP'
program bytes 12 0 6
split 1 3
range 97 97 2
range 64 64 4
range 98 98 4
range 99 99 5
match
range 99 99 7
split 8 10
range 64 64 9
range 97 97 11
range 98 98 11
match
claim inner 9 1 64
text 3 97 64 99
search 0
DUMP
# `[a-c@]+@[a-c]+` and its reverse half. Every match passes the `@` at 10, and the reverse
# program stands at 11 after it. The part before takes `@`, takes more than one count of bytes,
# and ends with no separator that the literal does not start with: no rule holds for it.
canary "claim inner" <<'DUMP'
program bytes 16 0 8
ranges 2
range 64 64 3
range 97 99 3
split 0 4
range 64 64 5
range 97 99 6
split 5 7
match
range 97 99 9
split 8 10
range 64 64 11
ranges 2
range 64 64 14
range 97 99 14
split 11 15
match
claim inner 11 1 64
text 4 97 64 64 98
search 0
DUMP
# `a*` read as UTF-8, with a claim. In the bytes C3 A9 it matches the empty text at 1, where
# no match may start. That match is empty, so the search with no claim keeps its hypothesis,
# and the theorem of a claim does not.
canary "starts-clean" <<'DUMP'
program utf8 3 0 none
split 1 2
range 97 97 0
match
claim suffix 1 97
text 2 195 169
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
