//! The encoder's block: the symbols it holds, their counts, and the plan it is written by. The plan
//! prices the block exactly three ways from its counts, stored, fixed and dynamic, and takes the
//! cheapest (decision 14, E3; RFC 1951 §3.2.3). A block's input is in the window, so its stored
//! form is a choice, until it crosses a slide of the window, which it does only while it codes for
//! less than its stored form (decision 44): no block costs more than its input stored.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const code = @import("encoder_code.zig");

/// A length or distance code's index: every code of either alphabet fits, so a table of
/// `codes_len` entries indexed by it needs no bounds check.
pub const CodeIndex = u5;
pub const codes_len = 1 << @bitSizeOf(CodeIndex);

/// A literal, or a length/distance pair (RFC 1951 §3.2.5).
pub const Symbol = packed struct(u32) {
    /// A literal's octet, or a pair's length less `match_len_min`.
    value: u8,
    /// A pair's distance, or 0 for a literal.
    distance: u16,
    /// A pair's distance code, found once when the pair is added; 0 for a literal.
    distance_code: CodeIndex = 0,
    reserved: u3 = 0,
};

comptime {
    assert(constants.length_base.len <= codes_len and constants.distance_used <= codes_len);
}

/// Each length's code, 257 to 285 less 257, lengths 3 to 258 (RFC 1951 §3.2.5), indexed by the
/// length less `match_len_min`, a `Symbol`'s value.
const length_codes: [constants.match_len_max - constants.match_len_min + 1]CodeIndex = codes: {
    var codes_of: [constants.match_len_max - constants.match_len_min + 1]CodeIndex = undefined;
    for (constants.length_base, constants.length_extra_bits, 0..) |base, extra, index| {
        for (base..base + (1 << extra)) |len| {
            if (len <= constants.match_len_max) codes_of[len - constants.match_len_min] = index;
        }
    }
    break :codes codes_of;
};

/// The distances of `near_codes` and above, one entry per `far_distance_step`: each distance code
/// from 16 on covers whole steps (RFC 1951 §3.2.5).
const near_distances = 256;
const far_distance_shift = 7;
const near_codes: [near_distances]CodeIndex = distance_codes(false);
/// The comptime branches building the far table takes: one per distance.
const distance_codes_quota = 100_000;
const far_codes: [constants.window_len >> far_distance_shift]CodeIndex = distance_codes(true);

comptime {
    // Both tables are indexed by a u8 without a bounds check.
    assert(near_distances == 1 << @bitSizeOf(u8) and constants.window_len >> far_distance_shift == 1 << @bitSizeOf(u8));
}

fn distance_codes(comptime far: bool) [if (far) constants.window_len >> far_distance_shift else near_distances]CodeIndex {
    @setEvalBranchQuota(distance_codes_quota);
    var codes_of: [if (far) constants.window_len >> far_distance_shift else near_distances]CodeIndex = @splat(0);
    for (constants.distance_base, constants.distance_extra_bits, 0..) |base, extra, index| {
        for (base..@as(usize, base) + (1 << extra)) |distance| {
            const slot = if (far) (distance - 1) >> far_distance_shift else distance - 1;
            if (slot < codes_of.len and (far or distance <= near_distances)) codes_of[slot] = index;
        }
    }
    return codes_of;
}

/// The code of a length, as its index from 257.
pub inline fn length_code(len: usize) CodeIndex {
    assert(len >= constants.match_len_min and len <= constants.match_len_max);
    return length_code_of(@intCast(len - constants.match_len_min));
}

/// `length_code` for a `Symbol`'s value, the length less `match_len_min`.
pub inline fn length_code_of(value: u8) CodeIndex {
    return length_codes[value];
}

/// The code of a distance. Both tables are read, so the choice is a select and not a branch, which
/// the distances of a block would mispredict. Each index is a u8, so neither read is checked.
pub inline fn distance_code(distance: usize) CodeIndex {
    assert(distance >= 1 and distance <= constants.window_len);
    const near = near_codes[@as(u8, @truncate(@min(distance, near_distances) - 1))];
    const far = far_codes[@as(u8, @truncate((distance - 1) >> far_distance_shift))];
    return if (distance <= near_distances) near else far;
}

