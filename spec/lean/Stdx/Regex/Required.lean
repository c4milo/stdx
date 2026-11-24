import Stdx.Regex.Suffix

/-!
# The wider rule: a search from a required literal, with a forward scan

Claim R4 refuses a literal whose first byte the part before it takes, as in `\w+\s+Holmes` and
`[a-z]shing`. A wider claim keeps the search from the literal's places, and scans forward from the
start it finds, since a match may now go on past the place. `byRequired` is that search.

Its precondition is `NoEarlier`, and `byRequired_answer` needs it: where a match ends before
another match ends, it starts at or before the other's start, or the other's start has a match
that ends there too. Without it the search is wrong: `needs_no_earlier` gives a text where every
match ends with the literal and the search gives a later start than the matcher. The pattern
`(?:[a-z]|[0-9][a-z]ab)ab` on the text `1xabab` is that text.

Four rules give `NoEarlier`, each one that a walk of a program can judge:

- `noEarlier_of_clean`: a byte of the literal stands in no part of a match before the literal.
  With the literal's first byte this is claim R4's own rule.
- `noEarlier_of_one_length`: every match has one length, as in `[a-z]shing`.
- `noEarlier_of_last_separator`: the part before the literal ends with one or more bytes of a
  class, and neither the rest of that part nor the literal's first byte is of the class, as the
  `\s+` of `\w+\s+Holmes`.
- `noEarlier_of_first_separator`: the part before the literal starts with one or more bytes of a
  class, and neither the rest of that part nor the literal holds a byte of the class.

Rust's regex crate judges its reverse suffix search by rules of these four kinds
(regex-automata 0.4.19, `meta/reverse_suffix.rs`), which decision 86 lets this file read for
their method.

`byGuarded` is the same search with a reverse scan that may give up, as a guard against a
quadratic search does. `byGuarded_answer`: where it gives an answer, the answer is `byRequired`'s.
-/
namespace Stdx.Regex.Search

/-- Where a match ends before another match ends, it starts at or before the other's start, or
the other's start has a match that ends there too. -/
def NoEarlier (t : Text) : Prop :=
  ∀ s e s' e', t.Match s e → t.Match s' e' → e < e' → s ≤ s' ∨ t.Match s' e

/-- The search from a required literal: from `index`, the first place of the literal from whose
end the reverse scan reads back to a match's start, and the forward scan's end from that start. -/
def byRequired {t : Text} (c : Scans t) (low : Nat) : Nat → Nat → Option (Nat × Nat)
  | 0, _ => none
  | turns + 1, index =>
    match c.place index with
    | none => none
    | some p =>
      match c.back low (p + c.width) with
      | none => byRequired c low turns (p + 1)
      | some s =>
        match c.ahead s with
        | none => none
        | some e => some (s, e)

/-- A turn ends the search where no place follows. -/
theorem byRequired_none {t : Text} {c : Scans t} {low turns index : Nat}
    (hplace : c.place index = none) : byRequired c low (turns + 1) index = none := by
  simp [byRequired, hplace]

/-- A turn goes on from one byte past a place that ends no match. -/
theorem byRequired_next {t : Text} {c : Scans t} {low turns index p : Nat}
    (hplace : c.place index = some p) (hback : c.back low (p + c.width) = none) :
    byRequired c low (turns + 1) index = byRequired c low turns (p + 1) := by
  simp [byRequired, hplace, hback]

/-- A turn ends the search at a place that ends a match, with the forward scan's end. -/
theorem byRequired_found {t : Text} {c : Scans t} {low turns index p s e : Nat}
    (hplace : c.place index = some p) (hback : c.back low (p + c.width) = some s)
    (hahead : c.ahead s = some e) :
    byRequired c low (turns + 1) index = some (s, e) := by
  simp [byRequired, hplace, hback, hahead]

