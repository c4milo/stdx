//! The least length of a match that the compiler counted for a program, as a `least` line of a
//! dump names it (decision 86, claim R13's least length, design §8 part 22q).
//!
//! `compile` counts the fewest bytes a match takes from the program's fragments
//! (`Program.len_min`), and a searcher refuses a text shorter than that. The Lean side decides
//! from the program that no match takes fewer bytes (spec/lean/Stdx/Regex/RulesLength.lean). A
//! count that fails there makes a searcher refuse a text that holds a match.
const std = @import("std");
const regex = @import("regex");
const platform = @import("platform");

/// The count of a program's `least` line, which a replay keeps until the program's searches.
pub const Named = struct {
    least: ?u32 = null,
    /// The `least` lines read.
    lines: usize = 0,

    /// Forgets the line, for the next program.
    pub fn clear(named: *Named) void {
        named.least = null;
    }

    /// A `least` line after its first word: the count, more than zero.
    pub fn set(named: *Named, tokens: *std.mem.TokenIterator(u8, .scalar)) !void {
        const word = tokens.next() orelse return error.VectorLeast;
        const least = std.fmt.parseInt(u32, word, 10) catch return error.VectorLeast;
        if (least == 0 or tokens.next() != null) return error.VectorLeast;
        named.least = least;
        named.lines += 1;
    }

    /// Requires the compiled program to hold the count that the file names, and zero where the
    /// file names none, and the searcher to take it. So what the Lean side judged is what this
    /// build's compiler counts.
    pub fn expect(named: *const Named, program: *const regex.Program, searcher: *const regex.Searcher) !void {
        if (program.len_min != (named.least orelse 0)) return error.LeastDiffers;
        if (searcher.len_min != program.len_min) return error.LeastDiffers;
    }
};

const testing = std.testing;

test "a least line holds one count past zero, and a replay requires the program to hold it" {
    var named: Named = .{};
    var tokens = std.mem.tokenizeScalar(u8, "10", ' ');
    try named.set(&tokens);
    try testing.expectEqual(@as(?u32, 10), named.least);
    for ([_][]const u8{ "", "0", "x", "10 11" }) |line| {
        var wrong: Named = .{};
        var words = std.mem.tokenizeScalar(u8, line, ' ');
        try testing.expectError(error.VectorLeast, wrong.set(&words));
    }
    var storage: [256]regex.Instruction = undefined;
    const program = try regex.compile("\\w{10,}", .{ .encoding = .bytes }, &storage);
    const memory = try testing.allocator.alloc(u64, regex.Searcher.memory_len(program.forward_len, program.slot_count(), regex.constants.cache_words_default));
    defer testing.allocator.free(memory);
    var searcher: regex.Searcher = undefined;
    searcher.init(&program, &.{ .features = platform.CpuFeatures.detect() }, memory);
    try named.expect(&program, &searcher);
    // Another count, and no line.
    named.least = 9;
    try testing.expectError(error.LeastDiffers, named.expect(&program, &searcher));
    named.clear();
    try testing.expectError(error.LeastDiffers, named.expect(&program, &searcher));
    // A searcher with the claim off keeps no count, so it differs from the program's.
    var plain: regex.Searcher = undefined;
    plain.init(&program, &.{ .features = platform.CpuFeatures.detect(), .claims = .{ .length = false } }, memory);
    named.least = 10;
    try testing.expectError(error.LeastDiffers, named.expect(&program, &plain));
}
