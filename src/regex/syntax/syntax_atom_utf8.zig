//! A class of many scalar values as a small automaton (decision 86 as amended). Each octet range
//! that UTF-8 sequences of the class start with in common is taken once, and each node whose
//! transitions equal another node's is written once.
//!
//! The method is the incremental construction of Daciuk, Mihov, Watson and Watson, "Incremental
//! Construction of Minimal Acyclic Finite-State Automata", Computational Linguistics 26(1), 2000,
//! over octet ranges in place of letters. It takes the sequences in order. The nodes on the path of
//! the last sequence stay open. A node is written when a later sequence leaves its path, so it is
//! written once, with all its transitions. Rust's regex crate builds the forward automaton of a
//! class the same way (regex-automata 0.4.19, `Utf8Compiler`).
//!
//! The forward program reads a sequence from its first octet, and the splitter gives the sequences
//! in that order. The reverse program reads a sequence from its last octet, so the sequences are
//! reversed and sorted first, in the storage past the program. No two sequences of a class take
//! the same octets, and none takes the start of another's, so the order of a node's transitions
//! chooses nothing.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const fragment = @import("../fragment.zig");
const program = @import("../program.zig");
const utf8_ranges = @import("../utf8_ranges.zig");
const Builder = fragment.Builder;
const Fragment = fragment.Fragment;
const Holes = fragment.Holes;
const Instruction = program.Instruction;
const OctetRange = utf8_ranges.OctetRange;
const ScalarRange = utf8_ranges.ScalarRange;
const Sequence = utf8_ranges.Sequence;
const node_file = @import("syntax_atom_utf8_node.zig");
const exit = node_file.exit;
const Transition = node_file.Transition;

/// A node the program holds, under the hash of its transitions: its entry, its first range, and its
/// count of transitions (syntax_atom_utf8_node.zig). A count of zero marks an empty slot.
const Slot = struct { hash: u32 = 0, entry: u32 = 0, ranges: u32 = 0, count: u32 = 0 };

const Error = fragment.Error;

comptime {
    // Forward, the open nodes never fill: the root holds one transition for each octet at most,
    // and each node under it one for each continuation octet.
    const continuations = constants.continuation_max - constants.continuation_min + 1;
    assert(constants.utf8_open_transitions_max >= constants.octet_values + (constants.utf8_len_max - 1) * continuations);
}

/// The fragment of a class whose ranges are in order and apart, which the builder's direction
/// reads. Null where a reverse class finds no room: its open nodes would hold more than
/// `utf8_open_transitions_max` transitions, or the storage past the program cannot hold its
/// sorted sequences and the program both. The caller then writes one alternative for each
/// sequence. Out of line, so that a class of few ranges does not pay for the frame.
pub noinline fn class(builder: *Builder, scalars: []const ScalarRange) fragment.Error!?Fragment {
    assert(scalars.len > 0);
    const begin = builder.len;
    var compiler: Compiler = .{ .builder = builder, .begin = begin };
    const built = switch (builder.direction) {
        .forward => compiler.forward(scalars),
        .reverse => compiler.reverse(scalars),
    };
    return built catch |err| {
        // Forward, only the storage can be full. In reverse, the sorted sequences took room that
        // the alternatives may fit in.
        if (builder.direction == .forward) return err;
        builder.truncate(begin);
        return null;
    };
}

