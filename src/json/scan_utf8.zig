//! The UTF-8 check of claim J5 a block at a time (RFC 3629 §4), split from scan.zig: the lanes of a
//! block whose octet UTF-8 rules out there, given the block before it. Two forms give the same
//! verdict on every block: `error_lanes_compares`, each rule as a compare against a splat, the
//! reference; and `error_octets_lookup`, three lookups of 16 entries by the nibbles of each octet
//! and the one before it, in one instruction each where the target has one (decision 37).
//! `error_lanes` takes the lookup where it can, and `error_octets` gives the lookup's verdict as
//! octets, before any compare to bools, for `valid`, the check over a whole buffer (decision 38).
//! The tables are built here from RFC 3629 §4's rules, and the tests require the lookup to judge
//! every pair of octets as utf8.zig's machine does.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const utf8 = @import("utf8.zig");

fn Block(comptime width: usize) type {
    return @Vector(width, u8);
}

fn Lanes(comptime width: usize) type {
    return @Vector(width, bool);
}

fn splat(comptime width: usize, octet: u8) Block(width) {
    return @splat(octet);
}

/// Whether this target looks 16 lanes up in a table of 16 in one instruction: NEON's TBL on
/// aarch64, and VPSHUFB on x86-64 with AVX2, which the module's baseline target lacks and its AVX2
/// variant object has (decision 37, string_walk.zig).
pub const has_lookup = builtin.cpu.arch == .aarch64 or (builtin.cpu.arch == .x86_64 and std.Target.x86.featureSetHas(builtin.cpu.features, .avx2));

/// The lanes of `block` whose octet UTF-8 rules out there, given the lanes before it and the last
/// three of `previous` (RFC 3629 §4). `previous` ends between characters, or inside a character
/// whose octets `block` goes on with. The two forms may flag an octet UTF-8 never holds on its own
/// lane or on the next; every caller ends its run before the first lane flagged and steps back over
/// a cut character (`cut_character_len`), so both give the same run.
pub inline fn error_lanes(comptime width: usize, previous: Block(width), block: Block(width)) Lanes(width) {
    if (comptime has_lookup and width == constants.vector_len) return error_octets_lookup(previous, block) != splat(width, 0);
    return error_lanes_compares(width, previous, block);
}

/// `error_lanes` as octets: nonzero on a lane the check flags, zero on the others. The lookup gives
/// its verdict as octets before any compare to bools, so a caller that ORs many blocks' verdicts
/// and tests them once saves a compare a block.
pub inline fn error_octets(previous: Block(constants.vector_len), block: Block(constants.vector_len)) Block(constants.vector_len) {
    const width = constants.vector_len;
    if (comptime has_lookup) return error_octets_lookup(previous, block);
    return @select(u8, error_lanes_compares(width, previous, block), splat(width, std.math.maxInt(u8)), splat(width, 0));
}

/// `error_lanes` as a compare against a splat for each rule. A lane holds when:
/// - a continuation octet stands where no first octet asks for one, or another octet stands where
///   one does;
/// - the octet is C0, C1 or from F5 up, which UTF-8 never holds;
/// - the octet follows E0, ED, F0 or F4 outside the narrower range RFC 3629 §4 gives it there.
pub inline fn error_lanes_compares(comptime width: usize, previous: Block(width), block: Block(width)) Lanes(width) {
    var asked: Lanes(width) = @splat(false);
    inline for (1..constants.utf8_len_max) |back| {
        asked |= shifted_in(width, back, previous, block) >= splat(width, constants.reaching_lead_min[back]);
    }
    const continuation = (block >= splat(width, constants.continuation_min)) & (block <= splat(width, constants.continuation_max));
    const overlong_first = (block >= splat(width, constants.overlong_lead_2_min)) & (block < splat(width, constants.lead_2_min));
    const never = overlong_first | (block >= splat(width, constants.invalid_min));
    const back_1 = shifted_in(width, 1, previous, block);
    const overlong_3 = (back_1 == splat(width, constants.lead_3_overlong)) & (block < splat(width, constants.lead_3_overlong_second_min));
    const surrogate = (back_1 == splat(width, constants.lead_3_surrogate)) & (block > splat(width, constants.lead_3_surrogate_second_max));
    const overlong_4 = (back_1 == splat(width, constants.lead_4_overlong)) & (block < splat(width, constants.lead_4_overlong_second_min));
    const past_last = (back_1 == splat(width, constants.lead_4_largest)) & (block > splat(width, constants.lead_4_largest_second_max));
    return (continuation != asked) | never | overlong_3 | surrogate | overlong_4 | past_last;
}

