# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507041020 |
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
| literal: a word | 217 | 65111.00 ± 85.2% | 6296.73 ± 22.7% | 43.31 ± 36.1% | 52160.73 ± 3.9% | 16221.32 ± 212.4% | 15.59 ± 77.6% | 157.42 ± 68.5% | 64439.55 ± 4.0% | 10.34 | 1.01 | 1.25 | 4.01 |
| literal: a word that is not there | 0 | 84888.58 ± 3.0% | 6070.82 ± 1.1% | 45.33 ± 2.7% | 64428.64 ± 2.4% | 56309.12 ± 2.7% | 15.14 ± 33.6% | 146.39 ± 80.1% | 83883.82 ± 3.6% | 13.98 | 1.01 | 1.32 | 1.51 |
| literal: one of four words | 661 | 21393.67 ± 3.5% | 2310.11 ± 3.6% | 24.36 ± 6.2% | 14351.03 ± 7.2% | 38.91 ± 6.1% | 5.08 ± 6.5% | 13.06 ± 7.2% | 21007.36 ± 7.9% | 9.26 | 1.02 | 1.49 | 549.87 |
| literal: a word in any case | 217 | 58809.13 ± 1.4% | 2500.14 ± 2.4% | 32.63 ± 1.4% | 13996.39 ± 0.8% | 71.26 ± 2.6% | refused | differs | 58946.72 ± 0.9% | 23.52 | 1.00 | 4.20 | 825.28 |
| literal: an href attribute | 33 | 53965.09 ± 4.2% | 757.49 ± 5.6% | 40.60 ± 4.2% | 48269.59 ± 5.0% | 3636.02 ± 5.2% | 11.30 ± 5.0% | 138.04 ± 5.6% | 53691.00 ± 7.2% | 71.24 | 1.01 | 1.12 | 14.84 |
| literal: a word, second text | 123 | 64377.63 ± 5.3% | 4466.50 ± 5.3% | 45.71 ± 4.9% | 49719.01 ± 4.9% | 14875.21 ± 7.0% | 20.89 ± 5.2% | 131.00 ± 6.1% | 66512.14 ± 7.8% | 14.41 | 0.97 | 1.29 | 4.33 |
| class: two capitalized words | 1331 | 1164.00 ± 1.9% | 752.00 ± 0.5% | 42.69 ± 4.2% | 709.76 ± 1.8% | 63.73 ± 17.9% | 14.26 ± 2.5% | 109.27 ± 3.2% | 1163.98 ± 2.9% | 1.55 | 1.00 | 1.64 | 18.26 |
| class: a word that ends in ing | 3399 | 714.57 ± 4.7% | 711.12 ± 6.2% | 27.44 ± 3.8% | 637.62 ± 4.7% | 46.75 ± 7.3% | 8.14 ± 4.7% | 32.51 ± 3.3% | 703.83 ± 4.0% | 1.00 | 1.02 | 1.12 | 15.29 |
| class: a word in capitals | 2332 | 1648.65 ± 6.9% | 723.28 ± 7.6% | 43.83 ± 5.0% | 657.59 ± 7.3% | 64.27 ± 43.3% | 16.38 ± 14.8% | 137.21 ± 44.6% | 1652.16 ± 5.4% | 2.28 | 1.00 | 2.51 | 25.65 |
| class: a number | 8288 | 2939.32 ± 6.2% | 1002.68 ± 5.5% | 42.75 ± 3.5% | 2283.16 ± 5.6% | 64.84 ± 24.7% | 0.45 ± 3.8% | 96.41 ± 9.8% | 2880.07 ± 6.5% | 2.93 | 1.02 | 1.29 | 45.33 |
| class: two capitalized words, second text | 5359 | 607.60 ± 14.4% | 620.24 ± 2.4% | 34.86 ± 5.3% | 557.77 ± 5.2% | 47.89 ± 27.9% | 17.16 ± 5.9% | 94.60 ± 4.4% | 614.85 ± 6.0% | 0.98 | 0.99 | 1.09 | 12.69 |
| other: a word between two words | 6104 | 1155.03 ± 8.7% | 712.64 ± 5.6% | 34.97 ± 8.2% | 952.33 ± 3.7% | 162.53 ± 6.7% | 10.31 ± 6.7% | 110.94 ± 5.5% | 1180.12 ± 2.7% | 1.62 | 0.98 | 1.21 | 7.11 |
| other: a number before a unit, second text | 1481 | 13351.28 ± 2.5% | 1451.92 ± 3.2% | 41.31 ± 0.8% | 10744.21 ± 9.4% | 59.58 ± 21.5% | 18.74 ± 5.4% | 107.99 ± 4.7% | 13331.69 ± 4.2% | 9.20 | 1.00 | 1.24 | 224.07 |
| other: a heading's start tag | 110 | 32529.45 ± 5.0% | 895.69 ± 6.4% | 41.72 ± 5.2% | 3308.47 ± 10.2% | 2552.51 ± 4.8% | 14.45 ± 3.5% | 166.60 ± 8.9% | 32894.56 ± 7.3% | 36.32 | 0.99 | 9.83 | 12.74 |
| other: a whole word | 217 | 41483.89 ± 44.2% | 706.72 ± 2.7% | 45.18 ± 2.3% | 35418.43 ± 8.8% | 72.13 ± 22.2% | 13.05 ± 7.6% | 81.88 ± 46.1% | 41283.62 ± 53.9% | 58.70 | 1.00 | 1.17 | 575.12 |
| other: a line's first word, second text | 3716 | 3446.59 ± 1.6% | 703.54 ± 12.0% | 47.65 ± 34.0% | 3456.88 ± 1.3% | 97.23 ± 3.9% | refused | refused | 3455.73 ± 1.5% | 4.90 | 1.00 | 1.00 | 35.45 |
| other: fourteen octets before an x | 87 | 49795.36 ± 37.2% | 325.68 ± 56.7% | 8.40 ± 14.2% | 4717.24 ± 3.2% | 13.84 ± 89.3% | differs | 25.07 ± 32.2% | 50125.83 ± 83.3% | 152.90 | 0.99 | 10.56 | 3598.35 |
| other: a Greek word | 21815 | 645.04 ± 1.9% | 534.01 ± 1.5% | 47.06 ± 2.9% | 343.31 ± 2.1% | 56.87 ± 14.5% | differs | refused | 650.01 ± 3.7% | 1.21 | 0.99 | 1.88 | 11.34 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 37.13 ± 11.4% | 37.92 ± 40.3% | 1.49 ± 12.7% | 23.95 ± 7.2% | 3.63 ± 4.1% | differs | 5.94 ± 10.0% | 37.99 ± 39.0% | 0.98 | 0.98 | 1.55 | 10.22 |
| a UUID | 32895 | 33.71 ± 3.0% | 33.93 ± 3.4% | 1.00 ± 3.9% | 18.11 ± 5.7% | 3.44 ± 7.5% | 0.72 ± 6.1% | 4.74 ± 7.3% | 33.51 ± 5.8% | 0.99 | 1.01 | 1.86 | 9.79 |
| an IPv4 address | 33176 | 47.50 ± 6.5% | 47.66 ± 5.3% | 3.22 ± 6.8% | 34.66 ± 5.7% | 9.06 ± 4.8% | differs | 5.86 ± 5.4% | 46.55 ± 5.8% | 1.00 | 1.02 | 1.37 | 5.25 |
| a date and time | 32954 | 46.41 ± 12.0% | 46.61 ± 5.2% | 2.40 ± 6.5% | 26.06 ± 6.9% | 10.47 ± 41.7% | 1.28 ± 4.9% | 11.46 ± 10.4% | 46.05 ± 35.7% | 1.00 | 1.01 | 1.78 | 4.43 |
| a field path | 32606 | 40.43 ± 4.0% | 39.85 ± 10.1% | 1.70 ± 2.3% | 27.75 ± 2.3% | 4.62 ± 20.6% | differs | 4.15 ± 35.1% | 40.76 ± 1.7% | 1.01 | 0.99 | 1.46 | 8.75 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.66 ± 4.9% | 15.37 ± 2.2% | 15.67 ± 4.3% | 17.16 ± 3.0% | 7.57 ± 3.4% | 1.05 ± 2.9% | none | 14.99 ± 2.5% | 1.02 | 1.04 | 0.91 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 362.46 ± 15.6% | 363.26 ± 1.2% | 427.34 ± 3.7% | 133.58 ± 5.3% | 339.24 ± 19.0% | 904.28 ± 3.8% | 5865.07 ± 24.6% | 370.44 ± 3.2% | 1.00 | 0.98 | 2.71 | 1.07 |
| a UUID | 62 | 237.98 ± 2.2% | 234.47 ± 8.3% | 260.57 ± 6.9% | 74.77 ± 1.9% | 156.21 ± 3.6% | 301.75 ± 3.0% | 7255.96 ± 1.6% | 237.45 ± 2.3% | 1.01 | 1.00 | 3.18 | 1.52 |
| an IPv4 address | 29 | 704.25 ± 5.0% | 701.81 ± 3.0% | 960.15 ± 2.9% | 122.05 ± 5.6% | 203.04 ± 7.1% | 563.91 ± 3.4% | 12745.69 ± 2.4% | 698.08 ± 1.5% | 1.00 | 1.01 | 5.77 | 3.47 |
| a date and time | 56 | 504.06 ± 6.1% | 502.12 ± 15.6% | 617.19 ± 1.9% | 112.29 ± 2.0% | 222.53 ± 4.4% | 553.97 ± 0.9% | 8114.02 ± 1.0% | 502.04 ± 2.1% | 1.00 | 1.00 | 4.49 | 2.27 |
| a field path | 39 | 357.75 ± 1.7% | 356.89 ± 2.4% | 418.54 ± 2.0% | 124.51 ± 3.1% | 308.16 ± 16.1% | 899.34 ± 1.1% | 7315.22 ± 3.9% | 352.56 ± 22.0% | 1.00 | 1.01 | 2.87 | 1.16 |
| literal: a word | 7 | 1051.05 ± 25.4% | 1153.52 ± 5.0% | 1985.48 ± 6.1% | 824.38 ± 5.6% | 1022.10 ± 6.9% | 1811.41 ± 8.3% | 45790.90 ± 18.2% | 1069.89 ± 4.6% | 0.91 | 0.98 | 1.27 | 1.03 |
| literal: a word that is not there | 8 | 998.55 ± 5.5% | 1082.30 ± 3.2% | 1819.09 ± 4.0% | 773.17 ± 3.5% | 971.44 ± 15.0% | 1682.01 ± 3.2% | 45499.94 ± 12.5% | 1002.85 ± 4.6% | 0.92 | 1.00 | 1.29 | 1.03 |
| literal: one of four words | 26 | 386.33 ± 1.9% | 643.66 ± 2.4% | 835.72 ± 6.0% | 65.81 ± 5.9% | 382.31 ± 3.0% | 639.83 ± 2.1% | 26602.43 ± 12.6% | 386.56 ± 2.8% | 0.60 | 1.00 | 5.87 | 1.01 |
| literal: a word in any case | 11 | 738.80 ± 2.1% | 788.04 ± 3.9% | 1091.65 ± 3.4% | 22.50 ± 29.2% | 1080.82 ± 2.0% | refused | 38151.77 ± 2.1% | 729.38 ± 5.1% | 0.94 | 1.01 | 32.83 | 0.68 |
| literal: an href attribute | 12 | 563.14 ± 10.2% | 591.47 ± 3.8% | 763.16 ± 1.1% | 59.92 ± 1.5% | 734.76 ± 18.1% | 1471.97 ± 1.6% | 34140.81 ± 13.8% | 572.35 ± 2.0% | 0.95 | 0.98 | 9.40 | 0.77 |
| literal: a word, second text | 10 | 939.47 ± 5.7% | 1033.89 ± 8.0% | 1634.66 ± 10.2% | 721.49 ± 6.7% | 849.23 ± 9.8% | 1537.26 ± 1.7% | 45324.93 ± 4.8% | 945.62 ± 13.5% | 0.91 | 0.99 | 1.30 | 1.11 |
| class: two capitalized words | 23 | 753.48 ± 3.9% | 813.46 ± 3.4% | 1153.84 ± 3.1% | 159.38 ± 0.4% | 791.90 ± 0.7% | 1375.51 ± 0.4% | 9707.51 ± 0.6% | 749.39 ± 1.1% | 0.93 | 1.01 | 4.73 | 0.95 |
| class: a word that ends in ing | 9 | 902.60 ± 4.3% | 1037.45 ± 4.9% | 1770.76 ± 5.0% | 202.30 ± 3.9% | 1049.42 ± 7.1% | 2212.75 ± 3.7% | 24750.78 ± 4.1% | 914.86 ± 5.0% | 0.87 | 0.99 | 4.46 | 0.86 |
| class: a word in capitals | 16 | 834.03 ± 2.7% | 913.47 ± 2.1% | 1426.46 ± 3.9% | 205.49 ± 1.2% | 1158.99 ± 2.2% | 1863.20 ± 1.8% | 12522.56 ± 3.7% | 840.32 ± 4.0% | 0.91 | 0.99 | 4.06 | 0.72 |
| class: a number | 6 | 1059.10 ± 30.1% | 1191.22 ± 26.5% | 2178.73 ± 33.5% | 58.58 ± 1.2% | 2091.27 ± 1.4% | 3473.24 ± 2.4% | 34971.34 ± 5.8% | 1058.13 ± 1.1% | 0.89 | 1.00 | 18.08 | 0.51 |
| class: two capitalized words, second text | 23 | 739.26 ± 16.0% | 797.89 ± 36.9% | 1147.30 ± 1.0% | 157.84 ± 1.0% | 776.13 ± 8.2% | 1344.15 ± 1.2% | 9645.83 ± 7.8% | 747.62 ± 3.0% | 0.93 | 0.99 | 4.68 | 0.95 |
| other: a word between two words | 13 | 895.47 ± 3.2% | 930.17 ± 15.2% | 1444.38 ± 4.2% | 202.99 ± 1.1% | 752.04 ± 19.5% | 1518.27 ± 2.0% | 23109.90 ± 3.1% | 895.61 ± 11.1% | 0.96 | 1.00 | 4.41 | 1.19 |
| other: a number before a unit, second text | 15 | 642.34 ± 39.4% | 710.69 ± 4.9% | 993.73 ± 1.3% | 55.37 ± 6.6% | 921.10 ± 8.6% | 1652.59 ± 6.8% | 24451.33 ± 14.0% | 646.60 ± 3.1% | 0.90 | 0.99 | 11.60 | 0.70 |
| other: a heading's start tag | 13 | 583.71 ± 2.3% | 600.28 ± 3.0% | 779.88 ± 3.6% | 57.97 ± 3.6% | 906.64 ± 29.3% | 1555.31 ± 2.3% | 28546.28 ± 1.4% | 572.57 ± 34.3% | 0.97 | 1.02 | 10.07 | 0.64 |
| other: a whole word | 11 | 914.55 ± 4.0% | 954.55 ± 11.0% | 1547.66 ± 8.6% | 179.81 ± 4.3% | 802.54 ± 15.4% | 1529.74 ± 41.0% | 40962.49 ± 21.0% | 887.88 ± 9.3% | 0.96 | 1.03 | 5.09 | 1.14 |
| other: a line's first word, second text | 17 | 842.90 ± 4.2% | 905.08 ± 7.5% | 1427.74 ± 2.7% | 187.19 ± 2.5% | 986.45 ± 3.2% | refused | refused | 850.97 ± 5.0% | 0.93 | 0.99 | 4.50 | 0.85 |
| other: fourteen octets before an x | 16 | 178.88 ± 3.2% | 254.22 ± 2.7% | 290.22 ± 2.6% | 21.89 ± 4.3% | 652.39 ± 42.2% | 696.51 ± 5.9% | 20638.11 ± 3.3% | 181.55 ± 4.0% | 0.70 | 0.99 | 8.17 | 0.27 |
| other: a Greek word | 8 | 699.34 ± 1.5% | 959.83 ± 2.2% | 1532.77 ± 2.4% | 72.71 ± 2.2% | 2050.77 ± 4.9% | 3075.14 ± 3.1% | refused | 696.20 ± 3.2% | 0.73 | 1.00 | 9.62 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 44469.99 ± 3.2% | not timed | not timed | 44266.76 ± 2.7% | 3938.49 ± 23.6% | not timed | not timed | 44938.93 ± 3.6% | | 0.99 | 1.00 | 11.29 |
| 01-literal/sherlock-casei-en | 522 | 40551.42 ± 3.0% | not timed | not timed | 11359.29 ± 1.2% | 52.27 ± 12.0% | not timed | not timed | 41210.06 ± 3.3% | | 0.98 | 3.57 | 775.86 |
| 01-literal/sherlock-ru | 724 | 45050.40 ± 2.1% | not timed | not timed | 42115.09 ± 4.7% | 2413.53 ± 1.8% | not timed | not timed | 45266.99 ± 2.2% | | 1.00 | 1.07 | 18.67 |
| 01-literal/sherlock-casei-ru | 746 | 14717.25 ± 2.7% | not timed | not timed | 9248.01 ± 1.2% | 56.30 ± 1.1% | not timed | not timed | 14679.40 ± 1.6% | | 1.00 | 1.59 | 261.39 |
| 01-literal/sherlock-zh | 30 | 80361.51 ± 1.1% | not timed | not timed | 58854.38 ± 36.1% | 2099.90 ± 7.9% | not timed | not timed | 80354.15 ± 7.6% | | 1.00 | 1.37 | 38.27 |
| 02-literal-alternate/sherlock-en | 714 | 18519.97 ± 5.6% | not timed | not timed | 13246.23 ± 1.8% | 27.95 ± 29.0% | not timed | not timed | 18379.46 ± 3.6% | | 1.01 | 1.40 | 662.67 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2986.86 ± 11.9% | not timed | not timed | 2878.54 ± 2.3% | 17.51 ± 3.3% | not timed | not timed | 3008.89 ± 5.6% | | 0.99 | 1.04 | 170.63 |
| 02-literal-alternate/sherlock-ru | 899 | 12132.07 ± 2.7% | not timed | not timed | 7195.28 ± 2.1% | 37.14 ± 1.1% | not timed | not timed | 12151.78 ± 2.4% | | 1.00 | 1.69 | 326.64 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2687.13 ± 8.9% | not timed | not timed | 1382.04 ± 16.5% | 15.63 ± 2.5% | not timed | not timed | 2698.70 ± 2.9% | | 1.00 | 1.94 | 171.89 |
| 02-literal-alternate/sherlock-zh | 207 | 24324.05 ± 5.4% | not timed | not timed | 15325.81 ± 6.7% | 51.48 ± 1.4% | not timed | not timed | 24274.04 ± 4.3% | | 1.00 | 1.59 | 472.50 |
| 03-date/ascii | 111817 | 180.98 ± 2.6% | not timed | not timed | 122.21 ± 3.0% | 0.31 ± 9.4% | not timed | not timed | 180.92 ± 4.5% | | 1.00 | 1.48 | 589.82 |
| 04-ruff-noqa/real | 84 | 652.37 ± 3.9% | not timed | not timed | 684.09 ± 1.7% | 30.23 ± 1.0% | not timed | not timed | 655.52 ± 4.7% | | 1.00 | 0.95 | 21.58 |
| 04-ruff-noqa/tweaked | 44 | 821.66 ± 6.4% | not timed | not timed | 692.96 ± 4.4% | 486.36 ± 4.1% | not timed | not timed | 869.21 ± 4.5% | | 0.95 | 1.19 | 1.69 |
| 05-lexer-veryl/single | 124800 | 7.25 ± 5.6% | not timed | not timed | 7.28 ± 3.6% | 0.35 ± 11.1% | not timed | not timed | 7.19 ± 19.3% | | 1.01 | 1.00 | 20.64 |
| 06-cloud-flare-redos/original | 107 | 549.55 ± 2.0% | not timed | not timed | 281.80 ± 1.2% | 35.68 ± 2.9% | not timed | not timed | 545.64 ± 9.6% | | 1.01 | 1.95 | 15.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 564.24 ± 3.7% | not timed | not timed | 300.92 ± 4.9% | 42.17 ± 4.2% | not timed | not timed | 553.80 ± 9.2% | | 1.02 | 1.88 | 13.38 |
| 06-cloud-flare-redos/simplified-long | 10000 | 666.93 ± 3.9% | not timed | not timed | 318.44 ± 4.3% | 44.81 ± 38.4% | not timed | not timed | 661.17 ± 7.9% | | 1.01 | 2.09 | 14.88 |
| 07-unicode-character-data/parse-line | 558784 | 333.82 ± 4.5% | not timed | not timed | 253.68 ± 3.4% | 66.62 ± 19.9% | not timed | not timed | 324.85 ± 7.8% | | 1.03 | 1.32 | 5.01 |
| 08-words/all-english | 56691 | 175.74 ± 2.7% | not timed | not timed | 110.08 ± 9.2% | 18.64 ± 8.0% | not timed | not timed | 173.22 ± 5.1% | | 1.01 | 1.60 | 9.43 |
| 08-words/long-english | 839 | 722.47 ± 1.6% | not timed | not timed | 691.13 ± 4.1% | 49.00 ± 1.3% | not timed | not timed | 726.67 ± 1.5% | | 0.99 | 1.05 | 14.75 |
| 09-aws-keys/full | 0 | 668.48 ± 3.4% | not timed | not timed | 707.65 ± 2.6% | 95.56 ± 2.0% | not timed | not timed | 672.44 ± 1.3% | | 0.99 | 0.94 | 7.00 |
| 09-aws-keys/quick | 0 | 1473.00 ± 3.4% | not timed | not timed | 1213.33 ± 41.7% | 540.91 ± 3.4% | not timed | not timed | 1474.86 ± 9.2% | | 1.00 | 1.21 | 2.72 |
| 10-bounded-repeat/letters-en | 1833 | 831.61 ± 4.2% | not timed | not timed | 756.96 ± 5.0% | 30.30 ± 2.6% | not timed | not timed | 848.94 ± 3.1% | | 0.98 | 1.10 | 27.45 |
| 10-bounded-repeat/letters-ru | 3475 | 692.99 ± 2.2% | not timed | not timed | 625.30 ± 2.4% | 31.19 ± 11.2% | not timed | not timed | 693.07 ± 5.6% | | 1.00 | 1.11 | 22.22 |
| 10-bounded-repeat/context | 53 | 115.13 ± 6.0% | not timed | not timed | 89.63 ± 8.5% | 29.13 ± 9.0% | not timed | not timed | 113.28 ± 6.2% | | 1.02 | 1.28 | 3.95 |
| 10-bounded-repeat/capitals | 11 | 758.62 ± 11.9% | not timed | not timed | 728.67 ± 4.2% | 52.80 ± 6.2% | not timed | not timed | 772.48 ± 8.0% | | 0.98 | 1.04 | 14.37 |
| 11-unstructured-to-json/extract | 600 | 73.71 ± 4.1% | not timed | not timed | 103.24 ± 3.8% | 73.81 ± 6.0% | not timed | not timed | 73.67 ± 3.8% | | 1.00 | 0.71 | 1.00 |
| 12-dictionary/single | 1 | 641.65 ± 1.9% | not timed | not timed | 610.77 ± 1.1% | 0.63 ± 4.1% | not timed | not timed | 640.14 ± 2.7% | | 1.00 | 1.05 | 1017.31 |
| 14-quadratic/1x | 100 | 38.98 ± 4.4% | not timed | not timed | 16.90 ± 15.8% | 1.46 ± 90.2% | not timed | not timed | 39.12 ± 6.2% | | 1.00 | 2.31 | 26.70 |
| 14-quadratic/2x | 200 | 29.68 ± 7.6% | not timed | not timed | 7.57 ± 4.9% | 0.76 ± 4.3% | not timed | not timed | 29.93 ± 6.7% | | 0.99 | 3.92 | 39.08 |
| 14-quadratic/10x | 1000 | 10.78 ± 37.2% | not timed | not timed | 1.45 ± 3.6% | 0.17 ± 6.2% | not timed | not timed | 10.69 ± 15.7% | | 1.01 | 7.44 | 62.97 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.92 ± 11.9% | not timed | not timed | 0.54 ± 4.9% | 0.85 ± 3.1% | not timed | not timed | 1.93 ± 2.1% | | 1.00 | 3.60 | 2.27 |
| 04-ruff-noqa/compile-real | 1 | 183.24 ± 9.5% | not timed | not timed | 21.17 ± 5.5% | 223.13 ± 9.6% | not timed | not timed | 180.62 ± 6.2% | | 1.01 | 8.66 | 0.82 |
| 05-lexer-veryl/compile-single | 1 | 22.31 ± 4.1% | not timed | not timed | 3.85 ± 1.0% | 10.63 ± 8.5% | not timed | not timed | 22.10 ± 5.5% | | 1.01 | 5.79 | 2.10 |
| 07-unicode-character-data/compile | 1 | 177.25 ± 6.7% | not timed | not timed | 39.14 ± 5.5% | 56.38 ± 10.2% | not timed | not timed | 175.53 ± 7.5% | | 1.01 | 4.53 | 3.14 |
| 09-aws-keys/compile-full | 1 | 74.90 ± 7.3% | not timed | not timed | 12.27 ± 4.7% | 34.51 ± 9.9% | not timed | not timed | 75.14 ± 3.8% | | 1.00 | 6.11 | 2.17 |
| 09-aws-keys/compile-quick | 1 | 293.80 ± 6.7% | not timed | not timed | 79.12 ± 5.7% | 215.83 ± 8.8% | not timed | not timed | 294.44 ± 6.2% | | 1.00 | 3.71 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 85.69 ± 11.0% | not timed | not timed | 17.37 ± 5.8% | 25.47 ± 70.9% | not timed | not timed | 85.39 ± 1.0% | | 1.00 | 4.93 | 3.36 |
| 10-bounded-repeat/compile-capitals | 1 | 131.25 ± 1.9% | not timed | not timed | 12.60 ± 0.6% | 36.54 ± 2.5% | not timed | not timed | 130.97 ± 3.3% | | 1.00 | 10.42 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 273.62 ± 2.2% | not timed | not timed | 63.66 ± 2.6% | 103.01 ± 8.4% | not timed | not timed | 276.59 ± 2.8% | | 0.99 | 4.30 | 2.66 |
| 12-dictionary/compile-single | 1 | 0.45 ± 2.4% | not timed | not timed | 0.10 ± 23.8% | 0.14 ± 20.6% | not timed | not timed | 0.45 ± 26.7% | | 1.00 | 4.58 | 3.24 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.20 ± 7.3% | not timed | not timed | 9.86 ± 2.8% | 0.88 ± 20.0% | not timed | not timed | 9.95 ± 8.7% | | 1.02 | 1.03 | 11.60 |
| dictionary/search/english-10 | 690 | 1.81 ± 2.8% | not timed | not timed | 231.66 ± 6.3% | 0.01 ± 5.5% | not timed | not timed | 1.79 ± 8.4% | | 1.01 | 0.0078 | 180.01 |
| dictionary/search/english-15 | 15 | 641.94 ± 3.9% | not timed | not timed | 615.16 ± 1.8% | 0.58 ± 1.8% | not timed | not timed | 642.04 ± 0.6% | | 1.00 | 1.04 | 1113.52 |
| folly/awyer-inn-busted | 1 | 6961.08 ± 13.2% | not timed | not timed | 168.24 ± 7.2% | 71.64 ± 3.7% | not timed | not timed | 6929.25 ± 4.4% | | 1.00 | 41.37 | 97.17 |
| folly/literal-never-match-rare | 0 | 83408.82 ± 5.6% | not timed | not timed | 66364.46 ± 6.5% | 88977.08 ± 6.5% | not timed | not timed | 83475.31 ± 7.8% | | 1.00 | 1.26 | 0.94 |
| folly/literal-never-match-frequent | 0 | 39418.33 ± 16.0% | not timed | not timed | 66973.77 ± 30.7% | 3038.40 ± 5.4% | not timed | not timed | 39255.77 ± 13.0% | | 1.00 | 0.59 | 12.97 |
| folly/literal-never-match-tricksy | 1 | 5384.93 ± 6.4% | not timed | not timed | 8495.65 ± 9.9% | 3891.01 ± 7.0% | not timed | not timed | 5256.47 ± 17.6% | | 1.02 | 0.63 | 1.38 |
| grep/every-line | 239963 | 1827.66 ± 3.7% | not timed | not timed | 1273.41 ± 4.3% | 544.75 ± 76.7% | not timed | not timed | 1819.79 ± 13.5% | | 1.00 | 1.44 | 3.36 |
| grep/long-words-ascii | 5073 | 657.89 ± 37.9% | not timed | not timed | 616.72 ± 5.7% | 63.11 ± 29.1% | not timed | not timed | 670.14 ± 3.8% | | 0.98 | 1.07 | 10.42 |
| imported/leipzig/twain | 811 | 68298.17 ± 19.4% | not timed | not timed | 56002.37 ± 4.3% | 14665.09 ± 14.0% | not timed | not timed | 68144.94 ± 6.4% | | 1.00 | 1.22 | 4.66 |
| imported/leipzig/twain-insensitive | 965 | 18802.25 ± 14.3% | not timed | not timed | 16928.38 ± 2.5% | 63.41 ± 6.4% | not timed | not timed | 18957.84 ± 4.8% | | 0.99 | 1.11 | 296.53 |
| imported/leipzig/shing | 1540 | 37844.46 ± 9.4% | not timed | not timed | 27175.19 ± 5.5% | 51.45 ± 7.2% | not timed | not timed | 38677.56 ± 4.5% | | 0.98 | 1.39 | 735.55 |
| imported/leipzig/huck-saw | 262 | 33214.80 ± 2.9% | not timed | not timed | 23435.99 ± 72.3% | 52.17 ± 12.7% | not timed | not timed | 33686.43 ± 4.9% | | 0.99 | 1.42 | 636.66 |
| imported/leipzig/word-ending-nn | 262 | 708.69 ± 40.1% | not timed | not timed | 716.85 ± 4.3% | 39.63 ± 4.8% | not timed | not timed | 721.59 ± 2.3% | | 0.98 | 0.99 | 17.88 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 14931.92 ± 3.9% | not timed | not timed | 5283.14 ± 3.2% | 15.57 ± 5.2% | not timed | not timed | 14862.82 ± 6.5% | | 1.00 | 2.83 | 958.89 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 27191.88 ± 53.6% | not timed | not timed | 19810.09 ± 12.1% | 28.39 ± 1.3% | not timed | not timed | 27256.91 ± 69.5% | | 1.00 | 1.37 | 957.68 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6391.01 ± 2.9% | not timed | not timed | 1131.53 ± 3.1% | 17.86 ± 4.8% | not timed | not timed | 6368.56 ± 5.9% | | 1.00 | 5.65 | 357.90 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 711.03 ± 1.7% | not timed | not timed | 714.99 ± 48.0% | 18.60 ± 3.7% | not timed | not timed | 712.65 ± 2.9% | | 1.00 | 0.99 | 38.22 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 705.36 ± 2.1% | not timed | not timed | 701.15 ± 2.4% | 15.71 ± 1.9% | not timed | not timed | 708.02 ± 3.3% | | 1.00 | 1.01 | 44.89 |
| imported/leipzig/tom-river | 2 | 15899.35 ± 3.0% | not timed | not timed | 16427.31 ± 5.8% | 50.10 ± 13.4% | not timed | not timed | 15422.06 ± 8.4% | | 1.03 | 0.97 | 317.35 |
| imported/leipzig/ing | 78424 | 686.91 ± 6.7% | not timed | not timed | 657.15 ± 5.0% | 41.89 ± 14.0% | not timed | not timed | 697.43 ± 3.3% | | 0.98 | 1.05 | 16.40 |
| imported/leipzig/ing-whitespace | 55248 | 866.66 ± 1.9% | not timed | not timed | 2776.25 ± 3.5% | 31.98 ± 4.7% | not timed | not timed | 878.00 ± 1.8% | | 0.99 | 0.31 | 27.10 |
| imported/leipzig/awyer-inn | 209 | 878.44 ± 55.1% | not timed | not timed | 17038.27 ± 6.4% | 33.26 ± 6.1% | not timed | not timed | 894.39 ± 10.8% | | 0.98 | 0.0516 | 26.41 |
| imported/leipzig/quotes-bounded | 8886 | 2423.50 ± 3.0% | not timed | not timed | 3854.57 ± 4.0% | 56.49 ± 3.3% | not timed | not timed | 2444.62 ± 5.1% | | 0.99 | 0.63 | 42.90 |
| imported/leipzig/non-ascii-alternate | 2 | 56271.88 ± 12.8% | not timed | not timed | 23991.13 ± 8.0% | 79.40 ± 12.5% | not timed | not timed | 55351.26 ± 4.1% | | 1.02 | 2.35 | 708.70 |
| imported/leipzig/math-symbols | 69 | 4143.44 ± 2.7% | not timed | not timed | 706.32 ± 1.3% | 54.03 ± 2.8% | not timed | not timed | 4107.81 ± 2.3% | | 1.01 | 5.87 | 76.68 |
| imported/leipzig/bounded-strings-ending-z | 0 | 694.44 ± 3.1% | not timed | not timed | 702.59 ± 1.8% | 35.86 ± 8.6% | not timed | not timed | 703.84 ± 2.8% | | 0.99 | 0.99 | 19.37 |
| imported/lh3lh3-reb/uri | 17549 | 998.13 ± 7.2% | not timed | not timed | 1473.71 ± 3.1% | 38.45 ± 3.9% | not timed | not timed | 985.20 ± 8.6% | | 1.01 | 0.68 | 25.96 |
| imported/lh3lh3-reb/email | 15057 | 975.87 ± 11.2% | not timed | not timed | 1406.92 ± 6.1% | 40.55 ± 5.2% | not timed | not timed | 968.82 ± 3.2% | | 1.01 | 0.69 | 24.07 |
| imported/lh3lh3-reb/date | 668 | 1123.11 ± 8.5% | not timed | not timed | 1254.63 ± 1.1% | 67.94 ± 10.8% | not timed | not timed | 1118.73 ± 1.5% | | 1.00 | 0.90 | 16.53 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 918.09 ± 9.6% | not timed | not timed | 523.15 ± 4.0% | 21.59 ± 2.2% | not timed | not timed | 914.74 ± 2.0% | | 1.00 | 1.75 | 42.53 |
| imported/mariomka/email | 92 | 50628.48 ± 3.3% | not timed | not timed | 70597.97 ± 1.8% | 47.94 ± 2.4% | not timed | not timed | 50451.02 ± 2.6% | | 1.00 | 0.72 | 1056.10 |
| imported/mariomka/uri | 5301 | 8488.76 ± 3.4% | not timed | not timed | 8852.56 ± 2.5% | 48.64 ± 2.7% | not timed | not timed | 8480.57 ± 4.3% | | 1.00 | 0.96 | 174.53 |
| imported/mariomka/ip | 5 | 2335.66 ± 30.5% | not timed | not timed | 2725.34 ± 51.3% | 28.01 ± 32.7% | not timed | not timed | 2318.80 ± 51.2% | | 1.01 | 0.86 | 83.38 |
| imported/rsc/no-exponential | 0 | 1156.57 ± 1.9% | not timed | not timed | 648.00 ± 53.9% | 32.06 ± 25.8% | not timed | not timed | 1150.01 ± 23.4% | | 1.01 | 1.78 | 36.07 |
| imported/rsc/literal | 1 | 1296.42 ± 5.2% | not timed | not timed | 2839.97 ± 2.5% | 306.65 ± 11.6% | not timed | not timed | 1258.90 ± 12.5% | | 1.03 | 0.46 | 4.23 |
| imported/rsc/not-literal | 2 | 1396.12 ± 52.2% | not timed | not timed | 1290.44 ± 38.2% | 74.72 ± 3.4% | not timed | not timed | 1435.28 ± 41.0% | | 0.97 | 1.08 | 18.69 |
| imported/rsc/match-class | 1 | 2503.36 ± 5.7% | not timed | not timed | 2945.84 ± 19.3% | 93.81 ± 7.0% | not timed | not timed | 2495.50 ± 5.7% | | 1.00 | 0.85 | 26.69 |
| imported/rsc/match-class-in-range | 1 | 2474.96 ± 1.3% | not timed | not timed | 4529.11 ± 3.6% | 95.23 ± 10.7% | not timed | not timed | 2473.41 ± 6.4% | | 1.00 | 0.55 | 25.99 |
| imported/rsc/match-class-unicode | 1 | 675.19 ± 3.2% | not timed | not timed | 638.59 ± 2.3% | 115.84 ± 7.1% | not timed | not timed | 681.00 ± 1.8% | | 0.99 | 1.06 | 5.83 |
| imported/rsc/anchored-literal-short-non-match | 0 | 2489.15 ± 3.3% | not timed | not timed | 1701.41 ± 6.1% | 437.27 ± 19.4% | not timed | not timed | 2445.79 ± 3.4% | | 1.02 | 1.46 | 5.69 |
| imported/rsc/anchored-literal-long-non-match | 0 | 36956.96 ± 38.5% | not timed | not timed | 25843.99 ± 3.1% | 6701.64 ± 17.3% | not timed | not timed | 37552.86 ± 3.9% | | 0.98 | 1.43 | 5.51 |
| imported/rsc/anchored-literal-short-match | 4 | 1251.40 ± 8.0% | not timed | not timed | 947.66 ± 5.8% | 141.59 ± 10.4% | not timed | not timed | 1259.07 ± 1.9% | | 0.99 | 1.32 | 8.84 |
| imported/rsc/anchored-literal-long-match | 4 | 18566.21 ± 26.8% | not timed | not timed | 14135.81 ± 2.3% | 2065.61 ± 14.2% | not timed | not timed | 18961.03 ± 5.0% | | 0.98 | 1.31 | 8.99 |
| imported/rsc/one-pass-short | 17 | 678.17 ± 6.1% | not timed | not timed | 418.46 ± 3.3% | 49.18 ± 7.3% | not timed | not timed | 681.60 ± 3.3% | | 0.99 | 1.62 | 13.79 |
| imported/rsc/one-pass-short-not | 17 | 448.54 ± 7.2% | not timed | not timed | 418.07 ± 3.0% | 44.76 ± 9.4% | not timed | not timed | 432.76 ± 4.9% | | 1.04 | 1.07 | 10.02 |
| imported/rsc/one-pass-long-prefix | 26 | 574.36 ± 14.9% | not timed | not timed | 458.12 ± 6.5% | 174.49 ± 10.9% | not timed | not timed | 563.05 ± 4.3% | | 1.02 | 1.25 | 3.29 |
| imported/rsc/one-pass-long-prefix-not | 26 | 570.87 ± 12.6% | not timed | not timed | 506.77 ± 5.8% | 115.29 ± 7.5% | not timed | not timed | 575.67 ± 10.6% | | 0.99 | 1.13 | 4.95 |
| imported/rsc/long-needle1 | 31 | 84647.07 ± 3.7% | not timed | not timed | 64735.93 ± 5.1% | 5.81 ± 7.2% | not timed | not timed | 85144.92 ± 1.2% | | 0.99 | 1.31 | 14566.34 |
| imported/rsc/long-needle2 | 31 | 85361.43 ± 1.1% | not timed | not timed | 352.22 ± 3.5% | 5.73 ± 4.8% | not timed | not timed | 85685.35 ± 2.0% | | 1.00 | 242.35 | 14886.78 |
| imported/rsc/easy0-32 | 26 | 1885.27 ± 2.6% | not timed | not timed | 2764.42 ± 2.0% | 219.43 ± 5.2% | not timed | not timed | 1868.28 ± 6.9% | | 1.01 | 0.68 | 8.59 |
| imported/rsc/easy0-1k | 26 | 30623.69 ± 5.4% | not timed | not timed | 30278.52 ± 16.4% | 3320.56 ± 9.3% | not timed | not timed | 30764.17 ± 4.0% | | 1.00 | 1.01 | 9.22 |
| imported/rsc/easy0-32k | 26 | 82164.85 ± 3.1% | not timed | not timed | 63183.65 ± 3.0% | 37637.43 ± 22.8% | not timed | not timed | 81999.86 ± 3.0% | | 1.00 | 1.30 | 2.18 |
| imported/rsc/easy0-1mb | 26 | 80157.63 ± 3.0% | not timed | not timed | 64158.73 ± 3.3% | 94221.85 ± 1.0% | not timed | not timed | 80289.36 ± 2.2% | | 1.00 | 1.25 | 0.85 |
| imported/rsc/easy1-32 | 19 | 1243.41 ± 15.0% | not timed | not timed | 1315.19 ± 5.1% | 205.24 ± 8.2% | not timed | not timed | 1326.90 ± 7.2% | | 0.94 | 0.95 | 6.06 |
| imported/rsc/easy1-1k | 19 | 24525.02 ± 4.4% | not timed | not timed | 25961.83 ± 4.2% | 3719.98 ± 10.6% | not timed | not timed | 26046.20 ± 3.5% | | 0.94 | 0.94 | 6.59 |
| imported/rsc/easy1-32k | 19 | 797072.54 ± 2.2% | not timed | not timed | 833185.37 ± 3.0% | 41411.95 ± 24.8% | not timed | not timed | 843142.02 ± 5.1% | | 0.95 | 0.96 | 19.25 |
| imported/rsc/easy1-1mb | 19 | 24150729.92 ± 3.0% | not timed | not timed | 26799762.95 ± 1.0% | 97202.78 ± 3.1% | not timed | not timed | 25066700.48 ± 5.8% | | 0.96 | 0.90 | 248.46 |
| imported/rsc/medium-32 | 27 | 1156.57 ± 2.8% | not timed | not timed | 1149.48 ± 12.4% | 109.12 ± 8.6% | not timed | not timed | 1154.70 ± 1.6% | | 1.00 | 1.01 | 10.60 |
| imported/rsc/medium-1k | 27 | 20776.07 ± 2.0% | not timed | not timed | 20497.39 ± 2.0% | 111.70 ± 3.6% | not timed | not timed | 20732.64 ± 6.0% | | 1.00 | 1.01 | 186.00 |
| imported/rsc/medium-32k | 27 | 601001.04 ± 1.6% | not timed | not timed | 632437.45 ± 0.8% | 76.87 ± 1.2% | not timed | not timed | 598944.36 ± 3.6% | | 1.00 | 0.95 | 7818.18 |
| imported/rsc/medium-1mb | 27 | 20336470.98 ± 3.3% | not timed | not timed | 20314393.81 ± 1.6% | 76.12 ± 0.6% | not timed | not timed | 20322922.70 ± 2.5% | | 1.00 | 1.00 | 267172.07 |
| imported/rsc/hard-32 | 58 | 566.45 ± 4.5% | not timed | not timed | 515.71 ± 3.1% | 72.16 ± 35.3% | not timed | not timed | 565.24 ± 31.8% | | 1.00 | 1.10 | 7.85 |
| imported/rsc/hard-1k | 27 | 19452.45 ± 2.3% | not timed | not timed | 19173.23 ± 2.4% | 58.46 ± 2.0% | not timed | not timed | 19553.19 ± 1.5% | | 0.99 | 1.01 | 332.74 |
| imported/rsc/hard-32k | 27 | 610324.76 ± 2.4% | not timed | not timed | 618725.21 ± 2.1% | 46.61 ± 4.0% | not timed | not timed | 611598.04 ± 2.7% | | 1.00 | 0.99 | 13092.95 |
| imported/rsc/hard-1mb | 51 | 11144119.99 ± 0.8% | not timed | not timed | 10398050.47 ± 1.9% | 46.32 ± 2.0% | not timed | not timed | 11118927.50 ± 1.2% | | 1.00 | 1.07 | 240615.73 |
| imported/rsc/reallyhard0-32 | 58 | 357.95 ± 4.0% | not timed | not timed | 331.70 ± 18.2% | 71.67 ± 31.8% | not timed | not timed | 361.56 ± 2.3% | | 0.99 | 1.08 | 4.99 |
| imported/rsc/reallyhard0-1k | 27 | 685.71 ± 3.7% | not timed | not timed | 682.00 ± 2.7% | 57.79 ± 5.0% | not timed | not timed | 680.96 ± 1.5% | | 1.01 | 1.01 | 11.87 |
| imported/rsc/reallyhard0-32k | 27 | 696.96 ± 4.2% | not timed | not timed | 705.26 ± 0.5% | 46.58 ± 5.2% | not timed | not timed | 686.58 ± 4.8% | | 1.02 | 0.99 | 14.96 |
| imported/rsc/reallyhard0-1mb | 51 | 710.55 ± 5.1% | not timed | not timed | 712.18 ± 4.7% | 47.01 ± 4.8% | not timed | not timed | 721.02 ± 4.4% | | 0.99 | 1.00 | 15.12 |
| imported/rsc/reallyreallyhard0-32 | 47 | 431.48 ± 8.9% | not timed | not timed | 265.65 ± 21.4% | 90.23 ± 49.0% | not timed | not timed | 429.69 ± 5.0% | | 1.00 | 1.62 | 4.78 |
| imported/rsc/reallyreallyhard0-1k | 16 | 11120.35 ± 0.7% | not timed | not timed | 10531.13 ± 2.1% | 48.94 ± 2.9% | not timed | not timed | 11271.14 ± 1.3% | | 0.99 | 1.06 | 227.22 |
| imported/rsc/reallyreallyhard0-32k | 16 | 71201.99 ± 3.4% | not timed | not timed | 55616.62 ± 1.7% | 37.67 ± 10.3% | not timed | not timed | 71082.16 ± 15.2% | | 1.00 | 1.28 | 1890.10 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 94257.55 ± 2.0% | not timed | not timed | 64553.06 ± 1.4% | 39.14 ± 1.3% | not timed | not timed | 94591.15 ± 1.0% | | 1.00 | 1.46 | 2408.06 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 410.68 ± 2.9% | not timed | not timed | 268.59 ± 3.2% | 89.52 ± 8.5% | not timed | not timed | 398.38 ± 7.1% | | 1.03 | 1.53 | 4.59 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 8928.10 ± 4.0% | not timed | not timed | 10194.34 ± 2.8% | 48.31 ± 1.5% | not timed | not timed | 8840.91 ± 2.0% | | 1.01 | 0.88 | 184.81 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 68770.25 ± 15.9% | not timed | not timed | 55940.68 ± 53.8% | 38.72 ± 2.0% | not timed | not timed | 68880.04 ± 1.5% | | 1.00 | 1.23 | 1776.02 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 82515.64 ± 0.8% | not timed | not timed | 64262.77 ± 11.3% | 38.88 ± 20.6% | not timed | not timed | 82423.17 ± 0.9% | | 1.00 | 1.28 | 2122.51 |
| imported/sherlock/name-sherlock | 776 | 63518.09 ± 4.0% | not timed | not timed | 50092.28 ± 7.3% | 15460.46 ± 6.8% | not timed | not timed | 63652.23 ± 3.8% | | 1.00 | 1.27 | 4.11 |
| imported/sherlock/name-holmes | 2766 | 36488.38 ± 2.0% | not timed | not timed | 35256.46 ± 18.6% | 4876.36 ± 5.9% | not timed | not timed | 36590.77 ± 6.4% | | 1.00 | 1.03 | 7.48 |
| imported/sherlock/name-sherlock-holmes | 1365 | 63941.66 ± 4.2% | not timed | not timed | 51297.51 ± 3.8% | 12548.87 ± 11.6% | not timed | not timed | 64628.06 ± 5.9% | | 0.99 | 1.25 | 5.10 |
| imported/sherlock/name-sherlock-casei | 816 | 64765.48 ± 4.0% | not timed | not timed | 14238.79 ± 4.0% | 51.09 ± 3.1% | not timed | not timed | 63776.10 ± 2.9% | | 1.02 | 4.55 | 1267.64 |
| imported/sherlock/name-holmes-casei | 2802 | 31193.41 ± 1.7% | not timed | not timed | 8910.48 ± 2.0% | 64.60 ± 4.3% | not timed | not timed | 31170.88 ± 2.2% | | 1.00 | 3.50 | 482.88 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 52555.71 ± 3.6% | not timed | not timed | 13896.42 ± 1.5% | 51.34 ± 4.8% | not timed | not timed | 52319.95 ± 4.4% | | 1.00 | 3.78 | 1023.62 |
| imported/sherlock/name-whitespace | 1461 | 37801.83 ± 4.6% | not timed | not timed | 36208.69 ± 5.3% | 11838.79 ± 23.3% | not timed | not timed | 37498.71 ± 3.3% | | 1.01 | 1.04 | 3.19 |
| imported/sherlock/name-alt1 | 1142 | 43482.28 ± 5.7% | not timed | not timed | 42198.64 ± 1.7% | 6456.94 ± 31.8% | not timed | not timed | 43408.99 ± 4.7% | | 1.00 | 1.03 | 6.73 |
| imported/sherlock/name-alt2 | 3542 | 27617.62 ± 2.6% | not timed | not timed | 11788.34 ± 1.2% | 52.69 ± 1.5% | not timed | not timed | 27550.01 ± 1.5% | | 1.00 | 2.34 | 524.17 |
| imported/sherlock/name-alt3 | 4507 | 16951.61 ± 3.0% | not timed | not timed | 11048.36 ± 1.5% | 16.62 ± 1.7% | not timed | not timed | 17008.89 ± 2.7% | | 1.00 | 1.53 | 1019.76 |
| imported/sherlock/name-alt3-casei | 4593 | 2377.33 ± 10.7% | not timed | not timed | 1606.94 ± 4.3% | 10.31 ± 23.2% | not timed | not timed | 2398.78 ± 23.4% | | 0.99 | 1.48 | 230.65 |
| imported/sherlock/name-alt4 | 3686 | 12637.90 ± 1.1% | not timed | not timed | 9286.52 ± 7.9% | 53.37 ± 3.9% | not timed | not timed | 12596.75 ± 1.1% | | 1.00 | 1.36 | 236.82 |
| imported/sherlock/name-alt4-casei | 4254 | 6934.47 ± 18.2% | not timed | not timed | 5030.20 ± 1.5% | 31.59 ± 32.7% | not timed | not timed | 6905.76 ± 4.8% | | 1.00 | 1.38 | 219.54 |
| imported/sherlock/name-alt5 | 4028 | 22087.87 ± 1.3% | not timed | not timed | 11484.55 ± 3.0% | 38.02 ± 2.3% | not timed | not timed | 22157.40 ± 16.8% | | 1.00 | 1.92 | 581.02 |
| imported/sherlock/name-alt5-casei | 4104 | 9330.62 ± 32.7% | not timed | not timed | 3689.35 ± 31.2% | 23.20 ± 3.1% | not timed | not timed | 9247.53 ± 18.9% | | 1.01 | 2.53 | 402.14 |
| imported/sherlock/no-match-uncommon | 0 | 88440.26 ± 1.5% | not timed | not timed | 88131.16 ± 4.0% | 76388.71 ± 4.9% | not timed | not timed | 88636.35 ± 23.4% | | 1.00 | 1.00 | 1.16 |
| imported/sherlock/no-match-common | 0 | 84982.33 ± 8.3% | not timed | not timed | 88150.90 ± 1.5% | 2322.21 ± 8.3% | not timed | not timed | 86445.57 ± 2.0% | | 0.98 | 0.96 | 36.60 |
| imported/sherlock/no-match-really-common | 0 | 59774.28 ± 2.0% | not timed | not timed | 61369.03 ± 2.9% | 2290.96 ± 2.1% | not timed | not timed | 59158.20 ± 5.4% | | 1.01 | 0.97 | 26.09 |
| imported/sherlock/the-lower | 21654 | 3801.02 ± 1.2% | not timed | not timed | 3784.30 ± 5.1% | 366.67 ± 26.9% | not timed | not timed | 3815.12 ± 3.3% | | 1.00 | 1.00 | 10.37 |
| imported/sherlock/the-upper | 2223 | 25202.17 ± 10.7% | not timed | not timed | 31268.95 ± 10.8% | 4088.53 ± 64.4% | not timed | not timed | 25613.92 ± 10.5% | | 0.98 | 0.81 | 6.16 |
| imported/sherlock/the-casei | 23961 | 3377.27 ± 3.2% | not timed | not timed | 1621.36 ± 11.3% | 56.84 ± 19.5% | not timed | not timed | 3460.37 ± 2.2% | | 0.98 | 2.08 | 59.42 |
| imported/sherlock/everything-greedy | 581881 | 366.19 ± 3.4% | not timed | not timed | 215.39 ± 8.7% | 45.28 ± 52.3% | not timed | not timed | 364.84 ± 4.1% | | 1.00 | 1.70 | 8.09 |
| imported/sherlock/everything-greedy-nl | 594933 | 546.86 ± 2.2% | not timed | not timed | 280.61 ± 2.6% | 51.75 ± 2.1% | not timed | not timed | 547.70 ± 3.6% | | 1.00 | 1.95 | 10.57 |
| imported/sherlock/letters | 447175 | 82.09 ± 18.2% | not timed | not timed | 43.37 ± 3.3% | 8.37 ± 25.2% | not timed | not timed | 93.01 ± 4.6% | | 0.88 | 1.89 | 9.81 |
| imported/sherlock/letters-upper | 14180 | 520.42 ± 5.5% | not timed | not timed | 429.72 ± 3.0% | 42.86 ± 42.1% | not timed | not timed | 530.92 ± 9.4% | | 0.98 | 1.21 | 12.14 |
| imported/sherlock/letters-lower | 432995 | 93.83 ± 3.3% | not timed | not timed | 42.01 ± 2.3% | 7.89 ± 23.4% | not timed | not timed | 94.33 ± 2.1% | | 0.99 | 2.23 | 11.89 |
| imported/sherlock/words | 447639 | 151.59 ± 4.5% | not timed | not timed | 103.12 ± 2.4% | 19.87 ± 4.3% | not timed | not timed | 151.59 ± 2.1% | | 1.00 | 1.47 | 7.63 |
| imported/sherlock/before-holmes | 4073 | 18729.09 ± 22.5% | not timed | not timed | 16348.97 ± 4.2% | 36.62 ± 20.4% | not timed | not timed | 18991.58 ± 6.2% | | 0.99 | 1.15 | 511.44 |
| imported/sherlock/before-after-holmes | 2593 | 19181.10 ± 2.6% | not timed | not timed | 19009.72 ± 6.2% | 36.23 ± 5.8% | not timed | not timed | 18847.02 ± 2.3% | | 1.02 | 1.01 | 529.37 |
| imported/sherlock/holmes-cochar-watson | 150 | 11558.32 ± 6.4% | not timed | not timed | 9506.78 ± 8.6% | 50.97 ± 11.9% | not timed | not timed | 11641.14 ± 9.2% | | 0.99 | 1.22 | 226.76 |
| imported/sherlock/holmes-coword-watson | 14309 | 1493.71 ± 3.7% | not timed | not timed | 1483.87 ± 21.8% | 10.93 ± 46.0% | not timed | not timed | 1501.82 ± 6.7% | | 0.99 | 1.01 | 136.67 |
| imported/sherlock/quotes | 14437 | 1653.92 ± 4.6% | not timed | not timed | 2845.61 ± 2.4% | 52.42 ± 3.5% | not timed | not timed | 1642.69 ± 3.2% | | 1.01 | 0.58 | 31.55 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 701.93 ± 3.9% | not timed | not timed | 40658.53 ± 18.8% | 59.00 ± 43.8% | not timed | not timed | 699.03 ± 4.7% | | 1.00 | 0.0173 | 11.90 |
| imported/sherlock/word-ending-n | 35297 | 553.56 ± 2.7% | not timed | not timed | 478.19 ± 6.2% | 36.47 ± 23.4% | not timed | not timed | 555.21 ± 3.5% | | 1.00 | 1.16 | 15.18 |
| imported/sherlock/repeated-class-negation | 2130 | 23385.24 ± 38.2% | not timed | not timed | 22874.12 ± 30.3% | 14.95 ± 20.9% | not timed | not timed | 24153.81 ± 10.5% | | 0.97 | 1.02 | 1564.14 |
| imported/sherlock/ing-suffix | 20547 | 688.47 ± 1.4% | not timed | not timed | 598.69 ± 2.3% | 43.10 ± 25.0% | not timed | not timed | 687.54 ± 11.2% | | 1.00 | 1.15 | 15.97 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 711.75 ± 16.7% | not timed | not timed | 3567.60 ± 8.2% | 31.26 ± 26.5% | not timed | not timed | 712.78 ± 3.2% | | 1.00 | 0.20 | 22.77 |
| opt/accelerate/whole-line | 239963 | 628.88 ± 1.7% | not timed | not timed | 496.12 ± 2.5% | 125.68 ± 23.9% | not timed | not timed | 655.33 ± 3.2% | | 0.96 | 1.27 | 5.00 |
| opt/accelerate/non-dna | 16745 | 576.05 ± 3.1% | not timed | not timed | 553.39 ± 3.2% | 47.37 ± 33.2% | not timed | not timed | 579.01 ± 7.5% | | 0.99 | 1.04 | 12.16 |
| opt/backtrack/words-english | 40536 | 180.00 ± 3.9% | not timed | not timed | 136.78 ± 3.3% | 28.63 ± 25.6% | not timed | not timed | 182.17 ± 4.5% | | 0.99 | 1.32 | 6.29 |
| opt/fixed-length/too-small-ascii | 0 | 532.95 ± 4.2% | not timed | not timed | 1075.98 ± 6.6% | 159.35 ± 3.4% | not timed | not timed | 538.55 ± 35.0% | | 0.99 | 0.50 | 3.34 |
| opt/fixed-length/too-big-ascii | 0 | 6248.47 ± 24.0% | not timed | not timed | 8690.62 ± 4.3% | 208.80 ± 12.2% | not timed | not timed | 6202.67 ± 51.8% | | 1.01 | 0.72 | 29.93 |
| opt/fixed-length/go33484-1 | 0 | 1202643.83 ± 31.6% | not timed | not timed | 1680266.79 ± 1.2% | 118483.83 ± 1.9% | not timed | not timed | 1224315.92 ± 3.2% | | 0.98 | 0.72 | 10.15 |
| opt/fixed-length/go33484-2 | 0 | 1214396.89 ± 3.0% | not timed | not timed | 1702457.14 ± 1.2% | 44830.21 ± 1.3% | not timed | not timed | 1239461.79 ± 2.7% | | 0.98 | 0.71 | 27.09 |
| opt/fixed-length/go33484-3 | 0 | 2861.57 ± 12.8% | not timed | not timed | 166696.58 ± 4.2% | 1251.57 ± 9.7% | not timed | not timed | 2845.49 ± 29.6% | | 1.01 | 0.0172 | 2.29 |
| opt/literal-alt/one-pattern | 1 | 692.28 ± 1.5% | not timed | not timed | 686.35 ± 7.9% | 0.60 ± 2.2% | not timed | not timed | 682.21 ± 2.3% | | 1.01 | 1.01 | 1145.08 |
| opt/onepass/fn-predicate | 916 | 565.57 ± 28.5% | not timed | not timed | 502.39 ± 2.3% | 272.57 ± 19.6% | not timed | not timed | 573.74 ± 2.5% | | 0.99 | 1.13 | 2.07 |
| opt/onepass/first-three-words-english | 35128 | 232.16 ± 2.1% | not timed | not timed | 288.38 ± 6.3% | 111.17 ± 12.3% | not timed | not timed | 223.34 ± 5.2% | | 1.04 | 0.81 | 2.09 |
| opt/prefilter/literal-english | 1 | 87325.83 ± 2.5% | not timed | not timed | 66327.93 ± 5.3% | 34213.71 ± 8.0% | not timed | not timed | 86940.06 ± 2.0% | | 1.00 | 1.32 | 2.55 |
| opt/prefilter/literal-casei-english | 1 | 65720.66 ± 2.9% | not timed | not timed | 17750.81 ± 1.8% | 50.54 ± 1.9% | not timed | not timed | 65615.01 ± 2.5% | | 1.00 | 3.70 | 1300.46 |
| opt/prefilter/literal-russian | 1 | 84463.99 ± 3.1% | not timed | not timed | 63804.37 ± 3.0% | 3947.70 ± 3.9% | not timed | not timed | 84552.37 ± 2.3% | | 1.00 | 1.32 | 21.40 |
| opt/prefilter/literal-casei-russian | 1 | 34861.22 ± 2.3% | not timed | not timed | 12652.43 ± 3.2% | 54.74 ± 4.0% | not timed | not timed | 35025.60 ± 3.2% | | 1.00 | 2.76 | 636.82 |
| opt/prefilter/rust-functions | 948 | 19032.75 ± 13.9% | not timed | not timed | 15588.13 ± 26.3% | 2312.74 ± 10.8% | not timed | not timed | 19186.11 ± 2.2% | | 0.99 | 1.22 | 8.23 |
| opt/reverse-anchored/word-end | 1 | 46221352.77 ± 5.0% | not timed | not timed | 32650690.97 ± 1.9% | 77.74 ± 19.7% | not timed | not timed | 45149970.48 ± 43.7% | | 1.02 | 1.42 | 594551.93 |
| opt/reverse-inner/holmes | 2593 | 19146.84 ± 2.0% | not timed | not timed | 18754.62 ± 8.3% | 34.76 ± 1.4% | not timed | not timed | 18655.55 ± 2.5% | | 1.03 | 1.02 | 550.81 |
| opt/reverse-inner/email | 47 | 93612.43 ± 8.8% | not timed | not timed | 103250.00 ± 2.6% | 46.04 ± 1.8% | not timed | not timed | 95605.99 ± 2.2% | | 0.98 | 0.91 | 2033.50 |
| opt/reverse-inner/factored-prefix | 3542 | 689.50 ± 2.5% | not timed | not timed | 677.58 ± 1.8% | 17.64 ± 2.1% | not timed | not timed | 688.26 ± 2.4% | | 1.00 | 1.02 | 39.09 |
| opt/reverse-inner/no-quadratic-backward | 0 | 6612.37 ± 1.2% | not timed | not timed | 697.67 ± 2.2% | 117.95 ± 1.6% | not timed | not timed | 6622.99 ± 11.4% | | 1.00 | 9.48 | 56.06 |
| opt/reverse-inner/no-quadratic-forward | 0 | 814.48 ± 17.8% | not timed | not timed | 323.47 ± 6.3% | 37.83 ± 19.1% | not timed | not timed | 809.30 ± 32.3% | | 1.01 | 2.52 | 21.53 |
| opt/reverse-suffix/holmes | 4073 | 18837.89 ± 18.3% | not timed | not timed | 16209.64 ± 2.1% | 34.67 ± 19.2% | not timed | not timed | 18830.84 ± 1.7% | | 1.00 | 1.16 | 543.39 |
| opt/reverse-suffix/no-quadratic | 0 | 6596.80 ± 3.1% | not timed | not timed | 698.05 ± 5.5% | 116.74 ± 8.0% | not timed | not timed | 6615.67 ± 1.7% | | 1.00 | 9.45 | 56.51 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 195.58 ± 2.7% | not timed | not timed | 254.56 ± 4.5% | 22.99 ± 15.1% | not timed | not timed | 188.48 ± 24.8% | | 1.04 | 0.77 | 8.51 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 198.21 ± 9.8% | not timed | not timed | 248.84 ± 28.4% | 21.75 ± 17.2% | not timed | not timed | 200.83 ± 17.6% | | 0.99 | 0.80 | 9.11 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.45 ± 4.1% | not timed | not timed | 0.78 ± 2.8% | 161.42 ± 31.0% | not timed | not timed | 0.46 ± 5.3% | | 1.00 | 0.58 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 369.28 ± 7.4% | not timed | not timed | 346.07 ± 3.0% | 139.82 ± 24.6% | not timed | not timed | 370.15 ± 2.4% | | 1.00 | 1.07 | 2.64 |
| reported/i13-subset-regex/original-ascii | 4094 | 14265.47 ± 6.0% | not timed | not timed | 4984.19 ± 10.6% | 14.72 ± 2.6% | not timed | not timed | 14382.05 ± 3.8% | | 0.99 | 2.86 | 969.21 |
| reported/i13-subset-regex/original-unicode | 4094 | 14691.92 ± 1.4% | not timed | not timed | 276.45 ± 5.8% | 15.05 ± 2.2% | not timed | not timed | 14737.00 ± 1.4% | | 1.00 | 53.15 | 975.92 |
| reported/i13-subset-regex/big-ascii | 1955 | 13555.95 ± 4.7% | not timed | not timed | 75.65 ± 2.5% | 13.24 ± 5.0% | not timed | not timed | 13569.95 ± 2.3% | | 1.00 | 179.19 | 1023.53 |
| reported/i13-subset-regex/big-unicode | 1955 | 13521.61 ± 9.5% | not timed | not timed | 13.56 ± 56.1% | 13.10 ± 3.4% | not timed | not timed | 13466.05 ± 58.2% | | 1.00 | 997.15 | 1031.90 |
| reported/i13-subset-regex/huge-ascii | 55 | 12469.61 ± 27.3% | not timed | not timed | 12.88 ± 1.3% | 12.23 ± 4.2% | not timed | not timed | 12427.69 ± 3.3% | | 1.00 | 967.98 | 1019.56 |
| reported/i13-subset-regex/huge-unicode | 55 | 12421.76 ± 2.2% | not timed | not timed | 12.59 ± 2.0% | 12.11 ± 3.7% | not timed | not timed | 12448.96 ± 6.4% | | 1.00 | 987.02 | 1026.07 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.59 ± 0.5% | not timed | not timed | 13.18 ± 1.4% | 12.21 ± 1.8% | not timed | not timed | 5.62 ± 1.5% | | 1.00 | 0.42 | 0.46 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.04 ± 2.2% | not timed | not timed | 12.75 ± 2.8% | 11.87 ± 3.1% | not timed | not timed | 7.06 ± 2.1% | | 1.00 | 0.55 | 0.59 |
| reported/i787-keywords/ascii | 5674 | 664.05 ± 12.2% | not timed | not timed | 204.64 ± 7.8% | 9.83 ± 10.0% | not timed | not timed | 663.41 ± 31.4% | | 1.00 | 3.25 | 67.54 |
| reported/i787-keywords/opt-ascii | 5674 | 664.51 ± 17.6% | not timed | not timed | 329.15 ± 59.6% | 16.14 ± 47.4% | not timed | not timed | 671.99 ± 40.7% | | 0.99 | 2.02 | 41.16 |
| slow/quadratic-regex-1x | 100 | 10.42 ± 4.7% | not timed | not timed | 8.34 ± 5.0% | 0.08 ± 2.1% | not timed | not timed | 10.40 ± 3.1% | | 1.00 | 1.25 | 137.70 |
| slow/quadratic-regex-2x | 199 | 4.49 ± 3.9% | not timed | not timed | 3.93 ± 1.8% | 0.02 ± 39.7% | not timed | not timed | 4.49 ± 56.6% | | 1.00 | 1.14 | 232.88 |
| slow/quadratic-haystack-1x | 100 | 38.40 ± 3.4% | not timed | not timed | 16.63 ± 3.7% | 1.46 ± 7.7% | not timed | not timed | 38.99 ± 3.2% | | 0.98 | 2.31 | 26.28 |
| slow/quadratic-haystack-2x | 200 | 30.51 ± 5.6% | not timed | not timed | 7.73 ± 3.7% | 0.77 ± 10.3% | not timed | not timed | 30.61 ± 4.1% | | 1.00 | 3.95 | 39.86 |
| unicode/codepoints/any-one | 1112064 | 486.52 ± 5.5% | not timed | not timed | 353.89 ± 3.9% | 27.31 ± 12.2% | not timed | not timed | 510.78 ± 10.9% | | 0.95 | 1.37 | 17.81 |
| unicode/codepoints/any-all | 4382592 | 334.27 ± 6.6% | not timed | not timed | 324.86 ± 5.9% | 187.79 ± 4.8% | not timed | not timed | 341.38 ± 5.1% | | 0.98 | 1.03 | 1.78 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.91 ± 8.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 714.04 ± 4.4% | not timed | not timed | 707.55 ± 34.3% | 220.28 ± 42.7% | not timed | not timed | 701.68 ± 11.2% | | 1.02 | 1.01 | 3.24 |
| unicode/overlapping-words/ascii | 6156 | 43.87 ± 5.3% | not timed | not timed | 55.12 ± 1.7% | 6.04 ± 13.6% | not timed | not timed | 43.01 ± 7.5% | | 1.02 | 0.80 | 7.26 |
| unicode/overlapping-words/english | 6156 | 2.07 ± 8.3% | not timed | not timed | 5.12 ± 2.5% | 3.58 ± 17.6% | not timed | not timed | 2.15 ± 3.3% | | 0.96 | 0.40 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.85 ± 9.7% | not timed | not timed | 4.86 ± 6.3% | 8.80 ± 7.8% | not timed | not timed | 1.90 ± 2.0% | | 0.97 | 0.38 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 172.44 ± 3.1% | not timed | not timed | 102.59 ± 8.9% | 18.80 ± 84.2% | not timed | not timed | 168.31 ± 17.9% | | 1.02 | 1.68 | 9.17 |
| unicode/word/boundary-long-english | 3466 | 704.75 ± 1.3% | not timed | not timed | 691.30 ± 2.0% | 49.22 ± 1.9% | not timed | not timed | 710.53 ± 1.2% | | 0.99 | 1.02 | 14.32 |
| unicode/word/around-holmes-english | 27 | 80465.66 ± 1.9% | not timed | not timed | 64231.83 ± 3.4% | 33.91 ± 58.8% | not timed | not timed | 80962.52 ± 5.0% | | 0.99 | 1.25 | 2372.91 |
| wild/bibleref/long | 874 | 660.92 ± 4.5% | not timed | not timed | 675.68 ± 3.7% | 11.04 ± 4.4% | not timed | not timed | 662.96 ± 4.9% | | 1.00 | 0.98 | 59.88 |
| wild/bibleref/short | 30 | 31.66 ± 15.5% | not timed | not timed | 43.51 ± 3.1% | 22.51 ± 16.8% | not timed | not timed | 32.11 ± 4.2% | | 0.99 | 0.73 | 1.41 |
| wild/bibleref/line | 874 | 675.54 ± 2.4% | not timed | not timed | 326.20 ± 3.1% | 13.13 ± 3.4% | not timed | not timed | 677.50 ± 1.9% | | 1.00 | 2.07 | 51.44 |
| wild/caddy/caddy | 6 | 609.97 ± 6.2% | not timed | not timed | 343.12 ± 9.0% | 103.29 ± 9.8% | not timed | not timed | 606.07 ± 2.6% | | 1.01 | 1.78 | 5.91 |
| wild/dot-star-capture/rust-src-tools | 6 | 2053.69 ± 2.9% | not timed | not timed | 463.90 ± 0.6% | 22.63 ± 1.7% | not timed | not timed | 2033.84 ± 6.2% | | 1.01 | 4.43 | 90.74 |
| wild/ruff/noqa | 84 | 632.16 ± 2.8% | not timed | not timed | 661.48 ± 21.2% | 29.82 ± 2.4% | not timed | not timed | 639.61 ± 3.3% | | 0.99 | 0.96 | 21.20 |
| wild/ruff/unnecessary-coding-comment | 16 | 1291.91 ± 2.1% | not timed | not timed | 857.07 ± 5.9% | 189.42 ± 18.5% | not timed | not timed | 1294.32 ± 3.0% | | 1.00 | 1.51 | 6.82 |
| wild/ruff/string-quote-prefix | 2972 | 1976.75 ± 2.6% | not timed | not timed | 659.05 ± 5.7% | 501.40 ± 57.3% | not timed | not timed | 1974.69 ± 10.2% | | 1.00 | 3.00 | 3.94 |
| wild/ruff/space-around-operator | 1224378 | 291.50 ± 2.8% | not timed | not timed | 272.67 ± 4.8% | 25.26 ± 2.6% | not timed | not timed | 296.41 ± 2.9% | | 0.98 | 1.07 | 11.54 |
| wild/ruff/shebang | 282 | 1356.40 ± 2.5% | not timed | not timed | 509.68 ± 4.6% | 167.05 ± 19.8% | not timed | not timed | 1377.05 ± 4.0% | | 0.99 | 2.66 | 8.12 |
| wild/rustsec-cargo-audit/original-unix | 471 | 28224.31 ± 2.6% | not timed | not timed | 31124.10 ± 2.7% | 11671.98 ± 5.5% | not timed | not timed | 28278.39 ± 5.1% | | 1.00 | 0.91 | 2.42 |
| wild/rustsec-cargo-audit/original-windows | 462 | 25960.62 ± 4.5% | not timed | not timed | 28842.12 ± 1.1% | 10605.97 ± 1.1% | not timed | not timed | 25744.44 ± 5.0% | | 1.01 | 0.90 | 2.45 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 27962.80 ± 2.8% | not timed | not timed | 30286.47 ± 4.1% | 10874.99 ± 25.9% | not timed | not timed | 28238.86 ± 4.7% | | 0.99 | 0.92 | 2.57 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 24046.93 ± 38.0% | not timed | not timed | 30086.03 ± 16.9% | 11108.35 ± 21.9% | not timed | not timed | 24393.03 ± 1.9% | | 0.99 | 0.80 | 2.16 |
| wild/url/search | 234965 | 160.10 ± 7.2% | not timed | not timed | 75.77 ± 6.7% | 3.32 ± 2.9% | not timed | not timed | 161.61 ± 4.0% | | 0.99 | 2.11 | 48.25 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 19.8% | not timed | not timed | 0.01 ± 11.4% | 0.01 ± 17.5% | not timed | not timed | 0.04 ± 10.4% | | 0.99 | 3.02 | 5.29 |
| dictionary/compile/english-15 | 1 | 0.45 ± 10.3% | not timed | not timed | 0.10 ± 52.9% | 0.14 ± 20.4% | not timed | not timed | 0.44 ± 11.1% | | 1.01 | 4.55 | 3.23 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.40 ± 9.9% | not timed | not timed | 0.03 ± 1.7% | 42.59 ± 14.8% | not timed | not timed | 0.41 ± 7.5% | | 0.97 | 13.07 | 0.0094 |
| reported/i1095-word-repetition/ascii-compile | 1 | 54.07 ± 16.5% | not timed | not timed | 18.82 ± 2.5% | 72.97 ± 9.9% | not timed | not timed | 58.90 ± 5.4% | | 0.92 | 2.87 | 0.74 |
| reported/i787-keywords/compile | 1 | 52.21 ± 5.9% | not timed | not timed | 3.06 ± 1.5% | 23.56 ± 9.0% | not timed | not timed | 52.81 ± 3.8% | | 0.99 | 17.06 | 2.22 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 554.79 ± 14.6% | not timed | not timed | 181.05 ± 11.8% | 740.88 ± 139.5% | not timed | not timed | 579.02 ± 93.0% | | 0.96 | 3.06 | 0.75 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 72.02 ± 12.3% | not timed | not timed | 6.98 ± 3.4% | 60.08 ± 20.5% | not timed | not timed | 76.55 ± 12.1% | | 0.94 | 10.33 | 1.20 |
| unicode/compile/one-letter | 53 | 9.77 ± 9.8% | not timed | not timed | 7.44 ± 6.8% | 79.02 ± 25.9% | not timed | not timed | 9.71 ± 23.6% | | 1.01 | 1.31 | 0.12 |
| unicode/compile/fifty-letters | 1 | 1.77 ± 13.5% | not timed | not timed | 0.16 ± 5.1% | 74.23 ± 15.5% | not timed | not timed | 1.81 ± 10.1% | | 0.98 | 11.00 | 0.0239 |
| unicode/compile/fifty-letters-ascii | 1 | 286.77 ± 8.3% | not timed | not timed | 79.79 ± 1.3% | 237.44 ± 15.2% | not timed | not timed | 295.31 ± 2.0% | | 0.97 | 3.59 | 1.21 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 606.93 ± 9.3% | not timed | not timed | 58.74 ± 8.6% | 884.78 ± 1.0% | not timed | not timed | 615.81 ± 9.5% | | 0.99 | 10.33 | 0.69 |
| unicode/compile/match-every-line-ascii | 4 | 1039.77 ± 10.7% | not timed | not timed | 214.98 ± 2.5% | 873.42 ± 11.1% | not timed | not timed | 1049.72 ± 8.1% | | 0.99 | 4.84 | 1.19 |
| unicode/compile/negated-class-matches-codepoint | 1 | 502.23 ± 5.9% | not timed | not timed | 63.09 ± 0.9% | 1645.26 ± 9.8% | not timed | not timed | 531.07 ± 16.7% | | 0.95 | 7.96 | 0.31 |
| wild/bibleref/compile | 3 | 8.75 ± 5.0% | not timed | not timed | 3.08 ± 2.2% | 39.49 ± 9.3% | not timed | not timed | 8.71 ± 11.0% | | 1.01 | 2.84 | 0.22 |
| wild/url/compile | 1 | 0.96 ± 2.2% | not timed | not timed | 0.21 ± 6.2% | 0.53 ± 23.0% | not timed | not timed | 0.97 ± 3.2% | | 1.00 | 4.59 | 1.84 |

