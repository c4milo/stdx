//! Claim J10's strings past their plain ASCII (decision 16's JSON decoder token loop): a name's or
//! a string's content once its run of plain ASCII stops at an octet other than its closing
//! quotation mark. It copies the runs a string carries as they are, plain ASCII and whole UTF-8
//! characters (RFC 8259 §7, RFC 3629 §4), and writes each escape RFC 8259 §7 names as the UTF-8 of
//! its character, as decoder_string.zig does. Left to the checked path, the loop's strings with
//! escapes ran 3 to 9 times slower than simdjson's on the N2 (design §8 step 18).
//!
//! Anything else leaves the string, whole, to the checked path, which names every refusal: an
//! escape it refuses or that the input cuts, a lone surrogate, a control character, a character
//! UTF-8 rules out or that the input cuts, and input or room that ends first. It reads and writes
//! the slices it is given, whose bounds Zig checks (ReleaseSafe).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const utf8 = @import("../../utf8.zig");
const scan = @import("../../scan.zig");
const wide = @import("../../wide.zig");
const Claims = @import("../../claims.zig").Claims;
const string_walk = @import("../../string_walk.zig");
const Walk = string_walk.Walk;
const hex_value = @import("../decoder_string.zig").hex_value;

/// What a string's content took: its octets in the input, up to its closing quotation mark, and
/// the octets written for them.
pub const Copied = struct { input_len: usize, output_len: usize };

/// The octets of an escape of a reverse solidus and a letter, of one of `\u` and its digits, and of
/// a surrogate pair's two.
pub const letter_escape_len = 2;
pub const unicode_escape_len = letter_escape_len + constants.escape_hex_digits;
pub const pair_escape_len = unicode_escape_len + unicode_escape_len;

/// The character each escape letter names, and zero for every other octet: no letter names
/// U+0000 (RFC 8259 §7). One load an escape, where optionals took two (design §8 step 18).
const letter_characters = table: {
    var characters: [std.math.maxInt(u8) + 1]u8 = @splat(0);
    for (constants.escape_letters, constants.escaped_characters) |letter, character| characters[letter] = character;
    break :table characters;
};

comptime {
    for (constants.escaped_characters) |character| assert(character != 0);
}

/// Each octet's value as a hexadecimal digit of either case, or `not_hex_digit` for an octet that
/// is none: a load a digit, and one test for a `\u` escape's four, where `hex_value`'s ranges took
/// tests at each digit.
const hex_digit_values = table: {
    var values: [std.math.maxInt(u8) + 1]u8 = @splat(not_hex_digit);
    for (&values, 0..) |*value, octet| value.* = hex_value(octet) orelse not_hex_digit;
    break :table values;
};
/// Past `hex_digit_max`, the largest digit's value, so four values OR'd together pass it when one
/// of them is no digit's.
const not_hex_digit = std.math.maxInt(u8);
const hex_digit_max = constants.nibble_mask;

/// `copy_rest` compiled into the AVX2 variant object with every claim on (variants/loop_string.zig),
/// where the UTF-8 check takes decision 37's lookup, VPSHUFB, which the baseline target lacks.
extern fn stdx_json_copy_rest_x86_64_avx2(rest: [*]const u8, rest_len: usize, room: [*]u8, room_len: usize, copied: *Copied) callconv(.c) bool;

/// `copy_rest`, in the variant object of `level` on x86-64 with every claim on, and here for every
/// other target, level and set of claims. On x86-64 the choice is made out of line, so that the
/// kernel's call site stays out of the token loop: inlined there, the call kept the loop's state
/// in memory on every x86-64 CPU, whether or not it ran, and hex strings and tokens, which never
/// reach it, ran 5% to 10% slower on an AMD EPYC 7763 (design §8 step 18).
pub inline fn copy_rest_at(comptime claims: Claims, level: wide.Level, rest: []const u8, room: []u8) ?Copied {
    if (comptime !wide.has_kernels or !std.meta.eql(claims, Claims{})) return copy_rest(claims, level, rest, room);
    return copy_rest_kernel_or_here(level, rest, room);
}

noinline fn copy_rest_kernel_or_here(level: wide.Level, rest: []const u8, room: []u8) ?Copied {
    if (level == .avx2) {
        var copied: Copied = undefined;
        if (!stdx_json_copy_rest_x86_64_avx2(rest.ptr, rest.len, room.ptr, room.len, &copied)) return null;
        return copied;
    }
    return copy_rest(.{}, level, rest, room);
}

