//! The DEFLATE decoder's fast path (decision 16): the symbol loop of decision 14's S1 and S2 and the
//! match copy of S4, which decision 16's table names.
//!
//! The loop runs while at least `input_slack` octets of input and `output_slack` octets of output
//! room remain, checked once in each iteration. It refills a 64-bit bit buffer with one 8-octet
//! little-endian load (S1), decodes each symbol with one lookup in the block's tables (S2), and
//! copies a match in chunks of `constants.copy_chunk_len` octets, overrunning into the room the
//! margin leaves (S4). It writes straight into the caller's output and reads history from the
//! output and, for what the window holds, from the window; the decoder appends the call's last
//! octets to the window once, when the call ends or the checked path needs it (S5).
//!
//! The common symbols run in `decode_common`: runs of literals the literal/length table decodes,
//! and pairs the tables decode whole whose match lies in this call's output at least a word back.
//! It stops, having used no bit of it, at any other symbol, which `decode_rare` decodes out of
//! line, so the common loop holds no call and keeps its state in registers.
//!
//! It decodes only what is valid: at a value no code names, a symbol RFC 1951 says never occurs,
//! or a distance past the history, it stops before using the symbol's bits, and the checked path
//! decodes the symbol again and refuses it. So both paths write the same octets and give the same
//! verdict on every input (decision 16).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");
const lookup = @import("../lookup.zig");
const fast_copy = @import("fast_copy.zig");
const fast_step = @import("fast_step.zig");
const fast_aarch64 = @import("fast_aarch64.zig");
const fast_x86_64 = @import("fast_x86_64.zig");
const options_module = @import("../options.zig");
const Options = options_module.Options;
const Lookups = options_module.Lookups;
const How = options_module.How;

/// Decision 16's margins: the input one iteration may read, a refill of 8 octets, and the output
/// it may write, a longest match and the overrun of its last chunk.
pub const input_slack = @sizeOf(u64);
pub const output_slack = fast_copy.room_len;

/// The bits a refill leaves in the buffer at least: an iteration uses at most `pair_bits_max`.
pub const refill_bits = @bitSizeOf(u64) - @bitSizeOf(u8);

/// The literals one iteration decodes at most. A literal the table decodes takes at most the
/// table's width, so after a refill each of these literals' lookups finds a whole table index in
/// the buffer, and none needs a check of the bits left.
pub const literals_per_refill = (refill_bits - constants.literal_length_table_bits) / constants.literal_length_table_bits + 1;

comptime {
    assert(constants.pair_bits_max <= refill_bits);
    assert(literals_per_refill <= output_slack);
    // The last literal's lookup still finds a whole table index.
    assert(refill_bits - (literals_per_refill - 1) * constants.literal_length_table_bits >= constants.literal_length_table_bits);
}

/// The two loops: the wide one, which the margins let read 8 octets at a time and write chunks
/// past a match's end, and the tail, which takes octets one at a time through the input's end and
/// checks the room each symbol writes, so the octets of a call that the margins leave out need
/// not go through the checked path.
pub const Mode = enum { wide, tail };

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
pub const Next = enum(u2) {
    margin = @intFromEnum(End.margin),
    end_of_block = @intFromEnum(End.end_of_block),
    checked = @intFromEnum(End.checked),
    go_on,

    /// The end a step other than `go_on` says.
    pub fn end(next: Next) End {
        assert(next != .go_on);
        return @enumFromInt(@intFromEnum(next));
    }
};

/// Why the common loop stopped: a margin, or a symbol for `decode_rare`, whose bits it left.
pub const Stop = enum(u8) { margin, rare };

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
    /// S2's count, when the decode keeps one (options.zig).
    lookups: ?*Lookups,
    /// Whether the CPU runs the x86-64 assembly of the common loop (decision 29).
    assembly: bool,
};

