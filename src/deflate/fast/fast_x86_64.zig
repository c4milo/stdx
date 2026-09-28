//! The DEFLATE decoder's common loop in x86-64 assembly (decision 29, which amends decision 16 for
//! this loop): the port of `fast_aarch64.zig`, whose comment describes what it takes, what it
//! leaves to `decode_rare`, and what keeps its reads and writes in bounds. It runs on a CPU with
//! BMI2 and SSSE3, and keeps in the state what x86-64's 14 registers do not hold.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const lookup = @import("../lookup.zig");
const fast = @import("fast.zig");
const Options = @import("../options.zig").Options;
const fast_copy = @import("fast_copy.zig");
const loop_text = @import("fast_x86_64_template.zig");

/// Whether the compiler assembles the x86-64 assembly: LLVM does, and Zig's own x86-64 backend, the
/// Debug default there, takes none of its directives, so a build through it keeps the Zig loop.
pub const assembles = builtin.zig_backend == .stage2_llvm;

/// Whether a CPU with `features` runs the assembly: an x86-64 CPU with BMI2 and SSSE3.
pub fn runs(features: codec.Features) bool {
    return builtin.cpu.arch == .x86_64 and features.bmi2;
}

/// Whether the assembly takes the common loop where the CPU runs it: an x86-64 target whose
/// compiler assembles it, S1 and S4 on, and no count of lookups.
pub fn takes(comptime options: Options) bool {
    return assembles and builtin.cpu.arch == .x86_64 and options.claims.word_refill and options.claims.chunk_copies and !options.count_lookups;
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `template_arguments` names. The tables' index bits stand where the aarch64 state has masks, for
/// BZHI.
const State = extern struct {
    input: [*]const u8,
    input_limit: [*]const u8,
    output: [*]u8,
    output_limit: [*]const u8,
    output_start: [*]const u8,
    buffer: u64,
    count: u64,
    literal_length_entries: [*]const lookup.Entry,
    literal_length_bits: u64,
    distance_entries: [*]const lookup.Entry,
    distance_bits: u64,
    distance_max: u64,
    /// Each distance symbol's base and mask, in place, so a combined entry's distance takes one
    /// load from the state.
    distance_codes: [fast.distance_codes.len]fast.DistanceCode,
    repeats: *const fast_copy.Repeats,
    /// The symbols decoded, which a test build counts (invariant 17).
    decoded: u64,
};

/// Runs the common loop as `fast.decode_common` does, for a caller that checked `takes` and that the
/// CPU runs the assembly: until a margin, or a symbol it leaves for `decode_rare` with the margins
/// held, at least `fast.refill_bits` bits in the buffer, and none of that symbol's bits used.
pub fn decode_common(loop: *fast.Loop) fast.Stop {
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
        .literal_length_bits = @popCount(loop.literal_length_mask),
        .distance_entries = loop.distance_entries,
        .distance_bits = @popCount(loop.distance_mask),
        .distance_max = loop.distance_max,
        .distance_codes = fast.distance_codes,
        .repeats = &fast_copy.repeats,
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
        : [stop] "={rax}" (-> u64),
        : [state] "{rdi}" (state),
        : .{
          .memory = true,
          .cc = true,
          .xmm0 = true,
          .xmm1 = true,
          .xmm2 = true,
          .rbx = true,
          .rcx = true,
          .rdx = true,
          .rsi = true,
          .r8 = true,
          .r9 = true,
          .r10 = true,
          .r11 = true,
          .r12 = true,
          .r13 = true,
          .r14 = true,
          .r15 = true,
        });
}

comptime {
    // An entry's used bits are its low six bits, the count SHRX takes, and its low octet, the
    // index BZHI takes; the subtraction of a whole entry takes them from the count's low octet.
    assert(@bitOffsetOf(lookup.Entry, "used_bits") == 0 and @bitOffsetOf(lookup.Entry, "other") == @bitSizeOf(u6));
    assert(@bitOffsetOf(lookup.Entry, "code_bits") == @bitSizeOf(u8));
    assert(@sizeOf(lookup.Entry) == @sizeOf(u32) and @sizeOf(fast.DistanceCode) == @sizeOf(u32));
    assert(@bitOffsetOf(fast.DistanceCode, "base") == 0 and @bitSizeOf(@FieldType(fast.DistanceCode, "base")) == @bitSizeOf(u16));
    assert(constants.copy_chunk_len == @sizeOf(u128));
    // The numbers the text writes: a buffer of 64 bits, whose count's bits 3 to 5 count whole
    // octets; entries of 4 octets; 0 and 1 for `fast.Stop`'s margin and rare.
    assert(std.math.log2_int(u64, @bitSizeOf(u8)) == 3 and @bitSizeOf(u64) - 1 == 63);
    assert(@sizeOf(lookup.Entry) == 4);
    assert(@intFromEnum(fast.Stop.margin) == 0 and @intFromEnum(fast.Stop.rare) == 1);
    assert(std.math.maxInt(@FieldType(lookup.Entry, "code_bits")) == 15);
    assert(@typeInfo(@TypeOf(lookup.Entry.combined_distance_symbol)).@"fn".return_type.? == u5);
    assert(@bitOffsetOf(fast.DistanceCode, "mask") == 16);
    assert(std.math.log2_int(u64, constants.copy_chunk_len) == 4);
}

