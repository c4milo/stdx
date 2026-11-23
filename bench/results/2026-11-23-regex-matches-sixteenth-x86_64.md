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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127380362 |
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
| literal: a word | 217 | 33221.45 ± 3.1% | 842.54 ± 0.2% | 19.54 ± 3.5% | 30813.33 ± 1.0% | 8806.96 ± 8.0% | 10.73 ± 0.2% | 77.18 ± 2.4% | 32341.68 ± 3.2% | 39.43 | 1.03 | 1.08 | 3.77 |
| literal: a word that is not there | 0 | 48714.71 ± 3.9% | 850.62 ± 0.1% | 19.79 ± 2.6% | 39421.91 ± 1.3% | 30197.21 ± 0.7% | 10.68 ± 0.0% | 73.41 ± 2.6% | 48382.21 ± 3.5% | 57.27 | 1.01 | 1.24 | 1.61 |
| literal: one of four words | 661 | 10911.57 ± 7.2% | 823.28 ± 1.4% | 10.96 ± 5.5% | 8730.21 ± 3.4% | 18.72 ± 3.8% | 3.98 ± 1.5% | 6.69 ± 2.8% | 10941.58 ± 2.5% | 13.25 | 1.00 | 1.25 | 582.96 |
| literal: a word in any case | 217 | 26044.82 ± 2.4% | 841.91 ± 0.2% | 14.74 ± 1.0% | 9049.69 ± 0.7% | 37.09 ± 0.9% | refused | differs | 25598.81 ± 0.9% | 30.94 | 1.02 | 2.88 | 702.15 |
| literal: an href attribute | 33 | 27101.40 ± 1.0% | 847.12 ± 0.2% | 18.23 ± 1.5% | 26758.93 ± 2.4% | 2044.32 ± 0.5% | 8.21 ± 0.3% | 61.78 ± 0.7% | 26585.06 ± 6.0% | 31.99 | 1.02 | 1.01 | 13.26 |
| literal: a word, second text | 123 | 33380.02 ± 3.2% | 845.68 ± 0.1% | 19.50 ± 3.2% | 31397.71 ± 0.2% | 7190.17 ± 5.3% | 11.79 ± 0.3% | 66.05 ± 1.6% | 33260.44 ± 2.3% | 39.47 | 1.00 | 1.06 | 4.64 |
| class: two capitalized words | 1331 | 786.82 ± 0.5% | 786.95 ± 0.4% | 18.62 ± 2.6% | 504.23 ± 0.2% | 33.89 ± 0.5% | 9.23 ± 0.1% | 55.70 ± 5.3% | 785.13 ± 0.4% | 1.00 | 1.00 | 1.56 | 23.21 |
| class: a word that ends in ing | 3399 | 715.57 ± 0.6% | 715.27 ± 0.2% | 12.74 ± 1.9% | 469.31 ± 0.2% | 25.03 ± 38.2% | 5.33 ± 0.6% | 17.16 ± 7.5% | 710.47 ± 1.4% | 1.00 | 1.01 | 1.52 | 28.59 |
| class: a word in capitals | 2332 | 985.31 ± 0.3% | 769.23 ± 1.0% | 19.59 ± 2.8% | 495.32 ± 0.3% | 36.29 ± 1.9% | 10.27 ± 0.7% | 76.36 ± 5.8% | 986.07 ± 0.3% | 1.28 | 1.00 | 1.99 | 27.15 |
| class: a number | 8288 | 1416.77 ± 0.3% | 658.66 ± 1.8% | 19.33 ± 4.9% | 1393.24 ± 0.7% | 36.05 ± 14.1% | 0.33 ± 0.2% | 55.87 ± 0.2% | 1424.12 ± 1.1% | 2.15 | 0.99 | 1.02 | 39.30 |
| class: two capitalized words, second text | 5359 | 594.04 ± 0.7% | 593.53 ± 0.4% | 16.88 ± 6.4% | 413.80 ± 0.3% | 29.62 ± 3.6% | 10.49 ± 0.2% | 51.77 ± 0.4% | 592.48 ± 1.0% | 1.00 | 1.00 | 1.44 | 20.06 |
| other: a word between two words | 6104 | 641.58 ± 0.2% | 618.40 ± 0.2% | 16.80 ± 1.0% | 667.73 ± 0.6% | 93.33 ± 15.3% | 7.23 ± 0.4% | 56.41 ± 1.2% | 638.44 ± 0.7% | 1.04 | 1.00 | 0.96 | 6.87 |
| other: a number before a unit, second text | 1481 | 6538.58 ± 2.7% | 792.45 ± 1.4% | 18.46 ± 3.8% | 6051.42 ± 2.5% | 34.79 ± 2.5% | 10.87 ± 1.2% | 54.82 ± 2.3% | 6556.40 ± 2.7% | 8.25 | 1.00 | 1.08 | 187.92 |
| other: a heading's start tag | 110 | 18930.20 ± 1.9% | 840.95 ± 0.3% | 19.08 ± 1.4% | 2000.78 ± 0.6% | 1469.83 ± 4.8% | 9.99 ± 0.6% | 72.73 ± 0.8% | 18866.88 ± 2.0% | 22.51 | 1.00 | 9.46 | 12.88 |
| other: a whole word | 217 | 22824.63 ± 4.3% | 841.53 ± 0.8% | 19.61 ± 9.2% | 21555.02 ± 1.2% | 39.41 ± 0.2% | 9.45 ± 0.1% | 46.86 ± 9.4% | 22584.00 ± 1.4% | 27.12 | 1.01 | 1.06 | 579.14 |
| other: a line's first word, second text | 3716 | 1716.45 ± 0.4% | 704.10 ± 0.2% | 21.91 ± 11.4% | 1642.84 ± 1.0% | 51.90 ± 6.4% | refused | refused | 1711.27 ± 1.2% | 2.44 | 1.00 | 1.04 | 33.07 |
| other: fourteen octets before an x | 87 | 25729.62 ± 2.4% | 193.49 ± 1.5% | 5.09 ± 0.5% | 2793.78 ± 1.9% | 8.72 ± 0.5% | differs | 15.41 ± 2.7% | 25373.72 ± 2.1% | 132.98 | 1.01 | 9.21 | 2952.05 |
| other: a Greek word | 21815 | 395.90 ± 0.4% | 287.53 ± 9.2% | 23.13 ± 1.2% | 256.41 ± 0.6% | 38.34 ± 9.9% | differs | refused | 396.40 ± 0.6% | 1.38 | 1.00 | 1.54 | 10.33 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.46 ± 1.4% | 24.29 ± 6.1% | 0.71 ± 1.2% | 16.75 ± 0.2% | 2.16 ± 0.1% | differs | 3.64 ± 0.4% | 24.71 ± 1.4% | 1.01 | 0.99 | 1.46 | 11.32 |
| a UUID | 32895 | 20.54 ± 0.6% | 20.53 ± 0.2% | 0.55 ± 1.1% | 12.76 ± 0.1% | 2.52 ± 2.1% | 0.44 ± 0.1% | 3.01 ± 1.3% | 20.45 ± 4.3% | 1.00 | 1.00 | 1.61 | 8.16 |
| an IPv4 address | 33176 | 34.41 ± 2.0% | 33.80 ± 2.3% | 1.76 ± 0.5% | 23.98 ± 0.1% | 5.76 ± 1.0% | differs | 3.39 ± 0.7% | 34.41 ± 0.7% | 1.02 | 1.00 | 1.43 | 5.97 |
| a date and time | 32954 | 30.42 ± 0.2% | 30.33 ± 0.3% | 1.27 ± 0.9% | 17.90 ± 1.0% | 6.50 ± 2.5% | 0.76 ± 0.1% | 6.20 ± 0.3% | 30.34 ± 0.3% | 1.00 | 1.00 | 1.70 | 4.68 |
| a field path | 32606 | 27.31 ± 0.9% | 27.25 ± 0.1% | 0.85 ± 10.4% | 19.38 ± 0.1% | 2.95 ± 0.9% | differs | 2.47 ± 0.8% | 27.24 ± 0.5% | 1.00 | 1.00 | 1.41 | 9.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.26 ± 0.4% | 8.31 ± 0.3% | 8.15 ± 1.4% | 10.22 ± 0.3% | 4.66 ± 7.4% | 0.62 ± 0.4% | none | 8.33 ± 1.5% | 0.99 | 0.99 | 0.81 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 184.90 ± 0.7% | 185.20 ± 0.5% | 214.41 ± 2.0% | 79.16 ± 16.6% | 183.28 ± 1.2% | 533.60 ± 1.1% | 3988.60 ± 13.3% | 184.83 ± 0.3% | 1.00 | 1.00 | 2.34 | 1.01 |
| a UUID | 62 | 120.54 ± 0.3% | 120.75 ± 1.0% | 133.21 ± 0.1% | 46.74 ± 9.7% | 90.72 ± 5.1% | 189.93 ± 2.7% | 3973.39 ± 0.2% | 120.43 ± 0.2% | 1.00 | 1.00 | 2.58 | 1.33 |
| an IPv4 address | 29 | 393.00 ± 1.3% | 393.44 ± 1.3% | 551.06 ± 4.6% | 69.62 ± 0.7% | 113.59 ± 2.8% | 330.72 ± 2.0% | 7199.71 ± 0.3% | 395.84 ± 1.8% | 1.00 | 0.99 | 5.65 | 3.46 |
| a date and time | 56 | 285.19 ± 0.3% | 286.04 ± 0.3% | 357.87 ± 1.0% | 68.87 ± 2.2% | 123.64 ± 0.9% | 369.01 ± 1.2% | 4173.12 ± 0.6% | 285.04 ± 0.2% | 1.00 | 1.00 | 4.14 | 2.31 |
| a field path | 39 | 180.11 ± 1.0% | 180.95 ± 0.3% | 208.44 ± 1.2% | 74.73 ± 3.3% | 170.10 ± 12.1% | 563.86 ± 7.1% | 4843.37 ± 1.2% | 180.13 ± 0.4% | 1.00 | 1.00 | 2.41 | 1.06 |
| literal: a word | 7 | 587.80 ± 0.3% | 625.04 ± 0.8% | 1096.49 ± 1.0% | 494.23 ± 2.1% | 570.40 ± 5.0% | 1230.08 ± 0.7% | 25033.70 ± 0.4% | 590.46 ± 0.7% | 0.94 | 1.00 | 1.19 | 1.03 |
| literal: a word that is not there | 8 | 568.46 ± 0.5% | 606.50 ± 0.8% | 1043.36 ± 0.4% | 456.87 ± 7.3% | 550.87 ± 4.6% | 1136.83 ± 0.6% | 23883.43 ± 0.9% | 566.65 ± 0.8% | 0.94 | 1.00 | 1.24 | 1.03 |
| literal: one of four words | 26 | 223.06 ± 2.4% | 361.85 ± 2.0% | 479.82 ± 9.7% | 41.65 ± 3.6% | 216.96 ± 6.3% | 429.65 ± 4.0% | 11330.09 ± 2.1% | 222.41 ± 2.3% | 0.62 | 1.00 | 5.36 | 1.03 |
| literal: a word in any case | 11 | 453.01 ± 0.7% | 477.96 ± 0.8% | 723.94 ± 0.6% | 14.45 ± 0.9% | 600.52 ± 2.6% | refused | 19353.72 ± 1.3% | 452.90 ± 0.4% | 0.95 | 1.00 | 31.34 | 0.75 |
| literal: an href attribute | 12 | 318.99 ± 1.7% | 329.98 ± 3.4% | 431.93 ± 1.2% | 35.68 ± 1.4% | 419.88 ± 3.0% | 923.63 ± 2.6% | 18628.38 ± 1.1% | 319.73 ± 0.7% | 0.97 | 1.00 | 8.94 | 0.76 |
| literal: a word, second text | 10 | 524.51 ± 1.5% | 571.24 ± 1.1% | 940.16 ± 1.7% | 421.56 ± 0.5% | 484.01 ± 15.2% | 963.04 ± 0.7% | 21620.18 ± 0.4% | 526.11 ± 0.8% | 0.92 | 1.00 | 1.24 | 1.08 |
| class: two capitalized words | 23 | 419.48 ± 2.0% | 448.19 ± 2.8% | 634.05 ± 3.1% | 95.69 ± 1.2% | 436.80 ± 2.5% | 891.37 ± 0.8% | 6380.06 ± 1.7% | 419.13 ± 0.7% | 0.94 | 1.00 | 4.38 | 0.96 |
| class: a word that ends in ing | 9 | 512.59 ± 0.7% | 574.84 ± 0.5% | 1006.34 ± 0.9% | 114.38 ± 9.8% | 610.60 ± 2.3% | 1424.54 ± 0.9% | 15254.97 ± 0.3% | 512.25 ± 1.2% | 0.89 | 1.00 | 4.48 | 0.84 |
| class: a word in capitals | 16 | 443.30 ± 0.9% | 479.37 ± 0.6% | 784.09 ± 8.2% | 121.04 ± 1.5% | 617.18 ± 27.2% | 1249.62 ± 1.3% | 8374.96 ± 3.1% | 444.34 ± 0.5% | 0.92 | 1.00 | 3.66 | 0.72 |
| class: a number | 6 | 558.43 ± 0.7% | 614.29 ± 13.5% | 1168.17 ± 0.2% | 35.65 ± 1.0% | 1126.08 ± 6.7% | 2350.09 ± 2.0% | 20456.65 ± 0.3% | 559.17 ± 0.4% | 0.91 | 1.00 | 15.66 | 0.50 |
| class: two capitalized words, second text | 23 | 420.12 ± 0.2% | 448.00 ± 2.2% | 650.40 ± 3.2% | 95.31 ± 0.3% | 438.00 ± 5.2% | 890.90 ± 0.7% | 6391.84 ± 0.6% | 419.79 ± 0.6% | 0.94 | 1.00 | 4.41 | 0.96 |
| other: a word between two words | 13 | 504.17 ± 1.0% | 518.40 ± 3.1% | 806.09 ± 9.1% | 123.92 ± 1.1% | 423.98 ± 2.0% | 967.36 ± 1.2% | 13882.86 ± 1.4% | 503.83 ± 0.4% | 0.97 | 1.00 | 4.07 | 1.19 |
| other: a number before a unit, second text | 15 | 355.50 ± 1.5% | 389.46 ± 0.7% | 536.87 ± 0.3% | 33.15 ± 1.3% | 534.28 ± 2.2% | 1126.47 ± 0.6% | 13810.37 ± 1.5% | 356.20 ± 0.3% | 0.91 | 1.00 | 10.72 | 0.67 |
| other: a heading's start tag | 13 | 331.93 ± 0.6% | 336.66 ± 1.3% | 443.17 ± 0.5% | 35.11 ± 3.3% | 513.63 ± 3.8% | 1062.65 ± 0.6% | 16347.85 ± 0.2% | 331.84 ± 0.5% | 0.99 | 1.00 | 9.45 | 0.65 |
| other: a whole word | 11 | 509.57 ± 0.9% | 537.42 ± 0.8% | 864.19 ± 0.5% | 110.86 ± 1.7% | 495.72 ± 10.7% | 992.40 ± 0.7% | 20873.65 ± 0.4% | 510.09 ± 0.4% | 0.95 | 1.00 | 4.60 | 1.03 |
| other: a line's first word, second text | 17 | 488.98 ± 1.7% | 509.01 ± 0.8% | 832.31 ± 2.3% | 114.47 ± 1.5% | 564.38 ± 4.5% | refused | refused | 487.31 ± 1.1% | 0.96 | 1.00 | 4.27 | 0.87 |
| other: fourteen octets before an x | 16 | 86.08 ± 1.3% | 123.68 ± 0.6% | 142.40 ± 0.3% | 14.14 ± 2.7% | 389.98 ± 2.8% | 437.46 ± 8.9% | 11697.81 ± 10.3% | 86.96 ± 1.8% | 0.70 | 0.99 | 6.09 | 0.22 |
| other: a Greek word | 8 | 376.74 ± 0.5% | 506.54 ± 0.4% | 828.65 ± 0.8% | 45.53 ± 4.1% | 1110.73 ± 9.2% | 2186.71 ± 1.2% | refused | 377.14 ± 0.6% | 0.74 | 1.00 | 8.27 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21185.45 ± 3.6% | not timed | not timed | 26793.43 ± 0.9% | 1898.40 ± 22.9% | not timed | not timed | 21044.87 ± 1.0% | | 1.01 | 0.79 | 11.16 |
| 01-literal/sherlock-casei-en | 522 | 4635.20 ± 0.2% | not timed | not timed | 7027.64 ± 0.4% | 28.46 ± 1.1% | not timed | not timed | 4626.86 ± 0.8% | | 1.00 | 0.66 | 162.85 |
| 01-literal/sherlock-ru | 724 | 22900.98 ± 3.0% | not timed | not timed | 27423.42 ± 18.0% | 1040.61 ± 8.4% | not timed | not timed | 22817.96 ± 2.3% | | 1.00 | 0.84 | 22.01 |
| 01-literal/sherlock-casei-ru | 746 | 7242.67 ± 0.4% | not timed | not timed | 5498.78 ± 0.3% | 30.39 ± 1.7% | not timed | not timed | 7235.46 ± 0.9% | | 1.00 | 1.32 | 238.29 |
| 01-literal/sherlock-zh | 30 | 40575.07 ± 1.0% | not timed | not timed | 35963.65 ± 3.6% | 1260.16 ± 9.1% | not timed | not timed | 40099.18 ± 2.0% | | 1.01 | 1.13 | 32.20 |
| 02-literal-alternate/sherlock-en | 714 | 9533.95 ± 0.6% | not timed | not timed | 8895.65 ± 9.5% | 14.79 ± 24.2% | not timed | not timed | 9509.20 ± 17.7% | | 1.00 | 1.07 | 644.77 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1731.96 ± 0.4% | not timed | not timed | 1818.11 ± 0.2% | 9.46 ± 12.1% | not timed | not timed | 1709.50 ± 0.2% | | 1.01 | 0.95 | 183.08 |
| 02-literal-alternate/sherlock-ru | 899 | 5928.36 ± 0.7% | not timed | not timed | 4265.57 ± 0.1% | 18.93 ± 13.5% | not timed | not timed | 5920.61 ± 0.6% | | 1.00 | 1.39 | 313.23 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1794.80 ± 0.1% | not timed | not timed | 1039.21 ± 4.8% | 8.46 ± 6.2% | not timed | not timed | 1791.27 ± 0.5% | | 1.00 | 1.73 | 212.09 |
| 02-literal-alternate/sherlock-zh | 207 | 13743.78 ± 1.2% | not timed | not timed | 10429.67 ± 5.7% | 26.89 ± 1.4% | not timed | not timed | 13682.80 ± 13.5% | | 1.00 | 1.32 | 511.10 |
| 03-date/ascii | 111817 | 99.64 ± 8.7% | not timed | not timed | 85.19 ± 0.2% | 0.18 ± 1.9% | not timed | not timed | 99.31 ± 1.1% | | 1.00 | 1.17 | 568.32 |
| 04-ruff-noqa/real | 84 | 544.23 ± 0.4% | not timed | not timed | 426.63 ± 0.4% | 15.95 ± 1.5% | not timed | not timed | 543.09 ± 0.6% | | 1.00 | 1.28 | 34.13 |
| 04-ruff-noqa/tweaked | 44 | 483.58 ± 0.2% | not timed | not timed | 420.14 ± 0.4% | 293.14 ± 10.3% | not timed | not timed | 481.67 ± 1.2% | | 1.00 | 1.15 | 1.65 |
| 05-lexer-veryl/single | 124800 | 2.76 ± 3.9% | not timed | not timed | 4.12 ± 0.9% | 0.21 ± 4.9% | not timed | not timed | 2.76 ± 4.4% | | 1.00 | 0.67 | 13.06 |
| 06-cloud-flare-redos/original | 107 | 229.78 ± 0.2% | not timed | not timed | 192.00 ± 6.3% | 20.61 ± 0.5% | not timed | not timed | 228.93 ± 0.2% | | 1.00 | 1.20 | 11.15 |
| 06-cloud-flare-redos/simplified-short | 102 | 220.77 ± 1.2% | not timed | not timed | 192.16 ± 1.8% | 21.96 ± 0.9% | not timed | not timed | 220.14 ± 0.8% | | 1.00 | 1.15 | 10.05 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.80 ± 0.4% | not timed | not timed | 211.22 ± 6.7% | 23.97 ± 1.9% | not timed | not timed | 246.78 ± 0.1% | | 1.00 | 1.17 | 10.30 |
| 07-unicode-character-data/parse-line | 558784 | 196.39 ± 10.1% | not timed | not timed | 159.83 ± 0.5% | 36.47 ± 4.5% | not timed | not timed | 192.54 ± 0.4% | | 1.02 | 1.23 | 5.38 |
| 08-words/all-english | 56691 | 90.81 ± 2.8% | not timed | not timed | 73.88 ± 0.4% | 11.21 ± 2.9% | not timed | not timed | 90.43 ± 0.5% | | 1.00 | 1.23 | 8.10 |
| 08-words/long-english | 839 | 808.96 ± 0.1% | not timed | not timed | 515.58 ± 0.4% | 26.33 ± 1.4% | not timed | not timed | 807.00 ± 0.1% | | 1.00 | 1.57 | 30.73 |
| 09-aws-keys/full | 0 | 423.71 ± 0.3% | not timed | not timed | 444.89 ± 0.3% | 54.86 ± 4.9% | not timed | not timed | 423.16 ± 0.6% | | 1.00 | 0.95 | 7.72 |
| 09-aws-keys/quick | 0 | 824.77 ± 1.8% | not timed | not timed | 805.45 ± 0.6% | 330.82 ± 0.5% | not timed | not timed | 822.04 ± 0.3% | | 1.00 | 1.02 | 2.49 |
| 10-bounded-repeat/letters-en | 1833 | 490.59 ± 0.3% | not timed | not timed | 432.13 ± 0.8% | 16.69 ± 1.9% | not timed | not timed | 490.82 ± 0.7% | | 1.00 | 1.14 | 29.40 |
| 10-bounded-repeat/letters-ru | 3475 | 318.36 ± 0.6% | not timed | not timed | 406.92 ± 0.5% | 17.88 ± 13.6% | not timed | not timed | 318.30 ± 0.4% | | 1.00 | 0.78 | 17.81 |
| 10-bounded-repeat/context | 53 | 66.35 ± 3.7% | not timed | not timed | 56.33 ± 9.2% | 16.80 ± 2.6% | not timed | not timed | 54.43 ± 3.3% | | 1.22 | 1.18 | 3.95 |
| 10-bounded-repeat/capitals | 11 | 845.14 ± 2.4% | not timed | not timed | 532.83 ± 0.4% | 30.92 ± 0.2% | not timed | not timed | 844.29 ± 1.2% | | 1.00 | 1.59 | 27.33 |
| 11-unstructured-to-json/extract | 600 | 35.92 ± 0.5% | not timed | not timed | 62.15 ± 0.6% | 40.77 ± 1.3% | not timed | not timed | 35.90 ± 0.2% | | 1.00 | 0.58 | 0.88 |
| 12-dictionary/single | 1 | 462.43 ± 0.3% | not timed | not timed | 442.34 ± 0.5% | 0.33 ± 0.3% | not timed | not timed | 464.43 ± 0.3% | | 1.00 | 1.05 | 1417.25 |
| 14-quadratic/1x | 100 | 10.06 ± 0.5% | not timed | not timed | 9.13 ± 0.1% | 0.80 ± 3.2% | not timed | not timed | 10.00 ± 2.7% | | 1.01 | 1.10 | 12.60 |
| 14-quadratic/2x | 200 | 6.30 ± 0.2% | not timed | not timed | 4.91 ± 0.3% | 0.41 ± 1.1% | not timed | not timed | 6.30 ± 0.9% | | 1.00 | 1.28 | 15.28 |
| 14-quadratic/10x | 1000 | 1.51 ± 4.4% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 1.1% | not timed | not timed | 1.51 ± 0.7% | | 1.00 | 1.43 | 16.22 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 0.5% | not timed | not timed | 0.37 ± 2.2% | 0.49 ± 3.5% | not timed | not timed | 1.33 ± 1.4% | | 1.01 | 3.61 | 2.77 |
| 04-ruff-noqa/compile-real | 1 | 79.86 ± 0.4% | not timed | not timed | 12.45 ± 12.3% | 123.60 ± 1.5% | not timed | not timed | 78.75 ± 4.5% | | 1.01 | 6.42 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 12.80 ± 0.5% | not timed | not timed | 2.35 ± 0.4% | 5.89 ± 1.7% | not timed | not timed | 12.70 ± 0.8% | | 1.01 | 5.45 | 2.17 |
| 07-unicode-character-data/compile | 1 | 50.32 ± 2.7% | not timed | not timed | 23.88 ± 19.2% | 32.95 ± 2.8% | not timed | not timed | 50.26 ± 0.5% | | 1.00 | 2.11 | 1.53 |
| 09-aws-keys/compile-full | 1 | 34.57 ± 1.3% | not timed | not timed | 7.21 ± 1.0% | 20.37 ± 5.4% | not timed | not timed | 34.62 ± 0.2% | | 1.00 | 4.80 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 160.08 ± 0.3% | not timed | not timed | 42.92 ± 5.5% | 117.02 ± 3.4% | not timed | not timed | 158.65 ± 1.5% | | 1.01 | 3.73 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 10.58 ± 5.6% | not timed | not timed | 11.51 ± 1.0% | 15.20 ± 1.2% | not timed | not timed | 10.60 ± 6.0% | | 1.00 | 0.92 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 73.94 ± 0.6% | not timed | not timed | 8.70 ± 0.7% | 22.28 ± 12.6% | not timed | not timed | 73.14 ± 1.7% | | 1.01 | 8.49 | 3.32 |
| 11-unstructured-to-json/compile | 1 | 75.75 ± 0.7% | not timed | not timed | 35.79 ± 0.9% | 59.73 ± 4.7% | not timed | not timed | 75.53 ± 1.8% | | 1.00 | 2.12 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.8% | not timed | not timed | 0.07 ± 35.1% | 0.08 ± 17.1% | not timed | not timed | 0.29 ± 3.7% | | 1.02 | 4.27 | 3.47 |

