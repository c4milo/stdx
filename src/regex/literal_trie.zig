//! A pattern that is an alternation of literals and nothing else, as a trie (decision 86 as
//! amended): rebar's dictionary is 2,663 words, and one alternative for each word costs every
//! state of a DFA a visit to every word.
//!
//! The literals are sorted and taken in order, by the incremental construction of Daciuk, Mihov,
//! Watson and Watson (Computational Linguistics 26(1), 2000), as `syntax_atom_utf8.zig` writes a
//! class. The octets that literals start with in common are taken once, and each node whose
//! instructions equal another's is written once. A literal that ends where others go on is an end
//! inside a node.
//!
//! The forward program keeps RE2's leftmost-first rule: of the literals that match at one place,
//! the first in the pattern wins. Two literals that match at one place are one the start of the
//! other, so they meet in one node, where the shorter one ends. The node's branches go in the order
//! of the first literal under each, and its end goes where the order of the literals puts it. A
//! node whose end stands between two literals of one branch has no such order, and the pattern is
//! then compiled as the parser reads it. The reverse program keeps the longest match, so the order
//! of its branches chooses nothing.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const errors = @import("errors.zig");
const fragment = @import("fragment.zig");
const program_file = @import("program.zig");
const Builder = fragment.Builder;
const Fragment = fragment.Fragment;
const Holes = fragment.Holes;
const Instruction = program_file.Instruction;
const scan_file = @import("literal_trie_scan.zig");
const Entry = scan_file.Entry;
const Shape = scan_file.Shape;

/// An open node: where its branches start among the open branches, the octet of the branch it
/// leads on by, and the literal that ends at it.
const Open = extern struct { start: u32, last: u32, end: u32 };

/// An `Open`'s `last` or `end` that holds none.
const none = std.math.maxInt(u32);

/// One branch of a node, to the node it leads to, with the first and the last literal that a
/// match through it can take: a literal under it that no earlier literal under it starts.
const Transition = extern struct { octet: u32, next: u32, first: u32, last: u32 };

/// A node the program holds, under the hash of its instructions, as in syntax_atom_utf8.zig.
const Slot = extern struct { hash: u32 = 0, first: u32 = 0, count: u32 = 0 };

/// A written node: its entry, and the first and the last literal a match through it can take.
const Written = struct { entry: u32, first: u32, last: u32 };

/// The trie of `pattern`, read in the builder's direction, or null where the pattern is not an
/// alternation of more than `literal_set_max` literals, the flags start under `(?i)`, a node has
/// no order for its end, or the storage past the program has no room for the sorted literals.
/// The caller then compiles the pattern as the parser reads it.
pub fn alternation(builder: *Builder, pattern: []const u8, case_insensitive: bool) errors.Error!?Fragment {
    if (case_insensitive or !scan_file.may_be_alternation(pattern)) return null;
    const shape = scan_file.scan(pattern) orelse return null;
    if (shape.count <= constants.literal_set_max) return null;
    return build(builder, pattern, shape);
}

/// Writes the literals' octets and entries past the program, sorts the entries, and writes the
/// trie below them. The lists the construction keeps take the same storage.
fn build(builder: *Builder, pattern: []const u8, shape: Shape) errors.Error!?Fragment {
    const free = std.mem.sliceAsBytes(builder.instructions[builder.len..]);
    const layout: Layout = .of(shape);
    if (layout.len > free.len) return null;
    // The area's octets come first, so that the lists after them end on the storage's end and
    // keep its alignment.
    const area = free[free.len - layout.len ..];
    const octets = area[0..shape.octets_len];
    var lists: []align(@alignOf(Instruction)) u8 = @alignCast(area[shape.octets_len..]);
    const entries = take(Entry, &lists, shape.count);
    const reverse = builder.direction == .reverse;
    scan_file.write_literals(pattern, octets, entries, reverse);
    std.sort.pdq(Entry, entries, Order{ .octets = octets, .reverse = reverse }, Order.less);
    var below: Builder = .{
        .instructions = builder.instructions[0 .. builder.len + (free.len - layout.len) / @sizeOf(Instruction)],
        .len = builder.len,
        .direction = builder.direction,
    };
    var compiler: Compiler = .{
        .builder = &below,
        .begin = builder.len,
        .ordered = !reverse,
        .transitions = take(Transition, &lists, layout.transitions),
        .slots = take(Slot, &lists, layout.slots),
        .open = take(Open, &lists, shape.depth + 1),
    };
    @memset(compiler.slots, .{});
    const built = compiler.run(octets, entries) catch |err| switch (err) {
        // Below the sorted literals the program has less room than the parser's may need.
        error.NoSpaceLeft => null,
        else => return err,
    };
    if (built == null) below.truncate(compiler.begin);
    builder.len = below.len;
    return built;
}

