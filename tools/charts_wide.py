"""Draws the chart of a benchmark whose libraries differ by orders of magnitude: regex.

charts.py calls `draw` with itself as `kit`: its report reader, its marks and its style. This file
states the rules that differ from charts.py's (decision 85 as amended on 2026-11-22).

- The chart draws one CPU model: the model that most of its reports name, and on a tie the model
  of the first report. A report that names no model is refused, and so is a model with fewer jobs
  than JOBS_MIN, since its interval would say nothing.
- A row's ratio is stdx's speed over Rust's crate's in one job. Its bar is the median of the jobs'
  ratios, and a dot stands for each job, so two groups of jobs show as two groups of dots.
- A row's whisker is an interval of that median: from the k-th lowest job to the k-th highest,
  with k the largest that still holds the median of all such jobs at CONFIDENCE, by the sign test.
  Unlike the lowest and highest job, it narrows as jobs are added.
- A row is ahead or behind where its whole interval lies above or below 1, and level where the
  interval holds 1 and lies inside MARGIN of 1. A row whose interval holds 1 and reaches past the
  margin is unclear: its jobs do not settle it. A difference inside the margin is one this chart
  calls too small to matter, and each count still names its direction.
- The axis is stdx over Rust's crate alone, logarithmic, with ticks at powers of 2. A bar past an
  edge stops there with an arrow. The other libraries stand in columns at the right: stdx's speed
  over theirs, the median of the jobs, or a dash where a library has no speed.
- A panel holds the rows of one report section whose names match its pattern. Two rows of one
  pattern on two texts are two rows and one pattern, and each count says both.
- The compile panel's rows are shorter, since a program compiles a pattern once and searches with
  it many times.
- The jobs of the other CPU models stand as small diamonds at their median, and the notes name the
  rows that fall on the other side of 1 there.

`python3 tools/charts_wide_test.py` runs the tests of these rules.
"""
import math
import re
import statistics
from collections import Counter

# The equivalence margin: a difference under 5% is one this chart calls too small to matter.
MARGIN = 0.05
# The confidence of a row's interval of the median.
CONFIDENCE = 0.95
# The fewest jobs of one CPU model that a chart draws.
JOBS_MIN = 5
# The axis's widest limits, and the room past its lowest and highest value.
LIMITS = (1 / 4, 16.0)
PAD = 1.2
BASE = "Rust regex"
MARKS = ["Go regexp", "mvzr", "zig-regex"]
SHORT = {"Go regexp": "Go", "mvzr": "mvzr", "zig-regex": "zig-regex"}
AGAIN = "stdx, again"
SEARCH = "Search in 1 MiB, MB/s"
TEXTS = "Match short texts, millions of texts a second"
GROUPS = "Capture groups of short texts, millions of texts a second"
COMPILE = "Compile, thousands of patterns a second"
HELD_SEARCH = "Held-out search, rebar's curated set, MB/s"
HELD_COMPILE = "Held-out compile, rebar's curated set, thousands of patterns a second"
# What a row's name starts with in the report, which a panel's title says for all its rows.
GROUP = re.compile(r"^(literal|class|other): ")
# The suffix of a row that times a pattern of another row on a second text.
SECOND = ", second text"
CHARS = 138
# The characters of a line of the subtitle, whose type is larger than a panel's lines.
SUB_CHARS = 118
LEFT, RIGHT = 250, 320
COLUMN = 66


class Panel:
    """The rows of `section` whose names match `rows`. `mean` prints a geometric mean, which
    unlike patterns do not have, `row` is the height of a row, and `marks` the libraries whose
    columns stand at the right."""

    def __init__(self, section, rows, title, mean=True, row=None, note=None, marks=None):
        self.section, self.rows, self.title, self.mean, self.row, self.note = section, re.compile(rows), title, mean, row, note
        self.marks = MARKS if marks is None else marks


