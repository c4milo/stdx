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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148066797 |
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
| literal: a word | 217 | 16013.12 ± 4.3% | 1039.43 ± 0.2% | 28.88 ± 0.4% | 18313.80 ± 3.0% | 9005.90 ± 9.9% | 17.32 ± 0.3% | 87.00 ± 0.4% | 16017.35 ± 1.9% | 15.41 | 1.00 | 0.87 | 1.78 |
| literal: a word that is not there | 0 | 18808.37 ± 3.9% | 1047.90 ± 0.2% | 28.89 ± 0.2% | 19909.24 ± 3.8% | 28890.09 ± 3.3% | 17.08 ± 0.4% | 82.96 ± 0.2% | 18806.75 ± 1.6% | 17.95 | 1.00 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6058.17 ± 0.5% | 1023.52 ± 0.1% | 14.74 ± 0.2% | 3947.80 ± 0.2% | 21.90 ± 0.0% | 5.43 ± 0.1% | 6.95 ± 0.9% | 6045.41 ± 0.2% | 5.92 | 1.00 | 1.53 | 276.62 |
| literal: a word in any case | 217 | 12572.65 ± 1.1% | 1039.70 ± 0.2% | 21.95 ± 0.8% | 3964.87 ± 0.2% | 37.89 ± 0.8% | refused | differs | 12564.90 ± 0.4% | 12.09 | 1.00 | 3.17 | 331.80 |
| literal: an href attribute | 33 | 13698.85 ± 0.7% | 1047.04 ± 0.2% | 27.55 ± 0.2% | 16831.60 ± 1.9% | 2262.28 ± 5.5% | 13.11 ± 0.2% | 75.81 ± 0.1% | 13646.35 ± 0.7% | 13.08 | 1.00 | 0.81 | 6.06 |
| literal: a word, second text | 123 | 16274.46 ± 0.5% | 1044.17 ± 0.1% | 28.38 ± 0.2% | 18288.89 ± 1.8% | 7734.55 ± 2.5% | 20.02 ± 0.5% | 71.06 ± 0.3% | 16262.11 ± 0.4% | 15.59 | 1.00 | 0.89 | 2.10 |
| class: two capitalized words | 1331 | 1105.97 ± 0.3% | 978.60 ± 0.2% | 26.22 ± 0.1% | 585.37 ± 0.1% | 40.53 ± 4.3% | 14.66 ± 0.3% | 68.93 ± 0.3% | 1105.42 ± 0.7% | 1.13 | 1.00 | 1.89 | 27.29 |
| class: a word that ends in ing | 3399 | 895.34 ± 0.2% | 895.01 ± 0.2% | 18.27 ± 0.1% | 548.08 ± 0.1% | 29.61 ± 12.5% | 8.19 ± 0.1% | 18.40 ± 0.5% | 894.05 ± 0.8% | 1.00 | 1.00 | 1.63 | 30.24 |
| class: a word in capitals | 2332 | 1454.81 ± 0.3% | 949.37 ± 0.2% | 27.96 ± 0.2% | 572.70 ± 0.1% | 43.53 ± 0.2% | 17.08 ± 0.1% | 83.34 ± 0.1% | 1452.11 ± 0.7% | 1.53 | 1.00 | 2.54 | 33.42 |
| class: a number | 8288 | 1989.58 ± 0.6% | 836.13 ± 0.1% | 28.15 ± 0.3% | 1721.63 ± 0.3% | 40.25 ± 15.6% | 0.55 ± 0.1% | 56.51 ± 0.6% | 1982.80 ± 0.1% | 2.38 | 1.00 | 1.16 | 49.44 |
| class: two capitalized words, second text | 5359 | 744.02 ± 0.1% | 744.35 ± 0.1% | 23.50 ± 0.2% | 483.88 ± 0.1% | 34.33 ± 10.4% | 17.05 ± 0.2% | 63.96 ± 0.3% | 743.93 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.67 |
| other: a word between two words | 6104 | 750.40 ± 0.4% | 777.14 ± 0.1% | 23.72 ± 0.2% | 739.19 ± 0.3% | 108.52 ± 13.9% | 11.14 ± 0.1% | 69.91 ± 0.2% | 755.70 ± 0.4% | 0.97 | 0.99 | 1.02 | 6.91 |
| other: a number before a unit, second text | 1481 | 5425.68 ± 0.5% | 984.83 ± 0.1% | 26.15 ± 0.2% | 5625.97 ± 0.7% | 40.73 ± 9.2% | 18.20 ± 0.5% | 67.13 ± 0.5% | 5431.08 ± 0.6% | 5.51 | 1.00 | 0.96 | 133.21 |
| other: a heading's start tag | 110 | 12505.27 ± 1.2% | 1036.29 ± 0.1% | 27.64 ± 0.3% | 1713.75 ± 0.2% | 1587.03 ± 6.7% | 16.09 ± 0.6% | 89.04 ± 0.2% | 12533.82 ± 1.1% | 12.07 | 1.00 | 7.30 | 7.88 |
| other: a whole word | 217 | 13998.37 ± 1.6% | 1038.66 ± 0.5% | 29.84 ± 0.3% | 14486.28 ± 1.1% | 49.43 ± 0.2% | 13.22 ± 0.1% | 56.35 ± 0.1% | 13920.60 ± 2.5% | 13.48 | 1.01 | 0.97 | 283.22 |
| other: a line's first word, second text | 3716 | 1976.21 ± 0.8% | 877.07 ± 0.1% | 31.42 ± 0.2% | 1720.60 ± 0.2% | 61.68 ± 7.1% | refused | refused | 1961.58 ± 0.7% | 2.25 | 1.01 | 1.15 | 32.04 |
| other: fourteen octets before an x | 87 | 19309.18 ± 1.4% | 230.79 ± 1.8% | 6.60 ± 0.2% | 3932.98 ± 0.2% | 10.66 ± 0.1% | differs | 17.82 ± 0.3% | 19513.37 ± 1.4% | 83.66 | 0.99 | 4.91 | 1811.40 |
| other: a Greek word | 21815 | 514.56 ± 0.5% | 414.53 ± 0.2% | 31.33 ± 0.3% | 289.95 ± 0.4% | 48.29 ± 11.1% | differs | refused | 513.92 ± 0.4% | 1.24 | 1.00 | 1.77 | 10.66 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.2% | 25.90 ± 0.2% | 0.87 ± 0.1% | 19.84 ± 0.6% | 2.78 ± 0.4% | differs | 4.01 ± 0.1% | 25.89 ± 0.3% | 1.00 | 1.00 | 1.30 | 9.32 |
| a UUID | 32895 | 21.07 ± 0.3% | 21.18 ± 0.4% | 0.65 ± 0.2% | 15.13 ± 0.5% | 3.12 ± 0.1% | 0.73 ± 0.3% | 3.61 ± 0.5% | 21.12 ± 0.5% | 0.99 | 1.00 | 1.39 | 6.75 |
| an IPv4 address | 33176 | 36.95 ± 0.2% | 36.98 ± 0.2% | 2.11 ± 1.2% | 29.45 ± 0.3% | 6.67 ± 0.1% | differs | 4.19 ± 0.2% | 36.96 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.54 |
| a date and time | 32954 | 30.81 ± 0.3% | 31.24 ± 0.4% | 1.48 ± 0.1% | 21.48 ± 0.6% | 7.06 ± 0.1% | 1.25 ± 0.4% | 7.19 ± 0.4% | 31.30 ± 0.4% | 0.99 | 0.98 | 1.43 | 4.37 |
| a field path | 32606 | 29.51 ± 0.2% | 29.46 ± 0.3% | 1.04 ± 0.2% | 23.34 ± 0.2% | 3.49 ± 0.5% | differs | 2.93 ± 0.2% | 29.55 ± 0.1% | 1.00 | 1.00 | 1.26 | 8.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.4% | 11.45 ± 0.3% | 11.50 ± 0.5% | 11.82 ± 0.4% | 4.95 ± 2.4% | 0.93 ± 0.7% | none | 11.47 ± 0.3% | 1.00 | 1.00 | 0.97 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.77 ± 0.3% | 236.24 ± 0.3% | 285.33 ± 0.3% | 86.38 ± 0.5% | 220.54 ± 0.7% | 484.30 ± 0.9% | 3858.61 ± 2.2% | 233.65 ± 0.1% | 0.99 | 1.00 | 2.71 | 1.06 |
| a UUID | 62 | 156.60 ± 0.2% | 156.97 ± 0.2% | 177.74 ± 0.0% | 46.27 ± 0.6% | 98.45 ± 1.0% | 187.88 ± 3.2% | 4434.11 ± 0.8% | 156.62 ± 0.2% | 1.00 | 1.00 | 3.38 | 1.59 |
| an IPv4 address | 29 | 419.65 ± 0.2% | 426.32 ± 0.1% | 611.45 ± 0.5% | 76.74 ± 0.2% | 131.46 ± 1.4% | 300.31 ± 1.6% | 7642.62 ± 0.1% | 419.57 ± 0.5% | 0.98 | 1.00 | 5.47 | 3.19 |
| a date and time | 56 | 302.53 ± 0.3% | 305.69 ± 0.2% | 388.79 ± 0.1% | 72.57 ± 0.2% | 137.03 ± 2.8% | 327.03 ± 1.4% | 4916.91 ± 0.7% | 302.09 ± 0.2% | 0.99 | 1.00 | 4.17 | 2.21 |
| a field path | 39 | 226.85 ± 0.2% | 228.70 ± 0.3% | 274.01 ± 0.2% | 80.38 ± 0.9% | 205.52 ± 1.5% | 503.02 ± 4.9% | 4938.56 ± 3.3% | 226.80 ± 0.2% | 0.99 | 1.00 | 2.82 | 1.10 |
| literal: a word | 7 | 624.06 ± 0.8% | 669.81 ± 0.3% | 1246.45 ± 0.9% | 505.97 ± 0.2% | 627.21 ± 2.2% | 953.41 ± 0.6% | 30438.74 ± 0.3% | 623.85 ± 0.8% | 0.93 | 1.00 | 1.23 | 0.99 |
| literal: a word that is not there | 8 | 598.81 ± 0.3% | 648.23 ± 0.4% | 1174.77 ± 0.2% | 456.08 ± 0.4% | 599.26 ± 1.3% | 907.34 ± 0.6% | 29071.59 ± 0.1% | 598.56 ± 0.2% | 0.92 | 1.00 | 1.31 | 1.00 |
| literal: one of four words | 26 | 240.26 ± 0.2% | 398.60 ± 0.2% | 555.36 ± 0.2% | 50.26 ± 1.0% | 241.72 ± 1.5% | 381.72 ± 1.5% | 15648.25 ± 0.3% | 240.17 ± 0.2% | 0.60 | 1.00 | 4.78 | 0.99 |
| literal: a word in any case | 11 | 481.16 ± 0.5% | 514.90 ± 0.3% | 827.48 ± 0.4% | 15.77 ± 1.5% | 649.70 ± 1.3% | refused | 23693.10 ± 0.4% | 481.49 ± 0.5% | 0.93 | 1.00 | 30.52 | 0.74 |
| literal: an href attribute | 12 | 348.35 ± 0.2% | 361.31 ± 0.5% | 490.70 ± 0.3% | 42.23 ± 0.4% | 496.37 ± 1.1% | 780.80 ± 1.0% | 21653.99 ± 0.2% | 349.01 ± 0.5% | 0.96 | 1.00 | 8.25 | 0.70 |
| literal: a word, second text | 10 | 562.42 ± 0.4% | 618.41 ± 0.4% | 1065.88 ± 0.2% | 388.88 ± 0.1% | 531.67 ± 2.0% | 810.27 ± 0.2% | 26973.21 ± 0.1% | 561.79 ± 0.2% | 0.91 | 1.00 | 1.45 | 1.06 |
| class: two capitalized words | 23 | 435.61 ± 0.2% | 464.28 ± 0.4% | 692.20 ± 0.6% | 100.11 ± 0.1% | 500.19 ± 1.5% | 744.32 ± 0.5% | 6600.24 ± 0.1% | 434.59 ± 0.4% | 0.94 | 1.00 | 4.35 | 0.87 |
| class: a word that ends in ing | 9 | 564.88 ± 0.7% | 632.72 ± 0.6% | 1150.62 ± 0.4% | 130.78 ± 1.4% | 754.17 ± 2.2% | 1115.51 ± 0.6% | 16129.89 ± 0.1% | 564.43 ± 0.5% | 0.89 | 1.00 | 4.32 | 0.75 |
| class: a word in capitals | 16 | 499.83 ± 0.4% | 536.97 ± 0.4% | 892.37 ± 0.3% | 135.32 ± 1.1% | 744.68 ± 1.3% | 1034.36 ± 1.7% | 8680.69 ± 0.1% | 499.76 ± 0.2% | 0.93 | 1.00 | 3.69 | 0.67 |
| class: a number | 6 | 629.95 ± 0.3% | 695.44 ± 0.8% | 1369.63 ± 0.1% | 41.36 ± 0.9% | 1391.12 ± 0.6% | 1860.97 ± 1.2% | 22855.23 ± 0.5% | 630.25 ± 0.1% | 0.91 | 1.00 | 15.23 | 0.45 |
| class: two capitalized words, second text | 23 | 434.41 ± 0.6% | 463.51 ± 0.8% | 692.99 ± 0.5% | 101.81 ± 0.6% | 499.75 ± 1.1% | 767.41 ± 0.9% | 6604.10 ± 0.1% | 435.30 ± 0.3% | 0.94 | 1.00 | 4.27 | 0.87 |
| other: a word between two words | 13 | 546.28 ± 0.2% | 564.88 ± 0.5% | 925.59 ± 0.1% | 133.19 ± 0.5% | 500.55 ± 6.7% | 811.81 ± 0.5% | 14986.92 ± 0.1% | 545.83 ± 0.4% | 0.97 | 1.00 | 4.10 | 1.09 |
| other: a number before a unit, second text | 15 | 406.08 ± 0.6% | 446.02 ± 0.5% | 644.77 ± 0.3% | 39.04 ± 0.5% | 629.81 ± 1.2% | 899.24 ± 1.0% | 15209.15 ± 0.3% | 407.25 ± 0.3% | 0.91 | 1.00 | 10.40 | 0.64 |
| other: a heading's start tag | 13 | 358.14 ± 0.5% | 363.93 ± 0.5% | 493.82 ± 0.2% | 43.48 ± 0.6% | 625.10 ± 1.8% | 863.73 ± 0.1% | 18108.34 ± 0.4% | 357.71 ± 0.3% | 0.98 | 1.00 | 8.24 | 0.57 |
| other: a whole word | 11 | 583.18 ± 0.3% | 617.73 ± 0.3% | 1072.56 ± 0.6% | 117.59 ± 0.4% | 562.79 ± 1.1% | 828.12 ± 1.2% | 26999.31 ± 0.2% | 582.80 ± 0.6% | 0.94 | 1.00 | 4.96 | 1.04 |
| other: a line's first word, second text | 17 | 535.08 ± 0.2% | 554.95 ± 0.3% | 929.56 ± 0.3% | 129.56 ± 0.1% | 708.33 ± 0.9% | refused | refused | 533.60 ± 0.6% | 0.96 | 1.00 | 4.13 | 0.76 |
| other: fourteen octets before an x | 16 | 112.10 ± 0.3% | 162.58 ± 0.5% | 190.02 ± 0.7% | 14.91 ± 0.5% | 454.33 ± 2.5% | 415.41 ± 1.2% | 12686.34 ± 0.5% | 111.95 ± 0.4% | 0.69 | 1.00 | 7.52 | 0.25 |
| other: a Greek word | 8 | 431.00 ± 0.4% | 593.26 ± 0.4% | 1042.20 ± 0.1% | 58.78 ± 0.5% | 1391.46 ± 1.6% | 1803.80 ± 0.8% | refused | 430.83 ± 0.2% | 0.73 | 1.00 | 7.33 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12658.69 ± 0.7% | not timed | not timed | 15931.62 ± 2.7% | 1964.08 ± 15.5% | not timed | not timed | 12693.54 ± 0.3% | | 1.00 | 0.79 | 6.45 |
| 01-literal/sherlock-casei-en | 522 | 4494.46 ± 1.1% | not timed | not timed | 3582.41 ± 0.1% | 32.53 ± 0.1% | not timed | not timed | 4495.24 ± 0.2% | | 1.00 | 1.25 | 138.17 |
| 01-literal/sherlock-ru | 724 | 13502.67 ± 0.8% | not timed | not timed | 17305.48 ± 0.5% | 1452.89 ± 24.1% | not timed | not timed | 13508.72 ± 0.1% | | 1.00 | 0.78 | 9.29 |
| 01-literal/sherlock-casei-ru | 746 | 5296.42 ± 0.3% | not timed | not timed | 3329.16 ± 0.0% | 31.65 ± 0.5% | not timed | not timed | 5305.47 ± 0.2% | | 1.00 | 1.59 | 167.34 |
| 01-literal/sherlock-zh | 30 | 16838.75 ± 0.3% | not timed | not timed | 18436.39 ± 0.8% | 2687.97 ± 15.4% | not timed | not timed | 16770.85 ± 0.4% | | 1.00 | 0.91 | 6.26 |
| 02-literal-alternate/sherlock-en | 714 | 5732.02 ± 0.9% | not timed | not timed | 3929.20 ± 0.9% | 16.61 ± 0.1% | not timed | not timed | 5739.18 ± 1.0% | | 1.00 | 1.46 | 345.10 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1709.74 ± 1.0% | not timed | not timed | 697.79 ± 0.3% | 11.10 ± 0.2% | not timed | not timed | 1703.98 ± 0.3% | | 1.00 | 2.45 | 154.08 |
| 02-literal-alternate/sherlock-ru | 899 | 4647.72 ± 0.3% | not timed | not timed | 3253.25 ± 0.2% | 22.64 ± 0.1% | not timed | not timed | 4656.72 ± 0.2% | | 1.00 | 1.43 | 205.32 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1810.61 ± 0.7% | not timed | not timed | 1222.25 ± 0.4% | 9.13 ± 0.1% | not timed | not timed | 1807.38 ± 0.5% | | 1.00 | 1.48 | 198.37 |
| 02-literal-alternate/sherlock-zh | 207 | 6993.82 ± 0.7% | not timed | not timed | 4159.31 ± 0.1% | 31.45 ± 0.1% | not timed | not timed | 7000.13 ± 0.6% | | 1.00 | 1.68 | 222.38 |
| 03-date/ascii | 111817 | 127.39 ± 0.1% | not timed | not timed | 96.18 ± 0.3% | 0.20 ± 8.3% | not timed | not timed | 126.62 ± 1.4% | | 1.01 | 1.32 | 629.42 |
| 04-ruff-noqa/real | 84 | 553.84 ± 5.2% | not timed | not timed | 476.53 ± 0.1% | 19.56 ± 0.2% | not timed | not timed | 553.90 ± 7.0% | | 1.00 | 1.16 | 28.32 |
| 04-ruff-noqa/tweaked | 44 | 548.03 ± 0.1% | not timed | not timed | 462.95 ± 0.1% | 366.29 ± 0.5% | not timed | not timed | 546.53 ± 0.2% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 4.19 ± 0.3% | not timed | not timed | 5.13 ± 0.3% | 0.20 ± 1.8% | not timed | not timed | 4.24 ± 4.9% | | 0.99 | 0.82 | 20.53 |
| 06-cloud-flare-redos/original | 107 | 263.85 ± 0.1% | not timed | not timed | 217.30 ± 0.1% | 24.89 ± 0.3% | not timed | not timed | 263.54 ± 0.2% | | 1.00 | 1.21 | 10.60 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.57 ± 0.2% | not timed | not timed | 226.46 ± 0.1% | 26.73 ± 0.4% | not timed | not timed | 259.31 ± 0.1% | | 1.00 | 1.15 | 9.71 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.19 ± 0.2% | not timed | not timed | 255.82 ± 0.2% | 28.82 ± 0.1% | not timed | not timed | 286.35 ± 0.2% | | 1.00 | 1.12 | 9.93 |
| 07-unicode-character-data/parse-line | 558784 | 234.76 ± 2.3% | not timed | not timed | 179.48 ± 0.1% | 42.89 ± 5.4% | not timed | not timed | 230.28 ± 2.1% | | 1.02 | 1.31 | 5.47 |
| 08-words/all-english | 56691 | 121.06 ± 0.4% | not timed | not timed | 83.41 ± 0.2% | 13.09 ± 2.7% | not timed | not timed | 120.78 ± 0.2% | | 1.00 | 1.45 | 9.25 |
| 08-words/long-english | 839 | 1006.10 ± 0.1% | not timed | not timed | 597.91 ± 0.2% | 32.21 ± 0.3% | not timed | not timed | 1006.17 ± 0.0% | | 1.00 | 1.68 | 31.24 |
| 09-aws-keys/full | 0 | 409.18 ± 0.1% | not timed | not timed | 489.76 ± 0.1% | 64.65 ± 3.4% | not timed | not timed | 409.09 ± 0.0% | | 1.00 | 0.84 | 6.33 |
| 09-aws-keys/quick | 0 | 739.83 ± 0.2% | not timed | not timed | 997.63 ± 0.2% | 420.95 ± 1.7% | not timed | not timed | 738.55 ± 0.3% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 636.93 ± 0.3% | not timed | not timed | 516.82 ± 0.6% | 19.32 ± 0.5% | not timed | not timed | 635.30 ± 0.2% | | 1.00 | 1.23 | 32.97 |
| 10-bounded-repeat/letters-ru | 3475 | 384.73 ± 0.2% | not timed | not timed | 477.96 ± 0.1% | 21.84 ± 8.3% | not timed | not timed | 382.06 ± 0.4% | | 1.01 | 0.80 | 17.61 |
| 10-bounded-repeat/context | 53 | 78.93 ± 1.2% | not timed | not timed | 66.13 ± 0.4% | 19.83 ± 0.2% | not timed | not timed | 78.98 ± 1.0% | | 1.00 | 1.19 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 1041.94 ± 0.1% | not timed | not timed | 615.80 ± 0.1% | 36.59 ± 0.1% | not timed | not timed | 1041.97 ± 0.1% | | 1.00 | 1.69 | 28.47 |
| 11-unstructured-to-json/extract | 600 | 49.22 ± 0.2% | not timed | not timed | 76.85 ± 0.2% | 48.87 ± 1.0% | not timed | not timed | 48.38 ± 1.0% | | 1.02 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 566.80 ± 0.4% | not timed | not timed | 562.64 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 567.67 ± 0.2% | | 1.00 | 1.01 | 1403.14 |
| 14-quadratic/1x | 100 | 9.67 ± 0.5% | not timed | not timed | 10.07 ± 0.2% | 0.98 ± 4.0% | not timed | not timed | 9.66 ± 1.0% | | 1.00 | 0.96 | 9.87 |
| 14-quadratic/2x | 200 | 5.55 ± 1.1% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.6% | not timed | not timed | 5.55 ± 0.9% | | 1.00 | 1.00 | 10.45 |
| 14-quadratic/10x | 1000 | 1.26 ± 1.0% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 1.26 ± 0.1% | | 1.00 | 1.04 | 10.92 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.44 ± 0.1% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 3.9% | not timed | not timed | 1.44 ± 0.9% | | 1.00 | 4.21 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 92.73 ± 0.2% | not timed | not timed | 13.81 ± 0.3% | 138.17 ± 1.8% | not timed | not timed | 92.48 ± 1.1% | | 1.00 | 6.72 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.69 ± 0.1% | not timed | not timed | 2.54 ± 0.7% | 6.46 ± 2.3% | not timed | not timed | 14.53 ± 1.2% | | 1.01 | 5.79 | 2.27 |
| 07-unicode-character-data/compile | 1 | 58.38 ± 0.2% | not timed | not timed | 26.00 ± 0.4% | 36.00 ± 3.1% | not timed | not timed | 58.47 ± 1.0% | | 1.00 | 2.24 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.80 ± 0.4% | not timed | not timed | 8.29 ± 0.3% | 23.20 ± 1.7% | not timed | not timed | 43.62 ± 0.4% | | 1.00 | 5.28 | 1.89 |
| 09-aws-keys/compile-quick | 1 | 187.78 ± 0.1% | not timed | not timed | 47.33 ± 0.1% | 133.60 ± 2.6% | not timed | not timed | 189.35 ± 1.2% | | 0.99 | 3.97 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.73 ± 1.1% | not timed | not timed | 11.11 ± 0.6% | 15.85 ± 1.8% | not timed | not timed | 14.57 ± 1.0% | | 1.01 | 1.33 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 85.97 ± 0.5% | not timed | not timed | 8.06 ± 0.4% | 23.65 ± 1.1% | not timed | not timed | 85.72 ± 1.2% | | 1.00 | 10.66 | 3.63 |
| 11-unstructured-to-json/compile | 1 | 90.87 ± 0.1% | not timed | not timed | 40.75 ± 0.2% | 68.31 ± 2.7% | not timed | not timed | 89.85 ± 1.2% | | 1.01 | 2.23 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 3.6% | 0.10 ± 6.0% | not timed | not timed | 0.36 ± 0.5% | | 1.01 | 5.31 | 3.73 |

