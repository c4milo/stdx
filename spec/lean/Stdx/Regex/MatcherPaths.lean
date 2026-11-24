import Stdx.Regex.Matcher
import Stdx.Regex.Search

/-!
# The backtracking matcher's ends are the ends of the program's paths

`Matcher.lean` holds the matcher to a backtracking matcher. This file holds that backtracking
matcher to the paths of `Program.lean`, and so gives the matches of a program as `Search.lean`
asks for them.

- `backtrack_sound`: an end that the backtracking matcher finds is the end of a path from a
  seed to `match`.
- `backtrack_complete`: where a path leads from an instruction to `match`, the backtracking
  matcher finds an end from that instruction. It needs `Exact`: `step` gives the instruction
  that a thread goes to, whichever range of a node takes the byte. The builder writes a node's
  ranges apart, so one range at most takes a byte, and this file takes that as a hypothesis.
- `textOf`: the matches of a program in a text, and the end that the pattern's order prefers
  from each start, as a `Search.Text`. Every claim's theorem is about such a text.
-/
namespace Stdx.Regex.Program

/-- Two paths, the second from where the first ends, make one path. -/
theorem Path.trans {prog : Array Inst} {text : List Nat} {a i b j c k : Nat}
    (h1 : Path prog text a i b j) (h2 : Path prog text b j c k) : Path prog text a i c k := by
  induction h1 with
  | here => exact h2
  | free hfree _ ih => exact .free hfree (ih h2)
  | take hbyte htakes _ ih => exact .take hbyte htakes (ih h2)

