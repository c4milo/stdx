# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
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
| literal: a word | 217 | 16124.62 ± 1.0% | 1040.35 ± 0.1% | 28.91 ± 0.5% | 18300.63 ± 1.1% | 9120.91 ± 9.6% | 17.30 ± 0.4% | 86.98 ± 0.1% | 16179.94 ± 1.0% | 15.50 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18673.19 ± 2.1% | 1048.34 ± 0.2% | 28.83 ± 0.4% | 19838.00 ± 0.9% | 28911.67 ± 1.1% | 17.06 ± 0.2% | 82.89 ± 0.3% | 18784.23 ± 0.6% | 17.81 | 0.99 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6062.76 ± 0.3% | 1023.88 ± 0.1% | 14.74 ± 1.0% | 3949.95 ± 0.2% | 21.91 ± 0.1% | 5.40 ± 0.6% | 6.95 ± 0.7% | 6045.91 ± 0.2% | 5.92 | 1.00 | 1.53 | 276.77 |
| literal: a word in any case | 217 | 12598.57 ± 0.8% | 1040.34 ± 0.1% | 21.64 ± 1.8% | 3974.42 ± 0.1% | 37.67 ± 0.8% | refused | differs | 12579.64 ± 0.4% | 12.11 | 1.00 | 3.17 | 334.48 |
| literal: an href attribute | 33 | 13634.31 ± 1.0% | 1046.71 ± 0.3% | 27.54 ± 0.1% | 16730.74 ± 1.1% | 2263.75 ± 0.7% | 12.74 ± 1.2% | 75.76 ± 0.3% | 13646.42 ± 0.5% | 13.03 | 1.00 | 0.81 | 6.02 |
| literal: a word, second text | 123 | 16382.81 ± 1.2% | 1044.27 ± 0.2% | 28.34 ± 0.1% | 18446.82 ± 0.7% | 7605.92 ± 4.1% | 19.85 ± 0.4% | 70.98 ± 0.4% | 16462.42 ± 1.0% | 15.69 | 1.00 | 0.89 | 2.15 |
| class: two capitalized words | 1331 | 1107.44 ± 0.2% | 978.24 ± 0.1% | 26.20 ± 0.2% | 582.18 ± 0.1% | 40.53 ± 3.1% | 14.76 ± 0.4% | 68.88 ± 0.1% | 1106.36 ± 0.5% | 1.13 | 1.00 | 1.90 | 27.33 |
| class: a word that ends in ing | 3399 | 896.00 ± 0.2% | 895.29 ± 0.2% | 18.26 ± 0.2% | 545.23 ± 0.1% | 29.54 ± 3.9% | 8.16 ± 0.1% | 18.40 ± 0.2% | 895.16 ± 0.2% | 1.00 | 1.00 | 1.64 | 30.33 |
| class: a word in capitals | 2332 | 1458.16 ± 0.4% | 949.92 ± 0.1% | 27.95 ± 0.4% | 572.51 ± 0.1% | 43.45 ± 2.1% | 17.01 ± 0.3% | 83.31 ± 0.2% | 1455.89 ± 0.4% | 1.54 | 1.00 | 2.55 | 33.56 |
| class: a number | 8288 | 1987.12 ± 0.3% | 835.95 ± 0.5% | 28.11 ± 0.3% | 1710.51 ± 0.2% | 41.75 ± 16.5% | 0.51 ± 0.7% | 56.57 ± 0.7% | 1980.69 ± 0.4% | 2.38 | 1.00 | 1.16 | 47.60 |
| class: two capitalized words, second text | 5359 | 743.50 ± 0.2% | 744.21 ± 0.1% | 23.48 ± 0.2% | 485.87 ± 0.1% | 33.78 ± 10.5% | 17.27 ± 0.2% | 63.82 ± 0.8% | 743.62 ± 0.1% | 1.00 | 1.00 | 1.53 | 22.01 |
| other: a word between two words | 6104 | 756.91 ± 0.1% | 777.33 ± 0.1% | 23.71 ± 0.2% | 739.96 ± 0.1% | 108.56 ± 13.7% | 11.20 ± 0.1% | 69.99 ± 0.9% | 756.13 ± 0.1% | 0.97 | 1.00 | 1.02 | 6.97 |
| other: a number before a unit, second text | 1481 | 5430.06 ± 1.2% | 984.76 ± 0.2% | 26.14 ± 0.3% | 5608.66 ± 0.4% | 40.74 ± 11.6% | 18.20 ± 0.1% | 66.88 ± 0.4% | 5445.08 ± 1.0% | 5.51 | 1.00 | 0.97 | 133.29 |
| other: a heading's start tag | 110 | 12489.35 ± 0.4% | 1036.19 ± 0.1% | 27.60 ± 0.2% | 1712.64 ± 0.6% | 1582.78 ± 6.2% | 16.00 ± 0.5% | 89.22 ± 0.5% | 12464.98 ± 0.8% | 12.05 | 1.00 | 7.29 | 7.89 |
| other: a whole word | 217 | 14047.98 ± 0.8% | 1038.92 ± 0.1% | 29.78 ± 0.4% | 14538.60 ± 1.0% | 49.39 ± 0.1% | 13.17 ± 0.1% | 56.32 ± 0.8% | 14089.18 ± 0.8% | 13.52 | 1.00 | 0.97 | 284.42 |
| other: a line's first word, second text | 3716 | 1979.76 ± 0.3% | 876.67 ± 0.2% | 31.40 ± 0.2% | 1725.76 ± 0.7% | 61.53 ± 7.0% | refused | refused | 1967.48 ± 0.8% | 2.26 | 1.01 | 1.15 | 32.17 |
| other: fourteen octets before an x | 87 | 19818.74 ± 0.7% | 215.72 ± 0.3% | 6.61 ± 0.1% | 4010.24 ± 0.7% | 10.65 ± 0.2% | differs | 17.85 ± 0.2% | 19818.64 ± 0.8% | 91.87 | 1.00 | 4.94 | 1860.96 |
| other: a Greek word | 21815 | 514.72 ± 0.3% | 414.26 ± 0.3% | 31.33 ± 0.3% | 289.97 ± 0.1% | 47.99 ± 11.1% | differs | refused | 513.05 ± 0.2% | 1.24 | 1.00 | 1.78 | 10.72 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.85 ± 0.1% | 25.88 ± 0.3% | 0.87 ± 0.2% | 19.87 ± 0.1% | 2.76 ± 1.2% | differs | 4.01 ± 0.2% | 25.89 ± 0.2% | 1.00 | 1.00 | 1.30 | 9.36 |
| a UUID | 32895 | 21.10 ± 0.3% | 21.21 ± 0.3% | 0.65 ± 0.3% | 15.17 ± 0.5% | 3.10 ± 0.7% | 0.73 ± 0.5% | 3.61 ± 0.4% | 21.18 ± 0.4% | 0.99 | 1.00 | 1.39 | 6.82 |
| an IPv4 address | 33176 | 36.95 ± 0.5% | 36.93 ± 0.4% | 2.11 ± 0.5% | 29.44 ± 0.3% | 6.66 ± 0.1% | differs | 4.20 ± 0.2% | 36.97 ± 0.4% | 1.00 | 1.00 | 1.25 | 5.55 |
| a date and time | 32954 | 31.22 ± 0.3% | 31.32 ± 0.3% | 1.48 ± 0.3% | 21.74 ± 0.1% | 7.06 ± 0.1% | 1.26 ± 0.4% | 7.18 ± 0.5% | 31.31 ± 0.3% | 1.00 | 1.00 | 1.44 | 4.42 |
| a field path | 32606 | 29.53 ± 0.2% | 29.48 ± 0.3% | 1.04 ± 0.2% | 23.40 ± 0.2% | 3.52 ± 0.7% | differs | 2.93 ± 0.2% | 29.53 ± 0.3% | 1.00 | 1.00 | 1.26 | 8.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.47 ± 0.4% | 11.45 ± 0.2% | 11.49 ± 0.2% | 11.81 ± 0.2% | 4.93 ± 2.1% | 0.93 ± 0.5% | none | 11.48 ± 0.3% | 1.00 | 1.00 | 0.97 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.44 ± 0.6% | 237.40 ± 0.2% | 286.97 ± 0.2% | 87.07 ± 0.4% | 217.81 ± 1.4% | 482.61 ± 0.5% | 3864.09 ± 3.4% | 235.42 ± 0.1% | 0.99 | 1.00 | 2.70 | 1.08 |
| a UUID | 62 | 157.52 ± 0.3% | 157.89 ± 0.2% | 178.91 ± 0.1% | 46.37 ± 0.3% | 98.28 ± 2.4% | 184.81 ± 2.5% | 4419.13 ± 1.0% | 157.41 ± 0.2% | 1.00 | 1.00 | 3.40 | 1.60 |
| an IPv4 address | 29 | 421.86 ± 0.8% | 428.26 ± 0.3% | 615.09 ± 0.6% | 77.34 ± 0.6% | 128.40 ± 1.0% | 294.12 ± 0.9% | 7641.58 ± 0.3% | 422.65 ± 0.4% | 0.99 | 1.00 | 5.45 | 3.29 |
| a date and time | 56 | 305.44 ± 0.3% | 308.56 ± 0.2% | 393.81 ± 0.1% | 73.12 ± 0.7% | 133.68 ± 2.3% | 318.21 ± 1.8% | 4924.95 ± 0.5% | 305.80 ± 0.4% | 0.99 | 1.00 | 4.18 | 2.28 |
| a field path | 39 | 227.60 ± 0.3% | 229.47 ± 0.3% | 274.72 ± 0.3% | 80.72 ± 0.4% | 200.68 ± 1.3% | 504.62 ± 1.7% | 4929.42 ± 3.1% | 227.64 ± 0.2% | 0.99 | 1.00 | 2.82 | 1.13 |
| literal: a word | 7 | 630.09 ± 0.6% | 674.90 ± 0.6% | 1265.10 ± 1.2% | 522.48 ± 0.3% | 613.76 ± 3.4% | 942.96 ± 0.8% | 30389.72 ± 0.2% | 630.31 ± 0.7% | 0.93 | 1.00 | 1.21 | 1.03 |
| literal: a word that is not there | 8 | 604.36 ± 0.5% | 656.08 ± 0.3% | 1191.70 ± 0.3% | 469.01 ± 0.2% | 593.63 ± 2.3% | 897.52 ± 0.4% | 29077.82 ± 0.3% | 604.36 ± 0.3% | 0.92 | 1.00 | 1.29 | 1.02 |
| literal: one of four words | 26 | 242.75 ± 0.1% | 404.80 ± 0.3% | 566.46 ± 0.5% | 49.24 ± 0.5% | 236.41 ± 1.5% | 366.70 ± 2.0% | 15625.45 ± 0.2% | 242.91 ± 0.4% | 0.60 | 1.00 | 4.93 | 1.03 |
| literal: a word in any case | 11 | 489.10 ± 0.4% | 524.25 ± 0.3% | 848.95 ± 0.3% | 15.72 ± 0.3% | 642.06 ± 2.2% | refused | 23730.46 ± 0.6% | 489.37 ± 0.1% | 0.93 | 1.00 | 31.11 | 0.76 |
| literal: an href attribute | 12 | 353.09 ± 0.6% | 367.31 ± 0.5% | 499.35 ± 0.4% | 45.57 ± 0.7% | 497.36 ± 1.1% | 780.12 ± 0.4% | 21639.22 ± 0.1% | 353.13 ± 1.1% | 0.96 | 1.00 | 7.75 | 0.71 |
| literal: a word, second text | 10 | 567.32 ± 0.5% | 622.99 ± 0.3% | 1080.72 ± 0.9% | 420.18 ± 0.6% | 526.03 ± 9.3% | 810.82 ± 0.5% | 26948.74 ± 0.1% | 567.02 ± 0.4% | 0.91 | 1.00 | 1.35 | 1.08 |
| class: two capitalized words | 23 | 438.29 ± 0.9% | 468.22 ± 0.5% | 701.57 ± 0.8% | 101.15 ± 0.2% | 498.59 ± 9.5% | 747.29 ± 0.6% | 6598.64 ± 0.4% | 437.83 ± 0.5% | 0.94 | 1.00 | 4.33 | 0.88 |
| class: a word that ends in ing | 9 | 568.71 ± 0.5% | 636.23 ± 0.4% | 1164.53 ± 0.2% | 132.17 ± 0.8% | 751.07 ± 0.9% | 1106.85 ± 1.6% | 16096.61 ± 0.4% | 567.59 ± 0.6% | 0.89 | 1.00 | 4.30 | 0.76 |
| class: a word in capitals | 16 | 501.30 ± 0.4% | 540.34 ± 0.3% | 899.49 ± 0.3% | 136.14 ± 0.3% | 740.27 ± 0.4% | 1026.65 ± 1.0% | 8673.39 ± 0.3% | 501.52 ± 0.3% | 0.93 | 1.00 | 3.68 | 0.68 |
| class: a number | 6 | 630.04 ± 0.3% | 696.18 ± 0.2% | 1369.69 ± 0.1% | 41.91 ± 0.4% | 1385.57 ± 0.5% | 1918.80 ± 1.3% | 22849.61 ± 0.3% | 630.09 ± 0.3% | 0.90 | 1.00 | 15.03 | 0.45 |
| class: two capitalized words, second text | 23 | 438.63 ± 0.3% | 468.31 ± 0.4% | 701.18 ± 0.4% | 104.22 ± 0.4% | 497.33 ± 2.8% | 737.32 ± 0.3% | 6602.82 ± 0.8% | 439.14 ± 0.3% | 0.94 | 1.00 | 4.21 | 0.88 |
| other: a word between two words | 13 | 553.87 ± 0.3% | 571.02 ± 0.9% | 945.75 ± 0.5% | 135.25 ± 0.9% | 494.99 ± 4.7% | 814.28 ± 1.2% | 14976.87 ± 0.2% | 553.44 ± 0.3% | 0.97 | 1.00 | 4.10 | 1.12 |
| other: a number before a unit, second text | 15 | 408.54 ± 0.4% | 446.71 ± 0.7% | 647.92 ± 0.6% | 39.40 ± 0.3% | 625.13 ± 1.5% | 889.35 ± 0.3% | 15211.19 ± 0.2% | 408.63 ± 0.1% | 0.91 | 1.00 | 10.37 | 0.65 |
| other: a heading's start tag | 13 | 360.90 ± 0.2% | 367.00 ± 0.5% | 498.41 ± 0.3% | 44.59 ± 0.3% | 618.27 ± 9.2% | 865.28 ± 0.6% | 18083.44 ± 0.4% | 360.38 ± 0.5% | 0.98 | 1.00 | 8.09 | 0.58 |
| other: a whole word | 11 | 588.46 ± 0.5% | 623.81 ± 0.3% | 1087.77 ± 0.6% | 122.08 ± 0.6% | 558.74 ± 1.1% | 817.98 ± 0.9% | 26750.85 ± 0.8% | 589.25 ± 0.4% | 0.94 | 1.00 | 4.82 | 1.05 |
| other: a line's first word, second text | 17 | 538.73 ± 0.4% | 558.40 ± 0.3% | 937.59 ± 0.2% | 130.07 ± 0.2% | 704.65 ± 1.0% | refused | refused | 536.12 ± 0.8% | 0.96 | 1.00 | 4.14 | 0.76 |
| other: fourteen octets before an x | 16 | 112.15 ± 0.4% | 162.75 ± 0.7% | 190.45 ± 0.1% | 15.21 ± 0.3% | 449.33 ± 1.5% | 405.29 ± 0.3% | 12635.84 ± 0.6% | 112.13 ± 0.3% | 0.69 | 1.00 | 7.37 | 0.25 |
| other: a Greek word | 8 | 431.96 ± 0.4% | 592.95 ± 0.4% | 1041.00 ± 0.6% | 59.22 ± 0.6% | 1367.02 ± 0.8% | 1843.72 ± 0.8% | refused | 431.63 ± 0.6% | 0.73 | 1.00 | 7.29 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12801.02 ± 0.3% | not timed | not timed | 16339.26 ± 0.2% | 1977.95 ± 15.0% | not timed | not timed | 12764.28 ± 0.8% | | 1.00 | 0.78 | 6.47 |
| 01-literal/sherlock-casei-en | 522 | 4503.54 ± 1.2% | not timed | not timed | 3585.85 ± 0.2% | 32.50 ± 0.4% | not timed | not timed | 4501.84 ± 0.4% | | 1.00 | 1.26 | 138.58 |
| 01-literal/sherlock-ru | 724 | 13505.08 ± 0.6% | not timed | not timed | 17272.18 ± 0.6% | 1362.01 ± 10.9% | not timed | not timed | 13491.91 ± 0.2% | | 1.00 | 0.78 | 9.92 |
| 01-literal/sherlock-casei-ru | 746 | 5297.54 ± 0.3% | not timed | not timed | 3333.78 ± 0.1% | 31.64 ± 0.2% | not timed | not timed | 5309.36 ± 0.1% | | 1.00 | 1.59 | 167.43 |
| 01-literal/sherlock-zh | 30 | 16924.22 ± 0.3% | not timed | not timed | 18517.12 ± 0.3% | 2654.80 ± 13.1% | not timed | not timed | 16921.29 ± 0.5% | | 1.00 | 0.91 | 6.37 |
| 02-literal-alternate/sherlock-en | 714 | 5735.39 ± 0.5% | not timed | not timed | 3933.49 ± 0.4% | 16.46 ± 0.3% | not timed | not timed | 5740.56 ± 0.4% | | 1.00 | 1.46 | 348.38 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1713.08 ± 1.3% | not timed | not timed | 696.18 ± 0.2% | 11.03 ± 1.5% | not timed | not timed | 1708.16 ± 0.7% | | 1.00 | 2.46 | 155.29 |
| 02-literal-alternate/sherlock-ru | 899 | 4648.33 ± 0.1% | not timed | not timed | 3252.27 ± 0.2% | 22.31 ± 0.2% | not timed | not timed | 4660.17 ± 0.1% | | 1.00 | 1.43 | 208.39 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1811.86 ± 0.5% | not timed | not timed | 1232.40 ± 0.2% | 9.10 ± 0.9% | not timed | not timed | 1806.13 ± 0.5% | | 1.00 | 1.47 | 199.08 |
| 02-literal-alternate/sherlock-zh | 207 | 7045.70 ± 0.5% | not timed | not timed | 4164.91 ± 0.1% | 31.13 ± 0.2% | not timed | not timed | 7046.17 ± 0.2% | | 1.00 | 1.69 | 226.36 |
| 03-date/ascii | 111817 | 127.22 ± 0.7% | not timed | not timed | 96.00 ± 0.1% | 0.20 ± 1.6% | not timed | not timed | 126.63 ± 1.1% | | 1.00 | 1.33 | 628.50 |
| 04-ruff-noqa/real | 84 | 553.57 ± 0.1% | not timed | not timed | 472.64 ± 0.1% | 19.54 ± 1.1% | not timed | not timed | 553.80 ± 0.1% | | 1.00 | 1.17 | 28.33 |
| 04-ruff-noqa/tweaked | 44 | 548.21 ± 0.2% | not timed | not timed | 462.30 ± 0.1% | 363.97 ± 0.8% | not timed | not timed | 546.56 ± 0.6% | | 1.00 | 1.19 | 1.51 |
| 05-lexer-veryl/single | 124800 | 4.19 ± 0.3% | not timed | not timed | 5.24 ± 0.4% | 0.21 ± 2.5% | not timed | not timed | 4.24 ± 1.9% | | 0.99 | 0.80 | 20.39 |
| 06-cloud-flare-redos/original | 107 | 263.56 ± 0.4% | not timed | not timed | 215.69 ± 0.1% | 24.81 ± 0.6% | not timed | not timed | 263.53 ± 0.4% | | 1.00 | 1.22 | 10.62 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.48 ± 0.3% | not timed | not timed | 226.76 ± 0.1% | 26.63 ± 0.1% | not timed | not timed | 259.22 ± 0.4% | | 1.00 | 1.14 | 9.75 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.11 ± 0.4% | not timed | not timed | 253.28 ± 0.1% | 28.81 ± 0.1% | not timed | not timed | 286.25 ± 0.3% | | 1.00 | 1.13 | 9.93 |
| 07-unicode-character-data/parse-line | 558784 | 234.84 ± 0.5% | not timed | not timed | 179.20 ± 0.3% | 41.89 ± 6.0% | not timed | not timed | 227.61 ± 1.8% | | 1.03 | 1.31 | 5.61 |
| 08-words/all-english | 56691 | 120.92 ± 0.2% | not timed | not timed | 83.40 ± 0.1% | 11.94 ± 10.4% | not timed | not timed | 120.57 ± 0.5% | | 1.00 | 1.45 | 10.13 |
| 08-words/long-english | 839 | 1006.11 ± 0.0% | not timed | not timed | 597.89 ± 0.2% | 32.51 ± 0.4% | not timed | not timed | 1006.43 ± 0.1% | | 1.00 | 1.68 | 30.95 |
| 09-aws-keys/full | 0 | 409.12 ± 0.1% | not timed | not timed | 495.82 ± 0.2% | 64.56 ± 0.1% | not timed | not timed | 409.15 ± 0.1% | | 1.00 | 0.83 | 6.34 |
| 09-aws-keys/quick | 0 | 739.29 ± 0.1% | not timed | not timed | 995.71 ± 0.3% | 416.05 ± 1.3% | not timed | not timed | 737.76 ± 0.1% | | 1.00 | 0.74 | 1.78 |
| 10-bounded-repeat/letters-en | 1833 | 636.13 ± 0.4% | not timed | not timed | 518.51 ± 0.1% | 19.49 ± 0.8% | not timed | not timed | 636.63 ± 0.2% | | 1.00 | 1.23 | 32.64 |
| 10-bounded-repeat/letters-ru | 3475 | 385.24 ± 0.2% | not timed | not timed | 477.46 ± 0.1% | 21.99 ± 9.0% | not timed | not timed | 382.24 ± 1.1% | | 1.01 | 0.81 | 17.52 |
| 10-bounded-repeat/context | 53 | 78.94 ± 0.8% | not timed | not timed | 65.70 ± 0.5% | 19.83 ± 0.1% | not timed | not timed | 78.92 ± 1.2% | | 1.00 | 1.20 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 1040.75 ± 0.1% | not timed | not timed | 618.55 ± 0.0% | 36.51 ± 0.1% | not timed | not timed | 1040.88 ± 0.1% | | 1.00 | 1.68 | 28.51 |
| 11-unstructured-to-json/extract | 600 | 49.26 ± 0.2% | not timed | not timed | 75.97 ± 0.1% | 48.90 ± 0.2% | not timed | not timed | 48.44 ± 0.1% | | 1.02 | 0.65 | 1.01 |
| 12-dictionary/single | 1 | 566.59 ± 0.2% | not timed | not timed | 562.36 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 567.48 ± 0.2% | | 1.00 | 1.01 | 1402.03 |
| 14-quadratic/1x | 100 | 9.66 ± 0.6% | not timed | not timed | 10.14 ± 0.1% | 0.97 ± 3.6% | not timed | not timed | 9.64 ± 0.4% | | 1.00 | 0.95 | 9.92 |
| 14-quadratic/2x | 200 | 5.56 ± 0.2% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 2.0% | not timed | not timed | 5.56 ± 0.8% | | 1.00 | 1.00 | 10.47 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.1% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.8% | not timed | not timed | 1.26 ± 0.8% | | 1.00 | 1.04 | 10.91 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.44 ± 0.2% | not timed | not timed | 0.34 ± 0.6% | 0.53 ± 1.3% | not timed | not timed | 1.44 ± 0.3% | | 1.00 | 4.21 | 2.74 |
| 04-ruff-noqa/compile-real | 1 | 92.45 ± 0.3% | not timed | not timed | 13.92 ± 0.2% | 132.15 ± 3.2% | not timed | not timed | 92.52 ± 1.2% | | 1.00 | 6.64 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 14.67 ± 0.3% | not timed | not timed | 2.55 ± 0.7% | 6.26 ± 3.9% | not timed | not timed | 14.61 ± 0.9% | | 1.00 | 5.75 | 2.34 |
| 07-unicode-character-data/compile | 1 | 58.00 ± 0.1% | not timed | not timed | 26.13 ± 0.2% | 34.83 ± 2.5% | not timed | not timed | 58.04 ± 0.4% | | 1.00 | 2.22 | 1.67 |
| 09-aws-keys/compile-full | 1 | 43.78 ± 0.1% | not timed | not timed | 8.34 ± 0.4% | 22.86 ± 4.4% | not timed | not timed | 43.42 ± 1.1% | | 1.01 | 5.25 | 1.91 |
| 09-aws-keys/compile-quick | 1 | 187.28 ± 0.1% | not timed | not timed | 48.22 ± 0.4% | 129.55 ± 2.4% | not timed | not timed | 188.55 ± 0.9% | | 0.99 | 3.88 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 14.77 ± 2.5% | not timed | not timed | 11.24 ± 0.2% | 15.69 ± 5.3% | not timed | not timed | 14.61 ± 2.3% | | 1.01 | 1.31 | 0.94 |
| 10-bounded-repeat/compile-capitals | 1 | 85.90 ± 0.5% | not timed | not timed | 8.11 ± 0.2% | 23.32 ± 18.9% | not timed | not timed | 85.70 ± 1.1% | | 1.00 | 10.60 | 3.68 |
| 11-unstructured-to-json/compile | 1 | 90.43 ± 0.1% | not timed | not timed | 41.12 ± 0.7% | 66.30 ± 3.2% | not timed | not timed | 89.97 ± 0.7% | | 1.01 | 2.20 | 1.36 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 1.3% | 0.09 ± 15.6% | not timed | not timed | 0.36 ± 1.6% | | 1.01 | 5.38 | 3.99 |

