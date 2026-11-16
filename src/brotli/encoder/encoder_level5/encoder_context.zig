//! Level 5's literal context modeling (RFC 7932 §7.1, §7.3; decision 62; decision 66, output
//! size). A meta-block may code its literals in one block type of UTF8 mode, with a prefix code
//! for each class of the octet before a literal: the UTF8 context ID without the low bits that the
//! octet before that one sets. The context map gives each ID its class, and the meta-block takes
//! this form where its literals then take fewer bits than in the split's blocks.
//!
//! The map is the same in every meta-block: each class's 4 IDs in a row. After the move-to-front
//! transform it is a run of 4 zeros, then each class's number and a run of 3 zeros.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const encoder_prefix = @import("../encoder_prefix.zig");
const encoder_commands = @import("../encoder_commands.zig");

pub const Error = encoder_prefix.Error;

const level5 = constants.encoder_level5;
const alphabet_len = constants.literal_alphabet_len;
const class_shift = level5.class_shift;
/// The IDs of one class, and the classes.
const ids_per_class = 1 << class_shift;
pub const class_count = constants.literal_contexts_count / ids_per_class;
const run_codes = level5.class_map_run_codes;
/// The class map's alphabet: a zero, the run codes, and the classes past the first (RFC 7932 §7.3).
const map_alphabet_len = class_count + run_codes;
const map_alphabet_bits = std.math.log2_int_ceil(usize, map_alphabet_len);
const LiteralCode = encoder_prefix.Code(alphabet_len);
const MapCode = encoder_prefix.Code(map_alphabet_len);

/// The class of each octet as the octet before a literal: its part of the UTF8 context ID, less
/// the low bits.
pub const class_of = table: {
    var table: [alphabet_len]u8 = undefined;
    for (&table, 0..) |*class, octet| class.* = context.lut0[octet] >> class_shift;
    break :table table;
};

comptime {
    // The octet before the octet before a literal sets only the ID's low bits, so a class is a
    // function of the octet before alone (RFC 7932 §7.1: UTF8's ID is Lut0[p1] | Lut1[p2]).
    for (context.lut1) |part| assert(part < ids_per_class);
    assert(class_count <= constants.trees_max and run_codes <= constants.run_length_codes_max);
}

/// One symbol of the class map and its extra bits.
const MapSymbol = struct { symbol: u8, extra: u8, extra_bits: u3 };

/// The class map's symbols (RFC 7932 §7.3): a run code r stands for 2^r zeros and r extra bits.
const map_symbols = symbols: {
    var list: [1 + 2 * (class_count - 1)]MapSymbol = undefined;
    list[0] = run_of(ids_per_class);
    for (1..class_count) |class| {
        list[2 * class - 1] = .{ .symbol = class + run_codes, .extra = 0, .extra_bits = 0 };
        list[2 * class] = run_of(ids_per_class - 1);
    }
    break :symbols list;
};

fn run_of(comptime zeros: usize) MapSymbol {
    const code = std.math.log2_int(usize, zeros);
    assert(code >= 1 and code <= run_codes);
    return .{ .symbol = code, .extra = zeros - (1 << code), .extra_bits = code };
}

