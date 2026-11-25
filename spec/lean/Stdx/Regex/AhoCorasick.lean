import Stdx.Regex.Search

/-!
# Claim R15: Aho and Corasick's search of a set of literals

A pattern that is an alternation of literals and nothing else matches where a literal stands, and
its order prefers the first literal of the alternation that stands at a start (decision 86, claim
R15). Once its DFAs give up, the searcher reads the text with the automaton of Aho and Corasick,
"Efficient string matching: an aid to bibliographic search", Communications of the ACM 18(6),
1975.

- `node lits w` is the longest suffix of `w` that starts a literal: the automaton's state after
  `w`. `node_step` proves that the state after one more byte depends on the state before alone,
  which is why a fail link serves. `failStep_eq` proves that the step by fail links, which the
  Zig code takes, is that state.
- `firstAt` is the literal the order prefers at a start, and `litText` the text of the set.
- `search` reads the text one byte at a time. It keeps the best match found, the least start
  and there the first literal, and stops where the state's text starts after that match.
- `search_answer` proves that the search gives the matcher's answer, `IsAnswer`.
-/
namespace Stdx.Regex.Aho

open Stdx.Regex.Search


/-- `u` starts some literal of the set. -/
def Starts (lits : List (List Nat)) (u : List Nat) : Bool :=
  lits.any fun l => u.isPrefixOf l

/-- The longest suffix of `w` that starts a literal: `w` itself where it does, and otherwise the
longest such suffix of its tail. -/
def node (lits : List (List Nat)) : List Nat → List Nat
  | [] => []
  | x :: rest => if Starts lits (x :: rest) then x :: rest else node lits rest

/-- The node of `w` is a suffix of `w`. -/
theorem node_suffix (lits : List (List Nat)) : ∀ w : List Nat, node lits w <:+ w
  | [] => List.suffix_refl _
  | x :: rest => by
    unfold node
    split
    · exact List.suffix_refl _
    · exact (node_suffix lits rest).trans (List.suffix_cons x rest)

/-- The node of `w` is empty, or it starts a literal. -/
theorem node_starts (lits : List (List Nat)) :
    ∀ w : List Nat, node lits w = [] ∨ Starts lits (node lits w) = true
  | [] => Or.inl rfl
  | x :: rest => by
    unfold node
    split
    · next h => exact Or.inr h
    · exact node_starts lits rest

/-- No suffix that starts a literal is longer than `node`. -/
theorem node_longest (lits : List (List Nat)) :
    ∀ w q : List Nat, q <:+ w → Starts lits q = true → q.length ≤ (node lits w).length
  | [], q, hq, _ => by
    have := hq.length_le
    simp at this
    simp [this]
  | x :: rest, q, hq, hs => by
    unfold node
    split
    · exact hq.length_le
    · next hw =>
      -- q is not the whole list, which starts no literal, so it is a suffix of the tail.
      have hne : q ≠ x :: rest := by
        intro h
        rw [h] at hs
        exact hw hs
      have hrest : q <:+ rest := by
        rcases List.suffix_cons_iff.mp hq with h | h
        · exact absurd h hne
        · exact h
      exact node_longest lits rest q hrest hs

/-- A prefix of what starts a literal starts it too. -/
theorem starts_prefix {lits : List (List Nat)} {p q : List Nat} (hp : p <+: q)
    (hq : Starts lits q = true) : Starts lits p = true := by
  unfold Starts at *
  rw [List.any_eq_true] at *
  obtain ⟨l, hl, hql⟩ := hq
  refine ⟨l, hl, ?_⟩
  rw [List.isPrefixOf_iff_prefix] at *
  exact hp.trans hql

/-- A suffix of `w ++ [c]` that ends with `d` is a suffix of `w` with `c` after it. -/
theorem suffix_concat {w q : List Nat} {c d : Nat} (h : q ++ [d] <:+ w ++ [c]) :
    d = c ∧ q <:+ w := by
  obtain ⟨t, ht⟩ := h
  rw [← List.append_assoc] at ht
  have := List.append_inj' ht rfl
  refine ⟨?_, ⟨t, this.1⟩⟩
  have h2 := this.2
  simp at h2
  exact h2

