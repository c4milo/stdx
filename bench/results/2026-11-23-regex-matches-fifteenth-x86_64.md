# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127376721 |
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
| literal: a word | 217 | 32711.60 ± 7.2% | 842.63 ± 1.2% | 19.47 ± 7.2% | 30893.49 ± 2.4% | 8902.26 ± 6.2% | 10.73 ± 1.3% | 76.25 ± 0.9% | 32533.34 ± 4.1% | 38.82 | 1.01 | 1.06 | 3.67 |
| literal: a word that is not there | 0 | 50567.25 ± 2.1% | 851.02 ± 0.1% | 19.83 ± 0.8% | 39441.21 ± 8.9% | 30249.58 ± 1.2% | 10.69 ± 2.8% | 72.04 ± 26.0% | 49606.63 ± 1.3% | 59.42 | 1.02 | 1.28 | 1.67 |
| literal: one of four words | 661 | 11031.03 ± 5.9% | 824.23 ± 0.2% | 10.94 ± 5.9% | 9106.02 ± 1.0% | 19.03 ± 4.7% | 3.99 ± 0.1% | 6.70 ± 0.8% | 11025.48 ± 10.5% | 13.38 | 1.00 | 1.21 | 579.79 |
| literal: a word in any case | 217 | 26213.22 ± 1.4% | 841.88 ± 2.8% | 14.77 ± 0.9% | 9260.34 ± 0.5% | 37.22 ± 5.7% | refused | differs | 25948.05 ± 0.5% | 31.14 | 1.01 | 2.83 | 704.36 |
| literal: an href attribute | 33 | 27098.55 ± 0.8% | 848.12 ± 0.2% | 18.22 ± 1.5% | 27175.82 ± 1.3% | 2068.98 ± 0.2% | 8.21 ± 0.2% | 62.14 ± 1.5% | 26753.68 ± 2.1% | 31.95 | 1.01 | 1.00 | 13.10 |
| literal: a word, second text | 123 | 34096.78 ± 2.3% | 845.80 ± 0.2% | 19.39 ± 5.7% | 31667.42 ± 0.9% | 7134.34 ± 9.6% | 11.78 ± 0.3% | 65.26 ± 2.4% | 33725.60 ± 1.8% | 40.31 | 1.01 | 1.08 | 4.78 |
| class: two capitalized words | 1331 | 786.74 ± 0.2% | 787.69 ± 0.3% | 18.63 ± 1.3% | 506.31 ± 0.1% | 34.29 ± 8.1% | 9.26 ± 0.2% | 55.71 ± 0.5% | 785.13 ± 1.3% | 1.00 | 1.00 | 1.55 | 22.94 |
| class: a word that ends in ing | 3399 | 716.41 ± 0.2% | 716.44 ± 0.4% | 12.87 ± 1.0% | 473.21 ± 0.4% | 25.67 ± 2.5% | 5.35 ± 0.3% | 17.20 ± 1.0% | 716.18 ± 0.2% | 1.00 | 1.00 | 1.51 | 27.90 |
| class: a word in capitals | 2332 | 983.65 ± 0.2% | 764.79 ± 0.4% | 19.68 ± 1.5% | 496.02 ± 1.4% | 36.76 ± 14.4% | 10.17 ± 0.1% | 76.55 ± 0.3% | 988.31 ± 3.6% | 1.29 | 1.00 | 1.98 | 26.76 |
| class: a number | 8288 | 1413.39 ± 3.8% | 659.23 ± 1.8% | 19.27 ± 22.7% | 1484.25 ± 3.2% | 36.32 ± 11.9% | 0.33 ± 0.4% | 55.86 ± 0.2% | 1419.30 ± 0.4% | 2.14 | 1.00 | 0.95 | 38.92 |
| class: two capitalized words, second text | 5359 | 585.43 ± 1.4% | 593.74 ± 1.2% | 17.12 ± 3.4% | 418.22 ± 1.4% | 28.73 ± 8.5% | 10.48 ± 1.1% | 51.58 ± 1.0% | 592.82 ± 1.4% | 0.99 | 0.99 | 1.40 | 20.38 |
| other: a word between two words | 6104 | 642.75 ± 0.3% | 619.37 ± 0.3% | 16.82 ± 1.8% | 698.31 ± 0.3% | 101.45 ± 12.5% | 7.06 ± 0.2% | 56.93 ± 1.8% | 642.44 ± 0.2% | 1.04 | 1.00 | 0.92 | 6.34 |
| other: a number before a unit, second text | 1481 | 6632.59 ± 1.2% | 793.90 ± 0.4% | 18.43 ± 12.2% | 6428.03 ± 0.7% | 35.23 ± 10.1% | 10.87 ± 0.3% | 55.14 ± 0.3% | 6499.00 ± 0.7% | 8.35 | 1.02 | 1.03 | 188.28 |
| other: a heading's start tag | 110 | 18978.76 ± 2.4% | 841.78 ± 0.9% | 19.26 ± 4.0% | 2008.50 ± 0.5% | 1478.72 ± 23.6% | 10.00 ± 0.6% | 72.70 ± 6.9% | 18507.38 ± 1.5% | 22.55 | 1.03 | 9.45 | 12.83 |
| other: a whole word | 217 | 22993.65 ± 4.2% | 842.26 ± 0.2% | 19.33 ± 5.0% | 19844.50 ± 9.9% | 40.71 ± 4.9% | 8.77 ± 0.1% | 46.87 ± 1.4% | 22622.90 ± 1.8% | 27.30 | 1.02 | 1.16 | 564.86 |
| other: a line's first word, second text | 3716 | 1716.40 ± 0.4% | 706.22 ± 0.1% | 22.04 ± 0.8% | 1702.49 ± 2.2% | 51.92 ± 17.7% | refused | refused | 1709.55 ± 1.5% | 2.43 | 1.00 | 1.01 | 33.06 |
| other: fourteen octets before an x | 87 | 25596.99 ± 1.6% | 199.59 ± 1.2% | 5.12 ± 4.0% | 2890.31 ± 0.8% | 9.01 ± 0.4% | differs | 15.45 ± 1.5% | 25537.94 ± 0.9% | 128.25 | 1.00 | 8.86 | 2840.35 |
| other: a Greek word | 21815 | 394.17 ± 1.0% | 290.50 ± 0.6% | 23.32 ± 1.0% | 264.92 ± 9.3% | 40.40 ± 14.6% | differs | refused | 395.44 ± 0.7% | 1.36 | 1.00 | 1.49 | 9.76 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.82 ± 0.8% | 24.76 ± 0.7% | 0.71 ± 0.5% | 16.78 ± 1.2% | 2.34 ± 11.5% | differs | 3.64 ± 16.5% | 24.79 ± 0.6% | 1.00 | 1.00 | 1.48 | 10.62 |
| a UUID | 32895 | 20.52 ± 5.5% | 20.59 ± 0.9% | 0.55 ± 0.2% | 12.63 ± 0.5% | 2.52 ± 1.6% | 0.43 ± 0.2% | 3.09 ± 0.3% | 20.44 ± 0.5% | 1.00 | 1.00 | 1.62 | 8.15 |
| an IPv4 address | 33176 | 34.41 ± 0.7% | 31.20 ± 0.3% | 1.75 ± 1.1% | 24.18 ± 0.3% | 5.74 ± 1.6% | differs | 3.38 ± 1.9% | 34.25 ± 0.5% | 1.10 | 1.00 | 1.42 | 5.99 |
| a date and time | 32954 | 30.24 ± 1.1% | 30.26 ± 1.0% | 1.27 ± 0.6% | 18.09 ± 0.8% | 6.69 ± 1.2% | 0.75 ± 0.6% | 6.18 ± 0.4% | 30.41 ± 10.6% | 1.00 | 0.99 | 1.67 | 4.52 |
| a field path | 32606 | 27.27 ± 10.7% | 27.35 ± 0.8% | 0.85 ± 0.3% | 19.57 ± 0.2% | 2.91 ± 1.5% | differs | 2.46 ± 7.5% | 27.38 ± 0.7% | 1.00 | 1.00 | 1.39 | 9.38 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.27 ± 3.0% | 8.29 ± 1.8% | 8.26 ± 0.5% | 10.62 ± 6.7% | 4.67 ± 4.9% | 0.61 ± 0.4% | none | 8.37 ± 2.1% | 1.00 | 0.99 | 0.78 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 186.47 ± 1.2% | 187.13 ± 0.4% | 216.83 ± 0.3% | 79.77 ± 1.6% | 182.86 ± 2.4% | 539.03 ± 6.0% | 3991.37 ± 0.4% | 186.92 ± 0.5% | 1.00 | 1.00 | 2.34 | 1.02 |
| a UUID | 62 | 121.84 ± 0.4% | 122.17 ± 1.2% | 134.96 ± 0.3% | 46.63 ± 1.4% | 90.23 ± 1.6% | 201.47 ± 1.5% | 4103.82 ± 0.7% | 121.91 ± 1.1% | 1.00 | 1.00 | 2.61 | 1.35 |
| an IPv4 address | 29 | 394.59 ± 1.1% | 394.48 ± 1.2% | 549.97 ± 2.4% | 69.82 ± 3.4% | 114.31 ± 1.7% | 322.03 ± 4.3% | 7183.92 ± 0.3% | 396.10 ± 8.1% | 1.00 | 1.00 | 5.65 | 3.45 |
| a date and time | 56 | 283.99 ± 0.6% | 284.92 ± 1.0% | 355.69 ± 0.2% | 67.33 ± 1.2% | 124.38 ± 1.5% | 369.20 ± 5.1% | 4238.08 ± 2.2% | 283.93 ± 1.4% | 1.00 | 1.00 | 4.22 | 2.28 |
| a field path | 39 | 182.93 ± 0.4% | 183.35 ± 0.7% | 211.14 ± 1.4% | 72.65 ± 4.8% | 169.56 ± 6.9% | 592.83 ± 10.2% | 4797.93 ± 2.1% | 182.59 ± 2.1% | 1.00 | 1.00 | 2.52 | 1.08 |
| literal: a word | 7 | 577.66 ± 2.7% | 612.32 ± 2.4% | 1049.54 ± 2.3% | 491.93 ± 3.0% | 579.81 ± 6.5% | 1252.14 ± 2.8% | 25050.79 ± 2.9% | 576.92 ± 17.2% | 0.94 | 1.00 | 1.17 | 1.00 |
| literal: a word that is not there | 8 | 553.86 ± 1.3% | 590.76 ± 0.3% | 991.74 ± 2.1% | 458.33 ± 0.8% | 562.42 ± 1.8% | 1177.02 ± 1.2% | 23326.50 ± 0.5% | 554.24 ± 1.4% | 0.94 | 1.00 | 1.21 | 0.98 |
| literal: one of four words | 26 | 215.36 ± 0.5% | 347.79 ± 0.3% | 457.74 ± 1.4% | 41.73 ± 0.5% | 217.08 ± 4.0% | 439.80 ± 2.2% | 11552.74 ± 0.2% | 215.45 ± 0.4% | 0.62 | 1.00 | 5.16 | 0.99 |
| literal: a word in any case | 11 | 429.53 ± 1.6% | 452.50 ± 1.8% | 666.10 ± 0.4% | 14.22 ± 3.5% | 620.48 ± 1.1% | refused | 19073.96 ± 2.6% | 429.01 ± 0.6% | 0.95 | 1.00 | 30.20 | 0.69 |
| literal: an href attribute | 12 | 314.33 ± 0.8% | 323.68 ± 0.6% | 420.94 ± 0.6% | 37.01 ± 1.3% | 434.59 ± 2.6% | 940.59 ± 12.9% | 18404.14 ± 1.2% | 312.69 ± 0.8% | 0.97 | 1.01 | 8.49 | 0.72 |
| literal: a word, second text | 10 | 510.73 ± 0.5% | 553.55 ± 0.4% | 900.77 ± 0.4% | 411.13 ± 2.2% | 488.86 ± 26.7% | 992.11 ± 1.5% | 20270.34 ± 0.8% | 511.12 ± 0.7% | 0.92 | 1.00 | 1.24 | 1.04 |
| class: two capitalized words | 23 | 420.81 ± 0.2% | 449.37 ± 1.1% | 648.75 ± 0.1% | 93.15 ± 1.9% | 454.64 ± 4.6% | 943.25 ± 1.0% | 6397.38 ± 13.1% | 420.96 ± 0.3% | 0.94 | 1.00 | 4.52 | 0.93 |
| class: a word that ends in ing | 9 | 506.00 ± 0.8% | 564.82 ± 0.6% | 978.37 ± 0.9% | 113.86 ± 1.6% | 633.89 ± 1.6% | 1416.98 ± 18.5% | 15231.70 ± 3.8% | 505.62 ± 0.4% | 0.90 | 1.00 | 4.44 | 0.80 |
| class: a word in capitals | 16 | 446.40 ± 0.4% | 480.73 ± 0.6% | 782.51 ± 6.0% | 119.44 ± 1.4% | 646.67 ± 3.4% | 1285.91 ± 1.2% | 8384.32 ± 0.2% | 446.47 ± 6.0% | 0.93 | 1.00 | 3.74 | 0.69 |
| class: a number | 6 | 564.40 ± 0.6% | 618.15 ± 0.5% | 1173.63 ± 0.7% | 36.22 ± 0.9% | 1173.29 ± 1.5% | 2187.59 ± 2.2% | 20441.89 ± 0.3% | 564.66 ± 0.4% | 0.91 | 1.00 | 15.58 | 0.48 |
| class: two capitalized words, second text | 23 | 420.21 ± 1.1% | 449.98 ± 2.3% | 650.40 ± 0.5% | 95.03 ± 1.3% | 448.87 ± 24.0% | 978.75 ± 1.8% | 6396.90 ± 0.9% | 421.22 ± 0.2% | 0.93 | 1.00 | 4.42 | 0.94 |
| other: a word between two words | 13 | 493.05 ± 0.7% | 506.68 ± 0.2% | 774.97 ± 0.7% | 123.39 ± 1.0% | 433.82 ± 4.0% | 1052.63 ± 0.4% | 14058.70 ± 16.1% | 491.20 ± 1.5% | 0.97 | 1.00 | 4.00 | 1.14 |
| other: a number before a unit, second text | 15 | 355.57 ± 0.4% | 389.20 ± 0.3% | 532.87 ± 0.7% | 33.48 ± 2.8% | 548.23 ± 1.8% | 1131.69 ± 4.2% | 13807.64 ± 0.7% | 355.27 ± 0.3% | 0.91 | 1.00 | 10.62 | 0.65 |
| other: a heading's start tag | 13 | 318.52 ± 1.2% | 322.55 ± 1.3% | 417.64 ± 0.6% | 35.43 ± 2.1% | 524.86 ± 1.4% | 1098.19 ± 0.5% | 16356.22 ± 0.6% | 317.72 ± 0.9% | 0.99 | 1.00 | 8.99 | 0.61 |
| other: a whole word | 11 | 503.48 ± 1.3% | 530.37 ± 1.7% | 841.91 ± 1.0% | 110.74 ± 1.6% | 508.40 ± 1.9% | 1063.11 ± 0.5% | 20784.47 ± 0.7% | 502.97 ± 0.6% | 0.95 | 1.00 | 4.55 | 0.99 |
| other: a line's first word, second text | 17 | 481.64 ± 1.3% | 503.13 ± 2.6% | 816.58 ± 1.1% | 113.68 ± 10.9% | 591.37 ± 3.3% | refused | refused | 479.89 ± 0.9% | 0.96 | 1.00 | 4.24 | 0.81 |
| other: fourteen octets before an x | 16 | 89.88 ± 21.3% | 125.37 ± 0.1% | 144.12 ± 0.7% | 14.02 ± 12.4% | 402.68 ± 7.8% | 453.12 ± 0.6% | 11807.70 ± 26.9% | 88.85 ± 1.8% | 0.72 | 1.01 | 6.41 | 0.22 |
| other: a Greek word | 8 | 379.45 ± 2.4% | 511.02 ± 1.0% | 838.74 ± 1.0% | 47.31 ± 0.3% | 1164.28 ± 1.5% | 2173.70 ± 0.7% | refused | 382.12 ± 0.2% | 0.74 | 0.99 | 8.02 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21116.19 ± 1.9% | not timed | not timed | 27120.83 ± 1.3% | 1926.73 ± 18.5% | not timed | not timed | 20927.62 ± 1.6% | | 1.01 | 0.78 | 10.96 |
| 01-literal/sherlock-casei-en | 522 | 4665.40 ± 0.2% | not timed | not timed | 7050.12 ± 0.6% | 28.32 ± 14.8% | not timed | not timed | 4670.88 ± 0.2% | | 1.00 | 0.66 | 164.75 |
| 01-literal/sherlock-ru | 724 | 23135.94 ± 15.6% | not timed | not timed | 27920.27 ± 1.8% | 1052.83 ± 3.2% | not timed | not timed | 22827.47 ± 1.0% | | 1.01 | 0.83 | 21.98 |
| 01-literal/sherlock-casei-ru | 746 | 7317.13 ± 3.6% | not timed | not timed | 5523.75 ± 0.2% | 30.43 ± 13.9% | not timed | not timed | 7303.27 ± 3.4% | | 1.00 | 1.32 | 240.48 |
| 01-literal/sherlock-zh | 30 | 41890.45 ± 3.3% | not timed | not timed | 36656.30 ± 14.7% | 1264.79 ± 0.2% | not timed | not timed | 41479.00 ± 1.7% | | 1.01 | 1.14 | 33.12 |
| 02-literal-alternate/sherlock-en | 714 | 9529.67 ± 0.8% | not timed | not timed | 8898.01 ± 6.2% | 14.43 ± 5.3% | not timed | not timed | 9538.33 ± 0.7% | | 1.00 | 1.07 | 660.54 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1739.45 ± 0.6% | not timed | not timed | 1814.39 ± 0.3% | 9.46 ± 1.5% | not timed | not timed | 1714.95 ± 0.2% | | 1.01 | 0.96 | 183.78 |
| 02-literal-alternate/sherlock-ru | 899 | 5972.88 ± 2.2% | not timed | not timed | 4246.87 ± 1.5% | 19.03 ± 18.6% | not timed | not timed | 5938.34 ± 2.4% | | 1.01 | 1.41 | 313.80 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1798.04 ± 2.1% | not timed | not timed | 1038.69 ± 1.1% | 8.42 ± 8.5% | not timed | not timed | 1796.34 ± 4.1% | | 1.00 | 1.73 | 213.52 |
| 02-literal-alternate/sherlock-zh | 207 | 13632.46 ± 0.5% | not timed | not timed | 10414.85 ± 0.4% | 26.86 ± 9.0% | not timed | not timed | 13632.97 ± 1.0% | | 1.00 | 1.31 | 507.61 |
| 03-date/ascii | 111817 | 98.11 ± 9.2% | not timed | not timed | 84.32 ± 0.4% | 0.18 ± 3.4% | not timed | not timed | 98.24 ± 3.3% | | 1.00 | 1.16 | 552.03 |
| 04-ruff-noqa/real | 84 | 546.31 ± 0.9% | not timed | not timed | 425.90 ± 1.4% | 14.80 ± 1.8% | not timed | not timed | 545.52 ± 0.5% | | 1.00 | 1.28 | 36.91 |
| 04-ruff-noqa/tweaked | 44 | 483.99 ± 0.2% | not timed | not timed | 422.76 ± 0.3% | 289.24 ± 0.5% | not timed | not timed | 483.16 ± 0.9% | | 1.00 | 1.14 | 1.67 |
| 05-lexer-veryl/single | 124800 | 2.77 ± 4.9% | not timed | not timed | 4.02 ± 1.4% | 0.21 ± 4.4% | not timed | not timed | 2.76 ± 4.2% | | 1.00 | 0.69 | 13.06 |
| 06-cloud-flare-redos/original | 107 | 230.41 ± 0.4% | not timed | not timed | 193.24 ± 0.6% | 20.73 ± 0.4% | not timed | not timed | 229.80 ± 2.2% | | 1.00 | 1.19 | 11.11 |
| 06-cloud-flare-redos/simplified-short | 102 | 220.34 ± 0.2% | not timed | not timed | 192.55 ± 0.2% | 22.00 ± 1.8% | not timed | not timed | 220.49 ± 0.3% | | 1.00 | 1.14 | 10.01 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.97 ± 0.4% | not timed | not timed | 211.12 ± 8.7% | 24.09 ± 4.7% | not timed | not timed | 246.84 ± 0.1% | | 1.00 | 1.17 | 10.25 |
| 07-unicode-character-data/parse-line | 558784 | 196.29 ± 0.1% | not timed | not timed | 161.54 ± 11.2% | 36.99 ± 3.9% | not timed | not timed | 193.52 ± 1.9% | | 1.01 | 1.22 | 5.31 |
| 08-words/all-english | 56691 | 90.44 ± 13.2% | not timed | not timed | 73.74 ± 2.2% | 10.67 ± 4.8% | not timed | not timed | 90.28 ± 0.2% | | 1.00 | 1.23 | 8.48 |
| 08-words/long-english | 839 | 808.24 ± 4.7% | not timed | not timed | 515.09 ± 0.1% | 26.38 ± 0.8% | not timed | not timed | 809.28 ± 0.1% | | 1.00 | 1.57 | 30.64 |
| 09-aws-keys/full | 0 | 424.21 ± 0.5% | not timed | not timed | 447.46 ± 0.5% | 54.88 ± 5.0% | not timed | not timed | 424.50 ± 0.2% | | 1.00 | 0.95 | 7.73 |
| 09-aws-keys/quick | 0 | 827.64 ± 4.2% | not timed | not timed | 804.48 ± 2.2% | 330.88 ± 2.3% | not timed | not timed | 825.74 ± 11.0% | | 1.00 | 1.03 | 2.50 |
| 10-bounded-repeat/letters-en | 1833 | 484.34 ± 1.5% | not timed | not timed | 430.80 ± 1.5% | 16.85 ± 3.4% | not timed | not timed | 487.98 ± 1.9% | | 0.99 | 1.12 | 28.74 |
| 10-bounded-repeat/letters-ru | 3475 | 317.36 ± 0.4% | not timed | not timed | 408.60 ± 0.2% | 17.89 ± 16.7% | not timed | not timed | 317.46 ± 0.5% | | 1.00 | 0.78 | 17.74 |
| 10-bounded-repeat/context | 53 | 65.58 ± 8.3% | not timed | not timed | 56.11 ± 3.0% | 16.79 ± 1.1% | not timed | not timed | 66.05 ± 1.8% | | 0.99 | 1.17 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 844.93 ± 0.5% | not timed | not timed | 533.59 ± 0.4% | 30.90 ± 0.7% | not timed | not timed | 845.76 ± 0.3% | | 1.00 | 1.58 | 27.35 |
| 11-unstructured-to-json/extract | 600 | 35.93 ± 0.4% | not timed | not timed | 62.31 ± 0.7% | 40.26 ± 7.3% | not timed | not timed | 35.96 ± 0.2% | | 1.00 | 0.58 | 0.89 |
| 12-dictionary/single | 1 | 460.45 ± 0.9% | not timed | not timed | 440.93 ± 0.2% | 0.32 ± 0.3% | not timed | not timed | 464.15 ± 0.5% | | 0.99 | 1.04 | 1435.12 |
| 14-quadratic/1x | 100 | 10.19 ± 2.9% | not timed | not timed | 9.12 ± 0.4% | 0.81 ± 2.3% | not timed | not timed | 10.11 ± 24.2% | | 1.01 | 1.12 | 12.63 |
| 14-quadratic/2x | 200 | 6.36 ± 0.2% | not timed | not timed | 4.92 ± 3.0% | 0.43 ± 0.6% | not timed | not timed | 6.34 ± 0.3% | | 1.00 | 1.29 | 14.73 |
| 14-quadratic/10x | 1000 | 1.51 ± 3.8% | not timed | not timed | 1.05 ± 0.4% | 0.09 ± 0.7% | not timed | not timed | 1.51 ± 1.1% | | 1.00 | 1.44 | 16.28 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.35 ± 0.5% | not timed | not timed | 0.37 ± 0.5% | 0.48 ± 5.0% | not timed | not timed | 1.34 ± 1.0% | | 1.01 | 3.66 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 79.92 ± 4.9% | not timed | not timed | 12.86 ± 1.2% | 124.81 ± 3.3% | not timed | not timed | 79.14 ± 2.1% | | 1.01 | 6.21 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.89 ± 1.1% | not timed | not timed | 2.34 ± 1.5% | 5.94 ± 1.5% | not timed | not timed | 12.81 ± 0.5% | | 1.01 | 5.50 | 2.17 |
| 07-unicode-character-data/compile | 1 | 50.47 ± 6.3% | not timed | not timed | 24.32 ± 0.7% | 32.94 ± 22.1% | not timed | not timed | 50.41 ± 6.5% | | 1.00 | 2.08 | 1.53 |
| 09-aws-keys/compile-full | 1 | 34.78 ± 0.5% | not timed | not timed | 7.30 ± 0.5% | 20.31 ± 4.1% | not timed | not timed | 34.34 ± 13.9% | | 1.01 | 4.76 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 160.81 ± 0.5% | not timed | not timed | 44.74 ± 1.1% | 119.05 ± 3.6% | not timed | not timed | 158.91 ± 2.0% | | 1.01 | 3.59 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 10.61 ± 0.5% | not timed | not timed | 11.46 ± 0.8% | 15.15 ± 2.6% | not timed | not timed | 10.57 ± 1.5% | | 1.00 | 0.93 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 74.20 ± 1.6% | not timed | not timed | 8.67 ± 0.3% | 22.52 ± 3.4% | not timed | not timed | 73.49 ± 0.5% | | 1.01 | 8.56 | 3.29 |
| 11-unstructured-to-json/compile | 1 | 76.98 ± 0.6% | not timed | not timed | 36.10 ± 3.2% | 60.45 ± 2.6% | not timed | not timed | 76.57 ± 1.5% | | 1.01 | 2.13 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.5% | not timed | not timed | 0.07 ± 14.0% | 0.09 ± 10.7% | not timed | not timed | 0.29 ± 4.0% | | 1.01 | 4.29 | 3.33 |

