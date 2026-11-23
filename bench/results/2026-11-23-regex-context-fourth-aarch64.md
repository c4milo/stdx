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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117644739 |
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
| literal: a word | 217 | 16095.80 ± 2.0% | 1037.02 ± 0.1% | 27.81 ± 0.2% | 18194.15 ± 0.8% | 9194.71 ± 7.4% | 16.35 ± 0.2% | 86.36 ± 0.3% | 16164.25 ± 2.1% | 15.52 | 1.00 | 0.88 | 1.75 |
| literal: a word that is not there | 0 | 18800.36 ± 0.6% | 1048.60 ± 0.1% | 27.78 ± 0.2% | 19755.66 ± 1.0% | 29123.70 ± 1.3% | 16.04 ± 0.3% | 82.20 ± 0.2% | 18879.24 ± 0.5% | 17.93 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6053.79 ± 0.9% | 1014.39 ± 0.1% | 14.42 ± 0.5% | 3929.73 ± 0.4% | 21.85 ± 0.1% | 4.86 ± 0.1% | 6.92 ± 0.5% | 6064.75 ± 0.6% | 5.97 | 1.00 | 1.54 | 277.07 |
| literal: a word in any case | 217 | 12598.88 ± 0.5% | 1038.15 ± 0.1% | 21.26 ± 0.5% | 3975.30 ± 0.1% | 38.08 ± 0.1% | refused | differs | 12583.97 ± 0.6% | 12.14 | 1.00 | 3.17 | 330.86 |
| literal: an href attribute | 33 | 13874.43 ± 0.8% | 1045.62 ± 0.1% | 26.79 ± 0.3% | 17200.95 ± 1.0% | 2250.36 ± 0.5% | 12.13 ± 0.3% | 75.07 ± 0.4% | 13877.70 ± 0.8% | 13.27 | 1.00 | 0.81 | 6.17 |
| literal: a word, second text | 123 | 16572.79 ± 1.5% | 1041.88 ± 0.1% | 27.55 ± 0.4% | 18434.40 ± 1.1% | 7888.39 ± 6.3% | 20.07 ± 0.9% | 70.24 ± 0.6% | 16679.21 ± 1.5% | 15.91 | 0.99 | 0.90 | 2.10 |
| class: two capitalized words | 1331 | 1125.39 ± 0.5% | 953.93 ± 0.1% | 25.59 ± 0.1% | 585.18 ± 0.1% | 40.66 ± 3.8% | 13.92 ± 0.3% | 68.96 ± 0.5% | 1124.84 ± 0.6% | 1.18 | 1.00 | 1.92 | 27.68 |
| class: a word that ends in ing | 3399 | 876.47 ± 0.4% | 876.03 ± 0.1% | 17.85 ± 0.3% | 547.18 ± 0.1% | 29.60 ± 9.7% | 7.78 ± 0.1% | 18.40 ± 0.3% | 875.56 ± 0.1% | 1.00 | 1.00 | 1.60 | 29.61 |
| class: a word in capitals | 2332 | 1475.85 ± 0.7% | 938.12 ± 0.3% | 27.22 ± 0.2% | 572.02 ± 0.0% | 43.50 ± 9.8% | 16.70 ± 0.3% | 83.23 ± 0.4% | 1474.16 ± 0.4% | 1.57 | 1.00 | 2.58 | 33.92 |
| class: a number | 8288 | 1989.05 ± 0.4% | 786.71 ± 0.0% | 27.32 ± 0.3% | 1706.38 ± 0.3% | 42.60 ± 17.3% | 0.51 ± 0.0% | 56.76 ± 0.5% | 1993.42 ± 0.1% | 2.53 | 1.00 | 1.17 | 46.69 |
| class: two capitalized words, second text | 5359 | 683.53 ± 0.1% | 679.44 ± 0.1% | 22.97 ± 0.1% | 484.46 ± 0.1% | 35.51 ± 14.3% | 17.10 ± 0.6% | 63.93 ± 0.4% | 683.29 ± 0.1% | 1.01 | 1.00 | 1.41 | 19.25 |
| other: a word between two words | 6104 | 765.37 ± 0.2% | 738.38 ± 0.2% | 23.21 ± 0.1% | 733.56 ± 0.1% | 109.17 ± 21.2% | 10.54 ± 0.1% | 69.66 ± 0.2% | 765.62 ± 0.1% | 1.04 | 1.00 | 1.04 | 7.01 |
| other: a number before a unit, second text | 1481 | 5581.50 ± 0.9% | 973.13 ± 0.1% | 25.50 ± 0.3% | 5676.33 ± 0.2% | 40.85 ± 0.1% | 18.15 ± 0.3% | 66.80 ± 0.2% | 5571.51 ± 0.2% | 5.74 | 1.00 | 0.98 | 136.65 |
| other: a heading's start tag | 110 | 12713.44 ± 0.4% | 1035.39 ± 0.1% | 26.94 ± 0.2% | 1709.94 ± 0.6% | 1570.74 ± 4.8% | 14.99 ± 0.8% | 88.95 ± 0.7% | 12709.98 ± 0.2% | 12.28 | 1.00 | 7.44 | 8.09 |
| other: a whole word | 217 | 14047.39 ± 0.4% | 1036.71 ± 0.1% | 28.77 ± 0.4% | 14737.94 ± 0.8% | 49.47 ± 0.2% | 12.07 ± 0.1% | 55.73 ± 0.7% | 14042.80 ± 0.3% | 13.55 | 1.00 | 0.95 | 283.96 |
| other: a line's first word, second text | 3716 | 1984.56 ± 0.5% | 854.95 ± 0.0% | 30.32 ± 0.1% | 1720.42 ± 0.4% | 62.56 ± 8.1% | refused | refused | 1974.19 ± 0.7% | 2.32 | 1.01 | 1.15 | 31.72 |
| other: fourteen octets before an x | 87 | 19889.10 ± 1.3% | 247.56 ± 0.4% | 6.09 ± 0.1% | 3981.13 ± 0.3% | 10.63 ± 0.1% | differs | 17.77 ± 0.4% | 19951.44 ± 0.3% | 80.34 | 1.00 | 5.00 | 1870.20 |
| other: a Greek word | 21815 | 486.17 ± 0.6% | 308.03 ± 0.5% | 30.63 ± 0.3% | 288.59 ± 0.4% | 47.32 ± 16.3% | differs | refused | 483.04 ± 0.7% | 1.58 | 1.01 | 1.68 | 10.27 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.1% | 25.87 ± 0.2% | 0.82 ± 0.3% | 19.84 ± 0.2% | 2.75 ± 0.6% | differs | 4.01 ± 0.4% | 25.85 ± 0.1% | 1.00 | 1.00 | 1.30 | 9.39 |
| a UUID | 32895 | 21.09 ± 0.3% | 21.16 ± 0.3% | 0.64 ± 0.2% | 15.07 ± 0.2% | 3.12 ± 0.7% | 0.73 ± 0.3% | 3.62 ± 1.1% | 21.18 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.77 |
| an IPv4 address | 33176 | 36.76 ± 0.3% | 36.74 ± 0.4% | 2.10 ± 0.2% | 29.40 ± 0.9% | 6.68 ± 0.3% | differs | 4.14 ± 0.2% | 36.79 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.50 |
| a date and time | 32954 | 31.05 ± 0.3% | 31.08 ± 0.3% | 1.46 ± 0.4% | 21.55 ± 0.1% | 7.05 ± 0.1% | 1.25 ± 0.1% | 7.18 ± 0.6% | 31.02 ± 0.3% | 1.00 | 1.00 | 1.44 | 4.40 |
| a field path | 32606 | 29.38 ± 0.6% | 29.31 ± 0.2% | 1.01 ± 0.3% | 23.22 ± 0.2% | 3.49 ± 1.2% | differs | 2.97 ± 0.3% | 29.35 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.61 ± 1.3% | 11.66 ± 1.0% | 11.65 ± 1.4% | 11.56 ± 0.1% | 4.95 ± 1.6% | 0.93 ± 0.2% | none | 11.65 ± 0.3% | 1.00 | 1.00 | 1.00 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.02 ± 0.3% | 236.36 ± 0.3% | 287.37 ± 0.3% | 86.33 ± 0.5% | 220.40 ± 0.9% | 474.03 ± 1.5% | 3858.95 ± 1.2% | 234.78 ± 0.2% | 0.99 | 1.00 | 2.72 | 1.07 |
| a UUID | 62 | 157.51 ± 0.6% | 158.05 ± 0.4% | 179.24 ± 0.2% | 46.20 ± 0.7% | 99.08 ± 1.2% | 186.56 ± 3.2% | 4364.95 ± 1.8% | 157.64 ± 0.2% | 1.00 | 1.00 | 3.41 | 1.59 |
| an IPv4 address | 29 | 421.60 ± 0.2% | 426.01 ± 0.6% | 617.86 ± 0.7% | 76.45 ± 0.2% | 129.91 ± 1.1% | 296.72 ± 2.2% | 7610.70 ± 0.2% | 421.38 ± 0.5% | 0.99 | 1.00 | 5.51 | 3.25 |
| a date and time | 56 | 306.43 ± 0.4% | 308.78 ± 0.6% | 398.19 ± 0.3% | 72.43 ± 0.5% | 136.41 ± 2.5% | 322.77 ± 1.1% | 4897.00 ± 0.7% | 306.46 ± 0.2% | 0.99 | 1.00 | 4.23 | 2.25 |
| a field path | 39 | 227.26 ± 0.6% | 228.62 ± 0.4% | 275.48 ± 0.4% | 80.17 ± 1.2% | 203.27 ± 1.0% | 499.87 ± 3.8% | 4876.66 ± 1.5% | 227.12 ± 0.2% | 0.99 | 1.00 | 2.83 | 1.12 |
| literal: a word | 7 | 623.69 ± 0.5% | 668.07 ± 0.2% | 1271.91 ± 0.2% | 511.99 ± 0.4% | 620.38 ± 2.4% | 948.72 ± 0.4% | 29617.80 ± 0.3% | 623.51 ± 0.5% | 0.93 | 1.00 | 1.22 | 1.01 |
| literal: a word that is not there | 8 | 600.04 ± 0.2% | 647.79 ± 0.4% | 1193.82 ± 0.1% | 468.98 ± 0.2% | 599.91 ± 1.8% | 899.34 ± 0.5% | 28591.82 ± 0.2% | 599.80 ± 0.2% | 0.93 | 1.00 | 1.28 | 1.00 |
| literal: one of four words | 26 | 241.95 ± 0.2% | 401.50 ± 0.6% | 566.32 ± 0.5% | 49.94 ± 0.9% | 238.41 ± 9.3% | 372.06 ± 2.8% | 15471.54 ± 0.2% | 241.99 ± 0.7% | 0.60 | 1.00 | 4.85 | 1.01 |
| literal: a word in any case | 11 | 484.59 ± 0.2% | 516.76 ± 0.5% | 843.36 ± 0.3% | 15.44 ± 1.2% | 647.64 ± 1.3% | refused | 23449.22 ± 0.5% | 484.42 ± 0.4% | 0.94 | 1.00 | 31.40 | 0.75 |
| literal: an href attribute | 12 | 350.22 ± 0.3% | 363.16 ± 0.3% | 495.49 ± 0.4% | 42.52 ± 0.3% | 500.83 ± 1.5% | 766.10 ± 1.0% | 21502.15 ± 0.3% | 350.07 ± 0.3% | 0.96 | 1.00 | 8.24 | 0.70 |
| literal: a word, second text | 10 | 561.96 ± 0.5% | 617.84 ± 0.3% | 1086.19 ± 0.2% | 393.36 ± 0.2% | 534.57 ± 11.4% | 795.71 ± 0.7% | 26602.15 ± 0.2% | 561.86 ± 0.5% | 0.91 | 1.00 | 1.43 | 1.05 |
| class: two capitalized words | 23 | 437.15 ± 0.4% | 469.05 ± 0.1% | 711.11 ± 0.4% | 99.40 ± 0.2% | 500.85 ± 1.6% | 737.76 ± 0.4% | 6574.42 ± 0.3% | 437.74 ± 0.3% | 0.93 | 1.00 | 4.40 | 0.87 |
| class: a word that ends in ing | 9 | 556.40 ± 0.5% | 627.35 ± 0.6% | 1175.26 ± 0.2% | 131.47 ± 1.7% | 757.34 ± 0.9% | 1088.59 ± 0.7% | 16000.68 ± 0.2% | 556.48 ± 0.5% | 0.89 | 1.00 | 4.23 | 0.73 |
| class: a word in capitals | 16 | 491.26 ± 0.2% | 534.27 ± 0.4% | 915.26 ± 0.5% | 134.90 ± 0.4% | 752.13 ± 0.7% | 1015.60 ± 0.4% | 8618.26 ± 0.8% | 491.31 ± 0.2% | 0.92 | 1.00 | 3.64 | 0.65 |
| class: a number | 6 | 611.78 ± 0.3% | 682.96 ± 0.3% | 1382.82 ± 0.1% | 41.63 ± 0.6% | 1412.43 ± 1.2% | 1862.34 ± 1.4% | 22328.24 ± 0.2% | 611.45 ± 0.3% | 0.90 | 1.00 | 14.70 | 0.43 |
| class: two capitalized words, second text | 23 | 438.08 ± 0.4% | 468.72 ± 0.3% | 711.17 ± 0.3% | 100.63 ± 0.4% | 502.58 ± 0.8% | 757.53 ± 0.5% | 6575.49 ± 0.6% | 438.00 ± 0.4% | 0.93 | 1.00 | 4.35 | 0.87 |
| other: a word between two words | 13 | 551.67 ± 0.4% | 569.49 ± 0.2% | 959.22 ± 0.1% | 133.15 ± 0.6% | 504.41 ± 4.4% | 807.49 ± 0.5% | 14835.20 ± 0.1% | 551.49 ± 0.7% | 0.97 | 1.00 | 4.14 | 1.09 |
| other: a number before a unit, second text | 15 | 406.81 ± 0.4% | 447.37 ± 0.2% | 657.59 ± 0.3% | 39.40 ± 0.3% | 630.49 ± 3.1% | 889.01 ± 1.1% | 15070.56 ± 0.2% | 406.65 ± 0.2% | 0.91 | 1.00 | 10.32 | 0.65 |
| other: a heading's start tag | 13 | 359.82 ± 0.3% | 365.03 ± 0.2% | 500.76 ± 0.2% | 43.56 ± 0.3% | 627.28 ± 1.0% | 874.21 ± 1.4% | 17846.71 ± 0.7% | 359.48 ± 0.2% | 0.99 | 1.00 | 8.26 | 0.57 |
| other: a whole word | 11 | 585.03 ± 0.2% | 619.55 ± 0.5% | 1087.85 ± 0.2% | 117.27 ± 0.7% | 563.55 ± 4.4% | 825.67 ± 0.5% | 26690.82 ± 0.4% | 584.31 ± 0.2% | 0.94 | 1.00 | 4.99 | 1.04 |
| other: a line's first word, second text | 17 | 533.55 ± 0.3% | 550.76 ± 0.2% | 941.71 ± 0.2% | 128.61 ± 0.2% | 707.57 ± 2.2% | refused | refused | 530.06 ± 1.1% | 0.97 | 1.01 | 4.15 | 0.75 |
| other: fourteen octets before an x | 16 | 111.56 ± 0.8% | 161.58 ± 1.0% | 189.60 ± 1.1% | 14.86 ± 0.3% | 451.22 ± 1.3% | 402.50 ± 0.5% | 12502.43 ± 0.6% | 111.48 ± 0.5% | 0.69 | 1.00 | 7.51 | 0.25 |
| other: a Greek word | 8 | 423.86 ± 0.3% | 585.81 ± 0.4% | 1057.59 ± 0.2% | 58.57 ± 0.2% | 1375.40 ± 1.4% | 1833.01 ± 0.7% | refused | 423.55 ± 0.4% | 0.72 | 1.00 | 7.24 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 13023.34 ± 0.5% | not timed | not timed | 16475.06 ± 1.4% | 1940.99 ± 18.8% | not timed | not timed | 13031.27 ± 0.5% | | 1.00 | 0.79 | 6.71 |
| 01-literal/sherlock-casei-en | 522 | 3914.03 ± 0.5% | not timed | not timed | 3594.12 ± 0.1% | 32.40 ± 0.3% | not timed | not timed | 3905.83 ± 0.5% | | 1.00 | 1.09 | 120.80 |
| 01-literal/sherlock-ru | 724 | 13652.65 ± 0.3% | not timed | not timed | 17343.28 ± 0.2% | 1571.90 ± 6.4% | not timed | not timed | 13623.64 ± 0.2% | | 1.00 | 0.79 | 8.69 |
| 01-literal/sherlock-casei-ru | 746 | 5316.58 ± 0.5% | not timed | not timed | 3320.04 ± 0.1% | 30.64 ± 0.4% | not timed | not timed | 5319.20 ± 0.3% | | 1.00 | 1.60 | 173.53 |
| 01-literal/sherlock-zh | 30 | 17122.58 ± 0.6% | not timed | not timed | 18787.50 ± 0.4% | 2617.81 ± 12.7% | not timed | not timed | 17104.79 ± 0.3% | | 1.00 | 0.91 | 6.54 |
| 02-literal-alternate/sherlock-en | 714 | 5824.44 ± 0.4% | not timed | not timed | 3938.11 ± 0.1% | 16.68 ± 0.1% | not timed | not timed | 5817.97 ± 0.3% | | 1.00 | 1.48 | 349.15 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1681.22 ± 1.1% | not timed | not timed | 696.68 ± 0.1% | 11.04 ± 0.2% | not timed | not timed | 1674.53 ± 0.4% | | 1.00 | 2.41 | 152.23 |
| 02-literal-alternate/sherlock-ru | 899 | 4716.27 ± 0.4% | not timed | not timed | 3255.65 ± 0.1% | 22.68 ± 0.2% | not timed | not timed | 4716.95 ± 0.4% | | 1.00 | 1.45 | 207.95 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1797.62 ± 0.5% | not timed | not timed | 1232.52 ± 0.1% | 9.06 ± 5.4% | not timed | not timed | 1793.80 ± 0.3% | | 1.00 | 1.46 | 198.38 |
| 02-literal-alternate/sherlock-zh | 207 | 7069.29 ± 0.2% | not timed | not timed | 4163.85 ± 0.2% | 31.54 ± 0.1% | not timed | not timed | 7066.52 ± 0.3% | | 1.00 | 1.70 | 224.13 |
| 03-date/ascii | 111817 | 124.07 ± 0.9% | not timed | not timed | 96.15 ± 0.2% | 0.20 ± 1.5% | not timed | not timed | 122.58 ± 0.1% | | 1.01 | 1.29 | 617.82 |
| 04-ruff-noqa/real | 84 | 555.25 ± 0.0% | not timed | not timed | 475.74 ± 0.3% | 19.53 ± 1.3% | not timed | not timed | 555.74 ± 0.1% | | 1.00 | 1.17 | 28.43 |
| 04-ruff-noqa/tweaked | 44 | 559.95 ± 0.2% | not timed | not timed | 465.66 ± 0.1% | 365.92 ± 0.2% | not timed | not timed | 558.59 ± 0.2% | | 1.00 | 1.20 | 1.53 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.6% | not timed | not timed | 5.24 ± 0.1% | 0.21 ± 3.1% | not timed | not timed | 3.63 ± 2.1% | | 0.97 | 0.67 | 17.06 |
| 06-cloud-flare-redos/original | 107 | 184.93 ± 0.7% | not timed | not timed | 217.31 ± 0.4% | 24.83 ± 0.2% | not timed | not timed | 183.71 ± 0.5% | | 1.01 | 0.85 | 7.45 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.07 ± 1.4% | not timed | not timed | 226.68 ± 0.1% | 26.69 ± 0.5% | not timed | not timed | 145.14 ± 1.1% | | 1.00 | 0.64 | 5.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.90 ± 2.3% | not timed | not timed | 256.19 ± 0.3% | 28.88 ± 0.1% | not timed | not timed | 154.92 ± 2.4% | | 1.00 | 0.60 | 5.36 |
| 07-unicode-character-data/parse-line | 558784 | 232.82 ± 1.6% | not timed | not timed | 178.72 ± 0.2% | 42.23 ± 6.1% | not timed | not timed | 227.44 ± 0.2% | | 1.02 | 1.30 | 5.51 |
| 08-words/all-english | 56691 | 103.42 ± 0.3% | not timed | not timed | 83.24 ± 0.1% | 12.04 ± 9.1% | not timed | not timed | 102.27 ± 0.6% | | 1.01 | 1.24 | 8.59 |
| 08-words/long-english | 839 | 999.35 ± 0.1% | not timed | not timed | 596.48 ± 0.1% | 32.64 ± 0.4% | not timed | not timed | 999.07 ± 0.1% | | 1.00 | 1.68 | 30.62 |
| 09-aws-keys/full | 0 | 424.92 ± 0.1% | not timed | not timed | 493.87 ± 0.2% | 64.80 ± 3.5% | not timed | not timed | 425.16 ± 0.1% | | 1.00 | 0.86 | 6.56 |
| 09-aws-keys/quick | 0 | 739.57 ± 0.2% | not timed | not timed | 977.12 ± 0.5% | 421.07 ± 1.0% | not timed | not timed | 736.95 ± 0.2% | | 1.00 | 0.76 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 587.01 ± 0.4% | not timed | not timed | 512.24 ± 0.7% | 19.54 ± 0.5% | not timed | not timed | 585.35 ± 0.3% | | 1.00 | 1.15 | 30.04 |
| 10-bounded-repeat/letters-ru | 3475 | 401.55 ± 0.2% | not timed | not timed | 480.61 ± 0.2% | 22.36 ± 16.1% | not timed | not timed | 400.55 ± 0.5% | | 1.00 | 0.84 | 17.96 |
| 10-bounded-repeat/context | 53 | 79.98 ± 1.1% | not timed | not timed | 65.93 ± 0.9% | 19.79 ± 0.3% | not timed | not timed | 79.35 ± 1.0% | | 1.01 | 1.21 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 1046.63 ± 0.2% | not timed | not timed | 618.67 ± 0.0% | 36.61 ± 0.1% | not timed | not timed | 1046.25 ± 0.3% | | 1.00 | 1.69 | 28.59 |
| 11-unstructured-to-json/extract | 600 | 47.82 ± 0.1% | not timed | not timed | 76.77 ± 0.3% | 48.95 ± 1.3% | not timed | not timed | 47.45 ± 0.4% | | 1.01 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 602.92 ± 0.2% | not timed | not timed | 557.24 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 602.43 ± 0.3% | | 1.00 | 1.08 | 1491.82 |
| 14-quadratic/1x | 100 | 12.62 ± 0.2% | not timed | not timed | 10.00 ± 0.1% | 0.97 ± 3.8% | not timed | not timed | 12.54 ± 1.1% | | 1.01 | 1.26 | 12.98 |
| 14-quadratic/2x | 200 | 7.81 ± 0.3% | not timed | not timed | 5.51 ± 0.2% | 0.53 ± 0.6% | not timed | not timed | 7.79 ± 1.3% | | 1.00 | 1.42 | 14.61 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.6% | not timed | not timed | 1.86 ± 0.4% | | 1.00 | 1.54 | 16.32 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.35 ± 0.7% | 0.55 ± 1.7% | not timed | not timed | 1.44 ± 0.8% | | 1.01 | 4.20 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 90.14 ± 0.2% | not timed | not timed | 13.90 ± 0.4% | 136.87 ± 3.0% | not timed | not timed | 90.05 ± 1.2% | | 1.00 | 6.49 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.54 ± 0.1% | not timed | not timed | 2.52 ± 0.5% | 6.44 ± 1.4% | not timed | not timed | 14.51 ± 1.0% | | 1.00 | 5.77 | 2.26 |
| 07-unicode-character-data/compile | 1 | 58.40 ± 0.1% | not timed | not timed | 25.89 ± 0.4% | 35.65 ± 2.7% | not timed | not timed | 57.98 ± 0.8% | | 1.01 | 2.26 | 1.64 |
| 09-aws-keys/compile-full | 1 | 43.54 ± 0.2% | not timed | not timed | 8.34 ± 0.2% | 22.91 ± 26.6% | not timed | not timed | 43.35 ± 1.2% | | 1.00 | 5.22 | 1.90 |
| 09-aws-keys/compile-quick | 1 | 185.26 ± 0.2% | not timed | not timed | 47.93 ± 0.1% | 132.19 ± 2.1% | not timed | not timed | 186.20 ± 0.3% | | 0.99 | 3.87 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.62 ± 0.7% | not timed | not timed | 11.18 ± 0.1% | 15.99 ± 1.7% | not timed | not timed | 14.47 ± 2.2% | | 1.01 | 1.31 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.31 ± 1.3% | not timed | not timed | 7.98 ± 0.3% | 23.91 ± 2.1% | not timed | not timed | 84.94 ± 1.0% | | 1.00 | 10.69 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 90.59 ± 0.2% | not timed | not timed | 40.61 ± 0.3% | 67.72 ± 2.1% | not timed | not timed | 89.52 ± 1.4% | | 1.01 | 2.23 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 1.1% | 0.09 ± 10.4% | not timed | not timed | 0.36 ± 1.8% | | 1.01 | 5.27 | 3.91 |

