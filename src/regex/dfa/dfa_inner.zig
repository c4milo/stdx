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
/// first byte. `reverse` is the reverse program's DFA. Null where the program holds none, or
/// where `inner_candidates_max` tries found none.
pub fn inner_of(reverse: *Dfa, program: *const Program) ?Suffix {
    assert(reverse.config.entry == program.reverse);
    var best: ?Candidate = null;
    var index: usize = program.forward_len;
    for (0..constants.inner_candidates_max) |_| {
        // A literal's later bytes give shorter literals, which cost no try.
        const len_min = if (best) |held| held.suffix.literal.len else 1;
        const found = next_chain(program, &index, len_min) orelse break;
        const candidate = judge(reverse, found.cut, found.chain) orelse continue;
        if (best == null or candidate.beats(best.?)) best = candidate;
    }
    return if (best) |held| held.suffix else null;
}

/// The next literal of `len_min` bytes or more that the reverse program takes from an
/// instruction at or after `index`, and that instruction. `index` then stands past it. Null
/// where the program holds no more.
fn next_chain(program: *const Program, index: *usize, len_min: usize) ?struct { cut: u32, chain: Suffix } {
    // Each turn passes one node and the ranges it holds.
    for (program.forward_len..program.instructions.len) |_| {
        if (index.* == program.instructions.len) break;
        const here: u32 = @intCast(index.*);
        const instruction = program.instructions[here];
        index.* += 1 + if (instruction.kind == .ranges) instruction.arg else 0;
        if (!takes_one(instruction)) continue;
        const chain = Literal.chain_of(program, here) orelse continue;
        if (chain.literal.len >= len_min) return .{ .cut = here, .chain = chain };
    }
    return null;
}

/// The literal `chain`, whose first instruction is `cut`, as a candidate: null where it does not
/// stand in the middle of every match, or no rule holds for the part before it.
fn judge(reverse: *Dfa, cut: u32, chain: Suffix) ?Candidate {
    if (!in_the_middle(reverse, cut, chain.before)) return null;
    if (dfa_suffix.holds(reverse, &chain, .first)) return .{ .suffix = chain, .apart = true };
    if (dfa_suffix.holds(reverse, &chain, .all)) return .{ .suffix = chain, .apart = false };
    return null;
}

fn takes_one(instruction: Instruction) bool {
    return instruction.kind == .range and instruction.lo == instruction.hi;
}

/// True when the literal whose first instruction is `cut` stands in the middle of every match:
/// every match holds it, a part of the match may follow it, and a part may come before it. A
/// literal that ends every match is claim R4's, and one that starts every match is claim R2's.
fn in_the_middle(dfa: *Dfa, cut: u32, before: u32) bool {
    return every_match_passes(dfa, cut) and takes_a_byte_before(dfa, cut) and takes_a_byte(dfa, before);
}

/// True when every path from the reverse program's entry to `match` passes the instruction
/// `cut`: a walk that does not pass it reaches no `match`.
fn every_match_passes(dfa: *Dfa, cut: u32) bool {
    dfa.visited.clear();
    _ = dfa.visited.insert(cut);
    return !reaches(dfa, push(dfa, 0, dfa.config.entry), .match);
}

/// True when the reverse program takes a byte before it reaches `cut`: the part of a match
/// after the literal.
fn takes_a_byte_before(dfa: *Dfa, cut: u32) bool {
    dfa.visited.clear();
    _ = dfa.visited.insert(cut);
    return reaches(dfa, push(dfa, 0, dfa.config.entry), .range);
}

/// True when the reverse program takes a byte from `before` on: the part of a match before
/// the literal.
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
