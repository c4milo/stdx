#!/usr/bin/env python3
"""Draws the README's charts from committed bench reports, and checks the committed charts.

    python3 tools/charts.py           draws every chart that bench/charts.txt names
    python3 tools/charts.py --check   fails when a committed chart differs from what it draws

bench/charts.txt names, one line each, a benchmark, an architecture and the committed reports
that the chart draws from: one report, or several jobs on one CPU model. A chart is one SVG under
docs/images/, `<benchmark>-<architecture>.svg`.

A bar is stdx's speed in multiples of the baseline the panel's title names, in the same row of the
same job, since decision 20 compares only numbers of one job; with several jobs, the bar is their
median and a line with caps spans them. Every bar panel of a chart shares one logarithmic axis,
from 0.25 to 4 at most, and a bar past an edge stops there with an arrow. Each bar grows from that
baseline's line at 1. The other baselines are marks of their own shape and color. A row is level
when its ratio lies inside the noise: the two cells' spread combined, or half the range of the
jobs. A summary row, a group of JSON workloads, is a median with a line from its lowest member to
its highest. Each title counts the rows ahead, level and behind, and the members behind under a
summary row, so a loss changes the title. A checksum's bar is the path the report names as the one
the CPU runs. A row marked † repeats a file the branch predictor learns (decision 45).

A benchmark whose libraries differ by orders of magnitude, regex, is drawn by charts_wide.py,
which states its own rules.

An encoder's panel is its speed-size frontier: one point for each library at each level, its
speed over the files, total octets over total time, in multiples of one baseline's middle level in
the same job, against its compression ratio, total octets over total compressed octets. The title
names each stdx level that another library's point beats in both speed and size.
"""
import math
import os
import re
import statistics
import sys

# The tool runs from a checkout, which keeps no compiled copy of charts_wide.py.
sys.dont_write_bytecode = True

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NUM = re.compile(r"^\s*(-?\d+(?:\.\d+)?)")
LOW, HIGH = 0.25, 4.0


def tables(path):
    """Each `## ` section of a report: its table's header and rows, as cells."""
    out, name, head = {}, None, None
    for line in open(path, encoding="utf-8"):
        if line.startswith("## "):
            name, head = line[3:].strip(), None
            continue
        if not line.startswith("|") or name is None:
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if all(set(c) <= set("-: ") for c in cells):
            continue
        if head is None:
            head = cells
            out[name] = (head, [])
        else:
            out[name][1].append(cells)
    return out


def field(path, key):
    """A value of the record above a report's first section: its commit, its CPU model, a
    baseline's version."""
    for line in open(path, encoding="utf-8"):
        if line.startswith("## "):
            break
        if line.startswith(f"| {key} |"):
            return line.split("|")[2].strip()
    return "unknown"


def value(cell):
    m = NUM.match(cell)
    return float(m.group(1)) if m else None


def spread(cell):
    """A cell's spread as a fraction: `334 ± 0.4%` gives 0.004, and a cell with none gives 0."""
    m = re.search(r"±\s*([\d.]+)%", cell)
    return float(m.group(1)) / 100 if m else 0.0


def dispatched(head):
    """The path the report names as the one the CPU runs: `stdx pmull / fastest baseline` names
    `stdx pmull`, and `scalar / libzstd` names `stdx scalar`. A caller gets that path."""
    for h in head:
        m = re.match(r"^(?:stdx )?([\w-]+) / (?:fastest baseline|libzstd)$", h)
        if m and f"stdx {m.group(1)}" in head:
            return f"stdx {m.group(1)}"
    return None


def pick(head, row, name):
    """A cell's (number, spread); `stdx*` is the path the CPU runs."""
    if name == "stdx*":
        name = dispatched(head)
    if name is None or name not in head:
        return None, 0.0
    cell = row[head.index(name)]
    return value(cell), spread(cell)


def median(xs):
    xs = [x for x in xs if x is not None]
    return statistics.median(xs) if xs else None


