//! Tests for the input-index rule: one fixture per shape its header names.

const std = @import("std");
const testing = std.testing;
const pepegrillo = @import("pepegrillo");
const harness = pepegrillo.lint.harness;
const input_index = @import("input_index.zig");

fn expect_findings(path: []const u8, source: [:0]const u8, expected: []const []const u8) !void {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try harness.run(arena_state.allocator(), input_index, path, source);
    try harness.expect_messages(findings, expected);
}

fn message(comptime read: []const u8) []const u8 {
    return "index reads " ++ read ++ ", which a reader of the input produced; take the octets" ++
        " through codec.Reader, which checks the bound (decision 16)";
}

/// A stored block's LEN (RFC 1951 §3.2.4), read and then used as a slice end with no check.
const length_fixture: [:0]const u8 =
    \\pub fn copy_stored(reader: *Reader, window: []u8) !void {
    \\    const len = try reader.read_int(u16, .little);
    \\    _ = window[0..len];
    \\}
;

test "input-index passes literal indexes, lengths, and values no reader produced" {
    try expect_findings("src/deflate/stored.zig",
        \\pub fn copy_stored(reader: *codec.Reader, output: *Writer, window: []u8) !void {
        \\    const octets = try reader.take(4);
        \\    var value: u32 = octets[0];
        \\    for (octets[1..]) |octet| value = (value << 8) | octet;
        \\    _ = window[0..octets.len];
        \\    const written = output.written();
        \\    _ = window[written.len - 1];
        \\    for (window, 0..) |_, index| _ = window[index];
        \\    _ = window[Writer.init(window).position];
        \\}
        \\pub fn fill(window: []u8, len: usize) void {
        \\    _ = window[0..len];
        \\}
        \\test "a test slices as it likes" {
        \\    var reader = Reader.init(&octets);
        \\    const len = try reader.read_octet();
        \\    _ = octets[0..len];
        \\}
    , &.{});
}

test "input-index flags a length a Reader parameter produced, at a slice end" {
    try expect_findings("src/deflate/stored.zig", length_fixture, &.{message("len")});
}

test "input-index flags an index, a slice start and a sentinel from a BitReader" {
    try expect_findings("src/deflate/huffman.zig",
        \\pub fn decode(bits: *BitReader, table: [:0]u16) !u16 {
        \\    const code = bits.peek(9);
        \\    _ = table[code];
        \\    _ = table[code..];
        \\    _ = table[0..1 :code];
        \\    return 0;
        \\}
    , &.{ message("code"), message("code"), message("code") });
}

test "input-index follows a local reader, an assignment and each kind of capture" {
    try expect_findings("src/gzip/header.zig",
        \\pub fn parse(input: []const u8, table: []const u8) !void {
        \\    var reader = Reader.init(input);
        \\    var total: usize = 0;
        \\    total += try reader.read_octet();
        \\    _ = table[total];
        \\    var bits: codec.BitReader = undefined;
        \\    const octets = try reader.take(2);
        \\    for (octets, 0..) |octet, index| _ = table[index..octet];
        \\    for (octets) |*slot| _ = table[slot.*];
        \\    for (table, octets) |_, second| _ = table[second];
        \\    if (bits.read(4)) |value| _ = table[value];
        \\    while (bits.read(1)) |*bit| _ = table[bit.*];
        \\    _ = table[Reader.init(input).position];
        \\    _ = table[BitReader.init(input, .{}).consumed()];
        \\}
    , &.{
        message("total"),
        message("octet"),
        message("slot"),
        message("second"),
        message("value"),
        message("bit"),
        message("Reader.init"),
        message("BitReader.init"),
    });
}

test "input-index reads each function, a nested one too, with only its own names" {
    try expect_findings("src/deflate/stored.zig",
        \\pub fn parse(reader: *Reader, table: []u8) !u16 {
        \\    const len = try reader.read_int(u16, .little);
        \\    const Local = struct {
        \\        fn fill(window: []u8, len: usize) void {
        \\            _ = window[0..len];
        \\        }
        \\    };
        \\    _ = Local;
        \\    _ = table[len];
        \\    return len;
        \\}
        \\pub fn fill(window: []u8, len: usize) void {
        \\    _ = window[0..len];
        \\}
    , &.{message("len")});
}

test "input-index reads src/ but not the reader, the bit reader, the writer or the tools" {
    try expect_findings("src/zstd/frame.zig", length_fixture, &.{message("len")});
    try expect_findings("src/codec/split.zig", length_fixture, &.{message("len")});
    try expect_findings("src/codec/reader.zig", length_fixture, &.{});
    try expect_findings("src/codec/bit_reader.zig", length_fixture, &.{});
    try expect_findings("src/codec/writer.zig", length_fixture, &.{});
    try expect_findings("tools/oracle/selftest.zig", length_fixture, &.{});
    try expect_findings("build/modules.zig", length_fixture, &.{});
}
