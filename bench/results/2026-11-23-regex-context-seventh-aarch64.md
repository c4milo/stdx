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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117654979 |
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
| literal: a word | 217 | 16053.09 ± 3.2% | 1037.19 ± 0.1% | 28.54 ± 0.4% | 18260.16 ± 4.6% | 8948.75 ± 22.8% | 17.51 ± 0.3% | 86.72 ± 0.2% | 16272.31 ± 23.7% | 15.48 | 0.99 | 0.88 | 1.79 |
| literal: a word that is not there | 0 | 18868.95 ± 2.4% | 1048.07 ± 0.2% | 28.50 ± 0.4% | 19805.57 ± 2.7% | 28905.54 ± 1.7% | 17.35 ± 0.2% | 82.48 ± 0.1% | 18869.52 ± 1.4% | 18.00 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6086.52 ± 5.5% | 1014.30 ± 0.2% | 14.61 ± 0.4% | 3948.26 ± 0.4% | 21.86 ± 0.1% | 5.29 ± 0.1% | 6.90 ± 0.3% | 6074.17 ± 3.0% | 6.00 | 1.00 | 1.54 | 278.41 |
| literal: a word in any case | 217 | 12587.35 ± 1.1% | 1037.25 ± 0.4% | 21.78 ± 0.8% | 3967.47 ± 0.2% | 38.08 ± 0.6% | refused | differs | 12558.89 ± 0.3% | 12.14 | 1.00 | 3.17 | 330.52 |
| literal: an href attribute | 33 | 13731.63 ± 2.2% | 1046.13 ± 0.2% | 27.27 ± 0.3% | 17056.83 ± 1.8% | 2251.65 ± 1.9% | 13.37 ± 0.2% | 75.65 ± 0.2% | 13707.71 ± 1.6% | 13.13 | 1.00 | 0.81 | 6.10 |
| literal: a word, second text | 123 | 16354.19 ± 1.7% | 1041.96 ± 0.1% | 28.09 ± 0.4% | 18298.89 ± 1.3% | 7569.34 ± 4.5% | 19.75 ± 0.4% | 70.01 ± 0.5% | 16540.28 ± 2.0% | 15.70 | 0.99 | 0.89 | 2.16 |
| class: two capitalized words | 1331 | 1125.14 ± 0.1% | 953.69 ± 0.8% | 25.99 ± 0.5% | 585.19 ± 0.1% | 40.74 ± 12.9% | 14.87 ± 0.4% | 68.94 ± 0.2% | 1124.20 ± 0.3% | 1.18 | 1.00 | 1.92 | 27.62 |
| class: a word that ends in ing | 3399 | 875.92 ± 0.2% | 876.38 ± 0.1% | 18.04 ± 0.1% | 547.97 ± 0.1% | 29.62 ± 3.4% | 8.23 ± 0.4% | 18.44 ± 0.6% | 874.60 ± 0.1% | 1.00 | 1.00 | 1.60 | 29.57 |
| class: a word in capitals | 2332 | 1476.85 ± 0.6% | 938.00 ± 0.2% | 27.56 ± 0.3% | 572.81 ± 0.1% | 43.64 ± 0.3% | 17.19 ± 0.1% | 83.34 ± 0.2% | 1476.16 ± 0.6% | 1.57 | 1.00 | 2.58 | 33.84 |
| class: a number | 8288 | 1993.27 ± 0.5% | 785.89 ± 0.1% | 27.89 ± 0.1% | 1732.75 ± 0.1% | 40.34 ± 16.3% | 0.56 ± 0.1% | 56.73 ± 0.6% | 1991.74 ± 0.3% | 2.54 | 1.00 | 1.15 | 49.41 |
| class: two capitalized words, second text | 5359 | 682.39 ± 0.1% | 678.59 ± 0.1% | 23.27 ± 0.2% | 485.11 ± 0.1% | 34.13 ± 10.7% | 16.71 ± 0.1% | 63.96 ± 0.3% | 682.09 ± 0.1% | 1.01 | 1.00 | 1.41 | 19.99 |
| other: a word between two words | 6104 | 767.03 ± 0.3% | 738.13 ± 0.2% | 23.43 ± 0.3% | 734.65 ± 0.1% | 108.74 ± 13.5% | 11.31 ± 0.1% | 69.75 ± 0.2% | 767.87 ± 0.1% | 1.04 | 1.00 | 1.04 | 7.05 |
| other: a number before a unit, second text | 1481 | 5557.41 ± 1.2% | 972.48 ± 0.1% | 25.93 ± 0.3% | 5664.86 ± 0.7% | 40.83 ± 11.3% | 17.83 ± 0.2% | 66.93 ± 0.3% | 5565.47 ± 1.4% | 5.71 | 1.00 | 0.98 | 136.11 |
| other: a heading's start tag | 110 | 12616.09 ± 1.3% | 1035.50 ± 0.2% | 27.43 ± 0.1% | 1709.75 ± 0.5% | 1569.23 ± 6.1% | 16.32 ± 0.3% | 88.98 ± 0.6% | 12626.41 ± 1.7% | 12.18 | 1.00 | 7.38 | 8.04 |
| other: a whole word | 217 | 13850.94 ± 1.9% | 1036.68 ± 0.1% | 29.40 ± 0.3% | 14334.12 ± 1.0% | 49.47 ± 0.2% | 13.68 ± 0.1% | 55.88 ± 0.2% | 13912.03 ± 1.0% | 13.36 | 1.00 | 0.97 | 280.01 |
| other: a line's first word, second text | 3716 | 1984.10 ± 0.7% | 855.54 ± 0.1% | 31.19 ± 0.1% | 1726.29 ± 0.6% | 61.52 ± 6.9% | refused | refused | 1974.16 ± 0.2% | 2.32 | 1.01 | 1.15 | 32.25 |
| other: fourteen octets before an x | 87 | 19143.57 ± 3.0% | 236.12 ± 0.4% | 6.13 ± 0.1% | 3958.44 ± 0.5% | 10.62 ± 0.3% | differs | 17.74 ± 0.1% | 19244.24 ± 1.6% | 81.07 | 0.99 | 4.84 | 1802.89 |
| other: a Greek word | 21815 | 486.57 ± 0.9% | 307.77 ± 0.4% | 30.93 ± 0.3% | 290.17 ± 0.1% | 44.59 ± 7.9% | differs | refused | 486.11 ± 0.9% | 1.58 | 1.00 | 1.68 | 10.91 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.90 ± 0.1% | 25.88 ± 0.1% | 0.82 ± 0.2% | 19.76 ± 0.5% | 2.78 ± 0.6% | differs | 4.00 ± 0.1% | 25.89 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.33 |
| a UUID | 32895 | 21.11 ± 0.2% | 21.22 ± 0.1% | 0.64 ± 0.2% | 15.10 ± 0.7% | 3.11 ± 0.1% | 0.72 ± 0.1% | 3.60 ± 0.3% | 21.19 ± 0.4% | 0.99 | 1.00 | 1.40 | 6.79 |
| an IPv4 address | 33176 | 37.00 ± 0.8% | 36.89 ± 0.3% | 2.09 ± 0.2% | 28.86 ± 0.6% | 6.68 ± 0.1% | differs | 4.13 ± 0.5% | 37.01 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.54 |
| a date and time | 32954 | 31.10 ± 0.3% | 31.13 ± 0.3% | 1.46 ± 0.2% | 21.15 ± 0.7% | 7.05 ± 0.2% | 1.20 ± 0.3% | 7.08 ± 0.6% | 31.13 ± 0.4% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.45 ± 0.1% | 29.33 ± 0.1% | 1.01 ± 0.2% | 23.00 ± 0.2% | 3.52 ± 0.8% | differs | 2.96 ± 0.5% | 29.43 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.36 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.64 ± 1.5% | 11.66 ± 1.4% | 11.66 ± 1.2% | 11.51 ± 0.2% | 4.96 ± 1.3% | 0.92 ± 0.8% | none | 11.62 ± 0.2% | 1.00 | 1.00 | 1.01 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.60 ± 0.2% | 217.97 ± 0.2% | 252.62 ± 0.1% | 86.66 ± 0.5% | 219.82 ± 1.8% | 478.90 ± 1.9% | 3856.17 ± 3.2% | 217.37 ± 0.6% | 1.00 | 1.00 | 2.51 | 0.99 |
| a UUID | 62 | 142.84 ± 0.3% | 143.25 ± 0.1% | 157.82 ± 0.1% | 46.34 ± 0.6% | 97.77 ± 0.4% | 189.90 ± 3.3% | 4441.01 ± 1.5% | 142.76 ± 0.3% | 1.00 | 1.00 | 3.08 | 1.46 |
| an IPv4 address | 29 | 440.71 ± 0.7% | 443.60 ± 0.3% | 615.32 ± 0.9% | 76.91 ± 0.3% | 129.56 ± 1.0% | 301.53 ± 1.5% | 7675.51 ± 0.3% | 440.38 ± 0.7% | 0.99 | 1.00 | 5.73 | 3.40 |
| a date and time | 56 | 319.57 ± 0.4% | 320.82 ± 0.4% | 404.20 ± 0.4% | 72.94 ± 0.5% | 134.52 ± 1.3% | 323.32 ± 1.3% | 4934.88 ± 0.7% | 319.42 ± 0.2% | 1.00 | 1.00 | 4.38 | 2.38 |
| a field path | 39 | 202.51 ± 0.4% | 203.39 ± 0.3% | 233.23 ± 0.3% | 80.98 ± 1.3% | 201.18 ± 1.3% | 501.44 ± 3.7% | 4920.36 ± 0.9% | 202.60 ± 0.3% | 1.00 | 1.00 | 2.50 | 1.01 |
| literal: a word | 7 | 667.74 ± 0.3% | 719.50 ± 0.2% | 1289.87 ± 0.2% | 520.84 ± 0.2% | 628.78 ± 2.3% | 956.03 ± 0.2% | 31146.90 ± 0.3% | 668.62 ± 0.4% | 0.93 | 1.00 | 1.28 | 1.06 |
| literal: a word that is not there | 8 | 636.43 ± 0.1% | 689.51 ± 0.7% | 1209.82 ± 0.1% | 478.59 ± 0.1% | 598.85 ± 2.5% | 906.21 ± 0.4% | 29517.68 ± 0.1% | 635.97 ± 0.2% | 0.92 | 1.00 | 1.33 | 1.06 |
| literal: one of four words | 26 | 256.23 ± 0.2% | 421.62 ± 0.3% | 570.50 ± 0.5% | 50.08 ± 1.1% | 240.61 ± 3.4% | 374.25 ± 0.7% | 15807.12 ± 0.2% | 256.38 ± 0.1% | 0.61 | 1.00 | 5.12 | 1.06 |
| literal: a word in any case | 11 | 519.39 ± 0.3% | 560.44 ± 0.2% | 863.94 ± 0.1% | 15.53 ± 1.3% | 644.72 ± 1.8% | refused | 23680.19 ± 0.1% | 519.23 ± 0.3% | 0.93 | 1.00 | 33.43 | 0.81 |
| literal: an href attribute | 12 | 352.17 ± 0.5% | 362.75 ± 0.3% | 472.89 ± 0.4% | 45.75 ± 0.6% | 497.51 ± 2.3% | 771.77 ± 0.8% | 22309.29 ± 0.1% | 351.81 ± 0.4% | 0.97 | 1.00 | 7.70 | 0.71 |
| literal: a word, second text | 10 | 593.38 ± 0.7% | 654.38 ± 0.6% | 1096.20 ± 0.4% | 401.41 ± 0.3% | 537.85 ± 1.4% | 799.29 ± 0.5% | 27537.82 ± 0.6% | 593.14 ± 0.4% | 0.91 | 1.00 | 1.48 | 1.10 |
| class: two capitalized words | 23 | 461.36 ± 0.6% | 491.16 ± 0.4% | 712.61 ± 0.2% | 99.90 ± 0.1% | 496.85 ± 1.3% | 739.98 ± 0.5% | 6625.12 ± 0.1% | 461.17 ± 0.4% | 0.94 | 1.00 | 4.62 | 0.93 |
| class: a word that ends in ing | 9 | 598.78 ± 0.5% | 666.66 ± 0.3% | 1174.35 ± 0.3% | 132.48 ± 1.9% | 755.03 ± 1.2% | 1100.81 ± 0.6% | 16274.89 ± 0.2% | 598.44 ± 0.6% | 0.90 | 1.00 | 4.52 | 0.79 |
| class: a word in capitals | 16 | 522.75 ± 0.4% | 560.35 ± 0.3% | 887.41 ± 0.3% | 135.47 ± 0.7% | 745.12 ± 1.0% | 1018.34 ± 1.0% | 8714.22 ± 1.8% | 522.74 ± 0.3% | 0.93 | 1.00 | 3.86 | 0.70 |
| class: a number | 6 | 661.54 ± 0.4% | 723.90 ± 0.5% | 1340.54 ± 0.1% | 41.84 ± 0.3% | 1402.79 ± 0.8% | 1851.85 ± 1.2% | 22944.48 ± 0.4% | 662.32 ± 0.2% | 0.91 | 1.00 | 15.81 | 0.47 |
| class: two capitalized words, second text | 23 | 461.22 ± 0.6% | 490.79 ± 0.2% | 712.34 ± 0.3% | 101.21 ± 0.3% | 500.47 ± 1.8% | 758.84 ± 0.6% | 6630.90 ± 0.2% | 461.53 ± 0.4% | 0.94 | 1.00 | 4.56 | 0.92 |
| other: a word between two words | 13 | 583.79 ± 0.1% | 603.13 ± 0.4% | 961.87 ± 0.1% | 133.67 ± 0.5% | 499.87 ± 1.3% | 814.07 ± 0.5% | 15094.59 ± 0.1% | 584.15 ± 0.3% | 0.97 | 1.00 | 4.37 | 1.17 |
| other: a number before a unit, second text | 15 | 400.74 ± 0.6% | 436.42 ± 0.4% | 597.75 ± 0.2% | 39.50 ± 0.4% | 631.43 ± 0.9% | 887.13 ± 0.9% | 15352.21 ± 0.2% | 401.83 ± 0.5% | 0.92 | 1.00 | 10.14 | 0.63 |
| other: a heading's start tag | 13 | 362.27 ± 0.5% | 366.54 ± 0.3% | 478.30 ± 0.4% | 43.12 ± 0.3% | 626.53 ± 1.1% | 875.70 ± 0.7% | 18509.83 ± 0.1% | 362.28 ± 0.3% | 0.99 | 1.00 | 8.40 | 0.58 |
| other: a whole word | 11 | 617.03 ± 0.3% | 655.72 ± 0.5% | 1094.04 ± 0.2% | 117.99 ± 0.5% | 559.81 ± 1.9% | 835.87 ± 0.3% | 27216.12 ± 0.3% | 617.35 ± 0.2% | 0.94 | 1.00 | 5.23 | 1.10 |
| other: a line's first word, second text | 17 | 556.74 ± 0.3% | 578.27 ± 0.4% | 925.76 ± 0.3% | 129.55 ± 0.4% | 704.51 ± 1.6% | refused | refused | 553.94 ± 0.7% | 0.96 | 1.01 | 4.30 | 0.79 |
| other: fourteen octets before an x | 16 | 112.43 ± 0.6% | 163.28 ± 1.1% | 185.60 ± 1.0% | 14.82 ± 0.3% | 452.65 ± 1.3% | 414.32 ± 0.5% | 12790.14 ± 0.6% | 112.39 ± 0.5% | 0.69 | 1.00 | 7.58 | 0.25 |
| other: a Greek word | 8 | 450.17 ± 0.2% | 594.31 ± 0.5% | 971.31 ± 0.1% | 59.10 ± 0.5% | 1393.93 ± 1.4% | 1791.47 ± 0.6% | refused | 450.35 ± 0.2% | 0.76 | 1.00 | 7.62 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12769.58 ± 0.4% | not timed | not timed | 15921.66 ± 0.4% | 1976.80 ± 12.6% | not timed | not timed | 12735.16 ± 0.2% | | 1.00 | 0.80 | 6.46 |
| 01-literal/sherlock-casei-en | 522 | 3921.18 ± 0.5% | not timed | not timed | 3592.62 ± 0.1% | 32.36 ± 0.3% | not timed | not timed | 3913.52 ± 0.4% | | 1.00 | 1.09 | 121.16 |
| 01-literal/sherlock-ru | 724 | 13653.91 ± 0.8% | not timed | not timed | 17260.10 ± 0.3% | 1418.38 ± 10.4% | not timed | not timed | 13604.10 ± 0.3% | | 1.00 | 0.79 | 9.63 |
| 01-literal/sherlock-casei-ru | 746 | 5306.99 ± 0.3% | not timed | not timed | 3324.15 ± 0.1% | 30.76 ± 0.6% | not timed | not timed | 5312.05 ± 0.2% | | 1.00 | 1.60 | 172.53 |
| 01-literal/sherlock-zh | 30 | 16667.44 ± 0.7% | not timed | not timed | 18210.67 ± 1.0% | 2917.88 ± 6.4% | not timed | not timed | 16632.21 ± 0.6% | | 1.00 | 0.92 | 5.71 |
| 02-literal-alternate/sherlock-en | 714 | 5828.37 ± 0.5% | not timed | not timed | 3937.07 ± 0.3% | 16.65 ± 0.1% | not timed | not timed | 5827.35 ± 0.2% | | 1.00 | 1.48 | 350.10 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1683.17 ± 0.8% | not timed | not timed | 695.10 ± 0.2% | 11.03 ± 0.2% | not timed | not timed | 1671.72 ± 0.5% | | 1.01 | 2.42 | 152.65 |
| 02-literal-alternate/sherlock-ru | 899 | 4709.45 ± 0.3% | not timed | not timed | 3258.49 ± 0.1% | 22.66 ± 0.1% | not timed | not timed | 4713.87 ± 0.2% | | 1.00 | 1.45 | 207.82 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1795.59 ± 0.5% | not timed | not timed | 1232.25 ± 0.2% | 9.07 ± 5.6% | not timed | not timed | 1789.23 ± 0.7% | | 1.00 | 1.46 | 198.02 |
| 02-literal-alternate/sherlock-zh | 207 | 7060.42 ± 0.3% | not timed | not timed | 4166.25 ± 0.2% | 31.53 ± 0.1% | not timed | not timed | 7053.04 ± 0.3% | | 1.00 | 1.69 | 223.96 |
| 03-date/ascii | 111817 | 124.25 ± 0.4% | not timed | not timed | 96.57 ± 0.0% | 0.20 ± 6.1% | not timed | not timed | 123.65 ± 0.5% | | 1.00 | 1.29 | 618.11 |
| 04-ruff-noqa/real | 84 | 548.25 ± 0.2% | not timed | not timed | 462.56 ± 0.1% | 19.56 ± 1.3% | not timed | not timed | 555.00 ± 0.1% | | 0.99 | 1.19 | 28.03 |
| 04-ruff-noqa/tweaked | 44 | 555.73 ± 0.1% | not timed | not timed | 459.56 ± 0.1% | 367.17 ± 0.2% | not timed | not timed | 557.99 ± 0.2% | | 1.00 | 1.21 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.5% | not timed | not timed | 4.98 ± 0.1% | 0.20 ± 3.2% | not timed | not timed | 3.72 ± 0.1% | | 0.99 | 0.74 | 18.00 |
| 06-cloud-flare-redos/original | 107 | 183.18 ± 0.5% | not timed | not timed | 216.75 ± 0.1% | 24.82 ± 0.2% | not timed | not timed | 183.54 ± 0.1% | | 1.00 | 0.85 | 7.38 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.07 ± 0.3% | not timed | not timed | 229.86 ± 0.1% | 26.67 ± 0.1% | not timed | not timed | 144.87 ± 0.1% | | 1.00 | 0.63 | 5.44 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.07 ± 5.0% | not timed | not timed | 256.66 ± 0.2% | 28.89 ± 0.1% | not timed | not timed | 154.30 ± 2.4% | | 1.00 | 0.60 | 5.33 |
| 07-unicode-character-data/parse-line | 558784 | 242.64 ± 2.0% | not timed | not timed | 173.24 ± 0.1% | 42.86 ± 2.4% | not timed | not timed | 238.85 ± 0.2% | | 1.02 | 1.40 | 5.66 |
| 08-words/all-english | 56691 | 102.74 ± 1.2% | not timed | not timed | 82.86 ± 0.1% | 13.08 ± 12.6% | not timed | not timed | 102.28 ± 0.4% | | 1.00 | 1.24 | 7.86 |
| 08-words/long-english | 839 | 999.17 ± 0.1% | not timed | not timed | 598.02 ± 0.1% | 32.57 ± 0.4% | not timed | not timed | 999.19 ± 0.1% | | 1.00 | 1.67 | 30.68 |
| 09-aws-keys/full | 0 | 424.27 ± 0.0% | not timed | not timed | 465.30 ± 0.2% | 64.77 ± 3.5% | not timed | not timed | 423.93 ± 0.1% | | 1.00 | 0.91 | 6.55 |
| 09-aws-keys/quick | 0 | 736.37 ± 0.1% | not timed | not timed | 984.70 ± 0.4% | 407.52 ± 3.2% | not timed | not timed | 732.07 ± 0.1% | | 1.01 | 0.75 | 1.81 |
| 10-bounded-repeat/letters-en | 1833 | 585.34 ± 0.1% | not timed | not timed | 517.98 ± 0.1% | 19.56 ± 0.3% | not timed | not timed | 584.78 ± 0.1% | | 1.00 | 1.13 | 29.93 |
| 10-bounded-repeat/letters-ru | 3475 | 401.76 ± 0.3% | not timed | not timed | 478.09 ± 0.1% | 21.92 ± 8.7% | not timed | not timed | 400.22 ± 0.5% | | 1.00 | 0.84 | 18.33 |
| 10-bounded-repeat/context | 53 | 79.73 ± 1.0% | not timed | not timed | 65.56 ± 0.3% | 19.46 ± 0.3% | not timed | not timed | 79.84 ± 1.2% | | 1.00 | 1.22 | 4.10 |
| 10-bounded-repeat/capitals | 11 | 1047.81 ± 0.2% | not timed | not timed | 616.78 ± 0.1% | 36.66 ± 0.1% | not timed | not timed | 1046.90 ± 0.1% | | 1.00 | 1.70 | 28.58 |
| 11-unstructured-to-json/extract | 600 | 48.23 ± 0.2% | not timed | not timed | 77.18 ± 0.2% | 48.93 ± 0.7% | not timed | not timed | 47.02 ± 0.9% | | 1.03 | 0.62 | 0.99 |
| 12-dictionary/single | 1 | 604.55 ± 0.3% | not timed | not timed | 560.72 ± 0.2% | 0.41 ± 0.3% | not timed | not timed | 604.56 ± 0.2% | | 1.00 | 1.08 | 1488.78 |
| 14-quadratic/1x | 100 | 12.58 ± 0.3% | not timed | not timed | 10.02 ± 0.5% | 0.98 ± 3.1% | not timed | not timed | 12.44 ± 0.8% | | 1.01 | 1.26 | 12.80 |
| 14-quadratic/2x | 200 | 7.82 ± 0.5% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 0.7% | not timed | not timed | 7.81 ± 1.3% | | 1.00 | 1.41 | 14.64 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.1% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.7% | not timed | not timed | 1.87 ± 0.4% | | 1.00 | 1.54 | 16.18 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.34 ± 0.2% | 0.55 ± 3.6% | not timed | not timed | 1.53 ± 1.3% | | 1.01 | 4.51 | 2.78 |
| 04-ruff-noqa/compile-real | 1 | 85.34 ± 0.2% | not timed | not timed | 13.66 ± 0.5% | 139.41 ± 1.1% | not timed | not timed | 84.54 ± 0.9% | | 1.01 | 6.25 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.49 ± 0.3% | not timed | not timed | 2.52 ± 0.6% | 6.41 ± 2.1% | not timed | not timed | 14.36 ± 1.6% | | 1.01 | 5.75 | 2.26 |
| 07-unicode-character-data/compile | 1 | 54.77 ± 0.2% | not timed | not timed | 26.08 ± 0.3% | 36.08 ± 3.3% | not timed | not timed | 54.68 ± 1.1% | | 1.00 | 2.10 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.16 ± 0.2% | not timed | not timed | 8.27 ± 0.4% | 23.10 ± 3.0% | not timed | not timed | 42.04 ± 0.8% | | 1.00 | 5.10 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 189.02 ± 0.1% | not timed | not timed | 47.21 ± 0.1% | 132.83 ± 11.5% | not timed | not timed | 189.04 ± 0.4% | | 1.00 | 4.00 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.37 ± 1.4% | not timed | not timed | 11.21 ± 0.2% | 15.73 ± 3.0% | not timed | not timed | 14.42 ± 1.6% | | 1.00 | 1.28 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 84.86 ± 0.2% | not timed | not timed | 8.02 ± 0.2% | 23.57 ± 0.8% | not timed | not timed | 84.61 ± 0.5% | | 1.00 | 10.58 | 3.60 |
| 11-unstructured-to-json/compile | 1 | 85.95 ± 0.2% | not timed | not timed | 40.84 ± 0.2% | 67.95 ± 2.8% | not timed | not timed | 85.72 ± 0.8% | | 1.00 | 2.10 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 0.4% | 0.09 ± 18.1% | not timed | not timed | 0.36 ± 0.4% | | 1.01 | 5.27 | 3.84 |