def label(name):
    return re.sub(r",\s*(MB/s|ratio)$", "", name)


def state(ratio, noise):
    """Ahead, level or behind: level inside the noise, or where the ratio rounds to 1.00."""
    noise = max(noise, 0.005)
    return "ahead" if ratio > 1 + noise else "behind" if ratio < 1 - noise else "level"


class Row:
    """One drawn row: stdx's ratio and the marks' (`values`), a summary's lowest and highest member
    (`span`), the jobs' lowest and highest (`jobs`), the noise that sets its state, and the states
    of the cells it stands for (`members`)."""

    def __init__(self, name, values, noise, span=None, jobs=None, learned=False, members=None):
        self.name, self.values, self.noise, self.span, self.jobs, self.learned = name, values, noise, span, jobs, learned
        self.state = state(values[0], noise) if values[0] is not None else None
        self.members = members if members is not None else ([self.state] if self.state else [])


def summary(name, rows, learned=False):
    values = [median(r.values[j] for r in rows) for j in range(len(rows[0].values))]
    bars = [r.values[0] for r in rows if r.values[0] is not None]
    return Row(name, values, statistics.median(r.noise for r in rows), (min(bars), max(bars)),
               learned=learned, members=[s for r in rows for s in r.members])


class Files:
    """A row for each table row: stdx's bar and the other baselines' marks over `base`, the baseline
    at 1."""
    kind = "bars"

    def __init__(self, section, stdx, base, marks, title):
        self.section, self.stdx, self.base, self.marks, self.title = section, stdx, base, marks, title
        self.unit = "sizes" if "octets a call" in title else "files"

    def data(self, reports, learned):
        out = []
        for name in [r[0] for r in reports[0][self.section][1]]:
            jobs = []
            for report in reports:
                head, rows = report[self.section]
                row = next((x for x in rows if x[0] == name), None)
                base, base_spread = pick(head, row, self.base) if row else (None, 0.0)
                if not base:
                    continue
                cells = [pick(head, row, c) for c in [self.stdx] + self.marks]
                jobs.append(([v / base if v else None for v, _ in cells], math.hypot(cells[0][1], base_spread)))
            if not jobs or median(j[0][0] for j in jobs) is None:
                continue
            values = [median(j[0][k] for j in jobs) for k in range(len(jobs[0][0]))]
            bars = [j[0][0] for j in jobs if j[0][0] is not None]
            noise = max(statistics.median(j[1] for j in jobs), (max(bars) - min(bars)) / 2 / values[0])
            out.append(Row(name, values, noise, jobs=(min(bars), max(bars)) if len(bars) > 1 else None,
                           learned=any(f in name for f in learned)))
        return out


class Grouped(Files):
    """Files, but the rows a group's pattern matches make one summary row where its first sits."""

    def __init__(self, section, stdx, base, marks, title, groups):
        super().__init__(section, stdx, base, marks, title)
        self.groups, self.unit = groups, "rows"

    def data(self, reports, learned):
        out, members = [], {}
        for row in super().data(reports, learned):
            group = next((g for g, pattern in self.groups if re.match(pattern, row.name)), None)
            if group is None:
                out.append(row)
                continue
            if group not in members:
                members[group] = []
                out.append(group)
            members[group].append(row)
        return [summary(f"{x} ({len(members[x])})", members[x], any(r.learned for r in members[x]))
                if isinstance(x, str) else x for x in out]


JSON_GROUPS = [("corpus texts as strings", r"string: [a-z-]+/"), ("hex strings", r"hex: ")]


