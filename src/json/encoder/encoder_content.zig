//! The content of the tokens whose octets come in a call's input: a name's or a string's
//! characters, escaped as RFC 8259 §7 requires and checked as UTF-8 (RFC 8259 §8.1), a hex
//! string's digits, and a number's text, checked against RFC 8259 §6.
//!
//! Each loop takes at least one octet of input, or returns, on every pass, so a call's work is
//! bounded by the octets it consumes and writes (invariant 17).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const wide = @import("../wide.zig");
const Claims = @import("../claims.zig").Claims;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Error = encoder_file.Error;
const Piece = encoder_file.Piece;

/// Writes the content of the token in progress from `reader` into `writer`. Returns the call's
/// status when the content goes on in a later call, and null when it is whole.
pub fn write(comptime claims: Claims, encoder: *Encoder, piece: Piece, reader: *codec.Reader, writer: *codec.Writer) Error!?codec.Status {
    return switch (encoder.kind) {
        .name, .string => string(claims, encoder, piece, reader, writer),
        .hex => hex(claims, encoder, piece, reader, writer),
        .number => number(encoder, piece, reader, writer),
        else => unreachable,
    };
}

fn string(comptime claims: Claims, encoder: *Encoder, piece: Piece, reader: *codec.Reader, writer: *codec.Writer) Error!?codec.Status {
    for (0..reader.remaining_len() + 1) |_| {
        if (!encoder.write_pending(writer)) return .needs_room;
        if (reader.remaining_len() == 0) return end_of_string(encoder, piece);
        if (claims.encoder_string_vectors and encoder.utf8.between_characters()) {
            copy_run(encoder.level.with(claims), reader, writer);
            if (reader.remaining_len() == 0) continue;
        }
        if (!try string_octet(claims, encoder, reader, writer)) return .needs_room;
    }
    // Each pass that does not return takes at least one octet.
    unreachable;
}

/// Copies the run of plain ASCII octets, as far as the output has room (claim J1), `level`'s vector
/// at a time (claim J7).
fn copy_run(level: wide.Level, reader: *codec.Reader, writer: *codec.Writer) void {
    const window = reader.take_partial(writer.room_len());
    reader.unread(window.len);
    const run = reader.take(wide.plain_len(level, window)) catch unreachable;
    writer.write_all(run) catch unreachable;
}

/// Takes the next octet of a string: escapes it, or checks it as UTF-8 and copies it. Returns false
/// when the output has no room for it, and then leaves it unread.
fn string_octet(comptime claims: Claims, encoder: *Encoder, reader: *codec.Reader, writer: *codec.Writer) Error!bool {
    const octet = reader.read_octet() catch unreachable;
    const between_characters = encoder.utf8.between_characters();
    if (between_characters and octet < constants.non_ascii_min and !scan.is_plain_ascii(octet)) {
        hold_escape(encoder, octet);
        return true;
    }
    if (writer.room_len() == 0) {
        reader.unread(1);
        return false;
    }
    // Claim J5 starts past the escapes, so a string of ASCII runs what it runs with J5 off.
    if (claims.encoder_string_vectors and claims.utf8_vectors and between_characters and octet >= constants.non_ascii_min) {
        reader.unread(1);
        if (@call(.never_inline, copy_characters, .{ reader, writer }) > 0) return true;
        _ = reader.read_octet() catch unreachable;
    }
    // RFC 8259 §8.1 and RFC 3629 §4: a string's octets are UTF-8.
    if (!encoder.utf8.accept(octet)) return error.InvalidUtf8;
    writer.write_octet(octet) catch unreachable;
    return true;
}

/// Copies the whole UTF-8 characters and plain ASCII octets that start the rest of the input, as
/// far as the output has room, and returns how many octets it copied (claim J5). It copies none
/// when the first character is not UTF-8, or the input or the room cuts it: the scalar validation
/// then takes it.
fn copy_characters(reader: *codec.Reader, writer: *codec.Writer) usize {
    const window = reader.take_partial(writer.room_len());
    reader.unread(window.len);
    const run = reader.take(scan.content_len_vector(constants.vector_len, window)) catch unreachable;
    writer.write_all(run) catch unreachable;
    return run.len;
}