/// The loop's state: the bit buffer and the input not yet taken into it, from the checked reader,
/// the output position taken from the checked writer, and what the loop reads on every iteration,
/// copied here once because the output's stores might alias the structures they came from.
pub const Loop = struct {
    input: []const u8,
    /// The input after the octets the buffer took: its end, as the checked reader's position.
    rest: []const u8,
    buffer: u64,
    count: u32,
    output: []u8,
    written: usize,
    literal_length_entries: *const [lookup.LiteralLengthTable.len]lookup.Entry,
    /// The index masks of the block's tables, no wider than the tables, so an index needs no
    /// bounds check: `decode_common` widens them from their tables' index types, which say so.
    literal_length_mask: u64,
    distance_entries: *const [lookup.DistanceTable.len]lookup.Entry,
    distance_mask: u64,
    distance_max: usize,
    /// Whether the literal/length table holds most lengths whole (lookup.zig, `build`).
    lengths_resolved: bool,
    decoded: usize = 0,
    /// S2's count for this run, which `run_loop` adds to the decode's when it keeps one.
    lookups: Lookups = .{},

    /// The literal/length entry of the code the buffer starts with.
    pub inline fn look_up(self: *const Loop) lookup.Entry {
        return self.literal_length_entries[@intCast(self.buffer & self.literal_length_mask)];
    }

    /// The distance entry of the code `buffer` starts with.
    pub inline fn look_up_distance(self: *const Loop, buffer: u64) lookup.Entry {
        return self.distance_entries[@intCast(buffer & self.distance_mask)];
    }

    inline fn has_margin(self: *const Loop) bool {
        return self.rest.len >= input_slack and self.output.len - self.written >= output_slack;
    }

    /// The input octets the checked reader has taken.
    inline fn position(self: *const Loop) usize {
        return self.input.len - self.rest.len;
    }

    /// Fills the buffer to at least `refill_bits` bits from `word`, the next 8 input octets,
    /// taking the whole octets that fit, with no branch: the bits above `count` repeat the input's
    /// next octets, which a later load writes again unchanged. The buffer holds at most 63 bits
    /// before it.
    inline fn refill(self: *Loop, word: *const [@sizeOf(u64)]u8) void {
        // The count fits six bits here, and its complement is the room left: 63 less the count.
        const held: u6 = @truncate(self.count);
        self.buffer |= std.mem.readInt(u64, word, .little) << held;
        self.rest = self.rest[~held / @bitSizeOf(u8) ..];
        // The count gains the whole octets taken: 56 plus the bits of a partly used octet.
        self.count = refill_bits + self.count % @bitSizeOf(u8);
    }

    /// Takes whole octets, one at a time, while they fit the buffer and the input has them. The
    /// bits above `count` stay zero.
    pub inline fn refill_exact(self: *Loop) void {
        for (0..@sizeOf(u64)) |_| {
            if (self.count > refill_bits or self.rest.len == 0) return;
            self.buffer |= @as(u64, self.rest[0]) << @intCast(self.count);
            self.rest = self.rest[1..];
            self.count += @bitSizeOf(u8);
        }
    }

    /// The room left in the output.
    pub inline fn room(self: *const Loop) usize {
        return self.output.len - self.written;
    }

    /// Uses a table entry's code. The shift takes the entry's low six bits, which hold the code's
    /// length, so the length need not be taken out first.
    pub inline fn consume_entry(self: *Loop, entry: lookup.Entry) void {
        self.buffer = past(self.buffer, entry);
        self.count -= entry.used_bits;
        if (builtin.is_test) self.decoded += 1;
    }

    /// Uses a length's and its distance's bits, after the copy: `after_length` is the buffer
    /// past the length's.
    inline fn consume_pair(self: *Loop, length: lookup.Entry, after_length: u64, distance: lookup.Entry) void {
        self.buffer = past(after_length, distance);
        self.count -= @as(u32, length.used_bits) + distance.used_bits;
        if (builtin.is_test) self.decoded += constants.decodes_per_step_max;
    }
};

inline fn low_bits(value: u64, count: u32) u64 {
    return value & ((@as(u64, 1) << @intCast(count)) - 1);
}

/// The value of the extra bits after a length's or a distance's code, which `buffer` starts with.
pub inline fn extra_value(buffer: u64, entry: lookup.Entry) u64 {
    return low_bits(buffer, entry.used_bits) >> entry.code_bits;
}

/// The bits of `buffer` past the symbol it starts with, and the symbol's extra bits: the entry's
/// low octet says how many, and a 64-bit shift takes the low six bits of its amount.
pub inline fn past(buffer: u64, entry: lookup.Entry) u64 {
    return buffer >> @truncate(@as(u32, @bitCast(entry)));
}

/// Decodes symbols from `bits` into `writer` until a margin, a block's end, or a symbol for the
/// checked path, and hands the bit buffer, the input position and the output position back.
pub noinline fn run(comptime options: Options, codes: Codes, history: History, bits: *codec.BitReader, writer: *codec.Writer) End {
    return run_loop(.wide, options, codes, history, bits, writer);
}

