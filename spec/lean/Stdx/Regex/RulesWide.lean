import Stdx.Regex.Rules

/-!
# Claim R4's second rule, decided from a program

A searcher takes claim R4 by three rules (decision 86, `dfa_suffix.zig`). `Rules.lean` decides
the first. This file decides the second: the part of a match before the literal takes one count
of bytes, as in `[a-z]shing`. Every match then has one length, which gives `Rising`, and
`bySuffix_rising` gives the search's answer with no forward scan.

- `levelsOk` checks a list of sets of instructions, one set a level: level `k` holds each
  instruction that a path from `before` stands at after `k` bytes. Only level `n` may hold
  `match`, and level `n + 1` is empty.
- `fixed_of_levelsOk` proves from the check alone that every path from `before` to `match`
  takes `n` bytes. It reads nothing of how `levelsFrom` built the levels.
- `fixedOn` is the rule for a literal, and `fixed_program` gives the search's answer from it.

The Zig walk, `dfa_length.from`, stops at `suffix_before_len_max` bytes. The proof needs no such
bound: the bound keeps a search's cost linear, and changes no answer.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The moves of an instruction, by whether they take a byte -/

/-- The instructions that one move with no byte leads to. -/
def freeSuccessors (prog : Array Inst) (pc : Nat) : List Nat :=
  match prog[pc]? with
  | some (.split out arg) => [out, arg]
  | some (.save _ out) => [out]
  | some (.jump out) => [out]
  | some (.look _ out) => [out]
  | _ => []

/-- The instructions that one move with a byte leads to. -/
def byteSuccessors (prog : Array Inst) (pc : Nat) : List Nat :=
  match prog[pc]? with
  | some (.range _ _ out) => [out]
  | some (.ranges count) =>
    (List.range count).filterMap fun j =>
      match prog[pc + 1 + j]? with
      | some (.range _ _ out) => some out
      | _ => none
  | _ => []

/-- A move with no byte leads to one of the free successors. -/
theorem free_successor {prog : Array Inst} {text : List Nat} {i pc out : Nat}
    (h : Free prog text i pc out) : out ∈ freeSuccessors prog pc := by
  cases h with
  | splitOut hp => simp [freeSuccessors, hp]
  | splitArg hp => simp [freeSuccessors, hp]
  | save hp => simp [freeSuccessors, hp]
  | jump hp => simp [freeSuccessors, hp]
  | look hp _ => simp [freeSuccessors, hp]

/-- A move with a byte leads to one of the byte successors. -/
theorem takes_successor {prog : Array Inst} {pc b out : Nat} (h : Takes prog pc b out) :
    out ∈ byteSuccessors prog pc := by
  cases h with
  | range hp _ _ => simp [byteSuccessors, hp]
  | @member count j lo hi hp hj hr _ _ =>
    simp only [byteSuccessors, hp, List.mem_filterMap, List.mem_range]
    exact ⟨j, hj, by simp [hr]⟩

/-! ## The levels of a walk -/

/-- Level `k` of `levels` is right: it holds each instruction its members lead to with no
byte, level `k + 1` holds each one they lead to with a byte, and it holds `match` only where
`k` is `n`. -/
def levelOk (prog : Array Inst) (n : Nat) (levels : List (List Nat)) (k : Nat) : Bool :=
  (levels.getD k []).all fun x =>
    (freeSuccessors prog x).all ((levels.getD k []).contains ·) &&
      (byteSuccessors prog x).all ((levels.getD (k + 1) []).contains ·) &&
      (!isDone prog x || k == n)

/-- The levels are right for a walk from `before` whose every path to `match` takes `n` bytes:
level 0 holds `before`, each level up to `n` is right, and level `n + 1` is empty. -/
def levelsOk (prog : Array Inst) (before n : Nat) (levels : List (List Nat)) : Bool :=
  (levels.getD 0 []).contains before && (levels.getD (n + 1) []).isEmpty &&
    (List.range (n + 1)).all (levelOk prog n levels)

/-- Where the levels are right, a path from an instruction of level `k` to `match` takes the
`n - k` bytes that are left. -/
theorem fixed_of_levelsOk {prog : Array Inst} {text : List Nat} {before n : Nat}
    {levels : List (List Nat)} (h : levelsOk prog before n levels = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done →
      ∀ k, k ≤ n → pc ∈ levels.getD k [] → j + k = i + n := by
  simp only [levelsOk, Bool.and_eq_true] at h
  obtain ⟨⟨_, hempty⟩, hall⟩ := h
  have hlevel : ∀ k, k ≤ n → ∀ x, x ∈ levels.getD k [] →
      (∀ y, y ∈ freeSuccessors prog x → y ∈ levels.getD k []) ∧
        (∀ y, y ∈ byteSuccessors prog x → y ∈ levels.getD (k + 1) []) ∧
        (isDone prog x = true → k = n) := by
    intro k hk x hx
    have hok := List.all_eq_true.mp hall k (List.mem_range.mpr (by omega))
    have hx' := List.all_eq_true.mp hok x hx
    simp only [Bool.and_eq_true, Bool.or_eq_true, Bool.not_eq_true', beq_iff_eq] at hx'
    obtain ⟨⟨hfree, hbyte⟩, hdone⟩ := hx'
    refine ⟨?_, ?_, ?_⟩
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hfree y hy)
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hbyte y hy)
    · intro hd
      cases hdone with
      | inl hnot => rw [hd] at hnot; cases hnot
      | inr heq => exact heq
  intro pc i pc' j hpath
  induction hpath with
  | here =>
    intro hdone k hk hmem
    have := (hlevel k hk _ hmem).2.2 (isDone_iff.mpr hdone)
    omega
  | free hfree _ ih =>
    intro hdone k hk hmem
    exact ih hdone k hk ((hlevel k hk _ hmem).1 _ (free_successor hfree))
  | take _ htakes hrest ih =>
    intro hdone k hk hmem
    have hnext := (hlevel k hk _ hmem).2.1 _ (takes_successor htakes)
    have hlt : k < n := by
      apply Nat.lt_of_le_of_ne hk
      intro heq
      rw [heq, List.isEmpty_iff.mp hempty] at hnext
      cases hnext
    have := ih hdone (k + 1) hlt hnext
    omega

