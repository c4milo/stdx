import Stdx.Regex.Matcher

/-!
# The capture groups of the matcher's match

`Matcher.find` with `Captures.groups` keeps two slots for each group, and each thread carries
its own (decision 86, `src/regex/matcher.zig`). A save writes the position into a slot of the
thread that passes it. The slots of the first thread that is `match`, at the last position
where one is, are the groups of the search's match.

This file holds the matcher of `Matcher.lean` again, with the slots of each thread:

- `followSlots` and `closureSlots` are `Closure.follow` and `Closure.closure` for threads that
  carry slots. `followSlots_erase` and `closureSlots_erase`: with the slots left out, they are
  those two walks.
- `runSlots` is `run` for such threads, and `runSlots_end`: with the slots left out, it is
  `run`.
- `capturesAt` gives the end and the slots of the match from one start, and `capturesAt_end`:
  its end is `findAt`'s, which `findAt_eq` proves is the end a backtracking matcher finds
  first.

So the slots are those of a thread of the proved matcher, at the end the proved matcher gives.
No theorem here says which path of the program wrote them.
-/
namespace Stdx.Regex.Matcher

open Stdx.Regex.Program Stdx.Regex.Closure

/-- The slots of a path after it passes the instruction at `pc` at offset `i`: a save writes
the offset into its slot, and no other instruction writes one. -/
def slotsAt (prog : Array Inst) (i pc : Nat) (slots : List (Option Nat)) : List (Option Nat) :=
  match prog[pc]? with
  | some (.save slot _) => slots.set slot (some i)
  | _ => slots

/-- `Closure.follow` at offset `i`, for a path that carries slots. A thread is an instruction
and the slots of the path that reached it first. -/
def followSlots (prog : Array Inst) (text : List Nat) (i : Nat) :
    Nat → List Nat → Nat → List (Option Nat) → List Nat × List (Nat × List (Option Nat))
  | 0, rem, _, _ => (rem, [])
  | fuel + 1, rem, pc, slots =>
    if pc ∈ rem then
      match kindAt prog text i pc with
      | .emit => (rem.filter (· != pc), [(pc, slots)])
      | .stop => (rem.filter (· != pc), [])
      | .one a =>
        followSlots prog text i fuel (rem.filter (· != pc)) a (slotsAt prog i pc slots)
      | .two a b =>
        let before := followSlots prog text i fuel (rem.filter (· != pc)) a slots
        let after := followSlots prog text i fuel before.1 b slots
        (after.1, before.2 ++ after.2)
    else (rem, [])

/-- With the slots left out, `followSlots` is `follow`. -/
theorem followSlots_erase (prog : Array Inst) (text : List Nat) (i : Nat) :
    ∀ fuel rem pc slots,
      (followSlots prog text i fuel rem pc slots).1 = (follow (kindAt prog text i) fuel rem pc).1 ∧
        (followSlots prog text i fuel rem pc slots).2.map (·.1) =
          (follow (kindAt prog text i) fuel rem pc).2 := by
  intro fuel
  induction fuel with
  | zero => intro rem pc slots; exact ⟨rfl, rfl⟩
  | succ fuel ih =>
    intro rem pc slots
    by_cases hmem : pc ∈ rem
    · cases hk : kindAt prog text i pc with
      | emit => simp [followSlots, follow, hmem, hk]
      | stop => simp [followSlots, follow, hmem, hk]
      | one a => simpa [followSlots, follow, hmem, hk] using ih _ a _
      | two a b =>
        have h1 := ih (rem.filter (· != pc)) a slots
        have h2 := ih (follow (kindAt prog text i) fuel (rem.filter (· != pc)) a).1 b slots
        simp only [followSlots, follow, hmem, hk, ite_true, List.map_append]
        rw [h1.1, h1.2]
        exact ⟨h2.1, by rw [h2.2]⟩
    · simp [followSlots, follow, hmem]

/-- `Closure.closure` at offset `i`, for seeds that carry slots: one `visited` set for all the
seeds of a position. -/
def closureSlots (prog : Array Inst) (text : List Nat) (i fuel : Nat) :
    List Nat → List (Nat × List (Option Nat)) → List Nat × List (Nat × List (Option Nat))
  | rem, [] => (rem, [])
  | rem, s :: seeds =>
    ((closureSlots prog text i fuel (followSlots prog text i fuel rem s.1 s.2).1 seeds).1,
      (followSlots prog text i fuel rem s.1 s.2).2 ++
        (closureSlots prog text i fuel (followSlots prog text i fuel rem s.1 s.2).1 seeds).2)

