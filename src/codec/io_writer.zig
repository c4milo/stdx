//! `IoWriter`: an encoder behind Zig 0.16's `std.Io.Writer` interface (decision 56). The caller
//! writes octets to `interface`, and the encoder writes the stream that codes them into a
//! destination `std.Io.Writer` that the caller owns.
//!
//! - `interface.flush` passes `Flush.flush` to the encoder, so a decoder can produce every octet
//!   written so far, and then flushes the destination.
//! - `finish` passes `Flush.finish`, which ends the stream, and then flushes the destination.
//!   The caller writes nothing after `finish`.
//!
//! The encoder writes into the destination's buffer, with no copy between. The writer keeps the
//! encoder's state when the destination fails with `error.WriteFailed`. The call fails the same
//! way, and the caller calls again when the destination has room. Each call of `drain` makes at
//! most one call of the encoder, so its work stays bounded by the octets that call takes and
//! writes (decision 11).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const status = @import("status.zig");
const Features = @import("features.zig").Features;

const Writer = std.Io.Writer;

/// `Encoder` has `init(*Encoder, Features)`, `encode(*Encoder, input, output, Flush)` and
/// `encoded_len_max(input_len)`. `held_len_max` is the most input octets it holds back between
/// calls, which a flush must still write.
pub fn IoWriter(comptime Encoder: type, comptime held_len_max: usize) type {
    return struct {
        const Self = @This();

        /// The interface the caller writes octets to.
        interface: Writer,
        /// Where the coded stream goes.
        destination: *Writer,
        encoder: Encoder,
        /// Whether the caller called `finish`, and whether the stream ended.
        phase: Phase,

        const Phase = enum { open, finishing, done };

        const vtable: Writer.VTable = .{ .drain = drain, .flush = flush };

        /// Starts the writer over `destination`, whose buffer holds at least one octet. `buffer` is
        /// the writer's own, which gathers small writes before the encoder takes them; it may be
        /// empty.
        pub fn init(self: *Self, destination: *Writer, buffer: []u8, features: Features) void {
            // `writableSliceGreedy` hands out the destination's buffer.
            assert(destination.buffer.len > 0);
            self.interface = .{ .vtable = &vtable, .buffer = buffer, .end = 0 };
            self.destination = destination;
            self.phase = .open;
            self.encoder.init(features);
        }

        /// Ends the stream: encodes every octet written, writes the format's end, and flushes the
        /// destination. A call that fails with `error.WriteFailed` keeps the state, and the caller
        /// calls `finish` again when the destination has room.
        pub fn finish(self: *Self) Writer.Error!void {
            if (self.phase != .done) {
                self.phase = .finishing;
                try encode_all(self, .finish);
                self.phase = .done;
            }
            try self.destination.flush();
        }

        fn drain(interface: *Writer, data: []const []const u8, splat: usize) Writer.Error!usize {
            return drain_into(@as(*Self, @alignCast(@fieldParentPtr("interface", interface))), data, splat);
        }

        fn flush(interface: *Writer) Writer.Error!void {
            return flush_into(@as(*Self, @alignCast(@fieldParentPtr("interface", interface))));
        }

        const held_len = held_len_max;
    };
}

fn drain_into(self: anytype, data: []const []const u8, splat: usize) Writer.Error!usize {
    const interface = &self.interface;
    // A write after `finish` is a programmer error (decision 11).
    assert(self.phase == .open);
    if (interface.end > 0) {
        _ = try encode_buffered(self, .none);
        return 0;
    }
    const input = first_input(data, splat);
    if (input.len == 0) return 0;
    const progress = try encode(self, input, .none);
    return progress.consumed;
}

fn flush_into(self: anytype) Writer.Error!void {
    // After `finish`, the octets left are the destination's.
    if (self.phase == .open) try encode_all(self, .flush);
    try self.destination.flush();
}

/// Encodes the buffered octets with `mode` until the encoder ends the flush or the stream.
fn encode_all(self: anytype, mode: status.Flush) Writer.Error!void {
    assert(mode != .none);
    const ended: status.Status = if (mode == .finish) .done else .needs_input;
    // Each round takes an input octet or writes one into a slice of at least one octet (invariant
    // 8), and `constants.io_flush_rounds_factor` bounds the octets the rounds write.
    const buffered_len = self.interface.end;
    const rounds_max = buffered_len + constants.io_flush_rounds_factor * @TypeOf(self.encoder).encoded_len_max(@TypeOf(self.*).held_len + buffered_len) + 1;
    for (0..rounds_max) |_| {
        const progress = try encode_buffered(self, mode);
        if (progress.status == ended) {
            assert(self.interface.end == 0);
            return;
        }
    }
    unreachable;
}

/// Encodes the octets in the writer's buffer, and moves the ones the encoder did not take to its
/// start.
fn encode_buffered(self: anytype, mode: status.Flush) Writer.Error!status.Progress {
    const interface = &self.interface;
    const progress = try encode(self, interface.buffer[0..interface.end], mode);
    const left_len = interface.end - progress.consumed;
    @memmove(interface.buffer[0..left_len], interface.buffer[progress.consumed..interface.end]);
    interface.end = left_len;
    return progress;
}

fn encode(self: anytype, input: []const u8, mode: status.Flush) Writer.Error!status.Progress {
    const output = try self.destination.writableSliceGreedy(1);
    const progress = self.encoder.encode(input, output, mode);
    self.destination.advance(progress.written);
    return progress;
}

/// The first octets of `data` to encode: its first slice that is not empty, or its last slice,
/// which `Writer.VTable.drain` repeats `splat` times. `drain` counts the octets it takes of the
/// repeated slice once each.
fn first_input(data: []const []const u8, splat: usize) []const u8 {
    assert(data.len > 0);
    for (data[0 .. data.len - 1]) |slice| {
        if (slice.len > 0) return slice;
    }
    if (splat == 0) return &.{};
    return data[data.len - 1];
}