/// A length or distance code as the symbol writer puts it: its code, the code's bits, the base of
/// the values it covers, and the extra bits after it that hold a value less the base (RFC 1951
/// §3.2.5), so a pair's length or distance goes into the bit buffer with one put.
pub const CodeEntry = struct {
    code: u16,
    base: u16,
    code_bits: u8,
    extra_bits: u8,
};

pub const Block = struct {
    symbols: [constants.block_symbols_max]Symbol,
    symbol_count: u16,
    literal_length_counts: [constants.literal_length_used]u16,
    distance_counts: [constants.distance_used]u16,
    /// Where the block's input starts in the window, after its last slide when it crossed one
    /// (decision 44), and how many octets its symbols cover.
    input_start: usize,
    input_len: usize,
    /// The symbols the block holds at its next check, or `block_symbols_max`: the rounds that
    /// decide positions stop there (decision 44).
    limit: u16,

    /// Starts an empty block at `input_start`. Every block ends with end-of-block (RFC 1951
    /// §3.2.3), which its counts hold from the start.
    pub fn reset(self: *Block, input_start: usize) void {
        self.symbol_count = 0;
        @memset(&self.literal_length_counts, 0);
        @memset(&self.distance_counts, 0);
        self.literal_length_counts[constants.end_of_block] = 1;
        self.input_start = input_start;
        self.input_len = 0;
        self.limit = constants.block_symbols_max;
    }

    pub fn full(self: *const Block) bool {
        return self.symbol_count == constants.block_symbols_max;
    }

    /// Whether the block holds its `limit`: it is full, or its newest symbols wait for a check.
    pub fn at_limit(self: *const Block) bool {
        return self.symbol_count >= self.limit;
    }

    /// Whether the block's newest symbols wait for their check (decision 44).
    pub fn at_check(self: *const Block) bool {
        return self.at_limit() and !self.full();
    }

    /// Symbols added by one loop with the count in a local, which the loop's stores elsewhere do not
    /// make the compiler reload; `finish` writes it back with the octets the symbols cover.
    pub fn appender(self: *Block) Appender {
        return .{ .block = self, .count = self.symbol_count };
    }

    pub inline fn add_literal(self: *Block, octet: u8) void {
        assert(!self.full());
        self.symbols[self.symbol_count] = .{ .value = octet, .distance = 0 };
        self.symbol_count += 1;
        self.literal_length_counts[octet] += 1;
        self.input_len += 1;
    }

    pub inline fn add_pair(self: *Block, len: usize, distance: usize) void {
        assert(!self.full());
        assert(distance >= 1 and distance <= constants.encoder_distance_max);
        const distance_index = distance_code(distance);
        self.symbols[self.symbol_count] = .{ .value = @intCast(len - constants.match_len_min), .distance = @intCast(distance), .distance_code = distance_index };
        self.symbol_count += 1;
        self.literal_length_counts[constants.first_length_symbol + length_code(len)] += 1;
        self.distance_counts[distance_index] += 1;
        self.input_len += len;
    }
};

