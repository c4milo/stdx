//! How claim R5 reads its literals from a program (literal_set.zig, decision 86 as amended): each
//! path from the forward program's entry, one octet a round.
//!
//! A path takes the octet of each instruction that takes one octet alone, and passes saves and
//! jumps. A split forks it in two, the preferred branch first, so the paths keep the order the
//! alternation prefers. A path ends at `match`, at any instruction that takes more than one
//! octet, at `literal_len_max` octets, and at a split once it holds `literal_fork_len_max`
//! octets. A round that would hold more than `literal_set_max` paths is not taken, and each path
//! keeps the octets it holds. So `(?i)sher` is its 24 case forms, and `Abraham|Isaac` its two
//! words whole. Every match starts with one path's octets, since each path follows the program.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const literal_set = @import("literal_set.zig");
const LiteralSet = literal_set.LiteralSet;

/// One path: the instruction it goes on from, and the octets it took.
const Path = struct {
    next: u32,
    len: u8,
    /// True while the path may take another octet.
    live: bool,
    /// True when the path reached `match` right after its octets: they are a whole match.
    matched: bool,
    octets: [constants.literal_len_max]u8,
};

const Paths = struct {
    paths: [constants.literal_set_max]Path,
    len: usize,

    fn slice(paths: *const Paths) []const Path {
        return paths.paths[0..paths.len];
    }

    fn add(paths: *Paths, path: Path) bool {
        if (paths.len == paths.paths.len) return false;
        paths.paths[paths.len] = path;
        paths.len += 1;
        return true;
    }
};

/// The literals one of which every match of `program` starts with, or null where a path ends
/// before `literal_prefix_len_min` octets, or fewer than `literal_set_count_min` paths stand.
pub fn of(program: *const Program) ?LiteralSet {
    // A program that starts with neither one octet nor a split starts with no literal, and its
    // search does not pay for the paths' frame.
    const first = program.instructions[past_saves(program, program.forward)];
    if (first.kind != .split and first.kind != .ranges and !(first.kind == .range and first.lo == first.hi)) return null;
    return read(program);
}

noinline fn read(program: *const Program) ?LiteralSet {
    var current: Paths = .{ .paths = undefined, .len = 1 };
    current.paths[0] = .{ .next = program.forward, .len = 0, .live = true, .matched = false, .octets = undefined };
    var forked: Paths = .{ .paths = undefined, .len = 0 };
    // Each round adds one octet to each live path, so the rounds are at most its octets.
    for (0..constants.literal_len_max) |_| {
        forked.len = 0;
        if (!round(program, &current, &forked)) break;
        current.paths = forked.paths;
        current.len = forked.len;
        if (!any_live(current.slice())) break;
    }
    return set_of(current.slice());
}

fn any_live(paths: []const Path) bool {
    for (paths) |path| {
        if (path.live) return true;
    }
    return false;
}

/// Adds the next octet of each live path to `forked`, and each path that ends. False where the
/// round would hold more than `literal_set_max` paths, or a path's walk found no octet within the
/// program's instructions: the paths then keep what they hold.
fn round(program: *const Program, current: *const Paths, forked: *Paths) bool {
    for (current.slice()) |path| {
        if (!path.live) {
            if (!forked.add(path)) return false;
            continue;
        }
        if (!fork(program, path, forked)) return false;
    }
    return true;
}

/// The paths `path` goes on to: one for each instruction its splits lead it to, in order of
/// preference, each with that instruction's octet or ended there.
fn fork(program: *const Program, path: Path, forked: *Paths) bool {
    var walk: Walk = .{};
    walk.stack[0] = path.next;
    // Each turn takes one instruction; a path whose walk takes no octet in as many turns as the
    // program has instructions holds a loop of splits and jumps, and ends the read.
    for (0..program.instructions.len) |_| {
        const index = walk.pop() orelse return true;
        if (!visit(program, index, path, &walk, forked)) return false;
    }
    return false;
}

/// The instructions a path's walk still goes to, the preferred one last.
const Walk = struct {
    stack: [constants.literal_set_max]u32 = undefined,
    len: usize = 1,

    fn pop(walk: *Walk) ?u32 {
        if (walk.len == 0) return null;
        walk.len -= 1;
        return walk.stack[walk.len];
    }

    fn push(walk: *Walk, index: u32) bool {
        if (walk.len == walk.stack.len) return false;
        walk.stack[walk.len] = index;
        walk.len += 1;
        return true;
    }
};

/// One instruction of a path's walk. False where `forked` or the walk has no room.
fn visit(program: *const Program, index: u32, path: Path, walk: *Walk, forked: *Paths) bool {
    const instruction = program.instructions[index];
    return switch (instruction.kind) {
        .save, .jump => walk.push(instruction.out),
        // A path past `literal_fork_len_max` octets ends at a split, or at a node of a class.
        .split => if (path.len >= constants.literal_fork_len_max) forked.add(ended(path, false)) else walk.push(instruction.arg) and walk.push(instruction.out),
        .ranges => if (path.len >= constants.literal_fork_len_max) forked.add(ended(path, false)) else fork_members(program, index, path, forked),
        .range => forked.add(took(path, instruction)),
        .match => forked.add(ended(path, true)),
        .look, .fail => forked.add(ended(path, false)),
    };
}

/// The paths after a node of a class: one for each of its ranges, in their order, each as `took`
/// gives it. The ranges take apart octets, so their order chooses nothing.
fn fork_members(program: *const Program, index: u32, path: Path, forked: *Paths) bool {
    for (program.instructions[index + 1 ..][0..program.instructions[index].arg]) |member| {
        if (!forked.add(took(path, member))) return false;
    }
    return true;
}

/// The path after `range`: its octet added where the range takes one octet alone, and ended
/// otherwise.
fn took(path: Path, range: program_file.Instruction) Path {
    if (range.lo != range.hi or path.len == constants.literal_len_max) return ended(path, false);
    var next = path;
    next.octets[next.len] = range.lo;
    next.len += 1;
    next.next = range.out;
    return next;
}

fn ended(path: Path, matched: bool) Path {
    var end = path;
    end.live = false;
    end.matched = matched;
    return end;
}

/// The set of the paths' octets, each cut to the shortest's length for Teddy's last octet.
fn set_of(paths: []const Path) ?LiteralSet {
    if (paths.len < constants.literal_set_count_min) return null;
    var set: LiteralSet = .{ .octets = undefined, .count = @intCast(paths.len), .len = constants.literal_len_max, .exact = true };
    for (paths, 0..) |path, index| {
        if (path.len < constants.literal_prefix_len_min) return null;
        @memcpy(set.octets[index][0..path.len], path.octets[0..path.len]);
        set.lens[index] = path.len;
        set.len = @min(set.len, path.len);
        set.exact = set.exact and path.matched;
    }
    set.prepare();
    return set;
}

/// Follows saves and jumps from `entry`, which take no octet: each instruction once.
fn past_saves(program: *const Program, entry: u32) u32 {
    var index = entry;
    for (0..program.instructions.len) |_| {
        const instruction = program.instructions[index];
        if (instruction.kind != .save and instruction.kind != .jump) return index;
        index = instruction.out;
    }
    return index;
}
