//! `matcher_replay <vector file>`: the Lean model of the matcher, held to `Matcher.find` on
//! programs a seed draws (decision 86, design §8 part 22h).
//!
//! `lake exe vectors --random <seed> <count>` writes a file of programs, texts and the answer
//! that spec/lean/Stdx/Regex/MatcherAnswer.lean proves for each search. This program builds
//! each program, runs `Matcher.find`, and requires the same span. It exits 1 at the first
//! search that differs, and names the file's line. `tools/matcher_model_check.sh` runs both
//! with a new seed.
//!
//! src/regex/matcher_vectors_test.zig replays the committed file of one seed the same way, as a
//! unit test. This program reads its file when it runs, so a seed needs no build.
const std = @import("std");
const regex = @import("regex");
const Instruction = regex.Instruction;
const Matcher = regex.Matcher;

const radix = 10;

/// The instructions a program of a file holds at most, and the bytes of a text.
const instructions_max = 16;
const text_len_max = 8;

/// The slots of the whole match, which is all a replay reads.
const span_slots = 2;

/// The entry of a program with no reverse half (`program.no_entry`).
const no_entry = std.math.maxInt(u32);

const Tokens = std.mem.TokenIterator(u8, .scalar);

fn take(tokens: *Tokens) ![]const u8 {
    return tokens.next() orelse error.VectorShort;
}

fn number(comptime T: type, tokens: *Tokens) !T {
    return std.fmt.parseInt(T, try take(tokens), radix);
}

/// One instruction of a file: its kind was read, and its fields follow in the order
/// `Vectors.lean` writes them.
fn instruction_of(kind: regex.Kind, tokens: *Tokens) !Instruction {
    var instruction: Instruction = .{ .kind = kind };
    switch (kind) {
        .range => {
            instruction.lo = try number(u8, tokens);
            instruction.hi = try number(u8, tokens);
            instruction.out = try number(u32, tokens);
        },
        .ranges => instruction.arg = try number(u32, tokens),
        .split => {
            instruction.out = try number(u32, tokens);
            instruction.arg = try number(u32, tokens);
        },
        .save => {
            instruction.arg = try number(u32, tokens);
            instruction.out = try number(u32, tokens);
        },
        .look => {
            instruction.look = std.meta.stringToEnum(regex.Look, try take(tokens)) orelse return error.VectorLook;
            instruction.out = try number(u32, tokens);
        },
        .jump => instruction.out = try number(u32, tokens),
        .match, .fail => {},
    }
    return instruction;
}

/// A file's programs and their searches, taken one line at a time.
const Replay = struct {
    instructions: [instructions_max]Instruction = undefined,
    instructions_len: u32 = 0,
    encoding: regex.Encoding = .utf8,
    text: [text_len_max]u8 = undefined,
    text_len: usize = 0,
    matcher: Matcher = undefined,
    memory: [Matcher.memory_len(instructions_max, span_slots)]u64 = undefined,
    programs: usize = 0,
    finds: usize = 0,

    fn feed(replay: *Replay, line: []const u8) !void {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        const word = try take(&tokens);
        if (std.mem.eql(u8, word, "program")) return replay.begin(&tokens);
        if (std.mem.eql(u8, word, "text")) return replay.set_text(&tokens);
        if (std.mem.eql(u8, word, "find")) return replay.expect_find(&tokens);
        const kind = std.meta.stringToEnum(regex.Kind, word) orelse return error.VectorWord;
        if (replay.instructions_len == instructions_max) return error.VectorProgramLong;
        replay.instructions[replay.instructions_len] = try instruction_of(kind, &tokens);
        replay.instructions_len += 1;
    }

    fn begin(replay: *Replay, tokens: *Tokens) !void {
        replay.encoding = std.meta.stringToEnum(regex.Encoding, try take(tokens)) orelse return error.VectorEncoding;
        replay.instructions_len = 0;
        replay.programs += 1;
    }

    /// The program the instructions read so far make: a forward program alone, whose entry is
    /// its first instruction and whose one group is the whole match.
    fn program(replay: *const Replay) regex.Program {
        return .{
            .instructions = replay.instructions[0..replay.instructions_len],
            .forward_len = replay.instructions_len,
            .forward_nodes = replay.instructions_len,
            .reverse_nodes = 0,
            .forward = 0,
            .reverse = no_entry,
            .group_count = 1,
            .reads_ahead = true,
            .has_looks = true,
            .encoding = replay.encoding,
            .classes = @splat(0),
            .class_count = 1,
            .names = &.{},
        };
    }

    fn set_text(replay: *Replay, tokens: *Tokens) !void {
        replay.text_len = try number(usize, tokens);
        if (replay.text_len > text_len_max) return error.VectorTextLong;
        for (replay.text[0..replay.text_len]) |*byte| byte.* = try number(u8, tokens);
        const built = replay.program();
        replay.matcher.init(&built, .{ .captures = .span }, &replay.memory);
    }

    fn expect_find(replay: *Replay, tokens: *Tokens) !void {
        const low = try number(usize, tokens);
        if (low > replay.text_len) return error.VectorOffset;
        const found = replay.matcher.find(replay.text[0..replay.text_len], low);
        replay.finds += 1;
        const first = try take(tokens);
        if (std.mem.eql(u8, first, "none")) return if (found == null) {} else error.MatchUnexpected;
        const span = found orelse return error.MatchMissing;
        if (span.start != try std.fmt.parseInt(u64, first, radix)) return error.StartDiffers;
        if (span.end != try number(u64, tokens)) return error.EndDiffers;
    }
};