/-- A path from inside a text ends inside it. -/
theorem Path.le_len {prog : Array Inst} {text : List Nat} {pc i pc' j : Nat}
    (h : Path prog text pc i pc' j) (hi : i ≤ text.length) : j ≤ text.length := by
  induction h with
  | here => exact hi
  | free _ _ ih => exact ih hi
  | @take pc i b mid pc' j hbyte _ _ ih =>
    apply ih
    apply Nat.succ_le_of_lt
    apply Nat.lt_of_not_le
    intro hle
    rw [List.getElem?_eq_none hle] at hbyte
    cases hbyte

end Stdx.Regex.Program

namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Closure

/-- The matcher's reading of an instruction that leads to one other is a move of a path. -/
theorem kindAt_one {prog : Array Inst} {text : List Nat} {i pc a : Nat}
    (h : kindAt prog text i pc = .one a) : Free prog text i pc a := by
  unfold kindAt at h
  cases hp : prog[pc]? with
  | none => simp [hp] at h
  | some inst =>
    cases inst with
    | range lo hi out => simp [hp] at h
    | ranges count => simp [hp] at h
    | split out arg => simp [hp] at h
    | save slot out =>
      simp [hp] at h
      subst h
      exact .save hp
    | look l out =>
      by_cases hh : l.holds (behind text i) (ahead text i) = true
      · simp [hp, hh] at h
        subst h
        exact .look hp hh
      · simp [hp, hh] at h
    | jump out =>
      simp [hp] at h
      subst h
      exact .jump hp
    | done => simp [hp] at h
    | fail => simp [hp] at h

/-- The matcher's reading of a split is the two moves of a path. -/
theorem kindAt_two {prog : Array Inst} {text : List Nat} {i pc a b : Nat}
    (h : kindAt prog text i pc = .two a b) : Free prog text i pc a ∧ Free prog text i pc b := by
  unfold kindAt at h
  cases hp : prog[pc]? with
  | none => simp [hp] at h
  | some inst =>
    cases inst with
    | range lo hi out => simp [hp] at h
    | ranges count => simp [hp] at h
    | split out arg =>
      simp [hp] at h
      obtain ⟨rfl, rfl⟩ := h
      exact ⟨.splitOut hp, .splitArg hp⟩
    | save slot out => simp [hp] at h
    | look l out =>
      by_cases hh : l.holds (behind text i) (ahead text i) = true
      · simp [hp, hh] at h
      · simp [hp, hh] at h
    | jump out => simp [hp] at h
    | done => simp [hp] at h
    | fail => simp [hp] at h

/-- A path of the matcher's walk at an offset is a path of the program that takes no byte. -/
theorem steps_path {prog : Array Inst} {text : List Nat} {i pc x : Nat}
    (h : Steps (kindAt prog text i) pc x) : Path prog text pc i x i := by
  induction h with
  | here => exact .here
  | one hk _ ih => exact .free (kindAt_one hk) ih
  | left hk _ ih => exact .free (kindAt_two hk).1 ih
  | right hk _ ih => exact .free (kindAt_two hk).2 ih

/-- A move of a path that takes no byte is a move of the matcher's walk. -/
theorem free_step {prog : Array Inst} {text : List Nat} {i pc mid x : Nat}
    (hfree : Free prog text i pc mid) (hrest : Steps (kindAt prog text i) mid x) :
    Steps (kindAt prog text i) pc x := by
  cases hfree with
  | splitOut hp =>
    rename_i arg
    exact .left (b := arg) (by simp [kindAt, hp]) hrest
  | splitArg hp =>
    rename_i out
    exact .right (a := out) (by simp [kindAt, hp]) hrest
  | save hp => exact .one (by simp [kindAt, hp]) hrest
  | jump hp => exact .one (by simp [kindAt, hp]) hrest
  | look hp hh => exact .one (by simp [kindAt, hp, hh]) hrest

/-- `isDone` holds for `match` alone. -/
theorem isDone_iff {prog : Array Inst} {pc : Nat} :
    isDone prog pc = true ↔ prog[pc]? = some .done := by
  unfold isDone
  cases hp : prog[pc]? with
  | none => simp
  | some inst => cases inst <;> simp

/-- A range that `stepRanges` finds is one of the node's ranges, and holds the byte. -/
theorem stepRanges_takes {prog : Array Inst} {b out : Nat} :
    ∀ count index, stepRanges prog index count b = some out →
      ∃ j lo hi, j < count ∧ prog[index + j]? = some (.range lo hi out) ∧ lo ≤ b ∧ b ≤ hi := by
  intro count
  induction count with
  | zero => intro index h; simp [stepRanges] at h
  | succ count ih =>
    intro index h
    -- The search goes on to the ranges after the first.
    have later : stepRanges prog (index + 1) count b = some out →
        ∃ j lo hi, j < count + 1 ∧ prog[index + j]? = some (.range lo hi out) ∧ lo ≤ b ∧ b ≤ hi := by
      intro h'
      have ⟨j, lo, hi, hj, hp, h1, h2⟩ := ih (index + 1) h'
      exact ⟨j + 1, lo, hi, by omega, by rw [← hp]; congr 1; omega, h1, h2⟩
    unfold stepRanges at h
    cases hp : prog[index]? with
    | none => simp [hp] at h; exact later h
    | some inst =>
      cases inst with
      | range lo hi out' =>
        by_cases hb : lo ≤ b ∧ b ≤ hi
        · simp [hp, hb] at h
          subst h
          exact ⟨0, lo, hi, by omega, by simpa using hp, hb.1, hb.2⟩
        · simp [hp, hb] at h
          exact later h
      | ranges c => simp [hp] at h; exact later h
      | split o a => simp [hp] at h; exact later h
      | save s o => simp [hp] at h; exact later h
      | look l o => simp [hp] at h; exact later h
      | jump o => simp [hp] at h; exact later h
      | done => simp [hp] at h; exact later h
      | fail => simp [hp] at h; exact later h

/-- An instruction that `step` gives is one that the thread's instruction takes the byte to. -/
theorem step_takes {prog : Array Inst} {pc b out : Nat} (h : step prog pc b = some out) :
    Takes prog pc b out := by
  unfold step at h
  cases hp : prog[pc]? with
  | none => simp [hp] at h
  | some inst =>
    cases inst with
    | range lo hi out' =>
      by_cases hb : lo ≤ b ∧ b ≤ hi
      · simp [hp, hb] at h
        subst h
        exact .range hp hb.1 hb.2
      · simp [hp, hb] at h
    | ranges count =>
      simp [hp] at h
      have ⟨j, lo, hi, hj, hm, h1, h2⟩ := stepRanges_takes count (pc + 1) h
      exact .member hp hj hm h1 h2
    | split o a => simp [hp] at h
    | save s o => simp [hp] at h
    | look l o => simp [hp] at h
    | jump o => simp [hp] at h
    | done => simp [hp] at h
    | fail => simp [hp] at h

/-- An instruction that takes a byte ends a path of the walk as a thread, and is no `match`. -/
theorem takes_emit {prog : Array Inst} {text : List Nat} {i pc b out : Nat}
    (h : Takes prog pc b out) : kindAt prog text i pc = .emit ∧ isDone prog pc = false := by
  cases h with
  | range hp _ _ => simp [kindAt, isDone, hp]
  | member hp _ _ _ _ => simp [kindAt, isDone, hp]

/-- A path to `match` from an instruction at an offset: a part that takes no byte, to a thread,
and then the offset where the thread is `match`, or the byte that the thread takes and the rest
of the path. -/
theorem path_split {prog : Array Inst} {text : List Nat} {pc i pc' e : Nat}
    (hpath : Path prog text pc i pc' e) (hdone : prog[pc']? = some .done) :
    ∃ x, Steps (kindAt prog text i) pc x ∧
      ((isDone prog x = true ∧ e = i) ∨
        ∃ b out, text[i]? = some b ∧ Takes prog x b out ∧ Path prog text out (i + 1) pc' e) := by
  induction hpath with
  | here => exact ⟨_, .here, Or.inl ⟨isDone_iff.mpr hdone, rfl⟩⟩
  | free hfree _ ih =>
    have ⟨x, hs, hcase⟩ := ih hdone
    exact ⟨x, free_step hfree hs, hcase⟩
  | take hbyte htakes hrest _ => exact ⟨_, .here, Or.inr ⟨_, _, hbyte, htakes, hrest⟩⟩

/-- An end that the backtracking matcher finds is the end of a path from a seed to `match`. -/
theorem backtrack_sound (prog : Array Inst) (text : List Nat) :
    ∀ turns i seeds e, backtrack prog text turns i seeds = some e →
      ∃ s pc, s ∈ seeds ∧ Path prog text s i pc e ∧ prog[pc]? = some .done := by
  intro turns
  induction turns with
  | zero => intro i seeds e h; simp [backtrack] at h
  | succ turns ih =>
    intro i seeds e h
    simp only [backtrack] at h
    have ⟨s, hs, hfirst⟩ := firstSeed_some h
    have ⟨x, hx, hend⟩ := first_some hfirst
    have hpath := steps_path (follow_reach _ _ _ _ x hx)
    unfold threadEnd at hend
    by_cases hd : isDone prog x = true
    · simp [hd] at hend
      subst hend
      exact ⟨s, x, hs, hpath, isDone_iff.mp hd⟩
    · have hd' : isDone prog x = false := by simpa using hd
      simp only [hd', Bool.false_eq_true, ite_false] at hend
      cases hb : text[i]? with
      | none => simp [hb] at hend
      | some b =>
        cases hst : step prog x b with
        | none => simp [hb, hst] at hend
        | some out =>
          simp only [hb, hst] at hend
          have ⟨s', pc, hs', hrest, hdone⟩ := ih (i + 1) [out] e hend
          have hout : s' = out := by simpa using hs'
          subst hout
          exact ⟨s, pc, hs, hpath.trans (.take hb (step_takes hst) hrest), hdone⟩

/-- `step` gives the instruction that a thread goes to, whichever range of a node takes the
byte. It holds for a program whose nodes hold ranges that stand apart. -/
def Exact (prog : Array Inst) : Prop :=
  ∀ pc b out, Takes prog pc b out → step prog pc b = some out

/-- Where a path leads from an instruction to `match`, the backtracking matcher finds an end
from that instruction, in as many positions as the path takes bytes and one more. -/
theorem backtrack_complete (prog : Array Inst) (text : List Nat) (hexact : Exact prog) :
    ∀ turns i pc pc' e, Path prog text pc i pc' e → prog[pc']? = some .done → e - i < turns →
      (backtrack prog text turns i [pc]).isSome := by
  intro turns
  induction turns with
  | zero => intro i pc pc' e _ _ h; omega
  | succ turns ih =>
    intro i pc pc' e hpath hdone hturns
    have ⟨x, hsteps, hcase⟩ := path_split hpath hdone
    -- The path's first thread ends a walk as a thread.
    have hemit : kindAt prog text i x = .emit := by
      cases hcase with
      | inl h => simp [kindAt, isDone_iff.mp h.1]
      | inr h =>
        obtain ⟨b, out, _, htakes, _⟩ := h
        exact (takes_emit htakes).1
    -- The seed is an instruction of the program.
    have hfull : pc ∈ List.range prog.size := by
      apply Classical.byContradiction
      intro hnot
      have hstop := kindAt_out prog text i hnot
      have := steps_stop hstop hsteps
      rw [this, hstop] at hemit
      cases hemit
    have hmem := follow_complete (kindAt prog text i) (fuel := prog.size + 1) (by simp)
      (fun y hy => kindAt_out prog text i hy) hfull hsteps hemit
    -- The thread has an end.
    have hend : (threadEnd prog text i
        (fun out => backtrack prog text turns (i + 1) [out]) x).isSome := by
      unfold threadEnd
      by_cases hd : isDone prog x = true
      · simp [hd]
      · have hd' : isDone prog x = false := by simpa using hd
        cases hcase with
        | inl h => exact absurd h.1 hd
        | inr h =>
          obtain ⟨b, out, hb, htakes, hrest⟩ := h
          have hle := hrest.le
          simp only [hd', Bool.false_eq_true, ite_false, hb, hexact x b out htakes]
          exact ih (i + 1) out pc' e hrest hdone (by omega)
    simpa [backtrack, firstSeed] using first_isSome hmem hend

/-- The matches of a program in a text, and the end that the pattern's order prefers from each
start: what `Search.lean` asks of a text. `starts` says where a match may start: at each offset
of a program of bytes, and before no continuation byte of a program of UTF-8
(`Encoding.may_start_at`). A match is a path from the entry to `match`, and the preferred end is
the one the backtracking matcher finds first, which is the matcher's (`findAt_eq`). -/
def textOf (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (hexact : Exact prog) : Search.Text where
  len := text.length
  Match := fun s e => s ≤ text.length ∧ starts s = true ∧ Matches prog entry text s e
  Prefers := fun s e =>
    s ≤ text.length ∧ starts s = true ∧ preferredEnd prog entry text s = some e
  inside := by
    intro s e h
    obtain ⟨hs, _, pc, hpath, _⟩ := h
    exact ⟨hpath.le, hpath.le_len hs⟩
  prefers_match := by
    intro s e h
    obtain ⟨hs, hstart, hpref⟩ := h
    unfold preferredEnd at hpref
    have ⟨s', pc, hs', hpath, hdone⟩ := backtrack_sound prog text _ _ _ _ hpref
    have hentry : s' = entry := by simpa using hs'
    subst hentry
    exact ⟨hs, hstart, pc, hpath, hdone⟩
  prefers_some := by
    intro s e h
    obtain ⟨hs, hstart, pc, hpath, hdone⟩ := h
    have hle := hpath.le_len hs
    have hsome := backtrack_complete prog text hexact (text.length - s + 1) s entry pc e hpath
      hdone (by omega)
    cases hv : backtrack prog text (text.length - s + 1) s [entry] with
    | none => rw [hv] at hsome; cases hsome
    | some e' => exact ⟨e', hs, hstart, hv⟩
  prefers_one := by
    intro s e e' h h'
    exact Option.some.inj (h.2.2.symm.trans h'.2.2)

end Stdx.Regex.Matcher
