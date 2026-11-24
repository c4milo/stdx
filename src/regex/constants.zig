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

/// The ranges of bytes a normalized set holds at most under `Encoding.bytes`. Its ranges stand
/// apart, so each takes two of the 256 values at least, with the gap after it.
pub const octet_ranges_max = octet_values / 2;

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
/// Unicode 17.0.0's largest property, `\p{C}`, holds 741, and `[\p{L}\p{M}\p{N}\p{Pc}]` holds 831,
/// so 2048 holds every class a pattern names with room. The owner ruled it on 2026-11-22: the
/// parser builds each class in one set, which it keeps for the next (decision 86 as amended).
pub const class_ranges_max = 2048;

/// The ranges of the set a pass builds its classes in first. ReleaseSafe writes each octet of a
/// set it declares, so a set of `class_ranges_max` costs a pass 16 KiB of writes. A pass reads a
/// pattern again in a set of `class_ranges_max` when a class does not fit in this one, so the limit
/// stays `class_ranges_max`. `\p{Greek}` and `\p{Latin}` hold 36 ranges each, and `\p{Lu}` 655.
pub const class_ranges_small = 64;

comptime {
    // A pass reads a pattern again only in a larger set.
    std.debug.assert(class_ranges_small < class_ranges_max);
}

/// The ranges of scalar values a class holds, one past U+007F, before the compiler writes it as
/// one automaton (syntax_atom_utf8.zig): under it, one alternative for each sequence of octet
/// ranges costs about as many instructions and no frame of tables. A case orbit holds at most 4.
pub const utf8_compact_ranges_min = 8;

/// The ranges of a `ranges` node that `program.step` reads in order before it halves the rest.
/// A run of like octets lands in one of the first ranges, ASCII in the first one or two, and a
/// branch the core predicts lets it read the next instruction before the range's ends are read.
/// Halving makes each read wait on the one before: four reads for the 10 ranges of `[^;]`.
pub const ranges_scan_len = 4;

/// The transitions the open nodes of a class's automaton hold at most. Forward, the root holds at
/// most one for each octet, 256, and each node under it one for each continuation octet, 64, so
/// 448 hold every class. A reverse root holds one for each distinct range of last octets, which a
/// class of many ranges can push past this: such a class takes one alternative a sequence.
pub const utf8_open_transitions_max = 512;

/// The slots of the table that finds a written node by its transitions, and the slots a lookup
/// reads from the home slot of a hash. `\p{L}` writes about 400 nodes in each direction: a node
/// the table forgot is written again, which costs instructions and changes no match.
pub const utf8_node_slots = 512;
pub const utf8_node_probes = 8;

comptime {
    // A hash finds its home slot with a mask.
    std.debug.assert(std.math.isPowerOfTwo(utf8_node_slots));
}

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

/// The octets of a group's name at most, as `year` in `(?P<year>`. A caller that keeps a
/// program's names gives each `GroupName` this many octets.
pub const group_name_len_max = 64;

/// The named groups a pattern holds at most. RFC 9485 §8 asks an implementation to bound what a
/// regexp costs: the parser keeps each name in its own stack frame, and compares each new name
/// with the names before it, so a name costs at most this many compares.
pub const group_names_max = 128;

/// A slot that holds no offset.
pub const slot_unset = std.math.maxInt(u64);

/// The bits of a table entry of the lazy DFA. An entry is the place of a state's row, with
/// `dfa_match_flag` where a match ended before the octet that led to it, `dfa_dead_flag` where
/// no later octet can change the search's answer, and `dfa_skip_flag` where the scan skips from
/// the state: to a literal, from a state that holds no thread and may start a match (claim R3),
/// or past the octets over which the state stays where it is (claim R9). A DFA takes one of the
/// two claims at most. An entry under `dfa_flags_min` is a row and nothing else. An entry of all
/// ones is not yet computed.
pub const dfa_match_flag = 0x8000_0000;
pub const dfa_dead_flag = 0x4000_0000;
pub const dfa_skip_flag = 0x2000_0000;
pub const dfa_flags_min = dfa_skip_flag;
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