class Frontier:
    """Each library's points: (library, level, speed section, speed column, ratio section, ratio
    column, the Level column's value or None). `reference` is the (library, level) whose speed is
    1 on the axis."""
    kind = "frontier"

    def __init__(self, points, reference, title):
        self.points, self.reference, self.title = points, reference, title

    @staticmethod
    def totals(report, section, col, level):
        head, rows = report.get(section, (None, []))
        if head is None or col not in head:
            return None
        if level is not None:
            rows = [r for r in rows if r[head.index("Level")] == level]
        octets = [value(r[head.index("Octets")]) for r in rows]
        cells = [value(r[head.index(col)]) for r in rows]
        if not rows or any(c is None or c <= 0 for c in cells):
            return None
        return sum(octets) / sum(o / c for o, c in zip(octets, cells))

    def data(self, reports, learned):
        found = {}
        for report in reports:
            job = {}
            for lib, level, speed_section, speed_col, ratio_section, ratio_col, filt in self.points:
                speed = self.totals(report, speed_section, speed_col, filt)
                ratio = self.totals(report, ratio_section, ratio_col, filt)
                if speed and ratio:
                    job[(lib, level)] = (speed, ratio)
            if self.reference not in job:
                continue
            unit = job[self.reference][0]
            for key, (speed, ratio) in job.items():
                found.setdefault(key, []).append((speed / unit, ratio))
        return {key: (median(x for x, _ in v), median(y for _, y in v)) for key, v in found.items()}


def bars_claim(rows, unit):
    drawn = [r for r in rows if r.state]
    count = {s: sum(r.state == s for r in drawn) for s in ("ahead", "level", "behind")}
    text = f"ahead on {count['ahead']}, level on {count['level']}, behind on {count['behind']} of {len(drawn)} {unit}"
    cells = [s for r in drawn for s in r.members]
    if len(cells) > len(drawn):
        text += f" (of {len(cells)} workloads, {sum(s == 'behind' for s in cells)} behind)"
    low = min(min(r.values[0], r.span[0]) if r.span else r.values[0] for r in drawn)
    high = max(max(r.values[0], r.span[1]) if r.span else r.values[0] for r in drawn)
    return f"{text}; {low:.2f} to {high:.2f}"


def frontier_claim(points):
    """The stdx levels that another library's point beats in both speed and ratio."""
    mine = sorted((k, v) for k, v in points.items() if k[0] == "stdx")
    beaten = []
    for (lib, level), (x, y) in mine:
        better = [f"{l} {lv}" for (l, lv), (px, py) in points.items() if l != "stdx" and px > x * 1.005 and py > y * 1.001]
        if better:
            beaten.append(f"level {level} by {', '.join(better)}")
    if not beaten:
        return f"no other library's point is both faster and smaller than any of stdx's {len(mine)} levels"
    return f"{len(beaten)} of stdx's {len(mine)} levels have a faster and smaller point: " + "; ".join(beaten)


DEFLATE_MARKS = ["zlib-ng, MB/s", "Wuffs, MB/s", "zlib, MB/s"]


def deflate_points():
    return [(lib, n, "Encoding speed, gzip", f"{lib}, MB/s", "Encoding ratio, gzip", f"{lib}, ratio", n)
            for lib in ("zlib", "zlib-ng", "libdeflate", "stdx") for n in ("1", "6", "9")]


def zstd_points():
    return [(lib, n, "Encoding speed", f"{lib}, MB/s", "Encoding ratio", f"{lib}, ratio", n)
            for lib in ("libzstd", "stdx") for n in ("1", "3")]


def brotli_points():
    out = []
    for n, w in (("1", "18"), ("5", "22")):
        speed, ratio = f"Encoding speed, level {n} at WBITS {w}", f"Encoding ratio, level {n} at WBITS {w}"
        out.append(("Google", n, speed, f"Google q{n}, MB/s", ratio, f"Google q{n}, ratio", None))
        out.append(("stdx", n, speed, f"stdx {n}, MB/s", ratio, f"stdx {n}, ratio", None))
    return out


