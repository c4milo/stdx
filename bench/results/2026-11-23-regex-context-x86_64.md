# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117634053 |
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
| literal: a word | 217 | 32524.41 ± 0.2% | 797.55 ± 0.3% | 23.62 ± 1.6% | 30226.26 ± 0.6% | 9369.27 ± 9.1% | 9.90 ± 0.2% | 80.89 ± 1.9% | 32493.87 ± 0.3% | 40.78 | 1.00 | 1.08 | 3.47 |
| literal: a word that is not there | 0 | 45643.46 ± 0.3% | 805.60 ± 0.2% | 23.62 ± 4.4% | 35661.01 ± 1.5% | 33609.54 ± 2.7% | 9.77 ± 0.5% | 75.49 ± 0.6% | 45595.12 ± 4.1% | 56.66 | 1.00 | 1.28 | 1.36 |
| literal: one of four words | 661 | 10906.88 ± 0.3% | 781.39 ± 0.3% | 12.96 ± 6.0% | 8874.04 ± 4.6% | 19.18 ± 4.6% | 3.46 ± 0.3% | 6.43 ± 0.7% | 10852.96 ± 5.6% | 13.96 | 1.00 | 1.23 | 568.67 |
| literal: a word in any case | 217 | 29283.89 ± 1.1% | 796.81 ± 0.4% | 17.86 ± 3.2% | 8969.83 ± 0.4% | 36.61 ± 1.0% | refused | differs | 29344.23 ± 2.3% | 36.75 | 1.00 | 3.26 | 799.95 |
| literal: an href attribute | 33 | 27580.02 ± 0.5% | 802.27 ± 0.5% | 22.79 ± 0.6% | 27080.48 ± 0.8% | 2298.41 ± 3.6% | 7.42 ± 0.2% | 70.64 ± 0.3% | 27542.43 ± 0.9% | 34.38 | 1.00 | 1.02 | 12.00 |
| literal: a word, second text | 123 | 34106.54 ± 0.5% | 798.60 ± 0.7% | 23.28 ± 0.6% | 30297.93 ± 1.4% | 8732.51 ± 28.8% | 11.21 ± 0.5% | 67.62 ± 1.0% | 34038.44 ± 0.2% | 42.71 | 1.00 | 1.13 | 3.91 |
| class: two capitalized words | 1331 | 695.71 ± 2.7% | 737.13 ± 0.5% | 22.09 ± 0.7% | 446.66 ± 0.1% | 34.37 ± 1.7% | 8.48 ± 0.2% | 61.08 ± 3.8% | 695.00 ± 0.3% | 0.94 | 1.00 | 1.56 | 20.24 |
| class: a word that ends in ing | 3399 | 675.18 ± 0.4% | 675.85 ± 0.2% | 15.25 ± 1.5% | 418.41 ± 0.4% | 25.37 ± 8.7% | 4.79 ± 0.2% | 16.14 ± 0.6% | 674.72 ± 0.3% | 1.00 | 1.00 | 1.61 | 26.62 |
| class: a word in capitals | 2332 | 887.11 ± 0.8% | 721.76 ± 0.9% | 23.22 ± 0.5% | 439.10 ± 0.6% | 36.80 ± 10.5% | 9.60 ± 0.3% | 77.97 ± 1.6% | 886.95 ± 0.2% | 1.23 | 1.00 | 2.02 | 24.11 |
| class: a number | 8288 | 1337.18 ± 0.5% | 612.63 ± 0.4% | 23.23 ± 1.3% | 1379.88 ± 8.6% | 36.57 ± 7.9% | 0.30 ± 0.5% | 54.87 ± 0.4% | 1346.10 ± 0.9% | 2.18 | 0.99 | 0.97 | 36.56 |
| class: two capitalized words, second text | 5359 | 530.89 ± 0.3% | 532.65 ± 0.3% | 19.90 ± 0.9% | 352.49 ± 0.1% | 28.99 ± 13.5% | 9.86 ± 0.3% | 56.70 ± 0.7% | 532.10 ± 0.2% | 1.00 | 1.00 | 1.51 | 18.31 |
| other: a word between two words | 6104 | 605.22 ± 0.4% | 565.89 ± 0.3% | 19.89 ± 1.7% | 629.63 ± 0.3% | 95.56 ± 15.1% | 6.57 ± 0.2% | 62.89 ± 0.2% | 602.55 ± 0.6% | 1.07 | 1.00 | 0.96 | 6.33 |
| other: a number before a unit, second text | 1481 | 7172.74 ± 2.3% | 759.12 ± 0.3% | 21.98 ± 1.6% | 6389.49 ± 0.8% | 34.82 ± 0.8% | 10.28 ± 0.4% | 59.37 ± 3.3% | 7268.76 ± 1.3% | 9.45 | 0.99 | 1.12 | 206.02 |
| other: a heading's start tag | 110 | 19150.25 ± 0.3% | 794.94 ± 0.5% | 23.31 ± 0.1% | 1928.45 ± 3.9% | 1563.62 ± 4.8% | 9.08 ± 1.1% | 82.99 ± 0.2% | 19105.29 ± 0.5% | 24.09 | 1.00 | 9.93 | 12.25 |
| other: a whole word | 217 | 22471.85 ± 0.3% | 798.29 ± 0.6% | 23.95 ± 1.0% | 22009.21 ± 0.5% | 42.21 ± 0.5% | 8.58 ± 0.1% | 48.44 ± 0.3% | 23042.67 ± 0.7% | 28.15 | 0.98 | 1.02 | 532.35 |
| other: a line's first word, second text | 3716 | 1811.40 ± 1.3% | 659.41 ± 0.1% | 25.09 ± 1.5% | 1808.65 ± 3.1% | 55.32 ± 2.1% | refused | refused | 1790.19 ± 1.4% | 2.75 | 1.01 | 1.00 | 32.74 |
| other: fourteen octets before an x | 87 | 27697.97 ± 0.7% | 189.79 ± 0.7% | 5.43 ± 0.2% | 2636.74 ± 1.6% | 8.97 ± 0.7% | differs | 15.65 ± 2.0% | 28144.77 ± 0.2% | 145.94 | 0.98 | 10.50 | 3086.85 |
| other: a Greek word | 21815 | 374.59 ± 0.4% | 254.49 ± 7.8% | 25.83 ± 1.4% | 236.28 ± 0.3% | 42.65 ± 14.0% | differs | refused | 373.25 ± 0.6% | 1.47 | 1.00 | 1.59 | 8.78 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.32 ± 0.2% | 22.28 ± 0.5% | 0.77 ± 0.3% | 15.41 ± 0.2% | 1.70 ± 0.6% | differs | 3.28 ± 2.0% | 22.22 ± 0.6% | 1.00 | 1.00 | 1.45 | 13.16 |
| a UUID | 32895 | 18.70 ± 0.2% | 18.80 ± 0.2% | 0.56 ± 4.7% | 11.72 ± 0.7% | 2.39 ± 1.9% | 0.40 ± 0.8% | 2.87 ± 5.8% | 18.81 ± 0.2% | 0.99 | 0.99 | 1.60 | 7.83 |
| an IPv4 address | 33176 | 31.09 ± 1.7% | 31.03 ± 0.8% | 1.79 ± 0.4% | 22.06 ± 0.7% | 5.40 ± 2.1% | differs | 3.25 ± 3.1% | 31.26 ± 1.1% | 1.00 | 0.99 | 1.41 | 5.76 |
| a date and time | 32954 | 28.30 ± 0.4% | 28.26 ± 2.0% | 1.34 ± 1.4% | 16.77 ± 0.2% | 6.36 ± 4.0% | 0.70 ± 0.5% | 5.59 ± 1.5% | 28.31 ± 0.1% | 1.00 | 1.00 | 1.69 | 4.45 |
| a field path | 32606 | 24.75 ± 1.0% | 24.80 ± 0.3% | 0.86 ± 1.2% | 17.81 ± 1.7% | 2.72 ± 2.4% | differs | 2.30 ± 0.9% | 24.82 ± 0.9% | 1.00 | 1.00 | 1.39 | 9.10 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.54 ± 1.2% | 8.49 ± 0.6% | 8.54 ± 0.4% | 10.45 ± 1.0% | 4.55 ± 2.5% | 0.58 ± 0.4% | none | 8.49 ± 0.5% | 1.01 | 1.01 | 0.82 | 1.88 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 179.57 ± 5.4% | 181.25 ± 2.1% | 210.05 ± 0.7% | 78.24 ± 2.3% | 189.46 ± 42.1% | 533.99 ± 1.2% | 3805.24 ± 3.2% | 180.31 ± 5.0% | 0.99 | 1.00 | 2.30 | 0.95 |
| a UUID | 62 | 116.32 ± 0.3% | 117.07 ± 1.0% | 129.21 ± 0.4% | 45.09 ± 1.2% | 91.99 ± 1.2% | 193.70 ± 3.4% | 4203.08 ± 0.4% | 116.48 ± 0.1% | 0.99 | 1.00 | 2.58 | 1.26 |
| an IPv4 address | 29 | 394.04 ± 0.4% | 397.74 ± 0.6% | 564.35 ± 0.2% | 66.73 ± 0.7% | 115.45 ± 0.8% | 300.32 ± 4.3% | 6990.02 ± 0.3% | 394.01 ± 0.4% | 0.99 | 1.00 | 5.91 | 3.41 |
| a date and time | 56 | 290.47 ± 0.7% | 291.40 ± 0.6% | 369.80 ± 0.5% | 66.30 ± 1.5% | 124.62 ± 2.0% | 346.69 ± 12.0% | 4315.54 ± 0.4% | 289.48 ± 0.6% | 1.00 | 1.00 | 4.38 | 2.33 |
| a field path | 39 | 170.50 ± 0.3% | 171.11 ± 0.4% | 195.99 ± 0.3% | 71.80 ± 1.9% | 178.46 ± 1.1% | 576.83 ± 7.7% | 4618.16 ± 0.7% | 170.71 ± 1.0% | 1.00 | 1.00 | 2.37 | 0.96 |
| literal: a word | 7 | 596.17 ± 3.3% | 645.96 ± 0.2% | 1169.71 ± 1.1% | 500.39 ± 1.1% | 607.05 ± 2.3% | 1235.94 ± 0.7% | 26932.59 ± 0.3% | 595.79 ± 0.4% | 0.92 | 1.00 | 1.19 | 0.98 |
| literal: a word that is not there | 8 | 577.39 ± 0.3% | 623.86 ± 0.2% | 1099.84 ± 0.1% | 461.17 ± 1.8% | 580.67 ± 2.0% | 1150.77 ± 2.5% | 26266.27 ± 1.4% | 577.18 ± 1.3% | 0.93 | 1.00 | 1.25 | 0.99 |
| literal: one of four words | 26 | 214.83 ± 1.7% | 368.89 ± 1.9% | 499.34 ± 0.6% | 41.61 ± 0.5% | 229.80 ± 1.6% | 459.31 ± 0.4% | 14188.38 ± 0.6% | 215.36 ± 1.8% | 0.58 | 1.00 | 5.16 | 0.93 |
| literal: a word in any case | 11 | 462.63 ± 0.2% | 494.21 ± 0.7% | 757.97 ± 0.6% | 14.34 ± 1.8% | 639.20 ± 4.1% | refused | 19255.70 ± 1.1% | 460.62 ± 0.5% | 0.94 | 1.00 | 32.26 | 0.72 |
| literal: an href attribute | 12 | 316.43 ± 0.5% | 329.06 ± 0.2% | 434.43 ± 0.4% | 39.28 ± 1.3% | 442.70 ± 2.8% | 989.66 ± 1.3% | 18713.40 ± 0.8% | 316.04 ± 0.4% | 0.96 | 1.00 | 8.06 | 0.71 |
| literal: a word, second text | 10 | 533.57 ± 0.4% | 586.18 ± 0.3% | 991.94 ± 0.8% | 415.01 ± 2.0% | 509.88 ± 3.6% | 1040.94 ± 0.7% | 24946.06 ± 1.1% | 534.27 ± 0.5% | 0.91 | 1.00 | 1.29 | 1.05 |
| class: two capitalized words | 23 | 417.30 ± 0.4% | 453.93 ± 1.0% | 660.77 ± 0.4% | 95.37 ± 0.8% | 464.86 ± 1.5% | 997.71 ± 0.7% | 6167.53 ± 0.2% | 417.79 ± 0.4% | 0.92 | 1.00 | 4.38 | 0.90 |
| class: a word that ends in ing | 9 | 518.18 ± 0.5% | 590.97 ± 0.5% | 1033.63 ± 0.4% | 116.98 ± 1.5% | 668.57 ± 3.0% | 1419.01 ± 1.3% | 14993.52 ± 0.6% | 517.69 ± 0.3% | 0.88 | 1.00 | 4.43 | 0.78 |
| class: a word in capitals | 16 | 461.95 ± 0.7% | 506.35 ± 1.1% | 818.00 ± 2.7% | 120.29 ± 2.8% | 692.57 ± 2.3% | 1340.08 ± 0.7% | 8215.61 ± 0.7% | 462.77 ± 0.4% | 0.91 | 1.00 | 3.84 | 0.67 |
| class: a number | 6 | 566.79 ± 0.3% | 637.87 ± 0.1% | 1189.48 ± 0.6% | 36.73 ± 1.3% | 1252.14 ± 2.7% | 2323.72 ± 0.9% | 20150.72 ± 0.8% | 566.20 ± 1.1% | 0.89 | 1.00 | 15.43 | 0.45 |
| class: two capitalized words, second text | 23 | 417.65 ± 0.2% | 453.75 ± 0.3% | 661.94 ± 0.4% | 93.05 ± 15.3% | 467.28 ± 2.6% | 961.32 ± 0.6% | 6163.79 ± 13.0% | 417.96 ± 0.2% | 0.92 | 1.00 | 4.49 | 0.89 |
| other: a word between two words | 13 | 510.76 ± 0.2% | 531.89 ± 0.6% | 840.62 ± 0.7% | 119.22 ± 1.5% | 450.82 ± 1.8% | 982.04 ± 0.3% | 13864.23 ± 0.5% | 510.88 ± 0.3% | 0.96 | 1.00 | 4.28 | 1.13 |
| other: a number before a unit, second text | 15 | 343.19 ± 0.8% | 378.58 ± 7.9% | 517.78 ± 0.3% | 34.03 ± 1.1% | 554.78 ± 2.6% | 1068.18 ± 14.0% | 13756.38 ± 0.4% | 343.41 ± 14.2% | 0.91 | 1.00 | 10.09 | 0.62 |
| other: a heading's start tag | 13 | 328.56 ± 1.5% | 334.58 ± 0.8% | 442.66 ± 0.8% | 37.71 ± 1.4% | 546.30 ± 1.8% | 1111.87 ± 1.5% | 16034.24 ± 1.5% | 328.36 ± 0.2% | 0.98 | 1.00 | 8.71 | 0.60 |
| other: a whole word | 11 | 525.39 ± 0.8% | 556.33 ± 1.5% | 910.14 ± 5.5% | 109.17 ± 13.4% | 520.48 ± 2.0% | 1070.70 ± 1.5% | 24593.98 ± 0.6% | 522.06 ± 1.1% | 0.94 | 1.01 | 4.81 | 1.01 |
| other: a line's first word, second text | 17 | 492.70 ± 0.5% | 515.32 ± 0.3% | 824.21 ± 3.9% | 115.34 ± 2.2% | 621.86 ± 1.4% | refused | refused | 491.64 ± 0.6% | 0.96 | 1.00 | 4.27 | 0.79 |
| other: fourteen octets before an x | 16 | 92.62 ± 6.4% | 137.36 ± 3.5% | 162.04 ± 0.8% | 13.97 ± 1.4% | 404.47 ± 3.5% | 447.57 ± 9.5% | 12186.21 ± 2.7% | 92.88 ± 6.8% | 0.67 | 1.00 | 6.63 | 0.23 |
| other: a Greek word | 8 | 355.14 ± 0.2% | 496.41 ± 0.4% | 778.18 ± 0.9% | 48.81 ± 9.4% | 1232.21 ± 2.9% | 2190.76 ± 1.2% | refused | 355.25 ± 0.1% | 0.72 | 1.00 | 7.28 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21574.78 ± 0.8% | not timed | not timed | 24861.45 ± 0.6% | 2015.82 ± 17.0% | not timed | not timed | 21554.24 ± 0.5% | | 1.00 | 0.87 | 10.70 |
| 01-literal/sherlock-casei-en | 522 | 4968.57 ± 1.7% | not timed | not timed | 7088.16 ± 0.3% | 26.39 ± 0.8% | not timed | not timed | 4883.91 ± 0.9% | | 1.02 | 0.70 | 188.29 |
| 01-literal/sherlock-ru | 724 | 23305.62 ± 0.3% | not timed | not timed | 26433.98 ± 0.5% | 953.47 ± 6.4% | not timed | not timed | 23278.62 ± 0.9% | | 1.00 | 0.88 | 24.44 |
| 01-literal/sherlock-casei-ru | 746 | 6835.46 ± 0.3% | not timed | not timed | 6061.44 ± 0.5% | 28.97 ± 1.2% | not timed | not timed | 6828.64 ± 1.6% | | 1.00 | 1.13 | 235.92 |
| 01-literal/sherlock-zh | 30 | 41231.37 ± 0.3% | not timed | not timed | 33386.68 ± 0.6% | 1275.88 ± 3.4% | not timed | not timed | 41071.93 ± 1.5% | | 1.00 | 1.23 | 32.32 |
| 02-literal-alternate/sherlock-en | 714 | 9880.67 ± 0.4% | not timed | not timed | 8595.53 ± 0.5% | 12.81 ± 0.8% | not timed | not timed | 9863.59 ± 0.2% | | 1.00 | 1.15 | 771.49 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1608.85 ± 1.2% | not timed | not timed | 1775.42 ± 0.8% | 8.76 ± 1.9% | not timed | not timed | 1596.58 ± 0.6% | | 1.01 | 0.91 | 183.75 |
| 02-literal-alternate/sherlock-ru | 899 | 5820.21 ± 0.6% | not timed | not timed | 7689.60 ± 0.8% | 17.20 ± 2.8% | not timed | not timed | 5809.06 ± 1.3% | | 1.00 | 0.76 | 338.38 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1543.90 ± 0.4% | not timed | not timed | 922.80 ± 1.5% | 7.86 ± 0.4% | not timed | not timed | 1562.35 ± 0.2% | | 0.99 | 1.67 | 196.51 |
| 02-literal-alternate/sherlock-zh | 207 | 14182.47 ± 1.9% | not timed | not timed | 10028.43 ± 0.2% | 23.41 ± 0.5% | not timed | not timed | 14188.21 ± 1.9% | | 1.00 | 1.41 | 605.80 |
| 03-date/ascii | 111817 | 99.61 ± 0.8% | not timed | not timed | 76.97 ± 13.8% | 0.18 ± 2.9% | not timed | not timed | 99.03 ± 0.5% | | 1.01 | 1.29 | 543.92 |
| 04-ruff-noqa/real | 84 | 533.36 ± 0.5% | not timed | not timed | 400.19 ± 0.3% | 13.97 ± 1.5% | not timed | not timed | 534.69 ± 0.3% | | 1.00 | 1.33 | 38.19 |
| 04-ruff-noqa/tweaked | 44 | 468.29 ± 0.5% | not timed | not timed | 396.80 ± 1.3% | 267.06 ± 0.5% | not timed | not timed | 472.02 ± 0.7% | | 0.99 | 1.18 | 1.75 |
| 05-lexer-veryl/single | 124800 | 2.91 ± 2.4% | not timed | not timed | 4.06 ± 1.2% | 0.20 ± 4.0% | not timed | not timed | 2.90 ± 3.1% | | 1.00 | 0.72 | 14.32 |
| 06-cloud-flare-redos/original | 107 | 170.74 ± 0.5% | not timed | not timed | 175.14 ± 1.0% | 18.98 ± 1.7% | not timed | not timed | 170.93 ± 1.6% | | 1.00 | 0.97 | 8.99 |
| 06-cloud-flare-redos/simplified-short | 102 | 126.39 ± 4.6% | not timed | not timed | 178.84 ± 4.9% | 20.36 ± 10.1% | not timed | not timed | 126.35 ± 2.4% | | 1.00 | 0.71 | 6.21 |
| 06-cloud-flare-redos/simplified-long | 10000 | 131.70 ± 4.4% | not timed | not timed | 201.51 ± 1.2% | 16.44 ± 33.5% | not timed | not timed | 131.29 ± 5.2% | | 1.00 | 0.65 | 8.01 |
| 07-unicode-character-data/parse-line | 558784 | 191.08 ± 3.0% | not timed | not timed | 157.22 ± 0.3% | 36.04 ± 8.1% | not timed | not timed | 186.79 ± 3.7% | | 1.02 | 1.22 | 5.30 |
| 08-words/all-english | 56691 | 76.46 ± 0.3% | not timed | not timed | 64.82 ± 0.4% | 10.16 ± 4.7% | not timed | not timed | 76.99 ± 1.0% | | 0.99 | 1.18 | 7.52 |
| 08-words/long-english | 839 | 763.67 ± 0.2% | not timed | not timed | 453.38 ± 0.2% | 27.28 ± 13.2% | not timed | not timed | 762.61 ± 0.3% | | 1.00 | 1.68 | 27.99 |
| 09-aws-keys/full | 0 | 404.02 ± 0.4% | not timed | not timed | 428.69 ± 7.8% | 49.45 ± 0.3% | not timed | not timed | 403.50 ± 0.3% | | 1.00 | 0.94 | 8.17 |
| 09-aws-keys/quick | 0 | 749.68 ± 0.6% | not timed | not timed | 747.12 ± 0.9% | 307.56 ± 3.0% | not timed | not timed | 741.38 ± 1.1% | | 1.01 | 1.00 | 2.44 |
| 10-bounded-repeat/letters-en | 1833 | 492.37 ± 2.2% | not timed | not timed | 426.88 ± 0.2% | 16.49 ± 1.6% | not timed | not timed | 490.70 ± 0.3% | | 1.00 | 1.15 | 29.86 |
| 10-bounded-repeat/letters-ru | 3475 | 285.14 ± 0.3% | not timed | not timed | 373.08 ± 1.4% | 19.62 ± 6.4% | not timed | not timed | 284.41 ± 1.6% | | 1.00 | 0.76 | 14.53 |
| 10-bounded-repeat/context | 53 | 60.30 ± 1.1% | not timed | not timed | 54.73 ± 0.6% | 17.55 ± 0.6% | not timed | not timed | 64.70 ± 1.7% | | 0.93 | 1.10 | 3.44 |
| 10-bounded-repeat/capitals | 11 | 806.37 ± 1.4% | not timed | not timed | 469.13 ± 0.2% | 31.27 ± 1.4% | not timed | not timed | 798.85 ± 0.7% | | 1.01 | 1.72 | 25.79 |
| 11-unstructured-to-json/extract | 600 | 35.69 ± 1.0% | not timed | not timed | 62.78 ± 1.7% | 27.32 ± 30.1% | not timed | not timed | 35.74 ± 0.3% | | 1.00 | 0.57 | 1.31 |
| 12-dictionary/single | 1 | 394.19 ± 1.9% | not timed | not timed | 373.99 ± 1.1% | 0.31 ± 5.3% | not timed | not timed | 396.24 ± 0.3% | | 0.99 | 1.05 | 1281.90 |
| 14-quadratic/1x | 100 | 10.34 ± 0.3% | not timed | not timed | 9.44 ± 7.5% | 0.77 ± 2.4% | not timed | not timed | 10.32 ± 1.3% | | 1.00 | 1.09 | 13.48 |
| 14-quadratic/2x | 200 | 6.18 ± 0.2% | not timed | not timed | 4.71 ± 2.0% | 0.42 ± 21.2% | not timed | not timed | 6.20 ± 0.3% | | 1.00 | 1.31 | 14.85 |
| 14-quadratic/10x | 1000 | 1.42 ± 0.2% | not timed | not timed | 0.94 ± 0.2% | 0.09 ± 1.7% | not timed | not timed | 1.42 ± 0.3% | | 1.00 | 1.51 | 15.61 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.32 ± 0.4% | not timed | not timed | 0.37 ± 1.0% | 0.49 ± 6.5% | not timed | not timed | 1.32 ± 1.4% | | 1.00 | 3.59 | 2.72 |
| 04-ruff-noqa/compile-real | 1 | 76.99 ± 11.9% | not timed | not timed | 13.44 ± 3.4% | 128.45 ± 2.0% | not timed | not timed | 74.82 ± 2.2% | | 1.03 | 5.73 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 13.12 ± 5.6% | not timed | not timed | 2.32 ± 0.8% | 6.02 ± 1.5% | not timed | not timed | 12.93 ± 1.1% | | 1.01 | 5.66 | 2.18 |
| 07-unicode-character-data/compile | 1 | 49.57 ± 0.3% | not timed | not timed | 23.78 ± 0.3% | 34.09 ± 3.2% | not timed | not timed | 48.71 ± 22.6% | | 1.02 | 2.08 | 1.45 |
| 09-aws-keys/compile-full | 1 | 34.79 ± 0.7% | not timed | not timed | 7.70 ± 15.2% | 21.34 ± 2.9% | not timed | not timed | 33.82 ± 11.7% | | 1.03 | 4.52 | 1.63 |
| 09-aws-keys/compile-quick | 1 | 154.46 ± 3.5% | not timed | not timed | 45.41 ± 1.1% | 122.11 ± 6.1% | not timed | not timed | 145.75 ± 12.3% | | 1.06 | 3.40 | 1.26 |
| 10-bounded-repeat/compile-context | 1 | 12.28 ± 14.1% | not timed | not timed | 11.24 ± 0.7% | 15.58 ± 4.1% | not timed | not timed | 12.17 ± 0.8% | | 1.01 | 1.09 | 0.79 |
| 10-bounded-repeat/compile-capitals | 1 | 73.77 ± 2.3% | not timed | not timed | 8.07 ± 1.8% | 22.70 ± 2.2% | not timed | not timed | 67.73 ± 1.5% | | 1.09 | 9.14 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 76.44 ± 1.2% | not timed | not timed | 36.90 ± 0.5% | 62.31 ± 2.5% | not timed | not timed | 75.25 ± 1.1% | | 1.02 | 2.07 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.27 ± 0.2% | not timed | not timed | 0.06 ± 1.3% | 0.09 ± 13.6% | not timed | not timed | 0.27 ± 1.8% | | 1.01 | 4.17 | 3.04 |

