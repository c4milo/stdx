import Stdx.Regex.MatcherSearch

/-!
# The forward DFA: a state is the matcher's list at one position

A lazy DFA reads the text once and gives where the match ends (decision 86,
`src/regex/dfa/dfa.zig`). A state holds the context of the byte behind the position, whether a
match may still start, and the seeds: the instructions its threads go on from, in order.
`Dfa.build` gives a state and a byte the next state, and says whether a match ends before the
byte.

- `delta` is `Dfa.build` for a DFA of `Kind.first` that is not anchored. It reads a state and a
  byte, and no text: the next state and the match are a function of those two. That is what
  lets a table hold them.
- `scan` is the forward scan by states, and `scan_eq`: it gives what the matcher's search gives.
  With `search_answer`, the forward scan gives the end of the search's answer.
- `cached`: a table that holds values of `delta`, any part of them, changes no step. So a cache
  that forgets its states and builds them again changes no answer.

This file leaves out the table itself, the classes of bytes, a DFA that gives up, and the claims
that change how a scan reads its bytes (R1, R7 and R9).
-/
namespace Stdx.Regex.Dfa

open Stdx.Regex.Program Stdx.Regex.Closure Stdx.Regex.Matcher

/-- What an instruction does to a path that takes no byte, between a byte of one context and a
byte of another (`dfa_close.visit`). -/
def kindOf (prog : Array Inst) (behind ahead : Context) (pc : Nat) : Kind :=
  match prog[pc]? with
  | some (.range _ _ _) => .emit
  | some (.ranges _) => .emit
  | some .done => .emit
  | some (.split out arg) => .two out arg
  | some (.save _ out) => .one out
  | some (.jump out) => .one out
  | some (.look l out) => if l.holds behind ahead then .one out else .stop
  | some .fail => .stop
  | none => .stop

/-- The matcher reads an instruction at an offset as the DFA reads it between the two contexts
of that offset. -/
theorem kindAt_eq (prog : Array Inst) (text : List Nat) (i : Nat) :
    kindAt prog text i = kindOf prog (behind text i) (ahead text i) := by
  funext pc
  rfl

/-- A state's threads between two contexts, in order (`dfa_close.close`). -/
def threadsOf (prog : Array Inst) (behind ahead : Context) (seeds : List Nat) : List Nat :=
  (closure (kindOf prog behind ahead) (prog.size + 1) (List.range prog.size) seeds).2

/-- The matcher's threads at an offset are the DFA's threads between its two contexts. -/
theorem threads_eq (prog : Array Inst) (text : List Nat) (i : Nat) (seeds : List Nat) :
    threads prog text i seeds = threadsOf prog (behind text i) (ahead text i) seeds := by
  unfold threads threadsOf
  rw [kindAt_eq]

/-- A state of the forward DFA. -/
structure State where
  /-- The context of the byte behind the position. -/
  behind : Context
  /-- Whether a match may still start: no match was found yet. -/
  restart : Bool
  /-- The instructions the position's threads go on from, in order. -/
  seeds : List Nat

/-- `Dfa.build`: the state after a byte, and whether a match ends before the byte. `mayByte` says
whether a match may start before a byte (`Encoding.may_start_at`). -/
def delta (prog : Array Inst) (entry : Nat) (mayByte : Nat → Bool) (st : State) (b : Nat) :
    State × Bool :=
  let found := threadsOf prog st.behind (Context.of b)
    (st.seeds ++ if st.restart && mayByte b then [entry] else [])
  let matched := found.any (isDone prog)
  let live := found.takeWhile (fun pc => !isDone prog pc)
  (⟨Context.of b, st.restart && !matched, live.filterMap (step prog · b)⟩, matched)

/-- `Dfa.matches_at_end`: whether a match ends where the text ends. -/
def deltaEnd (prog : Array Inst) (entry : Nat) (st : State) : Bool :=
  (threadsOf prog st.behind .edge (st.seeds ++ if st.restart then [entry] else [])).any
    (isDone prog)

