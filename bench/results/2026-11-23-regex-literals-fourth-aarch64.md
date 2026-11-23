# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243471575 |
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
| literal: a word | 217 | 18856.81 ± 2.5% | 4983.82 ± 0.3% | 28.29 ± 0.5% | 17635.59 ± 2.2% | 9070.27 ± 8.6% | 17.28 ± 0.4% | 84.18 ± 0.6% | 18828.90 ± 1.7% | 3.78 | 1.00 | 1.07 | 2.08 |
| literal: a word that is not there | 0 | 20767.87 ± 2.7% | 4864.59 ± 0.2% | 28.24 ± 0.9% | 18983.87 ± 1.4% | 27861.81 ± 1.5% | 17.11 ± 0.3% | 79.38 ± 0.5% | 21054.45 ± 3.6% | 4.27 | 0.99 | 1.09 | 0.75 |
| literal: one of four words | 661 | 6339.48 ± 0.9% | 1930.69 ± 0.3% | 14.44 ± 0.3% | 3938.56 ± 0.3% | 21.90 ± 0.2% | 5.36 ± 0.3% | 6.88 ± 0.3% | 6307.50 ± 0.5% | 3.28 | 1.01 | 1.61 | 289.46 |
| literal: a word in any case | 217 | 14906.65 ± 0.4% | 2073.52 ± 0.2% | 21.52 ± 0.3% | 3961.97 ± 0.4% | 38.07 ± 0.4% | refused | differs | 14879.24 ± 0.4% | 7.19 | 1.00 | 3.76 | 391.60 |
| literal: an href attribute | 33 | 16448.92 ± 1.4% | 608.65 ± 0.5% | 27.30 ± 0.5% | 16501.90 ± 2.7% | 2251.67 ± 0.4% | 13.16 ± 0.1% | 73.72 ± 0.3% | 16436.11 ± 1.6% | 27.03 | 1.00 | 1.00 | 7.31 |
| literal: a word, second text | 123 | 19018.26 ± 0.9% | 3343.99 ± 0.3% | 28.04 ± 0.4% | 17571.55 ± 0.6% | 7510.24 ± 6.7% | 20.10 ± 0.3% | 69.89 ± 0.4% | 19183.88 ± 1.8% | 5.69 | 0.99 | 1.08 | 2.53 |
| class: two capitalized words | 1331 | 1055.33 ± 0.6% | 599.39 ± 0.3% | 25.96 ± 0.2% | 585.27 ± 0.1% | 40.54 ± 2.2% | 14.73 ± 0.5% | 67.15 ± 1.3% | 1055.43 ± 0.7% | 1.76 | 1.00 | 1.80 | 26.03 |
| class: a word that ends in ing | 3399 | 572.13 ± 0.1% | 571.93 ± 0.3% | 17.98 ± 0.3% | 547.37 ± 0.1% | 29.60 ± 13.0% | 8.16 ± 0.2% | 18.20 ± 0.4% | 571.49 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.33 |
| class: a word in capitals | 2332 | 1369.61 ± 0.4% | 601.75 ± 0.4% | 27.67 ± 0.9% | 572.33 ± 0.3% | 43.47 ± 16.4% | 17.21 ± 0.5% | 81.78 ± 2.6% | 1368.52 ± 0.6% | 2.28 | 1.00 | 2.39 | 31.51 |
| class: a number | 8288 | 1957.51 ± 0.5% | 826.64 ± 0.3% | 27.81 ± 0.6% | 1709.76 ± 0.3% | 42.25 ± 15.9% | 0.55 ± 0.2% | 57.36 ± 0.1% | 1951.61 ± 0.2% | 2.37 | 1.00 | 1.14 | 46.33 |
| class: two capitalized words, second text | 5359 | 515.14 ± 0.4% | 523.53 ± 0.2% | 23.33 ± 0.3% | 485.01 ± 0.8% | 35.37 ± 14.4% | 17.11 ± 0.3% | 62.63 ± 0.3% | 515.19 ± 0.2% | 0.98 | 1.00 | 1.06 | 14.57 |
| other: a word between two words | 6104 | 788.55 ± 0.4% | 593.40 ± 0.2% | 23.54 ± 0.2% | 738.92 ± 0.4% | 110.02 ± 22.6% | 11.19 ± 0.1% | 68.13 ± 0.1% | 791.96 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.17 |
| other: a number before a unit, second text | 1481 | 5923.62 ± 1.4% | 1100.04 ± 0.1% | 26.06 ± 0.3% | 5612.42 ± 0.6% | 40.69 ± 0.2% | 18.23 ± 0.1% | 65.62 ± 0.9% | 5913.83 ± 0.5% | 5.38 | 1.00 | 1.06 | 145.58 |
| other: a heading's start tag | 110 | 13729.36 ± 1.0% | 741.83 ± 0.1% | 27.41 ± 0.5% | 1710.23 ± 0.4% | 1578.54 ± 4.9% | 16.04 ± 0.7% | 85.97 ± 0.7% | 13804.23 ± 0.9% | 18.51 | 0.99 | 8.03 | 8.70 |
| other: a whole word | 217 | 15586.40 ± 1.4% | 601.83 ± 0.7% | 29.23 ± 0.1% | 14126.19 ± 1.5% | 49.36 ± 0.1% | 13.24 ± 0.1% | 54.85 ± 0.8% | 15479.88 ± 4.4% | 25.90 | 1.01 | 1.10 | 315.77 |
| other: a line's first word, second text | 3716 | 2046.04 ± 0.4% | 587.34 ± 0.3% | 30.93 ± 0.6% | 1728.38 ± 0.4% | 62.86 ± 6.4% | refused | refused | 2041.56 ± 0.3% | 3.48 | 1.00 | 1.18 | 32.55 |
| other: fourteen octets before an x | 87 | 23294.03 ± 2.6% | 242.11 ± 0.9% | 6.54 ± 0.1% | 3980.15 ± 0.7% | 10.62 ± 0.4% | differs | 17.67 ± 0.2% | 23271.00 ± 1.4% | 96.21 | 1.00 | 5.85 | 2193.34 |
| other: a Greek word | 21815 | 487.98 ± 0.6% | 407.70 ± 0.3% | 30.89 ± 0.2% | 289.14 ± 0.3% | 49.02 ± 16.6% | differs | refused | 485.15 ± 0.5% | 1.20 | 1.01 | 1.69 | 9.95 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.46 ± 0.1% | 18.48 ± 0.2% | 0.86 ± 0.8% | 19.76 ± 0.3% | 2.74 ± 0.5% | differs | 4.00 ± 0.1% | 18.49 ± 0.3% | 1.00 | 1.00 | 0.93 | 6.73 |
| a UUID | 32895 | 20.08 ± 0.3% | 20.07 ± 0.3% | 0.64 ± 0.3% | 15.03 ± 0.6% | 3.09 ± 0.8% | 0.73 ± 0.1% | 3.64 ± 0.5% | 20.08 ± 0.2% | 1.00 | 1.00 | 1.34 | 6.50 |
| an IPv4 address | 33176 | 33.64 ± 0.7% | 33.65 ± 0.3% | 2.08 ± 0.2% | 29.30 ± 0.7% | 6.55 ± 0.2% | differs | 4.15 ± 0.2% | 33.64 ± 0.8% | 1.00 | 1.00 | 1.15 | 5.14 |
| a date and time | 32954 | 28.82 ± 0.1% | 28.90 ± 0.4% | 1.45 ± 0.4% | 21.52 ± 0.6% | 7.06 ± 0.0% | 1.25 ± 0.1% | 7.14 ± 0.6% | 28.87 ± 0.1% | 1.00 | 1.00 | 1.34 | 4.09 |
| a field path | 32606 | 21.77 ± 0.2% | 21.77 ± 0.5% | 1.02 ± 1.1% | 23.11 ± 0.6% | 3.46 ± 0.8% | differs | 2.93 ± 0.5% | 21.78 ± 0.4% | 1.00 | 1.00 | 0.94 | 6.28 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.8% | 11.08 ± 0.7% | 11.10 ± 0.9% | 11.51 ± 0.3% | 4.85 ± 1.4% | 0.94 ± 0.6% | none | 11.10 ± 0.6% | 1.00 | 1.00 | 0.96 | 2.29 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 228.34 ± 0.2% | 229.33 ± 0.4% | 268.12 ± 0.6% | 86.74 ± 1.2% | 206.23 ± 3.9% | 483.01 ± 2.8% | 3819.96 ± 0.4% | 228.24 ± 0.3% | 1.00 | 1.00 | 2.63 | 1.11 |
| a UUID | 62 | 146.93 ± 0.3% | 147.26 ± 0.3% | 163.05 ± 0.8% | 45.96 ± 0.6% | 91.41 ± 2.7% | 190.29 ± 1.7% | 4290.93 ± 0.7% | 146.83 ± 0.4% | 1.00 | 1.00 | 3.20 | 1.61 |
| an IPv4 address | 29 | 421.35 ± 0.4% | 425.90 ± 0.4% | 583.78 ± 0.4% | 77.78 ± 0.6% | 121.59 ± 3.4% | 302.92 ± 0.4% | 7620.29 ± 0.4% | 421.98 ± 0.4% | 0.99 | 1.00 | 5.42 | 3.47 |
| a date and time | 56 | 304.30 ± 0.2% | 305.53 ± 0.2% | 378.69 ± 0.3% | 73.36 ± 0.3% | 126.41 ± 2.2% | 324.82 ± 1.4% | 4956.02 ± 0.5% | 303.99 ± 0.3% | 1.00 | 1.00 | 4.15 | 2.41 |
| a field path | 39 | 220.46 ± 0.3% | 221.42 ± 0.2% | 257.41 ± 0.3% | 79.44 ± 0.8% | 190.58 ± 1.6% | 496.60 ± 1.7% | 4872.52 ± 0.5% | 220.16 ± 0.3% | 1.00 | 1.00 | 2.78 | 1.16 |
| literal: a word | 7 | 642.95 ± 0.2% | 697.18 ± 0.5% | 1234.58 ± 0.3% | 525.07 ± 0.2% | 600.63 ± 3.0% | 952.06 ± 0.6% | 30698.43 ± 0.1% | 642.52 ± 0.5% | 0.92 | 1.00 | 1.22 | 1.07 |
| literal: a word that is not there | 8 | 615.60 ± 0.2% | 671.67 ± 0.3% | 1162.90 ± 0.2% | 469.72 ± 0.5% | 564.40 ± 3.5% | 902.13 ± 0.3% | 29640.52 ± 0.1% | 616.98 ± 0.2% | 0.92 | 1.00 | 1.31 | 1.09 |
| literal: one of four words | 26 | 247.38 ± 0.2% | 400.74 ± 0.3% | 533.72 ± 0.7% | 50.33 ± 1.7% | 227.08 ± 2.1% | 375.05 ± 3.1% | 16115.53 ± 0.2% | 247.29 ± 0.2% | 0.62 | 1.00 | 4.91 | 1.09 |
| literal: a word in any case | 11 | 444.41 ± 0.2% | 476.05 ± 0.3% | 683.13 ± 0.2% | 15.46 ± 0.5% | 617.90 ± 1.4% | refused | 23766.52 ± 0.6% | 444.04 ± 0.2% | 0.93 | 1.00 | 28.75 | 0.72 |
| literal: an href attribute | 12 | 346.69 ± 0.5% | 360.39 ± 0.2% | 466.20 ± 0.5% | 44.67 ± 0.4% | 480.61 ± 2.3% | 773.69 ± 0.3% | 22198.95 ± 0.3% | 346.64 ± 1.1% | 0.96 | 1.00 | 7.76 | 0.72 |
| literal: a word, second text | 10 | 574.30 ± 0.9% | 635.61 ± 0.9% | 1053.53 ± 0.9% | 416.87 ± 0.3% | 516.11 ± 1.0% | 800.17 ± 0.2% | 27617.24 ± 0.2% | 575.02 ± 0.3% | 0.90 | 1.00 | 1.38 | 1.11 |
| class: two capitalized words | 23 | 443.54 ± 0.6% | 474.08 ± 0.6% | 678.92 ± 0.4% | 99.28 ± 0.2% | 484.56 ± 1.2% | 741.59 ± 0.5% | 6491.72 ± 0.4% | 443.48 ± 0.4% | 0.94 | 1.00 | 4.47 | 0.92 |
| class: a word that ends in ing | 9 | 577.57 ± 0.5% | 646.14 ± 0.2% | 1117.10 ± 0.3% | 132.31 ± 1.3% | 733.93 ± 1.8% | 1094.63 ± 1.5% | 16070.63 ± 0.3% | 576.71 ± 0.3% | 0.89 | 1.00 | 4.37 | 0.79 |
| class: a word in capitals | 16 | 504.87 ± 0.5% | 543.78 ± 0.1% | 861.89 ± 0.0% | 134.86 ± 0.9% | 729.34 ± 1.6% | 1032.58 ± 0.8% | 8566.13 ± 0.7% | 505.11 ± 0.3% | 0.93 | 1.00 | 3.74 | 0.69 |
| class: a number | 6 | 644.07 ± 0.2% | 707.13 ± 0.4% | 1317.40 ± 0.1% | 42.10 ± 1.0% | 1347.68 ± 5.3% | 1847.62 ± 1.2% | 23096.04 ± 0.1% | 642.99 ± 0.5% | 0.91 | 1.00 | 15.30 | 0.48 |
| class: two capitalized words, second text | 23 | 443.96 ± 0.4% | 474.16 ± 0.6% | 677.55 ± 0.4% | 100.15 ± 0.6% | 476.03 ± 2.4% | 754.70 ± 4.2% | 6499.84 ± 0.4% | 443.58 ± 0.4% | 0.94 | 1.00 | 4.43 | 0.93 |
| other: a word between two words | 13 | 556.12 ± 0.4% | 578.85 ± 0.2% | 913.92 ± 0.7% | 135.73 ± 1.0% | 484.83 ± 2.8% | 801.76 ± 0.8% | 14865.31 ± 0.3% | 555.86 ± 0.5% | 0.96 | 1.00 | 4.10 | 1.15 |
| other: a number before a unit, second text | 15 | 399.64 ± 0.2% | 436.89 ± 0.5% | 607.40 ± 0.7% | 39.32 ± 0.6% | 614.12 ± 2.8% | 884.37 ± 0.5% | 15307.01 ± 0.4% | 399.63 ± 0.5% | 0.91 | 1.00 | 10.16 | 0.65 |
| other: a heading's start tag | 13 | 357.04 ± 0.2% | 364.86 ± 0.4% | 475.42 ± 0.6% | 43.78 ± 0.7% | 596.80 ± 2.1% | 865.81 ± 0.7% | 18404.36 ± 0.4% | 356.66 ± 0.2% | 0.98 | 1.00 | 8.15 | 0.60 |
| other: a whole word | 11 | 585.30 ± 0.5% | 626.81 ± 0.4% | 1039.39 ± 0.3% | 120.01 ± 1.0% | 532.95 ± 3.7% | 831.90 ± 0.8% | 27322.08 ± 0.2% | 584.80 ± 0.9% | 0.93 | 1.00 | 4.88 | 1.10 |
| other: a line's first word, second text | 17 | 535.83 ± 0.3% | 561.17 ± 0.2% | 888.92 ± 0.5% | 130.29 ± 0.8% | 679.68 ± 4.5% | refused | refused | 534.13 ± 1.1% | 0.95 | 1.00 | 4.11 | 0.79 |
| other: fourteen octets before an x | 16 | 105.77 ± 0.7% | 150.46 ± 0.8% | 170.00 ± 0.7% | 15.25 ± 0.2% | 438.15 ± 3.1% | 417.50 ± 0.9% | 13006.46 ± 0.2% | 105.94 ± 0.1% | 0.70 | 1.00 | 6.94 | 0.24 |
| other: a Greek word | 8 | 462.23 ± 0.5% | 616.69 ± 0.4% | 1036.86 ± 0.2% | 59.13 ± 0.3% | 1329.34 ± 6.2% | 1840.45 ± 0.4% | refused | 461.98 ± 0.5% | 0.75 | 1.00 | 7.82 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15280.40 ± 1.4% | not timed | not timed | 15898.36 ± 1.7% | 2060.72 ± 13.2% | not timed | not timed | 15274.48 ± 1.1% | | 1.00 | 0.96 | 7.42 |
| 01-literal/sherlock-casei-en | 522 | 5156.05 ± 1.3% | not timed | not timed | 3580.34 ± 0.2% | 32.47 ± 0.2% | not timed | not timed | 5157.12 ± 0.5% | | 1.00 | 1.44 | 158.81 |
| 01-literal/sherlock-ru | 724 | 16997.87 ± 0.4% | not timed | not timed | 17219.01 ± 0.7% | 1432.14 ± 11.4% | not timed | not timed | 16950.09 ± 0.8% | | 1.00 | 0.99 | 11.87 |
| 01-literal/sherlock-casei-ru | 746 | 6150.17 ± 0.4% | not timed | not timed | 3328.29 ± 0.1% | 30.90 ± 0.3% | not timed | not timed | 6137.17 ± 0.5% | | 1.00 | 1.85 | 199.02 |
| 01-literal/sherlock-zh | 30 | 19555.44 ± 0.6% | not timed | not timed | 18434.24 ± 1.0% | 2780.13 ± 13.8% | not timed | not timed | 19444.25 ± 0.5% | | 1.01 | 1.06 | 7.03 |
| 02-literal-alternate/sherlock-en | 714 | 6027.78 ± 0.3% | not timed | not timed | 3939.78 ± 0.4% | 16.59 ± 0.3% | not timed | not timed | 6029.41 ± 0.4% | | 1.00 | 1.53 | 363.29 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1935.79 ± 1.7% | not timed | not timed | 697.61 ± 0.2% | 11.09 ± 0.2% | not timed | not timed | 1926.74 ± 0.7% | | 1.00 | 2.77 | 174.55 |
| 02-literal-alternate/sherlock-ru | 899 | 5544.59 ± 0.3% | not timed | not timed | 3246.86 ± 0.6% | 22.57 ± 0.2% | not timed | not timed | 5535.59 ± 0.4% | | 1.00 | 1.71 | 245.70 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.89 ± 0.5% | not timed | not timed | 1232.50 ± 0.3% | 9.06 ± 0.2% | not timed | not timed | 2052.22 ± 0.2% | | 1.00 | 1.67 | 227.02 |
| 02-literal-alternate/sherlock-zh | 207 | 7273.04 ± 0.7% | not timed | not timed | 4161.28 ± 0.2% | 31.48 ± 0.1% | not timed | not timed | 7275.20 ± 0.3% | | 1.00 | 1.75 | 231.05 |
| 03-date/ascii | 111817 | 123.51 ± 0.6% | not timed | not timed | 95.89 ± 0.1% | 0.20 ± 1.8% | not timed | not timed | 122.84 ± 0.2% | | 1.01 | 1.29 | 620.83 |
| 04-ruff-noqa/real | 84 | 402.08 ± 0.1% | not timed | not timed | 463.45 ± 0.3% | 19.54 ± 1.3% | not timed | not timed | 402.05 ± 0.1% | | 1.00 | 0.87 | 20.57 |
| 04-ruff-noqa/tweaked | 44 | 559.34 ± 0.2% | not timed | not timed | 465.61 ± 0.1% | 365.96 ± 2.5% | not timed | not timed | 560.18 ± 0.5% | | 1.00 | 1.20 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.2% | not timed | not timed | 5.17 ± 0.9% | 0.20 ± 4.7% | not timed | not timed | 5.33 ± 0.3% | | 1.00 | 1.03 | 26.40 |
| 06-cloud-flare-redos/original | 107 | 415.56 ± 0.2% | not timed | not timed | 213.24 ± 0.2% | 24.87 ± 0.2% | not timed | not timed | 415.38 ± 0.1% | | 1.00 | 1.95 | 16.71 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.11 ± 0.3% | not timed | not timed | 227.98 ± 0.2% | 26.70 ± 0.2% | not timed | not timed | 411.93 ± 0.1% | | 1.00 | 1.80 | 15.39 |
| 06-cloud-flare-redos/simplified-long | 10000 | 582.77 ± 0.4% | not timed | not timed | 254.45 ± 0.1% | 28.82 ± 0.1% | not timed | not timed | 583.01 ± 0.2% | | 1.00 | 2.29 | 20.22 |
| 07-unicode-character-data/parse-line | 558784 | 231.81 ± 0.1% | not timed | not timed | 181.16 ± 0.1% | 39.71 ± 12.2% | not timed | not timed | 231.92 ± 1.9% | | 1.00 | 1.28 | 5.84 |
| 08-words/all-english | 56691 | 116.38 ± 0.3% | not timed | not timed | 83.11 ± 0.2% | 11.79 ± 11.1% | not timed | not timed | 116.06 ± 0.7% | | 1.00 | 1.40 | 9.87 |
| 08-words/long-english | 839 | 613.88 ± 0.3% | not timed | not timed | 594.13 ± 0.1% | 32.50 ± 0.2% | not timed | not timed | 614.70 ± 0.1% | | 1.00 | 1.03 | 18.89 |
| 09-aws-keys/full | 0 | 407.30 ± 0.2% | not timed | not timed | 495.59 ± 0.1% | 64.37 ± 3.5% | not timed | not timed | 407.94 ± 0.2% | | 1.00 | 0.82 | 6.33 |
| 09-aws-keys/quick | 0 | 945.19 ± 0.2% | not timed | not timed | 1002.17 ± 0.2% | 413.53 ± 1.5% | not timed | not timed | 945.08 ± 0.3% | | 1.00 | 0.94 | 2.29 |
| 10-bounded-repeat/letters-en | 1833 | 580.02 ± 0.4% | not timed | not timed | 519.33 ± 0.3% | 19.55 ± 0.6% | not timed | not timed | 576.64 ± 1.1% | | 1.01 | 1.12 | 29.67 |
| 10-bounded-repeat/letters-ru | 3475 | 509.50 ± 1.5% | not timed | not timed | 477.73 ± 0.2% | 21.61 ± 18.5% | not timed | not timed | 508.54 ± 0.9% | | 1.00 | 1.07 | 23.58 |
| 10-bounded-repeat/context | 53 | 76.26 ± 0.5% | not timed | not timed | 64.58 ± 0.8% | 19.80 ± 0.2% | not timed | not timed | 76.56 ± 0.4% | | 1.00 | 1.18 | 3.85 |
| 10-bounded-repeat/capitals | 11 | 635.01 ± 8.3% | not timed | not timed | 615.26 ± 0.2% | 36.52 ± 0.1% | not timed | not timed | 634.03 ± 8.5% | | 1.00 | 1.03 | 17.39 |
| 11-unstructured-to-json/extract | 600 | 79.47 ± 0.2% | not timed | not timed | 76.42 ± 0.2% | 49.15 ± 1.7% | not timed | not timed | 81.98 ± 0.9% | | 0.97 | 1.04 | 1.62 |
| 12-dictionary/single | 1 | 559.78 ± 0.7% | not timed | not timed | 560.67 ± 0.0% | 0.40 ± 0.0% | not timed | not timed | 559.62 ± 0.3% | | 1.00 | 1.00 | 1415.48 |
| 14-quadratic/1x | 100 | 21.26 ± 0.8% | not timed | not timed | 10.06 ± 0.1% | 0.98 ± 3.1% | not timed | not timed | 21.14 ± 2.0% | | 1.01 | 2.11 | 21.77 |
| 14-quadratic/2x | 200 | 17.50 ± 0.8% | not timed | not timed | 5.56 ± 0.2% | 0.53 ± 0.8% | not timed | not timed | 17.50 ± 0.7% | | 1.00 | 3.15 | 33.05 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.4% | not timed | not timed | 1.21 ± 0.3% | 0.12 ± 2.2% | not timed | not timed | 7.67 ± 0.2% | | 1.00 | 6.37 | 66.71 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 0.2% | not timed | not timed | 0.34 ± 1.2% | 0.51 ± 3.4% | not timed | not timed | 1.27 ± 2.5% | | 1.00 | 3.80 | 2.48 |
| 04-ruff-noqa/compile-real | 1 | 90.33 ± 0.1% | not timed | not timed | 13.82 ± 0.6% | 127.11 ± 6.7% | not timed | not timed | 90.09 ± 1.1% | | 1.00 | 6.54 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 13.92 ± 1.6% | not timed | not timed | 2.52 ± 0.4% | 5.99 ± 8.4% | not timed | not timed | 13.84 ± 1.4% | | 1.01 | 5.53 | 2.32 |
| 07-unicode-character-data/compile | 1 | 55.43 ± 0.2% | not timed | not timed | 25.99 ± 0.4% | 33.17 ± 3.7% | not timed | not timed | 55.11 ± 1.6% | | 1.01 | 2.13 | 1.67 |
| 09-aws-keys/compile-full | 1 | 41.83 ± 0.3% | not timed | not timed | 8.35 ± 0.7% | 21.77 ± 4.5% | not timed | not timed | 41.62 ± 0.3% | | 1.00 | 5.01 | 1.92 |
| 09-aws-keys/compile-quick | 1 | 187.02 ± 0.2% | not timed | not timed | 47.76 ± 0.2% | 120.64 ± 7.1% | not timed | not timed | 184.45 ± 1.3% | | 1.01 | 3.92 | 1.55 |
| 10-bounded-repeat/compile-context | 1 | 13.68 ± 0.4% | not timed | not timed | 11.21 ± 0.6% | 14.23 ± 7.6% | not timed | not timed | 13.62 ± 2.0% | | 1.00 | 1.22 | 0.96 |
| 10-bounded-repeat/compile-capitals | 1 | 82.70 ± 0.1% | not timed | not timed | 8.08 ± 0.3% | 21.80 ± 3.7% | not timed | not timed | 82.33 ± 1.8% | | 1.00 | 10.24 | 3.79 |
| 11-unstructured-to-json/compile | 1 | 86.61 ± 1.7% | not timed | not timed | 40.13 ± 0.4% | 62.20 ± 2.2% | not timed | not timed | 85.83 ± 1.2% | | 1.01 | 2.16 | 1.39 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.06 ± 1.6% | 0.09 ± 12.3% | not timed | not timed | 0.35 ± 0.8% | | 1.00 | 5.44 | 3.97 |

