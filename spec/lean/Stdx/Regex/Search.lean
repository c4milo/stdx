/-!
# What a search must answer, and the places of a literal

`Searcher` answers as `Matcher` answers (decision 86). This file holds what the two share, with
no program in it: the spans a pattern matches in one text, the answer the matcher gives from an
offset, and the places where a literal stands. Each claim of the searcher is then a function over
three scans, and a theorem that the function gives the matcher's answer.

- `Text` is one text as a search reads it: its length, the spans that match, and the end that the
  pattern's order prefers from each start.
- `IsAnswer` says what the matcher gives from an offset: RE2's leftmost-first match.
- `Scans` holds the three scans a claim calls, each with what it must give: `Literal.find`, the
  reverse DFA's scan and the forward DFA's scan from a match's start.

Offsets are natural numbers. A span is its start and its end, the end not included.
-/
namespace Stdx.Regex.Search

/-- One text as a search reads it. `Match s e` holds where the pattern matches the bytes from `s`
up to `e`. `Prefers s e` holds where `e` is the end of the match that the pattern's order prefers
among the matches that start at `s`: the match a backtracking matcher finds first there. -/
structure Text where
  /-- The text's length in bytes. -/
  len : Nat
  /-- The pattern matches the bytes from the first offset up to the second. -/
  Match : Nat → Nat → Prop
  /-- The second offset ends the match that the pattern's order prefers from the first. -/
  Prefers : Nat → Nat → Prop
  /-- A match lies in the text. -/
  inside : ∀ {s e}, Match s e → s ≤ e ∧ e ≤ len
  /-- The preferred match is a match. -/
  prefers_match : ∀ {s e}, Prefers s e → Match s e
  /-- A start with a match has a preferred match. -/
  prefers_some : ∀ {s e}, Match s e → ∃ e', Prefers s e'
  /-- A start has one preferred match. -/
  prefers_one : ∀ {s e e'}, Prefers s e → Prefers s e' → e = e'

/-- What the matcher gives for a search from `low`: nothing where no match starts at or after
`low`, and otherwise the least such start with the end the pattern's order prefers there. -/
def IsAnswer (t : Text) (low : Nat) : Option (Nat × Nat) → Prop
  | none => ∀ s e, low ≤ s → ¬ t.Match s e
  | some (s, e) => low ≤ s ∧ t.Prefers s e ∧ ∀ s' e', low ≤ s' → t.Match s' e' → s ≤ s'

/-- A search has one answer. -/
theorem answer_one {t : Text} {low : Nat} {a b : Option (Nat × Nat)}
    (ha : IsAnswer t low a) (hb : IsAnswer t low b) : a = b := by
  match a, b with
  | none, none => rfl
  | none, some (s, e) =>
    exact absurd (t.prefers_match hb.2.1) (ha s e hb.1)
  | some (s, e), none =>
    exact absurd (t.prefers_match ha.2.1) (hb s e ha.1)
  | some (s, e), some (s', e') =>
    have h1 : s ≤ s' := ha.2.2 s' e' hb.1 (t.prefers_match hb.2.1)
    have h2 : s' ≤ s := hb.2.2 s e ha.1 (t.prefers_match ha.2.1)
    have hs : s = s' := Nat.le_antisymm h1 h2
    subst hs
    have he : e = e' := t.prefers_one ha.2.1 hb.2.1
    subst he
    rfl

/-- The scans a claim calls on one text, for a literal of `width` bytes, each with what it gives.
`Stands p` holds where the literal stands whole at `p`. -/
structure Scans (t : Text) where
  /-- The literal's length in bytes. -/
  width : Nat
  /-- The literal stands whole at the offset. -/
  Stands : Nat → Prop
  /-- `Literal.find`: the first place of the literal at or after an offset. -/
  place : Nat → Option Nat
  /-- The reverse DFA's scan: the least start, at or after the first offset, of a match that ends
  at the second. -/
  back : Nat → Nat → Option Nat
  /-- The forward DFA's scan from a match's start: the end the pattern's order prefers. -/
  ahead : Nat → Option Nat
  /-- A literal holds one byte or more. -/
  width_pos : 0 < width
  /-- A place lies in the text. -/
  stands_inside : ∀ {p}, Stands p → p + width ≤ t.len
  /-- `place` gives a place at or after the offset. -/
  place_some : ∀ {i p}, place i = some p → i ≤ p ∧ Stands p
  /-- `place` gives the first such place. -/
  place_first : ∀ {i p q}, place i = some p → i ≤ q → q < p → ¬ Stands q
  /-- `place` gives nothing where no place follows. -/
  place_none : ∀ {i q}, place i = none → i ≤ q → ¬ Stands q
  /-- `back` gives a start of a match that ends at the offset. -/
  back_some : ∀ {low e s}, back low e = some s → low ≤ s ∧ t.Match s e
  /-- `back` gives the least such start. -/
  back_least : ∀ {low e s s'}, back low e = some s → low ≤ s' → t.Match s' e → s ≤ s'
  /-- `back` gives nothing where no such match ends at the offset. -/
  back_none : ∀ {low e s}, back low e = none → low ≤ s → ¬ t.Match s e
  /-- `ahead` gives the preferred end. -/
  ahead_some : ∀ {s e}, ahead s = some e → t.Prefers s e
  /-- `ahead` gives nothing where no match starts at the offset. -/
  ahead_none : ∀ {s e}, ahead s = none → ¬ t.Match s e

/-- Every match ends with the literal: the literal stands whole at the match's end, inside the
match. -/
def EndsWith (t : Text) (c : Scans t) : Prop :=
  ∀ s e, t.Match s e → s + c.width ≤ e ∧ c.Stands (e - c.width)

/-- The place of the literal that ends a match stands at or after the match's start. -/
theorem place_of_match {t : Text} {c : Scans t} (hends : EndsWith t c) {s e : Nat}
    (hm : t.Match s e) : s ≤ e - c.width ∧ c.Stands (e - c.width) ∧ e - c.width + c.width = e := by
  have h := hends s e hm
  exact ⟨by omega, h.2, by omega⟩

end Stdx.Regex.Search
