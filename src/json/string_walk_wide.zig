//! The walk's blocks past a run's ASCII 32 octets at a time, for the decoder's walk in the AVX2
//! variant object, whose `copy_rest` names the width (variants/loop_string.zig). Decision 30 kept
//! the walk's UTF-8 blocks at 16 octets after a check at 64 ran text of Cyrillic and CJK
//! characters 37% slower; at 32, the check alone ran 1.8 times as fast as at 16 on the x86-64
//! runners (decision 39), and the decoder's walk at 16 decoded that text at 0.84 to 0.86 of
//! simdjson's speed on an AMD EPYC 9V45. The owner reopened the width for this path on
//! 2026-10-09 (decision 47, design §8 step 18).
//!
//! Every other caller of the walk, and every target but x86-64 with AVX2, keeps
//! `Walk.take_blocks` at 16 octets. It reads and writes the walk's slices, whose bounds Zig checks
//! (ReleaseSafe).

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");
const scan = @import("scan.zig");
const scan_utf8 = @import("scan_utf8.zig");
const string_walk = @import("string_walk.zig");
const Stop = string_walk.Stop;

/// The octets of a block: one AVX2 register.
pub const block_len = constants.avx2_vector_len;
const Block = @Vector(block_len, u8);

/// How a block's UTF-8 is judged: by the lookup where x86-64 has VPSHUFB for 32 lanes (decision
/// 39), and by the compares on every other target, where the tests run the walk at this width.
const form: scan_utf8.Form = if (builtin.cpu.arch == .x86_64 and scan_utf8.has_lookup) .lookup else .compares;

/// What `take_blocks` took: the octets the walk then moves past, the same in the input and in
/// the output since the blocks copy them as they are, and how the blocks stopped.
pub const Taken = struct { len: usize, stop: Stop };

/// `Walk.take_blocks` 32 octets a block, from the start of `input`, the walk's input left, into
/// `output`, its room left: copies blocks while both hold one, each as it is checked, up to the
/// first octet that stops the run. Short of a block, it steps back to the start of a character the
/// last block cut, which `Walk.take_run` then takes whole.
///
/// The decoder's walk reaches it at a run's first octet from 0x80 up, past `Walk.take_ascii` or
/// at the run's start, so no character crosses into the input: the block before the first is all
/// zeros. Out of line, from the start of a 64-octet line: its loop keeps its eleven constants of
/// 32 lanes in registers, 46 instructions a block, and the walk's function holds no register of
/// 32 lanes. Inline, the walk held eight of the constants across its other loops and this loop
/// read three from memory on each pass; an AMD EPYC 7763 then decoded the Cyrillic and CJK text
/// at 1.41 to 1.43 of main's speed, against 1.37 out of line, and this form is the one decision
/// 20's null build priced (design §8 step 18).
pub noinline fn take_blocks(input: []const u8, output: []u8) align(constants.kernel_alignment) Taken {
    var len: usize = 0;
    var previous: Block = @splat(0);
    for (0..input.len / block_len) |_| {
        // The count of passes leaves a block of input to each; the room's is tested.
        const input_left = input[len..];
        const output_left = output[len..];
        if (output_left.len < block_len) break;
        const block: Block = input_left[0..block_len].*;
        output_left[0..block_len].* = block;
        // A string escapes U+0000 to U+001F, the quotation mark and the reverse solidus (RFC 8259
        // §7), and holds UTF-8 alone (RFC 3629 §4).
        const errors = scan_utf8.error_octets(block_len, form, previous, block) != @as(Block, @splat(0));
        const stops = scan.escape_lanes(block_len, block) | errors;
        if (scan.any(block_len, stops)) {
            const lane = scan.first_lane(block_len, stops);
            if (scan.lane_holds(block_len, errors, lane)) return .{ .len = len, .stop = .ruled_out };
            return .{ .len = len + lane, .stop = .octet };
        }
        previous = block;
        len += block_len;
    }
    return .{ .len = len - scan.cut_character_len(input[0..len]), .stop = .short };
}
