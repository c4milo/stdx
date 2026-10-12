//! Tests of `encoder_match_three.zig`: the 3-octet table, what its candidate gives a position, and
//! the gate that starts and stops the matches at a block's end.

const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const constants = @import("../../constants.zig");
const Plan = @import("../encoder_block.zig").Plan;
const Block = @import("../encoder_block.zig").Block;
const Split = @import("../encoder_split.zig").Split;
const Match = @import("encoder_match.zig").Match;
const three_module = @import("encoder_match_three.zig");
const Three = three_module.Three;
const Probe = three_module.Probe;
const Counts = three_module.Counts;
const probe = three_module.probe;
const dear = three_module.dear;
const saves = three_module.saves;
const entropy = three_module.entropy;
const log2_fine = three_module.log2_fine;
const fine_per_bit = three_module.fine_per_bit;

/// The literals, the symbols before end-of-block (RFC 1951 §3.2.5).
const literal_count = constants.end_of_block;

test "log2 in 256ths of a bit is exact at powers of two and within a 100th of a bit between" {
    try testing.expectEqual(@as(u32, 0), log2_fine(1));
    try testing.expectEqual(@as(u32, fine_per_bit), log2_fine(2));
    try testing.expectEqual(@as(u32, 16 * fine_per_bit), log2_fine(1 << 16));
    for ([_]u32{ 3, 5, 6, 7, 9, 100, 1000, 12345, 16385, 49153, 65535, 70000 }) |n| {
        const exact = fine_per_bit * @log2(@as(f64, @floatFromInt(n)));
        try testing.expect(@abs(@as(f64, @floatFromInt(log2_fine(n))) - exact) <= @as(f64, fine_per_bit) / 100.0);
    }
}

test "symbols cost their entropy and a header's bits for each symbol with a count" {
    const header = constants.header_estimate_symbol_bits * fine_per_bit;
    // Four symbols as often as each other take 2 bits each.
    try testing.expectEqual(@as(u64, 32 * 2 * fine_per_bit + 4 * header), entropy(&.{ 8, 8, 0, 8, 8, 0 }));
    // One symbol alone takes none, and no symbol costs nothing.
    try testing.expectEqual(@as(u64, header), entropy(&.{ 0, 100 }));
    try testing.expectEqual(@as(u64, 0), entropy(&.{ 0, 0 }));
    // A half, a quarter and two eighths: 1, 2, 3 and 3 bits.
    try testing.expectEqual(@as(u64, (8 * 1 + 4 * 2 + 2 * 3 + 2 * 3) * fine_per_bit + 4 * header), entropy(&.{ 8, 4, 2, 2 }));
}

/// The 4 octets of `text`, least significant first.
fn word_of(text: *const [constants.hash_len]u8) u32 {
    return std.mem.readInt(u32, text, .little);
}

test "the table names the latest position with a hash of 3 octets, whatever the fourth" {
    var three: Three = undefined;
    // An entry for each hash of `three_hash_bits` bits.
    try testing.expectEqual(@as(usize, 16_384), three.heads.len);
    @memset(&three.heads, 0);
    try testing.expectEqual(@as(u16, 0), three.insert(true, word_of("abcd"), 100));
    try testing.expectEqual(@as(u16, 100), three.insert(true, word_of("abcX"), 200));
    try testing.expectEqual(@as(u16, 200), three.insert(true, word_of("abcd"), 300));
    // Other first octets have an entry of their own.
    try testing.expectEqual(@as(u16, 0), three.insert(true, word_of("Xbcd"), 400));
    try testing.expectEqual(@as(u16, 0), three.insert(true, word_of("aXcd"), 500));
    try testing.expectEqual(@as(u16, 0), three.insert(true, word_of("abXd"), 600));
    try testing.expectEqual(@as(u16, 300), three.insert(true, word_of("abcd"), 700));
}

/// What `probe` gives a position that holds "abcd" for a candidate `distance` before it that
/// holds `held`, in a window of zeros.
fn probe_at(position: usize, distance: usize, held: *const [constants.hash_len]u8) Probe {
    var window: [constants.encoder_window_len]u8 = @splat(0);
    @memcpy(window[position..][0..constants.hash_len], "abcd");
    @memcpy(window[position - distance ..][0..constants.hash_len], held);
    return probe(true, &window, position, word_of("abcd"), @intCast(position - distance));
}

