//! The DEFLATE decoder's fast path (decision 16): the symbol loop of decision 14's S1 and S2 and the
//! match copy of S4, which decision 16's table names.
//!
//! The loop runs while at least `input_slack` octets of input and `output_slack` octets of output
//! room remain, checked once at the top of each iteration. It refills a 64-bit bit buffer with one
//! 8-octet little-endian load (S1), decodes each symbol with one lookup in the block's tables (S2),
//! and copies a match in chunks of `constants.copy_chunk_len` octets, overrunning into the room
//! the margin leaves (S4). It writes straight into the caller's output, reads history from the
//! output and, for what came before the call, from the window, and appends what it wrote to the
//! window when it stops (S5).
//!
//! It decodes only what is valid and common: at a value no code names, a symbol RFC 1951 says
//! never occurs, or a distance past the history, it stops before using the symbol's bits, and the
//! checked path decodes the symbol again and refuses it. So both paths write the same octets and
//! give the same verdict on every input (decision 16).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const lookup = @import("lookup.zig");

/// Decision 16's margins: the input one iteration may read, a refill of 8 octets, and the output
/// it may write, a longest match and the overrun of its last chunk.
pub const input_slack = @sizeOf(u64);
pub const output_slack = constants.match_len_max + constants.copy_chunk_len;

/// The bits below which the loop refills: an iteration uses at most `pair_bits_max`, and a refill
/// leaves at least this many.
const refill_bits = @bitSizeOf(u64) - @bitSizeOf(u8);

/// The literal entries one refill decodes at most, each checked against the bits left.
const literals_per_refill = refill_bits / constants.literal_length_table_bits;

comptime {
    assert(constants.pair_bits_max <= refill_bits);
    assert(2 * literals_per_refill <= output_slack);
}

/// Why the loop stopped.
pub const End = enum {
    /// Too little input or output room was left for an iteration.
    margin,
    /// It used a block's end-of-block symbol.
    end_of_block,
    /// The next symbol is one the checked path decodes, or refuses.
    checked,
};

/// The block's codes, as tables and as the canonical codes a long code falls back to.
pub const Codes = struct {
    literal_length_table: *const lookup.LiteralLengthTable,
    distance_table: *const lookup.DistanceTable,
    literal_length_code: *const huffman.Code(constants.literal_length_alphabet_len),
    distance_code: *const huffman.Code(constants.distance_alphabet_len),
};

/// The history the loop reads and extends.
pub const History = struct {
    window: *codec.Window(constants.window_len),
    /// The farthest distance the stream may take (`limit_window`).
    distance_max: usize,
    /// Invariant 17's count, which a test build keeps.
    work: *huffman.Work,
};

/// The loop's state: the bit buffer and input position taken from the checked reader, and the
/// output position taken from the checked writer.
const Loop = struct {
    input: []const u8,
    position: usize,
    buffer: u64,
    count: u32,
    output: []u8,
    written: usize,
    /// Where the output stood when the loop started: the window holds everything before it.
    start: usize,
    /// The window's reach when the loop started.
    reach_before: usize,
    /// The index masks of the block's tables, kept here because the output's stores might alias
    /// the tables' own fields.
    literal_length_mask: u64,
    distance_mask: u64,
    decoded: usize = 0,

    inline fn has_margin(self: *const Loop) bool {
        return self.input.len - self.position >= input_slack and self.output.len - self.written >= output_slack;
    }

    /// Fills the buffer to at least `refill_bits` bits with one 8-octet load, taking the whole
    /// octets that fit, with no branch: the bits above `count` repeat the input's next octets,
    /// which a later load writes again unchanged. The buffer holds at most 63 bits before it.
    inline fn refill(self: *Loop) void {
        const word = std.mem.readInt(u64, self.input[self.position..][0..@sizeOf(u64)], .little);
        self.buffer |= word << @intCast(self.count);
        self.position += (@bitSizeOf(u64) - 1 - self.count) / @bitSizeOf(u8);
        // The count gains the whole octets taken: 56 plus the bits of a partly used octet.
        self.count = refill_bits + self.count % @bitSizeOf(u8);
    }

    inline fn consume(self: *Loop, count: u32) void {
        self.buffer >>= @intCast(count);
        self.count -= count;
        if (builtin.is_test) self.decoded += 1;
    }

    /// Uses a table entry's code. The shift takes the entry's low six bits, which hold the code's
    /// length, so the length need not be taken out first.
    inline fn consume_entry(self: *Loop, entry: lookup.Entry) void {
        const raw: u32 = @bitCast(entry);
        self.buffer >>= @truncate(raw);
        self.count -= entry.code_bits;
        if (builtin.is_test) self.decoded += 1;
    }

    /// The history a distance may reach now: the window's, and what the loop wrote since.
    inline fn reach(self: *const Loop) usize {
        return @min(constants.window_len, self.reach_before + self.written - self.start);
    }
};