/// The lanes of `block` moved up by `count`, with the last `count` lanes of `previous` below them.
pub fn shifted_in(comptime width: usize, comptime count: usize, previous: Block(width), block: Block(width)) Block(width) {
    const mask = comptime shift_mask(width, count);
    return @shuffle(u8, previous, block, mask);
}

fn shift_mask(comptime width: usize, comptime count: usize) @Vector(width, i32) {
    var mask: [width]i32 = undefined;
    for (&mask, 0..) |*lane, index| {
        lane.* = if (index >= count) ~@as(i32, @intCast(index - count)) else @intCast(width - count + index);
    }
    return mask;
}

/// The octets at the end of `octets` that start a character it cuts, when all before them is whole
/// UTF-8 and the last character's continuation octets are right for their first octet.
pub fn cut_character_len(octets: []const u8) usize {
    // `@min` with a comptime operand narrows its type, so the bound is widened before the `+ 1`.
    const from_end_max: usize = @min(octets.len, constants.utf8_len_max - 1);
    for (1..from_end_max + 1) |from_end| {
        const octet = octets[octets.len - from_end];
        if (octet < constants.continuation_min or octet > constants.continuation_max) {
            // A first octet asks for as many continuation octets as it reaches past itself.
            var reach: usize = 0;
            for (constants.reaching_lead_min[1..]) |lead_min| reach += @intFromBool(octet >= lead_min);
            return if (reach >= from_end) from_end else 0;
        }
    }
    return 0;
}

/// Whether `octets` is UTF-8 whole (RFC 3629 §4): the check a string's octets go through in the
/// walk, run alone over a buffer (decision 38). A group of `utf8_group_len` octets goes through
/// `group_error_octets`, then the blocks after the last group one at a time, and the last octets
/// through utf8.zig's machine. The json module's `is_utf8` for a caller, and bench-json's candidate
/// beside simdutf's `validate_utf8`.
pub fn valid(octets: []const u8) bool {
    const width = constants.vector_len;
    var previous: Block(width) = @splat(0);
    var index: usize = 0;
    // The groups' verdicts are ORed and read once: a group's verdict read as a scalar would cost the
    // ASCII path a second transfer out of the vector unit, and the verdict is the same at the end.
    var errors: Block(width) = @splat(0);
    for (0..octets.len / constants.utf8_group_len) |_| {
        errors |= group_error_octets(&previous, octets[index..][0..constants.utf8_group_len]);
        index += constants.utf8_group_len;
    }
    if (@reduce(.Max, errors) != 0) return false;
    for (0..(octets.len - index) / width) |_| {
        const block: Block(width) = octets[index..][0..width].*;
        if (@reduce(.Or, error_lanes(width, previous, block))) return false;
        previous = block;
        index += width;
    }
    // The blocks judged every octet but a character the last one cuts; the machine takes that
    // character's first octets again with the tail, and must end between characters.
    const cut_len = cut_character_len(octets[0..index]);
    var machine: utf8.Utf8 = .{};
    for (octets[index - cut_len ..]) |octet| {
        if (!machine.accept(octet)) return false;
    }
    return machine.between_characters();
}

