//! `IoReader`: a decoder behind Zig 0.16's `std.Io.Reader` interface (decision 56). The caller
//! reads decoded octets from `interface`. The reader takes coded octets from a source
//! `std.Io.Reader` that the caller owns.
//!
//! The reader keeps the decoder's state across every failure of its source:
//! - The source fails with `error.ReadFailed`: the read fails the same way, and `failure` stays
//!   null. The next read goes on from the same state, after the source holds more octets.
//! - The source fails with `error.EndOfStream`: the read fails the same way only when the decoder
//!   reported `done`. Inside a stream, the reader stops with `error.Truncated`.
//! - The decoder refuses the coded octets: the read fails with `error.ReadFailed`, and `failure`
//!   names the refusal. Every later read fails the same way.
//!
//! Each call of the interface makes at most one call of the decoder, so its work stays bounded by
//! the octets that call reads and writes (decision 11). The decoder writes into the caller's
//! `std.Io.Writer` when the caller streams, and into the reader's buffer when the caller peeks.

const std = @import("std");
const assert = std.debug.assert;
const status = @import("status.zig");
const Features = @import("features.zig").Features;

const Reader = std.Io.Reader;
const Writer = std.Io.Writer;
const Limit = std.Io.Limit;

/// What the reader does with the coded octets after a stream ended.
pub const AfterDone = enum {
    /// Refuse them as `error.TrailingOctets`: the coded octets hold one stream.
    refuse,
    /// Start the decoder again and decode them as the next stream: gzip's next member (RFC 1952
    /// §2.2), or Zstandard's next frame (RFC 8878 §3.1).
    restart,
};

/// The calls of a decoder that `IoReader` makes.
pub fn DecoderCalls(comptime Decoder: type, comptime Error: type) type {
    return struct {
        init: fn (*Decoder, Features) void,
        decode: fn (*Decoder, []const u8, []u8) Error!status.Progress,
        after_done: AfterDone,
    };
}

/// The two refusals of the reader itself, beside the decoder's.
pub const Ended = error{
    /// The source ended inside a stream.
    Truncated,
    /// The source held octets after its one stream.
    TrailingOctets,
};

pub fn IoReader(comptime Decoder: type, comptime Error: type, comptime calls: DecoderCalls(Decoder, Error)) type {
    return struct {
        const Self = @This();

        /// Why the reader stopped, when its source did not cause it.
        pub const Failure = Error || Ended;

        /// The interface the caller reads decoded octets from.
        interface: Reader,
        /// The coded octets.
        source: *Reader,
        decoder: Decoder,
        /// The features `init` took, which a restart passes again.
        features: Features,
        /// How the last call of the decoder ended: `needs_input` before the first call.
        last: status.Status,
        /// The refusal that stopped the reader, or null while it can go on.
        failure: ?Failure,

        const vtable: Reader.VTable = .{ .stream = stream };

        /// Starts the reader over `source`, whose buffer holds at least one octet. `buffer` is the
        /// reader's own, for the caller's peeks; it may be empty when the caller only streams into
        /// a writer with a buffer.
        pub fn init(self: *Self, source: *Reader, buffer: []u8, features: Features) void {
            // `peekGreedy` reads into the source's buffer.
            assert(source.buffer.len > 0);
            self.interface = .{ .vtable = &vtable, .buffer = buffer, .seek = 0, .end = 0 };
            self.source = source;
            self.features = features;
            self.last = .needs_input;
            self.failure = null;
            calls.init(&self.decoder, features);
        }

        fn stream(interface: *Reader, destination: *Writer, limit: Limit) Reader.StreamError!usize {
            return stream_into(@as(*Self, @alignCast(@fieldParentPtr("interface", interface))), destination, limit);
        }

        const decoder_calls = calls;
    };
}

fn stream_into(self: anytype, destination: *Writer, limit: Limit) Reader.StreamError!usize {
    if (self.failure != null) return error.ReadFailed;
    if (limit == .nothing) return 0;
    const input = try take_input(self);
    // A writer with no buffer has no slice to decode into, so the octets go into the reader's
    // buffer, which `Reader.stream` empties into the writer next.
    if (destination.buffer.len == 0) return decode_buffered(self, input);
    const output = limit.slice(try destination.writableSliceGreedy(1));
    const written = try decode(self, input, output);
    destination.advance(written);
    return written;
}

/// The coded octets the next call of the decoder takes. Reads the source only when the decoder
/// took all it had.
fn take_input(self: anytype) Reader.Error![]const u8 {
    switch (self.last) {
        .needs_room => return self.source.buffered(),
        .needs_input => return self.source.peekGreedy(1) catch |err| switch (err) {
            error.ReadFailed => return error.ReadFailed,
            error.EndOfStream => return fail(self, error.Truncated),
        },
        .done => {
            // `EndOfStream` passes through: the stream is whole and its source ended.
            const input = try self.source.peekGreedy(1);
            switch (@TypeOf(self.*).decoder_calls.after_done) {
                .refuse => return fail(self, error.TrailingOctets),
                .restart => {
                    @TypeOf(self.*).decoder_calls.init(&self.decoder, self.features);
                    self.last = .needs_input;
                    return input;
                },
            }
        },
    }
}

/// Decodes into the reader's own buffer, which `Reader.stream` emptied before this call.
fn decode_buffered(self: anytype, input: []const u8) Reader.Error!usize {
    const interface = &self.interface;
    assert(interface.seek == interface.end);
    assert(interface.buffer.len > 0);
    interface.seek = 0;
    interface.end = try decode(self, input, interface.buffer);
    return 0;
}

fn decode(self: anytype, input: []const u8, output: []u8) error{ReadFailed}!usize {
    assert(output.len > 0);
    const progress = @TypeOf(self.*).decoder_calls.decode(&self.decoder, input, output) catch |err| return fail(self, err);
    self.source.toss(progress.consumed);
    self.last = progress.status;
    return progress.written;
}

fn fail(self: anytype, failure: @TypeOf(self.*).Failure) error{ReadFailed} {
    assert(self.failure == null);
    self.failure = failure;
    return error.ReadFailed;
}