/// The octets past the program the construction takes for a pattern's literals: their octets,
/// their entries, the open nodes' branches, the table of written nodes and the open nodes.
const Layout = struct {
    transitions: usize,
    slots: usize,
    len: usize,

    fn of(shape: Shape) Layout {
        // A branch of an open node is an edge of the trie, one for each octet of a literal at most.
        const transitions = @as(usize, shape.octets_len) + 1;
        const slots = std.math.ceilPowerOfTwoAssert(usize, @max(transitions / constants.trie_octets_per_slot, constants.trie_node_slots_min));
        const len = shape.octets_len + shape.count * @sizeOf(Entry) + transitions * @sizeOf(Transition) +
            slots * @sizeOf(Slot) + (@as(usize, shape.depth) + 1) * @sizeOf(Open);
        return .{ .transitions = transitions, .slots = slots, .len = len };
    }
};

fn take(comptime T: type, lists: *[]align(@alignOf(Instruction)) u8, count: usize) []T {
    comptime assert(@alignOf(T) == @alignOf(Instruction) and @sizeOf(T) % @alignOf(Instruction) == 0);
    const taken = lists.*[0 .. count * @sizeOf(T)];
    lists.* = @alignCast(lists.*[count * @sizeOf(T) ..]);
    return std.mem.bytesAsSlice(T, taken);
}

/// The order the trie takes its literals in: octet by octet, from the first forward and from the
/// last in reverse, a literal before each that it starts.
const Order = struct {
    octets: []const u8,
    reverse: bool,

    fn less(order: Order, left: Entry, right: Entry) bool {
        if (left.key != right.key) return left.key < right.key;
        const a = order.octets[left.offset..][0..left.len];
        const b = order.octets[right.offset..][0..right.len];
        for (0..@min(a.len, b.len)) |place| {
            const x = if (order.reverse) a[a.len - 1 - place] else a[place];
            const y = if (order.reverse) b[b.len - 1 - place] else b[place];
            if (x != y) return x < y;
        }
        if (a.len != b.len) return a.len < b.len;
        // A literal twice: the first in the pattern first.
        return left.index < right.index;
    }
};