/-- Two suffixes of one list of the same length are equal. -/
theorem suffix_eq {a b w : List Nat} (ha : a <:+ w) (hb : b <:+ w) (hlen : a.length = b.length) :
    a = b :=
  (List.suffix_of_suffix_length_le ha hb (Nat.le_of_eq hlen)).eq_of_length hlen

/-- The node after one more byte depends on the node before alone. -/
theorem node_step (lits : List (List Nat)) (w : List Nat) (c : Nat) :
    node lits (w ++ [c]) = node lits (node lits w ++ [c]) := by
  have hsuf : node lits w ++ [c] <:+ w ++ [c] := by
    obtain ⟨p, hp⟩ := node_suffix lits w
    exact ⟨p, by rw [← List.append_assoc, hp]⟩
  -- The right side is a suffix of `w ++ [c]` that starts a literal, or empty.
  have hle : (node lits (node lits w ++ [c])).length ≤ (node lits (w ++ [c])).length := by
    rcases node_starts lits (node lits w ++ [c]) with h | h
    · rw [h]; exact Nat.zero_le _
    · exact node_longest lits (w ++ [c]) _ ((node_suffix lits _).trans hsuf) h
  -- The left side is empty, or a suffix of the node of `w` with `c` after it.
  have hge : (node lits (w ++ [c])).length ≤ (node lits (node lits w ++ [c])).length := by
    have hq := node_suffix lits (w ++ [c])
    rcases node_starts lits (w ++ [c]) with h | h
    · rw [h]; exact Nat.zero_le _
    · generalize hqdef : node lits (w ++ [c]) = q at h hq
      rcases List.eq_nil_or_concat q with hnil | ⟨q', d, hq'⟩
      · rw [hnil]; exact Nat.zero_le _
      · subst hq'
        rw [List.concat_eq_append] at h hq ⊢
        obtain ⟨hd, hq'w⟩ := suffix_concat hq
        subst hd
        have hs' : Starts lits q' = true := starts_prefix (List.prefix_append q' [d]) h
        have hlen := node_longest lits w q' hq'w hs'
        have hq'n : q' <:+ node lits w :=
          List.suffix_of_suffix_length_le hq'w (node_suffix lits w) hlen
        have : q' ++ [d] <:+ node lits w ++ [d] := by
          obtain ⟨t, ht⟩ := hq'n
          exact ⟨t, by rw [← List.append_assoc, ht]⟩
        exact node_longest lits _ _ this h
  exact suffix_eq (node_suffix lits _) ((node_suffix lits _).trans hsuf) (Nat.le_antisymm hge hle)

/-- A node is its own node. -/
theorem node_node (lits : List (List Nat)) (w : List Nat) : node lits (node lits w) = node lits w := by
  rcases node_starts lits w with h | h
  · rw [h]; rfl
  · generalize hn : node lits w = n at h
    cases n with
    | nil => rfl
    | cons x rest => simp [node, h]

/-- The automaton's step as Aho and Corasick take it: to the child where `u ++ [c]` starts a
literal, from the root to itself where `[c]` starts none, and otherwise the step from the fail
node, which is the node of `u` without its first byte. -/
def failStep (lits : List (List Nat)) : List Nat → Nat → List Nat
  | [], c => if Starts lits [c] then [c] else []
  | x :: rest, c =>
    if Starts lits (x :: rest ++ [c]) then x :: rest ++ [c] else failStep lits (node lits rest) c
termination_by u => u.length
decreasing_by
  have := (node_suffix lits rest).length_le
  simp at this ⊢
  omega

/-- The step by fail links is the node of the text read: the fail links serve. -/
theorem failStep_eq (lits : List (List Nat)) (c : Nat) :
    ∀ n u, u.length ≤ n → node lits u = u → failStep lits u c = node lits (u ++ [c]) := by
  intro n
  induction n with
  | zero =>
    intro u hu _
    have : u = [] := List.eq_nil_of_length_eq_zero (by omega)
    subst this
    simp [failStep, node]
  | succ n ih =>
    intro u hu hnode
    cases u with
    | nil => simp [failStep, node]
    | cons x rest =>
      have happ : x :: rest ++ [c] = x :: (rest ++ [c]) := rfl
      by_cases hs : Starts lits (x :: (rest ++ [c])) = true
      · have hn : node lits (x :: (rest ++ [c])) = x :: (rest ++ [c]) := by
          unfold node
          simp only [hs, ite_true]
        rw [failStep, happ]; simp only [hs, ite_true, hn]
      · have hn : node lits (x :: (rest ++ [c])) = node lits (rest ++ [c]) := by
          conv => lhs; unfold node
          simp only [hs, Bool.false_eq_true, ite_false]
        have hlen := (node_suffix lits rest).length_le
        simp only [List.length_cons] at hu
        rw [failStep, happ]
        simp only [hs, Bool.false_eq_true, ite_false]
        rw [hn, ih (node lits rest) (by omega) (node_node lits rest), ← node_step]

/-- `u` is one of the literals. -/
def isLit (lits : List (List Nat)) (u : List Nat) : Bool :=
  lits.contains u

/-- The longest suffix of `u` that is a literal. -/
def out (lits : List (List Nat)) : List Nat → Option (List Nat)
  | [] => none
  | x :: rest => if isLit lits (x :: rest) then some (x :: rest) else out lits rest

theorem out_spec (lits : List (List Nat)) :
    ∀ u l, out lits u = some l → l ∈ lits ∧ l <:+ u ∧ ∀ q, q <:+ u → q ∈ lits → q.length ≤ l.length
  | [], _, h => by simp [out] at h
  | x :: rest, l, h => by
    unfold out at h
    split at h
    · next hl =>
      cases h
      refine ⟨List.contains_iff_mem.mp hl, List.suffix_refl _, fun q hq _ => hq.length_le⟩
    · next hl =>
      obtain ⟨hm, hs, hmax⟩ := out_spec lits rest l h
      refine ⟨hm, hs.trans (List.suffix_cons x rest), fun q hq hqm => ?_⟩
      rcases List.suffix_cons_iff.mp hq with heq | hrest
      · subst heq
        exact absurd (List.contains_iff_mem.mpr hqm) hl
      · exact hmax q hrest hqm

theorem out_none (lits : List (List Nat)) :
    ∀ u, out lits u = none → ∀ q, q <:+ u → q ≠ [] → q ∉ lits
  | [], _, q, hq, hne, _ => by
    have := hq.length_le
    simp at this
    exact hne this
  | x :: rest, h, q, hq, hne, hqm => by
    unfold out at h
    split at h
    · cases h
    · next hl =>
      rcases List.suffix_cons_iff.mp hq with heq | hrest
      · subst heq
        exact hl (List.contains_iff_mem.mpr hqm)
      · exact out_none lits rest h q hrest hne hqm

/-- A literal starts itself, so a literal that ends `w` ends its node. -/
theorem lit_suffix_node {lits : List (List Nat)} {w q : List Nat} (hq : q <:+ w) (hm : q ∈ lits) :
    q <:+ node lits w := by
  have hs : Starts lits q = true := by
    unfold Starts
    rw [List.any_eq_true]
    exact ⟨q, hm, List.isPrefixOf_iff_prefix.mpr (List.prefix_refl q)⟩
  exact List.suffix_of_suffix_length_le hq (node_suffix lits w) (node_longest lits w q hq hs)

/-- The literal the order prefers at `s`: the first of the set that stands there. -/
def firstAt (lits : List (List Nat)) (t : List Nat) (s : Nat) : Option (List Nat) :=
  lits.find? fun l => l.isPrefixOf (t.drop s)

/-- A match found: its start, the rank of its literal, and its end. -/
abbrev Found := Nat × Nat × Nat

/-- True where `a` comes before `b`: it starts earlier, or at the same start with a lower rank. -/
def Found.better (a b : Found) : Bool :=
  a.1 < b.1 || (a.1 == b.1 && a.2.1 < b.2.1)

/-- The better of the best match found and a candidate. -/
def keep (best cand : Option Found) : Option Found :=
  match best, cand with
  | b, none => b
  | none, some c => some c
  | some b, some c => if c.better b then some c else some b

/-- The search over the bytes not read yet, from offset `i`, in the state `u`, with the best match
found. It stops where the state's text starts after the best match's start. -/
def go (lits : List (List Nat)) : List Nat → Nat → List Nat → Option Found → Option Found
  | [], _, _, best => best
  | c :: rest, i, u, best =>
    let u' := node lits (u ++ [c])
    let stop : Bool := match best with
      | some b => decide (b.1 < i + 1 - u'.length)
      | none => false
    if stop then best
    else go lits rest (i + 1) u' (keep best ((out lits u').map fun l => (i + 1 - l.length, lits.idxOf l, i + 1)))