/// Holds the escape of a quotation mark, a reverse solidus or a control character (RFC 8259 §7):
/// its two-character form where it has one, and `\u00` and two lowercase digits where it has none.
fn hold_escape(encoder: *Encoder, octet: u8) void {
    assert(octet < constants.unescaped_min or octet == constants.quotation_mark or octet == constants.reverse_solidus);
    if (std.mem.indexOfScalar(u8, constants.escaped_characters, octet)) |index| {
        encoder.hold(&.{ constants.reverse_solidus, constants.escape_letters[index] });
        return;
    }
    encoder.hold(constants.control_escape_prefix);
    encoder.hold(&hex_pair(octet));
}

fn hex_pair(octet: u8) [constants.hex_digits_per_octet]u8 {
    return .{ constants.hex_digits_lower[octet >> constants.nibble_bits], constants.hex_digits_lower[octet & constants.nibble_mask] };
}

fn end_of_string(encoder: *Encoder, piece: Piece) Error!?codec.Status {
    if (piece == .more) return .needs_input;
    // RFC 3629 §4: a string's octets end with a whole character.
    if (!encoder.utf8.between_characters()) return error.InvalidUtf8;
    return null;
}

fn hex(comptime claims: Claims, encoder: *Encoder, piece: Piece, reader: *codec.Reader, writer: *codec.Writer) ?codec.Status {
    for (0..reader.remaining_len() + 1) |_| {
        if (!encoder.write_pending(writer)) return .needs_room;
        if (reader.remaining_len() == 0) return end_of_hex(piece);
        if (writer.room_len() == 0) return .needs_room;
        // With room for one digit, the next octet's two wait in `pending`.
        if (hex_run(claims, encoder.level, reader, writer) == 0) encoder.hold(&hex_pair(reader.read_octet() catch unreachable));
    }
    // Each pass that does not return takes at least one octet.
    unreachable;
}

/// The status at the end of a call's input: more octets to come, or none, and the content whole.
fn end_of_hex(piece: Piece) ?codec.Status {
    return if (piece == .more) .needs_input else null;
}

/// Writes the digits of as many octets as the output has room for both digits of (claim J2),
/// `level`'s vector at a time (claim J7), and returns how many octets it took.
pub fn hex_run(comptime claims: Claims, level: wide.Level, reader: *codec.Reader, writer: *codec.Writer) usize {
    const window = reader.take_partial(writer.room_len() / constants.hex_digits_per_octet);
    const room = writer.octets[writer.position..];
    const taken = if (claims.hex_vectors)
        wide.hex_len(level.with(claims), window, room)
    else
        scan.hex_len_scalar(window, room);
    assert(taken == window.len);
    writer.position += constants.hex_digits_per_octet * taken;
    return taken;
}

fn number(encoder: *Encoder, piece: Piece, reader: *codec.Reader, writer: *codec.Writer) Error!?codec.Status {
    for (0..reader.remaining_len() + 1) |_| {
        if (reader.remaining_len() == 0) return end_of_number(encoder, piece);
        if (writer.room_len() == 0) return .needs_room;
        const octet = reader.read_octet() catch unreachable;
        // RFC 8259 §6: every octet of a number's text belongs to the one number it holds.
        if (encoder.number.accept(octet) != .taken) return error.InvalidNumber;
        writer.write_octet(octet) catch unreachable;
    }
    // Each pass that does not return takes one octet.
    unreachable;
}

fn end_of_number(encoder: *Encoder, piece: Piece) Error!?codec.Status {
    if (piece == .more) return .needs_input;
    // RFC 8259 §6: a number's text is a whole number.
    if (!encoder.number.whole()) return error.InvalidNumber;
    return null;
}