/// `Block.appender`'s state. A block holds at most `block_symbols_max` symbols, fewer than 2^16,
/// so none of its counts wraps and they add without an overflow check.
pub const Appender = struct {
    block: *Block,
    count: u16,

    /// `>=` rather than `==`: a loop that stops here leaves the count provably below the limit, so
    /// the appends' bound costs nothing.
    pub inline fn full(self: *const Appender) bool {
        return self.count >= constants.block_symbols_max;
    }

    pub inline fn literal(self: *Appender, octet: u8) void {
        const count = self.count;
        assert(count < constants.block_symbols_max);
        self.block.symbols[count] = .{ .value = octet, .distance = 0 };
        self.count = count + 1;
        self.block.literal_length_counts[octet] +%= 1;
    }

    pub inline fn pair(self: *Appender, len: usize, distance: usize) void {
        const count = self.count;
        assert(count < constants.block_symbols_max);
        assert(distance >= 1 and distance <= constants.encoder_distance_max);
        const distance_index = distance_code(distance);
        self.block.symbols[count] = .{ .value = @intCast(len - constants.match_len_min), .distance = @intCast(distance), .distance_code = distance_index };
        self.count = count + 1;
        self.block.literal_length_counts[constants.first_length_symbol + length_code(len)] +%= 1;
        self.block.distance_counts[distance_index] +%= 1;
    }

    /// Writes the count back, and adds `input_len`, the octets the symbols cover.
    pub fn finish(self: *const Appender, input_len: usize) void {
        self.block.symbol_count = self.count;
        self.block.input_len += input_len;
    }
};

comptime {
    // A count reaches at most `block_symbols_max`, end-of-block's one more: no count wraps.
    assert(constants.block_symbols_max + 1 <= std.math.maxInt(u16));
}

/// How a block is written: its type, and for a coded block its codes, and for a dynamic block its
/// header's counts, code length code and run-length items (RFC 1951 §3.2.7).
pub const Plan = struct {
    kind: constants.BlockType,
    final: bool,
    /// The block's exact size in bits, header included: its price (decision 14, E3).
    bits: u64,
    literal_length_lengths: [constants.literal_length_used]u8,
    literal_length_codes: [constants.literal_length_used]u16,
    distance_lengths: [constants.distance_used]u8,
    distance_codes: [constants.distance_used]u16,
    /// HLIT + 257, HDIST + 1 and HCLEN + 4.
    literal_length_count: u16,
    distance_count: u16,
    code_length_count: u16,
    code_length_lengths: [constants.code_length_alphabet_len]u8,
    code_length_codes: [constants.code_length_alphabet_len]u16,
    items: [code.items_max]code.Item,
    item_count: u16,
    /// Each length code's and distance code's entry for the symbol writer, from the codes above,
    /// indexed by `CodeIndex` without a bounds check; the entries past the alphabets stay zero.
    length_entries: [codes_len]CodeEntry,
    distance_entries: [codes_len]CodeEntry,

    /// Fills `length_entries` and `distance_entries` from the plan's codes.
    pub fn fill_entries(self: *Plan) void {
        self.length_entries = @splat(std.mem.zeroes(CodeEntry));
        self.distance_entries = @splat(std.mem.zeroes(CodeEntry));
        for (self.length_entries[0..constants.length_base.len], constants.length_base, constants.length_extra_bits, 0..) |*entry, base, extra_bits, index| {
            const symbol = constants.first_length_symbol + index;
            entry.* = .{ .code = self.literal_length_codes[symbol], .base = base, .code_bits = self.literal_length_lengths[symbol], .extra_bits = extra_bits };
        }
        for (self.distance_entries[0..constants.distance_used], constants.distance_base[0..constants.distance_used], constants.distance_extra_bits[0..constants.distance_used], 0..) |*entry, base, extra_bits, index| {
            entry.* = .{ .code = self.distance_codes[index], .base = base, .code_bits = self.distance_lengths[index], .extra_bits = extra_bits };
        }
    }
};

/// The fixed codes (RFC 1951 §3.2.6), reversed for the stream, built once at comptime. Each is
/// built over its whole alphabet, 288 and 32 symbols, since symbols 286, 287, 30 and 31 take codes
/// too, and the codes after them depend on it; the stream uses the first 286 and 30.
const fixed_literal_length_codes: [constants.literal_length_used]u16 = fixed: {
    var codes_of: [constants.literal_length_alphabet_len]u16 = undefined;
    code.build_codes(&constants.fixed_literal_length_lengths, &codes_of);
    break :fixed codes_of[0..constants.literal_length_used].*;
};
const fixed_distance_codes: [constants.distance_used]u16 = fixed: {
    var codes_of: [constants.distance_alphabet_len]u16 = undefined;
    code.build_codes(&constants.fixed_distance_lengths, &codes_of);
    break :fixed codes_of[0..constants.distance_used].*;
};

