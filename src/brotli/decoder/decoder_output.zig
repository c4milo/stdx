//! Where the checked path's octets go: the caller's output and the two octets a literal's context
//! reads (RFC 7932 §7.1), one octet at a time (decision 16); and where its back-references read
//! them: this call's output, and before it, the window.
//!
//! With the window-once claim, the window takes a call's octets once, when the call ends, and none
//! when the call ends the stream, as S5 does for DEFLATE and Z6 for Zstandard. With it off, each
//! octet the checked path writes goes into the window at once, and the fast path's go in when it
//! returns.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const State = @import("decoder_state.zig").State;
const Claims = @import("../claims.zig").Claims;

pub fn Output(comptime Window: type, comptime claims: Claims) type {
    return struct {
        const Self = @This();

        writer: *codec.Writer,
        window: *Window,

        pub fn has_room(self: *const Self) bool {
            return self.writer.room_len() > 0;
        }

        pub fn room_len(self: *const Self) usize {
            return self.writer.room_len();
        }

        /// Writes one octet of the meta-block: to the caller's output, and as p1 of the next
        /// literal's context (RFC 7932 §7.1).
        pub fn emit(self: *Self, state: *State, octet: u8) void {
            assert(self.has_room());
            assert(state.meta_block_left > 0);
            self.writer.write_octet(octet) catch unreachable;
            if (!claims.window_once) self.window.push(octet);
            state.p2 = state.p1;
            state.p1 = octet;
            state.produced += 1;
            state.meta_block_left -= 1;
        }

        /// The octet `distance` back from the next one: in this call's output, or in the window,
        /// which holds the octets before it. The caller has kept `distance` within the octets
        /// produced and the window (RFC 7932 §4, §9.1).
        pub fn back(self: *const Self, distance: u32) u8 {
            if (!claims.window_once) return self.window.back(distance);
            const written = self.writer.written();
            if (distance <= written.len) return written[written.len - distance];
            return self.window.back(distance - written.len);
        }
    };
}
