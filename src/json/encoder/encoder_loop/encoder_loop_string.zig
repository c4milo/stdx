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
const wide = @import("../../wide.zig");
const claims_file = @import("../../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const string_walk = @import("../../string_walk.zig");
const wide_walk = @import("../../string_walk_wide.zig");
const Walk = string_walk.Walk;
const escape_blocks = @import("encoder_loop_escapes.zig");

/// The octets of the two-character escape of a quotation mark, a reverse solidus or a control
/// character that has one, and of `\u00` and two digits for a control character that has none.
const letter_escape_len = 2;
const control_escape_len = constants.control_escape_prefix.len + constants.hex_digits_per_octet;

/// What `escape_letters` holds for a control character with no letter of its own, which a string
/// writes as `\u00` and two digits. It is the value next to zero, which no letter has, so that
/// one compare tells both from a letter.
pub const control_mark = 1;

/// For each octet a string must escape (RFC 8259 §7), the letter of its two-character escape: a
/// quotation mark's and a reverse solidus's are themselves. For a control character with none,
/// `control_mark`. For every other octet zero, so that one load says whether an octet is escaped
/// and how: a test of each class, then a table of optionals for the control characters' letters,
/// took five to eight instructions an escape more (design §8 step 18).
pub const escape_letters = table: {
    var letters: [std.math.maxInt(u8) + 1]u8 = @splat(0);
    for (0..constants.unescaped_min) |control| letters[control] = control_mark;
    for (constants.escape_letters, constants.escaped_characters) |letter, character| {
        if (character < constants.unescaped_min) letters[character] = letter;
    }
    letters[constants.quotation_mark] = constants.quotation_mark;
    letters[constants.reverse_solidus] = constants.reverse_solidus;
    break :table letters;
};

comptime {
    // Every letter is above the mark, so the mark alone names an escape of `\u00` and two digits.
    for (constants.escape_letters) |letter| assert(letter > control_mark);
}

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
    return copy_escaped(claims, constants.vector_len, level, octets, room);
}

noinline fn copy_escaped_kernel_or_here(comptime checked: bool, level: wide.Level, octets: []const u8, room: []u8) ?usize {
    const claims: Claims = .{ .encoder_token_loop_runtime_safety = checked };
    if (level != .avx2) return copy_escaped(claims, constants.vector_len, level, octets, room);
    const written = if (checked) stdx_json_copy_escaped_x86_64_avx2(octets.ptr, octets.len, room.ptr, room.len) else stdx_json_copy_escaped_unchecked_x86_64_avx2(octets.ptr, octets.len, room.ptr, room.len);
    return if (written == left) null else written;
}

/// The encoder's walk takes a run's ASCII blocks in a loop of their own everywhere but on x86-64,
/// where the two loops spilled the walk's state and one loop encoded bible.txt at 1.56 times the
/// speed (string_walk.zig, design §8 step 18).
const two_loops = builtin.cpu.arch != .x86_64;

/// Whether a walk whose blocks past a run's ASCII are `block_len` octets takes the run's ASCII in
/// a loop of its own: where `two_loops` says, and where those blocks are the wide ones, which run
/// out of line from a run's first octet from 0x80 up and leave the walk one loop to hold
/// (string_walk_wide.zig).
fn ascii_loop(comptime block_len: usize) bool {
    return two_loops or block_len == wide_walk.block_len;
}

/// Writes the content of a string whose octets are `octets` into `room`, escaped as RFC 8259 §7
/// requires, and returns how many octets it wrote; or null where the checked path must take it.
/// `block_len` is the walk's block past a run's ASCII (string_walk.zig's `take_to_stop`).
pub fn copy_escaped(comptime claims: Claims, comptime block_len: usize, level: wide.Level, octets: []const u8, room: []u8) align(constants.kernel_alignment) ?usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    var walk: Walk = .{ .input = octets, .output = room };
    var hand: Hand = .{};
    // Each pass takes at least one octet, or returns.
    for (0..octets.len + 1) |_| {
        // An octet to escape that follows an escaped one is taken at once, with no block walked to
        // find it: a text of lines that end in a carriage return and a line feed has two at each
        // line's end.
        if (walk.input.len == 0 or escape_letters[walk.input[0]] == 0) {
            if (!walk.take_to_stop(claims, comptime ascii_loop(block_len), block_len, level, octets, room)) return null;
            if (walk.input.len == 0) return room.len - walk.output.len;
            hand.ascii = walk.ascii_so_far;
        }
        if (!take_escaped_and_blocks(claims, &walk, &hand)) return null;
    }
    unreachable;
}

