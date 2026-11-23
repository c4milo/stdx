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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127325269 |
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
| literal: a word | 217 | 15949.02 ± 0.5% | 1039.98 ± 0.1% | 28.59 ± 0.2% | 18003.19 ± 2.0% | 9337.70 ± 6.7% | 17.38 ± 0.3% | 86.24 ± 0.5% | 15932.81 ± 0.9% | 15.34 | 1.00 | 0.89 | 1.71 |
| literal: a word that is not there | 0 | 18745.34 ± 3.3% | 1048.70 ± 0.2% | 28.55 ± 0.2% | 19757.79 ± 3.3% | 28645.74 ± 3.4% | 17.14 ± 0.1% | 82.27 ± 0.3% | 18847.72 ± 3.1% | 17.87 | 0.99 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6074.23 ± 0.5% | 1021.37 ± 0.1% | 14.68 ± 0.2% | 3948.57 ± 0.1% | 21.91 ± 0.1% | 5.45 ± 0.1% | 6.76 ± 0.4% | 6055.52 ± 0.3% | 5.95 | 1.00 | 1.54 | 277.27 |
| literal: a word in any case | 217 | 12571.20 ± 0.7% | 1040.21 ± 0.3% | 21.41 ± 2.3% | 3971.29 ± 0.2% | 38.04 ± 0.5% | refused | differs | 12570.04 ± 0.7% | 12.09 | 1.00 | 3.17 | 330.43 |
| literal: an href attribute | 33 | 13733.90 ± 0.6% | 1047.72 ± 0.2% | 27.19 ± 0.1% | 16859.31 ± 1.3% | 2265.08 ± 0.6% | 13.11 ± 0.1% | 75.43 ± 0.1% | 13750.23 ± 0.5% | 13.11 | 1.00 | 0.81 | 6.06 |
| literal: a word, second text | 123 | 16318.68 ± 0.7% | 1043.27 ± 0.3% | 28.26 ± 0.2% | 18053.38 ± 3.2% | 7726.30 ± 5.3% | 20.07 ± 0.5% | 69.62 ± 0.4% | 16301.88 ± 1.0% | 15.64 | 1.00 | 0.90 | 2.11 |
| class: two capitalized words | 1331 | 1125.22 ± 0.7% | 977.82 ± 0.1% | 26.06 ± 0.1% | 584.74 ± 0.4% | 40.60 ± 1.9% | 14.72 ± 0.4% | 68.55 ± 0.3% | 1127.73 ± 0.5% | 1.15 | 1.00 | 1.92 | 27.71 |
| class: a word that ends in ing | 3399 | 890.18 ± 0.1% | 890.70 ± 0.2% | 18.08 ± 0.3% | 548.01 ± 0.1% | 29.63 ± 4.9% | 8.23 ± 0.1% | 18.27 ± 0.2% | 888.38 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.04 |
| class: a word in capitals | 2332 | 1452.08 ± 0.3% | 949.58 ± 0.3% | 27.80 ± 0.2% | 572.54 ± 0.6% | 43.60 ± 16.3% | 17.18 ± 0.3% | 82.81 ± 0.5% | 1454.02 ± 0.6% | 1.53 | 1.00 | 2.54 | 33.30 |
| class: a number | 8288 | 2000.65 ± 0.2% | 827.10 ± 0.1% | 28.02 ± 0.1% | 1690.28 ± 0.3% | 43.23 ± 14.0% | 0.53 ± 0.7% | 56.98 ± 0.3% | 1992.98 ± 0.1% | 2.42 | 1.00 | 1.18 | 46.28 |
| class: two capitalized words, second text | 5359 | 737.59 ± 0.2% | 736.78 ± 0.2% | 23.39 ± 0.1% | 484.13 ± 0.1% | 35.44 ± 6.7% | 17.03 ± 0.3% | 63.68 ± 0.3% | 737.85 ± 0.1% | 1.00 | 1.00 | 1.52 | 20.81 |
| other: a word between two words | 6104 | 764.33 ± 0.1% | 764.34 ± 0.2% | 23.60 ± 0.2% | 738.86 ± 0.1% | 106.94 ± 10.1% | 11.19 ± 0.0% | 69.33 ± 0.2% | 762.29 ± 0.1% | 1.00 | 1.00 | 1.03 | 7.15 |
| other: a number before a unit, second text | 1481 | 5542.39 ± 0.6% | 982.79 ± 0.1% | 25.88 ± 0.2% | 5662.26 ± 0.3% | 40.79 ± 7.4% | 18.11 ± 0.3% | 66.77 ± 0.5% | 5517.60 ± 0.5% | 5.64 | 1.00 | 0.98 | 135.87 |
| other: a heading's start tag | 110 | 12623.76 ± 0.6% | 1035.76 ± 0.1% | 27.40 ± 0.1% | 1714.80 ± 0.3% | 1577.27 ± 6.0% | 16.06 ± 0.4% | 88.45 ± 0.3% | 12611.77 ± 0.2% | 12.19 | 1.00 | 7.36 | 8.00 |
| other: a whole word | 217 | 13890.52 ± 0.8% | 1037.91 ± 0.4% | 29.47 ± 0.3% | 14525.35 ± 0.8% | 49.41 ± 0.2% | 13.30 ± 0.1% | 56.01 ± 0.4% | 13900.67 ± 0.6% | 13.38 | 1.00 | 0.96 | 281.10 |
| other: a line's first word, second text | 3716 | 1959.00 ± 0.7% | 873.32 ± 0.2% | 31.01 ± 0.4% | 1728.86 ± 0.3% | 62.88 ± 8.5% | refused | refused | 1947.48 ± 0.9% | 2.24 | 1.01 | 1.13 | 31.15 |
| other: fourteen octets before an x | 87 | 19649.81 ± 0.9% | 239.39 ± 0.1% | 6.13 ± 0.1% | 3995.70 ± 0.4% | 10.64 ± 0.2% | differs | 17.74 ± 0.2% | 19744.38 ± 0.9% | 82.08 | 1.00 | 4.92 | 1846.30 |
| other: a Greek word | 21815 | 470.57 ± 0.4% | 356.95 ± 0.2% | 31.09 ± 0.0% | 289.55 ± 0.2% | 49.49 ± 8.5% | differs | refused | 469.00 ± 0.5% | 1.32 | 1.00 | 1.63 | 9.51 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.14 ± 0.2% | 25.84 ± 0.2% | 0.83 ± 0.3% | 19.80 ± 0.5% | 2.77 ± 0.9% | differs | 4.04 ± 0.1% | 25.88 ± 0.3% | 0.97 | 0.97 | 1.27 | 9.08 |
| a UUID | 32895 | 21.08 ± 0.1% | 21.16 ± 0.2% | 0.65 ± 0.2% | 15.12 ± 0.4% | 3.12 ± 0.5% | 0.73 ± 0.4% | 3.63 ± 0.5% | 21.13 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.77 |
| an IPv4 address | 33176 | 37.04 ± 0.2% | 37.01 ± 0.2% | 2.10 ± 0.4% | 29.38 ± 0.7% | 6.65 ± 0.2% | differs | 4.10 ± 0.4% | 37.08 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.57 |
| a date and time | 32954 | 31.05 ± 0.4% | 31.06 ± 0.5% | 1.42 ± 0.2% | 21.47 ± 0.5% | 7.06 ± 0.2% | 1.25 ± 0.3% | 7.13 ± 0.2% | 30.99 ± 0.5% | 1.00 | 1.00 | 1.45 | 4.40 |
| a field path | 32606 | 29.52 ± 0.3% | 29.48 ± 0.3% | 1.02 ± 0.9% | 22.66 ± 0.3% | 3.51 ± 1.0% | differs | 2.93 ± 0.2% | 29.52 ± 0.2% | 1.00 | 1.00 | 1.30 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.3% | 11.52 ± 0.5% | 11.49 ± 0.5% | 11.78 ± 0.2% | 4.93 ± 1.3% | 0.93 ± 0.3% | none | 11.52 ± 0.2% | 1.00 | 1.00 | 0.98 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.28 ± 0.1% | 237.16 ± 0.2% | 286.29 ± 0.2% | 86.19 ± 0.5% | 221.46 ± 1.0% | 486.71 ± 0.5% | 3754.77 ± 1.1% | 235.25 ± 0.1% | 0.99 | 1.00 | 2.73 | 1.06 |
| a UUID | 62 | 157.88 ± 0.3% | 158.42 ± 0.2% | 178.94 ± 0.1% | 46.45 ± 0.6% | 98.79 ± 0.7% | 190.21 ± 2.9% | 4453.69 ± 0.8% | 157.96 ± 0.2% | 1.00 | 1.00 | 3.40 | 1.60 |
| an IPv4 address | 29 | 425.60 ± 0.6% | 429.91 ± 0.5% | 615.92 ± 1.0% | 77.10 ± 0.4% | 130.45 ± 18.0% | 301.09 ± 1.3% | 7697.99 ± 0.3% | 425.38 ± 0.6% | 0.99 | 1.00 | 5.52 | 3.26 |
| a date and time | 56 | 307.55 ± 0.3% | 310.61 ± 0.4% | 396.46 ± 0.5% | 72.85 ± 0.1% | 137.02 ± 1.4% | 331.09 ± 1.6% | 4958.09 ± 0.5% | 306.52 ± 0.3% | 0.99 | 1.00 | 4.22 | 2.24 |
| a field path | 39 | 226.70 ± 0.5% | 228.51 ± 0.5% | 272.84 ± 0.6% | 81.27 ± 1.4% | 206.24 ± 0.9% | 505.67 ± 2.6% | 4843.41 ± 0.5% | 227.12 ± 0.6% | 0.99 | 1.00 | 2.79 | 1.10 |
| literal: a word | 7 | 637.21 ± 0.4% | 684.91 ± 0.6% | 1282.95 ± 0.7% | 496.90 ± 0.2% | 632.29 ± 5.7% | 955.99 ± 0.4% | 30471.10 ± 0.1% | 637.13 ± 0.3% | 0.93 | 1.00 | 1.28 | 1.01 |
| literal: a word that is not there | 8 | 611.66 ± 0.2% | 663.03 ± 0.3% | 1206.86 ± 0.1% | 462.96 ± 0.2% | 605.08 ± 1.6% | 910.49 ± 0.4% | 29200.85 ± 0.2% | 611.44 ± 0.3% | 0.92 | 1.00 | 1.32 | 1.01 |
| literal: one of four words | 26 | 245.66 ± 0.1% | 409.05 ± 0.3% | 572.13 ± 0.4% | 50.09 ± 1.4% | 243.93 ± 2.5% | 375.12 ± 1.1% | 15611.91 ± 0.2% | 245.66 ± 0.3% | 0.60 | 1.00 | 4.90 | 1.01 |
| literal: a word in any case | 11 | 494.33 ± 0.4% | 529.59 ± 0.3% | 853.67 ± 0.3% | 15.68 ± 0.3% | 659.76 ± 2.8% | refused | 23710.94 ± 0.4% | 494.07 ± 0.3% | 0.93 | 1.00 | 31.52 | 0.75 |
| literal: an href attribute | 12 | 353.26 ± 0.9% | 366.63 ± 0.8% | 495.27 ± 0.6% | 45.69 ± 0.6% | 504.92 ± 1.1% | 772.75 ± 0.5% | 21689.81 ± 0.1% | 353.56 ± 0.2% | 0.96 | 1.00 | 7.73 | 0.70 |
| literal: a word, second text | 10 | 575.36 ± 0.3% | 632.33 ± 0.2% | 1096.30 ± 0.1% | 377.53 ± 0.4% | 539.07 ± 2.0% | 802.63 ± 0.4% | 27017.19 ± 0.1% | 574.73 ± 0.1% | 0.91 | 1.00 | 1.52 | 1.07 |
| class: two capitalized words | 23 | 444.25 ± 0.1% | 472.78 ± 0.3% | 708.22 ± 0.2% | 99.92 ± 0.2% | 504.90 ± 0.7% | 752.09 ± 1.9% | 6356.37 ± 0.2% | 444.33 ± 0.1% | 0.94 | 1.00 | 4.45 | 0.88 |
| class: a word that ends in ing | 9 | 574.87 ± 0.4% | 643.89 ± 0.4% | 1179.95 ± 0.1% | 131.96 ± 0.7% | 759.69 ± 1.0% | 1110.65 ± 0.5% | 15829.33 ± 0.1% | 575.48 ± 0.2% | 0.89 | 1.00 | 4.36 | 0.76 |
| class: a word in capitals | 16 | 506.37 ± 0.7% | 545.21 ± 0.6% | 904.11 ± 1.2% | 135.23 ± 0.6% | 757.93 ± 2.8% | 1024.93 ± 1.1% | 8354.22 ± 0.1% | 507.73 ± 0.8% | 0.93 | 1.00 | 3.74 | 0.67 |
| class: a number | 6 | 638.36 ± 0.2% | 701.50 ± 0.6% | 1384.42 ± 0.1% | 42.08 ± 0.6% | 1404.06 ± 0.3% | 1860.06 ± 1.0% | 22706.90 ± 0.3% | 638.08 ± 0.2% | 0.91 | 1.00 | 15.17 | 0.45 |
| class: two capitalized words, second text | 23 | 443.87 ± 0.2% | 471.96 ± 0.6% | 708.57 ± 0.3% | 101.89 ± 0.7% | 506.35 ± 1.1% | 745.82 ± 1.3% | 6357.58 ± 0.1% | 443.80 ± 0.2% | 0.94 | 1.00 | 4.36 | 0.88 |
| other: a word between two words | 13 | 560.53 ± 0.5% | 579.60 ± 0.4% | 962.24 ± 0.5% | 132.69 ± 0.4% | 507.57 ± 0.7% | 806.17 ± 0.7% | 14693.21 ± 0.1% | 560.14 ± 0.5% | 0.97 | 1.00 | 4.22 | 1.10 |
| other: a number before a unit, second text | 15 | 411.45 ± 0.5% | 451.00 ± 0.3% | 653.27 ± 0.1% | 39.46 ± 0.4% | 637.03 ± 1.0% | 892.79 ± 0.1% | 15211.78 ± 0.1% | 411.34 ± 0.1% | 0.91 | 1.00 | 10.43 | 0.65 |
| other: a heading's start tag | 13 | 363.80 ± 0.3% | 369.54 ± 0.2% | 500.49 ± 0.3% | 43.80 ± 0.4% | 632.71 ± 1.3% | 873.08 ± 0.6% | 18117.00 ± 0.1% | 363.41 ± 0.3% | 0.98 | 1.00 | 8.31 | 0.57 |
| other: a whole word | 11 | 594.55 ± 0.4% | 631.69 ± 0.5% | 1098.17 ± 0.1% | 118.52 ± 0.3% | 569.03 ± 2.3% | 837.99 ± 0.7% | 26561.41 ± 0.2% | 592.74 ± 0.4% | 0.94 | 1.00 | 5.02 | 1.04 |
| other: a line's first word, second text | 17 | 544.77 ± 0.7% | 565.95 ± 0.4% | 950.45 ± 0.3% | 130.03 ± 0.5% | 717.88 ± 1.9% | refused | refused | 543.44 ± 0.6% | 0.96 | 1.00 | 4.19 | 0.76 |
| other: fourteen octets before an x | 16 | 112.66 ± 0.2% | 162.87 ± 1.1% | 190.00 ± 0.6% | 14.88 ± 0.7% | 457.20 ± 1.2% | 416.70 ± 0.8% | 12856.82 ± 0.3% | 112.55 ± 0.3% | 0.69 | 1.00 | 7.57 | 0.25 |
| other: a Greek word | 8 | 435.11 ± 0.4% | 596.91 ± 0.8% | 1049.17 ± 0.6% | 58.96 ± 0.7% | 1389.92 ± 0.8% | 1859.09 ± 0.5% | refused | 434.87 ± 0.4% | 0.73 | 1.00 | 7.38 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12846.90 ± 0.6% | not timed | not timed | 16367.59 ± 1.0% | 1990.29 ± 20.7% | not timed | not timed | 12855.96 ± 1.0% | | 1.00 | 0.78 | 6.45 |
| 01-literal/sherlock-casei-en | 522 | 3874.68 ± 0.3% | not timed | not timed | 3597.82 ± 0.2% | 32.53 ± 2.0% | not timed | not timed | 3871.84 ± 0.6% | | 1.00 | 1.08 | 119.10 |
| 01-literal/sherlock-ru | 724 | 13562.71 ± 0.4% | not timed | not timed | 17340.72 ± 0.3% | 1410.68 ± 13.4% | not timed | not timed | 13553.24 ± 0.5% | | 1.00 | 0.78 | 9.61 |
| 01-literal/sherlock-casei-ru | 746 | 5244.76 ± 0.1% | not timed | not timed | 3326.99 ± 0.2% | 31.75 ± 0.5% | not timed | not timed | 5250.14 ± 0.1% | | 1.00 | 1.58 | 165.18 |
| 01-literal/sherlock-zh | 30 | 16989.84 ± 0.5% | not timed | not timed | 18730.63 ± 0.7% | 2530.79 ± 6.8% | not timed | not timed | 16962.66 ± 0.2% | | 1.00 | 0.91 | 6.71 |
| 02-literal-alternate/sherlock-en | 714 | 5821.85 ± 0.4% | not timed | not timed | 3943.79 ± 0.2% | 16.55 ± 0.1% | not timed | not timed | 5823.70 ± 0.2% | | 1.00 | 1.48 | 351.67 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1667.59 ± 0.7% | not timed | not timed | 697.61 ± 0.1% | 11.12 ± 0.2% | not timed | not timed | 1659.64 ± 0.4% | | 1.00 | 2.39 | 149.92 |
| 02-literal-alternate/sherlock-ru | 899 | 4647.30 ± 0.2% | not timed | not timed | 3256.54 ± 0.1% | 22.63 ± 0.2% | not timed | not timed | 4656.53 ± 0.2% | | 1.00 | 1.43 | 205.32 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1784.11 ± 0.6% | not timed | not timed | 1230.25 ± 0.1% | 9.15 ± 5.7% | not timed | not timed | 1775.80 ± 0.3% | | 1.00 | 1.45 | 195.04 |
| 02-literal-alternate/sherlock-zh | 207 | 7041.05 ± 0.7% | not timed | not timed | 4166.77 ± 0.3% | 31.52 ± 0.0% | not timed | not timed | 7032.04 ± 1.0% | | 1.00 | 1.69 | 223.35 |
| 03-date/ascii | 111817 | 124.62 ± 0.3% | not timed | not timed | 95.72 ± 0.0% | 0.20 ± 3.1% | not timed | not timed | 123.50 ± 0.2% | | 1.01 | 1.30 | 623.94 |
| 04-ruff-noqa/real | 84 | 555.24 ± 0.1% | not timed | not timed | 463.58 ± 0.1% | 19.54 ± 1.2% | not timed | not timed | 554.25 ± 0.1% | | 1.00 | 1.20 | 28.42 |
| 04-ruff-noqa/tweaked | 44 | 546.14 ± 0.2% | not timed | not timed | 465.61 ± 0.0% | 360.47 ± 0.4% | not timed | not timed | 544.37 ± 0.2% | | 1.00 | 1.17 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.47 ± 0.2% | not timed | not timed | 5.18 ± 0.2% | 0.20 ± 5.3% | not timed | not timed | 3.57 ± 1.8% | | 0.97 | 0.67 | 16.94 |
| 06-cloud-flare-redos/original | 107 | 270.79 ± 0.3% | not timed | not timed | 214.97 ± 1.9% | 24.91 ± 0.2% | not timed | not timed | 269.84 ± 0.2% | | 1.00 | 1.26 | 10.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.83 ± 0.4% | not timed | not timed | 227.38 ± 0.2% | 26.78 ± 0.3% | not timed | not timed | 265.23 ± 0.9% | | 1.00 | 1.16 | 9.89 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.32 ± 0.2% | not timed | not timed | 254.76 ± 0.3% | 28.82 ± 0.4% | not timed | not timed | 294.31 ± 0.3% | | 1.00 | 1.16 | 10.21 |
| 07-unicode-character-data/parse-line | 558784 | 230.60 ± 4.3% | not timed | not timed | 175.92 ± 0.2% | 43.01 ± 1.0% | not timed | not timed | 232.37 ± 0.6% | | 0.99 | 1.31 | 5.36 |
| 08-words/all-english | 56691 | 119.56 ± 0.7% | not timed | not timed | 83.57 ± 0.1% | 12.96 ± 12.8% | not timed | not timed | 118.76 ± 0.6% | | 1.01 | 1.43 | 9.22 |
| 08-words/long-english | 839 | 1005.49 ± 0.2% | not timed | not timed | 596.36 ± 0.1% | 32.54 ± 4.0% | not timed | not timed | 1005.48 ± 0.0% | | 1.00 | 1.69 | 30.90 |
| 09-aws-keys/full | 0 | 412.72 ± 0.1% | not timed | not timed | 474.36 ± 0.1% | 64.64 ± 0.2% | not timed | not timed | 412.65 ± 0.0% | | 1.00 | 0.87 | 6.38 |
| 09-aws-keys/quick | 0 | 745.21 ± 0.1% | not timed | not timed | 998.59 ± 0.1% | 423.24 ± 0.8% | not timed | not timed | 743.49 ± 0.2% | | 1.00 | 0.75 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 633.93 ± 0.2% | not timed | not timed | 517.82 ± 0.3% | 19.49 ± 0.5% | not timed | not timed | 633.06 ± 0.2% | | 1.00 | 1.22 | 32.52 |
| 10-bounded-repeat/letters-ru | 3475 | 380.17 ± 0.3% | not timed | not timed | 478.94 ± 0.1% | 21.72 ± 8.9% | not timed | not timed | 379.00 ± 0.5% | | 1.00 | 0.79 | 17.50 |
| 10-bounded-repeat/context | 53 | 79.29 ± 1.1% | not timed | not timed | 66.07 ± 0.5% | 19.73 ± 0.0% | not timed | not timed | 79.25 ± 1.2% | | 1.00 | 1.20 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 1045.65 ± 0.1% | not timed | not timed | 615.80 ± 0.2% | 36.44 ± 0.2% | not timed | not timed | 1045.57 ± 0.0% | | 1.00 | 1.70 | 28.69 |
| 11-unstructured-to-json/extract | 600 | 47.74 ± 0.1% | not timed | not timed | 76.35 ± 0.4% | 49.04 ± 0.3% | not timed | not timed | 47.48 ± 0.1% | | 1.01 | 0.63 | 0.97 |
| 12-dictionary/single | 1 | 571.94 ± 0.4% | not timed | not timed | 563.33 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 572.23 ± 0.4% | | 1.00 | 1.02 | 1408.82 |
| 14-quadratic/1x | 100 | 12.99 ± 0.3% | not timed | not timed | 10.09 ± 0.3% | 0.98 ± 3.1% | not timed | not timed | 12.98 ± 0.4% | | 1.00 | 1.29 | 13.27 |
| 14-quadratic/2x | 200 | 7.98 ± 0.3% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 1.4% | not timed | not timed | 7.96 ± 2.2% | | 1.00 | 1.43 | 15.00 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.5% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.54 | 16.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.46 ± 0.2% | not timed | not timed | 0.34 ± 0.5% | 0.56 ± 2.3% | not timed | not timed | 1.45 ± 0.9% | | 1.00 | 4.23 | 2.62 |
| 04-ruff-noqa/compile-real | 1 | 93.09 ± 1.6% | not timed | not timed | 13.81 ± 0.3% | 141.60 ± 2.7% | not timed | not timed | 92.20 ± 1.1% | | 1.01 | 6.74 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.69 ± 0.6% | not timed | not timed | 2.55 ± 0.8% | 6.52 ± 2.3% | not timed | not timed | 14.67 ± 1.7% | | 1.00 | 5.76 | 2.25 |
| 07-unicode-character-data/compile | 1 | 58.29 ± 0.1% | not timed | not timed | 25.86 ± 0.4% | 37.13 ± 2.4% | not timed | not timed | 58.27 ± 0.3% | | 1.00 | 2.25 | 1.57 |
| 09-aws-keys/compile-full | 1 | 43.62 ± 0.2% | not timed | not timed | 8.32 ± 0.2% | 23.69 ± 0.6% | not timed | not timed | 43.48 ± 0.3% | | 1.00 | 5.24 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 188.62 ± 0.1% | not timed | not timed | 47.48 ± 0.1% | 135.07 ± 3.6% | not timed | not timed | 190.53 ± 0.2% | | 0.99 | 3.97 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.65 ± 1.0% | not timed | not timed | 11.17 ± 0.2% | 16.36 ± 3.0% | not timed | not timed | 14.60 ± 0.8% | | 1.00 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 86.22 ± 0.2% | not timed | not timed | 8.07 ± 0.0% | 24.32 ± 1.6% | not timed | not timed | 85.86 ± 0.9% | | 1.00 | 10.69 | 3.55 |
| 11-unstructured-to-json/compile | 1 | 90.75 ± 0.5% | not timed | not timed | 41.28 ± 0.6% | 68.98 ± 2.9% | not timed | not timed | 90.54 ± 1.0% | | 1.00 | 2.20 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 0.9% | 0.10 ± 11.0% | not timed | not timed | 0.36 ± 2.2% | | 1.00 | 5.14 | 3.71 |

