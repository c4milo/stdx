//! `matcher_replay dump <seed> <count> <file>`: the programs that `compile` gives the patterns
//! a seed draws, written for the Lean model to answer (decision 86, design §8 part 22h).
//!
//! Each case is a pattern, compiled as UTF-8 or as bytes in turn, its text, and a `search` line
//! for each search. `lake exe vectors --answers` writes the file again with each search
//! answered, and `matcher_replay` replays that file.
//!
//! The patterns come from two places in turn. One is tools/differential/regex_generate.zig,
//! which draws each form of the syntax. The other is `claim_case` below, which draws the shapes
//! the searcher's claims read: a literal that starts every match, one that ends every match,
//! one inside, and an alternation of literals, each beside a part that may take the literal's
//! bytes. Half of their texts hold the literal twice.
const std = @import("std");
const regex = @import("regex");
const regex_generate = @import("differential/regex_generate.zig");
const Generator = @import("codec").testing.split.Generator;
const Instruction = regex.Instruction;

/// The instructions a dumped program holds at most, its reverse half included, and the capture
/// slots. A larger program is left out: the Lean model walks a program by lists.
pub const instructions_max = 256;
pub const slots_max = 32;

/// The bytes of a dumped text. A drawn text is cut there, also inside a character: a text that
/// is not UTF-8 is a text the matcher must answer for.
pub const text_len_max = 12;

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

/// The parts of a pattern shaped for the searcher's claims. A run takes some bytes, and most
/// runs take a byte of a word, so a search from the word's place must read past it.
const runs = [_][]const u8{
    "[ab]*", "[a-c]+", "(?:a|ba)*", ".*", "\\w+", "[^b]*", "a?", "(?:ab)*?", "", "[b ]+", "\\w*?", "(?:[ab]|c[ab]ab)", "c", "(?i:b)*",
};
const words = [_][]const u8{ "ab", "ba", "abc", "aab", "b a", "cab", "aa", "abab" };
const tails = [_][]const u8{ "", "", "", "$", "\\b", "c*", "[ab]?" };

/// The pieces of a text for such a pattern: the words' bytes, so that a word stands in a text
/// more than once.
const claim_text_pieces = [_][]const u8{ "a", "b", "ab", "ba", "c", " ", "abc", "a", "b" };

/// The pieces such a text holds at most before its two words, and after them.
const claim_text_pieces_max = 3;

/// The letters that the nested shape's first branch takes.
const letters = [_][]const u8{ "a", "b" };

/// The shapes of such a pattern.
const Shape = enum {
    /// A run, then a word: the word ends every match.
    suffix,
    /// A word, then a run: the word starts every match.
    prefix,
    /// A run, a word, and a run: the word stands inside every match.
    inner,
    /// Two words in an alternation, then a run.
    set,
    /// A run and a word, or a word alone.
    either,
    /// `(?:[ab]|c[ab]W)W` for a word W, then a run: a match from `c` holds a shorter match that
    /// starts later and ends sooner. A search from the word's places then needs a rule, which
    /// spec/lean/Stdx/Regex/Required.lean names `NoEarlier` (`needs_no_earlier`).
    nested,
};

fn pick(generator: *Generator, comptime list: []const []const u8) []const u8 {
    return list[generator.below(list.len)];
}

/// Adds a piece to a text where it fits.
fn fit(text: *std.ArrayList(u8), piece: []const u8) void {
    if (text.unusedCapacitySlice().len >= piece.len) text.appendSliceAssumeCapacity(piece);
}

fn fit_pieces(generator: *Generator, text: *std.ArrayList(u8)) void {
    for (0..generator.below(claim_text_pieces_max + 1)) |_| fit(text, pick(generator, &claim_text_pieces));
}

/// Draws the text of such a case. Half of the texts hold the pattern's word twice: a search
/// from the word's places then has two places to judge. For the nested shape the two words
/// follow `c` and a letter, as in `cbabab` for `(?:[ab]|c[ab]ab)ab`, which is the text that
/// holds both of that shape's matches.
fn claim_text(generator: *Generator, case: *regex_generate.Case, shape: Shape, word: []const u8) void {
    var text: std.ArrayList(u8) = .initBuffer(case.text[0..text_len_max]);
    fit_pieces(generator, &text);
    if (generator.below(2) == 0) {
        if (shape == .nested) {
            fit(&text, "c");
            fit(&text, pick(generator, &letters));
            fit(&text, word);
        } else {
            fit(&text, word);
            fit_pieces(generator, &text);
        }
        fit(&text, word);
    }
    fit_pieces(generator, &text);
    case.text_len = text.items.len;
}

