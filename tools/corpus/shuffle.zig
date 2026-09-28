//! corpus_shuffle: writes the first MiB of a corpus file with its octets in a seeded order, the
//! literal-heavy text of decision 25.
//!
//! A shuffle keeps the file's octet frequencies, so its literals keep Huffman codes of many
//! lengths, and it breaks the file's repeated strings, so few matches cover it: an encoder emits
//! most of it as literals. The order is a Fisher-Yates shuffle drawn by `codec.split.Generator`,
//! SplitMix64, from `seed`, so every host writes the same octets.
//!
//! Usage: `corpus_shuffle <output> <source>`
//!
//! Exit status 0 when the output is written, 1 when the source cannot be read or holds fewer than
//! `shuffled_len` octets, 2 on a usage error.

const std = @import("std");
const codec = @import("codec");

/// The octets taken from the start of the source: 1 MiB, the largest piece of decision 15.
pub const shuffled_len = 1 << 20;

/// The seed of the order: fixed, so the file is the same on every host and in every run.
pub const seed = 0;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// Puts `octets` in the order a Fisher-Yates shuffle draws from `seed`: from the last position down
/// to the first, each position takes the octet of a position drawn at or below it.
pub fn shuffle(octets: []u8) void {
    var generator = codec.split.Generator.init(seed);
    var remaining = octets.len;
    for (0..octets.len) |_| {
        const drawn: usize = @intCast(generator.below(remaining));
        remaining -= 1;
        std.mem.swap(u8, &octets[remaining], &octets[drawn]);
    }
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    if (args.len != 3) usage();
    const output = args[1];
    const source = args[2];

    const octets = try std.Io.Dir.cwd().readFileAlloc(io, source, arena, .unlimited);
    if (octets.len < shuffled_len) {
        std.debug.print("corpus_shuffle: {s} holds {d} octets, fewer than {d}\n", .{ source, octets.len, shuffled_len });
        std.process.exit(1);
    }
    const taken = octets[0..shuffled_len];
    shuffle(taken);
    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = output, .data = taken });
}

fn usage() noreturn {
    std.debug.print("usage: corpus_shuffle <output> <source>\n", .{});
    std.process.exit(usage_exit_status);
}

// Tests.

const testing = std.testing;

test "the shuffle keeps every octet once and moves them" {
    var octets: [256]u8 = undefined;
    for (&octets, 0..) |*octet, value| octet.* = @intCast(value);
    shuffle(&octets);
    var seen: [256]bool = @splat(false);
    var moved: usize = 0;
    for (octets, 0..) |octet, position| {
        try testing.expect(!seen[octet]);
        seen[octet] = true;
        if (octet != position) moved += 1;
    }
    try testing.expect(moved > octets.len / 2);
}

test "the order is pinned, so every host writes the same file" {
    var octets = "abcdefghijklmnopqrstuvwxyz".*;
    shuffle(&octets);
    try testing.expectEqualStrings("vmxjtsybprfinhluqeodgczakw", &octets);
}

test "an empty or one-octet input stays as it is" {
    var empty: [0]u8 = .{};
    shuffle(&empty);
    var one = "a".*;
    shuffle(&one);
    try testing.expectEqualStrings("a", &one);
}
