import Stdx.Regex.Program
import Stdx.Regex.Closure

/-!
# The matcher gives the end a backtracking matcher finds first

`Matcher` is Pike's simulation (decision 86, `src/regex/matcher.zig`). At each position it holds
the threads that can still match, in the order a backtracking matcher would try them, and gives
the position's byte to all of them at once. This file holds a search that must start at one
offset, as a search with `Options.anchored` does, and reads no capture slot: it gives the end of
the match.

- `run` is the matcher. At a position it builds the threads of its seeds with one `visited`
  set, keeps the threads before the first `match`, records the position where a `match` stands,
  and gives the byte to each thread it kept. The instructions they go to are the next seeds.
- `backtrack` is a backtracking matcher over the same program. It tries the threads of a seed
  in order, each one to the end of the text before the next, and walks each seed alone. At one
  position it reads an instruction once, which is the matcher's rule for a loop whose pass
  takes no byte.
- `run_eq`: both give one end. So the matcher's match is the one that this backtracking matcher
  finds first.

`run` builds a position's threads whole and then cuts them at the first `match`, where the Zig
walk stops at it. This file does not prove that the two give the same threads. It also leaves
out the capture slots, and a search that may start at any offset.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Closure

/-- What the instruction at `pc` does, at offset `i` of a text, to a path that takes no byte
(`Matcher.visit`). An index past the program ends the path. -/
def kindAt (prog : Array Inst) (text : List Nat) (i pc : Nat) : Kind :=
  match prog[pc]? with
  | some (.range _ _ _) => .emit
  | some (.ranges _) => .emit
  | some .done => .emit
  | some (.split out arg) => .two out arg
  | some (.save _ out) => .one out
  | some (.jump out) => .one out
  | some (.look l out) => if l.holds (behind text i) (ahead text i) then .one out else .stop
  | some .fail => .stop
  | none => .stop

/-- An index past the program ends a path with no thread. -/
theorem kindAt_out (prog : Array Inst) (text : List Nat) (i : Nat) {pc : Nat}
    (h : pc ∉ List.range prog.size) : kindAt prog text i pc = .stop := by
  have hge : prog.size ≤ pc := by
    apply Nat.le_of_not_lt
    intro hlt
    exact h (List.mem_range.mpr hlt)
  simp [kindAt, Array.getElem?_eq_none hge]

/-- The instruction is `match`. -/
def isDone (prog : Array Inst) (pc : Nat) : Bool :=
  match prog[pc]? with
  | some .done => true
  | _ => false

/-- The instruction a thread goes to where one of the `count` ranges from `index` takes the byte
`b`: the first that takes it. -/
def stepRanges (prog : Array Inst) : Nat → Nat → Nat → Option Nat
  | _, 0, _ => none
  | index, count + 1, b =>
    match prog[index]? with
    | some (.range lo hi out) =>
      if lo ≤ b ∧ b ≤ hi then some out else stepRanges prog (index + 1) count b
    | _ => stepRanges prog (index + 1) count b

/-- The instruction a thread at `pc` goes to after it takes the byte `b`, or nothing where it
does not take it (`program.step`). -/
def step (prog : Array Inst) (pc b : Nat) : Option Nat :=
  match prog[pc]? with
  | some (.range lo hi out) => if lo ≤ b ∧ b ≤ hi then some out else none
  | some (.ranges count) => stepRanges prog (pc + 1) count b
  | _ => none

/-- The threads of a list of seeds at offset `i`, in order, built with one `visited` set
(`Matcher.close_seeds`). -/
def threads (prog : Array Inst) (text : List Nat) (i : Nat) (seeds : List Nat) : List Nat :=
  (closure (kindAt prog text i) (prog.size + 1) (List.range prog.size) seeds).2

/-- The matcher from offset `i` with `seeds`, for at most `turns` positions. `best` is the end of
the best match so far. -/
def run (prog : Array Inst) (text : List Nat) : Nat → Nat → List Nat → Option Nat → Option Nat
  | 0, _, _, best => best
  | turns + 1, i, seeds, best =>
    let found := threads prog text i seeds
    let live := found.takeWhile (fun pc => !isDone prog pc)
    let best' := if found.any (isDone prog) then some i else best
    match live, text[i]? with
    | [], _ => best'
    | _ :: _, none => best'
    | _ :: _, some b => run prog text turns (i + 1) (live.filterMap (step prog · b)) best'

