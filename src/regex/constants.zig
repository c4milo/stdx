//! The limits of the `regex` module (decision 86, design §8 step 22): what RFC 3629 fixes for
//! UTF-8, as the `utf8` module names it, what RFC 9485 §8 lets an implementation bound, and the
//! sizes stdx chose.
const std = @import("std");
const utf8 = @import("utf8");

/// The values one octet takes.
pub const octet_values = 256;

/// The largest octet.
pub const octet_max = 0xFF;

/// The largest Unicode scalar value (RFC 3629 §3). The `utf8` module names it `code_point_max`,
/// and each constant of UTF-8 below is that module's, as a number of no fixed type.
pub const scalar_max = @as(comptime_int, utf8.constants.code_point_max);

/// The first and the last surrogate, which UTF-8 never encodes (RFC 3629 §3).
pub const surrogate_min = @as(comptime_int, utf8.constants.surrogate_min);
pub const surrogate_max = @as(comptime_int, utf8.constants.surrogate_max);

/// The largest scalar value that one, two and three octets encode (RFC 3629 §3).
pub const one_octet_max = @as(comptime_int, utf8.constants.one_octet_max);
pub const two_octets_max = @as(comptime_int, utf8.constants.two_octets_max);
pub const three_octets_max = @as(comptime_int, utf8.constants.three_octets_max);

/// The octets of the longest UTF-8 sequence (RFC 3629 §3).
pub const utf8_len_max = utf8.constants.utf8_len_max;

/// The bits of a scalar value that each continuation octet holds (RFC 3629 §3).
pub const continuation_bits = utf8.constants.continuation_bits;

/// The first and the last continuation octet, 10xxxxxx (RFC 3629 §3).
pub const continuation_min = @as(comptime_int, utf8.constants.continuation_min);
pub const continuation_max = @as(comptime_int, utf8.constants.continuation_max);

/// The line feed, the one octet `.` refuses by default and the octet a line ends with.
pub const line_feed = '\n';

/// The bit that tells an ASCII letter's upper case from its lower case.
pub const ascii_case_bit = 0x20;

/// The largest count a range quantifier names, and the largest product of the counts of nested
/// range quantifiers. RFC 9485 §8 lets an implementation limit both. A count multiplies the
/// program, so the limit bounds the instructions one quantifier adds. RE2 and Go's regexp hold the
/// same 1,000.
pub const repeat_max = 1000;

/// The base of a count's digits, of a `\x` escape's, and of an octal escape's.
pub const decimal_base = 10;
pub const hex_base = 16;
pub const octal_base = 8;

/// The digits of the longest octal escape, as RE2 reads one.
pub const octal_digits_max = 3;

/// The digits of a `\xHH` escape. A `\x{...}` escape holds any number.
pub const hex_short_digits = 2;

/// The deepest nesting of groups a pattern may hold. The parser keeps one frame for each open
/// group in its own stack frame, so the limit bounds that memory, and the parser never recurses.
/// RFC 9485 §8 asks an implementation that takes a regexp from an untrusted source to be robust.
pub const depth_max = 96;

/// The fragments one frame holds before the parser joins the first two: a quantifier applies to
/// the last one alone.
pub const pending_max = 2;

/// The ranges of scalar values one character class holds, after its negation and its case folding.
pub const class_ranges_max = 128;

/// The ranges the UTF-8 split of one range of scalar values keeps on its stack. A split leaves at
/// most one range for each boundary it cuts at: the surrogates, the three lengths, and two for each
/// continuation octet.
pub const utf8_split_stack_len = 16;

/// The most instructions a program holds. A hole in a program under construction keeps a link in
/// 31 bits, two for each instruction.
pub const instructions_max = 1 << 24;

/// The targets one instruction holds at most: a split's two. A hole is named by its instruction's
/// index times this, plus the target's place.
pub const targets_per_instruction = 2;

/// The most instructions `compile_comptime` gives a pattern, and the branches it lets the compiler
/// take to compile one. A pattern past either is a compile error, and its caller compiles it at
/// run time.
pub const comptime_instructions_max = 4096;
pub const comptime_branch_quota = 4_000_000;

