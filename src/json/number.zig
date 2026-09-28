//! A number's grammar, one octet at a time (RFC 8259 §6):
//!
//!     number = [ minus ] int [ frac ] [ exp ]
//!     int    = zero / ( digit1-9 *DIGIT )
//!     frac   = decimal-point 1*DIGIT
//!     exp    = e [ minus / plus ] 1*DIGIT
//!
//! The decoder checks each number of a text with it, and the encoder each number text a caller
//! passes. Neither turns a number into a value: its text is what either writes (decision 27).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// Where a number stands after the octets it has taken.
pub const State = enum(u8) {
    /// No octet yet.
    start,
    /// The minus sign.
    minus,
    /// The integer part is a lone zero, which no digit may follow.
    zero,
    /// The integer part has a digit from 1 to 9 and any digits after it.
    integer,
    /// The decimal point, which a digit must follow.
    point,
    /// The fraction has at least one digit.
    fraction,
    /// The exponent's `e` or `E`, which a sign or a digit must follow.
    exponent_mark,
    /// The exponent's sign, which a digit must follow.
    exponent_sign,
    /// The exponent has at least one digit.
    exponent,
};

/// What one octet does to a number.
pub const Step = enum {
    /// The octet belongs to the number.
    taken,
    /// The number was whole before the octet, which belongs to what follows it.
    ended,
    /// The octet cannot come next, and the number is not whole before it.
    invalid,
};

pub const Number = struct {
    state: State = .start,

    /// True when the octets taken so far are a whole number.
    pub fn whole(self: Number) bool {
        return switch (self.state) {
            .zero, .integer, .fraction, .exponent => true,
            .start, .minus, .point, .exponent_mark, .exponent_sign => false,
        };
    }

    /// Takes the next octet, and says whether it belongs to the number (RFC 8259 §6). A digit
    /// after a lone zero is invalid rather than the start of what follows: leading zeros are not
    /// allowed, and a caller would otherwise see the number 0 where the text holds none.
    pub inline fn accept(self: *Number, octet: u8) Step {
        if (self.state == .zero and is_digit(octet)) return .invalid;
        const next = next_state(self.state, octet) orelse return if (self.whole()) .ended else .invalid;
        self.state = next;
        return .taken;
    }
};

fn is_digit(octet: u8) bool {
    return octet >= constants.zero and octet <= constants.nine;
}

/// The octets RFC 8259 §6's grammar tells apart.
const Class = enum { zero, digit, minus, plus, point, exponent, other };

fn class_of(octet: u8) Class {
    if (octet == constants.zero) return .zero;
    if (is_digit(octet)) return .digit;
    return switch (octet) {
        constants.minus => .minus,
        constants.plus => .plus,
        constants.decimal_point => .point,
        constants.exponent_lower, constants.exponent_upper => .exponent,
        else => .other,
    };
}

/// Each state's next state for each class of octet, or null where RFC 8259 §6 allows none, in
/// the order of `Class`: zero, digit, minus, plus, point, exponent, other.
const transitions = std.enums.EnumArray(State, [std.enums.values(Class).len]?State).init(.{
    .start = .{ .zero, .integer, .minus, null, null, null, null },
    .minus = .{ .zero, .integer, null, null, null, null, null },
    .zero = .{ null, null, null, null, .point, .exponent_mark, null },
    .integer = .{ .integer, .integer, null, null, .point, .exponent_mark, null },
    .point = .{ .fraction, .fraction, null, null, null, null, null },
    .fraction = .{ .fraction, .fraction, null, null, null, .exponent_mark, null },
    .exponent_mark = .{ .exponent, .exponent, .exponent_sign, .exponent_sign, null, null, null },
    .exponent_sign = .{ .exponent, .exponent, null, null, null, null, null },
    .exponent = .{ .exponent, .exponent, null, null, null, null, null },
});

/// The state after `octet`, or null when the number cannot take it there.
inline fn next_state(state: State, octet: u8) ?State {
    return transitions.get(state)[@intFromEnum(class_of(octet))];
}

/// A whole number that an octet after it ends: the octets it took, and the machine after them.
pub const Ended = struct { len: usize, number: Number };

/// The number that starts `octets`, when it is whole and an octet of `octets` ends it (RFC 8259
/// §6), for claim J8. Null when an octet cannot come next and the number is not whole before it,
/// and when the number runs to the end of `octets`, where it may go on.
pub fn ended_in(octets: []const u8) ?Ended {
    var number: Number = .{};
    var index: usize = 0;
    // Each pass takes at least one octet, or returns.
    for (0..octets.len + 1) |_| {
        if (loops_on_digits(number.state)) index += digits_len(octets[index..]);
        if (index == octets.len) return null;
        switch (number.accept(octets[index])) {
            .taken => index += 1,
            .ended => return .{ .len = index, .number = number },
            .invalid => return null,
        }
    }
    unreachable;
}

