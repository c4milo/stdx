# Benchmarks

stdx's benchmarks time it beside other libraries on GitHub's hosted runners. One runner is an Arm
Neoverse N2. The x86-64 runner gives a CPU model that changes from job to job. Every library of a
row runs in the same job, and a result is stdx's speed over another library's speed in that job
([decision 20](decisions.md)).

Each release runs every benchmark again ([decision 85](decisions.md)). On each release tag the
`bench` workflow runs each benchmark on both runners, once for each codec and 18 times for the
regular expressions. Each job measures the previous release first, and then the release. The
workflow then draws each chart, attaches it to the release, and writes it to the branch
[`charts`](https://github.com/c4milo/stdx/tree/charts). Each chart on this page and in each
module's README comes from that branch, so it is the latest release's chart.

No page on main gives a count of a chart, since the next release would make it stale. The
[page of the branch `charts`](https://github.com/c4milo/stdx/blob/charts/benchmarks.md) lists the
verdicts of each panel, and each release's notes list the rows that changed.

## How to read a chart

The charts are of two kinds ([decision 85](decisions.md)).

- The compression, JSON, checksum and base 64 charts each draw one job.
  - A bar is stdx's speed in multiples of the baseline that the panel's title names.
  - A blue bar is ahead, a gray bar is level, and an orange bar is behind. A row is level when
    its ratio is inside the noise: the spread of the two cells, combined.
  - An encoder's panel plots each library's speed against its compression ratio.
- The regular expression charts draw the median of the jobs on the CPU model that most jobs drew.
  - A bar is the median job, and its whisker is a 95% interval of that median.
  - A row is ahead or behind when its interval is above or below 1. It is level when the
    interval holds 1 and stays inside 5% of 1. It is unclear when the interval holds 1 and goes
    past 5%.
  - A row ahead or behind inside 5% is lighter, and a shaded band marks 5% of 1.
- Each chart marks the rows that changed since the previous release.
  - A row's change is its ratio at the release over its ratio at the previous release, in the
    same job. The median of the jobs is the row's change.
  - A green ▲ after a row's name marks a row 5% or more faster, and a red ▼ one 5% or more
    slower. With one job the change must also pass the noise. With 18 jobs its 95% interval must
    lie on that side of 1.
  - A dashed line marks the row's ratio at the previous release.

## Compression

### DEFLATE, zlib and gzip

`zig build bench-deflate -Doracles` times the gzip decoders of zlib, zlib-ng, libdeflate, Wuffs
and stdx over the corpus files. It also times the gzip encoders of zlib, zlib-ng, libdeflate and
stdx at levels 1, 6 and 9.

![stdx's DEFLATE against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/deflate-aarch64.svg)


![stdx's DEFLATE against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/deflate-x86_64.svg)


### Zstandard

`zig build bench-zstd -Doracles` times libzstd's decoder and stdx's over frames that libzstd
encodes at level 3. It also times both encoders, stdx at levels 1 and 3.

![stdx's Zstandard against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/zstd-aarch64.svg)


![stdx's Zstandard against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/zstd-x86_64.svg)


### brotli

`zig build bench-brotli -Doracles` times Google's brotli decoder and stdx's over streams that
Google's encoder writes at quality 11. It also times both encoders, stdx at levels 1 and 5.

![stdx's brotli against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/brotli-aarch64.svg)


![stdx's brotli against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/brotli-x86_64.svg)


## JSON

`zig build bench-json -Doracles` times the `json` module's decoder and encoder beside simdjson,
yyjson, Zig's std.json, serde_json and Go's jsontext.

![stdx's JSON against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/json-aarch64.svg)


![stdx's JSON against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/json-x86_64.svg)


## Checksums

`zig build bench-checksum -Doracles` times each CRC-32 and Adler-32 path the CPU runs beside zlib,
Wuffs, libdeflate and zlib-ng, and XXH64, from 64 octets to 1 MiB.

![stdx's checksums against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/checksum-aarch64.svg)


![stdx's checksums against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/checksum-x86_64.svg)


## Base 64

`zig build bench-base64 -Doracles` times base 64 encoding and decoding beside Rust's `base64`
crate, Go's encoding/base64 and Zig's std.base64, from 60 octets to 1 MiB.

![stdx's base64 against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/base64-aarch64.svg)


![stdx's base64 against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/base64-x86_64.svg)


## Regular expressions

`zig build bench-regex -Doracles` times the `regex` module beside Rust's regex crate, Go's
regexp, mvzr and zig-regex. Each library's answer must equal Go's before it is timed.

- Each release runs it 18 times on each runner. The N2 runner gives one model. The x86-64 chart
  draws the jobs of the model that the most jobs drew, and needs 5 or more of them.
- These patterns were written for this benchmark, and stdx was tuned on them. So they can favor
  stdx.
- Since the runs at commit 1df5f9f, stdx runs each pattern of rebar's sets that leaves `unicode`
  off in bytes (decision 86).

![stdx's regular expressions against libraries in Rust, Go and Zig, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-aarch64.svg)


![stdx's regular expressions against libraries in Rust, Go and Zig, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-x86_64.svg)


### rebar's curated set

The same runs time every benchmark of rebar's curated set whose engines name Go's regexp or RE2,
each under rebar's own model, pattern and haystack.

- rebar's author chose these benchmarks, not this benchmark's
  ([#44](https://github.com/c4milo/stdx/issues/44)).
- Design §8 part 22n then measured every row and changed stdx by what the rows showed. So this set
  is tuned now, as the set above is. It no longer shows how stdx runs on patterns that its tuning
  did not see.
- rebar's author also wrote Rust's regex crate, and rebar's `BIAS.md` says that the set can favor
  that crate.

![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-rebar-aarch64.svg)


![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-rebar-x86_64.svg)


### rebar's other benchmarks

The same runs time every benchmark of rebar's definitions outside its curated set and its tests
whose engines name Go's regexp or RE2, each under rebar's own model, pattern and haystack. The README of [`src/regex`](../src/regex/README.md#performance) draws this chart, by
the owner's ruling of 2026-11-23 (decisions 85 and 88).

- The owner ruled on 2026-11-24 to tune stdx on this set, and design §8 part 22q judges each
  change on its rows. So this set is tuned now, as the two sets above are, and it no longer shows
  how stdx runs on patterns that its tuning did not see.
- The runs at commit 1df5f9f are the last that came before any work on these rows
  (`bench/results/2026-11-24-regex-bytes-*`), and the README at commit
  [1744e4a](https://github.com/c4milo/stdx/blob/1744e4a/README.md#regular-expressions) draws
  them. No work on stdx had timed these rows, and no constant was chosen with one
  ([#44](https://github.com/c4milo/stdx/issues/44)). stdx was behind Rust's crate on 90 of the
  181 searches on the N2 there.
- One change came before those runs: the bytes mode, for the answer of
  `unicode/compile/match-every-line-ascii`. It was judged on that answer and on no speed.
- stdx gives no answer on `unicode/codepoints/letters-one`. stdx and Go's regexp count Unicode
  17.0.0's letters, and rebar's count comes from older tables.
- rebar's README says that these benchmarks mostly serve to make Rust's regex crate faster. So the
  set can favor that crate, and not stdx.

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-rebar-others-aarch64.svg)


![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/regex-rebar-others-x86_64.svg)


## Run a benchmark again

1. Run `zig build bench-<name> -Doracles` on a Linux host. The first build with `-Doracles`
   fetches about 265 MB of other libraries and corpora. `bench-json`, `bench-base64` and
   `bench-regex` need cargo and go on the path too.
2. Or start the `bench` workflow on GitHub, which runs on both hosted runners. Its `base` input
   names a commit to time first in the same job, for an A/B on one CPU. Its `release` input names
   a release tag, and runs every job of that release, as the tag's push does.
3. `python3 tools/charts.py <chart> <out.svg> <report>...` draws one chart from a run's reports.

[`CLAUDE.md`](../CLAUDE.md) says what each benchmark times, and
[`docs/performance.md`](performance.md) holds the method.
