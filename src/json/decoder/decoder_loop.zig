//! Claim J10: decision 16's JSON decoder token loop. Inside a batch (decision 33) it takes tokens
//! straight from the input slice into the output slice, with the grammar's expectation in a local,
//! until a token it does not take whole, the end of the input, or the batch's last slot. It takes
//! what claim J8's fast path takes: whitespace, at most one separator, and then a structural
//! character, a name or a string of plain ASCII, a whole number with the octet that ends it, or a
//! literal name. It also takes a sequence's record separator at a text's start, and a text's end.
//! Every other token it leaves, from its first octet of whitespace, to `Decoder.run`, the path one
//! token a call takes, which names every refusal.
//!
//! It reads and writes the slices directly, as decision 16's table lets it: a string's octets go
//! out a block of 16 at a time, and the last store runs past the string's end into room the call
//! does not report written, which only `output[0..written]` means anything in (decision 11). Zig's
//! bounds checks stay on (ReleaseSafe), and each access stays inside its slice by the checks before
//! it. The loop leaves the state `run` leaves, field for field, which decoder_loop_test.zig requires
//! after every batch.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const number_grammar = @import("../number.zig");
const wide = @import("../wide.zig");
const Claims = @import("../claims.zig").Claims;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Expect = decoder_file.Expect;
const Kind = decoder_file.Kind;
const Piece = @import("../framing.zig").Piece;
const Slot = @import("decoder_batch.zig").Slot;

/// Where a batch stands in its input and its output.
pub const Cursor = struct {
    consumed: usize,
    written: usize,
};

/// Takes tokens into `slots` from `cursor` on, moves `cursor` past them, and returns how many
/// slots it filled. At the text's end, in `piece`'s last octets or before the next text of a
/// sequence, it leaves the decoder done. The text's start and end cost qlog's records, 36 tokens a
/// text, about a sixth of their time through `Decoder.run` on the N2 (design §8 step 18).
pub fn take(decoder: *Decoder, comptime claims: Claims, input: []const u8, output: []u8, piece: Piece, cursor: *Cursor, slots: []Slot) usize {
    assert(decoder.stage != .done and decoder.stage != .refused);
    assert(decoder.open == .none and decoder.pending_len == 0);
    assert(cursor.consumed <= input.len and cursor.written <= output.len);
    var loop: Loop = .{ .decoder = decoder, .input = input, .output = output, .position = cursor.consumed, .written = cursor.written, .expect = decoder.expect };
    if (decoder.stage != .tokens and !loop.text_start()) return 0;
    var filled: usize = 0;
    // Each slot is written here, from values in registers: built on the stack by each kind's path
    // and loaded back whole, a slot stalled on its narrower stores (design §8 step 18).
    for (slots) |*slot| {
        const start = loop.written;
        const kind = loop.token(claims) orelse break;
        slot.* = .{ .kind = kind, .ended = true, .start = start, .len = loop.written - start };
        filled += 1;
    }
    // With every slot filled, the checked path asks for slots before it takes the text's end.
    if (filled < slots.len and loop.expect == .end_of_text) loop.text_end(piece);
    decoder.expect = loop.expect;
    if (loop.last) |last| {
        decoder.matched = last.matched;
        decoder.number = last.number;
    }
    cursor.* = .{ .consumed = loop.position, .written = loop.written };
    return filled;
}

/// What `Decoder.start_token` and the token's end leave in the state, for the last name, string,
/// number or literal name the loop took: `matched` counts a literal name's letters, and `number`
/// holds a number's last state.
const Last = struct { matched: u8, number: number_grammar.Number };

