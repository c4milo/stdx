#!/usr/bin/env python3
"""Draws every chart of a release from the bench workflow's reports, with what changed since the
previous release (decision 85 as amended on 2026-11-26).

    python3 tools/charts_release.py <reports> <out> <tag> [<previous tag> <previous reports> [<previous commit>]]

<reports> holds the run's artifacts, as `gh run download` writes them: a folder
`bench-<benchmark>-<runner>-<job>` for each job, with the release's `bench-report.md`. Each chart
that bench/charts.txt names draws from the jobs of its benchmark on its architecture's runner, and
fails when a job is missing. <previous reports> holds the folder `reports/` of the previous
release's archive, which tools/charts_release.sh takes from that release: each chart compares with
the same chart drawn from it (chart_change.py), as connect-zig compares its charts. Where that
release holds no archive, a job's `base-report.md` stands in for it when the report names
<previous commit>: the job measured the previous release first, on the same machine, as the runs
of the bench workflow before 2026-11-27 did. <out> then holds:

- `<chart>-<architecture>.svg`, each chart;
- `benchmarks.md`, the page of the branch `charts`: each chart, its verdicts and the rows that
  changed, which no page on main repeats;
- `notes.md`, the section that tools/charts_release.sh adds to the release's notes;
- `reports/`, each job's report, as `<benchmark>-<architecture>-<job>.md`, which the next release
  compares with.
"""
import os
import re
import shutil
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bench_release  # noqa: E402
import chart_change  # noqa: E402
import charts  # noqa: E402

# The folder of one job's reports, as the bench workflow names its artifact.
ARTIFACT = re.compile(r"^bench-(?P<benchmark>[a-z0-9]+)-(?P<runner>[a-z0-9.-]+?)-(?P<job>\d+)$")
ARCHITECTURES = {runner: arch for arch, runner in bench_release.RUNNERS.items()}
# The page of the branch `charts`, which the README and every module's README link.
PAGE = "https://github.com/c4milo/stdx/blob/charts/benchmarks.md"
# The heading of the section of a release's notes, which tools/charts_release.sh finds again.
HEADING = "## Benchmarks"
# A report of the previous release's archive: `<benchmark>-<architecture>-<job>.md`.
KEPT = re.compile(r"^(?P<benchmark>[a-z0-9]+)-(?P<arch>aarch64|x86_64)-(?P<job>\d+)\.md$")
# The row of a report's table of fields that names its commit, which bench/run.sh writes.
COMMIT = re.compile(r"^\| Commit \| ([0-9a-f]+) \|$")
# The fewest hex digits of a commit that a report's name of it must hold, as git abbreviates it.
SHORT_COMMIT = 7


def jobs_in(folder):
    """Each job's report under `folder`: {(benchmark, architecture): [(job, report)]}."""
    out = {}
    for entry in sorted(os.listdir(folder)):
        m = ARTIFACT.match(entry)
        report = os.path.join(folder, entry, "bench-report.md")
        if not m or m.group("runner") not in ARCHITECTURES or not os.path.exists(report):
            continue
        key = (m.group("benchmark"), ARCHITECTURES[m.group("runner")])
        out.setdefault(key, []).append((int(m.group("job")), report))
    return {key: sorted(jobs) for key, jobs in out.items()}


def kept_in(folder):
    """Each report of the previous release's archive under `folder`/reports:
    {(benchmark, architecture): [report]}, by job. An absent folder holds none."""
    reports = os.path.join(folder, "reports") if folder else ""
    out = {}
    if not reports or not os.path.isdir(reports):
        return out
    for name in os.listdir(reports):
        m = KEPT.match(name)
        if m:
            out.setdefault((m.group("benchmark"), m.group("arch")), []).append((int(m.group("job")), os.path.join(reports, name)))
    return {key: [path for _, path in sorted(jobs)] for key, jobs in out.items()}


class MissingJobs(Exception):
    """A chart's benchmark left no report of a job. Any other error is a fault of the drawing, and
    keeps its traceback."""


def report_commit(path):
    """The commit a report names in its table of fields, as bench/run.sh writes it, or None."""
    for line in open(path, encoding="utf-8"):
        m = COMMIT.match(line)
        if m:
            return m.group(1)
    return None


