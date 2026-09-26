//! The DEFLATE decoder's fast path (decision 16): the symbol loop of decision 14's S1 and S2 and the
//! match copy of S4, which decision 16's table names.
//!
//! The loop runs while at least `input_slack` octets of input and `output_slack` octets of output
//! room remain, checked once at the top of each iteration. It refills a 64-bit bit buffer with one
//! 8-octet little-endian load (S1), decodes each symbol with one lookup in the block's tables (S2),
//! and copies a match in chunks of `constants.copy_chunk_len` octets, overrunning into the room
//! the margin leaves (S4). It writes straight into the caller's output and reads history from the
//! output and, for what the window holds, from the window; the decoder appends the call's last
//! octets to the window once, when the call ends or the checked path needs it (S5).
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

/// The two loops: the wide one, which the margins let read 8 octets at a time and write chunks
/// past a match's end, and the tail, which takes octets one at a time through the input's end and
/// checks the room each symbol writes, so the octets of a call that the margins leave out need
/// not go through the checked path.
const Mode = enum { wide, tail };

/// Why the loop stopped.
pub const End = enum(u2) {
    /// Too little input or output room was left for an iteration.
    margin,
    /// It used a block's end-of-block symbol.
    end_of_block,
    /// The next symbol is one the checked path decodes, or refuses.
    checked,
};

/// What a step says: go on, or why the loop stops, numbered as `End` numbers it. A step returns
/// this rather than an optional `End`, which the compiler builds in memory.
const Next = enum(u2) {
    margin = @intFromEnum(End.margin),
    end_of_block = @intFromEnum(End.end_of_block),
    checked = @intFromEnum(End.checked),
    go_on,

    /// The end a step other than `go_on` says.
    fn end(next: Next) End {
        assert(next != .go_on);
        return @enumFromInt(@intFromEnum(next));
    }
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
    /// Where the output stands in the window: the octets before it are in the window, and the
    /// caller appends those after it, the loop's among them, when it next syncs.
    synced: usize,
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
    /// Where the output stands in the window: the window holds everything before it.
    start: usize,
    /// The window's reach when the loop started.
    reach_before: usize,
    /// The index masks of the block's tables, kept here because the output's stores might alias
    /// the tables' own fields.
    literal_length_mask: lookup.LiteralLengthTable.Index,
    distance_mask: lookup.DistanceTable.Index,
    decoded: usize = 0,
    /// The last output position the wide loop's margin allows, set when it starts, so each
    /// iteration compares against it with no subtraction.
    output_limit: usize = 0,

    /// The literal/length entry of the code the buffer starts with.
    inline fn look_up(self: *const Loop, table: *const lookup.LiteralLengthTable) lookup.Entry {
        return table.entries[@as(lookup.LiteralLengthTable.Index, @truncate(self.buffer)) & self.literal_length_mask];
    }

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

    /// Takes whole octets, one at a time, while they fit the buffer and the input has them. The
    /// bits above `count` stay zero.
    inline fn refill_exact(self: *Loop) void {
        for (0..@sizeOf(u64)) |_| {
            if (self.count > refill_bits or self.position == self.input.len) return;
            self.buffer |= @as(u64, self.input[self.position]) << @intCast(self.count);
            self.position += 1;
            self.count += @bitSizeOf(u8);
        }
    }

    /// The room left in the output.
    inline fn room(self: *const Loop) usize {
        return self.output.len - self.written;
    }

    inline fn consume(self: *Loop, count: u32) void {
        self.buffer >>= @intCast(count);
        self.count -= count;
        if (builtin.is_test) self.decoded += 1;
    }

    /// Uses a pair's bits: `after_length` is the buffer past the length's, and the distance's
    /// entry says how many bits come after them. `used` counts both.
    inline fn consume_pair(self: *Loop, after_length: u64, distance: lookup.Entry, used: u32) void {
        self.buffer = past(after_length, distance);
        self.count -= used;
        if (builtin.is_test) self.decoded += 1;
    }

    /// Uses a table entry's code. The shift takes the entry's low six bits, which hold the code's
    /// length, so the length need not be taken out first.
    inline fn consume_entry(self: *Loop, entry: lookup.Entry) void {
        const raw: u32 = @bitCast(entry);
        self.buffer >>= @truncate(raw);
        self.count -= entry.used_bits;
        if (builtin.is_test) self.decoded += 1;
    }
};

