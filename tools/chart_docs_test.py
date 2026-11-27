"""Tests of tools/chart_docs.py: python3 -I tools/chart_docs_test.py."""
import os
import shutil
import sys
import tempfile

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import chart_docs  # noqa: E402

CHARTS = chart_docs.CHARTS


def test_image():
    got = chart_docs.image("deflate", "aarch64")
    assert got == ("![stdx's DEFLATE against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner]"
                   f"({CHARTS}deflate-aarch64.svg)"), got
    assert "x86-64 runner" in chart_docs.image("regex-rebar-others", "x86_64")


def test_with_images():
    page = "a ![old](../../docs/images/zstd-x86_64.svg) b ![keep](images/other.svg) c ![x](images/unknown-aarch64.svg)"
    got = chart_docs.with_images(page)
    assert got == f"a {chart_docs.image('zstd', 'x86_64')} b ![keep](images/other.svg) c ![x](images/unknown-aarch64.svg)", got
    # An alt text that holds an escaped bracket is replaced whole, and a written image stays.
    assert chart_docs.with_images(r"![a \] b](images/zstd-x86_64.svg)") == chart_docs.image("zstd", "x86_64")
    assert chart_docs.with_images(chart_docs.image("json", "aarch64")) == chart_docs.image("json", "aarch64")


def test_problems():
    shown = [("zstd", "aarch64"), ("zstd", "x86_64")]
    both = chart_docs.image("zstd", "aarch64") + "\n" + chart_docs.image("zstd", "x86_64")
    assert chart_docs.problems("p", both, shown) == []
    missing = chart_docs.problems("p", chart_docs.image("zstd", "aarch64"), shown)
    assert len(missing) == 1 and "zstd-x86_64" in missing[0], missing
    assert chart_docs.problems("p", both + "\n![a](images/zstd-x86_64.svg)", shown)
    assert chart_docs.problems("p", both + "\n<!-- claims of zstd-x86_64 -->", shown)


def test_expected():
    pages = chart_docs.expected([("zstd", "aarch64", "zstd", 1), ("regex-rebar-others", "x86_64", "regex", 18),
                                 ("regex", "x86_64", "regex", 18)])
    assert pages["README.md"] == []
    assert pages["docs/benchmarks.md"] == [("zstd", "aarch64"), ("regex-rebar-others", "x86_64"), ("regex", "x86_64")]
    assert pages["src/compress/zstd/README.md"] == [("zstd", "aarch64")]
    # A module's README shows its own chart alone.
    assert pages["src/regex/README.md"] == [("regex-rebar-others", "x86_64")]


def run(root, arguments):
    """chart_docs.py's main over the tree at `root`: None when it passes, or its message."""
    saved = chart_docs.ROOT
    chart_docs.ROOT = root
    try:
        chart_docs.main(arguments)
    except SystemExit as stop:
        return str(stop)
    finally:
        chart_docs.ROOT = saved
    return None


def copy_pages(root):
    for page in chart_docs.expected([]).keys() | {f"src/{m}/README.md" for m in chart_docs.CHART_MODULES}:
        os.makedirs(os.path.dirname(os.path.join(root, page)) or root, exist_ok=True)
        shutil.copy(os.path.join(chart_docs.ROOT, page), os.path.join(root, page))


def test_committed_pages():
    # The committed pages pass, and a page that loses an image or holds an old one fails.
    assert run(chart_docs.ROOT, ["--check"]) is None
    with tempfile.TemporaryDirectory() as root:
        copy_pages(root)
        assert run(root, ["--check"]) is None
        readme = os.path.join(root, "src/compress/zstd/README.md")
        text = open(readme).read()
        open(readme, "w").write(text.replace(chart_docs.image("zstd", "x86_64"), ""))
        assert "zstd-x86_64" in run(root, ["--check"])
        open(readme, "w").write(text.replace(chart_docs.image("zstd", "x86_64"), "![t](../../../docs/images/zstd-x86_64.svg)"))
        assert "differs" in run(root, ["--check"])
        # Written, the page shows the chart from the branch again.
        assert run(root, []) is None
        assert run(root, ["--check"]) is None
        open(readme, "w").write(text + "\n<!-- claims of zstd-aarch64 -->\n")
        assert "claims" in run(root, ["--check"])


if __name__ == "__main__":
    tests = [value for name, value in sorted(globals().items()) if name.startswith("test_")]
    for test in tests:
        test()
    print(f"chart_docs_test.py: {len(tests)} tests passed")
