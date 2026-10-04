//! Claim J13 (decision 27): a block of 16 whose stops are escapes of a letter, taken at once inside
//! the strings of claim J10's loop. The walk stopped at each escape and scanned again from the
//! octet after it, so a block's address waited on the last escape's place: a load, a compare, a
//! transfer to a word and a count of its zeros, about 25 cycles an escape on the N2, where yyjson
//! took 12 (design §8 step 18).
//!
//! Here a block's address waits on nothing a block holds. Each escaped letter becomes its
//! character where it stands (RFC 8259 §7), and one shuffle a half of 8 lanes then leaves the
//! reverse solidi out, by a table of the lanes each set of deletions keeps. The first lane this
//! cannot take ends the loop there: an octet a string must escape, a non-ASCII octet, a quotation
//! mark no escape names, and an escape of `u` or of no letter. The walk and
//! decoder_loop_string.zig take the string on from it. An escaped reverse solidus is taken here,
//! one at a time, since its two reverse solidi stand side by side.
//!
//! The blocks take a string only where its letters' escapes come close together, and hand it back
//! where they stop coming (decoder_loop_looks.zig, `constants.escape_quiet_blocks_max`). A
//! shuffled block runs about 30 vector instructions, and the N2 has two pipes for them: there a
//! block costs what the walk's wait at one escape costs, so with every string's blocks shuffled
//! json-1m decoded 2.2 times as fast and prose 13% to 47% slower (design §8 step 18).
//!
//! It needs 16 lanes looked up by 16 indices in one instruction: NEON's TBL, and on x86-64
//! VPSHUFB, which the AVX2 variant object alone has (decision 37). It reads and writes the walk's
//! slices, whose bounds Zig checks (ReleaseSafe), and a block's stores run past what it reports
//! written, inside the room it was given (decision 11).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const scan = @import("../../scan.zig");
const scan_utf8 = @import("../../scan_utf8.zig");
const Walk = @import("../../string_walk.zig").Walk;

/// Whether this compilation has the lookup the blocks take.
pub const available = scan_utf8.has_lookup;

const width = constants.vector_len;
const Block = @Vector(width, u8);

/// The halves a block's shuffle takes it in, and the lanes of one: a table of every set of lanes
/// to leave out of 8 holds 256 entries, where one of 16 lanes would hold 65,536.
const halves = 2;
const half_len = width / halves;
const half_sets = 1 << half_len;

/// The octets of a letter's escape, the reverse solidus's among them, and of the character it
/// names (RFC 8259 §7).
pub const letter_escape_len = 2;
const solidus_len = 1;

/// What is left of a string's input and of its room, where the walk that stops at each escape
/// hands the string to the blocks and where they hand it back.
pub const Left = struct { input: []const u8, output: []u8 };

fn splat(octet: u8) Block {
    return @splat(octet);
}

/// The shifts of an octet's slot in the tables of 16 entries: the octet shifted right by the one
/// plus the octet shifted right by the other, the sum's low four bits. No two escape letters
/// share a slot, which decoder_loop_escapes_test.zig requires.
const slot_near_shift = 1;
const slot_far_shift = 3;

pub fn slot_of(octet: u8) u8 {
    return ((octet >> slot_near_shift) +% (octet >> slot_far_shift)) & constants.nibble_mask;
}

inline fn slots_of(block: Block) Block {
    return ((block >> @splat(slot_near_shift)) +% (block >> @splat(slot_far_shift))) & splat(constants.nibble_mask);
}

/// By slot, the escape letter that has the slot, and for a slot with none an octet of another
/// slot, which no octet of this slot equals. The reverse solidus has none here: `take_solidus`
/// takes its escape.
pub const letter_by_slot: [width]u8 = table: {
    var letters: [width]u8 = undefined;
    for (&letters, 0..) |*letter, slot| {
        letter.* = for (0..std.math.maxInt(u8)) |octet| {
            if (slot_of(octet) != slot) break octet;
        } else unreachable;
    }
    for (constants.escape_letters) |letter| {
        if (letter != constants.reverse_solidus) letters[slot_of(letter)] = letter;
    }
    break :table letters;
};

/// By slot, the letter that has the slot XOR the character it names (RFC 8259 §7), so a letter
/// XOR its slot's entry is its character; zero for a slot with no letter.
pub const difference_by_slot: [width]u8 = table: {
    var differences: [width]u8 = @splat(0);
    for (constants.escape_letters, constants.escaped_characters) |letter, character| differences[slot_of(letter)] = letter ^ character;
    break :table differences;
};