inline fn low_bits(value: u64, count: u32) u64 {
    return value & ((@as(u64, 1) << @intCast(count)) - 1);
}

/// The value of the extra bits after a length's or a distance's code, which `buffer` starts with.
inline fn extra_value(buffer: u64, entry: lookup.Entry) u64 {
    return low_bits(buffer, entry.used_bits) >> entry.code_bits;
}

/// The bits of `buffer` past the symbol it starts with, and the symbol's extra bits: the entry's
/// low octet says how many, and a 64-bit shift takes the low six bits of its amount.
inline fn past(buffer: u64, entry: lookup.Entry) u64 {
    return buffer >> @truncate(@as(u32, @bitCast(entry)));
}

/// Decodes symbols from `bits` into `writer` until a margin, a block's end, or a symbol for the
/// checked path, and hands the bit buffer, the input position and the output position back.
pub noinline fn run(codes: Codes, history: History, bits: *codec.BitReader, writer: *codec.Writer) End {
    return run_loop(.wide, codes, history, bits, writer);
}

/// As `run`, symbol by symbol through the end of the input and of the output, for what the wide
/// loop's margins leave out.
pub noinline fn run_tail(codes: Codes, history: History, bits: *codec.BitReader, writer: *codec.Writer) End {
    return run_loop(.tail, codes, history, bits, writer);
}

inline fn run_loop(comptime mode: Mode, codes: Codes, history: History, bits: *codec.BitReader, writer: *codec.Writer) End {
    var loop: Loop = .{
        .input = bits.reader.octets,
        .position = bits.reader.position,
        .buffer = bits.bits.buffer,
        .count = bits.bits.count,
        .output = writer.octets,
        .written = writer.position,
        .start = history.synced,
        .reach_before = history.window.reach(),
        .literal_length_mask = codes.literal_length_table.mask(),
        .distance_mask = codes.distance_table.mask(),
    };
    assert(loop.count <= @bitSizeOf(u64));
    const end: End = switch (mode) {
        .wide => if (loop.has_margin()) decode_symbols(&loop, codes, history) else .margin,
        .tail => decode_tail(&loop, codes, history),
    };
    assert(loop.written <= loop.output.len and loop.position <= loop.input.len);
    // Hand the state back as the checked reader keeps it: no bit above `count` set.
    bits.bits = .{
        .buffer = if (loop.count >= @bitSizeOf(u64)) loop.buffer else low_bits(loop.buffer, loop.count),
        .count = @intCast(loop.count),
    };
    bits.reader.position = loop.position;
    writer.position = loop.written;
    if (builtin.is_test) history.work.* += loop.decoded;
    return end;
}

/// The loop itself, entered with its margins held.
inline fn decode_symbols(loop: *Loop, codes: Codes, history: History) End {
    assert(loop.has_margin());
    loop.output_limit = loop.output.len - output_slack;
    // The state may bring a full buffer of 64 bits, which the first iteration starts from; each
    // iteration uses a bit or more, so every later refill finds 63 bits or fewer. The margins are
    // checked before each refill, which ends every iteration.
    if (loop.count < refill_bits) loop.refill();
    var entry = loop.look_up(codes.literal_length_table);
    // Each iteration consumes at least a bit, or ends the loop.
    const iterations_max = @bitSizeOf(u8) * (loop.input.len - loop.position) + @bitSizeOf(u64) + 1;
    var iterations_left = iterations_max;
    while (iterations_left > 0) : (iterations_left -= 1) {
        const next = step(.wide, loop, codes, history, entry);
        if (next != .go_on) return next.end();
        // The input's margin is the bound the refill's load checks, so the two are one compare.
        if (loop.position + input_slack > loop.input.len or loop.written > loop.output_limit) return .margin;
        entry = refill_and_look_up(loop, codes);
    }
    unreachable;
}

