//! Claim J11: decision 16's JSON encoder token loop. Inside a batch (decision 33) it writes items
//! straight into the output slice, until an item it does not write whole, the end of the text, or
//! the batch's last item. It writes what claim J9's fast path writes: the record separator that
//! starts a sequence's text, the value separator before a value, the token, and the line feed that
//! ends a sequence's text, for a structural character, a name or a string of plain ASCII, a hex
//! string, a number's text that is one whole number, a number it formats, and a literal name. Every
//! other item it leaves to `Encoder.run`, the path one token a call takes, which names every
//! refusal.
//!
//! It checks once that the output holds all an item writes, then stores into the slice directly, as
//! decision 16's table lets it. It copies a name's or a string's octets in moves of 8 or 4 that
//! overlap and stay inside the item's octets, which may end where the caller's memory does
//! (invariant 6). Zig's runtime safety checks stay on (ReleaseSafe), unless the caller turns them
//! off at its call site (decision 35): every function here says so itself, with the claims it
//! takes, as Zig applies `@setRuntimeSafety` to the function that calls it and a function it calls,
//! inline or not, keeps its own. It leaves the state `run` leaves, field for field, which
//! encoder_loop_test.zig requires after every batch.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const format = @import("../../format.zig");
const number_grammar = @import("../../number.zig");
const scan = @import("../../scan.zig");
const wide = @import("../../wide.zig");
const claims_file = @import("../../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const encoder_file = @import("../encoder.zig");
const Encoder = encoder_file.Encoder;
const Kind = encoder_file.Kind;
const Position = encoder_file.Position;
const Piece = encoder_file.Piece;
const Item = @import("../encoder_batch.zig").Item;
const loop_plain = @import("encoder_loop_plain.zig");
const loop_string = @import("encoder_loop_string.zig");

/// Writes items from the first on into `output` from `written` on, moves `written` past them, and
/// returns how many it wrote.
pub fn take(encoder: *Encoder, comptime claims: Claims, items: []const Item, output: []u8, written: *usize) usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    // The loop's steps are inline, and each kind of item that takes octets instantiates the scans'
    // and the copies' generic helpers again.
    @setEvalBranchQuota(constants.token_loop_branch_quota);
    assert(encoder.part == .between_tokens and encoder.pending_len == 0);
    assert(written.* <= output.len);
    var loop: Loop = .{ .encoder = encoder, .output = output, .rest = output[written.*..], .position = encoder.position, .depth = encoder.depth, .sequence = encoder.framing == .sequence };
    // The digits of a number the loop formats. Declared in `item`, its fill of undefined octets in
    // a safe build ran at every item.
    var buffer: format.Buffer = undefined;
    var taken: usize = 0;
    // Each item is read through a pointer, so each kind's path loads only the fields it reads: read
    // whole, an item's value took four loads before its kind was known.
    for (items) |*entry| {
        if (!loop.item(claims, entry, &buffer)) break;
        taken += 1;
        if (loop.position == .text_end) break;
    }
    loop.write_back(claims, if (taken > 0) items[taken - 1] else null);
    written.* = output.len - loop.rest.len;
    return taken;
}

/// The octets an item writes around its own: the record separator that starts a sequence's text,
/// the value separator before a value, and the line feed that ends a sequence's text. Packed into
/// one integer, it stays in a register: as a struct of four bools, it went through the stack at
/// every item.
const Frame = packed struct(u8) {
    record_separator: bool,
    value_separator: bool,
    line_feed: bool,
    ends_text: bool,
    unused: u4 = 0,

    inline fn len(self: Frame) usize {
        return @as(usize, @intFromBool(self.record_separator)) + @intFromBool(self.value_separator) + @intFromBool(self.line_feed);
    }
};

