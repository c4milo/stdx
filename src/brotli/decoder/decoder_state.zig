//! The brotli decoder's state apart from its window (decisions 11 and 12): what the stream, the
//! meta-block and the command being decoded have reached, the codes and context maps of the
//! meta-block, and the progress of a prefix code or context map being read. It holds no pointer, so
//! a caller may move or copy it between calls (invariant 12).

const std = @import("std");
const builtin = @import("builtin");
const codec = @import("codec");
const constants = @import("../constants.zig");
const prefix = @import("../prefix.zig");
const context = @import("../context.zig");

/// Every way a stream breaks RFC 7932.
pub const Corrupt = error{
    /// WBITS's invalid pattern (RFC 7932 §9.1).
    InvalidWindowBits,
    /// A bit the RFC requires to be zero is set: the padding after the last meta-block, and the
    /// bits before metadata or an uncompressed meta-block (RFC 7932 §9.2, §9.3).
    NonZeroPadding,
    /// The metadata header's reserved bit is set (RFC 7932 §9.2).
    ReservedBitSet,
    /// MSKIPLEN - 1 in more than one octet, or MLEN - 1 in more than four nibbles, whose last octet
    /// or nibble is zero (RFC 7932 §9.2).
    NonMinimalLength,
    /// A simple prefix code's symbol past its alphabet, or one it gives twice (RFC 7932 §3.4).
    InvalidSymbol,
    DuplicateSymbol,
    /// A complex prefix code's code length code whose lengths sum past 32, or end short of it
    /// without being the one length of a single symbol (RFC 7932 §3.5).
    OverSubscribedCodeLengthCode,
    IncompleteCodeLengthCode,
    /// A complex prefix code's code lengths that sum past 32768, or end the alphabet short of it
    /// (RFC 7932 §3.5).
    OverSubscribedCode,
    IncompleteCode,
    /// A repeat of code lengths past the alphabet, or a run of zeros past the context map (RFC 7932
    /// §3.5, §7.3).
    RepeatPastEnd,
    /// A context map whose values are not every tree index from 0 to NTREES - 1 (RFC 7932 §7.3).
    InvalidContextMap,
    /// A short distance code that gives a distance of zero or less (RFC 7932 §4).
    InvalidDistance,
    /// A command whose literals, copy or dictionary word run past MLEN (RFC 7932 §9.3).
    LengthPastMetaBlock,
    /// A dictionary reference of a length outside 4 to 24, or of a transform past 120 (RFC 7932 §8).
    InvalidDictionaryReference,
};

/// Every valid feature the decoder refuses.
pub const Unsupported = error{
    /// WBITS over the instance's `window_bits_max` (decision 12; RFC 7932 §12 advises the check).
    WindowTooLarge,
    /// RFC 9841's large-window signature (RFC 9841 §6), which version one leaves out (decision 13).
    LargeWindow,
};

pub const Error = Corrupt || Unsupported;

/// Where a stream stands: the step the next call takes.
pub const Phase = enum(u8) {
    stream_header,
    meta_block_header,
    metadata_header,
    metadata_skip,
    meta_block_len,
    uncompressed_flag,
    uncompressed_copy,
    block_types_count,
    first_block_count,
    distance_parameters,
    context_modes,
    trees_count,
    map_run_length,
    map_values,
    map_inverse_transform,
    prefix_kind,
    simple_count,
    simple_symbols,
    code_length_code,
    code_lengths,
    command,
    command_extra,
    block_type,
    block_count,
    literal,
    distance,
    copy,
    dictionary_copy,
    meta_block_end,
    stream_end,
    done,
    refused,
};

/// The three block categories of RFC 7932 §2, in the order the meta-block header gives them.
pub const Category = enum(u2) { literal, insert_copy, distance };
pub const categories_count = 3;

/// The block switching of one category (RFC 7932 §6): NBLTYPES, the current and previous block
/// types, the elements left in the current block, and the two codes of its block-switch commands.
pub const Blocks = struct {
    types_count: u16,
    type_current: u8,
    type_previous: u8,
    count_left: u32,
    type_code: prefix.Table(constants.block_type_table_len_max, constants.table_root_bits),
    count_code: prefix.Table(constants.block_count_table_len_max, constants.table_root_bits),
};

/// The context maps of RFC 7932 §7.3, as NTREES and the map a meta-block header gives.
pub const Map = enum(u1) { literal, distance };
pub const maps_count = 2;

comptime {
    std.debug.assert(@typeInfo(Map).@"enum".fields.len == maps_count);
}

/// What a prefix code being read defines, and so where it goes when built (RFC 7932 §9.2).
pub const Target = union(enum) {
    block_type: Category,
    block_count: Category,
    map: Map,
    literal: u16,
    insert_copy: u16,
    distance: u16,
};

