import Stdx.Regex.Search

/-!
# Claim R4: the search from the literal every match ends with

`Searcher.find_by_suffix` goes to each place of the literal in turn, and the reverse DFA reads
back from the place's end to the least start of a match that ends there (decision 86, claim R4,
`src/regex/dfa/dfa_suffix.zig`). `bySuffix` is that loop, over the scans of `Search.lean`.

The claim has two preconditions, and `bySuffix_answer` needs both:

- `EndsWith`: every match ends with the literal.
- `CleanBefore` for a mark with `Gap`: some byte of the literal stands in no part of a match
  before its literal. `Mark q` holds where the text holds that byte at `q`.

Claim R4 takes the literal's first byte as the mark, and `first_gap` gives its `Gap`. The proof
reads the mark through `Gap` alone, so it holds for any byte of the literal that the part before
never takes: `Required.lean` says which rule that widens.

Three theorems:

- `bySuffix_answer`: the loop gives the matcher's answer.
- `one_end`: every match from one start ends at one offset, so the loop needs no forward scan.
- `starts_after_place`: a match that ends at a place starts after every place before it. So a
  reverse scan reads no start at or before the place before its own, and a search stays linear
  in the text.
-/
namespace Stdx.Regex.Search

/-- No part of a match before its literal holds a marked byte. -/
def CleanBefore (t : Text) (c : Scans t) (Mark : Nat → Prop) : Prop :=
  ∀ s e, t.Match s e → ∀ q, s ≤ q → q < e - c.width → ¬ Mark q

/-- A marked byte stands from each place of the literal up to the next place. -/
def Gap {t : Text} (c : Scans t) (Mark : Nat → Prop) : Prop :=
  ∀ p p', c.Stands p → c.Stands p' → p < p' → ∃ q, p ≤ q ∧ q < p' ∧ Mark q

/-- The literal's first byte is a mark with `Gap`: it stands at each place. -/
theorem first_gap {t : Text} {c : Scans t} {Mark : Nat → Prop}
    (hfirst : ∀ p, c.Stands p → Mark p) : Gap c Mark :=
  fun p _ hp _ hlt => ⟨p, Nat.le_refl p, hlt, hfirst p hp⟩

/-- `Searcher.find_by_suffix`: from `index`, the first place of the literal from whose end the
reverse scan reads back to a match's start, in at most `turns` turns. -/
def bySuffix {t : Text} (c : Scans t) (low : Nat) : Nat → Nat → Option (Nat × Nat)
  | 0, _ => none
  | turns + 1, index =>
    match c.place index with
    | none => none
    | some p =>
      match c.back low (p + c.width) with
      | none => bySuffix c low turns (p + 1)
      | some s => some (s, p + c.width)

/-- A turn ends the search where no place follows. -/
theorem bySuffix_none {t : Text} {c : Scans t} {low turns index : Nat}
    (hplace : c.place index = none) : bySuffix c low (turns + 1) index = none := by
  simp [bySuffix, hplace]

/-- A turn goes on from one byte past a place that ends no match. -/
theorem bySuffix_next {t : Text} {c : Scans t} {low turns index p : Nat}
    (hplace : c.place index = some p) (hback : c.back low (p + c.width) = none) :
    bySuffix c low (turns + 1) index = bySuffix c low turns (p + 1) := by
  simp [bySuffix, hplace, hback]

/-- A turn ends the search at a place that ends a match. -/
theorem bySuffix_found {t : Text} {c : Scans t} {low turns index p s : Nat}
    (hplace : c.place index = some p) (hback : c.back low (p + c.width) = some s) :
    bySuffix c low (turns + 1) index = some (s, p + c.width) := by
  simp [bySuffix, hplace, hback]

/-- Under claim R4's preconditions, a match whose start is at or before a place ends at that
place or before it. -/
theorem ends_by_place {t : Text} {c : Scans t} {Mark : Nat → Prop}
    (hclean : CleanBefore t c Mark) (hgap : Gap c Mark) (hends : EndsWith t c)
    {s e p : Nat} (hm : t.Match s e) (hp : c.Stands p) (hsp : s ≤ p) : e - c.width ≤ p := by
  have hq := place_of_match hends hm
  apply Nat.le_of_not_lt
  intro hlt
  have ⟨q, hq1, hq2, hmark⟩ := hgap p (e - c.width) hp hq.2.1 hlt
  exact hclean s e hm q (Nat.le_trans hsp hq1) hq2 hmark

