//! Claim R6's table (decision 86 as amended): for each seed of a one-pass program and each class
//! of octets, what the seed's thread does with an octet of the class. A seed is an instruction a
//! thread starts a position from: the program's entry, or the target of a range. An entry holds
//! the row of the seed the thread goes on to and the slots its path saves, or says the thread
//! matches or ends. RE2 and Rust's crate keep the same table, their one-pass DFA (Cox, "Regular
//! Expression Matching in the Wild", 2010).
//!
//! The table takes the matcher's two tables of slots, which a one-pass search does not read. Only
//! the matcher's own search and the backtracker write them, and each sets
//! `Matcher.one_pass_table` back to `none`: the next search then builds the table again. Its
//! entries start unknown, and a search fills each one the first time it needs it, by the paths
//! `one_pass.follow` takes. An entry whose paths pass an assertion depends on the octets around
//! the position, so it keeps the contexts behind and ahead that it was filled for, and a search
//! fills it again where it meets other contexts.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Context = program_file.Context;
const matcher_file = @import("matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;
const one_pass = @import("one_pass.zig");

/// The slots an entry's mask holds, its low bits: a program of more keeps no table.
const mask_bits = @bitSizeOf(u32);

/// The bits of an entry's kind, at its top, and below them the contexts behind and ahead that an
/// entry whose paths pass an assertion was filled for. The bits between the mask and the
/// contexts hold the first entry of the next seed's row.
const kind_bits = 3;
const kind_shift = @bitSizeOf(u64) - kind_bits;
const context_bits = 2;
/// The bits of the two contexts, behind and then ahead.
const contexts_bits = context_bits + context_bits;
const contexts_shift = kind_shift - contexts_bits;
const contexts_mask = (1 << contexts_bits) - 1;
const next_mask = (@as(u64, 1) << (contexts_shift - mask_bits)) - 1;

/// What an entry says. A table starts with every entry zero, so `unknown`. The kinds from
/// `took_looked` on say the same as the three before them, for their contexts alone.
const Kind = enum(u3) { unknown, took, matched, dead, took_looked, matched_looked, dead_looked };

/// What a thread does with an octet, whatever the entry's contexts.
const Outcome = enum { took, matched, dead };

/// The row of an instruction that is no seed.
const no_row = std.math.maxInt(u16);

comptime {
    // A row number fits the map from instructions to rows, and a row's first entry its field.
    assert(constants.one_pass_instructions_max < no_row);
    assert(@typeInfo(Kind).@"enum".fields.len <= 1 << kind_bits);
    assert(@typeInfo(Context).@"enum".fields.len <= 1 << context_bits);
}

/// The table in the matcher's tables of slots: the row of each instruction, the seed of each
/// row, and the entries, a row of `columns` for each seed. The last column is the text's end.
pub const Table = struct {
    rows_of: []u16,
    seeds: []u32,
    entries: []u64,
    columns: u32,

    fn base_of(table: Table, seed: u32) u32 {
        assert(table.rows_of[seed] != no_row);
        return table.rows_of[seed] * table.columns;
    }

    fn seed_at(table: Table, base: u32) u32 {
        return table.seeds[base / table.columns];
    }
};

/// The table of the matcher's program, built where the tables of slots do not hold it. Null
/// where the program keeps more slots than a mask holds, or its table does not fit.
pub fn prepare(matcher: *Matcher) ?Table {
    if (matcher.one_pass_table == .absent) return null;
    const table = layout(matcher) orelse return absent(matcher);
    if (matcher.one_pass_table == .none) {
        if (!build(matcher, table)) return absent(matcher);
        matcher.one_pass_table = .held;
    }
    return table;
}

fn absent(matcher: *Matcher) ?Table {
    matcher.one_pass_table = .absent;
    return null;
}

/// The table's place in the matcher's two tables of slots, which the matcher takes one after the
/// other.
fn layout(matcher: *Matcher) ?Table {
    if (matcher.slots_len > mask_bits) return null;
    const count: usize = matcher.program.forward_len;
    assert(count <= constants.one_pass_instructions_max);
    assert(matcher.seed_slots.ptr + matcher.seed_slots.len == matcher.thread_slots.ptr);
    const words = matcher.seed_slots.ptr[0 .. matcher.seed_slots.len + matcher.thread_slots.len];
    const rows_of_words = words_for(count * @sizeOf(u16));
    const seeds_words = words_for(count * @sizeOf(u32));
    if (words.len <= rows_of_words + seeds_words) return null;
    return .{
        .rows_of = std.mem.bytesAsSlice(u16, std.mem.sliceAsBytes(words[0..rows_of_words]))[0..count],
        .seeds = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(words[rows_of_words..][0..seeds_words]))[0..count],
        .entries = words[rows_of_words + seeds_words ..],
        .columns = @as(u32, matcher.program.class_count) + 1,
    };
}

