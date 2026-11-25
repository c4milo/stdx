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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506983354 |
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
| literal: a word | 217 | 63655.95 ± 5.2% | 6408.11 ± 5.6% | 45.44 ± 6.6% | 51676.12 ± 5.4% | 15712.27 ± 9.1% | 15.77 ± 4.5% | 160.91 ± 5.2% | 64276.44 ± 5.5% | 9.93 | 0.99 | 1.23 | 4.05 |
| literal: a word that is not there | 0 | 86878.56 ± 38.6% | 6172.54 ± 66.2% | 47.30 ± 4.3% | 67573.55 ± 4.1% | 57555.50 ± 4.7% | 15.97 ± 2.1% | 146.59 ± 8.3% | 86129.03 ± 5.4% | 14.08 | 1.01 | 1.29 | 1.51 |
| literal: one of four words | 661 | 22373.79 ± 6.9% | 2422.59 ± 6.5% | 25.59 ± 5.9% | 14867.32 ± 5.5% | 39.69 ± 26.1% | 5.14 ± 4.7% | 13.40 ± 19.9% | 22586.76 ± 6.1% | 9.24 | 0.99 | 1.50 | 563.76 |
| literal: a word in any case | 217 | 61869.87 ± 4.0% | 2638.40 ± 0.9% | 34.58 ± 4.3% | 14319.29 ± 4.0% | 75.01 ± 4.1% | refused | differs | 61230.37 ± 6.0% | 23.45 | 1.01 | 4.32 | 824.79 |
| literal: an href attribute | 33 | 54169.88 ± 1.3% | 754.39 ± 4.4% | 40.35 ± 5.0% | 46296.47 ± 5.8% | 3632.31 ± 5.8% | 11.57 ± 5.2% | 126.22 ± 11.2% | 52864.74 ± 13.0% | 71.81 | 1.02 | 1.17 | 14.91 |
| literal: a word, second text | 123 | 63572.26 ± 5.9% | 4477.12 ± 5.2% | 45.22 ± 5.7% | 49169.51 ± 4.2% | 14766.60 ± 2.9% | 21.43 ± 26.8% | 134.73 ± 41.4% | 64252.56 ± 5.7% | 14.20 | 0.99 | 1.29 | 4.31 |
| class: two capitalized words | 1331 | 1144.07 ± 4.2% | 746.33 ± 5.9% | 41.85 ± 5.6% | 674.55 ± 9.8% | 62.04 ± 6.6% | 13.76 ± 5.6% | 106.71 ± 4.9% | 1156.47 ± 5.0% | 1.53 | 0.99 | 1.70 | 18.44 |
| class: a word that ends in ing | 3399 | 661.33 ± 3.8% | 662.66 ± 6.3% | 27.78 ± 8.4% | 637.78 ± 8.5% | 44.03 ± 4.9% | 7.87 ± 8.7% | 31.52 ± 11.2% | 667.99 ± 6.2% | 1.00 | 0.99 | 1.04 | 15.02 |
| class: a word in capitals | 2332 | 1574.87 ± 1.6% | 703.40 ± 2.5% | 41.66 ± 1.9% | 644.03 ± 1.2% | 62.74 ± 18.8% | 15.80 ± 1.8% | 131.65 ± 3.9% | 1564.25 ± 3.2% | 2.24 | 1.01 | 2.45 | 25.10 |
| class: a number | 8288 | 2857.83 ± 4.7% | 992.65 ± 4.0% | 42.33 ± 5.0% | 2203.76 ± 2.7% | 58.18 ± 15.0% | 0.43 ± 2.3% | 95.98 ± 2.1% | 2847.19 ± 2.7% | 2.88 | 1.00 | 1.30 | 49.12 |
| class: two capitalized words, second text | 5359 | 633.87 ± 4.1% | 643.16 ± 5.0% | 37.28 ± 14.0% | 582.56 ± 3.5% | 50.27 ± 7.4% | 17.67 ± 4.3% | 99.27 ± 8.7% | 639.47 ± 5.1% | 0.99 | 0.99 | 1.09 | 12.61 |
| other: a word between two words | 6104 | 1170.92 ± 4.9% | 714.79 ± 4.2% | 34.75 ± 6.7% | 951.73 ± 2.2% | 169.66 ± 4.0% | 10.14 ± 2.3% | 110.47 ± 7.1% | 1165.93 ± 3.4% | 1.64 | 1.00 | 1.23 | 6.90 |
| other: a number before a unit, second text | 1481 | 13392.56 ± 6.2% | 1421.01 ± 6.7% | 40.36 ± 33.7% | 10492.11 ± 6.1% | 59.99 ± 12.3% | 19.31 ± 4.4% | 106.17 ± 7.5% | 13251.87 ± 6.5% | 9.42 | 1.01 | 1.28 | 223.24 |
| other: a heading's start tag | 110 | 31310.67 ± 8.0% | 868.60 ± 5.9% | 41.62 ± 16.0% | 3385.90 ± 6.4% | 2554.01 ± 7.4% | 14.49 ± 5.8% | 148.03 ± 11.1% | 31444.34 ± 7.7% | 36.05 | 1.00 | 9.25 | 12.26 |
| other: a whole word | 217 | 40919.30 ± 0.9% | 729.73 ± 3.0% | 44.70 ± 8.4% | 35250.07 ± 1.0% | 73.61 ± 6.0% | 13.47 ± 4.9% | 82.88 ± 1.3% | 41328.82 ± 1.8% | 56.07 | 0.99 | 1.16 | 555.87 |
| other: a line's first word, second text | 3716 | 3498.65 ± 6.3% | 709.49 ± 5.1% | 50.17 ± 8.0% | 3478.90 ± 7.4% | 99.25 ± 12.6% | refused | refused | 3479.62 ± 6.5% | 4.93 | 1.01 | 1.01 | 35.25 |
| other: fourteen octets before an x | 87 | 53437.37 ± 3.5% | 351.89 ± 0.6% | 9.77 ± 4.3% | 5103.87 ± 2.6% | 15.04 ± 4.7% | differs | 26.98 ± 1.6% | 54010.91 ± 1.4% | 151.86 | 0.99 | 10.47 | 3552.69 |
| other: a Greek word | 21815 | 690.17 ± 2.1% | 566.67 ± 3.8% | 46.75 ± 8.1% | 357.25 ± 8.7% | 81.14 ± 7.8% | differs | refused | 677.77 ± 2.5% | 1.22 | 1.02 | 1.93 | 8.51 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 39.61 ± 3.4% | 39.05 ± 9.1% | 1.54 ± 63.6% | 24.87 ± 11.1% | 3.79 ± 0.5% | differs | 6.18 ± 2.3% | 38.78 ± 5.2% | 1.01 | 1.02 | 1.59 | 10.45 |
| a UUID | 32895 | 34.94 ± 6.9% | 35.14 ± 6.8% | 1.05 ± 6.1% | 18.66 ± 7.1% | 3.64 ± 8.8% | 0.72 ± 5.2% | 4.84 ± 12.4% | 34.96 ± 6.7% | 0.99 | 1.00 | 1.87 | 9.60 |
| an IPv4 address | 33176 | 49.42 ± 5.0% | 49.64 ± 1.4% | 3.35 ± 6.5% | 34.29 ± 0.5% | 9.35 ± 4.9% | differs | 6.14 ± 2.5% | 49.65 ± 3.6% | 1.00 | 1.00 | 1.44 | 5.29 |
| a date and time | 32954 | 48.67 ± 27.4% | 48.77 ± 64.1% | 2.52 ± 9.8% | 27.13 ± 4.7% | 11.11 ± 3.4% | 1.35 ± 1.1% | 11.90 ± 9.9% | 47.62 ± 3.5% | 1.00 | 1.02 | 1.79 | 4.38 |
| a field path | 32606 | 42.64 ± 2.6% | 42.84 ± 5.1% | 1.70 ± 1.9% | 28.12 ± 6.8% | 4.81 ± 5.7% | differs | 4.37 ± 21.0% | 41.93 ± 3.2% | 1.00 | 1.02 | 1.52 | 8.87 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 16.34 ± 5.6% | 15.62 ± 6.2% | 16.26 ± 5.8% | 17.98 ± 4.9% | 7.82 ± 6.3% | 1.08 ± 3.7% | none | 15.35 ± 3.6% | 1.05 | 1.06 | 0.91 | 2.09 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 370.80 ± 6.5% | 369.38 ± 5.4% | 422.19 ± 4.2% | 135.48 ± 5.5% | 315.59 ± 22.3% | 882.28 ± 22.0% | 5783.56 ± 54.8% | 370.72 ± 3.4% | 1.00 | 1.00 | 2.74 | 1.17 |
| a UUID | 62 | 244.12 ± 34.6% | 240.43 ± 61.0% | 272.56 ± 46.3% | 77.44 ± 35.9% | 155.85 ± 32.6% | 313.66 ± 7.4% | 7101.85 ± 11.3% | 239.66 ± 4.8% | 1.02 | 1.02 | 3.15 | 1.57 |
| an IPv4 address | 29 | 690.41 ± 13.4% | 692.20 ± 11.5% | 947.04 ± 2.9% | 119.65 ± 1.5% | 195.50 ± 50.2% | 562.55 ± 3.3% | 12557.00 ± 1.7% | 691.03 ± 6.7% | 1.00 | 1.00 | 5.77 | 3.53 |
| a date and time | 56 | 505.61 ± 3.0% | 498.38 ± 5.3% | 614.00 ± 5.6% | 113.31 ± 6.8% | 215.71 ± 7.1% | 561.68 ± 6.2% | 8050.18 ± 8.5% | 503.00 ± 3.0% | 1.01 | 1.01 | 4.46 | 2.34 |
| a field path | 39 | 368.93 ± 1.9% | 368.96 ± 3.4% | 425.98 ± 28.1% | 126.26 ± 7.6% | 302.62 ± 13.4% | 908.38 ± 5.9% | 7479.86 ± 4.8% | 364.24 ± 34.3% | 1.00 | 1.01 | 2.92 | 1.22 |
| literal: a word | 7 | 1085.89 ± 14.1% | 1155.96 ± 17.1% | 1942.69 ± 53.0% | 840.42 ± 2.7% | 1028.23 ± 144.3% | 1860.19 ± 8.4% | 47457.18 ± 6.1% | 1056.02 ± 12.7% | 0.94 | 1.03 | 1.29 | 1.06 |
| literal: a word that is not there | 8 | 1005.27 ± 1.6% | 1092.80 ± 0.9% | 1820.67 ± 12.3% | 752.98 ± 6.7% | 941.50 ± 4.1% | 1713.43 ± 1.6% | 45853.55 ± 2.1% | 1005.99 ± 0.7% | 0.92 | 1.00 | 1.34 | 1.07 |
| literal: one of four words | 26 | 410.68 ± 3.6% | 651.85 ± 4.0% | 843.26 ± 3.5% | 67.98 ± 6.0% | 372.31 ± 23.9% | 662.11 ± 6.3% | 27136.95 ± 10.3% | 404.94 ± 2.6% | 0.63 | 1.01 | 6.04 | 1.10 |
| literal: a word in any case | 11 | 771.71 ± 5.7% | 815.31 ± 6.2% | 1141.87 ± 6.0% | 23.48 ± 3.7% | 1093.04 ± 4.3% | refused | 40245.78 ± 5.4% | 773.30 ± 5.9% | 0.95 | 1.00 | 32.87 | 0.71 |
| literal: an href attribute | 12 | 573.07 ± 5.3% | 590.89 ± 5.1% | 768.10 ± 4.6% | 61.45 ± 6.4% | 733.07 ± 29.4% | 1447.00 ± 10.1% | 33419.70 ± 4.8% | 566.81 ± 5.8% | 0.97 | 1.01 | 9.33 | 0.78 |
| literal: a word, second text | 10 | 977.19 ± 6.7% | 1051.60 ± 4.4% | 1678.47 ± 3.5% | 724.72 ± 5.5% | 870.38 ± 5.2% | 1569.49 ± 3.6% | 47086.84 ± 1.3% | 956.34 ± 5.3% | 0.93 | 1.02 | 1.35 | 1.12 |
| class: two capitalized words | 23 | 769.27 ± 4.1% | 826.55 ± 2.7% | 1188.84 ± 3.2% | 165.21 ± 4.6% | 812.13 ± 5.8% | 1424.96 ± 4.7% | 9689.87 ± 4.1% | 753.26 ± 6.5% | 0.93 | 1.02 | 4.66 | 0.95 |
| class: a word that ends in ing | 9 | 953.36 ± 4.6% | 1107.60 ± 6.1% | 1829.27 ± 4.9% | 212.57 ± 5.8% | 1124.79 ± 6.3% | 2266.47 ± 4.1% | 25180.98 ± 4.6% | 959.96 ± 3.1% | 0.86 | 0.99 | 4.48 | 0.85 |
| class: a word in capitals | 16 | 875.56 ± 4.3% | 940.13 ± 12.3% | 1482.59 ± 14.3% | 214.63 ± 3.2% | 1207.45 ± 8.9% | 2046.66 ± 3.7% | 13051.97 ± 4.5% | 854.92 ± 2.3% | 0.93 | 1.02 | 4.08 | 0.73 |
| class: a number | 6 | 1090.04 ± 5.8% | 1205.27 ± 5.4% | 2153.45 ± 7.2% | 59.65 ± 3.1% | 2120.82 ± 3.6% | 3732.65 ± 4.1% | 36504.68 ± 5.1% | 1063.25 ± 5.5% | 0.90 | 1.03 | 18.27 | 0.51 |
| class: two capitalized words, second text | 23 | 769.21 ± 5.0% | 840.73 ± 2.5% | 1188.63 ± 1.9% | 163.23 ± 2.4% | 819.55 ± 1.2% | 1450.62 ± 1.3% | 9972.71 ± 1.0% | 769.54 ± 4.5% | 0.91 | 1.00 | 4.71 | 0.94 |
| other: a word between two words | 13 | 916.40 ± 7.0% | 954.42 ± 5.0% | 1489.82 ± 3.7% | 209.80 ± 8.9% | 750.59 ± 22.7% | 1558.22 ± 8.7% | 22614.44 ± 40.7% | 902.38 ± 72.9% | 0.96 | 1.02 | 4.37 | 1.22 |
| other: a number before a unit, second text | 15 | 673.90 ± 4.7% | 757.41 ± 6.7% | 1009.67 ± 6.0% | 57.37 ± 5.5% | 976.60 ± 4.5% | 1778.02 ± 3.5% | 24384.63 ± 2.2% | 679.22 ± 24.6% | 0.89 | 0.99 | 11.75 | 0.69 |
| other: a heading's start tag | 13 | 608.32 ± 2.9% | 626.12 ± 3.7% | 820.14 ± 4.2% | 61.12 ± 5.0% | 950.15 ± 3.6% | 1683.70 ± 3.2% | 29629.19 ± 5.1% | 613.22 ± 1.4% | 0.97 | 0.99 | 9.95 | 0.64 |
| other: a whole word | 11 | 981.97 ± 2.6% | 1049.99 ± 13.8% | 1667.77 ± 1.8% | 195.30 ± 3.1% | 929.98 ± 0.8% | 1637.89 ± 2.1% | 46094.18 ± 2.5% | 993.54 ± 4.7% | 0.94 | 0.99 | 5.03 | 1.06 |
| other: a line's first word, second text | 17 | 927.39 ± 2.4% | 978.95 ± 1.6% | 1531.86 ± 3.2% | 206.04 ± 1.9% | 1079.30 ± 3.3% | refused | refused | 925.54 ± 1.3% | 0.95 | 1.00 | 4.50 | 0.86 |
| other: fourteen octets before an x | 16 | 190.03 ± 8.0% | 265.56 ± 4.5% | 309.16 ± 3.6% | 23.28 ± 5.0% | 695.37 ± 2.9% | 767.90 ± 33.7% | 20998.37 ± 8.3% | 190.73 ± 6.9% | 0.72 | 1.00 | 8.16 | 0.27 |
| other: a Greek word | 8 | 714.46 ± 13.6% | 998.21 ± 3.3% | 1616.94 ± 1.6% | 77.89 ± 1.0% | 2113.38 ± 1.4% | 3555.75 ± 3.9% | refused | 741.58 ± 1.1% | 0.72 | 0.96 | 9.17 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 44903.21 ± 8.5% | not timed | not timed | 44088.42 ± 5.0% | 3589.50 ± 21.8% | not timed | not timed | 45223.61 ± 7.3% | | 0.99 | 1.02 | 12.51 |
| 01-literal/sherlock-casei-en | 522 | 41142.19 ± 6.4% | not timed | not timed | 11893.40 ± 5.5% | 53.34 ± 6.6% | not timed | not timed | 40853.16 ± 5.9% | | 1.01 | 3.46 | 771.34 |
| 01-literal/sherlock-ru | 724 | 45333.80 ± 2.5% | not timed | not timed | 43223.69 ± 2.1% | 2321.06 ± 6.0% | not timed | not timed | 45194.37 ± 2.6% | | 1.00 | 1.05 | 19.53 |
| 01-literal/sherlock-casei-ru | 746 | 14713.88 ± 2.1% | not timed | not timed | 9186.61 ± 3.0% | 55.73 ± 7.7% | not timed | not timed | 14731.12 ± 4.0% | | 1.00 | 1.60 | 264.02 |
| 01-literal/sherlock-zh | 30 | 79369.64 ± 2.2% | not timed | not timed | 58335.87 ± 3.3% | 2104.31 ± 2.8% | not timed | not timed | 79227.26 ± 1.3% | | 1.00 | 1.36 | 37.72 |
| 02-literal-alternate/sherlock-en | 714 | 18485.88 ± 63.1% | not timed | not timed | 13270.06 ± 4.8% | 28.34 ± 8.7% | not timed | not timed | 18605.16 ± 3.1% | | 0.99 | 1.39 | 652.36 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3063.91 ± 6.6% | not timed | not timed | 2888.05 ± 1.9% | 17.64 ± 5.5% | not timed | not timed | 3040.96 ± 6.6% | | 1.01 | 1.06 | 173.65 |
| 02-literal-alternate/sherlock-ru | 899 | 12420.00 ± 4.1% | not timed | not timed | 7526.43 ± 7.5% | 37.40 ± 3.9% | not timed | not timed | 12448.20 ± 15.3% | | 1.00 | 1.65 | 332.10 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2767.91 ± 4.9% | not timed | not timed | 1437.62 ± 2.3% | 15.90 ± 13.0% | not timed | not timed | 2764.42 ± 4.9% | | 1.00 | 1.93 | 174.06 |
| 02-literal-alternate/sherlock-zh | 207 | 24812.80 ± 5.9% | not timed | not timed | 15699.62 ± 4.9% | 52.37 ± 1.0% | not timed | not timed | 24820.84 ± 1.2% | | 1.00 | 1.58 | 473.77 |
| 03-date/ascii | 111817 | 181.20 ± 1.8% | not timed | not timed | 116.07 ± 8.6% | 0.30 ± 6.5% | not timed | not timed | 181.49 ± 2.6% | | 1.00 | 1.56 | 600.40 |
| 04-ruff-noqa/real | 84 | 633.77 ± 3.2% | not timed | not timed | 667.22 ± 2.4% | 30.04 ± 2.1% | not timed | not timed | 656.09 ± 2.1% | | 0.97 | 0.95 | 21.10 |
| 04-ruff-noqa/tweaked | 44 | 827.89 ± 30.8% | not timed | not timed | 688.53 ± 71.6% | 468.15 ± 17.3% | not timed | not timed | 829.47 ± 2.4% | | 1.00 | 1.20 | 1.77 |
| 05-lexer-veryl/single | 124800 | 7.29 ± 9.9% | not timed | not timed | 7.33 ± 12.7% | 0.34 ± 15.7% | not timed | not timed | 7.01 ± 3.5% | | 1.04 | 0.99 | 21.68 |
| 06-cloud-flare-redos/original | 107 | 550.58 ± 3.2% | not timed | not timed | 280.00 ± 1.6% | 37.68 ± 4.5% | not timed | not timed | 547.34 ± 3.7% | | 1.01 | 1.97 | 14.61 |
| 06-cloud-flare-redos/simplified-short | 102 | 550.44 ± 4.6% | not timed | not timed | 293.00 ± 5.5% | 40.71 ± 2.0% | not timed | not timed | 550.64 ± 1.8% | | 1.00 | 1.88 | 13.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 639.10 ± 2.7% | not timed | not timed | 318.82 ± 3.0% | 44.31 ± 6.0% | not timed | not timed | 643.05 ± 1.2% | | 0.99 | 2.00 | 14.42 |
| 07-unicode-character-data/parse-line | 558784 | 320.79 ± 5.4% | not timed | not timed | 254.19 ± 1.3% | 61.18 ± 7.9% | not timed | not timed | 329.06 ± 4.0% | | 0.97 | 1.26 | 5.24 |
| 08-words/all-english | 56691 | 171.31 ± 2.0% | not timed | not timed | 105.76 ± 2.3% | 18.02 ± 6.0% | not timed | not timed | 171.63 ± 3.9% | | 1.00 | 1.62 | 9.51 |
| 08-words/long-english | 839 | 733.35 ± 15.1% | not timed | not timed | 702.98 ± 33.7% | 47.21 ± 7.1% | not timed | not timed | 730.87 ± 3.7% | | 1.00 | 1.04 | 15.53 |
| 09-aws-keys/full | 0 | 660.66 ± 5.4% | not timed | not timed | 700.49 ± 3.4% | 95.57 ± 2.1% | not timed | not timed | 670.25 ± 1.4% | | 0.99 | 0.94 | 6.91 |
| 09-aws-keys/quick | 0 | 1521.77 ± 4.4% | not timed | not timed | 1261.65 ± 2.9% | 560.79 ± 2.9% | not timed | not timed | 1479.40 ± 5.0% | | 1.03 | 1.21 | 2.71 |
| 10-bounded-repeat/letters-en | 1833 | 839.34 ± 3.0% | not timed | not timed | 718.19 ± 3.4% | 29.80 ± 5.9% | not timed | not timed | 827.89 ± 3.6% | | 1.01 | 1.17 | 28.16 |
| 10-bounded-repeat/letters-ru | 3475 | 708.01 ± 4.4% | not timed | not timed | 641.00 ± 5.4% | 29.43 ± 20.0% | not timed | not timed | 705.62 ± 4.8% | | 1.00 | 1.10 | 24.06 |
| 10-bounded-repeat/context | 53 | 117.32 ± 5.5% | not timed | not timed | 90.76 ± 34.4% | 29.14 ± 6.1% | not timed | not timed | 116.31 ± 10.4% | | 1.01 | 1.29 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 781.03 ± 8.5% | not timed | not timed | 744.52 ± 4.6% | 54.26 ± 1.4% | not timed | not timed | 779.50 ± 7.8% | | 1.00 | 1.05 | 14.39 |
| 11-unstructured-to-json/extract | 600 | 75.53 ± 3.9% | not timed | not timed | 106.62 ± 3.9% | 76.03 ± 9.1% | not timed | not timed | 75.07 ± 3.1% | | 1.01 | 0.71 | 0.99 |
| 12-dictionary/single | 1 | 654.05 ± 4.2% | not timed | not timed | 626.25 ± 3.8% | 0.65 ± 3.4% | not timed | not timed | 647.89 ± 6.8% | | 1.01 | 1.04 | 1012.53 |
| 14-quadratic/1x | 100 | 40.00 ± 13.6% | not timed | not timed | 15.28 ± 8.3% | 1.47 ± 1.7% | not timed | not timed | 40.47 ± 3.7% | | 0.99 | 2.62 | 27.24 |
| 14-quadratic/2x | 200 | 32.41 ± 3.5% | not timed | not timed | 8.16 ± 3.3% | 0.80 ± 3.1% | not timed | not timed | 32.76 ± 3.3% | | 0.99 | 3.97 | 40.31 |
| 14-quadratic/10x | 1000 | 11.22 ± 4.2% | not timed | not timed | 1.49 ± 3.9% | 0.18 ± 18.2% | not timed | not timed | 11.25 ± 1.1% | | 1.00 | 7.51 | 62.46 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.04 ± 6.2% | not timed | not timed | 0.56 ± 0.7% | 0.88 ± 3.5% | not timed | not timed | 2.04 ± 0.5% | | 1.00 | 3.66 | 2.33 |
| 04-ruff-noqa/compile-real | 1 | 191.23 ± 1.6% | not timed | not timed | 22.28 ± 1.9% | 230.00 ± 2.3% | not timed | not timed | 190.52 ± 4.7% | | 1.00 | 8.58 | 0.83 |
| 05-lexer-veryl/compile-single | 1 | 23.64 ± 1.8% | not timed | not timed | 4.03 ± 3.4% | 11.17 ± 2.0% | not timed | not timed | 23.70 ± 2.1% | | 1.00 | 5.86 | 2.12 |
| 07-unicode-character-data/compile | 1 | 180.41 ± 20.0% | not timed | not timed | 37.53 ± 81.0% | 60.84 ± 75.0% | not timed | not timed | 183.23 ± 33.5% | | 0.98 | 4.81 | 2.97 |
| 09-aws-keys/compile-full | 1 | 79.80 ± 5.3% | not timed | not timed | 12.92 ± 7.0% | 37.83 ± 5.4% | not timed | not timed | 79.60 ± 4.0% | | 1.00 | 6.18 | 2.11 |
| 09-aws-keys/compile-quick | 1 | 292.72 ± 4.9% | not timed | not timed | 78.52 ± 5.7% | 210.63 ± 8.2% | not timed | not timed | 284.19 ± 10.3% | | 1.03 | 3.73 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 85.77 ± 3.8% | not timed | not timed | 17.25 ± 5.4% | 25.59 ± 11.6% | not timed | not timed | 85.45 ± 6.1% | | 1.00 | 4.97 | 3.35 |
| 10-bounded-repeat/compile-capitals | 1 | 137.49 ± 4.0% | not timed | not timed | 13.28 ± 2.6% | 38.99 ± 5.9% | not timed | not timed | 136.77 ± 2.4% | | 1.01 | 10.35 | 3.53 |
| 11-unstructured-to-json/compile | 1 | 289.53 ± 9.9% | not timed | not timed | 65.66 ± 1.2% | 117.05 ± 2.2% | not timed | not timed | 292.52 ± 3.9% | | 0.99 | 4.41 | 2.47 |
| 12-dictionary/compile-single | 1 | 0.47 ± 2.4% | not timed | not timed | 0.10 ± 23.5% | 0.14 ± 25.0% | not timed | not timed | 0.47 ± 2.1% | | 1.00 | 4.68 | 3.28 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.93 ± 16.6% | not timed | not timed | 10.35 ± 0.9% | 0.80 ± 28.6% | not timed | not timed | 10.07 ± 18.3% | | 1.09 | 1.06 | 13.59 |
| dictionary/search/english-10 | 690 | 1.86 ± 10.9% | not timed | not timed | 232.98 ± 4.2% | 0.01 ± 2.4% | not timed | not timed | 1.87 ± 5.1% | | 1.00 | 0.0080 | 175.70 |
| dictionary/search/english-15 | 15 | 660.39 ± 3.9% | not timed | not timed | 624.62 ± 4.5% | 0.61 ± 5.8% | not timed | not timed | 648.72 ± 8.6% | | 1.02 | 1.06 | 1088.24 |
| folly/awyer-inn-busted | 1 | 7173.18 ± 1.6% | not timed | not timed | 170.20 ± 4.3% | 73.84 ± 5.4% | not timed | not timed | 7164.37 ± 5.8% | | 1.00 | 42.15 | 97.15 |
| folly/literal-never-match-rare | 0 | 84986.15 ± 5.7% | not timed | not timed | 68657.46 ± 6.0% | 90188.71 ± 11.0% | not timed | not timed | 85237.76 ± 3.1% | | 1.00 | 1.24 | 0.94 |
| folly/literal-never-match-frequent | 0 | 38968.96 ± 14.4% | not timed | not timed | 65418.03 ± 5.5% | 3042.40 ± 2.5% | not timed | not timed | 39357.63 ± 7.8% | | 0.99 | 0.60 | 12.81 |
| folly/literal-never-match-tricksy | 1 | 5214.11 ± 10.2% | not timed | not timed | 8611.95 ± 6.9% | 3947.00 ± 5.3% | not timed | not timed | 5272.60 ± 8.3% | | 0.99 | 0.61 | 1.32 |
| grep/every-line | 239963 | 1824.48 ± 5.7% | not timed | not timed | 1306.88 ± 5.9% | 505.02 ± 16.0% | not timed | not timed | 1848.09 ± 7.3% | | 0.99 | 1.40 | 3.61 |
| grep/long-words-ascii | 5073 | 641.43 ± 3.6% | not timed | not timed | 587.45 ± 2.9% | 63.93 ± 8.7% | not timed | not timed | 655.21 ± 3.1% | | 0.98 | 1.09 | 10.03 |
| imported/leipzig/twain | 811 | 72435.84 ± 0.9% | not timed | not timed | 59021.43 ± 4.3% | 14908.08 ± 12.3% | not timed | not timed | 72401.59 ± 2.0% | | 1.00 | 1.23 | 4.86 |
| imported/leipzig/twain-insensitive | 965 | 18952.03 ± 1.7% | not timed | not timed | 17143.63 ± 1.8% | 63.90 ± 2.2% | not timed | not timed | 19039.27 ± 2.5% | | 1.00 | 1.11 | 296.59 |
| imported/leipzig/shing | 1540 | 41497.73 ± 6.4% | not timed | not timed | 27759.33 ± 3.3% | 51.32 ± 3.6% | not timed | not timed | 41991.17 ± 3.6% | | 0.99 | 1.49 | 808.58 |
| imported/leipzig/huck-saw | 262 | 34097.10 ± 11.4% | not timed | not timed | 23664.97 ± 2.0% | 51.06 ± 4.6% | not timed | not timed | 33964.84 ± 2.7% | | 1.00 | 1.44 | 667.82 |
| imported/leipzig/word-ending-nn | 262 | 719.13 ± 4.6% | not timed | not timed | 711.61 ± 4.0% | 37.26 ± 15.3% | not timed | not timed | 719.92 ± 4.9% | | 1.00 | 1.01 | 19.30 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 15791.32 ± 4.2% | not timed | not timed | 5665.71 ± 6.5% | 15.75 ± 7.1% | not timed | not timed | 15923.67 ± 9.2% | | 0.99 | 2.79 | 1002.86 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 29851.23 ± 3.8% | not timed | not timed | 22546.46 ± 6.1% | 29.75 ± 1.7% | not timed | not timed | 28852.48 ± 3.1% | | 1.03 | 1.32 | 1003.57 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6680.06 ± 4.2% | not timed | not timed | 1190.12 ± 8.3% | 18.37 ± 2.4% | not timed | not timed | 6809.74 ± 0.8% | | 0.98 | 5.61 | 363.70 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 743.86 ± 4.5% | not timed | not timed | 714.25 ± 5.1% | 17.97 ± 5.0% | not timed | not timed | 744.27 ± 5.0% | | 1.00 | 1.04 | 41.40 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 745.67 ± 3.7% | not timed | not timed | 744.08 ± 2.3% | 15.09 ± 6.6% | not timed | not timed | 743.81 ± 2.3% | | 1.00 | 1.00 | 49.42 |
| imported/leipzig/tom-river | 2 | 17449.12 ± 6.0% | not timed | not timed | 18026.68 ± 24.7% | 54.61 ± 4.9% | not timed | not timed | 17318.71 ± 3.7% | | 1.01 | 0.97 | 319.49 |
| imported/leipzig/ing | 78424 | 694.89 ± 46.1% | not timed | not timed | 662.44 ± 5.6% | 43.13 ± 5.5% | not timed | not timed | 696.66 ± 47.1% | | 1.00 | 1.05 | 16.11 |
| imported/leipzig/ing-whitespace | 55248 | 875.78 ± 0.7% | not timed | not timed | 2724.14 ± 2.8% | 32.24 ± 3.9% | not timed | not timed | 880.23 ± 2.4% | | 0.99 | 0.32 | 27.17 |
| imported/leipzig/awyer-inn | 209 | 921.03 ± 3.5% | not timed | not timed | 17553.04 ± 4.0% | 34.64 ± 4.7% | not timed | not timed | 919.95 ± 2.9% | | 1.00 | 0.0525 | 26.59 |
| imported/leipzig/quotes-bounded | 8886 | 2493.71 ± 2.4% | not timed | not timed | 3899.82 ± 6.9% | 58.30 ± 10.9% | not timed | not timed | 2492.93 ± 6.4% | | 1.00 | 0.64 | 42.77 |
| imported/leipzig/non-ascii-alternate | 2 | 62417.33 ± 13.7% | not timed | not timed | 24546.98 ± 3.1% | 82.70 ± 13.5% | not timed | not timed | 63089.54 ± 54.9% | | 0.99 | 2.54 | 754.78 |
| imported/leipzig/math-symbols | 69 | 4343.86 ± 3.9% | not timed | not timed | 718.94 ± 4.2% | 54.96 ± 5.2% | not timed | not timed | 4320.54 ± 4.1% | | 1.01 | 6.04 | 79.03 |
| imported/leipzig/bounded-strings-ending-z | 0 | 710.18 ± 4.9% | not timed | not timed | 707.26 ± 1.5% | 34.63 ± 2.9% | not timed | not timed | 711.45 ± 5.9% | | 1.00 | 1.00 | 20.50 |
| imported/lh3lh3-reb/uri | 17549 | 1002.12 ± 3.5% | not timed | not timed | 1496.88 ± 2.8% | 39.55 ± 5.1% | not timed | not timed | 1002.84 ± 2.0% | | 1.00 | 0.67 | 25.34 |
| imported/lh3lh3-reb/email | 15057 | 1026.21 ± 5.6% | not timed | not timed | 1477.76 ± 10.7% | 43.74 ± 10.3% | not timed | not timed | 1007.43 ± 0.6% | | 1.02 | 0.69 | 23.46 |
| imported/lh3lh3-reb/date | 668 | 1178.40 ± 4.9% | not timed | not timed | 1308.54 ± 5.8% | 73.42 ± 8.7% | not timed | not timed | 1190.42 ± 4.9% | | 0.99 | 0.90 | 16.05 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 962.42 ± 3.3% | not timed | not timed | 543.52 ± 4.6% | 22.55 ± 13.3% | not timed | not timed | 943.65 ± 4.4% | | 1.02 | 1.77 | 42.69 |
| imported/mariomka/email | 92 | 52422.65 ± 4.4% | not timed | not timed | 72411.44 ± 5.4% | 49.72 ± 8.6% | not timed | not timed | 51631.90 ± 4.9% | | 1.02 | 0.72 | 1054.40 |
| imported/mariomka/uri | 5301 | 9041.17 ± 4.6% | not timed | not timed | 9604.70 ± 4.0% | 51.94 ± 5.0% | not timed | not timed | 8793.20 ± 4.4% | | 1.03 | 0.94 | 174.06 |
| imported/mariomka/ip | 5 | 2458.45 ± 3.4% | not timed | not timed | 2925.07 ± 3.6% | 32.93 ± 8.7% | not timed | not timed | 2456.90 ± 7.6% | | 1.00 | 0.84 | 74.65 |
| imported/rsc/no-exponential | 0 | 1181.96 ± 3.5% | not timed | not timed | 760.72 ± 6.7% | 32.21 ± 4.7% | not timed | not timed | 1174.93 ± 5.5% | | 1.01 | 1.55 | 36.70 |
| imported/rsc/literal | 1 | 1351.04 ± 31.0% | not timed | not timed | 3122.19 ± 4.3% | 319.61 ± 121.2% | not timed | not timed | 1261.57 ± 79.5% | | 1.07 | 0.43 | 4.23 |
| imported/rsc/not-literal | 2 | 1447.28 ± 7.0% | not timed | not timed | 1345.65 ± 37.3% | 73.95 ± 3.7% | not timed | not timed | 1426.94 ± 11.1% | | 1.01 | 1.08 | 19.57 |
| imported/rsc/match-class | 1 | 2513.79 ± 9.8% | not timed | not timed | 2864.23 ± 15.0% | 93.74 ± 91.7% | not timed | not timed | 2516.66 ± 54.4% | | 1.00 | 0.88 | 26.82 |
| imported/rsc/match-class-in-range | 1 | 2510.07 ± 1.7% | not timed | not timed | 4714.46 ± 2.4% | 97.07 ± 32.4% | not timed | not timed | 2524.50 ± 11.8% | | 0.99 | 0.53 | 25.86 |
| imported/rsc/match-class-unicode | 1 | 685.47 ± 3.8% | not timed | not timed | 655.50 ± 1.5% | 115.18 ± 6.3% | not timed | not timed | 681.84 ± 2.0% | | 1.01 | 1.05 | 5.95 |
| imported/rsc/anchored-literal-short-non-match | 0 | 2506.68 ± 4.6% | not timed | not timed | 1741.84 ± 4.3% | 443.37 ± 4.8% | not timed | not timed | 2509.39 ± 2.8% | | 1.00 | 1.44 | 5.65 |
| imported/rsc/anchored-literal-long-non-match | 0 | 37599.86 ± 3.3% | not timed | not timed | 25515.26 ± 8.1% | 6593.46 ± 18.5% | not timed | not timed | 37982.76 ± 13.6% | | 0.99 | 1.47 | 5.70 |
| imported/rsc/anchored-literal-short-match | 4 | 1262.70 ± 24.5% | not timed | not timed | 952.54 ± 4.1% | 140.51 ± 14.8% | not timed | not timed | 1287.14 ± 5.5% | | 0.98 | 1.33 | 8.99 |
| imported/rsc/anchored-literal-long-match | 4 | 19113.18 ± 7.1% | not timed | not timed | 14514.94 ± 1.9% | 2114.70 ± 6.4% | not timed | not timed | 19323.46 ± 11.0% | | 0.99 | 1.32 | 9.04 |
| imported/rsc/one-pass-short | 17 | 666.33 ± 1.9% | not timed | not timed | 430.65 ± 1.6% | 46.54 ± 8.5% | not timed | not timed | 669.16 ± 1.4% | | 1.00 | 1.55 | 14.32 |
| imported/rsc/one-pass-short-not | 17 | 446.39 ± 6.7% | not timed | not timed | 477.65 ± 74.0% | 44.35 ± 13.0% | not timed | not timed | 467.04 ± 2.5% | | 0.96 | 0.93 | 10.07 |
| imported/rsc/one-pass-long-prefix | 26 | 586.00 ± 12.0% | not timed | not timed | 506.43 ± 2.1% | 166.37 ± 7.4% | not timed | not timed | 589.18 ± 12.3% | | 0.99 | 1.16 | 3.52 |
| imported/rsc/one-pass-long-prefix-not | 26 | 545.21 ± 10.6% | not timed | not timed | 488.31 ± 5.0% | 113.69 ± 5.4% | not timed | not timed | 591.27 ± 14.3% | | 0.92 | 1.12 | 4.80 |
| imported/rsc/long-needle1 | 31 | 89617.90 ± 3.9% | not timed | not timed | 66826.86 ± 4.3% | 5.96 ± 11.9% | not timed | not timed | 89878.12 ± 4.3% | | 1.00 | 1.34 | 15040.15 |
| imported/rsc/long-needle2 | 31 | 87978.76 ± 4.1% | not timed | not timed | 360.18 ± 3.0% | 5.83 ± 4.4% | not timed | not timed | 87690.54 ± 2.3% | | 1.00 | 244.26 | 15090.45 |
| imported/rsc/easy0-32 | 26 | 1969.28 ± 21.2% | not timed | not timed | 2932.19 ± 3.7% | 224.68 ± 5.9% | not timed | not timed | 2025.09 ± 3.4% | | 0.97 | 0.67 | 8.76 |
| imported/rsc/easy0-1k | 26 | 31553.37 ± 5.9% | not timed | not timed | 31582.69 ± 2.3% | 3383.87 ± 7.9% | not timed | not timed | 31723.81 ± 0.7% | | 0.99 | 1.00 | 9.32 |
| imported/rsc/easy0-32k | 26 | 84659.40 ± 3.6% | not timed | not timed | 64132.61 ± 3.6% | 37115.19 ± 21.4% | not timed | not timed | 86553.73 ± 5.0% | | 0.98 | 1.32 | 2.28 |
| imported/rsc/easy0-1mb | 26 | 82988.30 ± 0.5% | not timed | not timed | 65887.50 ± 2.7% | 98244.15 ± 2.9% | not timed | not timed | 83148.86 ± 1.2% | | 1.00 | 1.26 | 0.84 |
| imported/rsc/easy1-32 | 19 | 1235.00 ± 4.6% | not timed | not timed | 1235.20 ± 6.4% | 205.97 ± 9.1% | not timed | not timed | 1182.24 ± 6.8% | | 1.04 | 1.00 | 6.00 |
| imported/rsc/easy1-1k | 19 | 26523.31 ± 5.6% | not timed | not timed | 26166.85 ± 6.6% | 3581.68 ± 11.0% | not timed | not timed | 25747.56 ± 4.4% | | 1.03 | 1.01 | 7.41 |
| imported/rsc/easy1-32k | 19 | 846859.44 ± 2.5% | not timed | not timed | 874909.89 ± 4.5% | 42555.15 ± 15.5% | not timed | not timed | 817603.16 ± 1.6% | | 1.04 | 0.97 | 19.90 |
| imported/rsc/easy1-1mb | 19 | 26884324.03 ± 5.3% | not timed | not timed | 27598205.18 ± 5.3% | 101001.41 ± 4.9% | not timed | not timed | 26077069.72 ± 6.0% | | 1.03 | 0.97 | 266.18 |
| imported/rsc/medium-32 | 27 | 1133.87 ± 11.1% | not timed | not timed | 1009.77 ± 24.1% | 112.34 ± 22.4% | not timed | not timed | 1185.33 ± 60.7% | | 0.96 | 1.12 | 10.09 |
| imported/rsc/medium-1k | 27 | 20584.77 ± 11.3% | not timed | not timed | 19788.25 ± 4.9% | 119.22 ± 4.2% | not timed | not timed | 21296.21 ± 2.5% | | 0.97 | 1.04 | 172.66 |
| imported/rsc/medium-32k | 27 | 662477.72 ± 26.1% | not timed | not timed | 661338.27 ± 5.9% | 79.79 ± 3.5% | not timed | not timed | 663999.16 ± 4.7% | | 1.00 | 1.00 | 8303.23 |
| imported/rsc/medium-1mb | 27 | 21188699.51 ± 2.3% | not timed | not timed | 21131879.34 ± 4.0% | 81.56 ± 2.4% | not timed | not timed | 21635821.82 ± 3.8% | | 0.98 | 1.00 | 259795.24 |
| imported/rsc/hard-32 | 58 | 549.98 ± 3.7% | not timed | not timed | 513.91 ± 5.2% | 73.31 ± 7.1% | not timed | not timed | 557.05 ± 2.4% | | 0.99 | 1.07 | 7.50 |
| imported/rsc/hard-1k | 27 | 19916.83 ± 5.2% | not timed | not timed | 21011.13 ± 5.8% | 62.13 ± 5.2% | not timed | not timed | 19548.07 ± 7.8% | | 1.02 | 0.95 | 320.56 |
| imported/rsc/hard-32k | 27 | 621721.43 ± 3.7% | not timed | not timed | 659374.59 ± 3.5% | 49.04 ± 5.4% | not timed | not timed | 623211.71 ± 3.7% | | 1.00 | 0.94 | 12678.06 |
| imported/rsc/hard-1mb | 51 | 11373332.81 ± 1.8% | not timed | not timed | 11156428.16 ± 13.4% | 50.26 ± 4.1% | not timed | not timed | 11449748.52 ± 1.8% | | 0.99 | 1.02 | 226309.22 |
| imported/rsc/reallyhard0-32 | 58 | 363.70 ± 6.6% | not timed | not timed | 350.01 ± 6.0% | 75.86 ± 11.3% | not timed | not timed | 383.00 ± 4.0% | | 0.95 | 1.04 | 4.79 |
| imported/rsc/reallyhard0-1k | 27 | 730.53 ± 0.5% | not timed | not timed | 729.36 ± 1.7% | 63.83 ± 2.9% | not timed | not timed | 733.05 ± 0.1% | | 1.00 | 1.00 | 11.44 |
| imported/rsc/reallyhard0-32k | 27 | 701.45 ± 6.5% | not timed | not timed | 706.48 ± 6.3% | 47.96 ± 17.1% | not timed | not timed | 704.50 ± 6.2% | | 1.00 | 0.99 | 14.62 |
| imported/rsc/reallyhard0-1mb | 51 | 707.91 ± 10.5% | not timed | not timed | 709.71 ± 0.2% | 48.14 ± 1.2% | not timed | not timed | 708.92 ± 38.6% | | 1.00 | 1.00 | 14.71 |
| imported/rsc/reallyreallyhard0-32 | 47 | 433.31 ± 5.7% | not timed | not timed | 265.83 ± 2.5% | 90.60 ± 12.0% | not timed | not timed | 433.67 ± 11.7% | | 1.00 | 1.63 | 4.78 |
| imported/rsc/reallyreallyhard0-1k | 16 | 11765.26 ± 7.4% | not timed | not timed | 10408.60 ± 13.6% | 50.51 ± 3.6% | not timed | not timed | 11534.64 ± 5.0% | | 1.02 | 1.13 | 232.92 |
| imported/rsc/reallyreallyhard0-32k | 16 | 78172.96 ± 7.8% | not timed | not timed | 60116.47 ± 7.2% | 40.90 ± 6.1% | not timed | not timed | 75499.88 ± 9.2% | | 1.04 | 1.30 | 1911.43 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 96755.24 ± 5.1% | not timed | not timed | 67448.95 ± 1.8% | 40.55 ± 3.3% | not timed | not timed | 97793.40 ± 3.8% | | 0.99 | 1.43 | 2385.91 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 429.65 ± 20.5% | not timed | not timed | 288.97 ± 14.8% | 93.93 ± 95.2% | not timed | not timed | 423.81 ± 63.7% | | 1.01 | 1.49 | 4.57 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 9500.76 ± 4.4% | not timed | not timed | 10748.74 ± 5.3% | 50.30 ± 5.2% | not timed | not timed | 9406.22 ± 4.9% | | 1.01 | 0.88 | 188.87 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 70977.75 ± 7.9% | not timed | not timed | 57117.00 ± 2.6% | 39.86 ± 4.5% | not timed | not timed | 70837.20 ± 5.3% | | 1.00 | 1.24 | 1780.60 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 81632.18 ± 15.3% | not timed | not timed | 65270.58 ± 13.4% | 39.80 ± 5.9% | not timed | not timed | 82898.72 ± 0.5% | | 0.98 | 1.25 | 2051.26 |
| imported/sherlock/name-sherlock | 776 | 63859.03 ± 5.4% | not timed | not timed | 51321.26 ± 3.6% | 16545.58 ± 14.4% | not timed | not timed | 63948.67 ± 4.8% | | 1.00 | 1.24 | 3.86 |
| imported/sherlock/name-holmes | 2766 | 35632.35 ± 5.9% | not timed | not timed | 36113.42 ± 3.4% | 5325.68 ± 15.6% | not timed | not timed | 36705.68 ± 4.8% | | 0.97 | 0.99 | 6.69 |
| imported/sherlock/name-sherlock-holmes | 1365 | 65170.06 ± 3.8% | not timed | not timed | 52416.40 ± 3.7% | 13425.19 ± 6.2% | not timed | not timed | 65594.52 ± 7.0% | | 0.99 | 1.24 | 4.85 |
| imported/sherlock/name-sherlock-casei | 816 | 66537.09 ± 3.6% | not timed | not timed | 15200.58 ± 2.9% | 52.96 ± 5.1% | not timed | not timed | 66512.02 ± 2.9% | | 1.00 | 4.38 | 1256.32 |
| imported/sherlock/name-holmes-casei | 2802 | 32226.23 ± 3.0% | not timed | not timed | 9288.75 ± 4.5% | 67.11 ± 4.8% | not timed | not timed | 32537.57 ± 5.2% | | 0.99 | 3.47 | 480.21 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 51873.71 ± 6.8% | not timed | not timed | 14109.13 ± 3.5% | 52.68 ± 5.8% | not timed | not timed | 53113.02 ± 7.0% | | 0.98 | 3.68 | 984.77 |
| imported/sherlock/name-whitespace | 1461 | 38767.91 ± 2.3% | not timed | not timed | 37639.49 ± 4.7% | 12116.16 ± 21.8% | not timed | not timed | 39140.42 ± 2.2% | | 0.99 | 1.03 | 3.20 |
| imported/sherlock/name-alt1 | 1142 | 43540.45 ± 5.3% | not timed | not timed | 43341.37 ± 5.5% | 6652.69 ± 37.9% | not timed | not timed | 43534.33 ± 7.3% | | 1.00 | 1.00 | 6.54 |
| imported/sherlock/name-alt2 | 3542 | 27727.35 ± 3.6% | not timed | not timed | 12066.03 ± 5.4% | 53.47 ± 2.7% | not timed | not timed | 28350.20 ± 5.2% | | 0.98 | 2.30 | 518.59 |
| imported/sherlock/name-alt3 | 4507 | 17468.92 ± 5.5% | not timed | not timed | 11667.14 ± 5.3% | 17.20 ± 5.0% | not timed | not timed | 17458.58 ± 5.7% | | 1.00 | 1.50 | 1015.72 |
| imported/sherlock/name-alt3-casei | 4593 | 2585.37 ± 8.5% | not timed | not timed | 1724.84 ± 25.0% | 10.96 ± 35.7% | not timed | not timed | 2603.86 ± 10.2% | | 0.99 | 1.50 | 235.86 |
| imported/sherlock/name-alt4 | 3686 | 13158.66 ± 4.9% | not timed | not timed | 9728.85 ± 4.3% | 54.07 ± 3.5% | not timed | not timed | 13039.81 ± 8.0% | | 1.01 | 1.35 | 243.36 |
| imported/sherlock/name-alt4-casei | 4254 | 7242.43 ± 2.8% | not timed | not timed | 5171.52 ± 2.3% | 32.79 ± 3.5% | not timed | not timed | 7260.17 ± 12.7% | | 1.00 | 1.40 | 220.86 |
| imported/sherlock/name-alt5 | 4028 | 22200.90 ± 4.0% | not timed | not timed | 11668.73 ± 2.9% | 37.75 ± 10.1% | not timed | not timed | 22221.28 ± 20.3% | | 1.00 | 1.90 | 588.07 |
| imported/sherlock/name-alt5-casei | 4104 | 9761.85 ± 2.6% | not timed | not timed | 3768.82 ± 41.7% | 23.76 ± 5.8% | not timed | not timed | 9689.40 ± 4.3% | | 1.01 | 2.59 | 410.85 |
| imported/sherlock/no-match-uncommon | 0 | 88113.06 ± 2.5% | not timed | not timed | 87402.33 ± 4.6% | 76886.80 ± 5.3% | not timed | not timed | 88709.27 ± 5.1% | | 0.99 | 1.01 | 1.15 |
| imported/sherlock/no-match-common | 0 | 87782.99 ± 4.6% | not timed | not timed | 88061.30 ± 19.7% | 2403.85 ± 2.4% | not timed | not timed | 88153.67 ± 4.1% | | 1.00 | 1.00 | 36.52 |
| imported/sherlock/no-match-really-common | 0 | 61248.29 ± 14.2% | not timed | not timed | 67219.83 ± 7.9% | 2467.01 ± 4.7% | not timed | not timed | 60010.97 ± 9.6% | | 1.02 | 0.91 | 24.83 |
| imported/sherlock/the-lower | 21654 | 4077.05 ± 7.8% | not timed | not timed | 4082.76 ± 4.5% | 394.52 ± 11.6% | not timed | not timed | 4023.54 ± 6.1% | | 1.01 | 1.00 | 10.33 |
| imported/sherlock/the-upper | 2223 | 26671.59 ± 5.3% | not timed | not timed | 34744.49 ± 2.7% | 4222.21 ± 23.4% | not timed | not timed | 26632.18 ± 4.1% | | 1.00 | 0.77 | 6.32 |
| imported/sherlock/the-casei | 23961 | 3762.60 ± 4.4% | not timed | not timed | 1766.61 ± 3.7% | 60.57 ± 24.3% | not timed | not timed | 3654.30 ± 6.9% | | 1.03 | 2.13 | 62.12 |
| imported/sherlock/everything-greedy | 581881 | 366.10 ± 6.4% | not timed | not timed | 216.96 ± 9.6% | 42.84 ± 45.2% | not timed | not timed | 369.08 ± 6.5% | | 0.99 | 1.69 | 8.55 |
| imported/sherlock/everything-greedy-nl | 594933 | 586.65 ± 4.9% | not timed | not timed | 295.51 ± 33.2% | 56.08 ± 17.0% | not timed | not timed | 567.61 ± 6.6% | | 1.03 | 1.99 | 10.46 |
| imported/sherlock/letters | 447175 | 101.83 ± 3.3% | not timed | not timed | 46.16 ± 3.7% | 9.45 ± 29.7% | not timed | not timed | 101.59 ± 3.5% | | 1.00 | 2.21 | 10.78 |
| imported/sherlock/letters-upper | 14180 | 569.13 ± 3.1% | not timed | not timed | 459.25 ± 1.5% | 42.80 ± 10.1% | not timed | not timed | 570.92 ± 1.6% | | 1.00 | 1.24 | 13.30 |
| imported/sherlock/letters-lower | 432995 | 102.17 ± 4.6% | not timed | not timed | 44.73 ± 4.9% | 10.84 ± 37.8% | not timed | not timed | 101.44 ± 5.3% | | 1.01 | 2.28 | 9.42 |
| imported/sherlock/words | 447639 | 163.61 ± 5.7% | not timed | not timed | 110.99 ± 1.0% | 21.97 ± 15.3% | not timed | not timed | 164.22 ± 9.2% | | 1.00 | 1.47 | 7.45 |
| imported/sherlock/before-holmes | 4073 | 20124.29 ± 3.9% | not timed | not timed | 16732.58 ± 2.4% | 39.03 ± 1.0% | not timed | not timed | 20037.86 ± 1.6% | | 1.00 | 1.20 | 515.66 |
| imported/sherlock/before-after-holmes | 2593 | 20085.49 ± 6.4% | not timed | not timed | 19952.68 ± 1.3% | 39.03 ± 1.9% | not timed | not timed | 20150.68 ± 3.6% | | 1.00 | 1.01 | 514.61 |
| imported/sherlock/holmes-cochar-watson | 150 | 12588.43 ± 2.3% | not timed | not timed | 10136.33 ± 1.7% | 55.73 ± 1.0% | not timed | not timed | 12654.48 ± 1.4% | | 0.99 | 1.24 | 225.87 |
| imported/sherlock/holmes-coword-watson | 14309 | 1577.96 ± 3.2% | not timed | not timed | 1534.63 ± 3.2% | 11.62 ± 4.9% | not timed | not timed | 1579.40 ± 3.5% | | 1.00 | 1.03 | 135.75 |
| imported/sherlock/quotes | 14437 | 1749.19 ± 5.4% | not timed | not timed | 3025.55 ± 0.5% | 55.25 ± 4.2% | not timed | not timed | 1746.74 ± 4.5% | | 1.00 | 0.58 | 31.66 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 726.26 ± 6.2% | not timed | not timed | 40640.99 ± 5.4% | 60.87 ± 14.5% | not timed | not timed | 744.12 ± 5.1% | | 0.98 | 0.0179 | 11.93 |
| imported/sherlock/word-ending-n | 35297 | 564.66 ± 4.7% | not timed | not timed | 486.88 ± 5.4% | 37.24 ± 42.0% | not timed | not timed | 558.86 ± 4.9% | | 1.01 | 1.16 | 15.16 |
| imported/sherlock/repeated-class-negation | 2130 | 24319.06 ± 44.2% | not timed | not timed | 22539.36 ± 30.4% | 15.39 ± 82.1% | not timed | not timed | 24212.62 ± 27.3% | | 1.00 | 1.08 | 1580.58 |
| imported/sherlock/ing-suffix | 20547 | 713.59 ± 5.1% | not timed | not timed | 620.84 ± 3.8% | 45.26 ± 4.2% | not timed | not timed | 699.79 ± 5.3% | | 1.02 | 1.15 | 15.76 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 738.70 ± 1.7% | not timed | not timed | 3707.85 ± 3.2% | 32.62 ± 31.7% | not timed | not timed | 735.56 ± 4.0% | | 1.00 | 0.20 | 22.65 |
| opt/accelerate/whole-line | 239963 | 660.62 ± 14.3% | not timed | not timed | 503.66 ± 9.9% | 129.37 ± 22.8% | not timed | not timed | 665.75 ± 4.0% | | 0.99 | 1.31 | 5.11 |
| opt/accelerate/non-dna | 16745 | 606.45 ± 5.2% | not timed | not timed | 571.28 ± 2.6% | 47.37 ± 17.1% | not timed | not timed | 597.75 ± 3.8% | | 1.01 | 1.06 | 12.80 |
| opt/backtrack/words-english | 40536 | 185.00 ± 5.9% | not timed | not timed | 139.39 ± 2.3% | 29.36 ± 10.0% | not timed | not timed | 183.36 ± 7.9% | | 1.01 | 1.33 | 6.30 |
| opt/fixed-length/too-small-ascii | 0 | 589.79 ± 2.6% | not timed | not timed | 1153.60 ± 3.4% | 169.19 ± 3.9% | not timed | not timed | 594.32 ± 1.7% | | 0.99 | 0.51 | 3.49 |
| opt/fixed-length/too-big-ascii | 0 | 6398.93 ± 8.5% | not timed | not timed | 8938.41 ± 3.9% | 217.37 ± 4.9% | not timed | not timed | 6540.08 ± 5.8% | | 0.98 | 0.72 | 29.44 |
| opt/fixed-length/go33484-1 | 0 | 1250234.64 ± 5.2% | not timed | not timed | 1714454.55 ± 3.8% | 123518.21 ± 4.1% | not timed | not timed | 1248672.75 ± 3.0% | | 1.00 | 0.73 | 10.12 |
| opt/fixed-length/go33484-2 | 0 | 1234648.93 ± 3.1% | not timed | not timed | 1704663.32 ± 2.5% | 45039.08 ± 6.7% | not timed | not timed | 1242209.26 ± 7.6% | | 0.99 | 0.72 | 27.41 |
| opt/fixed-length/go33484-3 | 0 | 3036.61 ± 3.1% | not timed | not timed | 163167.38 ± 21.5% | 1299.02 ± 49.7% | not timed | not timed | 3048.88 ± 44.6% | | 1.00 | 0.0186 | 2.34 |
| opt/literal-alt/one-pattern | 1 | 695.56 ± 1.4% | not timed | not timed | 703.21 ± 1.4% | 0.62 ± 0.9% | not timed | not timed | 704.43 ± 1.3% | | 0.99 | 0.99 | 1122.32 |
| opt/onepass/fn-predicate | 916 | 596.48 ± 0.9% | not timed | not timed | 519.31 ± 9.6% | 285.91 ± 17.7% | not timed | not timed | 581.86 ± 1.7% | | 1.03 | 1.15 | 2.09 |
| opt/onepass/first-three-words-english | 35128 | 243.11 ± 6.1% | not timed | not timed | 304.89 ± 6.0% | 115.66 ± 10.6% | not timed | not timed | 233.57 ± 18.2% | | 1.04 | 0.80 | 2.10 |
| opt/prefilter/literal-english | 1 | 88218.01 ± 2.0% | not timed | not timed | 67059.36 ± 2.8% | 34770.08 ± 1.4% | not timed | not timed | 88351.87 ± 1.9% | | 1.00 | 1.32 | 2.54 |
| opt/prefilter/literal-casei-english | 1 | 68053.48 ± 7.5% | not timed | not timed | 18185.61 ± 5.8% | 52.35 ± 6.1% | not timed | not timed | 68159.82 ± 4.8% | | 1.00 | 3.74 | 1299.90 |
| opt/prefilter/literal-russian | 1 | 89657.17 ± 0.9% | not timed | not timed | 67530.27 ± 2.3% | 4133.76 ± 2.2% | not timed | not timed | 89790.48 ± 2.4% | | 1.00 | 1.33 | 21.69 |
| opt/prefilter/literal-casei-russian | 1 | 37167.75 ± 4.0% | not timed | not timed | 13308.63 ± 2.9% | 57.04 ± 5.0% | not timed | not timed | 37679.66 ± 4.2% | | 0.99 | 2.79 | 651.64 |
| opt/prefilter/rust-functions | 948 | 20064.04 ± 11.1% | not timed | not timed | 16884.77 ± 4.2% | 2405.50 ± 18.5% | not timed | not timed | 20555.64 ± 5.1% | | 0.98 | 1.19 | 8.34 |
| opt/reverse-anchored/word-end | 1 | 53452271.26 ± 5.7% | not timed | not timed | 37888239.10 ± 12.0% | 83.20 ± 5.1% | not timed | not timed | 55065637.28 ± 5.8% | | 0.97 | 1.41 | 642431.99 |
| opt/reverse-inner/holmes | 2593 | 20219.45 ± 4.4% | not timed | not timed | 20070.13 ± 3.7% | 38.43 ± 1.8% | not timed | not timed | 20180.95 ± 2.3% | | 1.00 | 1.01 | 526.09 |
| opt/reverse-inner/email | 47 | 98546.96 ± 7.2% | not timed | not timed | 102531.80 ± 10.7% | 48.67 ± 9.9% | not timed | not timed | 99732.37 ± 2.4% | | 0.99 | 0.96 | 2024.95 |
| opt/reverse-inner/factored-prefix | 3542 | 705.13 ± 5.1% | not timed | not timed | 700.64 ± 4.4% | 20.43 ± 6.0% | not timed | not timed | 704.78 ± 5.3% | | 1.00 | 1.01 | 34.52 |
| opt/reverse-inner/no-quadratic-backward | 0 | 6757.46 ± 6.3% | not timed | not timed | 723.32 ± 4.1% | 121.29 ± 4.4% | not timed | not timed | 6848.26 ± 4.8% | | 0.99 | 9.34 | 55.71 |
| opt/reverse-inner/no-quadratic-forward | 0 | 852.30 ± 9.5% | not timed | not timed | 331.12 ± 3.8% | 40.10 ± 6.1% | not timed | not timed | 856.15 ± 3.2% | | 1.00 | 2.57 | 21.25 |
| opt/reverse-suffix/holmes | 4073 | 19891.36 ± 5.2% | not timed | not timed | 16947.46 ± 5.3% | 37.68 ± 3.2% | not timed | not timed | 20088.14 ± 5.0% | | 0.99 | 1.17 | 527.88 |
| opt/reverse-suffix/no-quadratic | 0 | 7040.47 ± 4.4% | not timed | not timed | 742.56 ± 6.1% | 124.29 ± 5.5% | not timed | not timed | 6959.03 ± 5.2% | | 1.01 | 9.48 | 56.64 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 213.19 ± 3.1% | not timed | not timed | 244.17 ± 1.7% | 22.19 ± 15.8% | not timed | not timed | 213.93 ± 2.5% | | 1.00 | 0.87 | 9.61 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 215.46 ± 11.3% | not timed | not timed | 274.00 ± 5.3% | 22.80 ± 13.6% | not timed | not timed | 225.23 ± 4.7% | | 0.96 | 0.79 | 9.45 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.49 ± 0.9% | not timed | not timed | 0.84 ± 5.1% | 174.73 ± 7.9% | not timed | not timed | 0.48 ± 4.5% | | 1.01 | 0.58 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 388.12 ± 2.6% | not timed | not timed | 381.42 ± 2.9% | 160.67 ± 8.0% | not timed | not timed | 394.39 ± 4.5% | | 0.98 | 1.02 | 2.42 |
| reported/i13-subset-regex/original-ascii | 4094 | 15613.05 ± 2.5% | not timed | not timed | 5680.75 ± 2.4% | 15.77 ± 5.3% | not timed | not timed | 15383.33 ± 19.1% | | 1.01 | 2.75 | 989.84 |
| reported/i13-subset-regex/original-unicode | 4094 | 15675.98 ± 4.4% | not timed | not timed | 275.02 ± 9.9% | 15.36 ± 4.6% | not timed | not timed | 15919.70 ± 7.0% | | 0.98 | 57.00 | 1020.45 |
| reported/i13-subset-regex/big-ascii | 1955 | 14447.85 ± 6.1% | not timed | not timed | 80.44 ± 21.4% | 13.72 ± 1.9% | not timed | not timed | 14295.05 ± 4.4% | | 1.01 | 179.60 | 1053.11 |
| reported/i13-subset-regex/big-unicode | 1955 | 14411.39 ± 6.1% | not timed | not timed | 14.32 ± 56.2% | 13.48 ± 5.7% | not timed | not timed | 14283.28 ± 9.6% | | 1.01 | 1006.63 | 1069.34 |
| reported/i13-subset-regex/huge-ascii | 55 | 12960.68 ± 4.9% | not timed | not timed | 13.76 ± 5.4% | 12.46 ± 6.5% | not timed | not timed | 12932.07 ± 7.2% | | 1.00 | 941.82 | 1040.49 |
| reported/i13-subset-regex/huge-unicode | 55 | 12816.03 ± 5.8% | not timed | not timed | 13.47 ± 4.9% | 12.32 ± 10.4% | not timed | not timed | 12967.38 ± 5.7% | | 0.99 | 951.54 | 1039.99 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.60 ± 3.8% | not timed | not timed | 13.37 ± 5.5% | 12.67 ± 4.0% | not timed | not timed | 5.78 ± 4.5% | | 0.97 | 0.42 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.11 ± 2.9% | not timed | not timed | 13.04 ± 6.4% | 12.40 ± 9.1% | not timed | not timed | 7.55 ± 4.2% | | 0.94 | 0.55 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 666.20 ± 0.7% | not timed | not timed | 207.22 ± 3.8% | 9.91 ± 9.5% | not timed | not timed | 664.23 ± 2.0% | | 1.00 | 3.21 | 67.25 |
| reported/i787-keywords/opt-ascii | 5674 | 667.09 ± 1.8% | not timed | not timed | 336.91 ± 2.4% | 16.49 ± 30.1% | not timed | not timed | 670.28 ± 1.7% | | 1.00 | 1.98 | 40.45 |
| slow/quadratic-regex-1x | 100 | 10.41 ± 1.5% | not timed | not timed | 8.23 ± 1.4% | 0.08 ± 1.3% | not timed | not timed | 10.41 ± 1.3% | | 1.00 | 1.26 | 136.64 |
| slow/quadratic-regex-2x | 199 | 4.43 ± 0.8% | not timed | not timed | 3.87 ± 0.7% | 0.02 ± 2.4% | not timed | not timed | 4.43 ± 1.9% | | 1.00 | 1.14 | 225.05 |
| slow/quadratic-haystack-1x | 100 | 38.62 ± 14.8% | not timed | not timed | 16.66 ± 59.6% | 1.45 ± 47.8% | not timed | not timed | 39.27 ± 9.2% | | 0.98 | 2.32 | 26.71 |
| slow/quadratic-haystack-2x | 200 | 31.04 ± 8.5% | not timed | not timed | 7.78 ± 1.4% | 0.75 ± 38.5% | not timed | not timed | 31.18 ± 14.6% | | 1.00 | 3.99 | 41.54 |
| unicode/codepoints/any-one | 1112064 | 501.37 ± 1.3% | not timed | not timed | 341.35 ± 2.9% | 25.87 ± 25.6% | not timed | not timed | 493.46 ± 21.4% | | 1.02 | 1.47 | 19.38 |
| unicode/codepoints/any-all | 4382592 | 332.74 ± 2.7% | not timed | not timed | 330.29 ± 3.3% | 170.06 ± 12.4% | not timed | not timed | 333.83 ± 3.0% | | 1.00 | 1.01 | 1.96 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.85 ± 1.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 708.70 ± 5.7% | not timed | not timed | 723.16 ± 5.0% | 224.08 ± 5.2% | not timed | not timed | 719.48 ± 5.5% | | 0.99 | 0.98 | 3.16 |
| unicode/overlapping-words/ascii | 6156 | 44.54 ± 9.4% | not timed | not timed | 55.67 ± 8.5% | 6.20 ± 4.9% | not timed | not timed | 44.98 ± 3.4% | | 0.99 | 0.80 | 7.18 |
| unicode/overlapping-words/english | 6156 | 2.13 ± 1.8% | not timed | not timed | 5.19 ± 3.9% | 3.79 ± 6.6% | not timed | not timed | 2.16 ± 3.8% | | 0.99 | 0.41 | 0.56 |
| unicode/overlapping-words/russian | 5710 | 1.90 ± 4.3% | not timed | not timed | 4.97 ± 2.7% | 9.39 ± 5.9% | not timed | not timed | 1.94 ± 5.6% | | 0.98 | 0.38 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 179.22 ± 8.1% | not timed | not timed | 107.19 ± 4.6% | 19.99 ± 12.8% | not timed | not timed | 182.31 ± 3.9% | | 0.98 | 1.67 | 8.97 |
| unicode/word/boundary-long-english | 3466 | 742.78 ± 4.6% | not timed | not timed | 731.19 ± 4.0% | 50.39 ± 3.3% | not timed | not timed | 744.43 ± 4.3% | | 1.00 | 1.02 | 14.74 |
| unicode/word/around-holmes-english | 27 | 85155.78 ± 0.8% | not timed | not timed | 68037.07 ± 3.3% | 36.08 ± 1.8% | not timed | not timed | 85687.16 ± 4.2% | | 0.99 | 1.25 | 2359.87 |
| wild/bibleref/long | 874 | 704.43 ± 1.6% | not timed | not timed | 714.87 ± 5.3% | 11.42 ± 6.6% | not timed | not timed | 703.85 ± 7.5% | | 1.00 | 0.99 | 61.66 |
| wild/bibleref/short | 30 | 34.04 ± 1.7% | not timed | not timed | 47.36 ± 1.6% | 22.96 ± 12.0% | not timed | not timed | 34.77 ± 4.3% | | 0.98 | 0.72 | 1.48 |
| wild/bibleref/line | 874 | 714.16 ± 6.7% | not timed | not timed | 348.54 ± 6.1% | 13.84 ± 18.0% | not timed | not timed | 688.37 ± 8.1% | | 1.04 | 2.05 | 51.58 |
| wild/caddy/caddy | 6 | 636.23 ± 6.9% | not timed | not timed | 341.75 ± 5.9% | 109.23 ± 2.8% | not timed | not timed | 643.46 ± 15.5% | | 0.99 | 1.86 | 5.82 |
| wild/dot-star-capture/rust-src-tools | 6 | 2182.30 ± 49.2% | not timed | not timed | 494.45 ± 3.0% | 23.97 ± 4.0% | not timed | not timed | 2180.97 ± 4.3% | | 1.00 | 4.41 | 91.05 |
| wild/ruff/noqa | 84 | 678.63 ± 3.8% | not timed | not timed | 683.14 ± 4.3% | 32.08 ± 11.0% | not timed | not timed | 676.65 ± 2.9% | | 1.00 | 0.99 | 21.15 |
| wild/ruff/unnecessary-coding-comment | 16 | 1367.36 ± 6.8% | not timed | not timed | 896.14 ± 2.8% | 196.53 ± 18.4% | not timed | not timed | 1370.84 ± 5.4% | | 1.00 | 1.53 | 6.96 |
| wild/ruff/string-quote-prefix | 2972 | 2084.58 ± 7.5% | not timed | not timed | 686.88 ± 5.6% | 445.20 ± 35.6% | not timed | not timed | 2038.75 ± 6.5% | | 1.02 | 3.03 | 4.68 |
| wild/ruff/space-around-operator | 1224378 | 300.83 ± 7.8% | not timed | not timed | 274.49 ± 6.7% | 26.28 ± 14.7% | not timed | not timed | 306.06 ± 5.3% | | 0.98 | 1.10 | 11.45 |
| wild/ruff/shebang | 282 | 1322.03 ± 9.8% | not timed | not timed | 500.08 ± 16.3% | 156.75 ± 13.7% | not timed | not timed | 1366.44 ± 1.1% | | 0.97 | 2.64 | 8.43 |
| wild/rustsec-cargo-audit/original-unix | 471 | 30672.43 ± 12.6% | not timed | not timed | 33568.72 ± 12.5% | 12515.70 ± 4.5% | not timed | not timed | 30592.97 ± 1.4% | | 1.00 | 0.91 | 2.45 |
| wild/rustsec-cargo-audit/original-windows | 462 | 26746.37 ± 14.2% | not timed | not timed | 31589.23 ± 2.9% | 11530.54 ± 3.5% | not timed | not timed | 27401.92 ± 5.2% | | 0.98 | 0.85 | 2.32 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 31134.04 ± 4.8% | not timed | not timed | 32195.46 ± 6.6% | 11348.47 ± 41.3% | not timed | not timed | 31136.65 ± 6.6% | | 1.00 | 0.97 | 2.74 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 26261.16 ± 6.5% | not timed | not timed | 33327.37 ± 5.7% | 12153.74 ± 26.3% | not timed | not timed | 26706.79 ± 1.8% | | 0.98 | 0.79 | 2.16 |
| wild/url/search | 234965 | 176.75 ± 12.0% | not timed | not timed | 86.83 ± 4.6% | 3.60 ± 5.4% | not timed | not timed | 181.73 ± 12.3% | | 0.97 | 2.04 | 49.10 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 14.2% | not timed | not timed | 0.01 ± 3.6% | 0.01 ± 40.2% | not timed | not timed | 0.04 ± 3.5% | | 1.00 | 2.99 | 4.36 |
| dictionary/compile/english-15 | 1 | 0.43 ± 11.3% | not timed | not timed | 0.10 ± 6.4% | 0.12 ± 32.4% | not timed | not timed | 0.43 ± 8.6% | | 1.01 | 4.39 | 3.62 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.40 ± 41.4% | not timed | not timed | 0.03 ± 147.6% | 45.45 ± 11.7% | not timed | not timed | 0.41 ± 21.2% | | 0.95 | 15.15 | 0.0087 |
| reported/i1095-word-repetition/ascii-compile | 1 | 56.73 ± 11.0% | not timed | not timed | 18.19 ± 8.2% | 75.81 ± 18.5% | not timed | not timed | 56.80 ± 9.7% | | 1.00 | 3.12 | 0.75 |
| reported/i787-keywords/compile | 1 | 50.54 ± 4.5% | not timed | not timed | 3.09 ± 8.5% | 23.65 ± 13.0% | not timed | not timed | 51.67 ± 3.9% | | 0.98 | 16.36 | 2.14 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 545.50 ± 6.5% | not timed | not timed | 181.29 ± 1.8% | 740.54 ± 2.3% | not timed | not timed | 560.45 ± 3.6% | | 0.97 | 3.01 | 0.74 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 68.25 ± 10.5% | not timed | not timed | 6.86 ± 0.5% | 60.67 ± 11.2% | not timed | not timed | 74.16 ± 9.6% | | 0.92 | 9.94 | 1.12 |
| unicode/compile/one-letter | 53 | 9.86 ± 18.2% | not timed | not timed | 7.62 ± 8.4% | 79.72 ± 4.7% | not timed | not timed | 10.07 ± 8.3% | | 0.98 | 1.29 | 0.12 |
| unicode/compile/fifty-letters | 1 | 1.76 ± 13.2% | not timed | not timed | 0.16 ± 4.9% | 74.95 ± 10.5% | not timed | not timed | 1.82 ± 8.9% | | 0.97 | 10.98 | 0.0235 |
| unicode/compile/fifty-letters-ascii | 1 | 292.02 ± 6.4% | not timed | not timed | 81.53 ± 1.0% | 247.01 ± 36.2% | not timed | not timed | 296.40 ± 15.3% | | 0.99 | 3.58 | 1.18 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 665.32 ± 8.8% | not timed | not timed | 61.29 ± 3.4% | 938.53 ± 9.0% | not timed | not timed | 643.84 ± 21.1% | | 1.03 | 10.85 | 0.71 |
| unicode/compile/match-every-line-ascii | 4 | 1053.91 ± 10.7% | not timed | not timed | 208.24 ± 2.1% | 855.70 ± 11.6% | not timed | not timed | 1017.78 ± 9.5% | | 1.04 | 5.06 | 1.23 |
| unicode/compile/negated-class-matches-codepoint | 1 | 499.97 ± 6.3% | not timed | not timed | 62.58 ± 1.1% | 1610.79 ± 2.7% | not timed | not timed | 528.91 ± 6.3% | | 0.95 | 7.99 | 0.31 |
| wild/bibleref/compile | 3 | 8.34 ± 8.8% | not timed | not timed | 3.05 ± 8.6% | 40.94 ± 8.7% | not timed | not timed | 8.66 ± 15.1% | | 0.96 | 2.73 | 0.20 |
| wild/url/compile | 1 | 0.99 ± 16.9% | not timed | not timed | 0.21 ± 6.9% | 0.60 ± 6.9% | not timed | not timed | 0.98 ± 8.1% | | 1.01 | 4.59 | 1.63 |

