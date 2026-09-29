//! The UTF-8 check over a whole buffer (RFC 3629 §4), split from scan_utf8.zig: `valid` at 16
//! lanes, the json module's `is_utf8` on a target with no wider copy (decision 38), and `valid_by`
//! at any width, which the x86-64 variant object runs at 32 and 64 lanes (decision 39). Each judges
//! a block with scan_utf8.zig's `error_octets`, and the octets past the last block with utf8.zig's
//! machine.

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");
const utf8 = @import("utf8.zig");
const scan_utf8 = @import("scan_utf8.zig");
const Form = scan_utf8.Form;
const error_octets = scan_utf8.error_octets;
const cut_character_len = scan_utf8.cut_character_len;

fn Block(comptime width: usize) type {
    return @Vector(width, u8);
}

fn splat(comptime width: usize, octet: u8) Block(width) {
    return @splat(octet);
}

/// The form `valid` takes at 16 lanes on this target.
const form_16: Form = if (scan_utf8.has_lookup) .lookup else .compares;

/// Whether `octets` is UTF-8 whole (RFC 3629 §4): the check a string's octets go through in the
/// walk, run alone over a buffer (decision 38), at 16 lanes. The json module's `is_utf8` where the
/// caller's features name no wider level, and bench-json's candidate beside simdutf's
/// `validate_utf8`.
pub fn valid(octets: []const u8) bool {
    return valid_by(constants.vector_len, form_16, octets);
}

/// `valid` at `width` lanes a block, by `form`: groups of `utf8_group_blocks` blocks, then blocks of
/// `width`, then, past a wider width, blocks of 16, and the last octets through utf8.zig's machine.
/// The x86-64 variant object runs it at 32 and 64 lanes by the lookup (decision 39).
pub fn valid_by(comptime width: usize, comptime form: Form, octets: []const u8) bool {
    const start = if (width == constants.vector_len) 0 else aligned_start(width, octets);
    // The octets before `start` go through one block from the buffer's first octet, unaligned.
    if (start > 0 and @reduce(.Max, error_octets(width, form, @splat(0), loaded_by(width, form, octets[0..width].*))) != 0) return false;
    const index = blocks_valid(width, form, octets, start) orelse return false;
    if (width == constants.vector_len) return tail_valid(octets, index);
    return tail_valid(octets, blocks_valid(constants.vector_len, form_16, octets, index) orelse return false);
}

/// Where a wider copy's loads start: the buffer's first octet on a line of `width` octets, where it
/// holds a block before that octet and one after it; else its first octet. A block that crosses a
/// 64-octet line cost the 64-lane copy two thirds of its speed on an Intel Xeon Platinum 8370C
/// (decision 39). The verdict does not depend on where the loads start.
fn aligned_start(comptime width: usize, octets: []const u8) usize {
    const head_len = (width - @intFromPtr(octets.ptr) % width) % width;
    return if (head_len > 0 and octets.len >= head_len + width) head_len else 0;
}

/// The block before `start`, as far as the check reads it: the octets before `start` on its last
/// lanes, and zeros for the octets before the buffer. The check reads its last three lanes alone
/// (`shifted_in`, `incomplete_octets`).
fn block_before(comptime width: usize, octets: []const u8, start: usize) Block(width) {
    if (start >= width) return octets[start - width ..][0..width].*;
    var lanes: [width]u8 = @splat(0);
    const read_len: usize = @min(start, constants.utf8_len_max - 1);
    for (0..read_len) |back| lanes[width - 1 - back] = octets[start - 1 - back];
    return lanes;
}

/// Judges `octets` from `start`, a group of blocks and then a block at a time, with the octets
/// before `start` as the block before the first. Returns where the blocks end, or null where one
/// breaks RFC 3629 §4.
fn blocks_valid(comptime width: usize, comptime form: Form, octets: []const u8, start: usize) ?usize {
    const group_len = constants.utf8_group_blocks * width;
    var previous = block_before(width, octets, start);
    var index = start;
    // The verdicts are ORed and read once: a group's verdict read as a scalar would cost the ASCII
    // path a second transfer out of the vector unit, and the verdict is the same at the end.
    var errors: Block(width) = @splat(0);
    for (0..(octets.len - start) / group_len) |_| {
        errors |= group_error_octets(width, form, &previous, octets[index..][0..group_len]);
        index += group_len;
    }
    for (0..(octets.len - index) / width) |_| {
        const block = loaded_by(width, form, octets[index..][0..width].*);
        errors |= error_octets(width, form, previous, block);
        previous = block;
        index += width;
    }
    if (@reduce(.Max, errors) != 0) return null;
    return index;
}