inline fn low_bits(value: u64, count: u32) u64 {
    return value & ((@as(u64, 1) << @intCast(count)) - 1);
}

/// Decodes symbols from `bits` into `writer` until a margin, a block's end, or a symbol for the
/// checked path, and hands the bit buffer, the input position and the output position back.
pub noinline fn run(codes: Codes, history: History, bits: *codec.BitReader, writer: *codec.Writer) End {
    var loop: Loop = .{
        .input = bits.reader.octets,
        .position = bits.reader.position,
        .buffer = bits.bits.buffer,
        .count = bits.bits.count,
        .output = writer.octets,
        .written = writer.position,
        .start = writer.position,
        .reach_before = history.window.reach(),
        .literal_length_mask = (@as(u64, 1) << codes.literal_length_table.bits) - 1,
        .distance_mask = (@as(u64, 1) << codes.distance_table.bits) - 1,
    };
    assert(loop.count <= @bitSizeOf(u64));
    // Each iteration consumes at least a bit, or ends the loop.
    const iterations_max = @bitSizeOf(u8) * (loop.input.len - loop.position) + @bitSizeOf(u64) + 1;
    // The state may bring a full buffer of 64 bits, which the first iteration starts from; each
    // iteration uses a bit or more, so every later refill finds 63 bits or fewer.
    if (loop.count < refill_bits and loop.has_margin()) loop.refill();
    const end: End = for (0..iterations_max) |_| {
        if (!loop.has_margin()) break .margin;
        if (step(&loop, codes, history)) |ended| break ended;
        if (!loop.has_margin()) break .margin;
        loop.refill();
    } else unreachable;
    assert(loop.written <= loop.output.len and loop.position <= loop.input.len);
    // Hand the state back as the checked reader keeps it: no bit above `count` set.
    bits.bits = .{
        .buffer = if (loop.count >= @bitSizeOf(u64)) loop.buffer else low_bits(loop.buffer, loop.count),
        .count = @intCast(loop.count),
    };
    bits.reader.position = loop.position;
    writer.position = loop.written;
    history.window.append(loop.output[loop.start..loop.written]);
    if (builtin.is_test) history.work.* += loop.decoded;
    return end;
}

/// Decodes one literal/length symbol, and the distance a length takes, or a run of literals.
/// Returns why the loop stops, or null to go on.
inline fn step(loop: *Loop, codes: Codes, history: History) ?End {
    var entry = codes.literal_length_table.entries[@intCast(loop.buffer & loop.literal_length_mask)];
    if (entry.kind == .long) entry = resolve_literal_length(codes, loop.buffer) orelse return .checked;
    switch (entry.kind) {
        .literal, .literal_pair => {
            write_literals(loop, entry);
            // More literals while the buffer holds a whole table code: the first may have been a
            // long code.
            for (1..literals_per_refill) |_| {
                if (loop.count < constants.literal_length_table_bits) return null;
                const next = codes.literal_length_table.entries[@intCast(loop.buffer & loop.literal_length_mask)];
                if (next.kind != .literal and next.kind != .literal_pair) return null;
                write_literals(loop, next);
            }
            return null;
        },
        .end_of_block => {
            loop.consume(entry.code_bits);
            return .end_of_block;
        },
        .length => return copy_pair(loop, codes, history, entry),
        .distance, .long, .invalid => return .checked,
    }
}

/// Writes a literal, or a pair's two octets, the first from the value's low octet.
inline fn write_literals(loop: *Loop, entry: lookup.Entry) void {
    if (entry.kind == .literal_pair) {
        std.mem.writeInt(u16, loop.output[loop.written..][0..@sizeOf(u16)], entry.value, .little);
        loop.written += @sizeOf(u16);
        if (builtin.is_test) loop.decoded += 1;
    } else {
        loop.output[loop.written] = @truncate(entry.value);
        loop.written += 1;
    }
    loop.consume_entry(entry);
}

fn resolve_literal_length(codes: Codes, buffer: u64) ?lookup.Entry {
    return switch (codes.literal_length_code.decode(buffer, constants.code_len_max)) {
        .symbol => |symbol| lookup.literal_length_entry(symbol.value, @intCast(symbol.len)),
        .needs_bits, .invalid => null,
    };
}

