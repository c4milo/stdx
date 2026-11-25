import Stdx.Regex.RulesWide

/-!
# Claim R4's third rule, decided from a program

The third rule of `dfa_suffix.zig` is for a pattern such as `\w+\s+Holmes` (decision 86): the
part of a match before the literal ends with one byte or more of a set, the separator, and
holds no byte of the set before them, and the literal's first byte is none. Then no match
lies inside another, which is `Rising`, and `bySuffix_rising` gives the search's answer.

The reverse program reads that part backward: the separator's bytes first, then bytes that are
no separator. The rule is three sets of instructions:

- `first`: the instructions the program reaches from `before` with no byte. None is `match`,
  and the separator is the set of the bytes they take.
- `inside`: the instructions the program reaches while it took separators alone. A range of
  such an instruction holds separators alone, or none.
- `past`: the instructions the program reaches after a byte that is no separator. No range of
  such an instruction holds a separator.

`separatedOk` checks the three sets, and `separated_rising` proves `Rising` from the check
alone. `separatedOn` builds the sets and tries each tail of the literal, as the Zig rule tries
the literal whole and the literal past its first run: the rule for a shorter literal gives
`Rising` too, and the search still goes to the places of the whole one.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The ranges of an instruction -/

/-- The ranges that an instruction takes a byte by, each with the instruction it goes to: its
own range, or its node's ranges. -/
def rangesOf (prog : Array Inst) (pc : Nat) : List (Nat × Nat × Nat) :=
  match prog[pc]? with
  | some (.range lo hi out) => [(lo, hi, out)]
  | some (.ranges count) =>
    (List.range count).filterMap fun j =>
      match prog[pc + 1 + j]? with
      | some (.range lo hi out) => some (lo, hi, out)
      | _ => none
  | _ => []

/-- A byte that an instruction takes lies in one of its ranges. -/
theorem takes_range {prog : Array Inst} {pc b out : Nat} (h : Takes prog pc b out) :
    ∃ lo hi, (lo, hi, out) ∈ rangesOf prog pc ∧ lo ≤ b ∧ b ≤ hi := by
  cases h with
  | @range lo hi hp hlo hhi => exact ⟨lo, hi, by simp [rangesOf, hp], hlo, hhi⟩
  | @member count j lo hi hp hj hr hlo hhi =>
    refine ⟨lo, hi, ?_, hlo, hhi⟩
    simp only [rangesOf, hp, List.mem_filterMap, List.mem_range]
    exact ⟨j, hj, by simp [hr]⟩

/-- Every byte of a range has the property. -/
def rangeAll (holds : Nat → Bool) (lo hi : Nat) : Bool :=
  (List.range (hi + 1 - lo)).all fun d => holds (lo + d)

/-- A byte of a range that passes `rangeAll` has the property. -/
theorem rangeAll_byte {holds : Nat → Bool} {lo hi b : Nat} (h : rangeAll holds lo hi = true)
    (hlo : lo ≤ b) (hhi : b ≤ hi) : holds b = true := by
  have := List.all_eq_true.mp h (b - lo) (List.mem_range.mpr (by omega))
  have hb : lo + (b - lo) = b := by omega
  rw [hb] at this
  exact this

/-! ## The three sets -/

/-- The bytes that the instructions of `first` take: the separator. -/
def separator (prog : Array Inst) (first : List Nat) (b : Nat) : Bool :=
  first.any (takesByte prog · b)

/-- The three sets are right for a separator, and `firstByte`, the literal's first byte, is
none. -/
def separatedOk (prog : Array Inst) (before : Nat) (first inside past : List Nat)
    (firstByte : Nat) : Bool :=
  first.contains before &&
    (first.all fun x => (freeSuccessors prog x).all (first.contains ·) && !isDone prog x) &&
    first.all (inside.contains ·) &&
    (inside.all fun x => (freeSuccessors prog x).all (inside.contains ·) &&
      (rangesOf prog x).all fun r =>
        (rangeAll (separator prog first) r.1 r.2.1 && inside.contains r.2.2) ||
          (rangeAll (fun b => !separator prog first b) r.1 r.2.1 && past.contains r.2.2)) &&
    (past.all fun x => (freeSuccessors prog x).all (past.contains ·) &&
      (rangesOf prog x).all fun r =>
        rangeAll (fun b => !separator prog first b) r.1 r.2.1 && past.contains r.2.2) &&
    !separator prog first firstByte

