# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391545218 |
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
| literal: a word | 217 | 62382.96 ± 2.5% | 6196.83 ± 1.9% | 44.63 ± 12.1% | 51157.07 ± 2.9% | 15674.18 ± 8.3% | 15.56 ± 6.3% | 153.80 ± 29.2% | 62265.91 ± 1.0% | 10.07 | 1.00 | 1.22 | 3.98 |
| literal: a word that is not there | 0 | 81230.38 ± 0.9% | 6033.17 ± 3.9% | 44.09 ± 5.8% | 62473.22 ± 2.4% | 54621.91 ± 8.3% | 15.05 ± 10.7% | 137.43 ± 2.9% | 81761.38 ± 3.2% | 13.46 | 0.99 | 1.30 | 1.49 |
| literal: one of four words | 661 | 19149.33 ± 4.6% | 2287.86 ± 5.2% | 23.54 ± 4.3% | 14210.33 ± 3.3% | 37.77 ± 1.4% | 5.04 ± 3.9% | 12.29 ± 9.8% | 19052.18 ± 4.2% | 8.37 | 1.01 | 1.35 | 507.07 |
| literal: a word in any case | 217 | 57977.84 ± 1.2% | 2504.74 ± 1.2% | 30.83 ± 4.3% | 14272.66 ± 2.5% | 71.59 ± 5.5% | refused | differs | 57752.06 ± 1.2% | 23.15 | 1.00 | 4.06 | 809.81 |
| literal: an href attribute | 33 | 50848.32 ± 3.4% | 718.24 ± 4.2% | 37.13 ± 3.5% | 44557.43 ± 1.5% | 3418.49 ± 2.2% | 10.88 ± 1.5% | 124.18 ± 6.9% | 50886.37 ± 2.1% | 70.80 | 1.00 | 1.14 | 14.87 |
| literal: a word, second text | 123 | 63832.59 ± 1.8% | 4406.73 ± 0.9% | 43.60 ± 3.7% | 48200.88 ± 3.0% | 14695.72 ± 3.8% | 20.92 ± 3.6% | 122.55 ± 3.3% | 64146.82 ± 2.5% | 14.49 | 1.00 | 1.32 | 4.34 |
| class: two capitalized words | 1331 | 1127.23 ± 5.5% | 738.75 ± 1.3% | 40.61 ± 5.9% | 704.48 ± 1.9% | 60.35 ± 3.0% | 13.71 ± 2.8% | 105.70 ± 4.7% | 1101.52 ± 2.7% | 1.53 | 1.02 | 1.60 | 18.68 |
| class: a word that ends in ing | 3399 | 702.55 ± 1.0% | 711.89 ± 0.6% | 27.13 ± 2.2% | 663.08 ± 1.3% | 45.29 ± 20.0% | 7.90 ± 3.9% | 29.29 ± 3.9% | 712.06 ± 2.1% | 0.99 | 0.99 | 1.06 | 15.51 |
| class: a word in capitals | 2332 | 1564.02 ± 0.4% | 738.11 ± 1.0% | 42.30 ± 0.9% | 692.97 ± 1.9% | 65.40 ± 13.7% | 16.69 ± 1.9% | 132.75 ± 1.2% | 1583.80 ± 4.1% | 2.12 | 0.99 | 2.26 | 23.91 |
| class: a number | 8288 | 2701.95 ± 7.0% | 1002.72 ± 5.4% | 45.09 ± 14.6% | 2403.68 ± 3.1% | 62.70 ± 13.1% | 0.46 ± 0.7% | 97.11 ± 40.3% | 2723.83 ± 1.7% | 2.69 | 0.99 | 1.12 | 43.09 |
| class: two capitalized words, second text | 5359 | 631.60 ± 0.8% | 642.33 ± 4.6% | 37.87 ± 6.6% | 600.76 ± 0.4% | 51.40 ± 20.9% | 18.90 ± 1.9% | 99.64 ± 1.3% | 631.96 ± 1.4% | 0.98 | 1.00 | 1.05 | 12.29 |
| other: a word between two words | 6104 | 1138.46 ± 0.8% | 726.21 ± 0.2% | 36.85 ± 1.0% | 996.51 ± 2.1% | 170.43 ± 5.9% | 10.68 ± 0.4% | 115.13 ± 2.7% | 1140.18 ± 1.8% | 1.57 | 1.00 | 1.14 | 6.68 |
| other: a number before a unit, second text | 1481 | 13465.23 ± 1.3% | 1471.43 ± 0.8% | 42.00 ± 1.6% | 11441.76 ± 0.8% | 63.31 ± 10.4% | 19.52 ± 3.6% | 109.58 ± 0.9% | 13407.46 ± 2.7% | 9.15 | 1.00 | 1.18 | 212.69 |
| other: a heading's start tag | 110 | 32306.50 ± 5.3% | 919.21 ± 3.1% | 43.15 ± 7.1% | 3462.84 ± 5.4% | 2608.22 ± 5.8% | 14.38 ± 4.2% | 159.44 ± 31.3% | 32363.61 ± 5.2% | 35.15 | 1.00 | 9.33 | 12.39 |
| other: a whole word | 217 | 39276.17 ± 5.8% | 733.01 ± 4.3% | 46.16 ± 4.1% | 37773.42 ± 4.8% | 71.87 ± 22.3% | 13.60 ± 4.5% | 86.88 ± 4.4% | 39009.80 ± 2.6% | 53.58 | 1.01 | 1.04 | 546.50 |
| other: a line's first word, second text | 3716 | 3583.47 ± 6.1% | 725.90 ± 0.7% | 50.56 ± 3.6% | 3644.31 ± 5.8% | 104.50 ± 4.8% | refused | refused | 3569.97 ± 7.8% | 4.94 | 1.00 | 0.98 | 34.29 |
| other: fourteen octets before an x | 87 | 53265.06 ± 0.3% | 368.63 ± 0.7% | 9.54 ± 0.4% | 5386.34 ± 0.3% | 15.14 ± 8.7% | differs | 26.48 ± 4.4% | 53379.45 ± 4.7% | 144.50 | 1.00 | 9.89 | 3517.94 |
| other: a Greek word | 21815 | 614.35 ± 0.2% | 497.71 ± 2.3% | 49.82 ± 11.0% | 377.95 ± 0.4% | 62.67 ± 18.6% | differs | refused | 625.39 ± 3.1% | 1.23 | 0.98 | 1.63 | 9.80 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.24 ± 5.0% | 28.27 ± 0.3% | 1.60 ± 0.7% | 25.05 ± 0.2% | 3.47 ± 3.5% | differs | 6.02 ± 1.9% | 28.26 ± 0.4% | 1.00 | 1.00 | 1.13 | 8.13 |
| a UUID | 32895 | 31.00 ± 0.8% | 31.04 ± 1.1% | 1.05 ± 5.0% | 19.08 ± 6.6% | 3.68 ± 7.5% | 0.76 ± 2.0% | 4.76 ± 2.8% | 30.98 ± 0.7% | 1.00 | 1.00 | 1.62 | 8.42 |
| an IPv4 address | 33176 | 48.74 ± 1.3% | 48.57 ± 3.7% | 3.39 ± 1.5% | 36.41 ± 0.4% | 9.51 ± 2.0% | differs | 6.05 ± 1.0% | 48.55 ± 0.8% | 1.00 | 1.00 | 1.34 | 5.12 |
| a date and time | 32954 | 45.91 ± 2.0% | 45.59 ± 2.2% | 2.54 ± 1.8% | 27.35 ± 0.4% | 11.32 ± 2.4% | 1.36 ± 1.1% | 11.38 ± 21.9% | 44.70 ± 1.2% | 1.01 | 1.03 | 1.68 | 4.06 |
| a field path | 32606 | 31.95 ± 1.9% | 32.05 ± 2.1% | 1.74 ± 8.5% | 28.97 ± 0.7% | 4.90 ± 3.3% | differs | 4.36 ± 1.2% | 32.14 ± 1.0% | 1.00 | 0.99 | 1.10 | 6.52 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 16.18 ± 0.2% | 15.66 ± 2.9% | 16.36 ± 0.6% | 17.14 ± 0.4% | 7.82 ± 2.9% | 1.11 ± 0.3% | none | 16.20 ± 0.2% | 1.03 | 1.00 | 0.94 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 377.28 ± 1.7% | 377.26 ± 6.2% | 446.13 ± 3.2% | 140.58 ± 2.0% | 350.06 ± 0.6% | 929.61 ± 2.0% | 6067.03 ± 1.2% | 374.36 ± 4.9% | 1.00 | 1.01 | 2.68 | 1.08 |
| a UUID | 62 | 247.91 ± 3.6% | 244.81 ± 5.0% | 273.53 ± 8.6% | 75.73 ± 7.3% | 163.17 ± 4.7% | 317.17 ± 4.0% | 7305.82 ± 2.5% | 239.31 ± 25.9% | 1.01 | 1.04 | 3.27 | 1.52 |
| an IPv4 address | 29 | 713.75 ± 5.5% | 738.37 ± 5.8% | 1004.03 ± 4.4% | 124.82 ± 3.4% | 213.15 ± 3.3% | 597.08 ± 1.9% | 13102.75 ± 11.0% | 736.04 ± 5.8% | 0.97 | 0.97 | 5.72 | 3.35 |
| a date and time | 56 | 523.94 ± 1.4% | 530.86 ± 3.8% | 634.50 ± 6.2% | 118.66 ± 2.2% | 234.30 ± 8.9% | 600.11 ± 2.9% | 8451.87 ± 11.4% | 522.49 ± 6.9% | 0.99 | 1.00 | 4.42 | 2.24 |
| a field path | 39 | 376.44 ± 29.4% | 375.06 ± 19.0% | 443.50 ± 38.4% | 131.58 ± 13.5% | 319.62 ± 7.6% | 935.69 ± 2.9% | 7757.85 ± 4.2% | 381.46 ± 0.9% | 1.00 | 0.99 | 2.86 | 1.18 |
| literal: a word | 7 | 1110.46 ± 5.5% | 1228.60 ± 5.2% | 2123.43 ± 3.4% | 853.47 ± 17.2% | 1077.54 ± 5.4% | 1857.88 ± 5.7% | 49194.29 ± 4.8% | 1130.98 ± 2.4% | 0.90 | 0.98 | 1.30 | 1.03 |
| literal: a word that is not there | 8 | 1076.19 ± 18.5% | 1172.71 ± 32.0% | 1961.74 ± 5.1% | 805.62 ± 2.1% | 1037.54 ± 3.0% | 1804.39 ± 4.0% | 48348.99 ± 2.1% | 1080.49 ± 4.5% | 0.92 | 1.00 | 1.34 | 1.04 |
| literal: one of four words | 26 | 426.36 ± 2.0% | 671.45 ± 4.7% | 870.32 ± 2.7% | 70.16 ± 3.9% | 405.79 ± 2.4% | 694.98 ± 3.7% | 24977.41 ± 1.3% | 427.29 ± 2.1% | 0.63 | 1.00 | 6.08 | 1.05 |
| literal: a word in any case | 11 | 783.16 ± 26.5% | 837.53 ± 4.3% | 1178.72 ± 6.3% | 23.81 ± 2.9% | 1146.45 ± 3.7% | refused | 39271.39 ± 2.5% | 774.58 ± 4.3% | 0.94 | 1.01 | 32.89 | 0.68 |
| literal: an href attribute | 12 | 589.27 ± 5.3% | 618.59 ± 5.1% | 785.17 ± 6.0% | 62.79 ± 3.7% | 765.56 ± 8.0% | 1523.19 ± 3.9% | 34853.27 ± 18.0% | 589.06 ± 4.2% | 0.95 | 1.00 | 9.38 | 0.77 |
| literal: a word, second text | 10 | 994.40 ± 7.3% | 1093.10 ± 5.0% | 1749.17 ± 2.6% | 738.47 ± 7.3% | 907.05 ± 2.6% | 1607.98 ± 1.2% | 46965.21 ± 4.9% | 990.16 ± 1.4% | 0.91 | 1.00 | 1.35 | 1.10 |
| class: two capitalized words | 23 | 795.96 ± 5.4% | 854.09 ± 4.5% | 1186.39 ± 4.3% | 158.88 ± 5.6% | 825.43 ± 7.7% | 1497.82 ± 5.1% | 9976.07 ± 6.9% | 788.24 ± 5.1% | 0.93 | 1.01 | 5.01 | 0.96 |
| class: a word that ends in ing | 9 | 967.17 ± 4.7% | 1119.67 ± 4.8% | 1874.03 ± 5.8% | 213.79 ± 4.9% | 1143.18 ± 5.8% | 2197.03 ± 5.1% | 25256.64 ± 3.1% | 971.30 ± 5.5% | 0.86 | 1.00 | 4.52 | 0.85 |
| class: a word in capitals | 16 | 891.62 ± 1.2% | 974.31 ± 1.5% | 1511.66 ± 2.5% | 217.63 ± 2.6% | 1246.86 ± 2.2% | 2138.46 ± 1.0% | 13030.25 ± 0.3% | 891.66 ± 2.0% | 0.92 | 1.00 | 4.10 | 0.72 |
| class: a number | 6 | 1110.84 ± 2.2% | 1245.95 ± 2.4% | 2225.89 ± 1.6% | 61.98 ± 2.2% | 2245.05 ± 1.8% | 3912.85 ± 2.2% | 37957.34 ± 0.4% | 1111.40 ± 2.0% | 0.89 | 1.00 | 17.92 | 0.49 |
| class: two capitalized words, second text | 23 | 797.75 ± 1.3% | 863.57 ± 5.2% | 1216.97 ± 29.8% | 163.94 ± 1.0% | 836.58 ± 7.9% | 1545.35 ± 0.6% | 10009.43 ± 0.4% | 794.19 ± 2.2% | 0.92 | 1.00 | 4.87 | 0.95 |
| other: a word between two words | 13 | 930.05 ± 5.7% | 977.76 ± 5.3% | 1547.78 ± 6.3% | 218.13 ± 4.0% | 811.34 ± 4.7% | 1572.25 ± 12.6% | 23382.81 ± 4.4% | 954.47 ± 4.9% | 0.95 | 0.97 | 4.26 | 1.15 |
| other: a number before a unit, second text | 15 | 692.04 ± 2.2% | 778.05 ± 2.3% | 1077.80 ± 1.2% | 59.11 ± 0.9% | 1009.16 ± 0.6% | 1798.52 ± 3.9% | 25630.68 ± 0.5% | 690.27 ± 3.7% | 0.89 | 1.00 | 11.71 | 0.69 |
| other: a heading's start tag | 13 | 600.59 ± 5.7% | 619.46 ± 5.2% | 821.63 ± 2.6% | 61.53 ± 6.3% | 954.48 ± 9.6% | 1727.19 ± 4.2% | 29314.65 ± 4.1% | 610.64 ± 5.9% | 0.97 | 0.98 | 9.76 | 0.63 |
| other: a whole word | 11 | 967.05 ± 7.1% | 1075.04 ± 5.5% | 1702.89 ± 4.5% | 198.87 ± 1.1% | 935.87 ± 13.9% | 1675.72 ± 4.5% | 43331.42 ± 10.9% | 1001.16 ± 5.1% | 0.90 | 0.97 | 4.86 | 1.03 |
| other: a line's first word, second text | 17 | 943.67 ± 2.4% | 993.44 ± 1.2% | 1561.15 ± 4.2% | 209.27 ± 5.8% | 1051.38 ± 12.0% | refused | refused | 923.11 ± 6.1% | 0.95 | 1.02 | 4.51 | 0.90 |
| other: fourteen octets before an x | 16 | 187.20 ± 3.5% | 251.02 ± 8.8% | 292.05 ± 4.6% | 23.21 ± 17.3% | 711.48 ± 3.8% | 800.90 ± 23.8% | 20967.02 ± 5.0% | 183.21 ± 41.9% | 0.75 | 1.02 | 8.07 | 0.26 |
| other: a Greek word | 8 | 726.14 ± 2.8% | 989.44 ± 4.5% | 1550.80 ± 12.6% | 77.69 ± 5.4% | 2179.61 ± 5.3% | 3607.90 ± 2.6% | refused | 732.63 ± 2.1% | 0.73 | 0.99 | 9.35 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 46928.67 ± 3.5% | not timed | not timed | 46263.21 ± 8.3% | 3392.84 ± 22.2% | not timed | not timed | 47176.16 ± 1.9% | | 0.99 | 1.01 | 13.83 |
| 01-literal/sherlock-casei-en | 522 | 40820.47 ± 5.5% | not timed | not timed | 11729.73 ± 3.7% | 53.74 ± 3.5% | not timed | not timed | 40806.80 ± 6.6% | | 1.00 | 3.48 | 759.53 |
| 01-literal/sherlock-ru | 724 | 47276.37 ± 2.9% | not timed | not timed | 44522.43 ± 4.3% | 2365.48 ± 10.8% | not timed | not timed | 47263.10 ± 6.6% | | 1.00 | 1.06 | 19.99 |
| 01-literal/sherlock-casei-ru | 746 | 15360.44 ± 2.8% | not timed | not timed | 9733.51 ± 0.4% | 57.90 ± 6.8% | not timed | not timed | 15419.19 ± 2.1% | | 1.00 | 1.58 | 265.29 |
| 01-literal/sherlock-zh | 30 | 84714.92 ± 1.4% | not timed | not timed | 61685.81 ± 0.4% | 2178.70 ± 1.9% | not timed | not timed | 84138.25 ± 2.8% | | 1.01 | 1.37 | 38.88 |
| 02-literal-alternate/sherlock-en | 714 | 17202.79 ± 3.5% | not timed | not timed | 13963.11 ± 2.7% | 28.82 ± 3.3% | not timed | not timed | 17204.15 ± 8.9% | | 1.00 | 1.23 | 596.86 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3104.68 ± 5.7% | not timed | not timed | 3049.19 ± 3.4% | 18.70 ± 1.1% | not timed | not timed | 3093.25 ± 6.2% | | 1.00 | 1.02 | 166.04 |
| 02-literal-alternate/sherlock-ru | 899 | 13016.65 ± 0.8% | not timed | not timed | 7598.28 ± 5.8% | 37.78 ± 3.7% | not timed | not timed | 13024.48 ± 1.1% | | 1.00 | 1.71 | 344.53 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2812.88 ± 3.5% | not timed | not timed | 1480.95 ± 0.5% | 16.45 ± 5.1% | not timed | not timed | 2823.44 ± 4.3% | | 1.00 | 1.90 | 171.02 |
| 02-literal-alternate/sherlock-zh | 207 | 25049.05 ± 0.4% | not timed | not timed | 16403.31 ± 4.4% | 54.47 ± 13.7% | not timed | not timed | 24939.72 ± 1.1% | | 1.00 | 1.53 | 459.86 |
| 03-date/ascii | 111817 | 156.87 ± 1.2% | not timed | not timed | 123.03 ± 3.6% | 0.31 ± 1.6% | not timed | not timed | 153.21 ± 0.7% | | 1.02 | 1.28 | 503.66 |
| 04-ruff-noqa/real | 84 | 689.17 ± 3.0% | not timed | not timed | 704.67 ± 3.5% | 31.31 ± 5.8% | not timed | not timed | 671.08 ± 15.4% | | 1.03 | 0.98 | 22.01 |
| 04-ruff-noqa/tweaked | 44 | 878.26 ± 4.3% | not timed | not timed | 722.92 ± 4.7% | 493.99 ± 15.3% | not timed | not timed | 875.49 ± 4.7% | | 1.00 | 1.21 | 1.78 |
| 05-lexer-veryl/single | 124800 | 6.97 ± 11.4% | not timed | not timed | 7.99 ± 3.7% | 0.36 ± 14.4% | not timed | not timed | 6.83 ± 10.9% | | 1.02 | 0.87 | 19.21 |
| 06-cloud-flare-redos/original | 107 | 554.90 ± 1.2% | not timed | not timed | 296.01 ± 12.5% | 40.65 ± 1.7% | not timed | not timed | 540.62 ± 1.8% | | 1.03 | 1.87 | 13.65 |
| 06-cloud-flare-redos/simplified-short | 102 | 554.50 ± 0.3% | not timed | not timed | 312.04 ± 0.6% | 43.88 ± 13.5% | not timed | not timed | 548.86 ± 0.1% | | 1.01 | 1.78 | 12.64 |
| 06-cloud-flare-redos/simplified-long | 10000 | 677.80 ± 2.2% | not timed | not timed | 335.32 ± 1.3% | 47.62 ± 1.1% | not timed | not timed | 675.58 ± 2.6% | | 1.00 | 2.02 | 14.23 |
| 07-unicode-character-data/parse-line | 558784 | 340.78 ± 4.2% | not timed | not timed | 259.99 ± 6.1% | 67.36 ± 11.1% | not timed | not timed | 348.35 ± 9.6% | | 0.98 | 1.31 | 5.06 |
| 08-words/all-english | 56691 | 134.17 ± 4.6% | not timed | not timed | 103.34 ± 3.1% | 19.48 ± 15.7% | not timed | not timed | 130.97 ± 2.1% | | 1.02 | 1.30 | 6.89 |
| 08-words/long-english | 839 | 642.15 ± 60.3% | not timed | not timed | 592.27 ± 20.6% | 31.68 ± 28.0% | not timed | not timed | 618.51 ± 64.6% | | 1.04 | 1.08 | 20.27 |
| 09-aws-keys/full | 0 | 704.84 ± 4.3% | not timed | not timed | 738.83 ± 3.5% | 100.49 ± 4.6% | not timed | not timed | 682.57 ± 3.5% | | 1.03 | 0.95 | 7.01 |
| 09-aws-keys/quick | 0 | 1534.34 ± 1.0% | not timed | not timed | 1286.27 ± 2.2% | 572.64 ± 6.2% | not timed | not timed | 1539.90 ± 3.4% | | 1.00 | 1.19 | 2.68 |
| 10-bounded-repeat/letters-en | 1833 | 872.79 ± 0.6% | not timed | not timed | 766.27 ± 0.6% | 30.77 ± 1.5% | not timed | not timed | 868.63 ± 0.4% | | 1.00 | 1.14 | 28.36 |
| 10-bounded-repeat/letters-ru | 3475 | 740.25 ± 0.5% | not timed | not timed | 672.15 ± 1.0% | 29.48 ± 3.6% | not timed | not timed | 738.15 ± 2.0% | | 1.00 | 1.10 | 25.11 |
| 10-bounded-repeat/context | 53 | 122.78 ± 2.7% | not timed | not timed | 94.98 ± 2.2% | 30.44 ± 2.9% | not timed | not timed | 123.60 ± 0.9% | | 0.99 | 1.29 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 789.90 ± 8.2% | not timed | not timed | 745.52 ± 24.5% | 54.35 ± 6.5% | not timed | not timed | 788.51 ± 4.7% | | 1.00 | 1.06 | 14.53 |
| 11-unstructured-to-json/extract | 600 | 78.19 ± 6.8% | not timed | not timed | 107.20 ± 5.4% | 76.86 ± 5.2% | not timed | not timed | 77.66 ± 5.7% | | 1.01 | 0.73 | 1.02 |
| 12-dictionary/single | 1 | 675.49 ± 11.6% | not timed | not timed | 648.00 ± 0.3% | 0.68 ± 2.2% | not timed | not timed | 675.63 ± 0.4% | | 1.00 | 1.04 | 992.55 |
| 14-quadratic/1x | 100 | 40.74 ± 2.9% | not timed | not timed | 17.79 ± 1.4% | 1.47 ± 8.7% | not timed | not timed | 41.60 ± 2.0% | | 0.98 | 2.29 | 27.74 |
| 14-quadratic/2x | 200 | 32.10 ± 4.1% | not timed | not timed | 8.30 ± 2.5% | 0.82 ± 1.5% | not timed | not timed | 32.95 ± 5.8% | | 0.97 | 3.87 | 39.24 |
| 14-quadratic/10x | 1000 | 11.22 ± 2.3% | not timed | not timed | 1.53 ± 0.2% | 0.18 ± 1.1% | not timed | not timed | 11.32 ± 0.4% | | 0.99 | 7.34 | 62.09 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.05 ± 0.6% | not timed | not timed | 0.56 ± 0.4% | 0.88 ± 2.6% | not timed | not timed | 2.05 ± 0.4% | | 1.00 | 3.65 | 2.33 |
| 04-ruff-noqa/compile-real | 1 | 186.96 ± 12.3% | not timed | not timed | 22.17 ± 5.0% | 228.84 ± 13.2% | not timed | not timed | 187.58 ± 36.1% | | 1.00 | 8.43 | 0.82 |
| 05-lexer-veryl/compile-single | 1 | 23.74 ± 6.1% | not timed | not timed | 4.04 ± 3.8% | 11.31 ± 2.6% | not timed | not timed | 23.90 ± 1.8% | | 0.99 | 5.88 | 2.10 |
| 07-unicode-character-data/compile | 1 | 186.83 ± 2.2% | not timed | not timed | 42.07 ± 3.2% | 62.03 ± 5.0% | not timed | not timed | 186.65 ± 12.8% | | 1.00 | 4.44 | 3.01 |
| 09-aws-keys/compile-full | 1 | 78.74 ± 5.9% | not timed | not timed | 13.06 ± 13.9% | 38.51 ± 101.4% | not timed | not timed | 78.81 ± 7.9% | | 1.00 | 6.03 | 2.04 |
| 09-aws-keys/compile-quick | 1 | 296.48 ± 3.4% | not timed | not timed | 80.26 ± 1.8% | 222.33 ± 1.9% | not timed | not timed | 295.71 ± 5.2% | | 1.00 | 3.69 | 1.33 |
| 10-bounded-repeat/compile-context | 1 | 89.42 ± 2.5% | not timed | not timed | 18.06 ± 19.0% | 27.70 ± 1.4% | not timed | not timed | 89.81 ± 0.3% | | 1.00 | 4.95 | 3.23 |
| 10-bounded-repeat/compile-capitals | 1 | 135.07 ± 1.6% | not timed | not timed | 13.25 ± 0.9% | 39.90 ± 2.7% | not timed | not timed | 135.98 ± 1.3% | | 0.99 | 10.19 | 3.39 |
| 11-unstructured-to-json/compile | 1 | 293.83 ± 1.4% | not timed | not timed | 66.71 ± 1.5% | 116.16 ± 2.2% | not timed | not timed | 289.87 ± 8.4% | | 1.01 | 4.40 | 2.53 |
| 12-dictionary/compile-single | 1 | 0.47 ± 11.1% | not timed | not timed | 0.10 ± 3.9% | 0.13 ± 19.0% | not timed | not timed | 0.47 ± 10.8% | | 1.00 | 4.74 | 3.58 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 11.12 ± 8.0% | not timed | not timed | 10.23 ± 3.7% | 0.90 ± 29.6% | not timed | not timed | 11.28 ± 33.7% | | 0.99 | 1.09 | 12.40 |
| dictionary/search/english-10 | 690 | 1.87 ± 3.2% | not timed | not timed | 226.93 ± 6.6% | 0.01 ± 5.5% | not timed | not timed | 1.81 ± 6.1% | | 1.03 | 0.0082 | 182.45 |
| dictionary/search/english-15 | 15 | 672.74 ± 2.2% | not timed | not timed | 643.07 ± 0.5% | 0.59 ± 5.7% | not timed | not timed | 674.91 ± 1.4% | | 1.00 | 1.05 | 1137.67 |
| folly/awyer-inn-busted | 1 | 7243.00 ± 1.7% | not timed | not timed | 171.90 ± 0.2% | 72.11 ± 21.8% | not timed | not timed | 7244.69 ± 0.6% | | 1.00 | 42.14 | 100.44 |
| folly/literal-never-match-rare | 0 | 84867.63 ± 2.7% | not timed | not timed | 66620.80 ± 2.3% | 89312.04 ± 1.7% | not timed | not timed | 84854.62 ± 0.4% | | 1.00 | 1.27 | 0.95 |
| folly/literal-never-match-frequent | 0 | 39472.74 ± 11.1% | not timed | not timed | 67170.66 ± 8.7% | 3055.43 ± 45.9% | not timed | not timed | 40038.51 ± 46.3% | | 0.99 | 0.59 | 12.92 |
| folly/literal-never-match-tricksy | 1 | 5635.43 ± 6.0% | not timed | not timed | 8819.07 ± 24.9% | 3895.56 ± 2.8% | not timed | not timed | 5590.97 ± 3.9% | | 1.01 | 0.64 | 1.45 |
| grep/every-line | 239963 | 1873.83 ± 2.0% | not timed | not timed | 1340.01 ± 1.1% | 521.96 ± 11.7% | not timed | not timed | 1870.44 ± 2.4% | | 1.00 | 1.40 | 3.59 |
| grep/long-words-ascii | 5073 | 684.15 ± 6.0% | not timed | not timed | 634.47 ± 3.2% | 69.32 ± 7.6% | not timed | not timed | 680.07 ± 0.9% | | 1.01 | 1.08 | 9.87 |
| imported/leipzig/twain | 811 | 73446.37 ± 3.3% | not timed | not timed | 60979.19 ± 2.0% | 15626.46 ± 7.7% | not timed | not timed | 73725.80 ± 3.1% | | 1.00 | 1.20 | 4.70 |
| imported/leipzig/twain-insensitive | 965 | 19916.27 ± 1.3% | not timed | not timed | 17417.81 ± 5.0% | 66.48 ± 1.9% | not timed | not timed | 19627.29 ± 6.4% | | 1.01 | 1.14 | 299.57 |
| imported/leipzig/shing | 1540 | 774.16 ± 1.0% | not timed | not timed | 28942.96 ± 6.7% | 52.41 ± 4.5% | not timed | not timed | 747.19 ± 4.8% | | 1.04 | 0.0267 | 14.77 |
| imported/leipzig/huck-saw | 262 | 34728.82 ± 4.4% | not timed | not timed | 24392.07 ± 4.9% | 53.33 ± 11.4% | not timed | not timed | 34303.68 ± 3.0% | | 1.01 | 1.42 | 651.20 |
| imported/leipzig/word-ending-nn | 262 | 744.17 ± 1.8% | not timed | not timed | 748.95 ± 1.4% | 37.97 ± 5.8% | not timed | not timed | 747.14 ± 12.5% | | 1.00 | 0.99 | 19.60 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 14827.35 ± 6.2% | not timed | not timed | 5502.50 ± 6.2% | 14.91 ± 2.8% | not timed | not timed | 14884.11 ± 6.4% | | 1.00 | 2.69 | 994.75 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 28296.28 ± 5.5% | not timed | not timed | 22720.37 ± 53.0% | 28.58 ± 7.3% | not timed | not timed | 27301.66 ± 20.9% | | 1.04 | 1.25 | 990.12 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6782.21 ± 4.6% | not timed | not timed | 1200.07 ± 1.2% | 17.64 ± 3.7% | not timed | not timed | 6801.41 ± 4.2% | | 1.00 | 5.65 | 384.52 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 748.04 ± 1.0% | not timed | not timed | 748.28 ± 0.4% | 11.11 ± 2.3% | not timed | not timed | 748.30 ± 3.5% | | 1.00 | 1.00 | 67.31 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 742.80 ± 4.0% | not timed | not timed | 731.82 ± 3.8% | 9.89 ± 4.3% | not timed | not timed | 738.54 ± 1.8% | | 1.01 | 1.02 | 75.08 |
| imported/leipzig/tom-river | 2 | 16060.56 ± 1.9% | not timed | not timed | 17000.48 ± 2.8% | 51.36 ± 2.2% | not timed | not timed | 16104.61 ± 2.6% | | 1.00 | 0.94 | 312.70 |
| imported/leipzig/ing | 78424 | 698.46 ± 1.5% | not timed | not timed | 655.28 ± 0.8% | 40.93 ± 9.5% | not timed | not timed | 696.67 ± 4.5% | | 1.00 | 1.07 | 17.06 |
| imported/leipzig/ing-whitespace | 55248 | 920.26 ± 1.0% | not timed | not timed | 2943.71 ± 4.7% | 29.69 ± 7.4% | not timed | not timed | 923.78 ± 0.2% | | 1.00 | 0.31 | 30.99 |
| imported/leipzig/awyer-inn | 209 | 948.24 ± 4.4% | not timed | not timed | 18229.00 ± 1.3% | 32.99 ± 2.3% | not timed | not timed | 948.88 ± 1.9% | | 1.00 | 0.0520 | 28.74 |
| imported/leipzig/quotes-bounded | 8886 | 2600.12 ± 0.5% | not timed | not timed | 4083.42 ± 0.6% | 60.81 ± 3.3% | not timed | not timed | 2593.30 ± 1.5% | | 1.00 | 0.64 | 42.76 |
| imported/leipzig/non-ascii-alternate | 2 | 64017.46 ± 4.9% | not timed | not timed | 25737.33 ± 0.6% | 87.44 ± 6.1% | not timed | not timed | 64333.03 ± 3.6% | | 1.00 | 2.49 | 732.10 |
| imported/leipzig/math-symbols | 69 | 4455.66 ± 112.1% | not timed | not timed | 749.68 ± 1.3% | 57.49 ± 6.8% | not timed | not timed | 4464.40 ± 0.6% | | 1.00 | 5.94 | 77.51 |
| imported/leipzig/bounded-strings-ending-z | 0 | 712.17 ± 5.1% | not timed | not timed | 715.47 ± 5.0% | 25.18 ± 4.3% | not timed | not timed | 712.63 ± 5.8% | | 1.00 | 1.00 | 28.28 |
| imported/lh3lh3-reb/uri | 17549 | 944.49 ± 10.0% | not timed | not timed | 1555.39 ± 5.0% | 40.21 ± 2.3% | not timed | not timed | 914.93 ± 1.9% | | 1.03 | 0.61 | 23.49 |
| imported/lh3lh3-reb/email | 15057 | 1038.52 ± 5.4% | not timed | not timed | 1528.47 ± 4.4% | 44.60 ± 7.3% | not timed | not timed | 1010.64 ± 6.7% | | 1.03 | 0.68 | 23.28 |
| imported/lh3lh3-reb/date | 668 | 1176.34 ± 4.0% | not timed | not timed | 1326.78 ± 10.8% | 73.55 ± 14.9% | not timed | not timed | 1181.87 ± 2.4% | | 1.00 | 0.89 | 15.99 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 973.12 ± 18.8% | not timed | not timed | 561.75 ± 40.5% | 23.18 ± 2.4% | not timed | not timed | 938.80 ± 3.1% | | 1.04 | 1.73 | 41.97 |
| imported/mariomka/email | 92 | 854.45 ± 4.3% | not timed | not timed | 71339.26 ± 3.9% | 49.80 ± 2.8% | not timed | not timed | 847.02 ± 4.6% | | 1.01 | 0.0120 | 17.16 |
| imported/mariomka/uri | 5301 | 743.32 ± 5.0% | not timed | not timed | 9256.10 ± 5.7% | 51.98 ± 5.7% | not timed | not timed | 741.76 ± 4.6% | | 1.00 | 0.0803 | 14.30 |
| imported/mariomka/ip | 5 | 2412.59 ± 3.6% | not timed | not timed | 2950.95 ± 5.0% | 34.01 ± 6.1% | not timed | not timed | 2446.84 ± 2.1% | | 0.99 | 0.82 | 70.93 |
| imported/rsc/no-exponential | 0 | 1141.30 ± 6.2% | not timed | not timed | 748.55 ± 4.1% | 33.63 ± 6.3% | not timed | not timed | 1015.64 ± 5.9% | | 1.12 | 1.52 | 33.94 |
| imported/rsc/literal | 1 | 1396.84 ± 8.7% | not timed | not timed | 3050.47 ± 1.1% | 333.90 ± 17.4% | not timed | not timed | 1418.36 ± 3.3% | | 0.98 | 0.46 | 4.18 |
| imported/rsc/not-literal | 2 | 1262.61 ± 19.7% | not timed | not timed | 1374.90 ± 17.7% | 72.62 ± 16.3% | not timed | not timed | 1133.12 ± 22.9% | | 1.11 | 0.92 | 17.39 |
| imported/rsc/match-class | 1 | 1910.96 ± 4.9% | not timed | not timed | 2726.23 ± 1.1% | 84.92 ± 5.2% | not timed | not timed | 1908.26 ± 1.5% | | 1.00 | 0.70 | 22.50 |
| imported/rsc/match-class-in-range | 1 | 1940.29 ± 5.7% | not timed | not timed | 4138.31 ± 2.3% | 86.66 ± 4.7% | not timed | not timed | 1922.29 ± 3.5% | | 1.01 | 0.47 | 22.39 |
| imported/rsc/match-class-unicode | 1 | 576.42 ± 1.7% | not timed | not timed | 570.55 ± 1.5% | 101.70 ± 8.5% | not timed | not timed | 570.25 ± 0.5% | | 1.01 | 1.01 | 5.67 |
| imported/rsc/anchored-literal-short-non-match | 0 | 797.24 ± 5.9% | not timed | not timed | 1508.97 ± 1.2% | 390.88 ± 1.6% | not timed | not timed | 774.74 ± 5.4% | | 1.03 | 0.53 | 2.04 |
| imported/rsc/anchored-literal-long-non-match | 0 | 13144.95 ± 0.7% | not timed | not timed | 22629.05 ± 0.9% | 5914.83 ± 5.8% | not timed | not timed | 13170.37 ± 1.2% | | 1.00 | 0.58 | 2.22 |
| imported/rsc/anchored-literal-short-match | 4 | 613.38 ± 15.1% | not timed | not timed | 915.33 ± 18.1% | 140.83 ± 17.2% | not timed | not timed | 610.99 ± 17.3% | | 1.00 | 0.67 | 4.36 |
| imported/rsc/anchored-literal-long-match | 4 | 4040.19 ± 9.6% | not timed | not timed | 13258.11 ± 2.0% | 2044.03 ± 6.6% | not timed | not timed | 3990.59 ± 2.1% | | 1.01 | 0.30 | 1.98 |
| imported/rsc/one-pass-short | 17 | 490.14 ± 10.4% | not timed | not timed | 411.81 ± 47.1% | 46.99 ± 14.3% | not timed | not timed | 460.14 ± 9.4% | | 1.07 | 1.19 | 10.43 |
| imported/rsc/one-pass-short-not | 17 | 364.12 ± 23.9% | not timed | not timed | 485.24 ± 0.7% | 47.92 ± 4.0% | not timed | not timed | 366.55 ± 1.2% | | 0.99 | 0.75 | 7.60 |
| imported/rsc/one-pass-long-prefix | 26 | 371.20 ± 2.4% | not timed | not timed | 527.22 ± 1.3% | 190.75 ± 14.5% | not timed | not timed | 378.04 ± 2.2% | | 0.98 | 0.70 | 1.95 |
| imported/rsc/one-pass-long-prefix-not | 26 | 489.66 ± 3.2% | not timed | not timed | 491.92 ± 0.7% | 113.74 ± 13.2% | not timed | not timed | 495.34 ± 3.1% | | 0.99 | 1.00 | 4.30 |
| imported/rsc/long-needle1 | 31 | 91403.36 ± 1.5% | not timed | not timed | 69495.38 ± 4.1% | 6.26 ± 1.3% | not timed | not timed | 91540.87 ± 1.2% | | 1.00 | 1.32 | 14605.39 |
| imported/rsc/long-needle2 | 31 | 91233.43 ± 2.5% | not timed | not timed | 377.73 ± 1.2% | 6.24 ± 1.8% | not timed | not timed | 90995.81 ± 2.2% | | 1.00 | 241.53 | 14618.64 |
| imported/rsc/easy0-32 | 26 | 2066.87 ± 3.9% | not timed | not timed | 2960.67 ± 0.9% | 234.83 ± 9.1% | not timed | not timed | 2100.51 ± 1.9% | | 0.98 | 0.70 | 8.80 |
| imported/rsc/easy0-1k | 26 | 31770.47 ± 4.5% | not timed | not timed | 32263.10 ± 3.2% | 3534.92 ± 11.3% | not timed | not timed | 32284.34 ± 3.1% | | 0.98 | 0.98 | 8.99 |
| imported/rsc/easy0-32k | 26 | 87322.91 ± 2.2% | not timed | not timed | 67013.93 ± 1.9% | 40765.51 ± 22.1% | not timed | not timed | 86873.39 ± 2.0% | | 1.01 | 1.30 | 2.14 |
| imported/rsc/easy0-1mb | 26 | 87327.43 ± 2.6% | not timed | not timed | 70428.29 ± 2.3% | 103017.56 ± 0.4% | not timed | not timed | 87322.31 ± 2.9% | | 1.00 | 1.24 | 0.85 |
| imported/rsc/easy1-32 | 19 | 545.38 ± 3.4% | not timed | not timed | 1367.81 ± 2.7% | 225.74 ± 10.9% | not timed | not timed | 547.27 ± 11.9% | | 1.00 | 0.40 | 2.42 |
| imported/rsc/easy1-1k | 19 | 724.54 ± 3.3% | not timed | not timed | 25843.95 ± 2.5% | 3913.07 ± 6.8% | not timed | not timed | 736.51 ± 1.4% | | 0.98 | 0.0280 | 0.19 |
| imported/rsc/easy1-32k | 19 | 744.72 ± 2.0% | not timed | not timed | 881136.05 ± 4.2% | 44034.49 ± 37.7% | not timed | not timed | 739.73 ± 6.2% | | 1.01 | 0.0008 | 0.0169 |
| imported/rsc/easy1-1mb | 19 | 733.28 ± 3.6% | not timed | not timed | 26761034.84 ± 3.1% | 104487.49 ± 3.2% | not timed | not timed | 740.82 ± 4.2% | | 0.99 | 0.0000 | 0.0070 |
| imported/rsc/medium-32 | 27 | 727.53 ± 0.6% | not timed | not timed | 1192.68 ± 0.5% | 120.26 ± 8.6% | not timed | not timed | 728.70 ± 2.3% | | 1.00 | 0.61 | 6.05 |
| imported/rsc/medium-1k | 27 | 11350.62 ± 9.9% | not timed | not timed | 21939.84 ± 3.8% | 120.58 ± 1.8% | not timed | not timed | 11444.84 ± 7.2% | | 0.99 | 0.52 | 94.13 |
| imported/rsc/medium-32k | 27 | 77124.01 ± 4.3% | not timed | not timed | 643497.62 ± 1.8% | 85.11 ± 2.7% | not timed | not timed | 77475.97 ± 0.4% | | 1.00 | 0.12 | 906.22 |
| imported/rsc/medium-1mb | 27 | 88221.90 ± 1.6% | not timed | not timed | 21948242.12 ± 1.3% | 84.01 ± 6.9% | not timed | not timed | 87382.54 ± 2.8% | | 1.01 | 0.0040 | 1050.19 |
| imported/rsc/hard-32 | 58 | 363.11 ± 1.5% | not timed | not timed | 543.22 ± 2.6% | 75.41 ± 7.4% | not timed | not timed | 367.17 ± 3.9% | | 0.99 | 0.67 | 4.82 |
| imported/rsc/hard-1k | 27 | 725.59 ± 1.7% | not timed | not timed | 21805.81 ± 1.1% | 63.69 ± 4.5% | not timed | not timed | 725.64 ± 0.7% | | 1.00 | 0.0333 | 11.39 |
| imported/rsc/hard-32k | 27 | 749.39 ± 1.6% | not timed | not timed | 633394.33 ± 6.0% | 49.70 ± 2.1% | not timed | not timed | 749.90 ± 0.3% | | 1.00 | 0.0012 | 15.08 |
| imported/rsc/hard-1mb | 51 | 750.44 ± 0.3% | not timed | not timed | 11067818.51 ± 1.6% | 49.67 ± 2.1% | not timed | not timed | 750.51 ± 0.3% | | 1.00 | 0.0001 | 15.11 |
| imported/rsc/reallyhard0-32 | 58 | 372.12 ± 1.3% | not timed | not timed | 360.20 ± 0.3% | 79.41 ± 11.4% | not timed | not timed | 367.13 ± 3.5% | | 1.01 | 1.03 | 4.69 |
| imported/rsc/reallyhard0-1k | 27 | 733.23 ± 2.7% | not timed | not timed | 734.85 ± 1.4% | 64.04 ± 8.8% | not timed | not timed | 731.62 ± 0.7% | | 1.00 | 1.00 | 11.45 |
| imported/rsc/reallyhard0-32k | 27 | 748.84 ± 6.5% | not timed | not timed | 750.01 ± 2.9% | 51.13 ± 3.2% | not timed | not timed | 748.93 ± 26.0% | | 1.00 | 1.00 | 14.65 |
| imported/rsc/reallyhard0-1mb | 51 | 745.64 ± 1.3% | not timed | not timed | 746.25 ± 1.4% | 49.76 ± 2.0% | not timed | not timed | 745.09 ± 2.7% | | 1.00 | 1.00 | 14.98 |
| imported/rsc/reallyreallyhard0-32 | 47 | 425.25 ± 2.6% | not timed | not timed | 282.75 ± 4.7% | 91.73 ± 14.3% | not timed | not timed | 410.87 ± 3.4% | | 1.03 | 1.50 | 4.64 |
| imported/rsc/reallyreallyhard0-1k | 16 | 1084.52 ± 6.0% | not timed | not timed | 11477.11 ± 2.4% | 52.58 ± 3.2% | not timed | not timed | 1077.36 ± 1.2% | | 1.01 | 0.0945 | 20.63 |
| imported/rsc/reallyreallyhard0-32k | 16 | 784.11 ± 2.6% | not timed | not timed | 60499.50 ± 3.2% | 38.30 ± 0.8% | not timed | not timed | 782.53 ± 2.7% | | 1.00 | 0.0130 | 20.47 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 749.69 ± 0.2% | not timed | not timed | 69163.06 ± 5.7% | 37.11 ± 0.3% | not timed | not timed | 750.05 ± 0.3% | | 1.00 | 0.0108 | 20.20 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 412.72 ± 0.9% | not timed | not timed | 294.87 ± 1.8% | 96.40 ± 7.8% | not timed | not timed | 414.76 ± 6.6% | | 1.00 | 1.40 | 4.28 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 1042.67 ± 11.9% | not timed | not timed | 10804.71 ± 12.1% | 50.54 ± 10.7% | not timed | not timed | 955.65 ± 12.1% | | 1.09 | 0.0965 | 20.63 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 701.36 ± 11.1% | not timed | not timed | 54305.01 ± 1.5% | 37.07 ± 17.8% | not timed | not timed | 709.88 ± 12.4% | | 0.99 | 0.0129 | 18.92 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 740.47 ± 4.7% | not timed | not timed | 68419.82 ± 2.7% | 41.27 ± 0.8% | not timed | not timed | 740.10 ± 0.8% | | 1.00 | 0.0108 | 17.94 |
| imported/sherlock/name-sherlock | 776 | 66328.31 ± 4.5% | not timed | not timed | 53065.86 ± 4.7% | 16294.71 ± 8.8% | not timed | not timed | 66332.21 ± 5.7% | | 1.00 | 1.25 | 4.07 |
| imported/sherlock/name-holmes | 2766 | 39062.80 ± 1.3% | not timed | not timed | 37565.49 ± 0.8% | 5516.52 ± 4.3% | not timed | not timed | 39491.63 ± 1.9% | | 0.99 | 1.04 | 7.08 |
| imported/sherlock/name-sherlock-holmes | 1365 | 69536.11 ± 5.9% | not timed | not timed | 54641.04 ± 1.0% | 13249.83 ± 18.6% | not timed | not timed | 68832.96 ± 3.7% | | 1.01 | 1.27 | 5.25 |
| imported/sherlock/name-sherlock-casei | 816 | 66621.15 ± 5.7% | not timed | not timed | 15165.17 ± 1.9% | 55.03 ± 3.5% | not timed | not timed | 67113.70 ± 19.5% | | 0.99 | 4.39 | 1210.56 |
| imported/sherlock/name-holmes-casei | 2802 | 31488.05 ± 7.2% | not timed | not timed | 9029.04 ± 5.7% | 66.27 ± 24.6% | not timed | not timed | 31991.32 ± 4.0% | | 0.98 | 3.49 | 475.11 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 53523.64 ± 4.9% | not timed | not timed | 14756.50 ± 4.4% | 54.12 ± 4.8% | not timed | not timed | 54605.73 ± 2.7% | | 0.98 | 3.63 | 988.90 |
| imported/sherlock/name-whitespace | 1461 | 36558.92 ± 6.9% | not timed | not timed | 37802.27 ± 6.1% | 13002.31 ± 13.3% | not timed | not timed | 38145.57 ± 9.6% | | 0.96 | 0.97 | 2.81 |
| imported/sherlock/name-alt1 | 1142 | 40007.22 ± 7.3% | not timed | not timed | 43877.57 ± 6.0% | 6551.41 ± 16.8% | not timed | not timed | 40491.32 ± 8.0% | | 0.99 | 0.91 | 6.11 |
| imported/sherlock/name-alt2 | 3542 | 23456.97 ± 2.6% | not timed | not timed | 12639.06 ± 14.8% | 55.55 ± 77.7% | not timed | not timed | 23432.34 ± 10.0% | | 1.00 | 1.86 | 422.25 |
| imported/sherlock/name-alt3 | 4507 | 15123.74 ± 1.2% | not timed | not timed | 11664.50 ± 3.0% | 17.45 ± 12.2% | not timed | not timed | 15073.72 ± 14.7% | | 1.00 | 1.30 | 866.52 |
| imported/sherlock/name-alt3-casei | 4593 | 2529.61 ± 12.5% | not timed | not timed | 1730.42 ± 4.3% | 10.96 ± 5.3% | not timed | not timed | 2515.92 ± 8.1% | | 1.01 | 1.46 | 230.78 |
| imported/sherlock/name-alt4 | 3686 | 11947.42 ± 3.9% | not timed | not timed | 9917.88 ± 1.3% | 56.15 ± 3.9% | not timed | not timed | 11769.15 ± 1.8% | | 1.02 | 1.20 | 212.76 |
| imported/sherlock/name-alt4-casei | 4254 | 6918.86 ± 3.2% | not timed | not timed | 5310.29 ± 1.7% | 33.32 ± 2.8% | not timed | not timed | 6832.70 ± 4.2% | | 1.01 | 1.30 | 207.67 |
| imported/sherlock/name-alt5 | 4028 | 18004.49 ± 6.9% | not timed | not timed | 11576.14 ± 5.3% | 37.74 ± 21.5% | not timed | not timed | 18283.97 ± 5.5% | | 0.98 | 1.56 | 477.12 |
| imported/sherlock/name-alt5-casei | 4104 | 8605.31 ± 6.6% | not timed | not timed | 3759.23 ± 5.1% | 22.95 ± 4.8% | not timed | not timed | 8820.52 ± 6.8% | | 0.98 | 2.29 | 375.03 |
| imported/sherlock/no-match-uncommon | 0 | 93895.49 ± 6.4% | not timed | not timed | 93877.19 ± 2.9% | 82787.28 ± 3.2% | not timed | not timed | 94628.94 ± 5.9% | | 0.99 | 1.00 | 1.13 |
| imported/sherlock/no-match-common | 0 | 86665.56 ± 1.5% | not timed | not timed | 89927.54 ± 0.8% | 2338.97 ± 3.0% | not timed | not timed | 87351.57 ± 0.1% | | 0.99 | 0.96 | 37.05 |
| imported/sherlock/no-match-really-common | 0 | 60955.31 ± 5.2% | not timed | not timed | 66623.12 ± 5.0% | 2390.31 ± 5.7% | not timed | not timed | 61081.47 ± 5.1% | | 1.00 | 0.91 | 25.50 |
| imported/sherlock/the-lower | 21654 | 4145.62 ± 7.6% | not timed | not timed | 4109.91 ± 4.3% | 385.37 ± 12.8% | not timed | not timed | 4128.92 ± 4.3% | | 1.00 | 1.01 | 10.76 |
| imported/sherlock/the-upper | 2223 | 26502.29 ± 8.1% | not timed | not timed | 33400.76 ± 4.5% | 4196.57 ± 12.7% | not timed | not timed | 26264.69 ± 15.1% | | 1.01 | 0.79 | 6.32 |
| imported/sherlock/the-casei | 23961 | 3667.43 ± 4.7% | not timed | not timed | 1711.22 ± 5.8% | 59.42 ± 25.8% | not timed | not timed | 3655.37 ± 5.2% | | 1.00 | 2.14 | 61.72 |
| imported/sherlock/everything-greedy | 581881 | 355.42 ± 3.3% | not timed | not timed | 231.48 ± 8.3% | 40.43 ± 45.3% | not timed | not timed | 352.65 ± 2.1% | | 1.01 | 1.54 | 8.79 |
| imported/sherlock/everything-greedy-nl | 594933 | 589.38 ± 0.5% | not timed | not timed | 308.70 ± 0.1% | 56.20 ± 0.9% | not timed | not timed | 590.33 ± 0.6% | | 1.00 | 1.91 | 10.49 |
| imported/sherlock/letters | 447175 | 75.27 ± 8.7% | not timed | not timed | 47.11 ± 3.2% | 9.09 ± 39.6% | not timed | not timed | 67.94 ± 24.5% | | 1.11 | 1.60 | 8.28 |
| imported/sherlock/letters-upper | 14180 | 524.94 ± 4.9% | not timed | not timed | 458.53 ± 1.0% | 42.02 ± 33.6% | not timed | not timed | 521.88 ± 2.6% | | 1.01 | 1.14 | 12.49 |
| imported/sherlock/letters-lower | 432995 | 75.21 ± 4.9% | not timed | not timed | 44.67 ± 6.7% | 7.82 ± 33.5% | not timed | not timed | 68.95 ± 3.6% | | 1.09 | 1.68 | 9.62 |
| imported/sherlock/words | 447639 | 131.94 ± 5.0% | not timed | not timed | 107.32 ± 2.1% | 21.74 ± 13.3% | not timed | not timed | 128.47 ± 0.8% | | 1.03 | 1.23 | 6.07 |
| imported/sherlock/before-holmes | 4073 | 738.75 ± 1.6% | not timed | not timed | 17450.13 ± 0.8% | 39.09 ± 3.0% | not timed | not timed | 738.82 ± 4.9% | | 1.00 | 0.0423 | 18.90 |
| imported/sherlock/before-after-holmes | 2593 | 743.98 ± 6.1% | not timed | not timed | 20132.57 ± 16.8% | 39.06 ± 18.2% | not timed | not timed | 743.59 ± 2.7% | | 1.00 | 0.0370 | 19.05 |
| imported/sherlock/holmes-cochar-watson | 150 | 12516.74 ± 1.0% | not timed | not timed | 10204.93 ± 6.8% | 55.88 ± 5.7% | not timed | not timed | 12552.66 ± 1.3% | | 1.00 | 1.23 | 223.98 |
| imported/sherlock/holmes-coword-watson | 14309 | 1585.80 ± 0.9% | not timed | not timed | 1556.24 ± 6.5% | 11.49 ± 7.6% | not timed | not timed | 1586.21 ± 3.1% | | 1.00 | 1.02 | 138.06 |
| imported/sherlock/quotes | 14437 | 1701.24 ± 3.8% | not timed | not timed | 2979.08 ± 2.8% | 55.73 ± 5.0% | not timed | not timed | 1674.19 ± 3.5% | | 1.02 | 0.57 | 30.53 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 743.69 ± 3.2% | not timed | not timed | 42370.06 ± 1.0% | 63.29 ± 15.6% | not timed | not timed | 747.68 ± 1.7% | | 0.99 | 0.0176 | 11.75 |
| imported/sherlock/word-ending-n | 35297 | 566.84 ± 1.5% | not timed | not timed | 494.45 ± 0.9% | 39.42 ± 15.8% | not timed | not timed | 560.75 ± 0.4% | | 1.01 | 1.15 | 14.38 |
| imported/sherlock/repeated-class-negation | 2130 | 25193.11 ± 2.6% | not timed | not timed | 24295.17 ± 2.5% | 16.30 ± 3.7% | not timed | not timed | 25271.17 ± 4.2% | | 1.00 | 1.04 | 1546.01 |
| imported/sherlock/ing-suffix | 20547 | 696.78 ± 1.0% | not timed | not timed | 631.51 ± 0.6% | 46.14 ± 0.9% | not timed | not timed | 692.76 ± 0.3% | | 1.01 | 1.10 | 15.10 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 740.92 ± 0.3% | not timed | not timed | 3827.84 ± 1.4% | 33.88 ± 0.4% | not timed | not timed | 737.04 ± 0.5% | | 1.01 | 0.19 | 21.87 |
| opt/accelerate/whole-line | 239963 | 688.77 ± 1.0% | not timed | not timed | 529.50 ± 4.1% | 119.28 ± 13.4% | not timed | not timed | 687.64 ± 3.9% | | 1.00 | 1.30 | 5.77 |
| opt/accelerate/non-dna | 16745 | 571.49 ± 0.9% | not timed | not timed | 576.17 ± 0.7% | 50.03 ± 33.6% | not timed | not timed | 571.21 ± 0.3% | | 1.00 | 0.99 | 11.42 |
| opt/backtrack/words-english | 40536 | 197.04 ± 1.4% | not timed | not timed | 146.53 ± 0.4% | 31.94 ± 10.8% | not timed | not timed | 197.61 ± 0.9% | | 1.00 | 1.34 | 6.17 |
| opt/fixed-length/too-small-ascii | 0 | 580.70 ± 2.6% | not timed | not timed | 1174.81 ± 0.2% | 175.05 ± 1.7% | not timed | not timed | 577.96 ± 0.4% | | 1.00 | 0.49 | 3.32 |
| opt/fixed-length/too-big-ascii | 0 | 1152.68 ± 3.5% | not timed | not timed | 9326.46 ± 0.4% | 217.95 ± 7.4% | not timed | not timed | 1155.12 ± 0.7% | | 1.00 | 0.12 | 5.29 |
| opt/fixed-length/go33484-1 | 0 | 93.03 ± 0.8% | not timed | not timed | 1754119.84 ± 1.0% | 127322.77 ± 14.8% | not timed | not timed | 77.72 ± 0.5% | | 1.20 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 7136.18 ± 0.1% | not timed | not timed | 1792060.76 ± 0.6% | 47021.30 ± 0.6% | not timed | not timed | 7137.64 ± 0.2% | | 1.00 | 0.0040 | 0.15 |
| opt/fixed-length/go33484-3 | 0 | 2354.18 ± 5.2% | not timed | not timed | 176578.80 ± 1.3% | 1365.66 ± 0.5% | not timed | not timed | 2286.36 ± 8.2% | | 1.03 | 0.0133 | 1.72 |
| opt/literal-alt/one-pattern | 1 | 740.03 ± 4.4% | not timed | not timed | 737.84 ± 4.3% | 0.66 ± 3.8% | not timed | not timed | 731.61 ± 3.1% | | 1.01 | 1.00 | 1129.16 |
| opt/onepass/fn-predicate | 916 | 615.76 ± 1.2% | not timed | not timed | 548.84 ± 0.2% | 294.92 ± 15.4% | not timed | not timed | 623.65 ± 0.5% | | 0.99 | 1.12 | 2.09 |
| opt/onepass/first-three-words-english | 35128 | 225.08 ± 3.6% | not timed | not timed | 317.32 ± 2.1% | 119.66 ± 14.2% | not timed | not timed | 221.08 ± 2.6% | | 1.02 | 0.71 | 1.88 |
| opt/prefilter/literal-english | 1 | 91017.35 ± 1.1% | not timed | not timed | 70787.44 ± 0.6% | 36062.43 ± 3.5% | not timed | not timed | 91200.68 ± 0.2% | | 1.00 | 1.29 | 2.52 |
| opt/prefilter/literal-casei-english | 1 | 69824.12 ± 0.3% | not timed | not timed | 19083.54 ± 1.0% | 53.66 ± 3.1% | not timed | not timed | 69769.59 ± 0.3% | | 1.00 | 3.66 | 1301.25 |
| opt/prefilter/literal-russian | 1 | 94069.75 ± 3.5% | not timed | not timed | 71034.15 ± 2.1% | 4349.49 ± 1.9% | not timed | not timed | 93825.53 ± 4.9% | | 1.00 | 1.32 | 21.63 |
| opt/prefilter/literal-casei-russian | 1 | 37234.36 ± 4.9% | not timed | not timed | 13587.18 ± 0.5% | 58.48 ± 6.5% | not timed | not timed | 36993.89 ± 3.0% | | 1.01 | 2.74 | 636.67 |
| opt/prefilter/rust-functions | 948 | 21017.99 ± 40.8% | not timed | not timed | 17074.72 ± 0.9% | 2414.83 ± 4.3% | not timed | not timed | 20979.16 ± 51.0% | | 1.00 | 1.23 | 8.70 |
| opt/reverse-anchored/word-end | 1 | 7272.26 ± 0.1% | not timed | not timed | 38797409.14 ± 15.3% | 86.84 ± 1.4% | not timed | not timed | 7276.79 ± 0.3% | | 1.00 | 0.0002 | 83.74 |
| opt/reverse-inner/holmes | 2593 | 742.18 ± 0.8% | not timed | not timed | 20222.71 ± 0.8% | 36.55 ± 1.0% | not timed | not timed | 743.99 ± 0.1% | | 1.00 | 0.0367 | 20.31 |
| opt/reverse-inner/email | 47 | 1273.76 ± 28.2% | not timed | not timed | 109099.00 ± 2.2% | 48.35 ± 4.0% | not timed | not timed | 1274.43 ± 4.7% | | 1.00 | 0.0117 | 26.35 |
| opt/reverse-inner/factored-prefix | 3542 | 733.53 ± 0.2% | not timed | not timed | 724.54 ± 0.9% | 19.84 ± 7.3% | not timed | not timed | 733.54 ± 1.2% | | 1.00 | 1.01 | 36.98 |
| opt/reverse-inner/no-quadratic-backward | 0 | 7059.95 ± 1.7% | not timed | not timed | 749.76 ± 0.5% | 128.64 ± 0.7% | not timed | not timed | 7051.45 ± 1.2% | | 1.00 | 9.42 | 54.88 |
| opt/reverse-inner/no-quadratic-forward | 0 | 858.22 ± 9.7% | not timed | not timed | 334.84 ± 8.7% | 40.11 ± 41.7% | not timed | not timed | 848.11 ± 4.8% | | 1.01 | 2.56 | 21.40 |
| opt/reverse-suffix/holmes | 4073 | 741.68 ± 0.2% | not timed | not timed | 17521.31 ± 0.8% | 36.75 ± 0.9% | not timed | not timed | 741.67 ± 0.1% | | 1.00 | 0.0423 | 20.18 |
| opt/reverse-suffix/no-quadratic | 0 | 7078.56 ± 1.2% | not timed | not timed | 749.49 ± 0.7% | 128.73 ± 10.5% | not timed | not timed | 7061.14 ± 1.2% | | 1.00 | 9.44 | 54.99 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 221.78 ± 10.0% | not timed | not timed | 281.40 ± 0.5% | 25.31 ± 3.8% | not timed | not timed | 222.86 ± 9.8% | | 1.00 | 0.79 | 8.76 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 221.44 ± 1.9% | not timed | not timed | 251.14 ± 0.7% | 24.34 ± 6.7% | not timed | not timed | 224.73 ± 8.3% | | 0.99 | 0.88 | 9.10 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.49 ± 2.8% | not timed | not timed | 0.84 ± 1.2% | 175.50 ± 2.3% | not timed | not timed | 0.49 ± 8.3% | | 1.00 | 0.59 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 382.89 ± 4.2% | not timed | not timed | 379.82 ± 0.6% | 167.60 ± 8.8% | not timed | not timed | 380.97 ± 0.9% | | 1.01 | 1.01 | 2.28 |
| reported/i13-subset-regex/original-ascii | 4094 | 15529.68 ± 0.9% | not timed | not timed | 5646.43 ± 0.8% | 15.93 ± 2.4% | not timed | not timed | 15631.44 ± 3.1% | | 0.99 | 2.75 | 974.84 |
| reported/i13-subset-regex/original-unicode | 4094 | 15514.23 ± 4.8% | not timed | not timed | 302.06 ± 3.1% | 15.96 ± 1.6% | not timed | not timed | 15715.09 ± 5.0% | | 0.99 | 51.36 | 971.82 |
| reported/i13-subset-regex/big-ascii | 1955 | 14433.94 ± 2.4% | not timed | not timed | 82.16 ± 2.1% | 13.95 ± 2.1% | not timed | not timed | 14616.91 ± 1.2% | | 0.99 | 175.68 | 1035.05 |
| reported/i13-subset-regex/big-unicode | 1955 | 14469.48 ± 0.5% | not timed | not timed | 14.91 ± 55.9% | 13.83 ± 4.9% | not timed | not timed | 14613.76 ± 1.0% | | 0.99 | 970.69 | 1045.96 |
| reported/i13-subset-regex/huge-ascii | 55 | 13189.28 ± 57.8% | not timed | not timed | 14.09 ± 1.8% | 12.81 ± 41.3% | not timed | not timed | 13249.27 ± 4.3% | | 1.00 | 935.80 | 1029.97 |
| reported/i13-subset-regex/huge-unicode | 55 | 13226.28 ± 1.0% | not timed | not timed | 13.94 ± 1.0% | 12.78 ± 3.7% | not timed | not timed | 13361.08 ± 1.5% | | 0.99 | 948.83 | 1035.06 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.92 ± 3.3% | not timed | not timed | 14.00 ± 6.3% | 12.63 ± 3.6% | not timed | not timed | 5.75 ± 8.1% | | 1.03 | 0.42 | 0.47 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.77 ± 2.3% | not timed | not timed | 13.99 ± 1.0% | 12.81 ± 3.0% | not timed | not timed | 7.76 ± 2.0% | | 1.00 | 0.56 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 603.93 ± 0.4% | not timed | not timed | 215.75 ± 2.0% | 10.75 ± 11.2% | not timed | not timed | 604.06 ± 3.0% | | 1.00 | 2.80 | 56.16 |
| reported/i787-keywords/opt-ascii | 5674 | 603.26 ± 1.8% | not timed | not timed | 362.35 ± 3.6% | 18.35 ± 47.7% | not timed | not timed | 603.72 ± 0.3% | | 1.00 | 1.66 | 32.87 |
| slow/quadratic-regex-1x | 100 | 10.91 ± 3.8% | not timed | not timed | 7.79 ± 6.0% | 0.08 ± 3.7% | not timed | not timed | 11.12 ± 2.3% | | 0.98 | 1.40 | 134.62 |
| slow/quadratic-regex-2x | 199 | 4.64 ± 3.5% | not timed | not timed | 4.15 ± 4.7% | 0.02 ± 4.7% | not timed | not timed | 4.75 ± 3.7% | | 0.98 | 1.12 | 221.43 |
| slow/quadratic-haystack-1x | 100 | 41.03 ± 4.8% | not timed | not timed | 17.40 ± 17.4% | 1.49 ± 8.5% | not timed | not timed | 41.18 ± 1.8% | | 1.00 | 2.36 | 27.46 |
| slow/quadratic-haystack-2x | 200 | 32.28 ± 3.0% | not timed | not timed | 8.13 ± 3.5% | 0.82 ± 6.2% | not timed | not timed | 32.63 ± 3.4% | | 0.99 | 3.97 | 39.34 |
| unicode/codepoints/any-one | 1112064 | 526.46 ± 7.7% | not timed | not timed | 334.52 ± 16.4% | 30.97 ± 5.8% | not timed | not timed | 530.17 ± 2.5% | | 0.99 | 1.57 | 17.00 |
| unicode/codepoints/any-all | 4382592 | 354.14 ± 3.0% | not timed | not timed | 350.19 ± 4.7% | 192.93 ± 12.1% | not timed | not timed | 347.19 ± 4.4% | | 1.02 | 1.01 | 1.84 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.89 ± 3.2% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 750.18 ± 4.8% | not timed | not timed | 749.51 ± 5.6% | 236.83 ± 5.0% | not timed | not timed | 750.95 ± 0.4% | | 1.00 | 1.00 | 3.17 |
| unicode/overlapping-words/ascii | 6156 | 46.12 ± 3.4% | not timed | not timed | 57.46 ± 8.7% | 6.36 ± 86.6% | not timed | not timed | 45.66 ± 6.2% | | 1.01 | 0.80 | 7.25 |
| unicode/overlapping-words/english | 6156 | 2.21 ± 12.7% | not timed | not timed | 5.47 ± 0.5% | 3.93 ± 5.0% | not timed | not timed | 2.23 ± 3.6% | | 0.99 | 0.40 | 0.56 |
| unicode/overlapping-words/russian | 5710 | 2.00 ± 1.2% | not timed | not timed | 5.23 ± 0.6% | 9.76 ± 5.5% | not timed | not timed | 2.02 ± 5.9% | | 0.99 | 0.38 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 140.66 ± 2.1% | not timed | not timed | 102.13 ± 1.3% | 19.00 ± 10.6% | not timed | not timed | 132.82 ± 3.7% | | 1.06 | 1.38 | 7.40 |
| unicode/word/boundary-long-english | 3466 | 751.35 ± 2.2% | not timed | not timed | 735.08 ± 3.0% | 51.92 ± 20.2% | not timed | not timed | 749.91 ± 2.4% | | 1.00 | 1.02 | 14.47 |
| unicode/word/around-holmes-english | 27 | 750.63 ± 1.4% | not timed | not timed | 67994.74 ± 3.6% | 36.49 ± 3.3% | not timed | not timed | 750.20 ± 1.2% | | 1.00 | 0.0110 | 20.57 |
| wild/bibleref/long | 874 | 693.69 ± 4.4% | not timed | not timed | 701.85 ± 4.4% | 11.46 ± 4.3% | not timed | not timed | 694.69 ± 3.3% | | 1.00 | 0.99 | 60.51 |
| wild/bibleref/short | 30 | 36.56 ± 5.8% | not timed | not timed | 46.37 ± 5.3% | 25.25 ± 14.2% | not timed | not timed | 36.77 ± 7.2% | | 0.99 | 0.79 | 1.45 |
| wild/bibleref/line | 874 | 680.73 ± 6.4% | not timed | not timed | 331.17 ± 6.4% | 13.44 ± 6.9% | not timed | not timed | 640.70 ± 2.4% | | 1.06 | 2.06 | 50.65 |
| wild/caddy/caddy | 6 | 618.50 ± 8.9% | not timed | not timed | 360.28 ± 3.5% | 109.39 ± 45.3% | not timed | not timed | 596.68 ± 17.0% | | 1.04 | 1.72 | 5.65 |
| wild/dot-star-capture/rust-src-tools | 6 | 2195.57 ± 2.7% | not timed | not timed | 492.26 ± 3.0% | 23.75 ± 3.3% | not timed | not timed | 2195.06 ± 3.9% | | 1.00 | 4.46 | 92.43 |
| wild/ruff/noqa | 84 | 672.26 ± 3.6% | not timed | not timed | 706.71 ± 4.3% | 32.34 ± 4.6% | not timed | not timed | 645.30 ± 4.4% | | 1.04 | 0.95 | 20.79 |
| wild/ruff/unnecessary-coding-comment | 16 | 764.14 ± 0.3% | not timed | not timed | 937.21 ± 7.2% | 209.12 ± 14.9% | not timed | not timed | 762.35 ± 0.5% | | 1.00 | 0.82 | 3.65 |
| wild/ruff/string-quote-prefix | 2972 | 698.36 ± 0.3% | not timed | not timed | 693.38 ± 4.5% | 486.29 ± 28.4% | not timed | not timed | 675.49 ± 5.6% | | 1.03 | 1.01 | 1.44 |
| wild/ruff/space-around-operator | 1224378 | 327.57 ± 15.3% | not timed | not timed | 294.77 ± 1.5% | 27.73 ± 5.9% | not timed | not timed | 317.40 ± 3.6% | | 1.03 | 1.11 | 11.81 |
| wild/ruff/shebang | 282 | 687.60 ± 8.5% | not timed | not timed | 549.92 ± 2.4% | 168.11 ± 12.7% | not timed | not timed | 668.82 ± 3.7% | | 1.03 | 1.25 | 4.09 |
| wild/rustsec-cargo-audit/original-unix | 471 | 30616.67 ± 8.4% | not timed | not timed | 33766.39 ± 6.0% | 12541.08 ± 5.6% | not timed | not timed | 30698.67 ± 6.4% | | 1.00 | 0.91 | 2.44 |
| wild/rustsec-cargo-audit/original-windows | 462 | 28588.00 ± 2.0% | not timed | not timed | 32090.79 ± 0.9% | 11628.42 ± 0.6% | not timed | not timed | 28578.37 ± 2.5% | | 1.00 | 0.89 | 2.46 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 31354.49 ± 5.0% | not timed | not timed | 33349.62 ± 14.0% | 11839.31 ± 14.6% | not timed | not timed | 31339.31 ± 2.9% | | 1.00 | 0.94 | 2.65 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 26760.83 ± 15.8% | not timed | not timed | 32219.85 ± 8.5% | 11900.32 ± 32.2% | not timed | not timed | 25291.12 ± 7.4% | | 1.06 | 0.83 | 2.25 |
| wild/url/search | 234965 | 180.32 ± 9.8% | not timed | not timed | 87.01 ± 3.3% | 3.71 ± 3.9% | not timed | not timed | 172.11 ± 4.7% | | 1.05 | 2.07 | 48.55 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 9.2% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 26.8% | not timed | not timed | 0.04 ± 25.0% | | 0.98 | 2.96 | 4.66 |
| dictionary/compile/english-15 | 1 | 0.47 ± 10.4% | not timed | not timed | 0.11 ± 3.2% | 0.16 ± 14.4% | not timed | not timed | 0.47 ± 3.5% | | 1.00 | 4.24 | 3.00 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.43 ± 12.1% | not timed | not timed | 0.03 ± 8.1% | 50.04 ± 3.2% | not timed | not timed | 0.43 ± 3.2% | | 1.01 | 13.74 | 0.0086 |
| reported/i1095-word-repetition/ascii-compile | 1 | 58.96 ± 5.9% | not timed | not timed | 19.57 ± 25.4% | 81.99 ± 20.5% | not timed | not timed | 59.11 ± 9.3% | | 1.00 | 3.01 | 0.72 |
| reported/i787-keywords/compile | 1 | 53.85 ± 38.3% | not timed | not timed | 3.25 ± 2.2% | 25.16 ± 4.1% | not timed | not timed | 54.11 ± 7.6% | | 1.00 | 16.57 | 2.14 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 589.45 ± 12.3% | not timed | not timed | 210.15 ± 13.8% | 827.98 ± 3.4% | not timed | not timed | 592.67 ± 11.7% | | 0.99 | 2.80 | 0.71 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 78.21 ± 11.4% | not timed | not timed | 7.53 ± 1.0% | 65.12 ± 8.5% | not timed | not timed | 81.34 ± 6.5% | | 0.96 | 10.39 | 1.20 |
| unicode/compile/one-letter | 53 | 10.60 ± 13.3% | not timed | not timed | 8.03 ± 4.0% | 86.69 ± 4.4% | not timed | not timed | 10.70 ± 14.5% | | 0.99 | 1.32 | 0.12 |
| unicode/compile/fifty-letters | 1 | 1.86 ± 7.9% | not timed | not timed | 0.17 ± 1.3% | 83.45 ± 9.0% | not timed | not timed | 1.86 ± 7.0% | | 1.00 | 10.69 | 0.0222 |
| unicode/compile/fifty-letters-ascii | 1 | 309.33 ± 6.1% | not timed | not timed | 87.49 ± 3.2% | 278.28 ± 2.5% | not timed | not timed | 316.61 ± 4.9% | | 0.98 | 3.54 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 693.37 ± 19.2% | not timed | not timed | 64.38 ± 3.0% | 979.86 ± 2.5% | not timed | not timed | 675.09 ± 17.4% | | 1.03 | 10.77 | 0.71 |
| unicode/compile/match-every-line-ascii | 4 | 1064.37 ± 12.6% | not timed | not timed | 229.64 ± 7.6% | 979.90 ± 1.7% | not timed | not timed | 1122.74 ± 14.8% | | 0.95 | 4.63 | 1.09 |
| unicode/compile/negated-class-matches-codepoint | 1 | 547.39 ± 13.3% | not timed | not timed | 69.66 ± 2.8% | 1804.78 ± 8.9% | not timed | not timed | 576.05 ± 7.7% | | 0.95 | 7.86 | 0.30 |
| wild/bibleref/compile | 3 | 9.13 ± 7.4% | not timed | not timed | 3.38 ± 1.5% | 43.98 ± 13.4% | not timed | not timed | 9.44 ± 4.5% | | 0.97 | 2.70 | 0.21 |
| wild/url/compile | 1 | 1.06 ± 3.4% | not timed | not timed | 0.23 ± 3.0% | 0.60 ± 27.2% | not timed | not timed | 1.04 ± 4.7% | | 1.02 | 4.62 | 1.79 |