/-- `Dfa.scan_forward`: the scan by states from offset `i`. `last` is the end of the last match
it saw. The scan ends at a state with no seed from which no match may start. -/
def scan (prog : Array Inst) (entry : Nat) (text : List Nat) (mayByte : Nat → Bool) :
    Nat → Nat → State → Option Nat → Option Nat
  | 0, _, _, last => last
  | turns + 1, i, st, last =>
    match text[i]? with
    | none => if deltaEnd prog entry st then some i else last
    | some b =>
      let next := delta prog entry mayByte st b
      let last' := if next.2 then some i else last
      if next.1.seeds.isEmpty && !next.1.restart then last'
      else scan prog entry text mayByte turns (i + 1) next.1 last'

/-- Where a match may start in a text: before a byte that `mayByte` holds for, and at the
text's end. -/
def startsOf (text : List Nat) (mayByte : Nat → Bool) (i : Nat) : Bool :=
  match text[i]? with
  | none => true
  | some b => mayByte b

/-- The context ahead of an offset that holds a byte. -/
theorem ahead_some {text : List Nat} {i b : Nat} (h : text[i]? = some b) :
    ahead text i = Context.of b := by
  simp [ahead, h]

/-- The context ahead of the text's end. -/
theorem ahead_none {text : List Nat} {i : Nat} (h : text[i]? = none) : ahead text i = .edge := by
  simp [ahead, h]

/-- The context behind the offset after a byte. -/
theorem behind_succ {text : List Nat} {i b : Nat} (h : text[i]? = some b) :
    behind text (i + 1) = Context.of b := by
  simp [behind, h]

/-- With a match found and no seed, the matcher's search gives that match. -/
theorem search_dead (prog : Array Inst) (entry : Nat) (text : List Nat) (starts : Nat → Bool)
    (turns i v : Nat) : search prog entry text starts turns i [] (some v) = some v := by
  rw [search_some, run_eq, backtrack_nil]
  rfl

/-- One turn of the scan and one turn of the search, from the threads `found` of one position
that holds the byte `b`. The scan ends where no thread takes the byte and a match was found,
one position before the search ends. -/
theorem scan_step (prog : Array Inst) (entry : Nat) (text : List Nat) (mayByte : Nat → Bool)
    (turns i b : Nat) (hb : text[i]? = some b)
    (ih : ∀ (st : State) last, st.behind = behind text (i + 1) → st.restart = last.isNone →
      scan prog entry text mayByte turns (i + 1) st last =
        search prog entry text (startsOf text mayByte) turns (i + 1) st.seeds last)
    (found : List Nat) (restart : Bool) (last : Option Nat) (hrestart : restart = last.isNone) :
    (if ((found.takeWhile (fun pc => !isDone prog pc)).filterMap (step prog · b)).isEmpty &&
          !(restart && !found.any (isDone prog)) then
        (if found.any (isDone prog) then some i else last)
      else
        scan prog entry text mayByte turns (i + 1)
          ⟨Context.of b, restart && !found.any (isDone prog),
            (found.takeWhile (fun pc => !isDone prog pc)).filterMap (step prog · b)⟩
          (if found.any (isDone prog) then some i else last)) =
      (if (found.takeWhile (fun pc => !isDone prog pc)).isEmpty &&
          (if found.any (isDone prog) then some i else last).isSome then
        (if found.any (isDone prog) then some i else last)
      else
        search prog entry text (startsOf text mayByte) turns (i + 1)
          ((found.takeWhile (fun pc => !isDone prog pc)).filterMap (step prog · b))
          (if found.any (isDone prog) then some i else last)) := by
  have hstep : ∀ (r : Bool) (l : Option Nat) (seeds : List Nat), r = l.isNone →
      scan prog entry text mayByte turns (i + 1) ⟨Context.of b, r, seeds⟩ l =
        search prog entry text (startsOf text mayByte) turns (i + 1) seeds l :=
    fun r l seeds h => ih ⟨Context.of b, r, seeds⟩ l (behind_succ hb).symm h
  -- With a match found, no match may start, and both end where no thread is left.
  have hfound : ∀ (v : Nat) (live : List Nat),
      (if (live.filterMap (step prog · b)).isEmpty then some v
        else scan prog entry text mayByte turns (i + 1)
          ⟨Context.of b, false, live.filterMap (step prog · b)⟩ (some v)) =
      (if live.isEmpty then some v
        else search prog entry text (startsOf text mayByte) turns (i + 1)
          (live.filterMap (step prog · b)) (some v)) := by
    intro v live
    rw [hstep false (some v) _ rfl]
    cases live with
    | nil => simp
    | cons x xs =>
      by_cases hdead : ((x :: xs).filterMap (step prog · b)).isEmpty = true
      · have hnil : (x :: xs).filterMap (step prog · b) = [] := by simpa using hdead
        simp [hnil, search_dead]
      · simp [hdead]
  cases hany : found.any (isDone prog) with
  | true => simpa using hfound i (found.takeWhile (fun pc => !isDone prog pc))
  | false =>
    cases last with
    | none =>
      have hr : restart = true := hrestart
      subst hr
      simp [hstep true none _ rfl]
    | some v =>
      have hr : restart = false := hrestart
      subst hr
      simpa using hfound v (found.takeWhile (fun pc => !isDone prog pc))

