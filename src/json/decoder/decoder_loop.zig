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
const loop_string = @import("decoder_loop_string.zig");
const Copied = loop_string.Copied;

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
    var loop: Loop = .{
        .decoder = decoder,
        .in = input[cursor.consumed..],
        .out = output[cursor.written..],
        .expect = decoder.expect,
        .depth = decoder.depth,
        .in_object = decoder.depth > 0 and decoder.containers.is_object(decoder.depth - 1),
    };
    if (decoder.stage != .tokens and !loop.text_start()) return 0;
    var filled: usize = 0;
    // Each slot is written here, from values in registers: built on the stack by each kind's path
    // and loaded back whole, a slot stalled on its narrower stores (design §8 step 18).
    for (slots) |*slot| {
        const room_len = loop.out.len;
        const kind = loop.token(claims) orelse break;
        slot.* = .{ .kind = kind, .ended = true, .start = output.len - room_len, .len = room_len - loop.out.len };
        filled += 1;
    }
    // With every slot filled, the checked path asks for slots before it takes the text's end.
    if (filled < slots.len and loop.expect == .end_of_text) loop.text_end(piece);
    decoder.expect = loop.expect;
    decoder.depth = loop.depth;
    if (loop.last) |last| {
        decoder.matched = last.matched;
        decoder.number = last.number;
    }
    cursor.* = .{ .consumed = input.len - loop.in.len, .written = output.len - loop.out.len };
    return filled;
}

/// What `Decoder.start_token` and the token's end leave in the state, for the last name, string,
/// number or literal name the loop took: `matched` counts a literal name's letters, and `number`
/// holds a number's last state.
const Last = struct { matched: u8, number: number_grammar.Number };

