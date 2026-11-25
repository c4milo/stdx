//! The Zstandard decoder's literal loops in x86-64 assembly (decision 23): the aarch64 loops'
//! port, which `fast_literals_aarch64.zig` describes, on a CPU with BMI2. Each stream's word and position stay in registers, r8 to r11 and r12 to r15; its source
//! and its output stay in `Streams`, which a pass reads once for each stream. A code's length is its
//! cell's low octet, and SHLX shifts the word by the whole cell, whose higher octets add a multiple
//! of 64, which the shift ignores.
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
const sequences_x86_64 = @import("fast_sequences/fast_sequences_x86_64.zig");

/// Whether the assembly takes the loops: an x86-64 target whose compiler assembles them, four
/// streams, and the claim of Z1 on. The CPU's BMI2 is checked when a section runs.
pub fn takes(comptime count: usize, comptime claims: Claims) bool {
    return sequences_x86_64.assembles and builtin.cpu.arch == .x86_64 and count == streams_len and claims.interleaved_streams;
}

const streams_len = constants.literal_streams;

/// The literals, or pairs, a pass decodes of each stream: as many codes of the table's longest as
/// a word loaded before the last holds, at most `constants.literals_per_load_max`.
fn per_pass(bits_max: u4) usize {
    return @min((constants.pipelined_load_bits - @as(usize, bits_max)) / bits_max, constants.literals_per_load_max);
}

/// The position a pass needs in every stream: its last code's word loads from this many bits in,
/// after the codes before it.
fn needed_of(bits_max: u4) usize {
    return constants.pipelined_load_bits + (per_pass(bits_max) - 1) * @as(usize, bits_max);
}

/// A pair's store writes two octets, whatever its count.
const pair_store_len = @sizeOf(u16);

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
    /// For literals one a lookup: the literals of each stream `passes` passes write.
    written_max: usize,
};

/// Decodes literals one a lookup, a pass of each stream at a time, as `fast_literals.decode_loads`
/// does, for a caller that checked `takes` and that the CPU runs the assembly. Returns the literals
/// of each stream it wrote, the same for all.
pub fn decode_singles(comptime bits_max: u4, table: *const huffman.Table, streams: [streams_len][]const u8, outputs: [streams_len][]u8, readers: *[streams_len]codec.BackwardBitReader) usize {
    const n = comptime per_pass(bits_max);
    var shortest = outputs[0].len;
    for (outputs[1..]) |output| shortest = @min(shortest, output.len);
    var loop = streams_of(bits_max, streams, outputs, readers);
    loop.table = @ptrCast(&table.cells);
    loop.passes = shortest / n;
    loop.written_max = loop.passes * n;
    const written = singles(bits_max, &loop);
    assert(written <= loop.written_max and written % n == 0);
    for (readers, loop.positions) |*reader, position| reader.position = position;
    return written;
}

