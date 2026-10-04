//! The loops the encoder and the decoder spend their time in, each as a scalar path and a vector
//! path that must return the same (decision 21; claims J1, J2, J3 and J5, decision 27): the run of
//! a string's octets that need no escape, the same run with UTF-8 validated in it, and hexadecimal
//! digits. The run of whitespace has a scalar path alone, since claim J4's vector path left.
//!
//! Each takes a slice and returns a count, and reads nothing past the slice: a vector path loads
//! whole blocks of `width` octets while one fits, and hands the rest to the scalar path. The
//! caller takes the counted octets through `codec.Reader` and writes them through `codec.Writer`,
//! which check every bound (decision 16).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const utf8 = @import("utf8.zig");
const scan_utf8 = @import("scan_utf8.zig");

/// True for an octet a string carries as it is that is ASCII: U+0020 to U+007F, but for quotation
/// mark and reverse solidus, which a string must escape (RFC 8259 §7).
pub fn is_plain_ascii(octet: u8) bool {
    return octet >= constants.unescaped_min and octet < constants.non_ascii_min and
        octet != constants.quotation_mark and octet != constants.reverse_solidus;
}

/// True for insignificant whitespace (RFC 8259 §2).
pub fn is_whitespace(octet: u8) bool {
    // No whitespace octet is above a space, so one compare answers the octets that start tokens.
    if (octet > constants.space) return false;
    return octet == constants.space or octet == constants.horizontal_tab or
        octet == constants.line_feed or octet == constants.carriage_return;
}

/// The run of plain ASCII octets that starts `octets`, an octet at a time (claims J1 and J3 off).
pub fn plain_len_scalar(octets: []const u8) usize {
    for (octets, 0..) |octet, index| {
        if (!is_plain_ascii(octet)) return index;
    }
    return octets.len;
}

/// The run of octets a string carries as they are that starts `octets`: plain ASCII and whole UTF-8
/// characters (RFC 8259 §7, RFC 3629 §4), an octet at a time (claim J5 off). It stops before an
/// octet a string must escape, and before a character that is not UTF-8 or that `octets` cuts.
pub fn content_len_scalar(octets: []const u8) usize {
    var index: usize = 0;
    for (0..octets.len) |_| {
        if (index == octets.len) break;
        if (is_plain_ascii(octets[index])) {
            index += 1;
            continue;
        }
        if (octets[index] < constants.non_ascii_min) break;
        index += utf8.character_len(octets[index..]) orelse break;
    }
    return index;
}

/// The run of whitespace that starts `octets`, an octet at a time. Claim J4's vector path left
/// (decision 27).
pub fn whitespace_len_scalar(octets: []const u8) usize {
    for (octets, 0..) |octet, index| {
        if (!is_whitespace(octet)) return index;
    }
    return octets.len;
}

/// Copies `source` into `destination`, of the same length: up to 16 octets in two moves of 8 or 4
/// that overlap and stay inside both, and past that with `@memcpy`, which for a length known only
/// at run time is a call. The token loops copy a name, a string or a number with it.
pub inline fn copy(destination: []u8, source: []const u8) void {
    const len = source.len;
    assert(destination.len == len);
    if (len > constants.vector_len) return @memcpy(destination, source);
    inline for (.{ constants.word_len, @sizeOf(u32) }) |move_len| {
        if (len >= move_len) {
            destination[0..move_len].* = source[0..move_len].*;
            destination[len - move_len ..][0..move_len].* = source[len - move_len ..][0..move_len].*;
            return;
        }
    }
    // One to three octets: the first, the last and the middle one cover them all.
    if (len == 0) return;
    destination[0] = source[0];
    destination[len - 1] = source[len - 1];
    destination[len >> 1] = source[len >> 1];
}

/// Writes two lowercase hexadecimal digits for each octet of `input` that `output` has room for,
/// the more significant first, and returns how many octets of `input` it took (claim J2 off).
pub fn hex_len_scalar(input: []const u8, output: []u8) usize {
    const len = @min(input.len, output.len / constants.hex_digits_per_octet);
    for (input[0..len], 0..) |octet, index| {
        const digits = output[constants.hex_digits_per_octet * index ..][0..constants.hex_digits_per_octet];
        digits[0] = constants.hex_digits_lower[octet >> constants.nibble_bits];
        digits[1] = constants.hex_digits_lower[octet & constants.nibble_mask];
    }
    return len;
}

fn Block(comptime width: usize) type {
    return @Vector(width, u8);
}