fn words_for(octets: usize) usize {
    return (octets + @sizeOf(u64) - 1) / @sizeOf(u64);
}

/// Gives each seed a row and makes each entry unknown. False where the rows do not fit.
fn build(matcher: *const Matcher, table: Table) bool {
    @memset(table.rows_of, no_row);
    var rows = add_row(table, matcher.program.forward, 0);
    for (matcher.program.instructions[0..matcher.program.forward_len]) |instruction| {
        if (instruction.kind == .range) rows = add_row(table, instruction.out, rows);
    }
    const entries_len = @as(usize, rows) * table.columns;
    if (entries_len > table.entries.len) return false;
    @memset(table.entries[0..entries_len], 0);
    return true;
}

fn add_row(table: Table, seed: u32, rows: u32) u32 {
    if (table.rows_of[seed] != no_row) return rows;
    table.rows_of[seed] = @intCast(rows);
    table.seeds[rows] = seed;
    return rows + 1;
}

fn make(kind: Kind, contexts: u4, mask: u32, next: u32) u64 {
    assert(next <= next_mask);
    return @as(u64, @intFromEnum(kind)) << kind_shift | @as(u64, contexts) << contexts_shift | @as(u64, next) << mask_bits | mask;
}

fn kind_of(entry: u64) Kind {
    return @enumFromInt(entry >> kind_shift);
}

fn is_looked(entry: u64) bool {
    return @intFromEnum(kind_of(entry)) >= @intFromEnum(Kind.took_looked);
}

fn outcome_of(entry: u64) Outcome {
    return switch (kind_of(entry)) {
        .took, .took_looked => .took,
        .matched, .matched_looked => .matched,
        .dead, .dead_looked => .dead,
        .unknown => unreachable,
    };
}

fn contexts_of(entry: u64) u4 {
    return @intCast(entry >> contexts_shift & contexts_mask);
}

/// The contexts behind and ahead of the position `index`, as one entry keeps them.
fn contexts_at(haystack: []const u8, index: usize) u4 {
    const behind: Context = if (index == 0) .edge else Context.of(haystack[index - 1]);
    const ahead: Context = if (index == haystack.len) .edge else Context.of(haystack[index]);
    return @intCast(@as(u8, @intFromEnum(behind)) << context_bits | @intFromEnum(ahead));
}

fn mask_of(entry: u64) u32 {
    return @truncate(entry);
}

fn next_of(entry: u64) u32 {
    return @intCast(entry >> mask_bits & next_mask);
}

/// `one_pass.find` from `from`, by the table, once the matcher has started there with its slots
/// unset.
pub fn run(table: Table, matcher: *Matcher, haystack: []const u8, from: usize) ?Span {
    var at: At = .{ .base = table.base_of(matcher.program.forward), .index = from };
    // Each turn takes one octet at least, or ends the search: at most the octets from `from` and
    // one. No entry takes an octet at the text's end.
    for (from..haystack.len + 1) |_| {
        switch (turn(table, matcher, haystack, at)) {
            .next => |next| at = next,
            .done => |matched| return one_pass.finish(matcher, matched),
        }
    }
    unreachable;
}

/// A thread of `run`: the first entry of its seed's row, and the offset of its next octet.
const At = struct { base: u32, index: usize };

