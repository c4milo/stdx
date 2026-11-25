//! Claim J14 (decision 27): a block of 16 whose octets to escape each take a letter's escape,
//! written at once inside the strings of claim J11's loop. The walk of encoder_loop_string.zig
//! stops at each octet a string must escape and scans again from the octet after it, so each
//! escape waits on the last one's place and ends a run with a branch the predictor misses:
//! json-1m as a string, an escape every 7 octets, encoded at 0.78 of yyjson's speed on the N2
//! (design §8 step 18).
//!
//! Here a block's address waits on nothing a block holds. Each character a letter escapes
//! becomes its letter where it stands (RFC 8259 §7), and one lookup a half of 8 lanes then
//! writes a reverse solidus before each, by a table of the lanes each set of escapes writes. A
//! block that holds any other octet a string does not carry as it is ends the loop where the
//! block starts: a control character with no letter, and a non-ASCII octet, which the UTF-8 walk
//! judges. The walk takes the string on from it.
//!
//! On x86-64 a string goes two blocks a pass, 32 octets in one register: a pair of plain ASCII is
//! stored as it is, behind one branch, and any other pair goes through the lookup, both blocks
//! at once. A block at a time, bible.txt encoded at 0.79 of simdjson's speed on an AMD EPYC 9V74;
//! the lookup for every pair, with no branch on its octets, ran each text at one speed, below
//! main's on most texts there (design §8 step 18).
//!
//! It needs 16 lanes looked up by 16 indices in one instruction: NEON's TBL, and on x86-64
//! VPSHUFB, which the AVX2 variant object alone has (decision 37). It reads and writes the
//! walk's slices, whose bounds Zig checks (ReleaseSafe) unless the caller turns the checks off
//! at its call site (decision 35), and a block's stores run past what it reports written, inside
//! the room it was given (decision 11).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const scan = @import("../../scan.zig");
const scan_utf8 = @import("../../scan_utf8.zig");
const claims_file = @import("../../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const loop_string = @import("encoder_loop_string.zig");

/// Whether this compilation has the lookup the blocks take.
pub const available = scan_utf8.has_lookup;

pub const width = constants.vector_len;
const Block = Lanes(width);

/// The halves a block's lookup writes it in, and the lanes of one: a table of every set of lanes
/// to escape out of 8 holds 256 entries, where one of 16 lanes would hold 65,536.
const halves = 2;
const half_len = width / halves;
const half_sets = 1 << half_len;

/// The octets of a letter's escape (RFC 8259 §7).
const letter_escape_len = 2;

/// Whether `take` takes a string two blocks a pass before it takes blocks one at a time: on
/// x86-64, where it compiles with AVX2 alone (`available`), so that a pass is one register. A
/// pair of plain ASCII runs 17 instructions where two blocks ran 28, and a pair with a stop
/// about 63 where two blocks with stops ran 110.
const pairs = builtin.cpu.arch == .x86_64;

/// A pass of `pairs`, its blocks, and its halves of 8 lanes.
const pair_len = constants.avx2_vector_len;
const Pair = Lanes(pair_len);
const pair_blocks = pair_len / width;
const pair_halves = pair_blocks * halves;

/// The room a pass's stores reach into: each half's store is a block wide, the last from where
/// the three halves before it end, at most three blocks in.
const pair_room_len = (pair_halves - 1) * half_len * letter_escape_len + width;

comptime {
    assert(pair_blocks * width == pair_len);
}

/// Whether a block with one or two stops takes each where it stands, an octet at a time, and
/// only a block with more takes the lookup: on aarch64. The lookup runs 28 vector instructions a
/// block, and the N2 has two pipes for them: with every block that held a stop through it, a text
/// with an escape a line encoded 10% slower there than through the walk, and on an EPYC 7763
/// 6% to 120% faster (design §8 step 18).
const few_stops = builtin.cpu.arch == .aarch64;

/// The most stops a block takes an octet at a time.
const few_stops_max = 2;

/// The input a block's loads reach into: its own 16 octets, and with `few_stops` the 16 after a
/// stop, loaded again a place later.
pub const input_len = if (few_stops) width + width else width;

/// The room a block's stores reach into: each store is a block wide. The lookup's second starts
/// where the first half's octets end, at most a block in; a stop's starts past its escape, at
/// most a block and the stops before it in.
pub const room_len = if (few_stops) width + few_stops_max + width else half_len * letter_escape_len + width;

/// The bits of a `scan.LaneWord` a lane takes, and the word with each lane's lowest bit alone:
/// a word of those loses its first lane when its lowest set bit is cleared.
const word_bits_per_lane = @bitSizeOf(scan.LaneWord) / width;
const lanes_lowest_bits: scan.LaneWord = bits: {
    var bits: scan.LaneWord = 0;
    for (0..width) |lane| bits |= @as(scan.LaneWord, 1) << (lane * word_bits_per_lane);
    break :bits bits;
};

/// The lane of a half's lookup that holds a reverse solidus: the first past the half's own.
const solidus_lane = half_len;

fn Lanes(comptime lanes: usize) type {
    return @Vector(lanes, u8);
}

fn splat(comptime lanes: usize, octet: u8) Lanes(lanes) {
    return @splat(octet);
}

/// `table`'s 16 entries once for each 16 lanes, as VPSHUFB looks each 16 lanes up in their own
/// 16 entries (scan_utf8.zig's `lookup`).
fn repeated(comptime lanes: usize, comptime table: [width]u8) [lanes]u8 {
    return table ** (lanes / width);
}

/// An octet's slot in the tables of 16 entries: the octet plus its high four bits, the sum's low
/// four bits. No two of the characters a letter escapes share a slot, which
/// encoder_loop_escapes_test.zig requires.
pub fn slot_of(octet: u8) u8 {
    return (octet +% (octet >> constants.nibble_bits)) & constants.nibble_mask;
}

inline fn slots_of(comptime lanes: usize, block: Lanes(lanes)) Lanes(lanes) {
    return (block +% (block >> @splat(constants.nibble_bits))) & splat(lanes, constants.nibble_mask);
}

/// Whether a string escapes `character` by a letter (RFC 8259 §7): a quotation mark, a reverse
/// solidus, and the control characters `constants.escaped_characters` names. A string carries a
/// solidus as it is.
pub fn letter_escapes(character: u8) bool {
    return character == constants.quotation_mark or character == constants.reverse_solidus or
        (character < constants.unescaped_min and std.mem.indexOfScalar(u8, constants.escaped_characters, character) != null);
}

/// The letter of `character`'s escape, for a character `letter_escapes` holds for.
pub fn letter_of(character: u8) u8 {
    assert(letter_escapes(character));
    return constants.escape_letters[std.mem.indexOfScalar(u8, constants.escaped_characters, character).?];
}

/// By slot, the character a letter escapes that has the slot, and for a slot with none an octet
/// of another slot, which no octet of this slot equals.
pub const character_by_slot: [width]u8 = table: {
    var characters: [width]u8 = undefined;
    for (&characters, 0..) |*character, slot| {
        character.* = for (0..std.math.maxInt(u8)) |octet| {
            if (slot_of(octet) != slot) break octet;
        } else unreachable;
    }
    for (constants.escaped_characters) |character| {
        if (letter_escapes(character)) characters[slot_of(character)] = character;
    }
    break :table characters;
};

/// By slot, the character that has the slot XOR its escape's letter (RFC 8259 §7), so the
/// character XOR its slot's entry is its letter; zero for a slot with no character, and for a
/// quotation mark's and a reverse solidus's, whose letters are themselves.
pub const difference_by_slot: [width]u8 = table: {
    var differences: [width]u8 = @splat(0);
    for (constants.escaped_characters) |character| {
        if (letter_escapes(character)) differences[slot_of(character)] = character ^ letter_of(character);
    }
    break :table differences;
};

/// For each set of lanes of a half to escape, one bit a lane: the lane each octet the half
/// writes comes from, in order, with `solidus_lane` before each lane of the set; then zeros.
pub const written_lanes: [half_sets][width]u8 = table: {
    @setEvalBranchQuota(half_sets * width * letter_escape_len);
    var lanes: [half_sets][width]u8 = @splat(@splat(0));
    for (&lanes, 0..) |*entry, escaped| {
        var count: usize = 0;
        for (0..half_len) |lane| {
            if (escaped >> lane & 1 != 0) {
                entry[count] = solidus_lane;
                count += 1;
            }
            entry[count] = lane;
            count += 1;
        }
    }
    break :table lanes;
};

/// For each set of lanes of a half to escape, the octets the half writes.
pub const written_counts: [half_sets]u8 = table: {
    var counts: [half_sets]u8 = undefined;
    for (&counts, 0..) |*count, escaped| count.* = half_len + @popCount(@as(u8, escaped));
    break :table counts;
};

/// For each set of lanes of a half to escape, `written_lanes`'s entry and then `written_counts`'s,
/// in an entry whose length is a power of two, 32 octets: a pass finds both from the set's place
/// in its word of lane bits, by a shift and a mask.
const entry_len = std.math.ceilPowerOfTwoAssert(usize, width + 1);
const entry_count_at = width;
const entry_bits = std.math.log2_int(usize, entry_len);
const written_entries: [half_sets * entry_len]u8 = table: {
    var entries: [half_sets * entry_len]u8 = @splat(0);
    for (0..half_sets) |set| {
        entries[set * entry_len ..][0..width].* = written_lanes[set];
        entries[set * entry_len + entry_count_at] = written_counts[set];
    }
    break :table entries;
};

comptime {
    assert(entry_len == 1 << entry_bits);
}

/// Where `written_entries` holds the entry of the set of lanes `escaped_bits` gives the half
/// `half` of a pass.
inline fn entry_of(escaped_bits: usize, comptime half: usize) usize {
    const place = half * half_len;
    const moved = if (place >= entry_bits) escaped_bits >> (place - entry_bits) else escaped_bits << (entry_bits - place);
    return moved & ((half_sets - 1) << entry_bits);
}

/// All ones in each lane that holds, and zero in the others.
inline fn octets_of(comptime lanes: usize, holds: @Vector(lanes, bool)) Lanes(lanes) {
    return @select(u8, holds, splat(lanes, std.math.maxInt(u8)), splat(lanes, 0));
}

/// One bit a lane, the first lane lowest, in a general register. The empty assembly statement
/// hides the word from LLVM, as decoder_loop_escapes.zig's does.
inline fn lane_bits(comptime lanes: usize, octets: Lanes(lanes)) usize {
    const bits: std.meta.Int(.unsigned, lanes) = @bitCast(octets != splat(lanes, 0));
    return asm (""
        : [ret] "=r" (-> usize),
        : [bits] "0" (@as(usize, bits)),
    );
}

/// What a block with stops holds: its octets with each character a letter escapes as its letter,
/// the lanes of those characters, and the lanes this path cannot take, all ones in each.
fn Parts(comptime lanes: usize) type {
    return struct { text: Lanes(lanes), escaped: Lanes(lanes), bad: Lanes(lanes) };
}

inline fn parts_of(comptime lanes: usize, block: Lanes(lanes)) Parts(lanes) {
    const slots = slots_of(lanes, block);
    const characters = scan_utf8.lookup(lanes, comptime repeated(lanes, character_by_slot), slots);
    const differences = scan_utf8.lookup(lanes, comptime repeated(lanes, difference_by_slot), slots);
    // A string escapes these characters by a letter (RFC 8259 §7).
    const escaped = octets_of(lanes, characters == block);
    // A string must escape U+0000 through U+001F, by `\u` and four digits where no letter does
    // (RFC 8259 §7); an octet from 0x80 up is the UTF-8 walk's to judge (RFC 3629 §4).
    const signed: @Vector(lanes, i8) = @bitCast(block);
    const outside = octets_of(lanes, signed < @as(@Vector(lanes, i8), @splat(constants.unescaped_min)));
    return .{
        .text = block ^ (differences & escaped),
        .escaped = escaped,
        .bad = outside & ~escaped,
    };
}

/// The lanes of a half of `text` and then reverse solidi, for the half's lookup: `low` the first
/// 8 lanes, else the last 8.
inline fn half_then_solidi(text: Block, comptime low: bool) Block {
    const lanes = comptime lanes: {
        var mask: [width]i32 = undefined;
        for (0..half_len) |lane| {
            mask[lane] = if (low) lane else half_len + lane;
            mask[half_len + lane] = ~@as(i32, if (low) lane else half_len + lane);
        }
        break :lanes mask;
    };
    return @shuffle(u8, text, splat(width, constants.reverse_solidus), lanes);
}

/// Writes `text` with a reverse solidus before each lane of `escaped_bits`, one bit a lane, at
/// the start of `room`, and returns how many octets it wrote. Each half's store is a block wide,
/// the second from where the first half's octets end.
inline fn write_escaped(comptime claims: Claims, room: *[half_len * letter_escape_len + width]u8, text: Block, escaped_bits: usize) usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    const low: u8 = @truncate(escaped_bits);
    const high: u8 = @truncate(escaped_bits >> half_len);
    const low_lanes: Block = written_lanes[low];
    const high_lanes: Block = written_lanes[high];
    const low_written: [width]u8 = scan_utf8.lookup(width, half_then_solidi(text, true), low_lanes);
    const high_written: [width]u8 = scan_utf8.lookup(width, half_then_solidi(text, false), high_lanes);
    const low_count: usize = written_counts[low];
    room[0..width].* = low_written;
    room[low_count..][0..width].* = high_written;
    return low_count + written_counts[high];
}

