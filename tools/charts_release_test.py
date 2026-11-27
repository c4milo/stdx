"""Tests of tools/charts_release.py and tools/charts_release.sh: python3 -I tools/charts_release_test.py.

The reports are the committed runs of bench/results/, each standing in for a release's job and
for the previous release's archived report of it, where a test changes a cell.
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


RUNNERS = {"aarch64": "ubuntu-26.04-arm", "x86_64": "ubuntu-26.04"}
CODECS = ("deflate", "zstd", "brotli", "json", "checksum", "base64")


def jobs():
    """Each job the committed manifest asks for: (benchmark, architecture, job, committed report)."""
    for arch in RUNNERS:
        for benchmark in CODECS:
            yield benchmark, arch, 1, f"2026-11-20-{benchmark}-{arch}.md"
        for job, ordinal in enumerate(ORDINALS, 1):
            yield "regex", arch, job, f"2026-11-24-regex-places-{ordinal}{arch}.md"


def artifacts(folder):
    """A run's artifacts for every job of the manifest."""
    for benchmark, arch, job, report in jobs():
        add(folder, f"bench-{benchmark}-{RUNNERS[arch]}-{job}", report)


def kept(folder):
    """The previous release's archive of reports, extracted: the same committed reports."""
    os.makedirs(os.path.join(folder, "reports"))
    for benchmark, arch, job, report in jobs():
        shutil.copy(os.path.join(RESULTS, report), os.path.join(folder, "reports", f"{benchmark}-{arch}-{job}.md"))


def add(folder, name, report):
    os.makedirs(os.path.join(folder, name))
    shutil.copy(os.path.join(RESULTS, report), os.path.join(folder, name, "bench-report.md"))


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
        add(folder, "bench-deflate-ubuntu-26.04-arm-1", "2026-11-20-deflate-aarch64.md")
        add(folder, "bench-regex-ubuntu-26.04-2", "2026-11-24-regex-places-x86_64.md")
        add(folder, "bench-regex-other-runner-1", "2026-11-24-regex-places-x86_64.md")
        os.makedirs(os.path.join(folder, "bench-zstd-ubuntu-26.04-1"))
        found = charts_release.jobs_in(folder)
        assert set(found) == {("deflate", "aarch64"), ("regex", "x86_64")}, found
        job, report = found[("deflate", "aarch64")][0]
        assert job == 1 and report.endswith("bench-report.md")
        try:
            charts_release.chart_jobs(found, "x86_64", "regex", 2)
        except charts_release.MissingJobs as error:
            assert "[1]" in str(error), error
        else:
            raise AssertionError("no error for a missing job")


def test_kept_in():
    with tempfile.TemporaryDirectory() as folder:
        assert charts_release.kept_in(folder) == {} and charts_release.kept_in("") == {}
        os.makedirs(os.path.join(folder, "reports"))
        for name in ("regex-x86_64-10.md", "regex-x86_64-2.md", "deflate-aarch64-1-previous.md", "notes.md"):
            open(os.path.join(folder, "reports", name), "w").write("")
        found = charts_release.kept_in(folder)
        # By job number, and an earlier run's previous reports are left out.
        assert list(found) == [("regex", "x86_64")], found
        assert [os.path.basename(p) for p in found[("regex", "x86_64")]] == ["regex-x86_64-2.md", "regex-x86_64-10.md"]


def release(folder, change=None):
    """Draws every chart of a release whose previous release's reports `change` alters."""
    artifacts(os.path.join(folder, "in"))
    kept(os.path.join(folder, "kept"))
    if change:
        change(os.path.join(folder, "kept", "reports"))
    out = os.path.join(folder, "out")
    charts_release.main([os.path.join(folder, "in"), out, "v0.4.0", "v0.3.0", os.path.join(folder, "kept")])
    return out


def slower_then(reports):
    """The previous release: two gzip rows, gzip's level 6 and a regex row of every N2 job changed."""
    deflate = os.path.join(reports, "deflate-aarch64-1.md")
    scale(deflate, "Decoding, gzip at zlib level 6", "canterbury/alice29.txt", "stdx, MB/s", 1 / 1.2)
    scale(deflate, "Decoding, gzip at zlib level 6", "canterbury/kennedy.xls", "stdx, MB/s", 1.2)
    scale_level(deflate, "Encoding speed, gzip", "6", "stdx, MB/s", 1 / 1.3)
    for job in range(1, len(ORDINALS) + 1):
        scale(os.path.join(reports, f"regex-aarch64-{job}.md"), "Search in 1 MiB, MB/s", "literal: a word", "stdx", 1 / 1.25)


