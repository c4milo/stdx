//! The searcher's tests: each of its faster ways gives what the matcher gives (decision 16's rule
//! for a fast path), with a cache of every size, and through a cache that clears and one that
//! gives up.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const compiler = @import("../compile.zig");
const generate = @import("../generate_test.zig");
const matcher_test = @import("../matcher_test.zig");
const matcher_file = @import("../matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;
const searcher_file = @import("searcher.zig");
const searcher_claim = @import("searcher_claim.zig");
const Searcher = searcher_file.Searcher;
const dfa_file = @import("../dfa/dfa.zig");
const dfa_config = @import("../dfa/dfa_config.zig");
const Cache = @import("../dfa/dfa_cache.zig").Cache;
const Dfa = dfa_file.Dfa;
const Program = @import("../program.zig").Program;
const Instruction = @import("../program.zig").Instruction;

const storage_len = matcher_test.storage_len;
const groups_len = matcher_test.groups_len;

/// The most cache a test gives a searcher.
pub const cache_words_max = 32768;
pub const memory_len = Searcher.memory_len(storage_len, groups_len * constants.group_slots, cache_words_max);

/// A program, a searcher for it and a matcher to hold the searcher against.
pub const Fixture = struct {
    storage: [storage_len]Instruction = undefined,
    memory: [memory_len]u64 = undefined,
    reference_memory: [matcher_test.memory_len]u64 = undefined,
    program: Program = undefined,
    searcher: Searcher = undefined,
    reference: Matcher = undefined,
    /// The CPU features and the program's encoding: none and UTF-8, unless a test names others.
    features: @import("platform").CpuFeatures = .{},
    encoding: @import("../program.zig").Encoding = .utf8,
    /// True where `init` judges the claims that wait for text (searcher_claim.zig), so that a
    /// test of a claim meets it from the first search.
    judged: bool = true,
    /// True where each search starts with claim R14's account as `init` left it, so that a
    /// test's short texts, whose places stand close together, do not rest the claim.
    fresh_account: bool = true,

    /// Compiles `pattern` and gives the searcher `cache_words` words of cache.
    pub fn init(fixture: *Fixture, pattern: []const u8, cache_words: usize) !void {
        return fixture.init_claims(pattern, .{}, cache_words);
    }

    /// `init`, with the claims a test names.
    pub fn init_claims(fixture: *Fixture, pattern: []const u8, claims: searcher_file.Claims, cache_words: usize) !void {
        fixture.program = try compiler.compile(pattern, .{ .encoding = fixture.encoding }, &fixture.storage);
        try expect_nodes(&fixture.program);
        if (fixture.program.group_count > groups_len) return error.TestTooManyGroups;
        const len = Searcher.memory_len(fixture.program.forward_len, fixture.program.slot_count(), cache_words);
        fixture.searcher.init(&fixture.program, &.{ .features = fixture.features, .claims = claims }, fixture.memory[0..len]);
        if (fixture.judged) searcher_claim.judge(&fixture.searcher);
        fixture.reference.init(&fixture.program, .{ .captures = .groups }, &fixture.reference_memory);
    }

    /// Requires the searcher's three calls to give what the matcher gives from `from`.
    pub fn expect_agree(fixture: *Fixture, haystack: []const u8, from: usize) !void {
        const expected = fixture.reference.find(haystack, from);
        if (fixture.fresh_account) fixture.searcher.inner_account = .{};
        try testing.expectEqual(expected, fixture.searcher.find(haystack, from));
        if (fixture.fresh_account) fixture.searcher.inner_account = .{};
        const found = fixture.searcher.captures(haystack, from);
        try testing.expectEqual(expected != null, found != null);
        const groups = found orelse return;
        try testing.expectEqual(@as(usize, fixture.program.group_count), groups.len());
        // The reference keeps its match until its next search.
        for (0..groups.len()) |index| try testing.expectEqual(fixture.reference.group(@intCast(index)), groups.get(index));
    }

    pub fn expect_agree_everywhere(fixture: *Fixture, haystack: []const u8) !void {
        for (0..haystack.len + 1) |from| try fixture.expect_agree(haystack, from);
        try fixture.expect_is_match_agrees(haystack);
    }

    pub fn expect_is_match_agrees(fixture: *Fixture, haystack: []const u8) !void {
        fixture.reference.configure(.{ .captures = .none });
        fixture.reference.start(null, 0);
        const matched = fixture.reference.search(haystack, .last).status == .match;
        fixture.reference.configure(.{ .captures = .groups });
        try testing.expectEqual(matched, fixture.searcher.is_match(haystack));
    }
};

/// The words of a DFA's memory in one word of a searcher's memory.
const narrow_per_word = @sizeOf(u64) / @sizeOf(u32);

/// The words of cache, in a searcher's words, that hold `len` words of a DFA's memory.
fn words_for(len: usize) usize {
    return (len + narrow_per_word - 1) / narrow_per_word;
}

/// The least memory both DFAs of a program take: the sum of their least, which a searcher gives
/// each DFA before it divides the rest.
fn least_of(program: *const Program) usize {
    return Dfa.memory_len_min(program, program.forward) + Dfa.memory_len_min(program, program.reverse);
}

/// The caches a test runs under: room for thousands of states, the least both DFAs take, and
/// none, which leaves the matcher alone.
pub const CacheSizes = struct { most: usize, least: usize, none: usize };

pub fn cache_sizes(program: *const Program) CacheSizes {
    return .{
        .most = cache_words_max,
        .least = words_for(least_of(program)),
        .none = 0,
    };
}

const cases = [_]struct { pattern: []const u8, text: []const u8 }{
    .{ .pattern = "abc", .text = "xabcabc" },
    .{ .pattern = "a+", .text = "baaab" },
    .{ .pattern = "a*?", .text = "aaa" },
    .{ .pattern = "(a|ab)(c|bcd)(d*)", .text = "xabcd" },
    .{ .pattern = "foo|foobar", .text = "a foobar" },
    .{ .pattern = "a.*z|a", .text = "xabcd" },
    .{ .pattern = "(?m)^b$", .text = "a\nb\nc" },
    .{ .pattern = "\\bfoo\\b", .text = "afoo foob foo" },
    .{ .pattern = "\\B", .text = "a\xE6\x97\xA5 \xC3\xA9" },
    .{ .pattern = "", .text = "\xC3\xA9a" },
    .{ .pattern = "[^a]+", .text = "a\xFF\xC3\xA9b\xE2\x82\xACa" },
    .{ .pattern = "(a*)*b|c", .text = "aaac aab" },
    .{ .pattern = "(|a)+", .text = "aa" },
    .{ .pattern = "x{2,3}y?", .text = "xxxxyxx" },
    .{ .pattern = "a$", .text = "aa\na" },
    .{ .pattern = "[a-c]{2}\\d|\\w+ ", .text = "ab abc1 a1" },
    .{ .pattern = "(?s).\\z", .text = "ab\n" },
    .{ .pattern = "\\Aa|b\\z", .text = "bab" },
    .{ .pattern = "zzz", .text = "" },
    // Every match starts at the text's start, and no thread alone finds the groups.
    .{ .pattern = "^(a|ab)(c|bcd)(d*)", .text = "abcd abcd" },
    .{ .pattern = "\\A(a*)(a*)b", .text = "aab aab" },
};

test "the searcher gives what the matcher gives, from every offset, under every cache size" {
    var fixture: Fixture = .{};
    for (cases) |case| {
        try fixture.init(case.pattern, 0);
        const sizes = cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least, sizes.none }) |cache_words| {
            try fixture.init(case.pattern, cache_words);
            try fixture.expect_agree_everywhere(case.text);
            // A second pass reads the entries the first one built.
            try fixture.expect_agree_everywhere(case.text);
        }
    }
}

