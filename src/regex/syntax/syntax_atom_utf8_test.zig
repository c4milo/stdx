//! The tests of syntax_atom_utf8.zig: a class's automaton takes the octets its alternatives take,
//! in both directions, and is smaller than they are.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const unicode = @import("unicode");
const utf8 = @import("utf8");
const constants = @import("../constants.zig");
const fragment = @import("../fragment.zig");
const program = @import("../program.zig");
const utf8_ranges = @import("../utf8_ranges.zig");
const atom = @import("syntax_atom.zig");
const compact = @import("syntax_atom_utf8.zig");
const Builder = fragment.Builder;
const Direction = fragment.Direction;
const Fragment = fragment.Fragment;
const Instruction = program.Instruction;
const ScalarRange = utf8_ranges.ScalarRange;

/// The instructions of the largest program a test writes, the sorted sequences included.
const storage_len = 8192;

/// The step between the scalar values past U+07FF whose UTF-8 a test gives each program: a prime,
/// so that the values fall on every offset of a continuation octet.
const scalar_step = 101;

/// The texts of random octets a test gives each program, and their longest length.
const random_texts = 4000;
const random_len_max = 4;

/// One program of a class, in storage of its own.
const Built = struct {
    storage: [storage_len]Instruction = undefined,
    entry: u32 = 0,
    len: u32 = 0,
    direction: Direction = .forward,

    fn instructions(built: *const Built) []const Instruction {
        return built.storage[0..built.len];
    }
};

/// The class's automaton, or its alternatives where `alternatives` asks for them.
fn build(built: *Built, scalars: []const ScalarRange, direction: Direction, alternatives: bool) !void {
    var builder: Builder = .{ .instructions = &built.storage, .direction = direction };
    const whole: Fragment = if (alternatives) try atom.alternatives(&builder, scalars) else (try compact.class(&builder, scalars)).?;
    built.* = .{ .storage = built.storage, .entry = whole.entry, .len = builder.len, .direction = direction };
}

/// The lists a walk of a program keeps: each instruction visited in the walk's current step is
/// marked with the step's generation, so no list is cleared between steps.
const Walk = struct {
    mark: [storage_len]u32 = @splat(0),
    generation: u32 = 0,
    stack: [storage_len]u32 = undefined,
    threads: [storage_len]u32 = undefined,
    seeds: [storage_len]u32 = undefined,

    /// True when the program takes all of `text`, read in its direction, and then leaves the
    /// class through a hole.
    fn accepts(walk: *Walk, built: *const Built, text: []const u8) bool {
        const instructions = built.instructions();
        var seeds_len: usize = 1;
        walk.seeds[0] = built.entry;
        for (0..text.len) |taken| {
            const octet = if (built.direction == .forward) text[taken] else text[text.len - 1 - taken];
            const threads_len = walk.close(instructions, walk.seeds[0..seeds_len]);
            seeds_len = 0;
            var left = false;
            for (walk.threads[0..threads_len]) |index| {
                const next = program.step(instructions, index, octet) orelse continue;
                if (next & constants.hole_flag != 0) {
                    left = true;
                    continue;
                }
                walk.seeds[seeds_len] = next;
                seeds_len += 1;
            }
            if (taken == text.len - 1) return left;
        }
        return false;
    }

    /// The ranges the seeds reach through splits, each once.
    fn close(walk: *Walk, instructions: []const Instruction, seeds: []const u32) usize {
        walk.generation += 1;
        var threads_len: usize = 0;
        var stack_len: usize = 0;
        for (seeds) |seed| {
            walk.stack[stack_len] = seed;
            stack_len += 1;
        }
        // Each turn pops one instruction, and each is pushed once for each split that names it.
        for (0..constants.targets_per_instruction * instructions.len + seeds.len) |_| {
            if (stack_len == 0) break;
            stack_len -= 1;
            const index = walk.stack[stack_len];
            if (walk.mark[index] == walk.generation) continue;
            walk.mark[index] = walk.generation;
            const instruction = instructions[index];
            switch (instruction.kind) {
                .range, .ranges => {
                    walk.threads[threads_len] = index;
                    threads_len += 1;
                },
                .split => {
                    walk.stack[stack_len] = instruction.arg;
                    walk.stack[stack_len + 1] = instruction.out;
                    stack_len += constants.targets_per_instruction;
                },
                else => unreachable,
            }
        }
        return threads_len;
    }
};

