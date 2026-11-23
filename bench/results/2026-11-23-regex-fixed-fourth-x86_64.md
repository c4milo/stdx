# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159257799 |
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
| literal: a word | 217 | 28639.84 ± 0.4% | 901.63 ± 0.9% | 28.24 ± 0.6% | 26205.14 ± 0.4% | 8572.55 ± 42.0% | 12.30 ± 36.6% | 88.61 ± 0.6% | 28608.77 ± 0.4% | 31.76 | 1.00 | 1.09 | 3.34 |
| literal: a word that is not there | 0 | 35085.12 ± 0.4% | 913.10 ± 2.1% | 28.26 ± 0.8% | 29323.63 ± 4.0% | 23832.80 ± 0.6% | 12.05 ± 0.2% | 84.11 ± 1.0% | 35125.49 ± 0.4% | 38.42 | 1.00 | 1.20 | 1.47 |
| literal: one of four words | 661 | 10833.76 ± 2.5% | 861.97 ± 0.7% | 14.77 ± 0.8% | 7980.29 ± 0.9% | 21.05 ± 1.6% | 3.72 ± 0.7% | 6.65 ± 0.7% | 10747.71 ± 3.0% | 12.57 | 1.01 | 1.36 | 514.67 |
| literal: a word in any case | 217 | 23653.04 ± 1.1% | 892.64 ± 0.9% | 19.96 ± 0.8% | 8217.05 ± 2.0% | 40.80 ± 0.6% | refused | differs | 23626.67 ± 0.7% | 26.50 | 1.00 | 2.88 | 579.76 |
| literal: an href attribute | 33 | 22884.26 ± 1.1% | 904.79 ± 1.1% | 25.28 ± 0.6% | 23457.30 ± 0.7% | 1904.16 ± 0.2% | 8.91 ± 0.2% | 78.31 ± 0.4% | 22684.18 ± 1.0% | 25.29 | 1.01 | 0.98 | 12.02 |
| literal: a word, second text | 123 | 29022.32 ± 4.0% | 912.63 ± 1.0% | 27.73 ± 1.1% | 25626.35 ± 0.9% | 6693.73 ± 7.3% | 15.24 ± 0.3% | 76.51 ± 0.1% | 29103.92 ± 0.6% | 31.80 | 1.00 | 1.13 | 4.34 |
| class: two capitalized words | 1331 | 871.52 ± 0.3% | 858.68 ± 0.5% | 25.74 ± 3.5% | 545.69 ± 0.5% | 36.58 ± 0.3% | 10.51 ± 0.1% | 66.39 ± 2.9% | 869.95 ± 0.2% | 1.01 | 1.00 | 1.60 | 23.83 |
| class: a word that ends in ing | 3399 | 756.33 ± 1.0% | 755.61 ± 0.3% | 16.83 ± 0.6% | 504.05 ± 0.4% | 26.92 ± 2.8% | 5.88 ± 1.3% | 18.90 ± 0.4% | 755.36 ± 0.4% | 1.00 | 1.00 | 1.50 | 28.10 |
| class: a word in capitals | 2332 | 1135.60 ± 0.3% | 830.13 ± 0.7% | 27.33 ± 0.3% | 536.85 ± 0.1% | 39.30 ± 7.7% | 12.39 ± 0.1% | 83.29 ± 0.2% | 1130.39 ± 0.9% | 1.37 | 1.00 | 2.12 | 28.90 |
| class: a number | 8288 | 1590.49 ± 3.0% | 705.29 ± 0.2% | 26.79 ± 0.5% | 1588.01 ± 1.1% | 39.39 ± 11.9% | 0.36 ± 0.3% | 61.18 ± 1.1% | 1577.43 ± 0.1% | 2.26 | 1.01 | 1.00 | 40.38 |
| class: two capitalized words, second text | 5359 | 620.54 ± 2.2% | 626.38 ± 0.7% | 23.25 ± 0.5% | 442.18 ± 0.2% | 31.69 ± 9.9% | 13.22 ± 0.6% | 61.24 ± 0.3% | 624.12 ± 0.9% | 0.99 | 0.99 | 1.40 | 19.58 |
| other: a word between two words | 6104 | 735.56 ± 0.4% | 659.75 ± 0.4% | 22.79 ± 1.4% | 730.86 ± 0.4% | 103.72 ± 10.3% | 8.02 ± 0.1% | 69.65 ± 0.3% | 735.97 ± 0.3% | 1.11 | 1.00 | 1.01 | 7.09 |
| other: a number before a unit, second text | 1481 | 7514.80 ± 4.3% | 845.10 ± 3.7% | 26.08 ± 1.0% | 7014.09 ± 0.3% | 37.10 ± 4.5% | 13.93 ± 0.2% | 65.07 ± 2.7% | 7395.90 ± 4.5% | 8.89 | 1.02 | 1.07 | 202.57 |
| other: a heading's start tag | 110 | 18316.67 ± 5.5% | 916.27 ± 0.4% | 27.18 ± 0.6% | 2036.18 ± 0.4% | 1368.22 ± 4.7% | 10.88 ± 2.4% | 89.99 ± 0.4% | 18304.64 ± 1.1% | 19.99 | 1.00 | 9.00 | 13.39 |
| other: a whole word | 217 | 21431.94 ± 0.3% | 897.59 ± 1.5% | 29.13 ± 0.6% | 20279.86 ± 0.4% | 45.99 ± 8.4% | 10.46 ± 0.3% | 53.27 ± 0.4% | 21380.08 ± 1.2% | 23.88 | 1.00 | 1.06 | 466.01 |
| other: a line's first word, second text | 3716 | 2025.95 ± 0.7% | 738.34 ± 0.4% | 29.74 ± 0.9% | 1891.06 ± 0.6% | 59.86 ± 1.7% | refused | refused | 2013.43 ± 0.6% | 2.74 | 1.01 | 1.07 | 33.85 |
| other: fourteen octets before an x | 87 | 28906.13 ± 2.8% | 261.38 ± 0.5% | 6.17 ± 0.3% | 3511.04 ± 0.1% | 8.99 ± 0.8% | differs | 17.54 ± 0.4% | 28694.83 ± 1.5% | 110.59 | 1.01 | 8.23 | 3214.56 |
| other: a Greek word | 21815 | 432.24 ± 0.6% | 347.16 ± 0.6% | 30.12 ± 0.1% | 260.34 ± 0.5% | 42.41 ± 22.1% | differs | refused | 430.96 ± 0.3% | 1.25 | 1.00 | 1.66 | 10.19 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.20 ± 0.2% | 23.39 ± 0.5% | 0.87 ± 0.7% | 18.67 ± 0.1% | 2.42 ± 0.8% | differs | 4.16 ± 0.4% | 23.39 ± 0.2% | 0.99 | 0.99 | 1.24 | 9.59 |
| a UUID | 32895 | 19.71 ± 0.4% | 19.67 ± 0.8% | 0.60 ± 2.1% | 14.42 ± 0.1% | 2.50 ± 0.4% | 0.54 ± 0.1% | 3.17 ± 0.1% | 19.78 ± 0.7% | 1.00 | 1.00 | 1.37 | 7.88 |
| an IPv4 address | 33176 | 31.71 ± 0.4% | 32.12 ± 0.3% | 1.97 ± 0.4% | 26.36 ± 0.2% | 5.96 ± 0.4% | differs | 3.89 ± 1.0% | 32.05 ± 0.3% | 0.99 | 0.99 | 1.20 | 5.32 |
| a date and time | 32954 | 27.69 ± 0.8% | 27.83 ± 1.0% | 1.37 ± 1.0% | 20.33 ± 0.1% | 7.21 ± 0.4% | 0.94 ± 0.1% | 7.44 ± 0.1% | 27.67 ± 0.9% | 1.00 | 1.00 | 1.36 | 3.84 |
| a field path | 32606 | 26.00 ± 0.3% | 26.11 ± 0.4% | 0.98 ± 1.2% | 21.29 ± 0.1% | 2.85 ± 0.3% | differs | 2.52 ± 0.6% | 26.11 ± 0.4% | 1.00 | 1.00 | 1.22 | 9.13 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.99 ± 0.6% | 8.01 ± 0.4% | 8.02 ± 0.5% | 11.51 ± 0.3% | 4.70 ± 11.2% | 0.76 ± 4.4% | none | 7.90 ± 0.3% | 1.00 | 1.01 | 0.69 | 1.70 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.07 ± 0.5% | 234.20 ± 0.3% | 276.39 ± 9.1% | 85.78 ± 4.1% | 185.30 ± 5.6% | 548.30 ± 3.0% | 3528.32 ± 0.6% | 233.30 ± 0.8% | 1.00 | 1.00 | 2.73 | 1.26 |
| a UUID | 62 | 153.64 ± 9.4% | 155.67 ± 0.9% | 173.74 ± 0.6% | 47.14 ± 0.9% | 88.20 ± 9.5% | 195.72 ± 2.8% | 4404.07 ± 0.3% | 153.60 ± 1.2% | 0.99 | 1.00 | 3.26 | 1.74 |
| an IPv4 address | 29 | 434.22 ± 6.7% | 440.05 ± 7.0% | 604.92 ± 0.3% | 74.90 ± 1.3% | 115.32 ± 0.7% | 328.96 ± 1.6% | 7645.55 ± 10.2% | 435.19 ± 0.3% | 0.99 | 1.00 | 5.80 | 3.77 |
| a date and time | 56 | 336.21 ± 0.7% | 337.95 ± 6.2% | 427.44 ± 0.2% | 71.04 ± 1.3% | 120.07 ± 1.4% | 350.65 ± 9.0% | 4479.45 ± 10.8% | 336.13 ± 0.2% | 0.99 | 1.00 | 4.73 | 2.80 |
| a field path | 39 | 234.48 ± 0.7% | 235.42 ± 0.3% | 275.49 ± 8.7% | 76.97 ± 9.0% | 173.62 ± 20.6% | 559.76 ± 1.4% | 4479.50 ± 0.4% | 234.17 ± 1.0% | 1.00 | 1.00 | 3.05 | 1.35 |
| literal: a word | 7 | 678.34 ± 5.7% | 727.44 ± 1.4% | 1237.20 ± 0.2% | 494.15 ± 0.6% | 543.09 ± 2.5% | 1216.44 ± 0.6% | 28512.03 ± 0.7% | 679.45 ± 0.2% | 0.93 | 1.00 | 1.37 | 1.25 |
| literal: a word that is not there | 8 | 650.29 ± 0.1% | 701.88 ± 0.2% | 1164.61 ± 9.9% | 462.40 ± 5.9% | 521.41 ± 2.4% | 1141.51 ± 0.9% | 27693.82 ± 0.4% | 649.57 ± 0.5% | 0.93 | 1.00 | 1.41 | 1.25 |
| literal: one of four words | 26 | 253.29 ± 0.3% | 410.27 ± 3.8% | 544.92 ± 8.5% | 41.16 ± 4.1% | 211.13 ± 6.2% | 437.02 ± 6.7% | 16526.07 ± 4.8% | 253.17 ± 7.3% | 0.62 | 1.00 | 6.15 | 1.20 |
| literal: a word in any case | 11 | 542.17 ± 0.5% | 584.58 ± 0.4% | 882.60 ± 0.3% | 14.09 ± 1.4% | 556.94 ± 13.8% | refused | 22434.22 ± 16.7% | 541.83 ± 9.1% | 0.93 | 1.00 | 38.48 | 0.97 |
| literal: an href attribute | 12 | 352.84 ± 0.3% | 365.16 ± 0.1% | 474.81 ± 8.9% | 37.48 ± 0.9% | 422.30 ± 5.1% | 923.93 ± 3.2% | 20881.27 ± 0.3% | 352.72 ± 1.5% | 0.97 | 1.00 | 9.41 | 0.84 |
| literal: a word, second text | 10 | 600.63 ± 10.2% | 659.12 ± 0.3% | 1057.08 ± 0.2% | 434.19 ± 1.0% | 452.99 ± 2.4% | 970.07 ± 0.7% | 26169.31 ± 7.7% | 601.12 ± 0.4% | 0.91 | 1.00 | 1.38 | 1.33 |
| class: two capitalized words | 23 | 476.96 ± 0.6% | 510.91 ± 0.1% | 741.21 ± 0.5% | 103.28 ± 1.1% | 421.77 ± 12.0% | 900.25 ± 0.8% | 5767.55 ± 0.4% | 474.97 ± 0.3% | 0.93 | 1.00 | 4.62 | 1.13 |
| class: a word that ends in ing | 9 | 596.95 ± 9.7% | 680.55 ± 0.7% | 1159.80 ± 1.3% | 129.85 ± 1.2% | 622.73 ± 1.9% | 1366.20 ± 2.8% | 14748.43 ± 0.8% | 596.21 ± 2.2% | 0.88 | 1.00 | 4.60 | 0.96 |
| class: a word in capitals | 16 | 560.45 ± 8.3% | 613.54 ± 0.4% | 999.93 ± 0.3% | 135.73 ± 1.6% | 617.56 ± 26.0% | 1247.20 ± 2.2% | 7606.50 ± 0.5% | 561.07 ± 1.2% | 0.91 | 1.00 | 4.13 | 0.91 |
| class: a number | 6 | 683.26 ± 0.7% | 759.78 ± 0.6% | 1394.16 ± 0.4% | 35.94 ± 1.2% | 1145.79 ± 2.7% | 2265.32 ± 3.8% | 21277.35 ± 0.6% | 684.28 ± 0.6% | 0.90 | 1.00 | 19.01 | 0.60 |
| class: two capitalized words, second text | 23 | 476.55 ± 1.0% | 510.60 ± 0.5% | 741.01 ± 0.3% | 101.90 ± 0.8% | 424.50 ± 2.1% | 873.13 ± 4.3% | 5769.55 ± 0.2% | 476.14 ± 0.5% | 0.93 | 1.00 | 4.68 | 1.12 |
| other: a word between two words | 13 | 580.82 ± 0.3% | 601.11 ± 0.3% | 928.61 ± 0.2% | 133.92 ± 1.7% | 425.79 ± 2.0% | 993.49 ± 2.2% | 13781.93 ± 5.6% | 580.70 ± 0.2% | 0.97 | 1.00 | 4.34 | 1.36 |
| other: a number before a unit, second text | 15 | 433.60 ± 0.1% | 487.17 ± 0.2% | 688.25 ± 0.4% | 33.73 ± 0.8% | 524.86 ± 0.8% | 1079.30 ± 3.6% | 14705.08 ± 1.1% | 433.74 ± 0.3% | 0.89 | 1.00 | 12.86 | 0.83 |
| other: a heading's start tag | 13 | 368.84 ± 0.3% | 376.76 ± 0.2% | 491.16 ± 0.2% | 35.97 ± 0.3% | 517.47 ± 15.9% | 1034.51 ± 0.7% | 17547.29 ± 0.9% | 368.21 ± 1.0% | 0.98 | 1.00 | 10.25 | 0.71 |
| other: a whole word | 11 | 598.63 ± 0.4% | 635.45 ± 0.6% | 999.64 ± 0.2% | 118.42 ± 0.2% | 479.36 ± 2.7% | 1003.60 ± 1.8% | 24438.50 ± 0.9% | 597.01 ± 1.8% | 0.94 | 1.00 | 5.06 | 1.25 |
| other: a line's first word, second text | 17 | 574.04 ± 0.6% | 606.66 ± 4.0% | 970.98 ± 0.4% | 125.74 ± 0.2% | 580.16 ± 0.9% | refused | refused | 572.66 ± 0.8% | 0.95 | 1.00 | 4.57 | 0.99 |
| other: fourteen octets before an x | 16 | 95.13 ± 6.0% | 146.53 ± 0.2% | 173.12 ± 13.1% | 15.02 ± 3.0% | 372.03 ± 16.0% | 442.49 ± 6.5% | 12095.82 ± 0.2% | 95.22 ± 0.6% | 0.65 | 1.00 | 6.33 | 0.26 |
| other: a Greek word | 8 | 454.15 ± 1.3% | 610.06 ± 0.2% | 963.87 ± 5.4% | 45.19 ± 0.1% | 1123.96 ± 1.7% | 2138.54 ± 0.7% | refused | 454.02 ± 0.3% | 0.74 | 1.00 | 10.05 | 0.40 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20559.24 ± 0.5% | not timed | not timed | 22332.77 ± 1.4% | 1902.82 ± 22.8% | not timed | not timed | 20569.38 ± 1.0% | | 1.00 | 0.92 | 10.80 |
| 01-literal/sherlock-casei-en | 522 | 6537.61 ± 3.3% | not timed | not timed | 6821.89 ± 0.8% | 29.45 ± 1.1% | not timed | not timed | 6501.93 ± 2.9% | | 1.01 | 0.96 | 221.99 |
| 01-literal/sherlock-ru | 724 | 19136.02 ± 0.4% | not timed | not timed | 19941.58 ± 0.3% | 1108.00 ± 2.4% | not timed | not timed | 19082.62 ± 6.9% | | 1.00 | 0.96 | 17.27 |
| 01-literal/sherlock-casei-ru | 746 | 7286.79 ± 0.4% | not timed | not timed | 5543.11 ± 0.4% | 32.14 ± 5.0% | not timed | not timed | 7284.62 ± 0.2% | | 1.00 | 1.31 | 226.72 |
| 01-literal/sherlock-zh | 30 | 33116.83 ± 0.4% | not timed | not timed | 27885.47 ± 0.2% | 1102.29 ± 0.2% | not timed | not timed | 33028.91 ± 9.7% | | 1.00 | 1.19 | 30.04 |
| 02-literal-alternate/sherlock-en | 714 | 9938.07 ± 0.7% | not timed | not timed | 7704.03 ± 0.5% | 15.66 ± 0.7% | not timed | not timed | 9894.59 ± 6.3% | | 1.00 | 1.29 | 634.43 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1808.07 ± 1.5% | not timed | not timed | 2068.96 ± 10.1% | 9.79 ± 7.4% | not timed | not timed | 1784.38 ± 0.8% | | 1.01 | 0.87 | 184.74 |
| 02-literal-alternate/sherlock-ru | 899 | 6103.18 ± 0.3% | not timed | not timed | 4406.64 ± 2.2% | 21.53 ± 0.5% | not timed | not timed | 6090.52 ± 0.3% | | 1.00 | 1.38 | 283.53 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1898.98 ± 1.1% | not timed | not timed | 1088.63 ± 3.7% | 8.80 ± 0.7% | not timed | not timed | 1889.78 ± 0.5% | | 1.00 | 1.74 | 215.86 |
| 02-literal-alternate/sherlock-zh | 207 | 13628.16 ± 0.2% | not timed | not timed | 8884.53 ± 0.3% | 30.27 ± 0.8% | not timed | not timed | 13597.96 ± 1.0% | | 1.00 | 1.53 | 450.28 |
| 03-date/ascii | 111817 | 106.60 ± 1.5% | not timed | not timed | 91.12 ± 0.3% | 0.17 ± 3.3% | not timed | not timed | 103.52 ± 2.3% | | 1.03 | 1.17 | 629.51 |
| 04-ruff-noqa/real | 84 | 563.11 ± 0.5% | not timed | not timed | 438.91 ± 0.3% | 13.72 ± 1.2% | not timed | not timed | 561.28 ± 2.0% | | 1.00 | 1.28 | 41.04 |
| 04-ruff-noqa/tweaked | 44 | 463.30 ± 2.2% | not timed | not timed | 426.14 ± 0.3% | 300.66 ± 1.7% | not timed | not timed | 454.09 ± 2.5% | | 1.02 | 1.09 | 1.54 |
| 05-lexer-veryl/single | 124800 | 3.54 ± 7.2% | not timed | not timed | 4.52 ± 8.7% | 0.21 ± 3.5% | not timed | not timed | 3.58 ± 7.0% | | 0.99 | 0.78 | 17.09 |
| 06-cloud-flare-redos/original | 107 | 204.52 ± 0.8% | not timed | not timed | 202.38 ± 0.4% | 22.61 ± 0.3% | not timed | not timed | 204.08 ± 0.3% | | 1.00 | 1.01 | 9.04 |
| 06-cloud-flare-redos/simplified-short | 102 | 200.71 ± 0.3% | not timed | not timed | 207.35 ± 0.6% | 25.05 ± 0.6% | not timed | not timed | 199.82 ± 0.7% | | 1.00 | 0.97 | 8.01 |
| 06-cloud-flare-redos/simplified-long | 10000 | 218.19 ± 0.4% | not timed | not timed | 228.22 ± 1.3% | 27.69 ± 0.3% | not timed | not timed | 218.04 ± 0.5% | | 1.00 | 0.96 | 7.88 |
| 07-unicode-character-data/parse-line | 558784 | 194.72 ± 0.7% | not timed | not timed | 161.11 ± 0.5% | 39.06 ± 5.1% | not timed | not timed | 194.46 ± 1.8% | | 1.00 | 1.21 | 4.99 |
| 08-words/all-english | 56691 | 95.52 ± 0.6% | not timed | not timed | 75.77 ± 1.9% | 11.56 ± 2.6% | not timed | not timed | 94.73 ± 1.0% | | 1.01 | 1.26 | 8.26 |
| 08-words/long-english | 839 | 844.23 ± 0.4% | not timed | not timed | 553.10 ± 0.1% | 28.41 ± 0.7% | not timed | not timed | 842.33 ± 0.3% | | 1.00 | 1.53 | 29.72 |
| 09-aws-keys/full | 0 | 466.80 ± 0.5% | not timed | not timed | 452.92 ± 0.5% | 57.19 ± 3.6% | not timed | not timed | 464.40 ± 0.3% | | 1.01 | 1.03 | 8.16 |
| 09-aws-keys/quick | 0 | 821.87 ± 7.0% | not timed | not timed | 799.89 ± 0.6% | 340.33 ± 13.6% | not timed | not timed | 822.66 ± 6.7% | | 1.00 | 1.03 | 2.41 |
| 10-bounded-repeat/letters-en | 1833 | 539.75 ± 2.8% | not timed | not timed | 478.00 ± 1.3% | 18.65 ± 0.7% | not timed | not timed | 534.68 ± 1.5% | | 1.01 | 1.13 | 28.94 |
| 10-bounded-repeat/letters-ru | 3475 | 336.94 ± 3.0% | not timed | not timed | 434.50 ± 2.3% | 21.21 ± 7.0% | not timed | not timed | 334.85 ± 2.3% | | 1.01 | 0.78 | 15.89 |
| 10-bounded-repeat/context | 53 | 73.14 ± 7.8% | not timed | not timed | 59.62 ± 0.6% | 18.26 ± 3.2% | not timed | not timed | 73.04 ± 1.7% | | 1.00 | 1.23 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 906.82 ± 2.2% | not timed | not timed | 576.99 ± 0.1% | 33.24 ± 1.2% | not timed | not timed | 898.34 ± 0.6% | | 1.01 | 1.57 | 27.28 |
| 11-unstructured-to-json/extract | 600 | 42.54 ± 1.3% | not timed | not timed | 69.50 ± 6.6% | 44.56 ± 0.5% | not timed | not timed | 42.53 ± 10.2% | | 1.00 | 0.61 | 0.95 |
| 12-dictionary/single | 1 | 522.70 ± 0.3% | not timed | not timed | 504.05 ± 1.8% | 0.27 ± 2.2% | not timed | not timed | 524.78 ± 0.2% | | 1.00 | 1.04 | 1949.13 |
| 14-quadratic/1x | 100 | 11.11 ± 0.3% | not timed | not timed | 11.82 ± 0.4% | 0.89 ± 3.6% | not timed | not timed | 10.68 ± 7.6% | | 1.04 | 0.94 | 12.52 |
| 14-quadratic/2x | 200 | 6.71 ± 0.8% | not timed | not timed | 5.55 ± 0.1% | 0.49 ± 14.9% | not timed | not timed | 6.57 ± 0.7% | | 1.02 | 1.21 | 13.64 |
| 14-quadratic/10x | 1000 | 1.60 ± 0.3% | not timed | not timed | 1.16 ± 0.2% | 0.11 ± 1.4% | not timed | not timed | 1.60 ± 0.4% | | 1.00 | 1.37 | 14.64 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.59 ± 0.4% | not timed | not timed | 0.35 ± 1.1% | 0.50 ± 3.7% | not timed | not timed | 1.57 ± 1.4% | | 1.01 | 4.59 | 3.19 |
| 04-ruff-noqa/compile-real | 1 | 97.72 ± 6.5% | not timed | not timed | 12.17 ± 1.3% | 124.35 ± 4.3% | not timed | not timed | 97.27 ± 1.4% | | 1.00 | 8.03 | 0.79 |
| 05-lexer-veryl/compile-single | 1 | 15.17 ± 0.3% | not timed | not timed | 2.40 ± 11.9% | 5.89 ± 20.9% | not timed | not timed | 15.19 ± 0.6% | | 1.00 | 6.33 | 2.58 |
| 07-unicode-character-data/compile | 1 | 57.37 ± 0.2% | not timed | not timed | 24.60 ± 1.1% | 32.81 ± 1.2% | not timed | not timed | 57.01 ± 10.2% | | 1.01 | 2.33 | 1.75 |
| 09-aws-keys/compile-full | 1 | 37.79 ± 0.7% | not timed | not timed | 7.12 ± 0.4% | 21.11 ± 5.0% | not timed | not timed | 38.11 ± 0.4% | | 0.99 | 5.31 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 181.86 ± 6.5% | not timed | not timed | 46.17 ± 1.2% | 118.70 ± 1.0% | not timed | not timed | 178.71 ± 0.7% | | 1.02 | 3.94 | 1.53 |
| 10-bounded-repeat/compile-context | 1 | 12.34 ± 0.7% | not timed | not timed | 11.25 ± 0.7% | 14.78 ± 2.4% | not timed | not timed | 12.26 ± 1.1% | | 1.01 | 1.10 | 0.84 |
| 10-bounded-repeat/compile-capitals | 1 | 74.00 ± 0.4% | not timed | not timed | 8.40 ± 0.7% | 21.82 ± 2.4% | not timed | not timed | 74.34 ± 1.9% | | 1.00 | 8.81 | 3.39 |
| 11-unstructured-to-json/compile | 1 | 85.98 ± 0.3% | not timed | not timed | 36.53 ± 2.7% | 62.36 ± 2.6% | not timed | not timed | 85.37 ± 0.9% | | 1.01 | 2.35 | 1.38 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.9% | not timed | not timed | 0.07 ± 1.4% | 0.09 ± 13.8% | not timed | not timed | 0.29 ± 0.9% | | 1.01 | 4.43 | 3.29 |

