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
//! The work is cut into tasks, a seed or a part of a log each, which a thread for each core takes
//! in turn. Each thread holds its patterns' storage and a slot of the Go oracle, and the counts
//! are sums, so the verdict is the same for any count of threads.
//!
//! Usage: `differential_regex <re2-search.txt> <re2-exhaustive.txt.bz2>`. Exit status 0 when
//! every case agrees or is allowed, 1 when any is not, 2 on a usage error.

const std = @import("std");
const codec = @import("codec");
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

/// The most threads that take the tasks: the check starts one for each core, up to this count.
/// The exhaustive log is cut into `exhaustive_parts`, so that each thread has work until the
/// last part.
const workers_max = 16;
const exhaustive_parts = 64;

/// The line that starts a list of texts in a log. A reader needs nothing of the log before it.
const texts_line = "\nstrings\n";

/// The octets RE2's exhaustive log decodes to at most. It holds 64.5 MB.
const exhaustive_len_max = 128 * 1024 * 1024;

/// The cases of each log whose answers stdx gives as RE2 does, with the logs as pinned. A change
/// to what stdx refuses changes a count, in the commit that makes the change.
const expected_equal = struct {
    /// 3,424 until stdx took `\\p{...}` and `(?i)` past ASCII (decision 86 as amended).
    const search = 3_616;
    const exhaustive = 10_410_991;
};

/// The failures a task prints before it only counts them, and the octets of one failure's line.
const printed_failures_max = 20;
const failure_line_len = 4096;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// The generated cases whose program may pass the storage of regex_answer.zig: a property under
/// quantifiers nested three deep takes up to 81 copies, which a few cases in a million make. Each
/// is left out, since `NoSpaceLeft` names the caller's storage and no refusal of the pattern
/// (errors.zig). More than this many fails the check, so a compile that refuses for room where it
/// should not cannot leave cases out unseen.
const programs_too_large_max = 16;

/// The name of the error that says a program does not fit its storage.
const no_space_left = "NoSpaceLeft";

/// Counts for the report.
const Tally = struct {
    cases: usize = 0,
    equal: usize = 0,
    /// Cases whose pattern stdx and the oracle both refuse.
    both_refuse: usize = 0,
    /// Generated patterns past the generator's buffer, which were left out.
    too_long: usize = 0,
    /// Generated patterns whose program passes the storage, which were left out.
    too_large: usize = 0,
    allowed: usize = 0,
    allowed_by: [verdicts.entries.len]usize = @splat(0),
    failures: usize = 0,

    fn add(tally: *Tally, other: Tally) void {
        inline for (.{ "cases", "equal", "both_refuse", "too_long", "too_large", "allowed", "failures" }) |field| {
            @field(tally, field) += @field(other, field);
        }
        for (&tally.allowed_by, other.allowed_by) |*count, more| count.* += more;
    }
};

/// The three parts of the check, each with the name its lines carry and its oracle.
const Phase = enum {
    generated,
    search,
    exhaustive,

    fn name(phase: Phase) []const u8 {
        return switch (phase) {
            .generated => "Go's regexp, generated cases",
            .search => "RE2's search log",
            .exhaustive => "RE2's exhaustive log",
        };
    }

    fn oracle_kind(phase: Phase) verdicts.Oracle {
        return if (phase == .generated) .go else .re2;
    }
};

/// One thread's share of a phase: a seed's cases, or a part of a log.
const Task = struct {
    phase: Phase,
    work: union(enum) { seed: u64, log: []const u8 },
    tally: Tally = .{},
};

/// What one thread holds: stdx's patterns in storage of their own, and a slot of the Go oracle.
const Worker = struct {
    /// The pattern of the case, and for a case of a log the same pattern between `\A(?:` and
    /// `)\z`.
    stdx: Stdx,
    second: Stdx,
    slot: usize,
};

