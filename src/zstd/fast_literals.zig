//! The Zstandard decoder's literal decoding fast path (decision 16, claim Z1 of decision 14).
//!
//! Each Huffman-coded stream is read backward with one 8-octet little-endian load for as many
//! literals as the load's bits hold at the table's longest code, while at least
//! `constants.fast_read_position_min` bits remain before the stream's position. Four streams
//! decode in one loop, a load of each in turn, so the lookups of one stream do not wait on
//! another's (Z1). Literals go to the state's literal buffer, whose size is fixed, so the loop
//! needs no output margin. The checked decoder takes each stream from where the loop left it, in
//! stream order, and requires it to end exactly at its first bit.
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
    // No code is shorter than a bit, so each load decodes this many literals at least.
    const per_load = constants.fast_read_position_min / @as(usize, table.bits_max);
    if (claims.interleaved_streams) {
        decode_interleaved(count, table, streams, outputs, &readers, &done, per_load);
    } else {
        for (0..count) |index| decode_serial(table, streams[index], outputs[index], &readers[index], &done[index], per_load);
    }
    for (&readers, outputs, done) |*reader, output, decoded| try huffman.decode_rest(table, reader, output[decoded..]);
}

fn decode_checked(comptime count: usize, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8) huffman.Error!void {
    for (streams, outputs) |stream, output| try huffman.decode_stream(table, stream, output);
}

/// Whether a stream has the bits and the output the next load takes.
inline fn loadable(reader: *const codec.BackwardBitReader, output_left: usize, per_load: usize) bool {
    return reader.position >= constants.fast_read_position_min and output_left >= per_load;
}

/// One load of each stream in turn, while every stream can take one (Z1).
fn decode_interleaved(comptime count: usize, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8, readers: *[count]codec.BackwardBitReader, done: *[count]usize, per_load: usize) void {
    // Each pass decodes `per_load` literals of every stream.
    for (0..outputs[0].len / per_load + 1) |_| {
        inline for (0..count) |index| {
            if (!loadable(&readers[index], outputs[index].len - done[index], per_load)) return;
        }
        inline for (0..count) |index| {
            decode_load(table, streams[index], &readers[index].position, outputs[index][done[index]..][0..per_load]);
            done[index] += per_load;
        }
    }
}

/// One stream's loads, while it can take one.
fn decode_serial(table: *const huffman.Table, stream: []const u8, output: []u8, reader: *codec.BackwardBitReader, done: *usize, per_load: usize) void {
    for (0..output.len / per_load + 1) |_| {
        if (!loadable(reader, output.len - done.*, per_load)) return;
        decode_load(table, stream, &reader.position, output[done.*..][0..per_load]);
        done.* += per_load;
    }
}

/// Decodes `output.len` literals from one load of the 8 octets that end at `position`'s octet: each
/// the cell the next `bits_max` bits index, as the checked decoder takes it (RFC 8878 §4.2.2).
inline fn decode_load(table: *const huffman.Table, stream: []const u8, position: *usize, output: []u8) void {
    const end = std.math.divCeil(usize, position.*, @bitSizeOf(u8)) catch unreachable;
    const start = end - @sizeOf(u64);
    const word = std.mem.readInt(u64, stream[start..][0..@sizeOf(u64)], .little);
    var bits_left: usize = position.* - start * @bitSizeOf(u8);
    const mask = (@as(u64, 1) << table.bits_max) - 1;
    for (output) |*literal| {
        const shift: u6 = @intCast(bits_left - table.bits_max);
        const cell = table.cells[@intCast((word >> shift) & mask)];
        literal.* = cell.symbol;
        bits_left -= cell.bits;
    }
    position.* = start * @bitSizeOf(u8) + bits_left;
}

test {
    _ = @import("fast_literals_test.zig");
}
