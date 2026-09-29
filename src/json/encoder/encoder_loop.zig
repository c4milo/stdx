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
const constants = @import("../constants.zig");
const format = @import("../format.zig");
const number_grammar = @import("../number.zig");
const scan = @import("../scan.zig");
const wide = @import("../wide.zig");
const claims_file = @import("../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Kind = encoder_file.Kind;
const Position = encoder_file.Position;
const Piece = encoder_file.Piece;
const Item = @import("encoder_batch.zig").Item;
const loop_string = @import("encoder_loop_string.zig");

/// Writes items from the first on into `output` from `written` on, moves `written` past them, and
/// returns how many it wrote.
pub fn take(encoder: *Encoder, comptime claims: Claims, items: []const Item, output: []u8, written: *usize) usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
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
        codec.check_entry(entry.octets, self.output);
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
        if (piece == .more) return false;
        const run_len = if (claims.encoder_string_vectors) wide.plain_len(self.encoder.level.with(claims), octets) else scan.plain_len_scalar(octets);
        const closing = if (kind == .name) [_]u8{ constants.quotation_mark, constants.name_separator } else [_]u8{constants.quotation_mark};
        const frame = self.frame_of(claims, kind);
        const content_len = if (run_len == octets.len) octets.len else self.escaped(claims, frame, closing.len, octets) orelse return false;
        const body = self.open_body(claims, frame, 1 + content_len + closing.len) orelse return false;
        body[0] = constants.quotation_mark;
        if (run_len == octets.len) scan.copy(body[1..][0..octets.len], octets);
        body[body.len - closing.len ..][0..closing.len].* = closing;
        self.close(claims, kind, frame.ends_text);
        return true;
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
