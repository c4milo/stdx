"""Draws the chart of a benchmark whose libraries differ by orders of magnitude: regex.

charts.py calls `draw` with itself as `kit`: its report reader, its marks, its legend and its
style. This file states the rules that differ from charts.py's.

- A panel holds the rows of one report section whose names match the panel's pattern. Rows that
  measure another kind of pattern stand in another panel, so one count never mixes them.
- A bar is stdx's speed in multiples of the baseline at 1, the median of the jobs. Every panel
  shares one logarithmic axis, as in charts.py, so the line at 1 stands at one place down the
  chart and a factor of 4 is one length. Its limits are the chart's lowest and highest value,
  and its ticks are powers of 4.
- A row's number stands in a column at the right, after a square in the colour of its state.
  A ratio under 0.095 is printed as 1/N. A row within a factor of 2 of the baseline also shows
  its whisker as two numbers, since so short a whisker cannot be read from the axis.
- A row's whisker is the jobs' lowest and highest ratio. With one job it is the ratio divided
  and multiplied by 1 plus the two cells' combined spread.
- A row is level where its whisker touches the band around 1. A panel's band is the most that
  stdx differed from itself on a row of the panel: stdx, timed first in each round, over stdx
  timed again last in the round, as the median of the jobs. The band holds what repeats from
  job to job, and the whisker holds the rest. The band is never under 5%: the jobs of one CPU
  model repeat to 1%, but a row that stood 1% to 3% ahead on one x86-64 model stood 3% to 8%
  behind on another, from the same binary, so a lead under 5% is no lead a reader can keep.
- A hollow circle is stdx with its skip off, on the search panels.
- A library that has no speed on a row has its mark, hollow, after the row's name.
- Each panel's second line counts stdx against each other library by the same rule, since the
  bar shows one. A panel of unlike patterns prints no mean.
"""
import math
import re
import statistics

LIMITS = (4.0 ** -8, 4.0 ** 8)
BAND_MIN = 0.05
PAD = 1.3
RIGHT = 138
BASE = "Rust regex"
MARKS = ["Go regexp", "mvzr", "zig-regex"]
TWIN = "stdx, no skip"
AGAIN = "stdx, again"
SEARCH = "Search in 1 MiB, MB/s"
TEXTS = "Match short texts, millions of texts a second"
GROUPS = "Capture groups of short texts, millions of texts a second"
COMPILE = "Compile, thousands of patterns a second"
# What a row's name starts with in the report, which a panel's title says for all its rows.
GROUP = re.compile(r"^(literal|class|other): ")
CHARS = 138


class Panel:
    """The rows of `section` whose names match `rows`. `twin` adds stdx with its skip off, and
    `mean` prints a geometric mean, which unlike patterns do not have."""

    def __init__(self, section, rows, title, twin=False, mean=True):
        self.section, self.rows, self.title, self.twin, self.mean = section, re.compile(rows), title, twin, mean


PANELS = {
    "regex": ("regular expressions", [
        Panel(SEARCH, r"^literal: ", "search for a literal: every match in 1 MiB, in multiples of Rust regex's speed", True),
        Panel(SEARCH, r"^class: ", "search that starts with a class: every match in 1 MiB, in multiples of Rust regex's speed", True),
        Panel(SEARCH, r"^other: ", "search of other shapes: every match in 1 MiB, in multiples of Rust regex's speed", True, False),
        Panel(TEXTS, r"", "a pattern that validates each of 65,536 short texts, in multiples of Rust regex's speed"),
        Panel(GROUPS, r"", "the capture groups of each of 65,536 short texts, in multiples of Rust regex's speed"),
        Panel(COMPILE, r"", "a pattern compiled and made ready for its first search, in multiples of Rust regex's speed", False, False),
    ]),
}


class Row:
    """One drawn row. `over` holds stdx against each other library: a ratio and its whisker."""

    def __init__(self, label, ratio, whisker, marks, missing, twin, over, own):
        self.label, self.ratio, self.whisker, self.marks, self.missing = label, ratio, whisker, marks, missing
        self.twin, self.over, self.own, self.state = twin, over, own, None


def ratio_text(ratio):
    """A ratio as the chart prints it: 1/N under 0.095, where two decimals would leave one digit."""
    if ratio < 0.095:
        return f"1/{round(1 / ratio)}"
    return f"{ratio:.0f}" if ratio >= 100 else f"{ratio:.2f}"


def state(ratio, whisker, band):
    if whisker[0] <= 1 + band and whisker[1] >= 1 / (1 + band):
        return "level"
    return "ahead" if ratio > 1 else "behind"