test "a DFA takes memory_len_min words and no fewer" {
    var fixture: Fixture = .{};
    fixture.program = try compiler.compile("(a|b)+c", .{}, &fixture.storage);
    const least = Dfa.memory_len_min(&fixture.program, fixture.program.forward);
    const memory: []u32 = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(fixture.memory[0..]));
    var dfa: Dfa = undefined;
    const config: @import("../dfa/dfa.zig").Config = .{ .entry = fixture.program.forward, .kind = .first, .anchored = false };
    try testing.expect(!dfa.init(&fixture.program, config, memory[0 .. least - 1]));
    try testing.expect(dfa.init(&fixture.program, config, memory[0..least]));
    try testing.expectEqual(@as(u32, constants.dfa_states_min), dfa.cache.states_max);
}

test "a searcher gives each DFA its least, and divides the rest two parts to one" {
    var fixture: Fixture = .{};
    try fixture.init("(a|b)+c", 0);
    try testing.expect(!fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    const forward_least = Dfa.memory_len_min(&fixture.program, fixture.program.forward);
    const reverse_least = Dfa.memory_len_min(&fixture.program, fixture.program.reverse);
    // The two leasts and no more: two parts to one from the cache's start leaves one DFA short.
    try fixture.init("(a|b)+c", words_for(forward_least + reverse_least));
    try testing.expect(fixture.searcher.forward_ready and fixture.searcher.reverse_ready);
    try fixture.expect_agree_everywhere("xabcab");
    // Under the two leasts, the forward DFA takes the whole cache, for `is_match` alone.
    const short_words = words_for(forward_least + reverse_least) - 1;
    try fixture.init("(a|b)+c", short_words);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    try expect_states(&fixture, &fixture.searcher.forward, short_words * narrow_per_word);
    try fixture.expect_agree_everywhere("xabcab");
    try expect_split(&fixture, forward_least, reverse_least);
}

/// Requires `dfa` to hold the states of a DFA of its program and its configuration in `len` words.
fn expect_states(fixture: *Fixture, dfa: *const Dfa, len: usize) !void {
    var memory: [cache_words_max]u32 = undefined;
    var other: Dfa = undefined;
    try testing.expect(other.init(&fixture.program, dfa.config, memory[0..len]));
    try testing.expectEqual(other.cache.states_max, dfa.cache.states_max);
}

/// The states in each third of the spare `expect_split` gives a cache past the two leasts.
const spare_states = 100;

/// Requires a searcher whose cache holds a spare past the two leasts to give the forward DFA two
/// parts of it and the reverse DFA one, each beside its least.
fn expect_split(fixture: *Fixture, forward_least: usize, reverse_least: usize) !void {
    const third = Cache.memory_len(spare_states, @as(u32, fixture.program.class_count) + constants.context_count);
    const cache_words = words_for(forward_least + reverse_least + constants.dfa_cache_parts * third);
    try fixture.init("(a|b)+c", cache_words);
    const forward_len = forward_least + constants.dfa_forward_parts * third;
    try expect_states(fixture, &fixture.searcher.forward, forward_len);
    try expect_states(fixture, &fixture.searcher.reverse, cache_words * narrow_per_word - forward_len);
}

/// Holds the compiler's counts of nodes, kept as it writes and forgets instructions, to a count
/// of each program's instructions one by one.
fn expect_nodes(program: *const Program) !void {
    try testing.expectEqual(dfa_config.nodes_of(program.instructions[0..program.forward_len]), program.forward_nodes);
    try testing.expectEqual(dfa_config.nodes_of(program.instructions[program.forward_len..]), program.reverse_nodes);
}

test "a DFA's lists hold its nodes alone, and find a member by any instruction" {
    var fixture: Fixture = .{};
    fixture.program = try compiler.compile("[ac-eg]+x", .{}, &fixture.storage);
    const program = &fixture.program;
    const block = dfa_config.Block.of(program, program.forward);
    try testing.expect(block.nodes < block.len);
    const stride = @as(u32, program.class_count) + constants.context_count;
    const lists = dfa_file.sparse_lists * @as(usize, block.len) + dfa_file.node_lists * @as(usize, block.nodes) + 1;
    const least = Dfa.memory_len_min(program, program.forward);
    try testing.expectEqual(lists + Cache.memory_len(constants.dfa_states_min, stride), least);
    // The forward DFA runs in memory that holds its least and no more.
    const memory: []u32 = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(fixture.memory[0..]));
    var dfa: Dfa = undefined;
    const config: dfa_file.Config = .{ .entry = program.forward, .kind = .first, .anchored = false };
    try testing.expect(dfa.init(program, config, memory[0..least]));
    try testing.expectEqual(dfa_file.Scan{ .found = 6 }, dfa.scan_forward("xxagcx", 0, false));
}