const Loop = struct {
    decoder: *Decoder,
    /// The input not yet taken, and the output not yet written. Each token reads and writes from
    /// their starts, and the loop moves past what it took: slices whose lengths the compiler knows.
    /// Counted instead in indices into the whole input and output, each read and store paid a check
    /// of its own, about a fifth of decoding qlog's records (design §8 step 18).
    in: []const u8,
    out: []u8,
    expect: Expect,
    /// The decoder's depth, and whether the container it is in is an object, kept here for the
    /// batch: read from the decoder, they took a load at every separator and container.
    depth: u16,
    in_object: bool,
    last: ?Last = null,

    /// Takes the record separator that starts a sequence's text (RFC 7464 §2.1) and passes the check
    /// for a byte order mark (RFC 8259 §8.1), as `Decoder.step` does, when the separator is one and
    /// the octet after it starts neither another nor a byte order mark; for a text, when its first
    /// octet starts no byte order mark. Else it changes nothing, and returns false.
    inline fn text_start(self: *Loop) bool {
        if (self.decoder.matched != 0) return false;
        var first = self.in;
        if (self.decoder.stage == .record_separators) {
            if (first.len <= 1 or first[0] != constants.record_separator) return false;
            first = first[1..];
            if (first[0] == constants.record_separator) return false;
        } else {
            assert(self.decoder.stage == .byte_order_mark);
            if (first.len == 0) return false;
        }
        // The checked path refuses a byte order mark, and names the refusal.
        if (first[0] == constants.byte_order_mark[0]) return false;
        self.in = first;
        self.decoder.stage = .tokens;
        return true;
    }

    /// Takes the text's end after its value (RFC 8259 §2): whitespace, then the end of `piece` when
    /// it is the last, or a sequence's record separator, which starts the next text and which it
    /// leaves (RFC 7464 §2.1). Where `Decoder.step` asks for input or refuses the text, as it does a
    /// sequence's number or literal name that no whitespace follows (RFC 7464 §2.4), it changes
    /// nothing.
    inline fn text_end(self: *Loop, piece: Piece) void {
        const before = self.in;
        const octet = self.skip_whitespace();
        const delimited = self.decoder.value_delimited or self.in.len < before.len;
        const sequence = self.decoder.framing == .sequence;
        const ended = if (octet) |after| sequence and after == constants.record_separator else piece == .last;
        if (!ended or (sequence and !delimited)) {
            self.in = before;
            return;
        }
        self.decoder.value_delimited = delimited;
        self.decoder.stage = .done;
    }

    /// Takes the next token, whose octets it writes at the start of the loop's `out`, and returns
    /// its kind; or leaves the loop as it was and returns null.
    inline fn token(self: *Loop, comptime claims: Claims) ?Kind {
        const in = self.in;
        const expect = self.expect;
        if (self.next(claims)) |kind| return kind;
        self.in = in;
        self.expect = expect;
        return null;
    }

    inline fn next(self: *Loop, comptime claims: Claims) ?Kind {
        var octet = self.skip_whitespace() orelse return null;
        if (self.expect == .separator_or_end or self.expect == .name_separator) {
            self.expect = self.after_separator(octet) orelse return self.container_end(octet);
            self.in = self.in[1..];
            octet = self.skip_whitespace() orelse return null;
        }
        return switch (self.expect) {
            .name, .name_or_end_object => self.name(claims, octet),
            .value, .value_or_end_array => self.value(claims, octet),
            .end_of_text => null,
            .separator_or_end, .name_separator => unreachable,
        };
    }

    /// Takes the whitespace at the start of the loop's input (RFC 8259 §2), and returns the octet
    /// after it, which it leaves, or null at the input's end.
    inline fn skip_whitespace(self: *Loop) ?u8 {
        for (self.in, 0..) |octet, index| {
            if (!scan.is_whitespace(octet)) {
                self.in = self.in[index..];
                return octet;
            }
        }
        self.in = self.in[self.in.len..];
        return null;
    }

    /// What the grammar expects after `octet`, when it is the separator the loop expects, or null.
    inline fn after_separator(self: *const Loop, octet: u8) ?Expect {
        if (self.expect == .name_separator) return if (octet == constants.name_separator) .value else null;
        if (octet != constants.value_separator) return null;
        return if (self.in_object) .name else .value;
    }

    /// The end of the container `octet` closes after one of its values, or null.
    inline fn container_end(self: *Loop, octet: u8) ?Kind {
        if (self.expect != .separator_or_end) return null;
        const in_object = self.in_object;
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
        if (self.depth == constants.depth_max) return null;
        const object = octet == constants.begin_object;
        self.decoder.containers.set(self.depth, object);
        self.depth += 1;
        self.in_object = object;
        self.expect = if (object) .name_or_end_object else .value_or_end_array;
        self.in = self.in[1..];
        return if (object) .begin_object else .begin_array;
    }

    inline fn end(self: *Loop, kind: Kind) Kind {
        assert(self.depth > 0 and self.in_object == (kind == .end_object));
        assert(self.in_object == self.decoder.containers.is_object(self.depth - 1));
        self.depth -= 1;
        self.in_object = self.depth > 0 and self.decoder.containers.is_object(self.depth - 1);
        self.in = self.in[1..];
        self.value_ended(kind);
        return kind;
    }

    /// Takes a name or a string whose content the loop copies, and its closing quotation mark.
    inline fn string(self: *Loop, comptime claims: Claims, kind: Kind) ?Kind {
        const content = self.in[1..];
        const copied = (if (claims.decoder_string_vectors) self.copy_blocks(claims, content) else self.copy_scalar(content)) orelse return null;
        self.in = content[copied.input_len + 1 ..];
        self.out = self.out[copied.output_len..];
        self.last = .{ .matched = 1, .number = .{} };
        if (kind == .name) self.expect = .name_separator else self.value_ended(kind);
        return kind;
    }

    /// Copies a string's `content`, the input after its opening quotation mark, up to its closing
    /// one, and returns what it took and wrote, or null where the checked path must take it. Its
    /// first `constants.wide_run_len_min` octets of plain ASCII go a block of 16 at a time, a run
    /// past them to `copy_long`, and one that fewer than 16 octets of input or room leave to
    /// `copy_short`. Past its plain ASCII, its escapes and UTF-8 go to decoder_loop_string.zig.
    inline fn copy_blocks(self: *Loop, comptime claims: Claims, content: []const u8) ?Copied {
        var len: usize = 0;
        for (0..constants.wide_run_len_min / constants.vector_len) |_| {
            // Each block's slices first: their lengths' test then proves the load and the store in
            // bounds, which a test of the lengths left over did not, and each paid a check again.
            const input_rest = content[len..];
            const output_rest = self.out[len..];
            if (input_rest.len < constants.vector_len or output_rest.len < constants.vector_len) return self.copy_short(claims, content, len);
            const block: @Vector(constants.vector_len, u8) = input_rest[0..constants.vector_len].*;
            output_rest[0..constants.vector_len].* = block;
            if (scan.plain_stop(block)) |lane| {
                if (scan.is_quotation_mark(block, lane)) return .{ .input_len = len + lane, .output_len = len + lane };
                return self.copy_rest(claims, content, len + lane);
            }
            len += constants.vector_len;
        }
        const run_len = copy_long(self.decoder.level.with(claims), content[len..], self.out[len..]);
        return self.after_run(claims, content, len + run_len);
    }

    /// The rest of a run past its first `head_len` octets, when fewer than 16 of input or of room
    /// are left: scanned up to the end of either as `scan.plain_len_vector` scans a short run, and
    /// copied. Claim J8's fast path took such a string, near the end of the input or of the output,
    /// where the loop left it.
    inline fn copy_short(self: *Loop, comptime claims: Claims, content: []const u8, head_len: usize) ?Copied {
        const rest = content[head_len..];
        const room = self.out[head_len..];
        const window = rest[0..@min(rest.len, room.len)];
        const run_len = scan.plain_len_vector(constants.vector_len, window);
        scan.copy(room[0..run_len], window[0..run_len]);
        return self.after_run(claims, content, head_len + run_len);
    }

    /// The string whose first `len` octets of content are copied and plain ASCII: whole at its
    /// closing quotation mark, and else taken on past them by `copy_rest`.
    inline fn after_run(self: *Loop, comptime claims: Claims, content: []const u8, len: usize) ?Copied {
        if (len == content.len) return null;
        if (content[len] == constants.quotation_mark) return .{ .input_len = len, .output_len = len };
        return self.copy_rest(claims, content, len);
    }

    /// The string past its first `head_len` octets of content, copied and plain ASCII: its escapes,
    /// its UTF-8 and the runs between them (decoder_loop_string.zig).
    inline fn copy_rest(self: *Loop, comptime claims: Claims, content: []const u8, head_len: usize) ?Copied {
        const rest = loop_string.copy_rest_at(claims, self.decoder.level, content[head_len..], self.out[head_len..]) orelse return null;
        return .{ .input_len = head_len + rest.input_len, .output_len = head_len + rest.output_len };
    }

    /// `copy_blocks` an octet at a time, for plain ASCII alone (claim J3 off).
    inline fn copy_scalar(self: *Loop, content: []const u8) ?Copied {
        const len = scan.plain_len_scalar(content[0..@min(content.len, self.out.len)]);
        if (len == content.len or content[len] != constants.quotation_mark) return null;
        @memcpy(self.out[0..len], content[0..len]);
        return .{ .input_len = len, .output_len = len };
    }

    /// Takes a whole number and leaves the octet that ends it.
    inline fn number(self: *Loop) ?Kind {
        const ended_number = @call(.always_inline, number_grammar.ended_in, .{self.in}) orelse return null;
        if (self.out.len < ended_number.len) return null;
        scan.copy(self.out[0..ended_number.len], self.in[0..ended_number.len]);
        self.in = self.in[ended_number.len..];
        self.out = self.out[ended_number.len..];
        self.last = .{ .matched = 1, .number = ended_number.number };
        self.value_ended(.number);
        return .number;
    }

    /// Takes the literal name `text`, whose first letter starts the loop's input.
    inline fn literal(self: *Loop, kind: Kind, comptime text: []const u8) ?Kind {
        if (self.in.len < text.len) return null;
        if (!std.mem.eql(u8, self.in[0..text.len], text)) return null;
        self.in = self.in[text.len..];
        self.last = .{ .matched = text.len, .number = .{} };
        self.value_ended(kind);
        return kind;
    }

    /// Moves the grammar past a value of `kind` that just ended, as `Decoder.value_ended` does.
    inline fn value_ended(self: *Loop, kind: Kind) void {
        if (self.depth > 0) {
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

/// The run of plain ASCII past the blocks `copy_blocks` took, from `rest`, its octets after them,
/// into `room`, the output after them, as far as `room` holds: copied, and its length returned. It
/// is scanned at the widest vector the caller's features allow (claim J7), in a function of its own
/// as `wide.plain_len` scans it, and copied whole: 16 at a time, the loop ran long hex strings up to
/// 10% slower than the checked path on an AMD EPYC 7763 (design §8 step 18). It takes no `*Loop`,
/// which would keep the loop's fields in memory.
fn copy_long(level: wide.Level, rest: []const u8, room: []u8) usize {
    const window = rest[0..@min(rest.len, room.len)];
    const run_len = wide.plain_len(level, window);
    @memcpy(room[0..run_len], window[0..run_len]);
    return run_len;
}
