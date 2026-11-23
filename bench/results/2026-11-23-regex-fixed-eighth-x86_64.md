# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159283718 |
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
| literal: a word | 217 | 51962.90 ± 1.6% | 1161.49 ± 18.2% | 43.26 ± 0.7% | 49819.27 ± 7.9% | 15235.14 ± 4.7% | 15.08 ± 1.8% | 149.81 ± 2.9% | 52069.68 ± 1.2% | 44.74 | 1.00 | 1.04 | 3.41 |
| literal: a word that is not there | 0 | 76746.68 ± 4.3% | 1179.57 ± 1.9% | 41.90 ± 0.9% | 61303.96 ± 4.9% | 52690.82 ± 1.8% | 14.72 ± 1.5% | 139.02 ± 1.5% | 77165.06 ± 2.0% | 65.06 | 0.99 | 1.25 | 1.46 |
| literal: one of four words | 661 | 18556.64 ± 3.8% | 1148.78 ± 9.1% | 23.92 ± 38.9% | 13888.34 ± 32.5% | 35.55 ± 146.4% | 4.88 ± 1.5% | 11.83 ± 10.6% | 18553.06 ± 5.3% | 16.15 | 1.00 | 1.34 | 522.01 |
| literal: a word in any case | 217 | 46237.22 ± 1.8% | 1171.56 ± 0.9% | 31.09 ± 2.2% | 13617.37 ± 1.6% | 68.18 ± 1.8% | refused | differs | 45983.30 ± 44.1% | 39.47 | 1.01 | 3.40 | 678.17 |
| literal: an href attribute | 33 | 43702.42 ± 0.7% | 1178.40 ± 0.8% | 35.88 ± 2.2% | 42396.94 ± 3.1% | 3317.04 ± 5.1% | 10.95 ± 1.8% | 120.45 ± 6.0% | 43854.43 ± 1.1% | 37.09 | 1.00 | 1.03 | 13.18 |
| literal: a word, second text | 123 | 52457.91 ± 1.5% | 1180.74 ± 1.2% | 41.19 ± 2.8% | 46181.24 ± 3.1% | 13818.71 ± 6.3% | 20.03 ± 1.3% | 116.74 ± 2.6% | 52544.49 ± 2.2% | 44.43 | 1.00 | 1.14 | 3.80 |
| class: two capitalized words | 1331 | 1082.11 ± 2.7% | 1094.79 ± 0.8% | 38.76 ± 4.8% | 658.84 ± 0.9% | 58.57 ± 4.4% | 13.20 ± 2.4% | 98.00 ± 2.2% | 1074.54 ± 3.2% | 0.99 | 1.01 | 1.64 | 18.48 |
| class: a word that ends in ing | 3399 | 1004.79 ± 1.0% | 1001.81 ± 0.8% | 26.72 ± 0.7% | 617.32 ± 1.5% | 43.22 ± 3.8% | 7.59 ± 2.2% | 28.31 ± 2.8% | 1004.80 ± 0.8% | 1.00 | 1.00 | 1.63 | 23.25 |
| class: a word in capitals | 2332 | 1547.37 ± 1.2% | 1054.40 ± 1.7% | 41.00 ± 1.1% | 648.64 ± 0.6% | 61.95 ± 15.6% | 15.59 ± 2.4% | 129.91 ± 1.3% | 1541.04 ± 1.8% | 1.47 | 1.00 | 2.39 | 24.98 |
| class: a number | 8288 | 2431.58 ± 1.5% | 922.38 ± 1.9% | 39.88 ± 15.0% | 2163.51 ± 4.5% | 52.96 ± 27.4% | 0.44 ± 0.9% | 90.63 ± 0.8% | 2399.07 ± 1.1% | 2.64 | 1.01 | 1.12 | 45.91 |
| class: two capitalized words, second text | 5359 | 811.44 ± 2.1% | 814.73 ± 1.7% | 34.93 ± 1.6% | 543.13 ± 1.2% | 48.81 ± 12.5% | 16.83 ± 2.2% | 83.79 ± 1.1% | 810.20 ± 2.6% | 1.00 | 1.00 | 1.49 | 16.62 |
| other: a word between two words | 6104 | 1015.05 ± 3.9% | 852.92 ± 1.2% | 33.44 ± 4.7% | 924.29 ± 5.0% | 164.48 ± 7.1% | 9.91 ± 2.4% | 106.69 ± 3.2% | 1010.60 ± 4.5% | 1.19 | 1.00 | 1.10 | 6.17 |
| other: a number before a unit, second text | 1481 | 12262.65 ± 1.6% | 1119.49 ± 2.2% | 38.78 ± 8.4% | 9803.92 ± 43.2% | 53.99 ± 78.8% | 17.86 ± 1.5% | 99.92 ± 4.1% | 12073.31 ± 2.0% | 10.95 | 1.02 | 1.25 | 227.11 |
| other: a heading's start tag | 110 | 28233.91 ± 6.0% | 1169.79 ± 11.9% | 39.06 ± 1.5% | 3174.97 ± 29.8% | 2282.56 ± 89.0% | 13.40 ± 35.0% | 146.15 ± 5.3% | 28224.23 ± 7.4% | 24.14 | 1.00 | 8.89 | 12.37 |
| other: a whole word | 217 | 35962.51 ± 2.6% | 1149.96 ± 18.1% | 43.63 ± 3.7% | 34702.42 ± 3.8% | 71.44 ± 7.3% | 12.84 ± 38.1% | 75.77 ± 24.9% | 35612.50 ± 20.4% | 31.27 | 1.01 | 1.04 | 503.37 |
| other: a line's first word, second text | 3716 | 3131.90 ± 2.3% | 975.86 ± 1.8% | 46.89 ± 6.5% | 3323.78 ± 1.2% | 96.90 ± 4.7% | refused | refused | 3191.64 ± 2.7% | 3.21 | 0.98 | 0.94 | 32.32 |
| other: fourteen octets before an x | 87 | 43482.52 ± 2.8% | 312.18 ± 3.8% | 9.14 ± 3.5% | 4705.46 ± 5.9% | 13.87 ± 4.9% | differs | 24.36 ± 3.8% | 43370.30 ± 21.0% | 139.29 | 1.00 | 9.24 | 3134.37 |
| other: a Greek word | 21815 | 570.70 ± 0.9% | 448.31 ± 1.1% | 45.84 ± 1.8% | 343.91 ± 0.6% | 57.80 ± 16.0% | differs | refused | 573.12 ± 0.9% | 1.27 | 1.00 | 1.66 | 9.87 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 33.12 ± 2.4% | 33.33 ± 2.9% | 1.37 ± 15.6% | 22.98 ± 5.2% | 3.42 ± 10.6% | differs | 5.47 ± 5.3% | 33.11 ± 2.1% | 0.99 | 1.00 | 1.44 | 9.69 |
| a UUID | 32895 | 28.27 ± 24.0% | 28.03 ± 67.8% | 0.99 ± 1.1% | 17.55 ± 2.6% | 3.42 ± 4.0% | 0.71 ± 1.6% | 4.40 ± 6.2% | 28.29 ± 2.2% | 1.01 | 1.00 | 1.61 | 8.27 |
| an IPv4 address | 33176 | 45.29 ± 3.3% | 45.26 ± 2.9% | 3.19 ± 3.0% | 33.63 ± 4.4% | 8.65 ± 2.8% | differs | 5.45 ± 1.2% | 45.45 ± 1.8% | 1.00 | 1.00 | 1.35 | 5.23 |
| a date and time | 32954 | 41.87 ± 2.7% | 41.50 ± 2.3% | 2.35 ± 8.3% | 25.04 ± 2.1% | 10.28 ± 2.1% | 1.22 ± 2.5% | 10.37 ± 14.3% | 41.68 ± 3.8% | 1.01 | 1.00 | 1.67 | 4.07 |
| a field path | 32606 | 36.18 ± 26.1% | 36.12 ± 43.7% | 1.69 ± 5.2% | 26.66 ± 51.6% | 4.46 ± 40.1% | differs | 3.88 ± 4.7% | 35.94 ± 2.1% | 1.00 | 1.01 | 1.36 | 8.12 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.75 ± 1.2% | 12.82 ± 1.5% | 12.87 ± 1.6% | 16.63 ± 14.7% | 7.15 ± 8.5% | 1.02 ± 0.9% | none | 12.88 ± 1.8% | 0.99 | 0.99 | 0.77 | 1.78 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 354.99 ± 11.9% | 358.22 ± 1.5% | 415.00 ± 34.3% | 128.05 ± 14.3% | 307.77 ± 62.5% | 831.12 ± 51.4% | 5469.12 ± 5.2% | 355.44 ± 1.4% | 0.99 | 1.00 | 2.77 | 1.15 |
| a UUID | 62 | 231.27 ± 2.6% | 232.80 ± 1.3% | 256.58 ± 0.7% | 71.43 ± 1.7% | 149.19 ± 21.3% | 293.35 ± 2.7% | 6785.87 ± 14.4% | 231.58 ± 3.8% | 0.99 | 1.00 | 3.24 | 1.55 |
| an IPv4 address | 29 | 683.36 ± 1.4% | 693.02 ± 1.8% | 933.60 ± 2.4% | 114.86 ± 0.9% | 195.30 ± 3.6% | 528.03 ± 1.3% | 12125.42 ± 0.7% | 681.48 ± 1.7% | 0.99 | 1.00 | 5.95 | 3.50 |
| a date and time | 56 | 501.40 ± 3.2% | 505.67 ± 3.5% | 614.10 ± 4.1% | 109.29 ± 3.0% | 209.76 ± 2.4% | 542.00 ± 4.5% | 7725.39 ± 1.8% | 502.04 ± 2.1% | 0.99 | 1.00 | 4.59 | 2.39 |
| a field path | 39 | 347.51 ± 14.4% | 353.11 ± 50.2% | 401.10 ± 3.9% | 119.45 ± 3.0% | 294.80 ± 0.8% | 874.16 ± 6.5% | 7234.91 ± 0.9% | 350.14 ± 1.8% | 0.98 | 0.99 | 2.91 | 1.18 |
| literal: a word | 7 | 1084.93 ± 11.4% | 1148.40 ± 1.9% | 1980.41 ± 3.1% | 766.96 ± 2.8% | 973.38 ± 3.3% | 1765.15 ± 14.4% | 45571.57 ± 1.8% | 1090.32 ± 1.3% | 0.94 | 1.00 | 1.41 | 1.11 |
| literal: a word that is not there | 8 | 1052.10 ± 2.5% | 1126.90 ± 3.1% | 1908.14 ± 3.5% | 714.77 ± 1.5% | 940.17 ± 9.6% | 1624.34 ± 28.0% | 43960.81 ± 13.9% | 1046.62 ± 3.6% | 0.93 | 1.01 | 1.47 | 1.12 |
| literal: one of four words | 26 | 404.53 ± 1.1% | 643.98 ± 3.4% | 838.81 ± 1.5% | 63.74 ± 1.4% | 361.58 ± 20.4% | 616.27 ± 1.4% | 27197.41 ± 7.4% | 400.87 ± 2.2% | 0.63 | 1.01 | 6.35 | 1.12 |
| literal: a word in any case | 11 | 830.73 ± 1.9% | 887.54 ± 2.2% | 1306.09 ± 2.1% | 21.99 ± 13.0% | 1013.12 ± 45.7% | refused | 36578.33 ± 3.5% | 826.45 ± 2.9% | 0.94 | 1.01 | 37.79 | 0.82 |
| literal: an href attribute | 12 | 582.20 ± 10.5% | 604.82 ± 1.9% | 781.30 ± 1.4% | 59.08 ± 1.3% | 716.74 ± 3.8% | 1439.23 ± 1.3% | 32827.05 ± 1.2% | 585.27 ± 2.6% | 0.96 | 0.99 | 9.86 | 0.81 |
| literal: a word, second text | 10 | 948.26 ± 1.8% | 1044.45 ± 1.0% | 1676.66 ± 1.5% | 674.13 ± 2.5% | 825.41 ± 1.6% | 1478.44 ± 0.9% | 41637.97 ± 2.2% | 956.76 ± 2.5% | 0.91 | 0.99 | 1.41 | 1.15 |
| class: two capitalized words | 23 | 776.02 ± 44.1% | 830.33 ± 0.7% | 1188.01 ± 1.8% | 150.53 ± 0.8% | 753.81 ± 20.0% | 1352.07 ± 3.7% | 9286.87 ± 3.0% | 771.04 ± 23.9% | 0.93 | 1.01 | 5.16 | 1.03 |
| class: a word that ends in ing | 9 | 956.08 ± 1.1% | 1068.89 ± 12.3% | 1787.85 ± 64.0% | 194.82 ± 9.5% | 1045.11 ± 1.3% | 2067.71 ± 23.2% | 23635.90 ± 29.8% | 956.99 ± 2.1% | 0.89 | 1.00 | 4.91 | 0.91 |
| class: a word in capitals | 16 | 846.86 ± 8.1% | 913.74 ± 1.8% | 1418.80 ± 4.8% | 194.91 ± 3.5% | 1116.74 ± 14.8% | 1921.43 ± 1.6% | 11977.65 ± 13.2% | 851.08 ± 2.3% | 0.93 | 1.00 | 4.34 | 0.76 |
| class: a number | 6 | 1056.19 ± 1.6% | 1158.94 ± 32.5% | 2118.31 ± 6.0% | 56.01 ± 1.4% | 2051.10 ± 4.1% | 3514.65 ± 3.0% | 34646.42 ± 2.1% | 1051.50 ± 1.5% | 0.91 | 1.00 | 18.86 | 0.51 |
| class: two capitalized words, second text | 23 | 761.20 ± 1.7% | 819.87 ± 3.6% | 1173.17 ± 4.1% | 150.29 ± 3.3% | 745.88 ± 10.1% | 1343.24 ± 3.3% | 9067.13 ± 3.0% | 764.35 ± 1.9% | 0.93 | 1.00 | 5.06 | 1.02 |
| other: a word between two words | 13 | 943.73 ± 3.6% | 981.18 ± 3.3% | 1506.09 ± 1.7% | 202.93 ± 0.8% | 736.59 ± 2.9% | 1494.58 ± 1.3% | 22546.32 ± 0.8% | 940.53 ± 1.1% | 0.96 | 1.00 | 4.65 | 1.28 |
| other: a number before a unit, second text | 15 | 656.75 ± 6.6% | 740.67 ± 1.4% | 1014.17 ± 2.2% | 53.76 ± 1.7% | 907.62 ± 4.7% | 1692.43 ± 1.8% | 23285.28 ± 1.1% | 659.96 ± 1.7% | 0.89 | 1.00 | 12.22 | 0.72 |
| other: a heading's start tag | 13 | 598.98 ± 1.8% | 606.43 ± 1.7% | 790.11 ± 2.3% | 56.42 ± 0.9% | 883.20 ± 19.1% | 1594.43 ± 3.7% | 28018.36 ± 0.6% | 600.60 ± 1.8% | 0.99 | 1.00 | 10.62 | 0.68 |
| other: a whole word | 11 | 967.21 ± 1.3% | 1019.78 ± 1.9% | 1615.84 ± 1.8% | 181.37 ± 1.3% | 858.98 ± 1.8% | 1542.07 ± 1.5% | 42352.95 ± 0.4% | 966.81 ± 2.3% | 0.95 | 1.00 | 5.33 | 1.13 |
| other: a line's first word, second text | 17 | 923.10 ± 9.9% | 968.52 ± 58.3% | 1529.44 ± 10.3% | 190.46 ± 0.7% | 1004.35 ± 1.4% | refused | refused | 919.91 ± 1.2% | 0.95 | 1.00 | 4.85 | 0.92 |
| other: fourteen octets before an x | 16 | 175.19 ± 10.1% | 250.00 ± 77.9% | 285.13 ± 65.7% | 21.24 ± 62.3% | 638.94 ± 2.0% | 710.00 ± 1.5% | 20044.54 ± 12.0% | 175.46 ± 1.8% | 0.70 | 1.00 | 8.25 | 0.27 |
| other: a Greek word | 8 | 699.61 ± 1.0% | 927.75 ± 2.1% | 1432.25 ± 25.2% | 71.28 ± 1.1% | 2022.16 ± 2.3% | 3283.67 ± 13.1% | refused | 695.19 ± 2.4% | 0.75 | 1.01 | 9.82 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34386.11 ± 1.6% | not timed | not timed | 41741.70 ± 3.7% | 3436.83 ± 21.4% | not timed | not timed | 34316.88 ± 2.4% | | 1.00 | 0.82 | 10.01 |
| 01-literal/sherlock-casei-en | 522 | 10381.81 ± 1.0% | not timed | not timed | 10990.32 ± 0.8% | 49.74 ± 21.6% | not timed | not timed | 10388.64 ± 4.0% | | 1.00 | 0.94 | 208.73 |
| 01-literal/sherlock-ru | 724 | 35199.65 ± 2.1% | not timed | not timed | 42705.59 ± 1.3% | 2281.17 ± 4.1% | not timed | not timed | 34691.75 ± 2.5% | | 1.01 | 0.82 | 15.43 |
| 01-literal/sherlock-casei-ru | 746 | 10690.84 ± 0.9% | not timed | not timed | 8904.87 ± 1.0% | 53.32 ± 12.5% | not timed | not timed | 10591.58 ± 1.7% | | 1.01 | 1.20 | 200.52 |
| 01-literal/sherlock-zh | 30 | 69679.78 ± 3.0% | not timed | not timed | 55724.44 ± 10.5% | 2020.64 ± 54.0% | not timed | not timed | 69978.76 ± 80.4% | | 1.00 | 1.25 | 34.48 |
| 02-literal-alternate/sherlock-en | 714 | 15415.38 ± 2.0% | not timed | not timed | 12953.16 ± 2.0% | 27.40 ± 12.1% | not timed | not timed | 15456.03 ± 2.1% | | 1.00 | 1.19 | 562.62 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2606.63 ± 1.4% | not timed | not timed | 2831.15 ± 6.5% | 17.09 ± 3.3% | not timed | not timed | 2491.07 ± 43.8% | | 1.05 | 0.92 | 152.56 |
| 02-literal-alternate/sherlock-ru | 899 | 8809.58 ± 7.6% | not timed | not timed | 7280.09 ± 6.3% | 35.90 ± 2.1% | not timed | not timed | 8759.54 ± 1.9% | | 1.01 | 1.21 | 245.39 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2368.24 ± 2.4% | not timed | not timed | 1378.89 ± 2.4% | 15.25 ± 39.4% | not timed | not timed | 2344.36 ± 46.9% | | 1.01 | 1.72 | 155.31 |
| 02-literal-alternate/sherlock-zh | 207 | 21923.72 ± 2.6% | not timed | not timed | 15183.56 ± 0.6% | 50.85 ± 24.0% | not timed | not timed | 22223.27 ± 2.2% | | 0.99 | 1.44 | 431.14 |
| 03-date/ascii | 111817 | 146.66 ± 0.6% | not timed | not timed | 115.22 ± 1.1% | 0.30 ± 2.4% | not timed | not timed | 146.78 ± 0.9% | | 1.00 | 1.27 | 486.94 |
| 04-ruff-noqa/real | 84 | 784.91 ± 7.3% | not timed | not timed | 652.42 ± 2.0% | 29.23 ± 5.1% | not timed | not timed | 808.66 ± 6.0% | | 0.97 | 1.20 | 26.85 |
| 04-ruff-noqa/tweaked | 44 | 751.96 ± 1.3% | not timed | not timed | 661.67 ± 1.1% | 458.23 ± 22.9% | not timed | not timed | 750.57 ± 1.6% | | 1.00 | 1.14 | 1.64 |
| 05-lexer-veryl/single | 124800 | 5.91 ± 2.6% | not timed | not timed | 7.44 ± 1.3% | 0.33 ± 12.3% | not timed | not timed | 5.89 ± 2.9% | | 1.00 | 0.79 | 18.03 |
| 06-cloud-flare-redos/original | 107 | 301.75 ± 8.8% | not timed | not timed | 271.98 ± 16.0% | 37.07 ± 26.4% | not timed | not timed | 291.10 ± 7.1% | | 1.04 | 1.11 | 8.14 |
| 06-cloud-flare-redos/simplified-short | 102 | 292.81 ± 5.4% | not timed | not timed | 284.83 ± 5.9% | 39.56 ± 66.3% | not timed | not timed | 292.61 ± 1.3% | | 1.00 | 1.03 | 7.40 |
| 06-cloud-flare-redos/simplified-long | 10000 | 314.40 ± 2.2% | not timed | not timed | 305.26 ± 5.8% | 42.88 ± 2.1% | not timed | not timed | 314.91 ± 3.6% | | 1.00 | 1.03 | 7.33 |
| 07-unicode-character-data/parse-line | 558784 | 290.04 ± 53.8% | not timed | not timed | 238.80 ± 73.2% | 62.13 ± 6.4% | not timed | not timed | 283.95 ± 12.6% | | 1.02 | 1.21 | 4.67 |
| 08-words/all-english | 56691 | 122.84 ± 0.6% | not timed | not timed | 102.00 ± 1.2% | 17.82 ± 5.7% | not timed | not timed | 127.14 ± 0.6% | | 0.97 | 1.20 | 6.89 |
| 08-words/long-english | 839 | 1113.35 ± 1.8% | not timed | not timed | 662.40 ± 18.4% | 46.42 ± 46.2% | not timed | not timed | 1119.94 ± 2.1% | | 0.99 | 1.68 | 23.98 |
| 09-aws-keys/full | 0 | 631.68 ± 3.7% | not timed | not timed | 672.26 ± 2.1% | 91.74 ± 16.6% | not timed | not timed | 633.28 ± 0.6% | | 1.00 | 0.94 | 6.89 |
| 09-aws-keys/quick | 0 | 1248.48 ± 3.2% | not timed | not timed | 1179.09 ± 1.8% | 524.97 ± 22.1% | not timed | not timed | 1247.09 ± 1.8% | | 1.00 | 1.06 | 2.38 |
| 10-bounded-repeat/letters-en | 1833 | 722.30 ± 0.5% | not timed | not timed | 685.40 ± 0.5% | 28.11 ± 0.7% | not timed | not timed | 728.54 ± 0.5% | | 0.99 | 1.05 | 25.70 |
| 10-bounded-repeat/letters-ru | 3475 | 420.28 ± 58.6% | not timed | not timed | 605.93 ± 2.8% | 29.19 ± 29.6% | not timed | not timed | 418.77 ± 6.4% | | 1.00 | 0.69 | 14.40 |
| 10-bounded-repeat/context | 53 | 105.25 ± 4.2% | not timed | not timed | 87.67 ± 3.2% | 27.99 ± 2.4% | not timed | not timed | 104.57 ± 10.2% | | 1.01 | 1.20 | 3.76 |
| 10-bounded-repeat/capitals | 11 | 1194.38 ± 1.9% | not timed | not timed | 693.03 ± 1.6% | 50.44 ± 2.2% | not timed | not timed | 1192.92 ± 10.3% | | 1.00 | 1.72 | 23.68 |
| 11-unstructured-to-json/extract | 600 | 59.39 ± 3.2% | not timed | not timed | 101.91 ± 1.1% | 73.27 ± 3.1% | not timed | not timed | 60.15 ± 1.4% | | 0.99 | 0.58 | 0.81 |
| 12-dictionary/single | 1 | 626.62 ± 10.8% | not timed | not timed | 604.39 ± 59.5% | 0.61 ± 11.2% | not timed | not timed | 628.45 ± 1.7% | | 1.00 | 1.04 | 1028.49 |
| 14-quadratic/1x | 100 | 15.10 ± 7.1% | not timed | not timed | 16.22 ± 15.7% | 1.37 ± 3.2% | not timed | not timed | 15.18 ± 2.0% | | 1.00 | 0.93 | 11.05 |
| 14-quadratic/2x | 200 | 9.16 ± 1.2% | not timed | not timed | 7.64 ± 1.7% | 0.75 ± 2.2% | not timed | not timed | 9.07 ± 1.2% | | 1.01 | 1.20 | 12.15 |
| 14-quadratic/10x | 1000 | 2.10 ± 21.3% | not timed | not timed | 1.40 ± 40.7% | 0.16 ± 13.5% | not timed | not timed | 2.07 ± 5.8% | | 1.01 | 1.51 | 12.88 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.35 ± 3.7% | not timed | not timed | 0.52 ± 0.6% | 0.81 ± 45.6% | not timed | not timed | 2.34 ± 45.9% | | 1.01 | 4.49 | 2.91 |
| 04-ruff-noqa/compile-real | 1 | 156.87 ± 8.6% | not timed | not timed | 20.38 ± 0.6% | 218.43 ± 1.4% | not timed | not timed | 154.93 ± 10.9% | | 1.01 | 7.70 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 22.56 ± 44.6% | not timed | not timed | 3.75 ± 4.9% | 10.57 ± 51.1% | not timed | not timed | 22.61 ± 54.8% | | 1.00 | 6.01 | 2.13 |
| 07-unicode-character-data/compile | 1 | 90.29 ± 2.4% | not timed | not timed | 39.08 ± 1.6% | 56.93 ± 4.8% | not timed | not timed | 90.27 ± 1.7% | | 1.00 | 2.31 | 1.59 |
| 09-aws-keys/compile-full | 1 | 61.11 ± 63.4% | not timed | not timed | 12.15 ± 3.3% | 35.78 ± 6.4% | not timed | not timed | 61.70 ± 23.2% | | 0.99 | 5.03 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 286.08 ± 23.8% | not timed | not timed | 75.08 ± 48.2% | 209.36 ± 1.7% | not timed | not timed | 286.19 ± 2.5% | | 1.00 | 3.81 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 22.46 ± 1.3% | not timed | not timed | 16.96 ± 18.5% | 25.69 ± 14.9% | not timed | not timed | 22.51 ± 2.2% | | 1.00 | 1.32 | 0.87 |
| 10-bounded-repeat/compile-capitals | 1 | 128.75 ± 31.9% | not timed | not timed | 12.30 ± 1.1% | 37.31 ± 11.5% | not timed | not timed | 128.76 ± 59.8% | | 1.00 | 10.47 | 3.45 |
| 11-unstructured-to-json/compile | 1 | 138.71 ± 1.9% | not timed | not timed | 62.29 ± 1.1% | 109.21 ± 2.8% | not timed | not timed | 138.46 ± 2.0% | | 1.00 | 2.23 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.44 ± 9.8% | not timed | not timed | 0.09 ± 15.1% | 0.14 ± 15.9% | not timed | not timed | 0.43 ± 3.2% | | 1.02 | 4.73 | 3.26 |

