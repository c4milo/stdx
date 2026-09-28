import Stdx.Json.Utf8
import Stdx.Json.Number

/-!
# What the proofs rest on

Each theorem the Zig code relies on, with the axioms its proof uses, pinned. A proof left
unfinished compiles to `sorryAx`, which would change a line below and fail `lake build`. The three
that may appear are the ones every Lean proof about functions and propositions may use:
`propext`, `Classical.choice` and `Quot.sound`. A pin covers every lemma its theorem's proof uses.
-/
namespace Stdx.Json

/-- info: 'Stdx.Json.Utf8.accepts_iff' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Utf8.accepts_iff

/-- info: 'Stdx.Json.Utf8.refuses_iff' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Utf8.refuses_iff

/-- info: 'Stdx.Json.Number.accepts_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Number.accepts_iff

/-- info: 'Stdx.Json.Number.refuses_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Number.refuses_iff

/-- info: 'Stdx.Json.Number.accept_taken' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Number.accept_taken

/-- info: 'Stdx.Json.Number.ended_spec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Number.ended_spec

/-- info: 'Stdx.Json.Number.invalid_spec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Number.invalid_spec

end Stdx.Json
