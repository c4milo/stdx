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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102062604 |
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
| literal: a word | 217 | 32518.92 ± 0.5% | 1086.88 ± 0.3% | 35.28 ± 5.6% | 32708.71 ± 0.6% | 12578.83 ± 11.3% | 14.35 ± 0.3% | 114.85 ± 0.6% | 32480.16 ± 0.1% | 29.92 | 1.00 | 0.99 | 2.59 |
| literal: a word that is not there | 0 | 42566.50 ± 0.7% | 1099.63 ± 0.4% | 34.81 ± 1.3% | 36253.02 ± 0.6% | 40144.33 ± 0.9% | 14.38 ± 0.4% | 110.14 ± 0.6% | 42384.57 ± 1.2% | 38.71 | 1.00 | 1.17 | 1.06 |
| literal: one of four words | 661 | 13088.09 ± 1.4% | 1055.55 ± 0.7% | 18.95 ± 1.1% | 9627.09 ± 1.2% | 28.99 ± 0.8% | 4.26 ± 0.4% | 9.63 ± 1.1% | 12976.70 ± 0.6% | 12.40 | 1.01 | 1.36 | 451.41 |
| literal: a word in any case | 217 | 27056.48 ± 0.8% | 1081.06 ± 0.5% | 24.62 ± 0.5% | 9969.52 ± 0.5% | 58.08 ± 0.9% | refused | differs | 27042.52 ± 0.3% | 25.03 | 1.00 | 2.71 | 465.85 |
| literal: an href attribute | 33 | 27905.70 ± 1.0% | 1087.72 ± 1.0% | 30.91 ± 1.3% | 28852.10 ± 1.6% | 2584.55 ± 0.5% | 10.50 ± 0.4% | 100.89 ± 0.7% | 27910.34 ± 1.0% | 25.66 | 1.00 | 0.97 | 10.80 |
| literal: a word, second text | 123 | 33728.65 ± 4.6% | 1088.73 ± 0.2% | 33.62 ± 2.0% | 32555.75 ± 0.8% | 8927.63 ± 5.6% | 19.11 ± 0.5% | 94.40 ± 0.3% | 33678.93 ± 0.9% | 30.98 | 1.00 | 1.04 | 3.78 |
| class: two capitalized words | 1331 | 1005.71 ± 0.9% | 997.02 ± 0.8% | 32.72 ± 1.9% | 610.08 ± 0.5% | 49.01 ± 0.5% | 12.50 ± 0.2% | 82.11 ± 0.4% | 1006.91 ± 0.6% | 1.01 | 1.00 | 1.65 | 20.52 |
| class: a word that ends in ing | 3399 | 912.12 ± 0.5% | 910.54 ± 0.7% | 21.12 ± 0.8% | 571.81 ± 0.8% | 35.27 ± 11.5% | 7.06 ± 0.3% | 23.32 ± 1.0% | 910.36 ± 0.4% | 1.00 | 1.00 | 1.60 | 25.86 |
| class: a word in capitals | 2332 | 1361.17 ± 0.9% | 977.30 ± 0.9% | 34.41 ± 2.3% | 598.53 ± 0.5% | 52.45 ± 1.8% | 14.98 ± 0.6% | 105.91 ± 0.5% | 1360.11 ± 0.7% | 1.39 | 1.00 | 2.27 | 25.95 |
| class: a number | 8288 | 2026.16 ± 1.1% | 831.77 ± 0.9% | 33.40 ± 1.6% | 1925.33 ± 1.5% | 55.03 ± 9.4% | 0.42 ± 0.2% | 80.36 ± 0.4% | 2028.56 ± 0.7% | 2.44 | 1.00 | 1.05 | 36.82 |
| class: two capitalized words, second text | 5359 | 723.32 ± 0.3% | 722.78 ± 0.5% | 28.79 ± 2.7% | 506.11 ± 0.3% | 42.34 ± 14.2% | 16.33 ± 0.3% | 75.19 ± 1.3% | 722.20 ± 0.3% | 1.00 | 1.00 | 1.43 | 17.08 |
| other: a word between two words | 6104 | 732.12 ± 1.0% | 778.16 ± 0.1% | 28.82 ± 1.2% | 875.14 ± 0.5% | 135.66 ± 4.5% | 9.59 ± 0.2% | 87.30 ± 0.8% | 731.96 ± 0.4% | 0.94 | 1.00 | 0.84 | 5.40 |
| other: a number before a unit, second text | 1481 | 8874.51 ± 1.7% | 1019.06 ± 0.3% | 32.49 ± 2.9% | 9535.17 ± 0.5% | 49.16 ± 1.1% | 17.10 ± 0.3% | 78.96 ± 0.3% | 8758.97 ± 0.3% | 8.71 | 1.01 | 0.93 | 180.52 |
| other: a heading's start tag | 110 | 20534.70 ± 0.7% | 1084.86 ± 0.2% | 33.86 ± 2.3% | 2671.77 ± 1.6% | 1911.20 ± 7.5% | 13.12 ± 3.3% | 119.83 ± 0.9% | 20514.44 ± 0.5% | 18.93 | 1.00 | 7.69 | 10.74 |
| other: a whole word | 217 | 25323.39 ± 0.4% | 1085.86 ± 0.2% | 35.90 ± 1.8% | 26190.41 ± 2.5% | 60.29 ± 0.8% | 12.51 ± 0.2% | 68.53 ± 0.2% | 25288.91 ± 1.0% | 23.32 | 1.00 | 0.97 | 420.01 |
| other: a line's first word, second text | 3716 | 2366.20 ± 0.4% | 894.05 ± 0.3% | 38.02 ± 1.8% | 2444.93 ± 0.4% | 81.33 ± 3.8% | refused | refused | 2353.87 ± 0.5% | 2.65 | 1.01 | 0.97 | 29.10 |
| other: fourteen octets before an x | 87 | 36110.46 ± 2.8% | 296.26 ± 2.1% | 6.60 ± 0.2% | 4175.71 ± 0.5% | 11.64 ± 0.6% | differs | 20.73 ± 0.6% | 36063.22 ± 2.8% | 121.89 | 1.00 | 8.65 | 3103.28 |
| other: a Greek word | 21815 | 489.26 ± 0.3% | 344.21 ± 0.4% | 37.28 ± 1.4% | 312.35 ± 0.2% | 63.02 ± 11.9% | differs | refused | 488.28 ± 1.7% | 1.42 | 1.00 | 1.57 | 7.76 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.64 ± 0.6% | 29.63 ± 2.4% | 1.10 ± 0.1% | 21.48 ± 0.2% | 3.19 ± 0.6% | differs | 5.00 ± 0.4% | 29.66 ± 0.4% | 1.00 | 1.00 | 1.38 | 9.28 |
| a UUID | 32895 | 26.27 ± 0.4% | 26.29 ± 0.6% | 0.76 ± 0.4% | 16.39 ± 0.5% | 3.22 ± 1.9% | 0.71 ± 0.1% | 4.14 ± 0.6% | 26.33 ± 0.3% | 1.00 | 1.00 | 1.60 | 8.17 |
| an IPv4 address | 33176 | 39.19 ± 0.6% | 39.20 ± 0.3% | 2.42 ± 0.8% | 31.56 ± 0.3% | 8.12 ± 0.4% | differs | 4.88 ± 1.6% | 39.17 ± 0.3% | 1.00 | 1.00 | 1.24 | 4.83 |
| a date and time | 32954 | 38.56 ± 0.7% | 38.32 ± 0.6% | 1.76 ± 0.3% | 23.95 ± 0.8% | 10.24 ± 1.1% | 1.32 ± 0.1% | 9.28 ± 0.8% | 38.56 ± 0.5% | 1.01 | 1.00 | 1.61 | 3.77 |
| a field path | 32606 | 32.17 ± 0.4% | 32.11 ± 0.5% | 1.26 ± 0.9% | 24.74 ± 0.6% | 3.72 ± 1.0% | differs | 3.14 ± 0.6% | 31.96 ± 0.8% | 1.00 | 1.01 | 1.30 | 8.66 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.02 ± 1.1% | 10.05 ± 0.3% | 10.04 ± 1.8% | 14.75 ± 0.6% | 6.68 ± 1.1% | 1.04 ± 0.5% | none | 10.02 ± 1.0% | 1.00 | 1.00 | 0.68 | 1.50 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 278.15 ± 0.3% | 280.27 ± 0.5% | 325.87 ± 0.8% | 116.86 ± 1.4% | 263.45 ± 1.7% | 690.34 ± 1.8% | 4325.00 ± 1.0% | 278.19 ± 0.8% | 0.99 | 1.00 | 2.38 | 1.06 |
| a UUID | 62 | 177.15 ± 0.4% | 178.00 ± 0.3% | 196.81 ± 0.4% | 61.42 ± 1.1% | 117.25 ± 1.8% | 255.67 ± 2.0% | 5592.50 ± 1.3% | 176.77 ± 0.5% | 1.00 | 1.00 | 2.88 | 1.51 |
| an IPv4 address | 29 | 575.72 ± 0.8% | 582.43 ± 1.3% | 826.31 ± 0.8% | 99.51 ± 0.8% | 156.25 ± 1.4% | 429.01 ± 1.4% | 10216.80 ± 0.5% | 576.14 ± 0.8% | 0.99 | 1.00 | 5.79 | 3.68 |
| a date and time | 56 | 450.46 ± 0.2% | 455.02 ± 1.8% | 583.88 ± 0.2% | 96.48 ± 0.9% | 163.19 ± 4.5% | 448.85 ± 0.5% | 5566.45 ± 0.5% | 450.39 ± 0.5% | 0.99 | 1.00 | 4.67 | 2.76 |
| a field path | 39 | 264.96 ± 0.6% | 265.38 ± 0.7% | 304.42 ± 1.2% | 105.87 ± 1.4% | 248.00 ± 3.0% | 708.27 ± 1.8% | 5389.34 ± 0.9% | 265.03 ± 0.5% | 1.00 | 1.00 | 2.50 | 1.07 |
| literal: a word | 7 | 925.72 ± 0.5% | 989.99 ± 0.4% | 1830.51 ± 0.7% | 711.27 ± 0.4% | 814.48 ± 12.6% | 1438.10 ± 0.4% | 37535.24 ± 3.3% | 925.81 ± 0.5% | 0.94 | 1.00 | 1.30 | 1.14 |
| literal: a word that is not there | 8 | 883.71 ± 0.7% | 953.35 ± 0.7% | 1724.14 ± 1.1% | 637.40 ± 1.1% | 721.94 ± 10.2% | 1348.23 ± 0.5% | 35787.08 ± 2.6% | 883.61 ± 1.6% | 0.93 | 1.00 | 1.39 | 1.22 |
| literal: one of four words | 26 | 347.38 ± 0.8% | 599.34 ± 0.4% | 841.39 ± 0.5% | 50.94 ± 1.1% | 298.49 ± 8.4% | 501.85 ± 2.1% | 19212.34 ± 0.9% | 347.70 ± 0.8% | 0.58 | 1.00 | 6.82 | 1.16 |
| literal: a word in any case | 11 | 698.97 ± 0.8% | 743.45 ± 0.4% | 1133.89 ± 0.5% | 17.67 ± 0.4% | 851.76 ± 0.8% | refused | 30245.88 ± 0.5% | 697.98 ± 0.3% | 0.94 | 1.00 | 39.57 | 0.82 |
| literal: an href attribute | 12 | 464.33 ± 1.2% | 471.93 ± 0.4% | 618.44 ± 1.3% | 50.06 ± 0.6% | 614.51 ± 18.1% | 1143.03 ± 0.5% | 27387.61 ± 1.8% | 460.23 ± 3.9% | 0.98 | 1.01 | 9.28 | 0.76 |
| literal: a word, second text | 10 | 819.64 ± 0.5% | 902.96 ± 4.2% | 1563.74 ± 0.4% | 592.77 ± 4.8% | 681.94 ± 1.3% | 1167.53 ± 4.2% | 32447.11 ± 2.7% | 819.02 ± 1.4% | 0.91 | 1.00 | 1.38 | 1.20 |
| class: two capitalized words | 23 | 658.32 ± 0.4% | 713.93 ± 0.4% | 1069.20 ± 0.8% | 136.26 ± 3.2% | 632.59 ± 17.3% | 1119.53 ± 4.3% | 7694.49 ± 0.8% | 656.60 ± 5.6% | 0.92 | 1.00 | 4.83 | 1.04 |
| class: a word that ends in ing | 9 | 796.86 ± 0.5% | 906.76 ± 0.4% | 1641.80 ± 0.5% | 173.69 ± 2.5% | 932.65 ± 10.8% | 1719.08 ± 2.6% | 20330.33 ± 0.8% | 796.83 ± 0.4% | 0.88 | 1.00 | 4.59 | 0.85 |
| class: a word in capitals | 16 | 722.93 ± 3.0% | 790.45 ± 0.4% | 1332.49 ± 0.6% | 182.39 ± 4.5% | 928.78 ± 6.9% | 1596.50 ± 1.2% | 10138.32 ± 2.5% | 722.30 ± 2.9% | 0.91 | 1.00 | 3.96 | 0.78 |
| class: a number | 6 | 880.41 ± 0.3% | 981.32 ± 0.3% | 1903.89 ± 0.4% | 44.31 ± 1.2% | 1724.28 ± 1.2% | 3023.04 ± 5.3% | 30263.43 ± 0.1% | 881.78 ± 0.4% | 0.90 | 1.00 | 19.87 | 0.51 |
| class: two capitalized words, second text | 23 | 657.60 ± 5.4% | 714.59 ± 0.3% | 1067.96 ± 4.8% | 135.53 ± 0.3% | 636.36 ± 1.7% | 1135.87 ± 0.5% | 7724.52 ± 0.4% | 657.78 ± 0.5% | 0.92 | 1.00 | 4.85 | 1.03 |
| other: a word between two words | 13 | 789.78 ± 0.5% | 819.78 ± 0.3% | 1334.74 ± 0.4% | 183.10 ± 1.3% | 624.13 ± 14.1% | 1211.84 ± 1.9% | 18356.49 ± 1.0% | 786.40 ± 3.1% | 0.96 | 1.00 | 4.31 | 1.27 |
| other: a number before a unit, second text | 15 | 527.19 ± 0.3% | 583.54 ± 1.6% | 800.74 ± 0.5% | 41.57 ± 3.0% | 789.74 ± 1.3% | 1355.59 ± 1.3% | 19102.15 ± 1.2% | 526.85 ± 0.3% | 0.90 | 1.00 | 12.68 | 0.67 |
| other: a heading's start tag | 13 | 479.30 ± 0.5% | 485.40 ± 3.8% | 634.73 ± 0.2% | 47.92 ± 0.2% | 767.68 ± 4.6% | 1301.92 ± 0.9% | 22983.61 ± 4.3% | 479.06 ± 1.2% | 0.99 | 1.00 | 10.00 | 0.62 |
| other: a whole word | 11 | 832.07 ± 1.1% | 886.89 ± 3.8% | 1492.17 ± 0.8% | 162.54 ± 1.9% | 724.14 ± 3.0% | 1238.03 ± 1.1% | 32221.62 ± 2.4% | 832.14 ± 2.8% | 0.94 | 1.00 | 5.12 | 1.15 |
| other: a line's first word, second text | 17 | 760.84 ± 1.5% | 794.34 ± 0.3% | 1299.69 ± 0.6% | 173.91 ± 0.6% | 871.91 ± 13.0% | refused | refused | 758.80 ± 0.3% | 0.96 | 1.00 | 4.37 | 0.87 |
| other: fourteen octets before an x | 16 | 133.70 ± 0.8% | 191.95 ± 3.3% | 222.96 ± 0.6% | 18.52 ± 0.6% | 548.23 ± 2.7% | 601.92 ± 0.7% | 16297.47 ± 0.6% | 133.83 ± 0.3% | 0.70 | 1.00 | 7.22 | 0.24 |
| other: a Greek word | 8 | 580.44 ± 1.2% | 794.87 ± 3.7% | 1305.41 ± 0.5% | 61.26 ± 0.8% | 1704.33 ± 10.6% | 2889.99 ± 0.2% | refused | 577.54 ± 0.4% | 0.73 | 1.01 | 9.47 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23555.57 ± 0.7% | not timed | not timed | 28904.39 ± 1.1% | 2592.40 ± 14.6% | not timed | not timed | 23454.62 ± 0.7% | | 1.00 | 0.81 | 9.09 |
| 01-literal/sherlock-casei-en | 522 | 5177.08 ± 1.9% | not timed | not timed | 8418.05 ± 0.5% | 39.95 ± 3.9% | not timed | not timed | 5175.67 ± 0.5% | | 1.00 | 0.61 | 129.59 |
| 01-literal/sherlock-ru | 724 | 25200.36 ± 0.5% | not timed | not timed | 29063.87 ± 0.5% | 1548.79 ± 9.2% | not timed | not timed | 25073.15 ± 1.2% | | 1.01 | 0.87 | 16.27 |
| 01-literal/sherlock-casei-ru | 746 | 8501.61 ± 0.3% | not timed | not timed | 6552.69 ± 0.5% | 42.68 ± 5.7% | not timed | not timed | 8417.79 ± 0.5% | | 1.01 | 1.30 | 199.21 |
| 01-literal/sherlock-zh | 30 | 38129.38 ± 0.2% | not timed | not timed | 35209.20 ± 2.4% | 1607.20 ± 0.9% | not timed | not timed | 38164.45 ± 0.1% | | 1.00 | 1.08 | 23.72 |
| 02-literal-alternate/sherlock-en | 714 | 12132.26 ± 3.6% | not timed | not timed | 9402.41 ± 0.3% | 22.44 ± 30.4% | not timed | not timed | 12085.49 ± 0.6% | | 1.00 | 1.29 | 540.76 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2026.32 ± 2.3% | not timed | not timed | 2309.73 ± 1.7% | 13.66 ± 0.6% | not timed | not timed | 2011.49 ± 0.3% | | 1.01 | 0.88 | 148.30 |
| 02-literal-alternate/sherlock-ru | 899 | 7044.72 ± 0.4% | not timed | not timed | 5152.68 ± 0.5% | 29.03 ± 0.5% | not timed | not timed | 7036.05 ± 0.3% | | 1.00 | 1.37 | 242.70 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2133.40 ± 0.5% | not timed | not timed | 1255.06 ± 1.6% | 11.75 ± 0.6% | not timed | not timed | 2129.88 ± 1.6% | | 1.00 | 1.70 | 181.64 |
| 02-literal-alternate/sherlock-zh | 207 | 16402.05 ± 5.8% | not timed | not timed | 10743.77 ± 0.2% | 41.61 ± 0.4% | not timed | not timed | 16382.32 ± 0.2% | | 1.00 | 1.53 | 394.19 |
| 03-date/ascii | 111817 | 124.53 ± 1.0% | not timed | not timed | 110.69 ± 0.4% | 0.27 ± 2.0% | not timed | not timed | 123.95 ± 0.4% | | 1.00 | 1.13 | 467.63 |
| 04-ruff-noqa/real | 84 | 714.27 ± 3.0% | not timed | not timed | 562.54 ± 0.3% | 25.89 ± 1.6% | not timed | not timed | 717.38 ± 2.6% | | 1.00 | 1.27 | 27.58 |
| 04-ruff-noqa/tweaked | 44 | 636.45 ± 0.3% | not timed | not timed | 562.56 ± 2.1% | 454.22 ± 13.4% | not timed | not timed | 635.15 ± 0.3% | | 1.00 | 1.13 | 1.40 |
| 05-lexer-veryl/single | 124800 | 4.17 ± 3.1% | not timed | not timed | 5.74 ± 4.6% | 0.27 ± 4.2% | not timed | not timed | 4.18 ± 2.1% | | 1.00 | 0.73 | 15.73 |
| 06-cloud-flare-redos/original | 107 | 250.52 ± 0.6% | not timed | not timed | 262.28 ± 0.3% | 32.20 ± 0.5% | not timed | not timed | 250.47 ± 5.7% | | 1.00 | 0.96 | 7.78 |
| 06-cloud-flare-redos/simplified-short | 102 | 174.63 ± 0.1% | not timed | not timed | 267.48 ± 0.3% | 35.16 ± 0.3% | not timed | not timed | 174.51 ± 0.5% | | 1.00 | 0.65 | 4.97 |
| 06-cloud-flare-redos/simplified-long | 10000 | 188.22 ± 2.5% | not timed | not timed | 279.70 ± 1.4% | 38.11 ± 2.1% | not timed | not timed | 188.33 ± 2.8% | | 1.00 | 0.67 | 4.94 |
| 07-unicode-character-data/parse-line | 558784 | 52.67 ± 2.8% | not timed | not timed | 207.74 ± 0.2% | 53.68 ± 5.9% | not timed | not timed | 52.74 ± 0.8% | | 1.00 | 0.25 | 0.98 |
| 08-words/all-english | 56691 | 105.41 ± 0.8% | not timed | not timed | 93.55 ± 0.8% | 14.33 ± 3.4% | not timed | not timed | 104.92 ± 0.6% | | 1.00 | 1.13 | 7.35 |
| 08-words/long-english | 839 | 1042.53 ± 0.3% | not timed | not timed | 624.65 ± 0.2% | 37.71 ± 0.4% | not timed | not timed | 1041.70 ± 0.1% | | 1.00 | 1.67 | 27.65 |
| 09-aws-keys/full | 0 | 572.50 ± 0.2% | not timed | not timed | 573.93 ± 0.1% | 71.17 ± 1.1% | not timed | not timed | 571.76 ± 0.2% | | 1.00 | 1.00 | 8.04 |
| 09-aws-keys/quick | 0 | 568.88 ± 0.2% | not timed | not timed | 911.33 ± 0.6% | 520.51 ± 1.1% | not timed | not timed | 567.02 ± 0.1% | | 1.00 | 0.62 | 1.09 |
| 10-bounded-repeat/letters-en | 1833 | 605.71 ± 0.2% | not timed | not timed | 551.86 ± 0.2% | 24.07 ± 0.6% | not timed | not timed | 604.43 ± 0.2% | | 1.00 | 1.10 | 25.16 |
| 10-bounded-repeat/letters-ru | 3475 | 392.67 ± 0.4% | not timed | not timed | 495.18 ± 0.3% | 25.06 ± 18.5% | not timed | not timed | 392.25 ± 0.3% | | 1.00 | 0.79 | 15.67 |
| 10-bounded-repeat/context | 53 | 84.11 ± 1.4% | not timed | not timed | 74.49 ± 1.1% | 24.09 ± 0.4% | not timed | not timed | 84.08 ± 0.8% | | 1.00 | 1.13 | 3.49 |
| 10-bounded-repeat/capitals | 11 | 1087.92 ± 0.2% | not timed | not timed | 641.52 ± 0.1% | 44.49 ± 0.3% | not timed | not timed | 1086.88 ± 0.3% | | 1.00 | 1.70 | 24.45 |
| 11-unstructured-to-json/extract | 600 | 29.24 ± 0.1% | not timed | not timed | 81.30 ± 0.5% | 64.10 ± 0.2% | not timed | not timed | 29.10 ± 1.0% | | 1.00 | 0.36 | 0.46 |
| 12-dictionary/single | 1 | 569.45 ± 0.3% | not timed | not timed | 548.07 ± 0.3% | 0.52 ± 0.2% | not timed | not timed | 572.19 ± 0.2% | | 1.00 | 1.04 | 1097.70 |
| 14-quadratic/1x | 100 | 14.39 ± 0.4% | not timed | not timed | 13.49 ± 0.3% | 1.25 ± 2.0% | not timed | not timed | 14.40 ± 0.2% | | 1.00 | 1.07 | 11.48 |
| 14-quadratic/2x | 200 | 8.63 ± 0.4% | not timed | not timed | 6.61 ± 0.2% | 0.69 ± 0.8% | not timed | not timed | 8.59 ± 0.4% | | 1.00 | 1.31 | 12.48 |
| 14-quadratic/10x | 1000 | 1.93 ± 0.2% | not timed | not timed | 1.29 ± 0.2% | 0.15 ± 1.3% | not timed | not timed | 1.92 ± 0.3% | | 1.00 | 1.49 | 12.74 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.05 ± 0.4% | not timed | not timed | 0.45 ± 0.7% | 0.66 ± 2.2% | not timed | not timed | 2.04 ± 0.9% | | 1.01 | 4.56 | 3.12 |
| 04-ruff-noqa/compile-real | 1 | 129.08 ± 0.4% | not timed | not timed | 15.89 ± 0.5% | 174.54 ± 1.1% | not timed | not timed | 128.06 ± 5.0% | | 1.01 | 8.12 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 21.71 ± 0.9% | not timed | not timed | 3.06 ± 0.3% | 7.76 ± 1.4% | not timed | not timed | 21.59 ± 3.9% | | 1.01 | 7.09 | 2.80 |
| 07-unicode-character-data/compile | 1 | 78.41 ± 2.5% | not timed | not timed | 32.42 ± 2.6% | 43.47 ± 0.9% | not timed | not timed | 78.44 ± 0.6% | | 1.00 | 2.42 | 1.80 |
| 09-aws-keys/compile-full | 1 | 53.32 ± 4.3% | not timed | not timed | 9.04 ± 0.6% | 27.79 ± 4.0% | not timed | not timed | 52.81 ± 0.8% | | 1.01 | 5.90 | 1.92 |
| 09-aws-keys/compile-quick | 1 | 247.61 ± 0.3% | not timed | not timed | 61.18 ± 1.0% | 161.80 ± 2.6% | not timed | not timed | 244.96 ± 1.0% | | 1.01 | 4.05 | 1.53 |
| 10-bounded-repeat/compile-context | 1 | 16.66 ± 0.9% | not timed | not timed | 14.57 ± 0.7% | 20.08 ± 4.5% | not timed | not timed | 16.62 ± 1.7% | | 1.00 | 1.14 | 0.83 |
| 10-bounded-repeat/compile-capitals | 1 | 103.19 ± 0.7% | not timed | not timed | 10.92 ± 2.0% | 29.15 ± 2.9% | not timed | not timed | 101.62 ± 0.7% | | 1.02 | 9.45 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 118.25 ± 0.7% | not timed | not timed | 49.59 ± 0.9% | 82.91 ± 2.4% | not timed | not timed | 118.29 ± 0.8% | | 1.00 | 2.38 | 1.43 |
| 12-dictionary/compile-single | 1 | 0.37 ± 3.4% | not timed | not timed | 0.08 ± 1.2% | 0.11 ± 15.3% | not timed | not timed | 0.37 ± 0.9% | | 1.00 | 4.64 | 3.43 |

