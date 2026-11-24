//! `matcher_replay <vector file>`: the Lean model of the matcher, held to `Matcher.find` and to
//! `Searcher.find` on programs a seed draws (decision 86, design §8 part 22h).
//!
//! A vector file holds programs, texts and the answer that
//! spec/lean/Stdx/Regex/MatcherAnswer.lean proves for each search. It comes from one of two
//! places, and `tools/matcher_model_check.sh` runs both with a new seed:
//!
//! - `lake exe vectors --random <seed> <count>` draws programs as instructions. This program
//!   builds each one and requires `Matcher.find` to give the answer.
//! - `matcher_replay dump <seed> <count> <file>` writes the programs `compile` gives the
//!   patterns a seed draws (matcher_replay_dump.zig), and `lake exe vectors --answers <file>`
//!   answers each search. This program compiles each pattern again, requires the program the
//!   file lists, and requires the answer of `Matcher.find`, of a `Searcher` with every claim
//!   and of a `Searcher` with none. A line that begins `differs` says the model's reverse scan
//!   over the reverse program did not give the answer's start, and fails the replay.
//!
//! It exits 1 at the first line that fails, and names the line.
//! src/regex/matcher_vectors_test.zig replays the committed file of one seed as a unit test.
const std = @import("std");
const regex = @import("regex");
const platform = @import("platform");
const replay_dump = @import("matcher_replay_dump.zig");
const Instruction = regex.Instruction;
const Matcher = regex.Matcher;
const Searcher = regex.Searcher;

const radix = 10;
const hexadecimal = 16;

/// The longest pattern a file names (tools/differential/regex_generate.zig).
const pattern_len_max = 2048;

/// The slots of the whole match, which is all a replay of instructions reads.
const span_slots = 2;

/// The searchers a compiled pattern's searches run: one with every claim, one with none.
const searcher_count = 2;

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

/// Every claim of a searcher turned off: the DFAs and the matcher alone.
fn no_claims() regex.SearcherClaims {
    var claims: regex.SearcherClaims = .{};
    inline for (std.meta.fields(regex.SearcherClaims)) |field| @field(claims, field.name) = false;
    return claims;
}

/// The span a `find` line names, or null for `none`.
const Expected = ?struct { start: u64, end: u64 };

fn same(found: ?regex.Span, expected: Expected) bool {
    const span = found orelse return expected == null;
    const wanted = expected orelse return false;
    return span.start == wanted.start and span.end == wanted.end;
}

