//! The value encoder (decision 61): a text from a Zig value, written through the token `Encoder`
//! as much as each output holds.
//!
//! A cursor holds one index a level, for each struct or array the walk is inside. A struct of n
//! fields takes 2n + 2 positions: its begin, a name and a value for each field, and its end. An
//! array of n values takes n + 2: its begin, a value each, and its end. Every other shape is one
//! token at its parent's position.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const encoder_file = @import("../encoder/encoder.zig");
const value_type = @import("value_type.zig");
const constants = @import("../constants.zig");
const Framing = @import("../framing.zig").Framing;

const Encoder = encoder_file.Encoder;
const Token = encoder_file.Token;
pub const Error = encoder_file.Error;

/// A token at the cursor, and the octets of its name or string.
const Emit = struct { token: Token, octets: []const u8 = &.{} };

/// The encoder of values of type `T`.
pub fn ValueEncoder(comptime T: type) type {
    return struct {
        const Self = @This();
        const depth = value_type.depth_of(T);

        encoder: Encoder,
        /// One position a level of the walk.
        positions: [depth]u32,
        /// Octets of the current name or string that the token encoder took.
        taken: usize,
        /// The value the first call passed, which every later call passes too.
        root: ?*const T,

        pub fn init(self: *Self, framing: Framing, features: codec.Features) void {
            self.encoder.init(framing, features);
            self.positions = @splat(0);
            self.taken = 0;
            self.root = null;
        }

        /// Writes as much of `value`'s text into `output` as fits. `needs_room` asks for another
        /// call with the same value, at the same address, and more room; `done` says the text
        /// ended. A value of strings that are not UTF-8 is `error.InvalidUtf8` (RFC 8259 §8.1).
        pub fn encode(self: *Self, value: *const T, output: []u8) Error!codec.Progress {
            // The value moves or changes between calls only by the caller's error.
            assert(self.root == null or self.root.? == value);
            self.root = value;
            var written: usize = 0;
            // Every token writes an octet at least, so the output's room bounds the tokens.
            for (0..output.len + 1) |_| {
                const emit = current(T, value, &self.positions, 0);
                const progress = try self.encoder.encode(emit.token, emit.octets[self.taken..], output[written..]);
                written += progress.written;
                switch (progress.status) {
                    .needs_room => {
                        self.taken += progress.consumed;
                        return .{ .consumed = 0, .written = written, .status = .needs_room };
                    },
                    .done => return .{ .consumed = 0, .written = written, .status = .done },
                    .needs_input => {
                        self.taken = 0;
                        _ = advance(T, value, &self.positions, 0);
                    },
                }
            }
            unreachable;
        }
    };
}

/// Writes `value`'s text into `output` whole, and returns it: `error.NoSpaceLeft` when it does not
/// fit, with nothing written past `output`.
pub fn encode_value(comptime T: type, value: *const T, output: []u8, framing: Framing, features: codec.Features) (Error || error{NoSpaceLeft})![]u8 {
    var state: ValueEncoder(T) = undefined;
    state.init(framing, features);
    const progress = try state.encode(value, output);
    if (progress.status != .done) return error.NoSpaceLeft;
    return output[0..progress.written];
}

/// The token at the cursor's position in `value`, at `level`.
fn current(comptime U: type, value: *const U, positions: []u32, level: usize) Emit {
    return switch (comptime value_type.shape_of(U)) {
        .boolean => .{ .token = .{ .boolean = value.* } },
        .unsigned => .{ .token = .{ .unsigned = value.* } },
        .signed => .{ .token = .{ .signed = value.* } },
        .decimal => .{ .token = .{ .decimal = value.* } },
        .enumeration => .{ .token = .{ .string = .last }, .octets = @tagName(value.*) },
        .string => .{ .token = .{ .string = .last }, .octets = value.* },
        .optional => if (value.*) |*child| current(value_type.Child(U), child, positions, level) else .{ .token = .null },
        .structure => current_member(U, value, positions, level),
        .array, .slice => current_element(U, value, positions, level),
    };
}

fn current_member(comptime U: type, value: *const U, positions: []u32, level: usize) Emit {
    const fields = std.meta.fields(U);
    const position = positions[level];
    if (position == 0) return .{ .token = .begin_object };
    if (position == end_of(fields.len)) return .{ .token = .end_object };
    const field_index = (position - 1) / member_positions;
    inline for (fields, 0..) |field, index| {
        if (index == field_index) {
            if (position % member_positions == 1) return .{ .token = .{ .name = .last }, .octets = field.name };
            return current(field.type, &@field(value, field.name), positions, level + 1);
        }
    }
    unreachable;
}

fn current_element(comptime U: type, value: *const U, positions: []u32, level: usize) Emit {
    const position = positions[level];
    if (position == 0) return .{ .token = .begin_array };
    if (position == value.len + 1) return .{ .token = .end_array };
    return current(value_type.Child(U), &value.*[position - 1], positions, level + 1);
}

const member_positions = constants.value_member_positions;

/// A struct's end position: after its begin and each member's name and value.
fn end_of(fields_len: usize) usize {
    return member_positions * fields_len + 1;
}

/// Moves the cursor past the token at its position. Returns whether `value` ended there.
fn advance(comptime U: type, value: *const U, positions: []u32, level: usize) bool {
    return switch (comptime value_type.shape_of(U)) {
        .optional => if (value.*) |*child| advance(value_type.Child(U), child, positions, level) else true,
        .structure => advance_member(U, value, positions, level),
        .array, .slice => advance_container(value_type.Child(U), value.len, value, positions, level),
        else => true,
    };
}

fn advance_member(comptime U: type, value: *const U, positions: []u32, level: usize) bool {
    const fields = std.meta.fields(U);
    const position = positions[level];
    // A value's position: it moves on once the field's value ends.
    if (position > 1 and position % member_positions == 0 and position < end_of(fields.len)) {
        const field_index = position / member_positions - 1;
        inline for (fields, 0..) |field, index| {
            if (index == field_index and !advance(field.type, &@field(value, field.name), positions, level + 1)) return false;
        }
    }
    return step(positions, level, end_of(fields.len));
}

fn advance_container(comptime Element: type, len: usize, value: anytype, positions: []u32, level: usize) bool {
    const position = positions[level];
    if (position >= 1 and position <= len and !advance(Element, &value.*[position - 1], positions, level + 1)) return false;
    return step(positions, level, len + 1);
}

/// Moves `level`'s position one on. Past the end at `last`, the level returns to 0 and the
/// container has ended, so the level below starts each value at 0.
fn step(positions: []u32, level: usize, last: usize) bool {
    assert(positions[level] <= last);
    if (positions[level] == last) {
        positions[level] = 0;
        return true;
    }
    positions[level] += 1;
    return false;
}

test {
    _ = @import("value_encoder_test.zig");
}