/// What one turn of `run` gave: the thread at the next octet, or whether the search matched.
const Turn = union(enum) { next: At, done: bool };

/// The entry of the octet at `at`, filled where it is unknown, and what it says.
inline fn turn(table: Table, matcher: *Matcher, haystack: []const u8, at: At) Turn {
    const octet: ?u8 = if (at.index < haystack.len) haystack[at.index] else null;
    const column = if (octet) |known| matcher.program.classes[known] else table.columns - 1;
    const place = at.base + column;
    var entry = table.entries[place];
    if (kind_of(entry) == .unknown or (is_looked(entry) and contexts_of(entry) != contexts_at(haystack, at.index))) {
        entry = fill(table, matcher, place, octet, contexts_at(haystack, at.index));
    }
    switch (outcome_of(entry)) {
        .took => return .{ .next = took(table, matcher, haystack, at, place) },
        .matched => {
            save(matcher, entry, at.index);
            return .{ .done = true };
        },
        .dead => return .{ .done = false },
    }
}

/// The thread after the entry at `place` took the octet at `at`. A loop of the row takes the
/// octets after it at once.
inline fn took(table: Table, matcher: *Matcher, haystack: []const u8, at: At, place: u32) At {
    const entry = table.entries[place];
    save(matcher, entry, at.index);
    const next = next_of(entry);
    var index = at.index + 1;
    // An entry of other contexts would repeat for octets whose contexts it was not filled for.
    if (next == at.base and mask_of(entry) == 0 and !is_looked(entry)) index = loop_end(table, &matcher.program.classes, haystack, index, place);
    return .{ .base = next, .index = index };
}

/// Writes the position into each slot of the entry's mask.
fn save(matcher: *Matcher, entry: u64, position: usize) void {
    var mask = mask_of(entry);
    const slots = matcher.current();
    // One turn for each slot of the mask, at most `mask_bits`.
    while (mask != 0) : (mask &= mask - 1) slots[@ctz(mask)] = position;
}

/// Where a row's loop stops: the first octet from `from` whose entry is not the one at `place`,
/// which takes the octet back to its own row and saves no slot. Each entry the loop reads waits on
/// no octet before.
fn loop_end(table: Table, classes: *const [constants.octet_values]u8, haystack: []const u8, from: usize, place: u32) usize {
    const entry = table.entries[place];
    const base = place - place % table.columns;
    for (haystack[from..], from..) |octet, index| {
        if (table.entries[base + classes[octet]] != entry) return index;
    }
    return haystack.len;
}

/// Fills the entry at `place` for `octet`, under the contexts around its position, and gives it.
fn fill(table: Table, matcher: *Matcher, place: u32, octet: ?u8, contexts: u4) u64 {
    var walk: Closure = .{ .table = table, .matcher = matcher, .octet = octet, .contexts = contexts };
    const entry = walk.entry(table.seed_at(place - place % table.columns));
    assert(kind_of(entry) != .unknown);
    table.entries[place] = entry;
    return entry;
}

/// The walk that fills an entry: the paths from a seed in the matcher's order, as
/// `one_pass.follow` takes them, each instruction once, each assertion judged in `contexts`.
const Closure = struct {
    table: Table,
    matcher: *Matcher,
    octet: ?u8,
    contexts: u4,
    /// True once a path met an assertion, so that the entry holds for `contexts` alone.
    looked: bool = false,

    fn entry(walk: *Closure, seed: u32) u64 {
        const matcher = walk.matcher;
        matcher.visited.clear();
        matcher.stack[0] = seed;
        matcher.stack_values[0] = 0;
        var stack_len: u32 = 1;
        // Each instruction starts a path once.
        while (stack_len > 0) {
            assert(stack_len <= matcher.program.forward_len);
            stack_len -= 1;
            const first = matcher.stack[stack_len];
            const mask: u32 = @intCast(matcher.stack_values[stack_len]);
            if (path(walk, first, mask, &stack_len)) |found| return found;
        }
        return walk.make_of(.dead, 0, 0);
    }

    /// An entry of `outcome`, of the kind that keeps the contexts where a path met an assertion.
    fn make_of(walk: *const Closure, outcome: Outcome, mask: u32, next: u32) u64 {
        const plain: Kind = switch (outcome) {
            .took => .took,
            .matched => .matched,
            .dead => .dead,
        };
        if (!walk.looked) return make(plain, 0, mask, next);
        return make(@enumFromInt(@intFromEnum(plain) + @intFromEnum(Kind.took_looked) - @intFromEnum(Kind.took)), walk.contexts, mask, next);
    }

    fn holds(walk: *const Closure, look: program_file.Look) bool {
        const behind: Context = @enumFromInt(walk.contexts >> context_bits);
        const ahead: Context = @enumFromInt(walk.contexts & ((1 << context_bits) - 1));
        return look.holds(behind, ahead);
    }
};