const Loop = struct {
    decoder: *Decoder,
    input: []const u8,
    output: []u8,
    position: usize,
    written: usize,
    expect: Expect,
    last: ?Last = null,

    /// Takes the record separator that starts a sequence's text (RFC 7464 §2.1) and passes the check
    /// for a byte order mark (RFC 8259 §8.1), as `Decoder.step` does, when the separator is one and
    /// the octet after it starts neither another nor a byte order mark; for a text, when its first
    /// octet starts no byte order mark. Else it changes nothing, and returns false.
    inline fn text_start(self: *Loop) bool {
        if (self.decoder.matched != 0) return false;
        var first = self.position;
        if (self.decoder.stage == .record_separators) {
            if (self.input.len - first <= 1 or self.input[first] != constants.record_separator) return false;
            first += 1;
            if (self.input[first] == constants.record_separator) return false;
        } else {
            assert(self.decoder.stage == .byte_order_mark);
            if (first == self.input.len) return false;
        }
        // The checked path refuses a byte order mark, and names the refusal.
        if (self.input[first] == constants.byte_order_mark[0]) return false;
        self.position = first;
        self.decoder.stage = .tokens;
        return true;
    }

    /// Takes the text's end after its value (RFC 8259 §2): whitespace, then the end of `piece` when
    /// it is the last, or a sequence's record separator, which starts the next text and which it
    /// leaves (RFC 7464 §2.1). Where `Decoder.step` asks for input or refuses the text, as it does a
    /// sequence's number or literal name that no whitespace follows (RFC 7464 §2.4), it changes
    /// nothing.
    inline fn text_end(self: *Loop, piece: Piece) void {
        const start = self.position;
        const octet = self.skip_whitespace();
        const delimited = self.decoder.value_delimited or self.position > start;
        const sequence = self.decoder.framing == .sequence;
        const ended = if (octet) |after| sequence and after == constants.record_separator else piece == .last;
        if (!ended or (sequence and !delimited)) {
            self.position = start;
            return;
        }
        self.decoder.value_delimited = delimited;
        self.decoder.stage = .done;
    }

    /// Takes the next token, whose octets it writes from the loop's `written` on, and returns its
    /// kind; or leaves the loop as it was and returns null.
    inline fn token(self: *Loop, comptime claims: Claims) ?Kind {
        const position = self.position;
        const expect = self.expect;
        if (self.next(claims)) |kind| return kind;
        self.position = position;
        self.expect = expect;
        return null;
    }

    inline fn next(self: *Loop, comptime claims: Claims) ?Kind {
        var octet = self.skip_whitespace() orelse return null;
        if (self.expect == .separator_or_end or self.expect == .name_separator) {
            self.expect = self.after_separator(octet) orelse return self.container_end(octet);
            self.position += 1;
            octet = self.skip_whitespace() orelse return null;
        }
        return switch (self.expect) {
            .name, .name_or_end_object => self.name(claims, octet),
            .value, .value_or_end_array => self.value(claims, octet),
            .end_of_text => null,
            .separator_or_end, .name_separator => unreachable,
        };
    }

    /// Takes the whitespace at the loop's position (RFC 8259 §2), and returns the octet after it,
    /// which it leaves, or null at the input's end.
    inline fn skip_whitespace(self: *Loop) ?u8 {
        for (self.input[self.position..]) |octet| {
            if (!scan.is_whitespace(octet)) return octet;
            self.position += 1;
        }
        return null;
    }

    /// What the grammar expects after `octet`, when it is the separator the loop expects, or null.
    inline fn after_separator(self: *const Loop, octet: u8) ?Expect {
        if (self.expect == .name_separator) return if (octet == constants.name_separator) .value else null;
        if (octet != constants.value_separator) return null;
        return if (self.decoder.containers.is_object(self.decoder.depth - 1)) .name else .value;
    }

    /// The end of the container `octet` closes after one of its values, or null.
    inline fn container_end(self: *Loop, octet: u8) ?Kind {
        if (self.expect != .separator_or_end) return null;
        const in_object = self.decoder.containers.is_object(self.decoder.depth - 1);
        if (octet == constants.end_object and in_object) return self.end(.end_object);
        if (octet == constants.end_array and !in_object) return self.end(.end_array);
        return null;
    }

    inline fn name(self: *Loop, comptime claims: Claims, octet: u8) ?Kind {
        if (octet == constants.quotation_mark) return self.string(claims, .name);
        if (octet == constants.end_object and self.expect == .name_or_end_object) return self.end(.end_object);
        return null;
    }

    inline fn value(self: *Loop, comptime claims: Claims, octet: u8) ?Kind {
        return switch (octet) {
            constants.quotation_mark => self.string(claims, .string),
            constants.end_array => if (self.expect == .value_or_end_array) self.end(.end_array) else null,
            constants.begin_object, constants.begin_array => self.begin(octet),
            constants.literal_true[0] => self.literal(.true, constants.literal_true),
            constants.literal_false[0] => self.literal(.false, constants.literal_false),
            constants.literal_null[0] => self.literal(.null, constants.literal_null),
            else => if (number_grammar.starts_number(octet)) self.number() else null,
        };
    }

    /// Opens an object or an array below the depth limit, where the checked path refuses one.
    inline fn begin(self: *Loop, octet: u8) ?Kind {
        if (self.decoder.depth == constants.depth_max) return null;
        const object = octet == constants.begin_object;
        self.decoder.containers.set(self.decoder.depth, object);
        self.decoder.depth += 1;
        self.expect = if (object) .name_or_end_object else .value_or_end_array;
        self.position += 1;
        return if (object) .begin_object else .begin_array;
    }

    inline fn end(self: *Loop, kind: Kind) Kind {
        assert(self.decoder.depth > 0 and self.decoder.containers.is_object(self.decoder.depth - 1) == (kind == .end_object));
        self.decoder.depth -= 1;
        self.position += 1;
        self.value_ended(kind);
        return kind;
    }

    /// Takes a name or a string whose octets are a run of plain ASCII and its closing quotation
    /// mark, a block of 16 at a time.
    inline fn string(self: *Loop, comptime claims: Claims, kind: Kind) ?Kind {
        const content_len = (if (claims.decoder_string_vectors) self.copy_blocks(claims) else self.copy_scalar()) orelse return null;
        self.position += 1 + content_len + 1;
        self.written += content_len;
        self.last = .{ .matched = 1, .number = .{} };
        if (kind == .name) self.expect = .name_separator else self.value_ended(kind);
        return kind;
    }

    /// Copies a string's content up to its closing quotation mark, and returns its length, or null
    /// when an octet to escape, a control character, a non-ASCII octet or the end of a slice comes
    /// first. Its first `constants.wide_run_len_min` octets go a block of 16 at a time, and a run
    /// past them to `copy_long`.
    inline fn copy_blocks(self: *Loop, comptime claims: Claims) ?usize {
        const first = self.position + 1;
        var len: usize = 0;
        for (0..constants.wide_run_len_min / constants.vector_len) |_| {
            if (self.input.len - first - len < constants.vector_len) return null;
            if (self.output.len - self.written - len < constants.vector_len) return null;
            const block: @Vector(constants.vector_len, u8) = self.input[first + len ..][0..constants.vector_len].*;
            self.output[self.written + len ..][0..constants.vector_len].* = block;
            if (scan.plain_stop(block)) |lane| {
                return if (self.input[first + len + lane] == constants.quotation_mark) len + lane else null;
            }
            len += constants.vector_len;
        }
        const rest_len = copy_long(self.decoder.level.with(claims), self.input[first + len ..], self.output[self.written + len ..]) orelse return null;
        return len + rest_len;
    }

    /// `copy_blocks` an octet at a time (claim J3 off).
    inline fn copy_scalar(self: *Loop) ?usize {
        const content = self.input[self.position + 1 ..];
        const len = scan.plain_len_scalar(content[0..@min(content.len, self.output.len - self.written)]);
        if (len == content.len or content[len] != constants.quotation_mark) return null;
        @memcpy(self.output[self.written..][0..len], content[0..len]);
        return len;
    }

    /// Takes a whole number and leaves the octet that ends it.
    inline fn number(self: *Loop) ?Kind {
        const ended_number = @call(.always_inline, number_grammar.ended_in, .{self.input[self.position..]}) orelse return null;
        if (self.output.len - self.written < ended_number.len) return null;
        scan.copy(self.output[self.written..][0..ended_number.len], self.input[self.position..][0..ended_number.len]);
        self.position += ended_number.len;
        self.written += ended_number.len;
        self.last = .{ .matched = 1, .number = ended_number.number };
        self.value_ended(.number);
        return .number;
    }

    /// Takes the literal name `text`, whose first letter is at the loop's position.
    inline fn literal(self: *Loop, kind: Kind, comptime text: []const u8) ?Kind {
        if (self.input.len - self.position < text.len) return null;
        inline for (text, 0..) |letter, index| {
            if (self.input[self.position + index] != letter) return null;
        }
        self.position += text.len;
        self.last = .{ .matched = text.len, .number = .{} };
        self.value_ended(kind);
        return kind;
    }

    /// Moves the grammar past a value of `kind` that just ended, as `Decoder.value_ended` does.
    inline fn value_ended(self: *Loop, kind: Kind) void {
        if (self.decoder.depth > 0) {
            self.expect = .separator_or_end;
            return;
        }
        self.expect = .end_of_text;
        self.decoder.value_delimited = switch (kind) {
            .number, .true, .false, .null => false,
            else => true,
        };
    }
};

/// The rest of a string's run past the blocks `copy_blocks` took, from `rest`, its octets after
/// them, into `room`, the output after them: its length when its closing quotation mark follows it
/// in `rest`, or null. It is scanned at the widest vector the caller's features allow (claim J7), in
/// a function of its own as `wide.plain_len` scans it, and copied whole: 16 at a time, the loop ran
/// long hex strings up to 10% slower than the checked path on an AMD EPYC 7763 (design §8 step
/// 18). It takes no `*Loop`, which would keep the loop's fields in memory.
fn copy_long(level: wide.Level, rest: []const u8, room: []u8) ?usize {
    const window = rest[0..@min(rest.len, room.len)];
    const run_len = wide.plain_len(level, window);
    if (run_len == rest.len or rest[run_len] != constants.quotation_mark) return null;
    @memcpy(room[0..run_len], window[0..run_len]);
    return run_len;
}