/// The steps of the walk that finds the lengths of a program's matches, or of a part of it, for
/// each instruction of the DFA's program (dfa_length.zig, claim R13 and claim R4's second rule).
/// A level of the walk takes a step for each instruction it passes, so a pattern such as
/// `^.{249}$`, whose levels each hold a few instructions, takes about one step an instruction.
/// A pattern whose levels each hold most of its instructions would take the square of its
/// length, and stops here.
pub const length_steps_per_instruction = 8;

/// The most bytes that the part of a match before its last literal takes, where claim R4 goes to
/// the literal's places because that part takes one count of bytes (dfa_suffix.zig). A reverse
/// scan from a place that starts no match reads that many bytes and the literal at most, so a
/// text of such places costs each of its bytes that many reads. 8 holds `[a-z]shing`, and keeps
/// such a text within a few times a forward scan's cost.
pub const suffix_before_len_max = 8;

/// The literals of a program that claim R14 tries as the literal every match holds: the longest
/// that the reverse program takes from an instruction of one byte (dfa_inner.zig). Each try
/// walks the program a few times, so the limit bounds the walks by the program's length. 8
/// holds the literals of an address pattern such as `[\w.+-]+@[\w.-]+\.[\w.-]+`, which has
/// two, and the three of `[ab]*x(?:a|b)`, whose longest two no match is sure to pass.
pub const inner_candidates_max = 8;

/// What a search with an account pays for its start and for each place of its literal, in
/// bytes of a plain scan (searcher_account.zig, for claim R14 and for claim R4's second and
/// third rules). A place costs a search of the literal begun again, a reverse scan, and at most
/// one forward scan begun. With a space as its literal, `[A-Z][a-z]+ [A-Z][a-z]+` took 38 ns a
/// place on the N2 where the plain scan took 0.93 ns a byte, so a text whose places stand under
/// some 41 bytes apart loses (design §8 part 22q). 64 leaves the claim to texts where it gains
/// by half or more. A search's start costs about as much: some 85 instructions more than the
/// plain search's, with a place or with none.
pub const account_place_bytes = 64;

/// What a trial of a claim with an account may lose before the claim rests, in bytes of a
/// plain scan. A trial that fails then loses about a sixteenth of the text that the first rest
/// covers.
pub const account_credit_bytes = 1 << 12;

/// The most an account holds: its credit, and as much again that its searches gained. An
/// account that holds it has earned back what a trial may lose, so its next rest is the first
/// one's. A higher bound would let a long text of far places pay for as long a text of close
/// ones.
pub const account_balance_max = 2 * account_credit_bytes;

/// The bytes of text the plain search covers while a claim with an account rests, before the
/// claim tries again. A text changes, as claim R1's skip finds (`skip_rest_octets`), and each
/// trial that fails after another doubles the rest, up to `account_rest_doublings_max` times.
/// A trial that fails after the longest rest drops the claim: a searcher with the claim pays a
/// call for each search, which took 8% of a search of 51 bytes (design §8 part 22q), and by
/// then the claim lost six trials over 2 MiB of text.
pub const account_rest_bytes = 1 << 16;
pub const account_rest_doublings_max = 4;

/// The bytes of text a searcher's searches are given, for each instruction of the reverse
/// program, before it judges claim R4's second and third rules, claim R13 and claim R14
/// (searcher_claim.zig). At `init` their walks made a pattern ready at 0.16 to 0.85 of the
/// speed before. They take 13 to 123 ns an instruction in a cloud container, and a plain scan
/// takes about 1 ns a byte. So a searcher makes the walks once, after a scan that cost it
/// about half as much or more (design §8 part 22q). A searcher that is given less never pays
/// for them.
pub const claim_text_per_instruction = 64;

