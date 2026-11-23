# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159303707 |
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
| literal: a word | 217 | 16239.74 ± 1.0% | 1048.69 ± 0.2% | 28.75 ± 0.5% | 18431.80 ± 1.7% | 9105.05 ± 6.6% | 17.30 ± 0.3% | 87.05 ± 0.2% | 16235.94 ± 1.1% | 15.49 | 1.00 | 0.88 | 1.78 |
| literal: a word that is not there | 0 | 18701.83 ± 1.7% | 1056.28 ± 0.2% | 28.79 ± 0.4% | 19932.85 ± 2.8% | 29190.02 ± 0.8% | 17.08 ± 0.2% | 82.99 ± 0.2% | 18728.45 ± 1.1% | 17.71 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6071.70 ± 0.4% | 1031.56 ± 0.2% | 14.69 ± 0.1% | 3950.34 ± 0.2% | 21.89 ± 0.2% | 5.42 ± 0.5% | 6.94 ± 0.9% | 6075.10 ± 0.5% | 5.89 | 1.00 | 1.54 | 277.32 |
| literal: a word in any case | 217 | 12605.10 ± 0.6% | 1048.59 ± 0.2% | 21.90 ± 0.5% | 3967.57 ± 0.4% | 38.02 ± 0.5% | refused | differs | 12584.77 ± 0.4% | 12.02 | 1.00 | 3.18 | 331.50 |
| literal: an href attribute | 33 | 13608.09 ± 1.4% | 1054.92 ± 0.3% | 27.36 ± 0.2% | 17051.41 ± 1.3% | 2254.38 ± 0.6% | 13.10 ± 0.2% | 75.64 ± 0.4% | 13600.61 ± 1.4% | 12.90 | 1.00 | 0.80 | 6.04 |
| literal: a word, second text | 123 | 16474.15 ± 1.6% | 1051.32 ± 0.1% | 28.21 ± 0.4% | 18305.63 ± 3.0% | 7625.12 ± 5.5% | 20.07 ± 0.3% | 71.10 ± 0.7% | 16512.52 ± 0.4% | 15.67 | 1.00 | 0.90 | 2.16 |
| class: two capitalized words | 1331 | 1121.61 ± 0.2% | 979.01 ± 0.1% | 26.05 ± 0.4% | 585.43 ± 0.1% | 40.59 ± 10.5% | 14.64 ± 0.3% | 69.00 ± 0.2% | 1122.35 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.63 |
| class: a word that ends in ing | 3399 | 901.61 ± 0.1% | 901.76 ± 0.1% | 18.22 ± 0.2% | 547.67 ± 0.1% | 29.62 ± 3.2% | 8.20 ± 0.2% | 18.43 ± 1.2% | 900.73 ± 0.1% | 1.00 | 1.00 | 1.65 | 30.43 |
| class: a word in capitals | 2332 | 1461.89 ± 1.1% | 955.89 ± 0.3% | 27.67 ± 0.4% | 572.68 ± 0.1% | 43.49 ± 6.3% | 17.08 ± 0.4% | 83.29 ± 1.0% | 1460.99 ± 0.3% | 1.53 | 1.00 | 2.55 | 33.61 |
| class: a number | 8288 | 2008.60 ± 0.2% | 840.39 ± 0.1% | 27.96 ± 0.8% | 1718.18 ± 0.1% | 40.25 ± 15.8% | 0.55 ± 0.2% | 56.98 ± 0.4% | 1993.98 ± 0.3% | 2.39 | 1.01 | 1.17 | 49.90 |
| class: two capitalized words, second text | 5359 | 743.88 ± 0.1% | 745.52 ± 0.4% | 23.36 ± 0.2% | 484.95 ± 0.1% | 34.10 ± 9.7% | 17.08 ± 0.3% | 64.11 ± 0.2% | 744.40 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.82 |
| other: a word between two words | 6104 | 753.82 ± 0.2% | 780.83 ± 0.1% | 23.55 ± 0.2% | 737.36 ± 0.2% | 109.83 ± 13.4% | 11.14 ± 0.1% | 70.00 ± 0.2% | 751.06 ± 0.2% | 0.97 | 1.00 | 1.02 | 6.86 |
| other: a number before a unit, second text | 1481 | 5387.13 ± 0.4% | 991.87 ± 0.3% | 26.04 ± 0.4% | 5678.52 ± 0.6% | 40.76 ± 11.6% | 18.20 ± 0.2% | 67.05 ± 0.0% | 5398.14 ± 0.7% | 5.43 | 1.00 | 0.95 | 132.17 |
| other: a heading's start tag | 110 | 12586.98 ± 0.5% | 1044.65 ± 0.2% | 27.51 ± 0.2% | 1713.67 ± 0.6% | 1580.37 ± 6.3% | 16.09 ± 0.3% | 88.98 ± 0.6% | 12641.81 ± 0.5% | 12.05 | 1.00 | 7.35 | 7.96 |
| other: a whole word | 217 | 14020.77 ± 1.8% | 1046.70 ± 0.3% | 29.55 ± 0.3% | 14483.20 ± 1.0% | 49.39 ± 0.1% | 13.21 ± 0.2% | 56.34 ± 0.3% | 14073.83 ± 1.8% | 13.40 | 1.00 | 0.97 | 283.86 |
| other: a line's first word, second text | 3716 | 1932.73 ± 0.9% | 878.77 ± 0.2% | 31.17 ± 0.7% | 1726.35 ± 0.8% | 61.84 ± 7.2% | refused | refused | 1958.00 ± 1.3% | 2.20 | 0.99 | 1.12 | 31.26 |
| other: fourteen octets before an x | 87 | 19794.35 ± 1.7% | 230.83 ± 0.2% | 6.64 ± 0.1% | 3995.76 ± 0.5% | 10.66 ± 0.3% | differs | 17.83 ± 0.2% | 19866.18 ± 0.6% | 85.75 | 1.00 | 4.95 | 1856.81 |
| other: a Greek word | 21815 | 513.61 ± 0.6% | 414.31 ± 0.3% | 31.31 ± 1.6% | 289.93 ± 0.4% | 48.09 ± 11.8% | differs | refused | 508.90 ± 0.2% | 1.24 | 1.01 | 1.77 | 10.68 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.82 ± 0.2% | 25.85 ± 0.2% | 0.87 ± 0.3% | 19.82 ± 0.4% | 2.79 ± 0.4% | differs | 4.03 ± 0.2% | 25.88 ± 0.2% | 1.00 | 1.00 | 1.30 | 9.27 |
| a UUID | 32895 | 21.09 ± 0.2% | 21.19 ± 0.2% | 0.65 ± 0.1% | 15.08 ± 0.5% | 3.10 ± 0.8% | 0.73 ± 0.4% | 3.62 ± 0.3% | 21.12 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.81 |
| an IPv4 address | 33176 | 36.88 ± 0.4% | 36.82 ± 0.5% | 2.12 ± 0.3% | 29.47 ± 0.2% | 6.63 ± 0.2% | differs | 4.16 ± 0.2% | 36.94 ± 0.1% | 1.00 | 1.00 | 1.25 | 5.56 |
| a date and time | 32954 | 31.01 ± 0.3% | 31.02 ± 0.2% | 1.47 ± 0.2% | 21.49 ± 0.7% | 7.02 ± 0.6% | 1.25 ± 0.2% | 7.17 ± 0.3% | 31.05 ± 0.2% | 1.00 | 1.00 | 1.44 | 4.42 |
| a field path | 32606 | 29.43 ± 0.1% | 29.41 ± 0.1% | 1.04 ± 0.1% | 23.33 ± 0.2% | 3.50 ± 0.9% | differs | 2.97 ± 0.4% | 29.46 ± 0.2% | 1.00 | 1.00 | 1.26 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.4% | 11.48 ± 0.3% | 11.50 ± 0.6% | 11.82 ± 0.3% | 4.97 ± 3.2% | 0.93 ± 0.3% | none | 11.52 ± 0.4% | 1.00 | 1.00 | 0.97 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.62 ± 1.2% | 237.93 ± 0.3% | 287.18 ± 0.2% | 87.33 ± 0.2% | 222.16 ± 2.2% | 488.89 ± 0.4% | 3886.69 ± 3.7% | 235.73 ± 0.2% | 0.99 | 1.00 | 2.70 | 1.06 |
| a UUID | 62 | 157.53 ± 0.2% | 157.94 ± 0.2% | 178.92 ± 0.2% | 45.84 ± 0.2% | 99.12 ± 1.5% | 182.78 ± 1.1% | 4442.49 ± 1.9% | 157.52 ± 0.2% | 1.00 | 1.00 | 3.44 | 1.59 |
| an IPv4 address | 29 | 423.15 ± 0.5% | 428.44 ± 0.4% | 613.75 ± 0.5% | 77.06 ± 1.0% | 132.44 ± 1.6% | 292.17 ± 0.7% | 7640.64 ± 0.2% | 423.57 ± 0.5% | 0.99 | 1.00 | 5.49 | 3.19 |
| a date and time | 56 | 307.47 ± 0.5% | 310.56 ± 0.4% | 396.19 ± 0.2% | 72.83 ± 0.2% | 138.52 ± 1.3% | 322.57 ± 0.4% | 4898.36 ± 0.8% | 307.53 ± 0.5% | 0.99 | 1.00 | 4.22 | 2.22 |
| a field path | 39 | 227.29 ± 0.4% | 228.83 ± 0.3% | 274.00 ± 0.3% | 80.35 ± 0.4% | 208.57 ± 2.0% | 489.32 ± 0.9% | 4953.15 ± 3.9% | 227.33 ± 0.3% | 0.99 | 1.00 | 2.83 | 1.09 |
| literal: a word | 7 | 630.77 ± 0.3% | 676.98 ± 0.4% | 1251.40 ± 0.1% | 515.49 ± 1.8% | 630.96 ± 1.5% | 918.39 ± 0.5% | 30310.30 ± 0.1% | 631.52 ± 1.2% | 0.93 | 1.00 | 1.22 | 1.00 |
| literal: a word that is not there | 8 | 606.45 ± 0.2% | 656.23 ± 0.5% | 1170.39 ± 0.2% | 469.08 ± 0.4% | 602.00 ± 4.5% | 870.47 ± 0.5% | 28971.01 ± 0.1% | 605.73 ± 0.2% | 0.92 | 1.00 | 1.29 | 1.01 |
| literal: one of four words | 26 | 242.43 ± 0.3% | 405.34 ± 0.1% | 565.14 ± 0.3% | 49.63 ± 0.2% | 244.12 ± 1.4% | 360.33 ± 0.2% | 15595.54 ± 0.2% | 242.67 ± 0.3% | 0.60 | 1.00 | 4.88 | 0.99 |
| literal: a word in any case | 11 | 489.82 ± 0.4% | 522.88 ± 0.3% | 843.63 ± 0.4% | 15.77 ± 1.0% | 651.09 ± 0.6% | refused | 23449.44 ± 0.5% | 489.54 ± 0.1% | 0.94 | 1.00 | 31.05 | 0.75 |
| literal: an href attribute | 12 | 350.57 ± 0.1% | 363.92 ± 0.2% | 490.96 ± 0.3% | 9.81 ± 27.2% | 500.12 ± 1.4% | 761.00 ± 4.2% | 21563.34 ± 0.4% | 350.59 ± 0.1% | 0.96 | 1.00 | 35.72 | 0.70 |
| literal: a word, second text | 10 | 567.34 ± 0.6% | 623.76 ± 0.5% | 1071.15 ± 0.1% | 421.62 ± 0.1% | 536.73 ± 1.7% | 816.77 ± 0.4% | 26884.44 ± 0.3% | 567.07 ± 0.5% | 0.91 | 1.00 | 1.35 | 1.06 |
| class: two capitalized words | 23 | 438.87 ± 0.4% | 467.91 ± 0.6% | 699.72 ± 0.5% | 102.69 ± 0.1% | 504.57 ± 1.3% | 756.17 ± 0.8% | 6594.43 ± 0.4% | 438.32 ± 0.3% | 0.94 | 1.00 | 4.27 | 0.87 |
| class: a word that ends in ing | 9 | 566.58 ± 0.5% | 635.97 ± 0.6% | 1159.27 ± 0.3% | 133.74 ± 1.1% | 761.03 ± 1.2% | 1100.99 ± 1.5% | 16088.59 ± 0.3% | 566.54 ± 0.2% | 0.89 | 1.00 | 4.24 | 0.74 |
| class: a word in capitals | 16 | 501.84 ± 1.0% | 539.83 ± 0.5% | 895.53 ± 0.1% | 134.93 ± 2.1% | 753.63 ± 0.7% | 1051.50 ± 1.0% | 8662.81 ± 0.1% | 501.77 ± 0.3% | 0.93 | 1.00 | 3.72 | 0.67 |
| class: a number | 6 | 628.51 ± 0.4% | 695.44 ± 0.2% | 1359.19 ± 0.1% | 42.15 ± 0.9% | 1411.01 ± 0.9% | 1883.55 ± 1.1% | 22719.79 ± 0.2% | 628.56 ± 0.4% | 0.90 | 1.00 | 14.91 | 0.45 |
| class: two capitalized words, second text | 23 | 437.96 ± 0.3% | 468.14 ± 0.2% | 698.33 ± 0.5% | 101.42 ± 0.5% | 505.68 ± 4.1% | 749.03 ± 0.6% | 6592.40 ± 0.5% | 438.87 ± 0.4% | 0.94 | 1.00 | 4.32 | 0.87 |
| other: a word between two words | 13 | 551.59 ± 0.3% | 569.91 ± 0.6% | 936.71 ± 0.2% | 137.92 ± 0.4% | 503.57 ± 2.3% | 824.80 ± 1.7% | 14946.12 ± 0.1% | 551.79 ± 0.2% | 0.97 | 1.00 | 4.00 | 1.10 |
| other: a number before a unit, second text | 15 | 408.33 ± 0.2% | 448.11 ± 0.6% | 648.06 ± 0.1% | 39.60 ± 0.3% | 632.92 ± 3.3% | 889.82 ± 1.7% | 15165.38 ± 0.2% | 408.49 ± 0.2% | 0.91 | 1.00 | 10.31 | 0.65 |
| other: a heading's start tag | 13 | 361.29 ± 0.7% | 366.61 ± 0.6% | 497.21 ± 0.3% | 10.15 ± 22.4% | 629.96 ± 1.0% | 874.86 ± 1.6% | 18056.56 ± 0.4% | 361.08 ± 0.4% | 0.99 | 1.00 | 35.60 | 0.57 |
| other: a whole word | 11 | 587.71 ± 0.5% | 624.39 ± 0.3% | 1082.23 ± 0.3% | 120.53 ± 0.3% | 563.26 ± 2.6% | 836.02 ± 1.1% | 26760.64 ± 0.2% | 588.61 ± 0.3% | 0.94 | 1.00 | 4.88 | 1.04 |
| other: a line's first word, second text | 17 | 538.37 ± 0.4% | 559.42 ± 0.4% | 937.70 ± 0.2% | 130.25 ± 0.1% | 711.72 ± 0.9% | refused | refused | 536.94 ± 0.3% | 0.96 | 1.00 | 4.13 | 0.76 |
| other: fourteen octets before an x | 16 | 112.02 ± 0.4% | 162.58 ± 0.9% | 190.55 ± 0.8% | 7.25 ± 19.3% | 453.26 ± 4.0% | 414.09 ± 0.7% | 12656.43 ± 0.4% | 112.15 ± 0.9% | 0.69 | 1.00 | 15.44 | 0.25 |
| other: a Greek word | 8 | 431.57 ± 0.3% | 591.67 ± 0.6% | 1032.02 ± 0.2% | 10.83 ± 3.2% | 1390.44 ± 0.9% | 1813.63 ± 0.5% | refused | 431.61 ± 0.1% | 0.73 | 1.00 | 39.85 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12846.46 ± 0.4% | not timed | not timed | 16354.39 ± 1.3% | 2130.13 ± 10.0% | not timed | not timed | 12832.67 ± 0.6% | | 1.00 | 0.79 | 6.03 |
| 01-literal/sherlock-casei-en | 522 | 4469.83 ± 1.2% | not timed | not timed | 3594.66 ± 0.2% | 32.43 ± 0.7% | not timed | not timed | 4485.85 ± 0.1% | | 1.00 | 1.24 | 137.83 |
| 01-literal/sherlock-ru | 724 | 13486.63 ± 0.6% | not timed | not timed | 17363.09 ± 0.6% | 1491.38 ± 9.9% | not timed | not timed | 13484.40 ± 1.0% | | 1.00 | 0.78 | 9.04 |
| 01-literal/sherlock-casei-ru | 746 | 5283.23 ± 0.4% | not timed | not timed | 3312.88 ± 0.0% | 31.67 ± 1.5% | not timed | not timed | 5289.68 ± 0.3% | | 1.00 | 1.59 | 166.82 |
| 01-literal/sherlock-zh | 30 | 17015.48 ± 0.3% | not timed | not timed | 18812.02 ± 0.3% | 2779.58 ± 9.5% | not timed | not timed | 16977.85 ± 0.6% | | 1.00 | 0.90 | 6.12 |
| 02-literal-alternate/sherlock-en | 714 | 5749.44 ± 0.7% | not timed | not timed | 3941.88 ± 0.3% | 16.62 ± 0.1% | not timed | not timed | 5743.83 ± 0.6% | | 1.00 | 1.46 | 345.97 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.54 ± 1.2% | not timed | not timed | 697.98 ± 0.2% | 11.12 ± 0.2% | not timed | not timed | 1702.53 ± 0.5% | | 1.01 | 2.45 | 153.93 |
| 02-literal-alternate/sherlock-ru | 899 | 4648.63 ± 0.3% | not timed | not timed | 3254.88 ± 0.2% | 22.61 ± 0.2% | not timed | not timed | 4657.05 ± 0.3% | | 1.00 | 1.43 | 205.60 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1808.01 ± 0.7% | not timed | not timed | 1228.07 ± 0.2% | 9.14 ± 5.4% | not timed | not timed | 1801.12 ± 0.5% | | 1.00 | 1.47 | 197.79 |
| 02-literal-alternate/sherlock-zh | 207 | 7027.58 ± 0.2% | not timed | not timed | 4166.02 ± 0.1% | 31.41 ± 0.3% | not timed | not timed | 7029.17 ± 0.2% | | 1.00 | 1.69 | 223.74 |
| 03-date/ascii | 111817 | 126.72 ± 0.6% | not timed | not timed | 96.43 ± 0.0% | 0.20 ± 1.7% | not timed | not timed | 126.07 ± 0.8% | | 1.01 | 1.31 | 625.44 |
| 04-ruff-noqa/real | 84 | 556.04 ± 0.1% | not timed | not timed | 477.41 ± 0.0% | 19.17 ± 0.1% | not timed | not timed | 555.76 ± 0.1% | | 1.00 | 1.16 | 29.00 |
| 04-ruff-noqa/tweaked | 44 | 543.02 ± 0.2% | not timed | not timed | 466.35 ± 0.1% | 367.36 ± 0.5% | not timed | not timed | 542.57 ± 0.2% | | 1.00 | 1.16 | 1.48 |
| 05-lexer-veryl/single | 124800 | 4.25 ± 0.7% | not timed | not timed | 5.23 ± 0.4% | 0.21 ± 4.1% | not timed | not timed | 4.27 ± 2.5% | | 1.00 | 0.81 | 20.48 |
| 06-cloud-flare-redos/original | 107 | 259.66 ± 0.2% | not timed | not timed | 214.56 ± 0.1% | 24.98 ± 0.2% | not timed | not timed | 260.06 ± 0.4% | | 1.00 | 1.21 | 10.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.17 ± 0.2% | not timed | not timed | 228.55 ± 0.1% | 26.60 ± 0.2% | not timed | not timed | 254.90 ± 0.1% | | 1.00 | 1.12 | 9.59 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.16 ± 0.1% | not timed | not timed | 255.43 ± 0.1% | 28.79 ± 0.1% | not timed | not timed | 292.14 ± 0.2% | | 1.00 | 1.14 | 10.15 |
| 07-unicode-character-data/parse-line | 558784 | 234.70 ± 2.1% | not timed | not timed | 180.12 ± 0.2% | 42.41 ± 4.5% | not timed | not timed | 229.50 ± 1.8% | | 1.02 | 1.30 | 5.53 |
| 08-words/all-english | 56691 | 121.83 ± 0.4% | not timed | not timed | 82.96 ± 0.1% | 11.78 ± 15.1% | not timed | not timed | 121.46 ± 0.6% | | 1.00 | 1.47 | 10.35 |
| 08-words/long-english | 839 | 1012.93 ± 0.1% | not timed | not timed | 597.44 ± 0.1% | 32.64 ± 0.4% | not timed | not timed | 1012.55 ± 0.2% | | 1.00 | 1.70 | 31.03 |
| 09-aws-keys/full | 0 | 408.77 ± 0.0% | not timed | not timed | 491.81 ± 0.1% | 64.02 ± 0.2% | not timed | not timed | 408.52 ± 0.1% | | 1.00 | 0.83 | 6.38 |
| 09-aws-keys/quick | 0 | 746.30 ± 0.1% | not timed | not timed | 1002.08 ± 0.3% | 418.50 ± 0.8% | not timed | not timed | 743.58 ± 0.1% | | 1.00 | 0.74 | 1.78 |
| 10-bounded-repeat/letters-en | 1833 | 636.46 ± 0.4% | not timed | not timed | 517.10 ± 1.0% | 19.48 ± 0.4% | not timed | not timed | 634.76 ± 0.4% | | 1.00 | 1.23 | 32.67 |
| 10-bounded-repeat/letters-ru | 3475 | 382.60 ± 0.1% | not timed | not timed | 479.03 ± 0.0% | 21.93 ± 7.1% | not timed | not timed | 381.43 ± 0.6% | | 1.00 | 0.80 | 17.44 |
| 10-bounded-repeat/context | 53 | 79.60 ± 1.1% | not timed | not timed | 65.82 ± 0.7% | 19.83 ± 0.1% | not timed | not timed | 79.82 ± 1.5% | | 1.00 | 1.21 | 4.01 |
| 10-bounded-repeat/capitals | 11 | 1055.11 ± 0.3% | not timed | not timed | 616.79 ± 0.0% | 35.56 ± 0.1% | not timed | not timed | 1055.16 ± 0.2% | | 1.00 | 1.71 | 29.67 |
| 11-unstructured-to-json/extract | 600 | 49.34 ± 0.3% | not timed | not timed | 76.72 ± 0.2% | 48.99 ± 0.6% | not timed | not timed | 48.48 ± 0.8% | | 1.02 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 566.43 ± 0.2% | not timed | not timed | 554.88 ± 0.3% | 0.40 ± 0.2% | not timed | not timed | 569.57 ± 0.7% | | 0.99 | 1.02 | 1401.83 |
| 14-quadratic/1x | 100 | 12.81 ± 0.5% | not timed | not timed | 10.12 ± 0.2% | 0.98 ± 3.0% | not timed | not timed | 12.64 ± 1.3% | | 1.01 | 1.27 | 13.08 |
| 14-quadratic/2x | 200 | 7.95 ± 1.8% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 1.0% | not timed | not timed | 7.90 ± 1.3% | | 1.01 | 1.43 | 14.93 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.5% | not timed | not timed | 1.88 ± 0.3% | | 1.00 | 1.55 | 16.29 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.2% | 0.55 ± 3.6% | not timed | not timed | 1.44 ± 0.9% | | 1.00 | 4.21 | 2.65 |
| 04-ruff-noqa/compile-real | 1 | 92.90 ± 1.6% | not timed | not timed | 13.74 ± 0.6% | 136.64 ± 4.5% | not timed | not timed | 93.06 ± 0.7% | | 1.00 | 6.76 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 14.66 ± 0.2% | not timed | not timed | 2.50 ± 0.3% | 6.36 ± 3.3% | not timed | not timed | 14.65 ± 1.2% | | 1.00 | 5.85 | 2.31 |
| 07-unicode-character-data/compile | 1 | 58.35 ± 0.1% | not timed | not timed | 25.68 ± 0.3% | 35.28 ± 3.3% | not timed | not timed | 58.39 ± 0.4% | | 1.00 | 2.27 | 1.65 |
| 09-aws-keys/compile-full | 1 | 43.73 ± 0.2% | not timed | not timed | 8.25 ± 0.2% | 22.69 ± 2.9% | not timed | not timed | 43.44 ± 0.9% | | 1.01 | 5.30 | 1.93 |
| 09-aws-keys/compile-quick | 1 | 187.74 ± 0.2% | not timed | not timed | 46.88 ± 0.7% | 129.71 ± 2.7% | not timed | not timed | 189.60 ± 0.4% | | 0.99 | 4.00 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 14.72 ± 0.9% | not timed | not timed | 11.11 ± 0.2% | 15.62 ± 3.0% | not timed | not timed | 14.47 ± 2.2% | | 1.02 | 1.33 | 0.94 |
| 10-bounded-repeat/compile-capitals | 1 | 86.09 ± 0.8% | not timed | not timed | 8.07 ± 0.1% | 23.55 ± 2.8% | not timed | not timed | 85.46 ± 0.9% | | 1.01 | 10.67 | 3.66 |
| 11-unstructured-to-json/compile | 1 | 90.89 ± 0.3% | not timed | not timed | 40.89 ± 0.4% | 66.19 ± 5.1% | not timed | not timed | 90.70 ± 0.3% | | 1.00 | 2.22 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.36 ± 1.7% | not timed | not timed | 0.07 ± 32.0% | 0.10 ± 9.1% | not timed | not timed | 0.36 ± 1.5% | | 1.01 | 5.42 | 3.73 |