/// A file's programs and their searches, taken one line at a time. A replay stays where it is:
/// its searchers point at its program.
const Replay = struct {
    /// The instructions of the program's lines, and how many its `program` line names.
    listed: []Instruction,
    listed_len: u32 = 0,
    listed_named: u32 = 0,
    encoding: regex.Encoding = .utf8,
    forward: u32 = 0,
    reverse: u32 = replay_dump.no_entry,
    /// The pattern a `pattern` line named for the program that follows it.
    pattern: [pattern_len_max]u8 = undefined,
    pattern_len: usize = 0,
    pattern_pending: bool = false,
    /// Whether the program's lines came from a pattern, which the replay compiles again.
    compiled: bool = false,
    /// Whether the matcher and the searchers hold the program of the lines read.
    ready: bool = false,
    storage: []Instruction,
    program: regex.Program = undefined,
    text: [replay_dump.text_len_max]u8 = undefined,
    text_len: usize = 0,
    matcher: Matcher = undefined,
    matcher_memory: []u64,
    searchers: [searcher_count]Searcher = undefined,
    searcher_memory: [searcher_count][]u64,
    features: platform.CpuFeatures,
    programs: usize = 0,
    patterns: usize = 0,
    finds: usize = 0,
    searcher_finds: usize = 0,

    fn init(arena: std.mem.Allocator) !Replay {
        const count = replay_dump.instructions_max;
        var replay: Replay = .{
            .listed = try arena.alloc(Instruction, count),
            .storage = try arena.alloc(Instruction, count),
            .matcher_memory = try arena.alloc(u64, Matcher.memory_len(count, replay_dump.slots_max)),
            .searcher_memory = undefined,
            .features = platform.CpuFeatures.detect(),
        };
        const words = Searcher.memory_len(count, replay_dump.slots_max, regex.constants.cache_words_default);
        for (&replay.searcher_memory) |*memory| memory.* = try arena.alloc(u64, words);
        return replay;
    }

    fn feed(replay: *Replay, line: []const u8) !void {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        const word = try take(&tokens);
        if (std.mem.eql(u8, word, "pattern")) return replay.set_pattern(try take(&tokens));
        if (std.mem.eql(u8, word, "program")) return replay.begin(&tokens);
        if (std.mem.eql(u8, word, "text")) return replay.set_text(&tokens);
        if (std.mem.eql(u8, word, "find")) return replay.expect_find(&tokens);
        if (std.mem.eql(u8, word, "differs")) return error.ModelReverseDiffers;
        const kind = std.meta.stringToEnum(regex.Kind, word) orelse return error.VectorWord;
        if (replay.listed_len == replay.listed.len) return error.VectorProgramLong;
        replay.listed[replay.listed_len] = try instruction_of(kind, &tokens);
        replay.listed_len += 1;
    }

    /// A pattern's bytes from two hexadecimal digits each, or from `-` for the empty pattern.
    fn set_pattern(replay: *Replay, digits: []const u8) !void {
        const pattern = if (std.mem.eql(u8, digits, "-")) "" else digits;
        if (pattern.len % 2 != 0 or pattern.len / 2 > pattern_len_max) return error.VectorPattern;
        replay.pattern_len = pattern.len / 2;
        for (replay.pattern[0..replay.pattern_len], 0..) |*byte, index| {
            byte.* = try std.fmt.parseInt(u8, pattern[2 * index ..][0..2], hexadecimal);
        }
        replay.pattern_pending = true;
        replay.patterns += 1;
    }

    fn begin(replay: *Replay, tokens: *Tokens) !void {
        replay.encoding = std.meta.stringToEnum(regex.Encoding, try take(tokens)) orelse return error.VectorEncoding;
        replay.listed_named = try number(u32, tokens);
        replay.forward = try number(u32, tokens);
        const reverse = try take(tokens);
        replay.reverse = if (std.mem.eql(u8, reverse, "none")) replay_dump.no_entry else try std.fmt.parseInt(u32, reverse, radix);
        replay.compiled = replay.pattern_pending;
        replay.pattern_pending = false;
        replay.ready = false;
        replay.listed_len = 0;
        replay.programs += 1;
    }

    /// The program the listed instructions make: a forward program alone, whose one group is
    /// the whole match. Only the matcher runs it: a DFA needs the classes `compile` finds.
    fn listed_program(replay: *const Replay) regex.Program {
        return .{
            .instructions = replay.listed[0..replay.listed_len],
            .forward_len = replay.listed_len,
            .forward_nodes = replay.listed_len,
            .reverse_nodes = 0,
            .forward = replay.forward,
            .reverse = replay_dump.no_entry,
            .group_count = 1,
            .reads_ahead = true,
            .has_looks = true,
            .encoding = replay.encoding,
            .classes = @splat(0),
            .class_count = 1,
            .names = &.{},
        };
    }

    /// Compiles the pattern again, and requires the program the file lists: the proved answers
    /// are answers of those lines.
    fn compile_listed(replay: *Replay) !void {
        const pattern = replay.pattern[0..replay.pattern_len];
        replay.program = regex.compile(pattern, .{ .encoding = replay.encoding }, replay.storage) catch return error.PatternRefused;
        const program = &replay.program;
        if (program.forward != replay.forward or program.reverse != replay.reverse) return error.ProgramDiffers;
        if (program.instructions.len != replay.listed_len) return error.ProgramDiffers;
        for (program.instructions, replay.listed[0..replay.listed_len]) |made, listed| {
            var made_line: [replay_dump.line_len_max]u8 = undefined;
            var listed_line: [replay_dump.line_len_max]u8 = undefined;
            if (!std.mem.eql(u8, try replay_dump.line_of(&made_line, made), try replay_dump.line_of(&listed_line, listed))) return error.ProgramDiffers;
        }
    }

    /// Readies the matcher, and for a compiled pattern the searchers, for the lines read.
    fn make_ready(replay: *Replay) !void {
        if (replay.listed_len != replay.listed_named or replay.forward >= replay.listed_len) return error.VectorProgram;
        replay.ready = true;
        if (!replay.compiled) {
            replay.program = replay.listed_program();
            return replay.matcher.init(&replay.program, .{ .captures = .span }, replay.matcher_memory);
        }
        try replay.compile_listed();
        const program = &replay.program;
        if (program.slot_count() > replay_dump.slots_max) return error.VectorProgramLong;
        replay.matcher.init(program, .{ .captures = .span }, replay.matcher_memory);
        const claims = [searcher_count]regex.SearcherClaims{ .{}, no_claims() };
        const words = Searcher.memory_len(program.forward_len, program.slot_count(), regex.constants.cache_words_default);
        for (&replay.searchers, replay.searcher_memory, claims) |*searcher, memory, claim| {
            searcher.init(program, &.{ .features = replay.features, .claims = claim }, memory[0..words]);
        }
    }

    fn set_text(replay: *Replay, tokens: *Tokens) !void {
        replay.text_len = try number(usize, tokens);
        if (replay.text_len > replay.text.len) return error.VectorTextLong;
        for (replay.text[0..replay.text_len]) |*byte| byte.* = try number(u8, tokens);
        if (!replay.ready) try replay.make_ready();
    }

    fn expect_find(replay: *Replay, tokens: *Tokens) !void {
        if (!replay.ready) return error.VectorOrder;
        const low = try number(usize, tokens);
        if (low > replay.text_len) return error.VectorOffset;
        const first = try take(tokens);
        const expected: Expected = if (std.mem.eql(u8, first, "none")) null else .{
            .start = try std.fmt.parseInt(u64, first, radix),
            .end = try number(u64, tokens),
        };
        const text = replay.text[0..replay.text_len];
        replay.finds += 1;
        try expect_matcher(replay.matcher.find(text, low), expected);
        if (!replay.compiled) return;
        const causes = [searcher_count]anyerror{ error.SearcherDiffers, error.SearcherWithNoClaimDiffers };
        for (&replay.searchers, causes) |*searcher, cause| {
            replay.searcher_finds += 1;
            if (!same(searcher.find(text, low), expected)) return cause;
        }
    }
};