/// True in the states a digit leaves as they are: an integer part past its first digit, a
/// fraction, and an exponent (`transitions`). There a run of digits takes no step of the machine.
fn loops_on_digits(state: State) bool {
    return state == .integer or state == .fraction or state == .exponent;
}

/// The run of digits that starts `octets`.
fn digits_len(octets: []const u8) usize {
    for (octets, 0..) |octet, index| {
        if (!is_digit(octet)) return index;
    }
    return octets.len;
}

/// True for an octet that can start a number (RFC 8259 §6).
pub fn starts_number(octet: u8) bool {
    return octet == constants.minus or is_digit(octet);
}

/// True when all of `text` is one number (RFC 8259 §6).
pub fn is_number(text: []const u8) bool {
    return whole_number(text) != null;
}

/// The machine after all of `text`, when `text` is one whole number (RFC 8259 §6), or null.
pub fn whole_number(text: []const u8) ?Number {
    var number: Number = .{};
    var index: usize = 0;
    // Each pass takes at least one octet, or returns.
    for (0..text.len + 1) |_| {
        if (loops_on_digits(number.state)) index += digits_len(text[index..]);
        if (index == text.len) return if (number.whole()) number else null;
        if (number.accept(text[index]) != .taken) return null;
        index += 1;
    }
    unreachable;
}

// Tests.

const testing = std.testing;

test "the numbers RFC 8259 §6's grammar allows are whole, and each octet is taken" {
    const numbers = [_][]const u8{ "0", "-0", "7", "42", "-12", "0.5", "-0.25", "1e9", "1E+9", "1e-9", "0e0", "3.141592653589793238462643383279", "1E400", "-9223372036854775808", "18446744073709551616", "1.0e-010" };
    for (numbers) |text| try testing.expect(is_number(text));
}

test "the texts RFC 8259 §6 refuses are not numbers" {
    const refused = [_][]const u8{ "", "-", "+1", ".5", "01", "-01", "00", "1.", "1.e5", "1e", "1e+", "1e-", "Infinity", "NaN", "--1", "1.2.3", "0x10", "1e5.0", " 1", "1 " };
    for (refused) |text| try testing.expect(!is_number(text));
}

test "a number ends before an octet that follows it, and a cut one does not" {
    var number: Number = .{};
    try testing.expectEqual(.taken, number.accept('1'));
    try testing.expectEqual(.taken, number.accept('2'));
    try testing.expectEqual(.ended, number.accept(','));
    try testing.expectEqual(State.integer, number.state);
    number = .{};
    try testing.expectEqual(.taken, number.accept('-'));
    try testing.expectEqual(.invalid, number.accept(','));
    number = .{};
    try testing.expectEqual(.taken, number.accept('0'));
    try testing.expectEqual(.invalid, number.accept('1'));
    try testing.expectEqual(.ended, number.accept(']'));
    number = .{ .state = .fraction };
    try testing.expectEqual(.ended, number.accept('.'));
}

test "ended_in finds a whole number an octet ends, and nothing where it is cut or invalid" {
    const ended = [_]struct { octets: []const u8, len: usize, state: State }{
        .{ .octets = "12,", .len = 2, .state = .integer },
        .{ .octets = "-0.5e+3]", .len = 7, .state = .exponent },
        .{ .octets = "0 ", .len = 1, .state = .zero },
        .{ .octets = "1.25}", .len = 4, .state = .fraction },
        .{ .octets = "7\x1e", .len = 1, .state = .integer },
    };
    for (ended) |case| {
        const found = ended_in(case.octets) orelse return error.TestExpectedEnded;
        try testing.expectEqual(case.len, found.len);
        try testing.expectEqual(case.state, found.number.state);
    }
    // Cut at the end, where it may go on, and invalid before its end.
    for ([_][]const u8{ "", "12", "-", "1.5e", "01,", "-,", "1.x", "1e+]" }) |octets| {
        try testing.expectEqual(null, ended_in(octets));
    }
}

test "loops_on_digits holds exactly where every digit leaves the machine's state as it is" {
    for (std.enums.values(State)) |state| {
        var loops = true;
        for (constants.zero..constants.nine + 1) |digit| loops = loops and next_state(state, @intCast(digit)) == state;
        try testing.expectEqual(loops, loops_on_digits(state));
    }
}

