#!/usr/bin/env python3
"""Writes bench/regex/regex_rebar.zig, bench-regex's two sets of rebar's benchmarks.

    python3 bench/regex/rebar_cases.py <rebar checkout> > bench/regex/regex_rebar.zig

The rule takes every benchmark whose `engines` list names Go's regexp or RE2, the engines of stdx's
syntax, and whose model the benchmark runs, and nothing else (decision 86 as amended). `curated`
holds those of rebar's curated set. `others` holds those of every other definition but rebar's own
tests: no work on stdx has measured them. No row is chosen by what stdx does on it. The rule leaves
out the `regex-redux` model, a program of its own with no pattern. The checkout must be at COMMIT,
the commit build/oracle_regex.zig fetches the files from.
"""
import glob
import os
import re
import subprocess
import sys
import tomllib

COMMIT = "463d00f31887e84c38467805b9e3122c314b9521"
ENGINES = ("go/regexp", "re2")
MODELS = {"count": "count", "count-spans": "count_spans", "count-captures": "count_captures",
          "grep": "grep", "grep-captures": "grep_captures", "compile": "compile"}
HEADER = '''//! bench-regex's two sets of rebar's benchmarks (decision 86 as amended): each benchmark whose
//! engines name Go's regexp or RE2, the engines of stdx's syntax, and whose model the benchmark
//! runs. `curated` holds those of rebar's curated set, which design §8 part 22n tuned stdx on.
//! `others` holds those of every other definition but rebar's tests, which no work on stdx has
//! measured. bench/regex/rebar_cases.py wrote this file from the definitions of rebar at `commit`;
//! regenerate it, never edit it. Its patterns and haystacks are rebar's, and its answers are the
//! counts rebar's definitions give Go's regexp, Rust's crate and RE2.

/// The commit of rebar whose definitions and files the set takes.
pub const commit = "{commit}";

/// rebar's models: what one call does with a pattern and a haystack (rebar's MODELS.md).
pub const Model = enum {{ count, count_spans, count_captures, grep, grep_captures, compile }};

/// A pattern: its text, or a file of rebar's `benchmarks/regexes/`.
pub const Pattern = union(enum) {{
    text: []const u8,
    /// A file whose text, trimmed, is the pattern. With `alternate`, each line is an alternative
    /// in a group of its own, and with `literal`, each line stands for its own octets. `prepend`
    /// and `append` stand before and after the pattern.
    file: struct {{ path: []const u8, alternate: bool = false, literal: bool = false, prepend: []const u8 = "", append: []const u8 = "" }},
}};

/// A haystack: a text, repeated, or a file of rebar's `benchmarks/haystacks/`, and then `append`.
pub const Haystack = union(enum) {{
    text: struct {{ octets: []const u8, repeat: u32 = 1, append: []const u8 = "" }},
    /// The file, with each invalid UTF-8 sequence replaced with U+FFFD where `utf8_lossy` is set,
    /// its white space trimmed where `trim` is, and its lines from `line_start` up to `line_end`.
    file: struct {{ path: []const u8, utf8_lossy: bool = false, trim: bool = false, line_start: ?u32 = null, line_end: ?u32 = null, append: []const u8 = "" }},
}};

/// The answers rebar's definition gives three engines: Go's regexp, Rust's crate, and RE2, whose
/// syntax and reading of invalid UTF-8 stdx's are. Each candidate must give its engine's answer.
pub const Counts = struct {{
    go: u64,
    rust: u64,
    re2: u64,

    /// The same answer for all three engines.
    pub fn all(count: u64) Counts {{
        return .{{ .go = count, .rust = count, .re2 = count }};
    }}
}};

pub const Bench = struct {{
    /// The definition's file and the benchmark's name, as `01-literal/sherlock-en`.
    name: []const u8,
    model: Model,
    pattern: Pattern,
    case_insensitive: bool = false,
    unicode: bool = false,
    haystack: Haystack,
    count: Counts,
}};

pub const curated = [_]Bench{{
'''


def zig_string(text):
    """A Zig string literal of `text`: UTF-8 as it is, and escapes for what Zig's literal needs."""
    out = []
    for ch in text:
        if ch == "\\":
            out.append("\\\\")
        elif ch == '"':
            out.append('\\"')
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\r":
            out.append("\\r")
        elif ch == "\t":
            out.append("\\t")
        elif ord(ch) < 0x20 or ord(ch) == 0x7F:
            out.append("\\x%02x" % ord(ch))
        else:
            out.append(ch)
    return '"' + "".join(out) + '"'


