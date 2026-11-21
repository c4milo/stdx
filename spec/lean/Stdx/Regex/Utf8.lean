import Stdx.Json.Utf8

/-!
# UTF-8 as ranges of octets, RFC 3629 §3 and §4

`src/regex/utf8.zig` writes a scalar value as octets, and cuts a range of scalar values into
sequences of octet ranges, which a program of `regex` takes one octet at a time (decision 86).
This file holds both as functions, and three theorems hold them to RFC 3629:

- `encode_char` and `char_encode`: `encode` writes exactly the sequences RFC 3629 §4's syntax
  derives, which `Stdx.Json.Utf8.Char` transcribes;
- `whole_iff`: a range that `step` cuts no further is one sequence of octet ranges, which holds
  the UTF-8 of each scalar value of the range and nothing else;
- `split_iff`: the sequences `split` gives for a range hold the UTF-8 of each scalar value of
  the range that is no surrogate, and nothing else.

`Vectors.lean` writes the sequences of the ranges between the values where an encoding changes
into `src/regex/utf8_split_vectors.txt`, which a Zig test replays against `utf8.Splitter`.

Scalar values and octets are natural numbers.
-/
namespace Stdx.Regex.Utf8

open Stdx.Json.Utf8 (Char Tail)

/-- A Unicode scalar value (RFC 3629 §3): at most U+10FFFF, and no surrogate. -/
def Scalar (v : Nat) : Prop := v ≤ 0x10FFFF ∧ ¬ (0xD800 ≤ v ∧ v ≤ 0xDFFF)

/-- The octets of a value (RFC 3629 §3): the first holds the length's mark and the highest bits,
and each after it `10` and the next six. -/
def encode (v : Nat) : List Nat :=
  if v ≤ 0x7F then [v]
  else if v ≤ 0x7FF then [0xC0 + v / 64, 0x80 + v % 64]
  else if v ≤ 0xFFFF then [0xE0 + v / 4096, 0x80 + v / 64 % 64, 0x80 + v % 64]
  else [0xF0 + v / 262144, 0x80 + v / 4096 % 64, 0x80 + v / 64 % 64, 0x80 + v % 64]

/-- `encode` of a value of one octet. -/
theorem encode_one {v : Nat} (h : v ≤ 0x7F) : encode v = [v] := by
  simp [encode, h]

/-- `encode` of a value of two octets. -/
theorem encode_two {v : Nat} (h1 : 0x7F < v) (h2 : v ≤ 0x7FF) :
    encode v = [0xC0 + v / 64, 0x80 + v % 64] := by
  have n1 : ¬ v ≤ 0x7F := by omega
  simp [encode, n1, h2]

/-- `encode` of a value of three octets. -/
theorem encode_three {v : Nat} (h1 : 0x7FF < v) (h2 : v ≤ 0xFFFF) :
    encode v = [0xE0 + v / 4096, 0x80 + v / 64 % 64, 0x80 + v % 64] := by
  have n1 : ¬ v ≤ 0x7F := by omega
  have n2 : ¬ v ≤ 0x7FF := by omega
  simp [encode, n1, n2, h2]

/-- `encode` of a value of four octets. -/
theorem encode_four {v : Nat} (h : 0xFFFF < v) :
    encode v = [0xF0 + v / 262144, 0x80 + v / 4096 % 64, 0x80 + v / 64 % 64, 0x80 + v % 64] := by
  have n1 : ¬ v ≤ 0x7F := by omega
  have n2 : ¬ v ≤ 0x7FF := by omega
  have n3 : ¬ v ≤ 0xFFFF := by omega
  simp [encode, n1, n2, n3]

/-- Two lists of two are equal when their members are. -/
theorem list_two {a b c d : Nat} (h1 : a = c) (h2 : b = d) : [a, b] = [c, d] := by
  rw [h1, h2]

/-- Two lists of three are equal when their members are. -/
theorem list_three {a b c d e f : Nat} (h1 : a = d) (h2 : b = e) (h3 : c = f) :
    [a, b, c] = [d, e, f] := by
  rw [h1, h2, h3]

/-- Two lists of four are equal when their members are. -/
theorem list_four {a b c d e f g h : Nat} (h1 : a = e) (h2 : b = f) (h3 : c = g) (h4 : d = h) :
    [a, b, c, d] = [e, f, g, h] := by
  rw [h1, h2, h3, h4]

/-- A continuation octet's six bits give a `UTF8-tail`. -/
theorem tail_mod (v : Nat) : Tail (0x80 + v % 64) := by
  unfold Tail; omega