fn Lanes(comptime width: usize) type {
    return @Vector(width, bool);
}

fn splat(comptime width: usize, octet: u8) Block(width) {
    return @splat(octet);
}

fn load(comptime width: usize, octets: []const u8) Block(width) {
    return octets[0..width].*;
}

// Every function that takes or returns a vector of bool is inline: LLVM's Debug build cannot pass
// one across a call on AVX-512, whose mask registers hold it ("Cannot emit physreg copy
// instruction", CI run 36377079320 on x86-64).

/// Whether NEON's word of 4 bits a lane stands in for a bit a lane: on aarch64, at 16 octets.
fn has_nibbles(comptime width: usize) bool {
    return builtin.cpu.arch == .aarch64 and width == constants.vector_len;
}

/// NEON gathers no bit per lane into a register. Shifted right by 4 and narrowed as 16-bit lanes,
/// octets of all ones or all zeros leave 4 bits each in one word, the lowest lane lowest: a SHRN,
/// where x86-64 takes PMOVMSKB (docs/costs.md, the 32-octet vector compare).
inline fn nibbles_of(comptime width: usize, lanes: Lanes(width)) std.meta.Int(.unsigned, width * constants.nibble_bits) {
    const octets = @select(u8, lanes, splat(width, std.math.maxInt(u8)), splat(width, 0));
    const halves: @Vector(width / @sizeOf(u16), u16) = @bitCast(octets);
    const narrowed: @Vector(width / @sizeOf(u16), u8) = @truncate(halves >> @splat(constants.nibble_bits));
    return @bitCast(narrowed);
}

/// Whether any lane holds. At 16 octets on aarch64, the word `first_lane` counts in: a UMAXV
/// across the lanes waited longer, and each block of a string's stop paid it (design §8 step 18).
inline fn any(comptime width: usize, lanes: Lanes(width)) bool {
    if (comptime has_nibbles(width)) return nibbles_of(width, lanes) != 0;
    return @reduce(.Or, lanes);
}

/// The first lane that holds, of lanes of which at least one does.
inline fn first_lane(comptime width: usize, lanes: Lanes(width)) usize {
    assert(any(width, lanes));
    if (builtin.cpu.arch == .aarch64) return @ctz(nibbles_of(width, lanes)) / constants.nibble_bits;
    if (builtin.cpu.arch.endian() == .little) {
        const bits: std.meta.Int(.unsigned, width) = @bitCast(lanes);
        return @ctz(bits);
    }
    // Zig's own x86-64 backend indexes a vector at comptime-known lanes alone.
    inline for (0..width) |lane| {
        if (lanes[lane]) return lane;
    }
    unreachable;
}

/// The lanes whose octet a string must escape or is not ASCII: below U+0020 or from 0x80 up, which
/// shifted down by 0x20 wraps past 0xDF or lands at 0x60 and up, and the quotation mark and the
/// reverse solidus (RFC 8259 §7).
inline fn plain_stops(comptime width: usize, block: Block(width)) Lanes(width) {
    const shifted = block -% splat(width, constants.unescaped_min);
    const outside = shifted >= splat(width, constants.non_ascii_min - constants.unescaped_min);
    return outside | escape_lanes(width, block);
}

/// The lanes whose octet a string must escape (RFC 8259 §7).
inline fn escape_lanes(comptime width: usize, block: Block(width)) Lanes(width) {
    const control = block < splat(width, constants.unescaped_min);
    const quotation_mark = block == splat(width, constants.quotation_mark);
    const reverse_solidus = block == splat(width, constants.reverse_solidus);
    return control | quotation_mark | reverse_solidus;
}

/// The first lane of `block` that a string must escape or that is not ASCII, or null when all 16
/// are plain ASCII: the stop claim J10's loop finds in each block of a string.
pub inline fn plain_stop(block: Block(constants.vector_len)) ?usize {
    const stops = plain_stops(constants.vector_len, block);
    return if (any(constants.vector_len, stops)) first_lane(constants.vector_len, stops) else null;
}