def engine_count(count, engine):
    """The count a definition gives `engine`: one number, or the first entry whose engine pattern,
    anchored at both ends as rebar's FORMAT.md says, names it."""
    if isinstance(count, int):
        return count
    for entry in count:
        if re.fullmatch(entry["engine"], engine):
            return entry["count"]
    raise SystemExit(f"rebar_cases.py: a definition gives {engine} no count")


def counts_of(count):
    """The counts of Go's regexp, Rust's crate and RE2, as a Zig value."""
    values = [engine_count(count, engine) for engine in ("go/regexp", "rust/regex", "re2")]
    if len(set(values)) == 1:
        return ".all(%d)" % values[0]
    return ".{ .go = %d, .rust = %d, .re2 = %d }" % tuple(values)


def pattern_of(regex):
    if isinstance(regex, str):
        return ".{ .text = %s }" % zig_string(regex)
    unknown = set(regex) - {"path", "per-line", "literal", "prepend", "append"}
    if unknown or regex.get("per-line", "alternate") != "alternate":
        raise SystemExit(f"rebar_cases.py: a pattern option the set does not read: {regex}")
    fields = [".path = %s" % zig_string(regex["path"])]
    if regex.get("per-line") == "alternate":
        fields.append(".alternate = true")
    if regex.get("literal"):
        fields.append(".literal = true")
    for key in ("prepend", "append"):
        if key in regex:
            fields.append(".%s = %s" % (key, zig_string(regex[key])))
    return ".{ .file = .{ %s } }" % ", ".join(fields)


def haystack_of(haystack):
    if isinstance(haystack, str):
        haystack = {"contents": haystack}
    unknown = set(haystack) - {"path", "contents", "utf8-lossy", "trim", "line-start", "line-end", "repeat", "append"}
    if unknown or ("path" in haystack and "repeat" in haystack) or ("contents" in haystack and "trim" in haystack):
        raise SystemExit(f"rebar_cases.py: a haystack option the set does not read: {haystack}")
    append = [".append = %s" % zig_string(haystack["append"])] if "append" in haystack else []
    if "contents" in haystack:
        fields = [".octets = %s" % zig_string(haystack["contents"])]
        if "repeat" in haystack:
            fields.append(".repeat = %d" % haystack["repeat"])
        return ".{ .text = .{ %s } }" % ", ".join(fields + append)
    fields = [".path = %s" % zig_string(haystack["path"])]
    if haystack.get("utf8-lossy"):
        fields.append(".utf8_lossy = true")
    if haystack.get("trim"):
        fields.append(".trim = true")
    for key, field in (("line-start", "line_start"), ("line-end", "line_end")):
        if key in haystack:
            fields.append(".%s = %d" % (field, haystack[key]))
    return ".{ .file = .{ %s } }" % ", ".join(fields + append)


def entry(stem, bench):
    lines = ["    .{",
             "        .name = %s," % zig_string(f"{stem}/{bench['name']}"),
             "        .model = .%s," % MODELS[bench["model"]],
             "        .pattern = %s," % pattern_of(bench["regex"])]
    if bench.get("case-insensitive"):
        lines.append("        .case_insensitive = true,")
    if bench.get("unicode"):
        lines.append("        .unicode = true,")
    lines += ["        .haystack = %s," % haystack_of(bench["haystack"]),
              "        .count = %s," % counts_of(bench["count"]),
              "    },"]
    return lines


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: rebar_cases.py <rebar checkout>")
    checkout = sys.argv[1]
    head = subprocess.run(["git", "-C", checkout, "rev-parse", "HEAD"], capture_output=True, text=True, check=True).stdout.strip()
    if head != COMMIT:
        raise SystemExit(f"rebar_cases.py: the checkout is at {head}, and the set takes {COMMIT}")
    definitions = os.path.join(checkout, "benchmarks/definitions")
    paths = sorted(glob.glob(os.path.join(definitions, "**/*.toml"), recursive=True))
    out = [HEADER.format(commit=COMMIT)]
    for name in ("curated", "others"):
        if name == "others":
            out.append("\npub const others = [_]Bench{\n")
        for path in paths:
            relative = os.path.relpath(path, definitions)[:-len(".toml")]
            top = relative.split("/")[0]
            if (top == "curated") != (name == "curated") or top == "test":
                continue
            stem = os.path.basename(relative) if name == "curated" else relative
            for bench in tomllib.load(open(path, "rb")).get("bench", []):
                if taken(bench):
                    out.append("\n".join(entry(stem, bench)) + "\n")
        out.append("};\n")
    sys.stdout.write("".join(out))


def taken(bench):
    """The rule: an engine the benchmark names is Go's regexp or RE2, and the benchmark runs its
    model."""
    return any(engine in ENGINES for engine in bench.get("engines", [])) and bench["model"] in MODELS


if __name__ == "__main__":
    main()
