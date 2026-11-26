"""Tests of tools/chart_change.py: python3 -I tools/chart_change_test.py."""
import os
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import chart_change  # noqa: E402


def test_one_job_threshold():
    # A row 5% faster is marked; one 4.9% faster is not.
    assert chart_change.Change([1.05], [1.0]).kind == "faster"
    assert chart_change.Change([1.049], [1.0]).kind is None
    # 105 against 100, whose quotient a float holds as a hair under 5%, counts as 5%.
    assert chart_change.Change([1.05 * 3], [3.0]).kind == "faster"
    assert chart_change.Change([0.9], [1.0]).kind == "slower"
    assert chart_change.Change([1.0 / 1.04], [1.0]).kind is None


def test_one_job_noise():
    # With one job, a change must pass the cells' noise as well as the threshold.
    assert chart_change.Change([1.08], [1.0], noise=0.1).kind is None
    assert chart_change.Change([1.12], [1.0], noise=0.1).kind == "faster"
    assert chart_change.Change([0.88], [1.0], noise=0.1).kind == "slower"


def test_many_jobs_interval():
    # Eighteen jobs, each 10% faster: the interval lies past 1.
    assert chart_change.Change([1.1] * 18, [1.0] * 18).kind == "faster"
    # A median 10% faster whose jobs spread across 1 is not marked.
    now = [1.1] * 10 + [0.9] * 8
    assert chart_change.Change(now, [1.0] * 18).kind is None
    # Slower in every job.
    assert chart_change.Change([0.8] * 18, [1.0] * 18).kind == "slower"
    # Past 1 in every job, but by less than the threshold.
    assert chart_change.Change([1.03] * 18, [1.0] * 18).kind is None


def test_pairs():
    # A job that either release lacks is left out of the pairs.
    change = chart_change.Change([1.2, None, 1.2], [1.0, 1.0, None])
    assert change.changes == [1.2], change.changes
    assert chart_change.Change([None], [1.0]).kind is None
    assert chart_change.Change([], []).share is None
    # The previous ratio is the median of the paired jobs'.
    assert chart_change.Change([2.0, 2.0, 2.0], [1.0, 3.0, 2.0]).was == 2.0


def test_mark():
    assert chart_change.Change([1.0], [1.0]).mark() == ""
    assert chart_change.Change([1.2], [1.0]).mark() == ' <tspan class="better">▲20%</tspan>'
    assert chart_change.Change([0.8], [1.0]).mark() == ' <tspan class="worse">▼20%</tspan>'


def test_line():
    assert chart_change.Change([None], [None]).line(lambda v: v, 0, 1) == ""
    line = chart_change.Change([1.2], [2.0]).line(lambda v: v * 100, 50, 5)
    assert 'x1="200.0"' in line and 'class="was"' in line, line


def test_merged():
    members = [chart_change.Change([1.2], [1.0]), chart_change.Change([1.1], [1.0]), chart_change.Change([0.9], [1.0])]
    summary = chart_change.merged(members)
    assert abs(summary.share - 0.1) < 1e-9 and summary.kind == "faster", summary.share
    assert chart_change.merged([None, chart_change.Change([None], [1.0])]) is None


def test_counts():
    rows = [("p", "a", chart_change.Change([1.2], [1.0])), ("p", "b", chart_change.Change([0.8], [1.0])),
            ("p", "c", chart_change.Change([1.0], [1.0])), ("p", "d", None)]
    assert chart_change.counts(rows) == (1, 1, 3)


if __name__ == "__main__":
    tests = [value for name, value in sorted(globals().items()) if name.startswith("test_")]
    for test in tests:
        test()
    print(f"chart_change_test.py: {len(tests)} tests passed")