/-- The search of `t` from its start: the span of the match it finds. -/
def search (lits : List (List Nat)) (t : List Nat) : Option (Nat × Nat) :=
  (go lits t 0 [] none).map fun b => (b.1, b.2.2)

/-- A literal stands at `s` and ends inside `pre`. -/
def OccIn (lits : List (List Nat)) (pre : List Nat) (s : Nat) (l : List Nat) : Prop :=
  l ∈ lits ∧ l <+: pre.drop s

/-- The best match found is the best among the literals that end inside `pre`. -/
def Best (lits : List (List Nat)) (pre : List Nat) : Option Found → Prop
  | none => ∀ s l, ¬ OccIn lits pre s l
  | some (s, k, e) => (∃ l, OccIn lits pre s l ∧ lits.idxOf l = k ∧ e = s + l.length) ∧
      ∀ s' l', OccIn lits pre s' l' → s ≤ s' ∧ (s' = s → k ≤ lits.idxOf l')

/-- A literal that ends inside `pre ++ [c]` ends inside `pre`, or ends at its last byte. -/
theorem occ_step {lits : List (List Nat)} (hne : ∀ l ∈ lits, l ≠ []) {pre : List Nat} {c s : Nat}
    {l : List Nat} :
    OccIn lits (pre ++ [c]) s l ↔
      OccIn lits pre s l ∨ (l ∈ lits ∧ l <:+ pre ++ [c] ∧ s + l.length = pre.length + 1) := by
  constructor
  · intro ⟨hm, hp⟩
    by_cases hs : s ≤ pre.length
    · rw [List.drop_append_of_le_length hs] at hp
      rcases List.prefix_concat_iff.mp hp with heq | hold
      · right
        refine ⟨hm, ?_, ?_⟩
        · rw [heq]
          exact ⟨pre.take s, by rw [← List.append_assoc, List.take_append_drop]⟩
        · rw [heq]
          simp
          omega
      · exact Or.inl ⟨hm, hold⟩
    · have : (pre ++ [c]).drop s = [] := by
        apply List.drop_eq_nil_of_le
        simp
        omega
      rw [this] at hp
      exact absurd (List.prefix_nil.mp hp) (hne l hm)
  · intro h
    rcases h with ⟨hm, hp⟩ | ⟨hm, hsuf, hlen⟩
    · refine ⟨hm, ?_⟩
      rw [List.drop_append]
      exact hp.trans (List.prefix_append _ _)
    · refine ⟨hm, ?_⟩
      have := List.suffix_iff_eq_drop.mp hsuf
      have hs : (pre ++ [c]).length - l.length = s := by
        simp
        omega
      rw [hs] at this
      rw [← this]
      exact List.prefix_refl l

