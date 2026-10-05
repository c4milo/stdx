//! The DEFLATE header's fast paths (decision 16; decision 14, S13): a dynamic block's code length
//! code and its code lengths (RFC 1951 §3.2.7). The bits come from a 64-bit buffer refilled by
//! whole words while at least `input_slack` octets of input remain, and one lookup in a table of
//! `constants.code_length_table_bits` bits decodes each code of the code length code.
//!
//! A loop writes the lengths the checked steps of decoder_header.zig would write and leaves the
//! reader where they would. The checked path finishes the header: the lengths the input's margin
//! leaves out, the codes' builds, and every refusal. The loop stops before a symbol the checked
//! path refuses, having used no bit of it.
//!
//! The code lengths' loop writes nothing for a run of zeros. Every length ahead of it is zero:
//! the header's first step clears them all, and the decoder clears the code length code's lengths
//! again once that code is built.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");

/// Decision 16's input margin: the octets one refill loads.
pub const input_slack = @sizeOf(u64);

/// The code lengths a dynamic block's header fills: the literal/length alphabet's, then the
/// distance alphabet's (decoder.zig).
pub const Lengths = [constants.code_lengths_len]u8;

/// The canonical code of the code length alphabet (huffman.zig).
pub const CodeLengthCode = huffman.Code(constants.code_length_alphabet_len);

/// One entry of the code length code's table: the symbol whose code the index starts with, and
/// that code's bits.
pub const Entry = packed struct(u8) {
    code_bits: u3,
    symbol: u5,
};

comptime {
    assert(constants.code_length_code_len_max <= std.math.maxInt(u3));
    assert(constants.code_length_alphabet_len - 1 <= std.math.maxInt(u5));
    // A refill leaves a symbol's bits and more in the buffer.
    assert(constants.code_length_symbol_bits <= @bitSizeOf(u64) - @bitSizeOf(u8));
}

/// The entries a build starts from: one bit's.
const first_table_len = 2;

/// The code length code as a table indexed by the next bits of the stream, least significant bit
/// first, so one lookup decodes a code length symbol (decision 14, S13).
pub const Table = struct {
    entries: [len]Entry,

    pub const len = 1 << constants.code_length_table_bits;

    /// An index into `entries`: its type holds every index and no other.
    pub const Index = std.meta.Int(.unsigned, constants.code_length_table_bits);

    /// Builds the table of the code length code huffman.zig built complete: its `counts` of each
    /// length and its `symbols` in code order (RFC 1951 §3.2.2). It places the codes of each
    /// length in a table of that length's size, from the shortest, and doubles the table before
    /// the next length, as lookup.zig builds a block's tables. A complete code names every index.
    /// Returns the entries it wrote.
    pub fn build(self: *Table, code: *const CodeLengthCode) usize {
        assert(code.counts[0] == 0);
        self.entries[0..first_table_len].* = @splat(.{ .code_bits = 0, .symbol = 0 });
        var written: usize = first_table_len;
        var first: u16 = 0;
        var placed: u16 = 0;
        inline for (1..constants.code_length_table_bits + 1) |bits| {
            // RFC 1951 §3.2.2, step 2: the first code of this length.
            first = (first + code.counts[bits - 1]) << 1;
            if (bits > 1) {
                const half = 1 << (bits - 1);
                self.entries[half..][0..half].* = self.entries[0..half].*;
                written += half;
            }
            const of_length = code.symbols[placed..][0..code.counts[bits]];
            for (of_length, 0..) |symbol, index| {
                self.entries[reversed(@intCast(first + index), bits)] = .{ .code_bits = bits, .symbol = @intCast(symbol) };
            }
            placed += code.counts[bits];
            written += of_length.len;
        }
        assert(written <= constants.code_length_table_work_max);
        return written;
    }

    /// The entry of the code the buffer starts with.
    pub inline fn look_up(self: *const Table, buffer: u64) Entry {
        return self.entries[@as(Index, @truncate(buffer))];
    }
};

/// A code of `bits` bits, most significant first, as the stream packs it: least significant first
/// (RFC 1951 §3.1.1).
fn reversed(code: Table.Index, comptime bits: comptime_int) Table.Index {
    return @bitReverse(code) >> (constants.code_length_table_bits - bits);
}