/// The loop keeps the grammar's position and depth in locals, and writes them into the encoder
/// once, at the batch's end, with what `Encoder.run` leaves after the last item: stored at every
/// item, they took loads and stores the checked path reads only once the batch is over. Every value
/// an item keeps live across its octets costs registers the loop runs short of, so the last item's
/// kind and number are found again from the item, once.
const Loop = struct {
    encoder: *Encoder,
    /// The batch's whole output, which each item's octets must not overlap.
    output: []u8,
    /// The output not yet written. Each item writes from its start, and the loop moves past what
    /// it wrote: a slice whose length the compiler knows, where an index into the output cost each
    /// store a check of its own (decision 17).
    rest: []u8,
    position: Position,
    depth: u16,
    /// Whether the text is one of a sequence's.
    sequence: bool,

    /// Writes `entry` whole and returns true, or writes nothing, changes nothing and returns false.
    /// Each kind's path takes its kind at compile time.
    inline fn item(self: *Loop, comptime claims: Claims, entry: *const Item, buffer: *format.Buffer) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        // A switch on the kind alone, each arm reading its own field: a switch on the token loaded
        // its value whole, in four loads, before any arm ran.
        return switch (std.meta.activeTag(entry.token)) {
            .begin_object => self.structural(claims, .begin_object, constants.begin_object, entry),
            .begin_array => self.structural(claims, .begin_array, constants.begin_array, entry),
            .end_object => self.structural(claims, .end_object, constants.end_object, entry),
            .end_array => self.structural(claims, .end_array, constants.end_array, entry),
            .name => self.string(claims, .name, self.octets_of(claims, entry), entry.token.name),
            .string => self.string(claims, .string, self.octets_of(claims, entry), entry.token.string),
            .hex => self.hex(claims, self.octets_of(claims, entry), entry.token.hex),
            .number => self.number_text(claims, self.octets_of(claims, entry), entry.token.number),
            .unsigned => self.text(claims, .unsigned, format.unsigned(buffer, entry.token.unsigned), entry),
            .signed => self.text(claims, .signed, format.signed(buffer, entry.token.signed), entry),
            .decimal => self.text(claims, .decimal, format.decimal(buffer, entry.token.decimal), entry),
            .boolean => self.text(claims, .boolean, if (entry.token.boolean) constants.literal_true else constants.literal_false, entry),
            .null => self.text(claims, .null, constants.literal_null, entry),
        };
    }

    /// The octets of an item whose token takes them, checked against the output they must not
    /// overlap, as each call checks its input (decision 11).
    inline fn octets_of(self: *const Loop, comptime claims: Claims, entry: *const Item) []const u8 {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        assert(!overlap(entry.octets, self.output));
        return entry.octets;
    }

    /// The checks each item's token makes of the caller: it comes where the grammar allows it
    /// (`Encoder.encode`), and with no octets when it takes none. Its kind is known at compile time
    /// here, so each check is a test or two, where one of the token read from the item indexed a
    /// table.
    inline fn check_item(self: *const Loop, comptime claims: Claims, comptime kind: Kind, entry: ?*const Item) void {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        // Seven positions, so the shift of a mask of eight bits holds each.
        const shift: u3 = @truncate(@intFromEnum(self.position));
        assert(encoder_file.positions_allowed(kind) >> shift & 1 != 0);
        if (entry) |taking_none| assert(taking_none.octets.len == 0);
    }

    /// Writes an item's separators before it when the output holds them and the item's own
    /// `len` octets, and returns true; else returns false. The frame is a value of the caller's:
    /// returned as an optional, it went through the stack at every item.
    inline fn open(self: *Loop, comptime claims: Claims, frame: Frame, len: usize) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (frame.len() + len > self.rest.len) return false;
        if (frame.record_separator) self.put(claims, constants.record_separator);
        if (frame.value_separator) self.put(claims, constants.value_separator);
        return true;
    }

    /// `open`, and then the item's own `len` octets as one slice, which the loop moves past: taken
    /// once, it is checked once, and the stores into it at fixed offsets need no check of their own.
    /// Stored an octet at a time into the output, each reloaded the output's length, which the loop
    /// keeps in memory, for a check of its own.
    inline fn open_body(self: *Loop, comptime claims: Claims, frame: Frame, len: usize) ?[]u8 {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (!self.open(claims, frame, len)) return null;
        const body = self.rest[0..len];
        self.rest = self.rest[len..];
        return body;
    }

    /// The octets around an item of `kind` at the loop's position. Only a value can start a text
    /// or end one at depth 0, and only at the text's start; a name follows a value separator after
    /// a member, and any other value after an element.
    inline fn frame_of(self: *const Loop, comptime claims: Claims, comptime kind: Kind) Frame {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        self.check_item(claims, kind, null);
        const position = self.position;
        const ends = kind == .end_object or kind == .end_array;
        const value = !ends and kind != .name;
        const ends_text = if (ends) self.depth == 1 else value and kind != .begin_object and kind != .begin_array and position == .text_start;
        return .{
            .record_separator = value and self.sequence and position == .text_start,
            .value_separator = !ends and position == (if (kind == .name) Position.object_next else .array_next),
            .line_feed = ends_text and self.sequence,
            .ends_text = ends_text,
        };
    }

    /// Writes the line feed after an item that ends a sequence's text, and moves the grammar past
    /// the item as `Encoder.run` does.
    inline fn close(self: *Loop, comptime claims: Claims, comptime kind: Kind, ends_text: bool) void {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (ends_text and self.sequence) self.put(claims, constants.line_feed);
        encoder_file.advance_with(&self.position, &self.depth, &self.encoder.containers, kind);
        assert((self.position == .text_end) == ends_text);
    }

    /// Writes the grammar's position and depth into the encoder, and what `Encoder.run` leaves
    /// after `last`, the last item the loop wrote: its kind, and a number's text's last state.
    /// Inline, as every method here is: one that takes the loop's address out of line keeps all of
    /// its fields in memory.
    inline fn write_back(self: *const Loop, comptime claims: Claims, last: ?Item) void {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        self.encoder.position = self.position;
        self.encoder.depth = self.depth;
        const entry = last orelse return;
        self.encoder.kind = std.meta.activeTag(entry.token);
        self.encoder.ends_text = self.position == .text_end;
        self.encoder.number = if (entry.token == .number) number_grammar.whole_number(entry.octets).? else .{};
        self.encoder.part = if (self.position == .text_end) .done else .between_tokens;
    }

    inline fn structural(self: *Loop, comptime claims: Claims, comptime kind: Kind, octet: u8, entry: *const Item) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        self.check_item(claims, kind, entry);
        // The checked path refuses a container past the depth limit.
        const opens = kind == .begin_object or kind == .begin_array;
        if (opens and self.depth == constants.depth_max) return false;
        const frame = self.frame_of(claims, kind);
        if (!self.open(claims, frame, 1)) return false;
        self.put(claims, octet);
        self.close(claims, kind, frame.ends_text);
        return true;
    }

    /// Writes a name or a string whose octets are plain ASCII, which a string carries as they are
    /// (RFC 8259 §7).
    inline fn string(self: *Loop, comptime claims: Claims, comptime kind: Kind, octets: []const u8, piece: Piece) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (comptime kind != .name) {
            if (self.member_value()) return self.string_at(claims, kind, octets, piece);
        }
        return self.string_at(claims, kind, octets, piece);
    }

    /// Whether the item at hand is a member's value: it has no separator before it and ends no
    /// text, so the copy of a value's path compiled behind this test knows its frame, where the
    /// one path worked it out for every value, a member's or not (design §8 step 18).
    inline fn member_value(self: *const Loop) bool {
        return self.position == .member_value;
    }

    inline fn string_at(self: *Loop, comptime claims: Claims, comptime kind: Kind, octets: []const u8, piece: Piece) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (piece == .more) return false;
        const closing = if (kind == .name) [_]u8{ constants.quotation_mark, constants.name_separator } else [_]u8{constants.quotation_mark};
        const frame = self.frame_of(claims, kind);
        // A string takes its octets as they are at the least, so an output with no room for those
        // holds no form of it.
        const start = @as(usize, @intFromBool(frame.record_separator)) + @intFromBool(frame.value_separator) + 1;
        const around_len = start + closing.len + @intFromBool(frame.line_feed);
        if (self.rest.len < around_len or self.rest.len - around_len < octets.len) return false;
        if (!claims.encoder_string_vectors or octets.len > constants.vector_len) return self.string_long(claims, kind, frame, &closing, start, octets);
        // At most 16 octets, as most names and strings are: copied where the content goes as they
        // are scanned, each loaded once. Scanned and then copied, a name or a string of CLDR's
        // texts loaded its octets twice and chose by its length twice (design §8 step 18).
        if (copy_plain_short(claims, self.rest[start..][0..octets.len], octets)) {
            self.write_around(claims, kind, frame, &closing, start, around_len + octets.len);
            return true;
        }
        const content_len = self.escaped(claims, frame, closing.len, octets) orelse return false;
        self.write_around(claims, kind, frame, &closing, start, around_len + content_len);
        return true;
    }

    /// `string` for a string of more than 16 octets, and for every string with claim J1 off.
    inline fn string_long(self: *Loop, comptime claims: Claims, comptime kind: Kind, frame: Frame, comptime closing: []const u8, start: usize, octets: []const u8) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        var content_len = octets.len;
        if (!copy_plain_long(claims, self.encoder.level, self.rest[start..][0..octets.len], octets)) {
            content_len = self.escaped(claims, frame, closing.len, octets) orelse return false;
        }
        self.write_around(claims, kind, frame, closing, start, start + content_len + closing.len + @intFromBool(frame.line_feed));
        return true;
    }

    /// Writes what stands around a string's content, which starts `start` octets into the output
    /// left: the one separator its frame has and its opening quotation mark before it, and at the
    /// end of the string's `whole_len` octets its `closing` octets and the line feed that ends a
    /// sequence's text. Then moves the loop and the grammar past the string. The caller checked
    /// that the output holds them all, so one slice takes them, checked once.
    inline fn write_around(self: *Loop, comptime claims: Claims, comptime kind: Kind, frame: Frame, comptime closing: []const u8, start: usize, whole_len: usize) void {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        // A record separator starts a text and a value separator follows a value, so a frame has
        // one of them at most.
        assert(!(frame.record_separator and frame.value_separator));
        const whole = self.rest[0..whole_len];
        if (frame.record_separator) whole[0] = constants.record_separator;
        if (frame.value_separator) whole[0] = constants.value_separator;
        whole[start - 1] = constants.quotation_mark;
        const end = whole[whole_len - closing.len - @intFromBool(frame.line_feed) ..];
        end[0..closing.len].* = closing[0..closing.len].*;
        if (frame.line_feed) end[closing.len] = constants.line_feed;
        self.rest = self.rest[whole_len..];
        encoder_file.advance_with(&self.position, &self.depth, &self.encoder.containers, kind);
        assert((self.position == .text_end) == frame.ends_text);
    }

    /// Writes the escaped content of a string that is not all plain ASCII where its body's content
    /// goes, past its frame's separators and its opening quotation mark, with room left for its
    /// `closing_len` octets and a line feed (encoder_loop_string.zig). Returns its length, or null
    /// where the checked path must take the string.
    inline fn escaped(self: *const Loop, comptime claims: Claims, frame: Frame, closing_len: usize, octets: []const u8) ?usize {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (!claims.encoder_string_vectors) return null;
        const around_len = frame.len() + 1 + closing_len;
        if (self.rest.len < around_len) return null;
        const start = @as(usize, @intFromBool(frame.record_separator)) + @intFromBool(frame.value_separator) + 1;
        const room = self.rest[start..][0 .. self.rest.len - around_len];
        return loop_string.copy_escaped_at(claims, self.encoder.level, octets, room);
    }

    inline fn hex(self: *Loop, comptime claims: Claims, octets: []const u8, piece: Piece) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (self.member_value()) return self.hex_at(claims, octets, piece);
        return self.hex_at(claims, octets, piece);
    }

    inline fn hex_at(self: *Loop, comptime claims: Claims, octets: []const u8, piece: Piece) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (piece == .more) return false;
        const digits_len = constants.hex_digits_per_octet * octets.len;
        const frame = self.frame_of(claims, .hex);
        const body = self.open_body(claims, frame, 1 + digits_len + 1) orelse return false;
        body[0] = constants.quotation_mark;
        const digits = body[1..][0..digits_len];
        const taken = if (claims.hex_vectors) wide.hex_len(self.encoder.level.with(claims), octets, digits) else scan.hex_len_scalar(octets, digits);
        assert(taken == octets.len);
        body[body.len - 1] = constants.quotation_mark;
        self.close(claims, .hex, frame.ends_text);
        return true;
    }

    /// Writes a number's text, when it is one whole number (RFC 8259 §6).
    inline fn number_text(self: *Loop, comptime claims: Claims, octets: []const u8, piece: Piece) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (self.member_value()) return self.number_text_at(claims, octets, piece);
        return self.number_text_at(claims, octets, piece);
    }

    inline fn number_text_at(self: *Loop, comptime claims: Claims, octets: []const u8, piece: Piece) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (piece == .more) return false;
        if (@call(.always_inline, number_grammar.whole_number, .{octets}) == null) return false;
        const frame = self.frame_of(claims, .number);
        if (!self.open(claims, frame, octets.len)) return false;
        self.copy(claims, octets);
        self.close(claims, .number, frame.ends_text);
        return true;
    }

    /// Writes a number the encoder formatted, or a literal name.
    inline fn text(self: *Loop, comptime claims: Claims, comptime kind: Kind, octets: []const u8, entry: *const Item) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        if (self.member_value()) return self.text_at(claims, kind, octets, entry);
        return self.text_at(claims, kind, octets, entry);
    }

    inline fn text_at(self: *Loop, comptime claims: Claims, comptime kind: Kind, octets: []const u8, entry: *const Item) bool {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        self.check_item(claims, kind, entry);
        const frame = self.frame_of(claims, kind);
        if (!self.open(claims, frame, octets.len)) return false;
        self.copy(claims, octets);
        self.close(claims, kind, frame.ends_text);
        return true;
    }

    inline fn put(self: *Loop, comptime claims: Claims, octet: u8) void {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        self.rest[0] = octet;
        self.rest = self.rest[1..];
    }

    inline fn copy(self: *Loop, comptime claims: Claims, octets: []const u8) void {
        @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
        scan.copy(self.rest[0..octets.len], octets);
        self.rest = self.rest[octets.len..];
    }
};

