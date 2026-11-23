# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215359522 |
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
| literal: a word | 217 | 32754.13 ± 3.6% | 3364.02 ± 0.1% | 20.39 ± 3.7% | 31220.32 ± 1.2% | 8975.63 ± 13.4% | 10.73 ± 0.8% | 76.14 ± 0.9% | 32235.79 ± 2.1% | 9.74 | 1.02 | 1.05 | 3.65 |
| literal: a word that is not there | 0 | 48398.99 ± 4.4% | 3249.98 ± 1.0% | 20.36 ± 1.7% | 39686.80 ± 0.9% | 30346.85 ± 0.7% | 10.69 ± 0.7% | 72.13 ± 0.7% | 47881.86 ± 2.5% | 14.89 | 1.01 | 1.22 | 1.59 |
| literal: one of four words | 661 | 11189.87 ± 1.0% | 1388.88 ± 0.2% | 11.06 ± 2.9% | 9104.96 ± 0.3% | 19.27 ± 2.2% | 4.00 ± 0.2% | 6.68 ± 0.7% | 11151.30 ± 5.2% | 8.06 | 1.00 | 1.23 | 580.81 |
| literal: a word in any case | 217 | 26115.07 ± 1.4% | 1496.94 ± 1.4% | 15.26 ± 2.1% | 9151.66 ± 0.5% | 37.27 ± 1.1% | refused | differs | 25984.89 ± 0.8% | 17.45 | 1.01 | 2.85 | 700.67 |
| literal: an href attribute | 33 | 26525.24 ± 0.4% | 538.34 ± 0.4% | 18.58 ± 1.9% | 27466.17 ± 1.0% | 2063.70 ± 1.1% | 8.21 ± 0.3% | 61.64 ± 2.3% | 26309.01 ± 2.0% | 49.27 | 1.01 | 0.97 | 12.85 |
| literal: a word, second text | 123 | 32936.44 ± 0.8% | 2385.99 ± 0.5% | 20.13 ± 2.0% | 31870.00 ± 3.6% | 6910.09 ± 5.3% | 11.84 ± 0.2% | 65.02 ± 0.5% | 32630.38 ± 2.9% | 13.80 | 1.01 | 1.03 | 4.77 |
| class: two capitalized words | 1331 | 770.13 ± 0.2% | 526.24 ± 0.1% | 18.67 ± 1.0% | 506.07 ± 0.3% | 34.44 ± 6.6% | 9.27 ± 0.6% | 55.66 ± 0.3% | 769.38 ± 0.2% | 1.46 | 1.00 | 1.52 | 22.36 |
| class: a word that ends in ing | 3399 | 499.05 ± 0.1% | 499.06 ± 0.2% | 12.98 ± 5.1% | 473.15 ± 0.2% | 25.45 ± 6.2% | 5.35 ± 0.5% | 17.24 ± 0.6% | 498.98 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.61 |
| class: a word in capitals | 2332 | 951.98 ± 0.3% | 530.60 ± 0.9% | 19.71 ± 3.4% | 497.35 ± 0.7% | 36.64 ± 6.6% | 10.31 ± 0.3% | 76.32 ± 5.9% | 956.94 ± 0.4% | 1.79 | 0.99 | 1.91 | 25.98 |
| class: a number | 8288 | 1466.01 ± 3.8% | 697.27 ± 0.4% | 19.83 ± 3.3% | 1481.00 ± 0.6% | 35.06 ± 13.0% | 0.33 ± 0.5% | 54.69 ± 0.4% | 1463.63 ± 0.4% | 2.10 | 1.00 | 0.99 | 41.81 |
| class: two capitalized words, second text | 5359 | 444.34 ± 0.2% | 449.38 ± 0.3% | 15.35 ± 1.0% | 417.94 ± 0.4% | 29.03 ± 18.3% | 10.44 ± 0.1% | 51.58 ± 3.2% | 443.98 ± 0.2% | 0.99 | 1.00 | 1.06 | 15.31 |
| other: a word between two words | 6104 | 683.05 ± 0.1% | 511.69 ± 1.3% | 16.80 ± 1.3% | 695.24 ± 0.4% | 96.73 ± 14.9% | 7.25 ± 0.5% | 56.79 ± 0.6% | 682.57 ± 0.4% | 1.33 | 1.00 | 0.98 | 7.06 |
| other: a number before a unit, second text | 1481 | 7127.00 ± 1.0% | 861.49 ± 0.4% | 18.85 ± 9.9% | 6442.87 ± 0.7% | 35.15 ± 2.8% | 10.91 ± 0.4% | 55.11 ± 0.4% | 7038.74 ± 1.1% | 8.27 | 1.01 | 1.11 | 202.75 |
| other: a heading's start tag | 110 | 18624.30 ± 1.1% | 654.19 ± 0.1% | 19.41 ± 2.5% | 2011.40 ± 2.1% | 1480.31 ± 3.8% | 10.00 ± 6.8% | 72.64 ± 0.7% | 18405.10 ± 1.9% | 28.47 | 1.01 | 9.26 | 12.58 |
| other: a whole word | 217 | 22914.26 ± 1.2% | 530.74 ± 0.1% | 20.06 ± 2.0% | 22710.49 ± 4.0% | 40.03 ± 0.7% | 9.46 ± 0.8% | 46.86 ± 1.0% | 22752.75 ± 1.7% | 43.17 | 1.01 | 1.01 | 572.48 |
| other: a line's first word, second text | 3716 | 1912.71 ± 6.2% | 513.99 ± 0.7% | 22.39 ± 1.0% | 1702.13 ± 3.1% | 53.28 ± 3.2% | refused | refused | 1910.35 ± 1.3% | 3.72 | 1.00 | 1.12 | 35.90 |
| other: fourteen octets before an x | 87 | 25977.83 ± 8.2% | 207.10 ± 2.1% | 5.14 ± 2.2% | 2985.87 ± 2.3% | 9.03 ± 0.2% | differs | 15.41 ± 1.9% | 25797.32 ± 6.4% | 125.44 | 1.01 | 8.70 | 2875.73 |
| other: a Greek word | 21815 | 387.71 ± 0.3% | 335.18 ± 0.3% | 23.74 ± 3.5% | 262.72 ± 0.5% | 45.78 ± 7.9% | differs | refused | 387.04 ± 0.3% | 1.16 | 1.00 | 1.48 | 8.47 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.52 ± 1.2% | 18.62 ± 0.4% | 0.79 ± 9.1% | 16.81 ± 0.7% | 2.34 ± 0.2% | differs | 3.61 ± 0.9% | 18.61 ± 2.2% | 0.99 | 1.00 | 1.10 | 7.90 |
| a UUID | 32895 | 20.41 ± 0.2% | 20.21 ± 10.1% | 0.55 ± 0.2% | 12.88 ± 0.4% | 2.49 ± 0.6% | 0.44 ± 0.2% | 3.05 ± 3.6% | 20.38 ± 0.4% | 1.01 | 1.00 | 1.59 | 8.20 |
| an IPv4 address | 33176 | 34.08 ± 7.3% | 34.02 ± 10.0% | 1.75 ± 0.4% | 24.12 ± 1.7% | 5.63 ± 3.4% | differs | 3.40 ± 0.5% | 34.13 ± 0.3% | 1.00 | 1.00 | 1.41 | 6.06 |
| a date and time | 32954 | 28.61 ± 7.7% | 29.97 ± 3.4% | 1.25 ± 10.4% | 18.08 ± 0.6% | 6.60 ± 0.2% | 0.75 ± 0.2% | 6.18 ± 0.4% | 30.22 ± 9.0% | 0.95 | 0.95 | 1.58 | 4.34 |
| a field path | 32606 | 21.78 ± 0.3% | 21.77 ± 1.3% | 0.89 ± 0.5% | 19.39 ± 0.4% | 2.92 ± 1.4% | differs | 2.46 ± 1.0% | 21.79 ± 0.6% | 1.00 | 1.00 | 1.12 | 7.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.55 ± 2.6% | 8.51 ± 6.7% | 8.50 ± 0.4% | 10.68 ± 0.1% | 4.76 ± 1.2% | 0.62 ± 0.3% | none | 8.48 ± 16.2% | 1.01 | 1.01 | 0.80 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 205.67 ± 0.4% | 205.97 ± 0.2% | 241.32 ± 0.7% | 79.36 ± 3.2% | 183.45 ± 0.4% | 546.82 ± 3.1% | 3992.28 ± 0.5% | 205.69 ± 2.8% | 1.00 | 1.00 | 2.59 | 1.12 |
| a UUID | 62 | 133.90 ± 0.9% | 134.29 ± 0.8% | 149.67 ± 2.5% | 46.63 ± 1.6% | 89.71 ± 1.0% | 201.85 ± 3.9% | 4132.84 ± 0.3% | 134.02 ± 0.8% | 1.00 | 1.00 | 2.87 | 1.49 |
| an IPv4 address | 29 | 377.28 ± 3.3% | 385.82 ± 2.5% | 526.81 ± 4.6% | 68.69 ± 3.7% | 113.82 ± 5.6% | 327.31 ± 4.1% | 7041.36 ± 1.8% | 377.70 ± 7.8% | 0.98 | 1.00 | 5.49 | 3.31 |
| a date and time | 56 | 282.01 ± 0.9% | 282.20 ± 0.2% | 348.54 ± 0.3% | 68.39 ± 8.8% | 123.03 ± 15.2% | 379.52 ± 6.8% | 4256.93 ± 0.7% | 282.22 ± 0.2% | 1.00 | 1.00 | 4.12 | 2.29 |
| a field path | 39 | 206.49 ± 1.5% | 206.68 ± 0.9% | 242.81 ± 0.6% | 74.37 ± 1.0% | 174.43 ± 0.8% | 590.70 ± 2.2% | 4788.54 ± 2.2% | 206.20 ± 1.9% | 1.00 | 1.00 | 2.78 | 1.18 |
| literal: a word | 7 | 592.12 ± 1.9% | 632.05 ± 2.7% | 1082.86 ± 1.9% | 486.70 ± 0.9% | 580.29 ± 1.4% | 1291.79 ± 0.6% | 25194.25 ± 1.0% | 589.60 ± 1.7% | 0.94 | 1.00 | 1.22 | 1.02 |
| literal: a word that is not there | 8 | 567.16 ± 0.3% | 611.65 ± 0.6% | 1019.83 ± 0.4% | 449.51 ± 1.6% | 560.61 ± 3.3% | 1210.90 ± 3.8% | 24092.85 ± 0.8% | 566.63 ± 0.4% | 0.93 | 1.00 | 1.26 | 1.01 |
| literal: one of four words | 26 | 217.18 ± 1.3% | 359.82 ± 8.1% | 476.68 ± 0.8% | 41.93 ± 0.5% | 219.75 ± 1.8% | 448.90 ± 7.9% | 11545.07 ± 1.5% | 217.10 ± 0.2% | 0.60 | 1.00 | 5.18 | 0.99 |
| literal: a word in any case | 11 | 412.82 ± 0.9% | 434.42 ± 0.7% | 612.99 ± 0.3% | 14.33 ± 1.8% | 602.53 ± 3.1% | refused | 19383.59 ± 1.1% | 413.56 ± 0.4% | 0.95 | 1.00 | 28.81 | 0.69 |
| literal: an href attribute | 12 | 325.24 ± 0.9% | 335.03 ± 1.1% | 436.26 ± 0.9% | 37.30 ± 0.6% | 430.57 ± 1.2% | 976.24 ± 0.6% | 18380.26 ± 2.5% | 323.89 ± 7.8% | 0.97 | 1.00 | 8.72 | 0.76 |
| literal: a word, second text | 10 | 524.16 ± 6.5% | 569.60 ± 0.3% | 911.95 ± 0.6% | 393.96 ± 0.7% | 484.08 ± 13.3% | 1052.29 ± 0.6% | 21802.80 ± 0.3% | 525.09 ± 0.9% | 0.92 | 1.00 | 1.33 | 1.08 |
| class: two capitalized words | 23 | 420.97 ± 8.7% | 449.99 ± 2.5% | 627.57 ± 13.4% | 95.76 ± 0.5% | 449.60 ± 2.9% | 948.62 ± 11.5% | 6373.35 ± 1.1% | 420.63 ± 2.9% | 0.94 | 1.00 | 4.40 | 0.94 |
| class: a word that ends in ing | 9 | 513.91 ± 0.5% | 573.05 ± 0.5% | 978.67 ± 1.9% | 112.66 ± 0.8% | 624.34 ± 1.0% | 1426.32 ± 0.4% | 15261.17 ± 0.7% | 513.40 ± 0.5% | 0.90 | 1.00 | 4.56 | 0.82 |
| class: a word in capitals | 16 | 442.47 ± 0.5% | 476.20 ± 1.4% | 768.19 ± 2.0% | 122.03 ± 0.4% | 646.97 ± 2.4% | 1294.95 ± 1.2% | 8365.22 ± 0.6% | 442.97 ± 1.3% | 0.93 | 1.00 | 3.63 | 0.68 |
| class: a number | 6 | 567.08 ± 0.8% | 622.00 ± 2.4% | 1165.28 ± 0.7% | 36.16 ± 1.4% | 1184.18 ± 2.6% | 2243.82 ± 0.3% | 20437.97 ± 0.6% | 566.37 ± 0.4% | 0.91 | 1.00 | 15.68 | 0.48 |
| class: two capitalized words, second text | 23 | 420.77 ± 2.4% | 450.49 ± 0.6% | 648.77 ± 2.1% | 96.27 ± 1.0% | 449.83 ± 2.3% | 974.12 ± 0.7% | 6394.05 ± 1.3% | 420.41 ± 0.8% | 0.93 | 1.00 | 4.37 | 0.94 |
| other: a word between two words | 13 | 505.85 ± 0.5% | 517.60 ± 0.6% | 795.36 ± 0.5% | 121.19 ± 1.0% | 434.07 ± 1.7% | 1040.68 ± 0.4% | 14081.79 ± 0.7% | 505.43 ± 0.5% | 0.98 | 1.00 | 4.17 | 1.17 |
| other: a number before a unit, second text | 15 | 378.42 ± 0.4% | 417.54 ± 1.3% | 580.57 ± 0.7% | 33.53 ± 3.0% | 540.35 ± 1.2% | 1161.57 ± 2.0% | 13930.49 ± 0.2% | 378.33 ± 0.4% | 0.91 | 1.00 | 11.29 | 0.70 |
| other: a heading's start tag | 13 | 335.43 ± 0.5% | 339.21 ± 0.8% | 445.33 ± 0.1% | 35.70 ± 0.6% | 523.80 ± 0.9% | 1116.22 ± 1.2% | 16269.98 ± 0.5% | 335.53 ± 1.0% | 0.99 | 1.00 | 9.40 | 0.64 |
| other: a whole word | 11 | 511.19 ± 0.9% | 539.95 ± 0.3% | 837.94 ± 0.3% | 108.75 ± 0.6% | 506.03 ± 9.6% | 1101.35 ± 12.9% | 20763.79 ± 0.6% | 511.34 ± 0.6% | 0.95 | 1.00 | 4.70 | 1.01 |
| other: a line's first word, second text | 17 | 490.68 ± 1.3% | 507.22 ± 1.6% | 809.78 ± 0.7% | 113.83 ± 9.6% | 594.15 ± 0.7% | refused | refused | 490.29 ± 0.5% | 0.97 | 1.00 | 4.31 | 0.83 |
| other: fourteen octets before an x | 16 | 87.17 ± 0.4% | 124.84 ± 0.3% | 142.12 ± 0.4% | 14.10 ± 0.6% | 391.68 ± 3.8% | 461.62 ± 1.4% | 11993.54 ± 1.4% | 87.17 ± 2.1% | 0.70 | 1.00 | 6.18 | 0.22 |
| other: a Greek word | 8 | 397.72 ± 0.2% | 546.69 ± 0.3% | 924.12 ± 0.8% | 47.36 ± 1.6% | 1147.06 ± 26.2% | 2288.67 ± 1.8% | refused | 395.99 ± 2.5% | 0.73 | 1.00 | 8.40 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21505.44 ± 10.2% | not timed | not timed | 26731.34 ± 1.1% | 1919.04 ± 23.0% | not timed | not timed | 21416.34 ± 2.0% | | 1.00 | 0.80 | 11.21 |
| 01-literal/sherlock-casei-en | 522 | 7602.89 ± 0.8% | not timed | not timed | 7037.31 ± 0.3% | 28.55 ± 0.9% | not timed | not timed | 7647.89 ± 1.2% | | 0.99 | 1.08 | 266.34 |
| 01-literal/sherlock-ru | 724 | 23143.90 ± 3.0% | not timed | not timed | 27919.24 ± 3.5% | 1033.75 ± 31.9% | not timed | not timed | 22380.90 ± 5.1% | | 1.03 | 0.83 | 22.39 |
| 01-literal/sherlock-casei-ru | 746 | 9429.31 ± 2.9% | not timed | not timed | 5437.28 ± 1.8% | 30.53 ± 9.2% | not timed | not timed | 8640.50 ± 2.0% | | 1.09 | 1.73 | 308.86 |
| 01-literal/sherlock-zh | 30 | 41132.76 ± 1.8% | not timed | not timed | 36749.98 ± 0.7% | 1264.25 ± 0.6% | not timed | not timed | 40861.88 ± 0.4% | | 1.01 | 1.12 | 32.54 |
| 02-literal-alternate/sherlock-en | 714 | 9615.03 ± 0.3% | not timed | not timed | 8928.90 ± 0.7% | 14.00 ± 27.4% | not timed | not timed | 9609.54 ± 8.5% | | 1.00 | 1.08 | 686.87 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1991.91 ± 0.1% | not timed | not timed | 1803.63 ± 0.7% | 9.49 ± 3.2% | not timed | not timed | 1973.41 ± 2.6% | | 1.01 | 1.10 | 209.82 |
| 02-literal-alternate/sherlock-ru | 899 | 7794.45 ± 13.5% | not timed | not timed | 4245.63 ± 0.2% | 19.48 ± 14.4% | not timed | not timed | 7825.95 ± 7.1% | | 1.00 | 1.84 | 400.10 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2060.51 ± 3.0% | not timed | not timed | 1046.55 ± 1.5% | 8.58 ± 1.0% | not timed | not timed | 2067.01 ± 0.3% | | 1.00 | 1.97 | 240.09 |
| 02-literal-alternate/sherlock-zh | 207 | 13921.33 ± 13.9% | not timed | not timed | 10454.15 ± 0.4% | 27.21 ± 4.3% | not timed | not timed | 13958.62 ± 0.3% | | 1.00 | 1.33 | 511.72 |
| 03-date/ascii | 111817 | 97.71 ± 2.1% | not timed | not timed | 84.96 ± 0.1% | 0.18 ± 2.4% | not timed | not timed | 97.35 ± 6.7% | | 1.00 | 1.15 | 543.04 |
| 04-ruff-noqa/real | 84 | 417.91 ± 0.2% | not timed | not timed | 441.04 ± 1.7% | 15.99 ± 0.3% | not timed | not timed | 419.35 ± 0.3% | | 1.00 | 0.95 | 26.13 |
| 04-ruff-noqa/tweaked | 44 | 476.41 ± 0.4% | not timed | not timed | 428.08 ± 10.8% | 294.25 ± 0.2% | not timed | not timed | 475.71 ± 1.1% | | 1.00 | 1.11 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.22 ± 1.8% | not timed | not timed | 4.14 ± 1.6% | 0.21 ± 4.5% | not timed | not timed | 3.21 ± 2.7% | | 1.00 | 0.78 | 15.00 |
| 06-cloud-flare-redos/original | 107 | 348.50 ± 3.8% | not timed | not timed | 191.76 ± 18.0% | 20.08 ± 0.8% | not timed | not timed | 347.12 ± 0.4% | | 1.00 | 1.82 | 17.35 |
| 06-cloud-flare-redos/simplified-short | 102 | 334.24 ± 0.2% | not timed | not timed | 192.57 ± 0.9% | 21.56 ± 10.3% | not timed | not timed | 334.21 ± 3.0% | | 1.00 | 1.74 | 15.50 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.02 ± 0.1% | not timed | not timed | 211.60 ± 1.4% | 24.21 ± 0.2% | not timed | not timed | 464.56 ± 1.6% | | 1.00 | 2.20 | 19.21 |
| 07-unicode-character-data/parse-line | 558784 | 196.60 ± 2.2% | not timed | not timed | 161.80 ± 0.2% | 36.99 ± 6.5% | not timed | not timed | 191.85 ± 1.8% | | 1.02 | 1.22 | 5.32 |
| 08-words/all-english | 56691 | 95.62 ± 0.3% | not timed | not timed | 74.35 ± 0.7% | 10.03 ± 5.5% | not timed | not timed | 94.51 ± 22.3% | | 1.01 | 1.29 | 9.54 |
| 08-words/long-english | 839 | 535.70 ± 0.2% | not timed | not timed | 515.27 ± 0.3% | 26.08 ± 9.1% | not timed | not timed | 535.72 ± 0.1% | | 1.00 | 1.04 | 20.54 |
| 09-aws-keys/full | 0 | 421.22 ± 0.1% | not timed | not timed | 446.34 ± 1.2% | 54.20 ± 5.1% | not timed | not timed | 425.39 ± 0.9% | | 0.99 | 0.94 | 7.77 |
| 09-aws-keys/quick | 0 | 785.89 ± 0.3% | not timed | not timed | 802.75 ± 1.1% | 331.56 ± 1.8% | not timed | not timed | 782.18 ± 8.4% | | 1.00 | 0.98 | 2.37 |
| 10-bounded-repeat/letters-en | 1833 | 485.63 ± 3.1% | not timed | not timed | 431.03 ± 0.3% | 16.87 ± 1.2% | not timed | not timed | 486.76 ± 0.6% | | 1.00 | 1.13 | 28.78 |
| 10-bounded-repeat/letters-ru | 3475 | 431.79 ± 0.6% | not timed | not timed | 405.75 ± 3.8% | 17.93 ± 46.0% | not timed | not timed | 430.52 ± 3.0% | | 1.00 | 1.06 | 24.08 |
| 10-bounded-repeat/context | 53 | 64.77 ± 0.9% | not timed | not timed | 56.75 ± 0.9% | 16.85 ± 2.5% | not timed | not timed | 64.38 ± 0.7% | | 1.01 | 1.14 | 3.84 |
| 10-bounded-repeat/capitals | 11 | 558.53 ± 8.0% | not timed | not timed | 532.91 ± 0.3% | 30.88 ± 0.3% | not timed | not timed | 557.90 ± 8.0% | | 1.00 | 1.05 | 18.09 |
| 11-unstructured-to-json/extract | 600 | 53.95 ± 0.7% | not timed | not timed | 62.45 ± 0.9% | 40.71 ± 1.7% | not timed | not timed | 51.49 ± 0.4% | | 1.05 | 0.86 | 1.32 |
| 12-dictionary/single | 1 | 463.83 ± 1.8% | not timed | not timed | 444.38 ± 0.3% | 0.33 ± 1.0% | not timed | not timed | 464.46 ± 0.3% | | 1.00 | 1.04 | 1384.65 |
| 14-quadratic/1x | 100 | 20.73 ± 1.2% | not timed | not timed | 9.10 ± 0.3% | 0.80 ± 0.5% | not timed | not timed | 20.83 ± 0.2% | | 1.00 | 2.28 | 25.91 |
| 14-quadratic/2x | 200 | 16.07 ± 0.7% | not timed | not timed | 4.92 ± 0.9% | 0.43 ± 2.7% | not timed | not timed | 16.00 ± 4.3% | | 1.00 | 3.27 | 37.25 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.7% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 1.5% | not timed | not timed | 5.61 ± 0.9% | | 1.00 | 5.34 | 60.67 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.19 ± 0.3% | not timed | not timed | 0.39 ± 1.0% | 0.48 ± 1.8% | not timed | not timed | 1.18 ± 2.2% | | 1.01 | 3.07 | 2.46 |
| 04-ruff-noqa/compile-real | 1 | 81.71 ± 0.4% | not timed | not timed | 12.77 ± 1.8% | 125.49 ± 1.8% | not timed | not timed | 85.54 ± 0.9% | | 0.96 | 6.40 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 12.71 ± 0.8% | not timed | not timed | 2.36 ± 0.9% | 5.91 ± 2.2% | not timed | not timed | 12.81 ± 0.4% | | 0.99 | 5.37 | 2.15 |
| 07-unicode-character-data/compile | 1 | 51.40 ± 0.4% | not timed | not timed | 24.20 ± 3.4% | 32.90 ± 2.2% | not timed | not timed | 51.49 ± 0.9% | | 1.00 | 2.12 | 1.56 |
| 09-aws-keys/compile-full | 1 | 35.00 ± 0.5% | not timed | not timed | 7.39 ± 2.8% | 20.78 ± 3.1% | not timed | not timed | 35.20 ± 1.1% | | 0.99 | 4.74 | 1.68 |
| 09-aws-keys/compile-quick | 1 | 143.54 ± 1.0% | not timed | not timed | 44.60 ± 0.6% | 119.56 ± 2.7% | not timed | not timed | 155.82 ± 1.9% | | 0.92 | 3.22 | 1.20 |
| 10-bounded-repeat/compile-context | 1 | 10.60 ± 0.8% | not timed | not timed | 11.68 ± 0.4% | 15.17 ± 4.1% | not timed | not timed | 10.62 ± 1.6% | | 1.00 | 0.91 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 72.00 ± 1.8% | not timed | not timed | 8.79 ± 1.1% | 22.33 ± 1.7% | not timed | not timed | 72.17 ± 1.5% | | 1.00 | 8.19 | 3.23 |
| 11-unstructured-to-json/compile | 1 | 76.40 ± 0.8% | not timed | not timed | 36.83 ± 18.1% | 60.69 ± 2.3% | not timed | not timed | 76.82 ± 6.9% | | 0.99 | 2.07 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.5% | not timed | not timed | 0.07 ± 1.6% | 0.08 ± 23.6% | not timed | not timed | 0.29 ± 3.3% | | 1.01 | 4.17 | 3.47 |

