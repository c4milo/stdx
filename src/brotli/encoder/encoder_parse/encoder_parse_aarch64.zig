//! Level 1's parse in aarch64 assembly (decision 63, which amends decision 16 for this loop): the
//! positions of a meta-block probed in codec's match finder's tables, each match stepped back,
//! measured and weighed, and recorded as a command with its counts, as `parse_zig` does. It writes
//! the commands, counts and table entries the Zig parse writes.
//!
//! It takes level 1 on an aarch64 target built by LLVM; every other target runs the Zig parse. A
//! command whose insert or copy length passes the length tables leaves the text: Zig records it
//! and its table entries, and the text starts again after it.
//!
//! Its reads and writes go by address, without Zig's bounds checks. Every position it probes lies
//! below the search's end, 8 octets before the block's end, so each read of 8 octets stays in the
//! block; a hash's top 14 bits keep each entry inside its table; a command copies 4 octets or
//! more, so the count stays below the commands' room; and an octet or a symbol indexes its counts.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const encoder_parse = @import("encoder_parse.zig");
const loop_text = @import("encoder_parse_aarch64_template.zig");

const finder = codec.match_finder;
const Commands = encoder_commands.Commands;
const Command = encoder_commands.Command;

/// Whether the assembly takes the parse: an aarch64 target built by LLVM, which places the
/// assembly's registers, and level 1's tables, whose hashes the text writes.
pub fn takes(comptime level: finder.Level) bool {
    const tables = level.short_hash_len == constants.encoder_level1_hash_len and
        level.short_hash_log == constants.encoder_level1_hash_log and
        level.long_hash_log == constants.encoder_level1_long_hash_log;
    return tables and builtin.cpu.arch == .aarch64 and builtin.zig_backend == .stage2_llvm;
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets but the ring, at
/// the offsets `template_arguments` names.
const State = extern struct {
    window: [*]const u8,
    short: [*]u32,
    long: [*]u32,
    base: u64,
    position: u64,
    anchor: u64,
    end: u64,
    search_end: u64,
    reach: u64,
    literal_cost: u64,
    commands: [*]Command,
    count: u64,
    literal_counts: [*]u16,
    /// The literals the commands of one call inserted.
    inserted: u64,
    ring: [constants.last_distances_count]u32,
    small_symbols: [*]const u16,
    insert_codes: [*]const u8,
    copy_codes: [*]const u8,
    insert_copy_symbols: [*]const u16,
    command_counts: [*]u16,
    distance_counts: [*]u16,
    /// A match whose command the text leaves to Zig, when `pending` is 1.
    found_position: u64,
    found_len: u64,
    found_offset: u64,
    pending: u64,
};

/// `encoder_parse.parse` for a level that `takes`.
pub fn parse(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, start: usize, end: usize, commands: *Commands) void {
    @setRuntimeSafety(safety);
    comptime assert(takes(level));
    assert(start <= end and end <= window.len and commands.count == 0);
    const search_end = end -| codec.constants.match_read_len;
    var state: State = .{
        .window = window.ptr,
        .short = &matcher.short,
        .long = &matcher.long,
        .base = matcher.base,
        .position = start,
        .anchor = start,
        .end = end,
        .search_end = search_end,
        .reach = encoder_parse.reach(level),
        .literal_cost = commands.literal_cost,
        .commands = &commands.commands,
        .count = 0,
        .literal_counts = &commands.literal_counts,
        .inserted = 0,
        .ring = commands.last_distances,
        .small_symbols = @ptrCast(&encoder_commands.small_symbols),
        .insert_codes = @ptrCast(&encoder_commands.insert_codes),
        .copy_codes = @ptrCast(&encoder_commands.copy_codes),
        .insert_copy_symbols = @ptrCast(&encoder_commands.insert_copy_symbols),
        .command_counts = &commands.command_counts,
        .distance_counts = &commands.distance_counts,
        .found_position = 0,
        .found_len = 0,
        .found_offset = 0,
        .pending = 0,
    };
    // Each pass ends at the search's end or at a command for Zig, which moves the position forward.
    for (0..end - start + 1) |_| {
        state.pending = 0;
        execute(&state);
        // A miss may step past the end, as in the Zig parse; the anchor stays within it.
        assert(state.anchor <= state.position and state.anchor <= end and state.count <= commands.commands.len);
        commands.count = state.count;
        commands.literals_len += state.inserted;
        commands.inserted += state.inserted;
        commands.last_distances = state.ring;
        state.inserted = 0;
        if (state.pending == 0) break;
        take_pending(level, safety, matcher, window, search_end, commands, &state);
    }
    commands.add_literals(safety, window[state.anchor..end]);
}

/// The command the text left to Zig: its literals, its record and counts, and its table entries.
fn take_pending(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, search_end: usize, commands: *Commands, state: *State) void {
    @setRuntimeSafety(safety);
    const position = state.found_position;
    const len = state.found_len;
    assert(position >= state.anchor and position < search_end and state.found_offset > 0);
    commands.add(safety, window, state.anchor, position, len, state.found_offset);
    encoder_parse.insert(level, safety, matcher, window, position + codec.constants.match_insert_skip, position + len, search_end);
    state.position = position + len;
    state.anchor = position + len;
    state.count = commands.count;
    state.ring = commands.last_distances;
}

/// Parses the positions `State` describes, and stores the state back.
noinline fn execute(state: *State) void {
    asm volatile (template
        :
        : [state] "{x0}" (state),
        : .{
          .memory = true,
          .nzcv = true,
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

/// The bits a hash keeps: the product's top `encoder_level1_hash_log`.
const hash_shift = @bitSizeOf(u64) - constants.encoder_level1_hash_log;

comptime {
    // The fields `ldp` loads and `stp` stores in pairs are adjacent.
    for ([_][2][]const u8{
        .{ "window", "short" },             .{ "long", "base" },               .{ "position", "anchor" },
        .{ "end", "search_end" },           .{ "reach", "literal_cost" },      .{ "commands", "count" },
        .{ "literal_counts", "inserted" },  .{ "insert_codes", "copy_codes" }, .{ "command_counts", "distance_counts" },
        .{ "found_position", "found_len" }, .{ "found_offset", "pending" },
    }) |pair| assert(@offsetOf(State, pair[1]) == @offsetOf(State, pair[0]) + @sizeOf(u64));
    // The ring's four distances as two pairs of 4 octets.
    assert(constants.last_distances_count == 4 and @sizeOf([constants.last_distances_count]u32) == 2 * @sizeOf(u64));
    // Table entries of 4 octets, counts and symbols of 2, length codes of 1, commands of 8.
    assert(@sizeOf([2]u10) == 2 * @sizeOf(u16) and @sizeOf([2]u5) == 2 and @sizeOf(Command) == @sizeOf(u64));
    // A command's fields at bits 0, 16, 32 and 48, its symbol in the low `symbol_bits`.
    assert(@offsetOf(Command, "insert_len") == 0 and @offsetOf(Command, "copy_len") == 2);
    assert(@offsetOf(Command, "symbol_and_code") == 4 and @offsetOf(Command, "distance_extra") == 6);
    assert(builtin.cpu.arch.endian() == .little or builtin.cpu.arch != .aarch64);
    // The hashes: the short one of 5 octets, the long one of 8, both of 14 bits.
    assert(codec.constants.long_hash_len == @sizeOf(u64) and constants.encoder_level1_long_hash_log == constants.encoder_level1_hash_log);
    // The tables the symbol reads: small lengths by 16 and 32, codes of the lengths below 128.
    assert(encoder_commands.small_symbols.len == constants.encoder_distance_kinds and encoder_commands.small_symbols[0].len == constants.encoder_small_insert_len);
    assert(encoder_commands.small_symbols[0][0].len == constants.encoder_small_copy_len and constants.encoder_small_copy_len == 1 << 5);
    assert(constants.encoder_small_insert_len * constants.encoder_small_copy_len == 1 << 9);
    assert(encoder_commands.insert_codes.len == constants.encoder_length_table_len and encoder_commands.copy_codes.len == constants.encoder_length_table_len);
    assert(encoder_commands.insert_copy_symbols[0].len == constants.insert_length_codes.len and encoder_commands.insert_copy_symbols[0][0].len == constants.insert_length_codes.len);
    // The distance codes (`distance_code_of`): distance + 3 from 2 << n to 4 << n, the code
    // 16 + 2(n - 1) + half.
    assert(constants.distance_codes_per_extra_bits == 2 and constants.distance_short_codes_count == 16);
    // The cost rule: eighths of a bit, a shift of 3.
    assert(encoder_commands.eighths == 1 << 3);
    // The inserts after a match, and the skip after a miss.
    assert(codec.constants.match_insert_step > 0 and codec.constants.match_read_len == @sizeOf(u64));
}

/// The loop's text, with the offsets and constants it names filled in.
/// The near copy runs until the position passes the reach, then the far copy to the search's end.
const template = fill(loop_text.prologue ++ "\n" ++ near ++ far ++ loop_text.exit ++ "\n", template_arguments);
const match_text = loop_text.extend ++ "\n" ++ loop_text.command ++ "\n" ++ loop_text.record ++ "\n";
const near = loop_text.position ++ "\n" ++ loop_text.tables ++ "\n" ++ match_text;
const far = loop_text.position_far ++ "\n" ++ loop_text.tables_far ++ "\n" ++ match_text;

/// The branches `fill` takes at compile time: its replacing loops over the text.
const fill_quota = 10_000_000;

/// `text` with each `{[name]}` of `arguments`' fields replaced by the field's value in decimal, as
/// DEFLATE's x86-64 loop fills its text: `comptimePrint` takes 32 arguments at most.
fn fill(comptime text: []const u8, comptime arguments: anytype) []const u8 {
    @setEvalBranchQuota(fill_quota);
    comptime var out: []const u8 = text;
    inline for (@typeInfo(@TypeOf(arguments)).@"struct".fields) |field| {
        const key = "{[" ++ field.name ++ "]}";
        const value = std.fmt.comptimePrint("{d}", .{@field(arguments, field.name)});
        comptime var replaced: []const u8 = "";
        comptime var at: usize = 0;
        inline while (std.mem.indexOfPos(u8, out, at, key)) |found| {
            replaced = replaced ++ out[at..found] ++ value;
            at = found + key.len;
        }
        out = replaced ++ out[at..];
    }
    // Every name the text writes is filled.
    if (std.mem.indexOf(u8, out, "{[") != null) @compileError("a name of the text has no value");
    return out;
}

const template_arguments = .{
    .window = @offsetOf(State, "window"),
    .long = @offsetOf(State, "long"),
    .position = @offsetOf(State, "position"),
    .end = @offsetOf(State, "end"),
    .reach = @offsetOf(State, "reach"),
    .commands = @offsetOf(State, "commands"),
    .count = @offsetOf(State, "count"),
    .literal_counts = @offsetOf(State, "literal_counts"),
    .inserted = @offsetOf(State, "inserted"),
    .ring = @offsetOf(State, "ring"),
    .ring_back = @offsetOf(State, "ring") + @sizeOf(u64),
    .small_symbols = @offsetOf(State, "small_symbols"),
    .insert_codes = @offsetOf(State, "insert_codes"),
    .insert_copy_symbols = @offsetOf(State, "insert_copy_symbols"),
    .command_counts = @offsetOf(State, "command_counts"),
    .found_position = @offsetOf(State, "found_position"),
    .found_offset = @offsetOf(State, "found_offset"),
    .multiplier_0 = @as(u16, @truncate(codec.constants.match_hash_multiplier)),
    .multiplier_1 = @as(u16, @truncate(codec.constants.match_hash_multiplier >> @bitSizeOf(u16))),
    .multiplier_2 = @as(u16, @truncate(codec.constants.match_hash_multiplier >> @bitSizeOf(u32))),
    .multiplier_3 = @as(u16, @truncate(codec.constants.match_hash_multiplier >> @bitSizeOf(u48))),
    .short_shift = @bitSizeOf(u64) - @as(u32, constants.encoder_level1_hash_len) * @bitSizeOf(u8),
    .hash_shift = hash_shift,
    .read_after = 1 + codec.constants.match_read_len,
    .skip_log = codec.constants.match_skip_log,
    .eighths_shift = std.math.log2_int(u32, encoder_commands.eighths),
    .match_cost_base = constants.encoder_match_cost_base,
    .length_table_len = constants.encoder_length_table_len,
    .distance_offset = constants.distance_offset,
    .distance_prefix_base = constants.distance_prefix_base,
    .code_from_bits = constants.distance_short_codes_count - constants.distance_codes_per_extra_bits,
    .small_insert_len = constants.encoder_small_insert_len,
    .small_copy_len = constants.encoder_small_copy_len,
    .small_last_shift = std.math.log2_int(u32, constants.encoder_small_insert_len * constants.encoder_small_copy_len),
    .small_insert_shift = std.math.log2_int(u32, constants.encoder_small_copy_len),
    .codes_count = constants.insert_length_codes.len,
    .symbol_bits = encoder_commands.symbol_bits,
    .last_distance_symbols = constants.insert_copy_last_distance_symbols,
    .insert_skip = codec.constants.match_insert_skip,
    .insert_tail = codec.constants.match_insert_tail,
    .insert_step = codec.constants.match_insert_step,
};

test {
    _ = @import("encoder_parse_aarch64_test.zig");
}