test "every text of up to six octets of the grammar's letters is judged as RFC 8259 §6's rules judge it" {
    var text: [6]u8 = undefined;
    const letters = "01-+.eEx";
    for (1..text.len + 1) |len| {
        var counter: [6]u8 = @splat(0);
        for (0..std.math.pow(usize, letters.len, len)) |_| {
            for (text[0..len], counter[0..len]) |*octet, index| octet.* = letters[index];
            try testing.expectEqual(Grammar.is_number(text[0..len]), is_number(text[0..len]));
            for (counter[0..len]) |*digit| {
                digit.* += 1;
                if (digit.* < letters.len) break;
                digit.* = 0;
            }
        }
    }
    try testing.expect(starts_number('-') and starts_number('0') and starts_number('9'));
    try testing.expect(!starts_number('+') and !starts_number('.') and !starts_number('e'));
}

/// The verdicts of spec/lean/Stdx/Json/Number.lean's machine, which the proofs there hold to RFC
/// 8259 §6 (decision 28): whether each state is whole, then a line per state and octet with
/// `accept`'s verdict and the state after a taken one. `zig build lean` checks the file is what that
/// machine gives.
const Proved = struct {
    const vectors = @embedFile("number_vectors.txt");
    const octets = 256;
    const radix = 10;
    /// `accept`, the state, the octet, `taken` and the state after it.
    const fields_max = 5;
    const state_field = 1;
    const octet_field = 2;
    const verdict_field = 3;
    const after_field = 4;

    /// Checks one line, and returns 1 for a verdict, 0 for a state's wholeness.
    fn check(line: []const u8) !usize {
        var fields: [fields_max][]const u8 = @splat("");
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        for (&fields) |*field| field.* = tokens.next() orelse break;
        if (tokens.next() != null) return error.TestVectorTooLong;
        const state = std.meta.stringToEnum(State, fields[state_field]) orelse return error.TestUnknownState;
        if (std.mem.eql(u8, fields[0], "whole")) {
            try testing.expectEqual(std.mem.eql(u8, fields[octet_field], "1"), (Number{ .state = state }).whole());
            return 0;
        }
        try testing.expectEqualStrings("accept", fields[0]);
        var number: Number = .{ .state = state };
        const verdict = number.accept(try std.fmt.parseInt(u8, fields[octet_field], radix));
        const expected = std.meta.stringToEnum(Step, fields[verdict_field]) orelse return error.TestUnknownVerdict;
        try testing.expectEqual(expected, verdict);
        const after = if (expected == .taken) std.meta.stringToEnum(State, fields[after_field]) orelse return error.TestUnknownState else state;
        try testing.expectEqual(after, number.state);
        return 1;
    }
};

test "Number gives every verdict of the machine proved to accept exactly RFC 8259 §6's numbers" {
    var lines = std.mem.splitScalar(u8, Proved.vectors, '\n');
    try testing.expect(std.mem.startsWith(u8, lines.first(), "#"));
    var verdicts: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        verdicts += try Proved.check(line);
    }
    try testing.expectEqual(std.enums.values(State).len * Proved.octets, verdicts);
}

/// RFC 8259 §6's rules read one after another, for the tests to judge by:
/// `[ minus ] int [ frac ] [ exp ]`.
const Grammar = struct {
    fn is_number(text: []const u8) bool {
        var index: usize = @intFromBool(text.len > 0 and text[0] == constants.minus);
        index = integer(text, index) orelse return false;
        index = fraction(text, index) orelse return false;
        index = exponent(text, index) orelse return false;
        return index == text.len;
    }

    /// int = zero / ( digit1-9 *DIGIT )
    fn integer(text: []const u8, start: usize) ?usize {
        if (start == text.len or !is_digit(text[start])) return null;
        if (text[start] == constants.zero) return start + 1;
        return digits(text, start + 1);
    }

    /// frac = decimal-point 1*DIGIT
    fn fraction(text: []const u8, start: usize) ?usize {
        if (start == text.len or text[start] != constants.decimal_point) return start;
        const end = digits(text, start + 1);
        return if (end > start + 1) end else null;
    }

    /// exp = e [ minus / plus ] 1*DIGIT
    fn exponent(text: []const u8, start: usize) ?usize {
        if (start == text.len or (text[start] != constants.exponent_lower and text[start] != constants.exponent_upper)) return start;
        var index = start + 1;
        if (index < text.len and (text[index] == constants.minus or text[index] == constants.plus)) index += 1;
        const end = digits(text, index);
        return if (end > index) end else null;
    }

    fn digits(text: []const u8, start: usize) usize {
        var index = start;
        while (index < text.len and is_digit(text[index])) index += 1;
        return index;
    }
};
