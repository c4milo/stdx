//! bench-regex's held-out set (decision 86 as amended): every benchmark of rebar's curated set
//! whose engines name Go's regexp or RE2, the engines of stdx's syntax. bench/regex/rebar_cases.py
//! wrote this file from the definitions of rebar at `commit`; regenerate it, never edit it. Its
//! patterns and haystacks are rebar's, and its answers are the counts rebar's definitions give Go's
//! regexp. Nobody who tuned stdx chose these rows, but design §8 part 22n tuned stdx on them since.

/// The commit of rebar whose definitions and files the set takes.
pub const commit = "463d00f31887e84c38467805b9e3122c314b9521";

/// rebar's models: what one call does with a pattern and a haystack (rebar's MODELS.md).
pub const Model = enum { count, count_spans, count_captures, grep, grep_captures, compile };

/// A pattern: its text, or a file of rebar's `benchmarks/regexes/`.
pub const Pattern = union(enum) {
    text: []const u8,
    /// A file whose text, trimmed, is the pattern. With `alternate`, each line is an alternative
    /// in a group of its own, and with `literal`, each line stands for its own octets.
    file: struct { path: []const u8, alternate: bool = false, literal: bool = false },
};

/// A haystack: a text, repeated, or a file of rebar's `benchmarks/haystacks/`.
pub const Haystack = union(enum) {
    text: struct { octets: []const u8, repeat: u32 = 1 },
    /// The file's lines from `line_start` up to `line_end`, after each invalid UTF-8 sequence is
    /// replaced with U+FFFD where `utf8_lossy` is set.
    file: struct { path: []const u8, utf8_lossy: bool = false, line_start: ?u32 = null, line_end: ?u32 = null },
};

pub const Bench = struct {
    /// The definition's file and the benchmark's name, as `01-literal/sherlock-en`.
    name: []const u8,
    model: Model,
    pattern: Pattern,
    case_insensitive: bool = false,
    unicode: bool = false,
    haystack: Haystack,
    /// The answer rebar's definition gives Go's regexp, which every candidate must give.
    count: u64,
};

