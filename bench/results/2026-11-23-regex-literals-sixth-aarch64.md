# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243483671 |
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
| literal: a word | 217 | 19311.74 ± 0.8% | 4990.06 ± 0.3% | 27.69 ± 0.4% | 18261.36 ± 1.7% | 9176.96 ± 7.5% | 17.56 ± 0.4% | 84.27 ± 0.6% | 19272.44 ± 3.1% | 3.87 | 1.00 | 1.06 | 2.10 |
| literal: a word that is not there | 0 | 21177.26 ± 5.5% | 4867.40 ± 0.3% | 27.82 ± 0.2% | 19846.25 ± 1.4% | 29046.65 ± 7.3% | 17.38 ± 0.2% | 79.65 ± 0.7% | 21687.12 ± 3.1% | 4.35 | 0.98 | 1.07 | 0.73 |
| literal: one of four words | 661 | 6379.15 ± 0.6% | 1932.68 ± 0.2% | 14.25 ± 0.1% | 3950.71 ± 0.3% | 21.90 ± 0.2% | 5.27 ± 0.2% | 6.85 ± 0.2% | 6356.61 ± 0.1% | 3.30 | 1.00 | 1.61 | 291.32 |
| literal: a word in any case | 217 | 15156.66 ± 1.6% | 2074.49 ± 0.4% | 21.16 ± 0.4% | 3956.89 ± 0.4% | 38.06 ± 0.7% | refused | differs | 15102.43 ± 0.5% | 7.31 | 1.00 | 3.83 | 398.21 |
| literal: an href attribute | 33 | 16573.12 ± 1.8% | 609.34 ± 0.1% | 26.54 ± 0.3% | 16772.47 ± 2.5% | 2257.81 ± 0.4% | 13.33 ± 0.2% | 74.08 ± 0.3% | 16512.59 ± 2.4% | 27.20 | 1.00 | 0.99 | 7.34 |
| literal: a word, second text | 123 | 20021.78 ± 3.6% | 3355.85 ± 0.5% | 27.39 ± 0.1% | 18429.90 ± 1.4% | 7547.09 ± 6.5% | 19.77 ± 0.4% | 70.26 ± 0.4% | 20138.74 ± 0.7% | 5.97 | 0.99 | 1.09 | 2.65 |
| class: two capitalized words | 1331 | 1055.90 ± 0.2% | 599.91 ± 0.3% | 25.36 ± 0.3% | 585.07 ± 0.1% | 40.55 ± 7.8% | 14.98 ± 0.2% | 67.04 ± 0.6% | 1057.52 ± 0.4% | 1.76 | 1.00 | 1.80 | 26.04 |
| class: a word that ends in ing | 3399 | 573.64 ± 0.3% | 573.16 ± 0.2% | 17.71 ± 2.4% | 547.50 ± 0.4% | 29.56 ± 9.2% | 8.25 ± 0.1% | 18.23 ± 0.2% | 572.46 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.41 |
| class: a word in capitals | 2332 | 1368.55 ± 0.3% | 603.08 ± 0.3% | 26.93 ± 0.2% | 572.18 ± 0.1% | 43.45 ± 2.7% | 17.28 ± 0.4% | 82.62 ± 1.6% | 1370.62 ± 0.5% | 2.27 | 1.00 | 2.39 | 31.50 |
| class: a number | 8288 | 1953.24 ± 0.5% | 826.86 ± 0.1% | 27.22 ± 0.3% | 1713.43 ± 0.1% | 41.11 ± 13.0% | 0.56 ± 0.5% | 57.52 ± 0.8% | 1952.47 ± 0.2% | 2.36 | 1.00 | 1.14 | 47.51 |
| class: two capitalized words, second text | 5359 | 515.76 ± 0.2% | 523.57 ± 0.2% | 22.82 ± 0.1% | 484.90 ± 0.1% | 35.39 ± 15.3% | 16.71 ± 0.3% | 62.59 ± 1.0% | 515.09 ± 0.3% | 0.99 | 1.00 | 1.06 | 14.57 |
| other: a word between two words | 6104 | 796.44 ± 0.6% | 593.28 ± 0.2% | 23.07 ± 0.4% | 736.79 ± 0.2% | 109.35 ± 21.8% | 11.33 ± 0.3% | 67.95 ± 1.5% | 796.22 ± 0.1% | 1.34 | 1.00 | 1.08 | 7.28 |
| other: a number before a unit, second text | 1481 | 5982.74 ± 1.3% | 1099.85 ± 0.2% | 25.50 ± 0.2% | 5648.53 ± 0.6% | 40.74 ± 0.3% | 17.85 ± 0.2% | 65.26 ± 1.0% | 5852.62 ± 0.6% | 5.44 | 1.02 | 1.06 | 146.86 |
| other: a heading's start tag | 110 | 13888.11 ± 1.7% | 741.84 ± 0.2% | 26.85 ± 0.3% | 1710.78 ± 0.5% | 1578.72 ± 2.5% | 16.23 ± 0.2% | 85.94 ± 1.5% | 13902.23 ± 1.0% | 18.72 | 1.00 | 8.12 | 8.80 |
| other: a whole word | 217 | 15746.57 ± 1.2% | 602.35 ± 0.5% | 28.59 ± 0.2% | 14265.80 ± 1.0% | 49.40 ± 0.2% | 13.82 ± 0.4% | 54.42 ± 2.2% | 15737.87 ± 0.5% | 26.14 | 1.00 | 1.10 | 318.73 |
| other: a line's first word, second text | 3716 | 2042.11 ± 0.7% | 587.57 ± 0.3% | 29.91 ± 0.4% | 1726.34 ± 0.4% | 62.19 ± 6.8% | refused | refused | 2038.11 ± 0.2% | 3.48 | 1.00 | 1.18 | 32.83 |
| other: fourteen octets before an x | 87 | 23790.75 ± 2.0% | 243.75 ± 0.7% | 6.51 ± 0.1% | 3975.41 ± 0.2% | 10.66 ± 0.2% | differs | 17.71 ± 0.2% | 23777.56 ± 1.6% | 97.60 | 1.00 | 5.98 | 2232.17 |
| other: a Greek word | 21815 | 488.05 ± 1.1% | 408.82 ± 0.1% | 30.46 ± 0.4% | 289.24 ± 0.2% | 49.11 ± 8.9% | differs | refused | 486.05 ± 0.5% | 1.19 | 1.00 | 1.69 | 9.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.45 ± 0.3% | 18.48 ± 0.3% | 0.86 ± 0.4% | 19.80 ± 0.3% | 2.75 ± 0.7% | differs | 3.99 ± 0.1% | 18.49 ± 0.3% | 1.00 | 1.00 | 0.93 | 6.70 |
| a UUID | 32895 | 20.09 ± 0.1% | 20.12 ± 0.4% | 0.64 ± 0.2% | 15.10 ± 0.5% | 3.11 ± 0.4% | 0.72 ± 0.4% | 3.63 ± 0.3% | 20.14 ± 0.2% | 1.00 | 1.00 | 1.33 | 6.47 |
| an IPv4 address | 33176 | 33.62 ± 0.2% | 33.67 ± 0.2% | 2.07 ± 0.4% | 29.06 ± 0.1% | 6.60 ± 0.1% | differs | 4.14 ± 0.1% | 33.66 ± 0.2% | 1.00 | 1.00 | 1.16 | 5.09 |
| a date and time | 32954 | 28.70 ± 0.2% | 28.89 ± 0.2% | 1.44 ± 0.3% | 21.16 ± 0.3% | 7.02 ± 0.3% | 1.20 ± 0.2% | 7.12 ± 0.2% | 28.86 ± 0.4% | 0.99 | 0.99 | 1.36 | 4.09 |
| a field path | 32606 | 21.75 ± 0.1% | 21.79 ± 0.2% | 1.02 ± 0.2% | 22.99 ± 0.1% | 3.47 ± 1.3% | differs | 2.93 ± 0.2% | 21.79 ± 0.1% | 1.00 | 1.00 | 0.95 | 6.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.5% | 11.08 ± 0.3% | 11.07 ± 0.5% | 11.48 ± 0.1% | 4.93 ± 2.2% | 0.92 ± 0.1% | none | 11.09 ± 0.3% | 1.00 | 1.00 | 0.96 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.06 ± 0.1% | 221.96 ± 0.5% | 264.18 ± 0.1% | 87.05 ± 0.2% | 220.44 ± 1.1% | 450.57 ± 0.4% | 3807.23 ± 0.4% | 221.07 ± 0.2% | 1.00 | 1.00 | 2.54 | 1.00 |
| a UUID | 62 | 143.31 ± 0.2% | 143.67 ± 0.2% | 161.06 ± 0.1% | 45.80 ± 0.1% | 98.26 ± 0.6% | 173.45 ± 0.9% | 4268.88 ± 0.6% | 143.34 ± 0.2% | 1.00 | 1.00 | 3.13 | 1.46 |
| an IPv4 address | 29 | 412.03 ± 0.6% | 416.43 ± 0.5% | 596.65 ± 0.4% | 77.16 ± 1.0% | 130.36 ± 5.8% | 270.73 ± 0.8% | 7553.18 ± 0.2% | 412.34 ± 0.3% | 0.99 | 1.00 | 5.34 | 3.16 |
| a date and time | 56 | 294.74 ± 0.3% | 296.69 ± 0.4% | 375.71 ± 0.4% | 72.47 ± 0.3% | 136.91 ± 1.6% | 301.93 ± 0.4% | 4920.44 ± 0.4% | 294.67 ± 0.4% | 0.99 | 1.00 | 4.07 | 2.15 |
| a field path | 39 | 213.66 ± 0.2% | 214.33 ± 0.2% | 252.28 ± 0.2% | 80.08 ± 0.5% | 204.86 ± 1.2% | 451.25 ± 0.5% | 4838.04 ± 0.5% | 213.56 ± 0.2% | 1.00 | 1.00 | 2.67 | 1.04 |
| literal: a word | 7 | 610.04 ± 0.3% | 663.48 ± 0.7% | 1220.80 ± 0.5% | 508.21 ± 2.0% | 623.89 ± 3.4% | 844.02 ± 0.4% | 29730.31 ± 0.2% | 609.54 ± 0.4% | 0.92 | 1.00 | 1.20 | 0.98 |
| literal: a word that is not there | 8 | 592.53 ± 0.5% | 644.48 ± 0.2% | 1152.66 ± 0.2% | 466.55 ± 0.1% | 599.18 ± 4.0% | 804.80 ± 0.4% | 28540.48 ± 0.1% | 591.91 ± 0.8% | 0.92 | 1.00 | 1.27 | 0.99 |
| literal: one of four words | 26 | 236.70 ± 0.2% | 392.44 ± 0.3% | 541.58 ± 0.4% | 49.53 ± 0.3% | 239.86 ± 3.1% | 328.20 ± 1.4% | 15700.15 ± 0.3% | 236.78 ± 0.6% | 0.60 | 1.00 | 4.78 | 0.99 |
| literal: a word in any case | 11 | 433.90 ± 0.1% | 464.92 ± 0.3% | 689.87 ± 0.2% | 15.97 ± 1.0% | 646.13 ± 3.1% | refused | 23409.48 ± 0.6% | 433.46 ± 0.2% | 0.93 | 1.00 | 27.17 | 0.67 |
| literal: an href attribute | 12 | 332.27 ± 0.1% | 345.60 ± 0.3% | 459.62 ± 0.3% | 44.13 ± 4.5% | 499.59 ± 1.8% | 714.05 ± 2.9% | 21287.97 ± 0.7% | 332.41 ± 0.3% | 0.96 | 1.00 | 7.53 | 0.67 |
| literal: a word, second text | 10 | 546.24 ± 0.3% | 604.96 ± 0.3% | 1037.55 ± 0.2% | 415.90 ± 0.1% | 535.38 ± 2.4% | 743.51 ± 0.3% | 26394.11 ± 0.1% | 546.76 ± 0.3% | 0.90 | 1.00 | 1.31 | 1.02 |
| class: two capitalized words | 23 | 419.44 ± 0.5% | 454.49 ± 0.7% | 671.13 ± 0.6% | 102.38 ± 0.2% | 496.33 ± 1.6% | 681.91 ± 1.9% | 6448.33 ± 0.2% | 419.69 ± 0.4% | 0.92 | 1.00 | 4.10 | 0.85 |
| class: a word that ends in ing | 9 | 539.57 ± 0.4% | 611.44 ± 0.3% | 1103.21 ± 0.1% | 132.49 ± 1.1% | 745.07 ± 1.1% | 1048.79 ± 3.2% | 15772.28 ± 0.1% | 538.93 ± 0.4% | 0.88 | 1.00 | 4.07 | 0.72 |
| class: a word in capitals | 16 | 472.31 ± 0.1% | 518.89 ± 0.5% | 866.44 ± 0.2% | 136.06 ± 0.6% | 744.03 ± 1.1% | 973.57 ± 1.8% | 8493.21 ± 0.2% | 471.85 ± 0.8% | 0.91 | 1.00 | 3.47 | 0.63 |
| class: a number | 6 | 595.68 ± 0.3% | 669.15 ± 0.6% | 1320.47 ± 0.0% | 42.23 ± 0.8% | 1382.02 ± 0.7% | 1745.19 ± 0.4% | 22274.67 ± 0.1% | 596.07 ± 0.2% | 0.89 | 1.00 | 14.11 | 0.43 |
| class: two capitalized words, second text | 23 | 419.44 ± 0.4% | 454.33 ± 0.3% | 670.98 ± 0.2% | 103.50 ± 0.5% | 493.63 ± 2.3% | 701.60 ± 0.5% | 6445.40 ± 0.5% | 419.27 ± 0.8% | 0.92 | 1.00 | 4.05 | 0.85 |
| other: a word between two words | 13 | 527.03 ± 0.6% | 549.07 ± 0.4% | 900.73 ± 0.3% | 136.29 ± 1.0% | 494.48 ± 1.9% | 730.19 ± 1.0% | 14662.60 ± 0.1% | 527.75 ± 0.3% | 0.96 | 1.00 | 3.87 | 1.07 |
| other: a number before a unit, second text | 15 | 380.95 ± 0.9% | 420.75 ± 0.4% | 596.72 ± 0.4% | 39.71 ± 0.9% | 627.23 ± 1.1% | 822.50 ± 0.1% | 14946.66 ± 0.3% | 380.09 ± 0.5% | 0.91 | 1.00 | 9.59 | 0.61 |
| other: a heading's start tag | 13 | 342.07 ± 0.7% | 349.81 ± 0.4% | 467.67 ± 0.4% | 43.70 ± 0.4% | 624.02 ± 2.0% | 793.14 ± 0.5% | 17663.61 ± 0.3% | 342.05 ± 0.6% | 0.98 | 1.00 | 7.83 | 0.55 |
| other: a whole word | 11 | 566.74 ± 0.8% | 605.44 ± 0.4% | 1036.06 ± 0.6% | 121.29 ± 0.4% | 551.87 ± 2.0% | 765.32 ± 0.6% | 26629.25 ± 0.2% | 566.87 ± 0.7% | 0.94 | 1.00 | 4.67 | 1.03 |
| other: a line's first word, second text | 17 | 517.80 ± 0.3% | 542.33 ± 0.4% | 891.70 ± 0.2% | 128.98 ± 0.3% | 705.59 ± 1.4% | refused | refused | 515.69 ± 0.7% | 0.95 | 1.00 | 4.01 | 0.73 |
| other: fourteen octets before an x | 16 | 105.43 ± 0.6% | 150.69 ± 0.7% | 174.90 ± 0.7% | 14.89 ± 0.5% | 446.76 ± 1.6% | 386.90 ± 0.4% | 12630.34 ± 0.7% | 105.39 ± 0.2% | 0.70 | 1.00 | 7.08 | 0.24 |
| other: a Greek word | 8 | 410.45 ± 0.4% | 567.54 ± 0.4% | 985.82 ± 0.7% | 58.22 ± 0.5% | 1375.82 ± 1.4% | 1659.86 ± 0.5% | refused | 410.88 ± 0.2% | 0.72 | 1.00 | 7.05 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15586.01 ± 1.7% | not timed | not timed | 16053.10 ± 2.2% | 2119.47 ± 13.9% | not timed | not timed | 15626.33 ± 2.5% | | 1.00 | 0.97 | 7.35 |
| 01-literal/sherlock-casei-en | 522 | 5157.93 ± 0.8% | not timed | not timed | 3588.03 ± 0.1% | 32.39 ± 0.4% | not timed | not timed | 5160.27 ± 0.6% | | 1.00 | 1.44 | 159.26 |
| 01-literal/sherlock-ru | 724 | 17102.67 ± 0.5% | not timed | not timed | 17272.81 ± 0.3% | 1279.42 ± 17.4% | not timed | not timed | 17079.94 ± 0.3% | | 1.00 | 0.99 | 13.37 |
| 01-literal/sherlock-casei-ru | 746 | 6168.40 ± 0.0% | not timed | not timed | 3329.00 ± 0.2% | 30.73 ± 0.2% | not timed | not timed | 6164.55 ± 0.1% | | 1.00 | 1.85 | 200.76 |
| 01-literal/sherlock-zh | 30 | 19494.89 ± 0.4% | not timed | not timed | 18432.88 ± 0.5% | 2488.10 ± 17.8% | not timed | not timed | 19384.53 ± 0.7% | | 1.01 | 1.06 | 7.84 |
| 02-literal-alternate/sherlock-en | 714 | 6046.40 ± 0.6% | not timed | not timed | 3942.17 ± 0.2% | 16.58 ± 0.2% | not timed | not timed | 6057.28 ± 0.2% | | 1.00 | 1.53 | 364.65 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1935.77 ± 1.3% | not timed | not timed | 697.58 ± 0.2% | 11.12 ± 0.1% | not timed | not timed | 1924.93 ± 0.5% | | 1.01 | 2.77 | 174.03 |
| 02-literal-alternate/sherlock-ru | 899 | 5562.05 ± 0.2% | not timed | not timed | 3251.99 ± 0.1% | 22.61 ± 0.1% | not timed | not timed | 5556.44 ± 0.1% | | 1.00 | 1.71 | 246.03 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.44 ± 0.4% | not timed | not timed | 1232.34 ± 0.1% | 9.07 ± 0.2% | not timed | not timed | 2049.35 ± 0.1% | | 1.00 | 1.67 | 226.88 |
| 02-literal-alternate/sherlock-zh | 207 | 7292.09 ± 0.4% | not timed | not timed | 4160.64 ± 0.3% | 31.57 ± 0.0% | not timed | not timed | 7286.02 ± 0.3% | | 1.00 | 1.75 | 230.97 |
| 03-date/ascii | 111817 | 124.02 ± 0.6% | not timed | not timed | 96.60 ± 0.1% | 0.20 ± 3.9% | not timed | not timed | 123.29 ± 0.7% | | 1.01 | 1.28 | 610.60 |
| 04-ruff-noqa/real | 84 | 401.82 ± 0.1% | not timed | not timed | 456.71 ± 0.0% | 19.57 ± 1.3% | not timed | not timed | 401.53 ± 0.0% | | 1.00 | 0.88 | 20.54 |
| 04-ruff-noqa/tweaked | 44 | 561.19 ± 0.2% | not timed | not timed | 455.43 ± 0.2% | 367.09 ± 0.7% | not timed | not timed | 562.01 ± 0.2% | | 1.00 | 1.23 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.13 ± 0.1% | not timed | not timed | 5.09 ± 0.2% | 0.20 ± 5.7% | not timed | not timed | 5.04 ± 4.1% | | 1.02 | 1.01 | 26.04 |
| 06-cloud-flare-redos/original | 107 | 414.92 ± 0.2% | not timed | not timed | 214.55 ± 0.0% | 24.54 ± 6.1% | not timed | not timed | 414.93 ± 0.4% | | 1.00 | 1.93 | 16.91 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.40 ± 0.2% | not timed | not timed | 228.55 ± 0.1% | 26.30 ± 5.8% | not timed | not timed | 410.44 ± 2.8% | | 1.00 | 1.80 | 15.61 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.62 ± 0.3% | not timed | not timed | 255.48 ± 0.2% | 28.82 ± 0.2% | not timed | not timed | 583.25 ± 0.5% | | 1.00 | 2.28 | 20.25 |
| 07-unicode-character-data/parse-line | 558784 | 235.35 ± 0.1% | not timed | not timed | 171.75 ± 0.2% | 43.11 ± 2.0% | not timed | not timed | 234.90 ± 0.7% | | 1.00 | 1.37 | 5.46 |
| 08-words/all-english | 56691 | 116.52 ± 0.1% | not timed | not timed | 83.16 ± 0.2% | 13.36 ± 15.6% | not timed | not timed | 116.59 ± 0.5% | | 1.00 | 1.40 | 8.72 |
| 08-words/long-english | 839 | 612.16 ± 0.2% | not timed | not timed | 596.05 ± 0.2% | 32.65 ± 0.2% | not timed | not timed | 614.29 ± 1.2% | | 1.00 | 1.03 | 18.75 |
| 09-aws-keys/full | 0 | 408.15 ± 0.2% | not timed | not timed | 462.02 ± 0.1% | 64.51 ± 3.7% | not timed | not timed | 407.84 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 911.26 ± 0.4% | not timed | not timed | 991.93 ± 0.3% | 405.35 ± 3.6% | not timed | not timed | 910.96 ± 0.2% | | 1.00 | 0.92 | 2.25 |
| 10-bounded-repeat/letters-en | 1833 | 583.72 ± 1.7% | not timed | not timed | 518.52 ± 0.2% | 19.56 ± 0.8% | not timed | not timed | 579.44 ± 1.8% | | 1.01 | 1.13 | 29.84 |
| 10-bounded-repeat/letters-ru | 3475 | 510.27 ± 1.1% | not timed | not timed | 478.77 ± 0.1% | 22.00 ± 9.0% | not timed | not timed | 507.46 ± 0.9% | | 1.01 | 1.07 | 23.20 |
| 10-bounded-repeat/context | 53 | 77.28 ± 0.4% | not timed | not timed | 65.58 ± 0.7% | 19.83 ± 0.1% | not timed | not timed | 77.13 ± 0.4% | | 1.00 | 1.18 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.52 ± 8.3% | not timed | not timed | 618.39 ± 0.0% | 36.68 ± 0.2% | not timed | not timed | 634.20 ± 8.4% | | 1.00 | 1.03 | 17.33 |
| 11-unstructured-to-json/extract | 600 | 82.82 ± 0.1% | not timed | not timed | 78.10 ± 0.1% | 48.84 ± 0.5% | not timed | not timed | 82.39 ± 0.8% | | 1.01 | 1.06 | 1.70 |
| 12-dictionary/single | 1 | 559.56 ± 0.4% | not timed | not timed | 560.34 ± 0.0% | 0.41 ± 0.1% | not timed | not timed | 559.69 ± 0.4% | | 1.00 | 1.00 | 1379.08 |
| 14-quadratic/1x | 100 | 21.21 ± 0.4% | not timed | not timed | 10.06 ± 0.2% | 0.98 ± 2.8% | not timed | not timed | 21.05 ± 0.5% | | 1.01 | 2.11 | 21.61 |
| 14-quadratic/2x | 200 | 17.47 ± 0.2% | not timed | not timed | 5.45 ± 0.1% | 0.53 ± 0.5% | not timed | not timed | 17.51 ± 1.1% | | 1.00 | 3.21 | 32.68 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.68 ± 0.3% | | 1.00 | 6.33 | 66.79 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.3% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 5.5% | not timed | not timed | 1.25 ± 2.4% | | 1.00 | 3.66 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 88.30 ± 0.2% | not timed | not timed | 13.74 ± 0.2% | 138.47 ± 2.6% | not timed | not timed | 87.79 ± 1.1% | | 1.01 | 6.42 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 13.87 ± 1.3% | not timed | not timed | 2.53 ± 0.9% | 6.44 ± 2.7% | not timed | not timed | 13.80 ± 1.0% | | 1.01 | 5.47 | 2.15 |
| 07-unicode-character-data/compile | 1 | 53.65 ± 0.4% | not timed | not timed | 25.85 ± 0.3% | 35.98 ± 2.1% | not timed | not timed | 53.14 ± 1.4% | | 1.01 | 2.08 | 1.49 |
| 09-aws-keys/compile-full | 1 | 40.98 ± 0.1% | not timed | not timed | 8.21 ± 0.8% | 23.31 ± 2.1% | not timed | not timed | 40.67 ± 0.3% | | 1.01 | 4.99 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 178.99 ± 0.2% | not timed | not timed | 46.91 ± 0.2% | 132.41 ± 3.7% | not timed | not timed | 178.39 ± 1.2% | | 1.00 | 3.82 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 13.54 ± 0.4% | not timed | not timed | 11.10 ± 0.2% | 15.85 ± 1.4% | not timed | not timed | 13.49 ± 1.5% | | 1.00 | 1.22 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 80.70 ± 0.4% | not timed | not timed | 8.13 ± 0.2% | 23.62 ± 1.3% | not timed | not timed | 80.54 ± 1.9% | | 1.00 | 9.92 | 3.42 |
| 11-unstructured-to-json/compile | 1 | 83.87 ± 0.1% | not timed | not timed | 41.34 ± 0.2% | 67.96 ± 3.9% | not timed | not timed | 83.31 ± 2.2% | | 1.01 | 2.03 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 1.5% | 0.09 ± 16.1% | not timed | not timed | 0.35 ± 1.5% | | 1.01 | 5.10 | 3.72 |