/// The plain rows, one after another, that a run of matches takes before it gives the octets back
/// to the scan's loops (dfa_run.zig): the continuation octets of one UTF-8 sequence. A longer run
/// of plain rows, such as `.*` after a match, then goes to claim R7, which takes two octets for
/// one read of the cache. Where the run took them all, rebar's `14-quadratic` ran at 0.7 of its
/// speed.
pub const dfa_run_plain_rows_max = utf8_len_max - 1;

/// How a `Searcher` divides its cache once each DFA has its least: the forward DFA takes this many
/// parts of `dfa_cache_parts`, and the reverse DFA the rest. The forward DFA reads the whole text
/// and the reverse one a match alone. RE2 divides its memory two parts to one too.
pub const dfa_forward_parts = 2;
pub const dfa_cache_parts = 3;

/// The least slots of the table that finds a written node of a literal trie (literal_trie.zig),
/// and the slots a lookup reads from a hash's home. The table holds a power of two of slots, at
/// least one for each `trie_octets_per_slot` octets of the literals, in the storage past the
/// program. For rebar's dictionary, a table of one slot an octet took 786 kB of the storage; an
/// eighth of it wrote 5% more instructions, 24,088 in place of 22,915, in 0.95 of the time.
pub const trie_node_slots_min = 64;
pub const trie_octets_per_slot = 8;
pub const trie_node_probes = 8;

/// The splits the backtracker passes, at most, to skip alternatives that start with a range that
/// does not take the octet before it pushes the path (backtrack.zig). A class's node of 64
/// continuation ranges is 63 splits, so the walk passes any node's alternatives, and a push
/// costs a bounded walk.
pub const backtrack_skip_splits_max = 64;

/// The words of cache a `Searcher` takes where its caller names no other size: 4 MiB, the memory
/// Rust's regex crate lets the two lazy DFAs of one pattern take, 2 MiB each. The owner ruled it
/// on 2026-11-22 (decision 86 as amended): at 512 kB the DFAs of rebar's date pattern, and of
/// others of its size, did not start, and the matcher ran alone.
pub const cache_words_default = 1 << 19;

/// The octets one step of a skip judges: 16, the width of SSE2's and NEON's registers, which
/// every x86-64 and aarch64 CPU has (claims R1 and R9).
pub const skip_lanes = 16;

/// The octets one step of claim R2's and R5's searches compares in the variant object of x86-64's
/// AVX2: the width of its registers. A caller whose `platform.CpuFeatures` name AVX2 gets it.
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

/// The literals claim R5 searches for at most, one of which every match starts with: 64, as many
/// as Rust's regex crate gives Teddy. The owner ruled it on 2026-11-22 (decision 86 as amended):
/// `(?i)Sherlock` starts with 24 variants of its first four letters, `s` having three case forms.
/// Teddy holds them in `teddy_buckets` buckets of several literals each.
pub const literal_set_max = 64;

/// The slots of a set's table of heads (literal_set.zig): twice `literal_set_max`, so the table
/// is at most half full, and a lookup takes about one probe where it took a compare for each
/// literal of each bucket a place fits. A power of two, so a probe wraps by a mask.
pub const literal_set_slots = literal_set_max + literal_set_max;

/// Teddy's buckets, one bit of an octet each. Literals whose octets at Teddy's two offsets share
/// their low nibbles share a bucket (literal_set_fingerprint.zig), and a place whose octets fit a
/// bucket compares each literal of it.
pub const teddy_buckets = 8;

/// The most literals claim R5 compares with each lane where the target has no Teddy. Each costs
/// two compares and an AND a vector, so eight cost about two instructions an octet, under the
/// forward DFA's dozen. A larger set takes Teddy's tables one offset at a time there.
pub const literal_compare_max = 8;