# Each chart: what it draws, what it draws stdx against, and its panels.
PANELS = {
    "regex": ("regular expressions", "libraries in Rust, Go and Zig", [
        Panel(SEARCH, r"^literal: ", "search for a literal: every match in 1 MiB"),
        Panel(SEARCH, r"^class: ", "search that starts with a class: every match in 1 MiB"),
        Panel(SEARCH, r"^other: ", "search of other shapes: every match in 1 MiB", False),
        Panel(TEXTS, r"", "a pattern that validates each of 65,536 short texts"),
        Panel(GROUPS, r"", "the capture groups of each of 65,536 short texts"),
        Panel(COMPILE, r"", "a pattern compiled and made ready for its first search", False, 12,
              "stdx compiles both programs and readies a searcher, Rust's crate runs Regex::new and Go "
              "regexp.Compile. A program compiles a pattern once and searches with it many times."),
    ]),
    # The held-out set: a benchmark of its own, which nobody who tuned stdx chose (decision 86).
    "regex-rebar": ("regular expressions on rebar's curated set", "Rust's regex and Go's regexp", [
        Panel(HELD_SEARCH, r"", "rebar's curated searches", True, None,
              "Each row is a benchmark of rebar's curated set whose engines name Go's regexp or RE2, under rebar's "
              "own model, pattern and haystack. No claim of stdx is judged on these rows. rebar's author also wrote "
              "Rust's crate, and rebar's BIAS.md says the set may favor that crate.", ["Go regexp"]),
        Panel(HELD_COMPILE, r"", "rebar's curated compiles", True, 12, None, ["Go regexp"]),
    ]),
}


def coverage(jobs, k):
    """The chance that the k-th lowest and k-th highest of `jobs` ratios hold their median."""
    return 1 - 2 * sum(math.comb(jobs, i) for i in range(k)) / 2 ** jobs


def rank(jobs):
    """The k of a row's interval: the largest whose coverage is CONFIDENCE, or 1 for too few jobs."""
    k = 1
    while k + 1 <= (jobs + 1) // 2 and coverage(jobs, k + 1) >= CONFIDENCE:
        k += 1
    return k


def interval(ratios):
    ordered = sorted(ratios)
    k = rank(len(ordered))
    return ordered[k - 1], ordered[len(ordered) - k]


def inside(low, high):
    """Whether an interval lies inside the margin around 1."""
    return 1 / (1 + MARGIN) <= low and high <= 1 + MARGIN


def state(low, high):
    if low > 1:
        return "ahead"
    if high < 1:
        return "behind"
    return "level" if inside(low, high) else "unclear"


def pattern(name):
    """The pattern a row times: a row on a second text times the pattern of the row before it."""
    return name[:-len(SECOND)] if name.endswith(SECOND) else name


class Measure:
    """The jobs' ratios of stdx over one library, their median, interval and state."""

    def __init__(self, ratios):
        self.ratios = ratios
        self.median = statistics.median(ratios)
        self.low, self.high = interval(ratios)
        self.state = state(self.low, self.high)
        self.small = self.state in ("ahead", "behind") and inside(self.low, self.high)


class Row:
    def __init__(self, name, base, libs, others, drift):
        self.name, self.label, self.pattern = name, GROUP.sub("", name), pattern(GROUP.sub("", name))
        self.base, self.libs, self.others, self.drift = base, libs, others, drift


def ratio_text(ratio):
    """A ratio as the chart prints it: 1/N under 0.095, where two decimals would leave one digit,
    and three decimals inside the margin, where two could print 0.996 as 1.00."""
    if ratio < 0.095:
        return f"1/{round(1 / ratio)}"
    if inside(ratio, ratio):
        return f"{ratio:.3f}"
    return f"{ratio:.0f}" if ratio >= 100 else f"{ratio:.2f}"


def cells_of(kit, report, panel, name):
    head, body = report[panel.section]
    return head, next((x for x in body if x[0] == name), None)


