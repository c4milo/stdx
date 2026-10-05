//! A run of plain ASCII copied as it is scanned (claims J1, J3 and J7): its octets go to the
//! output a block at a time as each block is tested, each loaded once. The encoder's token loop
//! takes a long string with it (encoder_loop_plain.zig), and the decoder's loop the run of a long
//! string past its first blocks (decoder_loop_copy.zig). Scanned and then copied, a megabyte of
//! plain ASCII came through the cache twice (design §8 step 18).
//!
//! Four blocks a pass under one test, each block stored as it is loaded, at addresses that are
//! multiples of the block's width, so that no store of the pass spans two cache lines. The copy
//! writes the run at the least: past the octet that ends it, the output holds octets of the
//! input or what it held, which no caller reports as written (decision 11).
//!
//! Each function reads and writes the slices it is given, whose bounds Zig checks (ReleaseSafe),
//! as scan.zig's scans do: they keep their checks when a caller turns the encoder's token loop's
//! off (decision 35).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const scan = @import("scan.zig");
const wide = @import("wide.zig");

const Block = scan.Block;
const Lanes = scan.Lanes;

/// The blocks one pass of `copy_plain_vector` takes under one test.
pub const pass_blocks = 4;

/// Whether a pass folds its blocks before it compares them, and finds a quotation mark and a
/// reverse solidus by their distance from the octet between them: on aarch64, where the N2 has
/// two pipes for vector instructions, and each one a block saves is time (design §8 step 18).
const folds = builtin.cpu.arch == .aarch64;

/// How far the quotation mark and the reverse solidus each stand from the octet halfway between
/// them, and that octet. No other octet stands that far from it, so one difference and one compare
/// find both, where a compare for each and an OR took three instructions.
const marks_distance = (constants.reverse_solidus - constants.quotation_mark) >> 1;
const marks_middle = constants.quotation_mark + marks_distance;

comptime {
    assert(marks_middle + marks_distance == constants.reverse_solidus);
}

/// `copy_plain_vector` at AVX2's 32 octets, in that level's variant object (variants/scan_wide.zig).
extern fn stdx_json_copy_plain_x86_64_avx2(destination: [*]u8, source: [*]const u8, len: usize, from: usize) callconv(.c) usize;

/// The lanes that hold a quotation mark or a reverse solidus, which a string must escape (RFC
/// 8259 §7).
inline fn marks(comptime width: usize, block: Block(width)) Lanes(width) {
    if (comptime folds) {
        const middle = scan.splat(width, marks_middle);
        return @max(block, middle) - @min(block, middle) == scan.splat(width, marks_distance);
    }
    const quotation_mark = block == scan.splat(width, constants.quotation_mark);
    const reverse_solidus = block == scan.splat(width, constants.reverse_solidus);
    return quotation_mark | reverse_solidus;
}

/// A block's octets read as signed. A control character and an octet from 0x80 up are both below
/// U+0020 then, so one compare finds every octet outside U+0020 to U+007F (RFC 8259 §7).
inline fn signed(comptime width: usize, block: Block(width)) @Vector(width, i8) {
    return @bitCast(block);
}

inline fn below_space(comptime width: usize, octets: @Vector(width, i8)) Lanes(width) {
    return octets < @as(@Vector(width, i8), @splat(constants.unescaped_min));
}

/// The lanes whose octet a string must escape or is not ASCII (RFC 8259 §7): what
/// `scan.is_plain_ascii` refuses.
pub inline fn block_stops(comptime width: usize, block: Block(width)) Lanes(width) {
    return below_space(width, signed(width, block)) | marks(width, block);
}

/// Lanes of which one holds when a block of `blocks` holds a stop. Where `folds` holds, the least
/// of a lane's four octets, read as signed, is below U+0020 when one of the four is, so one compare
/// answers the four blocks.
inline fn pass_stops(comptime width: usize, blocks: *const [pass_blocks]Block(width)) Lanes(width) {
    if (comptime !folds) {
        var stops = block_stops(width, blocks[0]);
        inline for (1..pass_blocks) |at| stops = stops | block_stops(width, blocks[at]);
        return stops;
    }
    var least = signed(width, blocks[0]);
    var marked = marks(width, blocks[0]);
    inline for (1..pass_blocks) |at| {
        least = @min(least, signed(width, blocks[at]));
        marked = marked | marks(width, blocks[at]);
    }
    return below_space(width, least) | marked;
}