test "a candidate that holds the 4 octets gives a search as far as a search reaches" {
    const position = 40_000;
    try testing.expect(probe_at(position, 1, "abcd").four);
    try testing.expect(probe_at(position, constants.encoder_distance_max, "abcd").four);
    try testing.expect(!probe_at(position, constants.encoder_distance_max + 1, "abcd").four);
    try testing.expect(!probe_at(position, 1, "abcX").four);
    try testing.expect(!probe_at(position, 1, "Xbcd").four);
    // Position 0 names no candidate of a search, whatever it holds.
    try testing.expect(!probe_at(100, 100, "abcd").four);
    try testing.expect(probe_at(100, 99, "abcd").four);
}

test "a candidate that holds the first 3 octets gives a match within three_distance_max" {
    const position = 40_000;
    for ([_][]const u8{ "abcX", "abcd" }) |held| {
        const near = probe_at(position, 1, held[0..constants.hash_len]).three;
        try testing.expectEqual(Match{ .len = constants.match_len_min, .distance = 1 }, near);
        const far = probe_at(position, constants.three_distance_max, held[0..constants.hash_len]).three;
        try testing.expectEqual(Match{ .len = constants.match_len_min, .distance = constants.three_distance_max }, far);
        try testing.expectEqual(Match{}, probe_at(position, constants.three_distance_max + 1, held[0..constants.hash_len]).three);
    }
    try testing.expectEqual(Match{}, probe_at(position, 1, "abXd").three);
    try testing.expectEqual(Match{}, probe_at(position, 1, "aXcd").three);
    try testing.expectEqual(Match{}, probe_at(position, 1, "Xbcd").three);
    // Position 0 is read as any other, and a position is no candidate of its own.
    try testing.expectEqual(Match{ .len = constants.match_len_min, .distance = 100 }, probe_at(100, 100, "abcX").three);
    var window: [constants.encoder_window_len]u8 = @splat(0);
    const own = probe(true, &window, 0, 0, 0);
    try testing.expect(!own.four);
    try testing.expectEqual(Match{}, own.three);
}

/// A plan whose literals all take `len` bits, and counts of `literals` literals, `pairs` length
/// symbols and end-of-block.
fn scene(len: u8, literals: u16, pairs: u16, plan: *Plan, counts: *[constants.literal_length_used]u16) void {
    plan.literal_length_lengths = @splat(len);
    counts.* = @splat(0);
    counts['a'] = literals;
    counts[constants.first_length_symbol + 1] = pairs;
    counts[constants.end_of_block] = 1;
}

test "literals are dear from five bits a symbol of the block" {
    var plan: Plan = undefined;
    var counts: [constants.literal_length_used]u16 = undefined;
    // 100 literals of 8 bits: 800 bits, 5 a symbol over 160 symbols.
    scene(8, 100, 59, &plan, &counts);
    try testing.expect(dear(&plan, &counts));
    scene(8, 100, 60, &plan, &counts);
    try testing.expect(!dear(&plan, &counts));
    // Literals of 4 bits, or 5, take under 5 bits a symbol even alone, with end-of-block.
    scene(4, 100, 0, &plan, &counts);
    try testing.expect(!dear(&plan, &counts));
    scene(5, 100, 0, &plan, &counts);
    try testing.expect(!dear(&plan, &counts));
}

test "literals are dear from six and a half bits each at the mean" {
    var plan: Plan = undefined;
    var counts: [constants.literal_length_used]u16 = undefined;
    // Alone, literals of 6 bits are not dear, and literals of 7 are.
    scene(6, 100, 0, &plan, &counts);
    try testing.expect(!dear(&plan, &counts));
    scene(7, 100, 0, &plan, &counts);
    try testing.expect(dear(&plan, &counts));
    // As many of 6 bits as of 7: six and a half each. One more of 6 bits: under it.
    scene(6, 50, 0, &plan, &counts);
    plan.literal_length_lengths['b'] = 7;
    counts['b'] = 50;
    try testing.expect(dear(&plan, &counts));
    counts['a'] = 51;
    try testing.expect(!dear(&plan, &counts));
}

