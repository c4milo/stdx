import Stdx.Regex.Search

/-!
# Claims R11, R12 and R13: a pattern that holds a text's edges

A pattern may assert the text's start before it takes a byte, and the text's end after its last
(decision 86). Each claim is one scan or none, over the scans of `Search.lean`:

- Claim R11, `atStart`: where every match starts at the text's start, the forward scan anchored
  at the search's first offset gives the answer. `atStart_answer`.
- Claim R12, `fromEnd`: where every match ends at the text's end, the reverse scan from there
  gives the least start, and the match ends at the text's end. `fromEnd_answer`.
- Claim R13: where both hold, a text shorter than the least match or longer than the greatest
  holds no match. `excluded_answer`, and `excludes_iff` for the one compare that
  `Searcher.excludes` makes on wrapping words of 64 bits.
-/
namespace Stdx.Regex.Search

/-- Claim R11's search: the forward scan anchored at `low`. -/
def atStart {t : Text} (c : Scans t) (low : Nat) : Option (Nat × Nat) :=
  match c.ahead low with
  | none => none
  | some e => some (low, e)

/-- Claim R11: where every match starts at the text's start, the anchored forward scan from `low`
gives the matcher's answer from `low`. Past the text's start it finds nothing. -/
theorem atStart_answer {t : Text} {c : Scans t} {low : Nat}
    (hstart : ∀ s e, t.Match s e → s = 0) : IsAnswer t low (atStart c low) := by
  unfold atStart
  cases hahead : c.ahead low with
  | none =>
    intro s e hlow hm
    have hs := hstart s e hm
    have hl : s = low := by omega
    exact c.ahead_none hahead (hl ▸ hm)
  | some e =>
    have hpref := c.ahead_some hahead
    have hzero := hstart low e (t.prefers_match hpref)
    refine ⟨Nat.le_refl low, hpref, ?_⟩
    intro s' e' _ _
    omega

/-- Claim R12's search: the reverse scan from the text's end, back to `low`. -/
def fromEnd {t : Text} (c : Scans t) (low : Nat) : Option (Nat × Nat) :=
  match c.back low t.len with
  | none => none
  | some s => some (s, t.len)

/-- Claim R12: where every match ends at the text's end, the reverse scan from there gives the
matcher's answer from `low`, with no forward scan. -/
theorem fromEnd_answer {t : Text} {c : Scans t} {low : Nat}
    (hend : ∀ s e, t.Match s e → e = t.len) : IsAnswer t low (fromEnd c low) := by
  unfold fromEnd
  cases hback : c.back low t.len with
  | none =>
    intro s e hlow hm
    exact c.back_none hback hlow (hend s e hm ▸ hm)
  | some s0 =>
    have hb := c.back_some hback
    refine ⟨hb.1, ?_, ?_⟩
    · have ⟨e2, hpref⟩ := t.prefers_some hb.2
      have he := hend s0 e2 (t.prefers_match hpref)
      exact he ▸ hpref
    · intro s' e' hlow hm
      exact c.back_least hback hlow (hend s' e' hm ▸ hm)

/-- Claim R13: where every match is the whole text, and a match holds from `least` to `greatest`
bytes, a text of another length holds no match. -/
theorem excluded_answer {t : Text} {low least greatest : Nat}
    (hstart : ∀ s e, t.Match s e → s = 0) (hend : ∀ s e, t.Match s e → e = t.len)
    (hlength : ∀ s e, t.Match s e → least ≤ e - s ∧ e - s ≤ greatest)
    (hout : t.len < least ∨ greatest < t.len) : IsAnswer t low none := by
  intro s e _ hm
  have := hstart s e hm
  have := hend s e hm
  have := hlength s e hm
  omega

/-- `Searcher.excludes`, the one compare of claim R13 on words of 64 bits: a text's length less
the least length, wrapped, is past the span of lengths exactly where the length is under the
least or over the greatest. -/
theorem excludes_iff {len least span : Nat} (hlen : len < 2 ^ 64)
    (hspan : least + span < 2 ^ 64) :
    (len + 2 ^ 64 - least) % 2 ^ 64 > span ↔ len < least ∨ least + span < len := by
  omega

end Stdx.Regex.Search