/// The octets after the last block: the blocks judged every octet but a character the last one
/// cuts, so the machine takes that character's first octets again with the rest, and must end
/// between characters.
fn tail_valid(octets: []const u8, index: usize) bool {
    const cut_len = cut_character_len(octets[0..index]);
    var machine: utf8.Utf8 = .{};
    for (octets[index - cut_len ..]) |octet| {
        if (!machine.accept(octet)) return false;
    }
    return machine.between_characters();
}

/// The verdict on a group of `utf8_group_blocks` blocks as octets, nonzero on a lane the check
/// flags, with `previous` moved to the group's last block. A group of ASCII costs one test, and
/// breaks nothing but a character the block before it cut, whose first octets `incomplete_octets`
/// flags; any other group runs `error_octets` a block at a time and ORs the verdicts.
fn group_error_octets(comptime width: usize, comptime form: Form, previous: *Block(width), group: *const [constants.utf8_group_blocks * width]u8) Block(width) {
    var blocks: [constants.utf8_group_blocks]Block(width) = undefined;
    var all: Block(width) = @splat(0);
    inline for (&blocks, 0..) |*block, block_index| {
        block.* = loaded_by(width, form, group[block_index * width ..][0..width].*);
        all |= block.*;
    }
    if (!has_non_ascii(width, all)) {
        const errors = incomplete_octets(width, previous.*);
        previous.* = blocks[constants.utf8_group_blocks - 1];
        return errors;
    }
    var errors: Block(width) = @splat(0);
    inline for (blocks) |block| {
        errors |= error_octets(width, form, previous.*, block);
        previous.* = block;
    }
    return errors;
}

/// `block` as one register, as scan_utf8.zig's `loaded` gives it at 16 lanes, and at a wider width
/// too where the check judges by the lookup, which the variant object alone runs there (`Form`): a
/// wider block the module's own code judges by the compares passes as it is.
inline fn loaded_by(comptime width: usize, comptime form: Form, block: Block(width)) Block(width) {
    if (width == constants.vector_len or form != .lookup) return scan_utf8.loaded(width, block);
    return switch (builtin.cpu.arch) {
        .x86_64 => if (width == constants.avx512_vector_len) asm (""
            : [ret] "=v" (-> Block(width)),
            : [block] "0" (block),
        ) else asm (""
            : [ret] "=x" (-> Block(width)),
            : [block] "0" (block),
        ),
        else => block,
    };
}

/// Whether `block` holds an octet from 0x80 up: on x86-64 from the sign bits, which one instruction
/// gathers into a mask; elsewhere from the largest octet, which one instruction gives, and which ran
/// 4% faster than a compare on an M-series host.
inline fn has_non_ascii(comptime width: usize, block: Block(width)) bool {
    if (comptime builtin.cpu.arch == .x86_64) return @reduce(.Or, @as(@Vector(width, i8), @bitCast(block)) < @as(@Vector(width, i8), @splat(0)));
    return @reduce(.Max, block) >= constants.non_ascii_min;
}

/// Nonzero on the lanes of `block` that start a character the block cuts: a first octet on the last
/// lane, one that asks for two continuation octets on the lane before, and one that asks for three
/// on the lane before that (RFC 3629 §3). `cut_character_len` as lanes, for a block whose every
/// other octet is judged.
fn incomplete_octets(comptime width: usize, block: Block(width)) Block(width) {
    return @select(u8, block > comptime incomplete_max(width), splat(width, std.math.maxInt(u8)), splat(width, 0));
}

/// The largest octet each lane of a block holds without starting a character the block cuts: on
/// the last lane, one below the least first octet that reaches one octet past itself, and so on
/// back; and every octet on the lanes before those.
fn incomplete_max(comptime width: usize) Block(width) {
    var lanes: [width]u8 = @splat(std.math.maxInt(u8));
    for (1..constants.utf8_len_max) |back| lanes[width - back] = constants.reaching_lead_min[back] - 1;
    return lanes;
}
