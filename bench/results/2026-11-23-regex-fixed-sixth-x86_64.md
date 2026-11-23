# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159268337 |
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
| literal: a word | 217 | 31662.04 ± 0.7% | 1086.19 ± 0.3% | 36.67 ± 0.4% | 31588.65 ± 0.3% | 12702.32 ± 1.4% | 14.78 ± 0.2% | 115.54 ± 0.4% | 31593.90 ± 0.5% | 29.15 | 1.00 | 1.00 | 2.49 |
| literal: a word that is not there | 0 | 41237.61 ± 0.6% | 1097.89 ± 0.1% | 36.70 ± 1.0% | 35048.94 ± 0.2% | 38438.06 ± 0.5% | 14.34 ± 0.5% | 108.66 ± 2.1% | 41262.89 ± 0.3% | 37.56 | 1.00 | 1.18 | 1.07 |
| literal: one of four words | 661 | 12759.89 ± 1.2% | 1064.73 ± 0.5% | 19.09 ± 1.3% | 9401.62 ± 0.4% | 29.22 ± 0.6% | 4.32 ± 0.2% | 9.22 ± 0.7% | 12676.32 ± 0.7% | 11.98 | 1.01 | 1.36 | 436.63 |
| literal: a word in any case | 217 | 26629.66 ± 0.3% | 1087.77 ± 0.3% | 25.62 ± 3.0% | 9734.13 ± 0.2% | 58.47 ± 1.0% | refused | differs | 26522.11 ± 0.3% | 24.48 | 1.00 | 2.74 | 455.47 |
| literal: an href attribute | 33 | 28356.20 ± 0.5% | 1095.48 ± 0.2% | 32.17 ± 1.6% | 29303.48 ± 0.4% | 2605.70 ± 1.9% | 10.59 ± 0.5% | 99.19 ± 0.6% | 28307.23 ± 1.5% | 25.88 | 1.00 | 0.97 | 10.88 |
| literal: a word, second text | 123 | 33862.77 ± 0.6% | 1090.91 ± 0.3% | 35.43 ± 1.6% | 32782.73 ± 2.4% | 9181.15 ± 3.4% | 19.14 ± 0.3% | 96.92 ± 0.2% | 33843.51 ± 1.0% | 31.04 | 1.00 | 1.03 | 3.69 |
| class: two capitalized words | 1331 | 1019.85 ± 1.3% | 1007.93 ± 0.3% | 32.89 ± 1.5% | 611.62 ± 0.6% | 49.10 ± 0.7% | 12.58 ± 0.1% | 82.23 ± 0.5% | 1017.87 ± 0.6% | 1.01 | 1.00 | 1.67 | 20.77 |
| class: a word that ends in ing | 3399 | 920.83 ± 0.2% | 920.18 ± 0.2% | 21.36 ± 1.7% | 575.29 ± 0.4% | 35.42 ± 9.8% | 7.09 ± 0.2% | 22.91 ± 0.4% | 920.33 ± 0.1% | 1.00 | 1.00 | 1.60 | 25.99 |
| class: a word in capitals | 2332 | 1385.99 ± 1.9% | 987.42 ± 0.4% | 34.73 ± 2.0% | 603.60 ± 0.2% | 52.50 ± 13.1% | 15.16 ± 0.6% | 101.43 ± 1.6% | 1381.27 ± 0.4% | 1.40 | 1.00 | 2.30 | 26.40 |
| class: a number | 8288 | 1993.44 ± 0.4% | 859.14 ± 0.3% | 34.49 ± 1.1% | 2111.54 ± 0.3% | 52.51 ± 8.1% | 0.42 ± 0.2% | 70.88 ± 0.5% | 1963.51 ± 1.6% | 2.32 | 1.02 | 0.94 | 37.96 |
| class: two capitalized words, second text | 5359 | 752.55 ± 0.4% | 752.59 ± 0.2% | 29.47 ± 0.7% | 505.68 ± 0.2% | 42.11 ± 12.1% | 16.36 ± 0.2% | 74.77 ± 0.9% | 751.95 ± 0.5% | 1.00 | 1.00 | 1.49 | 17.87 |
| other: a word between two words | 6104 | 833.45 ± 0.4% | 794.36 ± 0.4% | 29.16 ± 1.2% | 874.10 ± 0.3% | 136.43 ± 12.2% | 9.61 ± 0.5% | 85.39 ± 0.4% | 834.31 ± 0.3% | 1.05 | 1.00 | 0.95 | 6.11 |
| other: a number before a unit, second text | 1481 | 9325.29 ± 1.9% | 1021.12 ± 0.1% | 32.85 ± 1.7% | 9576.98 ± 0.2% | 48.91 ± 0.9% | 17.08 ± 0.3% | 79.90 ± 0.5% | 9201.69 ± 0.6% | 9.13 | 1.01 | 0.97 | 190.67 |
| other: a heading's start tag | 110 | 20621.00 ± 0.5% | 1083.35 ± 0.6% | 34.87 ± 1.6% | 2695.44 ± 0.2% | 1901.20 ± 9.1% | 13.17 ± 0.7% | 117.23 ± 0.9% | 20643.70 ± 0.8% | 19.03 | 1.00 | 7.65 | 10.85 |
| other: a whole word | 217 | 24839.02 ± 0.4% | 1085.44 ± 0.2% | 37.02 ± 2.6% | 25416.79 ± 2.4% | 60.33 ± 0.8% | 12.55 ± 0.5% | 67.95 ± 1.7% | 24813.98 ± 0.5% | 22.88 | 1.00 | 0.98 | 411.72 |
| other: a line's first word, second text | 3716 | 2537.58 ± 0.4% | 911.31 ± 0.1% | 37.48 ± 0.7% | 2452.25 ± 0.8% | 81.36 ± 3.0% | refused | refused | 2526.40 ± 0.6% | 2.78 | 1.00 | 1.03 | 31.19 |
| other: fourteen octets before an x | 87 | 34799.83 ± 3.9% | 298.98 ± 0.4% | 7.77 ± 0.4% | 4175.05 ± 0.4% | 11.53 ± 0.3% | differs | 20.13 ± 0.6% | 34889.23 ± 3.9% | 116.40 | 1.00 | 8.34 | 3017.26 |
| other: a Greek word | 21815 | 525.00 ± 0.8% | 403.03 ± 0.2% | 36.72 ± 1.2% | 310.40 ± 1.4% | 63.94 ± 11.4% | differs | refused | 523.03 ± 1.5% | 1.30 | 1.00 | 1.69 | 8.21 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.31 ± 0.9% | 29.39 ± 1.8% | 1.06 ± 2.3% | 21.39 ± 0.8% | 3.20 ± 0.8% | differs | 4.97 ± 0.6% | 29.28 ± 0.8% | 1.00 | 1.00 | 1.37 | 9.15 |
| a UUID | 32895 | 26.36 ± 0.8% | 26.39 ± 0.3% | 0.74 ± 2.9% | 16.43 ± 0.3% | 3.24 ± 0.6% | 0.71 ± 1.1% | 4.08 ± 1.3% | 26.35 ± 0.2% | 1.00 | 1.00 | 1.60 | 8.14 |
| an IPv4 address | 33176 | 38.96 ± 0.6% | 39.01 ± 0.6% | 2.40 ± 0.5% | 31.45 ± 0.2% | 8.05 ± 0.5% | differs | 4.65 ± 1.3% | 38.95 ± 0.6% | 1.00 | 1.00 | 1.24 | 4.84 |
| a date and time | 32954 | 39.04 ± 0.6% | 38.99 ± 0.5% | 1.70 ± 0.3% | 23.75 ± 1.3% | 10.20 ± 1.3% | 1.30 ± 0.2% | 8.98 ± 1.4% | 39.11 ± 0.8% | 1.00 | 1.00 | 1.64 | 3.83 |
| a field path | 32606 | 31.37 ± 1.0% | 31.42 ± 0.9% | 1.23 ± 0.5% | 24.63 ± 0.3% | 3.68 ± 1.6% | differs | 3.08 ± 0.3% | 31.32 ± 1.0% | 1.00 | 1.00 | 1.27 | 8.52 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.29 ± 0.8% | 12.30 ± 0.5% | 12.30 ± 1.0% | 14.56 ± 3.4% | 6.69 ± 2.8% | 1.03 ± 1.5% | none | 12.33 ± 1.1% | 1.00 | 1.00 | 0.84 | 1.84 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 277.29 ± 0.4% | 278.86 ± 0.7% | 321.52 ± 0.4% | 114.45 ± 2.8% | 260.15 ± 1.5% | 687.66 ± 1.1% | 4310.40 ± 1.2% | 276.42 ± 0.6% | 0.99 | 1.00 | 2.42 | 1.07 |
| a UUID | 62 | 177.22 ± 0.4% | 178.03 ± 0.3% | 195.84 ± 0.8% | 61.46 ± 1.3% | 118.04 ± 1.0% | 252.81 ± 1.8% | 5691.22 ± 0.9% | 177.25 ± 0.6% | 1.00 | 1.00 | 2.88 | 1.50 |
| an IPv4 address | 29 | 582.63 ± 1.2% | 589.34 ± 1.0% | 820.54 ± 0.6% | 99.57 ± 0.3% | 156.72 ± 0.9% | 426.96 ± 1.3% | 10124.26 ± 1.2% | 582.39 ± 0.3% | 0.99 | 1.00 | 5.85 | 3.72 |
| a date and time | 56 | 452.22 ± 0.8% | 457.65 ± 1.2% | 575.43 ± 1.2% | 95.87 ± 0.8% | 166.84 ± 3.2% | 438.87 ± 0.7% | 5741.34 ± 0.9% | 452.28 ± 0.4% | 0.99 | 1.00 | 4.72 | 2.71 |
| a field path | 39 | 264.04 ± 0.6% | 265.61 ± 0.3% | 302.26 ± 0.6% | 104.37 ± 1.2% | 249.10 ± 1.5% | 705.25 ± 2.0% | 5535.86 ± 0.4% | 263.91 ± 0.5% | 0.99 | 1.00 | 2.53 | 1.06 |
| literal: a word | 7 | 928.20 ± 0.3% | 1015.56 ± 0.5% | 1820.54 ± 0.5% | 718.92 ± 1.1% | 819.73 ± 0.4% | 1433.65 ± 0.4% | 38651.78 ± 1.5% | 926.73 ± 0.6% | 0.91 | 1.00 | 1.29 | 1.13 |
| literal: a word that is not there | 8 | 892.00 ± 0.2% | 980.97 ± 3.5% | 1720.45 ± 0.5% | 644.04 ± 0.4% | 772.77 ± 8.2% | 1348.75 ± 0.5% | 38022.49 ± 0.2% | 890.29 ± 0.6% | 0.91 | 1.00 | 1.39 | 1.15 |
| literal: one of four words | 26 | 343.71 ± 3.2% | 602.58 ± 1.0% | 827.18 ± 0.7% | 50.49 ± 3.0% | 302.36 ± 18.6% | 498.65 ± 2.2% | 21845.59 ± 4.5% | 343.03 ± 0.5% | 0.57 | 1.00 | 6.81 | 1.14 |
| literal: a word in any case | 11 | 691.10 ± 2.8% | 751.83 ± 0.6% | 1129.25 ± 0.2% | 17.77 ± 0.5% | 852.22 ± 8.4% | refused | 31366.96 ± 0.6% | 689.98 ± 1.0% | 0.92 | 1.00 | 38.90 | 0.81 |
| literal: an href attribute | 12 | 464.37 ± 3.8% | 480.74 ± 0.6% | 627.56 ± 0.5% | 49.99 ± 0.5% | 612.69 ± 2.9% | 1148.78 ± 0.6% | 27644.49 ± 3.8% | 463.92 ± 1.0% | 0.97 | 1.00 | 9.29 | 0.76 |
| literal: a word, second text | 10 | 823.69 ± 0.7% | 929.14 ± 0.9% | 1559.57 ± 0.8% | 596.55 ± 0.5% | 681.57 ± 2.0% | 1171.75 ± 1.0% | 35718.70 ± 1.2% | 826.58 ± 0.5% | 0.89 | 1.00 | 1.38 | 1.21 |
| class: two capitalized words | 23 | 656.30 ± 0.5% | 718.15 ± 0.4% | 1049.68 ± 0.5% | 135.65 ± 3.5% | 635.17 ± 2.4% | 1093.71 ± 3.5% | 7753.42 ± 0.9% | 654.09 ± 0.6% | 0.91 | 1.00 | 4.84 | 1.03 |
| class: a word that ends in ing | 9 | 798.62 ± 0.4% | 915.08 ± 0.5% | 1612.15 ± 3.7% | 172.84 ± 0.6% | 931.67 ± 0.9% | 1656.71 ± 0.9% | 20217.14 ± 1.3% | 796.65 ± 3.5% | 0.87 | 1.00 | 4.62 | 0.86 |
| class: a word in capitals | 16 | 718.00 ± 0.3% | 794.22 ± 0.4% | 1305.36 ± 0.3% | 180.28 ± 3.5% | 934.00 ± 3.1% | 1561.23 ± 0.9% | 10209.15 ± 2.7% | 719.04 ± 1.8% | 0.90 | 1.00 | 3.98 | 0.77 |
| class: a number | 6 | 870.62 ± 0.3% | 985.53 ± 4.0% | 1890.26 ± 0.4% | 43.81 ± 2.3% | 1715.24 ± 7.2% | 2811.34 ± 1.6% | 30223.67 ± 5.5% | 869.72 ± 0.7% | 0.88 | 1.00 | 19.87 | 0.51 |
| class: two capitalized words, second text | 23 | 653.82 ± 0.9% | 716.21 ± 1.6% | 1044.25 ± 4.7% | 134.17 ± 0.8% | 631.46 ± 2.5% | 1104.30 ± 1.2% | 7707.71 ± 1.4% | 652.71 ± 0.5% | 0.91 | 1.00 | 4.87 | 1.04 |
| other: a word between two words | 13 | 791.57 ± 0.5% | 827.15 ± 3.7% | 1319.05 ± 0.8% | 181.54 ± 1.7% | 622.75 ± 5.9% | 1212.89 ± 2.0% | 18503.83 ± 0.4% | 789.72 ± 3.5% | 0.96 | 1.00 | 4.36 | 1.27 |
| other: a number before a unit, second text | 15 | 524.65 ± 0.5% | 584.35 ± 0.9% | 795.04 ± 0.8% | 41.46 ± 0.5% | 781.70 ± 4.0% | 1334.13 ± 1.4% | 19667.60 ± 2.9% | 522.30 ± 1.0% | 0.90 | 1.00 | 12.66 | 0.67 |
| other: a heading's start tag | 13 | 473.79 ± 1.6% | 486.31 ± 0.7% | 635.00 ± 1.4% | 47.70 ± 0.7% | 766.99 ± 0.7% | 1295.22 ± 1.7% | 23337.98 ± 0.6% | 472.77 ± 1.1% | 0.97 | 1.00 | 9.93 | 0.62 |
| other: a whole word | 11 | 830.04 ± 0.5% | 895.99 ± 0.7% | 1482.69 ± 1.6% | 160.89 ± 4.2% | 724.66 ± 7.5% | 1240.65 ± 4.7% | 34117.47 ± 2.8% | 834.44 ± 0.9% | 0.93 | 0.99 | 5.16 | 1.15 |
| other: a line's first word, second text | 17 | 754.38 ± 0.5% | 796.54 ± 1.0% | 1272.13 ± 1.0% | 171.93 ± 0.8% | 876.39 ± 1.2% | refused | refused | 754.72 ± 0.4% | 0.95 | 1.00 | 4.39 | 0.86 |
| other: fourteen octets before an x | 16 | 133.68 ± 0.7% | 194.49 ± 0.6% | 224.68 ± 1.0% | 18.55 ± 1.2% | 551.60 ± 1.9% | 584.62 ± 1.6% | 16528.09 ± 0.7% | 134.06 ± 0.4% | 0.69 | 1.00 | 7.21 | 0.24 |
| other: a Greek word | 8 | 566.70 ± 0.7% | 788.51 ± 0.8% | 1292.74 ± 0.9% | 61.23 ± 0.6% | 1713.09 ± 1.4% | 2706.36 ± 0.4% | refused | 565.31 ± 0.9% | 0.72 | 1.00 | 9.26 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23945.54 ± 0.8% | not timed | not timed | 28314.03 ± 0.9% | 2845.22 ± 8.4% | not timed | not timed | 23910.46 ± 0.7% | | 1.00 | 0.85 | 8.42 |
| 01-literal/sherlock-casei-en | 522 | 7480.59 ± 1.0% | not timed | not timed | 8401.39 ± 0.3% | 39.79 ± 0.9% | not timed | not timed | 7447.49 ± 0.4% | | 1.00 | 0.89 | 187.99 |
| 01-literal/sherlock-ru | 724 | 24904.24 ± 0.8% | not timed | not timed | 28289.20 ± 0.9% | 1589.10 ± 5.6% | not timed | not timed | 24806.01 ± 0.9% | | 1.00 | 0.88 | 15.67 |
| 01-literal/sherlock-casei-ru | 746 | 8226.58 ± 0.7% | not timed | not timed | 6496.05 ± 1.2% | 42.30 ± 1.8% | not timed | not timed | 8223.52 ± 0.9% | | 1.00 | 1.27 | 194.47 |
| 01-literal/sherlock-zh | 30 | 37984.42 ± 1.1% | not timed | not timed | 34763.17 ± 0.9% | 1585.03 ± 1.5% | not timed | not timed | 38014.70 ± 0.9% | | 1.00 | 1.09 | 23.96 |
| 02-literal-alternate/sherlock-en | 714 | 12034.42 ± 1.6% | not timed | not timed | 9376.43 ± 0.4% | 22.26 ± 0.8% | not timed | not timed | 12024.72 ± 0.6% | | 1.00 | 1.28 | 540.60 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2035.48 ± 1.9% | not timed | not timed | 2296.07 ± 1.1% | 13.61 ± 0.5% | not timed | not timed | 2022.51 ± 0.9% | | 1.01 | 0.89 | 149.55 |
| 02-literal-alternate/sherlock-ru | 899 | 6838.33 ± 0.3% | not timed | not timed | 5120.44 ± 0.7% | 28.86 ± 1.6% | not timed | not timed | 6799.81 ± 0.6% | | 1.01 | 1.34 | 236.92 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2152.92 ± 0.5% | not timed | not timed | 1243.65 ± 0.4% | 11.70 ± 0.7% | not timed | not timed | 2145.55 ± 1.0% | | 1.00 | 1.73 | 184.09 |
| 02-literal-alternate/sherlock-zh | 207 | 16505.29 ± 0.3% | not timed | not timed | 10695.21 ± 0.4% | 40.30 ± 0.7% | not timed | not timed | 16483.12 ± 0.4% | | 1.00 | 1.54 | 409.58 |
| 03-date/ascii | 111817 | 127.49 ± 0.6% | not timed | not timed | 109.46 ± 0.6% | 0.27 ± 2.4% | not timed | not timed | 127.32 ± 1.2% | | 1.00 | 1.16 | 480.95 |
| 04-ruff-noqa/real | 84 | 732.73 ± 1.2% | not timed | not timed | 564.91 ± 0.7% | 25.92 ± 1.9% | not timed | not timed | 737.67 ± 0.5% | | 0.99 | 1.30 | 28.26 |
| 04-ruff-noqa/tweaked | 44 | 623.71 ± 0.5% | not timed | not timed | 561.57 ± 0.5% | 372.91 ± 2.9% | not timed | not timed | 620.53 ± 4.7% | | 1.01 | 1.11 | 1.67 |
| 05-lexer-veryl/single | 124800 | 4.39 ± 3.6% | not timed | not timed | 5.34 ± 0.4% | 0.27 ± 9.8% | not timed | not timed | 4.39 ± 2.6% | | 1.00 | 0.82 | 16.02 |
| 06-cloud-flare-redos/original | 107 | 282.18 ± 0.4% | not timed | not timed | 261.07 ± 0.3% | 32.26 ± 0.8% | not timed | not timed | 282.50 ± 0.2% | | 1.00 | 1.08 | 8.75 |
| 06-cloud-flare-redos/simplified-short | 102 | 252.33 ± 0.4% | not timed | not timed | 267.26 ± 0.4% | 35.26 ± 4.2% | not timed | not timed | 252.63 ± 0.3% | | 1.00 | 0.94 | 7.16 |
| 06-cloud-flare-redos/simplified-long | 10000 | 271.15 ± 0.4% | not timed | not timed | 279.58 ± 2.4% | 38.10 ± 0.7% | not timed | not timed | 270.96 ± 0.6% | | 1.00 | 0.97 | 7.12 |
| 07-unicode-character-data/parse-line | 558784 | 269.82 ± 3.6% | not timed | not timed | 207.58 ± 0.5% | 53.62 ± 4.1% | not timed | not timed | 268.80 ± 1.5% | | 1.00 | 1.30 | 5.03 |
| 08-words/all-english | 56691 | 115.42 ± 0.8% | not timed | not timed | 92.76 ± 2.8% | 15.49 ± 8.4% | not timed | not timed | 115.32 ± 0.5% | | 1.00 | 1.24 | 7.45 |
| 08-words/long-english | 839 | 1050.22 ± 0.2% | not timed | not timed | 624.02 ± 0.1% | 37.59 ± 0.5% | not timed | not timed | 1050.28 ± 0.1% | | 1.00 | 1.68 | 27.94 |
| 09-aws-keys/full | 0 | 572.30 ± 1.1% | not timed | not timed | 575.90 ± 0.2% | 83.41 ± 1.6% | not timed | not timed | 571.58 ± 1.2% | | 1.00 | 0.99 | 6.86 |
| 09-aws-keys/quick | 0 | 1120.05 ± 0.2% | not timed | not timed | 910.43 ± 0.3% | 527.18 ± 16.3% | not timed | not timed | 1117.10 ± 0.5% | | 1.00 | 1.23 | 2.12 |
| 10-bounded-repeat/letters-en | 1833 | 627.64 ± 0.6% | not timed | not timed | 550.33 ± 0.3% | 24.13 ± 0.3% | not timed | not timed | 624.10 ± 0.7% | | 1.01 | 1.14 | 26.01 |
| 10-bounded-repeat/letters-ru | 3475 | 390.73 ± 1.6% | not timed | not timed | 491.92 ± 0.9% | 26.27 ± 14.3% | not timed | not timed | 389.12 ± 1.9% | | 1.00 | 0.79 | 14.88 |
| 10-bounded-repeat/context | 53 | 91.47 ± 1.1% | not timed | not timed | 75.07 ± 0.9% | 24.20 ± 1.0% | not timed | not timed | 91.38 ± 0.9% | | 1.00 | 1.22 | 3.78 |
| 10-bounded-repeat/capitals | 11 | 1087.84 ± 0.3% | not timed | not timed | 641.36 ± 0.1% | 44.36 ± 0.6% | not timed | not timed | 1085.45 ± 0.5% | | 1.00 | 1.70 | 24.52 |
| 11-unstructured-to-json/extract | 600 | 49.30 ± 0.1% | not timed | not timed | 81.04 ± 0.3% | 61.38 ± 1.5% | not timed | not timed | 49.23 ± 0.2% | | 1.00 | 0.61 | 0.80 |
| 12-dictionary/single | 1 | 569.75 ± 0.4% | not timed | not timed | 548.85 ± 0.2% | 0.52 ± 0.3% | not timed | not timed | 573.19 ± 0.2% | | 0.99 | 1.04 | 1091.27 |
| 14-quadratic/1x | 100 | 14.06 ± 0.5% | not timed | not timed | 13.49 ± 0.2% | 1.25 ± 0.7% | not timed | not timed | 14.04 ± 0.4% | | 1.00 | 1.04 | 11.21 |
| 14-quadratic/2x | 200 | 8.50 ± 0.2% | not timed | not timed | 6.61 ± 0.1% | 0.69 ± 0.9% | not timed | not timed | 8.48 ± 0.1% | | 1.00 | 1.29 | 12.27 |
| 14-quadratic/10x | 1000 | 1.93 ± 0.1% | not timed | not timed | 1.29 ± 0.1% | 0.15 ± 1.2% | not timed | not timed | 1.93 ± 0.5% | | 1.00 | 1.49 | 12.72 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.05 ± 0.4% | not timed | not timed | 0.45 ± 0.3% | 0.66 ± 2.6% | not timed | not timed | 2.04 ± 0.4% | | 1.00 | 4.54 | 3.10 |
| 04-ruff-noqa/compile-real | 1 | 130.76 ± 0.2% | not timed | not timed | 15.83 ± 0.4% | 175.81 ± 1.4% | not timed | not timed | 130.06 ± 0.8% | | 1.01 | 8.26 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 21.69 ± 0.3% | not timed | not timed | 3.06 ± 0.8% | 7.87 ± 2.6% | not timed | not timed | 21.54 ± 0.4% | | 1.01 | 7.09 | 2.76 |
| 07-unicode-character-data/compile | 1 | 79.37 ± 0.8% | not timed | not timed | 32.57 ± 0.3% | 44.42 ± 1.2% | not timed | not timed | 78.63 ± 1.0% | | 1.01 | 2.44 | 1.79 |
| 09-aws-keys/compile-full | 1 | 53.70 ± 0.4% | not timed | not timed | 9.01 ± 0.7% | 28.28 ± 0.7% | not timed | not timed | 53.67 ± 0.3% | | 1.00 | 5.96 | 1.90 |
| 09-aws-keys/compile-quick | 1 | 241.97 ± 0.4% | not timed | not timed | 59.99 ± 1.0% | 167.63 ± 3.2% | not timed | not timed | 240.82 ± 0.8% | | 1.00 | 4.03 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 16.80 ± 0.3% | not timed | not timed | 14.46 ± 0.4% | 20.92 ± 3.6% | not timed | not timed | 16.67 ± 2.6% | | 1.01 | 1.16 | 0.80 |
| 10-bounded-repeat/compile-capitals | 1 | 103.55 ± 3.7% | not timed | not timed | 10.95 ± 0.4% | 29.84 ± 1.2% | not timed | not timed | 102.80 ± 0.3% | | 1.01 | 9.45 | 3.47 |
| 11-unstructured-to-json/compile | 1 | 120.21 ± 0.7% | not timed | not timed | 50.70 ± 0.6% | 84.32 ± 6.4% | not timed | not timed | 118.62 ± 1.4% | | 1.01 | 2.37 | 1.43 |
| 12-dictionary/compile-single | 1 | 0.38 ± 0.3% | not timed | not timed | 0.08 ± 1.4% | 0.12 ± 14.6% | not timed | not timed | 0.37 ± 0.6% | | 1.01 | 4.53 | 3.16 |

