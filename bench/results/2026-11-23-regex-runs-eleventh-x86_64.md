# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148097561 |
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
| literal: a word | 217 | 27714.70 ± 36.1% | 817.08 ± 0.8% | 26.39 ± 1.4% | 25833.33 ± 0.8% | 8487.59 ± 6.4% | 12.48 ± 0.1% | 87.29 ± 0.7% | 27437.18 ± 29.7% | 33.92 | 1.01 | 1.07 | 3.27 |
| literal: a word that is not there | 0 | 34023.67 ± 0.4% | 830.27 ± 1.2% | 26.38 ± 1.4% | 28756.05 ± 0.1% | 23534.29 ± 1.8% | 12.21 ± 0.2% | 82.46 ± 0.5% | 33901.85 ± 0.3% | 40.98 | 1.00 | 1.18 | 1.45 |
| literal: one of four words | 661 | 10779.72 ± 1.6% | 803.27 ± 0.2% | 14.22 ± 0.9% | 7885.90 ± 0.6% | 21.19 ± 0.2% | 3.74 ± 0.5% | 6.45 ± 3.1% | 10570.30 ± 2.0% | 13.42 | 1.02 | 1.37 | 508.64 |
| literal: a word in any case | 217 | 23177.60 ± 2.0% | 818.19 ± 0.2% | 18.97 ± 5.3% | 8154.32 ± 3.0% | 40.79 ± 3.9% | refused | differs | 23068.73 ± 1.1% | 28.33 | 1.00 | 2.84 | 568.22 |
| literal: an href attribute | 33 | 23318.41 ± 0.4% | 822.91 ± 0.3% | 23.80 ± 0.9% | 23767.22 ± 0.4% | 1905.57 ± 0.6% | 9.06 ± 1.6% | 77.18 ± 1.0% | 23213.11 ± 2.2% | 28.34 | 1.00 | 0.98 | 12.24 |
| literal: a word, second text | 123 | 29534.21 ± 0.4% | 818.74 ± 0.5% | 25.71 ± 1.3% | 25847.37 ± 0.6% | 6666.12 ± 8.8% | 15.30 ± 0.3% | 75.39 ± 0.7% | 29428.37 ± 0.6% | 36.07 | 1.00 | 1.14 | 4.43 |
| class: two capitalized words | 1331 | 844.49 ± 0.4% | 768.49 ± 0.9% | 23.34 ± 0.8% | 546.34 ± 0.2% | 36.60 ± 6.0% | 10.61 ± 0.4% | 64.92 ± 3.3% | 859.35 ± 2.1% | 1.10 | 0.98 | 1.55 | 23.08 |
| class: a word that ends in ing | 3399 | 715.04 ± 0.8% | 711.58 ± 0.5% | 16.17 ± 0.5% | 503.49 ± 1.7% | 26.98 ± 7.8% | 5.86 ± 1.1% | 18.55 ± 3.1% | 715.79 ± 0.6% | 1.00 | 1.00 | 1.42 | 26.50 |
| class: a word in capitals | 2332 | 1141.14 ± 0.5% | 753.95 ± 0.4% | 25.60 ± 0.6% | 536.26 ± 0.3% | 39.32 ± 2.8% | 12.48 ± 0.3% | 77.95 ± 1.7% | 1133.63 ± 0.5% | 1.51 | 1.01 | 2.13 | 29.02 |
| class: a number | 8288 | 1580.77 ± 0.5% | 667.66 ± 1.7% | 25.63 ± 0.3% | 1640.02 ± 0.6% | 36.88 ± 11.7% | 0.37 ± 0.2% | 60.71 ± 0.4% | 1577.72 ± 0.4% | 2.37 | 1.00 | 0.96 | 42.87 |
| class: two capitalized words, second text | 5359 | 597.76 ± 0.5% | 592.94 ± 0.9% | 21.95 ± 0.3% | 440.78 ± 0.8% | 30.34 ± 10.7% | 13.22 ± 0.6% | 59.97 ± 0.5% | 598.24 ± 0.4% | 1.01 | 1.00 | 1.36 | 19.70 |
| other: a word between two words | 6104 | 730.12 ± 2.3% | 617.20 ± 0.6% | 21.56 ± 3.3% | 691.52 ± 0.3% | 99.00 ± 11.5% | 8.14 ± 0.3% | 69.37 ± 0.3% | 722.00 ± 0.3% | 1.18 | 1.01 | 1.06 | 7.38 |
| other: a number before a unit, second text | 1481 | 7353.92 ± 4.8% | 781.32 ± 2.2% | 24.31 ± 3.5% | 7030.83 ± 0.5% | 37.02 ± 5.3% | 13.91 ± 0.1% | 62.86 ± 8.0% | 7168.78 ± 0.6% | 9.41 | 1.03 | 1.05 | 198.63 |
| other: a heading's start tag | 110 | 18805.04 ± 0.5% | 818.84 ± 0.4% | 25.38 ± 1.4% | 2027.04 ± 0.8% | 1371.41 ± 2.8% | 11.20 ± 0.3% | 89.30 ± 0.8% | 18687.84 ± 0.4% | 22.97 | 1.01 | 9.28 | 13.71 |
| other: a whole word | 217 | 21054.80 ± 0.5% | 819.88 ± 0.9% | 27.13 ± 1.3% | 19751.78 ± 0.4% | 46.23 ± 1.5% | 10.71 ± 1.6% | 50.88 ± 0.9% | 20978.19 ± 0.7% | 25.68 | 1.00 | 1.07 | 455.44 |
| other: a line's first word, second text | 3716 | 2026.59 ± 1.1% | 705.43 ± 0.6% | 27.30 ± 0.9% | 1890.97 ± 0.6% | 59.96 ± 6.4% | refused | refused | 2023.25 ± 1.1% | 2.87 | 1.00 | 1.07 | 33.80 |
| other: fourteen octets before an x | 87 | 28010.42 ± 2.0% | 243.81 ± 1.0% | 6.12 ± 3.6% | 3614.15 ± 0.7% | 9.12 ± 0.5% | differs | 16.44 ± 0.6% | 27999.45 ± 3.5% | 114.89 | 1.00 | 7.75 | 3072.41 |
| other: a Greek word | 21815 | 444.05 ± 0.9% | 351.17 ± 1.1% | 29.07 ± 2.6% | 261.80 ± 0.7% | 47.11 ± 10.9% | differs | refused | 442.43 ± 0.9% | 1.26 | 1.00 | 1.70 | 9.43 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.34 ± 1.0% | 23.13 ± 0.6% | 0.87 ± 1.5% | 18.56 ± 0.2% | 2.41 ± 0.4% | differs | 4.09 ± 2.2% | 22.30 ± 0.3% | 1.01 | 1.05 | 1.26 | 9.68 |
| a UUID | 32895 | 19.04 ± 0.4% | 19.08 ± 0.6% | 0.60 ± 0.6% | 14.32 ± 0.6% | 2.48 ± 3.9% | 0.54 ± 0.7% | 3.20 ± 5.7% | 19.16 ± 0.3% | 1.00 | 0.99 | 1.33 | 7.68 |
| an IPv4 address | 33176 | 32.18 ± 1.4% | 32.32 ± 0.3% | 1.96 ± 1.3% | 26.39 ± 0.5% | 5.94 ± 0.6% | differs | 3.83 ± 1.4% | 32.41 ± 0.6% | 1.00 | 0.99 | 1.22 | 5.42 |
| a date and time | 32954 | 26.18 ± 0.2% | 27.49 ± 0.6% | 1.38 ± 2.4% | 20.25 ± 0.1% | 7.18 ± 0.5% | 0.95 ± 0.1% | 7.29 ± 2.0% | 27.57 ± 0.6% | 0.95 | 0.95 | 1.29 | 3.65 |
| a field path | 32606 | 25.72 ± 0.4% | 26.02 ± 0.4% | 0.98 ± 0.6% | 21.26 ± 0.3% | 2.84 ± 1.5% | differs | 2.59 ± 1.9% | 25.93 ± 4.2% | 0.99 | 0.99 | 1.21 | 9.05 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.00 ± 1.1% | 8.06 ± 0.2% | 8.06 ± 0.1% | 11.46 ± 0.3% | 4.62 ± 1.6% | 0.76 ± 1.3% | none | 8.06 ± 1.4% | 0.99 | 0.99 | 0.70 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.21 ± 7.7% | 225.28 ± 0.4% | 264.91 ± 0.7% | 86.08 ± 10.3% | 176.53 ± 1.5% | 525.45 ± 8.7% | 3472.08 ± 0.4% | 225.09 ± 0.3% | 1.00 | 1.00 | 2.62 | 1.28 |
| a UUID | 62 | 148.96 ± 0.5% | 149.86 ± 9.6% | 166.86 ± 1.8% | 46.63 ± 2.7% | 85.06 ± 16.3% | 191.39 ± 2.8% | 4254.89 ± 10.4% | 149.10 ± 0.2% | 0.99 | 1.00 | 3.19 | 1.75 |
| an IPv4 address | 29 | 423.64 ± 0.9% | 428.28 ± 0.2% | 589.61 ± 0.5% | 74.03 ± 0.8% | 107.50 ± 13.5% | 322.01 ± 2.1% | 7164.80 ± 1.5% | 424.12 ± 0.6% | 0.99 | 1.00 | 5.72 | 3.94 |
| a date and time | 56 | 329.09 ± 0.6% | 332.13 ± 0.2% | 422.28 ± 0.2% | 73.50 ± 0.3% | 115.33 ± 3.4% | 347.00 ± 1.3% | 4354.60 ± 9.8% | 329.25 ± 0.5% | 0.99 | 1.00 | 4.48 | 2.85 |
| a field path | 39 | 225.43 ± 0.3% | 226.65 ± 0.6% | 264.96 ± 1.0% | 80.53 ± 9.2% | 168.78 ± 3.8% | 568.86 ± 0.9% | 4356.91 ± 0.9% | 224.62 ± 10.0% | 0.99 | 1.00 | 2.80 | 1.34 |
| literal: a word | 7 | 660.62 ± 8.3% | 715.73 ± 0.4% | 1270.65 ± 0.4% | 503.73 ± 0.9% | 531.47 ± 2.0% | 1180.88 ± 2.7% | 26292.01 ± 0.6% | 660.52 ± 2.0% | 0.92 | 1.00 | 1.31 | 1.24 |
| literal: a word that is not there | 8 | 631.17 ± 0.4% | 688.97 ± 1.1% | 1195.10 ± 0.5% | 463.28 ± 1.2% | 511.12 ± 3.2% | 1119.49 ± 1.2% | 25592.75 ± 0.8% | 630.12 ± 0.4% | 0.92 | 1.00 | 1.36 | 1.23 |
| literal: one of four words | 26 | 253.67 ± 1.0% | 406.29 ± 0.6% | 554.60 ± 2.5% | 40.81 ± 4.1% | 201.25 ± 7.2% | 419.35 ± 4.3% | 14126.66 ± 4.8% | 252.93 ± 2.1% | 0.62 | 1.00 | 6.22 | 1.26 |
| literal: a word in any case | 11 | 535.89 ± 0.3% | 578.56 ± 1.0% | 896.03 ± 0.2% | 13.83 ± 0.7% | 547.99 ± 1.0% | refused | 20628.57 ± 1.4% | 536.37 ± 0.5% | 0.93 | 1.00 | 38.74 | 0.98 |
| literal: an href attribute | 12 | 348.10 ± 0.7% | 360.12 ± 0.3% | 471.72 ± 0.3% | 37.75 ± 0.2% | 407.27 ± 2.6% | 904.97 ± 0.4% | 19643.45 ± 1.5% | 347.77 ± 0.4% | 0.97 | 1.00 | 9.22 | 0.85 |
| literal: a word, second text | 10 | 582.88 ± 0.8% | 646.21 ± 0.3% | 1073.63 ± 2.7% | 422.74 ± 0.4% | 441.77 ± 2.7% | 945.25 ± 1.3% | 24207.03 ± 0.3% | 583.75 ± 1.6% | 0.90 | 1.00 | 1.38 | 1.32 |
| class: two capitalized words | 23 | 467.64 ± 0.2% | 499.60 ± 0.8% | 725.82 ± 1.7% | 102.78 ± 0.4% | 422.53 ± 3.5% | 859.80 ± 1.0% | 5641.10 ± 1.7% | 466.27 ± 3.2% | 0.94 | 1.00 | 4.55 | 1.11 |
| class: a word that ends in ing | 9 | 588.04 ± 2.6% | 664.86 ± 4.0% | 1152.63 ± 0.6% | 128.45 ± 0.9% | 602.22 ± 4.2% | 1305.65 ± 5.7% | 14132.96 ± 3.5% | 587.27 ± 0.7% | 0.88 | 1.00 | 4.58 | 0.98 |
| class: a word in capitals | 16 | 549.38 ± 0.4% | 597.61 ± 0.1% | 972.01 ± 0.4% | 134.80 ± 1.2% | 615.00 ± 16.6% | 1177.07 ± 6.3% | 7414.63 ± 8.0% | 548.86 ± 1.0% | 0.92 | 1.00 | 4.08 | 0.89 |
| class: a number | 6 | 669.71 ± 0.5% | 736.88 ± 6.3% | 1360.14 ± 12.2% | 36.22 ± 0.8% | 1114.66 ± 12.4% | 2217.48 ± 14.0% | 20155.17 ± 0.6% | 670.03 ± 0.1% | 0.91 | 1.00 | 18.49 | 0.60 |
| class: two capitalized words, second text | 23 | 468.52 ± 7.3% | 499.71 ± 0.4% | 727.88 ± 0.7% | 102.31 ± 5.6% | 420.69 ± 2.8% | 889.88 ± 0.4% | 5650.12 ± 5.7% | 468.16 ± 1.4% | 0.94 | 1.00 | 4.58 | 1.11 |
| other: a word between two words | 13 | 568.78 ± 0.5% | 587.16 ± 1.1% | 929.34 ± 0.4% | 137.25 ± 1.3% | 417.58 ± 2.4% | 960.95 ± 3.7% | 13308.23 ± 0.5% | 569.58 ± 2.7% | 0.97 | 1.00 | 4.14 | 1.36 |
| other: a number before a unit, second text | 15 | 420.74 ± 0.3% | 468.59 ± 6.7% | 666.48 ± 0.4% | 33.69 ± 1.0% | 511.71 ± 1.2% | 1055.64 ± 2.0% | 14067.43 ± 0.7% | 419.36 ± 1.7% | 0.90 | 1.00 | 12.49 | 0.82 |
| other: a heading's start tag | 13 | 366.07 ± 2.5% | 373.59 ± 0.3% | 491.35 ± 1.2% | 36.45 ± 13.5% | 466.96 ± 10.9% | 1020.11 ± 1.6% | 16164.34 ± 0.8% | 366.09 ± 0.2% | 0.98 | 1.00 | 10.04 | 0.78 |
| other: a whole word | 11 | 580.63 ± 0.4% | 626.78 ± 0.6% | 1021.86 ± 0.2% | 120.78 ± 1.1% | 466.79 ± 2.9% | 1005.76 ± 1.1% | 23055.25 ± 7.8% | 581.19 ± 0.6% | 0.93 | 1.00 | 4.81 | 1.24 |
| other: a line's first word, second text | 17 | 565.39 ± 0.6% | 600.03 ± 0.4% | 975.85 ± 0.3% | 128.98 ± 2.3% | 568.21 ± 18.8% | refused | refused | 563.00 ± 9.6% | 0.94 | 1.00 | 4.38 | 1.00 |
| other: fourteen octets before an x | 16 | 92.60 ± 0.4% | 140.12 ± 0.4% | 165.35 ± 0.2% | 15.19 ± 1.0% | 364.95 ± 20.1% | 443.56 ± 2.0% | 11333.08 ± 0.8% | 92.55 ± 4.6% | 0.66 | 1.00 | 6.09 | 0.25 |
| other: a Greek word | 8 | 444.37 ± 1.7% | 594.75 ± 0.4% | 953.09 ± 0.8% | 45.50 ± 0.1% | 1082.54 ± 3.7% | 2078.09 ± 1.4% | refused | 444.52 ± 0.8% | 0.75 | 1.00 | 9.77 | 0.41 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20893.20 ± 2.0% | not timed | not timed | 22435.68 ± 0.8% | 1838.74 ± 15.9% | not timed | not timed | 20935.53 ± 0.8% | | 1.00 | 0.93 | 11.36 |
| 01-literal/sherlock-casei-en | 522 | 6531.66 ± 3.1% | not timed | not timed | 6885.90 ± 0.2% | 29.32 ± 12.5% | not timed | not timed | 6483.93 ± 1.9% | | 1.01 | 0.95 | 222.74 |
| 01-literal/sherlock-ru | 724 | 20418.04 ± 0.9% | not timed | not timed | 21094.02 ± 0.9% | 1126.10 ± 10.2% | not timed | not timed | 20371.03 ± 0.9% | | 1.00 | 0.97 | 18.13 |
| 01-literal/sherlock-casei-ru | 746 | 7330.28 ± 0.2% | not timed | not timed | 5522.39 ± 0.9% | 31.61 ± 14.0% | not timed | not timed | 7300.72 ± 7.6% | | 1.00 | 1.33 | 231.88 |
| 01-literal/sherlock-zh | 30 | 32770.60 ± 0.3% | not timed | not timed | 27731.06 ± 0.1% | 1100.22 ± 0.9% | not timed | not timed | 32809.72 ± 0.2% | | 1.00 | 1.18 | 29.79 |
| 02-literal-alternate/sherlock-en | 714 | 9980.56 ± 1.7% | not timed | not timed | 7726.09 ± 0.7% | 16.22 ± 2.4% | not timed | not timed | 9943.22 ± 0.8% | | 1.00 | 1.29 | 615.48 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1793.78 ± 3.2% | not timed | not timed | 2047.98 ± 0.3% | 9.89 ± 0.6% | not timed | not timed | 1786.03 ± 0.5% | | 1.00 | 0.88 | 181.42 |
| 02-literal-alternate/sherlock-ru | 899 | 6158.82 ± 0.3% | not timed | not timed | 4424.36 ± 2.7% | 21.50 ± 8.3% | not timed | not timed | 6137.81 ± 0.6% | | 1.00 | 1.39 | 286.46 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1899.22 ± 0.6% | not timed | not timed | 1055.92 ± 1.1% | 8.81 ± 2.7% | not timed | not timed | 1881.89 ± 0.4% | | 1.01 | 1.80 | 215.54 |
| 02-literal-alternate/sherlock-zh | 207 | 13511.09 ± 9.9% | not timed | not timed | 8862.60 ± 0.3% | 30.48 ± 10.1% | not timed | not timed | 13369.84 ± 2.0% | | 1.01 | 1.52 | 443.30 |
| 03-date/ascii | 111817 | 102.08 ± 2.2% | not timed | not timed | 90.99 ± 1.9% | 0.17 ± 3.2% | not timed | not timed | 103.40 ± 2.1% | | 0.99 | 1.12 | 603.68 |
| 04-ruff-noqa/real | 84 | 556.27 ± 0.6% | not timed | not timed | 451.96 ± 0.4% | 17.42 ± 0.9% | not timed | not timed | 553.70 ± 0.6% | | 1.00 | 1.23 | 31.94 |
| 04-ruff-noqa/tweaked | 44 | 454.60 ± 0.4% | not timed | not timed | 443.28 ± 0.7% | 298.96 ± 0.9% | not timed | not timed | 451.31 ± 0.5% | | 1.01 | 1.03 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.51 ± 1.2% | not timed | not timed | 4.53 ± 0.4% | 0.21 ± 6.8% | not timed | not timed | 3.49 ± 2.0% | | 1.00 | 0.77 | 16.90 |
| 06-cloud-flare-redos/original | 107 | 250.42 ± 0.2% | not timed | not timed | 198.49 ± 0.6% | 22.61 ± 0.4% | not timed | not timed | 248.02 ± 0.6% | | 1.01 | 1.26 | 11.08 |
| 06-cloud-flare-redos/simplified-short | 102 | 246.92 ± 0.2% | not timed | not timed | 207.48 ± 0.7% | 24.95 ± 2.0% | not timed | not timed | 246.23 ± 0.4% | | 1.00 | 1.19 | 9.90 |
| 06-cloud-flare-redos/simplified-long | 10000 | 262.27 ± 0.2% | not timed | not timed | 229.15 ± 1.3% | 27.71 ± 0.8% | not timed | not timed | 262.16 ± 0.2% | | 1.00 | 1.14 | 9.46 |
| 07-unicode-character-data/parse-line | 558784 | 189.77 ± 1.0% | not timed | not timed | 158.85 ± 0.5% | 36.53 ± 6.5% | not timed | not timed | 188.08 ± 1.9% | | 1.01 | 1.19 | 5.19 |
| 08-words/all-english | 56691 | 97.02 ± 9.5% | not timed | not timed | 75.98 ± 0.9% | 10.20 ± 12.4% | not timed | not timed | 91.29 ± 1.2% | | 1.06 | 1.28 | 9.51 |
| 08-words/long-english | 839 | 787.90 ± 0.9% | not timed | not timed | 554.07 ± 0.7% | 28.45 ± 0.4% | not timed | not timed | 786.65 ± 0.3% | | 1.00 | 1.42 | 27.69 |
| 09-aws-keys/full | 0 | 445.83 ± 0.3% | not timed | not timed | 445.73 ± 0.3% | 57.14 ± 3.4% | not timed | not timed | 427.00 ± 6.9% | | 1.04 | 1.00 | 7.80 |
| 09-aws-keys/quick | 0 | 826.22 ± 6.3% | not timed | not timed | 790.09 ± 1.9% | 338.57 ± 12.4% | not timed | not timed | 825.88 ± 0.6% | | 1.00 | 1.05 | 2.44 |
| 10-bounded-repeat/letters-en | 1833 | 518.39 ± 0.8% | not timed | not timed | 481.82 ± 2.4% | 18.11 ± 0.9% | not timed | not timed | 505.85 ± 1.5% | | 1.02 | 1.08 | 28.62 |
| 10-bounded-repeat/letters-ru | 3475 | 320.78 ± 3.9% | not timed | not timed | 430.94 ± 1.6% | 20.58 ± 15.2% | not timed | not timed | 318.28 ± 0.3% | | 1.01 | 0.74 | 15.59 |
| 10-bounded-repeat/context | 53 | 71.41 ± 1.5% | not timed | not timed | 58.46 ± 1.3% | 18.51 ± 2.6% | not timed | not timed | 71.16 ± 5.9% | | 1.00 | 1.22 | 3.86 |
| 10-bounded-repeat/capitals | 11 | 827.12 ± 0.7% | not timed | not timed | 576.47 ± 0.5% | 33.31 ± 0.8% | not timed | not timed | 824.29 ± 0.8% | | 1.00 | 1.43 | 24.83 |
| 11-unstructured-to-json/extract | 600 | 42.41 ± 0.2% | not timed | not timed | 69.14 ± 0.4% | 44.93 ± 0.7% | not timed | not timed | 42.14 ± 0.5% | | 1.01 | 0.61 | 0.94 |
| 12-dictionary/single | 1 | 455.71 ± 0.2% | not timed | not timed | 503.09 ± 0.2% | 0.27 ± 2.3% | not timed | not timed | 456.71 ± 0.2% | | 1.00 | 0.91 | 1717.26 |
| 14-quadratic/1x | 100 | 8.35 ± 0.3% | not timed | not timed | 11.82 ± 0.2% | 0.90 ± 3.7% | not timed | not timed | 8.29 ± 1.8% | | 1.01 | 0.71 | 9.29 |
| 14-quadratic/2x | 200 | 4.79 ± 0.2% | not timed | not timed | 5.92 ± 4.9% | 0.49 ± 0.8% | not timed | not timed | 4.77 ± 0.2% | | 1.00 | 0.81 | 9.72 |
| 14-quadratic/10x | 1000 | 1.08 ± 1.5% | not timed | not timed | 1.15 ± 1.5% | 0.11 ± 1.9% | not timed | not timed | 1.08 ± 0.4% | | 1.00 | 0.94 | 10.02 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.57 ± 5.8% | not timed | not timed | 0.35 ± 1.9% | 0.47 ± 3.2% | not timed | not timed | 1.57 ± 2.3% | | 1.00 | 4.53 | 3.37 |
| 04-ruff-noqa/compile-real | 1 | 101.48 ± 0.2% | not timed | not timed | 12.22 ± 2.7% | 118.45 ± 1.9% | not timed | not timed | 100.81 ± 2.5% | | 1.01 | 8.30 | 0.86 |
| 05-lexer-veryl/compile-single | 1 | 15.30 ± 0.1% | not timed | not timed | 2.40 ± 1.2% | 5.65 ± 2.2% | not timed | not timed | 15.26 ± 0.5% | | 1.00 | 6.38 | 2.71 |
| 07-unicode-character-data/compile | 1 | 57.54 ± 0.6% | not timed | not timed | 24.94 ± 1.0% | 30.81 ± 8.1% | not timed | not timed | 57.41 ± 1.9% | | 1.00 | 2.31 | 1.87 |
| 09-aws-keys/compile-full | 1 | 37.60 ± 0.8% | not timed | not timed | 7.25 ± 1.0% | 19.79 ± 1.6% | not timed | not timed | 37.13 ± 1.5% | | 1.01 | 5.18 | 1.90 |
| 09-aws-keys/compile-quick | 1 | 178.49 ± 2.3% | not timed | not timed | 47.59 ± 0.7% | 110.29 ± 4.0% | not timed | not timed | 176.96 ± 1.1% | | 1.01 | 3.75 | 1.62 |
| 10-bounded-repeat/compile-context | 1 | 11.76 ± 0.2% | not timed | not timed | 11.36 ± 0.5% | 13.65 ± 6.6% | not timed | not timed | 11.68 ± 0.8% | | 1.01 | 1.04 | 0.86 |
| 10-bounded-repeat/compile-capitals | 1 | 70.60 ± 0.2% | not timed | not timed | 8.48 ± 0.3% | 20.09 ± 4.9% | not timed | not timed | 70.56 ± 1.6% | | 1.00 | 8.32 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 86.71 ± 0.3% | not timed | not timed | 36.91 ± 0.7% | 58.84 ± 3.4% | not timed | not timed | 85.76 ± 1.6% | | 1.01 | 2.35 | 1.47 |
| 12-dictionary/compile-single | 1 | 0.29 ± 3.6% | not timed | not timed | 0.06 ± 21.3% | 0.08 ± 24.5% | not timed | not timed | 0.28 ± 5.6% | | 1.01 | 4.92 | 3.66 |