/-- The loop's step: while every match from `low` ends at a place at or after `index`, the loop
from `index` gives the matcher's answer. -/
theorem byRequired_from {t : Text} {c : Scans t} {low : Nat}
    (hearlier : NoEarlier t) (hends : EndsWith t c) :
    ∀ turns index, t.len + 1 ≤ index + turns →
      (∀ s e, low ≤ s → t.Match s e → index ≤ e - c.width) →
      IsAnswer t low (byRequired c low turns index) := by
  intro turns
  induction turns with
  | zero =>
    intro index hturns hinv s e hlow hm
    have h1 := hinv s e hlow hm
    have h2 := (t.inside hm).2
    omega
  | succ turns ih =>
    intro index hturns hinv
    cases hplace : c.place index with
    | none =>
      rw [byRequired_none hplace]
      intro s e hlow hm
      exact c.place_none hplace (hinv s e hlow hm) (place_of_match hends hm).2.1
    | some p =>
      have hp := c.place_some hplace
      cases hback : c.back low (p + c.width) with
      | none =>
        rw [byRequired_next hplace hback]
        apply ih (p + 1) (by omega)
        intro s e hlow hm
        have hq := place_of_match hends hm
        have h1 := hinv s e hlow hm
        apply Nat.lt_of_not_le
        intro hle
        cases Nat.lt_or_eq_of_le hle with
        | inl hlt => exact c.place_first hplace h1 hlt hq.2.1
        | inr heq =>
          have he : e = p + c.width := by omega
          exact c.back_none hback hlow (he ▸ hm)
      | some s0 =>
        have hb := c.back_some hback
        cases hahead : c.ahead s0 with
        | none => exact absurd hb.2 (c.ahead_none hahead)
        | some e0 =>
          rw [byRequired_found hplace hback hahead]
          refine ⟨hb.1, c.ahead_some hahead, ?_⟩
          intro s' e' hlow hm
          apply Nat.le_of_not_lt
          intro hlt
          have hq := place_of_match hends hm
          have h1 := hinv s' e' hlow hm
          -- The place of the other match is `p` or a later one.
          have h2 : p ≤ e' - c.width := by
            apply Nat.le_of_not_lt
            intro h
            exact c.place_first hplace h1 h hq.2.1
          cases Nat.lt_or_eq_of_le h2 with
          | inl hlt2 =>
            cases hearlier s0 (p + c.width) s' e' hb.2 hm (by omega) with
            | inl h => omega
            | inr h =>
              have := c.back_least hback hlow h
              omega
          | inr heq =>
            have he : e' = p + c.width := by omega
            have := c.back_least hback hlow (he ▸ hm)
            omega

/-- The wider rule: where every match ends with the literal and `NoEarlier` holds, the search
from the literal's places gives the matcher's answer from `low`. -/
theorem byRequired_answer {t : Text} {c : Scans t} {low : Nat}
    (hearlier : NoEarlier t) (hends : EndsWith t c) (hlow : low ≤ t.len) :
    IsAnswer t low (byRequired c low (t.len - low + 1) low) := by
  apply byRequired_from hearlier hends _ _ (by omega)
  intro s e hs hm
  have := (place_of_match hends hm).1
  omega

/-! ## The rules that give `NoEarlier` -/

/-- A byte of the literal that stands in no part of a match before the literal gives
`NoEarlier`. Claim R4's rule is this one, with the literal's first byte. -/
theorem noEarlier_of_clean {t : Text} {c : Scans t} {Mark : Nat → Prop}
    (hclean : CleanBefore t c Mark) (hgap : Gap c Mark) (hends : EndsWith t c) :
    NoEarlier t := by
  intro s e s' e' hm hm' hlt
  apply Or.inl
  apply Nat.le_of_not_lt
  intro hss
  have hq := place_of_match hends hm
  have hq' := place_of_match hends hm'
  have := ends_by_place hclean hgap hends hm' hq.2.1 (by omega)
  omega

/-- A pattern whose matches all have one length gives `NoEarlier`. -/
theorem noEarlier_of_one_length {t : Text} {n : Nat}
    (hlength : ∀ s e, t.Match s e → e = s + n) : NoEarlier t := by
  intro s e s' e' hm hm' hlt
  have := hlength s e hm
  have := hlength s' e' hm'
  exact Or.inl (by omega)