/// `codec.overlap`: true when `octets` and `output` share any octet. An octet of the one stands
/// inside the other when its start is fewer octets past the other's start than the other holds,
/// counted with a subtraction that wraps: a slice that starts before the other wraps to more
/// than any slice holds, and a slice with no octet shares none. The sums of `codec.overlap`, each
/// checked for overflow, took 14 instructions of every item with octets (design §8 step 18).
pub inline fn overlap(octets: []const u8, output: []const u8) bool {
    const octets_start = @intFromPtr(octets.ptr);
    const output_start = @intFromPtr(output.ptr);
    const octets_inside = octets.len != 0 and octets_start -% output_start < output.len;
    const output_inside = output.len != 0 and output_start -% octets_start < octets.len;
    return octets_inside or output_inside;
}

/// Whether `octets`, more than 16 with claim J1 on, are all plain ASCII, which a string carries as
/// they are (RFC 8259 §7), and then copied into `content`, of the same length: as they are
/// scanned, each loaded once (encoder_loop_plain.zig); and with claim J1 off scanned an octet at a
/// time, then copied.
pub inline fn copy_plain_long(comptime claims: Claims, level: wide.Level, content: []u8, octets: []const u8) bool {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    if (claims.encoder_string_vectors) return loop_plain.copy_plain(level.with(claims), content, octets) == octets.len;
    if (scan.plain_len_scalar(octets) != octets.len) return false;
    scan.copy(content, octets);
    return true;
}

