# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102078946 |
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
| literal: a word | 217 | 32210.44 ± 1.2% | 1082.56 ± 0.2% | 35.33 ± 2.9% | 32470.95 ± 0.8% | 12449.85 ± 3.3% | 14.83 ± 0.3% | 114.88 ± 0.8% | 32197.26 ± 0.4% | 29.75 | 1.00 | 0.99 | 2.59 |
| literal: a word that is not there | 0 | 42328.91 ± 1.4% | 1094.40 ± 1.0% | 34.77 ± 2.8% | 35995.22 ± 0.3% | 39899.70 ± 1.3% | 14.35 ± 0.1% | 109.59 ± 0.4% | 42270.91 ± 0.3% | 38.68 | 1.00 | 1.18 | 1.06 |
| literal: one of four words | 661 | 13122.67 ± 1.0% | 1055.01 ± 0.5% | 18.92 ± 1.2% | 9584.48 ± 0.7% | 29.04 ± 0.9% | 4.26 ± 0.5% | 9.60 ± 0.6% | 12932.53 ± 0.3% | 12.44 | 1.01 | 1.37 | 451.85 |
| literal: a word in any case | 217 | 27157.36 ± 0.8% | 1077.64 ± 0.9% | 24.67 ± 2.5% | 9930.33 ± 1.7% | 57.98 ± 17.8% | refused | differs | 27196.29 ± 0.6% | 25.20 | 1.00 | 2.73 | 468.42 |
| literal: an href attribute | 33 | 27868.13 ± 0.6% | 1082.02 ± 0.5% | 31.31 ± 1.5% | 29070.81 ± 0.6% | 2566.75 ± 1.6% | 10.46 ± 0.6% | 100.55 ± 0.1% | 27783.95 ± 2.1% | 25.76 | 1.00 | 0.96 | 10.86 |
| literal: a word, second text | 123 | 32499.10 ± 0.5% | 1081.10 ± 0.4% | 33.52 ± 2.8% | 31084.58 ± 0.9% | 8718.80 ± 6.9% | 19.13 ± 0.4% | 93.73 ± 0.6% | 32490.84 ± 1.4% | 30.06 | 1.00 | 1.05 | 3.73 |
| class: two capitalized words | 1331 | 998.64 ± 0.5% | 990.84 ± 0.5% | 32.00 ± 1.6% | 606.02 ± 0.2% | 48.49 ± 0.8% | 12.49 ± 0.8% | 81.56 ± 0.4% | 998.21 ± 0.4% | 1.01 | 1.00 | 1.65 | 20.60 |
| class: a word that ends in ing | 3399 | 903.06 ± 0.3% | 904.14 ± 0.1% | 21.02 ± 0.8% | 569.68 ± 0.6% | 35.13 ± 9.7% | 7.09 ± 0.4% | 23.23 ± 0.7% | 903.20 ± 0.4% | 1.00 | 1.00 | 1.59 | 25.71 |
| class: a word in capitals | 2332 | 1356.28 ± 1.0% | 976.89 ± 0.6% | 34.01 ± 2.6% | 600.31 ± 0.5% | 52.30 ± 6.1% | 15.11 ± 0.5% | 106.09 ± 0.5% | 1356.46 ± 0.6% | 1.39 | 1.00 | 2.26 | 25.93 |
| class: a number | 8288 | 2009.28 ± 0.7% | 829.12 ± 0.8% | 33.39 ± 2.6% | 2112.89 ± 0.7% | 54.45 ± 15.2% | 0.42 ± 0.5% | 79.94 ± 0.6% | 2001.72 ± 0.8% | 2.42 | 1.00 | 0.95 | 36.90 |
| class: two capitalized words, second text | 5359 | 716.90 ± 0.3% | 715.31 ± 0.6% | 28.66 ± 0.9% | 503.38 ± 0.1% | 42.22 ± 14.6% | 16.28 ± 0.6% | 74.79 ± 0.8% | 716.44 ± 0.4% | 1.00 | 1.00 | 1.42 | 16.98 |
| other: a word between two words | 6104 | 725.93 ± 0.3% | 770.85 ± 0.4% | 28.46 ± 0.6% | 869.44 ± 0.4% | 131.76 ± 8.5% | 9.55 ± 0.3% | 86.76 ± 1.0% | 726.38 ± 0.5% | 0.94 | 1.00 | 0.83 | 5.51 |
| other: a number before a unit, second text | 1481 | 8655.91 ± 1.7% | 1013.28 ± 0.3% | 31.98 ± 1.0% | 9353.26 ± 0.5% | 48.87 ± 0.9% | 17.10 ± 0.2% | 78.05 ± 1.8% | 8489.88 ± 0.7% | 8.54 | 1.02 | 0.93 | 177.11 |
| other: a heading's start tag | 110 | 20354.82 ± 0.6% | 1078.42 ± 0.4% | 33.79 ± 0.3% | 2660.08 ± 0.7% | 1885.40 ± 8.9% | 13.04 ± 0.4% | 119.13 ± 0.7% | 20338.96 ± 0.7% | 18.87 | 1.00 | 7.65 | 10.80 |
| other: a whole word | 217 | 25246.44 ± 0.5% | 1085.38 ± 0.1% | 35.38 ± 3.4% | 26190.61 ± 0.2% | 60.43 ± 0.5% | 12.53 ± 0.4% | 68.62 ± 0.7% | 25254.01 ± 0.3% | 23.26 | 1.00 | 0.96 | 417.78 |
| other: a line's first word, second text | 3716 | 2321.59 ± 0.7% | 892.73 ± 0.5% | 38.11 ± 3.6% | 2425.45 ± 2.9% | 81.28 ± 3.2% | refused | refused | 2308.54 ± 0.4% | 2.60 | 1.01 | 0.96 | 28.56 |
| other: fourteen octets before an x | 87 | 35956.04 ± 0.9% | 290.44 ± 0.8% | 6.61 ± 0.8% | 4106.83 ± 0.4% | 11.61 ± 0.9% | differs | 20.79 ± 0.3% | 35902.70 ± 0.7% | 123.80 | 1.00 | 8.76 | 3096.44 |
| other: a Greek word | 21815 | 487.80 ± 0.3% | 343.29 ± 0.3% | 37.10 ± 0.9% | 312.69 ± 0.3% | 62.22 ± 8.0% | differs | refused | 487.09 ± 0.6% | 1.42 | 1.00 | 1.56 | 7.84 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.52 ± 0.2% | 29.51 ± 0.6% | 1.09 ± 0.5% | 21.45 ± 0.2% | 3.22 ± 0.5% | differs | 4.98 ± 0.4% | 29.58 ± 0.4% | 1.00 | 1.00 | 1.38 | 9.16 |
| a UUID | 32895 | 26.38 ± 0.7% | 26.38 ± 0.8% | 0.76 ± 1.5% | 16.47 ± 0.8% | 3.21 ± 1.5% | 0.71 ± 0.5% | 4.13 ± 1.1% | 26.38 ± 0.5% | 1.00 | 1.00 | 1.60 | 8.21 |
| an IPv4 address | 33176 | 38.97 ± 2.6% | 38.96 ± 0.7% | 2.40 ± 0.8% | 31.33 ± 0.3% | 8.03 ± 1.3% | differs | 4.84 ± 2.2% | 38.79 ± 1.1% | 1.00 | 1.00 | 1.24 | 4.85 |
| a date and time | 32954 | 38.26 ± 1.0% | 38.24 ± 1.1% | 1.74 ± 0.9% | 23.78 ± 1.1% | 10.20 ± 2.6% | 1.29 ± 1.0% | 9.17 ± 0.9% | 38.37 ± 1.2% | 1.00 | 1.00 | 1.61 | 3.75 |
| a field path | 32606 | 31.94 ± 0.8% | 31.92 ± 0.6% | 1.26 ± 1.2% | 24.66 ± 0.8% | 3.68 ± 2.9% | differs | 3.14 ± 1.0% | 31.90 ± 2.5% | 1.00 | 1.00 | 1.30 | 8.69 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.01 ± 0.4% | 10.01 ± 1.5% | 9.99 ± 1.6% | 14.70 ± 4.4% | 6.67 ± 1.4% | 1.02 ± 1.3% | none | 10.03 ± 0.9% | 1.00 | 1.00 | 0.68 | 1.50 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 291.05 ± 0.6% | 292.06 ± 0.5% | 347.40 ± 3.0% | 116.06 ± 2.9% | 259.24 ± 13.5% | 686.88 ± 1.6% | 4308.33 ± 0.2% | 290.17 ± 0.9% | 1.00 | 1.00 | 2.51 | 1.12 |
| a UUID | 62 | 188.79 ± 1.0% | 190.01 ± 0.8% | 215.48 ± 0.6% | 61.55 ± 1.0% | 116.29 ± 4.0% | 249.73 ± 2.9% | 5596.66 ± 1.3% | 188.86 ± 1.2% | 0.99 | 1.00 | 3.07 | 1.62 |
| an IPv4 address | 29 | 559.97 ± 1.1% | 567.88 ± 0.7% | 835.33 ± 1.0% | 100.08 ± 1.0% | 155.15 ± 1.1% | 432.88 ± 1.0% | 10222.69 ± 1.5% | 560.98 ± 0.9% | 0.99 | 1.00 | 5.60 | 3.61 |
| a date and time | 56 | 437.30 ± 0.8% | 440.65 ± 0.7% | 580.96 ± 0.3% | 96.41 ± 0.7% | 163.71 ± 7.6% | 442.62 ± 0.6% | 5512.86 ± 0.8% | 436.69 ± 3.7% | 0.99 | 1.00 | 4.54 | 2.67 |
| a field path | 39 | 281.83 ± 0.9% | 282.71 ± 0.7% | 333.61 ± 0.6% | 104.95 ± 1.2% | 246.08 ± 2.5% | 709.11 ± 2.4% | 5359.93 ± 2.0% | 281.13 ± 0.7% | 1.00 | 1.00 | 2.69 | 1.15 |
| literal: a word | 7 | 874.83 ± 0.9% | 934.29 ± 1.1% | 1805.88 ± 0.6% | 712.52 ± 0.7% | 813.81 ± 1.2% | 1457.11 ± 1.2% | 36613.40 ± 1.9% | 874.25 ± 0.4% | 0.94 | 1.00 | 1.23 | 1.07 |
| literal: a word that is not there | 8 | 839.64 ± 0.7% | 900.86 ± 0.7% | 1701.59 ± 0.7% | 634.03 ± 1.3% | 764.07 ± 8.2% | 1363.16 ± 0.8% | 35577.49 ± 0.9% | 839.12 ± 0.6% | 0.93 | 1.00 | 1.32 | 1.10 |
| literal: one of four words | 26 | 330.10 ± 0.5% | 578.25 ± 0.7% | 835.49 ± 1.5% | 50.05 ± 1.4% | 301.18 ± 3.7% | 505.28 ± 1.7% | 19042.92 ± 1.4% | 330.19 ± 0.5% | 0.57 | 1.00 | 6.60 | 1.10 |
| literal: a word in any case | 11 | 671.67 ± 1.1% | 715.68 ± 0.6% | 1135.52 ± 0.9% | 17.33 ± 0.8% | 840.83 ± 12.4% | refused | 29651.32 ± 4.9% | 671.91 ± 0.6% | 0.94 | 1.00 | 38.75 | 0.80 |
| literal: an href attribute | 12 | 451.30 ± 0.7% | 464.47 ± 0.9% | 623.91 ± 1.6% | 50.11 ± 1.6% | 611.15 ± 3.1% | 1156.84 ± 0.4% | 26510.85 ± 0.4% | 450.17 ± 1.4% | 0.97 | 1.00 | 9.01 | 0.74 |
| literal: a word, second text | 10 | 782.29 ± 0.6% | 855.08 ± 0.8% | 1538.11 ± 1.3% | 589.04 ± 0.4% | 672.95 ± 6.5% | 1180.86 ± 1.2% | 31903.63 ± 0.5% | 780.24 ± 0.8% | 0.91 | 1.00 | 1.33 | 1.16 |
| class: two capitalized words | 23 | 623.79 ± 0.5% | 678.00 ± 0.1% | 1055.46 ± 0.5% | 134.72 ± 1.1% | 629.63 ± 1.4% | 1115.04 ± 1.1% | 7646.23 ± 0.8% | 624.52 ± 3.7% | 0.92 | 1.00 | 4.63 | 0.99 |
| class: a word that ends in ing | 9 | 746.30 ± 1.0% | 844.92 ± 1.1% | 1625.53 ± 1.1% | 171.75 ± 0.5% | 927.49 ± 2.0% | 1725.75 ± 0.6% | 20084.99 ± 1.7% | 745.83 ± 0.6% | 0.88 | 1.00 | 4.35 | 0.80 |
| class: a word in capitals | 16 | 665.66 ± 0.2% | 728.87 ± 0.9% | 1288.25 ± 1.2% | 179.38 ± 2.1% | 924.63 ± 7.6% | 1578.79 ± 0.8% | 10105.92 ± 0.6% | 666.80 ± 1.1% | 0.91 | 1.00 | 3.71 | 0.72 |
| class: a number | 6 | 804.06 ± 1.1% | 898.98 ± 0.8% | 1852.21 ± 3.0% | 43.42 ± 1.8% | 1717.73 ± 2.2% | 3011.63 ± 2.7% | 29809.57 ± 0.9% | 804.60 ± 3.1% | 0.89 | 1.00 | 18.52 | 0.47 |
| class: two capitalized words, second text | 23 | 624.26 ± 1.1% | 678.59 ± 0.8% | 1059.23 ± 1.2% | 133.83 ± 4.6% | 626.98 ± 2.2% | 1133.49 ± 1.6% | 7671.35 ± 1.2% | 624.10 ± 1.2% | 0.92 | 1.00 | 4.66 | 1.00 |
| other: a word between two words | 13 | 752.58 ± 3.5% | 781.84 ± 0.5% | 1333.03 ± 0.7% | 181.62 ± 1.0% | 620.53 ± 12.9% | 1219.26 ± 2.5% | 18331.20 ± 1.8% | 752.36 ± 0.7% | 0.96 | 1.00 | 4.14 | 1.21 |
| other: a number before a unit, second text | 15 | 521.68 ± 0.6% | 576.53 ± 0.6% | 829.69 ± 0.8% | 41.06 ± 1.6% | 785.25 ± 0.8% | 1357.01 ± 2.3% | 18988.07 ± 1.3% | 520.72 ± 6.8% | 0.90 | 1.00 | 12.71 | 0.66 |
| other: a heading's start tag | 13 | 465.85 ± 4.4% | 473.35 ± 0.5% | 638.55 ± 0.5% | 48.30 ± 0.3% | 767.97 ± 1.5% | 1320.11 ± 1.2% | 22858.75 ± 4.2% | 465.79 ± 0.9% | 0.98 | 1.00 | 9.64 | 0.61 |
| other: a whole word | 11 | 794.39 ± 0.3% | 845.54 ± 0.6% | 1493.81 ± 0.9% | 159.60 ± 0.6% | 712.85 ± 8.2% | 1254.47 ± 0.5% | 32524.86 ± 2.1% | 795.65 ± 0.4% | 0.94 | 1.00 | 4.98 | 1.11 |
| other: a line's first word, second text | 17 | 718.48 ± 0.5% | 749.43 ± 0.9% | 1295.60 ± 0.6% | 171.51 ± 2.4% | 857.06 ± 13.4% | refused | refused | 717.95 ± 1.3% | 0.96 | 1.00 | 4.19 | 0.84 |
| other: fourteen octets before an x | 16 | 132.32 ± 0.6% | 190.39 ± 1.2% | 225.77 ± 0.4% | 18.47 ± 0.5% | 550.89 ± 1.8% | 587.80 ± 3.9% | 16170.59 ± 1.1% | 132.67 ± 1.0% | 0.69 | 1.00 | 7.16 | 0.24 |
| other: a Greek word | 8 | 540.23 ± 1.3% | 766.18 ± 1.4% | 1336.94 ± 0.9% | 61.11 ± 0.6% | 1716.74 ± 0.6% | 2890.71 ± 1.1% | refused | 539.67 ± 0.8% | 0.71 | 1.00 | 8.84 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23247.84 ± 0.9% | not timed | not timed | 28717.06 ± 0.8% | 2869.64 ± 13.0% | not timed | not timed | 23135.85 ± 0.7% | | 1.00 | 0.81 | 8.10 |
| 01-literal/sherlock-casei-en | 522 | 5142.93 ± 0.3% | not timed | not timed | 8405.80 ± 0.7% | 39.66 ± 1.4% | not timed | not timed | 5140.35 ± 0.6% | | 1.00 | 0.61 | 129.67 |
| 01-literal/sherlock-ru | 724 | 24028.16 ± 1.3% | not timed | not timed | 27399.35 ± 1.6% | 1584.51 ± 4.1% | not timed | not timed | 23937.68 ± 0.7% | | 1.00 | 0.88 | 15.16 |
| 01-literal/sherlock-casei-ru | 746 | 8181.73 ± 0.4% | not timed | not timed | 6490.95 ± 0.9% | 42.51 ± 3.9% | not timed | not timed | 8170.93 ± 0.8% | | 1.00 | 1.26 | 192.45 |
| 01-literal/sherlock-zh | 30 | 37614.09 ± 1.7% | not timed | not timed | 34798.09 ± 1.0% | 1588.69 ± 1.5% | not timed | not timed | 37573.92 ± 0.8% | | 1.00 | 1.08 | 23.68 |
| 02-literal-alternate/sherlock-en | 714 | 12035.22 ± 1.6% | not timed | not timed | 9342.86 ± 0.8% | 22.17 ± 0.6% | not timed | not timed | 11984.06 ± 0.5% | | 1.00 | 1.29 | 542.92 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2007.35 ± 1.5% | not timed | not timed | 2297.02 ± 0.7% | 13.61 ± 1.7% | not timed | not timed | 2004.51 ± 1.3% | | 1.00 | 0.87 | 147.52 |
| 02-literal-alternate/sherlock-ru | 899 | 6923.00 ± 0.3% | not timed | not timed | 5148.72 ± 0.3% | 28.83 ± 18.3% | not timed | not timed | 6789.75 ± 1.4% | | 1.02 | 1.34 | 240.17 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2113.71 ± 1.8% | not timed | not timed | 1246.30 ± 0.9% | 11.62 ± 2.5% | not timed | not timed | 2115.39 ± 0.8% | | 1.00 | 1.70 | 181.92 |
| 02-literal-alternate/sherlock-zh | 207 | 16362.75 ± 0.5% | not timed | not timed | 10774.53 ± 0.9% | 41.66 ± 3.1% | not timed | not timed | 16334.87 ± 0.4% | | 1.00 | 1.52 | 392.81 |
| 03-date/ascii | 111817 | 123.87 ± 1.5% | not timed | not timed | 110.61 ± 3.2% | 0.26 ± 4.3% | not timed | not timed | 123.01 ± 1.4% | | 1.01 | 1.12 | 476.04 |
| 04-ruff-noqa/real | 84 | 707.92 ± 2.8% | not timed | not timed | 567.14 ± 0.7% | 25.59 ± 1.8% | not timed | not timed | 716.85 ± 4.0% | | 0.99 | 1.25 | 27.66 |
| 04-ruff-noqa/tweaked | 44 | 636.34 ± 0.4% | not timed | not timed | 568.99 ± 1.2% | 367.19 ± 1.2% | not timed | not timed | 633.64 ± 1.0% | | 1.00 | 1.12 | 1.73 |
| 05-lexer-veryl/single | 124800 | 4.17 ± 1.2% | not timed | not timed | 5.72 ± 0.9% | 0.26 ± 6.1% | not timed | not timed | 4.18 ± 0.7% | | 1.00 | 0.73 | 15.78 |
| 06-cloud-flare-redos/original | 107 | 250.57 ± 5.3% | not timed | not timed | 261.93 ± 0.9% | 32.24 ± 0.8% | not timed | not timed | 250.96 ± 1.2% | | 1.00 | 0.96 | 7.77 |
| 06-cloud-flare-redos/simplified-short | 102 | 171.85 ± 0.3% | not timed | not timed | 267.24 ± 0.7% | 35.20 ± 1.6% | not timed | not timed | 173.51 ± 0.7% | | 0.99 | 0.64 | 4.88 |
| 06-cloud-flare-redos/simplified-long | 10000 | 184.83 ± 2.5% | not timed | not timed | 278.21 ± 1.3% | 37.87 ± 1.2% | not timed | not timed | 187.04 ± 3.2% | | 0.99 | 0.66 | 4.88 |
| 07-unicode-character-data/parse-line | 558784 | 52.37 ± 1.1% | not timed | not timed | 206.13 ± 1.4% | 53.59 ± 3.1% | not timed | not timed | 52.49 ± 0.4% | | 1.00 | 0.25 | 0.98 |
| 08-words/all-english | 56691 | 104.33 ± 1.4% | not timed | not timed | 92.60 ± 1.4% | 15.30 ± 7.9% | not timed | not timed | 103.76 ± 0.7% | | 1.01 | 1.13 | 6.82 |
| 08-words/long-english | 839 | 1032.17 ± 1.4% | not timed | not timed | 621.47 ± 0.9% | 37.83 ± 1.0% | not timed | not timed | 1035.34 ± 1.1% | | 1.00 | 1.66 | 27.29 |
| 09-aws-keys/full | 0 | 564.65 ± 0.6% | not timed | not timed | 574.29 ± 0.7% | 82.08 ± 1.3% | not timed | not timed | 564.60 ± 1.3% | | 1.00 | 0.98 | 6.88 |
| 09-aws-keys/quick | 0 | 563.76 ± 1.6% | not timed | not timed | 885.50 ± 1.4% | 406.68 ± 3.7% | not timed | not timed | 560.65 ± 0.6% | | 1.01 | 0.64 | 1.39 |
| 10-bounded-repeat/letters-en | 1833 | 599.89 ± 0.9% | not timed | not timed | 545.09 ± 1.4% | 23.99 ± 1.0% | not timed | not timed | 599.82 ± 0.6% | | 1.00 | 1.10 | 25.00 |
| 10-bounded-repeat/letters-ru | 3475 | 388.38 ± 0.3% | not timed | not timed | 489.21 ± 0.5% | 25.03 ± 13.8% | not timed | not timed | 387.76 ± 0.4% | | 1.00 | 0.79 | 15.52 |
| 10-bounded-repeat/context | 53 | 82.84 ± 1.1% | not timed | not timed | 73.19 ± 0.7% | 24.15 ± 0.8% | not timed | not timed | 83.22 ± 1.0% | | 1.00 | 1.13 | 3.43 |
| 10-bounded-repeat/capitals | 11 | 1077.66 ± 0.5% | not timed | not timed | 638.16 ± 0.8% | 44.25 ± 0.4% | not timed | not timed | 1074.69 ± 0.6% | | 1.00 | 1.69 | 24.35 |
| 11-unstructured-to-json/extract | 600 | 29.00 ± 0.5% | not timed | not timed | 80.61 ± 0.5% | 63.53 ± 1.0% | not timed | not timed | 28.89 ± 0.7% | | 1.00 | 0.36 | 0.46 |
| 12-dictionary/single | 1 | 563.48 ± 0.2% | not timed | not timed | 545.25 ± 0.4% | 0.52 ± 0.4% | not timed | not timed | 566.40 ± 0.5% | | 0.99 | 1.03 | 1081.32 |
| 14-quadratic/1x | 100 | 14.31 ± 0.5% | not timed | not timed | 13.41 ± 0.3% | 1.24 ± 1.9% | not timed | not timed | 14.29 ± 0.7% | | 1.00 | 1.07 | 11.57 |
| 14-quadratic/2x | 200 | 8.56 ± 0.3% | not timed | not timed | 6.55 ± 0.7% | 0.69 ± 1.1% | not timed | not timed | 8.54 ± 0.5% | | 1.00 | 1.31 | 12.46 |
| 14-quadratic/10x | 1000 | 1.91 ± 0.3% | not timed | not timed | 1.28 ± 0.2% | 0.15 ± 0.9% | not timed | not timed | 1.91 ± 1.4% | | 1.00 | 1.49 | 12.64 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.99 ± 1.5% | not timed | not timed | 0.44 ± 0.7% | 0.66 ± 2.9% | not timed | not timed | 1.98 ± 0.3% | | 1.00 | 4.53 | 3.03 |
| 04-ruff-noqa/compile-real | 1 | 126.49 ± 6.6% | not timed | not timed | 15.69 ± 1.0% | 173.79 ± 1.4% | not timed | not timed | 125.66 ± 1.0% | | 1.01 | 8.06 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 21.68 ± 0.3% | not timed | not timed | 3.03 ± 3.7% | 7.68 ± 1.8% | not timed | not timed | 21.51 ± 1.0% | | 1.01 | 7.16 | 2.82 |
| 07-unicode-character-data/compile | 1 | 78.05 ± 1.6% | not timed | not timed | 32.21 ± 1.3% | 43.27 ± 2.0% | not timed | not timed | 75.85 ± 6.6% | | 1.03 | 2.42 | 1.80 |
| 09-aws-keys/compile-full | 1 | 53.30 ± 0.9% | not timed | not timed | 8.96 ± 1.4% | 27.63 ± 0.7% | not timed | not timed | 53.35 ± 1.1% | | 1.00 | 5.95 | 1.93 |
| 09-aws-keys/compile-quick | 1 | 247.93 ± 0.9% | not timed | not timed | 59.06 ± 1.0% | 160.45 ± 2.7% | not timed | not timed | 245.16 ± 0.9% | | 1.01 | 4.20 | 1.55 |
| 10-bounded-repeat/compile-context | 1 | 16.70 ± 5.7% | not timed | not timed | 13.65 ± 1.1% | 20.11 ± 4.9% | not timed | not timed | 16.54 ± 0.9% | | 1.01 | 1.22 | 0.83 |
| 10-bounded-repeat/compile-capitals | 1 | 101.37 ± 1.2% | not timed | not timed | 10.29 ± 1.2% | 28.80 ± 5.0% | not timed | not timed | 102.62 ± 1.7% | | 0.99 | 9.85 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 118.11 ± 1.7% | not timed | not timed | 50.30 ± 1.8% | 80.80 ± 0.6% | not timed | not timed | 117.14 ± 1.1% | | 1.01 | 2.35 | 1.46 |
| 12-dictionary/compile-single | 1 | 0.37 ± 0.7% | not timed | not timed | 0.08 ± 0.6% | 0.12 ± 19.8% | not timed | not timed | 0.37 ± 2.2% | | 1.01 | 4.74 | 3.17 |

