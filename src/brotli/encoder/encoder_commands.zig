//! A meta-block's commands (RFC 7932 §9.3), as codec's match finder finds them (decision 62): each
//! command inserts literals and copies a match. Each command is coded once, as it arrives: its
//! insert-and-copy symbol and its distance's code and extra bits, which the meta-block counts for
//! its prefix codes and the writer puts.
//!
//! A command's distance goes out as a short code where one of the four last distances names it
//! (RFC 7932 §4), the last as code 0, and otherwise as a code of 16 or more with extra bits, with
//! NPOSTFIX and NDIRECT 0. Code 0 leaves the ring of last distances as it was; every other code
//! pushes its distance. The insert length code, the copy length code and code 0 together pick the
//! insert-and-copy symbol: one of 0 to 127 leaves the distance out of the stream (RFC 7932 §5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

comptime {
    assert(constants.encoder_meta_block_len_max <= std.math.maxInt(u16));
    assert(constants.encoder_commands_max < std.math.maxInt(u16));
}

/// The eighths of a bit `literal_cost` counts in.
pub const eighths = 8;

/// A command as the meta-block holds it, coded, in 8 octets (decision 12's budget): its lengths,
/// its insert-and-copy symbol, and its distance's code and extra bits. The lengths' extra bits
/// follow from the symbol and the lengths.
pub const Command = extern struct {
    insert_len: u16,
    copy_len: u16,
    /// The symbol in the low `symbol_bits` bits, and above them the distance's code: a short code
    /// below 16, else a code with extra bits (RFC 7932 §4).
    symbol_and_code: u16,
    /// The distance's extra bits, 16 at most below level 1's WBITS of 18.
    distance_extra: u16,

    pub inline fn symbol(self: Command) u10 {
        return @truncate(self.symbol_and_code);
    }

    pub inline fn distance_code(self: Command) u6 {
        return @intCast(self.symbol_and_code >> symbol_bits);
    }
};

/// The bits of an insert-and-copy symbol (RFC 7932 §5: 704 symbols).
pub const symbol_bits = @bitSizeOf(u10);

