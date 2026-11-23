# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127387921 |
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
| literal: a word | 217 | 16088.00 ± 2.5% | 1038.34 ± 0.1% | 28.70 ± 0.1% | 17972.30 ± 2.9% | 9078.94 ± 8.3% | 17.56 ± 0.4% | 86.08 ± 0.3% | 16190.28 ± 2.6% | 15.49 | 0.99 | 0.90 | 1.77 |
| literal: a word that is not there | 0 | 18516.88 ± 1.7% | 1047.15 ± 0.1% | 28.67 ± 0.4% | 19399.92 ± 2.2% | 28696.20 ± 2.3% | 17.42 ± 0.4% | 81.90 ± 0.3% | 18656.67 ± 1.6% | 17.68 | 0.99 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6070.47 ± 0.6% | 1020.34 ± 0.3% | 14.76 ± 0.2% | 3941.80 ± 0.4% | 21.86 ± 0.1% | 5.30 ± 0.2% | 6.72 ± 0.3% | 6051.47 ± 0.4% | 5.95 | 1.00 | 1.54 | 277.64 |
| literal: a word in any case | 217 | 12536.05 ± 0.7% | 1039.18 ± 0.1% | 21.99 ± 0.3% | 3965.15 ± 0.1% | 38.04 ± 1.5% | refused | differs | 12531.18 ± 0.5% | 12.06 | 1.00 | 3.16 | 329.52 |
| literal: an href attribute | 33 | 13535.07 ± 1.2% | 1045.41 ± 0.2% | 27.39 ± 0.4% | 16327.17 ± 0.7% | 2264.40 ± 0.2% | 13.42 ± 0.6% | 75.33 ± 0.2% | 13464.97 ± 1.0% | 12.95 | 1.01 | 0.83 | 5.98 |
| literal: a word, second text | 123 | 16243.54 ± 1.6% | 1042.93 ± 0.2% | 28.22 ± 0.2% | 18212.21 ± 2.7% | 7837.23 ± 6.9% | 19.70 ± 0.6% | 68.91 ± 0.2% | 16225.35 ± 1.7% | 15.57 | 1.00 | 0.89 | 2.07 |
| class: two capitalized words | 1331 | 1125.17 ± 0.3% | 977.17 ± 0.2% | 26.12 ± 0.2% | 584.80 ± 0.1% | 40.52 ± 2.0% | 14.98 ± 0.5% | 68.33 ± 0.3% | 1126.42 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.77 |
| class: a word that ends in ing | 3399 | 889.26 ± 0.1% | 890.81 ± 0.1% | 18.23 ± 0.1% | 547.92 ± 0.1% | 29.58 ± 11.8% | 8.26 ± 0.2% | 18.23 ± 0.3% | 888.52 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.07 |
| class: a word in capitals | 2332 | 1451.78 ± 0.4% | 950.33 ± 0.1% | 27.82 ± 0.3% | 572.47 ± 0.1% | 43.55 ± 6.6% | 17.26 ± 0.4% | 83.11 ± 0.6% | 1451.29 ± 0.2% | 1.53 | 1.00 | 2.54 | 33.33 |
| class: a number | 8288 | 1991.86 ± 0.2% | 827.24 ± 0.0% | 28.00 ± 0.2% | 1716.46 ± 0.6% | 42.92 ± 13.7% | 0.57 ± 0.0% | 56.84 ± 0.4% | 1987.23 ± 0.2% | 2.41 | 1.00 | 1.16 | 46.41 |
| class: two capitalized words, second text | 5359 | 737.93 ± 0.2% | 736.19 ± 0.1% | 23.44 ± 0.1% | 484.12 ± 0.1% | 35.39 ± 7.0% | 16.70 ± 0.2% | 63.43 ± 0.4% | 737.61 ± 0.2% | 1.00 | 1.00 | 1.52 | 20.85 |
| other: a word between two words | 6104 | 761.10 ± 0.3% | 763.89 ± 0.1% | 23.63 ± 0.2% | 736.64 ± 0.2% | 108.50 ± 14.8% | 11.35 ± 0.1% | 69.31 ± 0.3% | 757.63 ± 0.1% | 1.00 | 1.00 | 1.03 | 7.01 |
| other: a number before a unit, second text | 1481 | 5489.73 ± 0.3% | 982.36 ± 0.2% | 26.04 ± 0.1% | 5631.13 ± 0.8% | 40.73 ± 0.2% | 17.81 ± 0.1% | 66.66 ± 0.3% | 5486.73 ± 0.5% | 5.59 | 1.00 | 0.97 | 134.77 |
| other: a heading's start tag | 110 | 12341.68 ± 0.6% | 1034.90 ± 0.2% | 27.70 ± 0.2% | 1710.67 ± 0.5% | 1580.99 ± 6.3% | 16.37 ± 0.3% | 88.47 ± 0.5% | 12398.81 ± 1.6% | 11.93 | 1.00 | 7.21 | 7.81 |
| other: a whole word | 217 | 13784.76 ± 1.1% | 1037.87 ± 0.2% | 29.94 ± 0.2% | 14311.45 ± 0.7% | 49.43 ± 0.2% | 13.76 ± 0.1% | 55.63 ± 0.1% | 13810.90 ± 1.2% | 13.28 | 1.00 | 0.96 | 278.88 |
| other: a line's first word, second text | 3716 | 1956.30 ± 0.4% | 873.19 ± 0.2% | 31.37 ± 0.3% | 1731.46 ± 0.1% | 62.38 ± 8.5% | refused | refused | 1941.29 ± 0.5% | 2.24 | 1.01 | 1.13 | 31.36 |
| other: fourteen octets before an x | 87 | 19554.94 ± 3.2% | 229.30 ± 0.5% | 6.14 ± 0.1% | 3866.03 ± 0.5% | 10.65 ± 0.1% | differs | 17.71 ± 0.3% | 19537.95 ± 0.7% | 85.28 | 1.00 | 5.06 | 1837.01 |
| other: a Greek word | 21815 | 467.26 ± 1.0% | 358.22 ± 0.3% | 31.16 ± 0.3% | 289.32 ± 0.7% | 49.29 ± 9.3% | differs | refused | 466.66 ± 1.0% | 1.30 | 1.00 | 1.62 | 9.48 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.83 ± 0.1% | 25.79 ± 0.5% | 0.82 ± 0.3% | 19.65 ± 0.2% | 2.75 ± 1.2% | differs | 4.02 ± 0.4% | 25.85 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.38 |
| a UUID | 32895 | 21.04 ± 0.3% | 21.16 ± 0.2% | 0.65 ± 0.2% | 15.06 ± 0.6% | 3.10 ± 0.3% | 0.72 ± 0.4% | 3.61 ± 0.3% | 21.15 ± 0.3% | 0.99 | 0.99 | 1.40 | 6.78 |
| an IPv4 address | 33176 | 36.97 ± 0.2% | 36.89 ± 0.1% | 2.09 ± 1.7% | 29.04 ± 0.5% | 6.67 ± 0.1% | differs | 4.15 ± 0.2% | 36.94 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.54 |
| a date and time | 32954 | 31.01 ± 0.4% | 31.06 ± 0.4% | 1.42 ± 0.1% | 21.16 ± 0.3% | 7.06 ± 0.2% | 1.20 ± 0.4% | 7.03 ± 0.3% | 30.99 ± 0.8% | 1.00 | 1.00 | 1.47 | 4.39 |
| a field path | 32606 | 29.51 ± 0.3% | 29.41 ± 0.1% | 1.01 ± 0.3% | 22.95 ± 0.2% | 3.47 ± 0.8% | differs | 2.93 ± 0.2% | 29.44 ± 0.3% | 1.00 | 1.00 | 1.29 | 8.50 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.3% | 11.52 ± 0.4% | 11.53 ± 0.5% | 11.45 ± 0.3% | 4.90 ± 1.0% | 0.91 ± 0.7% | none | 11.49 ± 0.2% | 1.00 | 1.00 | 1.01 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 155.15 ± 0.4% | 155.49 ± 0.3% | 172.67 ± 0.6% | 86.88 ± 0.2% | 214.84 ± 2.0% | 486.74 ± 0.8% | 3742.71 ± 0.7% | 155.10 ± 0.2% | 1.00 | 1.00 | 1.79 | 0.72 |
| a UUID | 62 | 98.63 ± 0.2% | 98.78 ± 0.3% | 105.42 ± 0.4% | 45.54 ± 0.0% | 98.01 ± 0.7% | 185.08 ± 1.0% | 4482.08 ± 1.3% | 98.55 ± 0.3% | 1.00 | 1.00 | 2.17 | 1.01 |
| an IPv4 address | 29 | 439.04 ± 0.6% | 443.44 ± 0.4% | 613.84 ± 0.4% | 76.25 ± 0.8% | 129.89 ± 1.7% | 295.11 ± 0.5% | 7718.13 ± 0.5% | 439.28 ± 0.5% | 0.99 | 1.00 | 5.76 | 3.38 |
| a date and time | 56 | 318.86 ± 0.3% | 320.33 ± 0.1% | 401.63 ± 0.0% | 71.86 ± 0.1% | 135.86 ± 0.4% | 321.50 ± 0.5% | 4977.25 ± 0.4% | 319.11 ± 0.2% | 1.00 | 1.00 | 4.44 | 2.35 |
| a field path | 39 | 133.49 ± 0.3% | 133.85 ± 0.1% | 146.30 ± 0.1% | 79.47 ± 0.6% | 202.42 ± 1.9% | 485.46 ± 0.9% | 4858.27 ± 0.4% | 133.47 ± 0.2% | 1.00 | 1.00 | 1.68 | 0.66 |
| literal: a word | 7 | 669.76 ± 0.4% | 722.34 ± 0.1% | 1292.57 ± 0.2% | 504.43 ± 1.6% | 613.77 ± 0.9% | 920.02 ± 0.6% | 30880.94 ± 0.5% | 669.59 ± 0.4% | 0.93 | 1.00 | 1.33 | 1.09 |
| literal: a word that is not there | 8 | 639.22 ± 0.1% | 695.45 ± 0.3% | 1219.37 ± 0.6% | 462.23 ± 0.3% | 590.77 ± 2.8% | 873.50 ± 0.4% | 29405.11 ± 0.0% | 640.25 ± 0.3% | 0.92 | 1.00 | 1.38 | 1.08 |
| literal: one of four words | 26 | 256.39 ± 0.5% | 421.45 ± 0.7% | 568.77 ± 0.9% | 49.35 ± 0.3% | 238.77 ± 2.6% | 355.42 ± 0.3% | 15707.14 ± 0.4% | 256.98 ± 0.4% | 0.61 | 1.00 | 5.20 | 1.07 |
| literal: a word in any case | 11 | 524.35 ± 0.3% | 567.15 ± 0.3% | 872.39 ± 0.5% | 15.77 ± 0.8% | 647.89 ± 3.0% | refused | 23636.58 ± 0.2% | 523.98 ± 0.2% | 0.92 | 1.00 | 33.26 | 0.81 |
| literal: an href attribute | 12 | 350.13 ± 0.8% | 362.19 ± 0.4% | 472.53 ± 0.9% | 44.63 ± 1.0% | 493.86 ± 2.3% | 771.16 ± 2.0% | 22080.39 ± 0.2% | 350.24 ± 0.5% | 0.97 | 1.00 | 7.84 | 0.71 |
| literal: a word, second text | 10 | 596.44 ± 0.3% | 658.84 ± 0.4% | 1102.91 ± 0.0% | 408.95 ± 0.6% | 529.80 ± 1.5% | 798.93 ± 0.7% | 27278.08 ± 0.1% | 595.84 ± 0.2% | 0.91 | 1.00 | 1.46 | 1.13 |
| class: two capitalized words | 23 | 460.15 ± 0.0% | 490.55 ± 0.5% | 710.95 ± 0.2% | 100.56 ± 0.2% | 500.25 ± 2.9% | 742.84 ± 0.8% | 6370.36 ± 0.2% | 460.24 ± 0.2% | 0.94 | 1.00 | 4.58 | 0.92 |
| class: a word that ends in ing | 9 | 599.92 ± 0.5% | 668.07 ± 0.2% | 1177.58 ± 0.1% | 132.56 ± 1.0% | 735.89 ± 2.7% | 1089.49 ± 1.8% | 15928.30 ± 0.3% | 599.63 ± 0.3% | 0.90 | 1.00 | 4.53 | 0.82 |
| class: a word in capitals | 16 | 520.40 ± 0.4% | 560.65 ± 0.3% | 885.58 ± 0.3% | 135.32 ± 0.7% | 740.80 ± 0.9% | 1005.98 ± 1.0% | 8370.95 ± 0.1% | 521.90 ± 0.4% | 0.93 | 1.00 | 3.85 | 0.70 |
| class: a number | 6 | 659.90 ± 0.2% | 722.60 ± 0.6% | 1336.08 ± 0.1% | 41.88 ± 0.3% | 1386.41 ± 1.1% | 1906.47 ± 0.8% | 22785.52 ± 0.1% | 660.34 ± 0.4% | 0.91 | 1.00 | 15.76 | 0.48 |
| class: two capitalized words, second text | 23 | 460.28 ± 0.5% | 490.53 ± 0.4% | 710.23 ± 0.5% | 102.98 ± 0.2% | 493.04 ± 2.4% | 748.74 ± 0.7% | 6369.99 ± 0.2% | 460.57 ± 0.3% | 0.94 | 1.00 | 4.47 | 0.93 |
| other: a word between two words | 13 | 583.91 ± 0.2% | 604.14 ± 0.3% | 963.64 ± 0.2% | 135.51 ± 0.4% | 496.33 ± 2.6% | 810.50 ± 0.6% | 14753.32 ± 0.2% | 583.80 ± 0.4% | 0.97 | 1.00 | 4.31 | 1.18 |
| other: a number before a unit, second text | 15 | 319.48 ± 0.4% | 340.78 ± 0.2% | 433.77 ± 0.4% | 39.19 ± 0.3% | 624.99 ± 1.6% | 892.92 ± 0.2% | 15283.85 ± 0.4% | 319.49 ± 0.1% | 0.94 | 1.00 | 8.15 | 0.51 |
| other: a heading's start tag | 13 | 361.15 ± 0.5% | 366.84 ± 0.4% | 477.21 ± 0.4% | 42.21 ± 0.1% | 614.20 ± 1.4% | 859.71 ± 0.1% | 18383.38 ± 0.2% | 361.08 ± 0.6% | 0.98 | 1.00 | 8.55 | 0.59 |
| other: a whole word | 11 | 617.81 ± 0.1% | 658.76 ± 0.2% | 1099.40 ± 0.4% | 120.43 ± 0.4% | 553.84 ± 1.9% | 826.43 ± 1.0% | 26902.03 ± 0.2% | 617.16 ± 0.5% | 0.94 | 1.00 | 5.13 | 1.12 |
| other: a line's first word, second text | 17 | 557.09 ± 0.5% | 579.25 ± 0.2% | 929.11 ± 0.1% | 128.00 ± 0.2% | 700.05 ± 1.3% | refused | refused | 553.54 ± 0.9% | 0.96 | 1.01 | 4.35 | 0.80 |
| other: fourteen octets before an x | 16 | 112.95 ± 0.6% | 163.19 ± 1.3% | 186.19 ± 1.3% | 14.84 ± 0.9% | 446.42 ± 2.0% | 429.50 ± 0.7% | 13010.75 ± 0.2% | 112.90 ± 0.5% | 0.69 | 1.00 | 7.61 | 0.25 |
| other: a Greek word | 8 | 449.99 ± 0.3% | 591.05 ± 0.5% | 964.85 ± 0.1% | 57.61 ± 0.1% | 1357.55 ± 1.3% | 1802.70 ± 0.7% | refused | 450.24 ± 0.4% | 0.76 | 1.00 | 7.81 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12660.28 ± 0.6% | not timed | not timed | 15650.49 ± 2.9% | 1965.43 ± 14.4% | not timed | not timed | 12635.73 ± 0.9% | | 1.00 | 0.81 | 6.44 |
| 01-literal/sherlock-casei-en | 522 | 3883.79 ± 0.9% | not timed | not timed | 3584.93 ± 0.2% | 32.47 ± 0.1% | not timed | not timed | 3875.57 ± 0.4% | | 1.00 | 1.08 | 119.60 |
| 01-literal/sherlock-ru | 724 | 13558.62 ± 0.5% | not timed | not timed | 17259.93 ± 0.4% | 1475.86 ± 7.3% | not timed | not timed | 13502.41 ± 0.7% | | 1.00 | 0.79 | 9.19 |
| 01-literal/sherlock-casei-ru | 746 | 5244.85 ± 0.2% | not timed | not timed | 3324.47 ± 0.1% | 31.36 ± 0.4% | not timed | not timed | 5244.16 ± 0.2% | | 1.00 | 1.58 | 167.22 |
| 01-literal/sherlock-zh | 30 | 16562.65 ± 0.8% | not timed | not timed | 17882.74 ± 0.6% | 2460.00 ± 5.8% | not timed | not timed | 16521.11 ± 0.7% | | 1.00 | 0.93 | 6.73 |
| 02-literal-alternate/sherlock-en | 714 | 5787.52 ± 0.4% | not timed | not timed | 3943.24 ± 0.1% | 16.61 ± 0.1% | not timed | not timed | 5787.81 ± 0.4% | | 1.00 | 1.47 | 348.52 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1665.40 ± 0.4% | not timed | not timed | 696.42 ± 0.4% | 11.11 ± 0.5% | not timed | not timed | 1658.19 ± 0.2% | | 1.00 | 2.39 | 149.90 |
| 02-literal-alternate/sherlock-ru | 899 | 4650.79 ± 0.4% | not timed | not timed | 3255.15 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 4635.87 ± 0.2% | | 1.00 | 1.43 | 205.78 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1777.86 ± 0.4% | not timed | not timed | 1227.96 ± 0.2% | 9.15 ± 0.2% | not timed | not timed | 1773.12 ± 0.5% | | 1.00 | 1.45 | 194.31 |
| 02-literal-alternate/sherlock-zh | 207 | 6994.10 ± 0.3% | not timed | not timed | 4157.03 ± 0.1% | 31.53 ± 7.4% | not timed | not timed | 7002.03 ± 0.5% | | 1.00 | 1.68 | 221.79 |
| 03-date/ascii | 111817 | 124.80 ± 0.3% | not timed | not timed | 95.72 ± 0.1% | 0.20 ± 4.5% | not timed | not timed | 123.72 ± 0.4% | | 1.01 | 1.30 | 616.14 |
| 04-ruff-noqa/real | 84 | 553.92 ± 0.1% | not timed | not timed | 458.10 ± 0.1% | 19.56 ± 1.3% | not timed | not timed | 553.88 ± 0.1% | | 1.00 | 1.21 | 28.32 |
| 04-ruff-noqa/tweaked | 44 | 544.53 ± 0.2% | not timed | not timed | 442.67 ± 0.1% | 361.58 ± 1.3% | not timed | not timed | 543.36 ± 0.2% | | 1.00 | 1.23 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.5% | not timed | not timed | 4.02 ± 0.1% | 0.20 ± 5.7% | not timed | not timed | 3.68 ± 0.8% | | 1.00 | 0.91 | 18.03 |
| 06-cloud-flare-redos/original | 107 | 270.77 ± 0.2% | not timed | not timed | 214.61 ± 0.2% | 22.94 ± 0.3% | not timed | not timed | 269.49 ± 0.1% | | 1.00 | 1.26 | 11.80 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.04 ± 0.6% | not timed | not timed | 228.29 ± 0.1% | 26.71 ± 0.2% | not timed | not timed | 263.91 ± 0.5% | | 1.00 | 1.16 | 9.89 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.32 ± 0.2% | not timed | not timed | 255.79 ± 0.1% | 28.81 ± 0.1% | not timed | not timed | 294.17 ± 0.0% | | 1.00 | 1.15 | 10.21 |
| 07-unicode-character-data/parse-line | 558784 | 242.09 ± 2.4% | not timed | not timed | 148.55 ± 0.1% | 41.84 ± 6.8% | not timed | not timed | 241.27 ± 1.9% | | 1.00 | 1.63 | 5.79 |
| 08-words/all-english | 56691 | 119.47 ± 0.9% | not timed | not timed | 83.17 ± 0.2% | 11.72 ± 9.1% | not timed | not timed | 119.28 ± 0.5% | | 1.00 | 1.44 | 10.19 |
| 08-words/long-english | 839 | 1005.24 ± 0.1% | not timed | not timed | 596.06 ± 0.3% | 32.54 ± 0.3% | not timed | not timed | 1004.97 ± 0.1% | | 1.00 | 1.69 | 30.90 |
| 09-aws-keys/full | 0 | 412.30 ± 0.1% | not timed | not timed | 464.23 ± 0.1% | 64.38 ± 3.6% | not timed | not timed | 412.19 ± 0.0% | | 1.00 | 0.89 | 6.40 |
| 09-aws-keys/quick | 0 | 733.63 ± 0.3% | not timed | not timed | 991.60 ± 0.1% | 413.34 ± 4.0% | not timed | not timed | 729.69 ± 0.2% | | 1.01 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 633.35 ± 0.1% | not timed | not timed | 517.71 ± 0.5% | 19.47 ± 0.3% | not timed | not timed | 633.13 ± 0.2% | | 1.00 | 1.22 | 32.52 |
| 10-bounded-repeat/letters-ru | 3475 | 380.69 ± 0.3% | not timed | not timed | 476.37 ± 0.1% | 21.96 ± 8.8% | not timed | not timed | 378.54 ± 0.4% | | 1.01 | 0.80 | 17.34 |
| 10-bounded-repeat/context | 53 | 78.40 ± 0.9% | not timed | not timed | 64.86 ± 0.9% | 19.79 ± 0.3% | not timed | not timed | 78.16 ± 1.4% | | 1.00 | 1.21 | 3.96 |
| 10-bounded-repeat/capitals | 11 | 1044.61 ± 0.1% | not timed | not timed | 615.34 ± 0.1% | 36.43 ± 0.1% | not timed | not timed | 1044.37 ± 0.1% | | 1.00 | 1.70 | 28.68 |
| 11-unstructured-to-json/extract | 600 | 48.25 ± 0.1% | not timed | not timed | 77.88 ± 0.3% | 48.74 ± 0.9% | not timed | not timed | 47.08 ± 0.9% | | 1.02 | 0.62 | 0.99 |
| 12-dictionary/single | 1 | 572.04 ± 0.2% | not timed | not timed | 559.75 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 572.36 ± 0.1% | | 1.00 | 1.02 | 1401.78 |
| 14-quadratic/1x | 100 | 13.04 ± 0.2% | not timed | not timed | 10.03 ± 0.4% | 0.97 ± 3.6% | not timed | not timed | 12.92 ± 1.4% | | 1.01 | 1.30 | 13.39 |
| 14-quadratic/2x | 200 | 7.97 ± 0.3% | not timed | not timed | 5.52 ± 0.3% | 0.53 ± 1.8% | not timed | not timed | 7.92 ± 1.9% | | 1.01 | 1.44 | 14.98 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.5% | not timed | not timed | 1.85 ± 0.1% | | 1.01 | 1.53 | 16.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 1.1% | not timed | not timed | 0.34 ± 0.5% | 0.53 ± 4.5% | not timed | not timed | 1.54 ± 0.7% | | 1.00 | 4.53 | 2.90 |
| 04-ruff-noqa/compile-real | 1 | 85.51 ± 0.1% | not timed | not timed | 13.83 ± 0.2% | 135.38 ± 1.8% | not timed | not timed | 85.04 ± 0.8% | | 1.01 | 6.18 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 14.51 ± 0.1% | not timed | not timed | 2.50 ± 0.4% | 6.28 ± 4.1% | not timed | not timed | 14.44 ± 1.4% | | 1.00 | 5.81 | 2.31 |
| 07-unicode-character-data/compile | 1 | 54.93 ± 0.3% | not timed | not timed | 25.87 ± 0.3% | 35.14 ± 2.4% | not timed | not timed | 54.78 ± 0.4% | | 1.00 | 2.12 | 1.56 |
| 09-aws-keys/compile-full | 1 | 42.16 ± 0.2% | not timed | not timed | 8.28 ± 0.5% | 22.82 ± 1.2% | not timed | not timed | 41.96 ± 0.8% | | 1.00 | 5.09 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 189.24 ± 0.2% | not timed | not timed | 47.43 ± 0.3% | 130.19 ± 3.3% | not timed | not timed | 189.47 ± 1.3% | | 1.00 | 3.99 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 14.46 ± 0.6% | not timed | not timed | 11.16 ± 0.3% | 15.28 ± 3.1% | not timed | not timed | 14.27 ± 1.8% | | 1.01 | 1.30 | 0.95 |
| 10-bounded-repeat/compile-capitals | 1 | 85.25 ± 1.5% | not timed | not timed | 8.10 ± 0.2% | 23.04 ± 3.6% | not timed | not timed | 84.87 ± 0.2% | | 1.00 | 10.53 | 3.70 |
| 11-unstructured-to-json/compile | 1 | 86.44 ± 0.2% | not timed | not timed | 40.88 ± 0.5% | 65.82 ± 2.8% | not timed | not timed | 86.19 ± 0.5% | | 1.00 | 2.11 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 31.1% | 0.09 ± 9.7% | not timed | not timed | 0.36 ± 0.6% | | 1.01 | 5.42 | 3.85 |