def based_in(folder, commit):
    """Each job's `base-report.md` under `folder` that measured `commit`, as kept_in gives the
    reports of an archive: {(benchmark, architecture): [report]}, by job. A short commit names
    `commit` when it starts it."""
    out = {}
    for entry in sorted(os.listdir(folder)):
        m = ARTIFACT.match(entry)
        report = os.path.join(folder, entry, "base-report.md")
        if not m or m.group("runner") not in ARCHITECTURES or not os.path.exists(report):
            continue
        named = report_commit(report)
        if not named or len(named) < SHORT_COMMIT or not commit.startswith(named):
            continue
        key = (m.group("benchmark"), ARCHITECTURES[m.group("runner")])
        out.setdefault(key, []).append((int(m.group("job")), report))
    return {key: [path for _, path in sorted(jobs)] for key, jobs in out.items()}


def chart_jobs(found, arch, benchmark, count):
    """The jobs a chart draws, and fails unless every job of its benchmark ran."""
    jobs = found.get((benchmark, arch), [])
    ran = {job for job, _ in jobs}
    missing = [n for n in range(1, count + 1) if n not in ran]
    if missing:
        raise MissingJobs(f"{benchmark} on {arch}: no report of jobs {missing}")
    return [j for j in jobs if j[0] <= count]


def moved_rows(chart, name=None):
    """The rows of a chart that changed by the threshold or more, as Markdown table rows, each
    after the chart's name when `name` is given."""
    out = []
    for panel, row, change in chart.changes:
        if change is None or change.kind is None:
            continue
        arrow = "▲" if change.kind == "faster" else "▼"
        cells = [cell.replace("|", "\\|") for cell in ((name,) if name else ()) + (panel, row)]
        out.append("| " + " | ".join(cells) + f" | {arrow} {change.amount()} {change.kind} |")
    return out


def compared_none(drawn):
    """Whether the previous release left no report of any chart, as a release before decision 85's
    amendment of 2026-11-26 did."""
    return all(chart.comparison == chart_change.NO_REPORTS for _, chart in drawn)


def summary_line(chart, previous_tag):
    if chart.comparison != chart_change.COMPARED:
        return chart_change.note(previous_tag, chart.comparison)
    faster, slower, judged = chart_change.counts(chart.changes)
    return (f"Since {previous_tag}: {faster} rows faster and {slower} slower by {chart_change.THRESHOLD:.0%} "
            f"or more, of {judged}.")


def section(name, chart, previous_tag):
    """A chart's section of the page: its image, its verdicts and its rows that changed."""
    lines = [f"## {chart.title}", "", f"![{chart.title}]({name}.svg)", ""]
    lines += [f"- {claim}" for claim in chart.claims] + [""]
    if previous_tag:
        lines += [summary_line(chart, previous_tag), ""]
        rows = moved_rows(chart)
        if rows:
            lines += ["| Panel | Row | Change |", "| --- | --- | --- |", *rows, ""]
    return lines


def page(drawn, tag, previous_tag, run, same_jobs=False):
    """The page of the branch `charts`. `same_jobs` says the previous release's reports came from
    this release's jobs, which measured it first."""
    if not previous_tag:
        against = " No release came before it, so no chart marks a change."
    elif compared_none(drawn):
        against = f" {previous_tag} left no reports of its benchmarks, so no chart marks a change."
    else:
        against = (f" Each chart marks the rows that changed since {previous_tag}, which the same jobs measured first."
                   if same_jobs else
                   f" Each chart marks the rows that changed since {previous_tag}, where both ran on one CPU model.")
    lines = [f"# stdx's benchmarks at {tag}", "",
             f"The bench workflow drew these charts from the jobs of [its run]({run}) for {tag}.{against} "
             "[docs/benchmarks.md](https://github.com/c4milo/stdx/blob/main/docs/benchmarks.md) says how to "
             "read them and how to run each benchmark again.", ""]
    for name, chart in drawn:
        lines += section(name, chart, previous_tag if not compared_none(drawn) else None)
    return "\n".join(lines)


