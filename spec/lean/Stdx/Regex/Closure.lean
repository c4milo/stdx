/-!
# The threads of one position, in the order a backtracking matcher tries them

At one position of a text, `Matcher.follow` takes every path from a seed that takes no byte, the
preferred branch of each split first (decision 86, `src/regex/matcher.zig`). An instruction that
waits for a byte, or `match`, ends a path and joins the position's threads. An instruction that
another path of the position reached first ends a path too, and joins nothing: the matcher's
`visited` set holds it.

This file holds that walk with no program in it. `Kind` says what an instruction does to a path
at the position, and `follow` and `closure` are the walk from one seed and from a list of seeds.
`rem` holds the instructions that no path reached yet.

The main result is `closure_value`. The matcher keeps one `visited` set for all the seeds of a
position, so a later seed's paths stop at what an earlier seed's paths reached. For any value
`f` of a thread, the first value among the threads of all the seeds is the first value among
the seeds, each walked alone. So a later arrival at an instruction can be dropped, and the order
of the threads is the order in which a backtracking matcher tries them.

Instruction indexes are natural numbers.
-/
namespace Stdx.Regex.Closure

/-- What an instruction does at one position to a path that takes no byte. -/
inductive Kind where
  /-- It ends the path as a thread: it waits for a byte, or it is `match`. -/
  | emit
  /-- It ends the path with no thread: `fail`, or an assertion that does not hold. -/
  | stop
  /-- The path goes on to one instruction: a save, a jump, or an assertion that holds. -/
  | one (a : Nat)
  /-- The path goes on to `a` first and to `b` second: a split. -/
  | two (a b : Nat)

/-- The first value that `f` gives among the members of a list, in order. -/
def first {α : Type} (f : Nat → Option α) : List Nat → Option α
  | [] => none
  | x :: xs =>
    match f x with
    | some v => some v
    | none => first f xs

/-- The first value of two lists one after the other. -/
theorem first_append {α : Type} (f : Nat → Option α) (xs ys : List Nat) :
    first f (xs ++ ys) = (first f xs).or (first f ys) := by
  induction xs with
  | nil => simp [first]
  | cons x xs ih =>
    simp only [List.cons_append, first]
    cases f x with
    | some v => simp
    | none => simpa using ih

/-- A list has no first value exactly where `f` gives none for each member. -/
theorem first_none {α : Type} (f : Nat → Option α) (xs : List Nat) :
    first f xs = none ↔ ∀ x, x ∈ xs → f x = none := by
  induction xs with
  | nil => simp [first]
  | cons x xs ih =>
    simp only [first, List.mem_cons]
    cases hx : f x with
    | some v =>
      constructor
      · intro h; cases h
      · intro h; have := h x (Or.inl rfl); rw [hx] at this; cases this
    | none =>
      constructor
      · intro h y hy
        cases hy with
        | inl heq => rw [heq, hx]
        | inr hmem => exact ih.mp h y hmem
      · intro h
        exact ih.mpr (fun y hy => h y (Or.inr hy))

/-- A list without one of its members is shorter. -/
theorem length_without {pc : Nat} {rem : List Nat} (h : pc ∈ rem) :
    (rem.filter (· != pc)).length < rem.length := by
  induction rem with
  | nil => cases h
  | cons x xs ih =>
    by_cases hx : x = pc
    · have hle := List.length_filter_le (· != pc) xs
      rw [List.filter_cons_of_neg (by simp [hx])]
      simp only [List.length_cons]
      omega
    · have hmem : pc ∈ xs := by
        cases h with
        | head => exact absurd rfl hx
        | tail _ hmem => exact hmem
      have := ih hmem
      rw [List.filter_cons_of_pos (by simp [hx])]
      simp only [List.length_cons]
      omega

/-- A member of a list without `pc` is a member of the list, and is not `pc`. -/
theorem mem_without {pc x : Nat} {rem : List Nat} :
    x ∈ rem.filter (· != pc) ↔ x ∈ rem ∧ x ≠ pc := by
  simp [List.mem_filter]

