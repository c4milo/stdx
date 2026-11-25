//! `matcher_replay dump <seed> <count> <file>`: the programs that `compile` gives the patterns
//! a seed draws, written for the Lean model to answer (decision 86, design §8 part 22h).
//!
//! Each case is a pattern, compiled as UTF-8 or as bytes in turn, its text, and a `search` line
//! for each search. `lake exe vectors --answers` writes the file again with each search
//! answered, and `matcher_replay` replays that file.
//!
//! The patterns come from two places in turn. One is tools/differential/regex_generate.zig,
//! which draws each form of the syntax. The other is matcher_replay_shapes.zig, which draws the
//! shapes the searcher's claims read.
//!
//! A text holds at most `text_len_max` bytes, or for one case in `long_case_share` at most
//! `long_text_len_max`, with more searches.
//!
//! After a program's instructions, a `slots` line names the slots of its capture groups, two
//! for each group. The Lean side then writes the groups of each search's match
//! (matcher_replay_groups.zig).
//!
//! After that line, a `claim` line holds the literal that a searcher took for the
//! program, under the word of the rule it took it by (matcher_replay_claim.zig): `suffix` for
//! claim R4's first rule, `suffix-wide` for its second rule or its third, and `inner` for claim
//! R14. The Lean side decides each rule for the literal from the program, and a rule holds for
//! every text or for none.
//!
//! A `prefix` line holds the literal that the searcher's forward DFA goes to, by claim R2 or
//! claim R3 (matcher_replay_prefix.zig). The Lean side decides that every match starts with it.
const std = @import("std");
const regex = @import("regex");
const regex_generate = @import("../differential/regex_generate.zig");
const matcher_replay_claim = @import("matcher_replay_claim.zig");
const matcher_replay_prefix = @import("matcher_replay_prefix.zig");
const Prefix = matcher_replay_prefix.Prefix;
const matcher_replay_shapes = @import("matcher_replay_shapes.zig");
const pick = matcher_replay_shapes.pick;
const fit = matcher_replay_shapes.fit;
const Claim = matcher_replay_claim.Claim;
const Generator = @import("codec").testing.split.Generator;
const Instruction = regex.Instruction;

/// The instructions a dumped program holds at most, its reverse half included, and the capture
/// slots. A larger program is left out: the Lean model walks a program by lists.
pub const instructions_max = 256;
pub const slots_max = 32;

/// The bytes of a dumped text. A drawn text is cut there, also inside a character: a text that
/// is not UTF-8 is a text the matcher must answer for.
pub const text_len_max = 12;

/// The bytes of a long text at most. One case in `long_case_share` takes a long text: runs of
/// one filler with the case's own text after each, so that a search reads far before a match
/// and goes on past one. The Lean side holds a long text's answers by passes over it, and
/// decides the hypotheses of its theorems for the short texts alone.
pub const long_text_len_max = 1024;
const long_case_share = 8;
const long_runs_min = 2;
const long_runs_max = 4;
const filler_len_min = 16;
const filler_len_max = 400;

/// The searches of a long text: one from its start, and the others from offsets the seed
/// draws. A searcher keeps its caches from one search to the next, so more searches fill a
/// small cache more often.
const long_searches = 6;

/// What a run of a long text repeats.
const fillers = [_][]const u8{ "a", "b", "x", " ", "c", "\n", "\xC3\xA9", "ab" };

/// The bytes a line of a dump holds at most, a pattern's two digits a byte among them.
pub const line_len_max = 2 * regex_generate.pattern_len_max + 16;

/// The cases drawn for each case kept, at most: a pattern that `compile` refuses or whose
/// program is too large is left out.
const draws_per_case = 8;

/// An instruction as a line of a vector file, as spec/lean/Vectors.lean writes one.
pub fn line_of(buffer: []u8, instruction: Instruction) ![]const u8 {
    return switch (instruction.kind) {
        .range => std.fmt.bufPrint(buffer, "range {d} {d} {d}", .{ instruction.lo, instruction.hi, instruction.out }),
        .ranges => std.fmt.bufPrint(buffer, "ranges {d}", .{instruction.arg}),
        .split => std.fmt.bufPrint(buffer, "split {d} {d}", .{ instruction.out, instruction.arg }),
        .save => std.fmt.bufPrint(buffer, "save {d} {d}", .{ instruction.arg, instruction.out }),
        .look => std.fmt.bufPrint(buffer, "look {s} {d}", .{ @tagName(instruction.look), instruction.out }),
        .jump => std.fmt.bufPrint(buffer, "jump {d}", .{instruction.out}),
        .match => std.fmt.bufPrint(buffer, "match", .{}),
        .fail => std.fmt.bufPrint(buffer, "fail", .{}),
    };
}

