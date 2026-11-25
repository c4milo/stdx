import Stdx.Regex.RulesWide

/-!
# Claims R2 and R3, decided from a program with more than one way to start

A searcher goes to the places of a literal that every match starts with (decision 86, claims R2
and R3, `literal.zig`). `Searcher.lean` proves that search for a literal that `Chain` reads: the
instructions that follow one another from the program's entry. An alternation has no such chain,
because each of its ways starts with instructions of its own. This file decides the claim for
any program: every way to start reads the literal, as in `(?m)^ab|ab$`, whose two ways both
start with `ab`, one of them after an assertion.

- `leadsOk` checks a list of sets of instructions, one set a level: level `k` holds each
  instruction that a path from the entry stands at after `k` bytes. Below the literal's length,
  a level holds no `match`, and each of its instructions that takes a byte takes the literal's
  byte of that level alone, or its byte in either case.
- `reads_of_leadsOk` proves from the check alone that a path from a level's instruction to
  `match` reads the rest of the literal. It reads nothing of how `levelsFrom` built the levels.
- `leadsOn` is the rule for a literal, and `leads_program` gives the search's answer from it.

An assertion is a move with no byte here, whatever the text holds. So the check judges more
paths than one text has, and holds for every text.

The Zig walk, `literal_common.zig`, stops at a count of instructions a level. The proof needs no
such count: the count bounds what `Searcher.init` costs, and changes no answer.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The check of a level -/

/-- Each byte that the instruction at `pc` takes fits `place`: a range of one byte that the
place holds. A node of ranges fails the check, and an instruction that takes no byte passes. -/
def takesFit (prog : Array Inst) (pc : Nat) (place : Nat × Nat) : Bool :=
  match prog[pc]? with
  | some (.range lo hi _) => lo == hi && (lo == place.1 || lo == place.2)
  | some (.ranges _) => false
  | _ => true

/-- Where `takesFit` holds, a byte that the instruction takes fits the place. -/
theorem fits_of_takesFit {prog : Array Inst} {pc b out : Nat} {place : Nat × Nat}
    (h : takesFit prog pc place = true) (ht : Takes prog pc b out) : Fits place b := by
  cases ht with
  | @range lo hi hp hlo hhi =>
    simp only [takesFit, hp, Bool.and_eq_true, Bool.or_eq_true, beq_iff_eq] at h
    obtain ⟨heq, hfit⟩ := h
    have hb : b = lo := by omega
    cases hfit with
    | inl h1 => exact Or.inl (hb.trans h1)
    | inr h2 => exact Or.inr (hb.trans h2)
  | member hp _ _ _ _ => simp [takesFit, hp] at h

/-- Level `k` of `levels` is right for the literal's place `k`: it holds each instruction its
members lead to with no byte, level `k + 1` holds each one they lead to with a byte, it holds no
`match`, and each byte that a member takes fits the place. A level past the literal passes. -/
def leadOk (prog : Array Inst) (lit : List (Nat × Nat)) (levels : List (List Nat)) (k : Nat) :
    Bool :=
  match lit[k]? with
  | none => true
  | some place =>
    (levels.getD k []).all fun x =>
      (freeSuccessors prog x).all ((levels.getD k []).contains ·) &&
        (byteSuccessors prog x).all ((levels.getD (k + 1) []).contains ·) &&
        !isDone prog x && takesFit prog x place

/-- The levels are right for a walk from `entry` whose every path reads `lit` first: level 0
holds `entry`, and each level below the literal's length is right. -/
def leadsOk (prog : Array Inst) (entry : Nat) (lit : List (Nat × Nat))
    (levels : List (List Nat)) : Bool :=
  (levels.getD 0 []).contains entry && (List.range lit.length).all (leadOk prog lit levels)

/-- A literal with no place left stands anywhere. -/
theorem reads_past {text : List Nat} {lit : List (Nat × Nat)} {k i : Nat}
    (hk : lit.length ≤ k) : Reads text (lit.drop k) i := by
  intro m place hm
  rw [List.drop_eq_nil_of_le hk] at hm
  simp at hm

