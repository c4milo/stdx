//! A number's text, which the token decoder has checked against RFC 8259 §6, read into an integer
//! or a `Decimal` (decision 61). A number its type cannot hold is `error.NumberOutOfRange`: an
//! integer past the type's range, a fraction for an integer, an exponent, or a fraction longer
//! than `constants.fraction_digits_max`.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Decimal = @import("../format.zig").Decimal;

pub const Error = error{NumberOutOfRange};

/// The value of `text` as a `U`.
pub fn integer(comptime U: type, text: []const u8) Error!U {
    assert(text.len > 0);
    const negative = text[0] == constants.minus;
    const magnitude = try digits_value(text[@intFromBool(negative)..]);
    if (!negative) return std.math.cast(U, magnitude) orelse error.NumberOutOfRange;
    if (magnitude == 0) return 0;
    // RFC 8259 §6: an implementation may limit the range and precision of numbers.
    if (@typeInfo(U).int.signedness == .unsigned) return error.NumberOutOfRange;
    // The most negative value's magnitude is one past the largest positive one.
    const largest: u64 = std.math.maxInt(U);
    // RFC 8259 §6: an implementation may limit the range and precision of numbers.
    if (magnitude > largest + 1) return error.NumberOutOfRange;
    return @intCast(-@as(i65, magnitude));
}

/// The value of `text` as a `Decimal`. A text with no fraction takes one fraction digit of 0, as a
/// `Decimal` holds one digit at least.
pub fn decimal(text: []const u8) Error!Decimal {
    assert(text.len > 0);
    const negative = text[0] == constants.minus;
    const unsigned_text = text[@intFromBool(negative)..];
    const point = std.mem.indexOfScalar(u8, unsigned_text, constants.decimal_point) orelse {
        return .{ .negative = negative, .integer = try digits_value(unsigned_text), .fraction = 0, .fraction_digits = 1 };
    };
    const fraction_text = unsigned_text[point + 1 ..];
    // RFC 8259 §6: an implementation may limit the range and precision of numbers.
    if (fraction_text.len > constants.fraction_digits_max) return error.NumberOutOfRange;
    return .{
        .negative = negative,
        .integer = try digits_value(unsigned_text[0..point]),
        .fraction = try digits_value(fraction_text),
        .fraction_digits = @intCast(fraction_text.len),
    };
}

/// The value of a run of decimal digits. Any other octet, a fraction's point or an exponent's
/// letter, makes the number one the type cannot hold.
fn digits_value(digits: []const u8) Error!u64 {
    assert(digits.len > 0);
    var value: u64 = 0;
    for (digits) |digit| {
        // RFC 8259 §6: an implementation may limit the range and precision of numbers.
        if (digit < constants.zero or digit > constants.nine) return error.NumberOutOfRange;
        // RFC 8259 §6: an implementation may limit the range and precision of numbers.
        const times_ten = std.math.mul(u64, value, constants.decimal_base) catch return error.NumberOutOfRange;
        // RFC 8259 §6: an implementation may limit the range and precision of numbers.
        value = std.math.add(u64, times_ten, digit - constants.zero) catch return error.NumberOutOfRange;
    }
    return value;
}

// Tests.

const testing = std.testing;

test "an integer's text reads within its type's range, and past it is refused" {
    try testing.expectEqual(255, try integer(u8, "255"));
    try testing.expectError(error.NumberOutOfRange, integer(u8, "256"));
    try testing.expectEqual(-128, try integer(i8, "-128"));
    try testing.expectError(error.NumberOutOfRange, integer(i8, "-129"));
    try testing.expectEqual(0, try integer(u8, "-0"));
    try testing.expectError(error.NumberOutOfRange, integer(u8, "-1"));
    try testing.expectEqual(std.math.maxInt(u64), try integer(u64, "18446744073709551615"));
    try testing.expectError(error.NumberOutOfRange, integer(u64, "18446744073709551616"));
    try testing.expectEqual(std.math.minInt(i64), try integer(i64, "-9223372036854775808"));
    try testing.expectError(error.NumberOutOfRange, integer(u8, "1.5"));
    try testing.expectError(error.NumberOutOfRange, integer(u8, "1e2"));
}

test "a decimal's text reads into its parts, and an exponent or a long fraction is refused" {
    try testing.expectEqual(Decimal{ .negative = true, .integer = 12, .fraction = 5, .fraction_digits = 2 }, try decimal("-12.05"));
    try testing.expectEqual(Decimal{ .integer = 7, .fraction = 0, .fraction_digits = 1 }, try decimal("7"));
    try testing.expectError(error.NumberOutOfRange, decimal("1.5e3"));
    try testing.expectError(error.NumberOutOfRange, decimal("0.12345678901234567890"));
}
