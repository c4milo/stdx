//! The candidates of bench-regex (decision 86), each behind the same four calls: compile a
//! pattern, count its matches in a haystack, count the short texts it matches, and sum the
//! offsets of its groups in each text.
//!
//! - stdx's `regex`, by a `Searcher` with the default cache, and by one with no cache, where the
//!   matcher answers alone: the reference path.
//! - Rust's `regex` crate and Go's regexp, from the libraries of bench/regex/rust and
//!   bench/regex/go.
//! - Two libraries in Zig: zig-regex and mvzr, each at the commit build.zig.zon pins. zig-regex's
//!   search does not pass a line feed, so it takes a haystack one line at a time.
//!
//! A batch of texts holds a line feed after each text. A call into Go costs some tens of
//! nanoseconds, so every candidate takes a whole batch or a whole haystack in one call.

const std = @import("std");
const regex = @import("regex");
const ZigRegex = @import("zig_regex").Regex;
const mvzr = @import("mvzr");

pub const Engine = enum { stdx, stdx_matcher, rust, go, zig_regex, mvzr };

/// Each candidate's column, in `Engine`'s order.
pub const names = [_][]const u8{ "stdx", "stdx, matcher alone", "Rust regex", "Go regexp", "zig-regex", "mvzr" };

extern fn rust_regex_new(pattern: [*]const u8, len: usize) callconv(.c) ?*anyopaque;
extern fn rust_regex_free(handle: ?*anyopaque) callconv(.c) void;
extern fn rust_regex_count(handle: *const anyopaque, haystack: [*]const u8, len: usize) callconv(.c) usize;
extern fn rust_regex_matching(handle: *const anyopaque, texts: [*]const u8, len: usize) callconv(.c) usize;
extern fn rust_regex_groups(handle: *const anyopaque, texts: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_new(pattern: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_compile(pattern: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_count(handle: usize, haystack: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_matching(handle: usize, texts: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_groups(handle: usize, texts: [*]const u8, len: usize) callconv(.c) usize;

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

    fn cache_words(engine: Engine) usize {
        return if (engine == .stdx) regex.constants.cache_words_default else 0;
    }

    /// The words of a searcher's memory for any pattern of the benchmark.
    pub fn memory_len(engine: Engine) usize {
        return regex.Searcher.memory_len(storage_len, 2 * groups_max, cache_words(engine));
    }

    /// Compiles `pattern` and readies its searcher: what a caller does before its first search.
    pub fn ready(stdx: *Stdx, engine: Engine, pattern: []const u8) bool {
        stdx.program = regex.compile(pattern, .{}, &stdx.storage) catch return false;
        const len = regex.Searcher.memory_len(stdx.program.forward_len, stdx.program.slot_count(), cache_words(engine));
        stdx.searcher.init(&stdx.program, stdx.memory[0..len]);
        return true;
    }
};

/// A pattern as one candidate compiled it.
pub const Pattern = union(Engine) {
    stdx: *Stdx,
    stdx_matcher: *Stdx,
    rust: *anyopaque,
    go: usize,
    zig_regex: *ZigRegex,
    mvzr: *mvzr.Regex,
};

/// Compiles a pattern for a candidate, or gives null where the candidate refuses it. The pattern
/// lives as long as the arena.
pub fn compile(engine: Engine, arena: std.mem.Allocator, pattern: []const u8) !?Pattern {
    switch (engine) {
        .stdx, .stdx_matcher => {
            const stdx = try arena.create(Stdx);
            stdx.memory = try arena.alloc(u64, Stdx.memory_len(engine));
            if (!stdx.ready(engine, pattern)) return null;
            return if (engine == .stdx) .{ .stdx = stdx } else .{ .stdx_matcher = stdx };
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

    pub fn init(arena: std.mem.Allocator) !Scratch {
        const stdx = try arena.create(Stdx);
        stdx.memory = try arena.alloc(u64, Stdx.memory_len(.stdx));
        return .{ .stdx = stdx };
    }
};

/// Compiles a pattern and keeps nothing: the cost before a first search. False where the
/// candidate refuses the pattern.
pub fn compile_once(engine: Engine, scratch: *const Scratch, pattern: []const u8) bool {
    switch (engine) {
        .stdx, .stdx_matcher => return scratch.stdx.ready(engine, pattern),
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

/// zig-regex's matches in one line. Its search does not pass a line feed, so `zig_regex_count`
/// gives it a haystack one line at a time.
fn zig_regex_count_line(compiled: *ZigRegex, line: []const u8) usize {
    var matches: usize = 0;
    var position: usize = 0;
    while (position <= line.len) {
        var found = (compiled.captures(line[position..]) catch return matches) orelse return matches;
        const span = found.boundsAt(0).?;
        found.deinit();
        matches += 1;
        position += @max(span.upper, span.lower + 1);
    }
    return matches;
}

fn zig_regex_count(compiled: *ZigRegex, haystack: []const u8) usize {
    var matches: usize = 0;
    var lines = std.mem.splitScalar(u8, haystack, '\n');
    while (lines.next()) |line| matches += zig_regex_count_line(compiled, line);
    return matches;
}

fn mvzr_count(compiled: *const mvzr.Regex, haystack: []const u8) usize {
    var found: usize = 0;
    var matches = compiled.iterator(haystack);
    while (matches.next()) |_| found += 1;
    return found;
}

/// The matches of a pattern in a haystack, none inside another.
pub fn count(pattern: Pattern, haystack: []const u8) usize {
    switch (pattern) {
        .stdx, .stdx_matcher => |stdx| {
            var found: usize = 0;
            var matches: regex.Matches = .{ .searcher = &stdx.searcher, .haystack = haystack };
            while (matches.next()) |_| found += 1;
            return found;
        },
        .rust => |handle| return rust_regex_count(handle, haystack.ptr, haystack.len),
        .go => |handle| return go_regex_count(handle, haystack.ptr, haystack.len),
        .zig_regex => |compiled| return zig_regex_count(compiled, haystack),
        .mvzr => |compiled| return mvzr_count(compiled, haystack),
    }
}

/// The texts of a batch, a line feed after each.
const Texts = struct {
    rest: []const u8,

    fn next(texts: *Texts) ?[]const u8 {
        if (texts.rest.len == 0) return null;
        const end = std.mem.indexOfScalar(u8, texts.rest, '\n').?;
        defer texts.rest = texts.rest[end + 1 ..];
        return texts.rest[0..end];
    }
};

/// The texts of a batch that a pattern matches.
pub fn matching(pattern: Pattern, batch: []const u8) usize {
    var texts: Texts = .{ .rest = batch };
    var found: usize = 0;
    switch (pattern) {
        .stdx, .stdx_matcher => |stdx| while (texts.next()) |text| {
            found += @intFromBool(stdx.searcher.is_match(text));
        },
        .rust => |handle| return rust_regex_matching(handle, batch.ptr, batch.len),
        .go => |handle| return go_regex_matching(handle, batch.ptr, batch.len),
        .zig_regex => |compiled| while (texts.next()) |text| {
            found += @intFromBool(compiled.partialMatch(text) catch false);
        },
        .mvzr => |compiled| while (texts.next()) |text| {
            found += @intFromBool(compiled.isMatch(text));
        },
    }
    return found;
}

fn stdx_groups(stdx: *Stdx, batch: []const u8) usize {
    var texts: Texts = .{ .rest = batch };
    var spans: [groups_max]?regex.Span = undefined;
    const found = spans[0..stdx.program.group_count];
    var sum: usize = 0;
    while (texts.next()) |text| {
        if (!stdx.searcher.captures(text, 0, found)) continue;
        for (found) |group| {
            if (group) |span| sum += @intCast(span.start + span.end);
        }
    }
    return sum;
}

fn zig_regex_groups(compiled: *ZigRegex, batch: []const u8) usize {
    var texts: Texts = .{ .rest = batch };
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
pub fn groups(pattern: Pattern, batch: []const u8) ?usize {
    return switch (pattern) {
        .stdx, .stdx_matcher => |stdx| stdx_groups(stdx, batch),
        .rust => |handle| rust_regex_groups(handle, batch.ptr, batch.len),
        .go => |handle| go_regex_groups(handle, batch.ptr, batch.len),
        .zig_regex => |compiled| zig_regex_groups(compiled, batch),
        .mvzr => null,
    };
}

comptime {
    std.debug.assert(names.len == std.meta.fields(Engine).len);
}
