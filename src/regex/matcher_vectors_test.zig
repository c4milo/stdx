//! The check that ties `Matcher` to the definitions spec/lean/Stdx/Regex/ proves (decision 86).
//! `answerOf_isAnswer` there says what a search of a program's text answers: the least start of
//! a match, and the end a backtracking matcher finds first from it. matcher_vectors.txt, which
//! spec/lean/Vectors.lean writes, holds that answer for programs written by hand and for
//! programs a seed draws, each over some texts and from each offset. This test builds each
//! program, runs `Matcher.find`, and requires the same span.
//!
//! The programs are instructions, and no pattern: the file holds the matcher to the proved
//! model, and says nothing of the compiler.
const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Instruction = program_file.Instruction;
const Program = program_file.Program;
const matcher_file = @import("matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;

const vectors = @embedFile("matcher_vectors.txt");
const radix = 10;

/// The instructions a program of the file holds at most, and the bytes of a text.
const instructions_max = 16;
const text_len_max = 8;

/// The programs and the searches the file holds.
const programs_expected = 272;
const finds_expected = 9749;

const Tokens = std.mem.TokenIterator(u8, .scalar);

fn take(tokens: *Tokens) ![]const u8 {
    return tokens.next() orelse error.TestVectorShort;
}

fn number(comptime T: type, tokens: *Tokens) !T {
    return std.fmt.parseInt(T, try take(tokens), radix);
}

/// One instruction of the file: its kind was read, and its fields follow in the order
/// `Vectors.lean` writes them.
fn instruction_of(kind: program_file.Kind, tokens: *Tokens) !Instruction {
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
            instruction.look = std.meta.stringToEnum(program_file.Look, try take(tokens)) orelse return error.TestVectorLook;
            instruction.out = try number(u32, tokens);
        },
        .jump => instruction.out = try number(u32, tokens),
        .match, .fail => {},
    }
    return instruction;
}

/// The file's programs and their searches, taken one line at a time.
const Replay = struct {
    instructions: [instructions_max]Instruction = undefined,
    instructions_len: u32 = 0,
    /// The instructions the program's line names, and where its forward program starts.
    instructions_named: u32 = 0,
    forward: u32 = 0,
    encoding: program_file.Encoding = .utf8,
    text: [text_len_max]u8 = undefined,
    text_len: usize = 0,
    matcher: Matcher = undefined,
    memory: [Matcher.memory_len(instructions_max, constants.group_slots)]u64 = undefined,
    programs: usize = 0,
    finds: usize = 0,

    fn feed(replay: *Replay, line: []const u8) !void {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        const word = try take(&tokens);
        if (std.mem.eql(u8, word, "program")) return replay.begin(&tokens);
        if (std.mem.eql(u8, word, "text")) return replay.set_text(&tokens);
        if (std.mem.eql(u8, word, "find")) return replay.expect_find(&tokens);
        const kind = std.meta.stringToEnum(program_file.Kind, word) orelse return error.TestVectorWord;
        try testing.expect(replay.instructions_len < instructions_max);
        replay.instructions[replay.instructions_len] = try instruction_of(kind, &tokens);
        replay.instructions_len += 1;
    }

    fn begin(replay: *Replay, tokens: *Tokens) !void {
        replay.encoding = std.meta.stringToEnum(program_file.Encoding, try take(tokens)) orelse return error.TestVectorEncoding;
        replay.instructions_named = try number(u32, tokens);
        replay.forward = try number(u32, tokens);
        // The file's programs are forward programs alone.
        try testing.expectEqualStrings("none", try take(tokens));
        replay.instructions_len = 0;
        replay.programs += 1;
    }

    /// The program the instructions read so far make: a forward program alone, whose one group
    /// is the whole match.
    fn program(replay: *const Replay) Program {
        return .{
            .instructions = replay.instructions[0..replay.instructions_len],
            .forward_len = replay.instructions_len,
            .forward_nodes = replay.instructions_len,
            .reverse_nodes = 0,
            .forward = replay.forward,
            .reverse = program_file.no_entry,
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
        try testing.expect(replay.text_len <= text_len_max);
        for (replay.text[0..replay.text_len]) |*byte| byte.* = try number(u8, tokens);
        try testing.expectEqual(replay.instructions_named, replay.instructions_len);
        try testing.expect(replay.forward < replay.instructions_len);
        const built = replay.program();
        replay.matcher.init(&built, .{ .captures = .span }, &replay.memory);
    }

    fn expect_find(replay: *Replay, tokens: *Tokens) !void {
        const low = try number(usize, tokens);
        const found = replay.matcher.find(replay.text[0..replay.text_len], low);
        replay.finds += 1;
        const first = try take(tokens);
        if (std.mem.eql(u8, first, "none")) return testing.expectEqual(@as(?Span, null), found);
        const span = found orelse return error.TestMatchMissing;
        try testing.expectEqual(try std.fmt.parseInt(u64, first, radix), span.start);
        try testing.expectEqual(try number(u64, tokens), span.end);
    }
};

test "the matcher gives the answer the proved definitions give, for each search of the vectors" {
    var replay: Replay = .{};
    var lines = std.mem.tokenizeScalar(u8, vectors, '\n');
    var line_number: usize = 0;
    while (lines.next()) |line| {
        line_number += 1;
        if (line[0] == '#') continue;
        replay.feed(line) catch |err| {
            // Name the line that failed: these two print its number and its text.
            testing.expectEqual(@as(usize, 0), line_number) catch {};
            testing.expectEqualStrings("", line) catch {};
            return err;
        };
    }
    try testing.expectEqual(@as(usize, programs_expected), replay.programs);
    try testing.expectEqual(@as(usize, finds_expected), replay.finds);
}
