//! Claim R4 (decision 86): the literal every match ends with, where a search may start from it,
//! as in `[0-9][0-9,]* km`.
//!
//! The searcher goes to the literal's next place, and the reverse DFA reads back from the
//! place's end to the least start of a match that ends there. That is the forward search's
//! answer where one of three rules holds for the part of a match before its literal:
//!
//! - It takes no byte that is the literal's first (`apart`).
//! - It takes one count of bytes, at most `suffix_before_len_max` (`short_fixed`).
//! - It ends with one byte or more of a set, the separator, and holds no byte of the set
//!   before them, and the literal holds none (`separated`), as in `\w+\s+Holmes`.
//!
//! Under each rule:
//!
//! - No match starts before the start that the first such place gives. A match that ends at an
//!   earlier place would have been found from that place. A match that ends at a later place
//!   and starts earlier would hold the first place's literal in its part before its own. The
//!   first rule and the third leave no room for that, and under the second rule a later place
//!   has a later start.
//! - Every match from that start ends at the place's end, so the search needs no forward scan.
//! - A search reads each byte a bounded number of times, so it stays linear in the text. Under
//!   the first rule a reverse scan stops at the place before its own. Under the second it reads
//!   the literal and `suffix_before_len_max` bytes at most. Under the third it stops at the
//!   separator before its own.
//!
//! Rust's regex crate takes the same search under like rules, and then runs its forward DFA
//! from the start (regex-automata, `meta/prefix.rs`, read at its main branch on 2026-11-24).
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
const dfa_length = @import("dfa_length.zig");

/// A set of byte values.
const ByteSet = std.StaticBitSet(constants.octet_values);

/// The rules a caller lets `suffix_of` take a literal by.
pub const Rules = enum {
    /// The first rule alone, for a program whose forward DFA goes to a set of literals (claim
    /// R5). A search from one literal's places loses to the set's where the places stand close
    /// together, and the first rule keeps them apart from the rest of a match.
    first,
    all,
};

/// The literal every match of `program` ends with, where one of `rules` holds for the part of
/// a match before it. `reverse` is the reverse program's DFA, whose lists the walks take. Null
/// where the program has no such literal.
pub fn suffix_of(reverse: *Dfa, program: *const Program, rules: Rules) ?Literal {
    assert(reverse.config.entry == program.reverse);
    const suffix = Literal.suffix_of(program) orelse return null;
    return if (holds(reverse, &suffix, rules)) suffix.literal else null;
}

/// True where one of `rules` holds for the part of a match before `suffix`'s literal: the part
/// that the reverse program takes from `suffix.before`. Claim R14 asks it for a literal in a
/// match's middle (dfa_inner.zig).
pub fn holds(reverse: *Dfa, suffix: *const Suffix, rules: Rules) bool {
    if (apart(reverse, suffix)) return true;
    if (rules == .first) return false;
    return short_fixed(reverse, suffix.before) or separated(reverse, suffix);
}

/// The first rule: no instruction of the reverse program after the literal takes its first
/// byte. A first place that folds takes its byte in either case.
fn apart(dfa: *Dfa, suffix: *const Suffix) bool {
    const first = suffix.literal.octets[0];
    if (before_takes(dfa, suffix.before, first)) return false;
    return suffix.literal.fold_at(0) == 0 or !before_takes(dfa, suffix.before, first ^ constants.case_bit);
}

/// The second rule: the reverse program after the literal takes one count of bytes, at most
/// `suffix_before_len_max`.
fn short_fixed(dfa: *Dfa, before: u32) bool {
    const lengths = dfa_length.from(dfa, before) orelse return false;
    return lengths.least == lengths.most and lengths.most <= constants.suffix_before_len_max;
}

/// The third rule, for the literal whole, or for the literal past its first run. A separator of
/// one byte stands in the literal: `[ab]+ +x` ends with the literal ` x`, and its separator is
/// the literal's first run.
fn separated(dfa: *Dfa, suffix: *const Suffix) bool {
    if (separated_from(dfa, suffix.before, &suffix.literal, 0)) return true;
    return suffix.run != 0 and separated_from(dfa, suffix.run_entry, &suffix.literal, suffix.run);
}

/// The third rule for the part of the reverse program from `entry`, and the literal's bytes
/// from `skipped`. The separator is the set of the bytes that the reverse program takes first
/// from `entry`. The literal's bytes hold none of them, in either case of a place that folds.
/// Past the first byte not of the set, the reverse program takes no byte of the set.
fn separated_from(dfa: *Dfa, entry: u32, literal: *const Literal, skipped: usize) bool {
    const separator = first_bytes(dfa, entry) orelse return false;
    for (literal.slice()[skipped..], skipped..) |octet, place| {
        if (separator.isSet(octet)) return false;
        if (literal.fold_at(place) != 0 and separator.isSet(octet ^ constants.case_bit)) return false;
    }
    // The first walk reads every instruction from `entry`. It refuses a range that holds bytes
    // on both sides of the set, and keeps in `dfa.next` the targets of the ranges with no byte
    // of the set. The second walk reads what those targets reach.
    dfa.next.clear();
    dfa.visited.clear();
    if (!walk(dfa, push(dfa, 0, entry), &separator, .all)) return false;
    dfa.visited.clear();
    var stack_len: usize = 0;
    for (dfa.next.slice()) |seed| stack_len = push(dfa, stack_len, seed);
    return walk(dfa, stack_len, &separator, .past_separator);
}