/// As `run`, symbol by symbol through the end of the input and of the output, for what the wide
/// loop's margins leave out.
pub noinline fn run_tail(comptime options: Options, codes: Codes, history: History, bits: *codec.BitReader, writer: *codec.Writer) End {
    return run_loop(.tail, options, codes, history, bits, writer);
}

inline fn run_loop(comptime mode: Mode, comptime options: Options, codes: Codes, history: History, bits: *codec.BitReader, writer: *codec.Writer) End {
    var loop: Loop = .{
        .input = bits.reader.octets,
        .rest = bits.reader.octets[bits.reader.position..],
        .buffer = bits.bits.buffer,
        .count = bits.bits.count,
        .output = writer.octets,
        .written = writer.position,
        .literal_length_entries = &codes.literal_length_table.entries,
        .literal_length_mask = codes.literal_length_table.mask(),
        .distance_entries = &codes.distance_table.entries,
        .distance_mask = codes.distance_table.mask(),
        .distance_max = history.distance_max,
        .lengths_resolved = codes.literal_length_table.resolved,
    };
    assert(loop.count <= @bitSizeOf(u64));
    const end: End = switch (mode) {
        .wide => if (loop.has_margin()) decode_symbols(options, &loop, codes, history) else .margin,
        .tail => fast_step.decode_tail(options, &loop, codes, history),
    };
    assert(loop.written <= loop.output.len and loop.rest.len <= loop.input.len);
    // Hand the state back as the checked reader keeps it: no bit above `count` set.
    bits.bits = .{
        .buffer = if (loop.count >= @bitSizeOf(u64)) loop.buffer else low_bits(loop.buffer, loop.count),
        .count = @intCast(loop.count),
    };
    bits.reader.position = loop.position();
    writer.position = loop.written;
    if (builtin.is_test) history.work.* += loop.decoded;
    if (options.count_lookups) history.lookups.?.add(loop.lookups);
    return end;
}

/// The wide loop, entered with its margins held: the common symbols, and each other symbol out
/// of line.
inline fn decode_symbols(comptime options: Options, loop: *Loop, codes: Codes, history: History) End {
    assert(loop.has_margin());
    // Each round decodes a symbol at least, which takes a bit, or ends the loop.
    const rounds_max = @bitSizeOf(u8) * loop.rest.len + @bitSizeOf(u64) + 1;
    for (0..rounds_max) |_| {
        if (common(options, loop, codes, history) == .margin) return .margin;
        const next = decode_rare(options, loop, codes, history);
        if (next != .go_on) return next.end();
    }
    unreachable;
}

/// The common symbols, through the assembly of decision 29 where it runs.
inline fn common(comptime options: Options, loop: *Loop, codes: Codes, history: History) Stop {
    if (comptime fast_aarch64.takes(options)) return fast_aarch64.decode_common(loop, codes);
    if ((comptime fast_x86_64.takes(options)) and history.assembly) return fast_x86_64.decode_common(loop, codes);
    return decode_common(options, loop);
}

/// Whether a CPU with `features` runs the x86-64 assembly of the common loop.
pub fn assembly_runs(features: codec.Features) bool {
    return fast_x86_64.runs(features);
}

/// The input and the output room of one iteration of the wide loop, which its margins bound.
const Margins = struct {
    /// The next 8 input octets, which the refill at the iteration's end takes.
    word: *const [@sizeOf(u64)]u8,
    /// The output room from the iteration's first octet.
    room: *[output_slack]u8,
};

/// The margins of the next iteration, or null when too little input or output room is left.
/// Each slice is taken from the length the margin compares, so neither needs another check.
inline fn margins(loop: *const Loop) ?Margins {
    if (loop.rest.len < input_slack) return null;
    const room = loop.output[loop.written..];
    if (room.len < output_slack) return null;
    return .{ .word = loop.rest[0..input_slack], .room = room[0..output_slack] };
}

