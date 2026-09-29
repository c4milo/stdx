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
//! (invariant 6). Zig's bounds checks stay on (ReleaseSafe). It leaves the state `run` leaves,
//! field for field, which encoder_loop_test.zig requires after every batch.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const format = @import("../format.zig");
const number_grammar = @import("../number.zig");
const scan = @import("../scan.zig");
const wide = @import("../wide.zig");
const Claims = @import("../claims.zig").Claims;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Kind = encoder_file.Kind;
const Piece = encoder_file.Piece;
const Item = @import("encoder_batch.zig").Item;

/// Writes items from the first on into `output` from `written` on, moves `written` past them, and
/// returns how many it wrote.
pub fn take(encoder: *Encoder, comptime claims: Claims, items: []const Item, output: []u8, written: *usize) usize {
    assert(encoder.part == .between_tokens and encoder.pending_len == 0);
    assert(written.* <= output.len);
    var loop: Loop = .{ .encoder = encoder, .output = output, .written = written.* };
    // The digits of a number the loop formats. Declared in `item`, its fill of undefined octets in
    // a safe build ran at every item.
    var buffer: format.Buffer = undefined;
    var taken: usize = 0;
    for (items) |entry| {
        codec.check_entry(entry.octets, output);
        assert(entry.octets.len == 0 or encoder_file.takes_input(entry.token));
        if (!loop.item(claims, entry, &buffer)) break;
        taken += 1;
        if (encoder.part == .done) break;
    }
    written.* = loop.written;
    return taken;
}

/// The octets an item writes around its own: the record separator that starts a sequence's text,
/// the value separator before a value, and the line feed that ends a sequence's text.
const Frame = struct {
    record_separator: bool,
    value_separator: bool,
    line_feed: bool,
    ends_text: bool,

    fn len(self: Frame) usize {
        return @as(usize, @intFromBool(self.record_separator)) + @intFromBool(self.value_separator) + @intFromBool(self.line_feed);
    }
};

