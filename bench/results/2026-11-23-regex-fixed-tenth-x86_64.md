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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159292968 |
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
| literal: a word | 217 | 31568.07 ± 0.3% | 1090.04 ± 0.0% | 36.27 ± 2.0% | 32016.26 ± 0.3% | 12343.49 ± 2.5% | 14.72 ± 0.5% | 115.88 ± 0.8% | 31552.38 ± 0.2% | 28.96 | 1.00 | 0.99 | 2.56 |
| literal: a word that is not there | 0 | 41472.08 ± 0.2% | 1101.14 ± 0.1% | 36.90 ± 0.3% | 35438.92 ± 0.1% | 39273.86 ± 0.3% | 14.30 ± 0.4% | 108.74 ± 0.6% | 41479.39 ± 1.0% | 37.66 | 1.00 | 1.17 | 1.06 |
| literal: one of four words | 661 | 13342.81 ± 1.4% | 1068.69 ± 0.2% | 19.34 ± 3.4% | 9721.20 ± 0.8% | 29.27 ± 0.8% | 4.34 ± 0.4% | 9.26 ± 0.5% | 13223.34 ± 0.6% | 12.49 | 1.01 | 1.37 | 455.79 |
| literal: a word in any case | 217 | 26932.95 ± 0.7% | 1088.44 ± 0.2% | 25.72 ± 1.5% | 10064.69 ± 1.3% | 58.10 ± 0.7% | refused | differs | 26875.99 ± 0.4% | 24.74 | 1.00 | 2.68 | 463.56 |
| literal: an href attribute | 33 | 27665.53 ± 0.3% | 1097.77 ± 0.3% | 32.20 ± 0.9% | 28655.61 ± 0.8% | 2613.55 ± 0.2% | 10.60 ± 0.2% | 99.44 ± 0.7% | 27607.75 ± 0.3% | 25.20 | 1.00 | 0.97 | 10.59 |
| literal: a word, second text | 123 | 32959.61 ± 0.4% | 1093.28 ± 0.2% | 35.15 ± 1.6% | 31965.52 ± 0.1% | 8924.34 ± 6.9% | 19.15 ± 0.2% | 96.92 ± 0.3% | 33003.68 ± 0.3% | 30.15 | 1.00 | 1.03 | 3.69 |
| class: two capitalized words | 1331 | 1022.39 ± 0.4% | 1012.27 ± 0.1% | 32.94 ± 1.8% | 612.88 ± 0.0% | 49.06 ± 0.6% | 12.56 ± 0.3% | 82.38 ± 0.5% | 1021.84 ± 0.1% | 1.01 | 1.00 | 1.67 | 20.84 |
| class: a word that ends in ing | 3399 | 924.72 ± 0.1% | 923.05 ± 0.6% | 21.32 ± 0.6% | 575.27 ± 0.6% | 35.55 ± 2.6% | 7.10 ± 0.5% | 22.91 ± 0.6% | 923.90 ± 0.2% | 1.00 | 1.00 | 1.61 | 26.01 |
| class: a word in capitals | 2332 | 1391.80 ± 1.0% | 990.83 ± 0.1% | 34.79 ± 0.5% | 603.87 ± 0.7% | 52.95 ± 5.5% | 15.12 ± 0.2% | 101.96 ± 0.2% | 1388.42 ± 0.5% | 1.40 | 1.00 | 2.30 | 26.29 |
| class: a number | 8288 | 1995.05 ± 0.2% | 861.09 ± 0.3% | 34.34 ± 2.3% | 2123.28 ± 0.3% | 48.34 ± 16.8% | 0.42 ± 0.1% | 71.01 ± 0.4% | 1997.57 ± 0.1% | 2.32 | 1.00 | 0.94 | 41.27 |
| class: two capitalized words, second text | 5359 | 755.13 ± 0.3% | 754.96 ± 0.1% | 28.97 ± 2.2% | 506.57 ± 0.1% | 40.59 ± 16.3% | 16.21 ± 0.2% | 74.97 ± 0.7% | 754.40 ± 0.1% | 1.00 | 1.00 | 1.49 | 18.61 |
| other: a word between two words | 6104 | 838.50 ± 0.4% | 797.91 ± 0.1% | 29.11 ± 0.9% | 878.46 ± 0.4% | 137.29 ± 7.1% | 9.61 ± 0.1% | 85.63 ± 0.4% | 838.22 ± 0.8% | 1.05 | 1.00 | 0.95 | 6.11 |
| other: a number before a unit, second text | 1481 | 9245.71 ± 1.9% | 1025.08 ± 0.1% | 32.78 ± 1.7% | 9302.37 ± 1.1% | 49.10 ± 0.6% | 17.04 ± 0.6% | 80.11 ± 0.4% | 9090.99 ± 2.9% | 9.02 | 1.02 | 0.99 | 188.31 |
| other: a heading's start tag | 110 | 20186.42 ± 0.6% | 1089.07 ± 0.2% | 34.82 ± 1.4% | 2679.86 ± 2.4% | 1917.69 ± 7.8% | 13.17 ± 0.8% | 117.57 ± 1.1% | 20198.25 ± 0.4% | 18.54 | 1.00 | 7.53 | 10.53 |
| other: a whole word | 217 | 24786.02 ± 0.2% | 1089.28 ± 0.3% | 37.14 ± 0.5% | 25665.86 ± 0.3% | 60.35 ± 0.4% | 12.62 ± 0.9% | 67.76 ± 1.3% | 24805.45 ± 0.2% | 22.75 | 1.00 | 0.97 | 410.68 |
| other: a line's first word, second text | 3716 | 2555.43 ± 0.3% | 913.98 ± 0.5% | 37.74 ± 0.1% | 2469.58 ± 0.3% | 82.08 ± 4.4% | refused | refused | 2544.57 ± 0.4% | 2.80 | 1.00 | 1.03 | 31.13 |
| other: fourteen octets before an x | 87 | 34761.79 ± 0.3% | 298.05 ± 0.4% | 7.79 ± 1.5% | 4217.03 ± 1.8% | 11.59 ± 0.7% | differs | 20.21 ± 0.4% | 34824.57 ± 0.5% | 116.63 | 1.00 | 8.24 | 2999.96 |
| other: a Greek word | 21815 | 528.22 ± 0.3% | 405.50 ± 0.2% | 36.89 ± 2.9% | 313.23 ± 0.3% | 53.71 ± 4.1% | differs | refused | 526.89 ± 0.2% | 1.30 | 1.00 | 1.69 | 9.84 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.47 ± 1.2% | 29.49 ± 1.0% | 1.07 ± 3.0% | 21.53 ± 0.3% | 3.22 ± 0.5% | differs | 4.99 ± 0.7% | 29.46 ± 0.8% | 1.00 | 1.00 | 1.37 | 9.16 |
| a UUID | 32895 | 26.55 ± 0.1% | 26.52 ± 0.4% | 0.74 ± 0.9% | 16.52 ± 0.2% | 3.25 ± 1.1% | 0.72 ± 0.1% | 4.10 ± 1.2% | 26.52 ± 0.5% | 1.00 | 1.00 | 1.61 | 8.16 |
| an IPv4 address | 33176 | 39.08 ± 0.7% | 39.17 ± 0.5% | 2.41 ± 0.3% | 31.62 ± 0.1% | 8.11 ± 1.0% | differs | 4.66 ± 0.6% | 39.10 ± 0.3% | 1.00 | 1.00 | 1.24 | 4.82 |
| a date and time | 32954 | 39.39 ± 0.1% | 39.39 ± 0.7% | 1.72 ± 0.7% | 24.00 ± 0.2% | 10.24 ± 0.5% | 1.32 ± 0.1% | 9.05 ± 0.5% | 39.39 ± 0.6% | 1.00 | 1.00 | 1.64 | 3.85 |
| a field path | 32606 | 31.68 ± 0.6% | 31.48 ± 0.5% | 1.24 ± 0.5% | 24.86 ± 0.1% | 3.71 ± 0.5% | differs | 3.09 ± 0.2% | 31.54 ± 2.2% | 1.01 | 1.00 | 1.27 | 8.54 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.35 ± 0.6% | 12.35 ± 0.3% | 12.36 ± 0.8% | 14.74 ± 3.3% | 6.75 ± 1.0% | 1.05 ± 0.4% | none | 12.36 ± 0.2% | 1.00 | 1.00 | 0.84 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 280.15 ± 0.6% | 281.89 ± 0.4% | 324.93 ± 0.3% | 117.00 ± 1.5% | 262.41 ± 5.4% | 693.07 ± 0.9% | 4345.67 ± 1.1% | 279.93 ± 0.2% | 0.99 | 1.00 | 2.39 | 1.07 |
| a UUID | 62 | 180.21 ± 0.1% | 181.12 ± 0.2% | 199.64 ± 3.1% | 61.85 ± 3.6% | 118.87 ± 1.2% | 257.46 ± 2.3% | 5726.87 ± 0.3% | 180.05 ± 2.6% | 0.99 | 1.00 | 2.91 | 1.52 |
| an IPv4 address | 29 | 588.89 ± 4.4% | 599.78 ± 0.5% | 838.71 ± 0.3% | 100.51 ± 0.5% | 157.99 ± 2.9% | 432.96 ± 0.3% | 10316.14 ± 0.8% | 591.27 ± 0.5% | 0.98 | 1.00 | 5.86 | 3.73 |
| a date and time | 56 | 458.60 ± 0.3% | 463.07 ± 0.5% | 585.96 ± 0.3% | 96.89 ± 0.7% | 167.42 ± 10.3% | 455.19 ± 0.6% | 5778.62 ± 2.0% | 458.13 ± 1.4% | 0.99 | 1.00 | 4.73 | 2.74 |
| a field path | 39 | 265.39 ± 0.5% | 266.45 ± 0.3% | 305.16 ± 0.5% | 105.47 ± 0.9% | 244.76 ± 1.1% | 708.90 ± 2.5% | 5550.42 ± 0.6% | 265.26 ± 0.3% | 1.00 | 1.00 | 2.52 | 1.08 |
| literal: a word | 7 | 929.08 ± 0.4% | 1018.05 ± 0.2% | 1829.54 ± 0.8% | 721.37 ± 2.6% | 798.54 ± 9.8% | 1438.77 ± 0.6% | 38723.38 ± 0.3% | 928.94 ± 0.5% | 0.91 | 1.00 | 1.29 | 1.16 |
| literal: a word that is not there | 8 | 888.98 ± 6.5% | 982.82 ± 4.7% | 1721.95 ± 0.4% | 645.54 ± 0.3% | 765.01 ± 7.4% | 1359.14 ± 5.0% | 38118.11 ± 0.3% | 889.36 ± 4.2% | 0.90 | 1.00 | 1.38 | 1.16 |
| literal: one of four words | 26 | 349.68 ± 2.9% | 606.02 ± 0.4% | 834.38 ± 0.2% | 50.93 ± 2.5% | 300.71 ± 2.1% | 507.56 ± 2.2% | 21890.61 ± 0.8% | 349.25 ± 0.4% | 0.58 | 1.00 | 6.87 | 1.16 |
| literal: a word in any case | 11 | 691.82 ± 0.2% | 750.78 ± 0.1% | 1128.97 ± 0.5% | 17.84 ± 0.7% | 853.76 ± 0.6% | refused | 31324.39 ± 0.6% | 692.27 ± 0.2% | 0.92 | 1.00 | 38.77 | 0.81 |
| literal: an href attribute | 12 | 467.42 ± 0.3% | 482.58 ± 0.5% | 631.04 ± 5.2% | 50.05 ± 0.1% | 613.31 ± 2.3% | 1156.57 ± 0.1% | 27768.26 ± 0.4% | 466.93 ± 0.6% | 0.97 | 1.00 | 9.34 | 0.76 |
| literal: a word, second text | 10 | 826.17 ± 0.3% | 928.25 ± 0.5% | 1563.03 ± 0.4% | 600.04 ± 0.4% | 672.46 ± 17.0% | 1177.27 ± 0.9% | 35841.76 ± 0.5% | 825.21 ± 0.7% | 0.89 | 1.00 | 1.38 | 1.23 |
| class: two capitalized words | 23 | 663.79 ± 0.3% | 726.21 ± 0.2% | 1073.04 ± 0.2% | 136.58 ± 0.4% | 634.89 ± 1.8% | 1134.08 ± 0.5% | 7814.37 ± 0.7% | 662.61 ± 0.2% | 0.91 | 1.00 | 4.86 | 1.05 |
| class: a word that ends in ing | 9 | 808.71 ± 0.3% | 927.44 ± 0.4% | 1656.34 ± 0.4% | 174.05 ± 0.6% | 938.79 ± 9.8% | 1738.04 ± 0.1% | 20416.69 ± 1.8% | 808.27 ± 0.3% | 0.87 | 1.00 | 4.65 | 0.86 |
| class: a word in capitals | 16 | 729.85 ± 0.2% | 806.97 ± 0.2% | 1342.05 ± 0.2% | 182.24 ± 2.0% | 943.63 ± 1.0% | 1633.56 ± 0.4% | 10295.15 ± 0.5% | 729.20 ± 0.4% | 0.90 | 1.00 | 4.00 | 0.77 |
| class: a number | 6 | 884.73 ± 0.1% | 1001.32 ± 0.3% | 1920.53 ± 0.1% | 44.19 ± 1.4% | 1735.88 ± 1.7% | 3027.80 ± 1.7% | 30406.57 ± 0.5% | 884.73 ± 0.3% | 0.88 | 1.00 | 20.02 | 0.51 |
| class: two capitalized words, second text | 23 | 663.13 ± 0.2% | 726.77 ± 0.1% | 1071.68 ± 6.5% | 135.81 ± 0.3% | 634.50 ± 3.0% | 1149.01 ± 0.7% | 7787.83 ± 0.8% | 662.30 ± 0.2% | 0.91 | 1.00 | 4.88 | 1.05 |
| other: a word between two words | 13 | 801.10 ± 0.5% | 841.26 ± 0.2% | 1348.77 ± 0.2% | 182.87 ± 0.8% | 630.20 ± 1.0% | 1215.53 ± 2.0% | 18632.75 ± 1.3% | 799.87 ± 0.6% | 0.95 | 1.00 | 4.38 | 1.27 |
| other: a number before a unit, second text | 15 | 528.95 ± 0.6% | 588.37 ± 0.3% | 801.54 ± 0.2% | 41.69 ± 0.3% | 791.01 ± 8.8% | 1381.55 ± 1.7% | 19717.01 ± 1.5% | 528.38 ± 0.3% | 0.90 | 1.00 | 12.69 | 0.67 |
| other: a heading's start tag | 13 | 481.32 ± 0.5% | 489.81 ± 0.8% | 642.72 ± 0.5% | 47.98 ± 0.2% | 771.65 ± 0.4% | 1320.94 ± 0.7% | 23531.25 ± 0.3% | 481.39 ± 0.6% | 0.98 | 1.00 | 10.03 | 0.62 |
| other: a whole word | 11 | 842.83 ± 0.4% | 906.29 ± 4.5% | 1496.49 ± 0.6% | 162.49 ± 0.6% | 715.74 ± 20.7% | 1251.56 ± 3.1% | 34020.01 ± 2.9% | 842.48 ± 0.2% | 0.93 | 1.00 | 5.19 | 1.18 |
| other: a line's first word, second text | 17 | 763.91 ± 3.2% | 805.03 ± 3.5% | 1303.21 ± 0.3% | 174.71 ± 0.3% | 874.66 ± 8.9% | refused | refused | 763.71 ± 0.4% | 0.95 | 1.00 | 4.37 | 0.87 |
| other: fourteen octets before an x | 16 | 135.21 ± 0.2% | 195.31 ± 0.3% | 225.11 ± 3.4% | 18.73 ± 0.2% | 549.64 ± 1.0% | 587.05 ± 0.7% | 16706.32 ± 0.3% | 135.02 ± 0.1% | 0.69 | 1.00 | 7.22 | 0.25 |
| other: a Greek word | 8 | 577.56 ± 0.6% | 799.63 ± 0.3% | 1306.97 ± 5.8% | 61.59 ± 4.6% | 1714.88 ± 1.1% | 2893.95 ± 0.5% | refused | 577.37 ± 0.3% | 0.72 | 1.00 | 9.38 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23819.25 ± 0.2% | not timed | not timed | 28109.47 ± 0.5% | 2857.72 ± 14.0% | not timed | not timed | 23761.14 ± 0.3% | | 1.00 | 0.85 | 8.34 |
| 01-literal/sherlock-casei-en | 522 | 7545.22 ± 0.9% | not timed | not timed | 8503.86 ± 0.2% | 40.44 ± 0.9% | not timed | not timed | 7512.04 ± 4.3% | | 1.00 | 0.89 | 186.59 |
| 01-literal/sherlock-ru | 724 | 24456.55 ± 4.6% | not timed | not timed | 27790.18 ± 0.7% | 1593.90 ± 5.9% | not timed | not timed | 24397.14 ± 0.4% | | 1.00 | 0.88 | 15.34 |
| 01-literal/sherlock-casei-ru | 746 | 8296.86 ± 0.9% | not timed | not timed | 6548.26 ± 0.3% | 42.73 ± 2.0% | not timed | not timed | 8325.00 ± 2.6% | | 1.00 | 1.27 | 194.16 |
| 01-literal/sherlock-zh | 30 | 37596.78 ± 0.1% | not timed | not timed | 34425.53 ± 0.3% | 1607.34 ± 1.5% | not timed | not timed | 37580.27 ± 0.4% | | 1.00 | 1.09 | 23.39 |
| 02-literal-alternate/sherlock-en | 714 | 12130.05 ± 0.2% | not timed | not timed | 9445.39 ± 0.2% | 22.43 ± 0.5% | not timed | not timed | 12074.23 ± 0.6% | | 1.00 | 1.28 | 540.88 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2055.14 ± 0.7% | not timed | not timed | 2310.59 ± 0.5% | 13.68 ± 0.2% | not timed | not timed | 2038.02 ± 0.4% | | 1.01 | 0.89 | 150.19 |
| 02-literal-alternate/sherlock-ru | 899 | 6866.14 ± 0.3% | not timed | not timed | 5160.80 ± 0.4% | 29.08 ± 5.2% | not timed | not timed | 6835.49 ± 1.2% | | 1.00 | 1.33 | 236.07 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2168.02 ± 0.4% | not timed | not timed | 1251.71 ± 0.1% | 11.79 ± 2.1% | not timed | not timed | 2159.11 ± 0.4% | | 1.00 | 1.73 | 183.82 |
| 02-literal-alternate/sherlock-zh | 207 | 16346.95 ± 0.2% | not timed | not timed | 10772.71 ± 0.1% | 41.58 ± 2.5% | not timed | not timed | 16291.18 ± 0.7% | | 1.00 | 1.52 | 393.13 |
| 03-date/ascii | 111817 | 129.22 ± 0.2% | not timed | not timed | 110.10 ± 0.2% | 0.27 ± 2.1% | not timed | not timed | 128.95 ± 1.0% | | 1.00 | 1.17 | 473.69 |
| 04-ruff-noqa/real | 84 | 718.24 ± 3.8% | not timed | not timed | 565.69 ± 0.3% | 26.00 ± 1.8% | not timed | not timed | 733.14 ± 2.1% | | 0.98 | 1.27 | 27.63 |
| 04-ruff-noqa/tweaked | 44 | 626.33 ± 0.7% | not timed | not timed | 568.25 ± 0.2% | 435.82 ± 14.4% | not timed | not timed | 624.73 ± 0.2% | | 1.00 | 1.10 | 1.44 |
| 05-lexer-veryl/single | 124800 | 4.41 ± 0.4% | not timed | not timed | 5.77 ± 0.1% | 0.26 ± 6.4% | not timed | not timed | 4.42 ± 0.5% | | 1.00 | 0.77 | 16.73 |
| 06-cloud-flare-redos/original | 107 | 282.66 ± 0.5% | not timed | not timed | 262.60 ± 0.3% | 32.38 ± 0.3% | not timed | not timed | 282.75 ± 0.3% | | 1.00 | 1.08 | 8.73 |
| 06-cloud-flare-redos/simplified-short | 102 | 252.55 ± 0.3% | not timed | not timed | 267.59 ± 0.2% | 35.33 ± 0.1% | not timed | not timed | 252.42 ± 0.3% | | 1.00 | 0.94 | 7.15 |
| 06-cloud-flare-redos/simplified-long | 10000 | 271.72 ± 0.4% | not timed | not timed | 280.07 ± 0.2% | 38.01 ± 0.4% | not timed | not timed | 271.55 ± 0.2% | | 1.00 | 0.97 | 7.15 |
| 07-unicode-character-data/parse-line | 558784 | 269.38 ± 0.3% | not timed | not timed | 208.62 ± 0.3% | 53.33 ± 7.9% | not timed | not timed | 268.44 ± 1.6% | | 1.00 | 1.29 | 5.05 |
| 08-words/all-english | 56691 | 115.55 ± 0.5% | not timed | not timed | 92.91 ± 0.6% | 14.80 ± 10.8% | not timed | not timed | 115.29 ± 0.9% | | 1.00 | 1.24 | 7.81 |
| 08-words/long-english | 839 | 1051.70 ± 0.5% | not timed | not timed | 624.76 ± 0.3% | 37.82 ± 4.4% | not timed | not timed | 1050.69 ± 0.1% | | 1.00 | 1.68 | 27.81 |
| 09-aws-keys/full | 0 | 571.31 ± 0.6% | not timed | not timed | 581.21 ± 0.3% | 82.54 ± 5.0% | not timed | not timed | 573.53 ± 5.4% | | 1.00 | 0.98 | 6.92 |
| 09-aws-keys/quick | 0 | 1064.69 ± 7.0% | not timed | not timed | 880.31 ± 1.9% | 426.27 ± 6.0% | not timed | not timed | 1060.91 ± 7.1% | | 1.00 | 1.21 | 2.50 |
| 10-bounded-repeat/letters-en | 1833 | 626.48 ± 0.7% | not timed | not timed | 550.61 ± 0.3% | 24.25 ± 0.6% | not timed | not timed | 626.94 ± 0.4% | | 1.00 | 1.14 | 25.83 |
| 10-bounded-repeat/letters-ru | 3475 | 391.29 ± 0.2% | not timed | not timed | 495.64 ± 0.3% | 25.69 ± 12.3% | not timed | not timed | 390.56 ± 0.4% | | 1.00 | 0.79 | 15.23 |
| 10-bounded-repeat/context | 53 | 91.23 ± 1.2% | not timed | not timed | 73.98 ± 0.6% | 24.26 ± 0.5% | not timed | not timed | 91.54 ± 1.0% | | 1.00 | 1.23 | 3.76 |
| 10-bounded-repeat/capitals | 11 | 1090.10 ± 0.3% | not timed | not timed | 642.02 ± 0.1% | 44.35 ± 0.5% | not timed | not timed | 1083.76 ± 0.6% | | 1.01 | 1.70 | 24.58 |
| 11-unstructured-to-json/extract | 600 | 49.36 ± 2.5% | not timed | not timed | 79.64 ± 0.3% | 64.26 ± 0.2% | not timed | not timed | 49.13 ± 0.9% | | 1.00 | 0.62 | 0.77 |
| 12-dictionary/single | 1 | 571.09 ± 0.9% | not timed | not timed | 547.13 ± 0.8% | 0.52 ± 3.9% | not timed | not timed | 573.40 ± 0.4% | | 1.00 | 1.04 | 1098.78 |
| 14-quadratic/1x | 100 | 14.11 ± 2.2% | not timed | not timed | 13.53 ± 0.4% | 1.25 ± 1.0% | not timed | not timed | 14.08 ± 0.5% | | 1.00 | 1.04 | 11.27 |
| 14-quadratic/2x | 200 | 8.52 ± 0.2% | not timed | not timed | 6.62 ± 0.2% | 0.69 ± 6.8% | not timed | not timed | 8.49 ± 0.3% | | 1.00 | 1.29 | 12.28 |
| 14-quadratic/10x | 1000 | 1.94 ± 0.3% | not timed | not timed | 1.30 ± 0.2% | 0.15 ± 0.9% | not timed | not timed | 1.93 ± 0.4% | | 1.00 | 1.49 | 12.77 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.05 ± 0.2% | not timed | not timed | 0.45 ± 4.6% | 0.67 ± 4.5% | not timed | not timed | 2.04 ± 2.8% | | 1.01 | 4.54 | 3.08 |
| 04-ruff-noqa/compile-real | 1 | 132.33 ± 0.3% | not timed | not timed | 15.92 ± 0.7% | 175.61 ± 1.6% | not timed | not timed | 131.55 ± 5.4% | | 1.01 | 8.31 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 21.68 ± 3.7% | not timed | not timed | 3.06 ± 0.6% | 7.84 ± 1.4% | not timed | not timed | 21.74 ± 0.3% | | 1.00 | 7.08 | 2.76 |
| 07-unicode-character-data/compile | 1 | 79.59 ± 1.1% | not timed | not timed | 32.67 ± 0.3% | 44.16 ± 1.1% | not timed | not timed | 79.15 ± 6.8% | | 1.01 | 2.44 | 1.80 |
| 09-aws-keys/compile-full | 1 | 53.73 ± 0.5% | not timed | not timed | 9.15 ± 0.3% | 28.19 ± 1.9% | not timed | not timed | 53.83 ± 0.6% | | 1.00 | 5.87 | 1.91 |
| 09-aws-keys/compile-quick | 1 | 243.09 ± 0.1% | not timed | not timed | 60.52 ± 0.4% | 166.04 ± 3.6% | not timed | not timed | 242.03 ± 0.5% | | 1.00 | 4.02 | 1.46 |
| 10-bounded-repeat/compile-context | 1 | 16.56 ± 0.2% | not timed | not timed | 14.57 ± 0.3% | 20.82 ± 2.5% | not timed | not timed | 16.51 ± 1.2% | | 1.00 | 1.14 | 0.80 |
| 10-bounded-repeat/compile-capitals | 1 | 102.91 ± 0.3% | not timed | not timed | 10.92 ± 0.2% | 29.57 ± 1.4% | not timed | not timed | 103.24 ± 0.5% | | 1.00 | 9.43 | 3.48 |
| 11-unstructured-to-json/compile | 1 | 119.11 ± 0.5% | not timed | not timed | 50.91 ± 0.6% | 83.71 ± 3.2% | not timed | not timed | 118.86 ± 1.2% | | 1.00 | 2.34 | 1.42 |
| 12-dictionary/compile-single | 1 | 0.38 ± 0.6% | not timed | not timed | 0.08 ± 1.1% | 0.12 ± 8.6% | not timed | not timed | 0.37 ± 0.8% | | 1.01 | 4.61 | 3.22 |

