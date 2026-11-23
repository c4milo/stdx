"""Tests of tools/chart_docs.py: python3 -I tools/chart_docs_test.py."""
import os
import re
import shutil
import sys
import tempfile

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import chart_docs  # noqa: E402


def test_alt_text():
    page = "a ![old](docs/images/deflate-aarch64.svg) b ![keep](docs/images/other.svg)"
    got = chart_docs.with_alt_texts(page, "docs/images/", {"deflate-aarch64": "stdx's DEFLATE"})
    assert got == "a ![stdx's DEFLATE](docs/images/deflate-aarch64.svg) b ![keep](docs/images/other.svg)", got
    # An alt text that holds an escaped bracket is replaced whole.
    page = r"![a \] b](images/zstd-x86_64.svg)"
    got = chart_docs.with_alt_texts(page, "images/", {"zstd-x86_64": "t"})
    assert got == "![t](images/zstd-x86_64.svg)", got
    # Another prefix is another page's image, and stays.
    assert chart_docs.with_alt_texts("![x](images/zstd.svg)", "docs/images/", {"zstd": "t"}) == "![x](images/zstd.svg)"


def test_claims():
    page = "x\n<!-- claims of zstd-aarch64 -->\nold\n<!-- end of claims -->\ny\n"
    got = chart_docs.with_claims(page, {"zstd-aarch64": ["one | two", "three"]})
    assert got == "x\n<!-- claims of zstd-aarch64 -->\n\n- one \\| two\n- three\n\n<!-- end of claims -->\ny\n", got
    # Written twice, the block is the same.
    assert chart_docs.with_claims(got, {"zstd-aarch64": ["one | two", "three"]}) == got


def test_missing_block():
    for page in ("no block", "<!-- claims of zstd-aarch64 --> no end"):
        try:
            chart_docs.with_claims(page, {"zstd-aarch64": ["one"]})
        except ValueError:
            continue
        raise AssertionError(f"no error for {page!r}")


def test_stale_and_write():
    with tempfile.TemporaryDirectory() as root:
        os.makedirs(f"{root}/docs")
        readme = "![old](docs/images/zstd-aarch64.svg)\n"
        claims_page = "![old](images/zstd-aarch64.svg)\n<!-- claims of zstd-aarch64 -->\n<!-- end of claims -->\n"
        open(f"{root}/README.md", "w").write(readme)
        open(f"{root}/docs/benchmarks.md", "w").write(claims_page)
        titles, claims = {"zstd-aarch64": "t"}, {"zstd-aarch64": ["one"]}
        assert chart_docs.stale(root, titles, claims) == [f"{root}/README.md", f"{root}/docs/benchmarks.md"]
        chart_docs.write(root, titles, claims)
        assert chart_docs.stale(root, titles, claims) == []
        assert open(f"{root}/README.md").read() == "![t](docs/images/zstd-aarch64.svg)\n"
        # A line outside a block is the page's own, and leaves it current.
        open(f"{root}/docs/benchmarks.md", "a").write("- two\n")
        assert chart_docs.stale(root, titles, claims) == []
        # An alt text written by hand makes the page stale again.
        open(f"{root}/README.md", "w").write(readme)
        assert chart_docs.stale(root, titles, claims) == [f"{root}/README.md"]


def test_charts_check_reads_the_pages():
    """charts.py --check fails on a tree whose README holds an alt text written by hand."""
    import charts
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    with tempfile.TemporaryDirectory() as copy:
        for folder in ("bench/results", "docs/images"):
            shutil.copytree(f"{root}/{folder}", f"{copy}/{folder}")
        for page in ("bench/charts.txt", "README.md", "docs/benchmarks.md"):
            shutil.copy(f"{root}/{page}", f"{copy}/{page}")
        saved_root, saved_argv = charts.ROOT, sys.argv
        charts.ROOT, sys.argv = copy, ["charts.py", "--check"]
        try:
            charts.main()
            readme = open(f"{copy}/README.md", encoding="utf-8").read()
            open(f"{copy}/README.md", "w", encoding="utf-8").write(re.sub(r"!\[[^\]]*\]\(docs/images/zstd-aarch64", "![by hand](docs/images/zstd-aarch64", readme))
            try:
                charts.main()
            except SystemExit as stop:
                assert f"{copy}/README.md" in str(stop), stop
            else:
                raise AssertionError("charts.py --check passed a README with an alt text written by hand")
        finally:
            charts.ROOT, sys.argv = saved_root, saved_argv


def test_escaped():
    assert chart_docs.escaped("a*b_c|d<e`f[g]h\\i") == "a\\*b\\_c\\|d\\<e\\`f\\[g\\]h\\\\i"


if __name__ == "__main__":
    tests = [value for key, value in sorted(globals().items()) if key.startswith("test_")]
    for test in tests:
        test()
    print(f"chart_docs_test.py: {len(tests)} tests passed")
