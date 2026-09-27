//! The Zstandard decoder's sequence execution fast path (decision 16, claim Z4 of decision 14).
//!
//! The loop runs while the output has `constants.output_slack` octets of room, checked once at the
//! top of each iteration. It reads a sequence's bits with one 8-octet little-endian load per field,
//! which the stream allows while `constants.sequence_position_min` bits remain before the
//! position. It copies literals and matches straight into the caller's output, 16 octets at a time
//! and overrunning into the room the margin leaves (Z4), at most `constants.chunk_len_max` octets
//! of a run per iteration. A match reads the loop's own output, and the window for what came
//! before. The window, the checksum and the frame's count take the loop's octets once, when it
//! ends.
//!
//! It decodes only what is valid and common. It leaves the last sequence of a block, and any
//! sequence the checked path would refuse, to the checked path, without using its bits: the checked
//! path decodes it again, and refuses it or ends the block. So both paths write the same octets and
//! give the same verdict on every input (decision 16).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const sequences = @import("sequences.zig");
const block = @import("block.zig");
const Claims = @import("claims.zig").Claims;
const work_module = @import("work.zig");

/// Runs the loop over `run` until the margins or a sequence it leaves stop it.
pub fn execute(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) void {
    // Each iteration writes an octet or more, or decodes a sequence, which writes at least 3.
    const iterations_max = sink.room() + run.stream.left + 1;
    for (0..iterations_max) |_| {
        if (sink.room() < constants.output_slack) return;
        const written = sink.written;
        const left = run.stream.left;
        if (!step(Window, claims, run, context, sink)) return;
        assert(sink.written > written or run.stream.left < left);
    }
}

/// One iteration: the next sequence when the last is copied, then its literals, then its match
/// while the margin still holds. Returns false when the loop leaves the sequence.
inline fn step(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) bool {
    if (run.literals_left == 0 and run.match_left == 0) {
        if (!next_sequence(run, context, sink.reach())) return false;
    }
    if (run.literals_left > 0) {
        copy_literals(Window, claims, run, context, sink);
        if (run.literals_left > 0 or sink.room() < constants.output_slack) return true;
    }
    if (run.match_left > 0) copy_match(Window, claims, run, sink);
    return true;
}

/// A backward stream read from one 8-octet load at a time: the load's bits below the position are
/// `bits_left`, taken from the top, and a read that needs more loads again at the position (RFC
/// 8878 §4.1). A load needs `constants.fast_read_position_min` bits before the position.
const Reader = struct {
    octets: []const u8,
    word: u64,
    /// The load's first octet, and its bits not yet read.
    start: usize,
    bits_left: usize,

    fn init(octets: []const u8, at: usize) Reader {
        var reader: Reader = .{ .octets = octets, .word = 0, .start = 0, .bits_left = 0 };
        reader.load(at);
        return reader;
    }

    inline fn load(self: *Reader, at: usize) void {
        const end = std.math.divCeil(usize, at, @bitSizeOf(u8)) catch unreachable;
        self.start = end - @sizeOf(u64);
        self.word = std.mem.readInt(u64, self.octets[self.start..][0..@sizeOf(u64)], .little);
        self.bits_left = at - self.start * @bitSizeOf(u8);
    }

    /// The stream's position: the bits before it are not read yet.
    fn position(self: *const Reader) usize {
        return self.start * @bitSizeOf(u8) + self.bits_left;
    }

    /// `count` bits, the first read most significant.
    inline fn read(self: *Reader, count: u6) u64 {
        if (count > self.bits_left) self.load(self.position());
        self.bits_left -= count;
        const mask = (@as(u64, 1) << count) - 1;
        return std.math.shr(u64, self.word, self.bits_left) & mask;
    }
};

/// Decodes the next sequence as sequences.next does, and checks it as the checked path does before
/// its first copy. Returns false, having changed nothing, for a sequence the loop leaves: the last
/// of the block, one too close to the stream's start, and one the checked path refuses.
fn next_sequence(run: *block.Run, context: block.Context, reach: usize) bool {
    const stream = &run.stream;
    if (stream.left <= 1 or stream.overflowed or stream.position < constants.sequence_position_min) return false;
    var reader = Reader.init(context.block[run.stream_offset..][0..run.stream_len], stream.position);
    const tables = context.tables;
    const literals_length = tables.cells(.literals_length)[stream.states[sequences.slot(.literals_length)]];
    const offset = tables.cells(.offset)[stream.states[sequences.slot(.offset)]];
    const match_length = tables.cells(.match_length)[stream.states[sequences.slot(.match_length)]];
    const offset_code: u5 = @intCast(offset.symbol);
    const offset_value = (@as(u32, 1) << offset_code) + @as(u32, @intCast(reader.read(offset_code)));
    const match_len = constants.match_length_baselines[match_length.symbol] + @as(u32, @intCast(reader.read(constants.match_length_extra_bits[match_length.symbol])));
    const literals_len = constants.literals_length_baselines[literals_length.symbol] + @as(u32, @intCast(reader.read(constants.literals_length_extra_bits[literals_length.symbol])));
    var states = stream.states;
    states[sequences.slot(.literals_length)] = @intCast(literals_length.baseline + reader.read(@intCast(literals_length.bits)));
    states[sequences.slot(.match_length)] = @intCast(match_length.baseline + reader.read(@intCast(match_length.bits)));
    states[sequences.slot(.offset)] = @intCast(offset.baseline + reader.read(@intCast(offset.bits)));
    if (literals_len > run.section.len - run.literals_used) return false;
    const promised_len = run.promised_len +| match_len;
    if (promised_len > context.block_len_max) return false;
    var repeats = context.repeats.*;
    const distance = sequences.resolve_offset(&repeats, offset_value, literals_len) catch return false;
    // The checked path checks the reach when the match starts, after the literals.
    if (distance > context.window_len or distance > reach + literals_len) return false;
    stream.position = reader.position();
    stream.states = states;
    stream.left -= 1;
    context.repeats.* = repeats;
    run.promised_len = promised_len;
    run.offset = distance;
    run.literals_left = literals_len;
    run.match_left = match_len;
    work_module.add(context.work, work_module.of(1));
    return true;
}