/// The decoder's walk takes a run's ASCII blocks in a loop of their own on every architecture: on
/// x86-64 the one loop decoded the text files at 0.88 to 0.97 of the two loops' speed on an AMD
/// EPYC 7763 and an EPYC 9V74 (string_walk.zig, design §8 step 18).
const two_loops = true;

/// The rest of a string's content, from `rest`, its input after the octets already copied, into
/// `room`, the output after them, whose runs `level`'s scans take. Returns what it took, or null
/// where the checked path must take the string.
pub fn copy_rest(comptime claims: Claims, level: wide.Level, rest: []const u8, room: []u8) align(constants.kernel_alignment) ?Copied {
    var walk: Walk = .{ .input = rest, .output = room };
    // Each pass takes at least one octet, or returns.
    for (0..rest.len + 1) |_| {
        // An escape that follows an escape is taken at once, with no block walked to find it: a text
        // of lines that end in a carriage return and a line feed has two at each line's end.
        if (walk.input.len == 0 or walk.input[0] != constants.reverse_solidus) {
            if (!walk.take_to_stop(claims, two_loops, level, rest, room)) return null;
            if (walk.input.len == 0) return null;
        }
        switch (walk.input[0]) {
            constants.quotation_mark => return .{ .input_len = rest.len - walk.input.len, .output_len = room.len - walk.output.len },
            constants.reverse_solidus => if (!take_escape(claims, &walk)) return null,
            else => return null,
        }
    }
    unreachable;
}

/// Takes the escape that starts the walk's input (RFC 8259 §7): writes the character it names,
/// and moves the walk past the escape and the character. Returns false, with nothing taken, for an
/// escape the checked path refuses, one the input cuts, and a room too short for its character.
///
/// A letter's escape has its lengths as constants here, tested before the moves, so the moves
/// check nothing: passed through `Copied`, each took 11 instructions more on aarch64, and on the
/// N2 an instruction on this path costs its share of a cycle (design §8 step 18).
inline fn take_escape(comptime claims: Claims, walk: *Walk) bool {
    assert(walk.input[0] == constants.reverse_solidus);
    if (walk.input.len < letter_escape_len or walk.output.len == 0) return false;
    // The table holds zero for `u` and for every octet that starts no escape, which
    // `unescape_unicode` tells apart: tested for `u` first, each letter paid the test.
    const character = letter_characters[walk.input[1]];
    if (character == 0) return take_unicode(claims, walk);
    walk.output[0] = character;
    walk.take(letter_escape_len, 1);
    return true;
}

/// `take_escape` for an escape of no letter, of at least its two first octets, with room for an
/// octet: an escape of `u`, or one the checked path refuses.
/// With claim J12 off it is inline, as are the functions it calls: out of line, each escape paid
/// a call and returned what it took through memory, about a third of decoding a text of `\u`
/// escapes. With the claim on, one call takes a text of them (`unicode_call`).
inline fn take_unicode(comptime claims: Claims, walk: *Walk) bool {
    const escape = @call(unicode_call(claims), unescape_unicode, .{ claims, walk.input, walk.output }) orelse return false;
    walk.take(escape.input_len, escape.output_len);
    return true;
}

/// A `\u` escape, or a high surrogate's and the low one's after it (RFC 8259 §7), written as the
/// UTF-8 of the character it names. A surrogate alone names none (RFC 8259 §8.2).
fn unescape_unicode(comptime claims: Claims, escape: []const u8, room: []u8) ?Copied {
    if (claims.decoder_escape_words) {
        const text = unicode_text(escape, room, .{ .input_len = 0, .output_len = 0 });
        if (text.input_len > 0) return unicode_singles(escape, room, text);
    }
    const unit = code_unit(escape, 0) orelse return null;
    const high = unit >= constants.high_surrogate_min and unit < constants.low_surrogate_min;
    if (!high and unit >= constants.low_surrogate_min and unit <= constants.surrogate_max) return null;
    var code_point: u21 = unit;
    if (high) {
        const low = code_unit(escape, unicode_escape_len) orelse return null;
        if (low < constants.low_surrogate_min or low > constants.surrogate_max) return null;
        const high_bits: u21 = unit - constants.high_surrogate_min;
        const low_bits: u21 = low - constants.low_surrogate_min;
        code_point = constants.supplementary_min + ((high_bits << constants.surrogate_bits) | low_bits);
    }
    // No surrogate, and at most U+10FFFF, so UTF-8 holds it (RFC 3629 §3).
    const len = utf8.encoded_len(code_point);
    if (room.len < len) return null;
    utf8.encode(code_point, room[0..len]);
    const first: Copied = .{ .input_len = if (high) pair_escape_len else unicode_escape_len, .output_len = len };
    return unicode_run(claims, escape, room, first);
}

