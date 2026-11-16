//! Level 5's short distance codes of 4 to 15 (RFC 7932 §4; the owner's ruling of 2026-11-07,
//! decision 66, output size): a distance within 3 of the last distance or the one before takes a
//! short code, with no extra bits. Such codes widen the distance code's alphabet, and a small
//! meta-block pays for that in its code's description. So a meta-block keeps them only where its
//! distance code then takes fewer bits. Otherwise each such command takes back its code with
//! extra bits, which `note` kept in the command's record.
//!
//! The ring of last distances moves the same way under both codes: every code but 0 pushes the
//! distance (RFC 7932 §4). So the choice at the meta-block's end changes no later command.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const encoder_prefix = @import("../encoder_prefix.zig");
const encoder_commands = @import("../encoder_commands.zig");

const alphabet_len = constants.encoder_distance_alphabet_len;
/// The short codes 0 to 3 name the ring's distances as they are; 4 to 15 add a delta.
const near_first = constants.last_distances_count;
const near_end = constants.distance_short_codes_count;
const fallback_shift = constants.encoder_level5.near_fallback_shift;
pub const DistanceCode = encoder_prefix.Code(alphabet_len);

/// The largest delta a short code adds to a last distance (RFC 7932 §4).
const delta_max = delta: {
    var most: usize = 0;
    for (constants.distance_short_codes) |short| most = @max(most, @as(usize, @abs(short.delta)));
    break :delta most;
};

/// The last distances the codes of 4 to 15 start from: the last and the one before.
const near_lasts = lasts: {
    var count: usize = 0;
    for (constants.distance_short_codes[near_first..]) |short| count = @max(count, @as(usize, short.last) + 1);
    break :lasts count;
};

/// The code of 4 to 15 by the last distance it starts from and by its delta plus `delta_max`
/// (RFC 7932 §4). The slot of delta 0 holds 0: codes 0 and 1 name those distances.
const by_delta = table: {
    var table: [near_lasts][2 * delta_max + 1]u6 = @splat(@splat(0));
    for (constants.distance_short_codes[near_first..], near_first..) |short, code| {
        table[short.last][@intCast(@as(i64, short.delta) + delta_max)] = code;
    }
    break :table table;
};

comptime {
    // The fallback's code fits above the extra bits, and both fit the record's 32 bits.
    assert(alphabet_len <= 1 << (@bitSizeOf(u32) - fallback_shift));
    assert(constants.encoder_level5.window_bits - 1 <= fallback_shift);
}

/// The code of 4 to 15 that names `distance`, the last distance or the one before less or plus 1
/// to 3 (RFC 7932 §4), else null. The caller tried codes 0 to 3 first, so neither last distance is
/// `distance` itself.
pub inline fn code_of(ring: *const [constants.last_distances_count]u32, distance: u32) ?u6 {
    inline for (0..near_lasts) |last| {
        // One compare for both signs: distance - last + delta_max lies in 0 to 2 * delta_max.
        const slot = distance +% delta_max -% ring[last];
        if (slot <= 2 * delta_max) {
            assert(slot != delta_max);
            return by_delta[last][slot];
        }
    }
    return null;
}

/// A meta-block's commands at codes of 4 to 15: the counts of the codes with extra bits they take
/// otherwise, the sum of those codes' extra bits, and how many there are.
pub const Tally = struct {
    counts: [alphabet_len]u16,
    extra_bits: u32,
    total: u32,

    pub fn reset(self: *Tally) void {
        self.counts = @splat(0);
        self.extra_bits = 0;
        self.total = 0;
    }

    /// Notes a command at a code of 4 to 15 whose distance takes `fallback` otherwise. Returns what
    /// its record keeps in its extra bits until the meta-block's end: the fallback's code above
    /// its extra bits.
    pub inline fn note(self: *Tally, comptime safety: bool, fallback_code: u6, fallback_extra: u32, fallback_extra_bits: u5) u32 {
        @setRuntimeSafety(safety);
        assert(fallback_code >= near_end and fallback_extra < @as(u32, 1) << fallback_shift);
        // Decision 17: a meta-block holds at most `encoder_commands_max` commands, which fit a
        // count's 16 bits, and each adds 24 extra bits at most to the sum's 32.
        self.counts[fallback_code] +%= 1;
        self.extra_bits +%= fallback_extra_bits;
        self.total +%= 1;
        return @as(u32, fallback_code) << fallback_shift | fallback_extra;
    }
};

/// Keeps the codes of 4 to 15 where `code`, the distance code built from `with`, takes fewer bits
/// with them than a code without them takes with the fallbacks' extra bits. Otherwise it rebuilds
/// `code` without them and gives each such command its fallback. Either way, no record keeps a
/// fallback after it.
pub fn choose(commands: anytype, with: *const [alphabet_len]u16, code: *DistanceCode) void {
    const tally = &commands.near;
    if (tally.total == 0) return;
    var without = with.*;
    @memset(without[near_first..near_end], 0);
    for (&without, tally.counts) |*count, fallback| count.* += fallback;
    var other: DistanceCode = undefined;
    encoder_prefix.build(alphabet_len, &without, &other);
    const keep = bits_of(with, code) <= bits_of(&without, &other) + tally.extra_bits;
    if (!keep) code.* = other;
    for (commands.commands[0..commands.count]) |*command| {
        const short = command.distance_code();
        if (short < near_first or short >= near_end) continue;
        if (keep) {
            command.distance_extra = 0;
            continue;
        }
        const fallback: u16 = @intCast(command.distance_extra >> fallback_shift);
        command.symbol_and_code = @as(u16, command.symbol()) | fallback << encoder_commands.symbol_bits;
        command.distance_extra &= (@as(u32, 1) << fallback_shift) - 1;
    }
}

