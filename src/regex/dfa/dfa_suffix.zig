//! Claim R4 (decision 86): the literal every match ends with, where a search may start from it,
//! as in `[0-9][0-9,]* km`.
//!
//! The searcher goes to the literal's next place, and the reverse DFA reads back from the
//! place's end to the least start of a match that ends there. That is the forward search's
//! answer where no part of a match before its literal takes the literal's first octet:
//!
//! - A match holds that octet only in its literal, so the first place at or after a match's start
//!   is the place that ends it. The least start found from the places in turn is the match's.
//! - No octet the reverse DFA read between the start and the place is that octet, so every match
//!   from the start ends at the place's end, and the search needs no forward scan.
//! - Each reverse scan stops at the place before its own, which holds that octet, so a search
//!   reads each octet a bounded number of times and stays linear in the text.
//!
//! Rust's regex crate takes the same search where it proves a like rule, and then runs its
//! forward DFA from the start, since its rule lets a match go on past the place.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Program = @import("../program.zig").Program;
const Literal = @import("../literal.zig").Literal;
const Dfa = @import("dfa.zig").Dfa;

/// The literal every match of `program` ends with, where no instruction of the reverse program
/// after it takes its first octet. `reverse` is the reverse program's DFA, whose lists the walk
/// takes. Null where the program has no such literal.
pub fn suffix_of(reverse: *Dfa, program: *const Program) ?Literal {
    assert(reverse.config.entry == program.reverse);
    const suffix = Literal.suffix_of(program) orelse return null;
    const first = suffix.literal.octets[0];
    if (before_takes(reverse, suffix.before, first)) return null;
    // A first place that folds takes its octet in either case.
    if (suffix.literal.fold_at(0) != 0 and before_takes(reverse, suffix.before, first ^ constants.case_bit)) return null;
    return suffix.literal;
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
        const instruction = dfa.instructions[dfa.stack[stack_len]];
        switch (instruction.kind) {
            .range => if (instruction.takes(octet)) return true,
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