/// True when `lane` of `block` holds the quotation mark, read from the block's own compare, which
/// `plain_stop` makes too: loaded again from the input, the octet at a string's stop cost J10's
/// loop a load and a bounds check that waited on the lane (design §8 step 18).
pub inline fn is_quotation_mark(block: Block(constants.vector_len), lane: usize) bool {
    assert(lane < constants.vector_len);
    const quotation_marks = block == splat(constants.vector_len, constants.quotation_mark);
    if (builtin.cpu.arch == .aarch64) {
        const nibbles = nibbles_of(constants.vector_len, quotation_marks);
        return nibbles >> @intCast(lane * constants.nibble_bits) & 1 != 0;
    }
    if (builtin.cpu.arch.endian() == .little) {
        const bits: std.meta.Int(.unsigned, constants.vector_len) = @bitCast(quotation_marks);
        return bits >> @intCast(lane) & 1 != 0;
    }
    // As in `first_lane`: Zig's own x86-64 backend indexes a vector at comptime-known lanes alone.
    inline for (0..constants.vector_len) |index| {
        if (index == lane) return quotation_marks[index];
    }
    unreachable;
}

/// Where a string's run stops in `block`, the block after `previous` (claims J3 and J5): the first
/// lane that holds an octet a string must escape or one UTF-8 rules out there (RFC 8259 §7, RFC 3629
/// §4), plus `ruled_out` when UTF-8 rules it out; null when every lane is a string's octet. A block
/// of ASCII after one skips the UTF-8 check, which it cannot fail. For the loops that copy a block
/// as they check it: checked a run at a time, a text whose lines end in escapes restarted its run
/// at each, and the check took under half of its time (design §8 step 18).
pub inline fn string_stop(previous: Block(constants.vector_len), block: Block(constants.vector_len), octets: *const [constants.vector_len]u8, ascii_so_far: *bool) ?usize {
    const width = constants.vector_len;
    // While the run has been ASCII, one word answers both questions, whether the block is ASCII
    // and where it stops, in one transfer from a vector to a word; a block of ASCII with no stop
    // returns here, so the UTF-8 check does not run for it. Once a block is not ASCII, the question
    // stops, and each block after it pays the stop test alone: the check with the lookup costs
    // less than the question, a transfer of its own (design §8 step 18). On aarch64 the walk takes
    // its ASCII blocks in a loop of their own (string_walk.zig), and reaches this test with the
    // question answered; on x86-64 that second loop spilled the state of both to the stack, so
    // there this one loop holds them, and the question is asked here.
    if (ascii_so_far.*) {
        const stops = ascii_stops(block);
        if (stops == 0) return null;
        const lane = word_first(stops);
        if (octets[lane] < constants.non_ascii_min) return lane;
        ascii_so_far.* = false;
    }
    const escapes = escape_lanes(width, block);
    const errors = scan_utf8.error_lanes(width, previous, block);
    const stops = escapes | errors;
    if (!any(width, stops)) return null;
    const lane = first_lane(width, stops);
    return lane + if (lane_holds(width, errors, lane)) ruled_out else 0;
}

/// Added to the lane `string_stop` returns when UTF-8 rules its octet out.
pub const ruled_out = constants.vector_len;

/// The lanes of a block as a word a scalar scan consumes: on aarch64 the word `nibbles_of` gives,
/// four bits a lane, and elsewhere one bit a lane. `word_first` reads it either way.
pub const LaneWord = if (has_nibbles(constants.vector_len)) std.meta.Int(.unsigned, constants.vector_len * constants.nibble_bits) else std.meta.Int(.unsigned, constants.vector_len);
const word_bits_per_lane = if (has_nibbles(constants.vector_len)) constants.nibble_bits else 1;

inline fn lane_word(lanes: Lanes(constants.vector_len)) LaneWord {
    if (comptime has_nibbles(constants.vector_len)) return nibbles_of(constants.vector_len, lanes);
    if (comptime builtin.cpu.arch.endian() == .little) return @bitCast(lanes);
    var word: LaneWord = 0;
    inline for (0..constants.vector_len) |lane| word |= @as(LaneWord, @intFromBool(lanes[lane])) << lane;
    return word;
}

/// The word of the lanes of `masks`, each all ones or zero: the lanes that are all ones.
pub inline fn masks_word(masks: Block(constants.vector_len)) LaneWord {
    if (comptime has_nibbles(constants.vector_len)) {
        const halves: @Vector(constants.vector_len / @sizeOf(u16), u16) = @bitCast(masks);
        const narrowed: @Vector(constants.vector_len / @sizeOf(u16), u8) = @truncate(halves >> @splat(constants.nibble_bits));
        return @bitCast(narrowed);
    }
    return lane_word(masks >= splat(constants.vector_len, constants.non_ascii_min));
}

/// The first lane a word holds, of a word that holds one.
pub inline fn word_first(word: LaneWord) usize {
    assert(word != 0);
    return @ctz(word) / word_bits_per_lane;
}

