//! The window over a set of literals (decision 86, dfa_window.zig).
//!
//! `([A-Za-z]awyer|[A-Za-z]inn)\s` holds `awyer` or `inn` one byte after each match's start, and
//! no one literal in every match. Its reverse program takes `\s` and then splits into two ways.
//! Each way takes its literal from its first instruction, a cut, and then a part of a match of a
//! bounded length. Every match passes one of the cuts. So no match starts more than `lead` bytes
//! before the first place of any of the literals, and the window goes there, as it goes to the
//! places of one literal. Claim R5's `LiteralSet` finds the places, from the literals' first
//! bytes, as many as the shortest holds.
//!
//! spec/lean/Stdx/Regex/RulesWindowSet.lean decides the same rule from a program, and proves that
//! a search from the window gives the matcher's answer.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const program_file = @import("../program.zig");
const Program = program_file.Program;
const Instruction = program_file.Instruction;
const literal_file = @import("../literal.zig");
const Literal = literal_file.Literal;
const Suffix = literal_file.Suffix;
const LiteralSet = @import("../literal_set.zig").LiteralSet;
const Dfa = @import("dfa.zig").Dfa;
const dfa_inner = @import("dfa_inner.zig");
const dfa_length = @import("dfa_length.zig");
const dfa_window = @import("dfa_window.zig");
const Window = dfa_window.Window;

/// The instructions a split goes to.
const split_targets = 2;

/// The ways from one split of the reverse program: each way's cut and literal, and what the
/// ways hold together.
const Ways = struct {
    cuts: [constants.window_ways_max]u32 = undefined,
    chains: [constants.window_ways_max]Suffix = undefined,
    len: usize = 0,
    /// The bytes of the shortest literal.
    width: usize = constants.literal_len_max,
    /// The most bytes of a match before a literal, over every way.
    lead: u32 = 0,

    /// Adds a cut where the ways lack it. False where the ways are full.
    fn add(ways: *Ways, cut: u32) bool {
        assert(ways.len <= constants.window_ways_max);
        for (ways.cuts[0..ways.len]) |held| {
            if (held == cut) return true;
        }
        if (ways.len == constants.window_ways_max) return false;
        ways.cuts[ways.len] = cut;
        ways.len += 1;
        return true;
    }

    /// True when a search from these ways' places is the better one: the shortest literal is
    /// longer, or as long and the part of a match before a literal is shorter.
    fn beats(ways: *const Ways, other: *const Ways) bool {
        if (ways.width != other.width) return ways.width > other.width;
        return ways.lead < other.lead;
    }
};

/// A window over a set and its literals, which `dfa_window.take` gives the forward DFA.
pub const Found = struct { window: Window, literals: LiteralSet };

/// The window over a set: the literals that the ways from a split of the reverse program take,
/// where every match passes one of the ways' cuts and no part of a match before a literal takes
/// more than `window_lead_max` bytes. Of several splits, the one whose shortest literal is the
/// longest, and of those the one with the shorter part before a literal. `reverse` is the
/// reverse program's DFA. Null where none of the first `window_splits_max` splits holds one.
pub fn window_set_of(reverse: *Dfa, program: *const Program) ?Found {
    assert(reverse.config.entry == program.reverse);
    var best: ?Ways = null;
    var tries: usize = 0;
    var index: usize = program.forward_len;
    // Each turn passes one node and the ranges it holds.
    for (program.forward_len..program.instructions.len) |_| {
        if (index == program.instructions.len or tries == constants.window_splits_max) break;
        const here: u32 = @intCast(index);
        const instruction = program.instructions[here];
        index += 1 + if (instruction.kind == .ranges) instruction.arg else 0;
        if (instruction.kind != .split) continue;
        tries += 1;
        const ways = ways_of(reverse, program, here) orelse continue;
        if (best == null or ways.beats(&best.?)) best = ways;
    }
    return window_of(&(best orelse return null));
}

/// The ways from `split`, where each takes a literal of `literal_prefix_len_min` bytes or more
/// with no place that folds, the part before each takes at most `window_lead_max` bytes, and
/// every match passes one of their cuts. Null otherwise.
fn ways_of(reverse: *Dfa, program: *const Program, split: u32) ?Ways {
    var ways: Ways = .{};
    if (!cuts_of(program.instructions, split, &ways)) return null;
    if (ways.len < constants.literal_set_count_min) return null;
    for (ways.cuts[0..ways.len], ways.chains[0..ways.len]) |cut, *chain| {
        chain.* = Literal.chain_of(program, cut) orelse return null;
        // A set compares its literals' bytes as they stand, so a place that folds has no
        // literal of the set.
        if (chain.literal.len < constants.literal_prefix_len_min or chain.literal.folds != 0) return null;
        const lengths = dfa_length.from(reverse, chain.before, constants.window_lead_max) orelse return null;
        assert(lengths.bound <= constants.window_lead_max);
        ways.lead = @max(ways.lead, @as(u32, @intCast(lengths.bound)));
        ways.width = @min(ways.width, chain.literal.len);
    }
    if (!dfa_inner.every_match_passes_any(reverse, ways.cuts[0..ways.len])) return null;
    return ways;
}

/// Adds to `ways` the instructions that take one byte and that `split` leads to through splits,
/// jumps and saves, which take none. False where the walk meets another instruction, holds more
/// than `literal_ways_free_max` instructions, or finds more than `window_ways_max` cuts.
fn cuts_of(instructions: []const Instruction, split: u32, ways: *Ways) bool {
    var stack: [constants.literal_ways_free_max]u32 = undefined;
    stack[0] = split;
    var stack_len: usize = 1;
    for (0..constants.literal_ways_free_max) |_| {
        if (stack_len == 0) return true;
        stack_len -= 1;
        const instruction = instructions[stack[stack_len]];
        switch (instruction.kind) {
            .split => {
                if (stack_len + split_targets > stack.len) return false;
                // The second target goes on first, so the walk takes the first way first.
                stack[stack_len] = instruction.arg;
                stack[stack_len + 1] = instruction.out;
                stack_len += split_targets;
            },
            .jump, .save => {
                stack[stack_len] = instruction.out;
                stack_len += 1;
            },
            .range => {
                if (instruction.lo != instruction.hi or !ways.add(stack[stack_len])) return false;
            },
            else => return false,
        }
    }
    return stack_len == 0;
}

/// The window of the ways, and their literals as a set, each cut to the shortest's bytes by the
/// set's `len`.
fn window_of(ways: *const Ways) Found {
    assert(ways.len >= constants.literal_set_count_min and ways.len <= constants.window_ways_max);
    var found: Found = .{
        .window = .{ .finder = .{ .set = .{ .cuts = undefined, .befores = undefined } }, .lead = ways.lead, .before = 0 },
        .literals = .{ .octets = undefined, .count = @intCast(ways.len), .len = @intCast(ways.width), .exact = false },
    };
    const set = &found.window.finder.set;
    for (ways.chains[0..ways.len], 0..) |chain, place| {
        @memcpy(found.literals.octets[place][0..chain.literal.len], chain.literal.octets[0..chain.literal.len]);
        found.literals.lens[place] = chain.literal.len;
        set.cuts[place] = ways.cuts[place];
        set.befores[place] = chain.before;
    }
    found.literals.prepare();
    return found;
}