/// Decodes the common symbols until a margin, or a symbol it leaves for `decode_rare`: with the
/// margins held, at least `refill_bits` bits in the buffer, and none of that symbol's bits used.
/// It works on a copy of the state, which stays in registers, and writes it back when it stops.
inline fn decode_common(comptime options: Options, state: *Loop) Stop {
    var loop = state.*;
    defer state.* = loop;
    // The masks come back from memory: their tables' index types bound them again.
    loop.literal_length_mask = @as(lookup.LiteralLengthTable.Index, @truncate(loop.literal_length_mask));
    loop.distance_mask = @as(lookup.DistanceTable.Index, @truncate(loop.distance_mask));
    const first = margins(&loop) orelse return .margin;
    // The state may bring a full buffer of 64 bits, which the first iteration starts from; each
    // iteration uses a bit or more, so every later refill finds 63 bits or fewer.
    if (loop.count < refill_bits) refill(options, &loop, first.word);
    var entry = loop.look_up();
    // Each iteration consumes at least a bit, or ends the loop.
    const iterations_max = @bitSizeOf(u8) * loop.rest.len + @bitSizeOf(u64) + 1;
    for (0..iterations_max) |_| {
        // The margins, checked before the iteration's first access, bound every access in it: the
        // refill at its end takes `word`, and the iteration writes into `room`.
        const iteration = margins(&loop) orelse return .margin;
        // The buffer holds at least `refill_bits` bits, and `entry` is the next symbol's.
        var known: ?lookup.Entry = null;
        if (entry.literal) {
            known = literal_run(options, &loop, iteration.room, entry);
        } else if (entry.combined) {
            if (!copy_combined(options, &loop, entry)) return .rare;
        } else if (!entry.direct or !copy_common(options, &loop, entry)) {
            @branchHint(.unlikely);
            return .rare;
        }
        entry = next_entry(options, &loop, iteration.word, known);
    }
    unreachable;
}

/// Decodes the symbol `decode_common` stopped at: a code longer than the table, the end of the
/// block, a match from the window or less than a word back, or a value for the checked path.
noinline fn decode_rare(comptime options: Options, state: *Loop, codes: Codes, history: History) Next {
    var loop = state.*;
    defer state.* = loop;
    return fast_step.step(.wide, options, &loop, codes, history, loop.look_up());
}

/// Refills from `word`, and gives the next symbol's entry: `known`, which a literal run looked up
/// while the buffer held its index, or a lookup. When the bits before the refill hold a whole
/// table index, the lookup reads them, which the refill leaves in place, so it need not wait for
/// the refill.
inline fn next_entry(comptime options: Options, loop: *Loop, word: *const [@sizeOf(u64)]u8, known: ?lookup.Entry) lookup.Entry {
    if (known) |entry| {
        refill(options, loop, word);
        return entry;
    }
    if (loop.count >= constants.literal_length_table_bits) {
        const entry = loop.look_up();
        refill(options, loop, word);
        return entry;
    }
    refill(options, loop, word);
    return loop.look_up();
}

/// The wide loop's refill: one 8-octet load (S1), or with the claim off, an octet at a time.
inline fn refill(comptime options: Options, loop: *Loop, word: *const [@sizeOf(u64)]u8) void {
    if (options.claims.word_refill) loop.refill(word) else loop.refill_exact();
}

/// Writes the literal `first` and the literals after it, up to `literals_per_refill`, into `room`,
/// and returns the entry of the symbol after them when it looked it up, or null when the run
/// filled. The bit count drops once, by the run's bits.
inline fn literal_run(comptime options: Options, loop: *Loop, room: *[output_slack]u8, first: lookup.Entry) ?lookup.Entry {
    var run_bits: u32 = 0;
    write_literal(options, loop, room, 0, first, &run_bits);
    inline for (1..literals_per_refill) |index| {
        const next = loop.look_up();
        if (!next.literal) {
            loop.count -= run_bits;
            loop.written += index;
            return next;
        }
        write_literal(options, loop, room, index, next, &run_bits);
    }
    loop.count -= run_bits;
    loop.written += literals_per_refill;
    return null;
}

/// Writes a literal at `index` of the iteration's room, and adds its bits to the run's.
inline fn write_literal(comptime options: Options, loop: *Loop, room: *[output_slack]u8, comptime index: usize, entry: lookup.Entry, run_bits: *u32) void {
    if (options.count_lookups) count_symbol(loop, .table);
    room[index] = @truncate(entry.value);
    loop.buffer = past(loop.buffer, entry);
    run_bits.* += entry.used_bits;
    if (builtin.is_test) loop.decoded += 1;
}

/// Decodes a pair whose codes the tables hold and copies its match, when the match lies in this
/// call's output at least a word back. Returns false, having used no bit, for any other pair.
inline fn copy_common(comptime options: Options, loop: *Loop, length: lookup.Entry) bool {
    const len = length_of(loop.buffer, length, loop.lengths_resolved) orelse return false;
    const after_length = past(loop.buffer, length);
    const distance_entry = loop.look_up_distance(after_length);
    if (!distance_entry.direct) return false;
    const distance = distance_entry.value + extra_value(after_length, distance_entry);
    if (!copy_near(options, loop, distance, len)) return false;
    loop.consume_pair(length, after_length, distance_entry);
    return true;
}

