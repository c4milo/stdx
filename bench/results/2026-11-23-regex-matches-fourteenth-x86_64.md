# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127373415 |
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
| literal: a word | 217 | 31515.02 ± 1.3% | 1081.25 ± 0.9% | 36.55 ± 0.6% | 31699.55 ± 0.7% | 12583.53 ± 2.9% | 14.78 ± 0.6% | 114.47 ± 0.7% | 31451.83 ± 1.4% | 29.15 | 1.00 | 0.99 | 2.50 |
| literal: a word that is not there | 0 | 41494.42 ± 1.6% | 1097.28 ± 0.3% | 36.50 ± 0.6% | 35227.08 ± 0.2% | 39274.15 ± 0.3% | 14.34 ± 0.4% | 109.43 ± 0.8% | 41486.16 ± 1.4% | 37.82 | 1.00 | 1.18 | 1.06 |
| literal: one of four words | 661 | 13039.57 ± 2.7% | 1065.87 ± 0.3% | 19.36 ± 1.0% | 9518.82 ± 1.2% | 29.28 ± 0.9% | 4.31 ± 0.2% | 9.65 ± 0.6% | 12897.85 ± 0.6% | 12.23 | 1.01 | 1.37 | 445.33 |
| literal: a word in any case | 217 | 26938.46 ± 0.9% | 1086.50 ± 0.4% | 25.47 ± 0.7% | 9831.53 ± 0.5% | 58.48 ± 0.5% | refused | differs | 26922.08 ± 1.9% | 24.79 | 1.00 | 2.74 | 460.65 |
| literal: an href attribute | 33 | 28360.18 ± 0.2% | 1096.10 ± 0.3% | 32.38 ± 0.7% | 29307.92 ± 0.2% | 2580.71 ± 8.3% | 10.55 ± 0.3% | 101.69 ± 0.8% | 28313.61 ± 1.5% | 25.87 | 1.00 | 0.97 | 10.99 |
| literal: a word, second text | 123 | 33957.76 ± 0.5% | 1090.60 ± 0.4% | 35.56 ± 0.9% | 32647.14 ± 0.2% | 9046.05 ± 1.5% | 19.40 ± 0.7% | 98.71 ± 1.0% | 33985.57 ± 0.7% | 31.14 | 1.00 | 1.04 | 3.75 |
| class: two capitalized words | 1331 | 1007.56 ± 0.5% | 1011.87 ± 0.1% | 33.40 ± 0.4% | 611.50 ± 0.4% | 48.96 ± 0.2% | 12.58 ± 0.2% | 81.82 ± 0.9% | 1006.27 ± 0.5% | 1.00 | 1.00 | 1.65 | 20.58 |
| class: a word that ends in ing | 3399 | 917.35 ± 0.3% | 917.72 ± 0.4% | 21.91 ± 0.6% | 576.48 ± 0.7% | 35.40 ± 6.6% | 7.14 ± 0.2% | 23.31 ± 1.2% | 916.37 ± 0.2% | 1.00 | 1.00 | 1.59 | 25.92 |
| class: a word in capitals | 2332 | 1355.83 ± 0.1% | 984.20 ± 1.2% | 35.89 ± 1.0% | 603.69 ± 0.5% | 52.56 ± 1.8% | 15.25 ± 0.4% | 106.03 ± 0.6% | 1355.50 ± 0.1% | 1.38 | 1.00 | 2.25 | 25.80 |
| class: a number | 8288 | 1979.74 ± 0.4% | 853.32 ± 0.2% | 34.70 ± 0.7% | 2126.86 ± 0.3% | 51.02 ± 12.8% | 0.42 ± 0.1% | 80.26 ± 0.6% | 1980.10 ± 0.2% | 2.32 | 1.00 | 0.93 | 38.80 |
| class: two capitalized words, second text | 5359 | 754.48 ± 0.3% | 753.27 ± 0.6% | 30.16 ± 0.5% | 506.53 ± 0.3% | 42.25 ± 12.2% | 16.54 ± 1.3% | 75.11 ± 0.4% | 752.99 ± 0.2% | 1.00 | 1.00 | 1.49 | 17.86 |
| other: a word between two words | 6104 | 765.99 ± 1.2% | 792.46 ± 0.1% | 29.65 ± 1.0% | 876.22 ± 0.1% | 132.50 ± 16.9% | 9.61 ± 0.1% | 87.39 ± 0.5% | 765.69 ± 0.2% | 0.97 | 1.00 | 0.87 | 5.78 |
| other: a number before a unit, second text | 1481 | 8801.22 ± 1.2% | 1024.48 ± 0.5% | 33.31 ± 1.5% | 9472.54 ± 0.4% | 49.10 ± 10.8% | 17.33 ± 0.1% | 78.82 ± 0.9% | 8684.07 ± 2.4% | 8.59 | 1.01 | 0.93 | 179.24 |
| other: a heading's start tag | 110 | 20850.99 ± 2.9% | 1079.85 ± 0.4% | 35.41 ± 2.6% | 2699.65 ± 0.4% | 1908.21 ± 10.4% | 13.13 ± 0.2% | 119.04 ± 0.7% | 20826.90 ± 0.3% | 19.31 | 1.00 | 7.72 | 10.93 |
| other: a whole word | 217 | 25058.84 ± 0.3% | 1087.88 ± 0.2% | 36.91 ± 1.7% | 25715.86 ± 0.4% | 60.28 ± 0.8% | 12.55 ± 0.2% | 68.48 ± 0.3% | 25063.04 ± 0.4% | 23.03 | 1.00 | 0.97 | 415.73 |
| other: a line's first word, second text | 3716 | 2288.22 ± 3.0% | 908.79 ± 0.2% | 38.65 ± 1.9% | 2261.00 ± 0.6% | 80.54 ± 4.3% | refused | refused | 2276.29 ± 0.6% | 2.52 | 1.01 | 1.01 | 28.41 |
| other: fourteen octets before an x | 87 | 34780.16 ± 0.7% | 299.09 ± 0.6% | 7.47 ± 0.3% | 4104.69 ± 0.8% | 11.56 ± 1.0% | differs | 20.83 ± 0.3% | 34446.04 ± 1.4% | 116.29 | 1.01 | 8.47 | 3007.41 |
| other: a Greek word | 21815 | 489.94 ± 0.5% | 360.30 ± 1.1% | 37.45 ± 1.4% | 313.56 ± 1.0% | 53.53 ± 1.6% | differs | refused | 488.61 ± 0.4% | 1.36 | 1.00 | 1.56 | 9.15 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.92 ± 0.6% | 29.83 ± 0.7% | 1.08 ± 1.3% | 21.47 ± 0.1% | 3.18 ± 0.5% | differs | 4.98 ± 0.3% | 29.91 ± 0.3% | 1.00 | 1.00 | 1.39 | 9.40 |
| a UUID | 32895 | 26.53 ± 0.6% | 26.55 ± 2.6% | 0.77 ± 0.4% | 16.47 ± 0.7% | 3.25 ± 1.1% | 0.70 ± 0.3% | 4.08 ± 1.2% | 26.52 ± 0.7% | 1.00 | 1.00 | 1.61 | 8.17 |
| an IPv4 address | 33176 | 39.64 ± 0.6% | 39.68 ± 0.2% | 2.49 ± 0.7% | 31.59 ± 0.2% | 8.10 ± 0.7% | differs | 4.93 ± 0.5% | 39.57 ± 0.4% | 1.00 | 1.00 | 1.25 | 4.89 |
| a date and time | 32954 | 39.54 ± 0.6% | 39.40 ± 0.5% | 1.78 ± 0.4% | 23.95 ± 0.4% | 10.30 ± 0.2% | 1.28 ± 0.2% | 9.23 ± 0.8% | 39.58 ± 0.9% | 1.00 | 1.00 | 1.65 | 3.84 |
| a field path | 32606 | 32.25 ± 0.2% | 32.30 ± 0.6% | 1.27 ± 0.9% | 24.78 ± 1.0% | 3.71 ± 0.6% | differs | 3.14 ± 0.3% | 32.26 ± 0.2% | 1.00 | 1.00 | 1.30 | 8.69 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.38 ± 0.4% | 12.43 ± 1.2% | 12.40 ± 0.5% | 14.46 ± 1.2% | 6.71 ± 3.3% | 0.99 ± 0.7% | none | 12.40 ± 1.2% | 1.00 | 1.00 | 0.86 | 1.84 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 292.86 ± 0.9% | 293.82 ± 0.6% | 347.20 ± 0.6% | 115.21 ± 1.8% | 260.77 ± 12.6% | 673.71 ± 2.8% | 4289.05 ± 3.2% | 292.82 ± 5.1% | 1.00 | 1.00 | 2.54 | 1.12 |
| a UUID | 62 | 186.48 ± 3.2% | 187.76 ± 1.4% | 210.41 ± 1.2% | 61.17 ± 1.3% | 118.74 ± 4.7% | 250.72 ± 2.3% | 5580.78 ± 2.6% | 187.74 ± 0.9% | 0.99 | 0.99 | 3.05 | 1.57 |
| an IPv4 address | 29 | 564.14 ± 0.3% | 567.68 ± 1.0% | 812.00 ± 3.7% | 99.90 ± 2.9% | 155.60 ± 2.5% | 430.60 ± 0.6% | 10245.62 ± 1.0% | 563.88 ± 1.5% | 0.99 | 1.00 | 5.65 | 3.63 |
| a date and time | 56 | 439.72 ± 0.8% | 441.55 ± 3.7% | 577.87 ± 0.7% | 96.09 ± 1.4% | 165.47 ± 16.3% | 432.52 ± 1.5% | 5588.54 ± 0.5% | 439.17 ± 0.7% | 1.00 | 1.00 | 4.58 | 2.66 |
| a field path | 39 | 284.22 ± 0.3% | 284.89 ± 0.5% | 335.67 ± 0.4% | 105.03 ± 1.2% | 248.10 ± 3.6% | 704.53 ± 2.0% | 5417.37 ± 0.3% | 284.02 ± 4.4% | 1.00 | 1.00 | 2.71 | 1.15 |
| literal: a word | 7 | 889.69 ± 0.5% | 959.67 ± 1.0% | 1818.81 ± 4.0% | 705.73 ± 1.3% | 818.47 ± 1.4% | 1449.72 ± 0.9% | 37077.09 ± 2.5% | 890.82 ± 4.2% | 0.93 | 1.00 | 1.26 | 1.09 |
| literal: a word that is not there | 8 | 853.22 ± 0.9% | 929.83 ± 0.5% | 1720.74 ± 0.6% | 632.75 ± 0.6% | 775.26 ± 7.1% | 1364.16 ± 4.7% | 35601.46 ± 2.6% | 854.00 ± 4.0% | 0.92 | 1.00 | 1.35 | 1.10 |
| literal: one of four words | 26 | 344.86 ± 0.6% | 592.41 ± 1.9% | 841.96 ± 0.2% | 50.71 ± 1.0% | 304.93 ± 12.7% | 501.72 ± 2.2% | 19409.17 ± 1.6% | 345.00 ± 6.0% | 0.58 | 1.00 | 6.80 | 1.13 |
| literal: a word in any case | 11 | 678.82 ± 0.8% | 724.35 ± 0.3% | 1133.04 ± 3.8% | 17.60 ± 2.8% | 862.37 ± 1.4% | refused | 30398.88 ± 1.0% | 679.47 ± 0.9% | 0.94 | 1.00 | 38.57 | 0.79 |
| literal: an href attribute | 12 | 451.82 ± 3.5% | 466.96 ± 1.9% | 626.70 ± 1.6% | 49.84 ± 0.5% | 621.12 ± 0.5% | 1152.84 ± 0.8% | 26625.29 ± 1.0% | 453.46 ± 0.8% | 0.97 | 1.00 | 9.07 | 0.73 |
| literal: a word, second text | 10 | 797.95 ± 1.0% | 879.88 ± 0.7% | 1557.52 ± 0.9% | 594.11 ± 1.2% | 679.44 ± 26.9% | 1177.24 ± 0.4% | 32692.36 ± 4.4% | 800.22 ± 0.5% | 0.91 | 1.00 | 1.34 | 1.17 |
| class: two capitalized words | 23 | 639.46 ± 0.3% | 691.34 ± 0.6% | 1060.34 ± 0.3% | 134.91 ± 0.7% | 641.67 ± 15.8% | 1076.36 ± 0.6% | 7702.94 ± 0.3% | 639.01 ± 0.4% | 0.92 | 1.00 | 4.74 | 1.00 |
| class: a word that ends in ing | 9 | 765.17 ± 0.4% | 874.89 ± 0.3% | 1642.31 ± 3.6% | 171.11 ± 0.5% | 944.70 ± 0.9% | 1732.76 ± 2.9% | 19607.24 ± 4.0% | 763.80 ± 0.6% | 0.87 | 1.00 | 4.47 | 0.81 |
| class: a word in capitals | 16 | 684.53 ± 5.8% | 745.20 ± 0.7% | 1313.71 ± 0.3% | 180.91 ± 2.0% | 935.85 ± 8.2% | 1547.68 ± 0.6% | 10166.00 ± 0.5% | 685.10 ± 1.1% | 0.92 | 1.00 | 3.78 | 0.73 |
| class: a number | 6 | 831.92 ± 2.4% | 927.33 ± 0.8% | 1880.66 ± 0.4% | 44.41 ± 2.1% | 1743.48 ± 0.9% | 2982.51 ± 1.1% | 29840.48 ± 1.6% | 828.42 ± 0.6% | 0.90 | 1.00 | 18.73 | 0.48 |
| class: two capitalized words, second text | 23 | 635.73 ± 0.8% | 692.49 ± 2.4% | 1058.71 ± 0.4% | 134.13 ± 0.4% | 642.24 ± 1.5% | 1090.53 ± 0.9% | 7676.21 ± 0.7% | 637.68 ± 0.6% | 0.92 | 1.00 | 4.74 | 0.99 |
| other: a word between two words | 13 | 763.69 ± 0.2% | 799.93 ± 3.4% | 1335.85 ± 0.4% | 179.70 ± 0.8% | 631.52 ± 1.2% | 1189.40 ± 2.0% | 18133.23 ± 1.7% | 762.32 ± 3.4% | 0.95 | 1.00 | 4.25 | 1.21 |
| other: a number before a unit, second text | 15 | 534.54 ± 0.3% | 593.01 ± 0.5% | 848.28 ± 0.3% | 41.59 ± 0.5% | 791.49 ± 10.1% | 1347.80 ± 2.1% | 19092.83 ± 3.0% | 534.56 ± 1.7% | 0.90 | 1.00 | 12.85 | 0.68 |
| other: a heading's start tag | 13 | 471.42 ± 1.1% | 479.03 ± 0.5% | 646.04 ± 1.5% | 47.85 ± 0.5% | 774.92 ± 1.3% | 1297.45 ± 1.7% | 22968.26 ± 1.0% | 470.98 ± 0.8% | 0.98 | 1.00 | 9.85 | 0.61 |
| other: a whole word | 11 | 798.77 ± 3.8% | 858.10 ± 0.4% | 1483.49 ± 3.7% | 160.44 ± 0.8% | 724.30 ± 3.8% | 1258.19 ± 0.4% | 32407.38 ± 0.6% | 799.33 ± 0.5% | 0.93 | 1.00 | 4.98 | 1.10 |
| other: a line's first word, second text | 17 | 729.85 ± 0.2% | 762.13 ± 0.3% | 1289.55 ± 0.7% | 171.37 ± 1.0% | 879.79 ± 1.5% | refused | refused | 726.85 ± 0.3% | 0.96 | 1.00 | 4.26 | 0.83 |
| other: fourteen octets before an x | 16 | 133.03 ± 4.1% | 192.67 ± 0.4% | 227.33 ± 0.2% | 18.67 ± 0.6% | 556.70 ± 1.2% | 588.65 ± 1.1% | 16378.49 ± 0.7% | 133.17 ± 0.3% | 0.69 | 1.00 | 7.12 | 0.24 |
| other: a Greek word | 8 | 549.19 ± 0.3% | 775.67 ± 0.3% | 1332.30 ± 0.5% | 61.63 ± 0.8% | 1729.36 ± 1.4% | 2852.60 ± 1.1% | refused | 549.23 ± 0.8% | 0.71 | 1.00 | 8.91 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23446.01 ± 1.0% | not timed | not timed | 28696.70 ± 0.5% | 2699.30 ± 20.7% | not timed | not timed | 23408.39 ± 0.5% | | 1.00 | 0.82 | 8.69 |
| 01-literal/sherlock-casei-en | 522 | 5521.13 ± 1.0% | not timed | not timed | 8459.55 ± 0.3% | 39.95 ± 1.5% | not timed | not timed | 5529.77 ± 1.0% | | 1.00 | 0.65 | 138.21 |
| 01-literal/sherlock-ru | 724 | 24508.59 ± 1.0% | not timed | not timed | 28020.92 ± 0.5% | 1535.11 ± 4.4% | not timed | not timed | 24527.81 ± 0.7% | | 1.00 | 0.87 | 15.97 |
| 01-literal/sherlock-casei-ru | 746 | 8563.29 ± 0.4% | not timed | not timed | 6511.57 ± 0.9% | 42.59 ± 3.6% | not timed | not timed | 8532.13 ± 0.4% | | 1.00 | 1.32 | 201.06 |
| 01-literal/sherlock-zh | 30 | 38121.45 ± 0.4% | not timed | not timed | 35123.36 ± 0.3% | 1597.42 ± 0.7% | not timed | not timed | 38089.21 ± 0.2% | | 1.00 | 1.09 | 23.86 |
| 02-literal-alternate/sherlock-en | 714 | 12206.73 ± 1.2% | not timed | not timed | 9412.45 ± 0.2% | 22.40 ± 0.7% | not timed | not timed | 12155.42 ± 0.5% | | 1.00 | 1.30 | 544.89 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2042.49 ± 0.9% | not timed | not timed | 2303.08 ± 0.2% | 13.63 ± 20.8% | not timed | not timed | 2027.42 ± 0.8% | | 1.01 | 0.89 | 149.80 |
| 02-literal-alternate/sherlock-ru | 899 | 7007.01 ± 0.7% | not timed | not timed | 5159.30 ± 0.6% | 28.91 ± 1.3% | not timed | not timed | 7060.36 ± 1.4% | | 0.99 | 1.36 | 242.34 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2130.48 ± 0.5% | not timed | not timed | 1249.29 ± 0.3% | 11.78 ± 0.3% | not timed | not timed | 2122.61 ± 0.3% | | 1.00 | 1.71 | 180.93 |
| 02-literal-alternate/sherlock-zh | 207 | 16494.42 ± 0.6% | not timed | not timed | 10754.95 ± 0.3% | 41.53 ± 0.8% | not timed | not timed | 16466.12 ± 0.2% | | 1.00 | 1.53 | 397.14 |
| 03-date/ascii | 111817 | 125.89 ± 0.7% | not timed | not timed | 109.90 ± 0.8% | 0.27 ± 7.1% | not timed | not timed | 125.67 ± 1.3% | | 1.00 | 1.15 | 464.03 |
| 04-ruff-noqa/real | 84 | 710.02 ± 1.3% | not timed | not timed | 564.29 ± 0.5% | 25.66 ± 1.8% | not timed | not timed | 723.21 ± 1.2% | | 0.98 | 1.26 | 27.67 |
| 04-ruff-noqa/tweaked | 44 | 625.26 ± 1.3% | not timed | not timed | 562.21 ± 0.5% | 392.28 ± 4.1% | not timed | not timed | 624.36 ± 1.4% | | 1.00 | 1.11 | 1.59 |
| 05-lexer-veryl/single | 124800 | 3.99 ± 2.5% | not timed | not timed | 5.69 ± 0.5% | 0.26 ± 7.7% | not timed | not timed | 3.95 ± 3.3% | | 1.01 | 0.70 | 15.06 |
| 06-cloud-flare-redos/original | 107 | 309.15 ± 0.4% | not timed | not timed | 261.51 ± 0.6% | 31.87 ± 0.9% | not timed | not timed | 308.99 ± 0.4% | | 1.00 | 1.18 | 9.70 |
| 06-cloud-flare-redos/simplified-short | 102 | 285.65 ± 1.9% | not timed | not timed | 266.60 ± 0.2% | 34.90 ± 4.7% | not timed | not timed | 285.60 ± 0.2% | | 1.00 | 1.07 | 8.18 |
| 06-cloud-flare-redos/simplified-long | 10000 | 295.79 ± 1.6% | not timed | not timed | 278.42 ± 0.7% | 37.78 ± 0.7% | not timed | not timed | 295.66 ± 0.9% | | 1.00 | 1.06 | 7.83 |
| 07-unicode-character-data/parse-line | 558784 | 273.90 ± 0.6% | not timed | not timed | 206.04 ± 0.6% | 53.48 ± 0.9% | not timed | not timed | 273.01 ± 0.5% | | 1.00 | 1.33 | 5.12 |
| 08-words/all-english | 56691 | 116.01 ± 0.8% | not timed | not timed | 92.58 ± 0.6% | 14.18 ± 5.8% | not timed | not timed | 116.08 ± 0.6% | | 1.00 | 1.25 | 8.18 |
| 08-words/long-english | 839 | 1044.41 ± 0.3% | not timed | not timed | 622.80 ± 0.1% | 37.82 ± 0.6% | not timed | not timed | 1044.75 ± 0.3% | | 1.00 | 1.68 | 27.62 |
| 09-aws-keys/full | 0 | 561.83 ± 1.8% | not timed | not timed | 577.50 ± 0.3% | 82.36 ± 4.1% | not timed | not timed | 563.33 ± 1.1% | | 1.00 | 0.97 | 6.82 |
| 09-aws-keys/quick | 0 | 1093.43 ± 5.0% | not timed | not timed | 904.85 ± 2.8% | 425.97 ± 19.0% | not timed | not timed | 1084.50 ± 5.4% | | 1.01 | 1.21 | 2.57 |
| 10-bounded-repeat/letters-en | 1833 | 628.32 ± 0.5% | not timed | not timed | 521.77 ± 0.3% | 24.20 ± 0.5% | not timed | not timed | 626.91 ± 1.1% | | 1.00 | 1.20 | 25.97 |
| 10-bounded-repeat/letters-ru | 3475 | 385.30 ± 0.4% | not timed | not timed | 493.81 ± 0.4% | 26.96 ± 26.9% | not timed | not timed | 384.20 ± 0.3% | | 1.00 | 0.78 | 14.29 |
| 10-bounded-repeat/context | 53 | 89.35 ± 1.6% | not timed | not timed | 73.20 ± 0.7% | 24.26 ± 1.0% | not timed | not timed | 71.48 ± 1.1% | | 1.25 | 1.22 | 3.68 |
| 10-bounded-repeat/capitals | 11 | 1077.06 ± 0.3% | not timed | not timed | 639.84 ± 0.3% | 44.84 ± 1.9% | not timed | not timed | 1073.86 ± 0.4% | | 1.00 | 1.68 | 24.02 |
| 11-unstructured-to-json/extract | 600 | 46.91 ± 2.9% | not timed | not timed | 80.71 ± 0.6% | 64.18 ± 0.3% | not timed | not timed | 46.81 ± 0.7% | | 1.00 | 0.58 | 0.73 |
| 12-dictionary/single | 1 | 569.46 ± 1.9% | not timed | not timed | 545.61 ± 0.5% | 0.51 ± 3.8% | not timed | not timed | 571.35 ± 0.4% | | 1.00 | 1.04 | 1115.26 |
| 14-quadratic/1x | 100 | 14.67 ± 0.4% | not timed | not timed | 13.48 ± 0.2% | 1.24 ± 3.7% | not timed | not timed | 14.62 ± 0.6% | | 1.00 | 1.09 | 11.85 |
| 14-quadratic/2x | 200 | 8.70 ± 0.3% | not timed | not timed | 6.60 ± 0.6% | 0.69 ± 1.1% | not timed | not timed | 8.67 ± 1.8% | | 1.00 | 1.32 | 12.66 |
| 14-quadratic/10x | 1000 | 1.94 ± 0.2% | not timed | not timed | 1.29 ± 0.3% | 0.15 ± 1.3% | not timed | not timed | 1.93 ± 1.1% | | 1.00 | 1.50 | 12.71 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.00 ± 0.4% | not timed | not timed | 0.45 ± 0.6% | 0.65 ± 2.8% | not timed | not timed | 1.99 ± 0.3% | | 1.00 | 4.46 | 3.05 |
| 04-ruff-noqa/compile-real | 1 | 128.70 ± 0.3% | not timed | not timed | 15.78 ± 0.9% | 176.03 ± 1.1% | not timed | not timed | 128.44 ± 0.6% | | 1.00 | 8.15 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 21.76 ± 0.7% | not timed | not timed | 3.04 ± 1.3% | 7.74 ± 4.3% | not timed | not timed | 21.76 ± 0.5% | | 1.00 | 7.15 | 2.81 |
| 07-unicode-character-data/compile | 1 | 77.54 ± 0.7% | not timed | not timed | 31.45 ± 0.5% | 43.83 ± 1.6% | not timed | not timed | 77.14 ± 1.2% | | 1.01 | 2.47 | 1.77 |
| 09-aws-keys/compile-full | 1 | 53.35 ± 0.6% | not timed | not timed | 9.05 ± 0.3% | 27.95 ± 2.3% | not timed | not timed | 53.13 ± 0.7% | | 1.00 | 5.90 | 1.91 |
| 09-aws-keys/compile-quick | 1 | 247.97 ± 0.7% | not timed | not timed | 59.40 ± 4.1% | 163.28 ± 4.1% | not timed | not timed | 246.22 ± 1.5% | | 1.01 | 4.17 | 1.52 |
| 10-bounded-repeat/compile-context | 1 | 16.58 ± 7.1% | not timed | not timed | 14.42 ± 3.7% | 20.26 ± 4.6% | not timed | not timed | 16.69 ± 0.7% | | 0.99 | 1.15 | 0.82 |
| 10-bounded-repeat/compile-capitals | 1 | 103.43 ± 0.3% | not timed | not timed | 10.86 ± 0.2% | 29.28 ± 4.4% | not timed | not timed | 102.07 ± 4.8% | | 1.01 | 9.53 | 3.53 |
| 11-unstructured-to-json/compile | 1 | 118.43 ± 0.9% | not timed | not timed | 49.56 ± 0.8% | 83.57 ± 2.9% | not timed | not timed | 118.22 ± 0.4% | | 1.00 | 2.39 | 1.42 |
| 12-dictionary/compile-single | 1 | 0.38 ± 0.3% | not timed | not timed | 0.08 ± 10.4% | 0.12 ± 17.3% | not timed | not timed | 0.37 ± 1.5% | | 1.01 | 4.64 | 3.20 |

