# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215464555 |
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
| literal: a word | 217 | 32926.07 ± 3.0% | 3352.23 ± 0.5% | 20.12 ± 2.2% | 30561.48 ± 1.4% | 8739.46 ± 10.0% | 10.75 ± 0.3% | 76.21 ± 0.5% | 32223.74 ± 1.3% | 9.82 | 1.02 | 1.08 | 3.77 |
| literal: a word that is not there | 0 | 48743.21 ± 2.1% | 3244.73 ± 0.6% | 20.06 ± 2.1% | 38959.79 ± 0.7% | 30088.89 ± 0.2% | 10.69 ± 0.3% | 71.23 ± 1.3% | 48159.86 ± 2.8% | 15.02 | 1.01 | 1.25 | 1.62 |
| literal: one of four words | 661 | 11108.08 ± 1.2% | 1399.09 ± 0.7% | 10.93 ± 1.2% | 9069.18 ± 1.1% | 19.20 ± 1.9% | 3.99 ± 0.1% | 6.69 ± 1.3% | 11085.07 ± 1.2% | 7.94 | 1.00 | 1.22 | 578.43 |
| literal: a word in any case | 217 | 25395.70 ± 1.4% | 1492.83 ± 0.3% | 15.42 ± 2.7% | 9209.45 ± 3.8% | 36.78 ± 5.6% | refused | differs | 24958.48 ± 1.1% | 17.01 | 1.02 | 2.76 | 690.51 |
| literal: an href attribute | 33 | 26978.68 ± 2.1% | 537.53 ± 0.2% | 18.52 ± 1.4% | 26494.72 ± 6.2% | 2047.33 ± 0.8% | 8.18 ± 3.2% | 61.33 ± 1.3% | 26844.33 ± 0.5% | 50.19 | 1.01 | 1.02 | 13.18 |
| literal: a word, second text | 123 | 33496.73 ± 1.3% | 2382.22 ± 4.7% | 20.16 ± 3.9% | 31168.10 ± 0.4% | 7031.35 ± 7.1% | 11.80 ± 0.3% | 65.08 ± 1.8% | 33154.19 ± 1.0% | 14.06 | 1.01 | 1.07 | 4.76 |
| class: two capitalized words | 1331 | 768.18 ± 0.2% | 525.53 ± 0.5% | 18.68 ± 1.5% | 505.56 ± 0.2% | 34.34 ± 7.6% | 9.26 ± 0.3% | 55.65 ± 0.3% | 768.28 ± 0.3% | 1.46 | 1.00 | 1.52 | 22.37 |
| class: a word that ends in ing | 3399 | 498.06 ± 0.2% | 498.17 ± 0.3% | 12.99 ± 4.3% | 470.83 ± 0.7% | 25.68 ± 3.4% | 5.35 ± 0.6% | 17.10 ± 0.3% | 497.91 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.39 |
| class: a word in capitals | 2332 | 951.29 ± 0.4% | 529.80 ± 0.2% | 19.74 ± 4.2% | 496.77 ± 0.8% | 36.71 ± 9.1% | 10.30 ± 0.3% | 76.43 ± 0.7% | 952.84 ± 0.3% | 1.80 | 1.00 | 1.91 | 25.91 |
| class: a number | 8288 | 1465.08 ± 0.4% | 701.25 ± 0.2% | 19.70 ± 1.0% | 1468.84 ± 0.5% | 34.63 ± 9.0% | 0.33 ± 0.8% | 55.72 ± 1.1% | 1466.60 ± 0.2% | 2.09 | 1.00 | 1.00 | 42.30 |
| class: two capitalized words, second text | 5359 | 442.57 ± 1.1% | 449.56 ± 1.4% | 15.50 ± 1.1% | 416.14 ± 0.1% | 28.89 ± 13.2% | 10.49 ± 0.3% | 51.55 ± 0.5% | 442.82 ± 0.1% | 0.98 | 1.00 | 1.06 | 15.32 |
| other: a word between two words | 6104 | 681.68 ± 0.8% | 500.48 ± 0.4% | 16.72 ± 30.6% | 694.48 ± 2.9% | 97.46 ± 15.1% | 7.24 ± 0.2% | 56.58 ± 3.0% | 682.55 ± 7.2% | 1.36 | 1.00 | 0.98 | 6.99 |
| other: a number before a unit, second text | 1481 | 7095.28 ± 1.2% | 857.22 ± 0.7% | 18.88 ± 0.9% | 6388.69 ± 0.6% | 35.01 ± 9.8% | 10.88 ± 1.0% | 55.00 ± 9.0% | 7028.84 ± 5.7% | 8.28 | 1.01 | 1.11 | 202.69 |
| other: a heading's start tag | 110 | 18788.55 ± 2.7% | 652.74 ± 0.2% | 19.64 ± 1.6% | 2003.83 ± 8.2% | 1471.25 ± 3.8% | 10.01 ± 0.2% | 72.66 ± 0.3% | 18264.44 ± 3.4% | 28.78 | 1.03 | 9.38 | 12.77 |
| other: a whole word | 217 | 22862.92 ± 2.6% | 530.35 ± 0.1% | 19.34 ± 1.0% | 22309.64 ± 1.2% | 39.82 ± 0.4% | 9.45 ± 0.2% | 47.02 ± 1.5% | 22454.47 ± 10.8% | 43.11 | 1.02 | 1.02 | 574.09 |
| other: a line's first word, second text | 3716 | 1893.68 ± 2.2% | 511.37 ± 0.2% | 22.40 ± 11.2% | 1676.74 ± 3.1% | 53.07 ± 3.1% | refused | refused | 1911.32 ± 0.5% | 3.70 | 0.99 | 1.13 | 35.68 |
| other: fourteen octets before an x | 87 | 25779.41 ± 8.1% | 199.47 ± 0.5% | 5.17 ± 3.1% | 2743.85 ± 0.2% | 8.99 ± 0.9% | differs | 15.16 ± 27.4% | 25863.71 ± 0.9% | 129.24 | 1.00 | 9.40 | 2866.22 |
| other: a Greek word | 21815 | 385.50 ± 0.3% | 336.00 ± 0.4% | 23.62 ± 5.4% | 263.18 ± 0.8% | 43.46 ± 7.1% | differs | refused | 385.34 ± 1.3% | 1.15 | 1.00 | 1.46 | 8.87 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.59 ± 0.2% | 18.60 ± 0.3% | 0.79 ± 0.3% | 16.71 ± 0.5% | 1.99 ± 6.8% | differs | 3.61 ± 13.4% | 18.57 ± 0.3% | 1.00 | 1.00 | 1.11 | 9.34 |
| a UUID | 32895 | 20.38 ± 0.2% | 20.14 ± 0.4% | 0.55 ± 6.7% | 12.86 ± 0.5% | 2.48 ± 1.8% | 0.44 ± 0.2% | 3.09 ± 0.5% | 20.33 ± 0.5% | 1.01 | 1.00 | 1.58 | 8.21 |
| an IPv4 address | 33176 | 34.04 ± 0.6% | 33.81 ± 10.4% | 1.72 ± 3.7% | 24.16 ± 0.4% | 5.76 ± 1.5% | differs | 3.37 ± 2.3% | 34.01 ± 0.3% | 1.01 | 1.00 | 1.41 | 5.91 |
| a date and time | 32954 | 30.09 ± 1.3% | 30.00 ± 10.7% | 1.24 ± 2.3% | 18.02 ± 1.1% | 6.67 ± 2.1% | 0.76 ± 1.5% | 6.08 ± 5.0% | 30.14 ± 2.3% | 1.00 | 1.00 | 1.67 | 4.51 |
| a field path | 32606 | 21.75 ± 0.6% | 21.74 ± 0.4% | 0.90 ± 0.2% | 19.37 ± 0.7% | 2.94 ± 1.2% | differs | 2.45 ± 11.3% | 21.76 ± 0.5% | 1.00 | 1.00 | 1.12 | 7.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.29 ± 13.8% | 8.52 ± 0.9% | 8.46 ± 1.1% | 10.44 ± 0.2% | 4.69 ± 1.5% | 0.62 ± 0.6% | none | 8.48 ± 16.6% | 0.86 | 0.86 | 0.70 | 1.56 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 207.11 ± 0.9% | 207.29 ± 0.5% | 243.21 ± 0.6% | 79.82 ± 3.5% | 171.39 ± 5.9% | 535.56 ± 4.5% | 3890.07 ± 1.0% | 207.14 ± 0.8% | 1.00 | 1.00 | 2.59 | 1.21 |
| a UUID | 62 | 134.03 ± 1.0% | 134.47 ± 2.0% | 149.52 ± 1.5% | 46.94 ± 1.4% | 84.85 ± 9.4% | 198.61 ± 1.7% | 4027.13 ± 0.9% | 133.82 ± 0.7% | 1.00 | 1.00 | 2.86 | 1.58 |
| an IPv4 address | 29 | 387.54 ± 1.0% | 386.94 ± 1.2% | 533.13 ± 0.4% | 70.46 ± 0.7% | 109.22 ± 1.6% | 328.90 ± 2.4% | 6904.48 ± 0.4% | 389.13 ± 2.2% | 1.00 | 1.00 | 5.50 | 3.55 |
| a date and time | 56 | 281.50 ± 2.9% | 282.55 ± 0.5% | 349.61 ± 0.1% | 69.26 ± 8.9% | 116.52 ± 4.1% | 379.69 ± 17.2% | 4245.67 ± 1.4% | 282.38 ± 0.4% | 1.00 | 1.00 | 4.06 | 2.42 |
| a field path | 39 | 206.79 ± 2.6% | 207.15 ± 0.9% | 244.01 ± 1.0% | 74.38 ± 2.5% | 170.13 ± 1.9% | 598.23 ± 3.3% | 4696.44 ± 1.3% | 206.68 ± 1.1% | 1.00 | 1.00 | 2.78 | 1.22 |
| literal: a word | 7 | 591.41 ± 0.4% | 631.08 ± 0.6% | 1084.44 ± 0.6% | 473.01 ± 1.3% | 574.47 ± 2.3% | 1253.47 ± 1.2% | 22121.28 ± 0.4% | 588.47 ± 15.6% | 0.94 | 1.00 | 1.25 | 1.03 |
| literal: a word that is not there | 8 | 566.59 ± 0.4% | 609.18 ± 0.5% | 1018.42 ± 0.3% | 439.81 ± 0.6% | 550.49 ± 2.0% | 1185.82 ± 1.1% | 21268.43 ± 1.9% | 565.51 ± 14.6% | 0.93 | 1.00 | 1.29 | 1.03 |
| literal: one of four words | 26 | 219.18 ± 1.1% | 361.76 ± 0.6% | 477.36 ± 0.4% | 41.98 ± 1.7% | 209.97 ± 3.4% | 466.92 ± 1.0% | 11540.40 ± 0.2% | 218.84 ± 0.8% | 0.61 | 1.00 | 5.22 | 1.04 |
| literal: a word in any case | 11 | 415.62 ± 0.8% | 436.58 ± 0.4% | 619.88 ± 1.4% | 14.40 ± 2.5% | 600.56 ± 14.8% | refused | 17683.90 ± 8.6% | 415.37 ± 0.2% | 0.95 | 1.00 | 28.86 | 0.69 |
| literal: an href attribute | 12 | 324.30 ± 1.2% | 334.98 ± 0.5% | 435.68 ± 1.0% | 36.88 ± 1.4% | 410.91 ± 10.1% | 998.15 ± 9.6% | 15574.59 ± 2.2% | 323.03 ± 0.5% | 0.97 | 1.00 | 8.79 | 0.79 |
| literal: a word, second text | 10 | 522.27 ± 0.9% | 569.45 ± 0.9% | 911.01 ± 0.4% | 414.76 ± 11.5% | 467.46 ± 2.5% | 1060.95 ± 1.2% | 19179.13 ± 0.4% | 524.16 ± 0.7% | 0.92 | 1.00 | 1.26 | 1.12 |
| class: two capitalized words | 23 | 420.73 ± 9.7% | 450.73 ± 0.4% | 648.23 ± 2.9% | 97.01 ± 1.1% | 438.98 ± 2.8% | 974.40 ± 0.9% | 6330.01 ± 0.4% | 420.32 ± 0.5% | 0.93 | 1.00 | 4.34 | 0.96 |
| class: a word that ends in ing | 9 | 513.82 ± 0.4% | 572.22 ± 0.4% | 984.00 ± 1.8% | 115.54 ± 2.1% | 617.07 ± 2.7% | 1470.89 ± 1.3% | 14042.37 ± 0.5% | 512.13 ± 0.6% | 0.90 | 1.00 | 4.45 | 0.83 |
| class: a word in capitals | 16 | 445.25 ± 6.7% | 478.92 ± 0.4% | 779.14 ± 0.3% | 123.79 ± 2.3% | 635.72 ± 4.8% | 1343.20 ± 18.0% | 8299.76 ± 8.1% | 445.30 ± 4.7% | 0.93 | 1.00 | 3.60 | 0.70 |
| class: a number | 6 | 568.70 ± 1.2% | 621.80 ± 1.5% | 1169.01 ± 0.3% | 36.67 ± 0.7% | 1170.58 ± 10.4% | 2345.48 ± 2.9% | 19426.29 ± 0.5% | 566.20 ± 13.3% | 0.91 | 1.00 | 15.51 | 0.49 |
| class: two capitalized words, second text | 23 | 420.47 ± 0.7% | 451.04 ± 2.0% | 649.56 ± 3.1% | 95.45 ± 0.5% | 442.46 ± 3.3% | 931.97 ± 0.8% | 6323.33 ± 0.7% | 421.10 ± 0.4% | 0.93 | 1.00 | 4.41 | 0.95 |
| other: a word between two words | 13 | 505.42 ± 0.7% | 518.71 ± 1.7% | 796.97 ± 0.9% | 123.20 ± 1.4% | 432.56 ± 1.9% | 1057.17 ± 1.7% | 13368.12 ± 0.4% | 503.75 ± 0.4% | 0.97 | 1.00 | 4.10 | 1.17 |
| other: a number before a unit, second text | 15 | 377.29 ± 0.5% | 416.44 ± 0.4% | 581.25 ± 1.1% | 34.04 ± 1.2% | 525.25 ± 15.3% | 1135.61 ± 2.3% | 13062.75 ± 12.1% | 375.80 ± 0.4% | 0.91 | 1.00 | 11.08 | 0.72 |
| other: a heading's start tag | 13 | 336.26 ± 2.2% | 337.39 ± 6.6% | 445.38 ± 2.4% | 35.41 ± 2.2% | 513.80 ± 3.5% | 1087.46 ± 2.5% | 14873.83 ± 4.7% | 334.73 ± 2.8% | 1.00 | 1.00 | 9.50 | 0.65 |
| other: a whole word | 11 | 496.29 ± 11.4% | 533.15 ± 2.3% | 836.26 ± 2.2% | 111.25 ± 2.9% | 491.91 ± 4.6% | 1064.83 ± 4.1% | 19008.85 ± 2.2% | 504.47 ± 2.1% | 0.93 | 0.98 | 4.46 | 1.01 |
| other: a line's first word, second text | 17 | 492.21 ± 1.1% | 509.40 ± 12.1% | 818.33 ± 0.3% | 115.21 ± 0.8% | 587.33 ± 17.2% | refused | refused | 491.64 ± 0.9% | 0.97 | 1.00 | 4.27 | 0.84 |
| other: fourteen octets before an x | 16 | 88.87 ± 0.2% | 125.80 ± 0.4% | 143.86 ± 0.3% | 14.07 ± 9.1% | 392.96 ± 1.7% | 456.91 ± 2.4% | 10995.56 ± 9.3% | 88.82 ± 2.0% | 0.71 | 1.00 | 6.32 | 0.23 |
| other: a Greek word | 8 | 400.31 ± 0.5% | 546.93 ± 0.6% | 928.05 ± 0.9% | 46.60 ± 0.6% | 1166.53 ± 2.0% | 2207.62 ± 1.6% | refused | 398.19 ± 0.9% | 0.73 | 1.01 | 8.59 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21828.05 ± 23.3% | not timed | not timed | 26720.96 ± 2.1% | 1865.95 ± 19.4% | not timed | not timed | 21816.90 ± 0.5% | | 1.00 | 0.82 | 11.70 |
| 01-literal/sherlock-casei-en | 522 | 7586.10 ± 0.9% | not timed | not timed | 7055.45 ± 0.3% | 28.59 ± 12.4% | not timed | not timed | 7552.02 ± 1.8% | | 1.00 | 1.08 | 265.37 |
| 01-literal/sherlock-ru | 724 | 23374.95 ± 2.4% | not timed | not timed | 27363.35 ± 0.4% | 1044.27 ± 9.3% | not timed | not timed | 23310.76 ± 1.1% | | 1.00 | 0.85 | 22.38 |
| 01-literal/sherlock-casei-ru | 746 | 9418.64 ± 0.3% | not timed | not timed | 5496.86 ± 0.6% | 30.48 ± 0.7% | not timed | not timed | 9411.92 ± 0.6% | | 1.00 | 1.71 | 309.03 |
| 01-literal/sherlock-zh | 30 | 42258.42 ± 5.8% | not timed | not timed | 35774.99 ± 1.1% | 1257.53 ± 2.0% | not timed | not timed | 41903.09 ± 0.3% | | 1.01 | 1.18 | 33.60 |
| 02-literal-alternate/sherlock-en | 714 | 9572.94 ± 1.2% | not timed | not timed | 8913.66 ± 0.4% | 14.70 ± 3.9% | not timed | not timed | 9556.41 ± 0.6% | | 1.00 | 1.07 | 651.34 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1988.83 ± 0.3% | not timed | not timed | 1812.76 ± 1.0% | 9.40 ± 1.4% | not timed | not timed | 1968.43 ± 0.5% | | 1.01 | 1.10 | 211.58 |
| 02-literal-alternate/sherlock-ru | 899 | 7772.31 ± 1.8% | not timed | not timed | 4229.63 ± 1.0% | 19.23 ± 6.0% | not timed | not timed | 7778.36 ± 0.7% | | 1.00 | 1.84 | 404.19 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2064.98 ± 1.3% | not timed | not timed | 1044.90 ± 0.1% | 8.46 ± 1.8% | not timed | not timed | 2063.08 ± 7.3% | | 1.00 | 1.98 | 244.12 |
| 02-literal-alternate/sherlock-zh | 207 | 13780.14 ± 2.4% | not timed | not timed | 10388.09 ± 0.5% | 26.88 ± 14.8% | not timed | not timed | 13792.70 ± 1.4% | | 1.00 | 1.33 | 512.58 |
| 03-date/ascii | 111817 | 96.88 ± 5.2% | not timed | not timed | 71.22 ± 0.4% | 0.17 ± 3.4% | not timed | not timed | 97.02 ± 0.8% | | 1.00 | 1.36 | 554.60 |
| 04-ruff-noqa/real | 84 | 418.47 ± 2.6% | not timed | not timed | 439.62 ± 2.1% | 9.98 ± 0.9% | not timed | not timed | 417.37 ± 2.0% | | 1.00 | 0.95 | 41.92 |
| 04-ruff-noqa/tweaked | 44 | 474.42 ± 3.0% | not timed | not timed | 428.04 ± 0.4% | 292.14 ± 1.0% | not timed | not timed | 473.98 ± 0.5% | | 1.00 | 1.11 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.27 ± 1.8% | not timed | not timed | 3.94 ± 1.4% | 0.21 ± 3.1% | not timed | not timed | 3.26 ± 4.3% | | 1.00 | 0.83 | 15.46 |
| 06-cloud-flare-redos/original | 107 | 346.98 ± 0.4% | not timed | not timed | 191.62 ± 0.7% | 20.11 ± 1.4% | not timed | not timed | 347.61 ± 0.3% | | 1.00 | 1.81 | 17.25 |
| 06-cloud-flare-redos/simplified-short | 102 | 333.57 ± 0.2% | not timed | not timed | 192.42 ± 0.3% | 21.91 ± 0.4% | not timed | not timed | 332.70 ± 1.0% | | 1.00 | 1.73 | 15.23 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.09 ± 0.8% | not timed | not timed | 211.33 ± 18.1% | 11.20 ± 0.6% | not timed | not timed | 464.67 ± 0.1% | | 1.00 | 2.20 | 41.44 |
| 07-unicode-character-data/parse-line | 558784 | 196.08 ± 0.5% | not timed | not timed | 162.02 ± 1.7% | 35.21 ± 3.3% | not timed | not timed | 187.04 ± 2.8% | | 1.05 | 1.21 | 5.57 |
| 08-words/all-english | 56691 | 94.20 ± 1.3% | not timed | not timed | 73.67 ± 0.7% | 10.10 ± 14.7% | not timed | not timed | 94.74 ± 10.6% | | 0.99 | 1.28 | 9.33 |
| 08-words/long-english | 839 | 535.49 ± 0.3% | not timed | not timed | 514.20 ± 0.5% | 25.26 ± 0.9% | not timed | not timed | 535.22 ± 0.2% | | 1.00 | 1.04 | 21.20 |
| 09-aws-keys/full | 0 | 425.26 ± 1.2% | not timed | not timed | 447.55 ± 0.5% | 48.84 ± 2.1% | not timed | not timed | 424.59 ± 0.4% | | 1.00 | 0.95 | 8.71 |
| 09-aws-keys/quick | 0 | 784.82 ± 2.5% | not timed | not timed | 800.56 ± 7.5% | 328.95 ± 6.1% | not timed | not timed | 765.21 ± 0.3% | | 1.03 | 0.98 | 2.39 |
| 10-bounded-repeat/letters-en | 1833 | 485.12 ± 0.4% | not timed | not timed | 432.61 ± 0.2% | 16.86 ± 3.2% | not timed | not timed | 486.28 ± 0.1% | | 1.00 | 1.12 | 28.78 |
| 10-bounded-repeat/letters-ru | 3475 | 430.73 ± 0.5% | not timed | not timed | 408.24 ± 0.4% | 19.63 ± 5.5% | not timed | not timed | 430.25 ± 0.4% | | 1.00 | 1.06 | 21.95 |
| 10-bounded-repeat/context | 53 | 62.74 ± 2.0% | not timed | not timed | 54.86 ± 1.2% | 16.92 ± 0.6% | not timed | not timed | 64.14 ± 10.5% | | 0.98 | 1.14 | 3.71 |
| 10-bounded-repeat/capitals | 11 | 557.88 ± 8.0% | not timed | not timed | 531.58 ± 0.4% | 30.94 ± 1.1% | not timed | not timed | 557.30 ± 8.0% | | 1.00 | 1.05 | 18.03 |
| 11-unstructured-to-json/extract | 600 | 54.03 ± 3.2% | not timed | not timed | 62.29 ± 1.2% | 40.46 ± 0.8% | not timed | not timed | 53.12 ± 3.2% | | 1.02 | 0.87 | 1.34 |
| 12-dictionary/single | 1 | 462.68 ± 0.2% | not timed | not timed | 442.15 ± 1.5% | 0.32 ± 1.3% | not timed | not timed | 464.22 ± 0.9% | | 1.00 | 1.05 | 1449.86 |
| 14-quadratic/1x | 100 | 20.72 ± 11.1% | not timed | not timed | 9.12 ± 1.4% | 0.78 ± 0.9% | not timed | not timed | 20.72 ± 0.8% | | 1.00 | 2.27 | 26.73 |
| 14-quadratic/2x | 200 | 15.96 ± 17.6% | not timed | not timed | 4.91 ± 0.2% | 0.43 ± 0.4% | not timed | not timed | 15.96 ± 0.3% | | 1.00 | 3.25 | 37.38 |
| 14-quadratic/10x | 1000 | 5.61 ± 0.3% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 2.1% | not timed | not timed | 5.61 ± 1.8% | | 1.00 | 5.34 | 60.39 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.19 ± 0.5% | not timed | not timed | 0.38 ± 0.9% | 0.47 ± 3.3% | not timed | not timed | 1.19 ± 1.6% | | 1.01 | 3.11 | 2.53 |
| 04-ruff-noqa/compile-real | 1 | 85.94 ± 1.0% | not timed | not timed | 12.86 ± 1.2% | 120.00 ± 1.2% | not timed | not timed | 85.68 ± 7.0% | | 1.00 | 6.68 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 12.79 ± 0.6% | not timed | not timed | 2.35 ± 2.4% | 5.78 ± 4.5% | not timed | not timed | 12.74 ± 11.2% | | 1.00 | 5.45 | 2.21 |
| 07-unicode-character-data/compile | 1 | 51.93 ± 11.6% | not timed | not timed | 23.62 ± 3.8% | 30.57 ± 3.6% | not timed | not timed | 51.36 ± 1.4% | | 1.01 | 2.20 | 1.70 |
| 09-aws-keys/compile-full | 1 | 35.39 ± 2.4% | not timed | not timed | 7.40 ± 8.7% | 19.49 ± 6.3% | not timed | not timed | 35.15 ± 2.6% | | 1.01 | 4.78 | 1.82 |
| 09-aws-keys/compile-quick | 1 | 159.15 ± 3.4% | not timed | not timed | 45.74 ± 0.7% | 107.69 ± 7.1% | not timed | not timed | 157.61 ± 0.7% | | 1.01 | 3.48 | 1.48 |
| 10-bounded-repeat/compile-context | 1 | 10.62 ± 0.2% | not timed | not timed | 11.78 ± 0.4% | 14.55 ± 3.1% | not timed | not timed | 10.56 ± 17.8% | | 1.01 | 0.90 | 0.73 |
| 10-bounded-repeat/compile-capitals | 1 | 72.83 ± 1.4% | not timed | not timed | 8.86 ± 0.9% | 21.40 ± 2.9% | not timed | not timed | 73.22 ± 2.4% | | 0.99 | 8.22 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 78.76 ± 0.6% | not timed | not timed | 36.99 ± 1.8% | 57.45 ± 4.2% | not timed | not timed | 78.33 ± 1.2% | | 1.01 | 2.13 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.6% | not timed | not timed | 0.07 ± 14.8% | 0.08 ± 17.5% | not timed | not timed | 0.28 ± 3.0% | | 1.03 | 4.42 | 3.64 |

