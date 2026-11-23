# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127383966 |
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
| literal: a word | 217 | 41415.63 ± 6.5% | 916.90 ± 5.3% | 34.97 ± 3.3% | 40284.72 ± 1.6% | 12221.76 ± 2.9% | 12.18 ± 4.2% | 124.40 ± 2.9% | 42563.15 ± 5.2% | 45.17 | 0.97 | 1.03 | 3.39 |
| literal: a word that is not there | 0 | 58784.19 ± 4.8% | 913.97 ± 3.3% | 33.67 ± 4.2% | 48080.74 ± 2.4% | 40352.69 ± 4.6% | 11.47 ± 3.0% | 108.64 ± 3.1% | 59105.32 ± 2.2% | 64.32 | 0.99 | 1.22 | 1.46 |
| literal: one of four words | 661 | 14635.69 ± 6.6% | 895.88 ± 6.0% | 18.50 ± 2.8% | 10679.00 ± 3.8% | 28.91 ± 4.9% | 3.91 ± 6.0% | 10.33 ± 4.9% | 14512.40 ± 3.9% | 16.34 | 1.01 | 1.37 | 506.24 |
| literal: a word in any case | 217 | 39960.63 ± 8.9% | 978.69 ± 6.9% | 25.76 ± 4.2% | 11200.48 ± 4.8% | 54.89 ± 3.3% | refused | differs | 38915.32 ± 7.8% | 40.83 | 1.03 | 3.57 | 727.95 |
| literal: an href attribute | 33 | 35550.61 ± 3.6% | 934.13 ± 5.9% | 29.41 ± 8.0% | 34352.82 ± 11.3% | 2752.20 ± 5.2% | 8.72 ± 3.4% | 101.85 ± 7.3% | 35926.81 ± 2.9% | 38.06 | 0.99 | 1.03 | 12.92 |
| literal: a word, second text | 123 | 41839.99 ± 8.9% | 929.05 ± 5.9% | 34.02 ± 6.2% | 37459.19 ± 5.4% | 11431.85 ± 5.1% | 16.42 ± 4.1% | 103.28 ± 13.5% | 41966.22 ± 11.1% | 45.04 | 1.00 | 1.12 | 3.66 |
| class: two capitalized words | 1331 | 870.99 ± 6.2% | 892.85 ± 5.2% | 32.08 ± 5.6% | 531.82 ± 5.9% | 47.90 ± 5.7% | 10.73 ± 4.1% | 85.66 ± 7.6% | 872.58 ± 3.9% | 0.98 | 1.00 | 1.64 | 18.18 |
| class: a word that ends in ing | 3399 | 811.06 ± 5.6% | 810.91 ± 7.5% | 20.61 ± 5.9% | 497.96 ± 8.2% | 34.89 ± 12.2% | 6.12 ± 3.5% | 24.22 ± 3.0% | 812.54 ± 1.9% | 1.00 | 1.00 | 1.63 | 23.24 |
| class: a word in capitals | 2332 | 1239.47 ± 9.8% | 854.77 ± 8.5% | 32.42 ± 8.4% | 513.39 ± 7.2% | 49.50 ± 11.3% | 12.72 ± 2.1% | 102.65 ± 10.2% | 1220.31 ± 8.9% | 1.45 | 1.02 | 2.41 | 25.04 |
| class: a number | 8288 | 1868.07 ± 2.8% | 709.82 ± 3.5% | 31.94 ± 4.4% | 1740.50 ± 3.8% | 51.46 ± 18.7% | 0.34 ± 5.2% | 73.08 ± 3.4% | 1887.35 ± 5.4% | 2.63 | 0.99 | 1.07 | 36.30 |
| class: two capitalized words, second text | 5359 | 654.81 ± 2.2% | 656.76 ± 3.0% | 28.65 ± 3.2% | 444.87 ± 4.7% | 38.94 ± 18.0% | 13.61 ± 5.2% | 75.07 ± 9.0% | 648.54 ± 2.4% | 1.00 | 1.01 | 1.47 | 16.81 |
| other: a word between two words | 6104 | 748.31 ± 4.6% | 684.50 ± 6.3% | 27.51 ± 6.9% | 755.70 ± 5.2% | 135.12 ± 5.5% | 8.05 ± 4.6% | 86.24 ± 6.1% | 741.46 ± 3.5% | 1.09 | 1.01 | 0.99 | 5.54 |
| other: a number before a unit, second text | 1481 | 8901.06 ± 4.4% | 908.23 ± 2.5% | 31.43 ± 0.9% | 8400.62 ± 1.4% | 46.61 ± 13.3% | 14.60 ± 3.1% | 83.29 ± 2.0% | 8904.27 ± 2.4% | 9.80 | 1.00 | 1.06 | 190.99 |
| other: a heading's start tag | 110 | 23165.10 ± 5.8% | 953.98 ± 6.3% | 31.87 ± 4.6% | 2548.88 ± 7.1% | 1958.47 ± 7.3% | 10.80 ± 6.5% | 124.04 ± 20.2% | 22816.68 ± 2.6% | 24.28 | 1.02 | 9.09 | 11.83 |
| other: a whole word | 217 | 28432.00 ± 6.3% | 922.41 ± 1.9% | 34.45 ± 2.1% | 27648.56 ± 3.7% | 55.62 ± 6.3% | 10.13 ± 1.0% | 64.43 ± 1.7% | 28422.17 ± 3.9% | 30.82 | 1.00 | 1.03 | 511.17 |
| other: a line's first word, second text | 3716 | 2164.91 ± 5.1% | 766.33 ± 6.3% | 37.47 ± 6.9% | 2577.93 ± 4.7% | 77.85 ± 7.7% | refused | refused | 2177.97 ± 6.1% | 2.83 | 0.99 | 0.84 | 27.81 |
| other: fourteen octets before an x | 87 | 35537.87 ± 5.1% | 259.32 ± 5.9% | 6.73 ± 4.0% | 3684.93 ± 6.0% | 10.98 ± 5.6% | differs | 20.49 ± 14.8% | 35490.50 ± 3.0% | 137.04 | 1.00 | 9.64 | 3237.91 |
| other: a Greek word | 21815 | 458.76 ± 1.7% | 335.32 ± 2.3% | 36.18 ± 2.4% | 275.74 ± 1.5% | 58.27 ± 15.1% | differs | refused | 461.80 ± 1.4% | 1.37 | 0.99 | 1.66 | 7.87 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.58 ± 9.5% | 26.84 ± 13.0% | 1.07 ± 7.1% | 18.41 ± 5.1% | 2.75 ± 2.2% | differs | 4.59 ± 18.1% | 27.05 ± 4.8% | 0.99 | 0.98 | 1.44 | 9.66 |
| a UUID | 32895 | 22.72 ± 9.5% | 22.71 ± 4.8% | 0.79 ± 2.7% | 14.23 ± 5.0% | 2.82 ± 8.3% | 0.56 ± 8.5% | 3.71 ± 11.0% | 23.00 ± 5.8% | 1.00 | 0.99 | 1.60 | 8.05 |
| an IPv4 address | 33176 | 36.94 ± 6.1% | 36.95 ± 10.3% | 2.52 ± 12.3% | 27.14 ± 3.1% | 7.16 ± 4.9% | differs | 4.69 ± 1.4% | 37.68 ± 4.9% | 1.00 | 0.98 | 1.36 | 5.16 |
| a date and time | 32954 | 34.68 ± 4.2% | 34.30 ± 1.4% | 1.88 ± 5.2% | 19.46 ± 2.7% | 8.17 ± 9.4% | 1.00 ± 4.3% | 9.17 ± 10.2% | 33.52 ± 5.4% | 1.01 | 1.03 | 1.78 | 4.25 |
| a field path | 32606 | 28.60 ± 2.7% | 28.58 ± 2.7% | 1.31 ± 2.5% | 21.21 ± 2.2% | 3.59 ± 1.7% | differs | 3.24 ± 2.4% | 28.59 ± 1.7% | 1.00 | 1.00 | 1.35 | 7.97 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.79 ± 2.8% | 10.83 ± 2.8% | 10.58 ± 5.3% | 13.06 ± 2.4% | 5.67 ± 2.1% | 0.80 ± 3.3% | none | 10.72 ± 2.7% | 1.00 | 1.01 | 0.83 | 1.90 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 280.02 ± 2.1% | 284.98 ± 3.2% | 328.90 ± 1.4% | 101.67 ± 2.5% | 245.14 ± 1.8% | 670.65 ± 3.7% | 4360.66 ± 2.2% | 280.94 ± 2.0% | 0.98 | 1.00 | 2.75 | 1.14 |
| a UUID | 62 | 182.42 ± 2.0% | 185.42 ± 6.3% | 203.79 ± 5.2% | 56.62 ± 6.2% | 120.45 ± 4.7% | 230.64 ± 5.1% | 5448.31 ± 20.0% | 181.92 ± 7.7% | 0.98 | 1.00 | 3.22 | 1.51 |
| an IPv4 address | 29 | 578.49 ± 3.1% | 583.02 ± 1.6% | 797.83 ± 1.7% | 94.98 ± 1.2% | 157.86 ± 14.5% | 431.88 ± 6.4% | 10130.49 ± 1.3% | 578.47 ± 2.5% | 0.99 | 1.00 | 6.09 | 3.66 |
| a date and time | 56 | 409.29 ± 5.9% | 416.44 ± 2.8% | 512.47 ± 6.2% | 91.51 ± 1.5% | 168.57 ± 11.0% | 449.08 ± 2.6% | 5945.67 ± 6.2% | 409.45 ± 7.6% | 0.98 | 1.00 | 4.47 | 2.43 |
| a field path | 39 | 295.19 ± 4.1% | 296.36 ± 1.6% | 340.83 ± 2.8% | 102.05 ± 5.5% | 235.16 ± 4.2% | 722.71 ± 2.1% | 6015.06 ± 8.1% | 295.73 ± 5.6% | 1.00 | 1.00 | 2.89 | 1.26 |
| literal: a word | 7 | 914.02 ± 2.8% | 962.99 ± 5.5% | 1635.87 ± 7.3% | 623.46 ± 5.4% | 773.81 ± 28.9% | 1404.65 ± 9.9% | 37851.90 ± 10.2% | 911.13 ± 11.2% | 0.95 | 1.00 | 1.47 | 1.18 |
| literal: a word that is not there | 8 | 869.66 ± 6.6% | 938.78 ± 3.8% | 1573.52 ± 12.1% | 587.61 ± 13.9% | 748.65 ± 6.3% | 1346.34 ± 3.2% | 37369.72 ± 5.1% | 872.64 ± 7.3% | 0.93 | 1.00 | 1.48 | 1.16 |
| literal: one of four words | 26 | 341.15 ± 4.6% | 532.30 ± 15.2% | 690.62 ± 5.7% | 52.51 ± 6.0% | 299.65 ± 18.0% | 524.58 ± 6.2% | 21284.43 ± 13.2% | 343.00 ± 12.3% | 0.64 | 0.99 | 6.50 | 1.14 |
| literal: a word in any case | 11 | 682.03 ± 9.4% | 733.12 ± 3.6% | 1079.51 ± 4.8% | 18.20 ± 2.7% | 826.33 ± 4.7% | refused | 28389.55 ± 1.4% | 686.79 ± 1.9% | 0.93 | 0.99 | 37.47 | 0.83 |
| literal: an href attribute | 12 | 458.59 ± 3.2% | 477.39 ± 4.4% | 618.73 ± 2.5% | 47.55 ± 2.8% | 552.88 ± 7.7% | 1122.66 ± 3.4% | 25616.64 ± 3.2% | 461.53 ± 2.3% | 0.96 | 0.99 | 9.64 | 0.83 |
| literal: a word, second text | 10 | 767.26 ± 3.5% | 852.33 ± 6.0% | 1360.59 ± 5.1% | 532.52 ± 4.1% | 635.77 ± 28.2% | 1151.33 ± 3.4% | 34648.32 ± 0.6% | 769.90 ± 4.7% | 0.90 | 1.00 | 1.44 | 1.21 |
| class: two capitalized words | 23 | 640.02 ± 3.9% | 691.14 ± 2.1% | 966.64 ± 2.2% | 124.84 ± 3.3% | 615.27 ± 5.5% | 1111.94 ± 1.9% | 7529.98 ± 2.6% | 636.66 ± 3.4% | 0.93 | 1.01 | 5.13 | 1.04 |
| class: a word that ends in ing | 9 | 779.66 ± 2.6% | 892.79 ± 1.2% | 1488.83 ± 4.8% | 162.47 ± 1.5% | 874.87 ± 2.4% | 1679.77 ± 3.8% | 18004.61 ± 1.6% | 789.55 ± 1.8% | 0.87 | 0.99 | 4.80 | 0.89 |
| class: a word in capitals | 16 | 718.85 ± 7.9% | 771.13 ± 3.7% | 1211.66 ± 5.7% | 160.97 ± 4.3% | 937.99 ± 20.6% | 1617.58 ± 6.7% | 9996.16 ± 2.0% | 719.43 ± 6.0% | 0.93 | 1.00 | 4.47 | 0.77 |
| class: a number | 6 | 850.19 ± 11.0% | 929.92 ± 7.9% | 1662.51 ± 10.1% | 46.10 ± 3.3% | 1636.19 ± 9.0% | 2988.64 ± 9.0% | 28322.05 ± 5.1% | 885.20 ± 8.0% | 0.91 | 0.96 | 18.44 | 0.52 |
| class: two capitalized words, second text | 23 | 655.51 ± 9.4% | 710.23 ± 5.0% | 998.33 ± 14.5% | 124.54 ± 7.3% | 618.66 ± 24.0% | 1170.97 ± 4.6% | 7707.85 ± 10.2% | 652.22 ± 9.9% | 0.92 | 1.01 | 5.26 | 1.06 |
| other: a word between two words | 13 | 788.63 ± 17.9% | 839.05 ± 7.9% | 1247.92 ± 6.6% | 168.22 ± 6.5% | 595.70 ± 5.2% | 1241.78 ± 13.6% | 17113.00 ± 6.6% | 782.13 ± 5.9% | 0.94 | 1.01 | 4.69 | 1.32 |
| other: a number before a unit, second text | 15 | 541.45 ± 4.9% | 619.57 ± 8.7% | 828.09 ± 6.0% | 45.12 ± 9.2% | 743.40 ± 6.2% | 1385.82 ± 9.3% | 19624.69 ± 8.4% | 546.97 ± 8.2% | 0.87 | 0.99 | 12.00 | 0.73 |
| other: a heading's start tag | 13 | 519.12 ± 8.9% | 500.97 ± 8.7% | 650.09 ± 7.9% | 48.25 ± 4.4% | 704.53 ± 21.2% | 1262.41 ± 7.0% | 23571.92 ± 2.7% | 509.12 ± 4.3% | 1.04 | 1.02 | 10.76 | 0.74 |
| other: a whole word | 11 | 851.65 ± 18.9% | 881.02 ± 17.0% | 1320.00 ± 13.0% | 156.09 ± 10.1% | 697.33 ± 13.2% | 1320.46 ± 8.4% | 36167.80 ± 10.9% | 815.44 ± 18.4% | 0.97 | 1.04 | 5.46 | 1.22 |
| other: a line's first word, second text | 17 | 768.58 ± 5.9% | 825.71 ± 2.9% | 1284.14 ± 4.4% | 163.19 ± 2.7% | 830.59 ± 5.7% | refused | refused | 760.71 ± 4.3% | 0.93 | 1.01 | 4.71 | 0.93 |
| other: fourteen octets before an x | 16 | 145.36 ± 8.2% | 203.11 ± 8.9% | 225.18 ± 11.0% | 17.49 ± 4.2% | 521.07 ± 16.1% | 580.71 ± 10.5% | 17010.92 ± 8.9% | 148.86 ± 9.9% | 0.72 | 0.98 | 8.31 | 0.28 |
| other: a Greek word | 8 | 577.08 ± 5.4% | 747.75 ± 6.6% | 1155.89 ± 7.0% | 58.16 ± 9.2% | 1581.73 ± 9.5% | 2727.01 ± 6.3% | refused | 578.52 ± 7.3% | 0.77 | 1.00 | 9.92 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26023.07 ± 7.4% | not timed | not timed | 33342.18 ± 4.0% | 3013.14 ± 15.7% | not timed | not timed | 25844.07 ± 5.1% | | 1.01 | 0.78 | 8.64 |
| 01-literal/sherlock-casei-en | 522 | 5993.94 ± 9.9% | not timed | not timed | 9144.18 ± 2.2% | 40.12 ± 24.9% | not timed | not timed | 5989.58 ± 8.3% | | 1.00 | 0.66 | 149.39 |
| 01-literal/sherlock-ru | 724 | 28098.27 ± 5.2% | not timed | not timed | 34619.94 ± 23.7% | 1896.46 ± 33.4% | not timed | not timed | 27651.18 ± 7.2% | | 1.02 | 0.81 | 14.82 |
| 01-literal/sherlock-casei-ru | 746 | 8910.54 ± 8.2% | not timed | not timed | 7445.42 ± 7.6% | 45.36 ± 8.3% | not timed | not timed | 8899.41 ± 6.8% | | 1.00 | 1.20 | 196.46 |
| 01-literal/sherlock-zh | 30 | 56013.99 ± 6.2% | not timed | not timed | 47162.92 ± 3.1% | 1680.53 ± 4.4% | not timed | not timed | 57576.82 ± 7.2% | | 0.97 | 1.19 | 33.33 |
| 02-literal-alternate/sherlock-en | 714 | 12827.97 ± 4.8% | not timed | not timed | 10594.34 ± 8.9% | 23.67 ± 1.9% | not timed | not timed | 12788.44 ± 6.0% | | 1.00 | 1.21 | 541.98 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2239.06 ± 9.5% | not timed | not timed | 2265.40 ± 10.1% | 14.43 ± 8.8% | not timed | not timed | 2191.18 ± 7.1% | | 1.02 | 0.99 | 155.12 |
| 02-literal-alternate/sherlock-ru | 899 | 7457.00 ± 6.9% | not timed | not timed | 5808.73 ± 6.0% | 29.37 ± 9.9% | not timed | not timed | 7435.52 ± 4.4% | | 1.00 | 1.28 | 253.87 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2014.37 ± 5.0% | not timed | not timed | 1119.95 ± 9.6% | 12.71 ± 5.9% | not timed | not timed | 1950.71 ± 8.3% | | 1.03 | 1.80 | 158.50 |
| 02-literal-alternate/sherlock-zh | 207 | 18278.23 ± 4.8% | not timed | not timed | 12288.45 ± 5.0% | 41.29 ± 4.3% | not timed | not timed | 18600.44 ± 7.5% | | 0.98 | 1.49 | 442.70 |
| 03-date/ascii | 111817 | 122.15 ± 7.2% | not timed | not timed | 99.96 ± 3.6% | 0.24 ± 9.1% | not timed | not timed | 121.90 ± 7.2% | | 1.00 | 1.22 | 508.21 |
| 04-ruff-noqa/real | 84 | 682.49 ± 2.1% | not timed | not timed | 544.88 ± 5.6% | 24.49 ± 3.5% | not timed | not timed | 687.23 ± 3.3% | | 0.99 | 1.25 | 27.87 |
| 04-ruff-noqa/tweaked | 44 | 633.41 ± 10.4% | not timed | not timed | 562.34 ± 1.8% | 438.15 ± 19.7% | not timed | not timed | 643.94 ± 6.9% | | 0.98 | 1.13 | 1.45 |
| 05-lexer-veryl/single | 124800 | 4.13 ± 7.8% | not timed | not timed | 5.97 ± 10.3% | 0.28 ± 7.1% | not timed | not timed | 4.15 ± 7.0% | | 1.00 | 0.69 | 15.00 |
| 06-cloud-flare-redos/original | 107 | 254.29 ± 4.5% | not timed | not timed | 220.83 ± 8.9% | 27.62 ± 6.4% | not timed | not timed | 262.57 ± 6.5% | | 0.97 | 1.15 | 9.21 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.10 ± 8.4% | not timed | not timed | 246.72 ± 2.7% | 33.80 ± 5.8% | not timed | not timed | 260.38 ± 12.9% | | 1.01 | 1.07 | 7.81 |
| 06-cloud-flare-redos/simplified-long | 10000 | 273.43 ± 3.6% | not timed | not timed | 267.22 ± 3.8% | 36.86 ± 4.5% | not timed | not timed | 272.70 ± 3.7% | | 1.00 | 1.02 | 7.42 |
| 07-unicode-character-data/parse-line | 558784 | 271.59 ± 7.0% | not timed | not timed | 206.60 ± 4.5% | 52.06 ± 6.2% | not timed | not timed | 277.42 ± 3.1% | | 0.98 | 1.31 | 5.22 |
| 08-words/all-english | 56691 | 109.30 ± 4.0% | not timed | not timed | 85.71 ± 2.2% | 15.71 ± 8.0% | not timed | not timed | 105.63 ± 6.7% | | 1.03 | 1.28 | 6.96 |
| 08-words/long-english | 839 | 897.84 ± 1.3% | not timed | not timed | 531.95 ± 1.6% | 37.73 ± 2.6% | not timed | not timed | 899.87 ± 4.1% | | 1.00 | 1.69 | 23.80 |
| 09-aws-keys/full | 0 | 527.95 ± 7.3% | not timed | not timed | 564.27 ± 6.8% | 79.78 ± 6.1% | not timed | not timed | 531.21 ± 21.6% | | 0.99 | 0.94 | 6.62 |
| 09-aws-keys/quick | 0 | 1054.93 ± 1.9% | not timed | not timed | 1006.88 ± 2.0% | 516.26 ± 2.0% | not timed | not timed | 1090.14 ± 2.3% | | 0.97 | 1.05 | 2.04 |
| 10-bounded-repeat/letters-en | 1833 | 614.63 ± 3.5% | not timed | not timed | 601.17 ± 4.3% | 24.35 ± 3.7% | not timed | not timed | 612.74 ± 1.8% | | 1.00 | 1.02 | 25.24 |
| 10-bounded-repeat/letters-ru | 3475 | 365.33 ± 4.6% | not timed | not timed | 510.39 ± 4.3% | 25.61 ± 7.5% | not timed | not timed | 353.42 ± 6.2% | | 1.03 | 0.72 | 14.26 |
| 10-bounded-repeat/context | 53 | 86.50 ± 2.9% | not timed | not timed | 70.61 ± 8.4% | 23.98 ± 5.1% | not timed | not timed | 88.17 ± 5.8% | | 0.98 | 1.23 | 3.61 |
| 10-bounded-repeat/capitals | 11 | 997.78 ± 7.3% | not timed | not timed | 584.85 ± 2.7% | 41.49 ± 4.9% | not timed | not timed | 1010.20 ± 3.9% | | 0.99 | 1.71 | 24.05 |
| 11-unstructured-to-json/extract | 600 | 49.52 ± 2.6% | not timed | not timed | 86.83 ± 2.3% | 62.17 ± 4.6% | not timed | not timed | 48.87 ± 1.7% | | 1.01 | 0.57 | 0.80 |
| 12-dictionary/single | 1 | 511.70 ± 10.7% | not timed | not timed | 503.31 ± 11.3% | 0.51 ± 8.7% | not timed | not timed | 529.57 ± 6.8% | | 0.97 | 1.02 | 1004.67 |
| 14-quadratic/1x | 100 | 14.14 ± 3.6% | not timed | not timed | 13.77 ± 3.7% | 1.17 ± 4.6% | not timed | not timed | 14.10 ± 4.6% | | 1.00 | 1.03 | 12.09 |
| 14-quadratic/2x | 200 | 8.04 ± 1.5% | not timed | not timed | 6.60 ± 3.2% | 0.64 ± 4.0% | not timed | not timed | 7.94 ± 5.7% | | 1.01 | 1.22 | 12.62 |
| 14-quadratic/10x | 1000 | 1.75 ± 4.2% | not timed | not timed | 1.19 ± 4.1% | 0.14 ± 6.0% | not timed | not timed | 1.76 ± 4.3% | | 0.99 | 1.46 | 12.59 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.91 ± 3.1% | not timed | not timed | 0.42 ± 5.8% | 0.62 ± 4.7% | not timed | not timed | 1.91 ± 7.7% | | 1.00 | 4.55 | 3.10 |
| 04-ruff-noqa/compile-real | 1 | 129.11 ± 2.0% | not timed | not timed | 17.29 ± 3.0% | 153.08 ± 4.7% | not timed | not timed | 128.01 ± 1.3% | | 1.01 | 7.47 | 0.84 |
| 05-lexer-veryl/compile-single | 1 | 19.19 ± 3.9% | not timed | not timed | 3.20 ± 2.2% | 8.12 ± 2.8% | not timed | not timed | 19.37 ± 4.0% | | 0.99 | 5.99 | 2.36 |
| 07-unicode-character-data/compile | 1 | 76.76 ± 1.7% | not timed | not timed | 32.68 ± 3.6% | 46.03 ± 13.4% | not timed | not timed | 75.77 ± 4.1% | | 1.01 | 2.35 | 1.67 |
| 09-aws-keys/compile-full | 1 | 52.29 ± 3.7% | not timed | not timed | 10.19 ± 1.9% | 28.57 ± 4.1% | not timed | not timed | 52.50 ± 2.0% | | 1.00 | 5.13 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 246.53 ± 9.2% | not timed | not timed | 62.55 ± 9.4% | 153.19 ± 8.8% | not timed | not timed | 233.34 ± 9.8% | | 1.06 | 3.94 | 1.61 |
| 10-bounded-repeat/compile-context | 1 | 17.62 ± 7.4% | not timed | not timed | 13.39 ± 5.2% | 19.25 ± 7.1% | not timed | not timed | 18.04 ± 5.9% | | 0.98 | 1.32 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 103.91 ± 2.2% | not timed | not timed | 9.90 ± 1.4% | 28.19 ± 2.3% | not timed | not timed | 102.88 ± 2.1% | | 1.01 | 10.50 | 3.69 |
| 11-unstructured-to-json/compile | 1 | 109.96 ± 3.7% | not timed | not timed | 49.54 ± 3.7% | 75.65 ± 6.9% | not timed | not timed | 109.22 ± 2.2% | | 1.01 | 2.22 | 1.45 |
| 12-dictionary/compile-single | 1 | 0.36 ± 1.2% | not timed | not timed | 0.07 ± 2.5% | 0.10 ± 14.1% | not timed | not timed | 0.35 ± 3.6% | | 1.01 | 5.30 | 3.73 |

