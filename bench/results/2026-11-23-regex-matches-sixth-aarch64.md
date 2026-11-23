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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127337678 |
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
| literal: a word | 217 | 15983.49 ± 1.2% | 1039.15 ± 0.1% | 28.68 ± 0.5% | 18124.83 ± 1.2% | 9189.01 ± 8.5% | 17.42 ± 0.3% | 86.21 ± 0.2% | 15946.29 ± 2.1% | 15.38 | 1.00 | 0.88 | 1.74 |
| literal: a word that is not there | 0 | 18630.54 ± 3.5% | 1048.04 ± 0.1% | 28.77 ± 0.4% | 19759.04 ± 2.8% | 29219.40 ± 1.8% | 17.26 ± 0.2% | 82.18 ± 0.4% | 18691.07 ± 2.5% | 17.78 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6055.28 ± 0.5% | 1021.25 ± 0.1% | 14.75 ± 0.1% | 3943.39 ± 0.3% | 21.85 ± 0.1% | 5.25 ± 0.1% | 6.56 ± 0.1% | 6036.81 ± 0.1% | 5.93 | 1.00 | 1.54 | 277.18 |
| literal: a word in any case | 217 | 12592.39 ± 0.6% | 1039.10 ± 0.2% | 21.52 ± 2.6% | 3977.40 ± 0.3% | 38.05 ± 0.1% | refused | differs | 12587.57 ± 0.4% | 12.12 | 1.00 | 3.17 | 330.95 |
| literal: an href attribute | 33 | 13615.01 ± 1.4% | 1045.97 ± 0.2% | 27.50 ± 0.1% | 16757.73 ± 1.1% | 2261.25 ± 1.5% | 13.32 ± 0.4% | 75.63 ± 0.4% | 13634.08 ± 0.6% | 13.02 | 1.00 | 0.81 | 6.02 |
| literal: a word, second text | 123 | 16230.40 ± 0.6% | 1042.76 ± 0.1% | 28.33 ± 0.2% | 18155.11 ± 1.6% | 7651.28 ± 3.1% | 19.58 ± 0.6% | 69.82 ± 0.3% | 16229.37 ± 0.3% | 15.56 | 1.00 | 0.89 | 2.12 |
| class: two capitalized words | 1331 | 1127.72 ± 0.4% | 977.64 ± 0.1% | 26.15 ± 0.3% | 585.64 ± 0.1% | 40.53 ± 6.2% | 14.83 ± 0.4% | 68.50 ± 0.4% | 1126.71 ± 0.8% | 1.15 | 1.00 | 1.93 | 27.82 |
| class: a word that ends in ing | 3399 | 890.44 ± 0.3% | 890.88 ± 0.1% | 18.25 ± 0.2% | 547.72 ± 0.1% | 29.55 ± 10.5% | 8.19 ± 0.2% | 18.18 ± 1.5% | 888.74 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.14 |
| class: a word in capitals | 2332 | 1452.04 ± 0.7% | 949.56 ± 0.5% | 27.83 ± 0.3% | 572.39 ± 0.7% | 43.49 ± 3.0% | 17.18 ± 0.3% | 82.95 ± 0.4% | 1451.99 ± 0.2% | 1.53 | 1.00 | 2.54 | 33.39 |
| class: a number | 8288 | 1998.18 ± 0.6% | 828.36 ± 0.1% | 28.02 ± 0.3% | 1718.79 ± 0.3% | 41.13 ± 16.5% | 0.55 ± 0.5% | 56.65 ± 0.1% | 1983.76 ± 0.4% | 2.41 | 1.01 | 1.16 | 48.59 |
| class: two capitalized words, second text | 5359 | 738.08 ± 0.0% | 737.27 ± 0.1% | 23.44 ± 0.1% | 485.01 ± 0.1% | 32.75 ± 8.0% | 16.64 ± 0.3% | 63.63 ± 0.2% | 736.75 ± 0.1% | 1.00 | 1.00 | 1.52 | 22.53 |
| other: a word between two words | 6104 | 759.75 ± 0.6% | 763.16 ± 0.2% | 23.67 ± 0.2% | 738.78 ± 0.2% | 111.74 ± 12.2% | 11.28 ± 0.3% | 69.36 ± 1.1% | 756.12 ± 0.1% | 1.00 | 1.00 | 1.03 | 6.80 |
| other: a number before a unit, second text | 1481 | 5523.69 ± 0.5% | 982.77 ± 0.2% | 25.97 ± 0.2% | 5633.53 ± 0.3% | 40.77 ± 4.1% | 17.82 ± 0.3% | 66.79 ± 0.9% | 5500.23 ± 0.5% | 5.62 | 1.00 | 0.98 | 135.47 |
| other: a heading's start tag | 110 | 12500.00 ± 1.8% | 1036.24 ± 0.1% | 27.56 ± 0.2% | 1714.23 ± 0.3% | 1578.84 ± 6.1% | 16.15 ± 0.2% | 88.50 ± 0.3% | 12502.90 ± 1.2% | 12.06 | 1.00 | 7.29 | 7.92 |
| other: a whole word | 217 | 13851.98 ± 1.4% | 1038.57 ± 0.2% | 29.81 ± 0.2% | 14457.36 ± 0.8% | 49.29 ± 0.4% | 13.48 ± 0.2% | 55.80 ± 0.4% | 13841.13 ± 1.4% | 13.34 | 1.00 | 0.96 | 281.02 |
| other: a line's first word, second text | 3716 | 1959.34 ± 0.3% | 873.38 ± 0.1% | 31.31 ± 0.2% | 1723.62 ± 0.4% | 62.33 ± 6.9% | refused | refused | 1949.27 ± 1.0% | 2.24 | 1.01 | 1.14 | 31.43 |
| other: fourteen octets before an x | 87 | 19464.75 ± 2.0% | 237.09 ± 0.6% | 6.14 ± 0.1% | 4011.63 ± 0.4% | 10.61 ± 0.1% | differs | 17.67 ± 0.1% | 19445.96 ± 0.6% | 82.10 | 1.00 | 4.85 | 1835.04 |
| other: a Greek word | 21815 | 470.94 ± 0.8% | 357.89 ± 0.3% | 31.11 ± 0.1% | 289.54 ± 0.2% | 47.53 ± 10.2% | differs | refused | 468.75 ± 0.6% | 1.32 | 1.00 | 1.63 | 9.91 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.1% | 25.87 ± 0.3% | 0.82 ± 0.4% | 19.68 ± 0.4% | 2.77 ± 0.3% | differs | 4.02 ± 0.2% | 25.85 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.33 |
| a UUID | 32895 | 21.06 ± 0.2% | 21.11 ± 0.1% | 0.65 ± 0.2% | 15.13 ± 0.3% | 3.11 ± 0.4% | 0.72 ± 0.2% | 3.61 ± 0.7% | 21.13 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.77 |
| an IPv4 address | 33176 | 36.97 ± 0.2% | 36.83 ± 0.3% | 2.09 ± 0.1% | 29.27 ± 0.3% | 6.66 ± 0.3% | differs | 4.15 ± 0.2% | 36.99 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.55 |
| a date and time | 32954 | 30.97 ± 0.6% | 31.10 ± 0.3% | 1.41 ± 0.5% | 21.46 ± 0.2% | 7.05 ± 0.1% | 1.19 ± 0.3% | 6.80 ± 0.4% | 30.96 ± 0.7% | 1.00 | 1.00 | 1.44 | 4.39 |
| a field path | 32606 | 29.49 ± 0.3% | 29.44 ± 0.4% | 1.01 ± 0.7% | 23.06 ± 0.2% | 3.49 ± 1.3% | differs | 2.91 ± 0.3% | 29.49 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.3% | 11.47 ± 0.4% | 11.50 ± 0.4% | 11.32 ± 0.2% | 4.89 ± 2.2% | 0.91 ± 0.8% | none | 11.51 ± 0.2% | 1.00 | 1.00 | 1.02 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.42 ± 0.6% | 223.04 ± 0.4% | 259.10 ± 0.4% | 87.05 ± 0.7% | 212.19 ± 2.1% | 481.34 ± 0.4% | 3750.12 ± 0.5% | 222.50 ± 0.5% | 1.00 | 1.00 | 2.56 | 1.05 |
| a UUID | 62 | 146.05 ± 0.4% | 146.21 ± 0.2% | 161.37 ± 0.1% | 45.80 ± 1.0% | 95.44 ± 1.5% | 186.23 ± 1.8% | 4473.49 ± 0.5% | 145.92 ± 0.3% | 1.00 | 1.00 | 3.19 | 1.53 |
| an IPv4 address | 29 | 439.45 ± 0.4% | 442.78 ± 0.6% | 614.29 ± 0.6% | 78.13 ± 0.2% | 127.18 ± 0.9% | 297.68 ± 0.5% | 7720.20 ± 0.5% | 439.77 ± 0.5% | 0.99 | 1.00 | 5.62 | 3.46 |
| a date and time | 56 | 318.98 ± 0.3% | 320.18 ± 0.3% | 400.80 ± 0.3% | 73.26 ± 0.5% | 132.00 ± 3.5% | 329.66 ± 3.2% | 4988.43 ± 0.4% | 319.07 ± 0.6% | 1.00 | 1.00 | 4.35 | 2.42 |
| a field path | 39 | 209.03 ± 0.5% | 209.78 ± 0.4% | 241.65 ± 0.2% | 80.95 ± 1.2% | 196.02 ± 1.4% | 500.13 ± 1.4% | 4854.47 ± 2.7% | 208.99 ± 0.4% | 1.00 | 1.00 | 2.58 | 1.07 |
| literal: a word | 7 | 668.33 ± 0.5% | 717.14 ± 0.6% | 1281.85 ± 0.7% | 491.66 ± 0.2% | 611.55 ± 2.4% | 954.94 ± 0.6% | 30536.32 ± 0.1% | 668.44 ± 0.2% | 0.93 | 1.00 | 1.36 | 1.09 |
| literal: a word that is not there | 8 | 640.39 ± 0.2% | 694.34 ± 0.3% | 1204.25 ± 0.1% | 451.13 ± 0.3% | 583.49 ± 1.0% | 902.50 ± 0.8% | 29434.00 ± 0.2% | 640.14 ± 0.3% | 0.92 | 1.00 | 1.42 | 1.10 |
| literal: one of four words | 26 | 256.17 ± 0.4% | 419.90 ± 0.3% | 566.91 ± 0.5% | 50.59 ± 0.4% | 232.69 ± 7.9% | 373.24 ± 1.9% | 15776.82 ± 0.2% | 256.25 ± 0.1% | 0.61 | 1.00 | 5.06 | 1.10 |
| literal: a word in any case | 11 | 524.04 ± 0.4% | 565.16 ± 0.4% | 870.59 ± 0.2% | 15.68 ± 0.2% | 628.71 ± 1.5% | refused | 23839.07 ± 0.5% | 524.22 ± 0.2% | 0.93 | 1.00 | 33.42 | 0.83 |
| literal: an href attribute | 12 | 351.24 ± 0.3% | 363.26 ± 0.6% | 471.47 ± 0.6% | 45.45 ± 1.0% | 482.24 ± 2.7% | 779.50 ± 0.8% | 22401.88 ± 0.2% | 351.11 ± 0.4% | 0.97 | 1.00 | 7.73 | 0.73 |
| literal: a word, second text | 10 | 593.72 ± 0.5% | 654.75 ± 0.2% | 1093.04 ± 0.2% | 406.90 ± 0.4% | 521.08 ± 2.3% | 805.70 ± 0.4% | 27387.09 ± 0.2% | 594.26 ± 0.5% | 0.91 | 1.00 | 1.46 | 1.14 |
| class: two capitalized words | 23 | 461.97 ± 0.2% | 491.03 ± 0.2% | 709.27 ± 0.3% | 102.22 ± 0.8% | 490.54 ± 1.5% | 754.94 ± 0.8% | 6391.59 ± 0.1% | 462.03 ± 0.2% | 0.94 | 1.00 | 4.52 | 0.94 |
| class: a word that ends in ing | 9 | 601.22 ± 0.4% | 666.30 ± 0.2% | 1170.41 ± 0.2% | 131.70 ± 1.3% | 742.11 ± 1.9% | 1115.72 ± 2.1% | 15992.68 ± 0.2% | 600.48 ± 0.2% | 0.90 | 1.00 | 4.56 | 0.81 |
| class: a word in capitals | 16 | 524.85 ± 0.3% | 565.52 ± 0.8% | 902.26 ± 0.6% | 135.54 ± 1.5% | 730.96 ± 1.6% | 1002.64 ± 0.6% | 8404.47 ± 0.1% | 525.71 ± 0.6% | 0.93 | 1.00 | 3.87 | 0.72 |
| class: a number | 6 | 668.16 ± 0.4% | 730.06 ± 0.5% | 1364.79 ± 0.1% | 41.77 ± 0.9% | 1377.75 ± 2.2% | 1861.98 ± 1.3% | 23283.45 ± 0.1% | 668.17 ± 0.2% | 0.92 | 1.00 | 16.00 | 0.48 |
| class: two capitalized words, second text | 23 | 462.28 ± 0.3% | 491.65 ± 0.7% | 708.74 ± 0.4% | 101.27 ± 0.1% | 490.89 ± 5.5% | 768.27 ± 0.3% | 6396.68 ± 0.2% | 462.35 ± 0.3% | 0.94 | 1.00 | 4.56 | 0.94 |
| other: a word between two words | 13 | 582.21 ± 0.3% | 600.84 ± 0.4% | 957.26 ± 0.1% | 133.18 ± 0.2% | 487.46 ± 1.4% | 810.87 ± 0.6% | 14733.11 ± 0.2% | 581.27 ± 0.4% | 0.97 | 1.00 | 4.37 | 1.19 |
| other: a number before a unit, second text | 15 | 405.68 ± 0.3% | 441.54 ± 0.3% | 609.91 ± 0.6% | 39.35 ± 0.9% | 613.95 ± 2.0% | 886.64 ± 1.0% | 15415.62 ± 0.1% | 406.27 ± 0.4% | 0.92 | 1.00 | 10.31 | 0.66 |
| other: a heading's start tag | 13 | 363.12 ± 0.4% | 367.69 ± 0.4% | 478.83 ± 0.6% | 43.60 ± 0.4% | 614.02 ± 0.6% | 877.87 ± 0.5% | 18588.66 ± 0.2% | 362.81 ± 0.4% | 0.99 | 1.00 | 8.33 | 0.59 |
| other: a whole word | 11 | 613.04 ± 0.5% | 652.97 ± 0.4% | 1085.91 ± 0.1% | 118.15 ± 0.6% | 553.24 ± 3.4% | 833.43 ± 0.8% | 27003.76 ± 0.3% | 614.25 ± 0.5% | 0.94 | 1.00 | 5.19 | 1.11 |
| other: a line's first word, second text | 17 | 560.26 ± 0.4% | 581.96 ± 0.3% | 934.18 ± 0.1% | 129.87 ± 0.2% | 698.43 ± 0.9% | refused | refused | 558.64 ± 1.0% | 0.96 | 1.00 | 4.31 | 0.80 |
| other: fourteen octets before an x | 16 | 113.03 ± 0.5% | 162.65 ± 1.0% | 186.05 ± 0.9% | 15.23 ± 0.4% | 441.85 ± 1.5% | 417.34 ± 0.4% | 13067.25 ± 0.2% | 113.12 ± 0.1% | 0.69 | 1.00 | 7.42 | 0.26 |
| other: a Greek word | 8 | 450.28 ± 0.1% | 592.01 ± 0.3% | 961.88 ± 0.1% | 58.96 ± 0.2% | 1360.29 ± 2.7% | 1822.29 ± 0.6% | refused | 450.14 ± 0.2% | 0.76 | 1.00 | 7.64 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12760.95 ± 0.9% | not timed | not timed | 16045.76 ± 1.2% | 2082.68 ± 20.5% | not timed | not timed | 12797.64 ± 1.1% | | 1.00 | 0.80 | 6.13 |
| 01-literal/sherlock-casei-en | 522 | 3886.62 ± 0.4% | not timed | not timed | 3587.96 ± 0.2% | 32.53 ± 0.7% | not timed | not timed | 3878.58 ± 1.8% | | 1.00 | 1.08 | 119.48 |
| 01-literal/sherlock-ru | 724 | 13588.42 ± 7.8% | not timed | not timed | 17237.28 ± 11.4% | 1392.04 ± 24.1% | not timed | not timed | 13523.17 ± 4.7% | | 1.00 | 0.79 | 9.76 |
| 01-literal/sherlock-casei-ru | 746 | 5239.10 ± 0.5% | not timed | not timed | 3328.77 ± 0.1% | 31.78 ± 0.1% | not timed | not timed | 5242.34 ± 0.3% | | 1.00 | 1.57 | 164.88 |
| 01-literal/sherlock-zh | 30 | 16922.32 ± 1.1% | not timed | not timed | 18410.96 ± 0.7% | 2840.79 ± 18.4% | not timed | not timed | 16942.14 ± 1.2% | | 1.00 | 0.92 | 5.96 |
| 02-literal-alternate/sherlock-en | 714 | 5801.70 ± 0.7% | not timed | not timed | 3936.07 ± 0.3% | 16.02 ± 0.1% | not timed | not timed | 5817.45 ± 0.3% | | 1.00 | 1.47 | 362.21 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1669.64 ± 1.2% | not timed | not timed | 697.42 ± 0.2% | 11.11 ± 0.4% | not timed | not timed | 1661.90 ± 0.2% | | 1.00 | 2.39 | 150.22 |
| 02-literal-alternate/sherlock-ru | 899 | 4647.63 ± 0.1% | not timed | not timed | 3251.62 ± 0.1% | 22.58 ± 0.0% | not timed | not timed | 4641.76 ± 0.0% | | 1.00 | 1.43 | 205.85 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1778.13 ± 0.4% | not timed | not timed | 1226.93 ± 0.1% | 9.16 ± 1.2% | not timed | not timed | 1773.92 ± 0.4% | | 1.00 | 1.45 | 194.12 |
| 02-literal-alternate/sherlock-zh | 207 | 7067.49 ± 0.3% | not timed | not timed | 4155.32 ± 0.4% | 31.44 ± 0.1% | not timed | not timed | 7065.50 ± 0.2% | | 1.00 | 1.70 | 224.80 |
| 03-date/ascii | 111817 | 124.74 ± 0.8% | not timed | not timed | 96.34 ± 0.1% | 0.20 ± 3.1% | not timed | not timed | 123.21 ± 0.4% | | 1.01 | 1.29 | 616.37 |
| 04-ruff-noqa/real | 84 | 554.96 ± 0.0% | not timed | not timed | 461.35 ± 0.1% | 19.67 ± 1.3% | not timed | not timed | 555.32 ± 0.2% | | 1.00 | 1.20 | 28.21 |
| 04-ruff-noqa/tweaked | 44 | 544.78 ± 0.3% | not timed | not timed | 460.52 ± 0.1% | 362.74 ± 1.2% | not timed | not timed | 544.16 ± 0.2% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.3% | not timed | not timed | 5.09 ± 0.1% | 0.21 ± 2.5% | not timed | not timed | 3.68 ± 2.9% | | 1.00 | 0.72 | 17.73 |
| 06-cloud-flare-redos/original | 107 | 269.28 ± 2.2% | not timed | not timed | 211.00 ± 0.3% | 24.87 ± 2.9% | not timed | not timed | 269.18 ± 18.6% | | 1.00 | 1.28 | 10.83 |
| 06-cloud-flare-redos/simplified-short | 102 | 263.85 ± 0.5% | not timed | not timed | 228.93 ± 1.4% | 26.64 ± 7.2% | not timed | not timed | 263.62 ± 8.3% | | 1.00 | 1.15 | 9.90 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.25 ± 0.3% | not timed | not timed | 255.65 ± 0.2% | 28.84 ± 0.4% | not timed | not timed | 294.26 ± 0.2% | | 1.00 | 1.15 | 10.20 |
| 07-unicode-character-data/parse-line | 558784 | 239.27 ± 0.5% | not timed | not timed | 168.91 ± 0.1% | 42.00 ± 5.8% | not timed | not timed | 240.04 ± 0.7% | | 1.00 | 1.42 | 5.70 |
| 08-words/all-english | 56691 | 119.51 ± 0.1% | not timed | not timed | 83.08 ± 0.1% | 12.66 ± 6.2% | not timed | not timed | 119.31 ± 0.5% | | 1.00 | 1.44 | 9.44 |
| 08-words/long-english | 839 | 1005.45 ± 0.1% | not timed | not timed | 597.89 ± 0.1% | 32.25 ± 1.4% | not timed | not timed | 1005.47 ± 0.1% | | 1.00 | 1.68 | 31.17 |
| 09-aws-keys/full | 0 | 413.13 ± 0.0% | not timed | not timed | 461.49 ± 0.2% | 64.45 ± 3.4% | not timed | not timed | 413.02 ± 0.1% | | 1.00 | 0.90 | 6.41 |
| 09-aws-keys/quick | 0 | 737.93 ± 0.1% | not timed | not timed | 994.40 ± 0.5% | 417.73 ± 0.7% | not timed | not timed | 735.25 ± 0.1% | | 1.00 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 636.30 ± 0.7% | not timed | not timed | 518.40 ± 0.8% | 19.50 ± 0.6% | not timed | not timed | 634.29 ± 0.1% | | 1.00 | 1.23 | 32.63 |
| 10-bounded-repeat/letters-ru | 3475 | 379.97 ± 0.2% | not timed | not timed | 478.33 ± 0.0% | 21.83 ± 8.1% | not timed | not timed | 379.28 ± 1.5% | | 1.00 | 0.79 | 17.41 |
| 10-bounded-repeat/context | 53 | 78.93 ± 0.9% | not timed | not timed | 65.24 ± 1.1% | 19.82 ± 0.2% | not timed | not timed | 78.78 ± 1.1% | | 1.00 | 1.21 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 1044.54 ± 0.0% | not timed | not timed | 618.41 ± 0.0% | 36.53 ± 0.2% | not timed | not timed | 1044.17 ± 0.1% | | 1.00 | 1.69 | 28.60 |
| 11-unstructured-to-json/extract | 600 | 43.93 ± 0.1% | not timed | not timed | 77.25 ± 0.2% | 48.88 ± 0.4% | not timed | not timed | 43.79 ± 0.6% | | 1.00 | 0.57 | 0.90 |
| 12-dictionary/single | 1 | 571.86 ± 0.1% | not timed | not timed | 561.89 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 572.29 ± 0.1% | | 1.00 | 1.02 | 1414.21 |
| 14-quadratic/1x | 100 | 13.05 ± 0.4% | not timed | not timed | 10.04 ± 0.1% | 0.97 ± 3.8% | not timed | not timed | 13.00 ± 1.4% | | 1.00 | 1.30 | 13.47 |
| 14-quadratic/2x | 200 | 7.99 ± 0.1% | not timed | not timed | 5.53 ± 0.3% | 0.53 ± 1.6% | not timed | not timed | 7.92 ± 1.5% | | 1.01 | 1.44 | 14.99 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.4% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.6% | not timed | not timed | 1.86 ± 0.2% | | 1.00 | 1.53 | 16.04 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.1% | not timed | not timed | 0.34 ± 0.1% | 0.54 ± 6.3% | not timed | not timed | 1.54 ± 0.4% | | 1.00 | 4.50 | 2.89 |
| 04-ruff-noqa/compile-real | 1 | 87.26 ± 0.2% | not timed | not timed | 13.89 ± 0.3% | 131.83 ± 1.9% | not timed | not timed | 86.88 ± 0.9% | | 1.00 | 6.28 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.32 ± 1.7% | not timed | not timed | 2.51 ± 0.3% | 6.30 ± 3.0% | not timed | not timed | 14.28 ± 0.8% | | 1.00 | 5.70 | 2.27 |
| 07-unicode-character-data/compile | 1 | 55.34 ± 0.3% | not timed | not timed | 25.97 ± 0.3% | 34.90 ± 1.8% | not timed | not timed | 55.11 ± 0.4% | | 1.00 | 2.13 | 1.59 |
| 09-aws-keys/compile-full | 1 | 42.33 ± 0.2% | not timed | not timed | 8.27 ± 0.3% | 22.55 ± 1.7% | not timed | not timed | 42.16 ± 0.6% | | 1.00 | 5.12 | 1.88 |
| 09-aws-keys/compile-quick | 1 | 190.66 ± 0.2% | not timed | not timed | 47.49 ± 0.1% | 129.98 ± 3.2% | not timed | not timed | 190.97 ± 0.4% | | 1.00 | 4.01 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 1.3% | not timed | not timed | 11.16 ± 0.2% | 15.06 ± 3.6% | not timed | not timed | 14.64 ± 1.1% | | 1.00 | 1.31 | 0.97 |
| 10-bounded-repeat/compile-capitals | 1 | 85.28 ± 0.3% | not timed | not timed | 8.10 ± 0.4% | 23.21 ± 3.3% | not timed | not timed | 85.00 ± 1.0% | | 1.00 | 10.54 | 3.67 |
| 11-unstructured-to-json/compile | 1 | 86.78 ± 0.2% | not timed | not timed | 40.81 ± 0.5% | 65.16 ± 3.2% | not timed | not timed | 86.59 ± 0.4% | | 1.00 | 2.13 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 12.1% | 0.09 ± 8.1% | not timed | not timed | 0.35 ± 2.3% | | 1.01 | 5.32 | 3.83 |