/// Copies one block, and returns the first lane of it that holds a stop, or null when none does.
pub inline fn copy_block(comptime width: usize, destination: *[width]u8, source: *const [width]u8) ?usize {
    const block: Block(width) = source.*;
    destination.* = block;
    const stops = block_stops(width, block);
    return if (scan.any(width, stops)) scan.first_lane(width, stops) else null;
}

/// Copies `source` into `destination`, of the same length, from the octet at `from` on, and
/// returns where the first octet stands that a string must escape or that is not ASCII, or the
/// length when none does: `copy_plain_vector`, at the widest vector `level` allows. The octets
/// before `from` are plain ASCII, which the caller copied, and at least 16 of them. In a function
/// of its own: a long run's loop compiled inside its caller's ran slower on the N2 (wide.zig). On
/// x86-64 the level's kernel takes what a run holds past `wide_run_len_min` octets, as it does
/// for a run's scan.
pub noinline fn copy_from(level: wide.Level, destination: []u8, source: []const u8, from: usize) align(constants.kernel_alignment) usize {
    const narrow = constants.vector_len;
    if (comptime !wide.has_kernels) return copy_plain_vector(narrow, from, destination, source);
    const kernel_from = @max(from, constants.wide_run_len_min);
    if (level == .target or source.len <= kernel_from + constants.avx2_vector_len) return copy_plain_vector(narrow, from, destination, source);
    if (from < kernel_from) {
        const head = copy_plain_vector(narrow, from, destination[0..kernel_from], source[0..kernel_from]);
        if (head < kernel_from) return head;
    }
    return switch (level) {
        .avx2 => stdx_json_copy_plain_x86_64_avx2(destination.ptr, source.ptr, source.len, kernel_from),
        .target => unreachable,
    };
}

/// Where the blocks of a destination at `address` start: at the last octet up to `from` whose
/// address is a multiple of `width`, so that each block's store stays inside one cache line.
pub fn blocks_start(comptime width: usize, address: usize, from: usize) usize {
    return from - (address + from) % width;
}

/// Copies `source` into `destination`, of the same length, from the octet at `from` on, a block
/// of `width` octets at a time, and returns where the first octet stands that a string must escape
/// or that is not ASCII, or the length when none does. The octets before `from` are plain ASCII,
/// which the caller copied, and at least a block of them: so what it returns is
/// `scan.plain_len_scalar`'s count. It copies that run at the least.
///
/// The blocks start at `blocks_start`, up to a block before `from`: the octets between were
/// copied, and are copied again. The octets the whole blocks leave take one more block, the last
/// `width` octets, which overlaps the block before it.
pub fn copy_plain_vector(comptime width: usize, from: usize, destination: []u8, source: []const u8) align(constants.kernel_alignment) usize {
    const len = source.len;
    assert(destination.len == len);
    assert(from >= width);
    assert(from <= len);
    const pass_len = pass_blocks * width;
    var index = blocks_start(width, @intFromPtr(destination.ptr), from);
    for (0..(len - index) / pass_len) |_| {
        // A pass's octets as two arrays, each checked once: checked a block at a time, the
        // checks were a third of the pass's instructions.
        const taken = source[index..][0..pass_len];
        const stored = destination[index..][0..pass_len];
        var blocks: [pass_blocks]Block(width) = undefined;
        inline for (&blocks, 0..) |*block, at| {
            block.* = taken[at * width ..][0..width].*;
            stored[at * width ..][0..width].* = block.*;
        }
        // The blocks below find where the pass's stop stands.
        if (scan.any(width, pass_stops(width, &blocks))) break;
        index += pass_len;
    }
    for (0..(len - index) / width) |_| {
        if (copy_block(width, destination[index..][0..width], source[index..][0..width])) |lane| return index + lane;
        index += width;
    }
    if (index == len) return len;
    const last = len - width;
    const lane = copy_block(width, destination[last..][0..width], source[last..][0..width]) orelse return len;
    return last + lane;
}

test {
    _ = @import("plain_copy_test.zig");
}
