//! The fast paths of decision 16's base 64 rows: the encoder's whole groups and the decoder's whole
//! quanta, each read from the input slice and written to the output slice directly. Each counts its
//! steps once from the two slices' lengths, so every index it takes stays inside them, and
//! ReleaseSafe's bounds checks stay on. The checked paths of encoder.zig and decoder.zig are the
//! reference: each fast path gives the same octets and verdicts on every input (decision 16).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const alphabet = @import("alphabet.zig");
const vector = @import("fast_vector.zig");

/// Encodes the whole groups of `input` that `output` has room for, two letters a lookup in `pairs`,
/// and returns how many it encoded.
pub fn encode_groups(letters_of: alphabet.Alphabet, pairs: *const alphabet.PairTable, input: []const u8, output: []u8) usize {
    const count = @min(input.len / constants.group_octets, output.len / constants.quantum_letters);
    const blocks = switch (letters_of) {
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
pub fn decode_quanta(seen: ?alphabet.Alphabet, input: []const u8, output: []u8) usize {
    const count = @min(input.len / constants.quantum_letters, output.len / constants.group_octets);
    const tables = alphabet.quanta(seen);
    const block = if (seen) |known| switch (known) {
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

/// The vector steps of `encode_groups`, one block of `vector.block_octets` octets each, for an
/// alphabet fixed at compile time. Returns the blocks encoded.
fn encode_blocks(comptime letters_of: alphabet.Alphabet, input: []const u8, output: []u8) usize {
    const blocks = @min(input.len / vector.block_octets, output.len / vector.block_letters);
    for (0..blocks) |block| {
        const octets = input[block * vector.block_octets ..][0..vector.block_octets];
        vector.encode_block(letters_of, octets, output[block * vector.block_letters ..][0..vector.block_letters]);
    }
    return blocks;
}

/// The vector steps of `decode_quanta`, for an alphabet fixed at compile time, or none. Returns
/// the blocks decoded, which stop at the first block a letter of it cannot take.
fn decode_blocks(comptime seen: ?alphabet.Alphabet, input: []const u8, output: []u8) usize {
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