/-- With the slots left out, `closureSlots` is `closure`. -/
theorem closureSlots_erase (prog : Array Inst) (text : List Nat) (i fuel : Nat) :
    ∀ seeds rem,
      (closureSlots prog text i fuel rem seeds).1 =
          (closure (kindAt prog text i) fuel rem (seeds.map (·.1))).1 ∧
        (closureSlots prog text i fuel rem seeds).2.map (·.1) =
          (closure (kindAt prog text i) fuel rem (seeds.map (·.1))).2 := by
  intro seeds
  induction seeds with
  | nil => intro rem; exact ⟨rfl, rfl⟩
  | cons s seeds ih =>
    intro rem
    have h1 := followSlots_erase prog text i fuel rem s.1 s.2
    have h2 := ih (follow (kindAt prog text i) fuel rem s.1).1
    simp only [closureSlots, closure, List.map_cons, List.map_append]
    rw [h1.1, h1.2]
    exact ⟨h2.1, by rw [h2.2]⟩

/-- The threads of a list of seeds at offset `i`, each with its slots, in order. -/
def threadsSlots (prog : Array Inst) (text : List Nat) (i : Nat)
    (seeds : List (Nat × List (Option Nat))) : List (Nat × List (Option Nat)) :=
  (closureSlots prog text i (prog.size + 1) (List.range prog.size) seeds).2

/-- With the slots left out, the threads are `threads`. -/
theorem threadsSlots_erase (prog : Array Inst) (text : List Nat) (i : Nat)
    (seeds : List (Nat × List (Option Nat))) :
    (threadsSlots prog text i seeds).map (·.1) = threads prog text i (seeds.map (·.1)) :=
  (closureSlots_erase prog text i (prog.size + 1) seeds (List.range prog.size)).2

/-- The best match after a position's threads: the position and the slots of the first thread
that is `match`, or the best match before the position where none is. -/
def bestOf (prog : Array Inst) (found : List (Nat × List (Option Nat))) (i : Nat)
    (best : Option (Nat × List (Option Nat))) : Option (Nat × List (Option Nat)) :=
  match found.find? (fun t => isDone prog t.1) with
  | some t => some (i, t.2)
  | none => best

/-- `run` for threads that carry slots. `best` is the end and the slots of the best match so
far: those of the first thread that is `match`, at the last position where one is. -/
def runSlots (prog : Array Inst) (text : List Nat) :
    Nat → Nat → List (Nat × List (Option Nat)) → Option (Nat × List (Option Nat)) →
      Option (Nat × List (Option Nat))
  | 0, _, _, best => best
  | turns + 1, i, seeds, best =>
    let found := threadsSlots prog text i seeds
    let live := found.takeWhile (fun t => !isDone prog t.1)
    let best' := bestOf prog found i best
    match live, text[i]? with
    | [], _ => best'
    | _ :: _, none => best'
    | _ :: _, some b =>
      runSlots prog text turns (i + 1) (live.filterMap fun t => (step prog t.1 b).map (·, t.2))
        best'

/-- With the slots left out, the first thread that is `match` is where `any` finds one. -/
theorem find_done (prog : Array Inst) (found : List (Nat × List (Option Nat))) (i : Nat)
    (best : Option (Nat × List (Option Nat))) :
    (bestOf prog found i best).map (·.1) =
      if (found.map (·.1)).any (isDone prog) then some i else best.map (·.1) := by
  unfold bestOf
  induction found with
  | nil => simp
  | cons t rest ih =>
    by_cases hd : isDone prog t.1 = true
    · simp [List.find?, hd]
    · simp only [Bool.not_eq_true] at hd
      simp only [List.find?, hd, List.map_cons, List.any_cons, Bool.false_or]
      exact ih

/-- With the slots left out, the threads after a byte are those of `run`. -/
theorem step_erase (prog : Array Inst) (b : Nat) (live : List (Nat × List (Option Nat))) :
    (live.filterMap fun t => (step prog t.1 b).map (·, t.2)).map (·.1) =
      (live.map (·.1)).filterMap (step prog · b) := by
  induction live with
  | nil => rfl
  | cons t rest ih =>
    simp only [List.filterMap_cons, List.map_cons]
    cases hs : step prog t.1 b with
    | none => simpa [hs] using ih
    | some out => simpa [hs] using ih

