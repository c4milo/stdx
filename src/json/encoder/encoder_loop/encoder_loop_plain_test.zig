//! encoder_loop_plain.zig's copies against `scan.plain_len_scalar`, the reference (decision 16):
//! every octet in each block of a pass, a stop at every place of strings of every length, and
//! seeded strings, at 16 octets a block, at 32 and at 64, at every address of the destination
//! within a block, and at every level of claim J7 this CPU runs, which on x86-64 calls the kernel
//! of the variant object (decision 30).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const scan = @import("../../scan.zig");
const wide = @import("../../wide.zig");
const plain = @import("encoder_loop_plain.zig");

/// The widths the copy runs at: the codecs' `vector_len`, SSE2's and NEON's, then AVX2's and
/// AVX-512's.
const width_256_bits = 32;
const width_512_bits = 64;
const widths = [_]usize{ constants.vector_len, width_256_bits, width_512_bits };

/// The longest string a case copies: at the widest width, the block before `from`, two passes, a
/// block and a few octets.
const string_len_max = 700;

/// The octets kept on each side of a destination, which no copy may write, and what they hold.
const guard_len = 64;
const guard_octet = 0xa5;

/// A destination's address is `skew` octets past a multiple of this, the widest block.
const alignment = 64;

/// The seeded cases each test draws.
const seeded_cases = 2000;

/// Plain ASCII, with the octets next to each stop among it: U+0020 and U+007F, the ends of what a
/// string carries as it is, and the neighbours of the quotation mark and of the reverse solidus.
const plain_octets = " !#$[]^~\x7fThe quick brown fox jumps over the lazy dog 0123456789";

/// Octets at the edges of what a string carries as it is (RFC 8259 §7): each stop and the octets
/// beside it.
const edges = [_]u8{ '\x00', '\x1f', ' ', '!', '"', '#', '[', '\\', ']', '\x7f', '\x80', '\xff' };

fn fill_plain(octets: []u8) void {
    for (octets, 0..) |*octet, index| octet.* = plain_octets[index % plain_octets.len];
}

/// A destination of `len` octets, `skew` octets past a multiple of `alignment`, with guards
/// around it.
const Room = struct {
    storage: [guard_len + alignment + string_len_max + guard_len]u8 align(alignment) = @splat(guard_octet),

    fn destination(self: *Room, skew: usize, len: usize) []u8 {
        return self.storage[guard_len + skew ..][0..len];
    }

    /// Requires `run_len` to be the run of plain ASCII that starts `source`, the destination to
    /// hold that run, and no octet outside the destination to be written.
    fn expect(self: *const Room, skew: usize, source: []const u8, run_len: usize) !void {
        try testing.expectEqual(scan.plain_len_scalar(source), run_len);
        try testing.expectEqualSlices(u8, source[0..run_len], self.storage[guard_len + skew ..][0..run_len]);
        try testing.expect(std.mem.allEqual(u8, self.storage[0 .. guard_len + skew], guard_octet));
        try testing.expect(std.mem.allEqual(u8, self.storage[guard_len + skew + source.len ..], guard_octet));
    }
};

/// Copies `source`, whose first `from` octets are plain ASCII, at `width`, as a caller that
/// copied those octets does.
fn expect_vector(comptime width: usize, from: usize, skew: usize, source: []const u8) !void {
    var room: Room = .{};
    const destination = room.destination(skew, source.len);
    @memcpy(destination[0..from], source[0..from]);
    try room.expect(skew, source, plain.copy_plain_vector(width, from, destination, source));
}

/// Copies `source` as the token loop does, at every level of claim J7 this CPU runs.
fn expect_copy(skew: usize, source: []const u8) !void {
    const levels = comptime std.enums.values(wide.Level);
    for (levels[0 .. @intFromEnum(wide.Level.of(codec.Features.detect())) + 1]) |level| {
        var room: Room = .{};
        try room.expect(skew, source, plain.copy_plain(level, room.destination(skew, source.len), source));
    }
}

/// The octets a string of `pass_string_len` holds past its whole blocks, which the last block
/// takes.
const tail_len = 3;

/// A string of the block before `from`, one pass, one block more and `tail_len` octets.
fn pass_string_len(comptime width: usize) usize {
    return width + plain.pass_blocks * width + width + tail_len;
}

