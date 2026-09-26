//! Tests for the gzip decoder. Members are built here from a header with the optional fields FLG
//! names, DEFLATE blocks, and CRC32 and ISIZE (RFC 1952 §2.3). Each decodes in one call and under
//! seeded splits that move the state between calls (invariant 12), and each refusal names its RFC
//! rule.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const checksum = @import("checksum");
const deflate = @import("deflate");
const constants = @import("constants.zig");
const gzip = @import("decoder.zig");
const Decoder = gzip.Decoder;

/// The most octets a test decodes into.
const output_len_max = 1024;

/// The seeds each member decodes under.
const split_seeds = 200;

pub const Stream = deflate.TestStream;

/// The header's fields a member may carry, and whether FHCRC adds the CRC16.
pub const Member = struct {
    text: bool = false,
    extra: ?[]const u8 = null,
    name: ?[]const u8 = null,
    comment: ?[]const u8 = null,
    header_crc: bool = false,
};

/// MTIME, XFL and OS, which the decoder ignores (RFC 1952 §2.3.1.2).
const modification_time: u32 = 0x6512_3456;
const extra_flags: u8 = 2;
const operating_system: u8 = 3;

fn flags_of(member: Member) u8 {
    var flags: u8 = 0;
    if (member.text) flags |= 1;
    if (member.header_crc) flags |= constants.flag_header_crc;
    if (member.extra != null) flags |= constants.flag_extra;
    if (member.name != null) flags |= constants.flag_name;
    if (member.comment != null) flags |= constants.flag_comment;
    return flags;
}

/// A member's header: the fixed part, each optional field, and the CRC16 of all of them.
pub fn header(stream: *Stream, member: Member) void {
    stream.align_to_octet();
    const start = stream.slice().len;
    stream.append(&.{ constants.identification_1, constants.identification_2, constants.method_deflate, flags_of(member) });
    var time: [@sizeOf(u32)]u8 = undefined;
    std.mem.writeInt(u32, &time, modification_time, .little);
    stream.append(&time);
    stream.append(&.{ extra_flags, operating_system });
    if (member.extra) |extra| {
        var extra_len: [constants.extra_len_len]u8 = undefined;
        std.mem.writeInt(u16, &extra_len, @intCast(extra.len), .little);
        stream.append(&extra_len);
        stream.append(extra);
    }
    for ([_]?[]const u8{ member.name, member.comment }) |terminated| {
        if (terminated) |octets| {
            stream.append(octets);
            stream.append(&.{constants.field_terminator});
        }
    }
    if (member.header_crc) {
        var header_crc: [constants.header_crc_len]u8 = undefined;
        const crc = checksum.crc32(.table, constants.crc32_initial, stream.slice()[start..]);
        std.mem.writeInt(u16, &header_crc, @truncate(crc), .little);
        stream.append(&header_crc);
    }
}

/// CRC32 and ISIZE of `decoded`, least significant octet first (RFC 1952 §2.3), at the next octet.
pub fn trailer(stream: *Stream, decoded: []const u8) void {
    var octets: [constants.trailer_len]u8 = undefined;
    std.mem.writeInt(u32, octets[0..constants.trailer_crc32_len], checksum.crc32(.table, constants.crc32_initial, decoded), .little);
    std.mem.writeInt(u32, octets[constants.trailer_crc32_len..], @truncate(decoded.len), .little);
    stream.append(&octets);
}

/// A member of one stored block.
pub fn stored_member(stream: *Stream, member: Member, octets: []const u8) void {
    header(stream, member);
    stream.stored(true, octets);
    trailer(stream, octets);
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) gzip.Error!codec.Progress {
    return gzip.decode(decoder, input, output);
}

/// Decodes `input` in one call and under every seed, and requires `expected` and the member's end
/// at `member_len`.
fn expect_decodes(input: []const u8, member_len: usize, expected: []const u8) !void {
    var output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    gzip.init(&decoder, .{});
    const progress = try gzip.decode(&decoder, input, &output);
    try testing.expectEqual(codec.Status.done, progress.status);
    try testing.expectEqual(member_len, progress.consumed);
    try testing.expectEqualSlices(u8, expected, output[0..progress.written]);
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        gzip.init(&states[0], .{});
        const outcome = try codec.split.drive(Decoder, &states, step, input, output[0..expected.len], seed);
        try testing.expectEqual(codec.Status.done, outcome.status);
        try testing.expectEqual(member_len, outcome.consumed);
        try testing.expectEqualSlices(u8, expected, output[0..outcome.written]);
    }
}

