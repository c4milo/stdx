//! A meta-block's commands (RFC 7932 §9.3), as codec's match finder finds them (decision 62): each
//! command inserts literals and copies a match. The meta-block counts each symbol as a command
//! arrives, for its prefix codes, and the writer works out the symbols again as it puts them.
//!
//! A command's distance goes out as a short code where one of the four last distances names it
//! (RFC 7932 §4), the last as code 0, and otherwise as a code of 16 or more with extra bits, with
//! NPOSTFIX and NDIRECT 0. Code 0 leaves the ring of last distances as it was; every other code
//! pushes its distance. The insert length code, the copy length code and code 0 together pick the
//! insert-and-copy symbol: one of 0 to 127 leaves the distance out of the stream (RFC 7932 §5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// A command as the meta-block holds it, in 8 octets (decision 12's budget): its lengths, its
/// distance, and the distance's code. The writer works out the symbols and extra bits again.
pub const Command = packed struct(u64) {
    insert_len: u16,
    copy_len: u16,
    /// The distance, which a window of 2^24 octets or less holds in 24 bits (RFC 7932 §9.1).
    distance: u24,
    /// The distance's code: a short code below 16, else a code with extra bits (RFC 7932 §4).
    distance_code: u8,
};

/// A command's symbols and extra bits, as the writer puts them.
pub const Coded = struct {
    /// The insert-and-copy symbol, and the insert and copy lengths' extra bits.
    symbol: u16,
    insert_extra: u32,
    insert_extra_bits: u5,
    copy_extra: u32,
    copy_extra_bits: u5,
    /// The distance's extra bits; none for a short code.
    distance_extra: u32,
    distance_extra_bits: u5,
};

/// A meta-block's commands, its symbols' counts, and the ring of last distances, which lives for
/// the stream (RFC 7932 §4). The literals stay in the window, where the writer reads them.
pub const Commands = struct {
    commands: [constants.encoder_commands_max]Command,
    count: usize,
    literal_counts: [constants.literal_alphabet_len]u16,
    command_counts: [constants.insert_copy_alphabet_len]u16,
    distance_counts: [constants.encoder_distance_alphabet_len]u16,
    /// The literals of the meta-block so far, and those the commands so far insert; the rest
    /// follow the last match.
    literals_len: usize,
    inserted: usize,
    /// The last distance first.
    last_distances: [constants.last_distances_count]u32,

    pub fn init(self: *Commands) void {
        // RFC 7932 §4: the last distance 4, then 11, 15 and 16, at the stream's start.
        self.last_distances = constants.last_distances_initial;
        self.reset();
    }

    /// Empties the meta-block; the last distances stay, as the stream keeps them.
    pub fn reset(self: *Commands) void {
        self.count = 0;
        self.literals_len = 0;
        self.inserted = 0;
        self.literal_counts = @splat(0);
        self.command_counts = @splat(0);
        self.distance_counts = @splat(0);
    }

    /// The finder's sink: the literals from `anchor` to `position`, then a match of `len` octets
    /// `distance` back.
    pub fn add(self: *Commands, window: []const u8, anchor: usize, position: usize, len: usize, distance: usize) void {
        assert(len >= constants.copy_length_codes[0].base and distance > 0 and self.count < self.commands.len);
        const insert_len = position - anchor;
        self.add_literals(window[anchor..position]);
        const code = self.distance_code(@intCast(distance));
        self.record(.{ .insert_len = @intCast(insert_len), .copy_len = @intCast(len), .distance = @intCast(distance), .distance_code = code });
        self.inserted += insert_len;
        if (code != 0) self.push_distance(@intCast(distance));
    }

    /// The finder's sink: literals, before a match or after the last one. The meta-block's last
    /// command inserts those after the last match, and the stream ends before its copy (RFC 7932
    /// §9.3).
    pub fn add_literals(self: *Commands, octets: []const u8) void {
        for (octets) |octet| self.literal_counts[octet] += 1;
        self.literals_len += octets.len;
    }

    /// The last distance, which the finder tries first.
    pub inline fn repeat_offset(self: *const Commands) u32 {
        return self.last_distances[0];
    }

    /// Records the literals after the last match, if any, as a command of their own.
    pub fn close(self: *Commands) void {
        const tail_len = self.literals_len - self.inserted;
        if (tail_len == 0) return;
        assert(self.count < self.commands.len);
        // The copy never runs: the meta-block's length ends at the literals. Code 0 keeps the
        // distance out of the stream where the insert code allows it.
        self.record(.{ .insert_len = @intCast(tail_len), .copy_len = constants.copy_length_codes[0].base, .distance = @intCast(self.last_distances[0]), .distance_code = 0 });
        self.inserted = self.literals_len;
    }

    fn record(self: *Commands, command: Command) void {
        self.commands[self.count] = command;
        self.count += 1;
        const symbol = coded_of(command).symbol;
        self.command_counts[symbol] += 1;
        if (symbol >= constants.insert_copy_last_distance_symbols) self.distance_counts[command.distance_code] += 1;
    }

    /// The short code of the last distances that names `distance` (RFC 7932 §4), else the code
    /// with extra bits.
    fn distance_code(self: *const Commands, distance: u32) u8 {
        for (self.last_distances, 0..) |last, code| {
            if (last == distance) return @intCast(code);
        }
        return distance_code_of(distance).code;
    }

    fn push_distance(self: *Commands, distance: u32) void {
        std.mem.copyBackwards(u32, self.last_distances[1..], self.last_distances[0 .. self.last_distances.len - 1]);
        self.last_distances[0] = distance;
    }
};