/// Draws a case shaped for the searcher's claims.
fn claim_case(generator: *Generator, case: *regex_generate.Case) void {
    case.* = .{};
    var pattern: std.ArrayList(u8) = .initBuffer(&case.pattern.octets);
    const run = pick(generator, &runs);
    const word = pick(generator, &words);
    const other = pick(generator, &words);
    const second = pick(generator, &runs);
    const shape: Shape = @enumFromInt(generator.below(std.meta.fields(Shape).len));
    switch (shape) {
        .suffix => pattern.printAssumeCapacity("{s}{s}", .{ run, word }),
        .prefix => pattern.printAssumeCapacity("{s}{s}", .{ word, run }),
        .inner => pattern.printAssumeCapacity("{s}{s}{s}", .{ run, word, second }),
        .set => pattern.printAssumeCapacity("(?:{s}|{s}){s}", .{ word, other, run }),
        .either => pattern.printAssumeCapacity("(?:{s}{s}|{s})", .{ run, word, other }),
        .nested => pattern.printAssumeCapacity("(?:[ab]|c[ab]{s}){s}{s}", .{ word, word, second }),
    }
    pattern.appendSliceAssumeCapacity(pick(generator, &tails));
    case.pattern.len = pattern.items.len;
    claim_text(generator, case, shape, word);
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

    /// One case: a pattern, the program `compile` gave it, a text, and a search from each offset
    /// of `lows`.
    pub fn add_case(lines: *Lines, pattern: []const u8, program: *const regex.Program, text: []const u8, lows: []const usize) !void {
        try lines.add_pattern(pattern);
        try lines.add_program(program);
        try lines.add_text(text);
        for (lows) |low| try lines.add("search {d}", .{low});
    }
};

/// Writes a drawn case with one or two searches: one from the text's start, and one from an
/// offset the seed draws. False where the case is left out: its pattern did not fit, `compile`
/// refused it, or its program is too large for the storage or the slots.
fn add_drawn(lines: *Lines, generator: *Generator, case: *const regex_generate.Case, encoding: regex.Encoding, storage: []Instruction) !bool {
    if (case.overflowed()) return false;
    const program = regex.compile(case.pattern.slice(), .{ .encoding = encoding }, storage) catch return false;
    if (program.slot_count() > slots_max) return false;
    const text = case.text[0..@min(case.text_len, text_len_max)];
    const lows = [_]usize{ 0, generator.below(text.len + 1) };
    try lines.add_case(case.pattern.slice(), &program, text, if (lows[1] == 0) lows[0..1] else &lows);
    return true;
}

/// The dump of `count` cases that `seed` draws, or of fewer where too many are left out.
pub fn dump(arena: std.mem.Allocator, seed: u64, count: usize) ![]const u8 {
    var lines: Lines = .{ .arena = arena };
    try lines.add("# seed {d}: the programs `compile` gives drawn patterns, for `vectors --answers`.", .{seed});
    const storage = try arena.alloc(Instruction, instructions_max);
    var generator = Generator.init(seed);
    var case: regex_generate.Case = .{};
    var kept: usize = 0;
    for (0..count * draws_per_case) |draw| {
        if (kept == count) break;
        // Two draws of each source in turn, so that each source is read as UTF-8 and as bytes.
        if (draw / 2 % 2 == 0) regex_generate.next(&generator, &case) else claim_case(&generator, &case);
        const encoding: regex.Encoding = if (draw % 2 == 0) .utf8 else .bytes;
        if (try add_drawn(&lines, &generator, &case, encoding, storage)) kept += 1;
    }
    return lines.bytes.items;
}

const testing = std.testing;

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
    // A case holds one search, and a second one where the seed draws an offset past 0.
    try testing.expect(searches > cases and searches <= 2 * cases);
    // One seed gives one dump.
    try testing.expectEqualStrings(text, try dump(arena_state.allocator(), 1, cases));
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
