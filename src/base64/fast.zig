//! The fast paths of decision 16's base 64 rows: the encoder's whole groups and the decoder's whole
//! quanta, each read from the input slice and written to the output slice directly. Each counts its
//! steps once from the two slices' lengths, so every index it takes stays inside them, and
//! ReleaseSafe's bounds checks stay on. The checked paths of encoder.zig and decoder.zig are the
//! reference: each fast path gives the same octets and verdicts on every input (decision 16).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const alphabet = @import("alphabet.zig");
const builtin = @import("builtin");
const vector = @import("fast_vector.zig");

/// Whether this target has the AVX2 variant object's kernels (variants.zig): x86-64 alone builds it.
pub const has_kernels = builtin.cpu.arch == .x86_64;

extern fn stdx_base64_decode_blocks_x86_64_avx2(mode: u8, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize;
extern fn stdx_base64_encode_blocks_x86_64_avx2(letters: u8, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize;

/// A decoding step's alphabet, passed to the variant object as one octet.
pub const Mode = enum(u8) {
    shared,
    standard,
    url_safe,

    pub fn of(seen: ?alphabet.Alphabet) Mode {
        const known = seen orelse return .shared;
        return switch (known) {
            .standard => .standard,
            .url_safe => .url_safe,
        };
    }

    pub fn from_code(code: u8) Mode {
        return @enumFromInt(code);
    }

    pub fn letters(self: Mode) ?alphabet.Alphabet {
        return switch (self) {
            .shared => null,
            .standard => .standard,
            .url_safe => .url_safe,
        };
    }
};

/// Encodes the whole groups of `input` that `output` has room for, two letters a lookup in `pairs`,
/// and returns how many it encoded.
pub fn encode_groups(letters_of: alphabet.Alphabet, wide: bool, pairs: *const alphabet.PairTable, input: []const u8, output: []u8) usize {
    const count = @min(input.len / constants.group_octets, output.len / constants.quantum_letters);
    const blocks = if (has_kernels and wide)
        stdx_base64_encode_blocks_x86_64_avx2(@intFromEnum(letters_of), input.ptr, input.len, output.ptr, output.len)
    else switch (letters_of) {
        inline else => |known| encode_blocks(known, input, output),
    };
    const groups_per_block = vector.block_octets / constants.group_octets;
    for (blocks * groups_per_block..count) |index| {
        const group = input[index * constants.group_octets ..][0..constants.group_octets];
        const bits = std.mem.readInt(u24, group, .big);
        const letters = output[index * constants.quantum_letters ..][0..constants.quantum_letters];
        letters[0..alphabet.letters_per_pair].* = pairs[bits >> alphabet.pair_bits];
        letters[alphabet.letters_per_pair..].* = pairs[@as(u12, @truncate(bits))];
    }
    return count;
}

/// Decodes the whole quanta of `input` that `output` has room for, each the OR of one entry of each
/// of `tables`' four places, and returns how many it decoded. It stops at the first quantum whose
/// entries hold `quantum_refused`: a pad character, an octet in neither alphabet, or a letter of
/// values 62 and 63 that `tables` does not take, which the checked path then reads.
pub fn decode_quanta(seen: ?alphabet.Alphabet, wide: bool, input: []const u8, output: []u8) usize {
    const count = @min(input.len / constants.quantum_letters, output.len / constants.group_octets);
    const tables = alphabet.quanta(seen);
    const block = if (has_kernels and wide)
        stdx_base64_decode_blocks_x86_64_avx2(@intFromEnum(Mode.of(seen)), input.ptr, input.len, output.ptr, output.len)
    else if (seen) |known| switch (known) {
        inline else => |comptime_known| decode_blocks(comptime_known, input, output),
    } else decode_blocks(null, input, output);
    var done: usize = block * (vector.block_letters / constants.quantum_letters);
    while (done < count) : (done += 1) {
        const quantum = input[done * constants.quantum_letters ..][0..constants.quantum_letters];
        var value: u32 = 0;
        inline for (0..constants.quantum_letters) |place| value |= tables[place][quantum[place]];
        if (value >= alphabet.quantum_refused) break;
        std.mem.writeInt(u24, output[done * constants.group_octets ..][0..constants.group_octets], @intCast(value), .big);
    }
    assert(done <= count);
    return done;
}

/// `decode_quanta`, which also takes the alphabet of the first letter of value 62 or 63 as the
/// text's when `seen` is null and `either` says either alphabet may come, and goes on with it.
pub fn decode_quanta_learning(seen: *?alphabet.Alphabet, either: bool, wide: bool, input: []const u8, output: []u8) usize {
    const count = decode_quanta(seen.*, wide, input, output);
    if (seen.* != null or !either) return count;
    const done_letters = count * constants.quantum_letters;
    seen.* = first_alphabet(input[done_letters..]) orelse return count;
    return count + decode_quanta(seen.*, wide, input[done_letters..], output[count * constants.group_octets ..]);
}

/// The alphabet of the first letter of `input` that one alphabet alone holds, or null when no
/// such letter comes before the first octet that is no letter, or the input's end.
pub fn first_alphabet(input: []const u8) ?alphabet.Alphabet {
    for (input) |octet| {
        const entry = alphabet.table[octet];
        if (entry == alphabet.not_a_letter) return null;
        if (entry & alphabet.standard_only != 0) return .standard;
        if (entry & alphabet.url_safe_only != 0) return .url_safe;
    }
    return null;
}

/// The vector steps of `encode_groups`, one block of `vector.block_octets` octets each, for an
/// alphabet fixed at compile time. Returns the blocks encoded.
pub fn encode_blocks(comptime letters_of: alphabet.Alphabet, input: []const u8, output: []u8) usize {
    const blocks = @min(input.len / vector.block_octets, output.len / vector.block_letters);
    for (0..blocks) |block| {
        const octets = input[block * vector.block_octets ..][0..vector.block_octets];
        vector.encode_block(letters_of, octets, output[block * vector.block_letters ..][0..vector.block_letters]);
    }
    return blocks;
}

/// The vector steps of `decode_quanta`, for an alphabet fixed at compile time, or none. Returns
/// the blocks decoded, which stop at the first block a letter of it cannot take.
pub fn decode_blocks(comptime seen: ?alphabet.Alphabet, input: []const u8, output: []u8) usize {
    // Each step stores a whole block of letters' width, past the octets it writes.
    const room_past = vector.block_letters - vector.block_octets;
    const blocks = @min(input.len / vector.block_letters, (output.len -| room_past) / vector.block_octets);
    var block: usize = 0;
    while (block < blocks) : (block += 1) {
        const letters = input[block * vector.block_letters ..][0..vector.block_letters];
        if (!vector.decode_block(seen, letters, output[block * vector.block_octets ..][0..vector.block_letters])) break;
    }
    return block;
}
