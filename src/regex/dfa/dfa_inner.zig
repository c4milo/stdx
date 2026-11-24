//! Claim R14 (decision 86): a literal that every match holds, read from the reverse program,
//! as `@` in `\w+@\w+`.
//!
//! The reverse program takes the literal's bytes one after another from an instruction that
//! every path from its entry to `match` passes. So the text of every match holds the literal,
//! with a part of the match before it and a part after it. The searcher goes to the literal's
//! places where `dfa_suffix.holds` for the part before it: the first place that starts a match
//! then gives the match a forward search finds first.
//!
//! The walks take the reverse DFA's lists, as claim R4's walks do.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const program_file = @import("../program.zig");
const Program = program_file.Program;
const Instruction = program_file.Instruction;
const literal_file = @import("../literal.zig");
const Literal = literal_file.Literal;
const Suffix = literal_file.Suffix;
const Dfa = @import("dfa.zig").Dfa;
const dfa_suffix = @import("dfa_suffix.zig");

/// A literal that every match holds in its middle, and whether claim R4's first rule holds for
/// the part of a match before it.
const Candidate = struct {
    suffix: Suffix,
    apart: bool,

    /// True when a search from this literal's places is the better one: the literal is the
    /// longer, or as long and the part before it cannot hold its first byte, where the other's
    /// can. A text that the pattern fits then holds fewer of its places.
    fn beats(candidate: Candidate, other: Candidate) bool {
        if (candidate.suffix.literal.len != other.suffix.literal.len) return candidate.suffix.literal.len > other.suffix.literal.len;
        return candidate.apart and !other.apart;
    }
};

/// The literal that every match of `program` holds in its middle, after a part that one of
/// claim R4's rules holds for, and the instruction where the reverse program goes on to that
/// part. Of several, the longest, and of those the one whose part before it cannot hold its
/// first byte. `reverse` is the reverse program's DFA. Null where the program holds none
/// among its `inner_candidates_max` longest literals.
pub fn inner_of(reverse: *Dfa, program: *const Program) ?Suffix {
    assert(reverse.config.entry == program.reverse);
    var runs: [constants.inner_candidates_max]Run = undefined;
    const runs_len = collect(program, &runs);
    longest_first(runs[0..runs_len]);
    var memo: Memo = .{};
    var best: ?Candidate = null;
    for (runs[0..runs_len]) |run| {
        // The literals after a shorter one are as short or shorter, and lose to the one held.
        if (best) |held| {
            if (run.chain.literal.len < held.suffix.literal.len) break;
        }
        const candidate = judge(reverse, &memo, run) orelse continue;
        if (best == null or candidate.beats(best.?)) best = candidate;
    }
    var suffix = (best orelse return null).suffix;
    suffix.literal.prepare();
    return suffix;
}

/// A literal that the reverse program takes from one of its instructions: the instruction,
/// and the literal with the instruction where the program goes on.
const Run = struct { cut: u32, chain: Suffix };

/// Writes to `runs` the `inner_candidates_max` longest literals that the reverse program takes
/// from an instruction of one byte, and gives their count. An instruction inside a literal
/// starts a shorter literal, so a literal of many bytes gives many, and the longest are tried.
fn collect(program: *const Program, runs: *[constants.inner_candidates_max]Run) usize {
    var len: usize = 0;
    var index: usize = program.forward_len;
    // Each turn passes one node and the ranges it holds.
    for (program.forward_len..program.instructions.len) |_| {
        if (index == program.instructions.len) break;
        const here: u32 = @intCast(index);
        const instruction = program.instructions[here];
        index += 1 + if (instruction.kind == .ranges) instruction.arg else 0;
        if (!takes_one(instruction)) continue;
        const chain = Literal.chain_of(program, here) orelse continue;
        len = keep(runs, len, .{ .cut = here, .chain = chain });
    }
    return len;
}

/// Adds `run` to the `len` literals of `runs`, in the place of the shortest where `runs` is
/// full and `run` is longer. The count of literals after it.
fn keep(runs: *[constants.inner_candidates_max]Run, len: usize, run: Run) usize {
    if (len < runs.len) {
        runs[len] = run;
        return len + 1;
    }
    var shortest: usize = 0;
    for (runs[1..], 1..) |held, place| {
        if (held.chain.literal.len < runs[shortest].chain.literal.len) shortest = place;
    }
    if (run.chain.literal.len > runs[shortest].chain.literal.len) runs[shortest] = run;
    return len;
}

/// Orders `runs` from the longest literal to the shortest, and keeps the order of two as long.
fn longest_first(runs: []Run) void {
    for (runs, 0..) |_, sorted| {
        if (sorted == 0) continue;
        const run = runs[sorted];
        var place = sorted;
        // Each turn moves one shorter literal a place on: at most `sorted` of them.
        for (0..sorted) |_| {
            if (runs[place - 1].chain.literal.len >= run.chain.literal.len) break;
            runs[place] = runs[place - 1];
            place -= 1;
        }
        runs[place] = run;
    }
}

