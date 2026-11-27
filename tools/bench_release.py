#!/usr/bin/env python3
"""The jobs that the bench workflow runs, and the release that a tag's jobs measure again (decision
85 as amended on 2026-11-26).

    python3 tools/bench_release.py matrix                prints the jobs of a release, as JSON
    python3 tools/bench_release.py matrix <benchmark>    prints the jobs of one benchmark by hand
    python3 tools/bench_release.py previous <tag>        prints the release before <tag>, or nothing

bench/charts.txt names each chart that a release draws: the chart, its architecture, the
benchmark whose reports it draws, and the jobs of that benchmark that the architecture's runner
runs. A release runs, on each architecture, the most jobs that any chart of a benchmark asks for,
so the charts of one benchmark draw from the same jobs.

The release before a tag is the newest tag `vMAJOR.MINOR.PATCH` that is older than the tag by
SemVer's order (decision 65). The order of the numbers decides it, not the history: a tag that
names a commit no longer on main is still a release.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# The runner of each architecture, as the bench workflow names it.
RUNNERS = {"x86_64": "ubuntu-26.04", "aarch64": "ubuntu-26.04-arm"}
# A release's tag, as decision 65 names it.
RELEASE = re.compile(r"^v(\d+)\.(\d+)\.(\d+)$")


def manifest(path=os.path.join(ROOT, "bench", "charts.txt")):
    """Each (chart, architecture, benchmark, jobs) that bench/charts.txt names."""
    out = []
    for line in open(path, encoding="utf-8"):
        words = line.split("#", 1)[0].split()
        if not words:
            continue
        if len(words) != 4 or words[1] not in RUNNERS or not words[3].isdigit() or int(words[3]) < 1:
            raise ValueError(f"bench/charts.txt: a line names a chart, an architecture, a benchmark and its jobs: {line.strip()}")
        out.append((words[0], words[1], words[2], int(words[3])))
    return out


def release_jobs(charts):
    """One job for each benchmark, runner and job number of a release, in the order the charts name
    them."""
    jobs = {}
    for _, arch, benchmark, count in charts:
        jobs[(benchmark, arch)] = max(jobs.get((benchmark, arch), 0), count)
    return [{"benchmark": benchmark, "runner": RUNNERS[arch], "job": n}
            for (benchmark, arch), count in jobs.items() for n in range(1, count + 1)]


def benchmark_jobs(benchmark):
    """The jobs of one benchmark that a person starts: one on each runner."""
    return [{"benchmark": benchmark, "runner": runner, "job": 1} for runner in RUNNERS.values()]


def version(tag):
    """A release tag's numbers, or None for a tag that is no release."""
    m = RELEASE.match(tag)
    return tuple(int(n) for n in m.groups()) if m else None


def previous(tag, tags):
    """The newest release among `tags` that is older than `tag`, or None."""
    current = version(tag)
    if current is None:
        raise ValueError(f"{tag} is not a release tag vMAJOR.MINOR.PATCH")
    older = [(version(t), t) for t in tags if version(t) is not None and version(t) < current]
    return max(older)[1] if older else None


def main(arguments):
    if arguments[:1] == ["matrix"] and len(arguments) <= 2:
        jobs = benchmark_jobs(arguments[1]) if len(arguments) == 2 else release_jobs(manifest())
        print(json.dumps(jobs, separators=(",", ":")))
        return
    if arguments[:1] == ["previous"] and len(arguments) == 2:
        tags = subprocess.run(["git", "tag", "--list", "v*"], cwd=ROOT, check=True, capture_output=True,
                              text=True).stdout.split()
        print(previous(arguments[1], tags) or "")
        return
    sys.exit("usage: tools/bench_release.py matrix [<benchmark>] | previous <tag>")


if __name__ == "__main__":
    main(sys.argv[1:])