def summed(ratios, noise):
    """The jobs' median ratio and its whisker: lowest to highest, or one job's spread."""
    ratio = statistics.median(ratios)
    return ratio, ((min(ratios), max(ratios)) if len(ratios) > 1 else (ratio / (1 + noise), ratio * (1 + noise)))


def row_of(kit, panel, reports, name):
    """A row over the jobs that hold it, or None where no job timed stdx and the baseline."""
    base, others, twins, owns = [], {lib: [] for lib in MARKS}, [], []
    noise, noises = 0.0, {}
    for report in reports:
        head, body = report[panel.section]
        cells = next((x for x in body if x[0] == name), None)
        if not cells:
            continue
        stdx, stdx_spread = kit.pick(head, cells, "stdx")
        rust, rust_spread = kit.pick(head, cells, BASE)
        if not stdx or not rust:
            continue
        base.append(stdx / rust)
        noise = math.hypot(stdx_spread, rust_spread)
        for lib in MARKS:
            value, spread = kit.pick(head, cells, lib)
            if value:
                others[lib].append((stdx / value, value / rust))
                noises[lib] = math.hypot(stdx_spread, spread)
        twin, again = kit.pick(head, cells, TWIN)[0], kit.pick(head, cells, AGAIN)[0]
        if twin and panel.twin:
            twins.append(twin / rust)
        if again:
            owns.append(stdx / again)
    if not base:
        return None
    ratio, whisker = summed(base, noise)
    over = {lib: summed([o for o, _ in pairs], noises[lib]) for lib, pairs in others.items() if pairs}
    marks = {lib: statistics.median(m for _, m in pairs) for lib, pairs in others.items() if pairs}
    return Row(GROUP.sub("", name), ratio, whisker, marks, [lib for lib in MARKS if lib not in marks],
               statistics.median(twins) if twins else None, over, statistics.median(owns) if owns else None)


def rows_of(kit, panel, reports):
    names = [r[0] for r in reports[0][panel.section][1] if panel.rows.search(r[0])]
    rows = [row for row in (row_of(kit, panel, reports, name) for name in names) if row]
    band = max([BAND_MIN] + [max(r.own, 1 / r.own) - 1 for r in rows if r.own])
    for row in rows:
        row.state = state(row.ratio, row.whisker, band)
    return rows, band


def geometric_mean(values):
    return math.exp(sum(math.log(v) for v in values) / len(values))


def claim(panel, rows, band):
    """A panel's first line: stdx against the baseline at 1."""
    within = f"level is within {band * 100:.1f}% of 1"
    if len(rows) == 1:
        return f"against {BASE}: {rows[0].state}, at {ratio_text(rows[0].ratio)}; {within}"
    count = {s: sum(r.state == s for r in rows) for s in ("ahead", "level", "behind")}
    ratios = [r.ratio for r in rows]
    mean = f"geometric mean {ratio_text(geometric_mean(ratios))}, " if panel.mean else ""
    return (f"against {BASE}: ahead on {count['ahead']}, level on {count['level']}, behind on {count['behind']} of {len(rows)} patterns; "
            f"{mean}from {ratio_text(min(ratios))} to {ratio_text(max(ratios))}; {within}")


def versus(rows, band):
    """A panel's second line: stdx against each library that the marks show, by the bar's rule."""
    parts = []
    for lib in MARKS:
        states = [state(*r.over[lib], band) for r in rows if lib in r.over]
        if not states:
            parts.append(f"{lib}: no pattern timed")
            continue
        level = states.count("level")
        parts.append(f"{lib}: ahead on {states.count('ahead')}, " + (f"level on {level}, " if level else "") + f"behind on {states.count('behind')} of {len(states)}")
    return "against " + "; ".join(parts)


def span_of(panels):
    """The chart's range, as logarithms, with room past its lowest and highest value."""
    values = [1.0]
    for rows in panels:
        for r in rows:
            values += [r.ratio, r.whisker[0], r.whisker[1]] + list(r.marks.values()) + ([r.twin] if r.twin else [])
    return math.log(max(min(values) / PAD, LIMITS[0])), math.log(min(max(values) * PAD, LIMITS[1]))


def ticks_of(low, high):
    step = math.log(4)
    return [math.exp(k * step) for k in range(math.ceil(low / step - 1e-9), math.floor(high / step + 1e-9) + 1)]


def tick_text(tick):
    return f"1/{round(1 / tick)}" if tick < 1 else f"{round(tick)}"


def wrap(words, chars=CHARS):
    """`words` as lines of at most `chars` characters."""
    lines, line = [], ""
    for word in words.split(" "):
        if line and len(line) + 1 + len(word) > chars:
            lines.append(line)
            line = word
        else:
            line = f"{line} {word}" if line else word
    return lines + [line]