/-- The candidate of a step is a literal that ends at the step's offset. -/
theorem cand_occ {lits : List (List Nat)} {pre : List Nat} {c : Nat} {lc : List Nat}
    (h : out lits (node lits (pre ++ [c])) = some lc) :
    lc ∈ lits ∧ lc <:+ pre ++ [c] ∧ (pre.length + 1 - lc.length) + lc.length = pre.length + 1 := by
  obtain ⟨hm, hs, _⟩ := out_spec lits _ lc h
  have hsuf := hs.trans (node_suffix lits (pre ++ [c]))
  refine ⟨hm, hsuf, ?_⟩
  have := hsuf.length_le
  simp at this
  omega

/-- Of the literals that end at the step's offset, the candidate starts first, and it is the one
literal that starts there. -/
theorem cand_least {lits : List (List Nat)} (hne : ∀ l ∈ lits, l ≠ []) {pre : List Nat} {c s : Nat}
    {l : List Nat} (hm : l ∈ lits) (hs : l <:+ pre ++ [c]) (hlen : s + l.length = pre.length + 1) :
    ∃ lc, out lits (node lits (pre ++ [c])) = some lc ∧ pre.length + 1 - lc.length ≤ s ∧
      (s = pre.length + 1 - lc.length → l = lc) := by
  have hnode := lit_suffix_node hs hm
  cases hout : out lits (node lits (pre ++ [c])) with
  | none => exact absurd hm (out_none lits _ hout l hnode (hne l hm))
  | some lc =>
    obtain ⟨_, hcs, hmax⟩ := out_spec lits _ lc hout
    have hle := hmax l hnode hm
    have hsuf := hcs.trans (node_suffix lits (pre ++ [c]))
    have hlc := hsuf.length_le
    simp at hlc
    refine ⟨lc, rfl, by omega, fun heq => ?_⟩
    exact suffix_eq hs hsuf (by omega)

