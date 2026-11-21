//! Invariant 18's check for the matcher: the work of a search, counted, stays under a constant
//! times the program's instructions for each octet, on the patterns the papers name as a
//! backtracking matcher's worst cases (decision 86).
const std = @import("std");
const testing = std.testing;
const matcher_test = @import("matcher_test.zig");
const matcher_file = @import("matcher.zig");

/// The instructions a position's threads try at most, for each instruction of the program: one
/// try from a seed or the stack, one from the instruction before it, and one that finds it
/// visited. Then each thread reads the position's octet once.
const tries_per_instruction = 4;

/// The texts' lengths: the shortest, and each of the others twice the one before, so a count
/// that grows faster than the text shows.
const text_len_min = 64;
const text_len_max = 512;

const Worst = struct {
    pattern: []const u8,
    /// The octet the text repeats. No text holds a match, so the search reads all of it.
    octet: u8,
};

const worst = [_]Worst{
    // Cox (2007): a backtracking matcher takes 2^n steps on a?^n a^n over a^n.
    .{ .pattern = "(a?){24}a{24}b", .octet = 'a' },
    // Nested quantifiers, the shape of Staicu and Pradel's (a+)+b.
    .{ .pattern = "(a+)+b", .octet = 'a' },
    .{ .pattern = "(a*)*b", .octet = 'a' },
    .{ .pattern = "(a|aa)+b", .octet = 'a' },
    .{ .pattern = "(a|a?)+b", .octet = 'a' },
    .{ .pattern = "(x+x+)+y", .octet = 'x' },
    // The shape of Cloudflare's pattern of 2 July 2019.
    .{ .pattern = "(?:.*=.*)+;", .octet = 'x' },
    // The shape of Stack Overflow's pattern of 20 July 2016: quadratic in a backtracking matcher.
    .{ .pattern = "\\s+$", .octet = ' ' },
    .{ .pattern = "^(\\w+\\s?)*$", .octet = 'a' },
};

fn search_work(fixture: *matcher_test.Fixture, text: []const u8) !u64 {
    fixture.matcher.start(null, 0);
    fixture.matcher.work = 0;
    const end = fixture.matcher.search(text, .last);
    try testing.expectEqual(text.len, end.consumed);
    return fixture.matcher.work;
}

test "the matcher's work for each octet stays under four tries for each instruction" {
    var fixture: matcher_test.Fixture = .{};
    var text: [text_len_max + 1]u8 = undefined;
    for (worst) |case| {
        try fixture.init(case.pattern, .{ .captures = .groups });
        const per_octet = tries_per_instruction * fixture.program.forward_len + 1;
        @memset(&text, case.octet);
        // A last octet that no pattern here takes, so no text ends in a match.
        var len: usize = text_len_min;
        while (len <= text_len_max) : (len += len) {
            text[len] = '!';
            const work = try search_work(&fixture, text[0 .. len + 1]);
            try testing.expect(work <= (len + 1 + 1) * per_octet);
            try testing.expect(work >= len);
            text[len] = case.octet;
        }
    }
}

test "the matcher's work on twice the text is at most twice the work, and a constant" {
    var fixture: matcher_test.Fixture = .{};
    var text: [text_len_max]u8 = undefined;
    for (worst) |case| {
        try fixture.init(case.pattern, .{ .captures = .groups });
        @memset(&text, case.octet);
        var before = try search_work(&fixture, text[0..text_len_min]);
        var len: usize = text_len_min + text_len_min;
        while (len <= text_len_max) : (len += len) {
            const work = try search_work(&fixture, text[0..len]);
            const slack = tries_per_instruction * fixture.program.forward_len;
            try testing.expect(work <= before + before + slack);
            before = work;
        }
    }
}
