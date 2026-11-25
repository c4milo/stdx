import Stdx.Regex.Searcher

/-!
# The rules of the claims, decided from a program

A searcher takes a claim after it reads its program: `dfa_suffix.suffix_of` walks the reverse
program before claim R4 goes to a literal's places (decision 86). `Searcher.lean` proves the
search from what such a walk found, as hypotheses. This file decides those hypotheses from a
program, and proves each decision.

- `chainStop` follows a literal's bytes through a program, as `Literal.walk` reads them, and
  gives the instruction after the last one. `chain_of_chainStop` gives `Chain`.
- `reachOf` gives a set of instructions, and `closedUnder` checks that the set holds each
  instruction its members lead to. `reach_mem` proves that such a set holds every instruction
  the program reaches from a member. The proof reads the check alone, and nothing of how the
  set was built.
- `noneTakes` is `dfa_suffix.before_takes`, negated: no instruction that the program reaches
  from `before` takes a byte. `noneTakes_sound` proves it.
- `apartOn` is claim R4's first rule for a literal with no place that folds, and
  `apart_program` gives the search's answer from it.

`spec/lean/Vectors.lean` runs `apartOn` for each literal that a Zig searcher took by the first
rule. A rule that holds for a program holds for each text, so a literal that fails here is a
wrong choice for some text, and not for the drawn text alone.

`RulesWide.lean` and `RulesSeparator.lean` decide the second rule and the third, and
`RulesInner.lean` claim R14's rule. No file decides a literal with a place that folds.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The walk of a literal -/

/-- The instruction where a program stands after it takes the bytes of `walked` one after
another from `pc`, through saves, jumps and assertions, in at most `fuel` moves. Nothing where
an instruction takes another byte, or more than one. -/
def chainStop (prog : Array Inst) : Nat → Nat → List Nat → Option Nat
  | _, pc, [] => some pc
  | 0, _, _ :: _ => none
  | fuel + 1, pc, b :: rest =>
    match prog[pc]? with
    | some (.save _ out) => chainStop prog fuel out (b :: rest)
    | some (.jump out) => chainStop prog fuel out (b :: rest)
    | some (.look _ out) => chainStop prog fuel out (b :: rest)
    | some (.range lo hi out) =>
      if lo = b ∧ hi = b then chainStop prog fuel out rest else none
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
    | cons b rest =>
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
          by_cases hb : lo = b ∧ hi = b
          · rw [ite_eq_left hb] at h
            obtain ⟨hlo, hhi⟩ := hb
            subst hlo
            subst hhi
            exact .byte hp (ih out rest stop h)
          · rw [ite_eq_right hb] at h
            cases h
        | ranges count => simp [hp] at h
        | split out arg => simp [hp] at h
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
more for each byte. -/
def chainFuel (prog : Array Inst) (walked : List Nat) : Nat :=
  prog.size + walked.length + 1

/-- Claim R4's first rule for a literal with no place that folds. `walked` holds the literal's
bytes from its last to its first, as the walk of the reverse program reads them. The reverse
program takes those bytes from its entry, and no instruction it reaches after them takes the
literal's first byte. Gives that byte and the instruction after the literal. -/
def apartOn (rev : Array Inst) (reventry : Nat) (walked : List Nat) : Option (Nat × Nat) :=
  match walked.reverse[0]?, chainStop rev (chainFuel rev walked) reventry walked with
  | some b, some before => if noneTakes rev before b then some (b, before) else none
  | _, _ => none

/-- Claim R4 over a program, from the decided rule: where `apartOn` holds for a literal,
`Searcher.find_by_suffix` over the model's scans gives the matcher's answer from `low`, for a
text that has the builder's hypotheses. -/
theorem apart_program {prog rev : Array Inst} {entry reventry b before : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts)
    (hrule : apartOn rev reventry walked = some (b, before)) (hlit : 0 < walked.reverse.length)
    {low : Nat} (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (bySuffix (scansOf hexact hrevexact hrev hclean walked.reverse hlit) low
        (text.length - low + 1) low) := by
  unfold apartOn at hrule
  cases hfirst : walked.reverse[0]? with
  | none => simp [hfirst] at hrule
  | some b' =>
    cases hstop : chainStop rev (chainFuel rev walked) reventry walked with
    | none => simp [hfirst, hstop] at hrule
    | some before' =>
      simp only [hfirst, hstop] at hrule
      by_cases hnone : noneTakes rev before' b' = true
      · rw [ite_eq_left hnone] at hrule
        exact bySuffix_program hexact hrevexact hrev hclean
          (chain_of_chainStop _ _ _ _ hstop) (noneTakes_sound hnone) hlit hfirst hlow
      · rw [ite_eq_right hnone] at hrule
        cases hrule

/-! ## The rule on small programs -/

/-- `[0-9]+ab` has the reverse program `ba[0-9]+`: from 0 it takes `b`, then `a`, and from 2 a
digit or more. The walk of `b`, `a` stops at 2, and no instruction from there takes `a`, so the
rule holds for the literal `ab`. `[a-c]+ab` has `ba[a-c]+`, whose part from 2 takes `a`: the
rule fails. A walk of other bytes follows no chain. -/
example :
    apartOn #[.range 98 98 1, .range 97 97 2, .range 48 57 3, .split 2 4, .done] 0 [98, 97]
        = some (97, 2) ∧
      apartOn #[.range 98 98 1, .range 97 97 2, .range 97 99 3, .split 2 4, .done] 0 [98, 97]
        = none ∧
      apartOn #[.range 98 98 1, .range 97 97 2, .range 48 57 3, .split 2 4, .done] 0 [98, 98]
        = none ∧
      reachOf #[.range 98 98 1, .range 97 97 2, .range 48 57 3, .split 2 4, .done] 2
        = [2, 3, 4] := by decide

end Stdx.Regex.Matcher
