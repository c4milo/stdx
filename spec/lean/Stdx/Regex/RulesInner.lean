import Stdx.Regex.SearcherInner
import Stdx.Regex.RulesSeparator

/-!
# Claim R14's rule, decided from a program

A searcher takes claim R14 for a literal after three walks of the reverse program
(`dfa_inner.judge`, decision 86). `SearcherInner.lean` decides two of them: the literal's walk
from `cut` to `before`, and that every match passes `cut`. This file decides the third: one of
claim R4's three rules holds for the part of a match before the literal, which the reverse
program takes from `before`.

Each rule gives `BeforeRising`, the precondition of `byInner_answer`:

- `inner_apart`: no instruction from `before` takes the literal's first byte.
- `inner_fixed`: every path from `before` to `match` takes one count of bytes.
- `inner_separated`: the part ends with separators, and holds none before them. The rule may
  hold for the literal past some of its first bytes, as the Zig rule tries the literal past
  its first run. Those bytes are then separators, the byte after them is none, and `before`
  stands among the instructions that the program reaches over separators alone.

`beforeOn` is the three rules, `innerOn` is the whole rule for a literal with no place that
folds, and `inner_program` proves that the search from the literal's places gives the
matcher's answer.

The Zig rule has two more tests, which leave a literal that starts or ends every match to
claim R2 or claim R4. They choose a search, and change no answer, so this file has neither.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The first rule and the second -/

/-- The first rule gives `BeforeRising`: no instruction that the reverse program reaches from
`before` takes the literal's first byte. -/
theorem inner_apart {prog rev : Array Inst} {entry reventry cut before b : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hnone : noneTakes rev before b = true) (hfirst : walked.reverse[0]? = some b) :
    BeforeRising (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) := by
  apply beforeRising_of_clean (Mark := fun q => text[q]? = some b)
  · intro s p hb q hq1 hq2
    obtain ⟨hsp, hp, pc, hpath, _⟩ := hb
    have hc := path_clean hpath (noneTakes_sound hnone) (text.length - 1 - q) (by omega)
      (by omega)
    rw [mirrored_byte (by omega)] at hc
    exact hc
  · apply first_gap
    intro p hp
    have h := hp.2 0 hlit
    rw [Nat.add_zero, hfirst] at h
    exact h

/-- The second rule gives `BeforeRising`: every path of the reverse program from `before` to
`match` takes one count of bytes. -/
theorem inner_fixed {prog rev : Array Inst} {entry reventry cut before most n : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hfixed : fixedLength rev before most = some n) :
    BeforeRising (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) := by
  apply beforeRising_of_one_count (count := n)
  intro s p hb
  obtain ⟨hsp, hp, pc, hpath, hdone⟩ := hb
  have := fixedLength_sound hfixed hpath hdone
  omega

/-! ## The third rule -/

/-- The set `inside` is right for the separator of `first`: a range of a member holds
separators alone and leads to a member, or holds none and leads to a member of `past`. -/
def insideOk (prog : Array Inst) (first inside past : List Nat) : Bool :=
  inside.all fun x => (freeSuccessors prog x).all (inside.contains ·) &&
    (rangesOf prog x).all fun r =>
      (rangeAll (separator prog first) r.1 r.2.1 && inside.contains r.2.2) ||
        (rangeAll (fun b => !separator prog first b) r.1 r.2.1 && past.contains r.2.2)

/-- The set `past` is right for the separator of `first`: no range of a member holds a
separator, and each leads to a member. -/
def pastOk (prog : Array Inst) (first past : List Nat) : Bool :=
  past.all fun x => (freeSuccessors prog x).all (past.contains ·) &&
    (rangesOf prog x).all fun r =>
      rangeAll (fun b => !separator prog first b) r.1 r.2.1 && past.contains r.2.2

/-- The set `first` is right: a member leads to members with no byte, and none is `match`. -/
def firstOk (prog : Array Inst) (first : List Nat) : Bool :=
  first.all fun x => (freeSuccessors prog x).all (first.contains ·) && !isDone prog x