test "a DFA's lists cover its own program, and not the other one" {
    var fixture: Fixture = .{};
    // The groups' saves are in the forward program alone, so it is the longer of the two.
    fixture.program = try compiler.compile("(a)(b)(c)", .{}, &fixture.storage);
    const program = &fixture.program;
    const reverse_len = program.instructions.len - program.forward_len;
    try testing.expect(program.forward_len > reverse_len);
    const forward_least = Dfa.memory_len_min(program, program.forward);
    const reverse_least = Dfa.memory_len_min(program, program.reverse);
    // The program has no `ranges` node, so each of its instructions is a node.
    try testing.expectEqual((dfa_file.sparse_lists + dfa_file.node_lists) * (program.forward_len - reverse_len), forward_least - reverse_least);
    // The reverse DFA runs in memory that holds its own least and no more.
    const memory: []u32 = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(fixture.memory[0..]));
    var dfa: Dfa = undefined;
    const config: dfa_file.Config = .{ .entry = program.reverse, .kind = .longest, .anchored = true };
    try testing.expect(dfa.init(program, config, memory[0..reverse_least]));
    try testing.expectEqual(dfa_file.Scan{ .found = 1 }, dfa.scan_reverse("xabc", 0, 4));
}

/// The instructions of each program, forward and reverse, that `cache_words_default` must give
/// both DFAs room for: rebar's date pattern under `(?i)` compiled to 14,247 forward instructions,
/// and its DFAs did not start in the 512 kB the default was before the owner's ruling of
/// 2026-11-22 (decision 86 as amended).
const default_room_instructions = 40_000;

