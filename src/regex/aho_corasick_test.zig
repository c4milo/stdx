//! Claim R15's tests: the automaton of a trie's literals gives the matcher's match from every
//! offset (decision 16's rule for a fast path), and refuses each program that is not a trie's.
const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const compiler = @import("compile.zig");
const program_file = @import("program.zig");
const Instruction = program_file.Instruction;
const Program = program_file.Program;
const Encoding = program_file.Encoding;
const matcher_file = @import("matcher.zig");
const Matcher = matcher_file.Matcher;
const aho = @import("aho_corasick.zig");
const Automaton = aho.Automaton;
const build = @import("aho_corasick_build.zig").build;
const Generator = @import("codec").testing.split.Generator;

/// The instructions a test's trie takes: its forward and its reverse program, and the sorted
/// literals the compiler writes past them.
const storage_len = 16384;
const memory_words = 65536;
const pattern_len_max = 2048;
const text_len = 96;
const literals_min = constants.literal_set_max + 1;
const literals_max = literals_min + literals_min;
const literal_len_max = 8;

/// The order of a test's literals. Sorted either way, each literal stands before every literal it
/// starts, or after them all, so the compiler takes a trie. Drawn, a node may have no order, and
/// the compiler takes the alternation as the parser reads it, which is no trie.
const Order = enum { ascending, descending, drawn };

fn less(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.order(u8, left, right) == .lt;
}

fn more(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.order(u8, left, right) == .gt;
}

/// A program, the automaton's words and a matcher to hold the automaton against.
const Fixture = struct {
    storage: [storage_len]Instruction = undefined,
    memory: [memory_words]u32 = undefined,
    matcher_memory: [Matcher.memory_len(storage_len, constants.group_slots)]u64 = undefined,
    pattern: [pattern_len_max]u8 = undefined,
    octets: [literals_max][literal_len_max]u8 = undefined,
    program: Program = undefined,
    matcher: Matcher = undefined,
    automaton: Automaton = .{},

    /// Compiles `pattern`, readies the matcher, and builds the automaton in `words` words.
    fn init(fixture: *Fixture, pattern: []const u8, encoding: Encoding, words: usize) !bool {
        fixture.program = try compiler.compile(pattern, .{ .encoding = encoding }, &fixture.storage);
        const len = Matcher.memory_len(fixture.program.forward_len, fixture.program.slot_count());
        fixture.matcher.init(&fixture.program, .{ .captures = .span }, fixture.matcher_memory[0..len]);
        fixture.automaton = .{ .memory = fixture.memory[0..words] };
        const built = build(&fixture.automaton, &fixture.program);
        fixture.automaton.state = if (built) .ready else .refused;
        return built;
    }

    /// Requires the automaton to give the matcher's match from every offset of `text`.
    fn expect_matcher(fixture: *Fixture, text: []const u8) !void {
        for (0..text.len + 1) |from| {
            const expected = fixture.matcher.find(text, from);
            const got = fixture.automaton.find(text, from);
            try testing.expectEqual(expected, got);
        }
    }

    /// An alternation of `count` literals of up to `len_max` octets each from `alphabet`, many of
    /// them starts of one another, in the order `order` names.
    fn literals(fixture: *Fixture, generator: *Generator, alphabet: []const u8, count: usize, len_max: usize, order: Order) []const u8 {
        std.debug.assert(count <= literals_max and len_max <= literal_len_max);
        var drawn: [literals_max][]const u8 = undefined;
        for (drawn[0..count], fixture.octets[0..count]) |*literal, *octets| {
            const literal_len = generator.between(1, len_max);
            for (octets[0..literal_len]) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
            literal.* = octets[0..literal_len];
        }
        switch (order) {
            .drawn => {},
            .ascending => std.sort.pdq([]const u8, drawn[0..count], {}, less),
            .descending => std.sort.pdq([]const u8, drawn[0..count], {}, more),
        }
        var len: usize = 0;
        for (drawn[0..count], 0..) |literal, index| {
            if (index > 0) {
                fixture.pattern[len] = '|';
                len += 1;
            }
            @memcpy(fixture.pattern[len..][0..literal.len], literal);
            len += literal.len;
        }
        return fixture.pattern[0..len];
    }
};