/-- `encode` writes a sequence that RFC 3629 §4's syntax derives. -/
theorem encode_char {v : Nat} (h : Scalar v) : Char (encode v) := by
  obtain ⟨hmax, hsur⟩ := h
  by_cases h1 : v ≤ 0x7F
  · rw [encode_one h1]; exact Char.one h1
  by_cases h2 : v ≤ 0x7FF
  · rw [encode_two (by omega) h2]; exact Char.two (by omega) (by omega) (tail_mod v)
  by_cases h3 : v ≤ 0xFFFF
  · rw [encode_three (by omega) h3]
    by_cases hE0 : v / 4096 = 0
    · rw [hE0]; exact Char.e0 (by omega) (by omega) (tail_mod v)
    by_cases hED : v / 4096 = 13
    · rw [hED]; exact Char.ed (by omega) (by omega) (tail_mod v)
    by_cases hlow : v / 4096 ≤ 12
    · exact Char.e1ec (by omega) (by omega) (by unfold Tail; omega) (tail_mod v)
    · exact Char.eeef (by omega) (by omega) (by unfold Tail; omega) (tail_mod v)
  rw [encode_four (by omega)]
  by_cases hF0 : v / 262144 = 0
  · rw [hF0]; exact Char.f0 (by omega) (by omega) (by unfold Tail; omega) (tail_mod v)
  by_cases hF4 : v / 262144 = 4
  · rw [hF4]; exact Char.f4 (by omega) (by omega) (by unfold Tail; omega) (tail_mod v)
  · exact Char.f1f3 (by omega) (by omega) (by unfold Tail; omega) (by unfold Tail; omega)
      (tail_mod v)

/-- Every sequence RFC 3629 §4's syntax derives is `encode` of one scalar value. -/
theorem char_encode {l : List Nat} (h : Char l) : ∃ v, Scalar v ∧ encode v = l := by
  cases h with
  | @one a ha => exact ⟨a, ⟨by omega, by omega⟩, encode_one ha⟩
  | @two a b ha1 ha2 hb =>
    unfold Tail at hb
    refine ⟨(a - 0xC0) * 64 + (b - 0x80), ⟨by omega, by omega⟩, ?_⟩
    rw [encode_two (by omega) (by omega)]
    exact list_two (by omega) (by omega)
  | @e0 b c hb1 hb2 hc =>
    unfold Tail at hc
    refine ⟨(b - 0x80) * 64 + (c - 0x80), ⟨by omega, by omega⟩, ?_⟩
    rw [encode_three (by omega) (by omega)]
    exact list_three (by omega) (by omega) (by omega)
  | @e1ec a b c ha1 ha2 hb hc =>
    unfold Tail at hb hc
    refine ⟨(a - 0xE0) * 4096 + (b - 0x80) * 64 + (c - 0x80), ⟨by omega, by omega⟩, ?_⟩
    rw [encode_three (by omega) (by omega)]
    exact list_three (by omega) (by omega) (by omega)
  | @ed b c hb1 hb2 hc =>
    unfold Tail at hc
    refine ⟨13 * 4096 + (b - 0x80) * 64 + (c - 0x80), ⟨by omega, by omega⟩, ?_⟩
    rw [encode_three (by omega) (by omega)]
    exact list_three (by omega) (by omega) (by omega)
  | @eeef a b c ha1 ha2 hb hc =>
    unfold Tail at hb hc
    refine ⟨(a - 0xE0) * 4096 + (b - 0x80) * 64 + (c - 0x80), ⟨by omega, by omega⟩, ?_⟩
    rw [encode_three (by omega) (by omega)]
    exact list_three (by omega) (by omega) (by omega)
  | @f0 b c d hb1 hb2 hc hd =>
    unfold Tail at hc hd
    refine ⟨(b - 0x80) * 4096 + (c - 0x80) * 64 + (d - 0x80), ⟨by omega, by omega⟩, ?_⟩
    rw [encode_four (by omega)]
    exact list_four (by omega) (by omega) (by omega) (by omega)
  | @f1f3 a b c d ha1 ha2 hb hc hd =>
    unfold Tail at hb hc hd
    refine ⟨(a - 0xF0) * 262144 + (b - 0x80) * 4096 + (c - 0x80) * 64 + (d - 0x80),
      ⟨by omega, by omega⟩, ?_⟩
    rw [encode_four (by omega)]
    exact list_four (by omega) (by omega) (by omega) (by omega)
  | @f4 b c d hb1 hb2 hc hd =>
    unfold Tail at hc hd
    refine ⟨4 * 262144 + (b - 0x80) * 4096 + (c - 0x80) * 64 + (d - 0x80),
      ⟨by omega, by omega⟩, ?_⟩
    rw [encode_four (by omega)]
    exact list_four (by omega) (by omega) (by omega) (by omega)

/-- At a width of `m` values, two values agree above it, or the first is all zeros below it and
the last all ones: what `utf8.zig`'s `cut_continuation` leaves of a range. -/
def Aligned (m lo hi : Nat) : Prop := lo / m = hi / m ∨ (lo % m = 0 ∧ hi % m = m - 1)