const Compiler = struct {
    builder: *Builder,
    begin: u32,
    holes: Holes = .{},
    /// The transitions of the open nodes, the root's first: node `d`'s run from `starts[d]` to
    /// the next node's start.
    transitions: [constants.utf8_open_transitions_max]Transition = undefined,
    transitions_len: u32 = 0,
    starts: [constants.utf8_len_max]u32 = @splat(0),
    /// The last transition of each open node, which goes to the node after it, or for the
    /// deepest node to the class's end. Null at the root before the first sequence.
    lasts: [constants.utf8_len_max]?OctetRange = @splat(null),
    /// The open nodes: the root, and one for each range of the last sequence after its first.
    depth: u32 = 1,
    slots: [constants.utf8_node_slots]Slot = @splat(.{}),

    fn forward(compiler: *Compiler, scalars: []const ScalarRange) Error!Fragment {
        for (scalars) |range| {
            var splitter = utf8_ranges.Splitter.init(range.lo, range.hi);
            while (splitter.next()) |sequence| try compiler.add(sequence.ranges[0..sequence.len]);
        }
        return compiler.finish();
    }

    /// The sequences are written reversed at the storage's end, as keys, sorted, and read from
    /// there, while the program grows below them.
    fn reverse(compiler: *Compiler, scalars: []const ScalarRange) Error!Fragment {
        const builder = compiler.builder;
        const free = std.mem.sliceAsBytes(builder.instructions[builder.len..]);
        const capacity = free.len / @sizeOf(Key);
        const room = std.mem.bytesAsSlice(Key, free[0 .. capacity * @sizeOf(Key)]);
        // The keys fill the room from its end, so the program keeps the octets before them.
        var count: usize = 0;
        for (scalars) |range| {
            var splitter = utf8_ranges.Splitter.init(range.lo, range.hi);
            while (splitter.next()) |sequence| : (count += 1) {
                if (count == capacity) return error.NoSpaceLeft;
                room[capacity - 1 - count] = reversed_key(sequence);
            }
        }
        const keys = room[capacity - count ..];
        std.sort.pdq(Key, keys, {}, key_less);
        const sort_begin = builder.len + (capacity - count) * @sizeOf(Key) / @sizeOf(Instruction);
        var below: Builder = .{ .instructions = builder.instructions[0..sort_begin], .len = builder.len, .direction = builder.direction, .held = builder.held };
        compiler.builder = &below;
        defer builder.* = .{ .instructions = builder.instructions, .len = below.len, .direction = builder.direction, .held = below.held };
        for (keys) |key| {
            const sequence = sequence_of_key(key);
            try compiler.add(sequence.ranges[0..sequence.len]);
        }
        return compiler.finish();
    }

    fn add(compiler: *Compiler, ranges: []const OctetRange) Error!void {
        assert(ranges.len > 0 and ranges.len <= constants.utf8_len_max);
        var shared: u32 = 0;
        for (ranges[0..@min(ranges.len, compiler.depth)]) |range| {
            const last = compiler.lasts[shared] orelse break;
            if (last.lo != range.lo or last.hi != range.hi) break;
            shared += 1;
        }
        // No sequence of a class takes the start of another's, so each leaves the last one's path.
        assert(shared < ranges.len);
        try compiler.close_from(shared);
        compiler.lasts[shared] = ranges[shared];
        for (ranges[shared + 1 ..]) |range| {
            compiler.starts[compiler.depth] = compiler.transitions_len;
            compiler.lasts[compiler.depth] = range;
            compiler.depth += 1;
        }
        assert(compiler.depth == ranges.len);
    }

    /// Writes each open node deeper than `from`, the deepest first, and closes the last
    /// transition of node `from`.
    fn close_from(compiler: *Compiler, from: u32) Error!void {
        assert(from < compiler.depth);
        var next: u32 = exit;
        // Each turn writes one node, so the turns are at most `utf8_len_max`.
        for (0..constants.utf8_len_max) |_| {
            if (compiler.depth == from + 1) break;
            const node = compiler.depth - 1;
            try compiler.append(compiler.lasts[node].?, next);
            next = try compiler.write(compiler.starts[node]);
            compiler.transitions_len = compiler.starts[node];
            compiler.depth = node;
        }
        assert(compiler.depth == from + 1);
        if (compiler.lasts[from]) |last| {
            try compiler.append(last, next);
            compiler.lasts[from] = null;
        }
    }

    fn append(compiler: *Compiler, range: OctetRange, next: u32) Error!void {
        // Only a reverse root fills the open nodes (the comptime assert above).
        if (compiler.transitions_len == compiler.transitions.len) return error.NoSpaceLeft;
        compiler.transitions[compiler.transitions_len] = .{ .lo = range.lo, .hi = range.hi, .next = next };
        compiler.transitions_len += 1;
    }

    fn finish(compiler: *Compiler) Error!Fragment {
        try compiler.close_from(0);
        const entry = try compiler.write(0);
        assert(!compiler.holes.is_empty());
        return .{ .begin = compiler.begin, .entry = entry, .holes = compiler.holes, .nullable = false, .weight = 1 };
    }

    /// The entry of the node whose transitions run from `start` to the last: a node the program
    /// holds with the same transitions, or one written now.
    fn write(compiler: *Compiler, start: u32) fragment.Error!u32 {
        const node = compiler.transitions[start..compiler.transitions_len];
        assert(node.len > 0);
        const hash = hash_of(node);
        const home = hash & (constants.utf8_node_slots - 1);
        var free: ?u32 = null;
        for (0..constants.utf8_node_probes) |probe| {
            const index: u32 = @intCast((home + probe) & (constants.utf8_node_slots - 1));
            const slot = compiler.slots[index];
            if (slot.count == 0) {
                free = index;
                break;
            }
            if (slot.hash == hash and compiler.holds(slot, node)) return entry_of(slot);
        }
        const slot = try compiler.emit(node, hash);
        // A table with no free slot near home forgets the node there: a later equal node is
        // written again, which costs instructions and changes no match.
        compiler.slots[free orelse home] = slot;
        return entry_of(slot);
    }

    fn holds(compiler: *const Compiler, slot: Slot, node: []const Transition) bool {
        if (slot.count != node.len) return false;
        const ranges = compiler.builder.instructions[slot.ranges..][0..slot.count];
        for (node, ranges) |transition, instruction| {
            assert(instruction.kind == .range);
            if (instruction.lo != transition.lo or instruction.hi != transition.hi) return false;
            // A transition to the class's end is a hole, which no later step of the class fills.
            const leaves = instruction.out & constants.hole_flag != 0;
            if (leaves != (transition.next == exit)) return false;
            if (!leaves and instruction.out != transition.next) return false;
        }
        return true;
    }

    /// Writes a node: a `ranges` and its ranges where its transitions stand apart, and its ranges
    /// joined by splits where they overlap (syntax_atom_utf8_node.zig).
    fn emit(compiler: *Compiler, node: []const Transition, hash: u32) fragment.Error!Slot {
        const builder = compiler.builder;
        const count: u32 = @intCast(node.len);
        if (node_file.apart(node)) {
            const entry = try node_file.write_apart(builder, &compiler.holes, node);
            return .{ .hash = hash, .entry = entry, .ranges = entry + @intFromBool(count > 1), .count = count };
        }
        const ranges = builder.len;
        const entry = try node_file.write_split(builder, &compiler.holes, node);
        return .{ .hash = hash, .entry = entry, .ranges = ranges, .count = count };
    }
};