/// What the matcher gave against the proved answer, each difference with a cause of its own.
fn expect_matcher(found: ?regex.Span, expected: Expected) !void {
    const wanted = expected orelse return if (found == null) {} else error.MatchUnexpected;
    const span = found orelse return error.MatchMissing;
    if (span.start != wanted.start) return error.StartDiffers;
    if (span.end != wanted.end) return error.EndDiffers;
}

const Failure = struct { number: usize, line: []const u8, cause: anyerror };

/// Replays every line of a file's text. Gives the line that failed, with its number, or null.
fn replay_text(replay: *Replay, text: []const u8) ?Failure {
    var lines = std.mem.tokenizeScalar(u8, text, '\n');
    var line_number: usize = 0;
    while (lines.next()) |line| {
        line_number += 1;
        if (line[0] == '#') continue;
        replay.feed(line) catch |cause| return .{ .number = line_number, .line = line, .cause = cause };
    }
    return null;
}

fn usage() noreturn {
    std.debug.print("usage: matcher_replay <vector file> | matcher_replay dump <seed> <count> <file>\n", .{});
    std.process.exit(2);
}

/// `matcher_replay dump <seed> <count> <file>`.
fn write_dump(init: std.process.Init, arena: std.mem.Allocator, args: []const []const u8) !void {
    const seed = std.fmt.parseInt(u64, args[0], radix) catch usage();
    const count = std.fmt.parseInt(usize, args[1], radix) catch usage();
    const text = try replay_dump.dump(arena, seed, count);
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = text });
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    const dump_arguments = 5;
    if (args.len == dump_arguments and std.mem.eql(u8, args[1], "dump")) return write_dump(init, arena, args[2..]);
    if (args.len != 2) usage();
    const text = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], arena, .unlimited);
    var replay = try Replay.init(arena);
    if (replay_text(&replay, text)) |failed| {
        std.debug.print("matcher_replay: {s}, line {d}: `{s}`: {s}\n", .{ args[1], failed.number, failed.line, @errorName(failed.cause) });
        if (replay.compiled) std.debug.print("matcher_replay: the pattern is \"{f}\", read as {s}\n", .{ std.zig.fmtString(replay.pattern[0..replay.pattern_len]), @tagName(replay.encoding) });
        std.process.exit(1);
    }
    std.debug.print("matcher_replay: {d} programs, {d} of them compiled from a pattern, {d} searches, each the proved answer\n", .{ replay.programs, replay.patterns, replay.finds });
}

