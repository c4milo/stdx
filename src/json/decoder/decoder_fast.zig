//! Claim J8 (decision 30): the decoder's next token in one straight line. At the start of a call
//! between tokens, when the input holds all of the token and the output has room for its octets,
//! it takes whitespace, at most one separator, and then a structural character, a name or a string
//! of plain ASCII, a whole number with the octet that ends it, or a literal name.
//!
//! Every other case returns null having consumed nothing and changed nothing, and the checked path
//! of decoder.zig takes the call from its start: an escape, a non-ASCII octet, a record separator,
//! a token the input cuts, an output without the room, and every refusal. So every check an RFC
//! demands is the checked path's, which also names it.
//!
//! Every function here is inline, so the whole path compiles into the caller's loop whatever else
//! the build calls, and the checked path stays in functions of its own.
//!
//! It reads through the checked reader and writes through the checked writer: each octet the
//! grammar turns on with `read_octet`, and each run counted by a scan of scan.zig or number.zig and
//! taken with `take`. It changes the state only once the token is whole, and leaves it as the
//! checked path would, field for field, which decoder_fast_test.zig requires after every call.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const wide = @import("../wide.zig");
const number_grammar = @import("../number.zig");
const Claims = @import("../claims.zig").Claims;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Expect = decoder_file.Expect;
const Kind = decoder_file.Kind;
const Outcome = decoder_file.Outcome;
const Utf8 = @import("../utf8.zig").Utf8;

/// Decodes the next token, or returns null with nothing consumed and the state as it was.
pub inline fn token(decoder: *Decoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer) ?Outcome {
    assert(decoder.stage == .tokens and decoder.open == .none);
    // Between tokens, the UTF-8 check stands where `start_token` sets it: each continuation octet
    // resets its range, and a string ends only between characters. So a token taken here leaves it
    // as the checked path does.
    assert(std.meta.eql(decoder.utf8, Utf8{}));
    const start = reader.consumed();
    const written = writer.position;
    if (next_token(decoder, claims, reader, writer)) |outcome| return outcome;
    // Only a token taken whole writes, and changes the state.
    assert(writer.position == written);
    reader.unread(reader.consumed() - start);
    return null;
}

inline fn next_token(decoder: *Decoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer) ?Outcome {
    _ = decoder_file.skip_whitespace(reader);
    var octet = reader.read_octet() catch return null;
    var expect = decoder.expect;
    if (expect == .separator_or_end or expect == .name_separator) {
        expect = after_separator(decoder, expect, octet) orelse return container_end(decoder, expect, octet);
        _ = decoder_file.skip_whitespace(reader);
        octet = reader.read_octet() catch return null;
    }
    return token_at(decoder, claims, expect, octet, reader, writer);
}

/// Takes the token `octet` starts where the grammar expects `expect`.
inline fn token_at(decoder: *Decoder, comptime claims: Claims, expect: Expect, octet: u8, reader: *codec.Reader, writer: *codec.Writer) ?Outcome {
    if (expect == .end_of_text) return null;
    const names = expect == .name or expect == .name_or_end_object;
    if (octet == constants.quotation_mark) return string(decoder, claims, if (names) .name else .string, reader, writer);
    if (names) return if (octet == constants.end_object and expect == .name_or_end_object) end_container(decoder, .end_object) else null;
    return value(decoder, expect, octet, reader, writer);
}

/// What the grammar expects after `octet`, when it is the separator `expect` allows, or null.
inline fn after_separator(decoder: *const Decoder, expect: Expect, octet: u8) ?Expect {
    if (expect == .name_separator) return if (octet == constants.name_separator) .value else null;
    if (octet != constants.value_separator) return null;
    return if (decoder.containers.isSet(decoder.depth - 1)) .name else .value;
}

/// The end of the container `octet` closes after one of its values, or null.
inline fn container_end(decoder: *Decoder, expect: Expect, octet: u8) ?Outcome {
    if (expect != .separator_or_end) return null;
    const in_object = decoder.containers.isSet(decoder.depth - 1);
    if (octet == constants.end_object and in_object) return end_container(decoder, .end_object);
    if (octet == constants.end_array and !in_object) return end_container(decoder, .end_array);
    return null;
}

