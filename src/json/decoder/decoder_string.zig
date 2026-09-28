//! A name's or a string's content (RFC 8259 §7), up to its closing quotation mark: the octets a
//! string carries as they are, checked as UTF-8 (RFC 8259 §8.1, RFC 3629 §4), and each escape
//! written as the UTF-8 of the character it names.
//!
//! Every pass of the loop takes at least one octet of input or returns, so a call's work is bounded
//! by the octets it consumes and writes (invariant 17).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const Claims = @import("../claims.zig").Claims;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Error = decoder_file.Error;
const Outcome = decoder_file.Outcome;

/// Decodes the content of the name or string in progress. Returns `token` at its closing
/// quotation mark, or the status of a call whose input or room ran out first.
pub fn content(comptime claims: Claims, decoder: *Decoder, reader: *codec.Reader, writer: *codec.Writer) Error!Outcome {
    const kind = decoder_file.kind_of(decoder.open);
    for (0..reader.remaining_len() + 1) |_| {
        if (!write_pending(decoder, writer)) return .{ .status = .needs_room, .kind = kind };
        if (decoder.escape != .none) {
            try escape_octet(decoder, reader.read_octet() catch return .{ .status = .needs_input, .kind = kind });
            continue;
        }
        if (claims.decoder_string_vectors and decoder.utf8.between_characters()) copy_run(claims, reader, writer);
        const octet = reader.read_octet() catch return .{ .status = .needs_input, .kind = kind };
        if (try string_octet(decoder, octet, reader, writer)) |outcome| return outcome;
    }
    // Each pass that does not return takes at least one octet.
    unreachable;
}

/// Copies the run of octets a string carries as they are, as far as the output has room (claims J3
/// and J5).
fn copy_run(comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer) void {
    const window = reader.take_partial(writer.room_len());
    reader.unread(window.len);
    const run_len = if (claims.utf8_vectors)
        scan.content_len_vector(constants.vector_len, window)
    else
        scan.plain_len_vector(constants.vector_len, window);
    const run = reader.take(run_len) catch unreachable;
    writer.write_all(run) catch unreachable;
}

/// Takes one octet of the content: the closing quotation mark, the start of an escape, or an octet
/// the string carries as it is. Returns the call's outcome when the token ends or the output has no
/// room for the octet, which it then leaves unread, and null when the content goes on.
fn string_octet(decoder: *Decoder, octet: u8, reader: *codec.Reader, writer: *codec.Writer) Error!?Outcome {
    const kind = decoder_file.kind_of(decoder.open);
    const delimits = octet == constants.quotation_mark or octet == constants.reverse_solidus or octet < constants.unescaped_min;
    if (delimits and decoder.utf8.between_characters()) return delimiter(decoder, octet);
    if (writer.room_len() == 0) {
        reader.unread(1);
        return .{ .status = .needs_room, .kind = kind };
    }
    // RFC 8259 §8.1 and RFC 3629 §4: a text is UTF-8.
    if (!decoder.utf8.accept(octet)) return error.InvalidUtf8;
    writer.write_octet(octet) catch unreachable;
    return null;
}

/// Takes an octet that is not a string's content between characters: the closing quotation mark,
/// the reverse solidus of an escape, or a control character.
fn delimiter(decoder: *Decoder, octet: u8) Error!?Outcome {
    const kind = decoder_file.kind_of(decoder.open);
    if (octet == constants.quotation_mark) {
        if (kind == .name) decoder.name_ended() else decoder.value_ended(kind);
        return .{ .status = .token, .kind = kind };
    }
    if (octet == constants.reverse_solidus) {
        decoder.escape = .reverse_solidus;
        return null;
    }
    assert(octet < constants.unescaped_min);
    // RFC 7464 §2.1: a record separator ends a sequence's text, here inside a string.
    if (decoder.framing == .sequence and octet == constants.record_separator) return error.IncompleteText;
    // RFC 8259 §7: the control characters U+0000 to U+001F must be escaped.
    return error.ControlCharacterInString;
}

/// Takes one octet of an escape (RFC 8259 §7).
fn escape_octet(decoder: *Decoder, octet: u8) Error!void {
    switch (decoder.escape) {
        .reverse_solidus => return escape_letter(decoder, octet),
        .unicode => return escape_digit(decoder, octet),
        .high_surrogate => {
            // RFC 8259 §8.2: a high surrogate that no low one follows names no character.
            if (octet != constants.reverse_solidus) return error.LoneSurrogate;
            decoder.escape = .high_surrogate_reverse_solidus;
        },
        .high_surrogate_reverse_solidus => {
            // RFC 8259 §8.2: a high surrogate that no low one follows names no character.
            if (octet != constants.escape_unicode) return error.LoneSurrogate;
            start_unicode(decoder);
        },
        .none => unreachable,
    }
}

