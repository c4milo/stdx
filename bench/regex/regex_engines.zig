//! The candidates of bench-regex (decision 86), each behind the same four calls: compile a
//! pattern, find its matches in a haystack, count the short texts it matches, and sum the
//! offsets of its groups in each text.
//!
//! - stdx's `regex`, by a `Searcher` with the default cache; by one with claims R1 to R5 off,
//!   which skips to no start octet and no literal; and by one with no cache, where the matcher answers alone: the
//!   reference path. A second searcher like the first is timed last in each round, `stdx,
//!   again`: stdx over it shows how far one code path differs from itself.
//! - Rust's `regex` crate and Go's regexp, from the libraries of bench/regex/rust and
//!   bench/regex/go.
//! - Two libraries in Zig: zig-regex and mvzr, each at the commit build.zig.zon pins. zig-regex's
//!   search does not pass a line feed, so it takes a haystack one line at a time.
//!
//! A search gives the count of the matches and the sum of each match's start and end, so every
//! candidate finds both ends of a match. A batch of texts is the texts one after another and the
//! offset where each ends, so no candidate looks for a text's end while the clock runs. A call
//! into Go costs some tens of nanoseconds, so every candidate takes a whole batch or a whole
//! haystack in one call.

const std = @import("std");
const codec = @import("codec");
const regex = @import("regex");
const ZigRegex = @import("zig_regex").Regex;
const mvzr = @import("mvzr");

/// The candidates, in the order the first round times them. Each round after it starts one
/// candidate later, and `stdx_again` stays last (`timing.time_rotated`).
pub const Engine = enum { stdx, stdx_no_skip, stdx_matcher, rust, go, zig_regex, mvzr, stdx_again };

/// Each candidate's column, in `Engine`'s order.
pub const names = [_][]const u8{ "stdx", "stdx, no skip", "stdx, matcher alone", "Rust regex", "Go regexp", "zig-regex", "mvzr", "stdx, again" };

