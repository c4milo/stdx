# Benchmarks

stdx's benchmarks time it beside other libraries on GitHub's hosted runners. One runner is an Arm
Neoverse N2. The x86-64 runner gives a CPU model that changes from job to job. Every library of a
row runs in the same job, and a result is stdx's speed over another library's speed in that job
([decision 20](decisions.md)).

The README shows each chart. This page says how to read them and lists the verdicts of each panel.
It also says how to run each benchmark again. `tools/charts.py` draws the charts from the reports
in [`bench/results/`](../bench/results/) that [`bench/charts.txt`](../bench/charts.txt) names. It
writes the lists below from the same numbers, and `python3 tools/charts.py --check` fails where a
list differs. Nobody writes a count on this page by hand.

## How to read a chart

The charts are of two kinds ([decision 85](decisions.md)).

- The compression, JSON, checksum and base 64 charts each draw one job, from the first runs on
  Ubuntu 26.04, at commit 0dd2e97.
  - A bar is stdx's speed in multiples of the baseline that the panel's title names.
  - A blue bar is ahead, a gray bar is level, and an orange bar is behind. A row is level when
    its ratio is inside the noise: the spread of the two cells, combined.
  - An encoder's panel plots each library's speed against its compression ratio.
- The regular expression charts draw the median of 18 jobs, at commit 1df5f9f.
  - A bar is the median job, and its whisker is a 95% interval of that median.
  - A row is ahead or behind when its interval is above or below 1. It is level when the
    interval holds 1 and stays inside 5% of 1. It is unclear when the interval holds 1 and goes
    past 5%.
  - A row ahead or behind inside 5% is lighter, and a shaded band marks 5% of 1.

## Compression

### DEFLATE, zlib and gzip

`zig build bench-deflate -Doracles` times the gzip decoders of zlib, zlib-ng, libdeflate, Wuffs
and stdx over the corpus files. It also times the gzip encoders of zlib, zlib-ng, libdeflate and
stdx at levels 1, 6 and 9.