/// A task as a worker runs it.
const Check = struct {
    worker: *Worker,
    phase: Phase,
    tally: Tally = .{},

    fn fail(check: *Check, pattern: []const u8, text: []const u8, what: []const u8, ours: *const Answer, theirs: *const Answer) void {
        check.tally.failures += 1;
        if (check.tally.failures > printed_failures_max) return;
        // One line in one call, so that two threads' lines do not mix.
        var buffer: [failure_line_len]u8 = undefined;
        var line: std.Io.Writer = .fixed(&buffer);
        write_failure(&line, check.phase, pattern, text, what, ours, theirs) catch {};
        std.debug.print("{s}\n", .{line.buffered()});
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

fn write_failure(line: *std.Io.Writer, phase: Phase, pattern: []const u8, text: []const u8, what: []const u8, ours: *const Answer, theirs: *const Answer) std.Io.Writer.Error!void {
    try line.print("differential-regex FAILED: {s}: {s}: pattern \"{f}\", text \"{f}\": stdx ", .{
        phase.name(), what, std.zig.fmtString(pattern), std.zig.fmtString(text),
    });
    try ours.write(line);
    try line.writeAll("; oracle ");
    try theirs.write(line);
}

/// Go's answer for a pattern and a text.
fn go_answer(slot: usize, pattern: []const u8, text: []const u8) Answer {
    var answer: Answer = .{ .kind = .none };
    switch (oracle.find(slot, pattern, text, &answer.offsets)) {
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
    const cached = stdx.answer(text, .cached);
    const alone = stdx.answer(text, .alone);
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

/// The cases of one seed against Go's regexp.
fn check_seed(check: *Check, seed: u64) void {
    const stdx = &check.worker.stdx;
    var case: generate.Case = .{};
    var generator = codec.testing.split.Generator.init(seed);
    for (0..cases_per_seed) |_| {
        generate.next(&generator, &case);
        if (case.overflowed()) {
            check.tally.too_long += 1;
            continue;
        }
        const pattern = case.pattern.slice();
        const text = case.text[0..case.text_len];
        stdx.compile(pattern);
        if (std.mem.eql(u8, stdx.refusal, no_space_left)) {
            check.tally.too_large += 1;
            continue;
        }
        const ours = stdx_answer(check, stdx, pattern, text);
        const theirs = go_answer(check.worker.slot, pattern, text);
        check.judge(facts_of(.go, pattern, text, &ours, &theirs), &ours, &theirs);
    }
}

/// One result of a log's case: stdx's answer for `pattern` against the groups RE2 recorded.
fn check_result(check: *Check, stdx: *Stdx, pattern: []const u8, text: []const u8, result: []const u8) re2_log.Error!void {
    const theirs = try re2_log.parse_result(result);
    const ours = stdx_answer(check, stdx, pattern, text);
    var facts = facts_of(.re2, pattern, text, &ours, &theirs);
    if (!ours.eql(&theirs) and ours.kind != .refused) {
        const go = go_answer(check.worker.slot, pattern, text);
        facts.go_agrees_with_stdx = go.eql(&ours);
    }
    check.judge(facts, &ours, &theirs);
}

/// The pattern that matches where `pattern` matches the whole text, as Go's tests of these logs
/// write it.
fn whole_pattern(arena: std.mem.Allocator, pattern: []const u8) ![]const u8 {
    return std.mem.concat(arena, u8, &.{ "\\A(?:", pattern, ")\\z" });
}

/// Every case of one log, or of a part of one that starts at a list of texts.
fn check_log(check: *Check, log: []const u8) !void {
    // The page allocator serves any thread. A reader and the arena below keep what they take, so
    // a task asks it for little.
    var reader = re2_log.Reader.init(std.heap.page_allocator, log);
    defer reader.deinit();
    var pattern_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer pattern_arena.deinit();
    const worker = check.worker;
    var whole: []const u8 = "";
    while (try reader.next()) |case| {
        if (case.first_of_pattern) {
            _ = pattern_arena.reset(.retain_capacity);
            whole = try whole_pattern(pattern_arena.allocator(), case.pattern);
            worker.stdx.compile(case.pattern);
            worker.second.compile(whole);
        }
        try check_result(check, &worker.stdx, case.pattern, case.text, case.anywhere);
        try check_result(check, &worker.second, whole, case.text, case.whole);
    }
}

fn run_task(task: *Task, worker: *Worker) void {
    var check: Check = .{ .worker = worker, .phase = task.phase };
    switch (task.work) {
        .seed => |seed| check_seed(&check, seed),
        .log => |log| check_log(&check, log) catch |err| {
            check.tally.failures += 1;
            std.debug.print("differential-regex FAILED: {s}: the log does not read: {s}\n", .{ task.phase.name(), @errorName(err) });
        },
    }
    task.tally = check.tally;
}

/// The tasks, and the next one no thread has taken.
const Queue = struct {
    tasks: []Task,
    next: std.atomic.Value(usize) = .init(0),

    fn work(queue: *Queue, worker: *Worker) void {
        for (0..queue.tasks.len) |_| {
            const index = queue.next.fetchAdd(1, .monotonic);
            if (index >= queue.tasks.len) return;
            run_task(&queue.tasks[index], worker);
        }
    }
};

/// Cuts a log into parts of about one size, each from a line that starts a list of texts, and
/// gives the parts it wrote.
fn cut_log(log: []const u8, parts: [][]const u8) [][]const u8 {
    var start: usize = 0;
    var count: usize = 0;
    for (1..parts.len) |index| {
        const target = log.len / parts.len * index;
        if (target <= start) continue;
        const line = std.mem.indexOfPos(u8, log, target, texts_line) orelse break;
        parts[count] = log[start .. line + 1];
        count += 1;
        start = line + 1;
    }
    parts[count] = log[start..];
    return parts[0 .. count + 1];
}

fn report(phase: Phase, tally: Tally) void {
    std.debug.print("differential-regex: {s}: {d} cases, {d} equal, {d} refused by both, {d} allowed, {d} failed", .{
        phase.name(), tally.cases, tally.equal, tally.both_refuse, tally.allowed, tally.failures,
    });
    if (tally.too_long != 0) std.debug.print(", {d} patterns too long left out", .{tally.too_long});
    if (tally.too_large != 0) std.debug.print(", {d} programs too large left out", .{tally.too_large});
    std.debug.print("\n", .{});
    for (verdicts.entries, tally.allowed_by) |entry, allowed| {
        if (entry.oracle == phase.oracle_kind()) std.debug.print("differential-regex:   {d} allowed: {s}\n", .{ allowed, entry.shape });
    }
}

/// The failures of the generated cases, one more when more programs passed the storage than
/// `programs_too_large_max`.
fn generated_failures(tally: Tally) usize {
    return tally.failures + @intFromBool(tally.too_large > programs_too_large_max);
}

/// The failures of a log's check, one more when its count of equal answers is not the pinned one.
fn log_failures(phase: Phase, tally: Tally, expected: usize) usize {
    if (tally.equal == expected) return tally.failures;
    std.debug.print("differential-regex FAILED: {s}: {d} equal answers, and {d} are pinned\n", .{ phase.name(), tally.equal, expected });
    return tally.failures + 1;
}

/// Runs every task on a thread for each core, `workers_max` at most, each with patterns' storage
/// of its own. The tallies are sums, so the count of threads changes no result.
fn run(arena: std.mem.Allocator, tasks: []Task) !void {
    comptime std.debug.assert(workers_max <= oracle.slots_max);
    const cores = std.Thread.getCpuCount() catch 1;
    const workers = try arena.alloc(Worker, @max(1, @min(cores, workers_max)));
    for (workers, 0..) |*worker, slot| worker.* = .{ .stdx = try Stdx.init(arena), .second = try Stdx.init(arena), .slot = slot };
    var queue: Queue = .{ .tasks = tasks };
    var threads: [workers_max]std.Thread = undefined;
    for (threads[0..workers.len], workers) |*thread, *worker| thread.* = try std.Thread.spawn(.{}, Queue.work, .{ &queue, worker });
    for (threads[0..workers.len]) |thread| thread.join();
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len != 3) {
        std.debug.print("usage: differential_regex <re2-search.txt> <re2-exhaustive.txt.bz2>\n", .{});
        std.process.exit(usage_exit_status);
    }
    const search_log = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], arena, .unlimited);
    const packed_log = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], arena, .unlimited);
    const exhaustive_log = oracle.bzip2_decode(packed_log, try arena.alloc(u8, exhaustive_len_max)) orelse {
        std.debug.print("differential-regex FAILED: {s} is no bzip2 stream of at most {d} octets\n", .{ args[2], exhaustive_len_max });
        std.process.exit(1);
    };

    var parts: [exhaustive_parts][]const u8 = undefined;
    var tasks: std.ArrayList(Task) = .empty;
    for (seeds) |seed| try tasks.append(arena, .{ .phase = .generated, .work = .{ .seed = seed } });
    try tasks.append(arena, .{ .phase = .search, .work = .{ .log = search_log } });
    for (cut_log(exhaustive_log, &parts)) |part| try tasks.append(arena, .{ .phase = .exhaustive, .work = .{ .log = part } });
    try run(arena, tasks.items);

    var totals: [std.meta.fields(Phase).len]Tally = @splat(.{});
    for (tasks.items) |task| totals[@intFromEnum(task.phase)].add(task.tally);
    var cases: usize = 0;
    for (totals, 0..) |tally, phase| {
        report(@enumFromInt(phase), tally);
        cases += tally.cases;
    }
    const generated = totals[@intFromEnum(Phase.generated)];
    if (generated.too_large > programs_too_large_max) {
        std.debug.print("differential-regex FAILED: {d} programs too large, and {d} may be\n", .{ generated.too_large, programs_too_large_max });
    }
    const search = totals[@intFromEnum(Phase.search)];
    const exhaustive = totals[@intFromEnum(Phase.exhaustive)];
    const failures = generated_failures(generated) +
        log_failures(.search, search, expected_equal.search) + log_failures(.exhaustive, exhaustive, expected_equal.exhaustive);
    std.debug.print("differential-regex: {d} cases, {d} failed\n", .{ cases, failures });
    if (failures != 0) std.process.exit(1);
}