fn holds(scalars: []const ScalarRange, scalar: u32) bool {
    for (scalars) |range| {
        if (scalar >= range.lo and scalar <= range.hi) return true;
    }
    return false;
}

/// The bits of a draw that choose whether an octet after a text's first is any octet, one time in
/// four, or a continuation octet, so that many texts are UTF-8 or close to it.
const choice_bits = 2;
const choice_mask = (1 << choice_bits) - 1;

/// The seed of the random texts.
const random_seed = 0x07F8;

fn random_octet(generator: *codec.testing.split.Generator, first: bool) u8 {
    const draw = generator.next();
    const rest = draw >> choice_bits;
    if (first or draw & choice_mask == 0) return @truncate(rest);
    return @intCast(constants.continuation_min + rest % (constants.continuation_max - constants.continuation_min + 1));
}

/// Requires the automaton and the alternatives of a class to take the same texts in `direction`:
/// the UTF-8 of each scalar value up to U+07FF and of every `scalar_step`th past it, and texts of
/// random octets, many of them no UTF-8.
fn expect_same_texts(scalars: []const ScalarRange, direction: Direction) !void {
    var automaton: Built = .{};
    var alternatives: Built = .{};
    try build(&automaton, scalars, direction, false);
    try build(&alternatives, scalars, direction, true);
    var walk: Walk = .{};
    var octets: [constants.utf8_len_max]u8 = undefined;
    var scalar: u32 = 0;
    // Each turn moves on by one value or by `scalar_step`, so the turns are at most the values.
    for (0..constants.scalar_max + 1) |_| {
        if (scalar > constants.scalar_max) break;
        if (!utf8_ranges.is_surrogate(scalar)) {
            const len = utf8.encoded_len(@intCast(scalar));
            utf8.encode(@intCast(scalar), octets[0..len]);
            const expected = holds(scalars, scalar);
            try testing.expectEqual(expected, walk.accepts(&alternatives, octets[0..len]));
            try testing.expectEqual(expected, walk.accepts(&automaton, octets[0..len]));
        }
        scalar += if (scalar < constants.two_octets_max) 1 else scalar_step;
    }
    var generator = codec.testing.split.Generator.init(random_seed);
    var text: [random_len_max]u8 = undefined;
    for (0..random_texts) |_| {
        const len = 1 + generator.next() % random_len_max;
        for (text[0..len], 0..) |*octet, index| octet.* = random_octet(&generator, index == 0);
        try testing.expectEqual(walk.accepts(&alternatives, text[0..len]), walk.accepts(&automaton, text[0..len]));
    }
}

const directions = [_]Direction{ .forward, .reverse };

/// The first and the last scalar value of a class of one value in every `sparse_step`: a range
/// of values apart from each other, whose UTF-8 is two and three octets.
const sparse_first = 0x80;
const sparse_last = 0x1000;
const sparse_step = 3;
const sparse_count = (sparse_last - sparse_first) / sparse_step;

