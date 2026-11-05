//! The DEFLATE encoder's Huffman codes (RFC 1951 §3.2.2): the builder shared through codec
//! (decision 62, codec's prefix_code.zig), and the run-length coding of a dynamic block's code
//! lengths with symbols 16, 17 and 18 (§3.2.7), in `encoder_code_runs.zig`.

const std = @import("std");
const codec = @import("codec");
const constants = @import("../constants.zig");
const prefix_code = codec.prefix_code;

pub const symbols_max = prefix_code.symbols_max;
pub const Key = prefix_code.Key;
pub const LengthCounts = prefix_code.LengthCounts;
pub const build_lengths = prefix_code.build_lengths;
pub const build_lengths_listed = prefix_code.build_lengths_listed;
pub const build_lengths_package_merge = prefix_code.build_lengths_package_merge;
pub const build_codes = prefix_code.build_codes;
pub const build_codes_listed = prefix_code.build_codes_listed;

comptime {
    // DEFLATE's limits are within the shared builder's.
    std.debug.assert(constants.code_len_max == codec.constants.prefix_code_len_max);
    std.debug.assert(constants.literal_length_used <= prefix_code.symbols_max);
    std.debug.assert(constants.distance_used <= codec.constants.prefix_code_insertion_sort_len_max);
}

/// The run-length coding of a dynamic block's code lengths (RFC 1951 §3.2.7), in a file of its own.
const runs = @import("encoder_code_runs.zig");
pub const Item = runs.Item;
pub const items_max = runs.items_max;
pub const ItemCounts = runs.Counts;
pub const run_lengths = runs.run_lengths;

test {
    _ = @import("encoder_code_test.zig");
}