![stdx's DEFLATE against its baselines, on Neoverse-N2](images/deflate-aarch64.svg)

<!-- claims of deflate-aarch64 -->

- gzip decoding, in multiples of libdeflate's speed: ahead on 31, level on 2, behind on 6 of 39 files; 0.92 to 1.71
- gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio: no other library's point is both faster and smaller than any of stdx's 3 levels

<!-- end of claims -->

![stdx's DEFLATE against its baselines, on Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz](images/deflate-x86_64.svg)

<!-- claims of deflate-x86_64 -->

- gzip decoding, in multiples of libdeflate's speed: ahead on 22, level on 6, behind on 11 of 39 files; 0.89 to 1.98
- gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio: no other library's point is both faster and smaller than any of stdx's 3 levels

<!-- end of claims -->

### Zstandard

`zig build bench-zstd -Doracles` times libzstd's decoder and stdx's over frames that libzstd
encodes at level 3. It also times both encoders, stdx at levels 1 and 3.

![stdx's Zstandard against its baselines, on Neoverse-N2](images/zstd-aarch64.svg)

<!-- claims of zstd-aarch64 -->

- Zstandard decoding, in multiples of libzstd's speed: ahead on 11, level on 3, behind on 25 of 39 files; 0.92 to 1.09
- Zstandard encoding: speed in multiples of libzstd's level 3, against compression ratio: 2 of stdx's 2 levels have a faster and smaller point: level 1 by libzstd 3; level 3 by libzstd 3

<!-- end of claims -->

![stdx's Zstandard against its baselines, on Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz](images/zstd-x86_64.svg)

<!-- claims of zstd-x86_64 -->

- Zstandard decoding, in multiples of libzstd's speed: ahead on 31, level on 4, behind on 4 of 39 files; 0.88 to 1.27
- Zstandard encoding: speed in multiples of libzstd's level 3, against compression ratio: 2 of stdx's 2 levels have a faster and smaller point: level 1 by libzstd 3; level 3 by libzstd 3

<!-- end of claims -->

### brotli

`zig build bench-brotli -Doracles` times Google's brotli decoder and stdx's over streams that
Google's encoder writes at quality 11. It also times both encoders, stdx at levels 1 and 5.

![stdx's brotli against its baselines, on Neoverse-N2](images/brotli-aarch64.svg)

<!-- claims of brotli-aarch64 -->

- brotli decoding, in multiples of Google's speed: ahead on 39, level on 0, behind on 0 of 39 files; 1.10 to 3.36
- brotli encoding: speed in multiples of Google's quality 5, against compression ratio: no other library's point is both faster and smaller than any of stdx's 2 levels

<!-- end of claims -->

![stdx's brotli against its baselines, on AMD EPYC 7763 64-Core Processor](images/brotli-x86_64.svg)

<!-- claims of brotli-x86_64 -->

- brotli decoding, in multiples of Google's speed: ahead on 38, level on 1, behind on 0 of 39 files; 1.03 to 3.32
- brotli encoding: speed in multiples of Google's quality 5, against compression ratio: no other library's point is both faster and smaller than any of stdx's 2 levels

<!-- end of claims -->

## JSON

`zig build bench-json -Doracles` times the `json` module's decoder and encoder beside simdjson,
yyjson, Zig's std.json, serde_json and Go's jsontext.

![stdx's JSON against its baselines, on Neoverse-N2](images/json-aarch64.svg)

<!-- claims of json-aarch64 -->

- JSON decoding, in multiples of simdjson's speed: ahead on 8, level on 0, behind on 1 of 9 rows (of 63 workloads, 1 behind); 0.87 to 5.36
- JSON encoding, in multiples of simdjson's speed: ahead on 7, level on 0, behind on 1 of 8 rows (of 62 workloads, 1 behind); 0.80 to 11.18
- TextWriter's methods, in multiples of serde\_json's speed: ahead on 8, level on 0, behind on 0 of 8 rows (of 62 workloads, 0 behind); 1.64 to 16.35

<!-- end of claims -->

![stdx's JSON against its baselines, on AMD EPYC 9V45 96-Core Processor](images/json-x86_64.svg)

<!-- claims of json-x86_64 -->

- JSON decoding, in multiples of simdjson's speed: ahead on 3, level on 1, behind on 5 of 9 rows (of 63 workloads, 5 behind); 0.63 to 4.09
- JSON encoding, in multiples of simdjson's speed: ahead on 5, level on 2, behind on 1 of 8 rows (of 62 workloads, 1 behind); 0.52 to 21.60
- TextWriter's methods, in multiples of serde\_json's speed: ahead on 8, level on 0, behind on 0 of 8 rows (of 62 workloads, 0 behind); 1.42 to 36.67

<!-- end of claims -->

## Checksums

`zig build bench-checksum -Doracles` times each CRC-32 and Adler-32 path the CPU runs beside zlib,
Wuffs, libdeflate and zlib-ng, and XXH64, from 64 octets to 1 MiB.

![stdx's checksums against its baselines, on Neoverse-N2](images/checksum-aarch64.svg)

<!-- claims of checksum-aarch64 -->

- CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 3, level on 0, behind on 1 of 4 sizes; 0.70 to 1.68
- Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 2, level on 0, behind on 2 of 4 sizes; 0.69 to 1.31
- XXH64 by octets a call, the path the CPU runs, in multiples of libzstd's speed: ahead on 1, level on 2, behind on 1 of 4 sizes; 0.86 to 1.04

<!-- end of claims -->

![stdx's checksums against its baselines, on AMD EPYC 7763 64-Core Processor](images/checksum-x86_64.svg)

<!-- claims of checksum-x86_64 -->

- CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 0, level on 2, behind on 2 of 4 sizes; 0.79 to 1.00
- Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 2, level on 0, behind on 2 of 4 sizes; 0.72 to 1.19
- XXH64 by octets a call, the path the CPU runs, in multiples of libzstd's speed: ahead on 0, level on 2, behind on 2 of 4 sizes; 0.82 to 1.00

<!-- end of claims -->

## Base 64

`zig build bench-base64 -Doracles` times base 64 encoding and decoding beside Rust's `base64`
crate, Go's encoding/base64 and Zig's std.base64, from 60 octets to 1 MiB.

![stdx's base64 against its baselines, on Neoverse-N2](images/base64-aarch64.svg)

<!-- claims of base64-aarch64 -->

- base64 encoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.84 to 1.19
- base64 decoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.82 to 1.70

<!-- end of claims -->

![stdx's base64 against its baselines, on AMD EPYC 7763 64-Core Processor](images/base64-x86_64.svg)

<!-- claims of base64-x86_64 -->

- base64 encoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 5, level on 0, behind on 0 of 5 sizes; 1.35 to 4.40
- base64 decoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.87 to 5.05

<!-- end of claims -->

## Regular expressions

`zig build bench-regex -Doracles` times the `regex` module beside Rust's regex crate 1.13.2, Go's
regexp, mvzr and zig-regex. Each library's answer must equal Go's before it is timed.

- Eighteen runs ran it at commit 1df5f9f (`bench/results/2026-11-24-regex-bytes-*`). The N2
  chart draws all 18 jobs. The x86-64 chart draws the 5 jobs on an AMD EPYC 9V45, the model that
  the most jobs drew. The other 13 jobs drew four other models.
- These patterns were written for this benchmark, and stdx was tuned on them. So they can favor
  stdx.
- From these runs on, stdx runs each pattern of rebar's sets that leaves `unicode` off in bytes
  (decision 86).

![stdx's regular expressions against libraries in Rust, Go and Zig, on Neoverse-N2](images/regex-aarch64.svg)

<!-- claims of regex-aarch64 -->

- search for a literal: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 5, level on 0, behind on 1 (1 inside 5%) of 6 rows, 5 patterns; geometric mean over these rows 1.40; from 0.990 to 3.79; against Go regexp: ahead on 5, level on 0, behind on 1 of 6; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search that starts with a class: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 5 (1 inside 5%), level on 0, behind on 0 of 5 rows, 4 patterns; geometric mean over these rows 1.41; from 1.047 to 2.41; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search of other shapes: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 7, level on 0, behind on 0 of 7 rows, 7 patterns; from 1.05 to 8.17; against Go regexp: ahead on 7, level on 0, behind on 0 of 7; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 4, level on 0, behind on 0 of 4
- a pattern that validates each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: ahead on 3, level on 1, behind on 1 (1 inside 5%) of 5 rows, 5 patterns; geometric mean over these rows 1.20; from 0.988 to 1.45; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 2, level on 0, behind on 0 of 2
- the capture groups of each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: behind, inside 5%, at 0.969, 0.964 to 0.977; against Go regexp: ahead on 1, level on 0, behind on 0 of 1; mvzr: no pattern timed; zig-regex: ahead on 1, level on 0, behind on 0 of 1
- a pattern compiled and made ready for its first search, in multiples of Rust regex's speed: against Rust regex: ahead on 23, level on 0, behind on 0 of 23 rows, 21 patterns; from 1.21 to 28.34; against Go regexp: ahead on 6, level on 5, behind on 12 of 23; mvzr: ahead on 0, level on 0, behind on 21 of 21; zig-regex: ahead on 1, level on 0, behind on 20 of 21

<!-- end of claims -->

![stdx's regular expressions against libraries in Rust, Go and Zig, on AMD EPYC 9V45 96-Core Processor](images/regex-x86_64.svg)

<!-- claims of regex-x86_64 -->

- search for a literal: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 6, level on 0, behind on 0 of 6 rows, 5 patterns; geometric mean over these rows 1.53; from 1.13 to 4.10; against Go regexp: ahead on 6, level on 0, behind on 0 of 6; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search that starts with a class: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 5, level on 0, behind on 0 of 5 rows, 4 patterns; geometric mean over these rows 1.36; from 1.06 to 2.32; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search of other shapes: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 6, level on 0, behind on 1 (1 inside 5%) of 7 rows, 7 patterns; from 0.982 to 10.63; against Go regexp: ahead on 7, level on 0, behind on 0 of 7; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 4, level on 0, behind on 0 of 4
- a pattern that validates each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: ahead on 5, level on 0, behind on 0 of 5 rows, 5 patterns; geometric mean over these rows 1.35; from 1.11 to 1.67; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 2, level on 0, behind on 0 of 2
- the capture groups of each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: behind, at 0.89, 0.88 to 0.94; against Go regexp: ahead on 1, level on 0, behind on 0 of 1; mvzr: no pattern timed; zig-regex: ahead on 1, level on 0, behind on 0 of 1
- a pattern compiled and made ready for its first search, in multiples of Rust regex's speed: against Rust regex: ahead on 23, level on 0, behind on 0 of 23 rows, 21 patterns; from 1.26 to 32.80; against Go regexp: ahead on 11, level on 0, behind on 12 of 23; mvzr: ahead on 0, level on 0, behind on 21 of 21; zig-regex: ahead on 1, level on 0, behind on 20 of 21

<!-- end of claims -->

### rebar's curated set

The same runs time every benchmark of rebar's curated set whose engines name Go's regexp or RE2.
That is 31 searches and 10 compiles, each under rebar's own model, pattern and haystack.

- rebar's author chose these benchmarks, not this benchmark's
  ([#44](https://github.com/c4milo/stdx/issues/44)).
- Design §8 part 22n then measured every row and changed stdx by what the rows showed. So this set
  is tuned now, as the set above is. It no longer shows how stdx runs on patterns that its tuning
  did not see.
- rebar's author also wrote Rust's regex crate, and rebar's `BIAS.md` says that the set can favor
  that crate.

![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on Neoverse-N2](images/regex-rebar-aarch64.svg)

<!-- claims of regex-rebar-aarch64 -->

- rebar's curated searches, in multiples of Rust regex's speed: against Rust regex: ahead on 25 (3 inside 5%), level on 0, behind on 6 (2 inside 5%) of 31 rows, 31 patterns; geometric mean over these rows 1.46; from 0.74 to 6.36; against Go regexp: ahead on 31, level on 0, behind on 0 of 31
- rebar's curated compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 10, level on 0, behind on 0 of 10 rows, 10 patterns; geometric mean over these rows 5.42; from 3.59 to 10.58; against Go regexp: ahead on 9, level on 0, behind on 1 of 10

<!-- end of claims -->

![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on AMD EPYC 9V45 96-Core Processor](images/regex-rebar-x86_64.svg)

<!-- claims of regex-rebar-x86_64 -->

- rebar's curated searches, in multiples of Rust regex's speed: against Rust regex: ahead on 27 (1 inside 5%), level on 0, behind on 4 (1 inside 5%) of 31 rows, 31 patterns; geometric mean over these rows 1.44; from 0.72 to 7.33; against Go regexp: ahead on 30, level on 1, behind on 0 of 31
- rebar's curated compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 10, level on 0, behind on 0 of 10 rows, 10 patterns; geometric mean over these rows 5.33; from 3.59 to 10.19; against Go regexp: ahead on 9, level on 0, behind on 1 of 10

<!-- end of claims -->

### rebar's other benchmarks

The same runs time every benchmark of rebar's definitions outside its curated set and its tests
whose engines name Go's regexp or RE2: 197 of them, each under rebar's own model, pattern and
haystack. The README draws this chart, by the owner's ruling of 2026-11-23 (decision 85).

- No work on stdx timed these rows, and no constant was chosen with one
  ([#44](https://github.com/c4milo/stdx/issues/44)).
- One change was made for one of them: the bytes mode, for the answer of
  `unicode/compile/match-every-line-ascii`. It was judged on that answer and on no speed.
- stdx gives no answer on `unicode/codepoints/letters-one`. stdx and Go's regexp count Unicode
  17.0.0's letters, and rebar's count comes from older tables.
- rebar's README says that these benchmarks mostly serve to make Rust's regex crate faster. So the
  set can favor that crate, and not stdx.

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on Neoverse-N2](images/regex-rebar-others-aarch64.svg)

<!-- claims of regex-rebar-others-aarch64 -->

- searches of rebar's imported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 50 (2 inside 5%), level on 0, behind on 56 (11 inside 5%) of 106 rows, 106 patterns; geometric mean over these rows 0.52; from 1/21504 to 102; against Go regexp: ahead on 101, level on 0, behind on 5 of 106
- searches of rebar's opt definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 12 (3 inside 5%), level on 0, behind on 14 (1 inside 5%) of 26 rows, 26 patterns; geometric mean over these rows 0.29; from 1/24551 to 8.98; against Go regexp: ahead on 24, level on 0, behind on 2 of 26
- searches of rebar's reported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 9, level on 0, behind on 3 of 12 rows, 12 patterns; geometric mean over these rows 11.80; from 0.32 to 915; against Go regexp: ahead on 9, level on 0, behind on 3 of 12
- searches of rebar's unicode definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 3, level on 1, behind on 5 (1 inside 5%) of 9 rows, 9 patterns; geometric mean over these rows 0.58; from 1/32 to 1.63; stdx gives no answer on 1: unicode/codepoints/letters-one; against Go regexp: ahead on 7, level on 0, behind on 2 of 9
- searches of rebar's wild definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 6, level on 1, behind on 8 (2 inside 5%) of 15 rows, 15 patterns; geometric mean over these rows 1.13; from 0.70 to 3.04; against Go regexp: ahead on 15, level on 0, behind on 0 of 15
- searches of rebar's other definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 8, level on 1, behind on 4 (1 inside 5%) of 13 rows, 13 patterns; geometric mean over these rows 1.06; from 1/158 to 39.06; against Go regexp: ahead on 11, level on 0, behind on 1 of 12
- rebar's other compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 15, level on 0, behind on 0 of 15 rows, 15 patterns; geometric mean over these rows 5.29; from 1.47 to 16.44; against Go regexp: ahead on 6, level on 0, behind on 9 of 15

<!-- end of claims -->

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on AMD EPYC 9V45 96-Core Processor](images/regex-rebar-others-x86_64.svg)

<!-- claims of regex-rebar-others-x86_64 -->

- searches of rebar's imported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 45 (4 inside 5%), level on 10, unclear on 2, behind on 49 (1 inside 5%) of 106 rows, 106 patterns; geometric mean over these rows 0.46; from 1/36495 to 246; against Go regexp: ahead on 102, level on 0, behind on 4 of 106
- searches of rebar's opt definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 11 (1 inside 5%), level on 2, unclear on 1, behind on 12 of 26 rows, 26 patterns; geometric mean over these rows 0.27; from 1/18904 to 9.44; against Go regexp: ahead on 24, level on 0, behind on 2 of 26
- searches of rebar's reported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 8, level on 1, behind on 3 of 12 rows, 12 patterns; geometric mean over these rows 12.64; from 0.43 to 1002; against Go regexp: ahead on 9, level on 0, behind on 3 of 12
- searches of rebar's unicode definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 3 (1 inside 5%), level on 2, behind on 4 of 9 rows, 9 patterns; geometric mean over these rows 0.52; from 1/91 to 1.39; stdx gives no answer on 1: unicode/codepoints/letters-one; against Go regexp: ahead on 7, level on 0, behind on 2 of 9
- searches of rebar's wild definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 6, level on 1, behind on 8 (1 inside 5%) of 15 rows, 15 patterns; geometric mean over these rows 1.21; from 0.79 to 4.44; against Go regexp: ahead on 15, level on 0, behind on 0 of 15
- searches of rebar's other definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 10 (1 inside 5%), level on 0, behind on 3 of 13 rows, 13 patterns; geometric mean over these rows 1.10; from 1/135 to 42.43; against Go regexp: ahead on 12, level on 0, behind on 1 of 13
- rebar's other compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 15, level on 0, behind on 0 of 15 rows, 15 patterns; geometric mean over these rows 5.43; from 1.32 to 17.32; against Go regexp: ahead on 7, level on 0, behind on 8 of 15

<!-- end of claims -->

## Run a benchmark again

1. Run `zig build bench-<name> -Doracles` on a Linux host. The first build with `-Doracles`
   fetches about 265 MB of other libraries and corpora. `bench-json`, `bench-base64` and
   `bench-regex` need cargo and go on the path too.
2. Or start the `bench` workflow on GitHub, which runs on both hosted runners. Its `base` input
   names a commit to time first in the same job, for an A/B on one CPU.
3. Commit each report the workflow writes under `bench/results/`.
4. Name the reports in `bench/charts.txt`, then run `python3 tools/charts.py`. It draws the charts
   again and writes the lists on this page.

[`CLAUDE.md`](../CLAUDE.md) says what each benchmark times, and
[`docs/performance.md`](performance.md) holds the method.