test "a class's automaton takes the texts its alternatives take, in both directions" {
    // A class of every length of UTF-8, U+0000 among its values: the one sequence whose range
    // is two zeros.
    const mixed = [_]ScalarRange{
        .{ .lo = 0, .hi = 0 },
        .{ .lo = 'A', .hi = 'Z' },
        .{ .lo = 0x100, .hi = 0x17F },
        .{ .lo = 0x800, .hi = 0x8FF },
        .{ .lo = 0x3000, .hi = 0x3003 },
        .{ .lo = 0xE000, .hi = 0xE0FF },
        .{ .lo = 0x10000, .hi = 0x100FF },
        .{ .lo = 0x10FF00, .hi = 0x10FFFF },
    };
    var sparse: [sparse_count]ScalarRange = undefined;
    for (&sparse, 0..) |*range, index| {
        const value: u32 = @intCast(sparse_first + sparse_step * index);
        range.* = .{ .lo = value, .hi = value };
    }
    for (directions) |direction| {
        try expect_same_texts(&mixed, direction);
        try expect_same_texts(unicode.property("L").?, direction);
        try expect_same_texts(unicode.property("Nd").?, direction);
        try expect_same_texts(unicode.property("Greek").?, direction);
        try expect_same_texts(&sparse, direction);
    }
}

/// The automaton of `\p{L}` takes under `size_numerator / size_denominator` of the instructions
/// of its alternatives in each direction. The reverse program keeps that only where equal nodes
/// are written once: a trie of the sequences alone takes 0.87 of them.
const size_numerator = 3;
const size_denominator = 5;

test "forward, a node of \\p{L} is a ranges; read back, its root, whose ranges overlap, is splits" {
    var automaton: Built = .{};
    try build(&automaton, unicode.property("L").?, .forward, false);
    try testing.expectEqual(program.Kind.ranges, automaton.instructions()[automaton.entry].kind);
    try build(&automaton, unicode.property("L").?, .reverse, false);
    try testing.expectEqual(program.Kind.split, automaton.instructions()[automaton.entry].kind);
}

test "the automaton of \\p{L} takes under three fifths of the instructions of its alternatives" {
    var automaton: Built = .{};
    var alternatives: Built = .{};
    for (directions) |direction| {
        try build(&automaton, unicode.property("L").?, direction, false);
        try build(&alternatives, unicode.property("L").?, direction, true);
        try testing.expect(automaton.len * size_denominator < alternatives.len * size_numerator);
    }
}

/// Blocks of `block_len` scalar values from U+1000 on, each holding one range whose first and
/// last continuation octet no other block's range shares: the reverse program's root would take
/// one transition for each block.
const distinct_blocks = 768;
const distinct_first = 0x1000;
const block_len = 64;
const distinct_offsets = 48;

fn distinct_last_octets(ranges: *[distinct_blocks]ScalarRange) void {
    for (ranges, 0..) |*range, block| {
        const base: u32 = @intCast(distinct_first + block * block_len);
        const lo: u32 = @intCast(block % distinct_offsets);
        const len: u32 = @intCast(block / distinct_offsets);
        range.* = .{ .lo = base + lo, .hi = base + lo + len };
    }
}

test "a class whose reverse root would hold too many transitions takes its alternatives" {
    var ranges: [distinct_blocks]ScalarRange = undefined;
    distinct_last_octets(&ranges);
    try testing.expect(distinct_blocks > constants.utf8_open_transitions_max);
    var built: Built = .{};
    var builder: Builder = .{ .instructions = &built.storage, .direction = .reverse };
    _ = try builder.emit(.{ .kind = .fail });
    try testing.expectEqual(null, try compact.class(&builder, &ranges));
    try testing.expectEqual(1, builder.len);
    // Forward, the root takes the leading octets, and the class is one automaton.
    builder = .{ .instructions = &built.storage, .direction = .forward };
    try testing.expect(try compact.class(&builder, &ranges) != null);
}

/// Storage under the sequences of `\p{Greek}`, and storage that holds them and too few
/// instructions past them for the class's automaton.
const no_sort_room = 16;
const little_room = 64;

/// The instructions a program holds before the class, which the class must leave as they are.
const written_before = 40;

