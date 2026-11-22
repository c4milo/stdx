"""The tests of the regex chart's rules: `python3 tools/charts_wide_test.py`.

Each test holds one rule that tools/charts_wide.py states to the numbers the rule must give."""
import math
import os
import sys
import tempfile

# The tool runs from a checkout, which keeps no compiled copy of the files it imports.
sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from charts_wide import (CONFIDENCE, HELD_COMPILE, HELD_SEARCH, MARGIN, PANELS, Measure, Panel, Row, claim,  # noqa: E402
                         counted, coverage, flipped, interval, interval_text, models_of, pattern, rank, ratio_text, state,
                         tick_text, ticks_of)


def test_interval():
    assert rank(5) == 1 and abs(coverage(5, 1) - 0.9375) < 1e-9, "five jobs reach 94% with the lowest and highest"
    assert rank(10) == 2 and abs(coverage(10, 2) - 0.978515625) < 1e-9, "ten jobs drop one job at each end"
    assert rank(20) == 6 and coverage(20, 6) >= CONFIDENCE > coverage(20, 7), "twenty jobs drop five at each end"
    assert interval([0.9, 1.4, 1.0, 1.1, 1.2, 1.3, 1.5, 1.6, 2.0, 0.1]) == (0.9, 1.6), "the 2nd lowest to the 2nd highest"
    assert interval([3.0, 1.0, 2.0, 5.0, 4.0]) == (1.0, 5.0), "five jobs: the lowest to the highest"


def test_state():
    # Every job behind by 3.6% to 4.4%: behind, and inside the margin.
    m = Measure([0.956, 0.957, 0.958, 0.96, 0.96, 0.961, 0.962, 0.963, 0.963, 0.964])
    assert (m.state, m.small) == ("behind", True), (m.state, m.small)
    # Two groups of jobs, both under 1: behind, not level.
    m = Measure([0.73, 0.94, 0.73, 0.94, 0.72, 0.93, 0.95, 0.92, 0.71, 0.93])
    assert (m.state, m.small) == ("behind", False), (m.state, m.small)
    assert Measure([0.99, 1.0, 1.01, 1.02, 0.98]).state == "level"
    assert Measure([0.9, 0.97, 1.0, 1.03, 1.08]).state == "unclear"
    assert Measure([1.01, 1.02, 1.03, 1.02, 1.04]).small and Measure([1.01, 1.02, 1.03, 1.02, 1.04]).state == "ahead"
    assert Measure([1.06, 1.2, 1.3, 1.2, 1.1]).state == "ahead" and not Measure([1.06, 1.2, 1.3, 1.2, 1.1]).small
    assert state(1.0, 1.0) == "level" and state(1 / (1 + MARGIN), 1 + MARGIN) == "level"
    assert state(0.95, 1.0) == "unclear", "an interval that reaches past the margin is unclear"


def test_counts():
    rows = [Measure([0.96] * 5), Measure([0.97, 0.96, 0.955, 0.96, 0.97]), Measure([2.0] * 5), Measure([0.99, 1.0, 1.01, 1.0, 1.0])]
    assert counted(rows) == "ahead on 1, level on 1, behind on 2 (2 inside 5%)", counted(rows)
    assert pattern("a word, second text") == "a word" and pattern("a word") == "a word"


class Kit:
    """A stand-in for charts.py: the CPU model each path names."""

    def __init__(self, models):
        self.models = models

    def field(self, path, key):
        assert key == "CPU model"
        return self.models[path]


def refused(call):
    try:
        call()
    except AssertionError:
        return True
    return False


def test_models():
    kit = Kit({"a": "X", "b": "Y", "c": "Y", "d": "X", "e": "Z"})
    assert models_of(kit, ["a", "b", "c", "d", "e"], 1) == ("X", ["a", "d"], {"Y": ["b", "c"], "Z": ["e"]}), "a tie goes to the first"
    assert models_of(kit, ["b", "a", "c", "d"], 1)[0] == "Y"
    assert models_of(kit, ["e", "a", "b", "c"], 1)[0] == "Y", "the most jobs win"
    assert refused(lambda: models_of(Kit({"a": "unknown"}), ["a"], 1)), "a report with no CPU model is refused"
    five = Kit({p: "X" for p in "abcde"} | {"f": "Y"})
    assert models_of(five, list("abcdef"))[1] == list("abcde"), "five jobs of one model are drawn"
    assert refused(lambda: models_of(five, list("abcd") + ["f"])), "four jobs of one model are refused"


def test_flipped():
    behind = Row("other: a word", Measure([0.9] * 5), {}, {"Y": 1.1, "Z": 0.8}, 0.0)
    ahead = Row("class: a number", Measure([1.2] * 5), {}, {"Y": 1.3}, 0.0)
    assert flipped([(None, [behind, ahead], [])]) == ["a word (Y, 1.10)"], flipped([(None, [behind, ahead], [])])


def test_unanswered():
    """A row where stdx gave no answer stays in its panel's count, by name."""
    panel = Panel("Search", r"", "searches")
    rows = [Row("other: a word", Measure([0.9] * 5), {}, {}, 0.0), Row("class: a number", Measure([1.2] * 5), {}, {}, 0.0)]
    line = claim(panel, rows, ["a date"])
    assert line.endswith("; stdx gives no answer on 1: a date"), line
    assert "no answer" not in claim(panel, rows)


def test_ticks():
    assert [round(t, 3) for t in ticks_of(math.log(0.3), math.log(5))] == [0.5, 1, 2, 4]
    assert tick_text(0.25) == "1/4" and ratio_text(0.05) == "1/20" and ratio_text(150) == "150"
    assert ratio_text(0.9963) == "0.996" and ratio_text(0.94) == "0.94" and ratio_text(1.2) == "1.20"


def test_pipe():
    """A `\\|` in a row's label stays in the label, and every column keeps its place."""
    import charts
    with tempfile.NamedTemporaryFile("w", suffix=".md", delete=False, encoding="utf-8") as report:
        report.write("## Search\n\n| Pattern | stdx | Rust regex |\n|---|---|---|\n| a\\|b | 2.0 | 1.0 |\n")
    try:
        head, body = charts.tables(report.name)["Search"]
    finally:
        os.unlink(report.name)
    assert head == ["Pattern", "stdx", "Rust regex"] and body == [["a|b", "2.0", "1.0"]], body


def test_interval_text():
    assert interval_text(Measure([0.00006, 0.00007, 0.00008, 0.00007, 0.00007])) == "1/16667–1/12500"
    assert interval_text(Measure([0.84, 0.85, 0.86, 0.85, 0.85])) == "0.84–0.86"
    assert interval_text(Measure([0.994, 0.995, 0.996, 0.995, 0.995])) == "0.994–0.996"
    assert interval_text(Measure([150.0, 160.0, 170.0, 160.0, 160.0])) == "150–170"


def test_charts():
    """The held-out set draws on a chart of its own, with Go's column alone, and the tuned chart
    holds none of its rows."""
    held = {HELD_SEARCH, HELD_COMPILE}
    assert not any(panel.section in held for panel in PANELS["regex"][2])
    assert {panel.section for panel in PANELS["regex-rebar"][2]} == held
    assert all(panel.marks == ["Go regexp"] for panel in PANELS["regex-rebar"][2])


def main():
    tests = (test_interval, test_state, test_counts, test_models, test_flipped, test_unanswered, test_charts, test_ticks,
             test_pipe, test_interval_text)
    for test in tests:
        test()
    print(f"charts_wide_test.py: {len(tests)} tests passed")


if __name__ == "__main__":
    main()
