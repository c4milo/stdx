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
    // The tokens the loop takes with no call, and between their runs each string its first block
    // did not end, copied out of line: with that call inside the loop, aarch64 kept six of the
    // loop's values on the stack across every string (design §8 step 18). Each pass fills a slot
    // at least, or ends.
    var filled: usize = 0;
    for (0..slots.len + 1) |_| {
        filled = loop.fill(claims, slots, filled, output);
        const kind = loop.long_string orelse break;
        loop.long_string = null;
        const room_len = loop.out.len;
        if (loop.take_long_string(claims, kind) == null) break;
        slots[filled] = .{ .kind = kind, .ended = true, .start = output.len - room_len, .len = room_len - loop.out.len };
        filled += 1;
    }
    // With every slot filled, the checked path asks for slots before it takes the text's end.
    if (filled < slots.len and loop.expect == .end_of_text) loop.text_end(piece);
    decoder.expect = loop.expect;
    decoder.depth = loop.depth;
    if (last_value(slots[0..filled], output)) |last| {
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

/// The `Last` of the loop's `slots`, whose octets are in `output`, found from its last slot of a
/// name, string, number or literal name; or null where it holds none, and the decoder keeps its
/// own. Found once a batch, where each token wrote it to the loop's locals.
fn last_value(slots: []const Slot, output: []const u8) ?Last {
    for (0..slots.len) |back| {
        const slot = slots[slots.len - 1 - back];
        switch (slot.kind) {
            .begin_object, .end_object, .begin_array, .end_array => {},
            .name, .string => return .{ .matched = 1, .number = .{} },
            .number => return .{ .matched = 1, .number = number_grammar.whole_number(output[slot.start..][0..slot.len]).? },
            .true => return .{ .matched = constants.literal_true.len, .number = .{} },
            .false => return .{ .matched = constants.literal_false.len, .number = .{} },
            .null => return .{ .matched = constants.literal_null.len, .number = .{} },
        }
    }
    return null;
}

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
    /// The kind of the name or string at the start of `in` that stopped `fill`, when its first
    /// block did not end it: `take` copies it out of line.
    long_string: ?Kind = null,

    /// Fills `slots` from `first` on, each slot written here from values in registers: built on
    /// the stack by each kind's path and loaded back whole, a slot stalled on its narrower stores
    /// (design §8 step 18). Returns the slots filled, up to the token that stopped it.
    inline fn fill(self: *Loop, comptime claims: Claims, slots: []Slot, first: usize, output: []const u8) usize {
        return for (slots[first..], first..) |*slot, index| {
            const room_len = self.out.len;
            const kind = self.step(claims) orelse break index;
            slot.* = .{ .kind = kind, .ended = true, .start = output.len - room_len, .len = room_len - self.out.len };
        } else slots.len;
    }

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

    /// Takes the next token and the separator before it, writes the token's octets at the start of
    /// the loop's `out`, and returns its kind; or returns null where the loop leaves the rest to
    /// `Decoder.run`, with `expect` what the grammar expects there. Each state takes its own
    /// separator: the expectation is switched on once a token, and nothing is put back.
    inline fn step(self: *Loop, comptime claims: Claims) ?Kind {
        return switch (self.expect) {
            .separator_or_end => self.after_value(claims),
            .name_separator => self.after_name(claims),
            .value => self.value(claims),
            .value_or_end_array => self.value_or_end(claims),
            .name => self.name(claims),
            .name_or_end_object => self.name_or_end(claims),
            .end_of_text => null,
        };
    }

    /// The octet past the whitespace at the start of the loop's input (RFC 8259 §2), which it
    /// leaves there; or null at the input's end. Every token's first octet and every separator is
    /// above a space, so text with no whitespace between its tokens takes one compare.
    inline fn next_octet(self: *Loop) ?u8 {
        if (self.in.len == 0) return null;
        const octet = self.in[0];
        if (octet > constants.space) return octet;
        return self.skip_whitespace();
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

    /// After a value in a container: a value separator and the next member's name or element, or
    /// the container's end (RFC 8259 §4, §5).
    inline fn after_value(self: *Loop, comptime claims: Claims) ?Kind {
        const octet = self.next_octet() orelse return null;
        if (octet == constants.value_separator) {
            self.in = self.in[1..];
            if (self.in_object) {
                self.expect = .name;
                return self.name(claims);
            }
            self.expect = .value;
            return self.value(claims);
        }
        if (octet == constants.end_object and self.in_object) return self.end(.end_object);
        if (octet == constants.end_array and !self.in_object) return self.end(.end_array);
        return null;
    }

    /// After a name: its name separator, and the member's value (RFC 8259 §4).
    inline fn after_name(self: *Loop, comptime claims: Claims) ?Kind {
        const octet = self.next_octet() orelse return null;
        if (octet != constants.name_separator) return null;
        self.in = self.in[1..];
        self.expect = .value;
        return self.value(claims);
    }

    inline fn name(self: *Loop, comptime claims: Claims) ?Kind {
        const octet = self.next_octet() orelse return null;
        if (octet != constants.quotation_mark) return null;
        return self.string(claims, .name);
    }

    inline fn name_or_end(self: *Loop, comptime claims: Claims) ?Kind {
        const octet = self.next_octet() orelse return null;
        if (octet == constants.end_object) return self.end(.end_object);
        if (octet != constants.quotation_mark) return null;
        return self.string(claims, .name);
    }

    inline fn value(self: *Loop, comptime claims: Claims) ?Kind {
        const octet = self.next_octet() orelse return null;
        return self.value_of(claims, octet);
    }

    inline fn value_or_end(self: *Loop, comptime claims: Claims) ?Kind {
        const octet = self.next_octet() orelse return null;
        if (octet == constants.end_array) return self.end(.end_array);
        return self.value_of(claims, octet);
    }

    /// Takes the value `octet` starts (RFC 8259 §3).
    inline fn value_of(self: *Loop, comptime claims: Claims, octet: u8) ?Kind {
        return switch (octet) {
            constants.quotation_mark => self.string(claims, .string),
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
        const copied = (if (claims.decoder_string_vectors) first_block(content, self.out) else self.copy_scalar(content)) orelse {
            if (claims.decoder_string_vectors) self.long_string = kind;
            return null;
        };
        return self.string_taken(kind, content, copied);
    }

    /// The name or string at the start of `in` that `fill` stopped at, copied by `copy_blocks`; or
    /// null where the checked path must take it.
    fn take_long_string(self: *Loop, comptime claims: Claims, kind: Kind) ?Kind {
        const content = self.in[1..];
        const copied = copy_blocks(claims, self.decoder.level, content, self.out) orelse return null;
        return self.string_taken(kind, content, copied);
    }

    /// Moves the loop past a name or string whose `content` it `copied`, and past its closing
    /// quotation mark.
    inline fn string_taken(self: *Loop, kind: Kind, content: []const u8, copied: Copied) Kind {
        self.in = content[copied.input_len + 1 ..];
        self.out = self.out[copied.output_len..];
        if (kind == .name) self.expect = .name_separator else self.value_ended(kind);
        return kind;
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
        const len = @call(.always_inline, number_grammar.plain_len, .{self.in}) orelse
            (@call(.always_inline, number_grammar.ended_in, .{self.in}) orelse return null).len;
        if (self.out.len < len) return null;
        scan.copy(self.out[0..len], self.in[0..len]);
        self.in = self.in[len..];
        self.out = self.out[len..];
        self.value_ended(.number);
        return .number;
    }

    /// Takes the literal name `text`, whose first letter starts the loop's input.
    inline fn literal(self: *Loop, kind: Kind, comptime text: []const u8) ?Kind {
        if (self.in.len < text.len) return null;
        if (!std.mem.eql(u8, self.in[0..text.len], text)) return null;
        self.in = self.in[text.len..];
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

/// A string's `content`, the input after its opening quotation mark, copied into `room` when its
/// first block of 16 holds its closing quotation mark with plain ASCII before it: what it took and
/// wrote. Null for every other string, which `copy_blocks` takes. Inline and with no call, so the
/// loop's values stay in registers: with the paths that call out inline at every string, aarch64
/// stored eight of them to the stack at each one (design §8 step 18).
inline fn first_block(content: []const u8, room: []u8) ?Copied {
    if (content.len < constants.vector_len or room.len < constants.vector_len) return null;
    const block: @Vector(constants.vector_len, u8) = content[0..constants.vector_len].*;
    room[0..constants.vector_len].* = block;
    const lane = scan.plain_stop(block) orelse return null;
    if (!scan.is_quotation_mark(block, lane)) return null;
    return .{ .input_len = lane, .output_len = lane };
}

/// Copies a string's `content`, the input after its opening quotation mark, up to its closing
/// one, into `room`, and returns what it took and wrote, or null where the checked path must take
/// it. Its first `constants.wide_run_len_min` octets of plain ASCII go a block of 16 at a time, a
/// run past them to `copy_long`, and one that fewer than 16 octets of input or room leave to
/// `copy_short`. Past its plain ASCII, its escapes and UTF-8 go to decoder_loop_string.zig. Out
/// of line, and taking no `*Loop`, for the strings `first_block` leaves.
noinline fn copy_blocks(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8) ?Copied {
    var len: usize = 0;
    for (0..constants.wide_run_len_min / constants.vector_len) |_| {
        // Each block's slices first: their lengths' test then proves the load and the store in
        // bounds, which a test of the lengths left over did not, and each paid a check again.
        const input_rest = content[len..];
        const output_rest = room[len..];
        if (input_rest.len < constants.vector_len or output_rest.len < constants.vector_len) return copy_short(claims, level, content, room, len);
        const block: @Vector(constants.vector_len, u8) = input_rest[0..constants.vector_len].*;
        output_rest[0..constants.vector_len].* = block;
        if (scan.plain_stop(block)) |lane| {
            if (scan.is_quotation_mark(block, lane)) return .{ .input_len = len + lane, .output_len = len + lane };
            return copy_rest(claims, level, content, room, len + lane);
        }
        len += constants.vector_len;
    }
    const run_len = copy_long(level.with(claims), content[len..], room[len..]);
    return after_run(claims, level, content, room, len + run_len);
}

/// The rest of a run past its first `head_len` octets, when fewer than 16 of input or of room
/// are left: scanned up to the end of either as `scan.plain_len_vector` scans a short run, and
/// copied. Claim J8's fast path took such a string, near the end of the input or of the output,
/// where the loop left it.
inline fn copy_short(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, head_len: usize) ?Copied {
    const rest = content[head_len..];
    const rest_room = room[head_len..];
    const window = rest[0..@min(rest.len, rest_room.len)];
    const run_len = scan.plain_len_vector(constants.vector_len, window);
    scan.copy(rest_room[0..run_len], window[0..run_len]);
    return after_run(claims, level, content, room, head_len + run_len);
}

/// The string whose first `len` octets of content are copied and plain ASCII: whole at its
/// closing quotation mark, and else taken on past them by `copy_rest`.
inline fn after_run(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, len: usize) ?Copied {
    if (len == content.len) return null;
    if (content[len] == constants.quotation_mark) return .{ .input_len = len, .output_len = len };
    return copy_rest(claims, level, content, room, len);
}

/// The string past its first `head_len` octets of content, copied and plain ASCII: its escapes,
/// its UTF-8 and the runs between them (decoder_loop_string.zig).
inline fn copy_rest(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, head_len: usize) ?Copied {
    const rest = loop_string.copy_rest_at(claims, level, content[head_len..], room[head_len..]) orelse return null;
    return .{ .input_len = head_len + rest.input_len, .output_len = head_len + rest.output_len };
}

/// The run of plain ASCII past the blocks `copy_blocks` took, from `rest`, its octets after them,
/// into `room`, the output after them, as far as `room` holds: copied, and its length returned. It
/// is scanned at the widest vector the caller's features allow (claim J7), in a function of its own
/// as `wide.plain_len` scans it, and copied whole: 16 at a time, the loop ran long hex strings up to
/// 10% slower than the checked path on an AMD EPYC 7763 (design §8 step 18). It takes no `*Loop`,
/// which would keep the loop's fields in memory.
fn copy_long(level: wide.Level, rest: []const u8, room: []u8) align(constants.kernel_alignment) usize {
    const window = rest[0..@min(rest.len, room.len)];
    const run_len = wide.plain_len(level, window);
    @memcpy(room[0..run_len], window[0..run_len]);
    return run_len;
}