/// Copies the match a combined entry decodes, its distance's extra bits read after the entry's
/// bits, when the match lies in this call's output at least a word back. Returns false, having
/// used no bit, for any other.
inline fn copy_combined(comptime options: Options, loop: *Loop, entry: lookup.Entry) bool {
    const distance = combined_distance(loop.buffer, entry);
    if (!copy_near(options, loop, distance, entry.combined_length())) return false;
    loop.buffer = past(loop.buffer, entry);
    loop.count -= entry.used_bits;
    if (builtin.is_test) loop.decoded += constants.decodes_per_step_max;
    return true;
}

/// Copies a match of `len` octets from `distance` back, when it lies in this call's output at
/// least a word back, and counts its octets written and its two symbols. Returns false, having
/// written nothing, for any other.
inline fn copy_near(comptime options: Options, loop: *Loop, distance: u64, len: u64) bool {
    // The source is in this call's output when the subtraction does not pass its start.
    _ = std.math.sub(u64, loop.written, distance) catch return false;
    if (distance > loop.distance_max) return false;
    if (distance < constants.copy_word_len) return false;
    if (options.claims.chunk_copies) {
        if (distance >= constants.copy_chunk_len) {
            fast_copy.copy_chunks(constants.copy_chunk_len, loop.output, loop.written, @intCast(distance), @intCast(len));
        } else {
            fast_copy.copy_chunks(constants.copy_word_len, loop.output, loop.written, @intCast(distance), @intCast(len));
        }
    } else {
        fast_copy.copy_exact(loop.output, loop.written, @intCast(distance), @intCast(len));
    }
    loop.written += @intCast(len);
    if (options.count_lookups) {
        count_symbol(loop, .table);
        count_symbol(loop, .table);
    }
    return true;
}

/// A distance symbol's base, and the mask of its extra bits (RFC 1951 §3.2.5).
pub const DistanceCode = packed struct(u32) { base: u16, mask: u16 };

/// Each distance symbol's base and extra bits' mask, with a slot for each value of a symbol's
/// bits, so a combined entry's symbol indexes it with no bounds check. Symbols 30 and 31 never
/// occur (§3.2.6), and no combined entry holds them.
pub const distance_codes: [1 << @bitSizeOf(u5)]DistanceCode = codes: {
    var codes: [1 << @bitSizeOf(u5)]DistanceCode = @splat(.{ .base = 0, .mask = 0 });
    for (constants.distance_base, constants.distance_extra_bits, 0..) |base, extra_bits, symbol| {
        codes[symbol] = .{ .base = base, .mask = (1 << extra_bits) - 1 };
    }
    break :codes codes;
};

/// The distance a combined entry decodes: its symbol's base, and the extra bits after the codes
/// of the length and the distance, which the entry's `code_bits` say where they start.
pub inline fn combined_distance(buffer: u64, entry: lookup.Entry) u64 {
    const code = distance_codes[entry.combined_distance_symbol()];
    return code.base + ((buffer >> entry.code_bits) & code.mask);
}

/// The length a length's entry and the bits after its code give: the entry's value, or its base
/// and the extra bits after the code; null for a length of 258 from extra bits, which the checked
/// path refuses. A table built plain leaves every length's extra bits in the stream, none for a
/// length of 3 to 10, so each length reads them, with no branch on which it is; a table that
/// `resolved` its lengths holds most whole.
pub inline fn length_of(buffer: u64, length: lookup.Entry, resolved: bool) ?u64 {
    if (resolved and !length.extra) return length.value;
    const len = length.value + extra_value(buffer, length);
    // RFC 1951 §3.2.5: 258 has code 285 alone, which takes no extra bits.
    if (len == constants.match_len_max and length.extra) return null;
    return len;
}

/// Counts a symbol the fast path decoded, for S2's count (options.zig). Each call is under a
/// comptime test of `Options.count_lookups`, so a decode that does not count evaluates nothing.
pub inline fn count_symbol(loop: *Loop, how: How) void {
    loop.lookups.count(how);
}

test {
    _ = @import("fast_copy.zig");
    _ = @import("fast_step.zig");
    _ = @import("fast_lengths.zig");
    _ = @import("fast_aarch64.zig");
    _ = @import("fast_x86_64.zig");
    _ = @import("fast_test.zig");
}
