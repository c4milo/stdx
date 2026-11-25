import Stdx.Regex.RulesWide
import Stdx.Regex.Inner

/-!
# Claim R14 over a program: the search from a literal inside a match

Claim R14 goes to the places of a literal that every match holds in its middle, as `@` in
`\w+@\w+` (decision 86, `dfa_inner.zig`, `searcher_inner.zig`). `Inner.lean` proves the search
over scans that it takes as given. This file gives those scans for a program.

The reverse program takes the literal's bytes one after another from an instruction, `cut`,
and stands at `before` after them. Two walks say so, and each has a check here:

- `chainTo`: the walk of the literal from `cut` stands at `before`. `Literal.walk` goes on
  through the saves and jumps after the last byte, so the check does too.
- `passesOn`: every path from the reverse program's entry to `match` passes `cut`
  (`dfa_inner.every_match_passes`). `passes_split` proves it from a set that `passesOk` checks,
  and reads nothing of how the set was built.

`innerOf` is `Search.Inner` for such a program. The part of a match before the literal is a
path of the reverse program from `before`. The part after it is a path from the entry to
`cut`, and then through the literal's instructions: an assertion among them holds on that
path, so the three parts make a match. `backBefore` is the reverse DFA's scan from its second
start, which is `scanBack` from `before`.

`RulesInner.lean` decides the rule for the part before the literal, and proves the search.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Search

/-! ## A path's first part through a literal -/

