//! The decoder's walk of a type (decision 61): each token the token decoder gives goes to the
//! value at the cursor, which fills it or refuses it.
//!
//! A level's frame holds its position and, for a struct, the fields filled. A struct's position is
//! 0 before its begin, 1 between members, and 2 + i inside field i's value. An array's is 0 before
//! its begin, and 1 + n once it holds n values. A container's position returns to 0 at its end, so
//! the level below starts each value at 0.

const std = @import("std");
const assert = std.debug.assert;
const decoder_file = @import("../decoder/decoder.zig");
const value_type = @import("value_type.zig");
const value_number = @import("value_number.zig");
const constants = @import("../constants.zig");

const Kind = decoder_file.Kind;

/// What the walk refuses: a text the type cannot hold.
pub const Refusal = error{
    /// A member whose name no field of the struct has.
    UnknownField,
    /// A member whose field an earlier member filled.
    DuplicateField,
    /// An object that ends without a field that is not optional and has no default.
    MissingField,
    /// A token the type does not take where it comes, or a text deeper than the type.
    TypeMismatch,
    /// An array with more or fewer values than the type's array holds.
    ArrayLength,
    /// A string that names no tag of the enum.
    UnknownEnumName,
} || value_number.Error;

/// One level of the cursor.
pub fn Frame(comptime field_bits: usize) type {
    return struct {
        position: u32,
        filled: std.StaticBitSet(field_bits),

        pub const empty: @This() = .{ .position = 0, .filled = .initEmpty() };
    };
}

/// A token and its octets, and whether the value at the cursor keeps the octets as a string.
pub const Token = struct {
    kind: Kind,
    octets: []const u8,
    kept: bool = false,
};

/// Gives `token` to the value `target` of type `U` at `level`. Returns whether the value ended.
pub fn accept(comptime U: type, target: *U, frames: anytype, level: usize, token: *Token) Refusal!bool {
    switch (comptime value_type.shape_of(U)) {
        .boolean => target.* = switch (token.kind) {
            .true => true,
            .false => false,
            // RFC 8259 §9, the parser's representation: a bool takes `true` or `false`.
            else => return error.TypeMismatch,
        },
        .unsigned, .signed => target.* = try value_number.integer(U, try number_text(token)),
        .decimal => target.* = try value_number.decimal(try number_text(token)),
        .enumeration => target.* = try enum_tag(U, try string_text(token)),
        .string => {
            target.* = try string_text(token);
            token.kept = true;
        },
        .optional => return accept_optional(U, target, frames, level, token),
        .structure => return accept_member(U, target, frames, level, token),
        .array => return accept_element(U, target, frames, level, token),
        .slice => @compileError("json decodes no slice but []const u8: its values would need storage (decision 61)"),
    }
    return true;
}

fn number_text(token: *const Token) Refusal![]const u8 {
    // RFC 8259 §9, the parser's representation: this type takes a number.
    if (token.kind != .number) return error.TypeMismatch;
    return token.octets;
}

fn string_text(token: *const Token) Refusal![]const u8 {
    // RFC 8259 §9, the parser's representation: this type takes a string.
    if (token.kind != .string) return error.TypeMismatch;
    return token.octets;
}

fn enum_tag(comptime U: type, name: []const u8) Refusal!U {
    inline for (std.meta.fields(U)) |field| {
        if (std.mem.eql(u8, field.name, name)) return @enumFromInt(field.value);
    }
    // RFC 8259 §9, the parser's representation: an enum takes its tags alone.
    return error.UnknownEnumName;
}

/// Whether the value below `level` started: a struct or an array past its begin.
fn started(comptime U: type, frames: anytype, level: usize) bool {
    return (comptime value_type.depth_of(U) > 0) and frames[level].position != 0;
}

