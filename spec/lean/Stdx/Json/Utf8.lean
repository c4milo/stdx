/-!
# UTF-8, RFC 3629 §4

The syntax of a UTF-8 octet sequence, transcribed from RFC 3629 §4, and the machine
`src/json/utf8.zig`'s `Utf8` runs, one octet at a time. Two theorems hold the machine to the
syntax (decision 28):

- `accepts_iff`: from the start, the machine ends between characters exactly on the sequences the
  syntax derives;
- `refuses_iff`: it refuses an octet exactly when no sequence the syntax derives starts with the
  octets up to it, so it refuses at the first octet that rules the text out.

`Vectors.lean` writes every step of the machine, from every state it reaches, into
`src/json/utf8_vectors.txt`, which a Zig test replays against `Utf8.accept`.

Octets are natural numbers; the machine refuses every one above 0xFF, as no rule derives one.
-/
namespace Stdx.Json.Utf8

/-- `UTF8-tail = %x80-BF` -/
def Tail (b : Nat) : Prop := 0x80 ≤ b ∧ b ≤ 0xBF

/-- `UTF8-char = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4`, an alternative of RFC 3629 §4 each. -/
inductive Char : List Nat → Prop where
  /-- `UTF8-1 = %x00-7F` -/
  | one {a : Nat} : a ≤ 0x7F → Char [a]
  /-- `UTF8-2 = %xC2-DF UTF8-tail` -/
  | two {a b : Nat} : 0xC2 ≤ a → a ≤ 0xDF → Tail b → Char [a, b]
  /-- `UTF8-3 = %xE0 %xA0-BF UTF8-tail` -/
  | e0 {b c : Nat} : 0xA0 ≤ b → b ≤ 0xBF → Tail c → Char [0xE0, b, c]
  /-- `/ %xE1-EC 2( UTF8-tail )` -/
  | e1ec {a b c : Nat} : 0xE1 ≤ a → a ≤ 0xEC → Tail b → Tail c → Char [a, b, c]
  /-- `/ %xED %x80-9F UTF8-tail` -/
  | ed {b c : Nat} : 0x80 ≤ b → b ≤ 0x9F → Tail c → Char [0xED, b, c]
  /-- `/ %xEE-EF 2( UTF8-tail )` -/
  | eeef {a b c : Nat} : 0xEE ≤ a → a ≤ 0xEF → Tail b → Tail c → Char [a, b, c]
  /-- `UTF8-4 = %xF0 %x90-BF 2( UTF8-tail )` -/
  | f0 {b c d : Nat} : 0x90 ≤ b → b ≤ 0xBF → Tail c → Tail d → Char [0xF0, b, c, d]
  /-- `/ %xF1-F3 3( UTF8-tail )` -/
  | f1f3 {a b c d : Nat} : 0xF1 ≤ a → a ≤ 0xF3 → Tail b → Tail c → Tail d → Char [a, b, c, d]
  /-- `/ %xF4 %x80-8F 2( UTF8-tail )` -/
  | f4 {b c d : Nat} : 0x80 ≤ b → b ≤ 0x8F → Tail c → Tail d → Char [0xF4, b, c, d]

/-- `UTF8-octets = *( UTF8-char )` -/
inductive Octets : List Nat → Prop where
  /-- No character. -/
  | nil : Octets []
  /-- A character, then more. -/
  | cons {c rest : List Nat} : Char c → Octets rest → Octets (c ++ rest)

/-- Where the machine stands between octets. `fields` gives each as `Utf8`'s fields. -/
inductive State where
  /-- Between characters. -/
  | start
  /-- One `UTF8-tail` owed. -/
  | tail1
  /-- Two owed. -/
  | tail2
  /-- Three owed. -/
  | tail3
  /-- After `%xE0`: an octet of `%xA0-BF`, then one tail. -/
  | afterE0
  /-- After `%xED`: an octet of `%x80-9F`, then one tail. -/
  | afterED
  /-- After `%xF0`: an octet of `%x90-BF`, then two tails. -/
  | afterF0
  /-- After `%xF4`: an octet of `%x80-8F`, then two tails. -/
  | afterF4
  deriving DecidableEq, Repr

/-- Every state, in the order `Vectors.lean` writes them. -/
def State.all : List State :=
  [.start, .tail1, .tail2, .tail3, .afterE0, .afterED, .afterF0, .afterF4]

