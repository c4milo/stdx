//! Claim J10's names and strings: their content, past the opening quotation mark, copied a block
//! of 16 at a time inside the token loop while its first two blocks hold the closing quotation mark
//! with plain ASCII before it (`string`), and past them out of the loop's run (`copy_blocks`): the
//! rest of its plain ASCII a block at a time and then at the widest vector the caller's features
//! allow, and its escapes and UTF-8 by decoder_loop_string.zig. A block's store runs past the
//! string's end into room the call does not report written (decision 11).

const constants = @import("../../constants.zig");
const scan = @import("../../scan.zig");
const wide = @import("../../wide.zig");
const Claims = @import("../../claims.zig").Claims;
const Kind = @import("../decoder.zig").Kind;
const Loop = @import("decoder_loop.zig").Loop;
const loop_string = @import("decoder_loop_string.zig");
const Copied = loop_string.Copied;

/// Takes a name or a string whose content the loop copies, and its closing quotation mark, and
/// returns the octets it wrote: a string whose first block of 16, or its second, holds its closing
/// quotation mark with plain ASCII before it. Else it returns null, with `long_string` set for
/// `copy_blocks` to go on from the octets the blocks copied and found plain. Inline and with no
/// call, so the loop's values stay in registers: with the paths that call out inline at every
/// string, aarch64 stored eight of them to the stack at each one (design §8 step 18).
pub inline fn string(loop: *Loop, comptime claims: Claims, comptime kind: Kind) ?usize {
    const content = loop.in[1..];
    if (!claims.decoder_string_vectors) {
        const copied = copy_scalar(loop, content) orelse return null;
        loop.in = content[copied.input_len + 1 ..];
        loop.out = loop.out[copied.output_len..];
        return copied.output_len;
    }
    // The input is counted from the string's opening quotation mark, in one slice: counted from
    // its content, the content's start and length were two values more for the loop to keep, and
    // x86-64 kept the input's address on the stack across every name (design §8 step 18).
    const in = loop.in;
    if (in.len <= constants.vector_len or loop.out.len < constants.vector_len) return leave_long(loop, kind, 0);
    const block: @Vector(constants.vector_len, u8) = in[1..][0..constants.vector_len].*;
    loop.out[0..constants.vector_len].* = block;
    const lane = scan.plain_stop(block) orelse return second_block(loop, kind, content);
    if (!scan.is_quotation_mark(block, lane)) return leave_long(loop, kind, lane);
    loop.in = in[lane + quotation_marks ..];
    loop.out = loop.out[lane..];
    return lane;
}

/// The quotation marks around a string's content, which the loop moves past with it.
const quotation_marks = 2;

/// `string` on past its first block of plain ASCII, for the second block: qlog's records hold
/// two strings of 16 to 31 octets each, and left to the out-of-line copy they and CLDR's took 3
/// to 8 instructions a token more (design §8 step 18).
inline fn second_block(loop: *Loop, comptime kind: Kind, content: []const u8) ?usize {
    const blocks_len = constants.loop_string_blocks * constants.vector_len;
    if (content.len < blocks_len or loop.out.len < blocks_len) return leave_long(loop, kind, constants.vector_len);
    const block: @Vector(constants.vector_len, u8) = content[constants.vector_len..blocks_len].*;
    loop.out[constants.vector_len..blocks_len].* = block;
    const lane = scan.plain_stop(block) orelse return leave_long(loop, kind, blocks_len);
    const len = constants.vector_len + lane;
    if (!scan.is_quotation_mark(block, lane)) return leave_long(loop, kind, len);
    loop.in = content[len + 1 ..];
    loop.out = loop.out[len..];
    return len;
}

/// Leaves the name or string of `kind` at the start of `in` to `copy_blocks`, from the
/// `head_len` octets of its content its first blocks copied and found plain: a long string's
/// first block, copied again, took a 1 KiB hex string 2% more time on the N2 (design §8 step
/// 18).
inline fn leave_long(loop: *Loop, comptime kind: Kind, head_len: usize) ?usize {
    loop.long_string = .{ .kind = kind, .head_len = head_len };
    return null;
}

