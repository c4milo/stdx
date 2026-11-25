//! A compiled pattern: instructions that read one octet at a time (decision 86).
//!
//! A program is Thompson's automaton in Pike's instruction form. A scalar value past U+007F is a
//! sequence of octet ranges, so one program runs on octets and no matcher decodes UTF-8. A node of
//! a class is one `ranges` instruction and the apart ranges after it, so a matcher keeps one
//! thread for the node. Every instruction names its targets, so a fragment of a program stands
//! anywhere in it.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const is_continuation = @import("utf8_ranges.zig").is_continuation;

/// What one instruction does.
pub const Kind = enum(u8) {
    /// Take one octet from `lo` to `hi`, both included, then go to `out`.
    range,
    /// Take one octet that one of the next `arg` instructions takes, then go to that one's `out`.
    /// The `arg` instructions are ranges in ascending order and apart, a node of a class, and no
    /// other instruction goes to one of them: a matcher keeps one thread for the node, where a
    /// split of each range would keep one for each range.
    ranges,
    /// Go to `out` first and to `arg` second: `out` is the choice a match prefers.
    split,
    /// Write the position into slot `arg`, then go to `out`.
    save,
    /// Go to `out` when the assertion `look` holds at the position.
    look,
    /// Go to `out`.
    jump,
    /// The pattern matched.
    match,
    /// No octet passes.
    fail,
};

/// What the octet on one side of a position is to an assertion.
pub const Context = enum(u8) {
    /// No octet: the text starts or ends here.
    edge,
    line_feed,
    /// An ASCII letter, a digit or a low line.
    word,
    other,

    pub fn of(octet: u8) Context {
        return switch (octet) {
            constants.line_feed => .line_feed,
            '0'...'9', 'A'...'Z', 'a'...'z', '_' => .word,
            else => .other,
        };
    }
};

/// An assertion about a position, in the order a matcher reads the text. `behind` is the octet a
/// matcher read last and `ahead` the octet it reads next, so one set serves the forward program and
/// the reverse one: `^` is `behind_text` forward and `ahead_text` in reverse.
pub const Look = enum(u8) {
    behind_text,
    ahead_text,
    behind_line,
    ahead_line,
    word_boundary,
    not_word_boundary,

    pub fn holds(look: Look, behind: Context, ahead: Context) bool {
        return switch (look) {
            .behind_text => behind == .edge,
            .ahead_text => ahead == .edge,
            .behind_line => behind == .edge or behind == .line_feed,
            .ahead_line => ahead == .edge or ahead == .line_feed,
            .word_boundary => (behind == .word) != (ahead == .word),
            .not_word_boundary => (behind == .word) == (ahead == .word),
        };
    }

    /// True when the assertion reads the octet ahead, so a matcher cannot judge it before that
    /// octet or the end of the text is known.
    pub fn reads_ahead(look: Look) bool {
        return switch (look) {
            .behind_text, .behind_line => false,
            .ahead_text, .ahead_line, .word_boundary, .not_word_boundary => true,
        };
    }

    /// The same assertion for a matcher that reads the text in the other direction.
    pub fn reversed(look: Look) Look {
        return switch (look) {
            .behind_text => .ahead_text,
            .ahead_text => .behind_text,
            .behind_line => .ahead_line,
            .ahead_line => .behind_line,
            .word_boundary => .word_boundary,
            .not_word_boundary => .not_word_boundary,
        };
    }
};

/// One instruction. Its size is 12 octets and its alignment 4, so a thousand instructions take
/// 12 kB.
pub const Instruction = extern struct {
    /// The instruction that follows, for every kind but `match` and `fail`.
    out: u32 = 0,
    /// A split's second target, or a save's slot.
    arg: u32 = 0,
    kind: Kind,
    /// A range's first and last octet.
    lo: u8 = 0,
    hi: u8 = 0,
    look: Look = .behind_text,

    pub fn takes(instruction: Instruction, octet: u8) bool {
        assert(instruction.kind == .range);
        return instruction.lo <= octet and octet <= instruction.hi;
    }
};

/// The instruction a matcher goes to after the instruction at `index`, a `range` or a `ranges`,
/// takes `octet`, or null where it does not take it. Inline for a `range`, the commonest; a
/// `ranges` is found in a call of its own.
pub inline fn step(instructions: []const Instruction, index: u32, octet: u8) ?u32 {
    const instruction = instructions[index];
    if (instruction.kind == .range) return if (instruction.takes(octet)) instruction.out else null;
    return step_ranges(instructions, index, octet);
}

