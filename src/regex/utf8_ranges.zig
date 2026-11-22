//! A pattern's UTF-8 for the `regex` module (RFC 3629): one scalar value read from a pattern, and
//! a range of scalar values split into sequences of octet ranges. The `utf8` module checks each
//! character, reads its scalar value and writes one as octets (decision 86).
//!
//! A program takes octets, so a class or a `.` that holds scalar values past U+007F becomes
//! alternatives of two to four octet ranges. `Splitter` cuts a range of scalar values until each
//! piece is every sequence between its first and its last, octet by octet. RE2 compiles its
//! classes the same way (decision 86 names the method's source).
const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const utf8 = @import("utf8");
const constants = @import("constants.zig");

/// One range of scalar values: the `unicode` module's range, so a class takes a property's ranges as
/// they are.
pub const ScalarRange = @import("unicode").Range;

pub const OctetRange = struct { lo: u8, hi: u8 };

/// One to four octet ranges: every sequence whose octets fall in them, in order.
pub const Sequence = struct {
    ranges: [constants.utf8_len_max]OctetRange,
    len: u32,
};

pub const DecodeError = error{InvalidUtf8};

/// The next scalar value of a pattern, or null at its end.
pub fn take_scalar(reader: *codec.Reader) DecodeError!?u32 {
    const ahead = reader.take_partial(constants.utf8_len_max);
    if (ahead.len == 0) return null;
    // RFC 3629 §4: a pattern is UTF-8, so its next octets start with one whole character. The
    // syntax holds no overlong form, no surrogate and no value past U+10FFFF.
    const len = utf8.character_len(ahead) orelse return error.InvalidUtf8;
    reader.unread(ahead.len);
    // The character is inside the octets read ahead, so the reader holds all of it.
    const character = reader.take(len) catch unreachable;
    return utf8.decode(character);
}

/// True for 10xxxxxx, an octet that continues a sequence (RFC 3629 §3).
pub fn is_continuation(octet: u8) bool {
    return octet >= constants.continuation_min and octet <= constants.continuation_max;
}

pub fn is_surrogate(scalar: u32) bool {
    return scalar >= constants.surrogate_min and scalar <= constants.surrogate_max;
}

/// The largest scalar value that one, two and three octets encode, by the octets less one.
const len_maxima = [_]u32{ constants.one_octet_max, constants.two_octets_max, constants.three_octets_max };

