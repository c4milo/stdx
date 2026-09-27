//! The Zstandard decoder's literal decoding fast path (decision 16, claim Z1 of decision 14).
//!
//! Each Huffman-coded stream is read backward from one 8-octet little-endian load at a time, which
//! holds at least `constants.fast_read_position_min` bits below the stream's position, shifted so
//! the position's bit leads. A load decodes as many literals as those bits hold at the table's
//! longest code: each takes the cell the word's top `bits_max` bits index, and shifts its code out.
//! Four streams decode in one loop, a literal of each in turn, so the lookups of one stream do not
//! wait on another's (Z1). Literals go to the state's literal buffer, whose size is fixed, so the
//! loop needs no output margin. Each stream's last literals then decode one at a time, reading the
//! stream's first 8 octets where fewer lie before the position; the checked decoder takes each
//! stream from where they stop, in stream order, and requires it to end exactly at its first bit.
//!
//! A stream whose last octet is 0 sends every stream to the checked decoder whole, so each
//! refusal comes in the order the checked path gives it (decision 16).

const std = @import("std");
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const Claims = @import("claims.zig").Claims;

/// Decodes `outputs[i].len` literals from each of `streams`, one stream or four, as the checked
/// decoder would, stream after stream.
pub fn decode(comptime count: usize, comptime claims: Claims, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8) huffman.Error!void {
    var readers: [count]codec.BackwardBitReader = undefined;
    for (&readers, streams) |*reader, stream| {
        reader.* = codec.BackwardBitReader.init(stream) orelse return decode_checked(count, table, streams, outputs);
    }
    var done: [count]usize = @splat(0);
    // The table's longest code fixes the loop's shifts and its literals per load.
    switch (table.bits_max) {
        inline 1...constants.huffman_bits_max => |bits_max| {
            if (claims.interleaved_streams) {
                done = @splat(decode_loads(count, bits_max, table, streams, outputs, &readers));
            } else {
                for (&done, streams, outputs, &readers) |*decoded, stream, output, *reader| {
                    decoded.* = decode_loads(1, bits_max, table, .{stream}, .{output}, reader[0..1]);
                }
            }
        },
        // huffman.build gives a Max_Number_of_Bits from 1 to 11.
        else => unreachable,
    }
    for (&readers, streams, outputs, &done) |*reader, stream, output, *decoded| {
        decode_tail(table, stream, reader, output, decoded);
        try huffman.decode_rest(table, reader, output[decoded.*..]);
    }
}

/// The stream's first 8 octets as a little-endian word, zero past its end when it is shorter: the
/// load of any position in the stream's first 64 bits.
pub fn head_of(octets: []const u8) u64 {
    var padded: [@sizeOf(u64)]u8 = @splat(0);
    const len = @min(octets.len, padded.len);
    @memcpy(padded[0..len], octets[0..len]);
    return std.mem.readInt(u64, &padded, .little);
}

/// Decodes the literals the loads left, one at a time: each from the 8 octets that end at the
/// position's octet, or from the stream's first 8 when fewer lie before it, the bits before the
/// stream's first reading as zeros, as the checked decoder reads them (RFC 8878 §4.2.2). A code
/// longer than the bits left is the checked decoder's to refuse.
fn decode_tail(table: *const huffman.Table, stream: []const u8, reader: *codec.BackwardBitReader, output: []u8, done: *usize) void {
    const head = head_of(stream);
    const mask = (@as(u64, 1) << table.bits_max) - 1;
    for (output[done.*..]) |*literal| {
        const at = reader.position;
        const end = std.math.divCeil(usize, at, @bitSizeOf(u8)) catch unreachable;
        const start = if (end >= @sizeOf(u64)) end - @sizeOf(u64) else 0;
        const word = if (end >= @sizeOf(u64)) std.mem.readInt(u64, stream[start..][0..@sizeOf(u64)], .little) else head;
        const bits_left = at - start * @bitSizeOf(u8);
        const index = if (bits_left >= table.bits_max)
            (word >> @intCast(bits_left - table.bits_max)) & mask
        else
            (word & ((@as(u64, 1) << @intCast(bits_left)) - 1)) << @intCast(table.bits_max - bits_left);
        const cell = table.cells[@intCast(index)];
        if (cell.bits > at) return;
        literal.* = cell.symbol;
        reader.position = at - cell.bits;
        done.* += 1;
    }
}

