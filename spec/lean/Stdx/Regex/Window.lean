import Stdx.Regex.Inner

/-!
# The window: a search from a literal near every match's start

Every match of `\s[a-zA-Z]{0,12}ing\s` holds `ing` at most 13 bytes after its start. So no match
starts more than 13 bytes before the first place of `ing`, and a search may start its forward scan
there (decision 86, the window). This is the filter of a regular expression by a factor that every
match holds: find the factor, and read a window around it.

- `Within` says that every match holds a place of the literal at most `lead` bytes after its
  start.
- `answer_from_window`: the answer from `lead` bytes before the first place at or after `low`,
  and never before `low`, is the answer from `low`.
- `window_none`: a text with no place from `low` on holds no match from `low`.
- `within_of_inner`: a literal inside every match, after a part of at most `lead` bytes, is such
  a literal.

Claim R4's rules and claim R14's may refuse such a literal, since the part before it may hold the
literal's bytes. The window needs none of them: its forward scan reads every byte from where a
match may start.
-/
namespace Stdx.Regex.Search

/-- Every match holds a place of the literal at most `lead` bytes after its start. -/
def Within (t : Text) (c : Scans t) (lead : Nat) : Prop :=
  ∀ s e, t.Match s e → ∃ q, s ≤ q ∧ q ≤ s + lead ∧ c.Stands q

/-- No match from `low` starts before `lead` bytes before the first place at or after `low`. -/
theorem window_start {t : Text} {c : Scans t} {lead low p : Nat} (hwithin : Within t c lead)
    (hplace : c.place low = some p) {s e : Nat} (hlow : low ≤ s) (hm : t.Match s e) :
    max low (p - lead) ≤ s := by
  obtain ⟨q, hsq, hqs, hq⟩ := hwithin s e hm
  have hpq : p ≤ q := by
    apply Nat.le_of_not_lt
    intro hlt
    exact c.place_first hplace (Nat.le_trans hlow hsq) hlt hq
  have : p - lead ≤ s := by omega
  exact Nat.max_le.mpr ⟨hlow, this⟩

/-- The window changes no answer: the answer from `lead` bytes before the first place at or after
`low`, and never before `low`, is the answer from `low`. -/
theorem answer_from_window {t : Text} {c : Scans t} {lead low p : Nat} {a : Option (Nat × Nat)}
    (hwithin : Within t c lead) (hplace : c.place low = some p)
    (ha : IsAnswer t (max low (p - lead)) a) : IsAnswer t low a := by
  match a, ha with
  | none, ha =>
    intro s e hlow hm
    exact ha s e (window_start hwithin hplace hlow hm) hm
  | some (s, e), ha =>
    refine ⟨Nat.le_trans (Nat.le_max_left _ _) ha.1, ha.2.1, ?_⟩
    intro s' e' hlow hm
    exact ha.2.2 s' e' (window_start hwithin hplace hlow hm) hm

/-- A text with no place of the literal at or after `low` holds no match from `low`. -/
theorem window_none {t : Text} {c : Scans t} {lead low : Nat} (hwithin : Within t c lead)
    (hplace : c.place low = none) : IsAnswer t low none := by
  intro s e hlow hm
  obtain ⟨q, hsq, _, hq⟩ := hwithin s e hm
  exact c.place_none hplace (Nat.le_trans hlow hsq) hq

/-- A literal inside every match, after a part of the pattern that takes at most `lead` bytes,
stands at most `lead` bytes after every match's start. -/
theorem within_of_inner {t : Text} {c : Scans t} (n : Inner t c) {lead : Nat}
    (hbound : ∀ s p, n.Before s p → p ≤ s + lead) : Within t c lead := by
  intro s e hm
  obtain ⟨p, hb, hstands, _⟩ := n.split hm
  exact ⟨p, n.before_inside hb, hbound s p hb, hstands⟩

/-- A wider window holds what a narrower one holds. -/
theorem within_wider {t : Text} {c : Scans t} {lead lead' : Nat} (hwithin : Within t c lead)
    (hle : lead ≤ lead') : Within t c lead' := by
  intro s e hm
  obtain ⟨q, hsq, hqs, hq⟩ := hwithin s e hm
  exact ⟨q, hsq, by omega, hq⟩

end Stdx.Regex.Search
