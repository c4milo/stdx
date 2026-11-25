//! The Zstandard decoder's literal loops in aarch64 assembly (decision 23): four Huffman-coded
//! streams decoded a pass at a time, a literal a lookup or two (claim Z2), each stream's state in
//! registers the assembly allots, writing the literals `fast_literals`' Zig loops write.
//!
//! A literal is a chain of three instructions: the index from the word's top bits, the cell, and the
//! word shifted by the cell's code, 7 cycles on the cores this was measured on. A pass decodes `per_pass`
//! literals of one stream, then of the next, so each stream's chain is dispatched whole. The Zig
//! loops reload a stream's word after its pass, which puts the load's latency on the chain; here the
//! next word is loaded before the pass's last code, whose length alone is still unknown, so only an
//! add and a shift that align the word by that length remain on the chain
//! (`constants.pipelined_load_bits`).
//!
//! Its reads and writes go by address, without Zig's bounds checks. Each pass starts only where
//! every stream holds the bits its loads read and every output the literals its stores write, which
//! keep them inside the streams, the table and the outputs.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const Claims = @import("claims.zig").Claims;

const streams_len = constants.literal_streams;

/// Whether the assembly takes the loops: an aarch64 target, whose octets are little-endian, four
/// streams, and the claim of Z1 on.
pub fn takes(comptime count: usize, comptime claims: Claims) bool {
    return builtin.cpu.arch == .aarch64 and count == streams_len and claims.interleaved_streams;
}

/// The literals, or pairs, a pass decodes of each stream: as many codes of the table's longest as
/// a word loaded before the last holds, at most `constants.literals_per_load_max`.
pub fn per_pass(bits_max: u4) usize {
    return @min((constants.pipelined_load_bits - @as(usize, bits_max)) / bits_max, constants.literals_per_load_max);
}

/// The position a pass needs in every stream: its last code's word loads from this many bits in,
/// after the codes before it.
fn needed_of(bits_max: u4) usize {
    return constants.pipelined_load_bits + (per_pass(bits_max) - 1) * @as(usize, bits_max);
}

/// The registers that hold each stream's values, stream 0's first: its source, its output, its word
/// and its position.
const source_register = 2;
const output_register = 6;
const word_register = 10;
const position_register = 14;

/// A pair's store writes two octets, whatever its count.
const pair_store_len = @sizeOf(u16);

/// The offset of a four-entry field's last two entries, which one `ldp` or `stp` takes after the
/// first two.
const upper_half = @sizeOf(u128);

/// The loops' state, as the assembly reads and writes it: every field 8 octets, at the offsets the
/// templates name.
const Streams = extern struct {
    sources: [streams_len][*]const u8,
    /// Where each stream's next literal goes.
    outputs: [streams_len][*]u8,
    /// Each stream's position: the bits before it are not read yet.
    positions: [streams_len]usize,
    /// The table's cells, or its pairs.
    table: [*]const u8,
    /// The passes the outputs hold, for literals one a lookup.
    passes: usize,
    needed: usize,
    /// For pairs: the last place in each output a pass may start, its end less a pass's stores.
    limits: [streams_len][*]const u8,
};

comptime {
    assert(@offsetOf(Streams, "outputs") == streams_len * @sizeOf(u64));
    assert(@offsetOf(Streams, "positions") == 2 * streams_len * @sizeOf(u64));
    assert(@offsetOf(Streams, "table") == 3 * streams_len * @sizeOf(u64));
    assert(@offsetOf(Streams, "passes") == @offsetOf(Streams, "table") + @sizeOf(u64));
    assert(@offsetOf(Streams, "needed") == @offsetOf(Streams, "passes") + @sizeOf(u64));
    assert(@offsetOf(Streams, "limits") == @offsetOf(Streams, "needed") + @sizeOf(u64));
    // A cell's code length is its low octet and its literal the next, and a pair's length is its low
    // octet, its count the next and its literals the high 16 bits.
    assert(@bitOffsetOf(huffman.Entry, "bits") == 0 and @bitOffsetOf(huffman.Entry, "symbol") == @bitSizeOf(u8));
    assert(@bitOffsetOf(huffman.Pair, "bits") == 0 and @bitOffsetOf(huffman.Pair, "count") == @bitSizeOf(u8));
    assert(@bitOffsetOf(huffman.Pair, "literals") == 2 * @bitSizeOf(u8));
    assert(streams_len == 4);
}