/// The fixture the tests share: too large for a test's stack.
threadlocal var shared: Fixture = .{};

fn random_text(generator: *Generator, alphabet: []const u8, buffer: []u8) []const u8 {
    for (buffer) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
    return buffer;
}

test "the automaton gives the matcher's match from every offset, for literals that start one another" {
    var generator = Generator.init(0xAC15);
    var text: [text_len]u8 = undefined;
    for (0..48) |round| {
        const order: Order = @enumFromInt(round % 3);
        const count = literals_min + generator.below(literals_max - literals_min);
        const pattern = shared.literals(&generator, "abc", count, 2 + round % 6, order);
        const built = try shared.init(pattern, .bytes, memory_words);
        // Sorted, the compiler takes a trie, and the automaton takes it.
        if (order != .drawn) try testing.expect(built);
        if (!built) continue;
        for (0..4) |_| try shared.expect_matcher(random_text(&generator, "abcd", &text));
    }
}

test "the automaton keeps the order of the alternation at one start" {
    // `ab` first: at a start where both stand, the shorter literal wins.
    var generator = Generator.init(0xAB);
    var pattern: [pattern_len_max]u8 = undefined;
    for ([_][]const u8{ "ab|abc|", "abc|ab|" }, [_]u64{ 2, 3 }) |head, end| {
        var len: usize = 0;
        @memcpy(pattern[0..head.len], head);
        len += head.len;
        // Enough other words that the compiler takes a trie.
        len += (try std.fmt.bufPrint(pattern[len..], "{s}", .{shared.literals(&generator, "xyz", literals_min, 6, .ascending)})).len;
        try testing.expect(try shared.init(pattern[0..len], .bytes, memory_words));
        try shared.expect_matcher("zabcab");
        const span = shared.automaton.find("abc", 0).?;
        try testing.expectEqual(end, span.end);
    }
}

test "the automaton gives the matcher's match in UTF-8, where no match starts in a scalar value" {
    var generator = Generator.init(0xC3);
    var text: [text_len]u8 = undefined;
    // é is C3 A9, and ñ C3 B1: literals of them share their first octet.
    // Literals of 1 to 3 scalar values, sorted, so that the compiler takes a trie.
    const options = [_][]const u8{ "a", "é", "ñ", "n" };
    var drawn: [literals_max][]const u8 = undefined;
    const count = literals_min + 8;
    for (drawn[0..count], shared.octets[0..count]) |*literal, *octets| {
        var literal_len: usize = 0;
        for (0..generator.between(1, 3)) |_| {
            const option = options[generator.below(options.len)];
            @memcpy(octets[literal_len..][0..option.len], option);
            literal_len += option.len;
        }
        literal.* = octets[0..literal_len];
    }
    std.sort.pdq([]const u8, drawn[0..count], {}, less);
    var words: [pattern_len_max]u8 = undefined;
    var len: usize = 0;
    for (drawn[0..count], 0..) |literal, index| {
        if (index > 0) {
            words[len] = '|';
            len += 1;
        }
        @memcpy(words[len..][0..literal.len], literal);
        len += literal.len;
    }
    try testing.expect(try shared.init(words[0..len], .utf8, memory_words));
    for (0..16) |_| try shared.expect_matcher(random_text(&generator, "an\xC3\xA9\xB1", &text));
}