comptime {
    // RFC 7932 §4: distance + 3 lies below 2^WBITS, and its extra bits number its top bit's place
    // less one.
    assert(constants.encoder_level1_window_bits - 2 <= @bitSizeOf(u16));
}

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
    /// A literal's mean cost in eighths of a bit under the last meta-block's literal code, which
    /// `takes` weighs a match against.
    literal_cost: u32,

    pub fn init(self: *Commands) void {
        // RFC 7932 §4: the last distance 4, then 11, 15 and 16, at the stream's start.
        self.last_distances = constants.last_distances_initial;
        self.literal_cost = constants.encoder_literal_cost_initial;
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
    pub inline fn add(self: *Commands, comptime safety: bool, window: []const u8, anchor: usize, position: usize, len: usize, distance: usize) void {
        @setRuntimeSafety(safety);
        assert(len >= constants.copy_length_codes[0].base and distance > 0 and self.count < self.commands.len);
        const insert_len = position - anchor;
        self.add_literals(safety, window[anchor..position]);
        const code = self.distance_code(safety, @intCast(distance));
        self.record(safety, @intCast(insert_len), @intCast(len), code.code, @intCast(code.extra));
        self.inserted += insert_len;
        if (code.code != 0) self.push_distance(safety, @intCast(distance));
    }

    /// The finder's sink: literals, before a match or after the last one. The meta-block's last
    /// command inserts those after the last match, and the stream ends before its copy (RFC 7932
    /// §9.3).
    pub fn add_literals(self: *Commands, comptime safety: bool, octets: []const u8) void {
        @setRuntimeSafety(safety);
        // Decision 17: a meta-block holds at most `encoder_meta_block_len_max` literals, which fit
        // a count's 16 bits.
        for (octets) |octet| self.literal_counts[octet] +%= 1;
        self.literals_len += octets.len;
    }

    /// Whether a match of `len` octets `offset` back saves more bits than it costs: the literals it
    /// replaces, at `literal_cost`, against a command's cost and the distance's extra bits.
    pub inline fn takes(self: *const Commands, comptime safety: bool, len: usize, offset: usize) bool {
        @setRuntimeSafety(safety);
        const cost = constants.encoder_match_cost_base + @as(usize, std.math.log2_int(usize, offset)) * eighths;
        return len * self.literal_cost > cost;
    }

    /// Sets `literal_cost` from the literal code a meta-block built for its own counts.
    pub fn weigh_literals(self: *Commands, lengths: *const [constants.literal_alphabet_len]u8) void {
        if (self.literals_len == 0) return;
        // A lane's sum stays below a meta-block's literals times the longest code, which fits 32
        // bits, and so does the total.
        const lanes = constants.encoder_scan_lanes;
        const Lanes = @Vector(lanes, u32);
        comptime assert(constants.literal_alphabet_len % lanes == 0);
        var sums: Lanes = @splat(0);
        for (0..constants.literal_alphabet_len / lanes) |index| {
            const counts: @Vector(lanes, u16) = self.literal_counts[index * lanes ..][0..lanes].*;
            const lens: @Vector(lanes, u8) = lengths[index * lanes ..][0..lanes].*;
            sums += @as(Lanes, counts) * @as(Lanes, lens);
        }
        const bits: usize = @reduce(.Add, sums);
        self.literal_cost = @intCast(bits * eighths / self.literals_len);
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
        self.record(true, @intCast(tail_len), constants.copy_length_codes[0].base, 0, 0);
        self.inserted = self.literals_len;
    }

    inline fn record(self: *Commands, comptime safety: bool, insert_len: u16, copy_len: u16, code: u6, extra: u16) void {
        @setRuntimeSafety(safety);
        const symbol = symbol_of(safety, insert_len, copy_len, code);
        self.commands[self.count] = .{ .insert_len = insert_len, .copy_len = copy_len, .symbol_and_code = symbol | @as(u16, code) << symbol_bits, .distance_extra = extra };
        self.count += 1;
        // Decision 17: a meta-block holds at most `encoder_commands_max` commands, which fit a
        // count's 16 bits.
        self.command_counts[symbol] +%= 1;
        if (symbol >= constants.insert_copy_last_distance_symbols) self.distance_counts[code] +%= 1;
    }

    /// The short code of the last distances that names `distance` (RFC 7932 §4), with no extra
    /// bits, else the code with extra bits.
    inline fn distance_code(self: *const Commands, comptime safety: bool, distance: u32) DistanceCode {
        @setRuntimeSafety(safety);
        for (self.last_distances, 0..) |last, code| {
            if (last == distance) return .{ .code = @intCast(code), .extra = 0, .extra_bits = 0 };
        }
        return distance_code_of(safety, distance);
    }

    inline fn push_distance(self: *Commands, comptime safety: bool, distance: u32) void {
        @setRuntimeSafety(safety);
        std.mem.copyBackwards(u32, self.last_distances[1..], self.last_distances[0 .. self.last_distances.len - 1]);
        self.last_distances[0] = distance;
    }
};

/// The finder's sink over `commands`, with the safety decision 16 gives the encoder's parse: each
/// call goes to the method of `Commands` it names.
pub fn Sink(comptime safety: bool) type {
    return struct {
        const Self = @This();
        commands: *Commands,

        pub fn add(self: *Self, window: []const u8, anchor: usize, position: usize, len: usize, distance: usize) void {
            self.commands.add(safety, window, anchor, position, len, distance);
        }

        pub fn add_literals(self: *Self, octets: []const u8) void {
            self.commands.add_literals(safety, octets);
        }

        pub inline fn takes(self: *const Self, len: usize, offset: usize) bool {
            return self.commands.takes(safety, len, offset);
        }

        pub inline fn repeat_offset(self: *const Self) u32 {
            return self.commands.repeat_offset();
        }
    };
}

/// A command's insert-and-copy symbol (RFC 7932 §5).
inline fn symbol_of(comptime safety: bool, insert_len: u16, copy_len: u16, code: u6) u10 {
    @setRuntimeSafety(safety);
    const last = @intFromBool(code == 0);
    if (insert_len < small_symbols[0].len and copy_len < small_symbols[0][0].len) return small_symbols[last][insert_len][copy_len];
    return insert_copy_symbols[last][insert_code_of(safety, insert_len)][copy_code_of(safety, copy_len)];
}