def test_release():
    with tempfile.TemporaryDirectory() as folder:
        out = release(folder, slower_then)
        svgs = sorted(name for name in os.listdir(out) if name.endswith(".svg"))
        assert len(svgs) == 18 and "regex-rebar-others-x86_64.svg" in svgs, svgs
        assert len(os.listdir(os.path.join(out, "reports"))) == 48
        chart = open(os.path.join(out, "deflate-aarch64.svg")).read()
        marks = chart.split("</style>")[1]
        assert marks.count('class="better"') == 2 and marks.count('class="worse"') == 1, "two ▲ and one ▼"
        assert "past the noise of both" in chart
        assert '>6 <tspan class="better">▲30%</tspan></text>' in chart, "the encoder's level marks its change"
        regex = open(os.path.join(out, "regex-aarch64.svg")).read()
        assert 'a word <tspan class="better">▲25%</tspan>' in regex, "the regex chart marks its row"
        notes = open(os.path.join(out, "notes.md")).read()
        assert notes.startswith(charts_release.HEADING + "\n")
        assert "| deflate-aarch64 | gzip encoding: " in notes and "| stdx level 6 | ▲ 30% faster |" in notes, notes
        assert "| search for a literal: every match in 1 MiB | a word | ▲ 25% faster |" in notes, notes
        assert "| canterbury/alice29.txt | ▲ 20% faster |" in notes and "| canterbury/kennedy.xls | ▼ 17% slower |" in notes
        assert "| stdx's DEFLATE against its baselines, on Neoverse-N2 | 2 | 1 | 42 |" in notes, notes
        assert "mark nothing" not in notes
        page = open(os.path.join(out, "benchmarks.md")).read()
        assert page.startswith("# stdx's benchmarks at v0.4.0") and "![stdx's DEFLATE" in page
        assert "Since v0.3.0: 2 rows faster and 1 slower by 5% or more, of 42." in page, page
        # A chart's own section names no chart in its table of rows.
        assert "| Panel | Row | Change |" in page and "| deflate-aarch64 |" not in page
        assert "\n| gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio | stdx level 6 |" in page


def test_run_link():
    """The page links the run that measured the reports, which BENCH_REPORTS_RUN names when the
    workflow draws them again from an earlier run."""
    saved = {key: os.environ.get(key) for key in ("BENCH_REPORTS_RUN", "GITHUB_RUN_ID")}
    try:
        os.environ["GITHUB_RUN_ID"] = "222"
        os.environ.pop("BENCH_REPORTS_RUN", None)
        assert charts_release.run_id() == "222"
        os.environ["BENCH_REPORTS_RUN"] = "111"
        assert charts_release.run_id() == "111"
        os.environ["BENCH_REPORTS_RUN"] = ""
        assert charts_release.run_id() == "222", "an empty input names this run"
    finally:
        for key, value in saved.items():
            if value is None:
                os.environ.pop(key, None)
            else:
                os.environ[key] = value


def other_model(reports):
    """The previous release's x86-64 deflate job and every x86-64 regex job ran on another CPU."""
    paths = [os.path.join(reports, "deflate-x86_64-1.md")]
    paths += [os.path.join(reports, f"regex-x86_64-{job}.md") for job in range(1, len(ORDINALS) + 1)]
    for path in paths:
        text = re.sub(r"\| CPU model \| [^|]*\|", "| CPU model | Another CPU |", open(path).read())
        open(path, "w").write(text)


def set_cell(path, section, row, column, text):
    """Writes `text` into one cell of a report."""
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
            cells[head.index(column)] = text
            lines[i] = "| " + " | ".join(cells) + " |"
    open(path, "w").write("\n".join(lines))


def noisy_then(reports):
    """The previous release: a gzip row 10% slower whose cell spread 12%, and a regex row whose
    jobs spread from 10% slower to three times as fast, so that neither passes its noise."""
    # The committed report times stdx at 1074 MB/s on this row: 976.4 is 10% slower.
    set_cell(os.path.join(reports, "deflate-aarch64-1.md"), "Decoding, gzip at zlib level 6",
             "canterbury/plrabn12.txt", "stdx, MB/s", "976.4 ± 12.0%")
    for job in range(1, len(ORDINALS) + 1):
        factor = 1 / 1.1 if job <= 10 else 3.0
        scale(os.path.join(reports, f"regex-aarch64-{job}.md"), "Search in 1 MiB, MB/s",
              "literal: a word that is not there", "stdx", factor)


def test_noise():
    with tempfile.TemporaryDirectory() as folder:
        out = release(folder, noisy_then)
        deflate = open(os.path.join(out, "deflate-aarch64.svg")).read()
        regex = open(os.path.join(out, "regex-aarch64.svg")).read()
        assert "canterbury/plrabn12.txt <tspan" not in deflate, "a change inside the cells' spread is marked"
        assert "a word that is not there <tspan" not in regex, "a change inside the jobs' interval is marked"
        assert "plrabn12" not in open(os.path.join(out, "notes.md")).read()


def wide_spread(inputs):
    """The release: the x86-64 JSON job timed stdx's decoding of one row at 773.1 MB/s ± 148.7%,
    as the job of v0.4.0 did, so that the low end of its spread is below zero."""
    set_cell(os.path.join(inputs, "bench-json-ubuntu-26.04-1", "bench-report.md"), "Decoding against the baselines",
             "messages: a tree of 341 objects", "stdx, MB/s", "773.1 ± 148.7%")


