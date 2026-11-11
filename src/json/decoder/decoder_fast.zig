//! Claim J8 (decision 31): the decoder's next token in one straight line. At the start of a call
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
//! `text_start` does the same for the octets before a text's first token, for a caller that holds
//! the text's start (decision 69): it takes them where they need no verdict, and leaves every
//! other start to the checked path.
//!
//! It reads through the checked reader and writes through the checked writer: each octet the
//! grammar turns on with `take_octet`, and each run counted by a scan of scan.zig or number.zig,
//! taken with `take` and written with `write_first`, which moves a short run with no call
//! (decision 70). For a caller that holds all of its input, `TextReader`, it writes no octet the
//! input already holds: a name's, a string's or a number's octets stay where they lie, unless
//! the walk changed some (decision 74). It changes the state only once the token is whole, and
//! leaves it as the checked path would, field for field, which decoder_fast_test.zig requires
//! after every call.

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
const loop_copy = @import("decoder_loop/decoder_loop_copy.zig");

/// Takes the octets before a text's first token, for a caller that holds the text's start
/// (`TextReader`, decision 69): a sequence's record separators, and the look at the octet after
/// them that shows no byte order mark starts the text. The decoder then stands between tokens, so
/// the text's first token takes `token`. Where the start needs a verdict, it consumes nothing and
/// leaves the state as it was, and the checked path rules: a sequence's text with no separator,
/// an octet that may start a mark, and an input with no octet for the text.
pub inline fn text_start(decoder: *Decoder, reader: *codec.Reader) void {
    assert(decoder.stage == .record_separators or decoder.stage == .byte_order_mark);
    assert(decoder.matched == 0 and decoder.open == .none);
    const start = reader.consumed();
    // RFC 7464 §2.1: a record separator comes before each text of a sequence, and more may follow
    // it. A text with none is the checked path's to refuse.
    if (decoder.stage == .record_separators and skip_record_separators(reader) == 0) return;
    if (reader.take_octet()) |octet| {
        reader.unread(1);
        // RFC 8259 §8.1: no text starts with a byte order mark. An octet that may start one is
        // the checked path's to judge.
        if (octet != constants.byte_order_mark[0]) {
            decoder.stage = .tokens;
            return;
        }
    } else |_| {}
    reader.unread(reader.consumed() - start);
}

/// Takes the record separators at the reader's position, and returns how many it took.
inline fn skip_record_separators(reader: *codec.Reader) usize {
    const len = reader.remaining_len();
    for (0..len) |count| {
        const octet = reader.take_octet() catch unreachable;
        if (octet == constants.record_separator) continue;
        reader.unread(1);
        return count;
    }
    return len;
}

/// Decodes the next token, or returns null with nothing consumed and the state as it was. Where
/// `in_place` is null, a name's, a string's or a number's octets go into the output. Else it gets
/// them, and they stay in the input, or lie in the output where the walk changed some (decision
/// 74). Either way the output must have room for them.
pub inline fn token(decoder: *Decoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer, in_place: ?*[]const u8) ?Outcome {
    assert(decoder.stage == .tokens and decoder.open == .none);
    // Between tokens, the UTF-8 check stands where `start_token` sets it: each continuation octet
    // resets its range, and a string ends only between characters. So a token taken here leaves it
    // as the checked path does.
    assert(std.meta.eql(decoder.utf8, Utf8{}));
    const start = reader.consumed();
    const written = writer.position;
    if (next_token(decoder, claims, reader, writer, in_place)) |outcome| return outcome;
    // Only a token taken whole writes, and changes the state.
    assert(writer.position == written);
    reader.unread(reader.consumed() - start);
    return null;
}

inline fn next_token(decoder: *Decoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer, in_place: ?*[]const u8) ?Outcome {
    _ = decoder_file.skip_whitespace(reader);
    var octet = reader.take_octet() catch return null;
    var expect = decoder.expect;
    if (expect == .separator_or_end or expect == .name_separator) {
        expect = after_separator(decoder, expect, octet) orelse return container_end(decoder, expect, octet);
        _ = decoder_file.skip_whitespace(reader);
        octet = reader.take_octet() catch return null;
    }
    return token_at(decoder, claims, expect, octet, reader, writer, in_place);
}

/// Takes the token `octet` starts where the grammar expects `expect`.
inline fn token_at(decoder: *Decoder, comptime claims: Claims, expect: Expect, octet: u8, reader: *codec.Reader, writer: *codec.Writer, in_place: ?*[]const u8) ?Outcome {
    if (expect == .end_of_text) return null;
    const names = expect == .name or expect == .name_or_end_object;
    if (octet == constants.quotation_mark) return string(decoder, claims, if (names) .name else .string, reader, writer, in_place);
    if (names) return if (octet == constants.end_object and expect == .name_or_end_object) end_container(decoder, .end_object) else null;
    return value(decoder, expect, octet, reader, writer, in_place);
}

/// What the grammar expects after `octet`, when it is the separator `expect` allows, or null.
inline fn after_separator(decoder: *const Decoder, expect: Expect, octet: u8) ?Expect {
    if (expect == .name_separator) return if (octet == constants.name_separator) .value else null;
    if (octet != constants.value_separator) return null;
    return if (decoder.containers.is_object(decoder.depth - 1)) .name else .value;
}

/// The end of the container `octet` closes after one of its values, or null.
inline fn container_end(decoder: *Decoder, expect: Expect, octet: u8) ?Outcome {
    if (expect != .separator_or_end) return null;
    const in_object = decoder.containers.is_object(decoder.depth - 1);
    if (octet == constants.end_object and in_object) return end_container(decoder, .end_object);
    if (octet == constants.end_array and !in_object) return end_container(decoder, .end_array);
    return null;
}

