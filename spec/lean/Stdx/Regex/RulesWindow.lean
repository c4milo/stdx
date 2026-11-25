import Stdx.Regex.RulesInner
import Stdx.Regex.Window

/-!
# The window, decided from a program

`Window.lean` proves the search from a literal near every match's start, for a literal that
`Within` holds. This file decides `Within` from a program (decision 86, the window, `dfa_window.zig`).
It takes claim R14's structure: an instruction `cut` of the reverse program that every match
passes, from which the reverse program takes the literal and stands at `before`. Then a bound on
the part of a match before the literal is enough. Claim R14's rules for that part are not needed.

- `boundsOk` checks a list of sets of instructions, one set a level, for a walk from `before`
  whose every path takes at most `n` bytes: level `n + 1` is empty.
- `bounded_of_boundsOk` proves from the check alone that a path from `before` takes at most `n`
  bytes. It reads nothing of how `levelsFrom` built the levels.
- `windowOn` is the rule for a literal and a bound, and `window_program` gives the search's
  answer from it.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The levels of a bounded walk -/

/-- Level `k` of `levels` is right for a bounded walk: it holds each instruction its members lead
to with no byte, and level `k + 1` holds each one they lead to with a byte. -/
def boundOk (prog : Array Inst) (levels : List (List Nat)) (k : Nat) : Bool :=
  (levels.getD k []).all fun x =>
    (freeSuccessors prog x).all ((levels.getD k []).contains ·) &&
      (byteSuccessors prog x).all ((levels.getD (k + 1) []).contains ·)

/-- The levels are right for a walk from `before` whose every path takes at most `n` bytes: level
0 holds `before`, each level up to `n` is right, and level `n + 1` is empty. -/
def boundsOk (prog : Array Inst) (before n : Nat) (levels : List (List Nat)) : Bool :=
  (levels.getD 0 []).contains before && (levels.getD (n + 1) []).isEmpty &&
    (List.range (n + 1)).all (boundOk prog levels)

