"""Writes what the READMEs and docs/benchmarks.md say of each chart, from the chart itself.

charts.py calls it after it draws the charts, and `--check` fails where a page differs:
- Each image of a chart takes the chart's title as its alt text: in the README, in the README of
  each module's folder that shows a chart (decision 88), and in docs/benchmarks.md.
- docs/benchmarks.md holds each chart's verdicts, a line for each panel, between the markers
  `<!-- claims of <chart> -->` and `<!-- end of claims -->`. Each chart that bench/charts.txt
  names has one such block, so no count is written by hand.
"""
import re

# The folders of src/ whose README shows a chart, each under its category's folder (decision 6).
CHART_MODULES = (
    "encoding/base64",
    "compress/brotli",
    "hash",
    "compress/deflate",
    "encoding/json",
    "regex",
    "compress/zstd",
)


def images_from(module):
    """The path from the README of `src/<module>/` to docs/images/."""
    return "../" * (module.count("/") + 2) + "docs/images/"


# The pages charts.py keeps, each with the path from the page to docs/images/.
PAGES = (("README.md", "docs/images/"), ("docs/benchmarks.md", "images/")) + tuple(
    (f"src/{module}/README.md", images_from(module)) for module in CHART_MODULES
)

# The page that holds the claims.
CLAIMS_PAGE = "docs/benchmarks.md"

END = "<!-- end of claims -->"


def start(name):
    """The marker before the claims of chart `name`."""
    return f"<!-- claims of {name} -->"


def escaped(text):
    """`text` with the characters that Markdown reads as markup escaped."""
    return re.sub(r"([\\`*_|<\[\]])", r"\\\1", text)


def with_alt_texts(text, prefix, titles):
    """`text` with each image of a chart under `prefix` given the chart's title as its alt text.
    An image of a chart that `titles` does not name is left as it is."""
    def alt(match):
        name = match.group(2)
        if name not in titles:
            return match.group(0)
        return f"![{escaped(titles[name])}]({prefix}{name}.svg)"
    return re.sub(r"!\[((?:\\.|[^\]\\])*)\]\(" + re.escape(prefix) + r"([a-z0-9_-]+)\.svg\)", alt, text)


def with_claims(text, claims):
    """`text` with the block of each chart in `claims` holding that chart's claims, one line each.
    Raises ValueError where a chart has no block, or its block has no end."""
    for name, lines in claims.items():
        first = text.find(start(name))
        if first < 0:
            raise ValueError(f"{CLAIMS_PAGE} has no block {start(name)}")
        body = first + len(start(name))
        end = text.find(END, body)
        if end < 0:
            raise ValueError(f"{CLAIMS_PAGE}: the block of {name} has no {END}")
        listed = "".join(f"- {escaped(line)}\n" for line in lines)
        text = text[:body] + "\n\n" + listed + "\n" + text[end:]
    return text


def pages(root, titles, claims):
    """Each page's path, its text, and the text charts.py writes there."""
    for page, prefix in PAGES:
        text = open(f"{root}/{page}", encoding="utf-8").read()
        new = with_alt_texts(text, prefix, titles)
        if page == CLAIMS_PAGE:
            new = with_claims(new, claims)
        yield f"{root}/{page}", text, new


def stale(root, titles, claims):
    """The pages under `root` whose text differs from what charts.py writes."""
    return [path for path, text, new in pages(root, titles, claims) if text != new]


def write(root, titles, claims):
    """Writes each page under `root` that differs from what charts.py writes."""
    for path, text, new in pages(root, titles, claims):
        if text != new:
            open(path, "w", encoding="utf-8").write(new)