/-- A separator at the end of the part before the literal gives `NoEarlier`. `Sep q` holds where
the text's byte at `q` is of the separator's class. The part before the literal ends with a
separator, a separator in it has separators alone after it, and the literal's first byte is no
separator. -/
theorem noEarlier_of_last_separator {t : Text} {c : Scans t} {Sep : Nat → Prop}
    (hends : EndsWith t c)
    (hlast : ∀ s e, t.Match s e → s < e - c.width ∧ Sep (e - c.width - 1))
    (htail : ∀ s e, t.Match s e → ∀ q r, s ≤ q → q ≤ r → r < e - c.width → Sep q → Sep r)
    (hliteral : ∀ p, c.Stands p → ¬ Sep p) : NoEarlier t := by
  intro s e s' e' hm hm' hlt
  apply Or.inl
  apply Nat.le_of_not_lt
  intro hss
  have hq := place_of_match hends hm
  have hq' := place_of_match hends hm'
  have hl := hlast s e hm
  have hsep := htail s' e' hm' (e - c.width - 1) (e - c.width) (by omega) (by omega) (by omega) hl.2
  exact hliteral (e - c.width) hq.2.1 hsep

/-- A separator at the start of the part before the literal gives `NoEarlier`. A match is a head
and a rest: `Head s h` holds where the bytes from `s` up to `h` are the separators that start a
match, one or more, and `Rest h e` where the rest of a match, its literal included, stands from
`h` up to `e`. The rest holds no separator. -/
theorem noEarlier_of_first_separator {t : Text} {Sep : Nat → Prop} {Head Rest : Nat → Nat → Prop}
    (hsplit : ∀ s e, t.Match s e → ∃ h, Head s h ∧ Rest h e)
    (hjoin : ∀ s h e, Head s h → Rest h e → t.Match s e)
    (hhead : ∀ s h, Head s h → s < h ∧ ∀ q, s ≤ q → q < h → Sep q)
    (hrest : ∀ h e, Rest h e → h < e ∧ ∀ q, h ≤ q → q < e → ¬ Sep q) : NoEarlier t := by
  intro s e s' e' hm hm' hlt
  cases Nat.lt_or_ge s' s with
  | inr hge => exact Or.inl hge
  | inl hss =>
    apply Or.inr
    have ⟨h, hh, hr⟩ := hsplit s e hm
    have ⟨h', hh', hr'⟩ := hsplit s' e' hm'
    have a := hhead s h hh
    have a' := hhead s' h' hh'
    have b := hrest h e hr
    have b' := hrest h' e' hr'
    -- The inner match's first byte is a separator, so it stands in the outer match's head.
    have hsh : s < h' := by
      apply Nat.lt_of_not_le
      intro hle
      exact b'.2 s hle (by omega) (a.2 s (Nat.le_refl s) a.1)
    -- The two heads end at one offset: the first byte that is no separator.
    have heq : h = h' := by
      apply Nat.le_antisymm
      · apply Nat.le_of_not_lt
        intro hlt2
        exact b'.2 h' (Nat.le_refl h') b'.1 (a.2 h' (by omega) hlt2)
      · apply Nat.le_of_not_lt
        intro hlt2
        exact b.2 h (Nat.le_refl h) b.1 (a'.2 h (by omega) hlt2)
    exact hjoin s' h e (heq ▸ hh') hr

/-! ## The rules that need no forward scan

`Rising` is the stronger precondition, under which `bySuffix` gives the answer with no forward
scan (`bySuffix_rising`). Three of the four rules give it. The first separator does not: under
`\s+[a-z]{0,12}ing` the text of two spaces and `singing` holds a match from 0 up to 6 and one
from 0 up to 9, so one start has two ends, and that rule needs `byRequired`. -/

/-- `Rising` gives `NoEarlier`. -/
theorem noEarlier_of_rising {t : Text} (hrising : Rising t) : NoEarlier t :=
  fun s e s' e' hm hm' hlt => Or.inl (Nat.le_of_lt (hrising s e s' e' hm hm' hlt))