/-- The forward scan by states gives what the matcher's search gives, from a state that holds
the context behind the offset and may start a match exactly while no match was found. -/
theorem scan_eq (prog : Array Inst) (entry : Nat) (text : List Nat) (mayByte : Nat → Bool) :
    ∀ turns i (st : State) last, st.behind = behind text i → st.restart = last.isNone →
      scan prog entry text mayByte turns i st last =
        search prog entry text (startsOf text mayByte) turns i st.seeds last := by
  intro turns
  induction turns with
  | zero => intro i st last _ _; rfl
  | succ turns ih =>
    intro i st last hbehind hrestart
    cases hb : text[i]? with
    | none =>
      have hstart : startsOf text mayByte i = true := by simp [startsOf, hb]
      simp only [scan, search, hb, deltaEnd, threads_eq, ahead_none hb, ← hbehind, ← hrestart,
        hstart, Bool.and_true]
      rfl
    | some b =>
      have hstart : startsOf text mayByte i = mayByte b := by simp [startsOf, hb]
      simp only [scan, search, hb, delta, threads_eq, ahead_some hb, ← hbehind, ← hrestart,
        hstart]
      exact scan_step prog entry text mayByte turns i b hb (ih (i + 1)) _ st.restart last hrestart

/-- The forward scan gives the end of the search's answer, for the text that `textOf` gives the
program: the least start, and the end a backtracking matcher finds first from it. -/
theorem scan_answer (prog : Array Inst) (entry : Nat) (text : List Nat) (mayByte : Nat → Bool)
    (hexact : Exact prog) {low : Nat} {a : Option (Nat × Nat)} (hlow : low ≤ text.length)
    (ha : Search.IsAnswer (textOf prog entry text (startsOf text mayByte) hexact) low a) :
    scan prog entry text mayByte (text.length - low + 1) low ⟨behind text low, true, []⟩ none =
      a.map (·.2) := by
  rw [scan_eq prog entry text mayByte _ low ⟨behind text low, true, []⟩ none rfl rfl]
  exact search_answer prog entry text _ hexact hlow ha

/-- A step through a table. Where each entry the table holds is `delta`'s value, the step is
`delta`'s, whatever part of the states the table holds: a cache that forgets its states and
builds them again changes no step, and so no answer. -/
theorem cached (prog : Array Inst) (entry : Nat) (mayByte : Nat → Bool)
    (table : State → Nat → Option (State × Bool))
    (hsound : ∀ st b r, table st b = some r → r = delta prog entry mayByte st b)
    (st : State) (b : Nat) :
    (table st b).getD (delta prog entry mayByte st b) = delta prog entry mayByte st b := by
  cases h : table st b with
  | none => rfl
  | some r => simp [hsound st b r h]

end Stdx.Regex.Dfa