/-- A byte of the text at an offset is a separator. -/
def SepAt (prog : Array Inst) (first : List Nat) (text : List Nat) (q : Nat) : Prop :=
  ∃ b, text[q]? = some b ∧ separator prog first b = true

/-- A path from an instruction of `past` takes no separator. -/
theorem past_clean {prog : Array Inst} {text : List Nat} {first past : List Nat}
    (hpast : past.all (fun x => (freeSuccessors prog x).all (past.contains ·) &&
      (rangesOf prog x).all fun r =>
        rangeAll (fun b => !separator prog first b) r.1 r.2.1 && past.contains r.2.2) = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → pc ∈ past →
      ∀ r, i ≤ r → r < j → ¬ SepAt prog first text r := by
  intro pc i pc' j hpath
  induction hpath with
  | here => intro _ r h1 h2; omega
  | free hfree _ ih =>
    intro hmem
    have hx := List.all_eq_true.mp hpast _ hmem
    simp only [Bool.and_eq_true] at hx
    exact ih (List.contains_iff_mem.mp (List.all_eq_true.mp hx.1 _ (free_successor hfree)))
  | @take pc i b0 mid pc' j hbyte htakes _ ih =>
    intro hmem r h1 h2 hsep
    have hx := List.all_eq_true.mp hpast _ hmem
    simp only [Bool.and_eq_true] at hx
    obtain ⟨lo, hi, hrange, hlo, hhi⟩ := takes_range htakes
    have hr := List.all_eq_true.mp hx.2 _ hrange
    simp only [Bool.and_eq_true] at hr
    have hnot := rangeAll_byte hr.1 hlo hhi
    by_cases hri : r = i
    · obtain ⟨b, hb, hs⟩ := hsep
      rw [hri, hbyte] at hb
      have hbb : b0 = b := Option.some.inj hb
      rw [hbb, hs] at hnot
      cases hnot
    · exact ih (List.contains_iff_mem.mp hr.2) r (by omega) h2 hsep

/-- On a path from an instruction of `inside`, the separators stand first: an offset before a
separator's holds a separator. -/
theorem inside_first {prog : Array Inst} {text : List Nat} {first inside past : List Nat}
    (hinside : inside.all (fun x => (freeSuccessors prog x).all (inside.contains ·) &&
      (rangesOf prog x).all fun r =>
        (rangeAll (separator prog first) r.1 r.2.1 && inside.contains r.2.2) ||
          (rangeAll (fun b => !separator prog first b) r.1 r.2.1 && past.contains r.2.2)) = true)
    (hpast : past.all (fun x => (freeSuccessors prog x).all (past.contains ·) &&
      (rangesOf prog x).all fun r =>
        rangeAll (fun b => !separator prog first b) r.1 r.2.1 && past.contains r.2.2) = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → pc ∈ inside →
      ∀ q r, i ≤ q → q ≤ r → r < j → SepAt prog first text r → SepAt prog first text q := by
  intro pc i pc' j hpath
  induction hpath with
  | here => intro _ q r h1 h2 h3; omega
  | free hfree _ ih =>
    intro hmem
    have hx := List.all_eq_true.mp hinside _ hmem
    simp only [Bool.and_eq_true] at hx
    exact ih (List.contains_iff_mem.mp (List.all_eq_true.mp hx.1 _ (free_successor hfree)))
  | @take pc i b0 mid pc' j hbyte htakes hrest ih =>
    intro hmem q r h1 h2 h3 hsep
    have hx := List.all_eq_true.mp hinside _ hmem
    simp only [Bool.and_eq_true] at hx
    obtain ⟨lo, hi, hrange, hlo, hhi⟩ := takes_range htakes
    have hr := List.all_eq_true.mp hx.2 _ hrange
    simp only [Bool.or_eq_true, Bool.and_eq_true] at hr
    cases hr with
    | inl hin =>
      by_cases hqi : q = i
      · exact ⟨b0, hqi ▸ hbyte, rangeAll_byte hin.1 hlo hhi⟩
      · exact ih (List.contains_iff_mem.mp hin.2) q r (by omega) h2 h3 hsep
    | inr hout =>
      by_cases hri : r = i
      · have hqr : q = r := by omega
        exact hqr ▸ hsep
      · exact absurd hsep
          (past_clean hpast hrest (List.contains_iff_mem.mp hout.2) r (by omega) h3)

/-- A path from an instruction of `first` to `match` takes a byte, and its first byte is a
separator. -/
theorem first_separator {prog : Array Inst} {text : List Nat} {first : List Nat}
    (hfirst : first.all (fun x => (freeSuccessors prog x).all (first.contains ·) &&
      !isDone prog x) = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done → pc ∈ first →
      i < j ∧ SepAt prog first text i := by
  intro pc i pc' j hpath
  induction hpath with
  | here =>
    intro hdone hmem
    have hx := List.all_eq_true.mp hfirst _ hmem
    simp only [Bool.and_eq_true, Bool.not_eq_true'] at hx
    rw [isDone_iff.mpr hdone] at hx
    cases hx.2
  | free hfree _ ih =>
    intro hdone hmem
    have hx := List.all_eq_true.mp hfirst _ hmem
    simp only [Bool.and_eq_true] at hx
    exact ih hdone (List.contains_iff_mem.mp (List.all_eq_true.mp hx.1 _ (free_successor hfree)))
  | @take pc i b0 mid pc' j hbyte htakes hrest _ =>
    intro _ hmem
    have hle := hrest.le
    refine ⟨by omega, b0, hbyte, ?_⟩
    exact List.any_eq_true.mpr ⟨pc, hmem, takesByte_of_takes htakes⟩

/-! ## Claim R4's third rule -/

/-- The three sets of the rule, built from `before`: what the program reaches with no byte,
what it reaches over separators, and what it reaches past a byte that is none. -/
def separatedSets (prog : Array Inst) (before : Nat) : List Nat × List Nat × List Nat :=
  let fuel := prog.size + 1
  let first := growBy (freeSuccessors prog) fuel [before]
  let sep := separator prog first
  let within := fun x =>
    freeSuccessors prog x ++
      (rangesOf prog x).filterMap fun r => if rangeAll sep r.1 r.2.1 then some r.2.2 else none
  let inside := growBy within fuel first
  let leaves := (inside.flatMap fun x =>
    (rangesOf prog x).filterMap fun r =>
      if rangeAll sep r.1 r.2.1 then none else some r.2.2).eraseDups
  let past := growBy (fun x => freeSuccessors prog x ++ (rangesOf prog x).map (·.2.2)) fuel leaves
  (first, inside, past)

/-- The rule for the walk of one literal: the reverse program takes `walked` from its entry,
and the three sets from the instruction after it are right. -/
def separatedAt (rev : Array Inst) (reventry : Nat) (walked : List Nat) : Bool :=
  match walked.reverse[0]?, chainStop rev (chainFuel rev walked) reventry walked with
  | some b, some before =>
    let sets := separatedSets rev before
    separatedOk rev before sets.1 sets.2.1 sets.2.2 b
  | _, _ => false

/-- Claim R4's third rule for a literal with no place that folds: the rule holds for the
literal, or for the literal past some of its first bytes. `walked` holds the literal's bytes
from its last to its first, so such a literal is a first part of `walked`. Gives the count of
the bytes of that part. -/
def separatedOn (rev : Array Inst) (reventry : Nat) (walked : List Nat) : Option Nat :=
  (List.range walked.length).find? fun short =>
    separatedAt rev reventry (walked.take (walked.length - short))

/-- A byte of a text read backward, at the offset that mirrors `q`. -/
theorem mirrored_byte {text : List Nat} {q : Nat} (hq : q < text.length) :
    text.reverse[text.length - 1 - q]? = text[q]? := by
  rw [reverse_byte (by omega)]
  congr 1
  omega

/-- The third rule for the walk of one literal gives `Rising`. -/
theorem separated_rising {prog rev : Array Inst} {entry reventry : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts)
    (hrule : separatedAt rev reventry walked = true) (hlit : 0 < walked.reverse.length) :
    Rising (textOf prog entry text starts hexact) := by
  unfold separatedAt at hrule
  cases hbyte : walked.reverse[0]? with
  | none => simp [hbyte] at hrule
  | some b0 =>
    cases hstop : chainStop rev (chainFuel rev walked) reventry walked with
    | none => simp [hbyte, hstop] at hrule
    | some before =>
      simp only [hbyte, hstop, separatedOk, Bool.and_eq_true, Bool.not_eq_true'] at hrule
      obtain ⟨⟨⟨⟨⟨hstart, hfirst⟩, hsub⟩, hinside⟩, hpast⟩, hnotsep⟩ := hrule
      have hchain := chain_of_chainStop _ _ _ _ hstop
      have hends := endsWith_of_chain hexact hrevexact hrev hclean hchain hlit
      have hlen : walked.reverse.length = walked.length := List.length_reverse
      have hbefore := List.contains_iff_mem.mp hstart
      -- The rest of a match's path over the text read backward, from the literal's first byte.
      have hrest : ∀ s e, (textOf prog entry text starts hexact).Match s e →
          s ≤ e ∧ e ≤ text.length ∧ ∃ pc, rev[pc]? = some .done ∧
            Path rev text.reverse before (text.length - e + walked.length) pc
              (text.length - s) := by
        intro s e hm
        have hin := matches_inside hm.1 hm.2.2
        obtain ⟨pc, hpath, hdone⟩ := reversed_match hexact hrev hm
        exact ⟨hin.1, hin.2, pc, hdone, (chain_path hchain hpath hdone).2⟩
      apply rising_of_last_separator (c := scansOf hexact hrevexact hrev hclean walked.reverse hlit)
        (Sep := SepAt rev (separatedSets rev before).1 text) hends
      · intro s e hm
        obtain ⟨hse, he, pc, hdone, hpath⟩ := hrest s e hm
        obtain ⟨hlt, b, hb, hsep⟩ := first_separator hfirst hpath hdone hbefore
        show s < e - walked.reverse.length ∧ _
        refine ⟨by omega, b, ?_, hsep⟩
        show text[e - walked.reverse.length - 1]? = some b
        rw [← mirrored_byte (by omega)]
        have hidx : text.length - 1 - (e - walked.reverse.length - 1) =
            text.length - e + walked.length := by omega
        rw [hidx]
        exact hb
      · intro s e hm q r hsq hqr hre hsepq
        have hre' : r < e - walked.length := by
          have : (scansOf hexact hrevexact hrev hclean walked.reverse hlit).width =
              walked.reverse.length := rfl
          omega
        obtain ⟨hse, he, pc, _, hpath⟩ := hrest s e hm
        obtain ⟨b, hb, hsep⟩ := hsepq
        have hinsideMem := List.contains_iff_mem.mp (List.all_eq_true.mp hsub _ hbefore)
        have hmirror : SepAt rev (separatedSets rev before).1 text.reverse
            (text.length - 1 - q) := ⟨b, by rw [mirrored_byte (by omega)]; exact hb, hsep⟩
        obtain ⟨b', hb', hsep'⟩ := inside_first hinside hpast hpath hinsideMem
          (text.length - 1 - r) (text.length - 1 - q) (by omega) (by omega) (by omega) hmirror
        exact ⟨b', by rw [← mirrored_byte (by omega)]; exact hb', hsep'⟩
      · intro p hp hsep
        obtain ⟨b, hb, hs⟩ := hsep
        have hat := hp.2 0 hlit
        rw [Nat.add_zero, hbyte] at hat
        rw [hat] at hb
        have hbb : b0 = b := Option.some.inj hb
        rw [← hbb, hnotsep] at hs
        cases hs

/-- Claim R4 over a program, from the third rule: where `separatedOn` holds for a literal,
`Searcher.find_by_suffix` over the model's scans gives the matcher's answer from `low`, for a
text that has the builder's hypotheses. The search goes to the places of the whole literal. -/
theorem separated_program {prog rev : Array Inst} {entry reventry before short : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts)
    (hchain : Chain rev reventry walked before)
    (hrule : separatedOn rev reventry walked = some short) (hlit : 0 < walked.reverse.length)
    {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (bySuffix (scansOf hexact hrevexact hrev hclean walked.reverse hlit) low
        (text.length - low + 1) low) := by
  have hat := List.find?_some hrule
  have hshort := List.mem_range.mp (List.mem_of_find?_eq_some hrule)
  have hpart : 0 < (walked.take (walked.length - short)).reverse.length := by
    simp only [List.length_reverse, List.length_take]
    omega
  exact bySuffix_rising (separated_rising hexact hrevexact hrev hclean hat hpart)
    (endsWith_of_chain hexact hrevexact hrev hclean hchain hlit) hlow

/-! ## The second rule or the third -/

/-- The most bytes that the second rule's walk reads for the part before a literal. The Zig
walk stops at `suffix_before_len_max`, which is 8. A greater bound here refuses no literal that
the Zig rule takes, and the proof holds for each bound. -/
def fixedMost : Nat := 16

/-- Claim R4's second rule or its third, for a literal with no place that folds: what a
searcher judges after its searches were given enough text (`dfa_suffix.wide`). -/
def wideOn (rev : Array Inst) (reventry : Nat) (walked : List Nat) : Bool :=
  (chainStop rev (chainFuel rev walked) reventry walked).isSome &&
    ((fixedOn rev reventry walked fixedMost).isSome || (separatedOn rev reventry walked).isSome)

/-- Claim R4 over a program, from the second rule or the third: where `wideOn` holds for a
literal, `Searcher.find_by_suffix` over the model's scans gives the matcher's answer from
`low`, for a text that has the builder's hypotheses. -/
theorem wide_program {prog rev : Array Inst} {entry reventry : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts)
    (hrule : wideOn rev reventry walked = true) (hlit : 0 < walked.reverse.length)
    {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (bySuffix (scansOf hexact hrevexact hrev hclean walked.reverse hlit) low
        (text.length - low + 1) low) := by
  simp only [wideOn, Bool.and_eq_true, Bool.or_eq_true] at hrule
  obtain ⟨hstop, hcase⟩ := hrule
  cases hcase with
  | inl hfixed =>
    obtain ⟨n, hn⟩ := Option.isSome_iff_exists.mp hfixed
    exact fixed_program hexact hrevexact hrev hclean hn hlit hlow
  | inr hseparated =>
    obtain ⟨before, hbefore⟩ := Option.isSome_iff_exists.mp hstop
    obtain ⟨short, hshort⟩ := Option.isSome_iff_exists.mp hseparated
    exact separated_program hexact hrevexact hrev hclean (chain_of_chainStop _ _ _ _ hbefore)
      hshort hlit hlow

/-! ## The rule on small programs -/

/-- `[a-c]+ +xy` has the reverse program `yx +[a-c]+`: from 0 it takes `y`, then `x`, and from
2 a space or more, then a letter or more. The separator is the space, the letters are none,
and `x` is none, so the rule holds for the literal `xy`, whole.

`[a-c ]+ +xy` takes a space among its letters, so the rule fails for `xy`. It holds for `y`:
the separator is then `x`, which the part before takes once. `[a-cxy ]+ +xy` takes `x` there
too, and the rule holds for no part of the literal. -/
example :
    separatedOn #[.range 121 121 1, .range 120 120 2, .range 32 32 3, .split 2 4,
        .range 97 99 5, .split 4 6, .done] 0 [121, 120] = some 0 ∧
      separatedOn #[.range 121 121 1, .range 120 120 2, .range 32 32 3, .split 2 4,
        .ranges 2, .range 32 32 7, .range 97 99 7, .split 4 8, .done] 0 [121, 120] = some 1 ∧
      separatedOn #[.range 121 121 1, .range 120 120 2, .range 32 32 3, .split 2 4,
        .ranges 3, .range 32 32 8, .range 97 99 8, .range 120 121 8, .split 4 9, .done] 0
        [121, 120] = none := by
  decide

end Stdx.Regex.Matcher