/// The octets a path of claim R5's literals holds before a split ends it, as `LiteralSet.of`
/// reads them. Each split forks a path in two, so a split past this many octets stops the path,
/// and a loop forks no path without end. Eight octets are four letters of a script of two octets
/// a letter, such as Cyrillic, where `(?i)Шерлок` gives 16 literals. An ASCII word under `(?i)`
/// reaches `literal_set_max` first. The owner ruled 8 on 2026-11-23 (decision 86): at 4,
/// `(?i)Шерлок Холмс` held two letters and ran at about 5,250 MB/s, and at 8 at about 8,000. A
/// run of single octets goes on past it, to `literal_len_max`.
pub const literal_fork_len_max = 8;

/// The fewest literals claim R5 searches for: one literal is claim R2's.
pub const literal_set_count_min = 2;

/// The fewest literals for which claim R5 takes Teddy (literal_teddy.zig), where the target has
/// its lookups. A step of Teddy costs four lookups whatever the count, and a step of the compares
/// two compares for each literal. At 32 lanes on a Xeon, Teddy ran sets of 2 at 0.79 to 0.97 of
/// the compares' speed, 3 at 0.98 to 1.01 and 4 at 1.04 to 1.11 (design §8 step 22, part 22c).
pub const teddy_count_min = 4;

/// The entries of one of Teddy's tables: one for each value of a nibble, the 16 lanes that NEON's
/// TBL and x86-64's PSHUFB look up in.
pub const nibbles = 16;

/// The bits of a nibble, and the mask of an octet's low nibble.
pub const nibble_bits = 4;
pub const nibble_mask = 0x0F;

comptime {
    // Teddy gives each bucket one bit of an octet.
    std.debug.assert(teddy_buckets <= @bitSizeOf(u8));
    std.debug.assert(std.math.isPowerOfTwo(literal_set_slots));
    // A slot holds one more than a literal's place, in an octet.
    std.debug.assert(literal_set_max < std.math.maxInt(u8));
    std.debug.assert(literal_compare_max <= literal_set_max);
}

/// The most classes of octets a program may hold for claim R7's pair rows: a state's pair row
/// takes the square of the classes, 1,024 entries at most. The assertions' contexts split a
/// validation's classes, so that a UUID's pattern holds 16 and an email address's 21.
pub const pair_classes_max = 32;

/// The states claim R7 gives a pair row at most, and the part of a cache their rows take at
/// most: a quarter. The cache's first states get them, which a validation's few states and a
/// search's start states are. The rest of the cache keeps three quarters of its states.
pub const pair_states_max = 64;
pub const pair_memory_parts = 4;

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

/// Claim R9 judges each state that stays from its own visits, as claim R1 judges its skip, and
/// keeps the skip only where the visits passed this many octets each on average. A visit reads
/// its first `skip_scalar_run` octets against the table, as the scan's loop reads them, so only
/// the octets past them gain, and leaving the loop costs a branch the CPU cannot predict. Under 32,
/// rebar's `ruff-noqa/real` took 2.8% more instructions: its `\s*` stays over indents of a few
/// spaces (design §8 part 22n).
pub const stay_octets_per_visit_min = 32;

/// The states a DFA keeps a record of under claim R9: the octets that leave each, as ranges, and
/// its visits. A record is taken by the state's row, so more states that stay take turns in the
/// records, and each record is a few words of the DFA itself. The patterns of rebar's rows that
/// stay over long runs have one or two such states in use at a time.
pub const stay_records = 8;

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
/// leading words, and the packed seeds of a state of the usual size. A record takes the words its
/// seeds need, so this sets how many states the cache can count, not the room each one takes.
pub const dfa_record_words = 12;

/// The words before the packed seeds in a state's record: its flags and the count of the seeds'
/// octets.
pub const dfa_record_head = 2;

/// The hash a cache keys its states by: FNV-1a over a record's flags and its packed seeds.
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
    std.debug.assert(dfa_match_flag | dfa_dead_flag | dfa_skip_flag | dfa_row_mask == dfa_unknown);
    std.debug.assert(dfa_row_mask + 1 == dfa_flags_min);
    std.debug.assert(dfa_record_words > dfa_record_head);
}
