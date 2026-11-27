# stdx's benchmarks at v0.4.0

The bench workflow drew these charts from the jobs of [its run](https://github.com/c4milo/stdx/actions/runs/45895089065) for v0.4.0. Each chart marks the rows that changed since v0.3.0, which the same jobs measured first. [docs/benchmarks.md](https://github.com/c4milo/stdx/blob/main/docs/benchmarks.md) says how to read them and how to run each benchmark again.

## stdx's DEFLATE against its baselines, on Neoverse-N2

![stdx's DEFLATE against its baselines, on Neoverse-N2](deflate-aarch64.svg)

- gzip decoding, in multiples of libdeflate's speed: ahead on 34, level on 2, behind on 3 of 39 files; 0.95 to 1.70
- gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio: no other library's point is both faster and smaller than any of stdx's 3 levels

Since v0.3.0: 3 rows faster and 0 slower by 5% or more, of 42.

| Panel | Row | Change |
| --- | --- | --- |
| gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio | stdx level 1 | ▲ 10% faster |
| gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio | stdx level 6 | ▲ 11% faster |
| gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio | stdx level 9 | ▲ 11% faster |

## stdx's DEFLATE against its baselines, on INTEL(R) XEON(R) PLATINUM 8573C

![stdx's DEFLATE against its baselines, on INTEL(R) XEON(R) PLATINUM 8573C](deflate-x86_64.svg)

- gzip decoding, in multiples of libdeflate's speed: ahead on 17, level on 7, behind on 15 of 39 files; 0.90 to 1.85
- gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio: no other library's point is both faster and smaller than any of stdx's 3 levels

Since v0.3.0: 0 rows faster and 5 slower by 5% or more, of 42.

| Panel | Row | Change |
| --- | --- | --- |
| gzip decoding, in multiples of libdeflate's speed | canterbury/xargs.1 | ▼ 5% slower |
| gzip decoding, in multiples of libdeflate's speed | http/html-1kx1024 | ▼ 6% slower |
| gzip decoding, in multiples of libdeflate's speed | http/json-1kx1024 | ▼ 6% slower |
| gzip decoding, in multiples of libdeflate's speed | http/js-1kx1024 | ▼ 6% slower |
| gzip decoding, in multiples of libdeflate's speed | http/css-1kx1024 | ▼ 7% slower |

## stdx's Zstandard against its baselines, on Neoverse-N2

![stdx's Zstandard against its baselines, on Neoverse-N2](zstd-aarch64.svg)

- Zstandard decoding, in multiples of libzstd's speed: ahead on 10, level on 6, behind on 23 of 39 files; 0.92 to 1.10
- Zstandard encoding: speed in multiples of libzstd's level 3, against compression ratio: 2 of stdx's 2 levels have a faster and smaller point: level 1 by libzstd 3; level 3 by libzstd 3

Since v0.3.0: 0 rows faster and 0 slower by 5% or more, of 41.

## stdx's Zstandard against its baselines, on Intel(R) Xeon(R) 6975P-C

![stdx's Zstandard against its baselines, on Intel(R) Xeon(R) 6975P-C](zstd-x86_64.svg)

- Zstandard decoding, in multiples of libzstd's speed: ahead on 32, level on 6, behind on 1 of 39 files; 0.92 to 1.30
- Zstandard encoding: speed in multiples of libzstd's level 3, against compression ratio: 2 of stdx's 2 levels have a faster and smaller point: level 1 by libzstd 3; level 3 by libzstd 3

Since v0.3.0: 2 rows faster and 0 slower by 5% or more, of 41.

| Panel | Row | Change |
| --- | --- | --- |
| Zstandard decoding, in multiples of libzstd's speed | silesia/dickens | ▲ 5% faster |
| Zstandard decoding, in multiples of libzstd's speed | silesia/mr | ▲ 7% faster |

## stdx's brotli against its baselines, on Neoverse-N2

![stdx's brotli against its baselines, on Neoverse-N2](brotli-aarch64.svg)

- brotli decoding, in multiples of Google's speed: ahead on 39, level on 0, behind on 0 of 39 files; 1.09 to 3.36
- brotli encoding: speed in multiples of Google's quality 5, against compression ratio: no other library's point is both faster and smaller than any of stdx's 2 levels

Since v0.3.0: 0 rows faster and 0 slower by 5% or more, of 41.

## stdx's brotli against its baselines, on AMD EPYC 7763 64-Core Processor

![stdx's brotli against its baselines, on AMD EPYC 7763 64-Core Processor](brotli-x86_64.svg)

- brotli decoding, in multiples of Google's speed: ahead on 39, level on 0, behind on 0 of 39 files; 1.03 to 3.35
- brotli encoding: speed in multiples of Google's quality 5, against compression ratio: no other library's point is both faster and smaller than any of stdx's 2 levels

Since v0.3.0: 1 rows faster and 0 slower by 5% or more, of 41.

| Panel | Row | Change |
| --- | --- | --- |
| brotli decoding, in multiples of Google's speed | canterbury/fields.c | ▲ 7% faster |

## stdx's JSON against its baselines, on Neoverse-N2

![stdx's JSON against its baselines, on Neoverse-N2](json-aarch64.svg)

- JSON decoding, in multiples of simdjson's speed: ahead on 8, level on 0, behind on 1 of 9 rows (of 63 workloads, 1 behind); 0.86 to 5.34
- JSON encoding, in multiples of simdjson's speed: ahead on 7, level on 0, behind on 1 of 8 rows (of 62 workloads, 1 behind); 0.78 to 11.16
- TextWriter's methods, in multiples of serde_json's speed: ahead on 8, level on 0, behind on 0 of 8 rows (of 62 workloads, 0 behind); 1.63 to 16.33

Since v0.3.0: 0 rows faster and 0 slower by 5% or more, of 25.

## stdx's JSON against its baselines, on AMD EPYC 9V45 96-Core Processor

![stdx's JSON against its baselines, on AMD EPYC 9V45 96-Core Processor](json-x86_64.svg)

- JSON decoding, in multiples of simdjson's speed: ahead on 3, level on 2, behind on 4 of 9 rows (of 63 workloads, 4 behind); 0.63 to 4.24
- JSON encoding, in multiples of simdjson's speed: ahead on 4, level on 3, behind on 1 of 8 rows (of 62 workloads, 1 behind); 0.50 to 21.90
- TextWriter's methods, in multiples of serde_json's speed: ahead on 8, level on 0, behind on 0 of 8 rows (of 62 workloads, 0 behind); 1.24 to 36.81

Since v0.3.0: 0 rows faster and 0 slower by 5% or more, of 25.

## stdx's checksums against its baselines, on Neoverse-N2

![stdx's checksums against its baselines, on Neoverse-N2](checksum-aarch64.svg)

- CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 3, level on 0, behind on 1 of 4 sizes; 0.68 to 1.68
- Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 2, level on 0, behind on 2 of 4 sizes; 0.67 to 1.31
- XXH64 by octets a call, the path the CPU runs, in multiples of libzstd's speed: ahead on 1, level on 2, behind on 1 of 4 sizes; 0.86 to 1.02

Since v0.3.0: 0 rows faster and 1 slower by 5% or more, of 12.

| Panel | Row | Change |
| --- | --- | --- |
| CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed | 64 | ▼ 6% slower |

## stdx's checksums against its baselines, on AMD EPYC 7763 64-Core Processor

![stdx's checksums against its baselines, on AMD EPYC 7763 64-Core Processor](checksum-x86_64.svg)

- CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 0, level on 2, behind on 2 of 4 sizes; 0.79 to 1.00
- Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 2, level on 0, behind on 2 of 4 sizes; 0.71 to 1.18
- XXH64 by octets a call, the path the CPU runs, in multiples of libzstd's speed: ahead on 0, level on 2, behind on 2 of 4 sizes; 0.85 to 1.00

Since v0.3.0: 1 rows faster and 0 slower by 5% or more, of 12.

| Panel | Row | Change |
| --- | --- | --- |
| Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed | 1024 | ▲ 6% faster |

## stdx's base64 against its baselines, on Neoverse-N2

![stdx's base64 against its baselines, on Neoverse-N2](base64-aarch64.svg)

- base64 encoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.85 to 1.19
- base64 decoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.84 to 1.70

Since v0.3.0: 0 rows faster and 0 slower by 5% or more, of 10.

## stdx's base64 against its baselines, on AMD EPYC 7763 64-Core Processor

![stdx's base64 against its baselines, on AMD EPYC 7763 64-Core Processor](base64-x86_64.svg)

- base64 encoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 5, level on 0, behind on 0 of 5 sizes; 1.27 to 4.42
- base64 decoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.85 to 5.06

Since v0.3.0: 0 rows faster and 0 slower by 5% or more, of 10.

## stdx's regular expressions against libraries in Rust, Go and Zig, on Neoverse-N2

![stdx's regular expressions against libraries in Rust, Go and Zig, on Neoverse-N2](regex-aarch64.svg)

- search for a literal: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 5, level on 0, behind on 1 (1 inside 5%) of 6 rows, 5 patterns; geometric mean over these rows 1.41; from 0.991 to 3.82; against Go regexp: ahead on 5, level on 0, behind on 1 of 6; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search that starts with a class: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 5 (1 inside 5%), level on 0, behind on 0 of 5 rows, 4 patterns; geometric mean over these rows 1.57; from 1.048 to 2.68; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search of other shapes: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 7, level on 0, behind on 0 of 7 rows, 7 patterns; from 1.10 to 8.27; against Go regexp: ahead on 7, level on 0, behind on 0 of 7; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 4, level on 0, behind on 0 of 4
- a pattern that validates each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: ahead on 5, level on 0, behind on 0 of 5 rows, 5 patterns; geometric mean over these rows 1.49; from 1.32 to 1.63; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 2, level on 0, behind on 0 of 2
- the capture groups of each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: behind, inside 5%, at 0.978, 0.971 to 0.981; against Go regexp: ahead on 1, level on 0, behind on 0 of 1; mvzr: no pattern timed; zig-regex: ahead on 1, level on 0, behind on 0 of 1
- a pattern compiled and made ready for its first search, in multiples of Rust regex's speed: against Rust regex: ahead on 23, level on 0, behind on 0 of 23 rows, 21 patterns; from 1.17 to 27.77; against Go regexp: ahead on 6 (1 inside 5%), level on 2, behind on 15 of 23; mvzr: ahead on 0, level on 0, behind on 21 of 21; zig-regex: ahead on 1, level on 0, behind on 20 of 21

Since v0.3.0: 11 rows faster and 0 slower by 5% or more, of 47.

| Panel | Row | Change |
| --- | --- | --- |
| search that starts with a class: every match in 1 MiB | two capitalized words | ▲ 10% faster |
| search that starts with a class: every match in 1 MiB | a word in capitals | ▲ 11% faster |
| search that starts with a class: every match in 1 MiB | a number | ▲ 35% faster |
| search of other shapes: every match in 1 MiB | a number before a unit, second text | ▲ 6% faster |
| search of other shapes: every match in 1 MiB | a Greek word | ▲ 6% faster |
| a pattern that validates each of 65,536 short texts | an email address | ▲ 51% faster |
| a pattern that validates each of 65,536 short texts | a UUID | ▲ 17% faster |
| a pattern that validates each of 65,536 short texts | an IPv4 address | ▲ 7% faster |
| a pattern that validates each of 65,536 short texts | a date and time | ▲ 10% faster |
| a pattern that validates each of 65,536 short texts | a field path | ▲ 41% faster |
| a pattern compiled and made ready for its first search | a Greek word | ▲ 8% faster |

## stdx's regular expressions against libraries in Rust, Go and Zig, on AMD EPYC 9V74 80-Core Processor

![stdx's regular expressions against libraries in Rust, Go and Zig, on AMD EPYC 9V74 80-Core Processor](regex-x86_64.svg)

- search for a literal: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 6, level on 0, behind on 0 of 6 rows, 5 patterns; geometric mean over these rows 1.51; from 1.17 to 3.53; against Go regexp: ahead on 6, level on 0, behind on 0 of 6; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search that starts with a class: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 5, level on 0, behind on 0 of 5 rows, 4 patterns; geometric mean over these rows 1.64; from 1.08 to 2.78; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 5, level on 0, behind on 0 of 5
- search of other shapes: every match in 1 MiB, in multiples of Rust regex's speed: against Rust regex: ahead on 7, level on 0, behind on 0 of 7 rows, 7 patterns; from 1.048 to 10.03; against Go regexp: ahead on 7, level on 0, behind on 0 of 7; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 4, level on 0, behind on 0 of 4
- a pattern that validates each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: ahead on 5, level on 0, behind on 0 of 5 rows, 5 patterns; geometric mean over these rows 1.60; from 1.40 to 1.84; against Go regexp: ahead on 5, level on 0, behind on 0 of 5; mvzr: ahead on 5, level on 0, behind on 0 of 5; zig-regex: ahead on 2, level on 0, behind on 0 of 2
- the capture groups of each of 65,536 short texts, in multiples of Rust regex's speed: against Rust regex: behind, at 0.81, 0.79 to 0.82; against Go regexp: ahead on 1, level on 0, behind on 0 of 1; mvzr: no pattern timed; zig-regex: ahead on 1, level on 0, behind on 0 of 1
- a pattern compiled and made ready for its first search, in multiples of Rust regex's speed: against Rust regex: ahead on 23, level on 0, behind on 0 of 23 rows, 21 patterns; from 1.13 to 26.02; against Go regexp: ahead on 4, level on 0, unclear on 4, behind on 15 of 23; mvzr: ahead on 0, level on 0, behind on 21 of 21; zig-regex: ahead on 1, level on 0, behind on 20 of 21

Since v0.3.0: 8 rows faster and 4 slower by 5% or more, of 47.

| Panel | Row | Change |
| --- | --- | --- |
| search for a literal: every match in 1 MiB | a word | ▼ 7% slower |
| search for a literal: every match in 1 MiB | a word in any case | ▼ 6% slower |
| search that starts with a class: every match in 1 MiB | two capitalized words | ▲ 27% faster |
| search that starts with a class: every match in 1 MiB | a word in capitals | ▲ 38% faster |
| search that starts with a class: every match in 1 MiB | a number | ▲ 77% faster |
| search of other shapes: every match in 1 MiB | a line's first word, second text | ▼ 7% slower |
| search of other shapes: every match in 1 MiB | fourteen octets before an x | ▼ 7% slower |
| search of other shapes: every match in 1 MiB | a Greek word | ▲ 24% faster |
| a pattern that validates each of 65,536 short texts | an email address | ▲ 47% faster |
| a pattern that validates each of 65,536 short texts | a UUID | ▲ 15% faster |
| a pattern that validates each of 65,536 short texts | a date and time | ▲ 6% faster |
| a pattern that validates each of 65,536 short texts | a field path | ▲ 34% faster |

## stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on Neoverse-N2

![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on Neoverse-N2](regex-rebar-aarch64.svg)

- rebar's curated searches, in multiples of Rust regex's speed: against Rust regex: ahead on 24 (2 inside 5%), level on 1, behind on 6 (2 inside 5%) of 31 rows, 31 patterns; geometric mean over these rows 1.53; from 0.75 to 10.19; against Go regexp: ahead on 31, level on 0, behind on 0 of 31
- rebar's curated compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 10, level on 0, behind on 0 of 10 rows, 10 patterns; geometric mean over these rows 5.45; from 3.63 to 10.54; against Go regexp: ahead on 9, level on 0, behind on 1 of 10

Since v0.3.0: 10 rows faster and 0 slower by 5% or more, of 41.

| Panel | Row | Change |
| --- | --- | --- |
| rebar's curated searches | 03-date/ascii | ▲ 8% faster |
| rebar's curated searches | 04-ruff-noqa/real | ▲ 9% faster |
| rebar's curated searches | 04-ruff-noqa/tweaked | ▲ 51% faster |
| rebar's curated searches | 06-cloud-flare-redos/original | ▲ 6% faster |
| rebar's curated searches | 06-cloud-flare-redos/simplified-short | ▲ 5% faster |
| rebar's curated searches | 06-cloud-flare-redos/simplified-long | ▲ 7% faster |
| rebar's curated searches | 08-words/all-english | ▲ 11% faster |
| rebar's curated searches | 09-aws-keys/full | ▲ 8% faster |
| rebar's curated searches | 14-quadratic/2x | ▲ 14% faster |
| rebar's curated searches | 14-quadratic/10x | ▲ 60% faster |

## stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on AMD EPYC 9V74 80-Core Processor

![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on AMD EPYC 9V74 80-Core Processor](regex-rebar-x86_64.svg)

- rebar's curated searches, in multiples of Rust regex's speed: against Rust regex: ahead on 27 (1 inside 5%), level on 1, behind on 3 of 31 rows, 31 patterns; geometric mean over these rows 1.53; from 0.65 to 12.34; against Go regexp: ahead on 31 (1 inside 5%), level on 0, behind on 0 of 31
- rebar's curated compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 10, level on 0, behind on 0 of 10 rows, 10 patterns; geometric mean over these rows 4.68; from 2.89 to 8.88; against Go regexp: ahead on 9, level on 0, behind on 1 of 10

Since v0.3.0: 9 rows faster and 3 slower by 5% or more, of 41.

| Panel | Row | Change |
| --- | --- | --- |
| rebar's curated searches | 01-literal/sherlock-en | ▼ 9% slower |
| rebar's curated searches | 01-literal/sherlock-casei-en | ▼ 7% slower |
| rebar's curated searches | 01-literal/sherlock-ru | ▼ 8% slower |
| rebar's curated searches | 03-date/ascii | ▲ 14% faster |
| rebar's curated searches | 04-ruff-noqa/tweaked | ▲ 44% faster |
| rebar's curated searches | 06-cloud-flare-redos/original | ▲ 11% faster |
| rebar's curated searches | 06-cloud-flare-redos/simplified-short | ▲ 14% faster |
| rebar's curated searches | 06-cloud-flare-redos/simplified-long | ▲ 16% faster |
| rebar's curated searches | 08-words/all-english | ▲ 18% faster |
| rebar's curated searches | 14-quadratic/1x | ▲ 9% faster |
| rebar's curated searches | 14-quadratic/2x | ▲ 29% faster |
| rebar's curated searches | 14-quadratic/10x | ▲ 2.2× faster |

## stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on Neoverse-N2

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on Neoverse-N2](regex-rebar-others-aarch64.svg)

- searches of rebar's imported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 83 (4 inside 5%), level on 1, behind on 22 (5 inside 5%) of 106 rows, 106 patterns; geometric mean over these rows 1.38; from 0.58 to 102; against Go regexp: ahead on 104, level on 0, behind on 2 of 106
- searches of rebar's opt definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 15 (3 inside 5%), level on 0, behind on 11 (1 inside 5%) of 26 rows, 26 patterns; geometric mean over these rows 1.35; from 0.45 to 34.30; against Go regexp: ahead on 26, level on 0, behind on 0 of 26
- searches of rebar's reported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 9, level on 0, behind on 3 of 12 rows, 12 patterns; geometric mean over these rows 11.91; from 0.32 to 915; against Go regexp: ahead on 9, level on 0, behind on 3 of 12
- searches of rebar's unicode definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 5 (2 inside 5%), level on 0, behind on 4 (1 inside 5%) of 9 rows, 9 patterns; geometric mean over these rows 0.87; from 0.33 to 1.60; stdx gives no answer on 1: unicode/codepoints/letters-one; against Go regexp: ahead on 7, level on 0, behind on 2 of 9
- searches of rebar's wild definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 8, level on 1, behind on 6 (2 inside 5%) of 15 rows, 15 patterns; geometric mean over these rows 1.38; from 0.70 to 3.13; against Go regexp: ahead on 15, level on 0, behind on 0 of 15
- searches of rebar's other definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 9, level on 1, behind on 3 (1 inside 5%) of 13 rows, 13 patterns; geometric mean over these rows 1.79; from 0.63 to 150; against Go regexp: ahead on 11, level on 0, behind on 1 of 12
- rebar's other compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 15, level on 0, behind on 0 of 15 rows, 15 patterns; geometric mean over these rows 5.32; from 1.47 to 16.57; against Go regexp: ahead on 6, level on 0, behind on 9 of 15

Since v0.3.0: 75 rows faster and 2 slower by 5% or more, of 196.

| Panel | Row | Change |
| --- | --- | --- |
| searches of rebar's imported definitions | imported/leipzig/shing | ▲ 24× faster |
| searches of rebar's imported definitions | imported/leipzig/tom-sawyer-huckle-fin-prefix-short | ▲ 12× faster |
| searches of rebar's imported definitions | imported/leipzig/tom-sawyer-huckle-fin-prefix-long | ▲ 12× faster |
| searches of rebar's imported definitions | imported/leipzig/ing-whitespace | ▲ 2.5× faster |
| searches of rebar's imported definitions | imported/leipzig/awyer-inn | ▲ 8.2× faster |
| searches of rebar's imported definitions | imported/leipzig/quotes-bounded | ▲ 17% faster |
| searches of rebar's imported definitions | imported/leipzig/bounded-strings-ending-z | ▲ 6% faster |
| searches of rebar's imported definitions | imported/lh3lh3-reb/uri | ▲ 7% faster |
| searches of rebar's imported definitions | imported/mariomka/email | ▲ 34× faster |
| searches of rebar's imported definitions | imported/mariomka/uri | ▲ 9.1× faster |
| searches of rebar's imported definitions | imported/mariomka/ip | ▲ 21% faster |
| searches of rebar's imported definitions | imported/rsc/no-exponential | ▲ 8% faster |
| searches of rebar's imported definitions | imported/rsc/literal | ▲ 2.0× faster |
| searches of rebar's imported definitions | imported/rsc/not-literal | ▲ 8% faster |
| searches of rebar's imported definitions | imported/rsc/match-class | ▲ 12% faster |
| searches of rebar's imported definitions | imported/rsc/match-class-in-range | ▲ 12% faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-short-non-match | ▲ 2.7× faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-long-non-match | ▲ 2.7× faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-short-match | ▲ 72% faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-long-match | ▲ 3.6× faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-short | ▲ 18% faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-short-not | ▲ 23% faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-long-prefix | ▲ 52% faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-long-prefix-not | ▲ 15% faster |
| searches of rebar's imported definitions | imported/rsc/easy0-32 | ▲ 50% faster |
| searches of rebar's imported definitions | imported/rsc/easy0-1k | ▼ 10% slower |
| searches of rebar's imported definitions | imported/rsc/easy1-32 | ▲ 2.1× faster |
| searches of rebar's imported definitions | imported/rsc/easy1-1k | ▲ 27× faster |
| searches of rebar's imported definitions | imported/rsc/easy1-32k | ▲ 811× faster |
| searches of rebar's imported definitions | imported/rsc/easy1-1mb | ▲ 26,390× faster |
| searches of rebar's imported definitions | imported/rsc/medium-32 | ▲ 74% faster |
| searches of rebar's imported definitions | imported/rsc/medium-1k | ▲ 93% faster |
| searches of rebar's imported definitions | imported/rsc/medium-32k | ▲ 19× faster |
| searches of rebar's imported definitions | imported/rsc/medium-1mb | ▲ 614× faster |
| searches of rebar's imported definitions | imported/rsc/hard-32 | ▲ 66% faster |
| searches of rebar's imported definitions | imported/rsc/hard-1k | ▲ 22× faster |
| searches of rebar's imported definitions | imported/rsc/hard-32k | ▲ 664× faster |
| searches of rebar's imported definitions | imported/rsc/hard-1mb | ▲ 13,930× faster |
| searches of rebar's imported definitions | imported/rsc/reallyhard0-1mb | ▲ 5% faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyhard0-1k | ▲ 8.2× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyhard0-32k | ▲ 34× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyhard0-1mb | ▲ 37× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyreallyhard0-1k | ▲ 7.0× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyreallyhard0-32k | ▲ 34× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyreallyhard0-1mb | ▲ 36× faster |
| searches of rebar's imported definitions | imported/sherlock/everything-greedy-nl | ▲ 7% faster |
| searches of rebar's imported definitions | imported/sherlock/letters | ▲ 13% faster |
| searches of rebar's imported definitions | imported/sherlock/letters-lower | ▲ 13% faster |
| searches of rebar's imported definitions | imported/sherlock/words | ▲ 5% faster |
| searches of rebar's imported definitions | imported/sherlock/before-holmes | ▲ 17× faster |
| searches of rebar's imported definitions | imported/sherlock/before-after-holmes | ▲ 17× faster |
| searches of rebar's imported definitions | imported/sherlock/holmes-coword-watson | ▼ 9% slower |
| searches of rebar's imported definitions | imported/sherlock/quotes | ▲ 11% faster |
| searches of rebar's imported definitions | imported/sherlock/line-boundary-sherlock-holmes | ▲ 29× faster |
| searches of rebar's imported definitions | imported/sherlock/ing-suffix-limited-space | ▲ 2.8× faster |
| searches of rebar's opt definitions | opt/fixed-length/too-big-ascii | ▲ 5.3× faster |
| searches of rebar's opt definitions | opt/fixed-length/go33484-1 | ▲ 14,597× faster |
| searches of rebar's opt definitions | opt/fixed-length/go33484-2 | ▲ 119× faster |
| searches of rebar's opt definitions | opt/fixed-length/go33484-3 | ▲ 37× faster |
| searches of rebar's opt definitions | opt/onepass/first-three-words-english | ▲ 21% faster |
| searches of rebar's opt definitions | opt/reverse-anchored/word-end | ▲ 5,260× faster |
| searches of rebar's opt definitions | opt/reverse-inner/holmes | ▲ 17× faster |
| searches of rebar's opt definitions | opt/reverse-inner/email | ▲ 35× faster |
| searches of rebar's opt definitions | opt/reverse-inner/no-quadratic-backward | ▲ 3.8× faster |
| searches of rebar's opt definitions | opt/reverse-inner/no-quadratic-forward | ▲ 6% faster |
| searches of rebar's opt definitions | opt/reverse-suffix/holmes | ▲ 17× faster |
| searches of rebar's opt definitions | opt/reverse-suffix/no-quadratic | ▲ 3.8× faster |
| searches of rebar's unicode definitions | unicode/word/boundary-any-english | ▲ 10% faster |
| searches of rebar's unicode definitions | unicode/word/around-holmes-english | ▲ 33× faster |
| searches of rebar's wild definitions | wild/bibleref/line | ▲ 11% faster |
| searches of rebar's wild definitions | wild/ruff/noqa | ▲ 9% faster |
| searches of rebar's wild definitions | wild/ruff/unnecessary-coding-comment | ▲ 96% faster |
| searches of rebar's wild definitions | wild/ruff/string-quote-prefix | ▲ 3.2× faster |
| searches of rebar's wild definitions | wild/ruff/shebang | ▲ 2.4× faster |
| searches of rebar's other definitions | dictionary/search/english-10 | ▲ 197× faster |
| searches of rebar's other definitions | folly/awyer-inn-busted | ▲ 3.9× faster |
| searches of rebar's other definitions | slow/quadratic-haystack-2x | ▲ 13% faster |

## stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on AMD EPYC 9V74 80-Core Processor

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on AMD EPYC 9V74 80-Core Processor](regex-rebar-others-x86_64.svg)

- searches of rebar's imported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 82 (7 inside 5%), level on 2, behind on 22 (3 inside 5%) of 106 rows, 106 patterns; geometric mean over these rows 1.40; from 0.56 to 297; against Go regexp: ahead on 105, level on 0, behind on 1 (1 inside 5%) of 106
- searches of rebar's opt definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 16 (3 inside 5%), level on 0, behind on 10 of 26 rows, 26 patterns; geometric mean over these rows 1.42; from 0.55 to 38.52; against Go regexp: ahead on 26, level on 0, behind on 0 of 26
- searches of rebar's reported definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 9, level on 0, behind on 3 of 12 rows, 12 patterns; geometric mean over these rows 13.70; from 0.46 to 1047; against Go regexp: ahead on 9, level on 0, behind on 3 of 12
- searches of rebar's unicode definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 6 (2 inside 5%), level on 0, behind on 3 of 9 rows, 9 patterns; geometric mean over these rows 0.93; from 0.43 to 1.60; stdx gives no answer on 1: unicode/codepoints/letters-one; against Go regexp: ahead on 7, level on 0, behind on 2 of 9
- searches of rebar's wild definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 8 (1 inside 5%), level on 1, behind on 6 (2 inside 5%) of 15 rows, 15 patterns; geometric mean over these rows 1.39; from 0.70 to 3.59; against Go regexp: ahead on 15, level on 0, behind on 0 of 15
- searches of rebar's other definitions, in multiples of Rust regex's speed: against Rust regex: ahead on 11, level on 0, behind on 2 of 13 rows, 13 patterns; geometric mean over these rows 1.89; from 0.62 to 182; against Go regexp: ahead on 12, level on 0, behind on 1 (1 inside 5%) of 13
- rebar's other compiles, in multiples of Rust regex's speed: against Rust regex: ahead on 15, level on 0, behind on 0 of 15 rows, 15 patterns; geometric mean over these rows 4.63; from 1.20 to 16.95; against Go regexp: ahead on 5, level on 0, behind on 10 of 15

Since v0.3.0: 82 rows faster and 16 slower by 5% or more, of 196.

| Panel | Row | Change |
| --- | --- | --- |
| searches of rebar's imported definitions | imported/leipzig/shing | ▲ 46× faster |
| searches of rebar's imported definitions | imported/leipzig/certain-long-strings-ending-x | ▼ 9% slower |
| searches of rebar's imported definitions | imported/leipzig/tom-sawyer-huckle-fin-prefix-short | ▲ 30× faster |
| searches of rebar's imported definitions | imported/leipzig/tom-sawyer-huckle-fin-prefix-long | ▲ 28× faster |
| searches of rebar's imported definitions | imported/leipzig/ing-whitespace | ▲ 2.6× faster |
| searches of rebar's imported definitions | imported/leipzig/awyer-inn | ▲ 14× faster |
| searches of rebar's imported definitions | imported/leipzig/quotes-bounded | ▲ 25% faster |
| searches of rebar's imported definitions | imported/lh3lh3-reb/uri | ▲ 11% faster |
| searches of rebar's imported definitions | imported/mariomka/email | ▲ 56× faster |
| searches of rebar's imported definitions | imported/mariomka/uri | ▲ 11× faster |
| searches of rebar's imported definitions | imported/mariomka/ip | ▲ 40% faster |
| searches of rebar's imported definitions | imported/rsc/no-exponential | ▲ 8% faster |
| searches of rebar's imported definitions | imported/rsc/literal | ▲ 2.1× faster |
| searches of rebar's imported definitions | imported/rsc/not-literal | ▲ 19% faster |
| searches of rebar's imported definitions | imported/rsc/match-class | ▲ 34% faster |
| searches of rebar's imported definitions | imported/rsc/match-class-in-range | ▲ 34% faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-short-non-match | ▲ 2.5× faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-long-non-match | ▲ 2.3× faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-short-match | ▲ 60% faster |
| searches of rebar's imported definitions | imported/rsc/anchored-literal-long-match | ▲ 4.5× faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-short | ▲ 31% faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-short-not | ▲ 34% faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-long-prefix | ▲ 76% faster |
| searches of rebar's imported definitions | imported/rsc/one-pass-long-prefix-not | ▲ 17% faster |
| searches of rebar's imported definitions | imported/rsc/easy0-32 | ▲ 58% faster |
| searches of rebar's imported definitions | imported/rsc/easy0-1k | ▼ 22% slower |
| searches of rebar's imported definitions | imported/rsc/easy1-32 | ▲ 2.4× faster |
| searches of rebar's imported definitions | imported/rsc/easy1-1k | ▲ 32× faster |
| searches of rebar's imported definitions | imported/rsc/easy1-32k | ▲ 976× faster |
| searches of rebar's imported definitions | imported/rsc/easy1-1mb | ▲ 31,104× faster |
| searches of rebar's imported definitions | imported/rsc/medium-32 | ▲ 84% faster |
| searches of rebar's imported definitions | imported/rsc/medium-1k | ▲ 99% faster |
| searches of rebar's imported definitions | imported/rsc/medium-32k | ▲ 9.2× faster |
| searches of rebar's imported definitions | imported/rsc/medium-1mb | ▲ 241× faster |
| searches of rebar's imported definitions | imported/rsc/hard-32 | ▲ 68% faster |
| searches of rebar's imported definitions | imported/rsc/hard-1k | ▲ 25× faster |
| searches of rebar's imported definitions | imported/rsc/hard-32k | ▲ 765× faster |
| searches of rebar's imported definitions | imported/rsc/hard-1mb | ▲ 14,719× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyhard0-1k | ▲ 8.8× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyhard0-32k | ▲ 82× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyhard0-1mb | ▲ 116× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyreallyhard0-1k | ▲ 7.5× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyreallyhard0-32k | ▲ 76× faster |
| searches of rebar's imported definitions | imported/rsc/reallyreallyreallyhard0-1mb | ▲ 104× faster |
| searches of rebar's imported definitions | imported/sherlock/name-sherlock | ▼ 6% slower |
| searches of rebar's imported definitions | imported/sherlock/name-holmes | ▼ 16% slower |
| searches of rebar's imported definitions | imported/sherlock/name-sherlock-holmes | ▼ 6% slower |
| searches of rebar's imported definitions | imported/sherlock/name-sherlock-casei | ▼ 5% slower |
| searches of rebar's imported definitions | imported/sherlock/name-holmes-casei | ▼ 13% slower |
| searches of rebar's imported definitions | imported/sherlock/name-alt2 | ▲ 5% faster |
| searches of rebar's imported definitions | imported/sherlock/name-alt4 | ▲ 9% faster |
| searches of rebar's imported definitions | imported/sherlock/name-alt5 | ▲ 5% faster |
| searches of rebar's imported definitions | imported/sherlock/name-alt5-casei | ▲ 6% faster |
| searches of rebar's imported definitions | imported/sherlock/the-lower | ▼ 16% slower |
| searches of rebar's imported definitions | imported/sherlock/the-upper | ▼ 18% slower |
| searches of rebar's imported definitions | imported/sherlock/the-casei | ▼ 14% slower |
| searches of rebar's imported definitions | imported/sherlock/everything-greedy | ▲ 9% faster |
| searches of rebar's imported definitions | imported/sherlock/everything-greedy-nl | ▲ 10% faster |
| searches of rebar's imported definitions | imported/sherlock/letters | ▲ 20% faster |
| searches of rebar's imported definitions | imported/sherlock/letters-upper | ▲ 5% faster |
| searches of rebar's imported definitions | imported/sherlock/letters-lower | ▲ 20% faster |
| searches of rebar's imported definitions | imported/sherlock/words | ▲ 16% faster |
| searches of rebar's imported definitions | imported/sherlock/before-holmes | ▲ 23× faster |
| searches of rebar's imported definitions | imported/sherlock/before-after-holmes | ▲ 22× faster |
| searches of rebar's imported definitions | imported/sherlock/quotes | ▲ 15% faster |
| searches of rebar's imported definitions | imported/sherlock/line-boundary-sherlock-holmes | ▲ 57× faster |
| searches of rebar's imported definitions | imported/sherlock/repeated-class-negation | ▼ 11% slower |
| searches of rebar's imported definitions | imported/sherlock/ing-suffix-limited-space | ▲ 2.9× faster |
| searches of rebar's opt definitions | opt/accelerate/non-dna | ▲ 8% faster |
| searches of rebar's opt definitions | opt/fixed-length/too-big-ascii | ▲ 5.3× faster |
| searches of rebar's opt definitions | opt/fixed-length/go33484-1 | ▲ 12,896× faster |
| searches of rebar's opt definitions | opt/fixed-length/go33484-2 | ▲ 199× faster |
| searches of rebar's opt definitions | opt/fixed-length/go33484-3 | ▲ 50× faster |
| searches of rebar's opt definitions | opt/onepass/first-three-words-english | ▲ 14% faster |
| searches of rebar's opt definitions | opt/reverse-anchored/word-end | ▲ 8,316× faster |
| searches of rebar's opt definitions | opt/reverse-inner/holmes | ▲ 22× faster |
| searches of rebar's opt definitions | opt/reverse-inner/email | ▲ 80× faster |
| searches of rebar's opt definitions | opt/reverse-inner/no-quadratic-backward | ▲ 5.6× faster |
| searches of rebar's opt definitions | opt/reverse-suffix/holmes | ▲ 23× faster |
| searches of rebar's opt definitions | opt/reverse-suffix/no-quadratic | ▲ 5.6× faster |
| searches of rebar's reported definitions | reported/i13-subset-regex/original-ascii | ▼ 9% slower |
| searches of rebar's reported definitions | reported/i13-subset-regex/original-unicode | ▼ 8% slower |
| searches of rebar's reported definitions | reported/i13-subset-regex/big-unicode | ▼ 9% slower |
| searches of rebar's reported definitions | reported/i13-subset-regex/huge-ascii | ▼ 9% slower |
| searches of rebar's reported definitions | reported/i787-keywords/ascii | ▲ 13% faster |
| searches of rebar's unicode definitions | unicode/overlapping-words/ascii | ▲ 6% faster |
| searches of rebar's unicode definitions | unicode/word/boundary-any-english | ▲ 19% faster |
| searches of rebar's unicode definitions | unicode/word/around-holmes-english | ▲ 105× faster |
| searches of rebar's wild definitions | wild/bibleref/line | ▲ 6% faster |
| searches of rebar's wild definitions | wild/ruff/unnecessary-coding-comment | ▲ 99% faster |
| searches of rebar's wild definitions | wild/ruff/string-quote-prefix | ▲ 3.1× faster |
| searches of rebar's wild definitions | wild/ruff/shebang | ▲ 2.2× faster |
| searches of rebar's other definitions | dictionary/search/english-10 | ▲ 165× faster |
| searches of rebar's other definitions | folly/awyer-inn-busted | ▲ 5.6× faster |
| searches of rebar's other definitions | folly/literal-never-match-frequent | ▲ 9% faster |
| searches of rebar's other definitions | slow/quadratic-haystack-1x | ▲ 9% faster |
| searches of rebar's other definitions | slow/quadratic-haystack-2x | ▲ 29% faster |
| rebar's other compiles | dictionary/compile/english-15 | ▼ 9% slower |