fn entry_of(slot: Slot) u32 {
    assert(slot.count > 0);
    return slot.entry;
}

fn hash_of(node: []const Transition) u32 {
    var value: u32 = constants.fnv_offset_basis;
    for (node) |transition| {
        value = (value ^ transition.lo) *% constants.fnv_prime;
        value = (value ^ transition.hi) *% constants.fnv_prime;
        value = (value ^ transition.next) *% constants.fnv_prime;
    }
    return value;
}

/// A reversed sequence as one number: its ranges in the reverse program's order, each its first
/// octet and its last, from the most significant octets down, and zero past its last range. The
/// numbers sort as the reverse program's nodes take the sequences. Only the sequence of U+0000
/// holds a range of two zeros, and it holds one range alone, so a key gives back its length.
/// The storage past the program is aligned for instructions, so a key's number is too.
const Key = extern struct { bits: u64 align(@alignOf(Instruction)) };

fn key_less(_: void, left: Key, right: Key) bool {
    return left.bits < right.bits;
}

/// The bits of one octet, and of one range, its first octet and its last, in a key.
const octet_bits = @bitSizeOf(u8);
const key_range_bits = @bitSizeOf(OctetRange);

fn reversed_key(sequence: Sequence) Key {
    assert(sequence.len > 0 and sequence.len <= constants.utf8_len_max);
    var key: u64 = 0;
    for (0..sequence.len) |taken| {
        const range = sequence.ranges[sequence.len - 1 - taken];
        const shift: u6 = @intCast(key_range_bits * (constants.utf8_len_max - 1 - taken));
        key |= (@as(u64, range.lo) << octet_bits | range.hi) << shift;
    }
    return .{ .bits = key };
}

fn sequence_of_key(key: Key) Sequence {
    var sequence: Sequence = .{ .ranges = undefined, .len = 0 };
    for (0..constants.utf8_len_max) |place| {
        const shift: u6 = @intCast(key_range_bits * (constants.utf8_len_max - 1 - place));
        const bits: u16 = @truncate(key.bits >> shift);
        // Every range past the first takes octets of 0x80 and over.
        if (place > 0 and bits == 0) break;
        sequence.ranges[place] = .{ .lo = @intCast(bits >> octet_bits), .hi = @truncate(bits) };
        sequence.len += 1;
    }
    return sequence;
}

const testing = std.testing;

test "a written node holds only transitions with its own octets and targets" {
    var storage: [constants.utf8_len_max * constants.utf8_len_max]Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    var compiler: Compiler = .{ .builder = &builder, .begin = 0 };
    const target = try builder.emit(.{ .kind = .fail });
    const other = try builder.emit(.{ .kind = .fail });
    const node = [_]Transition{
        .{ .lo = 'a', .hi = 'a', .next = exit },
        .{ .lo = constants.continuation_min, .hi = constants.continuation_max, .next = target },
    };
    const slot = try compiler.emit(&node, hash_of(&node));
    try testing.expect(compiler.holds(slot, &node));
    var moved = node;
    moved[1].next = other;
    try testing.expect(!compiler.holds(slot, &moved));
    var leaves = node;
    leaves[1].next = exit;
    try testing.expect(!compiler.holds(slot, &leaves));
    var stays = node;
    stays[0].next = target;
    try testing.expect(!compiler.holds(slot, &stays));
    var narrower = node;
    narrower[1].hi = constants.continuation_max - 1;
    try testing.expect(!compiler.holds(slot, &narrower));
    try testing.expect(!compiler.holds(slot, node[0..1]));
}

test {
    _ = @import("syntax_atom_utf8_test.zig");
}