/// The walk's hand-off to claim J14's blocks (encoder_loop_escapes.zig): what it keeps between
/// escapes, and when it hands the string over.
pub const Hand = struct {
    /// Whether the last run the walk took was all ASCII, which is all the blocks take: a run
    /// that held a longer character says the octets after it likely hold one too. An escape
    /// that follows another ends no run, and leaves it as it was.
    ascii: bool = true,
    /// The blocks try again once this many octets of input are left, or fewer.
    from_len: usize = std.math.maxInt(usize),

    /// Hands the string to the blocks from where `walk` stands, where the last run was ASCII, the
    /// blocks are not waiting, and the input and the output hold what a block's loads and stores
    /// reach into; then moves the walk past what they took.
    ///
    /// Blocks that took nothing met an octet they leave to the walk in their first block: a
    /// control character with no letter or a non-ASCII octet, which come in runs. They then
    /// wait until the walk has taken `constants.escape_look_len_min` octets more: tried after
    /// each escape, a run of U+0000 encoded at 0.45 of the walk's speed on the N2 and on an EPYC
    /// 7763 (design §8 step 18).
    pub inline fn take(self: *Hand, comptime claims: Claims, walk: *Walk) void {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (!self.ascii or walk.input.len > self.from_len) return;
        if (walk.input.len < escape_blocks.input_len or walk.output.len < escape_blocks.room_len) return;
        const took = escape_blocks.take(claims, walk.input, walk.output);
        if (took.input_len == 0) self.from_len = walk.input.len -| constants.escape_look_len_min;
        walk.take(took.input_len, took.output_len);
    }
};

/// `take_escaped`, and then the blocks of claim J14 where the hand-off gives them the string.
inline fn take_escaped_and_blocks(comptime claims: Claims, walk: *Walk, hand: *Hand) bool {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    if (!take_escaped(claims, walk)) return false;
    if (comptime has_blocks(claims)) hand.take(claims, walk);
    return true;
}

/// Whether claim J14's blocks take a string on past an escape: where the claim is on and this
/// compilation has their lookup.
pub fn has_blocks(comptime claims: Claims) bool {
    return claims.encoder_escape_blocks and escape_blocks.available;
}

/// Writes the escape of the octet the walk stands at and moves the walk past both, and returns
/// true. Returns false, with nothing written, where the checked path must take the string: at a
/// character UTF-8 rules out or the string cuts, at an octet the room stopped, and where the
/// room is too short for the escape.
inline fn take_escaped(comptime claims: Claims, walk: *Walk) bool {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    const letter = escape_letters[walk.input[0]];
    if (letter <= control_mark) {
        if (letter == 0) return false;
        walk.take(1, escape_control(claims, walk.input[0], walk.output) orelse return false);
        return true;
    }
    // A letter's escape is two octets, tested before the walk moves, so the move checks nothing.
    if (walk.output.len < letter_escape_len) return false;
    walk.output[0..letter_escape_len].* = .{ constants.reverse_solidus, letter };
    walk.take(1, letter_escape_len);
    return true;
}

/// Writes the escape of `octet`, a control character with no letter of its own (RFC 8259 §7), at
/// the start of `room`: `\u00` and two lowercase digits. Returns its length, or null when `room`
/// is too short for it.
fn escape_control(comptime claims: Claims, octet: u8, room: []u8) ?usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    assert(octet < constants.unescaped_min);
    assert(escape_letters[octet] == control_mark);
    if (room.len < control_escape_len) return null;
    room[0..constants.control_escape_prefix.len].* = constants.control_escape_prefix.*;
    room[constants.control_escape_prefix.len..][0..constants.hex_digits_per_octet].* = .{
        constants.hex_digits_lower[octet >> constants.nibble_bits],
        constants.hex_digits_lower[octet & constants.nibble_mask],
    };
    return control_escape_len;
}
