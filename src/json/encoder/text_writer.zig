//! The encoder's whole-buffer helper (decision 11): one text, one token per call, into one buffer
//! the caller owns. Each call hands the encoder all of the token's octets and all the room left,
//! so a token either fits whole or the helper fails with `error.NoSpaceLeft`, having written
//! nothing past the buffer. A caller that writes records into the free part of a buffer keeps a
//! record only when `written` returns, and its length is the octets to keep.
//!
//! It holds the caller's buffer for the length of one text, as `codec.Writer` does, and is built
//! on the streaming call and on the token loop's step that call takes, never the reverse
//! (CLAUDE.md, Non-negotiables; decision 69).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Token = encoder_file.Token;
const token_loop = @import("encoder_loop/encoder_loop.zig");
const Claims = @import("../claims.zig").Claims;
const Framing = @import("../framing.zig").Framing;
const Decimal = @import("../format.zig").Decimal;

pub const TextWriter = struct {
    /// What a call can fail with: a refusal of the caller's input, or a buffer the text does not
    /// fit.
    pub const Error = encoder_file.Error || error{NoSpaceLeft};

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

    /// Writes `items` in one call (decision 33), each with all of its octets, as `write` writes each
    /// alone. After an error the text is lost, as after `write`'s.
    pub fn write_items(self: *TextWriter, items: []const Encoder.Item) Error!void {
        const batch = try self.encoder.encode_batch(items, self.output[self.len..]);
        self.len += batch.written;
        if (batch.status == .needs_room) return error.NoSpaceLeft;
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

    /// One token whose kind the calling method fixes (claim J15). The token loop's step for that
    /// kind alone compiles into the method, and writes the token whole at `output[len..]`. A token
    /// the step leaves, one to escape past its room or to refuse, takes the checked path.
    inline fn whole(self: *TextWriter, token: Token, octets: []const u8) Error!void {
        if (self.encoder.part == .between_tokens) {
            const item: Encoder.Item = .{ .token = token, .octets = octets };
            var end = self.len;
            const taken = @call(.always_inline, token_loop.take, .{ &self.encoder, Claims{}, @as(*const [1]Encoder.Item, &item), self.output, &end });
            if (taken == 1) {
                self.len = end;
                return;
            }
        }
        return self.checked(token, octets);
    }

    /// `write` on the checked path alone, for a token the loop's step left.
    noinline fn checked(self: *TextWriter, token: Token, octets: []const u8) Error!void {
        const progress = try self.encoder.encode_with(.{ .encoder_token_entry = false, .encoder_fast_path = false }, token, octets, self.output[self.len..]);
        self.len += progress.written;
        if (progress.status == .needs_room) return error.NoSpaceLeft;
        assert(progress.consumed == octets.len);
    }

    pub fn begin_object(self: *TextWriter) Error!void {
        return self.whole(.begin_object, "");
    }

    pub fn end_object(self: *TextWriter) Error!void {
        return self.whole(.end_object, "");
    }

    pub fn begin_array(self: *TextWriter) Error!void {
        return self.whole(.begin_array, "");
    }

    pub fn end_array(self: *TextWriter) Error!void {
        return self.whole(.end_array, "");
    }

    /// A member's name, `octets` in UTF-8 (RFC 8259 §4, §8.1).
    pub fn name(self: *TextWriter, octets: []const u8) Error!void {
        return self.whole(.{ .name = .last }, octets);
    }

    /// A string of `octets`, in UTF-8 (RFC 8259 §7, §8.1).
    pub fn string(self: *TextWriter, octets: []const u8) Error!void {
        return self.whole(.{ .string = .last }, octets);
    }

    /// A string of two lowercase hexadecimal digits for each of `octets`.
    pub fn hex(self: *TextWriter, octets: []const u8) Error!void {
        return self.whole(.{ .hex = .last }, octets);
    }

    /// A number whose text is `text`, which must be one number of RFC 8259 §6.
    pub fn number(self: *TextWriter, text: []const u8) Error!void {
        return self.whole(.{ .number = .last }, text);
    }

    pub fn unsigned(self: *TextWriter, value: u64) Error!void {
        return self.whole(.{ .unsigned = value }, "");
    }

    pub fn signed(self: *TextWriter, value: i64) Error!void {
        return self.whole(.{ .signed = value }, "");
    }

    /// A fixed-point decimal: `1234.567` for an integer part of 1234, a fraction of 567 and 3
    /// fraction digits.
    pub fn decimal(self: *TextWriter, value: Decimal) Error!void {
        return self.whole(.{ .decimal = value }, "");
    }

    /// The literal name `true` or `false` (RFC 8259 §3).
    pub fn boolean(self: *TextWriter, value: bool) Error!void {
        return self.whole(.{ .boolean = value }, "");
    }

    /// The literal name `null` (RFC 8259 §3).
    pub fn null_literal(self: *TextWriter) Error!void {
        return self.whole(.null, "");
    }

    /// The text, once its last token is written: `output[0..len]`.
    pub fn written(self: *const TextWriter) []const u8 {
        assert(self.encoder.is_done());
        return self.output[0..self.len];
    }
};
