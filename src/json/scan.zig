//! The loops the encoder and the decoder spend their time in, each as a scalar path and a vector
//! path that must return the same (decision 21; claims J1 to J5, decision 27): the run of a
//! string's octets that need no escape, the same run with UTF-8 validated in it, the run of
//! whitespace, and hexadecimal digits.
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

/// True for an octet a string carries as it is that is ASCII: U+0020 to U+007F, but for quotation
/// mark and reverse solidus, which a string must escape (RFC 8259 §7).
pub fn is_plain_ascii(octet: u8) bool {
    return octet >= constants.unescaped_min and octet < constants.non_ascii_min and
        octet != constants.quotation_mark and octet != constants.reverse_solidus;
}

/// True for insignificant whitespace (RFC 8259 §2).
pub fn is_whitespace(octet: u8) bool {
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

/// The run of whitespace that starts `octets`, an octet at a time (claim J4 off).
pub fn whitespace_len_scalar(octets: []const u8) usize {
    for (octets, 0..) |octet, index| {
        if (!is_whitespace(octet)) return index;
    }
    return octets.len;
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

fn any(comptime width: usize, lanes: Lanes(width)) bool {
    return @reduce(.Or, lanes);
}

/// The first lane that holds, of lanes of which at least one does.
fn first_lane(comptime width: usize, lanes: Lanes(width)) usize {
    assert(any(width, lanes));
    if (builtin.cpu.arch == .aarch64) {
        // NEON gathers no bit per lane into a register. Shifted right by 4 and narrowed as 16-bit
        // lanes, octets of all ones or all zeros leave 4 bits each in one word, the lowest lane
        // lowest: a SHRN, where x86-64 takes PMOVMSKB (docs/costs.md, the 32-octet vector compare).
        const octets = @select(u8, lanes, splat(width, std.math.maxInt(u8)), splat(width, 0));
        const halves: @Vector(width / @sizeOf(u16), u16) = @bitCast(octets);
        const narrowed: @Vector(width / @sizeOf(u16), u8) = @truncate(halves >> @splat(constants.nibble_bits));
        const nibbles: std.meta.Int(.unsigned, width * constants.nibble_bits) = @bitCast(narrowed);
        return @ctz(nibbles) / constants.nibble_bits;
    }
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
fn plain_stops(comptime width: usize, block: Block(width)) Lanes(width) {
    const shifted = block -% splat(width, constants.unescaped_min);
    const outside = shifted >= splat(width, constants.non_ascii_min - constants.unescaped_min);
    return outside | escape_lanes(width, block);
}

/// The lanes whose octet a string must escape (RFC 8259 §7).
fn escape_lanes(comptime width: usize, block: Block(width)) Lanes(width) {
    const control = block < splat(width, constants.unescaped_min);
    const quotation_mark = block == splat(width, constants.quotation_mark);
    const reverse_solidus = block == splat(width, constants.reverse_solidus);
    return control | quotation_mark | reverse_solidus;
}

/// `plain_len_scalar`, `width` octets at a time (claims J1 and J3).
pub fn plain_len_vector(comptime width: usize, octets: []const u8) usize {
    var index: usize = 0;
    for (0..octets.len / width) |_| {
        const stops = plain_stops(width, load(width, octets[index..]));
        if (any(width, stops)) return index + first_lane(width, stops);
        index += width;
    }
    return index + plain_len_scalar(octets[index..]);
}

/// The lanes of `block` whose octet UTF-8 rules out there, given the lanes before it and the last
/// three of `previous` (RFC 3629 §4). A lane holds when:
/// - a continuation octet stands where no first octet asks for one, or another octet stands where
///   one does;
/// - the octet is C0, C1 or from F5 up, which UTF-8 never holds;
/// - the octet follows E0, ED, F0 or F4 outside the narrower range RFC 3629 §4 gives it there.
///
/// `previous` ends between characters, or inside a character whose octets `block` goes on with.
fn utf8_error_lanes(comptime width: usize, previous: Block(width), block: Block(width)) Lanes(width) {
    var asked: Lanes(width) = @splat(false);
    inline for (1..constants.utf8_len_max) |back| {
        asked |= shifted_in(width, back, previous, block) >= splat(width, constants.reaching_lead_min[back]);
    }
    const continuation = (block >= splat(width, constants.continuation_min)) & (block <= splat(width, constants.continuation_max));
    const overlong_first = (block >= splat(width, constants.overlong_lead_2_min)) & (block < splat(width, constants.lead_2_min));
    const never = overlong_first | (block >= splat(width, constants.invalid_min));
    const back_1 = shifted_in(width, 1, previous, block);
    const overlong_3 = (back_1 == splat(width, constants.lead_3_overlong)) & (block < splat(width, constants.lead_3_overlong_second_min));
    const surrogate = (back_1 == splat(width, constants.lead_3_surrogate)) & (block > splat(width, constants.lead_3_surrogate_second_max));
    const overlong_4 = (back_1 == splat(width, constants.lead_4_overlong)) & (block < splat(width, constants.lead_4_overlong_second_min));
    const past_last = (back_1 == splat(width, constants.lead_4_largest)) & (block > splat(width, constants.lead_4_largest_second_max));
    return (continuation != asked) | never | overlong_3 | surrogate | overlong_4 | past_last;
}

/// The lanes of `block` moved up by `count`, with the last `count` lanes of `previous` below them.
fn shifted_in(comptime width: usize, comptime count: usize, previous: Block(width), block: Block(width)) Block(width) {
    const mask = comptime shift_mask(width, count);
    return @shuffle(u8, previous, block, mask);
}

fn shift_mask(comptime width: usize, comptime count: usize) @Vector(width, i32) {
    var mask: [width]i32 = undefined;
    for (&mask, 0..) |*lane, index| {
        lane.* = if (index >= count) ~@as(i32, @intCast(index - count)) else @intCast(width - count + index);
    }
    return mask;
}

/// The octets at the end of `octets` that start a character it cuts, when all before them is whole
/// UTF-8 and the last character's continuation octets are right for their first octet.
fn cut_character_len(octets: []const u8) usize {
    // `@min` with a comptime operand narrows its type, so the bound is widened before the `+ 1`.
    const from_end_max: usize = @min(octets.len, constants.utf8_len_max - 1);
    for (1..from_end_max + 1) |from_end| {
        const octet = octets[octets.len - from_end];
        if (octet < constants.continuation_min or octet > constants.continuation_max) {
            // A first octet asks for as many continuation octets as it reaches past itself.
            var reach: usize = 0;
            for (constants.reaching_lead_min[1..]) |lead_min| reach += @intFromBool(octet >= lead_min);
            return if (reach >= from_end) from_end else 0;
        }
    }
    return 0;
}

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
/// on a character's end. Without one, the run stops before the block that fails, less a character
/// it cuts.
fn utf8_run(comptime width: usize, octets: []const u8) Run {
    var previous = splat(width, 0);
    var index: usize = 0;
    for (0..octets.len / width) |_| {
        const block = load(width, octets[index..]);
        if (any(width, escape_lanes(width, block) | utf8_error_lanes(width, previous, block))) break;
        previous = block;
        index += width;
        if (!any(width, block >= splat(width, constants.non_ascii_min))) return .{ .len = index, .ascii_next = true };
    }
    return .{ .len = index - cut_character_len(octets[0..index]), .ascii_next = false };
}

/// `whitespace_len_scalar`, `width` octets at a time (claim J4). Most tokens follow the one before
/// with no whitespace between them, so the first octet is tested alone before any block is loaded.
pub fn whitespace_len_vector(comptime width: usize, octets: []const u8) usize {
    if (octets.len == 0 or !is_whitespace(octets[0])) return 0;
    var index: usize = 0;
    for (0..octets.len / width) |_| {
        const block = load(width, octets[index..]);
        const space = block == splat(width, constants.space);
        const horizontal_tab = block == splat(width, constants.horizontal_tab);
        const line_feed = block == splat(width, constants.line_feed);
        const carriage_return = block == splat(width, constants.carriage_return);
        const others = !(space | horizontal_tab | line_feed | carriage_return);
        if (any(width, others)) return index + first_lane(width, others);
        index += width;
    }
    return index + whitespace_len_scalar(octets[index..]);
}

/// `hex_len_scalar`, `width` octets at a time (claim J2): each nibble plus `'0'`, and plus the
/// distance from `'9' + 1` to `'a'` when it is 10 or more, the two digits of each octet interleaved.
pub fn hex_len_vector(comptime width: usize, input: []const u8, output: []u8) usize {
    const len = @min(input.len, output.len / constants.hex_digits_per_octet);
    const digits_len = constants.hex_digits_per_octet * width;
    var index: usize = 0;
    for (0..len / width) |_| {
        const block = load(width, input[index..]);
        const high = hex_digits(width, block >> @splat(constants.nibble_bits));
        const low = hex_digits(width, block & splat(width, constants.nibble_mask));
        const digits: @Vector(digits_len, u8) = @shuffle(u8, high, low, interleave_mask(width));
        output[constants.hex_digits_per_octet * index ..][0..digits_len].* = digits;
        index += width;
    }
    return index + hex_len_scalar(input[index..len], output[constants.hex_digits_per_octet * index ..]);
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

test {
    _ = @import("scan_test.zig");
}
