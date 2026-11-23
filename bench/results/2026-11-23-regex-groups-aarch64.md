# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215324030 |
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
| literal: a word | 217 | 16087.16 ± 1.5% | 4999.08 ± 0.3% | 27.99 ± 0.8% | 18164.60 ± 1.0% | 9103.92 ± 8.3% | 17.61 ± 0.4% | 83.89 ± 0.4% | 16190.76 ± 1.5% | 3.22 | 0.99 | 0.89 | 1.77 |
| literal: a word that is not there | 0 | 18664.53 ± 1.9% | 4877.50 ± 0.3% | 28.05 ± 0.4% | 19892.14 ± 6.0% | 28666.78 ± 2.4% | 17.42 ± 0.2% | 79.67 ± 0.7% | 18620.26 ± 1.0% | 3.83 | 1.00 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6089.91 ± 0.6% | 1935.38 ± 0.4% | 14.20 ± 0.3% | 3940.22 ± 0.2% | 21.91 ± 0.1% | 5.30 ± 0.1% | 6.87 ± 0.1% | 6074.90 ± 0.3% | 3.15 | 1.00 | 1.55 | 278.01 |
| literal: a word in any case | 217 | 12583.77 ± 0.8% | 2067.79 ± 0.2% | 20.89 ± 2.0% | 3957.16 ± 0.1% | 36.82 ± 0.6% | refused | differs | 12556.84 ± 0.9% | 6.09 | 1.00 | 3.18 | 341.74 |
| literal: an href attribute | 33 | 13614.18 ± 1.3% | 615.69 ± 0.1% | 26.69 ± 0.3% | 16896.57 ± 1.1% | 2258.24 ± 0.4% | 13.45 ± 0.2% | 73.39 ± 1.0% | 13587.27 ± 0.5% | 22.11 | 1.00 | 0.81 | 6.03 |
| literal: a word, second text | 123 | 16290.45 ± 2.3% | 3351.02 ± 0.3% | 27.64 ± 0.2% | 17872.37 ± 1.9% | 7651.07 ± 6.1% | 19.77 ± 0.4% | 69.72 ± 0.4% | 16310.72 ± 3.4% | 4.86 | 1.00 | 0.91 | 2.13 |
| class: two capitalized words | 1331 | 1062.22 ± 0.4% | 603.50 ± 0.1% | 25.60 ± 0.1% | 584.77 ± 0.4% | 40.48 ± 8.6% | 14.97 ± 0.2% | 67.30 ± 0.3% | 1063.79 ± 0.4% | 1.76 | 1.00 | 1.82 | 26.24 |
| class: a word that ends in ing | 3399 | 580.11 ± 0.1% | 578.65 ± 0.2% | 17.74 ± 0.1% | 547.67 ± 0.1% | 29.57 ± 10.8% | 8.26 ± 0.3% | 18.37 ± 0.5% | 579.60 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.62 |
| class: a word in capitals | 2332 | 1364.21 ± 0.5% | 614.50 ± 0.2% | 27.27 ± 0.2% | 572.54 ± 0.1% | 43.01 ± 6.4% | 17.28 ± 0.3% | 82.53 ± 0.5% | 1371.12 ± 0.4% | 2.22 | 0.99 | 2.38 | 31.72 |
| class: a number | 8288 | 2002.56 ± 0.3% | 833.41 ± 0.1% | 27.49 ± 0.3% | 1723.66 ± 0.3% | 38.30 ± 13.7% | 0.57 ± 0.3% | 57.50 ± 0.5% | 1996.33 ± 0.2% | 2.40 | 1.00 | 1.16 | 52.29 |
| class: two capitalized words, second text | 5359 | 521.20 ± 0.3% | 528.59 ± 0.2% | 22.87 ± 0.1% | 485.06 ± 0.1% | 34.23 ± 14.6% | 16.72 ± 0.5% | 62.78 ± 0.9% | 520.75 ± 0.2% | 0.99 | 1.00 | 1.07 | 15.23 |
| other: a word between two words | 6104 | 741.86 ± 0.2% | 598.00 ± 0.2% | 23.11 ± 0.4% | 733.00 ± 0.3% | 107.55 ± 13.9% | 11.34 ± 0.2% | 68.11 ± 1.2% | 738.48 ± 0.4% | 1.24 | 1.00 | 1.01 | 6.90 |
| other: a number before a unit, second text | 1481 | 5341.28 ± 0.3% | 1107.74 ± 0.4% | 25.74 ± 0.1% | 5654.50 ± 0.6% | 40.65 ± 0.2% | 17.84 ± 0.2% | 65.86 ± 0.1% | 5329.84 ± 0.2% | 4.82 | 1.00 | 0.94 | 131.39 |
| other: a heading's start tag | 110 | 12504.67 ± 0.7% | 751.06 ± 0.1% | 27.06 ± 0.3% | 1705.91 ± 0.2% | 1574.39 ± 2.6% | 16.36 ± 0.2% | 84.93 ± 1.7% | 12515.74 ± 0.3% | 16.65 | 1.00 | 7.33 | 7.94 |
| other: a whole word | 217 | 13948.30 ± 1.4% | 606.76 ± 0.5% | 29.02 ± 0.3% | 14268.06 ± 1.0% | 47.65 ± 0.5% | 13.87 ± 0.3% | 53.87 ± 1.9% | 13950.32 ± 1.0% | 22.99 | 1.00 | 0.98 | 292.73 |
| other: a line's first word, second text | 3716 | 1954.36 ± 0.3% | 594.46 ± 0.1% | 30.41 ± 0.1% | 1728.31 ± 0.5% | 62.28 ± 6.3% | refused | refused | 1942.58 ± 0.2% | 3.29 | 1.01 | 1.13 | 31.38 |
| other: fourteen octets before an x | 87 | 19392.13 ± 1.3% | 238.80 ± 0.9% | 6.29 ± 0.1% | 4018.43 ± 0.7% | 10.61 ± 0.3% | differs | 17.69 ± 0.2% | 19458.29 ± 0.9% | 81.21 | 1.00 | 4.83 | 1827.36 |
| other: a Greek word | 21815 | 501.24 ± 0.4% | 413.12 ± 0.3% | 30.65 ± 0.3% | 289.32 ± 0.3% | 47.20 ± 4.0% | differs | refused | 499.37 ± 0.6% | 1.21 | 1.00 | 1.73 | 10.62 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.87 ± 0.7% | 19.86 ± 0.4% | 0.84 ± 0.2% | 19.64 ± 0.5% | 2.76 ± 0.8% | differs | 4.04 ± 0.3% | 19.86 ± 0.2% | 1.00 | 1.00 | 1.01 | 7.19 |
| a UUID | 32895 | 21.30 ± 0.2% | 21.36 ± 0.3% | 0.64 ± 0.0% | 15.06 ± 0.5% | 3.09 ± 0.4% | 0.72 ± 0.3% | 3.62 ± 0.3% | 21.37 ± 0.1% | 1.00 | 1.00 | 1.41 | 6.89 |
| an IPv4 address | 33176 | 36.78 ± 0.2% | 36.85 ± 0.2% | 2.05 ± 0.1% | 29.10 ± 0.1% | 6.63 ± 0.2% | differs | 4.14 ± 0.1% | 36.90 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.55 |
| a date and time | 32954 | 31.36 ± 0.3% | 31.37 ± 0.1% | 1.41 ± 0.2% | 21.18 ± 0.6% | 7.05 ± 0.1% | 1.20 ± 0.2% | 7.07 ± 0.7% | 31.37 ± 0.2% | 1.00 | 1.00 | 1.48 | 4.45 |
| a field path | 32606 | 23.47 ± 0.2% | 23.57 ± 0.3% | 1.00 ± 0.6% | 23.17 ± 0.3% | 3.51 ± 0.7% | differs | 2.95 ± 0.2% | 23.55 ± 0.1% | 1.00 | 1.00 | 1.01 | 6.69 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.2% | 11.09 ± 0.1% | 11.09 ± 0.2% | 11.35 ± 0.1% | 4.92 ± 2.0% | 0.91 ± 0.2% | none | 11.09 ± 0.2% | 1.00 | 1.00 | 0.98 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.77 ± 0.3% | 226.38 ± 0.2% | 264.51 ± 0.2% | 87.11 ± 0.3% | 221.33 ± 0.8% | 469.25 ± 0.5% | 3777.67 ± 0.4% | 225.65 ± 0.2% | 1.00 | 1.00 | 2.59 | 1.02 |
| a UUID | 62 | 145.85 ± 0.2% | 146.17 ± 0.2% | 161.45 ± 0.2% | 46.10 ± 0.8% | 98.72 ± 0.6% | 187.80 ± 3.1% | 4213.92 ± 0.3% | 145.81 ± 0.2% | 1.00 | 1.00 | 3.16 | 1.48 |
| an IPv4 address | 29 | 430.37 ± 0.4% | 433.38 ± 0.5% | 597.82 ± 0.8% | 77.00 ± 0.5% | 131.12 ± 1.1% | 300.01 ± 1.6% | 7526.52 ± 0.5% | 429.73 ± 0.4% | 0.99 | 1.00 | 5.59 | 3.28 |
| a date and time | 56 | 301.96 ± 0.4% | 302.94 ± 0.2% | 375.04 ± 0.3% | 72.16 ± 1.0% | 137.09 ± 2.3% | 332.48 ± 0.4% | 4880.62 ± 0.9% | 302.04 ± 0.4% | 1.00 | 1.00 | 4.18 | 2.20 |
| a field path | 39 | 217.25 ± 0.2% | 217.97 ± 0.2% | 252.74 ± 0.3% | 79.60 ± 1.5% | 205.98 ± 1.8% | 500.91 ± 4.3% | 4826.12 ± 1.0% | 217.30 ± 0.2% | 1.00 | 1.00 | 2.73 | 1.05 |
| literal: a word | 7 | 653.50 ± 0.7% | 700.01 ± 0.8% | 1233.51 ± 0.6% | 494.89 ± 0.3% | 632.78 ± 0.8% | 954.42 ± 0.5% | 29557.08 ± 0.2% | 653.28 ± 0.7% | 0.93 | 1.00 | 1.32 | 1.03 |
| literal: a word that is not there | 8 | 628.78 ± 0.3% | 680.04 ± 0.4% | 1164.02 ± 0.1% | 455.77 ± 0.2% | 608.39 ± 1.1% | 899.53 ± 0.8% | 28560.43 ± 0.1% | 628.35 ± 0.4% | 0.92 | 1.00 | 1.38 | 1.03 |
| literal: one of four words | 26 | 250.49 ± 0.3% | 407.57 ± 0.4% | 546.26 ± 0.5% | 50.31 ± 0.8% | 242.19 ± 1.9% | 368.33 ± 0.6% | 15738.54 ± 0.4% | 250.12 ± 0.3% | 0.61 | 1.00 | 4.98 | 1.03 |
| literal: a word in any case | 11 | 455.27 ± 0.2% | 484.19 ± 0.2% | 696.18 ± 0.1% | 15.64 ± 0.2% | 647.70 ± 6.3% | refused | 23449.89 ± 0.3% | 455.08 ± 0.2% | 0.94 | 1.00 | 29.11 | 0.70 |
| literal: an href attribute | 12 | 346.18 ± 0.4% | 357.10 ± 0.4% | 460.91 ± 0.3% | 45.33 ± 1.5% | 501.29 ± 0.6% | 773.71 ± 0.6% | 21283.98 ± 0.8% | 345.57 ± 0.5% | 0.97 | 1.00 | 7.64 | 0.69 |
| literal: a word, second text | 10 | 580.46 ± 0.7% | 636.47 ± 0.3% | 1048.77 ± 0.7% | 404.45 ± 0.8% | 539.07 ± 1.5% | 804.70 ± 0.4% | 26400.12 ± 0.6% | 580.86 ± 1.0% | 0.91 | 1.00 | 1.44 | 1.08 |
| class: two capitalized words | 23 | 444.09 ± 0.5% | 473.36 ± 0.7% | 673.77 ± 0.4% | 102.71 ± 0.5% | 502.77 ± 0.8% | 744.45 ± 0.6% | 6441.71 ± 0.3% | 444.20 ± 0.4% | 0.94 | 1.00 | 4.32 | 0.88 |
| class: a word that ends in ing | 9 | 579.05 ± 0.5% | 645.38 ± 0.2% | 1108.56 ± 0.2% | 132.54 ± 0.2% | 761.87 ± 0.9% | 1098.22 ± 0.5% | 15781.26 ± 0.2% | 578.59 ± 0.8% | 0.90 | 1.00 | 4.37 | 0.76 |
| class: a word in capitals | 16 | 510.29 ± 0.4% | 550.94 ± 0.3% | 871.48 ± 0.4% | 135.67 ± 0.5% | 758.13 ± 0.8% | 1040.85 ± 0.4% | 8494.00 ± 0.5% | 510.26 ± 0.2% | 0.93 | 1.00 | 3.76 | 0.67 |
| class: a number | 6 | 652.04 ± 0.4% | 715.24 ± 0.4% | 1334.71 ± 0.1% | 41.83 ± 0.8% | 1413.66 ± 2.3% | 1855.27 ± 1.8% | 22317.01 ± 0.1% | 651.76 ± 0.3% | 0.91 | 1.00 | 15.59 | 0.46 |
| class: two capitalized words, second text | 23 | 444.67 ± 0.4% | 473.03 ± 0.6% | 672.54 ± 0.4% | 99.79 ± 0.2% | 504.29 ± 1.1% | 737.11 ± 2.9% | 6432.06 ± 0.3% | 444.10 ± 0.1% | 0.94 | 1.00 | 4.46 | 0.88 |
| other: a word between two words | 13 | 560.71 ± 0.4% | 578.16 ± 0.5% | 904.28 ± 0.7% | 132.88 ± 1.0% | 505.43 ± 1.8% | 804.21 ± 0.5% | 14633.08 ± 0.3% | 559.77 ± 0.4% | 0.97 | 1.00 | 4.22 | 1.11 |
| other: a number before a unit, second text | 15 | 400.26 ± 0.5% | 436.34 ± 0.1% | 600.25 ± 0.1% | 39.51 ± 0.6% | 634.72 ± 8.7% | 889.11 ± 0.4% | 14949.63 ± 0.3% | 399.43 ± 0.4% | 0.92 | 1.00 | 10.13 | 0.63 |
| other: a heading's start tag | 13 | 358.13 ± 0.3% | 362.66 ± 0.2% | 470.21 ± 0.6% | 43.73 ± 0.2% | 631.28 ± 0.8% | 877.78 ± 0.4% | 17631.02 ± 0.3% | 357.83 ± 0.3% | 0.99 | 1.00 | 8.19 | 0.57 |
| other: a whole word | 11 | 595.62 ± 0.3% | 631.03 ± 0.4% | 1038.44 ± 0.6% | 119.41 ± 0.6% | 566.74 ± 1.9% | 814.39 ± 0.5% | 26592.55 ± 0.3% | 596.31 ± 0.4% | 0.94 | 1.00 | 4.99 | 1.05 |
| other: a line's first word, second text | 17 | 546.28 ± 0.3% | 564.44 ± 0.3% | 891.19 ± 0.3% | 129.48 ± 0.2% | 712.53 ± 0.3% | refused | refused | 544.00 ± 0.5% | 0.97 | 1.00 | 4.22 | 0.77 |
| other: fourteen octets before an x | 16 | 109.02 ± 0.4% | 156.38 ± 0.4% | 177.66 ± 0.7% | 14.94 ± 0.4% | 455.15 ± 1.3% | 401.55 ± 0.8% | 12699.24 ± 0.6% | 109.17 ± 0.4% | 0.70 | 1.00 | 7.30 | 0.24 |
| other: a Greek word | 8 | 456.51 ± 0.4% | 605.10 ± 0.1% | 997.00 ± 0.0% | 58.86 ± 0.6% | 1401.63 ± 1.3% | 1831.23 ± 0.6% | refused | 456.72 ± 0.3% | 0.75 | 1.00 | 7.76 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12601.97 ± 1.5% | not timed | not timed | 15899.42 ± 1.8% | 1974.09 ± 16.0% | not timed | not timed | 12621.06 ± 1.1% | | 1.00 | 0.79 | 6.38 |
| 01-literal/sherlock-casei-en | 522 | 4951.96 ± 1.0% | not timed | not timed | 3595.92 ± 0.3% | 32.15 ± 0.4% | not timed | not timed | 4938.58 ± 0.5% | | 1.00 | 1.38 | 154.02 |
| 01-literal/sherlock-ru | 724 | 13518.96 ± 0.9% | not timed | not timed | 17239.24 ± 1.3% | 1465.05 ± 15.0% | not timed | not timed | 13506.12 ± 0.9% | | 1.00 | 0.78 | 9.23 |
| 01-literal/sherlock-casei-ru | 746 | 5985.11 ± 0.3% | not timed | not timed | 3312.45 ± 0.2% | 31.39 ± 1.6% | not timed | not timed | 5977.34 ± 0.7% | | 1.00 | 1.81 | 190.66 |
| 01-literal/sherlock-zh | 30 | 16821.15 ± 0.2% | not timed | not timed | 18220.78 ± 0.8% | 2742.47 ± 14.7% | not timed | not timed | 16799.72 ± 0.2% | | 1.00 | 0.92 | 6.13 |
| 02-literal-alternate/sherlock-en | 714 | 5758.00 ± 0.2% | not timed | not timed | 3945.92 ± 0.2% | 16.64 ± 0.0% | not timed | not timed | 5760.20 ± 0.2% | | 1.00 | 1.46 | 346.04 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1806.31 ± 1.0% | not timed | not timed | 696.70 ± 0.3% | 11.04 ± 0.2% | not timed | not timed | 1795.49 ± 0.3% | | 1.01 | 2.59 | 163.59 |
| 02-literal-alternate/sherlock-ru | 899 | 5329.26 ± 0.3% | not timed | not timed | 3262.40 ± 0.1% | 22.24 ± 0.2% | not timed | not timed | 5329.66 ± 0.2% | | 1.00 | 1.63 | 239.65 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1917.47 ± 0.5% | not timed | not timed | 1233.92 ± 0.1% | 9.15 ± 0.1% | not timed | not timed | 1908.27 ± 0.3% | | 1.00 | 1.55 | 209.61 |
| 02-literal-alternate/sherlock-zh | 207 | 7024.10 ± 1.2% | not timed | not timed | 4155.37 ± 0.5% | 31.52 ± 0.6% | not timed | not timed | 7035.46 ± 0.6% | | 1.00 | 1.69 | 222.87 |
| 03-date/ascii | 111817 | 126.26 ± 0.4% | not timed | not timed | 96.11 ± 0.2% | 0.20 ± 6.5% | not timed | not timed | 126.48 ± 0.8% | | 1.00 | 1.31 | 621.96 |
| 04-ruff-noqa/real | 84 | 405.25 ± 0.1% | not timed | not timed | 461.46 ± 0.1% | 19.52 ± 0.4% | not timed | not timed | 407.30 ± 0.1% | | 0.99 | 0.88 | 20.76 |
| 04-ruff-noqa/tweaked | 44 | 547.44 ± 0.3% | not timed | not timed | 463.70 ± 0.1% | 365.36 ± 0.1% | not timed | not timed | 549.27 ± 0.3% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.93 ± 0.3% | not timed | not timed | 5.05 ± 0.1% | 0.21 ± 5.5% | not timed | not timed | 3.91 ± 2.0% | | 1.01 | 0.78 | 18.98 |
| 06-cloud-flare-redos/original | 107 | 411.81 ± 0.1% | not timed | not timed | 217.50 ± 0.1% | 24.46 ± 6.2% | not timed | not timed | 413.96 ± 1.2% | | 0.99 | 1.89 | 16.83 |
| 06-cloud-flare-redos/simplified-short | 102 | 408.50 ± 7.2% | not timed | not timed | 227.98 ± 0.4% | 26.59 ± 2.7% | not timed | not timed | 410.66 ± 0.5% | | 0.99 | 1.79 | 15.36 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.40 ± 0.2% | not timed | not timed | 253.59 ± 0.1% | 28.83 ± 0.2% | not timed | not timed | 586.96 ± 0.0% | | 1.00 | 2.32 | 20.38 |
| 07-unicode-character-data/parse-line | 558784 | 234.81 ± 0.0% | not timed | not timed | 171.78 ± 0.2% | 42.82 ± 1.0% | not timed | not timed | 236.40 ± 0.7% | | 0.99 | 1.37 | 5.48 |
| 08-words/all-english | 56691 | 116.60 ± 0.2% | not timed | not timed | 82.94 ± 0.0% | 11.90 ± 12.9% | not timed | not timed | 117.05 ± 0.5% | | 1.00 | 1.41 | 9.80 |
| 08-words/long-english | 839 | 620.23 ± 0.2% | not timed | not timed | 596.24 ± 0.2% | 32.26 ± 0.6% | not timed | not timed | 621.00 ± 0.2% | | 1.00 | 1.04 | 19.23 |
| 09-aws-keys/full | 0 | 411.10 ± 0.1% | not timed | not timed | 461.50 ± 0.1% | 64.31 ± 4.1% | not timed | not timed | 414.40 ± 0.1% | | 0.99 | 0.89 | 6.39 |
| 09-aws-keys/quick | 0 | 733.32 ± 0.2% | not timed | not timed | 991.75 ± 0.4% | 423.79 ± 0.9% | not timed | not timed | 734.97 ± 0.1% | | 1.00 | 0.74 | 1.73 |
| 10-bounded-repeat/letters-en | 1833 | 580.73 ± 1.7% | not timed | not timed | 517.36 ± 0.3% | 19.54 ± 0.6% | not timed | not timed | 577.02 ± 1.2% | | 1.01 | 1.12 | 29.72 |
| 10-bounded-repeat/letters-ru | 3475 | 509.16 ± 1.0% | not timed | not timed | 478.24 ± 0.3% | 22.35 ± 16.5% | not timed | not timed | 509.16 ± 1.5% | | 1.00 | 1.06 | 22.78 |
| 10-bounded-repeat/context | 53 | 76.70 ± 0.2% | not timed | not timed | 65.45 ± 0.7% | 19.76 ± 0.3% | not timed | not timed | 77.49 ± 0.4% | | 0.99 | 1.17 | 3.88 |
| 10-bounded-repeat/capitals | 11 | 631.40 ± 8.2% | not timed | not timed | 618.28 ± 0.2% | 35.79 ± 0.3% | not timed | not timed | 630.59 ± 8.4% | | 1.00 | 1.02 | 17.64 |
| 11-unstructured-to-json/extract | 600 | 83.01 ± 0.4% | not timed | not timed | 77.68 ± 0.2% | 49.13 ± 6.4% | not timed | not timed | 82.62 ± 0.4% | | 1.00 | 1.07 | 1.69 |
| 12-dictionary/single | 1 | 560.83 ± 0.5% | not timed | not timed | 561.11 ± 0.2% | 0.41 ± 0.2% | not timed | not timed | 560.37 ± 0.2% | | 1.00 | 1.00 | 1367.73 |
| 14-quadratic/1x | 100 | 21.38 ± 1.6% | not timed | not timed | 10.02 ± 0.3% | 0.97 ± 4.2% | not timed | not timed | 21.40 ± 1.6% | | 1.00 | 2.13 | 21.98 |
| 14-quadratic/2x | 200 | 17.57 ± 3.5% | not timed | not timed | 5.52 ± 0.1% | 0.53 ± 1.0% | not timed | not timed | 17.60 ± 1.0% | | 1.00 | 3.19 | 32.86 |
| 14-quadratic/10x | 1000 | 7.69 ± 2.1% | not timed | not timed | 1.21 ± 0.6% | 0.12 ± 1.6% | not timed | not timed | 7.68 ± 2.2% | | 1.00 | 6.38 | 66.69 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 0.4% | not timed | not timed | 0.34 ± 0.8% | 0.55 ± 3.4% | not timed | not timed | 1.27 ± 1.9% | | 1.00 | 3.71 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 89.57 ± 0.3% | not timed | not timed | 13.72 ± 0.4% | 140.61 ± 2.6% | not timed | not timed | 89.28 ± 0.9% | | 1.00 | 6.53 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 13.96 ± 1.5% | not timed | not timed | 2.51 ± 0.6% | 6.49 ± 2.9% | not timed | not timed | 13.92 ± 1.1% | | 1.00 | 5.55 | 2.15 |
| 07-unicode-character-data/compile | 1 | 54.11 ± 0.7% | not timed | not timed | 25.57 ± 0.2% | 35.95 ± 21.5% | not timed | not timed | 53.80 ± 0.6% | | 1.01 | 2.12 | 1.51 |
| 09-aws-keys/compile-full | 1 | 41.57 ± 0.4% | not timed | not timed | 8.26 ± 0.3% | 23.22 ± 1.9% | not timed | not timed | 41.23 ± 1.5% | | 1.01 | 5.03 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 187.44 ± 0.3% | not timed | not timed | 46.22 ± 0.2% | 133.27 ± 2.8% | not timed | not timed | 186.22 ± 0.4% | | 1.01 | 4.06 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.01 ± 0.3% | not timed | not timed | 11.15 ± 0.2% | 15.88 ± 2.5% | not timed | not timed | 13.92 ± 1.3% | | 1.01 | 1.26 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 83.67 ± 0.5% | not timed | not timed | 8.02 ± 0.5% | 23.55 ± 27.0% | not timed | not timed | 83.31 ± 2.2% | | 1.00 | 10.43 | 3.55 |
| 11-unstructured-to-json/compile | 1 | 84.98 ± 0.1% | not timed | not timed | 40.62 ± 0.5% | 68.16 ± 1.5% | not timed | not timed | 84.76 ± 1.0% | | 1.00 | 2.09 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 1.9% | 0.10 ± 11.1% | not timed | not timed | 0.35 ± 1.7% | | 1.01 | 5.01 | 3.58 |

