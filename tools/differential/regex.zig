//! `zig build differential-regex -Doracles`: design §8 step 22's check of the `regex` module
//! against Go's regexp and against RE2's own test logs (decision 86).
//!
//! - Generated cases: `cases_per_seed` patterns and texts for each seed of `seeds`, from
//!   regex_generate.zig. stdx must give each the groups Go's regexp gives, by a searcher with a
//!   cache and by the matcher alone.
//! - RE2's logs: each pattern over each text of `re2-search.txt` and `re2-exhaustive.txt.bz2`,
//!   as Go's tree holds them, pinned by SHA-256 in build/oracle_regex.zig. stdx must give RE2's
//!   leftmost-first groups for a match anywhere in the text and for a match of the whole text.
//!
//! A difference passes only where an entry of tools/oracle/verdicts_regex.zig allows it. Each
//! log must also give the count of equal answers `expected_equal` pins, so a refusal that an
//! entry allows cannot grow unseen.
//!
//! Usage: `differential_regex <re2-search.txt> <re2-exhaustive.txt.bz2>`. Exit status 0 when
//! every case agrees or is allowed, 1 when any is not, 2 on a usage error.

const std = @import("std");
const codec = @import("codec");
const regex = @import("regex");
const oracle = @import("oracle_regexp");
const verdicts = @import("verdicts");
const answers = @import("regex_answer.zig");
const generate = @import("regex_generate.zig");
const re2_log = @import("regex_re2_log.zig");

const Answer = answers.Answer;
const Stdx = answers.Stdx;

/// The seeds of the generated cases, and the cases each gives: a million in all.
const seeds = [_]u64{ 0x5EED_0001, 0x5EED_0002, 0x5EED_0003, 0x5EED_0004 };
const cases_per_seed = 250_000;

/// The cache of the searcher that answers first. The matcher then answers alone, with none.
const cache_words = regex.constants.cache_words_default;

/// The octets RE2's exhaustive log decodes to at most. It holds 64.5 MB.
const exhaustive_len_max = 128 * 1024 * 1024;

/// The cases of each log whose answers stdx gives as RE2 does, with the logs as pinned. A change
/// to what stdx refuses changes a count, in the commit that makes the change.
const expected_equal = struct {
    const search = 3_424;
    const exhaustive = 10_410_991;
};

/// The failures the check prints before it only counts them.
const printed_failures_max = 20;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// Counts for the report.
const Tally = struct {
    cases: usize = 0,
    equal: usize = 0,
    /// Cases whose pattern stdx and the oracle both refuse.
    both_refuse: usize = 0,
    /// Generated patterns past the generator's buffer, which were left out.
    too_long: usize = 0,
    allowed: usize = 0,
    allowed_by: [verdicts.entries.len]usize = @splat(0),
    failures: usize = 0,
};

/// What every case of the check shares: stdx's patterns in storage of their own, and the tally.
const Check = struct {
    /// The pattern of the case, and for a case of a log the same pattern between `\A(?:` and
    /// `)\z`.
    stdx: *Stdx,
    second: *Stdx,
    tally: Tally = .{},
    name: []const u8,

    fn fail(check: *Check, pattern: []const u8, text: []const u8, what: []const u8, ours: *const Answer, theirs: *const Answer) void {
        check.tally.failures += 1;
        if (check.tally.failures > printed_failures_max) return;
        std.debug.print("differential-regex FAILED: {s}: {s}: pattern \"{f}\", text \"{f}\": stdx ", .{
            check.name, what, std.zig.fmtString(pattern), std.zig.fmtString(text),
        });
        ours.print();
        std.debug.print("; oracle ", .{});
        theirs.print();
        std.debug.print("\n", .{});
    }

    /// Counts a case whose answers are known: equal, allowed by an entry, or a failure.
    fn judge(check: *Check, facts: verdicts.Facts, ours: *const Answer, theirs: *const Answer) void {
        check.tally.cases += 1;
        if (ours.eql(theirs)) {
            if (ours.kind == .refused) check.tally.both_refuse += 1 else check.tally.equal += 1;
            return;
        }
        if (verdicts.find(facts)) |index| {
            check.tally.allowed += 1;
            check.tally.allowed_by[index] += 1;
            return;
        }
        check.fail(facts.pattern, facts.text, "no verdict entry allows the difference", ours, theirs);
    }
};

/// Go's answer for a pattern and a text.
fn go_answer(pattern: []const u8, text: []const u8) Answer {
    var answer: Answer = .{ .kind = .none };
    switch (oracle.find(pattern, text, &answer.offsets)) {
        .refused, .groups_too_many => answer.kind = .refused,
        .none => {},
        .groups => |groups| {
            answer.kind = .match;
            answer.groups = groups;
        },
    }
    return answer;
}

/// stdx's answer by the searcher with its cache, which the matcher alone must give too.
fn stdx_answer(check: *Check, stdx: *Stdx, pattern: []const u8, text: []const u8) Answer {
    const cached = stdx.answer(text, cache_words);
    const alone = stdx.answer(text, 0);
    if (!cached.eql(&alone)) check.fail(pattern, text, "the searcher and the matcher differ; the matcher is shown as the oracle", &cached, &alone);
    return cached;
}

fn facts_of(oracle_kind: verdicts.Oracle, pattern: []const u8, text: []const u8, ours: *const Answer, theirs: *const Answer) verdicts.Facts {
    return .{
        .oracle = oracle_kind,
        .pattern = pattern,
        .text = text,
        .stdx_error = ours.refusal,
        .oracle_refused = theirs.kind == .refused,
        .oracle_match = theirs.whole(),
    };
}

