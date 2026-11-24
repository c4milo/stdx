# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391506872 |
| Date | 2026-11-24 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 35663.39 ± 0.2% | 4109.08 ± 0.1% | 33.90 ± 1.2% | 31790.69 ± 0.7% | 12861.09 ± 2.5% | 14.81 ± 0.2% | 107.75 ± 1.1% | 35660.75 ± 0.2% | 8.68 | 1.00 | 1.12 | 2.77 |
| literal: a word that is not there | 0 | 41480.24 ± 0.4% | 4008.05 ± 0.5% | 34.05 ± 1.0% | 35298.51 ± 0.2% | 39416.69 ± 0.5% | 14.41 ± 0.2% | 107.00 ± 2.9% | 41550.68 ± 0.3% | 10.35 | 1.00 | 1.18 | 1.05 |
| literal: one of four words | 661 | 13154.94 ± 0.5% | 1973.76 ± 0.5% | 18.91 ± 1.3% | 9518.18 ± 0.4% | 29.16 ± 4.1% | 4.31 ± 0.1% | 7.99 ± 0.8% | 13125.29 ± 2.1% | 6.66 | 1.00 | 1.38 | 451.19 |
| literal: a word in any case | 217 | 29588.83 ± 0.7% | 2103.00 ± 0.2% | 24.63 ± 1.7% | 9824.40 ± 0.3% | 58.36 ± 0.8% | refused | differs | 29709.70 ± 0.5% | 14.07 | 1.00 | 3.01 | 506.98 |
| literal: an href attribute | 33 | 29944.30 ± 0.5% | 646.97 ± 0.4% | 29.53 ± 1.2% | 29270.68 ± 0.9% | 2601.06 ± 5.4% | 10.57 ± 0.4% | 101.01 ± 1.4% | 29968.36 ± 1.0% | 46.28 | 1.00 | 1.02 | 11.51 |
| literal: a word, second text | 123 | 36743.55 ± 0.2% | 3099.59 ± 0.5% | 33.77 ± 1.3% | 32682.57 ± 0.3% | 9230.29 ± 6.6% | 19.44 ± 0.3% | 98.80 ± 0.9% | 36754.21 ± 0.6% | 11.85 | 1.00 | 1.12 | 3.98 |
| class: two capitalized words | 1331 | 982.96 ± 0.3% | 633.07 ± 0.2% | 30.99 ± 1.1% | 611.39 ± 0.1% | 48.75 ± 17.0% | 12.62 ± 0.4% | 79.36 ± 0.3% | 983.64 ± 0.5% | 1.55 | 1.00 | 1.61 | 20.16 |
| class: a word that ends in ing | 3399 | 602.29 ± 0.3% | 602.16 ± 0.3% | 20.15 ± 2.1% | 575.28 ± 0.2% | 35.50 ± 13.3% | 7.16 ± 0.1% | 21.82 ± 0.4% | 602.47 ± 0.5% | 1.00 | 1.00 | 1.05 | 16.97 |
| class: a word in capitals | 2332 | 1335.00 ± 0.1% | 639.83 ± 0.3% | 32.99 ± 1.3% | 602.85 ± 0.2% | 52.66 ± 0.2% | 15.25 ± 0.2% | 96.09 ± 1.2% | 1334.20 ± 0.2% | 2.09 | 1.00 | 2.21 | 25.35 |
| class: a number | 8288 | 2052.93 ± 0.6% | 868.66 ± 0.2% | 32.11 ± 1.4% | 2137.29 ± 0.4% | 52.00 ± 10.7% | 0.42 ± 0.3% | 75.65 ± 0.3% | 2054.88 ± 0.1% | 2.36 | 1.00 | 0.96 | 39.48 |
| class: two capitalized words, second text | 5359 | 534.75 ± 0.2% | 542.01 ± 0.2% | 27.68 ± 0.8% | 506.59 ± 0.3% | 40.39 ± 14.4% | 16.50 ± 0.4% | 72.47 ± 0.2% | 534.67 ± 0.2% | 0.99 | 1.00 | 1.06 | 13.24 |
| other: a word between two words | 6104 | 865.11 ± 0.4% | 617.88 ± 0.2% | 27.30 ± 0.5% | 873.59 ± 0.5% | 127.56 ± 9.1% | 9.62 ± 0.3% | 87.54 ± 0.4% | 866.46 ± 0.3% | 1.40 | 1.00 | 0.99 | 6.78 |
| other: a number before a unit, second text | 1481 | 8841.53 ± 0.8% | 1153.28 ± 0.2% | 31.39 ± 2.3% | 9511.72 ± 0.3% | 48.92 ± 8.3% | 17.35 ± 0.3% | 78.50 ± 0.5% | 8845.00 ± 2.3% | 7.67 | 1.00 | 0.93 | 180.74 |
| other: a heading's start tag | 110 | 21354.68 ± 0.4% | 785.72 ± 0.1% | 32.57 ± 1.6% | 2704.58 ± 0.3% | 1911.83 ± 7.7% | 13.20 ± 0.4% | 114.76 ± 0.7% | 21367.87 ± 3.2% | 27.18 | 1.00 | 7.90 | 11.17 |
| other: a whole word | 217 | 26066.97 ± 0.2% | 638.41 ± 0.2% | 34.45 ± 0.6% | 25619.84 ± 0.3% | 60.28 ± 0.6% | 12.53 ± 0.3% | 64.09 ± 0.8% | 26092.97 ± 0.3% | 40.83 | 1.00 | 1.02 | 432.42 |
| other: a line's first word, second text | 3716 | 2538.17 ± 0.5% | 618.66 ± 0.2% | 34.80 ± 1.5% | 2467.35 ± 0.4% | 80.34 ± 4.6% | refused | refused | 2544.33 ± 0.5% | 4.10 | 1.00 | 1.03 | 31.59 |
| other: fourteen octets before an x | 87 | 36152.50 ± 0.6% | 311.80 ± 3.4% | 7.57 ± 0.5% | 4190.13 ± 0.5% | 11.63 ± 0.8% | differs | 19.95 ± 0.8% | 36292.88 ± 1.1% | 115.95 | 1.00 | 8.63 | 3109.37 |
| other: a Greek word | 21815 | 530.75 ± 1.1% | 410.87 ± 0.6% | 36.84 ± 0.7% | 312.47 ± 0.3% | 53.11 ± 1.6% | differs | refused | 531.57 ± 0.3% | 1.29 | 1.00 | 1.70 | 9.99 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.24 ± 0.3% | 23.23 ± 0.3% | 1.10 ± 0.6% | 21.50 ± 0.7% | 3.21 ± 0.7% | differs | 4.84 ± 0.4% | 23.21 ± 1.8% | 1.00 | 1.00 | 1.08 | 7.24 |
| a UUID | 32895 | 26.11 ± 0.4% | 26.09 ± 0.3% | 0.75 ± 2.6% | 16.50 ± 0.4% | 3.20 ± 1.3% | 0.71 ± 0.2% | 3.93 ± 2.9% | 26.11 ± 0.8% | 1.00 | 1.00 | 1.58 | 8.15 |
| an IPv4 address | 33176 | 37.90 ± 0.5% | 37.84 ± 0.6% | 2.41 ± 1.0% | 31.56 ± 1.6% | 8.08 ± 0.7% | differs | 4.64 ± 0.7% | 37.79 ± 2.9% | 1.00 | 1.00 | 1.20 | 4.69 |
| a date and time | 32954 | 37.83 ± 0.3% | 37.88 ± 0.4% | 1.79 ± 0.5% | 23.90 ± 0.4% | 10.24 ± 1.5% | 1.30 ± 0.3% | 8.62 ± 0.4% | 37.94 ± 0.9% | 1.00 | 1.00 | 1.58 | 3.69 |
| a field path | 32606 | 26.25 ± 0.3% | 26.34 ± 0.1% | 1.27 ± 0.7% | 24.84 ± 0.1% | 3.71 ± 0.3% | differs | 3.13 ± 1.0% | 26.30 ± 0.2% | 1.00 | 1.00 | 1.06 | 7.08 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.89 ± 0.6% | 12.87 ± 0.5% | 12.90 ± 0.4% | 14.64 ± 1.1% | 6.75 ± 0.7% | 1.03 ± 0.6% | none | 12.89 ± 0.7% | 1.00 | 1.00 | 0.88 | 1.91 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 292.99 ± 0.2% | 295.08 ± 0.2% | 345.78 ± 0.2% | 117.80 ± 1.7% | 259.97 ± 8.7% | 688.15 ± 1.9% | 4011.75 ± 0.5% | 293.43 ± 0.3% | 0.99 | 1.00 | 2.49 | 1.13 |
| a UUID | 62 | 190.84 ± 0.9% | 191.48 ± 3.0% | 213.77 ± 0.4% | 62.11 ± 1.2% | 118.87 ± 0.3% | 253.82 ± 1.3% | 5549.84 ± 0.5% | 191.13 ± 0.2% | 1.00 | 1.00 | 3.07 | 1.61 |
| an IPv4 address | 29 | 568.77 ± 0.8% | 575.92 ± 0.3% | 799.78 ± 0.2% | 101.49 ± 2.8% | 157.52 ± 1.1% | 432.70 ± 3.4% | 10068.34 ± 0.6% | 569.85 ± 0.7% | 0.99 | 1.00 | 5.60 | 3.61 |
| a date and time | 56 | 423.40 ± 4.1% | 427.78 ± 1.2% | 536.23 ± 0.2% | 96.72 ± 3.4% | 166.21 ± 2.9% | 450.68 ± 1.6% | 5568.50 ± 2.6% | 423.36 ± 9.7% | 0.99 | 1.00 | 4.38 | 2.55 |
| a field path | 39 | 288.04 ± 0.6% | 289.76 ± 0.2% | 338.23 ± 0.3% | 105.94 ± 0.3% | 247.74 ± 0.8% | 707.88 ± 0.7% | 5331.57 ± 1.1% | 288.19 ± 0.3% | 0.99 | 1.00 | 2.72 | 1.16 |
| literal: a word | 7 | 851.68 ± 0.3% | 932.83 ± 0.3% | 1645.73 ± 0.2% | 711.65 ± 1.1% | 823.88 ± 1.7% | 1448.80 ± 0.5% | 31409.99 ± 2.1% | 853.97 ± 0.5% | 0.91 | 1.00 | 1.20 | 1.03 |
| literal: a word that is not there | 8 | 819.18 ± 0.5% | 901.30 ± 0.3% | 1540.67 ± 1.3% | 663.39 ± 0.6% | 778.43 ± 27.1% | 1359.37 ± 0.4% | 30326.47 ± 1.4% | 819.67 ± 0.5% | 0.91 | 1.00 | 1.23 | 1.05 |
| literal: one of four words | 26 | 332.36 ± 0.0% | 547.24 ± 0.2% | 737.76 ± 0.4% | 51.25 ± 1.4% | 305.76 ± 1.6% | 516.49 ± 1.0% | 15207.15 ± 0.8% | 332.15 ± 0.5% | 0.61 | 1.00 | 6.48 | 1.09 |
| literal: a word in any case | 11 | 599.95 ± 0.4% | 645.88 ± 0.5% | 929.31 ± 0.3% | 17.75 ± 0.5% | 862.51 ± 12.9% | refused | 26794.31 ± 5.5% | 599.72 ± 0.4% | 0.93 | 1.00 | 33.79 | 0.70 |
| literal: an href attribute | 12 | 443.80 ± 0.6% | 461.12 ± 0.3% | 594.82 ± 0.7% | 50.12 ± 0.5% | 623.33 ± 17.3% | 1156.89 ± 0.8% | 25953.94 ± 3.0% | 443.41 ± 0.6% | 0.96 | 1.00 | 8.85 | 0.71 |
| literal: a word, second text | 10 | 754.44 ± 0.7% | 848.35 ± 0.5% | 1390.48 ± 0.4% | 588.00 ± 0.4% | 682.85 ± 3.7% | 1172.51 ± 0.5% | 28998.01 ± 0.4% | 755.75 ± 0.2% | 0.89 | 1.00 | 1.28 | 1.10 |
| class: two capitalized words | 23 | 620.09 ± 1.3% | 678.17 ± 1.1% | 1002.48 ± 1.0% | 134.46 ± 1.0% | 637.86 ± 1.6% | 1097.38 ± 1.3% | 6747.12 ± 1.6% | 621.04 ± 1.0% | 0.91 | 1.00 | 4.61 | 0.97 |
| class: a word that ends in ing | 9 | 759.49 ± 0.5% | 879.15 ± 0.5% | 1556.64 ± 0.8% | 170.82 ± 0.6% | 935.87 ± 1.8% | 1694.52 ± 1.5% | 19481.16 ± 1.7% | 758.65 ± 0.7% | 0.86 | 1.00 | 4.45 | 0.81 |
| class: a word in capitals | 16 | 683.60 ± 0.9% | 755.23 ± 0.6% | 1224.40 ± 0.9% | 181.98 ± 1.1% | 933.93 ± 1.5% | 1554.81 ± 1.7% | 8863.61 ± 1.2% | 684.39 ± 0.7% | 0.91 | 1.00 | 3.76 | 0.73 |
| class: a number | 6 | 850.12 ± 1.0% | 959.28 ± 0.8% | 1826.99 ± 0.8% | 43.80 ± 0.8% | 1733.70 ± 1.7% | 2942.52 ± 1.8% | 29639.34 ± 1.6% | 849.21 ± 0.8% | 0.89 | 1.00 | 19.41 | 0.49 |
| class: two capitalized words, second text | 23 | 620.38 ± 0.8% | 676.74 ± 0.7% | 999.52 ± 0.8% | 134.19 ± 1.0% | 632.11 ± 2.4% | 1113.06 ± 1.7% | 6735.88 ± 0.6% | 621.86 ± 0.8% | 0.92 | 1.00 | 4.62 | 0.98 |
| other: a word between two words | 13 | 737.08 ± 0.9% | 771.16 ± 0.5% | 1221.29 ± 0.9% | 185.30 ± 1.1% | 624.79 ± 2.0% | 1202.14 ± 0.7% | 17048.28 ± 2.0% | 735.84 ± 0.5% | 0.96 | 1.00 | 3.98 | 1.18 |
| other: a number before a unit, second text | 15 | 524.84 ± 0.4% | 590.49 ± 0.7% | 817.89 ± 4.3% | 42.20 ± 1.2% | 784.89 ± 14.6% | 1355.76 ± 0.7% | 18275.95 ± 2.3% | 524.63 ± 0.9% | 0.89 | 1.00 | 12.44 | 0.67 |
| other: a heading's start tag | 13 | 455.34 ± 0.5% | 462.16 ± 0.9% | 601.98 ± 0.7% | 48.10 ± 0.7% | 767.20 ± 4.0% | 1307.12 ± 0.7% | 21902.22 ± 1.8% | 455.09 ± 3.6% | 0.99 | 1.00 | 9.47 | 0.59 |
| other: a whole word | 11 | 760.62 ± 0.5% | 824.40 ± 0.5% | 1327.46 ± 0.2% | 162.09 ± 0.4% | 727.95 ± 1.1% | 1231.72 ± 2.0% | 29784.41 ± 2.8% | 760.42 ± 0.5% | 0.92 | 1.00 | 4.69 | 1.04 |
| other: a line's first word, second text | 17 | 712.85 ± 0.7% | 759.49 ± 0.9% | 1241.03 ± 0.6% | 171.83 ± 0.5% | 875.65 ± 0.5% | refused | refused | 714.04 ± 0.6% | 0.94 | 1.00 | 4.15 | 0.81 |
| other: fourteen octets before an x | 16 | 133.31 ± 0.8% | 185.66 ± 0.1% | 213.25 ± 0.5% | 18.57 ± 0.8% | 549.67 ± 0.9% | 581.59 ± 0.9% | 16074.43 ± 2.3% | 132.97 ± 0.7% | 0.72 | 1.00 | 7.18 | 0.24 |
| other: a Greek word | 8 | 575.63 ± 1.1% | 789.44 ± 0.6% | 1326.33 ± 0.5% | 61.13 ± 0.8% | 1727.67 ± 1.1% | 2796.87 ± 1.8% | refused | 575.77 ± 0.7% | 0.73 | 1.00 | 9.42 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29145.84 ± 0.7% | not timed | not timed | 28595.70 ± 2.0% | 2903.73 ± 3.2% | not timed | not timed | 29126.49 ± 4.4% | | 1.00 | 1.02 | 10.04 |
| 01-literal/sherlock-casei-en | 522 | 23337.31 ± 2.9% | not timed | not timed | 8415.80 ± 0.5% | 39.82 ± 0.3% | not timed | not timed | 23618.23 ± 2.4% | | 0.99 | 2.77 | 586.08 |
| 01-literal/sherlock-ru | 724 | 28995.23 ± 0.8% | not timed | not timed | 27787.65 ± 0.4% | 1587.87 ± 13.1% | not timed | not timed | 29006.82 ± 0.8% | | 1.00 | 1.04 | 18.26 |
| 01-literal/sherlock-casei-ru | 746 | 10794.26 ± 0.9% | not timed | not timed | 6469.52 ± 0.8% | 42.54 ± 3.1% | not timed | not timed | 10837.62 ± 1.2% | | 1.00 | 1.67 | 253.75 |
| 01-literal/sherlock-zh | 30 | 38783.87 ± 0.8% | not timed | not timed | 34467.26 ± 0.6% | 1600.83 ± 3.9% | not timed | not timed | 38743.64 ± 0.8% | | 1.00 | 1.13 | 24.23 |
| 02-literal-alternate/sherlock-en | 714 | 12382.41 ± 0.8% | not timed | not timed | 9363.13 ± 1.0% | 22.25 ± 3.4% | not timed | not timed | 12361.42 ± 1.4% | | 1.00 | 1.32 | 556.50 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2262.57 ± 1.1% | not timed | not timed | 2287.27 ± 0.9% | 13.55 ± 1.0% | not timed | not timed | 2276.75 ± 1.0% | | 0.99 | 0.99 | 166.98 |
| 02-literal-alternate/sherlock-ru | 899 | 9237.55 ± 1.0% | not timed | not timed | 5125.41 ± 1.5% | 28.57 ± 14.6% | not timed | not timed | 9270.54 ± 1.0% | | 1.00 | 1.80 | 323.34 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2332.14 ± 2.0% | not timed | not timed | 1241.38 ± 2.2% | 11.64 ± 0.3% | not timed | not timed | 2329.84 ± 1.0% | | 1.00 | 1.88 | 200.40 |
| 02-literal-alternate/sherlock-zh | 207 | 16797.29 ± 0.2% | not timed | not timed | 10699.56 ± 0.5% | 41.17 ± 6.3% | not timed | not timed | 16794.05 ± 0.3% | | 1.00 | 1.57 | 408.03 |
| 03-date/ascii | 111817 | 127.44 ± 0.6% | not timed | not timed | 110.04 ± 1.0% | 0.27 ± 3.0% | not timed | not timed | 127.69 ± 0.5% | | 1.00 | 1.16 | 473.90 |
| 04-ruff-noqa/real | 84 | 556.63 ± 0.8% | not timed | not timed | 561.66 ± 1.1% | 23.37 ± 1.5% | not timed | not timed | 556.04 ± 0.6% | | 1.00 | 0.99 | 23.82 |
| 04-ruff-noqa/tweaked | 44 | 658.42 ± 0.4% | not timed | not timed | 563.72 ± 1.0% | 374.42 ± 3.8% | not timed | not timed | 660.69 ± 0.7% | | 1.00 | 1.17 | 1.76 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.3% | not timed | not timed | 5.72 ± 1.0% | 0.27 ± 5.6% | not timed | not timed | 5.32 ± 3.9% | | 1.00 | 0.93 | 19.70 |
| 06-cloud-flare-redos/original | 107 | 473.54 ± 0.6% | not timed | not timed | 260.38 ± 0.8% | 32.12 ± 1.3% | not timed | not timed | 473.86 ± 0.7% | | 1.00 | 1.82 | 14.75 |
| 06-cloud-flare-redos/simplified-short | 102 | 418.95 ± 0.6% | not timed | not timed | 265.82 ± 0.5% | 35.08 ± 1.0% | not timed | not timed | 420.04 ± 0.9% | | 1.00 | 1.58 | 11.94 |
| 06-cloud-flare-redos/simplified-long | 10000 | 557.17 ± 0.8% | not timed | not timed | 279.21 ± 0.8% | 37.81 ± 7.0% | not timed | not timed | 557.40 ± 0.2% | | 1.00 | 2.00 | 14.74 |
| 07-unicode-character-data/parse-line | 558784 | 277.63 ± 0.7% | not timed | not timed | 205.57 ± 3.6% | 52.90 ± 6.2% | not timed | not timed | 278.79 ± 1.1% | | 1.00 | 1.35 | 5.25 |
| 08-words/all-english | 56691 | 112.92 ± 1.0% | not timed | not timed | 93.23 ± 1.0% | 14.21 ± 8.2% | not timed | not timed | 113.22 ± 2.0% | | 1.00 | 1.21 | 7.94 |
| 08-words/long-english | 839 | 643.84 ± 0.7% | not timed | not timed | 622.24 ± 0.8% | 38.01 ± 2.2% | not timed | not timed | 644.66 ± 0.5% | | 1.00 | 1.03 | 16.94 |
| 09-aws-keys/full | 0 | 568.77 ± 0.3% | not timed | not timed | 577.11 ± 0.6% | 82.49 ± 5.0% | not timed | not timed | 567.94 ± 0.3% | | 1.00 | 0.99 | 6.90 |
| 09-aws-keys/quick | 0 | 1128.22 ± 7.4% | not timed | not timed | 897.00 ± 2.4% | 428.31 ± 18.7% | not timed | not timed | 1123.07 ± 9.7% | | 1.00 | 1.26 | 2.63 |
| 10-bounded-repeat/letters-en | 1833 | 634.03 ± 1.8% | not timed | not timed | 550.39 ± 1.1% | 24.00 ± 0.7% | not timed | not timed | 635.14 ± 2.0% | | 1.00 | 1.15 | 26.42 |
| 10-bounded-repeat/letters-ru | 3475 | 535.14 ± 1.5% | not timed | not timed | 492.78 ± 0.5% | 26.35 ± 17.8% | not timed | not timed | 532.52 ± 3.6% | | 1.00 | 1.09 | 20.31 |
| 10-bounded-repeat/context | 53 | 96.28 ± 1.3% | not timed | not timed | 73.84 ± 0.8% | 24.20 ± 0.4% | not timed | not timed | 96.33 ± 1.6% | | 1.00 | 1.30 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 666.16 ± 8.6% | not timed | not timed | 634.81 ± 1.0% | 43.83 ± 1.0% | not timed | not timed | 667.68 ± 8.6% | | 1.00 | 1.05 | 15.20 |
| 11-unstructured-to-json/extract | 600 | 54.08 ± 1.1% | not timed | not timed | 80.37 ± 0.3% | 64.09 ± 0.4% | not timed | not timed | 54.07 ± 0.4% | | 1.00 | 0.67 | 0.84 |
| 12-dictionary/single | 1 | 572.72 ± 0.3% | not timed | not timed | 547.47 ± 0.2% | 0.52 ± 0.3% | not timed | not timed | 573.86 ± 0.6% | | 1.00 | 1.05 | 1095.98 |
| 14-quadratic/1x | 100 | 29.73 ± 0.7% | not timed | not timed | 13.46 ± 0.5% | 1.19 ± 4.3% | not timed | not timed | 29.80 ± 0.6% | | 1.00 | 2.21 | 25.04 |
| 14-quadratic/2x | 200 | 22.92 ± 0.4% | not timed | not timed | 6.59 ± 0.4% | 0.63 ± 0.3% | not timed | not timed | 22.95 ± 0.5% | | 1.00 | 3.48 | 36.31 |
| 14-quadratic/10x | 1000 | 7.16 ± 1.0% | not timed | not timed | 1.29 ± 0.3% | 0.14 ± 1.1% | not timed | not timed | 7.16 ± 0.6% | | 1.00 | 5.54 | 49.48 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.6% | not timed | not timed | 0.43 ± 0.4% | 0.66 ± 1.5% | not timed | not timed | 1.54 ± 0.4% | | 1.00 | 3.60 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 144.98 ± 0.8% | not timed | not timed | 15.92 ± 0.7% | 175.92 ± 0.5% | not timed | not timed | 145.29 ± 1.5% | | 1.00 | 9.11 | 0.82 |
| 05-lexer-veryl/compile-single | 1 | 19.15 ± 0.9% | not timed | not timed | 3.02 ± 0.5% | 7.72 ± 2.9% | not timed | not timed | 19.23 ± 1.4% | | 1.00 | 6.35 | 2.48 |
| 07-unicode-character-data/compile | 1 | 149.96 ± 1.6% | not timed | not timed | 31.78 ± 0.7% | 44.39 ± 1.7% | not timed | not timed | 149.75 ± 1.3% | | 1.00 | 4.72 | 3.38 |
| 09-aws-keys/compile-full | 1 | 63.85 ± 0.6% | not timed | not timed | 8.91 ± 0.6% | 27.95 ± 2.3% | not timed | not timed | 63.87 ± 0.7% | | 1.00 | 7.16 | 2.28 |
| 09-aws-keys/compile-quick | 1 | 228.06 ± 0.9% | not timed | not timed | 59.61 ± 0.8% | 161.98 ± 3.4% | not timed | not timed | 228.96 ± 1.5% | | 1.00 | 3.83 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 64.63 ± 0.8% | not timed | not timed | 14.47 ± 0.5% | 20.29 ± 3.6% | not timed | not timed | 64.57 ± 1.3% | | 1.00 | 4.47 | 3.19 |
| 10-bounded-repeat/compile-capitals | 1 | 95.57 ± 0.3% | not timed | not timed | 10.85 ± 0.5% | 29.49 ± 0.9% | not timed | not timed | 96.23 ± 0.6% | | 0.99 | 8.81 | 3.24 |
| 11-unstructured-to-json/compile | 1 | 227.38 ± 3.4% | not timed | not timed | 48.98 ± 1.3% | 81.84 ± 5.0% | not timed | not timed | 227.24 ± 2.7% | | 1.00 | 4.64 | 2.78 |
| 12-dictionary/compile-single | 1 | 0.37 ± 1.9% | not timed | not timed | 0.08 ± 1.3% | 0.12 ± 12.8% | not timed | not timed | 0.37 ± 3.0% | | 1.00 | 4.66 | 3.10 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.16 ± 2.6% | not timed | not timed | 7.74 ± 0.3% | 0.66 ± 12.6% | not timed | not timed | 7.52 ± 4.8% | | 0.95 | 0.92 | 10.89 |
| dictionary/search/english-10 | 690 | 1.46 ± 0.7% | not timed | not timed | 131.36 ± 0.4% | 0.01 ± 0.8% | not timed | not timed | 1.45 ± 0.5% | | 1.01 | 0.0111 | 220.40 |
| dictionary/search/english-15 | 15 | 572.51 ± 1.7% | not timed | not timed | 547.67 ± 0.4% | 0.50 ± 0.3% | not timed | not timed | 573.75 ± 0.3% | | 1.00 | 1.05 | 1156.23 |
| folly/awyer-inn-busted | 1 | 4395.25 ± 0.6% | not timed | not timed | 134.39 ± 0.5% | 55.70 ± 1.0% | not timed | not timed | 4394.14 ± 0.8% | | 1.00 | 32.71 | 78.91 |
| folly/literal-never-match-rare | 0 | 29502.03 ± 0.2% | not timed | not timed | 28995.05 ± 0.3% | 28991.67 ± 0.2% | not timed | not timed | 29564.23 ± 0.4% | | 1.00 | 1.02 | 1.02 |
| folly/literal-never-match-frequent | 0 | 18290.83 ± 1.1% | not timed | not timed | 28922.18 ± 0.2% | 2584.75 ± 0.4% | not timed | not timed | 18222.38 ± 1.0% | | 1.00 | 0.63 | 7.08 |
| folly/literal-never-match-tricksy | 1 | 3355.61 ± 0.4% | not timed | not timed | 5687.77 ± 18.6% | 1626.90 ± 0.1% | not timed | not timed | 3356.16 ± 0.3% | | 1.00 | 0.59 | 2.06 |
| grep/every-line | 239963 | 1441.77 ± 3.1% | not timed | not timed | 938.30 ± 0.3% | 400.90 ± 20.6% | not timed | not timed | 1448.07 ± 0.5% | | 1.00 | 1.54 | 3.60 |
| grep/long-words-ascii | 5073 | 549.82 ± 0.3% | not timed | not timed | 518.54 ± 0.6% | 53.53 ± 7.7% | not timed | not timed | 551.13 ± 0.2% | | 1.00 | 1.06 | 10.27 |
| imported/leipzig/twain | 811 | 28674.55 ± 3.0% | not timed | not timed | 28070.14 ± 1.1% | 12383.36 ± 9.6% | not timed | not timed | 28527.15 ± 1.8% | | 1.01 | 1.02 | 2.32 |
| imported/leipzig/twain-insensitive | 965 | 13358.72 ± 3.0% | not timed | not timed | 7661.78 ± 0.4% | 53.62 ± 0.5% | not timed | not timed | 13531.40 ± 2.2% | | 0.99 | 1.74 | 249.16 |
| imported/leipzig/shing | 1540 | 662.24 ± 0.1% | not timed | not timed | 17854.17 ± 1.2% | 41.67 ± 0.2% | not timed | not timed | 662.42 ± 0.1% | | 1.00 | 0.0371 | 15.89 |
| imported/leipzig/huck-saw | 262 | 18386.11 ± 5.4% | not timed | not timed | 15852.34 ± 0.2% | 42.29 ± 0.6% | not timed | not timed | 19157.88 ± 6.5% | | 0.96 | 1.16 | 434.81 |
| imported/leipzig/word-ending-nn | 262 | 636.52 ± 1.0% | not timed | not timed | 630.33 ± 0.6% | 30.06 ± 0.3% | not timed | not timed | 636.44 ± 0.8% | | 1.00 | 1.01 | 21.17 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11361.33 ± 1.2% | not timed | not timed | 4262.65 ± 0.7% | 12.29 ± 0.1% | not timed | not timed | 11455.25 ± 1.5% | | 0.99 | 2.67 | 924.25 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 16169.27 ± 4.5% | not timed | not timed | 14675.23 ± 3.4% | 22.76 ± 0.6% | not timed | not timed | 16049.84 ± 6.2% | | 1.01 | 1.10 | 710.42 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5711.88 ± 2.0% | not timed | not timed | 959.48 ± 0.7% | 13.62 ± 0.4% | not timed | not timed | 5793.62 ± 1.6% | | 0.99 | 5.95 | 419.46 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 638.44 ± 0.6% | not timed | not timed | 629.03 ± 0.9% | 14.32 ± 0.9% | not timed | not timed | 638.11 ± 0.7% | | 1.00 | 1.01 | 44.59 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 635.92 ± 0.4% | not timed | not timed | 629.87 ± 1.5% | 12.03 ± 0.4% | not timed | not timed | 636.76 ± 0.2% | | 1.00 | 1.01 | 52.88 |
| imported/leipzig/tom-river | 2 | 10994.42 ± 3.2% | not timed | not timed | 12080.75 ± 0.2% | 40.60 ± 1.5% | not timed | not timed | 11232.12 ± 3.4% | | 0.98 | 0.91 | 270.77 |
| imported/leipzig/ing | 78424 | 626.00 ± 0.9% | not timed | not timed | 585.45 ± 0.9% | 33.17 ± 3.9% | not timed | not timed | 626.67 ± 0.8% | | 1.00 | 1.07 | 18.87 |
| imported/leipzig/ing-whitespace | 55248 | 786.71 ± 1.4% | not timed | not timed | 2305.92 ± 4.1% | 24.19 ± 3.0% | not timed | not timed | 785.82 ± 0.3% | | 1.00 | 0.34 | 32.52 |
| imported/leipzig/awyer-inn | 209 | 803.78 ± 2.2% | not timed | not timed | 7214.88 ± 5.4% | 27.46 ± 0.2% | not timed | not timed | 804.40 ± 1.3% | | 1.00 | 0.11 | 29.27 |
| imported/leipzig/quotes-bounded | 8886 | 1787.31 ± 5.7% | not timed | not timed | 3428.07 ± 0.3% | 44.50 ± 0.9% | not timed | not timed | 1885.62 ± 10.8% | | 0.95 | 0.52 | 40.17 |
| imported/leipzig/non-ascii-alternate | 2 | 24690.57 ± 3.1% | not timed | not timed | 16613.20 ± 0.3% | 63.83 ± 1.6% | not timed | not timed | 25074.46 ± 2.2% | | 0.98 | 1.49 | 386.83 |
| imported/leipzig/math-symbols | 69 | 2107.02 ± 14.8% | not timed | not timed | 636.86 ± 0.9% | 44.13 ± 0.4% | not timed | not timed | 2015.34 ± 15.5% | | 1.05 | 3.31 | 47.74 |
| imported/leipzig/bounded-strings-ending-z | 0 | 634.02 ± 0.4% | not timed | not timed | 633.71 ± 0.3% | 30.37 ± 0.3% | not timed | not timed | 634.66 ± 0.1% | | 1.00 | 1.00 | 20.88 |
| imported/lh3lh3-reb/uri | 17549 | 780.67 ± 3.1% | not timed | not timed | 1031.67 ± 1.5% | 33.67 ± 2.4% | not timed | not timed | 784.24 ± 2.3% | | 1.00 | 0.76 | 23.18 |
| imported/lh3lh3-reb/email | 15057 | 857.81 ± 1.5% | not timed | not timed | 1072.09 ± 0.8% | 37.55 ± 3.1% | not timed | not timed | 857.10 ± 1.5% | | 1.00 | 0.80 | 22.84 |
| imported/lh3lh3-reb/date | 668 | 860.09 ± 1.0% | not timed | not timed | 964.81 ± 2.0% | 60.72 ± 4.4% | not timed | not timed | 864.45 ± 1.0% | | 0.99 | 0.89 | 14.16 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 801.67 ± 1.2% | not timed | not timed | 473.88 ± 0.9% | 18.94 ± 1.9% | not timed | not timed | 794.91 ± 1.9% | | 1.01 | 1.69 | 42.33 |
| imported/mariomka/email | 92 | 734.89 ± 0.6% | not timed | not timed | 26341.57 ± 0.6% | 39.04 ± 0.5% | not timed | not timed | 736.26 ± 0.8% | | 1.00 | 0.0279 | 18.82 |
| imported/mariomka/uri | 5301 | 632.28 ± 0.5% | not timed | not timed | 7276.89 ± 1.2% | 39.16 ± 0.4% | not timed | not timed | 631.62 ± 0.8% | | 1.00 | 0.0869 | 16.15 |
| imported/mariomka/ip | 5 | 1898.11 ± 3.8% | not timed | not timed | 2446.97 ± 0.2% | 26.32 ± 0.3% | not timed | not timed | 1901.12 ± 6.0% | | 1.00 | 0.78 | 72.10 |
| imported/rsc/no-exponential | 0 | 1014.99 ± 0.9% | not timed | not timed | 646.69 ± 0.3% | 30.71 ± 0.4% | not timed | not timed | 1013.44 ± 14.8% | | 1.00 | 1.57 | 33.05 |
| imported/rsc/literal | 1 | 827.38 ± 1.8% | not timed | not timed | 2758.95 ± 11.2% | 253.49 ± 19.3% | not timed | not timed | 800.33 ± 5.0% | | 1.03 | 0.30 | 3.26 |
| imported/rsc/not-literal | 2 | 999.21 ± 3.5% | not timed | not timed | 1430.86 ± 0.7% | 65.10 ± 12.2% | not timed | not timed | 996.06 ± 0.4% | | 1.00 | 0.70 | 15.35 |
| imported/rsc/match-class | 1 | 1781.12 ± 2.2% | not timed | not timed | 2845.27 ± 13.1% | 75.37 ± 9.3% | not timed | not timed | 1782.18 ± 0.8% | | 1.00 | 0.63 | 23.63 |
| imported/rsc/match-class-in-range | 1 | 1782.30 ± 11.6% | not timed | not timed | 4386.43 ± 0.7% | 78.04 ± 12.7% | not timed | not timed | 1783.12 ± 0.3% | | 1.00 | 0.41 | 22.84 |
| imported/rsc/match-class-unicode | 1 | 608.07 ± 0.3% | not timed | not timed | 595.89 ± 0.6% | 83.88 ± 0.6% | not timed | not timed | 608.56 ± 0.4% | | 1.00 | 1.02 | 7.25 |
| imported/rsc/anchored-literal-short-non-match | 0 | 702.11 ± 0.2% | not timed | not timed | 1571.13 ± 0.5% | 418.69 ± 1.9% | not timed | not timed | 701.29 ± 0.3% | | 1.00 | 0.45 | 1.68 |
| imported/rsc/anchored-literal-long-non-match | 0 | 12150.82 ± 0.3% | not timed | not timed | 23565.96 ± 1.7% | 6303.91 ± 3.4% | not timed | not timed | 12143.30 ± 0.2% | | 1.00 | 0.52 | 1.93 |
| imported/rsc/anchored-literal-short-match | 4 | 554.80 ± 1.3% | not timed | not timed | 1022.68 ± 0.5% | 110.81 ± 4.4% | not timed | not timed | 557.12 ± 1.1% | | 1.00 | 0.54 | 5.01 |
| imported/rsc/anchored-literal-long-match | 4 | 2905.53 ± 1.9% | not timed | not timed | 15339.11 ± 0.7% | 1675.13 ± 0.2% | not timed | not timed | 2893.74 ± 4.5% | | 1.00 | 0.19 | 1.73 |
| imported/rsc/one-pass-short | 17 | 503.72 ± 7.8% | not timed | not timed | 487.88 ± 8.7% | 42.90 ± 10.0% | not timed | not timed | 508.60 ± 4.8% | | 0.99 | 1.03 | 11.74 |
| imported/rsc/one-pass-short-not | 17 | 299.12 ± 8.3% | not timed | not timed | 449.19 ± 0.3% | 37.55 ± 14.0% | not timed | not timed | 304.56 ± 1.8% | | 0.98 | 0.67 | 7.97 |
| imported/rsc/one-pass-long-prefix | 26 | 309.00 ± 4.6% | not timed | not timed | 554.20 ± 0.1% | 132.67 ± 6.6% | not timed | not timed | 314.96 ± 5.9% | | 0.98 | 0.56 | 2.33 |
| imported/rsc/one-pass-long-prefix-not | 26 | 502.01 ± 10.3% | not timed | not timed | 551.52 ± 0.4% | 97.39 ± 10.0% | not timed | not timed | 509.82 ± 2.5% | | 0.98 | 0.91 | 5.15 |
| imported/rsc/long-needle1 | 31 | 41539.04 ± 2.3% | not timed | not timed | 36803.39 ± 1.9% | 4.57 ± 5.4% | not timed | not timed | 41538.96 ± 1.5% | | 1.00 | 1.13 | 9091.25 |
| imported/rsc/long-needle2 | 31 | 41133.68 ± 0.2% | not timed | not timed | 259.44 ± 0.5% | 4.67 ± 1.9% | not timed | not timed | 41155.08 ± 0.4% | | 1.00 | 158.55 | 8808.01 |
| imported/rsc/easy0-32 | 26 | 1178.34 ± 0.9% | not timed | not timed | 2639.62 ± 1.3% | 183.96 ± 14.4% | not timed | not timed | 1175.88 ± 3.2% | | 1.00 | 0.45 | 6.41 |
| imported/rsc/easy0-1k | 26 | 25149.48 ± 0.7% | not timed | not timed | 19151.35 ± 9.5% | 3124.66 ± 24.6% | not timed | not timed | 25103.52 ± 1.9% | | 1.00 | 1.31 | 8.05 |
| imported/rsc/easy0-32k | 26 | 53353.32 ± 0.4% | not timed | not timed | 39615.72 ± 0.2% | 27380.25 ± 1.6% | not timed | not timed | 53291.30 ± 8.4% | | 1.00 | 1.35 | 1.95 |
| imported/rsc/easy0-1mb | 26 | 39846.35 ± 0.2% | not timed | not timed | 36648.05 ± 0.1% | 53655.62 ± 0.3% | not timed | not timed | 39878.61 ± 0.2% | | 1.00 | 1.09 | 0.74 |
| imported/rsc/easy1-32 | 19 | 471.50 ± 2.6% | not timed | not timed | 1365.37 ± 1.2% | 184.43 ± 10.9% | not timed | not timed | 473.75 ± 11.0% | | 1.00 | 0.35 | 2.56 |
| imported/rsc/easy1-1k | 19 | 631.18 ± 3.1% | not timed | not timed | 28117.65 ± 0.9% | 3116.37 ± 12.7% | not timed | not timed | 628.63 ± 2.0% | | 1.00 | 0.0224 | 0.20 |
| imported/rsc/easy1-32k | 19 | 642.87 ± 0.9% | not timed | not timed | 881769.05 ± 0.5% | 29860.12 ± 15.4% | not timed | not timed | 642.44 ± 2.3% | | 1.00 | 0.0007 | 0.0215 |
| imported/rsc/easy1-1mb | 19 | 641.42 ± 0.6% | not timed | not timed | 28043252.33 ± 0.6% | 58999.33 ± 0.5% | not timed | not timed | 639.93 ± 0.9% | | 1.00 | 0.0000 | 0.0109 |
| imported/rsc/medium-32 | 27 | 590.06 ± 2.4% | not timed | not timed | 1261.87 ± 0.4% | 94.08 ± 9.0% | not timed | not timed | 591.05 ± 3.0% | | 1.00 | 0.47 | 6.27 |
| imported/rsc/medium-1k | 27 | 9098.16 ± 0.3% | not timed | not timed | 22490.67 ± 15.1% | 97.79 ± 5.1% | not timed | not timed | 9114.22 ± 0.3% | | 1.00 | 0.40 | 93.04 |
| imported/rsc/medium-32k | 27 | 47953.67 ± 0.3% | not timed | not timed | 699470.86 ± 0.2% | 64.58 ± 0.4% | not timed | not timed | 47914.92 ± 0.3% | | 1.00 | 0.0686 | 742.56 |
| imported/rsc/medium-1mb | 27 | 41708.16 ± 0.4% | not timed | not timed | 22415207.25 ± 0.3% | 66.19 ± 0.5% | not timed | not timed | 41656.53 ± 0.6% | | 1.00 | 0.0019 | 630.14 |
| imported/rsc/hard-32 | 58 | 323.49 ± 2.9% | not timed | not timed | 485.66 ± 0.7% | 64.88 ± 10.0% | not timed | not timed | 322.80 ± 0.5% | | 1.00 | 0.67 | 4.99 |
| imported/rsc/hard-1k | 27 | 628.79 ± 0.6% | not timed | not timed | 19623.52 ± 10.6% | 53.29 ± 0.4% | not timed | not timed | 626.34 ± 0.8% | | 1.00 | 0.0320 | 11.80 |
| imported/rsc/hard-32k | 27 | 637.30 ± 1.2% | not timed | not timed | 610074.02 ± 1.7% | 39.33 ± 1.3% | not timed | not timed | 639.42 ± 1.3% | | 1.00 | 0.0010 | 16.21 |
| imported/rsc/hard-1mb | 51 | 641.42 ± 0.9% | not timed | not timed | 8737000.45 ± 1.1% | 39.69 ± 5.8% | not timed | not timed | 641.71 ± 0.3% | | 1.00 | 0.0001 | 16.16 |
| imported/rsc/reallyhard0-32 | 58 | 322.90 ± 2.2% | not timed | not timed | 292.62 ± 0.6% | 65.27 ± 11.2% | not timed | not timed | 322.36 ± 0.5% | | 1.00 | 1.10 | 4.95 |
| imported/rsc/reallyhard0-1k | 27 | 626.62 ± 0.6% | not timed | not timed | 624.96 ± 0.5% | 53.27 ± 0.9% | not timed | not timed | 628.65 ± 0.4% | | 1.00 | 1.00 | 11.76 |
| imported/rsc/reallyhard0-32k | 27 | 640.46 ± 0.1% | not timed | not timed | 643.44 ± 0.4% | 39.60 ± 0.6% | not timed | not timed | 641.85 ± 0.4% | | 1.00 | 1.00 | 16.17 |
| imported/rsc/reallyhard0-1mb | 51 | 633.14 ± 1.1% | not timed | not timed | 642.25 ± 0.6% | 39.80 ± 6.8% | not timed | not timed | 632.26 ± 0.8% | | 1.00 | 0.99 | 15.91 |
| imported/rsc/reallyreallyhard0-32 | 47 | 354.51 ± 1.1% | not timed | not timed | 262.70 ± 4.5% | 72.45 ± 9.0% | not timed | not timed | 356.00 ± 4.3% | | 1.00 | 1.35 | 4.89 |
| imported/rsc/reallyreallyhard0-1k | 16 | 922.77 ± 1.4% | not timed | not timed | 9497.69 ± 3.1% | 41.05 ± 1.8% | not timed | not timed | 923.94 ± 0.5% | | 1.00 | 0.0972 | 22.48 |
| imported/rsc/reallyreallyhard0-32k | 16 | 657.83 ± 5.7% | not timed | not timed | 36906.52 ± 2.0% | 30.43 ± 0.5% | not timed | not timed | 656.81 ± 6.4% | | 1.00 | 0.0178 | 21.62 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 634.68 ± 0.7% | not timed | not timed | 39655.04 ± 0.5% | 30.54 ± 3.8% | not timed | not timed | 633.90 ± 0.6% | | 1.00 | 0.0160 | 20.78 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 339.65 ± 5.0% | not timed | not timed | 246.21 ± 1.2% | 76.37 ± 17.0% | not timed | not timed | 346.95 ± 1.1% | | 0.98 | 1.38 | 4.45 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 899.80 ± 1.2% | not timed | not timed | 9050.58 ± 2.6% | 41.06 ± 1.3% | not timed | not timed | 900.36 ± 1.1% | | 1.00 | 0.0994 | 21.92 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 661.27 ± 5.1% | not timed | not timed | 36861.91 ± 0.7% | 30.60 ± 6.0% | not timed | not timed | 663.08 ± 5.2% | | 1.00 | 0.0179 | 21.61 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 629.94 ± 0.9% | not timed | not timed | 35296.90 ± 0.4% | 30.55 ± 1.0% | not timed | not timed | 633.30 ± 0.8% | | 0.99 | 0.0178 | 20.62 |
| imported/sherlock/name-sherlock | 776 | 35395.63 ± 5.9% | not timed | not timed | 32791.23 ± 0.7% | 11662.17 ± 9.1% | not timed | not timed | 35869.79 ± 2.6% | | 0.99 | 1.08 | 3.04 |
| imported/sherlock/name-holmes | 2766 | 21914.36 ± 8.2% | not timed | not timed | 24977.44 ± 1.2% | 3954.30 ± 6.3% | not timed | not timed | 23219.04 ± 2.3% | | 0.94 | 0.88 | 5.54 |
| imported/sherlock/name-sherlock-holmes | 1365 | 35804.92 ± 8.0% | not timed | not timed | 32143.95 ± 5.1% | 10683.34 ± 17.7% | not timed | not timed | 35829.51 ± 1.6% | | 1.00 | 1.11 | 3.35 |
| imported/sherlock/name-sherlock-casei | 816 | 31367.19 ± 1.0% | not timed | not timed | 10161.83 ± 0.5% | 40.02 ± 0.9% | not timed | not timed | 31264.00 ± 4.3% | | 1.00 | 3.09 | 783.78 |
| imported/sherlock/name-holmes-casei | 2802 | 18782.84 ± 7.5% | not timed | not timed | 7067.44 ± 0.5% | 54.25 ± 1.2% | not timed | not timed | 18551.97 ± 5.7% | | 1.01 | 2.66 | 346.23 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 27976.86 ± 2.1% | not timed | not timed | 9901.10 ± 0.4% | 40.11 ± 0.4% | not timed | not timed | 27836.69 ± 1.2% | | 1.01 | 2.83 | 697.56 |
| imported/sherlock/name-whitespace | 1461 | 23979.14 ± 2.4% | not timed | not timed | 25956.55 ± 0.7% | 7582.69 ± 22.7% | not timed | not timed | 23951.63 ± 8.0% | | 1.00 | 0.92 | 3.16 |
| imported/sherlock/name-alt1 | 1142 | 22648.71 ± 1.1% | not timed | not timed | 34942.43 ± 0.4% | 5157.96 ± 30.3% | not timed | not timed | 22495.60 ± 7.6% | | 1.01 | 0.65 | 4.39 |
| imported/sherlock/name-alt2 | 3542 | 14708.12 ± 1.0% | not timed | not timed | 8802.82 ± 0.5% | 41.35 ± 4.1% | not timed | not timed | 14716.68 ± 1.6% | | 1.00 | 1.67 | 355.73 |
| imported/sherlock/name-alt3 | 4507 | 10377.67 ± 0.9% | not timed | not timed | 7914.10 ± 1.0% | 13.11 ± 3.8% | not timed | not timed | 10423.63 ± 1.6% | | 1.00 | 1.31 | 791.48 |
| imported/sherlock/name-alt3-casei | 4593 | 1690.79 ± 2.3% | not timed | not timed | 1370.20 ± 0.6% | 8.26 ± 2.4% | not timed | not timed | 1696.75 ± 2.7% | | 1.00 | 1.23 | 204.81 |
| imported/sherlock/name-alt4 | 3686 | 8888.97 ± 0.6% | not timed | not timed | 8156.58 ± 0.6% | 41.17 ± 4.3% | not timed | not timed | 8900.82 ± 6.3% | | 1.00 | 1.09 | 215.92 |
| imported/sherlock/name-alt4-casei | 4254 | 3704.36 ± 4.1% | not timed | not timed | 3950.96 ± 2.5% | 23.74 ± 0.9% | not timed | not timed | 3720.11 ± 3.7% | | 1.00 | 0.94 | 156.04 |
| imported/sherlock/name-alt5 | 4028 | 12323.05 ± 0.8% | not timed | not timed | 8412.13 ± 0.5% | 28.77 ± 0.5% | not timed | not timed | 12286.17 ± 0.6% | | 1.00 | 1.46 | 428.39 |
| imported/sherlock/name-alt5-casei | 4104 | 5286.29 ± 7.5% | not timed | not timed | 3009.87 ± 0.8% | 17.36 ± 0.8% | not timed | not timed | 5253.12 ± 7.3% | | 1.01 | 1.76 | 304.45 |
| imported/sherlock/no-match-uncommon | 0 | 42174.97 ± 0.6% | not timed | not timed | 36705.19 ± 1.8% | 53874.74 ± 0.7% | not timed | not timed | 41965.00 ± 1.0% | | 1.01 | 1.15 | 0.78 |
| imported/sherlock/no-match-common | 0 | 41912.08 ± 0.8% | not timed | not timed | 36944.29 ± 5.0% | 1987.03 ± 0.7% | not timed | not timed | 42090.28 ± 1.3% | | 1.00 | 1.13 | 21.09 |
| imported/sherlock/no-match-really-common | 0 | 32920.98 ± 5.5% | not timed | not timed | 31967.87 ± 0.6% | 1986.16 ± 1.0% | not timed | not timed | 33049.26 ± 0.8% | | 1.00 | 1.03 | 16.58 |
| imported/sherlock/the-lower | 21654 | 2867.70 ± 2.2% | not timed | not timed | 2456.58 ± 0.8% | 276.67 ± 17.3% | not timed | not timed | 2897.92 ± 9.7% | | 0.99 | 1.17 | 10.37 |
| imported/sherlock/the-upper | 2223 | 17820.72 ± 1.5% | not timed | not timed | 21423.46 ± 2.9% | 3074.13 ± 15.8% | not timed | not timed | 17681.68 ± 4.7% | | 1.01 | 0.83 | 5.80 |
| imported/sherlock/the-casei | 23961 | 2603.58 ± 4.7% | not timed | not timed | 1463.45 ± 0.8% | 47.88 ± 21.5% | not timed | not timed | 2622.02 ± 1.8% | | 0.99 | 1.78 | 54.37 |
| imported/sherlock/everything-greedy | 581881 | 305.17 ± 8.3% | not timed | not timed | 199.50 ± 0.8% | 34.33 ± 38.2% | not timed | not timed | 304.64 ± 1.4% | | 1.00 | 1.53 | 8.89 |
| imported/sherlock/everything-greedy-nl | 594933 | 487.84 ± 0.4% | not timed | not timed | 255.67 ± 1.1% | 39.70 ± 1.6% | not timed | not timed | 488.00 ± 0.3% | | 1.00 | 1.91 | 12.29 |
| imported/sherlock/letters | 447175 | 59.25 ± 1.5% | not timed | not timed | 41.99 ± 0.5% | 5.70 ± 30.9% | not timed | not timed | 59.69 ± 19.7% | | 0.99 | 1.41 | 10.39 |
| imported/sherlock/letters-upper | 14180 | 457.21 ± 2.4% | not timed | not timed | 402.85 ± 2.2% | 33.61 ± 29.3% | not timed | not timed | 459.16 ± 0.3% | | 1.00 | 1.13 | 13.60 |
| imported/sherlock/letters-lower | 432995 | 60.63 ± 0.7% | not timed | not timed | 42.92 ± 0.3% | 5.97 ± 36.4% | not timed | not timed | 60.86 ± 1.5% | | 1.00 | 1.41 | 10.15 |
| imported/sherlock/words | 447639 | 109.29 ± 5.1% | not timed | not timed | 92.63 ± 2.4% | 15.02 ± 11.9% | not timed | not timed | 109.82 ± 6.7% | | 1.00 | 1.18 | 7.28 |
| imported/sherlock/before-holmes | 4073 | 630.50 ± 0.6% | not timed | not timed | 14748.70 ± 0.6% | 27.87 ± 0.6% | not timed | not timed | 631.87 ± 0.3% | | 1.00 | 0.0427 | 22.63 |
| imported/sherlock/before-after-holmes | 2593 | 632.08 ± 0.7% | not timed | not timed | 15972.04 ± 1.0% | 27.97 ± 0.9% | not timed | not timed | 634.16 ± 0.3% | | 1.00 | 0.0396 | 22.60 |
| imported/sherlock/holmes-cochar-watson | 150 | 8137.17 ± 0.5% | not timed | not timed | 7082.62 ± 6.5% | 41.44 ± 0.5% | not timed | not timed | 8145.37 ± 11.7% | | 1.00 | 1.15 | 196.38 |
| imported/sherlock/holmes-coword-watson | 14309 | 1319.91 ± 0.3% | not timed | not timed | 1292.19 ± 0.3% | 8.31 ± 0.9% | not timed | not timed | 1321.60 ± 0.6% | | 1.00 | 1.02 | 158.85 |
| imported/sherlock/quotes | 14437 | 1332.73 ± 0.6% | not timed | not timed | 2041.55 ± 0.9% | 40.70 ± 0.7% | not timed | not timed | 1331.45 ± 0.6% | | 1.00 | 0.65 | 32.75 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 638.20 ± 0.5% | not timed | not timed | 28336.06 ± 0.5% | 48.04 ± 0.6% | not timed | not timed | 638.31 ± 0.4% | | 1.00 | 0.0225 | 13.28 |
| imported/sherlock/word-ending-n | 35297 | 476.65 ± 1.4% | not timed | not timed | 435.38 ± 0.7% | 28.20 ± 0.5% | not timed | not timed | 477.40 ± 0.3% | | 1.00 | 1.09 | 16.90 |
| imported/sherlock/repeated-class-negation | 2130 | 17724.53 ± 2.7% | not timed | not timed | 18101.49 ± 6.8% | 12.52 ± 0.7% | not timed | not timed | 17724.16 ± 2.2% | | 1.00 | 0.98 | 1415.31 |
| imported/sherlock/ing-suffix | 20547 | 579.80 ± 1.6% | not timed | not timed | 545.66 ± 0.1% | 34.05 ± 37.0% | not timed | not timed | 580.66 ± 0.5% | | 1.00 | 1.06 | 17.03 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 624.66 ± 0.9% | not timed | not timed | 2696.60 ± 0.4% | 24.23 ± 0.3% | not timed | not timed | 625.72 ± 0.2% | | 1.00 | 0.23 | 25.78 |
| opt/accelerate/whole-line | 239963 | 555.72 ± 0.3% | not timed | not timed | 441.22 ± 0.1% | 111.72 ± 17.7% | not timed | not timed | 555.76 ± 3.3% | | 1.00 | 1.26 | 4.97 |
| opt/accelerate/non-dna | 16745 | 471.64 ± 3.7% | not timed | not timed | 505.62 ± 3.8% | 38.32 ± 21.8% | not timed | not timed | 471.28 ± 0.3% | | 1.00 | 0.93 | 12.31 |
| opt/backtrack/words-english | 40536 | 150.42 ± 6.3% | not timed | not timed | 124.75 ± 0.5% | 24.34 ± 10.0% | not timed | not timed | 150.54 ± 2.0% | | 1.00 | 1.21 | 6.18 |
| opt/fixed-length/too-small-ascii | 0 | 416.02 ± 1.9% | not timed | not timed | 1040.19 ± 1.8% | 142.24 ± 1.6% | not timed | not timed | 415.26 ± 5.6% | | 1.00 | 0.40 | 2.92 |
| opt/fixed-length/too-big-ascii | 0 | 965.81 ± 1.4% | not timed | not timed | 8558.55 ± 1.3% | 173.18 ± 4.3% | not timed | not timed | 968.41 ± 2.4% | | 1.00 | 0.11 | 5.58 |
| opt/fixed-length/go33484-1 | 0 | 76.96 ± 0.1% | not timed | not timed | 1636235.95 ± 1.3% | 109678.94 ± 5.1% | not timed | not timed | 77.05 ± 0.2% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 4354.16 ± 0.3% | not timed | not timed | 1647096.34 ± 1.4% | 48614.22 ± 1.7% | not timed | not timed | 4352.17 ± 0.2% | | 1.00 | 0.0026 | 0.0896 |
| opt/fixed-length/go33484-3 | 0 | 1715.63 ± 0.3% | not timed | not timed | 164138.91 ± 1.2% | 1113.48 ± 0.2% | not timed | not timed | 1686.50 ± 0.2% | | 1.02 | 0.0105 | 1.54 |
| opt/literal-alt/one-pattern | 1 | 650.20 ± 2.1% | not timed | not timed | 655.00 ± 0.2% | 0.52 ± 0.3% | not timed | not timed | 650.72 ± 0.3% | | 1.00 | 0.99 | 1242.86 |
| opt/onepass/fn-predicate | 916 | 476.69 ± 0.7% | not timed | not timed | 444.49 ± 0.6% | 235.81 ± 14.4% | not timed | not timed | 476.47 ± 0.3% | | 1.00 | 1.07 | 2.02 |
| opt/onepass/first-three-words-english | 35128 | 165.48 ± 1.9% | not timed | not timed | 245.59 ± 0.4% | 66.54 ± 17.7% | not timed | not timed | 166.77 ± 1.4% | | 0.99 | 0.67 | 2.49 |
| opt/prefilter/literal-english | 1 | 41697.93 ± 0.6% | not timed | not timed | 36361.21 ± 0.2% | 24549.35 ± 0.2% | not timed | not timed | 41759.52 ± 0.1% | | 1.00 | 1.15 | 1.70 |
| opt/prefilter/literal-casei-english | 1 | 31827.42 ± 0.7% | not timed | not timed | 11891.45 ± 0.2% | 40.85 ± 0.3% | not timed | not timed | 31737.67 ± 0.3% | | 1.00 | 2.68 | 779.16 |
| opt/prefilter/literal-russian | 1 | 43039.22 ± 0.2% | not timed | not timed | 36559.02 ± 0.2% | 2326.03 ± 10.3% | not timed | not timed | 43030.91 ± 0.3% | | 1.00 | 1.18 | 18.50 |
| opt/prefilter/literal-casei-russian | 1 | 23745.32 ± 0.4% | not timed | not timed | 9017.60 ± 0.6% | 42.68 ± 0.2% | not timed | not timed | 23738.37 ± 0.2% | | 1.00 | 2.63 | 556.37 |
| opt/prefilter/rust-functions | 948 | 12783.52 ± 4.9% | not timed | not timed | 11469.43 ± 0.3% | 2109.11 ± 0.6% | not timed | not timed | 12754.27 ± 0.8% | | 1.00 | 1.11 | 6.06 |
| opt/reverse-anchored/word-end | 1 | 4409.08 ± 3.2% | not timed | not timed | 37682948.81 ± 0.3% | 63.66 ± 3.5% | not timed | not timed | 4408.87 ± 0.1% | | 1.00 | 0.0001 | 69.26 |
| opt/reverse-inner/holmes | 2593 | 635.96 ± 0.9% | not timed | not timed | 16017.32 ± 1.4% | 28.02 ± 0.2% | not timed | not timed | 636.15 ± 0.3% | | 1.00 | 0.0397 | 22.70 |
| opt/reverse-inner/email | 47 | 1089.24 ± 0.8% | not timed | not timed | 29486.40 ± 0.3% | 38.51 ± 0.6% | not timed | not timed | 1091.34 ± 0.5% | | 1.00 | 0.0369 | 28.29 |
| opt/reverse-inner/factored-prefix | 3542 | 627.75 ± 0.2% | not timed | not timed | 624.93 ± 0.3% | 15.11 ± 0.3% | not timed | not timed | 627.43 ± 0.8% | | 1.00 | 1.00 | 41.54 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4352.53 ± 0.2% | not timed | not timed | 643.05 ± 0.7% | 102.09 ± 5.4% | not timed | not timed | 4355.29 ± 0.2% | | 1.00 | 6.77 | 42.63 |
| opt/reverse-inner/no-quadratic-forward | 0 | 738.34 ± 2.2% | not timed | not timed | 296.11 ± 0.2% | 35.01 ± 0.5% | not timed | not timed | 738.98 ± 2.2% | | 1.00 | 2.49 | 21.09 |
| opt/reverse-suffix/holmes | 4073 | 633.32 ± 0.3% | not timed | not timed | 14761.40 ± 1.1% | 27.87 ± 5.1% | not timed | not timed | 633.13 ± 0.2% | | 1.00 | 0.0429 | 22.72 |
| opt/reverse-suffix/no-quadratic | 0 | 4354.04 ± 0.3% | not timed | not timed | 643.44 ± 0.9% | 101.68 ± 5.0% | not timed | not timed | 4356.05 ± 0.1% | | 1.00 | 6.77 | 42.82 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 148.17 ± 11.4% | not timed | not timed | 227.93 ± 2.0% | 19.51 ± 19.7% | not timed | not timed | 150.44 ± 2.0% | | 0.98 | 0.65 | 7.59 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 150.74 ± 3.7% | not timed | not timed | 232.15 ± 1.0% | 17.38 ± 19.7% | not timed | not timed | 146.87 ± 4.0% | | 1.03 | 0.65 | 8.67 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.38 ± 0.3% | not timed | not timed | 0.61 ± 0.2% | 134.62 ± 9.3% | not timed | not timed | 0.38 ± 6.8% | | 0.98 | 0.61 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 333.83 ± 0.4% | not timed | not timed | 319.73 ± 2.5% | 120.48 ± 1.1% | not timed | not timed | 334.19 ± 2.7% | | 1.00 | 1.04 | 2.77 |
| reported/i13-subset-regex/original-ascii | 4094 | 11396.49 ± 1.1% | not timed | not timed | 4306.98 ± 0.2% | 12.43 ± 0.8% | not timed | not timed | 11382.19 ± 4.0% | | 1.00 | 2.65 | 916.65 |
| reported/i13-subset-regex/original-unicode | 4094 | 11317.35 ± 1.5% | not timed | not timed | 251.54 ± 2.1% | 12.44 ± 1.0% | not timed | not timed | 11405.11 ± 2.4% | | 0.99 | 44.99 | 909.63 |
| reported/i13-subset-regex/big-ascii | 1955 | 10660.34 ± 1.0% | not timed | not timed | 67.43 ± 2.4% | 10.87 ± 0.5% | not timed | not timed | 10676.76 ± 1.2% | | 1.00 | 158.10 | 981.13 |
| reported/i13-subset-regex/big-unicode | 1955 | 10619.44 ± 0.7% | not timed | not timed | 12.09 ± 54.9% | 10.84 ± 0.3% | not timed | not timed | 10603.47 ± 1.4% | | 1.00 | 878.39 | 979.77 |
| reported/i13-subset-regex/huge-ascii | 55 | 9798.22 ± 2.0% | not timed | not timed | 11.41 ± 0.2% | 10.13 ± 0.4% | not timed | not timed | 9797.71 ± 1.8% | | 1.00 | 858.78 | 967.61 |
| reported/i13-subset-regex/huge-unicode | 55 | 9616.41 ± 2.0% | not timed | not timed | 11.31 ± 0.9% | 10.04 ± 0.4% | not timed | not timed | 9661.53 ± 1.2% | | 1.00 | 850.56 | 957.46 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.38 ± 0.5% | not timed | not timed | 11.29 ± 0.7% | 10.11 ± 0.8% | not timed | not timed | 4.38 ± 0.4% | | 1.00 | 0.39 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 6.22 ± 0.6% | not timed | not timed | 11.34 ± 0.4% | 10.08 ± 0.9% | not timed | not timed | 5.99 ± 0.5% | | 1.04 | 0.55 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 511.12 ± 1.4% | not timed | not timed | 153.64 ± 0.8% | 8.09 ± 0.3% | not timed | not timed | 513.10 ± 0.8% | | 1.00 | 3.33 | 63.18 |
| reported/i787-keywords/opt-ascii | 5674 | 512.43 ± 0.8% | not timed | not timed | 294.82 ± 0.8% | 12.65 ± 27.3% | not timed | not timed | 512.52 ± 1.9% | | 1.00 | 1.74 | 40.50 |
| slow/quadratic-regex-1x | 100 | 9.20 ± 0.5% | not timed | not timed | 6.78 ± 0.5% | 0.05 ± 1.2% | not timed | not timed | 9.17 ± 0.4% | | 1.00 | 1.36 | 170.46 |
| slow/quadratic-regex-2x | 199 | 4.06 ± 0.5% | not timed | not timed | 3.32 ± 0.6% | 0.02 ± 0.5% | not timed | not timed | 4.07 ± 0.4% | | 1.00 | 1.22 | 242.81 |
| slow/quadratic-haystack-1x | 100 | 29.74 ± 2.4% | not timed | not timed | 13.49 ± 0.3% | 1.24 ± 11.6% | not timed | not timed | 29.75 ± 2.4% | | 1.00 | 2.21 | 24.01 |
| slow/quadratic-haystack-2x | 200 | 22.93 ± 8.9% | not timed | not timed | 6.60 ± 0.4% | 0.67 ± 6.6% | not timed | not timed | 22.99 ± 1.6% | | 1.00 | 3.47 | 34.10 |
| unicode/codepoints/any-one | 1112064 | 394.02 ± 6.5% | not timed | not timed | 311.29 ± 1.7% | 18.99 ± 24.5% | not timed | not timed | 394.24 ± 0.3% | | 1.00 | 1.27 | 20.75 |
| unicode/codepoints/any-all | 4382592 | 294.60 ± 1.0% | not timed | not timed | 289.72 ± 0.3% | 144.64 ± 0.8% | not timed | not timed | 294.88 ± 0.6% | | 1.00 | 1.02 | 2.04 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.10 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 640.34 ± 0.4% | not timed | not timed | 641.04 ± 0.1% | 181.83 ± 2.5% | not timed | not timed | 641.36 ± 0.2% | | 1.00 | 1.00 | 3.52 |
| unicode/overlapping-words/ascii | 6156 | 32.08 ± 0.3% | not timed | not timed | 52.79 ± 0.2% | 4.28 ± 3.9% | not timed | not timed | 32.06 ± 0.7% | | 1.00 | 0.61 | 7.50 |
| unicode/overlapping-words/english | 6156 | 1.62 ± 1.3% | not timed | not timed | 3.65 ± 0.3% | 2.73 ± 0.6% | not timed | not timed | 1.61 ± 1.5% | | 1.00 | 0.44 | 0.59 |
| unicode/overlapping-words/russian | 5710 | 1.47 ± 3.6% | not timed | not timed | 3.56 ± 0.3% | 7.09 ± 10.6% | not timed | not timed | 1.53 ± 0.6% | | 0.96 | 0.41 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 114.07 ± 0.5% | not timed | not timed | 93.18 ± 0.5% | 13.79 ± 17.7% | not timed | not timed | 113.97 ± 0.6% | | 1.00 | 1.22 | 8.27 |
| unicode/word/boundary-long-english | 3466 | 639.48 ± 0.3% | not timed | not timed | 629.71 ± 0.1% | 38.36 ± 0.4% | not timed | not timed | 638.68 ± 0.4% | | 1.00 | 1.02 | 16.67 |
| unicode/word/around-holmes-english | 27 | 638.25 ± 0.6% | not timed | not timed | 35870.22 ± 0.5% | 26.08 ± 0.4% | not timed | not timed | 638.78 ± 0.4% | | 1.00 | 0.0178 | 24.47 |
| wild/bibleref/long | 874 | 598.09 ± 0.4% | not timed | not timed | 610.80 ± 0.4% | 8.40 ± 0.7% | not timed | not timed | 599.41 ± 0.3% | | 1.00 | 0.98 | 71.23 |
| wild/bibleref/short | 30 | 24.21 ± 7.6% | not timed | not timed | 37.52 ± 0.4% | 17.65 ± 19.7% | not timed | not timed | 24.75 ± 10.6% | | 0.98 | 0.65 | 1.37 |
| wild/bibleref/line | 874 | 514.89 ± 0.8% | not timed | not timed | 285.02 ± 0.5% | 10.90 ± 0.8% | not timed | not timed | 514.71 ± 0.5% | | 1.00 | 1.81 | 47.23 |
| wild/caddy/caddy | 6 | 461.21 ± 2.2% | not timed | not timed | 281.59 ± 0.2% | 89.52 ± 9.8% | not timed | not timed | 461.96 ± 10.6% | | 1.00 | 1.64 | 5.15 |
| wild/dot-star-capture/rust-src-tools | 6 | 1519.36 ± 0.9% | not timed | not timed | 350.85 ± 0.4% | 17.81 ± 0.8% | not timed | not timed | 1517.91 ± 4.7% | | 1.00 | 4.33 | 85.29 |
| wild/ruff/noqa | 84 | 556.76 ± 6.9% | not timed | not timed | 562.53 ± 5.1% | 25.74 ± 2.8% | not timed | not timed | 557.04 ± 0.4% | | 1.00 | 0.99 | 21.63 |
| wild/ruff/unnecessary-coding-comment | 16 | 615.21 ± 0.9% | not timed | not timed | 744.63 ± 2.3% | 160.27 ± 4.2% | not timed | not timed | 614.70 ± 0.9% | | 1.00 | 0.83 | 3.84 |
| wild/ruff/string-quote-prefix | 2972 | 564.82 ± 0.9% | not timed | not timed | 531.17 ± 1.0% | 402.81 ± 11.1% | not timed | not timed | 564.64 ± 5.7% | | 1.00 | 1.06 | 1.40 |
| wild/ruff/space-around-operator | 1224378 | 254.66 ± 2.8% | not timed | not timed | 245.82 ± 0.5% | 22.07 ± 2.5% | not timed | not timed | 255.47 ± 6.5% | | 1.00 | 1.04 | 11.54 |
| wild/ruff/shebang | 282 | 555.13 ± 1.4% | not timed | not timed | 434.94 ± 0.6% | 144.05 ± 3.5% | not timed | not timed | 552.34 ± 6.9% | | 1.01 | 1.28 | 3.85 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16183.84 ± 2.8% | not timed | not timed | 18292.02 ± 0.4% | 7835.34 ± 1.6% | not timed | not timed | 16186.81 ± 0.5% | | 1.00 | 0.88 | 2.07 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15352.35 ± 0.5% | not timed | not timed | 17628.85 ± 5.5% | 7259.70 ± 0.8% | not timed | not timed | 15344.64 ± 3.6% | | 1.00 | 0.87 | 2.11 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 16246.07 ± 0.6% | not timed | not timed | 18262.54 ± 0.5% | 7554.21 ± 40.1% | not timed | not timed | 16246.18 ± 1.5% | | 1.00 | 0.89 | 2.15 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 14584.79 ± 0.3% | not timed | not timed | 18030.35 ± 0.8% | 7747.58 ± 0.5% | not timed | not timed | 14563.54 ± 0.4% | | 1.00 | 0.81 | 1.88 |
| wild/url/search | 234965 | 145.37 ± 13.5% | not timed | not timed | 75.09 ± 0.5% | 2.68 ± 0.5% | not timed | not timed | 145.30 ± 12.4% | | 1.00 | 1.94 | 54.23 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 3.0% | not timed | not timed | 0.01 ± 1.6% | 0.01 ± 23.9% | not timed | not timed | 0.03 ± 16.9% | | 0.99 | 3.63 | 4.27 |
| dictionary/compile/english-15 | 1 | 0.36 ± 31.3% | not timed | not timed | 0.08 ± 1.5% | 0.11 ± 13.6% | not timed | not timed | 0.37 ± 2.5% | | 0.98 | 4.33 | 3.23 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.27 ± 19.7% | not timed | not timed | 0.02 ± 0.8% | 38.67 ± 10.8% | not timed | not timed | 0.28 ± 17.5% | | 0.98 | 12.12 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 50.28 ± 8.8% | not timed | not timed | 16.33 ± 0.5% | 64.83 ± 12.3% | not timed | not timed | 50.67 ± 2.1% | | 0.99 | 3.08 | 0.78 |
| reported/i787-keywords/compile | 1 | 44.90 ± 7.0% | not timed | not timed | 2.31 ± 1.3% | 19.46 ± 30.1% | not timed | not timed | 44.93 ± 0.5% | | 1.00 | 19.47 | 2.31 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 438.46 ± 10.6% | not timed | not timed | 158.55 ± 0.4% | 706.09 ± 12.8% | not timed | not timed | 445.13 ± 3.2% | | 0.99 | 2.77 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 59.94 ± 4.1% | not timed | not timed | 4.99 ± 0.4% | 50.31 ± 9.1% | not timed | not timed | 60.20 ± 5.8% | | 1.00 | 12.02 | 1.19 |
| unicode/compile/one-letter | 53 | 7.66 ± 17.6% | not timed | not timed | 6.09 ± 0.3% | 68.96 ± 5.0% | not timed | not timed | 7.68 ± 4.2% | | 1.00 | 1.26 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.22 ± 15.1% | not timed | not timed | 0.13 ± 0.7% | 69.67 ± 17.4% | not timed | not timed | 1.23 ± 10.1% | | 0.99 | 9.38 | 0.0175 |
| unicode/compile/fifty-letters-ascii | 1 | 255.57 ± 3.1% | not timed | not timed | 70.77 ± 0.8% | 247.88 ± 19.9% | not timed | not timed | 256.70 ± 8.3% | | 1.00 | 3.61 | 1.03 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 500.42 ± 12.3% | not timed | not timed | 50.75 ± 0.9% | 813.20 ± 4.8% | not timed | not timed | 511.68 ± 14.1% | | 0.98 | 9.86 | 0.62 |
| unicode/compile/match-every-line-ascii | 4 | 813.82 ± 5.1% | not timed | not timed | 192.01 ± 4.7% | 813.35 ± 8.9% | not timed | not timed | 842.64 ± 11.5% | | 0.97 | 4.24 | 1.00 |
| unicode/compile/negated-class-matches-codepoint | 1 | 418.14 ± 3.3% | not timed | not timed | 54.41 ± 1.4% | 1499.20 ± 5.8% | not timed | not timed | 422.68 ± 4.5% | | 0.99 | 7.69 | 0.28 |
| wild/bibleref/compile | 3 | 6.64 ± 12.8% | not timed | not timed | 2.38 ± 1.0% | 35.25 ± 16.6% | not timed | not timed | 6.71 ± 5.8% | | 0.99 | 2.79 | 0.19 |
| wild/url/compile | 1 | 0.71 ± 11.9% | not timed | not timed | 0.18 ± 1.0% | 0.52 ± 5.6% | not timed | not timed | 0.80 ± 12.5% | | 0.89 | 3.99 | 1.38 |