/-- What a backtracking matcher finds from one thread at offset `i`: the offset where the thread
is `match`, and otherwise what `next` finds from the instruction that the thread goes to after
it takes the text's byte. -/
def threadEnd (prog : Array Inst) (text : List Nat) (i : Nat) (next : Nat → Option Nat)
    (pc : Nat) : Option Nat :=
  if isDone prog pc then some i
  else
    match text[i]? with
    | none => none
    | some b =>
      match step prog pc b with
      | none => none
      | some out => next out

/-- A backtracking matcher from offset `i` with `seeds`, for at most `turns` positions: the first
end among the seeds in order, each walked alone, and among a seed's threads in order, each tried
to the end of the text before the next. -/
def backtrack (prog : Array Inst) (text : List Nat) : Nat → Nat → List Nat → Option Nat
  | 0, _, _ => none
  | turns + 1, i, seeds =>
    firstSeed (kindAt prog text i)
      (threadEnd prog text i (fun out => backtrack prog text turns (i + 1) [out]))
      (prog.size + 1) (List.range prog.size) seeds

/-- A backtracking matcher with no seed finds nothing. -/
theorem backtrack_nil (prog : Array Inst) (text : List Nat) (turns i : Nat) :
    backtrack prog text turns i [] = none := by
  cases turns <;> rfl

/-- A backtracking matcher tries its first seed, and then the others. -/
theorem backtrack_cons (prog : Array Inst) (text : List Nat) (turns i o : Nat) (seeds : List Nat) :
    backtrack prog text turns i (o :: seeds) =
      (backtrack prog text turns i [o]).or (backtrack prog text turns i seeds) := by
  cases turns with
  | zero => rfl
  | succ turns => simp [backtrack, firstSeed]

