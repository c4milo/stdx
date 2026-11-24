/-!
# A program, and the paths it takes over a text

`src/regex/program.zig` holds a compiled pattern as instructions that read one byte at a time
(decision 86). This file holds the instructions, and what it means for a program to match: a path
from its entry to `match` that takes the text's bytes in order. The matcher, the DFAs and every
claim of the searcher answer about these paths.

A program reads a text in one direction. The forward program reads it from its start. The reverse
program reads it from its end, so its text here is the forward text read backward.

Two theorems tie claim R4's two walks of the reverse program to its paths:

- `path_clean`: where no instruction that the program reaches from an instruction takes a byte,
  no path from that instruction takes it. `dfa_suffix.before_takes` is that walk.
- `chain_path`: where the instructions from an instruction take the bytes of a literal one after
  another, every path from it to `match` takes those bytes first. `Literal.walk` is that walk,
  for a literal with no place that folds.

Bytes, instruction indexes and offsets are natural numbers.
-/
namespace Stdx.Regex.Program

/-- What the byte on one side of a position is to an assertion (`program.Context`). -/
inductive Context where
  /-- No byte: the text starts or ends here. -/
  | edge
  /-- A line feed. -/
  | lineFeed
  /-- An ASCII letter, a digit or a low line. -/
  | word
  /-- Any other byte. -/
  | other
  deriving DecidableEq, Repr

/-- The context of one byte (`Context.of`). -/
def Context.of (b : Nat) : Context :=
  if b = 0x0A then .lineFeed
  else if (0x30 ≤ b ∧ b ≤ 0x39) ∨ (0x41 ≤ b ∧ b ≤ 0x5A) ∨ (0x61 ≤ b ∧ b ≤ 0x7A) ∨ b = 0x5F then .word
  else .other

/-- An assertion about a position, in the order a matcher reads the text (`program.Look`). -/
inductive Look where
  /-- The text starts behind the position. -/
  | behindText
  /-- The text ends ahead of the position. -/
  | aheadText
  /-- A line starts behind the position. -/
  | behindLine
  /-- A line ends ahead of the position. -/
  | aheadLine
  /-- A word character stands on one side alone. -/
  | wordBoundary
  /-- A word character stands on both sides or on neither. -/
  | notWordBoundary
  deriving DecidableEq, Repr

/-- Whether an assertion holds between the byte behind and the byte ahead (`Look.holds`). -/
def Look.holds : Look → Context → Context → Bool
  | .behindText, behind, _ => behind == .edge
  | .aheadText, _, ahead => ahead == .edge
  | .behindLine, behind, _ => behind == .edge || behind == .lineFeed
  | .aheadLine, _, ahead => ahead == .edge || ahead == .lineFeed
  | .wordBoundary, behind, ahead => (behind == .word) != (ahead == .word)
  | .notWordBoundary, behind, ahead => (behind == .word) == (ahead == .word)

/-- The same assertion for a matcher that reads the text in the other direction
(`Look.reversed`). -/
def Look.reversed : Look → Look
  | .behindText => .aheadText
  | .aheadText => .behindText
  | .behindLine => .aheadLine
  | .aheadLine => .behindLine
  | .wordBoundary => .wordBoundary
  | .notWordBoundary => .notWordBoundary

/-- An assertion read in the other direction holds with its two sides exchanged, as the Zig test
of `Look.reversed` requires. -/
theorem Look.reversed_holds (look : Look) (behind ahead : Context) :
    look.reversed.holds ahead behind = look.holds behind ahead := by
  cases look <;> cases behind <;> cases ahead <;> rfl

/-- One instruction (`program.Instruction`). -/
inductive Inst where
  /-- Take one byte from `lo` to `hi`, both included, then go to `out`. -/
  | range (lo hi out : Nat)
  /-- Take one byte that one of the next `count` instructions takes, each a `range`, then go to
  that one's `out`. -/
  | ranges (count : Nat)
  /-- Go to `out` first and to `arg` second. -/
  | split (out arg : Nat)
  /-- Write the position into a slot, then go to `out`. -/
  | save (slot out : Nat)
  /-- Go to `out` when the assertion holds at the position. -/
  | look (look : Look) (out : Nat)
  /-- Go to `out`. -/
  | jump (out : Nat)
  /-- The pattern matched (`Kind.match`). -/
  | done
  /-- No byte passes. -/
  | fail
  deriving DecidableEq, Repr

/-- The context of the byte behind an offset of a text, in the order the program reads it. -/
def behind (text : List Nat) (i : Nat) : Context :=
  if i = 0 then .edge else
    match text[i - 1]? with
    | some b => Context.of b
    | none => .edge

