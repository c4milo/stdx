"""What changed in each chart since the previous release (decision 85 as amended on 2026-11-26).

Each release keeps its jobs' reports with its GitHub release. The next release draws each chart
from its own jobs, draws it again from the previous release's reports, and compares the two, as
connect-zig compares its charts:

- A row's change is its value at the release over its value at the previous release: stdx's
  ratio over the panel's baseline, or an encoder level's speed in multiples of the reference's.
- A row is faster where its change is THRESHOLD or more above 1, and slower where it is that much
  below, and where the change passes the noise of both: the spread of each row's cells or jobs,
  combined.
- Two runs on different CPU models do not compare. A chart whose CPU model differs from the
  previous release's marks nothing, and says so.
- A faster row's label ends with ▲ and the change, a slower row's with ▼, and a dashed line marks
  the row's value at the previous release. A change of MULTIPLE times or more, either way, is a
  multiple, as ▲27,000×, and a smaller one a percentage, as ▲20%.

`python3 tools/chart_change_test.py` runs the tests of these rules.
"""
import math

# The least change of a row, as a share of its value at the previous release, that a chart marks.
# The regex chart calls a difference under 5% too small to matter, and every chart takes its rule.
THRESHOLD = 0.05
# How a chart compares with the previous release: the two drew one CPU model, they drew two, or
# the previous release left no report of the chart.
COMPARED, OTHER_MODEL, NO_REPORTS = "compared", "other model", "no reports"
# The least factor, faster or slower, that a change states as a multiple and not as a percentage.
# A search that reads only a text's end can run thousands of times as fast as one that reads all of
# it, and 2,638,874% says that worse than 26,390×.
MULTIPLE = 2.0
# The least multiple stated with no decimal.
WHOLE_MULTIPLE = 10.0
# The marks' colors, which each chart adds to its style sheet.
STYLE = """.better { fill: #1a7f37; } .worse { fill: #cf222e; }
@media (prefers-color-scheme: dark) { .better { fill: #3fb950; } .worse { fill: #f85149; } }
.was { stroke: var(--ink2); stroke-width: 1.5; stroke-dasharray: 2 2; }"""


class Change:
    """A row's change since the previous release: its value now (`now`) and then (`was`), the
    change as a share of `was` (`share`, above zero when stdx is faster), and whether the row is
    `faster`, `slower` or neither (None)."""

    def __init__(self, now, was, noise=0.0):
        self.now, self.was, self.noise = now, was, noise
        self.share = now / was - 1 if now and was else None
        self.kind = self.judge()

    def judge(self):
        if self.share is None:
            return None
        # Rounded, so that 105 against 100, whose quotient a float holds as a hair under 5%, is 5%.
        moved = round(abs(self.share), 9)
        if moved < THRESHOLD or moved <= self.noise:
            return None
        return "faster" if self.share > 0 else "slower"

    def amount(self):
        """The change as text: a multiple, faster or slower, from MULTIPLE times, and a
        percentage below it."""
        factor = max(self.now / self.was, self.was / self.now)
        if factor < MULTIPLE:
            return f"{abs(self.share) * 100:.0f}%"
        return f"{factor:,.0f}×" if factor >= WHOLE_MULTIPLE else f"{factor:.1f}×"

    def mark(self):
        """The text after a row's label: ▲ or ▼ and the change, or nothing."""
        if self.kind is None:
            return ""
        css, arrow = ("better", "▲") if self.kind == "faster" else ("worse", "▼")
        return f' <tspan class="{css}">{arrow}{self.amount()}</tspan>'

    def line(self, x_of, cy, half):
        """A dashed line across a row at its value at the previous release, where `x_of` places a
        value, or nothing when the row has none."""
        if self.was is None:
            return ""
        x = x_of(self.was)
        return f'<line class="was" x1="{x:.1f}" y1="{cy - half - 2:.1f}" x2="{x:.1f}" y2="{cy + half + 2:.1f}"/>'


def noise(*spreads):
    """Spreads combined, as one spread."""
    return math.hypot(*spreads)


def note(previous_tag, comparison):
    """The chart's line that says what its marks compare, or None."""
    if comparison == COMPARED:
        return (f"▲ marks a row {THRESHOLD:.0%} or more faster than at {previous_tag}, past the noise of both, "
                f"▼ one that much slower, and a dashed line its value at {previous_tag}.")
    if comparison == OTHER_MODEL:
        return f"{previous_tag} ran this chart on another CPU model, so it marks no change since {previous_tag}."
    if comparison == NO_REPORTS:
        return f"{previous_tag} left no reports of this chart, so it marks no change since {previous_tag}."
    return None


def comparison_of(models_now, models_was):
    """How a chart compares: COMPARED where both releases drew the same one CPU model."""
    if not models_was:
        return NO_REPORTS
    return COMPARED if models_now == models_was else OTHER_MODEL


def counts(rows):
    """(faster, slower, judged) over `rows` of (panel, row, Change)."""
    judged = [c for _, _, c in rows if c is not None and c.share is not None]
    return sum(c.kind == "faster" for c in judged), sum(c.kind == "slower" for c in judged), len(judged)