/// For each set of lanes to leave out of a half, one bit a lane: the lanes kept, in order, then
/// zeros; and their count.
pub const kept_lanes: [half_sets][half_len]u8 = table: {
    @setEvalBranchQuota(half_sets * width);
    var lanes: [half_sets][half_len]u8 = @splat(@splat(0));
    for (&lanes, 0..) |*entry, left_out| {
        var count: usize = 0;
        for (0..half_len) |lane| {
            if (left_out >> lane & 1 != 0) continue;
            entry[count] = lane;
            count += 1;
        }
    }
    break :table lanes;
};

pub const kept_counts: [half_sets]u8 = table: {
    var counts: [half_sets]u8 = undefined;
    for (&counts, 0..) |*count, left_out| count.* = half_len - @popCount(@as(u8, left_out));
    break :table counts;
};

/// All ones in each lane that holds, and zero in the others.
inline fn octets_of(lanes: @Vector(width, bool)) Block {
    return @select(u8, lanes, splat(std.math.maxInt(u8)), splat(0));
}

/// `block`'s lanes moved up by one, with the last lane of `before` first.
inline fn shifted(before: Block, block: Block) Block {
    const lanes = comptime lanes: {
        var mask: [width]i32 = undefined;
        mask[0] = width - 1;
        for (mask[1..], 0..) |*lane, from| lane.* = ~@as(i32, from);
        break :lanes mask;
    };
    return @shuffle(u8, before, block, lanes);
}

/// One bit a lane, the first lane lowest, in a general register. The empty assembly statement
/// hides the word from LLVM, which read the word's upper half back from the vector through the
/// stack where it could trace the word to it: seven instructions a block (design §8 step 18).
inline fn lane_bits(lanes: Block) usize {
    const bits: std.meta.Int(.unsigned, width) = @bitCast(lanes != splat(0));
    return asm (""
        : [ret] "=r" (-> usize),
        : [bits] "0" (@as(usize, bits)),
    );
}

/// What a block with stops holds: its octets with each escaped letter as its character, and the
/// lanes this path cannot take, all ones in each.
const Parts = struct { text: Block, bad: Block };

/// The parts of `block`, whose reverse solidi are `solidi`, after a block whose reverse solidi
/// were `before`. A lane counts as escaped when a reverse solidus stands before it, so an escaped
/// reverse solidus is no letter here, and the lane after it never counts wrongly: the loop ends
/// at the reverse solidus first.
inline fn parts_of(before: Block, block: Block, solidi: Block) Parts {
    const escaped = shifted(before, solidi);
    const slots = slots_of(block);
    const differences = scan_utf8.lookup(width, difference_by_slot, slots);
    const letters = scan_utf8.lookup(width, letter_by_slot, slots);
    // An escape names a character by one of these letters alone, or by `u` (RFC 8259 §7).
    const named = octets_of(letters == block);
    // A string ends at a quotation mark no reverse solidus escapes (RFC 8259 §7).
    const ends = octets_of(block == splat(constants.quotation_mark)) & ~escaped;
    // A string must escape U+0000 through U+001F (RFC 8259 §7); an octet from 0x80 up is the
    // UTF-8 walk's to judge (RFC 3629 §4).
    const outside = octets_of((block -% splat(constants.unescaped_min)) >= splat(constants.non_ascii_min - constants.unescaped_min));
    return .{
        .text = block ^ (differences & escaped),
        .bad = outside | ends | (escaped & ~named),
    };
}

/// Writes `text` without the lanes of `left_out`, one bit a lane, at the start of `room`, and
/// returns how many it wrote. Each half's store is 8 octets, the second from where the first's
/// kept lanes end.
inline fn write_kept(room: *[width]u8, text: Block, left_out: usize) usize {
    const low: u8 = @truncate(left_out);
    const high: u8 = @truncate(left_out >> half_len);
    const unused: [half_len]u8 = @splat(0);
    const low_lanes: Block = kept_lanes[low] ++ unused;
    const high_lanes: Block = kept_lanes[high] ++ unused;
    const low_text: [width]u8 = scan_utf8.lookup(width, text, low_lanes);
    const high_text: [width]u8 = scan_utf8.lookup(width, text, high_lanes | splat(half_len));
    const low_count: usize = kept_counts[low];
    room[0..half_len].* = low_text[0..half_len].*;
    room[low_count..][0..half_len].* = high_text[0..half_len].*;
    return low_count + kept_counts[high];
}