/// The lanes of `block` that end a run of plain ASCII: an octet a string must escape (RFC 8259
/// §7) or one from 0x80 up, which UTF-8 judges (RFC 3629 §4). One transfer from a vector to a
/// word for both questions (string_walk.zig).
///
/// Read as signed octets, a control character and an octet from 0x80 up are both below 0x20, so
/// one compare finds them: a compare for each range and an OR took three of the block's eight
/// vector instructions, and the N2 has two pipes for them (design §8 step 18). `plain_stops`
/// keeps its form: with this one, the token loop that inlines it took 1.6 instructions a token
/// more on CLDR's texts.
pub inline fn ascii_stops(block: Block(constants.vector_len)) LaneWord {
    const signed: @Vector(constants.vector_len, i8) = @bitCast(block);
    const outside = signed < @as(@Vector(constants.vector_len, i8), @splat(constants.unescaped_min));
    const quotation_mark = block == splat(constants.vector_len, constants.quotation_mark);
    const reverse_solidus = block == splat(constants.vector_len, constants.reverse_solidus);
    return lane_word(outside | quotation_mark | reverse_solidus);
}

/// True when the block `string_stop` checked holds no octet from 0x80 up.
pub inline fn is_ascii(block: Block(constants.vector_len)) bool {
    return !any(constants.vector_len, block >= splat(constants.vector_len, constants.non_ascii_min));
}

/// True when `lane` of `lanes` holds.
inline fn lane_holds(comptime width: usize, lanes: Lanes(width), lane: usize) bool {
    assert(lane < width);
    if (comptime has_nibbles(width)) return nibbles_of(width, lanes) >> @intCast(lane * constants.nibble_bits) & 1 != 0;
    if (builtin.cpu.arch.endian() == .little) {
        const bits: std.meta.Int(.unsigned, width) = @bitCast(lanes);
        return bits >> @intCast(lane) & 1 != 0;
    }
    // As in `first_lane`: Zig's own x86-64 backend indexes a vector at comptime-known lanes alone.
    inline for (0..width) |index| {
        if (index == lane) return lanes[index];
    }
    unreachable;
}

/// `plain_len_scalar`, `width` octets at a time (claims J1 and J3). A run the whole blocks do not
/// end ends in the last `width` octets, a block that overlaps the one before it: that one holds no
/// stop, so the block's first is the run's. A run shorter than a block takes `plain_len_short`.
pub fn plain_len_vector(comptime width: usize, octets: []const u8) align(constants.kernel_alignment) usize {
    if (octets.len < width) return plain_len_short(width, octets);
    var index: usize = 0;
    for (0..octets.len / width) |_| {
        const stops = plain_stops(width, load(width, octets[index..]));
        if (any(width, stops)) return index + first_lane(width, stops);
        index += width;
    }
    if (index == octets.len) return index;
    const last = octets.len - width;
    const stops = plain_stops(width, load(width, octets[last..]));
    return if (any(width, stops)) last + first_lane(width, stops) else octets.len;
}

/// `plain_len_vector` for a run shorter than a block. From 4 octets on, one 16-octet block holds
/// its first and its last `half` octets, where `half` is 8 for 8 to 15 octets and else 4, and
/// plain octets after them; the two halves overlap and cover the run, so the block's first stop
/// is the run's. Below 4 octets, an octet at a time.
inline fn plain_len_short(comptime width: usize, octets: []const u8) usize {
    if (width > constants.vector_len and octets.len >= constants.vector_len) return plain_len_vector(constants.vector_len, octets);
    if (octets.len >= constants.word_len) return halves_stop(constants.word_len, octets);
    if (octets.len >= half_word_len) return halves_stop(half_word_len, octets);
    return plain_len_scalar(octets);
}

/// The octets of the halves `plain_len_short` joins below 8 octets, and how many halves it joins.
const half_word_len = @sizeOf(u32);
const halves_joined = 2;

/// The first stop of `octets`, of `half` to `2 * half - 1` octets, from a block of its first and
/// its last `half` octets: at a lane of the first half, the lane; at a lane of the second, the
/// octet as far from the run's end as the lane is from the halves' end.
inline fn halves_stop(comptime half: usize, octets: []const u8) usize {
    const halves_len = halves_joined * half;
    const len = octets.len;
    assert(len >= half and len < halves_len);
    const halves = octets[0..half].* ++ octets[len - half ..][0..half].*;
    const plain: [constants.vector_len - halves_len]u8 = @splat(constants.space);
    const stops = plain_stops(constants.vector_len, halves ++ plain);
    if (!any(constants.vector_len, stops)) return len;
    const lane = first_lane(constants.vector_len, stops);
    return if (lane < half) lane else len + lane - halves_len;
}

