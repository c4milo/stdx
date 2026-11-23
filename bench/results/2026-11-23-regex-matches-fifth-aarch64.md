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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127334123 |
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
| literal: a word | 217 | 16121.48 ± 1.6% | 1039.14 ± 0.1% | 27.95 ± 0.1% | 18374.65 ± 2.1% | 9029.39 ± 9.6% | 17.29 ± 0.2% | 85.97 ± 0.1% | 16212.08 ± 0.8% | 15.51 | 0.99 | 0.88 | 1.79 |
| literal: a word that is not there | 0 | 18715.58 ± 1.7% | 1047.82 ± 0.1% | 27.89 ± 0.8% | 19703.30 ± 3.0% | 29094.26 ± 0.9% | 17.10 ± 0.2% | 81.73 ± 0.7% | 18832.33 ± 2.1% | 17.86 | 0.99 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6076.16 ± 0.3% | 1020.92 ± 0.1% | 14.58 ± 0.1% | 3943.14 ± 0.2% | 21.88 ± 0.0% | 5.36 ± 0.1% | 6.72 ± 0.2% | 6050.61 ± 0.3% | 5.95 | 1.00 | 1.54 | 277.74 |
| literal: a word in any case | 217 | 12570.15 ± 0.2% | 1039.43 ± 0.1% | 21.53 ± 1.5% | 3973.25 ± 0.1% | 37.97 ± 0.3% | refused | differs | 12558.80 ± 0.3% | 12.09 | 1.00 | 3.16 | 331.02 |
| literal: an href attribute | 33 | 13658.27 ± 0.8% | 1045.30 ± 0.3% | 26.87 ± 0.3% | 16845.54 ± 1.8% | 2258.29 ± 3.8% | 13.08 ± 0.3% | 75.19 ± 0.2% | 13613.74 ± 1.3% | 13.07 | 1.00 | 0.81 | 6.05 |
| literal: a word, second text | 123 | 16377.01 ± 1.1% | 1043.03 ± 0.2% | 27.69 ± 0.1% | 18267.35 ± 1.1% | 7566.80 ± 10.6% | 20.10 ± 0.3% | 68.45 ± 0.2% | 16455.54 ± 1.0% | 15.70 | 1.00 | 0.90 | 2.16 |
| class: two capitalized words | 1331 | 1126.28 ± 0.4% | 976.76 ± 0.2% | 25.68 ± 0.1% | 585.19 ± 0.0% | 40.59 ± 0.1% | 14.77 ± 0.1% | 68.32 ± 0.1% | 1125.33 ± 0.4% | 1.15 | 1.00 | 1.92 | 27.75 |
| class: a word that ends in ing | 3399 | 889.28 ± 0.2% | 890.82 ± 0.1% | 17.92 ± 0.4% | 547.85 ± 0.0% | 29.65 ± 5.3% | 8.14 ± 0.1% | 18.22 ± 0.4% | 889.92 ± 0.2% | 1.00 | 1.00 | 1.62 | 29.99 |
| class: a word in capitals | 2332 | 1449.86 ± 0.5% | 950.01 ± 0.0% | 27.32 ± 0.2% | 572.38 ± 0.2% | 43.62 ± 0.8% | 17.18 ± 0.7% | 82.99 ± 0.5% | 1449.87 ± 0.2% | 1.53 | 1.00 | 2.53 | 33.24 |
| class: a number | 8288 | 1994.26 ± 0.5% | 826.97 ± 0.2% | 27.48 ± 0.3% | 1717.65 ± 0.2% | 40.16 ± 12.0% | 0.55 ± 0.1% | 56.66 ± 0.2% | 1995.85 ± 0.2% | 2.41 | 1.00 | 1.16 | 49.66 |
| class: two capitalized words, second text | 5359 | 737.78 ± 0.2% | 736.47 ± 0.2% | 23.11 ± 0.1% | 484.65 ± 0.1% | 35.36 ± 13.6% | 17.11 ± 0.2% | 63.51 ± 0.2% | 736.95 ± 0.2% | 1.00 | 1.00 | 1.52 | 20.86 |
| other: a word between two words | 6104 | 762.04 ± 0.2% | 763.73 ± 0.1% | 23.34 ± 0.1% | 739.68 ± 0.2% | 104.92 ± 19.7% | 11.18 ± 0.1% | 69.05 ± 0.5% | 762.68 ± 0.1% | 1.00 | 1.00 | 1.03 | 7.26 |
| other: a number before a unit, second text | 1481 | 5514.93 ± 0.9% | 983.29 ± 0.1% | 25.58 ± 0.1% | 5654.22 ± 0.3% | 40.75 ± 0.3% | 18.15 ± 0.1% | 66.79 ± 0.3% | 5527.14 ± 1.1% | 5.61 | 1.00 | 0.98 | 135.33 |
| other: a heading's start tag | 110 | 12581.75 ± 0.2% | 1035.68 ± 0.5% | 27.04 ± 0.1% | 1709.84 ± 0.6% | 1578.65 ± 4.1% | 15.99 ± 0.5% | 88.44 ± 0.3% | 12578.41 ± 0.4% | 12.15 | 1.00 | 7.36 | 7.97 |
| other: a whole word | 217 | 14021.07 ± 1.1% | 1038.48 ± 0.3% | 29.15 ± 0.5% | 14775.94 ± 0.6% | 49.36 ± 0.6% | 13.12 ± 0.1% | 55.48 ± 0.1% | 13965.70 ± 1.6% | 13.50 | 1.00 | 0.95 | 284.04 |
| other: a line's first word, second text | 3716 | 1950.10 ± 0.5% | 873.59 ± 0.1% | 30.43 ± 0.2% | 1728.53 ± 0.3% | 62.68 ± 7.9% | refused | refused | 1945.56 ± 0.7% | 2.23 | 1.00 | 1.13 | 31.11 |
| other: fourteen octets before an x | 87 | 19857.80 ± 1.4% | 233.81 ± 0.3% | 6.11 ± 0.1% | 3993.55 ± 1.0% | 10.63 ± 0.1% | differs | 17.65 ± 0.1% | 19868.41 ± 0.7% | 84.93 | 1.00 | 4.97 | 1867.96 |
| other: a Greek word | 21815 | 469.31 ± 0.2% | 357.80 ± 0.4% | 30.82 ± 0.3% | 289.78 ± 0.4% | 44.87 ± 11.8% | differs | refused | 468.12 ± 0.4% | 1.31 | 1.00 | 1.62 | 10.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.89 ± 0.2% | 25.88 ± 0.1% | 0.83 ± 0.3% | 19.75 ± 0.2% | 2.76 ± 0.2% | differs | 4.04 ± 0.2% | 25.89 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.38 |
| a UUID | 32895 | 21.06 ± 0.3% | 21.09 ± 0.2% | 0.65 ± 0.1% | 15.07 ± 0.5% | 3.09 ± 0.6% | 0.73 ± 0.2% | 3.62 ± 0.7% | 21.18 ± 0.2% | 1.00 | 0.99 | 1.40 | 6.82 |
| an IPv4 address | 33176 | 36.96 ± 0.3% | 36.88 ± 0.3% | 2.09 ± 0.2% | 29.42 ± 0.4% | 6.67 ± 0.3% | differs | 4.16 ± 0.0% | 36.73 ± 0.2% | 1.00 | 1.01 | 1.26 | 5.54 |
| a date and time | 32954 | 31.08 ± 0.4% | 31.12 ± 0.3% | 1.41 ± 0.2% | 21.45 ± 0.5% | 7.04 ± 0.4% | 1.25 ± 0.1% | 7.05 ± 0.8% | 30.98 ± 0.3% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 29.47 ± 0.2% | 29.40 ± 0.2% | 1.01 ± 0.8% | 23.14 ± 0.1% | 3.48 ± 0.2% | differs | 2.93 ± 0.2% | 29.45 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.5% | 11.54 ± 0.7% | 11.54 ± 0.6% | 11.45 ± 0.2% | 4.89 ± 0.5% | 0.93 ± 0.1% | none | 11.55 ± 0.3% | 1.00 | 1.00 | 1.00 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.18 ± 0.2% | 235.88 ± 0.2% | 286.00 ± 0.2% | 86.29 ± 0.5% | 220.57 ± 2.0% | 475.68 ± 1.2% | 3738.49 ± 0.2% | 234.08 ± 0.1% | 0.99 | 1.00 | 2.71 | 1.06 |
| a UUID | 62 | 157.59 ± 0.2% | 157.88 ± 0.2% | 179.09 ± 0.1% | 46.18 ± 0.6% | 98.17 ± 1.5% | 187.26 ± 2.9% | 4447.04 ± 0.8% | 157.43 ± 0.2% | 1.00 | 1.00 | 3.41 | 1.61 |
| an IPv4 address | 29 | 421.03 ± 0.3% | 426.23 ± 0.3% | 617.53 ± 0.5% | 76.38 ± 0.4% | 131.05 ± 1.3% | 297.95 ± 1.5% | 7668.06 ± 0.4% | 420.89 ± 0.1% | 0.99 | 1.00 | 5.51 | 3.21 |
| a date and time | 56 | 306.73 ± 0.5% | 309.39 ± 0.1% | 398.29 ± 0.1% | 72.33 ± 0.3% | 135.70 ± 4.9% | 325.15 ± 1.3% | 4941.48 ± 0.5% | 306.61 ± 0.5% | 0.99 | 1.00 | 4.24 | 2.26 |
| a field path | 39 | 226.97 ± 0.3% | 228.08 ± 0.5% | 274.49 ± 0.5% | 80.05 ± 1.3% | 205.56 ± 10.4% | 499.28 ± 2.7% | 4811.40 ± 0.3% | 226.77 ± 0.2% | 1.00 | 1.00 | 2.84 | 1.10 |
| literal: a word | 7 | 629.18 ± 0.3% | 673.34 ± 0.3% | 1275.03 ± 0.7% | 512.76 ± 0.1% | 622.60 ± 1.8% | 941.10 ± 0.6% | 29596.63 ± 0.1% | 629.06 ± 0.3% | 0.93 | 1.00 | 1.23 | 1.01 |
| literal: a word that is not there | 8 | 604.22 ± 0.3% | 653.84 ± 0.3% | 1202.22 ± 0.2% | 469.92 ± 0.1% | 603.70 ± 1.6% | 896.57 ± 0.4% | 28597.96 ± 0.3% | 604.58 ± 0.1% | 0.92 | 1.00 | 1.29 | 1.00 |
| literal: one of four words | 26 | 242.43 ± 0.2% | 403.77 ± 0.3% | 568.04 ± 0.3% | 50.00 ± 1.2% | 244.33 ± 2.8% | 371.47 ± 1.6% | 15418.18 ± 0.2% | 242.48 ± 0.3% | 0.60 | 1.00 | 4.85 | 0.99 |
| literal: a word in any case | 11 | 487.90 ± 0.4% | 522.41 ± 0.6% | 850.42 ± 0.2% | 15.82 ± 1.7% | 650.47 ± 4.0% | refused | 23215.33 ± 0.4% | 487.77 ± 0.1% | 0.93 | 1.00 | 30.85 | 0.75 |
| literal: an href attribute | 12 | 351.20 ± 0.3% | 363.77 ± 0.4% | 494.18 ± 0.7% | 45.38 ± 1.0% | 499.22 ± 2.3% | 769.76 ± 0.8% | 21391.17 ± 0.2% | 351.19 ± 0.3% | 0.97 | 1.00 | 7.74 | 0.70 |
| literal: a word, second text | 10 | 564.23 ± 0.3% | 618.88 ± 0.3% | 1083.30 ± 0.5% | 392.30 ± 0.3% | 539.35 ± 4.6% | 796.76 ± 0.4% | 26406.78 ± 0.1% | 564.11 ± 0.2% | 0.91 | 1.00 | 1.44 | 1.05 |
| class: two capitalized words | 23 | 438.21 ± 0.3% | 469.53 ± 0.4% | 709.96 ± 0.6% | 98.93 ± 0.2% | 505.37 ± 2.1% | 741.55 ± 0.5% | 6331.59 ± 0.0% | 437.91 ± 0.4% | 0.93 | 1.00 | 4.43 | 0.87 |
| class: a word that ends in ing | 9 | 558.42 ± 0.3% | 629.46 ± 0.6% | 1177.32 ± 0.2% | 131.26 ± 2.1% | 756.58 ± 0.6% | 1093.43 ± 0.6% | 15690.51 ± 0.1% | 557.58 ± 0.5% | 0.89 | 1.00 | 4.25 | 0.74 |
| class: a word in capitals | 16 | 490.02 ± 0.4% | 532.32 ± 0.3% | 906.99 ± 0.3% | 134.36 ± 0.6% | 753.16 ± 0.9% | 1018.72 ± 1.5% | 8315.98 ± 0.1% | 490.48 ± 0.1% | 0.92 | 1.00 | 3.65 | 0.65 |
| class: a number | 6 | 613.94 ± 0.2% | 683.99 ± 0.6% | 1380.53 ± 0.1% | 41.60 ± 0.7% | 1407.81 ± 1.3% | 1872.73 ± 1.0% | 22426.99 ± 0.1% | 613.80 ± 0.3% | 0.90 | 1.00 | 14.76 | 0.44 |
| class: two capitalized words, second text | 23 | 437.80 ± 0.2% | 469.43 ± 0.1% | 710.13 ± 0.1% | 100.47 ± 0.5% | 500.96 ± 1.7% | 761.64 ± 0.4% | 6329.77 ± 0.2% | 438.47 ± 0.2% | 0.93 | 1.00 | 4.36 | 0.87 |
| other: a word between two words | 13 | 555.54 ± 0.1% | 575.07 ± 0.6% | 965.11 ± 0.4% | 132.53 ± 0.7% | 500.62 ± 2.4% | 806.01 ± 0.6% | 14525.49 ± 0.1% | 554.79 ± 0.3% | 0.97 | 1.00 | 4.19 | 1.11 |
| other: a number before a unit, second text | 15 | 407.37 ± 0.2% | 449.44 ± 0.2% | 657.21 ± 0.3% | 39.25 ± 0.4% | 633.76 ± 1.9% | 886.82 ± 1.1% | 15057.09 ± 0.1% | 407.28 ± 0.2% | 0.91 | 1.00 | 10.38 | 0.64 |
| other: a heading's start tag | 13 | 360.51 ± 0.3% | 365.43 ± 0.3% | 499.93 ± 0.3% | 43.14 ± 0.9% | 629.64 ± 0.3% | 876.75 ± 0.6% | 17827.81 ± 0.1% | 360.43 ± 0.3% | 0.99 | 1.00 | 8.36 | 0.57 |
| other: a whole word | 11 | 586.75 ± 0.3% | 623.16 ± 0.4% | 1096.91 ± 0.2% | 117.54 ± 0.6% | 566.10 ± 1.6% | 828.37 ± 0.4% | 26159.66 ± 0.2% | 586.84 ± 0.4% | 0.94 | 1.00 | 4.99 | 1.04 |
| other: a line's first word, second text | 17 | 534.69 ± 0.5% | 552.80 ± 0.4% | 942.36 ± 0.2% | 127.71 ± 0.4% | 709.72 ± 1.0% | refused | refused | 533.74 ± 0.7% | 0.97 | 1.00 | 4.19 | 0.75 |
| other: fourteen octets before an x | 16 | 111.70 ± 0.5% | 161.60 ± 0.6% | 189.75 ± 0.6% | 14.77 ± 0.5% | 452.57 ± 2.1% | 403.91 ± 0.2% | 12790.31 ± 0.2% | 111.84 ± 0.6% | 0.69 | 1.00 | 7.56 | 0.25 |
| other: a Greek word | 8 | 424.46 ± 0.2% | 585.60 ± 0.8% | 1049.02 ± 0.5% | 58.37 ± 0.7% | 1391.38 ± 2.3% | 1833.29 ± 0.1% | refused | 423.91 ± 0.2% | 0.72 | 1.00 | 7.27 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12764.82 ± 1.6% | not timed | not timed | 16219.98 ± 1.5% | 1995.77 ± 16.9% | not timed | not timed | 12803.80 ± 1.5% | | 1.00 | 0.79 | 6.40 |
| 01-literal/sherlock-casei-en | 522 | 3877.05 ± 0.7% | not timed | not timed | 3592.74 ± 0.4% | 32.49 ± 0.4% | not timed | not timed | 3878.40 ± 0.4% | | 1.00 | 1.08 | 119.32 |
| 01-literal/sherlock-ru | 724 | 13556.40 ± 0.7% | not timed | not timed | 17325.92 ± 0.8% | 1515.41 ± 15.9% | not timed | not timed | 13536.15 ± 0.7% | | 1.00 | 0.78 | 8.95 |
| 01-literal/sherlock-casei-ru | 746 | 5247.78 ± 0.2% | not timed | not timed | 3332.10 ± 0.2% | 31.70 ± 0.9% | not timed | not timed | 5259.41 ± 0.4% | | 1.00 | 1.57 | 165.55 |
| 01-literal/sherlock-zh | 30 | 16946.41 ± 0.1% | not timed | not timed | 18579.43 ± 0.7% | 2631.81 ± 10.1% | not timed | not timed | 16927.79 ± 0.5% | | 1.00 | 0.91 | 6.44 |
| 02-literal-alternate/sherlock-en | 714 | 5829.89 ± 0.4% | not timed | not timed | 3942.56 ± 0.3% | 16.65 ± 0.2% | not timed | not timed | 5829.28 ± 0.3% | | 1.00 | 1.48 | 350.17 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1668.12 ± 1.1% | not timed | not timed | 657.75 ± 0.3% | 11.12 ± 1.4% | not timed | not timed | 1661.70 ± 0.3% | | 1.00 | 2.54 | 150.01 |
| 02-literal-alternate/sherlock-ru | 899 | 4652.98 ± 0.1% | not timed | not timed | 3259.24 ± 0.1% | 22.63 ± 0.3% | not timed | not timed | 4656.79 ± 0.2% | | 1.00 | 1.43 | 205.60 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1784.23 ± 0.6% | not timed | not timed | 1232.95 ± 0.2% | 9.14 ± 0.3% | not timed | not timed | 1775.03 ± 0.4% | | 1.01 | 1.45 | 195.19 |
| 02-literal-alternate/sherlock-zh | 207 | 7074.63 ± 0.2% | not timed | not timed | 4162.11 ± 0.2% | 31.53 ± 9.5% | not timed | not timed | 7072.69 ± 0.4% | | 1.00 | 1.70 | 224.41 |
| 03-date/ascii | 111817 | 124.46 ± 0.6% | not timed | not timed | 96.12 ± 0.1% | 0.20 ± 4.3% | not timed | not timed | 123.99 ± 0.4% | | 1.00 | 1.29 | 611.05 |
| 04-ruff-noqa/real | 84 | 524.76 ± 0.0% | not timed | not timed | 477.97 ± 0.1% | 19.64 ± 1.3% | not timed | not timed | 554.88 ± 0.0% | | 0.95 | 1.10 | 26.72 |
| 04-ruff-noqa/tweaked | 44 | 545.79 ± 0.3% | not timed | not timed | 453.62 ± 0.0% | 363.98 ± 0.4% | not timed | not timed | 544.16 ± 0.1% | | 1.00 | 1.20 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.51 ± 0.2% | not timed | not timed | 5.17 ± 0.2% | 0.21 ± 4.7% | not timed | not timed | 3.64 ± 2.1% | | 0.96 | 0.68 | 17.08 |
| 06-cloud-flare-redos/original | 107 | 271.06 ± 0.1% | not timed | not timed | 216.69 ± 0.2% | 24.69 ± 6.2% | not timed | not timed | 269.83 ± 0.6% | | 1.00 | 1.25 | 10.98 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.07 ± 2.4% | not timed | not timed | 228.14 ± 0.1% | 26.69 ± 5.6% | not timed | not timed | 264.28 ± 5.0% | | 1.00 | 1.16 | 9.89 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.30 ± 0.7% | not timed | not timed | 255.81 ± 0.3% | 28.84 ± 0.1% | not timed | not timed | 294.32 ± 0.2% | | 1.00 | 1.15 | 10.20 |
| 07-unicode-character-data/parse-line | 558784 | 233.82 ± 0.3% | not timed | not timed | 174.98 ± 0.2% | 42.96 ± 0.3% | not timed | not timed | 228.23 ± 0.3% | | 1.02 | 1.34 | 5.44 |
| 08-words/all-english | 56691 | 119.34 ± 0.7% | not timed | not timed | 82.70 ± 0.2% | 11.87 ± 6.2% | not timed | not timed | 118.84 ± 0.6% | | 1.00 | 1.44 | 10.06 |
| 08-words/long-english | 839 | 1005.47 ± 0.1% | not timed | not timed | 596.24 ± 0.2% | 32.62 ± 0.4% | not timed | not timed | 1004.99 ± 0.1% | | 1.00 | 1.69 | 30.83 |
| 09-aws-keys/full | 0 | 412.96 ± 0.1% | not timed | not timed | 489.45 ± 0.1% | 64.48 ± 0.1% | not timed | not timed | 412.35 ± 0.0% | | 1.00 | 0.84 | 6.40 |
| 09-aws-keys/quick | 0 | 741.05 ± 0.1% | not timed | not timed | 1002.51 ± 0.2% | 417.73 ± 1.3% | not timed | not timed | 740.13 ± 0.0% | | 1.00 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 634.16 ± 0.4% | not timed | not timed | 518.17 ± 0.7% | 19.56 ± 0.6% | not timed | not timed | 633.36 ± 0.4% | | 1.00 | 1.22 | 32.41 |
| 10-bounded-repeat/letters-ru | 3475 | 380.97 ± 0.1% | not timed | not timed | 478.59 ± 0.1% | 21.68 ± 17.5% | not timed | not timed | 379.33 ± 0.4% | | 1.00 | 0.80 | 17.57 |
| 10-bounded-repeat/context | 53 | 79.23 ± 0.9% | not timed | not timed | 65.55 ± 0.6% | 19.79 ± 0.3% | not timed | not timed | 79.19 ± 1.1% | | 1.00 | 1.21 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1045.76 ± 0.1% | not timed | not timed | 615.44 ± 0.1% | 36.14 ± 0.1% | not timed | not timed | 1045.52 ± 0.1% | | 1.00 | 1.70 | 28.94 |
| 11-unstructured-to-json/extract | 600 | 47.70 ± 0.1% | not timed | not timed | 76.88 ± 0.5% | 48.64 ± 0.3% | not timed | not timed | 47.56 ± 0.8% | | 1.00 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 573.41 ± 0.2% | not timed | not timed | 559.92 ± 0.0% | 0.41 ± 0.1% | not timed | not timed | 572.87 ± 0.0% | | 1.00 | 1.02 | 1406.67 |
| 14-quadratic/1x | 100 | 12.98 ± 0.4% | not timed | not timed | 10.03 ± 0.2% | 0.97 ± 3.4% | not timed | not timed | 12.96 ± 1.4% | | 1.00 | 1.29 | 13.45 |
| 14-quadratic/2x | 200 | 7.97 ± 0.3% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 0.8% | not timed | not timed | 7.93 ± 0.8% | | 1.00 | 1.44 | 14.97 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 1.86 ± 0.5% | | 1.00 | 1.53 | 16.13 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.46 ± 0.3% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 4.3% | not timed | not timed | 1.45 ± 0.9% | | 1.00 | 4.24 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 92.72 ± 0.1% | not timed | not timed | 14.00 ± 0.2% | 138.93 ± 2.2% | not timed | not timed | 92.78 ± 1.0% | | 1.00 | 6.62 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.59 ± 0.2% | not timed | not timed | 2.51 ± 0.6% | 6.36 ± 1.4% | not timed | not timed | 14.39 ± 1.3% | | 1.01 | 5.80 | 2.29 |
| 07-unicode-character-data/compile | 1 | 58.34 ± 0.1% | not timed | not timed | 26.21 ± 0.2% | 35.72 ± 2.5% | not timed | not timed | 58.26 ± 1.1% | | 1.00 | 2.23 | 1.63 |
| 09-aws-keys/compile-full | 1 | 43.62 ± 0.2% | not timed | not timed | 8.22 ± 0.5% | 23.07 ± 1.8% | not timed | not timed | 43.36 ± 1.1% | | 1.01 | 5.31 | 1.89 |
| 09-aws-keys/compile-quick | 1 | 187.94 ± 0.1% | not timed | not timed | 47.97 ± 0.2% | 130.94 ± 2.3% | not timed | not timed | 188.44 ± 0.5% | | 1.00 | 3.92 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 14.58 ± 1.2% | not timed | not timed | 11.15 ± 0.4% | 15.97 ± 2.5% | not timed | not timed | 14.38 ± 1.6% | | 1.01 | 1.31 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.50 ± 0.4% | not timed | not timed | 8.02 ± 0.3% | 23.51 ± 1.4% | not timed | not timed | 85.45 ± 0.7% | | 1.00 | 10.66 | 3.64 |
| 11-unstructured-to-json/compile | 1 | 90.39 ± 0.2% | not timed | not timed | 40.84 ± 0.5% | 66.88 ± 4.7% | not timed | not timed | 90.10 ± 0.9% | | 1.00 | 2.21 | 1.35 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 1.1% | 0.09 ± 20.1% | not timed | not timed | 0.36 ± 2.1% | | 1.00 | 5.24 | 3.95 |

