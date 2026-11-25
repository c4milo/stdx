//! The configuration of a lazy DFA, the program it runs, and what its scan finds (dfa.zig,
//! decision 86).
const assert = @import("std").debug.assert;
const program_file = @import("../program.zig");
const Program = program_file.Program;
const Instruction = program_file.Instruction;

/// Which matches a DFA reports.
pub const Kind = enum {
    /// The forward program: a thread that matches ends every thread after it, as in the matcher,
    /// so the last match a scan sees is the one a backtracking matcher finds first.
    first,
    /// Every match is kept, so the last match a scan sees is the longest. The reverse program runs
    /// this way from a match's end, to find its start.
    longest,
};

pub const Config = struct {
    /// Where the program starts.
    entry: u32,
    kind: Kind,
    /// Whether a match must start at the scan's first octet.
    anchored: bool,
    /// Claim R1: whether a forward scan that waits for a match to start skips to the next octet
    /// that can start one (dfa_skip.zig). Only for a DFA of `Kind.first` that is not anchored:
    /// an anchored scan waits for no match, and the reverse program starts where a match ends.
    skip: bool = false,
    /// Claim R2: whether that skip goes to the next place of the literal every match starts
    /// with, where the program has one (literal.zig). Only with `skip`.
    literal: bool = false,
    /// Claim R5: whether that skip goes to the next place of one of the literals that the
    /// branches of an alternation start with, where the program has no literal of claim R2 and
    /// no assertion (literal_set.zig). Only with `skip`.
    literal_set: bool = false,
    /// Whether the searches of claims R2 and R5 run in the variant object of x86-64's AVX2,
    /// `avx2_lanes` octets a step (`Literal.wide`).
    wide: bool = false,
    /// Whether claim R5 takes Teddy in the variant object of SSSE3, on a CPU with SSSE3 and no
    /// AVX2 (`LiteralSet.ssse3`).
    ssse3: bool = false,
    /// Claim R7: whether a forward scan with no skip takes two octets a read (dfa_pairs.zig).
    pairs: bool = false,
    /// Claim R9: whether a forward scan goes past the octets over which a state stays where it
    /// is (dfa_stay.zig). Only for a DFA of `Kind.first` that is not anchored, and not with claim
    /// R3, which takes `dfa_skip_flag` for its own states.
    stays: bool = false,

    /// True when the DFA can take each claim the configuration names: a skip and claim R9 only
    /// in a forward DFA that is not anchored, and claims R2 and R5 only with the skip.
    pub fn valid(config: Config) bool {
        const forward = config.kind == .first and !config.anchored;
        return (!config.skip or forward) and (!config.stays or forward) and
            (!config.literal or config.skip) and (!config.literal_set or config.skip);
    }
};

/// What a visit of a scan to the state that waits goes to (dfa_wait.zig): the next octet that
/// can start a match (claim R1), the next place of the literal (claim R2), of one of the
/// literals (claim R5), or the next octet that can start a match in the window before the next
/// place of a literal (dfa_window.zig).
pub const Pass = enum { octet, literal, literal_set, window };

/// What a scan found: the offset its last match ended at in the scan's direction, none, or
/// nothing, because the cache thrashed.
pub const Scan = union(enum) {
    gave_up,
    none,
    found: usize,

    pub fn of(last: ?usize) Scan {
        return if (last) |offset| .{ .found = offset } else .none;
    }
};

/// The instructions of one program of a `Program`: the forward one from the first instruction,
/// or the reverse one, from where the forward one ends to the last.
pub const Block = struct {
    base: u32,
    len: u32,
    /// The instructions a thread, a seed or a step of the closure names: every instruction but
    /// the ranges that a `ranges` node holds after it. A DFA's lists hold these alone, and a
    /// class past ASCII holds about five ranges a node: `\p{L}` takes 1,345 instructions, of
    /// which 219 are nodes.
    nodes: u32,

    pub fn of(program: *const Program, entry: u32) Block {
        assert(entry < program.instructions.len);
        const total: u32 = @intCast(program.instructions.len);
        const base: u32 = if (entry < program.forward_len) 0 else program.forward_len;
        const len: u32 = if (entry < program.forward_len) program.forward_len else total - program.forward_len;
        const nodes = if (entry < program.forward_len) program.forward_nodes else program.reverse_nodes;
        assert(nodes <= len);
        return .{ .base = base, .len = len, .nodes = nodes };
    }
};

/// The instructions of `instructions` that are no range a `ranges` node holds, counted one by
/// one: what the compiler counts as it writes them. The tests hold the compiler's counts to it.
pub fn nodes_of(instructions: []const Instruction) u32 {
    var nodes: u32 = 0;
    var index: usize = 0;
    // Each turn passes one node and the ranges it holds, so the turns are at most the
    // instructions.
    for (0..instructions.len) |_| {
        if (index == instructions.len) break;
        const instruction = instructions[index];
        index += 1 + if (instruction.kind == .ranges) instruction.arg else 0;
        nodes += 1;
    }
    assert(index == instructions.len);
    return nodes;
}

const testing = @import("std").testing;
const compiler = @import("../compile.zig");

/// Instructions enough for the tests' patterns.
const test_storage_len = 64;

/// Instructions enough for `\p{L}`, both ways.
const test_large_storage_len = 8192;
threadlocal var test_large_storage: [test_large_storage_len]Instruction = undefined;

test "the compiler counts the nodes of a class too large for the small set, both ways" {
    // `\p{L}` holds more than `class_ranges_small` ranges, so its pass runs again in the large
    // set, and the reverse program sorts its sequences in the storage past the program.
    // `[ac-eg]` comes first, so the pass that `\\p{L}` refuses has written a `ranges` node.
    for ([_][]const u8{ "\\p{L}x", "[ac-eg]\\p{L}x" }) |pattern| {
        const program = try compiler.compile(pattern, .{}, &test_large_storage);
        try testing.expectEqual(nodes_of(program.instructions[0..program.forward_len]), program.forward_nodes);
        try testing.expectEqual(nodes_of(program.instructions[program.forward_len..]), program.reverse_nodes);
        try testing.expect(program.forward_nodes < program.forward_len);
    }
}

test "a block's nodes leave out the ranges a ranges node holds" {
    var storage: [test_storage_len]Instruction = undefined;
    const program = try compiler.compile("[ac-eg]x", .{}, &storage);
    for ([_]u32{ program.forward, program.reverse }) |entry| {
        const block = Block.of(&program, entry);
        // The class is one `ranges` node and the three ranges it holds.
        try testing.expectEqual(block.len - 3, block.nodes);
        try testing.expectEqual(nodes_of(program.instructions[block.base..][0..block.len]), block.nodes);
    }
}
