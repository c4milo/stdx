# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391491482 |
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
| literal: a word | 217 | 39153.54 ± 1.2% | 3353.60 ± 2.0% | 19.72 ± 1.3% | 31447.65 ± 0.3% | 9056.31 ± 9.7% | 10.76 ± 0.1% | 75.75 ± 0.7% | 39700.15 ± 4.3% | 11.68 | 0.99 | 1.25 | 4.32 |
| literal: a word that is not there | 0 | 54005.71 ± 0.5% | 3246.64 ± 0.4% | 19.82 ± 2.4% | 40163.69 ± 0.7% | 29955.61 ± 1.0% | 10.73 ± 0.3% | 71.78 ± 0.8% | 54169.54 ± 1.3% | 16.63 | 1.00 | 1.34 | 1.80 |
| literal: one of four words | 661 | 11563.93 ± 16.8% | 1403.55 ± 2.1% | 10.79 ± 2.7% | 9142.97 ± 1.7% | 19.25 ± 2.8% | 3.98 ± 1.5% | 6.45 ± 26.0% | 11528.69 ± 1.4% | 8.24 | 1.00 | 1.26 | 600.71 |
| literal: a word in any case | 217 | 30027.51 ± 1.1% | 1492.33 ± 1.4% | 14.71 ± 0.6% | 9236.27 ± 0.4% | 37.30 ± 0.5% | refused | differs | 30147.57 ± 1.0% | 20.12 | 1.00 | 3.25 | 805.01 |
| literal: an href attribute | 33 | 29151.81 ± 5.2% | 537.83 ± 0.1% | 18.16 ± 1.7% | 27547.80 ± 0.3% | 2060.18 ± 0.9% | 8.24 ± 0.2% | 59.83 ± 0.9% | 29372.86 ± 1.9% | 54.20 | 0.99 | 1.06 | 14.15 |
| literal: a word, second text | 123 | 38479.34 ± 0.8% | 2389.29 ± 0.4% | 19.71 ± 2.8% | 32277.08 ± 2.7% | 7015.75 ± 7.1% | 11.86 ± 0.2% | 65.05 ± 1.0% | 38562.93 ± 0.8% | 16.10 | 1.00 | 1.19 | 5.48 |
| class: two capitalized words | 1331 | 772.51 ± 2.3% | 525.83 ± 0.4% | 18.46 ± 0.2% | 506.29 ± 0.2% | 34.40 ± 14.1% | 9.34 ± 0.1% | 54.81 ± 0.5% | 771.66 ± 0.3% | 1.47 | 1.00 | 1.53 | 22.46 |
| class: a word that ends in ing | 3399 | 499.73 ± 0.3% | 499.42 ± 1.2% | 12.76 ± 0.2% | 471.35 ± 0.9% | 25.72 ± 6.3% | 5.35 ± 0.8% | 15.75 ± 0.9% | 500.03 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.43 |
| class: a word in capitals | 2332 | 951.94 ± 3.2% | 531.18 ± 0.2% | 19.52 ± 10.1% | 497.03 ± 0.3% | 36.75 ± 5.0% | 10.40 ± 0.7% | 76.40 ± 0.3% | 953.59 ± 3.2% | 1.79 | 1.00 | 1.92 | 25.90 |
| class: a number | 8288 | 1462.12 ± 0.1% | 702.93 ± 2.1% | 19.41 ± 3.4% | 1480.70 ± 1.7% | 34.64 ± 13.5% | 0.33 ± 0.2% | 54.29 ± 0.6% | 1451.83 ± 0.4% | 2.08 | 1.01 | 0.99 | 42.21 |
| class: two capitalized words, second text | 5359 | 443.56 ± 0.2% | 448.87 ± 0.2% | 16.39 ± 0.7% | 417.27 ± 0.5% | 29.19 ± 8.1% | 10.62 ± 0.3% | 50.38 ± 0.3% | 443.55 ± 0.7% | 0.99 | 1.00 | 1.06 | 15.20 |
| other: a word between two words | 6104 | 707.60 ± 0.4% | 512.20 ± 0.2% | 16.67 ± 0.9% | 698.46 ± 0.2% | 101.43 ± 7.7% | 7.28 ± 0.1% | 55.68 ± 4.1% | 706.78 ± 0.4% | 1.38 | 1.00 | 1.01 | 6.98 |
| other: a number before a unit, second text | 1481 | 7215.41 ± 2.6% | 858.94 ± 2.6% | 18.48 ± 3.9% | 6397.49 ± 2.6% | 35.12 ± 10.7% | 11.00 ± 0.6% | 53.95 ± 2.4% | 7197.87 ± 2.9% | 8.40 | 1.00 | 1.13 | 205.47 |
| other: a heading's start tag | 110 | 19430.12 ± 2.3% | 653.65 ± 0.1% | 19.15 ± 1.6% | 1931.20 ± 10.4% | 1453.50 ± 15.7% | 9.98 ± 0.5% | 71.29 ± 0.3% | 19443.23 ± 1.2% | 29.73 | 1.00 | 10.06 | 13.37 |
| other: a whole word | 217 | 23865.11 ± 1.1% | 530.46 ± 0.1% | 19.57 ± 1.2% | 22745.49 ± 0.9% | 41.22 ± 0.5% | 9.44 ± 0.4% | 46.49 ± 0.6% | 23913.60 ± 5.3% | 44.99 | 1.00 | 1.05 | 578.95 |
| other: a line's first word, second text | 3716 | 1947.78 ± 1.7% | 514.43 ± 0.8% | 21.45 ± 9.2% | 1674.13 ± 0.5% | 52.04 ± 13.5% | refused | refused | 1939.50 ± 1.0% | 3.79 | 1.00 | 1.16 | 37.43 |
| other: fourteen octets before an x | 87 | 27486.99 ± 0.6% | 230.86 ± 0.6% | 5.37 ± 0.2% | 2793.55 ± 0.4% | 8.98 ± 0.5% | differs | 15.06 ± 0.3% | 27529.44 ± 0.7% | 119.06 | 1.00 | 9.84 | 3059.24 |
| other: a Greek word | 21815 | 388.27 ± 0.6% | 335.73 ± 0.2% | 22.86 ± 3.4% | 265.13 ± 2.1% | 44.11 ± 11.9% | differs | refused | 388.63 ± 0.3% | 1.16 | 1.00 | 1.46 | 8.80 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.45 ± 0.3% | 18.47 ± 0.5% | 0.79 ± 0.4% | 16.80 ± 0.5% | 2.34 ± 1.2% | differs | 3.37 ± 2.9% | 18.47 ± 0.3% | 1.00 | 1.00 | 1.10 | 7.88 |
| a UUID | 32895 | 20.27 ± 0.1% | 20.27 ± 3.7% | 0.55 ± 2.2% | 12.83 ± 0.2% | 2.51 ± 2.0% | 0.44 ± 0.3% | 3.00 ± 0.9% | 20.30 ± 0.2% | 1.00 | 1.00 | 1.58 | 8.08 |
| an IPv4 address | 33176 | 33.32 ± 1.4% | 33.32 ± 0.5% | 1.77 ± 0.4% | 23.97 ± 0.2% | 5.75 ± 2.0% | differs | 3.27 ± 0.8% | 33.35 ± 0.6% | 1.00 | 1.00 | 1.39 | 5.79 |
| a date and time | 32954 | 29.80 ± 0.1% | 29.77 ± 0.2% | 1.27 ± 2.2% | 17.91 ± 0.2% | 6.70 ± 0.5% | 0.77 ± 0.4% | 5.52 ± 2.3% | 29.70 ± 6.2% | 1.00 | 1.00 | 1.66 | 4.45 |
| a field path | 32606 | 21.53 ± 0.3% | 21.56 ± 0.5% | 0.88 ± 2.0% | 19.34 ± 0.6% | 2.95 ± 12.1% | differs | 2.37 ± 0.3% | 21.52 ± 4.9% | 1.00 | 1.00 | 1.11 | 7.30 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.73 ± 0.7% | 8.68 ± 1.2% | 8.66 ± 0.9% | 10.47 ± 6.6% | 4.78 ± 10.1% | 0.63 ± 0.4% | none | 8.66 ± 0.4% | 1.01 | 1.01 | 0.83 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 196.50 ± 0.5% | 197.25 ± 1.4% | 233.33 ± 0.7% | 79.57 ± 3.1% | 184.78 ± 2.7% | 548.54 ± 5.5% | 3853.74 ± 0.3% | 196.67 ± 0.4% | 1.00 | 1.00 | 2.47 | 1.06 |
| a UUID | 62 | 129.17 ± 1.1% | 129.89 ± 1.0% | 146.87 ± 0.5% | 46.44 ± 1.7% | 90.12 ± 2.0% | 197.26 ± 0.8% | 3980.41 ± 0.9% | 129.61 ± 0.9% | 0.99 | 1.00 | 2.78 | 1.43 |
| an IPv4 address | 29 | 369.76 ± 0.7% | 370.43 ± 0.4% | 521.07 ± 1.4% | 71.19 ± 0.5% | 114.42 ± 0.4% | 338.89 ± 2.1% | 6623.33 ± 0.6% | 367.37 ± 1.5% | 1.00 | 1.01 | 5.19 | 3.23 |
| a date and time | 56 | 268.60 ± 0.5% | 270.25 ± 0.6% | 341.31 ± 1.0% | 69.13 ± 1.3% | 122.20 ± 3.3% | 367.85 ± 8.1% | 4065.19 ± 1.0% | 269.52 ± 0.7% | 0.99 | 1.00 | 3.89 | 2.20 |
| a field path | 39 | 200.03 ± 2.3% | 200.06 ± 10.1% | 237.53 ± 0.6% | 74.45 ± 1.4% | 173.18 ± 1.1% | 592.01 ± 1.3% | 4472.59 ± 0.4% | 199.81 ± 0.4% | 1.00 | 1.00 | 2.69 | 1.16 |
| literal: a word | 7 | 547.54 ± 12.7% | 590.41 ± 1.0% | 1080.90 ± 0.4% | 498.43 ± 1.9% | 572.89 ± 7.2% | 1260.07 ± 8.8% | 24647.50 ± 1.1% | 548.71 ± 0.6% | 0.93 | 1.00 | 1.10 | 0.96 |
| literal: a word that is not there | 8 | 528.19 ± 12.0% | 571.53 ± 0.4% | 1010.70 ± 0.7% | 453.15 ± 0.5% | 558.21 ± 3.1% | 1182.89 ± 1.0% | 22760.92 ± 3.4% | 528.44 ± 0.7% | 0.92 | 1.00 | 1.17 | 0.95 |
| literal: one of four words | 26 | 212.08 ± 1.6% | 342.36 ± 7.8% | 465.22 ± 5.0% | 42.05 ± 4.6% | 219.40 ± 3.0% | 463.43 ± 2.4% | 10283.53 ± 14.1% | 212.81 ± 2.7% | 0.62 | 1.00 | 5.04 | 0.97 |
| literal: a word in any case | 11 | 385.19 ± 2.9% | 409.16 ± 2.1% | 599.69 ± 8.9% | 14.41 ± 4.2% | 592.44 ± 5.4% | refused | 18894.65 ± 2.3% | 384.46 ± 2.0% | 0.94 | 1.00 | 26.73 | 0.65 |
| literal: an href attribute | 12 | 309.85 ± 0.2% | 319.29 ± 0.9% | 427.24 ± 10.4% | 37.40 ± 3.2% | 435.76 ± 1.1% | 995.41 ± 0.6% | 18410.76 ± 0.6% | 310.24 ± 0.4% | 0.97 | 1.00 | 8.29 | 0.71 |
| literal: a word, second text | 10 | 486.12 ± 1.1% | 531.64 ± 0.7% | 893.60 ± 0.4% | 416.83 ± 1.5% | 488.42 ± 4.1% | 1039.95 ± 12.2% | 20644.63 ± 0.9% | 485.74 ± 0.4% | 0.91 | 1.00 | 1.17 | 1.00 |
| class: two capitalized words | 23 | 399.16 ± 1.2% | 420.76 ± 0.4% | 624.69 ± 3.6% | 94.99 ± 17.5% | 453.97 ± 2.1% | 917.64 ± 0.9% | 6171.63 ± 0.8% | 394.48 ± 2.0% | 0.95 | 1.01 | 4.20 | 0.88 |
| class: a word that ends in ing | 9 | 485.59 ± 0.6% | 542.03 ± 0.3% | 989.54 ± 0.9% | 117.64 ± 0.9% | 639.97 ± 2.6% | 1425.43 ± 16.4% | 15054.69 ± 15.1% | 486.15 ± 0.8% | 0.90 | 1.00 | 4.13 | 0.76 |
| class: a word in capitals | 16 | 426.93 ± 0.4% | 452.24 ± 2.2% | 755.63 ± 8.8% | 124.16 ± 2.7% | 652.83 ± 3.0% | 1247.90 ± 1.4% | 8274.50 ± 0.6% | 427.32 ± 0.5% | 0.94 | 1.00 | 3.44 | 0.65 |
| class: a number | 6 | 542.33 ± 0.2% | 582.58 ± 1.9% | 1146.11 ± 1.1% | 37.06 ± 1.1% | 1195.12 ± 3.2% | 2229.63 ± 11.3% | 19844.93 ± 3.4% | 542.15 ± 0.6% | 0.93 | 1.00 | 14.63 | 0.45 |
| class: two capitalized words, second text | 23 | 396.90 ± 0.6% | 412.11 ± 10.5% | 616.83 ± 3.6% | 94.66 ± 1.8% | 453.88 ± 18.8% | 894.33 ± 1.7% | 6193.18 ± 5.9% | 395.41 ± 1.8% | 0.96 | 1.00 | 4.19 | 0.87 |
| other: a word between two words | 13 | 475.81 ± 0.7% | 496.44 ± 2.8% | 799.11 ± 10.4% | 123.56 ± 0.5% | 443.54 ± 2.3% | 1024.57 ± 0.8% | 13254.04 ± 0.9% | 476.45 ± 1.8% | 0.96 | 1.00 | 3.85 | 1.07 |
| other: a number before a unit, second text | 15 | 362.73 ± 0.3% | 399.99 ± 0.2% | 580.10 ± 0.3% | 34.45 ± 1.1% | 546.14 ± 13.0% | 1146.08 ± 4.0% | 12119.23 ± 0.4% | 362.42 ± 1.3% | 0.91 | 1.00 | 10.53 | 0.66 |
| other: a heading's start tag | 13 | 322.72 ± 0.6% | 327.66 ± 0.3% | 443.54 ± 0.3% | 35.27 ± 0.9% | 534.12 ± 2.8% | 1062.33 ± 1.4% | 14787.90 ± 0.4% | 322.10 ± 1.9% | 0.98 | 1.00 | 9.15 | 0.60 |
| other: a whole word | 11 | 472.40 ± 9.1% | 500.63 ± 1.6% | 819.30 ± 1.4% | 112.42 ± 8.4% | 514.37 ± 17.7% | 1047.51 ± 0.4% | 20203.51 ± 19.1% | 472.97 ± 1.2% | 0.94 | 1.00 | 4.20 | 0.92 |
| other: a line's first word, second text | 17 | 456.04 ± 0.6% | 476.80 ± 1.8% | 797.83 ± 0.2% | 116.39 ± 0.7% | 610.34 ± 1.5% | refused | refused | 456.36 ± 0.6% | 0.96 | 1.00 | 3.92 | 0.75 |
| other: fourteen octets before an x | 16 | 89.33 ± 3.0% | 122.86 ± 1.7% | 143.04 ± 0.7% | 14.07 ± 1.8% | 401.58 ± 2.5% | 447.27 ± 1.0% | 12021.45 ± 0.8% | 90.00 ± 0.5% | 0.73 | 0.99 | 6.35 | 0.22 |
| other: a Greek word | 8 | 378.84 ± 0.6% | 512.76 ± 0.1% | 921.45 ± 0.6% | 46.03 ± 1.4% | 1195.88 ± 3.8% | 2123.13 ± 1.2% | refused | 378.98 ± 1.2% | 0.74 | 1.00 | 8.23 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27175.14 ± 0.8% | not timed | not timed | 26690.56 ± 1.5% | 1969.81 ± 10.4% | not timed | not timed | 27257.25 ± 1.6% | | 1.00 | 1.02 | 13.80 |
| 01-literal/sherlock-casei-en | 522 | 21420.43 ± 2.3% | not timed | not timed | 7040.32 ± 0.3% | 28.43 ± 1.3% | not timed | not timed | 21320.80 ± 1.5% | | 1.00 | 3.04 | 753.50 |
| 01-literal/sherlock-ru | 724 | 28547.41 ± 1.4% | not timed | not timed | 27652.47 ± 1.2% | 1056.72 ± 2.8% | not timed | not timed | 28594.48 ± 2.1% | | 1.00 | 1.03 | 27.02 |
| 01-literal/sherlock-casei-ru | 746 | 9511.29 ± 0.8% | not timed | not timed | 5541.62 ± 0.3% | 30.41 ± 0.8% | not timed | not timed | 9450.65 ± 0.4% | | 1.01 | 1.72 | 312.77 |
| 01-literal/sherlock-zh | 30 | 47365.88 ± 1.6% | not timed | not timed | 36913.72 ± 0.6% | 1264.98 ± 1.5% | not timed | not timed | 47153.14 ± 1.2% | | 1.00 | 1.28 | 37.44 |
| 02-literal-alternate/sherlock-en | 714 | 10093.76 ± 0.3% | not timed | not timed | 8924.69 ± 0.7% | 13.62 ± 5.4% | not timed | not timed | 10076.71 ± 0.4% | | 1.00 | 1.13 | 740.88 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2107.42 ± 0.5% | not timed | not timed | 1822.56 ± 0.4% | 9.22 ± 0.5% | not timed | not timed | 2109.50 ± 0.4% | | 1.00 | 1.16 | 228.63 |
| 02-literal-alternate/sherlock-ru | 899 | 7950.70 ± 1.4% | not timed | not timed | 4271.58 ± 0.2% | 18.70 ± 12.0% | not timed | not timed | 7911.77 ± 0.5% | | 1.00 | 1.86 | 425.23 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2083.06 ± 0.7% | not timed | not timed | 1045.58 ± 0.2% | 8.38 ± 6.8% | not timed | not timed | 2077.07 ± 1.0% | | 1.00 | 1.99 | 248.46 |
| 02-literal-alternate/sherlock-zh | 207 | 14479.31 ± 1.5% | not timed | not timed | 10413.61 ± 0.4% | 26.71 ± 2.3% | not timed | not timed | 14443.21 ± 1.2% | | 1.00 | 1.39 | 542.19 |
| 03-date/ascii | 111817 | 96.68 ± 2.4% | not timed | not timed | 84.35 ± 3.2% | 0.18 ± 3.8% | not timed | not timed | 96.43 ± 0.4% | | 1.00 | 1.15 | 541.26 |
| 04-ruff-noqa/real | 84 | 417.87 ± 0.2% | not timed | not timed | 434.30 ± 0.6% | 14.05 ± 1.5% | not timed | not timed | 419.91 ± 0.6% | | 1.00 | 0.96 | 29.75 |
| 04-ruff-noqa/tweaked | 44 | 513.84 ± 0.7% | not timed | not timed | 419.72 ± 0.3% | 295.37 ± 0.4% | not timed | not timed | 516.23 ± 0.3% | | 1.00 | 1.22 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.58 ± 2.7% | not timed | not timed | 4.22 ± 0.2% | 0.21 ± 3.4% | not timed | not timed | 3.57 ± 2.7% | | 1.00 | 0.85 | 17.40 |
| 06-cloud-flare-redos/original | 107 | 351.00 ± 0.3% | not timed | not timed | 192.82 ± 1.2% | 20.62 ± 31.3% | not timed | not timed | 350.16 ± 0.6% | | 1.00 | 1.82 | 17.02 |
| 06-cloud-flare-redos/simplified-short | 102 | 331.15 ± 0.8% | not timed | not timed | 192.08 ± 0.6% | 21.94 ± 12.5% | not timed | not timed | 332.28 ± 0.3% | | 1.00 | 1.72 | 15.09 |
| 06-cloud-flare-redos/simplified-long | 10000 | 462.27 ± 0.6% | not timed | not timed | 211.68 ± 1.5% | 24.03 ± 2.3% | not timed | not timed | 464.18 ± 0.8% | | 1.00 | 2.18 | 19.24 |
| 07-unicode-character-data/parse-line | 558784 | 202.69 ± 4.3% | not timed | not timed | 161.97 ± 0.4% | 36.05 ± 19.3% | not timed | not timed | 204.34 ± 2.2% | | 0.99 | 1.25 | 5.62 |
| 08-words/all-english | 56691 | 98.11 ± 1.2% | not timed | not timed | 73.83 ± 0.9% | 10.13 ± 11.6% | not timed | not timed | 98.00 ± 0.3% | | 1.00 | 1.33 | 9.69 |
| 08-words/long-english | 839 | 535.26 ± 0.3% | not timed | not timed | 515.15 ± 0.1% | 26.73 ± 0.3% | not timed | not timed | 535.66 ± 1.3% | | 1.00 | 1.04 | 20.03 |
| 09-aws-keys/full | 0 | 425.10 ± 0.4% | not timed | not timed | 443.66 ± 1.0% | 54.56 ± 5.2% | not timed | not timed | 425.98 ± 0.2% | | 1.00 | 0.96 | 7.79 |
| 09-aws-keys/quick | 0 | 923.83 ± 1.8% | not timed | not timed | 802.33 ± 1.1% | 332.05 ± 0.1% | not timed | not timed | 924.47 ± 0.3% | | 1.00 | 1.15 | 2.78 |
| 10-bounded-repeat/letters-en | 1833 | 487.27 ± 0.5% | not timed | not timed | 430.77 ± 0.4% | 15.49 ± 2.1% | not timed | not timed | 486.99 ± 0.1% | | 1.00 | 1.13 | 31.45 |
| 10-bounded-repeat/letters-ru | 3475 | 429.87 ± 1.2% | not timed | not timed | 406.93 ± 0.2% | 17.56 ± 11.8% | not timed | not timed | 430.67 ± 0.3% | | 1.00 | 1.06 | 24.48 |
| 10-bounded-repeat/context | 53 | 68.32 ± 2.9% | not timed | not timed | 56.16 ± 3.6% | 16.80 ± 2.8% | not timed | not timed | 68.30 ± 2.7% | | 1.00 | 1.22 | 4.07 |
| 10-bounded-repeat/capitals | 11 | 555.92 ± 8.2% | not timed | not timed | 531.34 ± 0.3% | 30.90 ± 0.7% | not timed | not timed | 556.67 ± 7.9% | | 1.00 | 1.05 | 17.99 |
| 11-unstructured-to-json/extract | 600 | 37.43 ± 0.5% | not timed | not timed | 62.51 ± 0.7% | 40.83 ± 1.9% | not timed | not timed | 37.30 ± 0.7% | | 1.00 | 0.60 | 0.92 |
| 12-dictionary/single | 1 | 464.02 ± 0.8% | not timed | not timed | 439.99 ± 1.1% | 0.32 ± 0.6% | not timed | not timed | 464.34 ± 0.3% | | 1.00 | 1.05 | 1468.76 |
| 14-quadratic/1x | 100 | 21.68 ± 34.0% | not timed | not timed | 9.11 ± 0.3% | 0.80 ± 3.9% | not timed | not timed | 21.70 ± 2.9% | | 1.00 | 2.38 | 27.10 |
| 14-quadratic/2x | 200 | 16.50 ± 1.7% | not timed | not timed | 4.92 ± 2.4% | 0.41 ± 2.5% | not timed | not timed | 16.34 ± 3.7% | | 1.01 | 3.36 | 39.89 |
| 14-quadratic/10x | 1000 | 5.66 ± 8.3% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 5.9% | not timed | not timed | 5.67 ± 0.2% | | 1.00 | 5.38 | 60.63 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.05 ± 9.3% | not timed | not timed | 0.39 ± 0.9% | 0.48 ± 21.8% | not timed | not timed | 1.04 ± 0.9% | | 1.00 | 2.69 | 2.17 |
| 04-ruff-noqa/compile-real | 1 | 95.60 ± 0.8% | not timed | not timed | 12.86 ± 0.4% | 124.08 ± 2.5% | not timed | not timed | 95.38 ± 11.0% | | 1.00 | 7.44 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 12.42 ± 10.0% | not timed | not timed | 2.37 ± 19.0% | 5.93 ± 1.8% | not timed | not timed | 12.47 ± 1.2% | | 1.00 | 5.24 | 2.10 |
| 07-unicode-character-data/compile | 1 | 98.97 ± 0.4% | not timed | not timed | 24.36 ± 0.7% | 32.44 ± 12.1% | not timed | not timed | 98.94 ± 0.5% | | 1.00 | 4.06 | 3.05 |
| 09-aws-keys/compile-full | 1 | 43.49 ± 0.3% | not timed | not timed | 7.34 ± 14.3% | 20.38 ± 2.8% | not timed | not timed | 43.48 ± 0.5% | | 1.00 | 5.92 | 2.13 |
| 09-aws-keys/compile-quick | 1 | 152.72 ± 2.0% | not timed | not timed | 45.42 ± 0.6% | 120.30 ± 4.1% | not timed | not timed | 152.31 ± 1.2% | | 1.00 | 3.36 | 1.27 |
| 10-bounded-repeat/compile-context | 1 | 49.36 ± 1.4% | not timed | not timed | 11.61 ± 0.3% | 15.32 ± 2.3% | not timed | not timed | 49.90 ± 0.4% | | 0.99 | 4.25 | 3.22 |
| 10-bounded-repeat/compile-capitals | 1 | 73.09 ± 0.2% | not timed | not timed | 8.81 ± 0.9% | 22.70 ± 2.0% | not timed | not timed | 73.52 ± 0.3% | | 0.99 | 8.29 | 3.22 |
| 11-unstructured-to-json/compile | 1 | 149.03 ± 1.6% | not timed | not timed | 37.54 ± 2.7% | 61.45 ± 1.7% | not timed | not timed | 150.80 ± 2.6% | | 0.99 | 3.97 | 2.43 |
| 12-dictionary/compile-single | 1 | 0.28 ± 2.1% | not timed | not timed | 0.07 ± 1.2% | 0.08 ± 13.6% | not timed | not timed | 0.28 ± 5.4% | | 1.01 | 4.11 | 3.40 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.34 ± 6.5% | not timed | not timed | 5.57 ± 0.2% | 0.53 ± 20.9% | not timed | not timed | 5.32 ± 6.5% | | 1.00 | 0.96 | 10.03 |
| dictionary/search/english-10 | 690 | 0.91 ± 0.7% | not timed | not timed | 109.87 ± 0.5% | 0.00 ± 0.3% | not timed | not timed | 0.92 ± 0.8% | | 0.99 | 0.0083 | 196.14 |
| dictionary/search/english-15 | 15 | 463.77 ± 1.0% | not timed | not timed | 441.99 ± 0.5% | 0.27 ± 1.6% | not timed | not timed | 462.88 ± 0.4% | | 1.00 | 1.05 | 1694.43 |
| folly/awyer-inn-busted | 1 | 3680.03 ± 0.1% | not timed | not timed | 112.58 ± 0.1% | 37.35 ± 16.1% | not timed | not timed | 3683.12 ± 1.6% | | 1.00 | 32.69 | 98.53 |
| folly/literal-never-match-rare | 0 | 54167.79 ± 2.0% | not timed | not timed | 40401.88 ± 7.1% | 54349.24 ± 1.5% | not timed | not timed | 54779.47 ± 1.7% | | 0.99 | 1.34 | 1.00 |
| folly/literal-never-match-frequent | 0 | 18067.24 ± 0.7% | not timed | not timed | 40053.64 ± 0.9% | 2088.95 ± 0.5% | not timed | not timed | 18046.63 ± 1.0% | | 1.00 | 0.45 | 8.65 |
| folly/literal-never-match-tricksy | 1 | 3204.15 ± 21.7% | not timed | not timed | 4800.91 ± 0.5% | 1512.96 ± 0.6% | not timed | not timed | 3128.19 ± 0.3% | | 1.02 | 0.67 | 2.12 |
| grep/every-line | 239963 | 1206.46 ± 8.8% | not timed | not timed | 790.95 ± 6.2% | 284.44 ± 31.4% | not timed | not timed | 1218.22 ± 0.9% | | 0.99 | 1.53 | 4.24 |
| grep/long-words-ascii | 5073 | 434.44 ± 1.8% | not timed | not timed | 408.83 ± 0.3% | 38.11 ± 7.2% | not timed | not timed | 430.55 ± 1.2% | | 1.01 | 1.06 | 11.40 |
| imported/leipzig/twain | 811 | 44622.05 ± 21.7% | not timed | not timed | 37065.84 ± 1.2% | 10286.54 ± 21.6% | not timed | not timed | 44639.11 ± 4.4% | | 1.00 | 1.20 | 4.34 |
| imported/leipzig/twain-insensitive | 965 | 12990.02 ± 0.7% | not timed | not timed | 11223.20 ± 2.1% | 35.24 ± 2.9% | not timed | not timed | 12779.92 ± 0.6% | | 1.02 | 1.16 | 368.62 |
| imported/leipzig/shing | 1540 | 549.60 ± 0.2% | not timed | not timed | 18769.40 ± 0.3% | 29.93 ± 1.1% | not timed | not timed | 550.84 ± 0.1% | | 1.00 | 0.0293 | 18.36 |
| imported/leipzig/huck-saw | 262 | 20738.97 ± 1.1% | not timed | not timed | 15765.65 ± 1.1% | 27.47 ± 3.8% | not timed | not timed | 20693.73 ± 20.4% | | 1.00 | 1.32 | 754.97 |
| imported/leipzig/word-ending-nn | 262 | 532.45 ± 0.2% | not timed | not timed | 531.96 ± 0.2% | 21.14 ± 2.8% | not timed | not timed | 533.14 ± 0.3% | | 1.00 | 1.00 | 25.18 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 9916.14 ± 1.2% | not timed | not timed | 3328.64 ± 3.5% | 9.66 ± 1.2% | not timed | not timed | 9985.39 ± 1.0% | | 0.99 | 2.98 | 1026.60 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 16938.43 ± 5.2% | not timed | not timed | 14281.28 ± 3.3% | 14.86 ± 1.7% | not timed | not timed | 17015.45 ± 15.9% | | 1.00 | 1.19 | 1140.08 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4992.26 ± 0.3% | not timed | not timed | 705.56 ± 0.6% | 9.35 ± 2.3% | not timed | not timed | 4987.95 ± 0.4% | | 1.00 | 7.08 | 533.90 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 531.61 ± 0.9% | not timed | not timed | 530.75 ± 0.2% | 9.79 ± 0.9% | not timed | not timed | 531.84 ± 0.1% | | 1.00 | 1.00 | 54.28 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 532.15 ± 0.2% | not timed | not timed | 530.81 ± 0.4% | 8.30 ± 0.9% | not timed | not timed | 532.04 ± 0.2% | | 1.00 | 1.00 | 64.10 |
| imported/leipzig/tom-river | 2 | 10987.94 ± 2.8% | not timed | not timed | 11160.93 ± 21.1% | 27.02 ± 1.2% | not timed | not timed | 11007.00 ± 0.6% | | 1.00 | 0.98 | 406.60 |
| imported/leipzig/ing | 78424 | 523.75 ± 0.3% | not timed | not timed | 492.70 ± 0.3% | 23.86 ± 4.2% | not timed | not timed | 523.43 ± 0.5% | | 1.00 | 1.06 | 21.95 |
| imported/leipzig/ing-whitespace | 55248 | 642.67 ± 2.0% | not timed | not timed | 1868.15 ± 0.5% | 17.80 ± 5.0% | not timed | not timed | 649.29 ± 1.5% | | 0.99 | 0.34 | 36.10 |
| imported/leipzig/awyer-inn | 209 | 672.64 ± 1.4% | not timed | not timed | 11491.21 ± 0.6% | 19.46 ± 0.5% | not timed | not timed | 672.67 ± 1.4% | | 1.00 | 0.0585 | 34.57 |
| imported/leipzig/quotes-bounded | 8886 | 1623.43 ± 0.4% | not timed | not timed | 2857.72 ± 0.4% | 31.96 ± 0.3% | not timed | not timed | 1623.55 ± 0.5% | | 1.00 | 0.57 | 50.79 |
| imported/leipzig/non-ascii-alternate | 2 | 30704.86 ± 1.0% | not timed | not timed | 16547.40 ± 0.6% | 42.60 ± 0.4% | not timed | not timed | 30960.80 ± 2.5% | | 0.99 | 1.86 | 720.79 |
| imported/leipzig/math-symbols | 69 | 1602.34 ± 0.5% | not timed | not timed | 532.48 ± 0.6% | 31.30 ± 0.3% | not timed | not timed | 1602.97 ± 0.2% | | 1.00 | 3.01 | 51.19 |
| imported/leipzig/bounded-strings-ending-z | 0 | 534.59 ± 0.4% | not timed | not timed | 532.26 ± 0.6% | 19.96 ± 0.2% | not timed | not timed | 534.30 ± 0.4% | | 1.00 | 1.00 | 26.78 |
| imported/lh3lh3-reb/uri | 17549 | 603.47 ± 1.3% | not timed | not timed | 895.33 ± 0.5% | 22.51 ± 3.1% | not timed | not timed | 598.00 ± 1.3% | | 1.01 | 0.67 | 26.81 |
| imported/lh3lh3-reb/email | 15057 | 655.10 ± 0.5% | not timed | not timed | 916.52 ± 9.1% | 25.66 ± 2.0% | not timed | not timed | 653.64 ± 1.0% | | 1.00 | 0.71 | 25.53 |
| imported/lh3lh3-reb/date | 668 | 754.94 ± 0.5% | not timed | not timed | 818.16 ± 0.4% | 43.66 ± 1.8% | not timed | not timed | 756.70 ± 0.4% | | 1.00 | 0.92 | 17.29 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 616.19 ± 0.3% | not timed | not timed | 371.00 ± 0.2% | 12.65 ± 1.4% | not timed | not timed | 615.47 ± 2.4% | | 1.00 | 1.66 | 48.72 |
| imported/mariomka/email | 92 | 614.38 ± 0.2% | not timed | not timed | 38209.08 ± 1.4% | 28.05 ± 1.2% | not timed | not timed | 614.42 ± 0.7% | | 1.00 | 0.0161 | 21.90 |
| imported/mariomka/uri | 5301 | 525.32 ± 0.9% | not timed | not timed | 6527.60 ± 22.5% | 28.05 ± 0.3% | not timed | not timed | 525.65 ± 0.3% | | 1.00 | 0.0805 | 18.73 |
| imported/mariomka/ip | 5 | 1546.50 ± 3.1% | not timed | not timed | 2036.22 ± 0.3% | 17.55 ± 4.3% | not timed | not timed | 1555.79 ± 3.4% | | 0.99 | 0.76 | 88.10 |
| imported/rsc/no-exponential | 0 | 628.73 ± 18.5% | not timed | not timed | 336.63 ± 0.4% | 19.29 ± 6.2% | not timed | not timed | 626.93 ± 1.2% | | 1.00 | 1.87 | 32.59 |
| imported/rsc/literal | 1 | 753.05 ± 1.9% | not timed | not timed | 1741.89 ± 19.4% | 161.95 ± 12.5% | not timed | not timed | 752.64 ± 1.3% | | 1.00 | 0.43 | 4.65 |
| imported/rsc/not-literal | 2 | 633.20 ± 19.7% | not timed | not timed | 724.32 ± 0.4% | 40.78 ± 9.4% | not timed | not timed | 632.62 ± 7.8% | | 1.00 | 0.87 | 15.53 |
| imported/rsc/match-class | 1 | 1046.14 ± 2.0% | not timed | not timed | 1506.34 ± 0.7% | 50.01 ± 0.3% | not timed | not timed | 1038.41 ± 1.1% | | 1.01 | 0.69 | 20.92 |
| imported/rsc/match-class-in-range | 1 | 1043.16 ± 3.1% | not timed | not timed | 2709.27 ± 1.3% | 51.61 ± 14.4% | not timed | not timed | 1044.80 ± 0.7% | | 1.00 | 0.39 | 20.21 |
| imported/rsc/match-class-unicode | 1 | 465.48 ± 0.3% | not timed | not timed | 454.53 ± 0.4% | 62.03 ± 0.8% | not timed | not timed | 466.66 ± 0.2% | | 1.00 | 1.02 | 7.50 |
| imported/rsc/anchored-literal-short-non-match | 0 | 501.38 ± 0.4% | not timed | not timed | 896.71 ± 0.2% | 263.40 ± 2.3% | not timed | not timed | 501.04 ± 0.1% | | 1.00 | 0.56 | 1.90 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7718.24 ± 0.2% | not timed | not timed | 13433.88 ± 1.5% | 3942.08 ± 3.2% | not timed | not timed | 7708.92 ± 28.9% | | 1.00 | 0.57 | 1.96 |
| imported/rsc/anchored-literal-short-match | 4 | 338.15 ± 2.7% | not timed | not timed | 496.82 ± 1.7% | 80.21 ± 5.9% | not timed | not timed | 351.22 ± 5.9% | | 0.96 | 0.68 | 4.22 |
| imported/rsc/anchored-literal-long-match | 4 | 2303.25 ± 2.2% | not timed | not timed | 7566.98 ± 1.8% | 1244.36 ± 10.2% | not timed | not timed | 2300.01 ± 1.3% | | 1.00 | 0.30 | 1.85 |
| imported/rsc/one-pass-short | 17 | 257.55 ± 1.6% | not timed | not timed | 217.32 ± 1.2% | 27.71 ± 9.5% | not timed | not timed | 256.97 ± 1.5% | | 1.00 | 1.19 | 9.30 |
| imported/rsc/one-pass-short-not | 17 | 192.08 ± 1.5% | not timed | not timed | 229.24 ± 0.4% | 25.30 ± 9.2% | not timed | not timed | 191.73 ± 1.3% | | 1.00 | 0.84 | 7.59 |
| imported/rsc/one-pass-long-prefix | 26 | 208.34 ± 2.1% | not timed | not timed | 276.38 ± 0.3% | 91.12 ± 55.5% | not timed | not timed | 206.15 ± 2.7% | | 1.01 | 0.75 | 2.29 |
| imported/rsc/one-pass-long-prefix-not | 26 | 281.53 ± 2.1% | not timed | not timed | 275.21 ± 1.8% | 67.42 ± 22.4% | not timed | not timed | 281.07 ± 14.5% | | 1.00 | 1.02 | 4.18 |
| imported/rsc/long-needle1 | 31 | 57508.48 ± 8.6% | not timed | not timed | 39972.25 ± 20.6% | 3.32 ± 0.3% | not timed | not timed | 57364.98 ± 1.7% | | 1.00 | 1.44 | 17304.15 |
| imported/rsc/long-needle2 | 31 | 56737.56 ± 20.5% | not timed | not timed | 172.06 ± 0.4% | 3.32 ± 0.2% | not timed | not timed | 56720.13 ± 2.1% | | 1.00 | 329.76 | 17068.92 |
| imported/rsc/easy0-32 | 26 | 1044.41 ± 1.7% | not timed | not timed | 1524.95 ± 18.8% | 115.19 ± 13.8% | not timed | not timed | 1042.51 ± 1.7% | | 1.00 | 0.68 | 9.07 |
| imported/rsc/easy0-1k | 26 | 14868.27 ± 7.5% | not timed | not timed | 11764.55 ± 6.7% | 1863.46 ± 11.2% | not timed | not timed | 14890.51 ± 2.1% | | 1.00 | 1.26 | 7.98 |
| imported/rsc/easy0-32k | 26 | 55544.27 ± 1.8% | not timed | not timed | 38305.11 ± 1.3% | 20625.67 ± 35.4% | not timed | not timed | 55605.39 ± 16.1% | | 1.00 | 1.45 | 2.69 |
| imported/rsc/easy0-1mb | 26 | 55428.75 ± 1.4% | not timed | not timed | 40119.29 ± 0.6% | 54177.82 ± 0.8% | not timed | not timed | 55307.85 ± 0.4% | | 1.00 | 1.38 | 1.02 |
| imported/rsc/easy1-32 | 19 | 323.04 ± 3.0% | not timed | not timed | 645.22 ± 0.4% | 116.85 ± 12.7% | not timed | not timed | 324.82 ± 0.4% | | 0.99 | 0.50 | 2.76 |
| imported/rsc/easy1-1k | 19 | 513.39 ± 2.3% | not timed | not timed | 13231.63 ± 7.2% | 1905.96 ± 14.1% | not timed | not timed | 512.78 ± 0.7% | | 1.00 | 0.0388 | 0.27 |
| imported/rsc/easy1-32k | 19 | 531.02 ± 1.8% | not timed | not timed | 415024.14 ± 1.2% | 22844.67 ± 20.3% | not timed | not timed | 531.78 ± 0.5% | | 1.00 | 0.0013 | 0.0232 |
| imported/rsc/easy1-1mb | 19 | 533.35 ± 0.8% | not timed | not timed | 13202631.30 ± 8.5% | 54831.91 ± 2.2% | not timed | not timed | 533.39 ± 1.4% | | 1.00 | 0.0000 | 0.0097 |
| imported/rsc/medium-32 | 27 | 399.46 ± 1.5% | not timed | not timed | 625.45 ± 0.5% | 60.30 ± 10.7% | not timed | not timed | 398.43 ± 0.2% | | 1.00 | 0.64 | 6.62 |
| imported/rsc/medium-1k | 27 | 6464.88 ± 0.8% | not timed | not timed | 11134.42 ± 0.8% | 61.20 ± 1.5% | not timed | not timed | 6455.15 ± 0.6% | | 1.00 | 0.58 | 105.63 |
| imported/rsc/medium-32k | 27 | 45389.01 ± 1.5% | not timed | not timed | 349528.52 ± 0.5% | 41.24 ± 2.4% | not timed | not timed | 44633.65 ± 0.2% | | 1.02 | 0.13 | 1100.64 |
| imported/rsc/medium-1mb | 27 | 53747.24 ± 28.2% | not timed | not timed | 11150241.00 ± 0.6% | 41.64 ± 0.7% | not timed | not timed | 53884.43 ± 7.1% | | 1.00 | 0.0048 | 1290.91 |
| imported/rsc/hard-32 | 58 | 231.27 ± 0.6% | not timed | not timed | 339.09 ± 1.1% | 41.43 ± 7.0% | not timed | not timed | 231.46 ± 2.0% | | 1.00 | 0.68 | 5.58 |
| imported/rsc/hard-1k | 27 | 513.07 ± 0.4% | not timed | not timed | 10911.47 ± 9.2% | 33.47 ± 2.9% | not timed | not timed | 513.29 ± 0.3% | | 1.00 | 0.0470 | 15.33 |
| imported/rsc/hard-32k | 27 | 532.45 ± 0.5% | not timed | not timed | 347693.64 ± 0.2% | 25.46 ± 0.6% | not timed | not timed | 532.08 ± 0.3% | | 1.00 | 0.0015 | 20.91 |
| imported/rsc/hard-1mb | 51 | 533.77 ± 0.2% | not timed | not timed | 6810938.56 ± 7.5% | 25.60 ± 0.1% | not timed | not timed | 532.87 ± 0.6% | | 1.00 | 0.0001 | 20.85 |
| imported/rsc/reallyhard0-32 | 58 | 231.40 ± 0.9% | not timed | not timed | 214.76 ± 0.8% | 40.41 ± 7.0% | not timed | not timed | 231.61 ± 1.6% | | 1.00 | 1.08 | 5.73 |
| imported/rsc/reallyhard0-1k | 27 | 511.76 ± 0.8% | not timed | not timed | 511.26 ± 0.8% | 33.42 ± 0.6% | not timed | not timed | 513.23 ± 0.3% | | 1.00 | 1.00 | 15.31 |
| imported/rsc/reallyhard0-32k | 27 | 530.67 ± 0.3% | not timed | not timed | 531.17 ± 0.6% | 25.38 ± 0.4% | not timed | not timed | 532.59 ± 0.2% | | 1.00 | 1.00 | 20.91 |
| imported/rsc/reallyhard0-1mb | 51 | 533.94 ± 0.2% | not timed | not timed | 532.23 ± 0.6% | 25.48 ± 1.0% | not timed | not timed | 534.32 ± 0.2% | | 1.00 | 1.00 | 20.95 |
| imported/rsc/reallyreallyhard0-32 | 47 | 256.70 ± 0.5% | not timed | not timed | 181.69 ± 0.2% | 50.65 ± 11.0% | not timed | not timed | 255.32 ± 1.4% | | 1.01 | 1.41 | 5.07 |
| imported/rsc/reallyreallyhard0-1k | 16 | 759.48 ± 1.0% | not timed | not timed | 6407.85 ± 0.2% | 28.24 ± 0.3% | not timed | not timed | 758.53 ± 0.7% | | 1.00 | 0.12 | 26.90 |
| imported/rsc/reallyreallyhard0-32k | 16 | 553.83 ± 4.5% | not timed | not timed | 32331.72 ± 0.2% | 20.75 ± 0.5% | not timed | not timed | 555.92 ± 7.2% | | 1.00 | 0.0171 | 26.69 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 535.21 ± 0.3% | not timed | not timed | 39414.95 ± 0.5% | 20.72 ± 0.2% | not timed | not timed | 535.04 ± 11.0% | | 1.00 | 0.0136 | 25.84 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 250.17 ± 0.6% | not timed | not timed | 190.05 ± 5.6% | 50.85 ± 9.3% | not timed | not timed | 250.20 ± 2.4% | | 1.00 | 1.32 | 4.92 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 733.80 ± 4.5% | not timed | not timed | 6624.64 ± 0.5% | 28.20 ± 0.3% | not timed | not timed | 739.49 ± 0.7% | | 0.99 | 0.11 | 26.02 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 558.70 ± 11.7% | not timed | not timed | 32808.29 ± 0.5% | 20.80 ± 0.2% | not timed | not timed | 558.04 ± 5.0% | | 1.00 | 0.0170 | 26.86 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 534.40 ± 8.3% | not timed | not timed | 39573.15 ± 1.4% | 20.70 ± 0.4% | not timed | not timed | 534.89 ± 2.7% | | 1.00 | 0.0135 | 25.81 |
| imported/sherlock/name-sherlock | 776 | 38151.12 ± 11.0% | not timed | not timed | 31241.84 ± 0.3% | 9509.63 ± 22.6% | not timed | not timed | 38604.53 ± 6.6% | | 0.99 | 1.22 | 4.01 |
| imported/sherlock/name-holmes | 2766 | 19685.34 ± 1.2% | not timed | not timed | 18341.76 ± 2.5% | 2996.29 ± 26.9% | not timed | not timed | 19827.21 ± 2.7% | | 0.99 | 1.07 | 6.57 |
| imported/sherlock/name-sherlock-holmes | 1365 | 38892.36 ± 1.5% | not timed | not timed | 31621.72 ± 0.4% | 7590.61 ± 37.2% | not timed | not timed | 39158.16 ± 2.9% | | 0.99 | 1.23 | 5.12 |
| imported/sherlock/name-sherlock-casei | 816 | 31473.37 ± 0.9% | not timed | not timed | 9209.32 ± 1.5% | 28.33 ± 1.9% | not timed | not timed | 31204.77 ± 1.3% | | 1.01 | 3.42 | 1110.95 |
| imported/sherlock/name-holmes-casei | 2802 | 17001.79 ± 0.7% | not timed | not timed | 5919.85 ± 0.6% | 35.37 ± 0.7% | not timed | not timed | 16956.42 ± 1.4% | | 1.00 | 2.87 | 480.66 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 27842.22 ± 1.3% | not timed | not timed | 9032.30 ± 0.5% | 28.34 ± 1.4% | not timed | not timed | 27752.77 ± 1.1% | | 1.00 | 3.08 | 982.40 |
| imported/sherlock/name-whitespace | 1461 | 21913.51 ± 10.0% | not timed | not timed | 22571.19 ± 2.6% | 6891.02 ± 19.3% | not timed | not timed | 22011.84 ± 1.8% | | 1.00 | 0.97 | 3.18 |
| imported/sherlock/name-alt1 | 1142 | 20486.25 ± 1.5% | not timed | not timed | 23309.86 ± 3.1% | 3794.59 ± 23.0% | not timed | not timed | 20494.36 ± 0.7% | | 1.00 | 0.88 | 5.40 |
| imported/sherlock/name-alt2 | 3542 | 11975.06 ± 1.1% | not timed | not timed | 7766.23 ± 0.3% | 27.25 ± 27.1% | not timed | not timed | 12000.16 ± 1.1% | | 1.00 | 1.54 | 439.46 |
| imported/sherlock/name-alt3 | 4507 | 8259.14 ± 2.8% | not timed | not timed | 6864.37 ± 1.7% | 8.59 ± 2.6% | not timed | not timed | 8157.50 ± 3.8% | | 1.01 | 1.20 | 961.25 |
| imported/sherlock/name-alt3-casei | 4593 | 1560.35 ± 2.3% | not timed | not timed | 1086.95 ± 2.7% | 5.66 ± 16.1% | not timed | not timed | 1566.56 ± 0.8% | | 1.00 | 1.44 | 275.90 |
| imported/sherlock/name-alt4 | 3686 | 6778.78 ± 0.3% | not timed | not timed | 6064.51 ± 1.1% | 27.17 ± 26.9% | not timed | not timed | 6788.78 ± 0.7% | | 1.00 | 1.12 | 249.52 |
| imported/sherlock/name-alt4-casei | 4254 | 3059.37 ± 14.7% | not timed | not timed | 3156.92 ± 0.3% | 16.63 ± 1.9% | not timed | not timed | 3074.38 ± 0.8% | | 1.00 | 0.97 | 183.96 |
| imported/sherlock/name-alt5 | 4028 | 10228.33 ± 0.6% | not timed | not timed | 7396.95 ± 8.4% | 19.06 ± 2.0% | not timed | not timed | 10197.80 ± 16.3% | | 1.00 | 1.38 | 536.64 |
| imported/sherlock/name-alt5-casei | 4104 | 4585.23 ± 7.8% | not timed | not timed | 2405.82 ± 0.1% | 12.26 ± 0.9% | not timed | not timed | 4632.61 ± 1.9% | | 0.99 | 1.91 | 373.95 |
| imported/sherlock/no-match-uncommon | 0 | 54872.66 ± 0.8% | not timed | not timed | 49275.10 ± 0.2% | 44922.67 ± 0.3% | not timed | not timed | 54800.65 ± 1.5% | | 1.00 | 1.11 | 1.22 |
| imported/sherlock/no-match-common | 0 | 53412.72 ± 0.6% | not timed | not timed | 49247.43 ± 0.4% | 1575.44 ± 7.4% | not timed | not timed | 53390.63 ± 15.9% | | 1.00 | 1.08 | 33.90 |
| imported/sherlock/no-match-really-common | 0 | 32835.53 ± 1.8% | not timed | not timed | 30638.47 ± 0.4% | 1575.44 ± 0.4% | not timed | not timed | 31957.58 ± 0.6% | | 1.03 | 1.07 | 20.84 |
| imported/sherlock/the-lower | 21654 | 2404.96 ± 9.9% | not timed | not timed | 2195.84 ± 0.3% | 229.39 ± 16.8% | not timed | not timed | 2451.63 ± 0.9% | | 0.98 | 1.10 | 10.48 |
| imported/sherlock/the-upper | 2223 | 13749.53 ± 6.2% | not timed | not timed | 18435.88 ± 0.8% | 2694.18 ± 19.5% | not timed | not timed | 14301.32 ± 0.4% | | 0.96 | 0.75 | 5.10 |
| imported/sherlock/the-casei | 23961 | 2204.05 ± 15.2% | not timed | not timed | 1129.03 ± 0.5% | 32.59 ± 30.8% | not timed | not timed | 2209.06 ± 0.6% | | 1.00 | 1.95 | 67.64 |
| imported/sherlock/everything-greedy | 581881 | 229.67 ± 6.7% | not timed | not timed | 144.87 ± 0.6% | 24.01 ± 18.3% | not timed | not timed | 234.13 ± 11.2% | | 0.98 | 1.59 | 9.56 |
| imported/sherlock/everything-greedy-nl | 594933 | 407.13 ± 0.1% | not timed | not timed | 186.96 ± 2.9% | 27.06 ± 3.5% | not timed | not timed | 406.69 ± 0.8% | | 1.00 | 2.18 | 15.04 |
| imported/sherlock/letters | 447175 | 43.64 ± 9.5% | not timed | not timed | 29.94 ± 24.9% | 4.46 ± 6.2% | not timed | not timed | 43.82 ± 0.5% | | 1.00 | 1.46 | 9.79 |
| imported/sherlock/letters-upper | 14180 | 374.47 ± 14.3% | not timed | not timed | 319.96 ± 10.3% | 25.33 ± 25.7% | not timed | not timed | 375.81 ± 0.5% | | 1.00 | 1.17 | 14.78 |
| imported/sherlock/letters-lower | 432995 | 44.63 ± 0.6% | not timed | not timed | 29.90 ± 0.1% | 4.68 ± 44.5% | not timed | not timed | 44.13 ± 0.8% | | 1.01 | 1.49 | 9.54 |
| imported/sherlock/words | 447639 | 77.83 ± 10.5% | not timed | not timed | 72.73 ± 0.2% | 11.84 ± 19.2% | not timed | not timed | 78.24 ± 1.2% | | 0.99 | 1.07 | 6.58 |
| imported/sherlock/before-holmes | 4073 | 525.29 ± 0.4% | not timed | not timed | 9798.64 ± 0.5% | 20.13 ± 0.7% | not timed | not timed | 524.97 ± 0.3% | | 1.00 | 0.0536 | 26.10 |
| imported/sherlock/before-after-holmes | 2593 | 527.59 ± 0.9% | not timed | not timed | 11083.01 ± 0.5% | 20.12 ± 0.8% | not timed | not timed | 528.13 ± 0.3% | | 1.00 | 0.0476 | 26.22 |
| imported/sherlock/holmes-cochar-watson | 150 | 7363.62 ± 0.6% | not timed | not timed | 5985.07 ± 0.4% | 26.94 ± 0.6% | not timed | not timed | 7389.00 ± 0.5% | | 1.00 | 1.23 | 273.33 |
| imported/sherlock/holmes-coword-watson | 14309 | 1117.58 ± 0.4% | not timed | not timed | 1076.79 ± 1.9% | 5.85 ± 0.8% | not timed | not timed | 1118.37 ± 0.3% | | 1.00 | 1.04 | 191.08 |
| imported/sherlock/quotes | 14437 | 1120.99 ± 0.2% | not timed | not timed | 1560.14 ± 0.8% | 29.21 ± 25.2% | not timed | not timed | 1120.19 ± 9.1% | | 1.00 | 0.72 | 38.38 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 531.13 ± 0.2% | not timed | not timed | 24732.58 ± 6.0% | 31.82 ± 1.0% | not timed | not timed | 531.71 ± 0.2% | | 1.00 | 0.0215 | 16.69 |
| imported/sherlock/word-ending-n | 35297 | 398.68 ± 0.8% | not timed | not timed | 352.89 ± 7.8% | 20.09 ± 22.4% | not timed | not timed | 399.37 ± 11.7% | | 1.00 | 1.13 | 19.85 |
| imported/sherlock/repeated-class-negation | 2130 | 12210.20 ± 6.3% | not timed | not timed | 12151.12 ± 4.4% | 9.78 ± 0.5% | not timed | not timed | 12266.60 ± 3.7% | | 1.00 | 1.00 | 1248.89 |
| imported/sherlock/ing-suffix | 20547 | 481.11 ± 0.4% | not timed | not timed | 446.06 ± 0.2% | 24.40 ± 0.4% | not timed | not timed | 480.52 ± 0.2% | | 1.00 | 1.08 | 19.72 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 515.49 ± 0.9% | not timed | not timed | 1932.49 ± 0.3% | 17.75 ± 14.4% | not timed | not timed | 515.12 ± 0.9% | | 1.00 | 0.27 | 29.04 |
| opt/accelerate/whole-line | 239963 | 435.56 ± 0.7% | not timed | not timed | 343.36 ± 0.5% | 75.75 ± 17.3% | not timed | not timed | 434.12 ± 1.3% | | 1.00 | 1.27 | 5.75 |
| opt/accelerate/non-dna | 16745 | 371.42 ± 12.2% | not timed | not timed | 369.08 ± 0.3% | 25.52 ± 14.4% | not timed | not timed | 371.73 ± 0.6% | | 1.00 | 1.01 | 14.55 |
| opt/backtrack/words-english | 40536 | 104.36 ± 17.0% | not timed | not timed | 84.83 ± 4.0% | 16.31 ± 8.1% | not timed | not timed | 105.21 ± 6.1% | | 0.99 | 1.23 | 6.40 |
| opt/fixed-length/too-small-ascii | 0 | 300.88 ± 0.4% | not timed | not timed | 622.46 ± 9.4% | 99.25 ± 2.8% | not timed | not timed | 300.82 ± 0.5% | | 1.00 | 0.48 | 3.03 |
| opt/fixed-length/too-big-ascii | 0 | 664.37 ± 10.6% | not timed | not timed | 4920.43 ± 0.2% | 115.03 ± 0.9% | not timed | not timed | 663.84 ± 0.5% | | 1.00 | 0.14 | 5.78 |
| opt/fixed-length/go33484-1 | 0 | 51.73 ± 0.4% | not timed | not timed | 944426.16 ± 1.1% | 67395.82 ± 14.3% | not timed | not timed | 51.81 ± 4.6% | | 1.00 | 0.0001 | 0.0008 |
| opt/fixed-length/go33484-2 | 0 | 3640.77 ± 12.0% | not timed | not timed | 945232.37 ± 2.9% | 23869.49 ± 0.5% | not timed | not timed | 3646.17 ± 12.0% | | 1.00 | 0.0039 | 0.15 |
| opt/fixed-length/go33484-3 | 0 | 1441.02 ± 0.7% | not timed | not timed | 94487.81 ± 0.2% | 746.26 ± 17.2% | not timed | not timed | 1433.88 ± 0.1% | | 1.00 | 0.0153 | 1.93 |
| opt/literal-alt/one-pattern | 1 | 493.74 ± 1.5% | not timed | not timed | 482.81 ± 1.5% | 0.30 ± 14.9% | not timed | not timed | 492.80 ± 1.4% | | 1.00 | 1.02 | 1630.39 |
| opt/onepass/fn-predicate | 916 | 325.73 ± 3.0% | not timed | not timed | 328.86 ± 1.9% | 174.03 ± 32.0% | not timed | not timed | 327.65 ± 3.8% | | 0.99 | 0.99 | 1.87 |
| opt/onepass/first-three-words-english | 35128 | 107.99 ± 10.0% | not timed | not timed | 192.01 ± 0.2% | 64.50 ± 14.6% | not timed | not timed | 114.27 ± 1.6% | | 0.95 | 0.56 | 1.67 |
| opt/prefilter/literal-english | 1 | 54465.07 ± 16.3% | not timed | not timed | 39719.71 ± 0.4% | 19182.48 ± 5.1% | not timed | not timed | 54787.66 ± 14.6% | | 0.99 | 1.37 | 2.84 |
| opt/prefilter/literal-casei-english | 1 | 33548.68 ± 1.8% | not timed | not timed | 11889.40 ± 0.9% | 28.50 ± 27.2% | not timed | not timed | 33597.44 ± 1.3% | | 1.00 | 2.82 | 1177.04 |
| opt/prefilter/literal-russian | 1 | 55329.00 ± 0.4% | not timed | not timed | 39538.30 ± 0.4% | 1580.61 ± 0.2% | not timed | not timed | 55260.77 ± 8.1% | | 1.00 | 1.40 | 35.00 |
| opt/prefilter/literal-casei-russian | 1 | 21891.11 ± 0.3% | not timed | not timed | 8240.03 ± 0.4% | 30.64 ± 22.3% | not timed | not timed | 21860.88 ± 6.2% | | 1.00 | 2.66 | 714.41 |
| opt/prefilter/rust-functions | 948 | 11819.65 ± 0.3% | not timed | not timed | 10458.20 ± 0.2% | 1565.56 ± 17.8% | not timed | not timed | 11724.09 ± 0.5% | | 1.01 | 1.13 | 7.55 |
| opt/reverse-anchored/word-end | 1 | 3673.37 ± 5.3% | not timed | not timed | 22647412.31 ± 9.2% | 41.84 ± 0.3% | not timed | not timed | 3672.30 ± 1.1% | | 1.00 | 0.0002 | 87.79 |
| opt/reverse-inner/holmes | 2593 | 527.56 ± 0.2% | not timed | not timed | 11103.62 ± 0.7% | 20.30 ± 18.8% | not timed | not timed | 528.20 ± 0.3% | | 1.00 | 0.0475 | 25.99 |
| opt/reverse-inner/email | 47 | 908.44 ± 0.5% | not timed | not timed | 57132.50 ± 1.6% | 27.73 ± 5.8% | not timed | not timed | 908.72 ± 1.1% | | 1.00 | 0.0159 | 32.76 |
| opt/reverse-inner/factored-prefix | 3542 | 521.55 ± 0.2% | not timed | not timed | 515.93 ± 0.6% | 11.01 ± 0.8% | not timed | not timed | 521.44 ± 0.4% | | 1.00 | 1.01 | 47.37 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3636.23 ± 5.8% | not timed | not timed | 531.26 ± 0.9% | 64.29 ± 1.1% | not timed | not timed | 3635.54 ± 8.5% | | 1.00 | 6.84 | 56.56 |
| opt/reverse-inner/no-quadratic-forward | 0 | 622.60 ± 4.7% | not timed | not timed | 246.76 ± 3.6% | 20.94 ± 0.6% | not timed | not timed | 621.14 ± 4.8% | | 1.00 | 2.52 | 29.73 |
| opt/reverse-suffix/holmes | 4073 | 525.70 ± 1.3% | not timed | not timed | 9732.96 ± 18.0% | 20.14 ± 3.1% | not timed | not timed | 525.53 ± 1.3% | | 1.00 | 0.0540 | 26.11 |
| opt/reverse-suffix/no-quadratic | 0 | 3637.73 ± 0.2% | not timed | not timed | 533.26 ± 0.9% | 64.06 ± 1.2% | not timed | not timed | 3636.75 ± 0.1% | | 1.00 | 6.82 | 56.78 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 111.76 ± 2.1% | not timed | not timed | 134.14 ± 0.6% | 11.86 ± 39.0% | not timed | not timed | 111.55 ± 14.3% | | 1.00 | 0.83 | 9.42 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 111.55 ± 2.0% | not timed | not timed | 136.44 ± 1.0% | 11.66 ± 24.6% | not timed | not timed | 111.60 ± 1.3% | | 1.00 | 0.82 | 9.57 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.25 ± 1.8% | not timed | not timed | 0.42 ± 0.6% | 92.88 ± 0.7% | not timed | not timed | 0.25 ± 0.3% | | 0.99 | 0.61 | 0.0027 |
| reported/i1095-word-repetition/ascii-search | 256 | 262.67 ± 0.2% | not timed | not timed | 245.87 ± 0.4% | 80.37 ± 1.2% | not timed | not timed | 263.26 ± 0.4% | | 1.00 | 1.07 | 3.27 |
| reported/i13-subset-regex/original-ascii | 4094 | 10026.50 ± 1.5% | not timed | not timed | 3159.04 ± 3.6% | 9.60 ± 2.2% | not timed | not timed | 10051.19 ± 0.6% | | 1.00 | 3.17 | 1044.58 |
| reported/i13-subset-regex/original-unicode | 4094 | 9985.36 ± 1.1% | not timed | not timed | 167.48 ± 5.0% | 9.63 ± 1.6% | not timed | not timed | 10030.28 ± 5.0% | | 1.00 | 59.62 | 1036.85 |
| reported/i13-subset-regex/big-ascii | 1955 | 9424.22 ± 2.2% | not timed | not timed | 43.15 ± 2.2% | 8.28 ± 0.3% | not timed | not timed | 9472.59 ± 0.7% | | 0.99 | 218.38 | 1137.89 |
| reported/i13-subset-regex/big-unicode | 1955 | 9402.72 ± 1.9% | not timed | not timed | 7.78 ± 55.7% | 8.24 ± 0.9% | not timed | not timed | 9455.49 ± 1.0% | | 0.99 | 1208.61 | 1141.10 |
| reported/i13-subset-regex/huge-ascii | 55 | 8645.52 ± 8.6% | not timed | not timed | 7.28 ± 2.3% | 7.32 ± 0.9% | not timed | not timed | 8757.40 ± 1.7% | | 0.99 | 1187.15 | 1181.12 |
| reported/i13-subset-regex/huge-unicode | 55 | 8738.11 ± 2.0% | not timed | not timed | 7.18 ± 0.9% | 7.33 ± 1.1% | not timed | not timed | 8751.53 ± 1.3% | | 1.00 | 1216.61 | 1191.97 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.10 ± 0.5% | not timed | not timed | 7.19 ± 1.1% | 7.31 ± 0.9% | not timed | not timed | 3.10 ± 0.3% | | 1.00 | 0.43 | 0.42 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.38 ± 0.3% | not timed | not timed | 7.08 ± 0.9% | 7.30 ± 1.2% | not timed | not timed | 4.36 ± 0.7% | | 1.01 | 0.62 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 398.69 ± 0.9% | not timed | not timed | 123.70 ± 10.5% | 5.48 ± 0.4% | not timed | not timed | 403.06 ± 1.9% | | 0.99 | 3.22 | 72.81 |
| reported/i787-keywords/opt-ascii | 5674 | 401.70 ± 0.2% | not timed | not timed | 213.59 ± 0.2% | 9.02 ± 9.7% | not timed | not timed | 405.34 ± 0.4% | | 0.99 | 1.88 | 44.55 |
| slow/quadratic-regex-1x | 100 | 6.46 ± 6.9% | not timed | not timed | 4.63 ± 0.8% | 0.04 ± 0.3% | not timed | not timed | 6.52 ± 25.0% | | 0.99 | 1.39 | 153.63 |
| slow/quadratic-regex-2x | 199 | 3.06 ± 4.6% | not timed | not timed | 2.49 ± 3.4% | 0.01 ± 1.1% | not timed | not timed | 3.11 ± 4.6% | | 0.98 | 1.23 | 285.07 |
| slow/quadratic-haystack-1x | 100 | 21.64 ± 58.6% | not timed | not timed | 9.09 ± 0.6% | 0.83 ± 15.1% | not timed | not timed | 21.64 ± 1.3% | | 1.00 | 2.38 | 26.13 |
| slow/quadratic-haystack-2x | 200 | 16.20 ± 1.2% | not timed | not timed | 4.92 ± 0.4% | 0.44 ± 1.1% | not timed | not timed | 16.26 ± 2.2% | | 1.00 | 3.30 | 36.82 |
| unicode/codepoints/any-one | 1112064 | 276.16 ± 12.9% | not timed | not timed | 184.85 ± 0.3% | 16.21 ± 19.5% | not timed | not timed | 277.21 ± 26.3% | | 1.00 | 1.49 | 17.04 |
| unicode/codepoints/any-all | 4382592 | 238.68 ± 0.3% | not timed | not timed | 235.69 ± 0.3% | 98.50 ± 0.3% | not timed | not timed | 238.47 ± 10.0% | | 1.00 | 1.01 | 2.42 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.30 ± 1.4% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 533.37 ± 0.1% | not timed | not timed | 531.68 ± 0.8% | 120.76 ± 1.3% | not timed | not timed | 533.72 ± 0.8% | | 1.00 | 1.00 | 4.42 |
| unicode/overlapping-words/ascii | 6156 | 21.36 ± 2.3% | not timed | not timed | 33.64 ± 0.6% | 3.46 ± 1.6% | not timed | not timed | 21.41 ± 1.2% | | 1.00 | 0.64 | 6.17 |
| unicode/overlapping-words/english | 6156 | 1.12 ± 0.4% | not timed | not timed | 2.24 ± 0.9% | 2.17 ± 1.9% | not timed | not timed | 1.14 ± 0.4% | | 0.98 | 0.50 | 0.52 |
| unicode/overlapping-words/russian | 5710 | 1.02 ± 7.2% | not timed | not timed | 2.40 ± 0.4% | 5.38 ± 7.5% | not timed | not timed | 1.06 ± 0.7% | | 0.96 | 0.43 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 98.61 ± 8.1% | not timed | not timed | 73.76 ± 0.5% | 9.21 ± 25.9% | not timed | not timed | 99.40 ± 1.4% | | 0.99 | 1.34 | 10.70 |
| unicode/word/boundary-long-english | 3466 | 532.59 ± 0.3% | not timed | not timed | 522.51 ± 0.2% | 26.71 ± 27.8% | not timed | not timed | 532.87 ± 0.6% | | 1.00 | 1.02 | 19.94 |
| unicode/word/around-holmes-english | 27 | 532.25 ± 0.7% | not timed | not timed | 37548.43 ± 0.8% | 18.53 ± 0.3% | not timed | not timed | 533.16 ± 0.5% | | 1.00 | 0.0142 | 28.73 |
| wild/bibleref/long | 874 | 483.72 ± 1.1% | not timed | not timed | 494.87 ± 0.8% | 6.43 ± 1.1% | not timed | not timed | 484.67 ± 0.5% | | 1.00 | 0.98 | 75.28 |
| wild/bibleref/short | 30 | 16.82 ± 6.6% | not timed | not timed | 26.36 ± 1.7% | 11.74 ± 14.8% | not timed | not timed | 17.61 ± 5.3% | | 0.96 | 0.64 | 1.43 |
| wild/bibleref/line | 874 | 378.30 ± 0.4% | not timed | not timed | 214.17 ± 6.8% | 7.67 ± 1.2% | not timed | not timed | 380.14 ± 0.5% | | 1.00 | 1.77 | 49.30 |
| wild/caddy/caddy | 6 | 350.84 ± 2.8% | not timed | not timed | 246.97 ± 0.5% | 62.72 ± 13.8% | not timed | not timed | 354.59 ± 2.9% | | 0.99 | 1.42 | 5.59 |
| wild/dot-star-capture/rust-src-tools | 6 | 1276.46 ± 0.3% | not timed | not timed | 352.75 ± 0.4% | 11.43 ± 3.0% | not timed | not timed | 1275.38 ± 0.2% | | 1.00 | 3.62 | 111.65 |
| wild/ruff/noqa | 84 | 417.91 ± 0.8% | not timed | not timed | 433.99 ± 0.4% | 16.27 ± 2.3% | not timed | not timed | 419.67 ± 0.9% | | 1.00 | 0.96 | 25.68 |
| wild/ruff/unnecessary-coding-comment | 16 | 467.96 ± 0.5% | not timed | not timed | 600.46 ± 0.7% | 113.16 ± 4.2% | not timed | not timed | 468.58 ± 0.5% | | 1.00 | 0.78 | 4.14 |
| wild/ruff/string-quote-prefix | 2972 | 421.81 ± 0.7% | not timed | not timed | 323.34 ± 0.9% | 307.19 ± 33.5% | not timed | not timed | 422.12 ± 0.4% | | 1.00 | 1.30 | 1.37 |
| wild/ruff/space-around-operator | 1224378 | 181.48 ± 2.9% | not timed | not timed | 186.73 ± 0.3% | 14.95 ± 2.5% | not timed | not timed | 182.06 ± 2.3% | | 1.00 | 0.97 | 12.14 |
| wild/ruff/shebang | 282 | 414.82 ± 1.4% | not timed | not timed | 326.04 ± 3.9% | 91.92 ± 10.3% | not timed | not timed | 418.69 ± 0.7% | | 0.99 | 1.27 | 4.51 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16827.10 ± 16.1% | not timed | not timed | 19690.50 ± 0.6% | 6333.98 ± 0.7% | not timed | not timed | 16855.31 ± 2.5% | | 1.00 | 0.85 | 2.66 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15544.77 ± 1.7% | not timed | not timed | 18670.03 ± 4.9% | 5963.54 ± 4.6% | not timed | not timed | 15575.35 ± 2.4% | | 1.00 | 0.83 | 2.61 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 17169.19 ± 2.6% | not timed | not timed | 19340.24 ± 1.6% | 6089.73 ± 29.9% | not timed | not timed | 16923.65 ± 3.3% | | 1.01 | 0.89 | 2.82 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13962.41 ± 1.6% | not timed | not timed | 19452.21 ± 10.4% | 6202.00 ± 33.9% | not timed | not timed | 13909.00 ± 0.2% | | 1.00 | 0.72 | 2.25 |
| wild/url/search | 234965 | 102.21 ± 14.4% | not timed | not timed | 49.63 ± 7.5% | 1.90 ± 1.2% | not timed | not timed | 102.11 ± 20.8% | | 1.00 | 2.06 | 53.68 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 57.9% | not timed | not timed | 0.01 ± 6.6% | 0.01 ± 13.2% | not timed | not timed | 0.02 ± 57.4% | | 0.99 | 2.49 | 3.76 |
| dictionary/compile/english-15 | 1 | 0.28 ± 21.3% | not timed | not timed | 0.08 ± 1.3% | 0.10 ± 7.6% | not timed | not timed | 0.28 ± 8.4% | | 1.00 | 3.67 | 2.98 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 7.1% | not timed | not timed | 0.02 ± 15.8% | 31.08 ± 21.2% | not timed | not timed | 0.22 ± 10.5% | | 0.99 | 10.63 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 34.77 ± 13.3% | not timed | not timed | 13.78 ± 0.3% | 50.09 ± 37.7% | not timed | not timed | 35.41 ± 2.0% | | 0.98 | 2.52 | 0.69 |
| reported/i787-keywords/compile | 1 | 29.91 ± 17.2% | not timed | not timed | 1.95 ± 0.3% | 15.58 ± 21.7% | not timed | not timed | 30.52 ± 10.1% | | 0.98 | 15.36 | 1.92 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 283.47 ± 4.3% | not timed | not timed | 120.58 ± 0.5% | 492.09 ± 14.2% | not timed | not timed | 287.04 ± 20.3% | | 0.99 | 2.35 | 0.58 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 40.23 ± 11.7% | not timed | not timed | 4.01 ± 7.1% | 37.67 ± 23.5% | not timed | not timed | 37.26 ± 13.2% | | 1.08 | 10.03 | 1.07 |
| unicode/compile/one-letter | 53 | 5.39 ± 4.5% | not timed | not timed | 4.49 ± 4.0% | 56.21 ± 13.4% | not timed | not timed | 5.42 ± 11.3% | | 0.99 | 1.20 | 0.0958 |
| unicode/compile/fifty-letters | 1 | 0.90 ± 11.8% | not timed | not timed | 0.10 ± 1.1% | 53.09 ± 12.8% | not timed | not timed | 0.92 ± 1.8% | | 0.98 | 8.72 | 0.0170 |
| unicode/compile/fifty-letters-ascii | 1 | 159.61 ± 15.6% | not timed | not timed | 56.11 ± 0.5% | 190.21 ± 18.7% | not timed | not timed | 161.71 ± 11.7% | | 0.99 | 2.84 | 0.84 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 345.98 ± 11.5% | not timed | not timed | 37.50 ± 4.6% | 592.22 ± 21.6% | not timed | not timed | 342.77 ± 0.9% | | 1.01 | 9.23 | 0.58 |
| unicode/compile/match-every-line-ascii | 4 | 513.57 ± 4.4% | not timed | not timed | 131.90 ± 0.7% | 583.61 ± 28.5% | not timed | not timed | 514.12 ± 3.4% | | 1.00 | 3.89 | 0.88 |
| unicode/compile/negated-class-matches-codepoint | 1 | 279.05 ± 2.2% | not timed | not timed | 41.76 ± 0.6% | 1080.12 ± 11.9% | not timed | not timed | 279.75 ± 2.6% | | 1.00 | 6.68 | 0.26 |
| wild/bibleref/compile | 3 | 4.42 ± 15.5% | not timed | not timed | 1.95 ± 0.5% | 28.46 ± 20.5% | not timed | not timed | 4.87 ± 7.0% | | 0.91 | 2.26 | 0.16 |
| wild/url/compile | 1 | 0.54 ± 14.5% | not timed | not timed | 0.17 ± 17.7% | 0.35 ± 27.2% | not timed | not timed | 0.55 ± 0.5% | | 0.99 | 3.26 | 1.54 |