fn resolve_distance(codes: Codes, buffer: u64) ?lookup.Entry {
    return switch (codes.distance_code.decode(buffer, constants.code_len_max)) {
        .symbol => |symbol| lookup.distance_entry(symbol.value, @intCast(symbol.len)),
        .needs_bits, .invalid => null,
    };
}

/// Reads a length's extra bits and its distance, and copies the match, or stops before using any
/// bit of the pair when the checked path must see it.
inline fn copy_pair(loop: *Loop, codes: Codes, history: History, length: lookup.Entry) ?End {
    var used: u32 = length.code_bits;
    const len = length.value + low_bits(loop.buffer >> @intCast(used), length.extra_bits);
    // RFC 1951 §3.2.5: 258 has code 285 alone, which takes no extra bits.
    if (len == constants.match_len_max and length.extra_bits != 0) return .checked;
    used += length.extra_bits;
    var distance_entry = codes.distance_table.entries[@intCast((loop.buffer >> @intCast(used)) & loop.distance_mask)];
    if (distance_entry.kind == .long) distance_entry = resolve_distance(codes, loop.buffer >> @intCast(used)) orelse return .checked;
    if (distance_entry.kind != .distance) return .checked;
    used += distance_entry.code_bits;
    const distance = distance_entry.value + low_bits(loop.buffer >> @intCast(used), distance_entry.extra_bits);
    used += distance_entry.extra_bits;
    // A distance past the history or the container's window is the checked path's to refuse.
    if (distance > loop.reach() or distance > history.distance_max) return .checked;
    loop.consume(used);
    if (builtin.is_test) loop.decoded += 1;
    copy_match(loop, history.window, @intCast(distance), @intCast(len));
    return null;
}

/// Copies `len` octets from `distance` back: first what lies before this call's output, from the
/// window, then from the output itself.
fn copy_match(loop: *Loop, window: *const codec.Window(constants.window_len), distance: usize, len: usize) void {
    var copied: usize = 0;
    if (distance > loop.written) {
        const from_window = @min(len, distance - loop.written);
        // The window's newest octet is the one before `start`.
        window.copy_back(distance - loop.written + loop.start, loop.output[loop.written..][0..from_window]);
        copied = from_window;
    }
    if (copied < len) copy_within(loop.output, loop.written + copied, distance, len - copied);
    loop.written += len;
}

/// Copies `len` octets to `target` from `distance` before it: in chunks of `copy_chunk_len` or
/// `copy_word_len` octets where the distance leaves room for one, a fill for a distance of 1, and
/// octet by octet otherwise. A chunk may write up to its length less one past `len`, into the
/// margin, and reads only octets written before.
fn copy_within(output: []u8, target: usize, distance: usize, len: usize) void {
    const source = target - distance;
    if (distance >= constants.copy_chunk_len) {
        copy_chunks(constants.copy_chunk_len, output, target, source, len);
    } else if (distance >= constants.copy_word_len) {
        copy_chunks(constants.copy_word_len, output, target, source, len);
    } else if (distance == 1) {
        fill(output, target, output[source], len);
    } else {
        for (0..len) |index| output[target + index] = output[source + index];
    }
}

/// The chunks a match copy writes before it looks at the length: most matches are that short.
const chunks_unconditional = 2;

/// Copies `len` octets in chunks of `chunk_len`: the first `chunks_unconditional` whatever the
/// length, and the rest in a loop.
fn copy_chunks(comptime chunk_len: usize, output: []u8, target: usize, source: usize, len: usize) void {
    inline for (0..chunks_unconditional) |chunk| {
        const offset = chunk * chunk_len;
        output[target + offset ..][0..chunk_len].* = output[source + offset ..][0..chunk_len].*;
    }
    if (len <= chunks_unconditional * chunk_len) return;
    const chunks = std.math.divCeil(usize, len, chunk_len) catch unreachable;
    for (chunks_unconditional..chunks) |chunk| {
        const offset = chunk * chunk_len;
        output[target + offset ..][0..chunk_len].* = output[source + offset ..][0..chunk_len].*;
    }
}

/// Writes `len` copies of `octet`, a chunk at a time.
fn fill(output: []u8, target: usize, octet: u8, len: usize) void {
    const chunk_len = constants.copy_chunk_len;
    const chunk: [chunk_len]u8 = @splat(octet);
    const chunks = std.math.divCeil(usize, len, chunk_len) catch unreachable;
    for (0..chunks) |index| output[target + index * chunk_len ..][0..chunk_len].* = chunk;
}
