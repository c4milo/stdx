import Stdx.Regex.Reverse

/-!
# Checks of the two hypotheses that the program's theorems take

The theorems of `MatcherPaths.lean`, `MatcherAnswer.lean` and `Reverse.lean` take two hypotheses
that the builder must give, and that no proof here holds the builder to (decision 86):

- `Exact`: the ranges of one node stand apart, so `step` gives the one instruction a byte goes to.
- `Reverses`: the reverse program takes each match of the forward program read backward, and
  nothing else, on one text.

This file holds a function that decides each one, and the proof that the function is right:

- `isExact` reads each pair of ranges of each node, and `exact_of_isExact` gives `Exact`.
- `ends` gives every offset where a path from a seed reaches `match`, and `mem_endsFrom` says
  so. It is the matcher with no cut and no best end.
- `reversesOn` compares the two programs' ends for each start and each end of one text, and
  `reverses_of_reversesOn` gives `Reverses` for that text.

`spec/lean/Vectors.lean` runs both on each program and each text of a dump that `compile` wrote.
So the two hypotheses hold for each such program and text by a proved check, and for no other.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Closure

/-! ## `Exact` -/

/-- Two instructions take no byte in common, or go to one instruction. Only two ranges can
fail. -/
def standApart : Inst → Inst → Bool
  | .range lo hi out, .range lo' hi' out' => hi < lo' || hi' < lo || out == out'
  | _, _ => true

/-- Each pair of the `count` instructions from `index` stands apart. -/
def rangesApart (prog : Array Inst) (index count : Nat) : Bool :=
  (List.range count).all fun j => (List.range count).all fun k =>
    match prog[index + j]?, prog[index + k]? with
    | some a, some b => standApart a b
    | _, _ => true

/-- The ranges of the node at `pc` stand apart, where the instruction is a node. -/
def exactAt (prog : Array Inst) (pc : Nat) : Bool :=
  match prog[pc]? with
  | some (.ranges count) => rangesApart prog (pc + 1) count
  | _ => true

/-- The ranges of each node of the program stand apart. -/
def isExact (prog : Array Inst) : Bool :=
  (List.range prog.size).all (exactAt prog)