/// One generated case against Go's regexp.
fn check_generated(check: *Check, case: *const generate.Case) void {
    const pattern = case.pattern.slice();
    const text = case.text[0..case.text_len];
    check.stdx.compile(pattern);
    const ours = stdx_answer(check, check.stdx, pattern, text);
    const theirs = go_answer(pattern, text);
    check.judge(facts_of(.go, pattern, text, &ours, &theirs), &ours, &theirs);
}

fn check_seeds(check: *Check) void {
    var case: generate.Case = .{};
    for (seeds) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        for (0..cases_per_seed) |_| {
            generate.next(&generator, &case);
            if (case.overflowed()) {
                check.tally.too_long += 1;
                continue;
            }
            check_generated(check, &case);
        }
    }
}

/// One result of a log's case: stdx's answer for `pattern` against the groups RE2 recorded.
fn check_result(check: *Check, stdx: *Stdx, pattern: []const u8, text: []const u8, result: []const u8) re2_log.Error!void {
    const theirs = try re2_log.parse_result(result);
    const ours = stdx_answer(check, stdx, pattern, text);
    var facts = facts_of(.re2, pattern, text, &ours, &theirs);
    if (!ours.eql(&theirs) and ours.kind != .refused) {
        const go = go_answer(pattern, text);
        facts.go_agrees_with_stdx = go.eql(&ours);
    }
    check.judge(facts, &ours, &theirs);
}

/// The pattern that matches where `pattern` matches the whole text, as Go's tests of these logs
/// write it.
fn whole_pattern(arena: std.mem.Allocator, pattern: []const u8) ![]const u8 {
    return std.mem.concat(arena, u8, &.{ "\\A(?:", pattern, ")\\z" });
}

/// Every case of one log.
fn check_log(check: *Check, gpa: std.mem.Allocator, log: []const u8) !void {
    var reader = re2_log.Reader.init(gpa, log);
    defer reader.deinit();
    var pattern_arena = std.heap.ArenaAllocator.init(gpa);
    defer pattern_arena.deinit();
    var whole: []const u8 = "";
    while (try reader.next()) |case| {
        if (case.first_of_pattern) {
            _ = pattern_arena.reset(.retain_capacity);
            whole = try whole_pattern(pattern_arena.allocator(), case.pattern);
            check.stdx.compile(case.pattern);
            check.second.compile(whole);
        }
        try check_result(check, check.stdx, case.pattern, case.text, case.anywhere);
        try check_result(check, check.second, whole, case.text, case.whole);
    }
}

fn report(check: *const Check, oracle_kind: verdicts.Oracle) void {
    const tally = check.tally;
    std.debug.print("differential-regex: {s}: {d} cases, {d} equal, {d} refused by both, {d} allowed, {d} failed", .{
        check.name, tally.cases, tally.equal, tally.both_refuse, tally.allowed, tally.failures,
    });
    if (tally.too_long != 0) std.debug.print(", {d} patterns too long left out", .{tally.too_long});
    std.debug.print("\n", .{});
    for (verdicts.entries, tally.allowed_by) |entry, allowed| {
        if (entry.oracle == oracle_kind) std.debug.print("differential-regex:   {d} allowed: {s}\n", .{ allowed, entry.shape });
    }
}

/// The failures of a log's check, one more when its count of equal answers is not the pinned one.
fn log_failures(check: *const Check, expected: usize) usize {
    if (check.tally.equal == expected) return check.tally.failures;
    std.debug.print("differential-regex FAILED: {s}: {d} equal answers, and {d} are pinned\n", .{ check.name, check.tally.equal, expected });
    return check.tally.failures + 1;
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len != 3) {
        std.debug.print("usage: differential_regex <re2-search.txt> <re2-exhaustive.txt.bz2>\n", .{});
        std.process.exit(usage_exit_status);
    }
    var first_pattern = try Stdx.init(arena);
    var second_pattern = try Stdx.init(arena);
    const stdx = &first_pattern;
    const second = &second_pattern;

    var generated: Check = .{ .stdx = stdx, .second = second, .name = "Go's regexp, generated cases" };
    check_seeds(&generated);
    report(&generated, .go);

    const search_log = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], arena, .unlimited);
    var search: Check = .{ .stdx = stdx, .second = second, .name = "RE2's search log" };
    try check_log(&search, arena, search_log);
    report(&search, .re2);

    const packed_log = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], arena, .unlimited);
    const exhaustive_log = oracle.bzip2_decode(packed_log, try arena.alloc(u8, exhaustive_len_max)) orelse {
        std.debug.print("differential-regex FAILED: {s} is no bzip2 stream of at most {d} octets\n", .{ args[2], exhaustive_len_max });
        std.process.exit(1);
    };
    var exhaustive: Check = .{ .stdx = stdx, .second = second, .name = "RE2's exhaustive log" };
    try check_log(&exhaustive, arena, exhaustive_log);
    report(&exhaustive, .re2);

    const failures = generated.tally.failures + log_failures(&search, expected_equal.search) + log_failures(&exhaustive, expected_equal.exhaustive);
    std.debug.print("differential-regex: {d} cases, {d} failed\n", .{ generated.tally.cases + search.tally.cases + exhaustive.tally.cases, failures });
    if (failures != 0) std.process.exit(1);
}

test {
    _ = answers;
    _ = generate;
    _ = re2_log;
}
