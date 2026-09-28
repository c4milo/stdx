//! Where the checked path's octets go: the caller's output, the window, and the two octets a
//! literal's context reads (RFC 7932 §7.1), one octet at a time (decision 16).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const State = @import("decoder_state.zig").State;

pub fn Output(comptime Window: type) type {
    return struct {
        const Self = @This();

        writer: *codec.Writer,
        window: *Window,

        pub fn has_room(self: *const Self) bool {
            return self.writer.room_len() > 0;
        }

        /// Writes one octet of the meta-block: to the caller's output and the window, and as p1 of
        /// the next literal's context (RFC 7932 §7.1).
        pub fn emit(self: *Self, state: *State, octet: u8) void {
            assert(self.has_room());
            assert(state.meta_block_left > 0);
            self.writer.write_octet(octet) catch unreachable;
            self.window.push(octet);
            state.p2 = state.p1;
            state.p1 = octet;
            state.produced += 1;
            state.meta_block_left -= 1;
        }

        /// The octet `distance` back from the next one. The caller has kept `distance` within the
        /// octets produced and the window (RFC 7932 §4, §9.1).
        pub fn back(self: *const Self, distance: u32) u8 {
            return self.window.back(distance);
        }
    };
}
