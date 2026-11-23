# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148051066 |
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
| literal: a word | 217 | 40771.80 ± 6.1% | 1033.66 ± 0.8% | 30.03 ± 0.4% | 38695.19 ± 0.2% | 11991.87 ± 3.0% | 12.73 ± 1.8% | 104.12 ± 5.8% | 40792.37 ± 5.2% | 39.44 | 1.00 | 1.05 | 3.40 |
| literal: a word that is not there | 0 | 57174.02 ± 0.3% | 1044.08 ± 0.1% | 30.06 ± 0.5% | 45394.33 ± 0.8% | 43613.77 ± 2.7% | 12.61 ± 0.2% | 97.17 ± 0.2% | 57197.27 ± 1.1% | 54.76 | 1.00 | 1.26 | 1.31 |
| literal: one of four words | 661 | 14144.34 ± 1.0% | 1014.55 ± 0.2% | 16.85 ± 0.6% | 11131.19 ± 0.2% | 24.92 ± 0.2% | 4.46 ± 1.2% | 8.23 ± 1.8% | 14126.93 ± 0.6% | 13.94 | 1.00 | 1.27 | 567.53 |
| literal: a word in any case | 217 | 36591.99 ± 0.3% | 1032.81 ± 0.3% | 22.86 ± 0.7% | 11337.05 ± 0.2% | 47.17 ± 0.7% | refused | differs | 36462.01 ± 0.3% | 35.43 | 1.00 | 3.23 | 775.79 |
| literal: an href attribute | 33 | 35285.74 ± 0.4% | 1039.64 ± 0.3% | 29.09 ± 2.0% | 34727.10 ± 0.3% | 3018.21 ± 4.5% | 9.56 ± 0.2% | 91.20 ± 0.5% | 35215.17 ± 0.2% | 33.94 | 1.00 | 1.02 | 11.69 |
| literal: a word, second text | 123 | 44227.77 ± 4.3% | 1034.79 ± 0.0% | 29.54 ± 0.3% | 39215.32 ± 0.4% | 11032.07 ± 8.2% | 14.45 ± 0.2% | 87.64 ± 0.1% | 44281.83 ± 1.3% | 42.74 | 1.00 | 1.13 | 4.01 |
| class: two capitalized words | 1331 | 919.19 ± 0.3% | 963.28 ± 0.1% | 28.16 ± 0.4% | 576.05 ± 0.5% | 44.41 ± 0.9% | 10.88 ± 0.2% | 79.93 ± 0.8% | 919.14 ± 0.3% | 0.95 | 1.00 | 1.60 | 20.70 |
| class: a word that ends in ing | 3399 | 886.71 ± 0.1% | 887.27 ± 0.2% | 19.73 ± 0.6% | 540.35 ± 1.0% | 32.81 ± 3.8% | 6.19 ± 0.1% | 20.30 ± 9.2% | 885.26 ± 1.2% | 1.00 | 1.00 | 1.64 | 27.02 |
| class: a word in capitals | 2332 | 1159.13 ± 0.2% | 941.63 ± 0.5% | 29.59 ± 0.7% | 563.54 ± 0.9% | 47.94 ± 1.1% | 12.33 ± 0.1% | 100.78 ± 1.1% | 1157.48 ± 0.4% | 1.23 | 1.00 | 2.06 | 24.18 |
| class: a number | 8288 | 1716.96 ± 0.3% | 816.66 ± 0.2% | 29.54 ± 0.5% | 1813.32 ± 1.6% | 48.17 ± 13.7% | 0.38 ± 0.6% | 72.40 ± 2.0% | 1722.51 ± 0.3% | 2.10 | 1.00 | 0.95 | 35.64 |
| class: two capitalized words, second text | 5359 | 720.05 ± 0.4% | 724.76 ± 0.2% | 25.76 ± 0.2% | 475.44 ± 0.4% | 38.75 ± 13.5% | 12.68 ± 0.2% | 74.34 ± 0.3% | 724.23 ± 0.2% | 0.99 | 0.99 | 1.51 | 18.58 |
| other: a word between two words | 6104 | 835.40 ± 3.9% | 753.35 ± 0.2% | 19.18 ± 11.4% | 813.54 ± 2.6% | 127.42 ± 23.2% | 8.44 ± 2.4% | 81.53 ± 0.2% | 838.86 ± 0.5% | 1.11 | 1.00 | 1.03 | 6.56 |
| other: a number before a unit, second text | 1481 | 9906.83 ± 0.7% | 991.22 ± 1.1% | 28.15 ± 0.6% | 8276.59 ± 1.0% | 44.95 ± 10.1% | 13.27 ± 0.2% | 78.24 ± 7.4% | 9869.19 ± 0.3% | 9.99 | 1.00 | 1.20 | 220.41 |
| other: a heading's start tag | 110 | 24437.56 ± 0.1% | 1030.04 ± 0.2% | 29.84 ± 0.7% | 2567.27 ± 0.2% | 2011.65 ± 5.6% | 11.69 ± 0.6% | 107.07 ± 0.3% | 24456.42 ± 0.4% | 23.72 | 1.00 | 9.52 | 12.15 |
| other: a whole word | 217 | 29242.13 ± 0.3% | 1032.18 ± 0.2% | 30.61 ± 0.3% | 27825.28 ± 0.1% | 54.23 ± 0.6% | 11.01 ± 0.2% | 62.98 ± 0.6% | 29177.05 ± 0.5% | 28.33 | 1.00 | 1.05 | 539.23 |
| other: a line's first word, second text | 3716 | 2589.34 ± 1.1% | 861.93 ± 0.1% | 32.07 ± 4.7% | 2327.28 ± 3.8% | 70.95 ± 3.3% | refused | refused | 2577.27 ± 1.1% | 3.00 | 1.00 | 1.11 | 36.50 |
| other: fourteen octets before an x | 87 | 35946.32 ± 0.4% | 246.97 ± 1.0% | 7.39 ± 0.3% | 3512.93 ± 0.6% | 11.54 ± 1.7% | differs | 20.77 ± 12.9% | 36104.38 ± 13.9% | 145.55 | 1.00 | 10.23 | 3116.01 |
| other: a Greek word | 21815 | 478.47 ± 0.6% | 401.90 ± 0.1% | 33.73 ± 0.4% | 304.71 ± 0.3% | 57.96 ± 5.3% | differs | refused | 478.74 ± 0.7% | 1.19 | 1.00 | 1.57 | 8.26 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.09 ± 4.2% | 29.13 ± 3.9% | 1.04 ± 13.6% | 19.80 ± 0.8% | 2.69 ± 4.2% | differs | 4.11 ± 4.3% | 29.26 ± 1.3% | 1.00 | 0.99 | 1.47 | 10.83 |
| a UUID | 32895 | 24.15 ± 0.9% | 24.03 ± 0.5% | 0.73 ± 1.7% | 15.11 ± 0.5% | 3.03 ± 0.9% | 0.52 ± 0.3% | 3.89 ± 4.4% | 24.14 ± 0.2% | 1.00 | 1.00 | 1.60 | 7.97 |
| an IPv4 address | 33176 | 39.58 ± 1.2% | 39.69 ± 0.6% | 2.35 ± 1.4% | 28.11 ± 0.3% | 6.96 ± 1.3% | differs | 4.19 ± 0.6% | 39.92 ± 2.1% | 1.00 | 0.99 | 1.41 | 5.69 |
| a date and time | 32954 | 35.23 ± 0.4% | 35.90 ± 0.2% | 1.74 ± 0.4% | 21.65 ± 0.2% | 8.18 ± 2.8% | 0.91 ± 0.1% | 7.60 ± 8.0% | 35.86 ± 0.9% | 0.98 | 0.98 | 1.63 | 4.31 |
| a field path | 32606 | 31.35 ± 0.5% | 32.36 ± 8.1% | 1.15 ± 1.0% | 22.90 ± 0.3% | 3.48 ± 3.1% | differs | 2.98 ± 1.9% | 32.34 ± 0.2% | 0.97 | 0.97 | 1.37 | 9.02 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.89 ± 0.3% | 10.93 ± 9.4% | 10.95 ± 0.7% | 13.34 ± 1.4% | 5.65 ± 7.0% | 0.75 ± 1.6% | none | 10.99 ± 0.5% | 1.00 | 0.99 | 0.82 | 1.93 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.74 ± 0.9% | 235.35 ± 0.6% | 271.05 ± 0.4% | 101.15 ± 1.4% | 239.72 ± 15.5% | 695.68 ± 8.4% | 4782.17 ± 1.6% | 233.38 ± 0.8% | 0.99 | 1.00 | 2.31 | 0.98 |
| a UUID | 62 | 150.88 ± 2.6% | 151.57 ± 1.0% | 166.90 ± 0.4% | 57.97 ± 1.5% | 116.15 ± 18.1% | 255.38 ± 4.8% | 5387.12 ± 7.8% | 151.08 ± 13.8% | 1.00 | 1.00 | 2.60 | 1.30 |
| an IPv4 address | 29 | 506.20 ± 0.4% | 511.81 ± 0.2% | 727.16 ± 1.3% | 88.64 ± 3.2% | 144.59 ± 3.2% | 411.02 ± 1.7% | 8967.35 ± 2.1% | 506.51 ± 0.3% | 0.99 | 1.00 | 5.71 | 3.50 |
| a date and time | 56 | 372.71 ± 0.8% | 376.80 ± 0.4% | 476.13 ± 0.2% | 87.17 ± 1.0% | 158.46 ± 2.8% | 485.80 ± 2.7% | 5550.33 ± 0.7% | 373.21 ± 0.5% | 0.99 | 1.00 | 4.28 | 2.35 |
| a field path | 39 | 221.31 ± 0.1% | 222.14 ± 0.6% | 253.61 ± 0.9% | 96.24 ± 2.8% | 224.18 ± 16.0% | 724.40 ± 0.8% | 5653.51 ± 0.6% | 221.01 ± 0.2% | 1.00 | 1.00 | 2.30 | 0.99 |
| literal: a word | 7 | 769.57 ± 0.1% | 816.92 ± 0.3% | 1483.81 ± 0.2% | 652.20 ± 2.7% | 764.78 ± 40.5% | 1614.43 ± 0.9% | 34180.01 ± 0.6% | 769.10 ± 0.2% | 0.94 | 1.00 | 1.18 | 1.01 |
| literal: a word that is not there | 8 | 739.26 ± 0.2% | 789.90 ± 0.2% | 1396.13 ± 0.5% | 607.43 ± 0.7% | 756.46 ± 2.9% | 1514.37 ± 0.3% | 33404.19 ± 0.5% | 738.45 ± 0.7% | 0.94 | 1.00 | 1.22 | 0.98 |
| literal: one of four words | 26 | 279.59 ± 0.5% | 466.81 ± 0.7% | 630.99 ± 0.4% | 53.81 ± 1.3% | 286.22 ± 4.4% | 590.19 ± 5.4% | 18305.30 ± 6.9% | 278.70 ± 4.6% | 0.60 | 1.00 | 5.20 | 0.98 |
| literal: a word in any case | 11 | 590.12 ± 1.0% | 619.96 ± 0.5% | 946.46 ± 1.3% | 18.90 ± 0.9% | 817.44 ± 2.5% | refused | 24782.24 ± 22.1% | 587.38 ± 0.8% | 0.95 | 1.00 | 31.22 | 0.72 |
| literal: an href attribute | 12 | 404.87 ± 0.1% | 418.95 ± 0.2% | 552.23 ± 1.2% | 50.87 ± 1.1% | 570.68 ± 0.6% | 1292.44 ± 0.4% | 24744.25 ± 8.8% | 403.93 ± 0.3% | 0.97 | 1.00 | 7.96 | 0.71 |
| literal: a word, second text | 10 | 685.70 ± 0.2% | 742.37 ± 0.2% | 1253.92 ± 0.6% | 548.55 ± 0.8% | 649.95 ± 31.0% | 1368.42 ± 0.6% | 31874.96 ± 1.1% | 685.46 ± 0.2% | 0.92 | 1.00 | 1.25 | 1.06 |
| class: two capitalized words | 23 | 535.31 ± 0.4% | 581.57 ± 1.2% | 853.01 ± 1.1% | 124.19 ± 0.2% | 585.10 ± 3.7% | 1278.45 ± 1.6% | 7843.96 ± 0.5% | 534.21 ± 0.3% | 0.92 | 1.00 | 4.31 | 0.91 |
| class: a word that ends in ing | 9 | 652.44 ± 0.2% | 752.58 ± 8.6% | 1312.57 ± 6.3% | 152.78 ± 0.7% | 850.86 ± 13.8% | 1882.67 ± 1.0% | 19186.22 ± 0.6% | 651.74 ± 0.3% | 0.87 | 1.00 | 4.27 | 0.77 |
| class: a word in capitals | 16 | 589.65 ± 0.1% | 651.18 ± 0.4% | 1056.26 ± 0.7% | 158.27 ± 1.1% | 865.24 ± 25.9% | 1766.57 ± 1.6% | 10582.87 ± 0.3% | 590.28 ± 0.3% | 0.91 | 1.00 | 3.73 | 0.68 |
| class: a number | 6 | 723.82 ± 0.3% | 814.86 ± 0.2% | 1528.71 ± 0.4% | 46.99 ± 4.5% | 1617.97 ± 2.1% | 3064.80 ± 0.7% | 25747.59 ± 0.2% | 724.44 ± 15.6% | 0.89 | 1.00 | 15.40 | 0.45 |
| class: two capitalized words, second text | 23 | 534.18 ± 0.3% | 582.74 ± 0.3% | 853.98 ± 5.5% | 121.83 ± 0.9% | 595.03 ± 1.1% | 1264.04 ± 1.0% | 7833.96 ± 0.6% | 534.73 ± 0.1% | 0.92 | 1.00 | 4.38 | 0.90 |
| other: a word between two words | 13 | 653.85 ± 7.6% | 676.00 ± 8.3% | 1079.00 ± 1.0% | 159.00 ± 1.3% | 579.75 ± 1.7% | 1366.18 ± 0.4% | 17895.66 ± 0.7% | 654.74 ± 0.4% | 0.97 | 1.00 | 4.11 | 1.13 |
| other: a number before a unit, second text | 15 | 437.71 ± 0.3% | 483.12 ± 0.5% | 657.87 ± 0.4% | 44.17 ± 8.2% | 725.81 ± 1.3% | 1486.92 ± 3.2% | 17713.81 ± 0.7% | 438.18 ± 8.3% | 0.91 | 1.00 | 9.91 | 0.60 |
| other: a heading's start tag | 13 | 416.12 ± 6.2% | 425.06 ± 11.5% | 561.82 ± 0.6% | 48.65 ± 0.6% | 711.69 ± 3.3% | 1386.80 ± 9.7% | 19942.24 ± 18.7% | 417.94 ± 0.2% | 0.98 | 1.00 | 8.55 | 0.58 |
| other: a whole word | 11 | 674.95 ± 5.6% | 710.21 ± 2.9% | 1168.53 ± 11.3% | 142.35 ± 0.7% | 649.04 ± 8.6% | 1389.15 ± 1.0% | 31638.24 ± 0.5% | 668.10 ± 0.8% | 0.95 | 1.01 | 4.74 | 1.04 |
| other: a line's first word, second text | 17 | 633.77 ± 1.4% | 665.47 ± 0.6% | 1074.40 ± 0.3% | 149.38 ± 0.8% | 793.75 ± 1.1% | refused | refused | 631.12 ± 2.4% | 0.95 | 1.00 | 4.24 | 0.80 |
| other: fourteen octets before an x | 16 | 118.22 ± 1.3% | 176.87 ± 0.8% | 207.27 ± 1.0% | 18.19 ± 2.5% | 506.91 ± 2.6% | 571.15 ± 2.6% | 15632.28 ± 0.4% | 117.69 ± 1.8% | 0.67 | 1.00 | 6.50 | 0.23 |
| other: a Greek word | 8 | 454.15 ± 3.1% | 627.86 ± 1.3% | 977.73 ± 9.2% | 63.01 ± 3.1% | 1591.69 ± 6.7% | 2842.28 ± 12.9% | refused | 454.35 ± 12.2% | 0.72 | 1.00 | 7.21 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29173.72 ± 1.7% | not timed | not timed | 33362.76 ± 0.3% | 2892.24 ± 15.4% | not timed | not timed | 29093.86 ± 17.3% | | 1.00 | 0.87 | 10.09 |
| 01-literal/sherlock-casei-en | 522 | 8403.76 ± 1.0% | not timed | not timed | 9000.66 ± 0.5% | 33.69 ± 11.8% | not timed | not timed | 8194.63 ± 0.2% | | 1.03 | 0.93 | 249.41 |
| 01-literal/sherlock-ru | 724 | 30664.13 ± 7.2% | not timed | not timed | 34269.31 ± 23.8% | 1276.80 ± 4.1% | not timed | not timed | 30699.33 ± 0.7% | | 1.00 | 0.89 | 24.02 |
| 01-literal/sherlock-casei-ru | 746 | 8845.22 ± 1.6% | not timed | not timed | 7802.37 ± 0.5% | 36.24 ± 22.6% | not timed | not timed | 8776.93 ± 3.2% | | 1.01 | 1.13 | 244.10 |
| 01-literal/sherlock-zh | 30 | 53577.53 ± 15.3% | not timed | not timed | 43170.80 ± 0.4% | 1637.50 ± 1.0% | not timed | not timed | 53458.81 ± 1.0% | | 1.00 | 1.24 | 32.72 |
| 02-literal-alternate/sherlock-en | 714 | 12777.33 ± 13.1% | not timed | not timed | 10861.62 ± 0.1% | 19.03 ± 0.5% | not timed | not timed | 12744.74 ± 0.3% | | 1.00 | 1.18 | 671.59 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4142.78 ± 7.4% | not timed | not timed | 2299.65 ± 1.1% | 12.22 ± 2.1% | not timed | not timed | 3810.48 ± 6.8% | | 1.09 | 1.80 | 338.93 |
| 02-literal-alternate/sherlock-ru | 899 | 7434.39 ± 1.8% | not timed | not timed | 9780.25 ± 0.6% | 25.23 ± 0.2% | not timed | not timed | 7459.29 ± 1.0% | | 1.00 | 0.76 | 294.71 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2151.27 ± 2.6% | not timed | not timed | 1182.77 ± 1.0% | 10.55 ± 0.7% | not timed | not timed | 2124.24 ± 3.2% | | 1.01 | 1.82 | 203.96 |
| 02-literal-alternate/sherlock-zh | 207 | 18543.04 ± 0.9% | not timed | not timed | 12684.29 ± 0.2% | 35.65 ± 0.6% | not timed | not timed | 18555.29 ± 0.2% | | 1.00 | 1.46 | 520.18 |
| 03-date/ascii | 111817 | 128.74 ± 0.3% | not timed | not timed | 100.04 ± 0.6% | 0.22 ± 5.6% | not timed | not timed | 129.60 ± 0.8% | | 0.99 | 1.29 | 573.29 |
| 04-ruff-noqa/real | 84 | 698.01 ± 6.4% | not timed | not timed | 504.25 ± 0.2% | 21.17 ± 1.7% | not timed | not timed | 696.77 ± 5.1% | | 1.00 | 1.38 | 32.97 |
| 04-ruff-noqa/tweaked | 44 | 591.66 ± 0.3% | not timed | not timed | 515.98 ± 0.4% | 368.70 ± 10.6% | not timed | not timed | 590.39 ± 0.4% | | 1.00 | 1.15 | 1.60 |
| 05-lexer-veryl/single | 124800 | 4.12 ± 3.5% | not timed | not timed | 3.87 ± 2.0% | 0.26 ± 5.0% | not timed | not timed | 4.13 ± 5.2% | | 1.00 | 1.06 | 16.11 |
| 06-cloud-flare-redos/original | 107 | 268.85 ± 0.2% | not timed | not timed | 228.30 ± 1.9% | 25.90 ± 0.3% | not timed | not timed | 268.72 ± 0.7% | | 1.00 | 1.18 | 10.38 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.26 ± 0.4% | not timed | not timed | 236.41 ± 0.1% | 27.79 ± 0.4% | not timed | not timed | 264.61 ± 0.5% | | 1.00 | 1.12 | 9.51 |
| 06-cloud-flare-redos/simplified-long | 10000 | 280.95 ± 0.1% | not timed | not timed | 258.39 ± 0.2% | 29.84 ± 0.8% | not timed | not timed | 280.78 ± 0.5% | | 1.00 | 1.09 | 9.42 |
| 07-unicode-character-data/parse-line | 558784 | 244.22 ± 0.5% | not timed | not timed | 201.69 ± 0.2% | 46.97 ± 5.7% | not timed | not timed | 243.27 ± 1.8% | | 1.00 | 1.21 | 5.20 |
| 08-words/all-english | 56691 | 109.57 ± 0.3% | not timed | not timed | 84.72 ± 0.6% | 13.61 ± 6.4% | not timed | not timed | 111.01 ± 0.7% | | 0.99 | 1.29 | 8.05 |
| 08-words/long-english | 839 | 983.72 ± 0.2% | not timed | not timed | 583.65 ± 0.2% | 35.08 ± 25.9% | not timed | not timed | 986.90 ± 0.3% | | 1.00 | 1.69 | 28.04 |
| 09-aws-keys/full | 0 | 517.24 ± 0.2% | not timed | not timed | 552.14 ± 0.3% | 66.98 ± 0.4% | not timed | not timed | 512.83 ± 0.7% | | 1.01 | 0.94 | 7.72 |
| 09-aws-keys/quick | 0 | 984.73 ± 0.5% | not timed | not timed | 958.72 ± 1.5% | 414.98 ± 0.3% | not timed | not timed | 983.47 ± 0.8% | | 1.00 | 1.03 | 2.37 |
| 10-bounded-repeat/letters-en | 1833 | 670.75 ± 1.2% | not timed | not timed | 546.64 ± 0.7% | 22.88 ± 1.1% | not timed | not timed | 666.66 ± 0.8% | | 1.01 | 1.23 | 29.31 |
| 10-bounded-repeat/letters-ru | 3475 | 367.04 ± 0.4% | not timed | not timed | 482.02 ± 1.0% | 25.26 ± 9.6% | not timed | not timed | 367.48 ± 0.4% | | 1.00 | 0.76 | 14.53 |
| 10-bounded-repeat/context | 53 | 81.52 ± 1.2% | not timed | not timed | 70.08 ± 9.1% | 22.49 ± 4.4% | not timed | not timed | 82.35 ± 2.2% | | 0.99 | 1.16 | 3.63 |
| 10-bounded-repeat/capitals | 11 | 1032.61 ± 0.7% | not timed | not timed | 604.35 ± 0.1% | 40.30 ± 3.1% | not timed | not timed | 1028.87 ± 0.3% | | 1.00 | 1.71 | 25.62 |
| 11-unstructured-to-json/extract | 600 | 46.28 ± 0.5% | not timed | not timed | 79.06 ± 0.9% | 50.31 ± 2.3% | not timed | not timed | 46.25 ± 0.6% | | 1.00 | 0.59 | 0.92 |
| 12-dictionary/single | 1 | 509.05 ± 0.2% | not timed | not timed | 480.12 ± 0.2% | 0.38 ± 3.9% | not timed | not timed | 511.85 ± 0.6% | | 0.99 | 1.06 | 1326.60 |
| 14-quadratic/1x | 100 | 9.45 ± 0.5% | not timed | not timed | 12.19 ± 1.9% | 1.01 ± 8.8% | not timed | not timed | 9.40 ± 3.2% | | 1.00 | 0.78 | 9.37 |
| 14-quadratic/2x | 200 | 5.33 ± 2.1% | not timed | not timed | 6.12 ± 0.1% | 0.55 ± 3.0% | not timed | not timed | 5.33 ± 0.4% | | 1.00 | 0.87 | 9.76 |
| 14-quadratic/10x | 1000 | 1.18 ± 0.2% | not timed | not timed | 1.22 ± 0.2% | 0.12 ± 1.7% | not timed | not timed | 1.18 ± 0.6% | | 1.00 | 0.97 | 9.99 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.69 ± 0.8% | not timed | not timed | 0.47 ± 0.4% | 0.60 ± 8.5% | not timed | not timed | 1.68 ± 0.8% | | 1.01 | 3.58 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 100.50 ± 0.3% | not timed | not timed | 17.16 ± 0.8% | 153.49 ± 6.0% | not timed | not timed | 100.29 ± 1.0% | | 1.00 | 5.86 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 16.95 ± 0.4% | not timed | not timed | 2.99 ± 11.5% | 7.62 ± 3.2% | not timed | not timed | 16.92 ± 2.1% | | 1.00 | 5.67 | 2.23 |
| 07-unicode-character-data/compile | 1 | 62.90 ± 13.2% | not timed | not timed | 30.80 ± 1.5% | 42.58 ± 2.2% | not timed | not timed | 62.80 ± 0.7% | | 1.00 | 2.04 | 1.48 |
| 09-aws-keys/compile-full | 1 | 44.78 ± 0.1% | not timed | not timed | 9.96 ± 1.1% | 26.83 ± 2.1% | not timed | not timed | 44.57 ± 9.4% | | 1.00 | 4.50 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 198.67 ± 6.3% | not timed | not timed | 57.12 ± 0.5% | 144.77 ± 22.1% | not timed | not timed | 197.13 ± 1.1% | | 1.01 | 3.48 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 15.54 ± 0.5% | not timed | not timed | 14.10 ± 12.0% | 19.38 ± 2.6% | not timed | not timed | 15.43 ± 1.0% | | 1.01 | 1.10 | 0.80 |
| 10-bounded-repeat/compile-capitals | 1 | 93.14 ± 39.3% | not timed | not timed | 10.39 ± 0.4% | 28.03 ± 3.1% | not timed | not timed | 92.71 ± 7.0% | | 1.00 | 8.96 | 3.32 |
| 11-unstructured-to-json/compile | 1 | 98.14 ± 0.5% | not timed | not timed | 47.33 ± 0.8% | 75.33 ± 1.5% | not timed | not timed | 97.52 ± 0.6% | | 1.01 | 2.07 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.1% | not timed | not timed | 0.08 ± 43.0% | 0.11 ± 30.2% | not timed | not timed | 0.35 ± 1.6% | | 1.01 | 4.42 | 3.14 |

