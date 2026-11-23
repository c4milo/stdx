# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127325269 |
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
| literal: a word | 217 | 32504.84 ± 9.9% | 842.46 ± 0.1% | 19.45 ± 4.1% | 31089.30 ± 6.2% | 8815.86 ± 10.1% | 10.74 ± 0.7% | 77.39 ± 0.8% | 31753.15 ± 3.8% | 38.58 | 1.02 | 1.05 | 3.69 |
| literal: a word that is not there | 0 | 48441.71 ± 2.7% | 850.48 ± 0.3% | 19.96 ± 5.0% | 39601.66 ± 1.0% | 30422.77 ± 0.9% | 10.68 ± 0.1% | 73.18 ± 3.1% | 47497.40 ± 4.0% | 56.96 | 1.02 | 1.22 | 1.59 |
| literal: one of four words | 661 | 10901.06 ± 27.7% | 818.98 ± 1.4% | 10.98 ± 4.6% | 9073.83 ± 1.7% | 18.87 ± 4.9% | 3.99 ± 1.9% | 6.68 ± 2.6% | 10951.22 ± 3.0% | 13.31 | 1.00 | 1.20 | 577.69 |
| literal: a word in any case | 217 | 25777.85 ± 4.0% | 841.85 ± 1.9% | 14.66 ± 2.9% | 9185.25 ± 0.5% | 37.14 ± 2.1% | refused | differs | 25628.34 ± 4.7% | 30.62 | 1.01 | 2.81 | 694.03 |
| literal: an href attribute | 33 | 27321.57 ± 1.4% | 846.41 ± 0.6% | 18.33 ± 3.2% | 27362.47 ± 5.8% | 2061.31 ± 1.0% | 8.19 ± 0.2% | 61.67 ± 5.1% | 26815.31 ± 2.4% | 32.28 | 1.02 | 1.00 | 13.25 |
| literal: a word, second text | 123 | 33372.06 ± 4.1% | 844.56 ± 1.0% | 19.70 ± 3.9% | 31732.86 ± 4.2% | 7169.99 ± 11.2% | 11.78 ± 0.6% | 66.35 ± 6.5% | 33157.58 ± 7.4% | 39.51 | 1.01 | 1.05 | 4.65 |
| class: two capitalized words | 1331 | 786.12 ± 0.2% | 786.11 ± 0.2% | 18.77 ± 10.5% | 506.07 ± 1.1% | 34.09 ± 13.8% | 9.26 ± 0.2% | 55.65 ± 0.3% | 784.76 ± 2.0% | 1.00 | 1.00 | 1.55 | 23.06 |
| class: a word that ends in ing | 3399 | 713.31 ± 1.1% | 714.50 ± 0.4% | 12.90 ± 1.3% | 472.63 ± 0.9% | 25.48 ± 7.7% | 5.34 ± 0.5% | 17.13 ± 1.9% | 715.47 ± 0.3% | 1.00 | 1.00 | 1.51 | 27.99 |
| class: a word in capitals | 2332 | 986.61 ± 0.3% | 769.40 ± 2.5% | 19.43 ± 4.5% | 496.97 ± 0.4% | 36.33 ± 9.0% | 10.30 ± 0.2% | 76.36 ± 0.4% | 981.37 ± 0.5% | 1.28 | 1.01 | 1.99 | 27.16 |
| class: a number | 8288 | 1419.73 ± 2.8% | 656.74 ± 1.2% | 19.17 ± 3.2% | 1478.17 ± 0.8% | 36.38 ± 11.3% | 0.33 ± 0.8% | 55.68 ± 0.2% | 1423.44 ± 0.1% | 2.16 | 1.00 | 0.96 | 39.02 |
| class: two capitalized words, second text | 5359 | 590.95 ± 0.2% | 592.99 ± 0.3% | 17.05 ± 0.6% | 416.94 ± 1.4% | 29.34 ± 12.1% | 10.49 ± 0.2% | 51.58 ± 0.2% | 592.05 ± 0.7% | 1.00 | 1.00 | 1.42 | 20.14 |
| other: a word between two words | 6104 | 642.57 ± 0.3% | 618.82 ± 0.4% | 16.65 ± 2.8% | 697.90 ± 0.8% | 100.20 ± 3.9% | 7.24 ± 0.5% | 56.59 ± 1.0% | 641.40 ± 4.9% | 1.04 | 1.00 | 0.92 | 6.41 |
| other: a number before a unit, second text | 1481 | 6594.13 ± 2.5% | 792.77 ± 1.3% | 18.55 ± 3.7% | 6391.04 ± 2.4% | 33.20 ± 13.4% | 10.91 ± 1.3% | 54.89 ± 2.2% | 6449.02 ± 2.1% | 8.32 | 1.02 | 1.03 | 198.62 |
| other: a heading's start tag | 110 | 18654.36 ± 3.5% | 839.68 ± 0.2% | 19.13 ± 1.0% | 2000.91 ± 2.1% | 1472.97 ± 6.1% | 9.99 ± 1.0% | 72.69 ± 1.7% | 17915.92 ± 2.1% | 22.22 | 1.04 | 9.32 | 12.66 |
| other: a whole word | 217 | 22374.59 ± 9.0% | 841.44 ± 1.1% | 19.16 ± 2.6% | 22400.36 ± 10.2% | 40.52 ± 8.5% | 9.45 ± 1.1% | 46.82 ± 1.1% | 21899.67 ± 4.3% | 26.59 | 1.02 | 1.00 | 552.13 |
| other: a line's first word, second text | 3716 | 1617.99 ± 0.8% | 704.51 ± 0.2% | 22.11 ± 1.6% | 1700.51 ± 0.6% | 53.30 ± 14.5% | refused | refused | 1710.13 ± 0.6% | 2.30 | 0.95 | 0.95 | 30.36 |
| other: fourteen octets before an x | 87 | 25295.67 ± 4.8% | 194.95 ± 1.3% | 5.09 ± 1.2% | 2856.61 ± 5.8% | 8.94 ± 6.3% | differs | 15.43 ± 3.0% | 24939.60 ± 38.1% | 129.75 | 1.01 | 8.86 | 2829.83 |
| other: a Greek word | 21815 | 396.34 ± 0.5% | 289.70 ± 2.9% | 23.08 ± 4.3% | 265.62 ± 1.0% | 38.46 ± 6.9% | differs | refused | 395.39 ± 0.6% | 1.37 | 1.00 | 1.49 | 10.31 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.50 ± 1.1% | 24.33 ± 11.7% | 0.57 ± 4.7% | 16.78 ± 0.4% | 2.33 ± 0.8% | differs | 3.64 ± 1.9% | 24.71 ± 1.1% | 1.01 | 0.99 | 1.46 | 10.50 |
| a UUID | 32895 | 20.33 ± 9.2% | 20.58 ± 1.1% | 0.55 ± 0.8% | 12.81 ± 1.3% | 2.51 ± 0.7% | 0.44 ± 0.8% | 3.09 ± 3.4% | 20.52 ± 4.9% | 0.99 | 0.99 | 1.59 | 8.11 |
| an IPv4 address | 33176 | 34.39 ± 1.7% | 34.00 ± 1.9% | 1.75 ± 7.5% | 23.88 ± 0.3% | 5.77 ± 6.2% | differs | 3.38 ± 1.8% | 34.18 ± 1.3% | 1.01 | 1.01 | 1.44 | 5.95 |
| a date and time | 32954 | 30.38 ± 3.0% | 30.31 ± 0.2% | 1.27 ± 0.3% | 17.86 ± 0.9% | 6.68 ± 1.5% | 0.76 ± 0.7% | 6.19 ± 0.3% | 30.18 ± 0.7% | 1.00 | 1.01 | 1.70 | 4.55 |
| a field path | 32606 | 27.20 ± 0.6% | 27.29 ± 0.3% | 0.85 ± 0.5% | 19.38 ± 1.3% | 2.92 ± 0.9% | differs | 2.48 ± 2.5% | 27.24 ± 0.6% | 1.00 | 1.00 | 1.40 | 9.31 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.28 ± 1.7% | 8.18 ± 0.3% | 8.26 ± 0.3% | 10.65 ± 0.4% | 4.64 ± 1.1% | 0.62 ± 1.0% | none | 8.28 ± 1.9% | 1.01 | 1.00 | 0.78 | 1.78 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 183.52 ± 4.3% | 183.53 ± 10.4% | 213.06 ± 5.8% | 79.10 ± 3.4% | 163.39 ± 8.9% | 543.78 ± 2.4% | 3986.85 ± 0.6% | 184.16 ± 0.3% | 1.00 | 1.00 | 2.32 | 1.12 |
| a UUID | 62 | 119.59 ± 0.3% | 119.66 ± 1.4% | 132.03 ± 0.3% | 46.57 ± 8.2% | 85.05 ± 2.6% | 199.96 ± 4.7% | 4112.15 ± 0.3% | 119.34 ± 0.3% | 1.00 | 1.00 | 2.57 | 1.41 |
| an IPv4 address | 29 | 395.32 ± 1.2% | 394.07 ± 2.5% | 559.30 ± 1.7% | 68.96 ± 13.1% | 107.29 ± 2.5% | 317.81 ± 14.9% | 7199.84 ± 1.0% | 394.90 ± 10.7% | 1.00 | 1.00 | 5.73 | 3.68 |
| a date and time | 56 | 281.85 ± 1.3% | 282.45 ± 1.7% | 353.79 ± 7.4% | 67.39 ± 2.4% | 116.27 ± 27.5% | 372.38 ± 0.5% | 4239.13 ± 1.0% | 281.50 ± 6.6% | 1.00 | 1.00 | 4.18 | 2.42 |
| a field path | 39 | 180.33 ± 0.4% | 180.56 ± 0.3% | 208.81 ± 0.2% | 74.03 ± 2.2% | 157.32 ± 16.2% | 594.86 ± 9.3% | 4832.40 ± 0.5% | 180.30 ± 0.6% | 1.00 | 1.00 | 2.44 | 1.15 |
| literal: a word | 7 | 588.17 ± 3.5% | 627.51 ± 0.6% | 1107.78 ± 0.9% | 485.56 ± 9.0% | 550.82 ± 4.3% | 1252.53 ± 1.2% | 25097.80 ± 0.6% | 589.04 ± 0.3% | 0.94 | 1.00 | 1.21 | 1.07 |
| literal: a word that is not there | 8 | 567.26 ± 1.1% | 606.12 ± 1.0% | 1049.11 ± 0.4% | 446.97 ± 0.9% | 521.07 ± 15.7% | 1177.17 ± 5.7% | 23834.40 ± 0.7% | 566.72 ± 0.6% | 0.94 | 1.00 | 1.27 | 1.09 |
| literal: one of four words | 26 | 224.40 ± 0.9% | 363.11 ± 2.0% | 489.56 ± 0.4% | 41.61 ± 2.5% | 205.49 ± 9.6% | 449.99 ± 4.2% | 11304.26 ± 2.8% | 223.74 ± 2.3% | 0.62 | 1.00 | 5.39 | 1.09 |
| literal: a word in any case | 11 | 447.01 ± 3.3% | 471.76 ± 2.5% | 708.65 ± 15.0% | 14.01 ± 10.3% | 560.29 ± 6.1% | refused | 19242.78 ± 5.2% | 446.26 ± 2.7% | 0.95 | 1.00 | 31.92 | 0.80 |
| literal: an href attribute | 12 | 317.27 ± 0.8% | 328.59 ± 1.1% | 428.65 ± 0.4% | 36.25 ± 7.6% | 404.15 ± 7.8% | 960.89 ± 4.0% | 18663.17 ± 2.3% | 316.57 ± 0.7% | 0.97 | 1.00 | 8.75 | 0.79 |
| literal: a word, second text | 10 | 523.98 ± 12.3% | 570.96 ± 1.6% | 948.22 ± 2.6% | 390.08 ± 1.0% | 450.37 ± 2.4% | 1033.07 ± 0.3% | 21583.41 ± 2.6% | 525.27 ± 0.6% | 0.92 | 1.00 | 1.34 | 1.16 |
| class: two capitalized words | 23 | 418.74 ± 2.8% | 448.00 ± 3.2% | 635.42 ± 4.1% | 93.45 ± 1.1% | 396.50 ± 4.6% | 962.52 ± 0.5% | 6391.74 ± 2.8% | 418.77 ± 1.8% | 0.93 | 1.00 | 4.48 | 1.06 |
| class: a word that ends in ing | 9 | 512.04 ± 0.6% | 569.54 ± 0.9% | 1006.72 ± 2.5% | 114.61 ± 0.8% | 570.42 ± 1.5% | 1464.70 ± 1.9% | 15283.62 ± 0.4% | 512.22 ± 0.6% | 0.90 | 1.00 | 4.47 | 0.90 |
| class: a word in capitals | 16 | 444.93 ± 1.0% | 478.02 ± 0.3% | 783.87 ± 0.3% | 122.20 ± 1.0% | 607.55 ± 6.8% | 1373.59 ± 0.4% | 8379.88 ± 2.2% | 444.64 ± 0.8% | 0.93 | 1.00 | 3.64 | 0.73 |
| class: a number | 6 | 559.56 ± 0.5% | 610.33 ± 1.3% | 1163.54 ± 1.1% | 36.15 ± 1.9% | 1073.50 ± 3.8% | 2373.34 ± 4.5% | 20430.64 ± 0.4% | 557.55 ± 1.8% | 0.92 | 1.00 | 15.48 | 0.52 |
| class: two capitalized words, second text | 23 | 419.16 ± 2.2% | 443.30 ± 2.7% | 638.32 ± 3.6% | 94.23 ± 0.9% | 416.88 ± 3.4% | 934.44 ± 1.1% | 6394.07 ± 1.3% | 419.57 ± 0.9% | 0.95 | 1.00 | 4.45 | 1.01 |
| other: a word between two words | 13 | 504.06 ± 0.7% | 518.15 ± 0.4% | 810.33 ± 0.7% | 121.79 ± 1.4% | 401.61 ± 45.0% | 1039.93 ± 4.1% | 13882.18 ± 2.0% | 501.24 ± 0.6% | 0.97 | 1.01 | 4.14 | 1.26 |
| other: a number before a unit, second text | 15 | 355.84 ± 0.4% | 389.56 ± 1.3% | 537.44 ± 16.9% | 33.56 ± 0.6% | 504.75 ± 5.4% | 1137.94 ± 2.7% | 13852.41 ± 6.7% | 355.23 ± 0.6% | 0.91 | 1.00 | 10.60 | 0.70 |
| other: a heading's start tag | 13 | 330.39 ± 0.3% | 335.38 ± 4.0% | 442.63 ± 0.6% | 35.09 ± 2.7% | 498.24 ± 2.7% | 1074.66 ± 1.1% | 16388.50 ± 27.5% | 330.07 ± 1.8% | 0.99 | 1.00 | 9.41 | 0.66 |
| other: a whole word | 11 | 509.04 ± 1.0% | 535.78 ± 1.3% | 865.64 ± 0.3% | 110.92 ± 3.8% | 476.02 ± 6.0% | 1043.53 ± 1.1% | 20815.87 ± 1.0% | 508.67 ± 1.0% | 0.95 | 1.00 | 4.59 | 1.07 |
| other: a line's first word, second text | 17 | 486.39 ± 2.6% | 506.49 ± 0.9% | 830.80 ± 0.8% | 114.61 ± 0.9% | 559.12 ± 3.6% | refused | refused | 484.08 ± 2.9% | 0.96 | 1.00 | 4.24 | 0.87 |
| other: fourteen octets before an x | 16 | 85.42 ± 16.5% | 122.15 ± 1.2% | 140.38 ± 0.3% | 14.17 ± 0.4% | 369.01 ± 3.8% | 460.29 ± 0.9% | 11722.60 ± 1.5% | 85.97 ± 7.8% | 0.70 | 0.99 | 6.03 | 0.23 |
| other: a Greek word | 8 | 382.49 ± 0.4% | 506.57 ± 0.6% | 833.61 ± 0.5% | 46.29 ± 0.6% | 1058.41 ± 3.7% | 2121.87 ± 3.9% | refused | 382.15 ± 0.2% | 0.76 | 1.00 | 8.26 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20969.15 ± 1.8% | not timed | not timed | 26964.15 ± 4.4% | 1902.40 ± 25.9% | not timed | not timed | 20903.17 ± 1.1% | | 1.00 | 0.78 | 11.02 |
| 01-literal/sherlock-casei-en | 522 | 4663.26 ± 0.2% | not timed | not timed | 7078.51 ± 0.5% | 28.53 ± 1.8% | not timed | not timed | 4228.95 ± 1.1% | | 1.10 | 0.66 | 163.45 |
| 01-literal/sherlock-ru | 724 | 22833.36 ± 1.4% | not timed | not timed | 27959.30 ± 1.3% | 1072.20 ± 5.2% | not timed | not timed | 22797.50 ± 2.7% | | 1.00 | 0.82 | 21.30 |
| 01-literal/sherlock-casei-ru | 746 | 7290.39 ± 0.2% | not timed | not timed | 5536.72 ± 0.2% | 30.30 ± 3.2% | not timed | not timed | 7227.39 ± 2.2% | | 1.01 | 1.32 | 240.63 |
| 01-literal/sherlock-zh | 30 | 41276.03 ± 3.4% | not timed | not timed | 36843.55 ± 1.0% | 1261.56 ± 0.9% | not timed | not timed | 41742.31 ± 1.6% | | 0.99 | 1.12 | 32.72 |
| 02-literal-alternate/sherlock-en | 714 | 9470.78 ± 18.7% | not timed | not timed | 8952.30 ± 0.2% | 14.77 ± 5.5% | not timed | not timed | 9464.41 ± 1.0% | | 1.00 | 1.06 | 641.06 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1733.84 ± 6.4% | not timed | not timed | 1818.67 ± 0.4% | 9.50 ± 0.2% | not timed | not timed | 1727.22 ± 0.4% | | 1.00 | 0.95 | 182.50 |
| 02-literal-alternate/sherlock-ru | 899 | 5936.96 ± 0.9% | not timed | not timed | 4270.27 ± 3.5% | 19.21 ± 3.0% | not timed | not timed | 5939.60 ± 0.1% | | 1.00 | 1.39 | 309.01 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1799.30 ± 0.4% | not timed | not timed | 1040.71 ± 4.8% | 8.47 ± 0.8% | not timed | not timed | 1795.46 ± 0.2% | | 1.00 | 1.73 | 212.38 |
| 02-literal-alternate/sherlock-zh | 207 | 13722.19 ± 1.2% | not timed | not timed | 10417.13 ± 1.8% | 27.10 ± 14.3% | not timed | not timed | 13670.27 ± 15.6% | | 1.00 | 1.32 | 506.30 |
| 03-date/ascii | 111817 | 99.79 ± 2.2% | not timed | not timed | 84.55 ± 0.8% | 0.18 ± 2.1% | not timed | not timed | 98.75 ± 1.2% | | 1.01 | 1.18 | 561.05 |
| 04-ruff-noqa/real | 84 | 545.00 ± 1.1% | not timed | not timed | 422.07 ± 0.7% | 15.84 ± 1.6% | not timed | not timed | 539.65 ± 1.1% | | 1.01 | 1.29 | 34.41 |
| 04-ruff-noqa/tweaked | 44 | 481.61 ± 0.8% | not timed | not timed | 413.77 ± 9.8% | 293.35 ± 13.2% | not timed | not timed | 482.43 ± 6.0% | | 1.00 | 1.16 | 1.64 |
| 05-lexer-veryl/single | 124800 | 2.83 ± 1.1% | not timed | not timed | 4.10 ± 2.9% | 0.21 ± 2.9% | not timed | not timed | 2.65 ± 6.2% | | 1.07 | 0.69 | 13.47 |
| 06-cloud-flare-redos/original | 107 | 230.86 ± 2.1% | not timed | not timed | 182.14 ± 15.7% | 20.46 ± 7.9% | not timed | not timed | 229.14 ± 0.7% | | 1.01 | 1.27 | 11.28 |
| 06-cloud-flare-redos/simplified-short | 102 | 220.60 ± 1.9% | not timed | not timed | 192.51 ± 12.4% | 20.25 ± 28.5% | not timed | not timed | 219.18 ± 8.1% | | 1.01 | 1.15 | 10.90 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.52 ± 9.3% | not timed | not timed | 210.80 ± 0.7% | 24.01 ± 21.5% | not timed | not timed | 246.80 ± 0.1% | | 1.00 | 1.17 | 10.27 |
| 07-unicode-character-data/parse-line | 558784 | 196.84 ± 0.9% | not timed | not timed | 160.49 ± 1.7% | 36.90 ± 2.8% | not timed | not timed | 194.88 ± 0.6% | | 1.01 | 1.23 | 5.34 |
| 08-words/all-english | 56691 | 90.81 ± 1.5% | not timed | not timed | 73.71 ± 3.1% | 9.89 ± 8.9% | not timed | not timed | 89.79 ± 0.9% | | 1.01 | 1.23 | 9.18 |
| 08-words/long-english | 839 | 808.33 ± 0.2% | not timed | not timed | 513.62 ± 0.2% | 24.96 ± 11.6% | not timed | not timed | 807.15 ± 2.0% | | 1.00 | 1.57 | 32.38 |
| 09-aws-keys/full | 0 | 423.67 ± 4.6% | not timed | not timed | 444.71 ± 2.3% | 54.36 ± 1.4% | not timed | not timed | 420.23 ± 0.3% | | 1.01 | 0.95 | 7.79 |
| 09-aws-keys/quick | 0 | 825.18 ± 9.6% | not timed | not timed | 804.54 ± 0.2% | 329.36 ± 1.0% | not timed | not timed | 822.74 ± 9.9% | | 1.00 | 1.03 | 2.51 |
| 10-bounded-repeat/letters-en | 1833 | 470.81 ± 1.1% | not timed | not timed | 431.53 ± 3.1% | 16.70 ± 12.6% | not timed | not timed | 489.14 ± 2.4% | | 0.96 | 1.09 | 28.19 |
| 10-bounded-repeat/letters-ru | 3475 | 318.95 ± 0.3% | not timed | not timed | 406.99 ± 0.8% | 18.04 ± 11.5% | not timed | not timed | 317.96 ± 2.1% | | 1.00 | 0.78 | 17.68 |
| 10-bounded-repeat/context | 53 | 61.92 ± 6.0% | not timed | not timed | 51.64 ± 10.6% | 16.22 ± 5.9% | not timed | not timed | 61.80 ± 7.2% | | 1.00 | 1.20 | 3.82 |
| 10-bounded-repeat/capitals | 11 | 843.85 ± 0.3% | not timed | not timed | 532.67 ± 0.2% | 30.75 ± 1.3% | not timed | not timed | 841.89 ± 1.4% | | 1.00 | 1.58 | 27.44 |
| 11-unstructured-to-json/extract | 600 | 35.94 ± 16.9% | not timed | not timed | 61.98 ± 2.6% | 40.56 ± 1.9% | not timed | not timed | 35.74 ± 2.9% | | 1.01 | 0.58 | 0.89 |
| 12-dictionary/single | 1 | 459.41 ± 0.2% | not timed | not timed | 442.92 ± 0.2% | 0.32 ± 0.9% | not timed | not timed | 464.14 ± 0.9% | | 0.99 | 1.04 | 1433.64 |
| 14-quadratic/1x | 100 | 10.06 ± 0.6% | not timed | not timed | 9.03 ± 1.0% | 0.79 ± 5.2% | not timed | not timed | 9.83 ± 2.2% | | 1.02 | 1.11 | 12.77 |
| 14-quadratic/2x | 200 | 6.31 ± 0.7% | not timed | not timed | 4.89 ± 2.7% | 0.42 ± 3.9% | not timed | not timed | 6.24 ± 0.6% | | 1.01 | 1.29 | 15.13 |
| 14-quadratic/10x | 1000 | 1.50 ± 2.5% | not timed | not timed | 1.05 ± 7.7% | 0.09 ± 2.1% | not timed | not timed | 1.50 ± 1.2% | | 1.00 | 1.43 | 16.34 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 0.2% | not timed | not timed | 0.38 ± 30.2% | 0.46 ± 4.2% | not timed | not timed | 1.34 ± 0.3% | | 1.00 | 3.50 | 2.92 |
| 04-ruff-noqa/compile-real | 1 | 79.78 ± 0.5% | not timed | not timed | 13.08 ± 1.3% | 115.19 ± 44.5% | not timed | not timed | 79.24 ± 11.7% | | 1.01 | 6.10 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 12.70 ± 10.2% | not timed | not timed | 2.36 ± 0.7% | 5.74 ± 1.3% | not timed | not timed | 12.66 ± 5.1% | | 1.00 | 5.37 | 2.21 |
| 07-unicode-character-data/compile | 1 | 50.22 ± 0.1% | not timed | not timed | 24.56 ± 9.6% | 31.56 ± 2.1% | not timed | not timed | 50.07 ± 2.3% | | 1.00 | 2.04 | 1.59 |
| 09-aws-keys/compile-full | 1 | 34.68 ± 0.8% | not timed | not timed | 7.43 ± 1.1% | 19.27 ± 8.6% | not timed | not timed | 34.47 ± 15.8% | | 1.01 | 4.67 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 158.86 ± 2.8% | not timed | not timed | 45.17 ± 0.3% | 110.57 ± 4.4% | not timed | not timed | 156.97 ± 2.7% | | 1.01 | 3.52 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 10.61 ± 9.2% | not timed | not timed | 11.42 ± 1.3% | 14.67 ± 7.5% | not timed | not timed | 10.56 ± 1.5% | | 1.01 | 0.93 | 0.72 |
| 10-bounded-repeat/compile-capitals | 1 | 74.01 ± 1.3% | not timed | not timed | 8.72 ± 0.9% | 21.38 ± 13.0% | not timed | not timed | 72.83 ± 1.5% | | 1.02 | 8.48 | 3.46 |
| 11-unstructured-to-json/compile | 1 | 76.20 ± 0.3% | not timed | not timed | 36.10 ± 1.5% | 56.38 ± 15.0% | not timed | not timed | 75.60 ± 1.8% | | 1.01 | 2.11 | 1.35 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.0% | not timed | not timed | 0.06 ± 3.5% | 0.08 ± 20.5% | not timed | not timed | 0.28 ± 11.2% | | 1.04 | 4.57 | 3.78 |