test "the default cache gives both DFAs of a large program their least" {
    var fixture: Fixture = .{};
    var program = try compiler.compile("a", .{}, &fixture.storage);
    // The least reads the program's lengths and its counts of nodes alone, so its instructions
    // need not exist. Each instruction is a node, the most a DFA's lists hold.
    const many: [*]const Instruction = @ptrCast(&fixture.storage);
    program.instructions = many[0 .. 2 * default_room_instructions];
    program.forward_len = default_room_instructions;
    program.forward_nodes = default_room_instructions;
    program.reverse_nodes = default_room_instructions;
    const cache_len = constants.cache_words_default * narrow_per_word;
    try testing.expect(Dfa.memory_len_min(&program, 0) + Dfa.memory_len_min(&program, default_room_instructions) <= cache_len);
}

test "a program with no reverse half gives its whole cache to the forward DFA" {
    var fixture: Fixture = .{};
    fixture.program = try compiler.compile("a+b", .{ .reverse = false }, &fixture.storage);
    fixture.searcher.init(&fixture.program, &.{ .features = .{} }, &fixture.memory);
    fixture.reference.init(&fixture.program, .{ .captures = .groups }, &fixture.reference_memory);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    try fixture.expect_agree_everywhere("xaab ab");
    try testing.expect(fixture.searcher.is_match("xaab"));
    try testing.expect(!fixture.searcher.is_match("xaa"));
}

/// A text of `a` and `b` that a seed draws.
fn letters(generator: *codec.testing.split.Generator, buffer: []u8) void {
    for (buffer) |*octet| octet.* = if (generator.next() & 1 == 0) 'a' else 'b';
}

/// The claims of a searcher whose forward DFA reads every octet of a pattern that ends with a
/// literal: claim R4 would read back from the literal and build few states.
pub const no_suffix: searcher_file.Claims = .{ .suffix = false };