/// Cuts a range of scalar values into sequences of octet ranges. The surrogates are left out.
pub const Splitter = struct {
    stack: [constants.utf8_split_stack_len]ScalarRange = undefined,
    len: u32 = 0,
    /// The most ranges the stack held, which a test reads.
    len_peak: u32 = 0,

    pub fn init(lo: u32, hi: u32) Splitter {
        assert(lo <= hi and hi <= constants.scalar_max);
        var splitter: Splitter = .{};
        splitter.push(lo, hi);
        return splitter;
    }

    fn push(splitter: *Splitter, lo: u32, hi: u32) void {
        assert(splitter.len < constants.utf8_split_stack_len);
        splitter.stack[splitter.len] = .{ .lo = lo, .hi = hi };
        splitter.len += 1;
        splitter.len_peak = @max(splitter.len_peak, splitter.len);
    }

    pub fn next(splitter: *Splitter) ?Sequence {
        while (splitter.len > 0) {
            assert(splitter.len <= constants.utf8_split_stack_len);
            splitter.len -= 1;
            var range = splitter.stack[splitter.len];
            var cuts: u32 = 0;
            while (splitter.cut(&range)) : (cuts += 1) assert(cuts < constants.utf8_split_stack_len);
            if (range.lo <= range.hi) return sequence_of(range);
        }
        return null;
    }

    /// Cuts `range` once where it is not yet one sequence, and keeps the part cut off. True when
    /// it cut.
    fn cut(splitter: *Splitter, range: *ScalarRange) bool {
        if (splitter.cut_surrogates(range)) return true;
        if (range.lo > range.hi) return false;
        if (splitter.cut_length(range)) return true;
        return splitter.cut_continuation(range);
    }

    /// RFC 3629 §3: UTF-8 encodes no surrogate, so a range holds none.
    fn cut_surrogates(splitter: *Splitter, range: *ScalarRange) bool {
        if (range.lo < constants.surrogate_min and range.hi > constants.surrogate_max) {
            splitter.push(constants.surrogate_max + 1, range.hi);
            range.hi = constants.surrogate_min - 1;
            return true;
        }
        if (is_surrogate(range.lo)) range.lo = constants.surrogate_max + 1;
        if (is_surrogate(range.hi)) range.hi = constants.surrogate_min - 1;
        return false;
    }

    /// A sequence has one length, so a range ends where a longer encoding starts.
    fn cut_length(splitter: *Splitter, range: *ScalarRange) bool {
        for (len_maxima) |last| {
            if (range.lo <= last and range.hi > last) {
                splitter.push(last + 1, range.hi);
                range.hi = last;
                return true;
            }
        }
        return false;
    }

    /// Where the first and the last scalar value differ above their low `bits`, the low bits of
    /// the first must be all zeros and those of the last all ones: only then is every octet
    /// between the two encodings' octets, position by position, inside the range.
    fn cut_continuation(splitter: *Splitter, range: *ScalarRange) bool {
        for (1..utf8.encoded_len(@intCast(range.hi))) |tail_count| {
            const bits: u5 = @intCast(tail_count * constants.continuation_bits);
            const low: u32 = (@as(u32, 1) << bits) - 1;
            if (range.lo & ~low == range.hi & ~low) continue;
            if (range.lo & low != 0) {
                splitter.push((range.lo | low) + 1, range.hi);
                range.hi = range.lo | low;
                return true;
            }
            if (range.hi & low != low) {
                splitter.push(range.hi & ~low, range.hi);
                range.hi = (range.hi & ~low) - 1;
                return true;
            }
        }
        return false;
    }
};

fn sequence_of(range: ScalarRange) Sequence {
    const len = utf8.encoded_len(@intCast(range.lo));
    assert(utf8.encoded_len(@intCast(range.hi)) == len);
    var first: [constants.utf8_len_max]u8 = undefined;
    var last: [constants.utf8_len_max]u8 = undefined;
    utf8.encode(@intCast(range.lo), first[0..len]);
    utf8.encode(@intCast(range.hi), last[0..len]);
    var sequence: Sequence = .{ .ranges = undefined, .len = @intCast(len) };
    for (0..len) |index| {
        assert(first[index] <= last[index]);
        sequence.ranges[index] = .{ .lo = first[index], .hi = last[index] };
    }
    return sequence;
}

const testing = std.testing;

fn expect_scalars(text: []const u8, expected: []const u32) !void {
    var reader = codec.Reader.init(text);
    for (expected) |scalar| try testing.expectEqual(@as(?u32, scalar), try take_scalar(&reader));
    try testing.expectEqual(@as(?u32, null), try take_scalar(&reader));
}

test "take_scalar reads each length, and the first and the last scalar value of each" {
    try expect_scalars("a\xC3\xA9\xE2\x82\xAC\xF0\x9F\x98\x80", &.{ 'a', 0xE9, 0x20AC, 0x1F600 });
    try expect_scalars("\x00\x7F\xC2\x80\xDF\xBF\xE0\xA0\x80\xEF\xBF\xBF", &.{ 0, 0x7F, 0x80, 0x7FF, 0x800, 0xFFFF });
    try expect_scalars("\xED\x9F\xBF\xEE\x80\x80\xF0\x90\x80\x80\xF4\x8F\xBF\xBF", &.{ 0xD7FF, 0xE000, 0x10000, 0x10FFFF });
}