/// The entry of a program with no reverse half (`program.no_entry`).
pub const no_entry = std.math.maxInt(u32);

/// The lines of a dump as they grow.
pub const Lines = struct {
    arena: std.mem.Allocator,
    bytes: std.ArrayList(u8) = .empty,

    fn add(lines: *Lines, comptime format: []const u8, arguments: anytype) !void {
        var buffer: [line_len_max]u8 = undefined;
        try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, format ++ "\n", arguments));
    }

    /// A pattern's bytes, two hexadecimal digits each, or `-` for the empty pattern.
    fn add_pattern(lines: *Lines, pattern: []const u8) !void {
        try lines.bytes.appendSlice(lines.arena, "pattern ");
        if (pattern.len == 0) try lines.bytes.append(lines.arena, '-');
        for (pattern) |byte| {
            var digits: [2]u8 = undefined;
            try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&digits, "{x:0>2}", .{byte}));
        }
        try lines.bytes.append(lines.arena, '\n');
    }

    fn add_program(lines: *Lines, program: *const regex.Program) !void {
        const head = "program {s} {d} {d}";
        const names = .{ @tagName(program.encoding), program.instructions.len, program.forward };
        if (program.reverse == no_entry) try lines.add(head ++ " none", names) else try lines.add(head ++ " {d}", names ++ .{program.reverse});
        for (program.instructions) |instruction| {
            var buffer: [line_len_max]u8 = undefined;
            try lines.add("{s}", .{try line_of(&buffer, instruction)});
        }
    }

    fn add_text(lines: *Lines, text: []const u8) !void {
        var buffer: [line_len_max]u8 = undefined;
        try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, "text {d}", .{text.len}));
        for (text) |byte| try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, " {d}", .{byte}));
        try lines.bytes.append(lines.arena, '\n');
    }

    /// The literal a searcher took, under the word of its rule: for claim R14 the instruction
    /// where the reverse program stands after the literal, then the literal's length and its
    /// bytes, in the text's order. Where a place folds, the word `folds` and the places' bits.
    fn add_claim(lines: *Lines, claim: Claim) !void {
        var buffer: [line_len_max]u8 = undefined;
        try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, "claim {s}", .{claim.rule.word()}));
        if (claim.rule == .inner) try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, " {d}", .{claim.before}));
        try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, " {d}", .{claim.literal.len}));
        for (claim.literal) |byte| try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, " {d}", .{byte}));
        if (claim.folds != 0) try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, " folds {d}", .{claim.folds}));
        try lines.bytes.append(lines.arena, '\n');
    }

    /// The literal that a searcher's forward DFA goes to: its length and its bytes, and where a
    /// place folds, the word `folds` and the places' bits.
    fn add_prefix(lines: *Lines, prefix: Prefix) !void {
        var buffer: [line_len_max]u8 = undefined;
        try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, "prefix {d}", .{prefix.literal.len}));
        for (prefix.literal) |byte| try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, " {d}", .{byte}));
        if (prefix.folds != 0) try lines.bytes.appendSlice(lines.arena, try std.fmt.bufPrint(&buffer, " folds {d}", .{prefix.folds}));
        try lines.bytes.append(lines.arena, '\n');
    }

    /// One case: a pattern, the program `compile` gave it, the claim a new searcher took for
    /// it, the literal its forward DFA goes to, a text, and a search from each offset of `lows`.
    pub fn add_case(lines: *Lines, pattern: []const u8, program: *const regex.Program, claim: ?Claim, prefix: ?Prefix, text: []const u8, lows: []const usize) !void {
        try lines.add_pattern(pattern);
        try lines.add_program(program);
        try lines.add("slots {d}", .{program.slot_count()});
        if (claim) |taken| try lines.add_claim(taken);
        if (prefix) |taken| try lines.add_prefix(taken);
        try lines.add_text(text);
        for (lows) |low| try lines.add("search {d}", .{low});
    }
};

/// What a dump keeps from one case to the next: the storage `compile` writes, and the searcher
/// that says what claim a searcher takes for a program.
pub const Scratch = struct {
    storage: []Instruction,
    taker: matcher_replay_claim.Taker,

    pub fn init(arena: std.mem.Allocator) !Scratch {
        return .{
            .storage = try arena.alloc(Instruction, instructions_max),
            .taker = try matcher_replay_claim.Taker.init(arena, instructions_max, slots_max),
        };
    }
};