/// What claim R4's first rule and its second gave for the last part before a literal that
/// they judged. A literal of many bytes gives many literals with one part before them and one
/// first byte, and both rules read no more of a literal than that.
const Memo = struct {
    before: u32 = program_file.no_entry,
    first: u8 = 0,
    fold: u8 = 0,
    apart: bool = false,
    fixed: bool = false,

    fn of(memo: *Memo, reverse: *Dfa, chain: *const Suffix) *const Memo {
        const first = chain.literal.octets[0];
        const fold = chain.literal.fold_at(0);
        if (memo.before != chain.before or memo.first != first or memo.fold != fold) {
            const apart = dfa_suffix.apart(reverse, chain);
            // The second rule is asked for only where the first does not hold.
            const fixed = !apart and dfa_suffix.short_fixed(reverse, chain.before);
            memo.* = .{ .before = chain.before, .first = first, .fold = fold, .apart = apart, .fixed = fixed };
        }
        return memo;
    }
};

/// The literal of `run` as a candidate: null where not every match holds it, no rule holds
/// for the part before it, or it starts or ends every match. The first test is one walk, and
/// refuses the bytes of a class of scalar values, which a program may hold thousands of.
fn judge(reverse: *Dfa, memo: *Memo, run: Run) ?Candidate {
    if (!every_match_passes(reverse, run.cut)) return null;
    const rules = memo.of(reverse, &run.chain);
    if (!rules.apart and !dfa_suffix.wide(reverse, &run.chain, rules.fixed)) return null;
    if (!takes_a_byte_before(reverse, run.cut) or !takes_a_byte(reverse, run.chain.before)) return null;
    return .{ .suffix = run.chain, .apart = rules.apart };
}

fn takes_one(instruction: Instruction) bool {
    return instruction.kind == .range and instruction.lo == instruction.hi;
}

/// True when every path from the reverse program's entry to `match` passes the instruction
/// `cut`: a walk that does not pass it reaches no `match`.
fn every_match_passes(dfa: *Dfa, cut: u32) bool {
    dfa.visited.clear();
    _ = dfa.visited.insert(cut);
    return !reaches(dfa, push(dfa, 0, dfa.config.entry), .match);
}

/// True when the reverse program takes a byte before it reaches `cut`: the part of a match
/// after the literal. A literal that ends every match is claim R4's.
fn takes_a_byte_before(dfa: *Dfa, cut: u32) bool {
    dfa.visited.clear();
    _ = dfa.visited.insert(cut);
    return reaches(dfa, push(dfa, 0, dfa.config.entry), .range);
}

/// True when the reverse program takes a byte from `before` on: the part of a match before
/// the literal. A literal that starts every match is claim R2's.
fn takes_a_byte(dfa: *Dfa, before: u32) bool {
    dfa.visited.clear();
    return reaches(dfa, push(dfa, 0, before), .range);
}

/// What a walk looks for: `match`, or an instruction that takes a byte.
const Goal = enum { match, range };

/// True when a walk from the stack's seeds reaches `goal`. Each instruction goes on the stack
/// once, and an assertion passes.
fn reaches(dfa: *Dfa, seeds_len: usize, goal: Goal) bool {
    var stack_len = seeds_len;
    for (0..dfa.visited.dense.len) |_| {
        if (stack_len == 0) break;
        stack_len -= 1;
        const index = dfa.stack[stack_len];
        const kind = dfa.instructions[index].kind;
        const found = switch (goal) {
            .match => kind == .match,
            .range => kind == .range or kind == .ranges,
        };
        if (found) return true;
        stack_len = push_targets(dfa, stack_len, index);
    }
    return false;
}

/// Pushes the instructions that the instruction at `index` goes to.
fn push_targets(dfa: *Dfa, stack_len: usize, index: u32) usize {
    const instruction = dfa.instructions[index];
    switch (instruction.kind) {
        .match, .fail => return stack_len,
        .range, .save, .jump, .look => return push(dfa, stack_len, instruction.out),
        .split => return push(dfa, push(dfa, stack_len, instruction.out), instruction.arg),
        .ranges => {
            var len = stack_len;
            for (dfa.instructions[index + 1 ..][0..instruction.arg]) |member| len = push(dfa, len, member.out);
            return len;
        },
    }
}

fn push(dfa: *Dfa, stack_len: usize, index: u32) usize {
    if (!dfa.visited.insert(index)) return stack_len;
    dfa.stack[stack_len] = index;
    return stack_len + 1;
}