/-- A state as `Utf8`'s fields: the continuation octets still owed, and the least and the
greatest octet the next one may be. -/
def State.fields : State → Nat × Nat × Nat
  | .start => (0, 0x80, 0xBF)
  | .tail1 => (1, 0x80, 0xBF)
  | .tail2 => (2, 0x80, 0xBF)
  | .tail3 => (3, 0x80, 0xBF)
  | .afterE0 => (2, 0xA0, 0xBF)
  | .afterED => (2, 0x80, 0x9F)
  | .afterF0 => (3, 0x90, 0xBF)
  | .afterF4 => (3, 0x80, 0x8F)

/-- The state after octet `b` of a character's first octet, from between characters. -/
def first (b : Nat) : Option State :=
  if b ≤ 0x7F then some .start
  else if 0xC2 ≤ b ∧ b ≤ 0xDF then some .tail1
  else if b = 0xE0 then some .afterE0
  else if 0xE1 ≤ b ∧ b ≤ 0xEC then some .tail2
  else if b = 0xED then some .afterED
  else if 0xEE ≤ b ∧ b ≤ 0xEF then some .tail2
  else if b = 0xF0 then some .afterF0
  else if 0xF1 ≤ b ∧ b ≤ 0xF3 then some .tail3
  else if b = 0xF4 then some .afterF4
  else none

/-- `next` when `low ≤ b ≤ high`, and a refusal otherwise. -/
def within (low high b : Nat) (next : State) : Option State :=
  if low ≤ b ∧ b ≤ high then some next else none

/-- One octet: the state after it, or none where UTF-8 cannot hold it. -/
def step : State → Nat → Option State
  | .start, b => first b
  | .tail1, b => within 0x80 0xBF b .start
  | .tail2, b => within 0x80 0xBF b .tail1
  | .tail3, b => within 0x80 0xBF b .tail2
  | .afterE0, b => within 0xA0 0xBF b .tail1
  | .afterED, b => within 0x80 0x9F b .tail1
  | .afterF0, b => within 0x90 0xBF b .tail2
  | .afterF4, b => within 0x80 0x8F b .tail2

/-- The state after every octet of a sequence, or none when one is refused. -/
def run : State → List Nat → Option State
  | q, [] => some q
  | q, b :: l =>
    match step q b with
    | some q' => run q' l
    | none => none

/-- `n` tails, then UTF-8 again. -/
def Tails : Nat → List Nat → Prop
  | 0, l => Octets l
  | n + 1, l => ∃ b r, l = b :: r ∧ Tail b ∧ Tails n r

/-- What may follow a state: the sequences that take it back between characters and then derive
from `UTF8-octets`. -/
def Lang : State → List Nat → Prop
  | .start, l => Octets l
  | .tail1, l => Tails 1 l
  | .tail2, l => Tails 2 l
  | .tail3, l => Tails 3 l
  | .afterE0, l => ∃ b r, l = b :: r ∧ 0xA0 ≤ b ∧ b ≤ 0xBF ∧ Tails 1 r
  | .afterED, l => ∃ b r, l = b :: r ∧ 0x80 ≤ b ∧ b ≤ 0x9F ∧ Tails 1 r
  | .afterF0, l => ∃ b r, l = b :: r ∧ 0x90 ≤ b ∧ b ≤ 0xBF ∧ Tails 2 r
  | .afterF4, l => ∃ b r, l = b :: r ∧ 0x80 ≤ b ∧ b ≤ 0x8F ∧ Tails 2 r

