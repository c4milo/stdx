"""Checks that the pages on main show each chart from the branch `charts`, and say no measured
number of it (decision 85 as amended on 2026-11-26).

    python3 tools/chart_docs.py           writes each chart's image as the pages must show it
    python3 tools/chart_docs.py --check   fails where a page differs

The bench workflow draws each chart again on every release, into the branch `charts`. A page on
main shows a chart from that branch, so it always shows the latest release's:

- An image of a chart is `![<alt>](<CHARTS><chart>-<architecture>.svg)`, and its alt text names the
  chart and the runner, from `alt`, never a count: the counts are the release's.
- docs/benchmarks.md shows every chart that bench/charts.txt names, and the README of each
  module's folder shows the charts of its module (decision 88).
- No page shows an image of docs/images/, or holds a block of claims, which a release would leave
  stale.
"""
import os
import re
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bench_release  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# Where a page reads a chart: the branch `charts`, which GitHub serves as images.
CHARTS = "https://raw.githubusercontent.com/c4milo/stdx/charts/"
# The README of each module's folder that shows a chart, and the chart it shows, each folder under
# its category's (decision 6).
CHART_MODULES = {
    "encoding/base64": "base64",
    "compress/brotli": "brotli",
    "hash": "checksum",
    "compress/deflate": "deflate",
    "encoding/json": "json",
    "regex": "regex-rebar-others",
    "compress/zstd": "zstd",
}
# The page that shows every chart.
EVERY_CHART = "docs/benchmarks.md"
# What each chart draws, as its alt text names it.
SUBJECTS = {
    "deflate": "stdx's DEFLATE against its baselines",
    "zstd": "stdx's Zstandard against its baselines",
    "brotli": "stdx's brotli against its baselines",
    "json": "stdx's JSON against its baselines",
    "checksum": "stdx's checksums against its baselines",
    "base64": "stdx's base64 against its baselines",
    "regex": "stdx's regular expressions against libraries in Rust, Go and Zig",
    "regex-rebar": "stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp",
    "regex-rebar-others": "stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp",
}
RUNNERS = {"aarch64": "GitHub's Arm Neoverse N2 runner", "x86_64": "GitHub's x86-64 runner"}
IMAGE = re.compile(r"!\[((?:\\.|[^\]\\])*)\]\(([^)\s]*?)([a-z0-9-]+)-(aarch64|x86_64)\.svg\)")
# What a page must not hold: an image of docs/images/, and a block of claims.
STALE = (re.compile(r"\]\([^)]*images/[a-z0-9_-]+\.svg\)"), re.compile(r"<!-- claims of "))


def alt(chart, arch):
    """A chart's alt text: what it draws, on which runner, at the latest release."""
    return f"{SUBJECTS[chart]}, at the latest release, on {RUNNERS[arch]}"


def image(chart, arch):
    return f"![{alt(chart, arch)}]({CHARTS}{chart}-{arch}.svg)"


def with_images(text):
    """`text` with each image of a chart written as `image` writes it."""
    def written(match):
        chart, arch = match.group(3), match.group(4)
        return image(chart, arch) if chart in SUBJECTS else match.group(0)
    return IMAGE.sub(written, text)


def expected(charts):
    """Each page, and the images of charts it must show."""
    out = {"README.md": [], EVERY_CHART: [(chart, arch) for chart, arch, _, _ in charts]}
    for module, chart in CHART_MODULES.items():
        out[f"src/{module}/README.md"] = [(c, arch) for c, arch, _, _ in charts if c == chart]
    return out


def problems(page, text, shown):
    """What a page's text lacks or holds that it must not."""
    out = [f"{page}: shows no {image(chart, arch)}" for chart, arch in shown if image(chart, arch) not in text]
    out += [f"{page}: holds {rule.pattern!r}, which a release leaves stale" for rule in STALE if rule.search(text)]
    return out


def main(arguments):
    check = arguments == ["--check"]
    found = []
    for page, shown in expected(bench_release.manifest()).items():
        path = os.path.join(ROOT, page)
        text = open(path, encoding="utf-8").read()
        new = with_images(text)
        if check and new != text:
            found.append(f"{page}: an image of a chart differs from what chart_docs.py writes")
        elif new != text:
            open(path, "w", encoding="utf-8").write(new)
        found += problems(page, new, shown)
    if found:
        sys.exit("chart_docs.py:\n  " + "\n  ".join(found))


if __name__ == "__main__":
    main(sys.argv[1:])