/// Writes a block whose stops are `stops`, one bit a lane and two lanes at most, at the start of
/// `room`: the block as it is, then at each stop its letter's escape and after it the 16 octets
/// that follow the stop, loaded again from `input`. Returns how many octets the block wrote, or
/// zero where a stop is an octet the blocks do not take. It runs no vector instruction of its
/// own, and its stores wait on no lookup.
inline fn write_few(comptime claims: Claims, input: *const [input_len]u8, room: *[room_len]u8, block: Block, stops: scan.LaneWord) usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    room[0..width].* = block;
    var left = stops;
    var escapes: usize = 0;
    inline for (0..few_stops_max) |_| {
        if (left != 0) {
            const lane = scan.word_first(left);
            const letter = loop_string.escape_letters[input[lane]];
            // A control character with no letter, or a non-ASCII octet.
            if (letter <= loop_string.control_mark) return 0;
            const at = lane + escapes;
            room[at..][0..letter_escape_len].* = .{ constants.reverse_solidus, letter };
            room[at + letter_escape_len ..][0..width].* = input[lane + 1 ..][0..width].*;
            escapes += 1;
            left &= left - 1;
        }
    }
    assert(left == 0);
    return width + escapes;
}

/// Writes a block with stops by the lookup, or returns zero where it holds an octet the blocks do
/// not take.
inline fn write_many(comptime claims: Claims, room: *[room_len]u8, block: Block) usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    const parts = parts_of(width, block);
    if (scan.masks_word(parts.bad) != 0) return 0;
    return write_escaped(claims, room[0 .. half_len * letter_escape_len + width], parts.text, lane_bits(width, parts.escaped));
}