/// Decodes literals one a lookup, a pass of each stream at a time, as `fast_literals.decode_loads`
/// does, for a caller that checked `takes`. Returns the literals of each stream it wrote, the same
/// for all.
pub fn decode_singles(comptime bits_max: u4, table: *const huffman.Table, streams: [streams_len][]const u8, outputs: [streams_len][]u8, readers: *[streams_len]codec.BackwardBitReader) usize {
    const n = comptime per_pass(bits_max);
    var shortest = outputs[0].len;
    for (outputs[1..]) |output| shortest = @min(shortest, output.len);
    var loop = streams_of(bits_max, streams, outputs, readers);
    loop.table = @ptrCast(&table.cells);
    loop.passes = shortest / n;
    const passes = asm volatile (single_template(bits_max)
        : [passes] "={x0}" (-> usize),
        : [loop] "{x0}" (&loop),
        : clobbers);
    assert(passes <= loop.passes);
    for (readers, loop.positions) |*reader, position| reader.position = position;
    return passes * n;
}

/// Decodes literals in pairs (Z2), a pass of each stream at a time, as
/// `fast_literals.decode_pair_loads` does, for a caller that checked `takes` and built the table's
/// pairs. Returns the literals of each stream it wrote.
pub fn decode_pairs(comptime bits_max: u4, table: *const huffman.Table, streams: [streams_len][]const u8, outputs: [streams_len][]u8, readers: *[streams_len]codec.BackwardBitReader) [streams_len]usize {
    const n = comptime per_pass(bits_max);
    var done: [streams_len]usize = @splat(0);
    // A pass stores two octets a pair.
    for (outputs) |output| if (output.len < pair_store_len * n) return done;
    var loop = streams_of(bits_max, streams, outputs, readers);
    loop.table = @ptrCast(&table.pairs);
    for (&loop.limits, outputs) |*limit, output| limit.* = output[output.len - pair_store_len * n ..].ptr;
    asm volatile (pair_template(bits_max)
        :
        : [loop] "{x0}" (&loop),
        : clobbers);
    for (readers, loop.positions, &done, loop.outputs, outputs) |*reader, position, *len, next, output| {
        reader.position = position;
        len.* = @intFromPtr(next) - @intFromPtr(output.ptr);
        assert(len.* <= output.len);
    }
    return done;
}

fn streams_of(comptime bits_max: u4, streams: [streams_len][]const u8, outputs: [streams_len][]u8, readers: *[streams_len]codec.BackwardBitReader) Streams {
    var loop: Streams = undefined;
    for (&loop.sources, &loop.outputs, &loop.positions, streams, outputs, readers) |*source, *output, *position, stream, out, *reader| {
        source.* = stream.ptr;
        output.* = out.ptr;
        position.* = reader.position;
    }
    loop.needed = comptime needed_of(bits_max);
    return loop;
}

/// The registers the loops write: x1 the table; x2 to x5 the streams; x6 to x9 the outputs; x10 to
/// x13 the words; x14 to x17 the positions; x20 the position a pass needs; x19 and x21, x26 and x27
/// the passes and their count, or the pairs' limits; x22 to x25 each step's values.
const clobbers: std.builtin.assembly.Clobbers = .{ .memory = true, .nzcv = true, .x1 = true, .x2 = true, .x3 = true, .x4 = true, .x5 = true, .x6 = true, .x7 = true, .x8 = true, .x9 = true, .x10 = true, .x11 = true, .x12 = true, .x13 = true, .x14 = true, .x15 = true, .x16 = true, .x17 = true, .x19 = true, .x20 = true, .x21 = true, .x22 = true, .x23 = true, .x24 = true, .x25 = true, .x26 = true, .x27 = true };

