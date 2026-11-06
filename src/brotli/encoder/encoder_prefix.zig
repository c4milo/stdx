//! The encoder's prefix codes (RFC 7932 §3): a code for one block's symbol counts, built through
//! codec's shared builder (decision 62), and its description, in the simple form of §3.4 when four
//! symbols or fewer occur and in the complex form of §3.5 otherwise.
//!
//! A complex code's lengths go out as code length symbols: a length, 16 to repeat the previous
//! nonzero length, or 17 to repeat zero, each repeat's count in digits of base 4 or 8 that later
//! symbols of the same kind extend. The lengths after the last nonzero one are left out.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");

pub const Error = error{NoSpaceLeft};

/// The code of an alphabet of `alphabet_len` symbols: each symbol's length and code, and how its
/// description goes out.
pub fn Code(comptime alphabet_len: usize) type {
    return struct {
        pub const len = alphabet_len;

        lengths: [alphabet_len]u8,
        /// Each code, bit-reversed so it leaves least significant bit first (RFC 7932 §1.5.1).
        codes: [alphabet_len]u16,
        /// For a simple code: its symbols in the order the description lists them, and how many;
        /// 0 for a complex code.
        simple: [constants.simple_symbols_max]u16,
        simple_count: u3,
        tree_select: bool,
    };
}

/// Builds the code of `counts`, at least one of which is not zero.
pub fn build(comptime n: usize, counts: *const [n]u16, code: *Code(n)) void {
    build_limited(n, counts, constants.code_len_max, code);
}

/// Builds the code of `counts` with no code longer than `len_max` bits.
pub fn build_limited(comptime n: usize, counts: *const [n]u16, comptime len_max: u4, code: *Code(n)) void {
    comptime assert(len_max <= constants.code_len_max);
    var listed: [constants.simple_symbols_max]u16 = undefined;
    var used: usize = 0;
    for (counts, 0..) |count, symbol| {
        if (count == 0) continue;
        if (used < listed.len) listed[used] = @intCast(symbol);
        used += 1;
    }
    assert(used > 0);
    if (used > constants.simple_symbols_max) {
        code.simple_count = 0;
        codec.prefix_code.build_lengths(counts, len_max, &code.lengths);
        codec.prefix_code.build_codes(&code.lengths, &code.codes);
        return;
    }
    build_simple(n, counts, listed[0..used], code);
}

/// A simple code (RFC 7932 §3.4): its lengths are fixed by NSYM and the tree-select bit, given to
/// the symbols in the order the description lists them, so the most frequent comes first.
fn build_simple(comptime n: usize, counts: *const [n]u16, symbols: []u16, code: *Code(n)) void {
    std.mem.sort(u16, symbols, counts, more_frequent(n));
    @memset(&code.lengths, 0);
    // A code of one symbol takes no bits: its code is 0, which `build_codes` leaves unset.
    @memset(&code.codes, 0);
    code.simple_count = @intCast(symbols.len);
    code.tree_select = false;
    if (symbols.len == constants.simple_symbols_max) {
        // The tree-select bit's lengths when they code the symbols in fewer bits.
        const plain = constants.simple_code_lengths[constants.simple_symbols_max - constants.code_symbols_min];
        code.tree_select = bits_of(n, counts, symbols, &constants.simple_code_lengths_tree_select) < bits_of(n, counts, symbols, plain);
    }
    const lengths: []const u8 = if (symbols.len == 1) &.{0} else if (code.tree_select) &constants.simple_code_lengths_tree_select else constants.simple_code_lengths[symbols.len - constants.code_symbols_min];
    for (symbols, lengths, 0..) |symbol, len, index| {
        code.lengths[symbol] = len;
        code.simple[index] = symbol;
    }
    codec.prefix_code.build_codes(&code.lengths, &code.codes);
}

/// The bits `symbols`, in order, take with `lengths`.
fn bits_of(comptime n: usize, counts: *const [n]u16, symbols: []const u16, lengths: []const u8) u64 {
    var bits: u64 = 0;
    for (symbols, lengths) |symbol, len| bits += @as(u64, counts[symbol]) * len;
    return bits;
}

/// Orders symbols by count, the larger first, and by symbol among equal counts, so the code is a
/// function of the counts alone (invariant 5).
fn more_frequent(comptime n: usize) fn (*const [n]u16, u16, u16) bool {
    return struct {
        fn before(counts: *const [n]u16, left: u16, right: u16) bool {
            if (counts[left] != counts[right]) return counts[left] > counts[right];
            return left < right;
        }
    }.before;
}

/// Writes `symbol`'s code.
pub inline fn put_symbol(comptime n: usize, writer: *codec.BitWriter, code: *const Code(n), symbol: usize) Error!void {
    try put(writer, code.codes[symbol], @intCast(code.lengths[symbol]));
}

/// Writes the description of `code` (RFC 7932 §3.4, §3.5), its symbols `alphabet_bits` wide in the
/// simple form.
pub fn write(comptime n: usize, writer: *codec.BitWriter, code: *const Code(n), alphabet_bits: u4) Error!void {
    if (code.simple_count > 0) return write_simple(n, writer, code, alphabet_bits);
    return write_complex(writer, &code.lengths);
}

