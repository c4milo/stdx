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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127376721 |
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
| literal: a word | 217 | 16191.36 ± 1.5% | 1039.62 ± 0.1% | 28.72 ± 0.2% | 18381.31 ± 1.5% | 9205.88 ± 7.5% | 17.60 ± 0.3% | 86.12 ± 0.1% | 16188.81 ± 1.6% | 15.57 | 1.00 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18761.54 ± 0.7% | 1048.41 ± 0.2% | 28.78 ± 0.7% | 19802.07 ± 1.2% | 29536.10 ± 1.7% | 17.42 ± 0.1% | 81.85 ± 0.2% | 18845.37 ± 1.2% | 17.90 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6074.96 ± 0.3% | 1021.99 ± 0.2% | 14.77 ± 0.2% | 3952.61 ± 0.1% | 21.75 ± 0.2% | 5.30 ± 0.1% | 6.73 ± 0.2% | 6070.12 ± 0.3% | 5.94 | 1.00 | 1.54 | 279.36 |
| literal: a word in any case | 217 | 12607.42 ± 0.3% | 1040.05 ± 0.1% | 22.05 ± 2.3% | 3971.13 ± 0.2% | 37.86 ± 0.4% | refused | differs | 12610.17 ± 0.4% | 12.12 | 1.00 | 3.17 | 332.99 |
| literal: an href attribute | 33 | 13640.34 ± 1.4% | 1046.75 ± 0.3% | 27.44 ± 0.3% | 16916.82 ± 1.8% | 2265.72 ± 0.3% | 13.43 ± 0.4% | 75.39 ± 0.1% | 13619.03 ± 1.7% | 13.03 | 1.00 | 0.81 | 6.02 |
| literal: a word, second text | 123 | 16456.42 ± 0.8% | 1043.92 ± 0.1% | 28.28 ± 0.3% | 18379.93 ± 1.5% | 7814.10 ± 6.3% | 19.70 ± 0.6% | 68.95 ± 0.1% | 16564.86 ± 0.8% | 15.76 | 0.99 | 0.90 | 2.11 |
| class: two capitalized words | 1331 | 1125.54 ± 0.2% | 977.93 ± 0.2% | 26.14 ± 0.4% | 585.40 ± 0.2% | 40.56 ± 2.4% | 14.98 ± 0.2% | 68.46 ± 0.3% | 1127.17 ± 0.6% | 1.15 | 1.00 | 1.92 | 27.75 |
| class: a word that ends in ing | 3399 | 890.16 ± 0.1% | 891.61 ± 0.1% | 18.23 ± 0.2% | 548.03 ± 0.1% | 29.66 ± 9.6% | 8.24 ± 0.1% | 18.24 ± 0.5% | 889.52 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.01 |
| class: a word in capitals | 2332 | 1451.39 ± 0.3% | 950.94 ± 0.0% | 27.77 ± 0.3% | 572.54 ± 0.1% | 43.55 ± 9.1% | 17.23 ± 0.4% | 83.02 ± 0.4% | 1452.10 ± 0.6% | 1.53 | 1.00 | 2.54 | 33.32 |
| class: a number | 8288 | 1995.16 ± 0.3% | 828.09 ± 0.1% | 27.95 ± 0.2% | 1717.41 ± 0.3% | 41.29 ± 13.4% | 0.57 ± 0.2% | 56.75 ± 0.2% | 1989.41 ± 0.1% | 2.41 | 1.00 | 1.16 | 48.33 |
| class: two capitalized words, second text | 5359 | 738.15 ± 0.1% | 737.04 ± 0.0% | 23.45 ± 0.2% | 484.32 ± 0.1% | 35.44 ± 8.3% | 16.70 ± 0.4% | 63.38 ± 1.3% | 737.99 ± 0.1% | 1.00 | 1.00 | 1.52 | 20.83 |
| other: a word between two words | 6104 | 761.01 ± 0.4% | 764.45 ± 0.1% | 23.63 ± 0.1% | 737.52 ± 0.2% | 108.31 ± 19.1% | 11.34 ± 0.3% | 69.17 ± 0.4% | 758.40 ± 0.2% | 1.00 | 1.00 | 1.03 | 7.03 |
| other: a number before a unit, second text | 1481 | 5526.27 ± 0.8% | 983.42 ± 0.1% | 26.07 ± 0.2% | 5667.84 ± 0.1% | 40.82 ± 0.1% | 17.82 ± 0.2% | 66.88 ± 0.3% | 5526.59 ± 0.5% | 5.62 | 1.00 | 0.98 | 135.39 |
| other: a heading's start tag | 110 | 12538.31 ± 0.2% | 1035.90 ± 0.1% | 27.70 ± 0.1% | 1710.87 ± 0.3% | 1583.66 ± 3.5% | 16.37 ± 0.3% | 88.46 ± 0.4% | 12529.71 ± 0.4% | 12.10 | 1.00 | 7.33 | 7.92 |
| other: a whole word | 217 | 13952.56 ± 1.2% | 1038.59 ± 0.2% | 29.93 ± 0.3% | 14554.63 ± 1.2% | 49.31 ± 0.2% | 13.74 ± 0.2% | 55.61 ± 0.3% | 13923.22 ± 1.5% | 13.43 | 1.00 | 0.96 | 282.93 |
| other: a line's first word, second text | 3716 | 1956.47 ± 0.3% | 873.26 ± 0.1% | 31.37 ± 0.3% | 1730.58 ± 0.5% | 62.28 ± 7.3% | refused | refused | 1942.78 ± 0.3% | 2.24 | 1.01 | 1.13 | 31.41 |
| other: fourteen octets before an x | 87 | 19995.47 ± 1.3% | 232.34 ± 0.6% | 6.15 ± 0.1% | 4000.28 ± 0.5% | 10.46 ± 0.4% | differs | 17.70 ± 0.2% | 20087.32 ± 1.3% | 86.06 | 1.00 | 5.00 | 1910.91 |
| other: a Greek word | 21815 | 470.12 ± 0.8% | 358.52 ± 0.1% | 31.18 ± 0.2% | 289.62 ± 0.2% | 47.62 ± 8.2% | differs | refused | 468.17 ± 0.6% | 1.31 | 1.00 | 1.62 | 9.87 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.2% | 25.86 ± 0.2% | 0.82 ± 0.4% | 19.69 ± 0.3% | 2.78 ± 0.6% | differs | 4.03 ± 0.3% | 25.91 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.31 |
| a UUID | 32895 | 21.07 ± 0.4% | 21.17 ± 0.3% | 0.65 ± 0.1% | 15.13 ± 0.6% | 3.11 ± 0.9% | 0.72 ± 0.1% | 3.61 ± 0.7% | 21.12 ± 0.5% | 0.99 | 1.00 | 1.39 | 6.78 |
| an IPv4 address | 33176 | 36.99 ± 0.1% | 36.90 ± 0.1% | 2.09 ± 0.3% | 29.01 ± 0.4% | 6.66 ± 0.1% | differs | 4.14 ± 0.3% | 36.98 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.55 |
| a date and time | 32954 | 31.11 ± 0.3% | 31.09 ± 0.3% | 1.42 ± 0.1% | 21.10 ± 0.6% | 7.05 ± 0.2% | 1.19 ± 0.2% | 7.04 ± 0.2% | 31.09 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.54 ± 0.5% | 29.48 ± 0.1% | 1.01 ± 0.3% | 22.95 ± 0.2% | 3.53 ± 0.3% | differs | 2.92 ± 0.2% | 29.51 ± 0.2% | 1.00 | 1.00 | 1.29 | 8.38 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.84 ± 0.5% | 10.80 ± 0.6% | 10.84 ± 0.5% | 11.45 ± 0.1% | 4.92 ± 2.1% | 0.91 ± 0.4% | none | 10.80 ± 0.3% | 1.00 | 1.00 | 0.95 | 2.20 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.44 ± 0.3% | 217.94 ± 0.3% | 252.74 ± 0.1% | 87.49 ± 0.2% | 220.93 ± 1.8% | 486.00 ± 0.3% | 3764.89 ± 0.8% | 217.35 ± 0.2% | 1.00 | 1.00 | 2.49 | 0.98 |
| a UUID | 62 | 142.76 ± 0.3% | 143.19 ± 0.2% | 157.60 ± 0.1% | 45.94 ± 0.2% | 99.24 ± 1.8% | 185.53 ± 0.7% | 4480.26 ± 0.3% | 142.72 ± 0.3% | 1.00 | 1.00 | 3.11 | 1.44 |
| an IPv4 address | 29 | 439.85 ± 0.3% | 443.65 ± 0.6% | 614.39 ± 0.6% | 77.15 ± 0.8% | 132.34 ± 1.4% | 295.08 ± 0.3% | 7715.29 ± 0.6% | 440.24 ± 0.7% | 0.99 | 1.00 | 5.70 | 3.32 |
| a date and time | 56 | 318.94 ± 0.1% | 320.54 ± 0.3% | 401.82 ± 0.2% | 72.59 ± 0.2% | 136.46 ± 2.3% | 323.31 ± 1.2% | 4987.88 ± 0.1% | 319.11 ± 0.3% | 1.00 | 1.00 | 4.39 | 2.34 |
| a field path | 39 | 202.53 ± 0.2% | 203.46 ± 0.2% | 233.19 ± 0.3% | 80.37 ± 0.5% | 204.90 ± 1.7% | 484.29 ± 0.8% | 4856.09 ± 3.6% | 202.80 ± 0.3% | 1.00 | 1.00 | 2.52 | 0.99 |
| literal: a word | 7 | 669.02 ± 0.3% | 721.34 ± 0.3% | 1292.55 ± 0.2% | 518.59 ± 1.5% | 624.34 ± 1.8% | 918.55 ± 0.5% | 30926.96 ± 0.2% | 668.51 ± 0.3% | 0.93 | 1.00 | 1.29 | 1.07 |
| literal: a word that is not there | 8 | 640.21 ± 0.2% | 696.45 ± 0.4% | 1219.64 ± 0.1% | 473.18 ± 0.1% | 596.28 ± 1.2% | 871.60 ± 0.4% | 29445.74 ± 0.5% | 639.88 ± 0.3% | 0.92 | 1.00 | 1.35 | 1.07 |
| literal: one of four words | 26 | 256.91 ± 0.2% | 422.38 ± 0.5% | 570.80 ± 0.5% | 49.65 ± 0.3% | 241.57 ± 2.8% | 355.53 ± 0.5% | 15707.58 ± 0.3% | 256.80 ± 0.3% | 0.61 | 1.00 | 5.17 | 1.06 |
| literal: a word in any case | 11 | 524.82 ± 0.4% | 568.34 ± 0.5% | 875.59 ± 0.3% | 15.85 ± 1.0% | 648.76 ± 2.0% | refused | 23632.98 ± 0.5% | 524.48 ± 0.1% | 0.92 | 1.00 | 33.10 | 0.81 |
| literal: an href attribute | 12 | 350.28 ± 0.5% | 362.14 ± 0.2% | 472.13 ± 0.5% | 45.34 ± 0.5% | 498.58 ± 9.3% | 770.73 ± 1.9% | 22077.59 ± 0.3% | 350.67 ± 0.3% | 0.97 | 1.00 | 7.73 | 0.70 |
| literal: a word, second text | 10 | 596.05 ± 0.2% | 657.60 ± 0.4% | 1103.04 ± 0.2% | 421.55 ± 0.5% | 530.74 ± 1.9% | 798.96 ± 0.7% | 27258.89 ± 0.2% | 596.70 ± 0.2% | 0.91 | 1.00 | 1.41 | 1.12 |
| class: two capitalized words | 23 | 460.47 ± 0.2% | 491.01 ± 0.2% | 711.58 ± 0.6% | 101.89 ± 0.2% | 501.97 ± 9.9% | 743.39 ± 1.2% | 6370.25 ± 0.2% | 460.95 ± 0.4% | 0.94 | 1.00 | 4.52 | 0.92 |
| class: a word that ends in ing | 9 | 600.19 ± 0.2% | 668.15 ± 0.5% | 1178.60 ± 0.3% | 133.59 ± 0.8% | 752.69 ± 1.2% | 1089.40 ± 2.0% | 15931.82 ± 0.1% | 599.61 ± 0.2% | 0.90 | 1.00 | 4.49 | 0.80 |
| class: a word in capitals | 16 | 521.21 ± 0.4% | 561.53 ± 0.3% | 886.17 ± 0.5% | 136.69 ± 0.5% | 748.07 ± 1.5% | 1005.57 ± 0.8% | 8376.36 ± 0.1% | 520.79 ± 0.8% | 0.93 | 1.00 | 3.81 | 0.70 |
| class: a number | 6 | 659.48 ± 0.4% | 722.77 ± 0.3% | 1336.64 ± 0.1% | 42.17 ± 0.4% | 1386.38 ± 1.1% | 1908.79 ± 0.5% | 22795.15 ± 0.2% | 660.42 ± 0.2% | 0.91 | 1.00 | 15.64 | 0.48 |
| class: two capitalized words, second text | 23 | 460.10 ± 0.2% | 490.98 ± 0.3% | 711.59 ± 0.2% | 103.68 ± 0.2% | 501.83 ± 0.8% | 747.53 ± 1.4% | 6372.70 ± 0.1% | 460.55 ± 0.2% | 0.94 | 1.00 | 4.44 | 0.92 |
| other: a word between two words | 13 | 583.30 ± 0.4% | 604.40 ± 0.2% | 963.75 ± 0.6% | 136.80 ± 0.4% | 498.61 ± 0.6% | 810.63 ± 0.3% | 14762.25 ± 0.2% | 583.10 ± 0.3% | 0.97 | 1.00 | 4.26 | 1.17 |
| other: a number before a unit, second text | 15 | 401.78 ± 0.3% | 437.44 ± 0.2% | 599.52 ± 0.1% | 39.50 ± 0.7% | 629.61 ± 1.9% | 890.06 ± 0.4% | 15289.75 ± 0.1% | 401.95 ± 0.4% | 0.92 | 1.00 | 10.17 | 0.64 |
| other: a heading's start tag | 13 | 361.50 ± 0.6% | 366.74 ± 0.3% | 477.49 ± 0.7% | 43.75 ± 0.1% | 621.86 ± 0.9% | 859.18 ± 0.1% | 18374.61 ± 0.2% | 361.87 ± 0.5% | 0.99 | 1.00 | 8.26 | 0.58 |
| other: a whole word | 11 | 619.56 ± 0.1% | 658.78 ± 0.4% | 1100.77 ± 0.1% | 121.00 ± 0.4% | 562.60 ± 1.5% | 823.66 ± 0.8% | 26899.21 ± 1.6% | 619.31 ± 0.2% | 0.94 | 1.00 | 5.12 | 1.10 |
| other: a line's first word, second text | 17 | 557.71 ± 0.3% | 579.94 ± 0.3% | 929.22 ± 0.1% | 129.64 ± 0.2% | 705.90 ± 0.7% | refused | refused | 556.31 ± 0.5% | 0.96 | 1.00 | 4.30 | 0.79 |
| other: fourteen octets before an x | 16 | 112.67 ± 0.5% | 162.52 ± 0.3% | 185.50 ± 0.5% | 15.23 ± 0.3% | 453.88 ± 1.6% | 430.14 ± 1.0% | 13018.61 ± 0.3% | 112.69 ± 0.2% | 0.69 | 1.00 | 7.40 | 0.25 |
| other: a Greek word | 8 | 450.61 ± 0.2% | 591.77 ± 0.5% | 965.43 ± 0.1% | 58.87 ± 0.4% | 1375.29 ± 0.3% | 1804.22 ± 0.5% | refused | 450.47 ± 0.2% | 0.76 | 1.00 | 7.65 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12837.25 ± 0.9% | not timed | not timed | 16380.35 ± 1.4% | 2101.63 ± 16.4% | not timed | not timed | 12907.09 ± 1.5% | | 0.99 | 0.78 | 6.11 |
| 01-literal/sherlock-casei-en | 522 | 3886.31 ± 0.4% | not timed | not timed | 3591.17 ± 0.2% | 32.50 ± 0.4% | not timed | not timed | 3881.45 ± 0.4% | | 1.00 | 1.08 | 119.57 |
| 01-literal/sherlock-ru | 724 | 13608.85 ± 9.7% | not timed | not timed | 17309.42 ± 3.6% | 1324.24 ± 19.9% | not timed | not timed | 13555.17 ± 10.1% | | 1.00 | 0.79 | 10.28 |
| 01-literal/sherlock-casei-ru | 746 | 5248.50 ± 0.1% | not timed | not timed | 3322.33 ± 0.1% | 31.57 ± 0.6% | not timed | not timed | 5257.80 ± 0.0% | | 1.00 | 1.58 | 166.27 |
| 01-literal/sherlock-zh | 30 | 16997.00 ± 0.4% | not timed | not timed | 18652.29 ± 0.7% | 2678.16 ± 8.7% | not timed | not timed | 16981.10 ± 0.4% | | 1.00 | 0.91 | 6.35 |
| 02-literal-alternate/sherlock-en | 714 | 5826.01 ± 0.2% | not timed | not timed | 3946.26 ± 0.2% | 16.59 ± 0.1% | not timed | not timed | 5820.23 ± 0.2% | | 1.00 | 1.48 | 351.13 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1670.53 ± 0.8% | not timed | not timed | 698.11 ± 0.2% | 11.12 ± 0.3% | not timed | not timed | 1663.44 ± 0.2% | | 1.00 | 2.39 | 150.30 |
| 02-literal-alternate/sherlock-ru | 899 | 4614.77 ± 0.2% | not timed | not timed | 3259.64 ± 0.1% | 22.63 ± 3.9% | not timed | not timed | 4643.07 ± 0.3% | | 0.99 | 1.42 | 203.95 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1778.24 ± 0.5% | not timed | not timed | 1233.77 ± 0.1% | 9.15 ± 0.2% | not timed | not timed | 1774.13 ± 0.3% | | 1.00 | 1.44 | 194.32 |
| 02-literal-alternate/sherlock-zh | 207 | 7070.52 ± 0.3% | not timed | not timed | 4165.80 ± 0.6% | 30.95 ± 0.3% | not timed | not timed | 7066.46 ± 0.1% | | 1.00 | 1.70 | 228.42 |
| 03-date/ascii | 111817 | 124.97 ± 0.5% | not timed | not timed | 95.92 ± 0.0% | 0.21 ± 5.8% | not timed | not timed | 124.23 ± 0.2% | | 1.01 | 1.30 | 603.31 |
| 04-ruff-noqa/real | 84 | 554.20 ± 0.1% | not timed | not timed | 457.92 ± 0.1% | 19.55 ± 2.8% | not timed | not timed | 553.89 ± 0.1% | | 1.00 | 1.21 | 28.35 |
| 04-ruff-noqa/tweaked | 44 | 546.51 ± 0.3% | not timed | not timed | 461.98 ± 0.0% | 364.28 ± 1.0% | not timed | not timed | 544.03 ± 0.2% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.68 ± 0.5% | not timed | not timed | 5.01 ± 0.2% | 0.20 ± 4.0% | not timed | not timed | 3.70 ± 2.6% | | 1.00 | 0.73 | 18.11 |
| 06-cloud-flare-redos/original | 107 | 270.60 ± 0.3% | not timed | not timed | 217.63 ± 0.0% | 24.91 ± 0.1% | not timed | not timed | 269.82 ± 0.4% | | 1.00 | 1.24 | 10.86 |
| 06-cloud-flare-redos/simplified-short | 102 | 265.38 ± 0.8% | not timed | not timed | 228.54 ± 0.6% | 26.78 ± 0.2% | not timed | not timed | 264.85 ± 0.8% | | 1.00 | 1.16 | 9.91 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.35 ± 0.2% | not timed | not timed | 255.80 ± 0.3% | 28.78 ± 0.2% | not timed | not timed | 294.26 ± 0.1% | | 1.00 | 1.15 | 10.23 |
| 07-unicode-character-data/parse-line | 558784 | 242.55 ± 1.1% | not timed | not timed | 166.94 ± 0.2% | 42.24 ± 5.8% | not timed | not timed | 239.51 ± 2.4% | | 1.01 | 1.45 | 5.74 |
| 08-words/all-english | 56691 | 119.67 ± 0.9% | not timed | not timed | 81.34 ± 0.2% | 12.64 ± 11.0% | not timed | not timed | 119.59 ± 0.4% | | 1.00 | 1.47 | 9.47 |
| 08-words/long-english | 839 | 1006.29 ± 0.1% | not timed | not timed | 595.60 ± 0.0% | 32.53 ± 0.3% | not timed | not timed | 1005.83 ± 0.3% | | 1.00 | 1.69 | 30.93 |
| 09-aws-keys/full | 0 | 412.48 ± 0.1% | not timed | not timed | 462.53 ± 0.1% | 64.60 ± 1.2% | not timed | not timed | 412.53 ± 0.1% | | 1.00 | 0.89 | 6.39 |
| 09-aws-keys/quick | 0 | 733.86 ± 0.2% | not timed | not timed | 991.24 ± 0.1% | 420.11 ± 0.6% | not timed | not timed | 730.41 ± 0.1% | | 1.00 | 0.74 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 634.95 ± 0.6% | not timed | not timed | 516.73 ± 0.9% | 19.56 ± 0.7% | not timed | not timed | 635.13 ± 0.2% | | 1.00 | 1.23 | 32.46 |
| 10-bounded-repeat/letters-ru | 3475 | 380.83 ± 0.2% | not timed | not timed | 478.32 ± 0.2% | 21.96 ± 11.1% | not timed | not timed | 379.61 ± 0.5% | | 1.00 | 0.80 | 17.34 |
| 10-bounded-repeat/context | 53 | 78.89 ± 1.0% | not timed | not timed | 65.87 ± 0.3% | 19.81 ± 0.2% | not timed | not timed | 79.29 ± 0.9% | | 0.99 | 1.20 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 1045.79 ± 0.1% | not timed | not timed | 615.73 ± 0.0% | 36.62 ± 0.2% | not timed | not timed | 1045.45 ± 0.1% | | 1.00 | 1.70 | 28.56 |
| 11-unstructured-to-json/extract | 600 | 48.27 ± 0.1% | not timed | not timed | 77.89 ± 0.4% | 48.95 ± 2.7% | not timed | not timed | 47.13 ± 0.9% | | 1.02 | 0.62 | 0.99 |
| 12-dictionary/single | 1 | 573.11 ± 0.2% | not timed | not timed | 561.26 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 571.32 ± 0.1% | | 1.00 | 1.02 | 1398.74 |
| 14-quadratic/1x | 100 | 13.07 ± 0.4% | not timed | not timed | 10.04 ± 0.2% | 0.96 ± 3.2% | not timed | not timed | 12.98 ± 1.2% | | 1.01 | 1.30 | 13.64 |
| 14-quadratic/2x | 200 | 7.99 ± 0.3% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 0.9% | not timed | not timed | 7.96 ± 1.4% | | 1.00 | 1.44 | 15.02 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.6% | not timed | not timed | 1.85 ± 0.4% | | 1.00 | 1.54 | 16.04 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.2% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 5.0% | not timed | not timed | 1.53 ± 1.4% | | 1.01 | 4.49 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 85.60 ± 0.2% | not timed | not timed | 13.82 ± 0.5% | 139.27 ± 2.7% | not timed | not timed | 85.36 ± 0.5% | | 1.00 | 6.19 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.51 ± 0.2% | not timed | not timed | 2.52 ± 0.9% | 6.49 ± 1.5% | not timed | not timed | 14.32 ± 1.4% | | 1.01 | 5.76 | 2.24 |
| 07-unicode-character-data/compile | 1 | 54.93 ± 0.3% | not timed | not timed | 25.96 ± 0.3% | 36.09 ± 2.7% | not timed | not timed | 54.48 ± 1.3% | | 1.01 | 2.12 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.18 ± 0.2% | not timed | not timed | 8.30 ± 0.5% | 23.33 ± 2.9% | not timed | not timed | 42.04 ± 0.3% | | 1.00 | 5.08 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 189.00 ± 0.2% | not timed | not timed | 47.61 ± 0.1% | 132.09 ± 3.2% | not timed | not timed | 189.43 ± 0.3% | | 1.00 | 3.97 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.54 ± 1.2% | not timed | not timed | 11.35 ± 0.3% | 16.00 ± 3.2% | not timed | not timed | 14.49 ± 1.3% | | 1.00 | 1.28 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.18 ± 0.5% | not timed | not timed | 8.19 ± 0.2% | 24.02 ± 2.1% | not timed | not timed | 85.01 ± 0.3% | | 1.00 | 10.40 | 3.55 |
| 11-unstructured-to-json/compile | 1 | 86.48 ± 0.2% | not timed | not timed | 40.68 ± 0.1% | 68.04 ± 1.8% | not timed | not timed | 86.16 ± 0.6% | | 1.00 | 2.13 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 1.8% | not timed | not timed | 0.07 ± 8.5% | 0.10 ± 6.3% | not timed | not timed | 0.36 ± 2.1% | | 1.01 | 5.23 | 3.76 |