/// `taken`, and the `\u` escapes that follow it at once while each names a character that is no
/// surrogate and the room holds its UTF-8 (RFC 8259 §7): a text whose non-ASCII characters are all
/// escaped, as Python's json.dumps writes by default, takes a word's with no walk between them.
/// With claim J12, `unicode_text` takes what it can first.
inline fn unicode_run(comptime claims: Claims, escape: []const u8, room: []u8, taken: Copied) Copied {
    const run = if (claims.decoder_escape_words) unicode_text(escape, room, taken) else taken;
    return unicode_singles(escape, room, run);
}

/// `taken`, and the `\u` escapes after it one at a time, as `unicode_run` takes them.
inline fn unicode_singles(escape: []const u8, room: []u8, taken: Copied) Copied {
    var run = taken;
    for (0..escape.len / unicode_escape_len) |_| {
        const unit = code_unit(escape[run.input_len..], 0) orelse break;
        if (unit >= constants.high_surrogate_min and unit <= constants.surrogate_max) break;
        const len = utf8.encoded_len(unit);
        if (room.len - run.output_len < len) break;
        utf8.encode(unit, room[run.output_len..][0..len]);
        run.input_len += unicode_escape_len;
        run.output_len += len;
    }
    return run;
}

/// The code unit of the `\u` escape at `offset` in `escape`, from its four hexadecimal digits of
/// either case; or null when the escape is not there, or cut, or a digit is not one.
pub inline fn code_unit(escape: []const u8, offset: usize) ?u16 {
    if (escape.len - offset < unicode_escape_len) return null;
    if (escape[offset] != constants.reverse_solidus or escape[offset + 1] != constants.escape_unicode) return null;
    var unit: u16 = 0;
    var any: u8 = 0;
    for (escape[offset + letter_escape_len ..][0..constants.escape_hex_digits]) |digit| {
        const value = hex_digit_values[digit];
        any |= value;
        unit = unit << constants.nibble_bits | (value & hex_digit_max);
    }
    return if (any > hex_digit_max) null else unit;
}

// Claim J12: two `\u` escapes a pass. Read least significant octet first, the first eight octets of
// two escapes that follow each other hold the first's reverse solidus and `u` in their lowest two
// and the second's in their highest two, and the eight digits make one word, the first escape's in
// its lower half. Each test of a digit adds a constant that carries the octet into its high bit
// from a threshold on; an ASCII octet plus such a constant stays below 0x100, so no octet carries
// into the next.

/// One in each octet of a word: a value times it is that value in every octet.
const octet_lanes: u64 = std.math.maxInt(u64) / std.math.maxInt(u8);
/// The lowest octet of each 16-bit field of a word, and the lowest half of each 32-bit field.
const low_octets: u64 = std.math.maxInt(u64) / std.math.maxInt(u16) * std.math.maxInt(u8);
const low_halves: u64 = std.math.maxInt(u64) / std.math.maxInt(u32) * std.math.maxInt(u16);

/// A `\u` escape's reverse solidus and `u`, as its first two octets read, and where the second
/// escape's lie in the first word of a pair.
const escape_prefix: u64 = constants.reverse_solidus | @as(u64, constants.escape_unicode) << @bitSizeOf(u8);
const escape_prefix_mask: u64 = std.math.maxInt(u16);
const second_prefix_shift = unicode_escape_len * @bitSizeOf(u8);
const pair_prefixes = escape_prefix | escape_prefix << second_prefix_shift;
const pair_prefixes_mask = escape_prefix_mask | escape_prefix_mask << second_prefix_shift;

/// Where the first escape's digits start in the pair's first word, and the bits of one escape's
/// four digits, where the second escape's unit starts in the word of units.
const first_digits_shift = letter_escape_len * @bitSizeOf(u8);
pub const escape_digits_bits = constants.escape_hex_digits * @bitSizeOf(u8);

/// The first and last letters of a hexadecimal digit, lowercase, and what a letter's low nibble
/// falls short of its value by: 'a' and 'A' end in 1 and are worth 10.
const hex_letter_first = constants.hex_digits_lower[constants.hex_letter_value_min];
const hex_letter_last = constants.hex_digits_lower[constants.hex_digits_lower.len - 1];
const letter_nibble_offset = constants.hex_letter_value_min - (hex_letter_first & constants.nibble_mask);