SPECS = {
    "deflate": ("DEFLATE", [
        Files("Decoding, gzip at zlib level 6", "stdx, MB/s", "libdeflate, MB/s", DEFLATE_MARKS,
              "gzip decoding, in multiples of libdeflate's speed"),
        Frontier(deflate_points(), ("libdeflate", "6"),
                 "gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio"),
    ]),
    "zstd": ("Zstandard", [
        Files("Decoding, libzstd level 3", "stdx, MB/s", "libzstd, MB/s", [],
              "Zstandard decoding, in multiples of libzstd's speed"),
        Frontier(zstd_points(), ("libzstd", "3"),
                 "Zstandard encoding: speed in multiples of libzstd's level 3, against compression ratio"),
    ]),
    "brotli": ("brotli", [
        Files("Decoding, quality 11, window 22", "stdx, MB/s", "Google, MB/s", [],
              "brotli decoding, in multiples of Google's speed"),
        Frontier(brotli_points(), ("Google", "5"),
                 "brotli encoding: speed in multiples of Google's quality 5, against compression ratio"),
    ]),
    "json": ("JSON", [
        Grouped("Decoding against the baselines", "stdx, MB/s", "simdjson, MB/s", ["yyjson, MB/s", "std.json, MB/s"],
                "JSON decoding, in multiples of simdjson's speed", JSON_GROUPS),
        Grouped("Encoding against the baselines", "stdx, MB/s", "simdjson, MB/s", ["yyjson, MB/s", "std.json, MB/s"],
                "JSON encoding, in multiples of simdjson's speed", JSON_GROUPS),
        Grouped("TextWriter's methods against the baselines", "stdx, MB/s", "serde_json, MB/s", ["Go jsontext, MB/s"],
                "TextWriter's methods, in multiples of serde_json's speed", JSON_GROUPS),
    ]),
    "base64": ("base64", [
        Files("base 64 encode, GB/s of octets", "stdx", "Rust base64", ["Go encoding/base64", "std.base64"],
              "base64 encoding by octets a call, in multiples of Rust's base64 crate's speed"),
        Files("base 64 decode, GB/s of octets", "stdx", "Rust base64", ["Go encoding/base64", "std.base64"],
              "base64 decoding by octets a call, in multiples of Rust's base64 crate's speed"),
    ]),
    "checksum": ("checksums", [
        Files("CRC-32, GB/s", "stdx*", "libdeflate", ["zlib-ng", "Wuffs", "zlib"],
              "CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed"),
        Files("Adler-32, GB/s", "stdx*", "libdeflate", ["zlib-ng", "Wuffs", "zlib"],
              "Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed"),
        Files("XXH64, GB/s", "stdx*", "libzstd", [],
              "XXH64 by octets a call, the path the CPU runs, in multiples of libzstd's speed"),
    ]),
}

STYLE = """<style>
svg { --surface:#fcfcfb; --ink:#0b0b0b; --ink2:#52514e; --muted:#8a8984; --grid:#e4e3df; --stdx:#2a78d6; --lose:#d4552b; --tie:#a3a29c; --m0:#1c9e77; --m1:#9467bd; --m2:#b8860b; --m3:#8a8984; }
@media (prefers-color-scheme: dark) {
  svg { --surface:#1a1a19; --ink:#f0efec; --ink2:#c3c2b7; --muted:#8f8e86; --grid:#33332f; --stdx:#3987e5; --lose:#e0663b; --tie:#6b6a64; --m0:#2bb38b; --m1:#a982cf; --m2:#d4a62a; --m3:#8f8e86; }
}
text { font-family: -apple-system, "Segoe UI", Helvetica, Arial, sans-serif; fill: var(--ink); }
.title { font-size: 17px; font-weight: 600; } .sub { font-size: 12.5px; fill: var(--ink2); }
.panel { font-size: 13.5px; font-weight: 600; } .row { font-size: 11.5px; fill: var(--ink2); }
.val { font-size: 10.5px; font-weight: 600; } .tick { font-size: 10.5px; fill: var(--muted); }
.legend { font-size: 12px; fill: var(--ink2); }
</style>"""
WIDTH, LEFT, RIGHT, ROW = 900, 270, 64, 17
TICKS = [0.25, 0.5, 0.75, 1, 1.5, 2, 3, 4]
FILL = {"ahead": "var(--stdx)", "level": "var(--tie)", "behind": "var(--lose)"}


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