/// Replays every line of a file's text. Gives the line that failed, with its number, or null.
fn replay_text(replay: *Replay, text: []const u8) ?struct { number: usize, line: []const u8, cause: anyerror } {
    var lines = std.mem.tokenizeScalar(u8, text, '\n');
    var line_number: usize = 0;
    while (lines.next()) |line| {
        line_number += 1;
        if (line[0] == '#') continue;
        replay.feed(line) catch |cause| return .{ .number = line_number, .line = line, .cause = cause };
    }
    return null;
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len != 2) {
        std.debug.print("usage: matcher_replay <vector file>\n", .{});
        std.process.exit(2);
    }
    const text = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], arena, .unlimited);
    var replay: Replay = .{};
    if (replay_text(&replay, text)) |failed| {
        std.debug.print("matcher_replay: {s}, line {d}: `{s}`: {s}\n", .{ args[1], failed.number, failed.line, @errorName(failed.cause) });
        std.process.exit(1);
    }
    std.debug.print("matcher_replay: {d} programs, {d} searches, each the proved answer\n", .{ replay.programs, replay.finds });
}

const testing = std.testing;

/// `a|ab` between its two saves, over `xab`: the match from 1 up to 2 for a search from 0 or
/// from 1, and none from 2 or from 3.
const test_vectors =
    \\# a comment
    \\program utf8 7
    \\save 0 1
    \\split 2 3
    \\range 97 97 5
    \\range 97 97 4
    \\range 98 98 5
    \\save 1 6
    \\match
    \\text 3 120 97 98
    \\find 0 1 2
    \\find 1 1 2
    \\find 2 none
    \\find 3 none
    \\
;

test "a replay passes a file of proved answers, and counts its programs and searches" {
    var replay: Replay = .{};
    try testing.expect(replay_text(&replay, test_vectors) == null);
    try testing.expectEqual(@as(usize, 1), replay.programs);
    try testing.expectEqual(@as(usize, 4), replay.finds);
}

test "a replay names the line of an answer the matcher does not give" {
    const cases = [_]struct { line: []const u8, cause: anyerror }{
        .{ .line = "find 0 1 3", .cause = error.EndDiffers },
        .{ .line = "find 0 0 2", .cause = error.StartDiffers },
        .{ .line = "find 0 none", .cause = error.MatchUnexpected },
        .{ .line = "find 2 2 3", .cause = error.MatchMissing },
        .{ .line = "find 4 none", .cause = error.VectorOffset },
        .{ .line = "walk 0", .cause = error.VectorWord },
    };
    // The file's 14 lines, and the case's line after them.
    const failing_line = 15;
    for (cases) |case| {
        var text: [test_vectors.len + 16]u8 = undefined;
        const whole = try std.fmt.bufPrint(&text, "{s}{s}\n", .{ test_vectors, case.line });
        var replay: Replay = .{};
        const failed = replay_text(&replay, whole) orelse return error.TestExpectedFailure;
        try testing.expectEqual(@as(usize, failing_line), failed.number);
        try testing.expectEqualStrings(case.line, failed.line);
        try testing.expectEqual(case.cause, failed.cause);
    }
}