/// `step` of a `ranges`: its first `ranges_scan_len` ranges in order, then the rest by halving, at
/// most eight steps for 256 ranges. The ranges ascend and stand apart. It asserts nothing, as it
/// runs for each octet (decision 17): the builders of a node assert its count and write its
/// members as ranges (`syntax_atom_ranges.node` and `syntax_atom_utf8_node.write_apart`).
pub fn step_ranges(instructions: []const Instruction, index: u32, octet: u8) ?u32 {
    const instruction = instructions[index];
    const members = instructions[index + 1 ..][0..instruction.arg];
    const scanned = @min(members.len, constants.ranges_scan_len);
    for (members[0..scanned]) |member| {
        // An octet under a range stands between it and the one before.
        if (octet < member.lo) return null;
        if (octet <= member.hi) return member.out;
    }
    // The ranges below `low` start at or below `octet`, and those from `high` above it.
    var low: usize = scanned;
    var high: usize = members.len;
    // Each turn halves the ranges left, so the turns are at most the bits of their count.
    while (low < high) {
        const middle = low + ((high - low) >> 1);
        if (members[middle].lo <= octet) low = middle + 1 else high = middle;
    }
    if (low == scanned) return null;
    const member = members[low - 1];
    return if (octet <= member.hi) member.out else null;
}

/// An entry that names no program.
pub const no_entry = std.math.maxInt(u32);

/// A named capture group, as `(?P<year>` names one: its group and its name, which `compile`
/// copies, so a program's names do not hold the pattern.
pub const GroupName = struct {
    group: u32,
    len: u8,
    octets: [constants.group_name_len_max]u8,

    pub fn name(group_name: *const GroupName) []const u8 {
        return group_name.octets[0..group_name.len];
    }
};

/// How a program reads its text (decision 86 as amended).
pub const Encoding = enum(u8) {
    /// RFC 3629's UTF-8. A pattern's scalar values match their UTF-8, a byte that is not UTF-8
    /// matches nothing, and no match starts before a continuation byte.
    utf8,
    /// Bytes of any value, with no Unicode. A pattern's characters still match their UTF-8,
    /// but `.`, a class and an escape such as `\xE9` each take one byte, UTF-8 or not, and a
    /// match may start before any byte. A byte past 0x7F has no case and no class: `(?i)`
    /// folds ASCII alone.
    bytes,

    /// True where a match may start before `octet`: before any byte in bytes, and in UTF-8
    /// before any but a continuation byte, so that no match cuts a scalar value in two.
    pub fn may_start_at(encoding: Encoding, octet: u8) bool {
        return encoding == .bytes or !is_continuation(octet);
    }
};

/// A compiled pattern. It holds a slice of the storage the caller gave `compile`, so it lives as
/// long as that storage, and any number of matchers on any threads may read it.
pub const Program = struct {
    /// The forward program, then the reverse program when the options asked for one.
    instructions: []const Instruction,
    /// The instructions of the forward program, which come first.
    forward_len: u32,
    /// The nodes of the forward program and of the reverse one: every instruction but the
    /// ranges that a `ranges` node holds after it. A DFA's lists hold nodes alone (dfa_config.zig).
    forward_nodes: u32,
    reverse_nodes: u32,
    /// Where the forward program starts. It writes slots 0 and 1 around the whole match.
    forward: u32,
    /// Where the reverse program starts, or `no_entry`. It matches each match read backward and
    /// writes no slot.
    reverse: u32,
    /// The fewest bytes a match takes, or fewer, as the compiler counts its fragments: an
    /// assertion counts none. A search of a text with fewer bytes after its start finds no
    /// match (claim R13's least length). spec/lean/Stdx/Regex/RulesLength.lean judges it.
    len_min: u32 = 0,
    /// The capture groups, the whole match counted as group 0.
    group_count: u32,
    /// True when an assertion reads the octet ahead of a position.
    reads_ahead: bool,
    /// True when the program holds any assertion.
    has_looks: bool,
    /// How the program reads a text, as `Options.encoding` names it.
    encoding: Encoding,
    /// The class of each octet: two octets of one class take every program to the same state.
    classes: [constants.octet_values]u8,
    /// The classes `classes` names.
    class_count: u16,
    /// The names of the named groups, in the order they open, where the caller gave `compile`
    /// storage for them in `Options.names`, and empty where it gave none.
    names: []const GroupName,

    pub fn slot_count(program: *const Program) u32 {
        return program.group_count * constants.group_slots;
    }

    /// The group a name names, or null where no group holds it or the program keeps no names.
    pub fn group_index(program: *const Program, group_name: []const u8) ?u32 {
        assert(program.names.len <= constants.group_names_max);
        for (program.names) |*named| {
            if (std.mem.eql(u8, named.name(), group_name)) return named.group;
        }
        return null;
    }
};

