//! The base 64 decoder of RFC 4648 §4 and §5. It takes either alphabet in one pass, says which one
//! the text used, and refuses a text that mixes them. It takes a final quantum with its pad
//! characters or without them (RFC 4648 §3.2), and refuses any octet outside the alphabets,
//! whitespace included (RFC 4648 §3.3), and any final quantum whose unused bits are not zero (RFC
//! 4648 §3.5), so each octet string has one text that decodes to it.
//!
//! It streams (decision 11): a call takes the letters the caller has and writes the octets that
//! fit. Base 64 marks no end of its own, so `piece` says whether `input` holds the text's last
//! letters.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const alphabet_file = @import("alphabet.zig");
const Alphabet = alphabet_file.Alphabet;

/// Which alphabets a text may use.
pub const Accept = enum {
    /// Either alphabet, but one alone in a text.
    either,
    standard,
    url_safe,
};

/// Whether a text's final quantum carries its pad characters.
pub const Padding = enum {
    /// With them or without them (RFC 4648 §3.2 lets the referring specification decide).
    optional,
    /// With them, as RFC 4648 §3.2 requires when no specification says otherwise.
    required,
    /// Without them, as RFC 4648 §5 allows where the length is known.
    refused,
};

pub const DecoderOptions = struct {
    accept: Accept = .either,
    padding: Padding = .optional,
};

/// Whether `input` holds the text's last letters.
pub const Piece = enum { more, last };

pub const Error = error{
    /// An octet in neither alphabet, or in an alphabet `accept` leaves out (RFC 4648 §3.3).
    InvalidCharacter,
    /// A letter of one alphabet alone in a text that used the other's (RFC 4648 §5).
    MixedAlphabets,
    /// A pad character where none may stand, too few of them, or too many, or pad characters
    /// present or absent against `padding` (RFC 4648 §3.2, §4).
    InvalidPadding,
    /// A text whose final quantum holds one letter, which no octet takes (RFC 4648 §4).
    InvalidLength,
    /// A final quantum whose unused bits are not zero (RFC 4648 §3.5).
    NonCanonical,
};

/// Every refusal is of a text RFC 4648 does not allow (decision 11).
pub fn refusal(err: Error) codec.Refusal {
    _ = err;
    return .corrupt;
}