/// The verdict on a group of `utf8_group_blocks` blocks as octets, nonzero on a lane the check
/// flags, with `previous` moved to the group's last block. A group of ASCII costs one test, and
/// breaks nothing but a character the block before it cut, whose first octets `incomplete_octets`
/// flags; any other group runs `error_octets` a block at a time and ORs the verdicts.
fn group_error_octets(previous: *Block(constants.vector_len), group: *const [constants.utf8_group_len]u8) Block(constants.vector_len) {
    const width = constants.vector_len;
    var blocks: [constants.utf8_group_blocks]Block(width) = undefined;
    var all: Block(width) = @splat(0);
    inline for (&blocks, 0..) |*block, block_index| {
        block.* = loaded(width, group[block_index * width ..][0..width].*);
        all |= block.*;
    }
    if (!has_non_ascii(all)) {
        const errors = incomplete_octets(previous.*);
        previous.* = blocks[constants.utf8_group_blocks - 1];
        return errors;
    }
    var errors: Block(width) = @splat(0);
    inline for (blocks) |block| {
        errors |= error_octets(previous.*, block);
        previous.* = block;
    }
    return errors;
}

/// `block` as one register. `shifted_in` reads a block's low lanes alone, and for those reads LLVM
/// split each block's load into a load of 13 lanes and three loads of one lane, with a copy of the
/// register between them: 24 loads and 12 copies a group of four blocks in place of 4 loads. An
/// empty assembly statement that takes the block in a vector register and gives it back makes the
/// whole register the value the shuffles read. `valid`'s groups and scan.zig's `utf8_run` take
/// each block through it; a block wider than 16 octets, which only the tests scan, passes as it is.
pub inline fn loaded(comptime width: usize, block: Block(width)) Block(width) {
    if (comptime width != constants.vector_len) return block;
    return switch (builtin.cpu.arch) {
        .aarch64 => asm (""
            : [ret] "=w" (-> Block(width)),
            : [block] "0" (block),
        ),
        .x86_64 => asm (""
            : [ret] "=x" (-> Block(width)),
            : [block] "0" (block),
        ),
        else => block,
    };
}

/// Whether `block` holds an octet from 0x80 up: on x86-64 from the sign bits, which one instruction
/// gathers into a mask; elsewhere from the largest octet, which one instruction gives, and which ran
/// 4% faster than a compare on an M-series host.
inline fn has_non_ascii(block: Block(constants.vector_len)) bool {
    const width = constants.vector_len;
    if (comptime builtin.cpu.arch == .x86_64) return @reduce(.Or, @as(@Vector(width, i8), @bitCast(block)) < @as(@Vector(width, i8), @splat(0)));
    return @reduce(.Max, block) >= constants.non_ascii_min;
}

/// Nonzero on the lanes of `block` that start a character the block cuts: a first octet on the last
/// lane, one that asks for two continuation octets on the lane before, and one that asks for three
/// on the lane before that (RFC 3629 §3). `cut_character_len` as lanes, for a block whose every
/// other octet is judged.
fn incomplete_octets(block: Block(constants.vector_len)) Block(constants.vector_len) {
    const width = constants.vector_len;
    return @select(u8, block > incomplete_max, splat(width, std.math.maxInt(u8)), splat(width, 0));
}

/// The largest octet each lane of a block holds without starting a character the block cuts: on
/// the last lane, one below the least first octet that reaches one octet past itself, and so on
/// back; and every octet on the lanes before those.
const incomplete_max: Block(constants.vector_len) = blk: {
    var lanes: [constants.vector_len]u8 = @splat(std.math.maxInt(u8));
    for (1..constants.utf8_len_max) |back| lanes[constants.vector_len - back] = constants.reaching_lead_min[back] - 1;
    break :blk lanes;
};

// The lookup (decision 37).