extern fn rust_regex_new(pattern: [*]const u8, len: usize) callconv(.c) ?*anyopaque;
extern fn rust_regex_free(handle: ?*anyopaque) callconv(.c) void;
extern fn rust_regex_find_all(handle: *const anyopaque, haystack: [*]const u8, len: usize, offsets: *u64) callconv(.c) usize;
extern fn rust_regex_matching(handle: *const anyopaque, octets: [*]const u8, ends: [*]const u32, count: usize) callconv(.c) usize;
extern fn rust_regex_groups(handle: *const anyopaque, octets: [*]const u8, ends: [*]const u32, count: usize) callconv(.c) usize;
extern fn go_regex_new(pattern: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_compile(pattern: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_find_all(handle: usize, haystack: [*]const u8, len: usize, offsets: *u64) callconv(.c) usize;
extern fn go_regex_matching(handle: usize, octets: [*]const u8, ends: [*]const u32, count: usize) callconv(.c) usize;
extern fn go_regex_groups(handle: usize, octets: [*]const u8, ends: [*]const u32, count: usize) callconv(.c) usize;

/// The instructions a pattern of the benchmark takes at most, and the groups it holds at most.
const storage_len = 4096;
const groups_max = 8;

/// zig-regex takes an allocator and frees what a call takes, so libc's serves it, as it serves a
/// program that links libc.
const zig_regex_allocator = std.heap.c_allocator;

/// stdx's side of one pattern: its program, and a searcher that lives as long as the pattern.
pub const Stdx = struct {
    storage: [storage_len]regex.Instruction,
    memory: []u64,
    program: regex.Program,
    searcher: regex.Searcher,
    /// The host's CPU features, which `main` detects once, as Rust's crate detects them once.
    features: codec.Features,

    fn cache_words(engine: Engine) usize {
        return if (engine == .stdx_matcher) 0 else regex.constants.cache_words_default;
    }

    /// The words of a searcher's memory for any pattern of the benchmark.
    pub fn memory_len(engine: Engine) usize {
        return regex.Searcher.memory_len(storage_len, 2 * groups_max, cache_words(engine));
    }

    /// Compiles `pattern` and readies its searcher: what a caller does before its first search.
    pub fn ready(stdx: *Stdx, engine: Engine, pattern: []const u8) bool {
        stdx.program = regex.compile(pattern, .{}, &stdx.storage) catch return false;
        const len = regex.Searcher.memory_len(stdx.program.forward_len, stdx.program.slot_count(), cache_words(engine));
        stdx.searcher.init(&stdx.program, &.{ .features = stdx.features, .claims = .{ .start_skip = engine != .stdx_no_skip } }, stdx.memory[0..len]);
        return true;
    }
};

/// A pattern as one candidate compiled it.
pub const Pattern = union(Engine) {
    stdx: *Stdx,
    stdx_no_skip: *Stdx,
    stdx_matcher: *Stdx,
    rust: *anyopaque,
    go: usize,
    zig_regex: *ZigRegex,
    mvzr: *mvzr.Regex,
    stdx_again: *Stdx,
};

/// Compiles a pattern for a candidate, or gives null where the candidate refuses it. The pattern
/// lives as long as the arena.
pub fn compile(engine: Engine, arena: std.mem.Allocator, features: codec.Features, pattern: []const u8) !?Pattern {
    switch (engine) {
        .stdx, .stdx_no_skip, .stdx_matcher, .stdx_again => {
            const stdx = try arena.create(Stdx);
            stdx.memory = try arena.alloc(u64, Stdx.memory_len(engine));
            stdx.features = features;
            if (!stdx.ready(engine, pattern)) return null;
            return switch (engine) {
                .stdx => .{ .stdx = stdx },
                .stdx_no_skip => .{ .stdx_no_skip = stdx },
                .stdx_again => .{ .stdx_again = stdx },
                else => .{ .stdx_matcher = stdx },
            };
        },
        .rust => return if (rust_regex_new(pattern.ptr, pattern.len)) |handle| .{ .rust = handle } else null,
        .go => {
            const handle = go_regex_new(pattern.ptr, pattern.len);
            return if (handle == 0) null else .{ .go = handle };
        },
        .zig_regex => {
            const compiled = try arena.create(ZigRegex);
            compiled.* = ZigRegex.compile(zig_regex_allocator, pattern) catch return null;
            return .{ .zig_regex = compiled };
        },
        .mvzr => {
            const compiled = try arena.create(mvzr.Regex);
            compiled.* = mvzr.compile(pattern) orelse return null;
            return .{ .mvzr = compiled };
        },
    }
}

/// What a candidate needs to compile a pattern again and again: stdx's storage and memory.
pub const Scratch = struct {
    stdx: *Stdx,

    pub fn init(arena: std.mem.Allocator, features: codec.Features) !Scratch {
        const stdx = try arena.create(Stdx);
        stdx.memory = try arena.alloc(u64, Stdx.memory_len(.stdx));
        stdx.features = features;
        return .{ .stdx = stdx };
    }
};

/// Compiles a pattern and keeps nothing: the cost before a first search. False where the
/// candidate refuses the pattern.
pub fn compile_once(engine: Engine, scratch: *const Scratch, pattern: []const u8) bool {
    switch (engine) {
        .stdx, .stdx_no_skip, .stdx_matcher, .stdx_again => return scratch.stdx.ready(engine, pattern),
        .rust => {
            const handle = rust_regex_new(pattern.ptr, pattern.len) orelse return false;
            rust_regex_free(handle);
            return true;
        },
        .go => return go_regex_compile(pattern.ptr, pattern.len) != 0,
        .zig_regex => {
            var compiled = ZigRegex.compile(zig_regex_allocator, pattern) catch return false;
            compiled.deinit();
            return true;
        },
        .mvzr => {
            const compiled = mvzr.compile(pattern) orelse return false;
            std.mem.doNotOptimizeAway(&compiled);
            return true;
        },
    }
}

/// What a search of a haystack found: the matches, none inside another, and the sum of each
/// match's start and end.
pub const Found = struct {
    matches: usize = 0,
    offsets: u64 = 0,

    fn add(found: *Found, start: u64, end: u64) void {
        found.matches += 1;
        found.offsets += start + end;
    }
};

/// zig-regex's matches in one line, which starts at `base` in its haystack. Its search does not
/// pass a line feed, so `zig_regex_find_all` gives it a haystack one line at a time.
fn zig_regex_find_line(compiled: *ZigRegex, line: []const u8, base: usize, found: *Found) void {
    var position: usize = 0;
    while (position <= line.len) {
        var captures = (compiled.captures(line[position..]) catch return) orelse return;
        const span = captures.boundsAt(0).?;
        captures.deinit();
        found.add(base + position + span.lower, base + position + span.upper);
        position += @max(span.upper, span.lower + 1);
    }
}

fn zig_regex_find_all(compiled: *ZigRegex, haystack: []const u8) Found {
    var found: Found = .{};
    var lines = std.mem.splitScalar(u8, haystack, '\n');
    while (lines.next()) |line| zig_regex_find_line(compiled, line, @intFromPtr(line.ptr) - @intFromPtr(haystack.ptr), &found);
    return found;
}

fn mvzr_find_all(compiled: *const mvzr.Regex, haystack: []const u8) Found {
    var found: Found = .{};
    var matches = compiled.iterator(haystack);
    while (matches.next()) |match| found.add(match.start, match.end);
    return found;
}

fn stdx_find_all(stdx: *Stdx, haystack: []const u8) Found {
    var found: Found = .{};
    var matches: regex.Matches = .{ .searcher = &stdx.searcher, .haystack = haystack };
    while (matches.next()) |span| found.add(span.start, span.end);
    return found;
}

/// The matches of a pattern in a haystack, none inside another.
pub fn find_all(pattern: Pattern, haystack: []const u8) Found {
    var found: Found = .{};
    switch (pattern) {
        .stdx, .stdx_no_skip, .stdx_matcher, .stdx_again => |stdx| return stdx_find_all(stdx, haystack),
        .rust => |handle| found.matches = rust_regex_find_all(handle, haystack.ptr, haystack.len, &found.offsets),
        .go => |handle| found.matches = go_regex_find_all(handle, haystack.ptr, haystack.len, &found.offsets),
        .zig_regex => |compiled| return zig_regex_find_all(compiled, haystack),
        .mvzr => |compiled| return mvzr_find_all(compiled, haystack),
    }
    return found;
}

/// A batch of texts: the texts one after another, and the offset where each ends.
pub const Texts = struct {
    octets: []const u8,
    ends: []const u32,

    /// The texts in turn.
    const Walk = struct {
        texts: Texts,
        index: usize = 0,
        start: usize = 0,

        fn next(walk: *Walk) ?[]const u8 {
            if (walk.index == walk.texts.ends.len) return null;
            const end = walk.texts.ends[walk.index];
            defer walk.start = end;
            walk.index += 1;
            return walk.texts.octets[walk.start..end];
        }
    };

    fn in_turn(texts: Texts) Walk {
        return .{ .texts = texts };
    }
};

/// The texts of a batch that a pattern matches.
pub fn matching(pattern: Pattern, batch: Texts) usize {
    var texts = batch.in_turn();
    var found: usize = 0;
    switch (pattern) {
        .stdx, .stdx_no_skip, .stdx_matcher, .stdx_again => |stdx| while (texts.next()) |text| {
            found += @intFromBool(stdx.searcher.is_match(text));
        },
        .rust => |handle| return rust_regex_matching(handle, batch.octets.ptr, batch.ends.ptr, batch.ends.len),
        .go => |handle| return go_regex_matching(handle, batch.octets.ptr, batch.ends.ptr, batch.ends.len),
        .zig_regex => |compiled| while (texts.next()) |text| {
            found += @intFromBool(compiled.partialMatch(text) catch false);
        },
        .mvzr => |compiled| while (texts.next()) |text| {
            found += @intFromBool(compiled.isMatch(text));
        },
    }
    return found;
}

fn stdx_groups(stdx: *Stdx, batch: Texts) usize {
    var texts = batch.in_turn();
    var sum: usize = 0;
    while (texts.next()) |text| {
        const found = stdx.searcher.captures(text, 0) orelse continue;
        for (0..found.len()) |index| {
            if (found.get(index)) |span| sum += @intCast(span.start + span.end);
        }
    }
    return sum;
}

fn zig_regex_groups(compiled: *ZigRegex, batch: Texts) usize {
    var texts = batch.in_turn();
    var sum: usize = 0;
    while (texts.next()) |text| {
        var found = (compiled.captures(text) catch continue) orelse continue;
        defer found.deinit();
        for (0..found.len()) |group| {
            if (found.boundsAt(group)) |span| sum += span.lower + span.upper;
        }
    }
    return sum;
}

/// The sum of the start and the end of each group of a pattern's first match in each text of a
/// batch, or null where the candidate gives no groups.
pub fn groups(pattern: Pattern, batch: Texts) ?usize {
    return switch (pattern) {
        .stdx, .stdx_no_skip, .stdx_matcher, .stdx_again => |stdx| stdx_groups(stdx, batch),
        .rust => |handle| rust_regex_groups(handle, batch.octets.ptr, batch.ends.ptr, batch.ends.len),
        .go => |handle| go_regex_groups(handle, batch.octets.ptr, batch.ends.ptr, batch.ends.len),
        .zig_regex => |compiled| zig_regex_groups(compiled, batch),
        .mvzr => null,
    };
}

comptime {
    std.debug.assert(names.len == std.meta.fields(Engine).len);
}