/-- Where one of the `count` ranges from `index` takes the byte, `stepRanges` gives an
instruction. -/
theorem stepRanges_isSome {prog : Array Inst} {b : Nat} :
    ∀ count index j lo hi out, j < count → prog[index + j]? = some (.range lo hi out) → lo ≤ b →
      b ≤ hi → (stepRanges prog index count b).isSome := by
  intro count
  induction count with
  | zero => intro index j lo hi out hj; omega
  | succ count ih =>
    intro index j lo hi out hj hr hlo hhi
    cases j with
    | zero =>
      have hr' : prog[index]? = some (.range lo hi out) := by simpa using hr
      simp [stepRanges, hr', hlo, hhi]
    | succ j =>
      have hnext : (stepRanges prog (index + 1) count b).isSome :=
        ih (index + 1) j lo hi out (by omega) (by rw [← hr]; congr 1; omega) hlo hhi
      unfold stepRanges
      split
      · split
        · rfl
        · exact hnext
      · exact hnext

/-- An index with an instruction lies in the program. -/
theorem lt_size_of_getElem? {prog : Array Inst} {pc : Nat} {inst : Inst}
    (h : prog[pc]? = some inst) : pc < prog.size := by
  apply Nat.lt_of_not_le
  intro hle
  rw [Array.getElem?_eq_none hle] at h
  cases h

/-- A program whose nodes pass `isExact` is `Exact`. -/
theorem exact_of_isExact {prog : Array Inst} (h : isExact prog = true) : Exact prog := by
  intro pc b out htakes
  cases htakes with
  | range hp hlo hhi => simp [step, hp, hlo, hhi]
  | @member count j lo hi hp hj hr hlo hhi =>
    have hnode : exactAt prog pc = true :=
      List.all_eq_true.mp h pc (List.mem_range.mpr (lt_size_of_getElem? hp))
    simp only [exactAt, hp] at hnode
    have hsome := stepRanges_isSome count (pc + 1) j lo hi out hj hr hlo hhi
    cases hst : stepRanges prog (pc + 1) count b with
    | none => rw [hst] at hsome; cases hsome
    | some out' =>
      obtain ⟨k, lo', hi', hk, hr', hlo', hhi'⟩ := stepRanges_takes count (pc + 1) hst
      have hpair := List.all_eq_true.mp
        (List.all_eq_true.mp hnode j (List.mem_range.mpr hj)) k (List.mem_range.mpr hk)
      simp only [hr, hr', standApart, Bool.or_eq_true, decide_eq_true_eq, beq_iff_eq] at hpair
      have hout : out = out' := by
        rcases hpair with (h1 | h2) | h3
        · omega
        · omega
        · exact h3
      simp [step, hp, hst, hout]

/-! ## Every end of a match from a start -/

/-- Every offset where a thread is `match`, from offset `i` with `seeds`, for at most `turns`
positions: the matcher with no cut at a `match` and no best end. -/
def ends (prog : Array Inst) (text : List Nat) : Nat → Nat → List Nat → List Nat
  | 0, _, _ => []
  | turns + 1, i, seeds =>
    (if (threads prog text i seeds).any (isDone prog) then [i] else []) ++
      match text[i]? with
      | none => []
      | some b =>
        ends prog text turns (i + 1) ((threads prog text i seeds).filterMap (step prog · b))

/-- An offset among the ends is one that a path from a seed reaches `match` at. -/
theorem ends_sound (prog : Array Inst) (text : List Nat) :
    ∀ turns i seeds e, e ∈ ends prog text turns i seeds →
      ∃ s, s ∈ seeds ∧ Accepts prog text s i e := by
  intro turns
  induction turns with
  | zero => intro i seeds e h; simp [ends] at h
  | succ turns ih =>
    intro i seeds e h
    simp only [ends, List.mem_append] at h
    cases h with
    | inl hhere =>
      by_cases hc : (threads prog text i seeds).any (isDone prog) = true
      · simp only [hc, ite_true, List.mem_singleton] at hhere
        subst hhere
        exact done_here hc
      · simp [hc] at hhere
    | inr hrest =>
      cases hb : text[i]? with
      | none => simp [hb] at hrest
      | some b =>
        simp only [hb] at hrest
        obtain ⟨o, ho, pc', hpath, hdone⟩ := ih (i + 1) _ e hrest
        obtain ⟨x, hx, hstep⟩ := List.mem_filterMap.mp ho
        obtain ⟨s, hs, hfree⟩ := threads_sound hx
        exact ⟨s, hs, pc', hfree.trans (.take hb (step_takes hstep) hpath), hdone⟩

/-- An offset that a path from a seed reaches `match` at, among the positions the scan may
read, is among the ends. -/
theorem ends_complete (prog : Array Inst) (text : List Nat) (hexact : Exact prog) :
    ∀ turns i seeds e, (∃ s, s ∈ seeds ∧ Accepts prog text s i e) → e - i < turns →
      e ∈ ends prog text turns i seeds := by
  intro turns
  induction turns with
  | zero => intro i seeds e _ h; omega
  | succ turns ih =>
    intro i seeds e hacc hturns
    obtain ⟨s, hs, pc', hpath, hdone⟩ := hacc
    obtain ⟨x, hsteps, hcase⟩ := path_split hpath hdone
    simp only [ends, List.mem_append]
    cases hcase with
    | inl h =>
      obtain ⟨hd, he⟩ := h
      subst he
      have hx := threads_complete hs hsteps (by simp [kindAt, isDone_iff.mp hd])
      have hc : (threads prog text e seeds).any (isDone prog) = true :=
        List.any_eq_true.mpr ⟨x, hx, hd⟩
      exact Or.inl (by simp [hc])
    | inr h =>
      obtain ⟨b, out, hb, htakes, hrest⟩ := h
      have hx := threads_complete hs hsteps (takes_emit htakes).1
      have hout : out ∈ (threads prog text i seeds).filterMap (step prog · b) :=
        List.mem_filterMap.mpr ⟨x, hx, hexact x b out htakes⟩
      have hle := hrest.le
      refine Or.inr ?_
      simp only [hb]
      exact ih (i + 1) _ e ⟨out, hout, pc', hrest, hdone⟩ (by omega)

/-- Every end of a match that starts at `s`, read from `entry`. -/
def endsFrom (prog : Array Inst) (entry : Nat) (text : List Nat) (s : Nat) : List Nat :=
  ends prog text (text.length - s + 1) s [entry]

/-- `endsFrom` holds an offset exactly where a path from the entry at `s` reaches `match` at
it. -/
theorem mem_endsFrom {prog : Array Inst} (hexact : Exact prog) (entry : Nat) (text : List Nat)
    {s e : Nat} (he : e ≤ text.length) :
    e ∈ endsFrom prog entry text s ↔ Accepts prog text entry s e := by
  constructor
  · intro h
    obtain ⟨s', hs', hacc⟩ := ends_sound prog text _ _ _ e h
    have hentry : s' = entry := by simpa using hs'
    exact hentry ▸ hacc
  · intro hacc
    exact ends_complete prog text hexact _ _ _ e ⟨entry, by simp, hacc⟩ (by omega)

/-! ## `Reverses` -/

/-- For each start and each end of the text, the forward program matches from the start up to
the end exactly where the reverse program takes the same bytes read backward. -/
def reversesOn (fwd : Array Inst) (entry : Nat) (rev : Array Inst) (reventry : Nat)
    (text : List Nat) : Bool :=
  (List.range (text.length + 1)).all fun e =>
    (List.range (e + 1)).all fun s =>
      (endsFrom fwd entry text s).contains e ==
        (endsFrom rev reventry text.reverse (text.length - e)).contains (text.length - s)

/-- Two programs that are `Exact` and pass `reversesOn` for a text have `Reverses` for it. -/
theorem reverses_of_reversesOn {fwd rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    (hfwd : Exact fwd) (hrev : Exact rev) (h : reversesOn fwd entry rev reventry text = true) :
    Reverses fwd entry rev reventry text := by
  intro s e hse he
  have hpair := List.all_eq_true.mp
    (List.all_eq_true.mp h e (List.mem_range.mpr (by omega))) s (List.mem_range.mpr (by omega))
  have hsame : e ∈ endsFrom fwd entry text s ↔
      (text.length - s) ∈ endsFrom rev reventry text.reverse (text.length - e) := by
    have := beq_iff_eq.mp hpair
    constructor
    · intro hm
      have hc : (endsFrom fwd entry text s).contains e = true := List.contains_iff_mem.mpr hm
      rw [this] at hc
      exact List.contains_iff_mem.mp hc
    · intro hm
      have hc : (endsFrom rev reventry text.reverse (text.length - e)).contains
          (text.length - s) = true := List.contains_iff_mem.mpr hm
      rw [← this] at hc
      exact List.contains_iff_mem.mp hc
  have hlen : text.length - s ≤ text.reverse.length := by simp
  exact (mem_endsFrom hfwd entry text he).symm.trans
    (hsame.trans (mem_endsFrom hrev reventry text.reverse hlen))

/-! ## The checks on a small program -/

/-- `ab|a` and its reverse program `ba|a` in one array: the forward program from 0, the reverse
program from 4. Each node is one range, so the program is exact, and the two halves are each
other's reverse on `xab`. -/
example :
    isExact #[.split 1 3, .range 97 97 2, .range 98 98 7, .range 97 97 7,
        .split 5 6, .range 98 98 6, .range 97 97 7, .done] = true ∧
      reversesOn
        #[.split 1 3, .range 97 97 2, .range 98 98 7, .range 97 97 7,
          .split 5 6, .range 98 98 6, .range 97 97 7, .done] 0
        #[.split 1 3, .range 97 97 2, .range 98 98 7, .range 97 97 7,
          .split 5 6, .range 98 98 6, .range 97 97 7, .done] 4 [120, 97, 98] = true := by
  decide

/-- A node whose two ranges both take `a` and go to two instructions is not exact. A reverse
program that takes `b` alone is not the reverse of `ab|a`. -/
example :
    isExact #[.ranges 2, .range 97 98 3, .range 97 97 4, .done, .fail] = false ∧
      reversesOn
        #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 5, .range 98 98 5, .done] 0
        #[.split 1 3, .range 97 97 2, .range 98 98 5, .range 97 97 5, .range 98 98 5, .done] 4
        [120, 97, 98] = false := by
  decide

end Stdx.Regex.Matcher
