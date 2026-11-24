import Stdx.Regex.MatcherPaths

/-!
# The reverse DFA gives the least start of a match that ends at an offset

The searcher finds where a match starts with a DFA of `Kind.longest` over the reverse program
(decision 86, `src/regex/dfa/dfa_reverse.zig`). The DFA reads back from the match's end, keeps
every thread, and gives the last offset where a thread is `match`. Read backward, the last
offset is the least start.

- `runLongest` is that DFA's scan, as a matcher that cuts no thread at a `match`. It reads its
  text forward: the reverse program's text is the text read backward.
- `runLongest_sound` and `runLongest_complete`: it gives the last offset that a path from a
  seed reaches `match` at, within the positions it may read.
- `scanBack` is `dfa_reverse.scan`, from a match's end back to the search's first offset, and
  `scanBack_some`, `scanBack_least` and `scanBack_none` are what `Search.lean` asks of the
  reverse scan, for the paths of the forward program.

The three theorems take `Reverses` as a hypothesis: the reverse program takes each match of the
forward program read backward, and nothing else. That is the builder's work, and no proof here
holds the builder to it. They also read paths alone, so they hold no rule of where a match may
start.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Closure

/-- A path leads from an instruction at an offset to `match` at an offset. -/
def Accepts (prog : Array Inst) (text : List Nat) (pc i e : Nat) : Prop :=
  ∃ pc', Path prog text pc i pc' e ∧ prog[pc']? = some .done

/-- A thread of a position stands at the end of a path from a seed that takes no byte. -/
theorem threads_sound {prog : Array Inst} {text : List Nat} {i x : Nat} {seeds : List Nat}
    (hx : x ∈ threads prog text i seeds) : ∃ s, s ∈ seeds ∧ Path prog text s i x i := by
  have h := (mem_closure (kindAt prog text i) (fuel := prog.size + 1) (by simp)
    (fun y hy => kindAt_out prog text i hy) x seeds).mp hx
  obtain ⟨s, hs, hfollow⟩ := h
  exact ⟨s, hs, steps_path (follow_reach _ _ _ _ x hfollow)⟩

/-- A thread that a path from a seed reaches is a thread of the position. -/
theorem threads_complete {prog : Array Inst} {text : List Nat} {i s x : Nat} {seeds : List Nat}
    (hs : s ∈ seeds) (hsteps : Steps (kindAt prog text i) s x)
    (hemit : kindAt prog text i x = .emit) : x ∈ threads prog text i seeds := by
  have hfull : s ∈ List.range prog.size := by
    apply Classical.byContradiction
    intro hnot
    have hstop := kindAt_out prog text i hnot
    have := steps_stop hstop hsteps
    rw [this, hstop] at hemit
    cases hemit
  have hmem := follow_complete (kindAt prog text i) (fuel := prog.size + 1) (by simp)
    (fun y hy => kindAt_out prog text i hy) hfull hsteps hemit
  exact (mem_closure (kindAt prog text i) (fuel := prog.size + 1) (by simp)
    (fun y hy => kindAt_out prog text i hy) x seeds).mpr ⟨s, hs, hmem⟩

/-- The scan of a DFA of `Kind.longest` from offset `i` with `seeds`, for at most `turns`
positions: every thread goes on, and `best` is the last offset where a thread was `match`. -/
def runLongest (prog : Array Inst) (text : List Nat) :
    Nat → Nat → List Nat → Option Nat → Option Nat
  | 0, _, _, best => best
  | turns + 1, i, seeds, best =>
    match text[i]? with
    | none => if (threads prog text i seeds).any (isDone prog) then some i else best
    | some b =>
      runLongest prog text turns (i + 1) ((threads prog text i seeds).filterMap (step prog · b))
        (if (threads prog text i seeds).any (isDone prog) then some i else best)

/-- A `match` among a position's threads is the end of a path from a seed. -/
theorem done_here {prog : Array Inst} {text : List Nat} {i : Nat} {seeds : List Nat}
    (h : (threads prog text i seeds).any (isDone prog) = true) :
    ∃ s, s ∈ seeds ∧ Accepts prog text s i i := by
  obtain ⟨x, hx, hd⟩ := List.any_eq_true.mp h
  obtain ⟨s, hs, hpath⟩ := threads_sound hx
  exact ⟨s, hs, x, hpath, isDone_iff.mp hd⟩

/-- An offset that the scan gives is the best so far, or an offset that a path from a seed
reaches `match` at, among the positions the scan may read. -/
theorem runLongest_sound (prog : Array Inst) (text : List Nat) :
    ∀ turns i seeds best e, runLongest prog text turns i seeds best = some e →
      best = some e ∨ (i ≤ e ∧ e < i + turns ∧ ∃ s, s ∈ seeds ∧ Accepts prog text s i e) := by
  intro turns
  induction turns with
  | zero => intro i seeds best e h; exact Or.inl h
  | succ turns ih =>
    intro i seeds best e h
    -- The best end after this position: the position, or the best before it.
    have hbest : (if (threads prog text i seeds).any (isDone prog) then some i else best) = some e →
        best = some e ∨ (i ≤ e ∧ e < i + (turns + 1) ∧ ∃ s, s ∈ seeds ∧ Accepts prog text s i e) := by
      intro hv
      by_cases hc : (threads prog text i seeds).any (isDone prog) = true
      · simp only [hc, ite_true] at hv
        have he : i = e := Option.some.inj hv
        subst he
        exact Or.inr ⟨Nat.le_refl _, by omega, done_here hc⟩
      · simp only [hc, Bool.false_eq_true, ite_false] at hv
        exact Or.inl hv
    simp only [runLongest] at h
    cases hb : text[i]? with
    | none =>
      rw [hb] at h
      exact hbest h
    | some b =>
      rw [hb] at h
      cases ih (i + 1) _ _ e h with
      | inl hv => exact hbest hv
      | inr hr =>
        obtain ⟨h1, h2, o, ho, pc', hpath, hdone⟩ := hr
        obtain ⟨x, hx, hstep⟩ := List.mem_filterMap.mp ho
        obtain ⟨s, hs, hfree⟩ := threads_sound hx
        exact Or.inr ⟨by omega, by omega, s, hs, pc',
          hfree.trans (.take hb (step_takes hstep) hpath), hdone⟩

/-- With a best offset, the scan gives that offset or a later one. -/
theorem runLongest_some (prog : Array Inst) (text : List Nat) :
    ∀ turns i seeds v, ∃ e, runLongest prog text turns i seeds (some v) = some e ∧
      (e = v ∨ i ≤ e) := by
  intro turns
  induction turns with
  | zero => intro i seeds v; exact ⟨v, rfl, Or.inl rfl⟩
  | succ turns ih =>
    intro i seeds v
    simp only [runLongest]
    by_cases hc : (threads prog text i seeds).any (isDone prog) = true
    · simp only [hc, ite_true]
      cases hb : text[i]? with
      | none => exact ⟨i, rfl, Or.inr (Nat.le_refl i)⟩
      | some b =>
        obtain ⟨e, he, hcase⟩ := ih (i + 1) ((threads prog text i seeds).filterMap (step prog · b)) i
        exact ⟨e, he, Or.inr (by omega)⟩
    · simp only [hc, Bool.false_eq_true, ite_false]
      cases hb : text[i]? with
      | none => exact ⟨v, rfl, Or.inl rfl⟩
      | some b =>
        obtain ⟨e, he, hcase⟩ := ih (i + 1) ((threads prog text i seeds).filterMap (step prog · b)) v
        exact ⟨e, he, hcase.elim Or.inl (fun h => Or.inr (by omega))⟩

/-- Where a path from a seed reaches `match` at an offset that the scan may read, the scan gives
that offset or a later one. -/
theorem runLongest_complete (prog : Array Inst) (text : List Nat) (hexact : Exact prog) :
    ∀ turns i seeds best e', (∃ s, s ∈ seeds ∧ Accepts prog text s i e') → e' - i < turns →
      ∃ e, runLongest prog text turns i seeds best = some e ∧ e' ≤ e := by
  intro turns
  induction turns with
  | zero => intro i seeds best e' _ h; omega
  | succ turns ih =>
    intro i seeds best e' hacc hturns
    obtain ⟨s, hs, pc', hpath, hdone⟩ := hacc
    obtain ⟨x, hsteps, hcase⟩ := path_split hpath hdone
    simp only [runLongest]
    cases hcase with
    | inl h =>
      -- The path ends at this position: the scan holds it as its best offset from here on.
      obtain ⟨hd, he⟩ := h
      subst he
      have hx := threads_complete hs hsteps (by simp [kindAt, isDone_iff.mp hd])
      have hc : (threads prog text e' seeds).any (isDone prog) = true :=
        List.any_eq_true.mpr ⟨x, hx, hd⟩
      simp only [hc, ite_true]
      cases hb : text[e']? with
      | none => exact ⟨e', rfl, Nat.le_refl e'⟩
      | some b =>
        obtain ⟨e, he, hcase⟩ :=
          runLongest_some prog text turns (e' + 1)
            ((threads prog text e' seeds).filterMap (step prog · b)) e'
        exact ⟨e, he, by omega⟩
    | inr h =>
      obtain ⟨b, out, hb, htakes, hrest⟩ := h
      have hx := threads_complete hs hsteps (takes_emit htakes).1
      have hout : out ∈ (threads prog text i seeds).filterMap (step prog · b) :=
        List.mem_filterMap.mpr ⟨x, hx, hexact x b out htakes⟩
      have hle := hrest.le
      rw [hb]
      exact ih (i + 1) _ _ e' ⟨out, hout, pc', hrest, hdone⟩ (by omega)

/-- The reverse program takes each match of the forward program read backward, and nothing
else: a match from `s` up to `e` is a path of the reverse program over the text read backward,
from the offset of `e` to the offset of `s`. -/
def Reverses (fwd : Array Inst) (entry : Nat) (rev : Array Inst) (reventry : Nat)
    (text : List Nat) : Prop :=
  ∀ s e, s ≤ e → e ≤ text.length →
    (Matches fwd entry text s e ↔
      Accepts rev text.reverse reventry (text.length - e) (text.length - s))

/-- `dfa_reverse.scan`: the reverse DFA's scan from a match's end `e` back to `low`. It reads the
bytes from `e` back to `low`, and the contexts of the whole text. -/
def scanBack (rev : Array Inst) (reventry : Nat) (text : List Nat) (low e : Nat) : Option Nat :=
  (runLongest rev text.reverse (e - low + 1) (text.length - e) [reventry] none).map
    (text.length - ·)

/-- The reverse scan gives a start, at or after `low`, of a match that ends at `e`. -/
theorem scanBack_some {fwd rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    (hrev : Reverses fwd entry rev reventry text) {low e s : Nat} (hlow : low ≤ e)
    (he : e ≤ text.length) (h : scanBack rev reventry text low e = some s) :
    low ≤ s ∧ Matches fwd entry text s e := by
  unfold scanBack at h
  cases hrun : runLongest rev text.reverse (e - low + 1) (text.length - e) [reventry] none with
  | none => rw [hrun] at h; cases h
  | some j =>
    rw [hrun] at h
    have hs : text.length - j = s := by simpa using h
    cases runLongest_sound rev text.reverse _ _ _ _ j hrun with
    | inl hbest => cases hbest
    | inr hr =>
      obtain ⟨h1, h2, s', hs', hacc⟩ := hr
      have hentry : s' = reventry := by simpa using hs'
      subst hentry
      refine ⟨by omega, ?_⟩
      apply (hrev s e (by omega) he).mpr
      have hidx : text.length - s = j := by omega
      rw [hidx]
      exact hacc

/-- The reverse scan gives the least such start. -/
theorem scanBack_least {fwd rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    (hexact : Exact rev) (hrev : Reverses fwd entry rev reventry text) {low e s s' : Nat}
    (he : e ≤ text.length) (h : scanBack rev reventry text low e = some s) (hs' : low ≤ s')
    (hm : Matches fwd entry text s' e) : s ≤ s' := by
  have hse : s' ≤ e := by
    obtain ⟨pc, hpath, _⟩ := hm
    exact hpath.le
  have hacc := (hrev s' e hse he).mp hm
  obtain ⟨j, hrun, hj⟩ := runLongest_complete rev text.reverse hexact (e - low + 1)
    (text.length - e) [reventry] none (text.length - s') ⟨reventry, by simp, hacc⟩ (by omega)
  unfold scanBack at h
  rw [hrun] at h
  have hs : text.length - j = s := by simpa using h
  omega

/-- The reverse scan gives nothing where no match from `low` on ends at `e`. -/
theorem scanBack_none {fwd rev : Array Inst} {entry reventry : Nat} {text : List Nat}
    (hexact : Exact rev) (hrev : Reverses fwd entry rev reventry text) {low e s' : Nat}
    (he : e ≤ text.length) (h : scanBack rev reventry text low e = none) (hs' : low ≤ s') :
    ¬ Matches fwd entry text s' e := by
  intro hm
  have hse : s' ≤ e := by
    obtain ⟨pc, hpath, _⟩ := hm
    exact hpath.le
  have hacc := (hrev s' e hse he).mp hm
  obtain ⟨j, hrun, _⟩ := runLongest_complete rev text.reverse hexact (e - low + 1)
    (text.length - e) [reventry] none (text.length - s') ⟨reventry, by simp, hacc⟩ (by omega)
  unfold scanBack at h
  rw [hrun] at h
  simp at h

/-! ## The reverse scan on a small program -/

/-- The reverse program of `a+b` is `ba+`. In `xaab` the match that ends at 4 starts at 1, and a
scan that reads back to 2 alone gives the start 2. A scan from 3, where no match ends, gives
nothing. -/
example :
    scanBack #[.range 98 98 1, .range 97 97 2, .split 1 3, .done] 0 [120, 97, 97, 98] 0 4
        = some 1 ∧
      scanBack #[.range 98 98 1, .range 97 97 2, .split 1 3, .done] 0 [120, 97, 97, 98] 2 4
        = some 2 ∧
      scanBack #[.range 98 98 1, .range 97 97 2, .split 1 3, .done] 0 [120, 97, 97, 98] 0 3
        = none := by decide

end Stdx.Regex.Matcher