/-- A range of values of two octets that is aligned holds exactly the values whose two octets
lie between the octets of its ends. -/
theorem two_iff {lo hi a b : Nat} (hlo : 0x7F < lo) (h1 : Aligned 64 lo hi) :
    (0xC0 + lo / 64 ≤ a ∧ a ≤ 0xC0 + hi / 64 ∧ 0x80 + lo % 64 ≤ b ∧ b ≤ 0x80 + hi % 64) ↔
      ∃ v, lo ≤ v ∧ v ≤ hi ∧ a = 0xC0 + v / 64 ∧ b = 0x80 + v % 64 := by
  unfold Aligned at h1
  constructor
  · intro h
    refine ⟨(a - 0xC0) * 64 + (b - 0x80), ?_, ?_, ?_, ?_⟩ <;> omega
  · rintro ⟨v, hv1, hv2, rfl, rfl⟩
    omega

/-- The same of three octets. -/
theorem three_iff {lo hi a b c : Nat} (hlo : 0x7FF < lo)
    (h1 : Aligned 64 lo hi) (h2 : Aligned 4096 lo hi) :
    (0xE0 + lo / 4096 ≤ a ∧ a ≤ 0xE0 + hi / 4096 ∧
      0x80 + lo / 64 % 64 ≤ b ∧ b ≤ 0x80 + hi / 64 % 64 ∧
      0x80 + lo % 64 ≤ c ∧ c ≤ 0x80 + hi % 64) ↔
      ∃ v, lo ≤ v ∧ v ≤ hi ∧ a = 0xE0 + v / 4096 ∧ b = 0x80 + v / 64 % 64 ∧ c = 0x80 + v % 64 := by
  unfold Aligned at h1 h2
  constructor
  · intro h
    refine ⟨(a - 0xE0) * 4096 + (b - 0x80) * 64 + (c - 0x80), ?_, ?_, ?_, ?_, ?_⟩ <;> omega
  · rintro ⟨v, hv1, hv2, rfl, rfl, rfl⟩
    omega

/-- A value as four digits of six bits, and each part of it that `Aligned` reads. -/
theorem digits (n : Nat) :
    n = n / 262144 * 262144 + n / 4096 % 64 * 4096 + n / 64 % 64 * 64 + n % 64 ∧
      n / 4096 % 64 < 64 ∧ n / 64 % 64 < 64 ∧ n % 64 < 64 ∧
      n / 64 = n / 262144 * 4096 + n / 4096 % 64 * 64 + n / 64 % 64 ∧
      n / 4096 = n / 262144 * 64 + n / 4096 % 64 ∧
      n % 4096 = n / 64 % 64 * 64 + n % 64 ∧
      n % 262144 = n / 4096 % 64 * 4096 + n / 64 % 64 * 64 + n % 64 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- The same of four octets. The proof names each value's digits, so that what is left is
linear in them. -/
theorem four_iff {lo hi a b c d : Nat}
    (h1 : Aligned 64 lo hi) (h2 : Aligned 4096 lo hi) (h3 : Aligned 262144 lo hi) :
    (0xF0 + lo / 262144 ≤ a ∧ a ≤ 0xF0 + hi / 262144 ∧
      0x80 + lo / 4096 % 64 ≤ b ∧ b ≤ 0x80 + hi / 4096 % 64 ∧
      0x80 + lo / 64 % 64 ≤ c ∧ c ≤ 0x80 + hi / 64 % 64 ∧
      0x80 + lo % 64 ≤ d ∧ d ≤ 0x80 + hi % 64) ↔
      ∃ v, lo ≤ v ∧ v ≤ hi ∧ a = 0xF0 + v / 262144 ∧ b = 0x80 + v / 4096 % 64 ∧
        c = 0x80 + v / 64 % 64 ∧ d = 0x80 + v % 64 := by
  unfold Aligned at h1 h2 h3
  obtain ⟨el, lb4, lc4, ld4, l64, l4096, lr4096, lr262144⟩ := digits lo
  obtain ⟨eh, hb4, hc4, hd4, h64, h4096, hr4096, hr262144⟩ := digits hi
  rw [l64, h64] at h1
  rw [l4096, h4096, lr4096, hr4096] at h2
  rw [lr262144, hr262144] at h3
  clear l64 h64 l4096 h4096 lr4096 hr4096 lr262144 hr262144
  generalize lo / 262144 = la at *
  generalize lo / 4096 % 64 = lb at *
  generalize lo / 64 % 64 = lc at *
  generalize lo % 64 = ld at *
  generalize hi / 262144 = ha at *
  generalize hi / 4096 % 64 = hb at *
  generalize hi / 64 % 64 = hc at *
  generalize hi % 64 = hd at *
  constructor
  · intro h
    refine ⟨(a - 0xF0) * 262144 + (b - 0x80) * 4096 + (c - 0x80) * 64 + (d - 0x80),
      ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega
  · rintro ⟨v, hv1, hv2, rfl, rfl, rfl, rfl⟩
    obtain ⟨ev, vb4, vc4, vd4, -, -, -, -⟩ := digits v
    generalize v / 262144 = va at *
    generalize v / 4096 % 64 = vb at *
    generalize v / 64 % 64 = vc at *
    generalize v % 64 = vd at *
    omega

