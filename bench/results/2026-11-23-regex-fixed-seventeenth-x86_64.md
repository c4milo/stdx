# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159335181 |
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
| literal: a word | 217 | 27712.63 ± 0.7% | 898.28 ± 0.9% | 27.97 ± 0.4% | 25639.03 ± 0.1% | 8521.77 ± 6.2% | 12.35 ± 0.2% | 88.58 ± 0.3% | 27636.51 ± 0.4% | 30.85 | 1.00 | 1.08 | 3.25 |
| literal: a word that is not there | 0 | 33934.51 ± 22.2% | 911.03 ± 0.9% | 27.99 ± 0.4% | 28606.71 ± 0.3% | 23526.68 ± 0.4% | 12.08 ± 0.3% | 84.00 ± 2.1% | 33754.49 ± 4.0% | 37.25 | 1.01 | 1.19 | 1.44 |
| literal: one of four words | 661 | 10834.95 ± 0.7% | 856.10 ± 0.5% | 14.20 ± 1.3% | 7940.75 ± 1.4% | 20.22 ± 3.5% | 3.72 ± 7.3% | 6.67 ± 1.0% | 10708.65 ± 3.4% | 12.66 | 1.01 | 1.36 | 535.96 |
| literal: a word in any case | 217 | 23155.18 ± 2.0% | 884.22 ± 1.0% | 19.97 ± 3.4% | 8174.38 ± 4.4% | 39.77 ± 2.6% | refused | differs | 22869.47 ± 3.4% | 26.19 | 1.01 | 2.83 | 582.19 |
| literal: an href attribute | 33 | 23435.07 ± 0.9% | 908.34 ± 1.1% | 25.28 ± 1.6% | 23870.92 ± 1.3% | 1889.27 ± 0.7% | 8.94 ± 0.2% | 78.43 ± 0.4% | 23350.56 ± 1.1% | 25.80 | 1.00 | 0.98 | 12.40 |
| literal: a word, second text | 123 | 28849.95 ± 0.7% | 904.59 ± 1.0% | 27.54 ± 0.9% | 25503.30 ± 0.2% | 6604.43 ± 8.9% | 15.14 ± 0.5% | 76.67 ± 0.6% | 28831.42 ± 1.7% | 31.89 | 1.00 | 1.13 | 4.37 |
| class: two capitalized words | 1331 | 870.40 ± 2.0% | 853.27 ± 0.6% | 25.66 ± 3.1% | 545.15 ± 0.7% | 36.16 ± 0.6% | 10.51 ± 0.1% | 66.34 ± 2.9% | 863.94 ± 0.5% | 1.02 | 1.01 | 1.60 | 24.07 |
| class: a word that ends in ing | 3399 | 753.92 ± 0.8% | 752.90 ± 0.3% | 16.80 ± 1.4% | 502.83 ± 0.5% | 26.38 ± 7.1% | 5.90 ± 0.1% | 18.90 ± 0.7% | 751.80 ± 0.4% | 1.00 | 1.00 | 1.50 | 28.58 |
| class: a word in capitals | 2332 | 1134.33 ± 0.9% | 830.02 ± 1.5% | 27.25 ± 3.6% | 532.96 ± 0.4% | 38.50 ± 3.3% | 12.43 ± 2.3% | 83.24 ± 0.2% | 1132.58 ± 0.4% | 1.37 | 1.00 | 2.13 | 29.46 |
| class: a number | 8288 | 1562.76 ± 2.9% | 702.64 ± 0.3% | 27.10 ± 0.4% | 1636.57 ± 0.4% | 39.03 ± 7.6% | 0.36 ± 0.3% | 61.00 ± 0.5% | 1572.38 ± 2.9% | 2.22 | 0.99 | 0.95 | 40.04 |
| class: two capitalized words, second text | 5359 | 624.52 ± 0.9% | 624.02 ± 1.0% | 23.07 ± 0.8% | 442.95 ± 0.2% | 30.58 ± 8.7% | 13.24 ± 0.3% | 61.27 ± 0.2% | 617.55 ± 2.3% | 1.00 | 1.01 | 1.41 | 20.42 |
| other: a word between two words | 6104 | 735.89 ± 0.3% | 656.66 ± 0.1% | 22.86 ± 0.9% | 723.19 ± 2.2% | 95.67 ± 8.1% | 8.02 ± 1.7% | 69.62 ± 4.1% | 730.94 ± 0.4% | 1.12 | 1.01 | 1.02 | 7.69 |
| other: a number before a unit, second text | 1481 | 7491.57 ± 2.8% | 835.46 ± 0.9% | 24.72 ± 0.5% | 6912.43 ± 3.1% | 36.63 ± 3.7% | 13.91 ± 0.2% | 65.05 ± 0.3% | 7377.39 ± 3.1% | 8.97 | 1.02 | 1.08 | 204.53 |
| other: a heading's start tag | 110 | 18632.25 ± 1.2% | 910.24 ± 0.5% | 26.99 ± 0.9% | 2018.32 ± 1.7% | 1351.78 ± 2.4% | 11.03 ± 0.5% | 89.83 ± 0.5% | 18729.89 ± 0.2% | 20.47 | 0.99 | 9.23 | 13.78 |
| other: a whole word | 217 | 20898.02 ± 0.7% | 893.17 ± 1.2% | 28.36 ± 4.7% | 19806.58 ± 0.3% | 45.36 ± 6.8% | 10.62 ± 0.2% | 53.28 ± 0.6% | 20897.85 ± 1.1% | 23.40 | 1.00 | 1.06 | 460.76 |
| other: a line's first word, second text | 3716 | 2027.51 ± 0.5% | 732.03 ± 0.5% | 29.87 ± 0.9% | 1901.04 ± 2.0% | 58.96 ± 1.8% | refused | refused | 2021.04 ± 0.3% | 2.77 | 1.00 | 1.07 | 34.39 |
| other: fourteen octets before an x | 87 | 27719.90 ± 3.0% | 261.95 ± 4.8% | 6.12 ± 0.2% | 3500.20 ± 0.7% | 8.85 ± 3.0% | differs | 17.49 ± 4.8% | 27462.74 ± 1.9% | 105.82 | 1.01 | 7.92 | 3133.71 |
| other: a Greek word | 21815 | 429.05 ± 0.6% | 343.60 ± 1.6% | 27.77 ± 2.6% | 254.73 ± 0.6% | 45.49 ± 19.4% | differs | refused | 427.67 ± 0.3% | 1.25 | 1.00 | 1.68 | 9.43 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.41 ± 0.8% | 23.35 ± 0.7% | 0.88 ± 0.9% | 18.73 ± 0.2% | 2.42 ± 1.1% | differs | 4.16 ± 0.3% | 23.46 ± 0.4% | 1.00 | 1.00 | 1.25 | 9.66 |
| a UUID | 32895 | 19.84 ± 1.2% | 19.65 ± 0.5% | 0.60 ± 3.9% | 14.07 ± 1.5% | 2.50 ± 0.3% | 0.54 ± 0.1% | 3.18 ± 6.3% | 19.32 ± 6.2% | 1.01 | 1.03 | 1.41 | 7.95 |
| an IPv4 address | 33176 | 32.19 ± 0.3% | 32.07 ± 0.6% | 1.97 ± 5.9% | 25.11 ± 0.2% | 5.95 ± 0.2% | differs | 3.89 ± 0.4% | 32.17 ± 0.4% | 1.00 | 1.00 | 1.28 | 5.41 |
| a date and time | 32954 | 27.50 ± 0.9% | 27.69 ± 0.9% | 1.39 ± 6.0% | 20.44 ± 0.5% | 7.20 ± 0.4% | 0.94 ± 0.2% | 7.33 ± 0.3% | 27.72 ± 5.7% | 0.99 | 0.99 | 1.35 | 3.82 |
| a field path | 32606 | 25.92 ± 1.8% | 26.11 ± 2.0% | 0.98 ± 3.2% | 21.30 ± 0.4% | 2.85 ± 0.2% | differs | 2.52 ± 2.1% | 25.96 ± 2.0% | 0.99 | 1.00 | 1.22 | 9.11 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.98 ± 0.5% | 7.99 ± 0.4% | 8.03 ± 0.5% | 11.41 ± 0.5% | 4.61 ± 6.9% | 0.76 ± 0.4% | none | 7.97 ± 0.4% | 1.00 | 1.00 | 0.70 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.10 ± 1.0% | 225.70 ± 0.3% | 268.13 ± 9.0% | 84.96 ± 3.6% | 177.90 ± 15.1% | 542.22 ± 3.2% | 3527.82 ± 0.8% | 224.68 ± 6.1% | 1.00 | 1.00 | 2.65 | 1.27 |
| a UUID | 62 | 149.64 ± 8.5% | 150.57 ± 0.1% | 169.10 ± 0.8% | 47.16 ± 2.9% | 85.61 ± 1.9% | 193.21 ± 2.8% | 4425.04 ± 0.6% | 149.69 ± 1.0% | 0.99 | 1.00 | 3.17 | 1.75 |
| an IPv4 address | 29 | 424.54 ± 0.2% | 427.95 ± 0.4% | 606.64 ± 0.3% | 74.48 ± 1.6% | 110.77 ± 21.6% | 325.43 ± 1.0% | 7652.74 ± 1.3% | 424.50 ± 0.3% | 0.99 | 1.00 | 5.70 | 3.83 |
| a date and time | 56 | 331.20 ± 1.9% | 333.53 ± 5.6% | 431.70 ± 0.9% | 72.32 ± 2.2% | 117.97 ± 2.9% | 350.99 ± 0.7% | 4518.80 ± 5.7% | 331.13 ± 2.0% | 0.99 | 1.00 | 4.58 | 2.81 |
| a field path | 39 | 225.27 ± 2.0% | 226.26 ± 0.2% | 267.51 ± 0.6% | 76.58 ± 2.4% | 172.24 ± 0.9% | 550.45 ± 1.3% | 4487.41 ± 0.8% | 225.42 ± 2.7% | 1.00 | 1.00 | 2.94 | 1.31 |
| literal: a word | 7 | 653.81 ± 0.3% | 697.09 ± 0.3% | 1258.35 ± 0.3% | 496.13 ± 0.7% | 537.36 ± 21.2% | 1221.11 ± 0.6% | 26092.79 ± 7.3% | 653.29 ± 0.2% | 0.94 | 1.00 | 1.32 | 1.22 |
| literal: a word that is not there | 8 | 625.72 ± 0.4% | 671.99 ± 0.4% | 1180.76 ± 0.4% | 465.99 ± 0.3% | 520.85 ± 2.1% | 1141.09 ± 1.7% | 27047.55 ± 0.5% | 624.70 ± 0.2% | 0.93 | 1.00 | 1.34 | 1.20 |
| literal: one of four words | 26 | 247.13 ± 0.4% | 405.65 ± 0.2% | 557.56 ± 3.4% | 40.92 ± 8.8% | 208.48 ± 1.7% | 437.69 ± 1.3% | 16582.14 ± 1.3% | 246.82 ± 0.2% | 0.61 | 1.00 | 6.04 | 1.19 |
| literal: a word in any case | 11 | 528.98 ± 3.9% | 564.65 ± 9.7% | 904.84 ± 1.2% | 13.90 ± 4.8% | 556.45 ± 14.7% | refused | 21754.94 ± 1.4% | 529.17 ± 2.4% | 0.94 | 1.00 | 38.05 | 0.95 |
| literal: an href attribute | 12 | 348.72 ± 2.0% | 360.04 ± 11.2% | 483.19 ± 0.3% | 37.16 ± 7.2% | 411.14 ± 15.6% | 911.87 ± 0.7% | 20971.37 ± 0.7% | 349.37 ± 6.7% | 0.97 | 1.00 | 9.38 | 0.85 |
| literal: a word, second text | 10 | 579.98 ± 9.5% | 634.37 ± 0.9% | 1065.41 ± 4.9% | 421.39 ± 8.8% | 446.38 ± 3.0% | 966.85 ± 1.2% | 25766.63 ± 0.8% | 581.15 ± 9.4% | 0.91 | 1.00 | 1.38 | 1.30 |
| class: two capitalized words | 23 | 461.66 ± 1.1% | 497.36 ± 0.2% | 742.05 ± 0.6% | 100.57 ± 0.6% | 420.62 ± 2.4% | 863.16 ± 1.3% | 5766.66 ± 0.3% | 461.82 ± 0.9% | 0.93 | 1.00 | 4.59 | 1.10 |
| class: a word that ends in ing | 9 | 569.95 ± 0.6% | 650.66 ± 0.9% | 1179.26 ± 1.3% | 126.67 ± 1.5% | 619.31 ± 0.6% | 1256.89 ± 10.6% | 14782.17 ± 0.6% | 567.18 ± 0.7% | 0.88 | 1.00 | 4.50 | 0.92 |
| class: a word in capitals | 16 | 531.86 ± 0.3% | 580.94 ± 0.8% | 997.89 ± 0.1% | 132.27 ± 0.9% | 607.76 ± 1.7% | 1205.78 ± 3.5% | 7604.06 ± 0.3% | 530.71 ± 0.8% | 0.92 | 1.00 | 4.02 | 0.88 |
| class: a number | 6 | 643.55 ± 1.2% | 715.17 ± 0.2% | 1396.49 ± 0.2% | 35.82 ± 1.3% | 1143.76 ± 14.4% | 2215.25 ± 3.7% | 20167.79 ± 0.7% | 642.92 ± 1.0% | 0.90 | 1.00 | 17.97 | 0.56 |
| class: two capitalized words, second text | 23 | 462.70 ± 0.5% | 496.42 ± 0.4% | 742.34 ± 0.6% | 101.66 ± 0.9% | 426.71 ± 2.6% | 867.90 ± 8.2% | 5772.32 ± 0.3% | 461.68 ± 1.6% | 0.93 | 1.00 | 4.55 | 1.08 |
| other: a word between two words | 13 | 564.36 ± 2.4% | 582.68 ± 0.3% | 953.83 ± 0.4% | 134.48 ± 0.8% | 407.50 ± 49.2% | 929.39 ± 1.6% | 13813.92 ± 0.4% | 564.67 ± 0.3% | 0.97 | 1.00 | 4.20 | 1.38 |
| other: a number before a unit, second text | 15 | 409.85 ± 6.2% | 457.73 ± 0.2% | 657.11 ± 5.5% | 33.32 ± 0.5% | 521.08 ± 2.6% | 1037.65 ± 4.4% | 14550.73 ± 9.4% | 409.26 ± 0.1% | 0.90 | 1.00 | 12.30 | 0.79 |
| other: a heading's start tag | 13 | 363.07 ± 0.3% | 369.99 ± 0.3% | 495.94 ± 0.3% | 35.79 ± 3.5% | 517.66 ± 25.6% | 990.91 ± 2.2% | 17556.09 ± 0.7% | 363.01 ± 0.6% | 0.98 | 1.00 | 10.15 | 0.70 |
| other: a whole word | 11 | 579.52 ± 0.7% | 614.06 ± 1.0% | 1022.71 ± 3.2% | 117.10 ± 8.6% | 470.60 ± 1.8% | 982.36 ± 8.1% | 24214.29 ± 7.9% | 579.92 ± 0.2% | 0.94 | 1.00 | 4.95 | 1.23 |
| other: a line's first word, second text | 17 | 556.76 ± 4.9% | 585.56 ± 10.5% | 985.88 ± 4.5% | 126.07 ± 5.6% | 568.17 ± 8.4% | refused | refused | 553.72 ± 8.8% | 0.95 | 1.01 | 4.42 | 0.98 |
| other: fourteen octets before an x | 16 | 89.39 ± 5.1% | 143.40 ± 0.3% | 174.12 ± 0.3% | 15.06 ± 1.1% | 374.93 ± 6.7% | 444.29 ± 2.1% | 12124.93 ± 0.9% | 89.31 ± 0.3% | 0.62 | 1.00 | 5.94 | 0.24 |
| other: a Greek word | 8 | 419.49 ± 0.9% | 583.14 ± 1.0% | 966.77 ± 0.7% | 45.47 ± 0.1% | 1125.53 ± 1.1% | 2129.15 ± 1.1% | refused | 419.68 ± 0.6% | 0.72 | 1.00 | 9.23 | 0.37 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20755.66 ± 13.3% | not timed | not timed | 22340.53 ± 0.7% | 1855.48 ± 19.0% | not timed | not timed | 20725.12 ± 1.1% | | 1.00 | 0.93 | 11.19 |
| 01-literal/sherlock-casei-en | 522 | 6503.59 ± 3.0% | not timed | not timed | 6781.75 ± 0.2% | 29.67 ± 1.1% | not timed | not timed | 6459.78 ± 0.8% | | 1.01 | 0.96 | 219.17 |
| 01-literal/sherlock-ru | 724 | 19247.09 ± 0.2% | not timed | not timed | 19990.88 ± 5.0% | 1150.05 ± 3.3% | not timed | not timed | 19204.48 ± 0.6% | | 1.00 | 0.96 | 16.74 |
| 01-literal/sherlock-casei-ru | 746 | 7312.82 ± 0.2% | not timed | not timed | 5547.46 ± 0.3% | 32.33 ± 0.5% | not timed | not timed | 7262.85 ± 0.2% | | 1.01 | 1.32 | 226.22 |
| 01-literal/sherlock-zh | 30 | 33044.71 ± 8.0% | not timed | not timed | 27836.48 ± 0.3% | 1102.42 ± 1.6% | not timed | not timed | 33018.16 ± 0.3% | | 1.00 | 1.19 | 29.97 |
| 02-literal-alternate/sherlock-en | 714 | 9935.52 ± 2.2% | not timed | not timed | 7696.54 ± 0.6% | 16.04 ± 5.3% | not timed | not timed | 9918.42 ± 9.2% | | 1.00 | 1.29 | 619.61 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1758.99 ± 1.1% | not timed | not timed | 2059.04 ± 0.3% | 9.84 ± 0.1% | not timed | not timed | 1785.93 ± 1.1% | | 0.98 | 0.85 | 178.82 |
| 02-literal-alternate/sherlock-ru | 899 | 6114.28 ± 0.5% | not timed | not timed | 4428.01 ± 0.8% | 21.47 ± 0.3% | not timed | not timed | 6088.73 ± 0.5% | | 1.00 | 1.38 | 284.75 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1872.01 ± 0.5% | not timed | not timed | 1067.54 ± 0.3% | 8.80 ± 2.9% | not timed | not timed | 1883.74 ± 1.6% | | 0.99 | 1.75 | 212.64 |
| 02-literal-alternate/sherlock-zh | 207 | 13602.99 ± 0.3% | not timed | not timed | 8877.04 ± 0.2% | 30.40 ± 9.5% | not timed | not timed | 13557.30 ± 0.1% | | 1.00 | 1.53 | 447.46 |
| 03-date/ascii | 111817 | 105.11 ± 2.4% | not timed | not timed | 89.67 ± 3.9% | 0.17 ± 1.4% | not timed | not timed | 103.70 ± 4.2% | | 1.01 | 1.17 | 626.41 |
| 04-ruff-noqa/real | 84 | 562.14 ± 0.6% | not timed | not timed | 460.53 ± 2.0% | 17.10 ± 2.0% | not timed | not timed | 561.06 ± 0.4% | | 1.00 | 1.22 | 32.87 |
| 04-ruff-noqa/tweaked | 44 | 461.17 ± 3.8% | not timed | not timed | 434.79 ± 0.3% | 299.32 ± 12.4% | not timed | not timed | 460.95 ± 0.6% | | 1.00 | 1.06 | 1.54 |
| 05-lexer-veryl/single | 124800 | 3.49 ± 1.1% | not timed | not timed | 4.55 ± 0.4% | 0.21 ± 4.8% | not timed | not timed | 3.51 ± 7.0% | | 0.99 | 0.77 | 16.58 |
| 06-cloud-flare-redos/original | 107 | 204.96 ± 0.5% | not timed | not timed | 200.03 ± 1.4% | 22.57 ± 11.9% | not timed | not timed | 205.55 ± 0.6% | | 1.00 | 1.02 | 9.08 |
| 06-cloud-flare-redos/simplified-short | 102 | 200.63 ± 0.4% | not timed | not timed | 206.47 ± 2.1% | 25.03 ± 0.2% | not timed | not timed | 200.71 ± 4.5% | | 1.00 | 0.97 | 8.02 |
| 06-cloud-flare-redos/simplified-long | 10000 | 217.80 ± 0.1% | not timed | not timed | 226.65 ± 0.7% | 27.61 ± 10.9% | not timed | not timed | 217.59 ± 0.5% | | 1.00 | 0.96 | 7.89 |
| 07-unicode-character-data/parse-line | 558784 | 194.58 ± 13.6% | not timed | not timed | 160.51 ± 0.3% | 37.75 ± 11.3% | not timed | not timed | 193.62 ± 3.2% | | 1.00 | 1.21 | 5.15 |
| 08-words/all-english | 56691 | 94.61 ± 8.2% | not timed | not timed | 76.24 ± 0.1% | 11.39 ± 2.1% | not timed | not timed | 93.13 ± 2.5% | | 1.02 | 1.24 | 8.30 |
| 08-words/long-english | 839 | 841.69 ± 0.8% | not timed | not timed | 552.63 ± 0.3% | 28.19 ± 8.7% | not timed | not timed | 844.66 ± 0.8% | | 1.00 | 1.52 | 29.86 |
| 09-aws-keys/full | 0 | 466.44 ± 8.3% | not timed | not timed | 447.24 ± 0.1% | 57.00 ± 1.1% | not timed | not timed | 461.10 ± 0.5% | | 1.01 | 1.04 | 8.18 |
| 09-aws-keys/quick | 0 | 825.06 ± 1.5% | not timed | not timed | 798.74 ± 1.4% | 342.38 ± 13.5% | not timed | not timed | 807.43 ± 0.3% | | 1.02 | 1.03 | 2.41 |
| 10-bounded-repeat/letters-en | 1833 | 541.18 ± 2.1% | not timed | not timed | 478.39 ± 1.1% | 18.68 ± 1.6% | not timed | not timed | 537.64 ± 0.4% | | 1.01 | 1.13 | 28.97 |
| 10-bounded-repeat/letters-ru | 3475 | 337.15 ± 0.4% | not timed | not timed | 434.50 ± 1.2% | 20.86 ± 7.4% | not timed | not timed | 334.41 ± 0.6% | | 1.01 | 0.78 | 16.16 |
| 10-bounded-repeat/context | 53 | 72.70 ± 1.4% | not timed | not timed | 59.59 ± 0.7% | 18.27 ± 2.2% | not timed | not timed | 73.25 ± 1.2% | | 0.99 | 1.22 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 895.96 ± 2.3% | not timed | not timed | 576.82 ± 0.5% | 33.02 ± 0.3% | not timed | not timed | 895.98 ± 2.4% | | 1.00 | 1.55 | 27.14 |
| 11-unstructured-to-json/extract | 600 | 41.78 ± 7.0% | not timed | not timed | 69.04 ± 0.2% | 44.63 ± 0.9% | not timed | not timed | 41.71 ± 5.0% | | 1.00 | 0.61 | 0.94 |
| 12-dictionary/single | 1 | 521.20 ± 0.4% | not timed | not timed | 502.20 ± 0.9% | 0.27 ± 2.1% | not timed | not timed | 524.15 ± 3.7% | | 0.99 | 1.04 | 1948.90 |
| 14-quadratic/1x | 100 | 11.14 ± 0.3% | not timed | not timed | 11.81 ± 1.9% | 0.89 ± 18.6% | not timed | not timed | 11.13 ± 1.2% | | 1.00 | 0.94 | 12.56 |
| 14-quadratic/2x | 200 | 6.85 ± 0.6% | not timed | not timed | 5.91 ± 0.5% | 0.49 ± 0.9% | not timed | not timed | 6.84 ± 0.9% | | 1.00 | 1.16 | 13.94 |
| 14-quadratic/10x | 1000 | 1.60 ± 3.3% | not timed | not timed | 1.16 ± 0.1% | 0.11 ± 1.8% | not timed | not timed | 1.60 ± 0.6% | | 1.00 | 1.37 | 14.65 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.58 ± 0.6% | not timed | not timed | 0.34 ± 0.2% | 0.47 ± 5.4% | not timed | not timed | 1.57 ± 1.9% | | 1.01 | 4.62 | 3.34 |
| 04-ruff-noqa/compile-real | 1 | 102.97 ± 0.1% | not timed | not timed | 12.34 ± 0.9% | 122.99 ± 4.9% | not timed | not timed | 102.78 ± 1.3% | | 1.00 | 8.34 | 0.84 |
| 05-lexer-veryl/compile-single | 1 | 15.54 ± 11.5% | not timed | not timed | 2.40 ± 0.5% | 5.80 ± 2.2% | not timed | not timed | 15.43 ± 1.4% | | 1.01 | 6.48 | 2.68 |
| 07-unicode-character-data/compile | 1 | 58.75 ± 0.3% | not timed | not timed | 24.98 ± 0.5% | 32.68 ± 1.0% | not timed | not timed | 58.53 ± 10.9% | | 1.00 | 2.35 | 1.80 |
| 09-aws-keys/compile-full | 1 | 38.91 ± 0.2% | not timed | not timed | 7.19 ± 7.6% | 20.80 ± 1.3% | not timed | not timed | 38.52 ± 1.0% | | 1.01 | 5.41 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 183.08 ± 16.2% | not timed | not timed | 46.63 ± 0.5% | 115.90 ± 4.5% | not timed | not timed | 182.73 ± 1.0% | | 1.00 | 3.93 | 1.58 |
| 10-bounded-repeat/compile-context | 1 | 12.40 ± 7.9% | not timed | not timed | 11.36 ± 15.9% | 14.41 ± 5.1% | not timed | not timed | 12.36 ± 0.5% | | 1.00 | 1.09 | 0.86 |
| 10-bounded-repeat/compile-capitals | 1 | 75.07 ± 13.9% | not timed | not timed | 8.43 ± 0.9% | 21.38 ± 4.2% | not timed | not timed | 73.76 ± 1.1% | | 1.02 | 8.90 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 88.48 ± 0.4% | not timed | not timed | 35.97 ± 1.5% | 60.77 ± 4.3% | not timed | not timed | 87.48 ± 1.2% | | 1.01 | 2.46 | 1.46 |
| 12-dictionary/compile-single | 1 | 0.29 ± 4.8% | not timed | not timed | 0.06 ± 51.5% | 0.08 ± 10.1% | not timed | not timed | 0.29 ± 2.8% | | 1.01 | 4.63 | 3.56 |