/-- The first end among a position's threads: the first end among the threads before the first
`match`, and otherwise the position, where a `match` stands. -/
theorem first_split (prog : Array Inst) (text : List Nat) (i : Nat) (next : Nat → Option Nat) :
    ∀ found : List Nat, first (threadEnd prog text i next) found =
      (first (threadEnd prog text i next) (found.takeWhile (fun pc => !isDone prog pc))).or
        (if found.any (isDone prog) then some i else none) := by
  intro found
  induction found with
  | nil => rfl
  | cons x xs ih =>
    by_cases hx : isDone prog x = true
    · simp [first, threadEnd, hx]
    · have hx' : isDone prog x = false := by simpa using hx
      simp only [List.takeWhile, hx', Bool.not_false, first, List.any, Bool.false_or]
      cases threadEnd prog text i next x with
      | some v => simp
      | none => simpa using ih

/-- At the text's end the threads before the first `match` find nothing. -/
theorem live_none (prog : Array Inst) (text : List Nat) (i : Nat) (next : Nat → Option Nat)
    (hend : text[i]? = none) :
    ∀ found : List Nat,
      first (threadEnd prog text i next) (found.takeWhile (fun pc => !isDone prog pc)) = none := by
  intro found
  induction found with
  | nil => rfl
  | cons x xs ih =>
    by_cases hx : isDone prog x = true
    · simp [List.takeWhile, hx, first]
    · have hx' : isDone prog x = false := by simpa using hx
      simp only [List.takeWhile, hx', Bool.not_false, first, threadEnd, hend]
      simpa using ih

/-- The first end among the threads before the first `match` is what a backtracking matcher
finds at the next position, from the instructions those threads go to, in order. -/
theorem live_value (prog : Array Inst) (text : List Nat) (turns i b : Nat)
    (hbyte : text[i]? = some b) :
    ∀ found : List Nat,
      first (threadEnd prog text i (fun out => backtrack prog text turns (i + 1) [out]))
          (found.takeWhile (fun pc => !isDone prog pc)) =
        backtrack prog text turns (i + 1)
          ((found.takeWhile (fun pc => !isDone prog pc)).filterMap (step prog · b)) := by
  intro found
  induction found with
  | nil => simp [first, backtrack_nil]
  | cons x xs ih =>
    by_cases hx : isDone prog x = true
    · simp [List.takeWhile, hx, first, backtrack_nil]
    · have hx' : isDone prog x = false := by simpa using hx
      simp only [List.takeWhile, hx', Bool.not_false, first, threadEnd, hbyte]
      cases hstep : step prog x b with
      | none => simpa [List.filterMap, hstep] using ih
      | some out =>
        simp only [List.filterMap, hstep]
        rw [ih, backtrack_cons prog text turns (i + 1) out
          (List.filterMap (step prog · b) (List.takeWhile (fun pc => !isDone prog pc) xs))]
        cases backtrack prog text turns (i + 1) [out] <;> simp

/-- The matcher gives the end that the backtracking matcher finds first, or the best end so far
where it finds none. -/
theorem run_eq (prog : Array Inst) (text : List Nat) :
    ∀ turns i seeds best,
      run prog text turns i seeds best = (backtrack prog text turns i seeds).or best := by
  intro turns
  induction turns with
  | zero => intro i seeds best; simp [run, backtrack]
  | succ turns ih =>
    intro i seeds best
    -- A backtracking matcher's end is the first end among the matcher's threads.
    have hvalue : backtrack prog text (turns + 1) i seeds =
        first (threadEnd prog text i (fun out => backtrack prog text turns (i + 1) [out]))
          (threads prog text i seeds) := by
      unfold threads
      rw [closure_value _ _ (by simp) (fun x hx => kindAt_out prog text i hx)]
      rfl
    rw [hvalue, first_split]
    simp only [run]
    generalize threads prog text i seeds = found
    have hnone := live_none prog text i (fun out => backtrack prog text turns (i + 1) [out])
    have hsome := live_value prog text turns i
    cases hlive : found.takeWhile (fun pc => !isDone prog pc) with
    | nil => by_cases hc : found.any (isDone prog) = true <;> simp [first, hc]
    | cons x xs =>
      cases hb : text[i]? with
      | none =>
        have h := hnone hb found
        rw [hlive] at h
        rw [h]
        by_cases hc : found.any (isDone prog) = true <;> simp [hc]
      | some b =>
        have h := hsome b hb found
        rw [hlive] at h
        rw [h]
        simp only [ih]
        cases backtrack prog text turns (i + 1) ((x :: xs).filterMap (step prog · b)) <;>
          by_cases hc : found.any (isDone prog) = true <;> simp [hc]

/-- `Matcher.find` for a search that must start at `s`: the matcher from `s`, with the program's
entry as its one seed. -/
def findAt (prog : Array Inst) (entry : Nat) (text : List Nat) (s : Nat) : Option Nat :=
  run prog text (text.length - s + 1) s [entry] none

/-- The end that a backtracking matcher finds first from `s`. -/
def preferredEnd (prog : Array Inst) (entry : Nat) (text : List Nat) (s : Nat) : Option Nat :=
  backtrack prog text (text.length - s + 1) s [entry]

/-- The matcher's match from one start is the one a backtracking matcher finds first. -/
theorem findAt_eq (prog : Array Inst) (entry : Nat) (text : List Nat) (s : Nat) :
    findAt prog entry text s = preferredEnd prog entry text s := by
  unfold findAt preferredEnd
  rw [run_eq]
  simp

/-! ## The model on small programs

Each program is a pattern's instructions, written by hand. The ends are RE2's: the preferred
branch of a split wins over a longer match, a greedy loop takes all it can, a lazy loop takes
nothing, and a loop whose pass takes no byte ends. -/

/-- `a|ab` on `ab` ends at 1, and `ab|a` at 2. -/
example :
    findAt #[.split 1 3, .range 97 97 2, .done, .range 97 97 4, .range 98 98 5, .done] 0
        [97, 98] 0 = some 1 ∧
      findAt #[.split 3 1, .range 97 97 2, .done, .range 97 97 4, .range 98 98 5, .done] 0
        [97, 98] 0 = some 2 := by decide

/-- `a*` on `aaab` ends at 3, and `a*?` at 0. -/
example :
    findAt #[.split 1 2, .range 97 97 0, .done] 0 [97, 97, 97, 98] 0 = some 3 ∧
      findAt #[.split 2 1, .range 97 97 0, .done] 0 [97, 97, 97, 98] 0 = some 0 := by decide

/-- `(a*)*b`, whose inner loop may take no byte: on `aaba` it ends at 3, and `aa` holds no
match. -/
example :
    findAt #[.split 1 4, .split 2 3, .range 97 97 1, .jump 0, .range 98 98 5, .done] 0
        [97, 97, 98, 97] 0 = some 3 ∧
      findAt #[.split 1 4, .split 2 3, .range 97 97 1, .jump 0, .range 98 98 5, .done] 0
        [97, 97] 0 = none := by decide

/-- `a+?|a*` on `aa` ends at 1: the preferred end is neither the first end nor the last. -/
example :
    findAt #[.split 1 4, .range 97 97 2, .split 3 1, .done, .split 5 6, .range 97 97 4, .done] 0
      [97, 97] 0 = some 1 := by decide

/-- `a\z`: on `a` it ends at 1, and `ab` holds no match from 0, since the assertion of the
text's end does not hold before `b`. -/
example :
    findAt #[.range 97 97 1, .look .aheadText 2, .done] 0 [97] 0 = some 1 ∧
      findAt #[.range 97 97 1, .look .aheadText 2, .done] 0 [97, 98] 0 = none := by decide

end Stdx.Regex.Matcher
