//! Claim J10: decision 16's JSON decoder token loop. Inside a batch (decision 33) it takes tokens
//! straight from the input slice into the output slice, walking the grammar
//! (decoder_loop_grammar.zig), until a token it does not take whole, the end of the input, or the
//! batch's last slot. It takes what claim J8's fast path takes: whitespace, a separator, and then a
//! structural character, a name or a string of plain ASCII, a whole number with the octet that ends
//! it, or a literal name. It also takes a sequence's record separator at a text's start, and a
//! text's end. Every other token it leaves to `Decoder.run`, the path one token a call takes, which
//! names every refusal, with the grammar's state where it stopped: past a separator it took, at the
//! token it did not.
//!
//! It reads and writes the slices directly, as decision 16's table lets it: a string's octets go
//! out a block of 16 at a time, or of 32 in the walk past a run's ASCII in the AVX2 variant
//! object, and the last store runs past the string's end into room the call does not report
//! written, which only `output[0..written]` means anything in (decision 11). Zig's
//! bounds checks stay on (ReleaseSafe), and each access stays inside its slice by the checks before
//! it; a token's slot is written through a pointer an assertion tests against the slots' end. The
//! loop leaves the state `run` leaves, field for field, which decoder_loop_test.zig requires after
//! every batch.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const scan = @import("../../scan.zig");
const number_grammar = @import("../../number.zig");
const Claims = @import("../../claims.zig").Claims;
const decoder_file = @import("../decoder.zig");
const Decoder = decoder_file.Decoder;
const Expect = decoder_file.Expect;
const Kind = decoder_file.Kind;
const Piece = @import("../../framing.zig").Piece;
const Slot = @import("../decoder_batch.zig").Slot;
const Copied = @import("decoder_loop_string.zig").Copied;
const copy = @import("decoder_loop_copy.zig");
const grammar = @import("decoder_loop_grammar.zig");
const LongString = copy.LongString;

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
    // The loop's steps are inline, and each place a name or a string starts instantiates scan.zig's
    // vector helpers again.
    @setEvalBranchQuota(constants.token_loop_branch_quota);
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
    // The tokens the walk takes with no call, and between its runs each string its first blocks
    // did not end, copied out of line: with that call inside the walk, aarch64 kept six of the
    // loop's values on the stack across every string (design §8 step 18). Each pass fills a slot
    // at least, or ends, and the walk begins with a slot left.
    var filled: usize = 0;
    while (filled < slots.len) {
        filled = grammar.fill(&loop, claims, slots, filled, output);
        const long = loop.long_string orelse break;
        loop.long_string = null;
        const room_len = loop.out.len;
        if (!loop.take_long_string(claims, long)) break;
        slots[filled] = .{ .kind = long.kind, .ended = true, .start = output.len - room_len, .len = room_len - loop.out.len };
        filled += 1;
        // A string that ends the text's value, as one long string does a text of its own, needs
        // no second pass of the loop to find the text's end.
        if (loop.expect == .end_of_text) break;
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

pub const Loop = struct {
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
    /// The name or string at the start of `in` that stopped the walk, when its first blocks did
    /// not end it: `take` copies it out of line.
    long_string: ?LongString = null,

    /// The octets of `output` before `out`, where the next token's go. `out` is the rest of
    /// `output`, which the loop only moves past its start, so the difference never wraps.
    pub inline fn written(self: *const Loop, output: []const u8) usize {
        return output.len -% self.out.len;
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

    /// The first octet of the token after the separator `separator` that starts the loop's input,
    /// read with it as a pair where no whitespace comes between them (RFC 8259 §2), and the loop
    /// moved past the separator; or null, and nothing moved. Read apart, each paid a test of the
    /// input's length and of whitespace: 4 to 9 instructions a token on qlog's records and CLDR's
    /// texts (design §8 step 18).
    pub inline fn separator_pair(self: *Loop, comptime separator: u8) ?u8 {
        if (self.in.len < constants.separator_pair_len or self.in[0] != separator or self.in[1] <= constants.space) return null;
        self.in = self.in[1..];
        return self.in[0];
    }

    /// The octet past the whitespace at the start of the loop's input (RFC 8259 §2), which it
    /// leaves there; or null at the input's end. Every token's first octet and every separator is
    /// above a space, so text with no whitespace between its tokens takes one compare.
    pub inline fn next_octet(self: *Loop) ?u8 {
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

    /// Opens an object or an array below the depth limit, where the checked path refuses one.
    pub inline fn begin(self: *Loop, comptime object: bool) bool {
        if (self.depth == constants.depth_max) return false;
        self.decoder.containers.set(self.depth, object);
        self.depth += 1;
        self.in_object = object;
        self.in = self.in[1..];
        return true;
    }

    /// Closes the container the loop is in, at its end, a token of `kind`.
    pub inline fn end(self: *Loop, comptime kind: Kind) void {
        assert(self.depth > 0 and self.in_object == (kind == .end_object));
        assert(self.in_object == self.decoder.containers.is_object(self.depth - 1));
        self.depth -= 1;
        self.in_object = self.depth > 0 and self.decoder.containers.is_object(self.depth - 1);
        self.in = self.in[1..];
    }

    /// The name or string at the start of `in` that the walk stopped at, copied by `copy_blocks`
    /// from where its first blocks stopped; or false where the checked path must take it. Inline,
    /// outside the walk: qlog's records took 92 instructions a token on aarch64 against 98 with it
    /// out of line, and 103 against 104 on x86-64 (design §8 step 18).
    fn take_long_string(self: *Loop, comptime claims: Claims, long: LongString) bool {
        const content = self.in[1..];
        const copied = @call(.always_inline, copy.copy_blocks, .{ claims, self.decoder.level, content, self.out, long.head_len }) orelse return false;
        self.string_taken(long.kind, content, copied);
        return true;
    }

    /// Moves the loop past a name or string whose `content` it `copied`, and past its closing
    /// quotation mark.
    inline fn string_taken(self: *Loop, kind: Kind, content: []const u8, copied: Copied) void {
        self.in = content[copied.input_len + 1 ..];
        self.out = self.out[copied.output_len..];
        if (kind == .name) self.expect = .name_separator else self.value_ended(kind);
    }

    /// Takes a whole number and leaves the octet that ends it, and returns its length.
    pub inline fn number(self: *Loop) ?usize {
        const len = @call(.always_inline, number_grammar.plain_len, .{self.in}) orelse
            (@call(.always_inline, number_grammar.ended_in, .{self.in}) orelse return null).len;
        if (self.out.len < len) return null;
        scan.copy(self.out[0..len], self.in[0..len]);
        self.in = self.in[len..];
        self.out = self.out[len..];
        return len;
    }

    /// Takes the literal name `text`, whose first letter starts the loop's input.
    pub inline fn literal(self: *Loop, comptime text: []const u8) bool {
        if (self.in.len < text.len) return false;
        if (!std.mem.eql(u8, self.in[0..text.len], text)) return false;
        self.in = self.in[text.len..];
        return true;
    }

    /// Moves the grammar past a value of `kind` that just ended, as `Decoder.value_ended` does.
    inline fn value_ended(self: *Loop, kind: Kind) void {
        if (self.depth > 0) {
            self.expect = .separator_or_end;
            return;
        }
        self.expect = .end_of_text;
        self.decoder.value_delimited = is_delimited(kind);
    }
};

/// Whether a value of `kind` is delimited, as `Decoder.value_ended` finds: a number or a literal
/// name is not (RFC 7464 §2.4).
pub inline fn is_delimited(kind: Kind) bool {
    return switch (kind) {
        .number, .true, .false, .null => false,
        else => true,
    };
}