test "a pattern whose states outgrow the cache clears it, gives up, and still answers as the matcher" {
    // The DFA of this pattern remembers the last eight letters: 256 states and more.
    const pattern = "(a|b)*a(a|b){8}c";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init_claims(pattern, no_suffix, cache_sizes(&fixture.program).least);
    var generator = codec.testing.split.Generator.init(7);
    var text: [600]u8 = undefined;
    letters(&generator, &text);
    text[text.len - 1] = 'c';
    try fixture.expect_agree(&text, 0);
    try testing.expect(fixture.searcher.forward.cache.clears > 1);
    try testing.expect(fixture.searcher.give_ups > 0);
    // With room for its states, the same search never gives up.
    try fixture.init_claims(pattern, no_suffix, cache_words_max);
    try fixture.expect_agree(&text, 0);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.give_ups);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.clears);
}

test "a searcher stops trying its DFA after dfa_give_ups_max searches gave up" {
    const pattern = "(a|b)*a(a|b){8}c";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init_claims(pattern, no_suffix, cache_sizes(&fixture.program).least);
    var generator = codec.testing.split.Generator.init(11);
    var text: [600]u8 = undefined;
    for (0..2 * constants.dfa_give_ups_max) |_| {
        letters(&generator, &text);
        try fixture.expect_agree(&text, 0);
    }
    // `expect_agree` runs two searches that try the DFA, and each try past the limit is skipped.
    try testing.expectEqual(@as(u32, constants.dfa_give_ups_max), fixture.searcher.give_ups);
    const clears = fixture.searcher.forward.cache.clears;
    letters(&generator, &text);
    try fixture.expect_agree(&text, 0);
    try testing.expectEqual(clears, fixture.searcher.forward.cache.clears);
}

/// The words of the pattern below, the octets of each, and the octets of `x` after each start of
/// a word in the text: enough that a state serves more than `dfa_octets_per_state_min` octets.
const word_count = 40;
const word_len = 3;
const gap_len = 60;
const passes = 3;

/// The letters of one case.
const letters_len = 26;

/// The first letter of word `index`: each word has its own.
fn first_letter(index: usize) u8 {
    return if (index < letters_len) @intCast('a' + index) else @intCast('A' + index - letters_len);
}

test "a cache that clears on a text with few states for its length goes on without giving up" {
    // Forty words with forty first letters: two states a word, more than the least cache holds.
    // The words are in one group, so the parser writes one alternative a word: a trie of them
    // would build fewer states (literal_trie.zig).
    const opener = "(?:";
    var pattern: [opener.len + word_count * (word_len + 1)]u8 = undefined;
    @memcpy(pattern[0..opener.len], opener);
    for (0..word_count) |index| {
        const word = [_]u8{ first_letter(index), '=', @intCast('0' + index % 10), '|' };
        @memcpy(pattern[opener.len + index * word.len ..][0..word.len], &word);
    }
    // The last word's `|` closes the group.
    pattern[pattern.len - 1] = ')';
    // The text starts each word and leaves it, pass after pass, and ends with one whole word.
    var text: [passes * word_count * (word_len - 1 + gap_len) + word_len]u8 = @splat('x');
    for (0..passes * word_count) |index| {
        const start = index * (word_len - 1 + gap_len);
        text[start] = first_letter(index % word_count);
        text[start + 1] = '=';
    }
    @memcpy(text[text.len - word_len ..], "b=1");
    var fixture: Fixture = .{};
    // Claim R5 would take the forty words as an exact set, and run no DFA.
    try fixture.init_claims(&pattern, .{ .literal_set = false }, 0);
    try fixture.init_claims(&pattern, .{ .literal_set = false }, cache_sizes(&fixture.program).least);
    try fixture.expect_agree(&text, 0);
    try testing.expectEqual(@as(?Span, .{ .start = text.len - word_len, .end = text.len }), fixture.searcher.find(&text, 0));
    try testing.expect(fixture.searcher.forward.cache.clears > 0);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.give_ups);
}