const Compiler = struct {
    builder: *Builder,
    begin: u32,
    /// True for the forward program, whose branches keep the order of the literals.
    ordered: bool,
    holes: Holes = .{},
    /// The branches of the open nodes, the root's first: node `d`'s run from its start to the
    /// next node's.
    transitions: []Transition,
    transitions_len: u32 = 0,
    slots: []Slot,
    /// The open nodes, the root first, along the path of the last literal.
    open: []Open,
    depth: u32 = 1,

    fn run(compiler: *Compiler, octets: []const u8, entries: []const Entry) errors.Error!?Fragment {
        compiler.open[0] = .{ .start = 0, .last = none, .end = none };
        for (entries) |entry| {
            if (!try compiler.add(octets[entry.offset..][0..entry.len], entry.index)) return null;
        }
        if (!try compiler.close_deeper(0)) return null;
        const root = (try compiler.write(0)) orelse return null;
        assert(!compiler.holes.is_empty());
        return .{ .begin = compiler.begin, .entry = root.entry, .holes = compiler.holes, .nullable = false, .weight = 1 };
    }

    /// Takes a literal in sorted order. False where a node it closes has no order for its end.
    fn add(compiler: *Compiler, literal: []const u8, index: u32) errors.Error!bool {
        assert(literal.len > 0 and literal.len < compiler.open.len);
        var shared: u32 = 0;
        // The open path's branches lead by the octets of the literal before, in reading order.
        for (0..@min(literal.len, compiler.depth - 1)) |place| {
            if (compiler.open[place].last != compiler.octet_at(literal, place)) break;
            shared += 1;
        }
        if (!try compiler.close_deeper(shared)) return false;
        if (shared == literal.len) {
            // The literal again: the first in the pattern keeps the end.
            if (compiler.open[shared].end == none) compiler.open[shared].end = index;
            return true;
        }
        compiler.open[shared].last = compiler.octet_at(literal, shared);
        for (shared + 1..literal.len + 1) |place| {
            compiler.open[place] = .{
                .start = compiler.transitions_len,
                .last = if (place < literal.len) compiler.octet_at(literal, place) else none,
                .end = if (place == literal.len) index else none,
            };
        }
        compiler.depth = @intCast(literal.len + 1);
        return true;
    }

    /// The octet the program reads at `place` of a literal: from its first octet forward, and
    /// from its last in reverse.
    fn octet_at(compiler: *const Compiler, literal: []const u8, place: usize) u8 {
        return if (compiler.ordered) literal[place] else literal[literal.len - 1 - place];
    }

    /// Writes each open node deeper than `node`, the deepest first, and gives the branch that led
    /// to each its entry. False where a node has no order for its end.
    fn close_deeper(compiler: *Compiler, node: u32) errors.Error!bool {
        assert(node < compiler.depth);
        // Each turn writes one open node, at most the open nodes.
        for (0..compiler.open.len) |_| {
            if (compiler.depth == node + 1) return true;
            const deepest = compiler.depth - 1;
            const written = (try compiler.write(deepest)) orelse return false;
            compiler.transitions_len = compiler.open[deepest].start;
            compiler.depth = deepest;
            const parent = &compiler.open[deepest - 1];
            // An open branch is an edge of the trie, and the list holds one for each octet.
            assert(compiler.transitions_len < compiler.transitions.len);
            compiler.transitions[compiler.transitions_len] = .{ .octet = parent.last, .next = written.entry, .first = written.first, .last = written.last };
            compiler.transitions_len += 1;
            parent.last = none;
        }
        unreachable;
    }

    /// Writes the open node `node`, whose branches all lead to written nodes. Null where its
    /// end stands between two literals of one branch, in the forward program.
    fn write(compiler: *Compiler, node: u32) errors.Error!?Written {
        const branches = compiler.transitions[compiler.open[node].start..compiler.transitions_len];
        const end = compiler.open[node].end;
        const ends = end != none;
        var first: u32 = end;
        var last: u32 = 0;
        for (branches) |branch| {
            first = @min(first, branch.first);
            last = @max(last, branch.last);
            if (compiler.ordered and ends and branch.first < end and branch.last > end) return null;
        }
        // The end's literal starts every literal under the node, so no match through a branch
        // takes a literal after it: the last answer is the end's.
        if (ends) last = end;
        if (compiler.ordered) std.sort.insertion(Transition, branches, {}, by_first);
        // The end goes before every branch whose literals follow it in the pattern.
        var end_place: usize = branches.len;
        if (ends) {
            for (branches, 0..) |branch, place| {
                if (branch.first > end) {
                    end_place = place;
                    break;
                }
            }
        }
        const entry = try compiler.emit(branches, ends, end_place);
        return .{ .entry = entry, .first = first, .last = last };
    }

    /// The entry of a node of these branches and, where `ends`, an end at `end_place` among
    /// them: a node the program holds with the same instructions, or one written now.
    fn emit(compiler: *Compiler, branches: []const Transition, ends: bool, end_place: usize) errors.Error!u32 {
        const count = branches.len + @intFromBool(ends);
        assert(count > 0);
        const hash = hash_of(branches, ends, end_place);
        const mask: u32 = @intCast(compiler.slots.len - 1);
        var free: ?u32 = null;
        for (0..constants.trie_node_probes) |probe| {
            const index: u32 = (hash +% @as(u32, @intCast(probe))) & mask;
            const slot = compiler.slots[index];
            if (slot.count == 0) {
                free = index;
                break;
            }
            if (slot.hash == hash and compiler.holds(slot, branches, ends, end_place)) return entry_of(slot);
        }
        const builder = compiler.builder;
        const first: u32 = builder.len;
        for (0..count) |place| {
            if (ends and place == end_place) {
                const jump = try builder.empty();
                compiler.holes = builder.join(compiler.holes, jump.holes);
                continue;
            }
            const branch = branches[place - @intFromBool(ends and place > end_place)];
            _ = try builder.emit(.{ .kind = .range, .lo = @intCast(branch.octet), .hi = @intCast(branch.octet), .out = branch.next });
        }
        var entry = builder.len - 1;
        for (1..count) |back| {
            const index: u32 = @intCast(count - 1 - back);
            entry = try builder.emit(.{ .kind = .split, .out = first + index, .arg = entry });
        }
        const slot: Slot = .{ .hash = hash, .first = first, .count = @intCast(count) };
        assert(entry_of(slot) == entry);
        // A table with no free slot near home forgets the node there, which costs instructions
        // and changes no match.
        compiler.slots[free orelse (hash & mask)] = slot;
        return entry;
    }

    fn holds(compiler: *const Compiler, slot: Slot, branches: []const Transition, ends: bool, end_place: usize) bool {
        if (slot.count != branches.len + @intFromBool(ends)) return false;
        const written = compiler.builder.instructions[slot.first..][0..slot.count];
        for (written, 0..) |instruction, place| {
            if (ends and place == end_place) {
                if (instruction.kind != .jump) return false;
                continue;
            }
            const branch = branches[place - @intFromBool(ends and place > end_place)];
            if (instruction.kind != .range or instruction.lo != branch.octet or instruction.out != branch.next) return false;
        }
        return true;
    }
};