const Loop = struct {
    encoder: *Encoder,
    output: []u8,
    written: usize,

    /// Writes `entry` whole and returns true, or writes nothing, changes nothing and returns false.
    inline fn item(self: *Loop, comptime claims: Claims, entry: Item, buffer: *format.Buffer) bool {
        const kind = std.meta.activeTag(entry.token);
        assert(encoder_file.allowed(self.encoder.position, kind));
        return switch (entry.token) {
            .begin_object => self.structural(kind, constants.begin_object),
            .begin_array => self.structural(kind, constants.begin_array),
            .end_object => self.structural(kind, constants.end_object),
            .end_array => self.structural(kind, constants.end_array),
            .name, .string => |piece| self.string(claims, kind, entry.octets, piece),
            .hex => |piece| self.hex(claims, entry.octets, piece),
            .number => |piece| self.number_text(entry.octets, piece),
            .unsigned => |value| self.text(kind, format.unsigned(buffer, value)),
            .signed => |value| self.text(kind, format.signed(buffer, value)),
            .decimal => |value| self.text(kind, format.decimal(buffer, value)),
            .boolean => |truth| self.text(kind, if (truth) constants.literal_true else constants.literal_false),
            .null => self.text(kind, constants.literal_null),
        };
    }

    /// Writes an item's separators before it when the output holds them and the item's own
    /// `len` octets, and returns its frame, or null.
    inline fn open(self: *Loop, kind: Kind, len: usize) ?Frame {
        const position = self.encoder.position;
        const next = position == .object_next or position == .array_next;
        const ends_text = switch (kind) {
            .begin_object, .begin_array, .name => false,
            .end_object, .end_array => self.encoder.depth == 1,
            else => self.encoder.depth == 0,
        };
        const frame: Frame = .{
            .record_separator = self.encoder.framing == .sequence and position == .text_start,
            .value_separator = next and kind != .end_object and kind != .end_array,
            .line_feed = ends_text and self.encoder.framing == .sequence,
            .ends_text = ends_text,
        };
        if (frame.len() + len > self.output.len - self.written) return null;
        if (frame.record_separator) self.put(constants.record_separator);
        if (frame.value_separator) self.put(constants.value_separator);
        return frame;
    }

    /// Writes the line feed after an item that ends a sequence's text, and leaves the state as
    /// `Encoder.run` leaves it after the item's closing.
    inline fn close(self: *Loop, kind: Kind, frame: Frame, number: number_grammar.Number) void {
        if (frame.line_feed) self.put(constants.line_feed);
        @call(.always_inline, Encoder.advance, .{ self.encoder, kind });
        assert(self.encoder.position == .text_end or !frame.ends_text);
        self.encoder.kind = kind;
        self.encoder.ends_text = frame.ends_text;
        self.encoder.number = number;
        self.encoder.part = if (frame.ends_text) .done else .between_tokens;
    }

    inline fn structural(self: *Loop, kind: Kind, octet: u8) bool {
        // The checked path refuses a container past the depth limit.
        const opens = kind == .begin_object or kind == .begin_array;
        if (opens and self.encoder.depth == constants.depth_max) return false;
        const frame = self.open(kind, 1) orelse return false;
        self.put(octet);
        self.close(kind, frame, .{});
        return true;
    }

    /// Writes a name or a string whose octets are plain ASCII, which a string carries as they are
    /// (RFC 8259 §7).
    inline fn string(self: *Loop, comptime claims: Claims, kind: Kind, octets: []const u8, piece: Piece) bool {
        if (piece == .more) return false;
        const run_len = if (claims.encoder_string_vectors) wide.plain_len(self.encoder.level.with(claims), octets) else scan.plain_len_scalar(octets);
        if (run_len != octets.len) return false;
        const closing_len = @as(usize, 1) + @intFromBool(kind == .name);
        const frame = self.open(kind, 1 + octets.len + closing_len) orelse return false;
        self.put(constants.quotation_mark);
        self.copy(octets);
        self.put(constants.quotation_mark);
        if (kind == .name) self.put(constants.name_separator);
        self.close(kind, frame, .{});
        return true;
    }

    inline fn hex(self: *Loop, comptime claims: Claims, octets: []const u8, piece: Piece) bool {
        if (piece == .more) return false;
        const digits_len = constants.hex_digits_per_octet * octets.len;
        const frame = self.open(.hex, 1 + digits_len + 1) orelse return false;
        self.put(constants.quotation_mark);
        const room = self.output[self.written..][0..digits_len];
        const taken = if (claims.hex_vectors) wide.hex_len(self.encoder.level.with(claims), octets, room) else scan.hex_len_scalar(octets, room);
        assert(taken == octets.len);
        self.written += digits_len;
        self.put(constants.quotation_mark);
        self.close(.hex, frame, .{});
        return true;
    }

    /// Writes a number's text, when it is one whole number (RFC 8259 §6).
    inline fn number_text(self: *Loop, octets: []const u8, piece: Piece) bool {
        if (piece == .more) return false;
        const number = @call(.always_inline, number_grammar.whole_number, .{octets}) orelse return false;
        const frame = self.open(.number, octets.len) orelse return false;
        self.copy(octets);
        self.close(.number, frame, number);
        return true;
    }

    /// Writes a number the encoder formatted, or a literal name.
    inline fn text(self: *Loop, kind: Kind, octets: []const u8) bool {
        const frame = self.open(kind, octets.len) orelse return false;
        self.copy(octets);
        self.close(kind, frame, .{});
        return true;
    }

    inline fn put(self: *Loop, octet: u8) void {
        self.output[self.written] = octet;
        self.written += 1;
    }

    /// Copies `octets` in moves of 8 or 4 that overlap, reading nothing past their end, or with
    /// `@memcpy` past 16 of them.
    inline fn copy(self: *Loop, octets: []const u8) void {
        const len = octets.len;
        const destination = self.output[self.written..][0..len];
        self.written += len;
        if (len > constants.vector_len) return @memcpy(destination, octets);
        inline for (.{ constants.word_len, @sizeOf(u32) }) |move_len| {
            if (len >= move_len) {
                destination[0..move_len].* = octets[0..move_len].*;
                destination[len - move_len ..][0..move_len].* = octets[len - move_len ..][0..move_len].*;
                return;
            }
        }
        // One to three octets: the first, the last and the middle one cover them all.
        if (len == 0) return;
        destination[0] = octets[0];
        destination[len - 1] = octets[len - 1];
        destination[len >> 1] = octets[len >> 1];
    }
};
