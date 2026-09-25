//! Tests for the rfc-citation rule: one fixture per shape its header names.

const std = @import("std");
const testing = std.testing;
const pepegrillo = @import("pepegrillo");
const harness = pepegrillo.lint.harness;
const rfc_citation = @import("rfc_citation.zig");

fn expect_findings(path: []const u8, source: [:0]const u8, expected: []const []const u8) !void {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try harness.run(arena_state.allocator(), rfc_citation, path, source);
    try harness.expect_messages(findings, expected);
}

fn message(comptime error_name: []const u8) []const u8 {
    return "error." ++ error_name ++ " has no RFC section comment on its check; cite the RFC and" ++
        " the section that require it (invariant 16)";
}

const uncited_fixture: [:0]const u8 =
    \\pub fn read_block_type(bits: u2) !BlockType {
    \\    if (bits == 3) return error.ReservedBlockType;
    \\}
;

test "rfc-citation passes a citation above, trailing, and above a multi-line statement" {
    try expect_findings("src/deflate/block.zig",
        \\pub fn check(header: Header, length: u64) !void {
        \\    // RFC 1951 §3.2.3: BTYPE 11 is reserved and is an error.
        \\    if (header.block_type == 3) return error.ReservedBlockType;
        \\    if (header.nlen != ~header.len) return error.StoredLength; // RFC 1951 §3.2.4: NLEN.
        \\    // RFC 7932 Appendix A: the dictionary's word count.
        \\    // A second line of the same comment.
        \\    const len = std.math.cast(usize, length) orelse
        \\        return error.WordTooLong;
        \\    if (header.cm != 8 or
        \\        header.cinfo > 7) // RFC 1950 §2.2: CM is 8 and CINFO at most 7.
        \\        return error.Method;
        \\    if (len == 4) {
        \\        return error.Four; // RFC 1952 §2.3.1.2
        \\    }
        \\    // RFC 8878 §3.1.1.1.1.4: the reserved bit must be zero.
        \\    if (check_reserved(
        \\        header,
        \\        len,
        \\    )) return error.ReservedBit;
        \\    _ = switch (header.flags) {
        \\        0 => 1,
        \\        // RFC 1952 §2.3.1.2: a reserved bit set.
        \\        1 => return error.ReservedFlag,
        \\        else => 2,
        \\    };
        \\}
    , &.{});
}

test "rfc-citation flags a branch with no comment" {
    try expect_findings("src/deflate/block.zig", uncited_fixture, &.{message("ReservedBlockType")});
}

test "rfc-citation flags an RFC named with no section, and a section with no RFC" {
    try expect_findings("src/gzip/header.zig",
        \\pub fn check(header: Header) !void {
        \\    // RFC 1952: the magic octets.
        \\    if (header.id1 != 0x1f) return error.Magic;
        \\    // §2.3.1 of the gzip document.
        \\    if (header.id2 != 0x8b) return error.MagicTwo;
        \\    // RFC 7932 Appendix for the dictionary.
        \\    if (header.cm != 8) return error.Method;
        \\    // RFC §2.3.1.2: reserved bits.
        \\    if (header.flags > 31) return error.Reserved;
        \\    // RFC 1952 §x: the flags.
        \\    if (header.flags == 1) return error.Text;
        \\}
    , &.{ message("Magic"), message("MagicTwo"), message("Method"), message("Reserved"), message("Text") });
}

test "rfc-citation flags a citation a blank line, a statement, a prong or an argument away" {
    try expect_findings("src/gzip/header.zig",
        \\pub fn check(header: Header) !void {
        \\    // RFC 1952 §2.3.1: the magic octets.
        \\
        \\    if (header.id1 != 0x1f) return error.Magic;
        \\    // RFC 1952 §2.3.1: the method.
        \\    const method = header.cm;
        \\    if (method != 8) return error.Method;
        \\    const text = "// RFC 1952 §2.3.1"; if (method == 9) return error.Quoted;
        \\    _ = switch (method) {
        \\        // RFC 1952 §2.3.1.2: reserved bits.
        \\        7 => 1,
        \\        6 => return error.Prong,
        \\        else => 2,
        \\    };
        \\    // RFC 1952 §2.3.1: above the call, not above the argument.
        \\    consume(
        \\        std.math.cast(usize, header.xlen) orelse return error.Argument,
        \\    );
        \\}
    , &.{
        message("Magic"),
        message("Method"),
        message("Quoted"),
        message("Prong"),
        message("Argument"),
    });
}

test "rfc-citation reads neither operational errors, test errors nor test blocks" {
    try expect_findings("src/codec/reader.zig",
        \\pub fn take(self: *Reader, len: usize) ![]const u8 {
        \\    if (len > self.remaining_len()) return error.Truncated;
        \\    if (len > self.buffer.len) return error.NoSpaceLeft;
        \\    return error.TestUnexpectedResult;
        \\}
        \\test "a refusal" {
        \\    return error.ReservedBlockType;
        \\}
    , &.{});
}

test "rfc-citation reads a limit reached as a check that needs its RFC" {
    try expect_findings("src/zstd/frame.zig",
        \\pub fn check(window_len: u64) !void {
        \\    if (window_len > constants.window_len_max) return error.WindowTooLarge;
        \\    if (window_len > self.buffer.len) return error.Full;
        \\}
    , &.{ message("WindowTooLarge"), message("Full") });
}

test "rfc-citation reads src/ and nothing outside it" {
    try expect_findings("src/zstd/frame.zig", uncited_fixture, &.{message("ReservedBlockType")});
    try expect_findings("tools/graph_check.zig", uncited_fixture, &.{});
    try expect_findings("build/modules.zig", uncited_fixture, &.{});
    try expect_findings("src/deflate/block.md", uncited_fixture, &.{});
}
