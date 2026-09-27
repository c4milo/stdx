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
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const Claims = @import("claims.zig").Claims;
const fast_reader = @import("fast_reader.zig");

/// Decodes what it can of each of `streams`, one or four, from where `readers` stand, as the
/// checked decoder would, and returns how many literals of each it wrote: the checked decoder takes
/// each stream from there.
pub fn decode(comptime count: usize, comptime claims: Claims, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8, readers: *[count]codec.BackwardBitReader) [count]usize {
    if (!claims.interleaved_streams) return decode_each(count, claims, table, streams, outputs, readers);
    var done: [count]usize = undefined;
    // The table's longest code fixes the loop's shifts and its literals per load.
    switch (table.bits_max) {
        inline 1...constants.huffman_bits_max => |bits_max| {
            done = if (claims.pairs and table.pairs_ready)
                decode_pair_loads(count, bits_max, table, streams, outputs, readers)
            else
                @splat(decode_loads(count, bits_max, table, streams, outputs, readers));
            decode_tails(count, bits_max, table, streams, outputs, readers, &done);
        },
        // huffman.build gives a Max_Number_of_Bits from 1 to 11.
        else => unreachable,
    }
    return done;
}

/// `decode` one stream after another, when the claim of Z1 is off.
fn decode_each(comptime count: usize, comptime claims: Claims, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8, readers: *[count]codec.BackwardBitReader) [count]usize {
    comptime var one_claims = claims;
    one_claims.interleaved_streams = true;
    var done: [count]usize = undefined;
    for (&done, streams, outputs, readers) |*decoded, stream, output, *reader| {
        decoded.* = decode(1, one_claims, table, .{stream}, .{output}, reader[0..1])[0];
    }
    return done;
}

/// Builds `table.pairs` from its cells (claim Z2). The cell of the next Max_Number_of_Bits bits
/// names the literal whose code they begin with, and the literal after it when that one's code
/// ends within the same bits: the bits past the first code index the cells again, zeros below
/// them, and a code no longer than those bits is theirs whatever the zeros stand for. So the
/// second literals of every first code of one length form one row, which each such literal's run
/// of cells takes with its own literal added. The runs of one length lie together, so one row at a
/// time serves them.
pub fn build_pairs(table: *huffman.Table) void {
    const len = @as(usize, 1) << table.bits_max;
    // The length whose row the scratch holds; none is 0 bits long.
    var row_length: u8 = 0;
    var index: usize = 0;
    // Each run is one literal's cells, so at most 256 runs fill the table.
    for (0..constants.literal_symbols) |_| {
        if (index == len) break;
        const first = table.cells[index];
        const length: u4 = @truncate(first.bits);
        const run = len >> length;
        const row = table.scratch.rows[0..run];
        if (first.bits != row_length) build_row(table, length, row);
        row_length = first.bits;
        fill_pairs(table.pairs[index..][0..run], row, first.symbol);
        index += run;
    }
    assert(index == len);
    table.pairs_ready = true;
}

/// The pairs of a first code of `length` bits, but its literal: for each value of the bits after
/// it, the literal whose code they hold, when it ends within them, and the bits both codes take.
fn build_row(table: *const huffman.Table, length: u4, row: []huffman.Pair) void {
    const rest = table.bits_max - length;
    for (row, 0..) |*cell, after| {
        const second = table.cells[after << length];
        const both = second.bits <= rest;
        cell.* = .{
            .literals = if (both) @as(u16, second.symbol) << @bitSizeOf(u8) else 0,
            .bits = if (both) length + second.bits else length,
            .count = @as(u8, 1) + @intFromBool(both),
        };
    }
}

/// A literal's run of pairs: its row with the literal in each cell's first octet, a vector of cells
/// a store where the run holds one.
fn fill_pairs(pairs: []huffman.Pair, row: []const huffman.Pair, literal: u8) void {
    const Cells = @Vector(pairs_per_store, u32);
    const words: []u32 = @ptrCast(pairs);
    const row_words: []const u32 = @ptrCast(row);
    // The literal is the first octet of a pair's literals, its low 8 bits.
    const first: Cells = @splat(literal);
    if (pairs.len < pairs_per_store) {
        for (words, row_words) |*pair, cell| pair.* = cell | literal;
        return;
    }
    for (0..pairs.len / pairs_per_store) |store| {
        const cells: Cells = row_words[store * pairs_per_store ..][0..pairs_per_store].*;
        words[store * pairs_per_store ..][0..pairs_per_store].* = cells | first;
    }
}

/// The pairs one vector store writes: 4, 16 octets.
const pairs_per_store = 4;

/// The literals a pair writes at most, each step's store.
const pair_len = 2;

/// Decodes the streams' literals in pairs (Z2): one load of each stream, then a step of each in
/// turn, each step's pair writing two literals and moving past the one or two it holds. A pass
/// needs a load's bits in every stream and room for a pass's stores in every output; the loop
/// returns how many literals of each stream it wrote.
fn decode_pair_loads(comptime count: usize, comptime bits_max: u4, table: *const huffman.Table, streams: [count][]const u8, outputs: [count][]u8, readers: *[count]codec.BackwardBitReader) [count]usize {
    const steps = comptime literals_per_load(bits_max);
    var sources = streams;
    var positions: [count]usize = undefined;
    for (&positions, readers) |*position, *reader| position.* = reader.position;
    defer for (readers, positions) |*reader, position| {
        reader.position = position;
    };
    var written: [count]usize = @splat(0);
    var shortest = outputs[0].len;
    for (outputs[1..]) |output| shortest = @min(shortest, output.len);
    // Each pass writes `steps` literals of each stream at least.
    for (0..shortest / steps + 1) |_| {
        if (!loadable(count, positions) or !pairs_fit(count, steps, outputs, written)) break;
        pair_pass(count, bits_max, steps, table, &sources, &positions, outputs, &written);
    }
    return written;
}

/// Whether every output has room for a pass's stores past what it holds.
inline fn pairs_fit(comptime count: usize, comptime steps: usize, outputs: [count][]u8, written: [count]usize) bool {
    inline for (outputs, written) |output, len| {
        if (output.len - len < steps * pair_len) return false;
    }
    return true;
}

/// One pass of `decode_pair_loads`: a load of each stream, then `steps` pairs of each in turn.
/// `pairs_fit` found the room for every store, and the pairs table holds 2^11 cells, which the
/// word's top `bits_max` bits index whole (decision 17 keeps checks out of per-symbol loops).
inline fn pair_pass(comptime count: usize, comptime bits_max: u4, comptime steps: usize, table: *const huffman.Table, sources: *const [count][]const u8, positions: *[count]usize, outputs: [count][]u8, written: *[count]usize) void {
    var words: [count]u64 = undefined;
    inline for (&words, sources, positions) |*word, source, position| word.* = load(source, position);
    var used: [count]usize = @splat(0);
    inline for (0..steps) |_| {
        inline for (&words, outputs, written, &used) |*word, output, *len, *bits| {
            const pair = table.pairs[@as(u11, @truncate(word.* >> (@bitSizeOf(u64) - @as(u7, bits_max))))];
            std.mem.writeInt(u16, output.ptr[len.*..][0..pair_len], pair.literals, .little);
            len.* += pair.count;
            const pair_bits: u6 = @truncate(pair.bits);
            word.* <<= pair_bits;
            bits.* += pair_bits;
        }
    }
    inline for (positions, used) |*position, bits| position.* -= bits;
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
