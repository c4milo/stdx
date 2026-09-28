/-!
# A number's text, RFC 8259 §6

The grammar of a number, transcribed from RFC 8259 §6, and the machine `src/json/number.zig`'s
`Number` runs, one octet at a time. The theorems hold the machine to the grammar (decision 28):

- `accepts_iff`: from the start, the machine takes every octet and ends in a whole number exactly
  on the texts the grammar derives, which is how the encoder checks a number's text;
- `refuses_iff`: it refuses an octet exactly when no number starts with the octets up to it;
- `ended_spec` and `invalid_spec`: what `Number.accept`'s verdicts tell the decoder, which ends a
  number at the first octet the machine does not take.

`Vectors.lean` writes every verdict of the machine, from every state, into
`src/json/number_vectors.txt`, which a Zig test replays against `Number.accept`.
-/
namespace Stdx.Json.Number

/-- `DIGIT = %x30-39`, RFC 5234 Appendix B.1's core rule. -/
def Digit (b : Nat) : Prop := 0x30 ≤ b ∧ b ≤ 0x39

instance (b : Nat) : Decidable (Digit b) := inferInstanceAs (Decidable (_ ∧ _))

/-- `*DIGIT` -/
inductive Digits : List Nat → Prop where
  /-- No digit. -/
  | nil : Digits []
  /-- A digit, then more. -/
  | cons {d : Nat} {r : List Nat} : Digit d → Digits r → Digits (d :: r)

/-- `1*DIGIT` -/
def Digits1 (l : List Nat) : Prop := ∃ d r, l = d :: r ∧ Digit d ∧ Digits r

/-- `int = zero / ( digit1-9 *DIGIT )`, with `zero = %x30` and `digit1-9 = %x31-39`. -/
inductive IntPart : List Nat → Prop where
  /-- `zero` -/
  | zero : IntPart [0x30]
  /-- `digit1-9 *DIGIT` -/
  | digits {d : Nat} {r : List Nat} : 0x31 ≤ d → d ≤ 0x39 → Digits r → IntPart (d :: r)

/-- `frac = decimal-point 1*DIGIT`, with `decimal-point = %x2E`. -/
def Frac (l : List Nat) : Prop := ∃ r, l = 0x2E :: r ∧ Digits1 r

/-- `e = %x65 / %x45` -/
def E (b : Nat) : Prop := b = 0x65 ∨ b = 0x45

/-- `minus = %x2D` or `plus = %x2B` -/
def Sign (b : Nat) : Prop := b = 0x2D ∨ b = 0x2B

instance (b : Nat) : Decidable (E b) := inferInstanceAs (Decidable (_ ∨ _))
instance (b : Nat) : Decidable (Sign b) := inferInstanceAs (Decidable (_ ∨ _))

