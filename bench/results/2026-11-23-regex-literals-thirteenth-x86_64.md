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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243532636 |
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
| literal: a word | 217 | 39546.70 ± 5.1% | 3342.73 ± 0.2% | 19.84 ± 5.0% | 31219.62 ± 0.9% | 9039.34 ± 9.2% | 10.73 ± 0.3% | 75.64 ± 1.5% | 38426.07 ± 3.8% | 11.83 | 1.03 | 1.27 | 4.37 |
| literal: a word that is not there | 0 | 53437.24 ± 1.4% | 3234.58 ± 0.4% | 20.08 ± 2.2% | 39957.84 ± 0.8% | 30006.75 ± 0.6% | 10.70 ± 0.5% | 71.95 ± 0.6% | 52528.18 ± 1.7% | 16.52 | 1.02 | 1.34 | 1.78 |
| literal: one of four words | 661 | 11593.67 ± 2.0% | 1397.31 ± 0.7% | 10.93 ± 4.0% | 9113.12 ± 0.9% | 18.96 ± 9.1% | 3.98 ± 0.1% | 6.02 ± 0.2% | 11596.49 ± 1.9% | 8.30 | 1.00 | 1.27 | 611.40 |
| literal: a word in any case | 217 | 30020.84 ± 2.2% | 1461.72 ± 2.3% | 14.93 ± 4.3% | 9025.67 ± 4.6% | 37.09 ± 3.9% | refused | differs | 30055.11 ± 3.5% | 20.54 | 1.00 | 3.33 | 809.39 |
| literal: an href attribute | 33 | 29243.69 ± 1.0% | 539.08 ± 0.3% | 18.45 ± 1.3% | 27188.18 ± 4.6% | 2053.75 ± 1.1% | 8.24 ± 0.2% | 63.18 ± 4.0% | 29133.83 ± 1.9% | 54.25 | 1.00 | 1.08 | 14.24 |
| literal: a word, second text | 123 | 37261.78 ± 2.0% | 2369.14 ± 0.6% | 19.90 ± 3.5% | 31916.80 ± 1.4% | 7381.65 ± 5.1% | 11.82 ± 0.6% | 65.21 ± 2.5% | 37015.84 ± 1.9% | 15.73 | 1.01 | 1.17 | 5.05 |
| class: two capitalized words | 1331 | 764.30 ± 0.4% | 526.67 ± 0.5% | 18.61 ± 1.6% | 505.85 ± 0.8% | 34.30 ± 1.3% | 9.31 ± 0.3% | 57.29 ± 0.6% | 764.44 ± 0.3% | 1.45 | 1.00 | 1.51 | 22.28 |
| class: a word that ends in ing | 3399 | 498.36 ± 0.5% | 497.59 ± 0.7% | 12.90 ± 0.8% | 472.58 ± 0.5% | 23.89 ± 16.0% | 5.35 ± 0.5% | 16.49 ± 0.4% | 499.37 ± 1.2% | 1.00 | 1.00 | 1.05 | 20.86 |
| class: a word in capitals | 2332 | 942.74 ± 1.6% | 531.40 ± 0.6% | 19.59 ± 2.8% | 497.30 ± 0.3% | 36.61 ± 5.6% | 10.32 ± 0.7% | 77.63 ± 0.8% | 940.83 ± 2.9% | 1.77 | 1.00 | 1.90 | 25.75 |
| class: a number | 8288 | 1450.57 ± 0.3% | 699.98 ± 1.2% | 19.60 ± 0.9% | 1485.00 ± 2.1% | 34.63 ± 12.5% | 0.34 ± 0.3% | 55.42 ± 1.1% | 1452.20 ± 1.7% | 2.07 | 1.00 | 0.98 | 41.89 |
| class: two capitalized words, second text | 5359 | 442.14 ± 1.6% | 449.57 ± 2.4% | 17.05 ± 1.0% | 417.95 ± 0.7% | 29.91 ± 4.4% | 10.48 ± 0.3% | 52.64 ± 0.7% | 442.82 ± 0.9% | 0.98 | 1.00 | 1.06 | 14.78 |
| other: a word between two words | 6104 | 703.27 ± 3.8% | 510.24 ± 0.9% | 16.19 ± 1.2% | 699.18 ± 0.4% | 96.71 ± 13.7% | 7.26 ± 0.5% | 58.38 ± 1.0% | 705.38 ± 0.8% | 1.38 | 1.00 | 1.01 | 7.27 |
| other: a number before a unit, second text | 1481 | 7300.41 ± 1.1% | 854.39 ± 2.0% | 18.59 ± 4.8% | 6412.32 ± 1.6% | 35.09 ± 11.7% | 10.88 ± 0.3% | 56.02 ± 0.7% | 7267.69 ± 0.8% | 8.54 | 1.00 | 1.14 | 208.04 |
| other: a heading's start tag | 110 | 19469.10 ± 1.4% | 654.18 ± 0.2% | 19.36 ± 1.3% | 2005.67 ± 0.6% | 1477.22 ± 3.5% | 10.02 ± 3.6% | 74.19 ± 0.9% | 19326.45 ± 2.5% | 29.76 | 1.01 | 9.71 | 13.18 |
| other: a whole word | 217 | 23344.85 ± 2.3% | 531.41 ± 1.2% | 19.60 ± 2.0% | 22056.82 ± 6.6% | 38.62 ± 7.4% | 9.47 ± 1.5% | 46.87 ± 1.7% | 23222.91 ± 5.8% | 43.93 | 1.01 | 1.06 | 604.41 |
| other: a line's first word, second text | 3716 | 1995.27 ± 3.3% | 512.56 ± 0.5% | 22.23 ± 3.8% | 1699.83 ± 7.9% | 51.54 ± 5.1% | refused | refused | 1975.95 ± 4.6% | 3.89 | 1.01 | 1.17 | 38.71 |
| other: fourteen octets before an x | 87 | 27045.37 ± 1.8% | 207.10 ± 0.4% | 5.42 ± 3.3% | 2897.99 ± 1.3% | 8.98 ± 0.5% | differs | 14.72 ± 9.2% | 26987.78 ± 1.1% | 130.59 | 1.00 | 9.33 | 3012.24 |
| other: a Greek word | 21815 | 383.62 ± 0.1% | 335.61 ± 0.4% | 23.64 ± 2.9% | 262.72 ± 1.6% | 39.41 ± 5.4% | differs | refused | 384.50 ± 0.3% | 1.14 | 1.00 | 1.46 | 9.73 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 15.83 ± 0.2% | 16.89 ± 1.6% | 0.78 ± 0.7% | 16.80 ± 0.6% | 2.28 ± 0.8% | differs | 3.60 ± 6.5% | 16.91 ± 0.8% | 0.94 | 0.94 | 0.94 | 6.94 |
| a UUID | 32895 | 18.40 ± 1.2% | 18.36 ± 0.5% | 0.54 ± 6.8% | 12.82 ± 0.2% | 2.50 ± 1.5% | 0.44 ± 1.0% | 2.99 ± 10.0% | 18.33 ± 0.2% | 1.00 | 1.00 | 1.43 | 7.37 |
| an IPv4 address | 33176 | 30.46 ± 1.7% | 30.13 ± 1.6% | 1.76 ± 0.7% | 23.95 ± 0.2% | 5.68 ± 6.1% | differs | 3.39 ± 0.7% | 30.57 ± 2.2% | 1.01 | 1.00 | 1.27 | 5.36 |
| a date and time | 32954 | 27.07 ± 1.5% | 27.18 ± 3.2% | 1.25 ± 0.3% | 17.89 ± 1.6% | 6.59 ± 1.5% | 0.76 ± 0.3% | 6.02 ± 3.7% | 27.11 ± 0.9% | 1.00 | 1.00 | 1.51 | 4.11 |
| a field path | 32606 | 19.96 ± 1.2% | 19.98 ± 0.7% | 0.87 ± 3.6% | 19.38 ± 0.4% | 2.91 ± 0.5% | differs | 2.44 ± 0.7% | 19.93 ± 2.5% | 1.00 | 1.00 | 1.03 | 6.85 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.64 ± 32.0% | 8.68 ± 1.2% | 8.67 ± 2.7% | 10.64 ± 46.3% | 4.71 ± 0.8% | 0.62 ± 0.4% | none | 8.59 ± 3.7% | 1.00 | 1.01 | 0.81 | 1.84 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 203.69 ± 0.3% | 204.54 ± 1.8% | 241.76 ± 0.7% | 78.83 ± 3.6% | 185.01 ± 2.1% | 536.10 ± 4.8% | 3534.03 ± 3.6% | 203.40 ± 0.5% | 1.00 | 1.00 | 2.58 | 1.10 |
| a UUID | 62 | 132.15 ± 1.0% | 133.00 ± 2.2% | 148.29 ± 0.5% | 46.55 ± 1.2% | 89.53 ± 3.7% | 197.98 ± 4.9% | 3863.98 ± 0.8% | 132.29 ± 2.2% | 0.99 | 1.00 | 2.84 | 1.48 |
| an IPv4 address | 29 | 379.57 ± 2.0% | 384.02 ± 0.9% | 528.63 ± 1.5% | 70.03 ± 1.0% | 113.44 ± 2.9% | 330.40 ± 1.4% | 6567.05 ± 1.5% | 381.17 ± 1.4% | 0.99 | 1.00 | 5.42 | 3.35 |
| a date and time | 56 | 276.98 ± 1.3% | 278.81 ± 1.1% | 345.76 ± 2.9% | 69.09 ± 5.9% | 123.49 ± 12.8% | 374.34 ± 2.7% | 3853.12 ± 4.4% | 277.58 ± 2.1% | 0.99 | 1.00 | 4.01 | 2.24 |
| a field path | 39 | 203.99 ± 0.9% | 205.11 ± 2.1% | 240.75 ± 6.9% | 74.68 ± 1.8% | 174.67 ± 9.8% | 601.10 ± 2.4% | 4431.60 ± 6.3% | 204.51 ± 0.6% | 0.99 | 1.00 | 2.73 | 1.17 |
| literal: a word | 7 | 572.84 ± 2.6% | 618.56 ± 1.3% | 1079.55 ± 0.5% | 484.04 ± 1.6% | 575.80 ± 14.9% | 1239.23 ± 14.6% | 24571.69 ± 2.1% | 573.18 ± 1.0% | 0.93 | 1.00 | 1.18 | 0.99 |
| literal: a word that is not there | 8 | 543.02 ± 3.6% | 589.77 ± 2.3% | 1002.91 ± 0.6% | 449.32 ± 0.6% | 543.52 ± 10.2% | 1181.71 ± 1.2% | 23431.00 ± 0.9% | 545.48 ± 2.9% | 0.92 | 1.00 | 1.21 | 1.00 |
| literal: one of four words | 26 | 210.15 ± 0.4% | 355.66 ± 0.9% | 474.27 ± 1.6% | 41.62 ± 1.0% | 216.73 ± 2.5% | 451.58 ± 1.4% | 9863.71 ± 0.3% | 209.48 ± 0.9% | 0.59 | 1.00 | 5.05 | 0.97 |
| literal: a word in any case | 11 | 395.59 ± 2.2% | 418.73 ± 1.5% | 595.26 ± 0.9% | 14.52 ± 4.4% | 608.32 ± 1.7% | refused | 18199.69 ± 8.7% | 391.43 ± 2.4% | 0.94 | 1.01 | 27.24 | 0.65 |
| literal: an href attribute | 12 | 321.63 ± 0.5% | 335.88 ± 0.5% | 448.06 ± 0.1% | 36.80 ± 14.6% | 420.58 ± 2.6% | 956.07 ± 0.8% | 17217.85 ± 1.8% | 321.65 ± 1.2% | 0.96 | 1.00 | 8.74 | 0.76 |
| literal: a word, second text | 10 | 503.75 ± 2.6% | 544.34 ± 5.3% | 897.83 ± 3.1% | 405.04 ± 4.5% | 478.50 ± 5.9% | 991.35 ± 2.5% | 19833.31 ± 3.4% | 503.77 ± 2.7% | 0.93 | 1.00 | 1.24 | 1.05 |
| class: two capitalized words | 23 | 409.29 ± 0.9% | 439.75 ± 2.0% | 641.18 ± 3.6% | 94.00 ± 1.1% | 442.69 ± 7.1% | 955.24 ± 16.2% | 6117.06 ± 1.0% | 411.35 ± 2.2% | 0.93 | 1.00 | 4.35 | 0.92 |
| class: a word that ends in ing | 9 | 494.53 ± 3.6% | 567.38 ± 1.2% | 1002.59 ± 3.9% | 114.12 ± 0.8% | 613.41 ± 2.6% | 1441.07 ± 0.6% | 14798.07 ± 1.4% | 491.96 ± 10.0% | 0.87 | 1.01 | 4.33 | 0.81 |
| class: a word in capitals | 16 | 427.24 ± 1.0% | 462.00 ± 1.7% | 764.96 ± 0.5% | 124.03 ± 2.5% | 636.22 ± 3.3% | 1337.97 ± 0.8% | 8198.74 ± 14.3% | 427.29 ± 0.7% | 0.92 | 1.00 | 3.44 | 0.67 |
| class: a number | 6 | 544.07 ± 3.3% | 603.76 ± 1.8% | 1171.09 ± 0.2% | 36.58 ± 3.9% | 1161.57 ± 1.7% | 2317.73 ± 1.7% | 20148.35 ± 1.6% | 549.43 ± 1.5% | 0.90 | 0.99 | 14.88 | 0.47 |
| class: two capitalized words, second text | 23 | 410.45 ± 1.1% | 442.30 ± 3.6% | 641.90 ± 2.1% | 95.05 ± 1.0% | 450.60 ± 2.6% | 978.79 ± 1.6% | 6123.34 ± 2.4% | 410.90 ± 1.3% | 0.93 | 1.00 | 4.32 | 0.91 |
| other: a word between two words | 13 | 493.50 ± 2.9% | 515.65 ± 1.8% | 806.99 ± 0.5% | 123.87 ± 2.3% | 429.11 ± 4.7% | 1024.49 ± 2.1% | 12384.50 ± 4.0% | 494.40 ± 2.2% | 0.96 | 1.00 | 3.98 | 1.15 |
| other: a number before a unit, second text | 15 | 367.08 ± 1.5% | 413.86 ± 2.8% | 583.32 ± 0.6% | 33.82 ± 2.3% | 523.55 ± 15.5% | 1132.53 ± 2.7% | 12852.57 ± 1.5% | 365.34 ± 2.3% | 0.89 | 1.00 | 10.85 | 0.70 |
| other: a heading's start tag | 13 | 334.45 ± 1.2% | 342.37 ± 1.7% | 457.07 ± 0.5% | 34.93 ± 2.5% | 517.46 ± 3.5% | 1067.15 ± 1.8% | 15246.05 ± 4.8% | 334.85 ± 0.7% | 0.98 | 1.00 | 9.58 | 0.65 |
| other: a whole word | 11 | 496.24 ± 0.8% | 529.40 ± 11.0% | 834.05 ± 1.6% | 112.24 ± 1.8% | 497.99 ± 2.5% | 1034.69 ± 1.0% | 19085.34 ± 5.5% | 495.11 ± 0.7% | 0.94 | 1.00 | 4.42 | 1.00 |
| other: a line's first word, second text | 17 | 475.12 ± 4.9% | 505.21 ± 6.2% | 820.19 ± 0.4% | 114.82 ± 0.5% | 592.88 ± 2.1% | refused | refused | 471.61 ± 1.8% | 0.94 | 1.01 | 4.14 | 0.80 |
| other: fourteen octets before an x | 16 | 87.43 ± 1.3% | 124.24 ± 1.6% | 143.08 ± 12.8% | 14.09 ± 1.5% | 392.12 ± 1.4% | 451.01 ± 10.4% | 11728.07 ± 0.4% | 87.54 ± 8.7% | 0.70 | 1.00 | 6.20 | 0.22 |
| other: a Greek word | 8 | 370.16 ± 1.9% | 531.61 ± 1.4% | 933.15 ± 0.2% | 45.30 ± 0.3% | 1134.39 ± 1.9% | 2167.36 ± 0.5% | refused | 373.61 ± 8.1% | 0.70 | 0.99 | 8.17 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26670.32 ± 1.2% | not timed | not timed | 26940.78 ± 0.8% | 1905.00 ± 21.9% | not timed | not timed | 26372.99 ± 2.4% | | 1.01 | 0.99 | 14.00 |
| 01-literal/sherlock-casei-en | 522 | 8039.25 ± 1.5% | not timed | not timed | 7033.96 ± 0.7% | 23.50 ± 0.9% | not timed | not timed | 6653.20 ± 0.4% | | 1.21 | 1.14 | 342.14 |
| 01-literal/sherlock-ru | 724 | 27831.62 ± 1.5% | not timed | not timed | 27692.04 ± 0.8% | 1072.98 ± 8.8% | not timed | not timed | 27718.36 ± 11.7% | | 1.00 | 1.01 | 25.94 |
| 01-literal/sherlock-casei-ru | 746 | 9699.95 ± 0.7% | not timed | not timed | 5512.94 ± 0.4% | 29.79 ± 1.4% | not timed | not timed | 9678.32 ± 0.6% | | 1.00 | 1.76 | 325.59 |
| 01-literal/sherlock-zh | 30 | 46928.56 ± 0.8% | not timed | not timed | 36897.94 ± 0.7% | 1261.92 ± 0.7% | not timed | not timed | 46734.02 ± 1.2% | | 1.00 | 1.27 | 37.19 |
| 02-literal-alternate/sherlock-en | 714 | 10064.73 ± 0.6% | not timed | not timed | 8889.95 ± 0.5% | 14.77 ± 4.5% | not timed | not timed | 10079.03 ± 0.5% | | 1.00 | 1.13 | 681.56 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2042.71 ± 6.3% | not timed | not timed | 1820.09 ± 3.3% | 8.91 ± 2.2% | not timed | not timed | 2031.77 ± 2.7% | | 1.01 | 1.12 | 229.32 |
| 02-literal-alternate/sherlock-ru | 899 | 8123.05 ± 6.0% | not timed | not timed | 4252.97 ± 0.2% | 19.54 ± 0.8% | not timed | not timed | 8176.56 ± 5.5% | | 0.99 | 1.91 | 415.82 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2097.49 ± 0.6% | not timed | not timed | 1047.98 ± 0.6% | 8.47 ± 4.2% | not timed | not timed | 2101.76 ± 0.7% | | 1.00 | 2.00 | 247.68 |
| 02-literal-alternate/sherlock-zh | 207 | 14457.11 ± 0.4% | not timed | not timed | 10413.64 ± 1.9% | 27.17 ± 2.3% | not timed | not timed | 14439.45 ± 1.7% | | 1.00 | 1.39 | 532.10 |
| 03-date/ascii | 111817 | 95.10 ± 6.4% | not timed | not timed | 84.45 ± 2.8% | 0.18 ± 2.0% | not timed | not timed | 95.86 ± 2.9% | | 0.99 | 1.13 | 536.05 |
| 04-ruff-noqa/real | 84 | 410.54 ± 2.0% | not timed | not timed | 440.87 ± 0.7% | 15.97 ± 2.2% | not timed | not timed | 402.38 ± 1.9% | | 1.02 | 0.93 | 25.71 |
| 04-ruff-noqa/tweaked | 44 | 511.60 ± 0.9% | not timed | not timed | 421.99 ± 1.4% | 294.12 ± 0.6% | not timed | not timed | 512.24 ± 0.9% | | 1.00 | 1.21 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.45 ± 3.0% | not timed | not timed | 4.23 ± 2.1% | 0.21 ± 3.3% | not timed | not timed | 3.43 ± 0.8% | | 1.00 | 0.81 | 16.09 |
| 06-cloud-flare-redos/original | 107 | 348.38 ± 0.5% | not timed | not timed | 191.84 ± 8.6% | 20.65 ± 0.8% | not timed | not timed | 348.64 ± 0.2% | | 1.00 | 1.82 | 16.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 326.02 ± 2.2% | not timed | not timed | 190.73 ± 2.9% | 21.86 ± 1.0% | not timed | not timed | 323.65 ± 1.9% | | 1.01 | 1.71 | 14.91 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.81 ± 0.3% | not timed | not timed | 211.04 ± 13.8% | 23.94 ± 0.9% | not timed | not timed | 464.51 ± 0.3% | | 1.00 | 2.20 | 19.42 |
| 07-unicode-character-data/parse-line | 558784 | 203.07 ± 1.9% | not timed | not timed | 160.54 ± 0.7% | 36.69 ± 5.1% | not timed | not timed | 199.24 ± 7.7% | | 1.02 | 1.26 | 5.53 |
| 08-words/all-english | 56691 | 94.60 ± 3.7% | not timed | not timed | 73.65 ± 0.6% | 11.29 ± 13.1% | not timed | not timed | 94.13 ± 1.4% | | 1.00 | 1.28 | 8.38 |
| 08-words/long-english | 839 | 535.57 ± 0.3% | not timed | not timed | 513.49 ± 0.2% | 26.05 ± 3.0% | not timed | not timed | 535.44 ± 0.6% | | 1.00 | 1.04 | 20.56 |
| 09-aws-keys/full | 0 | 410.15 ± 3.3% | not timed | not timed | 436.92 ± 0.5% | 54.72 ± 1.2% | not timed | not timed | 414.45 ± 0.9% | | 0.99 | 0.94 | 7.50 |
| 09-aws-keys/quick | 0 | 948.99 ± 1.1% | not timed | not timed | 801.64 ± 0.7% | 331.76 ± 16.8% | not timed | not timed | 948.78 ± 9.3% | | 1.00 | 1.18 | 2.86 |
| 10-bounded-repeat/letters-en | 1833 | 481.28 ± 0.9% | not timed | not timed | 432.36 ± 0.1% | 16.81 ± 4.4% | not timed | not timed | 482.97 ± 0.3% | | 1.00 | 1.11 | 28.64 |
| 10-bounded-repeat/letters-ru | 3475 | 429.81 ± 0.7% | not timed | not timed | 408.64 ± 0.6% | 17.96 ± 15.6% | not timed | not timed | 428.95 ± 1.0% | | 1.00 | 1.05 | 23.93 |
| 10-bounded-repeat/context | 53 | 65.44 ± 2.5% | not timed | not timed | 56.32 ± 5.2% | 16.83 ± 2.7% | not timed | not timed | 65.24 ± 1.0% | | 1.00 | 1.16 | 3.89 |
| 10-bounded-repeat/capitals | 11 | 556.96 ± 8.1% | not timed | not timed | 531.97 ± 0.5% | 30.88 ± 4.2% | not timed | not timed | 552.89 ± 9.8% | | 1.01 | 1.05 | 18.04 |
| 11-unstructured-to-json/extract | 600 | 53.93 ± 6.2% | not timed | not timed | 60.36 ± 15.3% | 39.56 ± 3.7% | not timed | not timed | 54.69 ± 5.1% | | 0.99 | 0.89 | 1.36 |
| 12-dictionary/single | 1 | 457.30 ± 1.2% | not timed | not timed | 440.42 ± 0.5% | 0.31 ± 0.9% | not timed | not timed | 459.45 ± 1.0% | | 1.00 | 1.04 | 1490.51 |
| 14-quadratic/1x | 100 | 21.12 ± 4.4% | not timed | not timed | 9.09 ± 0.6% | 0.80 ± 2.7% | not timed | not timed | 21.08 ± 14.2% | | 1.00 | 2.32 | 26.47 |
| 14-quadratic/2x | 200 | 16.16 ± 0.9% | not timed | not timed | 4.90 ± 2.8% | 0.43 ± 5.6% | not timed | not timed | 16.20 ± 0.6% | | 1.00 | 3.30 | 37.82 |
| 14-quadratic/10x | 1000 | 5.61 ± 1.8% | not timed | not timed | 1.05 ± 1.1% | 0.09 ± 11.7% | not timed | not timed | 5.62 ± 0.2% | | 1.00 | 5.34 | 61.28 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.18 ± 0.5% | not timed | not timed | 0.39 ± 13.3% | 0.47 ± 6.8% | not timed | not timed | 1.18 ± 1.0% | | 1.01 | 3.07 | 2.52 |
| 04-ruff-noqa/compile-real | 1 | 85.42 ± 8.1% | not timed | not timed | 13.07 ± 0.5% | 125.20 ± 3.1% | not timed | not timed | 84.84 ± 5.7% | | 1.01 | 6.53 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 12.66 ± 0.3% | not timed | not timed | 2.37 ± 1.3% | 5.94 ± 2.7% | not timed | not timed | 12.56 ± 1.7% | | 1.01 | 5.35 | 2.13 |
| 07-unicode-character-data/compile | 1 | 52.12 ± 1.4% | not timed | not timed | 24.38 ± 0.7% | 32.63 ± 1.0% | not timed | not timed | 51.43 ± 3.1% | | 1.01 | 2.14 | 1.60 |
| 09-aws-keys/compile-full | 1 | 35.26 ± 1.3% | not timed | not timed | 7.39 ± 0.9% | 20.26 ± 5.4% | not timed | not timed | 34.83 ± 2.1% | | 1.01 | 4.77 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 153.88 ± 22.6% | not timed | not timed | 45.28 ± 3.0% | 116.62 ± 2.7% | not timed | not timed | 151.53 ± 1.4% | | 1.02 | 3.40 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 10.43 ± 0.3% | not timed | not timed | 11.66 ± 2.1% | 14.96 ± 4.9% | not timed | not timed | 10.40 ± 0.8% | | 1.00 | 0.90 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 71.92 ± 1.7% | not timed | not timed | 8.79 ± 1.5% | 22.08 ± 8.5% | not timed | not timed | 71.21 ± 3.1% | | 1.01 | 8.18 | 3.26 |
| 11-unstructured-to-json/compile | 1 | 77.77 ± 0.5% | not timed | not timed | 37.36 ± 1.4% | 59.22 ± 2.8% | not timed | not timed | 76.81 ± 2.0% | | 1.01 | 2.08 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.28 ± 2.3% | not timed | not timed | 0.07 ± 16.7% | 0.09 ± 15.3% | not timed | not timed | 0.28 ± 2.7% | | 1.00 | 4.12 | 3.29 |