def row_of(kit, panel, drawn, others, name):
    """A row over the drawn jobs, or None where no drawn job timed both stdx and Rust's crate."""
    base, libs, drift = [], {lib: [] for lib in panel.marks}, 0.0
    for report in drawn:
        head, cells = cells_of(kit, report, panel, name)
        stdx = kit.pick(head, cells, "stdx")[0] if cells else None
        rust = kit.pick(head, cells, BASE)[0] if cells else None
        if not stdx or not rust:
            continue
        base.append(stdx / rust)
        for lib in panel.marks:
            value = kit.pick(head, cells, lib)[0]
            if value:
                libs[lib].append(stdx / value)
        again = kit.pick(head, cells, AGAIN)[0]
        if again:
            drift = max(drift, abs(stdx / again - 1))
    if not base:
        return None
    medians = {}
    for model, reports in others.items():
        ratios = []
        for report in reports:
            head, cells = cells_of(kit, report, panel, name)
            stdx = kit.pick(head, cells, "stdx")[0] if cells else None
            rust = kit.pick(head, cells, BASE)[0] if cells else None
            if stdx and rust:
                ratios.append(stdx / rust)
        if ratios:
            medians[model] = statistics.median(ratios)
    row = Row(name, Measure(base), {lib: Measure(r) for lib, r in libs.items() if r}, medians, drift)
    if len(base) < len(drawn):
        # A row that some jobs lack has an interval of its own jobs, which the legend's does not state.
        row.label += f" ({len(base)} jobs)"
    return row


def rows_of(kit, panel, drawn, others):
    """The panel's rows, and the names of those where stdx gave no speed in any job, which a count
    must still name."""
    names = [r[0] for r in drawn[0][panel.section][1] if panel.rows.search(r[0])]
    pairs = [(name, row_of(kit, panel, drawn, others, name)) for name in names]
    return [row for _, row in pairs if row], [GROUP.sub("", name) for name, row in pairs if not row]


def geometric_mean(values):
    return math.exp(sum(math.log(v) for v in values) / len(values))


def counted(measures):
    """Ahead, level, unclear and behind, with how many of the ahead and behind are inside the margin."""
    def side(word):
        count = sum(m.state == word for m in measures)
        small = sum(m.state == word and m.small for m in measures)
        return f"{word} on {count}" + (f" ({small} inside {MARGIN:.0%})" if small else "")
    unclear = sum(m.state == "unclear" for m in measures)
    level = sum(m.state == "level" for m in measures)
    return ", ".join([side("ahead"), f"level on {level}"] + ([f"unclear on {unclear}"] if unclear else []) + [side("behind")])


def claim(panel, rows, missing=()):
    """A panel's first line: stdx against Rust's crate, and the rows where stdx gave no answer."""
    unanswered = f"; stdx gives no answer on {len(missing)}: {', '.join(missing)}" if missing else ""
    if len(rows) == 1:
        m = rows[0].base
        within = f", inside {MARGIN:.0%}" if m.small else ""
        return f"against {BASE}: {m.state}{within}, at {ratio_text(m.median)}, {ratio_text(m.low)} to {ratio_text(m.high)}{unanswered}"
    patterns = len({r.pattern for r in rows})
    ratios = [r.base.median for r in rows]
    mean = f"; geometric mean over these rows {ratio_text(geometric_mean(ratios))}" if panel.mean else ""
    return (f"against {BASE}: {counted([r.base for r in rows])} of {len(rows)} rows, {patterns} patterns{mean}; "
            f"from {ratio_text(min(ratios))} to {ratio_text(max(ratios))}{unanswered}")


def versus(rows, marks=MARKS):
    """A panel's second line: stdx against each other library, by the rule of the first."""
    parts = []
    for lib in marks:
        measures = [r.libs[lib] for r in rows if lib in r.libs]
        parts.append(f"{lib}: " + (f"{counted(measures)} of {len(measures)}" if measures else "no pattern timed"))
    return "against " + "; ".join(parts)


def span_of(panels):
    """The axis's range, as logarithms: the rows' values with room past them, inside LIMITS."""
    values = [1.0]
    for rows in panels:
        for r in rows:
            values += [r.base.median, r.base.low, r.base.high] + r.base.ratios
    low = max(min(values) / PAD, LIMITS[0])
    high = min(max(values) * PAD, LIMITS[1])
    return math.log(min(low, 1 / PAD)), math.log(max(high, PAD))


def ticks_of(low, high):
    step = math.log(2)
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


FILL = {"ahead": "var(--stdx)", "level": "var(--tie)", "behind": "var(--lose)", "unclear": "var(--surface)"}