const testing = std.testing;

test "cut_log gives parts that start at a list of texts and hold the whole log" {
    const log = "# a comment\nNames\nstrings\n\"a\"\nregexps\n\"a\"\n0-1;0-1;0-1;0-1\nstrings\n\"b\"\nregexps\n\"b\"\n0-1;0-1;0-1;0-1\nstrings\n\"c\"\nregexps\n\"c\"\n0-1;0-1;0-1;0-1\n";
    for ([_]usize{ 1, 2, 3, 8 }) |room| {
        var parts: [8][]const u8 = undefined;
        const cut = cut_log(log, parts[0..room]);
        var len: usize = 0;
        for (cut, 0..) |part, index| {
            if (index > 0) try testing.expect(std.mem.startsWith(u8, part, texts_line[1..]));
            try testing.expectEqualStrings(log[len..][0..part.len], part);
            len += part.len;
        }
        try testing.expectEqual(log.len, len);
        try testing.expect(cut.len <= room);
    }
    // With room for more parts than the log has lists, each list of texts starts a part.
    var parts: [8][]const u8 = undefined;
    const cut = cut_log(log, &parts);
    try testing.expectEqual(@as(usize, 3), std.mem.count(u8, log, texts_line));
    try testing.expectEqual(@as(usize, 4), cut.len);
    try testing.expectEqualStrings("# a comment\nNames\n", cut[0]);
}

test "Tally.add sums each count" {
    var total: Tally = .{ .cases = 1, .equal = 1 };
    var other: Tally = .{ .cases = 5, .equal = 2, .both_refuse = 1, .too_long = 1, .too_large = 3, .allowed = 1, .failures = 1 };
    other.allowed_by[0] = 1;
    total.add(other);
    total.add(other);
    try testing.expectEqual(Tally{ .cases = 11, .equal = 5, .both_refuse = 2, .too_long = 2, .too_large = 6, .allowed = 2, .allowed_by = blk: {
        var by: [verdicts.entries.len]usize = @splat(0);
        by[0] = 2;
        break :blk by;
    }, .failures = 2 }, total);
}

test "programs too large fail the generated cases past their bound alone" {
    try testing.expectEqual(@as(usize, 2), generated_failures(.{ .failures = 2, .too_large = programs_too_large_max }));
    try testing.expectEqual(@as(usize, 3), generated_failures(.{ .failures = 2, .too_large = programs_too_large_max + 1 }));
}

test {
    _ = answers;
    _ = generate;
    _ = re2_log;
}