/// A prefix code being read (RFC 7932 §3.4, §3.5): what it is for, the size of its alphabet, and how
/// far the reading has come.
pub const Reading = struct {
    target: Target,
    alphabet_len: u16,
    /// A simple code: NSYM, and the symbols read so far.
    simple_count: u8,
    simple_read: u8,
    simple_symbols: [constants.simple_symbols_max]u16,
    /// A complex code: the next place in `code_length_code_order` or in the alphabet, the space left
    /// of its sum, and the number of non-zero lengths so far.
    index: u16,
    space: i32,
    nonzero_count: u16,
    /// The previous non-zero code length, the last repeat code and the count it reached.
    previous_len: u8,
    repeat_symbol: u8,
    repeat_count: u32,
    /// A complex code: how many of the lengths read so far take each length, 1 to 15, so its build
    /// counts none of them again.
    counts: prefix.Counts,
    /// A complex code: the runs of equal lengths read so far, one list per length in symbol order,
    /// which the build walks in canonical order with no sort.
    ranges: prefix.Ranges,
};

/// A context map being read (RFC 7932 §7.3): which map, RLEMAX, and the entries written so far.
pub const MapReading = struct {
    map: Map,
    run_length_codes: u8,
    index: u32,
};

/// The command being decoded (RFC 7932 §5, §9.3): its insert-and-copy symbol's codes, the literals
/// left to insert, the copy length, and the copy's distance and octets left.
pub const Command = struct {
    insert_code: u8,
    copy_code: u8,
    last_distance: bool,
    insert_left: u32,
    copy_len: u32,
    distance: u32,
    copy_left: u32,
};

/// Invariant 17's count, which test builds alone keep: each symbol decoded, and each entry a table
/// build, a clear, a repeat, a run or the inverse move-to-front writes.
pub const Work = if (builtin.is_test) u64 else void;
pub const work_zero: Work = if (builtin.is_test) 0 else {};

/// Adds `work` to invariant 17's count, in a test build.
pub fn count_work(state: *State, work: usize) void {
    if (builtin.is_test) state.work += work;
}

/// The octets the stream has produced since `init` (RFC 7932 §4's reach with the window): the
/// meta-block's end less what it has left.
pub inline fn produced(state: *const State) u64 {
    return state.produced_end - state.meta_block_left;
}

pub const State = struct {
    bits: codec.Bits,
    phase: Phase,
    /// The farthest a back-reference reaches: (1 << WBITS) - 16 (RFC 7932 §9.1).
    window_distance_max: u32,
    /// The octets the stream will have produced when the meta-block ends: the octets before it and
    /// its MLEN. `produced` is what it has produced, so that a write moves one count, not two.
    produced_end: u64,
    /// ISLAST of the meta-block being read, the octets of its MLEN not yet produced, its MNIBBLES,
    /// and the metadata or uncompressed octets left to skip or copy.
    last_meta_block: bool,
    meta_block_left: u32,
    nibbles: u8,
    skip_bytes: u8,
    raw_left: u32,
    /// The last two octets produced, p1 the more recent (RFC 7932 §7.1).
    p1: u8,
    p2: u8,
    /// The ring of last distances (RFC 7932 §4): the last in `last_distances[0]`.
    last_distances: [constants.last_distances_count]u32,
    blocks: [categories_count]Blocks,
    /// The category whose block types the header reads, or whose block switch the command reads,
    /// and the phase the switch returns to.
    category: Category,
    after_switch: Phase,
    /// NPOSTFIX, NDIRECT, and the distance alphabet they give (RFC 7932 §4).
    postfix_bits: u2,
    direct_count: u8,
    distance_alphabet_len: u16,
    /// The context mode of each literal block type (RFC 7932 §7.1), and how many are read.
    context_modes: [constants.block_types_max]context.Mode,
    modes_read: u16,
    /// NTREESL and NTREESD, and the context maps (RFC 7932 §7.3).
    trees_counts: [maps_count]u16,
    literal_context_map: [constants.literal_contexts_count * constants.block_types_max]u8,
    distance_context_map: [constants.distance_contexts_count * constants.block_types_max]u8,
    /// The prefix codes of the meta-block (RFC 7932 §9.2), each built once into its table (claim
    /// B3).
    literal_codes: [constants.trees_max]prefix.Table(constants.literal_table_len_max, constants.table_root_bits),
    insert_copy_codes: [constants.block_types_max]prefix.Table(constants.insert_copy_table_len_max, constants.table_root_bits),
    distance_codes: [constants.trees_max]prefix.Table(constants.distance_table_len_max, constants.table_root_bits),
    /// A prefix code being read, the code of its code lengths, and its lengths so far.
    reading: Reading,
    code_length_code: prefix.Table(constants.code_length_table_len, constants.code_length_table_root_bits),
    lengths: [constants.code_length_alphabet_len]u8,
    /// A context map being read, and the prefix code of its values.
    map_reading: MapReading,
    map_code: prefix.Table(constants.context_map_table_len_max, constants.table_root_bits),
    command: Command,
    /// A static dictionary word, transformed, and the octets of it already written (RFC 7932 §8).
    word: [constants.transformed_word_len_max]u8,
    word_len: u8,
    word_written: u8,
    work: Work,
};
