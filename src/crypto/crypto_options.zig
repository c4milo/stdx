//! The options of chapulin's sessions, filled from the program's `Context`: the two fields where
//! chapulin takes its description of the CPU and its random source. The module's root calls it,
//! and does not export this file.
const std = @import("std");
const chapulin = @import("chapulin");

/// `options` with `cpu` and `random` set. A program leaves both unset, so a value it set is a
/// program's error. chapulin's two objects take one type of random source.
pub fn filled(options: anytype, cpu: anytype, random: chapulin.tcp.RandomSource) @TypeOf(options) {
    std.debug.assert(options.cpu == null);
    std.debug.assert(options.random == null);
    var result = options;
    result.cpu = cpu;
    result.random = random;
    return result;
}