/-- The third rule for a literal inside a match, past its first `short` bytes. `lit` holds the
literal's bytes in the text's order. The three sets are right for a separator, `before` stands
in `inside`, the literal's first `short` bytes are separators, and the byte after them is
none. With no byte passed, `before` stands in `first`, so the part before the literal ends
with a separator. -/
def innerSeparatedOk (prog : Array Inst) (before : Nat) (first inside past lit : List Nat)
    (short : Nat) : Bool :=
  inside.contains before && insideOk prog first inside past && pastOk prog first past &&
    ((List.range short).all fun j =>
      match lit[j]? with
      | some b => separator prog first b
      | none => false) &&
    (match lit[short]? with
      | some b => !separator prog first b
      | none => false) &&
    (short != 0 || (first.contains before && firstOk prog first))

/-- The third rule gives `BeforeRising`. -/
theorem inner_separated {prog rev : Array Inst} {entry reventry cut before short : Nat}
    {text walked first inside past : List Nat} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hrule : innerSeparatedOk rev before first inside past walked.reverse short = true) :
    BeforeRising (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) := by
  simp only [innerSeparatedOk, Bool.and_eq_true] at hrule
  obtain ⟨⟨⟨⟨⟨hbefore, hinside⟩, hpast⟩, hdropped⟩, hnext⟩, hzero⟩ := hrule
  have hbeforeMem := List.contains_iff_mem.mp hbefore
  -- The literal's byte after the first `short` is no separator.
  obtain ⟨c, hc, hcsep⟩ : ∃ c, walked.reverse[short]? = some c ∧
      separator rev first c = false := by
    cases hl : walked.reverse[short]? with
    | none => simp [hl] at hnext
    | some c => exact ⟨c, rfl, by simpa [hl] using hnext⟩
  -- Each of the first `short` is one.
  have hsep : ∀ j, j < short → ∃ d, walked.reverse[j]? = some d ∧
      separator rev first d = true := by
    intro j hj
    have hat := List.all_eq_true.mp hdropped j (List.mem_range.mpr hj)
    cases hl : walked.reverse[j]? with
    | none => simp [hl] at hat
    | some d => exact ⟨d, rfl, by simpa [hl] using hat⟩
  have hshort : short < walked.reverse.length := by
    apply Nat.lt_of_not_le
    intro hle
    rw [List.getElem?_eq_none hle] at hc
    cases hc
  intro s p s2 p2 hb hs hb2 hs2 hlt
  apply Nat.le_of_not_lt
  intro hss
  obtain ⟨hsp, hp, pc, hpath, hdone⟩ := hb
  obtain ⟨hsp2, hp2, pc2, hpath2, _⟩ := hb2
  have hstands : p + walked.reverse.length ≤ text.length ∧ StandsAt text walked.reverse p := hs
  have hstands2 : p2 + walked.reverse.length ≤ text.length ∧ StandsAt text walked.reverse p2 :=
    hs2
  -- The byte of the first place after its first `short` is no separator.
  have hx : text[p + short]? = some c := by rw [hstands.2 short hshort, hc]
  -- A separator stands one byte before it, at or after the first start.
  obtain ⟨y, d, hy1, hy2, hyd, hysep⟩ : ∃ y d, s ≤ y ∧ y + 1 = p + short ∧
      text[y]? = some d ∧ separator rev first d = true := by
    cases short with
    | zero =>
      simp only [bne_self_eq_false, Bool.false_or, Bool.and_eq_true] at hzero
      obtain ⟨hlt', d, hd, hdsep⟩ :=
        first_separator hzero.2 hpath hdone (List.contains_iff_mem.mp hzero.1)
      refine ⟨p - 1, d, by omega, by omega, ?_, hdsep⟩
      rw [← mirrored_byte (by omega)]
      have hidx : text.length - 1 - (p - 1) = text.length - p := by omega
      rw [hidx]
      exact hd
    | succ k =>
      obtain ⟨d, hd, hdsep⟩ := hsep k (Nat.lt_succ_self k)
      refine ⟨p + k, d, by omega, by omega, ?_, hdsep⟩
      rw [hstands.2 k (by omega), hd]
  by_cases hcase : p2 ≤ p + short
  · -- The second place's first bytes hold the offset, so its byte is a separator.
    obtain ⟨d2, hd2, hd2sep⟩ := hsep (p + short - p2) (by omega)
    have hat := hstands2.2 (p + short - p2) (by omega)
    have hidx : p2 + (p + short - p2) = p + short := by omega
    rw [hidx, hx, hd2] at hat
    have hcd : c = d2 := Option.some.inj hat
    rw [hcd, hd2sep] at hcsep
    cases hcsep
  · -- The second place's part before it holds both offsets, so the separators stand last.
    have hmirror : SepAt rev first text.reverse (text.length - 1 - y) :=
      ⟨d, by rw [mirrored_byte (by omega)]; exact hyd, hysep⟩
    obtain ⟨c', hc', hcsep'⟩ := inside_first hinside hpast hpath2 hbeforeMem
      (text.length - 1 - (p + short)) (text.length - 1 - y) (by omega) (by omega) (by omega)
      hmirror
    rw [mirrored_byte (by omega), hx] at hc'
    have hcc : c = c' := Option.some.inj hc'
    rw [← hcc, hcsep] at hcsep'
    cases hcsep'