/// `scan_utf8.cut_character_len`, for the callers that reach it through this file.
pub const cut_character_len = scan_utf8.cut_character_len;

/// `content_len_scalar`, `width` octets at a time (claim J5). Plain ASCII takes
/// `plain_len_vector`'s loop, so text of ASCII costs what it costs without the claim. At a
/// non-ASCII octet, `utf8_run` checks whole blocks as UTF-8 and hands back to that loop after a
/// block of ASCII. A block that holds an octet to escape, or one UTF-8 rules out, ends the vector
/// path: the scalar path goes on from the start of the last character before it.
pub fn content_len_vector(comptime width: usize, octets: []const u8) usize {
    var index: usize = 0;
    // Each pass takes octets or returns: a UTF-8 run that hands back takes at least a block.
    for (0..octets.len + 1) |_| {
        index += plain_len_vector(width, octets[index..]);
        if (index == octets.len or octets[index] < constants.non_ascii_min) return index;
        const run = utf8_run(width, octets[index..]);
        index += run.len;
        if (!run.ascii_next) return index + content_len_scalar(octets[index..]);
    }
    unreachable;
}

/// What `utf8_run` took: whole characters, and whether a block of ASCII ended them.
const Run = struct { len: usize, ascii_next: bool };

/// The blocks of `octets`, which starts a non-ASCII character, that are whole UTF-8 characters
/// with no octet to escape (RFC 8259 §7, RFC 3629 §4), up to one of ASCII alone, which ends the run
/// on a character's end. A block that fails ends the run at its first lane that fails, less a
/// character that lane cuts: ended at the block's start, each line of a text ended by an escape
/// left up to 15 octets to the scalar path (design §8 step 18). Each block goes through
/// `scan_utf8.loaded`: LLVM split its load for the check's shuffles, as it did in `valid`.
fn utf8_run(comptime width: usize, octets: []const u8) Run {
    var previous = splat(width, 0);
    var index: usize = 0;
    for (0..octets.len / width) |_| {
        const block = scan_utf8.loaded(width, load(width, octets[index..]));
        const stops = escape_lanes(width, block) | scan_utf8.error_lanes(width, previous, block);
        if (any(width, stops)) {
            const end = index + first_lane(width, stops);
            return .{ .len = end - cut_character_len(octets[0..end]), .ascii_next = false };
        }
        previous = block;
        index += width;
        if (!any(width, block >= splat(width, constants.non_ascii_min))) return .{ .len = index, .ascii_next = true };
    }
    return .{ .len = index - cut_character_len(octets[0..index]), .ascii_next = false };
}

/// `hex_len_scalar`, `width` octets at a time (claim J2): each nibble plus `'0'`, and plus the
/// distance from `'9' + 1` to `'a'` when it is 10 or more, the two digits of each octet interleaved.
/// Octets the whole blocks leave take one more block, which overlaps the last and writes the same
/// digits where it does; fewer than a block take `hex_len_short`.
pub fn hex_len_vector(comptime width: usize, input: []const u8, output: []u8) usize {
    const len = @min(input.len, output.len / constants.hex_digits_per_octet);
    if (len < width) {
        if (width > constants.vector_len and len >= constants.vector_len) return hex_len_vector(constants.vector_len, input[0..len], output);
        return hex_len_short(input[0..len], output);
    }
    var index: usize = 0;
    for (0..len / width) |_| {
        hex_block(width, input[index..][0..width], output[constants.hex_digits_per_octet * index ..]);
        index += width;
    }
    if (index < len) hex_block(width, input[len - width ..][0..width], output[constants.hex_digits_per_octet * (len - width) ..]);
    return len;
}

/// Writes the two digits of each octet of `input`, one block of them, at the start of `output`.
inline fn hex_block(comptime width: usize, input: *const [width]u8, output: []u8) void {
    const digits_len = constants.hex_digits_per_octet * width;
    const block: Block(width) = input.*;
    const high = hex_digits(width, block >> @splat(constants.nibble_bits));
    const low = hex_digits(width, block & splat(width, constants.nibble_mask));
    const digits: @Vector(digits_len, u8) = @shuffle(u8, high, low, interleave_mask(width));
    output[0..digits_len].* = digits;
}

