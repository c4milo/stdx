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
const Kind = encoder_file.Kind;
const token_loop = @import("encoder_loop/encoder_loop.zig");
const loop_base64 = @import("encoder_loop/encoder_loop_base64.zig");
const loop_member = @import("encoder_loop/encoder_loop_member.zig");
const base64_module = @import("base64");
const constants = @import("../constants.zig");
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
    inline fn whole(self: *TextWriter, comptime kind: Kind, token: Token, octets: []const u8) Error!void {
        if (self.encoder.part == .between_tokens) {
            const item: Encoder.Item = .{ .token = token, .octets = octets };
            var end = self.len;
            if (@call(.always_inline, token_loop.take_one, .{ &self.encoder, Claims{}, kind, &item, self.output, &end })) {
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
        return self.whole(.begin_object, .begin_object, "");
    }

    pub fn end_object(self: *TextWriter) Error!void {
        return self.whole(.end_object, .end_object, "");
    }

    pub fn begin_array(self: *TextWriter) Error!void {
        return self.whole(.begin_array, .begin_array, "");
    }

    pub fn end_array(self: *TextWriter) Error!void {
        return self.whole(.end_array, .end_array, "");
    }

    /// A member's name, `octets` in UTF-8 (RFC 8259 §4, §8.1).
    pub fn name(self: *TextWriter, octets: []const u8) Error!void {
        return self.whole(.name, .{ .name = .last }, octets);
    }

    /// A string of `octets`, in UTF-8 (RFC 8259 §7, §8.1).
    pub fn string(self: *TextWriter, octets: []const u8) Error!void {
        return self.whole(.string, .{ .string = .last }, octets);
    }

    /// A string of two lowercase hexadecimal digits for each of `octets`.
    pub fn hex(self: *TextWriter, octets: []const u8) Error!void {
        return self.whole(.hex, .{ .hex = .last }, octets);
    }

    /// A string of RFC 4648 §4's base 64 letters for `octets`, its last quantum padded (decision
    /// 73). The base64 module's encoder writes them straight into the text, which holds an
    /// ordinary string: a reader decodes its letters with that module's decoder.
    pub fn base64(self: *TextWriter, octets: []const u8) Error!void {
        if (self.encoder.part == .between_tokens) {
            var end = self.len;
            if (@call(.always_inline, loop_base64.take_letters, .{ &self.encoder, Claims{}, octets, self.output, &end })) {
                self.len = end;
                return;
            }
        }
        return self.letters_in_pieces(octets);
    }

    /// `base64` through the checked path, where the output has no room for the whole string: the
    /// letters of `constants.base64_piece_octets` octets at a time, each a piece of one string. The
    /// output then holds what the checked path writes for a string of all the letters, up to the
    /// octet where it stops with `error.NoSpaceLeft`.
    noinline fn letters_in_pieces(self: *TextWriter, octets: []const u8) Error!void {
        var letters: base64_module.Encoder = undefined;
        letters.init(.{}, loop_base64.features_of(self.encoder.level));
        var buffer: [constants.base64_piece_letters]u8 = undefined;
        var consumed: usize = 0;
        for (0..octets.len / constants.base64_piece_octets + 1) |_| {
            const rest = octets[consumed..];
            const piece = rest[0..@min(rest.len, constants.base64_piece_octets)];
            const last = piece.len == rest.len;
            const progress = letters.encode(piece, &buffer, if (last) .finish else .none);
            assert(progress.consumed == piece.len and progress.status != .needs_room);
            consumed += piece.len;
            try self.write(if (last) .{ .string = .last } else .{ .string = .more }, buffer[0..progress.written]);
            if (last) return;
        }
        // Each pass takes a whole piece, and the last pass the rest.
        unreachable;
    }

    /// A number whose text is `text`, which must be one number of RFC 8259 §6.
    pub fn number(self: *TextWriter, text: []const u8) Error!void {
        return self.whole(.number, .{ .number = .last }, text);
    }

    pub fn unsigned(self: *TextWriter, value: u64) Error!void {
        return self.whole(.unsigned, .{ .unsigned = value }, "");
    }

    pub fn signed(self: *TextWriter, value: i64) Error!void {
        return self.whole(.signed, .{ .signed = value }, "");
    }

    /// A fixed-point decimal: `1234.567` for an integer part of 1234, a fraction of 567 and 3
    /// fraction digits.
    pub fn decimal(self: *TextWriter, value: Decimal) Error!void {
        return self.whole(.decimal, .{ .decimal = value }, "");
    }

    /// The literal name `true` or `false` (RFC 8259 §3).
    pub fn boolean(self: *TextWriter, value: bool) Error!void {
        return self.whole(.boolean, .{ .boolean = value }, "");
    }

    /// The literal name `null` (RFC 8259 §3).
    pub fn null_literal(self: *TextWriter) Error!void {
        return self.whole(.null, .null, "");
    }

    /// A member's name and its value in one call (decision 78): `name_octets` as `name` takes
    /// them, then the token `token` of `kind` as its own method takes it. One step of the token
    /// loop writes both, and a member it leaves takes the checked path, which names every refusal.
    inline fn member(self: *TextWriter, comptime kind: Kind, name_octets: []const u8, token: Token, octets: []const u8) Error!void {
        if (self.encoder.part == .between_tokens) {
            const name_item: Encoder.Item = .{ .token = .{ .name = .last }, .octets = name_octets };
            const item: Encoder.Item = .{ .token = token, .octets = octets };
            var end = self.len;
            if (@call(.always_inline, loop_member.take_member, .{ &self.encoder, Claims{}, kind, &name_item, &item, self.output, &end })) {
                self.len = end;
                return;
            }
        }
        return self.member_checked(name_octets, token, octets);
    }

    /// `member` on the checked path alone: the name, then the value.
    noinline fn member_checked(self: *TextWriter, name_octets: []const u8, token: Token, octets: []const u8) Error!void {
        try self.checked(.{ .name = .last }, name_octets);
        return self.checked(token, octets);
    }

    /// A member whose value is an object: its name, then `{` (RFC 8259 §4).
    pub fn member_begin_object(self: *TextWriter, name_octets: []const u8) Error!void {
        return self.member(.begin_object, name_octets, .begin_object, "");
    }

    /// A member whose value is an array: its name, then `[`.
    pub fn member_begin_array(self: *TextWriter, name_octets: []const u8) Error!void {
        return self.member(.begin_array, name_octets, .begin_array, "");
    }

    /// A member whose value is a string of `octets`, as `string` writes it.
    pub fn member_string(self: *TextWriter, name_octets: []const u8, octets: []const u8) Error!void {
        return self.member(.string, name_octets, .{ .string = .last }, octets);
    }

    /// A member whose value is a string of hexadecimal digits, as `hex` writes it.
    pub fn member_hex(self: *TextWriter, name_octets: []const u8, octets: []const u8) Error!void {
        return self.member(.hex, name_octets, .{ .hex = .last }, octets);
    }

    /// A member whose value is a string of base 64 letters, as `base64` writes it.
    pub fn member_base64(self: *TextWriter, name_octets: []const u8, octets: []const u8) Error!void {
        if (self.encoder.part == .between_tokens) {
            const name_item: Encoder.Item = .{ .token = .{ .name = .last }, .octets = name_octets };
            var end = self.len;
            if (@call(.always_inline, loop_base64.take_member_letters, .{ &self.encoder, Claims{}, &name_item, octets, self.output, &end })) {
                self.len = end;
                return;
            }
        }
        try self.checked(.{ .name = .last }, name_octets);
        return self.letters_in_pieces(octets);
    }

    /// A member whose value is a number of the text `text`, as `number` writes it.
    pub fn member_number(self: *TextWriter, name_octets: []const u8, text: []const u8) Error!void {
        return self.member(.number, name_octets, .{ .number = .last }, text);
    }

    pub fn member_unsigned(self: *TextWriter, name_octets: []const u8, value: u64) Error!void {
        return self.member(.unsigned, name_octets, .{ .unsigned = value }, "");
    }

    pub fn member_signed(self: *TextWriter, name_octets: []const u8, value: i64) Error!void {
        return self.member(.signed, name_octets, .{ .signed = value }, "");
    }

    /// A member whose value is a fixed-point decimal, as `decimal` writes it.
    pub fn member_decimal(self: *TextWriter, name_octets: []const u8, value: Decimal) Error!void {
        return self.member(.decimal, name_octets, .{ .decimal = value }, "");
    }

    pub fn member_boolean(self: *TextWriter, name_octets: []const u8, value: bool) Error!void {
        return self.member(.boolean, name_octets, .{ .boolean = value }, "");
    }

    /// A member whose value is the literal name `null`.
    pub fn member_null(self: *TextWriter, name_octets: []const u8) Error!void {
        return self.member(.null, name_octets, .null, "");
    }

    /// The text, once its last token is written: `output[0..len]`.
    pub fn written(self: *const TextWriter) []const u8 {
        assert(self.encoder.is_done());
        return self.output[0..self.len];
    }
};
