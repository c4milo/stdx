//! The Zstandard decoder's sequence execution fast path (decision 16, claim Z4 of decision 14).
//!
//! The loop runs while the output has `constants.output_slack` octets of room, checked once at the
//! top of each iteration. It reads a sequence's fields from one 8-octet little-endian load, which
//! holds at least `constants.fast_read_position_min` bits below the stream's position, and keeps
//! its state in locals. It copies literals and matches straight into the caller's output, 16 octets
//! at a time and overrunning into the room the margin leaves (Z4), at most `constants.chunk_len_max`
//! octets per iteration. A match reads the call's own output, and the window for what came before
//! (Z6).
//!
//! A sequence the loop cannot take whole goes to `step`, one iteration at a time: the block's last,
//! one whose bits lie in the stream's first `constants.fast_read_position_min` or outnumber the
//! load's, one too long for an iteration, and one left over from a call whose room ran out. `step`
//! reads near the stream's start from the stream's first 8 octets, padded with zeros when the
//! stream is shorter.
//!
//! Both decode only what is valid. They leave any sequence the checked path would refuse to the
//! checked path, without using its bits: the checked path decodes it again and refuses it. So both
//! paths write the same octets and give the same verdict on every input (decision 16).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const sequences = @import("../sequences.zig");
const block = @import("../block.zig");
const Claims = @import("../claims.zig").Claims;
const work_module = @import("../work.zig");
const fast_literals = @import("../fast_literals.zig");
const copy = @import("fast_sequences_copy.zig");

const LiteralsLengthCells = @FieldType(sequences.Tables, "literals_length");
const OffsetCells = @FieldType(sequences.Tables, "offset");
const MatchLengthCells = @FieldType(sequences.Tables, "match_length");

/// What the loop reads for every sequence of a block, found once per call: the three codes' tables,
/// which change only between blocks, and the sequence stream's octets.
const Block = struct {
    tables: *const sequences.Tables,
    stream: []const u8,
    head: u64,
};

const codes = [_]sequences.Code{ .literals_length, .offset, .match_length };

