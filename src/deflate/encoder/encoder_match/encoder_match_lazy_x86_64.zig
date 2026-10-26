//! Level 6's lazy loop in x86-64 assembly (decision 53): the port of
//! `encoder_match_lazy_aarch64.zig`, whose comment describes the loop and its bounds, for the
//! x86-64 baseline. It keeps in the state what its 15 registers cannot hold.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Block = block_module.Block;
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const lazy_aarch64 = @import("encoder_match_lazy_aarch64.zig");
const loop_text = @import("encoder_match_lazy_x86_64_template.zig");

/// Whether the assembly takes the lazy loop: level 6, a block of no cheap literals, and an x86-64
/// target built by LLVM. Zig's own x86-64 backend, a caller's Debug default on Linux, rejects the
/// text's Intel syntax.
pub fn takes(comptime level: constants.Level, comptime cheap: bool) bool {
    var settings = level;
    settings.runtime_safety = true;
    const is_level = std.meta.eql(settings, constants.level(lazy_aarch64.level_number));
    return is_level and !cheap and builtin.cpu.arch == .x86_64 and builtin.zig_backend == .stage2_llvm;
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `template_arguments` names. The fields after `end` are the loop's own, which its registers do
/// not hold.
const State = extern struct {
    window: [*]const u8,
    heads: [*]u16,
    chain: [*]u16,
    symbols: [*]block_module.Symbol,
    literal_length_counts: [*]u16,
    position: u64,
    count: u64,
    previous_len: u64,
    previous_distance: u64,
    waiting: u64,
    end: u64,
    near_codes: [*]const block_module.CodeIndex,
    far_codes: [*]const block_module.CodeIndex,
    length_codes: [*]const block_module.CodeIndex,
    distance_counts: [*]u16,
    lowest: u64 = 0,
    offset: u64 = 0,
    tail: u64 = 0,
    candidate: u64 = 0,
    found_len: u64 = 0,
    /// The end of the whole words of a match's compare at the position.
    compare_end: u64 = 0,
    found_distance: u64 = 0,
    saved_frame: u64 = 0,
};

/// `advance_lazy` for a caller that checked `takes`.
pub fn advance(comptime level: constants.Level, self: *Matcher(level), block: *Block) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(takes(level, false));
    const lookahead = match.lookahead_end(level, self) orelse return;
    // As the aarch64 loop's end, and its count of the octets the symbols cover.
    const end = @min(lookahead, constants.encoder_window_len - constants.lookahead_min + 1);
    const covered_from = self.position - @intFromBool(self.waiting);
    assert(block.symbol_count <= constants.block_symbols_max);
    assert(self.waiting or self.previous.len == 0);
    var state: State = .{
        .window = &self.window,
        .heads = &self.heads,
        .chain = &self.chain,
        .symbols = &block.symbols,
        .literal_length_counts = &block.literal_length_counts,
        .position = self.position,
        .count = block.symbol_count,
        .previous_len = self.previous.len,
        .previous_distance = self.previous.distance,
        .waiting = @intFromBool(self.waiting),
        .end = end,
        .near_codes = &block_module.near_codes,
        .far_codes = &block_module.far_codes,
        .length_codes = &block_module.length_codes,
        .distance_counts = &block.distance_counts,
    };
    execute(&state);
    assert(state.position >= self.position and state.position < @max(end, self.position) + constants.match_len_max);
    assert(state.count >= block.symbol_count and state.count <= constants.block_symbols_max);
    assert(state.waiting <= 1 and (state.waiting == 1 or state.previous_len == 0));
    self.position = @intCast(state.position);
    self.previous = .{ .len = @intCast(state.previous_len), .distance = @intCast(state.previous_distance) };
    self.waiting = state.waiting == 1;
    block.symbol_count = @intCast(state.count);
    block.input_len += self.position - @intFromBool(self.waiting) - covered_from;
}

