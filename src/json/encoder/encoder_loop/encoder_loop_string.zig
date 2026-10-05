//! Claim J11's names and strings that are not all plain ASCII (decision 16's JSON encoder token
//! loop): it copies the runs a string carries as they are, plain ASCII and whole UTF-8 characters
//! (RFC 8259 §7, RFC 3629 §4), and writes each octet a string must escape as encoder_content.zig
//! does. Left to the checked path an octet at a time, strings with escapes encoded 2 to 4 times
//! slower than simdjson's on the N2 (design §8 step 18).
//!
//! Anything else leaves the string, whole, to the checked path, which names every refusal: a
//! character UTF-8 rules out or that the string cuts, and a room too short for the string. It reads
//! and writes the slices it is given, whose bounds Zig checks (ReleaseSafe) unless the caller turns
//! the checks off at its call site (decision 35). The walk it takes keeps its checks.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const scan = @import("../../scan.zig");
const wide = @import("../../wide.zig");
const claims_file = @import("../../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const string_walk = @import("../../string_walk.zig");
const Walk = string_walk.Walk;

/// The octets of the two-character escape of a quotation mark, a reverse solidus or a control
/// character that has one, and of `\u00` and two digits for a control character that has none.
const letter_escape_len = 2;
const control_escape_len = constants.control_escape_prefix.len + constants.hex_digits_per_octet;

/// The escape letter of each control character that has one, or null. A quotation mark's and a
/// reverse solidus's letters are themselves.
const escape_letters = table: {
    var letters: [constants.unescaped_min]?u8 = @splat(null);
    for (constants.escape_letters, constants.escaped_characters) |letter, character| {
        if (character < constants.unescaped_min) letters[character] = letter;
    }
    break :table letters;
};

/// What the variant object's `copy_escaped` returns for a string left to the checked path: more
/// than any room holds.
pub const left = std.math.maxInt(usize);

/// `copy_escaped` compiled into the AVX2 variant object (variants/loop_string.zig), where the UTF-8
/// check takes decision 37's lookup, VPSHUFB, which the baseline target lacks: with every claim on,
/// and with claim J11's runtime safety off at the caller's choice (decision 35).
extern fn stdx_json_copy_escaped_x86_64_avx2(octets: [*]const u8, len: usize, room: [*]u8, room_len: usize) callconv(.c) usize;
extern fn stdx_json_copy_escaped_unchecked_x86_64_avx2(octets: [*]const u8, len: usize, room: [*]u8, room_len: usize) callconv(.c) usize;

/// `copy_escaped`, in the variant object of `level` on x86-64 with every claim on, and here for
/// every other target, level and set of claims. On x86-64 the choice is made out of line, so that
/// the kernel's call site stays out of the token loop (decoder_loop_string.zig's `copy_rest_at`).
pub inline fn copy_escaped_at(comptime claims: Claims, level: wide.Level, octets: []const u8, room: []u8) ?usize {
    if (comptime wide.has_kernels and std.meta.eql(claims, Claims{})) return copy_escaped_kernel_or_here(true, level, octets, room);
    if (comptime wide.has_kernels and std.meta.eql(claims, Claims{ .encoder_token_loop_runtime_safety = false })) return copy_escaped_kernel_or_here(false, level, octets, room);
    return copy_escaped(claims, level, octets, room);
}

noinline fn copy_escaped_kernel_or_here(comptime checked: bool, level: wide.Level, octets: []const u8, room: []u8) ?usize {
    const claims: Claims = .{ .encoder_token_loop_runtime_safety = checked };
    if (level != .avx2) return copy_escaped(claims, level, octets, room);
    const written = if (checked) stdx_json_copy_escaped_x86_64_avx2(octets.ptr, octets.len, room.ptr, room.len) else stdx_json_copy_escaped_unchecked_x86_64_avx2(octets.ptr, octets.len, room.ptr, room.len);
    return if (written == left) null else written;
}

/// The encoder's walk takes a run's ASCII blocks in a loop of their own everywhere but on x86-64,
/// where the two loops spilled the walk's state and one loop encoded bible.txt at 1.56 times the
/// speed (string_walk.zig, design §8 step 18).
const two_loops = builtin.cpu.arch != .x86_64;

/// Writes the content of a string whose octets are `octets` into `room`, escaped as RFC 8259 §7
/// requires, and returns how many octets it wrote; or null where the checked path must take it.
pub fn copy_escaped(comptime claims: Claims, level: wide.Level, octets: []const u8, room: []u8) align(constants.kernel_alignment) ?usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    var walk: Walk = .{ .input = octets, .output = room };
    // Each pass takes at least one octet, or returns.
    for (0..octets.len + 1) |_| {
        // An octet to escape that follows an escaped one is taken at once, with no block walked to
        // find it: a text of lines that end in a carriage return and a line feed has two at each
        // line's end.
        if (walk.input.len == 0 or !escapes(walk.input[0])) {
            if (!walk.take_to_stop(claims, two_loops, level, octets, room)) return null;
            if (walk.input.len == 0) return room.len - walk.output.len;
        }
        const octet = walk.input[0];
        // A character UTF-8 rules out or the string cuts, or an octet the room stopped.
        if (!escapes(octet)) return null;
        walk.take(1, escape(claims, octet, walk.output) orelse return null);
    }
    unreachable;
}

/// Whether a string must escape `octet`: a quotation mark, a reverse solidus or a control character
/// (RFC 8259 §7).
inline fn escapes(octet: u8) bool {
    return octet < constants.non_ascii_min and !scan.is_plain_ascii(octet);
}

/// Writes the escape of `octet`, a quotation mark, a reverse solidus or a control character (RFC
/// 8259 §7), at the start of `room`: its two-character form where it has one, and else `\u00` and
/// two lowercase digits. Returns its length, or null when `room` is too short for it.
fn escape(comptime claims: Claims, octet: u8, room: []u8) ?usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    assert(octet < constants.unescaped_min or octet == constants.quotation_mark or octet == constants.reverse_solidus);
    const letter = if (octet < constants.unescaped_min) escape_letters[octet] else octet;
    if (letter) |named| {
        if (room.len < letter_escape_len) return null;
        room[0..letter_escape_len].* = .{ constants.reverse_solidus, named };
        return letter_escape_len;
    }
    if (room.len < control_escape_len) return null;
    room[0..constants.control_escape_prefix.len].* = constants.control_escape_prefix.*;
    room[constants.control_escape_prefix.len..][0..constants.hex_digits_per_octet].* = .{
        constants.hex_digits_lower[octet >> constants.nibble_bits],
        constants.hex_digits_lower[octet & constants.nibble_mask],
    };
    return control_escape_len;
}