test "the automaton gives the same matches with any count of full rows" {
    var generator = Generator.init(0x0F);
    var text: [text_len]u8 = undefined;
    const pattern = shared.literals(&generator, "abc", literals_min + 40, 6, .ascending);
    try testing.expect(try shared.init(pattern, .bytes, memory_words));
    const nodes = shared.automaton.nodes;
    try testing.expectEqual(nodes, shared.automaton.row_nodes);
    // The words for the nodes and their classes, then room for one row more each time.
    const base = aho.words_per_node * @as(usize, nodes) + aho.classes_words;
    const class_count = shared.program.class_count;
    for ([_]usize{ 1, 2, 7, nodes / 2, nodes - 1 }) |rows| {
        try testing.expect(try shared.init(pattern, .bytes, base + rows * class_count));
        try testing.expectEqual(@as(u32, @intCast(rows)), shared.automaton.row_nodes);
        for (0..4) |_| try shared.expect_matcher(random_text(&generator, "abcd", &text));
    }
    // No row for the root: the automaton is refused.
    try testing.expect(!try shared.init(pattern, .bytes, base));
    try testing.expect(!try shared.init(pattern, .bytes, base - 1));
}

test "the automaton refuses each program that is not a trie's" {
    // A loop, two branches by one octet, a class, an assertion, a match of no octet, and a
    // literal past `automaton_depth_max` octets.
    const refused = [_][]const u8{ "a+b", "ab|ac", "a[bc]", "\\bab", "a|", "|a" };
    for (refused) |pattern| try testing.expect(!try shared.init(pattern, .bytes, memory_words));
    var long: [constants.automaton_depth_max + 1]u8 = undefined;
    @memset(&long, 'a');
    try testing.expect(!try shared.init(&long, .bytes, memory_words));
    // One octet fewer is taken.
    try testing.expect(try shared.init(long[0 .. long.len - 1], .bytes, memory_words));
}

test "a refused build writes no word, so the DFAs whose words they are still answer" {
    var generator = Generator.init(0x5A);
    const pattern = shared.literals(&generator, "abc", literals_min + 40, 6, .ascending);
    try testing.expect(try shared.init(pattern, .bytes, memory_words));
    const needed = aho.words_per_node * @as(usize, shared.automaton.nodes) + aho.classes_words + shared.program.class_count;
    // A trie too large for the words, and programs that are no trie's deep inside.
    const cases = [_]struct { pattern: []const u8, words: usize }{
        .{ .pattern = pattern, .words = needed - 1 },
        .{ .pattern = "x(?:ab|ac)", .words = memory_words },
        .{ .pattern = "xy(?:a|b+)", .words = memory_words },
    };
    for (cases) |case| {
        @memset(&shared.memory, 0x5A5A5A5A);
        try testing.expect(!try shared.init(case.pattern, .bytes, case.words));
        for (shared.memory) |word| try testing.expectEqual(@as(u32, 0x5A5A5A5A), word);
    }
    // The words it needs are enough.
    try testing.expect(try shared.init(pattern, .bytes, needed));
}

test "the automaton refuses a UTF-8 program whose literal starts with a continuation byte" {
    // No pattern compiles so in UTF-8: a literal is the UTF-8 of its scalar values. The program
    // of bytes, read as UTF-8, would match where no match may start.
    try testing.expect(try shared.init("\\x80a|b", .bytes, memory_words));
    shared.program.encoding = .utf8;
    shared.automaton = .{ .memory = &shared.memory };
    try testing.expect(!build(&shared.automaton, &shared.program));
}

test "a node's literal from its fail node keeps its rank against the best at its start" {
    // In `xabce` the state after `c` is the node `xabc`, a start of `xabcd`. The longest literal
    // that ends there is `abc`, through the node's fail node, and at its start it comes before
    // `ab`, the best found one octet before.
    var generator = Generator.init(0xF1);
    var pattern: [pattern_len_max]u8 = undefined;
    const head = "xabcd|abc|ab|";
    @memcpy(pattern[0..head.len], head);
    var len: usize = head.len;
    len += (try std.fmt.bufPrint(pattern[len..], "{s}", .{shared.literals(&generator, "yz", literals_min, 6, .descending)})).len;
    try testing.expect(try shared.init(pattern[0..len], .bytes, memory_words));
    try shared.expect_matcher("xabce");
    try testing.expectEqual(matcher_file.Span{ .start = 1, .end = 4 }, shared.automaton.find("xabce", 0).?);
}
