import Stdx.Regex.MatcherPaths

/-!
# The matcher's search from any offset gives the end of the search's answer

`Matcher.search` may start a match at any offset (decision 86, `src/regex/matcher.zig`). At each
position it builds the threads of its seeds, and then, while it has found no match, the threads
of a match that starts at the position, after every seed's. So an earlier start is tried first.

- `search` is that search, for a match's end.
- `leftmost` is the search by a backtracking matcher: from each offset in turn where a match may
  start, the end it finds first, and the first offset that has one.
- `search_eq`: both give one end.
- `search_answer`: that end is the end of the answer that `Search.lean` states, for the text
  that `textOf` gives a program. So the matcher finds the match with the least start, and its
  end is the one a backtracking matcher finds first from that start.

The match's start is the value of the matcher's slot 0, and this file holds no slot.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Closure Stdx.Regex.Search

/-- `Matcher.search` from offset `i` with `seeds`, for at most `turns` positions. `best` is the
end of the best match so far. While it is nothing, a match may start at each offset where
`starts` holds, after the seeds. -/
def search (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    Nat → Nat → List Nat → Option Nat → Option Nat
  | 0, _, _, best => best
  | turns + 1, i, seeds, best =>
    let found := threads prog text i
      (seeds ++ if best.isNone && starts i then [entry] else [])
    let live := found.takeWhile (fun pc => !isDone prog pc)
    let best' := if found.any (isDone prog) then some i else best
    match text[i]? with
    | none => best'
    | some b =>
      if live.isEmpty && best'.isSome then best'
      else search prog entry text starts turns (i + 1) (live.filterMap (step prog · b)) best'

/-- The search by a backtracking matcher: the end it finds first from the least offset, at or
after `i`, where a match may start and it finds one. -/
def leftmost (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    Nat → Nat → Option Nat
  | 0, _ => none
  | turns + 1, i =>
    (if starts i then backtrack prog text (turns + 1) i [entry] else none).or
      (match text[i]? with
      | none => none
      | some _ => leftmost prog entry text starts turns (i + 1))

/-- With a match found, the search starts no match, and is the matcher of `Matcher.lean`. -/
theorem search_some (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    ∀ turns i seeds v,
      search prog entry text starts turns i seeds (some v) =
        run prog text turns i seeds (some v) := by
  intro turns
  induction turns with
  | zero => intro i seeds v; rfl
  | succ turns ih =>
    intro i seeds v
    simp only [search, run, Option.isNone_some, Bool.false_and, Bool.false_eq_true, ite_false,
      List.append_nil]
    generalize threads prog text i seeds = found
    by_cases hc : found.any (isDone prog) = true
    · simp only [hc, ite_true]
      cases hlive : found.takeWhile (fun pc => !isDone prog pc) with
      | nil => cases text[i]? <;> rfl
      | cons x xs =>
        cases text[i]? with
        | none => rfl
        | some b => exact ih _ _ _
    · simp only [hc, Bool.false_eq_true, ite_false]
      cases hlive : found.takeWhile (fun pc => !isDone prog pc) with
      | nil => cases text[i]? <;> rfl
      | cons x xs =>
        cases text[i]? with
        | none => rfl
        | some b => exact ih _ _ _

/-- The matcher's search gives the end that the backtracking matcher finds first from its
seeds, and otherwise the end of the search by a backtracking matcher from the position on. -/
theorem search_eq (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    ∀ turns i seeds,
      search prog entry text starts turns i seeds none =
        (backtrack prog text turns i seeds).or (leftmost prog entry text starts turns i) := by
  intro turns
  induction turns with
  | zero => intro i seeds; rfl
  | succ turns ih =>
    intro i seeds
    -- The first end among the position's threads: the seeds' first, then a new start's.
    have hvalue : (backtrack prog text (turns + 1) i seeds).or
          (if starts i = true then backtrack prog text (turns + 1) i [entry] else none) =
        first (threadEnd prog text i (fun out => backtrack prog text turns (i + 1) [out]))
          (threads prog text i (seeds ++ if starts i = true then [entry] else [])) := by
      unfold threads
      rw [closure_value _ _ (by simp) (fun x hx => kindAt_out prog text i hx), firstSeed_append]
      by_cases hs : starts i = true
      · simp [hs, backtrack, firstSeed]
      · simp [hs, backtrack, firstSeed]
    have hassoc : ∀ a b c : Option Nat, a.or (b.or c) = (a.or b).or c := by
      intro a b c
      cases a <;> simp
    simp only [leftmost]
    rw [hassoc, hvalue, first_split]
    simp only [search, Option.isNone_none, Bool.true_and]
    generalize threads prog text i (seeds ++ if starts i = true then [entry] else []) = found
    have hnone := live_none prog text i (fun out => backtrack prog text turns (i + 1) [out])
    have hsome := live_value prog text turns i
    cases hb : text[i]? with
    | none =>
      rw [hnone hb found]
      by_cases hc : found.any (isDone prog) = true <;> simp [hc]
    | some b =>
      have hl := hsome b hb found
      cases hlive : found.takeWhile (fun pc => !isDone prog pc) with
      | nil =>
        by_cases hc : found.any (isDone prog) = true
        · simp [hc, first]
        · simp [hc, first, ih, backtrack_nil]
      | cons x xs =>
        rw [hlive] at hl
        rw [hl]
        by_cases hc : found.any (isDone prog) = true
        · simp only [hc, ite_true, search_some, run_eq]
          cases backtrack prog text turns (i + 1) ((x :: xs).filterMap (step prog · b)) <;> simp
        · simp only [hc, Bool.false_eq_true, ite_false, ih]
          cases backtrack prog text turns (i + 1) ((x :: xs).filterMap (step prog · b)) <;> simp

/-- The search by a backtracking matcher gives the end of the answer that `Search.lean` states
for the program's text. -/
theorem leftmost_answer (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (hexact : Exact prog) :
    ∀ turns i a, i + turns = text.length + 1 →
      IsAnswer (textOf prog entry text starts hexact) i a →
      leftmost prog entry text starts turns i = a.map (·.2) := by
  intro turns
  induction turns with
  | zero =>
    intro i a hi ha
    match a, ha with
    | none, _ => rfl
    | some (s, e), ha =>
      have hs : s ≤ text.length := ha.2.1.1
      have := ha.1
      omega
  | succ turns ih =>
    intro i a hi ha
    have hturns : text.length - i + 1 = turns + 1 := by omega
    -- An end that the backtracking matcher finds from `i` is a preferred end of the text.
    have hprefers : ∀ e, starts i = true → backtrack prog text (turns + 1) i [entry] = some e →
        (textOf prog entry text starts hexact).Prefers i e := by
      intro e hst hv
      refine ⟨by omega, hst, ?_⟩
      unfold preferredEnd
      rw [hturns]
      exact hv
    simp only [leftmost]
    match a, ha with
    | none, ha =>
      have hhere : (if starts i = true then backtrack prog text (turns + 1) i [entry]
          else none) = none := by
        by_cases hst : starts i = true
        · simp only [hst, ite_true]
          cases hv : backtrack prog text (turns + 1) i [entry] with
          | none => rfl
          | some e =>
            exact absurd ((textOf prog entry text starts hexact).prefers_match (hprefers e hst hv))
              (ha i e (Nat.le_refl i))
        · simp [hst]
      rw [hhere]
      cases hb : text[i]? with
      | none => rfl
      | some b =>
        have := ih (i + 1) none (by omega) (fun s e hs hm => ha s e (by omega) hm)
        simpa using this
    | some (s, e), ha =>
      obtain ⟨hle, hpref, hleast⟩ := ha
      by_cases hsi : s = i
      · subst hsi
        obtain ⟨_, hst, hp⟩ := hpref
        unfold preferredEnd at hp
        rw [hturns] at hp
        simp [hst, hp]
      · have hhere : (if starts i = true then backtrack prog text (turns + 1) i [entry]
            else none) = none := by
          by_cases hst : starts i = true
          · simp only [hst, ite_true]
            cases hv : backtrack prog text (turns + 1) i [entry] with
            | none => rfl
            | some e0 =>
              have := hleast i e0 (Nat.le_refl i)
                ((textOf prog entry text starts hexact).prefers_match (hprefers e0 hst hv))
              omega
          · simp [hst]
        rw [hhere]
        have hslen : s ≤ text.length := hpref.1
        have hb : text[i]? = some text[i] := List.getElem?_eq_getElem (by omega)
        rw [hb]
        have := ih (i + 1) (some (s, e)) (by omega)
          ⟨by omega, hpref, fun s' e' hs' hm => hleast s' e' (by omega) hm⟩
        simpa using this

/-- The matcher's search from `low` gives the end of the search's answer: the match with the
least start, and from that start the end that a backtracking matcher finds first. -/
theorem search_answer (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (hexact : Exact prog) {low : Nat} {a : Option (Nat × Nat)} (hlow : low ≤ text.length)
    (ha : IsAnswer (textOf prog entry text starts hexact) low a) :
    search prog entry text starts (text.length - low + 1) low [] none = a.map (·.2) := by
  rw [search_eq, backtrack_nil]
  simpa using leftmost_answer prog entry text starts hexact _ low a (by omega) ha

/-! ## The search on small programs -/

/-- `a+` on `baa` from 0 ends at 3, and `a|ab` on `xab` ends at 2: the search goes to the first
offset that starts a match. -/
example :
    search #[.range 97 97 1, .split 0 2, .done] 0 [98, 97, 97] (fun _ => true) 4 0 [] none
        = some 3 ∧
      search #[.split 1 3, .range 97 97 2, .done, .range 97 97 4, .range 98 98 5, .done] 0
        [120, 97, 98] (fun _ => true) 4 0 [] none = some 2 := by decide

/-- `a*` on `baa` from 0 ends at 0: the empty match at the first offset wins over the longer
match that starts later. -/
example :
    search #[.split 1 2, .range 97 97 0, .done] 0 [98, 97, 97] (fun _ => true) 4 0 [] none
      = some 0 := by decide

/-- The empty pattern on the two bytes of `é`, searched from 1: no match starts before the
continuation byte at 1, so the search gives the empty match at 2. -/
example :
    search #[.done] 0 [0xC3, 0xA9] (fun i => i != 1) 2 1 [] none = some 2 := by decide

end Stdx.Regex.Matcher