/// Takes a value that is not a string, or the end of the array just opened.
inline fn value(decoder: *Decoder, expect: Expect, octet: u8, reader: *codec.Reader, writer: *codec.Writer) ?Outcome {
    switch (octet) {
        constants.end_array => return if (expect == .value_or_end_array) end_container(decoder, .end_array) else null,
        constants.begin_object, constants.begin_array => {
            // The checked path refuses a container past the depth limit.
            if (decoder.depth == constants.depth_max) return null;
            return @call(.always_inline, Decoder.begin_container, .{ decoder, octet }) catch unreachable;
        },
        constants.literal_true[0], constants.literal_false[0], constants.literal_null[0] => return literal(decoder, octet, reader),
        else => {},
    }
    if (!number_grammar.starts_number(octet)) return null;
    reader.unread(1);
    return number(decoder, reader, writer);
}

/// Takes a name or a string whose octets are a run of plain ASCII the output has room for, and its
/// closing quotation mark.
inline fn string(decoder: *Decoder, comptime claims: Claims, kind: Kind, reader: *codec.Reader, writer: *codec.Writer) ?Outcome {
    const window = reader.take_partial(writer.room_len());
    reader.unread(window.len);
    const run_len = if (claims.decoder_string_vectors)
        wide.plain_len(decoder.level.with(claims), window)
    else
        scan.plain_len_scalar(window);
    const content = reader.take(run_len) catch unreachable;
    const closing = reader.read_octet() catch return null;
    if (closing != constants.quotation_mark) return null;
    writer.write_all(content) catch unreachable;
    started(decoder, 1, .{});
    if (kind == .name) decoder.name_ended() else decoder.value_ended(kind);
    return .{ .status = .token, .kind = kind };
}

/// Takes a whole number the output has room for, and leaves the octet that ends it unread.
inline fn number(decoder: *Decoder, reader: *codec.Reader, writer: *codec.Writer) ?Outcome {
    // One octet past the room, so a number that fills the output shows the octet that ends it.
    // The reader's and the writer's steps are inline here: in the caller's loop, LLVM left them
    // calls.
    const window = @call(.always_inline, codec.Reader.take_partial, .{ reader, writer.room_len() +| 1 });
    reader.unread(window.len);
    const ended = @call(.always_inline, number_grammar.ended_in, .{window}) orelse return null;
    if (ended.len > writer.room_len()) return null;
    const octets = @call(.always_inline, codec.Reader.take, .{ reader, ended.len }) catch unreachable;
    @call(.always_inline, codec.Writer.write_all, .{ writer, octets }) catch unreachable;
    started(decoder, 1, ended.number);
    decoder.value_ended(.number);
    return .{ .status = .token, .kind = .number };
}

/// Takes the rest of the literal name whose first letter the caller read, `first`.
inline fn literal(decoder: *Decoder, first: u8, reader: *codec.Reader) ?Outcome {
    return switch (first) {
        constants.literal_true[0] => literal_of(decoder, .true, constants.literal_true, reader),
        constants.literal_false[0] => literal_of(decoder, .false, constants.literal_false, reader),
        constants.literal_null[0] => literal_of(decoder, .null, constants.literal_null, reader),
        else => unreachable,
    };
}

/// Takes the letters of `text` after its first, a letter at a time, which a text known at
/// comptime unrolls.
inline fn literal_of(decoder: *Decoder, kind: Kind, comptime text: []const u8, reader: *codec.Reader) ?Outcome {
    const rest = @call(.always_inline, codec.Reader.take, .{ reader, text.len - 1 }) catch return null;
    inline for (text[1..], 0..) |letter, index| {
        if (rest[index] != letter) return null;
    }
    started(decoder, text.len, .{});
    decoder.value_ended(kind);
    return .{ .status = .token, .kind = kind };
}

/// `Decoder.end_container`, inline here alone: the checked path calls it too.
inline fn end_container(decoder: *Decoder, kind: Kind) Outcome {
    return @call(.always_inline, Decoder.end_container, .{ decoder, kind });
}

/// Leaves the fields `Decoder.start_token` sets as the checked path leaves them at the token's end:
/// `matched` counts a literal name's letters, and `number` holds a number's last state. `utf8`
/// stands as `start_token` sets it already (`token`).
inline fn started(decoder: *Decoder, matched: u8, number_state: number_grammar.Number) void {
    decoder.matched = matched;
    decoder.number = number_state;
}