/-- The context of the byte ahead of an offset of a text. -/
def ahead (text : List Nat) (i : Nat) : Context :=
  match text[i]? with
  | some b => Context.of b
  | none => .edge

/-- The instruction at `pc` takes the byte `b` and goes to `out`: a `range` that holds `b`, or a
`ranges` node one of whose ranges holds it (`program.step`). -/
inductive Takes (prog : Array Inst) (pc b out : Nat) : Prop where
  /-- A range that holds the byte. -/
  | range {lo hi : Nat} : prog[pc]? = some (.range lo hi out) → lo ≤ b → b ≤ hi → Takes prog pc b out
  /-- A node whose range `j` holds the byte. -/
  | member {count j lo hi : Nat} : prog[pc]? = some (.ranges count) → j < count →
      prog[pc + 1 + j]? = some (.range lo hi out) → lo ≤ b → b ≤ hi → Takes prog pc b out

/-- One move of a thread that takes no byte, from one instruction to the next at an offset. -/
inductive Free (prog : Array Inst) (text : List Nat) (i : Nat) : Nat → Nat → Prop where
  /-- A split's preferred branch. -/
  | splitOut {pc out arg : Nat} : prog[pc]? = some (.split out arg) → Free prog text i pc out
  /-- A split's other branch. -/
  | splitArg {pc out arg : Nat} : prog[pc]? = some (.split out arg) → Free prog text i pc arg
  /-- A save. -/
  | save {pc slot out : Nat} : prog[pc]? = some (.save slot out) → Free prog text i pc out
  /-- A jump. -/
  | jump {pc out : Nat} : prog[pc]? = some (.jump out) → Free prog text i pc out
  /-- An assertion that holds at the offset. -/
  | look {pc out : Nat} {l : Look} : prog[pc]? = some (.look l out) →
      l.holds (behind text i) (ahead text i) = true → Free prog text i pc out