/// The chunks a match copy writes before it looks at the length, and the chunks two moves take
/// where the distance is that long at least, as in the aarch64 loop.
const chunks_unconditional = 3;
const chunks_paired = 2;

/// The loop's text, with the offsets and constants it names filled in.
const template = std.fmt.comptimePrint(text: {
    var text: []const u8 = loop_text.prologue ++ "\n" ++ loop_text.iteration ++ "\n";
    for (0..fast.literals_per_refill - 1) |_| text = text ++ loop_text.literal ++ "\n" ++ loop_text.literal_next ++ "\n";
    text = text ++ loop_text.literal ++ "\n" ++ loop_text.literal_last ++ "\n";
    break :text text ++ loop_text.combined ++ "\n" ++ loop_text.copy ++ "\n" ++ loop_text.plain ++ "\n" ++ loop_text.other_cases ++ "\n" ++ loop_text.exits ++ "\n";
}, template_arguments);

/// The instructions that count symbols in a test build, and nothing in another.
const counts = if (builtin.is_test) .{
    .literal = std.fmt.comptimePrint("inc qword ptr [rdi + {d}]", .{@offsetOf(State, "decoded")}),
    .match = std.fmt.comptimePrint("add qword ptr [rdi + {d}], {d}", .{ @offsetOf(State, "decoded"), constants.decodes_per_step_max }),
} else .{ .literal = "", .match = "" };

const template_arguments = .{
    .input = @offsetOf(State, "input"),
    .input_limit = @offsetOf(State, "input_limit"),
    .output = @offsetOf(State, "output"),
    .output_limit = @offsetOf(State, "output_limit"),
    .output_start = @offsetOf(State, "output_start"),
    .buffer = @offsetOf(State, "buffer"),
    .count = @offsetOf(State, "count"),
    .literal_length_entries = @offsetOf(State, "literal_length_entries"),
    .literal_length_bits = @offsetOf(State, "literal_length_bits"),
    .distance_entries = @offsetOf(State, "distance_entries"),
    .distance_bits = @offsetOf(State, "distance_bits"),
    .distance_max = @offsetOf(State, "distance_max"),
    .distance_codes = @offsetOf(State, "distance_codes"),
    .repeats = @offsetOf(State, "repeats"),
    .steps = @offsetOf(fast_copy.Repeats, "steps"),
    .refill_bits = fast.refill_bits,
    .match_len_max = constants.match_len_max,
    .literal_bit = 1 << @bitOffsetOf(lookup.Entry, "literal"),
    .direct_bit = 1 << @bitOffsetOf(lookup.Entry, "direct"),
    .extra_bit = 1 << @bitOffsetOf(lookup.Entry, "extra"),
    .combined_bit = 1 << @bitOffsetOf(lookup.Entry, "combined"),
    .value_at = @bitOffsetOf(lookup.Entry, "value"),
    .code_bits_at = @bitOffsetOf(lookup.Entry, "code_bits"),
    .combined_length_mask = (1 << lookup.combined_length_bits) - 1,
    .distance_symbol_at = @bitOffsetOf(lookup.Entry, "value") + lookup.combined_length_bits,
    .chunk = constants.copy_chunk_len,
    .third_chunk_at = constants.copy_chunk_len * (chunks_unconditional - 1),
    .chunks_len = constants.copy_chunk_len * chunks_unconditional,
    .pair = constants.copy_chunk_len * chunks_paired,
    .count_literal = counts.literal,
    .count_match = counts.match,
};

test "the assembly runs only on an x86-64 CPU with BMI2 and SSSE3" {
    try std.testing.expect(!runs(.{}));
    try std.testing.expectEqual(builtin.cpu.arch == .x86_64, runs(.{ .bmi2 = true }));
}
