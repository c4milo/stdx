//! The value decoder (decision 61): a Zig value from a text, read through the token `Decoder` as
//! much as each input holds.
//!
//! The caller passes the same storage and the same result to each call. A string a field keeps
//! stays at the front of the storage, and the result holds a slice of it. A name's or a number's
//! octets wait after the strings kept until the token ends, and the next token writes over them.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const decoder_file = @import("../decoder/decoder.zig");
const framing_file = @import("../framing.zig");
const value_type = @import("value_type.zig");
const value_accept = @import("value_accept.zig");
const constants = @import("../constants.zig");

const Decoder = decoder_file.Decoder;
const Framing = framing_file.Framing;
const Piece = framing_file.Piece;

/// A refusal of the text by the token decoder or by the type, or a storage the strings fill
/// (`error.NoSpaceLeft`).
pub const Error = decoder_file.Error || value_accept.Refusal || error{NoSpaceLeft};

/// The decoder of values of type `T`.
pub fn ValueDecoder(comptime T: type) type {
    return struct {
        const Self = @This();
        const Frame = value_accept.Frame(value_type.fields_max(T));

        decoder: Decoder,
        frames: [value_type.depth_of(T)]Frame,
        /// Octets at the storage's front that the result's strings hold.
        kept: usize,
        /// Octets of the current name, string or number written after them so far.
        pending: usize,
        /// The storage and the result the first call passed, which every later call passes too.
        storage: ?[*]u8,
        result: ?*T,

        pub fn init(self: *Self, framing: Framing, features: codec.Features) void {
            self.decoder.init(framing, features);
            self.frames = @splat(Frame.empty);
            self.kept = 0;
            self.pending = 0;
            self.storage = null;
            self.result = null;
        }

        /// Fills `result` from as much of the text as `input` holds, `piece` saying whether it holds
        /// the text's last octets. `needs_input` asks for the next octets; `done` says the text
        /// ended and `result` holds its value. A string longer than the storage left is
        /// `error.NoSpaceLeft`, as the result's strings already point into this storage.
        pub fn decode(self: *Self, input: []const u8, storage: []u8, piece: Piece, result: *T) Error!codec.Progress {
            // The storage or the result moves between calls only by the caller's error.
            assert(self.storage == null or self.storage.? == storage.ptr);
            assert(self.result == null or self.result.? == result);
            self.storage = storage.ptr;
            self.result = result;
            var consumed: usize = 0;
            // Each call of the token decoder takes an octet, or ends a token that took one.
            for (0..constants.value_decode_calls_per_octet * (input.len + 1)) |_| {
                const progress = try self.decoder.decode(input[consumed..], storage[self.kept + self.pending ..], piece);
                consumed += progress.consumed;
                switch (progress.status) {
                    .needs_input => {
                        if (progress.kind != null) self.pending += progress.written;
                        return .{ .consumed = consumed, .written = 0, .status = .needs_input };
                    },
                    .needs_room => return error.NoSpaceLeft,
                    .done => return .{ .consumed = consumed, .written = 0, .status = .done },
                    .token => try self.take(progress.kind.?, storage[self.kept..][0 .. self.pending + progress.written], result),
                }
            }
            unreachable;
        }

        fn take(self: *Self, kind: decoder_file.Kind, octets: []u8, result: *T) Error!void {
            self.pending = 0;
            var token: value_accept.Token = .{ .kind = kind, .octets = octets };
            _ = try value_accept.accept(T, result, &self.frames, 0, &token);
            if (token.kept) self.kept += octets.len;
        }
    };
}

/// Reads the one value of `text` into a `T`, its strings slices of `storage`: `error.Truncated`
/// when the text ends before its value does.
pub fn decode_value(comptime T: type, text: []const u8, storage: []u8, framing: Framing, features: codec.Features) (Error || error{Truncated})!T {
    var state: ValueDecoder(T) = undefined;
    state.init(framing, features);
    var result: T = undefined;
    const progress = try state.decode(text, storage, .last, &result);
    if (progress.status != .done) return error.Truncated;
    return result;
}

test {
    _ = @import("value_number.zig");
    _ = @import("value_decoder_test.zig");
    _ = @import("value_fuzz_test.zig");
}