/-- Every match from one start ends at one offset: the search needs no forward scan. -/
theorem one_end {t : Text} {c : Scans t} {Mark : Nat → Prop}
    (hclean : CleanBefore t c Mark) (hgap : Gap c Mark) (hends : EndsWith t c)
    {s e e' : Nat} (hm : t.Match s e) (hm' : t.Match s e') : e = e' := by
  have hq := place_of_match hends hm
  have hq' := place_of_match hends hm'
  have h1 := ends_by_place hclean hgap hends hm hq'.2.1 hq'.1
  have h2 := ends_by_place hclean hgap hends hm' hq.2.1 hq.1
  omega

/-- A match that ends at a place starts after every place before it. The reverse scan from a
place therefore reads no start at or before the place before its own. -/
theorem starts_after_place {t : Text} {c : Scans t} {Mark : Nat → Prop}
    (hclean : CleanBefore t c Mark) (hgap : Gap c Mark)
    {s p q : Nat} (hm : t.Match s (p + c.width)) (hp : c.Stands p) (hq : c.Stands q)
    (hqp : q < p) : q < s := by
  apply Nat.lt_of_not_le
  intro hsq
  have ⟨m, hm1, hm2, hmark⟩ := hgap q p hq hp hqp
  exact hclean s (p + c.width) hm m (Nat.le_trans hsq hm1) (by omega) hmark

/-- The loop's step: while every match from `low` ends at a place at or after `index`, the loop
from `index` gives the matcher's answer. -/
theorem bySuffix_from {t : Text} {c : Scans t} {Mark : Nat → Prop} {low : Nat}
    (hclean : CleanBefore t c Mark) (hgap : Gap c Mark) (hends : EndsWith t c) :
    ∀ turns index, t.len + 1 ≤ index + turns →
      (∀ s e, low ≤ s → t.Match s e → index ≤ e - c.width) →
      IsAnswer t low (bySuffix c low turns index) := by
  intro turns
  induction turns with
  | zero =>
    intro index hturns hinv s e hlow hm
    have h1 := hinv s e hlow hm
    have h2 := (t.inside hm).2
    omega
  | succ turns ih =>
    intro index hturns hinv
    cases hplace : c.place index with
    | none =>
      rw [bySuffix_none hplace]
      intro s e hlow hm
      exact c.place_none hplace (hinv s e hlow hm) (place_of_match hends hm).2.1
    | some p =>
      have hp := c.place_some hplace
      cases hback : c.back low (p + c.width) with
      | none =>
        rw [bySuffix_next hplace hback]
        apply ih (p + 1) (by omega)
        intro s e hlow hm
        have hq := place_of_match hends hm
        have h1 := hinv s e hlow hm
        apply Nat.lt_of_not_le
        intro hle
        cases Nat.lt_or_eq_of_le hle with
        | inl hlt => exact c.place_first hplace h1 hlt hq.2.1
        | inr heq =>
          have he : e = p + c.width := by omega
          exact c.back_none hback hlow (he ▸ hm)
      | some s0 =>
        rw [bySuffix_found hplace hback]
        have hb := c.back_some hback
        have hs0p : s0 ≤ p := by
          have := (place_of_match hends hb.2).1
          omega
        refine ⟨hb.1, ?_, ?_⟩
        · have ⟨e2, hpref⟩ := t.prefers_some hb.2
          have he : p + c.width = e2 := one_end hclean hgap hends hb.2 (t.prefers_match hpref)
          exact he ▸ hpref
        · intro s' e' hlow hm
          apply Nat.le_of_not_lt
          intro hlt
          have hq := place_of_match hends hm
          have h1 := hinv s' e' hlow hm
          have h2 := ends_by_place hclean hgap hends hm hp.2 (by omega)
          cases Nat.lt_or_eq_of_le h2 with
          | inl hlt2 => exact c.place_first hplace h1 hlt2 hq.2.1
          | inr heq =>
            have he : e' = p + c.width := by omega
            have := c.back_least hback hlow (he ▸ hm)
            omega

/-- Claim R4: where every match ends with the literal, and a marked byte of the literal stands
in no part of a match before it, `find_by_suffix` gives the matcher's answer from `low`. The loop
takes at most one turn for each byte from `low` and one more, as the Zig loop is bounded. -/
theorem bySuffix_answer {t : Text} {c : Scans t} {Mark : Nat → Prop} {low : Nat}
    (hclean : CleanBefore t c Mark) (hgap : Gap c Mark) (hends : EndsWith t c)
    (hlow : low ≤ t.len) :
    IsAnswer t low (bySuffix c low (t.len - low + 1) low) := by
  apply bySuffix_from hclean hgap hends _ _ (by omega)
  intro s e hs hm
  have := (place_of_match hends hm).1
  omega

end Stdx.Regex.Search
