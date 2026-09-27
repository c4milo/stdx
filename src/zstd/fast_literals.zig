//! The Zstandard decoder's literal decoding fast path (decision 16, claim Z1 of decision 14).
//!
//! Each Huffman-coded stream is read backward from one 8-octet little-endian load at a time, which
//! holds at least `constants.fast_read_position_min` bits below the stream's position, shifted so
//! the position's bit leads. A load decodes as many literals as those bits hold at the table's
//! longest code: each takes the cell the word's top `bits_max` bits index, and shifts its code out.
//! Four streams decode in one loop, a literal of each in turn, so the lookups of one stream do not
//! wait on another's (Z1). Literals go to the state's literal buffer, whose size is fixed, so the
//! loop needs no output margin. The streams' last literals then decode in turns as well, a load's
//! of each stream a pass, each read against the bits its stream has left, from the stream's first
//! 8 octets where fewer lie before the position; the checked decoder takes each stream from where
//! they stop, in stream order, and requires it to end exactly at its first bit.

const std = @import("std");
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const Claims = @import("claims.zig").Claims;
const fast_reader = @import("fast_reader.zig");

/// Decodes what it can of each of `streams`, one or four, from where `readers` stand, as the
/// checked decoder would, and returns how many literals of each it wrote: the checked decoder takes
/// each stream from there.
pub fn decode(comptime count: usize, comptime claims: Claims, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8, readers: *[count]codec.BackwardBitReader) [count]usize {
    var done: [count]usize = @splat(0);
    // The table's longest code fixes the loop's shifts and its literals per load.
    switch (table.bits_max) {
        inline 1...constants.huffman_bits_max => |bits_max| {
            if (claims.interleaved_streams) {
                done = @splat(decode_loads(count, bits_max, table, streams, outputs, readers));
                decode_tails(count, bits_max, table, streams, outputs, readers, &done);
            } else {
                for (&done, streams, outputs, readers) |*decoded, stream, output, *reader| {
                    decoded.* = decode_loads(1, bits_max, table, .{stream}, .{output}, reader[0..1]);
                    var one: [1]usize = .{decoded.*};
                    decode_tails(1, bits_max, table, .{stream}, .{output}, reader[0..1], &one);
                    decoded.* = one[0];
                }
            }
        },
        // huffman.build gives a Max_Number_of_Bits from 1 to 11.
        else => unreachable,
    }
    return done;
}

pub const head_of = fast_reader.head_of;

/// One stream's last literals, as `decode_tails` takes them.
const Tail = struct {
    stream: []const u8,
    head: u64,
    position: usize,
    output: []u8,
    done: usize,
    /// Whether a code was longer than the bits left, which the checked decoder refuses.
    stopped: bool,

    fn active(self: *const Tail) bool {
        return !self.stopped and self.done < self.output.len;
    }

    /// Decodes up to `per_load` literals from one load: the 8 octets that end at the position's
    /// octet, holding a load's literals' bits, or the stream's first 8 within its first 64 bits,
    /// the bits before its first reading as zeros, as the checked decoder reads them (RFC 8878
    /// §4.2.2). A code longer than the bits left stops the stream.
    inline fn pass(self: *Tail, comptime bits_max: u4, comptime per_load: usize, table: *const huffman.Table) void {
        if (!self.active()) return;
        var word = fast_reader.leading(self.stream, self.head, self.position);
        inline for (0..per_load) |_| {
            if (self.done == self.output.len) return;
            // As in `decode_pass`, the top `bits_max` bits index the table, and a code's length is
            // at most 11.
            const cell = table.cells[@as(u11, @truncate(word >> (@bitSizeOf(u64) - @as(u7, bits_max))))];
            if (cell.bits > self.position) {
                self.stopped = true;
                return;
            }
            self.output[self.done] = cell.symbol;
            self.done += 1;
            word <<= @as(u6, @truncate(cell.bits));
            self.position -= cell.bits;
        }
    }
};

/// Decodes the literals the loads left, a load's of each stream in turn, so one stream's lookups
/// do not wait on another's, until every stream is done or stopped.
fn decode_tails(comptime count: usize, comptime bits_max: u4, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8, readers: *[count]codec.BackwardBitReader, done: *[count]usize) void {
    const per_load = comptime literals_per_load(bits_max);
    var tails: [count]Tail = undefined;
    var longest: usize = 0;
    for (&tails, streams, outputs, readers, done) |*tail, stream, output, *reader, decoded| {
        tail.* = .{ .stream = stream, .head = head_of(stream), .position = reader.position, .output = output, .done = decoded, .stopped = false };
        longest = @max(longest, output.len - decoded);
    }
    defer for (&tails, readers, done) |tail, *reader, *decoded| {
        reader.position = tail.position;
        decoded.* = tail.done;
    };
    // A pass decodes a literal of every active stream at least, or stops it.
    for (0..longest) |_| {
        inline for (&tails) |*tail| tail.pass(bits_max, per_load, table);
        var active = false;
        for (&tails) |*tail| active = active or tail.active();
        if (!active) return;
    }
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