/// Takes the octet after a reverse solidus: `u`, or the letter of a two-character escape.
fn escape_letter(decoder: *Decoder, octet: u8) Error!void {
    if (octet == constants.escape_unicode) return start_unicode(decoder);
    const index = std.mem.indexOfScalar(u8, constants.escape_letters, octet) orelse {
        // RFC 8259 §7: a reverse solidus starts one of the escapes the grammar lists.
        return error.InvalidEscape;
    };
    decoder.escape = .none;
    hold(decoder, &.{constants.escaped_characters[index]});
}

fn start_unicode(decoder: *Decoder) void {
    decoder.escape = .unicode;
    decoder.escape_digits = 0;
    decoder.code_unit = 0;
}

/// Takes one of the four hexadecimal digits of a `\u` escape.
fn escape_digit(decoder: *Decoder, octet: u8) Error!void {
    // RFC 8259 §7: `\u` is followed by four hexadecimal digits, A to F in either case.
    const digit = hex_value(octet) orelse return error.InvalidEscape;
    decoder.code_unit = (decoder.code_unit << constants.nibble_bits) | digit;
    decoder.escape_digits += 1;
    if (decoder.escape_digits == constants.escape_hex_digits) try end_unicode(decoder);
}

fn hex_value(octet: u8) ?u8 {
    return switch (octet) {
        '0'...'9' => octet - '0',
        'a'...'f' => octet - 'a' + constants.hex_letter_value_min,
        'A'...'F' => octet - 'A' + constants.hex_letter_value_min,
        else => null,
    };
}

/// Ends a `\u` escape: holds the UTF-8 of the character it names, or waits for the low surrogate
/// after a high one (RFC 8259 §7). UTF-8 cannot hold a surrogate (RFC 3629 §3), so a lone one is
/// refused (decision 15).
fn end_unicode(decoder: *Decoder) Error!void {
    const unit = decoder.code_unit;
    decoder.escape = .none;
    const is_low = unit >= constants.low_surrogate_min and unit <= constants.surrogate_max;
    if (decoder.high_surrogate != 0) {
        // RFC 8259 §8.2: after a high surrogate, only a low surrogate names a character.
        if (!is_low) return error.LoneSurrogate;
        const high_bits: u21 = decoder.high_surrogate - constants.high_surrogate_min;
        const low_bits: u21 = unit - constants.low_surrogate_min;
        decoder.high_surrogate = 0;
        return hold_code_point(decoder, constants.supplementary_min + ((high_bits << constants.surrogate_bits) | low_bits));
    }
    if (unit >= constants.high_surrogate_min and unit < constants.low_surrogate_min) {
        decoder.high_surrogate = unit;
        decoder.escape = .high_surrogate;
        return;
    }
    // RFC 8259 §8.2: a low surrogate with no high one before it names no character.
    if (is_low) return error.LoneSurrogate;
    hold_code_point(decoder, unit);
}

/// Holds the UTF-8 of `code_point`, which is no surrogate and at most U+10FFFF: the callers check
/// both, so `utf8Encode` cannot refuse it (RFC 3629 §3).
fn hold_code_point(decoder: *Decoder, code_point: u21) void {
    var octets: [constants.utf8_len_max]u8 = undefined;
    const len = std.unicode.utf8Encode(code_point, &octets) catch unreachable;
    hold(decoder, octets[0..len]);
}

/// Adds `octets` to what the call writes before anything else.
fn hold(decoder: *Decoder, octets: []const u8) void {
    assert(decoder.pending_len == 0 and octets.len <= decoder.pending.len);
    @memcpy(decoder.pending[0..octets.len], octets);
    decoder.pending_len = @intCast(octets.len);
    decoder.pending_written = 0;
}

/// Writes what `output` takes of the held octets. Returns whether all of them are written.
fn write_pending(decoder: *Decoder, writer: *codec.Writer) bool {
    assert(decoder.pending_written <= decoder.pending_len);
    decoder.pending_written += @intCast(writer.write_partial(decoder.pending[decoder.pending_written..decoder.pending_len]));
    if (decoder.pending_written < decoder.pending_len) return false;
    decoder.pending_len = 0;
    decoder.pending_written = 0;
    return true;
}

// Tests. The decoder's tests run the content through `decode`; these pin the digits.

const testing = std.testing;

test "hex_value reads a digit of either case and nothing else" {
    for (0..256) |value| {
        const octet: u8 = @intCast(value);
        const expected: ?u8 = std.fmt.charToDigit(octet, 16) catch null;
        try testing.expectEqual(expected, hex_value(octet));
    }
}
