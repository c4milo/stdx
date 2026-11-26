"""Tests of tools/chart_change.py: python3 -I tools/chart_change_test.py."""
import os
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import chart_change  # noqa: E402


def test_threshold():
    # A row 5% faster is marked; one 4.9% faster is not.
    assert chart_change.Change(1.05, 1.0).kind == "faster"
    assert chart_change.Change(1.049, 1.0).kind is None
    # 105 against 100, whose quotient a float holds as a hair under 5%, counts as 5%.
    assert chart_change.Change(1.05 * 3, 3.0).kind == "faster"
    assert chart_change.Change(0.9, 1.0).kind == "slower"
    assert chart_change.Change(1.0 / 1.04, 1.0).kind is None


def test_noise():
    # A change must pass the noise of both releases as well as the threshold.
    assert chart_change.Change(1.08, 1.0, noise=0.1).kind is None
    assert chart_change.Change(1.12, 1.0, noise=0.1).kind == "faster"
    assert chart_change.Change(0.88, 1.0, noise=0.1).kind == "slower"
    assert chart_change.Change(1.1, 1.0, noise=0.1).kind is None
    assert abs(chart_change.noise(0.03, 0.04) - 0.05) < 1e-12


def test_missing():
    assert chart_change.Change(None, 1.0).kind is None
    assert chart_change.Change(1.0, None).share is None
    assert chart_change.Change(1.0, 0.0).share is None


def test_mark():
    assert chart_change.Change(1.0, 1.0).mark() == ""
    assert chart_change.Change(1.2, 1.0).mark() == ' <tspan class="better">▲20%</tspan>'
    assert chart_change.Change(0.8, 1.0).mark() == ' <tspan class="worse">▼20%</tspan>'


def test_line():
    assert chart_change.Change(1.0, None).line(lambda v: v, 0, 1) == ""
    line = chart_change.Change(1.2, 2.0).line(lambda v: v * 100, 50, 5)
    assert 'x1="200.0"' in line and 'class="was"' in line, line


def test_comparison():
    assert chart_change.comparison_of({"Neoverse-N2"}, {"Neoverse-N2"}) == chart_change.COMPARED
    assert chart_change.comparison_of({"AMD EPYC 7763"}, {"AMD EPYC 9V74"}) == chart_change.OTHER_MODEL
    assert chart_change.comparison_of({"Neoverse-N2"}, set()) == chart_change.NO_REPORTS
    assert "▲ marks a row 5% or more faster than at v0.3.0" in chart_change.note("v0.3.0", chart_change.COMPARED)
    assert "another CPU model" in chart_change.note("v0.3.0", chart_change.OTHER_MODEL)
    assert "no reports" in chart_change.note("v0.3.0", chart_change.NO_REPORTS)
    assert chart_change.note("v0.3.0", None) is None


def test_counts():
    rows = [("p", "a", chart_change.Change(1.2, 1.0)), ("p", "b", chart_change.Change(0.8, 1.0)),
            ("p", "c", chart_change.Change(1.0, 1.0)), ("p", "d", None)]
    assert chart_change.counts(rows) == (1, 1, 3)


if __name__ == "__main__":
    tests = [value for name, value in sorted(globals().items()) if name.startswith("test_")]
    for test in tests:
        test()
    print(f"chart_change_test.py: {len(tests)} tests passed")