/// Decodes literals in pairs (Z2), a pass of each stream at a time, as
/// `fast_literals.decode_pair_loads` does, for a caller that checked `takes`, that the CPU runs the
/// assembly, and that the table's pairs are built. Returns the literals of each stream it wrote.
pub fn decode_pairs(comptime bits_max: u4, table: *const huffman.Table, streams: [streams_len][]const u8, outputs: [streams_len][]u8, readers: *[streams_len]codec.BackwardBitReader) [streams_len]usize {
    const n = comptime per_pass(bits_max);
    var done: [streams_len]usize = @splat(0);
    // A pass stores two octets a pair.
    for (outputs) |output| if (output.len < pair_store_len * n) return done;
    var loop = streams_of(bits_max, streams, outputs, readers);
    loop.table = @ptrCast(&table.pairs);
    for (&loop.limits, outputs) |*limit, output| limit.* = output[output.len - pair_store_len * n ..].ptr;
    pairs(bits_max, &loop);
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

/// Literals one a lookup, a pass of each stream at a time, over `loop` as `decode_singles` sets it
/// up. Returns the literals of each stream it wrote.
fn singles(comptime bits_max: u4, loop: *Streams) usize {
    return asm volatile (single_template(bits_max)
        : [written] "={rax}" (-> usize),
        : [loop] "{rdi}" (loop),
        : clobbers);
}

/// Pairs (Z2), a pass of each stream at a time, over `loop` as `decode_pairs` sets it up; each
/// stream's output and position go back to `loop`.
fn pairs(comptime bits_max: u4, loop: *Streams) void {
    asm volatile (pair_template(bits_max)
        :
        : [loop] "{rdi}" (loop),
        : clobbers);
}

/// The registers the loops write: rsi the table; r8 to r11 the words and r12 to r15 the positions;
/// rbx the literals each stream took, or a pair's next load; rax, rcx and rdx each step's values.
const clobbers: std.builtin.assembly.Clobbers = .{ .memory = true, .cc = true, .rax = true, .rbx = true, .rcx = true, .rdx = true, .rsi = true, .r8 = true, .r9 = true, .r10 = true, .r11 = true, .r12 = true, .r13 = true, .r14 = true, .r15 = true };

/// The registers of each stream, stream 0's first.
const first_word_register = 8;
const first_position_register = 12;

fn word_of(comptime stream: usize) []const u8 {
    return std.fmt.comptimePrint("r{d}", .{first_word_register + stream});
}

fn position_of(comptime stream: usize) []const u8 {
    return std.fmt.comptimePrint("r{d}", .{first_position_register + stream});
}

fn field(comptime name: []const u8, comptime stream: usize) usize {
    return @offsetOf(Streams, name) + stream * @sizeOf(u64);
}

/// Loads the table and the positions.
const prologue = prologue: {
    var text: []const u8 =
        \\    .intel_syntax noprefix
        \\
    ++ std.fmt.comptimePrint("    mov rsi, qword ptr [rdi + {d}]\n", .{@offsetOf(Streams, "table")});
    for (0..streams_len) |stream| text = text ++ std.fmt.comptimePrint("    mov {s}, qword ptr [rdi + {d}]\n", .{ position_of(stream), field("positions", stream) });
    break :prologue text;
};

/// Each stream's first word: the 8 octets whose last holds the bit below its position, shifted so
/// that bit leads, 57 bits at least (RFC 8878 §4.1).
const first_words = first_words: {
    var text: []const u8 = "";
    for (0..streams_len) |stream| text = text ++ std.fmt.comptimePrint(
        \\    lea rax, [{[position]s} - {[read_min]d}]
        \\    mov rcx, rax
        \\    shr rcx, 3
        \\    mov rdx, qword ptr [rdi + {[source]d}]
        \\    mov {[word]s}, qword ptr [rdx + rcx]
        \\    not eax
        \\    and eax, 7
        \\    shlx {[word]s}, {[word]s}, rax
        \\
    , .{ .word = word_of(stream), .position = position_of(stream), .source = field("sources", stream), .read_min = constants.fast_read_position_min });
    break :first_words text;
};

/// Whether every stream holds a pass's bits: to 9 where one does not.
const positions_hold = positions_hold: {
    var text: []const u8 = std.fmt.comptimePrint("    mov rax, qword ptr [rdi + {d}]\n", .{@offsetOf(Streams, "needed")});
    for (0..streams_len) |stream| text = text ++ std.fmt.comptimePrint("    cmp {s}, rax\n    jb 9f\n", .{position_of(stream)});
    break :positions_hold text;
};

/// The positions stored back.
const epilogue = epilogue: {
    var text: []const u8 = "9:\n";
    for (0..streams_len) |stream| text = text ++ std.fmt.comptimePrint("    mov qword ptr [rdi + {d}], {s}\n", .{ field("positions", stream), position_of(stream) });
    break :epilogue text;
};

/// The stream's next word, loaded before its pass's last code from the octets that end at the one
/// holding the bit below the highest position the code may leave, `temporary` that octet's index,
/// and aligned by the code's length once the position it leaves is known.
fn next_word(comptime stream: usize, comptime temporary: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\    mov {[word]s}, qword ptr [rdi + {[source]d}]
        \\    mov {[word]s}, qword ptr [{[word]s} + {[temporary]s} - 7]
        \\    lea {[temporary]s}, [8*{[temporary]s} + 8]
        \\    sub {[temporary]s}, {[position]s}
        \\    shlx {[word]s}, {[word]s}, {[temporary]s}
        \\
    , .{ .word = word_of(stream), .position = position_of(stream), .source = field("sources", stream), .temporary = temporary });
}

/// The octet index `next_word` loads from, taken from the position before the last code.
fn next_octet(comptime stream: usize, comptime temporary: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\    lea {[temporary]s}, [{[position]s} - 2]
        \\    shr {[temporary]s}, 3
        \\
    , .{ .position = position_of(stream), .temporary = temporary });
}

/// A literal: the cell the word's top `bits_max` bits index, its literal stored at the stream's
/// output, rcx, past the literals each stream took, rbx, and the word and position moved past its
/// code. The last of a pass takes the next word.
fn single(comptime stream: usize, comptime at: usize, comptime bits_max: u4, comptime last: bool) []const u8 {
    const lookup = std.fmt.comptimePrint(
        \\    mov rax, {[word]s}
        \\    shr rax, {[top]d}
        \\    movzx eax, word ptr [rsi + rax*2]
        \\    mov byte ptr [rcx + rbx + {[at]d}], ah
        \\
    , .{ .word = word_of(stream), .top = @bitSizeOf(u64) - @as(usize, bits_max), .at = at });
    if (!last) return lookup ++ std.fmt.comptimePrint(
        \\    shlx {[word]s}, {[word]s}, rax
        \\    movzx edx, al
        \\    sub {[position]s}, rdx
        \\
    , .{ .word = word_of(stream), .position = position_of(stream) });
    return next_octet(stream, "rdx") ++ lookup ++ std.fmt.comptimePrint(
        \\    movzx eax, al
        \\    sub {[position]s}, rax
        \\
    , .{ .position = position_of(stream) }) ++ next_word(stream, "rdx");
}