/// What a pair of octets, the one before and the one on a lane, can break of RFC 3629 §4, one bit
/// each. The three tables below hold, for a nibble, the bits the pairs with that nibble can break;
/// their AND for a pair leaves the bits it does break. `two_continuations_bit` breaks nothing by itself:
/// it marks a continuation octet after a continuation octet, which is right where a first octet two
/// or three lanes back asks for it and wrong elsewhere, judged apart in `error_octets_lookup`.
const Breaks = packed struct(u8) {
    too_short: bool = false,
    too_long: bool = false,
    overlong_2: bool = false,
    surrogate: bool = false,
    overlong_3: bool = false,
    too_large: bool = false,
    overlong_4: bool = false,
    two_continuations: bool = false,

    fn bits(self: Breaks) u8 {
        return @bitCast(self);
    }
};
const too_short_bit = (Breaks{ .too_short = true }).bits();
const too_long_bit = (Breaks{ .too_long = true }).bits();
const overlong_2_bit = (Breaks{ .overlong_2 = true }).bits();
const surrogate_bit = (Breaks{ .surrogate = true }).bits();
const overlong_3_bit = (Breaks{ .overlong_3 = true }).bits();
const too_large_bit = (Breaks{ .too_large = true }).bits();
const overlong_4_bit = (Breaks{ .overlong_4 = true }).bits();
const two_continuations_bit = (Breaks{ .two_continuations = true }).bits();
/// Every bit but `two_continuations_bit`: a pair that breaks a rule.
const breaks_a_rule: u8 = ~two_continuations_bit;
/// The bits a first octet of any low nibble can break, by its high nibble alone.
const any_low_nibble: u8 = too_short_bit | too_long_bit | two_continuations_bit;

const nibbles = 1 << constants.nibble_bits;

fn high_nibble(octet: u8) u8 {
    return octet >> constants.nibble_bits;
}

fn low_nibble(octet: u8) u8 {
    return octet & constants.nibble_mask;
}

/// Whether an octet with `high` as its high nibble is a continuation octet (RFC 3629 §3).
fn continues(high: u8) bool {
    return high >= high_nibble(constants.continuation_min) and high <= high_nibble(constants.continuation_max);
}

/// By the high nibble of the octet before: an octet below 0x80 must not be followed by a
/// continuation octet; a continuation octet may be; a first octet must be, and C0 up, E0 up and F0
/// up can each start a form the second octet's range rules out.
const before_high_table: [nibbles]u8 = table: {
    var table: [nibbles]u8 = undefined;
    for (&table, 0..) |*entry, high| {
        const octet: u8 = @intCast(high << constants.nibble_bits);
        entry.* = if (octet < constants.non_ascii_min) too_long_bit else if (continues(@intCast(high))) two_continuations_bit else too_short_bit;
        if (octet == high_nibble(constants.overlong_lead_2_min) << constants.nibble_bits) entry.* |= overlong_2_bit;
        if (octet == constants.lead_3_min) entry.* |= surrogate_bit | overlong_3_bit;
        if (octet == constants.lead_4_min) entry.* |= too_large_bit | overlong_4_bit;
    }
    break :table table;
};

/// By the low nibble of the octet before: which of C0 and C1, E0, ED, F0, F4 and F5 up it can be.
const before_low_table: [nibbles]u8 = table: {
    var table: [nibbles]u8 = @splat(any_low_nibble);
    for (&table, 0..) |*entry, low| {
        if (low == low_nibble(constants.overlong_lead_2_min) or low == low_nibble(constants.lead_2_min - 1)) entry.* |= overlong_2_bit;
        if (low == low_nibble(constants.lead_3_overlong)) entry.* |= overlong_3_bit;
        if (low == low_nibble(constants.lead_3_surrogate)) entry.* |= surrogate_bit;
        if (low == low_nibble(constants.lead_4_overlong)) entry.* |= overlong_4_bit;
        if (low >= low_nibble(constants.lead_4_largest)) entry.* |= too_large_bit;
        if (low >= low_nibble(constants.invalid_min)) entry.* |= overlong_4_bit;
    }
    break :table table;
};