/-- With the slots left out, `runSlots` is `run`. -/
theorem runSlots_end (prog : Array Inst) (text : List Nat) :
    ∀ turns i seeds best,
      (runSlots prog text turns i seeds best).map (·.1) =
        run prog text turns i (seeds.map (·.1)) (best.map (·.1)) := by
  intro turns
  induction turns with
  | zero => intro i seeds best; rfl
  | succ turns ih =>
    intro i seeds best
    simp only [runSlots, run]
    have hfound := threadsSlots_erase prog text i seeds
    have hlive : ((threadsSlots prog text i seeds).takeWhile (fun t => !isDone prog t.1)).map
        (·.1) = (threads prog text i (seeds.map (·.1))).takeWhile (fun pc => !isDone prog pc) := by
      rw [← hfound, List.takeWhile_map]
      rfl
    have hbest := find_done prog (threadsSlots prog text i seeds) i best
    rw [hfound] at hbest
    cases hl : (threadsSlots prog text i seeds).takeWhile (fun t => !isDone prog t.1) with
    | nil =>
      rw [hl] at hlive
      simp only [List.map_nil] at hlive
      rw [← hlive]
      exact hbest
    | cons t rest =>
      rw [hl] at hlive
      simp only [List.map_cons] at hlive
      rw [← hlive]
      cases hb : text[i]? with
      | none => exact hbest
      | some b =>
        simp only
        rw [ih, hbest]
        congr 1
        exact step_erase prog b (t :: rest)

/-- The end and the slots of the matcher's match for a search that must start at `s`, with
`count` slots, none of them written at the start. -/
def capturesAt (prog : Array Inst) (entry : Nat) (text : List Nat) (s count : Nat) :
    Option (Nat × List (Option Nat)) :=
  runSlots prog text (text.length - s + 1) s [(entry, List.replicate count none)] none

/-- The match whose slots `capturesAt` gives ends where `findAt` says. -/
theorem capturesAt_end (prog : Array Inst) (entry : Nat) (text : List Nat) (s count : Nat) :
    (capturesAt prog entry text s count).map (·.1) = findAt prog entry text s := by
  unfold capturesAt findAt
  rw [runSlots_end]
  rfl

/-- The groups of a list of slots: for each two slots, the span from the first to the second,
or nothing where the path wrote neither or one alone (`Matcher.group`). -/
def groupsOf : List (Option Nat) → List (Option (Nat × Nat))
  | some s :: some e :: rest => some (s, e) :: groupsOf rest
  | _ :: _ :: rest => none :: groupsOf rest
  | _ => []

/-! ## The groups on small programs -/

/-- `(a+)(b)?` between its saves: slots 0 and 1 for the whole match, 2 and 3 for `a+`, 4 and 5
for `b`. In `xaab` from 1 the match ends at 4 with both groups. In `xaa` from 1 it ends at 3,
and the second group took no part. `(a|ab)(b?)` on `ab` takes `a` first, so its second group
holds `b`. -/
example :
    (capturesAt #[.save 0 1, .save 2 2, .range 97 97 3, .split 2 4, .save 3 5, .split 6 9,
        .save 4 7, .range 98 98 8, .save 5 9, .save 1 10, .done] 0 [120, 97, 97, 98] 1 6).map
        (fun m => (m.1, groupsOf m.2)) = some (4, [some (1, 4), some (1, 3), some (3, 4)]) ∧
      (capturesAt #[.save 0 1, .save 2 2, .range 97 97 3, .split 2 4, .save 3 5, .split 6 9,
        .save 4 7, .range 98 98 8, .save 5 9, .save 1 10, .done] 0 [120, 97, 97] 1 6).map
        (fun m => (m.1, groupsOf m.2)) = some (3, [some (1, 3), some (1, 3), none]) ∧
      (capturesAt #[.save 0 1, .save 2 2, .split 3 4, .range 97 97 6, .range 97 97 5,
        .range 98 98 6, .save 3 7, .save 4 8, .split 9 10, .range 98 98 10, .save 5 11,
        .save 1 12, .done] 0 [97, 98] 0 6).map
        (fun m => (m.1, groupsOf m.2)) = some (2, [some (0, 2), some (0, 1), some (1, 2)]) := by
  decide

end Stdx.Regex.Matcher
