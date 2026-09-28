# Benchmark results

Each file here is one report of `bench/run.sh`, from a named run of the `bench` workflow on one of
GitHub's hosted runners (decision 20), committed as the workflow wrote it. A file's name is the
date, the benchmark and the architecture.

A hosted runner is a shared virtual machine, and its CPU model can change from one run to the
next: the x86-64 runner was an AMD EPYC 9V74, an AMD EPYC 9V45, an AMD EPYC 7763, an Intel Xeon
Platinum 8573C, an Intel Xeon Platinum 8370C and an Intel Xeon 6973P-C in runs from 2026-09-25 to
2026-09-28. So compare
candidates within one file, where they ran interleaved on the same machine, and never a number in
one file with a number in another.

| Date | Benchmark | x86-64 | aarch64 | What it holds |
|---|---|---|---|---|
| 2026-09-25 | DEFLATE | [report](2026-09-25-deflate-x86_64.md) | [report](2026-09-25-deflate-aarch64.md) | zlib and Wuffs decoding, zlib encoding at levels 1, 6 and 9: the baselines before stdx's first codec |
| 2026-09-26 | Checksums | [report](2026-09-26-checksum-x86_64.md) | [report](2026-09-26-checksum-aarch64.md) | Every CRC-32 and Adler-32 path of stdx against zlib, Wuffs, libdeflate and zlib-ng, from 64 octets to 1 MiB: design §8 step 4 |
| 2026-09-26 | DEFLATE | [report](2026-09-26-deflate-checked-x86_64.md) | [report](2026-09-26-deflate-checked-aarch64.md) | stdx's gzip decoder on its checked path alone, beside zlib and Wuffs: design §8 step 6, the baseline step 7's fast path is priced against |
| 2026-09-26 | DEFLATE | [report](2026-09-26-deflate-fast-x86_64.md) | [report](2026-09-26-deflate-fast-aarch64.md) | stdx's gzip decoder with its fast path beside zlib, zlib-ng, libdeflate and Wuffs, and each claim of decision 14 off against all on: design §8 step 7 |
| 2026-09-26 | DEFLATE | [report](2026-09-26-deflate-encoder-x86_64.md) | [report](2026-09-26-deflate-encoder-aarch64.md) | stdx's gzip encoder at levels 1, 6 and 9 beside zlib, zlib-ng and libdeflate, and the decoders as in step 7: design §8 step 9 |
| 2026-09-26 | DEFLATE | [report](2026-09-26-deflate-encoder-search-x86_64.md) | [report](2026-09-26-deflate-encoder-search-aarch64.md) | As the row above, after the encoder's search turns candidates away on 4 octets and cuts itself after a long match: design §8 step 9, after the check |
| 2026-09-26 | Checksums | [AMD](2026-09-26-checksum-xxh64-x86_64-amd.md), [Intel](2026-09-26-checksum-xxh64-x86_64-intel.md) | [report](2026-09-26-checksum-xxh64-aarch64.md) | As step 4's row, with XXH64's scalar and AVX-512 paths beside the fastest CRC-32 path: design §8 step 10. The x86-64 reports are an AMD EPYC 9V74 and an Intel Xeon 8370C, where the AVX-512 path wins and loses |
| 2026-09-27 | Zstandard | [AMD](2026-09-27-zstd-x86_64.md), [Intel 8573C](2026-09-27-zstd-x86_64-intel-8573c.md), [Intel 8370C](2026-09-27-zstd-x86_64-intel-8370c.md), [Intel 6973P-C](2026-09-27-zstd-x86_64-intel-6973p-c.md) | [report](2026-09-27-zstd-aarch64.md) | stdx's HTTP decoder beside libzstd, its fast paths against its checked path, each claim of decision 14 off, and ReleaseFast: design §8 step 11. The Intel reports come from a one-off workflow that ran `bench/run.sh` as the bench workflow does, at 637ee9a, which is 3a45936 with that workflow's file alone |
| 2026-09-28 | Zstandard | [report](2026-09-28-zstd-x86_64.md) | [report](2026-09-28-zstd-aarch64.md) | As the row above, at 2182b94, with dickens's first MiB shuffled among the files (decision 25): Z2's verdict, design §8 step 11. The x86-64 runner was an AMD EPYC 7763 |
| 2026-09-28 | JSON | [report](2026-09-28-json-x86_64.md) | [report](2026-09-28-json-aarch64.md) | The `json` module's encoder and decoder with every claim of decision 27 on, each off in turn, and every one off, over CLDR's texts, qlog-shaped records, the corpus's text files as strings, a text of Cyrillic and CJK characters, and hex strings: design §8 step 16, at dff16c4, which main holds as 0aeb7eb. The x86-64 runner was an Intel Xeon Platinum 8370C |
