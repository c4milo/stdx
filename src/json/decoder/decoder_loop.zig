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

/// The prongs of `Loop.fill`'s switch: the grammar's states, numbered as `Expect` numbers them,
/// and those a prong goes on to: `value_next` and `name_next`, with a slot found for the value or
/// the name, `value_at` and `name_at`, with its first octet found too, and `value_end`, after a
/// value.
const State = enum(u8) {
    separator_or_end,
    name_separator,
    value,
    value_or_end_array,
    name_or_end_object,
    name,
    end_of_text,
    value_next,
    name_next,
    value_at,
    name_at,
    value_end,

    inline fn of(expect: Expect) State {
        return @enumFromInt(@intFromEnum(expect));
    }
};

comptime {
    // Each of the grammar's states is the prong of its name, so `State.of` is one cast.
    for (std.enums.values(Expect)) |expect| {
        assert(std.mem.eql(u8, @tagName(expect), @tagName(State.of(expect))));
    }
}

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
    /// The name or string at the start of `in` that stopped `fill`, when its first block did not
    /// end it: `take` copies it out of line.
    long_string: ?LongString = null,

    /// Fills `slots` from `first` on, and returns the slots filled, up to the token that stopped
    /// it. Each state of the grammar is a prong of one labeled switch, and a prong that takes a
    /// token goes on to the state after it with a jump of its own (`continue :state`), where a
    /// switch at the loop's head tested the state again at every token (design §8 step 18). The
    /// switch's value is the state whose token the loop did not take, with nothing to put back:
    /// each place it stops names its state, where a state kept in a register through the loop
    /// pushed the loop's other values to the stack on x86-64.
    inline fn fill(self: *Loop, comptime claims: Claims, slots: []Slot, first: usize, output: []const u8) usize {
        var index = first;
        // The slot of the token the loop takes next, found once a token, where the loop checks
        // that a slot is left; the first octet of a value or of a name, for `value_at` and
        // `name_at`; and for `value_end`, whether the value is delimited, as
        // `Decoder.value_ended` finds; and the state `value_at` and `name_at` stop in.
        var slot: *Slot = undefined;
        var octet: u8 = undefined;
        var delimited = false;
        var at: Expect = undefined;
        self.expect = state: switch (State.of(self.expect)) {
            .separator_or_end => {
                if (index >= slots.len) break :state .separator_or_end;
                slot = &slots[index];
                if (self.separator_pair(constants.value_separator)) |after| {
                    octet = after;
                    at = if (self.in_object) .name else .value;
                    if (self.in_object) continue :state .name_at;
                    continue :state .value_at;
                }
                octet = self.next_octet() orelse break :state .separator_or_end;
                if (octet == constants.value_separator) {
                    self.in = self.in[1..];
                    if (self.in_object) continue :state .name_next;
                    continue :state .value_next;
                }
                if (octet != (if (self.in_object) constants.end_object else constants.end_array)) break :state .separator_or_end;
                put(slot, &index, self.end(if (self.in_object) .end_object else .end_array), self.written(output), 0);
                delimited = true;
                continue :state .value_end;
            },
            .name_separator => {
                if (index >= slots.len) break :state .name_separator;
                slot = &slots[index];
                if (self.separator_pair(constants.name_separator)) |after| {
                    octet = after;
                    at = .value;
                    continue :state .value_at;
                }
                octet = self.next_octet() orelse break :state .name_separator;
                if (octet != constants.name_separator) break :state .name_separator;
                self.in = self.in[1..];
                continue :state .value_next;
            },
            .value => {
                if (index >= slots.len) break :state .value;
                slot = &slots[index];
                continue :state .value_next;
            },
            .value_or_end_array => {
                if (index >= slots.len) break :state .value_or_end_array;
                slot = &slots[index];
                octet = self.next_octet() orelse break :state .value_or_end_array;
                at = .value_or_end_array;
                if (octet != constants.end_array) continue :state .value_at;
                put(slot, &index, self.end(.end_array), self.written(output), 0);
                delimited = true;
                continue :state .value_end;
            },
            .name_or_end_object => {
                if (index >= slots.len) break :state .name_or_end_object;
                slot = &slots[index];
                octet = self.next_octet() orelse break :state .name_or_end_object;
                at = .name_or_end_object;
                if (octet != constants.end_object) continue :state .name_at;
                put(slot, &index, self.end(.end_object), self.written(output), 0);
                delimited = true;
                continue :state .value_end;
            },
            .name => {
                if (index >= slots.len) break :state .name;
                slot = &slots[index];
                continue :state .name_next;
            },
            .end_of_text => break :state .end_of_text,
            .value_next => {
                at = .value;
                octet = self.next_octet() orelse break :state .value;
                continue :state .value_at;
            },
            .name_next => {
                at = .name;
                octet = self.next_octet() orelse break :state .name;
                continue :state .name_at;
            },
            .name_at => {
                if (octet != constants.quotation_mark) break :state at;
                const start = self.written(output);
                const len = self.string(claims, .name) orelse break :state at;
                put(slot, &index, .name, start, len);
                continue :state .name_separator;
            },
            .value_at => switch (octet) {
                constants.quotation_mark => {
                    const start = self.written(output);
                    const len = self.string(claims, .string) orelse break :state at;
                    put(slot, &index, .string, start, len);
                    delimited = true;
                    continue :state .value_end;
                },
                constants.begin_object => {
                    if (!self.begin(true)) break :state at;
                    put(slot, &index, .begin_object, self.written(output), 0);
                    continue :state .name_or_end_object;
                },
                constants.begin_array => {
                    if (!self.begin(false)) break :state at;
                    put(slot, &index, .begin_array, self.written(output), 0);
                    continue :state .value_or_end_array;
                },
                constants.literal_true[0] => {
                    if (!self.literal(constants.literal_true)) break :state at;
                    put(slot, &index, .true, self.written(output), 0);
                    delimited = false;
                    continue :state .value_end;
                },
                constants.literal_false[0] => {
                    if (!self.literal(constants.literal_false)) break :state at;
                    put(slot, &index, .false, self.written(output), 0);
                    delimited = false;
                    continue :state .value_end;
                },
                constants.literal_null[0] => {
                    if (!self.literal(constants.literal_null)) break :state at;
                    put(slot, &index, .null, self.written(output), 0);
                    delimited = false;
                    continue :state .value_end;
                },
                else => {
                    if (!number_grammar.starts_number(octet)) break :state at;
                    const start = self.written(output);
                    const len = self.number() orelse break :state at;
                    put(slot, &index, .number, start, len);
                    delimited = false;
                    continue :state .value_end;
                },
            },
            .value_end => {
                if (self.depth > 0) continue :state .separator_or_end;
                self.decoder.value_delimited = delimited;
                continue :state .end_of_text;
            },
        };
        return index;
    }

    /// The octets of `output` before `out`, where the next token's go. `out` is the rest of
    /// `output`, which the loop only moves past its start, so the difference never wraps; the
    /// batch's exit checks every slot's octets against the octets written (`check_batch`).
    inline fn written(self: *const Loop, output: []const u8) usize {
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
    /// input's length and of whitespace: about 10 instructions a member on x86-64 (design §8 step
    /// 18).
    inline fn separator_pair(self: *Loop, comptime separator: u8) ?u8 {
        if (self.in.len < 2 or self.in[0] != separator or self.in[1] <= constants.space) return null;
        self.in = self.in[1..];
        return self.in[0];
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

    /// Opens an object or an array below the depth limit, where the checked path refuses one.
    inline fn begin(self: *Loop, comptime object: bool) bool {
        if (self.depth == constants.depth_max) return false;
        self.decoder.containers.set(self.depth, object);
        self.depth += 1;
        self.in_object = object;
        self.in = self.in[1..];
        return true;
    }

    /// Closes the container the loop is in at its end, a token of `kind`, and returns `kind`.
    inline fn end(self: *Loop, kind: Kind) Kind {
        assert(self.depth > 0 and self.in_object == (kind == .end_object));
        assert(self.in_object == self.decoder.containers.is_object(self.depth - 1));
        self.depth -= 1;
        self.in_object = self.depth > 0 and self.decoder.containers.is_object(self.depth - 1);
        self.in = self.in[1..];
        return kind;
    }

    /// Takes a name or a string whose content the loop copies, and its closing quotation mark, and
    /// returns the octets it wrote: a string whose first block of 16 holds its closing quotation
    /// mark with plain ASCII before it. Else it returns null, with `long_string` set for
    /// `copy_blocks` to go on from the octets the block copied and found plain. Inline and with no
    /// call, so the loop's values stay in registers: with the paths that call out inline at every
    /// string, aarch64 stored eight of them to the stack at each one (design §8 step 18).
    inline fn string(self: *Loop, comptime claims: Claims, comptime kind: Kind) ?usize {
        const content = self.in[1..];
        if (!claims.decoder_string_vectors) {
            const copied = self.copy_scalar(content) orelse return null;
            self.in = content[copied.input_len + 1 ..];
            self.out = self.out[copied.output_len..];
            return copied.output_len;
        }
        if (content.len < constants.vector_len or self.out.len < constants.vector_len) return self.leave_long(kind, 0);
        const block: @Vector(constants.vector_len, u8) = content[0..constants.vector_len].*;
        self.out[0..constants.vector_len].* = block;
        const lane = scan.plain_stop(block) orelse return self.second_block(kind, content);
        if (!scan.is_quotation_mark(block, lane)) return self.leave_long(kind, lane);
        self.in = content[lane + 1 ..];
        self.out = self.out[lane..];
        return lane;
    }

    /// `string` on past its first block of plain ASCII, for the second block: qlog's records hold
    /// two strings of 16 to 31 octets each, which took the out-of-line path at 30 instructions
    /// more each (design §8 step 18).
    inline fn second_block(self: *Loop, comptime kind: Kind, content: []const u8) ?usize {
        const blocks_len = 2 * constants.vector_len;
        if (content.len < blocks_len or self.out.len < blocks_len) return self.leave_long(kind, constants.vector_len);
        const block: @Vector(constants.vector_len, u8) = content[constants.vector_len..blocks_len].*;
        self.out[constants.vector_len..blocks_len].* = block;
        const lane = scan.plain_stop(block) orelse return self.leave_long(kind, blocks_len);
        const len = constants.vector_len + lane;
        if (!scan.is_quotation_mark(block, lane)) return self.leave_long(kind, len);
        self.in = content[len + 1 ..];
        self.out = self.out[len..];
        return len;
    }

    /// Leaves the name or string of `kind` at the start of `in` to `copy_blocks`, from the
    /// `head_len` octets of its content its first block copied and found plain: a long string's
    /// first block, copied again, took a 1 KiB hex string 2% more time on the N2 (design §8 step
    /// 18).
    inline fn leave_long(self: *Loop, comptime kind: Kind, head_len: usize) ?usize {
        self.long_string = .{ .kind = kind, .head_len = head_len };
        return null;
    }

    /// The name or string at the start of `in` that `fill` stopped at, copied by `copy_blocks`
    /// from where its first block stopped; or false where the checked path must take it. Inline,
    /// outside the loop of `fill`: on aarch64 qlog's records took 107 instructions a token against
    /// 114 with it out of line, and on x86-64 123 against 128 (design §8 step 18).
    fn take_long_string(self: *Loop, comptime claims: Claims, long: LongString) bool {
        const content = self.in[1..];
        const copied = @call(.always_inline, copy_blocks, .{ claims, self.decoder.level, content, self.out, long.head_len }) orelse return false;
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

    /// `copy_blocks` an octet at a time, for plain ASCII alone (claim J3 off).
    inline fn copy_scalar(self: *Loop, content: []const u8) ?Copied {
        const len = scan.plain_len_scalar(content[0..@min(content.len, self.out.len)]);
        if (len == content.len or content[len] != constants.quotation_mark) return null;
        @memcpy(self.out[0..len], content[0..len]);
        return .{ .input_len = len, .output_len = len };
    }

    /// Takes a whole number and leaves the octet that ends it, and returns its length.
    inline fn number(self: *Loop) ?usize {
        const len = @call(.always_inline, number_grammar.plain_len, .{self.in}) orelse
            (@call(.always_inline, number_grammar.ended_in, .{self.in}) orelse return null).len;
        if (self.out.len < len) return null;
        scan.copy(self.out[0..len], self.in[0..len]);
        self.in = self.in[len..];
        self.out = self.out[len..];
        return len;
    }

    /// Takes the literal name `text`, whose first letter starts the loop's input.
    inline fn literal(self: *Loop, comptime text: []const u8) bool {
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
        self.decoder.value_delimited = switch (kind) {
            .number, .true, .false, .null => false,
            else => true,
        };
    }
};

/// Writes `slot` for a token of `kind` whose octets are `output[start..][0..len]`, and moves
/// `index` past it.
inline fn put(slot: *Slot, index: *usize, kind: Kind, start: usize, len: usize) void {
    slot.* = .{ .kind = kind, .ended = true, .start = start, .len = len };
    index.* += 1;
}

/// A name or string `fill` stopped at: its kind, and the octets of its content its first block
/// copied and found plain.
const LongString = struct { kind: Kind, head_len: usize };

/// Copies a string's `content`, the input after its opening quotation mark, up to its closing
/// one, into `room`, and returns what it took and wrote, or null where the checked path must take
/// it. Its first `constants.wide_run_len_min` octets of plain ASCII go a block of 16 at a time, a
/// run past them to `copy_long`, and one that fewer than 16 octets of input or room leave to
/// `copy_short`. Past its plain ASCII, its escapes and UTF-8 go to decoder_loop_string.zig. It
/// takes no `*Loop`, for the strings `Loop.string` leaves.
fn copy_blocks(comptime claims: Claims, level: wide.Level, content: []const u8, room: []u8, head_len: usize) ?Copied {
    var len: usize = head_len;
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