def bar(kit, row, cy, sx, height):
    a, b = sorted((sx(1), sx(row.base.median)))
    edge = ' stroke="var(--tie)" stroke-width="1.2"' if row.base.state == "unclear" else ""
    out = [f'<rect x="{a:.1f}" y="{cy - height / 2:.1f}" width="{max(b - a, 1.5):.1f}" height="{height:.1f}" rx="2" fill="{FILL[row.base.state]}"{edge}/>']
    # A bar past an edge of the axis stops there, with an arrow that points past it.
    sign = 1 if row.base.median > math.exp(sx.high) else -1 if row.base.median < math.exp(sx.low) else 0
    if sign:
        x = sx(row.base.median)
        out.append(f'<path d="M{x + 5 * sign:.1f},{cy:.1f} L{x:.1f},{cy - 4:.1f} L{x:.1f},{cy + 4:.1f} Z" fill="var(--ink)"/>')
    return out


def whisker(row, cy, sx):
    low, high = sx(row.base.low), sx(row.base.high)
    out = [f'<line x1="{low:.1f}" y1="{cy:.1f}" x2="{high:.1f}" y2="{cy:.1f}" stroke="var(--ink)" stroke-width="1.2"/>']
    for x in (low, high):
        out.append(f'<line x1="{x:.1f}" y1="{cy - 3:.1f}" x2="{x:.1f}" y2="{cy + 3:.1f}" stroke="var(--ink)" stroke-width="1.2"/>')
    for ratio in row.base.ratios:
        out.append(f'<circle cx="{sx(ratio):.1f}" cy="{cy:.1f}" r="1.6" fill="var(--ink)" fill-opacity="0.45"/>')
    for ratio in row.others.values():
        x = sx(ratio)
        out.append(f'<path d="M{x:.1f},{cy - 3.4:.1f} L{x + 3.4:.1f},{cy:.1f} L{x:.1f},{cy + 3.4:.1f} L{x - 3.4:.1f},{cy:.1f} Z" fill="none" stroke="var(--muted)" stroke-width="1"/>')
    return out


def interval_text(m):
    """A row's interval as the number column prints it: three decimals where two would print both
    ends alike or the row is inside the margin, 1/N where two decimals leave no digit, and whole
    numbers past 100."""
    if m.low < 0.095:
        return f"{ratio_text(m.low)}–{ratio_text(m.high)}"
    if m.median >= 100:
        return f"{m.low:.0f}–{m.high:.0f}"
    digits = 3 if f"{m.low:.2f}" == f"{m.high:.2f}" or inside(m.low, m.high) else 2
    return f"{m.low:.{digits}f}–{m.high:.{digits}f}"


def columns(kit, row, cy, marks):
    """The number column, then stdx over each other library."""
    column = kit.WIDTH - RIGHT + 10
    m = row.base
    out = [f'<rect x="{column}" y="{cy - 4:.1f}" width="8" height="8" rx="2" fill="{FILL[m.state]}"'
           + (' stroke="var(--tie)" stroke-width="1"' if m.state == "unclear" else "") + "/>",
           f'<text class="val" x="{column + 13}" y="{cy + 4:.1f}">{ratio_text(m.median)}</text>']
    out.append(f'<text class="tick" x="{column + 56}" y="{cy + 4:.1f}">{interval_text(m)}</text>')
    for k, lib in enumerate(marks):
        x = kit.WIDTH - 16 - COLUMN * (len(marks) - 1 - k)
        text = ratio_text(row.libs[lib].median) if lib in row.libs else "—"
        out.append(f'<text class="tick" x="{x}" y="{cy + 4:.1f}" text-anchor="end">{text}</text>')
    return out


def row_svg(kit, row, cy, sx, height, marks):
    out = [f'<text class="row" x="{LEFT - 8}" y="{cy + 4:.1f}" text-anchor="end">{kit.esc(row.label)}</text>']
    return out + bar(kit, row, cy, sx, height) + whisker(row, cy, sx) + columns(kit, row, cy, marks)


class Scale:
    """The axis: a position for each ratio, inside its range."""

    def __init__(self, kit, span):
        self.low, self.high = span
        self.left, self.unit = LEFT, (kit.WIDTH - LEFT - RIGHT) / (self.high - self.low)

    def __call__(self, value):
        return self.left + (min(max(math.log(value), self.low), self.high) - self.low) * self.unit


