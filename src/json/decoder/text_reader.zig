//! The decoder's whole-buffer helper (decision 11): the tokens of a text whose octets are all in
//! one buffer, each name's, string's and number's octets written into one buffer the caller owns.
//! For a sequence (RFC 7464), `next_text` starts each text in turn.
//!
//! It holds the caller's input and storage for the length of the texts, as `codec.Reader` holds
//! its input, and is built on the streaming call (CLAUDE.md, Non-negotiables). The input ending
//! before a text does is `error.Truncated`, and a name, a string or a number longer than the
//! storage is `error.NoSpaceLeft`.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Kind = decoder_file.Kind;
const Framing = @import("../framing.zig").Framing;

/// What `next` can fail with: a refusal of the text, or the operational errors of decision 11.
pub const Error = decoder_file.Error || codec.Incomplete;

/// A token, with a name's, a string's or a number's octets. They lie in the reader's storage and
/// stay there until the next call.
pub const Item = union(Kind) {
    begin_object,
    end_object,
    begin_array,
    end_array,
    name: []const u8,
    string: []const u8,
    number: []const u8,
    true,
    false,
    null,
};

pub const TextReader = struct {
    decoder: Decoder,
    input: []const u8,
    consumed: usize,
    storage: []u8,
    framing: Framing,
    /// Whether a text has started, and whether the current one has ended.
    started: bool,
    ended: bool,

    /// Reads the texts `input` holds, writing names, strings and numbers into `storage`.
    pub fn init(input: []const u8, storage: []u8, framing: Framing) TextReader {
        var reader: TextReader = .{
            .decoder = undefined,
            .input = input,
            .consumed = 0,
            .storage = storage,
            .framing = framing,
            .started = false,
            .ended = false,
        };
        reader.decoder.init(framing);
        return reader;
    }

    /// Starts the next text. Returns false when the input holds no more: after the one text of a
    /// `text`, and at the input's end in a sequence. Call it before the first `next`.
    pub fn next_text(self: *TextReader) bool {
        if (!self.started) {
            self.started = true;
            return self.framing == .text or self.consumed < self.input.len;
        }
        assert(self.ended);
        if (self.framing == .text or self.consumed == self.input.len) return false;
        self.decoder.init(self.framing);
        self.ended = false;
        return true;
    }

    /// The current text's next token, or null at its end.
    pub fn next(self: *TextReader) Error!?Item {
        assert(self.started and !self.ended);
        const progress = try self.decoder.decode(self.input[self.consumed..], self.storage, .last);
        self.consumed += progress.consumed;
        const octets = self.storage[0..progress.written];
        return switch (progress.status) {
            .token => item(progress.kind.?, octets),
            .done => {
                self.ended = true;
                return null;
            },
            .needs_input => error.Truncated,
            .needs_room => error.NoSpaceLeft,
        };
    }

    /// The octets of the input taken so far: at a text's end, where the next one starts.
    pub fn consumed_len(self: *const TextReader) usize {
        return self.consumed;
    }
};

fn item(kind: Kind, octets: []const u8) Item {
    return switch (kind) {
        .begin_object => .begin_object,
        .end_object => .end_object,
        .begin_array => .begin_array,
        .end_array => .end_array,
        .name => .{ .name = octets },
        .string => .{ .string = octets },
        .number => .{ .number = octets },
        .true => .true,
        .false => .false,
        .null => .null,
    };
}
