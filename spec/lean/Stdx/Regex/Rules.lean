import Stdx.Regex.Searcher

/-!
# The rules of the claims, decided from a program

A searcher takes a claim after it reads its program: `dfa_suffix.suffix_of` walks the reverse
program before claim R4 goes to a literal's places (decision 86). `Searcher.lean` proves the
search from what such a walk found, as hypotheses. This file decides those hypotheses from a
program, and proves each decision.

- `chainStop` follows a literal's places through a program, as `Literal.walk` reads them, and
  gives the instruction after the last one. `chain_of_chainStop` gives `Chain`. A place that
  folds is a split between a letter's two cases.
- `reachOf` gives a set of instructions, and `closedUnder` checks that the set holds each
  instruction its members lead to. `reach_mem` proves that such a set holds every instruction
  the program reaches from a member. The proof reads the check alone, and nothing of how the
  set was built.
- `noneTakes` is `dfa_suffix.before_takes`, negated: no instruction that the program reaches
  from `before` takes a byte. `noneTakes_sound` proves it.
- `apartOn` is claim R4's first rule, and `apart_program` gives the search's answer from it.

`spec/lean/Vectors.lean` runs `apartOn` for each literal that a Zig searcher took by the first
rule. A rule that holds for a program holds for each text, so a literal that fails here is a
wrong choice for some text, and not for the drawn text alone.

`RulesWide.lean` and `RulesSeparator.lean` decide the second rule and the third, and
`RulesInner.lean` claim R14's rule.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The walk of a literal -/

/-- Whether a place holds the two bytes and no other, in either order. -/
def holds (place : Nat × Nat) (x y : Nat) : Bool :=
  (place.1 == x && place.2 == y) || (place.1 == y && place.2 == x)

/-- A place that holds two bytes takes those two and no other. -/
theorem holds_fits {place : Nat × Nat} {x y : Nat} (h : holds place x y = true) :
    ∀ c, Fits place c ↔ c = x ∨ c = y := by
  simp only [holds, Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq] at h
  intro c
  unfold Fits
  cases h with
  | inl h => rw [h.1, h.2]
  | inr h =>
    rw [h.1, h.2]
    exact Or.comm

/-- A place that holds one byte twice takes that byte and no other. -/
theorem holds_one {place : Nat × Nat} {b : Nat} (h : holds place b b = true) :
    ∀ c, Fits place c ↔ c = b :=
  fun c => (holds_fits h c).trans ⟨fun hc => hc.elim id id, Or.inl⟩