/// A block's exact size in bits as each type, headers included (decision 14, E3).
pub const Prices = struct {
    stored: u64,
    fixed: u64,
    dynamic: u64,

    /// The cheapest type, stored first and fixed next among equals.
    pub fn cheapest(self: Prices) constants.BlockType {
        if (self.stored <= self.fixed and self.stored <= self.dynamic) return .stored;
        return if (self.fixed <= self.dynamic) .fixed else .dynamic;
    }
};

/// The block's prices, with `dynamic` its planned dynamic code's, which `plan_dynamic` built, and
/// `dynamic_header_bits` the bits `plan_dynamic` counted for its header.
pub fn prices(block: *const Block, dynamic: *const Plan, dynamic_header_bits: u64, bit_position: u3) Prices {
    const block_header = constants.final_bits + constants.type_bits;
    const fixed_lengths = constants.fixed_literal_length_lengths[0..constants.literal_length_used];
    const fixed_distance_lengths = constants.fixed_distance_lengths[0..constants.distance_used];
    const coded = coded_bits(block, fixed_lengths, fixed_distance_lengths, &dynamic.literal_length_lengths, &dynamic.distance_lengths);
    return .{
        .stored = stored_bits(block.input_len, bit_position),
        .fixed = block_header + coded.fixed,
        .dynamic = block_header + dynamic_header_bits + coded.dynamic,
    };
}

/// The bits of a block's symbols under the fixed code and under its own.
const CodedBits = struct {
    fixed: u64,
    dynamic: u64,
};

/// The bits of a block's symbols and end-of-block under two codes at once, with their extra bits
/// (RFC 1951 §3.2.5): the fixed code and the dynamic. A block holds at most `block_symbols_max`
/// symbols and end-of-block, each `pair_bits_max` bits at most, so no sum wraps, and they add
/// without an overflow check.
fn coded_bits(block: *const Block, fixed_lengths: []const u8, fixed_distance_lengths: []const u8, lengths: []const u8, distance_lengths: []const u8) CodedBits {
    var fixed = weigh(&block.literal_length_counts, fixed_lengths);
    var dynamic = weigh(&block.literal_length_counts, lengths);
    var extra: u32 = 0;
    for (block.literal_length_counts[constants.first_length_symbol..], constants.length_extra_bits) |count, extra_bits| {
        extra +%= @as(u32, count) *% extra_bits;
    }
    for (block.distance_counts, fixed_distance_lengths, distance_lengths, constants.distance_extra_bits) |count, fixed_len, len, extra_bits| {
        fixed +%= @as(u32, count) *% (@as(u32, fixed_len) + extra_bits);
        dynamic +%= @as(u32, count) *% (@as(u32, len) + extra_bits);
    }
    return .{ .fixed = fixed +% extra, .dynamic = dynamic +% extra };
}

/// The counts one vector op of `weigh` takes.
const weigh_vector_len = 16;

/// What the mask of `weigh` leaves of a count.
const count_mask = std.math.maxInt(i16);

comptime {
    assert((constants.block_symbols_max + 1) * @as(u64, constants.pair_bits_max) <= std.math.maxInt(u32));
    assert(constants.block_symbols_max + 1 <= count_mask);
}