/// Refills, and looks up the next symbol's entry. When the bits before the refill hold a whole
/// table code, the lookup reads them, which the refill leaves in place, so the lookup need not
/// wait for the refill.
inline fn refill_and_look_up(loop: *Loop, codes: Codes) lookup.Entry {
    if (loop.count >= constants.literal_length_table_bits) {
        const entry = loop.look_up(codes.literal_length_table);
        loop.refill();
        return entry;
    }
    loop.refill();
    return loop.look_up(codes.literal_length_table);
}

/// The tail: a symbol at a time, while the input holds a whole pair's bits.
inline fn decode_tail(loop: *Loop, codes: Codes, history: History) End {
    // Each iteration consumes at least a bit, or ends the loop.
    const iterations_max = @bitSizeOf(u8) * (loop.input.len - loop.position) + @bitSizeOf(u64) + 1;
    for (0..iterations_max) |_| {
        loop.refill_exact();
        // Near the input's end, the checked path decodes what is left, and asks for more.
        if (loop.count < constants.pair_bits_max) return .checked;
        const next = step(.tail, loop, codes, history, loop.look_up(codes.literal_length_table));
        if (next != .go_on) return next.end();
    }
    unreachable;
}

/// Decodes one literal/length symbol, whose table entry is `first`, and the distance a length
/// takes, or a run of literals. Returns why the loop stops, or `go_on`.
inline fn step(comptime mode: Mode, loop: *Loop, codes: Codes, history: History, first: lookup.Entry) Next {
    var entry = first;
    if (entry.kind == .long) {
        @branchHint(.cold);
        entry = resolve_literal_length(codes, loop.buffer) orelse return .checked;
    }
    switch (entry.kind) {
        .literal, .literal_pair => return step_literals(mode, loop, codes, entry),
        .end_of_block => {
            loop.consume(entry.used_bits);
            return .end_of_block;
        },
        .length => return copy_pair(mode, loop, codes, history, entry),
        .distance, .long, .invalid => return .checked,
    }
}