STDX = ("circle", "var(--stdx)")
AT_ONE = ("diamond", "var(--ink)")
BASELINES = [("triangle", "var(--m0)"), ("square", "var(--m1)"), ("down", "var(--m2)")]


def figures(specs):
    """One figure for each library across a chart: stdx a blue circle, the baseline at 1 a black diamond,
    and the other baselines a triangle, a square and a down triangle, each in its own color. No
    other library takes the circle, so a circle is stdx in every panel."""
    at_one = {label(s.base) for s in specs if s.kind == "bars"} | {s.reference[0] for s in specs if s.kind == "frontier"}
    named = [label(m) for s in specs if s.kind == "bars" for m in s.marks]
    named += [k[0] for s in specs if s.kind == "frontier" for k in s.points]
    others = [lib for lib in dict.fromkeys(named) if lib != "stdx" and lib not in at_one]
    assert len(others) <= len(BASELINES), f"a chart has more baselines than figures: {others}"
    out = {lib: BASELINES[i] for i, lib in enumerate(others)}
    out.update({lib: AT_ONE for lib in at_one})
    out["stdx"] = STDX
    return out


def shape(figure, x, y, r=3.6):
    """A library's mark: its figure, filled with its color."""
    kind, fill = figure
    edge = f'fill="{fill}" stroke="var(--surface)" stroke-width="1.5"'
    if kind == "circle":
        return f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r + 0.8:.1f}" {edge}/>'
    if kind == "triangle":
        return f'<path d="M{x:.1f},{y - r - 0.6:.1f} L{x + r + 0.6:.1f},{y + r:.1f} L{x - r - 0.6:.1f},{y + r:.1f} Z" {edge}/>'
    if kind == "down":
        return f'<path d="M{x:.1f},{y + r + 0.6:.1f} L{x + r + 0.6:.1f},{y - r:.1f} L{x - r - 0.6:.1f},{y - r:.1f} Z" {edge}/>'
    if kind == "square":
        return f'<rect x="{x - r:.1f}" y="{y - r:.1f}" width="{2 * r:.1f}" height="{2 * r:.1f}" {edge}/>'
    return f'<path d="M{x:.1f},{y - r - 1:.1f} L{x + r + 1:.1f},{y:.1f} L{x:.1f},{y + r + 1:.1f} L{x - r - 1:.1f},{y:.1f} Z" {edge}/>'


def axis(panels):
    """One logarithmic range for every bar panel of a chart, inside LOW to HIGH."""
    values = [x for rows in panels for r in rows for x in r.values + list(r.span or ()) + list(r.jobs or ()) if x]
    low = max(min(values + [1]) / 1.15, LOW)
    high = min(max(values + [1]) * 1.15, HIGH)
    return math.log(min(low, 0.8)), math.log(max(high, 1.25))


def legend(items, ly):
    """Each (mark, words) from LEFT, on a new line where the next would pass the right edge."""
    out, x = [], LEFT
    for mark, words in items:
        width = 26 + 7 * len(words)
        if x > LEFT and x + width > WIDTH - 8:
            x, ly = LEFT, ly + 18
        out.append(mark(x + 4, ly - 4) + f'<text class="legend" x="{x + 12}" y="{ly}">{esc(words)}</text>')
        x += width
    return out, ly


