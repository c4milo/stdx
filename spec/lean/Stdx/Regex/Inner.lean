import Stdx.Regex.Suffix

/-!
# Claim R14: the search from a literal in a match's middle

Every match of a pattern such as `\w+@\w+` holds a literal in its middle. Claim R14 goes to each
place of the literal in turn (decision 86). The reverse DFA reads back from the place through the
part of the pattern before the literal, to the least start of that part. The forward DFA then
reads the whole pattern from that start. `byInner` is that loop.

`Inner` says what a literal in the middle is: a match is a part before the literal, the literal
at a place, and a part after it. The precondition is `BeforeRising`, a rule for the part before
the literal alone: of two places, the later one has no earlier start. The part after the literal
is free, and its length may vary, since the forward scan finds the end.

- `byInner_answer`: under `BeforeRising`, the loop gives the matcher's answer.
- Three rules give `BeforeRising`, each for the part before the literal: a byte of the literal
  stands nowhere in it (`beforeRising_of_clean`), it takes one count of bytes
  (`beforeRising_of_one_count`), or it ends with a separator (`beforeRising_of_last_separator`).

The loop goes on to the next place where a forward scan finds no match. The Zig loop then leaves
the places where the next one stands before the byte that scan stopped at, and the plain search
answers. This file does not model that guard: it costs a search its fast path and no answer.
-/
namespace Stdx.Regex.Search