fn expect_invalid(text: []const u8) !void {
    var reader = codec.Reader.init(text);
    try testing.expectError(error.InvalidUtf8, take_scalar(&reader));
}

test "take_scalar refuses what RFC 3629 §4's syntax does not hold" {
    // A continuation octet first, and the two leading octets of an overlong pair.
    try expect_invalid("\x80");
    try expect_invalid("\xBF");
    try expect_invalid("\xC0\x80");
    try expect_invalid("\xC1\xBF");
    // Overlong forms of three and four octets.
    try expect_invalid("\xE0\x9F\xBF");
    try expect_invalid("\xF0\x8F\xBF\xBF");
    // The surrogates, and the first value past U+10FFFF.
    try expect_invalid("\xED\xA0\x80");
    try expect_invalid("\xED\xBF\xBF");
    try expect_invalid("\xF4\x90\x80\x80");
    try expect_invalid("\xF5\x80\x80\x80");
    try expect_invalid("\xFF");
    // A sequence cut short, and a tail that is not one.
    try expect_invalid("\xC3");
    try expect_invalid("\xE2\x82");
    try expect_invalid("\xF0\x9F\x98");
    try expect_invalid("\xC3\x28");
    try expect_invalid("\xE2\x82\xC0");
}

fn expect_sequences(lo: u32, hi: u32, expected: []const []const OctetRange) !void {
    var splitter = Splitter.init(lo, hi);
    for (expected) |ranges| {
        const sequence = splitter.next() orelse return error.TestExpectedSequence;
        try testing.expectEqualSlices(OctetRange, ranges, sequence.ranges[0..sequence.len]);
    }
    try testing.expectEqual(@as(?Sequence, null), splitter.next());
}

fn r(lo: u8, hi: u8) OctetRange {
    return .{ .lo = lo, .hi = hi };
}

test "Splitter gives every scalar value as the sequences of RFC 3629 §4's syntax" {
    try expect_sequences(0, constants.scalar_max, &.{
        &.{r(0x00, 0x7F)},
        &.{ r(0xC2, 0xDF), r(0x80, 0xBF) },
        &.{ r(0xE0, 0xE0), r(0xA0, 0xBF), r(0x80, 0xBF) },
        &.{ r(0xE1, 0xEC), r(0x80, 0xBF), r(0x80, 0xBF) },
        &.{ r(0xED, 0xED), r(0x80, 0x9F), r(0x80, 0xBF) },
        &.{ r(0xEE, 0xEF), r(0x80, 0xBF), r(0x80, 0xBF) },
        &.{ r(0xF0, 0xF0), r(0x90, 0xBF), r(0x80, 0xBF), r(0x80, 0xBF) },
        &.{ r(0xF1, 0xF3), r(0x80, 0xBF), r(0x80, 0xBF), r(0x80, 0xBF) },
        &.{ r(0xF4, 0xF4), r(0x80, 0x8F), r(0x80, 0xBF), r(0x80, 0xBF) },
    });
}

test "Splitter cuts a range inside one length at each octet that is not whole" {
    try expect_sequences('a', 'z', &.{&.{r('a', 'z')}});
    try expect_sequences(0xE9, 0xE9, &.{&.{ r(0xC3, 0xC3), r(0xA9, 0xA9) }});
    try expect_sequences(0xA0, 0x13F, &.{
        &.{ r(0xC2, 0xC2), r(0xA0, 0xBF) },
        &.{ r(0xC3, 0xC4), r(0x80, 0xBF) },
    });
    try expect_sequences(0x7F, 0x80, &.{ &.{r(0x7F, 0x7F)}, &.{ r(0xC2, 0xC2), r(0x80, 0x80) } });
    try expect_sequences(0xD800, 0xDFFF, &.{});
    try expect_sequences(0xD7FF, 0xE000, &.{
        &.{ r(0xED, 0xED), r(0x9F, 0x9F), r(0xBF, 0xBF) },
        &.{ r(0xEE, 0xEE), r(0x80, 0x80), r(0x80, 0x80) },
    });
}