def header(kit, top, marks):
    column = kit.WIDTH - RIGHT + 10
    out = [f'<text class="tick" x="{column}" y="{top - 6}">stdx ÷ Rust, interval</text>']
    for k, lib in enumerate(marks):
        x = kit.WIDTH - 16 - COLUMN * (len(marks) - 1 - k)
        out.append(f'<text class="tick" x="{x}" y="{top - 6}" text-anchor="end">÷ {SHORT[lib]}</text>')
    return out


def panel_svg(kit, panel, rows, missing, y, sx):
    out = [f'<text class="panel" x="16" y="{y + 16}">{kit.esc(panel.title)}, in multiples of {BASE}\'s speed</text>']
    lines = wrap(claim(panel, rows, missing)) + wrap(versus(rows, panel.marks)) + (wrap(panel.note) if panel.note else [])
    out += [f'<text class="sub" x="16" y="{y + 33 + 16 * k}">{kit.esc(line)}</text>' for k, line in enumerate(lines)]
    row_height = panel.row or kit.ROW
    top = y + 44 + 16 * len(lines)
    height = row_height * len(rows)
    out += header(kit, top, panel.marks)
    for tick in ticks_of(sx.low, sx.high):
        out.append(f'<line x1="{sx(tick):.1f}" y1="{top}" x2="{sx(tick):.1f}" y2="{top + height}" stroke="var(--grid)"/>')
        out.append(f'<text class="tick" x="{sx(tick):.1f}" y="{top + height + 13}" text-anchor="middle">{tick_text(tick)}</text>')
    for k, row in enumerate(rows):
        out += row_svg(kit, row, top + k * row_height + row_height / 2, sx, row_height * 0.65, panel.marks)
    out.append(f'<line x1="{sx(1):.1f}" y1="{top - 4}" x2="{sx(1):.1f}" y2="{top + height}" stroke="var(--ink)" stroke-width="1.5"/>')
    return out, top + height + 34


def legend_svg(kit, y, jobs, others):
    k = rank(jobs)
    reach = "lowest to highest" if k == 1 else f"{k}{ordinal(k)} lowest to {k}{ordinal(k)} highest"
    out = [f'<text class="legend" x="16" y="{y}">A bar is the median of stdx over Rust regex:</text>']
    x = 300
    for state_name, words in (("ahead", "ahead"), ("level", "level"), ("unclear", "unclear"), ("behind", "behind")):
        edge = ' stroke="var(--tie)" stroke-width="1.2"' if state_name == "unclear" else ""
        out.append(f'<rect x="{x}" y="{y - 9}" width="12" height="10" rx="2" fill="{FILL[state_name]}"{edge}/><text class="legend" x="{x + 17}" y="{y}">{words}</text>')
        x += 74
    y += 18
    out.append(f'<circle cx="20" cy="{y - 4}" r="1.6" fill="var(--ink)" fill-opacity="0.45"/>'
               f'<text class="legend" x="28" y="{y}">a job</text>'
               f'<text class="legend" x="76" y="{y}">|—| the interval of the median: the jobs\' {reach} ratio, {coverage(jobs, k):.0%} confidence</text>')
    if others:
        y += 18
        out.append(f'<path d="M20,{y - 7.4} L23.4,{y - 4} L20,{y - 0.6} L16.6,{y - 4} Z" fill="none" stroke="var(--muted)" stroke-width="1"/>')
        words = "the median of another CPU model's jobs: " + ", ".join(f"{model} ({len(paths)})" for model, paths in others.items())
        for k, line in enumerate(wrap(words, SUB_CHARS)):
            y += 17 if k else 0
            out.append(f'<text class="legend" x="28" y="{y}">{kit.esc(line)}</text>')
    return out, y


def ordinal(k):
    return {1: "st", 2: "nd", 3: "rd"}.get(k if k < 20 else k % 10, "th")


def flipped(data):
    """The rows that fall on the other side of 1 on another CPU model."""
    out = []
    for _, rows, _ in data:
        for r in rows:
            for model, ratio in r.others.items():
                if (ratio < 1) != (r.base.median < 1):
                    out.append(f"{r.label} ({model}, {ratio_text(ratio)})")
    return out