/// Writes a literal entry, and in the wide loop the literal entries after it while the buffer
/// holds their codes.
inline fn step_literals(comptime mode: Mode, loop: *Loop, codes: Codes, entry: lookup.Entry) Next {
    // The tail writes one entry an iteration, into room it checks first.
    if (mode == .tail) {
        if (loop.room() < @sizeOf(u16)) return .margin;
        write_literals(loop, entry);
        return .go_on;
    }
    write_literals(loop, entry);
    // More literals while the buffer holds a whole table code: the first may have been a long
    // code.
    for (1..literals_per_refill) |_| {
        if (loop.count < constants.literal_length_table_bits) return .go_on;
        const next = loop.look_up(codes.literal_length_table);
        // The next iteration looks the entry up again, from the same bits.
        if (next.kind != .literal and next.kind != .literal_pair) return .go_on;
        write_literals(loop, next);
    }
    return .go_on;
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

/// The distance entry of a table entry that is not a distance's: a long code's, decoded with the
/// canonical code from `buffer`, or null for the checked path.
fn resolve_distance(codes: Codes, entry: lookup.Entry, buffer: u64) ?lookup.Entry {
    if (entry.kind != .long) return null;
    const resolved = switch (codes.distance_code.decode(buffer, constants.code_len_max)) {
        .symbol => |symbol| lookup.distance_entry(symbol.value, @intCast(symbol.len)),
        .needs_bits, .invalid => return null,
    };
    // RFC 1951 §3.2.6: distance codes 30 and 31 never occur; the checked path refuses them.
    return if (resolved.kind == .distance) resolved else null;
}

/// Reads a length's extra bits and its distance, and copies the match, or stops before using any
/// bit of the pair when the checked path must see it.
inline fn copy_pair(comptime mode: Mode, loop: *Loop, codes: Codes, history: History, length: lookup.Entry) Next {
    const len = length.value + extra_value(loop.buffer, length);
    // RFC 1951 §3.2.5: 258 has code 285 alone, which takes no extra bits.
    if (len == constants.match_len_max and length.used_bits != length.code_bits) return .checked;
    const after_length = past(loop.buffer, length);
    var distance_entry = codes.distance_table.entries[@as(lookup.DistanceTable.Index, @truncate(after_length)) & loop.distance_mask];
    if (distance_entry.kind != .distance) {
        @branchHint(.cold);
        distance_entry = resolve_distance(codes, distance_entry, after_length) orelse return .checked;
    }
    const distance = distance_entry.value + extra_value(after_length, distance_entry);
    const used = @as(u32, length.used_bits) + distance_entry.used_bits;
    // The tail copies a match whole or leaves it to the checked path, which copies what fits.
    if (mode == .tail and loop.room() < len) return .margin;
    // Most matches reach only octets this call wrote, inside the container's window, and copy
    // straight from the output; the rest go out of line.
    const target = loop.written;
    if (distance <= target and distance <= history.distance_max) {
        loop.consume_pair(after_length, distance_entry, used);
        loop.written += @intCast(len);
        switch (mode) {
            .wide => copy_within(loop.output, target, @intCast(distance), @intCast(len)),
            .tail => copy_exact(loop.output, target, @intCast(distance), @intCast(len)),
        }
    } else {
        @branchHint(.unlikely);
        if (!copy_from_window(loop.output, target, loop.start, loop.reach_before, history, @intCast(distance), @intCast(len))) return .checked;
        loop.consume_pair(after_length, distance_entry, used);
        loop.written += @intCast(len);
    }
    if (builtin.is_test) loop.decoded += 1;
    return .go_on;
}

/// Copies a match that reaches before this call's output: its first octets from the window, the
/// rest from the output, octet by octet. Returns false, having copied nothing, for a distance past
/// the history or the container's window, which the checked path refuses. It takes the loop's
/// state as values, so the loop's state stays in registers.
noinline fn copy_from_window(output: []u8, written: usize, start: usize, reach_before: usize, history: History, distance: usize, len: usize) bool {
    assert(distance > written or distance > history.distance_max);
    assert(start <= written);
    const reach = @min(constants.window_len, reach_before + written - start);
    if (distance > reach or distance > history.distance_max) return false;
    const from_window = @min(len, distance - written);
    // The window's newest octet is the one before `start`.
    history.window.copy_back(distance - written + start, output[written..][0..from_window]);
    if (from_window == len) return true;
    // The rest, when a match runs from the window into this call's output, is short.
    copy_exact(output, written + from_window, distance, len - from_window);
    return true;
}

/// Copies `len` octets to `target` from `distance` before it, octet by octet, so the copy reads
/// what it wrote when the match overlaps itself, and writes nothing past `len`.
fn copy_exact(output: []u8, target: usize, distance: usize, len: usize) void {
    const source = target - distance;
    for (0..len) |index| output[target + index] = output[source + index];
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
    // The first chunks' target and source, each bounded once: the chunks inside them sit at
    // offsets known at compile time, so their bounds need no check.
    const head_len = chunks_unconditional * chunk_len;
    const head_target = output[target..][0..head_len];
    const head_source = output[source..][0..head_len];
    inline for (0..chunks_unconditional) |chunk| {
        head_target[chunk * chunk_len ..][0..chunk_len].* = head_source[chunk * chunk_len ..][0..chunk_len].*;
    }
    if (len <= head_len) return;
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
