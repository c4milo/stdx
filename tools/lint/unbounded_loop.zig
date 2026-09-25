//! unbounded-loop: every loop over input-derived counts is bounded by a named limit (CLAUDE.md,
//! Non-negotiables; invariant 9). A decoder reads hostile input, so a loop whose trip count the
//! input chooses must stop at a limit stdx named, and a call's work stays bounded.
//!
//! Over every `.zig` file under `src/`, the rule reports two shapes:
//!   1. `while (true)`. With no `break` anywhere in the body, nothing ends the loop at all. With a
//!      `break` but no named limit anywhere in the loop, the input decides how many iterations run
//!      before the break fires.
//!   2. a condition that compares a length read against an integer literal, with no named limit
//!      anywhere in the loop: `while (reader.remaining() > 0)`, `while (chunk.len != 0)`. A length
//!      read is a call or a field whose last name is one of `length_reader_names`.
//!
//! A named limit is a chain holding the segment `constants` or ending in `_max`, read from a
//! `constants.zig` value and never from a literal. Finding one anywhere in the loop's condition,
//! continue expression or body is what clears the loop.
//!
//! What the rule cannot do. It reads the shape of the source, not its arithmetic, so it cannot
//! prove that a named limit it found is the thing bounding the trip count. It does not follow a
//! bound through a local. It says nothing about `for` loops, which iterate a slice whose length
//! is already fixed, and nothing about a `while` whose condition is any other expression:
//! `while (index < count)` and `while (iterator.next()) |item|` are outside both checks. A loop it
//! passes is therefore not proved bounded; invariant 17's worst-case check is what measures the
//! work, and this rule catches the two shapes that are unbounded on their face.
//!
//! The rule is pepegrillo's `unbounded_loop` (decision 7). This file holds stdx's configuration of
//! it and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const unbounded_loop = lint.rules.unbounded_loop;

/// The last name of a length read. A call or a field with one of these names, compared against an
/// integer literal, is the shape of check 2.
const length_reader_names = [_][]const u8{
    "remaining",
    "len",
    "size",
    "count",
    "bytes_remaining",
    "bytes_left",
};

/// The configuration. It reads `src/`. A chain holding the segment `constants` names a limit from
/// a module's `constants.zig`, and a chain whose last segment ends with `_max` names a limit:
/// `window_len_max`, `block_len_max`. pepegrillo numbers the length-read check 3; the header above
/// calls it check 2.
pub const config: unbounded_loop.Config = .{
    .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{"src"} },
    .forever = .unless_bounded_break,
    .length_read = true,
    .bound = .{ .segments = &.{"constants"}, .last_segment_suffixes = &.{"_max"} },
    .length_reader_names = &length_reader_names,
    .messages = .{
        .forever_without_break = "while (true) has no break; nothing ends the loop (invariant 9)",
        .forever_without_bound = "while (true) breaks on no named limit;" ++
            " bound it with a constants.zig value (invariant 9)",
        .length_read = "the condition reads {[read]s} against a literal" ++
            " and the loop names no limit (invariant 9)",
    },
};

const Rule = unbounded_loop.Rule(config);
pub const name = Rule.name;
pub const check = Rule.check;

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

fn findings_of(
    arena: std.mem.Allocator,
    path: []const u8,
    source: [:0]const u8,
) ![]const lint.report.Finding {
    return harness.run(arena, Rule, path, source);
}

const passing_fixture: [:0]const u8 =
    \\const constants = @import("constants.zig");
    \\
    \\/// RFC 1952 §2.3.1: the extra field's subfields, capped by the named limit.
    \\pub fn skip_subfields(self: *Header, reader: *Reader) !void {
    \\    var read: u32 = 0;
    \\    while (reader.remaining() > 0) {
    \\        if (read == constants.subfield_count_max) return error.TooManySubfields;
    \\        try self.skip(try reader.read_subfield());
    \\        read += 1;
    \\    }
    \\}
    \\
    \\pub fn drain(self: *Decoder) void {
    \\    var index: u32 = 0;
    \\    while (true) {
    \\        if (index == constants.pending_len_max) break;
    \\        self.pending[index] = 0;
    \\        index += 1;
    \\    }
    \\}
;

const failing_fixture: [:0]const u8 =
    \\pub fn skip_subfields(self: *Header, reader: *Reader) !void {
    \\    while (reader.remaining() > 0) {
    \\        try self.skip(try reader.read_subfield());
    \\    }
    \\}
    \\
    \\pub fn spin(self: *Decoder) void {
    \\    while (true) {
    \\        self.step();
    \\    }
    \\}