/// In every octet: the high bit, and the shift that brings it down to the lowest; the sums that
/// reach the high bit from '0', from past '9', from 'a' and from past 'f'; the case bit; and the
/// low nibble.
const octet_high_bits = octet_lanes * constants.non_ascii_min;
const high_bit_shift = @bitSizeOf(u8) - 1;
const from_zero = octet_lanes * (constants.non_ascii_min - constants.zero);
const past_nine = octet_lanes * (constants.non_ascii_min - constants.nine - 1);
const from_a = octet_lanes * (constants.non_ascii_min - hex_letter_first);
const past_f = octet_lanes * (constants.non_ascii_min - hex_letter_last - 1);
const case_bits = octet_lanes * constants.ascii_case_bit;
const low_nibbles = octet_lanes * constants.nibble_mask;

/// The most octets one code unit's UTF-8 takes, three up to U+FFFF (RFC 3629 §3), and the largest
/// code point each length reaches, indexed by the length.
const unit_utf8_len_max = 3;
const utf8_len_code_point_max = [_]u21{ 0, constants.one_octet_max, constants.two_octets_max, constants.three_octets_max };
/// The room a pair takes: both characters' UTF-8 goes out in one word, at most six octets of it.
const pair_room_len = @sizeOf(u64);
/// Four zeros as the second escape's digits, for a pair of one escape.
const zero_digits = (octet_lanes * constants.zero) << escape_digits_bits;

/// `taken`, and after it the `\u` escapes whose code units are no surrogates, and the plain ASCII
/// and the letters' escapes between them, while the room holds their characters (claim J12): two
/// `\u` escapes at once where two follow each other, their reverse solidi and `u`s checked in one
/// word and their eight digits read in another, where one escape at a time took about 28
/// instructions an escape to read; and between two escapes a letter's escape, or up to
/// `constants.escape_gap_len_max` octets of plain ASCII one at a time, where a return to the walk
/// took about 100 instructions at each (design §8 step 18).
pub inline fn unicode_text(escape: []const u8, room: []u8, taken: Copied) Copied {
    var rest = escape[taken.input_len..];
    var space = room[taken.output_len..];
    var gap_len: usize = 0;
    // Each pass takes at least one octet, or ends the text.
    for (0..escape.len) |_| {
        if (rest.len == 0 or space.len == 0) break;
        if (rest[0] != constants.reverse_solidus) {
            if (!is_plain_ascii(rest[0]) or gap_len == constants.escape_gap_len_max) break;
            space[0] = rest[0];
            rest = rest[1..];
            space = space[1..];
            gap_len += 1;
            continue;
        }
        const escapes = take_escapes(rest, space) orelse take_letter(rest, space) orelse break;
        rest = rest[escapes.input_len..];
        space = space[escapes.output_len..];
        gap_len = 0;
    }
    return .{ .input_len = escape.len - rest.len, .output_len = room.len - space.len };
}

/// The escape of a letter that starts `rest` (RFC 8259 §7), written at the start of `space`, which
/// holds an octet or more; or null where `rest` starts with none.
inline fn take_letter(rest: []const u8, space: []u8) ?Copied {
    if (rest.len < letter_escape_len) return null;
    const character = letter_characters[rest[1]];
    if (character == 0) return null;
    space[0] = character;
    return .{ .input_len = letter_escape_len, .output_len = 1 };
}

/// How `take_unicode` calls `unescape_unicode`: out of line with claim J12, and inline with it
/// off. Inlined into `copy_rest`, claim J12's loop kept the letter escapes' path in memory on
/// x86-64: json-1m as a string, all escapes of a letter, decoded 5% and 9% slower on an AMD EPYC
/// 9V74 and 7763. On aarch64 the registers held both, but the loop's constants were set again
/// at every stop of the walk's blocks, four to eight instructions a stop in every string (design
/// §8 step 18).
fn unicode_call(comptime claims: Claims) std.builtin.CallModifier {
    return if (claims.decoder_escape_words) .never_inline else .always_inline;
}

/// True for an ASCII octet a string carries as it is: from U+0020 up, but the quotation mark and
/// the reverse solidus (RFC 8259 §7).
inline fn is_plain_ascii(octet: u8) bool {
    return octet >= constants.unescaped_min and octet < constants.non_ascii_min and octet != constants.quotation_mark and octet != constants.reverse_solidus;
}

/// The two `\u` escapes that start `rest`, or the one, written at the start of `space` as the
/// UTF-8 of their characters; or null where they are no escapes of code units that are no
/// surrogates, and where fewer than a word of input or of room is left for one.
inline fn take_escapes(rest: []const u8, space: []u8) ?Copied {
    if (rest.len >= pair_escape_len and space.len >= pair_room_len) {
        if (take_pair(rest[0..pair_escape_len], space[0..pair_room_len])) |pair| return pair;
    }
    if (rest.len < constants.word_len or space.len < @sizeOf(u32)) return null;
    const unit = code_unit_word(rest[0..constants.word_len]) orelse return null;
    const character = unit_utf8(unit) orelse return null;
    std.mem.writeInt(u32, space[0..@sizeOf(u32)], character.word, .little);
    return .{ .input_len = unicode_escape_len, .output_len = character.len };
}

