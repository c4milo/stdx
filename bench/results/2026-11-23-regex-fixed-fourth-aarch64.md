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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159257799 |
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
| literal: a word | 217 | 16012.32 ± 0.8% | 1049.41 ± 0.2% | 28.74 ± 0.4% | 18110.23 ± 1.5% | 9185.81 ± 8.5% | 17.33 ± 0.3% | 86.98 ± 0.6% | 16120.05 ± 1.3% | 15.26 | 0.99 | 0.88 | 1.74 |
| literal: a word that is not there | 0 | 18775.61 ± 1.3% | 1057.84 ± 0.2% | 28.76 ± 0.5% | 19691.34 ± 0.5% | 28421.70 ± 5.2% | 17.08 ± 0.1% | 83.00 ± 0.3% | 18779.85 ± 0.7% | 17.75 | 1.00 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6063.98 ± 0.6% | 1031.67 ± 0.1% | 14.68 ± 0.8% | 3947.48 ± 0.2% | 21.85 ± 0.1% | 5.43 ± 0.3% | 6.92 ± 0.4% | 6066.87 ± 0.3% | 5.88 | 1.00 | 1.54 | 277.56 |
| literal: a word in any case | 217 | 12596.66 ± 0.4% | 1049.04 ± 0.1% | 21.89 ± 0.6% | 3968.10 ± 0.2% | 37.43 ± 1.2% | refused | differs | 12592.38 ± 0.2% | 12.01 | 1.00 | 3.17 | 336.58 |
| literal: an href attribute | 33 | 13579.97 ± 0.7% | 1054.83 ± 0.3% | 27.41 ± 0.3% | 16846.30 ± 1.7% | 2264.55 ± 0.8% | 13.09 ± 0.3% | 75.91 ± 0.4% | 13532.11 ± 0.7% | 12.87 | 1.00 | 0.81 | 6.00 |
| literal: a word, second text | 123 | 16367.73 ± 1.2% | 1050.25 ± 0.3% | 28.15 ± 0.2% | 18414.17 ± 3.1% | 7791.04 ± 6.2% | 20.07 ± 0.7% | 71.12 ± 0.5% | 16436.00 ± 0.6% | 15.58 | 1.00 | 0.89 | 2.10 |
| class: two capitalized words | 1331 | 1124.14 ± 0.3% | 979.54 ± 0.0% | 26.07 ± 0.4% | 585.19 ± 0.1% | 40.60 ± 9.0% | 14.64 ± 0.2% | 68.92 ± 0.7% | 1123.07 ± 0.1% | 1.15 | 1.00 | 1.92 | 27.69 |
| class: a word that ends in ing | 3399 | 902.66 ± 0.2% | 902.53 ± 0.1% | 18.21 ± 0.1% | 547.79 ± 0.1% | 29.60 ± 3.0% | 8.18 ± 0.2% | 18.36 ± 1.1% | 900.88 ± 0.2% | 1.00 | 1.00 | 1.65 | 30.49 |
| class: a word in capitals | 2332 | 1460.70 ± 0.7% | 956.37 ± 0.3% | 27.77 ± 0.4% | 572.64 ± 0.1% | 43.51 ± 2.4% | 17.08 ± 0.2% | 83.36 ± 0.3% | 1462.67 ± 0.8% | 1.53 | 1.00 | 2.55 | 33.57 |
| class: a number | 8288 | 2006.78 ± 0.3% | 839.90 ± 0.1% | 27.94 ± 0.4% | 1719.00 ± 0.2% | 42.14 ± 13.8% | 0.55 ± 0.1% | 56.87 ± 0.4% | 2003.59 ± 0.2% | 2.39 | 1.00 | 1.17 | 47.62 |
| class: two capitalized words, second text | 5359 | 743.83 ± 0.1% | 745.20 ± 0.1% | 23.36 ± 0.1% | 484.88 ± 0.5% | 35.05 ± 11.6% | 17.03 ± 0.9% | 64.11 ± 0.3% | 744.99 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.22 |
| other: a word between two words | 6104 | 753.56 ± 0.1% | 780.75 ± 0.1% | 23.57 ± 0.3% | 737.80 ± 0.2% | 108.86 ± 19.7% | 11.13 ± 0.1% | 70.01 ± 0.2% | 750.85 ± 0.0% | 0.97 | 1.00 | 1.02 | 6.92 |
| other: a number before a unit, second text | 1481 | 5387.04 ± 0.7% | 991.61 ± 0.2% | 26.02 ± 0.3% | 5585.16 ± 0.6% | 40.73 ± 0.2% | 18.21 ± 0.1% | 67.13 ± 0.5% | 5399.56 ± 0.5% | 5.43 | 1.00 | 0.96 | 132.26 |
| other: a heading's start tag | 110 | 12555.82 ± 0.9% | 1044.95 ± 0.2% | 27.53 ± 0.1% | 1712.16 ± 0.2% | 1580.92 ± 3.0% | 16.08 ± 0.3% | 88.99 ± 0.6% | 12559.82 ± 0.2% | 12.02 | 1.00 | 7.33 | 7.94 |
| other: a whole word | 217 | 13930.16 ± 0.7% | 1047.48 ± 0.1% | 29.48 ± 0.2% | 14466.83 ± 1.0% | 49.49 ± 0.2% | 13.20 ± 0.2% | 56.33 ± 0.3% | 14002.78 ± 0.9% | 13.30 | 0.99 | 0.96 | 281.49 |
| other: a line's first word, second text | 3716 | 1972.59 ± 0.4% | 879.31 ± 0.3% | 31.16 ± 0.3% | 1727.33 ± 0.5% | 62.28 ± 6.5% | refused | refused | 1959.34 ± 0.7% | 2.24 | 1.01 | 1.14 | 31.67 |
| other: fourteen octets before an x | 87 | 19922.91 ± 1.0% | 251.03 ± 0.7% | 6.63 ± 0.1% | 4068.42 ± 0.4% | 10.65 ± 0.3% | differs | 17.85 ± 0.7% | 19892.27 ± 1.0% | 79.36 | 1.00 | 4.90 | 1870.43 |
| other: a Greek word | 21815 | 508.66 ± 0.6% | 414.26 ± 0.3% | 31.31 ± 0.2% | 289.43 ± 0.4% | 49.08 ± 9.4% | differs | refused | 511.34 ± 0.4% | 1.23 | 0.99 | 1.76 | 10.36 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.2% | 25.88 ± 0.2% | 0.87 ± 0.2% | 19.86 ± 0.5% | 2.78 ± 0.2% | differs | 4.03 ± 0.4% | 25.90 ± 0.2% | 1.00 | 1.00 | 1.30 | 9.31 |
| a UUID | 32895 | 21.06 ± 0.2% | 21.18 ± 0.2% | 0.65 ± 0.2% | 15.13 ± 0.4% | 3.09 ± 0.8% | 0.72 ± 0.4% | 3.61 ± 0.5% | 21.13 ± 0.2% | 0.99 | 1.00 | 1.39 | 6.81 |
| an IPv4 address | 33176 | 36.96 ± 0.4% | 36.91 ± 0.4% | 2.12 ± 0.2% | 29.45 ± 0.3% | 6.63 ± 0.2% | differs | 4.16 ± 0.3% | 36.98 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.57 |
| a date and time | 32954 | 30.97 ± 0.4% | 30.99 ± 0.5% | 1.47 ± 2.9% | 21.49 ± 1.0% | 7.03 ± 0.3% | 1.24 ± 0.3% | 7.18 ± 0.4% | 30.95 ± 0.5% | 1.00 | 1.00 | 1.44 | 4.40 |
| a field path | 32606 | 29.48 ± 0.2% | 29.44 ± 0.3% | 1.04 ± 0.1% | 23.29 ± 0.3% | 3.49 ± 0.3% | differs | 2.96 ± 0.3% | 29.42 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.3% | 11.48 ± 0.5% | 11.54 ± 0.5% | 11.81 ± 0.1% | 5.01 ± 1.1% | 0.92 ± 0.6% | none | 11.48 ± 0.5% | 1.00 | 1.00 | 0.97 | 2.30 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.35 ± 0.3% | 236.79 ± 0.5% | 287.62 ± 0.1% | 86.74 ± 0.4% | 224.14 ± 0.9% | 491.29 ± 0.2% | 3867.94 ± 1.5% | 235.42 ± 0.3% | 0.99 | 1.00 | 2.71 | 1.05 |
| a UUID | 62 | 157.83 ± 0.4% | 158.17 ± 0.3% | 179.37 ± 0.6% | 45.51 ± 0.2% | 100.24 ± 1.1% | 182.82 ± 0.6% | 4386.83 ± 1.9% | 157.79 ± 0.2% | 1.00 | 1.00 | 3.47 | 1.57 |
| an IPv4 address | 29 | 422.54 ± 0.2% | 427.80 ± 0.4% | 613.71 ± 0.8% | 76.60 ± 1.1% | 132.67 ± 1.9% | 291.81 ± 0.7% | 7615.05 ± 0.4% | 422.04 ± 0.3% | 0.99 | 1.00 | 5.52 | 3.18 |
| a date and time | 56 | 307.44 ± 0.2% | 310.24 ± 0.2% | 396.93 ± 0.2% | 72.38 ± 0.3% | 139.88 ± 1.7% | 321.95 ± 1.0% | 4901.47 ± 0.4% | 307.33 ± 0.3% | 0.99 | 1.00 | 4.25 | 2.20 |
| a field path | 39 | 227.58 ± 0.4% | 229.21 ± 0.2% | 274.65 ± 0.2% | 79.67 ± 0.5% | 209.17 ± 1.3% | 489.84 ± 1.1% | 4916.99 ± 1.8% | 227.55 ± 0.3% | 0.99 | 1.00 | 2.86 | 1.09 |
| literal: a word | 7 | 631.57 ± 0.4% | 675.74 ± 0.2% | 1253.63 ± 0.2% | 507.27 ± 1.8% | 638.26 ± 12.6% | 921.11 ± 0.4% | 29532.15 ± 0.5% | 630.73 ± 0.4% | 0.93 | 1.00 | 1.25 | 0.99 |
| literal: a word that is not there | 8 | 605.41 ± 0.3% | 655.51 ± 0.4% | 1172.56 ± 0.2% | 463.83 ± 0.2% | 609.17 ± 1.5% | 874.77 ± 0.5% | 28520.51 ± 0.1% | 604.76 ± 0.2% | 0.92 | 1.00 | 1.31 | 0.99 |
| literal: one of four words | 26 | 242.29 ± 0.5% | 403.37 ± 0.6% | 562.43 ± 0.4% | 49.40 ± 0.4% | 246.86 ± 2.0% | 360.13 ± 0.6% | 15530.45 ± 0.1% | 242.75 ± 0.5% | 0.60 | 1.00 | 4.90 | 0.98 |
| literal: a word in any case | 11 | 486.36 ± 0.2% | 520.78 ± 0.3% | 839.84 ± 0.4% | 15.75 ± 0.9% | 669.20 ± 2.6% | refused | 23376.10 ± 0.1% | 486.96 ± 0.3% | 0.93 | 1.00 | 30.89 | 0.73 |
| literal: an href attribute | 12 | 350.66 ± 0.5% | 364.36 ± 0.4% | 493.00 ± 0.7% | 44.94 ± 0.4% | 503.06 ± 2.7% | 790.88 ± 1.6% | 21252.94 ± 0.1% | 351.26 ± 0.2% | 0.96 | 1.00 | 7.80 | 0.70 |
| literal: a word, second text | 10 | 567.28 ± 0.5% | 621.64 ± 0.6% | 1071.39 ± 0.7% | 411.50 ± 0.2% | 537.46 ± 3.4% | 809.26 ± 1.0% | 26499.92 ± 0.2% | 567.61 ± 0.1% | 0.91 | 1.00 | 1.38 | 1.06 |
| class: two capitalized words | 23 | 438.67 ± 0.2% | 468.19 ± 5.9% | 699.47 ± 7.8% | 101.30 ± 0.1% | 505.23 ± 5.9% | 754.93 ± 1.5% | 6568.14 ± 0.6% | 438.60 ± 0.5% | 0.94 | 1.00 | 4.33 | 0.87 |
| class: a word that ends in ing | 9 | 567.15 ± 0.3% | 635.50 ± 0.3% | 1158.75 ± 0.4% | 133.24 ± 1.6% | 768.39 ± 1.6% | 1102.51 ± 0.4% | 15866.34 ± 0.7% | 566.75 ± 0.4% | 0.89 | 1.00 | 4.26 | 0.74 |
| class: a word in capitals | 16 | 501.90 ± 0.1% | 539.78 ± 0.3% | 897.79 ± 0.3% | 137.16 ± 1.1% | 763.20 ± 0.8% | 1052.40 ± 0.4% | 8616.90 ± 0.1% | 501.72 ± 0.1% | 0.93 | 1.00 | 3.66 | 0.66 |
| class: a number | 6 | 628.81 ± 0.4% | 694.13 ± 0.2% | 1361.43 ± 0.1% | 41.84 ± 1.2% | 1416.75 ± 1.4% | 1947.07 ± 0.5% | 22475.62 ± 0.1% | 628.69 ± 0.3% | 0.91 | 1.00 | 15.03 | 0.44 |
| class: two capitalized words, second text | 23 | 438.05 ± 0.3% | 467.35 ± 0.5% | 699.25 ± 0.7% | 103.47 ± 0.3% | 508.01 ± 1.0% | 769.17 ± 0.7% | 6573.72 ± 0.1% | 438.19 ± 0.6% | 0.94 | 1.00 | 4.23 | 0.86 |
| other: a word between two words | 13 | 551.70 ± 0.3% | 570.55 ± 0.5% | 936.97 ± 0.2% | 135.63 ± 0.8% | 511.47 ± 8.7% | 818.34 ± 0.4% | 14744.50 ± 0.2% | 550.98 ± 0.1% | 0.97 | 1.00 | 4.07 | 1.08 |
| other: a number before a unit, second text | 15 | 408.33 ± 0.2% | 448.79 ± 0.2% | 649.67 ± 0.2% | 39.58 ± 0.4% | 644.33 ± 1.1% | 895.02 ± 0.2% | 14994.10 ± 0.2% | 408.32 ± 0.2% | 0.91 | 1.00 | 10.32 | 0.63 |
| other: a heading's start tag | 13 | 361.25 ± 0.3% | 367.10 ± 0.3% | 498.60 ± 0.4% | 43.95 ± 1.6% | 637.87 ± 0.6% | 876.66 ± 1.1% | 17843.72 ± 0.3% | 361.11 ± 0.2% | 0.98 | 1.00 | 8.22 | 0.57 |
| other: a whole word | 11 | 586.25 ± 0.7% | 622.20 ± 0.6% | 1079.98 ± 0.1% | 121.79 ± 0.8% | 571.08 ± 1.0% | 829.51 ± 2.2% | 26219.33 ± 0.9% | 586.29 ± 0.5% | 0.94 | 1.00 | 4.81 | 1.03 |
| other: a line's first word, second text | 17 | 538.32 ± 0.2% | 559.78 ± 0.1% | 939.33 ± 0.2% | 128.86 ± 0.3% | 720.22 ± 2.3% | refused | refused | 536.37 ± 0.4% | 0.96 | 1.00 | 4.18 | 0.75 |
| other: fourteen octets before an x | 16 | 112.19 ± 0.4% | 162.73 ± 0.4% | 190.99 ± 0.5% | 15.02 ± 0.5% | 461.61 ± 1.4% | 408.31 ± 1.4% | 12537.04 ± 0.7% | 111.97 ± 0.6% | 0.69 | 1.00 | 7.47 | 0.24 |
| other: a Greek word | 8 | 432.61 ± 0.3% | 593.69 ± 0.2% | 1039.54 ± 0.2% | 58.99 ± 0.5% | 1407.77 ± 0.5% | 1830.70 ± 0.5% | refused | 432.32 ± 0.3% | 0.73 | 1.00 | 7.33 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12924.79 ± 0.9% | not timed | not timed | 16460.68 ± 1.2% | 2109.55 ± 9.5% | not timed | not timed | 12923.98 ± 0.8% | | 1.00 | 0.79 | 6.13 |
| 01-literal/sherlock-casei-en | 522 | 4471.67 ± 1.1% | not timed | not timed | 3597.80 ± 0.2% | 32.57 ± 0.7% | not timed | not timed | 4458.81 ± 1.1% | | 1.00 | 1.24 | 137.29 |
| 01-literal/sherlock-ru | 724 | 13518.68 ± 0.3% | not timed | not timed | 17322.81 ± 0.5% | 1515.33 ± 9.3% | not timed | not timed | 13487.50 ± 0.3% | | 1.00 | 0.78 | 8.92 |
| 01-literal/sherlock-casei-ru | 746 | 5290.78 ± 0.3% | not timed | not timed | 3333.84 ± 0.2% | 31.71 ± 0.3% | not timed | not timed | 5296.09 ± 0.3% | | 1.00 | 1.59 | 166.84 |
| 01-literal/sherlock-zh | 30 | 17114.13 ± 0.5% | not timed | not timed | 18877.16 ± 0.8% | 2536.97 ± 15.6% | not timed | not timed | 17128.76 ± 0.5% | | 1.00 | 0.91 | 6.75 |
| 02-literal-alternate/sherlock-en | 714 | 5746.64 ± 0.3% | not timed | not timed | 3940.46 ± 0.2% | 16.63 ± 0.0% | not timed | not timed | 5772.66 ± 0.1% | | 1.00 | 1.46 | 345.48 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1708.89 ± 1.0% | not timed | not timed | 698.08 ± 0.2% | 11.14 ± 0.2% | not timed | not timed | 1699.92 ± 0.4% | | 1.01 | 2.45 | 153.42 |
| 02-literal-alternate/sherlock-ru | 899 | 4648.83 ± 0.2% | not timed | not timed | 3255.49 ± 0.2% | 22.62 ± 0.2% | not timed | not timed | 4656.16 ± 0.3% | | 1.00 | 1.43 | 205.54 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1810.29 ± 0.6% | not timed | not timed | 1229.79 ± 0.4% | 9.15 ± 0.2% | not timed | not timed | 1803.64 ± 0.3% | | 1.00 | 1.47 | 197.82 |
| 02-literal-alternate/sherlock-zh | 207 | 7029.25 ± 0.5% | not timed | not timed | 4162.68 ± 0.2% | 31.46 ± 0.2% | not timed | not timed | 7031.47 ± 0.7% | | 1.00 | 1.69 | 223.40 |
| 03-date/ascii | 111817 | 126.63 ± 0.6% | not timed | not timed | 95.97 ± 0.1% | 0.20 ± 5.7% | not timed | not timed | 125.43 ± 0.9% | | 1.01 | 1.32 | 622.87 |
| 04-ruff-noqa/real | 84 | 555.67 ± 0.1% | not timed | not timed | 466.88 ± 0.3% | 19.52 ± 0.7% | not timed | not timed | 555.43 ± 0.1% | | 1.00 | 1.19 | 28.47 |
| 04-ruff-noqa/tweaked | 44 | 543.22 ± 0.2% | not timed | not timed | 459.76 ± 0.1% | 367.43 ± 0.3% | not timed | not timed | 542.18 ± 0.4% | | 1.00 | 1.18 | 1.48 |
| 05-lexer-veryl/single | 124800 | 4.26 ± 0.4% | not timed | not timed | 5.24 ± 0.1% | 0.20 ± 2.5% | not timed | not timed | 4.26 ± 2.7% | | 1.00 | 0.81 | 20.78 |
| 06-cloud-flare-redos/original | 107 | 260.34 ± 0.4% | not timed | not timed | 217.54 ± 0.0% | 24.93 ± 0.1% | not timed | not timed | 259.88 ± 0.1% | | 1.00 | 1.20 | 10.44 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.21 ± 0.1% | not timed | not timed | 228.32 ± 0.0% | 26.73 ± 0.1% | not timed | not timed | 254.38 ± 0.1% | | 1.00 | 1.12 | 9.55 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.26 ± 0.1% | not timed | not timed | 255.87 ± 0.2% | 28.83 ± 0.1% | not timed | not timed | 292.30 ± 0.1% | | 1.00 | 1.14 | 10.14 |
| 07-unicode-character-data/parse-line | 558784 | 234.94 ± 0.3% | not timed | not timed | 181.04 ± 0.3% | 42.41 ± 20.1% | not timed | not timed | 229.34 ± 4.0% | | 1.02 | 1.30 | 5.54 |
| 08-words/all-english | 56691 | 121.63 ± 0.4% | not timed | not timed | 83.23 ± 0.1% | 12.38 ± 11.7% | not timed | not timed | 121.58 ± 0.1% | | 1.00 | 1.46 | 9.83 |
| 08-words/long-english | 839 | 1012.30 ± 0.1% | not timed | not timed | 597.59 ± 0.1% | 32.53 ± 0.5% | not timed | not timed | 1011.74 ± 0.3% | | 1.00 | 1.69 | 31.12 |
| 09-aws-keys/full | 0 | 408.81 ± 0.0% | not timed | not timed | 477.35 ± 0.2% | 64.62 ± 3.4% | not timed | not timed | 408.66 ± 0.1% | | 1.00 | 0.86 | 6.33 |
| 09-aws-keys/quick | 0 | 745.73 ± 0.1% | not timed | not timed | 967.56 ± 0.2% | 421.04 ± 0.8% | not timed | not timed | 743.85 ± 0.1% | | 1.00 | 0.77 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 635.62 ± 0.7% | not timed | not timed | 516.08 ± 0.4% | 19.47 ± 0.6% | not timed | not timed | 635.66 ± 0.1% | | 1.00 | 1.23 | 32.64 |
| 10-bounded-repeat/letters-ru | 3475 | 382.85 ± 0.4% | not timed | not timed | 478.55 ± 0.1% | 21.92 ± 8.6% | not timed | not timed | 380.99 ± 0.4% | | 1.00 | 0.80 | 17.47 |
| 10-bounded-repeat/context | 53 | 80.19 ± 1.0% | not timed | not timed | 66.38 ± 0.5% | 19.80 ± 0.2% | not timed | not timed | 79.77 ± 1.2% | | 1.01 | 1.21 | 4.05 |
| 10-bounded-repeat/capitals | 11 | 1055.83 ± 0.1% | not timed | not timed | 615.93 ± 0.1% | 36.18 ± 0.1% | not timed | not timed | 1055.05 ± 0.1% | | 1.00 | 1.71 | 29.18 |
| 11-unstructured-to-json/extract | 600 | 49.35 ± 0.3% | not timed | not timed | 76.84 ± 0.1% | 49.08 ± 0.2% | not timed | not timed | 48.48 ± 0.1% | | 1.02 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 567.09 ± 0.3% | not timed | not timed | 561.71 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 568.75 ± 0.2% | | 1.00 | 1.01 | 1406.15 |
| 14-quadratic/1x | 100 | 12.82 ± 0.7% | not timed | not timed | 10.09 ± 0.3% | 0.98 ± 5.0% | not timed | not timed | 12.75 ± 0.7% | | 1.01 | 1.27 | 13.11 |
| 14-quadratic/2x | 200 | 7.94 ± 0.3% | not timed | not timed | 5.53 ± 0.1% | 0.54 ± 1.8% | not timed | not timed | 7.87 ± 1.0% | | 1.01 | 1.43 | 14.82 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.88 ± 0.2% | | 1.00 | 1.55 | 16.26 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.4% | not timed | not timed | 0.35 ± 0.4% | 0.56 ± 2.3% | not timed | not timed | 1.44 ± 1.0% | | 1.01 | 4.21 | 2.60 |
| 04-ruff-noqa/compile-real | 1 | 92.81 ± 0.3% | not timed | not timed | 13.89 ± 0.5% | 141.12 ± 2.2% | not timed | not timed | 92.94 ± 0.7% | | 1.00 | 6.68 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.68 ± 0.7% | not timed | not timed | 2.54 ± 0.7% | 6.57 ± 3.4% | not timed | not timed | 14.58 ± 1.9% | | 1.01 | 5.78 | 2.23 |
| 07-unicode-character-data/compile | 1 | 58.31 ± 0.3% | not timed | not timed | 26.12 ± 0.2% | 36.27 ± 4.0% | not timed | not timed | 58.39 ± 0.3% | | 1.00 | 2.23 | 1.61 |
| 09-aws-keys/compile-full | 1 | 43.80 ± 0.4% | not timed | not timed | 8.27 ± 0.4% | 23.69 ± 7.2% | not timed | not timed | 43.55 ± 1.1% | | 1.01 | 5.30 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 187.95 ± 0.1% | not timed | not timed | 47.74 ± 0.2% | 133.82 ± 3.3% | not timed | not timed | 189.54 ± 1.3% | | 0.99 | 3.94 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.70 ± 0.5% | not timed | not timed | 11.15 ± 0.4% | 16.39 ± 2.6% | not timed | not timed | 14.64 ± 1.7% | | 1.00 | 1.32 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.97 ± 0.3% | not timed | not timed | 8.10 ± 0.2% | 24.40 ± 3.0% | not timed | not timed | 85.94 ± 0.8% | | 1.00 | 10.61 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 90.91 ± 0.2% | not timed | not timed | 40.82 ± 0.5% | 69.29 ± 2.3% | not timed | not timed | 90.68 ± 1.0% | | 1.00 | 2.23 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 13.5% | 0.09 ± 16.0% | not timed | not timed | 0.36 ± 1.9% | | 1.01 | 5.16 | 3.87 |

