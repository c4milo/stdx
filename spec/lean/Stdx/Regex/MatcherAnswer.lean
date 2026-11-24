import Stdx.Regex.MatcherSearch

/-!
# The search's answer as a function

`Search.lean` states the answer of a search as a property. `answerOf` gives it as a function for
a program's text: from each offset in turn where a match may start, the end that the
backtracking matcher finds first, and the first offset that has one.

- `answerOf_isAnswer`: the function's value is the search's answer. So every search of a
  program's text has an answer.
- `answerFast` gives the same value by the matcher of `Matcher.lean`, which reads each
  instruction once at a position, and `answerFast_isAnswer` proves it. It is the function
  that the vector writer runs.

`Vectors.lean` writes `answerFast`'s values for a set of programs and texts, and a Zig test
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

/-- `answerFrom`, with the matcher in the backtracking matcher's place. The matcher takes each
byte once for all its threads, so this function is the one to run on a long text. -/
def answerFastFrom (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    Nat → Nat → Option (Nat × Nat)
  | 0, _ => none
  | turns + 1, i =>
    match (if starts i then run prog text (turns + 1) i [entry] none else none) with
    | some e => some (i, e)
    | none =>
      match text[i]? with
      | none => none
      | some _ => answerFastFrom prog entry text starts turns (i + 1)

/-- The answer of a search from `low`, by the matcher from each offset in turn. -/
def answerFast (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (low : Nat) : Option (Nat × Nat) :=
  answerFastFrom prog entry text starts (text.length - low + 1) low

/-- The matcher from each offset gives what the backtracking matcher from each offset gives. -/
theorem answerFastFrom_eq (prog : Array Inst) (entry : Nat) (text : List Nat)
    (starts : Nat → Bool) :
    ∀ turns i, answerFastFrom prog entry text starts turns i =
      answerFrom prog entry text starts turns i := by
  intro turns
  induction turns with
  | zero => intro i; rfl
  | succ turns ih =>
    intro i
    simp only [answerFastFrom, answerFrom, run_eq, Option.or_none, ih]

/-- `answerFast` is the search's answer. -/
theorem answerFast_isAnswer (prog : Array Inst) (entry : Nat) (text : List Nat)
    (starts : Nat → Bool) (hexact : Exact prog) {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low (answerFast prog entry text starts low) := by
  unfold answerFast
  rw [answerFastFrom_eq]
  exact answerOf_isAnswer prog entry text starts hexact hlow

/-! ## A span held to the answer by two passes

`answerFast` runs the matcher from each offset in turn, which takes a time that grows with the
square of a long text where each start reads far. `isAnswerOf` decides whether a span, from any
source, is the answer: one pass of the matcher from the span's start, and one pass of the search
that may start a match before that start alone. The vector writer takes a span from the two
DFAs' scans and holds it to the answer this way, so a long text costs four passes. -/

/-- Whether `a` is the answer of a search from `low`. For no match, the search finds none. For
a span, a match may start at its start, the matcher from that start gives its end, and the
search that may start a match before that start alone finds none. -/
def isAnswerOf (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (low : Nat) : Option (Nat × Nat) → Bool
  | none => (search prog entry text starts (text.length - low + 1) low [] none).isNone
  | some (s, e) =>
    decide (low ≤ s) && decide (s ≤ text.length) && starts s &&
      (findAt prog entry text s == some e) &&
      (search prog entry text (fun i => starts i && decide (i < s)) (text.length - low + 1) low
        [] none).isNone

/-- A search that finds no end has no match from `low`. -/
theorem search_none (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (hexact : Exact prog) {low : Nat} (hlow : low ≤ text.length)
    (h : search prog entry text starts (text.length - low + 1) low [] none = none) :
    IsAnswer (textOf prog entry text starts hexact) low none := by
  have ha := answerOf_isAnswer prog entry text starts hexact hlow
  have hs := search_answer prog entry text starts hexact hlow ha
  rw [h] at hs
  cases hans : answerOf prog entry text starts low with
  | none => rw [hans] at ha; exact ha
  | some span => rw [hans] at hs; cases hs

/-- A span that passes `isAnswerOf` is the search's answer. -/
theorem isAnswer_of_isAnswerOf (prog : Array Inst) (entry : Nat) (text : List Nat)
    (starts : Nat → Bool) (hexact : Exact prog) {low : Nat} (hlow : low ≤ text.length) :
    ∀ a, isAnswerOf prog entry text starts low a = true →
      IsAnswer (textOf prog entry text starts hexact) low a
  | none, h =>
    search_none prog entry text starts hexact hlow (Option.isNone_iff_eq_none.mp h)
  | some (s, e), h => by
    simp only [isAnswerOf, Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq,
      Option.isNone_iff_eq_none] at h
    obtain ⟨⟨⟨⟨hls, hslen⟩, hstart⟩, hfind⟩, hnone⟩ := h
    refine ⟨hls, ⟨hslen, hstart, by rw [← findAt_eq]; exact hfind⟩, ?_⟩
    intro s' e' hlow' hm
    apply Nat.le_of_not_lt
    intro hlt
    have hno := search_none prog entry text (fun i => starts i && decide (i < s)) hexact hlow hnone
    exact hno s' e' hlow' ⟨hm.1, by simp [hm.2.1, hlt], hm.2.2⟩

/-- `a|ab` between its two saves, over `xab`: the span from 1 up to 2 is the answer from 0,
and no other span is. From 2 the answer is no match. -/
example :
    isAnswerOf #[.save 0 1, .split 2 3, .range 97 97 5, .range 97 97 4, .range 98 98 5,
        .save 1 6, .done] 0 [120, 97, 98] (fun _ => true) 0 (some (1, 2)) = true ∧
      isAnswerOf #[.save 0 1, .split 2 3, .range 97 97 5, .range 97 97 4, .range 98 98 5,
        .save 1 6, .done] 0 [120, 97, 98] (fun _ => true) 0 (some (1, 3)) = false ∧
      isAnswerOf #[.save 0 1, .split 2 3, .range 97 97 5, .range 97 97 4, .range 98 98 5,
        .save 1 6, .done] 0 [120, 97, 98] (fun _ => true) 0 none = false ∧
      isAnswerOf #[.save 0 1, .split 2 3, .range 97 97 5, .range 97 97 4, .range 98 98 5,
        .save 1 6, .done] 0 [120, 97, 98] (fun _ => true) 2 none = true ∧
      isAnswerOf #[.save 0 1, .split 2 3, .range 97 97 5, .range 97 97 4, .range 98 98 5,
        .save 1 6, .done] 0 [97, 97, 98] (fun _ => true) 0 (some (1, 2)) = false := by decide

end Stdx.Regex.Matcher
