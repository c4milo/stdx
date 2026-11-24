import Stdx.Regex.Suffix

/-!
# Claims R2, R3 and R5: the skip to a literal that starts every match

Where every match starts with a literal, or with one of a set of literals, no match starts where
none stands (decision 86). So a search may start at the first place at or after its first offset,
and a text with no place holds no match. `Stands p` holds here where the literal stands at `p`,
or one literal of the set.

- `answer_from_place`: the answer from the first place is the answer from the search's first
  offset. Claims R2, R3 and R5 start the forward scan there.
- `answer_none`: a text with no place from the offset on holds no match. `Searcher.is_match`
  answers so with no scan.
- `byExact_answer`: where the pattern is one literal and nothing else, each place of the literal
  is a match, and the searcher reads no DFA.
- `gap_of_byte`: any byte of a literal stands from each place of the literal up to the next
  place. That is the `Gap` that `Suffix.lean` asks of a mark, so claim R4's rule holds for any
  byte of the literal that the part before it never takes.

This file does not model a set of literals and nothing else, whose match is the first literal
of the set that stands at the first place.
-/
namespace Stdx.Regex.Search

/-- Every match starts at a place of the literal. -/
def StartsWith (t : Text) (c : Scans t) : Prop :=
  ∀ s e, t.Match s e → c.Stands s

/-- The skip changes no answer: the answer from the first place at or after `low` is the answer
from `low`. -/
theorem answer_from_place {t : Text} {c : Scans t} {low p : Nat} {a : Option (Nat × Nat)}
    (hstarts : StartsWith t c) (hplace : c.place low = some p) (ha : IsAnswer t p a) :
    IsAnswer t low a := by
  have hp := c.place_some hplace
  -- A match from `low` starts at a place, so at `p` or later.
  have hfrom : ∀ s e, low ≤ s → t.Match s e → p ≤ s := by
    intro s e hlow hm
    apply Nat.le_of_not_lt
    intro hlt
    exact c.place_first hplace hlow hlt (hstarts s e hm)
  match a, ha with
  | none, ha =>
    intro s e hlow hm
    exact ha s e (hfrom s e hlow hm) hm
  | some (s, e), ha =>
    refine ⟨Nat.le_trans hp.1 ha.1, ha.2.1, ?_⟩
    intro s' e' hlow hm
    exact ha.2.2 s' e' (hfrom s' e' hlow hm) hm

/-- A text with no place of the literal at or after `low` holds no match from `low`. -/
theorem answer_none {t : Text} {c : Scans t} {low : Nat}
    (hstarts : StartsWith t c) (hplace : c.place low = none) : IsAnswer t low none := by
  intro s e hlow hm
  exact c.place_none hplace hlow (hstarts s e hm)

/-- The pattern is the literal and nothing else: a match is one place of the literal. -/
def Exact (t : Text) (c : Scans t) : Prop :=
  ∀ s e, t.Match s e ↔ c.Stands s ∧ e = s + c.width

/-- `Searcher.find_by_dfa` for a pattern that is its literal: the literal's first place. -/
def byExact {t : Text} (c : Scans t) (low : Nat) : Option (Nat × Nat) :=
  match c.place low with
  | none => none
  | some p => some (p, p + c.width)

/-- Claim R2 for a pattern that is its literal: the first place of the literal is the matcher's
answer, with no DFA. -/
theorem byExact_answer {t : Text} {c : Scans t} {low : Nat} (hexact : Exact t c) :
    IsAnswer t low (byExact c low) := by
  have hstarts : StartsWith t c := fun s e hm => ((hexact s e).mp hm).1
  unfold byExact
  cases hplace : c.place low with
  | none => exact answer_none hstarts hplace
  | some p =>
    have hp := c.place_some hplace
    have hm : t.Match p (p + c.width) := (hexact p (p + c.width)).mpr ⟨hp.2, rfl⟩
    refine ⟨hp.1, ?_, ?_⟩
    · have ⟨e2, hpref⟩ := t.prefers_some hm
      have he := ((hexact p e2).mp (t.prefers_match hpref)).2
      exact he ▸ hpref
    · intro s' e' hlow hm'
      apply Nat.le_of_not_lt
      intro hlt
      exact c.place_first hplace hlow hlt (hstarts s' e' hm')

/-- A literal stands whole at an offset of a text. -/
def StandsAt (text literal : List Nat) (p : Nat) : Prop :=
  ∀ j, j < literal.length → text[p + j]? = literal[j]?

/-- Each byte of a literal stands from a place of the literal up to its next place. A byte past
the distance of the two places is also the literal's byte that distance before it. -/
theorem byte_between {text literal : List Nat} {p p' : Nat}
    (hp : StandsAt text literal p) (hp' : StandsAt text literal p') (hlt : p < p') :
    ∀ j, j < literal.length → ∃ q, p ≤ q ∧ q < p' ∧ text[q]? = literal[j]?
  | j, hj =>
    if h : j < p' - p then
      ⟨p + j, Nat.le_add_right p j, by omega, hp j hj⟩
    else by
      have hback : j - (p' - p) < literal.length := by omega
      have ⟨q, hq1, hq2, hq3⟩ := byte_between hp hp' hlt (j - (p' - p)) hback
      have h1 := hp j hj
      have h2 := hp' (j - (p' - p)) hback
      have hidx : p' + (j - (p' - p)) = p + j := by omega
      rw [hidx, h1] at h2
      exact ⟨q, hq1, hq2, by rw [hq3, h2]⟩
termination_by j => j
decreasing_by omega

/-- Any byte of a literal is a mark with `Gap`. -/
theorem gap_of_byte {t : Text} {c : Scans t} {text literal : List Nat} {j b : Nat}
    (hstands : ∀ p, c.Stands p → StandsAt text literal p) (hj : j < literal.length)
    (hb : literal[j]? = some b) : Gap c (fun q => text[q]? = some b) := by
  intro p p' hp hp' hlt
  have ⟨q, hq1, hq2, hq3⟩ := byte_between (hstands p hp) (hstands p' hp') hlt j hj
  exact ⟨q, hq1, hq2, show text[q]? = some b by rw [hq3, hb]⟩

end Stdx.Regex.Search