/// Copies up to `chunk_len_max` of the sequence's literals.
fn copy_literals(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) void {
    const len: u32 = @min(run.literals_left, constants.chunk_len_max);
    switch (run.section.source) {
        .block => copy_forward(claims, sink.output, sink.written, context.block[run.section.offset + run.literals_used ..], len),
        .buffer => copy_forward(claims, sink.output, sink.written, context.literals_buffer[run.literals_used..], len),
        .repeated => @memset(sink.output[sink.written..][0..len], run.section.octet),
    }
    sink.commit(len);
    run.literals_used += len;
    run.literals_left -= len;
}

/// Copies `len` octets of `source` to `target`: in chunks of `copy_chunk_len` when the source holds
/// whole chunks, overrunning `len` by less than one, and exactly otherwise.
inline fn copy_forward(comptime claims: Claims, output: []u8, target: usize, source: []const u8, len: usize) void {
    const chunked_len = std.mem.alignForward(usize, len, constants.copy_chunk_len);
    if (!claims.chunk_copies or source.len < chunked_len) {
        @memcpy(output[target..][0..len], source[0..len]);
        return;
    }
    for (0..chunked_len / constants.copy_chunk_len) |chunk| {
        const at = chunk * constants.copy_chunk_len;
        output[target + at ..][0..constants.copy_chunk_len].* = source[at..][0..constants.copy_chunk_len].*;
    }
}

/// Copies up to `chunk_len_max` of the sequence's match: what lies before the call's unsynced
/// output from the window, and the rest from the output.
fn copy_match(comptime Window: type, comptime claims: Claims, run: *block.Run, sink: *block.Sink(Window)) void {
    const len: u32 = @min(run.match_left, constants.chunk_len_max);
    const target = sink.written;
    const own_len = target - sink.synced.*;
    var copied: usize = 0;
    if (run.offset > own_len) {
        const distance = run.offset - own_len;
        copied = @min(len, distance);
        sink.window.copy_back(distance, sink.output[target..][0..copied]);
    }
    if (copied < len) copy_within(claims, sink.output, target + copied, run.offset, len - copied);
    sink.commit(len);
    run.match_left -= len;
}

/// Copies `len` octets to `target` from `distance` before it: in chunks of `copy_chunk_len` where
/// the distance leaves room for one, a fill for a distance of 1, and octet by octet otherwise. A
/// chunk may write less than its length past `len`, into the margin, and reads only octets written
/// before.
inline fn copy_within(comptime claims: Claims, output: []u8, target: usize, distance: usize, len: usize) void {
    assert(distance > 0);
    const source = target - distance;
    if (claims.chunk_copies and distance >= constants.copy_chunk_len) {
        const chunks = std.math.divCeil(usize, len, constants.copy_chunk_len) catch unreachable;
        for (0..chunks) |chunk| {
            const at = chunk * constants.copy_chunk_len;
            output[target + at ..][0..constants.copy_chunk_len].* = output[source + at ..][0..constants.copy_chunk_len].*;
        }
    } else if (distance >= len) {
        @memcpy(output[target..][0..len], output[source..][0..len]);
    } else if (distance == 1) {
        @memset(output[target..][0..len], output[source]);
    } else {
        for (0..len) |index| output[target + index] = output[source + index];
    }
}

test "the fast reader reads what the checked backward reader reads, across its loads" {
    const codec = @import("codec");
    var generator = codec.split.Generator.init(1);
    var stream: [64]u8 = undefined;
    for (&stream) |*octet| octet.* = @truncate(generator.next());
    stream[stream.len - 1] |= 0x80;
    var checked = codec.BackwardBitReader.init(&stream).?;
    var fast = Reader.init(&stream, checked.position);
    // Reads of up to 31 bits, so several reads outrun one load, while a load stays in the stream.
    while (checked.position >= constants.fast_read_position_min + 31) {
        const count: u6 = @intCast(generator.below(32));
        try std.testing.expectEqual(checked.read(count), fast.read(count));
        try std.testing.expectEqual(checked.position, fast.position());
    }
}

test {
    _ = @import("fast_sequences_test.zig");
}