def bar_panel(spec, rows, y, low, high, figure, names):
    out = [f'<text class="panel" x="16" y="{y + 16}">{esc(spec.title)}</text>',
           f'<text class="sub" x="16" y="{y + 33}">{esc(bars_claim(rows, spec.unit))}</text>']
    top, plot = y + 46, WIDTH - LEFT - RIGHT
    sx = lambda v: LEFT + plot * (min(max(math.log(v), low), high) - low) / (high - low)
    height = ROW * len(rows)
    for t in TICKS:
        if low <= math.log(t) <= high:
            out.append(f'<line x1="{sx(t):.1f}" y1="{top}" x2="{sx(t):.1f}" y2="{top + height}" stroke="var(--grid)"/>')
            out.append(f'<text class="tick" x="{sx(t):.1f}" y="{top + height + 13}" text-anchor="middle">{t:g}</text>')
    for k, row in enumerate(rows):
        v, cy = row.values, top + k * ROW + ROW / 2
        name = row.name + (" †" if row.learned else "")
        shown = f"{int(name):,} octets" if name.isdigit() else name
        out.append(f'<text class="row" x="{LEFT - 8}" y="{cy + 4:.1f}" text-anchor="end">{esc(shown)}</text>')
        if row.span:
            out.append(f'<line x1="{sx(row.span[0]):.1f}" y1="{cy:.1f}" x2="{sx(row.span[1]):.1f}" y2="{cy:.1f}" stroke="var(--ink2)" stroke-width="1.2"/>')
        reach = None
        if v[0] is not None:
            a, b = sorted((sx(1), sx(v[0])))
            out.append(f'<rect x="{a:.1f}" y="{cy - 5.5:.1f}" width="{max(b - a, 1.5):.1f}" height="11" rx="2" fill="{FILL[row.state]}"/>')
            if not low <= math.log(v[0]) <= high:
                tip = sx(v[0]) + (5 if v[0] > 1 else -5)
                out.append(f'<path d="M{tip:.1f},{cy:.1f} L{sx(v[0]):.1f},{cy - 5.5:.1f} L{sx(v[0]):.1f},{cy + 5.5:.1f} Z" fill="{FILL[row.state]}"/>')
            reach = row.jobs or ((v[0] * (1 - row.noise), v[0] * (1 + row.noise)) if not row.span and row.noise > 0 else None)
            if reach:
                out.append(f'<line x1="{sx(reach[0]):.1f}" y1="{cy:.1f}" x2="{sx(reach[1]):.1f}" y2="{cy:.1f}" stroke="var(--ink)" stroke-width="1.2"/>')
                for e in reach:
                    out.append(f'<line x1="{sx(e):.1f}" y1="{cy - 3:.1f}" x2="{sx(e):.1f}" y2="{cy + 3:.1f}" stroke="var(--ink)" stroke-width="1.2"/>')
        for lib, m in zip(spec.marks, v[1:]):
            if m is not None:
                out.append(shape(figure[label(lib)], sx(m), cy))
        if v[0] is not None:
            edge = max(sx(v[0]) + 5, sx(row.span[1]) if row.span else 0, sx(reach[1]) if reach else 0, sx(1))
            out.append(f'<text class="val" x="{edge + 5:.1f}" y="{cy + 4:.1f}">{v[0]:.2f}</text>')
    out.append(f'<line x1="{sx(1):.1f}" y1="{top - 4}" x2="{sx(1):.1f}" y2="{top + height}" stroke="var(--ink)" stroke-width="1.5"/>')
    rule = lambda x, y: f'<line x1="{x}" y1="{y - 6}" x2="{x}" y2="{y + 6}" stroke="var(--ink)" stroke-width="1.5"/>'
    items = [(rule, f"{names[label(spec.base)]}, at 1")]
    items += [(lambda x, y, f=figure[label(m)]: shape(f, x, y), names[label(m)]) for m in spec.marks]
    part, ly = legend(items, top + height + 30)
    return out + part, ly + 16


