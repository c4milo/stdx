import Stdx.Regex.Hypotheses
import Stdx.Regex.MatcherAnswer
import Stdx.Regex.Dfa
import Stdx.Regex.SuffixRule
import Stdx.Regex.Suffix
import Stdx.Regex.Required
import Stdx.Regex.Edges
import Stdx.Regex.Prefix

/-!
# The searches over a program

`Search.lean` and the files of the claims prove each search over three scans that they take as
given. `Dfa.lean` and `Reverse.lean` prove what the two DFAs' scans give for a program. This
file joins them: each search here runs the model's own scans over a program and a text, and
its theorem gives the matcher's answer with no scan taken as given.

- `byDfa` is the search with no claim: the forward DFA's scan gives a match's end, and the
  reverse DFA's scan from that end gives its start. `byDfa_answer` proves it.
- `scansOf` gives `Search.Scans` for a program, a text and a literal: `findLiteral`, the
  reverse DFA's scan, and the matcher from one start.
- `bySuffix_program` is claim R4, from the two walks of the reverse program. The wider search,
  claim R11 and claim R12 follow: `byRequired_program`, `atStart_program`, `fromEnd_program`.
- `bySkip_program` is the skip of claims R2, R3 and R5 to one literal that starts every match,
  from the walk of the forward program.

The claims that this file does not join: R10's count, R13's compare of lengths, R14's search
from a literal inside a match, a pattern that is its literal and nothing else, and a set of
literals.

What the theorems still take as given is the builder's work, and a rule of where a match
starts:

- `Exact` for both programs, and `Reverses` for the text (`Hypotheses.lean` decides both).
- `EmptyElsewhere`, for `byDfa`: a match that starts where no match may start is empty. The
  reverse scan reads paths alone, and this is what makes its start the answer's.
- `StartsClean`, for the searches from a literal: no match starts where no match may start.
  `startsCleanOn` and `emptyElsewhereOn` decide the two for one text.

A program of bytes has both, since a match may start at each offset. A program of UTF-8 takes
whole sequences, so no match of one byte or more starts before a continuation byte. No proof
here holds the builder to that.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Closure Stdx.Regex.Search

/-! ## Where a match starts -/

/-- No match starts where no match may start. -/
def StartsClean (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) : Prop :=
  ∀ s e, s ≤ text.length → Matches prog entry text s e → starts s = true

