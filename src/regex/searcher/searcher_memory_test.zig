//! The searcher's division of its cache between its two DFAs (decision 86): one set of lists
//! that both take, each DFA's least cache, and the rest in two halves, or the whole cache to
//! the forward DFA where that does not fit.
const std = @import("std");
const testing = std.testing;
const constants = @import("../constants.zig");
const compiler = @import("../compile.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const cache_words_max = searcher_test.cache_words_max;
const cache_sizes = searcher_test.cache_sizes;
const narrow_per_word = searcher_test.narrow_per_word;
const words_for = searcher_test.words_for;
const least_of = searcher_test.least_of;
const lists_of = searcher_test.lists_of;
const dfa_file = @import("../dfa/dfa.zig");
const dfa_config = @import("../dfa/dfa_config.zig");
const Cache = @import("../dfa/dfa_cache.zig").Cache;
const Dfa = dfa_file.Dfa;
const Instruction = @import("../program.zig").Instruction;

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

test "a DFA that shares its lists takes as many as its nodes need, and a least cache beside them" {
    var fixture: Fixture = .{};
    fixture.program = try compiler.compile("(a|b)+c", .{}, &fixture.storage);
    const program = &fixture.program;
    const lists_len = dfa_file.lists_len(dfa_file.nodes_of(program, program.forward));
    const least = dfa_file.cache_len_min(program);
    var lists: [cache_words_max]u32 = undefined;
    var memory: [cache_words_max]u32 = undefined;
    var dfa: Dfa = undefined;
    const config: dfa_file.Config = .{ .entry = program.forward, .kind = .first, .anchored = false };
    try testing.expect(!dfa.init_sharing(program, config, lists[0 .. lists_len - 1], memory[0..least]));
    try testing.expect(!dfa.init_sharing(program, config, lists[0..lists_len], memory[0 .. least - 1]));
    try testing.expect(dfa.init_sharing(program, config, lists[0..lists_len], memory[0..least]));
    try testing.expectEqual(dfa_file.Scan{ .found = 3 }, dfa.scan_forward("abc", 0, false));
}

test "a searcher gives each DFA its least, and divides the rest in two halves" {
    var fixture: Fixture = .{};
    try fixture.init("(a|b)+c", 0);
    try testing.expect(!fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    const least = least_of(&fixture.program);
    // The lists and the two leasts and no more: both DFAs start.
    try fixture.init("(a|b)+c", words_for(least));
    try testing.expect(fixture.searcher.forward_ready and fixture.searcher.reverse_ready);
    try fixture.expect_agree_everywhere("xabcab");
    // Under them, the forward DFA takes the whole cache with lists of its own, for `is_match`.
    const short_words = words_for(least) - 1;
    try fixture.init("(a|b)+c", short_words);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    var memory: [cache_words_max]u32 = undefined;
    var other: Dfa = undefined;
    try testing.expect(other.init(&fixture.program, fixture.searcher.forward.config, memory[0 .. short_words * narrow_per_word]));
    try testing.expectEqual(other.cache.states_max, fixture.searcher.forward.cache.states_max);
    try fixture.expect_agree_everywhere("xabcab");
    try expect_split(&fixture);
}

/// Requires `dfa` to hold the states of a DFA of its program and its configuration whose cache
/// takes `len` words beside its lists.
fn expect_states(fixture: *Fixture, dfa: *const Dfa, len: usize) !void {
    var lists: [cache_words_max]u32 = undefined;
    var memory: [cache_words_max]u32 = undefined;
    var other: Dfa = undefined;
    try testing.expect(other.init_sharing(&fixture.program, dfa.config, lists[0..lists_of(&fixture.program)], memory[0..len]));
    try testing.expectEqual(other.cache.states_max, dfa.cache.states_max);
}

/// The states in each part of the spare `expect_split` gives a cache past the two leasts.
const spare_states = 100;

/// Requires a searcher whose cache holds a spare past the lists and the two leasts to give each
/// DFA half of it, beside its least (the owner's ruling of 2026-11-26).
fn expect_split(fixture: *Fixture) !void {
    const part = Cache.memory_len(spare_states, @as(u32, fixture.program.class_count) + constants.context_count);
    const cache_words = words_for(least_of(&fixture.program) + constants.dfa_cache_parts * part);
    try fixture.init("(a|b)+c", cache_words);
    const forward_len = dfa_file.cache_len_min(&fixture.program) + constants.dfa_forward_parts * part;
    try expect_states(fixture, &fixture.searcher.forward, forward_len);
    const reverse_len = cache_words * narrow_per_word - lists_of(&fixture.program) - forward_len;
    try expect_states(fixture, &fixture.searcher.reverse, reverse_len);
    // The two halves: the reverse DFA takes no more than the word that rounds the cache up.
    try testing.expect(reverse_len >= forward_len and reverse_len - forward_len < narrow_per_word);
}

/// Requires the two DFAs of `pattern`'s searcher to take one set of lists, whichever half of the
/// program holds more nodes, and to agree with the matcher on `text`.
fn expect_shared(fixture: *Fixture, pattern: []const u8, text: []const u8) !void {
    try fixture.init(pattern, cache_sizes(&fixture.program).most);
    try fixture.init(pattern, words_for(least_of(&fixture.program)));
    const forward = &fixture.searcher.forward;
    const reverse = &fixture.searcher.reverse;
    try testing.expect(fixture.searcher.forward_ready and fixture.searcher.reverse_ready);
    try testing.expect(forward.threads.ptr == reverse.threads.ptr and forward.stack.ptr == reverse.stack.ptr);
    try testing.expect(forward.visited.sparse.ptr == reverse.visited.sparse.ptr);
    try testing.expect(forward.next.dense.ptr == reverse.next.dense.ptr);
    try fixture.expect_agree_everywhere(text);
}

test "the two DFAs take one set of lists, as long as the larger half needs" {
    var fixture: Fixture = .{};
    // The groups' saves are in the forward program alone, so its half holds more nodes.
    try fixture.init("(a)(b)(c)", 0);
    try testing.expect(fixture.program.forward_nodes > fixture.program.reverse_nodes);
    try expect_shared(&fixture, "(a)(b)(c)", "xabcabc");
    // UTF-8 read back splits a class by its last octet, so the reverse half holds more nodes.
    try fixture.init("[α-ωа-я]+x", 0);
    try testing.expect(fixture.program.reverse_nodes > fixture.program.forward_nodes);
    try expect_shared(&fixture, "[α-ωа-я]+x", "аβx яяx ωx");
}

test "a DFA's lists hold a word for each node alone, and find a member by its node's number" {
    var fixture: Fixture = .{};
    fixture.program = try compiler.compile("[ac-eg]+x", .{}, &fixture.storage);
    const program = &fixture.program;
    const block = dfa_config.Block.of(program, program.forward);
    try testing.expect(block.nodes < block.len);
    const stride = @as(u32, program.class_count) + constants.context_count;
    const lists = (dfa_file.sparse_lists + dfa_file.node_lists) * @as(usize, block.nodes) + 1;
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
    try testing.expect(least_of(&program) <= cache_len);
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
