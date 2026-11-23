//! Tests of literal_trie.zig: a pattern of literals compiled as a trie matches as the parser's
//! program does, and the parser takes every pattern the trie does not.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const compiler = @import("compile.zig");
const fragment = @import("fragment.zig");
const program_file = @import("program.zig");
const literal_trie = @import("literal_trie.zig");
const matcher_file = @import("matcher.zig");
const searcher_test = @import("searcher/searcher_test.zig");
const Matcher = matcher_file.Matcher;
const Generator = codec.testing.split.Generator;

/// The instructions and the matcher's words a test's program takes at most.
const storage_len = 8192;
const memory_len = Matcher.memory_len(storage_len, constants.group_slots);

/// A program and a matcher for it.
const Fixture = struct {
    storage: [storage_len]program_file.Instruction = undefined,
    memory: [memory_len]u64 = undefined,
    program: program_file.Program = undefined,
    matcher: Matcher = undefined,

    fn init(fixture: *Fixture, pattern: []const u8) !void {
        fixture.program = try compiler.compile(pattern, .{}, &fixture.storage);
        const len = Matcher.memory_len(fixture.program.forward_len, fixture.program.slot_count());
        fixture.matcher.init(&fixture.program, .{ .captures = .span }, fixture.memory[0..len]);
    }
};

/// True when `alternation` builds a trie of `pattern` in the forward direction.
fn takes(pattern: []const u8) !bool {
    var storage: [storage_len]program_file.Instruction = undefined;
    var builder: fragment.Builder = .{ .instructions = &storage, .direction = .forward };
    return (try literal_trie.alternation(&builder, pattern, false)) != null;
}

/// The room a test's pattern takes, its fillers included.
const pattern_room = 1024;

/// `head`, then `|` and filler literals `z00`, `z01` and on, until the pattern holds `total`
/// literals. No filler starts as a literal of a head does, or ends as one ends.
fn filled(buffer: *[pattern_room]u8, head: []const u8, total: usize) []const u8 {
    @memcpy(buffer[0..head.len], head);
    var len = head.len;
    // The bars of the head that no `\\` escapes.
    var count: usize = 1;
    for (head, 0..) |octet, index| count += @intFromBool(octet == '|' and (index == 0 or head[index - 1] != '\\'));
    var filler: usize = 0;
    while (count < total) : ({
        count += 1;
        filler += 1;
    }) {
        const written = std.fmt.bufPrint(buffer[len..], "|z{d:0>2}", .{filler}) catch unreachable;
        len += written.len;
    }
    return buffer[0..len];
}

/// The literals a pattern of the trie holds at least.
const trie_literals = constants.literal_set_max + 1;

/// `takes` of `head` filled to `trie_literals` literals.
fn takes_filled(head: []const u8) !bool {
    var buffer: [pattern_room]u8 = undefined;
    return takes(filled(&buffer, head, trie_literals));
}

test "the trie takes an alternation of more than literal_set_max literals, and nothing else" {
    try testing.expect(try takes_filled("a|b|c"));
    try testing.expect(try takes_filled("(?:a)|b|(?:c)|\\.\\+"));
    try testing.expect(try takes_filled("\xC3\xA9|b|\xE6\x97\xA5"));
    // A literal in the same set twice, and one that starts another.
    try testing.expect(try takes_filled("ab|a|abc|b|ab"));
    // No more than `literal_set_max` literals: claim R5's exact set is the better way. An
    // escaped `|` passes the count of bars, and the scan counts the literals.
    var buffer: [pattern_room]u8 = undefined;
    try testing.expect(!try takes(filled(&buffer, "a", constants.literal_set_max)));
    try testing.expect(!try takes(filled(&buffer, "a\\|", constants.literal_set_max)));
    // Anything but literals, each alone or in `(?:` and `)`.
    const others = [_][]const u8{
        "i*",     "|a", "[i]", "\\d",    "(?:a|b)", "(a)", "(?i)a", "(?:i", "i)",
        "\\x61b", ".",  "^i",  "(?:a)b",
    };
    for (others) |pattern| {
        if (try takes_filled(pattern)) return error.TestUnexpectedTrie;
    }
    // A pattern that is no UTF-8: the parser refuses it.
    try testing.expect(!try takes_filled("a|\xFF"));
}