/-- The candidate of the step after `pre`: the longest literal that ends at its last byte. -/
def candOf (lits : List (List Nat)) (pre : List Nat) (c : Nat) : Option Found :=
  (out lits (node lits (pre ++ [c]))).map fun l => (pre.length + 1 - l.length, lits.idxOf l, pre.length + 1)

/-- Each literal that ends inside `pre ++ [c]` ends inside `pre`, or starts no earlier than the
candidate, and at the candidate's start it is the candidate. -/
theorem occ_new {lits : List (List Nat)} (hne : ∀ l ∈ lits, l ≠ []) {pre : List Nat} {c : Nat}
    {lc : List Nat} (hout : out lits (node lits (pre ++ [c])) = some lc) {s : Nat} {l : List Nat}
    (h : OccIn lits (pre ++ [c]) s l) :
    OccIn lits pre s l ∨
      (pre.length + 1 - lc.length ≤ s ∧ (s = pre.length + 1 - lc.length → l = lc)) := by
  rcases (occ_step hne).mp h with hold | ⟨hm, hs, hlen⟩
  · exact Or.inl hold
  · obtain ⟨lc', hlc', hle, heq⟩ := cand_least hne hm hs hlen
    rw [hout] at hlc'
    cases hlc'
    exact Or.inr ⟨hle, heq⟩

