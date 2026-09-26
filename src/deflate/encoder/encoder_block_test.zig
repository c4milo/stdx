//! Tests for the encoder's block: each length's and distance's code against RFC 1951 §3.2.5's
//! table, and the plan's choice of the cheapest type.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const block_module = @import("encoder_block.zig");
const Block = block_module.Block;
const Plan = block_module.Plan;

test "every length and distance gets the code whose range holds it (RFC 1951 section 3.2.5)" {
    for (constants.match_len_min..constants.match_len_max + 1) |len| {
        const index = block_module.length_code(len);
        const base = constants.length_base[index];
        try testing.expect(len >= base and len < base + (@as(usize, 1) << @intCast(constants.length_extra_bits[index])));
    }
    try testing.expectEqual(constants.last_length_symbol - constants.first_length_symbol, block_module.length_code(constants.match_len_max));
    for (1..constants.window_len + 1) |distance| {
        const index = block_module.distance_code(distance);
        const base: usize = constants.distance_base[index];
        try testing.expect(distance >= base and distance < base + (@as(usize, 1) << @intCast(constants.distance_extra_bits[index])));
    }
}

test "the plan takes stored for random octets, fixed for a few, dynamic for a skewed block" {
    var block: Block = undefined;
    var result: Plan = undefined;
    // 16,384 random literals code no shorter than 8 bits each, and stored adds 5 octets.
    var generator = codec.split.Generator.init(1);
    block.reset(0);
    for (0..constants.block_symbols_max) |_| block.add_literal(@intCast(generator.below(256)));
    block_module.plan(&block, true, 0, &result);
    try testing.expectEqual(constants.BlockType.stored, result.kind);
    // Three literals: fixed's 8 bits each beat a dynamic header and stored's 5 octets.
    block.reset(0);
    for ("abc") |octet| block.add_literal(octet);
    block_module.plan(&block, false, 3, &result);
    try testing.expectEqual(constants.BlockType.fixed, result.kind);
    // Thousands of one literal and a few pairs: a dynamic code gives the literal one bit.
    block.reset(0);
    for (0..4000) |_| block.add_literal('a');
    for (0..10) |_| block.add_pair(10, 1);
    block_module.plan(&block, false, 0, &result);
    try testing.expectEqual(constants.BlockType.dynamic, result.kind);
    try testing.expectEqual(1, result.literal_length_lengths['a']);
}

test "a stored block's size counts its pad to the octet" {
    // 3 header bits from bit 0 pad 5; from bit 5 they end the octet.
    try testing.expectEqual(3 + 5 + 32 + 8, block_module.stored_bits(1, 0));
    try testing.expectEqual(3 + 0 + 32 + 8, block_module.stored_bits(1, 5));
    try testing.expectEqual(3 + 7 + 32, block_module.stored_bits(0, 6));
}

test "the plan takes the least of the three prices, for every seeded block" {
    var block: Block = undefined;
    var result: Plan = undefined;
    for (0..200) |seed| {
        var generator = codec.split.Generator.init(seed);
        block.reset(0);
        const symbols = generator.below(constants.block_symbols_max);
        // A seeded share of pairs and a seeded alphabet, so each type wins somewhere.
        const pair_share = generator.below(4);
        const alphabet = 1 + generator.below(256);
        for (0..symbols) |_| {
            // A block's input fits one stored block, as the encoder's do.
            if (block.input_len + constants.match_len_max > constants.stored_len_max) break;
            if (generator.below(4) < pair_share) {
                block.add_pair(constants.match_len_min + generator.below(40), 1 + generator.below(1000));
            } else {
                block.add_literal(@intCast(generator.below(alphabet)));
            }
        }
        const bit_position: u3 = @intCast(generator.below(8));
        block_module.plan(&block, seed % 2 == 0, bit_position, &result);
        const priced = block_module.prices(&block, &result, bit_position);
        try testing.expectEqual(@min(priced.stored, priced.fixed, priced.dynamic), result.bits);
        try testing.expectEqual(priced.cheapest(), result.kind);
    }
}