def ring(x, y):
    """stdx with its skip off: stdx's circle, hollow, on a line of the surface's colour so that
    it shows over a bar."""
    return (f'<circle cx="{x:.1f}" cy="{y:.1f}" r="4.6" fill="none" stroke="var(--surface)" stroke-width="1.6"/>'
            f'<circle cx="{x:.1f}" cy="{y:.1f}" r="3.4" fill="none" stroke="var(--stdx)" stroke-width="1.8"/>')


def hollow(figure, x, y, r=3.2):
    """A library's mark with no fill: the library has no speed on the row."""
    kind, colour = figure
    edge = f'fill="var(--surface)" stroke="{colour}" stroke-width="1.3"'
    if kind == "triangle":
        return f'<path d="M{x:.1f},{y - r:.1f} L{x + r:.1f},{y + r:.1f} L{x - r:.1f},{y + r:.1f} Z" {edge}/>'
    if kind == "down":
        return f'<path d="M{x:.1f},{y + r:.1f} L{x + r:.1f},{y - r:.1f} L{x - r:.1f},{y - r:.1f} Z" {edge}/>'
    return f'<rect x="{x - r:.1f}" y="{y - r:.1f}" width="{2 * r:.1f}" height="{2 * r:.1f}" {edge}/>'


def row_svg(kit, row, cy, sx, figures):
    left, column = kit.LEFT, kit.WIDTH - RIGHT + 8
    out = [hollow(figures[lib], left - 12 - 11 * k, cy) for k, lib in enumerate(reversed(row.missing))]
    edge = left - 8 - (11 * len(row.missing) + 3 if row.missing else 0)
    out.append(f'<text class="row" x="{edge}" y="{cy + 4:.1f}" text-anchor="end">{kit.esc(row.label)}</text>')
    a, b = sorted((sx(1), sx(row.ratio)))
    out.append(f'<rect x="{a:.1f}" y="{cy - 5.5:.1f}" width="{max(b - a, 1.5):.1f}" height="11" rx="2" fill="{kit.FILL[row.state]}"/>')
    out.append(f'<line x1="{sx(row.whisker[0]):.1f}" y1="{cy:.1f}" x2="{sx(row.whisker[1]):.1f}" y2="{cy:.1f}" stroke="var(--ink)" stroke-width="1.2"/>')
    for end in row.whisker:
        out.append(f'<line x1="{sx(end):.1f}" y1="{cy - 3:.1f}" x2="{sx(end):.1f}" y2="{cy + 3:.1f}" stroke="var(--ink)" stroke-width="1.2"/>')
    for lib in MARKS:
        if lib in row.marks:
            out.append(kit.shape(figures[lib], sx(row.marks[lib]), cy))
    if row.twin:
        out.append(ring(sx(row.twin), cy))
    out.append(f'<rect x="{column}" y="{cy - 4:.1f}" width="8" height="8" rx="2" fill="{kit.FILL[row.state]}"/>')
    out.append(f'<text class="val" x="{column + 13}" y="{cy + 4:.1f}">{ratio_text(row.ratio)}</text>')
    if 0.5 <= row.ratio <= 2:
        # Three decimals where two would print both ends alike.
        digits = 3 if f"{row.whisker[0]:.2f}" == f"{row.whisker[1]:.2f}" else 2
        out.append(f'<text class="tick" x="{column + 44}" y="{cy + 4:.1f}">{row.whisker[0]:.{digits}f} to {row.whisker[1]:.{digits}f}</text>')
    return out


def panel_svg(kit, panel, rows, band, y, span, figures):
    low, high = span
    unit = (kit.WIDTH - kit.LEFT - RIGHT) / (high - low)
    sx = lambda v: kit.LEFT + (min(max(math.log(v), low), high) - low) * unit
    out = [f'<text class="panel" x="16" y="{y + 16}">{kit.esc(panel.title)}</text>']
    lines = wrap(claim(panel, rows, band)) + wrap(versus(rows, band))
    out += [f'<text class="sub" x="16" y="{y + 33 + 16 * k}">{kit.esc(line)}</text>' for k, line in enumerate(lines)]
    top, height = y + 30 + 16 * len(lines), kit.ROW * len(rows)
    for tick in ticks_of(low, high):
        out.append(f'<line x1="{sx(tick):.1f}" y1="{top}" x2="{sx(tick):.1f}" y2="{top + height}" stroke="var(--grid)"/>')
        out.append(f'<text class="tick" x="{sx(tick):.1f}" y="{top + height + 13}" text-anchor="middle">{tick_text(tick)}</text>')
    for k, row in enumerate(rows):
        out += row_svg(kit, row, top + k * kit.ROW + kit.ROW / 2, sx, figures)
    out.append(f'<line x1="{sx(1):.1f}" y1="{top - 4}" x2="{sx(1):.1f}" y2="{top + height}" stroke="var(--ink)" stroke-width="1.5"/>')
    return out, top + height + 34


