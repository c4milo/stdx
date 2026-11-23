# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148056260 |
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
| literal: a word | 217 | 40634.34 ± 0.6% | 1032.54 ± 0.2% | 29.99 ± 0.5% | 38519.13 ± 1.8% | 11895.22 ± 19.2% | 12.91 ± 0.5% | 104.46 ± 0.2% | 40629.21 ± 0.3% | 39.35 | 1.00 | 1.05 | 3.42 |
| literal: a word that is not there | 0 | 57091.75 ± 0.6% | 1043.96 ± 0.1% | 30.03 ± 0.3% | 45803.70 ± 2.4% | 43676.74 ± 0.3% | 12.77 ± 1.0% | 98.33 ± 0.6% | 56883.80 ± 1.5% | 54.69 | 1.00 | 1.25 | 1.31 |
| literal: one of four words | 661 | 14064.48 ± 0.5% | 1012.87 ± 0.4% | 16.76 ± 2.0% | 11135.84 ± 4.9% | 24.73 ± 8.7% | 4.46 ± 0.3% | 8.23 ± 0.8% | 14061.34 ± 0.7% | 13.89 | 1.00 | 1.26 | 568.77 |
| literal: a word in any case | 217 | 36215.77 ± 6.4% | 1032.27 ± 0.4% | 22.79 ± 0.5% | 11377.59 ± 0.5% | 47.08 ± 0.6% | refused | differs | 36168.18 ± 2.1% | 35.08 | 1.00 | 3.18 | 769.28 |
| literal: an href attribute | 33 | 35232.08 ± 0.7% | 1039.24 ± 0.1% | 29.00 ± 1.3% | 35090.93 ± 1.1% | 2917.81 ± 6.8% | 9.67 ± 0.8% | 91.33 ± 1.0% | 35133.51 ± 0.3% | 33.90 | 1.00 | 1.00 | 12.07 |
| literal: a word, second text | 123 | 44454.16 ± 0.8% | 1034.98 ± 0.5% | 29.66 ± 0.3% | 39429.61 ± 1.1% | 11079.60 ± 7.6% | 14.44 ± 0.8% | 87.51 ± 0.1% | 44434.12 ± 0.4% | 42.95 | 1.00 | 1.13 | 4.01 |
| class: two capitalized words | 1331 | 919.48 ± 0.1% | 961.51 ± 0.1% | 28.09 ± 5.3% | 575.77 ± 0.2% | 44.18 ± 12.6% | 11.07 ± 0.2% | 79.85 ± 1.7% | 916.17 ± 0.2% | 0.96 | 1.00 | 1.60 | 20.81 |
| class: a word that ends in ing | 3399 | 884.42 ± 2.7% | 884.17 ± 2.5% | 20.06 ± 1.4% | 540.13 ± 0.5% | 32.57 ± 11.3% | 6.23 ± 0.2% | 20.31 ± 1.4% | 874.73 ± 2.9% | 1.00 | 1.01 | 1.64 | 27.15 |
| class: a word in capitals | 2332 | 1156.88 ± 0.2% | 940.28 ± 0.2% | 29.47 ± 1.3% | 565.37 ± 15.4% | 47.85 ± 7.7% | 12.51 ± 0.3% | 100.64 ± 0.7% | 1156.86 ± 0.2% | 1.23 | 1.00 | 2.05 | 24.18 |
| class: a number | 8288 | 1712.99 ± 0.8% | 814.16 ± 0.3% | 29.60 ± 0.6% | 1793.97 ± 1.6% | 45.28 ± 8.1% | 0.39 ± 0.2% | 72.41 ± 0.8% | 1705.07 ± 2.8% | 2.10 | 1.00 | 0.95 | 37.83 |
| class: two capitalized words, second text | 5359 | 723.78 ± 1.2% | 721.54 ± 0.8% | 25.63 ± 4.8% | 478.76 ± 0.2% | 37.33 ± 13.9% | 12.71 ± 0.4% | 74.44 ± 0.3% | 722.62 ± 0.0% | 1.00 | 1.00 | 1.51 | 19.39 |
| other: a word between two words | 6104 | 838.56 ± 3.9% | 752.18 ± 0.4% | 25.43 ± 3.9% | 814.06 ± 3.0% | 125.65 ± 15.4% | 8.53 ± 0.7% | 81.53 ± 0.2% | 836.89 ± 0.2% | 1.11 | 1.00 | 1.03 | 6.67 |
| other: a number before a unit, second text | 1481 | 9847.95 ± 0.6% | 989.86 ± 0.3% | 28.07 ± 1.0% | 8224.26 ± 1.2% | 44.82 ± 15.8% | 13.30 ± 0.4% | 76.98 ± 8.8% | 9796.41 ± 0.8% | 9.95 | 1.01 | 1.20 | 219.72 |
| other: a heading's start tag | 110 | 24422.49 ± 0.1% | 1029.91 ± 0.1% | 29.83 ± 0.9% | 2607.06 ± 1.2% | 2011.42 ± 6.1% | 11.83 ± 4.8% | 107.08 ± 0.2% | 24354.49 ± 4.0% | 23.71 | 1.00 | 9.37 | 12.14 |
| other: a whole word | 217 | 28877.50 ± 0.2% | 1032.50 ± 0.1% | 29.78 ± 0.4% | 28046.15 ± 1.0% | 53.86 ± 0.3% | 11.02 ± 0.2% | 63.03 ± 0.2% | 29190.98 ± 0.8% | 27.97 | 0.99 | 1.03 | 536.12 |
| other: a line's first word, second text | 3716 | 2572.26 ± 2.2% | 862.69 ± 0.2% | 31.88 ± 0.6% | 2280.72 ± 0.3% | 70.79 ± 3.4% | refused | refused | 2554.08 ± 1.3% | 2.98 | 1.01 | 1.13 | 36.34 |
| other: fourteen octets before an x | 87 | 35574.44 ± 0.8% | 247.95 ± 1.0% | 7.67 ± 0.8% | 3424.51 ± 0.3% | 11.39 ± 0.6% | differs | 20.63 ± 2.0% | 35776.96 ± 0.6% | 143.47 | 0.99 | 10.39 | 3123.71 |
| other: a Greek word | 21815 | 478.93 ± 0.6% | 401.95 ± 0.3% | 33.72 ± 0.7% | 304.25 ± 0.5% | 57.68 ± 7.8% | differs | refused | 478.38 ± 0.3% | 1.19 | 1.00 | 1.57 | 8.30 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.07 ± 0.8% | 29.12 ± 0.6% | 1.04 ± 0.4% | 19.82 ± 0.2% | 2.65 ± 10.1% | differs | 4.26 ± 7.3% | 29.18 ± 0.6% | 1.00 | 1.00 | 1.47 | 10.97 |
| a UUID | 32895 | 24.13 ± 0.4% | 24.13 ± 0.2% | 0.73 ± 0.2% | 15.13 ± 2.1% | 3.03 ± 4.1% | 0.52 ± 2.6% | 3.84 ± 2.1% | 24.09 ± 0.2% | 1.00 | 1.00 | 1.59 | 7.97 |
| an IPv4 address | 33176 | 39.77 ± 2.1% | 39.43 ± 2.5% | 2.35 ± 0.9% | 28.55 ± 0.3% | 6.93 ± 2.4% | differs | 4.23 ± 1.0% | 40.22 ± 1.4% | 1.01 | 0.99 | 1.39 | 5.73 |
| a date and time | 32954 | 35.96 ± 0.6% | 35.37 ± 0.4% | 1.72 ± 0.8% | 20.96 ± 0.2% | 8.18 ± 3.3% | 0.91 ± 0.1% | 7.56 ± 4.4% | 35.90 ± 0.3% | 1.02 | 1.00 | 1.72 | 4.40 |
| a field path | 32606 | 32.35 ± 0.5% | 32.41 ± 0.2% | 1.15 ± 3.2% | 23.03 ± 0.6% | 3.52 ± 2.2% | differs | 3.01 ± 1.9% | 32.49 ± 0.2% | 1.00 | 1.00 | 1.40 | 9.20 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.97 ± 1.0% | 10.96 ± 0.9% | 8.85 ± 0.4% | 13.05 ± 0.4% | 5.91 ± 3.7% | 0.76 ± 0.6% | none | 11.00 ± 0.3% | 1.00 | 1.00 | 0.84 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 237.89 ± 5.0% | 239.22 ± 3.4% | 281.08 ± 15.0% | 101.75 ± 1.1% | 243.98 ± 12.5% | 694.46 ± 6.6% | 4792.32 ± 1.7% | 238.13 ± 1.6% | 0.99 | 1.00 | 2.34 | 0.98 |
| a UUID | 62 | 152.50 ± 0.2% | 152.81 ± 1.0% | 171.16 ± 1.0% | 58.41 ± 1.9% | 117.90 ± 9.5% | 258.04 ± 1.9% | 5388.64 ± 0.7% | 152.53 ± 9.9% | 1.00 | 1.00 | 2.61 | 1.29 |
| an IPv4 address | 29 | 482.18 ± 2.2% | 487.32 ± 0.4% | 708.50 ± 15.4% | 87.77 ± 1.0% | 149.32 ± 2.2% | 413.49 ± 1.1% | 8994.23 ± 0.3% | 482.79 ± 0.4% | 0.99 | 1.00 | 5.49 | 3.23 |
| a date and time | 56 | 348.88 ± 0.4% | 350.95 ± 0.6% | 449.39 ± 0.5% | 87.31 ± 1.7% | 158.35 ± 16.9% | 476.15 ± 9.5% | 5557.71 ± 0.6% | 349.95 ± 0.3% | 0.99 | 1.00 | 4.00 | 2.20 |
| a field path | 39 | 228.15 ± 0.7% | 229.73 ± 0.4% | 266.76 ± 8.5% | 96.73 ± 2.3% | 228.14 ± 3.1% | 711.52 ± 1.0% | 5613.71 ± 1.7% | 228.32 ± 0.5% | 0.99 | 1.00 | 2.36 | 1.00 |
| literal: a word | 7 | 710.53 ± 9.6% | 751.24 ± 10.2% | 1387.87 ± 2.2% | 659.97 ± 1.1% | 795.15 ± 2.5% | 1609.76 ± 0.1% | 34053.76 ± 0.4% | 710.40 ± 1.2% | 0.95 | 1.00 | 1.08 | 0.89 |
| literal: a word that is not there | 8 | 682.40 ± 0.2% | 723.80 ± 0.7% | 1301.94 ± 0.8% | 611.75 ± 2.2% | 752.90 ± 1.5% | 1495.59 ± 0.6% | 33238.13 ± 15.1% | 681.98 ± 0.4% | 0.94 | 1.00 | 1.12 | 0.91 |
| literal: one of four words | 26 | 260.58 ± 0.2% | 434.77 ± 0.4% | 594.07 ± 0.3% | 53.78 ± 4.8% | 289.57 ± 13.8% | 596.81 ± 1.7% | 18331.56 ± 3.7% | 259.78 ± 0.2% | 0.60 | 1.00 | 4.85 | 0.90 |
| literal: a word in any case | 11 | 548.00 ± 0.6% | 576.34 ± 0.3% | 887.45 ± 0.6% | 18.85 ± 0.6% | 826.98 ± 4.6% | refused | 24741.63 ± 21.8% | 546.16 ± 10.7% | 0.95 | 1.00 | 29.08 | 0.66 |
| literal: an href attribute | 12 | 394.37 ± 0.6% | 406.37 ± 0.5% | 549.40 ± 12.2% | 51.19 ± 1.9% | 567.04 ± 13.1% | 1243.49 ± 0.6% | 24641.43 ± 0.3% | 393.57 ± 8.8% | 0.97 | 1.00 | 7.70 | 0.70 |
| literal: a word, second text | 10 | 630.35 ± 0.4% | 677.26 ± 0.6% | 1153.39 ± 2.2% | 538.46 ± 10.0% | 645.30 ± 19.2% | 1270.50 ± 4.3% | 31834.98 ± 0.5% | 630.08 ± 1.2% | 0.93 | 1.00 | 1.17 | 0.98 |
| class: two capitalized words | 23 | 501.92 ± 0.6% | 544.85 ± 0.8% | 811.58 ± 11.8% | 124.54 ± 0.7% | 599.25 ± 0.7% | 1271.24 ± 0.9% | 7841.39 ± 1.2% | 502.48 ± 0.7% | 0.92 | 1.00 | 4.03 | 0.84 |
| class: a word that ends in ing | 9 | 622.56 ± 0.4% | 705.60 ± 0.6% | 1291.45 ± 1.3% | 153.35 ± 1.3% | 854.95 ± 0.9% | 1931.06 ± 0.6% | 19213.25 ± 0.4% | 622.75 ± 0.3% | 0.88 | 1.00 | 4.06 | 0.73 |
| class: a word in capitals | 16 | 552.53 ± 0.3% | 603.03 ± 0.7% | 1013.32 ± 0.7% | 157.56 ± 12.0% | 884.99 ± 3.1% | 1781.47 ± 1.7% | 10576.70 ± 0.3% | 552.39 ± 0.8% | 0.92 | 1.00 | 3.51 | 0.62 |
| class: a number | 6 | 685.45 ± 13.4% | 766.77 ± 0.9% | 1534.98 ± 1.9% | 47.68 ± 0.5% | 1642.69 ± 2.7% | 3002.99 ± 12.5% | 25755.23 ± 11.5% | 685.94 ± 3.4% | 0.89 | 1.00 | 14.38 | 0.42 |
| class: two capitalized words, second text | 23 | 503.79 ± 0.5% | 546.26 ± 0.4% | 816.47 ± 0.9% | 121.60 ± 0.3% | 601.23 ± 2.6% | 1264.76 ± 0.6% | 7848.67 ± 0.8% | 502.36 ± 3.3% | 0.92 | 1.00 | 4.14 | 0.84 |
| other: a word between two words | 13 | 610.95 ± 1.0% | 630.55 ± 0.6% | 1020.62 ± 3.3% | 158.91 ± 5.1% | 560.49 ± 20.2% | 1344.20 ± 4.6% | 17381.27 ± 5.6% | 611.03 ± 1.4% | 0.97 | 1.00 | 3.84 | 1.09 |
| other: a number before a unit, second text | 15 | 428.65 ± 0.4% | 478.07 ± 0.8% | 673.21 ± 0.6% | 44.52 ± 0.7% | 724.08 ± 3.1% | 1427.91 ± 7.2% | 17545.61 ± 13.4% | 429.01 ± 0.6% | 0.90 | 1.00 | 9.63 | 0.59 |
| other: a heading's start tag | 13 | 408.15 ± 8.5% | 413.59 ± 2.6% | 563.26 ± 0.4% | 48.51 ± 0.7% | 706.31 ± 9.9% | 1390.31 ± 0.7% | 20019.23 ± 0.7% | 407.40 ± 1.3% | 0.99 | 1.00 | 8.41 | 0.58 |
| other: a whole word | 11 | 631.48 ± 0.8% | 663.72 ± 0.6% | 1115.18 ± 1.0% | 143.38 ± 1.8% | 674.75 ± 2.8% | 1393.45 ± 0.9% | 31410.41 ± 0.6% | 629.50 ± 0.6% | 0.95 | 1.00 | 4.40 | 0.94 |
| other: a line's first word, second text | 17 | 595.89 ± 1.3% | 625.49 ± 0.7% | 1046.52 ± 0.6% | 151.79 ± 0.9% | 801.59 ± 2.1% | refused | refused | 596.35 ± 0.4% | 0.95 | 1.00 | 3.93 | 0.74 |
| other: fourteen octets before an x | 16 | 116.40 ± 1.1% | 172.57 ± 0.7% | 206.07 ± 0.8% | 18.14 ± 0.6% | 518.90 ± 17.8% | 566.02 ± 1.5% | 15776.66 ± 0.3% | 116.18 ± 0.9% | 0.67 | 1.00 | 6.42 | 0.22 |
| other: a Greek word | 8 | 435.02 ± 7.2% | 618.41 ± 1.4% | 1023.64 ± 0.4% | 62.89 ± 0.2% | 1610.57 ± 2.0% | 2712.22 ± 0.7% | refused | 437.18 ± 0.8% | 0.70 | 1.00 | 6.92 | 0.27 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29384.31 ± 1.0% | not timed | not timed | 33824.11 ± 0.7% | 2575.57 ± 14.8% | not timed | not timed | 29270.66 ± 0.5% | | 1.00 | 0.87 | 11.41 |
| 01-literal/sherlock-casei-en | 522 | 8437.22 ± 0.3% | not timed | not timed | 9007.81 ± 0.3% | 33.54 ± 14.0% | not timed | not timed | 8375.40 ± 0.5% | | 1.01 | 0.94 | 251.52 |
| 01-literal/sherlock-ru | 724 | 30901.96 ± 1.7% | not timed | not timed | 34327.65 ± 4.3% | 1260.38 ± 11.7% | not timed | not timed | 30729.49 ± 0.6% | | 1.01 | 0.90 | 24.52 |
| 01-literal/sherlock-casei-ru | 746 | 8824.12 ± 0.4% | not timed | not timed | 7792.11 ± 0.8% | 37.59 ± 0.8% | not timed | not timed | 8854.72 ± 0.6% | | 1.00 | 1.13 | 234.74 |
| 01-literal/sherlock-zh | 30 | 53229.59 ± 1.1% | not timed | not timed | 43029.35 ± 0.8% | 1638.17 ± 1.8% | not timed | not timed | 53023.38 ± 0.7% | | 1.00 | 1.24 | 32.49 |
| 02-literal-alternate/sherlock-en | 714 | 12771.40 ± 6.6% | not timed | not timed | 10866.15 ± 12.0% | 19.04 ± 10.9% | not timed | not timed | 12792.03 ± 0.2% | | 1.00 | 1.18 | 670.64 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4182.77 ± 7.2% | not timed | not timed | 2304.23 ± 1.3% | 12.19 ± 0.9% | not timed | not timed | 3851.66 ± 2.2% | | 1.09 | 1.82 | 343.05 |
| 02-literal-alternate/sherlock-ru | 899 | 7478.15 ± 0.5% | not timed | not timed | 9791.57 ± 1.3% | 25.37 ± 6.7% | not timed | not timed | 7430.62 ± 0.9% | | 1.01 | 0.76 | 294.75 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2140.53 ± 1.4% | not timed | not timed | 1190.34 ± 0.5% | 10.55 ± 2.5% | not timed | not timed | 2118.73 ± 2.4% | | 1.01 | 1.80 | 202.96 |
| 02-literal-alternate/sherlock-zh | 207 | 18624.23 ± 0.2% | not timed | not timed | 12657.14 ± 0.4% | 35.67 ± 4.4% | not timed | not timed | 18579.39 ± 0.3% | | 1.00 | 1.47 | 522.14 |
| 03-date/ascii | 111817 | 131.19 ± 0.8% | not timed | not timed | 100.12 ± 0.7% | 0.23 ± 2.4% | not timed | not timed | 131.63 ± 0.8% | | 1.00 | 1.31 | 573.53 |
| 04-ruff-noqa/real | 84 | 697.81 ± 0.8% | not timed | not timed | 510.84 ± 0.4% | 20.68 ± 2.3% | not timed | not timed | 696.78 ± 1.7% | | 1.00 | 1.37 | 33.74 |
| 04-ruff-noqa/tweaked | 44 | 588.84 ± 0.2% | not timed | not timed | 514.52 ± 0.4% | 368.40 ± 0.7% | not timed | not timed | 584.58 ± 1.0% | | 1.01 | 1.14 | 1.60 |
| 05-lexer-veryl/single | 124800 | 4.00 ± 3.9% | not timed | not timed | 5.17 ± 1.2% | 0.26 ± 2.2% | not timed | not timed | 3.98 ± 13.3% | | 1.01 | 0.78 | 15.51 |
| 06-cloud-flare-redos/original | 107 | 268.03 ± 0.9% | not timed | not timed | 224.39 ± 1.2% | 21.54 ± 1.5% | not timed | not timed | 267.24 ± 0.7% | | 1.00 | 1.19 | 12.44 |
| 06-cloud-flare-redos/simplified-short | 102 | 262.90 ± 7.8% | not timed | not timed | 232.69 ± 1.8% | 23.30 ± 1.2% | not timed | not timed | 262.77 ± 0.6% | | 1.00 | 1.13 | 11.28 |
| 06-cloud-flare-redos/simplified-long | 10000 | 279.07 ± 0.9% | not timed | not timed | 256.52 ± 9.7% | 29.34 ± 3.9% | not timed | not timed | 279.08 ± 0.8% | | 1.00 | 1.09 | 9.51 |
| 07-unicode-character-data/parse-line | 558784 | 244.83 ± 0.4% | not timed | not timed | 199.76 ± 1.0% | 48.75 ± 8.8% | not timed | not timed | 244.07 ± 1.9% | | 1.00 | 1.23 | 5.02 |
| 08-words/all-english | 56691 | 112.64 ± 0.5% | not timed | not timed | 84.75 ± 0.1% | 14.55 ± 2.6% | not timed | not timed | 112.42 ± 0.5% | | 1.00 | 1.33 | 7.74 |
| 08-words/long-english | 839 | 987.89 ± 0.2% | not timed | not timed | 583.77 ± 0.5% | 34.77 ± 0.6% | not timed | not timed | 983.62 ± 0.9% | | 1.00 | 1.69 | 28.41 |
| 09-aws-keys/full | 0 | 517.19 ± 8.8% | not timed | not timed | 547.09 ± 0.4% | 62.51 ± 5.8% | not timed | not timed | 517.04 ± 0.1% | | 1.00 | 0.95 | 8.27 |
| 09-aws-keys/quick | 0 | 911.15 ± 0.7% | not timed | not timed | 941.97 ± 4.7% | 404.38 ± 11.7% | not timed | not timed | 983.69 ± 4.3% | | 0.93 | 0.97 | 2.25 |
| 10-bounded-repeat/letters-en | 1833 | 672.59 ± 6.9% | not timed | not timed | 556.64 ± 0.4% | 22.44 ± 0.6% | not timed | not timed | 665.20 ± 0.6% | | 1.01 | 1.21 | 29.98 |
| 10-bounded-repeat/letters-ru | 3475 | 369.96 ± 0.3% | not timed | not timed | 483.29 ± 0.7% | 24.52 ± 4.8% | not timed | not timed | 370.12 ± 0.2% | | 1.00 | 0.77 | 15.09 |
| 10-bounded-repeat/context | 53 | 78.30 ± 3.4% | not timed | not timed | 70.37 ± 0.7% | 22.58 ± 1.4% | not timed | not timed | 76.47 ± 3.1% | | 1.02 | 1.11 | 3.47 |
| 10-bounded-repeat/capitals | 11 | 1032.80 ± 0.7% | not timed | not timed | 603.92 ± 0.3% | 40.41 ± 0.8% | not timed | not timed | 1030.40 ± 0.4% | | 1.00 | 1.71 | 25.56 |
| 11-unstructured-to-json/extract | 600 | 46.79 ± 0.6% | not timed | not timed | 78.96 ± 1.9% | 49.89 ± 1.5% | not timed | not timed | 46.80 ± 0.7% | | 1.00 | 0.59 | 0.94 |
| 12-dictionary/single | 1 | 508.69 ± 0.3% | not timed | not timed | 482.94 ± 0.6% | 0.39 ± 6.6% | not timed | not timed | 511.84 ± 0.1% | | 0.99 | 1.05 | 1319.63 |
| 14-quadratic/1x | 100 | 9.50 ± 0.3% | not timed | not timed | 12.19 ± 0.4% | 1.00 ± 4.5% | not timed | not timed | 9.45 ± 0.6% | | 1.01 | 0.78 | 9.50 |
| 14-quadratic/2x | 200 | 5.35 ± 0.1% | not timed | not timed | 6.12 ± 0.3% | 0.51 ± 2.3% | not timed | not timed | 5.33 ± 3.2% | | 1.00 | 0.87 | 10.45 |
| 14-quadratic/10x | 1000 | 1.19 ± 0.1% | not timed | not timed | 1.22 ± 0.2% | 0.12 ± 1.1% | not timed | not timed | 1.18 ± 1.5% | | 1.00 | 0.98 | 10.02 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.66 ± 8.3% | not timed | not timed | 0.47 ± 0.8% | 0.61 ± 4.4% | not timed | not timed | 1.65 ± 0.9% | | 1.01 | 3.51 | 2.74 |
| 04-ruff-noqa/compile-real | 1 | 102.88 ± 1.2% | not timed | not timed | 17.06 ± 2.1% | 165.67 ± 16.0% | not timed | not timed | 102.59 ± 8.7% | | 1.00 | 6.03 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 17.11 ± 1.4% | not timed | not timed | 3.01 ± 0.4% | 7.86 ± 5.0% | not timed | not timed | 17.08 ± 3.0% | | 1.00 | 5.68 | 2.18 |
| 07-unicode-character-data/compile | 1 | 63.96 ± 0.4% | not timed | not timed | 30.15 ± 0.3% | 44.11 ± 2.3% | not timed | not timed | 63.92 ± 1.3% | | 1.00 | 2.12 | 1.45 |
| 09-aws-keys/compile-full | 1 | 44.96 ± 1.6% | not timed | not timed | 9.94 ± 14.0% | 27.74 ± 4.4% | not timed | not timed | 44.76 ± 0.7% | | 1.00 | 4.52 | 1.62 |
| 09-aws-keys/compile-quick | 1 | 197.61 ± 2.4% | not timed | not timed | 57.91 ± 1.1% | 154.67 ± 4.0% | not timed | not timed | 196.13 ± 7.9% | | 1.01 | 3.41 | 1.28 |
| 10-bounded-repeat/compile-context | 1 | 15.13 ± 0.9% | not timed | not timed | 14.38 ± 0.7% | 20.16 ± 2.5% | not timed | not timed | 15.15 ± 1.0% | | 1.00 | 1.05 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 90.83 ± 0.7% | not timed | not timed | 10.39 ± 0.7% | 28.92 ± 1.5% | not timed | not timed | 90.58 ± 0.9% | | 1.00 | 8.75 | 3.14 |
| 11-unstructured-to-json/compile | 1 | 99.04 ± 0.5% | not timed | not timed | 47.45 ± 0.9% | 78.81 ± 6.1% | not timed | not timed | 98.64 ± 0.8% | | 1.00 | 2.09 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.08 ± 3.1% | 0.11 ± 9.0% | not timed | not timed | 0.35 ± 23.4% | | 1.01 | 4.18 | 3.05 |

