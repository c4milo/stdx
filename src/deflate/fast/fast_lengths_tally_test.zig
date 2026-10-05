//! Tests for the tally of a DEFLATE header's lengths (decision 14, S14): the loop of
//! fast_lengths.zig and the checked steps count and list the lengths they read, and the block's
//! two codes are built from that. Each path must build the codes the lengths give, over blocks a
//! seed draws so that the decoder accepts them, and over the repeats that count in two alphabets
//! or list nothing.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");
const test_stream = @import("../test_stream.zig");
const deflate = @import("../decoder/decoder.zig");
const shared = @import("fast_lengths_test.zig");

const Generator = shared.Generator;
const Header = shared.Header;
const Codes = shared.Codes;

/// The seeds the blocks are drawn from.
const block_seeds = 400;

/// Of four draws, how many write a run of lengths as the lengths themselves, and how many prefer
/// a copy of the previous length to a run of zeros.
const draws = 4;
const plain_draws = 1;
const previous_draws = 2;

/// A dynamic block the decoder accepts: a header whose lengths give a complete literal/length code
/// with an end-of-block symbol and a distance code RFC 1951 §3.2.7 allows, then that symbol.
const Block = struct {
    header: Header,
    lengths: [constants.header_lengths_max]u8 = @splat(0),
    literal_length_count: u16,
    distance_count: u16,

    fn init(code_lengths: shared.CodeLengths, literal_length_count: u16, distance_count: u16) Block {
        return .{ .header = Header.init(code_lengths, literal_length_count, distance_count), .literal_length_count = literal_length_count, .distance_count = distance_count };
    }

    fn literal_lengths(self: *Block) []u8 {
        return self.lengths[0..self.literal_length_count];
    }

    fn distance_lengths(self: *Block) []u8 {
        return self.lengths[self.literal_length_count..][0..self.distance_count];
    }

    /// Ends the block: the end-of-block symbol's code, as RFC 1951 §3.2.2 assigns it.
    fn end(self: *Block) void {
        var lengths: [constants.literal_length_alphabet_len]u8 = @splat(0);
        @memcpy(lengths[0..self.literal_length_count], self.literal_lengths());
        const assigned = test_stream.assign_codes(constants.literal_length_alphabet_len, lengths);
        self.header.stream.code(assigned[constants.end_of_block], lengths[constants.end_of_block]);
    }

    /// The codes the block's lengths give, built from the lengths themselves.
    fn codes(self: *Block) !Codes {
        var built: Codes = undefined;
        var work = huffman.work_zero;
        try built.literal_length.build(self.literal_lengths(), .complete, &work);
        try built.distance.build(self.distance_lengths(), .distance, &work);
        return built;
    }
};

/// Of two draws of a complete code, one sorts its lengths.
const sort_draws = 2;

/// Gives `lengths` a complete code, drawn from `generator`. Half the draws sort the lengths, so
/// that equal ones stand together, as a header's repeats need.
fn draw_complete(generator: *Generator, lengths: []u8) void {
    const code_count: usize = @intCast(generator.between(test_stream.complete_codes_min, lengths.len));
    test_stream.draw_complete_code(generator, lengths, code_count, constants.code_len_max);
    if (generator.below(sort_draws) == 0) std.mem.sort(u8, lengths, {}, std.sort.asc(u8));
}

/// A distance code the decoder accepts, drawn from `generator`: none, one code of one bit, or a
/// complete code (RFC 1951 §3.2.7).
fn draw_distance_lengths(generator: *Generator, lengths: []u8) void {
    @memset(lengths, 0);
    const kind = generator.below(draws);
    if (kind == 0) return;
    if (kind == 1 or lengths.len < test_stream.complete_codes_min) {
        lengths[@intCast(generator.below(lengths.len))] = 1;
        return;
    }
    draw_complete(generator, lengths);
}

/// Writes `lengths` as code length symbols. Where a run of one value allows a repeat, the
/// generator draws whether to write one, which of the two a run of zeros takes, and its count.
fn give_lengths(header: *Header, generator: *Generator, lengths: []const u8) void {
    var at: usize = 0;
    // Each symbol gives a length at least.
    for (0..lengths.len) |_| {
        if (at == lengths.len) break;
        const len = lengths[at];
        const same = std.mem.indexOfNone(u8, lengths[at..], &.{len}) orelse lengths.len - at;
        const draw = generator.below(draws);
        const repeats = draw >= plain_draws and same >= constants.repeat_count_min[0];
        if (repeats and at > 0 and lengths[at - 1] == len and (len != 0 or draw < previous_draws)) {
            // RFC 1951 §3.2.7: 16 copies the previous length 3 to 6 times.
            const count = generator.between(constants.repeat_count_min[0], @min(same, constants.repeat_count_max[0]));
            header.give(constants.repeat_previous, count - constants.repeat_count_min[0]);
            at += @intCast(count);
        } else if (repeats and len == 0) {
            at += give_zeros(header, generator, same);
        } else {
            header.give(len, 0);
            at += 1;
        }
    }
}