def frontier_panel(spec, points, y, figure, names):
    out = [f'<text class="panel" x="16" y="{y + 16}">{esc(spec.title)}</text>',
           f'<text class="sub" x="16" y="{y + 33}">{esc(frontier_claim(points))}</text>']
    top, height, plot = y + 54, 230, WIDTH - LEFT - RIGHT
    xs, ys = [p[0] for p in points.values()], [p[1] for p in points.values()]
    xlow, xhigh = math.log(min(xs) / 1.25), math.log(max(xs) * 1.25)
    pad = (max(ys) - min(ys)) * 0.12 + 0.01
    ylow, yhigh = min(ys) - pad, max(ys) + pad
    sx = lambda v: LEFT + plot * (math.log(v) - xlow) / (xhigh - xlow)
    sy = lambda v: top + height - height * (v - ylow) / (yhigh - ylow)
    for t in [0.05, 0.1, 0.25, 0.5, 1, 2, 4, 8, 16, 32]:
        if xlow <= math.log(t) <= xhigh:
            out.append(f'<line x1="{sx(t):.1f}" y1="{top}" x2="{sx(t):.1f}" y2="{top + height}" stroke="var(--grid)"/>')
            out.append(f'<text class="tick" x="{sx(t):.1f}" y="{top + height + 13}" text-anchor="middle">{t:g}</text>')
    step = 10 ** math.floor(math.log10((yhigh - ylow) / 2))
    t = math.ceil(ylow / step) * step
    while t <= yhigh:
        out.append(f'<line x1="{LEFT}" y1="{sy(t):.1f}" x2="{LEFT + plot}" y2="{sy(t):.1f}" stroke="var(--grid)"/>')
        out.append(f'<text class="tick" x="{LEFT - 6}" y="{sy(t) + 4:.1f}" text-anchor="end">{t:.2f}</text>')
        t += step
    out.append(f'<text class="row" x="{LEFT - 8}" y="{top - 8}" text-anchor="end">compression ratio</text>')
    others = [lib for lib in dict.fromkeys(k[0] for k in points) if lib != "stdx"]
    for lib in others + ["stdx"]:
        pts = sorted((v[0], v[1], k[1]) for k, v in points.items() if k[0] == lib)
        out.append(f'<polyline points="{" ".join(f"{sx(a):.1f},{sy(b):.1f}" for a, b, _ in pts)}" fill="none" stroke="{figure[lib][1]}" stroke-width="1.6"/>')
        for a, b, level in pts:
            out.append(shape(figure[lib], sx(a), sy(b), 4.2))
            out.append(f'<text class="val" x="{sx(a) + 7:.1f}" y="{sy(b) - 6:.1f}">{level}</text>')
    items = [(lambda x, y, f=figure[lib]: shape(f, x, y), names[lib] + (f", level {spec.reference[1]} at 1" if lib == spec.reference[0] else ""))
             for lib in ["stdx"] + others]
    part, ly = legend(items, top + height + 34)
    out += part
    out.append(f'<text class="legend" x="{LEFT}" y="{ly + 18}">The number beside a point is its level. Up is smaller output, and right is faster.</text>')
    return out, ly + 34


def versions(paths, lib):
    """The version each report names for a baseline, as one word list; none for stdx, whose
    commit the subtitle names, or for a report from before decision 20's 2026-11-19 amendment."""
    found = sorted({field(p, lib) for p in paths} - {"unknown"}) if lib != "stdx" else []
    return [" / ".join(found)] if found else []


