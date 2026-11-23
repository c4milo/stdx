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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127322370 |
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
| literal: a word | 217 | 16055.34 ± 3.8% | 1038.80 ± 0.2% | 28.71 ± 0.4% | 17803.74 ± 4.1% | 9168.57 ± 9.1% | 17.47 ± 0.3% | 86.21 ± 0.3% | 16043.03 ± 1.6% | 15.46 | 1.00 | 0.90 | 1.75 |
| literal: a word that is not there | 0 | 18267.97 ± 3.9% | 1048.10 ± 0.1% | 28.80 ± 0.3% | 19387.93 ± 3.6% | 28355.16 ± 3.5% | 17.27 ± 0.1% | 82.15 ± 0.3% | 18284.09 ± 4.2% | 17.43 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6066.19 ± 0.3% | 1021.42 ± 0.1% | 14.74 ± 0.3% | 3941.17 ± 0.3% | 21.86 ± 0.2% | 5.25 ± 0.2% | 6.73 ± 0.2% | 6051.46 ± 0.3% | 5.94 | 1.00 | 1.54 | 277.51 |
| literal: a word in any case | 217 | 12567.56 ± 0.9% | 1039.70 ± 0.1% | 22.01 ± 1.0% | 3977.23 ± 0.2% | 38.05 ± 0.5% | refused | differs | 12562.50 ± 0.6% | 12.09 | 1.00 | 3.16 | 330.27 |
| literal: an href attribute | 33 | 13758.48 ± 1.5% | 1046.86 ± 0.2% | 27.48 ± 0.3% | 16906.37 ± 2.0% | 2262.76 ± 0.1% | 13.33 ± 0.2% | 75.69 ± 0.2% | 13707.93 ± 1.3% | 13.14 | 1.00 | 0.81 | 6.08 |
| literal: a word, second text | 123 | 16309.91 ± 2.4% | 1043.23 ± 0.5% | 28.36 ± 0.3% | 18168.93 ± 2.3% | 7699.76 ± 3.6% | 19.67 ± 0.4% | 69.73 ± 0.2% | 16570.68 ± 1.7% | 15.63 | 0.98 | 0.90 | 2.12 |
| class: two capitalized words | 1331 | 1126.62 ± 0.6% | 977.14 ± 0.2% | 26.17 ± 0.1% | 585.62 ± 0.1% | 40.57 ± 7.5% | 14.83 ± 0.3% | 68.71 ± 0.3% | 1127.91 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.77 |
| class: a word that ends in ing | 3399 | 890.11 ± 0.1% | 890.77 ± 0.1% | 18.25 ± 0.3% | 548.38 ± 0.1% | 29.37 ± 12.0% | 8.19 ± 0.2% | 18.21 ± 0.4% | 888.98 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.31 |
| class: a word in capitals | 2332 | 1450.64 ± 0.2% | 950.42 ± 0.1% | 27.90 ± 0.1% | 572.59 ± 0.1% | 43.60 ± 0.2% | 17.20 ± 0.3% | 82.91 ± 0.4% | 1439.27 ± 0.4% | 1.53 | 1.01 | 2.53 | 33.27 |
| class: a number | 8288 | 1997.53 ± 0.4% | 828.78 ± 0.1% | 28.04 ± 0.3% | 1721.09 ± 0.1% | 40.24 ± 15.6% | 0.56 ± 0.1% | 56.50 ± 0.8% | 1991.35 ± 0.5% | 2.41 | 1.00 | 1.16 | 49.64 |
| class: two capitalized words, second text | 5359 | 737.68 ± 0.2% | 737.17 ± 0.1% | 23.44 ± 0.1% | 484.95 ± 0.1% | 34.08 ± 10.5% | 16.68 ± 0.4% | 63.65 ± 0.3% | 736.61 ± 0.4% | 1.00 | 1.00 | 1.52 | 21.65 |
| other: a word between two words | 6104 | 759.90 ± 0.1% | 763.96 ± 0.1% | 23.68 ± 0.2% | 738.97 ± 0.3% | 108.45 ± 13.3% | 11.29 ± 0.2% | 69.40 ± 0.6% | 756.51 ± 0.1% | 0.99 | 1.00 | 1.03 | 7.01 |
| other: a number before a unit, second text | 1481 | 5545.91 ± 1.0% | 983.72 ± 0.2% | 26.04 ± 0.2% | 5273.17 ± 0.3% | 40.73 ± 11.4% | 17.81 ± 0.3% | 66.94 ± 0.1% | 5527.45 ± 0.6% | 5.64 | 1.00 | 1.05 | 136.15 |
| other: a heading's start tag | 110 | 12441.36 ± 2.8% | 1036.53 ± 0.2% | 27.63 ± 0.4% | 1711.86 ± 0.8% | 1580.59 ± 6.0% | 16.18 ± 0.4% | 88.40 ± 0.8% | 12536.28 ± 2.0% | 12.00 | 0.99 | 7.27 | 7.87 |
| other: a whole word | 217 | 13915.19 ± 0.9% | 1038.48 ± 0.2% | 29.88 ± 0.2% | 14323.12 ± 1.6% | 49.49 ± 0.1% | 13.46 ± 0.2% | 55.82 ± 0.7% | 13851.13 ± 0.6% | 13.40 | 1.00 | 0.97 | 281.19 |
| other: a line's first word, second text | 3716 | 1958.23 ± 0.3% | 873.14 ± 0.2% | 31.34 ± 0.1% | 1588.70 ± 0.7% | 62.70 ± 6.9% | refused | refused | 1950.32 ± 0.4% | 2.24 | 1.00 | 1.23 | 31.23 |
| other: fourteen octets before an x | 87 | 19552.76 ± 1.6% | 215.70 ± 1.7% | 6.14 ± 0.1% | 3894.56 ± 3.0% | 10.63 ± 0.1% | differs | 17.66 ± 0.2% | 19401.66 ± 3.5% | 90.65 | 1.01 | 5.02 | 1838.85 |
| other: a Greek word | 21815 | 470.00 ± 0.6% | 357.85 ± 0.2% | 31.12 ± 0.1% | 289.22 ± 0.4% | 47.81 ± 11.9% | differs | refused | 468.46 ± 0.6% | 1.31 | 1.00 | 1.63 | 9.83 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.1% | 25.88 ± 0.2% | 0.82 ± 0.2% | 19.71 ± 0.2% | 2.77 ± 0.7% | differs | 4.01 ± 0.2% | 25.90 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.34 |
| a UUID | 32895 | 21.08 ± 0.3% | 21.13 ± 0.3% | 0.65 ± 0.3% | 15.14 ± 0.4% | 3.11 ± 0.5% | 0.71 ± 0.5% | 3.61 ± 0.4% | 21.16 ± 0.4% | 1.00 | 1.00 | 1.39 | 6.78 |
| an IPv4 address | 33176 | 37.05 ± 0.1% | 36.93 ± 0.2% | 2.09 ± 0.1% | 28.98 ± 0.1% | 6.66 ± 0.2% | differs | 4.16 ± 0.2% | 37.10 ± 0.3% | 1.00 | 1.00 | 1.28 | 5.57 |
| a date and time | 32954 | 31.03 ± 0.4% | 31.19 ± 0.5% | 1.42 ± 0.3% | 21.13 ± 0.6% | 7.04 ± 0.3% | 1.19 ± 0.2% | 7.03 ± 0.6% | 31.07 ± 0.4% | 0.99 | 1.00 | 1.47 | 4.40 |
| a field path | 32606 | 29.52 ± 0.1% | 29.44 ± 0.2% | 1.01 ± 0.9% | 22.97 ± 0.3% | 3.53 ± 0.7% | differs | 2.91 ± 0.4% | 29.49 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.35 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.4% | 11.46 ± 0.4% | 11.49 ± 0.3% | 11.35 ± 0.1% | 4.94 ± 2.1% | 0.91 ± 0.3% | none | 11.51 ± 0.6% | 1.00 | 1.00 | 1.01 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.68 ± 0.3% | 223.29 ± 0.3% | 259.36 ± 0.4% | 86.93 ± 0.1% | 220.73 ± 1.1% | 487.82 ± 0.2% | 3757.55 ± 0.5% | 222.50 ± 0.4% | 1.00 | 1.00 | 2.56 | 1.01 |
| a UUID | 62 | 146.18 ± 0.2% | 146.39 ± 0.1% | 161.33 ± 0.1% | 45.64 ± 0.1% | 98.01 ± 1.2% | 184.35 ± 1.3% | 4477.27 ± 0.2% | 146.13 ± 0.1% | 1.00 | 1.00 | 3.20 | 1.49 |
| an IPv4 address | 29 | 439.40 ± 0.3% | 443.65 ± 0.5% | 614.16 ± 0.6% | 76.44 ± 0.9% | 130.87 ± 2.0% | 292.93 ± 0.7% | 7716.99 ± 0.4% | 439.34 ± 0.5% | 0.99 | 1.00 | 5.75 | 3.36 |
| a date and time | 56 | 319.33 ± 0.5% | 320.54 ± 0.4% | 401.36 ± 0.1% | 72.03 ± 0.2% | 137.86 ± 1.2% | 322.01 ± 0.8% | 4981.25 ± 0.5% | 319.10 ± 0.3% | 1.00 | 1.00 | 4.43 | 2.32 |
| a field path | 39 | 208.98 ± 0.4% | 209.98 ± 0.5% | 241.60 ± 0.5% | 79.55 ± 0.5% | 207.02 ± 1.5% | 487.07 ± 0.5% | 4860.74 ± 0.4% | 208.97 ± 0.3% | 1.00 | 1.00 | 2.63 | 1.01 |
| literal: a word | 7 | 668.34 ± 0.2% | 717.99 ± 0.3% | 1281.18 ± 0.7% | 504.54 ± 1.7% | 629.50 ± 1.3% | 923.39 ± 0.8% | 30627.57 ± 0.5% | 668.39 ± 0.2% | 0.93 | 1.00 | 1.32 | 1.06 |
| literal: a word that is not there | 8 | 640.23 ± 0.2% | 694.94 ± 0.4% | 1203.42 ± 0.1% | 462.65 ± 0.2% | 601.52 ± 1.7% | 876.13 ± 0.3% | 29645.90 ± 0.2% | 640.03 ± 0.1% | 0.92 | 1.00 | 1.38 | 1.06 |
| literal: one of four words | 26 | 256.01 ± 0.3% | 420.10 ± 0.4% | 567.15 ± 0.4% | 49.41 ± 0.4% | 245.77 ± 1.9% | 355.25 ± 0.3% | 15802.99 ± 0.4% | 256.20 ± 0.2% | 0.61 | 1.00 | 5.18 | 1.04 |
| literal: a word in any case | 11 | 523.69 ± 0.3% | 565.19 ± 0.3% | 870.86 ± 0.4% | 15.79 ± 1.0% | 651.83 ± 2.3% | refused | 23849.63 ± 0.4% | 522.96 ± 0.2% | 0.93 | 1.00 | 33.18 | 0.80 |
| literal: an href attribute | 12 | 351.37 ± 0.4% | 362.95 ± 0.6% | 471.49 ± 0.7% | 44.96 ± 0.7% | 498.03 ± 1.9% | 771.02 ± 2.1% | 22403.44 ± 0.3% | 352.02 ± 0.5% | 0.97 | 1.00 | 7.82 | 0.71 |
| literal: a word, second text | 10 | 593.48 ± 0.1% | 653.32 ± 0.6% | 1092.66 ± 0.0% | 409.92 ± 0.8% | 537.12 ± 1.8% | 799.56 ± 0.5% | 27529.21 ± 0.2% | 593.93 ± 0.2% | 0.91 | 1.00 | 1.45 | 1.10 |
| class: two capitalized words | 23 | 462.17 ± 0.3% | 492.46 ± 0.6% | 709.64 ± 0.3% | 100.82 ± 0.2% | 506.55 ± 1.6% | 744.59 ± 0.7% | 6391.95 ± 0.1% | 462.10 ± 0.4% | 0.94 | 1.00 | 4.58 | 0.91 |
| class: a word that ends in ing | 9 | 599.46 ± 0.4% | 667.36 ± 0.9% | 1171.94 ± 0.1% | 132.87 ± 0.9% | 764.28 ± 1.1% | 1095.49 ± 2.0% | 15988.03 ± 0.1% | 599.09 ± 0.4% | 0.90 | 1.00 | 4.51 | 0.78 |
| class: a word in capitals | 16 | 526.40 ± 0.2% | 566.06 ± 0.5% | 905.13 ± 0.6% | 135.61 ± 0.8% | 755.80 ± 0.8% | 1009.05 ± 0.6% | 8401.07 ± 0.1% | 525.59 ± 0.6% | 0.93 | 1.00 | 3.88 | 0.70 |
| class: a number | 6 | 666.55 ± 0.4% | 728.85 ± 0.5% | 1363.74 ± 0.1% | 41.88 ± 0.4% | 1405.43 ± 0.6% | 1904.16 ± 0.5% | 23182.10 ± 0.5% | 667.46 ± 0.2% | 0.91 | 1.00 | 15.92 | 0.47 |
| class: two capitalized words, second text | 23 | 461.59 ± 0.4% | 491.73 ± 0.7% | 709.49 ± 0.4% | 102.86 ± 0.5% | 507.13 ± 0.3% | 746.03 ± 0.6% | 6391.72 ± 0.1% | 462.18 ± 0.6% | 0.94 | 1.00 | 4.49 | 0.91 |
| other: a word between two words | 13 | 581.59 ± 0.3% | 601.52 ± 0.3% | 958.31 ± 0.1% | 135.98 ± 0.5% | 506.29 ± 1.0% | 812.42 ± 0.4% | 14754.54 ± 0.1% | 581.47 ± 0.4% | 0.97 | 1.00 | 4.28 | 1.15 |
| other: a number before a unit, second text | 15 | 406.12 ± 0.5% | 441.34 ± 0.4% | 609.59 ± 0.1% | 39.25 ± 0.4% | 642.33 ± 1.3% | 888.38 ± 0.7% | 15393.81 ± 0.2% | 405.81 ± 0.4% | 0.92 | 1.00 | 10.35 | 0.63 |
| other: a heading's start tag | 13 | 363.28 ± 0.3% | 367.91 ± 0.1% | 479.68 ± 0.3% | 43.10 ± 0.3% | 632.82 ± 1.0% | 857.63 ± 0.2% | 18572.09 ± 0.2% | 362.97 ± 0.1% | 0.99 | 1.00 | 8.43 | 0.57 |
| other: a whole word | 11 | 614.91 ± 0.5% | 653.68 ± 0.7% | 1085.23 ± 0.7% | 120.87 ± 0.4% | 566.58 ± 1.7% | 827.45 ± 1.1% | 27011.78 ± 1.7% | 615.41 ± 0.4% | 0.94 | 1.00 | 5.09 | 1.09 |
| other: a line's first word, second text | 17 | 560.74 ± 0.3% | 581.67 ± 0.2% | 934.08 ± 0.2% | 127.98 ± 0.1% | 713.58 ± 1.4% | refused | refused | 559.50 ± 0.5% | 0.96 | 1.00 | 4.38 | 0.79 |
| other: fourteen octets before an x | 16 | 113.00 ± 0.3% | 163.03 ± 0.5% | 185.93 ± 0.8% | 15.04 ± 0.4% | 459.18 ± 1.4% | 429.93 ± 0.5% | 13052.40 ± 0.3% | 112.96 ± 0.2% | 0.69 | 1.00 | 7.51 | 0.25 |
| other: a Greek word | 8 | 449.28 ± 0.2% | 591.98 ± 0.4% | 961.42 ± 0.1% | 58.43 ± 0.2% | 1381.58 ± 1.3% | 1786.15 ± 0.4% | refused | 449.48 ± 0.2% | 0.76 | 1.00 | 7.69 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12709.42 ± 0.7% | not timed | not timed | 15853.10 ± 1.3% | 2070.26 ± 15.5% | not timed | not timed | 12730.63 ± 1.5% | | 1.00 | 0.80 | 6.14 |
| 01-literal/sherlock-casei-en | 522 | 3881.63 ± 0.8% | not timed | not timed | 3585.85 ± 0.4% | 32.43 ± 0.6% | not timed | not timed | 3876.46 ± 0.5% | | 1.00 | 1.08 | 119.70 |
| 01-literal/sherlock-ru | 724 | 13589.32 ± 0.4% | not timed | not timed | 17172.47 ± 0.6% | 1418.70 ± 23.6% | not timed | not timed | 13572.01 ± 0.5% | | 1.00 | 0.79 | 9.58 |
| 01-literal/sherlock-casei-ru | 746 | 5232.92 ± 0.2% | not timed | not timed | 3325.68 ± 0.1% | 31.74 ± 0.3% | not timed | not timed | 5243.50 ± 0.1% | | 1.00 | 1.57 | 164.87 |
| 01-literal/sherlock-zh | 30 | 16843.42 ± 0.6% | not timed | not timed | 18236.56 ± 1.3% | 2627.52 ± 23.4% | not timed | not timed | 16813.12 ± 0.4% | | 1.00 | 0.92 | 6.41 |
| 02-literal-alternate/sherlock-en | 714 | 5822.62 ± 0.2% | not timed | not timed | 3944.71 ± 0.4% | 16.62 ± 0.3% | not timed | not timed | 5830.39 ± 0.4% | | 1.00 | 1.48 | 350.31 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1664.52 ± 0.6% | not timed | not timed | 696.69 ± 0.2% | 11.11 ± 12.4% | not timed | not timed | 1661.23 ± 0.6% | | 1.00 | 2.39 | 149.83 |
| 02-literal-alternate/sherlock-ru | 899 | 4639.05 ± 0.1% | not timed | not timed | 3257.13 ± 0.1% | 22.61 ± 0.1% | not timed | not timed | 4646.59 ± 0.3% | | 1.00 | 1.42 | 205.19 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1779.75 ± 0.6% | not timed | not timed | 1229.96 ± 0.2% | 9.16 ± 0.1% | not timed | not timed | 1774.66 ± 0.4% | | 1.00 | 1.45 | 194.34 |
| 02-literal-alternate/sherlock-zh | 207 | 7037.36 ± 0.5% | not timed | not timed | 4162.41 ± 0.2% | 31.52 ± 0.1% | not timed | not timed | 7036.32 ± 0.4% | | 1.00 | 1.69 | 223.23 |
| 03-date/ascii | 111817 | 124.86 ± 0.6% | not timed | not timed | 95.07 ± 0.1% | 0.21 ± 2.3% | not timed | not timed | 124.02 ± 0.3% | | 1.01 | 1.31 | 606.85 |
| 04-ruff-noqa/real | 84 | 555.30 ± 0.1% | not timed | not timed | 457.70 ± 0.1% | 19.58 ± 1.2% | not timed | not timed | 555.83 ± 0.1% | | 1.00 | 1.21 | 28.37 |
| 04-ruff-noqa/tweaked | 44 | 544.60 ± 0.2% | not timed | not timed | 443.42 ± 0.4% | 363.56 ± 0.3% | not timed | not timed | 544.42 ± 0.2% | | 1.00 | 1.23 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.68 ± 0.8% | not timed | not timed | 5.10 ± 0.1% | 0.21 ± 4.9% | not timed | not timed | 3.69 ± 1.7% | | 1.00 | 0.72 | 17.89 |
| 06-cloud-flare-redos/original | 107 | 270.95 ± 0.2% | not timed | not timed | 215.58 ± 0.0% | 24.82 ± 0.1% | not timed | not timed | 269.92 ± 0.3% | | 1.00 | 1.26 | 10.92 |
| 06-cloud-flare-redos/simplified-short | 102 | 266.04 ± 1.0% | not timed | not timed | 228.62 ± 0.1% | 26.77 ± 0.4% | not timed | not timed | 265.33 ± 1.0% | | 1.00 | 1.16 | 9.94 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.41 ± 0.2% | not timed | not timed | 255.75 ± 0.2% | 28.85 ± 0.1% | not timed | not timed | 294.39 ± 0.0% | | 1.00 | 1.15 | 10.21 |
| 07-unicode-character-data/parse-line | 558784 | 239.28 ± 0.9% | not timed | not timed | 169.12 ± 0.3% | 42.99 ± 7.2% | not timed | not timed | 239.71 ± 2.0% | | 1.00 | 1.41 | 5.57 |
| 08-words/all-english | 56691 | 119.68 ± 0.1% | not timed | not timed | 82.86 ± 0.3% | 11.67 ± 3.8% | not timed | not timed | 119.63 ± 0.3% | | 1.00 | 1.44 | 10.26 |
| 08-words/long-english | 839 | 1006.19 ± 0.1% | not timed | not timed | 596.50 ± 0.1% | 32.46 ± 0.7% | not timed | not timed | 1005.24 ± 0.2% | | 1.00 | 1.69 | 31.00 |
| 09-aws-keys/full | 0 | 413.07 ± 0.0% | not timed | not timed | 460.99 ± 0.1% | 64.80 ± 0.1% | not timed | not timed | 412.95 ± 0.1% | | 1.00 | 0.90 | 6.37 |
| 09-aws-keys/quick | 0 | 738.27 ± 0.2% | not timed | not timed | 989.83 ± 0.4% | 425.95 ± 1.0% | not timed | not timed | 735.74 ± 0.0% | | 1.00 | 0.75 | 1.73 |
| 10-bounded-repeat/letters-en | 1833 | 635.32 ± 0.6% | not timed | not timed | 515.44 ± 0.1% | 19.57 ± 0.3% | not timed | not timed | 634.74 ± 0.6% | | 1.00 | 1.23 | 32.47 |
| 10-bounded-repeat/letters-ru | 3475 | 380.37 ± 0.3% | not timed | not timed | 476.92 ± 0.1% | 23.59 ± 4.1% | not timed | not timed | 380.09 ± 0.5% | | 1.00 | 0.80 | 16.12 |
| 10-bounded-repeat/context | 53 | 79.06 ± 0.9% | not timed | not timed | 65.62 ± 0.9% | 19.82 ± 0.2% | not timed | not timed | 79.08 ± 1.1% | | 1.00 | 1.20 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1043.25 ± 0.3% | not timed | not timed | 615.47 ± 0.1% | 36.55 ± 0.2% | not timed | not timed | 1042.77 ± 0.6% | | 1.00 | 1.70 | 28.55 |
| 11-unstructured-to-json/extract | 600 | 47.72 ± 0.4% | not timed | not timed | 77.68 ± 0.3% | 49.23 ± 3.6% | not timed | not timed | 47.00 ± 1.2% | | 1.02 | 0.61 | 0.97 |
| 12-dictionary/single | 1 | 573.33 ± 0.2% | not timed | not timed | 560.33 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 572.12 ± 0.2% | | 1.00 | 1.02 | 1401.03 |
| 14-quadratic/1x | 100 | 13.03 ± 0.1% | not timed | not timed | 10.01 ± 0.3% | 0.99 ± 2.6% | not timed | not timed | 12.88 ± 1.4% | | 1.01 | 1.30 | 13.22 |
| 14-quadratic/2x | 200 | 7.99 ± 1.6% | not timed | not timed | 5.55 ± 0.4% | 0.54 ± 0.6% | not timed | not timed | 7.97 ± 1.2% | | 1.00 | 1.44 | 14.92 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.5% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.53 | 16.14 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.2% | not timed | not timed | 0.34 ± 0.7% | 0.55 ± 3.7% | not timed | not timed | 1.54 ± 0.9% | | 1.01 | 4.52 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 87.24 ± 0.2% | not timed | not timed | 13.84 ± 0.2% | 140.69 ± 1.6% | not timed | not timed | 86.87 ± 1.0% | | 1.00 | 6.30 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.33 ± 0.2% | not timed | not timed | 2.53 ± 0.8% | 6.47 ± 12.5% | not timed | not timed | 14.24 ± 1.4% | | 1.01 | 5.66 | 2.22 |
| 07-unicode-character-data/compile | 1 | 55.39 ± 0.2% | not timed | not timed | 25.85 ± 1.7% | 36.03 ± 5.1% | not timed | not timed | 55.03 ± 0.7% | | 1.01 | 2.14 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.39 ± 0.2% | not timed | not timed | 8.29 ± 0.2% | 23.44 ± 1.0% | not timed | not timed | 42.10 ± 0.6% | | 1.01 | 5.12 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 190.85 ± 0.1% | not timed | not timed | 47.38 ± 0.2% | 134.04 ± 1.9% | not timed | not timed | 191.01 ± 0.9% | | 1.00 | 4.03 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.58 ± 1.0% | not timed | not timed | 11.11 ± 0.1% | 16.07 ± 2.1% | not timed | not timed | 14.55 ± 0.3% | | 1.00 | 1.31 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.15 ± 1.3% | not timed | not timed | 8.07 ± 0.2% | 23.75 ± 1.7% | not timed | not timed | 84.59 ± 1.0% | | 1.01 | 10.55 | 3.58 |
| 11-unstructured-to-json/compile | 1 | 86.86 ± 0.3% | not timed | not timed | 41.13 ± 0.1% | 68.75 ± 2.7% | not timed | not timed | 86.36 ± 0.9% | | 1.01 | 2.11 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.1% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 9.7% | not timed | not timed | 0.35 ± 1.9% | | 1.01 | 5.07 | 3.60 |

