# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117667981 |
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
| literal: a word | 217 | 16129.56 ± 1.9% | 1036.83 ± 0.1% | 28.53 ± 0.2% | 17873.69 ± 1.6% | 9045.53 ± 9.0% | 17.51 ± 0.4% | 86.71 ± 0.2% | 16086.16 ± 0.9% | 15.56 | 1.00 | 0.90 | 1.78 |
| literal: a word that is not there | 0 | 18458.14 ± 2.2% | 1047.89 ± 0.6% | 28.51 ± 0.1% | 19211.02 ± 2.4% | 28198.26 ± 2.0% | 17.37 ± 0.2% | 82.45 ± 0.2% | 18636.46 ± 1.7% | 17.61 | 0.99 | 0.96 | 0.65 |
| literal: one of four words | 661 | 6078.35 ± 0.4% | 1014.42 ± 0.5% | 14.61 ± 0.3% | 3941.49 ± 0.5% | 21.91 ± 0.1% | 5.29 ± 0.2% | 6.91 ± 0.3% | 6068.51 ± 0.1% | 5.99 | 1.00 | 1.54 | 277.42 |
| literal: a word in any case | 217 | 12564.35 ± 1.0% | 1037.45 ± 0.1% | 21.72 ± 2.7% | 3963.86 ± 0.2% | 38.10 ± 0.4% | refused | differs | 12548.33 ± 0.4% | 12.11 | 1.00 | 3.17 | 329.77 |
| literal: an href attribute | 33 | 13854.28 ± 0.8% | 1045.54 ± 0.2% | 27.26 ± 0.2% | 16943.82 ± 2.3% | 2246.63 ± 6.0% | 13.30 ± 0.5% | 75.65 ± 0.2% | 13789.99 ± 0.5% | 13.25 | 1.00 | 0.82 | 6.17 |
| literal: a word, second text | 123 | 16442.63 ± 0.8% | 1041.66 ± 0.1% | 28.01 ± 0.2% | 18211.86 ± 1.0% | 7609.70 ± 4.4% | 19.72 ± 1.4% | 69.97 ± 0.4% | 16425.37 ± 1.0% | 15.79 | 1.00 | 0.90 | 2.16 |
| class: two capitalized words | 1331 | 1125.83 ± 0.6% | 953.57 ± 0.2% | 25.98 ± 0.4% | 585.13 ± 0.1% | 40.70 ± 3.0% | 14.91 ± 0.4% | 68.90 ± 0.3% | 1123.66 ± 0.3% | 1.18 | 1.00 | 1.92 | 27.66 |
| class: a word that ends in ing | 3399 | 875.88 ± 0.3% | 876.89 ± 0.1% | 18.04 ± 0.3% | 547.93 ± 0.1% | 29.66 ± 0.5% | 8.22 ± 0.1% | 18.40 ± 0.6% | 875.67 ± 0.2% | 1.00 | 1.00 | 1.60 | 29.53 |
| class: a word in capitals | 2332 | 1474.52 ± 1.3% | 937.99 ± 0.1% | 27.56 ± 0.6% | 572.64 ± 0.1% | 43.74 ± 0.1% | 17.17 ± 0.1% | 83.26 ± 0.4% | 1475.08 ± 0.3% | 1.57 | 1.00 | 2.57 | 33.71 |
| class: a number | 8288 | 1993.83 ± 0.3% | 786.41 ± 0.1% | 27.79 ± 0.2% | 1733.63 ± 0.1% | 41.27 ± 11.9% | 0.55 ± 0.7% | 56.73 ± 0.2% | 1994.88 ± 0.4% | 2.54 | 1.00 | 1.15 | 48.31 |
| class: two capitalized words, second text | 5359 | 682.39 ± 0.1% | 678.28 ± 0.2% | 23.28 ± 0.1% | 485.21 ± 0.0% | 34.82 ± 5.1% | 16.65 ± 0.3% | 64.02 ± 0.3% | 674.61 ± 0.2% | 1.01 | 1.01 | 1.41 | 19.60 |
| other: a word between two words | 6104 | 757.70 ± 0.3% | 738.30 ± 0.1% | 23.45 ± 0.3% | 734.55 ± 0.2% | 109.48 ± 9.9% | 11.30 ± 0.3% | 69.70 ± 0.3% | 767.63 ± 0.2% | 1.03 | 0.99 | 1.03 | 6.92 |
| other: a number before a unit, second text | 1481 | 5580.54 ± 1.0% | 972.25 ± 0.2% | 25.89 ± 0.2% | 5654.46 ± 0.9% | 40.84 ± 4.3% | 17.79 ± 0.2% | 66.98 ± 0.2% | 5582.49 ± 0.7% | 5.74 | 1.00 | 0.99 | 136.65 |
| other: a heading's start tag | 110 | 12689.46 ± 0.9% | 1035.53 ± 0.2% | 27.44 ± 0.3% | 1710.15 ± 0.7% | 1567.90 ± 0.7% | 16.16 ± 0.5% | 88.86 ± 0.2% | 12710.81 ± 1.0% | 12.25 | 1.00 | 7.42 | 8.09 |
| other: a whole word | 217 | 13967.69 ± 0.8% | 1036.55 ± 0.3% | 29.49 ± 0.3% | 14385.80 ± 1.7% | 49.34 ± 8.8% | 13.66 ± 0.3% | 55.86 ± 0.2% | 13912.39 ± 1.5% | 13.48 | 1.00 | 0.97 | 283.09 |
| other: a line's first word, second text | 3716 | 1981.27 ± 0.6% | 855.74 ± 0.1% | 31.14 ± 0.2% | 1727.78 ± 0.4% | 61.88 ± 6.2% | refused | refused | 1973.68 ± 0.7% | 2.32 | 1.00 | 1.15 | 32.02 |
| other: fourteen octets before an x | 87 | 19690.37 ± 0.8% | 239.03 ± 0.6% | 6.12 ± 0.1% | 4033.80 ± 0.4% | 10.64 ± 0.1% | differs | 17.75 ± 0.1% | 19555.78 ± 0.8% | 82.37 | 1.01 | 4.88 | 1850.71 |
| other: a Greek word | 21815 | 486.92 ± 1.1% | 307.25 ± 0.4% | 31.00 ± 0.2% | 290.14 ± 0.2% | 48.07 ± 12.0% | differs | refused | 486.17 ± 0.9% | 1.58 | 1.00 | 1.68 | 10.13 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.2% | 25.83 ± 0.1% | 0.82 ± 0.4% | 19.75 ± 0.4% | 2.77 ± 0.4% | differs | 3.99 ± 0.2% | 25.84 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.32 |
| a UUID | 32895 | 21.09 ± 0.2% | 21.21 ± 0.2% | 0.64 ± 0.2% | 15.09 ± 0.5% | 3.13 ± 0.1% | 0.72 ± 0.4% | 3.59 ± 0.4% | 21.17 ± 0.1% | 0.99 | 1.00 | 1.40 | 6.74 |
| an IPv4 address | 33176 | 36.87 ± 0.2% | 36.78 ± 0.1% | 2.09 ± 0.2% | 29.00 ± 0.2% | 6.66 ± 0.3% | differs | 4.13 ± 0.3% | 36.83 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.54 |
| a date and time | 32954 | 31.05 ± 0.3% | 31.13 ± 0.2% | 1.46 ± 0.1% | 21.13 ± 0.5% | 7.07 ± 0.2% | 1.20 ± 0.2% | 7.08 ± 0.2% | 31.09 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.39 |
| a field path | 32606 | 29.38 ± 0.1% | 29.26 ± 0.3% | 1.00 ± 0.1% | 22.99 ± 0.4% | 3.49 ± 0.8% | differs | 2.96 ± 0.3% | 29.37 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.64 ± 0.5% | 11.66 ± 0.5% | 11.65 ± 1.1% | 11.51 ± 0.2% | 4.92 ± 2.3% | 0.91 ± 0.7% | none | 11.63 ± 0.5% | 1.00 | 1.00 | 1.01 | 2.37 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.20 ± 0.2% | 218.00 ± 0.2% | 252.43 ± 0.1% | 86.44 ± 1.0% | 217.87 ± 1.9% | 481.00 ± 1.6% | 3885.12 ± 0.6% | 217.25 ± 0.2% | 1.00 | 1.00 | 2.51 | 1.00 |
| a UUID | 62 | 142.87 ± 0.2% | 143.19 ± 0.3% | 157.84 ± 0.2% | 46.50 ± 0.7% | 98.10 ± 2.2% | 189.39 ± 2.7% | 4398.97 ± 2.3% | 142.71 ± 0.1% | 1.00 | 1.00 | 3.07 | 1.46 |
| an IPv4 address | 29 | 439.39 ± 0.5% | 442.90 ± 0.5% | 615.68 ± 0.6% | 77.12 ± 0.4% | 130.31 ± 1.7% | 300.36 ± 1.0% | 7656.97 ± 0.2% | 439.58 ± 0.4% | 0.99 | 1.00 | 5.70 | 3.37 |
| a date and time | 56 | 319.20 ± 0.1% | 320.50 ± 0.5% | 402.81 ± 0.2% | 73.20 ± 0.4% | 135.34 ± 2.3% | 323.95 ± 1.2% | 4934.96 ± 0.5% | 319.14 ± 0.3% | 1.00 | 1.00 | 4.36 | 2.36 |
| a field path | 39 | 202.42 ± 0.4% | 203.10 ± 0.3% | 233.21 ± 0.2% | 80.83 ± 1.1% | 202.95 ± 1.9% | 500.27 ± 3.0% | 4919.29 ± 0.7% | 202.60 ± 0.3% | 1.00 | 1.00 | 2.50 | 1.00 |
| literal: a word | 7 | 666.77 ± 0.8% | 719.00 ± 0.4% | 1289.91 ± 0.2% | 526.71 ± 0.2% | 624.36 ± 1.2% | 952.00 ± 0.8% | 31145.47 ± 0.1% | 666.74 ± 0.4% | 0.93 | 1.00 | 1.27 | 1.07 |
| literal: a word that is not there | 8 | 635.89 ± 0.3% | 691.31 ± 0.3% | 1210.21 ± 0.1% | 482.85 ± 0.1% | 596.01 ± 2.4% | 903.32 ± 0.5% | 29544.03 ± 0.2% | 636.17 ± 0.3% | 0.92 | 1.00 | 1.32 | 1.07 |
| literal: one of four words | 26 | 256.09 ± 0.3% | 421.45 ± 0.2% | 570.02 ± 0.3% | 50.19 ± 1.3% | 241.88 ± 3.3% | 374.06 ± 1.1% | 15788.08 ± 0.4% | 256.22 ± 0.3% | 0.61 | 1.00 | 5.10 | 1.06 |
| literal: a word in any case | 11 | 520.06 ± 0.2% | 561.51 ± 0.3% | 865.13 ± 0.2% | 15.52 ± 1.4% | 649.16 ± 2.7% | refused | 23647.36 ± 0.4% | 519.97 ± 0.5% | 0.93 | 1.00 | 33.51 | 0.80 |
| literal: an href attribute | 12 | 350.92 ± 0.5% | 362.75 ± 0.7% | 472.91 ± 0.5% | 45.88 ± 0.3% | 500.19 ± 0.7% | 771.05 ± 1.4% | 22311.79 ± 0.3% | 350.92 ± 0.2% | 0.97 | 1.00 | 7.65 | 0.70 |
| literal: a word, second text | 10 | 591.92 ± 0.5% | 651.11 ± 0.8% | 1092.39 ± 0.7% | 403.39 ± 0.2% | 533.46 ± 8.8% | 799.13 ± 0.5% | 27473.29 ± 0.2% | 592.52 ± 0.5% | 0.91 | 1.00 | 1.47 | 1.11 |
| class: two capitalized words | 23 | 461.01 ± 0.6% | 490.32 ± 0.1% | 711.99 ± 0.8% | 100.24 ± 0.2% | 498.20 ± 2.8% | 739.02 ± 0.6% | 6627.94 ± 0.3% | 461.51 ± 0.2% | 0.94 | 1.00 | 4.60 | 0.93 |
| class: a word that ends in ing | 9 | 598.36 ± 0.6% | 666.78 ± 0.6% | 1175.77 ± 0.1% | 132.65 ± 1.8% | 758.97 ± 1.0% | 1096.01 ± 0.6% | 16252.75 ± 0.4% | 598.53 ± 0.6% | 0.90 | 1.00 | 4.51 | 0.79 |
| class: a word in capitals | 16 | 522.67 ± 0.9% | 559.99 ± 0.8% | 887.91 ± 0.4% | 135.59 ± 0.7% | 744.61 ± 2.4% | 1021.85 ± 0.6% | 8713.10 ± 0.2% | 523.25 ± 0.4% | 0.93 | 1.00 | 3.85 | 0.70 |
| class: a number | 6 | 662.90 ± 0.3% | 723.44 ± 0.6% | 1341.09 ± 0.1% | 41.84 ± 0.7% | 1418.52 ± 4.6% | 1852.25 ± 1.3% | 22910.48 ± 0.2% | 661.87 ± 0.2% | 0.92 | 1.00 | 15.85 | 0.47 |
| class: two capitalized words, second text | 23 | 461.50 ± 0.6% | 490.21 ± 0.7% | 711.38 ± 0.3% | 101.46 ± 0.3% | 503.15 ± 2.2% | 759.65 ± 0.2% | 6616.91 ± 0.1% | 461.12 ± 0.4% | 0.94 | 1.00 | 4.55 | 0.92 |
| other: a word between two words | 13 | 583.29 ± 0.5% | 602.15 ± 0.5% | 962.15 ± 0.7% | 133.49 ± 0.5% | 505.46 ± 1.3% | 813.77 ± 0.7% | 15115.67 ± 0.2% | 582.60 ± 0.7% | 0.97 | 1.00 | 4.37 | 1.15 |
| other: a number before a unit, second text | 15 | 402.20 ± 0.4% | 436.47 ± 0.2% | 598.05 ± 0.2% | 39.55 ± 0.4% | 638.10 ± 0.9% | 888.89 ± 0.9% | 15312.09 ± 0.3% | 401.64 ± 0.1% | 0.92 | 1.00 | 10.17 | 0.63 |
| other: a heading's start tag | 13 | 362.10 ± 0.2% | 366.75 ± 0.3% | 478.61 ± 0.5% | 44.04 ± 0.4% | 634.55 ± 0.6% | 876.00 ± 0.9% | 18492.39 ± 0.4% | 362.08 ± 0.3% | 0.99 | 1.00 | 8.22 | 0.57 |
| other: a whole word | 11 | 617.44 ± 0.3% | 656.60 ± 0.3% | 1092.99 ± 0.2% | 117.84 ± 0.5% | 561.20 ± 1.8% | 834.87 ± 0.4% | 27192.31 ± 0.3% | 615.56 ± 0.5% | 0.94 | 1.00 | 5.24 | 1.10 |
| other: a line's first word, second text | 17 | 556.82 ± 0.2% | 577.33 ± 0.4% | 925.09 ± 0.5% | 129.50 ± 0.2% | 707.63 ± 1.5% | refused | refused | 555.23 ± 0.9% | 0.96 | 1.00 | 4.30 | 0.79 |
| other: fourteen octets before an x | 16 | 112.54 ± 0.5% | 162.96 ± 0.4% | 186.30 ± 0.3% | 15.26 ± 0.3% | 452.90 ± 1.7% | 414.90 ± 0.3% | 12784.77 ± 0.4% | 112.42 ± 0.3% | 0.69 | 1.00 | 7.38 | 0.25 |
| other: a Greek word | 8 | 450.28 ± 0.1% | 594.20 ± 0.1% | 972.50 ± 0.1% | 59.16 ± 0.7% | 1391.40 ± 1.5% | 1790.04 ± 0.3% | refused | 450.11 ± 0.3% | 0.76 | 1.00 | 7.61 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12960.31 ± 0.7% | not timed | not timed | 16301.87 ± 1.7% | 2051.85 ± 16.9% | not timed | not timed | 12956.68 ± 0.5% | | 1.00 | 0.80 | 6.32 |
| 01-literal/sherlock-casei-en | 522 | 3915.26 ± 0.6% | not timed | not timed | 3592.76 ± 0.4% | 32.37 ± 0.2% | not timed | not timed | 3910.89 ± 0.1% | | 1.00 | 1.09 | 120.95 |
| 01-literal/sherlock-ru | 724 | 13655.86 ± 0.3% | not timed | not timed | 17323.87 ± 0.3% | 1535.41 ± 11.3% | not timed | not timed | 13639.68 ± 0.4% | | 1.00 | 0.79 | 8.89 |
| 01-literal/sherlock-casei-ru | 746 | 5321.10 ± 0.4% | not timed | not timed | 3331.92 ± 0.3% | 30.78 ± 0.5% | not timed | not timed | 5327.04 ± 0.5% | | 1.00 | 1.60 | 172.85 |
| 01-literal/sherlock-zh | 30 | 16986.83 ± 1.7% | not timed | not timed | 18513.92 ± 0.8% | 2796.16 ± 5.4% | not timed | not timed | 16998.95 ± 0.3% | | 1.00 | 0.92 | 6.08 |
| 02-literal-alternate/sherlock-en | 714 | 5843.04 ± 0.2% | not timed | not timed | 3934.97 ± 0.4% | 16.48 ± 0.2% | not timed | not timed | 5841.05 ± 0.3% | | 1.00 | 1.48 | 354.48 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1684.96 ± 0.8% | not timed | not timed | 696.53 ± 0.3% | 11.04 ± 0.1% | not timed | not timed | 1675.94 ± 0.3% | | 1.01 | 2.42 | 152.68 |
| 02-literal-alternate/sherlock-ru | 899 | 4722.51 ± 0.2% | not timed | not timed | 3258.42 ± 0.1% | 22.64 ± 0.1% | not timed | not timed | 4724.97 ± 0.2% | | 1.00 | 1.45 | 208.55 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1792.87 ± 0.6% | not timed | not timed | 1233.23 ± 0.3% | 9.05 ± 0.2% | not timed | not timed | 1793.10 ± 0.2% | | 1.00 | 1.45 | 198.10 |
| 02-literal-alternate/sherlock-zh | 207 | 7087.25 ± 0.1% | not timed | not timed | 4161.40 ± 0.2% | 31.46 ± 0.2% | not timed | not timed | 7068.94 ± 0.3% | | 1.00 | 1.70 | 225.28 |
| 03-date/ascii | 111817 | 124.27 ± 0.7% | not timed | not timed | 96.54 ± 0.1% | 0.20 ± 1.5% | not timed | not timed | 123.64 ± 0.1% | | 1.01 | 1.29 | 622.62 |
| 04-ruff-noqa/real | 84 | 555.44 ± 0.1% | not timed | not timed | 458.67 ± 0.2% | 19.71 ± 1.4% | not timed | not timed | 553.40 ± 0.1% | | 1.00 | 1.21 | 28.18 |
| 04-ruff-noqa/tweaked | 44 | 559.01 ± 0.1% | not timed | not timed | 454.92 ± 0.1% | 367.53 ± 0.7% | not timed | not timed | 559.53 ± 0.1% | | 1.00 | 1.23 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.69 ± 0.4% | not timed | not timed | 4.97 ± 0.2% | 0.20 ± 1.7% | not timed | not timed | 3.71 ± 0.6% | | 1.00 | 0.74 | 18.08 |
| 06-cloud-flare-redos/original | 107 | 183.76 ± 0.3% | not timed | not timed | 216.71 ± 0.1% | 24.96 ± 0.2% | not timed | not timed | 184.56 ± 0.5% | | 1.00 | 0.85 | 7.36 |
| 06-cloud-flare-redos/simplified-short | 102 | 143.77 ± 0.9% | not timed | not timed | 229.81 ± 0.4% | 26.74 ± 0.4% | not timed | not timed | 143.75 ± 0.8% | | 1.00 | 0.63 | 5.38 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.65 ± 2.4% | not timed | not timed | 257.01 ± 0.1% | 28.85 ± 0.2% | not timed | not timed | 154.48 ± 2.5% | | 1.00 | 0.60 | 5.36 |
| 07-unicode-character-data/parse-line | 558784 | 242.82 ± 2.4% | not timed | not timed | 174.35 ± 0.1% | 43.11 ± 4.7% | not timed | not timed | 240.63 ± 0.7% | | 1.01 | 1.39 | 5.63 |
| 08-words/all-english | 56691 | 102.84 ± 0.4% | not timed | not timed | 82.93 ± 0.2% | 12.08 ± 11.3% | not timed | not timed | 102.39 ± 0.5% | | 1.00 | 1.24 | 8.52 |
| 08-words/long-english | 839 | 999.03 ± 0.1% | not timed | not timed | 597.52 ± 0.1% | 32.74 ± 1.1% | not timed | not timed | 998.28 ± 0.2% | | 1.00 | 1.67 | 30.51 |
| 09-aws-keys/full | 0 | 424.20 ± 0.1% | not timed | not timed | 464.06 ± 0.2% | 64.70 ± 0.1% | not timed | not timed | 424.02 ± 0.1% | | 1.00 | 0.91 | 6.56 |
| 09-aws-keys/quick | 0 | 736.88 ± 0.1% | not timed | not timed | 983.37 ± 0.2% | 422.99 ± 1.8% | not timed | not timed | 732.46 ± 0.1% | | 1.01 | 0.75 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 585.93 ± 0.2% | not timed | not timed | 518.36 ± 0.3% | 19.46 ± 0.7% | not timed | not timed | 585.48 ± 0.2% | | 1.00 | 1.13 | 30.12 |
| 10-bounded-repeat/letters-ru | 3475 | 402.21 ± 0.1% | not timed | not timed | 480.51 ± 0.2% | 22.09 ± 7.9% | not timed | not timed | 400.45 ± 0.5% | | 1.00 | 0.84 | 18.21 |
| 10-bounded-repeat/context | 53 | 80.00 ± 0.9% | not timed | not timed | 65.90 ± 0.3% | 19.77 ± 0.3% | not timed | not timed | 79.72 ± 1.3% | | 1.00 | 1.21 | 4.05 |
| 10-bounded-repeat/capitals | 11 | 1047.35 ± 0.1% | not timed | not timed | 616.99 ± 0.3% | 36.76 ± 0.1% | not timed | not timed | 1047.04 ± 0.1% | | 1.00 | 1.70 | 28.49 |
| 11-unstructured-to-json/extract | 600 | 48.25 ± 0.1% | not timed | not timed | 77.81 ± 0.2% | 48.91 ± 0.2% | not timed | not timed | 47.07 ± 0.3% | | 1.03 | 0.62 | 0.99 |
| 12-dictionary/single | 1 | 604.61 ± 0.4% | not timed | not timed | 562.17 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 604.90 ± 0.2% | | 1.00 | 1.08 | 1478.22 |
| 14-quadratic/1x | 100 | 12.59 ± 0.3% | not timed | not timed | 10.04 ± 0.3% | 0.97 ± 3.0% | not timed | not timed | 12.54 ± 1.4% | | 1.00 | 1.25 | 12.98 |
| 14-quadratic/2x | 200 | 7.82 ± 0.4% | not timed | not timed | 5.55 ± 0.4% | 0.54 ± 1.8% | not timed | not timed | 7.81 ± 0.1% | | 1.00 | 1.41 | 14.62 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.5% | not timed | not timed | 1.87 ± 0.3% | | 1.00 | 1.54 | 16.19 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 0.2% | not timed | not timed | 0.34 ± 0.7% | 0.56 ± 3.4% | not timed | not timed | 1.53 ± 1.0% | | 1.00 | 4.44 | 2.75 |
| 04-ruff-noqa/compile-real | 1 | 85.43 ± 0.2% | not timed | not timed | 13.77 ± 0.3% | 141.30 ± 2.8% | not timed | not timed | 85.11 ± 0.8% | | 1.00 | 6.20 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 14.47 ± 0.2% | not timed | not timed | 2.52 ± 0.6% | 6.49 ± 3.2% | not timed | not timed | 14.40 ± 1.1% | | 1.01 | 5.74 | 2.23 |
| 07-unicode-character-data/compile | 1 | 55.03 ± 0.1% | not timed | not timed | 25.95 ± 0.1% | 36.52 ± 1.6% | not timed | not timed | 54.96 ± 1.2% | | 1.00 | 2.12 | 1.51 |
| 09-aws-keys/compile-full | 1 | 42.11 ± 0.2% | not timed | not timed | 8.30 ± 0.3% | 23.47 ± 0.5% | not timed | not timed | 42.09 ± 0.2% | | 1.00 | 5.07 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 188.94 ± 0.1% | not timed | not timed | 47.21 ± 0.2% | 136.33 ± 1.6% | not timed | not timed | 187.10 ± 1.6% | | 1.01 | 4.00 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.50 ± 2.3% | not timed | not timed | 11.24 ± 0.1% | 16.21 ± 2.7% | not timed | not timed | 14.40 ± 3.0% | | 1.01 | 1.29 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 84.86 ± 0.2% | not timed | not timed | 8.06 ± 0.2% | 23.96 ± 1.3% | not timed | not timed | 84.77 ± 0.4% | | 1.00 | 10.53 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 86.23 ± 0.2% | not timed | not timed | 40.56 ± 0.3% | 68.45 ± 2.7% | not timed | not timed | 85.98 ± 0.4% | | 1.00 | 2.13 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 0.2% | 0.09 ± 13.0% | not timed | not timed | 0.36 ± 0.9% | | 1.01 | 5.13 | 3.83 |