/// By the high nibble of the octet itself: whether it is a continuation octet, and which of the
/// narrower second-octet ranges it falls outside of.
const octet_high_table: [nibbles]u8 = table: {
    var table: [nibbles]u8 = undefined;
    for (&table, 0..) |*entry, high| {
        if (!continues(@intCast(high))) {
            entry.* = too_short_bit;
            continue;
        }
        entry.* = too_long_bit | two_continuations_bit | overlong_2_bit;
        if (high < high_nibble(constants.lead_3_overlong_second_min)) entry.* |= overlong_3_bit;
        if (high > high_nibble(constants.lead_3_surrogate_second_max)) entry.* |= surrogate_bit;
        if (high < high_nibble(constants.lead_4_overlong_second_min)) entry.* |= overlong_4_bit;
        if (high > high_nibble(constants.lead_4_largest_second_max)) entry.* |= too_large_bit;
    }
    break :table table;
};

/// How far back a character's first octet stands from its third octet and from its fourth.
const third_octet_distance = 2;
const fourth_octet_distance = 3;

/// The rules a pair breaks: the octet before, then the octet, as the tables see them.
fn pair_bits(before: u8, octet: u8) u8 {
    return before_high_table[high_nibble(before)] & before_low_table[low_nibble(before)] & octet_high_table[high_nibble(octet)];
}

/// Each lane of `indices`, a nibble, looked up in `table`: NEON's TBL, or x86-64's VPSHUFB. Register
/// operands only, as decision 16 admits.
inline fn lookup(table: Block(constants.vector_len), indices: Block(constants.vector_len)) Block(constants.vector_len) {
    comptime assert(has_lookup and constants.vector_len == nibbles);
    return switch (builtin.cpu.arch) {
        .aarch64 => asm ("tbl %[result].16b, {%[table].16b}, %[indices].16b"
            : [result] "=w" (-> Block(constants.vector_len)),
            : [table] "w" (table),
              [indices] "w" (indices),
        ),
        .x86_64 => asm ("vpshufb %[indices], %[table], %[result]"
            : [result] "=x" (-> Block(constants.vector_len)),
            : [table] "x" (table),
              [indices] "x" (indices),
        ),
        else => unreachable,
    };
}

/// `error_octets` from the three tables: `pair_bits` for each lane and the octet before it, three
/// lookups; then a continuation octet after a continuation octet is right only where the octet two
/// or three lanes back asks for it (RFC 3629 §3), and an octet is wrong there when it is not one.
/// The lookups leave `two_continuations_bit` set on a lane of a continuation octet after one, and
/// the bit is XORed with the lanes asked, so it stays set where the two differ; the other bits stay
/// as the lookups set them, one for each rule the pair breaks. A lane is left nonzero exactly when
/// its octet breaks a rule.
inline fn error_octets_lookup(previous: Block(constants.vector_len), block: Block(constants.vector_len)) Block(constants.vector_len) {
    const width = constants.vector_len;
    const before = shifted_in(width, 1, previous, block);
    const bits = lookup(before_high_table, before >> @splat(constants.nibble_bits)) & lookup(before_low_table, before & splat(width, constants.nibble_mask)) & lookup(octet_high_table, block >> @splat(constants.nibble_bits));
    const asked_two_or_three_back = (shifted_in(width, third_octet_distance, previous, block) >= splat(width, constants.lead_3_min)) | (shifted_in(width, fourth_octet_distance, previous, block) >= splat(width, constants.lead_4_min));
    return bits ^ @select(u8, asked_two_or_three_back, splat(width, two_continuations_bit), splat(width, 0));
}

// Tests.

const testing = std.testing;

/// The states utf8.zig's machine reaches from between characters, over every octet.
fn reachable_states() [constants.utf8_len_max * constants.utf8_len_max]?utf8.Utf8 {
    var states: [constants.utf8_len_max * constants.utf8_len_max]?utf8.Utf8 = @splat(null);
    states[0] = .{};
    var count: usize = 1;
    var next: usize = 0;
    while (next < count) : (next += 1) {
        for (0..std.math.maxInt(u8) + 1) |value| {
            var state = states[next].?;
            if (!state.accept(@intCast(value))) continue;
            var known = false;
            for (states[0..count]) |seen| known = known or std.meta.eql(seen.?, state);
            if (known) continue;
            states[count] = state;
            count += 1;
        }
    }
    return states;
}