pub const benches = [_]Bench{
    .{
        .name = "01-literal/sherlock-en",
        .model = .count,
        .pattern = .{ .text = "Sherlock Holmes" },
        .haystack = .{ .file = .{ .path = "opensubtitles/en-sampled.txt" } },
        .count = 513,
    },
    .{
        .name = "01-literal/sherlock-casei-en",
        .model = .count,
        .pattern = .{ .text = "Sherlock Holmes" },
        .case_insensitive = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/en-sampled.txt" } },
        .count = 522,
    },
    .{
        .name = "01-literal/sherlock-ru",
        .model = .count,
        .pattern = .{ .text = "Шерлок Холмс" },
        .unicode = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/ru-sampled.txt" } },
        .count = 724,
    },
    .{
        .name = "01-literal/sherlock-casei-ru",
        .model = .count,
        .pattern = .{ .text = "Шерлок Холмс" },
        .case_insensitive = true,
        .unicode = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/ru-sampled.txt" } },
        .count = 746,
    },
    .{
        .name = "01-literal/sherlock-zh",
        .model = .count,
        .pattern = .{ .text = "夏洛克·福尔摩斯" },
        .unicode = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/zh-sampled.txt" } },
        .count = 30,
    },
    .{
        .name = "02-literal-alternate/sherlock-en",
        .model = .count,
        .pattern = .{ .text = "Sherlock Holmes|John Watson|Irene Adler|Inspector Lestrade|Professor Moriarty" },
        .haystack = .{ .file = .{ .path = "opensubtitles/en-sampled.txt" } },
        .count = 714,
    },
    .{
        .name = "02-literal-alternate/sherlock-casei-en",
        .model = .count,
        .pattern = .{ .text = "Sherlock Holmes|John Watson|Irene Adler|Inspector Lestrade|Professor Moriarty" },
        .case_insensitive = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/en-sampled.txt" } },
        .count = 725,
    },
    .{
        .name = "02-literal-alternate/sherlock-ru",
        .model = .count,
        .pattern = .{ .text = "Шерлок Холмс|Джон Уотсон|Ирен Адлер|инспектор Лестрейд|профессор Мориарти" },
        .unicode = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/ru-sampled.txt" } },
        .count = 899,
    },
    .{
        .name = "02-literal-alternate/sherlock-casei-ru",
        .model = .count,
        .pattern = .{ .text = "Шерлок Холмс|Джон Уотсон|Ирен Адлер|инспектор Лестрейд|профессор Мориарти" },
        .case_insensitive = true,
        .unicode = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/ru-sampled.txt" } },
        .count = 971,
    },
    .{
        .name = "02-literal-alternate/sherlock-zh",
        .model = .count,
        .pattern = .{ .text = "夏洛克·福尔摩斯|约翰华生|阿德勒|雷斯垂德|莫里亚蒂教授" },
        .unicode = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/zh-sampled.txt" } },
        .count = 207,
    },
    .{
        .name = "03-date/ascii",
        .model = .count_spans,
        .pattern = .{ .file = .{ .path = "wild/date.txt" } },
        .case_insensitive = true,
        .haystack = .{ .file = .{ .path = "rust-src-tools-3b0d4813.txt", .line_start = 190000, .line_end = 200000 } },
        .count = 111817,
    },
    .{
        .name = "03-date/compile-ascii",
        .model = .compile,
        .pattern = .{ .file = .{ .path = "wild/date.txt" } },
        .case_insensitive = true,
        .haystack = .{ .text = .{ .octets = "2010-03-14" } },
        .count = 5,
    },
    .{
        .name = "04-ruff-noqa/real",
        .model = .grep_captures,
        .pattern = .{ .text = "(\\s*)((?:# [Nn][Oo][Qq][Aa])(?::\\s?(([A-Z]+[0-9]+(?:[,\\s]+)?)+))?)" },
        .haystack = .{ .file = .{ .path = "wild/cpython-226484e4.py", .utf8_lossy = true } },
        .count = 84,
    },
    .{
        .name = "04-ruff-noqa/tweaked",
        .model = .grep_captures,
        .pattern = .{ .text = "(?:# [Nn][Oo][Qq][Aa])(?::\\s?(([A-Z]+[0-9]+(?:[,\\s]+)?)+))?" },
        .haystack = .{ .file = .{ .path = "wild/cpython-226484e4.py", .utf8_lossy = true } },
        .count = 44,
    },
    .{
        .name = "04-ruff-noqa/compile-real",
        .model = .compile,
        .pattern = .{ .text = "(\\s*)((?:# [Nn][Oo][Qq][Aa])(?::\\s?(([A-Z]+[0-9]+(?:[,\\s]+)?)+))?)" },
        .haystack = .{ .text = .{ .octets = "# noqa" } },
        .count = 1,
    },
    .{
        .name = "05-lexer-veryl/single",
        .model = .count_captures,
        .pattern = .{ .file = .{ .path = "wild/parol-veryl.txt", .alternate = true } },
        .haystack = .{ .file = .{ .path = "wild/parol-veryl.vl" } },
        .count = 124800,
    },
    .{
        .name = "05-lexer-veryl/compile-single",
        .model = .compile,
        .pattern = .{ .file = .{ .path = "wild/parol-veryl.txt", .alternate = true } },
        .haystack = .{ .text = .{ .octets = "abcdefg_foobar" } },
        .count = 1,
    },
    .{
        .name = "06-cloud-flare-redos/original",
        .model = .count_spans,
        .pattern = .{ .text = "(?:(?:\"|'|\\]|\\}|\\\\|\\d|(?:nan|infinity|true|false|null|undefined|symbol|math)|`|-|\\+)+[)]*;?((?:\\s|-|~|!|\\{\\}|\\|\\||\\+)*.*(?:.*=.*)))" },
        .haystack = .{ .text = .{ .octets = "math x=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },
        .count = 107,
    },
    .{
        .name = "06-cloud-flare-redos/simplified-short",
        .model = .count_spans,
        .pattern = .{ .text = ".*.*=.*" },
        .haystack = .{ .text = .{ .octets = "x=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },
        .count = 102,
    },
    .{
        .name = "06-cloud-flare-redos/simplified-long",
        .model = .count_spans,
        .pattern = .{ .text = ".*.*=.*" },
        .haystack = .{ .file = .{ .path = "cloud-flare-redos.txt" } },
        .count = 10000,
    },
    .{
        .name = "07-unicode-character-data/parse-line",
        .model = .grep_captures,
        .pattern = .{ .file = .{ .path = "wild/ucd-parse.txt" } },
        .haystack = .{ .file = .{ .path = "wild/UnicodeData-15.0.0.txt" } },
        .count = 558784,
    },
    .{
        .name = "07-unicode-character-data/compile",
        .model = .compile,
        .pattern = .{ .file = .{ .path = "wild/ucd-parse.txt" } },
        .haystack = .{ .text = .{ .octets = "249D;PARENTHESIZED LATIN SMALL LETTER B;So;0;L;<compat> 0028 0062 0029;;;;N;;;;;" } },
        .count = 1,
    },
    .{
        .name = "08-words/all-english",
        .model = .count_spans,
        .pattern = .{ .text = "\\b[0-9A-Za-z_]+\\b" },
        .haystack = .{ .file = .{ .path = "opensubtitles/en-sampled.txt", .line_end = 2500 } },
        .count = 56691,
    },
    .{
        .name = "08-words/long-english",
        .model = .count_spans,
        .pattern = .{ .text = "\\b[0-9A-Za-z_]{12,}\\b" },
        .haystack = .{ .file = .{ .path = "opensubtitles/en-sampled.txt", .line_end = 2500 } },
        .count = 839,
    },
    .{
        .name = "09-aws-keys/full",
        .model = .grep_captures,
        .pattern = .{ .text = "(('|\")((?:ASIA|AKIA|AROA|AIDA)([A-Z0-7]{16}))('|\").*?(\\n^.*?){0,4}(('|\")[a-zA-Z0-9+/]{40}('|\"))+|('|\")[a-zA-Z0-9+/]{40}('|\").*?(\\n^.*?){0,3}('|\")((?:ASIA|AKIA|AROA|AIDA)([A-Z0-7]{16}))('|\"))+" },
        .haystack = .{ .file = .{ .path = "wild/cpython-226484e4.py", .utf8_lossy = true } },
        .count = 0,
    },
    .{
        .name = "09-aws-keys/quick",
        .model = .grep,
        .pattern = .{ .text = "((?:ASIA|AKIA|AROA|AIDA)([A-Z0-7]{16}))" },
        .haystack = .{ .file = .{ .path = "wild/cpython-226484e4.py", .utf8_lossy = true } },
        .count = 0,
    },
    .{
        .name = "09-aws-keys/compile-full",
        .model = .compile,
        .pattern = .{ .text = "(('|\")((?:ASIA|AKIA|AROA|AIDA)([A-Z0-7]{16}))('|\").*?(\\n^.*?){0,4}(('|\")[a-zA-Z0-9+/]{40}('|\"))+|('|\")[a-zA-Z0-9+/]{40}('|\").*?(\\n^.*?){0,3}('|\")((?:ASIA|AKIA|AROA|AIDA)([A-Z0-7]{16}))('|\"))+" },
        .haystack = .{ .text = .{ .octets = "\"AIDAABCDEFGHIJKLMNOP\"\"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\"" } },
        .count = 1,
    },
    .{
        .name = "09-aws-keys/compile-quick",
        .model = .compile,
        .pattern = .{ .text = "((?:ASIA|AKIA|AROA|AIDA)([A-Z0-7]{16}))" },
        .haystack = .{ .text = .{ .octets = "AIDAABCDEFGHIJKLMNOP" } },
        .count = 1,
    },
    .{
        .name = "10-bounded-repeat/letters-en",
        .model = .count,
        .pattern = .{ .text = "[A-Za-z]{8,13}" },
        .haystack = .{ .file = .{ .path = "opensubtitles/en-sampled.txt", .line_end = 5000 } },
        .count = 1833,
    },
    .{
        .name = "10-bounded-repeat/letters-ru",
        .model = .count,
        .pattern = .{ .text = "\\p{L}{8,13}" },
        .unicode = true,
        .haystack = .{ .file = .{ .path = "opensubtitles/ru-sampled.txt", .line_end = 5000 } },
        .count = 3475,
    },
    .{
        .name = "10-bounded-repeat/context",
        .model = .count,
        .pattern = .{ .text = "[A-Za-z]{10}\\s+[\\s\\S]{0,100}Result[\\s\\S]{0,100}\\s+[A-Za-z]{10}" },
        .haystack = .{ .file = .{ .path = "rust-src-tools-3b0d4813.txt" } },
        .count = 53,
    },
    .{
        .name = "10-bounded-repeat/capitals",
        .model = .count,
        .pattern = .{ .text = "(?:[A-Z][a-z]+\\s*){10,100}" },
        .haystack = .{ .file = .{ .path = "rust-src-tools-3b0d4813.txt" } },
        .count = 11,
    },
    .{
        .name = "10-bounded-repeat/compile-context",
        .model = .compile,
        .pattern = .{ .text = "[A-Za-z]{10}\\s+[\\s\\S]{0,100}Result[\\s\\S]{0,100}\\s+[A-Za-z]{10}" },
        .haystack = .{ .text = .{ .octets = "abcdefghij blah blah blah Result blib blab klmnopqrst" } },
        .count = 1,
    },
    .{
        .name = "10-bounded-repeat/compile-capitals",
        .model = .compile,
        .pattern = .{ .text = "(?:[A-Z][a-z]+\\s*){10,100}" },
        .haystack = .{ .text = .{ .octets = "Crazy Janey Mission Man Wild Billy Greasy Lake Hazy Davy Killer Joe" } },
        .count = 1,
    },
    .{
        .name = "11-unstructured-to-json/extract",
        .model = .grep_captures,
        .pattern = .{ .file = .{ .path = "wild/unstructured-to-json.txt" } },
        .haystack = .{ .file = .{ .path = "wild/unstructured-to-json.log" } },
        .count = 600,
    },
    .{
        .name = "11-unstructured-to-json/compile",
        .model = .compile,
        .pattern = .{ .file = .{ .path = "wild/unstructured-to-json.txt" } },
        .haystack = .{ .text = .{ .octets = "2022/06/17 06:25:22 I4: [17936:140245395805952:(17998)]: (8fb074fc-c766-498b-b224-8b660126b2c0): Searching for query 'dummy query' {/src/master/mastersearchattrs.cc:MasterSearchAttributes():40}" } },
        .count = 1,
    },
    .{
        .name = "12-dictionary/single",
        .model = .count,
        .pattern = .{ .file = .{ .path = "dictionary/english/length-15.txt", .alternate = true, .literal = true } },
        .haystack = .{ .file = .{ .path = "opensubtitles/en-medium.txt" } },
        .count = 1,
    },
    .{
        .name = "12-dictionary/compile-single",
        .model = .compile,
        .pattern = .{ .file = .{ .path = "dictionary/english/length-15.txt", .alternate = true, .literal = true } },
        .haystack = .{ .text = .{ .octets = "Zubeneschamali's" } },
        .count = 1,
    },
    .{
        .name = "14-quadratic/1x",
        .model = .count,
        .pattern = .{ .text = ".*[^A-Z]|[A-Z]" },
        .haystack = .{ .text = .{ .octets = "A", .repeat = 100 } },
        .count = 100,
    },
    .{
        .name = "14-quadratic/2x",
        .model = .count,
        .pattern = .{ .text = ".*[^A-Z]|[A-Z]" },
        .haystack = .{ .text = .{ .octets = "A", .repeat = 200 } },
        .count = 200,
    },
    .{
        .name = "14-quadratic/10x",
        .model = .count,
        .pattern = .{ .text = ".*[^A-Z]|[A-Z]" },
        .haystack = .{ .text = .{ .octets = "A", .repeat = 1000 } },
        .count = 1000,
    },
};