/// A long text for a case whose own text is `short`. A run repeats one filler, or holds mixed
/// pieces, which make a DFA build many states.
fn long_text(generator: *Generator, short: []const u8, buffer: *[long_text_len_max]u8) []const u8 {
    var text: std.ArrayList(u8) = .initBuffer(buffer);
    for (0..generator.between(long_runs_min, long_runs_max)) |_| {
        const mixed = generator.below(2) == 0;
        const filler = pick(generator, &fillers);
        for (0..generator.between(filler_len_min, filler_len_max) / filler.len) |_| {
            fit(&text, if (mixed) pick(generator, &matcher_replay_shapes.text_pieces) else filler);
        }
        fit(&text, short);
    }
    return text.items;
}

/// Writes a drawn case with one or two searches: one from the text's start, and one from an
/// offset the seed draws. False where the case is left out: its pattern did not fit, `compile`
/// refused it, or its program is too large for the storage or the slots.
fn add_drawn(lines: *Lines, generator: *Generator, case: *const regex_generate.Case, encoding: regex.Encoding, scratch: *Scratch) !bool {
    if (case.overflowed()) return false;
    const program = regex.compile(case.pattern.slice(), .{ .encoding = encoding }, scratch.storage) catch return false;
    if (program.slot_count() > slots_max) return false;
    const claim = scratch.taker.claim(&program);
    // The taker's searcher is the one that `claim` made ready for the program.
    const prefix = matcher_replay_prefix.held(&scratch.taker.searcher);
    var long: [long_text_len_max]u8 = undefined;
    const short = case.text[0..@min(case.text_len, text_len_max)];
    if (generator.below(long_case_share) != 0) {
        const lows = [_]usize{ 0, generator.below(short.len + 1) };
        try lines.add_case(case.pattern.slice(), &program, claim, prefix, short, if (lows[1] == 0) lows[0..1] else &lows);
        return true;
    }
    const text = long_text(generator, short, &long);
    var lows: [long_searches]usize = @splat(0);
    for (lows[1..]) |*low| low.* = generator.below(text.len + 1);
    try lines.add_case(case.pattern.slice(), &program, claim, prefix, text, &lows);
    return true;
}

/// The dump of `count` cases that `seed` draws, or of fewer where too many are left out.
pub fn dump(arena: std.mem.Allocator, seed: u64, count: usize) ![]const u8 {
    var lines: Lines = .{ .arena = arena };
    try lines.add("# seed {d}: the programs `compile` gives drawn patterns, for `vectors --answers`.", .{seed});
    var scratch = try Scratch.init(arena);
    var generator = Generator.init(seed);
    var case: regex_generate.Case = .{};
    var kept: usize = 0;
    for (0..count * draws_per_case) |draw| {
        if (kept == count) break;
        // Two draws of each source in turn, so that each source is read as UTF-8 and as bytes.
        if (draw / 2 % 2 == 0) regex_generate.next(&generator, &case) else matcher_replay_shapes.draw(&generator, &case, text_len_max);
        const encoding: regex.Encoding = if (draw % 2 == 0) .utf8 else .bytes;
        if (try add_drawn(&lines, &generator, &case, encoding, &scratch)) kept += 1;
    }
    return lines.bytes.items;
}

const testing = std.testing;
const text_len_radix = 10;

test "a dump holds a pattern, its program, a text and its searches for each case" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const cases = 6;
    const text = try dump(arena_state.allocator(), 1, cases);
    var patterns: usize = 0;
    var programs: usize = 0;
    var texts: usize = 0;
    var searches: usize = 0;
    var lines = std.mem.tokenizeScalar(u8, text, '\n');
    while (lines.next()) |line| {
        patterns += @intFromBool(std.mem.startsWith(u8, line, "pattern "));
        programs += @intFromBool(std.mem.startsWith(u8, line, "program "));
        texts += @intFromBool(std.mem.startsWith(u8, line, "text "));
        searches += @intFromBool(std.mem.startsWith(u8, line, "search "));
    }
    try testing.expectEqual(@as(usize, cases), patterns);
    try testing.expectEqual(@as(usize, cases), programs);
    try testing.expectEqual(@as(usize, cases), texts);
    // A case holds one search, and a second one where the seed draws an offset past 0. None
    // of these six takes a long text.
    try testing.expect(searches > cases and searches <= 2 * cases);
    // One seed gives one dump.
    try testing.expectEqualStrings(text, try dump(arena_state.allocator(), 1, cases));
}

/// The searches a text of `len` bytes may hold: `long_searches` for a long text, and one or two
/// for another.
fn expect_searches(len: usize, searches: usize) !void {
    if (len > text_len_max) return testing.expectEqual(@as(usize, long_searches), searches);
    try testing.expect(searches == 1 or searches == 2);
}