/// Whether some UTF-8 holds `before` and then `octet` next to each other, by the machine. An octet
/// UTF-8 never holds, C0, C1 or F5 up, is judged by its place alone, as the octet before the next
/// lane's: the tables flag it there, whatever follows.
fn pair_possible(states: []const ?utf8.Utf8, before: u8, octet: u8) bool {
    const never = (octet >= constants.overlong_lead_2_min and octet < constants.lead_2_min) or octet >= constants.invalid_min;
    for (states) |maybe| {
        var state = maybe orelse break;
        if (!state.accept(before)) continue;
        if (if (never) state.between_characters() else state.accept(octet)) return true;
    }
    return false;
}

test "the tables judge every pair of octets as the machine of RFC 3629 §4 does" {
    const states = reachable_states();
    for (0..std.math.maxInt(u8) + 1) |before| for (0..std.math.maxInt(u8) + 1) |octet| {
        const bits = pair_bits(@intCast(before), @intCast(octet));
        const both_continue = continues(high_nibble(@intCast(before))) and continues(high_nibble(@intCast(octet)));
        try testing.expectEqual(!pair_possible(&states, @intCast(before), @intCast(octet)), bits & breaks_a_rule != 0);
        try testing.expectEqual(both_continue, bits & two_continuations_bit != 0);
    };
}

/// The octets at each edge of RFC 3629 §4's ranges, with one inside each.
const edge_octets = "\x00\x41\x7f\x80\x9f\xa0\xbf\xc0\xc1\xc2\xdf\xe0\xe1\xec\xed\xee\xef\xf0\xf1\xf3\xf4\xf5\xf7\xf8\xff";

fn is_utf8(octets: []const u8) bool {
    var machine: utf8.Utf8 = .{};
    for (octets) |octet| {
        if (!machine.accept(octet)) return false;
    }
    return machine.between_characters();
}

/// The octets of a sequence `expect_triples_judged` lays in a block: an edge octet and two more.
const sequence_len = 3;

/// Every sequence of an edge octet and two octets, laid at `start` of a block of zeros, with a
/// lane of zeros after it: both forms must flag a lane of the block exactly when the octets are
/// not UTF-8. A lane follows the sequence because an octet UTF-8 never holds, or a first octet the
/// block cuts, on the last lane is flagged on the next block's first lane, or stepped back over by
/// `cut_character_len`; scan_test.zig checks the runs across blocks.
fn expect_triples_judged(comptime start: usize) !void {
    for (edge_octets) |first| for (0..std.math.maxInt(u8) + 1) |second| for (0..std.math.maxInt(u8) + 1) |third| {
        try expect_triple_judged(start, .{ first, @intCast(second), @intCast(third) });
    };
}

fn expect_triple_judged(comptime start: usize, sequence: [sequence_len]u8) !void {
    const width = constants.vector_len;
    const previous: Block(width) = @splat(0);
    var octets: [width]u8 = @splat(0);
    octets[start..][0..sequence_len].* = sequence;
    const block: Block(width) = octets;
    const sequence_valid = is_utf8(&octets);
    if (comptime has_lookup) try testing.expectEqual(!sequence_valid, @reduce(.Max, error_octets_lookup(previous, block)) != 0);
    try testing.expectEqual(!sequence_valid, @reduce(.Or, error_lanes_compares(width, previous, block)));
}

test "the lookup and the compares flag a block exactly when its sequence is not UTF-8" {
    try expect_triples_judged(0);
    try expect_triples_judged(constants.vector_len - sequence_len - 1);
}

test {
    _ = @import("scan_utf8_test.zig");
}