def notes(drawn, tag, previous_tag, same_jobs=False):
    """The section of the release's notes: each chart's rows faster and slower since the previous
    release."""
    lines = [HEADING, ""]
    if not previous_tag:
        return "\n".join(lines + [f"No release came before {tag}, so no chart marks a change. [The charts]({PAGE}).", ""])
    if compared_none(drawn):
        return "\n".join(lines + [f"{previous_tag} left no reports of its benchmarks, so no chart marks a change. "
                                   f"[The charts]({PAGE}).", ""])
    against = (f"with {previous_tag}, which the same jobs measured first, on the same machines"
               if same_jobs else f"with {previous_tag}'s, where both ran on one CPU model")
    lines += [f"Each chart compares {tag}'s jobs {against}. A row is "
              f"faster or slower where its ratio to its baseline moved by {chart_change.THRESHOLD:.0%} or more past "
              f"the noise. [The charts and their verdicts]({PAGE}).", "",
              "| Chart | Faster | Slower | Rows |", "| --- | ---: | ---: | ---: |"]
    others = []
    for _, chart in drawn:
        if chart.comparison != chart_change.COMPARED:
            others.append(chart.title)
            continue
        faster, slower, judged = chart_change.counts(chart.changes)
        lines.append(f"| {chart.title} | {faster} | {slower} | {judged} |")
    if others:
        lines += ["", f"These charts mark nothing, since {previous_tag} ran them on another CPU model or left no "
                  "report of them: " + "; ".join(others) + "."]
    moved = [row for name, chart in drawn for row in moved_rows(chart, name)]
    if moved:
        lines += ["", "<details>", "<summary>Rows that changed</summary>", "",
                  "| Chart | Panel | Row | Change |", "| --- | --- | --- | --- |", *moved, "", "</details>"]
    return "\n".join(lines + [""])


def copy_reports(found, out):
    folder = os.path.join(out, "reports")
    os.makedirs(folder, exist_ok=True)
    for (benchmark, arch), jobs in found.items():
        for job, report in jobs:
            shutil.copy(report, os.path.join(folder, f"{benchmark}-{arch}-{job}.md"))


def draw_all(found, kept, previous_tag, manifest):
    """Each chart of the manifest, as (name, Chart), each compared with the previous release's
    reports of its benchmark and architecture."""
    drawn = []
    for chart_name, arch, benchmark, count in manifest:
        paths = [report for _, report in chart_jobs(found, arch, benchmark, count)]
        drawn.append((f"{chart_name}-{arch}", charts.draw(chart_name, paths, kept.get((benchmark, arch), []), previous_tag)))
    return drawn


def run_id():
    """The run whose jobs measured the reports: BENCH_REPORTS_RUN when the workflow drew them again
    from an earlier run, and this run otherwise."""
    return os.environ.get("BENCH_REPORTS_RUN") or os.environ.get("GITHUB_RUN_ID", "")


def previous_reports(folder, arguments):
    """The previous release's reports, and whether this release's jobs measured them: its archive
    when it holds one, and else the jobs' base reports that name its commit."""
    kept = kept_in(arguments[0])
    if kept or len(arguments) < 2 or not arguments[1]:
        return kept, False
    based = based_in(folder, arguments[1])
    return based, bool(based)


def main(arguments):
    if len(arguments) not in (3, 5, 6):
        sys.exit("usage: tools/charts_release.py <reports> <out> <tag> "
                 "[<previous tag> <previous reports> [<previous commit>]]")
    folder, out, tag = arguments[:3]
    previous_tag = arguments[3] if len(arguments) >= 5 and arguments[3] else None
    found = jobs_in(folder)
    kept, same_jobs = previous_reports(folder, arguments[4:]) if previous_tag else ({}, False)
    try:
        drawn = draw_all(found, kept, previous_tag, bench_release.manifest())
    except MissingJobs as error:
        sys.exit(f"charts_release.py: {error}")
    os.makedirs(out, exist_ok=True)
    for name, chart in drawn:
        with open(os.path.join(out, f"{name}.svg"), "w", encoding="utf-8") as svg:
            svg.write(chart.svg)
    run = f"{os.environ.get('GITHUB_SERVER_URL', 'https://github.com')}/{os.environ.get('GITHUB_REPOSITORY', 'c4milo/stdx')}/actions/runs/{run_id()}"
    with open(os.path.join(out, "benchmarks.md"), "w", encoding="utf-8") as text:
        text.write(page(drawn, tag, previous_tag, run, same_jobs))
    with open(os.path.join(out, "notes.md"), "w", encoding="utf-8") as text:
        text.write(notes(drawn, tag, previous_tag, same_jobs))
    copy_reports(found, out)


if __name__ == "__main__":
    main(sys.argv[1:])