/-- The two bytes and the next instruction of two instructions that are each a range of one
byte and lead to one instruction: what `literal.case_pair` reads behind a split, with no rule
for the two bytes. -/
def foldOf (prog : Array Inst) (one other : Nat) : Option (Nat × Nat × Nat) :=
  match prog[one]?, prog[other]? with
  | some (.range x x' out), some (.range y y' out') =>
    if x = x' ∧ y = y' ∧ out = out' then some (x, y, out) else none
  | _, _ => none

/-- What `foldOf` gives is what the two instructions hold. -/
theorem foldOf_some {prog : Array Inst} {one other x y out : Nat}
    (h : foldOf prog one other = some (x, y, out)) :
    prog[one]? = some (.range x x out) ∧ prog[other]? = some (.range y y out) := by
  unfold foldOf at h
  cases h1 : prog[one]? with
  | none => simp [h1] at h
  | some i1 =>
    cases h2 : prog[other]? with
    | none => cases i1 <;> simp [h1, h2] at h
    | some i2 =>
      cases i1 <;> cases i2 <;> simp [h1, h2] at h
      obtain ⟨⟨h3, h4, h5⟩, h6, h7, h8⟩ := h
      subst h3 h4 h5 h6 h7 h8
      exact ⟨rfl, rfl⟩

/-- The instruction where a program stands after it takes a byte of each place of `walked`,
one after another from `pc`, through saves, jumps and assertions, in at most `fuel` moves. A
place is a range of the one byte that the place holds, or a split between the ranges of its
two bytes. Nothing where an instruction takes another byte, or more than one. -/
def chainStop (prog : Array Inst) : Nat → Nat → List (Nat × Nat) → Option Nat
  | _, pc, [] => some pc
  | 0, _, _ :: _ => none
  | fuel + 1, pc, place :: rest =>
    match prog[pc]? with
    | some (.save _ out) => chainStop prog fuel out (place :: rest)
    | some (.jump out) => chainStop prog fuel out (place :: rest)
    | some (.look _ out) => chainStop prog fuel out (place :: rest)
    | some (.range lo hi out) =>
      if lo = hi ∧ holds place lo lo = true then chainStop prog fuel out rest else none
    | some (.split one other) =>
      match foldOf prog one other with
      | some (x, y, out) =>
        if holds place x y = true then chainStop prog fuel out rest else none
      | none => none
    | _ => none

/-- A walk that `chainStop` follows is a `Chain`. -/
theorem chain_of_chainStop {prog : Array Inst} :
    ∀ fuel pc walked stop, chainStop prog fuel pc walked = some stop →
      Chain prog pc walked stop := by
  intro fuel
  induction fuel with
  | zero =>
    intro pc walked stop h
    cases walked with
    | nil =>
      have hstop : pc = stop := by simpa [chainStop] using h
      exact hstop ▸ .stop
    | cons b rest => simp [chainStop] at h
  | succ fuel ih =>
    intro pc walked stop h
    cases walked with
    | nil =>
      have hstop : pc = stop := by simpa [chainStop] using h
      exact hstop ▸ .stop
    | cons place rest =>
      simp only [chainStop] at h
      cases hp : prog[pc]? with
      | none => simp [hp] at h
      | some inst =>
        cases inst with
        | save slot out => exact .save hp (ih out _ stop (by simpa [hp] using h))
        | jump out => exact .jump hp (ih out _ stop (by simpa [hp] using h))
        | look l out => exact .look hp (ih out _ stop (by simpa [hp] using h))
        | range lo hi out =>
          simp only [hp] at h
          by_cases hb : lo = hi ∧ holds place lo lo = true
          · rw [ite_eq_left hb] at h
            obtain ⟨hlo, hfit⟩ := hb
            subst hlo
            exact .byte hp (holds_one hfit) (ih out rest stop h)
          · rw [ite_eq_right hb] at h
            cases h
        | split one other =>
          simp only [hp] at h
          cases hf : foldOf prog one other with
          | none => simp [hf] at h
          | some found =>
            obtain ⟨x, y, out⟩ := found
            simp only [hf] at h
            by_cases hb : holds place x y = true
            · rw [ite_eq_left hb] at h
              have ⟨h1, h2⟩ := foldOf_some hf
              exact .fold hp h1 h2 (holds_fits hb) (ih out rest stop h)
            · rw [ite_eq_right hb] at h
              cases h
        | ranges count => simp [hp] at h
        | done => simp [hp] at h
        | fail => simp [hp] at h

/-! ## The instructions a program reaches -/

/-- The instructions that one move of an instruction leads to. -/
def successors (prog : Array Inst) (pc : Nat) : List Nat :=
  match prog[pc]? with
  | some (.range _ _ out) => [out]
  | some (.ranges count) =>
    (List.range count).filterMap fun j =>
      match prog[pc + 1 + j]? with
      | some (.range _ _ out) => some out
      | _ => none
  | some (.split out arg) => [out, arg]
  | some (.save _ out) => [out]
  | some (.jump out) => [out]
  | some (.look _ out) => [out]
  | _ => []

/-- A move leads to one of the instruction's successors. -/
theorem edge_successor {prog : Array Inst} {pc mid : Nat} (h : Edge prog pc mid) :
    mid ∈ successors prog pc := by
  cases h with
  | takes htakes =>
    cases htakes with
    | range hp _ _ => simp [successors, hp]
    | @member count j lo hi hp hj hr _ _ =>
      simp only [successors, hp, List.mem_filterMap, List.mem_range]
      exact ⟨j, hj, by simp [hr]⟩
  | splitOut hp => simp [successors, hp]
  | splitArg hp => simp [successors, hp]
  | save hp => simp [successors, hp]
  | jump hp => simp [successors, hp]
  | look hp => simp [successors, hp]

/-- The set holds each instruction that its members lead to. -/
def closedUnder (prog : Array Inst) (set : List Nat) : Bool :=
  set.all fun x => (successors prog x).all (set.contains ·)

/-- A set that is closed holds every instruction the program reaches from a member. -/
theorem reach_mem {prog : Array Inst} {set : List Nat} (hclosed : closedUnder prog set = true)
    {pc x : Nat} (hreach : Reach prog pc x) : pc ∈ set → x ∈ set := by
  induction hreach with
  | here => exact id
  | move hedge _ ih =>
    intro hpc
    apply ih
    have hall := List.all_eq_true.mp hclosed _ hpc
    have := List.all_eq_true.mp hall _ (edge_successor hedge)
    exact List.contains_iff_mem.mp this

/-- A set grown `fuel` times: each time by the successors of its members that it lacks. -/
def grow (prog : Array Inst) : Nat → List Nat → List Nat
  | 0, set => set
  | fuel + 1, set =>
    let more := ((set.flatMap (successors prog)).filter (!set.contains ·)).eraseDups
    if more.isEmpty then set else grow prog fuel (set ++ more)

/-- The instructions a program reaches from `pc`, where the set came out closed. Each growth
adds an instruction or ends, so as many growths as the program has instructions are enough. -/
def reachOf (prog : Array Inst) (pc : Nat) : List Nat :=
  grow prog (prog.size + 1) [pc]

/-! ## A byte that no instruction takes -/

/-- Whether an instruction takes a byte, by its range or by one of its node's ranges. -/
def takesByte (prog : Array Inst) (pc b : Nat) : Bool :=
  match prog[pc]? with
  | some (.range lo hi _) => decide (lo ≤ b) && decide (b ≤ hi)
  | some (.ranges count) =>
    (List.range count).any fun j =>
      match prog[pc + 1 + j]? with
      | some (.range lo hi _) => decide (lo ≤ b) && decide (b ≤ hi)
      | _ => false
  | _ => false

/-- `takesByte` holds for each instruction that takes the byte. -/
theorem takesByte_of_takes {prog : Array Inst} {pc b out : Nat} (h : Takes prog pc b out) :
    takesByte prog pc b = true := by
  cases h with
  | range hp hlo hhi => simp [takesByte, hp, hlo, hhi]
  | @member count j lo hi hp hj hr hlo hhi =>
    simp only [takesByte, hp, List.any_eq_true, List.mem_range]
    exact ⟨j, hj, by simp [hr, hlo, hhi]⟩

/-- `dfa_suffix.before_takes`, negated and decided: no instruction that the program reaches
from `before` takes the byte `b`. -/
def noneTakes (prog : Array Inst) (before b : Nat) : Bool :=
  closedUnder prog (reachOf prog before) && (reachOf prog before).contains before &&
    (reachOf prog before).all fun x => !takesByte prog x b

/-- Where `noneTakes` holds, no instruction that the program reaches from `before` takes `b`. -/
theorem noneTakes_sound {prog : Array Inst} {before b : Nat}
    (h : noneTakes prog before b = true) :
    ∀ x out, Reach prog before x → ¬ Takes prog x b out := by
  simp only [noneTakes, Bool.and_eq_true] at h
  obtain ⟨⟨hclosed, hstart⟩, hnone⟩ := h
  intro x out hreach htakes
  have hx := reach_mem hclosed hreach (List.contains_iff_mem.mp hstart)
  have := List.all_eq_true.mp hnone x hx
  rw [takesByte_of_takes htakes] at this
  cases this

/-! ## Claim R4's first rule -/

/-- The moves a walk of a literal may take: each instruction of the program once, and one
more for each place. -/
def chainFuel (prog : Array Inst) (walked : List (Nat × Nat)) : Nat :=
  prog.size + walked.length + 1

/-- Claim R4's first rule. `walked` holds the literal's places from its last to its first, as
the walk of the reverse program reads them. The reverse program takes them from its entry, and
no instruction it reaches after them takes a byte of the literal's first place: the first
byte, in either case where the place folds (`dfa_suffix.apart`). Gives the place's first byte
and the instruction after the literal. -/
def apartOn (rev : Array Inst) (reventry : Nat) (walked : List (Nat × Nat)) :
    Option (Nat × Nat) :=
  match walked.reverse[0]?, chainStop rev (chainFuel rev walked) reventry walked with
  | some place, some before =>
    if noneTakes rev before place.1 && noneTakes rev before place.2 then
      some (place.1, before)
    else none
  | _, _ => none

/-- Claim R4 over a program, from the decided rule: where `apartOn` holds for a literal,
`Searcher.find_by_suffix` over the model's scans gives the matcher's answer from `low`, for a
text that has the builder's hypotheses. -/
theorem apart_program {prog rev : Array Inst} {entry reventry b before : Nat}
    {text : List Nat} {walked : List (Nat × Nat)} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts)
    (hrule : apartOn rev reventry walked = some (b, before)) (hlit : 0 < walked.reverse.length)
    {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (bySuffix (scansOf hexact hrevexact hrev hclean walked.reverse hlit) low
        (text.length - low + 1) low) := by
  unfold apartOn at hrule
  cases hfirst : walked.reverse[0]? with
  | none => simp [hfirst] at hrule
  | some place =>
    obtain ⟨b0, b1⟩ := place
    cases hstop : chainStop rev (chainFuel rev walked) reventry walked with
    | none => simp [hfirst, hstop] at hrule
    | some before' =>
      simp only [hfirst, hstop] at hrule
      by_cases hnone : (noneTakes rev before' b0 && noneTakes rev before' b1) = true
      · simp only [Bool.and_eq_true] at hnone
        exact bySuffix_program hexact hrevexact hrev hclean
          (chain_of_chainStop _ _ _ _ hstop) (noneTakes_sound hnone.1)
          (noneTakes_sound hnone.2) hlit hfirst hlow
      · rw [ite_eq_right hnone] at hrule
        cases hrule

/-! ## The rule on small programs -/

/-- `[0-9]+ab` has the reverse program `ba[0-9]+`: from 0 it takes `b`, then `a`, and from 2 a
digit or more. The walk of `b`, `a` stops at 2, and no instruction from there takes `a`, so the
rule holds for the literal `ab`. `[a-c]+ab` has `ba[a-c]+`, whose part from 2 takes `a`: the
rule fails. A walk of other bytes follows no chain. -/
example :
    apartOn #[.range 98 98 1, .range 97 97 2, .range 48 57 3, .split 2 4, .done] 0
        [(98, 98), (97, 97)] = some (97, 2) ∧
      apartOn #[.range 98 98 1, .range 97 97 2, .range 97 99 3, .split 2 4, .done] 0
        [(98, 98), (97, 97)] = none ∧
      apartOn #[.range 98 98 1, .range 97 97 2, .range 48 57 3, .split 2 4, .done] 0
        [(98, 98), (98, 98)] = none ∧
      reachOf #[.range 98 98 1, .range 97 97 2, .range 48 57 3, .split 2 4, .done] 2
        = [2, 3, 4] := by decide

/-- `[0-9]+(?i:a)b` has the reverse program `b(?i:a)[0-9]+`: from 0 it takes `b`, at 1 a split
between `a` and `A`, and from 4 a digit or more. The walk reads the place of `a` in either
case, and the rule holds: no digit is `a` or `A`. `[0-9A]+(?i:a)b` takes `A` before the
literal, so the rule fails for the place that folds, and would hold for `a` alone. -/
example :
    apartOn #[.range 98 98 1, .split 2 3, .range 97 97 4, .range 65 65 4, .range 48 57 5,
        .split 4 6, .done] 0 [(98, 98), (97, 65)] = some (97, 4) ∧
      apartOn #[.range 98 98 1, .split 2 3, .range 97 97 4, .range 65 65 4, .ranges 2,
        .range 48 57 7, .range 65 65 7, .split 4 8, .done] 0 [(98, 98), (97, 65)] = none ∧
      apartOn #[.range 98 98 1, .split 2 3, .range 97 97 4, .range 65 65 4, .range 48 57 5,
        .split 4 6, .done] 0 [(98, 98), (97, 97)] = none := by decide

end Stdx.Regex.Matcher
