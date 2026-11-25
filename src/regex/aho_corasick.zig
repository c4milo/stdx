//! Claim R15 (decision 86): the search of a trie's literals by the automaton of Aho and Corasick,
//! "Efficient string matching: an aid to bibliographic search", Communications of the ACM 18(6),
//! 1975.
//!
//! A pattern that is an alternation of more literals than claim R5 takes compiles as a trie
//! (literal_trie.zig). Its DFAs' lists hold a member for each node of its program, so a dictionary
//! of 43,029 words leaves no room in the default cache for its reverse DFA, and the matcher reads
//! the text at about 1 MB/s. Where the DFAs cannot answer, the searcher builds this automaton in
//! their cache's words (aho_corasick_build.zig, searcher_automaton.zig).
//!
//! A node of the automaton is a start of a literal. Its state after a text is the node of the
//! longest suffix of the text that starts a literal, and its fail node is the node of its own text
//! without the first octet. spec/lean/Stdx/Regex/AhoCorasick.lean proves that the step by children
//! and fail nodes gives that state (`failStep_eq`), and that the search below gives the matcher's
//! answer (`searchFrom_answer`).
//!
//! The search keeps the best match found: the least start, and at one start the literal the
//! program's order prefers, its rank. A node's text starts at the search's offset less the node's
//! depth. Once that start passes the best match's start, no better match is left.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const matcher_file = @import("matcher.zig");
const Span = matcher_file.Span;

/// A rank or a node that names none.
pub const none = std.math.maxInt(u32);

/// The words each node takes: its first branch, its fail node, its literal's rank, and one word
/// of four octets: its octet, its depth, the length of its longest literal, and its branches.
pub const words_per_node = 4;

/// The words of the program's classes of octets, which the automaton copies after its nodes.
pub const classes_words = constants.octet_values / @sizeOf(u32);

/// Where an automaton stands: not built, built, or refused for good.
pub const State = enum(u8) { waiting, ready, refused };

/// The octets of a node's word, and their shifts.
const label_shift = 0;
const depth_shift = 8;
const out_shift = 16;
const branches_shift = 24;
const octet_mask: u32 = constants.octet_max;

pub fn pack(label: u8, depth: u8, out_len: u8, branches: u8) u32 {
    return @as(u32, label) << label_shift | @as(u32, depth) << depth_shift |
        @as(u32, out_len) << out_shift | @as(u32, branches) << branches_shift;
}

pub inline fn label_of(word: u32) u8 {
    return @intCast(word >> label_shift & octet_mask);
}

pub inline fn depth_of(word: u32) u8 {
    return @intCast(word >> depth_shift & octet_mask);
}

pub inline fn out_of(word: u32) u8 {
    return @intCast(word >> out_shift & octet_mask);
}

pub inline fn branches_of(word: u32) u8 {
    return @intCast(word >> branches_shift & octet_mask);
}

/// The automaton of a trie, in the words a searcher gives it. Nodes are in breadth-first order, so
/// a node's children stand together and each node's fail node comes before it.
pub const Automaton = struct {
    /// The words the automaton may take: a searcher's cache, once both DFAs gave up.
    memory: []u32 = &.{},
    state: State = .waiting,
    nodes: u32 = 0,
    /// Each node's first child.
    first_child: []u32 = &.{},
    /// Each node's fail node: the node of its text without the first octet.
    fail: []u32 = &.{},
    /// The rank of each node's longest literal, or `none`.
    rank: []u32 = &.{},
    /// Each node's octet, depth, longest literal's length and count of children (`pack`).
    words: []u32 = &.{},
    /// A full row of next nodes for each of the first `row_nodes` nodes, one entry for each class
    /// of octet.
    rows: []u32 = &.{},
    row_nodes: u32 = 0,
    /// The program's classes of octets, which split no octet a literal takes from another, in
    /// the automaton's words.
    classes: []const u8 = &.{},
    class_count: u32 = 0,

    /// The child of `node` by `octet`, or null.
    pub inline fn child(automaton: *const Automaton, node: u32, octet: u8) ?u32 {
        const first = automaton.first_child[node];
        const count = branches_of(automaton.words[node]);
        for (automaton.words[first..][0..count], first..) |word, index| {
            if (label_of(word) == octet) return @intCast(index);
        }
        return null;
    }

    /// The node after `node` reads `octet`: its row where it has one, else its child, else the
    /// step from its fail node. Each fail node is less deep, so the steps are at most the depth.
    pub inline fn next(automaton: *const Automaton, from: u32, octet: u8) u32 {
        var node = from;
        for (0..constants.automaton_depth_max + 1) |_| {
            if (node < automaton.row_nodes) return automaton.rows[@as(usize, node) * automaton.class_count + automaton.classes[octet]];
            if (automaton.child(node, octet)) |found| return found;
            node = automaton.fail[node];
        }
        unreachable;
    }

    /// The first match at or after `from`, or null. The search starts at the root at `from`.
    pub fn find(automaton: *const Automaton, haystack: []const u8, from: usize) ?Span {
        assert(automaton.state == .ready and from <= haystack.len);
        var node: u32 = 0;
        var best_start: usize = std.math.maxInt(usize);
        var best_rank: u32 = none;
        var best_end: usize = 0;
        var index = from;
        while (index < haystack.len) {
            node = automaton.next(node, haystack[index]);
            index += 1;
            const word = automaton.words[node];
            // The node's text starts here. A match that starts no later than the best one
            // would hold that text, so none is left once it starts after it.
            if (index - depth_of(word) > best_start) break;
            const len = out_of(word);
            if (len == 0) continue;
            const start = index - len;
            const rank = automaton.rank[node];
            if (start < best_start or (start == best_start and rank < best_rank)) {
                best_start = start;
                best_rank = rank;
                best_end = index;
            }
        }
        if (best_rank == none) return null;
        assert(best_start >= from and best_end <= haystack.len);
        return .{ .start = best_start, .end = best_end };
    }
};

test "a node's word holds its four octets apart" {
    const word = pack(0xC3, 17, 9, 255);
    try std.testing.expectEqual(@as(u8, 0xC3), label_of(word));
    try std.testing.expectEqual(@as(u8, 17), depth_of(word));
    try std.testing.expectEqual(@as(u8, 9), out_of(word));
    try std.testing.expectEqual(@as(u8, 255), branches_of(word));
}
