# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127356161 |
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
| literal: a word | 217 | 16047.66 ± 2.2% | 1039.37 ± 0.4% | 28.52 ± 0.2% | 18412.47 ± 3.3% | 9404.63 ± 6.2% | 17.38 ± 0.3% | 86.15 ± 0.2% | 16269.73 ± 1.9% | 15.44 | 0.99 | 0.87 | 1.71 |
| literal: a word that is not there | 0 | 18829.39 ± 2.0% | 1048.32 ± 0.1% | 28.46 ± 0.1% | 19738.72 ± 3.1% | 29065.73 ± 2.7% | 17.13 ± 0.1% | 82.13 ± 0.2% | 18863.90 ± 1.5% | 17.96 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6056.83 ± 0.4% | 1021.46 ± 0.2% | 14.68 ± 0.1% | 3946.74 ± 0.2% | 21.86 ± 0.1% | 5.42 ± 0.0% | 6.75 ± 0.2% | 6062.87 ± 0.4% | 5.93 | 1.00 | 1.53 | 277.13 |
| literal: a word in any case | 217 | 12576.54 ± 0.6% | 1040.41 ± 0.1% | 21.80 ± 2.5% | 3974.24 ± 0.5% | 38.15 ± 1.0% | refused | differs | 12560.09 ± 0.3% | 12.09 | 1.00 | 3.16 | 329.65 |
| literal: an href attribute | 33 | 13741.96 ± 0.5% | 1046.00 ± 0.1% | 27.19 ± 0.2% | 16902.95 ± 1.8% | 2266.52 ± 0.1% | 13.14 ± 0.1% | 75.30 ± 0.4% | 13702.96 ± 0.5% | 13.14 | 1.00 | 0.81 | 6.06 |
| literal: a word, second text | 123 | 16379.66 ± 1.2% | 1043.18 ± 0.2% | 28.24 ± 0.1% | 18364.76 ± 2.7% | 7779.31 ± 7.3% | 20.03 ± 0.4% | 69.63 ± 0.5% | 16424.91 ± 1.1% | 15.70 | 1.00 | 0.89 | 2.11 |
| class: two capitalized words | 1331 | 1127.93 ± 0.6% | 978.23 ± 0.1% | 26.08 ± 0.1% | 585.30 ± 0.1% | 40.60 ± 0.1% | 14.74 ± 0.2% | 68.44 ± 0.4% | 1126.80 ± 0.5% | 1.15 | 1.00 | 1.93 | 27.78 |
| class: a word that ends in ing | 3399 | 880.77 ± 0.2% | 890.75 ± 0.2% | 18.07 ± 0.2% | 547.86 ± 0.2% | 29.61 ± 3.4% | 8.22 ± 0.1% | 18.23 ± 0.4% | 889.01 ± 0.1% | 0.99 | 0.99 | 1.61 | 29.74 |
| class: a word in capitals | 2332 | 1446.25 ± 0.4% | 949.18 ± 0.2% | 27.80 ± 0.2% | 572.50 ± 0.1% | 43.63 ± 14.0% | 17.12 ± 0.2% | 83.21 ± 0.4% | 1454.84 ± 0.3% | 1.52 | 0.99 | 2.53 | 33.15 |
| class: a number | 8288 | 1996.83 ± 0.2% | 826.79 ± 0.2% | 27.98 ± 0.6% | 1716.09 ± 0.3% | 43.00 ± 17.3% | 0.54 ± 0.4% | 56.99 ± 0.3% | 1991.86 ± 0.2% | 2.42 | 1.00 | 1.16 | 46.43 |
| class: two capitalized words, second text | 5359 | 737.63 ± 0.1% | 736.48 ± 0.2% | 23.39 ± 0.1% | 484.20 ± 0.1% | 35.40 ± 3.5% | 17.05 ± 0.2% | 63.69 ± 0.3% | 737.74 ± 0.1% | 1.00 | 1.00 | 1.52 | 20.84 |
| other: a word between two words | 6104 | 764.18 ± 0.1% | 764.20 ± 0.2% | 23.58 ± 0.2% | 738.26 ± 0.2% | 108.77 ± 15.3% | 11.17 ± 0.1% | 69.23 ± 0.6% | 762.78 ± 0.3% | 1.00 | 1.00 | 1.04 | 7.03 |
| other: a number before a unit, second text | 1481 | 5541.98 ± 0.5% | 983.23 ± 0.2% | 25.89 ± 0.3% | 5670.11 ± 0.6% | 40.80 ± 0.2% | 18.17 ± 0.1% | 66.87 ± 0.1% | 5521.23 ± 0.6% | 5.64 | 1.00 | 0.98 | 135.84 |
| other: a heading's start tag | 110 | 12580.69 ± 0.5% | 1036.34 ± 0.2% | 27.39 ± 0.1% | 1717.25 ± 0.6% | 1580.10 ± 9.4% | 16.10 ± 0.4% | 88.54 ± 0.5% | 12580.49 ± 0.7% | 12.14 | 1.00 | 7.33 | 7.96 |
| other: a whole word | 217 | 13829.88 ± 0.9% | 1039.22 ± 0.3% | 29.51 ± 0.7% | 14413.47 ± 1.9% | 49.46 ± 0.2% | 13.21 ± 0.1% | 56.00 ± 0.2% | 13941.29 ± 1.3% | 13.31 | 0.99 | 0.96 | 279.65 |
| other: a line's first word, second text | 3716 | 1962.02 ± 0.3% | 873.61 ± 0.1% | 30.94 ± 0.3% | 1725.62 ± 0.3% | 61.78 ± 5.3% | refused | refused | 1952.95 ± 0.5% | 2.25 | 1.00 | 1.14 | 31.76 |
| other: fourteen octets before an x | 87 | 19605.83 ± 0.7% | 251.95 ± 0.4% | 6.13 ± 0.1% | 4041.68 ± 0.5% | 10.65 ± 0.2% | differs | 17.73 ± 0.1% | 19663.25 ± 0.9% | 77.82 | 1.00 | 4.85 | 1841.52 |
| other: a Greek word | 21815 | 470.32 ± 0.7% | 357.70 ± 0.2% | 30.82 ± 0.1% | 289.87 ± 0.3% | 49.43 ± 10.9% | differs | refused | 469.51 ± 0.4% | 1.31 | 1.00 | 1.62 | 9.51 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.2% | 25.88 ± 0.2% | 0.82 ± 0.3% | 19.78 ± 0.2% | 2.78 ± 0.2% | differs | 4.04 ± 0.1% | 25.90 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.29 |
| a UUID | 32895 | 21.08 ± 0.4% | 21.15 ± 0.3% | 0.65 ± 0.1% | 15.18 ± 0.4% | 3.09 ± 0.8% | 0.73 ± 0.4% | 3.62 ± 0.6% | 21.12 ± 0.3% | 1.00 | 1.00 | 1.39 | 6.82 |
| an IPv4 address | 33176 | 37.01 ± 0.2% | 36.99 ± 0.2% | 2.10 ± 0.2% | 29.24 ± 0.4% | 6.68 ± 1.1% | differs | 4.16 ± 0.3% | 36.98 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.54 |
| a date and time | 32954 | 31.03 ± 0.2% | 31.07 ± 0.3% | 1.42 ± 0.2% | 21.60 ± 0.1% | 7.04 ± 0.1% | 1.25 ± 0.3% | 7.15 ± 0.3% | 31.04 ± 0.4% | 1.00 | 1.00 | 1.44 | 4.41 |
| a field path | 32606 | 29.53 ± 0.1% | 29.46 ± 0.2% | 1.02 ± 1.0% | 23.25 ± 0.3% | 3.49 ± 0.6% | differs | 2.94 ± 0.2% | 29.52 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.47 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.5% | 11.53 ± 0.7% | 11.49 ± 0.8% | 11.69 ± 0.1% | 4.84 ± 1.7% | 0.93 ± 0.4% | none | 11.52 ± 0.3% | 1.00 | 1.00 | 0.99 | 2.38 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.69 ± 0.3% | 237.63 ± 0.3% | 287.07 ± 0.4% | 86.30 ± 0.7% | 222.53 ± 1.0% | 484.21 ± 0.5% | 3750.57 ± 0.5% | 235.88 ± 0.3% | 0.99 | 1.00 | 2.73 | 1.06 |
| a UUID | 62 | 158.60 ± 0.2% | 159.08 ± 0.2% | 179.52 ± 0.2% | 45.53 ± 1.1% | 99.33 ± 1.2% | 183.96 ± 2.2% | 4454.10 ± 0.8% | 158.52 ± 0.2% | 1.00 | 1.00 | 3.48 | 1.60 |
| an IPv4 address | 29 | 425.75 ± 0.3% | 430.60 ± 0.3% | 616.90 ± 0.4% | 77.68 ± 0.1% | 131.15 ± 0.4% | 294.44 ± 0.6% | 7691.66 ± 0.5% | 425.10 ± 0.3% | 0.99 | 1.00 | 5.48 | 3.25 |
| a date and time | 56 | 306.82 ± 0.2% | 310.57 ± 0.4% | 395.81 ± 0.2% | 72.74 ± 0.4% | 137.81 ± 0.7% | 328.95 ± 2.2% | 4956.95 ± 0.2% | 306.98 ± 0.2% | 0.99 | 1.00 | 4.22 | 2.23 |
| a field path | 39 | 228.01 ± 0.3% | 229.47 ± 0.7% | 274.17 ± 0.4% | 80.26 ± 1.0% | 206.43 ± 0.9% | 506.15 ± 1.8% | 4848.65 ± 0.2% | 228.13 ± 0.5% | 0.99 | 1.00 | 2.84 | 1.10 |
| literal: a word | 7 | 638.34 ± 0.3% | 684.77 ± 0.3% | 1281.82 ± 0.5% | 483.67 ± 0.4% | 633.92 ± 2.5% | 954.28 ± 0.3% | 30424.45 ± 0.4% | 638.04 ± 0.3% | 0.93 | 1.00 | 1.32 | 1.01 |
| literal: a word that is not there | 8 | 612.82 ± 0.1% | 664.64 ± 0.3% | 1208.37 ± 0.1% | 442.18 ± 0.6% | 605.81 ± 0.4% | 900.78 ± 0.8% | 29149.30 ± 0.1% | 612.53 ± 0.2% | 0.92 | 1.00 | 1.39 | 1.01 |
| literal: one of four words | 26 | 245.16 ± 0.3% | 409.38 ± 0.4% | 569.03 ± 0.8% | 50.40 ± 0.3% | 246.59 ± 2.8% | 378.24 ± 2.7% | 15611.07 ± 0.1% | 245.25 ± 0.4% | 0.60 | 1.00 | 4.86 | 0.99 |
| literal: a word in any case | 11 | 494.30 ± 0.2% | 528.50 ± 0.3% | 852.08 ± 0.3% | 15.64 ± 0.2% | 653.57 ± 2.3% | refused | 23683.08 ± 0.5% | 493.87 ± 0.2% | 0.94 | 1.00 | 31.61 | 0.76 |
| literal: an href attribute | 12 | 353.55 ± 0.3% | 366.79 ± 0.3% | 494.47 ± 0.6% | 45.30 ± 0.8% | 498.90 ± 1.9% | 779.07 ± 0.4% | 21661.70 ± 0.4% | 352.83 ± 0.4% | 0.96 | 1.00 | 7.80 | 0.71 |
| literal: a word, second text | 10 | 574.39 ± 0.3% | 631.07 ± 0.4% | 1096.46 ± 0.1% | 398.96 ± 0.3% | 538.96 ± 1.6% | 809.80 ± 0.3% | 26979.34 ± 0.4% | 573.94 ± 0.2% | 0.91 | 1.00 | 1.44 | 1.07 |
| class: two capitalized words | 23 | 443.74 ± 0.5% | 472.85 ± 0.6% | 707.38 ± 0.7% | 101.49 ± 0.5% | 507.35 ± 1.3% | 758.13 ± 1.3% | 6360.56 ± 0.1% | 444.18 ± 0.5% | 0.94 | 1.00 | 4.37 | 0.87 |
| class: a word that ends in ing | 9 | 574.30 ± 0.6% | 643.70 ± 0.8% | 1177.19 ± 1.2% | 130.90 ± 1.2% | 765.60 ± 1.8% | 1105.40 ± 3.1% | 15817.84 ± 0.1% | 574.40 ± 0.6% | 0.89 | 1.00 | 4.39 | 0.75 |
| class: a word in capitals | 16 | 507.95 ± 0.4% | 545.10 ± 0.5% | 905.25 ± 0.3% | 134.88 ± 1.5% | 753.49 ± 1.1% | 1006.60 ± 0.6% | 8354.75 ± 0.2% | 507.68 ± 0.2% | 0.93 | 1.00 | 3.77 | 0.67 |
| class: a number | 6 | 638.32 ± 0.2% | 703.01 ± 0.5% | 1384.13 ± 0.4% | 41.68 ± 1.0% | 1403.82 ± 1.4% | 1887.62 ± 1.2% | 22759.27 ± 0.1% | 638.30 ± 0.1% | 0.91 | 1.00 | 15.32 | 0.45 |
| class: two capitalized words, second text | 23 | 444.14 ± 0.4% | 472.76 ± 0.3% | 707.09 ± 0.4% | 100.39 ± 0.4% | 508.77 ± 0.9% | 769.41 ± 0.4% | 6356.63 ± 0.1% | 444.03 ± 0.3% | 0.94 | 1.00 | 4.42 | 0.87 |
| other: a word between two words | 13 | 560.72 ± 0.3% | 579.06 ± 0.4% | 960.78 ± 0.1% | 132.31 ± 0.2% | 504.09 ± 0.4% | 812.17 ± 1.0% | 14669.73 ± 0.1% | 560.74 ± 0.3% | 0.97 | 1.00 | 4.24 | 1.11 |
| other: a number before a unit, second text | 15 | 411.99 ± 0.1% | 451.64 ± 0.3% | 655.31 ± 0.2% | 39.23 ± 0.8% | 637.97 ± 0.8% | 891.49 ± 1.7% | 15208.01 ± 0.1% | 411.99 ± 0.1% | 0.91 | 1.00 | 10.50 | 0.65 |
| other: a heading's start tag | 13 | 363.32 ± 0.3% | 368.87 ± 0.3% | 499.93 ± 0.5% | 43.38 ± 0.2% | 632.65 ± 0.6% | 880.85 ± 0.3% | 18094.95 ± 0.1% | 363.38 ± 0.4% | 0.98 | 1.00 | 8.37 | 0.57 |
| other: a whole word | 11 | 594.29 ± 0.5% | 632.68 ± 0.5% | 1095.79 ± 0.3% | 117.46 ± 0.3% | 568.07 ± 2.1% | 832.55 ± 0.5% | 26754.62 ± 0.2% | 594.22 ± 0.4% | 0.94 | 1.00 | 5.06 | 1.05 |
| other: a line's first word, second text | 17 | 545.11 ± 0.5% | 566.16 ± 0.6% | 948.86 ± 0.2% | 129.54 ± 0.1% | 713.19 ± 0.4% | refused | refused | 543.61 ± 0.8% | 0.96 | 1.00 | 4.21 | 0.76 |
| other: fourteen octets before an x | 16 | 112.56 ± 0.8% | 163.02 ± 1.2% | 189.27 ± 1.6% | 15.13 ± 0.3% | 456.55 ± 1.1% | 410.60 ± 0.7% | 12839.99 ± 0.2% | 112.44 ± 0.8% | 0.69 | 1.00 | 7.44 | 0.25 |
| other: a Greek word | 8 | 434.99 ± 0.4% | 596.46 ± 0.7% | 1047.33 ± 0.5% | 58.80 ± 0.5% | 1391.09 ± 0.8% | 1874.22 ± 0.2% | refused | 434.92 ± 0.4% | 0.73 | 1.00 | 7.40 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12816.86 ± 1.4% | not timed | not timed | 16460.53 ± 0.9% | 2074.71 ± 23.3% | not timed | not timed | 12842.28 ± 0.6% | | 1.00 | 0.78 | 6.18 |
| 01-literal/sherlock-casei-en | 522 | 3884.41 ± 0.3% | not timed | not timed | 3592.29 ± 0.2% | 32.48 ± 0.3% | not timed | not timed | 3866.18 ± 0.4% | | 1.00 | 1.08 | 119.58 |
| 01-literal/sherlock-ru | 724 | 13559.31 ± 0.5% | not timed | not timed | 17348.31 ± 1.0% | 1399.62 ± 14.1% | not timed | not timed | 13528.33 ± 1.4% | | 1.00 | 0.78 | 9.69 |
| 01-literal/sherlock-casei-ru | 746 | 5240.49 ± 0.3% | not timed | not timed | 3320.75 ± 0.2% | 31.68 ± 10.5% | not timed | not timed | 5249.13 ± 0.2% | | 1.00 | 1.58 | 165.44 |
| 01-literal/sherlock-zh | 30 | 17135.88 ± 0.4% | not timed | not timed | 18820.50 ± 0.5% | 2524.51 ± 12.5% | not timed | not timed | 17084.04 ± 0.4% | | 1.00 | 0.91 | 6.79 |
| 02-literal-alternate/sherlock-en | 714 | 5812.31 ± 0.3% | not timed | not timed | 3936.89 ± 0.3% | 16.57 ± 0.2% | not timed | not timed | 5804.99 ± 0.4% | | 1.00 | 1.48 | 350.79 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1667.43 ± 0.9% | not timed | not timed | 698.86 ± 0.3% | 11.13 ± 0.2% | not timed | not timed | 1653.45 ± 0.4% | | 1.01 | 2.39 | 149.87 |
| 02-literal-alternate/sherlock-ru | 899 | 4649.08 ± 0.2% | not timed | not timed | 3258.80 ± 0.1% | 22.65 ± 0.2% | not timed | not timed | 4651.91 ± 0.1% | | 1.00 | 1.43 | 205.29 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1781.39 ± 0.3% | not timed | not timed | 1231.28 ± 0.1% | 9.15 ± 0.1% | not timed | not timed | 1774.08 ± 0.2% | | 1.00 | 1.45 | 194.59 |
| 02-literal-alternate/sherlock-zh | 207 | 7069.45 ± 0.3% | not timed | not timed | 4164.80 ± 0.2% | 31.54 ± 0.2% | not timed | not timed | 7066.53 ± 0.2% | | 1.00 | 1.70 | 224.11 |
| 03-date/ascii | 111817 | 124.60 ± 0.5% | not timed | not timed | 96.48 ± 0.1% | 0.20 ± 1.5% | not timed | not timed | 123.35 ± 0.2% | | 1.01 | 1.29 | 625.89 |
| 04-ruff-noqa/real | 84 | 555.28 ± 0.0% | not timed | not timed | 473.40 ± 0.2% | 19.58 ± 2.3% | not timed | not timed | 554.33 ± 0.1% | | 1.00 | 1.17 | 28.36 |
| 04-ruff-noqa/tweaked | 44 | 545.93 ± 0.5% | not timed | not timed | 465.65 ± 0.1% | 364.48 ± 0.4% | not timed | not timed | 544.79 ± 0.2% | | 1.00 | 1.17 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.49 ± 0.2% | not timed | not timed | 5.16 ± 0.1% | 0.20 ± 4.6% | not timed | not timed | 3.58 ± 2.7% | | 0.98 | 0.68 | 17.18 |
| 06-cloud-flare-redos/original | 107 | 270.76 ± 0.3% | not timed | not timed | 212.08 ± 0.1% | 24.81 ± 0.1% | not timed | not timed | 269.47 ± 0.6% | | 1.00 | 1.28 | 10.91 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.21 ± 0.5% | not timed | not timed | 228.48 ± 0.1% | 26.55 ± 0.3% | not timed | not timed | 263.82 ± 0.8% | | 1.00 | 1.16 | 9.95 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.18 ± 0.3% | not timed | not timed | 255.83 ± 0.1% | 28.76 ± 0.2% | not timed | not timed | 294.19 ± 0.2% | | 1.00 | 1.15 | 10.23 |
| 07-unicode-character-data/parse-line | 558784 | 230.48 ± 1.0% | not timed | not timed | 173.23 ± 0.1% | 42.78 ± 8.2% | not timed | not timed | 231.16 ± 1.9% | | 1.00 | 1.33 | 5.39 |
| 08-words/all-english | 56691 | 119.47 ± 0.2% | not timed | not timed | 83.40 ± 0.1% | 11.98 ± 13.2% | not timed | not timed | 118.71 ± 0.4% | | 1.01 | 1.43 | 9.97 |
| 08-words/long-english | 839 | 1005.62 ± 0.1% | not timed | not timed | 597.83 ± 0.0% | 32.29 ± 0.8% | not timed | not timed | 1004.73 ± 0.1% | | 1.00 | 1.68 | 31.14 |
| 09-aws-keys/full | 0 | 412.64 ± 0.1% | not timed | not timed | 472.58 ± 0.2% | 66.81 ± 3.5% | not timed | not timed | 412.72 ± 0.1% | | 1.00 | 0.87 | 6.18 |
| 09-aws-keys/quick | 0 | 744.96 ± 0.1% | not timed | not timed | 1000.91 ± 0.1% | 417.79 ± 0.6% | not timed | not timed | 741.30 ± 0.1% | | 1.00 | 0.74 | 1.78 |
| 10-bounded-repeat/letters-en | 1833 | 633.45 ± 0.6% | not timed | not timed | 518.58 ± 0.8% | 19.54 ± 0.3% | not timed | not timed | 632.79 ± 0.2% | | 1.00 | 1.22 | 32.41 |
| 10-bounded-repeat/letters-ru | 3475 | 380.44 ± 0.4% | not timed | not timed | 478.19 ± 0.2% | 21.97 ± 9.0% | not timed | not timed | 379.76 ± 0.4% | | 1.00 | 0.80 | 17.32 |
| 10-bounded-repeat/context | 53 | 77.91 ± 0.9% | not timed | not timed | 66.29 ± 0.5% | 19.79 ± 0.1% | not timed | not timed | 79.25 ± 1.4% | | 0.98 | 1.18 | 3.94 |
| 10-bounded-repeat/capitals | 11 | 1045.31 ± 0.1% | not timed | not timed | 616.79 ± 0.0% | 36.66 ± 0.1% | not timed | not timed | 1045.59 ± 0.2% | | 1.00 | 1.69 | 28.51 |
| 11-unstructured-to-json/extract | 600 | 47.75 ± 0.2% | not timed | not timed | 76.50 ± 0.3% | 49.09 ± 0.4% | not timed | not timed | 47.58 ± 0.9% | | 1.00 | 0.62 | 0.97 |
| 12-dictionary/single | 1 | 570.69 ± 0.2% | not timed | not timed | 561.80 ± 0.0% | 0.40 ± 0.1% | not timed | not timed | 572.59 ± 0.1% | | 1.00 | 1.02 | 1426.52 |
| 14-quadratic/1x | 100 | 12.99 ± 0.3% | not timed | not timed | 10.04 ± 0.3% | 0.96 ± 3.0% | not timed | not timed | 12.96 ± 0.8% | | 1.00 | 1.29 | 13.49 |
| 14-quadratic/2x | 200 | 7.98 ± 0.4% | not timed | not timed | 5.56 ± 0.2% | 0.53 ± 1.8% | not timed | not timed | 7.95 ± 1.6% | | 1.00 | 1.44 | 14.92 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.3% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.5% | not timed | not timed | 1.86 ± 1.1% | | 1.00 | 1.53 | 16.11 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 1.3% | not timed | not timed | 0.35 ± 0.2% | 0.55 ± 2.5% | not timed | not timed | 1.45 ± 0.9% | | 1.00 | 4.20 | 2.65 |
| 04-ruff-noqa/compile-real | 1 | 93.07 ± 0.2% | not timed | not timed | 13.76 ± 0.2% | 140.82 ± 3.2% | not timed | not timed | 92.64 ± 1.0% | | 1.00 | 6.76 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.68 ± 0.3% | not timed | not timed | 2.52 ± 0.8% | 6.47 ± 1.3% | not timed | not timed | 14.65 ± 1.0% | | 1.00 | 5.83 | 2.27 |
| 07-unicode-character-data/compile | 1 | 58.26 ± 0.1% | not timed | not timed | 25.82 ± 0.3% | 36.39 ± 1.6% | not timed | not timed | 58.38 ± 0.7% | | 1.00 | 2.26 | 1.60 |
| 09-aws-keys/compile-full | 1 | 43.67 ± 0.2% | not timed | not timed | 8.25 ± 0.5% | 23.42 ± 2.0% | not timed | not timed | 43.57 ± 0.7% | | 1.00 | 5.29 | 1.86 |
| 09-aws-keys/compile-quick | 1 | 188.72 ± 0.1% | not timed | not timed | 47.17 ± 0.2% | 133.97 ± 3.4% | not timed | not timed | 190.32 ± 1.1% | | 0.99 | 4.00 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.67 ± 0.8% | not timed | not timed | 11.12 ± 0.2% | 16.49 ± 2.8% | not timed | not timed | 14.63 ± 1.2% | | 1.00 | 1.32 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 86.12 ± 0.3% | not timed | not timed | 8.07 ± 0.4% | 23.77 ± 3.1% | not timed | not timed | 85.80 ± 0.5% | | 1.00 | 10.67 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 90.71 ± 0.2% | not timed | not timed | 41.01 ± 0.7% | 68.03 ± 3.6% | not timed | not timed | 90.56 ± 0.3% | | 1.00 | 2.21 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 35.4% | 0.09 ± 11.8% | not timed | not timed | 0.36 ± 1.4% | | 1.00 | 5.30 | 3.89 |

