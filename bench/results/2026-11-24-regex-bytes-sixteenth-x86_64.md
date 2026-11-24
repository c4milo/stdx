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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391558797 |
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
| literal: a word | 217 | 64788.09 ± 24.2% | 6430.62 ± 71.9% | 46.21 ± 7.0% | 52351.31 ± 4.9% | 16127.81 ± 2.2% | 16.56 ± 2.8% | 157.83 ± 29.5% | 65947.80 ± 5.9% | 10.07 | 0.98 | 1.24 | 4.02 |
| literal: a word that is not there | 0 | 84242.82 ± 24.4% | 6322.51 ± 22.0% | 46.55 ± 1.7% | 66101.52 ± 6.4% | 58332.13 ± 6.9% | 16.25 ± 1.5% | 146.62 ± 9.2% | 85410.83 ± 6.1% | 13.32 | 0.99 | 1.27 | 1.44 |
| literal: one of four words | 661 | 19602.05 ± 102.2% | 2378.77 ± 8.0% | 24.21 ± 2.7% | 14867.73 ± 5.7% | 39.92 ± 2.0% | 5.17 ± 2.6% | 12.66 ± 28.2% | 20205.16 ± 0.9% | 8.24 | 0.97 | 1.32 | 491.07 |
| literal: a word in any case | 217 | 61389.81 ± 5.0% | 2619.77 ± 3.3% | 33.62 ± 1.5% | 14772.69 ± 1.2% | 75.86 ± 3.3% | refused | differs | 61451.78 ± 3.6% | 23.43 | 1.00 | 4.16 | 809.30 |
| literal: an href attribute | 33 | 53174.40 ± 1.8% | 757.47 ± 7.7% | 38.75 ± 2.9% | 47493.51 ± 47.7% | 3640.51 ± 5.9% | 11.82 ± 2.2% | 129.07 ± 6.9% | 52863.81 ± 3.9% | 70.20 | 1.01 | 1.12 | 14.61 |
| literal: a word, second text | 123 | 65330.55 ± 9.9% | 4555.77 ± 4.2% | 45.42 ± 3.9% | 50715.61 ± 3.1% | 15386.38 ± 5.9% | 21.57 ± 3.7% | 127.84 ± 5.3% | 68004.11 ± 5.1% | 14.34 | 0.96 | 1.29 | 4.25 |
| class: two capitalized words | 1331 | 1133.19 ± 3.4% | 744.50 ± 0.2% | 42.65 ± 0.7% | 708.69 ± 2.1% | 62.27 ± 9.7% | 14.44 ± 2.4% | 105.53 ± 4.7% | 1138.61 ± 2.3% | 1.52 | 1.00 | 1.60 | 18.20 |
| class: a word that ends in ing | 3399 | 713.69 ± 1.4% | 710.01 ± 2.8% | 28.29 ± 5.6% | 663.47 ± 5.5% | 47.66 ± 8.5% | 8.24 ± 3.2% | 29.81 ± 4.6% | 713.32 ± 15.8% | 1.01 | 1.00 | 1.08 | 14.97 |
| class: a word in capitals | 2332 | 1606.46 ± 3.4% | 742.27 ± 3.7% | 40.50 ± 44.4% | 689.74 ± 7.8% | 65.10 ± 27.0% | 16.54 ± 3.8% | 137.12 ± 7.0% | 1605.89 ± 4.9% | 2.16 | 1.00 | 2.33 | 24.68 |
| class: a number | 8288 | 2658.68 ± 3.8% | 1000.69 ± 5.7% | 43.65 ± 13.9% | 2276.07 ± 5.5% | 60.34 ± 23.3% | 0.47 ± 1.8% | 98.53 ± 4.9% | 2572.40 ± 4.2% | 2.66 | 1.03 | 1.17 | 44.06 |
| class: two capitalized words, second text | 5359 | 635.41 ± 1.1% | 643.16 ± 0.2% | 38.61 ± 6.8% | 595.51 ± 0.5% | 53.75 ± 16.5% | 18.60 ± 0.9% | 99.60 ± 3.6% | 632.81 ± 3.7% | 0.99 | 1.00 | 1.07 | 11.82 |
| other: a word between two words | 6104 | 1145.76 ± 3.6% | 723.76 ± 4.2% | 36.61 ± 8.0% | 1027.57 ± 4.0% | 174.58 ± 6.1% | 10.87 ± 0.9% | 114.49 ± 2.6% | 1150.34 ± 6.4% | 1.58 | 1.00 | 1.12 | 6.56 |
| other: a number before a unit, second text | 1481 | 13272.30 ± 2.2% | 1479.34 ± 3.1% | 42.76 ± 0.7% | 11256.17 ± 2.8% | 63.98 ± 15.2% | 20.16 ± 2.5% | 106.81 ± 10.4% | 13016.65 ± 5.2% | 8.97 | 1.02 | 1.18 | 207.45 |
| other: a heading's start tag | 110 | 32388.98 ± 0.9% | 921.30 ± 22.0% | 42.99 ± 3.1% | 3450.36 ± 7.0% | 2595.43 ± 8.0% | 14.85 ± 0.7% | 160.52 ± 25.7% | 32193.46 ± 7.6% | 35.16 | 1.01 | 9.39 | 12.48 |
| other: a whole word | 217 | 40632.67 ± 7.3% | 749.53 ± 1.5% | 47.33 ± 1.1% | 38338.07 ± 0.4% | 78.55 ± 2.0% | 13.93 ± 13.1% | 88.10 ± 5.5% | 41342.65 ± 3.3% | 54.21 | 0.98 | 1.06 | 517.30 |
| other: a line's first word, second text | 3716 | 3560.18 ± 0.8% | 728.05 ± 4.9% | 50.52 ± 5.0% | 3649.63 ± 1.5% | 105.01 ± 6.1% | refused | refused | 3512.06 ± 3.0% | 4.89 | 1.01 | 0.98 | 33.90 |
| other: fourteen octets before an x | 87 | 54247.41 ± 0.9% | 371.18 ± 0.9% | 9.59 ± 5.0% | 4985.32 ± 6.0% | 14.82 ± 3.9% | differs | 26.80 ± 3.1% | 53816.30 ± 0.9% | 146.15 | 1.01 | 10.88 | 3661.54 |
| other: a Greek word | 21815 | 625.18 ± 2.3% | 498.31 ± 0.1% | 49.94 ± 1.1% | 372.23 ± 0.4% | 83.34 ± 3.0% | differs | refused | 624.50 ± 4.9% | 1.25 | 1.00 | 1.68 | 7.50 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.25 ± 3.2% | 28.39 ± 1.0% | 1.60 ± 1.3% | 24.92 ± 3.5% | 3.42 ± 54.8% | differs | 5.67 ± 13.2% | 28.38 ± 2.1% | 1.00 | 1.00 | 1.13 | 8.27 |
| a UUID | 32895 | 30.96 ± 0.4% | 31.18 ± 1.3% | 1.08 ± 1.3% | 19.02 ± 1.8% | 3.76 ± 7.3% | 0.77 ± 3.4% | 4.76 ± 1.7% | 31.04 ± 6.5% | 0.99 | 1.00 | 1.63 | 8.23 |
| an IPv4 address | 33176 | 48.99 ± 1.4% | 48.96 ± 1.8% | 3.48 ± 11.3% | 36.43 ± 1.7% | 9.48 ± 3.9% | differs | 6.16 ± 4.2% | 48.97 ± 2.4% | 1.00 | 1.00 | 1.34 | 5.17 |
| a date and time | 32954 | 45.83 ± 5.9% | 44.35 ± 2.5% | 2.61 ± 5.4% | 27.38 ± 0.7% | 11.58 ± 5.9% | 1.35 ± 1.3% | 11.93 ± 9.1% | 45.86 ± 5.3% | 1.03 | 1.00 | 1.67 | 3.96 |
| a field path | 32606 | 32.04 ± 1.2% | 31.89 ± 7.0% | 1.84 ± 0.7% | 28.94 ± 6.9% | 4.99 ± 1.9% | differs | 4.33 ± 1.2% | 32.01 ± 1.7% | 1.00 | 1.00 | 1.11 | 6.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.92 ± 5.1% | 16.25 ± 6.3% | 16.46 ± 5.2% | 18.09 ± 1.4% | 8.02 ± 12.1% | 1.10 ± 4.1% | none | 16.29 ± 1.4% | 0.98 | 0.98 | 0.88 | 1.99 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 380.92 ± 2.6% | 383.73 ± 1.6% | 446.35 ± 5.2% | 140.50 ± 2.2% | 346.78 ± 16.5% | 940.47 ± 4.1% | 6054.62 ± 1.2% | 373.79 ± 4.9% | 0.99 | 1.02 | 2.71 | 1.10 |
| a UUID | 62 | 246.24 ± 6.4% | 249.50 ± 0.9% | 276.42 ± 3.8% | 78.25 ± 4.5% | 169.35 ± 2.0% | 325.81 ± 3.4% | 7563.23 ± 5.2% | 248.56 ± 4.0% | 0.99 | 0.99 | 3.15 | 1.45 |
| an IPv4 address | 29 | 725.90 ± 4.1% | 728.05 ± 13.4% | 1001.84 ± 5.2% | 123.32 ± 7.1% | 217.00 ± 3.4% | 594.43 ± 3.8% | 13594.53 ± 3.2% | 705.99 ± 6.4% | 1.00 | 1.03 | 5.89 | 3.35 |
| a date and time | 56 | 505.57 ± 5.4% | 521.63 ± 5.6% | 640.03 ± 4.8% | 118.25 ± 4.4% | 232.20 ± 4.3% | 598.54 ± 4.9% | 8171.60 ± 10.3% | 523.70 ± 4.7% | 0.97 | 0.97 | 4.28 | 2.18 |
| a field path | 39 | 376.20 ± 2.1% | 381.47 ± 7.6% | 439.57 ± 2.3% | 131.34 ± 2.0% | 333.99 ± 7.0% | 955.11 ± 10.1% | 7708.31 ± 1.7% | 375.47 ± 3.1% | 0.99 | 1.00 | 2.86 | 1.13 |
| literal: a word | 7 | 1120.56 ± 4.9% | 1219.46 ± 12.2% | 2084.11 ± 3.1% | 890.35 ± 1.3% | 1080.29 ± 41.7% | 1904.93 ± 56.3% | 50768.37 ± 6.8% | 1109.32 ± 4.1% | 0.92 | 1.01 | 1.26 | 1.04 |
| literal: a word that is not there | 8 | 1056.95 ± 7.3% | 1155.36 ± 38.1% | 1931.89 ± 1.7% | 835.53 ± 1.5% | 1047.01 ± 8.1% | 1810.96 ± 5.0% | 49718.78 ± 2.9% | 1055.47 ± 1.8% | 0.91 | 1.00 | 1.27 | 1.01 |
| literal: one of four words | 26 | 422.36 ± 13.9% | 660.35 ± 1.6% | 862.85 ± 4.5% | 70.29 ± 2.1% | 411.81 ± 1.2% | 682.57 ± 4.1% | 24949.29 ± 7.7% | 421.21 ± 3.2% | 0.64 | 1.00 | 6.01 | 1.03 |
| literal: a word in any case | 11 | 783.34 ± 1.4% | 834.00 ± 1.0% | 1187.14 ± 8.2% | 24.04 ± 5.7% | 1139.20 ± 4.3% | refused | 38779.78 ± 2.8% | 781.65 ± 0.9% | 0.94 | 1.00 | 32.58 | 0.69 |
| literal: an href attribute | 12 | 583.32 ± 1.1% | 610.40 ± 1.6% | 791.41 ± 2.1% | 63.67 ± 2.6% | 791.82 ± 12.9% | 1557.29 ± 1.7% | 36379.19 ± 1.2% | 582.95 ± 1.9% | 0.96 | 1.00 | 9.16 | 0.74 |
| literal: a word, second text | 10 | 973.68 ± 1.6% | 1082.16 ± 5.4% | 1724.18 ± 1.9% | 760.98 ± 0.7% | 918.93 ± 2.4% | 1603.96 ± 1.2% | 47591.52 ± 1.2% | 977.25 ± 6.3% | 0.90 | 1.00 | 1.28 | 1.06 |
| class: two capitalized words | 23 | 787.54 ± 3.5% | 851.13 ± 5.4% | 1208.36 ± 3.4% | 165.84 ± 1.0% | 849.00 ± 5.1% | 1497.52 ± 3.7% | 10133.93 ± 2.6% | 792.40 ± 6.5% | 0.93 | 0.99 | 4.75 | 0.93 |
| class: a word that ends in ing | 9 | 971.75 ± 7.9% | 1122.19 ± 1.7% | 1894.11 ± 3.2% | 210.19 ± 0.5% | 1178.49 ± 1.9% | 2260.21 ± 0.7% | 25904.75 ± 0.9% | 975.00 ± 2.4% | 0.87 | 1.00 | 4.62 | 0.82 |
| class: a word in capitals | 16 | 880.09 ± 2.2% | 959.43 ± 4.3% | 1498.94 ± 4.3% | 217.65 ± 1.1% | 1094.55 ± 25.1% | 2059.16 ± 1.1% | 13105.79 ± 1.2% | 876.52 ± 1.9% | 0.92 | 1.00 | 4.04 | 0.80 |
| class: a number | 6 | 1084.29 ± 3.3% | 1222.55 ± 4.4% | 2192.37 ± 1.9% | 61.56 ± 7.0% | 2270.35 ± 3.0% | 3806.49 ± 1.2% | 38272.66 ± 2.5% | 1083.55 ± 9.6% | 0.89 | 1.00 | 17.61 | 0.48 |
| class: two capitalized words, second text | 23 | 785.75 ± 24.9% | 845.51 ± 5.5% | 1216.99 ± 1.8% | 165.30 ± 2.9% | 843.94 ± 20.4% | 1489.92 ± 2.8% | 10013.74 ± 14.8% | 791.96 ± 2.1% | 0.93 | 0.99 | 4.75 | 0.93 |
| other: a word between two words | 13 | 951.15 ± 2.2% | 1006.23 ± 1.5% | 1530.27 ± 8.0% | 220.07 ± 0.7% | 806.36 ± 3.8% | 1614.75 ± 25.6% | 24210.54 ± 53.0% | 944.60 ± 9.6% | 0.95 | 1.01 | 4.32 | 1.18 |
| other: a number before a unit, second text | 15 | 690.90 ± 13.5% | 776.49 ± 7.3% | 1081.64 ± 5.4% | 58.53 ± 1.7% | 999.95 ± 1.9% | 1784.04 ± 7.1% | 25610.74 ± 5.3% | 689.53 ± 5.0% | 0.89 | 1.00 | 11.80 | 0.69 |
| other: a heading's start tag | 13 | 605.41 ± 1.2% | 620.91 ± 3.2% | 815.91 ± 0.7% | 60.62 ± 5.7% | 980.81 ± 2.5% | 1723.55 ± 2.2% | 30000.53 ± 0.9% | 606.20 ± 1.7% | 0.98 | 1.00 | 9.99 | 0.62 |
| other: a whole word | 11 | 986.53 ± 1.4% | 1069.22 ± 2.5% | 1691.53 ± 5.2% | 193.71 ± 1.8% | 947.39 ± 10.2% | 1656.36 ± 5.7% | 45710.42 ± 1.1% | 986.65 ± 5.5% | 0.92 | 1.00 | 5.09 | 1.04 |
| other: a line's first word, second text | 17 | 919.24 ± 3.4% | 988.07 ± 18.6% | 1556.16 ± 4.4% | 206.83 ± 2.2% | 1113.79 ± 3.7% | refused | refused | 929.42 ± 2.1% | 0.93 | 0.99 | 4.44 | 0.83 |
| other: fourteen octets before an x | 16 | 187.16 ± 3.9% | 259.55 ± 30.6% | 296.96 ± 0.4% | 23.35 ± 1.7% | 721.18 ± 3.2% | 785.97 ± 6.6% | 21306.59 ± 4.3% | 187.04 ± 43.5% | 0.72 | 1.00 | 8.02 | 0.26 |
| other: a Greek word | 8 | 749.06 ± 2.0% | 1013.65 ± 1.8% | 1625.38 ± 5.2% | 77.47 ± 3.3% | 2227.31 ± 1.1% | 3619.27 ± 0.8% | refused | 747.92 ± 3.0% | 0.74 | 1.00 | 9.67 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 47138.68 ± 1.3% | not timed | not timed | 45824.59 ± 1.9% | 3766.51 ± 15.1% | not timed | not timed | 47679.46 ± 1.0% | | 0.99 | 1.03 | 12.52 |
| 01-literal/sherlock-casei-en | 522 | 41830.40 ± 1.9% | not timed | not timed | 12008.01 ± 2.1% | 54.82 ± 3.0% | not timed | not timed | 42546.44 ± 2.6% | | 0.98 | 3.48 | 763.00 |
| 01-literal/sherlock-ru | 724 | 47000.14 ± 1.1% | not timed | not timed | 45048.10 ± 3.7% | 2487.93 ± 4.9% | not timed | not timed | 47359.82 ± 1.1% | | 0.99 | 1.04 | 18.89 |
| 01-literal/sherlock-casei-ru | 746 | 15640.04 ± 7.4% | not timed | not timed | 9715.29 ± 3.9% | 58.56 ± 2.9% | not timed | not timed | 15579.32 ± 2.1% | | 1.00 | 1.61 | 267.09 |
| 01-literal/sherlock-zh | 30 | 81683.18 ± 7.8% | not timed | not timed | 61166.43 ± 4.9% | 2196.68 ± 1.5% | not timed | not timed | 82257.25 ± 1.6% | | 0.99 | 1.34 | 37.18 |
| 02-literal-alternate/sherlock-en | 714 | 17385.30 ± 4.8% | not timed | not timed | 13956.12 ± 3.2% | 30.15 ± 17.6% | not timed | not timed | 17153.79 ± 4.8% | | 1.01 | 1.25 | 576.66 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3215.73 ± 6.7% | not timed | not timed | 3075.27 ± 0.7% | 18.72 ± 6.2% | not timed | not timed | 3201.57 ± 5.1% | | 1.00 | 1.05 | 171.77 |
| 02-literal-alternate/sherlock-ru | 899 | 13210.21 ± 2.2% | not timed | not timed | 7688.62 ± 2.4% | 38.23 ± 4.8% | not timed | not timed | 13165.60 ± 3.7% | | 1.00 | 1.72 | 345.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2856.27 ± 0.9% | not timed | not timed | 1481.20 ± 1.1% | 16.64 ± 18.0% | not timed | not timed | 2829.11 ± 3.8% | | 1.01 | 1.93 | 171.62 |
| 02-literal-alternate/sherlock-zh | 207 | 24654.38 ± 2.6% | not timed | not timed | 16457.43 ± 22.4% | 55.82 ± 47.2% | not timed | not timed | 25116.93 ± 12.6% | | 0.98 | 1.50 | 441.68 |
| 03-date/ascii | 111817 | 161.27 ± 4.7% | not timed | not timed | 127.33 ± 1.1% | 0.31 ± 4.8% | not timed | not timed | 161.31 ± 2.0% | | 1.00 | 1.27 | 519.41 |
| 04-ruff-noqa/real | 84 | 689.25 ± 2.9% | not timed | not timed | 703.87 ± 0.6% | 31.79 ± 2.5% | not timed | not timed | 678.27 ± 4.3% | | 1.02 | 0.98 | 21.68 |
| 04-ruff-noqa/tweaked | 44 | 880.28 ± 0.6% | not timed | not timed | 724.49 ± 2.1% | 499.61 ± 3.5% | not timed | not timed | 881.75 ± 1.6% | | 1.00 | 1.22 | 1.76 |
| 05-lexer-veryl/single | 124800 | 6.89 ± 12.2% | not timed | not timed | 7.95 ± 2.5% | 0.35 ± 9.5% | not timed | not timed | 6.99 ± 13.3% | | 0.99 | 0.87 | 19.51 |
| 06-cloud-flare-redos/original | 107 | 549.74 ± 4.2% | not timed | not timed | 295.06 ± 7.0% | 39.05 ± 4.3% | not timed | not timed | 538.90 ± 11.5% | | 1.02 | 1.86 | 14.08 |
| 06-cloud-flare-redos/simplified-short | 102 | 547.85 ± 2.6% | not timed | not timed | 302.38 ± 4.9% | 41.37 ± 5.1% | not timed | not timed | 541.46 ± 3.9% | | 1.01 | 1.81 | 13.24 |
| 06-cloud-flare-redos/simplified-long | 10000 | 664.04 ± 4.5% | not timed | not timed | 334.66 ± 48.1% | 47.00 ± 3.6% | not timed | not timed | 673.44 ± 4.3% | | 0.99 | 1.98 | 14.13 |
| 07-unicode-character-data/parse-line | 558784 | 353.80 ± 6.1% | not timed | not timed | 261.67 ± 2.5% | 68.07 ± 0.9% | not timed | not timed | 355.31 ± 2.7% | | 1.00 | 1.35 | 5.20 |
| 08-words/all-english | 56691 | 141.63 ± 0.8% | not timed | not timed | 97.41 ± 6.2% | 20.32 ± 16.4% | not timed | not timed | 142.10 ± 5.5% | | 1.00 | 1.45 | 6.97 |
| 08-words/long-english | 839 | 753.77 ± 0.8% | not timed | not timed | 722.95 ± 3.8% | 45.51 ± 7.3% | not timed | not timed | 754.96 ± 6.2% | | 1.00 | 1.04 | 16.56 |
| 09-aws-keys/full | 0 | 683.92 ± 4.3% | not timed | not timed | 736.43 ± 3.7% | 98.46 ± 4.3% | not timed | not timed | 702.78 ± 11.7% | | 0.97 | 0.93 | 6.95 |
| 09-aws-keys/quick | 0 | 1499.34 ± 5.1% | not timed | not timed | 1278.32 ± 4.3% | 564.41 ± 10.5% | not timed | not timed | 1509.71 ± 3.2% | | 0.99 | 1.17 | 2.66 |
| 10-bounded-repeat/letters-en | 1833 | 870.84 ± 15.7% | not timed | not timed | 768.80 ± 1.8% | 30.95 ± 33.7% | not timed | not timed | 871.62 ± 18.4% | | 1.00 | 1.13 | 28.14 |
| 10-bounded-repeat/letters-ru | 3475 | 737.19 ± 6.0% | not timed | not timed | 669.42 ± 0.8% | 34.50 ± 13.1% | not timed | not timed | 735.96 ± 5.7% | | 1.00 | 1.10 | 21.37 |
| 10-bounded-repeat/context | 53 | 122.75 ± 5.7% | not timed | not timed | 94.55 ± 2.3% | 30.55 ± 2.0% | not timed | not timed | 123.87 ± 1.6% | | 0.99 | 1.30 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 786.45 ± 6.0% | not timed | not timed | 747.14 ± 1.2% | 53.11 ± 3.8% | not timed | not timed | 789.81 ± 8.0% | | 1.00 | 1.05 | 14.81 |
| 11-unstructured-to-json/extract | 600 | 77.51 ± 1.3% | not timed | not timed | 108.84 ± 8.7% | 78.11 ± 12.6% | not timed | not timed | 75.79 ± 1.9% | | 1.02 | 0.71 | 0.99 |
| 12-dictionary/single | 1 | 675.24 ± 0.3% | not timed | not timed | 646.44 ± 60.7% | 0.67 ± 9.4% | not timed | not timed | 674.80 ± 30.2% | | 1.00 | 1.04 | 1000.77 |
| 14-quadratic/1x | 100 | 41.59 ± 1.4% | not timed | not timed | 17.79 ± 4.2% | 1.49 ± 3.6% | not timed | not timed | 41.74 ± 6.1% | | 1.00 | 2.34 | 27.84 |
| 14-quadratic/2x | 200 | 32.75 ± 11.1% | not timed | not timed | 8.31 ± 0.3% | 0.80 ± 0.9% | not timed | not timed | 32.73 ± 5.5% | | 1.00 | 3.94 | 40.69 |
| 14-quadratic/10x | 1000 | 11.38 ± 4.4% | not timed | not timed | 1.53 ± 0.3% | 0.18 ± 11.9% | not timed | not timed | 11.40 ± 0.8% | | 1.00 | 7.44 | 63.21 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.01 ± 2.9% | not timed | not timed | 0.56 ± 2.9% | 0.86 ± 4.2% | not timed | not timed | 2.01 ± 6.0% | | 1.00 | 3.59 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 192.48 ± 1.8% | not timed | not timed | 22.04 ± 67.2% | 236.30 ± 2.1% | not timed | not timed | 191.74 ± 38.9% | | 1.00 | 8.73 | 0.81 |
| 05-lexer-veryl/compile-single | 1 | 23.42 ± 1.1% | not timed | not timed | 4.09 ± 12.8% | 11.27 ± 2.6% | not timed | not timed | 23.41 ± 1.2% | | 1.00 | 5.73 | 2.08 |
| 07-unicode-character-data/compile | 1 | 182.82 ± 5.4% | not timed | not timed | 41.39 ± 5.3% | 63.10 ± 7.3% | not timed | not timed | 181.56 ± 5.3% | | 1.01 | 4.42 | 2.90 |
| 09-aws-keys/compile-full | 1 | 79.16 ± 5.4% | not timed | not timed | 13.03 ± 3.0% | 38.18 ± 5.1% | not timed | not timed | 78.84 ± 1.3% | | 1.00 | 6.08 | 2.07 |
| 09-aws-keys/compile-quick | 1 | 296.63 ± 7.4% | not timed | not timed | 79.88 ± 1.2% | 219.78 ± 8.8% | not timed | not timed | 299.82 ± 2.0% | | 0.99 | 3.71 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 89.54 ± 3.4% | not timed | not timed | 18.05 ± 1.7% | 27.35 ± 1.7% | not timed | not timed | 89.09 ± 4.5% | | 1.01 | 4.96 | 3.27 |
| 10-bounded-repeat/compile-capitals | 1 | 135.07 ± 4.4% | not timed | not timed | 13.14 ± 1.2% | 39.70 ± 6.2% | not timed | not timed | 135.94 ± 6.6% | | 0.99 | 10.28 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 287.08 ± 20.2% | not timed | not timed | 67.30 ± 1.5% | 117.73 ± 68.4% | not timed | not timed | 290.32 ± 3.3% | | 0.99 | 4.27 | 2.44 |
| 12-dictionary/compile-single | 1 | 0.47 ± 17.5% | not timed | not timed | 0.10 ± 42.1% | 0.15 ± 33.3% | not timed | not timed | 0.48 ± 3.5% | | 0.99 | 4.56 | 3.24 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 11.60 ± 5.5% | not timed | not timed | 10.44 ± 4.5% | 0.91 ± 27.2% | not timed | not timed | 11.54 ± 8.4% | | 1.01 | 1.11 | 12.69 |
| dictionary/search/english-10 | 690 | 1.91 ± 0.4% | not timed | not timed | 258.11 ± 1.7% | 0.01 ± 2.3% | not timed | not timed | 1.91 ± 0.5% | | 1.00 | 0.0074 | 192.07 |
| dictionary/search/english-15 | 15 | 677.57 ± 4.2% | not timed | not timed | 649.51 ± 6.7% | 0.61 ± 12.5% | not timed | not timed | 674.51 ± 0.6% | | 1.00 | 1.04 | 1106.11 |
| folly/awyer-inn-busted | 1 | 7268.95 ± 0.9% | not timed | not timed | 171.32 ± 1.1% | 74.32 ± 0.9% | not timed | not timed | 7278.74 ± 0.6% | | 1.00 | 42.43 | 97.81 |
| folly/literal-never-match-rare | 0 | 87857.45 ± 6.5% | not timed | not timed | 70493.10 ± 5.3% | 92859.84 ± 1.7% | not timed | not timed | 88432.49 ± 8.2% | | 0.99 | 1.25 | 0.95 |
| folly/literal-never-match-frequent | 0 | 41142.72 ± 8.4% | not timed | not timed | 67517.52 ± 7.1% | 3054.62 ± 11.2% | not timed | not timed | 41272.02 ± 47.5% | | 1.00 | 0.61 | 13.47 |
| folly/literal-never-match-tricksy | 1 | 5363.05 ± 9.0% | not timed | not timed | 8674.76 ± 9.5% | 3920.96 ± 68.0% | not timed | not timed | 5313.55 ± 13.7% | | 1.01 | 0.62 | 1.37 |
| grep/every-line | 239963 | 1777.21 ± 10.7% | not timed | not timed | 1346.57 ± 2.3% | 539.82 ± 16.4% | not timed | not timed | 1851.03 ± 5.3% | | 0.96 | 1.32 | 3.29 |
| grep/long-words-ascii | 5073 | 684.02 ± 6.4% | not timed | not timed | 633.16 ± 2.0% | 65.33 ± 13.4% | not timed | not timed | 667.99 ± 4.3% | | 1.02 | 1.08 | 10.47 |
| imported/leipzig/twain | 811 | 76023.52 ± 1.4% | not timed | not timed | 62658.89 ± 1.2% | 15748.79 ± 9.9% | not timed | not timed | 76311.41 ± 1.6% | | 1.00 | 1.21 | 4.83 |
| imported/leipzig/twain-insensitive | 965 | 19932.99 ± 0.3% | not timed | not timed | 17982.84 ± 0.7% | 66.60 ± 4.7% | not timed | not timed | 19938.34 ± 0.6% | | 1.00 | 1.11 | 299.30 |
| imported/leipzig/shing | 1540 | 777.02 ± 3.5% | not timed | not timed | 29471.49 ± 1.8% | 55.07 ± 2.8% | not timed | not timed | 777.10 ± 5.5% | | 1.00 | 0.0264 | 14.11 |
| imported/leipzig/huck-saw | 262 | 35537.16 ± 5.4% | not timed | not timed | 24875.20 ± 4.6% | 55.03 ± 5.5% | not timed | not timed | 35749.45 ± 13.5% | | 0.99 | 1.43 | 645.81 |
| imported/leipzig/word-ending-nn | 262 | 750.09 ± 0.9% | not timed | not timed | 744.95 ± 3.0% | 41.49 ± 1.7% | not timed | not timed | 749.78 ± 4.6% | | 1.00 | 1.01 | 18.08 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 15647.69 ± 16.1% | not timed | not timed | 5736.87 ± 7.1% | 15.98 ± 3.1% | not timed | not timed | 15881.52 ± 3.5% | | 0.99 | 2.73 | 979.31 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 28970.68 ± 6.2% | not timed | not timed | 22859.29 ± 0.6% | 30.42 ± 2.5% | not timed | not timed | 28439.19 ± 8.7% | | 1.02 | 1.27 | 952.29 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6871.06 ± 1.7% | not timed | not timed | 1204.53 ± 2.5% | 18.71 ± 1.5% | not timed | not timed | 6812.48 ± 7.0% | | 1.01 | 5.70 | 367.29 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 749.62 ± 0.5% | not timed | not timed | 746.95 ± 3.6% | 19.49 ± 2.1% | not timed | not timed | 749.81 ± 9.8% | | 1.00 | 1.00 | 38.47 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 749.86 ± 1.6% | not timed | not timed | 749.18 ± 6.4% | 16.81 ± 3.9% | not timed | not timed | 749.02 ± 1.5% | | 1.00 | 1.00 | 44.61 |
| imported/leipzig/tom-river | 2 | 17436.35 ± 2.8% | not timed | not timed | 18189.49 ± 4.3% | 54.48 ± 5.2% | not timed | not timed | 17539.74 ± 2.3% | | 0.99 | 0.96 | 320.03 |
| imported/leipzig/ing | 78424 | 737.84 ± 5.5% | not timed | not timed | 686.67 ± 2.9% | 43.89 ± 11.5% | not timed | not timed | 733.77 ± 4.3% | | 1.01 | 1.07 | 16.81 |
| imported/leipzig/ing-whitespace | 55248 | 919.33 ± 1.1% | not timed | not timed | 2954.41 ± 0.7% | 33.83 ± 3.8% | not timed | not timed | 923.87 ± 0.6% | | 1.00 | 0.31 | 27.17 |
| imported/leipzig/awyer-inn | 209 | 935.53 ± 4.9% | not timed | not timed | 18336.10 ± 6.9% | 34.94 ± 4.3% | not timed | not timed | 932.49 ± 3.1% | | 1.00 | 0.0510 | 26.77 |
| imported/leipzig/quotes-bounded | 8886 | 2544.00 ± 4.4% | not timed | not timed | 4042.46 ± 2.4% | 59.73 ± 4.3% | not timed | not timed | 2584.44 ± 3.7% | | 0.98 | 0.63 | 42.59 |
| imported/leipzig/non-ascii-alternate | 2 | 64982.90 ± 82.5% | not timed | not timed | 25298.67 ± 3.9% | 83.83 ± 7.0% | not timed | not timed | 64893.81 ± 30.9% | | 1.00 | 2.57 | 775.15 |
| imported/leipzig/math-symbols | 69 | 4363.02 ± 2.7% | not timed | not timed | 747.60 ± 3.9% | 57.57 ± 7.9% | not timed | not timed | 4371.21 ± 5.0% | | 1.00 | 5.84 | 75.79 |
| imported/leipzig/bounded-strings-ending-z | 0 | 724.54 ± 0.7% | not timed | not timed | 720.74 ± 4.6% | 38.06 ± 6.0% | not timed | not timed | 728.08 ± 6.6% | | 1.00 | 1.01 | 19.04 |
| imported/lh3lh3-reb/uri | 17549 | 953.87 ± 4.6% | not timed | not timed | 1559.46 ± 2.1% | 41.32 ± 6.0% | not timed | not timed | 932.27 ± 3.5% | | 1.02 | 0.61 | 23.09 |
| imported/lh3lh3-reb/email | 15057 | 1043.08 ± 3.6% | not timed | not timed | 1534.63 ± 4.8% | 45.21 ± 3.0% | not timed | not timed | 1047.06 ± 2.5% | | 1.00 | 0.68 | 23.07 |
| imported/lh3lh3-reb/date | 668 | 1192.74 ± 0.6% | not timed | not timed | 1350.52 ± 5.0% | 74.23 ± 8.1% | not timed | not timed | 1185.60 ± 5.3% | | 1.01 | 0.88 | 16.07 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 970.26 ± 2.6% | not timed | not timed | 564.70 ± 4.5% | 23.43 ± 2.9% | not timed | not timed | 969.95 ± 3.2% | | 1.00 | 1.72 | 41.42 |
| imported/mariomka/email | 92 | 865.99 ± 4.1% | not timed | not timed | 74925.16 ± 2.1% | 52.30 ± 1.5% | not timed | not timed | 867.28 ± 3.9% | | 1.00 | 0.0116 | 16.56 |
| imported/mariomka/uri | 5301 | 747.47 ± 6.0% | not timed | not timed | 9543.20 ± 16.9% | 52.53 ± 1.6% | not timed | not timed | 747.93 ± 3.5% | | 1.00 | 0.0783 | 14.23 |
| imported/mariomka/ip | 5 | 2494.53 ± 2.4% | not timed | not timed | 2962.71 ± 0.6% | 34.60 ± 6.8% | not timed | not timed | 2489.95 ± 7.7% | | 1.00 | 0.84 | 72.11 |
| imported/rsc/no-exponential | 0 | 1172.97 ± 0.7% | not timed | not timed | 751.60 ± 1.1% | 34.07 ± 0.8% | not timed | not timed | 1172.99 ± 0.5% | | 1.00 | 1.56 | 34.43 |
| imported/rsc/literal | 1 | 1368.16 ± 4.9% | not timed | not timed | 3225.83 ± 4.3% | 350.50 ± 21.1% | not timed | not timed | 1453.70 ± 15.6% | | 0.94 | 0.42 | 3.90 |
| imported/rsc/not-literal | 2 | 1337.65 ± 2.3% | not timed | not timed | 1202.28 ± 1.1% | 80.03 ± 6.1% | not timed | not timed | 1347.79 ± 0.8% | | 0.99 | 1.11 | 16.72 |
| imported/rsc/match-class | 1 | 2373.47 ± 13.4% | not timed | not timed | 3222.41 ± 2.3% | 102.15 ± 8.8% | not timed | not timed | 2374.34 ± 6.5% | | 1.00 | 0.74 | 23.24 |
| imported/rsc/match-class-in-range | 1 | 2374.00 ± 5.0% | not timed | not timed | 4989.66 ± 1.4% | 104.02 ± 9.6% | not timed | not timed | 2373.73 ± 42.0% | | 1.00 | 0.48 | 22.82 |
| imported/rsc/match-class-unicode | 1 | 695.80 ± 6.2% | not timed | not timed | 674.98 ± 0.5% | 121.28 ± 3.7% | not timed | not timed | 697.38 ± 4.1% | | 1.00 | 1.03 | 5.74 |
| imported/rsc/anchored-literal-short-non-match | 0 | 938.65 ± 7.0% | not timed | not timed | 1821.72 ± 5.6% | 468.84 ± 2.7% | not timed | not timed | 971.42 ± 1.5% | | 0.97 | 0.52 | 2.00 |
| imported/rsc/anchored-literal-long-non-match | 0 | 15638.43 ± 1.4% | not timed | not timed | 27339.66 ± 0.7% | 6941.87 ± 3.0% | not timed | not timed | 15589.09 ± 2.2% | | 1.00 | 0.57 | 2.25 |
| imported/rsc/anchored-literal-short-match | 4 | 688.29 ± 5.6% | not timed | not timed | 991.53 ± 2.3% | 157.92 ± 12.7% | not timed | not timed | 697.46 ± 1.2% | | 0.99 | 0.69 | 4.36 |
| imported/rsc/anchored-literal-long-match | 4 | 4498.15 ± 15.8% | not timed | not timed | 14896.43 ± 3.6% | 2329.83 ± 5.5% | not timed | not timed | 4612.63 ± 1.3% | | 0.98 | 0.30 | 1.93 |
| imported/rsc/one-pass-short | 17 | 582.01 ± 9.1% | not timed | not timed | 438.69 ± 4.5% | 51.17 ± 6.9% | not timed | not timed | 573.18 ± 4.2% | | 1.02 | 1.33 | 11.37 |
| imported/rsc/one-pass-short-not | 17 | 370.88 ± 1.6% | not timed | not timed | 482.21 ± 0.8% | 48.49 ± 2.4% | not timed | not timed | 369.82 ± 2.5% | | 1.00 | 0.77 | 7.65 |
| imported/rsc/one-pass-long-prefix | 26 | 371.71 ± 3.9% | not timed | not timed | 520.58 ± 4.7% | 188.23 ± 12.5% | not timed | not timed | 380.17 ± 6.9% | | 0.98 | 0.71 | 1.97 |
| imported/rsc/one-pass-long-prefix-not | 26 | 528.23 ± 1.2% | not timed | not timed | 512.26 ± 16.1% | 116.89 ± 15.5% | not timed | not timed | 530.14 ± 2.8% | | 1.00 | 1.03 | 4.52 |
| imported/rsc/long-needle1 | 31 | 90751.08 ± 1.7% | not timed | not timed | 69842.30 ± 1.0% | 6.39 ± 3.7% | not timed | not timed | 90884.64 ± 2.1% | | 1.00 | 1.30 | 14206.32 |
| imported/rsc/long-needle2 | 31 | 90853.39 ± 1.3% | not timed | not timed | 373.84 ± 6.3% | 6.17 ± 5.8% | not timed | not timed | 90315.12 ± 5.6% | | 1.01 | 243.03 | 14728.87 |
| imported/rsc/easy0-32 | 26 | 1968.83 ± 6.0% | not timed | not timed | 2965.73 ± 3.1% | 237.53 ± 13.7% | not timed | not timed | 2077.15 ± 4.9% | | 0.95 | 0.66 | 8.29 |
| imported/rsc/easy0-1k | 26 | 32371.70 ± 1.4% | not timed | not timed | 32286.14 ± 2.4% | 3638.56 ± 7.7% | not timed | not timed | 32288.87 ± 8.0% | | 1.00 | 1.00 | 8.90 |
| imported/rsc/easy0-32k | 26 | 85840.75 ± 2.4% | not timed | not timed | 67074.89 ± 0.9% | 40334.08 ± 17.1% | not timed | not timed | 86282.03 ± 2.3% | | 0.99 | 1.28 | 2.13 |
| imported/rsc/easy0-1mb | 26 | 87392.82 ± 5.3% | not timed | not timed | 69243.52 ± 6.5% | 98563.72 ± 6.3% | not timed | not timed | 86273.34 ± 5.3% | | 1.01 | 1.26 | 0.89 |
| imported/rsc/easy1-32 | 19 | 527.16 ± 5.2% | not timed | not timed | 1309.87 ± 4.5% | 232.32 ± 19.3% | not timed | not timed | 553.92 ± 6.4% | | 0.95 | 0.40 | 2.27 |
| imported/rsc/easy1-1k | 19 | 727.39 ± 1.7% | not timed | not timed | 26036.25 ± 3.2% | 3818.39 ± 12.7% | not timed | not timed | 736.57 ± 12.8% | | 0.99 | 0.0279 | 0.19 |
| imported/rsc/easy1-32k | 19 | 748.24 ± 5.6% | not timed | not timed | 882987.99 ± 0.6% | 42979.75 ± 28.8% | not timed | not timed | 743.69 ± 1.3% | | 1.01 | 0.0008 | 0.0174 |
| imported/rsc/easy1-1mb | 19 | 750.03 ± 0.3% | not timed | not timed | 27269612.91 ± 0.8% | 105925.95 ± 8.6% | not timed | not timed | 749.41 ± 1.4% | | 1.00 | 0.0000 | 0.0071 |
| imported/rsc/medium-32 | 27 | 725.11 ± 4.0% | not timed | not timed | 1227.27 ± 3.4% | 119.34 ± 12.3% | not timed | not timed | 722.24 ± 4.2% | | 1.00 | 0.59 | 6.08 |
| imported/rsc/medium-1k | 27 | 11456.49 ± 0.5% | not timed | not timed | 21948.91 ± 0.8% | 121.31 ± 0.5% | not timed | not timed | 11590.33 ± 1.0% | | 0.99 | 0.52 | 94.44 |
| imported/rsc/medium-32k | 27 | 76113.76 ± 0.6% | not timed | not timed | 691948.15 ± 2.7% | 84.67 ± 22.8% | not timed | not timed | 75872.85 ± 5.0% | | 1.00 | 0.11 | 898.99 |
| imported/rsc/medium-1mb | 27 | 86294.90 ± 1.0% | not timed | not timed | 21472767.06 ± 0.8% | 83.50 ± 2.7% | not timed | not timed | 86447.35 ± 0.3% | | 1.00 | 0.0040 | 1033.52 |
| imported/rsc/hard-32 | 58 | 366.56 ± 3.4% | not timed | not timed | 547.40 ± 5.0% | 76.80 ± 12.2% | not timed | not timed | 366.60 ± 1.0% | | 1.00 | 0.67 | 4.77 |
| imported/rsc/hard-1k | 27 | 720.56 ± 7.5% | not timed | not timed | 20465.70 ± 4.3% | 62.72 ± 14.1% | not timed | not timed | 723.01 ± 1.8% | | 1.00 | 0.0352 | 11.49 |
| imported/rsc/hard-32k | 27 | 749.51 ± 1.8% | not timed | not timed | 658954.69 ± 2.5% | 51.00 ± 0.6% | not timed | not timed | 748.97 ± 1.6% | | 1.00 | 0.0011 | 14.70 |
| imported/rsc/hard-1mb | 51 | 749.26 ± 0.3% | not timed | not timed | 11316036.65 ± 1.4% | 50.69 ± 0.9% | not timed | not timed | 749.24 ± 1.0% | | 1.00 | 0.0001 | 14.78 |
| imported/rsc/reallyhard0-32 | 58 | 372.80 ± 5.9% | not timed | not timed | 351.09 ± 18.5% | 79.91 ± 5.1% | not timed | not timed | 370.52 ± 5.0% | | 1.01 | 1.06 | 4.67 |
| imported/rsc/reallyhard0-1k | 27 | 733.27 ± 0.9% | not timed | not timed | 732.10 ± 1.2% | 64.41 ± 20.0% | not timed | not timed | 731.66 ± 5.4% | | 1.00 | 1.00 | 11.38 |
| imported/rsc/reallyhard0-32k | 27 | 749.31 ± 2.7% | not timed | not timed | 750.61 ± 3.9% | 50.74 ± 0.6% | not timed | not timed | 749.71 ± 0.3% | | 1.00 | 1.00 | 14.77 |
| imported/rsc/reallyhard0-1mb | 51 | 748.42 ± 5.1% | not timed | not timed | 748.90 ± 3.2% | 50.14 ± 3.5% | not timed | not timed | 747.48 ± 2.0% | | 1.00 | 1.00 | 14.93 |
| imported/rsc/reallyreallyhard0-32 | 47 | 424.47 ± 7.1% | not timed | not timed | 281.93 ± 2.6% | 96.25 ± 6.5% | not timed | not timed | 431.62 ± 4.5% | | 0.98 | 1.51 | 4.41 |
| imported/rsc/reallyreallyhard0-1k | 16 | 1080.59 ± 2.1% | not timed | not timed | 11433.71 ± 10.5% | 52.29 ± 6.1% | not timed | not timed | 1081.14 ± 0.9% | | 1.00 | 0.0945 | 20.67 |
| imported/rsc/reallyreallyhard0-32k | 16 | 771.72 ± 4.0% | not timed | not timed | 60669.95 ± 3.5% | 41.28 ± 5.4% | not timed | not timed | 779.00 ± 2.2% | | 0.99 | 0.0127 | 18.70 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 749.41 ± 0.3% | not timed | not timed | 69607.68 ± 21.5% | 42.03 ± 19.4% | not timed | not timed | 749.62 ± 0.6% | | 1.00 | 0.0108 | 17.83 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 418.15 ± 6.1% | not timed | not timed | 295.14 ± 0.8% | 99.56 ± 7.4% | not timed | not timed | 417.33 ± 9.4% | | 1.00 | 1.42 | 4.20 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 1049.91 ± 1.5% | not timed | not timed | 10805.75 ± 3.8% | 52.19 ± 2.1% | not timed | not timed | 1051.25 ± 0.8% | | 1.00 | 0.0972 | 20.12 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 767.84 ± 4.0% | not timed | not timed | 59888.38 ± 16.9% | 40.59 ± 19.5% | not timed | not timed | 782.34 ± 6.0% | | 0.98 | 0.0128 | 18.92 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 750.42 ± 0.4% | not timed | not timed | 69281.31 ± 1.5% | 40.58 ± 2.5% | not timed | not timed | 749.76 ± 0.8% | | 1.00 | 0.0108 | 18.49 |
| imported/sherlock/name-sherlock | 776 | 66185.04 ± 7.3% | not timed | not timed | 54015.63 ± 2.2% | 16669.67 ± 19.7% | not timed | not timed | 67981.78 ± 6.5% | | 0.97 | 1.23 | 3.97 |
| imported/sherlock/name-holmes | 2766 | 38267.66 ± 4.6% | not timed | not timed | 38240.55 ± 5.1% | 5499.80 ± 11.7% | not timed | not timed | 38749.65 ± 4.5% | | 0.99 | 1.00 | 6.96 |
| imported/sherlock/name-sherlock-holmes | 1365 | 66926.77 ± 6.9% | not timed | not timed | 54742.30 ± 3.3% | 14287.13 ± 7.7% | not timed | not timed | 68948.93 ± 7.4% | | 0.97 | 1.22 | 4.68 |
| imported/sherlock/name-sherlock-casei | 816 | 69251.24 ± 1.3% | not timed | not timed | 15183.28 ± 0.6% | 53.35 ± 3.1% | not timed | not timed | 69555.35 ± 0.8% | | 1.00 | 4.56 | 1298.17 |
| imported/sherlock/name-holmes-casei | 2802 | 32794.24 ± 1.6% | not timed | not timed | 9421.96 ± 0.4% | 67.40 ± 2.2% | not timed | not timed | 32965.26 ± 1.0% | | 0.99 | 3.48 | 486.58 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 54881.11 ± 2.7% | not timed | not timed | 14815.72 ± 3.5% | 55.13 ± 4.0% | not timed | not timed | 54670.99 ± 1.7% | | 1.00 | 3.70 | 995.49 |
| imported/sherlock/name-whitespace | 1461 | 35945.78 ± 6.9% | not timed | not timed | 38775.14 ± 1.2% | 13263.67 ± 9.6% | not timed | not timed | 37195.65 ± 6.9% | | 0.97 | 0.93 | 2.71 |
| imported/sherlock/name-alt1 | 1142 | 42854.61 ± 4.0% | not timed | not timed | 46189.51 ± 4.9% | 6836.28 ± 23.5% | not timed | not timed | 42807.28 ± 2.7% | | 1.00 | 0.93 | 6.27 |
| imported/sherlock/name-alt2 | 3542 | 23643.00 ± 0.5% | not timed | not timed | 12582.87 ± 2.6% | 55.97 ± 5.8% | not timed | not timed | 23571.02 ± 5.0% | | 1.00 | 1.88 | 422.42 |
| imported/sherlock/name-alt3 | 4507 | 15194.60 ± 0.6% | not timed | not timed | 11752.91 ± 2.0% | 17.70 ± 14.2% | not timed | not timed | 15170.17 ± 1.3% | | 1.00 | 1.29 | 858.39 |
| imported/sherlock/name-alt3-casei | 4593 | 2549.77 ± 12.0% | not timed | not timed | 1752.65 ± 0.4% | 11.02 ± 9.6% | not timed | not timed | 2536.03 ± 6.3% | | 1.01 | 1.45 | 231.33 |
| imported/sherlock/name-alt4 | 3686 | 12055.48 ± 0.3% | not timed | not timed | 9889.32 ± 0.4% | 55.83 ± 1.6% | not timed | not timed | 12072.55 ± 11.2% | | 1.00 | 1.22 | 215.92 |
| imported/sherlock/name-alt4-casei | 4254 | 6912.17 ± 3.5% | not timed | not timed | 5365.54 ± 1.1% | 33.46 ± 4.0% | not timed | not timed | 6900.44 ± 5.0% | | 1.00 | 1.29 | 206.56 |
| imported/sherlock/name-alt5 | 4028 | 19200.51 ± 4.6% | not timed | not timed | 12273.09 ± 0.4% | 40.47 ± 0.5% | not timed | not timed | 19247.99 ± 3.0% | | 1.00 | 1.56 | 474.40 |
| imported/sherlock/name-alt5-casei | 4104 | 8783.08 ± 1.9% | not timed | not timed | 3965.25 ± 1.6% | 24.77 ± 1.3% | not timed | not timed | 8708.87 ± 3.4% | | 1.01 | 2.22 | 354.60 |
| imported/sherlock/no-match-uncommon | 0 | 94853.18 ± 2.0% | not timed | not timed | 94385.74 ± 1.2% | 82428.26 ± 2.3% | not timed | not timed | 94920.90 ± 5.7% | | 1.00 | 1.00 | 1.15 |
| imported/sherlock/no-match-common | 0 | 92716.54 ± 3.9% | not timed | not timed | 94351.10 ± 1.0% | 2457.49 ± 1.2% | not timed | not timed | 92802.27 ± 0.5% | | 1.00 | 0.98 | 37.73 |
| imported/sherlock/no-match-really-common | 0 | 64513.21 ± 11.2% | not timed | not timed | 66889.43 ± 1.8% | 2460.43 ± 0.5% | not timed | not timed | 64313.05 ± 0.5% | | 1.00 | 0.96 | 26.22 |
| imported/sherlock/the-lower | 21654 | 4031.47 ± 7.1% | not timed | not timed | 4074.67 ± 3.1% | 389.80 ± 10.7% | not timed | not timed | 4136.27 ± 1.1% | | 0.97 | 0.99 | 10.34 |
| imported/sherlock/the-upper | 2223 | 26786.75 ± 3.1% | not timed | not timed | 35263.40 ± 2.3% | 4293.47 ± 15.0% | not timed | not timed | 27156.01 ± 6.4% | | 0.99 | 0.76 | 6.24 |
| imported/sherlock/the-casei | 23961 | 3714.75 ± 0.5% | not timed | not timed | 1784.82 ± 0.4% | 62.07 ± 19.2% | not timed | not timed | 3802.11 ± 0.6% | | 0.98 | 2.08 | 59.85 |
| imported/sherlock/everything-greedy | 581881 | 361.96 ± 0.7% | not timed | not timed | 231.31 ± 3.6% | 42.98 ± 14.8% | not timed | not timed | 362.29 ± 0.8% | | 1.00 | 1.56 | 8.42 |
| imported/sherlock/everything-greedy-nl | 594933 | 590.53 ± 0.3% | not timed | not timed | 308.07 ± 8.7% | 48.51 ± 0.9% | not timed | not timed | 589.91 ± 1.3% | | 1.00 | 1.92 | 12.17 |
| imported/sherlock/letters | 447175 | 74.81 ± 1.1% | not timed | not timed | 44.49 ± 0.2% | 11.06 ± 1.2% | not timed | not timed | 76.73 ± 0.8% | | 0.97 | 1.68 | 6.76 |
| imported/sherlock/letters-upper | 14180 | 534.90 ± 1.0% | not timed | not timed | 462.28 ± 0.5% | 41.66 ± 30.8% | not timed | not timed | 536.53 ± 0.5% | | 1.00 | 1.16 | 12.84 |
| imported/sherlock/letters-lower | 432995 | 78.72 ± 18.9% | not timed | not timed | 48.12 ± 0.5% | 10.14 ± 43.7% | not timed | not timed | 78.47 ± 1.3% | | 1.00 | 1.64 | 7.77 |
| imported/sherlock/words | 447639 | 133.12 ± 5.1% | not timed | not timed | 106.74 ± 1.1% | 20.83 ± 6.2% | not timed | not timed | 134.52 ± 1.1% | | 0.99 | 1.25 | 6.39 |
| imported/sherlock/before-holmes | 4073 | 740.19 ± 2.1% | not timed | not timed | 17106.21 ± 0.7% | 38.36 ± 1.1% | not timed | not timed | 742.12 ± 0.2% | | 1.00 | 0.0433 | 19.29 |
| imported/sherlock/before-after-holmes | 2593 | 744.08 ± 0.2% | not timed | not timed | 20039.78 ± 1.1% | 38.57 ± 1.3% | not timed | not timed | 744.47 ± 1.0% | | 1.00 | 0.0371 | 19.29 |
| imported/sherlock/holmes-cochar-watson | 150 | 12660.53 ± 0.6% | not timed | not timed | 10114.39 ± 0.8% | 55.96 ± 6.0% | not timed | not timed | 12590.96 ± 2.3% | | 1.01 | 1.25 | 226.25 |
| imported/sherlock/holmes-coword-watson | 14309 | 1587.20 ± 0.2% | not timed | not timed | 1559.10 ± 1.5% | 11.79 ± 0.7% | not timed | not timed | 1585.82 ± 2.1% | | 1.00 | 1.02 | 134.65 |
| imported/sherlock/quotes | 14437 | 1742.26 ± 4.7% | not timed | not timed | 3015.79 ± 1.3% | 55.49 ± 4.0% | not timed | not timed | 1745.21 ± 1.8% | | 1.00 | 0.58 | 31.40 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 747.91 ± 2.4% | not timed | not timed | 42433.14 ± 1.4% | 63.35 ± 21.9% | not timed | not timed | 748.60 ± 0.6% | | 1.00 | 0.0176 | 11.81 |
| imported/sherlock/word-ending-n | 35297 | 567.07 ± 3.3% | not timed | not timed | 504.20 ± 4.8% | 35.06 ± 27.5% | not timed | not timed | 569.28 ± 2.2% | | 1.00 | 1.12 | 16.18 |
| imported/sherlock/repeated-class-negation | 2130 | 25255.96 ± 10.6% | not timed | not timed | 24137.25 ± 0.2% | 16.43 ± 2.7% | not timed | not timed | 25278.93 ± 0.4% | | 1.00 | 1.05 | 1537.25 |
| imported/sherlock/ing-suffix | 20547 | 698.17 ± 0.6% | not timed | not timed | 637.44 ± 0.2% | 44.88 ± 1.8% | not timed | not timed | 699.48 ± 0.4% | | 1.00 | 1.10 | 15.56 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 737.91 ± 1.1% | not timed | not timed | 3784.66 ± 1.7% | 33.49 ± 30.7% | not timed | not timed | 742.93 ± 4.8% | | 0.99 | 0.19 | 22.03 |
| opt/accelerate/whole-line | 239963 | 682.02 ± 3.0% | not timed | not timed | 528.21 ± 1.2% | 130.53 ± 19.4% | not timed | not timed | 692.77 ± 0.6% | | 0.98 | 1.29 | 5.23 |
| opt/accelerate/non-dna | 16745 | 580.46 ± 0.8% | not timed | not timed | 580.29 ± 0.2% | 49.70 ± 22.8% | not timed | not timed | 581.59 ± 2.0% | | 1.00 | 1.00 | 11.68 |
| opt/backtrack/words-english | 40536 | 194.74 ± 10.4% | not timed | not timed | 148.62 ± 1.2% | 32.30 ± 8.0% | not timed | not timed | 197.82 ± 3.4% | | 0.98 | 1.31 | 6.03 |
| opt/fixed-length/too-small-ascii | 0 | 573.28 ± 4.9% | not timed | not timed | 1182.70 ± 0.6% | 173.92 ± 3.4% | not timed | not timed | 571.26 ± 2.0% | | 1.00 | 0.48 | 3.30 |
| opt/fixed-length/too-big-ascii | 0 | 1155.82 ± 6.5% | not timed | not timed | 9137.61 ± 10.9% | 218.78 ± 9.9% | not timed | not timed | 1153.71 ± 4.7% | | 1.00 | 0.13 | 5.28 |
| opt/fixed-length/go33484-1 | 0 | 93.41 ± 25.7% | not timed | not timed | 1765816.72 ± 22.0% | 128081.22 ± 42.4% | not timed | not timed | 93.22 ± 62.7% | | 1.00 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 7105.72 ± 2.1% | not timed | not timed | 1790135.88 ± 4.4% | 45520.77 ± 18.4% | not timed | not timed | 7104.42 ± 4.5% | | 1.00 | 0.0040 | 0.16 |
| opt/fixed-length/go33484-3 | 0 | 2359.72 ± 1.4% | not timed | not timed | 179328.54 ± 0.8% | 1323.01 ± 11.3% | not timed | not timed | 2311.57 ± 1.5% | | 1.02 | 0.0132 | 1.78 |
| opt/literal-alt/one-pattern | 1 | 737.68 ± 30.5% | not timed | not timed | 743.32 ± 58.0% | 0.66 ± 131.7% | not timed | not timed | 736.38 ± 116.3% | | 1.00 | 0.99 | 1125.39 |
| opt/onepass/fn-predicate | 916 | 533.12 ± 59.7% | not timed | not timed | 548.36 ± 29.7% | 294.08 ± 39.2% | not timed | not timed | 598.69 ± 86.8% | | 0.89 | 0.97 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 223.22 ± 14.2% | not timed | not timed | 318.35 ± 53.3% | 115.42 ± 7.5% | not timed | not timed | 223.64 ± 26.2% | | 1.00 | 0.70 | 1.93 |
| opt/prefilter/literal-english | 1 | 93647.72 ± 35.2% | not timed | not timed | 71049.11 ± 72.9% | 36704.06 ± 10.2% | not timed | not timed | 93751.59 ± 7.8% | | 1.00 | 1.32 | 2.55 |
| opt/prefilter/literal-casei-english | 1 | 71845.32 ± 0.8% | not timed | not timed | 19121.96 ± 0.1% | 54.81 ± 2.5% | not timed | not timed | 71575.68 ± 1.7% | | 1.00 | 3.76 | 1310.77 |
| opt/prefilter/literal-russian | 1 | 94870.39 ± 4.6% | not timed | not timed | 71166.68 ± 1.7% | 4353.53 ± 3.1% | not timed | not timed | 94728.92 ± 3.2% | | 1.00 | 1.33 | 21.79 |
| opt/prefilter/literal-casei-russian | 1 | 38108.70 ± 0.7% | not timed | not timed | 13677.04 ± 0.2% | 58.58 ± 2.5% | not timed | not timed | 38135.65 ± 2.3% | | 1.00 | 2.79 | 650.53 |
| opt/prefilter/rust-functions | 948 | 20910.98 ± 5.9% | not timed | not timed | 17108.78 ± 36.5% | 2500.01 ± 73.3% | not timed | not timed | 20793.93 ± 7.5% | | 1.01 | 1.22 | 8.36 |
| opt/reverse-anchored/word-end | 1 | 7023.67 ± 6.1% | not timed | not timed | 38514462.86 ± 4.4% | 82.70 ± 6.2% | not timed | not timed | 6986.40 ± 6.2% | | 1.01 | 0.0002 | 84.93 |
| opt/reverse-inner/holmes | 2593 | 741.74 ± 0.8% | not timed | not timed | 20285.27 ± 0.6% | 38.78 ± 0.4% | not timed | not timed | 743.95 ± 1.0% | | 1.00 | 0.0366 | 19.13 |
| opt/reverse-inner/email | 47 | 1228.74 ± 4.3% | not timed | not timed | 100704.98 ± 5.9% | 49.48 ± 4.4% | not timed | not timed | 1233.54 ± 3.9% | | 1.00 | 0.0122 | 24.83 |
| opt/reverse-inner/factored-prefix | 3542 | 731.36 ± 0.2% | not timed | not timed | 727.20 ± 0.2% | 20.52 ± 3.8% | not timed | not timed | 731.84 ± 0.8% | | 1.00 | 1.01 | 35.64 |
| opt/reverse-inner/no-quadratic-backward | 0 | 7034.57 ± 7.9% | not timed | not timed | 750.34 ± 3.6% | 125.61 ± 2.6% | not timed | not timed | 7072.60 ± 0.7% | | 0.99 | 9.38 | 56.00 |
| opt/reverse-inner/no-quadratic-forward | 0 | 870.93 ± 2.3% | not timed | not timed | 345.74 ± 0.1% | 40.24 ± 18.2% | not timed | not timed | 870.83 ± 2.2% | | 1.00 | 2.52 | 21.64 |
| opt/reverse-suffix/holmes | 4073 | 742.25 ± 0.1% | not timed | not timed | 17246.56 ± 1.6% | 38.40 ± 1.6% | not timed | not timed | 741.66 ± 0.3% | | 1.00 | 0.0430 | 19.33 |
| opt/reverse-suffix/no-quadratic | 0 | 7057.01 ± 2.8% | not timed | not timed | 749.43 ± 2.3% | 124.85 ± 2.7% | not timed | not timed | 7081.04 ± 0.4% | | 1.00 | 9.42 | 56.52 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 220.10 ± 5.7% | not timed | not timed | 272.04 ± 5.1% | 23.98 ± 13.7% | not timed | not timed | 215.72 ± 4.6% | | 1.02 | 0.81 | 9.18 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 220.48 ± 2.4% | not timed | not timed | 268.92 ± 5.9% | 24.58 ± 8.4% | not timed | not timed | 222.08 ± 2.6% | | 0.99 | 0.82 | 8.97 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.50 ± 7.5% | not timed | not timed | 0.80 ± 13.1% | 178.72 ± 7.0% | not timed | not timed | 0.49 ± 5.7% | | 1.00 | 0.62 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 384.95 ± 6.0% | not timed | not timed | 379.75 ± 4.1% | 159.56 ± 10.9% | not timed | not timed | 386.39 ± 3.8% | | 1.00 | 1.01 | 2.41 |
| reported/i13-subset-regex/original-ascii | 4094 | 15824.76 ± 5.6% | not timed | not timed | 5698.12 ± 0.9% | 15.89 ± 5.3% | not timed | not timed | 15569.21 ± 5.6% | | 1.02 | 2.78 | 995.72 |
| reported/i13-subset-regex/original-unicode | 4094 | 15721.88 ± 4.1% | not timed | not timed | 297.72 ± 7.2% | 15.91 ± 1.4% | not timed | not timed | 15807.41 ± 3.6% | | 0.99 | 52.81 | 988.19 |
| reported/i13-subset-regex/big-ascii | 1955 | 14765.74 ± 2.2% | not timed | not timed | 79.23 ± 5.2% | 13.80 ± 1.9% | not timed | not timed | 14727.93 ± 1.6% | | 1.00 | 186.37 | 1070.30 |
| reported/i13-subset-regex/big-unicode | 1955 | 14709.19 ± 0.8% | not timed | not timed | 13.60 ± 57.9% | 13.90 ± 2.1% | not timed | not timed | 14717.54 ± 5.2% | | 1.00 | 1081.72 | 1058.08 |
| reported/i13-subset-regex/huge-ascii | 55 | 13589.19 ± 5.0% | not timed | not timed | 14.15 ± 2.8% | 12.71 ± 2.5% | not timed | not timed | 13623.12 ± 2.3% | | 1.00 | 960.50 | 1068.76 |
| reported/i13-subset-regex/huge-unicode | 55 | 13601.30 ± 4.4% | not timed | not timed | 13.92 ± 2.3% | 12.77 ± 1.6% | not timed | not timed | 13523.32 ± 8.6% | | 1.01 | 977.31 | 1065.50 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.96 ± 6.1% | not timed | not timed | 13.98 ± 1.3% | 12.89 ± 3.8% | not timed | not timed | 5.96 ± 3.6% | | 1.00 | 0.43 | 0.46 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.64 ± 4.2% | not timed | not timed | 13.30 ± 6.2% | 12.46 ± 4.2% | not timed | not timed | 7.63 ± 3.2% | | 1.00 | 0.57 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 579.54 ± 5.1% | not timed | not timed | 217.29 ± 2.6% | 10.33 ± 6.1% | not timed | not timed | 584.08 ± 4.3% | | 0.99 | 2.67 | 56.13 |
| reported/i787-keywords/opt-ascii | 5674 | 599.90 ± 5.4% | not timed | not timed | 342.66 ± 3.8% | 17.96 ± 35.7% | not timed | not timed | 600.92 ± 3.3% | | 1.00 | 1.75 | 33.39 |
| slow/quadratic-regex-1x | 100 | 11.11 ± 0.8% | not timed | not timed | 8.81 ± 0.5% | 0.08 ± 2.3% | not timed | not timed | 11.10 ± 1.6% | | 1.00 | 1.26 | 138.32 |
| slow/quadratic-regex-2x | 199 | 4.64 ± 3.6% | not timed | not timed | 4.04 ± 5.0% | 0.02 ± 5.9% | not timed | not timed | 4.69 ± 1.8% | | 0.99 | 1.15 | 223.30 |
| slow/quadratic-haystack-1x | 100 | 41.06 ± 3.1% | not timed | not timed | 17.81 ± 3.4% | 1.47 ± 7.4% | not timed | not timed | 41.46 ± 4.4% | | 0.99 | 2.31 | 28.02 |
| slow/quadratic-haystack-2x | 200 | 31.75 ± 4.0% | not timed | not timed | 7.86 ± 17.3% | 0.80 ± 19.6% | not timed | not timed | 32.74 ± 6.8% | | 0.97 | 4.04 | 39.88 |
| unicode/codepoints/any-one | 1112064 | 534.74 ± 20.7% | not timed | not timed | 383.85 ± 4.6% | 29.50 ± 10.1% | not timed | not timed | 531.50 ± 7.4% | | 1.01 | 1.39 | 18.13 |
| unicode/codepoints/any-all | 4382592 | 351.80 ± 2.1% | not timed | not timed | 352.89 ± 1.7% | 201.19 ± 3.1% | not timed | not timed | 354.94 ± 1.4% | | 0.99 | 1.00 | 1.75 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 12.11 ± 5.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 749.76 ± 0.8% | not timed | not timed | 750.50 ± 4.3% | 230.20 ± 19.8% | not timed | not timed | 751.17 ± 0.8% | | 1.00 | 1.00 | 3.26 |
| unicode/overlapping-words/ascii | 6156 | 45.69 ± 5.0% | not timed | not timed | 58.38 ± 1.6% | 6.45 ± 4.0% | not timed | not timed | 45.36 ± 24.1% | | 1.01 | 0.78 | 7.08 |
| unicode/overlapping-words/english | 6156 | 2.24 ± 1.5% | not timed | not timed | 5.40 ± 2.6% | 3.85 ± 4.1% | not timed | not timed | 2.30 ± 4.6% | | 0.97 | 0.42 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 2.02 ± 1.5% | not timed | not timed | 5.20 ± 3.7% | 9.26 ± 6.8% | not timed | not timed | 2.01 ± 9.3% | | 1.00 | 0.39 | 0.22 |
| unicode/word/boundary-any-english | 450561 | 139.89 ± 10.0% | not timed | not timed | 111.43 ± 4.0% | 18.21 ± 28.8% | not timed | not timed | 138.77 ± 8.5% | | 1.01 | 1.26 | 7.68 |
| unicode/word/boundary-long-english | 3466 | 743.11 ± 4.4% | not timed | not timed | 725.80 ± 4.4% | 50.56 ± 17.7% | not timed | not timed | 742.57 ± 4.2% | | 1.00 | 1.02 | 14.70 |
| unicode/word/around-holmes-english | 27 | 748.84 ± 2.9% | not timed | not timed | 68250.19 ± 6.8% | 35.90 ± 2.6% | not timed | not timed | 744.89 ± 5.0% | | 1.01 | 0.0110 | 20.86 |
| wild/bibleref/long | 874 | 702.57 ± 3.3% | not timed | not timed | 712.88 ± 1.1% | 11.25 ± 4.9% | not timed | not timed | 705.84 ± 3.3% | | 1.00 | 0.99 | 62.46 |
| wild/bibleref/short | 30 | 36.93 ± 2.5% | not timed | not timed | 46.95 ± 2.7% | 23.26 ± 12.8% | not timed | not timed | 36.71 ± 8.1% | | 1.01 | 0.79 | 1.59 |
| wild/bibleref/line | 874 | 692.67 ± 5.9% | not timed | not timed | 346.09 ± 9.2% | 14.03 ± 8.2% | not timed | not timed | 702.09 ± 6.9% | | 0.99 | 2.00 | 49.38 |
| wild/caddy/caddy | 6 | 659.16 ± 11.9% | not timed | not timed | 367.00 ± 4.8% | 111.35 ± 12.3% | not timed | not timed | 641.84 ± 8.0% | | 1.03 | 1.80 | 5.92 |
| wild/dot-star-capture/rust-src-tools | 6 | 2156.58 ± 36.7% | not timed | not timed | 479.66 ± 3.8% | 23.11 ± 12.8% | not timed | not timed | 2125.98 ± 3.1% | | 1.01 | 4.50 | 93.33 |
| wild/ruff/noqa | 84 | 687.52 ± 3.6% | not timed | not timed | 697.97 ± 3.8% | 32.39 ± 7.9% | not timed | not timed | 685.06 ± 3.3% | | 1.00 | 0.99 | 21.23 |
| wild/ruff/unnecessary-coding-comment | 16 | 764.65 ± 0.9% | not timed | not timed | 935.94 ± 4.2% | 197.97 ± 12.2% | not timed | not timed | 763.31 ± 1.2% | | 1.00 | 0.82 | 3.86 |
| wild/ruff/string-quote-prefix | 2972 | 696.36 ± 2.6% | not timed | not timed | 705.73 ± 4.3% | 454.75 ± 28.7% | not timed | not timed | 695.06 ± 5.4% | | 1.00 | 0.99 | 1.53 |
| wild/ruff/space-around-operator | 1224378 | 323.59 ± 3.3% | not timed | not timed | 295.40 ± 2.5% | 27.88 ± 2.4% | not timed | not timed | 328.61 ± 3.1% | | 0.98 | 1.10 | 11.61 |
| wild/ruff/shebang | 282 | 669.79 ± 6.6% | not timed | not timed | 544.45 ± 3.8% | 167.03 ± 8.6% | not timed | not timed | 679.93 ± 4.0% | | 0.99 | 1.23 | 4.01 |
| wild/rustsec-cargo-audit/original-unix | 471 | 30812.01 ± 2.4% | not timed | not timed | 33158.15 ± 4.2% | 12628.90 ± 3.1% | not timed | not timed | 30416.23 ± 15.0% | | 1.01 | 0.93 | 2.44 |
| wild/rustsec-cargo-audit/original-windows | 462 | 28600.51 ± 3.9% | not timed | not timed | 31857.93 ± 2.8% | 11634.91 ± 6.4% | not timed | not timed | 28444.08 ± 5.6% | | 1.01 | 0.90 | 2.46 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 31721.41 ± 2.5% | not timed | not timed | 33305.51 ± 5.7% | 12134.40 ± 6.8% | not timed | not timed | 31522.09 ± 3.8% | | 1.01 | 0.95 | 2.61 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 26253.93 ± 9.1% | not timed | not timed | 33200.59 ± 2.0% | 12026.33 ± 46.6% | not timed | not timed | 25624.24 ± 19.0% | | 1.02 | 0.79 | 2.18 |
| wild/url/search | 234965 | 177.87 ± 27.0% | not timed | not timed | 86.06 ± 10.0% | 3.63 ± 4.2% | not timed | not timed | 184.93 ± 60.6% | | 0.96 | 2.07 | 49.02 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 2.7% | not timed | not timed | 0.01 ± 7.1% | 0.01 ± 20.8% | not timed | not timed | 0.04 ± 19.7% | | 0.99 | 2.95 | 4.50 |
| dictionary/compile/english-15 | 1 | 0.48 ± 1.3% | not timed | not timed | 0.11 ± 3.9% | 0.15 ± 31.8% | not timed | not timed | 0.47 ± 5.2% | | 1.01 | 4.17 | 3.20 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.43 ± 3.4% | not timed | not timed | 0.03 ± 6.7% | 50.94 ± 1.3% | not timed | not timed | 0.44 ± 5.2% | | 0.99 | 13.62 | 0.0084 |
| reported/i1095-word-repetition/ascii-compile | 1 | 59.53 ± 7.7% | not timed | not timed | 19.87 ± 5.4% | 83.90 ± 13.1% | not timed | not timed | 60.48 ± 3.0% | | 0.98 | 3.00 | 0.71 |
| reported/i787-keywords/compile | 1 | 56.30 ± 6.9% | not timed | not timed | 3.25 ± 4.7% | 26.51 ± 20.8% | not timed | not timed | 57.14 ± 7.7% | | 0.99 | 17.30 | 2.12 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 614.29 ± 39.0% | not timed | not timed | 208.93 ± 44.1% | 782.20 ± 27.8% | not timed | not timed | 581.22 ± 14.5% | | 1.06 | 2.94 | 0.79 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 79.41 ± 2.7% | not timed | not timed | 7.41 ± 18.5% | 65.51 ± 9.2% | not timed | not timed | 78.23 ± 7.5% | | 1.02 | 10.72 | 1.21 |
| unicode/compile/one-letter | 53 | 10.73 ± 14.9% | not timed | not timed | 7.91 ± 12.5% | 91.14 ± 17.2% | not timed | not timed | 10.74 ± 18.4% | | 1.00 | 1.36 | 0.12 |
| unicode/compile/fifty-letters | 1 | 1.90 ± 8.6% | not timed | not timed | 0.17 ± 3.2% | 91.00 ± 10.9% | not timed | not timed | 1.75 ± 17.2% | | 1.08 | 10.89 | 0.0209 |
| unicode/compile/fifty-letters-ascii | 1 | 311.16 ± 7.8% | not timed | not timed | 87.45 ± 0.6% | 269.42 ± 6.5% | not timed | not timed | 314.93 ± 6.2% | | 0.99 | 3.56 | 1.15 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 657.52 ± 15.0% | not timed | not timed | 63.82 ± 2.3% | 1000.16 ± 5.2% | not timed | not timed | 675.42 ± 7.0% | | 0.97 | 10.30 | 0.66 |
| unicode/compile/match-every-line-ascii | 4 | 1117.89 ± 18.1% | not timed | not timed | 226.51 ± 2.8% | 969.54 ± 10.4% | not timed | not timed | 1140.44 ± 4.5% | | 0.98 | 4.94 | 1.15 |
| unicode/compile/negated-class-matches-codepoint | 1 | 566.74 ± 18.6% | not timed | not timed | 68.86 ± 13.0% | 1841.43 ± 14.0% | not timed | not timed | 561.21 ± 38.8% | | 1.01 | 8.23 | 0.31 |
| wild/bibleref/compile | 3 | 9.57 ± 16.0% | not timed | not timed | 3.37 ± 3.5% | 45.16 ± 12.1% | not timed | not timed | 8.85 ± 47.0% | | 1.08 | 2.84 | 0.21 |
| wild/url/compile | 1 | 1.03 ± 19.3% | not timed | not timed | 0.23 ± 4.9% | 0.60 ± 43.2% | not timed | not timed | 1.01 ± 5.2% | | 1.02 | 4.38 | 1.70 |