/// `copy_blocks` an octet at a time, for plain ASCII alone (claim J3 off).
inline fn copy_scalar(loop: *Loop, content: []const u8) ?Copied {
    const len = scan.plain_len_scalar(content[0..@min(content.len, loop.out.len)]);
    if (len == content.len or content[len] != constants.quotation_mark) return null;
    @memcpy(loop.out[0..len], content[0..len]);
    return .{ .input_len = len, .output_len = len };
}

/// A name or string `fill` stopped at: its kind, and the octets of its content its first blocks
/// copied and found plain.
pub const LongString = struct { kind: Kind, head_len: usize };

/// Copies a string's `content`, the input after its opening quotation mark, up to its closing
/// one, into `room`, and returns what it took and wrote, or null where the checked path must take
/// it. Its first `constants.wide_run_len_min` octets of plain ASCII go a block of 16 at a time, a
/// run past them to `copy_long`, and one that fewer than 16 octets of input or room leave to
/// `copy_short`. Past its plain ASCII, its escapes and UTF-8 go to decoder_loop_string.zig. It
/// takes no `*Loop`, for the strings `Loop.string` leaves.
pub fn copy_blocks(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, head_len: usize) ?Copied {
    var len: usize = head_len;
    for (0..constants.wide_run_len_min / constants.vector_len) |_| {
        // Each block's slices first: their lengths' test then proves the load and the store in
        // bounds, which a test of the lengths left over did not, and each paid a check again.
        const input_rest = content[len..];
        const output_rest = room[len..];
        if (input_rest.len < constants.vector_len or output_rest.len < constants.vector_len) return copy_short(claims, level, content, room, len);
        const block: @Vector(constants.vector_len, u8) = input_rest[0..constants.vector_len].*;
        output_rest[0..constants.vector_len].* = block;
        if (scan.plain_stop(block)) |lane| {
            if (scan.is_quotation_mark(block, lane)) return .{ .input_len = len + lane, .output_len = len + lane };
            return copy_rest(claims, level, content, room, len + lane);
        }
        len += constants.vector_len;
    }
    const run_len = copy_long(level.with(claims), content[len..], room[len..]);
    return after_run(claims, level, content, room, len + run_len);
}

/// The rest of a run past its first `head_len` octets, when fewer than 16 of input or of room
/// are left: scanned up to the end of either as `scan.plain_len_vector` scans a short run, and
/// copied. Claim J8's fast path took such a string, near the end of the input or of the output,
/// where the loop left it.
inline fn copy_short(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, head_len: usize) ?Copied {
    const rest = content[head_len..];
    const rest_room = room[head_len..];
    const window = rest[0..@min(rest.len, rest_room.len)];
    const run_len = scan.plain_len_vector(constants.vector_len, window);
    scan.copy(rest_room[0..run_len], window[0..run_len]);
    return after_run(claims, level, content, room, head_len + run_len);
}

/// The string whose first `len` octets of content are copied and plain ASCII: whole at its
/// closing quotation mark, and else taken on past them by `copy_rest`.
inline fn after_run(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, len: usize) ?Copied {
    if (len == content.len) return null;
    if (content[len] == constants.quotation_mark) return .{ .input_len = len, .output_len = len };
    return copy_rest(claims, level, content, room, len);
}

/// The string past its first `head_len` octets of content, copied and plain ASCII: its escapes,
/// its UTF-8 and the runs between them (decoder_loop_string.zig).
inline fn copy_rest(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, head_len: usize) ?Copied {
    const rest = loop_string.copy_rest_at(claims, level, content[head_len..], room[head_len..]) orelse return null;
    return .{ .input_len = head_len + rest.input_len, .output_len = head_len + rest.output_len };
}

/// The run of plain ASCII past the blocks `copy_blocks` took, from `rest`, its octets after them,
/// into `room`, the output after them, as far as `room` holds: copied, and its length returned. It
/// is scanned at the widest vector the caller's features allow (claim J7), in a function of its own
/// as `wide.plain_len` scans it, and copied whole: 16 at a time, the loop ran long hex strings up to
/// 10% slower than the checked path on an AMD EPYC 7763 (design §8 step 18). It takes no `*Loop`,
/// which would keep the loop's fields in memory.
fn copy_long(level: wide.Level, rest: []const u8, room: []u8) align(constants.kernel_alignment) usize {
    const window = rest[0..@min(rest.len, room.len)];
    const run_len = wide.plain_len(level, window);
    @memcpy(room[0..run_len], window[0..run_len]);
    return run_len;
}