comptime {
    assert(@sizeOf(Instruction) == 3 * @sizeOf(u32));
    assert(@alignOf(Instruction) == @alignOf(u32));
    assert(std.meta.fields(Context).len == constants.context_count);
}

const testing = std.testing;

test "a match starts before a continuation byte in bytes alone" {
    for ([_]u8{ 0x00, 'a', 0x7F, 0xC2, 0xF4, 0xFF }) |octet| {
        try testing.expect(Encoding.utf8.may_start_at(octet));
        try testing.expect(Encoding.bytes.may_start_at(octet));
    }
    for ([_]u8{ constants.continuation_min, 0xA9, constants.continuation_max }) |octet| {
        try testing.expect(!Encoding.utf8.may_start_at(octet));
        try testing.expect(Encoding.bytes.may_start_at(octet));
    }
}

test "Context names the line feed, the word characters and the rest" {
    try testing.expectEqual(Context.line_feed, Context.of('\n'));
    for ("09AZaz_") |octet| try testing.expectEqual(Context.word, Context.of(octet));
    for ("/:@[`{ \r\x00\x80\xff") |octet| try testing.expectEqual(Context.other, Context.of(octet));
}

test "each assertion holds on its side of a position alone" {
    try testing.expect(Look.behind_text.holds(.edge, .word));
    try testing.expect(!Look.behind_text.holds(.line_feed, .edge));
    try testing.expect(Look.ahead_text.holds(.word, .edge));
    try testing.expect(!Look.ahead_text.holds(.edge, .line_feed));
    try testing.expect(Look.behind_line.holds(.line_feed, .other));
    try testing.expect(Look.behind_line.holds(.edge, .other));
    try testing.expect(!Look.behind_line.holds(.other, .line_feed));
    try testing.expect(Look.ahead_line.holds(.other, .line_feed));
    try testing.expect(Look.ahead_line.holds(.other, .edge));
    try testing.expect(!Look.ahead_line.holds(.line_feed, .other));
}

test "a word boundary lies between a word character and anything else" {
    const sides = [_]Context{ .edge, .line_feed, .word, .other };
    for (sides) |behind| {
        for (sides) |ahead| {
            const boundary = (behind == .word) != (ahead == .word);
            try testing.expectEqual(boundary, Look.word_boundary.holds(behind, ahead));
            try testing.expectEqual(!boundary, Look.not_word_boundary.holds(behind, ahead));
        }
    }
}

test "reversing an assertion twice gives it back, and swaps the side it reads" {
    const looks = [_]Look{ .behind_text, .ahead_text, .behind_line, .ahead_line, .word_boundary, .not_word_boundary };
    const sides = [_]Context{ .edge, .line_feed, .word, .other };
    for (looks) |look| {
        try testing.expectEqual(look, look.reversed().reversed());
        for (sides) |behind| {
            for (sides) |ahead| {
                try testing.expectEqual(look.holds(behind, ahead), look.reversed().holds(ahead, behind));
            }
        }
    }
}

test "step takes each octet that one of a node's ranges takes, by the scan and by halving" {
    // Six ranges: the first `ranges_scan_len` by the scan, the rest by halving.
    const ranges = [_][2]u8{ .{ 0x00, 0x09 }, .{ 0x0B, 0x0B }, .{ 0x20, 0x3A }, .{ 0x3C, 0x7F }, .{ 0xC2, 0xDF }, .{ 0xF0, 0xF4 } };
    comptime assert(ranges.len > constants.ranges_scan_len);
    // A range's target is its place past the node, so a wrong range gives a wrong target.
    const target_base = 100;
    var instructions: [ranges.len + 1]Instruction = undefined;
    instructions[0] = .{ .kind = .ranges, .arg = ranges.len };
    for (ranges, 1..) |range, index| {
        instructions[index] = .{ .kind = .range, .lo = range[0], .hi = range[1], .out = @intCast(target_base + index) };
    }
    for (0..constants.octet_values) |value| {
        const octet: u8 = @intCast(value);
        var expected: ?u32 = null;
        for (ranges, 1..) |range, index| {
            if (octet >= range[0] and octet <= range[1]) expected = @intCast(target_base + index);
        }
        try testing.expectEqual(expected, step(&instructions, 0, octet));
    }
}
