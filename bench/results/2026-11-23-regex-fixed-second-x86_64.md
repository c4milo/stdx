# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159246121 |
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
| literal: a word | 217 | 40515.57 ± 2.8% | 1033.23 ± 0.0% | 31.50 ± 1.8% | 38721.68 ± 1.2% | 11368.29 ± 7.6% | 12.92 ± 2.1% | 104.42 ± 2.5% | 40482.02 ± 5.3% | 39.21 | 1.00 | 1.05 | 3.56 |
| literal: a word that is not there | 0 | 57082.93 ± 0.5% | 1043.02 ± 0.3% | 31.51 ± 0.8% | 45886.56 ± 7.3% | 43546.77 ± 14.4% | 12.80 ± 0.2% | 98.24 ± 0.7% | 57067.09 ± 0.5% | 54.73 | 1.00 | 1.24 | 1.31 |
| literal: one of four words | 661 | 14163.24 ± 0.3% | 1013.30 ± 0.2% | 17.38 ± 1.2% | 11135.55 ± 0.3% | 24.58 ± 3.7% | 4.49 ± 0.7% | 8.06 ± 2.1% | 14136.46 ± 0.8% | 13.98 | 1.00 | 1.27 | 576.18 |
| literal: a word in any case | 217 | 36237.19 ± 0.3% | 1032.41 ± 0.1% | 24.45 ± 0.9% | 11352.93 ± 0.1% | 46.74 ± 7.1% | refused | differs | 36320.68 ± 0.5% | 35.10 | 1.00 | 3.19 | 775.28 |
| literal: an href attribute | 33 | 35296.35 ± 0.4% | 1039.32 ± 0.1% | 30.34 ± 0.4% | 34870.63 ± 1.1% | 2944.91 ± 2.8% | 9.70 ± 0.1% | 91.58 ± 0.3% | 35147.01 ± 0.7% | 33.96 | 1.00 | 1.01 | 11.99 |
| literal: a word, second text | 123 | 43868.08 ± 0.8% | 1035.91 ± 0.2% | 30.87 ± 0.2% | 39314.15 ± 0.6% | 10554.04 ± 5.3% | 14.45 ± 0.3% | 87.68 ± 0.1% | 44002.00 ± 0.4% | 42.35 | 1.00 | 1.12 | 4.16 |
| class: two capitalized words | 1331 | 915.59 ± 0.2% | 960.24 ± 0.7% | 29.21 ± 4.6% | 576.58 ± 0.5% | 43.51 ± 0.7% | 11.05 ± 0.2% | 80.28 ± 5.2% | 915.76 ± 0.3% | 0.95 | 1.00 | 1.59 | 21.04 |
| class: a word that ends in ing | 3399 | 884.30 ± 0.3% | 883.07 ± 0.3% | 20.46 ± 0.3% | 539.80 ± 0.4% | 30.03 ± 9.4% | 6.25 ± 0.2% | 19.89 ± 0.5% | 883.63 ± 1.1% | 1.00 | 1.00 | 1.64 | 29.45 |
| class: a word in capitals | 2332 | 1157.67 ± 0.2% | 940.38 ± 0.2% | 30.86 ± 5.7% | 565.80 ± 0.3% | 46.90 ± 8.4% | 12.46 ± 0.1% | 101.78 ± 1.3% | 1156.11 ± 0.1% | 1.23 | 1.00 | 2.05 | 24.68 |
| class: a number | 8288 | 1707.11 ± 4.2% | 808.11 ± 3.1% | 31.07 ± 1.6% | 1766.69 ± 0.2% | 44.19 ± 14.6% | 0.39 ± 0.6% | 69.15 ± 1.4% | 1701.27 ± 2.5% | 2.11 | 1.00 | 0.97 | 38.63 |
| class: two capitalized words, second text | 5359 | 714.78 ± 0.3% | 712.36 ± 1.1% | 26.48 ± 0.2% | 478.88 ± 0.1% | 37.43 ± 8.3% | 12.68 ± 0.2% | 74.54 ± 0.3% | 713.09 ± 0.8% | 1.00 | 1.00 | 1.49 | 19.10 |
| other: a word between two words | 6104 | 829.87 ± 0.3% | 751.10 ± 0.4% | 26.25 ± 0.3% | 816.14 ± 0.4% | 113.16 ± 10.4% | 8.57 ± 4.3% | 82.17 ± 0.2% | 830.30 ± 0.4% | 1.10 | 1.00 | 1.02 | 7.33 |
| other: a number before a unit, second text | 1481 | 9879.80 ± 0.5% | 990.96 ± 0.1% | 29.15 ± 0.7% | 8255.80 ± 0.2% | 44.23 ± 0.2% | 13.19 ± 0.3% | 78.37 ± 0.2% | 9798.16 ± 0.5% | 9.97 | 1.01 | 1.20 | 223.35 |
| other: a heading's start tag | 110 | 24301.52 ± 0.3% | 1029.66 ± 1.9% | 31.07 ± 0.5% | 2580.01 ± 1.1% | 1978.67 ± 9.2% | 11.84 ± 0.3% | 105.46 ± 1.0% | 24323.77 ± 1.2% | 23.60 | 1.00 | 9.42 | 12.28 |
| other: a whole word | 217 | 29154.76 ± 1.4% | 1032.09 ± 0.1% | 32.26 ± 0.7% | 28139.48 ± 1.6% | 51.35 ± 9.9% | 11.19 ± 7.2% | 62.89 ± 0.6% | 29132.18 ± 0.2% | 28.25 | 1.00 | 1.04 | 567.77 |
| other: a line's first word, second text | 3716 | 2584.73 ± 1.4% | 858.33 ± 0.5% | 36.04 ± 5.0% | 2287.43 ± 1.7% | 66.79 ± 4.0% | refused | refused | 2545.12 ± 1.1% | 3.01 | 1.02 | 1.13 | 38.70 |
| other: fourteen octets before an x | 87 | 35738.66 ± 0.3% | 245.62 ± 0.4% | 7.60 ± 0.3% | 3398.82 ± 0.4% | 11.02 ± 0.4% | differs | 21.75 ± 1.5% | 35720.82 ± 1.0% | 145.50 | 1.00 | 10.52 | 3244.26 |
| other: a Greek word | 21815 | 464.63 ± 0.4% | 389.46 ± 0.3% | 34.88 ± 0.2% | 304.40 ± 1.2% | 56.20 ± 8.2% | differs | refused | 461.04 ± 1.0% | 1.19 | 1.01 | 1.53 | 8.27 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.20 ± 0.5% | 29.20 ± 5.3% | 1.04 ± 5.7% | 19.88 ± 5.6% | 2.30 ± 7.6% | differs | 4.04 ± 2.1% | 29.50 ± 0.6% | 1.00 | 0.99 | 1.47 | 12.67 |
| a UUID | 32895 | 23.81 ± 4.2% | 24.20 ± 0.1% | 0.73 ± 0.9% | 15.08 ± 0.2% | 3.01 ± 8.1% | 0.50 ± 0.3% | 3.78 ± 0.2% | 24.06 ± 0.4% | 0.98 | 0.99 | 1.58 | 7.92 |
| an IPv4 address | 33176 | 40.41 ± 1.8% | 40.38 ± 1.8% | 2.35 ± 10.2% | 28.49 ± 0.3% | 7.00 ± 1.4% | differs | 4.15 ± 0.8% | 40.34 ± 0.9% | 1.00 | 1.00 | 1.42 | 5.78 |
| a date and time | 32954 | 36.09 ± 0.3% | 36.06 ± 0.4% | 1.73 ± 0.7% | 21.59 ± 0.4% | 8.23 ± 2.2% | 0.91 ± 0.2% | 7.88 ± 2.3% | 36.08 ± 0.4% | 1.00 | 1.00 | 1.67 | 4.38 |
| a field path | 32606 | 32.50 ± 2.3% | 32.50 ± 1.0% | 1.15 ± 0.3% | 22.94 ± 0.2% | 3.47 ± 12.2% | differs | 2.98 ± 1.5% | 32.52 ± 9.9% | 1.00 | 1.00 | 1.42 | 9.36 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.70 ± 0.3% | 10.86 ± 0.6% | 10.82 ± 0.6% | 13.33 ± 0.6% | 5.91 ± 3.3% | 0.76 ± 0.5% | none | 10.83 ± 0.4% | 0.99 | 0.99 | 0.80 | 1.81 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.08 ± 0.5% | 239.37 ± 0.6% | 281.19 ± 0.7% | 101.24 ± 2.4% | 244.16 ± 12.7% | 708.73 ± 5.7% | 4492.81 ± 9.1% | 237.93 ± 12.8% | 0.99 | 1.00 | 2.35 | 0.98 |
| a UUID | 62 | 155.08 ± 0.2% | 155.94 ± 0.4% | 174.62 ± 0.4% | 58.07 ± 2.1% | 118.02 ± 13.1% | 251.72 ± 9.9% | 5599.83 ± 10.0% | 154.88 ± 0.9% | 0.99 | 1.00 | 2.67 | 1.31 |
| an IPv4 address | 29 | 491.29 ± 2.7% | 497.88 ± 0.4% | 726.83 ± 1.1% | 87.54 ± 0.6% | 149.09 ± 1.7% | 415.49 ± 2.2% | 8949.28 ± 0.3% | 489.92 ± 0.6% | 0.99 | 1.00 | 5.61 | 3.30 |
| a date and time | 56 | 368.81 ± 0.3% | 371.20 ± 0.4% | 481.72 ± 1.3% | 86.98 ± 10.4% | 160.54 ± 4.2% | 475.47 ± 7.8% | 5721.64 ± 4.8% | 368.03 ± 3.5% | 0.99 | 1.00 | 4.24 | 2.30 |
| a field path | 39 | 227.62 ± 0.1% | 229.12 ± 0.4% | 267.88 ± 0.6% | 95.46 ± 2.5% | 229.18 ± 11.0% | 728.63 ± 1.8% | 5912.27 ± 1.7% | 227.54 ± 0.6% | 0.99 | 1.00 | 2.38 | 0.99 |
| literal: a word | 7 | 729.94 ± 4.5% | 772.44 ± 4.5% | 1472.24 ± 9.8% | 653.44 ± 5.3% | 780.95 ± 26.3% | 1612.21 ± 2.2% | 34144.87 ± 15.6% | 731.01 ± 0.2% | 0.94 | 1.00 | 1.12 | 0.93 |
| literal: a word that is not there | 8 | 704.80 ± 0.8% | 748.11 ± 0.4% | 1390.59 ± 0.8% | 590.34 ± 1.8% | 720.09 ± 27.8% | 1506.20 ± 24.0% | 33453.34 ± 30.5% | 703.25 ± 1.2% | 0.94 | 1.00 | 1.19 | 0.98 |
| literal: one of four words | 26 | 273.77 ± 0.2% | 453.86 ± 0.4% | 632.98 ± 0.7% | 53.47 ± 0.7% | 291.78 ± 1.5% | 589.16 ± 0.3% | 20937.10 ± 19.9% | 273.25 ± 0.5% | 0.60 | 1.00 | 5.12 | 0.94 |
| literal: a word in any case | 11 | 564.20 ± 0.7% | 597.55 ± 2.7% | 949.09 ± 8.8% | 18.72 ± 1.8% | 814.22 ± 28.8% | refused | 27689.74 ± 1.8% | 560.49 ± 0.6% | 0.94 | 1.01 | 30.15 | 0.69 |
| literal: an href attribute | 12 | 399.31 ± 0.7% | 413.45 ± 2.3% | 564.01 ± 0.9% | 51.08 ± 0.1% | 574.74 ± 1.1% | 1302.95 ± 0.6% | 24674.11 ± 1.2% | 399.51 ± 0.2% | 0.97 | 1.00 | 7.82 | 0.69 |
| literal: a word, second text | 10 | 654.17 ± 0.2% | 705.33 ± 0.2% | 1253.48 ± 0.2% | 545.29 ± 0.9% | 649.18 ± 0.9% | 1367.69 ± 0.9% | 32008.18 ± 0.3% | 654.56 ± 0.5% | 0.93 | 1.00 | 1.20 | 1.01 |
| class: two capitalized words | 23 | 515.93 ± 1.4% | 559.91 ± 5.7% | 855.75 ± 8.0% | 122.73 ± 1.9% | 601.04 ± 1.2% | 1276.89 ± 0.8% | 7080.12 ± 0.6% | 515.68 ± 0.3% | 0.92 | 1.00 | 4.20 | 0.86 |
| class: a word that ends in ing | 9 | 629.35 ± 0.5% | 714.09 ± 0.3% | 1333.96 ± 7.8% | 152.91 ± 7.3% | 856.50 ± 0.6% | 1928.85 ± 1.6% | 11949.56 ± 3.1% | 629.26 ± 0.5% | 0.88 | 1.00 | 4.12 | 0.73 |
| class: a word in capitals | 16 | 557.21 ± 0.8% | 607.40 ± 0.2% | 1043.47 ± 0.5% | 158.44 ± 1.0% | 892.13 ± 10.9% | 1797.22 ± 1.0% | 9669.04 ± 0.1% | 557.43 ± 0.4% | 0.92 | 1.00 | 3.52 | 0.62 |
| class: a number | 6 | 683.12 ± 0.4% | 760.27 ± 0.4% | 1527.21 ± 0.7% | 47.33 ± 1.4% | 1615.02 ± 2.8% | 3049.06 ± 6.4% | 20865.76 ± 0.9% | 683.35 ± 0.3% | 0.90 | 1.00 | 14.43 | 0.42 |
| class: two capitalized words, second text | 23 | 515.39 ± 0.9% | 561.09 ± 0.5% | 856.50 ± 0.3% | 121.73 ± 0.7% | 602.74 ± 3.1% | 1209.52 ± 1.2% | 7081.46 ± 0.1% | 515.42 ± 0.2% | 0.92 | 1.00 | 4.23 | 0.86 |
| other: a word between two words | 13 | 630.67 ± 0.2% | 649.71 ± 0.2% | 1087.22 ± 0.2% | 158.29 ± 1.6% | 576.33 ± 2.5% | 1358.60 ± 0.3% | 11405.43 ± 0.2% | 630.28 ± 0.7% | 0.97 | 1.00 | 3.98 | 1.09 |
| other: a number before a unit, second text | 15 | 435.38 ± 0.1% | 485.08 ± 0.1% | 691.77 ± 0.8% | 43.94 ± 1.0% | 719.99 ± 1.0% | 1471.79 ± 4.7% | 17868.08 ± 1.4% | 434.43 ± 11.4% | 0.90 | 1.00 | 9.91 | 0.60 |
| other: a heading's start tag | 13 | 411.38 ± 8.6% | 420.15 ± 0.3% | 574.86 ± 0.6% | 48.40 ± 0.9% | 704.44 ± 1.3% | 1395.53 ± 1.1% | 20447.97 ± 0.3% | 411.61 ± 9.3% | 0.98 | 1.00 | 8.50 | 0.58 |
| other: a whole word | 11 | 648.51 ± 8.1% | 685.84 ± 0.6% | 1187.50 ± 0.2% | 143.13 ± 0.9% | 670.90 ± 2.1% | 1372.80 ± 8.2% | 31939.30 ± 0.4% | 646.63 ± 0.6% | 0.95 | 1.00 | 4.53 | 0.97 |
| other: a line's first word, second text | 17 | 608.76 ± 0.8% | 637.03 ± 0.9% | 1090.11 ± 0.7% | 148.90 ± 0.7% | 803.88 ± 1.7% | refused | refused | 607.58 ± 0.4% | 0.96 | 1.00 | 4.09 | 0.76 |
| other: fourteen octets before an x | 16 | 118.64 ± 2.5% | 174.64 ± 0.2% | 209.46 ± 0.5% | 18.08 ± 0.2% | 523.27 ± 17.6% | 579.64 ± 1.2% | 15775.73 ± 0.7% | 119.93 ± 2.8% | 0.68 | 0.99 | 6.56 | 0.23 |
| other: a Greek word | 8 | 436.70 ± 0.8% | 610.41 ± 0.5% | 1013.10 ± 1.1% | 62.56 ± 1.0% | 1599.80 ± 0.7% | 2788.81 ± 0.1% | refused | 436.52 ± 0.2% | 0.72 | 1.00 | 6.98 | 0.27 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29462.09 ± 0.3% | not timed | not timed | 33658.49 ± 2.2% | 2541.72 ± 52.0% | not timed | not timed | 29350.71 ± 0.6% | | 1.00 | 0.88 | 11.59 |
| 01-literal/sherlock-casei-en | 522 | 8473.36 ± 0.5% | not timed | not timed | 9007.03 ± 0.1% | 33.85 ± 9.4% | not timed | not timed | 8443.29 ± 0.6% | | 1.00 | 0.94 | 250.31 |
| 01-literal/sherlock-ru | 724 | 30834.83 ± 0.5% | not timed | not timed | 34069.65 ± 12.2% | 1237.18 ± 6.6% | not timed | not timed | 30734.35 ± 0.5% | | 1.00 | 0.91 | 24.92 |
| 01-literal/sherlock-casei-ru | 746 | 8871.00 ± 1.0% | not timed | not timed | 7804.05 ± 0.8% | 37.09 ± 19.8% | not timed | not timed | 8801.75 ± 5.0% | | 1.01 | 1.14 | 239.16 |
| 01-literal/sherlock-zh | 30 | 53159.16 ± 0.9% | not timed | not timed | 42853.49 ± 0.5% | 1642.58 ± 4.6% | not timed | not timed | 53113.22 ± 0.5% | | 1.00 | 1.24 | 32.36 |
| 02-literal-alternate/sherlock-en | 714 | 12846.11 ± 0.8% | not timed | not timed | 10856.32 ± 8.0% | 19.08 ± 1.6% | not timed | not timed | 12851.35 ± 0.9% | | 1.00 | 1.18 | 673.25 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4129.11 ± 10.7% | not timed | not timed | 2276.54 ± 6.0% | 12.26 ± 2.1% | not timed | not timed | 3818.14 ± 1.2% | | 1.08 | 1.81 | 336.66 |
| 02-literal-alternate/sherlock-ru | 899 | 7464.35 ± 2.0% | not timed | not timed | 9837.61 ± 0.5% | 25.41 ± 0.3% | not timed | not timed | 7436.64 ± 0.3% | | 1.00 | 0.76 | 293.81 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2184.01 ± 3.7% | not timed | not timed | 1189.20 ± 0.7% | 10.53 ± 8.9% | not timed | not timed | 2176.41 ± 0.8% | | 1.00 | 1.84 | 207.35 |
| 02-literal-alternate/sherlock-zh | 207 | 18611.15 ± 0.2% | not timed | not timed | 12653.27 ± 4.1% | 35.71 ± 11.0% | not timed | not timed | 18582.48 ± 24.1% | | 1.00 | 1.47 | 521.21 |
| 03-date/ascii | 111817 | 128.52 ± 1.2% | not timed | not timed | 101.15 ± 0.3% | 0.23 ± 1.9% | not timed | not timed | 127.37 ± 3.3% | | 1.01 | 1.27 | 556.75 |
| 04-ruff-noqa/real | 84 | 687.38 ± 1.4% | not timed | not timed | 505.93 ± 4.3% | 20.73 ± 1.4% | not timed | not timed | 682.27 ± 0.5% | | 1.01 | 1.36 | 33.16 |
| 04-ruff-noqa/tweaked | 44 | 590.63 ± 21.0% | not timed | not timed | 509.49 ± 0.6% | 368.07 ± 0.5% | not timed | not timed | 589.43 ± 0.3% | | 1.00 | 1.16 | 1.60 |
| 05-lexer-veryl/single | 124800 | 3.83 ± 1.0% | not timed | not timed | 5.41 ± 1.0% | 0.24 ± 8.0% | not timed | not timed | 4.01 ± 1.7% | | 0.96 | 0.71 | 15.75 |
| 06-cloud-flare-redos/original | 107 | 259.36 ± 0.4% | not timed | not timed | 226.93 ± 1.4% | 25.39 ± 4.0% | not timed | not timed | 253.56 ± 14.5% | | 1.02 | 1.14 | 10.21 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.26 ± 9.9% | not timed | not timed | 236.48 ± 0.5% | 27.51 ± 2.9% | not timed | not timed | 255.89 ± 0.7% | | 0.99 | 1.08 | 9.24 |
| 06-cloud-flare-redos/simplified-long | 10000 | 280.53 ± 0.4% | not timed | not timed | 259.57 ± 0.4% | 29.78 ± 0.4% | not timed | not timed | 280.69 ± 0.6% | | 1.00 | 1.08 | 9.42 |
| 07-unicode-character-data/parse-line | 558784 | 245.72 ± 0.4% | not timed | not timed | 201.19 ± 0.3% | 48.77 ± 1.0% | not timed | not timed | 245.82 ± 1.3% | | 1.00 | 1.22 | 5.04 |
| 08-words/all-english | 56691 | 112.67 ± 0.9% | not timed | not timed | 84.42 ± 0.5% | 14.90 ± 6.6% | not timed | not timed | 112.03 ± 0.3% | | 1.01 | 1.33 | 7.56 |
| 08-words/long-english | 839 | 989.10 ± 0.2% | not timed | not timed | 583.87 ± 0.7% | 35.20 ± 0.4% | not timed | not timed | 988.06 ± 0.4% | | 1.00 | 1.69 | 28.10 |
| 09-aws-keys/full | 0 | 518.48 ± 0.2% | not timed | not timed | 546.50 ± 0.3% | 66.45 ± 2.9% | not timed | not timed | 517.40 ± 7.5% | | 1.00 | 0.95 | 7.80 |
| 09-aws-keys/quick | 0 | 894.05 ± 0.3% | not timed | not timed | 955.03 ± 0.7% | 414.14 ± 1.3% | not timed | not timed | 960.60 ± 0.8% | | 0.93 | 0.94 | 2.16 |
| 10-bounded-repeat/letters-en | 1833 | 659.90 ± 1.4% | not timed | not timed | 557.19 ± 0.6% | 22.81 ± 1.1% | not timed | not timed | 660.63 ± 0.9% | | 1.00 | 1.18 | 28.94 |
| 10-bounded-repeat/letters-ru | 3475 | 365.44 ± 0.4% | not timed | not timed | 483.11 ± 0.7% | 25.04 ± 9.6% | not timed | not timed | 365.47 ± 1.2% | | 1.00 | 0.76 | 14.59 |
| 10-bounded-repeat/context | 53 | 82.39 ± 1.1% | not timed | not timed | 70.80 ± 1.1% | 22.66 ± 0.9% | not timed | not timed | 82.01 ± 13.4% | | 1.00 | 1.16 | 3.64 |
| 10-bounded-repeat/capitals | 11 | 1032.71 ± 0.8% | not timed | not timed | 603.82 ± 0.1% | 40.29 ± 1.2% | not timed | not timed | 1030.60 ± 0.2% | | 1.00 | 1.71 | 25.63 |
| 11-unstructured-to-json/extract | 600 | 46.70 ± 0.6% | not timed | not timed | 79.65 ± 0.7% | 49.13 ± 1.1% | not timed | not timed | 46.79 ± 1.4% | | 1.00 | 0.59 | 0.95 |
| 12-dictionary/single | 1 | 508.94 ± 0.3% | not timed | not timed | 479.66 ± 0.3% | 0.39 ± 0.9% | not timed | not timed | 511.33 ± 0.3% | | 1.00 | 1.06 | 1294.99 |
| 14-quadratic/1x | 100 | 12.87 ± 11.8% | not timed | not timed | 12.16 ± 0.1% | 0.99 ± 3.3% | not timed | not timed | 12.82 ± 0.5% | | 1.00 | 1.06 | 13.04 |
| 14-quadratic/2x | 200 | 7.81 ± 1.0% | not timed | not timed | 6.12 ± 0.3% | 0.51 ± 5.2% | not timed | not timed | 7.79 ± 0.5% | | 1.00 | 1.28 | 15.40 |
| 14-quadratic/10x | 1000 | 1.81 ± 0.4% | not timed | not timed | 1.22 ± 0.6% | 0.12 ± 3.0% | not timed | not timed | 1.82 ± 0.5% | | 1.00 | 1.49 | 15.27 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.64 ± 1.0% | not timed | not timed | 0.48 ± 0.3% | 0.64 ± 4.7% | not timed | not timed | 1.63 ± 1.4% | | 1.01 | 3.42 | 2.57 |
| 04-ruff-noqa/compile-real | 1 | 102.45 ± 0.8% | not timed | not timed | 16.93 ± 0.8% | 167.30 ± 4.0% | not timed | not timed | 102.76 ± 0.7% | | 1.00 | 6.05 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 17.03 ± 0.8% | not timed | not timed | 2.99 ± 1.2% | 7.81 ± 2.1% | not timed | not timed | 16.91 ± 1.1% | | 1.01 | 5.69 | 2.18 |
| 07-unicode-character-data/compile | 1 | 63.93 ± 0.1% | not timed | not timed | 29.99 ± 3.2% | 44.09 ± 1.4% | not timed | not timed | 63.33 ± 1.3% | | 1.01 | 2.13 | 1.45 |
| 09-aws-keys/compile-full | 1 | 45.04 ± 0.4% | not timed | not timed | 9.92 ± 0.5% | 27.76 ± 3.1% | not timed | not timed | 44.83 ± 0.7% | | 1.00 | 4.54 | 1.62 |
| 09-aws-keys/compile-quick | 1 | 196.46 ± 0.2% | not timed | not timed | 56.74 ± 0.5% | 154.41 ± 4.1% | not timed | not timed | 197.24 ± 0.6% | | 1.00 | 3.46 | 1.27 |
| 10-bounded-repeat/compile-context | 1 | 15.47 ± 0.3% | not timed | not timed | 14.49 ± 0.2% | 19.93 ± 2.0% | not timed | not timed | 15.41 ± 0.7% | | 1.00 | 1.07 | 0.78 |
| 10-bounded-repeat/compile-capitals | 1 | 90.26 ± 1.3% | not timed | not timed | 10.46 ± 1.2% | 29.02 ± 1.6% | not timed | not timed | 91.77 ± 1.3% | | 0.98 | 8.63 | 3.11 |
| 11-unstructured-to-json/compile | 1 | 98.40 ± 0.5% | not timed | not timed | 47.67 ± 0.7% | 79.42 ± 2.7% | not timed | not timed | 97.84 ± 0.7% | | 1.01 | 2.06 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.35 ± 8.3% | not timed | not timed | 0.08 ± 17.0% | 0.11 ± 23.0% | not timed | not timed | 0.35 ± 0.7% | | 1.00 | 4.17 | 3.31 |