/// Requires `input` refused with `expected` in one call and under every seed.
fn expect_refused(input: []const u8, expected: gzip.Error) !void {
    var output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    gzip.init(&decoder, .{});
    try testing.expectError(expected, gzip.decode(&decoder, input, &output));
    try testing.expectEqual(codec.Refusal.corrupt, gzip.refusal(expected));
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        gzip.init(&states[0], .{});
        try testing.expectError(expected, codec.split.drive(Decoder, &states, step, input, &output, seed));
    }
}

const text = "a gzip member around a stored block, a gzip member around a stored block";

test "decode_all decodes every member, and refuses what follows the last unless it starts one" {
    var stream: Stream = .{};
    stored_member(&stream, .{}, "first ");
    stored_member(&stream, .{ .name = "second" }, "second");
    const members_len = stream.slice().len;
    var output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    gzip.init(&decoder, .{});
    const whole = try gzip.decode_all(&decoder, stream.slice(), &output);
    try testing.expectEqual(codec.Whole{ .consumed = members_len, .written = 12 }, whole);
    try testing.expectEqualSlices(u8, "first second", output[0..whole.written]);
    // The second member cut short, and room for the first member alone.
    gzip.init(&decoder, .{});
    try testing.expectError(error.Truncated, gzip.decode_all(&decoder, stream.slice()[0 .. members_len - 1], &output));
    gzip.init(&decoder, .{});
    try testing.expectError(error.NoSpaceLeft, gzip.decode_all(&decoder, stream.slice(), output[0..8]));
    // RFC 1952 §2.3.1: a member starts with ID1 and ID2, so ten zero octets start none.
    stream.append(&(.{0} ** constants.fixed_header_len));
    gzip.init(&decoder, .{});
    try testing.expectError(error.InvalidIdentification, gzip.decode_all(&decoder, stream.slice(), &output));
    // Two of the shortest members: a fixed block holding end-of-block alone, and no octet decoded.
    stream = .{};
    for (0..2) |_| {
        header(&stream, .{});
        stream.block_header(true, .fixed);
        stream.fixed_literal(deflate.constants.end_of_block);
        stream.align_to_octet();
        trailer(&stream, "");
    }
    try testing.expectEqual(2 * constants.member_len_min, stream.slice().len);
    gzip.init(&decoder, .{});
    try testing.expectEqual(codec.Whole{ .consumed = stream.slice().len, .written = 0 }, try gzip.decode_all(&decoder, stream.slice(), &output));
    // ID1 alone may start a member, which then needs input.
    stream = .{};
    stored_member(&stream, .{}, "first ");
    stream.append(&.{constants.identification_1});
    gzip.init(&decoder, .{});
    try testing.expectError(error.Truncated, gzip.decode_all(&decoder, stream.slice(), &output));
}

/// The fields a member shape may hold, one bit of the shape's index each.
const Optional = enum { text, extra, name, comment, header_crc };

fn has(index: usize, field: Optional) bool {
    return (index >> @intFromEnum(field)) & 1 != 0;
}

/// Every member shape: each of FTEXT, FEXTRA, FNAME, FCOMMENT and FHCRC present or not.
fn every_shape(index: usize) Member {
    return .{
        .text = has(index, .text),
        .extra = if (has(index, .extra)) "AP\x04\x00data" else null,
        .name = if (has(index, .name)) "name.txt" else null,
        .comment = if (has(index, .comment)) "a comment" else null,
        .header_crc = has(index, .header_crc),
    };
}

test "a member decodes with every combination of optional fields, and stops at ISIZE's end" {
    for (0..32) |index| {
        var stream: Stream = .{};
        stored_member(&stream, every_shape(index), text);
        const member_len = stream.slice().len;
        try expect_decodes(stream.slice(), member_len, text);
        // Octets after the member stay in the input for the next member (RFC 1952 §2.2).
        stream.append("next");
        try expect_decodes(stream.slice(), member_len, text);
    }
}

test "empty optional fields and an empty member" {
    var stream: Stream = .{};
    stored_member(&stream, .{ .extra = "", .name = "", .comment = "", .header_crc = true }, "");
    try expect_decodes(stream.slice(), stream.slice().len, "");
}

