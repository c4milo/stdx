//! unicode_tables_fold: the case orbits of CaseFolding.txt, as runs of each code point's next one
//! in its orbit, for tools/unicode/unicode_tables.zig.
//!
//! A line of CaseFolding.txt maps a code point to its folding under a status, which the file's
//! header defines. The simple case folding takes the lines of status C and S and leaves out those
//! of F and T, and UTS #18 RL1.5 asks a regular expression for the simple folding. Two code points
//! match under it when they fold to one code point. That code point and every code point that folds
//! to it make an orbit. The orbit's code points in ascending order, each followed by the next and the
//! last by the first, give each one's next code point.
//!
//! A run is a span of code points whose next ones follow one rule. Under an offset, each adds the
//! offset. Under pairs, the first of each two goes to the second, and the second back to the first.

const std = @import("std");
const parse = @import("unicode_tables_parse.zig");

pub const Error = parse.Error || error{FoldingInvalid};

/// How the code points of a run give their next ones.
pub const Step = union(enum) {
    offset: i32,
    pairs,
};

pub const Run = struct { lo: u32, hi: u32, step: Step };

/// The runs of CaseFolding.txt's simple case folding, in ascending order.
pub fn runs(arena: std.mem.Allocator, text: []const u8) Error![]Run {
    const next = try next_code_points(arena, try orbits(arena, text));
    return pair_runs(arena, try offset_runs(arena, next));
}

/// Each code point a folding names, and the code points that fold to it, beside it.
fn orbits(arena: std.mem.Allocator, text: []const u8) Error!std.AutoArrayHashMapUnmanaged(u32, std.ArrayList(u32)) {
    var folded: std.AutoArrayHashMapUnmanaged(u32, std.ArrayList(u32)) = .empty;
    var sources: std.AutoArrayHashMapUnmanaged(u32, void) = .empty;
    var lines: parse.Lines = .init(text);
    while (try lines.next()) |fields| {
        const code, const folding = try simple_folding(fields) orelse continue;
        try sources.put(arena, code, {});
        const entry = try folded.getOrPut(arena, folding);
        if (!entry.found_existing) {
            entry.value_ptr.* = .empty;
            try entry.value_ptr.append(arena, folding);
        }
        try entry.value_ptr.append(arena, code);
    }
    // A folding folds to itself: no code point that a folding names folds to another one.
    for (folded.keys()) |folding| if (sources.contains(folding)) return error.FoldingInvalid;
    return folded;
}

/// A line's code point and its folding, or null for a line of status F or T.
fn simple_folding(fields: []const []const u8) Error!?[2]u32 {
    // CaseFolding.txt: `<code>; <status>; <mapping>; # <name>`, so a fourth field is empty.
    if (fields.len < 3 or (fields.len == 4 and fields[3].len != 0)) return error.LineInvalid;
    const status = fields[1];
    if (std.mem.eql(u8, status, "F") or std.mem.eql(u8, status, "T")) return null;
    if (!std.mem.eql(u8, status, "C") and !std.mem.eql(u8, status, "S")) return error.LineInvalid;
    const code = (try parse.code_points(fields[0])).lo;
    const folding = (try parse.code_points(fields[2])).lo;
    if (code == folding) return error.FoldingInvalid;
    return .{ code, folding };
}

/// Each code point of an orbit and its next one, in ascending order of the code point.
fn next_code_points(arena: std.mem.Allocator, folded: std.AutoArrayHashMapUnmanaged(u32, std.ArrayList(u32))) Error![][2]u32 {
    var next: std.ArrayList([2]u32) = .empty;
    for (folded.values()) |*members| {
        std.mem.sort(u32, members.items, {}, std.sort.asc(u32));
        for (members.items, 0..) |code, index| {
            try next.append(arena, .{ code, members.items[(index + 1) % members.items.len] });
        }
    }
    std.mem.sort([2]u32, next.items, {}, code_first);
    return next.items;
}

fn code_first(_: void, left: [2]u32, right: [2]u32) bool {
    return left[0] < right[0];
}

/// The runs of consecutive code points whose next ones add the same offset.
fn offset_runs(arena: std.mem.Allocator, next: []const [2]u32) Error![]Run {
    var found: std.ArrayList(Run) = .empty;
    for (next) |pair| {
        const offset: i32 = @intCast(@as(i64, pair[1]) - pair[0]);
        if (found.items.len > 0) {
            const last = &found.items[found.items.len - 1];
            if (last.hi + 1 == pair[0] and last.step.offset == offset) {
                last.hi = pair[0];
                continue;
            }
        }
        try found.append(arena, .{ .lo = pair[0], .hi = pair[0], .step = .{ .offset = offset } });
    }
    return found.items;
}

