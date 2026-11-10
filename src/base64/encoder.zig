//! The base 64 encoder of RFC 4648 §4 and §5: each group of three octets becomes four letters, and a
//! final group of one or two octets becomes two or three letters and, when the caller asks for
//! them, the pad characters (RFC 4648 §3.2, §4).
//!
//! It streams (decision 11): a call takes the octets the caller has and writes the letters that
//! fit, holding back the one or two octets of a group not yet whole. `finish` ends the text. A
//! `flush` writes every whole group and holds the rest, because a group of fewer than three octets
//! ends a text (RFC 4648 §4), so no letter can stand for it before the text ends.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const alphabet_file = @import("alphabet.zig");
const Alphabet = alphabet_file.Alphabet;
const fast = @import("fast.zig");

/// The fast path a call may take: decision 16's row for the encoder's whole groups. The checked
/// path, with it off, is the reference.
pub const Claims = struct {
    whole_groups: bool = true,
};

pub const EncoderOptions = struct {
    alphabet: Alphabet = .standard,
    /// Whether a final group of one or two octets ends with its pad characters. RFC 4648 §3.2
    /// requires them unless the specification that refers to it says otherwise.
    padding: bool = true,
};

pub const Encoder = struct {
    letters: *const [constants.alphabet_len]u8,
    alphabet: Alphabet,
    /// Whether the CPU has AVX2, whose variant object's kernels the fast path then calls.
    wide: bool,
    pairs: *const alphabet_file.PairTable,
    padding: bool,
    /// The octets of a group not yet whole, `held_len` of them.
    held: [constants.group_octets - 1]u8,
    held_len: u8,
    /// The letters of a quantum the output had no room for, `pending_written` of them written:
    /// a group's, or the final quantum's once `finish` came.
    pending: [constants.quantum_letters]u8,
    pending_len: u8,
    pending_written: u8,
    part: Part,

    const Part = enum(u8) { groups, tail, done };

    /// Starts a text. The encoder copies what it keeps from `options`.
    pub fn init(self: *Encoder, options: EncoderOptions, features: codec.Features) void {
        self.* = .{
            .wide = fast.has_kernels and features.avx2,
            .letters = alphabet_file.letters(options.alphabet),
            .alphabet = options.alphabet,
            .pairs = alphabet_file.pair_letters(options.alphabet),
            .padding = options.padding,
            .held = undefined,
            .held_len = 0,
            .pending = undefined,
            .pending_len = 0,
            .pending_written = 0,
            .part = .groups,
        };
    }

    /// Ends the encoder. It holds nothing to release.
    pub fn deinit(self: *Encoder) void {
        self.* = undefined;
    }

    /// Encodes `input` into `output` (decision 11). `finish` says no input follows this call's.
    pub fn encode(self: *Encoder, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
        return self.encode_with(.{}, input, output, flush);
    }

    /// `encode`, with the claims the tests switch.
    pub fn encode_with(self: *Encoder, comptime claims: Claims, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
        codec.check_entry(input, output);
        assert(self.part != .done);
        assert(self.part == .groups or input.len == 0);
        var reader = codec.Reader.init(input);
        var writer = codec.Writer.init(output);
        const status = self.run(claims, &reader, &writer, flush);
        const progress: codec.Progress = .{ .consumed = reader.consumed(), .written = writer.position, .status = status };
        codec.check_progress(input.len, output.len, progress);
        return progress;
    }

    /// Encodes all of `input` into `output` as one text, and returns the letters written.
    pub fn encode_all(self: *Encoder, input: []const u8, output: []u8) error{NoSpaceLeft}!usize {
        const progress = self.encode(input, output, .finish);
        const whole = codec.whole(progress) catch |err| switch (err) {
            error.NoSpaceLeft => return error.NoSpaceLeft,
            error.Truncated => unreachable,
        };
        assert(whole.consumed == input.len);
        return whole.written;
    }

    /// The letters, pad characters included when `padding`, of a text of `input_len` octets.
    pub fn encoded_len(input_len: usize, padding: bool) usize {
        const groups = input_len / constants.group_octets;
        const rest = input_len % constants.group_octets;
        const whole = groups * constants.quantum_letters;
        if (rest == 0) return whole;
        if (padding) return whole + constants.quantum_letters;
        return whole + rest + 1;
    }

    fn run(self: *Encoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer, flush: codec.Flush) codec.Status {
        if (!self.write_pending(writer)) return .needs_room;
        if (self.part == .groups) {
            if (!self.complete_held(reader, writer)) return .needs_room;
            if (!self.write_groups(claims, reader, writer)) return .needs_room;
            self.hold(reader);
            if (flush != .finish) return .needs_input;
            self.start_tail();
            if (!self.write_pending(writer)) return .needs_room;
        }
        assert(self.part == .tail);
        self.part = .done;
        return .done;
    }

    /// Completes the group the octets held start, once the input gives the rest. False when the
    /// output had no room for all of its letters.
    fn complete_held(self: *Encoder, reader: *codec.Reader, writer: *codec.Writer) bool {
        if (self.held_len == 0) return true;
        const missing = constants.group_octets - self.held_len;
        if (reader.remaining_len() < missing) return true;
        var group: [constants.group_octets]u8 = undefined;
        @memcpy(group[0..self.held_len], self.held[0..self.held_len]);
        const rest = reader.take(missing) catch unreachable;
        @memcpy(group[self.held_len..], rest);
        self.held_len = 0;
        return self.write_quantum(self.quantum(group), writer);
    }

    /// Writes the whole groups of the input, the last one in part when the output has no room for
    /// all of its letters. False when the output filled first.
    fn write_groups(self: *Encoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer) bool {
        if (self.held_len != 0) return true;
        if (claims.whole_groups) self.fast_groups(reader, writer);
        const by_input = reader.remaining_len() / constants.group_octets;
        const by_room = writer.room_len() / constants.quantum_letters;
        for (0..@min(by_input, by_room)) |_| {
            const group = (reader.take(constants.group_octets) catch unreachable)[0..constants.group_octets].*;
            writer.write_all(&self.quantum(group)) catch unreachable;
        }
        if (by_input <= by_room) return true;
        const group = (reader.take(constants.group_octets) catch unreachable)[0..constants.group_octets].*;
        return self.write_quantum(self.quantum(group), writer);
    }

    /// Decision 16's row: the whole groups that fit, through fast.zig.
    fn fast_groups(self: *Encoder, reader: *codec.Reader, writer: *codec.Writer) void {
        const rest = reader.take_partial(reader.remaining_len());
        const count = fast.encode_groups(self.alphabet, self.wide, self.pairs, rest, writer.octets[writer.position..]);
        reader.unread(rest.len - count * constants.group_octets);
        writer.position += count * constants.quantum_letters;
    }

    /// Writes the letters of `letters` that fit, and keeps the rest pending. False when some are
    /// left.
    fn write_quantum(self: *Encoder, letters: [constants.quantum_letters]u8, writer: *codec.Writer) bool {
        assert(self.pending_written == self.pending_len);
        self.pending = letters;
        self.pending_len = constants.quantum_letters;
        self.pending_written = 0;
        return self.write_pending(writer);
    }

    /// Writes what is pending. False when the output filled first.
    fn write_pending(self: *Encoder, writer: *codec.Writer) bool {
        if (self.pending_written == self.pending_len) return true;
        const count = writer.write_partial(self.pending[self.pending_written..self.pending_len]);
        self.pending_written += @intCast(count);
        return self.pending_written == self.pending_len;
    }

    /// Holds the octets of a group the input does not complete.
    fn hold(self: *Encoder, reader: *codec.Reader) void {
        const rest = reader.remaining_len();
        if (rest == 0) return;
        assert(self.held_len + rest < constants.group_octets);
        for (reader.take(rest) catch unreachable) |octet| {
            self.held[self.held_len] = octet;
            self.held_len += 1;
        }
    }

    /// Forms the final quantum from the octets held (RFC 4648 §4, cases (2) and (3)): zero bits
    /// added on the right (RFC 4648 §3.5), then the pad characters when the caller wants them.
    fn start_tail(self: *Encoder) void {
        assert(self.part == .groups);
        self.part = .tail;
        if (self.held_len == 0) return;
        var group: [constants.group_octets]u8 = @splat(0);
        @memcpy(group[0..self.held_len], self.held[0..self.held_len]);
        self.pending = self.quantum(group);
        const letters_used: u8 = self.held_len + 1;
        self.pending_len = if (self.padding) constants.quantum_letters else letters_used;
        self.pending_written = 0;
        if (self.padding) @memset(self.pending[letters_used..], constants.pad);
        self.held_len = 0;
    }

    /// The four letters of one group of three octets, most significant bit first (RFC 4648 §4):
    /// two lookups of two letters each.
    fn quantum(self: *const Encoder, group: [constants.group_octets]u8) [constants.quantum_letters]u8 {
        const bits = std.mem.readInt(u24, &group, .big);
        const high = self.pairs[bits >> alphabet_file.pair_bits];
        const low = self.pairs[@as(u12, @truncate(bits))];
        return high ++ low;
    }
};