/// `hex_len_vector` for fewer than 16 octets. From 4 on, one block holds the first and the last
/// `half` octets, 8 for 8 to 15 and else 4, and each half's digits go to the output's start and
/// end, where they overlap and write the same digits. Below 4 octets, an octet at a time. Inline,
/// so a short hex string pays no call: out of line, qlog's 8-octet strings encoded 6% faster with
/// claim J2 off on the N2 (design §8 step 18).
pub inline fn hex_len_short(input: []const u8, output: []u8) usize {
    const len = @min(input.len, output.len / constants.hex_digits_per_octet);
    assert(len < constants.vector_len);
    if (len >= constants.word_len) {
        hex_halves(constants.word_len, input[0..len], output);
    } else if (len >= half_word_len) {
        hex_halves(half_word_len, input[0..len], output);
    } else return hex_len_scalar(input[0..len], output);
    return len;
}

/// Writes the digits of `input`, of `half` to `2 * half - 1` octets, from one block of its first and
/// its last `half` octets.
inline fn hex_halves(comptime half: usize, input: []const u8, output: []u8) void {
    const halves_len = halves_joined * half;
    const half_digits_len = constants.hex_digits_per_octet * half;
    const len = input.len;
    assert(len >= half and len < halves_len and output.len >= constants.hex_digits_per_octet * len);
    const unused: [constants.vector_len - halves_len]u8 = @splat(0);
    const block: [constants.vector_len]u8 = input[0..half].* ++ input[len - half ..][0..half].* ++ unused;
    var digits: [constants.hex_digits_per_octet * constants.vector_len]u8 = undefined;
    hex_block(constants.vector_len, &block, &digits);
    output[0..half_digits_len].* = digits[0..half_digits_len].*;
    output[constants.hex_digits_per_octet * len - half_digits_len ..][0..half_digits_len].* = digits[half_digits_len..][0..half_digits_len].*;
}

/// The lowercase hexadecimal digit of each lane, whose value is below 16.
fn hex_digits(comptime width: usize, nibbles: Block(width)) Block(width) {
    const letters = nibbles >= splat(width, constants.hex_letter_value_min);
    const past_digits = constants.hex_digits_lower[constants.hex_letter_value_min] - constants.zero - constants.hex_letter_value_min;
    return nibbles + splat(width, constants.zero) + @select(u8, letters, splat(width, past_digits), splat(width, 0));
}

fn interleave_mask(comptime width: usize) @Vector(constants.hex_digits_per_octet * width, i32) {
    var mask: [constants.hex_digits_per_octet * width]i32 = undefined;
    for (0..width) |index| {
        mask[constants.hex_digits_per_octet * index] = @intCast(index);
        mask[constants.hex_digits_per_octet * index + 1] = ~@as(i32, @intCast(index));
    }
    return mask;
}

// `content_len_vector` hands what `utf8_run` leaves to the scalar path, which counts the same run,
// so scan_test.zig's tests pass with the run taking nothing. This one requires the run's own count.
test "a UTF-8 run takes whole blocks itself, up to a block of ASCII, a stop or the input's end" {
    const width = constants.vector_len;
    const euro_sign = "\xe2\x82\xac";
    // Three blocks of U+20AC, 16 characters of three octets each, then two blocks of ASCII.
    var octets: [5 * width]u8 = @splat('a');
    for (0..3 * width / euro_sign.len) |index| octets[euro_sign.len * index ..][0..euro_sign.len].* = euro_sign.*;
    try std.testing.expectEqual(Run{ .len = 4 * width, .ascii_next = true }, utf8_run(width, &octets));
    // The input ends inside the second block, and the first block's end cuts the sixth character.
    try std.testing.expectEqual(Run{ .len = width - 1, .ascii_next = false }, utf8_run(width, octets[0 .. width + 2]));
    // A quotation mark in the fourth block, which a string must escape (RFC 8259 §7).
    octets[3 * width + 5] = constants.quotation_mark;
    try std.testing.expectEqual(Run{ .len = 3 * width + 5, .ascii_next = false }, utf8_run(width, &octets));
    // An ASCII octet where the twelfth character's second octet belongs (RFC 3629 §4).
    octets[2 * width + 2] = 'a';
    try std.testing.expectEqual(Run{ .len = 2 * width + 1, .ascii_next = false }, utf8_run(width, &octets));
}

test {
    _ = scan_utf8;
    _ = @import("scan_test.zig");
}
