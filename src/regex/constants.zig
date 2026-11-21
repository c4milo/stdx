//! The limits of the `regex` module (decision 86, design §8 step 22): what RFC 3629 fixes for
//! UTF-8, what RFC 9485 §8 lets an implementation bound, and the sizes stdx chose.
const std = @import("std");

/// The values one octet takes.
pub const octet_values = 256;

/// The largest octet.
pub const octet_max = 0xFF;

/// The largest Unicode scalar value (RFC 3629 §3).
pub const scalar_max = 0x10FFFF;

/// The first and the last surrogate, which UTF-8 never encodes (RFC 3629 §3).
pub const surrogate_first = 0xD800;
pub const surrogate_last = 0xDFFF;

/// The largest scalar value that one, two and three octets encode (RFC 3629 §3).
pub const one_octet_max = 0x7F;
pub const two_octets_max = 0x7FF;
pub const three_octets_max = 0xFFFF;

/// The octets of the longest UTF-8 sequence (RFC 3629 §3).
pub const utf8_len_max = 4;

/// The lengths of the multi-octet sequences (RFC 3629 §3).
pub const two_octets = 2;
pub const three_octets = 3;

/// The bits of a scalar value that each continuation octet holds, and their mask (RFC 3629 §3).
pub const continuation_bits = 6;
pub const continuation_mask = 0x3F;

/// The first and the last continuation octet, 10xxxxxx (RFC 3629 §3).
pub const continuation_min = 0x80;
pub const continuation_max = 0xBF;

/// The leading octets of a sequence of two, three and four octets with no payload bit set:
/// 110xxxxx, 1110xxxx and 11110xxx (RFC 3629 §3).
pub const two_octets_lead = 0xC0;
pub const three_octets_lead = 0xE0;
pub const four_octets_lead = 0xF0;

/// The first leading octet that RFC 3629 §4's syntax allows for two octets: C0 and C1 would
/// encode a scalar value below U+0080.
pub const two_octets_lead_min = 0xC2;

/// The last leading octet RFC 3629 §4's syntax allows: F5 and above would pass U+10FFFF.
pub const lead_max = 0xF4;

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
/// `dfa_match_flag` where a match ended before the octet that led to it and `dfa_dead_flag` where
/// no later octet can change the search's answer. An entry of all ones is not yet computed.
pub const dfa_match_flag = 0x8000_0000;
pub const dfa_dead_flag = 0x4000_0000;
pub const dfa_row_mask = 0x3FFF_FFFF;
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

/// The words a cache keeps for a state beside its row of the table: where its record starts, and
/// two slots of the hash table, which is kept at most half full.
pub const dfa_words_per_state = 3;

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
    std.debug.assert(one_octet_max + 1 == continuation_min);
    std.debug.assert(continuation_max - continuation_min == continuation_mask);
    std.debug.assert(1 << context_bits == context_count);
    std.debug.assert(dfa_match_flag | dfa_dead_flag | dfa_row_mask == dfa_unknown);
    std.debug.assert(dfa_record_words > dfa_record_head);
}