/// The runs, with each run of whole pairs, a code point that adds 1 beside one that adds -1, as one
/// run of pairs.
fn pair_runs(arena: std.mem.Allocator, offsets: []const Run) Error![]Run {
    var found: std.ArrayList(Run) = .empty;
    var index: usize = 0;
    while (index < offsets.len) {
        if (index + 1 < offsets.len and is_pair(offsets[index], offsets[index + 1])) {
            const lo = offsets[index].lo;
            const extends = found.items.len > 0 and found.items[found.items.len - 1].step == .pairs and
                found.items[found.items.len - 1].hi + 1 == lo;
            if (extends) found.items[found.items.len - 1].hi = lo + 1 else try found.append(arena, .{ .lo = lo, .hi = lo + 1, .step = .pairs });
            index += 2;
            continue;
        }
        try found.append(arena, offsets[index]);
        index += 1;
    }
    return found.items;
}

/// Whether two runs of one code point each are a pair: the first goes to the second, and back.
fn is_pair(first: Run, second: Run) bool {
    return first.lo == first.hi and second.lo == second.hi and second.lo == first.lo + 1 and
        first.step.offset == 1 and second.step.offset == -1;
}

// Tests.

const testing = std.testing;

const fixture =
    \\# CaseFolding-17.0.0.txt
    \\0041; C; 0061; # LATIN CAPITAL LETTER A
    \\0042; C; 0062; # LATIN CAPITAL LETTER B
    \\004B; C; 006B; # LATIN CAPITAL LETTER K
    \\00DF; F; 0073 0073; # LATIN SMALL LETTER SHARP S
    \\0100; C; 0101; # LATIN CAPITAL LETTER A WITH MACRON
    \\0102; C; 0103; # LATIN CAPITAL LETTER A WITH BREVE
    \\0130; T; 0069; # LATIN CAPITAL LETTER I WITH DOT ABOVE
    \\1E9E; F; 0073 0073; # LATIN CAPITAL LETTER SHARP S
    \\1E9E; S; 00DF; # LATIN CAPITAL LETTER SHARP S
    \\212A; C; 006B; # KELVIN SIGN
    \\
;

test "runs give each code point of an orbit the next one, in runs of offsets and of pairs" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const found = try runs(arena_state.allocator(), fixture);
    const expected = [_]Run{
        .{ .lo = 0x41, .hi = 0x42, .step = .{ .offset = 0x20 } },
        .{ .lo = 0x4B, .hi = 0x4B, .step = .{ .offset = 0x20 } },
        .{ .lo = 0x61, .hi = 0x62, .step = .{ .offset = -0x20 } },
        // The orbit of k holds K, k and the Kelvin sign: k goes to the Kelvin sign, which goes to K.
        .{ .lo = 0x6B, .hi = 0x6B, .step = .{ .offset = 0x212A - 0x6B } },
        // Status S maps the capital sharp s to the small one. F's lines are left out.
        .{ .lo = 0xDF, .hi = 0xDF, .step = .{ .offset = 0x1E9E - 0xDF } },
        .{ .lo = 0x100, .hi = 0x103, .step = .pairs },
        .{ .lo = 0x1E9E, .hi = 0x1E9E, .step = .{ .offset = 0xDF - 0x1E9E } },
        .{ .lo = 0x212A, .hi = 0x212A, .step = .{ .offset = 0x4B - 0x212A } },
    };
    try testing.expectEqualSlices(Run, &expected, found);
}

test "a run of pairs holds whole pairs alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    // 0x100 goes to 0x101 and back, but 0x102's orbit holds three code points: 0x102, 0x103, 0x104.
    const text = "0100; C; 0101;\n0102; C; 0104;\n0103; C; 0104;\n";
    const found = try runs(arena_state.allocator(), text);
    try testing.expectEqual(Step.pairs, found[0].step);
    try testing.expectEqual(@as(u32, 0x101), found[0].hi);
    try testing.expectEqual(Step{ .offset = 1 }, found[1].step);
    try testing.expectEqual(@as(u32, 0x103), found[1].hi);
    // 0x200 goes to 0x201, but 0x201 goes on to 0x300: the two are no pair.
    const apart = try runs(arena_state.allocator(), "0200; C; 0300;\n0201; C; 0300;\n");
    try testing.expectEqualSlices(Run, &.{
        .{ .lo = 0x200, .hi = 0x200, .step = .{ .offset = 1 } },
        .{ .lo = 0x201, .hi = 0x201, .step = .{ .offset = 0xFF } },
        .{ .lo = 0x300, .hi = 0x300, .step = .{ .offset = -0x100 } },
    }, apart);
}

test "runs refuse a folding that folds again, a code point that folds to itself, and a status of none" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    try testing.expectError(error.FoldingInvalid, runs(arena, "0041; C; 0061;\n0061; C; 0062;\n"));
    try testing.expectError(error.FoldingInvalid, runs(arena, "0041; C; 0041;\n"));
    try testing.expectError(error.LineInvalid, runs(arena, "0041; X; 0061;\n"));
    try testing.expectError(error.LineInvalid, runs(arena, "0041; C;\n"));
    try testing.expectError(error.LineInvalid, runs(arena, "0041; C; 0061; X\n"));
}
