"""Tests of tools/charts_release.py and tools/charts_release.sh: python3 -I tools/charts_release_test.py.

The reports are the committed runs of bench/results/, each standing in for a release's job and,
where a test changes a cell, for the previous release's job.
"""
import os
import re
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
TOOLS = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, TOOLS)
import charts_release  # noqa: E402

ROOT = os.path.dirname(TOOLS)
RESULTS = os.path.join(ROOT, "bench", "results")
ORDINALS = ["", "second-", "third-", "fourth-", "fifth-", "sixth-", "seventh-", "eighth-", "ninth-", "tenth-",
            "eleventh-", "twelfth-", "thirteenth-", "fourteenth-", "fifteenth-", "sixteenth-", "seventeenth-",
            "eighteenth-"]
SCRIPT = os.path.join(TOOLS, "charts_release.sh")


def artifacts(folder, previous=True):
    """A run's artifacts for every job the committed manifest asks for."""
    runners = {"aarch64": "ubuntu-26.04-arm", "x86_64": "ubuntu-26.04"}
    for arch, runner in runners.items():
        for benchmark in ("deflate", "zstd", "brotli", "json", "checksum", "base64"):
            add(folder, f"bench-{benchmark}-{runner}-1", f"2026-11-20-{benchmark}-{arch}.md", previous)
        for job, ordinal in enumerate(ORDINALS, 1):
            add(folder, f"bench-regex-{runner}-{job}", f"2026-11-24-regex-places-{ordinal}{arch}.md", previous)


def add(folder, name, report, previous):
    os.makedirs(os.path.join(folder, name))
    shutil.copy(os.path.join(RESULTS, report), os.path.join(folder, name, "bench-report.md"))
    if previous:
        shutil.copy(os.path.join(RESULTS, report), os.path.join(folder, name, "base-report.md"))


def scale(path, section, row, column, factor):
    """Multiplies one cell of a report by `factor`."""
    lines, current, head = open(path).read().split("\n"), None, None
    for i, line in enumerate(lines):
        if line.startswith("## "):
            current, head = line[3:].strip(), None
            continue
        if current != section or not line.startswith("|"):
            continue
        cells = [c.strip() for c in re.split(r"(?<!\\)\|", line.strip().strip("|"))]
        if head is None:
            head = cells
        elif cells[0] == row:
            k = head.index(column)
            number = re.match(r"([\d.]+)(.*)", cells[k])
            cells[k] = f"{float(number.group(1)) * factor:.3f}{number.group(2)}"
            lines[i] = "| " + " | ".join(cells) + " |"
    open(path, "w").write("\n".join(lines))


def scale_level(path, section, level, column, factor):
    """Multiplies a column of a report's rows at one level by `factor`."""
    lines, current, head = open(path).read().split("\n"), None, None
    for i, line in enumerate(lines):
        if line.startswith("## "):
            current, head = line[3:].strip(), None
            continue
        if current != section or not line.startswith("|") or set(line) <= set("|-: "):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if head is None:
            head = cells
        elif cells[head.index("Level")] == level:
            k = head.index(column)
            number = re.match(r"([\d.]+)(.*)", cells[k])
            cells[k] = f"{float(number.group(1)) * factor:.3f}{number.group(2)}"
            lines[i] = "| " + " | ".join(cells) + " |"
    open(path, "w").write("\n".join(lines))


def test_jobs_in():
    with tempfile.TemporaryDirectory() as folder:
        add(folder, "bench-deflate-ubuntu-26.04-arm-1", "2026-11-20-deflate-aarch64.md", True)
        add(folder, "bench-regex-ubuntu-26.04-2", "2026-11-24-regex-places-x86_64.md", False)
        add(folder, "bench-regex-other-runner-1", "2026-11-24-regex-places-x86_64.md", False)
        os.makedirs(os.path.join(folder, "bench-zstd-ubuntu-26.04-1"))
        found = charts_release.jobs_in(folder)
        assert set(found) == {("deflate", "aarch64"), ("regex", "x86_64")}, found
        job, report, previous = found[("deflate", "aarch64")][0]
        assert job == 1 and report.endswith("bench-report.md") and previous.endswith("base-report.md")
        assert found[("regex", "x86_64")][0][2] is None
        try:
            charts_release.chart_jobs(found, "x86_64", "regex", 2)
        except ValueError as error:
            assert "[1]" in str(error), error
        else:
            raise AssertionError("no error for a missing job")


