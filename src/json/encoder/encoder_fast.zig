//! Claim J9 (decision 30): the encoder's whole token in one straight line. At the start of a
//! token, when the call's input holds all of its octets and the output has room for every octet it
//! writes, the encoder writes them without holding any in `pending`: the record separator that
//! starts a sequence's text, the value separator before the token, the token, and the line feed
//! that ends a sequence's text (RFC 7464 §2.2).
//!
//! It writes a structural character, a name or a string of plain ASCII, a hex string, a number's
//! text that is one whole number, a number it formats, and a literal name. Every other case returns
//! null having consumed nothing, written nothing and changed nothing, and the checked path of
//! encoder.zig takes the call from its start: a name or a string with an octet to escape or a
//! non-ASCII one, a token whose octets go on in a later call, an output without the room, and every
//! refusal. So every check an RFC demands is the checked path's, which also names it.
//!
//! It leaves the state the checked path leaves, field for field, which encoder_fast_test.zig
//! requires after every call. Every function here is inline, so the whole path compiles into the
//! caller's loop whatever else the build calls.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const format = @import("../format.zig");
const scan = @import("../scan.zig");
const wide = @import("../wide.zig");
const number_grammar = @import("../number.zig");
const Claims = @import("../claims.zig").Claims;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Token = encoder_file.Token;
const Kind = encoder_file.Kind;
const content = @import("encoder_content.zig");
const Utf8 = @import("../utf8.zig").Utf8;

/// What a token writes between the octets that frame it. The octets of one or two are written one
/// at a time, so a copy of a few octets calls no `memcpy`.
const Body = struct {
    /// A structural character, or the quotation mark that opens a string.
    opening: ?u8 = null,
    /// A number the encoder formats, or a literal name.
    text: []const u8 = "",
    /// The call's input, written as it is, or as hex digits.
    content_len: usize = 0,
    hex: bool = false,
    closing: Closing = .none,
    /// The machine after a number's text.
    number: number_grammar.Number = .{},

    fn len(self: Body) usize {
        const content_octets = if (self.hex) constants.hex_digits_per_octet * self.content_len else self.content_len;
        return @as(usize, @intFromBool(self.opening != null)) + self.text.len + content_octets + self.closing.len();
    }
};

/// The octets a string closes with: its quotation mark, and a name's separator after a name's.
const Closing = enum {
    none,
    string,
    name,

    /// The quotation mark of a name or a string, and the separator after a name's (`write_body`).
    fn len(self: Closing) usize {
        return @as(usize, @intFromBool(self != .none)) + @intFromBool(self == .name);
    }
};

/// The octets a token writes around its body: the record separator that starts a sequence's
/// text, the value separator before a value, and the line feed that ends a sequence's text.
const Frame = struct {
    record_separator: bool,
    value_separator: bool,
    line_feed: bool,

    inline fn of(encoder: *const Encoder, kind: Kind, ends_text: bool) Frame {
        const next = encoder.position == .object_next or encoder.position == .array_next;
        return .{
            .record_separator = encoder.framing == .sequence and encoder.position == .text_start,
            .value_separator = next and kind != .end_object and kind != .end_array,
            .line_feed = ends_text and encoder.framing == .sequence,
        };
    }

    fn len(self: Frame) usize {
        return @as(usize, @intFromBool(self.record_separator)) + @intFromBool(self.value_separator) + @intFromBool(self.line_feed);
    }
};

/// Writes `value` whole, or returns null with nothing consumed, nothing written and the state as it
/// was.
pub inline fn token(encoder: *Encoder, comptime claims: Claims, value: Token, reader: *codec.Reader, writer: *codec.Writer) ?codec.Status {
    assert(encoder.part == .between_tokens and encoder.pending_len == 0);
    // Between tokens, the UTF-8 check stands where `Encoder.open` sets it: each continuation octet
    // resets its range, and a string ends only between characters.
    assert(std.meta.eql(encoder.utf8, Utf8{}));
    const kind = std.meta.activeTag(value);
    assert(encoder_file.allowed(encoder.position, kind));
    var buffer: format.Buffer = undefined;
    const body = body_of(encoder, claims, value, reader, &buffer) orelse return null;
    const ends_text = ends_text_after(encoder, kind);
    const frame: Frame = .of(encoder, kind, ends_text);
    if (frame.len() + body.len() > writer.room_len()) return null;
    if (frame.record_separator) writer.write_octet(constants.record_separator) catch unreachable;
    if (frame.value_separator) writer.write_octet(constants.value_separator) catch unreachable;
    write_body(claims, encoder.level, body, reader, writer);
    if (frame.line_feed) writer.write_octet(constants.line_feed) catch unreachable;
    ended(encoder, kind, ends_text, body.number);
    return if (ends_text) .done else .needs_input;
}