/-- Where the levels are right, a path from an instruction of level `k` to `match` reads the
literal's places from `k` on. -/
theorem reads_of_leadsOk {prog : Array Inst} {text : List Nat} {entry : Nat}
    {lit : List (Nat × Nat)} {levels : List (List Nat)}
    (h : leadsOk prog entry lit levels = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done →
      ∀ k, pc ∈ levels.getD k [] → Reads text (lit.drop k) i := by
  simp only [leadsOk, Bool.and_eq_true] at h
  obtain ⟨_, hall⟩ := h
  have hlevel : ∀ k (hk : k < lit.length), ∀ x, x ∈ levels.getD k [] →
      (∀ y, y ∈ freeSuccessors prog x → y ∈ levels.getD k []) ∧
        (∀ y, y ∈ byteSuccessors prog x → y ∈ levels.getD (k + 1) []) ∧
        isDone prog x = false ∧ takesFit prog x lit[k] = true := by
    intro k hk x hx
    have hok := List.all_eq_true.mp hall k (List.mem_range.mpr hk)
    simp only [leadOk, List.getElem?_eq_getElem hk] at hok
    have hx' := List.all_eq_true.mp hok x hx
    simp only [Bool.and_eq_true, Bool.not_eq_true'] at hx'
    obtain ⟨⟨⟨hfree, hbyte⟩, hdone⟩, hfit⟩ := hx'
    refine ⟨?_, ?_, hdone, hfit⟩
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hfree y hy)
    · intro y hy
      exact List.contains_iff_mem.mp (List.all_eq_true.mp hbyte y hy)
  intro pc i pc' j hpath
  induction hpath with
  | here =>
    intro hdone k hmem
    by_cases hk : k < lit.length
    · have hnot := (hlevel k hk _ hmem).2.2.1
      rw [isDone_iff.mpr hdone] at hnot
      cases hnot
    · exact reads_past (Nat.le_of_not_lt hk)
  | free hfree _ ih =>
    intro hdone k hmem
    by_cases hk : k < lit.length
    · exact ih hdone k ((hlevel k hk _ hmem).1 _ (free_successor hfree))
    · exact reads_past (Nat.le_of_not_lt hk)
  | take hbyte htakes _ ih =>
    intro hdone k hmem
    by_cases hk : k < lit.length
    · have hl := hlevel k hk _ hmem
      have hrest := ih hdone (k + 1) (hl.2.1 _ (takes_successor htakes))
      rw [List.drop_eq_getElem_cons hk]
      exact reads_cons hbyte (fits_of_takesFit hl.2.2.2 htakes) hrest
    · exact reads_past (Nat.le_of_not_lt hk)

/-! ## The rule for a literal -/

/-- The rule of claims R2 and R3: every path from `entry` to `match` reads `lit` first. The
levels are those of a walk from `entry`, one level for each place of the literal and one past
them. -/
def leadsOn (prog : Array Inst) (entry : Nat) (lit : List (Nat × Nat)) : Bool :=
  leadsOk prog entry lit (levelsFrom prog (lit.length + 1) [entry])

/-- Where the rule holds, a match from `s` reads the literal at `s`. -/
theorem leads_reads {prog : Array Inst} {text : List Nat} {entry s pc e : Nat}
    {lit : List (Nat × Nat)} (h : leadsOn prog entry lit = true)
    (hpath : Path prog text entry s pc e) (hdone : prog[pc]? = some .done) :
    Reads text lit s := by
  -- The proof reads the levels' check alone, and nothing of how many levels `leadsOn` builds.
  unfold leadsOn at h
  have hstart := h
  simp only [leadsOk, Bool.and_eq_true] at hstart
  have := reads_of_leadsOk h hpath hdone 0 (List.contains_iff_mem.mp hstart.1)
  simpa using this

/-- A text that reads a literal of one place or more at an offset holds the literal's bytes
from there. -/
theorem reads_inside {text : List Nat} {lit : List (Nat × Nat)} {s : Nat}
    (hlit : 0 < lit.length) (hreads : Reads text lit s) : s + lit.length ≤ text.length := by
  have hn : lit.length - 1 < lit.length := by omega
  have ⟨c, hc, _⟩ := hreads (lit.length - 1) lit[lit.length - 1] (List.getElem?_eq_getElem hn)
  have := (List.getElem?_eq_some_iff.mp hc).1
  omega

/-- Every match starts with a literal that the rule holds for. -/
theorem startsWith_of_leads {prog rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    {lit : List (Nat × Nat)} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hleads : leadsOn prog entry lit = true)
    (hlit : 0 < lit.length) :
    StartsWith (textOf prog entry text starts hexact)
      (scansOf hexact hrevexact hrev hclean lit hlit) := by
  intro s e hm
  obtain ⟨pc, hpath, hdone⟩ := hm.2.2
  have hreads := leads_reads hleads hpath hdone
  exact ⟨reads_inside hlit hreads, hreads⟩

/-- The skip over a program with more than one way to start. The rule holds for `lit`, so every
match starts with it. Then the search from the literal's first place gives the matcher's answer
from `low`. -/
theorem leads_program {prog rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    {lit : List (Nat × Nat)} {mayByte : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text (Dfa.startsOf text mayByte))
    (hleads : leadsOn prog entry lit = true) (hlit : 0 < lit.length) (low : Nat) :
    IsAnswer (textOf prog entry text (Dfa.startsOf text mayByte) hexact) low
      (bySkip prog entry rev reventry text mayByte lit low) := by
  have hstarts := startsWith_of_leads hexact hrevexact hrev hclean hleads hlit
  unfold bySkip
  cases hplace : findLiteral text lit low with
  | none => exact answer_none hstarts hplace
  | some p =>
    have hp := (scansOf hexact hrevexact hrev hclean lit hlit).place_some hplace
    have hlen : p ≤ text.length := by
      have := hp.2.1
      omega
    exact answer_from_place hstarts hplace
      (byDfa_answer hexact hrevexact hrev (emptyElsewhere_of_startsClean hclean) hlen)

/-! ## The rule on small programs -/

/-- `ab|ab` from 0: each way starts with `ab`, so the rule holds for `ab` and for `a`. It
fails for `abc`, which the program does not read, and for `b`. `ab|ac` holds `a` alone.
`(?i:a)b|ab` holds `ab` with a first place of either case, and not `ab` in one case. A way
that ends before the literal is whole fails: `ab|a`. -/
example :
    leadsOn #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 4, .range 98 98 5,
        .done] 0 [(97, 97), (98, 98)] = true ∧
      leadsOn #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 4, .range 98 98 5,
        .done] 0 [(97, 97)] = true ∧
      leadsOn #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 4, .range 98 98 5,
        .done] 0 [(97, 97), (98, 98), (99, 99)] = false ∧
      leadsOn #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 4, .range 98 98 5,
        .done] 0 [(98, 98)] = false ∧
      leadsOn #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 4, .range 99 99 5,
        .done] 0 [(97, 97)] = true ∧
      leadsOn #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 4, .range 99 99 5,
        .done] 0 [(97, 97), (98, 98)] = false ∧
      leadsOn #[.split 1 5, .split 2 3, .range 97 97 4, .range 65 65 4, .range 98 98 7,
        .range 97 97 6, .range 98 98 7, .done] 0 [(97, 65), (98, 98)] = true ∧
      leadsOn #[.split 1 5, .split 2 3, .range 97 97 4, .range 65 65 4, .range 98 98 7,
        .range 97 97 6, .range 98 98 7, .done] 0 [(97, 97), (98, 98)] = false ∧
      leadsOn #[.split 1 3, .range 97 97 2, .range 98 98 4, .range 97 97 4, .done] 0
        [(97, 97), (98, 98)] = false := by decide

end Stdx.Regex.Matcher