/// A meta-block's literals by class: their counts and codes, and the class map's code.
pub const Classes = struct {
    counts: [class_count][alphabet_len]u16,
    codes: [class_count]LiteralCode,
    map: MapCode,

    /// Counts the literals of `input`, the meta-block of `window[start..]`, by the class of the
    /// octet before each: the window's octet before the meta-block, or 0 at the stream's start
    /// (RFC 7932 §7.1).
    pub fn count(self: *Classes, comptime safety: bool, window: []const u8, start: usize, input: []const u8, commands: anytype) void {
        @setRuntimeSafety(safety);
        for (&self.counts) |*counts| counts.* = @splat(0);
        var produced: usize = 0;
        var before = octet_before(window, start);
        for (commands.commands[0..commands.count]) |command| {
            // Decision 17: a meta-block holds fewer literals than a count's 16 bits hold.
            for (input[produced..][0..command.insert_len]) |octet| {
                self.counts[class_of[before]][octet] +%= 1;
                before = octet;
            }
            produced += command.insert_len;
            if (produced == input.len) break;
            produced += encoder_commands.written_of(command);
            before = input[produced - 1];
        }
    }

    /// Builds each class's code and the map's, and returns the bits the literals take this way
    /// past the header fields both forms write: the context mode, NTREESL and the map, each
    /// class's code and its literals.
    pub fn build(self: *Classes) u64 {
        var bits: u64 = constants.context_mode_bits + count_bits(class_count);
        for (&self.counts, &self.codes) |*counts, *code| {
            // A code needs a symbol; a class with no literals codes one it never uses.
            const empty = std.mem.allEqual(u16, counts, 0);
            if (empty) counts[0] = 1;
            encoder_prefix.build(alphabet_len, counts, code);
            if (empty) counts[0] = 0;
            bits += encoder_prefix.description_bits(alphabet_len, code, constants.literal_alphabet_bits);
            for (counts, code.lengths) |literals, len| bits += @as(u64, literals) * len;
        }
        var map_counts: [map_alphabet_len]u16 = @splat(0);
        for (map_symbols) |entry| map_counts[entry.symbol] += 1;
        encoder_prefix.build(map_alphabet_len, &map_counts, &self.map);
        // RLEMAX's field, the map's code and symbols, and the IMTF bit.
        bits += 1 + constants.run_length_field_bits + encoder_prefix.description_bits(map_alphabet_len, &self.map, map_alphabet_bits) + 1;
        for (map_symbols) |entry| bits += self.map.lengths[entry.symbol] + entry.extra_bits;
        return bits;
    }

    /// The mean cost of a literal under the classes' codes, in eighths of a bit, for the next
    /// meta-block's parse.
    pub fn mean_cost(self: *const Classes, literals_len: usize) u32 {
        var bits: u64 = 0;
        for (&self.counts, &self.codes) |*counts, *code| {
            for (counts, code.lengths) |literals, len| bits += @as(u64, literals) * len;
        }
        return @intCast(bits * encoder_commands.eighths / literals_len);
    }

    /// The literal part of the meta-block's header (RFC 7932 §9.2): UTF8 mode, NTREESL and the
    /// class map; then, after NTREESD, `write_codes` writes the classes' codes.
    pub fn write_map(self: *const Classes, writer: *codec.BitWriter) Error!void {
        try put(writer, @intFromEnum(context.Mode.utf8), constants.context_mode_bits);
        try write_count(writer, class_count);
        try put(writer, (run_codes - 1) << 1 | 1, 1 + constants.run_length_field_bits);
        try encoder_prefix.write(map_alphabet_len, writer, &self.map, map_alphabet_bits);
        for (map_symbols) |entry| {
            try put(writer, self.map.codes[entry.symbol], @intCast(self.map.lengths[entry.symbol]));
            try put(writer, entry.extra, entry.extra_bits);
        }
        // IMTF.
        try put(writer, 1, 1);
    }

    pub fn write_codes(self: *const Classes, writer: *codec.BitWriter) Error!void {
        for (&self.codes) |*code| try encoder_prefix.write(alphabet_len, writer, code, constants.literal_alphabet_bits);
    }
};

/// The octet before a meta-block that starts at `start`: 0 at the stream's start (RFC 7932 §7.1).
pub fn octet_before(window: []const u8, start: usize) u8 {
    return if (start > 0) window[start - 1] else 0;
}

/// The bits of NBLTYPESx or NTREESx for `count` (RFC 7932 §9.2).
pub fn count_bits(count: usize) u64 {
    if (count == 1) return 1;
    const top = std.math.log2_int(usize, count - 1);
    return 1 + constants.count_field_bits + top;
}

/// NTREESx (RFC 7932 §9.2): a 0 bit for 1; otherwise 1, three bits n, and n bits of the count less
/// 1 less 2^n.
fn write_count(writer: *codec.BitWriter, count: usize) Error!void {
    assert(count > 1);
    const top: u3 = @intCast(std.math.log2_int(usize, count - 1));
    try put(writer, 1 | @as(u64, top) << 1, 1 + constants.count_field_bits);
    try put(writer, count - 1 - (@as(usize, 1) << top), top);
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}

const testing = std.testing;

test "a class is the UTF8 context ID less the bits of the octet before the octet before" {
    for (0..alphabet_len) |p1| {
        for (0..alphabet_len) |p2| {
            const id = context.literal_id(.utf8, @intCast(p1), @intCast(p2));
            try testing.expectEqual(id >> class_shift, class_of[p1]);
        }
    }
}

test "the class map's symbols give each ID its class after the inverse move-to-front" {
    // Decode the symbols as RFC 7932 §7.3 reads them: zeros, runs of zeros, values; then IMTF.
    var values: [constants.literal_contexts_count]u8 = undefined;
    var at: usize = 0;
    for (map_symbols) |entry| {
        if (entry.symbol == 0) {
            values[at] = 0;
            at += 1;
        } else if (entry.symbol <= run_codes) {
            const zeros = (@as(usize, 1) << @intCast(entry.symbol)) + entry.extra;
            @memset(values[at..][0..zeros], 0);
            at += zeros;
        } else {
            values[at] = entry.symbol - run_codes;
            at += 1;
        }
    }
    try testing.expectEqual(values.len, at);
    var order: [class_count]u8 = undefined;
    for (&order, 0..) |*value, index| value.* = @intCast(index);
    for (&values, 0..) |*value, id| {
        const index = value.*;
        value.* = order[index];
        std.mem.copyBackwards(u8, order[1 .. index + 1], order[0..index]);
        order[0] = value.*;
        try testing.expectEqual(id >> class_shift, value.*);
    }
}