/// One path from `first`, whose saves so far are `saved`: its entry where it matches or takes
/// the octet, or null where it ends. A split pushes its other branch.
fn path(walk: *Closure, first: u32, saved: u32, stack_len: *u32) ?u64 {
    const matcher = walk.matcher;
    const instructions = matcher.program.instructions;
    var index = first;
    var mask = saved;
    // Each instruction is visited once at most.
    for (0..matcher.program.forward_len) |_| {
        if (!matcher.visited.insert(index)) return null;
        const instruction = instructions[index];
        switch (instruction.kind) {
            .save => if (instruction.arg < matcher.slots_len) {
                mask |= @as(u32, 1) << @intCast(instruction.arg);
            },
            .jump => {},
            .split => {
                matcher.stack[stack_len.*] = instruction.arg;
                matcher.stack_values[stack_len.*] = mask;
                stack_len.* += 1;
            },
            // An assertion holds in some contexts and not in others: the entry keeps its own.
            .look => {
                walk.looked = true;
                if (!walk.holds(instruction.look)) return null;
            },
            .range, .ranges => {
                const next = program_file.step(instructions, index, walk.octet orelse return null) orelse return null;
                return walk.make_of(.took, mask, walk.table.base_of(next));
            },
            .match => return walk.make_of(.matched, mask, 0),
            .fail => return null,
        }
        index = instruction.out;
    }
    return null;
}

const testing = std.testing;
const compiler = @import("compile.zig");
const backtrack = @import("backtrack.zig");

/// The instructions and the matcher's words a test's pattern takes at most.
const test_storage_len = 1024;
const test_memory_len = 1 << test_memory_bits;
/// The words of a test matcher's memory, as a power of two.
const test_memory_bits = 14;

/// A one-pass program, a matcher whose search goes through one-pass, and one that is the
/// reference, each keeping every group's slots, anchored.
const Fixture = struct {
    storage: [test_storage_len]program_file.Instruction = undefined,
    memory: [test_memory_len]u64 = undefined,
    reference_memory: [test_memory_len]u64 = undefined,
    program: program_file.Program = undefined,
    matcher: Matcher = undefined,
    reference: Matcher = undefined,

    fn init(fixture: *Fixture, pattern: []const u8) !void {
        fixture.program = try compiler.compile(pattern, .{}, &fixture.storage);
        const len = Matcher.memory_len(fixture.program.forward_len, fixture.program.slot_count());
        const options: matcher_file.Options = .{ .captures = .groups, .anchored = true };
        fixture.matcher.init(&fixture.program, options, fixture.memory[0..len]);
        fixture.reference.init(&fixture.program, options, fixture.reference_memory[0..len]);
        try testing.expect(one_pass.check(&fixture.matcher));
    }

    /// One-pass gives the reference's match and groups in `text` from 0.
    fn expect_agree(fixture: *Fixture, text: []const u8) !void {
        const expected = fixture.reference.find(text, 0);
        try testing.expectEqual(expected, one_pass.find(&fixture.matcher, text, 0));
        if (expected == null) return;
        for (0..fixture.program.group_count) |group| {
            try testing.expectEqual(fixture.reference.group(@intCast(group)), fixture.matcher.group(@intCast(group)));
        }
    }
};