/// Decides the positions `State` describes, and stores the state back.
noinline fn execute(state: *State) void {
    asm volatile (template
        :
        : [state] "{rdi}" (state),
        : .{
          .memory = true,
          .cc = true,
          .rax = true,
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

/// The level's settings the text writes.
const settings_of = constants.level(lazy_aarch64.level_number);

/// The octets of a match the compare takes 8 at a time: every whole word of `match_len_max`.
const words_len = constants.match_len_max - constants.match_len_max % @sizeOf(u64);

comptime {
    // As the aarch64 text's layouts and limits (`encoder_match_lazy_aarch64.zig`).
    assert(constants.window_len == 1 << 15 and @sizeOf(u16) == 2 and @sizeOf(block_module.Symbol) == 4);
    assert(@bitOffsetOf(block_module.Symbol, "value") == 0 and @bitOffsetOf(block_module.Symbol, "distance") == 8);
    assert(@bitOffsetOf(block_module.Symbol, "distance_code") == 24 and @sizeOf(block_module.CodeIndex) == 1);
    assert(constants.hash_len == @sizeOf(u32) and settings_of.hash_bits < @bitSizeOf(u32));
    assert(settings_of.nice_len <= constants.match_len_max and words_len + 2 == constants.match_len_max);
    assert(words_len / @sizeOf(u64) == 32 and constants.match_len_taken_min - 1 == 3);
    // Decision 52's weight of 4 is the scale of `lea`'s index, and a bit length less one each
    // side, BSR's, gives the same difference as the bit lengths.
    assert(constants.lazy_length_weight == 4);
    assert(block_module.near_distances == 256 and block_module.far_distance_shift == 7);
    assert(constants.first_length_symbol == 257 and constants.match_len_min == 3);
    assert(constants.tail_skips_max == 4);
    assert(settings_of.tail_chains and settings_of.walks_inline and settings_of.lazy_by_bits and settings_of.chains);
    // Every immediate fits 32 bits signed, IMUL's as the multiplier's 32 bits.
    assert(constants.block_symbols_max < 1 << 31 and constants.encoder_distance_max < 1 << 31);
}

/// The loop's text, with the offsets and constants it names filled in: more than a format call
/// takes, so `fill` puts each in its place.
const template = fill(text: {
    var text: []const u8 = loop_text.prologue ++ "\n" ++ loop_text.position ++ "\n" ++ loop_text.skips ++ "\n" ++ loop_text.search ++ "\n" ++ loop_text.link ++ "\n";
    text = text ++ loop_text.compare_word ++ "\n";
    text = text ++ loop_text.compare_end ++ "\n" ++ loop_text.longer ++ "\n";
    for (0..constants.tail_skips_max) |_| text = text ++ loop_text.skip ++ "\n";
    break :text text ++ loop_text.moved ++ "\n" ++ loop_text.decide ++ "\n" ++ loop_text.take ++ "\n" ++ loop_text.exit ++ "\n";
}, template_arguments);

/// The comptime branches `fill` takes: a few for each octet of the text and each name.
const fill_quota = 10_000_000;

/// `text` with each `{[name]}` of `arguments`' fields replaced by the field's value in decimal.
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
    .heads = @offsetOf(State, "heads"),
    .chain = @offsetOf(State, "chain"),
    .symbols = @offsetOf(State, "symbols"),
    .literal_length_counts = @offsetOf(State, "literal_length_counts"),
    .position = @offsetOf(State, "position"),
    .count = @offsetOf(State, "count"),
    .previous_len = @offsetOf(State, "previous_len"),
    .previous_distance = @offsetOf(State, "previous_distance"),
    .waiting = @offsetOf(State, "waiting"),
    .end = @offsetOf(State, "end"),
    .near_codes = @offsetOf(State, "near_codes"),
    .far_codes = @offsetOf(State, "far_codes"),
    .length_codes = @offsetOf(State, "length_codes"),
    .distance_counts = @offsetOf(State, "distance_counts"),
    .lowest = @offsetOf(State, "lowest"),
    .offset = @offsetOf(State, "offset"),
    .tail = @offsetOf(State, "tail"),
    .candidate = @offsetOf(State, "candidate"),
    .found_len = @offsetOf(State, "found_len"),
    .compare_end = @offsetOf(State, "compare_end"),
    .found_distance = @offsetOf(State, "found_distance"),
    .saved_frame = @offsetOf(State, "saved_frame"),
    .multiplier = constants.hash_multiplier,
    .hash_shift = @bitSizeOf(u32) - @as(u32, settings_of.hash_bits),
    .symbols_max = constants.block_symbols_max,
    .distance_max = constants.encoder_distance_max,
    .lazy_len = settings_of.lazy_len,
    .candidates_max = settings_of.candidates_max,
    .cut_candidates_max = settings_of.cut_candidates_max,
    .cut_len = settings_of.cut_len,
    .nice_len = settings_of.nice_len,
    .words_len = words_len,
    .words_len_plus_one = words_len + 1,
    .tail_back = constants.match_len_taken_min - 1,
    .move_candidates_min = settings_of.tail_move_candidates_min,
    .match_len_taken_min = constants.match_len_taken_min,
    .margin = constants.lazy_bits_margin,
    .far_shift = block_module.far_distance_shift,
    .near_distances = block_module.near_distances,
    .match_len_min = constants.match_len_min,
    .distance_at = @bitOffsetOf(block_module.Symbol, "distance"),
    .code_at = @bitOffsetOf(block_module.Symbol, "distance_code"),
    .first_length_symbol = constants.first_length_symbol,
};
