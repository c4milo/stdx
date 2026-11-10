//! The decoder's whole-buffer helper (decision 11): the tokens of a text whose octets are all in
//! one buffer, each name's, string's and number's octets written into one buffer the caller owns.
//! For a sequence (RFC 7464), `next_text` starts each text in turn.
//!
//! It holds the caller's input and storage for the length of the texts, as `codec.Reader` holds
//! its input, and is built on the streaming call and on claim J8's straight line, which that call
//! takes (CLAUDE.md, Non-negotiables; decision 69). `next_text` takes a text's start where it
//! needs no verdict, so the line takes the text's first token too. The input ending before a text
//! does is `error.Truncated`, and a name, a string or a number longer than the storage is
//! `error.NoSpaceLeft`.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Kind = decoder_file.Kind;
const fast = @import("decoder_fast.zig");
const Framing = @import("../framing.zig").Framing;
const Claims = @import("../claims.zig").Claims;

pub const TextReader = struct {
    /// What `next` can fail with: a refusal of the text, or the operational errors of decision 11.
    pub const Error = decoder_file.Error || codec.Incomplete;

    /// A token, with a name's, a string's or a number's octets. They lie in the reader's storage
    /// and stay there until the next call.
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

    decoder: Decoder,
    input: []const u8,
    consumed: usize,
    storage: []u8,
    framing: Framing,
    /// The caller's CPU features, which each text's `Decoder.init` takes.
    features: codec.Features,
    /// Whether a text has started, and whether the current one has ended.
    started: bool,
    ended: bool,

    /// Reads the texts `input` holds, writing names, strings and numbers into `storage`, with the
    /// caller's CPU features (`Decoder.init`).
    pub fn init(input: []const u8, storage: []u8, framing: Framing, features: codec.Features) TextReader {
        var reader: TextReader = .{
            .decoder = undefined,
            .input = input,
            .consumed = 0,
            .storage = storage,
            .framing = framing,
            .features = features,
            .started = false,
            .ended = false,
        };
        reader.decoder.init(framing, features);
        return reader;
    }

    /// Starts the next text. Returns false when the input holds no more: after the one text of a
    /// `text`, and at the input's end in a sequence. Call it before the first `next`.
    pub fn next_text(self: *TextReader) bool {
        if (self.started) {
            assert(self.ended);
            if (self.framing == .text or self.consumed == self.input.len) return false;
            self.decoder.init(self.framing, self.features);
            self.ended = false;
        } else {
            self.started = true;
            if (self.framing == .sequence and self.consumed == self.input.len) return false;
        }
        // The text's start, taken here where it needs no verdict, so the text's first token takes
        // claim J8's line in `next` (decision 69). A start the checked path must rule on stays as
        // it is, and the first `next` takes it there.
        var reader: codec.Reader = .{ .octets = self.input, .position = self.consumed };
        fast.text_start(&self.decoder, &reader);
        self.consumed = reader.position;
        return true;
    }

    /// The current text's next token, or null at its end.
    pub fn next(self: *TextReader) Error!?TextReader.Item {
        assert(self.started and !self.ended);
        // Claim J8's straight line, taken here with no pass through the streaming call: the reader
        // holds all the input and all the storage, so it pays for no slice of either, no progress
        // and no status to read back (decision 69). A token the line leaves takes `decode`.
        if (self.decoder.stage == .tokens and self.decoder.open == .none) {
            var reader: codec.Reader = .{ .octets = self.input, .position = self.consumed };
            var writer = codec.Writer.init(self.storage);
            if (fast.token(&self.decoder, .{}, &reader, &writer)) |outcome| {
                // The line takes whole tokens alone, and leaves the text's end to `decode`.
                assert(outcome.status == .token);
                self.consumed = reader.position;
                return item(outcome.kind.?, self.storage[0..writer.position]);
            }
        }
        return self.checked();
    }

    /// `next` through the streaming call, for what claim J8's line leaves: a token with an escape
    /// or a non-ASCII octet, the text's end, a start `next_text` left, and every refusal. `next`
    /// took the line wherever the call takes it, so the call here goes without it: a second try
    /// reads the same octets in the same state, and leaves them again.
    noinline fn checked(self: *TextReader) Error!?TextReader.Item {
        const progress = try @call(.always_inline, Decoder.decode_with, .{ &self.decoder, without_line, self.input[self.consumed..], self.storage, .last });
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

/// The claims of `checked`'s call: every one on but claim J8's line, which `next` takes itself.
const without_line: Claims = .{ .decoder_fast_path = false };

fn item(kind: Kind, octets: []const u8) TextReader.Item {
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
