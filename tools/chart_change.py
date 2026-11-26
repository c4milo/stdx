"""What changed in each chart since the previous release (decision 85 as amended on 2026-11-26).

Each job of a release measures the previous release first and then the release, on one runner
(the bench workflow's `base`). A chart draws the release's jobs, and compares each of stdx's bars
with the same bar of the previous release's report of the same job:

- A job's change is the bar's ratio at the release over its ratio at the previous release. A
  ratio is stdx's speed over a baseline's speed in the same report, so a runner that slows in the
  middle of a job slows both.
- A row's change is the median of its jobs' changes.
- A row is faster where its change is THRESHOLD or more above 1, and slower where it is that much
  below. With fewer than JOBS_MIN jobs the change must also pass the noise, the spread of the four
  cells combined. With more, the change's interval of the median, by the regex chart's sign test,
  must lie wholly on that side of 1.
- A faster row's label ends with ▲ and the change, a slower row's with ▼, and a dashed line marks
  the bar's ratio at the previous release.

`python3 tools/chart_change_test.py` runs the tests of these rules.
"""
import math
import statistics

# The least change of a row, as a share of its ratio at the previous release, that a chart marks.
# The regex chart calls a difference under 5% too small to matter, and every chart takes its rule.
THRESHOLD = 0.05
# The fewest jobs of a row that the sign test judges, as the regex chart draws no fewer.
JOBS_MIN = 5
# The marks' colors, which each chart adds to its style sheet.
STYLE = """.better { fill: #1a7f37; } .worse { fill: #cf222e; }
@media (prefers-color-scheme: dark) { .better { fill: #3fb950; } .worse { fill: #f85149; } }
.was { stroke: var(--ink2); stroke-width: 1.5; stroke-dasharray: 2 2; }"""


def sign_interval(values):
    """The interval of the median of `values` that the regex chart draws for its rows."""
    import charts_wide
    return charts_wide.interval(values)


class Change:
    """A row's change since the previous release: its jobs' changes, their median as a share of
    the previous ratio (`share`, above zero when stdx is faster), the previous ratio (`was`), and
    whether the row is `faster`, `slower` or neither (None)."""

    def __init__(self, now, was, noise=0.0):
        pairs = [(n, w) for n, w in zip(now, was) if n and w]
        self.changes = [n / w for n, w in pairs]
        self.was = statistics.median(w for _, w in pairs) if pairs else None
        self.share = statistics.median(self.changes) - 1 if self.changes else None
        self.noise = noise
        self.kind = self.judge()

    def judge(self):
        if self.share is None or round(abs(self.share), 9) < THRESHOLD:
            return None
        if len(self.changes) >= JOBS_MIN:
            low, high = sign_interval(self.changes)
            past = low > 1 if self.share > 0 else high < 1
        else:
            past = abs(self.share) > self.noise
        if not past:
            return None
        return "faster" if self.share > 0 else "slower"

    def mark(self):
        """The text after a row's label: ▲ or ▼ and the change, or nothing."""
        if self.kind is None:
            return ""
        css, arrow = ("better", "▲") if self.kind == "faster" else ("worse", "▼")
        return f' <tspan class="{css}">{arrow}{abs(self.share) * 100:.0f}%</tspan>'

    def line(self, x_of, cy, half):
        """A dashed line across a row at its ratio at the previous release, where `x_of` places a
        ratio, or nothing when the row has none."""
        if self.was is None:
            return ""
        x = x_of(self.was)
        return f'<line class="was" x1="{x:.1f}" y1="{cy - half - 2:.1f}" x2="{x:.1f}" y2="{cy + half + 2:.1f}"/>'


def merged(changes):
    """One change for a summary row from its members' changes: the median of their shares, judged
    as one job against the median of their noise."""
    known = [c for c in changes if c is not None and c.share is not None]
    if not known:
        return None
    out = Change([], [])
    out.share = statistics.median(c.share for c in known)
    out.was = statistics.median(c.was for c in known)
    out.noise = statistics.median(c.noise for c in known)
    out.changes = [1 + out.share]
    out.kind = out.judge()
    return out


def noise(*spreads):
    """The cells' spreads combined, as one spread."""
    return math.hypot(*spreads)


def note(previous_tag):
    """The chart's line that explains the marks."""
    return (f"▲ marks a row {THRESHOLD:.0%} or more faster than at {previous_tag}, measured in the same jobs, "
            f"▼ one that much slower, and a dashed line its ratio at {previous_tag}.")


def counts(rows):
    """(faster, slower, judged) over `rows` of (panel, row, Change)."""
    judged = [c for _, _, c in rows if c is not None and c.share is not None]
    return sum(c.kind == "faster" for c in judged), sum(c.kind == "slower" for c in judged), len(judged)