test "some cases of a dump take a long text, each with its searches" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const cases = 64;
    const text = try dump(arena_state.allocator(), 1, cases);
    var longs: usize = 0;
    var texts: usize = 0;
    var len: usize = 0;
    var searches: usize = 0;
    var lines = std.mem.tokenizeScalar(u8, text, '\n');
    while (lines.next()) |line| {
        searches += @intFromBool(std.mem.startsWith(u8, line, "search "));
        if (!std.mem.startsWith(u8, line, "text ")) continue;
        // The text before this one is whole: its searches are counted.
        if (texts > 0) try expect_searches(len, searches);
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        _ = tokens.next();
        len = try std.fmt.parseInt(usize, tokens.next().?, text_len_radix);
        try testing.expect(len <= long_text_len_max);
        longs += @intFromBool(len > text_len_max);
        texts += 1;
        searches = 0;
    }
    try expect_searches(len, searches);
    try testing.expectEqual(@as(usize, cases), texts);
    try testing.expect(longs > 0 and longs < cases / 2);
}

test "a dump names the literal that a searcher took, after the program and before its text" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const cases = 64;
    const text = try dump(arena_state.allocator(), 1, cases);
    var claims: usize = 0;
    var inner: usize = 0;
    var folded: usize = 0;
    var prefixes: usize = 0;
    var lines = std.mem.tokenizeScalar(u8, text, '\n');
    var before: []const u8 = "";
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, "prefix ")) {
            prefixes += 1;
            try testing.expect(!std.mem.startsWith(u8, before, "text ") and !std.mem.startsWith(u8, before, "search "));
        }
        if (std.mem.startsWith(u8, line, "claim ")) {
            claims += 1;
            inner += @intFromBool(std.mem.startsWith(u8, line, "claim inner "));
            try testing.expect(!std.mem.startsWith(u8, before, "text ") and !std.mem.startsWith(u8, before, "search "));
            folded += @intFromBool(try expect_claim_line(line));
        }
        before = line;
    }
    try testing.expect(claims > 0 and claims < cases);
    try testing.expect(inner > 0 and inner < claims);
    try testing.expect(folded > 0 and folded < claims);
    try testing.expect(prefixes > 0 and prefixes < cases);
}

/// Requires a claim line's parts: its rule, for claim R14 an instruction, the literal's length
/// and that many bytes, and for a literal with a place that folds the word `folds` and the
/// places' bits, which name no place past the literal. True for a literal with such a place.
fn expect_claim_line(line: []const u8) !bool {
    var tokens = std.mem.tokenizeScalar(u8, line, ' ');
    _ = tokens.next();
    const rule = matcher_replay_claim.Rule.of_word(tokens.next().?).?;
    if (rule == .inner) _ = try std.fmt.parseInt(u32, tokens.next().?, text_len_radix);
    const len = try std.fmt.parseInt(usize, tokens.next().?, text_len_radix);
    try testing.expect(len > 0);
    for (0..len) |_| _ = try std.fmt.parseInt(u8, tokens.next().?, text_len_radix);
    const word = tokens.next() orelse return false;
    try testing.expectEqualStrings("folds", word);
    const folds = try std.fmt.parseInt(u64, tokens.next().?, text_len_radix);
    try testing.expect(folds != 0 and folds >> @intCast(len) == 0);
    try testing.expect(tokens.next() == null);
    return true;
}

test "line_of writes each kind as the Lean model reads it" {
    var buffer: [line_len_max]u8 = undefined;
    try testing.expectEqualStrings("range 97 98 5", try line_of(&buffer, .{ .kind = .range, .lo = 'a', .hi = 'b', .out = 5 }));
    try testing.expectEqualStrings("ranges 2", try line_of(&buffer, .{ .kind = .ranges, .arg = 2 }));
    try testing.expectEqualStrings("split 3 4", try line_of(&buffer, .{ .kind = .split, .out = 3, .arg = 4 }));
    try testing.expectEqualStrings("save 1 6", try line_of(&buffer, .{ .kind = .save, .arg = 1, .out = 6 }));
    try testing.expectEqualStrings("look word_boundary 2", try line_of(&buffer, .{ .kind = .look, .look = .word_boundary, .out = 2 }));
    try testing.expectEqualStrings("jump 7", try line_of(&buffer, .{ .kind = .jump, .out = 7 }));
    try testing.expectEqualStrings("match", try line_of(&buffer, .{ .kind = .match }));
    try testing.expectEqualStrings("fail", try line_of(&buffer, .{ .kind = .fail }));
}
