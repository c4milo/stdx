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
const fse = @import("fse.zig");
const sequences = @import("sequences.zig");
const block = @import("block.zig");
const Claims = @import("claims.zig").Claims;
const work_module = @import("work.zig");

/// What the loop reads for every sequence of a block, found once per call: the three codes' tables,
/// which change only between blocks, and the sequence stream's octets.
const Block = struct {
    cells: [codes.len][]const fse.Entry,
    stream: []const u8,
};

const codes = [_]sequences.Code{ .literals_length, .offset, .match_length };

/// Runs the loop over `run` until the margins or a sequence it leaves stop it. The frame's count
/// takes the loop's octets when it ends.
pub fn execute(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) void {
    // The loop leaves a block's last sequence, and a block of none has no tables to find.
    if (run.stream.left <= 1) return;
    const start = sink.written;
    defer sink.frame_len.* += sink.written - start;
    var found: Block = .{ .cells = undefined, .stream = context.block[run.stream_offset..][0..run.stream_len] };
    for (codes, &found.cells) |code, *cells| cells.* = context.tables.cells(code);
    // Each iteration writes an octet or more, or decodes a sequence, which writes at least 3.
    const iterations_max = sink.room() + run.stream.left + 1;
    for (0..iterations_max) |_| {
        if (sink.room() < constants.output_slack) return;
        if (run.literals_left == 0 and run.match_left == 0) {
            run_whole(Window, claims, run, context, &found, sink);
            if (sink.room() < constants.output_slack) return;
        }
        const written = sink.written;
        const left = run.stream.left;
        if (!step(Window, claims, run, context, &found, sink)) return;
        assert(sink.written > written or run.stream.left < left);
    }
}

/// The loop proper: whole sequences whose literals and match fit `chunk_len_max`, each decoded,
/// checked and copied in one iteration, with the loop's state held in a `Whole` and written back
/// when it stops. It stops, having left the sequence unread, where `next_sequence` would return
/// false, and at a sequence too long for one iteration, which `step` then takes in chunks.
fn run_whole(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, found: *const Block, sink: *block.Sink(Window)) void {
    var whole = Whole.start(Window, run, context, sink);
    defer whole.finish(Window, run, context, sink);
    for (0..run.stream.left) |_| {
        if (!whole.take(Window, claims, found, context, sink, run.stream.overflowed)) return;
    }
}