/// The reader's state in locals: the input, the position of the next octet, and the bits taken
/// from the octets before it, least significant bit first (RFC 1951 §3.1.1).
const Bits = struct {
    input: []const u8,
    position: usize,
    buffer: u64,
    count: u32,

    /// The reader's state, as a loop takes it: no bit above `count` set.
    inline fn of(bits: *const codec.BitReader) Bits {
        assert(bits.bits.count <= @bitSizeOf(u64));
        return .{ .input = bits.reader.octets, .position = bits.reader.position, .buffer = bits.bits.buffer, .count = bits.bits.count };
    }

    /// Whether the buffer holds `wanted` bits, after a refill when it holds fewer and the input's
    /// margin holds: one 8-octet load, of which the whole octets that fit above `count` are
    /// taken. The bits above `count` repeat the input's next octet, which the next load writes
    /// again unchanged.
    inline fn has_bits(self: *Bits, comptime wanted: u32) bool {
        comptime assert(wanted <= constants.code_length_symbol_bits);
        if (self.count >= wanted) return true;
        if (self.input.len - self.position < input_slack) return false;
        // The octets of a stream come least significant bit first (RFC 1951 §3.1.1).
        const loaded = std.mem.readInt(u64, self.input[self.position..][0..input_slack], .little);
        self.buffer |= loaded << @intCast(self.count);
        const octets = (@bitSizeOf(u64) - 1 - self.count) / @bitSizeOf(u8);
        self.position += octets;
        self.count += octets * @bitSizeOf(u8);
        return true;
    }

    /// Takes `bit_count` bits, at most a symbol's.
    inline fn take(self: *Bits, bit_count: u32) void {
        assert(bit_count <= constants.code_length_symbol_bits and bit_count <= self.count);
        self.buffer >>= @intCast(bit_count);
        self.count -= bit_count;
    }

    /// Hands the reader back as the checked reader keeps it: no bit above `count` set.
    inline fn hand_back(self: *const Bits, bits: *codec.BitReader) void {
        assert(self.position <= self.input.len and self.count <= @bitSizeOf(u64));
        const kept = if (self.count == @bitSizeOf(u64)) self.buffer else self.buffer & ((@as(u64, 1) << @intCast(self.count)) - 1);
        bits.bits = .{ .buffer = kept, .count = @intCast(self.count) };
        bits.reader.position = self.position;
    }
};

/// The mask of a length of the code length code: 3 bits (RFC 1951 §3.2.7).
const code_length_code_mask = (1 << constants.code_length_code_bits) - 1;

/// Reads lengths of the code length code, in the order RFC 1951 §3.2.7 gives them, while the
/// buffer holds one or the input's margin lets it refill, up to the `count` the header gives.
/// `index` counts the lengths read so far. Returns how many it read.
pub fn read_code_length_code(lengths: *Lengths, index: *u16, count: u16, bits: *codec.BitReader) usize {
    assert(count <= constants.code_length_alphabet_len and index.* <= count);
    var local = Bits.of(bits);
    var at: usize = index.*;
    for (0..constants.code_length_alphabet_len) |_| {
        if (at >= count or !local.has_bits(constants.code_length_code_bits)) break;
        lengths[constants.code_length_order[at]] = @intCast(local.buffer & code_length_code_mask);
        local.take(constants.code_length_code_bits);
        at += 1;
    }
    const read_count = at - index.*;
    index.* = @intCast(at);
    local.hand_back(bits);
    return read_count;
}

/// Each repeat symbol's extra bits and least count (RFC 1951 §3.2.7), by the symbol's low four
/// bits, so a table entry's symbol indexes them with no bounds check: 16, 17 and 18 come first.
const repeat_slots = 1 << @bitSizeOf(u4);
const repeat_extra_bits: [repeat_slots]u8 = repeats(&constants.repeat_extra_bits);
const repeat_count_min: [repeat_slots]u8 = repeats(&constants.repeat_count_min);

fn repeats(comptime values: anytype) [repeat_slots]u8 {
    var slots: [repeat_slots]u8 = @splat(0);
    for (values, 0..) |value, kind| slots[kind] = @intCast(value);
    return slots;
}

comptime {
    assert(constants.repeat_previous == repeat_slots);
}

/// A length in each octet of a word: a multiply by it copies an octet into all eight.
const repeated_octet: u64 = 0x0101_0101_0101_0101;

/// What the code lengths' loop writes into: the header's lengths, the count of those read so far,
/// of the header's `total`, and the tally of them for the codes' builds (decision 14, S14), of
/// which the literal/length alphabet takes the first `literal_length_count`.
pub const Into = struct {
    lengths: *Lengths,
    index: *u16,
    total: u16,
    tally: *huffman.Tally,
    literal_length_count: u16,
};

/// The loop's own copy of what it advances, which stays in registers.
const Place = struct {
    /// The lengths read so far.
    at: u32,
    /// The places the tally lists so far.
    coded_count: u32,
};