const testing = std.testing;

/// `a|ab` between its two saves, over `xab`: the match from 1 up to 2 for a search from 0 or
/// from 1, and none from 2 or from 3.
const test_vectors =
    \\# a comment
    \\program utf8 7 0 none
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
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    var replay = try Replay.init(arena.allocator());
    try testing.expect(replay_text(&replay, test_vectors) == null);
    try testing.expectEqual(@as(usize, 1), replay.programs);
    try testing.expectEqual(@as(usize, 0), replay.patterns);
    try testing.expectEqual(@as(usize, 4), replay.finds);
    // A program of instructions runs no searcher.
    try testing.expectEqual(@as(usize, 0), replay.searcher_finds);
}

test "a replay names the line of an answer the matcher does not give" {
    const cases = [_]struct { line: []const u8, cause: anyerror }{
        .{ .line = "find 0 1 3", .cause = error.EndDiffers },
        .{ .line = "find 0 0 2", .cause = error.StartDiffers },
        .{ .line = "find 0 none", .cause = error.MatchUnexpected },
        .{ .line = "find 2 2 3", .cause = error.MatchMissing },
        .{ .line = "find 4 none", .cause = error.VectorOffset },
        .{ .line = "walk 0", .cause = error.VectorWord },
        .{ .line = "differs back 0 2 gives 0", .cause = error.ModelReverseDiffers },
    };
    // The file's 14 lines, and the case's line after them.
    const failing_line = 15;
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    for (cases) |case| {
        var text: [test_vectors.len + 32]u8 = undefined;
        const whole = try std.fmt.bufPrint(&text, "{s}{s}\n", .{ test_vectors, case.line });
        var replay = try Replay.init(arena.allocator());
        const failed = replay_text(&replay, whole) orelse return error.TestExpectedFailure;
        try testing.expectEqual(@as(usize, failing_line), failed.number);
        try testing.expectEqualStrings(case.line, failed.line);
        try testing.expectEqual(case.cause, failed.cause);
    }
}

/// The dump of `a|ab` over `xab`, with its searches from 0 and from 2 answered.
fn answered_case(arena: std.mem.Allocator) ![]const u8 {
    var lines: replay_dump.Lines = .{ .arena = arena };
    const storage = try arena.alloc(Instruction, replay_dump.instructions_max);
    const program = try regex.compile("a|ab", .{}, storage);
    try lines.add_case("a|ab", &program, "xab", &.{ 0, 2 });
    const first = try std.mem.replaceOwned(u8, arena, lines.bytes.items, "search 0", "find 0 1 2");
    return std.mem.replaceOwned(u8, arena, first, "search 2", "find 2 none");
}

