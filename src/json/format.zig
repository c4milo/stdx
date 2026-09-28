//! The text of the numbers the encoder writes from values: unsigned and signed integers, and
//! fixed-point decimals, in the grammar of RFC 8259 §6, with no floating point (decision 27). Each
//! is a pure function of its value (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// A fixed-point decimal: an integer part, then a fraction with a fixed number of digits. It is
/// written `[-]integer.fraction`, the fraction with exactly `fraction_digits` digits, so that 1234,
/// 567 and 3 write "1234.567", and 0, 5 and 3 write "0.005".
pub const Decimal = struct {
    /// True for a number below zero, whose text starts with a minus sign.
    negative: bool = false,
    /// The integer part.
    integer: u64,
    /// The fraction's digits read as an integer, below 10 to the power `fraction_digits`.
    fraction: u64,
    /// The digits after the decimal point: at least one, which RFC 8259 §6 requires of a fraction,
    /// and at most `constants.fraction_digits_max`.
    fraction_digits: u5,
};

/// 10 to the power of each index, up to the most digits a fraction takes.
const powers_of_ten = powers: {
    var table: [constants.fraction_digits_max + 1]u64 = undefined;
    var power: u64 = 1;
    for (&table) |*entry| {
        entry.* = power;
        power *%= constants.decimal_base;
    }
    break :powers table;
};

/// The room one number's text takes at most.
pub const Buffer = [constants.number_text_len_max]u8;

/// Writes the decimal digits of `value` so that they end at `end`, with zeros before them up to
/// `digits_min` digits, and returns where they start.
fn digits_ending_at(buffer: *Buffer, end: usize, value: u64, digits_min: usize) usize {
    var start = end;
    var rest = value;
    for (0..constants.unsigned_digits_max) |written| {
        if (rest == 0 and written >= digits_min and written > 0) break;
        start -= 1;
        buffer[start] = constants.zero + @as(u8, @intCast(rest % constants.decimal_base));
        rest /= constants.decimal_base;
    }
    assert(rest == 0 and end - start >= @max(digits_min, 1));
    return start;
}

/// The text of `value`: its digits, with no leading zero.
pub fn unsigned(buffer: *Buffer, value: u64) []const u8 {
    return buffer[digits_ending_at(buffer, buffer.len, value, 1)..];
}

/// The text of `value`: a minus sign when it is below zero, then the digits of its magnitude.
pub fn signed(buffer: *Buffer, value: i64) []const u8 {
    var start = digits_ending_at(buffer, buffer.len, @abs(value), 1);
    if (value < 0) {
        start -= 1;
        buffer[start] = constants.minus;
    }
    return buffer[start..];
}

/// The text of `value`: `[-]integer.fraction`, the fraction in exactly `fraction_digits` digits.
pub fn decimal(buffer: *Buffer, value: Decimal) []const u8 {
    assert(value.fraction_digits >= 1 and value.fraction_digits <= constants.fraction_digits_max);
    assert(value.fraction < powers_of_ten[value.fraction_digits]);
    const point = digits_ending_at(buffer, buffer.len, value.fraction, value.fraction_digits) - 1;
    buffer[point] = constants.decimal_point;
    var start = digits_ending_at(buffer, point, value.integer, 1);
    if (value.negative) {
        start -= 1;
        buffer[start] = constants.minus;
    }
    return buffer[start..];
}

// Tests.

const testing = std.testing;
const codec = @import("codec");
const number = @import("number.zig");

test "integers are written as their decimal digits, with no leading zero" {
    var buffer: Buffer = undefined;
    try testing.expectEqualStrings("0", unsigned(&buffer, 0));
    try testing.expectEqualStrings("7", unsigned(&buffer, 7));
    try testing.expectEqualStrings("1200", unsigned(&buffer, 1200));
    try testing.expectEqualStrings("18446744073709551615", unsigned(&buffer, std.math.maxInt(u64)));
    try testing.expectEqualStrings("0", signed(&buffer, 0));
    try testing.expectEqualStrings("-1", signed(&buffer, -1));
    try testing.expectEqualStrings("9223372036854775807", signed(&buffer, std.math.maxInt(i64)));
    try testing.expectEqualStrings("-9223372036854775808", signed(&buffer, std.math.minInt(i64)));
}

test "a decimal is written with exactly its fraction's digits" {
    var buffer: Buffer = undefined;
    try testing.expectEqualStrings("1234.567", decimal(&buffer, .{ .integer = 1234, .fraction = 567, .fraction_digits = 3 }));
    try testing.expectEqualStrings("0.005", decimal(&buffer, .{ .integer = 0, .fraction = 5, .fraction_digits = 3 }));
    try testing.expectEqualStrings("0.000", decimal(&buffer, .{ .integer = 0, .fraction = 0, .fraction_digits = 3 }));
    try testing.expectEqualStrings("-0.5", decimal(&buffer, .{ .negative = true, .integer = 0, .fraction = 5, .fraction_digits = 1 }));
    try testing.expectEqualStrings("-122.3959", decimal(&buffer, .{ .negative = true, .integer = 122, .fraction = 3959, .fraction_digits = 4 }));
    try testing.expectEqualStrings(
        "-18446744073709551615.9999999999999999999",
        decimal(&buffer, .{ .negative = true, .integer = std.math.maxInt(u64), .fraction = 9999999999999999999, .fraction_digits = 19 }),
    );
    try testing.expectEqual(constants.number_text_len_max, decimal(&buffer, .{ .negative = true, .integer = std.math.maxInt(u64), .fraction = 0, .fraction_digits = 19 }).len);
}

test "every text written is a number of RFC 8259 §6" {
    var buffer: Buffer = undefined;
    var generator = codec.split.Generator.init(1);
    for (0..10_000) |_| {
        const value = generator.next();
        try testing.expect(number.is_number(unsigned(&buffer, value >> @intCast(value % 64))));
        try testing.expect(number.is_number(signed(&buffer, @bitCast(value))));
        const digits: u5 = @intCast(1 + value % 19);
        const fraction = (value >> 7) % powers_of_ten[digits];
        try testing.expect(number.is_number(decimal(&buffer, .{ .negative = value % 2 == 0, .integer = value >> 3, .fraction = fraction, .fraction_digits = digits })));
    }
}