fn write_simple(comptime n: usize, writer: *codec.BitWriter, code: *const Code(n), alphabet_bits: u4) Error!void {
    // RFC 7932 §3.4: 1 for a simple code, NSYM - 1, the symbols, and the tree-select bit for four.
    try put(writer, constants.prefix_kind_simple, constants.prefix_kind_bits);
    try put(writer, code.simple_count - 1, constants.simple_count_bits);
    for (code.simple[0..code.simple_count]) |symbol| try put(writer, symbol, alphabet_bits);
    if (code.simple_count == constants.simple_symbols_max) try put(writer, @intFromBool(code.tree_select), 1);
}

/// A complex code's code length symbols, each with its extra bits, and their counts.
const Runs = struct {
    symbols: [constants.encoder_code_alphabet_len_max]u8,
    extra: [constants.encoder_code_alphabet_len_max]u8,
    len: usize,
    counts: [constants.code_length_alphabet_len]u16,

    fn push(self: *Runs, symbol: u8, extra: u8) void {
        self.symbols[self.len] = symbol;
        self.extra[self.len] = extra;
        self.len += 1;
        self.counts[symbol] += 1;
    }
};

fn write_complex(writer: *codec.BitWriter, lengths: []const u8) Error!void {
    var runs: Runs = .{ .symbols = undefined, .extra = undefined, .len = 0, .counts = @splat(0) };
    runs_of(lengths, &runs);
    var length_code: Code(constants.code_length_alphabet_len) = undefined;
    codec.prefix_code.build_lengths(&runs.counts, constants.code_length_code_len_max, &length_code.lengths);
    codec.prefix_code.build_codes(&length_code.lengths, &length_code.codes);
    try write_length_code(writer, &length_code.lengths);
    for (runs.symbols[0..runs.len], runs.extra[0..runs.len]) |symbol, extra| {
        try put_symbol(constants.code_length_alphabet_len, writer, &length_code, symbol);
        if (symbol == constants.repeat_previous_symbol) try put(writer, extra, constants.repeat_previous_extra_bits);
        if (symbol == constants.repeat_zero_symbol) try put(writer, extra, constants.repeat_zero_extra_bits);
    }
}

/// HSKIP and the code length code's lengths in RFC 7932 §3.5's order, each through the fixed code,
/// up to the last that is not zero. The builder gives two symbols a length at least.
fn write_length_code(writer: *codec.BitWriter, lengths: *const [constants.code_length_alphabet_len]u8) Error!void {
    const order = constants.code_length_code_order;
    // RFC 7932 §3.5: HSKIP 2 leaves out the lengths of symbols 1 and 2, and HSKIP 3 that of 3 too;
    // an HSKIP of 1 would name a simple code, so one zero alone is written.
    var skip: u2 = 0;
    for (order[0..constants.code_length_skip_max]) |symbol| {
        if (lengths[symbol] != 0) break;
        skip += 1;
    }
    if (skip == 1) skip = 0;
    var last: usize = 0;
    for (order, 0..) |symbol, index| {
        if (lengths[symbol] != 0) last = index;
    }
    try put(writer, skip, constants.prefix_kind_bits);
    for (order[skip .. last + 1]) |symbol| {
        const fixed = constants.code_length_code_length_codes[lengths[symbol]];
        try put(writer, fixed.code, fixed.len);
    }
}

/// The code length symbols of `lengths` up to the last nonzero one (RFC 7932 §3.5).
fn runs_of(lengths: []const u8, runs: *Runs) void {
    var end = lengths.len;
    for (0..lengths.len) |_| {
        if (end == 0 or lengths[end - 1] != 0) break;
        end -= 1;
    }
    var previous: u8 = constants.previous_len_initial;
    var at: usize = 0;
    for (0..end) |_| {
        if (at == end) break;
        const len = lengths[at];
        var run = run_len(lengths[at..end]);
        at += run;
        if (len == 0) {
            push_repeats(runs, 0, run, constants.repeat_zero_symbol, constants.repeat_zero_extra_bits);
            continue;
        }
        if (len != previous) {
            runs.push(len, 0);
            run -= 1;
            previous = len;
        }
        push_repeats(runs, len, run, constants.repeat_previous_symbol, constants.repeat_previous_extra_bits);
    }
}

/// The lengths at the front of `lengths` equal to its first.
fn run_len(lengths: []const u8) usize {
    for (lengths[1..], 1..) |len, index| {
        if (len != lengths[0]) return index;
    }
    return lengths.len;
}

/// `count` lengths of `len`: each alone below a repeat's 3, else repeat symbols whose extra bits
/// are the count's digits, the most significant first, each later one extending the count (RFC
/// 7932 §3.5).
fn push_repeats(runs: *Runs, len: u8, count: usize, symbol: u8, extra_bits: u2) void {
    if (count < constants.repeat_len_min) {
        for (0..count) |_| runs.push(len, 0);
        return;
    }
    var digits: [constants.repeat_digits_max]u8 = undefined;
    var digit_count: usize = 0;
    var rest = count - constants.repeat_len_min;
    const mask = (@as(usize, 1) << extra_bits) - 1;
    for (&digits) |*digit| {
        digit.* = @intCast(rest & mask);
        digit_count += 1;
        rest >>= extra_bits;
        if (rest == 0) break;
        rest -= 1;
    }
    var index = digit_count;
    for (0..digit_count) |_| {
        index -= 1;
        runs.push(symbol, digits[index]);
    }
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}

test {
    _ = @import("encoder_prefix_test.zig");
}
