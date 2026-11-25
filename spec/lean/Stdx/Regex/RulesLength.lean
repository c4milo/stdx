import Stdx.Regex.RulesWindow

/-!
# The least length of a match, decided from a program

`\w{10,}` matches no text of fewer than 10 bytes, wherever it starts and ends. A search of a text
with fewer bytes after its start than that least length finds no match, and reads none of them
(decision 86, claim R13's least length). The compiler counts it from the fragments of a pattern,
as `Program.len_min`, and the seeded check holds each count to `leastOn`.

- `leastOk` checks a list of sets of instructions, one set a level, for a walk from the entry:
  each level before `n` is right, as `boundOk` asks, and holds no `match`.
- `least_of_leastOk` proves from the check alone that a path from a level's instruction to
  `match` takes the bytes left before level `n`.
- `leastOn` is the rule for a count `n`, and `short_answer` gives the search's answer: none,
  for a text shorter than `n` bytes after the search's start.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-- The levels show that no path from `entry` reaches `match` before `n` bytes: level 0 holds
`entry`, and each level before `n` is right and holds no `match`. -/
def leastOk (prog : Array Inst) (entry n : Nat) (levels : List (List Nat)) : Bool :=
  (levels.getD 0 []).contains entry &&
    (List.range n).all fun k =>
      boundOk prog levels k && (levels.getD k []).all fun x => !isDone prog x

/-- Where the levels are right, a path from an instruction of level `k` to `match` takes at
least the `n - k` bytes left before level `n`. -/
theorem least_of_leastOk {prog : Array Inst} {text : List Nat} {entry n : Nat}
    {levels : List (List Nat)} (h : leastOk prog entry n levels = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done →
      ∀ k, k ≤ n → pc ∈ levels.getD k [] → i + (n - k) ≤ j := by
  simp only [leastOk, Bool.and_eq_true] at h
  obtain ⟨_, hall⟩ := h
  have hlevel : ∀ k, k < n → ∀ x, x ∈ levels.getD k [] →
      isDone prog x = false ∧
        (∀ y, y ∈ freeSuccessors prog x → y ∈ levels.getD k []) ∧
        (∀ y, y ∈ byteSuccessors prog x → y ∈ levels.getD (k + 1) []) := by
    intro k hk x hx
    have hok := List.all_eq_true.mp hall k (List.mem_range.mpr hk)
    simp only [Bool.and_eq_true] at hok
    obtain ⟨hbound, hnone⟩ := hok
    have hx' := List.all_eq_true.mp hbound x hx
    simp only [Bool.and_eq_true] at hx'
    refine ⟨?_, ?_, ?_⟩
    · have := List.all_eq_true.mp hnone x hx
      simpa using this
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hx'.1 y hy)
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hx'.2 y hy)
  intro pc i pc' j hpath
  induction hpath with
  | here =>
    intro hdone k hk hmem
    by_cases hlt : k < n
    · have hnot := (hlevel k hlt _ hmem).1
      rw [isDone_iff.mpr hdone] at hnot
      cases hnot
    · omega
  | free hfree hrest ih =>
    intro hdone k hk hmem
    by_cases hlt : k < n
    · exact ih hdone k hk ((hlevel k hlt _ hmem).2.1 _ (free_successor hfree))
    · have := hrest.le
      omega
  | take _ htakes hrest ih =>
    intro hdone k hk hmem
    by_cases hlt : k < n
    · have := ih hdone (k + 1) hlt ((hlevel k hlt _ hmem).2.2 _ (takes_successor htakes))
      omega
    · have := hrest.le
      omega

/-- The rule for a count `n`, which the seeded check holds `Program.len_min` to: the walk of
`n + 1` levels from `entry` meets no `match` before level `n`. -/
def leastOn (prog : Array Inst) (entry n : Nat) : Bool :=
  leastOk prog entry n (levelsFrom prog (n + 1) [entry])

/-- Where `leastOn` holds, every match takes at least `n` bytes. -/
theorem leastOn_sound {prog : Array Inst} {entry n : Nat} {text : List Nat} {s e : Nat}
    (h : leastOn prog entry n = true) (hm : Matches prog entry text s e) : s + n ≤ e := by
  obtain ⟨pc, hpath, hdone⟩ := hm
  have hstart := h
  unfold leastOn at hstart
  simp only [leastOk, Bool.and_eq_true] at hstart
  have := least_of_leastOk h hpath hdone 0 (Nat.zero_le n)
    (List.contains_iff_mem.mp hstart.1)
  omega

/-- The search of a text with fewer than `n` bytes after `low` finds no match, where `leastOn`
holds for `n`. -/
theorem short_answer {prog : Array Inst} {entry n low : Nat} {text : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog) (h : leastOn prog entry n = true)
    (hshort : text.length < low + n) :
    IsAnswer (textOf prog entry text starts hexact) low none := by
  intro s e hlow hm
  have := leastOn_sound h hm.2.2
  have := matches_inside hm.1 hm.2.2
  omega

/-! ## The rule on small programs -/

/-- `[a-c]{2}[a-c]*`: two letters, then a loop. Every match takes two bytes or more, so the rule
holds for 2 and fails for 3. -/
example :
    leastOn #[.range 97 99 1, .range 97 99 2, .split 3 4, .range 97 99 2, .done] 0 2 = true ∧
      leastOn #[.range 97 99 1, .range 97 99 2, .split 3 4, .range 97 99 2, .done] 0 3 =
        false := by
  decide

end Stdx.Regex.Matcher
