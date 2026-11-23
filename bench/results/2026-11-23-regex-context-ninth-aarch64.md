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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117671569 |
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
| literal: a word | 217 | 15976.47 ± 2.4% | 1036.73 ± 0.1% | 28.62 ± 0.5% | 17618.97 ± 3.1% | 9001.52 ± 8.4% | 17.31 ± 0.3% | 86.89 ± 0.1% | 15839.55 ± 2.8% | 15.41 | 1.01 | 0.91 | 1.77 |
| literal: a word that is not there | 0 | 18121.27 ± 1.1% | 1047.82 ± 0.2% | 28.59 ± 0.5% | 18801.46 ± 1.5% | 26930.23 ± 3.2% | 17.14 ± 0.2% | 82.69 ± 0.2% | 18286.18 ± 2.0% | 17.29 | 0.99 | 0.96 | 0.67 |
| literal: one of four words | 661 | 6091.28 ± 0.4% | 1014.38 ± 0.1% | 14.61 ± 0.5% | 3945.40 ± 0.1% | 21.88 ± 0.1% | 5.24 ± 0.1% | 6.88 ± 0.3% | 6080.94 ± 0.1% | 6.00 | 1.00 | 1.54 | 278.38 |
| literal: a word in any case | 217 | 12502.32 ± 1.0% | 1037.31 ± 0.2% | 21.80 ± 0.1% | 3969.20 ± 0.6% | 38.14 ± 0.4% | refused | differs | 12486.75 ± 0.6% | 12.05 | 1.00 | 3.15 | 327.78 |
| literal: an href attribute | 33 | 13636.02 ± 0.9% | 1044.88 ± 0.2% | 27.28 ± 0.3% | 16734.70 ± 3.7% | 2256.72 ± 0.6% | 12.87 ± 1.2% | 75.88 ± 0.2% | 13635.35 ± 0.8% | 13.05 | 1.00 | 0.81 | 6.04 |
| literal: a word, second text | 123 | 16365.10 ± 1.1% | 1042.02 ± 0.1% | 28.14 ± 0.3% | 18245.35 ± 3.8% | 7582.49 ± 7.0% | 19.48 ± 0.4% | 71.07 ± 0.3% | 16512.25 ± 1.8% | 15.71 | 0.99 | 0.90 | 2.16 |
| class: two capitalized words | 1331 | 1126.13 ± 0.7% | 952.78 ± 0.2% | 26.00 ± 0.3% | 581.91 ± 0.1% | 40.75 ± 8.1% | 14.82 ± 0.3% | 68.89 ± 0.3% | 1120.12 ± 0.5% | 1.18 | 1.01 | 1.94 | 27.64 |
| class: a word that ends in ing | 3399 | 876.62 ± 0.2% | 876.15 ± 0.2% | 18.07 ± 0.1% | 545.99 ± 0.1% | 29.66 ± 10.8% | 8.15 ± 0.1% | 18.40 ± 0.7% | 875.41 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.56 |
| class: a word in capitals | 2332 | 1474.69 ± 0.5% | 937.52 ± 0.5% | 27.69 ± 0.3% | 572.26 ± 0.2% | 43.57 ± 9.7% | 17.03 ± 0.2% | 83.23 ± 0.4% | 1473.68 ± 0.4% | 1.57 | 1.00 | 2.58 | 33.84 |
| class: a number | 8288 | 1994.31 ± 0.2% | 785.18 ± 0.1% | 27.89 ± 0.3% | 1738.49 ± 0.2% | 40.67 ± 16.2% | 0.51 ± 0.6% | 56.60 ± 0.4% | 1994.14 ± 0.2% | 2.54 | 1.00 | 1.15 | 49.03 |
| class: two capitalized words, second text | 5359 | 682.99 ± 0.2% | 678.96 ± 0.2% | 23.32 ± 0.1% | 487.27 ± 0.1% | 35.52 ± 15.1% | 16.93 ± 0.3% | 64.08 ± 0.2% | 682.67 ± 0.0% | 1.01 | 1.00 | 1.40 | 19.23 |
| other: a word between two words | 6104 | 767.40 ± 0.3% | 737.75 ± 0.1% | 23.47 ± 0.2% | 735.83 ± 0.2% | 108.27 ± 15.9% | 11.34 ± 0.3% | 69.94 ± 0.2% | 767.11 ± 0.2% | 1.04 | 1.00 | 1.04 | 7.09 |
| other: a number before a unit, second text | 1481 | 5581.11 ± 0.6% | 973.04 ± 0.1% | 25.90 ± 0.4% | 5642.24 ± 1.0% | 40.81 ± 0.2% | 17.90 ± 0.1% | 66.97 ± 0.4% | 5553.99 ± 0.9% | 5.74 | 1.00 | 0.99 | 136.75 |
| other: a heading's start tag | 110 | 12581.32 ± 1.0% | 1035.14 ± 0.1% | 27.39 ± 0.2% | 1710.63 ± 0.1% | 1565.02 ± 2.9% | 16.06 ± 0.2% | 89.02 ± 0.6% | 12578.15 ± 0.5% | 12.15 | 1.00 | 7.35 | 8.04 |
| other: a whole word | 217 | 13817.39 ± 2.9% | 1036.39 ± 0.2% | 29.42 ± 0.3% | 14314.51 ± 1.8% | 49.44 ± 0.2% | 13.36 ± 0.3% | 56.20 ± 0.6% | 13920.90 ± 1.8% | 13.33 | 0.99 | 0.97 | 279.47 |
| other: a line's first word, second text | 3716 | 1986.22 ± 0.5% | 854.62 ± 0.2% | 31.17 ± 0.1% | 1737.42 ± 0.3% | 62.19 ± 6.6% | refused | refused | 1976.90 ± 0.4% | 2.32 | 1.00 | 1.14 | 31.94 |
| other: fourteen octets before an x | 87 | 19422.18 ± 0.4% | 235.66 ± 0.4% | 6.11 ± 0.1% | 3987.70 ± 0.5% | 10.63 ± 0.1% | differs | 17.79 ± 0.3% | 19545.03 ± 1.1% | 82.42 | 0.99 | 4.87 | 1826.67 |
| other: a Greek word | 21815 | 485.74 ± 0.8% | 308.73 ± 0.3% | 30.94 ± 0.3% | 290.58 ± 0.2% | 49.08 ± 9.9% | differs | refused | 483.31 ± 0.6% | 1.57 | 1.01 | 1.67 | 9.90 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.92 ± 0.3% | 25.94 ± 0.2% | 0.82 ± 0.1% | 19.54 ± 0.6% | 2.76 ± 0.5% | differs | 4.00 ± 0.2% | 25.90 ± 0.4% | 1.00 | 1.00 | 1.33 | 9.38 |
| a UUID | 32895 | 21.15 ± 0.2% | 21.19 ± 0.4% | 0.65 ± 0.2% | 15.11 ± 0.6% | 3.12 ± 0.1% | 0.72 ± 0.1% | 3.60 ± 1.0% | 21.21 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.79 |
| an IPv4 address | 33176 | 36.92 ± 0.4% | 36.88 ± 0.1% | 2.10 ± 0.2% | 28.94 ± 0.7% | 6.66 ± 0.1% | differs | 4.14 ± 0.1% | 36.90 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.54 |
| a date and time | 32954 | 31.07 ± 0.2% | 31.18 ± 0.2% | 1.46 ± 0.2% | 21.40 ± 0.4% | 7.05 ± 0.2% | 1.19 ± 0.1% | 7.10 ± 0.3% | 31.13 ± 0.1% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 29.44 ± 0.3% | 29.42 ± 0.2% | 1.01 ± 0.2% | 23.18 ± 0.2% | 3.50 ± 1.5% | differs | 2.96 ± 0.2% | 29.42 ± 0.1% | 1.00 | 1.00 | 1.27 | 8.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.61 ± 0.5% | 11.59 ± 0.5% | 11.65 ± 0.4% | 11.35 ± 0.2% | 4.98 ± 1.8% | 0.90 ± 0.8% | none | 11.62 ± 0.2% | 1.00 | 1.00 | 1.02 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.44 ± 0.3% | 223.02 ± 0.2% | 258.93 ± 0.2% | 87.39 ± 0.3% | 219.84 ± 1.4% | 481.54 ± 0.9% | 3875.41 ± 2.6% | 222.38 ± 0.2% | 1.00 | 1.00 | 2.55 | 1.01 |
| a UUID | 62 | 145.48 ± 0.1% | 145.80 ± 0.2% | 160.90 ± 0.2% | 46.48 ± 0.2% | 98.76 ± 1.4% | 185.90 ± 2.5% | 4428.88 ± 1.8% | 145.47 ± 0.2% | 1.00 | 1.00 | 3.13 | 1.47 |
| an IPv4 address | 29 | 439.93 ± 0.3% | 444.28 ± 0.3% | 616.23 ± 0.6% | 77.05 ± 0.6% | 131.53 ± 1.4% | 295.65 ± 1.2% | 7630.67 ± 0.1% | 440.85 ± 0.2% | 0.99 | 1.00 | 5.71 | 3.34 |
| a date and time | 56 | 320.04 ± 0.3% | 321.40 ± 0.2% | 402.87 ± 0.2% | 73.17 ± 0.5% | 134.50 ± 12.4% | 317.86 ± 2.1% | 4932.42 ± 0.4% | 319.96 ± 0.4% | 1.00 | 1.00 | 4.37 | 2.38 |
| a field path | 39 | 208.91 ± 0.1% | 209.79 ± 0.2% | 241.70 ± 0.3% | 80.94 ± 0.5% | 203.68 ± 1.8% | 502.98 ± 2.5% | 4927.75 ± 0.5% | 208.74 ± 0.1% | 1.00 | 1.00 | 2.58 | 1.03 |
| literal: a word | 7 | 669.10 ± 0.2% | 721.09 ± 0.3% | 1288.29 ± 0.1% | 527.95 ± 0.3% | 624.51 ± 3.1% | 941.46 ± 0.5% | 30834.62 ± 0.3% | 669.11 ± 0.2% | 0.93 | 1.00 | 1.27 | 1.07 |
| literal: a word that is not there | 8 | 641.48 ± 0.2% | 695.40 ± 0.2% | 1210.66 ± 0.1% | 475.93 ± 0.3% | 598.00 ± 2.5% | 894.55 ± 0.7% | 29581.44 ± 0.3% | 640.61 ± 0.2% | 0.92 | 1.00 | 1.35 | 1.07 |
| literal: one of four words | 26 | 252.55 ± 0.2% | 418.09 ± 0.4% | 564.25 ± 0.6% | 49.43 ± 0.6% | 238.71 ± 1.5% | 361.92 ± 1.5% | 15851.86 ± 0.3% | 252.84 ± 0.3% | 0.60 | 1.00 | 5.11 | 1.06 |
| literal: a word in any case | 11 | 518.82 ± 0.3% | 564.26 ± 0.1% | 871.48 ± 0.3% | 15.44 ± 0.4% | 641.55 ± 2.0% | refused | 23828.63 ± 0.5% | 519.54 ± 0.4% | 0.92 | 1.00 | 33.61 | 0.81 |
| literal: an href attribute | 12 | 352.23 ± 0.3% | 363.48 ± 0.4% | 471.81 ± 0.2% | 45.54 ± 0.9% | 496.07 ± 1.6% | 776.78 ± 0.6% | 22326.07 ± 0.5% | 352.13 ± 0.2% | 0.97 | 1.00 | 7.73 | 0.71 |
| literal: a word, second text | 10 | 593.92 ± 0.5% | 655.42 ± 0.8% | 1097.38 ± 0.6% | 429.76 ± 0.8% | 533.64 ± 2.0% | 806.06 ± 0.5% | 27629.18 ± 0.8% | 593.11 ± 0.5% | 0.91 | 1.00 | 1.38 | 1.11 |
| class: two capitalized words | 23 | 463.85 ± 0.2% | 493.65 ± 0.3% | 714.26 ± 0.3% | 101.26 ± 0.2% | 497.53 ± 0.7% | 738.68 ± 0.4% | 6638.26 ± 0.3% | 464.15 ± 0.2% | 0.94 | 1.00 | 4.58 | 0.93 |
| class: a word that ends in ing | 9 | 601.76 ± 0.2% | 669.52 ± 0.4% | 1175.88 ± 0.1% | 132.19 ± 1.3% | 754.01 ± 0.8% | 1106.61 ± 2.2% | 16312.92 ± 0.1% | 601.72 ± 0.7% | 0.90 | 1.00 | 4.55 | 0.80 |
| class: a word in capitals | 16 | 530.91 ± 0.4% | 570.46 ± 0.5% | 914.12 ± 0.7% | 136.23 ± 0.6% | 746.66 ± 1.4% | 1013.91 ± 1.0% | 8720.46 ± 0.2% | 530.68 ± 0.2% | 0.93 | 1.00 | 3.90 | 0.71 |
| class: a number | 6 | 667.14 ± 0.6% | 729.01 ± 1.1% | 1369.12 ± 0.0% | 41.98 ± 0.6% | 1404.80 ± 1.0% | 1893.39 ± 1.2% | 23180.18 ± 0.3% | 668.31 ± 0.7% | 0.92 | 1.00 | 15.89 | 0.47 |
| class: two capitalized words, second text | 23 | 464.37 ± 0.7% | 493.11 ± 0.3% | 713.86 ± 0.3% | 104.22 ± 0.3% | 499.30 ± 1.0% | 730.01 ± 0.5% | 6633.76 ± 0.8% | 464.44 ± 0.3% | 0.94 | 1.00 | 4.46 | 0.93 |
| other: a word between two words | 13 | 582.47 ± 0.5% | 601.05 ± 0.4% | 957.60 ± 0.4% | 134.97 ± 0.9% | 499.67 ± 1.2% | 806.61 ± 1.1% | 15095.01 ± 0.3% | 583.24 ± 0.6% | 0.97 | 1.00 | 4.32 | 1.17 |
| other: a number before a unit, second text | 15 | 407.30 ± 0.7% | 442.06 ± 0.3% | 610.11 ± 0.8% | 39.51 ± 0.2% | 630.28 ± 0.9% | 885.31 ± 0.7% | 15362.06 ± 0.4% | 407.30 ± 0.3% | 0.92 | 1.00 | 10.31 | 0.65 |
| other: a heading's start tag | 13 | 363.03 ± 0.4% | 367.03 ± 0.2% | 479.01 ± 0.4% | 44.52 ± 0.3% | 628.51 ± 0.8% | 860.74 ± 0.6% | 18576.65 ± 0.4% | 362.67 ± 0.2% | 0.99 | 1.00 | 8.15 | 0.58 |
| other: a whole word | 11 | 616.76 ± 0.2% | 655.77 ± 0.2% | 1087.64 ± 0.1% | 121.46 ± 0.5% | 566.11 ± 2.0% | 819.23 ± 0.9% | 27228.47 ± 0.6% | 616.44 ± 0.2% | 0.94 | 1.00 | 5.08 | 1.09 |
| other: a line's first word, second text | 17 | 561.34 ± 0.5% | 584.42 ± 0.6% | 937.19 ± 0.2% | 130.37 ± 0.1% | 703.50 ± 0.4% | refused | refused | 560.70 ± 0.4% | 0.96 | 1.00 | 4.31 | 0.80 |
| other: fourteen octets before an x | 16 | 112.35 ± 0.5% | 161.81 ± 0.6% | 184.71 ± 1.0% | 15.13 ± 0.3% | 453.48 ± 1.1% | 414.76 ± 0.9% | 12833.19 ± 0.5% | 112.13 ± 0.4% | 0.69 | 1.00 | 7.43 | 0.25 |
| other: a Greek word | 8 | 451.50 ± 0.3% | 596.14 ± 0.4% | 969.01 ± 0.1% | 59.27 ± 0.3% | 1375.66 ± 1.6% | 1782.61 ± 0.7% | refused | 450.78 ± 0.3% | 0.76 | 1.00 | 7.62 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12813.31 ± 0.4% | not timed | not timed | 16053.39 ± 1.6% | 2111.29 ± 19.7% | not timed | not timed | 12816.75 ± 1.0% | | 1.00 | 0.80 | 6.07 |
| 01-literal/sherlock-casei-en | 522 | 3907.43 ± 0.6% | not timed | not timed | 3594.10 ± 0.1% | 32.35 ± 0.1% | not timed | not timed | 3906.24 ± 0.3% | | 1.00 | 1.09 | 120.80 |
| 01-literal/sherlock-ru | 724 | 13654.07 ± 0.4% | not timed | not timed | 17288.08 ± 0.6% | 1513.98 ± 12.8% | not timed | not timed | 13626.90 ± 0.3% | | 1.00 | 0.79 | 9.02 |
| 01-literal/sherlock-casei-ru | 746 | 5313.57 ± 0.5% | not timed | not timed | 3334.41 ± 0.2% | 30.71 ± 7.4% | not timed | not timed | 5317.85 ± 0.7% | | 1.00 | 1.59 | 173.04 |
| 01-literal/sherlock-zh | 30 | 16770.34 ± 0.6% | not timed | not timed | 18168.93 ± 2.0% | 2759.66 ± 3.6% | not timed | not timed | 16753.27 ± 0.6% | | 1.00 | 0.92 | 6.08 |
| 02-literal-alternate/sherlock-en | 714 | 5812.36 ± 0.4% | not timed | not timed | 3937.12 ± 0.2% | 16.66 ± 2.7% | not timed | not timed | 5812.10 ± 0.3% | | 1.00 | 1.48 | 348.98 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1680.20 ± 0.9% | not timed | not timed | 694.65 ± 0.2% | 11.03 ± 0.1% | not timed | not timed | 1675.95 ± 0.2% | | 1.00 | 2.42 | 152.39 |
| 02-literal-alternate/sherlock-ru | 899 | 4716.60 ± 0.1% | not timed | not timed | 3255.47 ± 0.1% | 22.58 ± 0.1% | not timed | not timed | 4717.35 ± 0.2% | | 1.00 | 1.45 | 208.86 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1795.90 ± 0.6% | not timed | not timed | 1233.70 ± 0.1% | 9.06 ± 0.3% | not timed | not timed | 1790.11 ± 0.4% | | 1.00 | 1.46 | 198.20 |
| 02-literal-alternate/sherlock-zh | 207 | 7034.88 ± 0.8% | not timed | not timed | 4152.40 ± 0.4% | 31.52 ± 0.1% | not timed | not timed | 7062.76 ± 1.0% | | 1.00 | 1.69 | 223.16 |
| 03-date/ascii | 111817 | 123.50 ± 0.7% | not timed | not timed | 96.37 ± 0.1% | 0.20 ± 5.0% | not timed | not timed | 123.69 ± 1.1% | | 1.00 | 1.28 | 619.31 |
| 04-ruff-noqa/real | 84 | 555.15 ± 0.1% | not timed | not timed | 463.23 ± 0.1% | 19.85 ± 1.2% | not timed | not timed | 555.66 ± 0.1% | | 1.00 | 1.20 | 27.96 |
| 04-ruff-noqa/tweaked | 44 | 559.15 ± 0.3% | not timed | not timed | 459.77 ± 0.1% | 366.41 ± 1.5% | not timed | not timed | 558.82 ± 0.1% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 3.70 ± 0.8% | not timed | not timed | 5.07 ± 0.2% | 0.20 ± 3.9% | not timed | not timed | 3.68 ± 2.7% | | 1.00 | 0.73 | 18.06 |
| 06-cloud-flare-redos/original | 107 | 184.68 ± 0.2% | not timed | not timed | 216.26 ± 0.1% | 25.01 ± 0.2% | not timed | not timed | 184.31 ± 0.4% | | 1.00 | 0.85 | 7.38 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.30 ± 0.2% | not timed | not timed | 228.20 ± 0.1% | 26.81 ± 0.2% | not timed | not timed | 145.29 ± 0.1% | | 1.00 | 0.64 | 5.42 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.63 ± 2.6% | not timed | not timed | 254.80 ± 0.1% | 28.80 ± 0.1% | not timed | not timed | 154.77 ± 2.7% | | 1.00 | 0.61 | 5.37 |
| 07-unicode-character-data/parse-line | 558784 | 241.75 ± 2.2% | not timed | not timed | 171.97 ± 0.0% | 42.74 ± 5.2% | not timed | not timed | 240.76 ± 1.4% | | 1.00 | 1.41 | 5.66 |
| 08-words/all-english | 56691 | 102.75 ± 0.5% | not timed | not timed | 83.33 ± 0.1% | 13.10 ± 10.4% | not timed | not timed | 102.54 ± 0.3% | | 1.00 | 1.23 | 7.84 |
| 08-words/long-english | 839 | 999.07 ± 0.0% | not timed | not timed | 597.86 ± 0.0% | 32.59 ± 0.8% | not timed | not timed | 998.64 ± 0.2% | | 1.00 | 1.67 | 30.66 |
| 09-aws-keys/full | 0 | 424.01 ± 0.1% | not timed | not timed | 460.00 ± 0.2% | 64.79 ± 0.1% | not timed | not timed | 424.27 ± 0.1% | | 1.00 | 0.92 | 6.54 |
| 09-aws-keys/quick | 0 | 744.20 ± 0.1% | not timed | not timed | 988.70 ± 0.6% | 415.96 ± 0.4% | not timed | not timed | 742.11 ± 0.1% | | 1.00 | 0.75 | 1.79 |
| 10-bounded-repeat/letters-en | 1833 | 586.32 ± 0.3% | not timed | not timed | 518.29 ± 0.2% | 19.47 ± 0.2% | not timed | not timed | 585.22 ± 0.1% | | 1.00 | 1.13 | 30.12 |
| 10-bounded-repeat/letters-ru | 3475 | 401.55 ± 0.2% | not timed | not timed | 479.30 ± 0.2% | 22.01 ± 7.6% | not timed | not timed | 400.49 ± 0.5% | | 1.00 | 0.84 | 18.24 |
| 10-bounded-repeat/context | 53 | 79.49 ± 0.9% | not timed | not timed | 65.81 ± 0.3% | 19.79 ± 0.2% | not timed | not timed | 79.40 ± 1.0% | | 1.00 | 1.21 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 1046.68 ± 0.1% | not timed | not timed | 616.75 ± 0.1% | 36.63 ± 0.0% | not timed | not timed | 1046.30 ± 0.2% | | 1.00 | 1.70 | 28.58 |
| 11-unstructured-to-json/extract | 600 | 47.72 ± 0.1% | not timed | not timed | 76.97 ± 0.4% | 48.69 ± 0.3% | not timed | not timed | 46.92 ± 0.2% | | 1.02 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 603.48 ± 0.6% | not timed | not timed | 561.26 ± 0.2% | 0.41 ± 0.2% | not timed | not timed | 602.63 ± 0.4% | | 1.00 | 1.08 | 1481.29 |
| 14-quadratic/1x | 100 | 12.60 ± 0.2% | not timed | not timed | 10.07 ± 0.1% | 0.98 ± 1.3% | not timed | not timed | 12.42 ± 1.6% | | 1.01 | 1.25 | 12.89 |
| 14-quadratic/2x | 200 | 7.83 ± 0.2% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.6% | not timed | not timed | 7.78 ± 1.2% | | 1.01 | 1.41 | 14.70 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.0% | not timed | not timed | 1.87 ± 0.2% | | 1.00 | 1.54 | 16.24 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.4% | not timed | not timed | 0.34 ± 0.5% | 0.54 ± 2.0% | not timed | not timed | 1.54 ± 1.2% | | 1.00 | 4.51 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 86.95 ± 0.0% | not timed | not timed | 13.74 ± 0.3% | 140.00 ± 6.3% | not timed | not timed | 86.89 ± 0.9% | | 1.00 | 6.33 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.34 ± 0.4% | not timed | not timed | 2.54 ± 0.9% | 6.38 ± 2.2% | not timed | not timed | 14.30 ± 0.9% | | 1.00 | 5.66 | 2.25 |
| 07-unicode-character-data/compile | 1 | 55.47 ± 0.2% | not timed | not timed | 25.89 ± 0.3% | 36.08 ± 3.6% | not timed | not timed | 55.35 ± 0.9% | | 1.00 | 2.14 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.41 ± 0.1% | not timed | not timed | 8.31 ± 0.2% | 23.17 ± 2.7% | not timed | not timed | 42.29 ± 0.7% | | 1.00 | 5.10 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 190.51 ± 0.2% | not timed | not timed | 47.55 ± 0.6% | 134.34 ± 2.7% | not timed | not timed | 188.78 ± 1.2% | | 1.01 | 4.01 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.60 ± 1.3% | not timed | not timed | 11.16 ± 0.3% | 15.79 ± 3.1% | not timed | not timed | 14.45 ± 0.8% | | 1.01 | 1.31 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.13 ± 0.3% | not timed | not timed | 8.06 ± 0.2% | 23.60 ± 1.2% | not timed | not timed | 84.76 ± 0.5% | | 1.00 | 10.56 | 3.61 |
| 11-unstructured-to-json/compile | 1 | 86.81 ± 0.2% | not timed | not timed | 40.80 ± 0.3% | 68.44 ± 2.4% | not timed | not timed | 86.51 ± 1.2% | | 1.00 | 2.13 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 13.1% | 0.09 ± 14.7% | not timed | not timed | 0.35 ± 1.6% | | 1.01 | 5.11 | 3.89 |

