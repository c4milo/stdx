import Stdx.Utf8
import Stdx.Json.Number
import Stdx.Regex.Utf8
import Stdx.Regex.Program
import Stdx.Regex.SuffixRule
import Stdx.Regex.Required
import Stdx.Regex.Inner
import Stdx.Regex.Edges
import Stdx.Regex.Prefix
import Stdx.Regex.Count
import Stdx.Regex.Closure
import Stdx.Regex.Matcher

/-!
# What the proofs rest on

Each theorem the Zig code relies on, with the axioms its proof uses, pinned. A proof left
unfinished compiles to `sorryAx`, which would change a line below and fail `lake build`. The three
that may appear are the ones every Lean proof about functions and propositions may use:
`propext`, `Classical.choice` and `Quot.sound`. A pin covers every lemma its theorem's proof uses.
-/
namespace Stdx

/-- info: 'Stdx.Utf8.accepts_iff' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Utf8.accepts_iff

/-- info: 'Stdx.Utf8.refuses_iff' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Utf8.refuses_iff

end Stdx

namespace Stdx.Json

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

namespace Stdx.Regex

/-- info: 'Stdx.Regex.Utf8.encode_char' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Utf8.encode_char

/-- info: 'Stdx.Regex.Utf8.char_encode' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Utf8.char_encode

/-- info: 'Stdx.Regex.Utf8.whole_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Utf8.whole_iff

/-- info: 'Stdx.Regex.Utf8.cut_spec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Utf8.cut_spec

/-- info: 'Stdx.Regex.Utf8.sequences_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Utf8.sequences_iff

/-- info: 'Stdx.Regex.Program.path_clean' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Program.path_clean

/-- info: 'Stdx.Regex.Program.chain_path' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Program.chain_path

/-- info: 'Stdx.Regex.Program.suffix_rule' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Program.suffix_rule

/-- info: 'Stdx.Regex.Search.answer_one' does not depend on any axioms -/
#guard_msgs in #print axioms Search.answer_one

/-- info: 'Stdx.Regex.Search.bySuffix_answer' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.bySuffix_answer

/-- info: 'Stdx.Regex.Search.one_end' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.one_end

/-- info: 'Stdx.Regex.Search.starts_after_place' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.starts_after_place

/-- info: 'Stdx.Regex.Search.byRequired_answer' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.byRequired_answer

/-- info: 'Stdx.Regex.Search.noEarlier_of_clean' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.noEarlier_of_clean

/-- info: 'Stdx.Regex.Search.noEarlier_of_one_length' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.noEarlier_of_one_length

/-- info: 'Stdx.Regex.Search.noEarlier_of_last_separator' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.noEarlier_of_last_separator

/-- info: 'Stdx.Regex.Search.noEarlier_of_first_separator' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.noEarlier_of_first_separator

/-- info: 'Stdx.Regex.Search.needs_no_earlier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Search.needs_no_earlier

/-- info: 'Stdx.Regex.Search.byGuarded_answer' depends on axioms: [propext] -/
#guard_msgs in #print axioms Search.byGuarded_answer

/-- info: 'Stdx.Regex.Search.bySuffix_rising' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.bySuffix_rising

/-- info: 'Stdx.Regex.Search.rising_of_one_length' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.rising_of_one_length

/-- info: 'Stdx.Regex.Search.rising_of_last_separator' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.rising_of_last_separator

/-- info: 'Stdx.Regex.Search.byInner_answer' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.byInner_answer

/-- info: 'Stdx.Regex.Search.beforeRising_of_clean' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.beforeRising_of_clean

/-- info: 'Stdx.Regex.Search.beforeRising_of_one_count' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.beforeRising_of_one_count

/-- info: 'Stdx.Regex.Search.beforeRising_of_last_separator' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.beforeRising_of_last_separator

/-- info: 'Stdx.Regex.Search.atStart_answer' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.atStart_answer

/-- info: 'Stdx.Regex.Search.fromEnd_answer' does not depend on any axioms -/
#guard_msgs in #print axioms Search.fromEnd_answer

/-- info: 'Stdx.Regex.Search.excluded_answer' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.excluded_answer

/-- info: 'Stdx.Regex.Search.excludes_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Search.excludes_iff

/-- info: 'Stdx.Regex.Search.answer_from_place' does not depend on any axioms -/
#guard_msgs in #print axioms Search.answer_from_place

/-- info: 'Stdx.Regex.Search.answer_none' does not depend on any axioms -/
#guard_msgs in #print axioms Search.answer_none

/-- info: 'Stdx.Regex.Search.byExact_answer' does not depend on any axioms -/
#guard_msgs in #print axioms Search.byExact_answer

/-- info: 'Stdx.Regex.Search.byte_between' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.byte_between

/-- info: 'Stdx.Regex.Search.gap_of_byte' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.gap_of_byte

/-- info: 'Stdx.Regex.Search.nextEnd_eq' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.nextEnd_eq

/-- info: 'Stdx.Regex.Search.count_eq' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.count_eq

/-- info: 'Stdx.Regex.Closure.follow_sim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Closure.follow_sim

/-- info: 'Stdx.Regex.Closure.closure_value' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Closure.closure_value

/-- info: 'Stdx.Regex.Matcher.run_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.run_eq

/-- info: 'Stdx.Regex.Matcher.findAt_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.findAt_eq

end Stdx.Regex