/// A command's extra bits (RFC 7932 §4, §5): the lengths' from the symbol's codes, and the
/// distance's from its code.
pub fn coded_of(comptime safety: bool, command: Command) Coded {
    @setRuntimeSafety(safety);
    const lengths = symbol_lengths[command.symbol()];
    return .{
        .symbol = command.symbol(),
        .insert_extra = command.insert_len - lengths.insert_base,
        .insert_extra_bits = lengths.insert_extra_bits,
        .copy_extra = command.copy_len - lengths.copy_base,
        .copy_extra_bits = lengths.copy_extra_bits,
        .distance_extra = command.distance_extra,
        .distance_extra_bits = distance_extra_bits[command.distance_code()],
    };
}

/// The symbols of the short lengths most commands take, by whether the distance is the last one and
/// by the two lengths, in one load (RFC 7932 §5).
pub const small_symbols = symbols: {
    @setEvalBranchQuota(constants.encoder_symbol_table_quota);
    var table: [constants.encoder_distance_kinds][constants.encoder_small_insert_len][constants.encoder_small_copy_len]u10 = undefined;
    for (&table, 0..) |*by_insert, last| {
        for (by_insert, 0..) |*by_copy, insert_len| {
            for (by_copy, 0..) |*symbol, copy_len| {
                const copy_code = if (copy_len < constants.copy_length_codes[0].base) 0 else copy_codes[copy_len];
                symbol.* = insert_copy_symbols[last][insert_codes[insert_len]][copy_code];
            }
        }
    }
    break :symbols table;
};

/// The first lengths and extra bits of each insert-and-copy symbol's two length codes, worked out
/// from RFC 7932 §5's cells at compile time.
const SymbolLengths = struct { insert_base: u16, insert_extra_bits: u5, copy_base: u16, copy_extra_bits: u5 };

const symbol_lengths = lengths: {
    var table: [constants.insert_copy_alphabet_len]SymbolLengths = undefined;
    for (&table, 0..) |*entry, symbol| {
        const cell = constants.insert_copy_cells[symbol >> constants.insert_copy_cell_bits];
        const insert = constants.insert_length_codes[cell.insert + ((symbol >> constants.insert_copy_code_bits) & code_mask)];
        const copy = constants.copy_length_codes[cell.copy + (symbol & code_mask)];
        entry.* = .{ .insert_base = insert.base, .insert_extra_bits = insert.extra_bits, .copy_base = copy.base, .copy_extra_bits = copy.extra_bits };
    }
    break :lengths table;
};

/// The extra bits of each distance code (RFC 7932 §4, NPOSTFIX and NDIRECT 0): none for a short
/// code, and for code 16 + 2(n - 1) + half, n.
const distance_extra_bits = bits: {
    var table: [constants.encoder_distance_alphabet_len]u5 = @splat(0);
    for (constants.distance_short_codes_count..table.len) |code| {
        table[code] = (code - constants.distance_short_codes_count) / constants.distance_codes_per_extra_bits + 1;
    }
    break :bits table;
};

/// The insert and copy length codes of the lengths below `constants.encoder_length_table_len`,
/// worked out from RFC 7932 §5's tables at compile time; a longer length searches the table.
pub const insert_codes = length_codes_of(&constants.insert_length_codes);
pub const copy_codes = length_codes_of(&constants.copy_length_codes);

fn length_codes_of(comptime table: []const constants.LengthCode) [constants.encoder_length_table_len]u5 {
    @setEvalBranchQuota(constants.encoder_symbol_table_quota);
    var codes: [constants.encoder_length_table_len]u5 = @splat(0);
    for (&codes, 0..) |*code, len| {
        if (len >= table[0].base) code.* = length_code(table, len);
    }
    return codes;
}

inline fn insert_code_of(comptime safety: bool, len: u32) u5 {
    @setRuntimeSafety(safety);
    if (len < insert_codes.len) return insert_codes[len];
    return length_code(&constants.insert_length_codes, len);
}

inline fn copy_code_of(comptime safety: bool, len: u32) u5 {
    @setRuntimeSafety(safety);
    if (len < copy_codes.len) return copy_codes[len];
    return length_code(&constants.copy_length_codes, len);
}