test "a forward node whose end stands between two answers of one branch takes the parser" {
    // After `ab`, `abc` comes before `a` and `abd` after it: `a` wins over `abd` and loses to
    // `abc`, so no order of `a`'s node puts its end.
    try testing.expect(!try takes_filled("abc|a|abd"));
    // `abc` starts `abcd` and comes first, so no match through `abc`'s branch takes `abcd`:
    // the branch's answers all come before `ab`, which ends after them.
    try testing.expect(try takes_filled("abc|ab|abcd"));
    try testing.expect(try takes_filled("ab|abc|abcd"));
    try testing.expect(try takes_filled("abcd|abc|ab"));
}

/// The literals a seed draws: 65 to 100, each of 2 to 6 octets of `alphabet`, so that some start
/// others and a few stand twice.
const literals_min = trie_literals;
const literals_extra_max = 35;
const literals_max = literals_min + literals_extra_max;
const literal_len_min = 2;
const literal_len_max = 6;
const alphabet = "abcdefgh";
const random_sets = 300;
const texts_per_set = 8;
const text_len = 24;

/// One literal in `group_odds` stands in a group of its own.
const group_odds = 4;
const opener = "(?:";

fn random_pattern(generator: *Generator, buffer: []u8) []const u8 {
    var len: usize = 0;
    const count = literals_min + generator.below(literals_max - literals_min + 1);
    for (0..count) |index| {
        if (index > 0) {
            buffer[len] = '|';
            len += 1;
        }
        const grouped = generator.below(group_odds) == 0;
        if (grouped) {
            @memcpy(buffer[len..][0..opener.len], opener);
            len += opener.len;
        }
        for (0..literal_len_min + generator.below(literal_len_max - literal_len_min + 1)) |_| {
            buffer[len] = alphabet[generator.below(alphabet.len)];
            len += 1;
        }
        if (grouped) {
            buffer[len] = ')';
            len += 1;
        }
    }
    return buffer[0..len];
}

test "a trie matches as the parser's program does, from every start, by matcher and searcher" {
    var trie: Fixture = .{};
    var parsed: Fixture = .{};
    var searching: searcher_test.Fixture = .{};
    var generator = Generator.init(0x7121);
    var buffer: [literals_max * (literal_len_max + 5)]u8 = undefined;
    var wrapped: [buffer.len + 4]u8 = undefined;
    var taken: usize = 0;
    for (0..random_sets) |_| {
        const pattern = random_pattern(&generator, &buffer);
        // The same alternation in one group, which the trie refuses: the parser's program.
        const reference = std.fmt.bufPrint(&wrapped, "(?:{s})", .{pattern}) catch unreachable;
        try testing.expect(!try takes(reference));
        taken += @intFromBool(try takes(pattern));
        try trie.init(pattern);
        try parsed.init(reference);
        // `compile` writes the trie where it builds: a set's literals take one octet each once.
        if (try takes(pattern)) try testing.expect(trie.program.forward_len < parsed.program.forward_len);
        try searching.init(pattern, searcher_test.cache_words_max);
        var text: [text_len]u8 = undefined;
        for (0..texts_per_set) |_| {
            for (&text) |*octet| octet.* = (alphabet ++ "x")[generator.below(alphabet.len + 1)];
            for (0..text.len + 1) |from| {
                const expected = parsed.matcher.find(&text, from);
                try testing.expectEqual(expected, trie.matcher.find(&text, from));
                try testing.expectEqual(expected, searching.searcher.find(&text, from));
            }
        }
    }
    // Some sets hold a node with no order for its end: the seed gave 235 tries of 300 sets. The
    // bound keeps the test reading tries, and not the parser's programs alone.
    try testing.expect(taken * 2 > random_sets);
}

/// Requires the trie's program of `pattern` to match each text as the parser's program does.
fn expect_as_parsed(head: []const u8, texts: []const []const u8) !void {
    var trie: Fixture = .{};
    var parsed: Fixture = .{};
    var wrapped: [storage_len]u8 = undefined;
    var buffer: [pattern_room]u8 = undefined;
    const pattern = filled(&buffer, head, trie_literals);
    try testing.expect(try takes(pattern));
    try trie.init(pattern);
    try parsed.init(try std.fmt.bufPrint(&wrapped, "(?:{s})", .{pattern}));
    for (texts) |text| {
        for (0..text.len + 1) |from| try testing.expectEqual(parsed.matcher.find(text, from), trie.matcher.find(text, from));
    }
}

test "a trie of escaped, grouped and UTF-8 literals matches as the parser's program does" {
    try expect_as_parsed(
        "a\\.b|\\+|(?:c\\|)|\xC3\xA9x|d|e|f|(?:g)|h\\$|\xE6\x97\xA5",
        &.{ "a.b axb + c| c \xC3\xA9x \xC3\xA9 h$ h \xE6\x97\xA5", "\\+\\.", "gfedc" },
    );
}

