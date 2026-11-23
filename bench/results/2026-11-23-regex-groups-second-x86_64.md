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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215329391 |
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
| literal: a word | 217 | 33348.70 ± 2.2% | 3361.93 ± 0.8% | 20.06 ± 0.3% | 31314.67 ± 3.1% | 9038.51 ± 8.9% | 10.77 ± 0.2% | 75.74 ± 1.5% | 32688.91 ± 1.9% | 9.92 | 1.02 | 1.06 | 3.69 |
| literal: a word that is not there | 0 | 49600.42 ± 1.0% | 3252.69 ± 0.4% | 20.11 ± 0.7% | 39533.87 ± 1.7% | 30213.86 ± 0.5% | 10.72 ± 0.4% | 71.38 ± 0.8% | 49325.81 ± 1.9% | 15.25 | 1.01 | 1.25 | 1.64 |
| literal: one of four words | 661 | 11201.04 ± 2.3% | 1401.59 ± 0.2% | 10.92 ± 2.9% | 9089.70 ± 0.5% | 19.32 ± 1.8% | 3.96 ± 0.4% | 6.67 ± 3.3% | 11180.33 ± 1.0% | 7.99 | 1.00 | 1.23 | 579.75 |
| literal: a word in any case | 217 | 26041.69 ± 0.5% | 1496.75 ± 0.5% | 15.45 ± 5.6% | 9231.68 ± 1.3% | 37.32 ± 0.1% | refused | differs | 25998.61 ± 1.7% | 17.40 | 1.00 | 2.82 | 697.86 |
| literal: an href attribute | 33 | 27111.34 ± 4.8% | 538.62 ± 0.2% | 18.53 ± 0.7% | 27451.02 ± 5.4% | 2058.75 ± 1.2% | 8.27 ± 0.1% | 61.11 ± 10.1% | 27283.02 ± 1.3% | 50.33 | 0.99 | 0.99 | 13.17 |
| literal: a word, second text | 123 | 34194.61 ± 0.4% | 2390.06 ± 0.8% | 19.94 ± 0.2% | 32096.75 ± 0.5% | 7038.22 ± 6.1% | 11.69 ± 0.1% | 64.55 ± 1.4% | 34217.11 ± 7.7% | 14.31 | 1.00 | 1.07 | 4.86 |
| class: two capitalized words | 1331 | 770.85 ± 0.1% | 525.37 ± 0.3% | 18.66 ± 2.8% | 506.05 ± 0.1% | 34.16 ± 11.0% | 9.39 ± 0.1% | 55.65 ± 1.2% | 771.10 ± 2.2% | 1.47 | 1.00 | 1.52 | 22.57 |
| class: a word that ends in ing | 3399 | 498.81 ± 0.2% | 497.68 ± 0.5% | 12.99 ± 0.3% | 472.87 ± 0.3% | 25.57 ± 5.8% | 5.32 ± 0.4% | 17.25 ± 1.0% | 498.59 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.51 |
| class: a word in capitals | 2332 | 956.33 ± 0.3% | 529.20 ± 0.9% | 19.70 ± 1.0% | 498.46 ± 0.8% | 36.58 ± 14.2% | 10.48 ± 0.3% | 76.40 ± 2.0% | 955.91 ± 0.2% | 1.81 | 1.00 | 1.92 | 26.14 |
| class: a number | 8288 | 1467.09 ± 1.8% | 699.82 ± 1.6% | 19.69 ± 8.5% | 1350.69 ± 2.9% | 35.86 ± 13.6% | 0.34 ± 0.3% | 55.76 ± 1.6% | 1465.55 ± 2.3% | 2.10 | 1.00 | 1.09 | 40.91 |
| class: two capitalized words, second text | 5359 | 441.99 ± 0.6% | 448.31 ± 1.0% | 15.53 ± 0.1% | 417.28 ± 0.5% | 29.21 ± 10.1% | 10.63 ± 0.2% | 51.52 ± 1.3% | 441.65 ± 0.6% | 0.99 | 1.00 | 1.06 | 15.13 |
| other: a word between two words | 6104 | 688.87 ± 0.1% | 511.86 ± 0.5% | 16.81 ± 1.4% | 685.24 ± 0.2% | 100.98 ± 7.8% | 7.27 ± 0.2% | 56.50 ± 1.2% | 689.79 ± 0.2% | 1.35 | 1.00 | 1.01 | 6.82 |
| other: a number before a unit, second text | 1481 | 7122.84 ± 1.5% | 862.42 ± 0.6% | 18.79 ± 0.4% | 6448.79 ± 0.4% | 35.24 ± 7.2% | 11.04 ± 0.2% | 55.12 ± 0.4% | 7140.05 ± 1.1% | 8.26 | 1.00 | 1.10 | 202.15 |
| other: a heading's start tag | 110 | 19090.98 ± 0.4% | 653.95 ± 0.5% | 19.47 ± 0.4% | 2007.56 ± 1.0% | 1481.02 ± 17.7% | 10.06 ± 0.5% | 72.72 ± 6.1% | 19066.05 ± 0.7% | 29.19 | 1.00 | 9.51 | 12.89 |
| other: a whole word | 217 | 23399.99 ± 2.0% | 530.99 ± 26.4% | 20.69 ± 3.2% | 22697.65 ± 0.3% | 39.90 ± 2.1% | 9.55 ± 0.2% | 47.22 ± 0.5% | 23061.88 ± 3.3% | 44.07 | 1.01 | 1.03 | 586.51 |
| other: a line's first word, second text | 3716 | 1909.65 ± 0.8% | 513.46 ± 0.2% | 24.20 ± 0.5% | 1705.20 ± 1.5% | 53.05 ± 7.1% | refused | refused | 1908.12 ± 0.7% | 3.72 | 1.00 | 1.12 | 36.00 |
| other: fourteen octets before an x | 87 | 26108.17 ± 1.1% | 204.28 ± 1.5% | 5.23 ± 0.3% | 2717.64 ± 0.4% | 8.99 ± 0.6% | differs | 15.52 ± 1.7% | 26131.06 ± 0.8% | 127.81 | 1.00 | 9.61 | 2905.63 |
| other: a Greek word | 21815 | 385.26 ± 3.8% | 333.90 ± 0.4% | 24.06 ± 0.2% | 264.12 ± 4.1% | 44.32 ± 13.6% | differs | refused | 386.02 ± 2.0% | 1.15 | 1.00 | 1.46 | 8.69 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.65 ± 2.5% | 18.60 ± 0.4% | 0.79 ± 9.3% | 16.80 ± 3.6% | 2.15 ± 0.3% | differs | 3.63 ± 0.7% | 18.62 ± 0.4% | 1.00 | 1.00 | 1.11 | 8.66 |
| a UUID | 32895 | 20.33 ± 4.0% | 20.12 ± 5.9% | 0.55 ± 0.2% | 12.84 ± 1.6% | 2.51 ± 0.6% | 0.43 ± 0.7% | 3.10 ± 0.4% | 20.43 ± 0.2% | 1.01 | 1.00 | 1.58 | 8.09 |
| an IPv4 address | 33176 | 34.05 ± 0.5% | 33.99 ± 0.4% | 1.74 ± 0.5% | 24.01 ± 0.6% | 5.78 ± 1.9% | differs | 3.44 ± 1.2% | 34.07 ± 0.3% | 1.00 | 1.00 | 1.42 | 5.89 |
| a date and time | 32954 | 30.29 ± 0.5% | 30.26 ± 0.6% | 1.23 ± 0.8% | 18.02 ± 0.5% | 6.70 ± 0.8% | 0.76 ± 0.4% | 6.18 ± 5.5% | 30.30 ± 0.4% | 1.00 | 1.00 | 1.68 | 4.52 |
| a field path | 32606 | 21.80 ± 1.1% | 21.80 ± 4.9% | 0.90 ± 2.1% | 19.45 ± 0.6% | 2.95 ± 0.6% | differs | 2.45 ± 1.7% | 21.80 ± 4.8% | 1.00 | 1.00 | 1.12 | 7.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.85 ± 3.3% | 8.83 ± 16.2% | 8.60 ± 3.3% | 10.65 ± 0.5% | 4.84 ± 3.9% | 0.62 ± 0.3% | none | 8.83 ± 2.6% | 1.00 | 1.00 | 0.83 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 185.07 ± 1.1% | 186.00 ± 0.1% | 216.09 ± 1.1% | 80.09 ± 2.9% | 186.08 ± 2.2% | 545.14 ± 3.9% | 3892.34 ± 0.6% | 185.42 ± 0.2% | 1.00 | 1.00 | 2.31 | 0.99 |
| a UUID | 62 | 121.35 ± 0.8% | 121.63 ± 0.5% | 134.96 ± 0.2% | 46.75 ± 1.8% | 89.40 ± 1.1% | 199.73 ± 2.4% | 4009.23 ± 13.8% | 121.36 ± 21.3% | 1.00 | 1.00 | 2.60 | 1.36 |
| an IPv4 address | 29 | 381.91 ± 1.4% | 377.69 ± 18.4% | 534.19 ± 4.4% | 69.14 ± 3.2% | 113.63 ± 4.2% | 326.73 ± 13.4% | 6845.51 ± 2.7% | 382.52 ± 4.0% | 1.01 | 1.00 | 5.52 | 3.36 |
| a date and time | 56 | 277.50 ± 2.9% | 277.40 ± 2.7% | 346.31 ± 5.3% | 68.99 ± 3.2% | 123.60 ± 11.9% | 376.00 ± 2.4% | 4217.62 ± 2.6% | 276.61 ± 2.8% | 1.00 | 1.00 | 4.02 | 2.25 |
| a field path | 39 | 184.97 ± 0.4% | 185.34 ± 0.7% | 215.23 ± 0.6% | 75.37 ± 3.0% | 173.64 ± 3.0% | 591.81 ± 6.5% | 4693.27 ± 6.2% | 184.76 ± 1.2% | 1.00 | 1.00 | 2.45 | 1.07 |
| literal: a word | 7 | 579.02 ± 0.5% | 618.96 ± 1.0% | 1108.18 ± 15.3% | 494.30 ± 11.9% | 587.91 ± 1.1% | 1238.49 ± 0.8% | 21937.70 ± 0.1% | 577.92 ± 1.7% | 0.94 | 1.00 | 1.17 | 0.98 |
| literal: a word that is not there | 8 | 554.38 ± 0.6% | 598.88 ± 0.9% | 1037.64 ± 0.5% | 454.05 ± 0.9% | 563.87 ± 9.1% | 1162.16 ± 1.9% | 20787.21 ± 0.5% | 555.36 ± 3.3% | 0.93 | 1.00 | 1.22 | 0.98 |
| literal: one of four words | 26 | 215.73 ± 0.5% | 358.12 ± 15.4% | 481.07 ± 0.6% | 41.87 ± 0.8% | 221.51 ± 12.0% | 448.57 ± 1.7% | 11558.12 ± 16.0% | 215.27 ± 0.4% | 0.60 | 1.00 | 5.15 | 0.97 |
| literal: a word in any case | 11 | 397.95 ± 0.5% | 418.15 ± 0.4% | 597.91 ± 0.6% | 14.42 ± 10.5% | 614.45 ± 2.4% | refused | 17702.70 ± 1.6% | 397.83 ± 0.6% | 0.95 | 1.00 | 27.60 | 0.65 |
| literal: an href attribute | 12 | 314.70 ± 0.3% | 323.66 ± 1.0% | 426.64 ± 0.5% | 37.53 ± 0.9% | 439.13 ± 1.3% | 964.52 ± 0.6% | 17269.74 ± 0.6% | 312.92 ± 1.3% | 0.97 | 1.01 | 8.39 | 0.72 |
| literal: a word, second text | 10 | 512.24 ± 1.4% | 560.43 ± 0.7% | 930.29 ± 0.3% | 414.51 ± 0.7% | 490.50 ± 2.7% | 1012.50 ± 0.8% | 18745.57 ± 2.5% | 513.05 ± 1.0% | 0.91 | 1.00 | 1.24 | 1.04 |
| class: two capitalized words | 23 | 406.92 ± 2.1% | 428.46 ± 20.4% | 639.82 ± 4.8% | 94.07 ± 1.3% | 454.79 ± 2.1% | 924.55 ± 0.4% | 6304.74 ± 0.8% | 405.74 ± 1.9% | 0.95 | 1.00 | 4.33 | 0.89 |
| class: a word that ends in ing | 9 | 497.97 ± 0.5% | 555.76 ± 0.5% | 992.18 ± 0.6% | 115.07 ± 0.8% | 642.61 ± 3.5% | 1394.16 ± 7.8% | 14000.83 ± 1.0% | 498.31 ± 0.3% | 0.90 | 1.00 | 4.33 | 0.77 |
| class: a word in capitals | 16 | 422.37 ± 8.2% | 453.63 ± 1.1% | 759.17 ± 8.0% | 122.67 ± 1.7% | 668.39 ± 2.4% | 1286.55 ± 1.8% | 8311.84 ± 10.4% | 420.95 ± 0.7% | 0.93 | 1.00 | 3.44 | 0.63 |
| class: a number | 6 | 539.90 ± 0.6% | 591.70 ± 0.7% | 1151.01 ± 1.0% | 36.33 ± 0.6% | 1221.93 ± 3.0% | 2405.26 ± 6.5% | 19635.81 ± 0.7% | 538.37 ± 0.3% | 0.91 | 1.00 | 14.86 | 0.44 |
| class: two capitalized words, second text | 23 | 407.19 ± 2.5% | 428.73 ± 4.6% | 641.09 ± 3.5% | 95.24 ± 1.6% | 454.64 ± 1.6% | 949.27 ± 0.9% | 6315.03 ± 0.3% | 405.21 ± 2.2% | 0.95 | 1.00 | 4.28 | 0.90 |
| other: a word between two words | 13 | 495.52 ± 1.7% | 509.97 ± 0.7% | 807.78 ± 0.8% | 125.12 ± 1.5% | 445.42 ± 2.2% | 1023.58 ± 0.3% | 13418.90 ± 0.2% | 494.64 ± 0.3% | 0.97 | 1.00 | 3.96 | 1.11 |
| other: a number before a unit, second text | 15 | 354.54 ± 0.8% | 390.67 ± 0.7% | 546.69 ± 0.5% | 33.56 ± 0.5% | 552.57 ± 2.2% | 1158.53 ± 1.4% | 12949.69 ± 1.1% | 354.54 ± 1.3% | 0.91 | 1.00 | 10.56 | 0.64 |
| other: a heading's start tag | 13 | 323.91 ± 2.9% | 328.03 ± 1.0% | 435.53 ± 0.8% | 35.76 ± 0.7% | 542.40 ± 1.1% | 1099.07 ± 0.7% | 14860.27 ± 0.7% | 323.07 ± 14.5% | 0.99 | 1.00 | 9.06 | 0.60 |
| other: a whole word | 11 | 493.57 ± 11.2% | 524.51 ± 0.5% | 832.62 ± 1.5% | 110.89 ± 0.9% | 510.01 ± 2.9% | 1040.56 ± 1.3% | 20152.99 ± 17.0% | 493.76 ± 10.2% | 0.94 | 1.00 | 4.45 | 0.97 |
| other: a line's first word, second text | 17 | 471.86 ± 6.9% | 489.31 ± 0.4% | 809.70 ± 6.2% | 117.28 ± 0.6% | 609.43 ± 3.1% | refused | refused | 469.25 ± 3.6% | 0.96 | 1.01 | 4.02 | 0.77 |
| other: fourteen octets before an x | 16 | 81.55 ± 0.9% | 122.06 ± 0.1% | 141.07 ± 11.6% | 14.25 ± 0.7% | 402.86 ± 23.7% | 455.33 ± 0.5% | 10919.01 ± 1.1% | 81.61 ± 0.9% | 0.67 | 1.00 | 5.72 | 0.20 |
| other: a Greek word | 8 | 367.93 ± 1.7% | 513.87 ± 11.6% | 877.78 ± 13.6% | 47.36 ± 43.9% | 1200.93 ± 1.7% | 2251.03 ± 0.4% | refused | 367.51 ± 0.5% | 0.72 | 1.00 | 7.77 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22048.99 ± 1.5% | not timed | not timed | 26923.84 ± 0.6% | 2000.79 ± 15.7% | not timed | not timed | 21974.64 ± 1.4% | | 1.00 | 0.82 | 11.02 |
| 01-literal/sherlock-casei-en | 522 | 7627.81 ± 0.3% | not timed | not timed | 7013.74 ± 0.2% | 28.73 ± 0.8% | not timed | not timed | 7580.31 ± 1.8% | | 1.01 | 1.09 | 265.47 |
| 01-literal/sherlock-ru | 724 | 23749.29 ± 1.5% | not timed | not timed | 27907.43 ± 1.0% | 1084.27 ± 5.9% | not timed | not timed | 23701.21 ± 1.8% | | 1.00 | 0.85 | 21.90 |
| 01-literal/sherlock-casei-ru | 746 | 9414.03 ± 0.7% | not timed | not timed | 5373.24 ± 0.5% | 30.41 ± 3.4% | not timed | not timed | 9379.47 ± 2.2% | | 1.00 | 1.75 | 309.53 |
| 01-literal/sherlock-zh | 30 | 41896.73 ± 3.9% | not timed | not timed | 36182.80 ± 7.5% | 1242.08 ± 6.8% | not timed | not timed | 41719.39 ± 3.3% | | 1.00 | 1.16 | 33.73 |
| 02-literal-alternate/sherlock-en | 714 | 9688.13 ± 0.7% | not timed | not timed | 8930.66 ± 0.7% | 14.19 ± 1.0% | not timed | not timed | 9618.81 ± 10.3% | | 1.01 | 1.08 | 682.76 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1996.14 ± 0.6% | not timed | not timed | 1819.93 ± 0.4% | 9.42 ± 1.3% | not timed | not timed | 1975.95 ± 5.5% | | 1.01 | 1.10 | 212.01 |
| 02-literal-alternate/sherlock-ru | 899 | 7840.12 ± 0.7% | not timed | not timed | 4256.37 ± 0.3% | 19.28 ± 0.8% | not timed | not timed | 7836.85 ± 0.4% | | 1.00 | 1.84 | 406.66 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2066.57 ± 0.2% | not timed | not timed | 1042.51 ± 4.7% | 8.57 ± 0.8% | not timed | not timed | 2065.26 ± 0.3% | | 1.00 | 1.98 | 241.12 |
| 02-literal-alternate/sherlock-zh | 207 | 13962.58 ± 1.9% | not timed | not timed | 10429.42 ± 0.8% | 27.09 ± 12.0% | not timed | not timed | 13999.57 ± 0.7% | | 1.00 | 1.34 | 515.39 |
| 03-date/ascii | 111817 | 98.21 ± 0.8% | not timed | not timed | 84.87 ± 0.6% | 0.18 ± 2.9% | not timed | not timed | 98.22 ± 0.9% | | 1.00 | 1.16 | 547.75 |
| 04-ruff-noqa/real | 84 | 419.70 ± 19.6% | not timed | not timed | 426.44 ± 0.6% | 15.95 ± 0.8% | not timed | not timed | 419.50 ± 1.5% | | 1.00 | 0.98 | 26.32 |
| 04-ruff-noqa/tweaked | 44 | 476.54 ± 0.6% | not timed | not timed | 420.59 ± 1.6% | 295.02 ± 0.3% | not timed | not timed | 475.30 ± 0.3% | | 1.00 | 1.13 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.26 ± 10.3% | not timed | not timed | 4.20 ± 0.6% | 0.21 ± 2.2% | not timed | not timed | 3.31 ± 11.8% | | 0.99 | 0.78 | 15.74 |
| 06-cloud-flare-redos/original | 107 | 349.02 ± 0.6% | not timed | not timed | 190.78 ± 5.3% | 20.73 ± 0.2% | not timed | not timed | 349.16 ± 0.3% | | 1.00 | 1.83 | 16.84 |
| 06-cloud-flare-redos/simplified-short | 102 | 333.94 ± 0.5% | not timed | not timed | 192.17 ± 0.6% | 22.03 ± 1.7% | not timed | not timed | 334.22 ± 0.2% | | 1.00 | 1.74 | 15.16 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.30 ± 0.1% | not timed | not timed | 211.61 ± 0.2% | 24.06 ± 0.4% | not timed | not timed | 464.99 ± 0.8% | | 1.00 | 2.20 | 19.34 |
| 07-unicode-character-data/parse-line | 558784 | 198.65 ± 3.0% | not timed | not timed | 162.19 ± 0.5% | 37.70 ± 25.9% | not timed | not timed | 198.86 ± 0.6% | | 1.00 | 1.22 | 5.27 |
| 08-words/all-english | 56691 | 97.14 ± 8.2% | not timed | not timed | 73.73 ± 1.9% | 10.09 ± 3.7% | not timed | not timed | 98.25 ± 0.2% | | 0.99 | 1.32 | 9.63 |
| 08-words/long-english | 839 | 534.64 ± 0.2% | not timed | not timed | 515.59 ± 0.2% | 25.95 ± 9.1% | not timed | not timed | 535.99 ± 0.3% | | 1.00 | 1.04 | 20.60 |
| 09-aws-keys/full | 0 | 426.81 ± 1.9% | not timed | not timed | 437.26 ± 10.9% | 54.54 ± 7.5% | not timed | not timed | 426.22 ± 2.1% | | 1.00 | 0.98 | 7.83 |
| 09-aws-keys/quick | 0 | 789.48 ± 0.3% | not timed | not timed | 805.96 ± 7.9% | 332.79 ± 0.9% | not timed | not timed | 785.50 ± 0.6% | | 1.01 | 0.98 | 2.37 |
| 10-bounded-repeat/letters-en | 1833 | 486.51 ± 3.2% | not timed | not timed | 432.07 ± 2.5% | 16.40 ± 0.6% | not timed | not timed | 486.85 ± 0.2% | | 1.00 | 1.13 | 29.67 |
| 10-bounded-repeat/letters-ru | 3475 | 430.09 ± 0.2% | not timed | not timed | 408.29 ± 1.0% | 19.20 ± 11.7% | not timed | not timed | 431.29 ± 0.3% | | 1.00 | 1.05 | 22.40 |
| 10-bounded-repeat/context | 53 | 64.98 ± 0.3% | not timed | not timed | 56.65 ± 0.3% | 16.91 ± 2.9% | not timed | not timed | 64.97 ± 0.6% | | 1.00 | 1.15 | 3.84 |
| 10-bounded-repeat/capitals | 11 | 558.61 ± 8.0% | not timed | not timed | 533.60 ± 0.3% | 30.81 ± 5.5% | not timed | not timed | 557.96 ± 8.0% | | 1.00 | 1.05 | 18.13 |
| 11-unstructured-to-json/extract | 600 | 54.78 ± 0.6% | not timed | not timed | 62.51 ± 2.0% | 41.13 ± 1.8% | not timed | not timed | 54.67 ± 1.4% | | 1.00 | 0.88 | 1.33 |
| 12-dictionary/single | 1 | 460.11 ± 0.4% | not timed | not timed | 443.51 ± 2.6% | 0.32 ± 2.6% | not timed | not timed | 464.42 ± 13.5% | | 0.99 | 1.04 | 1434.78 |
| 14-quadratic/1x | 100 | 20.74 ± 0.8% | not timed | not timed | 9.07 ± 0.7% | 0.80 ± 2.6% | not timed | not timed | 20.57 ± 2.2% | | 1.01 | 2.29 | 25.93 |
| 14-quadratic/2x | 200 | 16.04 ± 0.7% | not timed | not timed | 4.91 ± 2.3% | 0.43 ± 2.4% | not timed | not timed | 16.00 ± 0.7% | | 1.00 | 3.27 | 37.44 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.6% | not timed | not timed | 1.05 ± 1.0% | 0.09 ± 15.6% | not timed | not timed | 5.62 ± 3.0% | | 1.00 | 5.35 | 60.82 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.13 ± 0.8% | not timed | not timed | 0.39 ± 12.0% | 0.49 ± 3.6% | not timed | not timed | 1.13 ± 1.3% | | 1.01 | 2.93 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 78.71 ± 1.0% | not timed | not timed | 12.78 ± 12.3% | 125.54 ± 2.7% | not timed | not timed | 78.25 ± 0.7% | | 1.01 | 6.16 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 12.44 ± 4.7% | not timed | not timed | 2.34 ± 3.9% | 5.93 ± 5.1% | not timed | not timed | 12.46 ± 1.0% | | 1.00 | 5.32 | 2.10 |
| 07-unicode-character-data/compile | 1 | 49.39 ± 0.3% | not timed | not timed | 24.48 ± 1.1% | 32.61 ± 3.4% | not timed | not timed | 49.11 ± 3.6% | | 1.01 | 2.02 | 1.51 |
| 09-aws-keys/compile-full | 1 | 34.09 ± 13.8% | not timed | not timed | 7.42 ± 1.3% | 20.40 ± 6.9% | not timed | not timed | 33.63 ± 1.4% | | 1.01 | 4.59 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 152.22 ± 0.9% | not timed | not timed | 45.25 ± 0.6% | 120.16 ± 1.4% | not timed | not timed | 147.06 ± 14.6% | | 1.04 | 3.36 | 1.27 |
| 10-bounded-repeat/compile-context | 1 | 10.34 ± 0.2% | not timed | not timed | 11.78 ± 24.9% | 15.28 ± 2.2% | not timed | not timed | 10.33 ± 0.2% | | 1.00 | 0.88 | 0.68 |
| 10-bounded-repeat/compile-capitals | 1 | 72.07 ± 18.4% | not timed | not timed | 8.82 ± 0.8% | 22.45 ± 1.8% | not timed | not timed | 71.81 ± 0.2% | | 1.00 | 8.17 | 3.21 |
| 11-unstructured-to-json/compile | 1 | 74.67 ± 1.3% | not timed | not timed | 37.33 ± 17.9% | 60.77 ± 4.6% | not timed | not timed | 74.23 ± 1.5% | | 1.01 | 2.00 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.29 ± 3.3% | not timed | not timed | 0.07 ± 1.0% | 0.09 ± 12.3% | not timed | not timed | 0.28 ± 1.2% | | 1.02 | 4.27 | 3.38 |

