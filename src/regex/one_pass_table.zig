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
//! the position, so the search walks that position as `one_pass.find` does.
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

/// The bits of an entry's kind, at its top. The bits between the mask and the kind hold the first
/// entry of the next seed's row.
const kind_bits = 3;
const kind_shift = @bitSizeOf(u64) - kind_bits;
const next_mask = (@as(u64, 1) << (kind_shift - mask_bits)) - 1;

/// What an entry says. A table starts with every entry zero, so `unknown`.
const Kind = enum(u3) { unknown, took, matched, dead, walk };

/// The row of an instruction that is no seed.
const no_row = std.math.maxInt(u16);

comptime {
    // A row number fits the map from instructions to rows, and a row's first entry its field.
    assert(constants.one_pass_instructions_max < no_row);
    assert(@typeInfo(Kind).@"enum".fields.len <= 1 << kind_bits);
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

fn make(kind: Kind, mask: u32, next: u32) u64 {
    assert(next <= next_mask);
    return @as(u64, @intFromEnum(kind)) << kind_shift | @as(u64, next) << mask_bits | mask;
}

fn kind_of(entry: u64) Kind {
    return @enumFromInt(entry >> kind_shift);
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
    var entry = table.entries[at.base + column];
    if (kind_of(entry) == .unknown) entry = fill(table, matcher, at.base + column, octet);
    switch (kind_of(entry)) {
        .took => return .{ .next = took(table, matcher, haystack, at, at.base + column) },
        .matched => {
            save(matcher, entry, at.index);
            return .{ .done = true };
        },
        .dead => return .{ .done = false },
        .walk => return walk(table, matcher, haystack, at),
        .unknown => unreachable,
    }
}

/// The thread after the entry at `place` took the octet at `at`. A loop of the row takes the
/// octets after it at once.
inline fn took(table: Table, matcher: *Matcher, haystack: []const u8, at: At, place: u32) At {
    const entry = table.entries[place];
    save(matcher, entry, at.index);
    const next = next_of(entry);
    var index = at.index + 1;
    if (next == at.base and mask_of(entry) == 0) index = loop_end(table, &matcher.program.classes, haystack, index, place);
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

/// A position whose paths pass an assertion: `one_pass.step` walks it with the octets around it.
fn walk(table: Table, matcher: *Matcher, haystack: []const u8, at: At) Turn {
    matcher.position = at.index;
    matcher.behind = if (at.index == 0) .edge else Context.of(haystack[at.index - 1]);
    return switch (one_pass.step(matcher, haystack, at.index, table.seed_at(at.base))) {
        .took => |next| .{ .next = .{ .base = table.base_of(next), .index = at.index + 1 } },
        .matched => .{ .done = true },
        .dead => .{ .done = false },
    };
}

/// Fills the entry at `place` for `octet`, and gives it.
fn fill(table: Table, matcher: *Matcher, place: u32, octet: ?u8) u64 {
    const entry = closure(table, matcher, table.seed_at(place - place % table.columns), octet);
    assert(kind_of(entry) != .unknown);
    table.entries[place] = entry;
    return entry;
}

/// The entry of `seed` for `octet`: the paths from the seed in the matcher's order, as
/// `one_pass.follow` takes them, each instruction once.
fn closure(table: Table, matcher: *Matcher, seed: u32, octet: ?u8) u64 {
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
        if (path(table, matcher, first, mask, octet, &stack_len)) |entry| return entry;
    }
    return make(.dead, 0, 0);
}

/// One path from `first`, whose saves so far are `saved`: its entry where it matches, takes the
/// octet or meets an assertion, or null where it ends. A split pushes its other branch.
fn path(table: Table, matcher: *Matcher, first: u32, saved: u32, octet: ?u8, stack_len: *u32) ?u64 {
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
            // An assertion holds in some contexts and not in others, which one entry cannot say.
            .look => return make(.walk, 0, 0),
            .range, .ranges => {
                const next = program_file.step(instructions, index, octet orelse return null) orelse return null;
                return make(.took, mask, table.base_of(next));
            },
            .match => return make(.matched, mask, 0),
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

test "the entries a search filled serve the next search, and each kind gives the walk's answer" {
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
    var walked: usize = 0;
    for (table.entries[0 .. rows * table.columns]) |entry| {
        filled += @intFromBool(kind_of(entry) != .unknown);
        walked += @intFromBool(kind_of(entry) == .walk);
    }
    try testing.expect(filled > 0 and walked > 0);
}

test "the text's end has a column of its own, apart from the first class's" {
    var fixture: Fixture = .{};
    // The first class holds octet 0, which the loop takes, and the loop ends at the text's end.
    try fixture.init("([\\x00-a]*)$");
    for ([_][]const u8{ "\x00", "\x00\x00", "a\x00", "", "\x00b" }) |text| try fixture.expect_agree(text);
    try testing.expectEqual(matcher_file.OnePassTable.held, fixture.matcher.one_pass_table);
}