test "a reverse class with too little room past its program takes its alternatives" {
    const greek = unicode.property("Greek").?;
    var storage: [little_room]Instruction = undefined;
    for ([_]usize{ no_sort_room, little_room }) |room| {
        var builder: Builder = .{ .instructions = storage[0..room], .direction = .reverse };
        try testing.expectEqual(null, try compact.class(&builder, greek));
        try testing.expectEqual(0, builder.len);
    }
    // The sequences would fit in the storage, but not past the program: the sort writes nothing.
    var builder: Builder = .{ .instructions = &storage, .direction = .reverse };
    for (0..written_before) |_| _ = try builder.emit(.{ .kind = .match });
    try testing.expectEqual(null, try compact.class(&builder, greek));
    try testing.expectEqual(written_before, builder.len);
    for (storage[0..written_before]) |instruction| try testing.expectEqual(program.Kind.match, instruction.kind);
    // Forward, the program grows in the storage alone, which is too small.
    builder = .{ .instructions = &storage, .direction = .forward };
    try testing.expectError(error.NoSpaceLeft, compact.class(&builder, greek));
}

/// A class's program as the parser writes it, from `atom.class`.
fn class_program(built: *Built, scalars: []const ScalarRange) !void {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = @import("../scalar_set.zig").ScalarSet.init(&set_storage);
    for (scalars) |range| try set.add(range.lo, range.hi);
    set.normalize();
    var builder: Builder = .{ .instructions = &built.storage, .direction = .forward };
    built.entry = (try atom.class(&builder, &set)).entry;
    built.len = builder.len;
}

/// The first scalar value of a class of `utf8_compact_ranges_min` ranges past U+007F, a value
/// apart from the next.
const routed_first = 0x100;

test "a class of utf8_compact_ranges_min ranges or more, one past U+007F, is one automaton" {
    var ranges: [constants.utf8_compact_ranges_min]ScalarRange = undefined;
    // An ASCII range first: the class is routed by its last range, which is past U+007F.
    ranges[0] = .{ .lo = 'a', .hi = 'z' };
    for (ranges[1..], 1..) |*range, index| {
        const value: u32 = @intCast(routed_first + 2 * index);
        range.* = .{ .lo = value, .hi = value };
    }
    var parsed: Built = .{};
    var automaton: Built = .{};
    var alternatives: Built = .{};
    try class_program(&parsed, &ranges);
    try build(&automaton, &ranges, .forward, false);
    try build(&alternatives, &ranges, .forward, true);
    try testing.expectEqualSlices(Instruction, automaton.instructions(), parsed.instructions());
    // One range fewer: the alternatives.
    try class_program(&parsed, ranges[0 .. ranges.len - 1]);
    try build(&alternatives, ranges[0 .. ranges.len - 1], .forward, true);
    try testing.expectEqualSlices(Instruction, alternatives.instructions(), parsed.instructions());
    // Every range of one octet: no automaton, whatever the count, but one node of the ranges
    // (syntax_atom_ranges.zig).
    var ascii: [constants.utf8_compact_ranges_min]ScalarRange = undefined;
    for (&ascii, 0..) |*range, index| {
        const value: u32 = @intCast('a' + 2 * index);
        range.* = .{ .lo = value, .hi = value };
    }
    try class_program(&parsed, &ascii);
    const head = parsed.instructions()[0];
    try testing.expectEqual(program.Kind.ranges, head.kind);
    try testing.expectEqual(@as(u32, ascii.len), head.arg);
}

test "a reverse class whose program would reach its sorted sequences takes its alternatives" {
    const greek = unicode.property("Greek").?;
    var roomy: Built = .{};
    try build(&roomy, greek, .reverse, false);
    // Room for the program and one more instruction, under the room its sequences take besides.
    var storage: [storage_len]Instruction = undefined;
    var builder: Builder = .{ .instructions = storage[0 .. roomy.len + 1], .direction = .reverse };
    try testing.expectEqual(null, try compact.class(&builder, greek));
    try testing.expectEqual(0, builder.len);
}
