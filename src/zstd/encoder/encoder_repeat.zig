//! A sequence's Offset_Value for its offset, and the Repeated_Offsets it leaves (RFC 8878
//! §3.1.1.5): the inverse of the decoder's `sequences.resolve_offset`, so the two keep the same
//! three offsets.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

pub const Repeats = [constants.repeated_offsets_initial.len]u32;

/// The Offset_Values that name a Repeated_Offset (RFC 8878 §3.1.1.5).
const value_first = 1;
const value_second = 2;
const value_third = 3;

/// The Offset_Value that names `offset` after `literals_len` literals, a Repeated_Offset where one
/// is equal, and `repeats` updated as the decoder updates them.
pub fn offset_value(repeats: *Repeats, offset: u32, literals_len: u32) u32 {
    assert(offset > 0);
    const first, const second, const third = repeats.*;
    if (literals_len > 0) {
        // RFC 8878 §3.1.1.5: values 1 to 3 name Repeated_Offset1 to 3.
        if (offset == first) return value_first;
        if (offset == second) {
            repeats.* = .{ second, first, third };
            return value_second;
        }
        if (offset == third) {
            repeats.* = .{ third, first, second };
            return value_third;
        }
    } else {
        // RFC 8878 §3.1.1.5: with no literals, values 1 to 3 name Repeated_Offset2, 3 and
        // Repeated_Offset1 - 1.
        if (offset == second) {
            repeats.* = .{ second, first, third };
            return value_first;
        }
        if (offset == third) {
            repeats.* = .{ third, first, second };
            return value_second;
        }
        if (offset == first -% 1) {
            repeats.* = .{ offset, first, second };
            return value_third;
        }
    }
    repeats.* = .{ offset, first, second };
    return offset + constants.repeat_offset_values;
}

test "an Offset_Value resolves to its offset, and both sides keep the same Repeated_Offsets" {
    const codec = @import("codec");
    const sequences = @import("../sequences.zig");
    var generator = codec.split.Generator.init(5);
    var encoder_repeats: Repeats = constants.repeated_offsets_initial;
    var decoder_repeats: Repeats = constants.repeated_offsets_initial;
    for (0..10_000) |_| {
        // Offsets near the repeated ones, so every value 1 to 3 comes up.
        const offset: u32 = switch (generator.below(4)) {
            0 => encoder_repeats[generator.below(3)],
            1 => encoder_repeats[0] -| 1,
            else => @intCast(generator.between(1, 40)),
        };
        if (offset == 0) continue;
        const literals_len: u32 = @intCast(generator.below(3));
        const value = offset_value(&encoder_repeats, offset, literals_len);
        try std.testing.expectEqual(offset, try sequences.resolve_offset(&decoder_repeats, value, literals_len));
        try std.testing.expectEqualSlices(u32, &decoder_repeats, &encoder_repeats);
    }
}