test "a replay compiles a named pattern and asks the matcher and both searchers" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const text = try answered_case(arena.allocator());
    var replay = try Replay.init(arena.allocator());
    try testing.expect(replay_text(&replay, text) == null);
    try testing.expectEqual(@as(usize, 1), replay.programs);
    try testing.expectEqual(@as(usize, 1), replay.patterns);
    try testing.expectEqual(@as(usize, 2), replay.finds);
    try testing.expectEqual(@as(usize, 2 * searcher_count), replay.searcher_finds);
    try testing.expect(replay.program.reverse != replay_dump.no_entry);
}

test "a replay refuses a program that is not the one its pattern compiles to" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const text = try answered_case(arena.allocator());
    const cases = [_]struct { old: []const u8, new: []const u8, cause: anyerror }{
        // `a|ac` in place of `a|ab`: one range differs.
        .{ .old = "pattern 617c6162", .new = "pattern 617c6163", .cause = error.ProgramDiffers },
        // `a|ab|c` holds more instructions.
        .{ .old = "pattern 617c6162", .new = "pattern 617c61627c63", .cause = error.ProgramDiffers },
        .{ .old = "pattern 617c6162", .new = "pattern 28", .cause = error.PatternRefused },
        .{ .old = "pattern 617c6162", .new = "pattern 617", .cause = error.VectorPattern },
        // A program line that names one instruction more than the lines hold.
        .{ .old = "program utf8 ", .new = "program utf8 1", .cause = error.VectorProgram },
    };
    for (cases) |case| {
        const changed = try std.mem.replaceOwned(u8, arena.allocator(), text, case.old, case.new);
        try testing.expect(!std.mem.eql(u8, changed, text));
        var replay = try Replay.init(arena.allocator());
        const failed = replay_text(&replay, changed) orelse return error.TestExpectedFailure;
        try testing.expectEqual(case.cause, failed.cause);
        try testing.expect(std.mem.startsWith(u8, failed.line, "text ") or std.mem.startsWith(u8, failed.line, "pattern "));
    }
}

test "a replay refuses a program line whose entries are not the compiled program's" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const text = try answered_case(arena.allocator());
    const storage = try arena.allocator().alloc(Instruction, replay_dump.instructions_max);
    const program = try regex.compile("a|ab", .{}, storage);
    const count = program.instructions.len;
    const entries = [_][2]u32{ .{ program.forward - 1, program.reverse }, .{ program.forward, program.reverse - 1 } };
    for (entries) |entry| {
        var old: [replay_dump.line_len_max]u8 = undefined;
        var new: [replay_dump.line_len_max]u8 = undefined;
        const line = try std.fmt.bufPrint(&old, "program utf8 {d} {d} {d}", .{ count, program.forward, program.reverse });
        const other = try std.fmt.bufPrint(&new, "program utf8 {d} {d} {d}", .{ count, entry[0], entry[1] });
        const changed = try std.mem.replaceOwned(u8, arena.allocator(), text, line, other);
        try testing.expect(!std.mem.eql(u8, changed, text));
        var replay = try Replay.init(arena.allocator());
        const failed = replay_text(&replay, changed) orelse return error.TestExpectedFailure;
        try testing.expectEqual(error.ProgramDiffers, failed.cause);
    }
}

test "same holds a searcher's span to both offsets of the answer, and to none" {
    const span: regex.Span = .{ .start = 1, .end = 2 };
    try testing.expect(same(span, .{ .start = 1, .end = 2 }));
    try testing.expect(!same(span, .{ .start = 0, .end = 2 }));
    try testing.expect(!same(span, .{ .start = 1, .end = 3 }));
    try testing.expect(!same(span, null));
    try testing.expect(!same(null, .{ .start = 1, .end = 2 }));
    try testing.expect(same(null, null));
}

test "no_claims turns every claim of a searcher off" {
    const claims = no_claims();
    inline for (std.meta.fields(regex.SearcherClaims)) |field| try testing.expect(!@field(claims, field.name));
    try testing.expect((regex.SearcherClaims{}).suffix);
}

test {
    _ = replay_dump;
}
