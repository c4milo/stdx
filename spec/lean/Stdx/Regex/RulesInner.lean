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

- `inner_apart`: no instruction from `before` takes a byte of the literal's first place.
- `inner_fixed`: every path from `before` to `match` takes one count of bytes.
- `inner_separated`: the part ends with separators, and holds none before them. The rule may
  hold for the literal past some of its first places, as the Zig rule tries the literal past
  its first run. The search still goes to the places of the whole literal. So the proof reads
  the places passed too: `chain_seps` follows them through the rule's sets, and gives that the
  separators stand last in the part before the literal and the places passed, read as one.

`beforeOn` is the three rules, `innerOn` is the whole rule, and `inner_program` proves that the
search from the literal's places gives the matcher's answer.

The Zig rule has two more tests, which leave a literal that starts or ends every match to
claim R2 or claim R4. They choose a search, and change no answer, so this file has neither.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## The first rule and the second -/

/-- The first rule gives `BeforeRising`: no instruction that the reverse program reaches from
`before` takes a byte of the literal's first place. -/
theorem inner_apart {prog rev : Array Inst} {entry reventry cut before b b' : Nat}
    {text : List Nat} {walked : List (Nat × Nat)} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hnone : noneTakes rev before b = true) (hnone' : noneTakes rev before b' = true)
    (hfirst : walked.reverse[0]? = some (b, b')) :
    BeforeRising (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) := by
  apply beforeRising_of_clean (Mark := fun q => text[q]? = some b ∨ text[q]? = some b')
  · intro s p hb q hq1 hq2 hmark
    obtain ⟨hsp, hp, pc, hpath, _⟩ := hb
    cases hmark with
    | inl h =>
      have hc := path_clean hpath (noneTakes_sound hnone) (text.length - 1 - q) (by omega)
        (by omega)
      rw [mirrored_byte (by omega)] at hc
      exact hc h
    | inr h =>
      have hc := path_clean hpath (noneTakes_sound hnone') (text.length - 1 - q) (by omega)
        (by omega)
      rw [mirrored_byte (by omega)] at hc
      exact hc h
  · apply first_gap
    intro p hp
    have ⟨c, hc, hfits⟩ := hp.2 0 (b, b') hfirst
    rw [Nat.add_zero] at hc
    cases hfits with
    | inl h =>
      have h' : c = b := h
      exact Or.inl (h' ▸ hc)
    | inr h =>
      have h' : c = b' := h
      exact Or.inr (h' ▸ hc)

/-- The second rule gives `BeforeRising`: every path of the reverse program from `before` to
`match` takes one count of bytes. -/
theorem inner_fixed {prog rev : Array Inst} {entry reventry cut before most n : Nat}
    {text : List Nat} {walked : List (Nat × Nat)} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hfixed : fixedLength rev before most = some n) :
    BeforeRising (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) := by
  apply beforeRising_of_one_count (count := n)
  intro s p hb
  obtain ⟨hsp, hp, pc, hpath, hdone⟩ := hb
  have := fixedLength_sound hfixed hpath hdone
  omega

/-! ## The three sets of the third rule, read for one member -/

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

/-- What `firstOk` holds for one member. -/
theorem first_step {prog : Array Inst} {first : List Nat} (h : firstOk prog first = true)
    {x : Nat} (hx : x ∈ first) : ∀ y, y ∈ freeSuccessors prog x → y ∈ first := by
  unfold firstOk at h
  have hx' := List.all_eq_true.mp h x hx
  simp only [Bool.and_eq_true] at hx'
  exact fun y hy => List.contains_iff_mem.mp (List.all_eq_true.mp hx'.1 y hy)

/-- What `insideOk` holds for one member. -/
theorem inside_step {prog : Array Inst} {first inside past : List Nat}
    (h : insideOk prog first inside past = true) {x : Nat} (hx : x ∈ inside) :
    (∀ y, y ∈ freeSuccessors prog x → y ∈ inside) ∧
      ∀ r, r ∈ rangesOf prog x →
        (rangeAll (separator prog first) r.1 r.2.1 = true ∧ r.2.2 ∈ inside) ∨
          (rangeAll (fun b => !separator prog first b) r.1 r.2.1 = true ∧ r.2.2 ∈ past) := by
  unfold insideOk at h
  have hx' := List.all_eq_true.mp h x hx
  simp only [Bool.and_eq_true] at hx'
  refine ⟨fun y hy => List.contains_iff_mem.mp (List.all_eq_true.mp hx'.1 y hy), ?_⟩
  intro r hr
  have hr' := List.all_eq_true.mp hx'.2 r hr
  simp only [Bool.or_eq_true, Bool.and_eq_true] at hr'
  cases hr' with
  | inl h1 => exact Or.inl ⟨h1.1, List.contains_iff_mem.mp h1.2⟩
  | inr h1 => exact Or.inr ⟨h1.1, List.contains_iff_mem.mp h1.2⟩

/-- What `pastOk` holds for one member. -/
theorem past_step {prog : Array Inst} {first past : List Nat} (h : pastOk prog first past = true)
    {x : Nat} (hx : x ∈ past) :
    (∀ y, y ∈ freeSuccessors prog x → y ∈ past) ∧
      ∀ r, r ∈ rangesOf prog x →
        rangeAll (fun b => !separator prog first b) r.1 r.2.1 = true ∧ r.2.2 ∈ past := by
  unfold pastOk at h
  have hx' := List.all_eq_true.mp h x hx
  simp only [Bool.and_eq_true] at hx'
  refine ⟨fun y hy => List.contains_iff_mem.mp (List.all_eq_true.mp hx'.1 y hy), ?_⟩
  intro r hr
  have hr' := List.all_eq_true.mp hx'.2 r hr
  simp only [Bool.and_eq_true] at hr'
  exact ⟨hr'.1, List.contains_iff_mem.mp hr'.2⟩

/-- A byte of the text is a separator where the text holds it. -/
theorem sepAt_iff_byte {prog : Array Inst} {first text : List Nat} {i b : Nat}
    (hbyte : text[i]? = some b) : SepAt prog first text i ↔ separator prog first b = true := by
  constructor
  · intro ⟨b', hb', hs⟩
    rw [hbyte] at hb'
    exact (Option.some.inj hb') ▸ hs
  · intro hs
    exact ⟨b, hbyte, hs⟩

/-! ## A walk of places through the three sets -/

/-- In a span of a text, the separators stand first: an offset before a separator's holds a
separator. -/
def SepsFirst (prog : Array Inst) (first text : List Nat) (lo hi : Nat) : Prop :=
  ∀ q r, lo ≤ q → q ≤ r → r < hi → SepAt prog first text r → SepAt prog first text q

/-- What a walk from `pc` to `stop` over the bytes of a span gives. From an instruction of
`inside`, the span holds separators alone and `stop` is in `inside`, or its separators stand
first and `stop` is in `past`. From an instruction of `past`, the span holds no separator and
`stop` is in `past`. -/
def SepWalk (prog : Array Inst) (first inside past text : List Nat) (pc stop lo hi : Nat) :
    Prop :=
  (pc ∈ inside →
    (stop ∈ inside ∧ ∀ q, lo ≤ q → q < hi → SepAt prog first text q) ∨
      (stop ∈ past ∧ SepsFirst prog first text lo hi)) ∧
    (pc ∈ past → stop ∈ past ∧ ∀ q, lo ≤ q → q < hi → ¬ SepAt prog first text q)

/-- A move with no byte keeps what the walk gives. -/
theorem sepWalk_free {prog : Array Inst} {first inside past text : List Nat}
    {pc out stop lo hi : Nat} (hin : pc ∈ inside → out ∈ inside) (hpa : pc ∈ past → out ∈ past)
    (h : SepWalk prog first inside past text out stop lo hi) :
    SepWalk prog first inside past text pc stop lo hi :=
  ⟨fun hm => h.1 (hin hm), fun hm => h.2 (hpa hm)⟩

/-- A range of one byte, which the text holds at the span's first offset, goes before the
walk of the rest of the span. -/
theorem sepWalk_byte {prog : Array Inst} {first inside past text : List Nat}
    (hinside : insideOk prog first inside past = true) (hpast : pastOk prog first past = true)
    {pc b out stop i hi : Nat} (hinst : prog[pc]? = some (.range b b out))
    (hbyte : text[i]? = some b)
    (h : SepWalk prog first inside past text out stop (i + 1) hi) :
    SepWalk prog first inside past text pc stop i hi := by
  have hrange : (b, b, out) ∈ rangesOf prog pc := by simp [rangesOf, hinst]
  constructor
  · intro hm
    cases (inside_step hinside hm).2 _ hrange with
    | inl hsep =>
      have hs : SepAt prog first text i :=
        (sepAt_iff_byte hbyte).mpr (rangeAll_byte hsep.1 (Nat.le_refl b) (Nat.le_refl b))
      cases h.1 hsep.2 with
      | inl hall =>
        refine Or.inl ⟨hall.1, ?_⟩
        intro q h1 h2
        by_cases hq : q = i
        · exact hq ▸ hs
        · exact hall.2 q (by omega) h2
      | inr hfirst =>
        refine Or.inr ⟨hfirst.1, ?_⟩
        intro q r h1 h2 h3 hr
        by_cases hq : q = i
        · exact hq ▸ hs
        · exact hfirst.2 q r (by omega) h2 h3 hr
    | inr hnot =>
      have hn : ¬ SepAt prog first text i := by
        intro hs
        have hsep := (sepAt_iff_byte hbyte).mp hs
        have hno := rangeAll_byte hnot.1 (Nat.le_refl b) (Nat.le_refl b)
        simp [hsep] at hno
      have ⟨hstop, hclean⟩ := h.2 hnot.2
      refine Or.inr ⟨hstop, ?_⟩
      intro q r h1 h2 h3 hr
      by_cases hri : r = i
      · have hqr : q = r := by omega
        exact hqr ▸ hr
      · exact absurd hr (hclean r (by omega) h3)
  · intro hm
    have hstep := (past_step hpast hm).2 _ hrange
    have hn : ¬ SepAt prog first text i := by
      intro hs
      have hsep := (sepAt_iff_byte hbyte).mp hs
      have hno := rangeAll_byte hstep.1 (Nat.le_refl b) (Nat.le_refl b)
      simp [hsep] at hno
    have ⟨hstop, hclean⟩ := h.2 hstep.2
    refine ⟨hstop, ?_⟩
    intro q h1 h2
    by_cases hq : q = i
    · exact hq ▸ hn
    · exact hclean q (by omega) h2

/-- The places after a literal's first take the bytes after the first one's. -/
theorem reads_tail {text : List Nat} {place : Nat × Nat} {literal : List (Nat × Nat)} {i : Nat}
    (h : Reads text (place :: literal) i) : Reads text literal (i + 1) := by
  intro m pl hm
  have ⟨c, hc, hfit⟩ := h (m + 1) pl (by simpa using hm)
  have hidx : i + (m + 1) = i + 1 + m := by omega
  exact ⟨c, hidx ▸ hc, hfit⟩

/-- A walk of a literal's places, over the bytes that they take in a text, goes through the
three sets as `SepWalk` says. -/
theorem chain_seps {prog : Array Inst} {first inside past text : List Nat}
    (hinside : insideOk prog first inside past = true) (hpast : pastOk prog first past = true) :
    ∀ {pc stop : Nat} {places : List (Nat × Nat)}, Chain prog pc places stop →
      ∀ {i : Nat}, Reads text places i →
        SepWalk prog first inside past text pc stop i (i + places.length) := by
  intro pc stop places hchain
  induction hchain with
  | stop =>
    intro i _
    exact ⟨fun h => Or.inl ⟨h, fun q h1 h2 => by simp at h2; omega⟩,
      fun h => ⟨h, fun q h1 h2 => by simp at h2; omega⟩⟩
  | save hinst _ ih =>
    intro i hreads
    exact sepWalk_free (fun h => (inside_step hinside h).1 _ (by simp [freeSuccessors, hinst]))
      (fun h => (past_step hpast h).1 _ (by simp [freeSuccessors, hinst])) (ih hreads)
  | jump hinst _ ih =>
    intro i hreads
    exact sepWalk_free (fun h => (inside_step hinside h).1 _ (by simp [freeSuccessors, hinst]))
      (fun h => (past_step hpast h).1 _ (by simp [freeSuccessors, hinst])) (ih hreads)
  | look hinst _ ih =>
    intro i hreads
    exact sepWalk_free (fun h => (inside_step hinside h).1 _ (by simp [freeSuccessors, hinst]))
      (fun h => (past_step hpast h).1 _ (by simp [freeSuccessors, hinst])) (ih hreads)
  | @byte pc b out stop place literal hinst hfits _ ih =>
    intro i hreads
    have ⟨c, hc, hfit⟩ := hreads 0 place List.getElem?_cons_zero
    have hcb : c = b := (hfits c).mp hfit
    subst hcb
    have hidx : i + (place :: literal).length = i + 1 + literal.length := by
      simp only [List.length_cons]; omega
    rw [hidx]
    exact sepWalk_byte hinside hpast hinst hc (ih (reads_tail hreads))
  | @fold pc one other x y out stop place literal hsplit hone hother hfits _ ih =>
    intro i hreads
    have ⟨c, hc, hfit⟩ := hreads 0 place List.getElem?_cons_zero
    have hidx : i + (place :: literal).length = i + 1 + literal.length := by
      simp only [List.length_cons]; omega
    rw [hidx]
    cases (hfits c).mp hfit with
    | inl hx =>
      subst hx
      exact sepWalk_free
        (fun h => (inside_step hinside h).1 _ (by simp [freeSuccessors, hsplit]))
        (fun h => (past_step hpast h).1 _ (by simp [freeSuccessors, hsplit]))
        (sepWalk_byte hinside hpast hone hc (ih (reads_tail hreads)))
    | inr hy =>
      subst hy
      exact sepWalk_free
        (fun h => (inside_step hinside h).1 _ (by simp [freeSuccessors, hsplit]))
        (fun h => (past_step hpast h).1 _ (by simp [freeSuccessors, hsplit]))
        (sepWalk_byte hinside hpast hother hc (ih (reads_tail hreads)))

/-- A walk of places from an instruction of `first` takes a separator first, or takes no place
and stands in `first`. -/
theorem chain_first {prog : Array Inst} {first text : List Nat}
    (hfirst : firstOk prog first = true) :
    ∀ {pc stop : Nat} {places : List (Nat × Nat)}, Chain prog pc places stop → pc ∈ first →
      ∀ {i : Nat}, Reads text places i →
        (places = [] ∧ stop ∈ first) ∨ SepAt prog first text i := by
  intro pc stop places hchain
  induction hchain with
  | stop => intro hmem i _; exact Or.inl ⟨rfl, hmem⟩
  | save hinst _ ih =>
    intro hmem i hreads
    exact ih (first_step hfirst hmem _ (by simp [freeSuccessors, hinst])) hreads
  | jump hinst _ ih =>
    intro hmem i hreads
    exact ih (first_step hfirst hmem _ (by simp [freeSuccessors, hinst])) hreads
  | look hinst _ ih =>
    intro hmem i hreads
    exact ih (first_step hfirst hmem _ (by simp [freeSuccessors, hinst])) hreads
  | @byte pc b out stop place literal hinst hfits _ _ =>
    intro hmem i hreads
    have ⟨c, hc, hfit⟩ := hreads 0 place List.getElem?_cons_zero
    have hcb : c = b := (hfits c).mp hfit
    subst hcb
    exact Or.inr ⟨c, hc, List.any_eq_true.mpr ⟨pc, hmem,
      takesByte_of_takes (.range hinst (Nat.le_refl _) (Nat.le_refl _))⟩⟩
  | @fold pc one other x y out stop place literal hsplit hone hother hfits _ _ =>
    intro hmem i hreads
    have ⟨c, hc, hfit⟩ := hreads 0 place List.getElem?_cons_zero
    cases (hfits c).mp hfit with
    | inl hx =>
      subst hx
      exact Or.inr ⟨c, hc, List.any_eq_true.mpr
        ⟨one, first_step hfirst hmem _ (by simp [freeSuccessors, hsplit]),
          takesByte_of_takes (.range hone (Nat.le_refl _) (Nat.le_refl _))⟩⟩
    | inr hy =>
      subst hy
      exact Or.inr ⟨c, hc, List.any_eq_true.mpr
        ⟨other, first_step hfirst hmem _ (by simp [freeSuccessors, hsplit]),
          takesByte_of_takes (.range hother (Nat.le_refl _) (Nat.le_refl _))⟩⟩

/-- A walk of no place from an instruction of `first` stands in `first`. -/
theorem chain_none {prog : Array Inst} {first : List Nat} (hfirst : firstOk prog first = true) :
    ∀ {pc stop : Nat} {places : List (Nat × Nat)}, Chain prog pc places stop → places = [] →
      pc ∈ first → stop ∈ first := by
  intro pc stop places hchain
  induction hchain with
  | stop => intro _ hmem; exact hmem
  | save hinst _ ih =>
    intro he hmem
    exact ih he (first_step hfirst hmem _ (by simp [freeSuccessors, hinst]))
  | jump hinst _ ih =>
    intro he hmem
    exact ih he (first_step hfirst hmem _ (by simp [freeSuccessors, hinst]))
  | look hinst _ ih =>
    intro he hmem
    exact ih he (first_step hfirst hmem _ (by simp [freeSuccessors, hinst]))
  | byte _ _ _ _ => intro he; cases he
  | fold _ _ _ _ _ _ => intro he; cases he

/-- The first places of a literal that stands in a text, read from the text read backward:
the walk reads them from the last of them to the first. -/
theorem reads_passed {text : List Nat} {lit : List (Nat × Nat)} {p short : Nat}
    (hshort : short ≤ lit.length) (hlen : p + lit.length ≤ text.length) (h : Reads text lit p) :
    Reads text.reverse (lit.take short).reverse (text.length - (p + short)) := by
  have htake : (lit.take short).length = short := by
    rw [List.length_take]
    omega
  intro j place hj
  have hjlt : j < short := by
    apply Nat.lt_of_not_le
    intro hle
    rw [List.getElem?_eq_none (by rw [List.length_reverse, htake]; exact hle)] at hj
    cases hj
  rw [walked_byte (by omega), htake, List.getElem?_take_of_lt (by omega)] at hj
  have ⟨c, hc, hfit⟩ := h (short - 1 - j) place hj
  refine ⟨c, ?_, hfit⟩
  rw [reverse_byte (by omega)]
  have hidx : text.length - 1 - (text.length - (p + short) + j) = p + (short - 1 - j) := by
    omega
  rw [hidx]
  exact hc

/-! ## The third rule -/

/-- The third rule for a literal inside a match, past its first `short` places. `lit` holds the
literal's places in the text's order. The three sets are right for a separator, and `start`
stands in `first`. The reverse program takes the places passed from `start`, from the last of
them to the first, and stands at `before`. No byte of the place after them is a separator. -/
def innerSeparatedOk (prog : Array Inst) (start before : Nat) (first inside past : List Nat)
    (lit : List (Nat × Nat)) (short : Nat) : Bool :=
  first.contains start && firstOk prog first && first.all (inside.contains ·) &&
    insideOk prog first inside past && pastOk prog first past &&
    chainTo prog before (prog.size + short + 1) start (lit.take short).reverse &&
    match lit[short]? with
    | some next => !separator prog first next.1 && !separator prog first next.2
    | none => false

/-- The third rule gives `BeforeRising`. -/
theorem inner_separated {prog rev : Array Inst} {entry reventry cut before start short : Nat}
    {text first inside past : List Nat} {walked : List (Nat × Nat)} {starts : Nat → Bool}
    (hexact : Exact prog) (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before)
    (hrule : innerSeparatedOk rev start before first inside past walked.reverse short = true) :
    BeforeRising (innerOf hexact hrevexact hrev hclean hlit hpasses hchain) := by
  simp only [innerSeparatedOk, Bool.and_eq_true] at hrule
  obtain ⟨⟨⟨⟨⟨⟨hstart, hfirst⟩, hsub⟩, hinside⟩, hpast⟩, hwalk⟩, hnext⟩ := hrule
  have hstartMem := List.contains_iff_mem.mp hstart
  have hstartInside : start ∈ inside :=
    List.contains_iff_mem.mp (List.all_eq_true.mp hsub _ hstartMem)
  have hpassed := chain_of_chainTo _ _ _ hwalk
  -- No byte of the literal's place after the places passed is a separator.
  obtain ⟨next, hnextAt, hn1, hn2⟩ : ∃ next, walked.reverse[short]? = some next ∧
      separator rev first next.1 = false ∧ separator rev first next.2 = false := by
    cases hl : walked.reverse[short]? with
    | none => simp [hl] at hnext
    | some next =>
      simp only [hl, Bool.and_eq_true, Bool.not_eq_true'] at hnext
      exact ⟨next, rfl, hnext.1, hnext.2⟩
  have hshort : short < walked.reverse.length := by
    apply Nat.lt_of_not_le
    intro hle
    rw [List.getElem?_eq_none hle] at hnextAt
    cases hnextAt
  have htake : (walked.reverse.take short).reverse.length = short := by
    rw [List.length_reverse, List.length_take]
    omega
  -- What one place of the literal gives, with a part before it from `s`: over the text read
  -- backward, the separators stand first from the offset after the places passed up to `s`,
  -- that offset holds a separator, and the offset before it holds none.
  have hplace : ∀ s p, s ≤ p → p ≤ text.length →
      Accepts rev text.reverse before (text.length - p) (text.length - s) →
      p + walked.reverse.length ≤ text.length → Reads text walked.reverse p →
      SepsFirst rev first text.reverse (text.length - (p + short)) (text.length - s) ∧
        SepAt rev first text.reverse (text.length - (p + short)) ∧
        text.length - (p + short) < text.length - s ∧
        ¬ SepAt rev first text.reverse (text.length - (p + short) - 1) := by
    intro s p hsp hp hacc hlen hreads
    obtain ⟨pc, hpath, hdone⟩ := hacc
    have hback := reads_passed (short := short) (by omega) hlen hreads
    have hend : text.length - (p + short) + (walked.reverse.take short).reverse.length =
        text.length - p := by
      rw [htake]
      omega
    have hsets := chain_seps hinside hpast hpassed hback
    rw [hend] at hsets
    -- A separator stands at the span's first offset, and the span holds it.
    have hsepAt : SepAt rev first text.reverse (text.length - (p + short)) ∧
        text.length - (p + short) < text.length - s := by
      by_cases hz : short = 0
      · -- The walk took no place, so `before` stands in `first`.
        have hnil : (walked.reverse.take short).reverse = [] := by simp [hz]
        have ⟨hlt, hsep⟩ :=
          first_separator hfirst hpath hdone (chain_none hfirst hpassed hnil hstartMem)
        rw [hz, Nat.add_zero]
        exact ⟨hsep, hlt⟩
      · cases chain_first hfirst hpassed hstartMem hback with
        | inl hnone =>
          have hlength := congrArg List.length hnone.1
          rw [htake] at hlength
          exact absurd hlength hz
        | inr hsep => exact ⟨hsep, by omega⟩
    refine ⟨?_, ?_, ?_, ?_⟩
    · -- The places passed, and then the part before the literal.
      intro q r h1 h2 h3 hr
      cases hsets.1 hstartInside with
      | inl hall =>
        by_cases hq : q < text.length - p
        · exact hall.2 q h1 hq
        · exact inside_first hinside hpast hpath hall.1 q r (by omega) h2 h3 hr
      | inr hpastSet =>
        by_cases hrp : r < text.length - p
        · exact hpastSet.2 q r h1 h2 hrp hr
        · exact absurd hr (past_clean hpast hpath hpastSet.1 r (by omega) h3)
    · exact hsepAt.1
    · exact hsepAt.2
    · intro hsep
      obtain ⟨c, hc, hcsep⟩ := hsep
      have ⟨c', hc', hfit⟩ := hreads short next hnextAt
      have hidx : text.length - (p + short) - 1 = text.length - 1 - (p + short) := by omega
      rw [hidx, mirrored_byte (by omega), hc'] at hc
      have hcc : c' = c := Option.some.inj hc
      cases hfit with
      | inl h =>
        have h' : c' = next.1 := h
        rw [← hcc, h', hn1] at hcsep
        cases hcsep
      | inr h =>
        have h' : c' = next.2 := h
        rw [← hcc, h', hn2] at hcsep
        cases hcsep
  intro s p s2 p2 hb hs hb2 hs2 hlt
  apply Nat.le_of_not_lt
  intro hss
  obtain ⟨hsp, hp, hacc⟩ := hb
  obtain ⟨hsp2, hp2, hacc2⟩ := hb2
  have hstands : p + walked.reverse.length ≤ text.length ∧ Reads text walked.reverse p := hs
  have hstands2 : p2 + walked.reverse.length ≤ text.length ∧ Reads text walked.reverse p2 := hs2
  have ⟨_, hsepAt, hbound, hnotSep⟩ := hplace s p hsp hp hacc hstands.1 hstands.2
  have ⟨hfirst2, _, _, _⟩ := hplace s2 p2 hsp2 hp2 hacc2 hstands2.1 hstands2.2
  -- The second place's span holds the first place's separator and the byte after it.
  exact hnotSep (hfirst2 (text.length - (p + short) - 1) (text.length - (p + short)) (by omega)
    (by omega) (by omega) hsepAt)

/-- The third rule for a literal inside a match: the rule holds for the literal, or for the
literal past some of its first places. `walked` holds the literal's places from its last to
its first. The sets come from the instruction after the walk of the places not passed. Gives
the count of the places passed. -/
def innerSeparatedOn (rev : Array Inst) (cut before : Nat) (walked : List (Nat × Nat)) :
    Option Nat :=
  (List.range walked.length).find? fun short =>
    match chainStop rev (chainFuel rev walked) cut (walked.take (walked.length - short)) with
    | some start =>
      let sets := separatedSets rev start
      innerSeparatedOk rev start before sets.1 sets.2.1 sets.2.2 walked.reverse short
    | none => false

/-! ## Claim R14's rule -/

/-- One of claim R4's three rules for the part of a match before a literal inside it
(`dfa_suffix.apart` and `dfa_suffix.wide`, from `before`). -/
def beforeOn (rev : Array Inst) (cut before : Nat) (walked : List (Nat × Nat)) : Bool :=
  (match walked.reverse[0]? with
    | some place => noneTakes rev before place.1 && noneTakes rev before place.2
    | none => false) ||
    (fixedLength rev before fixedMost).isSome || (innerSeparatedOn rev cut before walked).isSome

/-- Each rule of `beforeOn` gives `BeforeRising`. -/
theorem beforeOn_rising {prog rev : Array Inst} {entry reventry cut before : Nat}
    {text : List Nat} {walked : List (Nat × Nat)} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
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
      | some place =>
        obtain ⟨b0, b1⟩ := place
        simp only [hb, Bool.and_eq_true] at hapart
        exact inner_apart hexact hrevexact hrev hclean hlit hpasses hchain hapart.1 hapart.2 hb
    | inr hfixed =>
      obtain ⟨n, hn⟩ := Option.isSome_iff_exists.mp hfixed
      exact inner_fixed hexact hrevexact hrev hclean hlit hpasses hchain hn
  | inr hseparated =>
    obtain ⟨short, hshort⟩ := Option.isSome_iff_exists.mp hseparated
    have hat := List.find?_some hshort
    cases hstart : chainStop rev (chainFuel rev walked) cut
        (walked.take (walked.length - short)) with
    | none => simp [hstart] at hat
    | some start =>
      simp only [hstart] at hat
      exact inner_separated hexact hrevexact hrev hclean hlit hpasses hchain hat

/-- Claim R14's rule. `walked` holds the literal's places from its last to its first. The
reverse program takes them from `cut` and stands at `before`, every match passes `cut`, and
one of claim R4's rules holds for the part of a match before the literal. -/
def innerOn (rev : Array Inst) (reventry cut before : Nat) (walked : List (Nat × Nat)) : Bool :=
  chainTo rev before (chainFuel rev walked) cut walked && passesOn rev reventry cut &&
    beforeOn rev cut before walked

/-- What `innerOn` holds: the three hypotheses of `inner_program`. -/
theorem innerOn_parts {rev : Array Inst} {reventry cut before : Nat}
    {walked : List (Nat × Nat)} (h : innerOn rev reventry cut before walked = true) :
    passesOn rev reventry cut = true ∧ Chain rev cut walked before ∧
      beforeOn rev cut before walked = true := by
  simp only [innerOn, Bool.and_eq_true] at h
  exact ⟨h.1.2, chain_of_chainTo _ _ _ h.1.1, h.2⟩

/-- Claim R14 over a program: where the three parts of `innerOn` hold for a literal,
`searcher_inner.find` over the model's scans gives the matcher's answer from `low`, for a text
that has the builder's hypotheses. The reverse scan of each place starts at `before`. -/
theorem inner_program {prog rev : Array Inst} {entry reventry cut before : Nat}
    {text : List Nat} {walked : List (Nat × Nat)} {starts : Nat → Bool} (hexact : Exact prog)
    (hrevexact : Exact rev) (hrev : Reverses prog entry rev reventry text)
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
        0 2 3 [(64, 64)] = true ∧
      innerOn #[.range 97 99 1, .split 0 2, .range 64 64 3, .range 97 99 4, .split 3 5, .done]
        0 0 3 [(64, 64)] = false ∧
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
        .range 97 99 5, .split 4 6, .done] 1 3 [(120, 120), (32, 32)] = some 1 ∧
      innerSeparatedOn #[.range 97 99 1, .range 120 120 2, .range 32 32 3, .range 32 32 4,
        .range 97 99 5, .split 4 6, .done] 1 4 [(120, 120), (32, 32), (32, 32)] = some 0 := by
  decide

/-- `[b-d]*(?i:a)ax[b-d]` has the reverse program `[b-d]xa(?i:a)[b-d]*`. Its literal is `aax`,
whose first place takes `a` in either case. The part before it may hold nothing, so the rule
fails for the literal whole. It holds past the two places of `a`: the separator is `a`, `x`
is none, and the letters before hold none. The first place may take `A`, which is no
separator, and the walk of the places passed then stands among the instructions past the
separator. -/
example :
    innerSeparatedOn #[.range 98 100 1, .range 120 120 2, .range 97 97 3, .split 4 5,
        .range 97 97 6, .range 65 65 6, .split 7 8, .range 98 100 6, .done] 1 6
        [(120, 120), (97, 97), (97, 65)] = some 2 := by
  decide

end Stdx.Regex.Matcher