test "a trie with no room past its program for its lists takes the parser" {
    var buffer: [pattern_room]u8 = undefined;
    const pattern = filled(&buffer, "abc|abd|abe", trie_literals);
    var storage: [storage_len]program_file.Instruction = undefined;
    // The least storage in which the trie builds.
    var least: usize = 0;
    for (1..storage_len) |len| {
        var builder: fragment.Builder = .{ .instructions = storage[0..len], .direction = .forward };
        if (try literal_trie.alternation(&builder, pattern, false) == null) {
            try testing.expectEqual(0, builder.len);
            continue;
        }
        least = len;
        break;
    }
    try testing.expect(least > 0);
    // There the program and the lists fit apart, so it matches as the parser's does.
    var builder: fragment.Builder = .{ .instructions = storage[0..least], .direction = .forward };
    const built = (try literal_trie.alternation(&builder, pattern, false)).?;
    const program_len = builder.len;
    var roomy: [storage_len]program_file.Instruction = undefined;
    var roomy_builder: fragment.Builder = .{ .instructions = &roomy, .direction = .forward };
    const roomy_built = (try literal_trie.alternation(&roomy_builder, pattern, false)).?;
    try testing.expectEqual(roomy_built.entry, built.entry);
    try testing.expectEqualSlices(program_file.Instruction, roomy[0..roomy_builder.len], storage[0..program_len]);
    // The lists take more room than the program.
    try testing.expect(least > 2 * program_len);
}

/// The reverse root of a program, past the saves and jumps that start the reverse program.
fn reverse_root(program: *const program_file.Program) u32 {
    var root = program.reverse;
    for (0..program.instructions.len) |_| {
        const kind = program.instructions[root].kind;
        if (kind != .save and kind != .jump) break;
        root = program.instructions[root].out;
    }
    return root;
}

/// The branches of the node at `node` that take `octet` alone: the ranges its splits lead to.
fn branches_taking(program: *const program_file.Program, node: u32, octet: u8, found: *[storage_len]u32) []const u32 {
    var stack: [storage_len]u32 = undefined;
    stack[0] = node;
    var stack_len: usize = 1;
    var count: usize = 0;
    for (0..program.instructions.len) |_| {
        if (stack_len == 0) break;
        stack_len -= 1;
        const instruction = program.instructions[stack[stack_len]];
        switch (instruction.kind) {
            .split => {
                stack[stack_len] = instruction.arg;
                stack[stack_len + 1] = instruction.out;
                stack_len += constants.targets_per_instruction;
            },
            .range => if (instruction.lo == octet and instruction.hi == octet) {
                found[count] = stack[stack_len];
                count += 1;
            },
            else => {},
        }
    }
    return found[0..count];
}

/// Requires the node past `prefix`, read from the reverse root, to hold one branch that takes
/// `a` and one that takes `b`: the literals' octets before `prefix`.
fn expect_one_branch_each(head: []const u8, prefix: []const u8) !void {
    var fixture: Fixture = .{};
    var buffer: [pattern_room]u8 = undefined;
    try fixture.init(filled(&buffer, head, trie_literals));
    var found: [storage_len]u32 = undefined;
    var node = reverse_root(&fixture.program);
    for (prefix) |octet| {
        const branches = branches_taking(&fixture.program, node, octet, &found);
        try testing.expectEqual(1, branches.len);
        node = fixture.program.instructions[branches[0]].out;
    }
    try testing.expectEqual(1, branches_taking(&fixture.program, node, 'a', &found).len);
    try testing.expectEqual(1, branches_taking(&fixture.program, node, 'b', &found).len);
}

test "the reverse program of literals that end alike reads each last octet once" {
    // Sorted from the first octet, the literals end in `a` and `b` in turn, so a trie built in
    // that order would hold a branch for each literal there.
    try expect_one_branch_each("pa|qb|ra|sb|ta|ub|va|wb|xa|yb", "");
    // The same past eight octets that every literal ends with, which a sort key holds whole.
    try expect_one_branch_each("pazzzzzzzz|qbzzzzzzzz|razzzzzzzz|sbzzzzzzzz|tazzzzzzzz|ubzzzzzzzz|vazzzzzzzz|wbzzzzzzzz|xazzzzzzzz|ybzzzzzzzz", "zzzzzzzz");
}
