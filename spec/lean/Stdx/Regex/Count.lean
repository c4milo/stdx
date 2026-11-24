import Stdx.Regex.Search

/-!
# Claim R10: a count of the matches by their ends alone

`Matches.next` gives every match of a text in order: each search starts where the match before
it ended, and an empty match that touches the match before it is left out (decision 86).
`Matches.count` counts the matches that `next` would give. Under claim R10 it finds each match's
end by the forward DFA alone, and reads no match back to its start.

A walk's state is where the next search starts and where the last match ended. `nextSpan` is one
turn of `next`, and `nextEnd` one turn of the count by ends.

- `nextEnd_eq`: a turn by ends gives the end of the match that a turn of `next` gives. A search
  starts at the last match's end, so a match that ends there is empty, and the end alone tells
  that it touches the match before it.
- `count_eq`: the count by ends is the count of the matches that `next` gives.
-/
namespace Stdx.Regex.Search

/-- The state of a walk of a text's matches (`Matches`). -/
structure Walk where
  /-- Where the next search starts. -/
  position : Nat
  /-- Where the last match ended, or nothing before the first match. -/
  lastEnd : Option Nat

/-- One turn of `Matches.next`: the first match from the walk's position. An empty match that
touches the match before it gives way to the first match one byte on. -/
def nextSpan (find : Nat → Option (Nat × Nat)) (len : Nat) (w : Walk) : Option (Nat × Nat) :=
  match find w.position with
  | none => none
  | some (s, e) =>
    if s = e ∧ w.lastEnd = some e then (if len < e + 1 then none else find (e + 1))
    else some (s, e)

/-- One turn of the count by ends (`Matches.next_end`): the end of the first match from the
walk's position. An end at the last match's end gives way to the first end one byte on. -/
def nextEnd (findEnd : Nat → Option Nat) (len : Nat) (w : Walk) : Option Nat :=
  match findEnd w.position with
  | none => none
  | some e =>
    if w.lastEnd = some e then (if len < e + 1 then none else findEnd (e + 1))
    else some e

/-- The turns of `Matches.count`: each turn counts one match and goes on from its end. -/
def countWith (step : Walk → Option Nat) (len : Nat) : Nat → Walk → Nat
  | 0, _ => 0
  | turns + 1, w =>
    if len < w.position then 0
    else
      match step w with
      | none => 0
      | some e => 1 + countWith step len turns ⟨e, some e⟩

/-- A turn by ends gives the end of the match that a turn of `next` gives, in a walk whose
search starts at the last match's end. `find` is the searcher's answer, and `findEnd` the end
of that answer, as the forward DFA gives it. -/
theorem nextEnd_eq {t : Text} {find : Nat → Option (Nat × Nat)} {findEnd : Nat → Option Nat}
    (hfind : ∀ low, IsAnswer t low (find low))
    (hend : ∀ low, findEnd low = (find low).map (·.2))
    (w : Walk) (hlast : ∀ l, w.lastEnd = some l → l = w.position) :
    nextEnd findEnd t.len w = (nextSpan find t.len w).map (·.2) := by
  unfold nextEnd nextSpan
  rw [hend w.position]
  cases hfound : find w.position with
  | none => rfl
  | some span =>
    obtain ⟨s, e⟩ := span
    have ha := hfind w.position
    rw [hfound] at ha
    have hse := (t.inside (t.prefers_match ha.2.1)).1
    by_cases hl : w.lastEnd = some e
    · -- The match ends where the search started, so it is empty.
      have hpos := hlast e hl
      have hempty : s = e := by have := ha.1; omega
      simp only [Option.map_some, hl, hempty, and_self, ite_true]
      by_cases hlen : t.len < e + 1
      · simp [hlen]
      · simp [hlen, hend (e + 1)]
    · simp [hl]

/-- Claim R10: the count by ends is the count of the matches that `next` gives. -/
theorem count_eq {t : Text} {find : Nat → Option (Nat × Nat)} {findEnd : Nat → Option Nat}
    (hfind : ∀ low, IsAnswer t low (find low))
    (hend : ∀ low, findEnd low = (find low).map (·.2)) :
    ∀ turns (w : Walk), (∀ l, w.lastEnd = some l → l = w.position) →
      countWith (nextEnd findEnd t.len) t.len turns w =
        countWith (fun w => (nextSpan find t.len w).map (·.2)) t.len turns w := by
  intro turns
  induction turns with
  | zero => intro w _; rfl
  | succ turns ih =>
    intro w hlast
    unfold countWith
    rw [nextEnd_eq hfind hend w hlast]
    by_cases hpos : t.len < w.position
    · simp [hpos]
    · simp only [hpos, ite_false]
      cases (nextSpan find t.len w).map (·.2) with
      | none => rfl
      | some e =>
        simp only
        rw [ih ⟨e, some e⟩ (fun l hl => by simpa using hl.symm)]

end Stdx.Regex.Search