/// For a pair's two lookups: each block's first half, or with `first` false its second, in the
/// low 8 lanes of the block's own 16, and reverse solidi in the high 8, as `half_then_solidi`
/// puts one half.
inline fn halves_then_solidi(text: Pair, comptime first: bool) Pair {
    const lanes = comptime lanes: {
        var mask: [pair_len]i32 = undefined;
        for (0..pair_blocks) |block| {
            for (0..half_len) |lane| {
                const from: i32 = @intCast(block * width + lane + if (first) 0 else half_len);
                mask[block * width + lane] = from;
                mask[block * width + half_len + lane] = ~from;
            }
        }
        break :lanes mask;
    };
    return @shuffle(u8, text, splat(pair_len, constants.reverse_solidus), lanes);
}

/// Two blocks' lanes as one pair's, the first block's in the low 16.
inline fn joined(first: Block, second: Block) Pair {
    const lanes = comptime lanes: {
        var mask: [pair_len]i32 = undefined;
        for (0..width) |lane| {
            mask[lane] = lane;
            mask[width + lane] = ~@as(i32, lane);
        }
        break :lanes mask;
    };
    return @shuffle(u8, first, second, lanes);
}

/// Writes a pair's `text` with a reverse solidus before each lane of `escaped_bits`, one bit a
/// lane, at the start of `room`, and returns how many octets it wrote. One lookup writes the two
/// blocks' first halves and another their second halves; each half is stored a block wide from
/// where the halves before it end.
inline fn write_pair(comptime claims: Claims, room: *[pair_room_len]u8, text: Pair, escaped_bits: usize) usize {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    var entries: [pair_halves]usize = undefined;
    inline for (&entries, 0..) |*entry, half| entry.* = entry_of(escaped_bits, half);
    const first_lanes = joined(written_entries[entries[0]..][0..width].*, written_entries[entries[halves]..][0..width].*);
    const second_lanes = joined(written_entries[entries[1]..][0..width].*, written_entries[entries[halves + 1]..][0..width].*);
    const firsts: [pair_blocks][width]u8 = @bitCast(scan_utf8.lookup(pair_len, halves_then_solidi(text, true), first_lanes));
    const seconds: [pair_blocks][width]u8 = @bitCast(scan_utf8.lookup(pair_len, halves_then_solidi(text, false), second_lanes));
    // Where each half starts, after the octets of the halves before it.
    var starts: [pair_halves + 1]usize = undefined;
    starts[0] = 0;
    inline for (entries, 0..) |entry, half| starts[half + 1] = starts[half] + written_entries[entry + entry_count_at];
    const reach = room[0 .. starts[pair_halves - 1] + width];
    inline for (0..pair_blocks) |block| {
        reach[starts[block * halves]..][0..width].* = firsts[block];
        reach[starts[block * halves + 1]..][0..width].* = seconds[block];
    }
    return starts[pair_halves];
}

