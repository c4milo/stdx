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
import Stdx.Regex.Captures
import Stdx.Regex.MatcherPaths
import Stdx.Regex.MatcherSearch
import Stdx.Regex.MatcherAnswer
import Stdx.Regex.Dfa
import Stdx.Regex.Reverse
import Stdx.Regex.Hypotheses
import Stdx.Regex.Searcher
import Stdx.Regex.Rules
import Stdx.Regex.RulesWide
import Stdx.Regex.RulesPrefix
import Stdx.Regex.RulesSeparator
import Stdx.Regex.SearcherInner
import Stdx.Regex.RulesInner
import Stdx.Regex.RulesWindow
import Stdx.Regex.RulesWindowSet

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

/-- info: 'Stdx.Regex.Matcher.backtrack_sound' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.backtrack_sound

/-- info: 'Stdx.Regex.Matcher.backtrack_complete' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.backtrack_complete

/-- info: 'Stdx.Regex.Matcher.search_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.search_eq

/-- info: 'Stdx.Regex.Matcher.search_answer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.search_answer

/-- info: 'Stdx.Regex.Closure.mem_closure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Closure.mem_closure

/-- info: 'Stdx.Regex.Dfa.scan_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Dfa.scan_eq

/-- info: 'Stdx.Regex.Dfa.scan_answer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Dfa.scan_answer

/-- info: 'Stdx.Regex.Dfa.cached' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Dfa.cached

/-- info: 'Stdx.Regex.Matcher.runLongest_sound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.runLongest_sound

/-- info: 'Stdx.Regex.Matcher.runLongest_complete' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.runLongest_complete

/-- info: 'Stdx.Regex.Matcher.scanBack_some' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.scanBack_some

/-- info: 'Stdx.Regex.Matcher.scanBack_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.scanBack_least

/-- info: 'Stdx.Regex.Matcher.scanBack_none' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.scanBack_none

/-- info: 'Stdx.Regex.Matcher.answerOf_isAnswer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.answerOf_isAnswer

/-- info: 'Stdx.Regex.Matcher.answerFast_isAnswer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.answerFast_isAnswer

/-- info: 'Stdx.Regex.Matcher.search_none' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.search_none

/-- info: 'Stdx.Regex.Matcher.isAnswer_of_isAnswerOf' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.isAnswer_of_isAnswerOf

/-- info: 'Stdx.Regex.Matcher.exact_of_isExact' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.exact_of_isExact

/-- info: 'Stdx.Regex.Matcher.mem_endsFrom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.mem_endsFrom

/-- info: 'Stdx.Regex.Matcher.reverses_of_reversesOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.reverses_of_reversesOn

/-- info: 'Stdx.Regex.Matcher.byDfa_answer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.byDfa_answer

/-- info: 'Stdx.Regex.Matcher.bySuffix_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.bySuffix_program

/-- info: 'Stdx.Regex.Matcher.byRequired_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.byRequired_program

/-- info: 'Stdx.Regex.Matcher.atStart_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.atStart_program

/-- info: 'Stdx.Regex.Matcher.fromEnd_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.fromEnd_program

/-- info: 'Stdx.Regex.Matcher.bySkip_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.bySkip_program

/-- info: 'Stdx.Regex.Matcher.startsClean_of_startsCleanOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.startsClean_of_startsCleanOn

/-- info: 'Stdx.Regex.Matcher.emptyElsewhere_of_emptyElsewhereOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.emptyElsewhere_of_emptyElsewhereOn

/-- info: 'Stdx.Regex.Matcher.chain_of_chainStop' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.chain_of_chainStop

/-- info: 'Stdx.Regex.Matcher.reach_mem' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.reach_mem

/-- info: 'Stdx.Regex.Matcher.noneTakes_sound' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.noneTakes_sound

/-- info: 'Stdx.Regex.Matcher.apart_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.apart_program

/-- info: 'Stdx.Regex.Matcher.fixed_of_levelsOk' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.fixed_of_levelsOk

/-- info: 'Stdx.Regex.Matcher.fixed_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.fixed_program

/-- info: 'Stdx.Regex.Search.window_start' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.window_start

