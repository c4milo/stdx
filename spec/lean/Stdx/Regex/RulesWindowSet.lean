import Stdx.Regex.RulesWindow

/-!
# The window over a set of literals, decided from a program

`([A-Za-z]awyer|[A-Za-z]inn)\s` holds no one literal in every match: each match holds `awyer` or
`inn`, one byte after its start. `RulesWindow.lean` decides the window for one literal. This file
decides it for a set (decision 86, the window, `dfa_window.zig`).

- `passesAnyOn` decides that every path of the reverse program from its entry to `match` passes
  one of several instructions, the cuts. `passesAny_split` proves it.
- Each way names a cut, the literal that the reverse program takes from it, and the instruction
  `before` where the literal ends. Its literal is cut to the set's `width`, as `LiteralSet` keeps
  each literal's first `len` bytes.
- `windowSetOn` is the rule, and `windowSet_program` gives the search's answer from it: from
  `lead` bytes before the first place of any literal of the set.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## A match passes one of several instructions -/

/-- The moves of an instruction in a walk that stops at each cut. -/
def successorsButAny (prog : Array Inst) (cuts : List Nat) (pc : Nat) : List Nat :=
  if cuts.contains pc then [] else successors prog pc

/-- The set shows that every path from `entry` to `match` passes a cut: it holds `entry`, and
each member that is no cut is no `match` and leads to members alone. -/
def passesAnyOk (prog : Array Inst) (entry : Nat) (cuts set : List Nat) : Bool :=
  set.contains entry &&
    set.all fun x => cuts.contains x || (!isDone prog x && (successors prog x).all (set.contains ·))