test "members follow one another, each done at its end" {
    var stream: Stream = .{};
    stored_member(&stream, .{ .name = "first" }, "first member");
    const members_len = stream.slice().len;
    stored_member(&stream, .{ .header_crc = true }, "second member");
    const input = stream.slice();
    var output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    gzip.init(&decoder, .{});
    const first = try gzip.decode(&decoder, input, &output);
    try testing.expectEqual(codec.Status.done, first.status);
    try testing.expectEqual(members_len, first.consumed);
    gzip.init(&decoder, .{});
    const second = try gzip.decode(&decoder, input[first.consumed..], output[first.written..]);
    try testing.expectEqual(codec.Status.done, second.status);
    try testing.expectEqual(input.len, first.consumed + second.consumed);
    try testing.expectEqualStrings("first membersecond member", output[0 .. first.written + second.written]);
}

test "a cut member needs input, and is never done before its last octet" {
    var stream: Stream = .{};
    stored_member(&stream, every_shape(31), text);
    const whole = stream.slice();
    var output: [output_len_max]u8 = undefined;
    for (0..whole.len) |cut| {
        var decoder: Decoder = undefined;
        gzip.init(&decoder, .{});
        const progress = try gzip.decode(&decoder, whole[0..cut], &output);
        try testing.expectEqual(codec.Status.needs_input, progress.status);
        try testing.expectEqual(cut, progress.consumed);
    }
}

test "ID1, ID2 and CM are checked, as RFC 1952 section 2.3.1.2 requires" {
    const cases = [_]struct { usize, u8, gzip.Error }{
        .{ constants.identification_1_offset, 0x1e, error.InvalidIdentification },
        .{ constants.identification_2_offset, 0x8c, error.InvalidIdentification },
        .{ constants.method_offset, 7, error.InvalidMethod },
        .{ constants.method_offset, 9, error.InvalidMethod },
    };
    for (cases) |case| {
        var stream: Stream = .{};
        stored_member(&stream, .{}, text);
        stream.octets[case[0]] = case[1];
        try expect_refused(stream.slice(), case[2]);
    }
}

test "each reserved FLG bit is refused" {
    for (5..8) |bit| {
        var stream: Stream = .{};
        stored_member(&stream, .{}, text);
        stream.octets[constants.flags_offset] |= @as(u8, 1) << @intCast(bit);
        try expect_refused(stream.slice(), error.ReservedFlagSet);
    }
}

test "a CRC16 that does not match the header is refused, wherever the header differs" {
    var stream: Stream = .{};
    stored_member(&stream, .{ .extra = "XY\x00\x00", .name = "n", .comment = "c", .header_crc = true }, text);
    // MTIME, XFL, the extra field, FNAME, FCOMMENT and both octets of the CRC16 itself.
    for ([_]usize{ 4, 8, 14, 16, 18, 20, 21 }) |offset| {
        var corrupt = stream;
        corrupt.octets[offset] ^= 0x01;
        try expect_refused(corrupt.slice(), error.HeaderChecksumMismatch);
    }
}

test "a wrong CRC32 or ISIZE is refused, whichever octet differs" {
    var stream: Stream = .{};
    stored_member(&stream, .{}, text);
    const len = stream.slice().len;
    for (0..constants.trailer_len) |index| {
        var corrupt = stream;
        corrupt.octets[len - constants.trailer_len + index] ^= 0x40;
        const expected: gzip.Error = if (index < constants.trailer_crc32_len) error.ChecksumMismatch else error.SizeMismatch;
        try expect_refused(corrupt.slice(), expected);
    }
}

test "a wrong CRC32 is refused as soon as its four octets are in, before ISIZE" {
    var stream: Stream = .{};
    stored_member(&stream, .{}, text);
    const len = stream.slice().len;
    stream.octets[len - constants.trailer_len] ^= 0x01;
    const cut = stream.slice()[0 .. len - constants.trailer_len + constants.trailer_crc32_len];
    try expect_refused(cut, error.ChecksumMismatch);
    // With CRC32 right, the same cut needs ISIZE.
    var valid: Stream = .{};
    stored_member(&valid, .{}, text);
    var output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    gzip.init(&decoder, .{});
    const progress = try gzip.decode(&decoder, valid.slice()[0..cut.len], &output);
    try testing.expectEqual(codec.Status.needs_input, progress.status);
}

test "the DEFLATE stream's refusals pass through" {
    var stream: Stream = .{};
    header(&stream, .{});
    stream.block_header(true, .reserved);
    try expect_refused(stream.slice(), error.InvalidBlockType);
}

test {
    _ = @import("decoder_fuzz_test.zig");
}