/-- `Matcher.follow` from one seed. `rem` holds the instructions no path reached yet. The walk
gives the instructions still not reached, and the threads it found, in order. -/
def follow (kind : Nat → Kind) : Nat → List Nat → Nat → List Nat × List Nat
  | 0, rem, _ => (rem, [])
  | fuel + 1, rem, pc =>
    if pc ∈ rem then
      match kind pc with
      | .emit => (rem.filter (· != pc), [pc])
      | .stop => (rem.filter (· != pc), [])
      | .one a => follow kind fuel (rem.filter (· != pc)) a
      | .two a b =>
        let before := follow kind fuel (rem.filter (· != pc)) a
        let after := follow kind fuel before.1 b
        (after.1, before.2 ++ after.2)
    else (rem, [])

/-- A walk from an instruction that a path reached before finds nothing. -/
theorem follow_skip (kind : Nat → Kind) {fuel : Nat} {rem : List Nat} {pc : Nat}
    (h : pc ∉ rem) : follow kind fuel rem pc = (rem, []) := by
  cases fuel with
  | zero => rfl
  | succ fuel => simp [follow, h]

/-- A walk to a thread. -/
theorem follow_emit (kind : Nat → Kind) {fuel : Nat} {rem : List Nat} {pc : Nat}
    (h : pc ∈ rem) (hk : kind pc = .emit) :
    follow kind (fuel + 1) rem pc = (rem.filter (· != pc), [pc]) := by
  simp [follow, h, hk]

/-- A walk that ends with no thread. -/
theorem follow_stop (kind : Nat → Kind) {fuel : Nat} {rem : List Nat} {pc : Nat}
    (h : pc ∈ rem) (hk : kind pc = .stop) :
    follow kind (fuel + 1) rem pc = (rem.filter (· != pc), []) := by
  simp [follow, h, hk]

/-- A walk through an instruction that leads to one other. -/
theorem follow_one (kind : Nat → Kind) {fuel : Nat} {rem : List Nat} {pc a : Nat}
    (h : pc ∈ rem) (hk : kind pc = .one a) :
    follow kind (fuel + 1) rem pc = follow kind fuel (rem.filter (· != pc)) a := by
  simp [follow, h, hk]

/-- A walk through a split: its preferred branch, then its other branch. -/
theorem follow_two (kind : Nat → Kind) {fuel : Nat} {rem : List Nat} {pc a b : Nat}
    (h : pc ∈ rem) (hk : kind pc = .two a b) :
    follow kind (fuel + 1) rem pc =
      ((follow kind fuel (follow kind fuel (rem.filter (· != pc)) a).1 b).1,
        (follow kind fuel (rem.filter (· != pc)) a).2 ++
          (follow kind fuel (follow kind fuel (rem.filter (· != pc)) a).1 b).2) := by
  simp [follow, h, hk]

/-- A walk leaves behind only instructions that no path reached before it. -/
theorem follow_sub (kind : Nat → Kind) :
    ∀ fuel rem pc x, x ∈ (follow kind fuel rem pc).1 → x ∈ rem := by
  intro fuel
  induction fuel with
  | zero => intro rem pc x h; simpa [follow] using h
  | succ fuel ih =>
    intro rem pc x h
    by_cases hmem : pc ∈ rem
    · cases hk : kind pc with
      | emit => rw [follow_emit kind hmem hk] at h; exact (mem_without.mp h).1
      | stop => rw [follow_stop kind hmem hk] at h; exact (mem_without.mp h).1
      | one a => rw [follow_one kind hmem hk] at h; exact (mem_without.mp (ih _ _ _ h)).1
      | two a b =>
        rw [follow_two kind hmem hk] at h
        exact (mem_without.mp (ih _ _ _ (ih _ _ _ h))).1
    · rw [follow_skip kind hmem] at h; exact h

/-- A walk leaves no more instructions than it found. -/
theorem follow_len (kind : Nat → Kind) :
    ∀ fuel rem pc, (follow kind fuel rem pc).1.length ≤ rem.length := by
  intro fuel
  induction fuel with
  | zero => intro rem pc; simp [follow]
  | succ fuel ih =>
    intro rem pc
    have hle := List.length_filter_le (· != pc) rem
    by_cases hmem : pc ∈ rem
    · cases hk : kind pc with
      | emit => rw [follow_emit kind hmem hk]; exact hle
      | stop => rw [follow_stop kind hmem hk]; exact hle
      | one a => rw [follow_one kind hmem hk]; exact Nat.le_trans (ih _ _) hle
      | two a b =>
        rw [follow_two kind hmem hk]
        exact Nat.le_trans (ih _ _) (Nat.le_trans (ih _ _) hle)
    · rw [follow_skip kind hmem]; exact Nat.le_refl _

