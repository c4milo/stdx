//! The encoder's block: the symbols it holds, their counts, and the plan it is written by. The plan
//! prices the block exactly three ways from its counts, stored, fixed and dynamic, and takes the
//! cheapest (decision 14, E3; RFC 1951 §3.2.3). A block's input is always in the window, so the
//! stored form is always a choice, and no block costs more than its input stored.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const code = @import("encoder_code.zig");

/// A literal, or a length/distance pair (RFC 1951 §3.2.5).
pub const Symbol = packed struct(u32) {
    /// A literal's octet, or a pair's length less `match_len_min`.
    value: u8,
    /// A pair's distance, or 0 for a literal.
    distance: u16,
    reserved: u8 = 0,
};

/// Each length's code, 257 to 285 less 257, lengths 3 to 258 (RFC 1951 §3.2.5).
const length_codes: [constants.match_len_max - constants.match_len_min + 1]u8 = codes: {
    var codes_of: [constants.match_len_max - constants.match_len_min + 1]u8 = undefined;
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
const near_codes: [near_distances]u8 = distance_codes(false);
/// The comptime branches building the far table takes: one per distance.
const distance_codes_quota = 100_000;
const far_codes: [constants.window_len >> far_distance_shift]u8 = distance_codes(true);

fn distance_codes(comptime far: bool) [if (far) constants.window_len >> far_distance_shift else near_distances]u8 {
    @setEvalBranchQuota(distance_codes_quota);
    var codes_of: [if (far) constants.window_len >> far_distance_shift else near_distances]u8 = @splat(0);
    for (constants.distance_base, constants.distance_extra_bits, 0..) |base, extra, index| {
        for (base..@as(usize, base) + (1 << extra)) |distance| {
            const slot = if (far) (distance - 1) >> far_distance_shift else distance - 1;
            if (slot < codes_of.len and (far or distance <= near_distances)) codes_of[slot] = index;
        }
    }
    return codes_of;
}

/// The code of a length, as its index from 257.
pub fn length_code(len: usize) u8 {
    assert(len >= constants.match_len_min and len <= constants.match_len_max);
    return length_codes[len - constants.match_len_min];
}

/// The code of a distance. Both tables are read, so the choice is a select and not a branch, which
/// the distances of a block would mispredict.
pub fn distance_code(distance: usize) u8 {
    assert(distance >= 1 and distance <= constants.window_len);
    const near = near_codes[@min(distance, near_distances) - 1];
    const far = far_codes[(distance - 1) >> far_distance_shift];
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
    /// Where the block's input starts in the window, and how many octets its symbols cover.
    input_start: usize,
    input_len: usize,

    /// Starts an empty block at `input_start`. Every block ends with end-of-block (RFC 1951
    /// §3.2.3), which its counts hold from the start.
    pub fn reset(self: *Block, input_start: usize) void {
        self.symbol_count = 0;
        @memset(&self.literal_length_counts, 0);
        @memset(&self.distance_counts, 0);
        self.literal_length_counts[constants.end_of_block] = 1;
        self.input_start = input_start;
        self.input_len = 0;
    }

    pub fn full(self: *const Block) bool {
        return self.symbol_count == constants.block_symbols_max;
    }

    pub fn add_literal(self: *Block, octet: u8) void {
        assert(!self.full());
        self.symbols[self.symbol_count] = .{ .value = octet, .distance = 0 };
        self.symbol_count += 1;
        self.literal_length_counts[octet] += 1;
        self.input_len += 1;
    }

    pub fn add_pair(self: *Block, len: usize, distance: usize) void {
        assert(!self.full());
        assert(distance >= 1 and distance <= constants.encoder_distance_max);
        self.symbols[self.symbol_count] = .{ .value = @intCast(len - constants.match_len_min), .distance = @intCast(distance) };
        self.symbol_count += 1;
        self.literal_length_counts[constants.first_length_symbol + length_code(len)] += 1;
        self.distance_counts[distance_code(distance)] += 1;
        self.input_len += len;
    }
};

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
    /// Each length code's and distance code's entry for the symbol writer, from the codes above.
    length_entries: [constants.length_base.len]CodeEntry,
    distance_entries: [constants.distance_used]CodeEntry,

    /// Fills `length_entries` and `distance_entries` from the plan's codes.
    pub fn fill_entries(self: *Plan) void {
        for (&self.length_entries, constants.length_base, constants.length_extra_bits, 0..) |*entry, base, extra_bits, index| {
            const symbol = constants.first_length_symbol + index;
            entry.* = .{ .code = self.literal_length_codes[symbol], .base = base, .code_bits = self.literal_length_lengths[symbol], .extra_bits = extra_bits };
        }
        for (&self.distance_entries, constants.distance_base[0..constants.distance_used], constants.distance_extra_bits[0..constants.distance_used], 0..) |*entry, base, extra_bits, index| {
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

/// The block's prices, with `dynamic` its planned dynamic code's, which `plan_dynamic` built.
pub fn prices(block: *const Block, dynamic: *const Plan, bit_position: u3) Prices {
    const block_header = constants.final_bits + constants.type_bits;
    const fixed_lengths = constants.fixed_literal_length_lengths[0..constants.literal_length_used];
    const fixed_distance_lengths = constants.fixed_distance_lengths[0..constants.distance_used];
    return .{
        .stored = stored_bits(block.input_len, bit_position),
        .fixed = block_header + data_bits(block, fixed_lengths, fixed_distance_lengths),
        .dynamic = block_header + header_bits(dynamic) + data_bits(block, &dynamic.literal_length_lengths, &dynamic.distance_lengths),
    };
}

/// Plans `block`, final or not, to start `bit_position` bits into an octet: its dynamic code, then
/// the cheapest of the three types by exact size.
pub fn plan(block: *const Block, final: bool, bit_position: u3, result: *Plan) void {
    assert(block.literal_length_counts[constants.end_of_block] == 1);
    result.final = final;
    plan_dynamic(block, result);
    const priced = prices(block, result, bit_position);
    result.kind = priced.cheapest();
    result.bits = switch (result.kind) {
        .stored => priced.stored,
        .fixed => priced.fixed,
        .dynamic => priced.dynamic,
        .reserved => unreachable,
    };
    if (result.kind == .fixed) {
        @memcpy(&result.literal_length_lengths, constants.fixed_literal_length_lengths[0..constants.literal_length_used]);
        result.literal_length_codes = fixed_literal_length_codes;
        @memcpy(&result.distance_lengths, constants.fixed_distance_lengths[0..constants.distance_used]);
        result.distance_codes = fixed_distance_codes;
    }
    if (result.kind != .stored) result.fill_entries();
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
pub fn stored_bits(len: usize, bit_position: u3) u64 {
    assert(len <= constants.stored_len_max);
    const block_header = constants.final_bits + constants.type_bits;
    const pad = (@bitSizeOf(u8) - (@as(u64, bit_position) + block_header) % @bitSizeOf(u8)) % @bitSizeOf(u8);
    return block_header + pad + constants.stored_header_bits + @as(u64, len) * @bitSizeOf(u8);
}

/// The bits of a block's symbols and end-of-block under the given code lengths, with their extra
/// bits (RFC 1951 §3.2.5).
fn data_bits(block: *const Block, literal_length_lengths: []const u8, distance_lengths: []const u8) u64 {
    var bits: u64 = 0;
    for (block.literal_length_counts, literal_length_lengths, 0..) |count, len, symbol| {
        bits += @as(u64, count) * len;
        if (symbol >= constants.first_length_symbol) bits += @as(u64, count) * constants.length_extra_bits[symbol - constants.first_length_symbol];
    }
    for (block.distance_counts, distance_lengths, constants.distance_extra_bits) |count, len, extra| {
        bits += @as(u64, count) * (len + extra);
    }
    return bits;
}

/// A dynamic block's header bits, BFINAL and BTYPE excluded: HLIT, HDIST and HCLEN, the code
/// length code, and the code lengths as items (RFC 1951 §3.2.7).
fn header_bits(dynamic: *const Plan) u64 {
    var bits: u64 = constants.hlit_bits + constants.hdist_bits + constants.hclen_bits;
    bits += @as(u64, dynamic.code_length_count) * constants.code_length_code_bits;
    for (dynamic.items[0..dynamic.item_count]) |item| {
        bits += dynamic.code_length_lengths[item.symbol];
        if (item.symbol >= constants.repeat_previous) bits += constants.repeat_extra_bits[item.symbol - constants.repeat_previous];
    }
    return bits;
}

/// Builds the block's own codes and the header that carries them (RFC 1951 §3.2.7).
fn plan_dynamic(block: *const Block, result: *Plan) void {
    code.build_lengths(&block.literal_length_counts, constants.code_len_max, &result.literal_length_lengths);
    code.build_lengths(&block.distance_counts, constants.code_len_max, &result.distance_lengths);
    code.build_codes(&result.literal_length_lengths, &result.literal_length_codes);
    code.build_codes(&result.distance_lengths, &result.distance_codes);
    // RFC 1951 §3.2.7: HLIT + 257 literal/length lengths, HDIST + 1 distance lengths.
    result.literal_length_count = @intCast(@max(constants.hlit_base, last_used(&result.literal_length_lengths)));
    result.distance_count = @intCast(@max(constants.hdist_base, last_used(&result.distance_lengths)));
    var lengths: [code.items_max]u8 = undefined;
    @memcpy(lengths[0..result.literal_length_count], result.literal_length_lengths[0..result.literal_length_count]);
    @memcpy(lengths[result.literal_length_count..][0..result.distance_count], result.distance_lengths[0..result.distance_count]);
    result.item_count = @intCast(code.run_lengths(lengths[0 .. result.literal_length_count + result.distance_count], &result.items));
    var item_counts: [constants.code_length_alphabet_len]u16 = @splat(0);
    for (result.items[0..result.item_count]) |item| item_counts[item.symbol] += 1;
    code.build_lengths(&item_counts, constants.code_length_code_len_max, &result.code_length_lengths);
    code.build_codes(&result.code_length_lengths, &result.code_length_codes);
    // RFC 1951 §3.2.7: HCLEN + 4 code length code lengths, in `code_length_order`.
    var count: u16 = constants.hclen_base;
    for (constants.code_length_order, 1..) |symbol, index| {
        if (result.code_length_lengths[symbol] != 0) count = @max(count, @as(u16, @intCast(index)));
    }
    result.code_length_count = count;
}

/// One more than the last symbol with a length.
fn last_used(lengths: []const u8) usize {
    var last: usize = 0;
    for (lengths, 1..) |len, index| {
        if (len != 0) last = index;
    }
    return last;
}

test {
    _ = @import("encoder_block_test.zig");
}
