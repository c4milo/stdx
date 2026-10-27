//! The tests of the Literals_Section, each read back through the decoder's `literals.read`.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");
const literals_module = @import("../literals.zig");
const encoder_literals = @import("encoder_literals.zig");

/// State that outlives one test's stack frame: a block's literals and buffers are large.
threadlocal var scratch: encoder_literals.Scratch = undefined;
/// Room for a section of a block's literals: the raw ones and their header.
const section_len_max = constants.block_len_max + section_header_len_max;
const section_header_len_max = 5;

threadlocal var octets: [section_len_max]u8 = undefined;
threadlocal var decoded: [constants.block_len_max]u8 = undefined;
threadlocal var message: [constants.block_len_max]u8 = undefined;
threadlocal var table: huffman.Table = undefined;

/// Writes `literals` as a section and requires the decoder to read them back from it. Returns the
/// section's length.
fn expect_round_trip(literals: []const u8) !usize {
    var writer = codec.Writer.init(&octets);
    try encoder_literals.write_section(&writer, literals, &scratch);
    const section = writer.written();
    var table_valid = false;
    const read = try literals_module.read(section, constants.block_len_max, .{ .table = &table, .table_valid = &table_valid, .buffer = &decoded, .assembly = false });
    try testing.expectEqual(section.len, read.section_len);
    try testing.expectEqual(literals.len, read.len);
    switch (read.source) {
        .block => try testing.expectEqualSlices(u8, literals, section[read.offset..][0..read.len]),
        .repeated => for (literals) |literal| try testing.expectEqual(read.octet, literal),
        .buffer => try testing.expectEqualSlices(u8, literals, decoded[0..read.len]),
    }
    return section.len;
}

test "literals of every size and shape read back through the decoder" {
    var generator = codec.split.Generator.init(7);
    for (0..120) |_| {
        const len: usize = switch (generator.below(4)) {
            0 => generator.below(40),
            1 => generator.between(40, 2000),
            2 => generator.between(2000, 20_000),
            else => generator.between(20_000, constants.block_len_max),
        };
        const alphabet = generator.between(1, constants.literal_symbols);
        for (message[0..len]) |*literal| literal.* = @intCast(generator.below(generator.below(alphabet) + 1));
        // A section is never larger than its literals raw, with a raw header of at most 3 octets.
        try testing.expect(try expect_round_trip(message[0..len]) <= len + 3);
    }
}

test "text compresses, one octet repeated takes its header and one octet, and random octets go out raw" {
    const text = "the stream of a coded body is the octets of one coded message, and a window is history. ";
    var len: usize = 0;
    while (len + text.len <= 10_000) : (len += text.len) @memcpy(message[len..][0..text.len], text);
    try testing.expect(try expect_round_trip(message[0..len]) < len * 3 / 4);
    @memset(message[0..5000], 'x');
    try testing.expectEqual(4, try expect_round_trip(message[0..5000]));
    var generator = codec.split.Generator.init(8);
    for (message[0..5000]) |*literal| literal.* = @truncate(generator.next());
    try testing.expectEqual(5000 + 3, try expect_round_trip(message[0..5000]));
}
