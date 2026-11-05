//! The Zstandard encoder's side of the shared match finder (decision 62, codec's
//! match_finder.zig): the block a parse fills with sequences and literals, and its repeat offset,
//! Repeated_Offset1 (RFC 8878 §3.1.1.5).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_repeat = @import("encoder_repeat.zig");
const encoder_sequences = @import("encoder_sequences.zig");

pub const Level = codec.match_finder.Level;
pub const Matcher = codec.match_finder.Matcher;
pub const match_len = codec.match_finder.match_len;

/// What a block's parse fills: its sequences and the literals between them.
pub const Block = struct {
    sequences: *encoder_sequences.Sequences,
    literals: []u8,
    literals_len: usize,
    repeats: *encoder_repeat.Repeats,

    /// Records a sequence of the literals from `anchor` to `position` and a match of `len` at
    /// `offset`, as RFC 8878 §3.1.1.4 executes it.
    pub fn add(self: *Block, window: []const u8, anchor: usize, position: usize, len: usize, offset: usize) align(constants.encoder_function_alignment) void {
        const literals_len = position - anchor;
        self.add_literals(window[anchor..position]);
        const sequences = self.sequences;
        const index = sequences.count;
        assert(index < constants.block_sequences_max and len >= constants.match_length_baselines[0]);
        sequences.literals_lens[index] = @intCast(literals_len);
        sequences.match_lens[index] = @intCast(len);
        sequences.offset_values[index] = encoder_repeat.offset_value(self.repeats, @intCast(offset), @intCast(literals_len));
        sequences.count = index + 1;
    }

    /// Repeated_Offset1, which the finder tries before its tables.
    pub inline fn repeat_offset(self: *const Block) u32 {
        return self.repeats[0];
    }

    pub fn add_literals(self: *Block, octets: []const u8) void {
        @memcpy(self.literals[self.literals_len..][0..octets.len], octets);
        self.literals_len += octets.len;
    }
};

test {
    _ = @import("encoder_match_test.zig");
}