/// True when the sequence holds the octets of `scalar`.
fn holds(sequence: Sequence, scalar: u32) bool {
    var octets: [constants.utf8_len_max]u8 = undefined;
    const len = utf8.encoded_len(@intCast(scalar));
    if (len != sequence.len) return false;
    utf8.encode(@intCast(scalar), octets[0..len]);
    for (sequence.ranges[0..sequence.len], octets[0..sequence.len]) |range, octet| {
        if (octet < range.lo or octet > range.hi) return false;
    }
    return true;
}

/// The scalar values a sequence holds: the product of its ranges' sizes.
fn sequence_size(sequence: Sequence) u64 {
    var size: u64 = 1;
    for (sequence.ranges[0..sequence.len]) |range| size *= @as(u64, range.hi - range.lo) + 1;
    return size;
}

/// The scalar values of a range, the surrogates left out.
fn range_size(lo: u32, hi: u32) u64 {
    var size: u64 = @as(u64, hi - lo) + 1;
    const first = @max(lo, constants.surrogate_min);
    const last = @min(hi, constants.surrogate_max);
    if (first <= last) size -= @as(u64, last - first) + 1;
    return size;
}

/// The sequences of a range hold as many scalar values as the range, hold both of its ends, and
/// hold neither neighbour, so they hold the range and nothing else.
fn expect_exact(lo: u32, hi: u32) !u32 {
    var splitter = Splitter.init(lo, hi);
    var total: u64 = 0;
    var holds_lo = false;
    var holds_hi = false;
    while (splitter.next()) |sequence| {
        total += sequence_size(sequence);
        holds_lo = holds_lo or holds(sequence, lo);
        holds_hi = holds_hi or holds(sequence, hi);
        if (lo > 0 and !is_surrogate(lo - 1)) try testing.expect(!holds(sequence, lo - 1));
        if (hi < constants.scalar_max and !is_surrogate(hi + 1)) try testing.expect(!holds(sequence, hi + 1));
    }
    try testing.expectEqual(range_size(lo, hi), total);
    try testing.expectEqual(!is_surrogate(lo), holds_lo);
    try testing.expectEqual(!is_surrogate(hi), holds_hi);
    return splitter.len_peak;
}

test "Splitter holds exactly its range, for every pair of the values where an encoding changes" {
    const edges = [_]u32{
        0x00,    0x01,    0x3F,     0x40,     0x7F,     0x80,   0xBF,    0xC0,    0xFF,    0x100,
        0x7BF,   0x7C0,   0x7FF,    0x800,    0x83F,    0x840,  0xFFF,   0x1000,  0xCFFF,  0xD000,
        0xD7FF,  0xD800,  0xDBFF,   0xDFFF,   0xE000,   0xFFFF, 0x10000, 0x1003F, 0x10FFF, 0x3FFFF,
        0x40000, 0xFFFFF, 0x100000, 0x10FFBF, 0x10FFFF,
    };
    var peak: u32 = 0;
    for (edges) |lo| {
        for (edges) |hi| {
            if (lo > hi) continue;
            peak = @max(peak, try expect_exact(lo, hi));
        }
    }
    // The stack's size is a named limit: the peak a range reaches stays inside it.
    try testing.expect(peak <= constants.utf8_split_stack_len);
}

test "Splitter holds exactly its range, for seeded ranges" {
    var generator = codec.testing.split.Generator.init(0x5EED);
    var peak: u32 = 0;
    for (0..4096) |_| {
        const first: u32 = @intCast(generator.below(constants.scalar_max + 1));
        const second: u32 = @intCast(generator.below(constants.scalar_max + 1));
        peak = @max(peak, try expect_exact(@min(first, second), @max(first, second)));
    }
    try testing.expect(peak <= constants.utf8_split_stack_len);
}