/// The bits the distance code `code` takes for `counts`: its description and its symbols.
fn bits_of(counts: *const [alphabet_len]u16, code: *const DistanceCode) u64 {
    var bits: u64 = encoder_prefix.description_bits(alphabet_len, code, constants.encoder_distance_alphabet_bits);
    for (counts, code.lengths) |count, len| bits += @as(u64, count) * len;
    return bits;
}

const testing = std.testing;

test "a distance within 3 of the last or the one before takes its code of 4 to 15" {
    // RFC 7932 §4: from the last distance 100, 99 is code 4, 101 code 5, 97 code 8 and 103 code
    // 9; from the one before, 50, 49 is code 10 and 53 code 15.
    const ring = [_]u32{ 100, 50, 7, 9 };
    const cases = [_][2]u32{ .{ 99, 4 }, .{ 101, 5 }, .{ 98, 6 }, .{ 102, 7 }, .{ 97, 8 }, .{ 103, 9 }, .{ 49, 10 }, .{ 51, 11 }, .{ 48, 12 }, .{ 52, 13 }, .{ 47, 14 }, .{ 53, 15 } };
    for (cases) |case| try testing.expectEqual(@as(?u6, @intCast(case[1])), code_of(&ring, case[0]));
    // Past 3 from both, and the ring's third and fourth: no code of 4 to 15 names them.
    for ([_]u32{ 96, 104, 46, 54, 7, 9, 1 << 20 }) |distance| try testing.expectEqual(null, code_of(&ring, distance));
}

test "each code of 4 to 15 names the distance RFC 7932 gives it" {
    const ring = [_]u32{ 1000, 40, 7, 9 };
    for (constants.distance_short_codes[near_first..], near_first..) |short, code| {
        const distance: u32 = @intCast(@as(i64, ring[short.last]) + short.delta);
        try testing.expectEqual(@as(?u6, @intCast(code)), code_of(&ring, distance));
    }
}

test "a meta-block keeps its codes of 4 to 15 where its distance code then takes fewer bits" {
    try @call(.never_inline, expect_choice, .{ far_extra_bits, true });
}

test "a meta-block gives its commands back their codes with extra bits where those take fewer bits" {
    try @call(.never_inline, expect_choice, .{ near_extra_bits, false });
}

/// Ten commands at one code with extra bits, and one at code 5 whose distance takes that code too,
/// with `extra_bits` extra bits. Without code 5 the distance code has one symbol fewer to describe
/// and one bit more for the code it shares, which 3 extra bits outweigh and 15 do not.
fn expect_choice(extra_bits: u5, keep: bool) !void {
    var commands: encoder_commands.WideCommands = undefined;
    commands.init();
    const shared_code: u6 = @intCast(near_end + 2 * (@as(usize, extra_bits) - 1));
    for (0..shared_count) |index| {
        commands.commands[index] = .{ .insert_len = 0, .copy_len = 4, .symbol_and_code = explicit_symbol | @as(u16, shared_code) << encoder_commands.symbol_bits, .distance_extra = 0 };
    }
    commands.distance_counts[shared_code] = shared_count;
    const kept = commands.near.note(true, shared_code, near_extra, extra_bits);
    commands.commands[shared_count] = .{ .insert_len = 0, .copy_len = 4, .symbol_and_code = explicit_symbol | @as(u16, near_code) << encoder_commands.symbol_bits, .distance_extra = kept };
    commands.distance_counts[near_code] = 1;
    commands.count = shared_count + 1;
    var with = commands.distance_counts;
    with[0] += 1;
    var code: DistanceCode = undefined;
    encoder_prefix.build(alphabet_len, &with, &code);
    choose(&commands, &with, &code);
    const command = commands.commands[shared_count];
    try testing.expectEqual(explicit_symbol, command.symbol());
    if (keep) {
        try testing.expectEqual(near_code, command.distance_code());
        try testing.expectEqual(0, command.distance_extra);
        try testing.expect(code.lengths[near_code] > 0);
    } else {
        try testing.expectEqual(shared_code, command.distance_code());
        try testing.expectEqual(near_extra, command.distance_extra);
        try testing.expectEqual(0, code.lengths[near_code]);
    }
    // The other commands keep their codes and extra bits.
    for (commands.commands[0..shared_count]) |other| {
        try testing.expectEqual(shared_code, other.distance_code());
        try testing.expectEqual(0, other.distance_extra);
    }
}

const shared_count = 10;
const near_code = 5;
const near_extra = 1;
const far_extra_bits = 15;
const near_extra_bits = 3;
/// An insert-and-copy symbol whose distance goes out (RFC 7932 §5).
const explicit_symbol = constants.insert_copy_last_distance_symbols;