/// What `run_whole` holds while it runs: the stream's place, the states, the Repeated_Offsets,
/// the block's counts and the output's, and the history's split between window and output.
const Whole = struct {
    position: usize,
    states: [codes.len]u16,
    left: u32,
    repeats: [constants.repeated_offsets_initial.len]u32,
    literals_used: u32,
    promised_len: u32,
    written: usize,
    taken: usize,
    synced: usize,
    window_reach: usize,
    section: @FieldType(block.Run, "section"),
    literal_source: []const u8,

    fn start(comptime Window: type, run: *const block.Run, context: block.Context, sink: *const block.Sink(Window)) Whole {
        return .{
            .position = run.stream.position,
            .states = run.stream.states,
            .left = run.stream.left,
            .repeats = context.repeats.*,
            .literals_used = run.literals_used,
            .promised_len = run.promised_len,
            .written = sink.written,
            .taken = 0,
            .synced = sink.synced.*,
            .window_reach = sink.window.reach(),
            .section = run.section,
            .literal_source = switch (run.section.source) {
                .block => context.block[run.section.offset..],
                .buffer => context.literals_buffer,
                .repeated => &.{},
            },
        };
    }

    fn finish(self: *const Whole, comptime Window: type, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) void {
        run.stream.position = self.position;
        run.stream.states = self.states;
        run.stream.left = self.left;
        context.repeats.* = self.repeats;
        run.literals_used = self.literals_used;
        run.promised_len = self.promised_len;
        sink.written = self.written;
        work_module.add(context.work, work_module.of(self.taken));
    }

    /// Takes one whole sequence, or returns false having taken nothing.
    inline fn take(self: *Whole, comptime Window: type, comptime claims: Claims, found: *const Block, context: block.Context, sink: *block.Sink(Window), overflowed: bool) bool {
        if (self.left <= 1 or overflowed or self.position < constants.sequence_position_min) return false;
        if (sink.output.len - self.written < constants.output_slack) return false;
        var reader = Reader.init(found.stream, self.position);
        const decoded = decode(&reader, found, self.states);
        const distance, const repeats = self.check(decoded, context) orelse return false;
        self.copy(Window, claims, sink, decoded, distance);
        self.position = reader.position();
        self.states = decoded.states;
        self.left -= 1;
        self.repeats = repeats;
        self.literals_used += decoded.literals_len;
        self.promised_len +|= decoded.match_len;
        self.written += decoded.literals_len + decoded.match_len;
        self.taken += 1;
        if (sink.window_each) {
            sink.written = self.written;
            sink.sync();
            self.synced = sink.synced.*;
            self.window_reach = sink.window.reach();
        }
        return true;
    }

    /// The checks the checked path makes before a sequence's first copy, and the loop's own bound on
    /// one iteration's copies. Returns the offset and the Repeated_Offsets after it, or null.
    inline fn check(self: *const Whole, decoded: Decoded, context: block.Context) ?struct { u32, [constants.repeated_offsets_initial.len]u32 } {
        if (decoded.literals_len > self.section.len - self.literals_used) return null;
        if (decoded.literals_len + decoded.match_len > constants.chunk_len_max) return null;
        if (self.promised_len +| decoded.match_len > context.block_len_max) return null;
        const distance, const repeats = resolve(self.repeats, decoded.offset_value, decoded.literals_len) orelse return null;
        // The checked path checks the reach when the match starts, after the literals.
        const reach = self.window_reach + (self.written - self.synced) + decoded.literals_len;
        if (distance > context.window_len or distance > reach) return null;
        return .{ distance, repeats };
    }

    /// The sequence's literals, then its match: what lies before the unsynced output from the
    /// window, and the rest from the output.
    inline fn copy(self: *const Whole, comptime Window: type, comptime claims: Claims, sink: *block.Sink(Window), decoded: Decoded, distance: u32) void {
        const output = sink.output;
        switch (self.section.source) {
            .block, .buffer => copy_forward(claims, output, self.written, self.literal_source[self.literals_used..], decoded.literals_len),
            .repeated => @memset(output[self.written..][0..decoded.literals_len], self.section.octet),
        }
        const target = self.written + decoded.literals_len;
        const own_len = target - self.synced;
        var copied: usize = 0;
        if (distance > own_len) {
            copied = @min(decoded.match_len, distance - own_len);
            sink.window.copy_back(distance - own_len, output[target..][0..copied]);
        }
        if (copied < decoded.match_len) copy_within(claims, output, target + copied, distance, decoded.match_len - copied);
    }
};

/// A sequence's values and the states after it, as sequences.next reads them.
const Decoded = struct {
    literals_len: u32,
    offset_value: u32,
    match_len: u32,
    states: [codes.len]u16,
};

/// Reads a sequence that is not its block's last: its offset, match length and literals length
/// bits, then the next states of literals length, match length and offset (RFC 8878
/// §3.1.1.3.2.1.2). Every cast truncates to a width the tables bound: a read of at most 31 bits, a
/// state below its table's 512 cells (decision 17 keeps checks out of per-symbol loops).
inline fn decode(reader: *Reader, found: *const Block, states: [codes.len]u16) Decoded {
    const literals_length = found.cells[sequences.slot(.literals_length)][states[sequences.slot(.literals_length)]];
    const offset = found.cells[sequences.slot(.offset)][states[sequences.slot(.offset)]];
    const match_length = found.cells[sequences.slot(.match_length)][states[sequences.slot(.match_length)]];
    const offset_code: u5 = @truncate(offset.symbol);
    var decoded: Decoded = undefined;
    decoded.offset_value = (@as(u32, 1) << offset_code) + @as(u32, @truncate(reader.read(offset_code)));
    decoded.match_len = constants.match_length_baselines[match_length.symbol] + @as(u32, @truncate(reader.read(constants.match_length_extra_bits[match_length.symbol])));
    decoded.literals_len = constants.literals_length_baselines[literals_length.symbol] + @as(u32, @truncate(reader.read(constants.literals_length_extra_bits[literals_length.symbol])));
    decoded.states[sequences.slot(.literals_length)] = @truncate(literals_length.baseline + reader.read(@truncate(literals_length.bits)));
    decoded.states[sequences.slot(.match_length)] = @truncate(match_length.baseline + reader.read(@truncate(match_length.bits)));
    decoded.states[sequences.slot(.offset)] = @truncate(offset.baseline + reader.read(@truncate(offset.bits)));
    return decoded;
}

