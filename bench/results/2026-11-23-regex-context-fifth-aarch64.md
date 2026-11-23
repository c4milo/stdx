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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117648292 |
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
| literal: a word | 217 | 16262.45 ± 1.0% | 1036.97 ± 0.1% | 28.24 ± 0.4% | 18327.88 ± 0.7% | 9251.52 ± 7.2% | 17.29 ± 0.4% | 86.59 ± 0.8% | 16234.98 ± 0.9% | 15.68 | 1.00 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18924.47 ± 1.3% | 1047.77 ± 0.2% | 28.30 ± 0.2% | 19966.15 ± 1.4% | 29365.63 ± 0.8% | 17.08 ± 0.1% | 82.67 ± 0.2% | 18986.41 ± 0.6% | 18.06 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6075.70 ± 0.6% | 1014.78 ± 0.3% | 14.54 ± 0.8% | 3943.59 ± 0.7% | 21.85 ± 0.2% | 5.42 ± 0.2% | 6.90 ± 1.1% | 6081.42 ± 0.3% | 5.99 | 1.00 | 1.54 | 278.04 |
| literal: a word in any case | 217 | 12560.21 ± 0.7% | 1037.69 ± 0.1% | 21.61 ± 2.3% | 3970.46 ± 0.2% | 38.07 ± 0.1% | refused | differs | 12555.81 ± 0.7% | 12.10 | 1.00 | 3.16 | 329.90 |
| literal: an href attribute | 33 | 13855.92 ± 0.5% | 1046.18 ± 0.2% | 27.06 ± 0.2% | 17062.82 ± 0.9% | 2264.41 ± 0.7% | 13.10 ± 0.1% | 75.69 ± 0.2% | 13865.42 ± 0.3% | 13.24 | 1.00 | 0.81 | 6.12 |
| literal: a word, second text | 123 | 16513.93 ± 0.9% | 1042.14 ± 0.2% | 28.00 ± 0.2% | 18448.38 ± 1.4% | 7745.59 ± 10.2% | 20.03 ± 1.1% | 70.77 ± 0.6% | 16531.46 ± 1.1% | 15.85 | 1.00 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1124.54 ± 0.6% | 953.79 ± 0.1% | 25.96 ± 0.2% | 585.43 ± 0.1% | 40.70 ± 12.9% | 14.64 ± 0.3% | 68.98 ± 0.2% | 1122.27 ± 0.5% | 1.18 | 1.00 | 1.92 | 27.63 |
| class: a word that ends in ing | 3399 | 876.06 ± 0.3% | 876.46 ± 0.2% | 17.99 ± 0.2% | 547.89 ± 0.1% | 29.65 ± 3.3% | 8.16 ± 0.2% | 18.46 ± 0.4% | 875.92 ± 0.0% | 1.00 | 1.00 | 1.60 | 29.54 |
| class: a word in capitals | 2332 | 1476.60 ± 0.3% | 937.08 ± 0.2% | 27.59 ± 0.4% | 572.45 ± 0.0% | 43.56 ± 2.9% | 17.04 ± 0.3% | 83.29 ± 0.3% | 1477.15 ± 0.3% | 1.58 | 1.00 | 2.58 | 33.90 |
| class: a number | 8288 | 2003.06 ± 0.2% | 786.93 ± 0.1% | 27.75 ± 0.5% | 1732.09 ± 0.2% | 40.53 ± 15.6% | 0.55 ± 0.1% | 56.97 ± 0.3% | 1990.34 ± 0.2% | 2.55 | 1.01 | 1.16 | 49.42 |
| class: two capitalized words, second text | 5359 | 683.30 ± 0.2% | 679.84 ± 0.1% | 23.25 ± 0.1% | 484.91 ± 0.1% | 35.12 ± 10.7% | 17.05 ± 0.5% | 64.10 ± 0.2% | 683.34 ± 0.1% | 1.01 | 1.00 | 1.41 | 19.46 |
| other: a word between two words | 6104 | 767.99 ± 0.2% | 738.83 ± 0.1% | 23.40 ± 0.2% | 736.17 ± 0.2% | 107.70 ± 15.2% | 11.14 ± 0.5% | 69.89 ± 0.2% | 767.31 ± 0.2% | 1.04 | 1.00 | 1.04 | 7.13 |
| other: a number before a unit, second text | 1481 | 5533.48 ± 1.1% | 972.92 ± 0.1% | 25.80 ± 0.2% | 5683.59 ± 0.2% | 40.84 ± 15.7% | 18.17 ± 0.4% | 66.95 ± 0.3% | 5584.14 ± 0.2% | 5.69 | 0.99 | 0.97 | 135.48 |
| other: a heading's start tag | 110 | 12718.68 ± 0.5% | 1035.38 ± 0.3% | 27.27 ± 0.2% | 1713.73 ± 0.2% | 1570.68 ± 5.2% | 16.09 ± 0.4% | 89.01 ± 0.6% | 12673.80 ± 1.0% | 12.28 | 1.00 | 7.42 | 8.10 |
| other: a whole word | 217 | 14088.37 ± 0.9% | 1036.90 ± 0.1% | 29.18 ± 0.2% | 14639.82 ± 0.5% | 49.18 ± 0.5% | 13.20 ± 0.2% | 56.41 ± 0.2% | 14076.50 ± 1.1% | 13.59 | 1.00 | 0.96 | 286.45 |
| other: a line's first word, second text | 3716 | 1982.06 ± 0.6% | 856.43 ± 0.1% | 30.81 ± 0.1% | 1721.30 ± 0.5% | 62.16 ± 6.7% | refused | refused | 1974.10 ± 0.4% | 2.31 | 1.00 | 1.15 | 31.89 |
| other: fourteen octets before an x | 87 | 19913.32 ± 0.7% | 247.52 ± 0.7% | 6.11 ± 0.1% | 4038.30 ± 1.8% | 10.48 ± 0.1% | differs | 17.79 ± 0.3% | 19950.33 ± 0.7% | 80.45 | 1.00 | 4.93 | 1900.66 |
| other: a Greek word | 21815 | 486.56 ± 0.4% | 308.89 ± 0.4% | 30.86 ± 0.4% | 290.57 ± 0.2% | 43.70 ± 10.5% | differs | refused | 483.97 ± 0.5% | 1.58 | 1.01 | 1.67 | 11.13 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.1% | 25.88 ± 0.1% | 0.82 ± 0.5% | 19.90 ± 0.1% | 2.77 ± 0.6% | differs | 4.01 ± 0.2% | 25.89 ± 0.1% | 1.00 | 1.00 | 1.30 | 9.33 |
| a UUID | 32895 | 21.14 ± 0.2% | 21.22 ± 0.3% | 0.65 ± 0.2% | 15.15 ± 0.3% | 3.12 ± 0.3% | 0.72 ± 0.1% | 3.61 ± 0.4% | 21.16 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.78 |
| an IPv4 address | 33176 | 36.81 ± 0.3% | 36.82 ± 0.3% | 2.11 ± 0.4% | 29.49 ± 0.3% | 6.68 ± 0.2% | differs | 4.15 ± 0.3% | 36.86 ± 0.1% | 1.00 | 1.00 | 1.25 | 5.51 |
| a date and time | 32954 | 30.97 ± 0.5% | 31.00 ± 0.2% | 1.47 ± 0.2% | 21.56 ± 0.2% | 7.06 ± 0.1% | 1.25 ± 0.3% | 7.14 ± 0.5% | 31.04 ± 0.3% | 1.00 | 1.00 | 1.44 | 4.38 |
| a field path | 32606 | 29.41 ± 0.2% | 29.41 ± 0.2% | 1.01 ± 0.3% | 23.38 ± 0.0% | 3.50 ± 0.5% | differs | 2.98 ± 0.3% | 29.45 ± 0.2% | 1.00 | 1.00 | 1.26 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.61 ± 1.3% | 11.62 ± 1.2% | 11.61 ± 1.4% | 11.84 ± 0.1% | 4.96 ± 1.2% | 0.93 ± 0.3% | none | 11.65 ± 0.6% | 1.00 | 1.00 | 0.98 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.05 ± 0.3% | 237.59 ± 0.3% | 286.80 ± 0.1% | 86.37 ± 0.6% | 223.10 ± 1.3% | 482.04 ± 1.1% | 3861.59 ± 1.5% | 236.16 ± 0.3% | 0.99 | 1.00 | 2.73 | 1.06 |
| a UUID | 62 | 157.57 ± 0.3% | 158.08 ± 0.1% | 178.71 ± 0.4% | 46.26 ± 0.9% | 100.09 ± 0.4% | 188.13 ± 3.2% | 4423.61 ± 2.1% | 157.56 ± 0.2% | 1.00 | 1.00 | 3.41 | 1.57 |
| an IPv4 address | 29 | 425.57 ± 0.5% | 431.06 ± 0.6% | 619.65 ± 0.5% | 76.40 ± 0.2% | 132.78 ± 0.9% | 299.80 ± 1.4% | 7643.27 ± 0.3% | 425.09 ± 0.4% | 0.99 | 1.00 | 5.57 | 3.20 |
| a date and time | 56 | 307.26 ± 1.1% | 310.35 ± 0.5% | 396.91 ± 0.2% | 72.47 ± 0.2% | 137.78 ± 1.7% | 327.44 ± 0.8% | 4898.20 ± 0.6% | 307.22 ± 0.1% | 0.99 | 1.00 | 4.24 | 2.23 |
| a field path | 39 | 227.99 ± 0.2% | 229.42 ± 0.4% | 274.26 ± 0.2% | 80.66 ± 0.7% | 207.01 ± 0.9% | 525.81 ± 6.2% | 4894.16 ± 1.9% | 227.84 ± 0.4% | 0.99 | 1.00 | 2.83 | 1.10 |
| literal: a word | 7 | 639.11 ± 0.6% | 685.24 ± 0.8% | 1292.83 ± 0.8% | 501.27 ± 2.0% | 633.81 ± 2.1% | 966.52 ± 0.8% | 30451.49 ± 0.1% | 637.65 ± 0.6% | 0.93 | 1.00 | 1.27 | 1.01 |
| literal: a word that is not there | 8 | 613.35 ± 0.4% | 664.62 ± 0.5% | 1217.74 ± 0.1% | 450.86 ± 0.3% | 612.15 ± 1.5% | 920.84 ± 0.5% | 29135.73 ± 0.1% | 613.83 ± 0.2% | 0.92 | 1.00 | 1.36 | 1.00 |
| literal: one of four words | 26 | 244.16 ± 0.3% | 408.41 ± 0.2% | 570.77 ± 0.4% | 50.14 ± 1.0% | 244.28 ± 2.1% | 384.70 ± 3.1% | 15646.10 ± 0.1% | 244.23 ± 0.2% | 0.60 | 1.00 | 4.87 | 1.00 |
| literal: a word in any case | 11 | 494.18 ± 0.4% | 527.62 ± 0.6% | 852.17 ± 0.2% | 15.36 ± 0.6% | 664.83 ± 10.9% | refused | 23717.83 ± 0.6% | 494.18 ± 0.2% | 0.94 | 1.00 | 32.18 | 0.74 |
| literal: an href attribute | 12 | 353.37 ± 0.5% | 366.57 ± 0.3% | 495.21 ± 0.5% | 44.61 ± 1.2% | 505.92 ± 1.9% | 786.22 ± 0.5% | 21668.29 ± 0.6% | 353.47 ± 0.4% | 0.96 | 1.00 | 7.92 | 0.70 |
| literal: a word, second text | 10 | 571.43 ± 0.5% | 628.79 ± 0.3% | 1094.16 ± 0.3% | 394.82 ± 0.1% | 540.05 ± 2.5% | 816.38 ± 0.3% | 27095.01 ± 0.1% | 570.80 ± 0.4% | 0.91 | 1.00 | 1.45 | 1.06 |
| class: two capitalized words | 23 | 443.63 ± 0.4% | 472.65 ± 0.2% | 709.75 ± 0.3% | 99.38 ± 0.3% | 503.80 ± 4.2% | 752.71 ± 1.1% | 6585.39 ± 0.5% | 443.92 ± 0.1% | 0.94 | 1.00 | 4.46 | 0.88 |
| class: a word that ends in ing | 9 | 574.98 ± 0.5% | 642.31 ± 1.0% | 1176.79 ± 0.1% | 132.17 ± 1.1% | 765.61 ± 4.9% | 1074.20 ± 0.7% | 16125.50 ± 0.3% | 574.39 ± 0.4% | 0.90 | 1.00 | 4.35 | 0.75 |
| class: a word in capitals | 16 | 507.60 ± 0.8% | 544.42 ± 0.7% | 905.96 ± 1.4% | 134.60 ± 0.6% | 759.32 ± 1.5% | 1027.12 ± 1.7% | 8692.24 ± 0.8% | 507.23 ± 0.7% | 0.93 | 1.00 | 3.77 | 0.67 |
| class: a number | 6 | 638.37 ± 0.2% | 704.24 ± 0.5% | 1385.91 ± 0.3% | 41.84 ± 0.7% | 1417.97 ± 2.0% | 1845.43 ± 1.4% | 22803.48 ± 0.2% | 638.06 ± 0.3% | 0.91 | 1.00 | 15.26 | 0.45 |
| class: two capitalized words, second text | 23 | 444.27 ± 0.3% | 472.68 ± 0.3% | 710.29 ± 0.2% | 99.23 ± 1.0% | 507.57 ± 0.8% | 736.98 ± 3.8% | 6591.65 ± 0.2% | 444.36 ± 0.4% | 0.94 | 1.00 | 4.48 | 0.88 |
| other: a word between two words | 13 | 561.97 ± 0.6% | 580.78 ± 1.0% | 967.34 ± 0.2% | 132.59 ± 1.1% | 508.79 ± 1.2% | 806.66 ± 0.5% | 14925.51 ± 0.2% | 562.24 ± 0.4% | 0.97 | 1.00 | 4.24 | 1.10 |
| other: a number before a unit, second text | 15 | 410.47 ± 0.4% | 449.16 ± 0.2% | 652.94 ± 0.3% | 39.28 ± 0.5% | 636.44 ± 0.9% | 886.47 ± 0.4% | 15187.82 ± 0.3% | 410.30 ± 0.2% | 0.91 | 1.00 | 10.45 | 0.64 |
| other: a heading's start tag | 13 | 361.85 ± 0.4% | 367.78 ± 0.4% | 498.87 ± 0.2% | 43.10 ± 0.4% | 634.38 ± 1.4% | 874.62 ± 1.0% | 18057.54 ± 0.2% | 361.60 ± 0.2% | 0.98 | 1.00 | 8.40 | 0.57 |
| other: a whole word | 11 | 596.29 ± 0.3% | 632.11 ± 0.7% | 1099.62 ± 0.2% | 117.61 ± 0.4% | 566.47 ± 1.7% | 836.10 ± 0.8% | 26962.81 ± 0.8% | 596.82 ± 0.2% | 0.94 | 1.00 | 5.07 | 1.05 |
| other: a line's first word, second text | 17 | 543.81 ± 0.4% | 564.70 ± 0.7% | 946.04 ± 0.6% | 129.84 ± 0.1% | 712.80 ± 1.6% | refused | refused | 542.77 ± 0.7% | 0.96 | 1.00 | 4.19 | 0.76 |
| other: fourteen octets before an x | 16 | 111.71 ± 0.7% | 162.02 ± 0.5% | 189.29 ± 0.3% | 14.69 ± 0.4% | 458.14 ± 0.9% | 406.24 ± 0.5% | 12656.02 ± 0.6% | 111.60 ± 0.3% | 0.69 | 1.00 | 7.61 | 0.24 |
| other: a Greek word | 8 | 434.14 ± 0.4% | 599.79 ± 0.5% | 1055.64 ± 0.1% | 58.94 ± 0.6% | 1408.45 ± 1.0% | 1841.31 ± 0.6% | refused | 434.08 ± 0.1% | 0.72 | 1.00 | 7.37 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 13041.48 ± 0.5% | not timed | not timed | 16433.16 ± 1.5% | 2066.69 ± 13.1% | not timed | not timed | 13061.95 ± 0.6% | | 1.00 | 0.79 | 6.31 |
| 01-literal/sherlock-casei-en | 522 | 3912.36 ± 0.5% | not timed | not timed | 3591.68 ± 0.3% | 32.42 ± 0.2% | not timed | not timed | 3903.98 ± 0.2% | | 1.00 | 1.09 | 120.67 |
| 01-literal/sherlock-ru | 724 | 13632.06 ± 0.7% | not timed | not timed | 17329.78 ± 0.5% | 1343.17 ± 7.5% | not timed | not timed | 13613.01 ± 0.6% | | 1.00 | 0.79 | 10.15 |
| 01-literal/sherlock-casei-ru | 746 | 5313.00 ± 0.2% | not timed | not timed | 3332.21 ± 0.1% | 30.54 ± 0.1% | not timed | not timed | 5318.97 ± 0.2% | | 1.00 | 1.59 | 173.98 |
| 01-literal/sherlock-zh | 30 | 17149.49 ± 0.3% | not timed | not timed | 19017.12 ± 0.5% | 2390.11 ± 17.6% | not timed | not timed | 17160.79 ± 0.3% | | 1.00 | 0.90 | 7.18 |
| 02-literal-alternate/sherlock-en | 714 | 5821.77 ± 0.5% | not timed | not timed | 3938.77 ± 0.2% | 16.64 ± 0.1% | not timed | not timed | 5800.75 ± 0.3% | | 1.00 | 1.48 | 349.87 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1683.00 ± 1.1% | not timed | not timed | 697.69 ± 0.4% | 11.05 ± 0.1% | not timed | not timed | 1678.27 ± 0.4% | | 1.00 | 2.41 | 152.30 |
| 02-literal-alternate/sherlock-ru | 899 | 4720.98 ± 0.2% | not timed | not timed | 3255.97 ± 0.1% | 22.65 ± 0.1% | not timed | not timed | 4729.11 ± 0.3% | | 1.00 | 1.45 | 208.46 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1795.37 ± 0.4% | not timed | not timed | 1232.19 ± 0.3% | 9.07 ± 0.9% | not timed | not timed | 1791.86 ± 0.3% | | 1.00 | 1.46 | 198.03 |
| 02-literal-alternate/sherlock-zh | 207 | 7085.55 ± 0.2% | not timed | not timed | 4161.25 ± 0.2% | 31.54 ± 0.2% | not timed | not timed | 7072.16 ± 0.1% | | 1.00 | 1.70 | 224.64 |
| 03-date/ascii | 111817 | 123.90 ± 0.7% | not timed | not timed | 96.44 ± 0.1% | 0.21 ± 4.6% | not timed | not timed | 123.30 ± 0.6% | | 1.00 | 1.28 | 602.01 |
| 04-ruff-noqa/real | 84 | 555.65 ± 0.4% | not timed | not timed | 464.28 ± 0.2% | 19.71 ± 1.3% | not timed | not timed | 554.86 ± 0.1% | | 1.00 | 1.20 | 28.20 |
| 04-ruff-noqa/tweaked | 44 | 558.98 ± 0.2% | not timed | not timed | 458.66 ± 0.1% | 367.41 ± 0.2% | not timed | not timed | 558.74 ± 0.1% | | 1.00 | 1.22 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.3% | not timed | not timed | 5.21 ± 0.2% | 0.21 ± 2.3% | not timed | not timed | 3.60 ± 1.6% | | 0.98 | 0.68 | 17.08 |
| 06-cloud-flare-redos/original | 107 | 184.19 ± 0.7% | not timed | not timed | 217.33 ± 0.1% | 24.88 ± 0.3% | not timed | not timed | 182.52 ± 0.3% | | 1.01 | 0.85 | 7.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.26 ± 0.1% | not timed | not timed | 229.65 ± 0.1% | 26.81 ± 0.3% | not timed | not timed | 145.12 ± 0.3% | | 1.00 | 0.63 | 5.42 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.94 ± 2.3% | not timed | not timed | 256.96 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 154.90 ± 2.3% | | 1.00 | 0.60 | 5.37 |
| 07-unicode-character-data/parse-line | 558784 | 231.46 ± 2.4% | not timed | not timed | 181.17 ± 0.2% | 42.85 ± 5.6% | not timed | not timed | 229.13 ± 2.2% | | 1.01 | 1.28 | 5.40 |
| 08-words/all-english | 56691 | 103.28 ± 0.9% | not timed | not timed | 82.68 ± 0.1% | 12.71 ± 12.5% | not timed | not timed | 102.73 ± 0.6% | | 1.01 | 1.25 | 8.13 |
| 08-words/long-english | 839 | 998.58 ± 0.1% | not timed | not timed | 595.35 ± 0.1% | 32.69 ± 0.5% | not timed | not timed | 998.50 ± 0.1% | | 1.00 | 1.68 | 30.54 |
| 09-aws-keys/full | 0 | 424.22 ± 0.1% | not timed | not timed | 494.76 ± 0.1% | 64.73 ± 3.4% | not timed | not timed | 424.90 ± 0.1% | | 1.00 | 0.86 | 6.55 |
| 09-aws-keys/quick | 0 | 744.18 ± 0.1% | not timed | not timed | 999.16 ± 0.4% | 414.02 ± 3.0% | not timed | not timed | 741.05 ± 0.1% | | 1.00 | 0.74 | 1.80 |
| 10-bounded-repeat/letters-en | 1833 | 586.06 ± 0.2% | not timed | not timed | 516.66 ± 0.2% | 19.53 ± 0.3% | not timed | not timed | 585.37 ± 0.3% | | 1.00 | 1.13 | 30.01 |
| 10-bounded-repeat/letters-ru | 3475 | 401.52 ± 0.2% | not timed | not timed | 481.25 ± 0.1% | 22.49 ± 8.1% | not timed | not timed | 399.54 ± 1.6% | | 1.00 | 0.83 | 17.85 |
| 10-bounded-repeat/context | 53 | 80.09 ± 1.1% | not timed | not timed | 66.55 ± 0.4% | 19.78 ± 0.2% | not timed | not timed | 80.42 ± 0.9% | | 1.00 | 1.20 | 4.05 |
| 10-bounded-repeat/capitals | 11 | 1047.13 ± 0.2% | not timed | not timed | 618.62 ± 0.1% | 36.58 ± 0.1% | not timed | not timed | 1047.41 ± 0.3% | | 1.00 | 1.69 | 28.63 |
| 11-unstructured-to-json/extract | 600 | 47.83 ± 0.0% | not timed | not timed | 74.91 ± 0.2% | 48.88 ± 0.7% | not timed | not timed | 47.60 ± 0.8% | | 1.00 | 0.64 | 0.98 |
| 12-dictionary/single | 1 | 604.27 ± 0.3% | not timed | not timed | 560.96 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 603.39 ± 0.4% | | 1.00 | 1.08 | 1467.02 |
| 14-quadratic/1x | 100 | 12.59 ± 0.2% | not timed | not timed | 10.08 ± 0.3% | 0.96 ± 2.7% | not timed | not timed | 12.54 ± 1.0% | | 1.00 | 1.25 | 13.07 |
| 14-quadratic/2x | 200 | 7.83 ± 0.2% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 1.4% | not timed | not timed | 7.78 ± 0.8% | | 1.01 | 1.41 | 14.77 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 2.0% | not timed | not timed | 1.86 ± 0.4% | | 1.00 | 1.54 | 16.17 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.3% | not timed | not timed | 0.35 ± 0.3% | 0.55 ± 4.6% | not timed | not timed | 1.45 ± 1.3% | | 1.00 | 4.19 | 2.62 |
| 04-ruff-noqa/compile-real | 1 | 93.00 ± 0.3% | not timed | not timed | 13.78 ± 0.3% | 142.97 ± 3.8% | not timed | not timed | 92.93 ± 1.1% | | 1.00 | 6.75 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.68 ± 0.2% | not timed | not timed | 2.53 ± 0.6% | 6.58 ± 2.6% | not timed | not timed | 14.64 ± 0.7% | | 1.00 | 5.80 | 2.23 |
| 07-unicode-character-data/compile | 1 | 58.41 ± 0.2% | not timed | not timed | 26.11 ± 0.1% | 36.75 ± 1.7% | not timed | not timed | 58.38 ± 1.4% | | 1.00 | 2.24 | 1.59 |
| 09-aws-keys/compile-full | 1 | 43.71 ± 0.3% | not timed | not timed | 8.32 ± 0.2% | 23.86 ± 1.1% | not timed | not timed | 43.54 ± 0.1% | | 1.00 | 5.26 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 188.46 ± 0.3% | not timed | not timed | 48.42 ± 0.1% | 136.00 ± 2.3% | not timed | not timed | 190.18 ± 1.2% | | 0.99 | 3.89 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.71 ± 2.1% | not timed | not timed | 11.21 ± 0.3% | 16.45 ± 1.3% | not timed | not timed | 14.65 ± 0.9% | | 1.00 | 1.31 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 85.87 ± 0.6% | not timed | not timed | 8.01 ± 0.4% | 24.41 ± 1.3% | not timed | not timed | 85.62 ± 0.7% | | 1.00 | 10.72 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 90.86 ± 0.5% | not timed | not timed | 41.13 ± 0.7% | 69.98 ± 3.9% | not timed | not timed | 90.73 ± 0.9% | | 1.00 | 2.21 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 33.8% | 0.10 ± 3.5% | not timed | not timed | 0.36 ± 0.4% | | 1.01 | 5.20 | 3.77 |

