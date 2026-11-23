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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148137098 |
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
| literal: a word | 217 | 16127.24 ± 0.6% | 1039.88 ± 0.2% | 28.52 ± 0.5% | 18238.45 ± 1.2% | 9174.54 ± 9.6% | 17.53 ± 0.2% | 86.83 ± 0.3% | 16127.35 ± 0.9% | 15.51 | 1.00 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18744.44 ± 0.8% | 1048.31 ± 0.2% | 28.66 ± 0.2% | 19839.90 ± 0.9% | 29330.56 ± 0.8% | 17.35 ± 0.2% | 82.71 ± 0.2% | 18757.33 ± 0.7% | 17.88 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6064.20 ± 0.5% | 1023.95 ± 0.2% | 14.67 ± 0.2% | 3950.22 ± 0.2% | 21.84 ± 0.1% | 5.29 ± 0.2% | 6.94 ± 0.2% | 6043.12 ± 0.4% | 5.92 | 1.00 | 1.54 | 277.69 |
| literal: a word in any case | 217 | 12632.88 ± 0.3% | 1040.83 ± 0.1% | 21.45 ± 2.0% | 3965.54 ± 0.1% | 38.02 ± 0.1% | refused | differs | 12639.07 ± 0.5% | 12.14 | 1.00 | 3.19 | 332.26 |
| literal: an href attribute | 33 | 13752.52 ± 0.4% | 1047.03 ± 0.2% | 27.34 ± 0.2% | 17129.62 ± 1.1% | 2262.82 ± 0.8% | 13.34 ± 0.4% | 75.67 ± 0.4% | 13744.58 ± 0.5% | 13.13 | 1.00 | 0.80 | 6.08 |
| literal: a word, second text | 123 | 16372.86 ± 0.7% | 1043.49 ± 0.1% | 28.33 ± 0.2% | 18350.28 ± 1.4% | 7933.43 ± 5.6% | 19.66 ± 0.8% | 69.54 ± 0.7% | 16361.06 ± 0.6% | 15.69 | 1.00 | 0.89 | 2.06 |
| class: two capitalized words | 1331 | 1106.28 ± 0.9% | 977.86 ± 0.1% | 26.16 ± 0.3% | 585.19 ± 0.1% | 40.52 ± 0.8% | 14.89 ± 0.3% | 68.76 ± 0.4% | 1105.82 ± 1.1% | 1.13 | 1.00 | 1.89 | 27.30 |
| class: a word that ends in ing | 3399 | 895.31 ± 0.1% | 895.22 ± 0.1% | 18.04 ± 0.4% | 547.95 ± 0.1% | 29.58 ± 12.6% | 8.23 ± 0.4% | 18.42 ± 0.3% | 893.96 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.26 |
| class: a word in capitals | 2332 | 1455.65 ± 0.3% | 950.99 ± 0.1% | 27.92 ± 0.2% | 572.59 ± 0.2% | 43.49 ± 6.7% | 17.16 ± 0.2% | 83.26 ± 0.3% | 1454.38 ± 0.1% | 1.53 | 1.00 | 2.54 | 33.47 |
| class: a number | 8288 | 1992.70 ± 0.4% | 836.65 ± 0.1% | 28.05 ± 0.1% | 1706.10 ± 0.2% | 43.00 ± 13.5% | 0.55 ± 0.5% | 56.57 ± 0.1% | 1988.22 ± 0.2% | 2.38 | 1.00 | 1.17 | 46.34 |
| class: two capitalized words, second text | 5359 | 744.18 ± 0.3% | 741.91 ± 0.4% | 23.41 ± 0.1% | 484.00 ± 0.1% | 35.33 ± 7.0% | 16.71 ± 0.3% | 63.85 ± 0.0% | 743.16 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.06 |
| other: a word between two words | 6104 | 751.97 ± 0.1% | 777.20 ± 0.1% | 23.56 ± 0.3% | 736.81 ± 0.3% | 108.29 ± 14.7% | 11.31 ± 0.2% | 69.82 ± 0.3% | 748.14 ± 0.1% | 0.97 | 1.01 | 1.02 | 6.94 |
| other: a number before a unit, second text | 1481 | 5431.54 ± 0.5% | 985.12 ± 0.2% | 26.07 ± 0.2% | 5477.58 ± 0.3% | 40.79 ± 0.3% | 17.82 ± 0.1% | 66.84 ± 0.3% | 5427.01 ± 0.5% | 5.51 | 1.00 | 0.99 | 133.16 |
| other: a heading's start tag | 110 | 12590.05 ± 0.4% | 1036.21 ± 0.0% | 27.56 ± 0.1% | 1704.68 ± 0.2% | 1571.91 ± 6.2% | 16.23 ± 0.3% | 89.06 ± 0.3% | 12571.00 ± 0.2% | 12.15 | 1.00 | 7.39 | 8.01 |
| other: a whole word | 217 | 14031.76 ± 0.4% | 1038.93 ± 0.1% | 29.73 ± 0.1% | 14561.43 ± 0.3% | 49.43 ± 0.1% | 13.67 ± 0.2% | 55.95 ± 0.3% | 14092.55 ± 1.2% | 13.51 | 1.00 | 0.96 | 283.86 |
| other: a line's first word, second text | 3716 | 1979.73 ± 0.6% | 877.33 ± 0.1% | 31.08 ± 0.2% | 1719.17 ± 0.5% | 62.20 ± 8.2% | refused | refused | 1963.02 ± 0.5% | 2.26 | 1.01 | 1.15 | 31.83 |
| other: fourteen octets before an x | 87 | 19981.15 ± 1.0% | 236.91 ± 0.9% | 6.59 ± 0.1% | 4029.17 ± 2.4% | 10.61 ± 0.3% | differs | 17.75 ± 0.1% | 20045.71 ± 0.5% | 84.34 | 1.00 | 4.96 | 1882.46 |
| other: a Greek word | 21815 | 514.33 ± 0.4% | 413.20 ± 0.1% | 31.21 ± 0.2% | 289.41 ± 0.3% | 48.72 ± 9.6% | differs | refused | 514.37 ± 0.4% | 1.24 | 1.00 | 1.78 | 10.56 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.81 ± 0.2% | 25.77 ± 0.1% | 0.87 ± 0.4% | 19.76 ± 0.5% | 2.75 ± 1.1% | differs | 4.00 ± 0.3% | 25.84 ± 0.4% | 1.00 | 1.00 | 1.31 | 9.38 |
| a UUID | 32895 | 21.02 ± 0.2% | 21.13 ± 0.1% | 0.65 ± 0.3% | 15.12 ± 0.4% | 3.11 ± 0.6% | 0.72 ± 0.3% | 3.59 ± 0.6% | 21.14 ± 0.3% | 0.99 | 0.99 | 1.39 | 6.75 |
| an IPv4 address | 33176 | 36.86 ± 0.3% | 36.78 ± 0.3% | 2.10 ± 0.7% | 29.02 ± 0.4% | 6.66 ± 0.1% | differs | 4.17 ± 0.1% | 36.88 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.53 |
| a date and time | 32954 | 31.17 ± 0.5% | 31.20 ± 0.6% | 1.47 ± 0.4% | 21.18 ± 0.1% | 7.06 ± 0.0% | 1.19 ± 0.3% | 7.11 ± 0.3% | 31.14 ± 0.2% | 1.00 | 1.00 | 1.47 | 4.42 |
| a field path | 32606 | 29.52 ± 0.1% | 29.42 ± 0.1% | 1.03 ± 0.1% | 23.04 ± 0.1% | 3.49 ± 0.3% | differs | 2.92 ± 0.3% | 29.46 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.45 ± 0.4% | 11.44 ± 0.9% | 11.42 ± 0.6% | 11.48 ± 0.2% | 4.94 ± 1.5% | 0.91 ± 0.2% | none | 11.49 ± 0.7% | 1.00 | 1.00 | 1.00 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 215.82 ± 0.7% | 216.82 ± 0.7% | 251.38 ± 0.2% | 87.22 ± 0.3% | 220.26 ± 1.3% | 484.14 ± 0.4% | 3887.08 ± 0.9% | 215.89 ± 1.0% | 1.00 | 1.00 | 2.47 | 0.98 |
| a UUID | 62 | 142.23 ± 0.4% | 142.37 ± 0.4% | 156.81 ± 0.3% | 45.78 ± 0.2% | 98.60 ± 1.0% | 183.79 ± 1.1% | 4413.54 ± 1.3% | 142.02 ± 0.2% | 1.00 | 1.00 | 3.11 | 1.44 |
| an IPv4 address | 29 | 435.95 ± 0.2% | 439.95 ± 0.4% | 611.40 ± 0.5% | 76.96 ± 0.9% | 130.90 ± 0.4% | 293.98 ± 0.4% | 7671.58 ± 0.3% | 435.88 ± 0.4% | 0.99 | 1.00 | 5.66 | 3.33 |
| a date and time | 56 | 318.57 ± 0.4% | 319.89 ± 0.2% | 400.96 ± 0.3% | 72.57 ± 0.2% | 136.66 ± 1.2% | 320.30 ± 0.7% | 4941.78 ± 0.3% | 318.28 ± 0.2% | 1.00 | 1.00 | 4.39 | 2.33 |
| a field path | 39 | 202.34 ± 0.2% | 202.89 ± 0.3% | 232.94 ± 0.2% | 80.08 ± 0.6% | 205.72 ± 1.3% | 483.06 ± 0.5% | 4965.24 ± 2.0% | 202.50 ± 0.3% | 1.00 | 1.00 | 2.53 | 0.98 |
| literal: a word | 7 | 658.87 ± 0.4% | 712.61 ± 0.3% | 1273.58 ± 0.1% | 513.37 ± 1.7% | 628.76 ± 1.2% | 919.98 ± 0.6% | 31254.32 ± 0.2% | 659.58 ± 0.5% | 0.92 | 1.00 | 1.28 | 1.05 |
| literal: a word that is not there | 8 | 630.40 ± 0.3% | 686.36 ± 0.5% | 1201.52 ± 0.2% | 469.35 ± 0.1% | 604.27 ± 2.5% | 872.59 ± 0.4% | 29462.81 ± 0.1% | 630.55 ± 0.5% | 0.92 | 1.00 | 1.34 | 1.04 |
| literal: one of four words | 26 | 253.84 ± 0.3% | 418.27 ± 0.3% | 564.87 ± 0.3% | 49.59 ± 0.2% | 244.17 ± 2.9% | 354.15 ± 0.7% | 15841.03 ± 0.6% | 253.70 ± 0.2% | 0.61 | 1.00 | 5.12 | 1.04 |
| literal: a word in any case | 11 | 515.77 ± 0.5% | 557.59 ± 0.3% | 861.06 ± 0.6% | 15.82 ± 1.2% | 648.10 ± 2.2% | refused | 23637.38 ± 0.5% | 516.06 ± 0.3% | 0.92 | 1.00 | 32.60 | 0.80 |
| literal: an href attribute | 12 | 349.38 ± 0.3% | 361.01 ± 0.1% | 472.26 ± 0.2% | 45.02 ± 0.3% | 499.63 ± 1.5% | 783.02 ± 2.0% | 22192.51 ± 0.2% | 349.37 ± 0.3% | 0.97 | 1.00 | 7.76 | 0.70 |
| literal: a word, second text | 10 | 587.10 ± 0.4% | 648.34 ± 0.2% | 1086.93 ± 0.1% | 416.70 ± 0.8% | 535.67 ± 1.6% | 800.36 ± 0.3% | 27411.50 ± 0.2% | 587.69 ± 0.3% | 0.91 | 1.00 | 1.41 | 1.10 |
| class: two capitalized words | 23 | 457.03 ± 0.2% | 486.76 ± 0.6% | 704.89 ± 0.3% | 101.92 ± 0.2% | 506.51 ± 1.8% | 740.52 ± 0.3% | 6623.05 ± 0.3% | 457.39 ± 0.2% | 0.94 | 1.00 | 4.48 | 0.90 |
| class: a word that ends in ing | 9 | 593.20 ± 0.6% | 661.83 ± 0.5% | 1163.41 ± 0.1% | 133.81 ± 1.2% | 759.50 ± 9.0% | 1098.32 ± 0.6% | 16312.09 ± 0.2% | 592.66 ± 0.4% | 0.90 | 1.00 | 4.43 | 0.78 |
| class: a word in capitals | 16 | 517.53 ± 0.4% | 555.94 ± 0.4% | 882.00 ± 0.4% | 137.44 ± 0.9% | 751.30 ± 0.2% | 1041.29 ± 0.6% | 8698.94 ± 0.2% | 517.48 ± 0.3% | 0.93 | 1.00 | 3.77 | 0.69 |
| class: a number | 6 | 650.32 ± 0.2% | 712.62 ± 0.2% | 1329.33 ± 0.0% | 41.92 ± 1.0% | 1403.65 ± 1.4% | 1901.25 ± 0.3% | 23067.29 ± 0.1% | 650.76 ± 0.4% | 0.91 | 1.00 | 15.51 | 0.46 |
| class: two capitalized words, second text | 23 | 457.58 ± 0.3% | 486.70 ± 0.9% | 704.87 ± 0.2% | 103.71 ± 0.2% | 505.34 ± 1.8% | 761.21 ± 0.5% | 6619.68 ± 0.8% | 457.62 ± 0.3% | 0.94 | 1.00 | 4.41 | 0.91 |
| other: a word between two words | 13 | 576.80 ± 0.1% | 595.55 ± 0.6% | 950.22 ± 0.6% | 135.77 ± 0.5% | 501.28 ± 1.1% | 813.10 ± 0.3% | 15106.18 ± 0.3% | 575.71 ± 0.4% | 0.97 | 1.00 | 4.25 | 1.15 |
| other: a number before a unit, second text | 15 | 399.16 ± 0.4% | 432.42 ± 0.6% | 595.62 ± 0.3% | 39.66 ± 0.4% | 630.40 ± 1.0% | 886.80 ± 0.3% | 15379.22 ± 0.4% | 399.22 ± 0.2% | 0.92 | 1.00 | 10.07 | 0.63 |
| other: a heading's start tag | 13 | 358.18 ± 0.5% | 362.87 ± 0.5% | 473.77 ± 0.5% | 43.92 ± 1.6% | 627.09 ± 0.7% | 874.44 ± 0.2% | 18469.61 ± 0.4% | 358.31 ± 0.4% | 0.99 | 1.00 | 8.16 | 0.57 |
| other: a whole word | 11 | 610.56 ± 0.4% | 649.16 ± 0.5% | 1086.50 ± 0.3% | 121.86 ± 0.8% | 565.93 ± 1.9% | 824.09 ± 1.0% | 27181.90 ± 0.2% | 610.96 ± 0.6% | 0.94 | 1.00 | 5.01 | 1.08 |
| other: a line's first word, second text | 17 | 552.11 ± 0.2% | 572.37 ± 0.2% | 915.10 ± 0.3% | 128.96 ± 0.2% | 711.41 ± 1.0% | refused | refused | 549.70 ± 0.7% | 0.96 | 1.00 | 4.28 | 0.78 |
| other: fourteen octets before an x | 16 | 112.39 ± 0.7% | 162.34 ± 0.5% | 185.35 ± 0.5% | 15.06 ± 0.6% | 455.12 ± 1.8% | 414.25 ± 1.0% | 12832.75 ± 0.6% | 112.56 ± 0.7% | 0.69 | 1.00 | 7.46 | 0.25 |
| other: a Greek word | 8 | 447.35 ± 0.1% | 586.63 ± 0.4% | 954.78 ± 0.1% | 59.14 ± 0.3% | 1394.36 ± 1.3% | 1766.37 ± 0.5% | refused | 447.48 ± 0.2% | 0.76 | 1.00 | 7.56 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12976.98 ± 0.4% | not timed | not timed | 16520.01 ± 1.1% | 2069.46 ± 16.7% | not timed | not timed | 12928.83 ± 0.2% | | 1.00 | 0.79 | 6.27 |
| 01-literal/sherlock-casei-en | 522 | 4491.67 ± 0.9% | not timed | not timed | 3590.94 ± 0.1% | 32.46 ± 0.5% | not timed | not timed | 4489.52 ± 0.3% | | 1.00 | 1.25 | 138.36 |
| 01-literal/sherlock-ru | 724 | 13544.50 ± 0.8% | not timed | not timed | 17371.68 ± 0.4% | 1420.59 ± 3.1% | not timed | not timed | 13527.34 ± 0.6% | | 1.00 | 0.78 | 9.53 |
| 01-literal/sherlock-casei-ru | 746 | 5293.09 ± 0.1% | not timed | not timed | 3332.05 ± 0.2% | 31.69 ± 0.3% | not timed | not timed | 5296.36 ± 0.1% | | 1.00 | 1.59 | 167.02 |
| 01-literal/sherlock-zh | 30 | 17057.74 ± 0.3% | not timed | not timed | 18755.96 ± 0.9% | 2862.54 ± 19.4% | not timed | not timed | 17108.43 ± 0.4% | | 1.00 | 0.91 | 5.96 |
| 02-literal-alternate/sherlock-en | 714 | 5757.64 ± 0.3% | not timed | not timed | 3942.43 ± 0.1% | 16.62 ± 0.0% | not timed | not timed | 5771.33 ± 0.3% | | 1.00 | 1.46 | 346.42 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.36 ± 1.5% | not timed | not timed | 696.55 ± 0.5% | 11.10 ± 0.8% | not timed | not timed | 1706.14 ± 1.0% | | 1.00 | 2.46 | 154.24 |
| 02-literal-alternate/sherlock-ru | 899 | 4651.68 ± 0.1% | not timed | not timed | 3253.81 ± 0.1% | 22.62 ± 0.2% | not timed | not timed | 4654.03 ± 0.2% | | 1.00 | 1.43 | 205.66 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1815.76 ± 0.5% | not timed | not timed | 1229.67 ± 0.1% | 9.11 ± 0.2% | not timed | not timed | 1808.01 ± 0.2% | | 1.00 | 1.48 | 199.21 |
| 02-literal-alternate/sherlock-zh | 207 | 7045.16 ± 0.6% | not timed | not timed | 4156.80 ± 0.2% | 31.44 ± 0.2% | not timed | not timed | 7053.01 ± 0.2% | | 1.00 | 1.69 | 224.10 |
| 03-date/ascii | 111817 | 127.17 ± 0.2% | not timed | not timed | 93.99 ± 0.1% | 0.20 ± 5.2% | not timed | not timed | 126.72 ± 0.4% | | 1.00 | 1.35 | 627.63 |
| 04-ruff-noqa/real | 84 | 553.61 ± 0.1% | not timed | not timed | 450.75 ± 0.3% | 19.61 ± 1.1% | not timed | not timed | 553.23 ± 0.1% | | 1.00 | 1.23 | 28.23 |
| 04-ruff-noqa/tweaked | 44 | 549.61 ± 0.1% | not timed | not timed | 455.00 ± 0.1% | 366.31 ± 0.3% | not timed | not timed | 548.10 ± 0.1% | | 1.00 | 1.21 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.96 ± 0.6% | not timed | not timed | 5.01 ± 0.2% | 0.20 ± 2.9% | not timed | not timed | 4.06 ± 1.0% | | 0.98 | 0.79 | 19.40 |
| 06-cloud-flare-redos/original | 107 | 264.02 ± 0.2% | not timed | not timed | 216.28 ± 0.1% | 24.92 ± 0.4% | not timed | not timed | 261.42 ± 0.3% | | 1.01 | 1.22 | 10.60 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.20 ± 0.4% | not timed | not timed | 228.52 ± 0.1% | 26.64 ± 0.2% | not timed | not timed | 259.17 ± 0.3% | | 1.00 | 1.13 | 9.73 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.09 ± 0.2% | not timed | not timed | 255.84 ± 0.0% | 28.75 ± 0.2% | not timed | not timed | 286.26 ± 0.2% | | 1.00 | 1.12 | 9.95 |
| 07-unicode-character-data/parse-line | 558784 | 238.71 ± 0.2% | not timed | not timed | 172.21 ± 0.1% | 42.21 ± 6.2% | not timed | not timed | 239.30 ± 2.1% | | 1.00 | 1.39 | 5.66 |
| 08-words/all-english | 56691 | 121.21 ± 0.3% | not timed | not timed | 81.51 ± 0.1% | 12.13 ± 12.7% | not timed | not timed | 120.64 ± 0.3% | | 1.00 | 1.49 | 9.99 |
| 08-words/long-english | 839 | 1006.00 ± 0.1% | not timed | not timed | 597.37 ± 0.3% | 32.53 ± 0.5% | not timed | not timed | 1006.58 ± 0.1% | | 1.00 | 1.68 | 30.93 |
| 09-aws-keys/full | 0 | 408.94 ± 0.1% | not timed | not timed | 464.07 ± 0.1% | 64.49 ± 3.5% | not timed | not timed | 408.42 ± 0.0% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 734.37 ± 0.2% | not timed | not timed | 965.86 ± 0.2% | 421.65 ± 1.0% | not timed | not timed | 733.45 ± 0.1% | | 1.00 | 0.76 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 639.24 ± 0.4% | not timed | not timed | 515.42 ± 0.7% | 19.50 ± 0.4% | not timed | not timed | 637.85 ± 0.2% | | 1.00 | 1.24 | 32.79 |
| 10-bounded-repeat/letters-ru | 3475 | 385.44 ± 0.4% | not timed | not timed | 477.86 ± 0.1% | 21.96 ± 8.7% | not timed | not timed | 383.49 ± 0.5% | | 1.01 | 0.81 | 17.55 |
| 10-bounded-repeat/context | 53 | 79.03 ± 0.9% | not timed | not timed | 65.99 ± 0.6% | 19.83 ± 0.2% | not timed | not timed | 79.10 ± 1.1% | | 1.00 | 1.20 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1040.98 ± 0.2% | not timed | not timed | 615.61 ± 0.0% | 36.34 ± 0.1% | not timed | not timed | 1041.23 ± 0.2% | | 1.00 | 1.69 | 28.64 |
| 11-unstructured-to-json/extract | 600 | 49.80 ± 0.2% | not timed | not timed | 77.59 ± 0.1% | 48.97 ± 0.9% | not timed | not timed | 49.54 ± 1.0% | | 1.01 | 0.64 | 1.02 |
| 12-dictionary/single | 1 | 566.98 ± 0.6% | not timed | not timed | 556.20 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 566.63 ± 0.1% | | 1.00 | 1.02 | 1400.40 |
| 14-quadratic/1x | 100 | 9.66 ± 0.6% | not timed | not timed | 9.98 ± 0.4% | 0.98 ± 3.8% | not timed | not timed | 9.67 ± 1.3% | | 1.00 | 0.97 | 9.88 |
| 14-quadratic/2x | 200 | 5.57 ± 0.3% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 0.4% | not timed | not timed | 5.56 ± 0.9% | | 1.00 | 1.01 | 10.46 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.6% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.8% | not timed | not timed | 1.26 ± 1.3% | | 1.00 | 1.04 | 10.92 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.35 ± 0.5% | 0.56 ± 16.3% | not timed | not timed | 1.53 ± 0.9% | | 1.01 | 4.47 | 2.77 |
| 04-ruff-noqa/compile-real | 1 | 85.35 ± 0.2% | not timed | not timed | 13.82 ± 0.1% | 139.65 ± 14.7% | not timed | not timed | 84.44 ± 0.6% | | 1.01 | 6.18 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.51 ± 0.2% | not timed | not timed | 2.55 ± 0.8% | 6.50 ± 5.1% | not timed | not timed | 14.46 ± 0.5% | | 1.00 | 5.69 | 2.23 |
| 07-unicode-character-data/compile | 1 | 55.02 ± 0.1% | not timed | not timed | 26.03 ± 0.2% | 36.30 ± 3.8% | not timed | not timed | 54.93 ± 0.7% | | 1.00 | 2.11 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.27 ± 1.3% | not timed | not timed | 8.32 ± 0.2% | 23.46 ± 0.9% | not timed | not timed | 42.19 ± 1.0% | | 1.00 | 5.08 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 188.76 ± 0.3% | not timed | not timed | 46.33 ± 0.1% | 134.72 ± 2.9% | not timed | not timed | 188.55 ± 0.7% | | 1.00 | 4.07 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.59 ± 0.8% | not timed | not timed | 11.21 ± 0.2% | 16.11 ± 3.4% | not timed | not timed | 14.47 ± 0.9% | | 1.01 | 1.30 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.23 ± 0.5% | not timed | not timed | 8.09 ± 0.2% | 24.02 ± 1.1% | not timed | not timed | 84.14 ± 0.9% | | 1.01 | 10.53 | 3.55 |
| 11-unstructured-to-json/compile | 1 | 86.34 ± 0.3% | not timed | not timed | 40.94 ± 0.3% | 68.60 ± 1.7% | not timed | not timed | 85.35 ± 1.1% | | 1.01 | 2.11 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 36.0% | 0.10 ± 18.3% | not timed | not timed | 0.36 ± 1.7% | | 1.01 | 5.21 | 3.65 |

