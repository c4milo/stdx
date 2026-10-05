//! encoder_loop_plain.zig's copy against `scan.plain_len_scalar`, the reference (decision 16): a
//! string of every length past 16 with a stop at every place, and seeded strings, at every address
//! of the destination within a block and at every level of claim J7 this CPU runs. plain_copy.zig's
//! tests hold the blocks it hands a longer string to.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const plain_copy = @import("../../plain_copy.zig");
const copies = @import("../../plain_copy_test.zig");
const plain = @import("encoder_loop_plain.zig");

const Room = copies.Room;
const fill_plain = copies.fill_plain;
const draw = copies.draw;
const edges = copies.edges;
const plain_octets = copies.plain_octets;
const alignment = copies.alignment;
const string_len_max = copies.string_len_max;
const seeded_cases = copies.seeded_cases;

/// Copies `source` as the token loop does, at every level of claim J7 this CPU runs.
fn expect_copy(skew: usize, source: []const u8) !void {
    for (copies.levels_run()) |level| {
        var room: Room = .{};
        try room.expect(skew, source, plain.copy_plain(level, room.destination(skew, source.len), source));
    }
}

test "the loop's copy takes a string of every length past 16, with a stop at every place" {
    var source: [constants.wide_run_len_min + plain_copy.pass_blocks * constants.avx2_vector_len + constants.avx2_vector_len + 2]u8 = undefined;
    for (constants.vector_len + 1..source.len + 1) |len| {
        fill_plain(&source);
        try expect_copy(len % alignment, source[0..len]);
        for (0..len) |place| {
            source[place] = edges[place % edges.len];
            try expect_copy(place % alignment, source[0..len]);
            source[place] = plain_octets[0];
        }
    }
}

test "the loop's copy takes seeded strings as far as their plain ASCII runs" {
    var source: [string_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const len: usize = @intCast(generator.between(constants.vector_len + 1, string_len_max));
        draw(&generator, source[0..len], 0);
        try expect_copy(@intCast(generator.below(alignment)), source[0..len]);
    }
}