/-- A pattern whose matches all have one length gives `Rising`. -/
theorem rising_of_one_length {t : Text} {n : Nat}
    (hlength : ∀ s e, t.Match s e → e = s + n) : Rising t := by
  intro s e s' e' hm hm' hlt
  have := hlength s e hm
  have := hlength s' e' hm'
  omega

/-- A separator at the end of the part before the literal gives `Rising`, under the hypotheses
of `noEarlier_of_last_separator`. The literal's first byte alone must be no separator: the proof
reads no other byte of the literal. -/
theorem rising_of_last_separator {t : Text} {c : Scans t} {Sep : Nat → Prop}
    (hends : EndsWith t c)
    (hlast : ∀ s e, t.Match s e → s < e - c.width ∧ Sep (e - c.width - 1))
    (htail : ∀ s e, t.Match s e → ∀ q r, s ≤ q → q ≤ r → r < e - c.width → Sep q → Sep r)
    (hliteral : ∀ p, c.Stands p → ¬ Sep p) : Rising t := by
  intro s e s' e' hm hm' hlt
  apply Nat.lt_of_not_le
  intro hss
  have hq := place_of_match hends hm
  have hq' := place_of_match hends hm'
  have hl := hlast s e hm
  have hsep := htail s' e' hm' (e - c.width - 1) (e - c.width) (by omega) (by omega) (by omega) hl.2
  exact hliteral (e - c.width) hq.2.1 hsep

/-! ## The search without `NoEarlier` -/

/-- The matches of `(?:[a-z]|[0-9][a-z]ab)ab` in the text `1xabab`: the second alternative's from
0 up to 6, and the first alternative's from 1 up to 4, which lies inside it. -/
def nestedText : Text where
  len := 6
  Match s e := (s = 1 ∧ e = 4) ∨ (s = 0 ∧ e = 6)
  Prefers s e := (s = 1 ∧ e = 4) ∨ (s = 0 ∧ e = 6)
  inside := by intro s e h; omega
  prefers_match := fun h => h
  prefers_some := fun {_ e} h => ⟨e, h⟩
  prefers_one := by intro s e e' h h'; omega

/-- The scans of that text for the literal `ab`, which stands at 2 and at 4. -/
def nestedScans : Scans nestedText where
  width := 2
  Stands p := p = 2 ∨ p = 4
  place i := if i ≤ 2 then some 2 else if i ≤ 4 then some 4 else none
  back low e :=
    if e = 4 then (if low ≤ 1 then some 1 else none)
    else if e = 6 then (if low = 0 then some 0 else none)
    else none
  ahead s := if s = 0 then some 6 else if s = 1 then some 4 else none
  width_pos := by decide
  stands_inside := by intro p h; simp [nestedText]; omega
  place_some := by intro i p h; split at h <;> (try split at h) <;> simp at h <;> omega
  place_first := by intro i p q h; split at h <;> (try split at h) <;> simp at h <;> omega
  place_none := by intro i q h; split at h <;> (try split at h) <;> simp at h; omega
  back_some := by
    intro low e s h
    simp only [nestedText]
    split at h <;> (try split at h) <;> (try split at h) <;> simp at h <;> omega
  back_least := by
    intro low e s s' h hlow hm
    simp only [nestedText] at hm
    split at h <;> (try split at h) <;> (try split at h) <;> simp at h <;> omega
  back_none := by
    intro low e s h hlow
    simp only [nestedText]
    split at h <;> (try split at h) <;> (try split at h) <;> simp at h <;> omega
  ahead_some := by
    intro s e h
    simp only [nestedText]
    split at h <;> (try split at h) <;> simp at h <;> omega
  ahead_none := by
    intro s e h
    simp only [nestedText]
    split at h <;> (try split at h) <;> simp at h; omega

