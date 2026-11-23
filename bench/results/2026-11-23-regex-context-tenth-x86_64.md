# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117674709 |
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
| literal: a word | 217 | 32344.36 ± 0.5% | 1088.57 ± 0.4% | 32.97 ± 0.3% | 32781.46 ± 0.3% | 12703.13 ± 4.3% | 14.88 ± 0.1% | 107.88 ± 0.9% | 32315.77 ± 0.2% | 29.71 | 1.00 | 0.99 | 2.55 |
| literal: a word that is not there | 0 | 42600.84 ± 0.9% | 1100.24 ± 0.2% | 32.77 ± 1.5% | 36310.62 ± 0.4% | 40177.40 ± 1.0% | 14.36 ± 0.5% | 102.92 ± 1.3% | 42633.59 ± 0.9% | 38.72 | 1.00 | 1.17 | 1.06 |
| literal: one of four words | 661 | 13479.78 ± 52.5% | 1063.51 ± 4.3% | 18.60 ± 82.7% | 9646.24 ± 31.6% | 29.09 ± 89.1% | 4.31 ± 4.3% | 7.95 ± 0.8% | 13351.85 ± 0.3% | 12.67 | 1.01 | 1.40 | 463.33 |
| literal: a word in any case | 217 | 27800.85 ± 0.3% | 1088.70 ± 0.1% | 24.47 ± 1.9% | 10067.76 ± 0.4% | 58.18 ± 0.6% | refused | differs | 27724.36 ± 0.4% | 25.54 | 1.00 | 2.76 | 477.81 |
| literal: an href attribute | 33 | 28335.68 ± 0.3% | 1093.56 ± 0.2% | 30.27 ± 1.4% | 29318.30 ± 0.4% | 2596.99 ± 1.8% | 10.56 ± 0.3% | 98.64 ± 1.4% | 28247.49 ± 1.2% | 25.91 | 1.00 | 0.97 | 10.91 |
| literal: a word, second text | 123 | 33998.25 ± 0.6% | 1092.28 ± 0.2% | 32.34 ± 0.4% | 32682.66 ± 0.2% | 9127.56 ± 1.7% | 19.35 ± 1.2% | 98.97 ± 0.5% | 33934.42 ± 0.5% | 31.13 | 1.00 | 1.04 | 3.72 |
| class: two capitalized words | 1331 | 1009.46 ± 0.4% | 998.82 ± 0.2% | 30.42 ± 1.5% | 610.89 ± 0.2% | 48.71 ± 0.4% | 12.62 ± 0.3% | 79.82 ± 0.4% | 1008.69 ± 0.6% | 1.01 | 1.00 | 1.65 | 20.72 |
| class: a word that ends in ing | 3399 | 917.89 ± 0.2% | 916.68 ± 0.3% | 20.52 ± 0.4% | 574.38 ± 0.4% | 35.38 ± 14.2% | 7.14 ± 0.3% | 21.56 ± 0.6% | 915.54 ± 0.5% | 1.00 | 1.00 | 1.60 | 25.94 |
| class: a word in capitals | 2332 | 1372.63 ± 0.8% | 985.86 ± 0.2% | 31.96 ± 1.5% | 602.89 ± 0.4% | 52.32 ± 17.0% | 15.25 ± 0.2% | 97.08 ± 0.4% | 1371.24 ± 0.2% | 1.39 | 1.00 | 2.28 | 26.23 |
| class: a number | 8288 | 1956.81 ± 0.3% | 834.32 ± 0.3% | 31.89 ± 1.6% | 2124.41 ± 0.3% | 51.79 ± 9.5% | 0.42 ± 0.1% | 75.63 ± 0.3% | 1954.48 ± 0.4% | 2.35 | 1.00 | 0.92 | 37.79 |
| class: two capitalized words, second text | 5359 | 724.78 ± 0.1% | 723.90 ± 0.2% | 27.70 ± 0.5% | 505.54 ± 0.2% | 42.60 ± 6.2% | 16.46 ± 0.6% | 72.94 ± 0.2% | 724.72 ± 0.2% | 1.00 | 1.00 | 1.43 | 17.01 |
| other: a word between two words | 6104 | 744.71 ± 0.1% | 777.80 ± 0.3% | 27.40 ± 0.6% | 869.11 ± 0.2% | 131.69 ± 16.9% | 9.60 ± 0.5% | 85.81 ± 0.6% | 747.51 ± 0.4% | 0.96 | 1.00 | 0.86 | 5.66 |
| other: a number before a unit, second text | 1481 | 8845.31 ± 3.0% | 1021.62 ± 0.3% | 30.30 ± 1.0% | 9465.85 ± 0.9% | 48.76 ± 6.1% | 17.17 ± 1.0% | 78.08 ± 2.9% | 8730.42 ± 0.7% | 8.66 | 1.01 | 0.93 | 181.39 |
| other: a heading's start tag | 110 | 20685.66 ± 3.2% | 1082.46 ± 0.4% | 32.52 ± 2.0% | 2699.33 ± 0.5% | 1896.07 ± 9.1% | 13.09 ± 0.8% | 117.54 ± 0.3% | 20645.67 ± 3.3% | 19.11 | 1.00 | 7.66 | 10.91 |
| other: a whole word | 217 | 25367.28 ± 0.4% | 1083.40 ± 0.6% | 33.74 ± 1.8% | 26142.79 ± 0.5% | 60.01 ± 0.9% | 12.50 ± 0.3% | 64.26 ± 1.0% | 25304.48 ± 0.9% | 23.41 | 1.00 | 0.97 | 422.69 |
| other: a line's first word, second text | 3716 | 2346.99 ± 0.9% | 893.40 ± 0.4% | 35.23 ± 0.4% | 2437.49 ± 0.5% | 81.66 ± 3.7% | refused | refused | 2335.81 ± 0.4% | 2.63 | 1.00 | 0.96 | 28.74 |
| other: fourteen octets before an x | 87 | 35952.51 ± 1.0% | 295.15 ± 0.6% | 7.38 ± 0.4% | 4151.63 ± 2.5% | 11.55 ± 0.6% | differs | 20.01 ± 0.5% | 36031.35 ± 0.3% | 121.81 | 1.00 | 8.66 | 3112.17 |
| other: a Greek word | 21815 | 501.08 ± 1.4% | 344.03 ± 1.2% | 36.65 ± 0.9% | 312.33 ± 1.1% | 62.12 ± 12.2% | differs | refused | 500.27 ± 0.6% | 1.46 | 1.00 | 1.60 | 8.07 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.72 ± 0.3% | 28.71 ± 0.7% | 1.08 ± 12.4% | 21.46 ± 9.8% | 3.22 ± 1.2% | differs | 4.78 ± 0.9% | 28.73 ± 2.5% | 1.00 | 1.00 | 1.34 | 8.93 |
| a UUID | 32895 | 25.90 ± 0.3% | 25.92 ± 0.3% | 0.77 ± 2.4% | 16.47 ± 0.8% | 3.25 ± 1.0% | 0.71 ± 0.4% | 3.96 ± 0.9% | 25.93 ± 0.3% | 1.00 | 1.00 | 1.57 | 7.96 |
| an IPv4 address | 33176 | 38.78 ± 0.6% | 38.90 ± 0.5% | 2.48 ± 0.7% | 31.35 ± 0.4% | 8.12 ± 0.8% | differs | 4.59 ± 0.4% | 38.88 ± 0.7% | 1.00 | 1.00 | 1.24 | 4.78 |
| a date and time | 32954 | 37.53 ± 0.6% | 37.60 ± 0.5% | 1.80 ± 0.4% | 23.94 ± 0.2% | 10.25 ± 2.5% | 1.29 ± 0.4% | 8.47 ± 0.4% | 37.55 ± 0.7% | 1.00 | 1.00 | 1.57 | 3.66 |
| a field path | 32606 | 31.23 ± 2.6% | 31.10 ± 0.6% | 1.27 ± 4.0% | 24.78 ± 0.5% | 3.71 ± 0.7% | differs | 3.12 ± 0.6% | 31.21 ± 0.6% | 1.00 | 1.00 | 1.26 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.31 ± 0.3% | 12.36 ± 0.4% | 12.35 ± 0.3% | 14.71 ± 1.7% | 6.84 ± 0.9% | 1.02 ± 0.4% | none | 12.31 ± 0.7% | 1.00 | 1.00 | 0.84 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 293.43 ± 0.5% | 295.16 ± 0.5% | 350.63 ± 0.6% | 116.44 ± 1.4% | 262.11 ± 1.1% | 687.12 ± 1.0% | 3999.01 ± 1.4% | 293.62 ± 0.5% | 0.99 | 1.00 | 2.52 | 1.12 |
| a UUID | 62 | 189.79 ± 0.5% | 190.63 ± 0.5% | 214.25 ± 0.8% | 61.84 ± 0.7% | 117.62 ± 1.6% | 256.76 ± 4.3% | 5575.09 ± 0.4% | 189.70 ± 0.5% | 1.00 | 1.00 | 3.07 | 1.61 |
| an IPv4 address | 29 | 569.67 ± 0.5% | 575.17 ± 0.3% | 834.93 ± 0.7% | 100.41 ± 0.3% | 158.29 ± 1.6% | 439.09 ± 0.4% | 10095.16 ± 0.7% | 569.32 ± 0.6% | 0.99 | 1.00 | 5.67 | 3.60 |
| a date and time | 56 | 441.81 ± 0.3% | 446.19 ± 4.0% | 581.46 ± 0.5% | 96.59 ± 0.8% | 167.54 ± 0.5% | 450.76 ± 0.5% | 5585.71 ± 1.0% | 442.90 ± 0.5% | 0.99 | 1.00 | 4.57 | 2.64 |
| a field path | 39 | 284.40 ± 0.6% | 286.42 ± 0.4% | 335.73 ± 0.4% | 105.49 ± 1.2% | 247.42 ± 1.8% | 716.40 ± 1.2% | 5373.00 ± 0.8% | 283.42 ± 0.8% | 0.99 | 1.00 | 2.70 | 1.15 |
| literal: a word | 7 | 884.63 ± 0.5% | 958.97 ± 0.4% | 1842.26 ± 0.8% | 721.54 ± 0.8% | 811.55 ± 1.4% | 1472.68 ± 0.2% | 36083.11 ± 1.0% | 883.98 ± 0.6% | 0.92 | 1.00 | 1.23 | 1.09 |
| literal: a word that is not there | 8 | 851.98 ± 0.4% | 926.98 ± 0.3% | 1745.45 ± 0.9% | 644.63 ± 0.9% | 779.22 ± 0.5% | 1381.37 ± 0.6% | 33948.86 ± 1.5% | 850.14 ± 0.6% | 0.92 | 1.00 | 1.32 | 1.09 |
| literal: one of four words | 26 | 335.33 ± 0.7% | 590.64 ± 0.2% | 843.80 ± 0.8% | 50.44 ± 0.6% | 301.16 ± 1.0% | 507.34 ± 1.7% | 16722.94 ± 0.9% | 335.10 ± 0.4% | 0.57 | 1.00 | 6.65 | 1.11 |
| literal: a word in any case | 11 | 669.06 ± 6.1% | 716.62 ± 0.8% | 1142.58 ± 0.4% | 17.70 ± 0.6% | 768.63 ± 12.1% | refused | 27137.34 ± 1.8% | 669.51 ± 5.3% | 0.93 | 1.00 | 37.80 | 0.87 |
| literal: an href attribute | 12 | 462.99 ± 0.4% | 476.00 ± 0.8% | 637.87 ± 0.3% | 49.87 ± 0.4% | 613.96 ± 11.1% | 1141.45 ± 4.2% | 25987.72 ± 3.0% | 462.65 ± 1.2% | 0.97 | 1.00 | 9.28 | 0.75 |
| literal: a word, second text | 10 | 790.56 ± 0.7% | 877.59 ± 0.5% | 1575.97 ± 0.5% | 600.19 ± 1.0% | 681.28 ± 2.3% | 1191.80 ± 1.1% | 30715.17 ± 2.7% | 790.32 ± 0.2% | 0.90 | 1.00 | 1.32 | 1.16 |
| class: two capitalized words | 23 | 637.82 ± 0.3% | 697.67 ± 0.5% | 1079.34 ± 0.4% | 136.30 ± 0.8% | 635.79 ± 0.5% | 1110.26 ± 0.8% | 6763.98 ± 0.5% | 636.40 ± 0.9% | 0.91 | 1.00 | 4.68 | 1.00 |
| class: a word that ends in ing | 9 | 757.02 ± 0.5% | 869.75 ± 0.6% | 1674.35 ± 0.6% | 172.61 ± 0.5% | 936.20 ± 1.3% | 1758.51 ± 0.7% | 19497.94 ± 1.0% | 758.57 ± 0.1% | 0.87 | 1.00 | 4.39 | 0.81 |
| class: a word in capitals | 16 | 679.94 ± 0.3% | 744.37 ± 0.6% | 1320.20 ± 0.4% | 181.31 ± 2.0% | 941.47 ± 0.7% | 1601.85 ± 0.8% | 8989.07 ± 0.5% | 680.78 ± 0.4% | 0.91 | 1.00 | 3.75 | 0.72 |
| class: a number | 6 | 829.69 ± 0.2% | 926.79 ± 0.4% | 1920.47 ± 0.6% | 44.39 ± 1.4% | 1727.27 ± 1.1% | 3097.00 ± 1.8% | 29725.54 ± 1.6% | 829.24 ± 0.5% | 0.90 | 1.00 | 18.69 | 0.48 |
| class: two capitalized words, second text | 23 | 637.49 ± 0.7% | 695.52 ± 0.7% | 1079.91 ± 0.1% | 134.88 ± 0.4% | 627.98 ± 5.4% | 1132.36 ± 0.6% | 6786.40 ± 0.7% | 636.14 ± 0.4% | 0.92 | 1.00 | 4.73 | 1.02 |
| other: a word between two words | 13 | 766.07 ± 0.7% | 797.50 ± 0.4% | 1356.19 ± 0.2% | 180.87 ± 3.3% | 626.02 ± 1.3% | 1215.12 ± 1.8% | 16864.25 ± 3.7% | 766.11 ± 0.3% | 0.96 | 1.00 | 4.24 | 1.22 |
| other: a number before a unit, second text | 15 | 537.35 ± 0.4% | 597.96 ± 4.8% | 858.25 ± 0.2% | 41.65 ± 1.6% | 792.25 ± 1.0% | 1364.22 ± 1.9% | 18572.11 ± 5.0% | 536.85 ± 0.5% | 0.90 | 1.00 | 12.90 | 0.68 |
| other: a heading's start tag | 13 | 476.97 ± 0.2% | 485.98 ± 3.9% | 652.52 ± 0.5% | 47.85 ± 0.3% | 760.22 ± 19.9% | 1318.07 ± 0.7% | 22055.04 ± 1.3% | 476.13 ± 0.8% | 0.98 | 1.00 | 9.97 | 0.63 |
| other: a whole word | 11 | 811.50 ± 0.5% | 863.67 ± 3.8% | 1540.35 ± 0.4% | 161.14 ± 0.3% | 725.12 ± 1.0% | 1269.47 ± 1.4% | 29806.70 ± 2.1% | 809.73 ± 3.6% | 0.94 | 1.00 | 5.04 | 1.12 |
| other: a line's first word, second text | 17 | 729.79 ± 0.3% | 758.15 ± 0.3% | 1305.47 ± 0.4% | 173.05 ± 0.2% | 862.14 ± 8.8% | refused | refused | 727.84 ± 0.6% | 0.96 | 1.00 | 4.22 | 0.85 |
| other: fourteen octets before an x | 16 | 133.67 ± 0.5% | 194.69 ± 0.2% | 228.55 ± 0.6% | 18.64 ± 0.3% | 542.36 ± 5.1% | 580.57 ± 0.5% | 16089.18 ± 1.2% | 133.73 ± 0.2% | 0.69 | 1.00 | 7.17 | 0.25 |
| other: a Greek word | 8 | 550.21 ± 0.5% | 779.19 ± 0.3% | 1352.34 ± 0.5% | 61.62 ± 0.4% | 1727.84 ± 0.9% | 2961.12 ± 0.4% | refused | 549.95 ± 0.3% | 0.71 | 1.00 | 8.93 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23595.47 ± 0.8% | not timed | not timed | 28969.95 ± 0.4% | 2773.64 ± 11.5% | not timed | not timed | 23487.19 ± 0.3% | | 1.00 | 0.81 | 8.51 |
| 01-literal/sherlock-casei-en | 522 | 5522.32 ± 0.5% | not timed | not timed | 8454.39 ± 0.5% | 39.97 ± 1.2% | not timed | not timed | 5505.91 ± 0.3% | | 1.00 | 0.65 | 138.16 |
| 01-literal/sherlock-ru | 724 | 24073.48 ± 0.4% | not timed | not timed | 28264.68 ± 0.2% | 1599.73 ± 2.5% | not timed | not timed | 24036.83 ± 0.3% | | 1.00 | 0.85 | 15.05 |
| 01-literal/sherlock-casei-ru | 746 | 8250.99 ± 0.3% | not timed | not timed | 6407.57 ± 1.1% | 42.67 ± 0.6% | not timed | not timed | 8335.29 ± 0.6% | | 0.99 | 1.29 | 193.39 |
| 01-literal/sherlock-zh | 30 | 38206.14 ± 0.5% | not timed | not timed | 35191.17 ± 0.2% | 1599.68 ± 0.5% | not timed | not timed | 38189.58 ± 1.0% | | 1.00 | 1.09 | 23.88 |
| 02-literal-alternate/sherlock-en | 714 | 12144.23 ± 0.7% | not timed | not timed | 9422.32 ± 1.5% | 22.45 ± 0.7% | not timed | not timed | 12078.34 ± 0.3% | | 1.01 | 1.29 | 541.06 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2033.57 ± 0.7% | not timed | not timed | 2308.45 ± 5.1% | 13.70 ± 0.6% | not timed | not timed | 2019.63 ± 0.5% | | 1.01 | 0.88 | 148.43 |
| 02-literal-alternate/sherlock-ru | 899 | 6915.96 ± 0.3% | not timed | not timed | 5086.93 ± 0.4% | 28.88 ± 17.1% | not timed | not timed | 6894.71 ± 1.0% | | 1.00 | 1.36 | 239.44 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2121.45 ± 0.6% | not timed | not timed | 1242.06 ± 0.2% | 11.89 ± 0.5% | not timed | not timed | 2112.98 ± 0.1% | | 1.00 | 1.71 | 178.37 |
| 02-literal-alternate/sherlock-zh | 207 | 16459.65 ± 0.2% | not timed | not timed | 10750.40 ± 0.1% | 41.50 ± 0.8% | not timed | not timed | 16436.09 ± 5.8% | | 1.00 | 1.53 | 396.65 |
| 03-date/ascii | 111817 | 125.40 ± 1.2% | not timed | not timed | 110.23 ± 0.3% | 0.27 ± 4.8% | not timed | not timed | 125.02 ± 1.2% | | 1.00 | 1.14 | 464.79 |
| 04-ruff-noqa/real | 84 | 729.26 ± 0.6% | not timed | not timed | 565.33 ± 0.4% | 25.83 ± 1.8% | not timed | not timed | 729.16 ± 1.1% | | 1.00 | 1.29 | 28.24 |
| 04-ruff-noqa/tweaked | 44 | 618.04 ± 0.6% | not timed | not timed | 569.75 ± 0.5% | 371.55 ± 3.0% | not timed | not timed | 615.97 ± 0.4% | | 1.00 | 1.08 | 1.66 |
| 05-lexer-veryl/single | 124800 | 4.10 ± 0.2% | not timed | not timed | 5.77 ± 0.3% | 0.26 ± 4.5% | not timed | not timed | 4.12 ± 0.1% | | 1.00 | 0.71 | 15.49 |
| 06-cloud-flare-redos/original | 107 | 246.65 ± 0.1% | not timed | not timed | 262.17 ± 0.3% | 31.86 ± 0.5% | not timed | not timed | 246.47 ± 0.3% | | 1.00 | 0.94 | 7.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 172.90 ± 0.5% | not timed | not timed | 267.12 ± 0.1% | 34.38 ± 1.1% | not timed | not timed | 172.70 ± 0.4% | | 1.00 | 0.65 | 5.03 |
| 06-cloud-flare-redos/simplified-long | 10000 | 189.36 ± 4.2% | not timed | not timed | 279.57 ± 0.2% | 37.90 ± 0.8% | not timed | not timed | 189.31 ± 5.4% | | 1.00 | 0.68 | 5.00 |
| 07-unicode-character-data/parse-line | 558784 | 280.65 ± 8.0% | not timed | not timed | 205.54 ± 3.1% | 53.46 ± 2.6% | not timed | not timed | 281.00 ± 0.3% | | 1.00 | 1.37 | 5.25 |
| 08-words/all-english | 56691 | 106.02 ± 1.5% | not timed | not timed | 92.75 ± 0.8% | 14.46 ± 10.8% | not timed | not timed | 106.69 ± 0.5% | | 0.99 | 1.14 | 7.33 |
| 08-words/long-english | 839 | 1038.11 ± 0.6% | not timed | not timed | 623.59 ± 0.2% | 37.39 ± 3.9% | not timed | not timed | 1039.87 ± 0.1% | | 1.00 | 1.66 | 27.77 |
| 09-aws-keys/full | 0 | 573.17 ± 0.2% | not timed | not timed | 581.54 ± 0.4% | 82.30 ± 5.4% | not timed | not timed | 572.31 ± 0.4% | | 1.00 | 0.99 | 6.96 |
| 09-aws-keys/quick | 0 | 997.72 ± 3.0% | not timed | not timed | 895.12 ± 0.5% | 410.08 ± 3.8% | not timed | not timed | 1009.22 ± 5.1% | | 0.99 | 1.11 | 2.43 |
| 10-bounded-repeat/letters-en | 1833 | 610.97 ± 0.4% | not timed | not timed | 549.32 ± 0.5% | 24.03 ± 0.5% | not timed | not timed | 607.52 ± 0.3% | | 1.01 | 1.11 | 25.43 |
| 10-bounded-repeat/letters-ru | 3475 | 392.75 ± 0.3% | not timed | not timed | 492.93 ± 0.7% | 25.42 ± 8.5% | not timed | not timed | 392.05 ± 0.3% | | 1.00 | 0.80 | 15.45 |
| 10-bounded-repeat/context | 53 | 90.12 ± 1.3% | not timed | not timed | 73.43 ± 0.8% | 24.31 ± 0.2% | not timed | not timed | 90.33 ± 1.4% | | 1.00 | 1.23 | 3.71 |
| 10-bounded-repeat/capitals | 11 | 1087.34 ± 0.8% | not timed | not timed | 640.21 ± 0.3% | 44.51 ± 0.3% | not timed | not timed | 1077.88 ± 0.2% | | 1.01 | 1.70 | 24.43 |
| 11-unstructured-to-json/extract | 600 | 46.44 ± 0.3% | not timed | not timed | 81.02 ± 0.4% | 64.02 ± 0.6% | not timed | not timed | 46.27 ± 0.7% | | 1.00 | 0.57 | 0.73 |
| 12-dictionary/single | 1 | 567.67 ± 1.9% | not timed | not timed | 548.87 ± 0.3% | 0.53 ± 4.6% | not timed | not timed | 571.19 ± 0.4% | | 0.99 | 1.03 | 1075.58 |
| 14-quadratic/1x | 100 | 14.28 ± 0.5% | not timed | not timed | 13.46 ± 2.7% | 1.24 ± 2.9% | not timed | not timed | 14.25 ± 0.7% | | 1.00 | 1.06 | 11.48 |
| 14-quadratic/2x | 200 | 8.56 ± 1.3% | not timed | not timed | 6.61 ± 0.2% | 0.69 ± 0.9% | not timed | not timed | 8.54 ± 0.1% | | 1.00 | 1.30 | 12.37 |
| 14-quadratic/10x | 1000 | 1.93 ± 0.2% | not timed | not timed | 1.29 ± 0.5% | 0.15 ± 0.9% | not timed | not timed | 1.93 ± 0.2% | | 1.00 | 1.50 | 12.72 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.01 ± 0.4% | not timed | not timed | 0.45 ± 3.4% | 0.66 ± 2.3% | not timed | not timed | 2.00 ± 6.0% | | 1.01 | 4.48 | 3.03 |
| 04-ruff-noqa/compile-real | 1 | 129.22 ± 0.1% | not timed | not timed | 15.93 ± 4.0% | 175.22 ± 0.8% | not timed | not timed | 128.50 ± 1.1% | | 1.01 | 8.11 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 21.76 ± 0.8% | not timed | not timed | 3.03 ± 0.8% | 7.73 ± 2.1% | not timed | not timed | 21.67 ± 0.8% | | 1.00 | 7.17 | 2.81 |
| 07-unicode-character-data/compile | 1 | 76.84 ± 0.6% | not timed | not timed | 32.33 ± 1.4% | 43.11 ± 0.8% | not timed | not timed | 77.00 ± 1.3% | | 1.00 | 2.38 | 1.78 |
| 09-aws-keys/compile-full | 1 | 53.54 ± 0.7% | not timed | not timed | 8.99 ± 0.5% | 27.73 ± 0.8% | not timed | not timed | 53.21 ± 0.9% | | 1.01 | 5.95 | 1.93 |
| 09-aws-keys/compile-quick | 1 | 246.81 ± 0.6% | not timed | not timed | 59.37 ± 0.1% | 161.12 ± 1.6% | not timed | not timed | 245.27 ± 1.0% | | 1.01 | 4.16 | 1.53 |
| 10-bounded-repeat/compile-context | 1 | 16.87 ± 1.0% | not timed | not timed | 14.40 ± 0.4% | 20.14 ± 2.3% | not timed | not timed | 16.68 ± 1.6% | | 1.01 | 1.17 | 0.84 |
| 10-bounded-repeat/compile-capitals | 1 | 101.91 ± 0.9% | not timed | not timed | 10.85 ± 0.5% | 28.91 ± 1.1% | not timed | not timed | 101.23 ± 1.2% | | 1.01 | 9.39 | 3.53 |
| 11-unstructured-to-json/compile | 1 | 119.14 ± 0.8% | not timed | not timed | 48.97 ± 0.8% | 81.77 ± 2.6% | not timed | not timed | 118.25 ± 5.2% | | 1.01 | 2.43 | 1.46 |
| 12-dictionary/compile-single | 1 | 0.37 ± 3.0% | not timed | not timed | 0.08 ± 2.0% | 0.11 ± 21.0% | not timed | not timed | 0.37 ± 3.0% | | 1.02 | 4.64 | 3.35 |

