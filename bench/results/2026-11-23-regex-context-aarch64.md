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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117634053 |
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
| literal: a word | 217 | 15792.94 ± 1.9% | 1037.19 ± 0.5% | 28.15 ± 0.4% | 17634.42 ± 2.6% | 9202.28 ± 6.3% | 17.33 ± 0.3% | 86.65 ± 0.2% | 15814.70 ± 0.9% | 15.23 | 1.00 | 0.90 | 1.72 |
| literal: a word that is not there | 0 | 18346.94 ± 3.0% | 1048.37 ± 0.1% | 28.29 ± 0.3% | 19120.62 ± 3.4% | 27125.47 ± 5.8% | 17.08 ± 0.2% | 82.70 ± 0.1% | 18379.46 ± 3.0% | 17.50 | 1.00 | 0.96 | 0.68 |
| literal: one of four words | 661 | 6089.21 ± 0.4% | 1015.41 ± 0.2% | 14.57 ± 0.2% | 3945.48 ± 0.3% | 21.91 ± 0.1% | 5.43 ± 0.2% | 6.93 ± 1.2% | 6069.11 ± 0.3% | 6.00 | 1.00 | 1.54 | 277.90 |
| literal: a word in any case | 217 | 12555.74 ± 1.1% | 1037.61 ± 0.4% | 21.54 ± 0.6% | 3971.58 ± 0.3% | 38.13 ± 0.1% | refused | differs | 12559.66 ± 0.8% | 12.10 | 1.00 | 3.16 | 329.29 |
| literal: an href attribute | 33 | 13702.38 ± 1.3% | 1044.88 ± 0.2% | 27.06 ± 0.1% | 16427.15 ± 2.9% | 2257.98 ± 0.8% | 13.05 ± 0.2% | 75.72 ± 0.5% | 13739.48 ± 0.6% | 13.11 | 1.00 | 0.83 | 6.07 |
| literal: a word, second text | 123 | 16246.81 ± 0.8% | 1042.19 ± 0.0% | 28.01 ± 0.2% | 17797.91 ± 2.4% | 7398.15 ± 6.2% | 20.08 ± 0.3% | 70.72 ± 0.4% | 16263.23 ± 2.5% | 15.59 | 1.00 | 0.91 | 2.20 |
| class: two capitalized words | 1331 | 1126.88 ± 0.5% | 953.65 ± 0.3% | 25.95 ± 0.2% | 585.71 ± 0.1% | 40.75 ± 2.9% | 14.68 ± 0.3% | 68.96 ± 0.3% | 1128.56 ± 0.7% | 1.18 | 1.00 | 1.92 | 27.66 |
| class: a word that ends in ing | 3399 | 877.45 ± 0.1% | 877.56 ± 0.1% | 17.98 ± 0.2% | 546.48 ± 0.2% | 29.67 ± 4.3% | 8.19 ± 0.2% | 18.45 ± 1.9% | 876.73 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.58 |
| class: a word in capitals | 2332 | 1465.15 ± 1.5% | 937.50 ± 0.3% | 27.57 ± 0.2% | 572.50 ± 0.1% | 43.56 ± 2.6% | 17.03 ± 0.3% | 83.31 ± 0.3% | 1475.34 ± 1.5% | 1.56 | 0.99 | 2.56 | 33.64 |
| class: a number | 8288 | 2000.63 ± 0.8% | 787.12 ± 0.1% | 27.73 ± 0.2% | 1730.24 ± 0.1% | 39.49 ± 16.1% | 0.53 ± 0.4% | 56.97 ± 0.4% | 1990.26 ± 0.3% | 2.54 | 1.01 | 1.16 | 50.67 |
| class: two capitalized words, second text | 5359 | 683.83 ± 0.4% | 676.51 ± 0.2% | 23.26 ± 0.1% | 485.00 ± 0.1% | 35.56 ± 14.3% | 17.08 ± 0.3% | 64.17 ± 0.2% | 683.61 ± 0.2% | 1.01 | 1.00 | 1.41 | 19.23 |
| other: a word between two words | 6104 | 768.12 ± 0.2% | 739.63 ± 0.0% | 23.41 ± 0.2% | 736.07 ± 0.2% | 109.20 ± 17.0% | 11.12 ± 0.1% | 69.95 ± 0.2% | 766.81 ± 0.1% | 1.04 | 1.00 | 1.04 | 7.03 |
| other: a number before a unit, second text | 1481 | 5588.96 ± 0.5% | 973.14 ± 0.1% | 25.77 ± 0.1% | 5669.44 ± 1.1% | 40.85 ± 0.1% | 18.21 ± 0.5% | 66.86 ± 0.2% | 5578.91 ± 1.3% | 5.74 | 1.00 | 0.99 | 136.81 |
| other: a heading's start tag | 110 | 12484.99 ± 1.0% | 1036.32 ± 0.2% | 27.29 ± 0.1% | 1710.97 ± 0.1% | 1568.65 ± 5.8% | 15.94 ± 0.5% | 88.98 ± 0.7% | 12565.50 ± 0.6% | 12.05 | 0.99 | 7.30 | 7.96 |
| other: a whole word | 217 | 13836.20 ± 0.9% | 1036.61 ± 0.1% | 29.21 ± 0.1% | 14112.58 ± 2.9% | 49.37 ± 0.3% | 13.20 ± 0.1% | 56.35 ± 0.5% | 13817.19 ± 0.7% | 13.35 | 1.00 | 0.98 | 280.26 |
| other: a line's first word, second text | 3716 | 1979.45 ± 0.5% | 856.75 ± 0.2% | 30.82 ± 0.2% | 1723.92 ± 0.3% | 62.09 ± 6.5% | refused | refused | 1974.33 ± 0.2% | 2.31 | 1.00 | 1.15 | 31.88 |
| other: fourteen octets before an x | 87 | 18521.21 ± 4.6% | 230.33 ± 0.6% | 6.11 ± 0.1% | 3990.69 ± 0.3% | 10.64 ± 0.0% | differs | 17.82 ± 0.2% | 18615.65 ± 3.5% | 80.41 | 0.99 | 4.64 | 1740.43 |
| other: a Greek word | 21815 | 486.72 ± 1.0% | 308.72 ± 0.4% | 30.83 ± 0.5% | 290.43 ± 0.1% | 47.61 ± 14.1% | differs | refused | 486.03 ± 0.9% | 1.58 | 1.00 | 1.68 | 10.22 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.3% | 25.88 ± 0.2% | 0.82 ± 0.3% | 19.88 ± 0.3% | 2.78 ± 0.3% | differs | 4.01 ± 0.1% | 25.89 ± 0.1% | 1.00 | 1.00 | 1.30 | 9.30 |
| a UUID | 32895 | 21.14 ± 0.1% | 21.22 ± 0.2% | 0.65 ± 0.2% | 15.14 ± 0.2% | 3.12 ± 0.1% | 0.73 ± 0.2% | 3.60 ± 1.0% | 21.17 ± 0.3% | 1.00 | 1.00 | 1.40 | 6.77 |
| an IPv4 address | 33176 | 36.91 ± 0.2% | 36.90 ± 0.4% | 2.11 ± 0.3% | 29.41 ± 0.5% | 6.66 ± 0.1% | differs | 4.15 ± 0.3% | 36.94 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.54 |
| a date and time | 32954 | 31.10 ± 0.5% | 31.08 ± 0.6% | 1.47 ± 0.5% | 21.55 ± 0.9% | 7.07 ± 0.4% | 1.25 ± 0.3% | 7.16 ± 0.3% | 31.10 ± 0.6% | 1.00 | 1.00 | 1.44 | 4.40 |
| a field path | 32606 | 29.39 ± 0.1% | 29.37 ± 0.1% | 1.01 ± 0.2% | 23.39 ± 0.4% | 3.53 ± 0.9% | differs | 2.98 ± 0.2% | 29.44 ± 0.3% | 1.00 | 1.00 | 1.26 | 8.34 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.64 ± 0.8% | 11.64 ± 0.8% | 11.54 ± 0.4% | 11.84 ± 0.2% | 4.99 ± 2.9% | 0.93 ± 0.1% | none | 11.67 ± 0.3% | 1.00 | 1.00 | 0.98 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.43 ± 0.4% | 237.99 ± 0.4% | 287.71 ± 0.4% | 86.53 ± 0.4% | 222.80 ± 0.9% | 485.21 ± 1.0% | 3877.77 ± 2.4% | 236.33 ± 0.2% | 0.99 | 1.00 | 2.73 | 1.06 |
| a UUID | 62 | 157.86 ± 1.0% | 158.23 ± 0.3% | 178.78 ± 0.1% | 46.53 ± 0.7% | 98.83 ± 0.6% | 188.49 ± 2.8% | 4380.35 ± 1.1% | 157.69 ± 0.3% | 1.00 | 1.00 | 3.39 | 1.60 |
| an IPv4 address | 29 | 425.59 ± 0.7% | 431.18 ± 0.4% | 619.03 ± 0.5% | 77.39 ± 0.2% | 132.28 ± 1.6% | 292.23 ± 1.6% | 7636.71 ± 0.2% | 425.67 ± 0.3% | 0.99 | 1.00 | 5.50 | 3.22 |
| a date and time | 56 | 307.15 ± 0.4% | 310.53 ± 0.6% | 396.29 ± 0.4% | 73.20 ± 0.4% | 138.90 ± 2.0% | 326.08 ± 0.7% | 4912.85 ± 0.7% | 307.20 ± 0.3% | 0.99 | 1.00 | 4.20 | 2.21 |
| a field path | 39 | 228.14 ± 0.4% | 229.46 ± 0.4% | 274.66 ± 0.4% | 81.00 ± 1.3% | 207.51 ± 0.8% | 504.17 ± 2.8% | 4905.05 ± 0.8% | 228.21 ± 0.3% | 0.99 | 1.00 | 2.82 | 1.10 |
| literal: a word | 7 | 639.32 ± 0.8% | 685.69 ± 0.4% | 1292.72 ± 0.2% | 523.36 ± 0.2% | 634.98 ± 2.0% | 953.85 ± 0.6% | 30457.30 ± 0.1% | 639.03 ± 0.5% | 0.93 | 1.00 | 1.22 | 1.01 |
| literal: a word that is not there | 8 | 612.16 ± 0.4% | 664.02 ± 0.4% | 1217.48 ± 0.1% | 479.76 ± 0.1% | 608.21 ± 2.2% | 909.29 ± 0.8% | 29136.83 ± 0.1% | 613.79 ± 0.4% | 0.92 | 1.00 | 1.28 | 1.01 |
| literal: one of four words | 26 | 243.86 ± 0.2% | 407.38 ± 0.3% | 569.62 ± 0.3% | 50.07 ± 1.3% | 243.15 ± 1.9% | 367.38 ± 0.9% | 15608.52 ± 0.3% | 244.02 ± 0.3% | 0.60 | 1.00 | 4.87 | 1.00 |
| literal: a word in any case | 11 | 494.07 ± 0.3% | 527.26 ± 0.4% | 851.58 ± 0.2% | 15.53 ± 1.3% | 650.75 ± 0.3% | refused | 23730.11 ± 0.2% | 493.09 ± 0.3% | 0.94 | 1.00 | 31.82 | 0.76 |
| literal: an href attribute | 12 | 353.51 ± 0.3% | 365.90 ± 0.4% | 495.86 ± 0.4% | 45.58 ± 0.7% | 500.24 ± 1.0% | 773.85 ± 0.8% | 21659.38 ± 0.1% | 353.36 ± 0.3% | 0.97 | 1.00 | 7.76 | 0.71 |
| literal: a word, second text | 10 | 571.49 ± 0.8% | 628.15 ± 0.5% | 1094.12 ± 0.7% | 399.04 ± 0.2% | 538.92 ± 2.8% | 806.41 ± 0.4% | 27081.94 ± 0.1% | 570.40 ± 0.4% | 0.91 | 1.00 | 1.43 | 1.06 |
| class: two capitalized words | 23 | 443.54 ± 0.4% | 471.68 ± 0.3% | 708.59 ± 0.4% | 100.39 ± 0.2% | 501.59 ± 1.5% | 744.53 ± 0.4% | 6595.62 ± 0.3% | 443.65 ± 0.3% | 0.94 | 1.00 | 4.42 | 0.88 |
| class: a word that ends in ing | 9 | 573.41 ± 0.3% | 641.35 ± 0.3% | 1175.13 ± 0.1% | 132.90 ± 2.1% | 754.74 ± 0.7% | 1098.33 ± 0.4% | 16109.30 ± 0.2% | 573.61 ± 0.4% | 0.89 | 1.00 | 4.31 | 0.76 |
| class: a word in capitals | 16 | 507.08 ± 0.1% | 544.14 ± 0.2% | 905.27 ± 1.3% | 136.06 ± 0.7% | 747.00 ± 2.0% | 1025.66 ± 1.6% | 8685.20 ± 0.6% | 506.62 ± 0.1% | 0.93 | 1.00 | 3.73 | 0.68 |
| class: a number | 6 | 636.59 ± 0.5% | 704.13 ± 0.6% | 1385.37 ± 0.1% | 41.83 ± 0.8% | 1405.97 ± 0.9% | 1890.19 ± 1.6% | 22832.69 ± 0.3% | 637.42 ± 0.2% | 0.90 | 1.00 | 15.22 | 0.45 |
| class: two capitalized words, second text | 23 | 444.33 ± 0.8% | 472.86 ± 0.4% | 709.36 ± 0.3% | 101.64 ± 0.3% | 502.26 ± 0.8% | 763.22 ± 0.6% | 6597.40 ± 0.2% | 444.24 ± 0.0% | 0.94 | 1.00 | 4.37 | 0.88 |
| other: a word between two words | 13 | 561.27 ± 0.2% | 580.23 ± 0.2% | 966.89 ± 0.2% | 134.24 ± 0.6% | 506.50 ± 3.3% | 815.36 ± 0.6% | 14930.32 ± 0.2% | 561.90 ± 0.3% | 0.97 | 1.00 | 4.18 | 1.11 |
| other: a number before a unit, second text | 15 | 412.29 ± 0.3% | 451.17 ± 0.3% | 654.95 ± 0.3% | 39.67 ± 0.5% | 634.23 ± 1.2% | 890.66 ± 1.6% | 15187.28 ± 0.1% | 412.04 ± 0.2% | 0.91 | 1.00 | 10.39 | 0.65 |
| other: a heading's start tag | 13 | 362.55 ± 0.3% | 367.46 ± 0.5% | 498.58 ± 0.3% | 44.00 ± 0.3% | 631.01 ± 1.6% | 880.12 ± 1.1% | 18043.57 ± 0.4% | 362.16 ± 0.3% | 0.99 | 1.00 | 8.24 | 0.57 |
| other: a whole word | 11 | 595.38 ± 0.5% | 632.38 ± 0.3% | 1099.62 ± 0.1% | 118.34 ± 0.7% | 568.57 ± 3.6% | 837.91 ± 0.2% | 26984.94 ± 0.3% | 596.46 ± 0.2% | 0.94 | 1.00 | 5.03 | 1.05 |
| other: a line's first word, second text | 17 | 541.98 ± 0.9% | 564.22 ± 0.6% | 944.81 ± 0.8% | 129.98 ± 0.1% | 708.00 ± 0.7% | refused | refused | 539.92 ± 0.9% | 0.96 | 1.00 | 4.17 | 0.77 |
| other: fourteen octets before an x | 16 | 111.94 ± 0.4% | 162.34 ± 0.4% | 189.27 ± 1.0% | 15.21 ± 0.5% | 453.76 ± 0.6% | 405.37 ± 0.4% | 12633.94 ± 0.3% | 111.90 ± 0.3% | 0.69 | 1.00 | 7.36 | 0.25 |
| other: a Greek word | 8 | 434.53 ± 0.4% | 599.74 ± 0.3% | 1059.88 ± 0.1% | 59.16 ± 0.6% | 1384.16 ± 1.0% | 1846.33 ± 0.5% | refused | 434.75 ± 0.2% | 0.72 | 1.00 | 7.34 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12818.45 ± 0.4% | not timed | not timed | 16150.33 ± 1.7% | 1999.93 ± 16.2% | not timed | not timed | 12832.16 ± 0.7% | | 1.00 | 0.79 | 6.41 |
| 01-literal/sherlock-casei-en | 522 | 3911.08 ± 0.7% | not timed | not timed | 3590.20 ± 0.2% | 32.42 ± 0.3% | not timed | not timed | 3902.61 ± 0.4% | | 1.00 | 1.09 | 120.64 |
| 01-literal/sherlock-ru | 724 | 13644.41 ± 0.5% | not timed | not timed | 17317.12 ± 0.7% | 1500.79 ± 17.1% | not timed | not timed | 13629.18 ± 0.4% | | 1.00 | 0.79 | 9.09 |
| 01-literal/sherlock-casei-ru | 746 | 5319.98 ± 0.2% | not timed | not timed | 3334.66 ± 0.2% | 30.76 ± 7.0% | not timed | not timed | 5320.46 ± 0.3% | | 1.00 | 1.60 | 172.93 |
| 01-literal/sherlock-zh | 30 | 16773.98 ± 0.3% | not timed | not timed | 18236.41 ± 1.1% | 2527.23 ± 15.3% | not timed | not timed | 16812.11 ± 0.5% | | 1.00 | 0.92 | 6.64 |
| 02-literal-alternate/sherlock-en | 714 | 5818.62 ± 0.2% | not timed | not timed | 3943.67 ± 0.2% | 16.63 ± 12.7% | not timed | not timed | 5809.98 ± 0.5% | | 1.00 | 1.48 | 349.85 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1679.26 ± 0.7% | not timed | not timed | 695.92 ± 0.5% | 11.01 ± 0.2% | not timed | not timed | 1675.39 ± 0.5% | | 1.00 | 2.41 | 152.56 |
| 02-literal-alternate/sherlock-ru | 899 | 4721.56 ± 0.2% | not timed | not timed | 3253.74 ± 0.1% | 22.66 ± 0.2% | not timed | not timed | 4721.90 ± 0.2% | | 1.00 | 1.45 | 208.32 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1794.05 ± 0.5% | not timed | not timed | 1232.25 ± 0.4% | 9.07 ± 0.1% | not timed | not timed | 1792.07 ± 0.3% | | 1.00 | 1.46 | 197.77 |
| 02-literal-alternate/sherlock-zh | 207 | 7090.00 ± 0.2% | not timed | not timed | 4168.57 ± 0.2% | 31.53 ± 0.2% | not timed | not timed | 7088.80 ± 0.1% | | 1.00 | 1.70 | 224.89 |
| 03-date/ascii | 111817 | 124.20 ± 0.4% | not timed | not timed | 96.63 ± 0.2% | 0.21 ± 4.5% | not timed | not timed | 123.63 ± 0.3% | | 1.00 | 1.29 | 597.25 |
| 04-ruff-noqa/real | 84 | 555.45 ± 0.1% | not timed | not timed | 473.37 ± 0.1% | 19.69 ± 1.6% | not timed | not timed | 554.63 ± 0.4% | | 1.00 | 1.17 | 28.21 |
| 04-ruff-noqa/tweaked | 44 | 559.69 ± 0.1% | not timed | not timed | 461.81 ± 0.1% | 369.74 ± 0.5% | not timed | not timed | 558.97 ± 0.2% | | 1.00 | 1.21 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.51 ± 0.1% | not timed | not timed | 5.20 ± 0.1% | 0.21 ± 2.9% | not timed | not timed | 3.59 ± 2.0% | | 0.98 | 0.68 | 17.04 |
| 06-cloud-flare-redos/original | 107 | 184.78 ± 0.7% | not timed | not timed | 217.45 ± 0.7% | 25.00 ± 0.2% | not timed | not timed | 182.77 ± 0.7% | | 1.01 | 0.85 | 7.39 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.21 ± 0.1% | not timed | not timed | 229.42 ± 0.1% | 26.75 ± 0.1% | not timed | not timed | 144.87 ± 0.2% | | 1.00 | 0.63 | 5.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.63 ± 2.6% | not timed | not timed | 256.82 ± 0.3% | 28.87 ± 0.2% | not timed | not timed | 154.80 ± 2.3% | | 1.00 | 0.60 | 5.36 |
| 07-unicode-character-data/parse-line | 558784 | 231.44 ± 0.2% | not timed | not timed | 181.09 ± 0.1% | 43.50 ± 4.7% | not timed | not timed | 231.17 ± 3.3% | | 1.00 | 1.28 | 5.32 |
| 08-words/all-english | 56691 | 103.25 ± 0.3% | not timed | not timed | 82.81 ± 0.1% | 11.84 ± 3.8% | not timed | not timed | 102.46 ± 0.3% | | 1.01 | 1.25 | 8.72 |
| 08-words/long-english | 839 | 998.09 ± 0.1% | not timed | not timed | 597.82 ± 0.1% | 32.55 ± 1.0% | not timed | not timed | 999.03 ± 0.1% | | 1.00 | 1.67 | 30.66 |
| 09-aws-keys/full | 0 | 424.45 ± 0.1% | not timed | not timed | 494.75 ± 0.2% | 64.55 ± 0.1% | not timed | not timed | 424.84 ± 0.1% | | 1.00 | 0.86 | 6.58 |
| 09-aws-keys/quick | 0 | 744.47 ± 0.1% | not timed | not timed | 999.11 ± 0.4% | 427.03 ± 0.3% | not timed | not timed | 741.77 ± 0.1% | | 1.00 | 0.75 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 587.24 ± 0.4% | not timed | not timed | 518.17 ± 0.2% | 19.54 ± 0.4% | not timed | not timed | 586.84 ± 0.1% | | 1.00 | 1.13 | 30.05 |
| 10-bounded-repeat/letters-ru | 3475 | 401.79 ± 0.3% | not timed | not timed | 480.89 ± 0.1% | 23.66 ± 4.1% | not timed | not timed | 400.71 ± 0.8% | | 1.00 | 0.84 | 16.98 |
| 10-bounded-repeat/context | 53 | 80.35 ± 1.2% | not timed | not timed | 66.41 ± 0.5% | 19.80 ± 0.4% | not timed | not timed | 80.09 ± 1.2% | | 1.00 | 1.21 | 4.06 |
| 10-bounded-repeat/capitals | 11 | 1048.01 ± 0.1% | not timed | not timed | 616.85 ± 0.1% | 36.54 ± 0.2% | not timed | not timed | 1048.08 ± 0.0% | | 1.00 | 1.70 | 28.68 |
| 11-unstructured-to-json/extract | 600 | 47.84 ± 0.1% | not timed | not timed | 76.67 ± 0.1% | 48.89 ± 2.9% | not timed | not timed | 47.57 ± 0.1% | | 1.01 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 605.22 ± 0.2% | not timed | not timed | 556.54 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 605.09 ± 0.3% | | 1.00 | 1.09 | 1474.83 |
| 14-quadratic/1x | 100 | 12.59 ± 0.3% | not timed | not timed | 10.12 ± 0.8% | 0.97 ± 2.5% | not timed | not timed | 12.52 ± 1.1% | | 1.01 | 1.24 | 13.02 |
| 14-quadratic/2x | 200 | 7.84 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.3% | not timed | not timed | 7.78 ± 0.9% | | 1.01 | 1.41 | 14.68 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 1.86 ± 0.2% | | 1.00 | 1.54 | 16.17 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 2.7% | not timed | not timed | 1.45 ± 1.1% | | 1.00 | 4.22 | 2.65 |
| 04-ruff-noqa/compile-real | 1 | 92.79 ± 0.1% | not timed | not timed | 13.82 ± 0.1% | 141.82 ± 2.8% | not timed | not timed | 92.82 ± 1.0% | | 1.00 | 6.72 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.67 ± 0.1% | not timed | not timed | 2.53 ± 0.8% | 6.48 ± 2.6% | not timed | not timed | 14.65 ± 1.3% | | 1.00 | 5.79 | 2.26 |
| 07-unicode-character-data/compile | 1 | 58.34 ± 0.3% | not timed | not timed | 26.25 ± 0.1% | 36.49 ± 3.9% | not timed | not timed | 58.51 ± 0.3% | | 1.00 | 2.22 | 1.60 |
| 09-aws-keys/compile-full | 1 | 43.72 ± 0.2% | not timed | not timed | 8.36 ± 0.4% | 23.67 ± 0.7% | not timed | not timed | 43.60 ± 0.6% | | 1.00 | 5.23 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 188.50 ± 0.2% | not timed | not timed | 48.17 ± 0.7% | 137.02 ± 2.3% | not timed | not timed | 190.07 ± 0.8% | | 0.99 | 3.91 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.70 ± 1.6% | not timed | not timed | 11.17 ± 0.1% | 16.41 ± 1.4% | not timed | not timed | 14.50 ± 1.9% | | 1.01 | 1.32 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 86.11 ± 0.3% | not timed | not timed | 7.99 ± 0.2% | 23.92 ± 2.2% | not timed | not timed | 85.99 ± 0.5% | | 1.00 | 10.77 | 3.60 |
| 11-unstructured-to-json/compile | 1 | 90.86 ± 0.2% | not timed | not timed | 40.49 ± 0.2% | 69.46 ± 1.2% | not timed | not timed | 90.48 ± 1.4% | | 1.00 | 2.24 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 21.3% | 0.10 ± 25.9% | not timed | not timed | 0.36 ± 1.2% | | 1.01 | 5.15 | 3.65 |

