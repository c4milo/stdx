# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117681182 |
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
| literal: a word | 217 | 33033.24 ± 4.0% | 894.35 ± 0.2% | 19.85 ± 2.8% | 31058.10 ± 0.7% | 8840.10 ± 7.9% | 10.78 ± 0.4% | 75.39 ± 0.8% | 32296.49 ± 3.1% | 36.94 | 1.02 | 1.06 | 3.74 |
| literal: a word that is not there | 0 | 48828.04 ± 2.1% | 905.76 ± 0.2% | 20.00 ± 1.8% | 39318.70 ± 0.9% | 30031.54 ± 0.4% | 10.73 ± 0.7% | 71.43 ± 1.2% | 48311.50 ± 2.0% | 53.91 | 1.01 | 1.24 | 1.63 |
| literal: one of four words | 661 | 10966.61 ± 1.0% | 868.57 ± 0.9% | 10.92 ± 2.8% | 9124.12 ± 1.2% | 19.12 ± 4.9% | 3.99 ± 0.4% | 6.44 ± 1.2% | 10992.64 ± 0.8% | 12.63 | 1.00 | 1.20 | 573.70 |
| literal: a word in any case | 217 | 25442.00 ± 5.9% | 882.82 ± 1.3% | 14.78 ± 2.7% | 9180.60 ± 2.2% | 37.01 ± 3.2% | refused | differs | 25280.12 ± 2.0% | 28.82 | 1.01 | 2.77 | 687.53 |
| literal: an href attribute | 33 | 26273.02 ± 2.5% | 901.33 ± 0.1% | 18.23 ± 1.7% | 27191.13 ± 0.6% | 2051.85 ± 1.2% | 8.24 ± 0.2% | 60.30 ± 1.2% | 26392.85 ± 6.1% | 29.15 | 1.00 | 0.97 | 12.80 |
| literal: a word, second text | 123 | 33575.23 ± 7.9% | 898.42 ± 0.3% | 19.48 ± 1.7% | 31615.34 ± 1.1% | 7163.14 ± 10.7% | 11.87 ± 0.5% | 65.13 ± 11.6% | 33053.89 ± 1.3% | 37.37 | 1.02 | 1.06 | 4.69 |
| class: two capitalized words | 1331 | 780.09 ± 2.1% | 813.50 ± 0.7% | 18.64 ± 2.0% | 505.53 ± 0.1% | 34.37 ± 7.5% | 9.33 ± 0.7% | 54.86 ± 0.3% | 776.56 ± 0.2% | 0.96 | 1.00 | 1.54 | 22.70 |
| class: a word that ends in ing | 3399 | 737.73 ± 0.3% | 738.22 ± 0.2% | 12.90 ± 1.1% | 472.99 ± 0.3% | 25.66 ± 6.2% | 5.35 ± 0.6% | 15.74 ± 1.8% | 737.71 ± 0.9% | 1.00 | 1.00 | 1.56 | 28.75 |
| class: a word in capitals | 2332 | 986.86 ± 0.5% | 797.29 ± 1.5% | 19.71 ± 2.4% | 496.86 ± 0.6% | 36.69 ± 8.4% | 10.40 ± 0.3% | 76.30 ± 0.3% | 983.87 ± 0.6% | 1.24 | 1.00 | 1.99 | 26.90 |
| class: a number | 8288 | 1401.05 ± 0.6% | 652.45 ± 0.3% | 19.32 ± 2.9% | 1482.67 ± 0.2% | 33.07 ± 14.2% | 0.33 ± 0.3% | 54.17 ± 1.2% | 1397.05 ± 0.4% | 2.15 | 1.00 | 0.94 | 42.37 |
| class: two capitalized words, second text | 5359 | 582.71 ± 0.2% | 582.44 ± 0.1% | 17.02 ± 9.7% | 418.38 ± 0.2% | 29.62 ± 6.3% | 10.60 ± 0.2% | 50.39 ± 0.9% | 581.84 ± 3.1% | 1.00 | 1.00 | 1.39 | 19.67 |
| other: a word between two words | 6104 | 649.22 ± 0.1% | 621.56 ± 0.2% | 16.80 ± 7.6% | 686.07 ± 0.8% | 97.59 ± 18.1% | 7.27 ± 0.3% | 55.46 ± 10.5% | 644.66 ± 0.3% | 1.04 | 1.01 | 0.95 | 6.65 |
| other: a number before a unit, second text | 1481 | 6835.15 ± 0.5% | 827.19 ± 1.5% | 18.50 ± 1.2% | 6416.08 ± 0.7% | 35.23 ± 7.5% | 10.99 ± 0.3% | 53.75 ± 11.0% | 6804.13 ± 0.2% | 8.26 | 1.00 | 1.07 | 193.99 |
| other: a heading's start tag | 110 | 18862.30 ± 1.7% | 893.82 ± 0.1% | 19.20 ± 2.9% | 2009.08 ± 0.9% | 1486.77 ± 8.4% | 10.05 ± 0.6% | 71.31 ± 6.8% | 18747.57 ± 1.2% | 21.10 | 1.01 | 9.39 | 12.69 |
| other: a whole word | 217 | 22655.02 ± 9.0% | 891.95 ± 1.5% | 19.60 ± 3.5% | 22414.71 ± 16.4% | 39.75 ± 10.2% | 9.43 ± 1.4% | 46.46 ± 0.7% | 22279.48 ± 9.8% | 25.40 | 1.02 | 1.01 | 570.00 |
| other: a line's first word, second text | 3716 | 1744.79 ± 0.7% | 719.75 ± 1.1% | 21.66 ± 1.6% | 1702.58 ± 8.6% | 53.32 ± 4.9% | refused | refused | 1754.66 ± 0.4% | 2.42 | 0.99 | 1.02 | 32.72 |
| other: fourteen octets before an x | 87 | 25010.75 ± 0.9% | 193.89 ± 0.8% | 5.01 ± 0.5% | 2925.97 ± 0.8% | 9.02 ± 0.3% | differs | 15.10 ± 3.1% | 24950.49 ± 1.7% | 129.00 | 1.00 | 8.55 | 2772.38 |
| other: a Greek word | 21815 | 412.88 ± 0.6% | 269.11 ± 0.2% | 22.84 ± 4.4% | 265.57 ± 0.3% | 39.17 ± 8.2% | differs | refused | 412.49 ± 0.4% | 1.53 | 1.00 | 1.55 | 10.54 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.70 ± 1.3% | 24.71 ± 9.3% | 0.72 ± 7.6% | 16.85 ± 0.3% | 1.72 ± 0.3% | differs | 3.41 ± 2.8% | 24.82 ± 1.1% | 1.00 | 1.00 | 1.47 | 14.35 |
| a UUID | 32895 | 20.71 ± 0.2% | 19.81 ± 0.6% | 0.56 ± 1.3% | 12.89 ± 0.2% | 2.50 ± 7.2% | 0.44 ± 0.3% | 2.98 ± 18.3% | 20.66 ± 0.2% | 1.05 | 1.00 | 1.61 | 8.28 |
| an IPv4 address | 33176 | 34.58 ± 0.8% | 34.02 ± 13.1% | 1.81 ± 2.2% | 24.11 ± 0.6% | 5.78 ± 1.1% | differs | 3.36 ± 3.6% | 34.59 ± 0.4% | 1.02 | 1.00 | 1.43 | 5.98 |
| a date and time | 32954 | 29.94 ± 0.1% | 30.78 ± 10.2% | 1.25 ± 1.7% | 18.06 ± 0.4% | 6.67 ± 1.2% | 0.76 ± 0.5% | 5.64 ± 5.4% | 30.80 ± 0.3% | 0.97 | 0.97 | 1.66 | 4.49 |
| a field path | 32606 | 27.35 ± 1.4% | 27.33 ± 10.4% | 0.88 ± 1.6% | 19.45 ± 0.5% | 2.92 ± 0.8% | differs | 2.37 ± 0.3% | 27.42 ± 0.5% | 1.00 | 1.00 | 1.41 | 9.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.17 ± 1.4% | 8.22 ± 0.6% | 8.15 ± 0.3% | 9.97 ± 0.3% | 4.75 ± 8.3% | 0.62 ± 0.3% | none | 8.22 ± 4.3% | 0.99 | 0.99 | 0.82 | 1.72 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 182.99 ± 0.6% | 183.70 ± 1.8% | 211.54 ± 0.5% | 80.73 ± 4.5% | 183.03 ± 3.4% | 530.87 ± 2.8% | 3876.03 ± 0.7% | 183.00 ± 2.7% | 1.00 | 1.00 | 2.27 | 1.00 |
| a UUID | 62 | 120.39 ± 0.2% | 120.73 ± 0.6% | 132.99 ± 9.5% | 46.08 ± 0.9% | 89.93 ± 1.9% | 198.79 ± 2.0% | 4032.59 ± 1.4% | 120.36 ± 9.9% | 1.00 | 1.00 | 2.61 | 1.34 |
| an IPv4 address | 29 | 388.91 ± 1.0% | 393.56 ± 6.8% | 548.27 ± 3.7% | 70.61 ± 1.0% | 111.93 ± 4.5% | 318.23 ± 1.3% | 7000.51 ± 1.3% | 388.79 ± 2.7% | 0.99 | 1.00 | 5.51 | 3.47 |
| a date and time | 56 | 282.10 ± 0.4% | 283.63 ± 1.0% | 354.38 ± 0.7% | 68.49 ± 1.2% | 122.24 ± 7.8% | 373.07 ± 1.5% | 4138.49 ± 0.8% | 282.26 ± 0.6% | 0.99 | 1.00 | 4.12 | 2.31 |
| a field path | 39 | 181.21 ± 0.3% | 182.03 ± 1.3% | 208.44 ± 0.2% | 74.31 ± 2.7% | 173.63 ± 3.9% | 577.38 ± 1.8% | 4649.24 ± 0.5% | 180.94 ± 0.7% | 1.00 | 1.00 | 2.44 | 1.04 |
| literal: a word | 7 | 587.99 ± 0.8% | 637.11 ± 0.8% | 1149.65 ± 0.3% | 495.21 ± 1.7% | 575.64 ± 1.4% | 1246.97 ± 1.2% | 24759.62 ± 0.4% | 588.68 ± 0.5% | 0.92 | 1.00 | 1.19 | 1.02 |
| literal: a word that is not there | 8 | 564.94 ± 0.6% | 612.92 ± 0.7% | 1077.81 ± 0.4% | 463.76 ± 0.7% | 560.59 ± 3.3% | 1178.14 ± 1.0% | 21098.39 ± 3.2% | 565.74 ± 0.5% | 0.92 | 1.00 | 1.22 | 1.01 |
| literal: one of four words | 26 | 223.22 ± 0.4% | 362.16 ± 0.5% | 486.59 ± 0.3% | 41.81 ± 1.3% | 222.12 ± 3.6% | 450.40 ± 0.4% | 10559.66 ± 0.1% | 223.75 ± 0.5% | 0.62 | 1.00 | 5.34 | 1.00 |
| literal: a word in any case | 11 | 449.68 ± 0.4% | 482.15 ± 0.2% | 736.97 ± 0.5% | 14.27 ± 2.7% | 607.91 ± 17.4% | refused | 19173.96 ± 0.3% | 447.90 ± 0.6% | 0.93 | 1.00 | 31.52 | 0.74 |
| literal: an href attribute | 12 | 317.61 ± 2.3% | 331.82 ± 2.6% | 439.36 ± 2.8% | 36.81 ± 4.8% | 418.67 ± 12.7% | 923.47 ± 10.4% | 18021.15 ± 2.4% | 317.32 ± 2.4% | 0.96 | 1.00 | 8.63 | 0.76 |
| literal: a word, second text | 10 | 523.32 ± 0.5% | 576.35 ± 0.4% | 964.49 ± 0.6% | 418.05 ± 0.5% | 485.29 ± 1.3% | 1005.18 ± 0.5% | 20545.27 ± 0.4% | 522.51 ± 0.8% | 0.91 | 1.00 | 1.25 | 1.08 |
| class: two capitalized words | 23 | 416.56 ± 1.1% | 442.77 ± 1.9% | 642.06 ± 2.6% | 96.26 ± 2.0% | 440.04 ± 4.2% | 901.22 ± 1.1% | 6183.36 ± 0.5% | 416.81 ± 0.5% | 0.94 | 1.00 | 4.33 | 0.95 |
| class: a word that ends in ing | 9 | 511.60 ± 0.5% | 571.32 ± 0.4% | 1005.02 ± 1.2% | 115.98 ± 2.2% | 638.48 ± 2.9% | 1376.49 ± 0.7% | 15177.26 ± 0.2% | 512.03 ± 0.6% | 0.90 | 1.00 | 4.41 | 0.80 |
| class: a word in capitals | 16 | 447.51 ± 0.6% | 478.79 ± 1.0% | 789.28 ± 0.4% | 123.39 ± 1.7% | 669.59 ± 2.4% | 1265.10 ± 1.6% | 8288.78 ± 17.7% | 447.44 ± 7.2% | 0.93 | 1.00 | 3.63 | 0.67 |
| class: a number | 6 | 565.52 ± 11.8% | 618.41 ± 0.6% | 1188.70 ± 12.9% | 36.62 ± 0.9% | 1188.22 ± 2.4% | 2145.31 ± 6.6% | 20568.68 ± 0.4% | 565.32 ± 0.4% | 0.91 | 1.00 | 15.44 | 0.48 |
| class: two capitalized words, second text | 23 | 417.08 ± 0.9% | 440.85 ± 8.5% | 647.63 ± 3.1% | 95.64 ± 1.4% | 453.14 ± 11.2% | 936.56 ± 5.1% | 6202.48 ± 0.1% | 416.93 ± 0.4% | 0.95 | 1.00 | 4.36 | 0.92 |
| other: a word between two words | 13 | 496.70 ± 1.3% | 516.29 ± 10.8% | 812.39 ± 6.1% | 124.24 ± 3.6% | 431.79 ± 3.8% | 1010.40 ± 0.9% | 13262.66 ± 0.4% | 495.88 ± 1.3% | 0.96 | 1.00 | 4.00 | 1.15 |
| other: a number before a unit, second text | 15 | 358.10 ± 0.4% | 392.50 ± 0.3% | 540.01 ± 0.4% | 33.94 ± 2.9% | 541.20 ± 1.5% | 1084.02 ± 3.0% | 13614.02 ± 1.4% | 357.91 ± 0.2% | 0.91 | 1.00 | 10.55 | 0.66 |
| other: a heading's start tag | 13 | 331.54 ± 0.6% | 339.64 ± 1.0% | 449.77 ± 0.2% | 34.69 ± 13.2% | 517.65 ± 2.0% | 1012.60 ± 5.1% | 16056.43 ± 1.7% | 331.80 ± 0.4% | 0.98 | 1.00 | 9.56 | 0.64 |
| other: a whole word | 11 | 487.97 ± 10.0% | 542.63 ± 2.5% | 878.15 ± 0.7% | 110.92 ± 0.7% | 510.87 ± 2.7% | 983.51 ± 2.1% | 19672.60 ± 1.0% | 504.73 ± 7.0% | 0.90 | 0.97 | 4.40 | 0.96 |
| other: a line's first word, second text | 17 | 486.33 ± 0.2% | 509.92 ± 1.7% | 833.97 ± 0.6% | 116.34 ± 0.5% | 602.49 ± 2.5% | refused | refused | 486.67 ± 2.0% | 0.95 | 1.00 | 4.18 | 0.81 |
| other: fourteen octets before an x | 16 | 87.63 ± 13.5% | 124.18 ± 0.1% | 143.19 ± 0.3% | 13.91 ± 1.0% | 393.85 ± 2.2% | 450.04 ± 2.2% | 12015.96 ± 0.7% | 87.74 ± 0.2% | 0.71 | 1.00 | 6.30 | 0.22 |
| other: a Greek word | 8 | 386.11 ± 0.5% | 512.02 ± 0.3% | 861.57 ± 2.3% | 46.08 ± 2.2% | 1177.61 ± 3.3% | 2043.86 ± 1.4% | refused | 385.54 ± 7.7% | 0.75 | 1.00 | 8.38 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21052.66 ± 2.0% | not timed | not timed | 26916.06 ± 1.1% | 1954.95 ± 19.6% | not timed | not timed | 21084.68 ± 1.1% | | 1.00 | 0.78 | 10.77 |
| 01-literal/sherlock-casei-en | 522 | 4653.89 ± 0.5% | not timed | not timed | 7030.91 ± 0.5% | 28.48 ± 13.0% | not timed | not timed | 4655.34 ± 0.8% | | 1.00 | 0.66 | 163.41 |
| 01-literal/sherlock-ru | 724 | 22499.50 ± 2.7% | not timed | not timed | 27690.76 ± 0.9% | 1088.85 ± 7.3% | not timed | not timed | 22672.33 ± 1.3% | | 0.99 | 0.81 | 20.66 |
| 01-literal/sherlock-casei-ru | 746 | 7310.10 ± 1.5% | not timed | not timed | 5501.81 ± 0.9% | 30.40 ± 0.8% | not timed | not timed | 7285.42 ± 0.3% | | 1.00 | 1.33 | 240.43 |
| 01-literal/sherlock-zh | 30 | 42153.21 ± 32.4% | not timed | not timed | 36733.68 ± 1.7% | 1260.84 ± 1.2% | not timed | not timed | 41794.31 ± 0.4% | | 1.01 | 1.15 | 33.43 |
| 02-literal-alternate/sherlock-en | 714 | 9510.73 ± 0.8% | not timed | not timed | 8937.46 ± 0.4% | 14.42 ± 4.0% | not timed | not timed | 9499.59 ± 0.9% | | 1.00 | 1.06 | 659.74 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1732.67 ± 7.0% | not timed | not timed | 1815.60 ± 0.6% | 9.27 ± 0.7% | not timed | not timed | 1715.24 ± 0.5% | | 1.01 | 0.95 | 186.83 |
| 02-literal-alternate/sherlock-ru | 899 | 5942.04 ± 0.4% | not timed | not timed | 4266.86 ± 0.4% | 19.66 ± 1.6% | not timed | not timed | 5960.12 ± 0.5% | | 1.00 | 1.39 | 302.21 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1801.23 ± 0.6% | not timed | not timed | 1041.58 ± 9.9% | 8.55 ± 1.2% | not timed | not timed | 1800.41 ± 8.4% | | 1.00 | 1.73 | 210.58 |
| 02-literal-alternate/sherlock-zh | 207 | 13749.98 ± 4.1% | not timed | not timed | 10460.79 ± 5.1% | 26.98 ± 14.0% | not timed | not timed | 13782.72 ± 0.4% | | 1.00 | 1.31 | 509.64 |
| 03-date/ascii | 111817 | 102.20 ± 2.7% | not timed | not timed | 84.71 ± 3.0% | 0.18 ± 1.9% | not timed | not timed | 102.82 ± 4.0% | | 0.99 | 1.21 | 583.60 |
| 04-ruff-noqa/real | 84 | 565.56 ± 0.4% | not timed | not timed | 425.68 ± 6.8% | 14.72 ± 28.5% | not timed | not timed | 562.91 ± 0.3% | | 1.00 | 1.33 | 38.41 |
| 04-ruff-noqa/tweaked | 44 | 449.84 ± 0.2% | not timed | not timed | 419.73 ± 1.7% | 287.90 ± 4.9% | not timed | not timed | 449.34 ± 0.2% | | 1.00 | 1.07 | 1.56 |
| 05-lexer-veryl/single | 124800 | 2.87 ± 0.8% | not timed | not timed | 4.22 ± 1.1% | 0.21 ± 3.2% | not timed | not timed | 2.86 ± 0.4% | | 1.00 | 0.68 | 13.68 |
| 06-cloud-flare-redos/original | 107 | 184.07 ± 0.9% | not timed | not timed | 191.50 ± 3.5% | 13.08 ± 10.7% | not timed | not timed | 183.29 ± 1.1% | | 1.00 | 0.96 | 14.07 |
| 06-cloud-flare-redos/simplified-short | 102 | 127.83 ± 2.0% | not timed | not timed | 192.67 ± 0.6% | 14.03 ± 1.3% | not timed | not timed | 127.03 ± 2.5% | | 1.01 | 0.66 | 9.11 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.48 ± 7.2% | not timed | not timed | 211.56 ± 0.2% | 14.84 ± 0.3% | not timed | not timed | 136.34 ± 5.1% | | 1.00 | 0.65 | 9.20 |
| 07-unicode-character-data/parse-line | 558784 | 194.37 ± 4.2% | not timed | not timed | 158.50 ± 8.8% | 37.86 ± 10.8% | not timed | not timed | 193.07 ± 2.6% | | 1.01 | 1.23 | 5.13 |
| 08-words/all-english | 56691 | 73.40 ± 0.5% | not timed | not timed | 73.24 ± 0.4% | 9.79 ± 8.4% | not timed | not timed | 73.24 ± 8.0% | | 1.00 | 1.00 | 7.50 |
| 08-words/long-english | 839 | 845.56 ± 0.1% | not timed | not timed | 514.85 ± 0.4% | 25.61 ± 28.0% | not timed | not timed | 849.83 ± 0.4% | | 0.99 | 1.64 | 33.01 |
| 09-aws-keys/full | 0 | 421.09 ± 9.2% | not timed | not timed | 451.80 ± 0.6% | 53.39 ± 7.0% | not timed | not timed | 432.23 ± 1.0% | | 0.97 | 0.93 | 7.89 |
| 09-aws-keys/quick | 0 | 812.70 ± 0.7% | not timed | not timed | 805.05 ± 0.6% | 330.08 ± 11.5% | not timed | not timed | 811.97 ± 0.6% | | 1.00 | 1.01 | 2.46 |
| 10-bounded-repeat/letters-en | 1833 | 467.74 ± 0.4% | not timed | not timed | 432.70 ± 2.7% | 17.07 ± 0.8% | not timed | not timed | 467.88 ± 0.5% | | 1.00 | 1.08 | 27.41 |
| 10-bounded-repeat/letters-ru | 3475 | 322.28 ± 5.9% | not timed | not timed | 408.18 ± 0.4% | 19.35 ± 12.3% | not timed | not timed | 322.47 ± 4.0% | | 1.00 | 0.79 | 16.66 |
| 10-bounded-repeat/context | 53 | 65.62 ± 7.6% | not timed | not timed | 56.16 ± 5.9% | 16.94 ± 2.9% | not timed | not timed | 65.42 ± 8.0% | | 1.00 | 1.17 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 886.82 ± 1.7% | not timed | not timed | 532.53 ± 1.3% | 30.98 ± 8.5% | not timed | not timed | 895.71 ± 1.8% | | 0.99 | 1.67 | 28.63 |
| 11-unstructured-to-json/extract | 600 | 35.69 ± 0.2% | not timed | not timed | 62.55 ± 0.9% | 23.27 ± 1.8% | not timed | not timed | 35.61 ± 0.8% | | 1.00 | 0.57 | 1.53 |
| 12-dictionary/single | 1 | 460.15 ± 0.2% | not timed | not timed | 441.06 ± 2.4% | 0.33 ± 1.6% | not timed | not timed | 462.47 ± 0.4% | | 0.99 | 1.04 | 1411.64 |
| 14-quadratic/1x | 100 | 11.23 ± 0.7% | not timed | not timed | 9.11 ± 0.4% | 0.81 ± 3.4% | not timed | not timed | 11.08 ± 2.3% | | 1.01 | 1.23 | 13.88 |
| 14-quadratic/2x | 200 | 6.85 ± 0.6% | not timed | not timed | 4.91 ± 0.2% | 0.43 ± 1.7% | not timed | not timed | 6.81 ± 0.4% | | 1.01 | 1.39 | 15.81 |
| 14-quadratic/10x | 1000 | 1.59 ± 0.5% | not timed | not timed | 1.05 ± 0.4% | 0.09 ± 0.8% | not timed | not timed | 1.59 ± 1.2% | | 1.00 | 1.51 | 16.85 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 0.6% | not timed | not timed | 0.38 ± 0.8% | 0.48 ± 4.1% | not timed | not timed | 1.33 ± 1.5% | | 1.00 | 3.48 | 2.80 |
| 04-ruff-noqa/compile-real | 1 | 78.90 ± 1.0% | not timed | not timed | 12.90 ± 0.9% | 125.74 ± 3.0% | not timed | not timed | 77.74 ± 1.5% | | 1.01 | 6.12 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 12.83 ± 0.6% | not timed | not timed | 2.34 ± 0.3% | 5.86 ± 3.1% | not timed | not timed | 12.82 ± 0.5% | | 1.00 | 5.47 | 2.19 |
| 07-unicode-character-data/compile | 1 | 49.95 ± 0.5% | not timed | not timed | 24.09 ± 0.6% | 32.90 ± 1.8% | not timed | not timed | 49.82 ± 1.2% | | 1.00 | 2.07 | 1.52 |
| 09-aws-keys/compile-full | 1 | 34.00 ± 1.8% | not timed | not timed | 7.34 ± 0.3% | 19.98 ± 4.0% | not timed | not timed | 34.31 ± 1.5% | | 0.99 | 4.63 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 158.09 ± 0.4% | not timed | not timed | 46.30 ± 0.5% | 118.30 ± 3.7% | not timed | not timed | 157.68 ± 1.0% | | 1.00 | 3.41 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 10.57 ± 1.3% | not timed | not timed | 11.62 ± 2.5% | 15.09 ± 2.2% | not timed | not timed | 10.54 ± 0.4% | | 1.00 | 0.91 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 73.27 ± 0.3% | not timed | not timed | 8.63 ± 3.4% | 21.89 ± 11.1% | not timed | not timed | 73.14 ± 1.9% | | 1.00 | 8.49 | 3.35 |
| 11-unstructured-to-json/compile | 1 | 76.01 ± 0.3% | not timed | not timed | 37.25 ± 2.3% | 55.96 ± 76.2% | not timed | not timed | 75.40 ± 2.3% | | 1.01 | 2.04 | 1.36 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.4% | not timed | not timed | 0.07 ± 42.5% | 0.08 ± 12.6% | not timed | not timed | 0.28 ± 4.5% | | 1.01 | 4.34 | 3.73 |

