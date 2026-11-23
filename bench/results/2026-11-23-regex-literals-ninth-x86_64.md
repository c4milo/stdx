# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243505717 |
| Date | 2026-11-23 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

The patterns of the search table:

- literal: a word, in canterbury-large/bible.txt: `Pharaoh`
- literal: a word that is not there, in canterbury-large/bible.txt: `Sherlock`
- literal: one of four words, in canterbury-large/bible.txt: `Abraham|Isaac|Jacob|Joseph`
- literal: a word in any case, in canterbury-large/bible.txt: `(?i)pharaoh`
- literal: an href attribute, in http/html-1m: `href="[^"]*"`
- literal: a word, second text, in canterbury-large/world192.txt: `Population`
- class: two capitalized words, in canterbury-large/bible.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- class: a word that ends in ing, in canterbury-large/bible.txt: `[a-z]+ing`
- class: a word in capitals, in canterbury-large/bible.txt: `[A-Z][A-Z][A-Z]+`
- class: a number, in http/html-1m: `[0-9]+`
- class: two capitalized words, second text, in canterbury-large/world192.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- other: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- other: a number before a unit, second text, in canterbury-large/world192.txt: `[0-9][0-9,]* km`
- other: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- other: a whole word, in canterbury-large/bible.txt: `\bPharaoh\b`, which Rust's regex takes as `(?-u:\b)Pharaoh(?-u:\b)`
- other: a line's first word, second text, in canterbury-large/world192.txt: `(?m)^[A-Z][a-z]+:`
- other: fourteen octets before an x, in canterbury-large/bible.txt: `[a-q][^u-z]{13}x`
- other: a Greek word, in generated: words in four scripts: `[α-ω]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| literal: a word | 217 | 40215.84 ± 4.8% | 3337.92 ± 2.1% | 20.11 ± 0.2% | 31098.23 ± 1.1% | 8955.45 ± 9.6% | 10.95 ± 0.5% | 76.00 ± 1.2% | 38848.42 ± 1.7% | 12.05 | 1.04 | 1.29 | 4.49 |
| literal: a word that is not there | 0 | 53859.36 ± 49.1% | 3243.96 ± 0.1% | 20.11 ± 0.3% | 39500.63 ± 3.2% | 30106.82 ± 0.8% | 10.87 ± 0.6% | 71.76 ± 2.1% | 53492.84 ± 22.8% | 16.60 | 1.01 | 1.36 | 1.79 |
| literal: one of four words | 661 | 11613.19 ± 0.8% | 1391.05 ± 1.9% | 11.04 ± 2.9% | 9105.04 ± 0.3% | 19.33 ± 1.8% | 3.97 ± 0.1% | 6.02 ± 7.5% | 11598.80 ± 4.2% | 8.35 | 1.00 | 1.28 | 600.75 |
| literal: a word in any case | 217 | 30153.55 ± 1.6% | 1493.23 ± 2.2% | 15.52 ± 0.1% | 9220.61 ± 4.3% | 37.30 ± 0.3% | refused | differs | 30142.08 ± 0.7% | 20.19 | 1.00 | 3.27 | 808.34 |
| literal: an href attribute | 33 | 29458.04 ± 1.9% | 540.09 ± 2.8% | 18.81 ± 0.4% | 27363.34 ± 1.1% | 2058.29 ± 0.9% | 8.34 ± 0.8% | 63.31 ± 9.7% | 29007.19 ± 1.5% | 54.54 | 1.02 | 1.08 | 14.31 |
| literal: a word, second text | 123 | 37683.91 ± 2.7% | 2382.60 ± 2.2% | 20.00 ± 0.3% | 32037.29 ± 2.1% | 7244.00 ± 8.9% | 12.02 ± 0.2% | 64.88 ± 1.5% | 37471.79 ± 1.5% | 15.82 | 1.01 | 1.18 | 5.20 |
| class: two capitalized words | 1331 | 765.28 ± 2.4% | 526.18 ± 0.1% | 18.83 ± 0.3% | 506.64 ± 0.7% | 34.42 ± 6.2% | 9.46 ± 0.6% | 57.50 ± 0.3% | 764.89 ± 0.3% | 1.45 | 1.00 | 1.51 | 22.23 |
| class: a word that ends in ing | 3399 | 497.80 ± 0.3% | 497.03 ± 1.2% | 12.95 ± 0.2% | 473.34 ± 0.2% | 25.76 ± 7.5% | 5.31 ± 0.2% | 16.53 ± 8.0% | 498.10 ± 1.0% | 1.00 | 1.00 | 1.05 | 19.32 |
| class: a word in capitals | 2332 | 942.29 ± 0.9% | 529.81 ± 0.4% | 19.78 ± 7.3% | 497.91 ± 0.7% | 36.72 ± 7.1% | 10.51 ± 0.5% | 77.62 ± 0.2% | 942.58 ± 0.5% | 1.78 | 1.00 | 1.89 | 25.66 |
| class: a number | 8288 | 1448.64 ± 2.0% | 701.11 ± 1.7% | 19.68 ± 2.2% | 1485.76 ± 2.7% | 36.26 ± 50.2% | 0.34 ± 0.2% | 55.50 ± 0.2% | 1447.97 ± 0.2% | 2.07 | 1.00 | 0.98 | 39.95 |
| class: two capitalized words, second text | 5359 | 443.98 ± 1.1% | 449.99 ± 1.0% | 17.22 ± 1.1% | 418.14 ± 0.2% | 30.23 ± 13.3% | 10.64 ± 0.5% | 52.73 ± 9.4% | 444.22 ± 0.2% | 0.99 | 1.00 | 1.06 | 14.69 |
| other: a word between two words | 6104 | 709.55 ± 0.8% | 512.05 ± 2.3% | 16.93 ± 0.4% | 699.65 ± 0.3% | 102.01 ± 14.7% | 7.35 ± 13.7% | 57.86 ± 1.0% | 707.88 ± 0.4% | 1.39 | 1.00 | 1.01 | 6.96 |
| other: a number before a unit, second text | 1481 | 7309.49 ± 0.4% | 856.45 ± 1.2% | 18.80 ± 0.4% | 6354.30 ± 0.3% | 35.18 ± 6.8% | 11.06 ± 0.3% | 56.36 ± 1.9% | 7261.73 ± 1.1% | 8.53 | 1.01 | 1.15 | 207.77 |
| other: a heading's start tag | 110 | 19722.58 ± 2.2% | 654.48 ± 0.1% | 19.60 ± 0.5% | 2009.52 ± 1.4% | 1480.32 ± 4.1% | 10.17 ± 4.7% | 74.25 ± 1.6% | 19102.09 ± 0.4% | 30.13 | 1.03 | 9.81 | 13.32 |
| other: a whole word | 217 | 23851.78 ± 2.3% | 532.44 ± 0.1% | 20.43 ± 1.9% | 22566.87 ± 0.6% | 40.29 ± 0.2% | 9.62 ± 0.2% | 46.58 ± 0.4% | 23234.20 ± 3.0% | 44.80 | 1.03 | 1.06 | 592.00 |
| other: a line's first word, second text | 3716 | 1970.24 ± 3.8% | 513.75 ± 1.5% | 24.15 ± 4.6% | 1704.61 ± 0.8% | 52.28 ± 5.0% | refused | refused | 1981.60 ± 4.0% | 3.84 | 0.99 | 1.16 | 37.69 |
| other: fourteen octets before an x | 87 | 28014.52 ± 1.9% | 203.75 ± 1.0% | 5.44 ± 2.3% | 2830.84 ± 1.1% | 9.02 ± 0.1% | differs | 14.65 ± 3.1% | 27308.38 ± 4.4% | 137.49 | 1.03 | 9.90 | 3106.61 |
| other: a Greek word | 21815 | 382.46 ± 25.5% | 333.63 ± 1.4% | 24.05 ± 0.2% | 253.26 ± 1.1% | 39.72 ± 8.5% | differs | refused | 383.35 ± 0.5% | 1.15 | 1.00 | 1.51 | 9.63 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 17.01 ± 0.7% | 17.01 ± 0.7% | 0.78 ± 1.2% | 17.03 ± 0.2% | 2.33 ± 2.3% | differs | 3.63 ± 10.3% | 16.92 ± 1.9% | 1.00 | 1.01 | 1.00 | 7.29 |
| a UUID | 32895 | 18.53 ± 0.7% | 18.54 ± 0.3% | 0.53 ± 6.1% | 12.86 ± 0.2% | 2.52 ± 1.6% | 0.43 ± 0.6% | 3.05 ± 1.6% | 18.45 ± 0.6% | 1.00 | 1.00 | 1.44 | 7.35 |
| an IPv4 address | 33176 | 30.47 ± 1.6% | 30.12 ± 2.3% | 1.75 ± 7.5% | 23.71 ± 3.6% | 5.72 ± 0.9% | differs | 3.41 ± 0.8% | 30.59 ± 0.5% | 1.01 | 1.00 | 1.29 | 5.33 |
| a date and time | 32954 | 27.29 ± 0.9% | 27.35 ± 0.3% | 1.24 ± 0.9% | 18.05 ± 0.5% | 6.41 ± 11.5% | 0.74 ± 0.2% | 6.02 ± 2.8% | 27.39 ± 2.5% | 1.00 | 1.00 | 1.51 | 4.25 |
| a field path | 32606 | 19.58 ± 4.6% | 19.90 ± 2.1% | 0.88 ± 4.3% | 19.43 ± 1.8% | 2.91 ± 2.6% | differs | 2.44 ± 2.3% | 19.77 ± 1.8% | 0.98 | 0.99 | 1.01 | 6.72 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.79 ± 23.4% | 8.80 ± 22.8% | 8.80 ± 0.1% | 10.57 ± 0.9% | 4.65 ± 1.0% | 0.62 ± 0.2% | none | 8.81 ± 2.0% | 1.00 | 1.00 | 0.83 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 188.53 ± 2.3% | 189.65 ± 0.5% | 217.89 ± 3.6% | 80.35 ± 3.3% | 183.04 ± 4.0% | 535.33 ± 3.4% | 3456.91 ± 4.7% | 189.38 ± 0.3% | 0.99 | 1.00 | 2.35 | 1.03 |
| a UUID | 62 | 123.17 ± 1.1% | 123.73 ± 0.4% | 135.86 ± 0.4% | 46.69 ± 1.4% | 90.26 ± 1.0% | 197.34 ± 2.3% | 3860.15 ± 1.4% | 123.31 ± 1.3% | 1.00 | 1.00 | 2.64 | 1.36 |
| an IPv4 address | 29 | 389.98 ± 3.0% | 391.71 ± 0.9% | 529.61 ± 11.7% | 69.97 ± 0.6% | 115.08 ± 6.9% | 332.71 ± 14.4% | 6620.09 ± 0.9% | 387.68 ± 8.1% | 1.00 | 1.01 | 5.57 | 3.39 |
| a date and time | 56 | 283.21 ± 0.8% | 284.07 ± 0.6% | 348.76 ± 0.5% | 69.62 ± 2.3% | 123.28 ± 1.4% | 373.40 ± 9.9% | 3854.89 ± 4.0% | 282.59 ± 5.8% | 1.00 | 1.00 | 4.07 | 2.30 |
| a field path | 39 | 186.36 ± 3.5% | 187.39 ± 0.3% | 214.35 ± 0.5% | 74.63 ± 9.8% | 162.99 ± 30.8% | 588.72 ± 1.7% | 4462.49 ± 1.4% | 186.55 ± 0.2% | 0.99 | 1.00 | 2.50 | 1.14 |
| literal: a word | 7 | 595.44 ± 0.7% | 639.34 ± 14.0% | 1083.16 ± 11.7% | 490.33 ± 0.8% | 575.82 ± 1.2% | 1264.38 ± 1.0% | 24602.82 ± 8.0% | 595.69 ± 0.7% | 0.93 | 1.00 | 1.21 | 1.03 |
| literal: a word that is not there | 8 | 567.62 ± 1.3% | 617.84 ± 1.0% | 1013.29 ± 11.8% | 455.20 ± 1.1% | 554.03 ± 1.1% | 1187.71 ± 0.4% | 23468.11 ± 1.8% | 567.37 ± 0.1% | 0.92 | 1.00 | 1.25 | 1.02 |
| literal: one of four words | 26 | 216.81 ± 0.5% | 362.36 ± 12.4% | 474.13 ± 2.7% | 41.80 ± 0.3% | 217.04 ± 3.0% | 448.17 ± 1.4% | 9771.58 ± 3.3% | 216.94 ± 7.4% | 0.60 | 1.00 | 5.19 | 1.00 |
| literal: a word in any case | 11 | 403.74 ± 0.3% | 426.22 ± 0.9% | 590.10 ± 1.5% | 14.47 ± 1.2% | 604.89 ± 3.1% | refused | 18663.48 ± 1.0% | 403.67 ± 1.3% | 0.95 | 1.00 | 27.90 | 0.67 |
| literal: an href attribute | 12 | 321.50 ± 0.4% | 334.81 ± 0.4% | 433.17 ± 0.1% | 37.01 ± 2.4% | 422.11 ± 4.3% | 973.82 ± 2.3% | 17414.65 ± 0.5% | 321.16 ± 0.4% | 0.96 | 1.00 | 8.69 | 0.76 |
| literal: a word, second text | 10 | 521.05 ± 0.6% | 574.04 ± 1.0% | 896.67 ± 1.2% | 412.67 ± 0.7% | 486.39 ± 1.4% | 1044.78 ± 0.5% | 20056.61 ± 1.6% | 522.03 ± 0.8% | 0.91 | 1.00 | 1.26 | 1.07 |
| class: two capitalized words | 23 | 420.69 ± 1.7% | 454.07 ± 2.3% | 640.00 ± 2.9% | 94.15 ± 1.6% | 444.82 ± 2.9% | 976.82 ± 3.0% | 6120.32 ± 0.9% | 420.54 ± 1.0% | 0.93 | 1.00 | 4.47 | 0.95 |
| class: a word that ends in ing | 9 | 511.23 ± 0.7% | 591.49 ± 0.9% | 1003.22 ± 1.1% | 115.08 ± 0.9% | 623.54 ± 2.4% | 1493.53 ± 4.7% | 14825.75 ± 0.6% | 511.53 ± 0.5% | 0.86 | 1.00 | 4.44 | 0.82 |
| class: a word in capitals | 16 | 447.37 ± 0.9% | 483.76 ± 0.5% | 772.79 ± 2.0% | 122.02 ± 1.4% | 644.82 ± 1.2% | 1348.87 ± 3.6% | 8235.05 ± 0.7% | 447.10 ± 0.5% | 0.92 | 1.00 | 3.67 | 0.69 |
| class: a number | 6 | 576.06 ± 0.4% | 639.65 ± 2.3% | 1183.60 ± 0.5% | 36.61 ± 1.1% | 1152.12 ± 2.5% | 2322.67 ± 1.4% | 20190.10 ± 0.7% | 576.62 ± 0.3% | 0.90 | 1.00 | 15.74 | 0.50 |
| class: two capitalized words, second text | 23 | 421.20 ± 8.1% | 446.77 ± 5.1% | 624.62 ± 2.8% | 94.06 ± 0.8% | 449.18 ± 2.5% | 970.89 ± 1.4% | 6124.99 ± 0.4% | 420.70 ± 1.2% | 0.94 | 1.00 | 4.48 | 0.94 |
| other: a word between two words | 13 | 508.25 ± 7.9% | 530.31 ± 0.7% | 805.98 ± 0.4% | 122.21 ± 0.6% | 436.57 ± 3.4% | 1046.67 ± 1.0% | 12382.50 ± 11.6% | 507.62 ± 3.6% | 0.96 | 1.00 | 4.16 | 1.16 |
| other: a number before a unit, second text | 15 | 360.58 ± 1.2% | 404.23 ± 0.1% | 548.11 ± 6.4% | 33.64 ± 0.4% | 532.38 ± 14.0% | 1146.85 ± 2.1% | 12883.72 ± 0.3% | 360.55 ± 0.7% | 0.89 | 1.00 | 10.72 | 0.68 |
| other: a heading's start tag | 13 | 331.52 ± 2.2% | 337.24 ± 0.4% | 440.58 ± 1.2% | 35.43 ± 1.0% | 522.11 ± 1.8% | 1041.64 ± 0.9% | 14880.50 ± 3.8% | 331.65 ± 0.6% | 0.98 | 1.00 | 9.36 | 0.63 |
| other: a whole word | 11 | 505.81 ± 2.7% | 537.25 ± 3.2% | 820.09 ± 3.1% | 108.32 ± 4.0% | 496.62 ± 11.4% | 1031.79 ± 3.0% | 18937.16 ± 4.1% | 505.09 ± 2.7% | 0.94 | 1.00 | 4.67 | 1.02 |
| other: a line's first word, second text | 17 | 488.75 ± 3.7% | 517.70 ± 3.0% | 810.17 ± 0.3% | 114.26 ± 1.9% | 593.74 ± 1.6% | refused | refused | 488.24 ± 1.2% | 0.94 | 1.00 | 4.28 | 0.82 |
| other: fourteen octets before an x | 16 | 87.27 ± 0.2% | 124.44 ± 1.0% | 141.17 ± 0.2% | 14.33 ± 1.0% | 392.85 ± 21.6% | 457.67 ± 2.0% | 11757.23 ± 0.3% | 87.14 ± 1.7% | 0.70 | 1.00 | 6.09 | 0.22 |
| other: a Greek word | 8 | 387.41 ± 1.0% | 542.26 ± 0.2% | 886.34 ± 6.0% | 46.99 ± 2.3% | 1138.35 ± 4.0% | 2163.26 ± 0.4% | refused | 387.10 ± 0.8% | 0.71 | 1.00 | 8.25 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26939.47 ± 2.8% | not timed | not timed | 27142.78 ± 0.3% | 1909.19 ± 19.4% | not timed | not timed | 26875.05 ± 1.7% | | 1.00 | 0.99 | 14.11 |
| 01-literal/sherlock-casei-en | 522 | 7965.11 ± 1.3% | not timed | not timed | 7063.60 ± 0.6% | 23.52 ± 1.2% | not timed | not timed | 8001.53 ± 1.1% | | 1.00 | 1.13 | 338.68 |
| 01-literal/sherlock-ru | 724 | 28681.28 ± 2.8% | not timed | not timed | 27866.67 ± 2.1% | 1054.87 ± 5.3% | not timed | not timed | 28213.96 ± 0.9% | | 1.02 | 1.03 | 27.19 |
| 01-literal/sherlock-casei-ru | 746 | 9655.64 ± 2.3% | not timed | not timed | 5514.98 ± 0.2% | 29.94 ± 1.0% | not timed | not timed | 9647.02 ± 0.2% | | 1.00 | 1.75 | 322.52 |
| 01-literal/sherlock-zh | 30 | 46720.61 ± 1.7% | not timed | not timed | 36834.71 ± 1.1% | 1264.06 ± 1.4% | not timed | not timed | 46369.77 ± 0.5% | | 1.01 | 1.27 | 36.96 |
| 02-literal-alternate/sherlock-en | 714 | 10110.52 ± 1.1% | not timed | not timed | 8861.85 ± 0.6% | 14.82 ± 1.6% | not timed | not timed | 10089.11 ± 0.7% | | 1.00 | 1.14 | 682.38 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2038.69 ± 3.9% | not timed | not timed | 1822.44 ± 0.8% | 8.90 ± 0.9% | not timed | not timed | 2022.98 ± 2.0% | | 1.01 | 1.12 | 229.16 |
| 02-literal-alternate/sherlock-ru | 899 | 8091.17 ± 0.7% | not timed | not timed | 4256.85 ± 1.2% | 19.55 ± 7.7% | not timed | not timed | 8119.68 ± 0.4% | | 1.00 | 1.90 | 413.93 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2094.68 ± 0.4% | not timed | not timed | 1044.29 ± 0.2% | 8.35 ± 7.9% | not timed | not timed | 2092.56 ± 0.6% | | 1.00 | 2.01 | 250.79 |
| 02-literal-alternate/sherlock-zh | 207 | 14442.15 ± 0.6% | not timed | not timed | 10340.79 ± 39.3% | 27.04 ± 2.6% | not timed | not timed | 14419.75 ± 0.4% | | 1.00 | 1.40 | 534.09 |
| 03-date/ascii | 111817 | 96.06 ± 0.7% | not timed | not timed | 85.12 ± 0.3% | 0.18 ± 1.2% | not timed | not timed | 96.37 ± 1.9% | | 1.00 | 1.13 | 546.99 |
| 04-ruff-noqa/real | 84 | 411.23 ± 7.7% | not timed | not timed | 423.52 ± 0.3% | 15.72 ± 2.3% | not timed | not timed | 411.28 ± 0.2% | | 1.00 | 0.97 | 26.16 |
| 04-ruff-noqa/tweaked | 44 | 515.90 ± 17.1% | not timed | not timed | 420.85 ± 0.4% | 295.10 ± 1.0% | not timed | not timed | 512.34 ± 2.4% | | 1.01 | 1.23 | 1.75 |
| 05-lexer-veryl/single | 124800 | 3.38 ± 5.3% | not timed | not timed | 4.17 ± 3.9% | 0.21 ± 6.5% | not timed | not timed | 3.33 ± 2.5% | | 1.02 | 0.81 | 15.89 |
| 06-cloud-flare-redos/original | 107 | 348.75 ± 0.6% | not timed | not timed | 191.93 ± 14.7% | 20.72 ± 2.0% | not timed | not timed | 349.23 ± 0.2% | | 1.00 | 1.82 | 16.83 |
| 06-cloud-flare-redos/simplified-short | 102 | 330.92 ± 0.3% | not timed | not timed | 192.51 ± 0.4% | 22.01 ± 3.3% | not timed | not timed | 329.39 ± 6.2% | | 1.00 | 1.72 | 15.04 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.12 ± 1.4% | not timed | not timed | 211.86 ± 0.1% | 24.12 ± 0.3% | not timed | not timed | 464.70 ± 0.6% | | 1.00 | 2.20 | 19.28 |
| 07-unicode-character-data/parse-line | 558784 | 201.74 ± 18.3% | not timed | not timed | 160.96 ± 1.8% | 37.06 ± 11.1% | not timed | not timed | 202.75 ± 5.0% | | 1.00 | 1.25 | 5.44 |
| 08-words/all-english | 56691 | 96.43 ± 0.8% | not timed | not timed | 74.24 ± 0.6% | 10.09 ± 15.3% | not timed | not timed | 96.20 ± 0.7% | | 1.00 | 1.30 | 9.56 |
| 08-words/long-english | 839 | 536.66 ± 0.7% | not timed | not timed | 513.45 ± 0.2% | 26.21 ± 0.9% | not timed | not timed | 535.94 ± 0.1% | | 1.00 | 1.05 | 20.47 |
| 09-aws-keys/full | 0 | 415.55 ± 0.5% | not timed | not timed | 441.31 ± 0.7% | 54.88 ± 2.1% | not timed | not timed | 416.75 ± 0.3% | | 1.00 | 0.94 | 7.57 |
| 09-aws-keys/quick | 0 | 971.15 ± 1.0% | not timed | not timed | 806.68 ± 1.4% | 330.06 ± 1.1% | not timed | not timed | 968.92 ± 1.2% | | 1.00 | 1.20 | 2.94 |
| 10-bounded-repeat/letters-en | 1833 | 481.75 ± 0.2% | not timed | not timed | 430.71 ± 0.4% | 16.93 ± 2.6% | not timed | not timed | 483.56 ± 0.1% | | 1.00 | 1.12 | 28.46 |
| 10-bounded-repeat/letters-ru | 3475 | 427.64 ± 0.4% | not timed | not timed | 408.82 ± 0.2% | 19.79 ± 6.4% | not timed | not timed | 427.66 ± 2.8% | | 1.00 | 1.05 | 21.60 |
| 10-bounded-repeat/context | 53 | 65.45 ± 6.7% | not timed | not timed | 56.33 ± 7.3% | 16.91 ± 2.8% | not timed | not timed | 65.49 ± 1.0% | | 1.00 | 1.16 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 558.16 ± 8.0% | not timed | not timed | 532.61 ± 0.6% | 30.95 ± 1.2% | not timed | not timed | 553.04 ± 8.2% | | 1.01 | 1.05 | 18.03 |
| 11-unstructured-to-json/extract | 600 | 57.25 ± 0.8% | not timed | not timed | 62.11 ± 1.0% | 40.82 ± 2.4% | not timed | not timed | 57.29 ± 2.2% | | 1.00 | 0.92 | 1.40 |
| 12-dictionary/single | 1 | 458.71 ± 0.5% | not timed | not timed | 441.09 ± 0.5% | 0.32 ± 5.1% | not timed | not timed | 460.56 ± 0.3% | | 1.00 | 1.04 | 1453.36 |
| 14-quadratic/1x | 100 | 21.19 ± 0.6% | not timed | not timed | 9.10 ± 3.6% | 0.81 ± 17.0% | not timed | not timed | 20.98 ± 3.2% | | 1.01 | 2.33 | 26.17 |
| 14-quadratic/2x | 200 | 16.06 ± 1.4% | not timed | not timed | 4.93 ± 0.3% | 0.43 ± 0.4% | not timed | not timed | 16.11 ± 3.6% | | 1.00 | 3.26 | 37.07 |
| 14-quadratic/10x | 1000 | 5.61 ± 8.2% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 1.0% | not timed | not timed | 5.63 ± 0.9% | | 1.00 | 5.34 | 60.16 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.14 ± 0.4% | not timed | not timed | 0.39 ± 11.2% | 0.48 ± 6.1% | not timed | not timed | 1.13 ± 1.3% | | 1.00 | 2.94 | 2.36 |
| 04-ruff-noqa/compile-real | 1 | 80.14 ± 0.3% | not timed | not timed | 12.83 ± 3.3% | 122.96 ± 2.7% | not timed | not timed | 79.35 ± 1.2% | | 1.01 | 6.25 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 12.31 ± 9.6% | not timed | not timed | 2.38 ± 0.6% | 5.92 ± 2.0% | not timed | not timed | 12.26 ± 0.6% | | 1.00 | 5.18 | 2.08 |
| 07-unicode-character-data/compile | 1 | 49.63 ± 0.4% | not timed | not timed | 24.33 ± 12.9% | 32.92 ± 15.4% | not timed | not timed | 49.28 ± 1.9% | | 1.01 | 2.04 | 1.51 |
| 09-aws-keys/compile-full | 1 | 34.17 ± 1.1% | not timed | not timed | 7.40 ± 0.8% | 20.17 ± 5.4% | not timed | not timed | 34.05 ± 1.2% | | 1.00 | 4.62 | 1.69 |
| 09-aws-keys/compile-quick | 1 | 154.56 ± 0.2% | not timed | not timed | 45.21 ± 0.9% | 118.33 ± 8.7% | not timed | not timed | 154.15 ± 2.0% | | 1.00 | 3.42 | 1.31 |
| 10-bounded-repeat/compile-context | 1 | 10.50 ± 1.9% | not timed | not timed | 11.71 ± 1.5% | 15.25 ± 0.6% | not timed | not timed | 10.54 ± 1.2% | | 1.00 | 0.90 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 73.40 ± 1.0% | not timed | not timed | 8.79 ± 0.7% | 22.18 ± 1.7% | not timed | not timed | 72.98 ± 0.2% | | 1.01 | 8.35 | 3.31 |
| 11-unstructured-to-json/compile | 1 | 74.94 ± 1.0% | not timed | not timed | 37.26 ± 4.6% | 60.28 ± 11.2% | not timed | not timed | 74.11 ± 1.2% | | 1.01 | 2.01 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.28 ± 0.5% | not timed | not timed | 0.07 ± 1.2% | 0.09 ± 17.0% | not timed | not timed | 0.28 ± 19.0% | | 1.01 | 4.14 | 3.17 |