/// Every insert-and-copy symbol, by whether the distance is the last one and by the two length
/// codes, worked out from RFC 7932 §5's cells at compile time.
pub const insert_copy_symbols = symbols: {
    @setEvalBranchQuota(constants.encoder_symbol_table_quota);
    const count = constants.insert_length_codes.len;
    var symbols: [constants.encoder_distance_kinds][count][count]u10 = undefined;
    for (&symbols, 0..) |*table, last| {
        for (0..count) |insert| {
            for (0..count) |copy| table[insert][copy] = insert_copy_symbol(insert, copy, last == 1);
        }
    }
    break :symbols symbols;
};

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
fn insert_copy_symbol(insert_code: u5, copy_code: u5, last_distance: bool) u10 {
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

const DistanceCode = struct { code: u6, extra: u32, extra_bits: u5 };

/// A distance's code of 16 or more and its extra bits, with NPOSTFIX and NDIRECT 0 (RFC 7932 §4):
/// distance + 3 lies from 2 << ndistbits to 4 << ndistbits, and its bit below the top two picks
/// one of the two codes of each ndistbits.
inline fn distance_code_of(comptime safety: bool, distance: u32) DistanceCode {
    @setRuntimeSafety(safety);
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
    commands.add(true, &window, 0, 0, 4, 4);
    try std.testing.expectEqualSlices(u32, &constants.last_distances_initial, &commands.last_distances);
    commands.add(true, &window, 4, 8, 4, 15);
    commands.add(true, &window, 12, 12, 4, 100);
    try std.testing.expectEqualSlices(u32, &.{ 100, 15, 4, 11 }, &commands.last_distances);
    const codes = [_]u8{ commands.commands[0].distance_code(), commands.commands[1].distance_code(), commands.commands[2].distance_code() };
    try std.testing.expectEqualSlices(u8, &.{ 0, 2, 25 }, &codes);
    // RFC 7932 §5: no insert and a copy of 4 with distance code 0 is symbol 2, of the cell that
    // leaves the distance out; 4 inserted and 4 copied with another code is 128 + 34.
    try std.testing.expectEqual(2, coded_of(true, commands.commands[0]).symbol);
    try std.testing.expectEqual(162, coded_of(true, commands.commands[1]).symbol);
    try std.testing.expectEqual(1, commands.command_counts[2]);
    try std.testing.expectEqual(0, commands.distance_counts[0]);
    try std.testing.expectEqual(1, commands.distance_counts[2]);
    try std.testing.expectEqual(1, commands.distance_counts[25]);
    const extra = coded_of(true, commands.commands[2]);
    try std.testing.expectEqual(5, extra.distance_extra_bits);
    try std.testing.expectEqual(103 - 96, extra.distance_extra);
}

test "a match is taken when the literals it replaces cost more than it" {
    // At 2 bits a literal, a match 1000 back costs 12 bits and 9 of distance, 168 eighths: 10
    // literals save 160 and 11 save 176.
    var commands: Commands = undefined;
    commands.init();
    commands.literal_cost = 16;
    try std.testing.expect(!commands.takes(true, 10, 1000));
    try std.testing.expect(commands.takes(true, 11, 1000));
    // Nearer, a shorter match pays: 1 back costs 96 eighths, which 7 literals pass.
    try std.testing.expect(!commands.takes(true, 6, 1));
    try std.testing.expect(commands.takes(true, 7, 1));
}

test "a literal's cost is the mean length of the code its meta-block built" {
    var commands: Commands = undefined;
    commands.init();
    try std.testing.expectEqual(constants.encoder_literal_cost_initial, commands.literal_cost);
    // The last octet value too, which the weighing's last group of lanes holds.
    const window = "aaab\xff\xff\xff\xff";
    commands.add_literals(true, window);
    var lengths: [constants.literal_alphabet_len]u8 = @splat(0);
    lengths['a'] = 1;
    lengths['b'] = 3;
    lengths[0xff] = 5;
    commands.weigh_literals(&lengths);
    // Three literals of 1 bit, one of 3 and four of 5: 26 bits over 8, 26 eighths.
    try std.testing.expectEqual(26, commands.literal_cost);
}