/-- The wider search needs `NoEarlier`. In `nestedText` every match ends with the literal, and
the search from the literal's first place gives the match from 1 up to 4, where the matcher gives
the match from 0 up to 6. -/
theorem needs_no_earlier :
    EndsWith nestedText nestedScans ∧
      byRequired nestedScans 0 (nestedText.len - 0 + 1) 0 = some (1, 4) ∧
      IsAnswer nestedText 0 (some (0, 6)) ∧
      ¬ IsAnswer nestedText 0 (some (1, 4)) ∧
      ¬ NoEarlier nestedText := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro s e h
    simp only [nestedText] at h
    simp only [nestedScans]
    omega
  · decide
  · refine ⟨Nat.le_refl 0, Or.inr ⟨rfl, rfl⟩, ?_⟩
    intro s' e' _ _
    exact Nat.zero_le s'
  · intro h
    have := h.2.2 0 6 (Nat.le_refl 0) (Or.inr ⟨rfl, rfl⟩)
    omega
  · intro h
    have := h 1 4 0 6 (Or.inl ⟨rfl, rfl⟩) (Or.inr ⟨rfl, rfl⟩) (by decide)
    simp only [nestedText] at this
    omega

/-! ## The guard changes no answer -/

/-- What a reverse scan with a guard gives: a start, no match, or no answer, where it would read
bytes that an earlier scan of the search read. -/
inductive Limited where
  /-- The least start of a match that ends at the scan's first offset. -/
  | found (start : Nat)
  /-- No match ends there. -/
  | none
  /-- The scan stopped at its floor: the search goes to the plain DFAs. -/
  | gaveUp

/-- A reverse scan with a guard: where it answers, it gives what `back` gives. -/
structure Guard {t : Text} (c : Scans t) where
  /-- The scan from `low`, with a floor, of the matches that end at an offset. -/
  scan : Nat → Nat → Nat → Limited
  /-- A start it gives is `back`'s. -/
  scan_found : ∀ {low floor e s}, scan low floor e = .found s → c.back low e = some s
  /-- Where it gives no match, `back` gives none. -/
  scan_none : ∀ {low floor e}, scan low floor e = .none → c.back low e = none

/-- `byRequired` with a guarded reverse scan, whose floor is the end of the place before. The
outer `none` says that a scan gave up. -/
def byGuarded {t : Text} {c : Scans t} (g : Guard c) (low : Nat) :
    Nat → Nat → Nat → Option (Option (Nat × Nat))
  | 0, _, _ => some none
  | turns + 1, index, floor =>
    match c.place index with
    | none => some none
    | some p =>
      match g.scan low floor (p + c.width) with
      | .gaveUp => none
      | .none => byGuarded g low turns (p + 1) (p + c.width)
      | .found s =>
        match c.ahead s with
        | none => some none
        | some e => some (some (s, e))

/-- Where the guarded search answers, its answer is the plain search's: the guard costs a search
its fast path at most, and never its answer. -/
theorem byGuarded_answer {t : Text} {c : Scans t} (g : Guard c) (low : Nat) :
    ∀ turns index floor a, byGuarded g low turns index floor = some a →
      byRequired c low turns index = a := by
  intro turns
  induction turns with
  | zero =>
    intro index floor a h
    simp [byGuarded] at h
    simp [byRequired, h]
  | succ turns ih =>
    intro index floor a h
    unfold byGuarded at h
    cases hplace : c.place index with
    | none =>
      simp [hplace] at h
      rw [byRequired_none hplace, h]
    | some p =>
      simp only [hplace] at h
      cases hscan : g.scan low floor (p + c.width) with
      | gaveUp => simp [hscan] at h
      | none =>
        simp only [hscan] at h
        rw [byRequired_next hplace (g.scan_none hscan)]
        exact ih (p + 1) (p + c.width) a h
      | found s =>
        simp only [hscan] at h
        have hback := g.scan_found hscan
        cases hahead : c.ahead s with
        | none =>
          simp [hahead] at h
          simp [byRequired, hplace, hback, hahead, h]
        | some e =>
          simp [hahead] at h
          rw [byRequired_found hplace hback hahead, h]

end Stdx.Regex.Search