/-- The best match after one more byte: the better of the best before and the candidate. -/
theorem best_step {lits : List (List Nat)} (hne : ∀ l ∈ lits, l ≠ []) {pre : List Nat} {c : Nat}
    {best : Option Found} (hb : Best lits pre best) :
    Best lits (pre ++ [c]) (keep best (candOf lits pre c)) := by
  unfold candOf
  cases hout : out lits (node lits (pre ++ [c])) with
  | none =>
    have hold : ∀ s l, OccIn lits (pre ++ [c]) s l → OccIn lits pre s l := by
      intro s l h
      rcases (occ_step hne).mp h with hold | ⟨hm, hs, hlen⟩
      · exact hold
      · obtain ⟨_, hlc, _⟩ := cand_least hne hm hs hlen
        rw [hout] at hlc
        cases hlc
    cases best with
    | none => exact fun s l h => hb s l (hold s l h)
    | some b =>
      obtain ⟨s, k, e⟩ := b
      obtain ⟨⟨l, hl, hk, he⟩, hmin⟩ := hb
      exact ⟨⟨l, (occ_step hne).mpr (Or.inl hl), hk, he⟩, fun s' l' h => hmin s' l' (hold s' l' h)⟩
  | some lc =>
    obtain ⟨hm, hs, hlen⟩ := cand_occ hout
    have hcocc : OccIn lits (pre ++ [c]) (pre.length + 1 - lc.length) lc :=
      (occ_step hne).mpr (Or.inr ⟨hm, hs, hlen⟩)
    cases best with
    | none =>
      refine ⟨⟨lc, hcocc, rfl, by omega⟩, fun s' l' h => ?_⟩
      rcases occ_new hne hout h with hold | ⟨h1, h2⟩
      · exact absurd hold (hb s' l')
      · exact ⟨h1, fun heq => by rw [h2 heq]; exact Nat.le_refl _⟩
    | some b =>
      obtain ⟨s, k, e⟩ := b
      obtain ⟨⟨l, hl, hk, he⟩, hmin⟩ := hb
      simp only [Option.map, keep]
      split
      · next hbetter =>
        simp [Found.better] at hbetter
        refine ⟨⟨lc, hcocc, rfl, by omega⟩, fun s' l' h => ?_⟩
        rcases occ_new hne hout h with hold | ⟨h1, h2⟩
        · obtain ⟨h1, h2⟩ := hmin s' l' hold
          rcases hbetter with hlt | ⟨heq, hlt⟩
          · exact ⟨by omega, fun h' => by omega⟩
          · exact ⟨by omega, fun h' => Nat.le_of_lt (Nat.lt_of_lt_of_le hlt (h2 (by omega)))⟩
        · exact ⟨h1, fun heq => by rw [h2 heq]; exact Nat.le_refl _⟩
      · next hworse =>
        simp [Found.better] at hworse
        refine ⟨⟨l, (occ_step hne).mpr (Or.inl hl), hk, he⟩, fun s' l' h => ?_⟩
        rcases occ_new hne hout h with hold | ⟨h1, h2⟩
        · exact hmin s' l' hold
        · obtain ⟨hge, hge2⟩ := hworse
          refine ⟨by omega, fun heq => ?_⟩
          have hs' : s' = pre.length + 1 - lc.length := by omega
          rw [h2 hs']
          exact hge2 (by omega)

/-- A literal that ends inside `pre` ends inside any text that `pre` starts. -/
theorem occ_mono {lits : List (List Nat)} {pre x : List Nat} {s : Nat} {l : List Nat}
    (h : OccIn lits pre s l) : OccIn lits (pre ++ x) s l := by
  refine ⟨h.1, ?_⟩
  rw [List.drop_append]
  exact h.2.trans (List.prefix_append _ _)

/-- A literal that starts before the state's text ends inside the text read: the state is the
longest suffix of that text that starts a literal. -/
theorem occ_before_state {lits : List (List Nat)} {pre rest : List Nat} {s : Nat} {l : List Nat}
    (hm : l ∈ lits) (hp : l <+: (pre ++ rest).drop s)
    (hs : s < pre.length - (node lits pre).length) : OccIn lits pre s l := by
  refine ⟨hm, ?_⟩
  have hsle : s ≤ pre.length := by omega
  rw [List.drop_append_of_le_length hsle] at hp
  have hd : pre.drop s <+: pre.drop s ++ rest := List.prefix_append _ _
  by_cases hlen : l.length ≤ (pre.drop s).length
  · exact List.prefix_of_prefix_length_le hp hd hlen
  · exfalso
    have hdl : pre.drop s <+: l := List.prefix_of_prefix_length_le hd hp (by omega)
    have hstarts : Starts lits (pre.drop s) = true := by
      unfold Starts
      rw [List.any_eq_true]
      exact ⟨l, hm, List.isPrefixOf_iff_prefix.mpr hdl⟩
    have := node_longest lits pre (pre.drop s) (List.drop_suffix s pre) hstarts
    simp at this
    omega

/-- The search over the rest of the text, from the end of `pre`, in the state of `pre`, finds the
best match of the whole text. -/
theorem go_best {lits : List (List Nat)} (hne : ∀ l ∈ lits, l ≠ []) :
    ∀ rest pre best, Best lits pre best →
      Best lits (pre ++ rest) (go lits rest pre.length (node lits pre) best)
  | [], pre, best, hb => by simpa [go] using hb
  | c :: rest, pre, best, hb => by
    have hu : node lits (node lits pre ++ [c]) = node lits (pre ++ [c]) := (node_step lits pre c).symm
    have happ : pre ++ c :: rest = (pre ++ [c]) ++ rest := by simp
    have hlen : (pre ++ [c]).length = pre.length + 1 := by simp
    cases best with
    | none =>
      have := go_best hne rest (pre ++ [c]) _ (best_step hne (c := c) hb)
      rw [happ]
      simpa [go, hu, candOf] using this
    | some b =>
      obtain ⟨s, k, e⟩ := b
      by_cases hstop : s < pre.length + 1 - (node lits (pre ++ [c])).length
      · have hgo : go lits (c :: rest) pre.length (node lits pre) (some (s, k, e)) = some (s, k, e) := by
          simp [go, hu, hstop]
        rw [hgo]
        obtain ⟨⟨l, hl, hk, he⟩, hmin⟩ := hb
        refine ⟨⟨l, occ_mono hl, hk, he⟩, fun s' l' h => ?_⟩
        by_cases hlt : s < s'
        · exact ⟨Nat.le_of_lt hlt, fun h' => by omega⟩
        · rw [happ] at h
          have hocc := occ_before_state h.1 h.2 (by omega)
          rcases (occ_step hne).mp hocc with hold | ⟨hm, hsuf, hend⟩
          · exact hmin s' l' hold
          · exfalso
            have := (lit_suffix_node hsuf hm).length_le
            omega
      · have hgo : go lits (c :: rest) pre.length (node lits pre) (some (s, k, e)) =
            go lits rest (pre ++ [c]).length (node lits (pre ++ [c])) (keep (some (s, k, e)) (candOf lits pre c)) := by
          simp [go, hu, hstop, candOf]
        rw [hgo, happ]
        exact go_best hne rest (pre ++ [c]) _ (best_step hne hb)

/-- The text of a set of literals, none empty: a match is a literal where it stands, and the
order prefers the first literal of the set that stands at a start. -/
def litText (lits : List (List Nat)) (hne : ∀ l ∈ lits, l ≠ []) (t : List Nat) : Text where
  len := t.length
  Match s e := ∃ l ∈ lits, l <+: t.drop s ∧ e = s + l.length
  Prefers s e := ∃ l, firstAt lits t s = some l ∧ e = s + l.length
  inside := by
    intro s e ⟨l, hm, hp, he⟩
    have := hp.length_le
    have hl : l.length ≠ 0 := fun h => hne l hm (List.eq_nil_of_length_eq_zero h)
    simp at this
    omega
  prefers_match := by
    intro s e ⟨l, hf, he⟩
    unfold firstAt at hf
    have hp := List.find?_some hf
    exact ⟨l, List.mem_of_find?_eq_some hf, List.isPrefixOf_iff_prefix.mp hp, he⟩
  prefers_some := by
    intro s e ⟨l, hm, hp, _⟩
    cases hf : firstAt lits t s with
    | none =>
      exfalso
      unfold firstAt at hf
      exact List.find?_eq_none.mp hf l hm (List.isPrefixOf_iff_prefix.mpr hp)
    | some l' => exact ⟨s + l'.length, l', rfl, rfl⟩
  prefers_one := by
    intro s e e' ⟨l, hf, he⟩ ⟨l', hf', he'⟩
    rw [hf] at hf'
    cases hf'
    omega

/-- The first element that a test takes comes no later than any other it takes. -/
theorem find?_idxOf_le {p : List Nat → Bool} :
    ∀ {xs : List (List Nat)} {y x : List Nat}, xs.find? p = some y → p x = true → x ∈ xs →
      xs.idxOf y ≤ xs.idxOf x
  | [], _, _, h, _, _ => by simp at h
  | z :: zs, y, x, h, hx, hmem => by
    rw [List.find?_cons] at h
    split at h
    · cases h
      simp [List.idxOf_cons]
    · next hz =>
      have hzx : z ≠ x := fun heq => by rw [heq] at hz; simp [hx] at hz
      have hzy : z ≠ y := fun heq => by
        rw [heq] at hz; simp [List.find?_some h] at hz
      have hxs : x ∈ zs := by
        rcases List.mem_cons.mp hmem with heq | hin
        · exact absurd heq.symm hzx
        · exact hin
      have := find?_idxOf_le h hx hxs
      simp [List.idxOf_cons, hzx, hzy]
      exact this

/-- Two members of a list at one place are one. -/
theorem idxOf_inj {xs : List (List Nat)} {a b : List Nat} (ha : a ∈ xs) (hb : b ∈ xs)
    (h : xs.idxOf a = xs.idxOf b) : a = b := by
  have ha' := List.idxOf_lt_length_iff.mpr ha
  have hb' := List.idxOf_lt_length_iff.mpr hb
  have e1 := List.getElem_idxOf ha'
  have e2 := List.getElem_idxOf hb'
  simp only [h] at e1
  exact e1.symm.trans e2

/-- The search of a text from its start gives the matcher's answer. -/
theorem search_answer {lits : List (List Nat)} (hne : ∀ l ∈ lits, l ≠ []) (t : List Nat) :
    IsAnswer (litText lits hne t) 0 (search lits t) := by
  have h0 : Best lits [] none := by
    intro s l ⟨hm, hp⟩
    simp at hp
    exact hne l hm hp
  have hb := go_best hne t [] none h0
  simp only [List.nil_append, List.length_nil] at hb
  have hnode : node lits [] = [] := rfl
  rw [hnode] at hb
  unfold search
  cases hgo : go lits t 0 [] none with
  | none =>
    rw [hgo] at hb
    intro s e _ ⟨l, hm, hp, _⟩
    exact hb s l ⟨hm, hp⟩
  | some b =>
    obtain ⟨s, k, e⟩ := b
    rw [hgo] at hb
    obtain ⟨⟨l, ⟨hm, hp⟩, hk, he⟩, hmin⟩ := hb
    refine ⟨Nat.zero_le _, ?_, fun s' e' _ ⟨l', hm', hp', _⟩ => (hmin s' l' ⟨hm', hp'⟩).1⟩
    -- The first literal that stands at `s` is `l`: no literal that stands there comes before it.
    cases hf : firstAt lits t s with
    | none =>
      exfalso
      unfold firstAt at hf
      exact List.find?_eq_none.mp hf l hm (List.isPrefixOf_iff_prefix.mpr hp)
    | some y =>
      have hfirst : firstAt lits t s = some y := hf
      unfold firstAt at hf
      have hym := List.mem_of_find?_eq_some hf
      have hyp0 := List.find?_some hf
      have hyp := List.isPrefixOf_iff_prefix.mp hyp0
      have h1 := find?_idxOf_le hf (p := fun l => l.isPrefixOf (t.drop s)) (List.isPrefixOf_iff_prefix.mpr hp) hm
      have h2 := (hmin s y ⟨hym, hyp⟩).2 rfl
      have hy : y = l := idxOf_inj hym hm (by omega)
      exact ⟨y, hfirst, by rw [hy, he]⟩

/-- The search from `low`: the automaton starts at its root there, as a search of the text after
`low`, and the span it finds moves back by `low`. -/
def searchFrom (lits : List (List Nat)) (t : List Nat) (low : Nat) : Option (Nat × Nat) :=
  (search lits (t.drop low)).map fun span => (span.1 + low, span.2 + low)

/-- The search from `low` gives the matcher's answer from `low`. -/
theorem searchFrom_answer {lits : List (List Nat)} (hne : ∀ l ∈ lits, l ≠ []) (t : List Nat)
    (low : Nat) : IsAnswer (litText lits hne t) low (searchFrom lits t low) := by
  have ha := search_answer hne (t.drop low)
  have hdrop : ∀ s, low ≤ s → (t.drop low).drop (s - low) = t.drop s := by
    intro s hs
    rw [List.drop_drop]
    congr 1
    omega
  unfold searchFrom
  cases hsearch : search lits (t.drop low) with
  | none =>
    rw [hsearch] at ha
    intro s e hlow ⟨l, hm, hp, _⟩
    exact ha (s - low) (s - low + l.length) (Nat.zero_le _) ⟨l, hm, by rw [hdrop s hlow]; exact hp, rfl⟩
  | some span =>
    obtain ⟨s, e⟩ := span
    rw [hsearch] at ha
    obtain ⟨_, ⟨l, hf, he⟩, hmin⟩ := ha
    refine ⟨by omega, ⟨l, ?_, by simp; omega⟩, fun s' e' hlow ⟨l', hm', hp', _⟩ => ?_⟩
    · have := hdrop (s + low) (by omega)
      simp only [Nat.add_sub_cancel] at this
      unfold firstAt at hf ⊢
      rw [← this]
      exact hf
    · have := hmin (s' - low) (s' - low + l'.length) (Nat.zero_le _)
        ⟨l', hm', by rw [hdrop s' hlow]; exact hp', rfl⟩
      simp
      omega

/-! ## The search on small sets -/

/-- `abcd` and `bc`, the first preferred: in `xabcdy` the match is `abcd`, which starts first,
though `bc` ends first. -/
example : searchFrom [[1, 2, 3, 4], [2, 3]] [9, 1, 2, 3, 4, 9] 0 = some (1, 5) := by decide

/-- `ab` before `abc`: at one start the order prefers the first literal, though it is shorter. -/
example : searchFrom [[1, 2], [1, 2, 3]] [1, 2, 3] 0 = some (0, 2) := by decide

/-- `abc` before `ab`: the longer literal comes first in the order, so it wins. -/
example : searchFrom [[1, 2, 3], [1, 2]] [1, 2, 3] 0 = some (0, 3) := by decide

/-- `abc` before `ab`, where `abc` does not stand: the search falls back to `ab`. -/
example : searchFrom [[1, 2, 3], [1, 2]] [1, 2, 4] 0 = some (0, 2) := by decide

end Stdx.Regex.Aho