def draw(benchmark, paths):
    if benchmark not in SPECS:
        sys.path.insert(0, os.path.join(ROOT, "tools"))
        import charts_wide
        return charts_wide.draw(sys.modules[__name__], benchmark, paths)
    name, specs = SPECS[benchmark]
    reports = [tables(p) for p in paths]
    cpus = {field(p, "CPU model") for p in paths}
    assert len(cpus) == 1, f"{benchmark}: the reports name more than one CPU model: {sorted(cpus)}"
    text = open(paths[0], encoding="utf-8").read()
    m = re.search(r"has learned, the shorter the file the more: (.*?)\.(?:\s|$)", text)
    learned = [f.strip() for f in m.group(1).split(",")] if m else []
    present = [s for s in specs if s.kind == "frontier" or all(s.section in r for r in reports)]
    data = [s.data(reports, learned) for s in present]
    low, high = axis([d for s, d in zip(present, data) if s.kind == "bars"])
    figure = figures(present)
    names = {lib: " ".join([lib] + versions(paths, lib)) for lib in figure}
    body, y, descs, any_learned = [], 64, [], False
    for spec, rows in zip(present, data):
        if not rows:
            continue
        if spec.kind == "bars":
            part, y = bar_panel(spec, rows, y, low, high, figure, names)
            descs.append(f"{spec.title}: {bars_claim(rows, spec.unit)}")
            any_learned = any_learned or any(r.learned for r in rows)
        else:
            part, y = frontier_panel(spec, rows, y, figure, names)
            descs.append(f"{spec.title}: {frontier_claim(rows)}")
        body += part
    legend = []
    legend.append(f'<text class="legend" x="16" y="{y + 9}">A bar is stdx:</text>')
    for x, fill, words in ((104, "stdx", "ahead"), (162, "tie", "level, inside the noise"), (322, "lose", "behind")):
        legend.append(f'<rect x="{x}" y="{y}" width="12" height="10" rx="2" fill="var(--{fill})"/><text class="legend" x="{x + 17}" y="{y + 9}">{words}</text>')
    whisker = "the jobs, lowest to highest" if len(paths) > 1 else "the two cells' spread"
    legend.append(f'<text class="legend" x="400" y="{y + 9}">|—| {whisker}</text>')
    if any_learned:
        y += 18
        legend.append(f'<text class="legend" x="16" y="{y + 9}">† the benchmark repeats this file of 256 KiB or less, so the branch predictor learns it (decision 45)</text>')
    height = y + 26
    cpu = cpus.pop()
    runs = ", ".join(field(p, "Run URL").rsplit("/", 1)[-1] for p in paths)
    commits = ", ".join(sorted({field(p, "Commit") for p in paths}))
    title = f"stdx's {name} against its baselines, on {cpu}"
    sub = (f"The median of {len(paths)} jobs, runs {runs}, at {commits}." if len(paths) > 1 else
           f"One job of run {runs} at commit {commits}.") + " The line at 1 is the baseline each panel's title names; the axis is logarithmic."
    head = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {WIDTH} {height}" width="{WIDTH}" height="{height}" role="img" aria-labelledby="t d">',
            f'<title id="t">{esc(title)}</title>', f'<desc id="d">{esc(". ".join(descs))}.</desc>', STYLE,
            f'<rect width="{WIDTH}" height="{height}" fill="var(--surface)"/>',
            f'<text class="title" x="16" y="26">{esc(title)}</text>', f'<text class="sub" x="16" y="46">{esc(sub)}</text>']
    return "\n".join(head + body + legend + ["</svg>", ""])


def manifest():
    for line in open(os.path.join(ROOT, "bench", "charts.txt"), encoding="utf-8"):
        words = line.split("#", 1)[0].split()
        if words:
            yield words[0], words[1], [os.path.join(ROOT, p) for p in words[2:]]


def main():
    check = sys.argv[1:] == ["--check"]
    stale = []
    for benchmark, arch, reports in manifest():
        svg = draw(benchmark, reports)
        out = os.path.join(ROOT, "docs", "images", f"{benchmark}-{arch}.svg")
        if check:
            if not os.path.exists(out) or open(out, encoding="utf-8").read() != svg:
                stale.append(out)
        else:
            os.makedirs(os.path.dirname(out), exist_ok=True)
            open(out, "w", encoding="utf-8").write(svg)
    if stale:
        sys.exit("charts.py: these charts differ from what their reports draw; run python3 tools/charts.py:\n  " + "\n  ".join(stale))


if __name__ == "__main__":
    main()