/-- A literal that every match holds in its middle. `Before s p` holds where the part of the
pattern before the literal matches the bytes from `s` up to `p`, and `After q e` where the part
after it matches the bytes from `q` up to `e`. `backBefore` is the reverse DFA's scan from its
second start: the least start, at or after the first offset, of a part before the literal that
ends at the second. -/
structure Inner (t : Text) (c : Scans t) where
  /-- The part before the literal matches the bytes from the first offset up to the second. -/
  Before : Nat → Nat → Prop
  /-- The part after the literal matches the bytes from the first offset up to the second. -/
  After : Nat → Nat → Prop
  /-- The reverse scan of the part before the literal. -/
  backBefore : Nat → Nat → Option Nat
  /-- The part before the literal ends at or after its start. -/
  before_inside : ∀ {s p}, Before s p → s ≤ p
  /-- A match holds the literal: a part before it, the literal at a place, and a part after. -/
  split : ∀ {s e}, t.Match s e → ∃ p, Before s p ∧ c.Stands p ∧ After (p + c.width) e
  /-- The three parts make a match. -/
  join : ∀ {s p e}, Before s p → c.Stands p → After (p + c.width) e → t.Match s e
  /-- `backBefore` gives a start of the part before the literal. -/
  back_some : ∀ {low p s}, backBefore low p = some s → low ≤ s ∧ Before s p
  /-- `backBefore` gives the least such start. -/
  back_least : ∀ {low p s s'}, backBefore low p = some s → low ≤ s' → Before s' p → s ≤ s'
  /-- `backBefore` gives nothing where no part before the literal ends at the place. -/
  back_none : ∀ {low p s}, backBefore low p = none → low ≤ s → ¬ Before s p

/-- Of two places of the literal, the later one has no earlier start of the part before it. -/
def BeforeRising {t : Text} {c : Scans t} (n : Inner t c) : Prop :=
  ∀ s p s' p', n.Before s p → c.Stands p → n.Before s' p' → c.Stands p' → p < p' → s ≤ s'

/-- `searcher_inner.find`: from `index`, the first place of the literal where the reverse scan
finds a start of the part before it and the forward scan from that start finds a match. -/
def byInner {t : Text} {c : Scans t} (n : Inner t c) (low : Nat) :
    Nat → Nat → Option (Nat × Nat)
  | 0, _ => none
  | turns + 1, index =>
    match c.place index with
    | none => none
    | some p =>
      match n.backBefore low p with
      | none => byInner n low turns (p + 1)
      | some s =>
        match c.ahead s with
        | none => byInner n low turns (p + 1)
        | some e => some (s, e)

/-- A turn ends the search where no place follows. -/
theorem byInner_none {t : Text} {c : Scans t} {n : Inner t c} {low turns index : Nat}
    (hplace : c.place index = none) : byInner n low (turns + 1) index = none := by
  simp [byInner, hplace]

/-- A turn goes on from a place that no part before the literal ends at. -/
theorem byInner_next {t : Text} {c : Scans t} {n : Inner t c} {low turns index p : Nat}
    (hplace : c.place index = some p) (hback : n.backBefore low p = none) :
    byInner n low (turns + 1) index = byInner n low turns (p + 1) := by
  simp [byInner, hplace, hback]

/-- A turn goes on from a place whose start has no match. -/
theorem byInner_failed {t : Text} {c : Scans t} {n : Inner t c} {low turns index p s : Nat}
    (hplace : c.place index = some p) (hback : n.backBefore low p = some s)
    (hahead : c.ahead s = none) :
    byInner n low (turns + 1) index = byInner n low turns (p + 1) := by
  simp [byInner, hplace, hback, hahead]

/-- A turn ends the search at a place whose start has a match. -/
theorem byInner_found {t : Text} {c : Scans t} {n : Inner t c} {low turns index p s e : Nat}
    (hplace : c.place index = some p) (hback : n.backBefore low p = some s)
    (hahead : c.ahead s = some e) :
    byInner n low (turns + 1) index = some (s, e) := by
  simp [byInner, hplace, hback, hahead]

/-- The loop's step: while no match from `low` holds its literal before `index`, the loop from
`index` gives the matcher's answer. -/
theorem byInner_from {t : Text} {c : Scans t} {n : Inner t c} {low : Nat}
    (hrising : BeforeRising n) :
    ∀ turns index, t.len + 1 ≤ index + turns →
      (∀ s p e, low ≤ s → n.Before s p → c.Stands p → n.After (p + c.width) e → index ≤ p) →
      IsAnswer t low (byInner n low turns index) := by
  intro turns
  induction turns with
  | zero =>
    intro index hturns hinv s e hlow hm
    have ⟨p, hb, hs, ha⟩ := n.split hm
    have h1 := hinv s p e hlow hb hs ha
    have h2 := c.stands_inside hs
    omega
  | succ turns ih =>
    intro index hturns hinv
    cases hplace : c.place index with
    | none =>
      rw [byInner_none hplace]
      intro s e hlow hm
      have ⟨p, hb, hs, ha⟩ := n.split hm
      exact c.place_none hplace (hinv s p e hlow hb hs ha) hs
    | some p =>
      have hp := c.place_some hplace
      -- A match that holds its literal at or after `index` holds it at `p` or later.
      have hfirst : ∀ s q e, low ≤ s → n.Before s q → c.Stands q → n.After (q + c.width) e →
          p ≤ q := by
        intro s q e hlow hb hs ha
        apply Nat.le_of_not_lt
        intro hlt
        exact c.place_first hplace (hinv s q e hlow hb hs ha) hlt hs
      cases hback : n.backBefore low p with
      | none =>
        rw [byInner_next hplace hback]
        apply ih (p + 1) (by omega)
        intro s q e hlow hb hs ha
        cases Nat.lt_or_eq_of_le (hfirst s q e hlow hb hs ha) with
        | inl hlt => exact hlt
        | inr heq => exact absurd (heq ▸ hb) (n.back_none hback hlow)
      | some s0 =>
        have hb0 := n.back_some hback
        cases hahead : c.ahead s0 with
        | none =>
          rw [byInner_failed hplace hback hahead]
          apply ih (p + 1) (by omega)
          intro s q e hlow hb hs ha
          cases Nat.lt_or_eq_of_le (hfirst s q e hlow hb hs ha) with
          | inl hlt => exact hlt
          | inr heq =>
            -- A part after the literal at `p` would give a match from `s0`.
            subst heq
            exact absurd (n.join hb0.2 hp.2 ha) (c.ahead_none hahead)
        | some e0 =>
          rw [byInner_found hplace hback hahead]
          refine ⟨hb0.1, c.ahead_some hahead, ?_⟩
          intro s' e' hlow hm
          have ⟨q, hb, hs, ha⟩ := n.split hm
          cases Nat.lt_or_eq_of_le (hfirst s' q e' hlow hb hs ha) with
          | inl hlt => exact hrising s0 p s' q hb0.2 hp.2 hb hs hlt
          | inr heq => exact n.back_least hback hlow (heq ▸ hb)

/-- Claim R14: where every match holds the literal in its middle and `BeforeRising` holds, the
search from the literal's places gives the matcher's answer from `low`. -/
theorem byInner_answer {t : Text} {c : Scans t} {n : Inner t c} {low : Nat}
    (hrising : BeforeRising n) (hlow : low ≤ t.len) :
    IsAnswer t low (byInner n low (t.len - low + 1) low) := by
  apply byInner_from hrising _ _ (by omega)
  intro s p e hs hb _ _
  have := n.before_inside hb
  omega

/-! ## The rules that give `BeforeRising` -/

/-- A marked byte of the literal that stands nowhere in the part before it gives `BeforeRising`.
With the literal's first byte this is claim R4's first rule. -/
theorem beforeRising_of_clean {t : Text} {c : Scans t} {n : Inner t c} {Mark : Nat → Prop}
    (hclean : ∀ s p, n.Before s p → ∀ q, s ≤ q → q < p → ¬ Mark q) (hgap : Gap c Mark) :
    BeforeRising n := by
  intro s p s' p' hb hs hb' hs' hlt
  apply Nat.le_of_not_lt
  intro hss
  have ⟨q, hq1, hq2, hmark⟩ := hgap p p' hs hs' hlt
  have := n.before_inside hb
  exact hclean s' p' hb' q (by omega) hq2 hmark

/-- A part before the literal that takes one count of bytes gives `BeforeRising`. The part after
the literal may take any count. -/
theorem beforeRising_of_one_count {t : Text} {c : Scans t} {n : Inner t c} {count : Nat}
    (hcount : ∀ s p, n.Before s p → p = s + count) : BeforeRising n := by
  intro s p s' p' hb _ hb' _ hlt
  have := hcount s p hb
  have := hcount s' p' hb'
  omega

/-- A separator at the end of the part before the literal gives `BeforeRising`. The part ends
with a separator, a separator in it has separators alone after it, and the literal's first byte
is no separator. -/
theorem beforeRising_of_last_separator {t : Text} {c : Scans t} {n : Inner t c}
    {Sep : Nat → Prop}
    (hlast : ∀ s p, n.Before s p → s < p ∧ Sep (p - 1))
    (htail : ∀ s p, n.Before s p → ∀ q r, s ≤ q → q ≤ r → r < p → Sep q → Sep r)
    (hliteral : ∀ p, c.Stands p → ¬ Sep p) : BeforeRising n := by
  intro s p s' p' hb hs hb' _ hlt
  apply Nat.le_of_not_lt
  intro hss
  have hl := hlast s p hb
  have hsep := htail s' p' hb' (p - 1) p (by omega) (by omega) hlt hl.2
  exact hliteral p hs hsep

end Stdx.Regex.Search