/// One iteration: the next sequence when the last is copied, then its literals, then its match
/// while the margin still holds. Returns false when the loop leaves the sequence.
inline fn step(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, found: *const Block, sink: *block.Sink(Window)) bool {
    if (run.literals_left == 0 and run.match_left == 0) {
        if (!next_sequence(run, context, found, sink.reach())) return false;
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
    inline fn position(self: *const Reader) usize {
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
/// of the block, one too close to the stream's start, and one the checked path refuses. Every cast
/// truncates to a width the tables and RFC 8878 §3.1.1.3.2.1.1 bound: a read of at most 31 bits, a
/// state below its table's 512 cells (decision 17 keeps checks out of per-symbol loops).
fn next_sequence(run: *block.Run, context: block.Context, found: *const Block, reach: usize) bool {
    const stream = &run.stream;
    if (stream.left <= 1 or stream.overflowed or stream.position < constants.sequence_position_min) return false;
    var reader = Reader.init(found.stream, stream.position);
    const decoded = decode(&reader, found, stream.states);
    const literals_len = decoded.literals_len;
    const match_len = decoded.match_len;
    const offset_value = decoded.offset_value;
    const states = decoded.states;
    if (literals_len > run.section.len - run.literals_used) return false;
    const promised_len = run.promised_len +| match_len;
    if (promised_len > context.block_len_max) return false;
    const distance, const repeats = resolve(context.repeats.*, offset_value, literals_len) orelse return false;
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

/// The offset `offset_value` names and the Repeated_Offsets after it, as sequences.resolve_offset
/// gives them (RFC 8878 §3.1.1.5), or null for the offset of 0 the checked path refuses. A new
/// offset, the common case, shifts the three; a repeated one takes the checked function on a copy.
inline fn resolve(repeats: [constants.repeated_offsets_initial.len]u32, offset_value: u32, literals_len: u32) ?struct { u32, [constants.repeated_offsets_initial.len]u32 } {
    if (offset_value > constants.repeat_offset_values) {
        const offset = offset_value - constants.repeat_offset_values;
        return .{ offset, .{ offset, repeats[0], repeats[1] } };
    }
    var after = repeats;
    const offset = sequences.resolve_offset(&after, offset_value, literals_len) catch return null;
    return .{ offset, after };
}

/// Copies up to `chunk_len_max` of the sequence's literals.
fn copy_literals(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) void {
    const len: u32 = @min(run.literals_left, constants.chunk_len_max);
    switch (run.section.source) {
        .block => copy_forward(claims, sink.output, sink.written, context.block[run.section.offset + run.literals_used ..], len),
        .buffer => copy_forward(claims, sink.output, sink.written, context.literals_buffer[run.literals_used..], len),
        .repeated => @memset(sink.output[sink.written..][0..len], run.section.octet),
    }
    advance(Window, sink, len);
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
    advance(Window, sink, len);
    run.match_left -= len;
}

/// Records `len` octets placed at `written`, as `Sink.commit` does but for the frame's count, which
/// `execute` adds when the loop ends.
inline fn advance(comptime Window: type, sink: *block.Sink(Window), len: usize) void {
    sink.written += len;
    if (sink.window_each) sink.sync();
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