/// Takes a value that is not a string, or the end of the array just opened.
inline fn value(decoder: *Decoder, expect: Expect, octet: u8, reader: *codec.Reader, writer: *codec.Writer, in_place: ?*[]const u8) ?Outcome {
    switch (octet) {
        constants.end_array => return if (expect == .value_or_end_array) end_container(decoder, .end_array) else null,
        constants.begin_object, constants.begin_array => {
            // The checked path refuses a container past the depth limit.
            if (decoder.depth == constants.depth_max) return null;
            return @call(.always_inline, decoder_file.begin_container, .{ decoder, octet }) catch unreachable;
        },
        constants.literal_true[0], constants.literal_false[0], constants.literal_null[0] => return literal(decoder, octet, reader),
        else => {},
    }
    if (!number_grammar.starts_number(octet)) return null;
    reader.unread(1);
    return number(decoder, reader, writer, in_place);
}

/// Takes a name or a string whose octets are a run of plain ASCII the output has room for, and its
/// closing quotation mark.
inline fn string(decoder: *Decoder, comptime claims: Claims, kind: Kind, reader: *codec.Reader, writer: *codec.Writer, in_place: ?*[]const u8) ?Outcome {
    const window = reader.take_partial(writer.room_len());
    reader.unread(window.len);
    const run_len = if (claims.decoder_string_vectors)
        wide.plain_len(decoder.level.with(claims), window)
    else
        scan.plain_len_scalar(window);
    _ = reader.take(run_len) catch unreachable;
    const closing = reader.take_octet() catch return null;
    if (closing != constants.quotation_mark) {
        if (!claims.decoder_line_strings or run_len == window.len) return null;
        reader.unread(run_len + 1);
        return walked(decoder, claims, kind, reader, writer, in_place);
    }
    leave(window, run_len, writer, in_place);
    return string_ended(decoder, kind);
}

/// Claim J16: a name or a string whose plain run stopped at an escape or a non-ASCII octet, its
/// content at the reader's position, through J10's walk, which takes its escapes and its UTF-8
/// (decoder_loop_copy.zig). The walk reads the input and writes the output's room as decision 16
/// lets J10's loop, and leaves the octets past the token's in room the call does not report. Null
/// where the walk leaves the string to the checked path, which names every refusal.
inline fn walked(decoder: *Decoder, comptime claims: Claims, kind: Kind, reader: *codec.Reader, writer: *codec.Writer, in_place: ?*[]const u8) ?Outcome {
    const content = reader.take_partial(reader.remaining_len());
    reader.unread(content.len);
    const room = writer.octets[writer.position..];
    const copied = loop_copy.copy_blocks(claims, decoder.level, content, room, 0) orelse return null;
    // The content and its closing quotation mark.
    _ = reader.take(copied.input_len + 1) catch unreachable;
    const start = writer.position;
    writer.position += copied.output_len;
    assert(writer.position <= writer.octets.len);
    if (in_place) |octets| octets.* = writer.octets[start..writer.position];
    return string_ended(decoder, kind);
}

/// Leaves the first `len` octets of `window`, a token's that the line changes none of: in the
/// output, or, where `in_place` is not null, in the input where they lie (decision 74).
inline fn leave(window: []const u8, len: usize, writer: *codec.Writer, in_place: ?*[]const u8) void {
    assert(len <= window.len and len <= writer.room_len());
    if (in_place) |octets| {
        octets.* = window[0..len];
    } else {
        writer.write_first(window, len) catch unreachable;
    }
}

/// Moves the state past a name or a string taken whole, as the checked path does.
inline fn string_ended(decoder: *Decoder, kind: Kind) Outcome {
    started(decoder, 1, .{});
    if (kind == .name) decoder_file.name_ended(decoder) else decoder_file.value_ended(decoder, kind);
    return .{ .status = .token, .kind = kind };
}

/// Takes a whole number the output has room for, and leaves the octet that ends it unread.
inline fn number(decoder: *Decoder, reader: *codec.Reader, writer: *codec.Writer, in_place: ?*[]const u8) ?Outcome {
    // One octet past the room, so a number that fills the output shows the octet that ends it.
    // The reader's and the writer's steps are inline here: in the caller's loop, LLVM left them
    // calls.
    const window = @call(.always_inline, codec.Reader.take_partial, .{ reader, writer.room_len() +| 1 });
    reader.unread(window.len);
    const ended = @call(.always_inline, number_grammar.ended_in, .{window}) orelse return null;
    if (ended.len > writer.room_len()) return null;
    _ = @call(.always_inline, codec.Reader.take, .{ reader, ended.len }) catch unreachable;
    leave(window, ended.len, writer, in_place);
    started(decoder, 1, ended.number);
    decoder_file.value_ended(decoder, .number);
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
    decoder_file.value_ended(decoder, kind);
    return .{ .status = .token, .kind = kind };
}

/// `decoder_file.end_container`, inline here alone: the checked path calls it too.
inline fn end_container(decoder: *Decoder, kind: Kind) Outcome {
    return @call(.always_inline, decoder_file.end_container, .{ decoder, kind });
}

/// Leaves the fields `Decoder.start_token` sets as the checked path leaves them at the token's end:
/// `matched` counts a literal name's letters, and `number` holds a number's last state. `utf8`
/// stands as `start_token` sets it already (`token`).
inline fn started(decoder: *Decoder, matched: u8, number_state: number_grammar.Number) void {
    decoder.matched = matched;
    decoder.number = number_state;
}