/-- A set grown `fuel` times: each time by its members' successors that it lacks. -/
def growBy (next : Nat → List Nat) : Nat → List Nat → List Nat
  | 0, set => set
  | fuel + 1, set =>
    let more := ((set.flatMap next).filter (!set.contains ·)).eraseDups
    if more.isEmpty then set else growBy next fuel (set ++ more)

/-- `count` levels of a walk from `seeds`: each level is its seeds and what they lead to with no
byte, and its members' byte successors are the next level's seeds. -/
def levelsFrom (prog : Array Inst) : Nat → List Nat → List (List Nat)
  | 0, _ => []
  | count + 1, seeds =>
    let level := growBy (freeSuccessors prog) (prog.size + 1) seeds.eraseDups
    level :: levelsFrom prog count (level.flatMap (byteSuccessors prog)).eraseDups

/-- `dfa_length.from` with one length: the count of bytes that every path from `before` to
`match` takes, where it is one count of at most `most`. -/
def fixedLength (prog : Array Inst) (before most : Nat) : Option Nat :=
  (List.range (most + 1)).find? fun n =>
    levelsOk prog before n (levelsFrom prog (most + 2) [before])

/-- Where `fixedLength` gives a count, every path from `before` to `match` takes that many
bytes. -/
theorem fixedLength_sound {prog : Array Inst} {text : List Nat} {before most n : Nat}
    (h : fixedLength prog before most = some n) {i pc' j : Nat}
    (hpath : Path prog text before i pc' j) (hdone : prog[pc']? = some .done) : j = i + n := by
  have hok := List.find?_some h
  have hstart : before ∈ (levelsFrom prog (most + 2) [before]).getD 0 [] := by
    simp only [levelsOk, Bool.and_eq_true] at hok
    exact List.contains_iff_mem.mp hok.1.1
  have := fixed_of_levelsOk hok hpath hdone 0 (Nat.zero_le n) hstart
  omega

/-! ## Claim R4's second rule -/

/-- Claim R4's second rule for a literal with no place that folds. `walked` holds the literal's
bytes from its last to its first. The reverse program takes those bytes from its entry, and
then one count of bytes, of at most `most`, on each path to `match`. Gives that count. -/
def fixedOn (rev : Array Inst) (reventry : Nat) (walked : List Nat) (most : Nat) : Option Nat :=
  match chainStop rev (chainFuel rev walked) reventry walked with
  | some before => fixedLength rev before most
  | none => none

/-- Claim R4 over a program, from the second rule: where `fixedOn` gives a count for a literal,
`Searcher.find_by_suffix` over the model's scans gives the matcher's answer from `low`, for a
text that has the builder's hypotheses. -/
theorem fixed_program {prog rev : Array Inst} {entry reventry most n : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts)
    (hrule : fixedOn rev reventry walked most = some n) (hlit : 0 < walked.reverse.length)
    {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (bySuffix (scansOf hexact hrevexact hrev hclean walked.reverse hlit) low
        (text.length - low + 1) low) := by
  unfold fixedOn at hrule
  cases hstop : chainStop rev (chainFuel rev walked) reventry walked with
  | none => simp [hstop] at hrule
  | some before =>
    simp only [hstop] at hrule
    have hchain := chain_of_chainStop _ _ _ _ hstop
    have hends := endsWith_of_chain hexact hrevexact hrev hclean hchain hlit
    have hlength : ∀ s e, (textOf prog entry text starts hexact).Match s e →
        e = s + (walked.length + n) := by
      intro s e hm
      have hin := matches_inside hm.1 hm.2.2
      obtain ⟨pc, hpath, hdone⟩ := reversed_match hexact hrev hm
      have ⟨_, hrest⟩ := chain_path hchain hpath hdone
      have := fixedLength_sound hrule hrest hdone
      omega
    exact bySuffix_rising (rising_of_one_length hlength) hends hlow

/-! ## The rule on small programs -/

/-- `[a-c]shing` has the reverse program `gnihs[a-c]`: from 0 it takes the five bytes of
`shing` from the last to the first, and from 5 one byte. Every path from 5 takes one byte, so
the rule holds with the count 1. `[a-c]+ab` has `ba[a-c]+`, whose part from 2 takes one byte or
more: no one count holds. -/
example :
    fixedOn #[.range 103 103 1, .range 110 110 2, .range 105 105 3, .range 104 104 4,
        .range 115 115 5, .range 97 99 6, .done] 0 [103, 110, 105, 104, 115] 8 = some 1 ∧
      fixedOn #[.range 98 98 1, .range 97 97 2, .range 97 99 3, .split 2 4, .done] 0 [98, 97] 8
        = none ∧
      levelsFrom #[.range 98 98 1, .range 97 97 2, .range 97 99 3, .split 2 4, .done] 3 [2]
        = [[2], [3, 2, 4], [3, 2, 4]] := by decide

end Stdx.Regex.Matcher