test "the matches paid when they saved three_saving_divisor's share, and no less" {
    try testing.expect(saves(9_899, 10_000));
    try testing.expect(!saves(9_900, 10_000));
    try testing.expect(!saves(10_000, 10_000));
    try testing.expect(!saves(0, 0));
}

/// Counts of `literals` literals spread over every octet as evenly as they go, `longer` matches
/// of 4 octets and end-of-block, with `taken` 3-octet matches of the distance code `code` among
/// the symbols and in `three`'s counts, each made of the octets `octets`.
fn taken_scene(three: *Three, literals: u16, longer: u16, taken: u16, code: usize, octets: [constants.match_len_min]u8, literal_length: *[constants.literal_length_used]u16, distance: *[constants.distance_used]u16) void {
    literal_length.* = @splat(0);
    distance.* = @splat(0);
    for (literal_length[0..literal_count], 0..) |*count, octet| count.* = literals / literal_count + @intFromBool(octet < literals % literal_count);
    literal_length[constants.end_of_block] = 1;
    literal_length[constants.first_length_symbol] = taken;
    literal_length[constants.first_length_symbol + 1] = longer;
    distance[code] = taken;
    distance[constants.distance_used - 1] = longer;
    three.forget();
    for (octets) |octet| three.octets[octet] += taken;
    three.distances[code] = taken;
}

test "3-octet matches pay among dear literals nearby, and not far away, among cheap ones or when none was taken" {
    var three: Three = undefined;
    var literal_length: [constants.literal_length_used]u16 = undefined;
    var distance: [constants.distance_used]u16 = undefined;
    // 2,000 literals of 8 bits and 500 matches of a distance code with no extra bits: each
    // match takes about 2 bits for its length, where its three literals would take about 24.
    taken_scene(&three, 2_000, 100, 500, 0, "xyz".*, &literal_length, &distance);
    try testing.expect(three.paid(&literal_length, &distance));
    // The same matches of a far code take 13 extra bits each, more than they save: as literals
    // their octets would be the block's three commonest.
    taken_scene(&three, 2_000, 100, 500, constants.distance_used - 2, "xyz".*, &literal_length, &distance);
    try testing.expect(!three.paid(&literal_length, &distance));
    // Among literals of one octet, which cost no bit, a match saves nothing.
    taken_scene(&three, 0, 100, 500, 0, "xxx".*, &literal_length, &distance);
    literal_length['x'] = 2_000;
    try testing.expect(!three.paid(&literal_length, &distance));
    // None taken: nothing to pay.
    taken_scene(&three, 2_000, 100, 0, 0, "xyz".*, &literal_length, &distance);
    try testing.expect(!three.paid(&literal_length, &distance));
}

test "a block's end reads the symbols a cut carries, and no count of the block's own first symbols" {
    var plan: Plan = undefined;
    var block: Block = undefined;
    var split: Split = undefined;
    scene(end_literal_len, end_literals, end_pairs, &plan, &block.literal_length_counts);
    block.distance_counts = @splat(0);
    inline for (.{ .{ 0, false }, .{ 1, true }, .{ constants.block_chunk_symbols, true } }) |case| {
        var three: Three = undefined;
        three.start();
        three.live = true;
        // The counts in which the matches pay are `split`'s, which hold them or not.
        var taken: Three = undefined;
        taken_scene(&taken, end_taken_literals, end_longer, end_taken, 0, "xyz".*, &split.literal_length_counts, &split.distance_counts);
        three.octets = taken.octets;
        three.distances = taken.distances;
        split.carried_count = case[0];
        three.end_block(&plan, false, &block, &split);
        try testing.expectEqual(case[1], three.live);
    }
}

test "the matches' distances cost only where the matches are" {
    var three: Three = undefined;
    var literal_length: [constants.literal_length_used]u16 = undefined;
    var distance: [constants.distance_used]u16 = undefined;
    // 500 matches over ten distance codes of 3 to 7 extra bits, 50 each: with their codes'
    // three bits and more each they cost 3% over their literals. Were their distances counted
    // without them too, they would seem to save 5%.
    taken_scene(&three, 2_000, 100, 500, 0, "xyz".*, &literal_length, &distance);
    distance[0] = 0;
    three.distances[0] = 0;
    for (8..18) |code| {
        distance[code] = 50;
        three.distances[code] = 50;
    }
    try testing.expect(!three.paid(&literal_length, &distance));
}