/// The sum of each literal/length count times its code's length, `weigh_vector_len` counts at a
/// time: Zig 0.16 turns no loop into vector code, so the vectors are written out.
fn weigh(counts: *const [constants.literal_length_used]u16, lengths: []const u8) align(constants.hot_function_alignment) u32 {
    assert(lengths.len == counts.len);
    const Counts = @Vector(weigh_vector_len, u16);
    const Products = @Vector(weigh_vector_len, u32);
    var sums: Products = @splat(0);
    var index: usize = 0;
    while (index + weigh_vector_len <= counts.len) : (index += weigh_vector_len) {
        // The mask changes no count. It tells the compiler that both factors fit 15 bits, which
        // x86-64 multiplies and adds in pairs with one instruction.
        const bounded = @as(Counts, counts[index..][0..weigh_vector_len].*) & @as(Counts, @splat(count_mask));
        const len: @Vector(weigh_vector_len, u8) = lengths[index..][0..weigh_vector_len].*;
        sums +%= @as(Products, bounded) *% @as(Products, len);
    }
    var sum: u32 = @reduce(.Add, sums);
    for (counts[index..], lengths[index..]) |count, len| sum +%= @as(u32, count) *% len;
    return sum;
}

/// Whether the block's fixed code prices below its stored form, so that its plan does not take
/// the stored form (decision 44).
pub fn fixed_beats_stored(block: *const Block, bit_position: u3) bool {
    const fixed_lengths = constants.fixed_literal_length_lengths[0..constants.literal_length_used];
    const fixed_distance_lengths = constants.fixed_distance_lengths[0..constants.distance_used];
    const coded = coded_bits(block, fixed_lengths, fixed_distance_lengths, fixed_lengths, fixed_distance_lengths);
    return constants.final_bits + constants.type_bits + coded.fixed < stored_bits(block.input_len, bit_position);
}

/// Plans `block`, final or not, to start `bit_position` bits into an octet: its dynamic code, then
/// the cheapest of the three types by exact size.
pub fn plan(block: *const Block, final: bool, bit_position: u3, result: *Plan) align(constants.hot_function_alignment) void {
    assert(block.literal_length_counts[constants.end_of_block] == 1);
    result.final = final;
    if (block.symbol_count == 0) return plan_empty(bit_position, result);
    const dynamic_header_bits = plan_dynamic(block, result);
    const priced = prices(block, result, dynamic_header_bits, bit_position);
    result.kind = priced.cheapest();
    result.bits = switch (result.kind) {
        .stored => priced.stored,
        .fixed => priced.fixed,
        .dynamic => priced.dynamic,
        .reserved => unreachable,
    };
    if (result.kind == .fixed) set_fixed(result);
    if (result.kind != .stored) result.fill_entries();
}

/// Plans a block of end-of-block alone: fixed, whose 7 bits after the header cost less than a
/// stored block's pad, LEN and NLEN or a dynamic block's header (RFC 1951 §3.2.4 to §3.2.7), so
/// the prices need not be worked out.
fn plan_empty(bit_position: u3, result: *Plan) void {
    result.kind = .fixed;
    result.bits = constants.final_bits + constants.type_bits + constants.fixed_literal_length_lengths[constants.end_of_block];
    assert(result.bits < stored_bits(0, bit_position));
    set_fixed(result);
    result.fill_entries();
}

/// The fixed codes (RFC 1951 §3.2.6) into the plan.
fn set_fixed(result: *Plan) void {
    @memcpy(&result.literal_length_lengths, constants.fixed_literal_length_lengths[0..constants.literal_length_used]);
    result.literal_length_codes = fixed_literal_length_codes;
    @memcpy(&result.distance_lengths, constants.fixed_distance_lengths[0..constants.distance_used]);
    result.distance_codes = fixed_distance_codes;
}

/// Plans the empty stored block that ends a flush on an octet boundary (RFC 1951 §3.2.4),
/// starting `bit_position` bits into an octet.
pub fn plan_empty_stored(bit_position: u3, result: *Plan) void {
    result.kind = .stored;
    result.final = false;
    result.bits = stored_bits(0, bit_position);
}

/// The bits of a stored block of `len` octets starting `bit_position` bits into an octet, with its
/// header: BFINAL and BTYPE, the pad to the octet, LEN and NLEN, and the octets (RFC 1951 §3.2.4).
/// A block that crossed a slide of the window may cover more octets than one stored block holds,
/// and is priced here all the same; it is never written stored (decision 44).
pub fn stored_bits(len: usize, bit_position: u3) u64 {
    const block_header = constants.final_bits + constants.type_bits;
    const pad = (@bitSizeOf(u8) - (@as(u64, bit_position) + block_header) % @bitSizeOf(u8)) % @bitSizeOf(u8);
    return block_header + pad + constants.stored_header_bits + @as(u64, len) * @bitSizeOf(u8);
}