/-- A match that starts where no match may start is empty. -/
def EmptyElsewhere (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    Prop :=
  ∀ s e, s ≤ text.length → Matches prog entry text s e → starts s = false → s = e

/-- `StartsClean` is the stronger of the two. -/
theorem emptyElsewhere_of_startsClean {prog : Array Inst} {entry : Nat} {text : List Nat}
    {starts : Nat → Bool} (h : StartsClean prog entry text starts) :
    EmptyElsewhere prog entry text starts := by
  intro s e hs hm hstart
  rw [h s e hs hm] at hstart
  cases hstart

/-- Each offset where no match may start has no match. -/
def startsCleanOn (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    Bool :=
  (List.range (text.length + 1)).all fun s => starts s || (endsFrom prog entry text s).isEmpty

/-- Each offset where no match may start has the empty match alone. -/
def emptyElsewhereOn (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool) :
    Bool :=
  (List.range (text.length + 1)).all fun s =>
    starts s || (endsFrom prog entry text s).all (· == s)

/-- A match's end lies in the text, where its start does. -/
theorem matches_inside {prog : Array Inst} {entry : Nat} {text : List Nat} {s e : Nat}
    (hs : s ≤ text.length) (hm : Matches prog entry text s e) : s ≤ e ∧ e ≤ text.length := by
  obtain ⟨pc, hpath, _⟩ := hm
  exact ⟨hpath.le, hpath.le_len hs⟩

/-- A program and a text that pass `startsCleanOn` have `StartsClean`. -/
theorem startsClean_of_startsCleanOn {prog : Array Inst} {entry : Nat} {text : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog)
    (h : startsCleanOn prog entry text starts = true) : StartsClean prog entry text starts := by
  intro s e hs hm
  have hin := matches_inside hs hm
  have hat := List.all_eq_true.mp h s (List.mem_range.mpr (by omega))
  have hmem := (mem_endsFrom hexact entry text hin.2).mpr hm
  cases hstart : starts s with
  | true => rfl
  | false =>
    simp only [hstart, Bool.false_or, List.isEmpty_iff] at hat
    rw [hat] at hmem
    cases hmem

/-- A program and a text that pass `emptyElsewhereOn` have `EmptyElsewhere`. -/
theorem emptyElsewhere_of_emptyElsewhereOn {prog : Array Inst} {entry : Nat} {text : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog)
    (h : emptyElsewhereOn prog entry text starts = true) :
    EmptyElsewhere prog entry text starts := by
  intro s e hs hm hstart
  have hin := matches_inside hs hm
  have hat := List.all_eq_true.mp h s (List.mem_range.mpr (by omega))
  have hmem := (mem_endsFrom hexact entry text hin.2).mpr hm
  simp only [hstart, Bool.false_or] at hat
  have := List.all_eq_true.mp hat e hmem
  exact (beq_iff_eq.mp this).symm

/-! ## The search with no claim -/

/-- `Searcher.find_by_dfa` with no claim: the forward DFA's scan from `low` gives the end of a
match, and the reverse DFA's scan from that end back to `low` gives its start. -/
def byDfa (prog : Array Inst) (entry : Nat) (rev : Array Inst) (reventry : Nat)
    (text : List Nat) (mayByte : Nat → Bool) (low : Nat) : Option (Nat × Nat) :=
  match Dfa.scan prog entry text mayByte (text.length - low + 1) low
      ⟨behind text low, true, []⟩ none with
  | none => none
  | some e => (scanBack rev reventry text low e).map (·, e)

/-- The two scans give the matcher's answer from `low`. -/
theorem byDfa_answer {prog rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    {mayByte : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hempty : EmptyElsewhere prog entry text (Dfa.startsOf text mayByte)) {low : Nat}
    (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text (Dfa.startsOf text mayByte) hexact) low
      (byDfa prog entry rev reventry text mayByte low) := by
  have ha := answerOf_isAnswer prog entry text (Dfa.startsOf text mayByte) hexact hlow
  have hscan := Dfa.scan_answer prog entry text mayByte hexact hlow ha
  unfold byDfa
  rw [hscan]
  cases hans : answerOf prog entry text (Dfa.startsOf text mayByte) low with
  | none =>
    rw [hans] at ha
    exact ha
  | some span =>
    obtain ⟨s, e⟩ := span
    rw [hans] at ha
    have hm := (textOf prog entry text (Dfa.startsOf text mayByte) hexact).prefers_match ha.2.1
    have hin := matches_inside hm.1 hm.2.2
    simp only [Option.map_some]
    cases hback : scanBack rev reventry text low e with
    | none => exact absurd hm.2.2 (scanBack_none hrevexact hrev hin.2 hback ha.1)
    | some s' =>
      have hsome := scanBack_some hrev (Nat.le_trans ha.1 hin.1) hin.2 hback
      have hleast := scanBack_least hrevexact hrev hin.2 hback ha.1 hm.2.2
      have hs' : s' ≤ text.length := by omega
      have hsame : s' = s := by
        cases hstart : Dfa.startsOf text mayByte s' with
        | true =>
          have := ha.2.2 s' e hsome.1 ⟨hs', hstart, hsome.2⟩
          omega
        | false =>
          have := hempty s' e hs' hsome.2 hstart
          omega
      subst hsame
      exact ha

/-! ## The scans of a program, for a literal -/

/-- Whether a literal stands whole at an offset of a text. -/
def standsAt (text lit : List Nat) (p : Nat) : Bool :=
  decide (p + lit.length ≤ text.length) &&
    (List.range lit.length).all fun j => text[p + j]? == lit[j]?

/-- `standsAt` decides that the literal stands whole in the text. -/
theorem standsAt_iff {text lit : List Nat} {p : Nat} :
    standsAt text lit p = true ↔ p + lit.length ≤ text.length ∧ StandsAt text lit p := by
  simp only [standsAt, Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true, List.mem_range,
    beq_iff_eq, StandsAt]

/-- The first place of a literal from `i`, among `turns` offsets. -/
def findFrom (text lit : List Nat) : Nat → Nat → Option Nat
  | 0, _ => none
  | turns + 1, i => if standsAt text lit i then some i else findFrom text lit turns (i + 1)

/-- `Literal.find`: the first place of a literal at or after `i`. -/
def findLiteral (text lit : List Nat) (i : Nat) : Option Nat :=
  findFrom text lit (text.length + 1 - i) i

/-- A place that `findFrom` gives is a place, and the first from `i`. -/
theorem findFrom_some {text lit : List Nat} :
    ∀ turns i p, findFrom text lit turns i = some p →
      i ≤ p ∧ standsAt text lit p = true ∧ ∀ q, i ≤ q → q < p → standsAt text lit q = false := by
  intro turns
  induction turns with
  | zero => intro i p h; simp [findFrom] at h
  | succ turns ih =>
    intro i p h
    simp only [findFrom] at h
    cases hat : standsAt text lit i with
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

/-- Where `findFrom` gives nothing, none of its offsets is a place. -/
theorem findFrom_none {text lit : List Nat} :
    ∀ turns i, findFrom text lit turns i = none →
      ∀ q, i ≤ q → q < i + turns → standsAt text lit q = false := by
  intro turns
  induction turns with
  | zero => intro i _ q h1 h2; omega
  | succ turns ih =>
    intro i h q hq1 hq2
    simp only [findFrom] at h
    cases hat : standsAt text lit i with
    | true => simp [hat] at h
    | false =>
      simp only [hat, Bool.false_eq_true, ite_false] at h
      cases Nat.lt_or_ge i q with
      | inl hlt => exact ih (i + 1) h q hlt (by omega)
      | inr hge =>
        have : q = i := by omega
        exact this ▸ hat

/-- The scans that the searches from a literal call, for a program, a text and a literal:
`findLiteral`, the reverse DFA's scan, and the matcher from one start. Each field is what
`Search.Scans` asks of it. -/
def scansOf {prog rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (lit : List Nat) (hlit : 0 < lit.length) :
    Scans (textOf prog entry text starts hexact) where
  width := lit.length
  Stands := fun p => p + lit.length ≤ text.length ∧ StandsAt text lit p
  place := findLiteral text lit
  back := fun low e =>
    if low ≤ e ∧ e ≤ text.length then scanBack rev reventry text low e else none
  ahead := fun s => if starts s = true ∧ s ≤ text.length then findAt prog entry text s else none
  width_pos := hlit
  stands_inside := fun h => h.1
  place_some := by
    intro i p h
    obtain ⟨h1, h2, _⟩ := findFrom_some _ i p h
    exact ⟨h1, standsAt_iff.mp h2⟩
  place_first := by
    intro i p q h hq1 hq2 hstands
    obtain ⟨_, _, h3⟩ := findFrom_some _ i p h
    have := h3 q hq1 hq2
    rw [standsAt_iff.mpr hstands] at this
    cases this
  place_none := by
    intro i q h hq hstands
    have hlen : q + lit.length ≤ text.length := hstands.1
    have := findFrom_none _ i h q hq (by omega)
    rw [standsAt_iff.mpr hstands] at this
    cases this
  back_some := by
    intro low e s h
    by_cases hguard : low ≤ e ∧ e ≤ text.length
    · rw [ite_eq_left hguard] at h
      have hsome := scanBack_some hrev hguard.1 hguard.2 h
      obtain ⟨pc, hpath, hdone⟩ := hsome.2
      have hs : s ≤ text.length := Nat.le_trans hpath.le hguard.2
      exact ⟨hsome.1, hs, hclean s e hs hsome.2, hsome.2⟩
    · rw [ite_eq_right hguard] at h
      cases h
  back_least := by
    intro low e s s' h hlow hm
    have hin := matches_inside hm.1 hm.2.2
    have hguard : low ≤ e ∧ e ≤ text.length := ⟨by omega, hin.2⟩
    rw [ite_eq_left hguard] at h
    exact scanBack_least hrevexact hrev hin.2 h hlow hm.2.2
  back_none := by
    intro low e s h hlow hm
    have hin := matches_inside hm.1 hm.2.2
    have hguard : low ≤ e ∧ e ≤ text.length := ⟨by omega, hin.2⟩
    rw [ite_eq_left hguard] at h
    exact scanBack_none hrevexact hrev hin.2 h hlow hm.2.2
  ahead_some := by
    intro s e h
    by_cases hguard : starts s = true ∧ s ≤ text.length
    · rw [ite_eq_left hguard, findAt_eq] at h
      exact ⟨hguard.2, hguard.1, h⟩
    · rw [ite_eq_right hguard] at h
      cases h
  ahead_none := by
    intro s e h hm
    have hguard : starts s = true ∧ s ≤ text.length := ⟨hm.2.1, hm.1⟩
    rw [ite_eq_left hguard, findAt_eq] at h
    obtain ⟨e', hpref⟩ := (textOf prog entry text starts hexact).prefers_some hm
    have := hpref.2.2
    rw [h] at this
    cases this

/-! ## The searches from a literal, over a program -/

/-- A match of the forward program is a match of the reverse program over the text read
backward. -/
theorem reversed_match {prog rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog) (hrev : Reverses prog entry rev reventry text)
    {s e : Nat} (hm : (textOf prog entry text starts hexact).Match s e) :
    Matches rev reventry text.reverse (text.length - e) (text.length - s) := by
  have hin := matches_inside hm.1 hm.2.2
  exact (hrev s e hin.1 hin.2).mp hm.2.2

/-- A byte of a literal, where `walked` holds the literal's bytes from its last to its first. -/
theorem walked_byte {walked : List Nat} {j : Nat} (hj : j < walked.length) :
    walked.reverse[j]? = walked[walked.length - 1 - j]? := by
  simp [List.getElem?_reverse hj]

/-- Every match ends with the literal that `Literal.walk` read from the reverse program's
entry. `walked` holds its bytes from the last to the first, as the walk reads them. -/
theorem endsWith_of_chain {prog rev : Array Inst} {entry reventry before : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hchain : Chain rev reventry walked before)
    (hlit : 0 < walked.reverse.length) :
    EndsWith (textOf prog entry text starts hexact)
      (scansOf hexact hrevexact hrev hclean walked.reverse hlit) := by
  intro s e hm
  have hin := matches_inside hm.1 hm.2.2
  obtain ⟨pc, hpath, hdone⟩ := reversed_match hexact hrev hm
  have ⟨hbytes, hrest⟩ := chain_path hchain hpath hdone
  have hle := hrest.le
  have hlen : walked.reverse.length = walked.length := List.length_reverse
  show s + walked.reverse.length ≤ e ∧
    (e - walked.reverse.length + walked.reverse.length ≤ text.length ∧
      StandsAt text walked.reverse (e - walked.reverse.length))
  refine ⟨by omega, by omega, ?_⟩
  intro j hj
  rw [walked_byte (by omega)]
  have h := hbytes (walked.length - 1 - j) (by omega)
  rw [reverse_byte (by omega)] at h
  have hidx : text.length - 1 - (text.length - e + (walked.length - 1 - j)) =
      e - walked.reverse.length + j := by omega
  rw [hidx] at h
  exact h

/-- Claim R4 over a program. `Literal.walk` read `walked` from the reverse program's entry up
to `before`, and `before_takes` found no instruction from `before` that takes the byte `b`,
which is the literal's first byte. Then `Searcher.find_by_suffix` over the model's scans gives
the matcher's answer from `low`. -/
theorem bySuffix_program {prog rev : Array Inst} {entry reventry before b : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hchain : Chain rev reventry walked before)
    (hnone : ∀ x out, Reach rev before x → ¬ Takes rev x b out)
    (hlit : 0 < walked.reverse.length) (hfirst : walked.reverse[0]? = some b) {low : Nat}
    (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (bySuffix (scansOf hexact hrevexact hrev hclean walked.reverse hlit) low
        (text.length - low + 1) low) := by
  have hends := endsWith_of_chain hexact hrevexact hrev hclean hchain hlit
  have hlen : walked.reverse.length = walked.length := List.length_reverse
  have hrule := suffix_rule (Match := (textOf prog entry text starts hexact).Match)
    (fun s e hm => matches_inside hm.1 hm.2.2) (fun s e hm => reversed_match hexact hrev hm)
    hchain hnone
  have hcleanBefore : CleanBefore (textOf prog entry text starts hexact)
      (scansOf hexact hrevexact hrev hclean walked.reverse hlit)
      (fun q => text[q]? = some b) := by
    intro s e hm q hq1 hq2
    have hq3 : q < e - walked.length := by
      have : (scansOf hexact hrevexact hrev hclean walked.reverse hlit).width =
          walked.reverse.length := rfl
      omega
    exact (hrule s e hm).2 q hq1 hq3
  have hgap : Gap (scansOf hexact hrevexact hrev hclean walked.reverse hlit)
      (fun q => text[q]? = some b) := by
    apply first_gap
    intro p hp
    have h := hp.2 0 hlit
    rw [Nat.add_zero, hfirst] at h
    exact h
  exact bySuffix_answer hcleanBefore hgap hends hlow

/-- The wider search over a program: every match ends with the literal that `Literal.walk`
read, and `NoEarlier` holds. Then the search from the literal's places, with a forward scan
from each start, gives the matcher's answer from `low`. -/
theorem byRequired_program {prog rev : Array Inst} {entry reventry before : Nat}
    {text walked : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hchain : Chain rev reventry walked before)
    (hlit : 0 < walked.reverse.length)
    (hearlier : NoEarlier (textOf prog entry text starts hexact)) {low : Nat}
    (hlow : low ≤ text.length) :
    IsAnswer (textOf prog entry text starts hexact) low
      (byRequired (scansOf hexact hrevexact hrev hclean walked.reverse hlit) low
        (text.length - low + 1) low) :=
  byRequired_answer hearlier (endsWith_of_chain hexact hrevexact hrev hclean hchain hlit) hlow

/-- Claim R11 over a program: where every match starts at the text's start, the matcher from
`low` alone gives the answer. The literal is any, since the search reads no place. -/
theorem atStart_program {prog rev : Array Inst} {entry reventry : Nat} {text lit : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < lit.length)
    (hstart : ∀ s e, (textOf prog entry text starts hexact).Match s e → s = 0) (low : Nat) :
    IsAnswer (textOf prog entry text starts hexact) low
      (atStart (scansOf hexact hrevexact hrev hclean lit hlit) low) :=
  atStart_answer hstart

/-- Claim R12 over a program: where every match ends at the text's end, the reverse DFA's scan
from there gives the answer. The literal is any, since the search reads no place. -/
theorem fromEnd_program {prog rev : Array Inst} {entry reventry : Nat} {text lit : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < lit.length)
    (hend : ∀ s e, (textOf prog entry text starts hexact).Match s e → e = text.length)
    (low : Nat) :
    IsAnswer (textOf prog entry text starts hexact) low
      (fromEnd (scansOf hexact hrevexact hrev hclean lit hlit) low) :=
  fromEnd_answer hend

/-- Every match starts with the literal that `Literal.walk` read from the forward program's
entry. -/
theorem startsWith_of_chain {prog rev : Array Inst} {entry reventry stop : Nat}
    {text lit : List Nat} {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hchain : Chain prog entry lit stop)
    (hlit : 0 < lit.length) :
    StartsWith (textOf prog entry text starts hexact)
      (scansOf hexact hrevexact hrev hclean lit hlit) := by
  intro s e hm
  have hin := matches_inside hm.1 hm.2.2
  obtain ⟨pc, hpath, hdone⟩ := hm.2.2
  have ⟨hbytes, hrest⟩ := chain_path hchain hpath hdone
  have hle := hrest.le
  exact ⟨by omega, hbytes⟩

/-- The search of claims R2, R3 and R5 for one literal: from the literal's first place at or
after `low`, the two scans of `byDfa`. -/
def bySkip (prog : Array Inst) (entry : Nat) (rev : Array Inst) (reventry : Nat)
    (text : List Nat) (mayByte : Nat → Bool) (lit : List Nat) (low : Nat) : Option (Nat × Nat) :=
  match findLiteral text lit low with
  | none => none
  | some p => byDfa prog entry rev reventry text mayByte p

/-- The skip over a program. `Literal.walk` read `lit` from the forward program's entry, so
every match starts with it. Then the search from the literal's first place gives the matcher's
answer from `low`. -/
theorem bySkip_program {prog rev : Array Inst} {entry reventry stop : Nat}
    {text lit : List Nat} {mayByte : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text (Dfa.startsOf text mayByte))
    (hchain : Chain prog entry lit stop) (hlit : 0 < lit.length) (low : Nat) :
    IsAnswer (textOf prog entry text (Dfa.startsOf text mayByte) hexact) low
      (bySkip prog entry rev reventry text mayByte lit low) := by
  have hstarts := startsWith_of_chain hexact hrevexact hrev hclean hchain hlit
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

/-! ## The searches on small programs -/

/-- `a+b` from 0 and its reverse program `ba+` from 4, in one array. In `xaab` the two scans
give the match from 1 up to 4, from 2 they give the match from 2, and from 4 they give none.
The literal `ab` stands at 2 alone. -/
example :
    byDfa #[.range 97 97 1, .split 0 2, .range 98 98 3, .done,
        .range 98 98 5, .range 97 97 6, .split 5 7, .done] 0
      #[.range 97 97 1, .split 0 2, .range 98 98 3, .done,
        .range 98 98 5, .range 97 97 6, .split 5 7, .done] 4
      [120, 97, 97, 98] (fun _ => true) 0 = some (1, 4) ∧
    byDfa #[.range 97 97 1, .split 0 2, .range 98 98 3, .done,
        .range 98 98 5, .range 97 97 6, .split 5 7, .done] 0
      #[.range 97 97 1, .split 0 2, .range 98 98 3, .done,
        .range 98 98 5, .range 97 97 6, .split 5 7, .done] 4
      [120, 97, 97, 98] (fun _ => true) 2 = some (2, 4) ∧
    byDfa #[.range 97 97 1, .split 0 2, .range 98 98 3, .done,
        .range 98 98 5, .range 97 97 6, .split 5 7, .done] 0
      #[.range 97 97 1, .split 0 2, .range 98 98 3, .done,
        .range 98 98 5, .range 97 97 6, .split 5 7, .done] 4
      [120, 97, 97, 98] (fun _ => true) 4 = none ∧
    findLiteral [120, 97, 97, 98] [97, 98] 0 = some 2 ∧
    findLiteral [120, 97, 97, 98] [97, 98] 1 = some 2 ∧
    findLiteral [120, 97, 97, 98] [97, 98] 3 = none := by decide

/-- `a*` read as UTF-8 over the two bytes of `é`. It matches the empty text before the
continuation byte, so it has `EmptyElsewhere` and not `StartsClean`. `[\x80-\xBF]*a` over a
continuation byte and `a` matches both bytes from 0, where no match may start, so it has
neither. -/
example :
    emptyElsewhereOn #[.split 1 2, .range 97 97 0, .done] 0 [0xC3, 0xA9]
        (Dfa.startsOf [0xC3, 0xA9] fun b => !(0x80 ≤ b && b ≤ 0xBF)) = true ∧
      startsCleanOn #[.split 1 2, .range 97 97 0, .done] 0 [0xC3, 0xA9]
        (Dfa.startsOf [0xC3, 0xA9] fun b => !(0x80 ≤ b && b ≤ 0xBF)) = false ∧
      emptyElsewhereOn #[.split 1 2, .range 128 191 0, .range 97 97 3, .done] 0 [0xA9, 97]
        (Dfa.startsOf [0xA9, 97] fun b => !(0x80 ≤ b && b ≤ 0xBF)) = false := by decide

end Stdx.Regex.Matcher
