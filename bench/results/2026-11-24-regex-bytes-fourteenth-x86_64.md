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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391548887 |
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
| literal: a word | 217 | 65927.56 ± 4.0% | 6474.16 ± 1.6% | 47.06 ± 1.1% | 54377.82 ± 7.8% | 16553.00 ± 3.8% | 16.54 ± 1.6% | 157.98 ± 3.2% | 64775.31 ± 10.3% | 10.18 | 1.02 | 1.21 | 3.98 |
| literal: a word that is not there | 0 | 87425.35 ± 2.7% | 6341.53 ± 1.3% | 46.79 ± 1.2% | 67357.95 ± 0.7% | 58099.67 ± 1.6% | 16.20 ± 0.7% | 147.40 ± 1.0% | 87210.06 ± 2.7% | 13.79 | 1.00 | 1.30 | 1.50 |
| literal: one of four words | 661 | 20157.29 ± 0.8% | 2411.98 ± 0.5% | 25.42 ± 0.1% | 14991.74 ± 4.3% | 40.13 ± 4.5% | 5.22 ± 1.7% | 13.25 ± 2.6% | 20144.67 ± 0.9% | 8.36 | 1.00 | 1.34 | 502.28 |
| literal: a word in any case | 217 | 60778.63 ± 0.9% | 2624.03 ± 1.8% | 32.39 ± 0.6% | 14841.06 ± 0.3% | 74.71 ± 7.5% | refused | differs | 61516.54 ± 4.6% | 23.16 | 0.99 | 4.10 | 813.55 |
| literal: an href attribute | 33 | 53712.16 ± 1.0% | 757.31 ± 0.2% | 39.08 ± 1.8% | 47384.87 ± 3.8% | 3619.32 ± 0.9% | 11.82 ± 0.5% | 133.05 ± 3.8% | 53571.11 ± 1.9% | 70.92 | 1.00 | 1.13 | 14.84 |
| literal: a word, second text | 123 | 67747.74 ± 1.3% | 4606.84 ± 0.2% | 45.86 ± 1.3% | 50706.59 ± 8.3% | 15226.55 ± 4.7% | 21.80 ± 5.5% | 128.47 ± 3.3% | 68481.82 ± 2.1% | 14.71 | 0.99 | 1.34 | 4.45 |
| class: two capitalized words | 1331 | 1131.49 ± 0.7% | 743.45 ± 0.8% | 42.45 ± 2.7% | 713.82 ± 1.9% | 63.92 ± 4.0% | 14.41 ± 0.4% | 106.19 ± 9.3% | 1130.17 ± 1.6% | 1.52 | 1.00 | 1.59 | 17.70 |
| class: a word that ends in ing | 3399 | 711.80 ± 0.4% | 711.93 ± 0.3% | 28.14 ± 3.1% | 665.50 ± 2.7% | 47.46 ± 11.4% | 8.23 ± 0.5% | 29.97 ± 2.1% | 712.79 ± 0.4% | 1.00 | 1.00 | 1.07 | 15.00 |
| class: a word in capitals | 2332 | 1619.01 ± 4.5% | 743.67 ± 1.3% | 43.85 ± 2.7% | 699.30 ± 0.4% | 67.33 ± 8.5% | 16.79 ± 4.6% | 135.85 ± 5.0% | 1628.12 ± 0.8% | 2.18 | 0.99 | 2.32 | 24.05 |
| class: a number | 8288 | 2655.62 ± 0.8% | 1009.32 ± 1.1% | 44.83 ± 6.9% | 2364.02 ± 1.6% | 60.43 ± 26.1% | 0.46 ± 1.3% | 98.29 ± 1.3% | 2679.25 ± 3.4% | 2.63 | 0.99 | 1.12 | 43.95 |
| class: two capitalized words, second text | 5359 | 629.57 ± 0.5% | 639.54 ± 0.3% | 38.40 ± 1.0% | 594.01 ± 1.1% | 53.67 ± 10.4% | 18.26 ± 0.4% | 98.93 ± 3.9% | 628.19 ± 0.5% | 0.98 | 1.00 | 1.06 | 11.73 |
| other: a word between two words | 6104 | 1134.85 ± 3.9% | 724.41 ± 2.5% | 35.78 ± 1.6% | 952.21 ± 0.9% | 173.66 ± 5.1% | 10.91 ± 5.4% | 113.31 ± 3.5% | 1135.33 ± 0.6% | 1.57 | 1.00 | 1.19 | 6.53 |
| other: a number before a unit, second text | 1481 | 13258.65 ± 6.7% | 1474.60 ± 1.7% | 42.56 ± 1.0% | 11106.21 ± 5.2% | 60.43 ± 8.1% | 19.71 ± 3.8% | 106.30 ± 6.0% | 13237.85 ± 2.2% | 8.99 | 1.00 | 1.19 | 219.40 |
| other: a heading's start tag | 110 | 32402.02 ± 0.8% | 918.82 ± 4.7% | 43.12 ± 0.8% | 3443.41 ± 5.5% | 2641.01 ± 9.5% | 14.87 ± 3.4% | 156.17 ± 15.4% | 32468.45 ± 0.5% | 35.26 | 1.00 | 9.41 | 12.27 |
| other: a whole word | 217 | 40854.10 ± 0.3% | 746.25 ± 0.3% | 47.17 ± 0.5% | 37281.17 ± 11.7% | 78.35 ± 5.9% | 13.79 ± 1.1% | 87.03 ± 2.4% | 40925.11 ± 0.5% | 54.75 | 1.00 | 1.10 | 521.41 |
| other: a line's first word, second text | 3716 | 3515.26 ± 4.0% | 725.22 ± 2.5% | 50.46 ± 71.2% | 3619.90 ± 6.4% | 103.69 ± 4.7% | refused | refused | 3530.18 ± 2.2% | 4.85 | 1.00 | 0.97 | 33.90 |
| other: fourteen octets before an x | 87 | 53490.89 ± 1.3% | 411.04 ± 3.8% | 9.31 ± 5.6% | 5146.08 ± 3.0% | 14.95 ± 3.5% | differs | 25.98 ± 6.9% | 52621.40 ± 3.4% | 130.13 | 1.02 | 10.39 | 3577.02 |
| other: a Greek word | 21815 | 618.97 ± 4.8% | 495.23 ± 1.9% | 49.67 ± 1.7% | 367.22 ± 1.5% | 62.25 ± 21.9% | differs | refused | 620.94 ± 0.3% | 1.25 | 1.00 | 1.69 | 9.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.11 ± 0.4% | 27.90 ± 1.8% | 1.62 ± 5.3% | 25.01 ± 0.1% | 3.79 ± 1.5% | differs | 5.99 ± 0.9% | 28.20 ± 0.2% | 1.01 | 1.00 | 1.12 | 7.41 |
| a UUID | 32895 | 30.82 ± 3.5% | 30.95 ± 7.2% | 1.07 ± 6.0% | 19.01 ± 35.6% | 3.72 ± 8.2% | 0.77 ± 4.2% | 4.82 ± 4.4% | 30.65 ± 4.0% | 1.00 | 1.01 | 1.62 | 8.29 |
| an IPv4 address | 33176 | 46.44 ± 9.5% | 46.41 ± 6.2% | 3.41 ± 7.1% | 35.30 ± 7.5% | 9.40 ± 8.7% | differs | 5.76 ± 13.1% | 46.86 ± 8.5% | 1.00 | 0.99 | 1.32 | 4.94 |
| a date and time | 32954 | 45.36 ± 4.6% | 46.08 ± 3.9% | 2.59 ± 4.5% | 27.24 ± 6.5% | 11.15 ± 37.1% | 1.35 ± 3.7% | 10.92 ± 12.8% | 45.81 ± 4.2% | 0.98 | 0.99 | 1.67 | 4.07 |
| a field path | 32606 | 32.04 ± 1.5% | 32.06 ± 2.4% | 1.76 ± 0.7% | 28.90 ± 35.4% | 4.88 ± 55.5% | differs | 4.24 ± 37.4% | 32.23 ± 14.7% | 1.00 | 0.99 | 1.11 | 6.57 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 16.23 ± 4.6% | 16.44 ± 6.8% | 16.41 ± 0.5% | 18.28 ± 1.4% | 7.86 ± 3.5% | 1.08 ± 3.6% | none | 16.33 ± 6.1% | 0.99 | 0.99 | 0.89 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 356.12 ± 6.3% | 368.15 ± 4.9% | 420.16 ± 7.4% | 135.59 ± 6.9% | 329.72 ± 25.8% | 929.31 ± 4.7% | 6038.84 ± 6.7% | 367.39 ± 6.1% | 0.97 | 0.97 | 2.63 | 1.08 |
| a UUID | 62 | 236.34 ± 5.8% | 248.61 ± 4.2% | 273.39 ± 4.2% | 78.52 ± 2.1% | 164.66 ± 29.3% | 322.64 ± 7.8% | 7341.32 ± 5.7% | 246.93 ± 0.7% | 0.95 | 0.96 | 3.01 | 1.44 |
| an IPv4 address | 29 | 724.31 ± 5.0% | 744.69 ± 2.8% | 993.92 ± 7.9% | 127.49 ± 3.0% | 216.10 ± 1.5% | 592.40 ± 1.2% | 13574.89 ± 6.9% | 730.63 ± 6.2% | 0.97 | 0.99 | 5.68 | 3.35 |
| a date and time | 56 | 523.82 ± 1.8% | 532.05 ± 1.3% | 651.12 ± 2.0% | 120.70 ± 1.4% | 231.85 ± 2.8% | 595.80 ± 11.9% | 8197.58 ± 4.7% | 527.92 ± 3.5% | 0.98 | 0.99 | 4.34 | 2.26 |
| a field path | 39 | 378.52 ± 5.1% | 383.15 ± 4.8% | 439.71 ± 3.3% | 134.19 ± 1.7% | 320.17 ± 6.1% | 951.22 ± 2.7% | 7712.87 ± 1.9% | 381.26 ± 3.4% | 0.99 | 0.99 | 2.82 | 1.18 |
| literal: a word | 7 | 1080.79 ± 4.0% | 1218.96 ± 4.9% | 2085.28 ± 2.5% | 898.08 ± 2.5% | 1066.40 ± 19.9% | 1894.02 ± 1.8% | 50219.38 ± 4.6% | 1119.37 ± 1.7% | 0.89 | 0.97 | 1.20 | 1.01 |
| literal: a word that is not there | 8 | 1047.34 ± 9.3% | 1148.62 ± 5.7% | 1906.95 ± 6.7% | 813.24 ± 3.2% | 1040.89 ± 20.1% | 1803.07 ± 5.3% | 49437.66 ± 1.5% | 1051.31 ± 5.9% | 0.91 | 1.00 | 1.29 | 1.01 |
| literal: one of four words | 26 | 423.56 ± 6.6% | 644.49 ± 7.2% | 827.55 ± 5.2% | 68.66 ± 7.4% | 408.41 ± 6.5% | 694.72 ± 0.9% | 24728.63 ± 3.9% | 407.49 ± 4.4% | 0.66 | 1.04 | 6.17 | 1.04 |
| literal: a word in any case | 11 | 788.47 ± 2.4% | 841.36 ± 0.2% | 1190.34 ± 1.3% | 23.93 ± 2.9% | 1140.92 ± 1.3% | refused | 38953.48 ± 10.3% | 786.59 ± 1.6% | 0.94 | 1.00 | 32.95 | 0.69 |
| literal: an href attribute | 12 | 582.90 ± 10.0% | 604.25 ± 7.3% | 785.74 ± 3.1% | 64.12 ± 0.7% | 790.57 ± 8.6% | 1511.66 ± 3.5% | 35690.76 ± 4.8% | 583.57 ± 2.4% | 0.96 | 1.00 | 9.09 | 0.74 |
| literal: a word, second text | 10 | 974.69 ± 8.4% | 1074.82 ± 3.5% | 1733.91 ± 1.7% | 752.78 ± 2.2% | 882.32 ± 42.2% | 1534.09 ± 5.5% | 46895.33 ± 32.1% | 967.74 ± 65.3% | 0.91 | 1.01 | 1.29 | 1.10 |
| class: two capitalized words | 23 | 791.12 ± 1.5% | 849.07 ± 1.3% | 1211.18 ± 2.0% | 166.02 ± 8.0% | 837.69 ± 2.6% | 1478.66 ± 2.5% | 9966.43 ± 10.7% | 789.33 ± 0.9% | 0.93 | 1.00 | 4.77 | 0.94 |
| class: a word that ends in ing | 9 | 984.65 ± 6.3% | 1115.88 ± 1.6% | 1862.00 ± 7.6% | 212.73 ± 3.1% | 1156.84 ± 12.6% | 2288.57 ± 2.4% | 24269.65 ± 0.7% | 980.75 ± 4.1% | 0.88 | 1.00 | 4.63 | 0.85 |
| class: a word in capitals | 16 | 884.60 ± 1.1% | 962.46 ± 0.4% | 1483.94 ± 5.4% | 216.53 ± 6.2% | 1237.11 ± 10.6% | 2075.16 ± 6.1% | 13029.93 ± 5.1% | 881.63 ± 2.4% | 0.92 | 1.00 | 4.09 | 0.72 |
| class: a number | 6 | 1078.10 ± 6.4% | 1210.80 ± 4.4% | 2185.75 ± 3.6% | 62.03 ± 2.2% | 2254.36 ± 5.3% | 3740.82 ± 6.3% | 37849.50 ± 9.0% | 1099.59 ± 6.6% | 0.89 | 0.98 | 17.38 | 0.48 |
| class: two capitalized words, second text | 23 | 755.73 ± 5.8% | 818.48 ± 4.3% | 1149.57 ± 5.2% | 156.23 ± 5.8% | 780.73 ± 9.5% | 1399.99 ± 2.1% | 9521.45 ± 0.8% | 752.41 ± 4.9% | 0.92 | 1.00 | 4.84 | 0.97 |
| other: a word between two words | 13 | 893.31 ± 2.5% | 952.85 ± 3.4% | 1447.45 ± 4.3% | 211.55 ± 1.9% | 766.30 ± 0.9% | 1546.03 ± 4.4% | 23149.83 ± 3.1% | 894.34 ± 7.6% | 0.94 | 1.00 | 4.22 | 1.17 |
| other: a number before a unit, second text | 15 | 657.17 ± 4.4% | 738.61 ± 3.6% | 1017.75 ± 6.0% | 56.03 ± 4.8% | 941.65 ± 2.0% | 1691.58 ± 5.9% | 23942.76 ± 10.6% | 654.63 ± 1.8% | 0.89 | 1.00 | 11.73 | 0.70 |
| other: a heading's start tag | 13 | 570.77 ± 8.2% | 590.43 ± 6.5% | 791.89 ± 6.1% | 58.29 ± 11.0% | 889.51 ± 5.1% | 1635.99 ± 1.2% | 28276.77 ± 15.4% | 594.18 ± 22.5% | 0.97 | 0.96 | 9.79 | 0.64 |
| other: a whole word | 11 | 988.81 ± 2.6% | 1073.04 ± 1.9% | 1688.66 ± 1.7% | 193.94 ± 7.2% | 949.01 ± 0.9% | 1675.68 ± 5.4% | 44216.24 ± 2.6% | 987.31 ± 4.5% | 0.92 | 1.00 | 5.10 | 1.04 |
| other: a line's first word, second text | 17 | 903.56 ± 2.3% | 964.04 ± 5.6% | 1470.58 ± 13.6% | 207.75 ± 3.1% | 1102.04 ± 0.6% | refused | refused | 909.15 ± 1.3% | 0.94 | 0.99 | 4.35 | 0.82 |
| other: fourteen octets before an x | 16 | 186.48 ± 2.0% | 258.27 ± 6.5% | 294.92 ± 1.8% | 23.54 ± 7.2% | 720.98 ± 38.5% | 781.77 ± 2.7% | 21316.21 ± 0.6% | 185.60 ± 7.0% | 0.72 | 1.00 | 7.92 | 0.26 |
| other: a Greek word | 8 | 734.96 ± 1.6% | 996.22 ± 6.2% | 1591.95 ± 3.0% | 77.55 ± 9.6% | 2228.38 ± 3.3% | 3585.19 ± 6.7% | refused | 738.00 ± 7.0% | 0.74 | 1.00 | 9.48 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 46948.65 ± 2.9% | not timed | not timed | 46037.01 ± 11.1% | 3642.99 ± 49.1% | not timed | not timed | 46802.53 ± 2.1% | | 1.00 | 1.02 | 12.89 |
| 01-literal/sherlock-casei-en | 522 | 42304.41 ± 6.3% | not timed | not timed | 11924.74 ± 0.6% | 53.37 ± 20.6% | not timed | not timed | 42117.87 ± 3.6% | | 1.00 | 3.55 | 792.72 |
| 01-literal/sherlock-ru | 724 | 47840.72 ± 3.0% | not timed | not timed | 44752.46 ± 4.0% | 2483.51 ± 8.1% | not timed | not timed | 47798.50 ± 3.5% | | 1.00 | 1.07 | 19.26 |
| 01-literal/sherlock-casei-ru | 746 | 15622.88 ± 0.9% | not timed | not timed | 9739.45 ± 0.3% | 58.64 ± 3.0% | not timed | not timed | 15699.08 ± 1.2% | | 1.00 | 1.60 | 266.44 |
| 01-literal/sherlock-zh | 30 | 83214.38 ± 1.2% | not timed | not timed | 61183.86 ± 1.7% | 2181.17 ± 1.3% | not timed | not timed | 83180.76 ± 2.0% | | 1.00 | 1.36 | 38.15 |
| 02-literal-alternate/sherlock-en | 714 | 17095.30 ± 3.7% | not timed | not timed | 13846.06 ± 9.2% | 29.64 ± 1.1% | not timed | not timed | 17103.83 ± 6.0% | | 1.00 | 1.23 | 576.79 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3199.42 ± 5.3% | not timed | not timed | 3069.69 ± 1.1% | 18.78 ± 2.0% | not timed | not timed | 3191.13 ± 6.1% | | 1.00 | 1.04 | 170.35 |
| 02-literal-alternate/sherlock-ru | 899 | 12965.76 ± 10.8% | not timed | not timed | 7628.79 ± 1.8% | 39.32 ± 2.1% | not timed | not timed | 12698.35 ± 38.3% | | 1.02 | 1.70 | 329.77 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2818.02 ± 6.7% | not timed | not timed | 1476.48 ± 4.6% | 16.29 ± 2.6% | not timed | not timed | 2828.78 ± 7.2% | | 1.00 | 1.91 | 172.95 |
| 02-literal-alternate/sherlock-zh | 207 | 25103.36 ± 1.0% | not timed | not timed | 16465.11 ± 0.7% | 55.32 ± 0.3% | not timed | not timed | 25061.32 ± 0.9% | | 1.00 | 1.52 | 453.77 |
| 03-date/ascii | 111817 | 159.59 ± 7.2% | not timed | not timed | 125.19 ± 4.2% | 0.31 ± 2.1% | not timed | not timed | 161.26 ± 2.8% | | 0.99 | 1.27 | 507.22 |
| 04-ruff-noqa/real | 84 | 688.35 ± 3.8% | not timed | not timed | 703.80 ± 5.8% | 32.29 ± 3.2% | not timed | not timed | 688.54 ± 0.5% | | 1.00 | 0.98 | 21.32 |
| 04-ruff-noqa/tweaked | 44 | 867.08 ± 3.6% | not timed | not timed | 723.20 ± 4.9% | 498.89 ± 13.7% | not timed | not timed | 859.75 ± 3.7% | | 1.01 | 1.20 | 1.74 |
| 05-lexer-veryl/single | 124800 | 6.82 ± 9.4% | not timed | not timed | 7.51 ± 8.0% | 0.35 ± 6.5% | not timed | not timed | 7.29 ± 10.8% | | 0.94 | 0.91 | 19.45 |
| 06-cloud-flare-redos/original | 107 | 527.52 ± 2.5% | not timed | not timed | 281.27 ± 0.7% | 37.10 ± 5.3% | not timed | not timed | 526.18 ± 4.7% | | 1.00 | 1.88 | 14.22 |
| 06-cloud-flare-redos/simplified-short | 102 | 531.08 ± 13.0% | not timed | not timed | 298.01 ± 0.1% | 39.89 ± 0.9% | not timed | not timed | 530.23 ± 1.2% | | 1.00 | 1.78 | 13.31 |
| 06-cloud-flare-redos/simplified-long | 10000 | 642.05 ± 0.4% | not timed | not timed | 317.56 ± 0.8% | 44.35 ± 1.0% | not timed | not timed | 642.06 ± 0.5% | | 1.00 | 2.02 | 14.48 |
| 07-unicode-character-data/parse-line | 558784 | 338.33 ± 4.1% | not timed | not timed | 245.10 ± 7.8% | 64.75 ± 4.0% | not timed | not timed | 344.41 ± 3.5% | | 0.98 | 1.38 | 5.23 |
| 08-words/all-english | 56691 | 132.64 ± 0.8% | not timed | not timed | 100.06 ± 1.0% | 20.33 ± 17.3% | not timed | not timed | 133.00 ± 0.6% | | 1.00 | 1.33 | 6.53 |
| 08-words/long-english | 839 | 718.26 ± 1.1% | not timed | not timed | 688.77 ± 1.2% | 47.99 ± 1.7% | not timed | not timed | 716.77 ± 0.9% | | 1.00 | 1.04 | 14.97 |
| 09-aws-keys/full | 0 | 667.63 ± 0.2% | not timed | not timed | 696.58 ± 1.1% | 95.29 ± 3.8% | not timed | not timed | 666.37 ± 0.7% | | 1.00 | 0.96 | 7.01 |
| 09-aws-keys/quick | 0 | 1447.51 ± 4.7% | not timed | not timed | 1226.24 ± 1.0% | 535.06 ± 1.9% | not timed | not timed | 1456.20 ± 1.5% | | 0.99 | 1.18 | 2.71 |
| 10-bounded-repeat/letters-en | 1833 | 829.65 ± 6.5% | not timed | not timed | 732.79 ± 1.4% | 29.51 ± 0.6% | not timed | not timed | 829.32 ± 1.3% | | 1.00 | 1.13 | 28.11 |
| 10-bounded-repeat/letters-ru | 3475 | 704.85 ± 0.8% | not timed | not timed | 639.81 ± 7.3% | 30.07 ± 12.1% | not timed | not timed | 702.88 ± 1.6% | | 1.00 | 1.10 | 23.44 |
| 10-bounded-repeat/context | 53 | 115.07 ± 3.3% | not timed | not timed | 88.33 ± 1.4% | 28.78 ± 12.8% | not timed | not timed | 112.26 ± 0.5% | | 1.03 | 1.30 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 787.89 ± 4.9% | not timed | not timed | 746.41 ± 8.5% | 54.00 ± 2.0% | not timed | not timed | 789.11 ± 8.1% | | 1.00 | 1.06 | 14.59 |
| 11-unstructured-to-json/extract | 600 | 78.64 ± 2.0% | not timed | not timed | 108.98 ± 6.1% | 79.27 ± 0.9% | not timed | not timed | 78.66 ± 6.2% | | 1.00 | 0.72 | 0.99 |
| 12-dictionary/single | 1 | 674.02 ± 0.4% | not timed | not timed | 644.42 ± 1.6% | 0.67 ± 2.5% | not timed | not timed | 674.06 ± 3.5% | | 1.00 | 1.05 | 1009.26 |
| 14-quadratic/1x | 100 | 39.69 ± 5.5% | not timed | not timed | 17.74 ± 2.7% | 1.48 ± 6.1% | not timed | not timed | 40.89 ± 3.8% | | 0.97 | 2.24 | 26.89 |
| 14-quadratic/2x | 200 | 31.54 ± 23.2% | not timed | not timed | 8.27 ± 2.5% | 0.82 ± 13.2% | not timed | not timed | 33.02 ± 2.4% | | 0.96 | 3.81 | 38.64 |
| 14-quadratic/10x | 1000 | 10.73 ± 20.6% | not timed | not timed | 1.51 ± 9.5% | 0.18 ± 8.2% | not timed | not timed | 11.35 ± 6.7% | | 0.94 | 7.10 | 59.35 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.95 ± 28.9% | not timed | not timed | 0.55 ± 2.7% | 0.87 ± 51.0% | not timed | not timed | 2.01 ± 30.0% | | 0.97 | 3.55 | 2.25 |
| 04-ruff-noqa/compile-real | 1 | 187.10 ± 4.1% | not timed | not timed | 22.22 ± 3.5% | 231.54 ± 2.3% | not timed | not timed | 193.39 ± 5.1% | | 0.97 | 8.42 | 0.81 |
| 05-lexer-veryl/compile-single | 1 | 23.64 ± 2.0% | not timed | not timed | 4.10 ± 4.6% | 11.32 ± 6.0% | not timed | not timed | 23.44 ± 7.7% | | 1.01 | 5.77 | 2.09 |
| 07-unicode-character-data/compile | 1 | 184.72 ± 2.4% | not timed | not timed | 42.28 ± 1.7% | 63.28 ± 2.5% | not timed | not timed | 177.64 ± 5.3% | | 1.04 | 4.37 | 2.92 |
| 09-aws-keys/compile-full | 1 | 79.25 ± 0.8% | not timed | not timed | 12.98 ± 2.5% | 39.30 ± 2.8% | not timed | not timed | 78.89 ± 3.6% | | 1.00 | 6.11 | 2.02 |
| 09-aws-keys/compile-quick | 1 | 298.67 ± 3.4% | not timed | not timed | 81.29 ± 2.2% | 226.20 ± 4.5% | not timed | not timed | 299.38 ± 2.5% | | 1.00 | 3.67 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 89.67 ± 3.2% | not timed | not timed | 18.19 ± 1.5% | 27.82 ± 5.0% | not timed | not timed | 89.87 ± 0.5% | | 1.00 | 4.93 | 3.22 |
| 10-bounded-repeat/compile-capitals | 1 | 130.82 ± 6.0% | not timed | not timed | 13.16 ± 5.2% | 39.37 ± 4.6% | not timed | not timed | 133.11 ± 2.0% | | 0.98 | 9.94 | 3.32 |
| 11-unstructured-to-json/compile | 1 | 290.79 ± 2.2% | not timed | not timed | 66.37 ± 4.1% | 117.81 ± 1.7% | not timed | not timed | 290.51 ± 2.2% | | 1.00 | 4.38 | 2.47 |
| 12-dictionary/compile-single | 1 | 0.47 ± 4.6% | not timed | not timed | 0.10 ± 2.5% | 0.15 ± 37.9% | not timed | not timed | 0.47 ± 0.7% | | 1.00 | 4.65 | 3.16 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.63 ± 6.1% | not timed | not timed | 9.17 ± 3.5% | 0.96 ± 16.9% | not timed | not timed | 11.16 ± 8.3% | | 0.95 | 1.16 | 11.07 |
| dictionary/search/english-10 | 690 | 1.89 ± 5.3% | not timed | not timed | 260.74 ± 1.6% | 0.01 ± 1.4% | not timed | not timed | 1.89 ± 3.4% | | 1.00 | 0.0073 | 169.20 |
| dictionary/search/english-15 | 15 | 675.35 ± 0.1% | not timed | not timed | 647.83 ± 0.4% | 0.65 ± 1.1% | not timed | not timed | 674.83 ± 0.4% | | 1.00 | 1.04 | 1041.53 |
| folly/awyer-inn-busted | 1 | 7249.82 ± 4.4% | not timed | not timed | 171.79 ± 0.8% | 73.84 ± 7.1% | not timed | not timed | 7258.20 ± 4.0% | | 1.00 | 42.20 | 98.18 |
| folly/literal-never-match-rare | 0 | 89130.16 ± 0.8% | not timed | not timed | 69934.25 ± 4.8% | 94515.13 ± 5.7% | not timed | not timed | 89209.11 ± 0.6% | | 1.00 | 1.27 | 0.94 |
| folly/literal-never-match-frequent | 0 | 39955.99 ± 11.6% | not timed | not timed | 68521.87 ± 2.5% | 3065.11 ± 1.2% | not timed | not timed | 41336.15 ± 8.1% | | 0.97 | 0.58 | 13.04 |
| folly/literal-never-match-tricksy | 1 | 5718.34 ± 5.7% | not timed | not timed | 8913.86 ± 4.5% | 3937.69 ± 4.8% | not timed | not timed | 5700.88 ± 4.7% | | 1.00 | 0.64 | 1.45 |
| grep/every-line | 239963 | 1860.92 ± 5.0% | not timed | not timed | 1327.39 ± 46.2% | 515.87 ± 27.6% | not timed | not timed | 1854.99 ± 96.3% | | 1.00 | 1.40 | 3.61 |
| grep/long-words-ascii | 5073 | 672.85 ± 10.0% | not timed | not timed | 634.70 ± 4.9% | 68.19 ± 9.8% | not timed | not timed | 678.92 ± 5.8% | | 0.99 | 1.06 | 9.87 |
| imported/leipzig/twain | 811 | 76495.77 ± 1.0% | not timed | not timed | 62408.17 ± 3.1% | 15645.72 ± 9.9% | not timed | not timed | 76734.80 ± 0.6% | | 1.00 | 1.23 | 4.89 |
| imported/leipzig/twain-insensitive | 965 | 19952.59 ± 0.3% | not timed | not timed | 17826.33 ± 7.5% | 66.72 ± 4.2% | not timed | not timed | 19965.97 ± 4.0% | | 1.00 | 1.12 | 299.05 |
| imported/leipzig/shing | 1540 | 775.18 ± 0.1% | not timed | not timed | 29477.39 ± 3.3% | 54.53 ± 1.2% | not timed | not timed | 775.09 ± 0.5% | | 1.00 | 0.0263 | 14.22 |
| imported/leipzig/huck-saw | 262 | 36074.77 ± 0.5% | not timed | not timed | 24882.87 ± 3.1% | 55.29 ± 5.4% | not timed | not timed | 36079.49 ± 3.9% | | 1.00 | 1.45 | 652.44 |
| imported/leipzig/word-ending-nn | 262 | 729.95 ± 4.5% | not timed | not timed | 748.98 ± 1.1% | 41.72 ± 2.0% | not timed | not timed | 749.33 ± 1.8% | | 0.97 | 0.97 | 17.50 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 15664.90 ± 10.0% | not timed | not timed | 5742.19 ± 4.1% | 15.92 ± 3.1% | not timed | not timed | 15821.63 ± 0.9% | | 0.99 | 2.73 | 984.27 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 29074.78 ± 4.5% | not timed | not timed | 22685.60 ± 49.2% | 30.56 ± 2.5% | not timed | not timed | 28142.59 ± 16.7% | | 1.03 | 1.28 | 951.32 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6831.50 ± 1.2% | not timed | not timed | 1192.37 ± 2.2% | 18.68 ± 1.5% | not timed | not timed | 6830.47 ± 0.5% | | 1.00 | 5.73 | 365.77 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 734.42 ± 4.7% | not timed | not timed | 746.64 ± 0.4% | 19.34 ± 3.2% | not timed | not timed | 746.04 ± 6.2% | | 0.98 | 0.98 | 37.97 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 747.40 ± 0.3% | not timed | not timed | 747.65 ± 2.4% | 16.89 ± 3.6% | not timed | not timed | 748.31 ± 0.3% | | 1.00 | 1.00 | 44.25 |
| imported/leipzig/tom-river | 2 | 17373.90 ± 1.1% | not timed | not timed | 18134.03 ± 0.5% | 54.69 ± 0.8% | not timed | not timed | 17325.50 ± 1.0% | | 1.00 | 0.96 | 317.66 |
| imported/leipzig/ing | 78424 | 733.65 ± 3.0% | not timed | not timed | 689.78 ± 6.9% | 45.67 ± 5.5% | not timed | not timed | 731.28 ± 4.0% | | 1.00 | 1.06 | 16.06 |
| imported/leipzig/ing-whitespace | 55248 | 911.17 ± 5.1% | not timed | not timed | 2923.60 ± 2.2% | 33.97 ± 6.8% | not timed | not timed | 923.54 ± 2.1% | | 0.99 | 0.31 | 26.82 |
| imported/leipzig/awyer-inn | 209 | 948.96 ± 1.0% | not timed | not timed | 18353.81 ± 1.1% | 35.75 ± 2.5% | not timed | not timed | 947.11 ± 3.9% | | 1.00 | 0.0517 | 26.54 |
| imported/leipzig/quotes-bounded | 8886 | 2594.06 ± 3.8% | not timed | not timed | 4107.66 ± 1.5% | 60.26 ± 2.9% | not timed | not timed | 2597.95 ± 6.8% | | 1.00 | 0.63 | 43.05 |
| imported/leipzig/non-ascii-alternate | 2 | 66155.61 ± 1.9% | not timed | not timed | 25859.05 ± 1.3% | 84.91 ± 2.6% | not timed | not timed | 66009.18 ± 2.8% | | 1.00 | 2.56 | 779.08 |
| imported/leipzig/math-symbols | 69 | 4462.49 ± 0.9% | not timed | not timed | 750.82 ± 0.6% | 58.25 ± 2.6% | not timed | not timed | 4470.21 ± 2.2% | | 1.00 | 5.94 | 76.61 |
| imported/leipzig/bounded-strings-ending-z | 0 | 748.20 ± 4.4% | not timed | not timed | 750.88 ± 0.8% | 39.28 ± 8.9% | not timed | not timed | 749.27 ± 5.1% | | 1.00 | 1.00 | 19.05 |
| imported/lh3lh3-reb/uri | 17549 | 935.53 ± 0.6% | not timed | not timed | 1575.54 ± 0.6% | 40.26 ± 3.8% | not timed | not timed | 955.07 ± 0.5% | | 0.98 | 0.59 | 23.24 |
| imported/lh3lh3-reb/email | 15057 | 1042.60 ± 1.4% | not timed | not timed | 1530.34 ± 1.4% | 45.05 ± 2.6% | not timed | not timed | 1040.64 ± 2.3% | | 1.00 | 0.68 | 23.14 |
| imported/lh3lh3-reb/date | 668 | 1187.90 ± 0.9% | not timed | not timed | 1345.78 ± 3.3% | 73.91 ± 4.7% | not timed | not timed | 1187.28 ± 0.9% | | 1.00 | 0.88 | 16.07 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 964.32 ± 1.6% | not timed | not timed | 564.09 ± 3.7% | 23.34 ± 3.3% | not timed | not timed | 956.98 ± 4.8% | | 1.01 | 1.71 | 41.32 |
| imported/mariomka/email | 92 | 865.12 ± 2.1% | not timed | not timed | 75858.81 ± 3.5% | 51.58 ± 7.9% | not timed | not timed | 860.84 ± 2.6% | | 1.00 | 0.0114 | 16.77 |
| imported/mariomka/uri | 5301 | 746.29 ± 1.1% | not timed | not timed | 9477.91 ± 5.2% | 52.96 ± 4.3% | not timed | not timed | 745.84 ± 2.5% | | 1.00 | 0.0787 | 14.09 |
| imported/mariomka/ip | 5 | 2490.11 ± 4.5% | not timed | not timed | 2995.03 ± 1.0% | 34.06 ± 2.3% | not timed | not timed | 2487.45 ± 2.8% | | 1.00 | 0.83 | 73.11 |
| imported/rsc/no-exponential | 0 | 1168.95 ± 4.1% | not timed | not timed | 744.12 ± 8.3% | 36.59 ± 1.9% | not timed | not timed | 1173.24 ± 6.1% | | 1.00 | 1.57 | 31.95 |
| imported/rsc/literal | 1 | 1451.14 ± 7.4% | not timed | not timed | 3224.74 ± 4.6% | 347.60 ± 5.7% | not timed | not timed | 1427.80 ± 7.2% | | 1.02 | 0.45 | 4.17 |
| imported/rsc/not-literal | 2 | 1368.08 ± 1.2% | not timed | not timed | 1439.72 ± 0.2% | 76.79 ± 11.8% | not timed | not timed | 1340.00 ± 46.3% | | 1.02 | 0.95 | 17.82 |
| imported/rsc/match-class | 1 | 2388.21 ± 5.3% | not timed | not timed | 3241.25 ± 2.8% | 102.88 ± 1.5% | not timed | not timed | 2375.79 ± 0.1% | | 1.01 | 0.74 | 23.21 |
| imported/rsc/match-class-in-range | 1 | 2372.49 ± 5.7% | not timed | not timed | 4988.29 ± 1.5% | 104.52 ± 6.9% | not timed | not timed | 2351.05 ± 1.1% | | 1.01 | 0.48 | 22.70 |
| imported/rsc/match-class-unicode | 1 | 697.12 ± 1.7% | not timed | not timed | 689.68 ± 0.4% | 125.05 ± 5.0% | not timed | not timed | 699.10 ± 0.7% | | 1.00 | 1.01 | 5.57 |
| imported/rsc/anchored-literal-short-non-match | 0 | 966.21 ± 5.5% | not timed | not timed | 1818.35 ± 4.1% | 466.22 ± 7.7% | not timed | not timed | 963.01 ± 5.8% | | 1.00 | 0.53 | 2.07 |
| imported/rsc/anchored-literal-long-non-match | 0 | 15782.78 ± 44.5% | not timed | not timed | 27327.54 ± 6.0% | 7002.11 ± 2.1% | not timed | not timed | 15776.32 ± 3.2% | | 1.00 | 0.58 | 2.25 |
| imported/rsc/anchored-literal-short-match | 4 | 687.73 ± 4.4% | not timed | not timed | 999.29 ± 6.3% | 159.31 ± 11.9% | not timed | not timed | 697.83 ± 1.7% | | 0.99 | 0.69 | 4.32 |
| imported/rsc/anchored-literal-long-match | 4 | 4604.84 ± 1.5% | not timed | not timed | 14997.40 ± 0.1% | 2341.46 ± 4.2% | not timed | not timed | 4632.46 ± 1.5% | | 0.99 | 0.31 | 1.97 |
| imported/rsc/one-pass-short | 17 | 541.96 ± 5.6% | not timed | not timed | 472.36 ± 3.7% | 52.90 ± 88.5% | not timed | not timed | 548.66 ± 1.6% | | 0.99 | 1.15 | 10.24 |
| imported/rsc/one-pass-short-not | 17 | 363.90 ± 5.7% | not timed | not timed | 503.89 ± 4.2% | 49.42 ± 15.2% | not timed | not timed | 369.19 ± 5.6% | | 0.99 | 0.72 | 7.36 |
| imported/rsc/one-pass-long-prefix | 26 | 381.60 ± 1.7% | not timed | not timed | 548.70 ± 0.3% | 190.50 ± 13.2% | not timed | not timed | 375.84 ± 10.7% | | 1.02 | 0.70 | 2.00 |
| imported/rsc/one-pass-long-prefix-not | 26 | 508.09 ± 7.8% | not timed | not timed | 525.91 ± 0.6% | 127.19 ± 13.5% | not timed | not timed | 490.04 ± 5.9% | | 1.04 | 0.97 | 3.99 |
| imported/rsc/long-needle1 | 31 | 91087.79 ± 2.1% | not timed | not timed | 69923.24 ± 10.4% | 6.25 ± 37.1% | not timed | not timed | 90593.65 ± 48.5% | | 1.01 | 1.30 | 14583.07 |
| imported/rsc/long-needle2 | 31 | 91750.56 ± 2.9% | not timed | not timed | 367.04 ± 4.6% | 6.20 ± 3.2% | not timed | not timed | 91919.40 ± 0.9% | | 1.00 | 249.97 | 14806.20 |
| imported/rsc/easy0-32 | 26 | 2037.35 ± 6.2% | not timed | not timed | 2959.43 ± 0.6% | 237.42 ± 10.3% | not timed | not timed | 2027.39 ± 2.2% | | 1.00 | 0.69 | 8.58 |
| imported/rsc/easy0-1k | 26 | 32092.81 ± 4.8% | not timed | not timed | 32298.77 ± 2.6% | 3673.80 ± 11.2% | not timed | not timed | 32448.44 ± 2.0% | | 0.99 | 0.99 | 8.74 |
| imported/rsc/easy0-32k | 26 | 87269.04 ± 2.8% | not timed | not timed | 66818.58 ± 4.7% | 40188.51 ± 23.3% | not timed | not timed | 87297.23 ± 0.7% | | 1.00 | 1.31 | 2.17 |
| imported/rsc/easy0-1mb | 26 | 88158.11 ± 5.8% | not timed | not timed | 70517.42 ± 0.3% | 104279.97 ± 4.9% | not timed | not timed | 88358.19 ± 5.6% | | 1.00 | 1.25 | 0.85 |
| imported/rsc/easy1-32 | 19 | 551.11 ± 1.6% | not timed | not timed | 1220.64 ± 2.5% | 225.90 ± 12.8% | not timed | not timed | 550.95 ± 7.4% | | 1.00 | 0.45 | 2.44 |
| imported/rsc/easy1-1k | 19 | 723.54 ± 11.0% | not timed | not timed | 26147.61 ± 0.1% | 3863.95 ± 18.4% | not timed | not timed | 728.39 ± 6.9% | | 0.99 | 0.0277 | 0.19 |
| imported/rsc/easy1-32k | 19 | 749.11 ± 2.1% | not timed | not timed | 819580.19 ± 0.5% | 44699.09 ± 18.7% | not timed | not timed | 749.70 ± 11.7% | | 1.00 | 0.0009 | 0.0168 |
| imported/rsc/easy1-1mb | 19 | 750.00 ± 9.8% | not timed | not timed | 28149865.05 ± 1.7% | 103030.52 ± 2.0% | not timed | not timed | 750.11 ± 0.4% | | 1.00 | 0.0000 | 0.0073 |
| imported/rsc/medium-32 | 27 | 731.04 ± 1.5% | not timed | not timed | 1167.90 ± 0.8% | 120.77 ± 7.1% | not timed | not timed | 729.66 ± 0.5% | | 1.00 | 0.63 | 6.05 |
| imported/rsc/medium-1k | 27 | 11430.31 ± 0.6% | not timed | not timed | 20115.86 ± 6.6% | 121.28 ± 2.3% | not timed | not timed | 11555.97 ± 0.5% | | 0.99 | 0.57 | 94.24 |
| imported/rsc/medium-32k | 27 | 76186.68 ± 1.3% | not timed | not timed | 622561.28 ± 4.0% | 82.33 ± 1.3% | not timed | not timed | 76575.97 ± 0.3% | | 0.99 | 0.12 | 925.43 |
| imported/rsc/medium-1mb | 27 | 84726.98 ± 13.4% | not timed | not timed | 21265396.84 ± 2.4% | 82.68 ± 4.4% | not timed | not timed | 88236.87 ± 0.1% | | 0.96 | 0.0040 | 1024.72 |
| imported/rsc/hard-32 | 58 | 368.52 ± 7.4% | not timed | not timed | 535.52 ± 2.7% | 79.47 ± 11.6% | not timed | not timed | 373.21 ± 5.7% | | 0.99 | 0.69 | 4.64 |
| imported/rsc/hard-1k | 27 | 730.00 ± 1.8% | not timed | not timed | 19419.89 ± 10.8% | 63.43 ± 4.3% | not timed | not timed | 730.28 ± 12.5% | | 1.00 | 0.0376 | 11.51 |
| imported/rsc/hard-32k | 27 | 725.76 ± 30.2% | not timed | not timed | 682902.21 ± 3.1% | 51.33 ± 5.1% | not timed | not timed | 745.46 ± 4.6% | | 0.97 | 0.0011 | 14.14 |
| imported/rsc/hard-1mb | 51 | 748.97 ± 3.4% | not timed | not timed | 9337537.14 ± 7.3% | 51.03 ± 6.7% | not timed | not timed | 749.32 ± 0.2% | | 1.00 | 0.0001 | 14.68 |
| imported/rsc/reallyhard0-32 | 58 | 370.29 ± 0.5% | not timed | not timed | 359.37 ± 0.4% | 79.42 ± 9.5% | not timed | not timed | 370.46 ± 1.8% | | 1.00 | 1.03 | 4.66 |
| imported/rsc/reallyhard0-1k | 27 | 721.63 ± 11.3% | not timed | not timed | 732.66 ± 1.1% | 61.40 ± 16.5% | not timed | not timed | 733.20 ± 1.1% | | 0.98 | 0.98 | 11.75 |
| imported/rsc/reallyhard0-32k | 27 | 749.78 ± 0.4% | not timed | not timed | 748.85 ± 2.9% | 51.05 ± 1.4% | not timed | not timed | 749.18 ± 3.4% | | 1.00 | 1.00 | 14.69 |
| imported/rsc/reallyhard0-1mb | 51 | 748.87 ± 0.2% | not timed | not timed | 751.01 ± 19.6% | 50.10 ± 3.3% | not timed | not timed | 747.09 ± 2.8% | | 1.00 | 1.00 | 14.95 |
| imported/rsc/reallyreallyhard0-32 | 47 | 430.04 ± 4.1% | not timed | not timed | 277.44 ± 0.1% | 98.05 ± 6.4% | not timed | not timed | 429.86 ± 7.2% | | 1.00 | 1.55 | 4.39 |
| imported/rsc/reallyreallyhard0-1k | 16 | 1082.33 ± 3.3% | not timed | not timed | 11457.21 ± 0.5% | 52.58 ± 1.8% | not timed | not timed | 1080.08 ± 2.7% | | 1.00 | 0.0945 | 20.58 |
| imported/rsc/reallyreallyhard0-32k | 16 | 782.52 ± 5.1% | not timed | not timed | 60759.84 ± 0.7% | 40.95 ± 6.7% | not timed | not timed | 782.56 ± 4.7% | | 1.00 | 0.0129 | 19.11 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 749.08 ± 4.4% | not timed | not timed | 70119.68 ± 2.5% | 41.37 ± 4.3% | not timed | not timed | 749.30 ± 3.8% | | 1.00 | 0.0107 | 18.11 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 419.05 ± 0.5% | not timed | not timed | 290.88 ± 2.7% | 99.98 ± 8.2% | not timed | not timed | 418.72 ± 10.4% | | 1.00 | 1.44 | 4.19 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 1012.03 ± 10.8% | not timed | not timed | 10602.08 ± 6.2% | 52.46 ± 4.8% | not timed | not timed | 1049.62 ± 4.3% | | 0.96 | 0.0955 | 19.29 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 782.91 ± 2.8% | not timed | not timed | 59994.27 ± 4.4% | 41.90 ± 5.7% | not timed | not timed | 760.51 ± 5.1% | | 1.03 | 0.0130 | 18.69 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 750.02 ± 0.1% | not timed | not timed | 69888.15 ± 1.5% | 42.01 ± 0.8% | not timed | not timed | 750.44 ± 0.1% | | 1.00 | 0.0107 | 17.85 |
| imported/sherlock/name-sherlock | 776 | 66737.52 ± 4.1% | not timed | not timed | 53493.06 ± 4.3% | 16248.81 ± 10.6% | not timed | not timed | 67233.14 ± 5.6% | | 0.99 | 1.25 | 4.11 |
| imported/sherlock/name-holmes | 2766 | 38496.92 ± 4.8% | not timed | not timed | 37290.91 ± 1.6% | 5432.05 ± 7.4% | not timed | not timed | 38273.28 ± 1.1% | | 1.01 | 1.03 | 7.09 |
| imported/sherlock/name-sherlock-holmes | 1365 | 68256.30 ± 2.1% | not timed | not timed | 54358.56 ± 3.0% | 13867.13 ± 12.7% | not timed | not timed | 68983.80 ± 1.3% | | 0.99 | 1.26 | 4.92 |
| imported/sherlock/name-sherlock-casei | 816 | 68550.50 ± 1.1% | not timed | not timed | 15210.77 ± 0.6% | 54.15 ± 1.6% | not timed | not timed | 68551.42 ± 1.6% | | 1.00 | 4.51 | 1266.05 |
| imported/sherlock/name-holmes-casei | 2802 | 32738.99 ± 1.9% | not timed | not timed | 9375.44 ± 10.9% | 68.71 ± 5.3% | not timed | not timed | 32645.78 ± 11.5% | | 1.00 | 3.49 | 476.50 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 55248.21 ± 2.1% | not timed | not timed | 14784.54 ± 0.9% | 53.79 ± 2.0% | not timed | not timed | 54873.12 ± 2.3% | | 1.01 | 3.74 | 1027.02 |
| imported/sherlock/name-whitespace | 1461 | 37626.76 ± 5.3% | not timed | not timed | 37690.19 ± 1.6% | 12680.40 ± 9.4% | not timed | not timed | 37875.49 ± 2.5% | | 0.99 | 1.00 | 2.97 |
| imported/sherlock/name-alt1 | 1142 | 42099.41 ± 16.1% | not timed | not timed | 45054.71 ± 13.6% | 6961.07 ± 11.1% | not timed | not timed | 42564.65 ± 1.5% | | 0.99 | 0.93 | 6.05 |
| imported/sherlock/name-alt2 | 3542 | 23593.52 ± 3.6% | not timed | not timed | 12701.25 ± 5.4% | 57.04 ± 4.5% | not timed | not timed | 23594.56 ± 1.1% | | 1.00 | 1.86 | 413.60 |
| imported/sherlock/name-alt3 | 4507 | 15197.04 ± 1.0% | not timed | not timed | 11742.52 ± 1.9% | 17.80 ± 5.6% | not timed | not timed | 15170.29 ± 1.0% | | 1.00 | 1.29 | 853.80 |
| imported/sherlock/name-alt3-casei | 4593 | 2501.78 ± 10.8% | not timed | not timed | 1738.98 ± 9.5% | 11.20 ± 4.1% | not timed | not timed | 2538.59 ± 8.4% | | 0.99 | 1.44 | 223.46 |
| imported/sherlock/name-alt4 | 3686 | 12001.89 ± 32.7% | not timed | not timed | 9856.35 ± 1.1% | 56.24 ± 60.2% | not timed | not timed | 12043.61 ± 5.1% | | 1.00 | 1.22 | 213.42 |
| imported/sherlock/name-alt4-casei | 4254 | 6938.62 ± 2.8% | not timed | not timed | 5382.68 ± 4.3% | 32.11 ± 47.9% | not timed | not timed | 6950.25 ± 4.2% | | 1.00 | 1.29 | 216.10 |
| imported/sherlock/name-alt5 | 4028 | 19236.03 ± 1.5% | not timed | not timed | 12322.67 ± 0.5% | 40.38 ± 1.2% | not timed | not timed | 19263.52 ± 0.5% | | 1.00 | 1.56 | 476.32 |
| imported/sherlock/name-alt5-casei | 4104 | 8850.11 ± 1.6% | not timed | not timed | 3940.27 ± 3.4% | 24.21 ± 2.3% | not timed | not timed | 8832.50 ± 5.9% | | 1.00 | 2.25 | 365.52 |
| imported/sherlock/no-match-uncommon | 0 | 94328.36 ± 2.0% | not timed | not timed | 93467.53 ± 1.9% | 82937.07 ± 2.2% | not timed | not timed | 94565.17 ± 2.7% | | 1.00 | 1.01 | 1.14 |
| imported/sherlock/no-match-common | 0 | 92305.19 ± 3.4% | not timed | not timed | 93458.60 ± 0.5% | 2461.15 ± 0.3% | not timed | not timed | 92335.95 ± 3.0% | | 1.00 | 0.99 | 37.50 |
| imported/sherlock/no-match-really-common | 0 | 64063.26 ± 0.2% | not timed | not timed | 69531.45 ± 5.9% | 2457.24 ± 0.6% | not timed | not timed | 64109.01 ± 0.6% | | 1.00 | 0.92 | 26.07 |
| imported/sherlock/the-lower | 21654 | 4133.40 ± 4.9% | not timed | not timed | 4133.14 ± 4.0% | 371.81 ± 7.6% | not timed | not timed | 4155.84 ± 3.1% | | 0.99 | 1.00 | 11.12 |
| imported/sherlock/the-upper | 2223 | 27094.03 ± 4.3% | not timed | not timed | 36933.61 ± 4.8% | 4455.23 ± 41.2% | not timed | not timed | 27291.66 ± 4.1% | | 0.99 | 0.73 | 6.08 |
| imported/sherlock/the-casei | 23961 | 3802.52 ± 8.2% | not timed | not timed | 1741.02 ± 0.5% | 61.02 ± 25.0% | not timed | not timed | 3791.07 ± 2.5% | | 1.00 | 2.18 | 62.32 |
| imported/sherlock/everything-greedy | 581881 | 358.33 ± 4.3% | not timed | not timed | 230.04 ± 2.6% | 45.16 ± 45.4% | not timed | not timed | 361.82 ± 6.0% | | 0.99 | 1.56 | 7.94 |
| imported/sherlock/everything-greedy-nl | 594933 | 590.67 ± 0.8% | not timed | not timed | 307.96 ± 4.5% | 55.98 ± 21.0% | not timed | not timed | 590.72 ± 0.5% | | 1.00 | 1.92 | 10.55 |
| imported/sherlock/letters | 447175 | 76.58 ± 13.7% | not timed | not timed | 47.03 ± 9.9% | 8.70 ± 61.6% | not timed | not timed | 77.27 ± 2.1% | | 0.99 | 1.63 | 8.80 |
| imported/sherlock/letters-upper | 14180 | 532.13 ± 2.3% | not timed | not timed | 467.16 ± 3.0% | 43.20 ± 17.9% | not timed | not timed | 533.81 ± 2.0% | | 1.00 | 1.14 | 12.32 |
| imported/sherlock/letters-lower | 432995 | 78.09 ± 7.8% | not timed | not timed | 47.30 ± 3.9% | 9.23 ± 35.6% | not timed | not timed | 78.17 ± 2.6% | | 1.00 | 1.65 | 8.46 |
| imported/sherlock/words | 447639 | 132.72 ± 9.1% | not timed | not timed | 108.92 ± 2.7% | 22.38 ± 27.5% | not timed | not timed | 132.46 ± 4.4% | | 1.00 | 1.22 | 5.93 |
| imported/sherlock/before-holmes | 4073 | 738.91 ± 3.9% | not timed | not timed | 17003.09 ± 2.6% | 38.87 ± 1.4% | not timed | not timed | 733.36 ± 4.2% | | 1.01 | 0.0435 | 19.01 |
| imported/sherlock/before-after-holmes | 2593 | 715.86 ± 2.2% | not timed | not timed | 19312.79 ± 0.9% | 36.84 ± 26.5% | not timed | not timed | 712.00 ± 0.7% | | 1.01 | 0.0371 | 19.43 |
| imported/sherlock/holmes-cochar-watson | 150 | 12156.79 ± 2.1% | not timed | not timed | 9771.87 ± 1.2% | 53.87 ± 2.4% | not timed | not timed | 12107.24 ± 1.8% | | 1.00 | 1.24 | 225.66 |
| imported/sherlock/holmes-coword-watson | 14309 | 1537.02 ± 3.3% | not timed | not timed | 1508.01 ± 4.7% | 11.49 ± 4.2% | not timed | not timed | 1529.72 ± 4.7% | | 1.00 | 1.02 | 133.78 |
| imported/sherlock/quotes | 14437 | 1737.68 ± 3.6% | not timed | not timed | 2986.30 ± 2.3% | 55.51 ± 6.0% | not timed | not timed | 1721.86 ± 6.4% | | 1.01 | 0.58 | 31.30 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 742.91 ± 3.7% | not timed | not timed | 40254.73 ± 7.4% | 62.74 ± 4.3% | not timed | not timed | 728.42 ± 3.7% | | 1.02 | 0.0185 | 11.84 |
| imported/sherlock/word-ending-n | 35297 | 552.20 ± 11.3% | not timed | not timed | 489.79 ± 2.6% | 37.87 ± 17.6% | not timed | not timed | 556.45 ± 1.5% | | 0.99 | 1.13 | 14.58 |
| imported/sherlock/repeated-class-negation | 2130 | 23970.13 ± 4.7% | not timed | not timed | 23841.77 ± 2.4% | 15.96 ± 3.3% | not timed | not timed | 24191.26 ± 3.5% | | 0.99 | 1.01 | 1502.26 |
| imported/sherlock/ing-suffix | 20547 | 684.35 ± 1.2% | not timed | not timed | 619.61 ± 5.4% | 44.46 ± 9.6% | not timed | not timed | 682.06 ± 5.1% | | 1.00 | 1.10 | 15.39 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 742.87 ± 31.2% | not timed | not timed | 3828.78 ± 3.0% | 28.45 ± 28.0% | not timed | not timed | 741.54 ± 0.9% | | 1.00 | 0.19 | 26.11 |
| opt/accelerate/whole-line | 239963 | 657.63 ± 15.2% | not timed | not timed | 518.70 ± 43.0% | 128.64 ± 24.5% | not timed | not timed | 678.02 ± 12.6% | | 0.97 | 1.27 | 5.11 |
| opt/accelerate/non-dna | 16745 | 577.68 ± 4.2% | not timed | not timed | 582.82 ± 3.6% | 47.26 ± 30.3% | not timed | not timed | 566.65 ± 5.6% | | 1.02 | 0.99 | 12.22 |
| opt/backtrack/words-english | 40536 | 197.89 ± 10.4% | not timed | not timed | 143.48 ± 3.8% | 30.75 ± 10.1% | not timed | not timed | 194.59 ± 3.0% | | 1.02 | 1.38 | 6.44 |
| opt/fixed-length/too-small-ascii | 0 | 565.91 ± 16.0% | not timed | not timed | 1180.00 ± 2.0% | 175.27 ± 2.1% | not timed | not timed | 569.29 ± 2.9% | | 0.99 | 0.48 | 3.23 |
| opt/fixed-length/too-big-ascii | 0 | 1116.57 ± 2.3% | not timed | not timed | 9163.80 ± 4.0% | 218.72 ± 1.8% | not timed | not timed | 1155.10 ± 2.2% | | 0.97 | 0.12 | 5.10 |
| opt/fixed-length/go33484-1 | 0 | 93.08 ± 5.1% | not timed | not timed | 1774487.46 ± 0.4% | 127375.86 ± 2.3% | not timed | not timed | 86.04 ± 3.9% | | 1.08 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 7114.90 ± 5.3% | not timed | not timed | 1789818.57 ± 4.3% | 47215.96 ± 1.6% | not timed | not timed | 7117.78 ± 0.4% | | 1.00 | 0.0040 | 0.15 |
| opt/fixed-length/go33484-3 | 0 | 2331.24 ± 1.4% | not timed | not timed | 176892.87 ± 1.4% | 1362.94 ± 1.3% | not timed | not timed | 2318.94 ± 0.2% | | 1.01 | 0.0132 | 1.71 |
| opt/literal-alt/one-pattern | 1 | 744.06 ± 11.7% | not timed | not timed | 724.39 ± 27.6% | 0.63 ± 7.7% | not timed | not timed | 736.27 ± 3.1% | | 1.01 | 1.03 | 1189.77 |
| opt/onepass/fn-predicate | 916 | 602.57 ± 3.6% | not timed | not timed | 549.62 ± 3.0% | 291.51 ± 19.8% | not timed | not timed | 622.05 ± 2.2% | | 0.97 | 1.10 | 2.07 |
| opt/onepass/first-three-words-english | 35128 | 223.97 ± 8.3% | not timed | not timed | 318.64 ± 4.0% | 119.89 ± 11.0% | not timed | not timed | 221.74 ± 5.8% | | 1.01 | 0.70 | 1.87 |
| opt/prefilter/literal-english | 1 | 93918.89 ± 0.7% | not timed | not timed | 71334.02 ± 49.7% | 36233.81 ± 8.2% | not timed | not timed | 93975.63 ± 12.9% | | 1.00 | 1.32 | 2.59 |
| opt/prefilter/literal-casei-english | 1 | 71595.11 ± 3.7% | not timed | not timed | 19091.79 ± 4.1% | 54.55 ± 6.4% | not timed | not timed | 71090.60 ± 6.3% | | 1.01 | 3.75 | 1312.42 |
| opt/prefilter/literal-russian | 1 | 94815.83 ± 0.5% | not timed | not timed | 71218.11 ± 0.5% | 4361.83 ± 0.9% | not timed | not timed | 94767.14 ± 0.7% | | 1.00 | 1.33 | 21.74 |
| opt/prefilter/literal-casei-russian | 1 | 38053.71 ± 0.6% | not timed | not timed | 13629.56 ± 0.9% | 58.75 ± 0.9% | not timed | not timed | 38151.58 ± 0.5% | | 1.00 | 2.79 | 647.72 |
| opt/prefilter/rust-functions | 948 | 20918.25 ± 14.5% | not timed | not timed | 16998.34 ± 11.8% | 2532.11 ± 51.9% | not timed | not timed | 20974.35 ± 2.7% | | 1.00 | 1.23 | 8.26 |
| opt/reverse-anchored/word-end | 1 | 7253.15 ± 0.8% | not timed | not timed | 39069731.66 ± 1.4% | 86.06 ± 2.2% | not timed | not timed | 7265.08 ± 0.8% | | 1.00 | 0.0002 | 84.28 |
| opt/reverse-inner/holmes | 2593 | 743.15 ± 1.4% | not timed | not timed | 20205.07 ± 2.2% | 38.59 ± 4.2% | not timed | not timed | 743.39 ± 2.9% | | 1.00 | 0.0368 | 19.26 |
| opt/reverse-inner/email | 47 | 1276.72 ± 3.7% | not timed | not timed | 105165.10 ± 3.3% | 51.27 ± 4.1% | not timed | not timed | 1277.12 ± 5.1% | | 1.00 | 0.0121 | 24.90 |
| opt/reverse-inner/factored-prefix | 3542 | 732.75 ± 0.1% | not timed | not timed | 727.84 ± 0.5% | 20.73 ± 0.5% | not timed | not timed | 732.82 ± 0.8% | | 1.00 | 1.01 | 35.35 |
| opt/reverse-inner/no-quadratic-backward | 0 | 7071.93 ± 1.0% | not timed | not timed | 750.52 ± 0.8% | 127.70 ± 4.8% | not timed | not timed | 7044.64 ± 1.2% | | 1.00 | 9.42 | 55.38 |
| opt/reverse-inner/no-quadratic-forward | 0 | 871.33 ± 1.9% | not timed | not timed | 345.90 ± 0.1% | 41.06 ± 1.4% | not timed | not timed | 870.05 ± 1.6% | | 1.00 | 2.52 | 21.22 |
| opt/reverse-suffix/holmes | 4073 | 742.01 ± 1.6% | not timed | not timed | 17107.33 ± 4.6% | 39.09 ± 4.2% | not timed | not timed | 741.88 ± 0.5% | | 1.00 | 0.0434 | 18.98 |
| opt/reverse-suffix/no-quadratic | 0 | 7082.15 ± 0.8% | not timed | not timed | 750.71 ± 0.3% | 125.91 ± 2.3% | not timed | not timed | 7093.23 ± 0.6% | | 1.00 | 9.43 | 56.25 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 221.04 ± 3.6% | not timed | not timed | 282.90 ± 31.3% | 25.39 ± 14.1% | not timed | not timed | 216.56 ± 2.4% | | 1.02 | 0.78 | 8.71 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 212.43 ± 39.6% | not timed | not timed | 284.00 ± 35.3% | 24.83 ± 7.8% | not timed | not timed | 217.53 ± 6.4% | | 0.98 | 0.75 | 8.55 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.49 ± 2.0% | not timed | not timed | 0.82 ± 18.4% | 177.77 ± 15.6% | not timed | not timed | 0.50 ± 2.5% | | 0.99 | 0.60 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 383.10 ± 1.4% | not timed | not timed | 383.50 ± 1.2% | 166.38 ± 8.6% | not timed | not timed | 386.15 ± 1.7% | | 0.99 | 1.00 | 2.30 |
| reported/i13-subset-regex/original-ascii | 4094 | 15472.58 ± 4.4% | not timed | not timed | 5756.20 ± 3.9% | 15.93 ± 3.5% | not timed | not timed | 15747.39 ± 1.5% | | 0.98 | 2.69 | 971.35 |
| reported/i13-subset-regex/original-unicode | 4094 | 15721.78 ± 3.9% | not timed | not timed | 299.30 ± 7.8% | 15.58 ± 2.1% | not timed | not timed | 15805.56 ± 2.0% | | 0.99 | 52.53 | 1009.03 |
| reported/i13-subset-regex/big-ascii | 1955 | 14572.73 ± 8.3% | not timed | not timed | 81.49 ± 5.6% | 13.80 ± 1.7% | not timed | not timed | 14759.61 ± 5.1% | | 0.99 | 178.83 | 1055.95 |
| reported/i13-subset-regex/big-unicode | 1955 | 14690.70 ± 1.2% | not timed | not timed | 14.70 ± 56.7% | 13.83 ± 1.6% | not timed | not timed | 14640.69 ± 1.6% | | 1.00 | 999.10 | 1062.03 |
| reported/i13-subset-regex/huge-ascii | 55 | 13581.66 ± 15.0% | not timed | not timed | 13.98 ± 1.8% | 12.84 ± 2.0% | not timed | not timed | 13563.09 ± 0.8% | | 1.00 | 971.39 | 1057.95 |
| reported/i13-subset-regex/huge-unicode | 55 | 13549.88 ± 5.4% | not timed | not timed | 13.79 ± 2.6% | 12.87 ± 2.8% | not timed | not timed | 13443.11 ± 2.3% | | 1.01 | 982.32 | 1052.95 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 6.01 ± 2.1% | not timed | not timed | 14.04 ± 1.2% | 12.76 ± 3.6% | not timed | not timed | 5.97 ± 1.5% | | 1.01 | 0.43 | 0.47 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.80 ± 1.3% | not timed | not timed | 13.87 ± 3.1% | 12.82 ± 0.8% | not timed | not timed | 7.89 ± 2.6% | | 0.99 | 0.56 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 602.20 ± 0.9% | not timed | not timed | 220.81 ± 2.0% | 10.76 ± 1.1% | not timed | not timed | 610.36 ± 0.7% | | 0.99 | 2.73 | 55.97 |
| reported/i787-keywords/opt-ascii | 5674 | 603.65 ± 4.9% | not timed | not timed | 351.96 ± 4.5% | 17.67 ± 9.7% | not timed | not timed | 607.20 ± 3.9% | | 0.99 | 1.72 | 34.17 |
| slow/quadratic-regex-1x | 100 | 11.13 ± 2.8% | not timed | not timed | 8.86 ± 40.1% | 0.08 ± 5.6% | not timed | not timed | 11.13 ± 7.0% | | 1.00 | 1.26 | 138.53 |
| slow/quadratic-regex-2x | 199 | 4.75 ± 1.5% | not timed | not timed | 4.09 ± 5.0% | 0.02 ± 1.7% | not timed | not timed | 4.71 ± 3.9% | | 1.01 | 1.16 | 228.02 |
| slow/quadratic-haystack-1x | 100 | 39.75 ± 28.5% | not timed | not timed | 17.45 ± 4.1% | 1.47 ± 11.4% | not timed | not timed | 40.73 ± 5.7% | | 0.98 | 2.28 | 27.06 |
| slow/quadratic-haystack-2x | 200 | 32.63 ± 5.2% | not timed | not timed | 8.29 ± 2.3% | 0.84 ± 1.0% | not timed | not timed | 33.04 ± 8.9% | | 0.99 | 3.94 | 38.99 |
| unicode/codepoints/any-one | 1112064 | 522.09 ± 16.4% | not timed | not timed | 382.58 ± 40.3% | 29.26 ± 22.2% | not timed | not timed | 525.39 ± 1.0% | | 0.99 | 1.36 | 17.84 |
| unicode/codepoints/any-all | 4382592 | 352.12 ± 5.0% | not timed | not timed | 347.00 ± 5.1% | 195.18 ± 4.2% | not timed | not timed | 351.97 ± 4.7% | | 1.00 | 1.01 | 1.80 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 12.39 ± 1.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 750.01 ± 2.1% | not timed | not timed | 743.33 ± 1.7% | 232.16 ± 4.6% | not timed | not timed | 736.69 ± 6.8% | | 1.02 | 1.01 | 3.23 |
| unicode/overlapping-words/ascii | 6156 | 46.49 ± 3.5% | not timed | not timed | 58.50 ± 4.6% | 6.27 ± 3.7% | not timed | not timed | 45.63 ± 8.8% | | 1.02 | 0.79 | 7.42 |
| unicode/overlapping-words/english | 6156 | 2.26 ± 1.1% | not timed | not timed | 5.41 ± 4.5% | 3.92 ± 4.6% | not timed | not timed | 2.29 ± 7.3% | | 0.99 | 0.42 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.98 ± 4.1% | not timed | not timed | 5.17 ± 5.3% | 9.75 ± 5.1% | not timed | not timed | 2.04 ± 7.4% | | 0.97 | 0.38 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 141.80 ± 4.8% | not timed | not timed | 108.67 ± 3.8% | 18.95 ± 17.5% | not timed | not timed | 141.36 ± 5.1% | | 1.00 | 1.30 | 7.48 |
| unicode/word/boundary-long-english | 3466 | 749.61 ± 1.5% | not timed | not timed | 735.27 ± 0.3% | 51.94 ± 6.9% | not timed | not timed | 750.62 ± 6.0% | | 1.00 | 1.02 | 14.43 |
| unicode/word/around-holmes-english | 27 | 720.50 ± 5.8% | not timed | not timed | 66204.33 ± 5.1% | 34.05 ± 5.4% | not timed | not timed | 722.58 ± 4.9% | | 1.00 | 0.0109 | 21.16 |
| wild/bibleref/long | 874 | 710.26 ± 0.4% | not timed | not timed | 717.65 ± 0.2% | 11.47 ± 0.5% | not timed | not timed | 710.57 ± 1.7% | | 1.00 | 0.99 | 61.92 |
| wild/bibleref/short | 30 | 37.25 ± 6.9% | not timed | not timed | 47.24 ± 0.9% | 22.80 ± 22.3% | not timed | not timed | 36.94 ± 33.6% | | 1.01 | 0.79 | 1.63 |
| wild/bibleref/line | 874 | 701.96 ± 3.1% | not timed | not timed | 351.43 ± 9.9% | 13.85 ± 24.0% | not timed | not timed | 699.95 ± 1.0% | | 1.00 | 2.00 | 50.68 |
| wild/caddy/caddy | 6 | 660.30 ± 3.9% | not timed | not timed | 361.67 ± 3.7% | 111.72 ± 7.9% | not timed | not timed | 673.28 ± 3.8% | | 0.98 | 1.83 | 5.91 |
| wild/dot-star-capture/rust-src-tools | 6 | 2194.75 ± 2.2% | not timed | not timed | 496.49 ± 2.3% | 24.26 ± 5.0% | not timed | not timed | 2199.13 ± 5.9% | | 1.00 | 4.42 | 90.46 |
| wild/ruff/noqa | 84 | 688.59 ± 0.8% | not timed | not timed | 707.85 ± 3.3% | 32.63 ± 3.6% | not timed | not timed | 688.80 ± 0.7% | | 1.00 | 0.97 | 21.11 |
| wild/ruff/unnecessary-coding-comment | 16 | 759.37 ± 0.4% | not timed | not timed | 933.86 ± 0.2% | 192.41 ± 12.0% | not timed | not timed | 761.61 ± 4.4% | | 1.00 | 0.81 | 3.95 |
| wild/ruff/string-quote-prefix | 2972 | 700.31 ± 0.8% | not timed | not timed | 707.65 ± 5.4% | 457.91 ± 31.6% | not timed | not timed | 699.79 ± 2.9% | | 1.00 | 0.99 | 1.53 |
| wild/ruff/space-around-operator | 1224378 | 331.43 ± 2.0% | not timed | not timed | 293.85 ± 0.9% | 27.64 ± 1.5% | not timed | not timed | 330.88 ± 4.9% | | 1.00 | 1.13 | 11.99 |
| wild/ruff/shebang | 282 | 687.81 ± 0.9% | not timed | not timed | 550.00 ± 3.5% | 162.97 ± 13.2% | not timed | not timed | 688.85 ± 0.6% | | 1.00 | 1.25 | 4.22 |
| wild/rustsec-cargo-audit/original-unix | 471 | 30806.91 ± 2.0% | not timed | not timed | 34005.30 ± 1.2% | 12776.10 ± 0.8% | not timed | not timed | 30662.89 ± 0.6% | | 1.00 | 0.91 | 2.41 |
| wild/rustsec-cargo-audit/original-windows | 462 | 28740.55 ± 2.3% | not timed | not timed | 31955.91 ± 1.8% | 11818.85 ± 37.3% | not timed | not timed | 28760.39 ± 3.2% | | 1.00 | 0.90 | 2.43 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 31732.23 ± 1.1% | not timed | not timed | 33201.04 ± 8.3% | 12312.16 ± 5.3% | not timed | not timed | 31655.48 ± 1.9% | | 1.00 | 0.96 | 2.58 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 27029.48 ± 3.6% | not timed | not timed | 33247.89 ± 2.3% | 12425.09 ± 33.3% | not timed | not timed | 27122.33 ± 5.7% | | 1.00 | 0.81 | 2.18 |
| wild/url/search | 234965 | 182.16 ± 6.4% | not timed | not timed | 89.10 ± 1.9% | 3.71 ± 3.0% | not timed | not timed | 181.23 ± 5.7% | | 1.01 | 2.04 | 49.12 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 2.8% | not timed | not timed | 0.01 ± 1.8% | 0.01 ± 8.6% | not timed | not timed | 0.04 ± 3.0% | | 0.98 | 2.92 | 4.17 |
| dictionary/compile/english-15 | 1 | 0.47 ± 2.3% | not timed | not timed | 0.12 ± 5.7% | 0.16 ± 8.8% | not timed | not timed | 0.47 ± 2.2% | | 1.00 | 4.09 | 2.95 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.43 ± 18.9% | not timed | not timed | 0.03 ± 4.3% | 50.92 ± 8.8% | not timed | not timed | 0.44 ± 3.6% | | 0.98 | 12.42 | 0.0085 |
| reported/i1095-word-repetition/ascii-compile | 1 | 61.56 ± 6.5% | not timed | not timed | 19.95 ± 0.5% | 88.42 ± 6.6% | not timed | not timed | 61.20 ± 5.3% | | 1.01 | 3.09 | 0.70 |
| reported/i787-keywords/compile | 1 | 56.97 ± 16.8% | not timed | not timed | 3.27 ± 1.5% | 27.78 ± 13.2% | not timed | not timed | 57.01 ± 9.0% | | 1.00 | 17.43 | 2.05 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 604.39 ± 7.4% | not timed | not timed | 207.19 ± 0.8% | 813.62 ± 9.1% | not timed | not timed | 617.28 ± 15.8% | | 0.98 | 2.92 | 0.74 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 78.92 ± 5.1% | not timed | not timed | 7.48 ± 0.6% | 66.55 ± 4.5% | not timed | not timed | 79.90 ± 5.0% | | 0.99 | 10.56 | 1.19 |
| unicode/compile/one-letter | 53 | 10.75 ± 15.3% | not timed | not timed | 8.05 ± 1.4% | 94.33 ± 6.3% | not timed | not timed | 10.78 ± 13.1% | | 1.00 | 1.34 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.90 ± 10.0% | not timed | not timed | 0.17 ± 5.2% | 91.63 ± 10.9% | not timed | not timed | 1.91 ± 4.4% | | 1.00 | 11.20 | 0.0207 |
| unicode/compile/fifty-letters-ascii | 1 | 313.18 ± 9.5% | not timed | not timed | 87.06 ± 0.5% | 290.83 ± 13.2% | not timed | not timed | 316.90 ± 9.5% | | 0.99 | 3.60 | 1.08 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 693.29 ± 2.1% | not timed | not timed | 64.60 ± 1.7% | 1009.33 ± 11.9% | not timed | not timed | 683.27 ± 17.6% | | 1.01 | 10.73 | 0.69 |
| unicode/compile/match-every-line-ascii | 4 | 1126.81 ± 10.5% | not timed | not timed | 227.14 ± 6.0% | 1022.68 ± 11.6% | not timed | not timed | 1146.54 ± 13.2% | | 0.98 | 4.96 | 1.10 |
| unicode/compile/negated-class-matches-codepoint | 1 | 562.63 ± 13.4% | not timed | not timed | 69.05 ± 32.0% | 1894.79 ± 18.1% | not timed | not timed | 560.16 ± 14.2% | | 1.00 | 8.15 | 0.30 |
| wild/bibleref/compile | 3 | 9.39 ± 13.8% | not timed | not timed | 3.33 ± 0.6% | 46.75 ± 15.3% | not timed | not timed | 9.40 ± 13.1% | | 1.00 | 2.82 | 0.20 |
| wild/url/compile | 1 | 1.03 ± 13.4% | not timed | not timed | 0.23 ± 0.7% | 0.63 ± 27.3% | not timed | not timed | 1.04 ± 3.3% | | 0.99 | 4.40 | 1.62 |

