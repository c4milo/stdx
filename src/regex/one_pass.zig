//! Claim R6 (decision 86): the capture groups of a match by one thread, where the forward program
//! is one-pass.
//!
//! The matcher keeps a thread for each instruction that waits for an octet, and copies each
//! thread's slots as it moves. A program is one-pass where no two instructions that a position's
//! paths reach take the same octet, and no path reaches `match` beside one that reaches an
//! instruction that takes an octet. A path through an assertion of the text's end takes no octet
//! after it, so such a `match` stands beside no octet. Then each position holds one thread, and
//! one thread from the match's start finds every group.
//!
//! `find` follows that thread's paths as `Matcher.follow` does: the preferred branch of each
//! split first, each instruction once a position, and the saves undone through the matcher's
//! stack. It writes the matcher's slots, so `Matcher.group` reads the groups. RE2 and Rust's
//! regex crate keep a one-pass DFA for this case (Cox, "Regular Expression Matching in the Wild",
//! 2010).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Context = program_file.Context;
const Instruction = program_file.Instruction;
const matcher_file = @import("matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;
const is_continuation = @import("utf8_ranges.zig").is_continuation;
const one_pass_table = @import("one_pass_table.zig");

/// The bits of a set of octets, a word for each 64.
const Octets = [constants.octet_values / @bitSizeOf(u64)]u64;

/// True when the matcher's forward program is one-pass. It walks with the matcher's lists, and
/// gives false for a program of more than `one_pass_instructions_max` instructions.
pub fn check(matcher: *Matcher) bool {
    const program = &matcher.program;
    if (program.forward_len > constants.one_pass_instructions_max) return false;
    if (!closure_is_one_pass(matcher, program.forward)) return false;
    for (program.instructions[0..program.forward_len]) |instruction| {
        if (instruction.kind == .range and !closure_is_one_pass(matcher, instruction.out)) return false;
    }
    return true;
}

/// True when the instructions that the paths from `seed` reach take no octet twice, and no path
/// reaches `match` where another reaches an instruction that takes an octet. Each assertion but
/// one of the text's end is taken to hold, so the judgment covers every context.
fn closure_is_one_pass(matcher: *Matcher, seed: u32) bool {
    const instructions = matcher.program.instructions;
    var taken: Octets = @splat(0);
    var takes = false;
    var matches = false;
    matcher.visited.clear();
    _ = matcher.visited.insert(seed);
    matcher.stack[0] = seed;
    var stack_len: usize = 1;
    // Each instruction goes on the stack once, the first time the walk meets it.
    for (0..matcher.program.forward_len) |_| {
        if (stack_len == 0) break;
        stack_len -= 1;
        const index = matcher.stack[stack_len];
        const instruction = instructions[index];
        switch (instruction.kind) {
            .range, .ranges => {
                if (!take_node_once(instructions, index, &taken)) return false;
                takes = true;
            },
            .match => matches = true,
            .fail => {},
            // No octet follows the text's end.
            .look => if (instruction.look != .ahead_text) {
                stack_len = push_new(matcher, stack_len, instruction.out);
            },
            .save, .jump => stack_len = push_new(matcher, stack_len, instruction.out),
            .split => {
                stack_len = push_new(matcher, stack_len, instruction.arg);
                stack_len = push_new(matcher, stack_len, instruction.out);
            },
        }
    }
    assert(stack_len == 0);
    return !(takes and matches);
}

fn push_new(matcher: *Matcher, stack_len: usize, index: u32) usize {
    if (!matcher.visited.insert(index)) return stack_len;
    matcher.stack[stack_len] = index;
    return stack_len + 1;
}

/// Adds the octets the `range` or the `ranges` node at `index` takes to `taken`. False where one
/// of them was there already.
fn take_node_once(instructions: []const Instruction, index: u32, taken: *Octets) bool {
    const instruction = instructions[index];
    if (instruction.kind == .range) return take_once(taken, instruction);
    for (instructions[index + 1 ..][0..instruction.arg]) |member| {
        if (!take_once(taken, member)) return false;
    }
    return true;
}

fn take_once(taken: *Octets, range: Instruction) bool {
    // At most `octet_values` octets.
    for (range.lo..@as(usize, range.hi) + 1) |octet| {
        const word = octet / @bitSizeOf(u64);
        const bit = @as(u64, 1) << @intCast(octet % @bitSizeOf(u64));
        if (taken[word] & bit != 0) return false;
        taken[word] |= bit;
    }
    return true;
}

/// What one position's paths gave: a match, no thread, or the instruction after the one that
/// took the position's octet.
const Outcome = union(enum) { matched, dead, took: u32 };

/// The match that starts at `from`, as the matcher finds it anchored there, with its groups in
/// the matcher's slots. Null where no match starts there. The matcher must keep every group's
/// slots, and its program must be one-pass.
pub fn find(matcher: *Matcher, haystack: []const u8, from: usize) ?Span {
    assert(from <= haystack.len);
    assert(matcher.slots_len == matcher.program.slot_count());
    matcher.start(if (from == 0) null else haystack[from - 1], from);
    // A loop of stores, where `@memset` of a few slots costs a call that writes an octet a step.
    for (matcher.current()) |*slot| slot.* = constants.slot_unset;
    // No match starts before a continuation octet of UTF-8, as in the matcher.
    if (from < haystack.len and is_continuation(haystack[from])) return finish(matcher, false);
    if (one_pass_table.prepare(matcher)) |table| return one_pass_table.run(table, matcher, haystack, from);
    var seed = matcher.program.forward;
    var index = from;
    // Each turn takes one octet at least, or ends the search: at most the octets from `from`
    // and one.
    for (from..haystack.len + 1) |_| {
        const run = take_ranges(matcher.program.instructions, haystack, index, seed);
        if (run.dead) return finish(matcher, false);
        if (run.index != index) {
            index = run.index;
            seed = run.seed;
            matcher.position = index;
            matcher.behind = Context.of(haystack[index - 1]);
        }
        switch (step(matcher, haystack, index, seed)) {
            .matched => return finish(matcher, true),
            .dead => return finish(matcher, false),
            .took => |next| {
                seed = next;
                index += 1;
            },
        }
    }
    // At the text's end no instruction takes an octet, so the last turn returned.
    unreachable;
}

/// The outcome of the paths from `seed` at `index`. Where they take the octet there, the
/// matcher's position moves past it.
inline fn step(matcher: *Matcher, haystack: []const u8, index: usize, seed: u32) Outcome {
    const octet: ?u8 = if (index < haystack.len) haystack[index] else null;
    const ahead: Context = if (octet) |known| Context.of(known) else .edge;
    // A seed whose paths are one line needs no list: no branch is tried and undone.
    const outcome = straight(matcher, seed, octet, ahead) orelse follow(matcher, seed, octet, ahead);
    if (outcome == .took) {
        matcher.position = index + 1;
        matcher.behind = ahead;
    }
    return outcome;
}

/// Where a run of seeds that each take an octet at once ended, as most seeds of a one-pass
/// pattern do: the offset, the seed there, and whether a seed refused its octet.
const Run = struct { index: usize, seed: u32, dead: bool };

/// Takes the octets from `from` while the seed takes each at once, one seed an octet. Such a seed
/// writes no slot and reads no assertion, so the run keeps the position in a register.
inline fn take_ranges(instructions: []const Instruction, haystack: []const u8, from: usize, first: u32) Run {
    var seed = first;
    var index = from;
    // Each turn takes one octet at least.
    while (index < haystack.len) {
        switch (take_at_once(instructions, seed, haystack[index])) {
            .next => |next| {
                index += 1;
                if (next == seed) index = loop_end(instructions, haystack, index, seed);
                seed = next;
            },
            .other => return .{ .index = index, .seed = seed, .dead = false },
            .dead => return .{ .index = index, .seed = seed, .dead = true },
        }
    }
    return .{ .index = haystack.len, .seed = seed, .dead = false };
}

/// Where the loop of `x+` or `x*` at the split `seed` stops: the first octet from `from` that its
/// choice does not take back to the seed. The choice is the same at each octet, so the reads of
/// its ranges wait on no octet before.
fn loop_end(instructions: []const Instruction, haystack: []const u8, from: usize, seed: u32) usize {
    const choice = instructions[seed].out;
    assert(instructions[seed].kind == .split and is_choice(instructions, choice));
    for (haystack[from..], from..) |octet, index| {
        if (choice_step(instructions, choice, octet) != seed) return index;
    }
    return haystack.len;
}

/// What a seed does with an octet that a choice takes at once: the instruction after the choice;
/// no thread left; or other, where the seed's paths need `step`.
const AtOnce = union(enum) { next: u32, other, dead };

/// A seed that is a choice has no other path. A seed that is a split whose preferred branch is a
/// choice is the loop of `x+` or `x*`. Where that choice takes the octet, its path is the first
/// that the matcher tries, and so the thread: no other node the seed reaches takes the octet, and
/// the seed reaches no `match` (`closure_is_one_pass`). The path holds no save, so the thread
/// writes no slot.
inline fn take_at_once(instructions: []const Instruction, seed: u32, octet: u8) AtOnce {
    // Where the seed's choice refuses the octet, no thread is left.
    if (is_choice(instructions, seed)) return if (choice_step(instructions, seed, octet)) |next| .{ .next = next } else .dead;
    const instruction = instructions[seed];
    if (instruction.kind != .split or !is_choice(instructions, instruction.out)) return .other;
    return if (choice_step(instructions, instruction.out, octet)) |next| .{ .next = next } else .other;
}

/// True for a node, and for a split of two nodes, as a class of two ranges compiles. A choice
/// writes no slot, and the matcher tries its preferred node first.
inline fn is_choice(instructions: []const Instruction, index: u32) bool {
    const instruction = instructions[index];
    if (is_node(instruction)) return true;
    return instruction.kind == .split and is_node(instructions[instruction.out]) and is_node(instructions[instruction.arg]);
}

/// The instruction after the node of the choice at `index` that takes the octet, the preferred
/// node first.
inline fn choice_step(instructions: []const Instruction, index: u32, octet: u8) ?u32 {
    const instruction = instructions[index];
    if (instruction.kind != .split) return program_file.step(instructions, index, octet);
    return program_file.step(instructions, instruction.out, octet) orelse program_file.step(instructions, instruction.arg, octet);
}

pub fn finish(matcher: *Matcher, matched: bool) ?Span {
    if (matched) @memcpy(matcher.best(), matcher.current());
    matcher.matched = matched;
    matcher.finished = true;
    matcher.stack_len = 0;
    return if (matched) matcher.span() else null;
}

/// The outcome of a seed whose path is one line of saves, jumps and assertions up to `match` or an
/// instruction that takes an octet, or null where it meets a split. The walk writes the line's
/// saves as it goes. Where it meets a split, `follow` takes the seed and writes the same saves
/// with the same position, and every path that survives takes them. A split with a node as a
/// branch is part of the line: `split_branch` gives the one branch that survives.
fn straight(matcher: *Matcher, seed: u32, octet: ?u8, ahead: Context) ?Outcome {
    const instructions = matcher.program.instructions;
    var index = seed;
    // A line holds each instruction once at most: a program's paths that take no octet hold no
    // loop that is not split. A line through splits may go round a loop, as `(a*)*` does where no
    // node takes the octet: each lap does as the first did, so the walk meets the bound and
    // `follow` finds no thread.
    for (0..matcher.program.forward_len) |_| {
        const instruction = &instructions[index];
        switch (instruction.kind) {
            .save => if (instruction.arg < matcher.slots_len) {
                matcher.current()[instruction.arg] = matcher.position;
            },
            // Every path from the seed passes this assertion.
            .look => if (!instruction.look.holds(matcher.behind, ahead)) return .dead,
            .jump => {},
            .range, .ranges => {
                const known = octet orelse return .dead;
                return .{ .took = program_file.step(instructions, index, known) orelse return .dead };
            },
            .match => return .matched,
            .fail => return .dead,
            .split => switch (split_branch(instructions, instruction.*, octet) orelse return null) {
                .took => |next| return .{ .took = next },
                .other => |other| {
                    index = other;
                    continue;
                },
            },
        }
        index = instruction.out;
    }
    return null;
}

/// What a split with a choice as a branch leaves of its paths: the choice's path, which takes the
/// octet; or the other branch, where the choice refuses it.
const Branch = union(enum) { took: u32, other: u32 };

/// A split whose branch is a choice, as the loop of `x+` or `x*` compiles. A choice that refuses
/// the octet ends its paths, which write no slot, so the split's paths are the other branch's. A
/// preferred choice that takes the octet is the thread (`take_at_once`). Null for any other split,
/// and where the other branch's choice takes the octet: the preferred branch's paths, which the
/// matcher tries first, may reach that node through a save, as `(a*)*b` does.
inline fn split_branch(instructions: []const Instruction, split: Instruction, octet: ?u8) ?Branch {
    if (is_choice(instructions, split.out)) {
        const next = choice_step_at(instructions, split.out, octet) orelse return .{ .other = split.arg };
        return .{ .took = next };
    }
    if (!is_choice(instructions, split.arg)) return null;
    if (choice_step_at(instructions, split.arg, octet) != null) return null;
    return .{ .other = split.out };
}

/// `choice_step`, where no octet stands at the text's end.
inline fn choice_step_at(instructions: []const Instruction, index: u32, octet: ?u8) ?u32 {
    return choice_step(instructions, index, octet orelse return null);
}

inline fn is_node(instruction: Instruction) bool {
    return instruction.kind == .range or instruction.kind == .ranges;
}

/// Follows the paths from `seed` that take no octet, as `Matcher.follow` does, until one reaches
/// `match` or an instruction that takes `octet`.
fn follow(matcher: *Matcher, seed: u32, octet: ?u8, ahead: Context) Outcome {
    matcher.visited.clear();
    matcher.stack_len = 0;
    matcher.push(seed, 0);
    // Each instruction starts a path once, and each save pushes one entry that undoes it.
    while (matcher.stack_len > 0) {
        assert(matcher.stack_len <= constants.instructions_max);
        matcher.stack_len -= 1;
        const entry = matcher.stack[matcher.stack_len];
        if (entry & constants.hole_flag != 0) {
            matcher.current()[entry & constants.hole_none] = matcher.stack_values[matcher.stack_len];
            continue;
        }
        var path: ?u32 = entry;
        while (path) |index| {
            switch (visit(matcher, index, octet, ahead)) {
                .next => |next| path = next,
                .done => |outcome| return outcome,
            }
        }
    }
    return .dead;
}

/// One instruction of a path: the instruction the path goes on to, null where it ends, or the
/// position's outcome.
fn visit(matcher: *Matcher, index: u32, octet: ?u8, ahead: Context) union(enum) { next: ?u32, done: Outcome } {
    if (!matcher.visited.insert(index)) return .{ .next = null };
    const instruction = matcher.program.instructions[index];
    switch (instruction.kind) {
        .jump => return .{ .next = instruction.out },
        .split => {
            matcher.push(instruction.arg, 0);
            return .{ .next = instruction.out };
        },
        .save => {
            if (instruction.arg < matcher.slots_len) {
                matcher.push(instruction.arg | constants.hole_flag, matcher.current()[instruction.arg]);
                matcher.current()[instruction.arg] = matcher.position;
            }
            return .{ .next = instruction.out };
        },
        .look => return .{ .next = if (instruction.look.holds(matcher.behind, ahead)) instruction.out else null },
        .range, .ranges => {
            const known = octet orelse return .{ .next = null };
            const next = program_file.step(matcher.program.instructions, index, known) orelse return .{ .next = null };
            return .{ .done = .{ .took = next } };
        },
        .match => return .{ .done = .matched },
        .fail => return .{ .next = null },
    }
}

const testing = std.testing;
const compiler = @import("compile.zig");
const Generator = @import("codec").testing.split.Generator;

/// The instructions and the matcher's words a test's pattern takes at most.
const test_storage_len = 1024;
const test_memory_len = 1 << test_memory_bits;
/// The words of a test matcher's memory, as a power of two.
const test_memory_bits = 16;

/// A program and a matcher that keeps every group's slots, anchored.
const Fixture = struct {
    storage: [test_storage_len]Instruction = undefined,
    memory: [test_memory_len]u64 = undefined,
    program: program_file.Program = undefined,
    matcher: Matcher = undefined,

    fn init(fixture: *Fixture, pattern: []const u8) !void {
        fixture.program = try compiler.compile(pattern, .{}, &fixture.storage);
        const len = Matcher.memory_len(fixture.program.forward_len, fixture.program.slot_count());
        fixture.matcher.init(&fixture.program, .{ .captures = .groups, .anchored = true }, fixture.memory[0..len]);
    }
};

test "check takes a program where each octet leads one thread on, and refuses one where it leads two" {
    var fixture: Fixture = .{};
    const one_pass_patterns = [_][]const u8{
        "^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})Z$",
        "^([a-z]+)@([a-z]+)$",
        "^[a-z_][a-z0-9_]*(\\.[a-z_][a-z0-9_]*)*$",
        "(a)(b)c",
        "(a|b)c",
        "(a)|b",
        "(\\bab)",
        // A class of three octets is one `ranges` node.
        "([ :x])c",
    };
    for (one_pass_patterns) |pattern| {
        try fixture.init(pattern);
        if (!check(&fixture.matcher)) return error.TestExpectedOnePass;
    }
    // Two threads take one octet, or a match stands beside an octet.
    const other_patterns = [_][]const u8{ "(a|ab)c", "a*a", "(a+)(a+)", "(.*)x", "([a-z]+)", "(a|b)*", "x(a?)a", "\\b(a|ab)c", "([ :x])|(x)" };
    for (other_patterns) |pattern| {
        try fixture.init(pattern);
        if (check(&fixture.matcher)) return error.TestUnexpectedOnePass;
    }
}

/// The octets of a test's texts, which the patterns below take and refuse.
const test_alphabet = "ab09-T:Z@x.\xC3\xA9";

/// One-pass patterns with groups, over the octets of `test_alphabet`.
const test_patterns = [_][]const u8{
    "([0-9]{2})-([0-9]{2})T([0-9])Z",
    "^([ab]+)@([ab]+)$",
    "([ab][ab0]*)(\\.([ab][ab0]*))*$",
    "(?:(a)|(b)(x)?)$",
    "(a(b)?)x",
    "\\b(a)(b)\\b",
    "(?:(a)|(b))+x",
    // After `x`, a split whose other branch is `b`, which its preferred branch reaches through
    // the group's saves: the thread takes them.
    "x(a*)*b",
    // A loop of a split of two nodes, whose exit leads to a node: `a` is the second node's.
    "([ab0]*)x",
    // An assertion in a loop that saves no slot: `\b` holds before the first `a` of a run alone.
    "(?:\\ba|-)+(x)",
    // An empty match, which no position inside the UTF-8 of a scalar value starts.
    "()",
};

test "find gives the match and the groups the matcher gives, anchored at every offset" {
    var fixture: Fixture = .{};
    var reference: Fixture = .{};
    var generator = Generator.init(0x0E1A);
    for (test_patterns) |pattern| {
        // By the table (one_pass_table.zig), then by the walk alone.
        for ([_]matcher_file.OnePassTable{ .none, .absent }) |table| {
            try fixture.init(pattern);
            fixture.matcher.one_pass_table = table;
            try reference.init(pattern);
            try testing.expect(check(&fixture.matcher));
            try expect_agree_on_texts(&fixture, &reference, &generator);
        }
    }
}

/// `expect_agree` from every offset of `test_texts` texts the generator draws.
fn expect_agree_on_texts(fixture: *Fixture, reference: *Fixture, generator: *Generator) !void {
    var text: [test_text_len]u8 = undefined;
    for (0..test_texts) |_| {
        for (&text) |*octet| octet.* = test_alphabet[generator.below(test_alphabet.len)];
        for (0..text.len + 1) |from| try expect_agree(fixture, reference, &text, from);
    }
}

test "the octets a run of ranges takes set the context an assertion after them reads" {
    var fixture: Fixture = .{};
    var reference: Fixture = .{};
    // A step takes `-`, and a run takes `a`: `\b` reads `a` behind it, not `-`.
    const pattern = "(-a)\\b-";
    try fixture.init(pattern);
    try reference.init(pattern);
    try testing.expect(check(&fixture.matcher));
    try testing.expect(find(&fixture.matcher, "-a-", 0) != null);
    for ([_][]const u8{ "-a-", "--a-", "-a--a-" }) |text| {
        for (0..text.len + 1) |from| try expect_agree(&fixture, &reference, text, from);
    }
}

/// The octets of a test's text, and the texts of each pattern.
const test_text_len = 24;
const test_texts = 64;

fn expect_agree(fixture: *Fixture, reference: *Fixture, text: []const u8, from: usize) !void {
    const expected = reference.matcher.find(text, from);
    try testing.expectEqual(expected, find(&fixture.matcher, text, from));
    if (expected == null) return;
    for (0..fixture.program.group_count) |group| {
        try testing.expectEqual(reference.matcher.group(@intCast(group)), fixture.matcher.group(@intCast(group)));
    }
}
