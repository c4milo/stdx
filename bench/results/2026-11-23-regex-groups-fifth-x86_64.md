# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215353115 |
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
| literal: a word | 217 | 40587.09 ± 0.5% | 3966.94 ± 0.3% | 32.66 ± 0.4% | 37978.76 ± 0.2% | 11977.52 ± 5.3% | 12.76 ± 2.5% | 103.35 ± 5.3% | 40911.95 ± 2.0% | 10.23 | 0.99 | 1.07 | 3.39 |
| literal: a word that is not there | 0 | 57489.17 ± 0.6% | 3907.61 ± 0.7% | 32.36 ± 22.9% | 45369.87 ± 0.4% | 43791.04 ± 1.1% | 12.62 ± 0.2% | 98.50 ± 4.1% | 57409.62 ± 9.9% | 14.71 | 1.00 | 1.27 | 1.31 |
| literal: one of four words | 661 | 14155.41 ± 0.3% | 1669.25 ± 2.7% | 16.98 ± 0.5% | 11140.67 ± 0.2% | 25.00 ± 0.4% | 4.48 ± 0.4% | 8.63 ± 4.0% | 14086.85 ± 0.2% | 8.48 | 1.00 | 1.27 | 566.16 |
| literal: a word in any case | 217 | 36785.35 ± 1.0% | 1795.42 ± 4.0% | 24.04 ± 0.6% | 11347.03 ± 0.2% | 47.12 ± 1.0% | refused | differs | 36708.40 ± 2.0% | 20.49 | 1.00 | 3.24 | 780.71 |
| literal: an href attribute | 33 | 35449.74 ± 0.4% | 615.90 ± 0.3% | 29.05 ± 0.2% | 34944.71 ± 1.0% | 3053.09 ± 6.2% | 9.55 ± 0.5% | 91.10 ± 0.7% | 35433.03 ± 0.4% | 57.56 | 1.00 | 1.01 | 11.61 |
| literal: a word, second text | 123 | 44453.28 ± 0.5% | 3106.12 ± 0.4% | 32.30 ± 4.6% | 39540.27 ± 0.6% | 11254.82 ± 3.1% | 14.52 ± 0.2% | 88.67 ± 1.8% | 44476.70 ± 4.2% | 14.31 | 1.00 | 1.12 | 3.95 |
| class: two capitalized words | 1331 | 905.81 ± 0.2% | 606.04 ± 0.1% | 29.61 ± 4.9% | 575.18 ± 0.2% | 44.46 ± 0.2% | 10.96 ± 0.6% | 79.51 ± 2.0% | 905.85 ± 2.0% | 1.49 | 1.00 | 1.57 | 20.37 |
| class: a word that ends in ing | 3399 | 576.62 ± 0.2% | 574.59 ± 0.7% | 19.93 ± 1.2% | 540.94 ± 1.2% | 32.81 ± 22.6% | 6.19 ± 0.2% | 20.56 ± 1.2% | 575.71 ± 0.3% | 1.00 | 1.00 | 1.07 | 17.57 |
| class: a word in capitals | 2332 | 1140.56 ± 0.3% | 610.69 ± 0.4% | 31.92 ± 0.3% | 564.78 ± 0.3% | 46.95 ± 18.1% | 12.42 ± 0.9% | 102.00 ± 4.3% | 1139.81 ± 0.3% | 1.87 | 1.00 | 2.02 | 24.29 |
| class: a number | 8288 | 1837.84 ± 1.0% | 815.44 ± 0.5% | 32.53 ± 0.4% | 1806.94 ± 1.9% | 48.26 ± 11.9% | 0.38 ± 0.3% | 72.49 ± 0.2% | 1743.28 ± 1.5% | 2.25 | 1.05 | 1.02 | 38.08 |
| class: two capitalized words, second text | 5359 | 512.74 ± 0.3% | 519.04 ± 0.2% | 22.12 ± 0.2% | 478.63 ± 0.2% | 38.17 ± 16.3% | 12.79 ± 0.2% | 73.69 ± 0.2% | 511.65 ± 0.4% | 0.99 | 1.00 | 1.07 | 13.43 |
| other: a word between two words | 6104 | 833.04 ± 0.1% | 578.50 ± 0.3% | 26.15 ± 4.3% | 807.14 ± 3.5% | 123.19 ± 12.3% | 8.49 ± 0.1% | 82.23 ± 0.8% | 832.71 ± 0.3% | 1.44 | 1.00 | 1.03 | 6.76 |
| other: a number before a unit, second text | 1481 | 9989.97 ± 44.7% | 1052.17 ± 1.2% | 30.10 ± 1.4% | 8260.36 ± 1.8% | 44.28 ± 6.1% | 13.35 ± 14.4% | 77.30 ± 0.6% | 9932.74 ± 2.0% | 9.49 | 1.01 | 1.21 | 225.59 |
| other: a heading's start tag | 110 | 24461.82 ± 3.3% | 747.07 ± 0.1% | 32.40 ± 0.4% | 2541.83 ± 2.8% | 2019.54 ± 4.0% | 11.63 ± 5.7% | 97.48 ± 2.1% | 24461.65 ± 0.2% | 32.74 | 1.00 | 9.62 | 12.11 |
| other: a whole word | 217 | 29466.18 ± 1.0% | 607.07 ± 0.6% | 32.08 ± 6.5% | 27752.47 ± 0.6% | 54.32 ± 2.7% | 11.05 ± 0.2% | 63.25 ± 1.0% | 29442.88 ± 0.4% | 48.54 | 1.00 | 1.06 | 542.44 |
| other: a line's first word, second text | 3716 | 2561.03 ± 2.4% | 589.23 ± 0.4% | 35.81 ± 1.0% | 2300.25 ± 1.2% | 69.08 ± 15.3% | refused | refused | 2548.42 ± 1.6% | 4.35 | 1.00 | 1.11 | 37.07 |
| other: fourteen octets before an x | 87 | 36346.28 ± 0.5% | 260.81 ± 2.4% | 6.87 ± 2.2% | 3477.98 ± 1.2% | 11.59 ± 2.2% | differs | 21.39 ± 12.7% | 35497.62 ± 21.5% | 139.36 | 1.02 | 10.45 | 3134.91 |
| other: a Greek word | 21815 | 460.79 ± 0.5% | 396.04 ± 0.2% | 34.77 ± 0.7% | 302.12 ± 0.5% | 55.94 ± 10.4% | differs | refused | 459.37 ± 4.6% | 1.16 | 1.00 | 1.53 | 8.24 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 21.66 ± 0.5% | 21.70 ± 0.2% | 1.02 ± 0.2% | 19.87 ± 6.2% | 2.69 ± 9.8% | differs | 4.33 ± 6.2% | 21.64 ± 1.0% | 1.00 | 1.00 | 1.09 | 8.06 |
| a UUID | 32895 | 24.01 ± 0.2% | 24.44 ± 0.5% | 0.71 ± 9.2% | 15.12 ± 0.1% | 2.98 ± 5.2% | 0.52 ± 0.2% | 3.77 ± 0.4% | 24.25 ± 6.4% | 0.98 | 0.99 | 1.59 | 8.06 |
| an IPv4 address | 33176 | 40.98 ± 1.0% | 40.92 ± 11.9% | 2.25 ± 15.6% | 28.56 ± 5.4% | 6.95 ± 2.0% | differs | 4.21 ± 0.7% | 41.00 ± 12.3% | 1.00 | 1.00 | 1.43 | 5.90 |
| a date and time | 32954 | 36.24 ± 5.4% | 36.32 ± 0.5% | 1.69 ± 0.6% | 21.68 ± 0.4% | 8.21 ± 2.2% | 0.90 ± 2.0% | 7.75 ± 3.2% | 35.99 ± 0.4% | 1.00 | 1.01 | 1.67 | 4.42 |
| a field path | 32606 | 24.94 ± 0.3% | 25.43 ± 0.2% | 1.13 ± 0.9% | 23.01 ± 0.3% | 3.56 ± 2.2% | differs | 3.09 ± 0.6% | 25.47 ± 0.4% | 0.98 | 0.98 | 1.08 | 7.01 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.92 ± 1.1% | 10.82 ± 0.7% | 11.00 ± 1.5% | 13.22 ± 0.8% | 5.84 ± 3.1% | 0.74 ± 15.7% | none | 10.89 ± 0.4% | 1.01 | 1.00 | 0.83 | 1.87 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 260.13 ± 0.7% | 261.59 ± 0.2% | 305.98 ± 0.2% | 101.21 ± 1.3% | 245.78 ± 4.0% | 699.55 ± 5.2% | 4946.78 ± 6.0% | 260.21 ± 0.9% | 0.99 | 1.00 | 2.57 | 1.06 |
| a UUID | 62 | 169.38 ± 0.3% | 170.11 ± 0.3% | 188.48 ± 6.5% | 58.06 ± 1.2% | 119.19 ± 3.4% | 257.35 ± 1.5% | 5544.21 ± 0.5% | 169.43 ± 0.3% | 1.00 | 1.00 | 2.92 | 1.42 |
| an IPv4 address | 29 | 503.90 ± 0.3% | 510.68 ± 0.3% | 699.04 ± 0.3% | 87.88 ± 6.6% | 147.91 ± 8.9% | 413.69 ± 8.4% | 9002.29 ± 0.2% | 503.89 ± 11.3% | 0.99 | 1.00 | 5.73 | 3.41 |
| a date and time | 56 | 363.70 ± 4.5% | 365.58 ± 3.7% | 453.39 ± 0.4% | 87.68 ± 0.5% | 160.63 ± 8.1% | 474.78 ± 3.2% | 5686.55 ± 0.1% | 364.03 ± 0.2% | 0.99 | 1.00 | 4.15 | 2.26 |
| a field path | 39 | 257.92 ± 21.0% | 259.20 ± 4.1% | 300.73 ± 1.0% | 95.63 ± 2.8% | 226.95 ± 14.5% | 737.15 ± 0.5% | 6036.90 ± 1.5% | 257.96 ± 1.3% | 1.00 | 1.00 | 2.70 | 1.14 |
| literal: a word | 7 | 778.29 ± 1.1% | 826.48 ± 0.3% | 1420.98 ± 0.5% | 653.23 ± 1.9% | 785.77 ± 2.6% | 1619.32 ± 0.5% | 34570.21 ± 0.3% | 777.67 ± 3.5% | 0.94 | 1.00 | 1.19 | 0.99 |
| literal: a word that is not there | 8 | 746.24 ± 4.1% | 795.19 ± 5.8% | 1326.91 ± 6.6% | 598.66 ± 2.0% | 760.26 ± 1.3% | 1521.79 ± 1.2% | 33635.86 ± 0.5% | 746.31 ± 0.3% | 0.94 | 1.00 | 1.25 | 0.98 |
| literal: one of four words | 26 | 272.60 ± 0.3% | 454.87 ± 0.1% | 592.57 ± 0.2% | 53.80 ± 1.5% | 295.77 ± 1.8% | 585.39 ± 11.8% | 18006.94 ± 1.1% | 272.34 ± 1.4% | 0.60 | 1.00 | 5.07 | 0.92 |
| literal: a word in any case | 11 | 533.45 ± 0.6% | 561.13 ± 1.4% | 791.79 ± 0.5% | 18.94 ± 0.5% | 838.89 ± 0.5% | refused | 27688.58 ± 0.4% | 530.50 ± 0.3% | 0.95 | 1.01 | 28.16 | 0.64 |
| literal: an href attribute | 12 | 415.58 ± 0.7% | 432.66 ± 0.2% | 561.76 ± 0.4% | 50.92 ± 1.0% | 575.03 ± 1.8% | 1295.74 ± 1.8% | 24148.43 ± 11.2% | 415.94 ± 0.4% | 0.96 | 1.00 | 8.16 | 0.72 |
| literal: a word, second text | 10 | 686.97 ± 0.2% | 746.50 ± 9.4% | 1190.96 ± 0.4% | 545.46 ± 0.6% | 649.68 ± 19.1% | 1363.63 ± 3.9% | 32270.91 ± 0.2% | 686.35 ± 17.9% | 0.92 | 1.00 | 1.26 | 1.06 |
| class: two capitalized words | 23 | 532.05 ± 1.4% | 576.38 ± 0.6% | 814.76 ± 1.3% | 124.83 ± 10.1% | 609.54 ± 19.5% | 1290.42 ± 1.6% | 8041.24 ± 0.4% | 532.36 ± 0.1% | 0.92 | 1.00 | 4.26 | 0.87 |
| class: a word that ends in ing | 9 | 674.09 ± 0.7% | 766.97 ± 0.5% | 1288.90 ± 1.1% | 153.59 ± 0.9% | 864.20 ± 1.9% | 1891.20 ± 0.6% | 19338.52 ± 1.2% | 674.20 ± 7.7% | 0.88 | 1.00 | 4.39 | 0.78 |
| class: a word in capitals | 16 | 593.75 ± 0.3% | 653.05 ± 0.2% | 1019.23 ± 2.1% | 159.41 ± 0.5% | 901.03 ± 1.4% | 1777.22 ± 2.7% | 10514.16 ± 0.5% | 593.37 ± 0.9% | 0.91 | 1.00 | 3.72 | 0.66 |
| class: a number | 6 | 747.52 ± 0.5% | 843.76 ± 0.2% | 1522.49 ± 8.5% | 47.70 ± 0.4% | 1641.07 ± 1.3% | 3054.40 ± 0.7% | 25967.73 ± 0.4% | 748.02 ± 0.1% | 0.89 | 1.00 | 15.67 | 0.46 |
| class: two capitalized words, second text | 23 | 530.23 ± 0.5% | 573.67 ± 0.8% | 812.00 ± 1.2% | 122.04 ± 2.5% | 606.59 ± 10.8% | 1262.48 ± 1.4% | 8047.73 ± 0.3% | 532.74 ± 0.3% | 0.92 | 1.00 | 4.34 | 0.87 |
| other: a word between two words | 13 | 658.11 ± 3.9% | 679.75 ± 8.3% | 1038.26 ± 0.3% | 159.19 ± 1.1% | 581.45 ± 2.1% | 1350.87 ± 0.4% | 18016.92 ± 0.4% | 657.04 ± 15.3% | 0.97 | 1.00 | 4.13 | 1.13 |
| other: a number before a unit, second text | 15 | 470.87 ± 0.6% | 527.73 ± 3.7% | 720.00 ± 2.3% | 44.56 ± 1.1% | 730.74 ± 24.9% | 1483.65 ± 5.2% | 17874.99 ± 1.2% | 469.57 ± 3.2% | 0.89 | 1.00 | 10.57 | 0.64 |
| other: a heading's start tag | 13 | 431.24 ± 1.0% | 439.87 ± 3.4% | 570.63 ± 1.2% | 48.49 ± 0.4% | 714.30 ± 1.3% | 1403.30 ± 1.3% | 20675.76 ± 0.4% | 432.14 ± 0.6% | 0.98 | 1.00 | 8.89 | 0.60 |
| other: a whole word | 11 | 672.37 ± 1.1% | 710.22 ± 0.2% | 1116.96 ± 0.2% | 143.04 ± 1.0% | 684.89 ± 1.4% | 1376.53 ± 0.8% | 32050.96 ± 1.4% | 673.53 ± 0.2% | 0.95 | 1.00 | 4.70 | 0.98 |
| other: a line's first word, second text | 17 | 636.57 ± 14.1% | 671.75 ± 0.5% | 1038.32 ± 0.9% | 149.16 ± 0.9% | 816.76 ± 12.2% | refused | refused | 634.08 ± 1.4% | 0.95 | 1.00 | 4.27 | 0.78 |
| other: fourteen octets before an x | 16 | 118.51 ± 1.0% | 175.66 ± 2.0% | 203.42 ± 1.0% | 18.18 ± 1.1% | 524.62 ± 21.0% | 575.45 ± 0.9% | 15753.86 ± 0.4% | 118.34 ± 0.5% | 0.67 | 1.00 | 6.52 | 0.23 |
| other: a Greek word | 8 | 489.33 ± 1.3% | 704.39 ± 0.9% | 1129.18 ± 0.5% | 62.94 ± 0.2% | 1624.28 ± 1.5% | 2821.63 ± 0.5% | refused | 490.49 ± 0.5% | 0.69 | 1.00 | 7.77 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29319.71 ± 0.1% | not timed | not timed | 33732.23 ± 0.8% | 2833.73 ± 12.1% | not timed | not timed | 29274.18 ± 0.9% | | 1.00 | 0.87 | 10.35 |
| 01-literal/sherlock-casei-en | 522 | 10677.94 ± 1.2% | not timed | not timed | 9028.84 ± 0.7% | 34.03 ± 11.3% | not timed | not timed | 10658.49 ± 0.6% | | 1.00 | 1.18 | 313.81 |
| 01-literal/sherlock-ru | 724 | 30396.47 ± 0.4% | not timed | not timed | 34074.50 ± 0.8% | 1279.19 ± 5.6% | not timed | not timed | 30346.09 ± 0.6% | | 1.00 | 0.89 | 23.76 |
| 01-literal/sherlock-casei-ru | 746 | 11865.26 ± 0.5% | not timed | not timed | 7810.15 ± 0.5% | 37.21 ± 1.9% | not timed | not timed | 11796.86 ± 0.4% | | 1.01 | 1.52 | 318.85 |
| 01-literal/sherlock-zh | 30 | 53139.13 ± 0.6% | not timed | not timed | 42971.39 ± 1.3% | 1629.95 ± 1.5% | not timed | not timed | 52983.68 ± 0.4% | | 1.00 | 1.24 | 32.60 |
| 02-literal-alternate/sherlock-en | 714 | 12692.62 ± 0.8% | not timed | not timed | 10910.54 ± 0.3% | 19.14 ± 1.2% | not timed | not timed | 12654.04 ± 0.2% | | 1.00 | 1.16 | 663.27 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4839.23 ± 7.5% | not timed | not timed | 2314.57 ± 0.6% | 12.32 ± 1.1% | not timed | not timed | 4421.61 ± 1.2% | | 1.09 | 2.09 | 392.93 |
| 02-literal-alternate/sherlock-ru | 899 | 10241.54 ± 0.6% | not timed | not timed | 9731.64 ± 0.4% | 25.52 ± 0.3% | not timed | not timed | 10184.87 ± 1.1% | | 1.01 | 1.05 | 401.38 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2467.46 ± 0.9% | not timed | not timed | 1185.35 ± 3.9% | 10.56 ± 3.8% | not timed | not timed | 2431.76 ± 1.9% | | 1.01 | 2.08 | 233.65 |
| 02-literal-alternate/sherlock-zh | 207 | 18435.59 ± 0.8% | not timed | not timed | 12599.20 ± 0.2% | 35.61 ± 1.5% | not timed | not timed | 18417.59 ± 0.1% | | 1.00 | 1.46 | 517.74 |
| 03-date/ascii | 111817 | 126.91 ± 1.6% | not timed | not timed | 99.65 ± 18.7% | 0.23 ± 3.3% | not timed | not timed | 126.96 ± 2.2% | | 1.00 | 1.27 | 558.39 |
| 04-ruff-noqa/real | 84 | 486.93 ± 0.7% | not timed | not timed | 508.46 ± 0.4% | 21.28 ± 2.0% | not timed | not timed | 489.22 ± 0.5% | | 1.00 | 0.96 | 22.88 |
| 04-ruff-noqa/tweaked | 44 | 586.00 ± 20.5% | not timed | not timed | 511.73 ± 0.2% | 370.32 ± 0.3% | not timed | not timed | 584.03 ± 1.2% | | 1.00 | 1.15 | 1.58 |
| 05-lexer-veryl/single | 124800 | 4.76 ± 1.8% | not timed | not timed | 5.52 ± 13.1% | 0.26 ± 3.1% | not timed | not timed | 4.67 ± 2.7% | | 1.02 | 0.86 | 18.32 |
| 06-cloud-flare-redos/original | 107 | 410.71 ± 1.5% | not timed | not timed | 225.79 ± 26.1% | 25.33 ± 0.7% | not timed | not timed | 410.79 ± 1.1% | | 1.00 | 1.82 | 16.22 |
| 06-cloud-flare-redos/simplified-short | 102 | 398.56 ± 0.9% | not timed | not timed | 233.90 ± 22.8% | 27.60 ± 14.6% | not timed | not timed | 397.65 ± 0.2% | | 1.00 | 1.70 | 14.44 |
| 06-cloud-flare-redos/simplified-long | 10000 | 510.52 ± 0.2% | not timed | not timed | 259.34 ± 0.4% | 29.85 ± 0.5% | not timed | not timed | 507.49 ± 0.1% | | 1.01 | 1.97 | 17.11 |
| 07-unicode-character-data/parse-line | 558784 | 246.95 ± 3.9% | not timed | not timed | 200.87 ± 8.4% | 47.34 ± 29.0% | not timed | not timed | 243.45 ± 4.2% | | 1.01 | 1.23 | 5.22 |
| 08-words/all-english | 56691 | 111.93 ± 0.7% | not timed | not timed | 83.52 ± 4.6% | 13.76 ± 15.4% | not timed | not timed | 111.84 ± 0.9% | | 1.00 | 1.34 | 8.13 |
| 08-words/long-english | 839 | 615.26 ± 0.6% | not timed | not timed | 585.11 ± 0.3% | 35.18 ± 18.0% | not timed | not timed | 614.67 ± 0.2% | | 1.00 | 1.05 | 17.49 |
| 09-aws-keys/full | 0 | 495.34 ± 0.1% | not timed | not timed | 541.50 ± 0.4% | 67.16 ± 2.9% | not timed | not timed | 495.87 ± 0.1% | | 1.00 | 0.91 | 7.38 |
| 09-aws-keys/quick | 0 | 917.01 ± 5.2% | not timed | not timed | 949.47 ± 3.2% | 414.31 ± 46.5% | not timed | not timed | 889.44 ± 0.5% | | 1.03 | 0.97 | 2.21 |
| 10-bounded-repeat/letters-en | 1833 | 679.54 ± 2.9% | not timed | not timed | 556.83 ± 0.9% | 22.67 ± 1.4% | not timed | not timed | 676.32 ± 17.1% | | 1.00 | 1.22 | 29.98 |
| 10-bounded-repeat/letters-ru | 3475 | 526.80 ± 1.4% | not timed | not timed | 470.94 ± 0.3% | 23.51 ± 29.3% | not timed | not timed | 523.34 ± 1.3% | | 1.01 | 1.12 | 22.41 |
| 10-bounded-repeat/context | 53 | 82.96 ± 4.2% | not timed | not timed | 68.87 ± 5.1% | 22.55 ± 0.9% | not timed | not timed | 83.18 ± 1.4% | | 1.00 | 1.20 | 3.68 |
| 10-bounded-repeat/capitals | 11 | 638.00 ± 8.0% | not timed | not timed | 605.23 ± 0.3% | 40.49 ± 1.2% | not timed | not timed | 637.23 ± 8.1% | | 1.00 | 1.05 | 15.76 |
| 11-unstructured-to-json/extract | 600 | 63.25 ± 0.6% | not timed | not timed | 80.66 ± 1.4% | 50.53 ± 19.9% | not timed | not timed | 63.32 ± 0.9% | | 1.00 | 0.78 | 1.25 |
| 12-dictionary/single | 1 | 510.19 ± 1.4% | not timed | not timed | 480.90 ± 0.2% | 0.38 ± 4.0% | not timed | not timed | 511.94 ± 3.8% | | 1.00 | 1.06 | 1337.93 |
| 14-quadratic/1x | 100 | 26.01 ± 1.4% | not timed | not timed | 12.19 ± 0.4% | 0.99 ± 2.8% | not timed | not timed | 26.13 ± 0.9% | | 1.00 | 2.13 | 26.24 |
| 14-quadratic/2x | 200 | 19.81 ± 0.8% | not timed | not timed | 6.13 ± 0.1% | 0.54 ± 1.9% | not timed | not timed | 19.92 ± 1.3% | | 0.99 | 3.23 | 36.67 |
| 14-quadratic/10x | 1000 | 6.86 ± 0.7% | not timed | not timed | 1.22 ± 0.2% | 0.12 ± 1.2% | not timed | not timed | 6.87 ± 0.5% | | 1.00 | 5.64 | 59.10 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.46 ± 0.5% | not timed | not timed | 0.48 ± 3.2% | 0.62 ± 4.6% | not timed | not timed | 1.46 ± 0.4% | | 1.00 | 3.08 | 2.36 |
| 04-ruff-noqa/compile-real | 1 | 108.94 ± 6.0% | not timed | not timed | 17.23 ± 0.7% | 169.30 ± 4.3% | not timed | not timed | 108.87 ± 1.2% | | 1.00 | 6.32 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 16.67 ± 1.4% | not timed | not timed | 3.01 ± 1.1% | 7.79 ± 1.8% | not timed | not timed | 16.48 ± 1.0% | | 1.01 | 5.54 | 2.14 |
| 07-unicode-character-data/compile | 1 | 65.09 ± 1.5% | not timed | not timed | 30.27 ± 6.7% | 43.62 ± 34.3% | not timed | not timed | 64.80 ± 1.9% | | 1.00 | 2.15 | 1.49 |
| 09-aws-keys/compile-full | 1 | 45.85 ± 5.3% | not timed | not timed | 9.94 ± 7.4% | 27.59 ± 1.8% | not timed | not timed | 45.29 ± 1.6% | | 1.01 | 4.61 | 1.66 |
| 09-aws-keys/compile-quick | 1 | 199.21 ± 1.1% | not timed | not timed | 58.76 ± 0.9% | 156.48 ± 3.1% | not timed | not timed | 197.63 ± 1.2% | | 1.01 | 3.39 | 1.27 |
| 10-bounded-repeat/compile-context | 1 | 15.28 ± 1.5% | not timed | not timed | 14.53 ± 4.6% | 20.26 ± 2.5% | not timed | not timed | 15.26 ± 1.5% | | 1.00 | 1.05 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 94.06 ± 1.1% | not timed | not timed | 10.67 ± 0.5% | 29.31 ± 2.9% | not timed | not timed | 93.81 ± 1.9% | | 1.00 | 8.82 | 3.21 |
| 11-unstructured-to-json/compile | 1 | 99.65 ± 1.5% | not timed | not timed | 47.75 ± 0.8% | 79.69 ± 3.4% | not timed | not timed | 98.77 ± 0.7% | | 1.01 | 2.09 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.8% | not timed | not timed | 0.08 ± 2.3% | 0.11 ± 15.4% | not timed | not timed | 0.34 ± 1.4% | | 1.01 | 4.36 | 3.13 |