/// Two `\u` escapes, written as the UTF-8 of their characters in one store of a word; or null.
inline fn take_pair(octets: *const [pair_escape_len]u8, space: *[pair_room_len]u8) ?Copied {
    const units = code_unit_pair(octets) orelse return null;
    const first = unit_utf8(@truncate(units)) orelse return null;
    const second = unit_utf8(@truncate(units >> escape_digits_bits)) orelse return null;
    const second_shift: u6 = @intCast(first.len * @bitSizeOf(u8));
    std.mem.writeInt(u64, space, @as(u64, first.word) | (@as(u64, second.word) << second_shift), .little);
    return .{ .input_len = pair_escape_len, .output_len = first.len + second.len };
}

/// The code unit of the `\u` escape that starts `octets`, from the word that holds it: its digits
/// read as a pair's first escape's, with four zeros as the second's.
pub inline fn code_unit_word(octets: *const [constants.word_len]u8) ?u16 {
    const word = std.mem.readInt(u64, octets, .little);
    if ((word & escape_prefix_mask) != escape_prefix) return null;
    const digits: u64 = @as(u32, @truncate(word >> first_digits_shift));
    const units = pair_units(digits | zero_digits) orelse return null;
    return @truncate(units);
}

/// A code unit's UTF-8 in a word's lowest octets, its first octet lowest, and their count.
const Utf8Word = struct { word: u32, len: usize };

/// The UTF-8 of `unit` (RFC 3629 §3), or null for a surrogate, which names no character alone
/// (RFC 8259 §7). Stored whole as a word, where `utf8.encode`'s store of each length took about 18
/// instructions an escape with the length it is chosen by (design §8 step 18).
inline fn unit_utf8(unit: u16) ?Utf8Word {
    inline for (1..unit_utf8_len_max + 1) |len| {
        if (unit <= utf8_len_code_point_max[len]) {
            if (len == unit_utf8_len_max and is_surrogate(unit)) return null;
            var octets: [@sizeOf(u32)]u8 = @splat(0);
            octets[0..len].* = utf8.encoded(len, unit);
            return .{ .word = std.mem.readInt(u32, &octets, .little), .len = len };
        }
    }
    unreachable;
}

/// True for a code unit of UTF-16's surrogates, which names no character alone (RFC 8259 §7).
inline fn is_surrogate(unit: u16) bool {
    return unit >= constants.high_surrogate_min and unit <= constants.surrogate_max;
}

/// The code units of the two `\u` escapes that `octets` holds one after the other, the first's in
/// the lower half of the word returned and the second's in the upper; or null when either is not a
/// reverse solidus, a `u` and four hexadecimal digits of either case (RFC 8259 §7).
pub inline fn code_unit_pair(octets: *const [pair_escape_len]u8) ?u64 {
    const first = std.mem.readInt(u64, octets[0..constants.word_len], .little);
    if ((first & pair_prefixes_mask) != pair_prefixes) return null;
    const first_digits: u64 = @as(u32, @truncate(first >> first_digits_shift));
    const second_digits: u64 = std.mem.readInt(u32, octets[constants.word_len..], .little);
    return pair_units(first_digits | (second_digits << escape_digits_bits));
}

/// The two code units of `digits`, eight hexadecimal digits of either case, one an octet and each
/// unit's most significant first; or null when an octet is no digit.
inline fn pair_units(digits: u64) ?u64 {
    // An octet from 0x80 up clears its own high bit in both tests, whatever carries into it, and
    // only such an octet carries out of its own: a test for one would add nothing.
    const decimals = (digits +% from_zero) & ~(digits +% past_nine) & octet_high_bits;
    const lower = digits | case_bits;
    const letters = (lower +% from_a) & ~(lower +% past_f) & octet_high_bits;
    if ((decimals | letters) != octet_high_bits) return null;
    const values = (digits & low_nibbles) + (letters >> high_bit_shift) * letter_nibble_offset;
    // Each 16-bit field: its first digit's value times 16 plus its second's, in its lowest octet.
    const octet_values = ((values << constants.nibble_bits) | (values >> @bitSizeOf(u8))) & low_octets;
    // Each 32-bit field: its first octet's value times 256 plus its second's.
    return ((octet_values << @bitSizeOf(u8)) | (octet_values >> @bitSizeOf(u16))) & low_halves;
}
