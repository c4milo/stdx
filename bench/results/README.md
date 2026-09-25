# Benchmark results

Each file here is one report of `bench/run.sh`, from a named run of the `bench` workflow on one of
GitHub's hosted runners (decision 20), committed as the workflow wrote it. A file's name is the
date, the benchmark and the architecture.

A hosted runner is a shared virtual machine, and its CPU model can change from one run to the
next: the x86-64 runner was an AMD EPYC 9V74, an AMD EPYC 9V45 and an Intel Xeon Platinum 8573C in
three runs on 2026-09-25. So compare candidates within one file, where they ran interleaved on the
same machine, and never a number in one file with a number in another.

| Date | Benchmark | x86-64 | aarch64 | What it holds |
|---|---|---|---|---|
| 2026-09-25 | DEFLATE | [report](2026-09-25-deflate-x86_64.md) | [report](2026-09-25-deflate-aarch64.md) | zlib and Wuffs decoding, zlib encoding at levels 1, 6 and 9: the baselines before stdx's first codec |
