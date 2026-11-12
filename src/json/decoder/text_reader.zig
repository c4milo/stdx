//! The decoder's whole-buffer helper (decision 11): the tokens of a text whose octets are all in
//! one buffer. A name's, a string's or a number's octets that the text holds as they are stay in
//! that buffer, where claim J10's loop or claim J8's line takes the token. Other octets go into a
//! storage buffer the caller owns (decision 74). For a sequence (RFC 7464), `next_text` starts
//! each text in turn.
//!
//! It holds the caller's input and storage for the length of the texts, as `codec.Reader` holds
//! its input. It is built on the streaming call and on the paths that call takes (CLAUDE.md,
//! Non-negotiables). Claim J10's loop takes tokens ahead into a queue of items, their octets in
//! place, and `next` hands them out one a call (decision 76). A token the loop leaves takes claim
//! J8's straight line, then the checked path (decision 69). `next_text` takes a text's start where
//! it needs no verdict. The input ending before a text does is `error.Truncated`, and a name, a
//! string or a number longer than the storage is `error.NoSpaceLeft`, wherever its octets lie.
//!
//! A `TextReader` is a plain value: a copy reads on from where the original stood, and the
//! original reads on as if the copy had never read. The queue holds only octets that lie in the
//! input. Both write the one storage, so octets that lie there stay only until the next call of
//! either.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Kind = decoder_file.Kind;
const fast = @import("decoder_fast.zig");
const Framing = @import("../framing.zig").Framing;
const Claims = @import("../claims.zig").Claims;
const constants = @import("../constants.zig");
const token_loop = @import("decoder_loop/decoder_loop.zig");

pub const TextReader = struct {
    /// What `next` can fail with: a refusal of the text, or the operational errors of decision 11.
    pub const Error = decoder_file.Error || codec.Incomplete;

    /// A token, with a name's, a string's or a number's octets. They lie in the reader's input, or
    /// in its storage where the decoder changed them, and stay there until the next call
    /// (decision 74).
    pub const Item = @import("decoder_batch.zig").Item;

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
    /// The tokens claim J10's loop took ahead, their octets in place in the input: `next` hands out
    /// `queue[handed..queued]` before it decodes again (decision 76). `decoder` and `consumed`
    /// stand past the last of them.
    queue: [constants.reader_queue_len]TextReader.Item,
    queued: u8,
    handed: u8,

    /// Reads the texts `input` holds, with the caller's CPU features (`Decoder.init`). A name's, a
    /// string's or a number's octets that do not stay in `input` go into `storage`.
    pub fn init(input: []const u8, storage: []u8, framing: Framing, features: codec.Features) TextReader {
        // A safe build fills an `undefined` field with 0xaa: the queue's 1.5 KiB took a memset
        // call, about 1,700 instructions a reader. The safety off here skips that fill alone, as
        // `init` checks nothing else (decision 76).
        @setRuntimeSafety(false);
        var reader: TextReader = .{
            .decoder = undefined,
            .input = input,
            .consumed = 0,
            .storage = storage,
            .framing = framing,
            .features = features,
            .started = false,
            .ended = false,
            .queue = undefined,
            .queued = 0,
            .handed = 0,
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

    /// The current text's next token, or null at its end. Small enough that a caller's loop takes
    /// it inline: the queue's next token, or a call when the queue is empty (decision 76).
    pub fn next(self: *TextReader) Error!?TextReader.Item {
        assert(self.started and !self.ended);
        assert(self.handed <= self.queued);
        if (self.handed < self.queued) return self.pop();
        return self.next_unqueued();
    }

    /// `next` when the queue is empty: the text's end, the queue filled again, or a token the loop
    /// leaves. Out of line: inside `next`, LLVM took `next` out of the caller's loop, and each
    /// token paid a call and its item's return through memory (decision 76).
    noinline fn next_unqueued(self: *TextReader) Error!?TextReader.Item {
        assert(self.handed == self.queued);
        if (self.decoder.stage == .done) {
            self.ended = true;
            return null;
        }
        // Claim J10's loop, in place: tokens a batch at a time, for `next` to hand out one a call
        // (decision 76). A token it leaves takes claim J8's line, then the checked path.
        if (self.decoder.stage == .tokens and self.decoder.open == .none and self.refill()) return self.pop();
        if (self.decoder.stage == .done) {
            self.ended = true;
            return null;
        }
        // Claim J8's straight line, taken here with no pass through the streaming call: the reader
        // holds all the input and all the storage, so it pays for no slice of either, no progress
        // and no status to read back (decision 69). A token the line leaves takes `decode`.
        if (self.decoder.stage == .tokens and self.decoder.open == .none) {
            var reader: codec.Reader = .{ .octets = self.input, .position = self.consumed };
            var writer = codec.Writer.init(self.storage);
            // The line leaves a token's octets in the input, and writes only those it changed.
            var octets: []const u8 = &.{};
            if (fast.token(&self.decoder, .{}, &reader, &writer, &octets)) |outcome| {
                // The line takes whole tokens alone, and leaves the text's end to `decode`.
                assert(outcome.status == .token);
                self.consumed = reader.position;
                return item(outcome.kind.?, octets);
            }
        }
        return self.checked();
    }

    /// Takes tokens ahead into the queue through claim J10's loop in place, and returns whether it
    /// took one. The loop also takes the text's end, which leaves the decoder done.
    inline fn refill(self: *TextReader) bool {
        var cursor: token_loop.Cursor = .{ .consumed = self.consumed, .written = 0 };
        const filled = token_loop.take_in_place(&self.decoder, in_place, self.input, self.storage, .last, &cursor, &self.queue);
        assert(cursor.written == 0);
        self.consumed = cursor.consumed;
        self.queued = @intCast(filled);
        self.handed = 0;
        return filled > 0;
    }

    /// The next token of the queue, its octets in the input.
    inline fn pop(self: *TextReader) TextReader.Item {
        const queued = self.queue[self.handed];
        self.handed += 1;
        return queued;
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

    /// The octets of the input taken so far: at a text's end, where the next one starts. Between a
    /// text's tokens it stands past the tokens the queue holds (decision 76).
    pub fn consumed_len(self: *const TextReader) usize {
        return self.consumed;
    }
};

/// The claims of `checked`'s call: every one on but claim J8's line, which `next` takes itself.
const without_line: Claims = .{ .decoder_fast_path = false };

/// The claims of the queue's loop: every one on, the octets in place (decision 76).
const in_place: Claims = .{ .decoder_loop_in_place = true };

comptime {
    // The queue's counts fit their fields.
    assert(constants.reader_queue_len <= std.math.maxInt(u8));
}

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