/-- A thread of a walk is an instruction that ends a path as a thread, that no path reached
before the walk, and that the walk reached. -/
theorem follow_threads (kind : Nat → Kind) :
    ∀ fuel rem pc x, x ∈ (follow kind fuel rem pc).2 →
      x ∈ rem ∧ kind x = .emit ∧ x ∉ (follow kind fuel rem pc).1 := by
  intro fuel
  induction fuel with
  | zero => intro rem pc x h; simp [follow] at h
  | succ fuel ih =>
    intro rem pc x h
    by_cases hmem : pc ∈ rem
    · cases hk : kind pc with
      | emit =>
        rw [follow_emit kind hmem hk] at h ⊢
        have hx : x = pc := by simpa using h
        subst hx
        exact ⟨hmem, hk, fun hin => (mem_without.mp hin).2 rfl⟩
      | stop => rw [follow_stop kind hmem hk] at h; simp at h
      | one a =>
        rw [follow_one kind hmem hk] at h ⊢
        have ⟨h1, h2, h3⟩ := ih _ _ _ h
        exact ⟨(mem_without.mp h1).1, h2, h3⟩
      | two a b =>
        rw [follow_two kind hmem hk] at h ⊢
        cases List.mem_append.mp h with
        | inl hl =>
          have ⟨h1, h2, h3⟩ := ih _ _ _ hl
          exact ⟨(mem_without.mp h1).1, h2, fun hin => h3 (follow_sub kind _ _ _ _ hin)⟩
        | inr hr =>
          have ⟨h1, h2, h3⟩ := ih _ _ _ hr
          exact ⟨(mem_without.mp (follow_sub kind _ _ _ _ h1)).1, h2, h3⟩
    · rw [follow_skip kind hmem] at h; simp at h

/-- What a walk left behind for an instruction it reached: the instruction's thread where it
ends a path as one, and no instruction that it leads to still to reach. -/
def Settled (kind : Nat → Kind) (rem threads : List Nat) (x : Nat) : Prop :=
  (kind x = .emit → x ∈ threads) ∧ (∀ a, kind x = .one a → a ∉ rem) ∧
    ∀ a b, kind x = .two a b → a ∉ rem ∧ b ∉ rem