/// The bit that marks an instruction's target as a hole: a target not yet known, which holds a
/// link to the next hole of its fragment.
pub const hole_flag = 0x8000_0000;

/// The link that ends a list of holes.
pub const hole_none = 0x7FFF_FFFF;

/// The slots of one capture group: where it starts and where it ends.
pub const group_slots = 2;

/// The capture groups a program holds at most, the whole match included.
pub const groups_max = 1 << 12;

/// A slot that holds no offset.
pub const slot_unset = std.math.maxInt(u64);

/// The bits of a table entry of the lazy DFA. An entry is the place of a state's row, with
/// `dfa_match_flag` where a match ended before the octet that led to it, `dfa_dead_flag` where
/// no later octet can change the search's answer, and `dfa_idle_flag` where the state holds no
/// thread and may start a match, in a DFA that skips to a literal from there (claim R3). An
/// entry under `dfa_flags_min` is a row and nothing else. An entry of all ones is not yet
/// computed.
pub const dfa_match_flag = 0x8000_0000;
pub const dfa_dead_flag = 0x4000_0000;
pub const dfa_idle_flag = 0x2000_0000;
pub const dfa_flags_min = dfa_idle_flag;
pub const dfa_row_mask = 0x1FFF_FFFF;
pub const dfa_unknown = 0xFFFF_FFFF;

/// The fewest states a cache must have room for before a `Searcher` uses the lazy DFA. Under it
/// the cache would clear at almost every octet. RE2 asks for room for the same 20.
pub const dfa_states_min = 20;

/// The octets a lazy DFA must take, for each state it built since its cache last cleared, to go
/// on after the cache fills again. Under it the cache is thrashing: building a state costs more
/// than the matcher's step, so the search goes to the matcher. RE2 and Rust's regex use the same
/// 10.
pub const dfa_octets_per_state_min = 10;

/// The searches a `Searcher` lets its lazy DFA give up before it stops trying the DFA.
pub const dfa_give_ups_max = 8;

/// How a `Searcher` divides its cache: the forward DFA takes this many parts of
/// `dfa_cache_parts`, and the reverse DFA the rest. The forward DFA reads the whole text and the
/// reverse one a match alone. RE2 divides its memory the same way.
pub const dfa_forward_parts = 2;
pub const dfa_cache_parts = 3;

/// The words of cache a `Searcher` takes where its caller names no other size: 512 kB, room for
/// some thousands of states of a usual pattern.
pub const cache_words_default = 1 << 16;

/// The octets one step of a skip judges: 16, the width of SSE2's and NEON's registers, which
/// every x86-64 and aarch64 CPU has (claim R1).
pub const skip_lanes = 16;

/// The octets one step of claim R2's and R5's searches compares in the variant object of x86-64's
/// AVX2: the width of its registers. A caller whose `codec.Features` name AVX2 gets it.
pub const avx2_lanes = 32;

/// The octets of the literal every match starts with that claim R2 keeps at most. A place where
/// the literal's first and last octets stand costs a comparison of this many octets at most, so a
/// search stays linear in the text. A longer literal keeps its first octets, which every match
/// still starts with.
pub const literal_len_max = 32;

/// The steps of `skip_lanes` octets that claim R2's search tests before it looks for a candidate
/// in one: 64 octets, whose mask fits one word. A text with few candidates then costs one
/// branch for each 64 octets, not one for each 16.
pub const literal_steps = 4;

/// The steps of a block of claim R2's search where the text has room for one: 128 octets, so a
/// block's bounds checks and branch cost half as much an octet as in a block of `literal_steps`.
/// A block of `literal_steps` then takes what is left before the octets one at a time.
pub const literal_wide_steps = 8;

/// The literals claim R5 searches for at most, one of which every match starts with. Each costs
/// two compares and an AND a vector, so eight cost about two instructions an octet, under the
/// forward DFA's dozen. A pattern with more branches takes claim R1's skip.
pub const literal_set_max = 8;