/-- A path of a program over a text: from an instruction at an offset to an instruction at an
offset, by moves that take no byte and moves that take the next byte. -/
inductive Path (prog : Array Inst) (text : List Nat) : Nat → Nat → Nat → Nat → Prop where
  /-- The path of no move. -/
  | here {pc i : Nat} : Path prog text pc i pc i
  /-- A move that takes no byte, then a path. -/
  | free {pc i mid pc' j : Nat} : Free prog text i pc mid → Path prog text mid i pc' j →
      Path prog text pc i pc' j
  /-- A move that takes the byte at the offset, then a path. -/
  | take {pc i b mid pc' j : Nat} : text[i]? = some b → Takes prog pc b mid →
      Path prog text mid (i + 1) pc' j → Path prog text pc i pc' j

/-- The program matches the text's bytes from `s` up to `e`, read from `entry`: a path from the
entry at `s` ends at `match` at `e`. -/
def Matches (prog : Array Inst) (entry : Nat) (text : List Nat) (s e : Nat) : Prop :=
  ∃ pc, Path prog text entry s pc e ∧ prog[pc]? = some .done

/-- A path never goes back in the text. -/
theorem Path.le {prog : Array Inst} {text : List Nat} {pc i pc' j : Nat}
    (h : Path prog text pc i pc' j) : i ≤ j := by
  induction h with
  | here => exact Nat.le_refl _
  | free _ _ ih => exact ih
  | take _ _ _ ih => omega

/-- An instruction leads to another in one move, whatever the text holds. -/
inductive Edge (prog : Array Inst) : Nat → Nat → Prop where
  /-- A move that takes some byte. -/
  | takes {pc b out : Nat} : Takes prog pc b out → Edge prog pc out
  /-- A split's preferred branch. -/
  | splitOut {pc out arg : Nat} : prog[pc]? = some (.split out arg) → Edge prog pc out
  /-- A split's other branch. -/
  | splitArg {pc out arg : Nat} : prog[pc]? = some (.split out arg) → Edge prog pc arg
  /-- A save. -/
  | save {pc slot out : Nat} : prog[pc]? = some (.save slot out) → Edge prog pc out
  /-- A jump. -/
  | jump {pc out : Nat} : prog[pc]? = some (.jump out) → Edge prog pc out
  /-- An assertion, taken to hold. -/
  | look {pc out : Nat} {l : Look} : prog[pc]? = some (.look l out) → Edge prog pc out

/-- The instructions a program reaches from an instruction, by any moves. -/
inductive Reach (prog : Array Inst) : Nat → Nat → Prop where
  /-- An instruction reaches itself. -/
  | here {pc : Nat} : Reach prog pc pc
  /-- One move, then the instructions its target reaches. -/
  | move {pc mid pc' : Nat} : Edge prog pc mid → Reach prog mid pc' → Reach prog pc pc'

/-- A move that takes no byte is an edge. -/
theorem Free.edge {prog : Array Inst} {text : List Nat} {i pc out : Nat}
    (h : Free prog text i pc out) : Edge prog pc out := by
  cases h with
  | splitOut h => exact .splitOut h
  | splitArg h => exact .splitArg h
  | save h => exact .save h
  | jump h => exact .jump h
  | look h _ => exact .look h

/-- `dfa_suffix.before_takes`, as a rule: where no instruction that the program reaches from `pc`
takes the byte `b`, no path from `pc` takes it. So the text holds no `b` from the path's first
offset up to its last. -/
theorem path_clean {prog : Array Inst} {text : List Nat} {b pc i pc' j : Nat}
    (hpath : Path prog text pc i pc' j)
    (hnone : ∀ x out, Reach prog pc x → ¬ Takes prog x b out) :
    ∀ q, i ≤ q → q < j → text[q]? ≠ some b := by
  induction hpath with
  | here => intro q h1 h2; omega
  | free hfree _ ih =>
    exact ih (fun x out hx => hnone x out (.move hfree.edge hx))
  | @take pc i c mid pc' j hbyte htakes _ ih =>
    intro q h1 h2 hq
    cases Nat.eq_or_lt_of_le h1 with
    | inl heq =>
      subst heq
      have hc : c = b := by
        rw [hbyte] at hq
        exact Option.some.inj hq
      subst hc
      exact hnone pc mid .here htakes
    | inr hlt =>
      exact ih (fun x out hx => hnone x out (.move (.takes htakes) hx)) q hlt h2 hq

/-- `Literal.walk`, as a rule: from `pc`, through saves, jumps and assertions, the instructions
take the bytes of `literal` one after another, each a range of one byte, and lead to `stop`. -/
inductive Chain (prog : Array Inst) : Nat → List Nat → Nat → Prop where
  /-- The walk of no instruction. -/
  | stop {pc : Nat} : Chain prog pc [] pc
  /-- A save, which takes no byte. -/
  | save {pc slot out stop : Nat} {literal : List Nat} : prog[pc]? = some (.save slot out) →
      Chain prog out literal stop → Chain prog pc literal stop
  /-- A jump, which takes no byte. -/
  | jump {pc out stop : Nat} {literal : List Nat} : prog[pc]? = some (.jump out) →
      Chain prog out literal stop → Chain prog pc literal stop
  /-- An assertion, which takes no byte. -/
  | look {pc out stop : Nat} {l : Look} {literal : List Nat} : prog[pc]? = some (.look l out) →
      Chain prog out literal stop → Chain prog pc literal stop
  /-- A range of one byte, which is the literal's next byte. -/
  | byte {pc b out stop : Nat} {literal : List Nat} : prog[pc]? = some (.range b b out) →
      Chain prog out literal stop → Chain prog pc (b :: literal) stop

/-- `Literal.walk`'s literal starts every path: a path from `pc` to `match` takes the literal's
bytes first, and goes on from `stop` at the offset after them. -/
theorem chain_path {prog : Array Inst} {text : List Nat} {pc stop : Nat} {literal : List Nat}
    (hchain : Chain prog pc literal stop) :
    ∀ {i pc' j : Nat}, Path prog text pc i pc' j → prog[pc']? = some .done →
      (∀ m, m < literal.length → text[i + m]? = literal[m]?) ∧
        Path prog text stop (i + literal.length) pc' j := by
  induction hchain with
  | stop =>
    intro i pc' j hpath _
    exact ⟨fun m hm => absurd hm (Nat.not_lt_zero m), hpath⟩
  | save hinst _ ih =>
    intro i pc' j hpath hdone
    cases hpath with
    | here => simp [hinst] at hdone
    | free hfree hrest =>
      cases hfree with
      | splitOut h => simp [hinst] at h
      | splitArg h => simp [hinst] at h
      | save h => simp [hinst] at h; exact ih (h.2 ▸ hrest) hdone
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
      | jump h => simp [hinst] at h; exact ih (h ▸ hrest) hdone
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
      | look h _ => simp [hinst] at h; exact ih (h.2 ▸ hrest) hdone
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
        have ⟨hbytes, hgo⟩ := ih (hout ▸ hrest) hdone
        refine ⟨?_, ?_⟩
        · intro m hm
          cases m with
          | zero => simpa using hbyte
          | succ m =>
            have hm' : m < literal.length := by simpa using hm
            have := hbytes m hm'
            have hidx : i + (m + 1) = i + 1 + m := by omega
            rw [hidx, this]
            simp
        · have hidx : i + (c :: literal).length = i + 1 + literal.length := by
            simp only [List.length_cons]; omega
          rw [hidx]
          exact hgo

end Stdx.Regex.Program
