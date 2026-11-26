"""Tests of tools/bench_release.py: python3 -I tools/bench_release_test.py."""
import os
import sys
import tempfile

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bench_release  # noqa: E402


def manifest_of(text):
    with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False) as out:
        out.write(text)
    try:
        return bench_release.manifest(out.name)
    finally:
        os.unlink(out.name)


def test_manifest():
    charts = manifest_of("# a comment\ndeflate aarch64 deflate 1\n\nregex x86_64 regex 3 # jobs\n")
    assert charts == [("deflate", "aarch64", "deflate", 1), ("regex", "x86_64", "regex", 3)], charts
    for line in ("deflate aarch64 deflate", "deflate arm64 deflate 1", "deflate aarch64 deflate 0", "deflate aarch64 deflate x"):
        try:
            manifest_of(line + "\n")
        except ValueError:
            continue
        raise AssertionError(f"no error for {line!r}")


def test_release_jobs():
    charts = [("regex", "aarch64", "regex", 2), ("regex-rebar", "aarch64", "regex", 3),
              ("deflate", "x86_64", "deflate", 1)]
    jobs = bench_release.release_jobs(charts)
    regex = [j for j in jobs if j["benchmark"] == "regex"]
    # A benchmark runs the most jobs any of its charts asks for, numbered from 1.
    assert [j["job"] for j in regex] == [1, 2, 3], regex
    assert all(j["runner"] == "ubuntu-26.04-arm" for j in regex)
    assert {"benchmark": "deflate", "runner": "ubuntu-26.04", "job": 1} in jobs
    assert len(jobs) == 4


def test_committed_manifest():
    # Every chart of the committed manifest names a benchmark the workflow knows, and each runner
    # runs every benchmark.
    charts = bench_release.manifest()
    known = {"deflate", "zstd", "brotli", "json", "checksum", "base64", "regex"}
    assert {benchmark for _, _, benchmark, _ in charts} == known
    jobs = bench_release.release_jobs(charts)
    for runner in bench_release.RUNNERS.values():
        assert {j["benchmark"] for j in jobs if j["runner"] == runner} == known


def test_benchmark_jobs():
    jobs = bench_release.benchmark_jobs("json")
    assert jobs == [{"benchmark": "json", "runner": "ubuntu-26.04", "job": 1},
                    {"benchmark": "json", "runner": "ubuntu-26.04-arm", "job": 1}], jobs


def test_previous():
    tags = ["v0.1.0", "v0.1.2", "v0.2.0", "v0.3.0", "v0.10.0", "v0.9.1", "corpora", "v1.0.0-rc1"]
    assert bench_release.previous("v0.4.0", tags) == "v0.3.0"
    # The numbers decide, not the text: 0.10.0 follows 0.9.1.
    assert bench_release.previous("v0.10.0", tags) == "v0.9.1"
    assert bench_release.previous("v0.11.0", tags) == "v0.10.0"
    assert bench_release.previous("v0.2.0", tags) == "v0.1.2"
    assert bench_release.previous("v0.1.0", tags) is None
    try:
        bench_release.previous("corpora", tags)
    except ValueError:
        return
    raise AssertionError("no error for a tag that is no release")


if __name__ == "__main__":
    tests = [value for name, value in sorted(globals().items()) if name.startswith("test_")]
    for test in tests:
        test()
    print(f"bench_release_test.py: {len(tests)} tests passed")