/-- Octets that fall in a sequence of octet ranges: as many as the ranges, each in its own. -/
def Within : List (Nat × Nat) → List Nat → Prop
  | [], [] => True
  | (lo, hi) :: ranges, b :: octets => lo ≤ b ∧ b ≤ hi ∧ Within ranges octets
  | _, _ => False

/-- The octet ranges between the octets of two values, as `utf8.zig`'s `sequence_of` gives
them. -/
def sequence (lo hi : Nat) : List (Nat × Nat) := (encode lo).zip (encode hi)

/-- A range `cut` leaves whole: its values take one length, and it is aligned at each
continuation octet of that length. -/
def Whole (lo hi : Nat) : Prop :=
  lo ≤ hi ∧
    (hi ≤ 0x7F ∨
      (0x7F < lo ∧ hi ≤ 0x7FF ∧ Aligned 64 lo hi) ∨
      (0x7FF < lo ∧ hi ≤ 0xFFFF ∧ Aligned 64 lo hi ∧ Aligned 4096 lo hi) ∨
      (0xFFFF < lo ∧ Aligned 64 lo hi ∧ Aligned 4096 lo hi ∧ Aligned 262144 lo hi))

/-- A whole range of one octet is its one octet range. -/
theorem whole_one {lo hi : Nat} (hle : lo ≤ hi) (hhi : hi ≤ 0x7F) (l : List Nat) :
    Within (sequence lo hi) l ↔ ∃ v, lo ≤ v ∧ v ≤ hi ∧ l = encode v := by
  rw [sequence, encode_one (by omega : lo ≤ 0x7F), encode_one hhi]
  constructor
  · intro h
    match l, h with
    | [a], h =>
      simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true] at h
      exact ⟨a, h.1, h.2, (encode_one (by omega)).symm⟩
  · rintro ⟨v, hv1, hv2, rfl⟩
    rw [encode_one (by omega)]
    simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true]
    exact ⟨hv1, hv2⟩

/-- A whole range of two octets is its two octet ranges. -/
theorem whole_two {lo hi : Nat} (hle : lo ≤ hi) (hlo : 0x7F < lo) (hhi : hi ≤ 0x7FF)
    (h1 : Aligned 64 lo hi) (l : List Nat) :
    Within (sequence lo hi) l ↔ ∃ v, lo ≤ v ∧ v ≤ hi ∧ l = encode v := by
  rw [sequence, encode_two hlo (by omega), encode_two (by omega) hhi]
  constructor
  · intro h
    match l, h with
    | [a, b], h =>
      simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true] at h
      obtain ⟨v, hv1, hv2, rfl, rfl⟩ := (two_iff hlo h1).mp ⟨h.1, h.2.1, h.2.2.1, h.2.2.2⟩
      exact ⟨v, hv1, hv2, (encode_two (by omega) (by omega)).symm⟩
  · rintro ⟨v, hv1, hv2, rfl⟩
    rw [encode_two (by omega) (by omega)]
    simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true]
    exact (two_iff hlo h1).mpr ⟨v, hv1, hv2, rfl, rfl⟩

/-- A whole range of three octets is its three octet ranges. -/
theorem whole_three {lo hi : Nat} (hle : lo ≤ hi) (hlo : 0x7FF < lo) (hhi : hi ≤ 0xFFFF)
    (h1 : Aligned 64 lo hi) (h2 : Aligned 4096 lo hi) (l : List Nat) :
    Within (sequence lo hi) l ↔ ∃ v, lo ≤ v ∧ v ≤ hi ∧ l = encode v := by
  rw [sequence, encode_three hlo (by omega), encode_three (by omega) hhi]
  constructor
  · intro h
    match l, h with
    | [a, b, c], h =>
      simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true] at h
      obtain ⟨v, hv1, hv2, rfl, rfl, rfl⟩ :=
        (three_iff hlo h1 h2).mp ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1, h.2.2.2.2.1, h.2.2.2.2.2⟩
      exact ⟨v, hv1, hv2, (encode_three (by omega) (by omega)).symm⟩
  · rintro ⟨v, hv1, hv2, rfl⟩
    rw [encode_three (by omega) (by omega)]
    simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true]
    exact (three_iff hlo h1 h2).mpr ⟨v, hv1, hv2, rfl, rfl, rfl⟩