/// The extra bits an item of each code length symbol carries (RFC 1951 §3.2.7).
const item_extra_bits: [constants.code_length_alphabet_len]u8 = extra: {
    var bits: [constants.code_length_alphabet_len]u8 = @splat(0);
    for (constants.repeat_extra_bits, constants.repeat_previous..) |extra_bits, symbol| bits[symbol] = extra_bits;
    break :extra bits;
};

/// A dynamic block's header bits, BFINAL and BTYPE excluded: HLIT, HDIST and HCLEN, the code
/// length code, and the code lengths as items (RFC 1951 §3.2.7), `item_counts` of each symbol.
fn header_bits(dynamic: *const Plan, item_counts: *const code.ItemCounts) u64 {
    var bits: u64 = constants.hlit_bits + constants.hdist_bits + constants.hclen_bits;
    bits += @as(u64, dynamic.code_length_count) * constants.code_length_code_bits;
    for (item_counts, dynamic.code_length_lengths, item_extra_bits) |count, len, extra_bits| {
        bits += @as(u64, count) * (@as(u64, len) + extra_bits);
    }
    return bits;
}

/// Builds the block's own codes and the header that carries them (RFC 1951 §3.2.7). Returns the
/// header's bits, as `header_bits` counts them.
fn plan_dynamic(block: *const Block, result: *Plan) u64 {
    var length_counts: code.LengthCounts = undefined;
    var literal_listed: [constants.literal_length_used]code.Key = undefined;
    const literals_listed = code.build_lengths_listed(&block.literal_length_counts, constants.code_len_max, &result.literal_length_lengths, &literal_listed, &length_counts);
    code.build_codes_listed(&result.literal_length_lengths, literal_listed[0..literals_listed], &length_counts, &result.literal_length_codes);
    var distance_listed: [constants.distance_used]code.Key = undefined;
    const distances_listed = code.build_lengths_listed(&block.distance_counts, constants.code_len_max, &result.distance_lengths, &distance_listed, &length_counts);
    code.build_codes_listed(&result.distance_lengths, distance_listed[0..distances_listed], &length_counts, &result.distance_codes);
    // RFC 1951 §3.2.7: HLIT + 257 literal/length lengths, HDIST + 1 distance lengths.
    result.literal_length_count = @intCast(@max(constants.hlit_base, last_used(&result.literal_length_lengths)));
    result.distance_count = @intCast(@max(constants.hdist_base, last_used(&result.distance_lengths)));
    var item_counts: code.ItemCounts = undefined;
    result.item_count = @intCast(code.run_lengths(result.literal_length_lengths[0..result.literal_length_count], result.distance_lengths[0..result.distance_count], &result.items, &item_counts));
    code.build_lengths(&item_counts, constants.code_length_code_len_max, &result.code_length_lengths);
    code.build_codes(&result.code_length_lengths, &result.code_length_codes);
    // RFC 1951 §3.2.7: HCLEN + 4 code length code lengths, in `code_length_order`.
    var count: u16 = constants.hclen_base;
    for (constants.code_length_order, 1..) |symbol, index| {
        if (result.code_length_lengths[symbol] != 0) count = @max(count, @as(u16, @intCast(index)));
    }
    result.code_length_count = count;
    return header_bits(result, &item_counts);
}

/// One more than the last symbol with a length, found from the end.
fn last_used(lengths: []const u8) usize {
    var last = lengths.len;
    for (0..lengths.len) |_| {
        if (lengths[last - 1] != 0) break;
        last -= 1;
    }
    return last;
}

test {
    _ = @import("encoder_block_test.zig");
}