fn accept_optional(comptime U: type, target: *U, frames: anytype, level: usize, token: *Token) Refusal!bool {
    const Child = value_type.Child(U);
    // An optional takes no level: its child's frame is this level's.
    if (!started(Child, frames, level)) {
        if (token.kind == .null) {
            target.* = null;
            return true;
        }
        // A child of one token is read whole, then stored: an optional slice is null by its
        // pointer, so a child stored before its value could read as null.
        if (comptime value_type.depth_of(Child) == 0) {
            var child: Child = undefined;
            _ = try accept(Child, &child, frames, level, token);
            target.* = child;
            return true;
        }
        // A struct's or an array's optional keeps a tag of its own. Its child takes defined octets,
        // and every field and value is written again before the child ends.
        var child: Child = undefined;
        @memset(std.mem.asBytes(&child), 0);
        target.* = child;
    }
    return accept(Child, &target.*.?, frames, level, token);
}

fn accept_member(comptime U: type, target: *U, frames: anytype, level: usize, token: *Token) Refusal!bool {
    const frame = &frames[level];
    switch (frame.position) {
        0 => {
            // RFC 8259 §9, the parser's representation: a struct takes an object.
            if (token.kind != .begin_object) return error.TypeMismatch;
            frame.position = 1;
            frame.filled = .initEmpty();
            return false;
        },
        1 => {
            if (token.kind == .end_object) {
                try fill_missing(U, target, frame.filled);
                frame.position = 0;
                return true;
            }
            // The token decoder gives a name or the object's end here (RFC 8259 §4).
            assert(token.kind == .name);
            const index = try field_index(U, token.octets);
            // RFC 8259 §4: the names within an object SHOULD be unique; a field takes one member.
            if (frame.filled.isSet(index)) return error.DuplicateField;
            frame.filled.set(index);
            frame.position = @intCast(constants.value_field_position_first + index);
            return false;
        },
        else => {
            if (try accept_field(U, target, frames, level, token, frame.position - constants.value_field_position_first)) frame.position = 1;
            return false;
        },
    }
}

fn field_index(comptime U: type, name: []const u8) Refusal!usize {
    inline for (std.meta.fields(U), 0..) |field, index| {
        if (std.mem.eql(u8, field.name, name)) return index;
    }
    // RFC 8259 §9, the parser's representation: a struct takes its fields alone.
    return error.UnknownField;
}

fn accept_field(comptime U: type, target: *U, frames: anytype, level: usize, token: *Token, which: usize) Refusal!bool {
    inline for (std.meta.fields(U), 0..) |field, index| {
        if (index == which) return accept(field.type, &@field(target, field.name), frames, level + 1, token);
    }
    unreachable;
}

/// Fills each field no member named with its default, or null for an optional one.
fn fill_missing(comptime U: type, target: *U, filled: anytype) Refusal!void {
    inline for (std.meta.fields(U), 0..) |field, index| {
        if (!filled.isSet(index)) {
            if (comptime field.defaultValue()) |default| {
                @field(target, field.name) = default;
            } else if (comptime value_type.shape_of(field.type) == .optional) {
                @field(target, field.name) = null;
            } else {
                // RFC 8259 §9, the parser's representation: this field has no default.
                return error.MissingField;
            }
        }
    }
}

fn accept_element(comptime U: type, target: *U, frames: anytype, level: usize, token: *Token) Refusal!bool {
    const Child = value_type.Child(U);
    const frame = &frames[level];
    if (frame.position == 0) {
        // RFC 8259 §9, the parser's representation: an array type takes an array.
        if (token.kind != .begin_array) return error.TypeMismatch;
        frame.position = 1;
        return false;
    }
    const count = frame.position - 1;
    if (!started(Child, frames, level + 1)) {
        if (token.kind == .end_array) {
            // RFC 8259 §9, the parser's representation: [N]T takes N values.
            if (count != target.len) return error.ArrayLength;
            frame.position = 0;
            return true;
        }
        // RFC 8259 §9, the parser's representation: [N]T takes N values.
        if (count == target.len) return error.ArrayLength;
    }
    if (try accept(Child, &target[count], frames, level + 1, token)) frame.position += 1;
    return false;
}