/// One for each octet a string carries as it is that is ASCII (`scan.is_plain_ascii`), and zero
/// for every other: one load answers an octet, where the compares took four branches.
const plain_ascii = table: {
    var plain: [std.math.maxInt(u8) + 1]u8 = undefined;
    for (&plain, 0..) |*entry, octet| entry.* = @intFromBool(scan.is_plain_ascii(octet));
    break :table plain;
};

/// The octets of the halves `copy_plain_short` joins below 8 octets.
const half_word_len = @sizeOf(u32);

/// Copies `source`, of at most 16 octets, into `destination`, of the same length, as `scan.copy`
/// does, and returns whether every octet is plain ASCII: in two moves of 8 or 4 that overlap and
/// stay inside both (invariant 6), checked as one block of 16 or 8 lanes; and below 4 octets,
/// the first, the last and the middle one, which cover them all.
pub inline fn copy_plain_short(comptime claims: Claims, destination: []u8, source: []const u8) bool {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    const len = source.len;
    assert(destination.len == len);
    assert(len <= constants.vector_len);
    inline for (.{ constants.word_len, half_word_len }) |half| {
        if (len >= half) {
            const first: [half]u8 = source[0..half].*;
            const last: [half]u8 = source[len - half ..][0..half].*;
            destination[0..half].* = first;
            destination[len - half ..][0..half].* = last;
            return !has_stop(halves_joined * half, first ++ last);
        }
    }
    if (len == 0) return true;
    const first = source[0];
    const last = source[len - 1];
    const middle = source[len >> 1];
    destination[0] = first;
    destination[len - 1] = last;
    destination[len >> 1] = middle;
    return plain_ascii[first] & plain_ascii[last] & plain_ascii[middle] != 0;
}

/// The halves `copy_plain_short` joins into a block.
const halves_joined = 2;

/// Whether a lane of `block` holds an octet a string must escape or one that is not ASCII (RFC
/// 8259 §7): below U+0020 or from 0x80 up, which as a signed octet is below 0x20 too, a quotation
/// mark or a reverse solidus. The lanes as one integer answer it, with no count of the first.
inline fn has_stop(comptime width: usize, block: @Vector(width, u8)) bool {
    const signed: @Vector(width, i8) = @bitCast(block);
    const outside = signed < @as(@Vector(width, i8), @splat(constants.unescaped_min));
    const quotation_mark = block == @as(@Vector(width, u8), @splat(constants.quotation_mark));
    const reverse_solidus = block == @as(@Vector(width, u8), @splat(constants.reverse_solidus));
    const stops = @select(u8, outside | quotation_mark | reverse_solidus, @as(@Vector(width, u8), @splat(std.math.maxInt(u8))), @as(@Vector(width, u8), @splat(0)));
    return @as(std.meta.Int(.unsigned, width * @bitSizeOf(u8)), @bitCast(stops)) != 0;
}
