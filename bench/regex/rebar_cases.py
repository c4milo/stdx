#!/usr/bin/env python3
"""Writes bench/regex/regex_rebar.zig, bench-regex's held-out set, from rebar's definitions.

    python3 bench/regex/rebar_cases.py <rebar checkout> > bench/regex/regex_rebar.zig

The rule takes every benchmark of rebar's curated set whose `engines` list names Go's regexp or
RE2, the engines of stdx's syntax, and nothing else (decision 86 as amended). No row is chosen by
what stdx does on it. The checkout must be at COMMIT, the commit build/oracle_regex.zig fetches the
set's files from.
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
HEADER = '''//! bench-regex's held-out set (decision 86 as amended): every benchmark of rebar's curated set
//! whose engines name Go's regexp or RE2, the engines of stdx's syntax. bench/regex/rebar_cases.py
//! wrote this file from the definitions of rebar at `commit`; regenerate it, never edit it. Its
//! patterns and haystacks are rebar's, and its answers are the counts rebar's definitions give Go's
//! regexp. Nobody who tuned stdx chose these rows, but design §8 part 22n tuned stdx on them since.

/// The commit of rebar whose definitions and files the set takes.
pub const commit = "{commit}";

/// rebar's models: what one call does with a pattern and a haystack (rebar's MODELS.md).
pub const Model = enum {{ count, count_spans, count_captures, grep, grep_captures, compile }};

/// A pattern: its text, or a file of rebar's `benchmarks/regexes/`.
pub const Pattern = union(enum) {{
    text: []const u8,
    /// A file whose text, trimmed, is the pattern. With `alternate`, each line is an alternative
    /// in a group of its own, and with `literal`, each line stands for its own octets.
    file: struct {{ path: []const u8, alternate: bool = false, literal: bool = false }},
}};

/// A haystack: a text, repeated, or a file of rebar's `benchmarks/haystacks/`.
pub const Haystack = union(enum) {{
    text: struct {{ octets: []const u8, repeat: u32 = 1 }},
    /// The file's lines from `line_start` up to `line_end`, after each invalid UTF-8 sequence is
    /// replaced with U+FFFD where `utf8_lossy` is set.
    file: struct {{ path: []const u8, utf8_lossy: bool = false, line_start: ?u32 = null, line_end: ?u32 = null }},
}};

pub const Bench = struct {{
    /// The definition's file and the benchmark's name, as `01-literal/sherlock-en`.
    name: []const u8,
    model: Model,
    pattern: Pattern,
    case_insensitive: bool = false,
    unicode: bool = false,
    haystack: Haystack,
    /// The answer rebar's definition gives Go's regexp, which every candidate must give.
    count: u64,
}};

pub const benches = [_]Bench{{
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


def go_count(count):
    """The count a definition gives Go's regexp: one number, or the first entry whose engine pattern
    names Go's regexp."""
    if isinstance(count, int):
        return count
    for entry in count:
        if re.fullmatch(entry["engine"], "go/regexp"):
            return entry["count"]
    raise SystemExit("rebar_cases.py: a definition gives Go's regexp no count")


def pattern_of(regex):
    if isinstance(regex, str):
        return ".{ .text = %s }" % zig_string(regex)
    unknown = set(regex) - {"path", "per-line", "literal"}
    if unknown or regex.get("per-line", "alternate") != "alternate":
        raise SystemExit(f"rebar_cases.py: a pattern option the set does not read: {regex}")
    fields = [".path = %s" % zig_string(regex["path"])]
    if regex.get("per-line") == "alternate":
        fields.append(".alternate = true")
    if regex.get("literal"):
        fields.append(".literal = true")
    return ".{ .file = .{ %s } }" % ", ".join(fields)


def haystack_of(haystack):
    if isinstance(haystack, str):
        haystack = {"contents": haystack}
    unknown = set(haystack) - {"path", "contents", "utf8-lossy", "line-start", "line-end", "repeat"}
    if unknown:
        raise SystemExit(f"rebar_cases.py: a haystack option the set does not read: {haystack}")
    if "contents" in haystack:
        fields = [".octets = %s" % zig_string(haystack["contents"])]
        if "repeat" in haystack:
            fields.append(".repeat = %d" % haystack["repeat"])
        return ".{ .text = .{ %s } }" % ", ".join(fields)
    fields = [".path = %s" % zig_string(haystack["path"])]
    if haystack.get("utf8-lossy"):
        fields.append(".utf8_lossy = true")
    for key, field in (("line-start", "line_start"), ("line-end", "line_end")):
        if key in haystack:
            fields.append(".%s = %d" % (field, haystack[key]))
    return ".{ .file = .{ %s } }" % ", ".join(fields)


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
              "        .count = %d," % go_count(bench["count"]),
              "    },"]
    return lines


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: rebar_cases.py <rebar checkout>")
    checkout = sys.argv[1]
    head = subprocess.run(["git", "-C", checkout, "rev-parse", "HEAD"], capture_output=True, text=True, check=True).stdout.strip()
    if head != COMMIT:
        raise SystemExit(f"rebar_cases.py: the checkout is at {head}, and the set takes {COMMIT}")
    out = [HEADER.format(commit=COMMIT)]
    for path in sorted(glob.glob(os.path.join(checkout, "benchmarks/definitions/curated/*.toml"))):
        stem = os.path.basename(path)[:-len(".toml")]
        for bench in tomllib.load(open(path, "rb")).get("bench", []):
            if any(engine in ENGINES for engine in bench.get("engines", [])):
                out.append("\n".join(entry(stem, bench)) + "\n")
    out.append("};\n")
    sys.stdout.write("".join(out))


if __name__ == "__main__":
    main()