/// The bytes that the reverse program takes first from `entry`. Null where it reaches `match`
/// with no byte, so that a match may hold nothing there.
fn first_bytes(dfa: *Dfa, entry: u32) ?ByteSet {
    var set = ByteSet.initEmpty();
    dfa.visited.clear();
    var stack_len = push(dfa, 0, entry);
    for (0..dfa.visited.dense.len) |_| {
        if (stack_len == 0) break;
        stack_len -= 1;
        const index = dfa.stack[stack_len];
        const instruction = dfa.instructions[index];
        switch (instruction.kind) {
            .range => set.setRangeValue(.{ .start = instruction.lo, .end = @as(usize, instruction.hi) + 1 }, true),
            .ranges => for (dfa.instructions[index + 1 ..][0..instruction.arg]) |member| {
                set.setRangeValue(.{ .start = member.lo, .end = @as(usize, member.hi) + 1 }, true);
            },
            .match => return null,
            .fail => {},
            .save, .jump, .look => stack_len = push(dfa, stack_len, instruction.out),
            .split => {
                stack_len = push(dfa, stack_len, instruction.out);
                stack_len = push(dfa, stack_len, instruction.arg);
            },
        }
    }
    assert(stack_len == 0);
    return set;
}

/// What a walk of the third rule reads: every instruction after the literal, or the
/// instructions past a byte that is not of the separator.
const Part = enum { all, past_separator };

/// Walks the instructions the stack's `stack_len` seeds reach, each once. False where a range
/// holds bytes of the separator and bytes not of it, or where a range past the separator holds
/// a byte of it.
fn walk(dfa: *Dfa, seeds_len: usize, separator: *const ByteSet, part: Part) bool {
    var stack_len = seeds_len;
    for (0..dfa.visited.dense.len) |_| {
        if (stack_len == 0) break;
        stack_len -= 1;
        const index = dfa.stack[stack_len];
        const instruction = dfa.instructions[index];
        switch (instruction.kind) {
            .range => stack_len = judge(dfa, stack_len, instruction, separator, part) orelse return false,
            .ranges => for (dfa.instructions[index + 1 ..][0..instruction.arg]) |member| {
                stack_len = judge(dfa, stack_len, member, separator, part) orelse return false;
            },
            .match, .fail => {},
            .save, .jump, .look => stack_len = push(dfa, stack_len, instruction.out),
            .split => {
                stack_len = push(dfa, stack_len, instruction.out);
                stack_len = push(dfa, stack_len, instruction.arg);
            },
        }
    }
    assert(stack_len == 0);
    return true;
}

/// Judges one range of a walk, and pushes its target. Null where the range breaks the rule.
fn judge(dfa: *Dfa, stack_len: usize, range: Instruction, separator: *const ByteSet, part: Part) ?usize {
    assert(range.kind == .range);
    var inside: usize = 0;
    for (range.lo..@as(usize, range.hi) + 1) |octet| inside += @intFromBool(separator.isSet(octet));
    const len = @as(usize, range.hi) - range.lo + 1;
    if (inside != 0 and inside != len) return null;
    if (inside == 0 and part == .all) _ = dfa.next.insert(range.out);
    if (inside != 0 and part == .past_separator) return null;
    return push(dfa, stack_len, range.out);
}

/// True when an instruction that the reverse program reaches from `before` takes `octet`. Each
/// instruction goes on the stack once, the first time the walk meets it.
fn before_takes(dfa: *Dfa, before: u32, octet: u8) bool {
    dfa.visited.clear();
    _ = dfa.visited.insert(before);
    dfa.stack[0] = before;
    var stack_len: usize = 1;
    for (0..dfa.instructions.len) |_| {
        if (stack_len == 0) return false;
        stack_len -= 1;
        const index = dfa.stack[stack_len];
        const instruction = dfa.instructions[index];
        switch (instruction.kind) {
            .range => if (instruction.takes(octet)) return true,
            .ranges => {
                if (program_file.step(dfa.instructions, index, octet) != null) return true;
                // A node's ranges are reached through it alone, so the walk goes on to their
                // targets from here.
                for (dfa.instructions[index + 1 ..][0..instruction.arg]) |member| stack_len = push(dfa, stack_len, member.out);
                continue;
            },
            .match, .fail => continue,
            .save, .jump, .look => {},
            .split => stack_len = push(dfa, stack_len, instruction.arg),
        }
        stack_len = push(dfa, stack_len, instruction.out);
    }
    assert(stack_len == 0);
    return false;
}

fn push(dfa: *Dfa, stack_len: usize, index: u32) usize {
    if (!dfa.visited.insert(index)) return stack_len;
    dfa.stack[stack_len] = index;
    return stack_len + 1;
}
