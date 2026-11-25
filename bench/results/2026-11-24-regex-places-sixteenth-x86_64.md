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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507050846 |
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
| literal: a word | 217 | 62680.41 ± 2.7% | 6204.27 ± 1.6% | 45.09 ± 1.1% | 50684.36 ± 7.8% | 15865.89 ± 4.9% | 15.44 ± 11.0% | 157.57 ± 1.8% | 62393.55 ± 1.5% | 10.10 | 1.00 | 1.24 | 3.95 |
| literal: a word that is not there | 0 | 82527.36 ± 1.5% | 5979.55 ± 0.5% | 45.20 ± 0.8% | 62922.47 ± 0.9% | 54994.62 ± 2.8% | 14.93 ± 0.2% | 144.67 ± 2.7% | 82231.25 ± 0.8% | 13.80 | 1.00 | 1.31 | 1.50 |
| literal: one of four words | 661 | 21526.87 ± 1.6% | 2329.47 ± 0.5% | 24.12 ± 0.5% | 14155.43 ± 0.8% | 37.96 ± 1.1% | 4.98 ± 1.4% | 13.12 ± 1.2% | 21550.52 ± 0.8% | 9.24 | 1.00 | 1.52 | 567.16 |
| literal: a word in any case | 217 | 58476.79 ± 2.6% | 2516.15 ± 1.0% | 32.66 ± 0.5% | 14008.88 ± 0.4% | 71.56 ± 1.9% | refused | differs | 58026.86 ± 0.9% | 23.24 | 1.01 | 4.17 | 817.18 |
| literal: an href attribute | 33 | 50713.28 ± 0.8% | 712.76 ± 1.0% | 38.01 ± 0.6% | 44655.82 ± 5.2% | 3408.99 ± 3.1% | 10.98 ± 2.1% | 130.21 ± 1.7% | 50088.62 ± 26.9% | 71.15 | 1.01 | 1.14 | 14.88 |
| literal: a word, second text | 123 | 63355.78 ± 2.1% | 4398.47 ± 1.0% | 43.51 ± 1.7% | 47739.01 ± 2.0% | 14461.26 ± 7.5% | 20.32 ± 1.0% | 129.86 ± 0.8% | 63429.19 ± 0.8% | 14.40 | 1.00 | 1.33 | 4.38 |
| class: two capitalized words | 1331 | 1102.18 ± 0.2% | 711.15 ± 0.7% | 40.57 ± 1.6% | 672.69 ± 0.6% | 60.11 ± 26.1% | 13.46 ± 0.5% | 104.57 ± 2.5% | 1103.74 ± 0.7% | 1.55 | 1.00 | 1.64 | 18.34 |
| class: a word that ends in ing | 3399 | 685.92 ± 0.7% | 687.03 ± 0.3% | 27.71 ± 0.5% | 630.32 ± 1.9% | 42.64 ± 11.4% | 7.83 ± 1.0% | 30.88 ± 1.8% | 688.52 ± 0.9% | 1.00 | 1.00 | 1.09 | 16.09 |
| class: a word in capitals | 2332 | 1587.20 ± 21.5% | 714.63 ± 2.7% | 42.21 ± 1.3% | 656.93 ± 1.5% | 64.95 ± 10.0% | 16.05 ± 1.0% | 134.20 ± 1.0% | 1593.51 ± 3.1% | 2.22 | 1.00 | 2.42 | 24.44 |
| class: a number | 8288 | 2858.96 ± 1.7% | 998.05 ± 1.4% | 42.64 ± 3.1% | 2258.69 ± 1.1% | 57.09 ± 18.6% | 0.43 ± 2.0% | 94.94 ± 6.2% | 2863.55 ± 11.1% | 2.86 | 1.00 | 1.27 | 50.08 |
| class: two capitalized words, second text | 5359 | 606.52 ± 0.9% | 616.50 ± 1.2% | 36.08 ± 2.3% | 559.57 ± 2.2% | 49.97 ± 6.4% | 17.32 ± 0.4% | 95.29 ± 2.1% | 608.43 ± 2.1% | 0.98 | 1.00 | 1.08 | 12.14 |
| other: a word between two words | 6104 | 1123.80 ± 19.7% | 698.64 ± 2.3% | 34.85 ± 1.8% | 940.58 ± 1.2% | 169.35 ± 7.9% | 10.02 ± 0.5% | 112.27 ± 3.4% | 1150.78 ± 7.4% | 1.61 | 0.98 | 1.19 | 6.64 |
| other: a number before a unit, second text | 1481 | 13052.30 ± 3.1% | 1414.05 ± 27.4% | 37.80 ± 2.5% | 10675.15 ± 1.7% | 58.78 ± 11.5% | 18.28 ± 0.7% | 105.82 ± 3.1% | 13052.96 ± 2.3% | 9.23 | 1.00 | 1.22 | 222.06 |
| other: a heading's start tag | 110 | 30929.13 ± 1.6% | 860.29 ± 0.8% | 39.51 ± 1.2% | 3232.27 ± 2.6% | 2507.20 ± 6.7% | 13.86 ± 2.0% | 161.13 ± 0.8% | 30941.47 ± 1.9% | 35.95 | 1.00 | 9.57 | 12.34 |
| other: a whole word | 217 | 40976.36 ± 9.4% | 700.26 ± 0.9% | 44.58 ± 1.6% | 35451.11 ± 1.0% | 73.17 ± 1.7% | 13.50 ± 0.7% | 82.96 ± 2.8% | 41187.25 ± 0.7% | 58.52 | 0.99 | 1.16 | 560.03 |
| other: a line's first word, second text | 3716 | 3411.58 ± 1.5% | 704.84 ± 1.2% | 48.11 ± 2.6% | 3394.77 ± 3.7% | 97.95 ± 4.3% | refused | refused | 3413.86 ± 1.5% | 4.84 | 1.00 | 1.00 | 34.83 |
| other: fourteen octets before an x | 87 | 50857.53 ± 1.7% | 330.52 ± 1.6% | 9.31 ± 1.5% | 4677.84 ± 1.7% | 14.05 ± 25.5% | differs | 25.46 ± 2.8% | 51279.59 ± 1.4% | 153.87 | 0.99 | 10.87 | 3618.89 |
| other: a Greek word | 21815 | 651.83 ± 2.2% | 533.21 ± 1.4% | 47.52 ± 2.2% | 346.15 ± 1.9% | 59.91 ± 17.9% | differs | refused | 653.09 ± 1.0% | 1.22 | 1.00 | 1.88 | 10.88 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 37.20 ± 5.0% | 37.15 ± 19.9% | 1.49 ± 0.5% | 23.62 ± 1.0% | 3.54 ± 3.2% | differs | 5.93 ± 5.4% | 37.33 ± 1.6% | 1.00 | 1.00 | 1.58 | 10.51 |
| a UUID | 32895 | 33.51 ± 4.2% | 33.42 ± 1.3% | 1.00 ± 0.9% | 18.00 ± 0.4% | 3.50 ± 2.5% | 0.72 ± 1.8% | 4.56 ± 10.8% | 33.13 ± 7.3% | 1.00 | 1.01 | 1.86 | 9.59 |
| an IPv4 address | 33176 | 46.60 ± 0.6% | 46.83 ± 1.8% | 3.24 ± 1.8% | 34.26 ± 0.8% | 8.95 ± 1.6% | differs | 5.77 ± 0.9% | 46.11 ± 1.4% | 1.00 | 1.01 | 1.36 | 5.21 |
| a date and time | 32954 | 45.58 ± 0.7% | 45.67 ± 1.1% | 2.42 ± 1.1% | 25.74 ± 1.0% | 10.77 ± 8.3% | 1.28 ± 1.0% | 11.39 ± 5.0% | 45.69 ± 0.7% | 1.00 | 1.00 | 1.77 | 4.23 |
| a field path | 32606 | 39.14 ± 1.5% | 40.11 ± 1.6% | 1.71 ± 1.5% | 27.27 ± 1.0% | 4.62 ± 2.9% | differs | 4.13 ± 1.8% | 40.25 ± 8.8% | 0.98 | 0.97 | 1.44 | 8.48 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 14.82 ± 0.9% | 14.91 ± 0.8% | 14.66 ± 1.4% | 16.90 ± 1.7% | 7.39 ± 7.5% | 1.03 ± 3.3% | none | 15.34 ± 1.0% | 0.99 | 0.97 | 0.88 | 2.01 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 353.34 ± 6.6% | 352.74 ± 31.3% | 412.15 ± 4.2% | 131.89 ± 1.8% | 313.80 ± 2.9% | 863.16 ± 1.3% | 5687.52 ± 5.3% | 352.19 ± 5.4% | 1.00 | 1.00 | 2.68 | 1.13 |
| a UUID | 62 | 232.96 ± 1.6% | 231.88 ± 11.0% | 256.99 ± 32.0% | 73.16 ± 3.6% | 154.09 ± 20.7% | 300.02 ± 3.0% | 7028.15 ± 4.6% | 231.15 ± 8.7% | 1.00 | 1.01 | 3.18 | 1.51 |
| an IPv4 address | 29 | 675.04 ± 1.2% | 670.97 ± 4.2% | 926.66 ± 1.0% | 118.64 ± 2.4% | 199.57 ± 1.9% | 546.56 ± 6.8% | 12546.12 ± 32.9% | 676.27 ± 1.3% | 1.01 | 1.00 | 5.69 | 3.38 |
| a date and time | 56 | 497.69 ± 1.7% | 495.39 ± 4.4% | 611.47 ± 11.3% | 111.67 ± 1.2% | 214.00 ± 33.7% | 556.75 ± 3.8% | 7894.89 ± 12.0% | 495.97 ± 1.6% | 1.00 | 1.00 | 4.46 | 2.33 |
| a field path | 39 | 353.14 ± 1.8% | 350.29 ± 11.8% | 410.14 ± 4.4% | 124.19 ± 2.0% | 292.67 ± 16.5% | 892.36 ± 1.4% | 7281.60 ± 5.3% | 350.22 ± 10.1% | 1.01 | 1.01 | 2.84 | 1.21 |
| literal: a word | 7 | 1048.60 ± 2.0% | 1134.49 ± 1.4% | 1939.55 ± 1.6% | 831.86 ± 6.7% | 986.93 ± 17.5% | 1779.68 ± 0.7% | 46047.27 ± 2.8% | 1040.45 ± 2.7% | 0.92 | 1.01 | 1.26 | 1.06 |
| literal: a word that is not there | 8 | 979.30 ± 2.4% | 1076.01 ± 2.2% | 1773.50 ± 1.9% | 759.86 ± 1.3% | 959.05 ± 3.7% | 1696.92 ± 1.5% | 46337.03 ± 3.1% | 977.90 ± 2.5% | 0.91 | 1.00 | 1.29 | 1.02 |
| literal: one of four words | 26 | 398.71 ± 1.7% | 626.63 ± 1.7% | 819.83 ± 2.2% | 65.28 ± 1.5% | 383.20 ± 2.0% | 648.26 ± 0.5% | 26570.11 ± 13.9% | 397.85 ± 1.0% | 0.64 | 1.00 | 6.11 | 1.04 |
| literal: a word in any case | 11 | 737.92 ± 1.5% | 786.93 ± 2.4% | 1105.40 ± 0.9% | 22.41 ± 1.5% | 1065.92 ± 1.1% | refused | 38318.31 ± 1.5% | 734.75 ± 1.3% | 0.94 | 1.00 | 32.92 | 0.69 |
| literal: an href attribute | 12 | 558.78 ± 1.4% | 584.44 ± 1.6% | 750.53 ± 3.4% | 59.74 ± 0.9% | 721.68 ± 31.3% | 1442.37 ± 1.4% | 33289.20 ± 2.2% | 553.61 ± 1.9% | 0.96 | 1.01 | 9.35 | 0.77 |
| literal: a word, second text | 10 | 911.22 ± 2.5% | 1012.25 ± 2.7% | 1616.40 ± 4.2% | 697.09 ± 0.4% | 834.28 ± 13.1% | 1476.01 ± 21.1% | 44416.94 ± 29.4% | 926.33 ± 2.9% | 0.90 | 0.98 | 1.31 | 1.09 |
| class: two capitalized words | 23 | 724.36 ± 0.6% | 786.48 ± 2.1% | 1128.91 ± 3.3% | 157.22 ± 1.4% | 761.38 ± 5.3% | 1400.24 ± 3.2% | 9109.29 ± 8.8% | 725.61 ± 2.1% | 0.92 | 1.00 | 4.61 | 0.95 |
| class: a word that ends in ing | 9 | 900.44 ± 21.1% | 1047.69 ± 4.3% | 1743.22 ± 3.0% | 199.69 ± 0.4% | 1071.59 ± 2.0% | 2129.16 ± 2.0% | 23875.41 ± 6.3% | 914.66 ± 1.9% | 0.86 | 0.98 | 4.51 | 0.84 |
| class: a word in capitals | 16 | 819.67 ± 8.3% | 904.39 ± 1.8% | 1402.15 ± 1.7% | 204.66 ± 4.3% | 1121.00 ± 9.2% | 1940.89 ± 4.0% | 12319.94 ± 1.7% | 825.06 ± 1.3% | 0.91 | 0.99 | 4.01 | 0.73 |
| class: a number | 6 | 1030.20 ± 2.6% | 1149.94 ± 2.2% | 2063.87 ± 8.3% | 57.82 ± 3.7% | 2047.86 ± 12.9% | 3519.52 ± 2.1% | 34865.00 ± 1.0% | 1025.28 ± 2.0% | 0.90 | 1.00 | 17.82 | 0.50 |
| class: two capitalized words, second text | 23 | 732.23 ± 2.1% | 795.36 ± 1.6% | 1128.43 ± 2.6% | 157.83 ± 1.7% | 759.42 ± 12.7% | 1375.11 ± 1.7% | 9132.20 ± 9.7% | 732.69 ± 1.6% | 0.92 | 1.00 | 4.64 | 0.96 |
| other: a word between two words | 13 | 896.20 ± 9.5% | 943.45 ± 7.3% | 1462.62 ± 2.7% | 204.70 ± 1.4% | 744.09 ± 3.2% | 1494.76 ± 3.3% | 22675.52 ± 1.9% | 891.24 ± 2.8% | 0.95 | 1.01 | 4.38 | 1.20 |
| other: a number before a unit, second text | 15 | 679.59 ± 8.0% | 747.13 ± 10.2% | 1007.31 ± 33.6% | 55.30 ± 8.1% | 896.63 ± 15.8% | 1772.41 ± 5.7% | 25063.93 ± 6.1% | 688.70 ± 7.0% | 0.91 | 0.99 | 12.29 | 0.76 |
| other: a heading's start tag | 13 | 616.29 ± 19.6% | 628.68 ± 5.1% | 823.26 ± 5.2% | 61.73 ± 4.6% | 944.84 ± 11.7% | 1702.16 ± 8.5% | 30850.29 ± 16.5% | 621.74 ± 8.1% | 0.98 | 0.99 | 9.98 | 0.65 |
| other: a whole word | 11 | 961.81 ± 26.2% | 1037.33 ± 7.3% | 1675.86 ± 7.1% | 195.83 ± 6.3% | 941.08 ± 57.1% | 1657.12 ± 6.0% | 45846.03 ± 13.8% | 963.25 ± 7.0% | 0.93 | 1.00 | 4.91 | 1.02 |
| other: a line's first word, second text | 17 | 913.36 ± 3.0% | 984.02 ± 3.8% | 1558.95 ± 3.6% | 207.66 ± 3.3% | 1056.38 ± 12.5% | refused | refused | 920.64 ± 7.3% | 0.93 | 0.99 | 4.40 | 0.86 |
| other: fourteen octets before an x | 16 | 187.72 ± 1.4% | 269.05 ± 5.8% | 298.43 ± 5.4% | 22.91 ± 4.9% | 703.15 ± 1.6% | 775.48 ± 2.3% | 21908.70 ± 15.4% | 181.63 ± 18.4% | 0.70 | 1.03 | 8.19 | 0.27 |
| other: a Greek word | 8 | 752.49 ± 3.1% | 1006.13 ± 5.4% | 1611.54 ± 9.0% | 77.74 ± 1.5% | 2139.70 ± 15.8% | 3521.71 ± 2.3% | refused | 754.59 ± 6.3% | 0.75 | 1.00 | 9.68 | 0.35 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 47047.34 ± 3.1% | not timed | not timed | 45446.72 ± 2.7% | 3672.91 ± 16.8% | not timed | not timed | 46337.30 ± 10.3% | | 1.02 | 1.04 | 12.81 |
| 01-literal/sherlock-casei-en | 522 | 42519.11 ± 4.7% | not timed | not timed | 11937.21 ± 2.8% | 53.86 ± 3.7% | not timed | not timed | 42747.32 ± 2.7% | | 0.99 | 3.56 | 789.41 |
| 01-literal/sherlock-ru | 724 | 47420.12 ± 7.9% | not timed | not timed | 45876.23 ± 4.8% | 2477.33 ± 4.1% | not timed | not timed | 47441.20 ± 3.2% | | 1.00 | 1.03 | 19.14 |
| 01-literal/sherlock-casei-ru | 746 | 15317.39 ± 2.3% | not timed | not timed | 9706.76 ± 0.9% | 59.68 ± 0.7% | not timed | not timed | 15322.46 ± 2.6% | | 1.00 | 1.58 | 256.67 |
| 01-literal/sherlock-zh | 30 | 82816.33 ± 3.4% | not timed | not timed | 61180.86 ± 1.2% | 2185.04 ± 2.2% | not timed | not timed | 82533.19 ± 3.0% | | 1.00 | 1.35 | 37.90 |
| 02-literal-alternate/sherlock-en | 714 | 19564.63 ± 2.5% | not timed | not timed | 13930.38 ± 3.1% | 30.39 ± 4.9% | not timed | not timed | 19585.32 ± 2.3% | | 1.00 | 1.40 | 643.74 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3178.73 ± 5.3% | not timed | not timed | 3045.72 ± 1.4% | 18.76 ± 13.0% | not timed | not timed | 3194.51 ± 4.9% | | 1.00 | 1.04 | 169.46 |
| 02-literal-alternate/sherlock-ru | 899 | 13144.33 ± 1.6% | not timed | not timed | 7637.38 ± 1.9% | 39.29 ± 8.0% | not timed | not timed | 13076.38 ± 1.3% | | 1.01 | 1.72 | 334.54 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2857.50 ± 3.2% | not timed | not timed | 1411.10 ± 55.4% | 15.93 ± 39.8% | not timed | not timed | 2810.08 ± 34.2% | | 1.02 | 2.03 | 179.38 |
| 02-literal-alternate/sherlock-zh | 207 | 26373.32 ± 0.9% | not timed | not timed | 16422.13 ± 2.1% | 56.11 ± 3.2% | not timed | not timed | 26225.53 ± 2.7% | | 1.01 | 1.61 | 470.01 |
| 03-date/ascii | 111817 | 179.82 ± 22.3% | not timed | not timed | 129.17 ± 1.7% | 0.31 ± 6.2% | not timed | not timed | 192.47 ± 4.9% | | 0.93 | 1.39 | 578.78 |
| 04-ruff-noqa/real | 84 | 688.22 ± 15.3% | not timed | not timed | 671.70 ± 15.2% | 31.84 ± 6.9% | not timed | not timed | 684.64 ± 3.6% | | 1.01 | 1.02 | 21.62 |
| 04-ruff-noqa/tweaked | 44 | 856.44 ± 5.6% | not timed | not timed | 704.58 ± 5.4% | 499.42 ± 12.1% | not timed | not timed | 841.92 ± 4.5% | | 1.02 | 1.22 | 1.71 |
| 05-lexer-veryl/single | 124800 | 7.42 ± 6.2% | not timed | not timed | 7.77 ± 4.6% | 0.35 ± 6.3% | not timed | not timed | 7.48 ± 11.4% | | 0.99 | 0.95 | 21.11 |
| 06-cloud-flare-redos/original | 107 | 558.99 ± 6.1% | not timed | not timed | 293.51 ± 5.6% | 39.60 ± 7.1% | not timed | not timed | 553.04 ± 26.6% | | 1.01 | 1.90 | 14.12 |
| 06-cloud-flare-redos/simplified-short | 102 | 555.52 ± 8.6% | not timed | not timed | 310.01 ± 15.9% | 42.18 ± 7.4% | not timed | not timed | 558.07 ± 8.0% | | 1.00 | 1.79 | 13.17 |
| 06-cloud-flare-redos/simplified-long | 10000 | 650.60 ± 3.5% | not timed | not timed | 320.32 ± 3.4% | 45.96 ± 2.5% | not timed | not timed | 649.34 ± 2.0% | | 1.00 | 2.03 | 14.16 |
| 07-unicode-character-data/parse-line | 558784 | 325.51 ± 2.7% | not timed | not timed | 252.77 ± 4.3% | 66.19 ± 3.1% | not timed | not timed | 325.24 ± 4.7% | | 1.00 | 1.29 | 4.92 |
| 08-words/all-english | 56691 | 172.46 ± 5.1% | not timed | not timed | 108.08 ± 2.8% | 18.85 ± 12.6% | not timed | not timed | 165.53 ± 3.6% | | 1.04 | 1.60 | 9.15 |
| 08-words/long-english | 839 | 744.11 ± 4.6% | not timed | not timed | 707.34 ± 9.1% | 49.15 ± 21.3% | not timed | not timed | 735.03 ± 25.2% | | 1.01 | 1.05 | 15.14 |
| 09-aws-keys/full | 0 | 686.23 ± 8.4% | not timed | not timed | 686.43 ± 3.5% | 98.00 ± 4.9% | not timed | not timed | 683.33 ± 4.7% | | 1.00 | 1.00 | 7.00 |
| 09-aws-keys/quick | 0 | 1516.97 ± 7.7% | not timed | not timed | 1293.45 ± 3.0% | 566.90 ± 1.5% | not timed | not timed | 1533.24 ± 2.3% | | 0.99 | 1.17 | 2.68 |
| 10-bounded-repeat/letters-en | 1833 | 830.46 ± 13.6% | not timed | not timed | 741.69 ± 33.7% | 30.81 ± 7.1% | not timed | not timed | 842.77 ± 3.6% | | 0.99 | 1.12 | 26.96 |
| 10-bounded-repeat/letters-ru | 3475 | 741.44 ± 3.5% | not timed | not timed | 656.27 ± 2.3% | 29.73 ± 9.5% | not timed | not timed | 721.34 ± 32.7% | | 1.03 | 1.13 | 24.94 |
| 10-bounded-repeat/context | 53 | 119.50 ± 2.8% | not timed | not timed | 94.44 ± 5.3% | 30.04 ± 5.4% | not timed | not timed | 117.79 ± 5.6% | | 1.01 | 1.27 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 769.90 ± 6.8% | not timed | not timed | 726.53 ± 1.5% | 53.91 ± 8.0% | not timed | not timed | 775.75 ± 10.2% | | 0.99 | 1.06 | 14.28 |
| 11-unstructured-to-json/extract | 600 | 78.25 ± 30.7% | not timed | not timed | 109.23 ± 10.3% | 78.33 ± 5.7% | not timed | not timed | 78.38 ± 21.0% | | 1.00 | 0.72 | 1.00 |
| 12-dictionary/single | 1 | 665.56 ± 2.2% | not timed | not timed | 644.84 ± 3.9% | 0.65 ± 4.0% | not timed | not timed | 672.28 ± 5.8% | | 0.99 | 1.03 | 1027.12 |
| 14-quadratic/1x | 100 | 41.39 ± 11.8% | not timed | not timed | 17.44 ± 7.0% | 1.50 ± 1.6% | not timed | not timed | 41.42 ± 11.0% | | 1.00 | 2.37 | 27.61 |
| 14-quadratic/2x | 200 | 33.05 ± 4.5% | not timed | not timed | 8.15 ± 3.6% | 0.81 ± 2.2% | not timed | not timed | 33.13 ± 4.8% | | 1.00 | 4.06 | 40.63 |
| 14-quadratic/10x | 1000 | 11.26 ± 2.7% | not timed | not timed | 1.51 ± 1.7% | 0.18 ± 2.5% | not timed | not timed | 11.13 ± 4.2% | | 1.01 | 7.47 | 63.61 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.99 ± 3.0% | not timed | not timed | 0.55 ± 6.3% | 0.87 ± 9.8% | not timed | not timed | 2.01 ± 7.5% | | 0.99 | 3.61 | 2.29 |
| 04-ruff-noqa/compile-real | 1 | 188.98 ± 6.0% | not timed | not timed | 21.86 ± 10.1% | 229.32 ± 55.0% | not timed | not timed | 186.55 ± 3.0% | | 1.01 | 8.65 | 0.82 |
| 05-lexer-veryl/compile-single | 1 | 23.55 ± 1.5% | not timed | not timed | 4.03 ± 10.1% | 11.34 ± 25.4% | not timed | not timed | 23.68 ± 4.8% | | 0.99 | 5.84 | 2.08 |
| 07-unicode-character-data/compile | 1 | 181.48 ± 5.7% | not timed | not timed | 39.72 ± 4.6% | 60.33 ± 3.4% | not timed | not timed | 175.12 ± 5.0% | | 1.04 | 4.57 | 3.01 |
| 09-aws-keys/compile-full | 1 | 78.88 ± 5.8% | not timed | not timed | 12.85 ± 3.2% | 37.33 ± 11.4% | not timed | not timed | 79.18 ± 3.3% | | 1.00 | 6.14 | 2.11 |
| 09-aws-keys/compile-quick | 1 | 295.93 ± 1.7% | not timed | not timed | 80.21 ± 3.8% | 223.75 ± 2.0% | not timed | not timed | 292.56 ± 1.1% | | 1.01 | 3.69 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 88.09 ± 6.6% | not timed | not timed | 17.68 ± 3.9% | 27.43 ± 5.7% | not timed | not timed | 88.89 ± 1.5% | | 0.99 | 4.98 | 3.21 |
| 10-bounded-repeat/compile-capitals | 1 | 138.33 ± 0.6% | not timed | not timed | 13.01 ± 2.4% | 40.10 ± 9.2% | not timed | not timed | 138.15 ± 6.7% | | 1.00 | 10.64 | 3.45 |
| 11-unstructured-to-json/compile | 1 | 290.88 ± 2.6% | not timed | not timed | 67.71 ± 1.7% | 115.36 ± 2.8% | not timed | not timed | 288.23 ± 2.2% | | 1.01 | 4.30 | 2.52 |
| 12-dictionary/compile-single | 1 | 0.48 ± 2.0% | not timed | not timed | 0.10 ± 10.4% | 0.15 ± 31.5% | not timed | not timed | 0.48 ± 1.0% | | 1.00 | 4.70 | 3.20 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.81 ± 7.6% | not timed | not timed | 9.87 ± 10.2% | 0.91 ± 34.8% | not timed | not timed | 10.67 ± 6.3% | | 1.01 | 1.10 | 11.92 |
| dictionary/search/english-10 | 690 | 1.84 ± 5.7% | not timed | not timed | 236.64 ± 6.2% | 0.01 ± 5.4% | not timed | not timed | 1.92 ± 10.1% | | 0.96 | 0.0078 | 174.33 |
| dictionary/search/english-15 | 15 | 627.86 ± 1.7% | not timed | not timed | 601.07 ± 0.8% | 0.58 ± 0.4% | not timed | not timed | 626.38 ± 1.0% | | 1.00 | 1.04 | 1089.36 |
| folly/awyer-inn-busted | 1 | 6758.79 ± 2.4% | not timed | not timed | 160.23 ± 0.4% | 70.48 ± 2.2% | not timed | not timed | 6758.60 ± 4.3% | | 1.00 | 42.18 | 95.90 |
| folly/literal-never-match-rare | 0 | 80032.13 ± 1.7% | not timed | not timed | 63544.24 ± 1.8% | 86035.91 ± 2.3% | not timed | not timed | 80327.05 ± 2.2% | | 1.00 | 1.26 | 0.93 |
| folly/literal-never-match-frequent | 0 | 35520.43 ± 9.2% | not timed | not timed | 61776.16 ± 2.2% | 2829.98 ± 6.0% | not timed | not timed | 36242.63 ± 7.2% | | 0.98 | 0.57 | 12.55 |
| folly/literal-never-match-tricksy | 1 | 5221.34 ± 5.4% | not timed | not timed | 8003.61 ± 0.8% | 3548.03 ± 3.5% | not timed | not timed | 5218.97 ± 5.4% | | 1.00 | 0.65 | 1.47 |
| grep/every-line | 239963 | 1734.89 ± 2.2% | not timed | not timed | 1219.51 ± 1.9% | 489.52 ± 11.7% | not timed | not timed | 1753.94 ± 2.8% | | 0.99 | 1.42 | 3.54 |
| grep/long-words-ascii | 5073 | 636.45 ± 2.3% | not timed | not timed | 591.32 ± 9.5% | 64.44 ± 8.9% | not timed | not timed | 637.47 ± 17.6% | | 1.00 | 1.08 | 9.88 |
| imported/leipzig/twain | 811 | 68834.45 ± 2.1% | not timed | not timed | 56841.68 ± 3.4% | 14620.30 ± 10.8% | not timed | not timed | 69059.73 ± 2.4% | | 1.00 | 1.21 | 4.71 |
| imported/leipzig/twain-insensitive | 965 | 18314.09 ± 2.7% | not timed | not timed | 16626.41 ± 1.4% | 62.43 ± 2.8% | not timed | not timed | 18386.18 ± 2.3% | | 1.00 | 1.10 | 293.33 |
| imported/leipzig/shing | 1540 | 40389.12 ± 6.7% | not timed | not timed | 26913.39 ± 1.0% | 50.24 ± 5.4% | not timed | not timed | 40567.12 ± 2.8% | | 1.00 | 1.50 | 803.87 |
| imported/leipzig/huck-saw | 262 | 33074.73 ± 0.9% | not timed | not timed | 22984.86 ± 1.0% | 51.28 ± 0.6% | not timed | not timed | 33069.06 ± 1.5% | | 1.00 | 1.44 | 644.95 |
| imported/leipzig/word-ending-nn | 262 | 691.68 ± 2.4% | not timed | not timed | 693.24 ± 2.6% | 38.66 ± 3.3% | not timed | not timed | 694.27 ± 1.0% | | 1.00 | 1.00 | 17.89 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 14654.68 ± 2.0% | not timed | not timed | 5311.62 ± 2.6% | 14.84 ± 2.7% | not timed | not timed | 14727.54 ± 2.7% | | 1.00 | 2.76 | 987.37 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 27884.97 ± 1.5% | not timed | not timed | 21107.02 ± 6.8% | 28.84 ± 3.2% | not timed | not timed | 27997.90 ± 8.1% | | 1.00 | 1.32 | 966.98 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6428.20 ± 1.6% | not timed | not timed | 1112.58 ± 0.8% | 17.44 ± 3.1% | not timed | not timed | 6381.94 ± 1.4% | | 1.01 | 5.78 | 368.68 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 695.93 ± 0.3% | not timed | not timed | 695.29 ± 0.4% | 18.27 ± 2.3% | not timed | not timed | 697.12 ± 0.7% | | 1.00 | 1.00 | 38.10 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 699.03 ± 1.2% | not timed | not timed | 696.33 ± 0.5% | 15.71 ± 1.3% | not timed | not timed | 697.26 ± 0.3% | | 1.00 | 1.00 | 44.51 |
| imported/leipzig/tom-river | 2 | 16266.39 ± 1.2% | not timed | not timed | 16792.01 ± 0.4% | 50.24 ± 5.0% | not timed | not timed | 16296.28 ± 0.7% | | 1.00 | 0.97 | 323.77 |
| imported/leipzig/ing | 78424 | 683.31 ± 1.0% | not timed | not timed | 641.61 ± 1.8% | 40.53 ± 6.0% | not timed | not timed | 685.54 ± 0.4% | | 1.00 | 1.06 | 16.86 |
| imported/leipzig/ing-whitespace | 55248 | 853.63 ± 0.2% | not timed | not timed | 2727.25 ± 0.8% | 30.78 ± 8.4% | not timed | not timed | 859.40 ± 1.2% | | 0.99 | 0.31 | 27.73 |
| imported/leipzig/awyer-inn | 209 | 883.92 ± 1.5% | not timed | not timed | 17107.81 ± 0.4% | 33.39 ± 6.5% | not timed | not timed | 884.48 ± 1.4% | | 1.00 | 0.0517 | 26.47 |
| imported/leipzig/quotes-bounded | 8886 | 2412.21 ± 3.5% | not timed | not timed | 3811.36 ± 3.0% | 56.91 ± 3.5% | not timed | not timed | 2406.92 ± 3.5% | | 1.00 | 0.63 | 42.38 |
| imported/leipzig/non-ascii-alternate | 2 | 61284.15 ± 0.9% | not timed | not timed | 24063.94 ± 1.7% | 83.12 ± 1.4% | not timed | not timed | 61458.81 ± 1.3% | | 1.00 | 2.55 | 737.29 |
| imported/leipzig/math-symbols | 69 | 4152.47 ± 3.8% | not timed | not timed | 681.62 ± 5.8% | 53.93 ± 5.1% | not timed | not timed | 4050.99 ± 5.1% | | 1.03 | 6.09 | 77.00 |
| imported/leipzig/bounded-strings-ending-z | 0 | 696.85 ± 12.9% | not timed | not timed | 697.30 ± 0.5% | 36.78 ± 4.8% | not timed | not timed | 693.42 ± 2.2% | | 1.00 | 1.00 | 18.95 |
| imported/lh3lh3-reb/uri | 17549 | 1013.16 ± 3.8% | not timed | not timed | 1507.34 ± 3.1% | 40.91 ± 5.1% | not timed | not timed | 990.96 ± 4.5% | | 1.02 | 0.67 | 24.77 |
| imported/lh3lh3-reb/email | 15057 | 994.39 ± 2.3% | not timed | not timed | 1454.80 ± 5.2% | 43.39 ± 3.0% | not timed | not timed | 953.39 ± 6.6% | | 1.04 | 0.68 | 22.92 |
| imported/lh3lh3-reb/date | 668 | 1126.61 ± 4.3% | not timed | not timed | 1255.52 ± 2.5% | 69.83 ± 5.4% | not timed | not timed | 1124.39 ± 2.3% | | 1.00 | 0.90 | 16.13 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 902.07 ± 1.9% | not timed | not timed | 522.52 ± 1.9% | 21.52 ± 3.7% | not timed | not timed | 901.06 ± 12.8% | | 1.00 | 1.73 | 41.92 |
| imported/mariomka/email | 92 | 51564.44 ± 1.7% | not timed | not timed | 71183.36 ± 3.1% | 47.93 ± 2.6% | not timed | not timed | 51182.77 ± 6.6% | | 1.01 | 0.72 | 1075.81 |
| imported/mariomka/uri | 5301 | 8397.74 ± 2.1% | not timed | not timed | 8907.99 ± 13.8% | 48.80 ± 1.2% | not timed | not timed | 8429.06 ± 2.1% | | 1.00 | 0.94 | 172.09 |
| imported/mariomka/ip | 5 | 2343.83 ± 0.9% | not timed | not timed | 2782.18 ± 1.2% | 31.94 ± 1.0% | not timed | not timed | 2339.78 ± 7.1% | | 1.00 | 0.84 | 73.39 |
| imported/rsc/no-exponential | 0 | 1150.47 ± 0.8% | not timed | not timed | 570.59 ± 0.7% | 34.20 ± 2.5% | not timed | not timed | 1146.43 ± 0.7% | | 1.00 | 2.02 | 33.64 |
| imported/rsc/literal | 1 | 1298.85 ± 5.9% | not timed | not timed | 2997.24 ± 0.5% | 323.73 ± 4.6% | not timed | not timed | 1309.47 ± 10.2% | | 0.99 | 0.43 | 4.01 |
| imported/rsc/not-literal | 2 | 1413.46 ± 5.1% | not timed | not timed | 1327.03 ± 0.5% | 74.16 ± 1.7% | not timed | not timed | 1405.46 ± 5.8% | | 1.01 | 1.07 | 19.06 |
| imported/rsc/match-class | 1 | 2520.41 ± 6.4% | not timed | not timed | 3024.16 ± 0.3% | 94.11 ± 1.7% | not timed | not timed | 2525.81 ± 0.7% | | 1.00 | 0.83 | 26.78 |
| imported/rsc/match-class-in-range | 1 | 2524.00 ± 4.2% | not timed | not timed | 4634.10 ± 0.9% | 96.76 ± 1.8% | not timed | not timed | 2525.45 ± 6.2% | | 1.00 | 0.54 | 26.08 |
| imported/rsc/match-class-unicode | 1 | 664.18 ± 2.8% | not timed | not timed | 638.32 ± 1.8% | 112.42 ± 53.5% | not timed | not timed | 667.40 ± 3.9% | | 1.00 | 1.04 | 5.91 |
| imported/rsc/anchored-literal-short-non-match | 0 | 2441.67 ± 23.9% | not timed | not timed | 1693.78 ± 2.6% | 441.99 ± 2.7% | not timed | not timed | 2447.75 ± 29.8% | | 1.00 | 1.44 | 5.52 |
| imported/rsc/anchored-literal-long-non-match | 0 | 36757.84 ± 28.5% | not timed | not timed | 25474.51 ± 3.1% | 6559.72 ± 2.3% | not timed | not timed | 37022.89 ± 3.9% | | 0.99 | 1.44 | 5.60 |
| imported/rsc/anchored-literal-short-match | 4 | 1263.39 ± 2.9% | not timed | not timed | 919.61 ± 0.2% | 149.35 ± 10.5% | not timed | not timed | 1252.31 ± 6.9% | | 1.01 | 1.37 | 8.46 |
| imported/rsc/anchored-literal-long-match | 4 | 18803.30 ± 5.2% | not timed | not timed | 13864.74 ± 0.4% | 2127.77 ± 21.8% | not timed | not timed | 18795.50 ± 5.9% | | 1.00 | 1.36 | 8.84 |
| imported/rsc/one-pass-short | 17 | 692.27 ± 6.7% | not timed | not timed | 440.99 ± 3.0% | 48.15 ± 13.7% | not timed | not timed | 699.41 ± 3.2% | | 0.99 | 1.57 | 14.38 |
| imported/rsc/one-pass-short-not | 17 | 446.14 ± 4.5% | not timed | not timed | 467.40 ± 7.8% | 43.45 ± 14.5% | not timed | not timed | 398.98 ± 3.3% | | 1.12 | 0.95 | 10.27 |
| imported/rsc/one-pass-long-prefix | 26 | 563.96 ± 16.0% | not timed | not timed | 489.48 ± 8.8% | 174.71 ± 16.8% | not timed | not timed | 549.84 ± 10.0% | | 1.03 | 1.15 | 3.23 |
| imported/rsc/one-pass-long-prefix-not | 26 | 542.78 ± 8.9% | not timed | not timed | 493.33 ± 1.2% | 111.26 ± 9.3% | not timed | not timed | 572.78 ± 8.5% | | 0.95 | 1.10 | 4.88 |
| imported/rsc/long-needle1 | 31 | 85254.34 ± 0.2% | not timed | not timed | 65009.41 ± 0.5% | 5.75 ± 20.3% | not timed | not timed | 85097.36 ± 0.9% | | 1.00 | 1.31 | 14818.41 |
| imported/rsc/long-needle2 | 31 | 85601.07 ± 3.0% | not timed | not timed | 349.96 ± 1.8% | 5.79 ± 0.8% | not timed | not timed | 85633.39 ± 2.5% | | 1.00 | 244.60 | 14779.32 |
| imported/rsc/easy0-32 | 26 | 1878.60 ± 19.1% | not timed | not timed | 2713.92 ± 2.1% | 215.72 ± 10.5% | not timed | not timed | 1886.83 ± 3.4% | | 1.00 | 0.69 | 8.71 |
| imported/rsc/easy0-1k | 26 | 29019.55 ± 1.8% | not timed | not timed | 30012.69 ± 1.3% | 3312.49 ± 6.0% | not timed | not timed | 29235.32 ± 13.4% | | 0.99 | 0.97 | 8.76 |
| imported/rsc/easy0-32k | 26 | 81125.56 ± 2.6% | not timed | not timed | 62158.71 ± 6.4% | 37831.12 ± 19.4% | not timed | not timed | 81321.39 ± 3.7% | | 1.00 | 1.31 | 2.14 |
| imported/rsc/easy0-1mb | 26 | 81680.94 ± 11.1% | not timed | not timed | 65322.11 ± 15.6% | 97506.75 ± 0.9% | not timed | not timed | 81103.41 ± 2.3% | | 1.01 | 1.25 | 0.84 |
| imported/rsc/easy1-32 | 19 | 1292.81 ± 33.1% | not timed | not timed | 1172.62 ± 0.8% | 199.40 ± 23.8% | not timed | not timed | 1285.02 ± 2.2% | | 1.01 | 1.10 | 6.48 |
| imported/rsc/easy1-1k | 19 | 24229.77 ± 3.2% | not timed | not timed | 26204.81 ± 5.7% | 3483.98 ± 12.5% | not timed | not timed | 23865.56 ± 6.9% | | 1.02 | 0.92 | 6.95 |
| imported/rsc/easy1-32k | 19 | 824615.96 ± 2.6% | not timed | not timed | 789935.13 ± 0.5% | 41147.59 ± 16.3% | not timed | not timed | 830218.32 ± 0.9% | | 0.99 | 1.04 | 20.04 |
| imported/rsc/easy1-1mb | 19 | 26680118.21 ± 0.7% | not timed | not timed | 25875518.32 ± 1.6% | 97655.92 ± 1.9% | not timed | not timed | 26489450.21 ± 2.0% | | 1.01 | 1.03 | 273.21 |
| imported/rsc/medium-32 | 27 | 1159.05 ± 1.8% | not timed | not timed | 1150.06 ± 1.3% | 101.82 ± 14.8% | not timed | not timed | 1153.72 ± 0.4% | | 1.00 | 1.01 | 11.38 |
| imported/rsc/medium-1k | 27 | 20674.88 ± 0.3% | not timed | not timed | 19158.49 ± 0.5% | 109.87 ± 1.8% | not timed | not timed | 20613.43 ± 2.7% | | 1.00 | 1.08 | 188.18 |
| imported/rsc/medium-32k | 27 | 599541.44 ± 2.3% | not timed | not timed | 622673.65 ± 22.7% | 77.22 ± 0.6% | not timed | not timed | 601242.64 ± 1.2% | | 1.00 | 0.96 | 7763.61 |
| imported/rsc/medium-1mb | 27 | 19764510.47 ± 17.4% | not timed | not timed | 19100109.88 ± 39.6% | 78.57 ± 18.7% | not timed | not timed | 19788035.09 ± 20.9% | | 1.00 | 1.03 | 251547.53 |
| imported/rsc/hard-32 | 58 | 538.04 ± 12.8% | not timed | not timed | 499.25 ± 1.8% | 72.93 ± 8.5% | not timed | not timed | 542.25 ± 1.0% | | 0.99 | 1.08 | 7.38 |
| imported/rsc/hard-1k | 27 | 18218.45 ± 1.6% | not timed | not timed | 19477.18 ± 0.5% | 59.45 ± 3.3% | not timed | not timed | 17678.50 ± 4.4% | | 1.03 | 0.94 | 306.43 |
| imported/rsc/hard-32k | 27 | 608708.70 ± 0.6% | not timed | not timed | 635379.75 ± 1.2% | 47.91 ± 0.7% | not timed | not timed | 587780.31 ± 7.8% | | 1.04 | 0.96 | 12704.47 |
| imported/rsc/hard-1mb | 51 | 11095361.05 ± 6.7% | not timed | not timed | 10359392.79 ± 2.4% | 47.96 ± 4.2% | not timed | not timed | 10805068.21 ± 1.4% | | 1.03 | 1.07 | 231334.43 |
| imported/rsc/reallyhard0-32 | 58 | 359.23 ± 4.7% | not timed | not timed | 327.71 ± 1.4% | 73.07 ± 27.9% | not timed | not timed | 357.15 ± 4.0% | | 1.01 | 1.10 | 4.92 |
| imported/rsc/reallyhard0-1k | 27 | 685.18 ± 1.0% | not timed | not timed | 681.28 ± 1.1% | 59.50 ± 2.3% | not timed | not timed | 680.33 ± 1.2% | | 1.01 | 1.01 | 11.52 |
| imported/rsc/reallyhard0-32k | 27 | 693.82 ± 7.1% | not timed | not timed | 697.14 ± 1.8% | 47.82 ± 1.2% | not timed | not timed | 696.03 ± 9.8% | | 1.00 | 1.00 | 14.51 |
| imported/rsc/reallyhard0-1mb | 51 | 696.75 ± 0.5% | not timed | not timed | 696.55 ± 0.8% | 47.60 ± 1.2% | not timed | not timed | 696.75 ± 2.8% | | 1.00 | 1.00 | 14.64 |
| imported/rsc/reallyreallyhard0-32 | 47 | 425.82 ± 1.7% | not timed | not timed | 264.02 ± 0.8% | 91.07 ± 8.3% | not timed | not timed | 420.68 ± 4.5% | | 1.01 | 1.61 | 4.68 |
| imported/rsc/reallyreallyhard0-1k | 16 | 11016.07 ± 1.1% | not timed | not timed | 10551.95 ± 24.5% | 47.82 ± 33.6% | not timed | not timed | 11150.08 ± 4.1% | | 0.99 | 1.04 | 230.38 |
| imported/rsc/reallyreallyhard0-32k | 16 | 72154.25 ± 2.7% | not timed | not timed | 56134.64 ± 1.5% | 37.91 ± 5.3% | not timed | not timed | 71891.27 ± 0.9% | | 1.00 | 1.29 | 1903.21 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 93226.97 ± 2.1% | not timed | not timed | 65036.99 ± 3.7% | 38.89 ± 0.8% | not timed | not timed | 93867.41 ± 1.2% | | 0.99 | 1.43 | 2397.33 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 403.57 ± 7.3% | not timed | not timed | 269.54 ± 2.1% | 91.00 ± 11.8% | not timed | not timed | 398.62 ± 25.1% | | 1.01 | 1.50 | 4.43 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 9046.49 ± 1.5% | not timed | not timed | 10445.80 ± 0.7% | 48.29 ± 6.6% | not timed | not timed | 8961.43 ± 1.3% | | 1.01 | 0.87 | 187.33 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 69535.51 ± 1.4% | not timed | not timed | 54476.94 ± 12.1% | 38.81 ± 7.8% | not timed | not timed | 69235.66 ± 7.2% | | 1.00 | 1.28 | 1791.83 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 81299.80 ± 0.9% | not timed | not timed | 64696.93 ± 5.2% | 39.05 ± 3.7% | not timed | not timed | 81554.58 ± 1.4% | | 1.00 | 1.26 | 2081.76 |
| imported/sherlock/name-sherlock | 776 | 62179.86 ± 21.6% | not timed | not timed | 49533.15 ± 3.2% | 15559.78 ± 11.4% | not timed | not timed | 62047.72 ± 2.2% | | 1.00 | 1.26 | 4.00 |
| imported/sherlock/name-holmes | 2766 | 35915.24 ± 4.7% | not timed | not timed | 34474.78 ± 1.3% | 5090.54 ± 0.8% | not timed | not timed | 36240.66 ± 4.1% | | 0.99 | 1.04 | 7.06 |
| imported/sherlock/name-sherlock-holmes | 1365 | 63025.68 ± 8.0% | not timed | not timed | 49554.02 ± 16.9% | 13540.53 ± 8.9% | not timed | not timed | 63193.99 ± 7.3% | | 1.00 | 1.27 | 4.65 |
| imported/sherlock/name-sherlock-casei | 816 | 63942.42 ± 0.6% | not timed | not timed | 14168.58 ± 1.0% | 50.36 ± 13.4% | not timed | not timed | 63701.79 ± 9.9% | | 1.00 | 4.51 | 1269.65 |
| imported/sherlock/name-holmes-casei | 2802 | 30856.37 ± 5.3% | not timed | not timed | 8806.60 ± 2.2% | 63.96 ± 2.1% | not timed | not timed | 30836.86 ± 2.8% | | 1.00 | 3.50 | 482.40 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 50917.09 ± 30.1% | not timed | not timed | 13828.00 ± 5.2% | 51.08 ± 12.0% | not timed | not timed | 51430.22 ± 4.6% | | 0.99 | 3.68 | 996.85 |
| imported/sherlock/name-whitespace | 1461 | 37126.03 ± 3.2% | not timed | not timed | 35458.25 ± 2.4% | 11523.84 ± 13.2% | not timed | not timed | 36846.56 ± 4.4% | | 1.01 | 1.05 | 3.22 |
| imported/sherlock/name-alt1 | 1142 | 42438.83 ± 2.7% | not timed | not timed | 41407.01 ± 3.0% | 6378.31 ± 26.0% | not timed | not timed | 42809.80 ± 5.1% | | 0.99 | 1.02 | 6.65 |
| imported/sherlock/name-alt2 | 3542 | 27887.27 ± 3.3% | not timed | not timed | 12001.95 ± 4.1% | 53.67 ± 2.9% | not timed | not timed | 27680.54 ± 2.6% | | 1.01 | 2.32 | 519.59 |
| imported/sherlock/name-alt3 | 4507 | 17260.89 ± 1.3% | not timed | not timed | 11134.60 ± 7.4% | 16.89 ± 2.0% | not timed | not timed | 17156.32 ± 2.8% | | 1.01 | 1.55 | 1022.10 |
| imported/sherlock/name-alt3-casei | 4593 | 2470.79 ± 11.8% | not timed | not timed | 1644.68 ± 2.4% | 10.62 ± 27.8% | not timed | not timed | 2491.70 ± 9.1% | | 0.99 | 1.50 | 232.55 |
| imported/sherlock/name-alt4 | 3686 | 12426.09 ± 16.7% | not timed | not timed | 8964.30 ± 3.7% | 51.55 ± 14.4% | not timed | not timed | 12547.10 ± 32.3% | | 0.99 | 1.39 | 241.06 |
| imported/sherlock/name-alt4-casei | 4254 | 6970.33 ± 4.9% | not timed | not timed | 5101.12 ± 4.4% | 30.51 ± 35.9% | not timed | not timed | 6907.05 ± 1.5% | | 1.01 | 1.37 | 228.47 |
| imported/sherlock/name-alt5 | 4028 | 22147.81 ± 1.9% | not timed | not timed | 11477.36 ± 2.4% | 37.61 ± 22.9% | not timed | not timed | 22180.04 ± 1.0% | | 1.00 | 1.93 | 588.82 |
| imported/sherlock/name-alt5-casei | 4104 | 9251.14 ± 8.3% | not timed | not timed | 3724.82 ± 1.7% | 23.09 ± 2.8% | not timed | not timed | 9234.66 ± 12.9% | | 1.00 | 2.48 | 400.61 |
| imported/sherlock/no-match-uncommon | 0 | 86052.06 ± 3.4% | not timed | not timed | 85294.58 ± 1.8% | 76159.01 ± 1.7% | not timed | not timed | 86152.79 ± 2.3% | | 1.00 | 1.01 | 1.13 |
| imported/sherlock/no-match-common | 0 | 84619.70 ± 3.0% | not timed | not timed | 83482.14 ± 2.4% | 2329.20 ± 1.7% | not timed | not timed | 84117.34 ± 1.8% | | 1.01 | 1.01 | 36.33 |
| imported/sherlock/no-match-really-common | 0 | 58302.54 ± 2.2% | not timed | not timed | 61357.67 ± 38.9% | 2311.78 ± 1.8% | not timed | not timed | 58493.00 ± 5.3% | | 1.00 | 0.95 | 25.22 |
| imported/sherlock/the-lower | 21654 | 3867.97 ± 4.3% | not timed | not timed | 3841.07 ± 3.5% | 350.34 ± 23.9% | not timed | not timed | 3908.07 ± 5.3% | | 0.99 | 1.01 | 11.04 |
| imported/sherlock/the-upper | 2223 | 25750.52 ± 6.8% | not timed | not timed | 33046.81 ± 18.3% | 4170.32 ± 18.6% | not timed | not timed | 26012.20 ± 14.3% | | 0.99 | 0.78 | 6.17 |
| imported/sherlock/the-casei | 23961 | 3576.89 ± 2.0% | not timed | not timed | 1672.14 ± 18.5% | 58.02 ± 17.8% | not timed | not timed | 3579.70 ± 1.4% | | 1.00 | 2.14 | 61.65 |
| imported/sherlock/everything-greedy | 581881 | 366.45 ± 3.4% | not timed | not timed | 215.34 ± 2.1% | 46.22 ± 42.5% | not timed | not timed | 363.57 ± 4.5% | | 1.01 | 1.70 | 7.93 |
| imported/sherlock/everything-greedy-nl | 594933 | 551.64 ± 5.4% | not timed | not timed | 292.83 ± 3.2% | 51.97 ± 4.3% | not timed | not timed | 555.35 ± 1.9% | | 0.99 | 1.88 | 10.61 |
| imported/sherlock/letters | 447175 | 93.77 ± 32.6% | not timed | not timed | 44.59 ± 37.4% | 7.35 ± 24.4% | not timed | not timed | 97.09 ± 5.6% | | 0.97 | 2.10 | 12.75 |
| imported/sherlock/letters-upper | 14180 | 536.40 ± 5.2% | not timed | not timed | 433.06 ± 28.7% | 42.09 ± 23.0% | not timed | not timed | 531.92 ± 3.9% | | 1.01 | 1.24 | 12.74 |
| imported/sherlock/letters-lower | 432995 | 96.15 ± 2.3% | not timed | not timed | 44.86 ± 0.5% | 8.14 ± 29.4% | not timed | not timed | 96.65 ± 0.9% | | 0.99 | 2.14 | 11.81 |
| imported/sherlock/words | 447639 | 154.16 ± 3.6% | not timed | not timed | 105.34 ± 3.0% | 21.04 ± 4.1% | not timed | not timed | 155.47 ± 3.3% | | 0.99 | 1.46 | 7.33 |
| imported/sherlock/before-holmes | 4073 | 19144.33 ± 1.9% | not timed | not timed | 16481.28 ± 0.7% | 37.03 ± 8.2% | not timed | not timed | 19181.44 ± 2.6% | | 1.00 | 1.16 | 517.01 |
| imported/sherlock/before-after-holmes | 2593 | 19456.63 ± 4.9% | not timed | not timed | 19190.04 ± 5.1% | 37.45 ± 2.1% | not timed | not timed | 19480.22 ± 2.5% | | 1.00 | 1.01 | 519.47 |
| imported/sherlock/holmes-cochar-watson | 150 | 12004.27 ± 1.7% | not timed | not timed | 9772.82 ± 2.2% | 53.18 ± 0.4% | not timed | not timed | 11965.40 ± 4.8% | | 1.00 | 1.23 | 225.72 |
| imported/sherlock/holmes-coword-watson | 14309 | 1515.59 ± 6.7% | not timed | not timed | 1467.34 ± 6.8% | 11.29 ± 15.4% | not timed | not timed | 1485.34 ± 7.1% | | 1.02 | 1.03 | 134.21 |
| imported/sherlock/quotes | 14437 | 1650.29 ± 1.6% | not timed | not timed | 2855.11 ± 3.0% | 52.55 ± 3.8% | not timed | not timed | 1660.08 ± 4.9% | | 0.99 | 0.58 | 31.40 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 715.53 ± 8.1% | not timed | not timed | 39314.52 ± 13.0% | 60.64 ± 17.0% | not timed | not timed | 712.16 ± 18.0% | | 1.00 | 0.0182 | 11.80 |
| imported/sherlock/word-ending-n | 35297 | 560.36 ± 1.4% | not timed | not timed | 472.35 ± 1.2% | 37.51 ± 13.3% | not timed | not timed | 553.72 ± 7.8% | | 1.01 | 1.19 | 14.94 |
| imported/sherlock/repeated-class-negation | 2130 | 23522.58 ± 3.8% | not timed | not timed | 22561.72 ± 3.1% | 15.04 ± 7.8% | not timed | not timed | 23590.62 ± 5.2% | | 1.00 | 1.04 | 1563.59 |
| imported/sherlock/ing-suffix | 20547 | 693.68 ± 4.4% | not timed | not timed | 602.77 ± 3.0% | 43.74 ± 15.7% | not timed | not timed | 688.64 ± 1.6% | | 1.01 | 1.15 | 15.86 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 721.76 ± 2.3% | not timed | not timed | 3647.47 ± 2.2% | 31.78 ± 2.5% | not timed | not timed | 715.38 ± 1.6% | | 1.01 | 0.20 | 22.71 |
| opt/accelerate/whole-line | 239963 | 651.71 ± 1.7% | not timed | not timed | 497.97 ± 1.5% | 118.58 ± 18.6% | not timed | not timed | 654.78 ± 1.7% | | 1.00 | 1.31 | 5.50 |
| opt/accelerate/non-dna | 16745 | 574.53 ± 7.3% | not timed | not timed | 547.72 ± 3.5% | 47.08 ± 35.0% | not timed | not timed | 578.35 ± 1.6% | | 0.99 | 1.05 | 12.20 |
| opt/backtrack/words-english | 40536 | 178.52 ± 2.5% | not timed | not timed | 138.85 ± 2.7% | 29.90 ± 18.7% | not timed | not timed | 178.01 ± 9.0% | | 1.00 | 1.29 | 5.97 |
| opt/fixed-length/too-small-ascii | 0 | 563.44 ± 2.1% | not timed | not timed | 1094.34 ± 7.7% | 162.25 ± 15.9% | not timed | not timed | 556.91 ± 4.7% | | 1.01 | 0.51 | 3.47 |
| opt/fixed-length/too-big-ascii | 0 | 6352.14 ± 1.5% | not timed | not timed | 8819.00 ± 2.7% | 205.99 ± 2.8% | not timed | not timed | 6310.03 ± 1.9% | | 1.01 | 0.72 | 30.84 |
| opt/fixed-length/go33484-1 | 0 | 1214605.31 ± 1.1% | not timed | not timed | 1690761.36 ± 1.6% | 120956.62 ± 4.2% | not timed | not timed | 1236377.37 ± 2.1% | | 0.98 | 0.72 | 10.04 |
| opt/fixed-length/go33484-2 | 0 | 1241116.33 ± 14.3% | not timed | not timed | 1692089.32 ± 13.2% | 43876.71 ± 1.5% | not timed | not timed | 1246619.13 ± 0.3% | | 1.00 | 0.73 | 28.29 |
| opt/fixed-length/go33484-3 | 0 | 2977.49 ± 1.4% | not timed | not timed | 167143.53 ± 1.0% | 1297.89 ± 1.0% | not timed | not timed | 2968.28 ± 1.7% | | 1.00 | 0.0178 | 2.29 |
| opt/literal-alt/one-pattern | 1 | 704.58 ± 2.5% | not timed | not timed | 700.24 ± 4.2% | 0.61 ± 32.9% | not timed | not timed | 710.59 ± 1.5% | | 0.99 | 1.01 | 1162.51 |
| opt/onepass/fn-predicate | 916 | 586.19 ± 4.1% | not timed | not timed | 498.09 ± 6.2% | 279.10 ± 15.0% | not timed | not timed | 586.13 ± 2.8% | | 1.00 | 1.18 | 2.10 |
| opt/onepass/first-three-words-english | 35128 | 235.28 ± 1.6% | not timed | not timed | 280.92 ± 1.6% | 111.57 ± 8.5% | not timed | not timed | 236.81 ± 13.8% | | 0.99 | 0.84 | 2.11 |
| opt/prefilter/literal-english | 1 | 87946.86 ± 1.4% | not timed | not timed | 66891.94 ± 8.5% | 34701.17 ± 1.8% | not timed | not timed | 87926.09 ± 3.2% | | 1.00 | 1.31 | 2.53 |
| opt/prefilter/literal-casei-english | 1 | 68060.87 ± 1.5% | not timed | not timed | 17839.80 ± 5.9% | 51.27 ± 1.4% | not timed | not timed | 67528.60 ± 3.5% | | 1.01 | 3.82 | 1327.52 |
| opt/prefilter/literal-russian | 1 | 87210.11 ± 1.5% | not timed | not timed | 65672.01 ± 1.8% | 4125.94 ± 1.4% | not timed | not timed | 86351.72 ± 1.6% | | 1.01 | 1.33 | 21.14 |
| opt/prefilter/literal-casei-russian | 1 | 36425.25 ± 4.9% | not timed | not timed | 12723.15 ± 9.1% | 54.92 ± 1.9% | not timed | not timed | 35908.50 ± 5.3% | | 1.01 | 2.86 | 663.21 |
| opt/prefilter/rust-functions | 948 | 19644.66 ± 5.7% | not timed | not timed | 15769.09 ± 1.4% | 2385.26 ± 2.9% | not timed | not timed | 19515.19 ± 3.6% | | 1.01 | 1.25 | 8.24 |
| opt/reverse-anchored/word-end | 1 | 54563478.16 ± 2.8% | not timed | not timed | 36960066.59 ± 5.3% | 80.58 ± 4.2% | not timed | not timed | 52290714.20 ± 2.8% | | 1.04 | 1.48 | 677168.54 |
| opt/reverse-inner/holmes | 2593 | 19012.75 ± 3.7% | not timed | not timed | 18815.26 ± 1.3% | 36.40 ± 4.7% | not timed | not timed | 19120.66 ± 0.5% | | 0.99 | 1.01 | 522.34 |
| opt/reverse-inner/email | 47 | 96756.99 ± 6.6% | not timed | not timed | 108706.77 ± 2.2% | 48.08 ± 4.4% | not timed | not timed | 98201.71 ± 8.8% | | 0.99 | 0.89 | 2012.38 |
| opt/reverse-inner/factored-prefix | 3542 | 693.09 ± 1.3% | not timed | not timed | 682.88 ± 1.5% | 19.23 ± 0.5% | not timed | not timed | 694.83 ± 1.6% | | 1.00 | 1.01 | 36.05 |
| opt/reverse-inner/no-quadratic-backward | 0 | 6803.32 ± 4.8% | not timed | not timed | 716.79 ± 1.6% | 121.15 ± 5.7% | not timed | not timed | 6870.91 ± 4.0% | | 0.99 | 9.49 | 56.15 |
| opt/reverse-inner/no-quadratic-forward | 0 | 860.93 ± 7.8% | not timed | not timed | 345.49 ± 4.5% | 40.57 ± 1.7% | not timed | not timed | 870.52 ± 4.4% | | 0.99 | 2.49 | 21.22 |
| opt/reverse-suffix/holmes | 4073 | 20101.83 ± 5.7% | not timed | not timed | 16937.81 ± 6.7% | 37.37 ± 12.5% | not timed | not timed | 19776.91 ± 4.3% | | 1.02 | 1.19 | 537.85 |
| opt/reverse-suffix/no-quadratic | 0 | 6921.61 ± 4.2% | not timed | not timed | 727.78 ± 2.9% | 120.83 ± 7.5% | not timed | not timed | 6903.89 ± 4.2% | | 1.00 | 9.51 | 57.28 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 224.74 ± 10.7% | not timed | not timed | 279.85 ± 2.3% | 24.02 ± 36.0% | not timed | not timed | 223.90 ± 5.1% | | 1.00 | 0.80 | 9.36 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 225.05 ± 36.3% | not timed | not timed | 256.95 ± 14.9% | 24.28 ± 52.8% | not timed | not timed | 225.19 ± 18.7% | | 1.00 | 0.88 | 9.27 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.49 ± 6.0% | not timed | not timed | 0.86 ± 3.8% | 169.83 ± 10.1% | not timed | not timed | 0.50 ± 4.0% | | 0.99 | 0.57 | 0.0029 |
| reported/i1095-word-repetition/ascii-search | 256 | 395.19 ± 2.5% | not timed | not timed | 382.26 ± 2.1% | 163.80 ± 1.1% | not timed | not timed | 399.45 ± 0.6% | | 0.99 | 1.03 | 2.41 |
| reported/i13-subset-regex/original-ascii | 4094 | 15837.03 ± 6.3% | not timed | not timed | 5484.65 ± 5.3% | 15.88 ± 10.4% | not timed | not timed | 15932.86 ± 8.1% | | 0.99 | 2.89 | 997.04 |
| reported/i13-subset-regex/original-unicode | 4094 | 15772.45 ± 4.4% | not timed | not timed | 300.09 ± 4.5% | 15.46 ± 5.1% | not timed | not timed | 15696.33 ± 3.3% | | 1.00 | 52.56 | 1020.10 |
| reported/i13-subset-regex/big-ascii | 1955 | 14123.53 ± 3.6% | not timed | not timed | 79.96 ± 4.9% | 13.42 ± 5.7% | not timed | not timed | 14614.38 ± 3.7% | | 0.97 | 176.63 | 1052.81 |
| reported/i13-subset-regex/big-unicode | 1955 | 14565.41 ± 1.8% | not timed | not timed | 14.49 ± 57.1% | 13.80 ± 3.3% | not timed | not timed | 14596.82 ± 4.0% | | 1.00 | 1005.09 | 1055.43 |
| reported/i13-subset-regex/huge-ascii | 55 | 12544.71 ± 8.9% | not timed | not timed | 12.93 ± 5.6% | 12.02 ± 8.1% | not timed | not timed | 12579.32 ± 3.8% | | 1.00 | 970.25 | 1043.99 |
| reported/i13-subset-regex/huge-unicode | 55 | 12590.93 ± 8.2% | not timed | not timed | 12.79 ± 4.2% | 12.20 ± 5.6% | not timed | not timed | 12539.47 ± 2.8% | | 1.00 | 984.74 | 1032.43 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.59 ± 1.4% | not timed | not timed | 13.01 ± 1.3% | 11.99 ± 2.8% | not timed | not timed | 5.61 ± 2.7% | | 1.00 | 0.43 | 0.47 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.41 ± 2.0% | not timed | not timed | 13.11 ± 1.8% | 11.89 ± 5.4% | not timed | not timed | 7.45 ± 2.1% | | 1.00 | 0.57 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 652.03 ± 2.0% | not timed | not timed | 201.00 ± 1.2% | 9.81 ± 3.9% | not timed | not timed | 655.28 ± 3.5% | | 1.00 | 3.24 | 66.47 |
| reported/i787-keywords/opt-ascii | 5674 | 661.15 ± 1.8% | not timed | not timed | 330.05 ± 2.7% | 16.31 ± 18.8% | not timed | not timed | 659.04 ± 11.3% | | 1.00 | 2.00 | 40.53 |
| slow/quadratic-regex-1x | 100 | 10.34 ± 3.1% | not timed | not timed | 7.52 ± 2.2% | 0.08 ± 4.0% | not timed | not timed | 10.29 ± 2.6% | | 1.00 | 1.37 | 137.04 |
| slow/quadratic-regex-2x | 199 | 4.39 ± 4.4% | not timed | not timed | 3.74 ± 1.0% | 0.02 ± 1.3% | not timed | not timed | 4.33 ± 1.5% | | 1.01 | 1.17 | 224.58 |
| slow/quadratic-haystack-1x | 100 | 38.22 ± 3.6% | not timed | not timed | 16.51 ± 2.3% | 1.36 ± 16.2% | not timed | not timed | 38.13 ± 26.1% | | 1.00 | 2.32 | 28.01 |
| slow/quadratic-haystack-2x | 200 | 30.56 ± 2.8% | not timed | not timed | 7.70 ± 1.9% | 0.73 ± 26.3% | not timed | not timed | 30.37 ± 2.7% | | 1.01 | 3.97 | 41.66 |
| unicode/codepoints/any-one | 1112064 | 495.52 ± 6.3% | not timed | not timed | 353.79 ± 5.6% | 27.25 ± 27.1% | not timed | not timed | 483.93 ± 0.8% | | 1.02 | 1.40 | 18.18 |
| unicode/codepoints/any-all | 4382592 | 330.13 ± 4.3% | not timed | not timed | 266.88 ± 29.2% | 185.14 ± 1.1% | not timed | not timed | 328.68 ± 1.6% | | 1.00 | 1.24 | 1.78 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.57 ± 4.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 697.41 ± 0.9% | not timed | not timed | 693.34 ± 0.7% | 216.20 ± 7.9% | not timed | not timed | 696.68 ± 1.3% | | 1.00 | 1.01 | 3.23 |
| unicode/overlapping-words/ascii | 6156 | 41.92 ± 4.8% | not timed | not timed | 54.58 ± 1.7% | 5.79 ± 4.0% | not timed | not timed | 42.34 ± 6.2% | | 0.99 | 0.77 | 7.24 |
| unicode/overlapping-words/english | 6156 | 2.06 ± 7.2% | not timed | not timed | 5.10 ± 2.4% | 3.65 ± 11.5% | not timed | not timed | 2.08 ± 4.6% | | 0.99 | 0.40 | 0.56 |
| unicode/overlapping-words/russian | 5710 | 1.85 ± 3.9% | not timed | not timed | 4.80 ± 1.8% | 8.93 ± 9.4% | not timed | not timed | 1.81 ± 2.8% | | 1.02 | 0.39 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 167.70 ± 7.9% | not timed | not timed | 102.98 ± 1.5% | 19.96 ± 14.6% | not timed | not timed | 170.29 ± 16.4% | | 0.98 | 1.63 | 8.40 |
| unicode/word/boundary-long-english | 3466 | 698.58 ± 3.3% | not timed | not timed | 678.20 ± 1.7% | 48.53 ± 1.8% | not timed | not timed | 689.72 ± 3.8% | | 1.01 | 1.03 | 14.39 |
| unicode/word/around-holmes-english | 27 | 78079.64 ± 16.5% | not timed | not timed | 60351.68 ± 50.1% | 33.25 ± 40.2% | not timed | not timed | 78537.29 ± 1.9% | | 0.99 | 1.29 | 2348.15 |
| wild/bibleref/long | 874 | 651.03 ± 2.8% | not timed | not timed | 664.03 ± 1.5% | 10.86 ± 0.8% | not timed | not timed | 652.17 ± 1.7% | | 1.00 | 0.98 | 59.92 |
| wild/bibleref/short | 30 | 32.33 ± 7.3% | not timed | not timed | 44.37 ± 1.3% | 21.88 ± 17.6% | not timed | not timed | 32.37 ± 4.5% | | 1.00 | 0.73 | 1.48 |
| wild/bibleref/line | 874 | 671.64 ± 0.4% | not timed | not timed | 325.68 ± 0.4% | 13.03 ± 2.3% | not timed | not timed | 665.13 ± 1.7% | | 1.01 | 2.06 | 51.56 |
| wild/caddy/caddy | 6 | 590.46 ± 3.0% | not timed | not timed | 341.83 ± 6.1% | 102.13 ± 20.2% | not timed | not timed | 595.99 ± 5.3% | | 0.99 | 1.73 | 5.78 |
| wild/dot-star-capture/rust-src-tools | 6 | 2034.85 ± 5.5% | not timed | not timed | 460.42 ± 2.2% | 22.51 ± 8.4% | not timed | not timed | 2032.94 ± 3.0% | | 1.00 | 4.42 | 90.39 |
| wild/ruff/noqa | 84 | 638.59 ± 17.7% | not timed | not timed | 656.32 ± 14.1% | 29.94 ± 5.9% | not timed | not timed | 641.29 ± 7.4% | | 1.00 | 0.97 | 21.33 |
| wild/ruff/unnecessary-coding-comment | 16 | 1195.77 ± 20.3% | not timed | not timed | 842.74 ± 3.0% | 194.11 ± 11.6% | not timed | not timed | 1291.77 ± 1.3% | | 0.93 | 1.42 | 6.16 |
| wild/ruff/string-quote-prefix | 2972 | 1989.45 ± 2.5% | not timed | not timed | 650.80 ± 4.5% | 419.12 ± 28.6% | not timed | not timed | 1983.26 ± 2.5% | | 1.00 | 3.06 | 4.75 |
| wild/ruff/space-around-operator | 1224378 | 297.59 ± 8.2% | not timed | not timed | 270.37 ± 2.7% | 25.46 ± 2.6% | not timed | not timed | 289.54 ± 3.8% | | 1.03 | 1.10 | 11.69 |
| wild/ruff/shebang | 282 | 1379.25 ± 1.1% | not timed | not timed | 510.80 ± 10.2% | 161.58 ± 10.6% | not timed | not timed | 1377.72 ± 17.0% | | 1.00 | 2.70 | 8.54 |
| wild/rustsec-cargo-audit/original-unix | 471 | 28670.87 ± 1.6% | not timed | not timed | 31383.28 ± 3.7% | 11830.52 ± 1.4% | not timed | not timed | 28509.92 ± 3.4% | | 1.01 | 0.91 | 2.42 |
| wild/rustsec-cargo-audit/original-windows | 462 | 26605.12 ± 2.4% | not timed | not timed | 29131.99 ± 5.2% | 11042.71 ± 26.7% | not timed | not timed | 26846.48 ± 7.3% | | 0.99 | 0.91 | 2.41 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 29218.25 ± 2.9% | not timed | not timed | 31169.71 ± 1.6% | 11530.45 ± 27.4% | not timed | not timed | 29127.62 ± 2.8% | | 1.00 | 0.94 | 2.53 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 25164.51 ± 2.5% | not timed | not timed | 31098.24 ± 4.0% | 11796.24 ± 21.4% | not timed | not timed | 25462.34 ± 0.9% | | 0.99 | 0.81 | 2.13 |
| wild/url/search | 234965 | 165.83 ± 7.7% | not timed | not timed | 82.93 ± 4.1% | 3.42 ± 2.4% | not timed | not timed | 169.92 ± 4.8% | | 0.98 | 2.00 | 48.43 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 1.8% | not timed | not timed | 0.01 ± 1.9% | 0.01 ± 22.8% | not timed | not timed | 0.04 ± 3.9% | | 0.99 | 2.90 | 4.26 |
| dictionary/compile/english-15 | 1 | 0.44 ± 10.7% | not timed | not timed | 0.11 ± 3.8% | 0.14 ± 33.0% | not timed | not timed | 0.44 ± 7.2% | | 1.01 | 4.16 | 3.20 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.43 ± 6.0% | not timed | not timed | 0.03 ± 7.2% | 47.81 ± 2.7% | not timed | not timed | 0.43 ± 6.0% | | 1.00 | 13.46 | 0.0089 |
| reported/i1095-word-repetition/ascii-compile | 1 | 58.29 ± 1.9% | not timed | not timed | 18.42 ± 4.3% | 82.70 ± 21.2% | not timed | not timed | 58.81 ± 3.2% | | 0.99 | 3.16 | 0.70 |
| reported/i787-keywords/compile | 1 | 52.24 ± 2.0% | not timed | not timed | 3.07 ± 0.5% | 24.82 ± 7.7% | not timed | not timed | 51.82 ± 2.6% | | 1.01 | 17.02 | 2.11 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 559.88 ± 25.8% | not timed | not timed | 180.51 ± 2.4% | 790.20 ± 6.6% | not timed | not timed | 577.78 ± 9.7% | | 0.97 | 3.10 | 0.71 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 75.29 ± 6.5% | not timed | not timed | 6.95 ± 2.8% | 62.98 ± 3.4% | not timed | not timed | 75.20 ± 2.1% | | 1.00 | 10.83 | 1.20 |
| unicode/compile/one-letter | 53 | 9.86 ± 10.1% | not timed | not timed | 7.52 ± 18.6% | 86.96 ± 26.3% | not timed | not timed | 9.77 ± 8.3% | | 1.01 | 1.31 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.81 ± 12.4% | not timed | not timed | 0.16 ± 1.4% | 82.74 ± 8.1% | not timed | not timed | 1.81 ± 5.0% | | 1.00 | 11.19 | 0.0219 |
| unicode/compile/fifty-letters-ascii | 1 | 286.33 ± 9.5% | not timed | not timed | 80.12 ± 1.7% | 273.75 ± 9.1% | not timed | not timed | 292.50 ± 12.9% | | 0.98 | 3.57 | 1.05 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 642.65 ± 16.9% | not timed | not timed | 59.87 ± 1.0% | 990.84 ± 7.7% | not timed | not timed | 647.17 ± 15.7% | | 0.99 | 10.73 | 0.65 |
| unicode/compile/match-every-line-ascii | 4 | 1049.79 ± 10.2% | not timed | not timed | 212.27 ± 9.6% | 902.87 ± 71.5% | not timed | not timed | 1080.56 ± 18.8% | | 0.97 | 4.95 | 1.16 |
| unicode/compile/negated-class-matches-codepoint | 1 | 528.77 ± 3.0% | not timed | not timed | 64.35 ± 0.7% | 1676.99 ± 16.7% | not timed | not timed | 535.50 ± 5.0% | | 0.99 | 8.22 | 0.32 |
| wild/bibleref/compile | 3 | 8.87 ± 7.0% | not timed | not timed | 3.07 ± 2.2% | 42.98 ± 18.3% | not timed | not timed | 8.98 ± 14.8% | | 0.99 | 2.89 | 0.21 |
| wild/url/compile | 1 | 0.92 ± 15.1% | not timed | not timed | 0.22 ± 2.4% | 0.53 ± 30.4% | not timed | not timed | 0.95 ± 6.5% | | 0.96 | 4.24 | 1.73 |

