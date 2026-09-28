//! The DEFLATE decoder's common loop in aarch64 assembly (decision 29, which amends decision 16 for
//! this loop): `fast.decode_common` with its state in registers the assembly allots, taking the
//! symbols the Zig loop takes and writing the same octets.
//!
//! It takes S1 and S4 on, and a decode that counts no lookups; the Zig loop takes every other
//! setting, and every other target. Like the Zig loop, it checks decision 16's margins at the top
//! of each iteration, and leaves every symbol but a literal the table decodes and a match inside
//! this call's output to `decode_rare`. Unlike it, it copies a match whose distance is below a
//! chunk itself, from the chunk of this call's output before the target, and leaves only a match
//! with less than a chunk of this call's output before it.
//!
//! Its reads and writes go by address, without Zig's bounds checks. The margins keep the refill's
//! load inside the input and an iteration's stores inside the output, the tables' masks keep each
//! lookup inside its table, and the checks of each match keep its loads inside the octets this
//! call wrote (invariant 10).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const lookup = @import("../lookup.zig");
const fast = @import("fast.zig");
const fast_copy = @import("fast_copy.zig");
const Options = @import("../options.zig").Options;
const loop_text = @import("fast_aarch64_template.zig");

/// Whether the assembly takes the common loop: an aarch64 target, S1 and S4 on, and no count of
/// lookups.
pub fn takes(comptime options: Options) bool {
    return builtin.cpu.arch == .aarch64 and options.claims.word_refill and options.claims.chunk_copies and !options.count_lookups;
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `template_arguments` names.
const State = extern struct {
    /// The input's next octet, and the last place an 8-octet load may start.
    input: [*]const u8,
    input_limit: [*]const u8,
    /// The output's next octet, the last place an iteration may start, and the call's first octet.
    output: [*]u8,
    output_limit: [*]const u8,
    output_start: [*]const u8,
    buffer: u64,
    count: u64,
    literal_length_entries: [*]const lookup.Entry,
    literal_length_mask: u64,
    distance_entries: [*]const lookup.Entry,
    distance_mask: u64,
    distance_max: u64,
    distance_codes: [*]const fast.DistanceCode,
    repeats: *const fast_copy.Repeats,
    /// The literal/length codes longer than the table, which the loop decodes on from their
    /// prefixes: each length's codes, the code's symbols in code order, and each length symbol's
    /// entry for a code of no bits.
    long_codes: *const [constants.code_len_max + 1]lookup.LongCodes,
    literal_length_symbols: [*]const u16,
    length_entries: *const [constants.length_base.len]lookup.Entry,
    /// The symbols decoded, which a test build counts (invariant 17).
    decoded: u64,
};

/// Runs the common loop as `fast.decode_common` does, for a caller that checked `takes`: until a
/// margin, or a symbol it leaves for `decode_rare` with the margins held, at least
/// `fast.refill_bits` bits in the buffer, and none of that symbol's bits used.
pub fn decode_common(loop: *fast.Loop, codes: fast.Codes) fast.Stop {
    if (loop.rest.len < fast.input_slack or loop.room() < fast.output_slack) return .margin;
    assert(loop.count <= @bitSizeOf(u64));
    // The masks index no entry past their tables.
    assert(loop.literal_length_mask < lookup.LiteralLengthTable.len and loop.distance_mask < lookup.DistanceTable.len);
    var state: State = .{
        .input = loop.rest.ptr,
        .input_limit = loop.rest[loop.rest.len - fast.input_slack ..].ptr,
        .output = loop.output[loop.written..].ptr,
        .output_limit = loop.output[loop.output.len - fast.output_slack ..].ptr,
        .output_start = loop.output.ptr,
        .buffer = loop.buffer,
        .count = loop.count,
        .literal_length_entries = loop.literal_length_entries,
        .literal_length_mask = loop.literal_length_mask,
        .distance_entries = loop.distance_entries,
        .distance_mask = loop.distance_mask,
        .distance_max = loop.distance_max,
        .distance_codes = &fast.distance_codes,
        .repeats = &fast_copy.repeats,
        .long_codes = &codes.literal_length_table.long_codes,
        .literal_length_symbols = &codes.literal_length_code.symbols,
        .length_entries = &lookup.length_entries,
        .decoded = 0,
    };
    const stop: fast.Stop = @enumFromInt(execute(&state));
    const taken = @intFromPtr(state.input) - @intFromPtr(loop.rest.ptr);
    assert(taken < loop.rest.len);
    loop.rest = loop.rest[taken..];
    loop.written = @intFromPtr(state.output) - @intFromPtr(loop.output.ptr);
    assert(loop.written <= loop.output.len);
    loop.buffer = state.buffer;
    loop.count = @intCast(state.count);
    if (builtin.is_test) loop.decoded += state.decoded;
    return stop;
}

/// Decodes until a margin or a symbol for `decode_rare`, as `State` describes, and returns which.
noinline fn execute(state: *State) u64 {
    return asm volatile (template
        : [stop] "={x0}" (-> u64),
        : [state] "{x0}" (state),
        : .{
          .memory = true,
          .nzcv = true,
          .v0 = true,
          .v1 = true,
          .v2 = true,
          .x1 = true,
          .x2 = true,
          .x3 = true,
          .x4 = true,
          .x5 = true,
          .x6 = true,
          .x7 = true,
          .x8 = true,
          .x9 = true,
          .x10 = true,
          .x11 = true,
          .x12 = true,
          .x13 = true,
          .x14 = true,
          .x15 = true,
          .x16 = true,
          .x17 = true,
          .x19 = true,
          .x20 = true,
          .x21 = true,
          .x22 = true,
          .x23 = true,
          .x24 = true,
          .x25 = true,
          .x26 = true,
          .x27 = true,
          .x28 = true,
        });
}

comptime {
    // The fields `ldp` loads in pairs are adjacent.
    assert(@offsetOf(State, "input_limit") == @offsetOf(State, "input") + @sizeOf(u64));
    assert(@offsetOf(State, "output_limit") == @offsetOf(State, "output") + @sizeOf(u64));
    assert(@offsetOf(State, "count") == @offsetOf(State, "buffer") + @sizeOf(u64));
    assert(@offsetOf(State, "literal_length_mask") == @offsetOf(State, "literal_length_entries") + @sizeOf(u64));
    assert(@offsetOf(State, "distance_mask") == @offsetOf(State, "distance_entries") + @sizeOf(u64));
    assert(@offsetOf(State, "distance_codes") == @offsetOf(State, "distance_max") + @sizeOf(u64));
    // An entry's low six bits are its bits, so a shift by the whole entry uses them, and its low
    // octet is its bits for every entry the loop takes, so a subtraction of the whole entry takes
    // them from the count's low octet.
    assert(@bitOffsetOf(lookup.Entry, "used_bits") == 0 and @bitOffsetOf(lookup.Entry, "other") == @bitSizeOf(u6));
    assert(@bitOffsetOf(lookup.Entry, "code_bits") == @bitSizeOf(u8));
    assert(@sizeOf(lookup.Entry) == @sizeOf(u32) and @sizeOf(fast.DistanceCode) == @sizeOf(u32));
    assert(@bitOffsetOf(fast.DistanceCode, "base") == 0 and @bitSizeOf(@FieldType(fast.DistanceCode, "base")) == @bitSizeOf(u16));
    // A chunk is one vector register.
    assert(constants.copy_chunk_len == @sizeOf(u128));
    // The numbers the text writes (fast_aarch64_template.zig).
    assert(@bitSizeOf(u64) == 64 and std.math.log2_int(u64, @bitSizeOf(u8)) == 3);
    assert((@bitSizeOf(u64) - 1) & ~@as(u64, @bitSizeOf(u8) - 1) == 0x38);
    assert(std.math.maxInt(u8) == 0xff and @bitSizeOf(u64) <= std.math.maxInt(u8));
    assert(std.math.log2_int(u64, @sizeOf(lookup.Entry)) == 2);
    assert(@typeInfo(@TypeOf(lookup.Entry.combined_distance_symbol)).@"fn".return_type.? == u5);
    assert(@bitSizeOf(@FieldType(lookup.Entry, "code_bits")) == 4 and std.math.log2_int(u64, constants.copy_chunk_len) == 4);
    // A long code's entry: `other` in bits 6 and 7, whose low bit the block's end and an invalid
    // entry set and a long code's does not; codes of 15 bits at most; each length's codes in 8
    // octets, the first code's value, the count and the place 16 bits each, low to high.
    assert(@bitOffsetOf(lookup.Entry, "other") == 6 and @intFromEnum(lookup.Other.long) == 2);
    assert(@intFromEnum(lookup.Other.end_of_block) & 1 == 1 and @intFromEnum(lookup.Other.invalid) & 1 == 1);
    assert(constants.code_len_max == 15);
    assert(@sizeOf(lookup.LongCodes) == 8 and @bitOffsetOf(lookup.LongCodes, "count") == 16 and @bitOffsetOf(lookup.LongCodes, "index") == 32);
    // Symbols 257 to 285 are the lengths; 256 ends the block (RFC 1951 §3.2.5).
    assert(constants.first_length_symbol == 257 and constants.length_base.len == 29 and constants.end_of_block == 256);
    assert(@intFromEnum(fast.Stop.margin) == 0 and @intFromEnum(fast.Stop.rare) == 1);
    // A run of literals uses no more bits than a refill leaves, and a pair from two entries, the
    // literal after it and the next symbol's lookup read bits below 64, the stream's
    // (fast_aarch64_template.zig).
    assert(fast.literals_per_refill * constants.literal_length_table_bits <= fast.refill_bits);
    const length_bits_max = constants.literal_length_table_bits + std.mem.max(u7, &constants.length_extra_bits);
    const distance_bits_max = constants.distance_table_bits + std.mem.max(u7, &constants.distance_extra_bits);
    assert(length_bits_max + distance_bits_max + 2 * constants.literal_length_table_bits <= @bitSizeOf(u64));
    assert(length_bits_max + distance_bits_max + constants.literal_length_table_bits <= fast.refill_bits);
    // The rest of a match's copies reach no further than the margin's room.
    assert(std.mem.alignForward(usize, constants.match_len_max, constants.copy_chunk_len) <= fast.output_slack);
}

/// The chunks a match copy writes before it looks at the length: most matches are that short.
const chunks_unconditional = 3;

/// The chunks one `ldp` and one `stp` move, where the distance is that long at least.
const chunks_paired = 2;

/// The loop's text, with the offsets and constants it names filled in.
const template = std.fmt.comptimePrint(text: {
    var text: []const u8 = loop_text.prologue ++ "\n" ++ loop_text.iteration ++ "\n";
    for (0..fast.literals_per_refill - 1) |_| text = text ++ loop_text.literal ++ "\n" ++ loop_text.literal_next ++ "\n";
    text = text ++ loop_text.literal ++ "\n" ++ loop_text.literal_last ++ "\n";
    break :text text ++ loop_text.combined ++ "\n" ++ loop_text.copy ++ "\n" ++ loop_text.plain ++ "\n" ++ loop_text.other_cases ++ "\n" ++ loop_text.long_code ++ "\n" ++ loop_text.exits ++ "\n";
}, template_arguments);

/// The instructions that count symbols in a test build, and nothing in another.
const counts = if (builtin.is_test) .{
    .load = std.fmt.comptimePrint("ldr x25, [x0, #{d}]", .{@offsetOf(State, "decoded")}),
    .store = std.fmt.comptimePrint("str x25, [x0, #{d}]", .{@offsetOf(State, "decoded")}),
    .literal = "add x25, x25, #1",
    .match = std.fmt.comptimePrint("add x25, x25, #{d}", .{constants.decodes_per_step_max}),
} else .{ .load = "", .store = "", .literal = "", .match = "" };

const template_arguments = .{
    .input = @offsetOf(State, "input"),
    .output = @offsetOf(State, "output"),
    .output_start = @offsetOf(State, "output_start"),
    .buffer = @offsetOf(State, "buffer"),
    .literal_length_entries = @offsetOf(State, "literal_length_entries"),
    .distance_entries = @offsetOf(State, "distance_entries"),
    .distance_max = @offsetOf(State, "distance_max"),
    .repeats = @offsetOf(State, "repeats"),
    .steps = @offsetOf(fast_copy.Repeats, "steps"),
    .refill_bits = fast.refill_bits,
    .match_len_max = constants.match_len_max,
    .literal_at = @bitOffsetOf(lookup.Entry, "literal"),
    .direct_at = @bitOffsetOf(lookup.Entry, "direct"),
    .extra_at = @bitOffsetOf(lookup.Entry, "extra"),
    .combined_at = @bitOffsetOf(lookup.Entry, "combined"),
    .value_at = @bitOffsetOf(lookup.Entry, "value"),
    .code_bits_at = @bitOffsetOf(lookup.Entry, "code_bits"),
    .combined_length_bits = lookup.combined_length_bits,
    .distance_symbol_at = @bitOffsetOf(lookup.Entry, "value") + lookup.combined_length_bits,
    .mask_at = @bitOffsetOf(fast.DistanceCode, "mask"),
    .chunk = constants.copy_chunk_len,
    .third_chunk_at = constants.copy_chunk_len * (chunks_unconditional - 1),
    .chunks_len = constants.copy_chunk_len * chunks_unconditional,
    .long_codes = @offsetOf(State, "long_codes"),
    .literal_length_symbols = @offsetOf(State, "literal_length_symbols"),
    .length_entries = @offsetOf(State, "length_entries"),
    .pair = constants.copy_chunk_len * chunks_paired,
    .load_decoded = counts.load,
    .store_decoded = counts.store,
    .count_literal = counts.literal,
    .count_match = counts.match,
};