/-- A whole range of four octets is its four octet ranges. -/
theorem whole_four {lo hi : Nat} (hle : lo ≤ hi) (hlo : 0xFFFF < lo)
    (h1 : Aligned 64 lo hi) (h2 : Aligned 4096 lo hi) (h3 : Aligned 262144 lo hi) (l : List Nat) :
    Within (sequence lo hi) l ↔ ∃ v, lo ≤ v ∧ v ≤ hi ∧ l = encode v := by
  rw [sequence, encode_four hlo, encode_four (by omega : 0xFFFF < hi)]
  constructor
  · intro h
    match l, h with
    | [a, b, c, d], h =>
      simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true] at h
      obtain ⟨v, hv1, hv2, rfl, rfl, rfl, rfl⟩ :=
        (four_iff h1 h2 h3).mp
          ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1, h.2.2.2.2.1, h.2.2.2.2.2.1, h.2.2.2.2.2.2.1,
            h.2.2.2.2.2.2.2⟩
      exact ⟨v, hv1, hv2, (encode_four (by omega)).symm⟩
  · rintro ⟨v, hv1, hv2, rfl⟩
    rw [encode_four (by omega)]
    simp only [List.zip_cons_cons, List.zip_nil_right, Within, and_true]
    exact (four_iff h1 h2 h3).mpr ⟨v, hv1, hv2, rfl, rfl, rfl, rfl⟩

/-- A whole range is one sequence of octet ranges, which holds the UTF-8 of each value of the
range and nothing else. -/
theorem whole_iff {lo hi : Nat} (h : Whole lo hi) (l : List Nat) :
    Within (sequence lo hi) l ↔ ∃ v, lo ≤ v ∧ v ≤ hi ∧ l = encode v := by
  obtain ⟨hle, hone | ⟨hlo, hhi, h1⟩ | ⟨hlo, hhi, h1, h2⟩ | ⟨hlo, h1, h2, h3⟩⟩ := h
  · exact whole_one hle hone l
  · exact whole_two hle hlo hhi h1 l
  · exact whole_three hle hlo hhi h1 h2 l
  · exact whole_four hle hlo h1 h2 h3 l

/-- What one pass of `utf8.zig`'s `Splitter.cut` loop leaves of a range. -/
inductive Cut where
  /-- The range holds no scalar value. -/
  | none
  /-- The range, without the surrogates at its ends, is one sequence. -/
  | whole (lo hi : Nat)
  /-- The part kept, and the part put by for later. -/
  | parts (lo hi lo' hi' : Nat)

/-- A range's first value, moved past the surrogates where it is one (`cut_surrogates`). -/
def clampLo (lo : Nat) : Nat := if 0xD800 ≤ lo ∧ lo ≤ 0xDFFF then 0xE000 else lo

/-- A range's last value, moved before the surrogates where it is one (`cut_surrogates`). -/
def clampHi (hi : Nat) : Nat := if 0xD800 ≤ hi ∧ hi ≤ 0xDFFF then 0xD7FF else hi

/-- `cut_continuation` at a width of `m` values: the two parts of a range that is not aligned
there. -/
def alignCut (m lo hi : Nat) : Option (Nat × Nat × Nat × Nat) :=
  if lo / m = hi / m then Option.none
  else if lo % m ≠ 0 then some (lo, lo / m * m + (m - 1), (lo / m + 1) * m, hi)
  else if hi % m ≠ m - 1 then some (lo, hi / m * m - 1, hi / m * m, hi)
  else Option.none

/-- The parts `alignCut` gives, or the range whole. -/
def alignOr (m lo hi : Nat) (otherwise : Cut) : Cut :=
  match alignCut m lo hi with
  | some (a, b, c, d) => .parts a b c d
  | Option.none => otherwise

/-- `cut_continuation` for a range of one length: each width of that length in turn. -/
def continuationCut (lo hi : Nat) : Cut :=
  if hi ≤ 0x7F then .whole lo hi
  else alignOr 64 lo hi
    (if hi ≤ 0x7FF then .whole lo hi
     else alignOr 4096 lo hi
       (if hi ≤ 0xFFFF then .whole lo hi else alignOr 262144 lo hi (.whole lo hi)))

/-- `cut_length`, then `cut_continuation`, for a range with no surrogate at either end. -/
def lengthCut (lo hi : Nat) : Cut :=
  if lo ≤ 0x7F ∧ 0x7F < hi then .parts lo 0x7F 0x80 hi
  else if lo ≤ 0x7FF ∧ 0x7FF < hi then .parts lo 0x7FF 0x800 hi
  else if lo ≤ 0xFFFF ∧ 0xFFFF < hi then .parts lo 0xFFFF 0x10000 hi
  else continuationCut lo hi