/// Takes the string on from `left`, a block of 16 at a time while the input and the output hold
/// one: a block of plain ASCII as it is, and a block of plain ASCII and letters' escapes by the
/// shuffle. It moves `left` to the first octet it does not take, or short of a block, or past
/// `constants.escape_quiet_blocks_max` blocks in a row with no reverse solidus, where the walk that
/// stops at each escape costs less. `start` is the input the string's rest started with. Out of
/// line, so the walk's own loop holds none of its values.
pub noinline fn take(left: *Left, start: []const u8) void {
    var walk: Walk = .{ .input = left.input, .output = left.output };
    take_blocks(&walk, start, constants.escape_quiet_blocks_max);
    left.* = .{ .input = walk.input, .output = walk.output };
}

/// `take` on the caller's copy of the walk, up to `quiet_max` blocks in a row with no reverse
/// solidus.
pub inline fn take_blocks(walk: *Walk, start: []const u8, quiet_max: usize) void {
    // The reverse solidi of the block before, and whether its last lane held one: the escape that
    // starts there names the next block's first octet.
    var before: Block = @splat(0);
    var carry: usize = 0;
    var quiet: usize = 0;
    // A carry clears `quiet`, so the loop never ends for the quiet blocks with one left.
    while (quiet < quiet_max and walk.input.len >= width and walk.output.len >= width) {
        const block = scan_utf8.loaded(width, walk.input[0..width].*);
        const stops = scan.ascii_stops(block);
        if (stops == 0 and carry == 0) {
            walk.output[0..width].* = block;
            walk.input = walk.input[width..];
            walk.output = walk.output[width..];
            before = @splat(0);
            quiet += 1;
            continue;
        }
        const solidi = octets_of(block == splat(constants.reverse_solidus));
        const solidus_bits = lane_bits(solidi);
        // With no escape in the block and none that reaches into it, its first stop ends the run.
        if (solidus_bits | carry == 0) {
            const lane = scan.word_first(stops);
            walk.output[0..width].* = block;
            walk.input = walk.input[lane..];
            walk.output = walk.output[lane..];
            return;
        }
        quiet = 0;
        const parts = parts_of(before, block, solidi);
        const bad = scan.masks_word(parts.bad);
        if (bad != 0) {
            if (!leave(walk, start, parts.text, solidus_bits << 1 | carry, scan.word_first(bad))) return;
            before = @splat(0);
            carry = 0;
            continue;
        }
        const written = write_kept(walk.output[0..width], parts.text, solidus_bits);
        walk.input = walk.input[width..];
        walk.output = walk.output[written..];
        before = solidi;
        carry = solidus_bits >> (width - 1);
    }
    if (carry != 0) back_up(walk, start);
}

/// Moves the walk back to the reverse solidus that ended the block before, whose escape the
/// octet at the input's start ends.
inline fn back_up(walk: *Walk, start: []const u8) void {
    walk.input = start[start.len - walk.input.len - 1 ..];
}

/// Takes the block that starts the input up to `lane`, its first lane the shuffle cannot take, or
/// up to the reverse solidus before it where `lane` is an escape's letter: `escaped_bits` holds
/// one bit a lane that a reverse solidus stands before. Returns true once it took an escaped
/// reverse solidus there, for the loop to go on; false where the octet that now starts the input
/// stops the walk.
fn leave(walk: *Walk, start: []const u8, text: Block, escaped_bits: usize, lane: usize) bool {
    assert(lane < width);
    const is_letter = escaped_bits >> @intCast(lane) & 1 != 0;
    if (is_letter and lane == 0) {
        back_up(walk, start);
        return take_solidus(walk);
    }
    const end = lane - @intFromBool(is_letter);
    const from_end = @as(usize, std.math.maxInt(usize)) << @intCast(end);
    // Each reverse solidus before `end` starts an escape that a lane before `lane` ends.
    const written = write_kept(walk.output[0..width], text, escaped_bits >> 1 | from_end);
    walk.input = walk.input[end..];
    walk.output = walk.output[written..];
    return take_solidus(walk);
}

/// Takes the escape of a reverse solidus that starts the input (RFC 8259 §7), and says whether
/// one did. A reverse solidus `leave` stops at has its letter after it, since the letter is why
/// it stopped there; and the room holds the character, since `leave` wrote fewer octets than the
/// block the room held.
inline fn take_solidus(walk: *Walk) bool {
    if (walk.input[0] != constants.reverse_solidus or walk.input[1] != constants.reverse_solidus) return false;
    walk.output[0] = constants.reverse_solidus;
    walk.input = walk.input[letter_escape_len..];
    walk.output = walk.output[solidus_len..];
    return true;
}