/// Loads the state, and each stream's first word: the 8 octets whose last holds the bit below its
/// position, shifted so that bit leads, 57 bits at least (RFC 8878 §4.1).
const prologue = std.fmt.comptimePrint(
    \\    ldp x2, x3, [x0, #{[sources]d}]
    \\    ldp x4, x5, [x0, #{[sources_high]d}]
    \\    ldp x6, x7, [x0, #{[outputs]d}]
    \\    ldp x8, x9, [x0, #{[outputs_high]d}]
    \\    ldp x14, x15, [x0, #{[positions]d}]
    \\    ldp x16, x17, [x0, #{[positions_high]d}]
    \\    ldr x1, [x0, #{[table]d}]
    \\    ldr x20, [x0, #{[needed]d}]
    \\
, .{
    .sources = @offsetOf(Streams, "sources"),
    .sources_high = @offsetOf(Streams, "sources") + upper_half,
    .outputs = @offsetOf(Streams, "outputs"),
    .outputs_high = @offsetOf(Streams, "outputs") + upper_half,
    .positions = @offsetOf(Streams, "positions"),
    .positions_high = @offsetOf(Streams, "positions") + upper_half,
    .table = @offsetOf(Streams, "table"),
    .needed = @offsetOf(Streams, "needed"),
});

fn first_word(comptime stream: usize) []const u8 {
    return std.fmt.comptimePrint(
        \\    sub x22, x{[position]d}, #{[read_min]d}
        \\    lsr x23, x22, #3
        \\    ldr x{[word]d}, [x{[source]d}, x23]
        \\    mvn x22, x22
        \\    and x22, x22, #7
        \\    lsl x{[word]d}, x{[word]d}, x22
        \\
    , .{ .word = word_register + stream, .position = position_register + stream, .source = source_register + stream, .read_min = constants.fast_read_position_min });
}

const first_words = first_words: {
    var words: []const u8 = "";
    for (0..streams_len) |stream| words = words ++ first_word(stream);
    break :first_words words;
};

/// Whether every stream holds a pass's bits: flags hs when all do.
const positions_hold =
    \\    cmp x14, x20
    \\    ccmp x15, x20, #0, hs
    \\    ccmp x16, x20, #0, hs
    \\    ccmp x17, x20, #0, hs
    \\
;

/// Loads the stream's next word before its pass's last code, from the octets that end at the one
/// holding the bit below the highest position the code may leave, `x24` the word's top edge less the
/// position, -1 at the least, to which the code's length adds the shift that aligns it.
fn next_word(comptime stream: usize) []const u8 {
    return std.fmt.comptimePrint(
        \\    sub x24, x{[position]d}, #2
        \\    lsr x24, x24, #3
        \\    add x25, x{[source]d}, x24
        \\    ldur x25, [x25, #-7]
        \\    lsl x24, x24, #3
        \\    add x24, x24, #8
        \\    sub x24, x24, x{[position]d}
        \\
    , .{ .position = position_register + stream, .source = source_register + stream });
}

/// A literal: the cell the word's top `bits_max` bits index, its literal stored, the word shifted
/// by its code, and the position moved past it. The last of a pass takes the next word, aligned.
fn single(comptime stream: usize, comptime at: usize, comptime bits_max: u4, comptime last: bool) []const u8 {
    const shift = if (last)
        \\    add x24, x24, w22, uxtb
        \\    lsl x{[word]d}, x25, x24
        \\
    else
        \\    lsl x{[word]d}, x{[word]d}, x22
        \\
    ;
    return std.fmt.comptimePrint(
        \\    lsr x22, x{[word]d}, #{[top]d}
        \\    ldrh w22, [x1, x22, lsl #1]
        \\    lsr w23, w22, #8
        \\    strb w23, [x{[output]d}, #{[at]d}]
        \\
    ++ shift ++
        \\    sub x{[position]d}, x{[position]d}, w22, uxtb
        \\
    , .{ .word = word_register + stream, .output = output_register + stream, .position = position_register + stream, .at = at, .top = @bitSizeOf(u64) - @as(usize, bits_max) });
}

/// A pair: as `single`, its literals stored two octets whatever its count, and the output moved
/// past the ones it holds.
fn pair(comptime stream: usize, comptime bits_max: u4, comptime last: bool) []const u8 {
    const shift = if (last)
        \\    add x24, x24, w22, uxtb
        \\    lsl x{[word]d}, x25, x24
        \\
    else
        \\    lsl x{[word]d}, x{[word]d}, x22
        \\
    ;
    return std.fmt.comptimePrint(
        \\    lsr x22, x{[word]d}, #{[top]d}
        \\    ldr w22, [x1, x22, lsl #2]
        \\    lsr w23, w22, #16
        \\    strh w23, [x{[output]d}]
        \\    ubfx x23, x22, #8, #8
        \\    add x{[output]d}, x{[output]d}, x23
        \\
    ++ shift ++
        \\    sub x{[position]d}, x{[position]d}, w22, uxtb
        \\
    , .{ .word = word_register + stream, .output = output_register + stream, .position = position_register + stream, .top = @bitSizeOf(u64) - @as(usize, bits_max) });
}

/// A pass: each stream's literals in turn, its next word loaded before its last.
fn single_pass(comptime bits_max: u4) []const u8 {
    const n = per_pass(bits_max);
    comptime var body: []const u8 = "";
    inline for (0..streams_len) |stream| {
        inline for (0..n - 1) |at| body = body ++ single(stream, at, bits_max, false);
        body = body ++ next_word(stream) ++ single(stream, n - 1, bits_max, true);
    }
    return body;
}

fn pair_pass(comptime bits_max: u4) []const u8 {
    const n = per_pass(bits_max);
    comptime var body: []const u8 = "";
    inline for (0..streams_len) |stream| {
        inline for (0..n - 1) |_| body = body ++ pair(stream, bits_max, false);
        body = body ++ next_word(stream) ++ pair(stream, bits_max, true);
    }
    return body;
}

/// Literals one a lookup: x19 the passes the outputs hold, x21 the passes taken, which it returns.
fn single_template(comptime bits_max: u4) []const u8 {
    return prologue ++ std.fmt.comptimePrint(
        \\    ldr x19, [x0, #{[passes]d}]
        \\    mov x21, #0
        \\    cbz x19, 9f
        \\
    , .{ .passes = @offsetOf(Streams, "passes") }) ++ positions_hold ++
        \\    b.lo 9f
        \\
    ++ first_words ++
        \\    // The loop starts a fetch line of its own.
        \\    .p2align 6
        \\1:
        \\
    ++ single_pass(bits_max) ++ std.fmt.comptimePrint(
        \\    add x6, x6, #{[n]d}
        \\    add x7, x7, #{[n]d}
        \\    add x8, x8, #{[n]d}
        \\    add x9, x9, #{[n]d}
        \\    add x21, x21, #1
        \\    cmp x21, x19
        \\    b.hs 9f
        \\
    , .{ .n = per_pass(bits_max) }) ++ positions_hold ++ std.fmt.comptimePrint(
        \\    b.hs 1b
        \\9:
        \\    stp x14, x15, [x0, #{[positions]d}]
        \\    stp x16, x17, [x0, #{[positions_high]d}]
        \\    mov x0, x21
        \\
    , .{ .positions = @offsetOf(Streams, "positions"), .positions_high = @offsetOf(Streams, "positions") + upper_half });
}

/// Pairs: x26, x27, x19 and x21 the outputs' limits; the outputs and positions go back to `Streams`.
fn pair_template(comptime bits_max: u4) []const u8 {
    const limits_hold =
        \\    ccmp x26, x6, #0, hs
        \\    ccmp x27, x7, #0, hs
        \\    ccmp x19, x8, #0, hs
        \\    ccmp x21, x9, #0, hs
        \\
    ;
    return prologue ++ std.fmt.comptimePrint(
        \\    ldp x26, x27, [x0, #{[limits]d}]
        \\    ldp x19, x21, [x0, #{[limits_high]d}]
        \\
    , .{ .limits = @offsetOf(Streams, "limits"), .limits_high = @offsetOf(Streams, "limits") + upper_half }) ++ positions_hold ++ limits_hold ++
        \\    b.lo 9f
        \\
    ++ first_words ++
        \\    // The loop starts a fetch line of its own.
        \\    .p2align 6
        \\1:
        \\
    ++ pair_pass(bits_max) ++ positions_hold ++ limits_hold ++ std.fmt.comptimePrint(
        \\    b.hs 1b
        \\9:
        \\    stp x14, x15, [x0, #{[positions]d}]
        \\    stp x16, x17, [x0, #{[positions_high]d}]
        \\    stp x6, x7, [x0, #{[outputs]d}]
        \\    stp x8, x9, [x0, #{[outputs_high]d}]
        \\
    , .{
        .positions = @offsetOf(Streams, "positions"),
        .positions_high = @offsetOf(Streams, "positions") + upper_half,
        .outputs = @offsetOf(Streams, "outputs"),
        .outputs_high = @offsetOf(Streams, "outputs") + upper_half,
    });
}

comptime {
    for (1..constants.huffman_bits_max + 1) |bits_max| {
        const n = per_pass(bits_max);
        // A pass's codes fit the word loaded before its last, and the first word's 57 bits.
        assert(n * bits_max <= constants.pipelined_load_bits - bits_max and n * bits_max <= constants.fast_read_position_min);
        assert(n >= 2);
    }
}

test "a pass's next word loads from inside its stream, and holds the pass's codes" {
    for (1..constants.huffman_bits_max + 1) |bits| {
        const bits_max: u4 = @intCast(bits);
        const n = per_pass(bits_max);
        // From the least position a pass may start at, its codes before the last take the most they
        // can, and the next word loads from the octets that end at the one holding the bit below
        // the highest position the last code may leave.
        const top = needed_of(bits_max) - (n - 1) * @as(usize, bits_max);
        const last = (top - 2) / 8;
        try std.testing.expect(last >= 7);
        // Below the position the last code leaves, at its longest, the word holds a pass's codes.
        const low = top - bits_max;
        try std.testing.expect(low - (last - 7) * 8 >= n * @as(usize, bits_max));
    }
}