/-- One pass of the loop: the surrogates first, then the lengths, then the continuation
octets. -/
def cut (lo hi : Nat) : Cut :=
  if lo < 0xD800 ∧ 0xDFFF < hi then .parts lo 0xD7FF 0xE000 hi
  else if clampHi hi < clampLo lo then .none
  else lengthCut (clampLo lo) (clampHi hi)

/-- The sequences of a range, in rising order, as `Splitter.next` gives them one by one. `fuel`
bounds the passes: a range of `n` values takes at most `n`. -/
def split : Nat → Nat → Nat → List (List (Nat × Nat))
  | 0, _, _ => []
  | fuel + 1, lo, hi =>
    match cut lo hi with
    | .none => []
    | .whole a b => [sequence a b]
    | .parts a b c d => split fuel a b ++ split fuel c d

/-- What a pass leaves, said of the values: the scalar values of the range are those of the
whole range it gives, or those of its two parts, each a shorter range inside it. -/
def CutSpec (lo hi : Nat) : Cut → Prop
  | .none => ∀ v, lo ≤ v → v ≤ hi → ¬ Scalar v
  | .whole a b => Whole a b ∧ ∀ v, (lo ≤ v ∧ v ≤ hi ∧ Scalar v) ↔ (a ≤ v ∧ v ≤ b)
  | .parts a b c d =>
    lo ≤ a ∧ a ≤ b ∧ b < c ∧ c ≤ d ∧ d ≤ hi ∧
      ∀ v, (lo ≤ v ∧ v ≤ hi ∧ Scalar v) ↔ ((a ≤ v ∧ v ≤ b) ∨ (c ≤ v ∧ v ≤ d)) ∧ Scalar v

/-- `alignCut` gives no parts exactly where the range is aligned. -/
theorem alignCut_none {m lo hi : Nat} (h : alignCut m lo hi = Option.none) : Aligned m lo hi := by
  unfold alignCut at h
  unfold Aligned
  split at h
  · exact Or.inl (by assumption)
  · split at h
    · cases h
    · split at h
      · cases h
      · exact Or.inr ⟨by omega, by omega⟩

/-- The parts `alignCut` gives are the range's two ends, the second where the first stops. -/
theorem alignCut_some {m lo hi a b c d : Nat} (hm : m = 64 ∨ m = 4096 ∨ m = 262144)
    (hle : lo ≤ hi) (h : alignCut m lo hi = some (a, b, c, d)) :
    a = lo ∧ d = hi ∧ lo ≤ b ∧ b + 1 = c ∧ c ≤ hi := by
  unfold alignCut at h
  rcases hm with rfl | rfl | rfl <;>
  · split at h
    · cases h
    · split at h
      · simp only [Option.some.injEq, Prod.mk.injEq] at h
        omega
      · split at h
        · simp only [Option.some.injEq, Prod.mk.injEq] at h
          omega
        · cases h

/-- Where `alignCut` gives no parts, `alignOr` gives what it was told to. -/
theorem alignOr_none {m lo hi : Nat} {otherwise : Cut} (h : alignCut m lo hi = Option.none) :
    alignOr m lo hi otherwise = otherwise := by
  unfold alignOr; rw [h]

/-- Where `alignCut` gives parts, `alignOr` gives them. -/
theorem alignOr_some {m lo hi a b c d : Nat} {otherwise : Cut}
    (h : alignCut m lo hi = some (a, b, c, d)) : alignOr m lo hi otherwise = .parts a b c d := by
  unfold alignOr; rw [h]

/-- What a pass leaves of a range with no surrogate at either end: the range whole, or its two
ends as parts that meet. -/
def Plain (lo hi : Nat) : Cut → Prop
  | .none => False
  | .whole a b => Whole a b ∧ a = lo ∧ b = hi
  | .parts a b c d => a = lo ∧ d = hi ∧ lo ≤ b ∧ b + 1 = c ∧ c ≤ hi

/-- The values of a range take one length. -/
def SameLength (lo hi : Nat) : Prop :=
  hi ≤ 0x7F ∨ (0x7F < lo ∧ hi ≤ 0x7FF) ∨ (0x7FF < lo ∧ hi ≤ 0xFFFF) ∨ 0xFFFF < lo

/-- One width of `continuationCut`: parts, or the range aligned there and the rest to judge. -/
theorem alignOr_plain {m lo hi : Nat} {otherwise : Cut} (hm : m = 64 ∨ m = 4096 ∨ m = 262144)
    (hle : lo ≤ hi) (rest : Aligned m lo hi → Plain lo hi otherwise) :
    Plain lo hi (alignOr m lo hi otherwise) := by
  cases hcut : alignCut m lo hi with
  | none => rw [alignOr_none hcut]; exact rest (alignCut_none hcut)
  | some parts =>
    obtain ⟨a, b, c, d⟩ := parts
    rw [alignOr_some hcut]
    exact alignCut_some hm hle hcut