/// Writes a run of zeros, of a count the generator draws from 3 to `same`, as symbol 17 or 18
/// (RFC 1951 §3.2.7). Returns the count.
fn give_zeros(header: *Header, generator: *Generator, same: usize) usize {
    const long = constants.repeat_zero_long - constants.repeat_previous;
    const short = constants.repeat_zero_short - constants.repeat_previous;
    const count: usize = @intCast(generator.between(constants.repeat_count_min[short], @min(same, constants.repeat_count_max[long])));
    if (count >= constants.repeat_count_min[long]) {
        header.give(constants.repeat_zero_long, count - constants.repeat_count_min[long]);
    } else {
        header.give(constants.repeat_zero_short, count - constants.repeat_count_min[short]);
    }
    return count;
}

/// A block `seed` draws: a code length code with a code for every symbol, the two alphabets'
/// lengths, and the symbols that write them.
fn draw_block(seed: u64) Block {
    var generator = Generator.init(seed);
    const code_lengths = shared.draw_code(&generator, shared.alphabet_len);
    const literal_length_count: u16 = @intCast(generator.between(constants.hlit_base, constants.literal_length_used));
    const distance_count: u16 = @intCast(generator.between(constants.hdist_base, constants.distance_alphabet_len));
    var block = Block.init(code_lengths, literal_length_count, distance_count);
    const literal_lengths = block.literal_lengths();
    draw_complete(&generator, literal_lengths);
    // RFC 1951 §3.2.7: the end-of-block symbol has a code. A symbol that has one gives it its own.
    if (literal_lengths[constants.end_of_block] == 0) {
        const coded = std.mem.indexOfNone(u8, literal_lengths, &.{0}).?;
        std.mem.swap(u8, &literal_lengths[coded], &literal_lengths[constants.end_of_block]);
    }
    draw_distance_lengths(&generator, block.distance_lengths());
    give_lengths(&block.header, &generator, block.lengths[0 .. literal_length_count + distance_count]);
    block.end();
    return block;
}

/// Requires each path to decode the block to its end and to have built the codes its lengths
/// give: the loops with the tally, the loops without it, the checked steps with it, and the
/// checked path alone.
fn expect_block_codes(block: *Block) !void {
    try testing.expectEqual(block.header.total, block.header.filled);
    var buffer: [test_stream.stream_len_max + shared.padding_len]u8 = undefined;
    const input = block.header.padded(&buffer);
    const expected = try block.codes();
    const paths = .{ .{ deflate.Options{}, shared.loop_fill }, .{ shared.tally_off, shared.tally_off_fill }, .{ shared.loop_off, shared.loop_off_fill }, .{ shared.checked, shared.checked_fill } };
    inline for (paths) |path| {
        const read = shared.read_header(path[0], input, input.len, path[1]);
        try testing.expectEqual(codec.Status.done, (try read.result).status);
        try testing.expectEqualSlices(u8, block.lengths[0..block.header.total], read.lengths[0..block.header.total]);
        try expected.expect_equal(&read.codes);
    }
}

test "every path builds a drawn block's codes as its lengths give them, whole" {
    for (0..block_seeds) |seed| {
        var block = draw_block(seed);
        try expect_block_codes(&block);
    }
}

test "the loops build a drawn block's codes as its lengths give them, cut at every octet" {
    for (0..block_seeds / 8) |seed| {
        var block = draw_block(seed);
        var buffer: [test_stream.stream_len_max + shared.padding_len]u8 = undefined;
        const input = block.header.padded(&buffer);
        const expected = try block.codes();
        for (1..input.len) |cut| {
            const read = shared.read_header(.{}, input, cut, shared.loop_fill);
            try testing.expectEqual(codec.Status.done, (try read.result).status);
            try expected.expect_equal(&read.codes);
        }
    }
}

/// A code length code for the lengths 0 and `coded_len` and the repeats 16 and 18: the length takes
/// a bit, 0 two, and each repeat three, a complete code.
const coded_len = 2;
const coded_len_bits = 1;
const zero_bits = 2;
const repeat_bits = 3;