/-- An instruction stays settled as a walk goes on. -/
theorem Settled.weaken {kind : Nat → Kind} {rem rem' threads threads' : List Nat} {x : Nat}
    (h : Settled kind rem threads x) (hrem : ∀ y, y ∈ rem' → y ∈ rem)
    (hthreads : ∀ y, y ∈ threads → y ∈ threads') : Settled kind rem' threads' x :=
  ⟨fun he => hthreads x (h.1 he), fun a ha hin => h.2.1 a ha (hrem a hin),
    fun a b hab => ⟨fun hin => (h.2.2 a b hab).1 (hrem a hin), fun hin => (h.2.2 a b hab).2 (hrem b hin)⟩⟩

/-- A walk with room for every instruction reaches its seed, and settles each instruction it
reaches. -/
theorem follow_done (kind : Nat → Kind) :
    ∀ fuel rem pc, rem.length < fuel →
      (pc ∈ rem → pc ∉ (follow kind fuel rem pc).1) ∧
        ∀ x, x ∈ rem → x ∉ (follow kind fuel rem pc).1 →
          Settled kind (follow kind fuel rem pc).1 (follow kind fuel rem pc).2 x := by
  intro fuel
  induction fuel with
  | zero => intro rem pc h; omega
  | succ fuel ih =>
    intro rem pc hfuel
    by_cases hmem : pc ∈ rem
    · have hlen := length_without hmem
      have hfuel₁ : (rem.filter (· != pc)).length < fuel := by omega
      -- An instruction of `rem` that is not in `rem` without `pc` is `pc`.
      have hpc : ∀ x, x ∈ rem → x ∉ rem.filter (· != pc) → x = pc := by
        intro x hx hnot
        apply Classical.byContradiction
        intro hne
        exact hnot (mem_without.mpr ⟨hx, hne⟩)
      cases hk : kind pc with
      | emit =>
        rw [follow_emit kind hmem hk]
        refine ⟨fun _ h => (mem_without.mp h).2 rfl, ?_⟩
        intro x hx hnot
        have hxpc := hpc x hx hnot
        subst hxpc
        exact ⟨fun _ => List.mem_singleton.mpr rfl, fun a ha => (by cases hk.symm.trans ha),
          fun a b hab => (by cases hk.symm.trans hab)⟩
      | stop =>
        rw [follow_stop kind hmem hk]
        refine ⟨fun _ h => (mem_without.mp h).2 rfl, ?_⟩
        intro x hx hnot
        have hxpc := hpc x hx hnot
        subst hxpc
        exact ⟨fun he => (by cases hk.symm.trans he), fun a ha => (by cases hk.symm.trans ha),
          fun a b hab => (by cases hk.symm.trans hab)⟩
      | one a =>
        rw [follow_one kind hmem hk]
        have ⟨h1, h2⟩ := ih (rem.filter (· != pc)) a hfuel₁
        have hsub := follow_sub kind fuel (rem.filter (· != pc)) a
        have ha : a ∉ (follow kind fuel (rem.filter (· != pc)) a).1 := by
          intro h
          exact h1 (hsub a h) h
        refine ⟨fun _ h => (mem_without.mp (hsub pc h)).2 rfl, ?_⟩
        intro x hx hnot
        by_cases hxpc : x = pc
        · subst hxpc
          exact ⟨fun he => (by cases hk.symm.trans he),
            fun a' ha' => Kind.one.inj (hk.symm.trans ha') ▸ ha,
            fun a' b' hab => (by cases hk.symm.trans hab)⟩
        · exact h2 x (mem_without.mpr ⟨hx, hxpc⟩) hnot
      | two a b =>
        rw [follow_two kind hmem hk]
        have hlenF := follow_len kind fuel (rem.filter (· != pc)) a
        have ⟨f1, f2⟩ := ih (rem.filter (· != pc)) a hfuel₁
        have ⟨g1, g2⟩ := ih (follow kind fuel (rem.filter (· != pc)) a).1 b (by omega)
        have subF := follow_sub kind fuel (rem.filter (· != pc)) a
        have subG := follow_sub kind fuel (follow kind fuel (rem.filter (· != pc)) a).1 b
        have ha : a ∉ (follow kind fuel (follow kind fuel (rem.filter (· != pc)) a).1 b).1 := by
          intro h
          exact f1 (subF a (subG a h)) (subG a h)
        have hb : b ∉ (follow kind fuel (follow kind fuel (rem.filter (· != pc)) a).1 b).1 := by
          intro h
          exact g1 (subG b h) h
        refine ⟨fun _ h => (mem_without.mp (subF pc (subG pc h))).2 rfl, ?_⟩
        intro x hx hnot
        by_cases hxpc : x = pc
        · subst hxpc
          refine ⟨fun he => (by cases hk.symm.trans he), fun a' ha' => (by cases hk.symm.trans ha'), ?_⟩
          intro a' b' hab
          obtain ⟨rfl, rfl⟩ := Kind.two.inj (hk.symm.trans hab)
          exact ⟨ha, hb⟩
        · have hx₁ : x ∈ rem.filter (· != pc) := mem_without.mpr ⟨hx, hxpc⟩
          by_cases hxF : x ∈ (follow kind fuel (rem.filter (· != pc)) a).1
          · exact (g2 x hxF hnot).weaken (fun _ h => h) (fun y hy => List.mem_append.mpr (Or.inr hy))
          · exact (f2 x hx₁ hxF).weaken (fun y hy => subG y hy)
              (fun y hy => List.mem_append.mpr (Or.inl hy))
    · rw [follow_skip kind hmem]
      exact ⟨fun h => absurd h hmem, fun x hx hnot => absurd hx hnot⟩

/-- A set of instructions that no path leaves. -/
def Closed (kind : Nat → Kind) (D : Nat → Prop) : Prop :=
  ∀ x, D x → (∀ a, kind x = .one a → D a) ∧ ∀ a b, kind x = .two a b → D a ∧ D b

/-- A walk from inside a closed set reaches instructions of the set alone, and its threads are
of the set. -/
theorem follow_inside (kind : Nat → Kind) {D : Nat → Prop} (hclosed : Closed kind D) :
    ∀ fuel rem pc, D pc →
      (∀ x, x ∈ rem → x ∉ (follow kind fuel rem pc).1 → D x) ∧
        ∀ x, x ∈ (follow kind fuel rem pc).2 → D x := by
  intro fuel
  induction fuel with
  | zero =>
    intro rem pc _
    exact ⟨fun x hx hnot => absurd hx hnot, fun x hx => by simp [follow] at hx⟩
  | succ fuel ih =>
    intro rem pc hD
    by_cases hmem : pc ∈ rem
    · have hpc : ∀ x, x ∈ rem → x ∉ rem.filter (· != pc) → D x := by
        intro x hx hnot
        have hxpc : x = pc := by
          apply Classical.byContradiction
          intro hne
          exact hnot (mem_without.mpr ⟨hx, hne⟩)
        rw [hxpc]
        exact hD
      cases hk : kind pc with
      | emit =>
        rw [follow_emit kind hmem hk]
        refine ⟨hpc, ?_⟩
        intro x hx
        rw [List.mem_singleton.mp hx]
        exact hD
      | stop =>
        rw [follow_stop kind hmem hk]
        exact ⟨hpc, fun x hx => by simp at hx⟩
      | one a =>
        rw [follow_one kind hmem hk]
        have ⟨h1, h2⟩ := ih (rem.filter (· != pc)) a ((hclosed pc hD).1 a hk)
        refine ⟨?_, h2⟩
        intro x hx hnot
        by_cases hx₁ : x ∈ rem.filter (· != pc)
        · exact h1 x hx₁ hnot
        · exact hpc x hx hx₁
      | two a b =>
        rw [follow_two kind hmem hk]
        have hab := (hclosed pc hD).2 a b hk
        have ⟨f1, f2⟩ := ih (rem.filter (· != pc)) a hab.1
        have ⟨g1, g2⟩ := ih (follow kind fuel (rem.filter (· != pc)) a).1 b hab.2
        refine ⟨?_, ?_⟩
        · intro x hx hnot
          by_cases hx₁ : x ∈ rem.filter (· != pc)
          · by_cases hxF : x ∈ (follow kind fuel (rem.filter (· != pc)) a).1
            · exact g1 x hxF hnot
            · exact f1 x hx₁ hxF
          · exact hpc x hx hx₁
        · intro x hx
          cases List.mem_append.mp hx with
          | inl h => exact f2 x h
          | inr h => exact g2 x h
    · rw [follow_skip kind hmem]
      exact ⟨fun x hx hnot => absurd hx hnot, fun x hx => by simp at hx⟩

/-- Two walks from one seed, one of which starts with a closed set already reached. Where each
thread of the set has no value, the two walks give one first value, and the first walk leaves
what the second leaves outside the set. -/
theorem follow_sim (kind : Nat → Kind) {α : Type} (f : Nat → Option α) {D : Nat → Prop}
    (hclosed : Closed kind D) (hdead : ∀ x, D x → kind x = .emit → f x = none) :
    ∀ fuelB fuelA remA remB pc, remA.length < fuelA → remB.length < fuelB →
      (∀ x, x ∈ remA ↔ x ∈ remB ∧ ¬ D x) →
      (∀ x, x ∈ (follow kind fuelA remA pc).1 ↔ x ∈ (follow kind fuelB remB pc).1 ∧ ¬ D x) ∧
        first f (follow kind fuelA remA pc).2 = first f (follow kind fuelB remB pc).2 := by
  intro fuelB
  induction fuelB with
  | zero => intro fuelA remA remB pc _ h; omega
  | succ fuelB ih =>
    intro fuelA remA remB pc hfa hfb hrel
    by_cases hB : pc ∈ remB
    · by_cases hD : D pc
      · -- The first walk stops at once, and the second stays inside the set.
        have hA : pc ∉ remA := fun h => ((hrel pc).mp h).2 hD
        rw [follow_skip kind hA]
        have ⟨h1, h2⟩ := follow_inside kind hclosed (fuelB + 1) remB pc hD
        have hsub := follow_sub kind (fuelB + 1) remB pc
        refine ⟨?_, ?_⟩
        · intro x
          constructor
          · intro hx
            have hx' := (hrel x).mp hx
            refine ⟨?_, hx'.2⟩
            apply Classical.byContradiction
            intro hnot
            exact hx'.2 (h1 x hx'.1 hnot)
          · intro hx
            exact (hrel x).mpr ⟨hsub x hx.1, hx.2⟩
        · have hnone : first f (follow kind (fuelB + 1) remB pc).2 = none :=
            (first_none f _).mpr
              (fun x hx => hdead x (h2 x hx) (follow_threads kind _ _ _ x hx).2.1)
          rw [hnone]
          rfl
      · -- Both walks reach the seed, and go on alike.
        have hA : pc ∈ remA := (hrel pc).mpr ⟨hB, hD⟩
        cases fuelA with
        | zero => omega
        | succ fuelA =>
          have hlenA := length_without hA
          have hlenB := length_without hB
          have hrel₁ : ∀ x, x ∈ remA.filter (· != pc) ↔ x ∈ remB.filter (· != pc) ∧ ¬ D x := by
            intro x
            rw [mem_without, mem_without, hrel x]
            constructor
            · intro h; exact ⟨⟨h.1.1, h.2⟩, h.1.2⟩
            · intro h; exact ⟨⟨h.1.1, h.2⟩, h.1.2⟩
          cases hk : kind pc with
          | emit => rw [follow_emit kind hA hk, follow_emit kind hB hk]; exact ⟨hrel₁, rfl⟩
          | stop => rw [follow_stop kind hA hk, follow_stop kind hB hk]; exact ⟨hrel₁, rfl⟩
          | one a =>
            rw [follow_one kind hA hk, follow_one kind hB hk]
            exact ih fuelA _ _ a (by omega) (by omega) hrel₁
          | two a b =>
            rw [follow_two kind hA hk, follow_two kind hB hk]
            have ⟨r1, e1⟩ := ih fuelA _ _ a (by omega) (by omega) hrel₁
            have hlenFA := follow_len kind fuelA (remA.filter (· != pc)) a
            have hlenFB := follow_len kind fuelB (remB.filter (· != pc)) a
            have ⟨r2, e2⟩ := ih fuelA _ _ b (by omega) (by omega) r1
            refine ⟨r2, ?_⟩
            rw [first_append, first_append, e1, e2]
    · have hA : pc ∉ remA := fun h => hB ((hrel pc).mp h).1
      rw [follow_skip kind hA, follow_skip kind hB]
      exact ⟨hrel, rfl⟩

/-- `Matcher.close_seeds`: the walk from each seed of a list in turn, with one `visited` set. -/
def closure (kind : Nat → Kind) (fuel : Nat) : List Nat → List Nat → List Nat × List Nat
  | rem, [] => (rem, [])
  | rem, s :: seeds =>
    ((closure kind fuel (follow kind fuel rem s).1 seeds).1,
      (follow kind fuel rem s).2 ++ (closure kind fuel (follow kind fuel rem s).1 seeds).2)

/-- Two walks from a list of seeds, as `follow_sim` holds two walks from one seed. -/
theorem closure_sim (kind : Nat → Kind) {α : Type} (f : Nat → Option α) {D : Nat → Prop}
    (hclosed : Closed kind D) (hdead : ∀ x, D x → kind x = .emit → f x = none)
    {fuelA fuelB : Nat} :
    ∀ seeds remA remB, remA.length < fuelA → remB.length < fuelB →
      (∀ x, x ∈ remA ↔ x ∈ remB ∧ ¬ D x) →
      first f (closure kind fuelA remA seeds).2 = first f (closure kind fuelB remB seeds).2 := by
  intro seeds
  induction seeds with
  | nil => intro remA remB _ _ _; rfl
  | cons s seeds ih =>
    intro remA remB hfa hfb hrel
    have ⟨r, e⟩ := follow_sim kind f hclosed hdead fuelB fuelA remA remB s hfa hfb hrel
    have hlenA := follow_len kind fuelA remA s
    have hlenB := follow_len kind fuelB remB s
    simp only [closure]
    rw [first_append, first_append, e, ih _ _ (by omega) (by omega) r]

/-- The first value among a list of seeds, each walked alone from `full`, in order. -/
def firstSeed (kind : Nat → Kind) {α : Type} (f : Nat → Option α) (fuel : Nat)
    (full : List Nat) : List Nat → Option α
  | [] => none
  | s :: seeds => (first f (follow kind fuel full s).2).or (firstSeed kind f fuel full seeds)

/-- The first seed's walk, then the walks of the other seeds as if the first had reached
nothing. -/
theorem closure_cons (kind : Nat → Kind) {α : Type} (f : Nat → Option α) {fuel : Nat}
    {full : List Nat} (hfuel : full.length < fuel) (hout : ∀ x, x ∉ full → kind x = .stop)
    (s : Nat) (seeds : List Nat) :
    first f (closure kind fuel full (s :: seeds)).2 =
      (first f (follow kind fuel full s).2).or (first f (closure kind fuel full seeds).2) := by
  simp only [closure]
  rw [first_append]
  cases hv : first f (follow kind fuel full s).2 with
  | some v => simp
  | none =>
    simp only [Option.none_or]
    have hdone := (follow_done kind fuel full s hfuel).2
    have hsub := follow_sub kind fuel full s
    have hlen := follow_len kind fuel full s
    -- What the first seed's walk reached is a closed set whose threads have no value.
    have hclosed : Closed kind (fun x => x ∉ (follow kind fuel full s).1) := by
      intro x hx
      by_cases hfull : x ∈ full
      · exact (hdone x hfull hx).2
      · have hk := hout x hfull
        exact ⟨fun a ha => (by cases hk.symm.trans ha), fun a b hab => (by cases hk.symm.trans hab)⟩
    have hdead : ∀ x, x ∉ (follow kind fuel full s).1 → kind x = .emit → f x = none := by
      intro x hx hk
      by_cases hfull : x ∈ full
      · exact (first_none f _).mp hv x ((hdone x hfull hx).1 hk)
      · cases (hout x hfull).symm.trans hk
    apply closure_sim kind f hclosed hdead seeds _ full (by omega) hfuel
    intro x
    constructor
    · intro hx
      exact ⟨hsub x hx, fun h => h hx⟩
    · intro hx
      exact Classical.not_not.mp hx.2

/-- The matcher keeps one `visited` set for all the seeds of a position. For any value of a
thread, the first value among the threads it finds is the first value among the seeds, each
walked alone: a later arrival at an instruction changes no first value. -/
theorem closure_value (kind : Nat → Kind) {α : Type} (f : Nat → Option α) {fuel : Nat}
    {full : List Nat} (hfuel : full.length < fuel) (hout : ∀ x, x ∉ full → kind x = .stop) :
    ∀ seeds, first f (closure kind fuel full seeds).2 = firstSeed kind f fuel full seeds := by
  intro seeds
  induction seeds with
  | nil => rfl
  | cons s seeds ih =>
    rw [closure_cons kind f hfuel hout, ih]
    rfl

/-! ## The walk's threads are the instructions that a path reaches -/

/-- A path that takes no byte leads from one instruction to another. -/
inductive Steps (kind : Nat → Kind) : Nat → Nat → Prop where
  /-- The path of no move. -/
  | here {pc : Nat} : Steps kind pc pc
  /-- A move to the one instruction that follows, then a path. -/
  | one {pc a x : Nat} : kind pc = .one a → Steps kind a x → Steps kind pc x
  /-- A move to a split's preferred branch, then a path. -/
  | left {pc a b x : Nat} : kind pc = .two a b → Steps kind a x → Steps kind pc x
  /-- A move to a split's other branch, then a path. -/
  | right {pc a b x : Nat} : kind pc = .two a b → Steps kind b x → Steps kind pc x

/-- A thread of a walk stands at the end of a path from the walk's seed. -/
theorem follow_reach (kind : Nat → Kind) :
    ∀ fuel rem pc x, x ∈ (follow kind fuel rem pc).2 → Steps kind pc x := by
  intro fuel
  induction fuel with
  | zero => intro rem pc x h; simp [follow] at h
  | succ fuel ih =>
    intro rem pc x h
    by_cases hmem : pc ∈ rem
    · cases hk : kind pc with
      | emit =>
        rw [follow_emit kind hmem hk] at h
        rw [List.mem_singleton.mp h]
        exact .here
      | stop => rw [follow_stop kind hmem hk] at h; simp at h
      | one a =>
        rw [follow_one kind hmem hk] at h
        exact .one hk (ih _ _ _ h)
      | two a b =>
        rw [follow_two kind hmem hk] at h
        cases List.mem_append.mp h with
        | inl hl => exact .left hk (ih _ _ _ hl)
        | inr hr => exact .right hk (ih _ _ _ hr)
    · rw [follow_skip kind hmem] at h; simp at h

/-- A walk from `full` with room for every instruction finds each thread that a path from its
seed reaches. -/
theorem follow_complete (kind : Nat → Kind) {fuel : Nat} {full : List Nat}
    (hfuel : full.length < fuel) (hout : ∀ x, x ∉ full → kind x = .stop) {s x : Nat}
    (hs : s ∈ full) (hsteps : Steps kind s x) (hx : kind x = .emit) :
    x ∈ (follow kind fuel full s).2 := by
  have hdone := follow_done kind fuel full s hfuel
  -- A path from an instruction that the walk reached stays among those it reached.
  have key : ∀ pc y, Steps kind pc y → pc ∉ (follow kind fuel full s).1 →
      y ∉ (follow kind fuel full s).1 := by
    intro pc y h
    induction h with
    | here => exact fun h => h
    | @one pc a y hk _ ih =>
      intro hpc
      by_cases hfull : pc ∈ full
      · exact ih ((hdone.2 pc hfull hpc).2.1 a hk)
      · cases (hout pc hfull).symm.trans hk
    | @left pc a b y hk _ ih =>
      intro hpc
      by_cases hfull : pc ∈ full
      · exact ih ((hdone.2 pc hfull hpc).2.2 a b hk).1
      · cases (hout pc hfull).symm.trans hk
    | @right pc a b y hk _ ih =>
      intro hpc
      by_cases hfull : pc ∈ full
      · exact ih ((hdone.2 pc hfull hpc).2.2 a b hk).2
      · cases (hout pc hfull).symm.trans hk
  have hxnot := key s x hsteps (hdone.1 hs)
  by_cases hfull : x ∈ full
  · exact (hdone.2 x hfull hxnot).1 hx
  · cases (hout x hfull).symm.trans hx

/-- A path from an instruction that ends a path goes nowhere. -/
theorem steps_stop {kind : Nat → Kind} {pc x : Nat} (hk : kind pc = .stop)
    (h : Steps kind pc x) : x = pc := by
  cases h with
  | here => rfl
  | one hk' _ => cases hk.symm.trans hk'
  | left hk' _ => cases hk.symm.trans hk'
  | right hk' _ => cases hk.symm.trans hk'

/-- A first value is the value of a member. -/
theorem first_some {α : Type} {f : Nat → Option α} {xs : List Nat} {v : α}
    (h : first f xs = some v) : ∃ x, x ∈ xs ∧ f x = some v := by
  induction xs with
  | nil => simp [first] at h
  | cons x xs ih =>
    simp only [first] at h
    cases hx : f x with
    | some w =>
      rw [hx] at h
      exact ⟨x, List.mem_cons_self, by rw [hx]; exact h⟩
    | none =>
      rw [hx] at h
      have ⟨y, hy, hv⟩ := ih h
      exact ⟨y, List.mem_cons_of_mem x hy, hv⟩

/-- A list with a member that has a value has a first value. -/
theorem first_isSome {α : Type} {f : Nat → Option α} {xs : List Nat} {x : Nat}
    (hx : x ∈ xs) (h : (f x).isSome) : (first f xs).isSome := by
  cases hv : first f xs with
  | some v => rfl
  | none =>
    have := (first_none f xs).mp hv x hx
    rw [this] at h
    cases h

/-- The first value among two lists of seeds one after the other. -/
theorem firstSeed_append (kind : Nat → Kind) {α : Type} (f : Nat → Option α) (fuel : Nat)
    (full xs ys : List Nat) :
    firstSeed kind f fuel full (xs ++ ys) =
      (firstSeed kind f fuel full xs).or (firstSeed kind f fuel full ys) := by
  induction xs with
  | nil => simp [firstSeed]
  | cons x xs ih =>
    simp only [List.cons_append, firstSeed, ih]
    cases first f (follow kind fuel full x).2 <;> simp

/-- A first value among seeds is the first value of one seed's walk. -/
theorem firstSeed_some {kind : Nat → Kind} {α : Type} {f : Nat → Option α} {fuel : Nat}
    {full seeds : List Nat} {v : α} (h : firstSeed kind f fuel full seeds = some v) :
    ∃ s, s ∈ seeds ∧ first f (follow kind fuel full s).2 = some v := by
  induction seeds with
  | nil => simp [firstSeed] at h
  | cons s seeds ih =>
    simp only [firstSeed] at h
    cases hs : first f (follow kind fuel full s).2 with
    | some w =>
      rw [hs] at h
      exact ⟨s, List.mem_cons_self, by rw [hs]; simpa using h⟩
    | none =>
      rw [hs] at h
      have ⟨y, hy, hv⟩ := ih (by simpa using h)
      exact ⟨y, List.mem_cons_of_mem s hy, hv⟩

end Stdx.Regex.Closure
