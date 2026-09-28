//! A number's octets (RFC 8259 §6), which the decoder writes as they are, and the literal names
//! (RFC 8259 §3). Neither says where it ends: a number ends at the first octet that cannot go on
//! with it, and a literal name at its last letter, and the grammar judges what follows each.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const Piece = @import("../framing.zig").Piece;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Error = decoder_file.Error;
const Outcome = decoder_file.Outcome;

/// Decodes the number in progress, writing its octets into the output. Returns `token` at the
/// first octet past it, which it leaves unread, or at the text's last octet.
pub fn number(decoder: *Decoder, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!Outcome {
    assert(decoder.open == .number);
    for (0..reader.remaining_len() + 1) |_| {
        const octet = reader.read_octet() catch return end_of_input(decoder, piece);
        var next = decoder.number;
        switch (next.accept(octet)) {
            .taken => {
                if (writer.room_len() == 0) {
                    reader.unread(1);
                    return .{ .status = .needs_room, .kind = .number };
                }
                decoder.number = next;
                writer.write_octet(octet) catch unreachable;
            },
            .ended => {
                reader.unread(1);
                decoder.value_ended(.number);
                return .{ .status = .token, .kind = .number };
            },
            // RFC 8259 §6: the octet cannot come next in a number, and the number is not whole.
            .invalid => return error.InvalidNumber,
        }
    }
    // Each pass that does not return takes one octet.
    unreachable;
}

/// A number the input ran out in: whole at the text's last octet, and else waiting for more.
fn end_of_input(decoder: *Decoder, piece: Piece) Outcome {
    if (piece == .last and decoder.number.whole()) {
        decoder.value_ended(.number);
        return .{ .status = .token, .kind = .number };
    }
    return .{ .status = .needs_input, .kind = .number };
}

/// Decodes the literal name in progress, whose first letter the decoder took. Returns `token`
/// after its last letter.
pub fn literal(decoder: *Decoder, reader: *codec.Reader) Error!Outcome {
    const kind = decoder_file.kind_of(decoder.open);
    const text: []const u8 = switch (kind) {
        .true => constants.literal_true,
        .false => constants.literal_false,
        .null => constants.literal_null,
        else => unreachable,
    };
    assert(decoder.matched >= 1 and decoder.matched <= text.len);
    for (decoder.matched..text.len) |index| {
        const octet = reader.read_octet() catch return .{ .status = .needs_input, .kind = null };
        if (octet != text[index]) {
            // RFC 7464 §2.1: a record separator ends a sequence's text, here inside a literal name.
            if (decoder.framing == .sequence and octet == constants.record_separator) return error.IncompleteText;
            // RFC 8259 §3: the literal names are false, null and true, lowercase.
            return error.InvalidLiteral;
        }
        decoder.matched += 1;
    }
    decoder.value_ended(kind);
    return .{ .status = .token, .kind = kind };
}
