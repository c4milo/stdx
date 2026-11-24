import Stdx.Regex.MatcherSearch

/-!
# The search's answer as a function

`Search.lean` states the answer of a search as a property. `answerOf` gives it as a function for
a program's text: from each offset in turn where a match may start, the end that the
backtracking matcher finds first, and the first offset that has one.

- `answerOf_isAnswer`: the function's value is the search's answer. So every search of a
  program's text has an answer.

`Vectors.lean` writes this function's values for a set of programs and texts, and a Zig test
requires `Matcher.find` to give the same spans.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-- The match from the least offset, at or after `i`, where a match may start and the
backtracking matcher finds an end: that offset and that end. -/
def answerFrom (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    Nat → Nat → Option (Nat × Nat)
  | 0, _ => none
  | turns + 1, i =>
    match (if starts i then backtrack prog text (turns + 1) i [entry] else none) with
    | some e => some (i, e)
    | none =>
      match text[i]? with
      | none => none
      | some _ => answerFrom prog entry text starts turns (i + 1)

/-- The answer of a search of a program's text from `low`. -/
def answerOf (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (low : Nat) : Option (Nat × Nat) :=
  answerFrom prog entry text starts (text.length - low + 1) low

/-- `answerFrom` gives the search's answer, with one turn for each offset up to the text's
end. -/
theorem answerFrom_isAnswer (prog : Array Inst) (entry : Nat) (text : List Nat)
    (starts : Nat → Bool) (hexact : Exact prog) :
    ∀ turns i, i + turns = text.length + 1 →
      IsAnswer (textOf prog entry text starts hexact) i
        (answerFrom prog entry text starts turns i) := by
  intro turns
  induction turns with
  | zero =>
    intro i hi s e hs hm
    have := hm.1
    omega
  | succ turns ih =>
    intro i hi
    have hturns : text.length - i + 1 = turns + 1 := by omega
    simp only [answerFrom]
    cases hhere : (if starts i = true then backtrack prog text (turns + 1) i [entry] else none) with
    | some e =>
      -- A match starts at `i`, and no start is less.
      have hst : starts i = true := by
        apply Classical.byContradiction
        intro hn
        simp [hn] at hhere
      simp only [hst, ite_true] at hhere
      refine ⟨Nat.le_refl i, ⟨by omega, hst, ?_⟩, fun s' _ hs' _ => hs'⟩
      unfold preferredEnd
      rw [hturns]
      exact hhere
    | none =>
      -- No match starts at `i`.
      have hnone : ∀ e, ¬ (textOf prog entry text starts hexact).Match i e := by
        intro e hm
        obtain ⟨e', _, hst, hp⟩ := (textOf prog entry text starts hexact).prefers_some hm
        unfold preferredEnd at hp
        rw [hturns] at hp
        simp [hst, hp] at hhere
      cases hb : text[i]? with
      | none =>
        intro s e hs hm
        have hlen : s ≤ text.length := hm.1
        have hi' : text.length ≤ i := by
          apply Nat.le_of_not_lt
          intro hlt
          rw [List.getElem?_eq_getElem hlt] at hb
          cases hb
        have hsi : s = i := by omega
        exact hnone e (hsi ▸ hm)
      | some b =>
        have hrest := ih (i + 1) (by omega)
        -- The answer from the next offset is the answer from this one.
        have hlift : ∀ a, IsAnswer (textOf prog entry text starts hexact) (i + 1) a →
            IsAnswer (textOf prog entry text starts hexact) i a := by
          intro a ha
          match a, ha with
          | none, ha =>
            intro s e hs hm
            by_cases hsi : s = i
            · exact hnone e (hsi ▸ hm)
            · exact ha s e (by omega) hm
          | some (s, e), ha =>
            refine ⟨by have := ha.1; omega, ha.2.1, ?_⟩
            intro s' e' hs' hm
            by_cases hsi : s' = i
            · exact absurd (hsi ▸ hm) (hnone e')
            · exact ha.2.2 s' e' (by omega) hm
        exact hlift _ hrest

/-- The function's value is the search's answer: the least start of a match, and the end that
the backtracking matcher finds first from it. -/
theorem answerOf_isAnswer (prog : Array Inst) (entry : Nat) (text : List Nat)
    (starts : Nat → Bool) (hexact : Exact prog) {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low (answerOf prog entry text starts low) :=
  answerFrom_isAnswer prog entry text starts hexact _ low (by omega)

end Stdx.Regex.Matcher
