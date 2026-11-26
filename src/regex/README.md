# stdx.regex

`stdx.regex` matches regular expressions in time linear in the text, in memory that the program
gives ([decision 86](../../docs/decisions.md)).

## Use

```zig
/// Counts the matches of `pattern` in `haystack`. The program gives the searcher its memory: 4 MiB
/// of it is the default cache, and a smaller cache costs speed, never an answer.
fn count_matches(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, pattern: []const u8, haystack: []const u8) !u64 {
    var storage: [instructions_len]stdx.regex.Instruction = undefined;
    const program = try stdx.regex.compile(pattern, .{}, &storage);
    const cache_words = stdx.regex.constants.cache_words_default;
    const memory = try gpa.alloc(u64, stdx.regex.Searcher.memory_len(program.forward_len, program.slot_count(), cache_words));
    defer gpa.free(memory);
    var searcher: stdx.regex.Searcher = undefined;
    searcher.init(&program, &.{ .features = features }, memory);
    var matches: stdx.regex.Matches = .{ .searcher = &searcher, .haystack = haystack };
    return matches.count();
}
```

```zig
/// The text that the first capture group of `pattern` took in its first match in `haystack`, or
/// null where no match holds the group.
fn first_group(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, pattern: []const u8, haystack: []const u8) !?[]const u8 {
    var storage: [instructions_len]stdx.regex.Instruction = undefined;
    const program = try stdx.regex.compile(pattern, .{}, &storage);
    const cache_words = stdx.regex.constants.cache_words_default;
    const memory = try gpa.alloc(u64, stdx.regex.Searcher.memory_len(program.forward_len, program.slot_count(), cache_words));
    defer gpa.free(memory);
    var searcher: stdx.regex.Searcher = undefined;
    searcher.init(&program, &.{ .features = features }, memory);
    const groups = searcher.captures(haystack, 0) orelse return null;
    const span = groups.get(1) orelse return null;
    return haystack[@intCast(span.start)..@intCast(span.end)];
}
```

- `compile` writes the pattern's program into `storage`. It returns a `stdx.regex.Error` for a
  pattern that it refuses, with one value for each cause.
- The program reads `storage`, and the searcher reads `memory`. Keep both while the searcher runs.
- A cache smaller than the default 4 MiB costs speed, and never an answer.

Each example is an excerpt of [`tools/consumer/main.zig`](../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## Syntax

- The grammar is [RFC 9485](https://www.rfc-editor.org/rfc/rfc9485)'s, with RE2's anchors,
  groups, named groups, lazy quantifiers, flags and named classes, and `\p{...}` with Unicode's
  case folding.
- A match is the leftmost one, and among those the one that a backtracking matcher finds first, as
  in RE2 and in Go's regexp.
- stdx refuses the forms that need a backtracking matcher: a backreference
  (`error.UnsupportedBackreference`) and a lookaround (`error.UnsupportedLookaround`).
- `Options.encoding` reads the text as UTF-8, or as bytes. In bytes, `.`, a class and an escape
  such as `\xE9` each take one byte, UTF-8 or not, and `(?i)` folds ASCII alone.

## What it holds

- `compile`: a `Program` from a pattern, in storage that the program owns. `compile_comptime`
  compiles a pattern of 4,096 instructions at most at compile time.
- `Searcher`: `find`, `is_match`, and `captures`, over a text that one buffer holds. `Matches`
  gives each match in turn, and counts them.
- `Matcher`: the same answers for a text that arrives in pieces. Its memory depends on the
  program alone, and not on the text.
- `Searcher.memory_len`: the memory that a searcher takes for a program and a cache.

## Limits

| Limit | Value |
| --- | --- |
| A repeat's count, and the product of nested counts | 1,000 |
| The depth of nested groups | 96 |
| Capture groups, the whole match included | 4,096 |
| Named groups | 128, each name 64 bytes at most |
| Instructions of one program | 2^24 |

A pattern past a limit returns an error value. The limits bound what a pattern from a source
that the program does not trust can cost (RFC 9485 §8).

## How it is checked

- `zig build differential-regex -Doracles` gives a million generated patterns and texts to stdx
  and to Go's regexp, and then every pattern and text of RE2's own two test logs to stdx.
- [`spec/lean`](../../spec/lean) holds a Lean model of the matcher, and of several of the
  searcher's faster paths, with a proof for each that it gives the matcher's answer.
  `tools/matcher_model_check.sh` holds the code to the model's answers on programs that a seed
  draws.

## Performance

stdx was tuned on each set that measures it. The chart is the latest release's: the median of 18
jobs on each of GitHub's runners, against Rust's regex crate and Go's regexp. The rows are rebar's
benchmarks outside its curated set and its tests whose engines name Go's regexp or RE2, each under
rebar's own model, pattern and haystack. A green ▲ or a red ▼ after a row's name marks a row 5% or
more faster or slower than at the previous release, measured in the same jobs.
[The page of the branch `charts`](https://github.com/c4milo/stdx/blob/charts/benchmarks.md) lists the counts of each panel.

stdx was tuned on these rows ([decision 86](../../docs/decisions.md)), so this chart can favor stdx. The runs
at commit 1df5f9f are the last that came before that work, and the README at commit
[1744e4a](https://github.com/c4milo/stdx/blob/1744e4a/README.md#regular-expressions) draws them.
One change came before those runs, for the answer of one row and on no speed: stdx runs each
benchmark that leaves `unicode` off in bytes, as Rust's crate runs it.

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-rebar-others-aarch64.svg)

<details>
<summary>x86-64: the CPU model that most of the release's jobs drew</summary>

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-rebar-others-x86_64.svg)

</details>

[`docs/benchmarks.md`](../../docs/benchmarks.md#regular-expressions) holds two more charts from the same runs: the
patterns written for this benchmark, and rebar's curated set. stdx was tuned on both too. That
page says how to read each chart and run the benchmark again.
