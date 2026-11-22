//! The entries of unicode_tables.zig, which tools/unicode/unicode_tables.zig writes from
//! tools/unicode/ucd/.

/// The first and the last code point of a range, in a property's ranges, which are in order and
/// apart: each range starts past the code point after the one before it.
pub const Range = extern struct {
    lo: u32,
    hi: u32,
};

/// One name of a property, as `property` compares it, and the property's ranges.
pub const Property = struct {
    name: []const u8,
    ranges: []const Range,
};

/// A span of code points whose next code points in their case orbits follow one step.
pub const FoldRun = struct {
    lo: u32,
    hi: u32,
    step: Step,
};

/// How the code points of a run give their next ones. Under `offset`, each adds the offset. Under
/// `pairs`, the run's code points go in twos from `lo`: the first of two goes to the second, and the
/// second back to the first.
pub const Step = union(enum) {
    offset: i32,
    pairs,
};