/-- The third rule for a literal inside a match: the rule holds for the literal, or for the
literal past some of its first bytes. `walked` holds the literal's bytes from its last to its
first. The sets come from `before` for the literal whole, and from the instruction after the
walk of the shorter literal for another. Gives the count of the bytes passed. -/
def innerSeparatedOn (rev : Array Inst) (cut before : Nat) (walked : List Nat) : Option Nat :=
  (List.range walked.length).find? fun short =>
    let start :=
      if short = 0 then some before
      else chainStop rev (chainFuel rev walked) cut (walked.take (walked.length - short))
    match start with
    | some from' =>
      let sets := separatedSets rev from'
      innerSeparatedOk rev before sets.1 sets.2.1 sets.2.2 walked.reverse short
    | none => false

/-! ## Claim R14's rule -/

/-- One of claim R4's three rules for the part of a match before a literal inside it
(`dfa_suffix.apart` and `dfa_suffix.wide`, from `before`). -/
def beforeOn (rev : Array Inst) (cut before : Nat) (walked : List Nat) : Bool :=
  (match walked.reverse[0]? with
    | some b => noneTakes rev before b
    | none => false) ||
    (fixedLength rev before fixedMost).isSome || (innerSeparatedOn rev cut before walked).isSome

/-- Each rule of `beforeOn` gives `BeforeRising`. -/
theorem beforeOn_rising {prog rev : Array Inst} {entry reventry cut before : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hrule : beforeOn rev cut before walked = true) :
    BeforeRising (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) := by
  simp only [beforeOn, Bool.or_eq_true] at hrule
  cases hrule with
  | inl hfirstTwo =>
    cases hfirstTwo with
    | inl hapart =>
      cases hb : walked.reverse[0]? with
      | none => simp [hb] at hapart
      | some b =>
        exact inner_apart hexact hrevexact hrev hclean hlit hpasses hchain
          (by simpa [hb] using hapart) hb
    | inr hfixed =>
      obtain ⟨n, hn⟩ := Option.isSome_iff_exists.mp hfixed
      exact inner_fixed hexact hrevexact hrev hclean hlit hpasses hchain hn
  | inr hseparated =>
    obtain ⟨short, hshort⟩ := Option.isSome_iff_exists.mp hseparated
    have hat := List.find?_some hshort
    cases hstart : (if short = 0 then some before
        else chainStop rev (chainFuel rev walked) cut (walked.take (walked.length - short))) with
    | none => simp [hstart] at hat
    | some from' =>
      simp only [hstart] at hat
      exact inner_separated hexact hrevexact hrev hclean hlit hpasses hchain hat