/// Runs the loop over `run` until the margins or a sequence it leaves stop it. The frame's count
/// takes the loop's octets when it ends.
pub fn execute(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) void {
    // A block of no sequences, or none left, has no tables to find.
    if (run.stream.left == 0) return;
    const start = sink.written;
    defer sink.frame_len.* += sink.written - start;
    const stream_octets = context.block[run.stream_offset..][0..run.stream_len];
    const found: Block = .{
        .tables = context.tables,
        .stream = stream_octets,
        .head = fast_literals.head_of(stream_octets),
    };
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

/// Where a block's literals come from: a slice, the block's own octets or the literal buffer, or
/// one octet repeated (RFC 8878 §3.1.1.3.1.1).
const LiteralKind = enum { slice, repeated };

/// The loop proper, for the block's kind of literals.
fn run_whole(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, found: *const Block, sink: *block.Sink(Window)) void {
    switch (run.section.source) {
        .block => run_loop(.slice, Window, claims, run, context, found, sink, context.block[run.section.offset..]),
        .buffer => run_loop(.slice, Window, claims, run, context, found, sink, context.literals_buffer),
        .repeated => run_loop(.repeated, Window, claims, run, context, found, sink, &.{}),
    }
}

/// Whole sequences, each decoded, checked and copied in one iteration, with the loop's state in
/// locals, written back when it stops. It stops, having left the sequence unread, at a sequence
/// that `step` takes, which the module's comment lists, and where `next_sequence` would return
/// false.
fn run_loop(comptime kind: LiteralKind, comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, found: *const Block, sink: *block.Sink(Window), literal_source: []const u8) void {
    const output = sink.output;
    const literals_end = copy.literals_end_of(kind == .slice, claims, run.section.len, literal_source);
    // The block's last sequence reads no states, and `step` takes it, as it takes every sequence
    // when the literal source is shorter than a chunk.
    if (run.stream.left <= 1 or output.len < constants.output_slack or literals_end + copy.overrun_of(kind == .slice, claims) > literal_source.len and kind == .slice) return;
    assert(run.promised_len <= context.block_len_max);
    // What every iteration reads, held here: a write to the output may alias any pointer's target,
    // so a read through one would repeat after every copy.
    const stream = found.stream;
    const tables = found.tables;
    const bounds: Bounds = .{
        // Decision 16's margin: an iteration starts no later than this.
        .written_max = output.len - constants.output_slack,
        .literals_end = literals_end,
        .block_len_max = context.block_len_max,
        .window_len = context.window_len,
    };
    // The literals copied, and the match octets the block promised against Block_Maximum_Size,
    // each at most Block_Maximum_Size: kept narrow, so a sum with a length cannot overflow.
    var literals_used: u32 = run.literals_used;
    var promised_len: u32 = run.promised_len;
    var position = run.stream.position;
    // The cells of the next sequence's states, which the loop carries in their place: it writes
    // each sequence's states to `run.stream` as it takes the sequence, and loads their cells before
    // its copies, which could alias the tables, so the states are read before the copies.
    var cells = cells_of(tables, run.stream.states);
    var repeats = context.repeats.*;
    var written = sink.written;
    var synced = sink.synced.*;
    var taken: usize = 0;
    defer {
        run.stream.position = position;
        run.stream.left -= @intCast(taken);
        context.repeats.* = repeats;
        run.literals_used = literals_used;
        run.promised_len = promised_len;
        sink.written = written;
        work_module.add(context.work, work_module.of(taken));
    }
    for (0..run.stream.left - 1) |_| {
        if (position < constants.fast_read_position_min or written > bounds.written_max) return;
        // The 8 octets whose last holds the position's bit, least significant first (RFC 8878
        // §4.1): at least `fast_read_position_min` bits below the position, which then lead.
        const below = position - constants.fast_read_position_min;
        const lag: u3 = @truncate(below);
        const aligned = std.mem.readInt(u64, stream[below / @bitSizeOf(u8) ..][0..@sizeOf(u64)], .little) << ~lag;
        const literals_length, const offset, const match_length = cells;
        // RFC 8878 §3.1.1.3.2.1.2: the offset, match length and literals length bits, then the
        // states of literals length, match length and offset. Each field starts where the widths
        // before it end, counted from the top of `aligned`. A field read past the load's bits is
        // garbage that `leaves` discards.
        const match_length_at = @as(usize, offset.extra_bits);
        const literals_length_at = match_length_at + match_length.extra_bits;
        const literals_state_at = literals_length_at + literals_length.extra_bits;
        const match_state_at = literals_state_at + literals_length.bits;
        const offset_state_at = match_state_at + match_length.bits;
        const need = offset_state_at + offset.bits;
        const offset_value = offset.base + field(aligned, 0, offset.extra_bits);
        const match_len = match_length.base + field(aligned, match_length_at, match_length.extra_bits);
        const literals_len = literals_length.base + field(aligned, literals_length_at, literals_length.extra_bits);
        const distance, const next_repeats = resolve(repeats, offset_value, literals_len) orelse return;
        if (leaves(bounds, need, constants.fast_read_position_min + @as(usize, lag), literals_used, promised_len, literals_len, match_len, distance)) return;
        const target = written + literals_len;
        const own_len = target - synced;
        if (window_leaves(Window, claims, sink.window, distance, own_len, match_len)) return;
        const states: [codes.len]u16 = .{
            @truncate(literals_length.baseline + field(aligned, literals_state_at, literals_length.bits)),
            @truncate(offset.baseline + field(aligned, offset_state_at, offset.bits)),
            @truncate(match_length.baseline + field(aligned, match_state_at, match_length.bits)),
        };
        run.stream.states = states;
        cells = cells_of(tables, states);
        copy_literal_run(kind, claims, output, written, literal_source, literals_used, run.section.octet, literals_len);
        if (distance > own_len) {
            copy.copy_from_window_chunks(Window, claims, sink.window, output, target, distance, own_len, match_len);
        } else copy.copy_within(claims, output, target, distance, match_len);
        literals_used = @truncate(literals_used + literals_len);
        promised_len = @truncate(promised_len + match_len);
        written = target + match_len;
        position -= need;
        repeats = next_repeats;
        taken += 1;
        sync_each(Window, claims, sink, written, &synced);
    }
}

/// What the loop checks every sequence against, fixed for the call.
const Bounds = struct {
    written_max: usize,
    literals_end: usize,
    block_len_max: u32,
    window_len: u64,
};

/// Whether the loop leaves a sequence, in one branch for every check: the load does not hold its
/// `need` bits, a check of `next_sequence` fails, or one iteration cannot copy it.
inline fn leaves(bounds: Bounds, need: usize, loaded_len: usize, literals_used: u32, promised_len: u32, literals_len: usize, match_len: usize, distance: usize) bool {
    return need > loaded_len or
        literals_used + literals_len > bounds.literals_end or
        literals_len + match_len > constants.chunk_len_max or
        promised_len + match_len > bounds.block_len_max or
        distance > bounds.window_len;
}

/// Whether the loop leaves a match of `len` octets from `distance` before a target where the call's
/// own output holds the last `own_len` octets. The checked path checks the reach when the match
/// starts, after the literals. The call's own output lies within it, so only a match that reads
/// the window can pass it; the loop also leaves a match whose window part it cannot copy in chunks.
inline fn window_leaves(comptime Window: type, comptime claims: Claims, window: *const Window, distance: usize, own_len: usize, len: usize) bool {
    return distance > own_len and !copy.window_chunks_fit(Window, claims, window, distance, own_len, len);
}

/// Moves the call's output into the window after each sequence, when the claim of Z6 is off.
inline fn sync_each(comptime Window: type, comptime claims: Claims, sink: *block.Sink(Window), written: usize, synced: *usize) void {
    if (claims.window_once) return;
    sink.written = written;
    sink.sync();
    synced.* = sink.synced.*;
}

/// Copies a literal run of `kind`: `len` octets of `literal_source` from `start`, in chunks where
/// the claim holds, or `octet` repeated.
inline fn copy_literal_run(comptime kind: LiteralKind, comptime claims: Claims, output: []u8, target: usize, literal_source: []const u8, start: usize, octet: u8, len: usize) void {
    switch (kind) {
        .slice => if (claims.chunk_copies) copy.copy_run_chunks(output, target, literal_source, start, len) else @memcpy(output[target..][0..len], literal_source[start..][0..len]),
        .repeated => copy.fill_run(claims, output, target, octet, len),
    }
}

/// The `count` bits of `aligned` that start `at` bits below its top, the first read most
/// significant (RFC 8878 §4.1). A field of none is 0: the shift past the word's top leaves
/// nothing, whatever `at` truncates to. Every other field ends inside the word, so `at` is below
/// 64, and the tables bound a field to 31 bits.
inline fn field(aligned: u64, at: usize, count: u8) usize {
    const value = ((aligned << @as(u6, @truncate(at))) >> 1) >> ~@as(u6, @truncate(count));
    return @as(u32, @truncate(value));
}

/// The cells of the three states, each the index of its table's array: the array's length bounds
/// every state a table's widths gave, so the truncation changes none (decision 17 keeps checks out
/// of per-symbol loops).
inline fn cells_of(tables: *const sequences.Tables, states: anytype) [codes.len]sequences.Cell {
    return .{
        tables.literals_length[@as(Index(LiteralsLengthCells), @truncate(states[sequences.slot(.literals_length)]))],
        tables.offset[@as(Index(OffsetCells), @truncate(states[sequences.slot(.offset)]))],
        tables.match_length[@as(Index(MatchLengthCells), @truncate(states[sequences.slot(.match_length)]))],
    };
}

/// The integer that holds every index of the array type `Cells`.
fn Index(comptime Cells: type) type {
    return std.math.IntFittingRange(0, @typeInfo(Cells).array.len - 1);
}

/// A sequence's values and the states after it, as sequences.next reads them.
const Decoded = struct {
    literals_len: u32,
    offset_value: u32,
    match_len: u32,
    states: [codes.len]u16,
};

/// Reads a sequence: its offset, match length and literals length bits, then, unless it is its
/// block's last, the next states of literals length, match length and offset (RFC 8878
/// §3.1.1.3.2.1.2). Every cast truncates to a width the tables bound: a read of at most 31 bits, a
/// state below its table's 512 cells (decision 17 keeps checks out of per-symbol loops).
fn decode(reader: *Reader, found: *const Block, states: [codes.len]u16, last: bool) Decoded {
    const literals_length, const offset, const match_length = cells_of(found.tables, states);
    var decoded: Decoded = undefined;
    decoded.offset_value = offset.base + @as(u32, @truncate(reader.read(@truncate(offset.extra_bits))));
    decoded.match_len = match_length.base + @as(u32, @truncate(reader.read(@truncate(match_length.extra_bits))));
    decoded.literals_len = literals_length.base + @as(u32, @truncate(reader.read(@truncate(literals_length.extra_bits))));
    decoded.states = states;
    if (last) return decoded;
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
    /// The stream's first 8 octets, zero past its end when it is shorter: the load of any position
    /// in the stream's first 64 bits.
    head: u64,
    word: u64,
    /// The load's first octet, and its bits not yet read.
    start: usize,
    bits_left: usize,
    /// Whether a read reached before the stream's first bit, as the checked reader marks it.
    overflowed: bool,

    fn init(octets: []const u8, head: u64, at: usize) Reader {
        var reader: Reader = .{ .octets = octets, .head = head, .word = 0, .start = 0, .bits_left = 0, .overflowed = false };
        reader.load(at);
        return reader;
    }

    fn load(self: *Reader, at: usize) void {
        const end = std.math.divCeil(usize, at, @bitSizeOf(u8)) catch unreachable;
        if (end >= @sizeOf(u64)) {
            self.start = end - @sizeOf(u64);
            self.word = std.mem.readInt(u64, self.octets[self.start..][0..@sizeOf(u64)], .little);
        } else {
            self.start = 0;
            self.word = self.head;
        }
        self.bits_left = at - self.start * @bitSizeOf(u8);
    }

    /// The stream's position: the bits before it are not read yet.
    fn position(self: *const Reader) usize {
        return self.start * @bitSizeOf(u8) + self.bits_left;
    }

    /// `count` bits, the first read most significant. Bits before the stream's first read as
    /// zeros and mark the reader overflowed, as the checked reader reads them (RFC 8878 §4.1).
    fn read(self: *Reader, count: u6) u64 {
        if (count > self.bits_left) self.load(self.position());
        const mask = (@as(u64, 1) << count) - 1;
        if (count > self.bits_left) {
            // Only a load from the stream's first octet holds fewer bits than a read takes.
            const value = (self.word & ((@as(u64, 1) << @intCast(self.bits_left)) - 1)) << @intCast(count - self.bits_left);
            self.bits_left = 0;
            self.overflowed = true;
            return value & mask;
        }
        self.bits_left -= count;
        return std.math.shr(u64, self.word, self.bits_left) & mask;
    }

    /// Whether every bit was read and no read reached before the first.
    fn finished(self: *const Reader) bool {
        return self.position() == 0 and !self.overflowed;
    }
};

/// Decodes the next sequence as sequences.next does, and checks it as the checked path does before
/// its first copy. Returns false, having changed nothing, for a sequence the checked path refuses.
fn next_sequence(run: *block.Run, context: block.Context, found: *const Block, reach: usize) bool {
    const stream = &run.stream;
    if (stream.left == 0 or stream.overflowed) return false;
    const last = stream.left == 1;
    var reader = Reader.init(found.stream, found.head, stream.position);
    const decoded = decode(&reader, found, stream.states, last);
    // RFC 8878 §3.1.1.3.2.1.2: a stream that ends before its sequences, or holds bits after the
    // last, is corrupt; the checked path refuses it.
    if (reader.overflowed or (last and !reader.finished())) return false;
    const literals_len = decoded.literals_len;
    const match_len = decoded.match_len;
    if (literals_len > run.section.len - run.literals_used) return false;
    const promised_len = run.promised_len +| match_len;
    if (promised_len > context.block_len_max) return false;
    const distance, const repeats = resolve(context.repeats.*, decoded.offset_value, literals_len) orelse return false;
    // The checked path checks the reach when the match starts, after the literals.
    if (distance > context.window_len or distance > reach + literals_len) return false;
    stream.position = reader.position();
    stream.states = decoded.states;
    stream.left -= 1;
    context.repeats.* = repeats;
    run.promised_len = promised_len;
    run.offset = @intCast(distance);
    run.literals_left = literals_len;
    run.match_left = match_len;
    work_module.add(context.work, work_module.of(1));
    return true;
}

/// The offset `offset_value` names and the Repeated_Offsets after it, as sequences.resolve_offset
/// gives them (RFC 8878 §3.1.1.5), or null for the offset of 0 the checked path refuses. A new
/// offset, the common case, shifts the three. An Offset_Value is below 2^32, as its code's base
/// and extra bits bound it, so the cast to a Repeated_Offset truncates nothing.
inline fn resolve(repeats: [constants.repeated_offsets_initial.len]u32, offset_value: usize, literals_len: usize) ?struct { usize, [constants.repeated_offsets_initial.len]u32 } {
    const first, const second, const third = repeats;
    if (offset_value > constants.repeat_offset_values) {
        const offset: u32 = @truncate(offset_value - constants.repeat_offset_values);
        return .{ offset, .{ offset, first, second } };
    }
    // Offset_Value 1 to 3 names a Repeated_Offset, the next one when the literals length is 0, and
    // the fourth is Repeated_Offset1 - 1 (RFC 8878 §3.1.1.5); the checked path refuses an offset
    // of 0.
    const index = offset_value - 1 + @intFromBool(literals_len == 0);
    const candidates = [_]u32{ first, second, third, first -% 1 };
    const offset = candidates[index];
    if (offset == 0) return null;
    if (index == 0) return .{ offset, repeats };
    if (index == 1) return .{ offset, .{ offset, first, third } };
    return .{ offset, .{ offset, first, second } };
}

/// Copies up to `chunk_len_max` of the sequence's literals.
fn copy_literals(comptime Window: type, comptime claims: Claims, run: *block.Run, context: block.Context, sink: *block.Sink(Window)) void {
    const len: u32 = @min(run.literals_left, constants.chunk_len_max);
    switch (run.section.source) {
        .block => copy.copy_run(claims, sink.output, sink.written, context.block, run.section.offset + run.literals_used, len),
        .buffer => copy.copy_run(claims, sink.output, sink.written, context.literals_buffer, run.literals_used, len),
        .repeated => copy.fill_run(claims, sink.output, sink.written, run.section.octet, len),
    }
    advance(Window, sink, len);
    run.literals_used += len;
    run.literals_left -= len;
}

/// Copies up to `chunk_len_max` of the sequence's match: what lies before the call's unsynced
/// output from the window, and the rest from the output.
fn copy_match(comptime Window: type, comptime claims: Claims, run: *block.Run, sink: *block.Sink(Window)) void {
    const len: u32 = @min(run.match_left, constants.chunk_len_max);
    const target = sink.written;
    const own_len = target - sink.synced.*;
    if (run.offset > own_len) {
        copy.copy_from_window(Window, claims, sink.window, sink.output, target, run.offset, own_len, len);
    } else copy.copy_within(claims, sink.output, target, run.offset, len);
    advance(Window, sink, len);
    run.match_left -= len;
}

/// Records `len` octets placed at `written`, as `Sink.commit` does but for the frame's count, which
/// `execute` adds when the loop ends.
inline fn advance(comptime Window: type, sink: *block.Sink(Window), len: usize) void {
    sink.written += len;
    if (sink.window_each) sink.sync();
}

test "the fast reader reads what the checked backward reader reads, across its loads" {
    const codec = @import("codec");
    var generator = codec.split.Generator.init(1);
    var stream: [64]u8 = undefined;
    for (&stream) |*octet| octet.* = @truncate(generator.next());
    stream[stream.len - 1] |= 0x80;
    var checked = codec.BackwardBitReader.init(&stream).?;
    var fast = Reader.init(&stream, fast_literals.head_of(&stream), checked.position);
    // Reads of up to 31 bits, so several reads outrun one load, down to the stream's first bit and
    // past it, where both read zeros and mark themselves overflowed.
    while (!checked.overflowed) {
        const count: u6 = @intCast(generator.below(32));
        try std.testing.expectEqual(checked.read(count), fast.read(count));
        try std.testing.expectEqual(checked.position, fast.position());
        try std.testing.expectEqual(checked.overflowed, fast.overflowed);
    }
    // A stream shorter than a load reads from its padded head.
    var short = codec.BackwardBitReader.init(stream[0..5]).?;
    var short_fast = Reader.init(stream[0..5], fast_literals.head_of(stream[0..5]), short.position);
    while (!short.overflowed) {
        const count: u6 = @intCast(generator.below(12));
        try std.testing.expectEqual(short.read(count), short_fast.read(count));
        try std.testing.expectEqual(short.overflowed, short_fast.overflowed);
    }
}

test "the loop leaves a sequence whose bits pass its load's, and one any check refuses" {
    // Frames reach the first only with offsets of 2^19 or more; the tests' window is 2^17.
    const loaded_len = constants.fast_read_position_min;
    const bounds: Bounds = .{ .written_max = 1000, .literals_end = 100, .block_len_max = 1000, .window_len = 1000 };
    try std.testing.expect(!leaves(bounds, loaded_len, loaded_len, 90, 900, 10, 20, 1000));
    try std.testing.expect(leaves(bounds, loaded_len + 1, loaded_len, 90, 900, 10, 20, 1000));
    try std.testing.expect(leaves(bounds, loaded_len, loaded_len, 91, 900, 10, 20, 1000));
    try std.testing.expect(leaves(bounds, loaded_len, loaded_len, 0, 0, 10, constants.chunk_len_max - 9, 1000));
    try std.testing.expect(leaves(bounds, loaded_len, loaded_len, 90, 981, 10, 20, 1000));
    try std.testing.expect(leaves(bounds, loaded_len, loaded_len, 90, 900, 10, 20, 1001));
}

test {
    _ = @import("fast_sequences_test.zig");
}