test "the blocks start at the last octet up to `from` whose address is a multiple of the width" {
    inline for (widths) |width| {
        for (0..3 * width) |address| {
            for (width..3 * width) |from| {
                const start = plain.blocks_start(width, address, from);
                try testing.expect(start <= from and from - start < width);
                try testing.expectEqual(0, (address + start) % width);
            }
        }
    }
}

test "an octet at the edges of plain ASCII stops the copy at every place of a pass, or is copied" {
    inline for (widths) |width| {
        var source: [pass_string_len(width)]u8 = undefined;
        for ([_]usize{ 0, 5 }) |skew| {
            for (width..source.len) |place| {
                for (edges) |edge| {
                    fill_plain(&source);
                    source[place] = edge;
                    try expect_vector(width, width, skew, &source);
                }
            }
        }
    }
}

test "every octet, in each block of a pass and in the blocks after it, stops the copy or is copied" {
    inline for (widths) |width| {
        var source: [pass_string_len(width)]u8 = undefined;
        // A lane of each of the pass's four blocks, of the block after it, and the last octet.
        var places: [plain.pass_blocks + 2]usize = undefined;
        for (places[0 .. plain.pass_blocks + 1], 0..) |*place, block| place.* = width + block * width + block;
        places[plain.pass_blocks + 1] = source.len - 1;
        for (places) |place| {
            for (0..std.math.maxInt(u8) + 1) |octet| {
                fill_plain(&source);
                source[place] = @intCast(octet);
                try expect_vector(width, width, 0, &source);
            }
        }
    }
}

test "a copy returns the first of two stops, at every length and from every octet it may start at" {
    inline for (widths) |width| {
        var source: [width + 2 * plain.pass_blocks * width + width + 1]u8 = undefined;
        for (width..source.len + 1) |len| {
            var generator = codec.split.Generator.init(len);
            fill_plain(&source);
            const skew: usize = @intCast(generator.below(alignment));
            for ([_]usize{ width, @min(len, width + 1), @min(len, 2 * width), len }) |from| {
                try expect_vector(width, from, skew, source[0..len]);
            }
            if (len == width) continue;
            const first: usize = @intCast(generator.between(width, len - 1));
            const second: usize = @intCast(generator.between(first, len - 1));
            source[second] = constants.reverse_solidus;
            source[first] = constants.quotation_mark;
            try expect_vector(width, width, skew, source[0..len]);
            source[first] = plain_octets[0];
            source[len - 1] = constants.horizontal_tab;
            try expect_vector(width, width, skew, source[0..len]);
        }
    }
}

test "a copy stores at every address of the destination within a block" {
    inline for (widths) |width| {
        var source: [pass_string_len(width) + width]u8 = undefined;
        for (0..alignment) |skew| {
            fill_plain(&source);
            try expect_vector(width, width, skew, &source);
            try expect_vector(width, 2 * width, skew, &source);
            source[source.len - width - 1] = constants.line_feed;
            try expect_vector(width, width, skew, &source);
        }
    }
}

/// Draws a string of plain ASCII with a few octets drawn from all 256 among it, past its first
/// `plain_len` octets.
fn draw(generator: *codec.split.Generator, octets: []u8, plain_len: usize) void {
    fill_plain(octets);
    for (0..generator.below(drawn_octets_max + 1)) |_| {
        if (octets.len == plain_len) return;
        const place: usize = @intCast(generator.between(plain_len, octets.len - 1));
        octets[place] = @intCast(generator.below(std.math.maxInt(u8) + 1));
    }
}

/// The most octets `draw` draws from all 256 into a string.
const drawn_octets_max = 3;

test "seeded strings copy as far as their plain ASCII runs, at every width" {
    var source: [string_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        inline for (widths) |width| {
            const len: usize = @intCast(generator.between(width, string_len_max));
            const from: usize = @intCast(generator.between(width, @min(len, 2 * width)));
            draw(&generator, source[0..len], from);
            try expect_vector(width, from, @intCast(generator.below(alignment)), source[0..len]);
        }
    }
}

test "the loop's copy takes a string of every length past 16, with a stop at every place" {
    var source: [constants.wide_run_len_min + plain.pass_blocks * constants.avx2_vector_len + constants.avx2_vector_len + 2]u8 = undefined;
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