/-- Where the set is right, a path from a member to `match` has a first part that ends at a
cut. -/
theorem passesAny_split {prog : Array Inst} {text : List Nat} {entry : Nat} {cuts set : List Nat}
    (h : passesAnyOk prog entry cuts set = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done → pc ∈ set →
      ∃ cut k, cut ∈ cuts ∧ Path prog text pc i cut k ∧ Path prog text cut k pc' j := by
  simp only [passesAnyOk, Bool.and_eq_true] at h
  obtain ⟨_, hall⟩ := h
  have hstep : ∀ x, x ∈ set → x ∉ cuts →
      isDone prog x = false ∧ ∀ y, y ∈ successors prog x → y ∈ set := by
    intro x hx hne
    have hx' := List.all_eq_true.mp hall x hx
    simp only [Bool.or_eq_true, List.contains_iff_mem, Bool.and_eq_true,
      Bool.not_eq_true'] at hx'
    cases hx' with
    | inl hin => exact absurd hin hne
    | inr hr =>
      exact ⟨hr.1, fun y hy => List.contains_iff_mem.mp (List.all_eq_true.mp hr.2 y hy)⟩
  intro pc i pc' j hpath
  induction hpath with
  | @here pc i =>
    intro hdone hmem
    by_cases hc : pc ∈ cuts
    · exact ⟨pc, i, hc, .here, .here⟩
    · have hnot := (hstep pc hmem hc).1
      rw [isDone_iff.mpr hdone] at hnot
      cases hnot
  | @free pc i mid pc' j hfree hrest ih =>
    intro hdone hmem
    by_cases hc : pc ∈ cuts
    · exact ⟨pc, i, hc, .here, .free hfree hrest⟩
    · obtain ⟨c, k, hcut, h1, h2⟩ :=
        ih hdone ((hstep pc hmem hc).2 mid (edge_successor hfree.edge))
      exact ⟨c, k, hcut, .free hfree h1, h2⟩
  | @take pc i b mid pc' j hbyte htakes hrest ih =>
    intro hdone hmem
    by_cases hc : pc ∈ cuts
    · exact ⟨pc, i, hc, .here, .take hbyte htakes hrest⟩
    · obtain ⟨c, k, hcut, h1, h2⟩ :=
        ih hdone ((hstep pc hmem hc).2 mid (edge_successor (.takes htakes)))
      exact ⟨c, k, hcut, .take hbyte htakes h1, h2⟩

/-- `dfa_inner.window_set_of`'s check that every match passes a cut, decided: the set that a walk
from `entry` gives, where it stops at each cut. -/
def passesAnyOn (prog : Array Inst) (entry : Nat) (cuts : List Nat) : Bool :=
  passesAnyOk prog entry cuts (growBy (successorsButAny prog cuts) (prog.size + 1) [entry])

/-- Where `passesAnyOn` holds, a path from `entry` to `match` has a first part that ends at a
cut. -/
theorem passesAnyOn_split {prog : Array Inst} {text : List Nat} {entry : Nat} {cuts : List Nat}
    (h : passesAnyOn prog entry cuts = true) {i pc' j : Nat}
    (hpath : Path prog text entry i pc' j) (hdone : prog[pc']? = some .done) :
    ∃ cut k, cut ∈ cuts ∧ Path prog text entry i cut k ∧ Path prog text cut k pc' j := by
  have hentry : entry ∈ growBy (successorsButAny prog cuts) (prog.size + 1) [entry] := by
    simp only [passesAnyOn, passesAnyOk, Bool.and_eq_true] at h
    exact List.contains_iff_mem.mp h.1
  exact passesAny_split h hpath hdone hentry

/-! ## The places of a set of literals -/

/-- The first offset from `i` that `stands` holds, among `turns` offsets. -/
def findBy (stands : Nat → Bool) : Nat → Nat → Option Nat
  | 0, _ => none
  | turns + 1, i => if stands i then some i else findBy stands turns (i + 1)

theorem findBy_some {stands : Nat → Bool} :
    ∀ turns i p, findBy stands turns i = some p →
      i ≤ p ∧ stands p = true ∧ ∀ q, i ≤ q → q < p → stands q = false := by
  intro turns
  induction turns with
  | zero => intro i p h; simp [findBy] at h
  | succ turns ih =>
    intro i p h
    simp only [findBy] at h
    cases hat : stands i with
    | true =>
      simp only [hat, ite_true, Option.some.injEq] at h
      subst h
      exact ⟨Nat.le_refl i, hat, fun q h1 h2 => by omega⟩
    | false =>
      simp only [hat, Bool.false_eq_true, ite_false] at h
      obtain ⟨h1, h2, h3⟩ := ih (i + 1) p h
      refine ⟨by omega, h2, ?_⟩
      intro q hq1 hq2
      cases Nat.lt_or_ge i q with
      | inl hlt => exact h3 q hlt hq2
      | inr hge =>
        have : q = i := by omega
        exact this ▸ hat

theorem findBy_none {stands : Nat → Bool} :
    ∀ turns i, findBy stands turns i = none →
      ∀ q, i ≤ q → q < i + turns → stands q = false := by
  intro turns
  induction turns with
  | zero => intro i _ q h1 h2; omega
  | succ turns ih =>
    intro i h q hq1 hq2
    simp only [findBy] at h
    cases hat : stands i with
    | true => simp [hat] at h
    | false =>
      simp only [hat, Bool.false_eq_true, ite_false] at h
      cases Nat.lt_or_ge i q with
      | inl hlt => exact ih (i + 1) h q hlt (by omega)
      | inr hge =>
        have : q = i := by omega
        exact this ▸ hat

/-- A literal of the set stands at the offset, and the set's `width` bytes from it lie in the
text. -/
def standsAny (text : List Nat) (lits : List (List (Nat × Nat))) (width p : Nat) : Bool :=
  decide (p + width ≤ text.length) && lits.any fun lit => standsAt text lit p

/-- `LiteralSet.find`: the first place of a literal of the set at or after `i`. -/
def findAny (text : List Nat) (lits : List (List (Nat × Nat))) (width i : Nat) : Option Nat :=
  findBy (standsAny text lits width) (text.length + 1 - i) i

/-- The scans of the searches from a set of literals: those of `scansOf`, with the places of the
set in the place of one literal's. -/
def scansOfSet {prog rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text) (hclean : StartsClean prog entry text starts)
    (lits : List (List (Nat × Nat))) (width : Nat) (hwidth : 0 < width) :
    Scans (textOf prog entry text starts hexact) :=
  { scansOf hexact hrevexact hrev hclean [(0, 0)] (by decide) with
    width := width
    Stands := fun p => standsAny text lits width p = true
    place := findAny text lits width
    width_pos := hwidth
    stands_inside := by
      intro p h
      simp only [standsAny, Bool.and_eq_true, decide_eq_true_eq] at h
      exact h.1
    place_some := by
      intro i p h
      obtain ⟨h1, h2, _⟩ := findBy_some _ i p h
      exact ⟨h1, h2⟩
    place_first := by
      intro i p q h hq1 hq2 hstands
      obtain ⟨_, _, h3⟩ := findBy_some _ i p h
      have := h3 q hq1 hq2
      rw [hstands] at this
      cases this
    place_none := by
      intro i q h hq hstands
      have hlen : q + width ≤ text.length := by
        simp only [standsAny, Bool.and_eq_true, decide_eq_true_eq] at hstands
        exact hstands.1
      have := findBy_none _ i h q hq (by show q < i + (text.length + 1 - i); omega)
      rw [hstands] at this
      cases this }

/-- A literal that a text reads at an offset is read there in its first bytes too. -/
theorem reads_take {text : List Nat} {lit : List (Nat × Nat)} {p n : Nat}
    (h : Reads text lit p) : Reads text (lit.take n) p := by
  intro m place hm
  rw [List.getElem?_take] at hm
  split at hm
  · exact h m place hm
  · cases hm

/-! ## The rule -/

/-- A way of the set: the cut, the literal's places from its last to its first, as the reverse
program reads them from the cut, and the instruction where they end. -/
abbrev Way := Nat × List (Nat × Nat) × Nat

/-- The set's literals: each way's literal in the order of the text, cut to `width` bytes. -/
def setLiterals (ways : List Way) (width : Nat) : List (List (Nat × Nat)) :=
  ways.map fun way => way.2.1.reverse.take width

/-- One way is right: the reverse program takes its literal from its cut and stands at its
`before`, the literal holds `width` bytes or more, and every path from `before` takes at most
`lead` bytes. -/
def wayOk (rev : Array Inst) (width lead : Nat) (way : Way) : Bool :=
  chainTo rev way.2.2 (chainFuel rev way.2.1) way.1 way.2.1 && decide (width ≤ way.2.1.length) &&
    (boundedLength rev way.2.2 lead).isSome

/-- The rule of the window over a set: every match passes a cut of the ways, and each way is
right. -/
def windowSetOn (rev : Array Inst) (reventry : Nat) (ways : List Way) (width lead : Nat) :
    Bool :=
  decide (0 < width) && passesAnyOn rev reventry (ways.map (·.1)) && ways.all (wayOk rev width lead)

/-- Every match holds a literal of the set at most `lead` bytes after its start, where the rule
holds. -/
theorem windowSet_within {prog rev : Array Inst} {entry reventry width lead : Nat}
    {text : List Nat} {ways : List Way} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hwidth : 0 < width)
    (hpasses : passesAnyOn rev reventry (ways.map (·.1)) = true)
    (hways : ways.all (wayOk rev width lead) = true) :
    Within (textOf prog entry text starts hexact)
      (scansOfSet hexact hrevexact hrev hclean (setLiterals ways width) width hwidth) lead := by
  intro s e hm
  have hin := matches_inside hm.1 hm.2.2
  obtain ⟨pc, hpath, hdone⟩ := reversed_match hexact hrev hm
  obtain ⟨c, k, hcut, _, hfrom⟩ := passesAnyOn_split hpasses hpath hdone
  obtain ⟨way, hway, hc⟩ := List.mem_map.mp hcut
  have hok := List.all_eq_true.mp hways way hway
  simp only [wayOk, Bool.and_eq_true, decide_eq_true_eq] at hok
  obtain ⟨⟨hto, hwide⟩, hsome⟩ := hok
  have hchain := chain_of_chainTo _ _ _ hto
  rw [hc] at hchain
  have ⟨hbytes, hrest⟩ := chain_path hchain hfrom hdone
  obtain ⟨n, hn⟩ := Option.isSome_iff_exists.mp hsome
  have hle : n ≤ lead := by
    have hmem := List.mem_of_find?_eq_some hn
    exact Nat.le_of_lt_succ (List.mem_range.mp hmem)
  have hbound := boundedLength_sound hn hrest
  have h2 := hrest.le
  have hlen : way.2.1.reverse.length = way.2.1.length := List.length_reverse
  have hread : Reads text way.2.1.reverse (text.length - k - way.2.1.length) := by
    have hr : Reads text.reverse way.2.1 (text.length - (text.length - k)) := by
      have hback : text.length - (text.length - k) = k := by omega
      rw [hback]
      exact hbytes
    exact reads_reversed (e := text.length - k) (by omega) (by omega) hr
  refine ⟨text.length - k - way.2.1.length, by omega, by omega, ?_⟩
  show standsAny text (setLiterals ways width) width (text.length - k - way.2.1.length) = true
  simp only [standsAny, Bool.and_eq_true, decide_eq_true_eq, List.any_eq_true]
  refine ⟨by omega, way.2.1.reverse.take width, List.mem_map.mpr ⟨way, hway, rfl⟩, ?_⟩
  refine standsAt_iff.mpr ⟨?_, reads_take hread⟩
  have : (way.2.1.reverse.take width).length ≤ width := List.length_take_le _ _
  omega

/-- `dfa_window.zig`'s search for a set: from `lead` bytes before the first place of a literal of
the set at or after `low`, and never before `low`, the two scans of `byDfa`. -/
def byWindowSet (prog : Array Inst) (entry : Nat) (rev : Array Inst) (reventry : Nat)
    (text : List Nat) (mayByte : Nat → Bool) (lits : List (List (Nat × Nat))) (width lead low : Nat) :
    Option (Nat × Nat) :=
  match findAny text lits width low with
  | none => none
  | some p => byDfa prog entry rev reventry text mayByte (max low (p - lead))

/-- The window over a set, over a program. Where `windowSetOn` holds, the search from `lead` bytes
before the first place of a literal of the set gives the matcher's answer from `low`. -/
theorem windowSet_program {prog rev : Array Inst} {entry reventry width lead : Nat}
    {text : List Nat} {ways : List Way} {mayByte : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text (Dfa.startsOf text mayByte))
    (hrule : windowSetOn rev reventry ways width lead = true) (low : Nat) :
    IsAnswer (textOf prog entry text (Dfa.startsOf text mayByte) hexact) low
      (byWindowSet prog entry rev reventry text mayByte (setLiterals ways width) width lead low) := by
  simp only [windowSetOn, Bool.and_eq_true, decide_eq_true_eq] at hrule
  obtain ⟨⟨hwidth, hpasses⟩, hways⟩ := hrule
  have hwithin := windowSet_within hexact hrevexact hrev hclean hwidth hpasses hways
  unfold byWindowSet
  cases hplace : findAny text (setLiterals ways width) width low with
  | none =>
    exact window_none (c := scansOfSet hexact hrevexact hrev hclean (setLiterals ways width)
      width hwidth) hwithin hplace
  | some p =>
    have hp := (scansOfSet hexact hrevexact hrev hclean (setLiterals ways width) width
      hwidth).place_some hplace
    have hst : p + width ≤ text.length := (scansOfSet hexact hrevexact hrev hclean
      (setLiterals ways width) width hwidth).stands_inside hp.2
    have hlen : max low (p - lead) ≤ text.length := by
      have := hp.1
      omega
    exact answer_from_window (c := scansOfSet hexact hrevexact hrev hclean _ width hwidth)
      hwithin hplace
      (byDfa_answer hexact hrevexact hrev (emptyElsewhere_of_startsClean hclean) hlen)

/-! ## The rule on small programs -/

/-- `[a-c](?:xy|zw)` read backward: from 0 a split to the two ways, `yx` from 2 and `wz` from 4,
each to the letter at 6, then `match`. Every path passes 2 or 4, each way stands at 6, and every
path from 6 takes one byte. The window of 1 holds over both ways; a window of 0 fails, and so
does a cut that one way misses. -/
example :
    windowSetOn #[.split 2 4, .done, .range 121 121 3, .range 120 120 6, .range 119 119 5,
        .range 122 122 6, .range 97 99 7, .done] 0 [(2, [(121, 121), (120, 120)], 6),
        (4, [(119, 119), (122, 122)], 6)] 2 1 = true ∧
      windowSetOn #[.split 2 4, .done, .range 121 121 3, .range 120 120 6, .range 119 119 5,
        .range 122 122 6, .range 97 99 7, .done] 0 [(2, [(121, 121), (120, 120)], 6),
        (4, [(119, 119), (122, 122)], 6)] 2 0 = false ∧
      windowSetOn #[.split 2 4, .done, .range 121 121 3, .range 120 120 6, .range 119 119 5,
        .range 122 122 6, .range 97 99 7, .done] 0 [(2, [(121, 121), (120, 120)], 6)] 2 1 =
        false := by
  decide

end Stdx.Regex.Matcher