/-- `continuationCut` gives a range of one length whole only where it is aligned at each of its
continuation octets, and otherwise its two ends. -/
theorem continuationCut_plain {lo hi : Nat} (hle : lo ≤ hi) (hsame : SameLength lo hi) :
    Plain lo hi (continuationCut lo hi) := by
  unfold SameLength at hsame
  unfold continuationCut
  by_cases h1 : hi ≤ 0x7F
  · simp only [h1, ↓reduceIte]
    exact ⟨⟨hle, Or.inl h1⟩, rfl, rfl⟩
  simp only [h1, ↓reduceIte]
  refine alignOr_plain (Or.inl rfl) hle fun a1 => ?_
  by_cases h2 : hi ≤ 0x7FF
  · simp only [h2, ↓reduceIte]
    exact ⟨⟨hle, Or.inr (Or.inl ⟨by omega, h2, a1⟩)⟩, rfl, rfl⟩
  simp only [h2, ↓reduceIte]
  refine alignOr_plain (Or.inr (Or.inl rfl)) hle fun a2 => ?_
  by_cases h3 : hi ≤ 0xFFFF
  · simp only [h3, ↓reduceIte]
    exact ⟨⟨hle, Or.inr (Or.inr (Or.inl ⟨by omega, h3, a1, a2⟩))⟩, rfl, rfl⟩
  simp only [h3, ↓reduceIte]
  refine alignOr_plain (Or.inr (Or.inr rfl)) hle fun a3 => ?_
  exact ⟨⟨hle, Or.inr (Or.inr (Or.inr ⟨by omega, a1, a2, a3⟩))⟩, rfl, rfl⟩

/-- `lengthCut` gives a range whole only where `Whole` holds, and otherwise its two ends. -/
theorem lengthCut_plain {lo hi : Nat} (hle : lo ≤ hi) : Plain lo hi (lengthCut lo hi) := by
  unfold lengthCut
  by_cases h1 : lo ≤ 0x7F ∧ 0x7F < hi
  · simp only [h1, and_self, ↓reduceIte]
    exact ⟨rfl, rfl, by omega, by omega, by omega⟩
  simp only [h1, ↓reduceIte]
  by_cases h2 : lo ≤ 0x7FF ∧ 0x7FF < hi
  · simp only [h2, and_self, ↓reduceIte]
    exact ⟨rfl, rfl, by omega, by omega, by omega⟩
  simp only [h2, ↓reduceIte]
  by_cases h3 : lo ≤ 0xFFFF ∧ 0xFFFF < hi
  · simp only [h3, and_self, ↓reduceIte]
    exact ⟨rfl, rfl, by omega, by omega, by omega⟩
  simp only [h3, ↓reduceIte]
  exact continuationCut_plain hle (by unfold SameLength; omega)

/-- A first value after `clampLo`: itself, or U+E000 where it was a surrogate. -/
theorem clampLo_spec (lo : Nat) :
    (clampLo lo = lo ∧ ¬ (0xD800 ≤ lo ∧ lo ≤ 0xDFFF)) ∨
      (clampLo lo = 0xE000 ∧ 0xD800 ≤ lo ∧ lo ≤ 0xDFFF) := by
  unfold clampLo
  split <;> omega

/-- A last value after `clampHi`: itself, or U+D7FF where it was a surrogate. -/
theorem clampHi_spec (hi : Nat) :
    (clampHi hi = hi ∧ ¬ (0xD800 ≤ hi ∧ hi ≤ 0xDFFF)) ∨
      (clampHi hi = 0xD7FF ∧ 0xD800 ≤ hi ∧ hi ≤ 0xDFFF) := by
  unfold clampHi
  split <;> omega

/-- One pass leaves the scalar values of its range, and no other value. -/
theorem cut_spec {lo hi : Nat} (hle : lo ≤ hi) (hmax : hi ≤ 0x10FFFF) :
    CutSpec lo hi (cut lo hi) := by
  unfold cut
  by_cases hs : lo < 0xD800 ∧ 0xDFFF < hi
  · simp only [hs, and_self, ↓reduceIte]
    refine ⟨by omega, by omega, by omega, by omega, by omega, fun v => ?_⟩
    unfold Scalar
    omega
  simp only [hs, ↓reduceIte]
  have cl := clampLo_spec lo
  have ch := clampHi_spec hi
  generalize clampLo lo = lo' at *
  generalize clampHi hi = hi' at *
  by_cases he : hi' < lo'
  · simp only [he, ↓reduceIte]
    intro v hv1 hv2
    unfold Scalar
    omega
  simp only [he, ↓reduceIte]
  have plain := lengthCut_plain (by omega : lo' ≤ hi')
  cases hcut : lengthCut lo' hi' with
  | none => rw [hcut] at plain; exact plain.elim
  | whole a b =>
    rw [hcut] at plain
    obtain ⟨hw, rfl, rfl⟩ := plain
    refine ⟨hw, fun v => ?_⟩
    unfold Scalar
    omega
  | parts a b c d =>
    rw [hcut] at plain
    obtain ⟨rfl, rfl, h1, h2, h3⟩ := plain
    refine ⟨by omega, by omega, by omega, by omega, by omega, fun v => ?_⟩
    unfold Scalar
    omega