/-- A path from `pc` to `match` goes through the literal's instructions first: its first part
is a path from `pc` to `stop` over the literal's bytes. -/
theorem chain_prefix {prog : Array Inst} {text : List Nat} {pc stop : Nat} {literal : List Nat}
    (hchain : Chain prog pc literal stop) :
    ∀ {i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done →
      Path prog text pc i stop (i + literal.length) := by
  induction hchain with
  | stop => intro i pc' j _ _; exact .here
  | save hinst _ ih =>
    intro i pc' j hpath hdone
    cases hpath with
    | here => simp [hinst] at hdone
    | free hfree hrest =>
      cases hfree with
      | splitOut h => simp [hinst] at h
      | splitArg h => simp [hinst] at h
      | save h => simp [hinst] at h; exact .free (.save hinst) (ih (h.2 ▸ hrest) hdone)
      | jump h => simp [hinst] at h
      | look h _ => simp [hinst] at h
    | take _ htakes _ =>
      cases htakes with
      | range h _ _ => simp [hinst] at h
      | member h _ _ _ _ => simp [hinst] at h
  | jump hinst _ ih =>
    intro i pc' j hpath hdone
    cases hpath with
    | here => simp [hinst] at hdone
    | free hfree hrest =>
      cases hfree with
      | splitOut h => simp [hinst] at h
      | splitArg h => simp [hinst] at h
      | save h => simp [hinst] at h
      | jump h => simp [hinst] at h; exact .free (.jump hinst) (ih (h ▸ hrest) hdone)
      | look h _ => simp [hinst] at h
    | take _ htakes _ =>
      cases htakes with
      | range h _ _ => simp [hinst] at h
      | member h _ _ _ _ => simp [hinst] at h
  | look hinst _ ih =>
    intro i pc' j hpath hdone
    cases hpath with
    | here => simp [hinst] at hdone
    | free hfree hrest =>
      cases hfree with
      | splitOut h => simp [hinst] at h
      | splitArg h => simp [hinst] at h
      | save h => simp [hinst] at h
      | jump h => simp [hinst] at h
      | look h hholds =>
        simp [hinst] at h
        obtain ⟨hl, hout⟩ := h
        subst hl
        exact .free (.look hinst hholds) (ih (hout ▸ hrest) hdone)
    | take _ htakes _ =>
      cases htakes with
      | range h _ _ => simp [hinst] at h
      | member h _ _ _ _ => simp [hinst] at h
  | @byte pc b out stop literal hinst _ ih =>
    intro i pc' j hpath hdone
    cases hpath with
    | here => simp [hinst] at hdone
    | free hfree _ =>
      cases hfree with
      | splitOut h => simp [hinst] at h
      | splitArg h => simp [hinst] at h
      | save h => simp [hinst] at h
      | jump h => simp [hinst] at h
      | look h _ => simp [hinst] at h
    | @take _ _ c mid _ _ hbyte htakes hrest =>
      cases htakes with
      | member h _ _ _ _ => simp [hinst] at h
      | range h hlo hhi =>
        simp [hinst] at h
        obtain ⟨hlo', hhi', hout⟩ := h
        have hc : c = b := by omega
        subst hc
        have hgo := ih (hout ▸ hrest) hdone
        have hidx : i + (c :: literal).length = i + 1 + literal.length := by
          simp only [List.length_cons]; omega
        rw [hidx]
        exact .take hbyte (.range hinst (Nat.le_refl _) (Nat.le_refl _)) hgo

/-! ## The walk of a literal to a named instruction -/

/-- Whether the program takes the bytes of `walked` one after another from `pc`, through
saves, jumps and assertions, and stands at `stop` after them, in at most `fuel` moves. The
walk may go on through such moves after the last byte, as `Literal.walk` does. -/
def chainTo (prog : Array Inst) (stop : Nat) : Nat → Nat → List Nat → Bool
  | 0, pc, walked => walked.isEmpty && pc == stop
  | fuel + 1, pc, walked =>
    (walked.isEmpty && pc == stop) ||
      match prog[pc]? with
      | some (.save _ out) => chainTo prog stop fuel out walked
      | some (.jump out) => chainTo prog stop fuel out walked
      | some (.look _ out) => chainTo prog stop fuel out walked
      | some (.range lo hi out) =>
        match walked with
        | b :: rest => lo == b && hi == b && chainTo prog stop fuel out rest
        | [] => false
      | _ => false

/-- A walk that ends where no byte is left stands at `stop`. -/
theorem chain_of_stopped {prog : Array Inst} {stop pc : Nat} {walked : List Nat}
    (h : (walked.isEmpty && pc == stop) = true) : Chain prog pc walked stop := by
  simp only [Bool.and_eq_true, List.isEmpty_iff, beq_iff_eq] at h
  obtain ⟨hw, hpc⟩ := h
  subst hw
  subst hpc
  exact .stop

/-- A walk that `chainTo` follows is a `Chain`. -/
theorem chain_of_chainTo {prog : Array Inst} {stop : Nat} :
    ∀ fuel pc walked, chainTo prog stop fuel pc walked = true → Chain prog pc walked stop := by
  intro fuel
  induction fuel with
  | zero => intro pc walked h; exact chain_of_stopped h
  | succ fuel ih =>
    intro pc walked h
    simp only [chainTo, Bool.or_eq_true] at h
    cases h with
    | inl hstop => exact chain_of_stopped hstop
    | inr hmove =>
      cases hp : prog[pc]? with
      | none => simp [hp] at hmove
      | some inst =>
        cases inst with
        | save slot out => exact .save hp (ih out walked (by simpa [hp] using hmove))
        | jump out => exact .jump hp (ih out walked (by simpa [hp] using hmove))
        | look l out => exact .look hp (ih out walked (by simpa [hp] using hmove))
        | range lo hi out =>
          cases walked with
          | nil => simp [hp] at hmove
          | cons b rest =>
            simp only [hp, Bool.and_eq_true, beq_iff_eq] at hmove
            obtain ⟨⟨hlo, hhi⟩, hrest⟩ := hmove
            subst hlo
            subst hhi
            exact .byte hp (ih out rest hrest)
        | ranges count => simp [hp] at hmove
        | split out arg => simp [hp] at hmove
        | done => simp [hp] at hmove
        | fail => simp [hp] at hmove

/-! ## An instruction that every match passes -/

/-- The moves of an instruction in a walk that stops at `cut`. -/
def successorsBut (prog : Array Inst) (cut pc : Nat) : List Nat :=
  if pc = cut then [] else successors prog pc

/-- The set shows that every path from `entry` to `match` passes `cut`: it holds `entry`, and
each member that is not `cut` is no `match` and leads to members alone. -/
def passesOk (prog : Array Inst) (entry cut : Nat) (set : List Nat) : Bool :=
  set.contains entry &&
    set.all fun x => x == cut || (!isDone prog x && (successors prog x).all (set.contains ·))

/-- Where the set is right, a path from a member to `match` has a first part that ends at
`cut`. -/
theorem passes_split {prog : Array Inst} {text : List Nat} {entry cut : Nat} {set : List Nat}
    (h : passesOk prog entry cut set = true) :
    ∀ {pc i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done → pc ∈ set →
      ∃ k, Path prog text pc i cut k ∧ Path prog text cut k pc' j := by
  simp only [passesOk, Bool.and_eq_true] at h
  obtain ⟨_, hall⟩ := h
  have hstep : ∀ x, x ∈ set → x ≠ cut →
      isDone prog x = false ∧ ∀ y, y ∈ successors prog x → y ∈ set := by
    intro x hx hne
    have hx' := List.all_eq_true.mp hall x hx
    simp only [Bool.or_eq_true, beq_iff_eq, Bool.and_eq_true, Bool.not_eq_true'] at hx'
    cases hx' with
    | inl heq => exact absurd heq hne
    | inr hr =>
      exact ⟨hr.1, fun y hy => List.contains_iff_mem.mp (List.all_eq_true.mp hr.2 y hy)⟩
  intro pc i pc' j hpath
  induction hpath with
  | @here pc i =>
    intro hdone hmem
    by_cases hc : pc = cut
    · subst hc
      exact ⟨i, .here, .here⟩
    · have hnot := (hstep pc hmem hc).1
      rw [isDone_iff.mpr hdone] at hnot
      cases hnot
  | @free pc i mid pc' j hfree hrest ih =>
    intro hdone hmem
    by_cases hc : pc = cut
    · subst hc
      exact ⟨i, .here, .free hfree hrest⟩
    · obtain ⟨k, h1, h2⟩ := ih hdone ((hstep pc hmem hc).2 mid (edge_successor hfree.edge))
      exact ⟨k, .free hfree h1, h2⟩
  | @take pc i b mid pc' j hbyte htakes hrest ih =>
    intro hdone hmem
    by_cases hc : pc = cut
    · subst hc
      exact ⟨i, .here, .take hbyte htakes hrest⟩
    · obtain ⟨k, h1, h2⟩ :=
        ih hdone ((hstep pc hmem hc).2 mid (edge_successor (.takes htakes)))
      exact ⟨k, .take hbyte htakes h1, h2⟩

/-- `dfa_inner.every_match_passes`, decided: the set that a walk from `entry` gives, where it
stops at `cut`, shows that every path from `entry` to `match` passes `cut`. -/
def passesOn (prog : Array Inst) (entry cut : Nat) : Bool :=
  passesOk prog entry cut (growBy (successorsBut prog cut) (prog.size + 1) [entry])

/-- Where `passesOn` holds, a path from `entry` to `match` has a first part that ends at
`cut`. -/
theorem passesOn_split {prog : Array Inst} {text : List Nat} {entry cut : Nat}
    (h : passesOn prog entry cut = true) {i pc' j : Nat}
    (hpath : Path prog text entry i pc' j) (hdone : prog[pc']? = some .done) :
    ∃ k, Path prog text entry i cut k ∧ Path prog text cut k pc' j := by
  have hentry : entry ∈ growBy (successorsBut prog cut) (prog.size + 1) [entry] := by
    simp only [passesOn, passesOk, Bool.and_eq_true] at h
    exact List.contains_iff_mem.mp h.1
  exact passes_split h hpath hdone hentry

/-! ## The reverse scan from the second start -/

/-- The reverse scan from an instruction gives a start, at or after `low`, of a path from the
instruction to `match` over the text read backward from `e`. -/
theorem scanBack_accepts {rev : Array Inst} {start : Nat} {text : List Nat} {low e s : Nat}
    (hlow : low ≤ e) (he : e ≤ text.length) (h : scanBack rev start text low e = some s) :
    low ≤ s ∧ s ≤ e ∧ Accepts rev text.reverse start (text.length - e) (text.length - s) := by
  unfold scanBack at h
  cases hrun : runLongest rev text.reverse (e - low + 1) (text.length - e) [start] none with
  | none => rw [hrun] at h; cases h
  | some j =>
    rw [hrun] at h
    have hs : text.length - j = s := by simpa using h
    cases runLongest_sound rev text.reverse _ _ _ _ j hrun with
    | inl hbest => cases hbest
    | inr hr =>
      obtain ⟨h1, h2, s', hs', hacc⟩ := hr
      have hentry : s' = start := by simpa using hs'
      subst hentry
      have hidx : text.length - s = j := by omega
      refine ⟨by omega, by omega, ?_⟩
      rw [hidx]
      exact hacc

/-- The reverse scan from an instruction gives the least such start. -/
theorem scanBack_accepts_least {rev : Array Inst} {start : Nat} {text : List Nat}
    (hexact : Exact rev) {low e s s' : Nat} (he : e ≤ text.length)
    (h : scanBack rev start text low e = some s) (hs' : low ≤ s') (hse : s' ≤ e)
    (hacc : Accepts rev text.reverse start (text.length - e) (text.length - s')) : s ≤ s' := by
  obtain ⟨j, hrun, hj⟩ := runLongest_complete rev text.reverse hexact (e - low + 1)
    (text.length - e) [start] none (text.length - s') ⟨start, by simp, hacc⟩ (by omega)
  unfold scanBack at h
  rw [hrun] at h
  have hs : text.length - j = s := by simpa using h
  omega

/-- The reverse scan from an instruction gives nothing where no such path starts at or after
`low`. -/
theorem scanBack_accepts_none {rev : Array Inst} {start : Nat} {text : List Nat}
    (hexact : Exact rev) {low e s' : Nat} (he : e ≤ text.length)
    (h : scanBack rev start text low e = none) (hs' : low ≤ s') (hse : s' ≤ e) :
    ¬ Accepts rev text.reverse start (text.length - e) (text.length - s') := by
  intro hacc
  obtain ⟨j, hrun, _⟩ := runLongest_complete rev text.reverse hexact (e - low + 1)
    (text.length - e) [start] none (text.length - s') ⟨start, by simp, hacc⟩ (by omega)
  unfold scanBack at h
  rw [hrun] at h
  simp at h

/-! ## The literal inside a match, over a program -/

/-- `Search.Inner` for a program, a text and a literal that the reverse program takes from
`cut`, an instruction that every match passes. `walked` holds the literal's bytes from its last
to its first. The part before the literal is a path of the reverse program from `before`, and
the part after it is a path from the entry to `cut` and through the literal's instructions.
`backBefore` is the reverse DFA's scan from its second start, `before`. -/
def innerOf {prog rev : Array Inst} {entry reventry cut before : Nat} {text walked : List Nat}
    {starts : Nat → Bool} (hexact : Exact prog) (hrevexact : Exact rev)
    (hrev : Reverses prog entry rev reventry text)
    (hclean : StartsClean prog entry text starts) (hlit : 0 < walked.reverse.length)
    (hpasses : passesOn rev reventry cut = true) (hchain : Chain rev cut walked before) :
    Inner (textOf prog entry text starts hexact)
      (scansOf hexact hrevexact hrev hclean walked.reverse hlit) where
  Before := fun s p => s ≤ p ∧ p ≤ text.length ∧
    Accepts rev text.reverse before (text.length - p) (text.length - s)
  After := fun q e => walked.length ≤ q ∧ q ≤ e ∧ e ≤ text.length ∧
    Path rev text.reverse reventry (text.length - e) cut (text.length - q) ∧
    Path rev text.reverse cut (text.length - q) before (text.length - q + walked.length)
  backBefore := fun low p =>
    if low ≤ p ∧ p ≤ text.length then scanBack rev before text low p else none
  before_inside := fun h => h.1
  split := by
    intro s e hm
    have hin := matches_inside hm.1 hm.2.2
    obtain ⟨pc, hpath, hdone⟩ := reversed_match hexact hrev hm
    obtain ⟨k, hto, hfrom⟩ := passesOn_split hpasses hpath hdone
    have ⟨hbytes, hrest⟩ := chain_path hchain hfrom hdone
    have hprefix := chain_prefix hchain hfrom hdone
    have h1 := hto.le
    have h2 := hrest.le
    have hlen : walked.reverse.length = walked.length := List.length_reverse
    refine ⟨text.length - k - walked.length, ⟨by omega, by omega, pc, ?_, hdone⟩, ?_, ?_⟩
    · have hidx : text.length - (text.length - k - walked.length) = k + walked.length := by
        omega
      rw [hidx]
      exact hrest
    · show text.length - k - walked.length + walked.reverse.length ≤ text.length ∧
        StandsAt text walked.reverse (text.length - k - walked.length)
      refine ⟨by omega, ?_⟩
      intro j hj
      rw [walked_byte (by omega)]
      have h := hbytes (walked.length - 1 - j) (by omega)
      rw [reverse_byte (by omega)] at h
      have hidx : text.length - 1 - (k + (walked.length - 1 - j)) =
          text.length - k - walked.length + j := by omega
      rw [hidx] at h
      exact h
    · show walked.length ≤ text.length - k - walked.length + walked.reverse.length ∧
        text.length - k - walked.length + walked.reverse.length ≤ e ∧ e ≤ text.length ∧
        Path rev text.reverse reventry (text.length - e) cut
          (text.length - (text.length - k - walked.length + walked.reverse.length)) ∧
        Path rev text.reverse cut
          (text.length - (text.length - k - walked.length + walked.reverse.length)) before
          (text.length - (text.length - k - walked.length + walked.reverse.length) +
            walked.length)
      have hq : text.length - (text.length - k - walked.length + walked.reverse.length) = k := by
        omega
      rw [hq]
      exact ⟨by omega, by omega, hin.2, hto, hprefix⟩
  join := by
    intro s p e hb _ ha
    obtain ⟨hsp, hp, pc, hpath, hdone⟩ := hb
    have hlen : walked.reverse.length = walked.length := List.length_reverse
    have ha' : walked.length ≤ p + walked.reverse.length ∧
        p + walked.reverse.length ≤ e ∧ e ≤ text.length ∧
        Path rev text.reverse reventry (text.length - e) cut
          (text.length - (p + walked.reverse.length)) ∧
        Path rev text.reverse cut (text.length - (p + walked.reverse.length)) before
          (text.length - (p + walked.reverse.length) + walked.length) := ha
    obtain ⟨_, hqe, he, hto, hliteral⟩ := ha'
    have hidx : text.length - (p + walked.reverse.length) + walked.length = text.length - p := by
      omega
    rw [hidx] at hliteral
    have hm := (hrev s e (by omega) he).mpr ⟨pc, (hto.trans hliteral).trans hpath, hdone⟩
    exact ⟨by omega, hclean s e (by omega) hm, hm⟩
  back_some := by
    intro low p s h
    by_cases hguard : low ≤ p ∧ p ≤ text.length
    · rw [ite_eq_left hguard] at h
      obtain ⟨h1, h2, hacc⟩ := scanBack_accepts hguard.1 hguard.2 h
      exact ⟨h1, h2, hguard.2, hacc⟩
    · rw [ite_eq_right hguard] at h
      cases h
  back_least := by
    intro low p s s' h hlow hb
    obtain ⟨hsp, hp, hacc⟩ := hb
    have hguard : low ≤ p ∧ p ≤ text.length := ⟨by omega, hp⟩
    rw [ite_eq_left hguard] at h
    exact scanBack_accepts_least hrevexact hp h hlow hsp hacc
  back_none := by
    intro low p s h hlow hb
    obtain ⟨hsp, hp, hacc⟩ := hb
    have hguard : low ≤ p ∧ p ≤ text.length := ⟨by omega, hp⟩
    rw [ite_eq_left hguard] at h
    exact scanBack_accepts_none hrevexact hp h hlow hsp hacc

end Stdx.Regex.Matcher
