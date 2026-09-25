//! Commit-message linter for the Conventional Commit rules of CLAUDE.md (Commits). It reads commit
//! messages out of git, or one message from a file, and prints one line per finding; it changes
//! nothing.
//!
//! Run:  zig build lint-commits            # the commits this branch adds to origin/main
//!       zig-out/bin/commit_lint --range REV [REV...]
//!       zig-out/bin/commit_lint --message PATH
//!
//! The linter is pepegrillo's (decision 7). This file holds stdx's configuration of it: the module
//! scopes of docs/design.md §3 with `bench` and `oracle` beside them, and the first words refused
//! as not imperative. The limits are the ones CLAUDE.md states, which are pepegrillo's defaults:
//! a subject of at most 72 columns, and a body of at most 100 words, 3 paragraphs and 100 columns
//! a line.
//!
//! One line per finding, in the shape the Zig compiler prints an error:
//!
//!     source: error: [rule-name] message
//!
//! `error` marks a rule of CLAUDE.md that was broken, and `warning` a scope outside the module
//! graph. CLAUDE.md states that scopes track the module graph, and a closed
//! check would make this tool, rather than the design, the authority on what modules exist, so an
//! unknown scope never changes the exit status.
//!
//! Exit status: 0 when no rule was violated, warnings included; 1 when any rule was violated; 2 on
//! a usage error, an unreadable message file, or a git log that failed. .githooks/pre-push reads
//! the difference.

const std = @import("std");
const pepegrillo = @import("pepegrillo");

/// The scopes CLAUDE.md names: one per module of docs/design.md §3, then `bench` for the
/// benchmarks and `oracle` for the differential checks of `tools/`.
pub const module_scopes = [_][]const u8{
    "codec", "checksum", "deflate", "zlib", "gzip", "zstd", "brotli", "bench", "oracle",
};

/// First words that describe the commit instead of commanding it.
const third_person_forms = [_][]const u8{
    "adds",    "fixes", "updates", "removes", "implements", "splits",
    "renames", "moves", "makes",   "drops",   "lands",      "keeps",
};

/// Commands whose spelling ends in `ed` or `ing` all the same. The suffix test reads the last two
/// or three bytes of a word, not its grammar, so without this list it refuses `bring the hook
/// back` and `seed the corpus`.
const imperative_exceptions = [_][]const u8{
    "bring",  "embed", "seed", "speed", "feed", "exceed", "proceed", "succeed", "shed", "ring",
    "string",
};

pub const config: pepegrillo.commit.Config = .{
    .scope_admits_digits = false,
    .known_scopes = &module_scopes,
    .unknown_scope_reason = "is not a module of the graph",
    .third_person_forms = &third_person_forms,
    .imperative_exceptions = &imperative_exceptions,
};

pub fn main(init: std.process.Init) !void {
    return pepegrillo.commit.main(init, config);
}

// Tests. pepegrillo tests the rules; these pin stdx's configuration of them.

const testing = std.testing;
const commit = pepegrillo.commit;

/// The module scopes as the scope warning prints them, written out rather than built from
/// `module_scopes`, so a scope added to or dropped from that list fails this file.
const module_scope_list = "codec, checksum, deflate, zlib, gzip, zstd, brotli, bench, oracle";

/// Lints `text` under stdx's configuration and checks each finding, in order, as
/// `severity: rule: message`.
fn expect_findings(text: []const u8, expected: []const []const u8) !void {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    var findings: commit.Findings = .{ .arena = arena, .max_findings = config.max_findings };
    try commit.lint_message_text(arena, config, &findings, "message", text);
    try testing.expectEqual(expected.len, findings.items.items.len);
    for (findings.items.items, expected) |finding, wanted| {
        const line = try std.fmt.allocPrint(arena, "{s}: {s}: {s}", .{
            finding.severity.text(), finding.rule, finding.message,
        });
        try testing.expectEqualStrings(wanted, line);
    }
}

test "every scope CLAUDE.md names passes" {
    // Written out rather than read from `module_scopes`, so a scope dropped from that list fails.
    const scopes = [_][]const u8{
        "codec", "checksum", "deflate", "zlib", "gzip", "zstd", "brotli", "bench", "oracle",
    };
    try testing.expectEqual(scopes.len, module_scopes.len);
    for (scopes) |scope| {
        var buffer: [96]u8 = undefined;
        const text = try std.fmt.bufPrint(&buffer, "feat({s}): add the frame reader\n", .{scope});
        try expect_findings(text, &.{});
    }
}

test "a well-formed scope the graph does not name draws a warning" {
    try expect_findings("refactor(deflate-fast): add the frame reader\n", &.{
        "warning: scope-known: the scope \"deflate-fast\" is not a module of the graph (" ++
            module_scope_list ++ ")",
    });
}

test "a scope with a digit is refused, because no scope stdx names holds one" {
    try expect_findings("feat(zstd2): add the frame reader\n", &.{
        "violation: subject-format: the scope holds a byte that is not a lowercase letter or a " ++
            "hyphen: \"feat(zstd2): add the frame reader\"",
    });
}

test "a subject over 72 columns is refused" {
    const subject = "feat(deflate): " ++ "a" ** 58;
    try expect_findings(subject ++ "\n", &.{
        "violation: subject-length: the subject is 73 columns, over the 72-column limit",
    });
}

test "every third-person form is refused" {
    // Written out rather than read from `third_person_forms`, so a form dropped from it fails.
    const forms = [_][]const u8{
        "adds",  "fixes", "updates", "removes", "implements", "splits", "renames", "moves", "makes",
        "drops", "lands", "keeps",
    };
    try testing.expectEqual(forms.len, third_person_forms.len);
    for (forms) |form| {
        var buffer: [128]u8 = undefined;
        var wanted_buffer: [160]u8 = undefined;
        const text = try std.fmt.bufPrint(&buffer, "feat: {s} the frame reader\n", .{form});
        const wanted = try std.fmt.bufPrint(
            &wanted_buffer,
            "violation: subject-description: \"{s}\" is a third-person form, not imperative",
            .{form},
        );
        try expect_findings(text, &.{wanted});
    }
}

test "every command whose spelling ends in ed or ing passes" {
    // Written out rather than read from `imperative_exceptions`, so a word dropped from it fails.
    const exceptions = [_][]const u8{
        "bring",  "embed", "seed", "speed", "feed", "exceed", "proceed", "succeed", "shed", "ring",
        "string",
    };
    try testing.expectEqual(exceptions.len, imperative_exceptions.len);
    for (exceptions) |exception| {
        var buffer: [128]u8 = undefined;
        const text = try std.fmt.bufPrint(&buffer, "feat: {s} the corpus\n", .{exception});
        try expect_findings(text, &.{});
    }
}
