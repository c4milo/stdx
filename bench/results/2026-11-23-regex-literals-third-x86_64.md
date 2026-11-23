# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243465473 |
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
| literal: a word | 217 | 61843.83 ± 6.8% | 6090.79 ± 43.4% | 44.75 ± 12.7% | 50944.37 ± 70.6% | 16182.09 ± 2.7% | 16.08 ± 1.7% | 159.91 ± 5.3% | 61761.73 ± 1.3% | 10.15 | 1.00 | 1.21 | 3.82 |
| literal: a word that is not there | 0 | 81469.89 ± 6.6% | 6033.72 ± 5.2% | 44.99 ± 1.2% | 62522.57 ± 3.3% | 53819.23 ± 1.5% | 15.66 ± 1.0% | 142.68 ± 1.1% | 81387.97 ± 0.8% | 13.50 | 1.00 | 1.30 | 1.51 |
| literal: one of four words | 661 | 19035.36 ± 61.6% | 2277.34 ± 12.5% | 24.48 ± 1.4% | 14211.36 ± 0.7% | 37.95 ± 1.0% | 4.98 ± 2.4% | 12.82 ± 6.1% | 18409.45 ± 11.5% | 8.36 | 1.03 | 1.34 | 501.55 |
| literal: a word in any case | 217 | 56999.82 ± 47.1% | 2468.78 ± 30.6% | 32.21 ± 112.5% | 13876.80 ± 9.1% | 71.30 ± 2.8% | refused | differs | 57220.97 ± 25.4% | 23.09 | 1.00 | 4.11 | 799.39 |
| literal: an href attribute | 33 | 49913.03 ± 3.5% | 704.94 ± 2.6% | 37.00 ± 7.8% | 44304.08 ± 6.3% | 3447.01 ± 2.3% | 11.28 ± 7.5% | 131.00 ± 23.1% | 50343.59 ± 1.5% | 70.80 | 0.99 | 1.13 | 14.48 |
| literal: a word, second text | 123 | 64007.69 ± 2.2% | 4297.49 ± 2.0% | 43.05 ± 1.3% | 48850.32 ± 2.7% | 14834.74 ± 6.3% | 20.70 ± 1.1% | 128.11 ± 2.3% | 64387.05 ± 3.5% | 14.89 | 0.99 | 1.31 | 4.31 |
| class: two capitalized words | 1331 | 1087.36 ± 2.0% | 702.71 ± 16.3% | 40.72 ± 44.0% | 670.19 ± 0.9% | 59.60 ± 18.0% | 13.76 ± 6.7% | 103.13 ± 3.4% | 1086.53 ± 1.1% | 1.55 | 1.00 | 1.62 | 18.24 |
| class: a word that ends in ing | 3399 | 670.32 ± 1.5% | 667.16 ± 1.4% | 26.84 ± 1.5% | 629.04 ± 1.2% | 44.89 ± 10.1% | 7.77 ± 1.3% | 30.91 ± 2.5% | 673.15 ± 1.3% | 1.00 | 1.00 | 1.07 | 14.93 |
| class: a word in capitals | 2332 | 1524.68 ± 2.0% | 703.08 ± 12.8% | 41.85 ± 27.9% | 657.67 ± 1.4% | 64.46 ± 10.6% | 16.17 ± 37.0% | 131.89 ± 33.9% | 1530.84 ± 4.2% | 2.17 | 1.00 | 2.32 | 23.65 |
| class: a number | 8288 | 2563.18 ± 1.9% | 948.21 ± 1.5% | 42.54 ± 1.5% | 2245.88 ± 1.3% | 55.93 ± 21.1% | 0.45 ± 1.6% | 95.22 ± 2.4% | 2566.69 ± 2.5% | 2.70 | 1.00 | 1.14 | 45.83 |
| class: two capitalized words, second text | 5359 | 586.72 ± 1.7% | 593.76 ± 2.0% | 36.39 ± 1.8% | 557.85 ± 2.2% | 50.54 ± 7.6% | 17.45 ± 2.7% | 94.04 ± 1.7% | 593.66 ± 3.0% | 0.99 | 0.99 | 1.05 | 11.61 |
| other: a word between two words | 6104 | 1061.55 ± 0.5% | 678.21 ± 1.8% | 34.53 ± 1.5% | 955.21 ± 1.6% | 164.64 ± 20.4% | 10.31 ± 1.0% | 111.95 ± 1.2% | 1069.31 ± 1.1% | 1.57 | 0.99 | 1.11 | 6.45 |
| other: a number before a unit, second text | 1481 | 12475.55 ± 3.6% | 1372.30 ± 2.1% | 40.00 ± 2.5% | 10716.13 ± 6.2% | 58.77 ± 10.3% | 18.62 ± 2.5% | 104.38 ± 3.3% | 12335.68 ± 2.8% | 9.09 | 1.01 | 1.16 | 212.29 |
| other: a heading's start tag | 110 | 29986.16 ± 3.5% | 864.07 ± 2.9% | 40.24 ± 1.6% | 3262.23 ± 2.6% | 2526.51 ± 7.7% | 14.13 ± 3.4% | 161.85 ± 5.2% | 30181.76 ± 1.6% | 34.70 | 0.99 | 9.19 | 11.87 |
| other: a whole word | 217 | 38164.44 ± 141.0% | 700.49 ± 46.3% | 43.46 ± 0.5% | 35456.06 ± 1.1% | 73.60 ± 1.3% | 13.73 ± 16.1% | 83.14 ± 69.1% | 37987.32 ± 16.5% | 54.48 | 1.00 | 1.08 | 518.54 |
| other: a line's first word, second text | 3716 | 3296.51 ± 5.2% | 682.36 ± 1.3% | 48.18 ± 0.8% | 3404.83 ± 1.5% | 100.51 ± 3.0% | refused | refused | 3300.36 ± 2.8% | 4.83 | 1.00 | 0.97 | 32.80 |
| other: fourteen octets before an x | 87 | 49576.46 ± 17.8% | 340.63 ± 42.8% | 9.00 ± 19.0% | 4741.40 ± 1.2% | 13.94 ± 1.9% | differs | 24.47 ± 1.6% | 48836.69 ± 3.3% | 145.54 | 1.02 | 10.46 | 3555.61 |
| other: a Greek word | 21815 | 584.11 ± 1.7% | 460.47 ± 0.8% | 47.67 ± 1.9% | 344.23 ± 1.9% | 78.29 ± 21.6% | differs | refused | 577.40 ± 53.9% | 1.27 | 1.01 | 1.70 | 7.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.69 ± 19.0% | 25.93 ± 2.4% | 1.46 ± 2.6% | 22.51 ± 0.9% | 3.53 ± 5.5% | differs | 5.58 ± 7.3% | 25.80 ± 1.9% | 0.99 | 1.00 | 1.14 | 7.28 |
| a UUID | 32895 | 28.12 ± 1.8% | 28.13 ± 1.4% | 0.98 ± 1.9% | 17.80 ± 2.1% | 3.50 ± 12.3% | 0.71 ± 32.6% | 4.52 ± 2.3% | 28.14 ± 1.2% | 1.00 | 1.00 | 1.58 | 8.02 |
| an IPv4 address | 33176 | 42.30 ± 6.0% | 40.57 ± 55.6% | 3.08 ± 5.9% | 34.05 ± 1.8% | 9.02 ± 2.6% | differs | 5.80 ± 1.8% | 43.22 ± 1.5% | 1.04 | 0.98 | 1.24 | 4.69 |
| a date and time | 32954 | 40.64 ± 8.3% | 41.06 ± 3.5% | 2.34 ± 50.0% | 25.66 ± 0.7% | 10.63 ± 2.6% | 1.27 ± 1.8% | 11.20 ± 2.8% | 40.07 ± 12.7% | 0.99 | 1.01 | 1.58 | 3.82 |
| a field path | 32606 | 29.01 ± 33.8% | 28.56 ± 2.6% | 1.64 ± 2.5% | 26.87 ± 14.8% | 4.60 ± 68.6% | differs | 3.90 ± 14.2% | 29.07 ± 66.2% | 1.02 | 1.00 | 1.08 | 6.30 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.18 ± 5.3% | 15.20 ± 4.7% | 15.22 ± 7.6% | 16.82 ± 16.6% | 7.36 ± 7.8% | 1.03 ± 59.9% | none | 15.13 ± 80.9% | 1.00 | 1.00 | 0.90 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 366.95 ± 14.1% | 371.38 ± 2.5% | 426.92 ± 4.7% | 129.42 ± 33.7% | 319.79 ± 9.5% | 865.25 ± 4.6% | 5763.83 ± 27.9% | 366.85 ± 1.8% | 0.99 | 1.00 | 2.84 | 1.15 |
| a UUID | 62 | 238.03 ± 2.2% | 239.57 ± 2.0% | 262.23 ± 12.6% | 73.63 ± 1.1% | 156.67 ± 1.9% | 310.49 ± 2.4% | 6949.68 ± 2.1% | 238.48 ± 0.6% | 0.99 | 1.00 | 3.23 | 1.52 |
| an IPv4 address | 29 | 710.69 ± 2.2% | 723.39 ± 3.0% | 974.12 ± 1.8% | 118.89 ± 3.0% | 203.83 ± 3.2% | 553.52 ± 1.1% | 12662.04 ± 1.4% | 710.24 ± 2.1% | 0.98 | 1.00 | 5.98 | 3.49 |
| a date and time | 56 | 510.07 ± 2.2% | 516.01 ± 2.3% | 622.86 ± 1.8% | 114.81 ± 1.3% | 220.20 ± 16.4% | 571.36 ± 0.8% | 7252.15 ± 1.2% | 509.78 ± 2.0% | 0.99 | 1.00 | 4.44 | 2.32 |
| a field path | 39 | 366.58 ± 0.7% | 370.39 ± 1.5% | 429.69 ± 1.0% | 124.65 ± 5.1% | 306.00 ± 12.2% | 886.93 ± 2.0% | 7333.65 ± 2.0% | 368.19 ± 2.4% | 0.99 | 1.00 | 2.94 | 1.20 |
| literal: a word | 7 | 1101.57 ± 1.5% | 1204.06 ± 0.9% | 2033.02 ± 1.7% | 827.51 ± 2.2% | 1015.92 ± 2.1% | 1742.85 ± 6.5% | 47178.37 ± 21.5% | 1095.16 ± 56.5% | 0.91 | 1.01 | 1.33 | 1.08 |
| literal: a word that is not there | 8 | 1060.40 ± 19.6% | 1165.59 ± 1.9% | 1919.60 ± 8.2% | 772.75 ± 8.5% | 965.85 ± 14.4% | 1711.53 ± 3.2% | 46307.69 ± 1.2% | 1054.76 ± 3.4% | 0.91 | 1.01 | 1.37 | 1.10 |
| literal: one of four words | 26 | 406.82 ± 0.6% | 638.08 ± 0.6% | 820.10 ± 1.6% | 65.59 ± 3.1% | 379.68 ± 1.8% | 650.28 ± 4.6% | 23304.33 ± 8.1% | 405.83 ± 0.9% | 0.64 | 1.00 | 6.20 | 1.07 |
| literal: a word in any case | 11 | 757.07 ± 2.8% | 813.26 ± 5.6% | 1125.06 ± 35.9% | 22.40 ± 15.1% | 1055.15 ± 21.3% | refused | 36575.51 ± 4.0% | 755.82 ± 1.8% | 0.93 | 1.00 | 33.80 | 0.72 |
| literal: an href attribute | 12 | 569.82 ± 6.5% | 599.56 ± 55.1% | 769.39 ± 1.0% | 59.52 ± 0.9% | 732.56 ± 13.3% | 1455.88 ± 1.4% | 33444.14 ± 2.9% | 568.89 ± 1.2% | 0.95 | 1.00 | 9.57 | 0.78 |
| literal: a word, second text | 10 | 960.68 ± 10.4% | 1052.32 ± 3.7% | 1645.75 ± 4.4% | 685.74 ± 4.7% | 850.40 ± 17.4% | 1516.07 ± 3.4% | 43874.10 ± 4.1% | 953.06 ± 5.0% | 0.91 | 1.01 | 1.40 | 1.13 |
| class: two capitalized words | 23 | 788.56 ± 4.9% | 849.23 ± 2.0% | 1184.51 ± 6.1% | 155.14 ± 18.6% | 792.10 ± 59.2% | 1404.16 ± 4.6% | 8908.12 ± 1.3% | 786.15 ± 1.8% | 0.93 | 1.00 | 5.08 | 1.00 |
| class: a word that ends in ing | 9 | 971.98 ± 12.0% | 1128.79 ± 3.7% | 1856.65 ± 2.1% | 197.69 ± 2.4% | 1099.59 ± 3.1% | 2181.06 ± 0.7% | 24437.09 ± 1.1% | 970.06 ± 3.6% | 0.86 | 1.00 | 4.92 | 0.88 |
| class: a word in capitals | 16 | 873.45 ± 1.3% | 946.32 ± 4.2% | 1472.88 ± 3.3% | 200.28 ± 1.5% | 1156.46 ± 2.8% | 1971.38 ± 1.7% | 12033.71 ± 1.2% | 882.04 ± 1.8% | 0.92 | 0.99 | 4.36 | 0.76 |
| class: a number | 6 | 1121.66 ± 6.5% | 1206.97 ± 7.6% | 2171.92 ± 7.9% | 58.21 ± 6.7% | 2121.53 ± 4.3% | 3570.44 ± 4.4% | 35089.30 ± 3.3% | 1095.28 ± 5.4% | 0.93 | 1.02 | 19.27 | 0.53 |
| class: two capitalized words, second text | 23 | 783.03 ± 2.7% | 860.76 ± 4.2% | 1207.69 ± 2.6% | 155.26 ± 4.6% | 799.40 ± 8.2% | 1408.62 ± 2.7% | 9063.84 ± 5.3% | 791.32 ± 6.1% | 0.91 | 0.99 | 5.04 | 0.98 |
| other: a word between two words | 13 | 948.68 ± 1.3% | 997.21 ± 8.6% | 1522.99 ± 4.1% | 202.17 ± 2.5% | 732.35 ± 10.5% | 1520.21 ± 3.2% | 23317.43 ± 19.4% | 946.75 ± 1.9% | 0.95 | 1.00 | 4.69 | 1.30 |
| other: a number before a unit, second text | 15 | 668.82 ± 2.5% | 768.67 ± 1.3% | 1043.38 ± 0.3% | 54.91 ± 1.9% | 945.35 ± 8.9% | 1674.16 ± 3.3% | 22847.28 ± 1.6% | 673.23 ± 2.8% | 0.87 | 0.99 | 12.18 | 0.71 |
| other: a heading's start tag | 13 | 595.50 ± 1.6% | 625.18 ± 1.8% | 798.95 ± 1.4% | 58.07 ± 1.3% | 930.94 ± 3.0% | 1582.62 ± 3.2% | 28356.40 ± 1.6% | 599.84 ± 2.2% | 0.95 | 0.99 | 10.25 | 0.64 |
| other: a whole word | 11 | 966.42 ± 9.1% | 1029.23 ± 68.3% | 1583.95 ± 8.2% | 182.83 ± 1.2% | 900.20 ± 16.4% | 1576.55 ± 1.0% | 41746.87 ± 2.6% | 964.48 ± 4.0% | 0.94 | 1.00 | 5.29 | 1.07 |
| other: a line's first word, second text | 17 | 915.53 ± 4.3% | 1000.85 ± 1.1% | 1552.66 ± 2.2% | 190.11 ± 20.1% | 1050.34 ± 9.4% | refused | refused | 921.04 ± 1.8% | 0.91 | 0.99 | 4.82 | 0.87 |
| other: fourteen octets before an x | 16 | 173.48 ± 2.2% | 249.37 ± 2.7% | 280.07 ± 35.3% | 21.99 ± 1.8% | 680.85 ± 7.7% | 735.22 ± 1.5% | 20677.02 ± 0.8% | 174.19 ± 0.9% | 0.70 | 1.00 | 7.89 | 0.25 |
| other: a Greek word | 8 | 719.00 ± 2.8% | 972.01 ± 2.4% | 1527.29 ± 1.5% | 72.70 ± 1.8% | 2072.48 ± 4.2% | 3366.49 ± 0.9% | refused | 719.71 ± 2.2% | 0.74 | 1.00 | 9.89 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 44672.95 ± 3.3% | not timed | not timed | 43733.36 ± 4.0% | 3847.35 ± 18.9% | not timed | not timed | 44636.10 ± 1.8% | | 1.00 | 1.02 | 11.61 |
| 01-literal/sherlock-casei-en | 522 | 14531.97 ± 1.2% | not timed | not timed | 11266.75 ± 0.6% | 50.28 ± 2.0% | not timed | not timed | 14442.30 ± 2.0% | | 1.01 | 1.29 | 289.00 |
| 01-literal/sherlock-ru | 724 | 44295.98 ± 49.6% | not timed | not timed | 41317.09 ± 47.7% | 2340.36 ± 81.3% | not timed | not timed | 44752.84 ± 53.3% | | 0.99 | 1.07 | 18.93 |
| 01-literal/sherlock-casei-ru | 746 | 14670.75 ± 1.6% | not timed | not timed | 9154.59 ± 4.1% | 54.94 ± 34.6% | not timed | not timed | 14626.06 ± 0.9% | | 1.00 | 1.60 | 267.06 |
| 01-literal/sherlock-zh | 30 | 76398.11 ± 11.9% | not timed | not timed | 57163.06 ± 2.0% | 2058.48 ± 1.5% | not timed | not timed | 76686.59 ± 1.1% | | 1.00 | 1.34 | 37.11 |
| 02-literal-alternate/sherlock-en | 714 | 16036.11 ± 49.8% | not timed | not timed | 13072.45 ± 2.0% | 28.20 ± 12.6% | not timed | not timed | 15945.86 ± 24.5% | | 1.01 | 1.23 | 568.61 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2898.67 ± 4.2% | not timed | not timed | 2876.50 ± 1.4% | 17.58 ± 5.8% | not timed | not timed | 2769.74 ± 4.1% | | 1.05 | 1.01 | 164.86 |
| 02-literal-alternate/sherlock-ru | 899 | 12242.46 ± 3.7% | not timed | not timed | 7297.07 ± 1.3% | 35.92 ± 2.6% | not timed | not timed | 12145.60 ± 15.7% | | 1.01 | 1.68 | 340.82 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2675.75 ± 2.2% | not timed | not timed | 1383.33 ± 1.1% | 15.53 ± 3.3% | not timed | not timed | 2675.15 ± 2.1% | | 1.00 | 1.93 | 172.29 |
| 02-literal-alternate/sherlock-zh | 207 | 23237.99 ± 1.0% | not timed | not timed | 15380.87 ± 1.3% | 51.77 ± 1.1% | not timed | not timed | 23178.01 ± 3.1% | | 1.00 | 1.51 | 448.85 |
| 03-date/ascii | 111817 | 147.47 ± 1.5% | not timed | not timed | 118.10 ± 1.5% | 0.30 ± 2.7% | not timed | not timed | 149.43 ± 11.2% | | 0.99 | 1.25 | 495.87 |
| 04-ruff-noqa/real | 84 | 641.58 ± 1.7% | not timed | not timed | 654.94 ± 14.3% | 29.74 ± 1.7% | not timed | not timed | 613.95 ± 1.6% | | 1.05 | 0.98 | 21.57 |
| 04-ruff-noqa/tweaked | 44 | 784.80 ± 1.1% | not timed | not timed | 659.87 ± 1.3% | 473.60 ± 1.0% | not timed | not timed | 782.95 ± 6.3% | | 1.00 | 1.19 | 1.66 |
| 05-lexer-veryl/single | 124800 | 7.24 ± 12.3% | not timed | not timed | 7.59 ± 2.6% | 0.35 ± 20.0% | not timed | not timed | 6.84 ± 9.8% | | 1.06 | 0.95 | 20.93 |
| 06-cloud-flare-redos/original | 107 | 518.94 ± 0.8% | not timed | not timed | 278.18 ± 7.0% | 35.60 ± 12.4% | not timed | not timed | 511.05 ± 41.0% | | 1.02 | 1.87 | 14.58 |
| 06-cloud-flare-redos/simplified-short | 102 | 519.38 ± 1.3% | not timed | not timed | 289.77 ± 2.1% | 40.49 ± 29.0% | not timed | not timed | 522.97 ± 33.9% | | 0.99 | 1.79 | 12.83 |
| 06-cloud-flare-redos/simplified-long | 10000 | 631.40 ± 0.9% | not timed | not timed | 312.99 ± 0.3% | 44.51 ± 0.6% | not timed | not timed | 632.65 ± 0.8% | | 1.00 | 2.02 | 14.18 |
| 07-unicode-character-data/parse-line | 558784 | 311.09 ± 6.8% | not timed | not timed | 248.21 ± 10.1% | 62.01 ± 30.4% | not timed | not timed | 320.74 ± 5.8% | | 0.97 | 1.25 | 5.02 |
| 08-words/all-english | 56691 | 129.54 ± 2.4% | not timed | not timed | 104.10 ± 2.4% | 17.99 ± 2.2% | not timed | not timed | 131.18 ± 2.6% | | 0.99 | 1.24 | 7.20 |
| 08-words/long-english | 839 | 698.29 ± 0.9% | not timed | not timed | 672.49 ± 2.3% | 47.16 ± 30.1% | not timed | not timed | 700.39 ± 0.9% | | 1.00 | 1.04 | 14.81 |
| 09-aws-keys/full | 0 | 648.84 ± 2.0% | not timed | not timed | 652.83 ± 11.2% | 93.75 ± 5.9% | not timed | not timed | 654.15 ± 2.4% | | 0.99 | 0.99 | 6.92 |
| 09-aws-keys/quick | 0 | 1474.12 ± 9.1% | not timed | not timed | 1211.80 ± 0.4% | 538.63 ± 12.9% | not timed | not timed | 1473.08 ± 1.6% | | 1.00 | 1.22 | 2.74 |
| 10-bounded-repeat/letters-en | 1833 | 817.27 ± 2.3% | not timed | not timed | 721.36 ± 1.3% | 29.07 ± 2.0% | not timed | not timed | 817.02 ± 1.6% | | 1.00 | 1.13 | 28.12 |
| 10-bounded-repeat/letters-ru | 3475 | 690.04 ± 58.4% | not timed | not timed | 614.43 ± 9.5% | 28.55 ± 17.9% | not timed | not timed | 687.58 ± 8.0% | | 1.00 | 1.12 | 24.17 |
| 10-bounded-repeat/context | 53 | 106.97 ± 10.5% | not timed | not timed | 88.38 ± 7.7% | 28.64 ± 3.9% | not timed | not timed | 106.99 ± 2.6% | | 1.00 | 1.21 | 3.73 |
| 10-bounded-repeat/capitals | 11 | 738.35 ± 7.3% | not timed | not timed | 698.69 ± 0.6% | 51.51 ± 2.7% | not timed | not timed | 735.69 ± 8.1% | | 1.00 | 1.06 | 14.33 |
| 11-unstructured-to-json/extract | 600 | 105.50 ± 1.5% | not timed | not timed | 101.48 ± 1.2% | 74.33 ± 35.7% | not timed | not timed | 105.19 ± 5.6% | | 1.00 | 1.04 | 1.42 |
| 12-dictionary/single | 1 | 628.30 ± 1.7% | not timed | not timed | 608.11 ± 0.6% | 0.63 ± 1.7% | not timed | not timed | 631.42 ± 1.0% | | 1.00 | 1.03 | 997.31 |
| 14-quadratic/1x | 100 | 39.05 ± 8.1% | not timed | not timed | 16.73 ± 1.0% | 1.41 ± 1.8% | not timed | not timed | 38.98 ± 0.7% | | 1.00 | 2.33 | 27.69 |
| 14-quadratic/2x | 200 | 31.05 ± 1.4% | not timed | not timed | 7.84 ± 2.9% | 0.78 ± 15.6% | not timed | not timed | 31.11 ± 1.8% | | 1.00 | 3.96 | 39.83 |
| 14-quadratic/10x | 1000 | 10.60 ± 2.0% | not timed | not timed | 1.43 ± 1.4% | 0.17 ± 6.0% | not timed | not timed | 10.54 ± 0.8% | | 1.01 | 7.40 | 62.86 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.98 ± 1.4% | not timed | not timed | 0.51 ± 5.6% | 0.82 ± 3.2% | not timed | not timed | 2.00 ± 2.8% | | 0.99 | 3.85 | 2.42 |
| 04-ruff-noqa/compile-real | 1 | 155.63 ± 2.0% | not timed | not timed | 20.23 ± 3.2% | 218.67 ± 2.8% | not timed | not timed | 154.53 ± 1.9% | | 1.01 | 7.69 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 21.86 ± 3.2% | not timed | not timed | 3.77 ± 1.6% | 10.56 ± 70.7% | not timed | not timed | 21.75 ± 24.5% | | 1.00 | 5.80 | 2.07 |
| 07-unicode-character-data/compile | 1 | 85.89 ± 5.4% | not timed | not timed | 37.81 ± 6.1% | 59.04 ± 10.8% | not timed | not timed | 86.22 ± 3.4% | | 1.00 | 2.27 | 1.45 |
| 09-aws-keys/compile-full | 1 | 59.06 ± 2.1% | not timed | not timed | 12.08 ± 4.2% | 35.36 ± 6.5% | not timed | not timed | 58.21 ± 14.9% | | 1.01 | 4.89 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 285.76 ± 5.9% | not timed | not timed | 74.38 ± 31.0% | 205.52 ± 42.9% | not timed | not timed | 288.94 ± 1.4% | | 0.99 | 3.84 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 21.43 ± 2.0% | not timed | not timed | 16.80 ± 2.0% | 25.96 ± 1.7% | not timed | not timed | 21.42 ± 22.1% | | 1.00 | 1.28 | 0.83 |
| 10-bounded-repeat/compile-capitals | 1 | 126.34 ± 2.3% | not timed | not timed | 12.40 ± 8.3% | 37.48 ± 4.4% | not timed | not timed | 125.24 ± 1.7% | | 1.01 | 10.18 | 3.37 |
| 11-unstructured-to-json/compile | 1 | 134.16 ± 2.3% | not timed | not timed | 61.89 ± 3.7% | 108.64 ± 43.6% | not timed | not timed | 133.22 ± 46.5% | | 1.01 | 2.17 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.44 ± 1.1% | not timed | not timed | 0.09 ± 1.1% | 0.13 ± 45.2% | not timed | not timed | 0.43 ± 9.2% | | 1.02 | 4.71 | 3.43 |