fn decode_checked(comptime count: usize, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8) huffman.Error!void {
    for (streams, outputs) |stream, output| try huffman.decode_stream(table, stream, output);
}

/// The literals one load decodes: as many codes of the table's longest as the load's bits hold, at
/// most `constants.literals_per_load_max`.
pub fn literals_per_load(bits_max: u4) usize {
    return @min(constants.fast_read_position_min / @as(usize, bits_max), constants.literals_per_load_max);
}

/// One load of each stream, then a literal of each in turn, while every stream has the bits and the
/// output a load takes (Z1). Every stream takes a load's literals at once, so all have decoded as
/// many when the loop stops: the count it returns.
fn decode_loads(comptime count: usize, comptime bits_max: u4, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8, readers: *[count]codec.BackwardBitReader) usize {
    const per_load = comptime literals_per_load(bits_max);
    // Held here: a write to the output may alias the memory the slices and positions came from, so
    // a read of it would repeat after every write.
    var sources = streams;
    var positions: [count]usize = undefined;
    for (&positions, readers) |*position, *reader| position.* = reader.position;
    defer for (readers, positions) |*reader, position| {
        reader.position = position;
    };
    const runs = runs_of(count, per_load, outputs);
    for (0..runs[0].len) |pass| {
        if (!loadable(count, positions)) return pass * per_load;
        decode_pass(count, bits_max, per_load, table, &sources, &positions, &runs, pass);
    }
    return runs[0].len * per_load;
}

/// Whether every stream has the bits a load takes.
inline fn loadable(comptime count: usize, positions: [count]usize) bool {
    inline for (positions) |position| {
        if (position < constants.fast_read_position_min) return false;
    }
    return true;
}

/// Each output as runs of `per_load` literals, one a load, as many as the shortest output holds.
inline fn runs_of(comptime count: usize, comptime per_load: usize, outputs: [count][]u8) [count][][per_load]u8 {
    var len_min = outputs[0].len;
    for (outputs[1..]) |output| len_min = @min(len_min, output.len);
    var runs: [count][][per_load]u8 = undefined;
    inline for (&runs, outputs) |*run, output| run.* = std.mem.bytesAsSlice([per_load]u8, output[0 .. len_min / per_load * per_load]);
    return runs;
}

/// Decodes run `pass` of every stream from one load of each, a literal of each in turn, and moves
/// each position past the codes it took.
inline fn decode_pass(comptime count: usize, comptime bits_max: u4, comptime per_load: usize, table: *const huffman.Table, sources: *const [count][]const u8, positions: *[count]usize, runs: *const [count][][per_load]u8, pass: usize) void {
    var words: [count]u64 = undefined;
    inline for (&words, sources, positions) |*word, source, position| word.* = load(source, position);
    var used: [count]usize = @splat(0);
    inline for (0..per_load) |literal| {
        inline for (&words, runs, &used) |*word, run, *bits| {
            // The top `bits_max` bits index the table, which holds 2^11 cells: the shift leaves
            // fewer bits than the index type holds, so the truncation changes none, and a code's
            // length is at most 11, which the shift's type holds (decision 17 keeps checks out of
            // per-symbol loops).
            const cell = table.cells[@as(u11, @truncate(word.* >> (@bitSizeOf(u64) - @as(u7, bits_max))))];
            run[pass][literal] = cell.symbol;
            word.* <<= @as(u6, @truncate(cell.bits));
            bits.* += cell.bits;
        }
    }
    inline for (positions, used) |*position, bits| position.* -= bits;
}

/// The 8 octets whose last holds the bit below `position`, least significant first, shifted so
/// that bit leads: at least `constants.fast_read_position_min` bits below the position lead the
/// word, the first to be read most significant (RFC 8878 §4.1).
inline fn load(stream: []const u8, position: usize) u64 {
    const below = position - constants.fast_read_position_min;
    const lag: u3 = @truncate(below);
    return std.mem.readInt(u64, stream[below / @bitSizeOf(u8) ..][0..@sizeOf(u64)], .little) << ~lag;
}

test {
    _ = @import("fast_literals_test.zig");
}