/-- Claim R14's rule for a literal with no place that folds. `walked` holds the literal's
bytes from its last to its first. The reverse program takes them from `cut` and stands at
`before`, every match passes `cut`, and one of claim R4's rules holds for the part of a match
before the literal. -/
def innerOn (rev : Array Inst) (reventry cut before : Nat) (walked : List Nat) : Bool :=
  chainTo rev before (chainFuel rev walked) cut walked && passesOn rev reventry cut &&
    beforeOn rev cut before walked

/-- What `innerOn` holds: the three hypotheses of `inner_program`. -/
theorem innerOn_parts {rev : Array Inst} {reventry cut before : Nat} {walked : List Nat}
    (h : innerOn rev reventry cut before walked = true) :
    passesOn rev reventry cut = true ∧ Chain rev cut walked before ∧
      beforeOn rev cut before walked = true := by
  simp only [innerOn, Bool.and_eq_true] at h
  exact ⟨h.1.2, chain_of_chainTo _ _ _ h.1.1, h.2⟩

/-- Claim R14 over a program: where the three parts of `innerOn` hold for a literal,
`searcher_inner.find` over the model's scans gives the matcher's answer from `low`, for a text
that has the builder's hypotheses. The reverse scan of each place starts at `before`. -/
theorem inner_program {prog rev : Array Inst} {entry reventry cut before : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hrule : beforeOn rev cut before walked = true) {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (byInner (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) low
        (text.length - low + 1) low) :=
  byInner_answer (beforeOn_rising hexact hrevexact hrev hclean hlit hpasses hchain hrule) hlow

/-! ## The rule on small programs -/

/-- `[a-c]+@[a-c]+` has a reverse program of the same form: from 0 a letter or more, at 2 the
byte `@`, and from 3 a letter or more. Every path to `match` passes 2, the walk of `@` from 2
stands at 3, and no instruction from 3 takes `@`: the rule holds. It fails for the cut 0,
which takes no `@`.

`c(?:@a|b)` is the reverse program of `(?:a@|b)c`: a path through `b` passes no `@`, so the
rule fails for the cut 2. -/
example :
    innerOn #[.range 97 99 1, .split 0 2, .range 64 64 3, .range 97 99 4, .split 3 5, .done]
        0 2 3 [64] = true ∧
      innerOn #[.range 97 99 1, .split 0 2, .range 64 64 3, .range 97 99 4, .split 3 5, .done]
        0 0 3 [64] = false ∧
      passesOn #[.range 99 99 1, .split 2 4, .range 64 64 3, .range 97 97 5, .range 98 98 5,
        .done] 0 2 = false ∧
      growBy (successorsBut #[.range 97 99 1, .split 0 2, .range 64 64 3, .range 97 99 4,
        .split 3 5, .done] 2) 7 [0] = [0, 1, 2] := by
  decide

/-- `[a-c]+ +x[a-c]` has the reverse program `[a-c]x +[a-c]+`. Its literal is a space and
`x`: the walk from 1 takes `x`, then the space, and stands at the split at 3. With the literal
whole, the part before it ends with a space or a letter, so the separator would hold the
literal's first byte. Past that byte the rule holds: the separator is the space, `x` is none,
and the letters hold none.

`[a-c]+  x[a-c]` takes two spaces, and its literal holds both. The part before it takes
letters alone, so the rule holds for the literal whole, with the letters as the separator. -/
example :
    innerSeparatedOn #[.range 97 99 1, .range 120 120 2, .range 32 32 3, .split 2 4,
        .range 97 99 5, .split 4 6, .done] 1 3 [120, 32] = some 1 ∧
      innerSeparatedOn #[.range 97 99 1, .range 120 120 2, .range 32 32 3, .range 32 32 4,
        .range 97 99 5, .split 4 6, .done] 1 4 [120, 32, 32] = some 0 := by
  decide

end Stdx.Regex.Matcher