test "the matches' counts come off the distance codes and go to their octets' literals" {
    var three: Three = undefined;
    var literal_length: [constants.literal_length_used]u16 = undefined;
    var distance: [constants.distance_used]u16 = undefined;
    taken_scene(&three, 0, 0, 0, 0, "abc".*, &literal_length, &distance);
    // Two literals, 'x' and 'y', 3 each, and 2 matches of "xyx" with no extra bits.
    literal_length['x'] = 3;
    literal_length['y'] = 3;
    literal_length[constants.first_length_symbol] = 2;
    distance[0] = 2;
    three.octets['x'] = 4;
    three.octets['y'] = 2;
    three.distances[0] = 2;
    // Without: 'x' 7, 'y' 5 and end-of-block, 13 symbols, and no distance. With: 3, 3, 2 and
    // 1, 9 symbols, and one distance code.
    const without = entropy(&.{ 7, 5, 1 });
    const with = entropy(&.{ 3, 3, 2, 1 }) + entropy(&.{2});
    try testing.expectEqual(saves(with, without), three.paid(&literal_length, &distance));
    // A count of matches beyond the symbols' is cut to theirs.
    three.distances[0] = 9;
    try testing.expectEqual(saves(with, without), three.paid(&literal_length, &distance));
}

test "a count taken of a match holds its three octets and its distance's code" {
    var three: Three = undefined;
    three.forget();
    three.tally(true, word_of("aba?"), 7);
    three.tally(true, word_of("abc?"), 7);
    try testing.expectEqual(@as(u16, 3), three.octets['a']);
    try testing.expectEqual(@as(u16, 2), three.octets['b']);
    try testing.expectEqual(@as(u16, 1), three.octets['c']);
    try testing.expectEqual(@as(u16, 0), three.octets['?']);
    try testing.expectEqual(@as(u16, 2), three.distances[7]);
    var all: u32 = 0;
    for (three.octets) |count| all += count;
    try testing.expectEqual(@as(u32, 6), all);
}

test "a slide moves the table's positions, and those that fall out name position 0" {
    var three: Three = undefined;
    three.live = true;
    @memset(&three.heads, 0);
    three.heads[1] = constants.window_len + 5;
    three.heads[2] = constants.window_len;
    three.heads[3] = constants.window_len - 1;
    three.heads[three.heads.len - 1] = std.math.maxInt(u16);
    three.slide();
    try testing.expectEqual(@as(u16, 5), three.heads[1]);
    try testing.expectEqual(@as(u16, 0), three.heads[2]);
    try testing.expectEqual(@as(u16, 0), three.heads[3]);
    try testing.expectEqual(@as(u16, std.math.maxInt(u16) - constants.window_len), three.heads[three.heads.len - 1]);
}

/// The scenes of `end_block`: literals of this many bits, this many of them, among this many
/// length symbols where they are not dear; and counts in which this many 3-octet matches pay
/// among that many literals and those longer matches.
const end_literal_len = 8;
const end_literals = 100;
const end_pairs = 200;
const end_taken = 500;
const end_taken_literals = 2_000;
const end_longer = 100;

/// One block end for `three`, after a block whose literals are dear or not, and whose 3-octet
/// matches, when it took any, paid or not.
fn end_block(three: *Three, dear_literals: bool, pays: bool, cheap: bool) void {
    var plan: Plan = undefined;
    var counts: [constants.literal_length_used]u16 = undefined;
    scene(end_literal_len, end_literals, if (dear_literals) 0 else end_pairs, &plan, &counts);
    var literal_length: [constants.literal_length_used]u16 = undefined;
    var distance: [constants.distance_used]u16 = undefined;
    var taken: Three = undefined;
    taken_scene(&taken, end_taken_literals, end_longer, if (pays) end_taken else 0, 0, "xyz".*, &literal_length, &distance);
    three.octets = taken.octets;
    three.distances = taken.distances;
    // The plan and the block's own literal/length counts tell whether its literals are dear;
    // the counts with the matches tell whether they paid, here as the symbols a cut carries.
    const none: [constants.distance_used]u16 = @splat(0);
    three.update(&plan, cheap, .{ .literal_length = &counts, .distance = &none }, .{ .literal_length = &literal_length, .distance = &distance });
}