/-- info: 'Stdx.Regex.Search.answer_from_window' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.answer_from_window

/-- info: 'Stdx.Regex.Search.window_none' does not depend on any axioms -/
#guard_msgs in #print axioms Search.window_none

/-- info: 'Stdx.Regex.Search.within_of_inner' does not depend on any axioms -/
#guard_msgs in #print axioms Search.within_of_inner

/-- info: 'Stdx.Regex.Search.within_wider' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Search.within_wider

/-- info: 'Stdx.Regex.Matcher.bounded_of_boundsOk' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.bounded_of_boundsOk

/-- info: 'Stdx.Regex.Matcher.boundedLength_sound' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.boundedLength_sound

/-- info: 'Stdx.Regex.Matcher.window_within' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.window_within

/-- info: 'Stdx.Regex.Matcher.window_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.window_program

/-- info: 'Stdx.Regex.Matcher.passesAny_split' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.passesAny_split

/-- info: 'Stdx.Regex.Matcher.passesAnyOn_split' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.passesAnyOn_split

/-- info: 'Stdx.Regex.Matcher.findBy_some' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.findBy_some

/-- info: 'Stdx.Regex.Matcher.findBy_none' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.findBy_none

/-- info: 'Stdx.Regex.Matcher.reads_take' depends on axioms: [propext] -/
#guard_msgs in #print axioms Matcher.reads_take

/-- info: 'Stdx.Regex.Matcher.windowSet_within' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.windowSet_within

/-- info: 'Stdx.Regex.Matcher.windowSet_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.windowSet_program

/-- info: 'Stdx.Regex.Matcher.fits_of_takesFit' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.fits_of_takesFit

/-- info: 'Stdx.Regex.Matcher.reads_of_leadsOk' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.reads_of_leadsOk

/-- info: 'Stdx.Regex.Matcher.leads_reads' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.leads_reads

/-- info: 'Stdx.Regex.Matcher.startsWith_of_leads' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.startsWith_of_leads

/-- info: 'Stdx.Regex.Matcher.leads_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.leads_program

/-- info: 'Stdx.Regex.Matcher.first_separator' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.first_separator

/-- info: 'Stdx.Regex.Matcher.inside_first' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.inside_first

/-- info: 'Stdx.Regex.Matcher.separated_rising' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.separated_rising

/-- info: 'Stdx.Regex.Matcher.separated_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.separated_program

/-- info: 'Stdx.Regex.Matcher.wide_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.wide_program

/-- info: 'Stdx.Regex.Matcher.chain_prefix' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.chain_prefix

/-- info: 'Stdx.Regex.Matcher.chain_of_chainTo' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.chain_of_chainTo

/-- info: 'Stdx.Regex.Matcher.passes_split' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.passes_split

/-- info: 'Stdx.Regex.Matcher.scanBack_accepts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.scanBack_accepts

/-- info: 'Stdx.Regex.Matcher.scanBack_accepts_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.scanBack_accepts_least

/-- info: 'Stdx.Regex.Matcher.scanBack_accepts_none' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.scanBack_accepts_none

/-- info: 'Stdx.Regex.Matcher.inner_apart' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.inner_apart

/-- info: 'Stdx.Regex.Matcher.inner_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.inner_fixed

/-- info: 'Stdx.Regex.Matcher.inner_separated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.inner_separated

/-- info: 'Stdx.Regex.Matcher.beforeOn_rising' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.beforeOn_rising

/-- info: 'Stdx.Regex.Matcher.innerOn_parts' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.innerOn_parts

/-- info: 'Stdx.Regex.Matcher.inner_program' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.inner_program

/-- info: 'Stdx.Regex.Matcher.chain_seps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms Matcher.chain_seps

/-- info: 'Stdx.Regex.Matcher.chain_first' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.chain_first

/-- info: 'Stdx.Regex.Matcher.chain_none' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.chain_none

/-- info: 'Stdx.Regex.Matcher.followSlots_erase' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.followSlots_erase

/-- info: 'Stdx.Regex.Matcher.runSlots_end' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.runSlots_end

/-- info: 'Stdx.Regex.Matcher.capturesAt_end' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms Matcher.capturesAt_end

end Stdx.Regex