/// What `take` took of the input and wrote for it. Two words, so it returns in registers.
pub const Took = packed struct { input_len: usize, output_len: usize };

/// Takes a string on from `input`, a block of 16 at a time while the input holds `input_len`
/// octets and the output `room_len`: a block of plain ASCII as it is, and a block of plain ASCII
/// and of characters a letter escapes with each escape written. It ends at the first block that
/// holds another octet, or short of a block. Out of line, so the walk's own loop holds none of
/// its values, and from the start of a 64-octet line: with the function 20 octets further into
/// its line, json-1m as a string encoded 13% slower on the N2 on the same instructions (design
/// §8 step 18).
///
/// With `pairs`, the blocks go two a pass while the input holds a pair and the output a pair's
/// room, and one at a time from the pair that ends that loop.
pub noinline fn take(comptime claims: Claims, input: []const u8, output: []u8) align(constants.kernel_alignment) Took {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    if (comptime !pairs) return take_blocks(claims, input, output);
    const paired = take_pairs(claims, input, output);
    const blocks = take_blocks(claims, input[paired.input_len..], output[paired.output_len..]);
    return .{ .input_len = paired.input_len + blocks.input_len, .output_len = paired.output_len + blocks.output_len };
}

/// The lanes of `pair` that end a run of plain ASCII, as scan.zig's `ascii_stops` finds a
/// block's: one bit a lane.
inline fn pair_stops(pair: Pair) u32 {
    const signed: @Vector(pair_len, i8) = @bitCast(pair);
    const outside = signed < @as(@Vector(pair_len, i8), @splat(constants.unescaped_min));
    const quotation_mark = pair == splat(pair_len, constants.quotation_mark);
    const reverse_solidus = pair == splat(pair_len, constants.reverse_solidus);
    return @bitCast(outside | quotation_mark | reverse_solidus);
}