/// A command's symbols and extra bits (RFC 7932 §5).
pub fn coded_of(command: Command) Coded {
    const insert_code = length_code(&constants.insert_length_codes, command.insert_len);
    const copy_code = length_code(&constants.copy_length_codes, command.copy_len);
    const insert = constants.insert_length_codes[insert_code];
    const copy = constants.copy_length_codes[copy_code];
    var coded: Coded = .{
        .symbol = insert_copy_symbol(insert_code, copy_code, command.distance_code == 0),
        .insert_extra = command.insert_len - insert.base,
        .insert_extra_bits = insert.extra_bits,
        .copy_extra = command.copy_len - copy.base,
        .copy_extra_bits = copy.extra_bits,
        .distance_extra = 0,
        .distance_extra_bits = 0,
    };
    if (command.distance_code >= constants.distance_short_codes_count) {
        const distance = distance_code_of(command.distance);
        assert(distance.code == command.distance_code);
        coded.distance_extra = distance.extra;
        coded.distance_extra_bits = distance.extra_bits;
    }
    return coded;
}

/// The code of `len` in a table of RFC 7932 §5: the last whose first length is `len` or less.
fn length_code(table: []const constants.LengthCode, len: u32) u5 {
    assert(len >= table[0].base);
    var code: u5 = 0;
    for (table[1..], 1..) |entry, index| {
        if (entry.base > len) break;
        code = @intCast(index);
    }
    return code;
}

/// The insert-and-copy symbol of two length codes: a symbol below 128 when the distance is the last
/// one and both codes fit its cells, else the cell of RFC 7932 §5's table that holds both.
fn insert_copy_symbol(insert_code: u5, copy_code: u5, last_distance: bool) u16 {
    const low = (@as(u16, insert_code & code_mask) << constants.insert_copy_code_bits) | (copy_code & code_mask);
    const first_explicit = constants.insert_copy_last_distance_symbols >> constants.insert_copy_cell_bits;
    const cells = constants.insert_copy_cells;
    const start: usize = if (last_distance) 0 else first_explicit;
    for (cells[start..], start..) |cell, index| {
        if (last_distance and index == first_explicit) break;
        if (cell.insert == insert_code & ~code_mask and cell.copy == copy_code & ~code_mask) return @intCast((index << constants.insert_copy_cell_bits) | low);
    }
    // No cell below 128 holds the codes: the distance goes out as code 0.
    return insert_copy_symbol(insert_code, copy_code, false);
}

const code_mask: u5 = (1 << constants.insert_copy_code_bits) - 1;

const DistanceCode = struct { code: u8, extra: u32, extra_bits: u5 };

/// A distance's code of 16 or more and its extra bits, with NPOSTFIX and NDIRECT 0 (RFC 7932 §4):
/// distance + 3 lies from 2 << ndistbits to 4 << ndistbits, and its bit below the top two picks
/// one of the two codes of each ndistbits.
fn distance_code_of(distance: u32) DistanceCode {
    const shifted = distance + constants.distance_offset;
    const top: u5 = @intCast(std.math.log2_int(u32, shifted));
    const extra_bits: u5 = top - 1;
    const half: u32 = (shifted >> extra_bits) & 1;
    return .{
        .code = @intCast(constants.distance_short_codes_count + constants.distance_codes_per_extra_bits * (@as(u32, extra_bits) - 1) + half),
        .extra = shifted - ((constants.distance_prefix_base + half) << extra_bits),
        .extra_bits = extra_bits,
    };
}

test "a distance the ring holds takes its short code, and code 0 moves no distance" {
    // RFC 7932 §4: the ring starts 4, 11, 15, 16. Distance 4 is code 0 and stays; 15 is code 2 and
    // goes first; 100 takes code 25, as 103 is 0b1100111, and goes first.
    var commands: Commands = undefined;
    commands.init();
    const window = [_]u8{0} ** 64;
    commands.add(&window, 0, 0, 4, 4);
    try std.testing.expectEqualSlices(u32, &constants.last_distances_initial, &commands.last_distances);
    commands.add(&window, 4, 8, 4, 15);
    commands.add(&window, 12, 12, 4, 100);
    try std.testing.expectEqualSlices(u32, &.{ 100, 15, 4, 11 }, &commands.last_distances);
    const codes = [_]u8{ commands.commands[0].distance_code, commands.commands[1].distance_code, commands.commands[2].distance_code };
    try std.testing.expectEqualSlices(u8, &.{ 0, 2, 25 }, &codes);
    // RFC 7932 §5: no insert and a copy of 4 with distance code 0 is symbol 2, of the cell that
    // leaves the distance out; 4 inserted and 4 copied with another code is 128 + 34.
    try std.testing.expectEqual(2, coded_of(commands.commands[0]).symbol);
    try std.testing.expectEqual(162, coded_of(commands.commands[1]).symbol);
    try std.testing.expectEqual(1, commands.command_counts[2]);
    try std.testing.expectEqual(0, commands.distance_counts[0]);
    try std.testing.expectEqual(1, commands.distance_counts[2]);
    try std.testing.expectEqual(1, commands.distance_counts[25]);
    const extra = coded_of(commands.commands[2]);
    try std.testing.expectEqual(5, extra.distance_extra_bits);
    try std.testing.expectEqual(103 - 96, extra.distance_extra);
}
