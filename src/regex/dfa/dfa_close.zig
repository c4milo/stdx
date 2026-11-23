//! A state's threads, built from its seeds as the matcher builds a position's threads, with no
//! capture slot (dfa.zig, decision 86).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Context = @import("../program.zig").Context;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const restart_bit = dfa_file.restart_bit;
const context_mask = dfa_file.context_mask;

/// Builds a state's threads, as `Matcher.close` does, with no slot. True when a thread reached
/// `match`; under `Kind.first` the build ends there.
pub fn close(dfa: *Dfa, state: u32, ahead: Context, may_start: bool) bool {
    const head = dfa.cache.head(state);
    const behind: Context = @enumFromInt(head & context_mask);
    dfa.visited.clear();
    dfa.threads_len = 0;
    dfa.reached = false;
    var seeds = dfa.cache.seeds(state);
    while (seeds.next()) |seed| {
        follow(dfa, seed, behind, ahead);
        if (dfa.reached and dfa.config.kind == .first) return true;
    }
    if (head & restart_bit != 0 and may_start) follow(dfa, dfa.config.entry, behind, ahead);
    return dfa.reached;
}

fn follow(dfa: *Dfa, seed: u32, behind: Context, ahead: Context) void {
    assert(dfa.stack_len == 0);
    dfa.stack[0] = seed;
    dfa.stack_len = 1;
    while (dfa.stack_len > 0) {
        assert(dfa.stack_len <= constants.instructions_max);
        dfa.stack_len -= 1;
        var path: ?u32 = dfa.stack[dfa.stack_len];
        while (path) |index| path = visit(dfa, index, behind, ahead);
        if (dfa.reached and dfa.config.kind == .first) {
            dfa.stack_len = 0;
            return;
        }
    }
}

fn visit(dfa: *Dfa, index: u32, behind: Context, ahead: Context) ?u32 {
    if (!dfa.visited.insert(index)) return null;
    const instruction = dfa.instructions[index];
    switch (instruction.kind) {
        .jump, .save => return instruction.out,
        .split => {
            dfa.stack[dfa.stack_len] = instruction.arg;
            dfa.stack_len += 1;
            return instruction.out;
        },
        .look => return if (instruction.look.holds(behind, ahead)) instruction.out else null,
        .range, .ranges => {
            dfa.threads[dfa.threads_len] = index;
            dfa.threads_len += 1;
            return null;
        },
        .match => {
            dfa.reached = true;
            return null;
        },
        .fail => return null,
    }
}