/// Takes pairs of blocks from the start of `input` while it holds a pair and `output` a pair's
/// room: a pair of plain ASCII as it is, and any other through the lookup. It ends before a
/// pair that holds an octet the blocks do not take.
inline fn take_pairs(comptime claims: Claims, input: []const u8, output: []u8) Took {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    var input_left = input;
    var output_left = output;
    while (input_left.len >= pair_len and output_left.len >= pair_room_len) {
        const pair: Pair = input_left[0..pair_len].*;
        if (pair_stops(pair) == 0) {
            output_left[0..pair_len].* = pair;
            input_left = input_left[pair_len..];
            output_left = output_left[pair_len..];
            continue;
        }
        const parts = parts_of(pair_len, pair);
        if (lane_bits(pair_len, parts.bad) != 0) break;
        const written = write_pair(claims, output_left[0..pair_room_len], parts.text, lane_bits(pair_len, parts.escaped));
        input_left = input_left[pair_len..];
        output_left = output_left[written..];
    }
    return .{ .input_len = input.len - input_left.len, .output_len = output.len - output_left.len };
}

/// `take`'s blocks one at a time.
inline fn take_blocks(comptime claims: Claims, input: []const u8, output: []u8) Took {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    var input_left = input;
    var output_left = output;
    while (input_left.len >= input_len and output_left.len >= room_len) {
        const block = scan_utf8.loaded(width, input_left[0..width].*);
        const stops = scan.ascii_stops(block);
        if (stops == 0) {
            output_left[0..width].* = block;
            input_left = input_left[width..];
            output_left = output_left[width..];
            continue;
        }
        const written = written: {
            if (comptime few_stops) {
                const lanes = stops & lanes_lowest_bits;
                const past_one = lanes & (lanes - 1);
                if (past_one & (past_one -% 1) == 0) break :written write_few(claims, input_left[0..input_len], output_left[0..room_len], block, lanes);
            }
            break :written write_many(claims, output_left[0..room_len], block);
        };
        if (written == 0) break;
        input_left = input_left[width..];
        output_left = output_left[written..];
    }
    return .{ .input_len = input.len - input_left.len, .output_len = output.len - output_left.len };
}