/// The fewest literals claim R5 searches for: one literal is claim R2's.
pub const literal_set_count_min = 2;

/// The forward instructions a program may hold for a searcher to judge at `init` whether it is
/// one-pass (claim R6). The judgment walks a closure from each instruction that takes an octet,
/// so it costs at most this many walks of this many instructions.
pub const one_pass_instructions_max = 1024;

/// The bit in which the two cases of an ASCII letter differ (RFC 20's chart). `(?i)` takes a
/// letter as a split between its two cases, and claim R2 compares `octet | case_bit` with the
/// lower case: equal for the two octets that differ in this bit alone, and for no other.
pub const case_bit = 0x20;

/// The shortest literal that claim R2 searches for where more of the pattern follows it. One
/// octet is claim R1's skip, which judges `skip_ranges_max` ranges a step.
pub const literal_prefix_len_min = 2;

/// The ranges of octets a step of a skip judges at most. Three hold a literal's first octet in
/// both cases with one more, the first letters of a few words, or a class such as `[0-9A-Fa-f]`.
/// A set of more ranges is skipped one octet at a time.
pub const skip_ranges_max = 3;

/// The octets a skip judges one at a time before it steps by `skip_lanes`. A step costs about as
/// much as these, so a skip that ends within them, as most do where the start octets are dense,
/// never pays for one.
pub const skip_scalar_run = 8;

/// A DFA judges its skip each time its scans visited the state that waits this many times, and
/// keeps it only where the visits passed `skip_octets_per_visit_min` octets each on average. A
/// visit that passes few octets costs a branch the CPU cannot predict, which is more than the
/// table reads it saves: where the start octets are as dense as the letters in prose, the plain
/// scan is faster. Design §8 step 22 holds the measurement the 8 comes from.
pub const skip_trial_visits = 256;
pub const skip_octets_per_visit_min = 8;

/// The octets a DFA scans with its skip off before it tries the skip again. A text changes: one
/// part's start octets are close together and the next part's are far apart. A trial that fails
/// costs about a microsecond, and this many octets take a hundred times that. Each trial that
/// fails after another doubles the rest, up to `skip_rest_doublings_max` times, so a text that
/// stays dense pays for fewer trials.
pub const skip_rest_octets = 1 << 16;
pub const skip_rest_doublings_max = 4;

/// The words a cache keeps for a state beside its row of the table: where its record starts, and
/// two slots of the hash table, which is kept at most half full.
pub const dfa_words_per_state = 3;

/// The slots of a cache's hash table that `init` and a clear write: room for 32 states. The table
/// doubles as states join, so that a searcher made ready for a short text writes 256 octets of
/// its table, where the default cache's whole table is some 32 KiB.
pub const dfa_slots_first = 64;

/// The words of a state's record a cache plans for when it divides its memory: the record's two
/// leading words, and the instructions of a state of the usual size.
pub const dfa_record_words = 12;

/// The words before the instructions in a state's record: its flags and its length.
pub const dfa_record_head = 2;

/// The hash a cache keys its states by: FNV-1a over the words of a record.
pub const fnv_offset_basis = 0x811C_9DC5;
pub const fnv_prime = 0x0100_0193;

/// The bits of a record's first word that hold what the octet behind the state is to an
/// assertion.
pub const context_bits = 2;

/// The contexts an octet falls in, which the assertions read: the edge of the text, a line feed, a
/// word character, and any other octet.
pub const context_count = 4;

comptime {
    std.debug.assert(repeat_max * repeat_max < std.math.maxInt(u32));
    std.debug.assert(targets_per_instruction * instructions_max < hole_none);
    std.debug.assert(hole_flag & hole_none == 0);
    std.debug.assert(1 << context_bits == context_count);
    std.debug.assert(dfa_match_flag | dfa_dead_flag | dfa_idle_flag | dfa_row_mask == dfa_unknown);
    std.debug.assert(dfa_row_mask + 1 == dfa_flags_min);
    std.debug.assert(dfa_record_words > dfa_record_head);
}