test "the matcher's own search and the backtracker leave no table, and the next search builds one" {
    var fixture: Fixture = .{};
    try fixture.init("([a-z]+)@([a-z]+)\\.(com|org)");
    try fixture.expect_agree("ab@cd.com");
    try testing.expectEqual(matcher_file.OnePassTable.held, fixture.matcher.one_pass_table);
    // Each writes the tables of slots that hold the table.
    try testing.expect(fixture.matcher.find("zz@ww.org", 0) != null);
    try testing.expectEqual(matcher_file.OnePassTable.none, fixture.matcher.one_pass_table);
    try fixture.expect_agree("x@y.org");
    try fixture.expect_agree("x@yy.net");
    try testing.expectEqual(matcher_file.OnePassTable.held, fixture.matcher.one_pass_table);
    const text = "qq@r.com";
    try testing.expect(backtrack.find(&fixture.matcher, text, 0, text.len) != null);
    try testing.expectEqual(matcher_file.OnePassTable.none, fixture.matcher.one_pass_table);
    try fixture.expect_agree("abc@de.com");
    try fixture.expect_agree("abc@de.co");
}

test "a program of more slots than a mask holds, or whose table does not fit, keeps no table" {
    var fixture: Fixture = .{};
    // Seventeen groups, the whole match's among them: 34 slots.
    try fixture.init("(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)");
    try fixture.expect_agree("abcdefghijklmnop");
    try fixture.expect_agree("abcdefghijklmnoq");
    try testing.expectEqual(matcher_file.OnePassTable.absent, fixture.matcher.one_pass_table);
    // Two groups and 21 classes: a row of 22 entries for each of 11 seeds, where the tables of
    // slots hold 4 words for each of some 20 instructions.
    try fixture.init("([a-b][c-d][e-f][g-h][i-j][k-l][m-n][o-p][q-r][s-t])");
    try fixture.expect_agree("acegikmoqs");
    try fixture.expect_agree("acegikmoqz");
    try testing.expectEqual(matcher_file.OnePassTable.absent, fixture.matcher.one_pass_table);
}

test "the entries a search filled serve the next search, and each kind gives the matcher's answer" {
    var fixture: Fixture = .{};
    // A loop, saves on a choice's way out, an assertion and a match at the text's end.
    try fixture.init("([0-9]+)-(x|yz)?\\b([ab]*)$");
    const texts = [_][]const u8{ "12-x", "12-yzab", "1-", "1-yzba", "12-", "-x", "12-xa", "1-ybz", "9-yz-" };
    for (0..2) |_| {
        for (texts) |text| try fixture.expect_agree(text);
    }
    try testing.expectEqual(matcher_file.OnePassTable.held, fixture.matcher.one_pass_table);
    const table = prepare(&fixture.matcher).?;
    var rows: usize = 0;
    for (table.rows_of) |row| rows += @intFromBool(row != no_row);
    var filled: usize = 0;
    var looked: usize = 0;
    for (table.entries[0 .. rows * table.columns]) |entry| {
        filled += @intFromBool(kind_of(entry) != .unknown);
        looked += @intFromBool(kind_of(entry) != .unknown and is_looked(entry));
    }
    try testing.expect(filled > 0 and looked > 0);
}

test "the text's end has a column of its own, apart from the first class's" {
    var fixture: Fixture = .{};
    // The first class holds octet 0, which the loop takes, and the loop ends at the text's end.
    try fixture.init("([\\x00-a]*)$");
    for ([_][]const u8{ "\x00", "\x00\x00", "a\x00", "", "\x00b" }) |text| try fixture.expect_agree(text);
    try testing.expectEqual(matcher_file.OnePassTable.held, fixture.matcher.one_pass_table);
}

test "a loop does not repeat an entry that holds for its own contexts alone" {
    var fixture: Fixture = .{};
    // `\b` holds before the `a` after `-` and not before the `a` after it.
    try fixture.init("(?:\\ba|-)+(x)");
    for ([_][]const u8{ "-aax", "-a-ax", "a-ax", "-ax", "aax", "-a-aax" }) |text| try fixture.expect_agree(text);
}