/-- Where the levels are right, a path from an instruction of level `k` takes at most the
`n - k` bytes that are left. -/
theorem bounded_of_boundsOk {prog : Array Inst} {text : List Nat} {before n : Nat}
    {levels : List (List Nat)} (h : boundsOk prog before n levels = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j →
      ∀ k, k ≤ n → pc ∈ levels.getD k [] → j + k ≤ i + n := by
  simp only [boundsOk, Bool.and_eq_true] at h
  obtain ⟨⟨_, hempty⟩, hall⟩ := h
  have hlevel : ∀ k, k ≤ n → ∀ x, x ∈ levels.getD k [] →
      (∀ y, y ∈ freeSuccessors prog x → y ∈ levels.getD k []) ∧
        (∀ y, y ∈ byteSuccessors prog x → y ∈ levels.getD (k + 1) []) := by
    intro k hk x hx
    have hok := List.all_eq_true.mp hall k (List.mem_range.mpr (by omega))
    have hx' := List.all_eq_true.mp hok x hx
    simp only [Bool.and_eq_true] at hx'
    refine ⟨?_, ?_⟩
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hx'.1 y hy)
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hx'.2 y hy)
  intro pc i pc' j hpath
  induction hpath with
  | here =>
    intro k hk _
    omega
  | free hfree _ ih =>
    intro k hk hmem
    exact ih k hk ((hlevel k hk _ hmem).1 _ (free_successor hfree))
  | take _ htakes _ ih =>
    intro k hk hmem
    have hnext := (hlevel k hk _ hmem).2 _ (takes_successor htakes)
    have hlt : k < n := by
      apply Nat.lt_of_le_of_ne hk
      intro heq
      rw [heq, List.isEmpty_iff.mp hempty] at hnext
      cases hnext
    have := ih (k + 1) hlt hnext
    omega

/-- `dfa_length.from`'s greatest length: the least count `n` of at most `most` bytes that bounds
every path from `before`, where one does. -/
def boundedLength (prog : Array Inst) (before most : Nat) : Option Nat :=
  (List.range (most + 1)).find? fun n =>
    boundsOk prog before n (levelsFrom prog (most + 2) [before])

/-- Where `boundedLength` gives a count, every path from `before` takes at most that many
bytes. -/
theorem boundedLength_sound {prog : Array Inst} {text : List Nat} {before most n : Nat}
    (h : boundedLength prog before most = some n) {i pc' j : Nat}
    (hpath : Path prog text before i pc' j) : j ≤ i + n := by
  -- The proof reads the levels' check alone, and nothing of how many levels the walk builds.
  have hok := List.find?_some h
  have hstart := hok
  simp only [boundsOk, Bool.and_eq_true] at hstart
  have := bounded_of_boundsOk hok hpath 0 (Nat.zero_le n) (List.contains_iff_mem.mp hstart.1.1)
  omega

/-! ## The rule of the window -/

/-- Every match holds the literal at most `n` bytes after its start, where claim R14's structure
holds for it and every path of the reverse program from `before` takes at most `n` bytes. -/
theorem window_within {prog rev : Array Inst} {entry reventry cut before most n : Nat}
    {text : List Nat} {walked : List (Nat × Nat)} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hbound : boundedLength rev before most = some n) :
    Within (textOf prog entry text starts hexact)
      (scansOf hexact hrevexact hrev hclean walked.reverse hlit) n := by
  apply within_of_inner (innerOf hexact hrevexact hrev hclean hlit hpasses hchain)
  intro s p hb
  obtain ⟨hsp, hp, pc, hpath, _⟩ := hb
  have := boundedLength_sound hbound hpath
  omega

/-- The rule of the window. `walked` holds the literal's places from its last to its first. The
reverse program takes them from `cut` and stands at `before`, every match passes `cut`, and
every path from `before` takes at most `lead` bytes. -/
def windowOn (rev : Array Inst) (reventry cut before : Nat) (walked : List (Nat × Nat))
    (lead : Nat) : Bool :=
  chainTo rev before (chainFuel rev walked) cut walked && passesOn rev reventry cut &&
    (boundedLength rev before lead).isSome

/-- `dfa_window.zig`'s search for one literal: from `lead` bytes before the literal's first place
at or after `low`, and never before `low`, the two scans of `byDfa`. -/
def byWindow (prog : Array Inst) (entry : Nat) (rev : Array Inst) (reventry : Nat)
    (text : List Nat) (mayByte : Nat → Bool) (lit : List (Nat × Nat)) (lead low : Nat) :
    Option (Nat × Nat) :=
  match findLiteral text lit low with
  | none => none
  | some p => byDfa prog entry rev reventry text mayByte (max low (p - lead))

/-- The window over a program. Where `windowOn` holds for a literal and a bound, the search from
`lead` bytes before the literal's first place gives the matcher's answer from `low`, for a text
that has the builder's hypotheses. -/
theorem window_program {prog rev : Array Inst} {entry reventry cut before lead : Nat}
    {text : List Nat} {walked : List (Nat × Nat)} {mayByte : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text (Dfa.startsOf text mayByte))
    (hlit : 0 < walked.reverse.length) (hrule : windowOn rev reventry cut before walked lead = true)
    (low : Nat) :
    IsAnswer (textOf prog entry text (Dfa.startsOf text mayByte) hexact) low
      (byWindow prog entry rev reventry text mayByte walked.reverse lead low) := by
  simp only [windowOn, Bool.and_eq_true] at hrule
  obtain ⟨⟨hto, hpasses⟩, hsome⟩ := hrule
  have hchain := chain_of_chainTo _ _ _ hto
  obtain ⟨n, hn⟩ := Option.isSome_iff_exists.mp hsome
  have hle : n ≤ lead := by
    have := List.find?_some hn
    have hmem := List.mem_of_find?_eq_some hn
    exact Nat.le_of_lt_succ (List.mem_range.mp hmem)
  have hwithin := within_wider
    (window_within hexact hrevexact hrev hclean hlit hpasses hchain hn) hle
  unfold byWindow
  cases hplace : findLiteral text walked.reverse low with
  | none => exact window_none hwithin hplace
  | some p =>
    have hp := (scansOf hexact hrevexact hrev hclean walked.reverse hlit).place_some hplace
    have hlen : max low (p - lead) ≤ text.length := by
      have := hp.2.1
      omega
    exact answer_from_window hwithin hplace
      (byDfa_answer hexact hrevexact hrev (emptyElsewhere_of_startsClean hclean) hlen)

/-! ## The rule on small programs -/

/-- `[a-c]{0,2}x` has the reverse program `x[a-c]{0,2}`: from 0 the byte `x`, then up to two
letters. Every path passes 0, the walk of `x` from 0 stands at 1, and every path from 1 takes at
most two bytes: the window of 2 holds, and the window of 1 fails. `[a-c]*x`, whose part before
the literal has no bound, fails for any window. -/
example :
    windowOn #[.range 120 120 1, .split 2 5, .range 97 99 3, .split 4 5, .range 97 99 5, .done]
        0 0 1 [(120, 120)] 2 = true ∧
      windowOn #[.range 120 120 1, .split 2 5, .range 97 99 3, .split 4 5, .range 97 99 5,
        .done] 0 0 1 [(120, 120)] 1 = false ∧
      windowOn #[.range 120 120 1, .split 2 3, .range 97 99 1, .done] 0 0 1 [(120, 120)] 16 =
        false ∧
      boundedLength #[.range 120 120 1, .split 2 5, .range 97 99 3, .split 4 5, .range 97 99 5,
        .done] 1 16 = some 2 := by
  decide

end Stdx.Regex.Matcher