/-- A sequence of UTF-8 split at its first character's first octet. -/
theorem octets_cons (b : Nat) (l : List Nat) :
    Octets (b :: l) ↔ ∃ q, first b = some q ∧ Lang q l := by
  constructor
  · intro h
    generalize hbl : b :: l = xs at h
    cases h with
    | nil => cases hbl
    | cons hc hr =>
      cases hc with
      | one ha =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        exact ⟨.start, by simp [first, ha], hr⟩
      | two ha ha' ht =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        refine ⟨.tail1, ?_, _, _, rfl, ht, hr⟩
        simp only [first]
        rw [ite_eq_right (by omega), ite_eq_left ⟨ha, ha'⟩]
      | e0 hb hb' ht =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        exact ⟨.afterE0, by simp [first], _, _, rfl, hb, hb', _, _, rfl, ht, hr⟩
      | e1ec ha ha' hb hc' =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        refine ⟨.tail2, ?_, _, _, rfl, hb, _, _, rfl, hc', hr⟩
        simp only [first]
        rw [ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_left ⟨ha, ha'⟩]
      | ed hb hb' ht =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        exact ⟨.afterED, by simp [first], _, _, rfl, hb, hb', _, _, rfl, ht, hr⟩
      | eeef ha ha' hb hc' =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        refine ⟨.tail2, ?_, _, _, rfl, hb, _, _, rfl, hc', hr⟩
        simp only [first]
        rw [ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_right (by omega),
          ite_eq_right (by omega), ite_eq_left ⟨ha, ha'⟩]
      | f0 hb hb' hc' hd =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        exact ⟨.afterF0, by simp [first], _, _, rfl, hb, hb', _, _, rfl, hc', _, _, rfl, hd, hr⟩
      | f1f3 ha ha' hb hc' hd =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        refine ⟨.tail3, ?_, _, _, rfl, hb, _, _, rfl, hc', _, _, rfl, hd, hr⟩
        simp only [first]
        rw [ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_right (by omega),
          ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_right (by omega), ite_eq_left ⟨ha, ha'⟩]
      | f4 hb hb' hc' hd =>
        simp only [List.cons_append, List.nil_append, List.cons.injEq] at hbl
        obtain ⟨rfl, rfl⟩ := hbl
        exact ⟨.afterF4, by simp [first], _, _, rfl, hb, hb', _, _, rfl, hc', _, _, rfl, hd, hr⟩
  · rintro ⟨q, hq, hl⟩
    unfold first at hq
    split at hq
    · next h =>
      cases hq
      exact Octets.cons (c := [b]) (Char.one h) hl
    split at hq
    · next h =>
      cases hq
      obtain ⟨x, r, rfl, hx, hr⟩ := hl
      exact Octets.cons (c := [b, x]) (Char.two h.1 h.2 hx) hr
    split at hq
    · next h =>
      cases hq
      subst h
      obtain ⟨y, r, rfl, hy, hy', z, r', rfl, hz, hr⟩ := hl
      exact Octets.cons (c := [0xE0, y, z]) (Char.e0 hy hy' hz) hr
    split at hq
    · next h =>
      cases hq
      obtain ⟨y, r, rfl, hy, z, r', rfl, hz, hr⟩ := hl
      exact Octets.cons (c := [b, y, z]) (Char.e1ec h.1 h.2 hy hz) hr
    split at hq
    · next h =>
      cases hq
      subst h
      obtain ⟨y, r, rfl, hy, hy', z, r', rfl, hz, hr⟩ := hl
      exact Octets.cons (c := [0xED, y, z]) (Char.ed hy hy' hz) hr
    split at hq
    · next h =>
      cases hq
      obtain ⟨y, r, rfl, hy, z, r', rfl, hz, hr⟩ := hl
      exact Octets.cons (c := [b, y, z]) (Char.eeef h.1 h.2 hy hz) hr
    split at hq
    · next h =>
      cases hq
      subst h
      obtain ⟨y, r, rfl, hy, hy', z, r', rfl, hz, w, r'', rfl, hw, hr⟩ := hl
      exact Octets.cons (c := [0xF0, y, z, w]) (Char.f0 hy hy' hz hw) hr
    split at hq
    · next h =>
      cases hq
      obtain ⟨y, r, rfl, hy, z, r', rfl, hz, w, r'', rfl, hw, hr⟩ := hl
      exact Octets.cons (c := [b, y, z, w]) (Char.f1f3 h.1 h.2 hy hz hw) hr
    split at hq
    · next h =>
      cases hq
      subst h
      obtain ⟨y, r, rfl, hy, hy', z, r', rfl, hz, w, r'', rfl, hw, hr⟩ := hl
      exact Octets.cons (c := [0xF4, y, z, w]) (Char.f4 hy hy' hz hw) hr
    cases hq

/-- A list that starts with `b`, taken apart at `b`. -/
theorem exists_cons_iff {P : Nat → List Nat → Prop} {b : Nat} {l : List Nat} :
    (∃ x r, b :: l = x :: r ∧ P x r) ↔ P b l :=
  ⟨fun ⟨_, _, h, hp⟩ => (by cases h; exact hp), fun hp => ⟨b, l, rfl, hp⟩⟩

/-- A step that takes an octet in one range to one state. -/
theorem exists_within_iff {low high b : Nat} {next : State} {P : State → Prop} :
    (∃ q, within low high b next = some q ∧ P q) ↔ (low ≤ b ∧ b ≤ high) ∧ P next := by
  unfold within
  by_cases h : low ≤ b ∧ b ≤ high
  · rw [ite_eq_left h]
    exact ⟨fun ⟨_, hq, hp⟩ => (by cases hq; exact ⟨h, hp⟩), fun ⟨_, hp⟩ => ⟨_, rfl, hp⟩⟩
  · rw [ite_eq_right h]
    exact ⟨fun ⟨_, hq, _⟩ => (by cases hq), fun ⟨hr, _⟩ => absurd hr h⟩

/-- What may follow each state, split at its first octet: the machine's step. -/
theorem lang_cons (q : State) (b : Nat) (l : List Nat) :
    Lang q (b :: l) ↔ ∃ q', step q b = some q' ∧ Lang q' l := by
  cases q with
  | start => exact octets_cons b l
  | tail1 => simp only [Lang, Tails, step, exists_cons_iff, exists_within_iff, Tail]
  | tail2 => simp only [Lang, Tails, step, exists_cons_iff, exists_within_iff, Tail]
  | tail3 => simp only [Lang, Tails, step, exists_cons_iff, exists_within_iff, Tail]
  | afterE0 => simp only [Lang, step, exists_cons_iff, exists_within_iff, and_assoc]
  | afterED => simp only [Lang, step, exists_cons_iff, exists_within_iff, and_assoc]
  | afterF0 => simp only [Lang, step, exists_cons_iff, exists_within_iff, and_assoc]
  | afterF4 => simp only [Lang, step, exists_cons_iff, exists_within_iff, and_assoc]

/-- From any state, the machine ends between characters exactly on what may follow it. -/
theorem run_eq_start_iff (q : State) (l : List Nat) : run q l = some .start ↔ Lang q l := by
  induction l generalizing q with
  | nil => cases q <;> simp [run, Lang, Tails, Octets.nil]
  | cons b l ih =>
    rw [lang_cons]
    simp only [run]
    cases h : step q b with
    | none => simp
    | some q' => simp [ih]

/-- **The machine accepts exactly UTF-8** (RFC 3629 §4): from the start, it ends between
characters exactly on the sequences `UTF8-octets` derives. -/
theorem accepts_iff (l : List Nat) : run .start l = some .start ↔ Octets l :=
  run_eq_start_iff .start l

/-- Running over two parts is running over the first, then the second. -/
theorem run_append (q : State) (l s : List Nat) :
    run q (l ++ s) = (run q l).bind (fun q' => run q' s) := by
  induction l generalizing q with
  | nil => simp [run]
  | cons b l ih =>
    simp only [List.cons_append, run]
    cases step q b <;> simp [ih]

/-- A shortest way back between characters from each state. -/
def State.completion : State → List Nat
  | .start => []
  | .tail1 => [0x80]
  | .tail2 => [0x80, 0x80]
  | .tail3 => [0x80, 0x80, 0x80]
  | .afterE0 => [0xA0, 0x80]
  | .afterED => [0x80, 0x80]
  | .afterF0 => [0x90, 0x80, 0x80]
  | .afterF4 => [0x80, 0x80, 0x80]

/-- Each state's completion takes it back between characters. -/
theorem run_completion (q : State) : run q q.completion = some .start := by
  cases q <;> decide

/-- **The machine refuses at the first octet that rules UTF-8 out**: it refuses the octets so far
exactly when no sequence `UTF8-octets` derives starts with them. -/
theorem refuses_iff (l : List Nat) : run .start l = none ↔ ¬ ∃ s, Octets (l ++ s) := by
  constructor
  · rintro h ⟨s, hs⟩
    rw [← accepts_iff, run_append, h] at hs
    cases hs
  · intro h
    cases hr : run .start l with
    | none => rfl
    | some q =>
      exfalso
      apply h
      refine ⟨q.completion, ?_⟩
      rw [← accepts_iff, run_append, hr]
      exact run_completion q

end Stdx.Json.Utf8