def test_release():
    with tempfile.TemporaryDirectory() as folder:
        artifacts(os.path.join(folder, "in"))
        previous = os.path.join(folder, "in", "bench-deflate-ubuntu-26.04-arm-1", "base-report.md")
        scale(previous, "Decoding, gzip at zlib level 6", "canterbury/alice29.txt", "stdx, MB/s", 1 / 1.2)
        scale(previous, "Decoding, gzip at zlib level 6", "canterbury/kennedy.xls", "stdx, MB/s", 1.2)
        # stdx's gzip level 6 encoded 30% slower at the previous release.
        scale_level(previous, "Encoding speed, gzip", "6", "stdx, MB/s", 1 / 1.3)
        # Each of the regex jobs on the N2 ran `a word` 25% slower at the previous release.
        for job in range(1, len(ORDINALS) + 1):
            regex = os.path.join(folder, "in", f"bench-regex-ubuntu-26.04-arm-{job}", "base-report.md")
            scale(regex, "Search in 1 MiB, MB/s", "literal: a word", "stdx", 1 / 1.25)
        out = os.path.join(folder, "out")
        charts_release.main([os.path.join(folder, "in"), out, "v0.4.0", "v0.3.0"])
        svgs = sorted(name for name in os.listdir(out) if name.endswith(".svg"))
        assert len(svgs) == 18 and "regex-rebar-others-x86_64.svg" in svgs, svgs
        assert len(os.listdir(os.path.join(out, "reports"))) == 2 * 48
        chart = open(os.path.join(out, "deflate-aarch64.svg")).read()
        marks = chart.split("</style>")[1]
        assert marks.count('class="better"') == 2 and marks.count('class="worse"') == 1, "two ▲ and one ▼"
        assert "measured in the same jobs" in chart
        assert '>6 <tspan class="better">▲30%</tspan></text>' in chart, "the encoder's level marks its change"
        assert "| stdx level 6 | ▲ 30% faster |" in open(os.path.join(out, "notes.md")).read()
        regex = open(os.path.join(out, "regex-aarch64.svg")).read()
        assert 'a word <tspan class="better">▲25%</tspan>' in regex, "the regex chart marks its row"
        notes = open(os.path.join(out, "notes.md")).read()
        assert notes.startswith(charts_release.HEADING + "\n")
        assert "| search for a literal: every match in 1 MiB | a word | ▲ 25% faster |" in notes, notes
        assert "| canterbury/alice29.txt | ▲ 20% faster |" in notes and "| canterbury/kennedy.xls | ▼ 17% slower |" in notes
        assert "| stdx's DEFLATE against its baselines, on Neoverse-N2 | 2 | 1 | 42 |" in notes, notes
        page = open(os.path.join(out, "benchmarks.md")).read()
        assert page.startswith("# stdx's benchmarks at v0.4.0") and "![stdx's DEFLATE" in page
        assert "Since v0.3.0: 2 rows faster and 1 slower by 5% or more, of 42" in page, page


def test_first_release():
    with tempfile.TemporaryDirectory() as folder:
        artifacts(os.path.join(folder, "in"), previous=False)
        out = os.path.join(folder, "out")
        charts_release.main([os.path.join(folder, "in"), out, "v0.1.0", ""])
        notes = open(os.path.join(out, "notes.md")).read()
        assert "No release came before v0.1.0" in notes, notes
        assert 'class="better"' not in open(os.path.join(out, "deflate-aarch64.svg")).read().split("</style>")[1]


def shell(command, cwd, env=None):
    """Runs `command` in sh with charts_release.sh's functions defined."""
    script = f'. "{SCRIPT}"; {command}'
    return subprocess.run(["sh", "-c", script], cwd=cwd, env=env, check=True, capture_output=True, text=True)


def git(cwd, *arguments):
    return subprocess.run(["git", *arguments], cwd=cwd, check=True, capture_output=True, text=True).stdout