def legend_svg(kit, paths, y, figures, jobs):
    """The chart's one legend, above its panels."""
    rule = lambda x, ly: f'<line x1="{x}" y1="{ly - 6}" x2="{x}" y2="{ly + 6}" stroke="var(--ink)" stroke-width="1.5"/>'
    version = lambda lib: " ".join([lib] + kit.versions(paths, lib))
    items = [(rule, f"{version(BASE)}, at 1")]
    items += [(lambda x, ly, f=figures[lib]: kit.shape(f, x, ly), version(lib)) for lib in MARKS]
    items.append((ring, "stdx with its skip off"))
    saved, kit.LEFT = kit.LEFT, 16
    out, y = kit.legend(items, y)
    kit.LEFT = saved
    y += 20
    out.append(f'<text class="legend" x="16" y="{y}">A bar is stdx:</text>')
    for x, fill, words in ((104, "stdx", "ahead"), (162, "tie", "level"), (222, "lose", "behind")):
        out.append(f'<rect x="{x}" y="{y - 9}" width="12" height="10" rx="2" fill="var(--{fill})"/><text class="legend" x="{x + 17}" y="{y}">{words}</text>')
    whisker = "the jobs, lowest to highest" if jobs > 1 else "the two cells' spread"
    out.append(f'<text class="legend" x="292" y="{y}">|—| {whisker}</text>')
    out.append(hollow(figures[MARKS[0]], 500, y - 4) + hollow(figures[MARKS[1]], 512, y - 4) + hollow(figures[MARKS[2]], 524, y - 4))
    out.append(f'<text class="legend" x="534" y="{y}">after a name: that library has no speed there</text>')
    return out, y


def notes_svg(kit, y):
    notes = ["A row is level where its whisker touches its panel's band around 1. The band is the most that stdx differed from itself on a row of the panel: "
             "stdx timed first in each round over stdx timed again last, as the median of the jobs. It is never under 5%, "
             "since a lead under that on one CPU model did not hold on another.",
             "A library has no speed on a pattern that it refuses, where its answer is not Go regexp's, and where it has no such call. The report says which."]
    out = []
    for note in notes:
        for line in wrap(note):
            y += 17
            out.append(f'<text class="legend" x="16" y="{y}">{kit.esc(line)}</text>')
    return out, y


def draw(kit, benchmark, paths):
    name, panels = PANELS[benchmark]
    reports = [kit.tables(p) for p in paths]
    cpus = {kit.field(p, "CPU model") for p in paths}
    assert len(cpus) == 1, f"{benchmark}: the reports name more than one CPU model: {sorted(cpus)}"
    panels = [p for p in panels if all(p.section in r for r in reports)]
    data = [(p,) + rows_of(kit, p, reports) for p in panels]
    data = [(p, rows, band) for p, rows, band in data if rows]
    span = span_of([rows for _, rows, _ in data])
    figures = dict(zip(MARKS, kit.BASELINES))
    legend, y = legend_svg(kit, paths, 88, figures, len(paths))
    body, descs = [], []
    y += 22
    for panel, rows, band in data:
        part, y = panel_svg(kit, panel, rows, band, y, span, figures)
        body += part
        descs.append(f"{panel.title}: {claim(panel, rows, band)}; {versus(rows, band)}")
    notes, y = notes_svg(kit, y - 14)
    height = y + 16
    runs = ", ".join(kit.field(p, "Run URL").rsplit("/", 1)[-1] for p in paths)
    commits = ", ".join(sorted({kit.field(p, "Commit") for p in paths}))
    title = f"stdx's {name} against libraries in Rust, Go and Zig, on {cpus.pop()}"
    subs = [f"The median of {len(paths)} jobs, runs {runs}, at commit {commits}." if len(paths) > 1 else f"One job of run {runs} at commit {commits}.",
            "Each bar is stdx in multiples of the baseline at the line at 1. Every panel shares one logarithmic axis."]
    head = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {kit.WIDTH} {height}" width="{kit.WIDTH}" height="{height}" role="img" aria-labelledby="t d">',
            f'<title id="t">{kit.esc(title)}</title>', f'<desc id="d">{kit.esc(". ".join(descs))}.</desc>', kit.STYLE,
            f'<rect width="{kit.WIDTH}" height="{height}" fill="var(--surface)"/>',
            f'<text class="title" x="16" y="26">{kit.esc(title)}</text>']
    head += [f'<text class="sub" x="16" y="{46 + 16 * k}">{kit.esc(sub)}</text>' for k, sub in enumerate(subs)]
    return "\n".join(head + legend + body + notes + ["</svg>", ""])