def test_wide_spread():
    with tempfile.TemporaryDirectory() as folder:
        artifacts(os.path.join(folder, "in"))
        wide_spread(os.path.join(folder, "in"))
        out = os.path.join(folder, "out")
        charts_release.main([os.path.join(folder, "in"), out, "v0.4.0"])
        chart = open(os.path.join(out, "json-x86_64.svg")).read()
        assert "a tree of 341 objects" in chart, "the row with the wide spread is drawn"


def test_moved_rows():
    """A change of two times or more states a multiple in the notes, as on the chart."""
    import chart_change
    chart = charts_release.charts.Chart("", "a chart", [], [
        ("a panel", "a row", chart_change.Change(3.0, 1.0)),
        ("a panel", "a row | with a pipe", chart_change.Change(1.0, 4.0)),
        ("a panel", "a row inside the threshold", chart_change.Change(1.01, 1.0))])
    assert charts_release.moved_rows(chart, "deflate-x86_64") == [
        "| deflate-x86_64 | a panel | a row | ▲ 3.0× faster |",
        "| deflate-x86_64 | a panel | a row \\| with a pipe | ▼ 4.0× slower |"], charts_release.moved_rows(chart, "deflate-x86_64")


def test_drawing_fault():
    """An error of the drawing keeps its traceback: only a missing job ends with a message."""
    with tempfile.TemporaryDirectory() as folder:
        artifacts(os.path.join(folder, "in"))
        draw = charts_release.charts.draw

        def fault(*arguments):
            raise ValueError("a fault of the drawing")
        charts_release.charts.draw = fault
        try:
            charts_release.main([os.path.join(folder, "in"), os.path.join(folder, "out"), "v0.4.0"])
        except ValueError as error:
            assert str(error) == "a fault of the drawing", error
        else:
            raise AssertionError("the fault ended as a missing job's message")
        finally:
            charts_release.charts.draw = draw


def test_other_model():
    with tempfile.TemporaryDirectory() as folder:
        out = release(folder, other_model)
        for name in ("deflate-x86_64", "regex-x86_64"):
            chart = open(os.path.join(out, f"{name}.svg")).read()
            assert "ran this chart on another CPU model" in chart, name
            assert 'class="was"' not in chart.split("</style>")[1], name
        assert "past the noise of both" in open(os.path.join(out, "deflate-aarch64.svg")).read()
        notes = open(os.path.join(out, "notes.md")).read()
        assert "mark nothing, since v0.3.0 ran them on another CPU model" in notes, notes
        assert "| stdx's DEFLATE against its baselines, on Intel" not in notes


def test_no_reports():
    with tempfile.TemporaryDirectory() as folder:
        artifacts(os.path.join(folder, "in"))
        out = os.path.join(folder, "out")
        charts_release.main([os.path.join(folder, "in"), out, "v0.4.0", "v0.3.0", os.path.join(folder, "absent")])
        assert "left no reports of this chart" in open(os.path.join(out, "deflate-aarch64.svg")).read()
        # One line in the notes and on the page, and no table and no list of the 18 charts.
        notes = open(os.path.join(out, "notes.md")).read()
        assert "v0.3.0 left no reports of its benchmarks, so no chart marks a change." in notes, notes
        assert "| Chart |" not in notes and "mark nothing" not in notes, notes
        page = open(os.path.join(out, "benchmarks.md")).read()
        assert "v0.3.0 left no reports of its benchmarks" in page and "Since v0.3.0" not in page, page
        assert "Each chart marks" not in page and "left no reports of this chart" not in page


def test_first_release():
    with tempfile.TemporaryDirectory() as folder:
        artifacts(os.path.join(folder, "in"))
        out = os.path.join(folder, "out")
        charts_release.main([os.path.join(folder, "in"), out, "v0.1.0", "", ""])
        notes = open(os.path.join(out, "notes.md")).read()
        assert "No release came before v0.1.0" in notes, notes
        chart = open(os.path.join(out, "deflate-aarch64.svg")).read()
        assert 'class="better"' not in chart.split("</style>")[1] and "marks no change" not in chart


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
    "release download") [ -f "$here/archive.tar.gz" ] || exit 1; cp "$here/archive.tar.gz" "$7/bench-reports-$3.tar.gz" ;;
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


def test_previous():
    with tempfile.TemporaryDirectory() as folder:
        env, bin_folder = stub(folder)
        os.makedirs(os.path.join(folder, "archive", "reports"))
        open(os.path.join(folder, "archive", "reports", "deflate-aarch64-1.md"), "w").write("report")
        subprocess.run(["tar", "-czf", os.path.join(bin_folder, "archive.tar.gz"), "-C", os.path.join(folder, "archive"), "reports"], check=True)
        shell(f'release_previous v9.9.9 "{folder}/kept"', folder, env)
        assert open(os.path.join(folder, "kept", "reports", "deflate-aarch64-1.md")).read() == "report"
        assert os.listdir(os.path.join(folder, "kept")) == ["reports"]
        # A release with no archive leaves the folder empty.
        os.remove(os.path.join(bin_folder, "archive.tar.gz"))
        shell(f'release_previous v9.9.8 "{folder}/none"', folder, env)
        assert os.listdir(os.path.join(folder, "none")) == []


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
