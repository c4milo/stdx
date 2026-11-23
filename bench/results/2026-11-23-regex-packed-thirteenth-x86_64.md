# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102092242 |
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
| literal: a word | 217 | 52564.71 ± 1.8% | 1205.08 ± 2.8% | 43.67 ± 9.3% | 51185.18 ± 6.3% | 15890.15 ± 8.9% | 15.47 ± 3.0% | 155.71 ± 5.3% | 53194.15 ± 36.7% | 43.62 | 0.99 | 1.03 | 3.31 |
| literal: a word that is not there | 0 | 77960.97 ± 10.3% | 1230.86 ± 4.6% | 44.70 ± 5.2% | 62906.70 ± 13.6% | 54366.42 ± 2.5% | 15.28 ± 3.4% | 147.35 ± 4.0% | 76823.15 ± 1.4% | 63.34 | 1.01 | 1.24 | 1.43 |
| literal: one of four words | 661 | 18949.78 ± 14.2% | 1195.10 ± 4.9% | 24.96 ± 5.5% | 13587.64 ± 21.5% | 38.19 ± 22.7% | 5.17 ± 5.6% | 13.27 ± 4.8% | 19182.81 ± 8.0% | 15.86 | 0.99 | 1.39 | 496.19 |
| literal: a word in any case | 217 | 48292.56 ± 2.7% | 1212.95 ± 2.5% | 32.23 ± 3.2% | 14186.39 ± 66.6% | 71.54 ± 6.5% | refused | differs | 48541.89 ± 2.3% | 39.81 | 0.99 | 3.40 | 675.07 |
| literal: an href attribute | 33 | 45734.40 ± 2.8% | 1217.12 ± 3.2% | 37.52 ± 3.2% | 44527.77 ± 5.3% | 3471.12 ± 7.2% | 11.08 ± 1.2% | 129.41 ± 2.5% | 45308.06 ± 2.9% | 37.58 | 1.01 | 1.03 | 13.18 |
| literal: a word, second text | 123 | 53669.36 ± 4.0% | 1207.86 ± 2.4% | 43.45 ± 3.7% | 48928.83 ± 2.3% | 14349.40 ± 8.3% | 20.77 ± 1.5% | 130.12 ± 1.2% | 54629.51 ± 3.5% | 44.43 | 0.98 | 1.10 | 3.74 |
| class: two capitalized words | 1331 | 1080.89 ± 21.6% | 1086.24 ± 39.9% | 40.27 ± 4.1% | 672.98 ± 5.6% | 60.16 ± 9.7% | 13.53 ± 1.7% | 104.09 ± 4.1% | 1076.58 ± 4.6% | 1.00 | 1.00 | 1.61 | 17.97 |
| class: a word that ends in ing | 3399 | 1000.76 ± 0.9% | 1002.66 ± 0.9% | 27.42 ± 8.3% | 632.16 ± 35.3% | 45.07 ± 2.0% | 7.88 ± 0.6% | 30.01 ± 0.9% | 1003.06 ± 1.1% | 1.00 | 1.00 | 1.58 | 22.21 |
| class: a word in capitals | 2332 | 1521.90 ± 4.7% | 1078.19 ± 3.0% | 41.78 ± 6.5% | 675.04 ± 3.6% | 64.66 ± 12.3% | 16.28 ± 4.0% | 123.58 ± 3.4% | 1497.76 ± 8.0% | 1.41 | 1.02 | 2.25 | 23.54 |
| class: a number | 8288 | 2527.84 ± 19.4% | 912.63 ± 4.7% | 42.51 ± 3.2% | 2338.94 ± 1.4% | 66.86 ± 21.9% | 0.45 ± 1.2% | 95.35 ± 2.4% | 2510.48 ± 2.2% | 2.77 | 1.01 | 1.08 | 37.81 |
| class: two capitalized words, second text | 5359 | 813.73 ± 4.2% | 810.36 ± 12.5% | 36.91 ± 3.2% | 577.79 ± 2.0% | 50.01 ± 6.8% | 18.01 ± 49.2% | 98.13 ± 26.0% | 807.48 ± 4.0% | 1.00 | 1.01 | 1.41 | 16.27 |
| other: a word between two words | 6104 | 958.86 ± 5.1% | 854.71 ± 5.8% | 35.08 ± 3.0% | 924.10 ± 3.1% | 168.40 ± 3.4% | 10.22 ± 5.0% | 111.40 ± 4.2% | 951.38 ± 4.8% | 1.12 | 1.01 | 1.04 | 5.69 |
| other: a number before a unit, second text | 1481 | 11403.70 ± 2.6% | 1129.10 ± 3.2% | 40.37 ± 2.0% | 10798.16 ± 4.1% | 59.19 ± 12.9% | 18.54 ± 6.5% | 104.60 ± 4.0% | 11530.42 ± 2.8% | 10.10 | 0.99 | 1.06 | 192.65 |
| other: a heading's start tag | 110 | 29568.30 ± 2.7% | 1203.49 ± 1.2% | 40.35 ± 1.7% | 3275.66 ± 1.0% | 2499.03 ± 6.3% | 14.49 ± 1.7% | 150.66 ± 14.8% | 29484.59 ± 3.3% | 24.57 | 1.00 | 9.03 | 11.83 |
| other: a whole word | 217 | 36637.58 ± 0.7% | 1216.37 ± 1.8% | 43.77 ± 17.5% | 35410.28 ± 1.9% | 73.46 ± 9.1% | 14.00 ± 2.6% | 84.32 ± 4.7% | 36464.66 ± 1.4% | 30.12 | 1.00 | 1.03 | 498.76 |
| other: a line's first word, second text | 3716 | 2916.36 ± 5.2% | 991.11 ± 1.9% | 48.11 ± 2.5% | 3452.76 ± 2.1% | 97.00 ± 8.3% | refused | refused | 2918.06 ± 3.3% | 2.94 | 1.00 | 0.84 | 30.07 |
| other: fourteen octets before an x | 87 | 45151.24 ± 3.5% | 339.74 ± 4.4% | 7.98 ± 4.8% | 4864.09 ± 1.2% | 14.33 ± 2.9% | differs | 26.27 ± 4.3% | 45122.01 ± 4.7% | 132.90 | 1.00 | 9.28 | 3149.82 |
| other: a Greek word | 21815 | 585.20 ± 2.9% | 407.93 ± 7.6% | 47.26 ± 5.2% | 359.62 ± 4.0% | 59.14 ± 11.6% | differs | refused | 579.87 ± 1.8% | 1.43 | 1.01 | 1.63 | 9.90 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 35.04 ± 4.3% | 34.90 ± 3.4% | 1.38 ± 4.3% | 24.01 ± 1.9% | 3.56 ± 0.4% | differs | 5.87 ± 4.8% | 34.75 ± 2.9% | 1.00 | 1.01 | 1.46 | 9.83 |
| a UUID | 32895 | 30.80 ± 4.7% | 30.98 ± 24.8% | 1.03 ± 45.7% | 18.82 ± 4.2% | 3.58 ± 7.0% | 0.74 ± 4.8% | 4.79 ± 6.0% | 30.15 ± 3.6% | 0.99 | 1.02 | 1.64 | 8.60 |
| an IPv4 address | 33176 | 48.53 ± 4.9% | 48.73 ± 3.2% | 3.39 ± 16.8% | 36.30 ± 5.0% | 9.54 ± 7.8% | differs | 6.27 ± 6.6% | 48.76 ± 4.0% | 1.00 | 1.00 | 1.34 | 5.09 |
| a date and time | 32954 | 46.14 ± 5.1% | 45.24 ± 3.5% | 2.48 ± 4.0% | 26.26 ± 5.1% | 10.72 ± 6.2% | 1.33 ± 3.6% | 12.33 ± 3.3% | 46.22 ± 3.7% | 1.02 | 1.00 | 1.76 | 4.31 |
| a field path | 32606 | 37.87 ± 4.0% | 38.21 ± 5.3% | 1.67 ± 2.6% | 27.74 ± 2.1% | 4.67 ± 2.1% | differs | 4.21 ± 3.1% | 38.66 ± 4.9% | 0.99 | 0.98 | 1.36 | 8.11 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.54 ± 3.9% | 15.52 ± 4.3% | 15.38 ± 6.1% | 16.41 ± 3.0% | 7.62 ± 6.8% | 1.05 ± 13.9% | none | 14.52 ± 6.3% | 1.00 | 1.07 | 0.95 | 2.04 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 371.80 ± 4.8% | 376.26 ± 3.6% | 438.14 ± 2.7% | 133.64 ± 5.0% | 322.02 ± 28.3% | 880.24 ± 3.3% | 5637.32 ± 6.8% | 372.58 ± 2.4% | 0.99 | 1.00 | 2.78 | 1.15 |
| a UUID | 62 | 246.64 ± 4.7% | 240.08 ± 6.1% | 268.00 ± 11.3% | 73.99 ± 11.0% | 126.44 ± 96.2% | 310.84 ± 7.1% | 7480.51 ± 13.8% | 250.11 ± 5.1% | 1.03 | 0.99 | 3.33 | 1.95 |
| an IPv4 address | 29 | 754.96 ± 5.6% | 760.57 ± 6.5% | 1033.58 ± 6.4% | 116.02 ± 7.0% | 203.23 ± 75.4% | 549.74 ± 18.6% | 12837.92 ± 171.5% | 743.31 ± 74.7% | 0.99 | 1.02 | 6.51 | 3.71 |
| a date and time | 56 | 530.91 ± 5.4% | 531.00 ± 6.2% | 654.35 ± 5.0% | 117.08 ± 2.2% | 217.65 ± 9.5% | 592.91 ± 4.9% | 8232.93 ± 4.0% | 533.82 ± 4.0% | 1.00 | 0.99 | 4.53 | 2.44 |
| a field path | 39 | 364.62 ± 3.0% | 367.44 ± 2.3% | 421.63 ± 2.5% | 126.83 ± 2.6% | 307.24 ± 16.0% | 895.38 ± 4.7% | 7472.88 ± 7.1% | 362.40 ± 3.3% | 0.99 | 1.01 | 2.87 | 1.19 |
| literal: a word | 7 | 1135.61 ± 5.6% | 1232.03 ± 2.0% | 2139.79 ± 2.2% | 790.45 ± 3.1% | 1003.81 ± 7.0% | 1757.54 ± 0.8% | 46721.31 ± 14.8% | 1144.51 ± 6.3% | 0.92 | 0.99 | 1.44 | 1.13 |
| literal: a word that is not there | 8 | 1096.47 ± 2.2% | 1179.64 ± 1.2% | 2000.59 ± 2.9% | 741.48 ± 40.6% | 985.44 ± 81.7% | 1710.36 ± 1.4% | 46357.62 ± 1.6% | 1085.52 ± 2.8% | 0.93 | 1.01 | 1.48 | 1.11 |
| literal: one of four words | 26 | 431.64 ± 1.9% | 676.40 ± 3.0% | 890.01 ± 2.0% | 66.51 ± 3.5% | 387.76 ± 1.2% | 665.99 ± 0.8% | 27345.52 ± 18.7% | 433.45 ± 1.0% | 0.64 | 1.00 | 6.49 | 1.11 |
| literal: a word in any case | 11 | 885.08 ± 0.6% | 947.12 ± 1.2% | 1419.22 ± 2.4% | 22.81 ± 1.0% | 1077.21 ± 4.4% | refused | 39415.73 ± 3.9% | 881.22 ± 0.8% | 0.93 | 1.00 | 38.79 | 0.82 |
| literal: an href attribute | 12 | 586.88 ± 5.6% | 616.02 ± 3.9% | 805.57 ± 1.9% | 61.10 ± 1.6% | 739.68 ± 23.4% | 1469.45 ± 0.8% | 33502.33 ± 1.6% | 589.62 ± 4.1% | 0.95 | 1.00 | 9.61 | 0.79 |
| literal: a word, second text | 10 | 996.05 ± 1.8% | 1094.15 ± 1.1% | 1750.74 ± 1.4% | 657.56 ± 0.6% | 846.83 ± 2.6% | 1506.71 ± 1.0% | 45048.64 ± 1.8% | 1003.19 ± 2.4% | 0.91 | 0.99 | 1.51 | 1.18 |
| class: two capitalized words | 23 | 802.18 ± 6.3% | 863.74 ± 6.3% | 1232.25 ± 4.9% | 159.43 ± 1.7% | 797.68 ± 1.8% | 1438.87 ± 3.2% | 9498.75 ± 3.8% | 799.66 ± 6.3% | 0.93 | 1.00 | 5.03 | 1.01 |
| class: a word that ends in ing | 9 | 986.83 ± 1.7% | 1112.05 ± 2.0% | 1867.17 ± 2.9% | 202.27 ± 2.3% | 1097.83 ± 4.1% | 2219.03 ± 1.8% | 24106.07 ± 1.8% | 992.06 ± 3.2% | 0.89 | 0.99 | 4.88 | 0.90 |
| class: a word in capitals | 16 | 896.87 ± 5.7% | 962.63 ± 3.1% | 1519.71 ± 4.2% | 207.30 ± 38.6% | 1153.40 ± 28.7% | 2016.03 ± 5.9% | 12597.39 ± 4.4% | 904.47 ± 9.2% | 0.93 | 0.99 | 4.33 | 0.78 |
| class: a number | 6 | 1108.23 ± 3.1% | 1235.56 ± 5.9% | 2214.28 ± 8.8% | 58.70 ± 2.6% | 1964.21 ± 16.6% | 3614.15 ± 2.4% | 34942.61 ± 1.0% | 1103.55 ± 1.4% | 0.90 | 1.00 | 18.88 | 0.56 |
| class: two capitalized words, second text | 23 | 799.11 ± 2.6% | 862.80 ± 1.7% | 1229.92 ± 0.2% | 154.84 ± 0.8% | 785.75 ± 1.4% | 1420.24 ± 1.4% | 9463.25 ± 1.4% | 801.39 ± 1.2% | 0.93 | 1.00 | 5.16 | 1.02 |
| other: a word between two words | 13 | 960.66 ± 2.4% | 994.14 ± 2.1% | 1538.31 ± 3.3% | 203.69 ± 1.2% | 764.33 ± 2.0% | 1539.32 ± 2.2% | 23048.78 ± 0.2% | 962.81 ± 1.0% | 0.97 | 1.00 | 4.72 | 1.26 |
| other: a number before a unit, second text | 15 | 674.16 ± 2.1% | 761.18 ± 1.3% | 1028.74 ± 0.7% | 55.42 ± 1.9% | 950.52 ± 3.2% | 1711.85 ± 2.6% | 24214.85 ± 1.3% | 676.15 ± 1.5% | 0.89 | 1.00 | 12.17 | 0.71 |
| other: a heading's start tag | 13 | 614.57 ± 4.0% | 628.12 ± 2.0% | 825.73 ± 3.4% | 58.27 ± 1.8% | 919.88 ± 1.3% | 1621.48 ± 12.9% | 29094.11 ± 1.6% | 610.42 ± 3.3% | 0.98 | 1.01 | 10.55 | 0.67 |
| other: a whole word | 11 | 989.81 ± 2.4% | 1056.62 ± 2.0% | 1688.53 ± 3.4% | 181.00 ± 1.4% | 860.39 ± 23.3% | 1576.88 ± 1.5% | 43177.28 ± 9.7% | 993.73 ± 2.0% | 0.94 | 1.00 | 5.47 | 1.15 |
| other: a line's first word, second text | 17 | 934.26 ± 4.6% | 989.56 ± 2.7% | 1556.60 ± 63.4% | 196.30 ± 6.1% | 886.17 ± 73.9% | refused | refused | 930.88 ± 59.1% | 0.94 | 1.00 | 4.76 | 1.05 |
| other: fourteen octets before an x | 16 | 180.59 ± 3.0% | 255.36 ± 1.6% | 292.64 ± 3.0% | 21.86 ± 3.6% | 668.94 ± 8.3% | 738.98 ± 2.9% | 20731.66 ± 2.3% | 179.85 ± 2.6% | 0.71 | 1.00 | 8.26 | 0.27 |
| other: a Greek word | 8 | 727.01 ± 6.2% | 978.66 ± 51.0% | 1535.12 ± 72.5% | 72.99 ± 15.7% | 2034.29 ± 141.5% | 3368.54 ± 37.5% | refused | 733.34 ± 2.2% | 0.74 | 0.99 | 9.96 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 33359.08 ± 2.1% | not timed | not timed | 42822.68 ± 1.0% | 3456.26 ± 25.4% | not timed | not timed | 33400.36 ± 3.4% | | 1.00 | 0.78 | 9.65 |
| 01-literal/sherlock-casei-en | 522 | 6874.01 ± 6.8% | not timed | not timed | 11256.07 ± 0.7% | 50.07 ± 0.9% | not timed | not timed | 6830.21 ± 7.8% | | 1.01 | 0.61 | 137.30 |
| 01-literal/sherlock-ru | 724 | 34812.89 ± 1.7% | not timed | not timed | 42442.06 ± 7.3% | 2322.83 ± 4.9% | not timed | not timed | 34823.34 ± 3.3% | | 1.00 | 0.82 | 14.99 |
| 01-literal/sherlock-casei-ru | 746 | 9850.99 ± 16.2% | not timed | not timed | 9131.12 ± 54.5% | 54.69 ± 8.8% | not timed | not timed | 10740.67 ± 8.1% | | 0.92 | 1.08 | 180.13 |
| 01-literal/sherlock-zh | 30 | 70083.96 ± 11.5% | not timed | not timed | 57220.75 ± 2.2% | 2048.89 ± 6.6% | not timed | not timed | 70534.83 ± 3.9% | | 0.99 | 1.22 | 34.21 |
| 02-literal-alternate/sherlock-en | 714 | 15131.19 ± 5.6% | not timed | not timed | 13181.58 ± 3.5% | 28.20 ± 19.7% | not timed | not timed | 15131.12 ± 3.8% | | 1.00 | 1.15 | 536.53 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2765.34 ± 2.7% | not timed | not timed | 2889.70 ± 0.7% | 17.39 ± 3.8% | not timed | not timed | 2706.44 ± 1.5% | | 1.02 | 0.96 | 159.01 |
| 02-literal-alternate/sherlock-ru | 899 | 9069.80 ± 1.2% | not timed | not timed | 7218.91 ± 1.8% | 36.85 ± 1.7% | not timed | not timed | 9043.28 ± 23.7% | | 1.00 | 1.26 | 246.13 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2528.71 ± 1.8% | not timed | not timed | 1418.39 ± 3.7% | 15.63 ± 1.9% | not timed | not timed | 2488.71 ± 2.6% | | 1.02 | 1.78 | 161.84 |
| 02-literal-alternate/sherlock-zh | 207 | 22470.73 ± 1.5% | not timed | not timed | 15484.53 ± 2.4% | 52.31 ± 3.5% | not timed | not timed | 21989.19 ± 2.6% | | 1.02 | 1.45 | 429.59 |
| 03-date/ascii | 111817 | 149.72 ± 0.9% | not timed | not timed | 122.22 ± 13.7% | 0.30 ± 11.1% | not timed | not timed | 148.36 ± 3.5% | | 1.01 | 1.22 | 505.01 |
| 04-ruff-noqa/real | 84 | 843.65 ± 6.0% | not timed | not timed | 669.62 ± 2.9% | 29.96 ± 3.3% | not timed | not timed | 838.67 ± 8.0% | | 1.01 | 1.26 | 28.16 |
| 04-ruff-noqa/tweaked | 44 | 781.33 ± 44.8% | not timed | not timed | 665.28 ± 55.6% | 466.49 ± 2.0% | not timed | not timed | 783.16 ± 2.1% | | 1.00 | 1.17 | 1.67 |
| 05-lexer-veryl/single | 124800 | 5.36 ± 1.6% | not timed | not timed | 7.52 ± 2.7% | 0.33 ± 8.7% | not timed | not timed | 5.40 ± 8.7% | | 0.99 | 0.71 | 16.11 |
| 06-cloud-flare-redos/original | 107 | 282.77 ± 9.1% | not timed | not timed | 284.50 ± 2.6% | 38.36 ± 3.8% | not timed | not timed | 285.72 ± 8.8% | | 0.99 | 0.99 | 7.37 |
| 06-cloud-flare-redos/simplified-short | 102 | 212.50 ± 6.8% | not timed | not timed | 299.17 ± 5.1% | 41.05 ± 6.4% | not timed | not timed | 204.47 ± 2.7% | | 1.04 | 0.71 | 5.18 |
| 06-cloud-flare-redos/simplified-long | 10000 | 232.03 ± 2.0% | not timed | not timed | 317.09 ± 2.1% | 44.04 ± 2.3% | not timed | not timed | 226.33 ± 1.5% | | 1.03 | 0.73 | 5.27 |
| 07-unicode-character-data/parse-line | 558784 | 67.04 ± 15.4% | not timed | not timed | 251.69 ± 1.7% | 62.53 ± 14.6% | not timed | not timed | 66.74 ± 0.6% | | 1.00 | 0.27 | 1.07 |
| 08-words/all-english | 56691 | 124.39 ± 3.6% | not timed | not timed | 108.04 ± 3.5% | 19.21 ± 11.3% | not timed | not timed | 128.38 ± 1.9% | | 0.97 | 1.15 | 6.48 |
| 08-words/long-english | 839 | 1159.03 ± 3.5% | not timed | not timed | 701.92 ± 2.9% | 49.61 ± 3.7% | not timed | not timed | 1158.44 ± 34.6% | | 1.00 | 1.65 | 23.36 |
| 09-aws-keys/full | 0 | 692.41 ± 7.8% | not timed | not timed | 709.23 ± 13.0% | 95.89 ± 21.1% | not timed | not timed | 636.97 ± 3.3% | | 1.09 | 0.98 | 7.22 |
| 09-aws-keys/quick | 0 | 697.70 ± 4.4% | not timed | not timed | 1226.70 ± 2.4% | 547.67 ± 14.6% | not timed | not timed | 694.81 ± 0.5% | | 1.00 | 0.57 | 1.27 |
| 10-bounded-repeat/letters-en | 1833 | 696.18 ± 4.1% | not timed | not timed | 726.92 ± 2.0% | 29.47 ± 4.1% | not timed | not timed | 701.03 ± 3.6% | | 0.99 | 0.96 | 23.62 |
| 10-bounded-repeat/letters-ru | 3475 | 437.92 ± 3.6% | not timed | not timed | 629.42 ± 5.6% | 31.54 ± 10.1% | not timed | not timed | 434.49 ± 1.3% | | 1.01 | 0.70 | 13.88 |
| 10-bounded-repeat/context | 53 | 97.72 ± 21.9% | not timed | not timed | 89.91 ± 3.0% | 29.17 ± 26.8% | not timed | not timed | 98.96 ± 76.8% | | 0.99 | 1.09 | 3.35 |
| 10-bounded-repeat/capitals | 11 | 1226.12 ± 6.0% | not timed | not timed | 713.80 ± 6.2% | 52.55 ± 11.2% | not timed | not timed | 1227.35 ± 4.2% | | 1.00 | 1.72 | 23.33 |
| 11-unstructured-to-json/extract | 600 | 36.21 ± 2.0% | not timed | not timed | 104.25 ± 2.0% | 75.44 ± 2.5% | not timed | not timed | 35.83 ± 3.8% | | 1.01 | 0.35 | 0.48 |
| 12-dictionary/single | 1 | 637.89 ± 1.1% | not timed | not timed | 614.32 ± 0.8% | 0.61 ± 1.9% | not timed | not timed | 640.28 ± 0.8% | | 1.00 | 1.04 | 1042.20 |
| 14-quadratic/1x | 100 | 15.90 ± 2.2% | not timed | not timed | 17.01 ± 1.3% | 1.41 ± 3.1% | not timed | not timed | 15.87 ± 5.2% | | 1.00 | 0.93 | 11.25 |
| 14-quadratic/2x | 200 | 9.26 ± 3.0% | not timed | not timed | 7.79 ± 58.9% | 0.76 ± 17.7% | not timed | not timed | 9.45 ± 2.1% | | 0.98 | 1.19 | 12.15 |
| 14-quadratic/10x | 1000 | 2.11 ± 2.5% | not timed | not timed | 1.43 ± 2.3% | 0.17 ± 1.4% | not timed | not timed | 2.10 ± 1.9% | | 1.01 | 1.47 | 12.27 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.47 ± 5.6% | not timed | not timed | 0.55 ± 4.7% | 0.83 ± 4.1% | not timed | not timed | 2.42 ± 5.4% | | 1.02 | 4.48 | 2.96 |
| 04-ruff-noqa/compile-real | 1 | 156.12 ± 3.5% | not timed | not timed | 21.02 ± 4.1% | 214.34 ± 10.6% | not timed | not timed | 155.37 ± 3.0% | | 1.00 | 7.43 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 23.52 ± 3.1% | not timed | not timed | 3.90 ± 6.5% | 10.62 ± 4.0% | not timed | not timed | 23.40 ± 3.7% | | 1.00 | 6.03 | 2.21 |
| 07-unicode-character-data/compile | 1 | 93.41 ± 4.5% | not timed | not timed | 39.92 ± 7.3% | 58.68 ± 17.0% | not timed | not timed | 94.32 ± 4.4% | | 0.99 | 2.34 | 1.59 |
| 09-aws-keys/compile-full | 1 | 64.82 ± 3.7% | not timed | not timed | 12.46 ± 4.6% | 36.54 ± 8.9% | not timed | not timed | 63.89 ± 5.5% | | 1.01 | 5.20 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 311.66 ± 2.4% | not timed | not timed | 79.83 ± 2.8% | 219.82 ± 9.0% | not timed | not timed | 307.57 ± 4.0% | | 1.01 | 3.90 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 23.94 ± 2.7% | not timed | not timed | 17.96 ± 2.3% | 26.54 ± 8.2% | not timed | not timed | 23.38 ± 14.9% | | 1.02 | 1.33 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 134.08 ± 2.9% | not timed | not timed | 12.94 ± 7.7% | 37.88 ± 11.0% | not timed | not timed | 132.21 ± 5.1% | | 1.01 | 10.36 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 143.56 ± 4.5% | not timed | not timed | 62.65 ± 1.7% | 108.02 ± 18.6% | not timed | not timed | 144.08 ± 3.1% | | 1.00 | 2.29 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.45 ± 19.7% | not timed | not timed | 0.09 ± 78.6% | 0.14 ± 7.0% | not timed | not timed | 0.47 ± 11.4% | | 0.96 | 4.81 | 3.15 |