def notes_svg(kit, y, data, drift, has_others):
    notes = [f"A row is ahead or behind where its interval lies above or below 1, and level where it holds 1 inside {MARGIN:.0%} of 1. "
             f"A row whose interval holds 1 and reaches past {MARGIN:.0%} is unclear: its jobs do not settle it. "
             f"A difference inside {MARGIN:.0%} is one this chart calls too small to matter, and the counts still name its direction.",
             f"The columns at the right are stdx's speed over another library's, the median of the jobs. "
             f"A library has no speed (—) on a pattern that it refuses, where its answer is not Go regexp's, and where it has no such call.",
             f"stdx timed again, last in each round, differed from stdx timed first by at most {drift:.1%} in any job of any row."]
    if has_others:
        moved = flipped(data)
        notes.append("On another CPU model, these rows fall on the other side of 1: " + ("; ".join(moved) if moved else "none") + ".")
    out = []
    for note in notes:
        for line in wrap(note):
            y += 17
            out.append(f'<text class="legend" x="16" y="{y}">{kit.esc(line)}</text>')
    return out, y


def models_of(kit, paths, jobs_min=JOBS_MIN):
    """The drawn model with its reports, and every other model with its reports, in the order listed.
    A drawn model of fewer than `jobs_min` jobs is refused."""
    models = [kit.field(p, "CPU model") for p in paths]
    assert "unknown" not in models, f"a report names no CPU model: {[p for p, m in zip(paths, models) if m == 'unknown']}"
    counts = Counter(models)
    drawn = next(m for m in models if counts[m] == max(counts.values()))
    assert counts[drawn] >= jobs_min, f"{counts[drawn]} jobs on {drawn}, fewer than {jobs_min}"
    others = {}
    for path, model in zip(paths, models):
        if model != drawn:
            others.setdefault(model, []).append(path)
    return drawn, [p for p, m in zip(paths, models) if m == drawn], others


def draw(kit, benchmark, paths):
    name, against, panels = PANELS[benchmark]
    model, drawn_paths, other_paths = models_of(kit, paths)
    drawn = [kit.tables(p) for p in drawn_paths]
    others = {m: [kit.tables(p) for p in ps] for m, ps in other_paths.items()}
    panels = [p for p in panels if all(p.section in r for r in drawn)]
    data = [(p,) + rows_of(kit, p, drawn, others) for p in panels]
    data = [(p, rows, missing) for p, rows, missing in data if rows]
    sx = Scale(kit, span_of([rows for _, rows, _ in data]))
    runs = ", ".join(kit.field(p, "Run URL").rsplit("/", 1)[-1] for p in drawn_paths)
    commits = ", ".join(sorted({kit.field(p, "Commit") for p in drawn_paths}))
    rule = f", the CPU model of {len(drawn_paths)} of {len(paths)} jobs, the most of any" if other_paths else ""
    subs = wrap(f"The median of {len(drawn_paths)} jobs on {model}{rule}: runs {runs}, at commit {commits}.", SUB_CHARS)
    subs += ["The bars share one logarithmic axis of stdx over Rust regex. The other libraries stand in the columns at the right."]
    legend, y = legend_svg(kit, 46 + 16 * len(subs) + 12, len(drawn_paths), other_paths)
    body, descs = [], []
    y += 24
    drift = 0.0
    for panel, rows, missing in data:
        part, y = panel_svg(kit, panel, rows, missing, y, sx)
        body += part
        drift = max([drift] + [r.drift for r in rows])
        descs.append(f"{panel.title}, in multiples of {BASE}'s speed: {claim(panel, rows, missing)}; {versus(rows, panel.marks)}")
    notes, y = notes_svg(kit, y - 14, data, drift, bool(other_paths))
    height = y + 16
    title = f"stdx's {name} against {against}, on {model}"
    head = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {kit.WIDTH} {height}" width="{kit.WIDTH}" height="{height}" role="img" aria-labelledby="t d">',
            f'<title id="t">{kit.esc(title)}</title>', f'<desc id="d">{kit.esc(". ".join(descs))}.</desc>', kit.STYLE,
            f'<rect width="{kit.WIDTH}" height="{height}" fill="var(--surface)"/>',
            f'<text class="title" x="16" y="26">{kit.esc(title)}</text>']
    head += [f'<text class="sub" x="16" y="{46 + 16 * k}">{kit.esc(sub)}</text>' for k, sub in enumerate(subs)]
    return "\n".join(head + legend + body + notes + ["</svg>", ""])