/// A pair: as `single`, its literals stored two octets whatever its count, and the output, rcx,
/// moved past the ones it holds.
fn pair(comptime stream: usize, comptime bits_max: u4, comptime last: bool) []const u8 {
    const lookup = std.fmt.comptimePrint(
        \\    mov rax, {[word]s}
        \\    shr rax, {[top]d}
        \\    mov eax, dword ptr [rsi + rax*4]
        \\    mov edx, eax
        \\    shr edx, 16
        \\    mov word ptr [rcx], dx
        \\    movzx edx, ah
        \\    add rcx, rdx
        \\
    , .{ .word = word_of(stream), .top = @bitSizeOf(u64) - @as(usize, bits_max) });
    if (!last) return lookup ++ std.fmt.comptimePrint(
        \\    shlx {[word]s}, {[word]s}, rax
        \\    movzx edx, al
        \\    sub {[position]s}, rdx
        \\
    , .{ .word = word_of(stream), .position = position_of(stream) });
    return next_octet(stream, "rbx") ++ lookup ++ std.fmt.comptimePrint(
        \\    movzx eax, al
        \\    sub {[position]s}, rax
        \\
    , .{ .position = position_of(stream) }) ++ next_word(stream, "rbx");
}

/// A pass of literals one a lookup: each stream's in turn, its output in rcx.
fn single_pass(comptime bits_max: u4) []const u8 {
    const n = per_pass(bits_max);
    comptime var body: []const u8 = "";
    inline for (0..streams_len) |stream| {
        body = body ++ std.fmt.comptimePrint("    mov rcx, qword ptr [rdi + {d}]\n", .{field("outputs", stream)});
        inline for (0..n - 1) |at| body = body ++ single(stream, at, bits_max, false);
        body = body ++ single(stream, n - 1, bits_max, true);
    }
    return body;
}

/// A pass of pairs: each stream's in turn, its output in rcx and back to `Streams` after.
fn pair_pass(comptime bits_max: u4) []const u8 {
    const n = per_pass(bits_max);
    comptime var body: []const u8 = "";
    inline for (0..streams_len) |stream| {
        body = body ++ std.fmt.comptimePrint("    mov rcx, qword ptr [rdi + {d}]\n", .{field("outputs", stream)});
        inline for (0..n - 1) |_| body = body ++ pair(stream, bits_max, false);
        body = body ++ pair(stream, bits_max, true) ++ std.fmt.comptimePrint("    mov qword ptr [rdi + {d}], rcx\n", .{field("outputs", stream)});
    }
    return body;
}

/// Literals one a lookup: rbx the literals each stream took, which it returns, up to `written_max`.
fn single_template(comptime bits_max: u4) []const u8 {
    const written_max = @offsetOf(Streams, "written_max");
    return prologue ++ std.fmt.comptimePrint(
        \\    xor ebx, ebx
        \\    cmp qword ptr [rdi + {d}], 0
        \\    je 9f
        \\
    , .{written_max}) ++ positions_hold ++ first_words ++
        \\    // The loop starts a fetch line of its own.
        \\    .p2align 6
        \\1:
        \\
    ++ single_pass(bits_max) ++ std.fmt.comptimePrint(
        \\    add rbx, {d}
        \\    cmp rbx, qword ptr [rdi + {d}]
        \\    jae 9f
        \\
    , .{ per_pass(bits_max), written_max }) ++ positions_hold ++
        \\    jmp 1b
        \\
    ++ epilogue ++
        \\    mov rax, rbx
        \\    .att_syntax prefix
        \\
    ;
}

/// Pairs: every output below its limit before each pass; the outputs and positions go back to
/// `Streams`.
fn pair_template(comptime bits_max: u4) []const u8 {
    comptime var limits_hold: []const u8 = "";
    inline for (0..streams_len) |stream| limits_hold = limits_hold ++ std.fmt.comptimePrint(
        \\    mov rax, qword ptr [rdi + {d}]
        \\    cmp rax, qword ptr [rdi + {d}]
        \\    ja 9f
        \\
    , .{ field("outputs", stream), field("limits", stream) });
    return prologue ++ positions_hold ++ limits_hold ++ first_words ++
        \\    // The loop starts a fetch line of its own.
        \\    .p2align 6
        \\1:
        \\
    ++ pair_pass(bits_max) ++ positions_hold ++ limits_hold ++
        \\    jmp 1b
        \\
    ++ epilogue ++
        \\    .att_syntax prefix
        \\
    ;
}

comptime {
    // A cell's code length is its low octet and its literal the next, and a pair's length is its low
    // octet, its count the next and its literals the high 16 bits.
    assert(@bitOffsetOf(huffman.Entry, "bits") == 0 and @bitOffsetOf(huffman.Entry, "symbol") == @bitSizeOf(u8));
    assert(@bitOffsetOf(huffman.Pair, "bits") == 0 and @bitOffsetOf(huffman.Pair, "count") == @bitSizeOf(u8));
    assert(@bitOffsetOf(huffman.Pair, "literals") == 2 * @bitSizeOf(u8));
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