pub const Decoder = struct {
    accept: Accept,
    padding: Padding,
    /// The alphabet whose letters of values 62 and 63 the text used, once one appeared.
    seen: ?Alphabet,
    /// The values of the quantum's letters so far, `held_len` of them, most significant first.
    bits: u32,
    held_len: u8,
    /// The pad characters the final quantum still needs, once its first came.
    pads_left: u8,
    /// The octets of a quantum the output had no room for, `pending_written` of them written: a
    /// group's three, or the final quantum's one or two.
    pending: [constants.group_octets]u8,
    pending_len: u8,
    pending_written: u8,
    part: Part,

    const Part = enum(u8) { letters, padding, after_padding, tail, done };

    /// Starts a text. The decoder copies what it keeps from `options`.
    pub fn init(self: *Decoder, options: DecoderOptions, features: codec.Features) void {
        _ = features;
        self.* = .{
            .accept = options.accept,
            .padding = options.padding,
            .seen = switch (options.accept) {
                .either => null,
                .standard => .standard,
                .url_safe => .url_safe,
            },
            .bits = 0,
            .held_len = 0,
            .pads_left = 0,
            .pending = undefined,
            .pending_len = 0,
            .pending_written = 0,
            .part = .letters,
        };
    }

    /// Ends the decoder. It holds nothing to release.
    pub fn deinit(self: *Decoder) void {
        self.* = undefined;
    }

    /// The alphabet the text used, as far as its letters of values 62 and 63 tell: null while it
    /// used only the letters both alphabets share.
    pub fn alphabet(self: *const Decoder) ?Alphabet {
        return self.seen;
    }

    /// Decodes `input` into `output` (decision 11). After an error the text is lost, and a new one
    /// starts with `init`.
    pub fn decode(self: *Decoder, input: []const u8, output: []u8, piece: Piece) Error!codec.Progress {
        codec.check_entry(input, output);
        assert(self.part != .done);
        var reader = codec.Reader.init(input);
        var writer = codec.Writer.init(output);
        const status = try self.run(&reader, &writer, piece);
        const progress: codec.Progress = .{ .consumed = reader.consumed(), .written = writer.position, .status = status };
        codec.check_progress(input.len, output.len, progress);
        return progress;
    }

    /// Decodes all of `input` as one text into `output`, and returns the octets written.
    pub fn decode_all(self: *Decoder, input: []const u8, output: []u8) (Error || error{NoSpaceLeft})!usize {
        const progress = try self.decode(input, output, .last);
        const whole = codec.whole(progress) catch |err| switch (err) {
            error.NoSpaceLeft => return error.NoSpaceLeft,
            error.Truncated => unreachable,
        };
        return whole.written;
    }

    /// The octets `text` decodes to, from its length and its pad characters alone: the room
    /// `decode_all` needs. It reads no letter, so a text it accepts may still be refused.
    pub fn decoded_len(text: []const u8) Error!usize {
        var letters = text.len;
        var pads: usize = 0;
        while (pads < constants.quantum_letters - constants.one_octet_letters and letters > 0 and
            text[letters - 1] == constants.pad) : (pads += 1) letters -= 1;
        // RFC 4648 §4: pad characters complete a quantum of four.
        if (pads > 0 and text.len % constants.quantum_letters != 0) return error.InvalidPadding;
        const rest = letters % constants.quantum_letters;
        // RFC 4648 §4: a final quantum takes two or three letters, never one.
        if (rest == 1) return error.InvalidLength;
        const whole = letters / constants.quantum_letters * constants.group_octets;
        return if (rest == 0) whole else whole + rest - 1;
    }

    fn run(self: *Decoder, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!codec.Status {
        if (!self.write_pending(writer)) return .needs_room;
        if (self.part == .tail) return self.finish();
        while (reader.remaining_len() > 0) {
            try self.take(reader.take_octet() catch unreachable);
            if (!self.write_pending(writer)) return .needs_room;
        }
        if (piece == .more) return .needs_input;
        try self.end();
        if (!self.write_pending(writer)) return .needs_room;
        return self.finish();
    }

    fn finish(self: *Decoder) codec.Status {
        assert(self.part == .tail);
        assert(self.pending_written == self.pending_len);
        self.part = .done;
        return .done;
    }

    /// Writes what is pending. False when the output filled first.
    fn write_pending(self: *Decoder, writer: *codec.Writer) bool {
        const count = writer.write_partial(self.pending[self.pending_written..self.pending_len]);
        self.pending_written += @intCast(count);
        return self.pending_written == self.pending_len;
    }

    /// Takes one octet of the text.
    fn take(self: *Decoder, octet: u8) Error!void {
        switch (self.part) {
            .letters => if (octet == constants.pad) try self.start_padding() else try self.letter(octet),
            .padding => {
                // RFC 4648 §4: after the first pad character, only the rest of them.
                if (octet != constants.pad) return error.InvalidPadding;
                self.pads_left -= 1;
                if (self.pads_left == 0) self.part = .after_padding;
            },
            // RFC 4648 §4: the pad characters end the text.
            .after_padding => return error.InvalidPadding,
            .tail, .done => unreachable,
        }
    }

    fn letter(self: *Decoder, octet: u8) Error!void {
        const entry = alphabet_file.table[octet];
        // RFC 4648 §3.3: an octet outside the alphabet refuses the text.
        if (entry == alphabet_file.not_a_letter) return error.InvalidCharacter;
        if (entry & alphabet_file.flags_mask != 0) try self.note_alphabet(entry);
        self.bits = self.bits << constants.letter_bits | (entry & alphabet_file.value_mask);
        self.held_len += 1;
        if (self.held_len < constants.quantum_letters) return;
        std.mem.writeInt(u24, &self.pending, @intCast(self.bits), .big);
        self.pending_len = constants.group_octets;
        self.pending_written = 0;
        self.bits = 0;
        self.held_len = 0;
    }

    /// Notes the alphabet a letter of value 62 or 63 belongs to.
    fn note_alphabet(self: *Decoder, entry: u8) Error!void {
        const of: Alphabet = if (entry & alphabet_file.standard_only != 0) .standard else .url_safe;
        if (self.seen) |seen| {
            if (seen == of) return;
            // RFC 4648 §5: the two alphabets are two encodings, and a text is one of them.
            return if (self.accept == .either) error.MixedAlphabets else error.InvalidCharacter;
        }
        self.seen = of;
    }

    fn start_padding(self: *Decoder) Error!void {
        // RFC 4648 §3.2: the caller may refuse pad characters where the length is known.
        if (self.padding == .refused) return error.InvalidPadding;
        // RFC 4648 §4: pad characters follow two or three letters of a quantum, never fewer.
        if (self.held_len < constants.one_octet_letters) return error.InvalidPadding;
        const pads = constants.pads_after(self.held_len);
        try self.form_tail();
        self.pads_left = @intCast(pads - 1);
        self.part = if (self.pads_left == 0) .after_padding else .padding;
    }

    /// Ends the text at the end of the input.
    fn end(self: *Decoder) Error!void {
        switch (self.part) {
            .letters => {
                if (self.held_len == 0) {
                    self.part = .tail;
                    return;
                }
                // RFC 4648 §4: a final quantum of one letter holds no octet.
                if (self.held_len == 1) return error.InvalidLength;
                // RFC 4648 §3.2: the caller may require the pad characters.
                if (self.padding == .required) return error.InvalidPadding;
                try self.form_tail();
            },
            // RFC 4648 §4: a pad character stands for each letter the quantum lacks.
            .padding => return error.InvalidPadding,
            .after_padding => {},
            .tail, .done => unreachable,
        }
        self.part = .tail;
    }

    /// The octets of a final quantum of two or three letters (RFC 4648 §4, cases (2) and (3)).
    fn form_tail(self: *Decoder) Error!void {
        assert(self.held_len == constants.one_octet_letters or self.held_len == constants.two_octet_letters);
        const bits_len = self.held_len * constants.letter_bits;
        const octets = bits_len / constants.octet_bits;
        const unused = bits_len % constants.octet_bits;
        // RFC 4648 §3.5: the bits after the last octet's are zero in the one canonical text.
        if (self.bits & ((@as(u32, 1) << @intCast(unused)) - 1) != 0) return error.NonCanonical;
        const value = self.bits >> @intCast(unused);
        assert(self.pending_written == self.pending_len);
        for (0..octets) |index| {
            const shift = (octets - 1 - index) * constants.octet_bits;
            self.pending[index] = @truncate(value >> @intCast(shift));
        }
        self.pending_len = @intCast(octets);
        self.pending_written = 0;
        self.held_len = 0;
        self.bits = 0;
    }
};