/-- `exp = e [ minus / plus ] 1*DIGIT` -/
def Exp (l : List Nat) : Prop :=
  ∃ e r, l = e :: r ∧ E e ∧ (Digits1 r ∨ ∃ s r', r = s :: r' ∧ Sign s ∧ Digits1 r')

/-- `number = [ minus ] int [ frac ] [ exp ]` -/
def Number (l : List Nat) : Prop :=
  ∃ m i f x, l = m ++ i ++ f ++ x ∧ (m = [] ∨ m = [0x2D]) ∧ IntPart i ∧
    (f = [] ∨ Frac f) ∧ (x = [] ∨ Exp x)

/-- Where the machine stands after the octets it has taken: `number.zig`'s `State`, whose names
`State.name` gives. -/
inductive State where
  /-- No octet yet. -/
  | start
  /-- The minus sign. -/
  | minus
  /-- The integer part is a lone zero. -/
  | zero
  /-- The integer part has a digit from 1 to 9 and any digits after it. -/
  | integer
  /-- The decimal point. -/
  | point
  /-- The fraction has a digit or more. -/
  | fraction
  /-- The exponent's `e` or `E`. -/
  | exponentMark
  /-- The exponent's sign. -/
  | exponentSign
  /-- The exponent has a digit or more. -/
  | exponent
  deriving DecidableEq, Repr

/-- Every state, in the order `Vectors.lean` writes them. -/
def State.all : List State :=
  [.start, .minus, .zero, .integer, .point, .fraction, .exponentMark, .exponentSign, .exponent]

/-- A state's name in `number.zig`. -/
def State.name : State → String
  | .start => "start"
  | .minus => "minus"
  | .zero => "zero"
  | .integer => "integer"
  | .point => "point"
  | .fraction => "fraction"
  | .exponentMark => "exponent_mark"
  | .exponentSign => "exponent_sign"
  | .exponent => "exponent"

/-- One octet: the state after it, or none where the grammar cannot take it. -/
def step : State → Nat → Option State
  | .start, b =>
    if b = 0x30 then some .zero
    else if 0x31 ≤ b ∧ b ≤ 0x39 then some .integer
    else if b = 0x2D then some .minus
    else none
  | .minus, b =>
    if b = 0x30 then some .zero
    else if 0x31 ≤ b ∧ b ≤ 0x39 then some .integer
    else none
  | .zero, b =>
    if b = 0x2E then some .point
    else if E b then some .exponentMark
    else none
  | .integer, b =>
    if Digit b then some .integer
    else if b = 0x2E then some .point
    else if E b then some .exponentMark
    else none
  | .point, b => if Digit b then some .fraction else none
  | .fraction, b =>
    if Digit b then some .fraction
    else if E b then some .exponentMark
    else none
  | .exponentMark, b =>
    if Digit b then some .exponent
    else if Sign b then some .exponentSign
    else none
  | .exponentSign, b => if Digit b then some .exponent else none
  | .exponent, b => if Digit b then some .exponent else none

/-- True where the octets taken so far are a whole number. -/
def whole : State → Bool
  | .zero | .integer | .fraction | .exponent => true
  | _ => false

/-- The state after every octet of a text, or none when one is refused. -/
def run : State → List Nat → Option State
  | q, [] => some q
  | q, b :: l =>
    match step q b with
    | some q' => run q' l
    | none => none

/-- What `Number.accept` says of an octet. -/
inductive Verdict where
  /-- The octet belongs to the number, which goes on in the state given. -/
  | taken (q : State)
  /-- The number was whole before the octet, which belongs to what follows it. -/
  | ended
  /-- The octet cannot come next, and the number is not whole before it. -/
  | invalid
  deriving DecidableEq, Repr

/-- `Number.accept`: an octet's verdict. A digit after a lone zero is invalid rather than the start
of what follows: RFC 8259 §6 allows no leading zero, and a caller would otherwise see the number 0
where the text holds none. -/
def accept (q : State) (b : Nat) : Verdict :=
  if q = .zero ∧ Digit b then .invalid
  else
    match step q b with
    | some q' => .taken q'
    | none => if whole q then .ended else .invalid

/-- `[ frac ] [ exp ]` -/
def FracExp (l : List Nat) : Prop :=
  ∃ f x, l = f ++ x ∧ (f = [] ∨ Frac f) ∧ (x = [] ∨ Exp x)

/-- What may follow a state: the rest of a number the grammar derives. -/
def Lang : State → List Nat → Prop
  | .start, l => Number l
  | .minus, l => ∃ i t, l = i ++ t ∧ IntPart i ∧ FracExp t
  | .zero, l => FracExp l
  | .integer, l => ∃ ds t, l = ds ++ t ∧ Digits ds ∧ FracExp t
  | .point, l => ∃ ds x, l = ds ++ x ∧ Digits1 ds ∧ (x = [] ∨ Exp x)
  | .fraction, l => ∃ ds x, l = ds ++ x ∧ Digits ds ∧ (x = [] ∨ Exp x)
  | .exponentMark, l => Digits1 l ∨ ∃ s r, l = s :: r ∧ Sign s ∧ Digits1 r
  | .exponentSign, l => Digits1 l
  | .exponent, l => Digits l

/-- A list that starts with `b`, taken apart at `b`. -/
theorem exists_cons_iff {P : Nat → List Nat → Prop} {b : Nat} {l : List Nat} :
    (∃ x r, b :: l = x :: r ∧ P x r) ↔ P b l :=
  ⟨fun ⟨_, _, h, hp⟩ => (by cases h; exact hp), fun hp => ⟨b, l, rfl, hp⟩⟩

/-- Digits, taken apart at the first. -/
theorem digits_cons_iff {b : Nat} {l : List Nat} : Digits (b :: l) ↔ Digit b ∧ Digits l :=
  ⟨fun h => (by cases h; exact ⟨‹_›, ‹_›⟩), fun ⟨hb, hl⟩ => Digits.cons hb hl⟩

/-- `1*DIGIT` holds no empty list. -/
theorem not_digits1_nil : ¬ Digits1 [] := fun ⟨_, _, h, _⟩ => (by cases h)

/-- Digits, then something: either the list starts with a digit, or the digits are none. -/
theorem digits_prefix_cons {P : List Nat → Prop} {b : Nat} {l : List Nat} :
    (∃ ds t, b :: l = ds ++ t ∧ Digits ds ∧ P t) ↔
      (Digit b ∧ ∃ ds t, l = ds ++ t ∧ Digits ds ∧ P t) ∨ P (b :: l) := by
  constructor
  · rintro ⟨ds, t, h, hds, hp⟩
    cases ds with
    | nil =>
      simp only [List.nil_append] at h
      subst h
      exact Or.inr hp
    | cons d ds' =>
      simp only [List.cons_append, List.cons.injEq] at h
      obtain ⟨rfl, rfl⟩ := h
      rw [digits_cons_iff] at hds
      exact Or.inl ⟨hds.1, ds', t, rfl, hds.2, hp⟩
  · rintro (⟨hb, ds, t, rfl, hds, hp⟩ | hp)
    · exact ⟨b :: ds, t, rfl, Digits.cons hb hds, hp⟩
    · exact ⟨[], b :: l, rfl, Digits.nil, hp⟩

/-- `1*DIGIT`, then something, taken apart at the first digit. -/
theorem digits1_prefix_cons {P : List Nat → Prop} {b : Nat} {l : List Nat} :
    (∃ ds x, b :: l = ds ++ x ∧ Digits1 ds ∧ P x) ↔
      Digit b ∧ ∃ ds x, l = ds ++ x ∧ Digits ds ∧ P x := by
  constructor
  · rintro ⟨ds, x, h, ⟨d, r, rfl, hd, hr⟩, hp⟩
    simp only [List.cons_append, List.cons.injEq] at h
    obtain ⟨rfl, rfl⟩ := h
    exact ⟨hd, r, x, rfl, hr, hp⟩
  · rintro ⟨hb, ds, x, rfl, hds, hp⟩
    exact ⟨b :: ds, x, rfl, ⟨b, ds, rfl, hb, hds⟩, hp⟩

/-- `[ frac ] [ exp ]`, taken apart at its first octet: a decimal point or an exponent's mark. -/
theorem fracExp_cons {b : Nat} {l : List Nat} :
    FracExp (b :: l) ↔ (b = 0x2E ∧ Lang .point l) ∨ (E b ∧ Lang .exponentMark l) := by
  constructor
  · rintro ⟨f, x, h, hf, hx⟩
    rcases hf with rfl | ⟨r, rfl, hr⟩
    · simp only [List.nil_append] at h
      subst h
      rcases hx with hx | ⟨e, r, he, hE, hrest⟩
      · cases hx
      · simp only [List.cons.injEq] at he
        obtain ⟨rfl, rfl⟩ := he
        exact Or.inr ⟨hE, hrest⟩
    · simp only [List.cons_append, List.cons.injEq] at h
      obtain ⟨rfl, rfl⟩ := h
      exact Or.inl ⟨rfl, r, x, rfl, hr, hx⟩
  · rintro (⟨rfl, ds, x, rfl, hds, hx⟩ | ⟨hE, hl⟩)
    · exact ⟨0x2E :: ds, x, rfl, Or.inr ⟨ds, rfl, hds⟩, hx⟩
    · exact ⟨[], b :: l, rfl, Or.inl rfl, Or.inr ⟨b, l, rfl, hE, hl⟩⟩

/-- `int` and what follows it, taken apart at the integer part's first digit. -/
theorem minus_cons {b : Nat} {l : List Nat} :
    Lang .minus (b :: l) ↔
      (b = 0x30 ∧ Lang .zero l) ∨ ((0x31 ≤ b ∧ b ≤ 0x39) ∧ Lang .integer l) := by
  constructor
  · rintro ⟨i, t, h, hi, ht⟩
    cases hi with
    | zero =>
      simp only [List.cons_append, List.nil_append, List.cons.injEq] at h
      obtain ⟨rfl, rfl⟩ := h
      exact Or.inl ⟨rfl, ht⟩
    | digits hd hd' hr =>
      simp only [List.cons_append, List.cons.injEq] at h
      obtain ⟨rfl, rfl⟩ := h
      exact Or.inr ⟨⟨hd, hd'⟩, _, _, rfl, hr, ht⟩
  · rintro (⟨rfl, hl⟩ | ⟨⟨hd, hd'⟩, ds, t, rfl, hds, ht⟩)
    · exact ⟨[0x30], l, rfl, IntPart.zero, hl⟩
    · exact ⟨b :: ds, t, rfl, IntPart.digits hd hd' hds, ht⟩

/-- `number` with its optional parts regrouped: a sign or none, then what follows `minus`. -/
theorem number_iff {l : List Nat} :
    Number l ↔ ∃ m t, l = m ++ t ∧ (m = [] ∨ m = [0x2D]) ∧ Lang .minus t := by
  constructor
  · rintro ⟨m, i, f, x, rfl, hm, hi, hf, hx⟩
    exact ⟨m, i ++ (f ++ x), by simp [List.append_assoc], hm, i, f ++ x, rfl, hi, f, x, rfl, hf, hx⟩
  · rintro ⟨m, t, rfl, hm, i, t', rfl, hi, f, x, rfl, hf, hx⟩
    exact ⟨m, i, f, x, by simp [List.append_assoc], hm, hi, hf, hx⟩

/-- `number`, taken apart at its first octet: a minus sign, or the integer part's first digit. -/
theorem number_cons {b : Nat} {l : List Nat} :
    Number (b :: l) ↔ (b = 0x2D ∧ Lang .minus l) ∨ Lang .minus (b :: l) := by
  rw [number_iff]
  constructor
  · rintro ⟨m, t, h, hm | hm, ht⟩
    · subst hm
      simp only [List.nil_append] at h
      subst h
      exact Or.inr ht
    · subst hm
      simp only [List.cons_append, List.nil_append, List.cons.injEq] at h
      obtain ⟨rfl, rfl⟩ := h
      exact Or.inl ⟨rfl, ht⟩
  · rintro (⟨rfl, hl⟩ | hl)
    · exact ⟨[0x2D], l, rfl, Or.inr rfl, hl⟩
    · exact ⟨[], b :: l, rfl, Or.inl rfl, hl⟩

/-- What may follow each state, split at its first octet: the machine's step. -/
theorem lang_cons (q : State) (b : Nat) (l : List Nat) :
    Lang q (b :: l) ↔ ∃ q', step q b = some q' ∧ Lang q' l := by
  cases q with
  | start =>
    rw [show Lang .start (b :: l) = Number (b :: l) from rfl, number_cons, minus_cons]
    constructor
    · rintro (⟨rfl, h⟩ | ⟨rfl, h⟩ | ⟨hb, h⟩)
      · exact ⟨.minus, rfl, h⟩
      · exact ⟨.zero, rfl, h⟩
      · refine ⟨.integer, ?_, h⟩
        simp only [step]
        rw [ite_eq_right (by omega), ite_eq_left hb]
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact Or.inr (Or.inl ⟨hb, h⟩)
      split at hq
      · next hb => cases hq; exact Or.inr (Or.inr ⟨hb, h⟩)
      split at hq
      · next hb => cases hq; exact Or.inl ⟨hb, h⟩
      cases hq
  | minus =>
    rw [minus_cons]
    constructor
    · rintro (⟨rfl, h⟩ | ⟨hb, h⟩)
      · exact ⟨.zero, rfl, h⟩
      · refine ⟨.integer, ?_, h⟩
        simp only [step]
        rw [ite_eq_right (by omega), ite_eq_left hb]
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact Or.inl ⟨hb, h⟩
      split at hq
      · next hb => cases hq; exact Or.inr ⟨hb, h⟩
      cases hq
  | zero =>
    rw [show Lang .zero (b :: l) = FracExp (b :: l) from rfl, fracExp_cons]
    constructor
    · rintro (⟨rfl, h⟩ | ⟨hb, h⟩)
      · exact ⟨.point, rfl, h⟩
      · refine ⟨.exponentMark, ?_, h⟩
        simp only [step]
        rw [ite_eq_right (by unfold E at hb; omega), ite_eq_left hb]
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact Or.inl ⟨hb, h⟩
      split at hq
      · next hb => cases hq; exact Or.inr ⟨hb, h⟩
      cases hq
  | integer =>
    rw [show Lang .integer (b :: l) = ∃ ds t, b :: l = ds ++ t ∧ Digits ds ∧ FracExp t from rfl,
      digits_prefix_cons, fracExp_cons]
    constructor
    · rintro (⟨hb, h⟩ | ⟨rfl, h⟩ | ⟨hb, h⟩)
      · exact ⟨.integer, by simp only [step]; rw [ite_eq_left hb], h⟩
      · exact ⟨.point, rfl, h⟩
      · refine ⟨.exponentMark, ?_, h⟩
        simp only [step]
        rw [ite_eq_right (by unfold Digit E at *; omega), ite_eq_right (by unfold E at hb; omega),
          ite_eq_left hb]
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact Or.inl ⟨hb, h⟩
      split at hq
      · next hb => cases hq; exact Or.inr (Or.inl ⟨hb, h⟩)
      split at hq
      · next hb => cases hq; exact Or.inr (Or.inr ⟨hb, h⟩)
      cases hq
  | point =>
    rw [show Lang .point (b :: l) = ∃ ds x, b :: l = ds ++ x ∧ Digits1 ds ∧ (x = [] ∨ Exp x) from rfl,
      digits1_prefix_cons]
    constructor
    · rintro ⟨hb, h⟩
      exact ⟨.fraction, by simp only [step]; rw [ite_eq_left hb], h⟩
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact ⟨hb, h⟩
      cases hq
  | fraction =>
    rw [show Lang .fraction (b :: l) = ∃ ds x, b :: l = ds ++ x ∧ Digits ds ∧ (x = [] ∨ Exp x) from rfl,
      digits_prefix_cons]
    constructor
    · rintro (⟨hb, h⟩ | (h | ⟨e, r, he, hE, hrest⟩))
      · exact ⟨.fraction, by simp only [step]; rw [ite_eq_left hb], h⟩
      · cases h
      · simp only [List.cons.injEq] at he
        obtain ⟨rfl, rfl⟩ := he
        refine ⟨.exponentMark, ?_, hrest⟩
        simp only [step]
        rw [ite_eq_right (by unfold Digit E at *; omega), ite_eq_left hE]
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact Or.inl ⟨hb, h⟩
      split at hq
      · next hb => cases hq; exact Or.inr (Or.inr ⟨b, l, rfl, hb, h⟩)
      cases hq
  | exponentMark =>
    rw [show Lang .exponentMark (b :: l) =
      (Digits1 (b :: l) ∨ ∃ s r, b :: l = s :: r ∧ Sign s ∧ Digits1 r) from rfl]
    simp only [Digits1, exists_cons_iff]
    constructor
    · rintro (⟨hb, h⟩ | ⟨hb, h⟩)
      · exact ⟨.exponent, by simp only [step]; rw [ite_eq_left hb], h⟩
      · refine ⟨.exponentSign, ?_, h⟩
        simp only [step]
        rw [ite_eq_right (by unfold Digit Sign at *; omega), ite_eq_left hb]
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact Or.inl ⟨hb, h⟩
      split at hq
      · next hb => cases hq; exact Or.inr ⟨hb, h⟩
      cases hq
  | exponentSign =>
    rw [show Lang .exponentSign (b :: l) = Digits1 (b :: l) from rfl]
    simp only [Digits1, exists_cons_iff]
    constructor
    · rintro ⟨hb, h⟩
      exact ⟨.exponent, by simp only [step]; rw [ite_eq_left hb], h⟩
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact ⟨hb, h⟩
      cases hq
  | exponent =>
    rw [show Lang .exponent (b :: l) = Digits (b :: l) from rfl, digits_cons_iff]
    constructor
    · rintro ⟨hb, h⟩
      exact ⟨.exponent, by simp only [step]; rw [ite_eq_left hb], h⟩
    · rintro ⟨q', hq, h⟩
      simp only [step] at hq
      split at hq
      · next hb => cases hq; exact ⟨hb, h⟩
      cases hq

/-- What may follow each state holds the empty list exactly where the state is whole. -/
theorem lang_nil (q : State) : Lang q [] ↔ whole q = true := by
  cases q with
  | start =>
    simp only [Lang, whole]
    refine ⟨fun ⟨m, i, f, x, h, _, hi, _, _⟩ => ?_, fun h => nomatch h⟩
    cases hi <;> simp at h
  | minus =>
    simp only [Lang, whole]
    refine ⟨fun ⟨i, t, h, hi, _⟩ => ?_, fun h => nomatch h⟩
    cases hi <;> simp at h
  | zero => exact ⟨fun _ => rfl, fun _ => ⟨[], [], rfl, Or.inl rfl, Or.inl rfl⟩⟩
  | integer =>
    exact ⟨fun _ => rfl, fun _ => ⟨[], [], rfl, Digits.nil, [], [], rfl, Or.inl rfl, Or.inl rfl⟩⟩
  | point =>
    simp only [Lang, whole]
    refine ⟨fun ⟨ds, x, h, hds, _⟩ => ?_, fun h => nomatch h⟩
    obtain ⟨d, r, rfl, _, _⟩ := hds
    simp at h
  | fraction => exact ⟨fun _ => rfl, fun _ => ⟨[], [], rfl, Digits.nil, Or.inl rfl⟩⟩
  | exponentMark =>
    simp only [Lang, whole]
    refine ⟨fun h => ?_, fun h => nomatch h⟩
    rcases h with h | ⟨s, r, h, _⟩
    · exact absurd h not_digits1_nil
    · cases h
  | exponentSign =>
    simp only [Lang, whole]
    exact ⟨fun h => absurd h not_digits1_nil, fun h => nomatch h⟩
  | exponent => exact ⟨fun _ => rfl, fun _ => Digits.nil⟩

/-- From any state, the machine takes every octet and ends whole exactly on what may follow it. -/
theorem run_whole_iff (q : State) (l : List Nat) :
    (∃ q', run q l = some q' ∧ whole q' = true) ↔ Lang q l := by
  induction l generalizing q with
  | nil =>
    rw [lang_nil]
    exact ⟨fun ⟨_, h, hw⟩ => (by cases h; exact hw), fun hw => ⟨q, rfl, hw⟩⟩
  | cons b l ih =>
    rw [lang_cons]
    simp only [run]
    cases h : step q b with
    | none => simp
    | some q' => simp only [Option.some.injEq, exists_eq_left', ih]

/-- **The machine accepts exactly RFC 8259 §6's numbers**: from the start, it takes every octet of
a text and ends whole exactly on the texts `number` derives. -/
theorem accepts_iff (l : List Nat) :
    (∃ q, run .start l = some q ∧ whole q = true) ↔ Number l :=
  run_whole_iff .start l

/-- Running over two parts is running over the first, then the second. -/
theorem run_append (q : State) (l s : List Nat) :
    run q (l ++ s) = (run q l).bind (fun q' => run q' s) := by
  induction l generalizing q with
  | nil => simp [run]
  | cons b l ih =>
    simp only [List.cons_append, run]
    cases step q b <;> simp [ih]

/-- A shortest way from each state to a whole number. -/
def State.completion : State → List Nat
  | .start | .minus | .point | .exponentMark | .exponentSign => [0x30]
  | .zero | .integer | .fraction | .exponent => []

/-- Each state's completion makes a whole number. -/
theorem run_completion (q : State) : ∃ q', run q q.completion = some q' ∧ whole q' = true := by
  cases q with
  | start => exact ⟨.zero, rfl, rfl⟩
  | minus => exact ⟨.zero, rfl, rfl⟩
  | zero => exact ⟨.zero, rfl, rfl⟩
  | integer => exact ⟨.integer, rfl, rfl⟩
  | point => exact ⟨.fraction, rfl, rfl⟩
  | fraction => exact ⟨.fraction, rfl, rfl⟩
  | exponentMark => exact ⟨.exponent, rfl, rfl⟩
  | exponentSign => exact ⟨.exponent, rfl, rfl⟩
  | exponent => exact ⟨.exponent, rfl, rfl⟩

/-- **The machine refuses at the first octet that rules a number out**: it refuses the octets so
far exactly when no text `number` derives starts with them. -/
theorem refuses_iff (l : List Nat) : run .start l = none ↔ ¬ ∃ s, Number (l ++ s) := by
  constructor
  · rintro h ⟨s, hs⟩
    obtain ⟨q, hq, -⟩ := (accepts_iff _).mpr hs
    rw [run_append, h] at hq
    cases hq
  · intro h
    cases hr : run .start l with
    | none => rfl
    | some q =>
      exfalso
      apply h
      obtain ⟨q', hq', hw⟩ := run_completion q
      refine ⟨q.completion, (accepts_iff _).mp ⟨q', ?_, hw⟩⟩
      rw [run_append, hr]
      exact hq'

/-- `accept` takes an octet exactly where the machine steps on it. -/
theorem accept_taken (q q' : State) (b : Nat) : accept q b = .taken q' ↔ step q b = some q' := by
  unfold accept
  by_cases h : q = .zero ∧ Digit b
  · rw [ite_eq_left h]
    obtain ⟨rfl, hb⟩ := h
    simp only [step]
    rw [ite_eq_right (by unfold Digit at hb; omega), ite_eq_right (by unfold Digit E at *; omega)]
    simp
  · rw [ite_eq_right h]
    cases step q b with
    | some q'' => simp
    | none => cases whole q <;> simp

/-- What an octet `accept` does not take tells: the machine takes no step on it. -/
theorem step_none_of_not_taken {q : State} {b : Nat} (h : ∀ q', accept q b ≠ .taken q') :
    step q b = none := by
  cases hs : step q b with
  | none => rfl
  | some q' => exact absurd ((accept_taken q q' b).mpr hs) (h q')

/-- **An octet `accept` ends a number before** comes after one whole number, and no number goes
on with it. -/
theorem ended_spec {l : List Nat} {q : State} {b : Nat} (hl : run .start l = some q)
    (h : accept q b = .ended) : Number l ∧ ¬ ∃ s, Number (l ++ b :: s) := by
  have hstep : step q b = none := step_none_of_not_taken (fun q' hq => by rw [hq] at h; cases h)
  have hwhole : whole q = true := by
    unfold accept at h
    split at h
    · cases h
    · rw [hstep] at h
      cases hw : whole q
      · rw [hw] at h; cases h
      · rfl
  refine ⟨(accepts_iff l).mp ⟨q, hl, hwhole⟩, ?_⟩
  rintro ⟨s, hs⟩
  obtain ⟨q', hq', -⟩ := (accepts_iff _).mpr hs
  rw [run_append, hl] at hq'
  simp [run, hstep] at hq'

/-- **An octet `accept` refuses** leaves no number that goes on with the octets before it and it. -/
theorem invalid_spec {l : List Nat} {q : State} {b : Nat} (hl : run .start l = some q)
    (h : accept q b = .invalid) : ¬ ∃ s, Number (l ++ b :: s) := by
  have hstep : step q b = none := step_none_of_not_taken (fun q' hq => by rw [hq] at h; cases h)
  rintro ⟨s, hs⟩
  obtain ⟨q', hq', -⟩ := (accepts_iff _).mpr hs
  rw [run_append, hl] at hq'
  simp [run, hstep] at hq'

end Stdx.Json.Number