def test_branch():
    with tempfile.TemporaryDirectory() as folder:
        remote, work, out = (os.path.join(folder, name) for name in ("remote.git", "work", "out"))
        git(folder, "init", "-q", "--bare", remote)
        git(folder, "init", "-q", work)
        git(work, "remote", "add", "origin", remote)
        os.makedirs(os.path.join(out, "reports"))
        for name in ("a.svg", "benchmarks.md", "notes.md", "reports/r.md"):
            open(os.path.join(out, name), "w").write(name)
        shell(f'charts_branch "{out}" v9.9.9', work)
        files = git(remote, "ls-tree", "-r", "--name-only", "charts").split()
        assert files == ["a.svg", "benchmarks.md", "reports/r.md"], files
        assert git(remote, "log", "-1", "--format=%s", "charts").strip() == "chore: draw the charts of v9.9.9"
        # The next release's commit replaces the branch's.
        os.remove(os.path.join(out, "a.svg"))
        shell(f'charts_branch "{out}" v9.9.10', work)
        assert git(remote, "rev-list", "--count", "charts").strip() == "1"
        assert "a.svg" not in git(remote, "ls-tree", "-r", "--name-only", "charts")


STUB = """#!/bin/sh
# A stand-in for gh: a release's notes are the file body in this folder.
here="$(dirname "$0")"
echo "$*" >>"$here/calls"
case "$1 $2" in
    "release view") [ -f "$here/body" ] || exit 1; [ "${4:-}" = --json ] && cat "$here/body"; exit 0 ;;
    "release edit") cp "$5" "$here/body" ;;
    "release create") shift 2; while [ "$#" -gt 0 ]; do [ "$1" = --notes-file ] && cp "$2" "$here/body"; shift; done ;;
esac
"""


def stub(folder):
    bin_folder = os.path.join(folder, "bin")
    os.makedirs(bin_folder)
    path = os.path.join(bin_folder, "gh")
    open(path, "w").write(STUB)
    os.chmod(path, 0o755)
    return dict(os.environ, PATH=f"{bin_folder}:{os.environ['PATH']}"), bin_folder


def test_notes():
    with tempfile.TemporaryDirectory() as folder:
        env, bin_folder = stub(folder)
        open(os.path.join(bin_folder, "body"), "w").write("# stdx 9.9.9\n\nWritten by hand.\n\n## Benchmarks\n\nold\n")
        notes = os.path.join(folder, "notes.md")
        open(notes, "w").write("## Benchmarks\n\nnew\n")
        shell(f'release_notes "{notes}" v9.9.9', folder, env)
        body = open(os.path.join(bin_folder, "body")).read()
        assert body == "# stdx 9.9.9\n\nWritten by hand.\n\n## Benchmarks\n\nnew\n", body
        # Notes written on GitHub's page end each line with a carriage return.
        open(os.path.join(bin_folder, "body"), "w", newline="").write("# stdx 9.9.9\r\n\r\n## Benchmarks\r\n\r\nold\r\n")
        shell(f'release_notes "{notes}" v9.9.9', folder, env)
        body = open(os.path.join(bin_folder, "body"), newline="").read()
        assert body == "# stdx 9.9.9\r\n\r\n## Benchmarks\n\nnew\n", repr(body)


def test_open():
    with tempfile.TemporaryDirectory() as folder:
        env, bin_folder = stub(folder)
        os.makedirs(os.path.join(folder, "docs", "releases"))
        open(os.path.join(folder, "docs", "releases", "v9.9.9.md"), "w").write("Notes of 9.9.9.\n")
        shell("release_open v9.9.9", folder, env)
        calls = open(os.path.join(bin_folder, "calls")).read()
        assert "release create v9.9.9 --verify-tag --title stdx 9.9.9 --notes-file docs/releases/v9.9.9.md" in calls, calls
        assert open(os.path.join(bin_folder, "body")).read() == "Notes of 9.9.9.\n"
        # A release that exists keeps its notes.
        shell("release_open v9.9.9", folder, env)
        assert open(os.path.join(bin_folder, "calls")).read().count("release create") == 1
        # With no file of notes, GitHub writes them.
        os.remove(os.path.join(bin_folder, "body"))
        shell("release_open v9.9.10", os.path.join(folder, "docs"), env)
        assert "release create v9.9.10 --verify-tag --title stdx 9.9.10 --generate-notes" in open(os.path.join(bin_folder, "calls")).read()


if __name__ == "__main__":
    tests = [value for name, value in sorted(globals().items()) if name.startswith("test_")]
    for test in tests:
        test()
    print(f"charts_release_test.py: {len(tests)} tests passed")