fn by_first(_: void, left: Transition, right: Transition) bool {
    return left.first < right.first;
}

fn entry_of(slot: Slot) u32 {
    assert(slot.count > 0);
    const splits = slot.count - 1;
    return slot.first + slot.count + splits - 1;
}

fn hash_of(branches: []const Transition, ends: bool, end_place: usize) u32 {
    var value: u32 = constants.fnv_offset_basis;
    for (branches) |branch| {
        value = (value ^ branch.octet) *% constants.fnv_prime;
        value = (value ^ branch.next) *% constants.fnv_prime;
    }
    const end_mark: u32 = if (ends) @intCast(end_place) else none;
    return (value ^ end_mark) *% constants.fnv_prime;
}

const testing = std.testing;

test "a written node holds only branches with its own octets and targets, and its end" {
    var storage: [constants.trie_node_slots_min]Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    var transitions: [constants.trie_node_slots_min]Transition = undefined;
    var slots: [constants.trie_node_slots_min]Slot = @splat(.{});
    var open: [1]Open = undefined;
    var compiler: Compiler = .{ .builder = &builder, .begin = 0, .ordered = true, .transitions = &transitions, .slots = &slots, .open = &open };
    const target = try builder.emit(.{ .kind = .fail });
    const other = try builder.emit(.{ .kind = .fail });
    const branches = [_]Transition{ .{ .octet = 'a', .next = target, .first = 0, .last = 0 }, .{ .octet = 'b', .next = target, .first = 1, .last = 1 } };
    const entry = try compiler.emit(&branches, true, 1);
    // The node is written after the two targets: three alternatives, then two splits.
    const slot: Slot = .{ .hash = hash_of(&branches, true, 1), .first = other + 1, .count = 3 };
    try testing.expectEqual(entry, entry_of(slot));
    try testing.expect(compiler.holds(slot, &branches, true, 1));
    var moved = branches;
    moved[1].next = other;
    try testing.expect(!compiler.holds(slot, &moved, true, 1));
    var renamed = branches;
    renamed[0].octet = 'c';
    try testing.expect(!compiler.holds(slot, &renamed, true, 1));
    try testing.expect(!compiler.holds(slot, &branches, true, 0));
    try testing.expect(!compiler.holds(slot, &branches, false, 1));
    // The same node again is found, and writes nothing.
    const len = builder.len;
    try testing.expectEqual(entry, try compiler.emit(&branches, true, 1));
    try testing.expectEqual(len, builder.len);
}

test {
    _ = @import("literal_trie_test.zig");
}