/// Reads code length symbols while the buffer holds one or the input's margin lets it refill, and
/// lengths are left to read, writing each symbol's lengths as the checked path writes them, and
/// tallying them as it does when the decode `tallies`. It stops, having used no bit of it, at a
/// symbol the checked path refuses. Returns invariant 17's count for what it read: a decode a
/// symbol, and an entry a length.
pub fn read(comptime tallies: bool, table: *const Table, into: Into, bits: *codec.BitReader) usize {
    assert(into.total <= constants.header_lengths_max and into.index.* <= into.total);
    // A decode that tallies nothing leaves the tally as it found it, and reads none of it.
    assert(!tallies or into.tally.coded_count <= into.index.*);
    var local = Bits.of(bits);
    var place: Place = .{ .at = into.index.*, .coded_count = if (tallies) into.tally.coded_count else 0 };
    var symbols: usize = 0;
    // Each symbol gives a length at least, so the lengths bound the loop.
    for (0..into.total) |_| {
        if (place.at >= into.total or !local.has_bits(constants.code_length_symbol_bits)) break;
        const entry = table.look_up(local.buffer);
        if (entry.symbol < constants.repeat_previous) {
            into.lengths[place.at] = entry.symbol;
            if (tallies) tally_length(into, &place, @truncate(entry.symbol));
            place.at += 1;
            local.take(entry.code_bits);
        } else if (!repeat(tallies, into, &place, &local, entry)) {
            break;
        }
        symbols += 1;
    }
    const written = place.at - into.index.*;
    into.index.* = @intCast(place.at);
    if (tallies) into.tally.coded_count = @intCast(place.coded_count);
    local.hand_back(bits);
    return symbols + written;
}

/// Tallies one length, `len`, at the loop's place: counted in its alphabet, and its place listed
/// when it is not zero, with no branch on that.
inline fn tally_length(into: Into, place: *Place, len: u4) void {
    into.tally.counts[huffman.Tally.alphabet(place.at, into.literal_length_count)][len] +%= 1;
    into.tally.coded[place.coded_count] = .{ .place = @intCast(place.at), .len = len };
    place.coded_count += @intFromBool(len != 0);
}

/// Applies the repeat symbol `entry` decodes, 16, 17 or 18, with its extra bits after its code
/// (RFC 1951 §3.2.7), to the lengths from the loop's place, and moves the place past them.
/// Returns false, having used no bit and written nothing, when the checked path must take the
/// symbol.
inline fn repeat(comptime tallies: bool, into: Into, place: *Place, local: *Bits, entry: Entry) bool {
    const at = place.at;
    const kind: u4 = @truncate(entry.symbol);
    const extra_bits: u32 = repeat_extra_bits[kind];
    const extra: u32 = @intCast((local.buffer >> entry.code_bits) & ((@as(u64, 1) << @intCast(extra_bits)) - 1));
    const count = repeat_count_min[kind] + extra;
    // RFC 1951 §3.2.7: the code lengths form one sequence, which a repeat may not pass. The
    // checked path refuses it.
    if (at + count > into.total) return false;
    if (entry.symbol == constants.repeat_previous) {
        // RFC 1951 §3.2.7: 16 copies the previous code length, and the first has none. The checked
        // path refuses it.
        if (at == 0) return false;
        // One store writes the copies and zeros after them, where every length is still zero.
        // Near the array's end it has no room, and the checked path writes the copies.
        if (at + @sizeOf(u64) > into.lengths.len) return false;
        const previous = into.lengths[at - 1];
        if (tallies) tally_copies(into, place, @truncate(previous), count);
        const copies = (previous * repeated_octet) & ((@as(u64, 1) << @intCast(count * @bitSizeOf(u8))) - 1);
        // The first copy goes to the lowest address: least significant octet first.
        std.mem.writeInt(u64, into.lengths[at..][0..@sizeOf(u64)], copies, .little);
    }
    // A run of zeros writes nothing and tallies nothing: the lengths ahead of the loop are zero.
    local.take(entry.code_bits + extra_bits);
    place.at = at + count;
    return true;
}

/// Tallies `count` copies of the length `len` from the loop's place, with no branch: counted in
/// their alphabets, since a repeat may run from the literal/length alphabet into the distance
/// alphabet (RFC 1951 §3.2.7), and their places listed when the length is not zero. It writes the
/// most places a repeat gives, and the list keeps as many as the copies.
inline fn tally_copies(into: Into, place: *Place, len: u4, count: u32) void {
    const at = place.at;
    assert(count <= constants.repeat_previous_count_max);
    const literal_length_copies = @min(count, into.literal_length_count -| at);
    into.tally.counts[0][len] +%= @intCast(literal_length_copies);
    into.tally.counts[1][len] +%= @intCast(count - literal_length_copies);
    inline for (0..constants.repeat_previous_count_max) |copy| {
        into.tally.coded[place.coded_count + copy] = .{ .place = @intCast(at + copy), .len = len };
    }
    place.coded_count += if (len != 0) count else 0;
}

test {
    _ = @import("fast_lengths_test.zig");
    _ = @import("fast_lengths_tally_test.zig");
}