test "the matches are judged over the block's symbols and those a cut carries together" {
    var three: Three = undefined;
    var plan: Plan = undefined;
    var counts: [constants.literal_length_used]u16 = undefined;
    scene(end_literal_len, end_literals, end_pairs, &plan, &counts);
    var literal_length: [constants.literal_length_used]u16 = undefined;
    var distance: [constants.distance_used]u16 = undefined;
    const none_literal_length: [constants.literal_length_used]u16 = @splat(0);
    const none_distance: [constants.distance_used]u16 = @splat(0);
    const with: Counts = .{ .literal_length = &literal_length, .distance = &distance };
    const without: Counts = .{ .literal_length = &none_literal_length, .distance = &none_distance };
    // The symbols among which the matches pay, as the block's, as the carried ones, and in
    // neither: only there are the matches found among none of the symbols, and stop.
    inline for (.{ .{ with, without, true }, .{ without, with, true }, .{ with, null, true }, .{ without, null, false } }) |case| {
        three.start();
        three.live = true;
        var taken: Three = undefined;
        taken_scene(&taken, end_taken_literals, end_longer, end_taken, 0, "xyz".*, &literal_length, &distance);
        three.octets = taken.octets;
        three.distances = taken.distances;
        three.update(&plan, false, case[0], case[1]);
        try testing.expectEqual(case[2], three.live);
    }
}

test "the matches start after dear literals with a table of zeros, and stop where they do not pay" {
    var three: Three = undefined;
    three.start();
    @memset(&three.heads, 7);
    try testing.expect(!three.live);
    end_block(&three, false, false, false);
    try testing.expect(!three.live);
    try testing.expectEqual(@as(u16, 7), three.heads[0]);
    end_block(&three, true, false, false);
    try testing.expect(three.live);
    for (three.heads) |head| try testing.expectEqual(@as(u16, 0), head);
    // While they pay they stay, whatever the literals, and the table is kept.
    three.heads[5] = 9;
    end_block(&three, false, true, false);
    try testing.expect(three.live);
    try testing.expectEqual(@as(u16, 9), three.heads[5]);
    // Each block end forgets the counts of the block's matches.
    for (three.octets) |count| try testing.expectEqual(@as(u16, 0), count);
    for (three.distances) |count| try testing.expectEqual(@as(u16, 0), count);
    end_block(&three, true, false, false);
    try testing.expect(!three.live);
    // A block of cheap literals takes none (decision 42), whatever the matches saved.
    three.live = true;
    end_block(&three, true, true, true);
    try testing.expect(!three.live);
}

test "after a block the matches did not pay in, the next try waits, twice as long each time" {
    var three: Three = undefined;
    three.start();
    var wait: u8 = 1;
    const doublings: usize = std.math.log2_int(u8, constants.three_wait_max);
    for (0..2 * doublings) |_| {
        end_block(&three, true, false, false);
        try testing.expect(three.live);
        end_block(&three, true, false, false);
        try testing.expect(!three.live);
        // The block ends that pass before dear literals start the matches again.
        for (0..wait) |_| {
            end_block(&three, true, false, false);
            try testing.expect(!three.live);
        }
        wait = @min(wait * 2, constants.three_wait_max);
    }
    // The longest wait, `three_wait_max`.
    try testing.expectEqual(@as(u8, 64), wait);
    // A block they pay in ends the count: the next failure waits one block end again.
    end_block(&three, true, false, false);
    try testing.expect(three.live);
    end_block(&three, true, true, false);
    try testing.expect(three.live);
    end_block(&three, true, false, false);
    try testing.expect(!three.live);
    end_block(&three, true, false, false);
    try testing.expect(!three.live);
    end_block(&three, true, false, false);
    try testing.expect(three.live);
}
