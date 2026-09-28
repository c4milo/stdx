//! The encoder's whole-buffer helper (decision 11): one text, one token per call, into one buffer
//! the caller owns. Each call hands the encoder all of the token's octets and all the room left,
//! so a token either fits whole or the helper fails with `error.NoSpaceLeft`, having written
//! nothing past the buffer. A caller that writes records into the free part of a buffer keeps a
//! record only when `written` returns, and its length is the octets to keep.
//!
//! It holds the caller's buffer for the length of one text, as `codec.Writer` does, and is built
//! on the streaming call, never the reverse (CLAUDE.md, Non-negotiables).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Token = encoder_file.Token;
const Framing = @import("../framing.zig").Framing;
const Decimal = @import("../format.zig").Decimal;

/// What a call can fail with: a refusal of the caller's input, or a buffer the text does not fit.
pub const Error = encoder_file.Error || error{NoSpaceLeft};

pub const TextWriter = struct {
    encoder: Encoder,
    output: []u8,
    /// The octets of `output` written so far, from its start.
    len: usize,

    /// Starts a text in `output`, with the caller's CPU features (`Encoder.init`).
    pub fn init(output: []u8, framing: Framing, features: codec.Features) TextWriter {
        var text: TextWriter = .{ .encoder = undefined, .output = output, .len = 0 };
        text.encoder.init(framing, features);
        return text;
    }

    /// Writes one token, with `octets` holding all of a name's, a string's, a hex string's or a
    /// number's octets, and nothing for any other token. After an error the text is lost: the
    /// octets written are no text, and a new one starts with `init`.
    pub fn write(self: *TextWriter, token: Token, octets: []const u8) Error!void {
        const progress = try self.encoder.encode(token, octets, self.output[self.len..]);
        self.len += progress.written;
        if (progress.status == .needs_room) return error.NoSpaceLeft;
        assert(progress.consumed == octets.len);
    }

    pub fn begin_object(self: *TextWriter) Error!void {
        return self.write(.begin_object, "");
    }

    pub fn end_object(self: *TextWriter) Error!void {
        return self.write(.end_object, "");
    }

    pub fn begin_array(self: *TextWriter) Error!void {
        return self.write(.begin_array, "");
    }

    pub fn end_array(self: *TextWriter) Error!void {
        return self.write(.end_array, "");
    }

    /// A member's name, `octets` in UTF-8 (RFC 8259 §4, §8.1).
    pub fn name(self: *TextWriter, octets: []const u8) Error!void {
        return self.write(.{ .name = .last }, octets);
    }

    /// A string of `octets`, in UTF-8 (RFC 8259 §7, §8.1).
    pub fn string(self: *TextWriter, octets: []const u8) Error!void {
        return self.write(.{ .string = .last }, octets);
    }

    /// A string of two lowercase hexadecimal digits for each of `octets`.
    pub fn hex(self: *TextWriter, octets: []const u8) Error!void {
        return self.write(.{ .hex = .last }, octets);
    }

    /// A number whose text is `text`, which must be one number of RFC 8259 §6.
    pub fn number(self: *TextWriter, text: []const u8) Error!void {
        return self.write(.{ .number = .last }, text);
    }

    pub fn unsigned(self: *TextWriter, value: u64) Error!void {
        return self.write(.{ .unsigned = value }, "");
    }

    pub fn signed(self: *TextWriter, value: i64) Error!void {
        return self.write(.{ .signed = value }, "");
    }

    /// A fixed-point decimal: `1234.567` for an integer part of 1234, a fraction of 567 and 3
    /// fraction digits.
    pub fn decimal(self: *TextWriter, value: Decimal) Error!void {
        return self.write(.{ .decimal = value }, "");
    }

    /// The literal name `true` or `false` (RFC 8259 §3).
    pub fn boolean(self: *TextWriter, value: bool) Error!void {
        return self.write(.{ .boolean = value }, "");
    }

    /// The literal name `null` (RFC 8259 §3).
    pub fn null_literal(self: *TextWriter) Error!void {
        return self.write(.null, "");
    }

    /// The text, once its last token is written: `output[0..len]`.
    pub fn written(self: *const TextWriter) []const u8 {
        assert(self.encoder.is_done());
        return self.output[0..self.len];
    }
};