/// The seeds of the generated comparison, and the texts each pattern is searched in.
const generated_patterns = 600;
const texts_per_pattern = 6;

test "the searcher gives what the matcher gives, for generated patterns and texts" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5EA2C4);
    var pattern_buffer: [generate.pattern_len_max]u8 = undefined;
    var text_buffer: [generate.text_len_max]u8 = undefined;
    for (0..generated_patterns) |round| {
        const pattern = generate.pattern(&generator, &pattern_buffer);
        try fixture.init(pattern, 0);
        const sizes = cache_sizes(&fixture.program);
        try fixture.init(pattern, if (round & 1 == 0) sizes.most else sizes.least);
        for (0..texts_per_pattern) |_| {
            try fixture.expect_agree_everywhere(generate.text(&generator, &text_buffer));
        }
    }
}

test "a state built while the cache clears is not written into the cleared table" {
    // The letters build a new state each, until one fills the cache. The `x` leads back to the
    // state the scan started in, whose row is the table's first. The `a` then builds a state
    // while the cache clears, and that state takes the first row. An entry written for the old
    // row would lead this state to itself on `a`, and `aab` would go unseen.
    const pattern = "aab|(b|c)*b(b|c){8}!";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    const least = cache_sizes(&fixture.program).least;
    var generator = codec.testing.split.Generator.init(3);
    var text: [100]u8 = undefined;
    for (&text) |*octet| octet.* = if (generator.next() & 1 == 0) 'b' else 'c';
    var cleared_at_a = false;
    for (0..text.len - 4) |prefix_len| {
        try fixture.init(pattern, least);
        @memcpy(text[prefix_len..][0..4], "xaab");
        const haystack = text[0 .. prefix_len + 4];
        _ = fixture.searcher.find(haystack[0 .. prefix_len + 1], 0);
        const clears = fixture.searcher.forward.cache.clears;
        try fixture.expect_agree(haystack, 0);
        // The search of the whole text reads the letters and the `x` from the table, so a clear
        // it adds came while it built the state after `a`.
        if (clears == 0 and fixture.searcher.forward.cache.clears > 0) cleared_at_a = true;
        text[prefix_len] = if (generator.next() & 1 == 0) 'b' else 'c';
    }
    try testing.expect(cleared_at_a);
}

/// The letters of the short texts: two a pattern below names, one it does not, a line feed for
/// the anchors, and a scalar value of two octets.
const short_letters = [_][]const u8{ "a", "b", "c", "\n", "\xC3\xA9" };

/// The longest short text, in letters.
const short_len_max = 5;

/// The patterns held over every short text: each form of the syntax whose states a text's
/// letters can reach in a few steps.
const short_patterns = [_][]const u8{
    "a",          "ab|a",         "(a|b)*c",  "a*?b",     "(a*)*b",
    "^a|b$",      "(?m)^b$",      "\\ba+\\b", "\\B",      "a{2,3}",
    "(a|ab)(b|)", "[^a]\xC3\xA9", ".a",       "(?s).\\z", "",
};

/// Writes the text whose letters are the digits of `number` in the base of the letters, the
/// last letter first, and gives its length.
fn short_text(number: usize, len: usize, buffer: []u8) usize {
    var rest = number;
    var written: usize = 0;
    for (0..len) |_| {
        const letter = short_letters[rest % short_letters.len];
        @memcpy(buffer[written..][0..letter.len], letter);
        written += letter.len;
        rest /= short_letters.len;
    }
    return written;
}

test "the searcher gives what the matcher gives on every short text over five letters" {
    var fixture: Fixture = .{};
    var buffer: [short_len_max * 2]u8 = undefined;
    for (short_patterns) |pattern| {
        try fixture.init(pattern, 0);
        try fixture.init(pattern, cache_sizes(&fixture.program).least);
        var count: usize = 1;
        for (0..short_len_max + 1) |len| {
            for (0..count) |number| {
                const text = buffer[0..short_text(number, len, &buffer)];
                try fixture.expect_agree(text, 0);
            }
            count *= short_letters.len;
        }
    }
}
