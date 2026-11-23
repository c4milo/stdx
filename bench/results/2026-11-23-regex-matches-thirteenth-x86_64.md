# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127370160 |
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
| literal: a word | 217 | 41750.48 ± 1.9% | 1019.22 ± 2.3% | 32.73 ± 11.2% | 38988.29 ± 19.6% | 11582.40 ± 3.9% | 12.75 ± 0.7% | 103.12 ± 9.6% | 41672.65 ± 21.3% | 40.96 | 1.00 | 1.07 | 3.60 |
| literal: a word that is not there | 0 | 58272.91 ± 1.2% | 1034.62 ± 0.5% | 33.21 ± 1.0% | 45980.35 ± 0.9% | 43730.10 ± 8.2% | 12.55 ± 0.4% | 98.87 ± 0.5% | 58182.14 ± 3.3% | 56.32 | 1.00 | 1.27 | 1.33 |
| literal: one of four words | 661 | 13888.39 ± 11.8% | 996.30 ± 2.0% | 17.24 ± 4.9% | 11190.04 ± 1.4% | 24.83 ± 6.2% | 4.47 ± 0.3% | 8.65 ± 2.3% | 13711.69 ± 3.0% | 13.94 | 1.01 | 1.24 | 559.28 |
| literal: a word in any case | 217 | 37178.78 ± 0.7% | 1018.42 ± 0.3% | 24.31 ± 1.3% | 11330.07 ± 3.1% | 46.83 ± 0.7% | refused | differs | 36738.00 ± 0.2% | 36.51 | 1.01 | 3.28 | 793.92 |
| literal: an href attribute | 33 | 35641.16 ± 3.2% | 1025.95 ± 0.1% | 31.96 ± 0.4% | 35228.65 ± 0.4% | 2960.75 ± 4.4% | 9.48 ± 0.3% | 91.54 ± 0.5% | 35719.73 ± 0.5% | 34.74 | 1.00 | 1.01 | 12.04 |
| literal: a word, second text | 123 | 45266.93 ± 0.7% | 1015.89 ± 0.3% | 32.66 ± 0.5% | 39830.57 ± 0.4% | 11377.30 ± 2.1% | 14.51 ± 0.4% | 88.51 ± 1.6% | 45108.52 ± 0.6% | 44.56 | 1.00 | 1.14 | 3.98 |
| class: two capitalized words | 1331 | 917.34 ± 0.3% | 941.78 ± 0.2% | 30.63 ± 1.2% | 575.79 ± 0.6% | 44.49 ± 0.3% | 10.97 ± 0.2% | 79.29 ± 0.6% | 915.23 ± 0.3% | 0.97 | 1.00 | 1.59 | 20.62 |
| class: a word that ends in ing | 3399 | 867.21 ± 0.2% | 868.81 ± 0.1% | 20.39 ± 0.9% | 537.72 ± 0.1% | 32.24 ± 11.0% | 6.18 ± 4.8% | 20.41 ± 11.9% | 861.88 ± 9.2% | 1.00 | 1.01 | 1.61 | 26.90 |
| class: a word in capitals | 2332 | 1153.47 ± 3.1% | 917.67 ± 0.4% | 32.57 ± 7.0% | 566.83 ± 0.4% | 47.56 ± 1.6% | 12.41 ± 0.9% | 102.02 ± 0.3% | 1151.27 ± 0.2% | 1.26 | 1.00 | 2.03 | 24.25 |
| class: a number | 8288 | 1734.93 ± 3.6% | 805.94 ± 3.2% | 33.00 ± 6.8% | 1805.27 ± 10.7% | 48.20 ± 12.6% | 0.38 ± 0.4% | 72.31 ± 0.3% | 1739.33 ± 0.6% | 2.15 | 1.00 | 0.96 | 35.99 |
| class: two capitalized words, second text | 5359 | 708.53 ± 0.6% | 706.95 ± 0.3% | 27.33 ± 0.7% | 478.67 ± 0.3% | 38.86 ± 5.8% | 12.80 ± 0.3% | 73.56 ± 0.8% | 709.00 ± 0.2% | 1.00 | 1.00 | 1.48 | 18.23 |
| other: a word between two words | 6104 | 773.50 ± 0.4% | 740.15 ± 0.2% | 27.11 ± 0.2% | 817.21 ± 2.0% | 122.88 ± 22.1% | 8.48 ± 0.4% | 82.27 ± 2.8% | 769.22 ± 0.3% | 1.05 | 1.01 | 0.95 | 6.29 |
| other: a number before a unit, second text | 1481 | 9263.61 ± 3.6% | 970.21 ± 0.2% | 30.52 ± 0.9% | 8299.14 ± 0.2% | 44.93 ± 1.3% | 13.34 ± 0.4% | 77.35 ± 1.1% | 9222.94 ± 15.3% | 9.55 | 1.00 | 1.12 | 206.19 |
| other: a heading's start tag | 110 | 24588.21 ± 0.6% | 1012.76 ± 0.2% | 32.91 ± 1.0% | 2563.85 ± 4.7% | 2006.46 ± 12.5% | 11.69 ± 0.3% | 107.21 ± 2.4% | 24546.71 ± 1.9% | 24.28 | 1.00 | 9.59 | 12.25 |
| other: a whole word | 217 | 29485.79 ± 0.2% | 1019.23 ± 0.1% | 32.94 ± 0.4% | 28257.04 ± 9.0% | 54.15 ± 1.1% | 11.05 ± 0.2% | 63.45 ± 0.5% | 29165.37 ± 0.6% | 28.93 | 1.01 | 1.04 | 544.53 |
| other: a line's first word, second text | 3716 | 2324.01 ± 2.0% | 848.95 ± 0.2% | 36.17 ± 0.8% | 2331.37 ± 3.6% | 69.86 ± 3.9% | refused | refused | 2297.32 ± 1.3% | 2.74 | 1.01 | 1.00 | 33.27 |
| other: fourteen octets before an x | 87 | 35546.89 ± 0.2% | 251.47 ± 0.5% | 7.13 ± 4.9% | 3502.45 ± 0.2% | 11.57 ± 1.5% | differs | 20.90 ± 5.4% | 35749.38 ± 0.6% | 141.35 | 0.99 | 10.15 | 3073.61 |
| other: a Greek word | 21815 | 475.66 ± 0.5% | 359.27 ± 0.5% | 34.80 ± 0.3% | 299.59 ± 1.7% | 57.15 ± 10.4% | differs | refused | 473.81 ± 0.7% | 1.32 | 1.00 | 1.59 | 8.32 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.57 ± 7.2% | 29.63 ± 0.5% | 1.00 ± 2.2% | 19.72 ± 1.8% | 2.69 ± 0.3% | differs | 4.35 ± 1.4% | 29.11 ± 0.8% | 1.00 | 1.02 | 1.50 | 10.98 |
| a UUID | 32895 | 24.02 ± 0.5% | 24.03 ± 0.5% | 0.73 ± 0.9% | 15.14 ± 0.2% | 3.09 ± 2.7% | 0.52 ± 0.5% | 3.78 ± 3.9% | 23.94 ± 8.7% | 1.00 | 1.00 | 1.59 | 7.77 |
| an IPv4 address | 33176 | 40.62 ± 0.4% | 40.38 ± 0.4% | 2.32 ± 0.3% | 28.43 ± 0.1% | 7.02 ± 0.5% | differs | 4.14 ± 2.6% | 40.62 ± 0.7% | 1.01 | 1.00 | 1.43 | 5.79 |
| a date and time | 32954 | 35.90 ± 3.6% | 35.41 ± 1.0% | 1.71 ± 0.5% | 21.70 ± 0.2% | 8.20 ± 3.8% | 0.91 ± 0.6% | 8.05 ± 1.2% | 36.12 ± 0.3% | 1.01 | 0.99 | 1.65 | 4.38 |
| a field path | 32606 | 32.83 ± 3.6% | 26.96 ± 1.5% | 1.11 ± 0.3% | 23.04 ± 0.4% | 3.48 ± 4.0% | differs | 3.09 ± 0.9% | 32.93 ± 5.9% | 1.22 | 1.00 | 1.43 | 9.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.86 ± 0.2% | 10.84 ± 1.1% | 10.83 ± 0.3% | 13.22 ± 7.1% | 5.88 ± 2.5% | 0.75 ± 0.4% | none | 10.82 ± 7.8% | 1.00 | 1.00 | 0.82 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 232.90 ± 8.5% | 234.33 ± 1.0% | 270.57 ± 0.2% | 101.74 ± 1.4% | 242.35 ± 13.5% | 696.78 ± 3.5% | 4789.97 ± 0.6% | 233.17 ± 0.5% | 0.99 | 1.00 | 2.29 | 0.96 |
| a UUID | 62 | 151.13 ± 0.7% | 151.81 ± 0.4% | 167.54 ± 0.2% | 57.39 ± 2.6% | 118.55 ± 15.6% | 251.71 ± 2.8% | 5291.72 ± 8.6% | 151.29 ± 0.6% | 1.00 | 1.00 | 2.63 | 1.27 |
| an IPv4 address | 29 | 511.35 ± 5.6% | 516.24 ± 6.6% | 731.99 ± 5.6% | 87.34 ± 13.9% | 146.11 ± 19.8% | 399.11 ± 3.5% | 8427.30 ± 0.4% | 511.56 ± 0.8% | 0.99 | 1.00 | 5.85 | 3.50 |
| a date and time | 56 | 369.19 ± 0.3% | 372.05 ± 1.3% | 481.59 ± 1.0% | 86.14 ± 1.1% | 161.00 ± 11.2% | 458.18 ± 0.4% | 5560.55 ± 1.3% | 369.28 ± 2.4% | 0.99 | 1.00 | 4.29 | 2.29 |
| a field path | 39 | 220.25 ± 0.6% | 221.46 ± 0.6% | 253.92 ± 0.5% | 93.44 ± 1.5% | 228.87 ± 2.1% | 734.82 ± 2.1% | 5751.18 ± 1.6% | 219.79 ± 0.7% | 0.99 | 1.00 | 2.36 | 0.96 |
| literal: a word | 7 | 769.51 ± 0.2% | 818.41 ± 0.6% | 1500.64 ± 0.5% | 642.70 ± 1.7% | 791.94 ± 2.6% | 1590.44 ± 1.9% | 26790.18 ± 0.9% | 769.75 ± 0.3% | 0.94 | 1.00 | 1.20 | 0.97 |
| literal: a word that is not there | 8 | 741.91 ± 0.1% | 794.39 ± 0.1% | 1412.95 ± 0.2% | 583.89 ± 1.4% | 760.24 ± 2.7% | 1504.10 ± 0.6% | 26560.77 ± 0.2% | 739.76 ± 0.9% | 0.93 | 1.00 | 1.27 | 0.98 |
| literal: one of four words | 26 | 289.81 ± 2.4% | 470.82 ± 0.3% | 640.25 ± 0.2% | 54.16 ± 0.7% | 296.17 ± 2.1% | 556.21 ± 1.6% | 17859.00 ± 0.6% | 290.13 ± 0.6% | 0.62 | 1.00 | 5.35 | 0.98 |
| literal: a word in any case | 11 | 592.73 ± 1.4% | 626.52 ± 0.2% | 967.91 ± 0.4% | 18.77 ± 0.8% | 830.48 ± 0.8% | refused | 22570.74 ± 0.2% | 590.27 ± 1.0% | 0.95 | 1.00 | 31.58 | 0.71 |
| literal: an href attribute | 12 | 403.40 ± 0.9% | 415.53 ± 0.4% | 552.14 ± 0.7% | 50.37 ± 1.9% | 571.76 ± 18.3% | 1233.05 ± 2.3% | 20220.22 ± 12.6% | 403.25 ± 12.9% | 0.97 | 1.00 | 8.01 | 0.71 |
| literal: a word, second text | 10 | 686.00 ± 0.6% | 744.92 ± 1.0% | 1272.56 ± 0.9% | 533.64 ± 7.6% | 663.21 ± 17.8% | 1272.08 ± 0.5% | 25328.40 ± 0.5% | 683.85 ± 1.3% | 0.92 | 1.00 | 1.29 | 1.03 |
| class: two capitalized words | 23 | 538.18 ± 2.0% | 583.57 ± 1.1% | 858.74 ± 0.2% | 121.63 ± 0.5% | 608.84 ± 1.6% | 1224.10 ± 0.6% | 7666.03 ± 0.1% | 536.20 ± 0.4% | 0.92 | 1.00 | 4.42 | 0.88 |
| class: a word that ends in ing | 9 | 666.94 ± 0.3% | 757.99 ± 0.7% | 1337.49 ± 0.7% | 150.85 ± 1.1% | 862.78 ± 3.0% | 1763.38 ± 1.5% | 16906.15 ± 0.5% | 666.13 ± 0.6% | 0.88 | 1.00 | 4.42 | 0.77 |
| class: a word in capitals | 16 | 596.26 ± 0.2% | 652.53 ± 0.4% | 1064.11 ± 0.2% | 154.55 ± 1.4% | 894.58 ± 12.7% | 1646.30 ± 2.2% | 9858.93 ± 0.3% | 595.92 ± 0.3% | 0.91 | 1.00 | 3.86 | 0.67 |
| class: a number | 6 | 730.93 ± 5.2% | 818.08 ± 8.8% | 1545.72 ± 0.5% | 47.19 ± 0.8% | 1646.91 ± 1.8% | 3006.58 ± 2.6% | 21665.60 ± 0.8% | 730.78 ± 0.2% | 0.89 | 1.00 | 15.49 | 0.44 |
| class: two capitalized words, second text | 23 | 538.87 ± 0.3% | 584.92 ± 0.4% | 859.30 ± 0.3% | 122.84 ± 1.2% | 596.74 ± 2.1% | 1261.74 ± 2.0% | 7671.19 ± 1.8% | 538.10 ± 11.0% | 0.92 | 1.00 | 4.39 | 0.90 |
| other: a word between two words | 13 | 657.29 ± 14.7% | 680.14 ± 7.3% | 1088.08 ± 12.5% | 158.91 ± 1.3% | 587.29 ± 1.4% | 1295.38 ± 0.4% | 16050.83 ± 0.3% | 658.22 ± 14.8% | 0.97 | 1.00 | 4.14 | 1.12 |
| other: a number before a unit, second text | 15 | 439.23 ± 0.1% | 484.48 ± 9.7% | 664.16 ± 5.6% | 44.25 ± 1.2% | 729.14 ± 21.1% | 1454.80 ± 8.4% | 15966.59 ± 11.6% | 438.97 ± 0.2% | 0.91 | 1.00 | 9.93 | 0.60 |
| other: a heading's start tag | 13 | 419.44 ± 0.9% | 424.88 ± 3.1% | 565.31 ± 1.2% | 48.66 ± 0.3% | 715.75 ± 1.2% | 1373.37 ± 0.7% | 17783.40 ± 0.8% | 419.82 ± 0.6% | 0.99 | 1.00 | 8.62 | 0.59 |
| other: a whole word | 11 | 679.32 ± 0.4% | 714.38 ± 8.1% | 1186.42 ± 0.2% | 142.10 ± 0.5% | 683.94 ± 1.7% | 1374.95 ± 2.0% | 25912.61 ± 9.4% | 675.28 ± 1.0% | 0.95 | 1.01 | 4.78 | 0.99 |
| other: a line's first word, second text | 17 | 636.32 ± 1.3% | 666.31 ± 10.2% | 1077.80 ± 0.6% | 150.06 ± 0.7% | 811.80 ± 1.4% | refused | refused | 635.70 ± 0.4% | 0.95 | 1.00 | 4.24 | 0.78 |
| other: fourteen octets before an x | 16 | 118.08 ± 3.3% | 178.56 ± 0.2% | 210.52 ± 0.6% | 18.23 ± 0.5% | 522.35 ± 19.0% | 576.30 ± 1.8% | 13974.20 ± 0.6% | 118.70 ± 3.3% | 0.66 | 0.99 | 6.48 | 0.23 |
| other: a Greek word | 8 | 464.62 ± 0.2% | 636.39 ± 0.2% | 1006.55 ± 0.8% | 63.20 ± 6.9% | 1628.34 ± 3.2% | 2777.94 ± 1.4% | refused | 464.37 ± 0.8% | 0.73 | 1.00 | 7.35 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27766.42 ± 0.4% | not timed | not timed | 33889.70 ± 1.5% | 2959.27 ± 15.5% | not timed | not timed | 27787.27 ± 0.5% | | 1.00 | 0.82 | 9.38 |
| 01-literal/sherlock-casei-en | 522 | 6391.91 ± 2.6% | not timed | not timed | 9036.17 ± 5.7% | 33.61 ± 4.0% | not timed | not timed | 6346.15 ± 3.3% | | 1.01 | 0.71 | 190.20 |
| 01-literal/sherlock-ru | 724 | 29752.17 ± 1.3% | not timed | not timed | 34057.99 ± 10.9% | 1287.26 ± 10.3% | not timed | not timed | 29731.40 ± 0.5% | | 1.00 | 0.87 | 23.11 |
| 01-literal/sherlock-casei-ru | 746 | 8773.47 ± 0.5% | not timed | not timed | 7806.51 ± 12.0% | 37.59 ± 0.3% | not timed | not timed | 8725.74 ± 0.1% | | 1.01 | 1.12 | 233.43 |
| 01-literal/sherlock-zh | 30 | 52913.81 ± 0.4% | not timed | not timed | 43038.36 ± 0.3% | 1635.33 ± 13.0% | not timed | not timed | 52856.44 ± 0.6% | | 1.00 | 1.23 | 32.36 |
| 02-literal-alternate/sherlock-en | 714 | 12588.89 ± 0.3% | not timed | not timed | 10950.22 ± 0.9% | 19.09 ± 0.4% | not timed | not timed | 12584.39 ± 0.3% | | 1.00 | 1.15 | 659.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2129.45 ± 6.8% | not timed | not timed | 2312.06 ± 2.9% | 12.27 ± 6.2% | not timed | not timed | 2098.23 ± 10.9% | | 1.01 | 0.92 | 173.56 |
| 02-literal-alternate/sherlock-ru | 899 | 7438.80 ± 0.3% | not timed | not timed | 9818.08 ± 0.4% | 25.43 ± 17.7% | not timed | not timed | 7285.35 ± 0.1% | | 1.02 | 0.76 | 292.47 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2067.68 ± 0.5% | not timed | not timed | 1189.08 ± 0.4% | 10.58 ± 0.7% | not timed | not timed | 2059.25 ± 5.1% | | 1.00 | 1.74 | 195.48 |
| 02-literal-alternate/sherlock-zh | 207 | 18171.95 ± 0.6% | not timed | not timed | 12582.68 ± 0.4% | 35.46 ± 14.4% | not timed | not timed | 18171.62 ± 0.3% | | 1.00 | 1.44 | 512.48 |
| 03-date/ascii | 111817 | 129.09 ± 1.4% | not timed | not timed | 101.08 ± 0.5% | 0.23 ± 4.8% | not timed | not timed | 127.65 ± 1.1% | | 1.01 | 1.28 | 565.29 |
| 04-ruff-noqa/real | 84 | 666.54 ± 0.8% | not timed | not timed | 515.33 ± 0.2% | 16.81 ± 1.7% | not timed | not timed | 665.25 ± 0.5% | | 1.00 | 1.29 | 39.64 |
| 04-ruff-noqa/tweaked | 44 | 607.91 ± 0.2% | not timed | not timed | 514.28 ± 0.3% | 368.50 ± 1.5% | not timed | not timed | 608.16 ± 0.2% | | 1.00 | 1.18 | 1.65 |
| 05-lexer-veryl/single | 124800 | 3.64 ± 0.6% | not timed | not timed | 4.82 ± 1.5% | 0.25 ± 8.5% | not timed | not timed | 3.63 ± 2.5% | | 1.00 | 0.75 | 14.31 |
| 06-cloud-flare-redos/original | 107 | 269.02 ± 0.3% | not timed | not timed | 226.91 ± 2.5% | 25.93 ± 0.7% | not timed | not timed | 268.09 ± 0.9% | | 1.00 | 1.19 | 10.37 |
| 06-cloud-flare-redos/simplified-short | 102 | 263.17 ± 1.1% | not timed | not timed | 236.26 ± 0.5% | 27.77 ± 0.6% | not timed | not timed | 263.19 ± 0.5% | | 1.00 | 1.11 | 9.48 |
| 06-cloud-flare-redos/simplified-long | 10000 | 281.10 ± 0.1% | not timed | not timed | 259.80 ± 0.1% | 29.81 ± 1.4% | not timed | not timed | 280.91 ± 0.2% | | 1.00 | 1.08 | 9.43 |
| 07-unicode-character-data/parse-line | 558784 | 245.24 ± 0.6% | not timed | not timed | 199.64 ± 0.5% | 48.85 ± 10.8% | not timed | not timed | 242.56 ± 0.8% | | 1.01 | 1.23 | 5.02 |
| 08-words/all-english | 56691 | 114.06 ± 0.6% | not timed | not timed | 84.70 ± 10.6% | 13.67 ± 2.6% | not timed | not timed | 113.84 ± 0.4% | | 1.00 | 1.35 | 8.34 |
| 08-words/long-english | 839 | 972.61 ± 0.5% | not timed | not timed | 582.56 ± 0.2% | 35.17 ± 1.3% | not timed | not timed | 971.13 ± 0.1% | | 1.00 | 1.67 | 27.65 |
| 09-aws-keys/full | 0 | 515.45 ± 4.3% | not timed | not timed | 540.48 ± 2.8% | 67.37 ± 2.8% | not timed | not timed | 489.48 ± 4.6% | | 1.05 | 0.95 | 7.65 |
| 09-aws-keys/quick | 0 | 934.76 ± 8.8% | not timed | not timed | 958.19 ± 1.3% | 409.57 ± 0.7% | not timed | not timed | 959.79 ± 1.0% | | 0.97 | 0.98 | 2.28 |
| 10-bounded-repeat/letters-en | 1833 | 643.49 ± 1.2% | not timed | not timed | 554.86 ± 5.2% | 22.85 ± 13.9% | not timed | not timed | 630.27 ± 1.7% | | 1.02 | 1.16 | 28.16 |
| 10-bounded-repeat/letters-ru | 3475 | 366.06 ± 0.2% | not timed | not timed | 483.17 ± 0.5% | 25.60 ± 13.4% | not timed | not timed | 364.34 ± 1.9% | | 1.00 | 0.76 | 14.30 |
| 10-bounded-repeat/context | 53 | 83.06 ± 10.4% | not timed | not timed | 70.85 ± 2.7% | 21.11 ± 4.0% | not timed | not timed | 84.69 ± 1.1% | | 0.98 | 1.17 | 3.93 |
| 10-bounded-repeat/capitals | 11 | 1024.59 ± 0.8% | not timed | not timed | 604.48 ± 0.1% | 40.36 ± 0.8% | not timed | not timed | 1024.70 ± 1.0% | | 1.00 | 1.69 | 25.39 |
| 11-unstructured-to-json/extract | 600 | 45.70 ± 0.2% | not timed | not timed | 79.34 ± 1.4% | 50.28 ± 2.0% | not timed | not timed | 46.13 ± 0.7% | | 0.99 | 0.58 | 0.91 |
| 12-dictionary/single | 1 | 508.37 ± 0.1% | not timed | not timed | 482.93 ± 0.0% | 0.38 ± 3.2% | not timed | not timed | 511.65 ± 0.1% | | 0.99 | 1.05 | 1338.75 |
| 14-quadratic/1x | 100 | 13.61 ± 10.6% | not timed | not timed | 12.15 ± 0.3% | 1.02 ± 1.9% | not timed | not timed | 13.48 ± 4.4% | | 1.01 | 1.12 | 13.33 |
| 14-quadratic/2x | 200 | 8.04 ± 12.9% | not timed | not timed | 6.12 ± 0.2% | 0.55 ± 1.8% | not timed | not timed | 8.01 ± 6.5% | | 1.00 | 1.31 | 14.55 |
| 14-quadratic/10x | 1000 | 1.82 ± 1.2% | not timed | not timed | 1.22 ± 0.3% | 0.12 ± 1.5% | not timed | not timed | 1.82 ± 2.7% | | 1.00 | 1.50 | 15.32 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.68 ± 0.6% | not timed | not timed | 0.48 ± 13.3% | 0.64 ± 2.6% | not timed | not timed | 1.67 ± 1.0% | | 1.00 | 3.53 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 100.70 ± 0.7% | not timed | not timed | 17.29 ± 0.9% | 168.94 ± 20.8% | not timed | not timed | 99.73 ± 7.6% | | 1.01 | 5.83 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 16.87 ± 0.6% | not timed | not timed | 3.00 ± 1.1% | 7.89 ± 1.9% | not timed | not timed | 16.82 ± 0.9% | | 1.00 | 5.63 | 2.14 |
| 07-unicode-character-data/compile | 1 | 63.41 ± 0.3% | not timed | not timed | 30.48 ± 0.5% | 44.28 ± 2.1% | not timed | not timed | 63.20 ± 1.1% | | 1.00 | 2.08 | 1.43 |
| 09-aws-keys/compile-full | 1 | 44.82 ± 0.4% | not timed | not timed | 10.01 ± 1.0% | 28.20 ± 2.1% | not timed | not timed | 44.68 ± 0.4% | | 1.00 | 4.48 | 1.59 |
| 09-aws-keys/compile-quick | 1 | 201.89 ± 0.1% | not timed | not timed | 57.52 ± 11.9% | 158.62 ± 3.5% | not timed | not timed | 198.64 ± 8.1% | | 1.02 | 3.51 | 1.27 |
| 10-bounded-repeat/compile-context | 1 | 15.38 ± 0.3% | not timed | not timed | 14.37 ± 0.4% | 20.38 ± 3.2% | not timed | not timed | 15.77 ± 0.5% | | 0.98 | 1.07 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 93.90 ± 1.7% | not timed | not timed | 10.56 ± 0.5% | 29.69 ± 2.4% | not timed | not timed | 93.64 ± 0.7% | | 1.00 | 8.89 | 3.16 |
| 11-unstructured-to-json/compile | 1 | 98.23 ± 13.8% | not timed | not timed | 47.87 ± 17.1% | 80.53 ± 5.8% | not timed | not timed | 97.83 ± 1.5% | | 1.00 | 2.05 | 1.22 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.09 ± 0.7% | 0.10 ± 12.8% | not timed | not timed | 0.35 ± 6.0% | | 1.01 | 4.10 | 3.38 |