/// What `value` writes, when the call holds all of it, or null.
inline fn body_of(encoder: *const Encoder, comptime claims: Claims, value: Token, reader: *codec.Reader, buffer: *format.Buffer) ?Body {
    return switch (value) {
        .begin_object, .begin_array, .end_object, .end_array => structural_body(encoder, value),
        .name, .string, .hex, .number => content_body(claims, encoder.level, value, reader),
        .unsigned => |number| .{ .text = format.unsigned(buffer, number) },
        .signed => |number| .{ .text = format.signed(buffer, number) },
        .decimal => |number| .{ .text = format.decimal(buffer, number) },
        .boolean => |truth| .{ .text = if (truth) constants.literal_true else constants.literal_false },
        .null => .{ .text = constants.literal_null },
    };
}

/// A structural character, or null for a container past the depth limit, which the checked path
/// refuses.
inline fn structural_body(encoder: *const Encoder, value: Token) ?Body {
    const opening: u8 = switch (value) {
        .begin_object => constants.begin_object,
        .begin_array => constants.begin_array,
        .end_object => constants.end_object,
        .end_array => constants.end_array,
        else => unreachable,
    };
    const opens = value == .begin_object or value == .begin_array;
    if (opens and encoder.depth == constants.depth_max) return null;
    return .{ .opening = opening };
}

/// A token whose octets are the call's input, when the call holds all of them.
inline fn content_body(comptime claims: Claims, level: wide.Level, value: Token, reader: *codec.Reader) ?Body {
    return switch (value) {
        .name, .string => |piece| .{
            .opening = constants.quotation_mark,
            .content_len = plain_input_len(claims, level, piece, reader) orelse return null,
            .closing = if (value == .name) .name else .string,
        },
        .hex => |piece| if (piece == .more) null else .{ .opening = constants.quotation_mark, .content_len = reader.remaining_len(), .hex = true, .closing = .string },
        .number => |piece| number_body(piece, reader),
        else => unreachable,
    };
}

/// The length of a name's or a string's octets, when the call holds all of them and they are plain
/// ASCII, which a string carries as it is (RFC 8259 §7), or null.
inline fn plain_input_len(comptime claims: Claims, level: wide.Level, piece: encoder_file.Piece, reader: *codec.Reader) ?usize {
    if (piece == .more) return null;
    const input = reader.take_partial(reader.remaining_len());
    reader.unread(input.len);
    const run_len = if (claims.encoder_string_vectors)
        wide.plain_len(level.with(claims), input)
    else
        scan.plain_len_scalar(input);
    return if (run_len == input.len) input.len else null;
}

/// A number's text written as it is, when the call holds all of it and it is one whole number.
inline fn number_body(piece: encoder_file.Piece, reader: *codec.Reader) ?Body {
    if (piece == .more) return null;
    const input = reader.take_partial(reader.remaining_len());
    reader.unread(input.len);
    const number = @call(.always_inline, number_grammar.whole_number, .{input}) orelse return null;
    return .{ .content_len = input.len, .number = number };
}

/// True when a token of `kind` ends the text: a value at depth 0, or the end of the outermost
/// container.
inline fn ends_text_after(encoder: *const Encoder, kind: Kind) bool {
    return switch (kind) {
        .begin_object, .begin_array, .name => false,
        .end_object, .end_array => encoder.depth == 1,
        else => encoder.depth == 0,
    };
}

inline fn write_body(comptime claims: Claims, level: wide.Level, body: Body, reader: *codec.Reader, writer: *codec.Writer) void {
    if (body.opening) |opening| writer.write_octet(opening) catch unreachable;
    if (body.text.len > 0) writer.write_all(body.text) catch unreachable;
    write_content(claims, level, body, reader, writer);
    if (body.closing != .none) writer.write_octet(constants.quotation_mark) catch unreachable;
    if (body.closing == .name) writer.write_octet(constants.name_separator) catch unreachable;
}

/// Writes the call's input as it is, or as hex digits.
inline fn write_content(comptime claims: Claims, level: wide.Level, body: Body, reader: *codec.Reader, writer: *codec.Writer) void {
    if (body.hex) {
        const taken = content.hex_run(claims, level, reader, writer);
        assert(taken == body.content_len);
    } else if (body.content_len > 0) {
        writer.write_all(reader.take(body.content_len) catch unreachable) catch unreachable;
    }
}

/// Leaves the state as the checked path leaves it after `kind`'s closing: `Encoder.open` moved the
/// grammar past it, the content left `number` at the number's last state, and `finish` ended the
/// token or the text. `utf8` stands as `open` sets it already (`token`).
inline fn ended(encoder: *Encoder, kind: Kind, ends_text: bool, number: number_grammar.Number) void {
    // Inline here alone: the checked path's `open` calls it too, and a call a token cost the
    // fast path a sixth of its time on the N2 (design §8 step 17).
    @call(.always_inline, Encoder.advance, .{ encoder, kind });
    assert(encoder.position == .text_end or !ends_text);
    encoder.kind = kind;
    encoder.ends_text = ends_text;
    encoder.number = number;
    encoder.part = if (ends_text) .done else .between_tokens;
}