;

test "unbounded-loop passes loops a named limit bounds" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/gzip/header.zig", passing_fixture);
    try harness.expect_messages(findings, &.{});
}

test "unbounded-loop flags an input length read and a while (true) with no break" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/gzip/header.zig", failing_fixture);
    try harness.expect_messages(findings, &.{
        "the condition reads reader.remaining against a literal and the loop names no limit (invariant 9)",
        "while (true) has no break; nothing ends the loop (invariant 9)",
    });
    try testing.expectEqual(2, findings[0].line);
    try testing.expectEqual(8, findings[1].line);
}

test "unbounded-loop flags a while (true) whose break rests on no named limit" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zstd/frame.zig",
        \\pub fn skip(self: *Decoder, reader: *Reader) void {
        \\    while (true) {
        \\        const frame = reader.next() orelse break;
        \\        self.skip_frame(frame);
        \\    }
        \\}
    );
    try harness.expect_messages(findings, &.{
        "while (true) breaks on no named limit; bound it with a constants.zig value (invariant 9)",
    });
}

test "unbounded-loop flags a length field compared to a literal" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/brotli/meta_block.zig",
        \\pub fn decode(self: *Decoder, chunk: []const u8) void {
        \\    while (chunk.len != 0) {
        \\        chunk = self.command(chunk);
        \\    }
        \\    while (0 < self.trees.count()) {
        \\        self.release();
        \\    }
        \\}
    );
    try harness.expect_messages(findings, &.{
        "the condition reads chunk.len against a literal and the loop names no limit (invariant 9)",
        "the condition reads self.trees.count against a literal and the loop names no limit (invariant 9)",
    });
}

test "unbounded-loop leaves every other condition alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/codec/codec.zig",
        \\pub fn scan(iterator: anytype, count: u32, done: bool) void {
        \\    var index: u32 = 0;
        \\    while (index < count) : (index += 1) {}
        \\    while (iterator.next()) |item| _ = item;
        \\    while (!done) {}
        \\    while (false) {}
        \\    for (0..count) |i| _ = i;
        \\    while (index < buffer.len) : (index += 1) {}
        \\}
    );
    try harness.expect_messages(findings, &.{});
}

test "unbounded-loop accepts a constants.zig value whose name does not end in _max" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/deflate.zig",
        \\pub fn fill(self: *Decoder, reader: *Reader) void {
        \\    while (true) {
        \\        if (self.depth == constants.table_bits) break;
        \\        self.step();
        \\    }
        \\}
    );
    try harness.expect_messages(findings, &.{});
}

test "unbounded-loop accepts a _max name reached without the constants root" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/deflate.zig",
        \\pub fn drain(self: *Decoder, reader: *Reader) void {
        \\    var read: u32 = 0;
        \\    while (reader.remaining() > 0) : (read = @min(read + 1, symbols_max)) {
        \\        self.step();
        \\    }
        \\}
    );
    try harness.expect_messages(findings, &.{});
}

test "unbounded-loop reads src/ alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    try testing.expect(config.scope.applies("src/deflate/deflate.zig"));
    try testing.expect(!config.scope.applies("tools/lint/main.zig"));
    try testing.expect(!config.scope.applies("build/modules.zig"));
    try harness.expect_messages(try findings_of(arena, "tools/lint/main.zig", failing_fixture), &.{});
}

test "unbounded-loop reads every length reader name on its list" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/gzip/header.zig",
        \\pub fn drain(self: *Header, reader: *Reader, chunk: []const u8) void {
        \\    while (reader.remaining() > 0) self.step();
        \\    while (chunk.len != 0) self.step();
        \\    while (reader.size() > 0) self.step();
        \\    while (self.entries.count() > 0) self.step();
        \\    while (reader.bytes_remaining > 0) self.step();
        \\    while (reader.bytes_left() != 0) self.step();
        \\    while (reader.total() != 0) self.step();
        \\}
    );
    const suffix = " against a literal and the loop names no limit (invariant 9)";
    try harness.expect_messages(findings, &.{
        "the condition reads reader.remaining" ++ suffix,
        "the condition reads chunk.len" ++ suffix,
        "the condition reads reader.size" ++ suffix,
        "the condition reads self.entries.count" ++ suffix,
        "the condition reads reader.bytes_remaining" ++ suffix,
        "the condition reads reader.bytes_left" ++ suffix,
    });
}
