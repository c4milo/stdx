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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117677710 |
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
| literal: a word | 217 | 15866.67 ± 1.6% | 1036.16 ± 0.1% | 27.85 ± 0.2% | 17900.08 ± 2.7% | 8988.31 ± 8.7% | 17.32 ± 0.3% | 86.36 ± 0.1% | 15988.86 ± 0.6% | 15.31 | 0.99 | 0.89 | 1.77 |
| literal: a word that is not there | 0 | 18440.57 ± 2.4% | 1047.52 ± 0.1% | 27.73 ± 0.3% | 19344.81 ± 0.6% | 27555.89 ± 3.4% | 17.14 ± 0.1% | 82.13 ± 0.1% | 18511.56 ± 4.0% | 17.60 | 1.00 | 0.95 | 0.67 |
| literal: one of four words | 661 | 6076.17 ± 0.5% | 1014.01 ± 0.2% | 14.43 ± 0.4% | 3940.85 ± 0.5% | 21.84 ± 0.2% | 5.35 ± 0.7% | 6.89 ± 0.6% | 6063.85 ± 0.1% | 5.99 | 1.00 | 1.54 | 278.20 |
| literal: a word in any case | 217 | 12524.92 ± 0.7% | 1036.89 ± 0.3% | 21.30 ± 0.5% | 3969.33 ± 0.1% | 38.07 ± 0.3% | refused | differs | 12510.69 ± 0.2% | 12.08 | 1.00 | 3.16 | 329.01 |
| literal: an href attribute | 33 | 13723.38 ± 1.7% | 1045.89 ± 0.2% | 26.17 ± 0.4% | 16904.19 ± 3.3% | 2255.59 ± 0.2% | 13.22 ± 0.1% | 75.27 ± 0.3% | 13788.16 ± 1.9% | 13.12 | 1.00 | 0.81 | 6.08 |
| literal: a word, second text | 123 | 16501.83 ± 2.3% | 1042.01 ± 0.1% | 27.49 ± 0.1% | 18485.14 ± 1.0% | 7877.19 ± 6.8% | 20.10 ± 0.5% | 70.20 ± 0.2% | 16476.01 ± 1.9% | 15.84 | 1.00 | 0.89 | 2.09 |
| class: two capitalized words | 1331 | 1125.69 ± 0.5% | 953.20 ± 0.4% | 25.60 ± 0.3% | 584.84 ± 0.5% | 40.73 ± 9.0% | 14.75 ± 0.5% | 68.94 ± 0.2% | 1123.11 ± 0.6% | 1.18 | 1.00 | 1.92 | 27.64 |
| class: a word that ends in ing | 3399 | 875.75 ± 0.2% | 875.77 ± 0.2% | 17.87 ± 0.2% | 547.72 ± 0.1% | 29.64 ± 11.2% | 8.10 ± 0.1% | 18.43 ± 0.9% | 874.55 ± 0.1% | 1.00 | 1.00 | 1.60 | 29.55 |
| class: a word in capitals | 2332 | 1468.13 ± 0.6% | 936.96 ± 0.1% | 27.20 ± 0.2% | 572.16 ± 0.1% | 43.56 ± 6.3% | 17.13 ± 0.1% | 83.24 ± 0.2% | 1469.00 ± 0.6% | 1.57 | 1.00 | 2.57 | 33.70 |
| class: a number | 8288 | 1989.07 ± 0.4% | 785.95 ± 0.2% | 27.32 ± 0.2% | 1731.07 ± 0.1% | 38.72 ± 15.0% | 0.55 ± 0.1% | 56.61 ± 0.4% | 1988.19 ± 0.2% | 2.53 | 1.00 | 1.15 | 51.37 |
| class: two capitalized words, second text | 5359 | 682.78 ± 0.1% | 678.94 ± 0.0% | 22.99 ± 0.0% | 485.50 ± 0.1% | 35.54 ± 8.2% | 17.12 ± 0.3% | 64.04 ± 0.3% | 682.45 ± 0.3% | 1.01 | 1.00 | 1.41 | 19.21 |
| other: a word between two words | 6104 | 763.28 ± 0.2% | 738.17 ± 0.1% | 23.20 ± 0.1% | 737.44 ± 0.3% | 109.26 ± 20.1% | 11.25 ± 0.3% | 69.48 ± 0.3% | 764.88 ± 0.2% | 1.03 | 1.00 | 1.04 | 6.99 |
| other: a number before a unit, second text | 1481 | 5564.09 ± 1.0% | 972.99 ± 0.5% | 25.46 ± 0.2% | 5654.21 ± 1.1% | 40.90 ± 0.3% | 18.17 ± 0.2% | 66.81 ± 0.3% | 5557.46 ± 1.4% | 5.72 | 1.00 | 0.98 | 136.05 |
| other: a heading's start tag | 110 | 12533.49 ± 1.1% | 1035.49 ± 0.1% | 26.90 ± 0.2% | 1710.91 ± 0.3% | 1567.42 ± 3.2% | 16.03 ± 0.3% | 88.92 ± 0.5% | 12581.97 ± 1.4% | 12.10 | 1.00 | 7.33 | 8.00 |
| other: a whole word | 217 | 13855.73 ± 2.4% | 1036.38 ± 0.4% | 28.78 ± 0.3% | 14417.36 ± 1.0% | 49.45 ± 0.2% | 13.00 ± 0.1% | 55.69 ± 0.3% | 13876.02 ± 0.9% | 13.37 | 1.00 | 0.96 | 280.19 |
| other: a line's first word, second text | 3716 | 1980.06 ± 0.6% | 855.12 ± 0.2% | 30.34 ± 0.1% | 1728.38 ± 0.3% | 62.16 ± 7.1% | refused | refused | 1975.09 ± 0.6% | 2.32 | 1.00 | 1.15 | 31.86 |
| other: fourteen octets before an x | 87 | 19062.49 ± 1.7% | 227.10 ± 0.5% | 6.10 ± 0.2% | 3924.20 ± 0.5% | 10.63 ± 0.3% | differs | 17.77 ± 0.1% | 19180.98 ± 2.1% | 83.94 | 0.99 | 4.86 | 1792.77 |
| other: a Greek word | 21815 | 487.86 ± 0.7% | 309.09 ± 0.3% | 30.59 ± 0.2% | 290.22 ± 0.4% | 49.37 ± 9.3% | differs | refused | 485.32 ± 0.8% | 1.58 | 1.01 | 1.68 | 9.88 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.3% | 25.84 ± 0.1% | 0.82 ± 0.6% | 19.76 ± 0.5% | 2.79 ± 0.3% | differs | 4.02 ± 0.2% | 25.84 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.27 |
| a UUID | 32895 | 21.09 ± 0.2% | 21.12 ± 0.3% | 0.65 ± 0.1% | 15.07 ± 0.4% | 3.10 ± 0.5% | 0.73 ± 0.2% | 3.62 ± 0.7% | 21.17 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.79 |
| an IPv4 address | 33176 | 36.84 ± 0.4% | 36.80 ± 0.4% | 2.10 ± 0.4% | 29.24 ± 0.6% | 6.68 ± 0.1% | differs | 4.14 ± 0.3% | 36.93 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.52 |
| a date and time | 32954 | 30.84 ± 0.3% | 31.09 ± 0.2% | 1.46 ± 0.1% | 21.42 ± 1.1% | 7.05 ± 0.3% | 1.25 ± 0.4% | 7.17 ± 10.7% | 30.85 ± 0.2% | 0.99 | 1.00 | 1.44 | 4.37 |
| a field path | 32606 | 29.36 ± 0.1% | 29.28 ± 0.2% | 1.01 ± 0.1% | 23.19 ± 0.4% | 3.49 ± 0.6% | differs | 2.97 ± 0.2% | 29.35 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.60 ± 0.7% | 11.62 ± 0.9% | 11.62 ± 0.5% | 11.43 ± 0.2% | 4.99 ± 2.3% | 0.93 ± 0.3% | none | 11.55 ± 0.7% | 1.00 | 1.00 | 1.01 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.88 ± 0.3% | 236.31 ± 0.2% | 287.59 ± 0.2% | 87.14 ± 0.2% | 221.15 ± 1.1% | 481.15 ± 0.3% | 3819.05 ± 2.0% | 234.98 ± 0.2% | 0.99 | 1.00 | 2.70 | 1.06 |
| a UUID | 62 | 156.57 ± 0.4% | 156.96 ± 0.2% | 178.12 ± 0.2% | 45.94 ± 0.4% | 99.03 ± 0.7% | 180.79 ± 0.6% | 4385.27 ± 1.8% | 156.62 ± 0.3% | 1.00 | 1.00 | 3.41 | 1.58 |
| an IPv4 address | 29 | 421.41 ± 0.3% | 427.18 ± 0.3% | 619.53 ± 0.5% | 77.31 ± 1.0% | 131.95 ± 0.6% | 288.96 ± 0.6% | 7597.60 ± 0.1% | 421.57 ± 0.3% | 0.99 | 1.00 | 5.45 | 3.19 |
| a date and time | 56 | 306.72 ± 0.7% | 309.11 ± 0.4% | 398.67 ± 0.3% | 72.92 ± 0.2% | 137.41 ± 0.8% | 318.83 ± 0.5% | 4906.26 ± 0.5% | 306.67 ± 0.4% | 0.99 | 1.00 | 4.21 | 2.23 |
| a field path | 39 | 227.47 ± 0.4% | 228.96 ± 0.1% | 275.93 ± 0.2% | 80.38 ± 0.5% | 206.62 ± 0.7% | 484.26 ± 0.8% | 4887.40 ± 0.6% | 227.40 ± 0.2% | 0.99 | 1.00 | 2.83 | 1.10 |
| literal: a word | 7 | 624.70 ± 0.4% | 667.36 ± 0.3% | 1271.23 ± 0.1% | 517.86 ± 1.5% | 630.08 ± 2.1% | 912.87 ± 0.3% | 29621.21 ± 0.3% | 623.78 ± 0.7% | 0.94 | 1.00 | 1.21 | 0.99 |
| literal: a word that is not there | 8 | 600.10 ± 0.4% | 647.64 ± 0.2% | 1194.39 ± 0.1% | 472.02 ± 0.5% | 602.76 ± 0.8% | 868.25 ± 0.4% | 28600.75 ± 0.4% | 599.63 ± 0.2% | 0.93 | 1.00 | 1.27 | 1.00 |
| literal: one of four words | 26 | 241.57 ± 0.2% | 401.31 ± 0.3% | 566.14 ± 0.3% | 49.69 ± 0.3% | 244.71 ± 0.8% | 354.62 ± 0.7% | 15452.92 ± 0.2% | 241.56 ± 0.3% | 0.60 | 1.00 | 4.86 | 0.99 |
| literal: a word in any case | 11 | 485.22 ± 0.2% | 516.85 ± 0.6% | 845.98 ± 0.2% | 15.51 ± 0.8% | 648.28 ± 2.0% | refused | 23475.48 ± 0.4% | 484.85 ± 0.3% | 0.94 | 1.00 | 31.28 | 0.75 |
| literal: an href attribute | 12 | 350.14 ± 0.2% | 363.15 ± 0.2% | 495.61 ± 0.3% | 9.02 ± 43.9% | 500.63 ± 1.5% | 755.22 ± 1.7% | 21505.54 ± 0.5% | 350.08 ± 0.1% | 0.96 | 1.00 | 38.81 | 0.70 |
| literal: a word, second text | 10 | 561.48 ± 0.6% | 616.85 ± 0.5% | 1083.60 ± 0.8% | 423.60 ± 0.2% | 538.45 ± 7.3% | 782.29 ± 0.9% | 26589.05 ± 0.1% | 561.56 ± 0.3% | 0.91 | 1.00 | 1.33 | 1.04 |
| class: two capitalized words | 23 | 437.53 ± 0.9% | 468.65 ± 0.4% | 710.92 ± 0.5% | 102.62 ± 0.1% | 499.08 ± 1.1% | 737.76 ± 0.5% | 6567.57 ± 0.5% | 437.70 ± 0.3% | 0.93 | 1.00 | 4.26 | 0.88 |
| class: a word that ends in ing | 9 | 557.07 ± 0.9% | 629.59 ± 0.4% | 1176.00 ± 0.4% | 134.08 ± 0.8% | 755.04 ± 0.5% | 1067.64 ± 1.3% | 15999.87 ± 0.0% | 556.83 ± 0.6% | 0.88 | 1.00 | 4.15 | 0.74 |
| class: a word in capitals | 16 | 491.88 ± 0.8% | 534.02 ± 0.7% | 913.96 ± 0.3% | 137.12 ± 1.1% | 750.57 ± 0.5% | 1020.47 ± 2.0% | 8619.29 ± 0.1% | 491.47 ± 0.2% | 0.92 | 1.00 | 3.59 | 0.66 |
| class: a number | 6 | 611.61 ± 0.7% | 684.50 ± 0.4% | 1387.55 ± 0.2% | 42.18 ± 0.1% | 1404.86 ± 1.4% | 1923.34 ± 0.8% | 22315.04 ± 0.2% | 612.51 ± 0.4% | 0.89 | 1.00 | 14.50 | 0.44 |
| class: two capitalized words, second text | 23 | 437.63 ± 0.3% | 468.56 ± 0.6% | 711.76 ± 0.2% | 102.49 ± 1.6% | 502.42 ± 7.0% | 734.75 ± 0.6% | 6571.29 ± 0.3% | 437.50 ± 0.3% | 0.93 | 1.00 | 4.27 | 0.87 |
| other: a word between two words | 13 | 551.70 ± 0.8% | 570.50 ± 0.4% | 959.60 ± 0.9% | 137.26 ± 1.5% | 502.12 ± 1.1% | 806.54 ± 0.6% | 14824.67 ± 0.1% | 552.45 ± 1.0% | 0.97 | 1.00 | 4.02 | 1.10 |
| other: a number before a unit, second text | 15 | 406.17 ± 0.1% | 447.56 ± 0.2% | 656.58 ± 0.4% | 39.41 ± 0.4% | 632.92 ± 0.7% | 885.94 ± 0.3% | 15070.93 ± 0.2% | 406.01 ± 0.3% | 0.91 | 1.00 | 10.31 | 0.64 |
| other: a heading's start tag | 13 | 359.52 ± 0.5% | 365.30 ± 0.4% | 500.24 ± 0.3% | 9.98 ± 21.4% | 622.75 ± 1.8% | 857.98 ± 0.4% | 17886.26 ± 0.1% | 359.37 ± 0.7% | 0.98 | 1.00 | 36.02 | 0.58 |
| other: a whole word | 11 | 585.22 ± 0.2% | 620.08 ± 0.3% | 1090.49 ± 0.4% | 121.99 ± 0.3% | 567.33 ± 1.2% | 821.82 ± 0.5% | 26674.83 ± 0.3% | 584.24 ± 0.3% | 0.94 | 1.00 | 4.80 | 1.03 |
| other: a line's first word, second text | 17 | 532.81 ± 0.5% | 550.22 ± 0.5% | 941.77 ± 0.1% | 129.68 ± 0.2% | 708.26 ± 0.8% | refused | refused | 531.72 ± 0.8% | 0.97 | 1.00 | 4.11 | 0.75 |
| other: fourteen octets before an x | 16 | 111.53 ± 0.5% | 161.32 ± 0.6% | 189.92 ± 1.0% | 7.04 ± 20.3% | 452.67 ± 1.8% | 406.94 ± 0.4% | 12494.15 ± 0.7% | 111.50 ± 0.1% | 0.69 | 1.00 | 15.85 | 0.25 |
| other: a Greek word | 8 | 423.81 ± 0.2% | 586.82 ± 0.2% | 1059.49 ± 0.1% | 13.52 ± 45.5% | 1386.26 ± 0.9% | 1804.54 ± 0.6% | refused | 423.99 ± 0.1% | 0.72 | 1.00 | 31.36 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12760.59 ± 0.7% | not timed | not timed | 15927.93 ± 1.0% | 2069.33 ± 19.8% | not timed | not timed | 12725.50 ± 0.8% | | 1.00 | 0.80 | 6.17 |
| 01-literal/sherlock-casei-en | 522 | 3914.95 ± 0.6% | not timed | not timed | 3579.01 ± 0.3% | 32.43 ± 0.2% | not timed | not timed | 3909.08 ± 0.8% | | 1.00 | 1.09 | 120.73 |
| 01-literal/sherlock-ru | 724 | 13637.29 ± 0.5% | not timed | not timed | 17293.63 ± 0.3% | 1510.74 ± 9.0% | not timed | not timed | 13611.17 ± 0.4% | | 1.00 | 0.79 | 9.03 |
| 01-literal/sherlock-casei-ru | 746 | 5309.49 ± 0.2% | not timed | not timed | 3325.72 ± 0.1% | 30.75 ± 0.3% | not timed | not timed | 5316.93 ± 0.4% | | 1.00 | 1.60 | 172.66 |
| 01-literal/sherlock-zh | 30 | 16409.33 ± 0.2% | not timed | not timed | 17833.71 ± 1.5% | 2667.21 ± 5.3% | not timed | not timed | 16406.39 ± 0.6% | | 1.00 | 0.92 | 6.15 |
| 02-literal-alternate/sherlock-en | 714 | 5816.93 ± 0.5% | not timed | not timed | 3935.04 ± 0.2% | 16.58 ± 0.1% | not timed | not timed | 5807.95 ± 0.4% | | 1.00 | 1.48 | 350.93 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1680.24 ± 1.0% | not timed | not timed | 696.00 ± 0.1% | 11.04 ± 14.6% | not timed | not timed | 1670.68 ± 0.6% | | 1.01 | 2.41 | 152.17 |
| 02-literal-alternate/sherlock-ru | 899 | 4713.60 ± 0.3% | not timed | not timed | 3255.89 ± 0.1% | 22.67 ± 0.1% | not timed | not timed | 4717.21 ± 0.7% | | 1.00 | 1.45 | 207.96 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1797.87 ± 0.5% | not timed | not timed | 1233.04 ± 0.4% | 9.07 ± 0.1% | not timed | not timed | 1790.94 ± 0.3% | | 1.00 | 1.46 | 198.30 |
| 02-literal-alternate/sherlock-zh | 207 | 7003.92 ± 0.4% | not timed | not timed | 4155.97 ± 0.4% | 31.51 ± 0.1% | not timed | not timed | 7020.21 ± 0.4% | | 1.00 | 1.69 | 222.28 |
| 03-date/ascii | 111817 | 123.75 ± 0.8% | not timed | not timed | 96.10 ± 0.1% | 0.20 ± 4.9% | not timed | not timed | 122.88 ± 0.7% | | 1.01 | 1.29 | 615.42 |
| 04-ruff-noqa/real | 84 | 555.27 ± 0.1% | not timed | not timed | 469.11 ± 0.1% | 19.10 ± 1.1% | not timed | not timed | 555.76 ± 0.1% | | 1.00 | 1.18 | 29.06 |
| 04-ruff-noqa/tweaked | 44 | 559.71 ± 0.5% | not timed | not timed | 467.16 ± 0.1% | 365.74 ± 0.4% | not timed | not timed | 557.40 ± 1.4% | | 1.00 | 1.20 | 1.53 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.5% | not timed | not timed | 5.25 ± 0.1% | 0.21 ± 2.3% | not timed | not timed | 3.65 ± 2.3% | | 0.96 | 0.67 | 17.01 |
| 06-cloud-flare-redos/original | 107 | 184.81 ± 1.0% | not timed | not timed | 215.18 ± 0.1% | 24.87 ± 0.2% | not timed | not timed | 184.35 ± 0.5% | | 1.00 | 0.86 | 7.43 |
| 06-cloud-flare-redos/simplified-short | 102 | 142.24 ± 0.6% | not timed | not timed | 228.55 ± 0.3% | 26.79 ± 9.3% | not timed | not timed | 144.92 ± 23.2% | | 0.98 | 0.62 | 5.31 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.74 ± 1.7% | not timed | not timed | 256.94 ± 0.2% | 28.81 ± 4.8% | not timed | not timed | 154.69 ± 2.9% | | 1.00 | 0.60 | 5.37 |
| 07-unicode-character-data/parse-line | 558784 | 232.82 ± 1.0% | not timed | not timed | 178.74 ± 0.2% | 42.81 ± 5.3% | not timed | not timed | 227.77 ± 1.0% | | 1.02 | 1.30 | 5.44 |
| 08-words/all-english | 56691 | 103.57 ± 0.3% | not timed | not timed | 83.51 ± 0.3% | 11.81 ± 8.8% | not timed | not timed | 102.86 ± 0.3% | | 1.01 | 1.24 | 8.77 |
| 08-words/long-english | 839 | 998.89 ± 0.1% | not timed | not timed | 597.56 ± 0.1% | 32.55 ± 0.5% | not timed | not timed | 997.96 ± 0.1% | | 1.00 | 1.67 | 30.69 |
| 09-aws-keys/full | 0 | 424.94 ± 0.1% | not timed | not timed | 478.65 ± 0.1% | 66.95 ± 3.6% | not timed | not timed | 425.06 ± 0.1% | | 1.00 | 0.89 | 6.35 |
| 09-aws-keys/quick | 0 | 738.77 ± 0.2% | not timed | not timed | 998.56 ± 0.1% | 418.38 ± 0.4% | not timed | not timed | 734.69 ± 0.2% | | 1.01 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 587.62 ± 0.4% | not timed | not timed | 516.93 ± 1.2% | 19.47 ± 0.6% | not timed | not timed | 585.76 ± 0.3% | | 1.00 | 1.14 | 30.18 |
| 10-bounded-repeat/letters-ru | 3475 | 391.20 ± 0.2% | not timed | not timed | 480.43 ± 0.1% | 21.72 ± 17.3% | not timed | not timed | 400.92 ± 0.5% | | 0.98 | 0.81 | 18.01 |
| 10-bounded-repeat/context | 53 | 79.31 ± 1.2% | not timed | not timed | 65.71 ± 0.3% | 19.78 ± 0.2% | not timed | not timed | 79.55 ± 0.7% | | 1.00 | 1.21 | 4.01 |
| 10-bounded-repeat/capitals | 11 | 1046.53 ± 0.2% | not timed | not timed | 618.39 ± 0.0% | 36.23 ± 0.0% | not timed | not timed | 1046.56 ± 0.1% | | 1.00 | 1.69 | 28.89 |
| 11-unstructured-to-json/extract | 600 | 47.79 ± 0.1% | not timed | not timed | 76.97 ± 0.1% | 48.62 ± 0.4% | not timed | not timed | 47.53 ± 0.4% | | 1.01 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 603.66 ± 0.5% | not timed | not timed | 554.88 ± 0.2% | 0.40 ± 0.0% | not timed | not timed | 604.23 ± 0.2% | | 1.00 | 1.09 | 1510.75 |
| 14-quadratic/1x | 100 | 12.62 ± 0.4% | not timed | not timed | 10.01 ± 0.1% | 0.98 ± 3.6% | not timed | not timed | 12.55 ± 1.0% | | 1.01 | 1.26 | 12.94 |
| 14-quadratic/2x | 200 | 7.83 ± 0.4% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.5% | not timed | not timed | 7.78 ± 1.7% | | 1.01 | 1.41 | 14.79 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 2.2% | not timed | not timed | 1.87 ± 0.3% | | 1.00 | 1.54 | 16.13 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.44 ± 0.2% | not timed | not timed | 0.34 ± 0.5% | 0.53 ± 4.9% | not timed | not timed | 1.43 ± 1.5% | | 1.01 | 4.23 | 2.70 |
| 04-ruff-noqa/compile-real | 1 | 92.92 ± 0.2% | not timed | not timed | 13.84 ± 0.9% | 136.34 ± 2.3% | not timed | not timed | 92.96 ± 1.1% | | 1.00 | 6.71 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 14.56 ± 0.1% | not timed | not timed | 2.51 ± 0.7% | 6.30 ± 3.3% | not timed | not timed | 14.50 ± 1.1% | | 1.00 | 5.79 | 2.31 |
| 07-unicode-character-data/compile | 1 | 58.46 ± 0.7% | not timed | not timed | 26.13 ± 0.3% | 35.42 ± 4.5% | not timed | not timed | 58.38 ± 1.0% | | 1.00 | 2.24 | 1.65 |
| 09-aws-keys/compile-full | 1 | 43.65 ± 1.3% | not timed | not timed | 8.28 ± 0.2% | 22.88 ± 2.9% | not timed | not timed | 43.38 ± 1.0% | | 1.01 | 5.27 | 1.91 |
| 09-aws-keys/compile-quick | 1 | 187.73 ± 0.1% | not timed | not timed | 47.77 ± 0.4% | 130.99 ± 8.2% | not timed | not timed | 188.59 ± 0.3% | | 1.00 | 3.93 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.61 ± 1.0% | not timed | not timed | 11.17 ± 0.2% | 15.46 ± 2.8% | not timed | not timed | 14.50 ± 0.8% | | 1.01 | 1.31 | 0.94 |
| 10-bounded-repeat/compile-capitals | 1 | 85.31 ± 1.6% | not timed | not timed | 7.99 ± 0.2% | 23.23 ± 1.0% | not timed | not timed | 85.10 ± 1.2% | | 1.00 | 10.68 | 3.67 |
| 11-unstructured-to-json/compile | 1 | 90.61 ± 0.2% | not timed | not timed | 40.74 ± 0.1% | 66.36 ± 3.3% | not timed | not timed | 90.56 ± 0.2% | | 1.00 | 2.22 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 19.7% | not timed | not timed | 0.36 ± 1.9% | | 1.01 | 5.35 | 3.70 |

