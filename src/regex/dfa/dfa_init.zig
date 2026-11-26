//! How a DFA takes its memory (decision 86): its lists, and its cache of states. A search runs one
//! DFA at a time, and each build of a state clears the lists it reads before it reads them. So a
//! program's forward DFA and its reverse DFA can take one set of lists, as long as the larger of
//! the two halves needs (decision 86 as amended on 2026-11-25). A program of 95 copies of `\p{L}`
//! has 28,540 nodes forward and 116,136 read back: lists of their own took 83% of the default
//! cache, and left the reverse DFA too few states.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Program = @import("../program.zig").Program;
const Literal = @import("../literal.zig").Literal;
const LiteralSet = @import("../literal_set.zig").LiteralSet;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const Config = dfa_file.Config;
const Block = @import("dfa_config.zig").Block;
const NodeSet = @import("dfa_node_set.zig").NodeSet;
const Cache = @import("dfa_cache.zig").Cache;
const dfa_pairs = @import("dfa_pairs.zig");
const dfa_stay = @import("dfa_stay.zig");

/// The lists a DFA builds a state with: two sets, each a list of its members and a list that
/// finds a member by its node's number (dfa_node_set.zig), the threads and the stack. Each is as
/// long as the program's nodes (`Block.nodes`), and the stack one word longer.
pub const sparse_lists = 2;
pub const node_lists = 4;

/// The words of the lists of a DFA whose program holds `nodes` nodes.
pub fn lists_len(nodes: u32) usize {
    return (sparse_lists + node_lists) * @as(usize, nodes) + 1;
}

/// The nodes of the half of `program` at `entry`. A search never leaves its half, so the lists
/// cover it alone: the forward program, or the reverse one, which the compiler writes after it.
pub fn nodes_of(program: *const Program, entry: u32) u32 {
    return Block.of(program, entry).nodes;
}

/// The words a DFA's cache takes to hold `dfa_states_min` states, beside its lists.
pub fn cache_len_min(program: *const Program) usize {
    return Cache.memory_len(constants.dfa_states_min, stride_of(program));
}

/// The words a DFA of the program at `entry` needs, with lists of its own, for its cache to hold
/// `dfa_states_min` states.
pub fn memory_len_min(program: *const Program, entry: u32) usize {
    return lists_len(nodes_of(program, entry)) + cache_len_min(program);
}

/// A row of the table: one entry for each class of octets, and one for each context the text
/// can end in.
fn stride_of(program: *const Program) u32 {
    return @as(u32, program.class_count) + constants.context_count;
}

/// Readies a DFA in `memory`, whose start holds the DFA's own lists. False when the memory is
/// under `memory_len_min`, and the DFA must not be used.
pub fn init(dfa: *Dfa, program: *const Program, config: Config, memory: []u32) bool {
    const lists = lists_len(nodes_of(program, config.entry));
    if (memory.len < lists + cache_len_min(program)) return refuse(dfa);
    return init_sharing(dfa, program, config, memory[0..lists], memory[lists..]);
}

/// Readies a DFA whose lists are `lists`, which the program's other DFA may take too, and whose
/// cache is `memory`. False when `lists` is under `lists_len` of the DFA's nodes or `memory` under
/// `cache_len_min`, and the DFA must not be used.
pub fn init_sharing(dfa: *Dfa, program: *const Program, config: Config, lists: []u32, memory: []u32) bool {
    const block = Block.of(program, config.entry);
    if (lists.len < lists_len(block.nodes) or memory.len < cache_len_min(program)) return refuse(dfa);
    assert(config.valid());
    const len = block.len;
    const nodes = block.nodes;
    // Each list is as long as the larger DFA's nodes, and this DFA takes the start of each.
    const nodes_max: u32 = @intCast((lists.len - 1) / (sparse_lists + node_lists));
    assert(nodes <= nodes_max);
    var rest = lists;
    // The threads, then the stack: the cache packs a record in them when neither is in use.
    const ordered = take(&rest, nodes_max + nodes_max + 1);
    dfa.* = .{
        .instructions = program.instructions,
        .config = config,
        .has_looks = program.has_looks,
        .encoding = program.encoding,
        .may_skip = config.skip and !program.has_looks,
        .classes = program.classes,
        .representatives = undefined,
        .class_count = program.class_count,
        .pair_shift = 0,
        .first_columns = undefined,
        .visited = NodeSet.init(take(&rest, nodes_max)[0..nodes], take(&rest, nodes_max)[0..nodes], program.instructions, len),
        .next = NodeSet.init(take(&rest, nodes_max)[0..nodes], take(&rest, nodes_max)[0..nodes], program.instructions, len),
        .threads = ordered[0..nodes],
        .threads_len = 0,
        .stack = ordered[nodes_max..],
        .stack_len = 0,
        .reached = false,
        .mark = 0,
        .skip = undefined,
        .literal = if (config.literal and config.skip) Literal.of(program, program.has_looks) else null,
        .literals = null,
        .looking = false,
        .skip_known = false,
        .idle = constants.dfa_unknown,
        .skip_visits = 0,
        .skip_octets = 0,
        .skip_off = false,
        .skip_retry_at = 0,
        .skip_poor_trials = 0,
        .second_entry = config.entry,
        .stays = dfa_stay.empty,
        .stays_clears = 0,
        .cache = undefined,
    };
    for (0..constants.octet_values) |octet| {
        const reversed: u8 = @intCast(constants.octet_max - octet);
        dfa.representatives[dfa.classes[reversed]] = reversed;
    }
    ready_literals(dfa, program, config);
    const stride = stride_of(program);
    const pair_stride = pair_stride_of(dfa, program, config, memory.len);
    dfa.cache.init(memory, stride, pair_stride, std.mem.sliceAsBytes(ordered));
    return true;
}

/// Leaves a DFA that `init` refused with no table. A scan of it is a programmer's error, which
/// each scan asserts.
fn refuse(dfa: *Dfa) bool {
    dfa.cache.table = &.{};
    return false;
}

/// Readies claims R2, R3 and R5 for the literals of the DFA's program.
fn ready_literals(dfa: *Dfa, program: *const Program, config: Config) void {
    dfa.looking = program.has_looks and dfa.literal != null;
    // Claim R3 takes `dfa_skip_flag` for its states with no thread.
    if (dfa.looking) dfa.config.stays = false;
    // A program with an assertion has no skip, so claim R5 is for one with none.
    if (config.literal_set and config.skip and dfa.literal == null and !program.has_looks) dfa.literals = LiteralSet.of(program);
    if (dfa.literal) |*literal| literal.wide = config.wide;
    if (dfa.literals) |*set| {
        set.wide = config.wide;
        set.ssse3 = config.ssse3;
    }
}

/// Claim R7's pair stride: zero where the claim is off, the program has too many classes,
/// or the memory holds no pair row beside `dfa_states_min` states.
fn pair_stride_of(dfa: *Dfa, program: *const Program, config: Config, memory_len: usize) u32 {
    if (!config.pairs) return 0;
    const stride = stride_of(program);
    const shift = dfa_pairs.shift_of(program, stride) orelse return 0;
    if (Cache.pair_words(memory_len, stride, stride << shift) == 0) return 0;
    dfa.pair_shift = shift;
    dfa.first_columns = dfa_pairs.first_columns(&dfa.classes, dfa.class_count);
    return stride << shift;
}

fn take(memory: *[]u32, len: usize) []u32 {
    const taken = memory.*[0..len];
    memory.* = memory.*[len..];
    return taken;
}
