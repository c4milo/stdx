//! The tests of matcher_replay.zig: what a replay passes, what it counts, and the line it names
//! where a file holds an answer `Matcher.find` does not give or a program `compile` does not
//! write.
const std = @import("std");
const regex = @import("regex");
const matcher_replay = @import("matcher_replay.zig");
const replay_dump = @import("matcher_replay_dump.zig");
const Instruction = regex.Instruction;
const Replay = matcher_replay.Replay;
const replay_text = matcher_replay.replay_text;
const same = matcher_replay.same;
const no_claims = matcher_replay.no_claims;
const searcher_count = matcher_replay.searcher_count;
const long_read_len = matcher_replay.long_read_len;
const long_read_searcher = matcher_replay.long_read_searcher;
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
    try testing.expectEqual(@as(usize, 0), replay.long_reads);
}

test "a replay names the line of an answer the matcher does not give" {
    const cases = [_]struct { line: []const u8, cause: anyerror }{
        .{ .line = "find 0 1 3", .cause = error.EndDiffers },
        .{ .line = "find 0 0 2", .cause = error.StartDiffers },
        .{ .line = "find 0 none", .cause = error.MatchUnexpected },
        .{ .line = "find 2 2 3", .cause = error.MatchMissing },
        .{ .line = "find 4 none", .cause = error.VectorOffset },
        .{ .line = "walk 0", .cause = error.VectorWord },
        .{ .line = "differs dfa 0 gives 0 2", .cause = error.ModelCheckFailed },
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
    try lines.add_case("a|ab", &program, null, "xab", &.{ 0, 2 });
    const first = try std.mem.replaceOwned(u8, arena, lines.bytes.items, "search 0", "find 0 1 2");
    return std.mem.replaceOwned(u8, arena, first, "search 2", "find 2 none");
}

test "a replay compiles a named pattern and asks the matcher and each searcher" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const text = try answered_case(arena.allocator());
    var replay = try Replay.init(arena.allocator());
    try testing.expect(replay_text(&replay, text) == null);
    try testing.expectEqual(@as(usize, 1), replay.programs);
    try testing.expectEqual(@as(usize, 1), replay.patterns);
    try testing.expectEqual(@as(usize, 2), replay.finds);
    try testing.expectEqual(@as(usize, 2 * searcher_count), replay.searcher_finds);
    // One of the case's two searches starts at 0, and each searcher answers `is_match` for it.
    try testing.expectEqual(@as(usize, searcher_count), replay.is_matches);
    try testing.expectEqual(@as(usize, 1), replay.long_reads);
    try testing.expectEqualStrings("xabxab", replay.long_text[0 .. 2 * "xab".len]);
    try testing.expectEqual(@as(usize, long_read_len), replay.long_text.len);
    // The fourth searcher's DFAs started, with a cache far under the default one. The words
    // before these would not start them.
    const small = &replay.searchers[matcher_replay.small_cache_searcher];
    try testing.expect(small.forward_ready and small.reverse_ready);
    try testing.expect(replay.small_cache_words > 0 and replay.small_cache_words < regex.constants.cache_words_default / 16);
    try testing.expect(replay.program.reverse != replay_dump.no_entry);
}

/// The dump of `[0-9]+ab` over `x12ab`, with its search answered. A new searcher takes claim
/// R4 for it by the first rule: no digit is the literal's first byte.
fn answered_claim(arena: std.mem.Allocator) ![]const u8 {
    var lines: replay_dump.Lines = .{ .arena = arena };
    var scratch = try replay_dump.Scratch.init(arena);
    const pattern = "[0-9]+ab";
    const program = try regex.compile(pattern, .{}, scratch.storage);
    try lines.add_case(pattern, &program, scratch.suffix_claim(&program), "x12ab", &.{0});
    return std.mem.replaceOwned(u8, arena, lines.bytes.items, "search 0", "find 0 1 5");
}

test "a replay requires its new searcher to hold the literal of a claim line" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const text = try answered_claim(arena.allocator());
    try testing.expect(std.mem.indexOf(u8, text, "\nclaim suffix 2 97 98\n") != null);
    var replay = try Replay.init(arena.allocator());
    try testing.expect(replay_text(&replay, text) == null);
    try testing.expectEqual(@as(usize, 1), replay.claims);
    const cases = [_]struct { old: []const u8, new: []const u8, cause: anyerror }{
        // Another literal of the same length, a shorter one, and no line.
        .{ .old = "claim suffix 2 97 98", .new = "claim suffix 2 97 99", .cause = error.ClaimDiffers },
        .{ .old = "claim suffix 2 97 98", .new = "claim suffix 1 98", .cause = error.ClaimDiffers },
        .{ .old = "claim suffix 2 97 98\n", .new = "", .cause = error.ClaimDiffers },
        .{ .old = "claim suffix 2 97 98", .new = "claim inner 2 97 98", .cause = error.VectorClaim },
        .{ .old = "claim suffix 2 97 98", .new = "claim suffix 0", .cause = error.VectorClaim },
    };
    for (cases) |case| {
        const changed = try std.mem.replaceOwned(u8, arena.allocator(), text, case.old, case.new);
        try testing.expect(!std.mem.eql(u8, changed, text));
        var other = try Replay.init(arena.allocator());
        const failed = replay_text(&other, changed) orelse return error.TestExpectedFailure;
        try testing.expectEqual(case.cause, failed.cause);
    }
    // A pattern with no such literal has no line, and a line for it is refused.
    const plain = try answered_case(arena.allocator());
    try testing.expect(std.mem.indexOf(u8, plain, "claim") == null);
    const claimed = try std.mem.replaceOwned(u8, arena.allocator(), plain, "\ntext ", "\nclaim suffix 1 98\ntext ");
    var third = try Replay.init(arena.allocator());
    const failed = replay_text(&third, claimed) orelse return error.TestExpectedFailure;
    try testing.expectEqual(error.ClaimDiffers, failed.cause);
}

test "the long text judges each claim that waits, in the third searcher alone" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    var lines: replay_dump.Lines = .{ .arena = arena.allocator() };
    const storage = try arena.allocator().alloc(Instruction, replay_dump.instructions_max);
    // A searcher of this pattern waits before it judges claim R14 (decision 86, the claims
    // that wait). Its reverse program is long enough that a text of one byte an instruction,
    // read twice, judges nothing.
    const pattern = "[ab]+x[ab]{20}";
    const program = try regex.compile(pattern, .{}, storage);
    try lines.add_case(pattern, &program, null, "axb", &.{0});
    const text = try std.mem.replaceOwned(u8, arena.allocator(), lines.bytes.items, "search 0", "find 0 none");
    var replay = try Replay.init(arena.allocator());
    try testing.expect(replay_text(&replay, text) == null);
    try testing.expect(replay.searchers[0].deferred.any());
    try testing.expect(!replay.searchers[long_read_searcher].deferred.any());
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