/-- The sequences `split` gives for a range hold the UTF-8 of each scalar value of the range,
and nothing else. -/
theorem split_iff (fuel : Nat) : ∀ (lo hi : Nat), hi - lo < fuel → lo ≤ hi → hi ≤ 0x10FFFF →
    ∀ l : List Nat, (∃ s, s ∈ split fuel lo hi ∧ Within s l) ↔
      ∃ v, lo ≤ v ∧ v ≤ hi ∧ Scalar v ∧ l = encode v := by
  induction fuel with
  | zero => intro lo hi hfuel; omega
  | succ fuel ih =>
    intro lo hi hfuel hle hmax l
    have spec := cut_spec hle hmax
    unfold split
    cases hcut : cut lo hi with
    | none =>
      rw [hcut] at spec
      simp only [List.not_mem_nil, false_and, exists_false, false_iff]
      rintro ⟨v, hv1, hv2, hv, -⟩
      exact spec v hv1 hv2 hv
    | whole a b =>
      rw [hcut] at spec
      obtain ⟨hw, hv⟩ := spec
      simp only [List.mem_singleton, exists_eq_left]
      rw [whole_iff hw]
      constructor
      · rintro ⟨v, hv1, hv2, rfl⟩
        obtain ⟨h1, h2, h3⟩ := (hv v).mpr ⟨hv1, hv2⟩
        exact ⟨v, h1, h2, h3, rfl⟩
      · rintro ⟨v, hv1, hv2, hv3, rfl⟩
        obtain ⟨h1, h2⟩ := (hv v).mp ⟨hv1, hv2, hv3⟩
        exact ⟨v, h1, h2, rfl⟩
    | parts a b c d =>
      rw [hcut] at spec
      obtain ⟨h1, h2, h3, h4, h5, hv⟩ := spec
      have first := ih a b (by omega) h2 (by omega) l
      have second := ih c d (by omega) h4 (by omega) l
      simp only [List.mem_append]
      constructor
      · rintro ⟨s, hs | hs, hw⟩
        · obtain ⟨v, hv1, hv2, hv3, rfl⟩ := first.mp ⟨s, hs, hw⟩
          obtain ⟨g1, g2, g3⟩ := (hv v).mpr ⟨Or.inl ⟨hv1, hv2⟩, hv3⟩
          exact ⟨v, g1, g2, g3, rfl⟩
        · obtain ⟨v, hv1, hv2, hv3, rfl⟩ := second.mp ⟨s, hs, hw⟩
          obtain ⟨g1, g2, g3⟩ := (hv v).mpr ⟨Or.inr ⟨hv1, hv2⟩, hv3⟩
          exact ⟨v, g1, g2, g3, rfl⟩
      · rintro ⟨v, hv1, hv2, hv3, rfl⟩
        obtain ⟨hin | hin, -⟩ := (hv v).mp ⟨hv1, hv2, hv3⟩
        · obtain ⟨s, hs, hw⟩ := first.mpr ⟨v, hin.1, hin.2, hv3, rfl⟩
          exact ⟨s, Or.inl hs, hw⟩
        · obtain ⟨s, hs, hw⟩ := second.mpr ⟨v, hin.1, hin.2, hv3, rfl⟩
          exact ⟨s, Or.inr hs, hw⟩

/-- The sequences of a range, with fuel for every pass it can take. -/
def sequences (lo hi : Nat) : List (List (Nat × Nat)) := split (hi - lo + 1) lo hi

/-- Octets fall in one of a range's sequences exactly when RFC 3629 §4's syntax derives them as
one character, and the scalar value they encode lies in the range. -/
theorem sequences_iff {lo hi : Nat} (hle : lo ≤ hi) (hmax : hi ≤ 0x10FFFF) (l : List Nat) :
    (∃ s, s ∈ sequences lo hi ∧ Within s l) ↔
      ∃ v, lo ≤ v ∧ v ≤ hi ∧ Scalar v ∧ l = encode v ∧ Char l := by
  unfold sequences
  rw [split_iff (hi - lo + 1) lo hi (by omega) hle hmax l]
  constructor
  · rintro ⟨v, h1, h2, h3, rfl⟩
    exact ⟨v, h1, h2, h3, rfl, encode_char h3⟩
  · rintro ⟨v, h1, h2, h3, h4, -⟩
    exact ⟨v, h1, h2, h3, h4⟩

end Stdx.Regex.Utf8