fn tally_code() shared.CodeLengths {
    var lengths: shared.CodeLengths = @splat(0);
    lengths[coded_len] = coded_len_bits;
    lengths[0] = zero_bits;
    lengths[constants.repeat_previous] = repeat_bits;
    lengths[constants.repeat_zero_long] = repeat_bits;
    return lengths;
}

/// The most zeros one symbol 18 gives, as its extra bits say it, and what the rest of 253 take.
const zeros_most = 127;
const zeros_rest = 104;

test "a repeat that runs from the literal/length alphabet into the distance alphabet counts in both" {
    // Four literal/length codes of two bits, at 0, 254, 255 and 256, and four distance codes of
    // two bits. One repeat gives six of the eight: two literal/length symbols' and four distance
    // symbols' (RFC 1951 §3.2.7).
    const distance_count = 4;
    var block = Block.init(tally_code(), constants.hlit_base, distance_count);
    block.header.give(coded_len, 0);
    block.header.give(constants.repeat_zero_long, zeros_most);
    block.header.give(constants.repeat_zero_long, zeros_rest);
    block.header.give(coded_len, 0);
    block.header.give(constants.repeat_previous, constants.repeat_count_max[0] - constants.repeat_count_min[0]);
    @memset(block.lengths[constants.end_of_block - 2 ..][0 .. 3 + distance_count], coded_len);
    block.lengths[0] = coded_len;
    block.end();
    try expect_block_codes(&block);
    const built = try block.codes();
    try testing.expectEqual(4, built.literal_length.code_count);
    try testing.expectEqual(distance_count, built.distance.code_count);
}

test "a repeat of a previous length of zero lists no code" {
    // Four literal/length codes of two bits, at 0, 1, 255 and 256, and no distance code. A zero
    // and three copies of it by symbol 16 follow the first two.
    var block = Block.init(tally_code(), constants.hlit_base, constants.hdist_base);
    block.header.give(coded_len, 0);
    block.header.give(coded_len, 0);
    block.header.give(0, 0);
    block.header.give(constants.repeat_previous, 0);
    block.header.give(constants.repeat_zero_long, zeros_most);
    block.header.give(constants.repeat_zero_long, zeros_rest - 4);
    block.header.give(coded_len, 0);
    block.header.give(coded_len, 0);
    block.header.give(0, 0);
    block.lengths[0] = coded_len;
    block.lengths[1] = coded_len;
    block.lengths[constants.end_of_block - 1] = coded_len;
    block.lengths[constants.end_of_block] = coded_len;
    block.end();
    try expect_block_codes(&block);
}

test "a literal/length code of one code is refused on every path, as a distance code is not" {
    // The end-of-block symbol alone has a code, of one bit, and so has one distance symbol. RFC
    // 1951 §3.2.7 describes one distance code of one bit, and no literal/length code of that
    // kind, which decision 15 refuses.
    const one_bit = 1;
    var lengths: shared.CodeLengths = @splat(0);
    lengths[0] = one_bit;
    lengths[one_bit] = zero_bits;
    lengths[constants.repeat_zero_long] = zero_bits;
    var header = Header.init(lengths, constants.hlit_base, constants.hdist_base);
    header.give(constants.repeat_zero_long, zeros_most);
    header.give(constants.repeat_zero_long, zeros_rest + 3);
    header.give(one_bit, 0);
    header.give(one_bit, 0);
    try testing.expectEqual(header.total, header.filled);
    var buffer: [test_stream.stream_len_max + shared.padding_len]u8 = undefined;
    const read = try shared.expect_paths_agree(header.padded(&buffer));
    try testing.expectEqual(error.IncompleteCode, read.result);
}

test "a decode that builds its codes from the lengths leaves the tally as it found it" {
    var block = draw_block(0);
    var buffer: [test_stream.stream_len_max + shared.padding_len]u8 = undefined;
    const input = block.header.padded(&buffer);
    const marker = 0x77;
    inline for (.{ shared.checked, shared.tally_off }) |options| {
        var decoder: deflate.Decoder = undefined;
        @memset(std.mem.asBytes(&decoder), marker);
        deflate.init(&decoder, codec.Features.detect());
        var output: [shared.output_len]u8 = undefined;
        const progress = try deflate.decode_with(options, &decoder, input, &output);
        try testing.expectEqual(codec.Status.done, progress.status);
        try testing.expect(std.mem.allEqual(u8, std.mem.asBytes(&decoder.tally), marker));
    }
}
