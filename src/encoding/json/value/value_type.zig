//! The Zig types the value layer maps to JSON and back (decision 61), classified at comptime. A
//! struct and an array each take one level of a cursor; every other shape takes none, so a type's
//! depth is the most structs and arrays that nest in it.

const std = @import("std");
const Decimal = @import("../format.zig").Decimal;
const constants = @import("../constants.zig");

/// What a type maps to in a text.
pub const Shape = enum {
    /// `true` or `false` (RFC 8259 §3).
    boolean,
    /// A number with no fraction or exponent, at most 64 bits wide (RFC 8259 §6).
    unsigned,
    signed,
    /// A number with a fraction and no exponent: `Decimal`.
    decimal,
    /// A string holding a tag's name.
    enumeration,
    /// A string: `[]const u8`.
    string,
    /// `null`, or the child's value.
    optional,
    /// An object, a member a field (RFC 8259 §4).
    structure,
    /// An array of exactly `N` values (RFC 8259 §5).
    array,
    /// An array of any length: encoded, never decoded (decision 61).
    slice,
};

/// The shape of `T`, or a compile error for a type decision 61 leaves out.
pub fn shape_of(comptime T: type) Shape {
    if (T == Decimal) return .decimal;
    if (T == []const u8) return .string;
    return switch (@typeInfo(T)) {
        .bool => .boolean,
        .int => |int| int_shape(T, int),
        .@"enum" => .enumeration,
        .optional => .optional,
        .@"struct" => .structure,
        .array => .array,
        .pointer => |pointer| slice_shape(T, pointer),
        else => @compileError("json values take no " ++ @typeName(T) ++ " (decision 61)"),
    };
}

fn int_shape(comptime T: type, comptime int: std.builtin.Type.Int) Shape {
    if (int.bits > @bitSizeOf(u64)) @compileError("json integers take at most 64 bits, not " ++ @typeName(T));
    return if (int.signedness == .unsigned) .unsigned else .signed;
}

fn slice_shape(comptime T: type, comptime pointer: std.builtin.Type.Pointer) Shape {
    if (pointer.size != .slice or !pointer.is_const) @compileError("json values take const slices alone, not " ++ @typeName(T));
    return .slice;
}

/// The child type of an optional, an array or a slice.
pub fn Child(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .optional => |optional| optional.child,
        .array => |array| array.child,
        .pointer => |pointer| pointer.child,
        else => unreachable,
    };
}

/// The levels of a cursor that `T` takes: one for each struct or array that nests, at the most.
pub fn depth_of(comptime T: type) usize {
    return depth_within(T, 0);
}

fn depth_within(comptime T: type, comptime seen: usize) usize {
    // A type that nests deeper than any text the token decoder reads is recursive, or too deep.
    if (seen > constants.depth_max) @compileError("json value type nests too deep: " ++ @typeName(T));
    return switch (comptime shape_of(T)) {
        .optional => depth_within(Child(T), seen),
        .array, .slice => 1 + depth_within(Child(T), seen + 1),
        .structure => blk: {
            var deepest: usize = 0;
            inline for (std.meta.fields(T)) |field| deepest = @max(deepest, depth_within(field.type, seen + 1));
            break :blk 1 + deepest;
        },
        else => 0,
    };
}

/// The most fields any struct in `T` holds, which bounds the bits a decoder keeps a level.
pub fn fields_max(comptime T: type) usize {
    return switch (comptime shape_of(T)) {
        .optional, .array, .slice => fields_max(Child(T)),
        .structure => blk: {
            var most: usize = std.meta.fields(T).len;
            inline for (std.meta.fields(T)) |field| most = @max(most, fields_max(field.type));
            break :blk most;
        },
        else => 0,
    };
}

// Tests.

const testing = std.testing;

test "each type maps to its shape, and structs and arrays set the depth" {
    const Inner = struct { flag: bool, count: u8 };
    const Outer = struct { name: []const u8, inner: ?Inner, list: [2]Inner, values: []const i32, amount: Decimal };
    try testing.expectEqual(Shape.structure, shape_of(Outer));
    try testing.expectEqual(Shape.string, shape_of([]const u8));
    try testing.expectEqual(Shape.slice, shape_of([]const i32));
    try testing.expectEqual(Shape.decimal, shape_of(Decimal));
    try testing.expectEqual(Shape.signed, shape_of(i64));
    try testing.expectEqual(Shape.enumeration, shape_of(enum { a, b }));
    try testing.expectEqual(0, depth_of(u8));
    try testing.expectEqual(1, depth_of(Inner));
    try testing.expectEqual(3, depth_of(Outer));
    try testing.expectEqual(5, fields_max(Outer));
    try testing.expectEqual(2, fields_max([3]Inner));
}
