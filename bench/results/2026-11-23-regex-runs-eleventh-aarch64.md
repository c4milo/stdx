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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148097561 |
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
| literal: a word | 217 | 16199.31 ± 1.9% | 1040.06 ± 0.4% | 28.84 ± 0.9% | 18340.17 ± 2.7% | 9128.77 ± 9.0% | 17.18 ± 0.5% | 86.57 ± 0.2% | 16194.95 ± 1.1% | 15.58 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18849.79 ± 2.2% | 1049.15 ± 0.2% | 28.88 ± 0.5% | 19829.96 ± 3.3% | 29454.34 ± 1.1% | 16.96 ± 0.2% | 82.38 ± 0.1% | 18901.05 ± 0.7% | 17.97 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6056.52 ± 0.8% | 1023.82 ± 0.2% | 14.75 ± 0.3% | 3946.47 ± 0.5% | 21.87 ± 0.2% | 5.36 ± 0.4% | 6.94 ± 0.6% | 6044.12 ± 0.4% | 5.92 | 1.00 | 1.53 | 276.93 |
| literal: a word in any case | 217 | 12628.40 ± 0.3% | 1039.98 ± 0.1% | 21.66 ± 1.2% | 3977.60 ± 0.2% | 37.93 ± 0.5% | refused | differs | 12615.68 ± 0.6% | 12.14 | 1.00 | 3.17 | 332.95 |
| literal: an href attribute | 33 | 13688.23 ± 0.5% | 1046.18 ± 0.1% | 27.48 ± 0.3% | 16829.12 ± 0.8% | 2252.99 ± 5.3% | 13.06 ± 0.4% | 75.42 ± 0.2% | 13703.55 ± 0.7% | 13.08 | 1.00 | 0.81 | 6.08 |
| literal: a word, second text | 123 | 16423.88 ± 1.9% | 1043.74 ± 0.2% | 28.32 ± 0.2% | 18456.59 ± 2.5% | 7668.83 ± 3.8% | 20.13 ± 0.3% | 70.10 ± 0.6% | 16446.03 ± 2.1% | 15.74 | 1.00 | 0.89 | 2.14 |
| class: two capitalized words | 1331 | 1097.86 ± 0.6% | 978.09 ± 0.2% | 26.28 ± 0.2% | 584.86 ± 0.1% | 40.49 ± 2.2% | 14.67 ± 0.3% | 68.79 ± 0.2% | 1107.13 ± 0.4% | 1.12 | 0.99 | 1.88 | 27.11 |
| class: a word that ends in ing | 3399 | 894.46 ± 0.1% | 894.84 ± 0.1% | 18.27 ± 0.4% | 547.90 ± 0.0% | 29.60 ± 12.6% | 8.14 ± 0.1% | 18.42 ± 0.4% | 894.49 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.21 |
| class: a word in capitals | 2332 | 1454.93 ± 0.2% | 949.53 ± 0.1% | 27.87 ± 0.3% | 572.70 ± 0.1% | 43.59 ± 0.1% | 17.11 ± 0.4% | 83.11 ± 0.2% | 1454.44 ± 0.3% | 1.53 | 1.00 | 2.54 | 33.38 |
| class: a number | 8288 | 1986.07 ± 0.2% | 835.98 ± 0.1% | 28.11 ± 0.3% | 1723.64 ± 0.1% | 41.47 ± 9.5% | 0.54 ± 0.4% | 56.53 ± 0.2% | 1987.20 ± 0.1% | 2.38 | 1.00 | 1.15 | 47.90 |
| class: two capitalized words, second text | 5359 | 743.10 ± 0.2% | 744.39 ± 0.2% | 23.50 ± 0.3% | 484.26 ± 0.1% | 32.59 ± 13.0% | 17.10 ± 0.2% | 63.85 ± 0.3% | 743.25 ± 0.1% | 1.00 | 1.00 | 1.53 | 22.80 |
| other: a word between two words | 6104 | 755.37 ± 0.1% | 777.29 ± 0.1% | 23.70 ± 0.3% | 740.75 ± 0.2% | 104.71 ± 13.1% | 11.11 ± 0.1% | 69.67 ± 0.1% | 753.46 ± 0.2% | 0.97 | 1.00 | 1.02 | 7.21 |
| other: a number before a unit, second text | 1481 | 5466.32 ± 1.0% | 984.46 ± 0.3% | 26.22 ± 0.2% | 5636.02 ± 0.4% | 40.72 ± 11.9% | 18.14 ± 0.2% | 66.93 ± 0.3% | 5445.30 ± 0.4% | 5.55 | 1.00 | 0.97 | 134.25 |
| other: a heading's start tag | 110 | 12570.83 ± 0.9% | 1035.67 ± 0.1% | 27.75 ± 0.5% | 1711.29 ± 0.3% | 1584.30 ± 5.4% | 15.91 ± 0.2% | 88.87 ± 1.0% | 12545.75 ± 0.3% | 12.14 | 1.00 | 7.35 | 7.93 |
| other: a whole word | 217 | 14052.37 ± 0.4% | 1038.54 ± 0.1% | 29.88 ± 0.2% | 14716.48 ± 0.3% | 49.36 ± 10.4% | 13.08 ± 0.3% | 55.72 ± 0.5% | 14019.27 ± 0.5% | 13.53 | 1.00 | 0.95 | 284.66 |
| other: a line's first word, second text | 3716 | 1971.08 ± 0.4% | 877.13 ± 0.2% | 31.42 ± 0.1% | 1725.14 ± 0.6% | 61.23 ± 8.1% | refused | refused | 1960.84 ± 0.5% | 2.25 | 1.01 | 1.14 | 32.19 |
| other: fourteen octets before an x | 87 | 19909.60 ± 1.2% | 238.12 ± 0.7% | 6.59 ± 0.1% | 3983.06 ± 0.7% | 10.64 ± 0.2% | differs | 17.76 ± 0.0% | 20010.26 ± 0.9% | 83.61 | 0.99 | 5.00 | 1870.82 |
| other: a Greek word | 21815 | 515.11 ± 0.3% | 412.59 ± 0.1% | 31.34 ± 0.1% | 289.76 ± 0.4% | 49.50 ± 7.6% | differs | refused | 511.36 ± 0.4% | 1.25 | 1.01 | 1.78 | 10.41 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.90 ± 0.1% | 25.87 ± 0.1% | 0.87 ± 0.3% | 19.80 ± 0.5% | 2.76 ± 0.5% | differs | 3.95 ± 0.2% | 25.89 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.39 |
| a UUID | 32895 | 21.09 ± 0.2% | 21.16 ± 0.2% | 0.65 ± 0.2% | 15.16 ± 0.7% | 3.10 ± 0.3% | 0.74 ± 0.2% | 3.53 ± 0.3% | 21.22 ± 0.3% | 1.00 | 0.99 | 1.39 | 6.80 |
| an IPv4 address | 33176 | 36.92 ± 0.2% | 36.92 ± 0.2% | 2.10 ± 0.4% | 28.98 ± 0.5% | 6.67 ± 0.2% | differs | 4.12 ± 0.2% | 37.02 ± 0.1% | 1.00 | 1.00 | 1.27 | 5.54 |
| a date and time | 32954 | 31.29 ± 0.5% | 31.28 ± 0.6% | 1.47 ± 0.4% | 21.47 ± 0.8% | 7.04 ± 0.3% | 1.25 ± 0.3% | 7.11 ± 0.2% | 31.24 ± 0.5% | 1.00 | 1.00 | 1.46 | 4.45 |
| a field path | 32606 | 29.52 ± 0.3% | 29.52 ± 0.2% | 1.03 ± 0.2% | 23.28 ± 0.2% | 3.50 ± 1.3% | differs | 2.92 ± 0.3% | 29.51 ± 0.3% | 1.00 | 1.00 | 1.27 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.4% | 11.46 ± 0.8% | 11.48 ± 0.7% | 11.46 ± 0.1% | 4.99 ± 1.5% | 0.94 ± 0.5% | none | 11.44 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.30 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.94 ± 0.2% | 235.75 ± 0.2% | 286.03 ± 0.2% | 86.73 ± 0.6% | 222.78 ± 1.2% | 448.40 ± 0.4% | 3867.57 ± 1.4% | 233.77 ± 0.2% | 0.99 | 1.00 | 2.70 | 1.05 |
| a UUID | 62 | 155.05 ± 0.3% | 155.29 ± 0.1% | 176.41 ± 0.4% | 45.64 ± 0.9% | 100.19 ± 1.1% | 173.92 ± 2.1% | 4397.81 ± 0.9% | 154.86 ± 0.2% | 1.00 | 1.00 | 3.40 | 1.55 |
| an IPv4 address | 29 | 416.88 ± 0.5% | 422.60 ± 0.3% | 610.85 ± 0.2% | 77.89 ± 0.3% | 132.32 ± 1.1% | 276.42 ± 0.4% | 7612.23 ± 0.2% | 417.20 ± 0.6% | 0.99 | 1.00 | 5.35 | 3.15 |
| a date and time | 56 | 305.81 ± 0.4% | 308.26 ± 0.2% | 396.87 ± 0.1% | 73.01 ± 1.2% | 138.46 ± 1.4% | 309.18 ± 1.1% | 4907.66 ± 0.5% | 305.98 ± 0.2% | 0.99 | 1.00 | 4.19 | 2.21 |
| a field path | 39 | 224.52 ± 0.2% | 226.12 ± 0.4% | 271.51 ± 0.2% | 79.62 ± 0.4% | 207.49 ± 1.3% | 459.25 ± 0.8% | 4940.33 ± 3.8% | 224.65 ± 0.5% | 0.99 | 1.00 | 2.82 | 1.08 |
| literal: a word | 7 | 619.32 ± 0.5% | 662.61 ± 0.5% | 1253.14 ± 0.8% | 490.77 ± 0.3% | 635.16 ± 1.8% | 875.07 ± 0.4% | 29478.45 ± 0.3% | 619.84 ± 0.4% | 0.93 | 1.00 | 1.26 | 0.98 |
| literal: a word that is not there | 8 | 596.31 ± 0.2% | 645.71 ± 0.3% | 1184.32 ± 0.2% | 451.69 ± 0.3% | 614.68 ± 1.9% | 825.99 ± 0.3% | 28542.38 ± 0.2% | 596.10 ± 0.2% | 0.92 | 1.00 | 1.32 | 0.97 |
| literal: one of four words | 26 | 240.64 ± 0.4% | 400.06 ± 0.4% | 561.91 ± 0.3% | 50.73 ± 0.9% | 247.38 ± 1.5% | 339.41 ± 0.2% | 15420.95 ± 0.3% | 240.86 ± 0.4% | 0.60 | 1.00 | 4.74 | 0.97 |
| literal: a word in any case | 11 | 482.57 ± 0.5% | 514.67 ± 0.5% | 841.71 ± 0.4% | 15.61 ± 0.4% | 663.81 ± 2.5% | refused | 23432.26 ± 0.1% | 482.79 ± 0.3% | 0.94 | 1.00 | 30.91 | 0.73 |
| literal: an href attribute | 12 | 350.97 ± 0.3% | 363.78 ± 0.4% | 497.67 ± 0.3% | 45.18 ± 0.5% | 505.57 ± 2.5% | 722.92 ± 0.3% | 21468.68 ± 0.3% | 350.89 ± 0.4% | 0.96 | 1.00 | 7.77 | 0.69 |
| literal: a word, second text | 10 | 556.84 ± 0.5% | 610.88 ± 0.5% | 1067.87 ± 0.6% | 398.13 ± 0.2% | 544.75 ± 1.8% | 744.82 ± 0.3% | 26447.02 ± 0.2% | 556.52 ± 0.2% | 0.91 | 1.00 | 1.40 | 1.02 |
| class: two capitalized words | 23 | 433.03 ± 0.7% | 464.88 ± 0.6% | 703.04 ± 0.4% | 100.40 ± 0.3% | 507.33 ± 0.2% | 695.11 ± 0.5% | 6568.98 ± 0.2% | 432.62 ± 0.5% | 0.93 | 1.00 | 4.31 | 0.85 |
| class: a word that ends in ing | 9 | 551.50 ± 0.4% | 623.66 ± 0.2% | 1160.60 ± 0.4% | 132.78 ± 0.9% | 764.55 ± 0.9% | 1015.79 ± 1.8% | 16007.97 ± 0.0% | 550.97 ± 0.3% | 0.88 | 1.00 | 4.15 | 0.72 |
| class: a word in capitals | 16 | 483.98 ± 0.2% | 528.45 ± 0.4% | 900.15 ± 0.3% | 135.31 ± 1.5% | 754.93 ± 1.4% | 953.27 ± 0.6% | 8642.50 ± 0.1% | 484.11 ± 0.3% | 0.92 | 1.00 | 3.58 | 0.64 |
| class: a number | 6 | 604.53 ± 0.3% | 677.80 ± 0.3% | 1359.64 ± 0.0% | 41.80 ± 0.6% | 1416.58 ± 1.1% | 1687.10 ± 1.4% | 22500.67 ± 0.1% | 603.84 ± 0.2% | 0.89 | 1.00 | 14.46 | 0.43 |
| class: two capitalized words, second text | 23 | 433.00 ± 0.3% | 465.32 ± 0.6% | 703.84 ± 0.3% | 101.57 ± 0.2% | 506.11 ± 1.5% | 682.49 ± 0.5% | 6571.37 ± 0.2% | 432.80 ± 0.2% | 0.93 | 1.00 | 4.26 | 0.86 |
| other: a word between two words | 13 | 548.73 ± 0.3% | 567.55 ± 0.2% | 947.75 ± 0.2% | 133.01 ± 0.2% | 507.01 ± 0.6% | 742.14 ± 0.5% | 14801.28 ± 0.1% | 547.93 ± 0.1% | 0.97 | 1.00 | 4.13 | 1.08 |
| other: a number before a unit, second text | 15 | 402.10 ± 0.6% | 442.80 ± 0.5% | 646.95 ± 0.2% | 39.51 ± 0.4% | 636.82 ± 0.9% | 814.14 ± 0.7% | 15079.42 ± 0.3% | 402.19 ± 0.3% | 0.91 | 1.00 | 10.18 | 0.63 |
| other: a heading's start tag | 13 | 359.02 ± 0.5% | 365.22 ± 0.4% | 501.10 ± 0.4% | 43.76 ± 0.5% | 624.74 ± 1.5% | 796.70 ± 0.7% | 17852.57 ± 0.4% | 359.00 ± 0.3% | 0.98 | 1.00 | 8.20 | 0.57 |
| other: a whole word | 11 | 580.05 ± 1.4% | 614.82 ± 1.7% | 1084.74 ± 1.0% | 118.07 ± 0.3% | 562.70 ± 1.2% | 756.04 ± 2.4% | 26552.56 ± 0.1% | 580.53 ± 1.4% | 0.94 | 1.00 | 4.91 | 1.03 |
| other: a line's first word, second text | 17 | 528.48 ± 0.4% | 546.56 ± 0.4% | 930.99 ± 0.7% | 130.87 ± 0.3% | 711.77 ± 2.2% | refused | refused | 526.41 ± 0.9% | 0.97 | 1.00 | 4.04 | 0.74 |
| other: fourteen octets before an x | 16 | 111.19 ± 0.3% | 160.86 ± 0.7% | 188.77 ± 0.9% | 15.19 ± 0.5% | 454.16 ± 2.1% | 386.93 ± 0.5% | 12556.56 ± 0.5% | 111.21 ± 0.2% | 0.69 | 1.00 | 7.32 | 0.24 |
| other: a Greek word | 8 | 420.93 ± 0.4% | 581.02 ± 0.2% | 1037.88 ± 0.2% | 59.12 ± 0.3% | 1395.00 ± 2.0% | 1690.42 ± 0.4% | refused | 421.19 ± 0.2% | 0.72 | 1.00 | 7.12 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12861.94 ± 0.7% | not timed | not timed | 16248.10 ± 0.7% | 2129.15 ± 17.6% | not timed | not timed | 12890.42 ± 1.2% | | 1.00 | 0.79 | 6.04 |
| 01-literal/sherlock-casei-en | 522 | 4495.50 ± 0.9% | not timed | not timed | 3580.29 ± 0.2% | 32.54 ± 0.5% | not timed | not timed | 4492.22 ± 0.3% | | 1.00 | 1.26 | 138.16 |
| 01-literal/sherlock-ru | 724 | 13533.12 ± 0.6% | not timed | not timed | 17281.26 ± 0.4% | 1388.30 ± 6.6% | not timed | not timed | 13516.18 ± 0.7% | | 1.00 | 0.78 | 9.75 |
| 01-literal/sherlock-casei-ru | 746 | 5292.52 ± 0.1% | not timed | not timed | 3328.20 ± 0.1% | 31.58 ± 0.1% | not timed | not timed | 5297.58 ± 0.1% | | 1.00 | 1.59 | 167.57 |
| 01-literal/sherlock-zh | 30 | 16983.91 ± 0.4% | not timed | not timed | 18508.67 ± 0.9% | 2640.91 ± 5.5% | not timed | not timed | 16953.44 ± 0.2% | | 1.00 | 0.92 | 6.43 |
| 02-literal-alternate/sherlock-en | 714 | 5748.92 ± 0.2% | not timed | not timed | 3939.12 ± 0.4% | 16.59 ± 0.3% | not timed | not timed | 5750.40 ± 0.2% | | 1.00 | 1.46 | 346.44 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1710.50 ± 1.2% | not timed | not timed | 697.66 ± 0.1% | 11.14 ± 0.1% | not timed | not timed | 1708.13 ± 0.8% | | 1.00 | 2.45 | 153.59 |
| 02-literal-alternate/sherlock-ru | 899 | 4628.01 ± 0.1% | not timed | not timed | 3253.74 ± 0.0% | 22.58 ± 0.1% | not timed | not timed | 4653.02 ± 0.1% | | 0.99 | 1.42 | 204.94 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1815.10 ± 0.7% | not timed | not timed | 1230.28 ± 0.2% | 9.13 ± 0.2% | not timed | not timed | 1807.58 ± 0.3% | | 1.00 | 1.48 | 198.86 |
| 02-literal-alternate/sherlock-zh | 207 | 7022.61 ± 0.3% | not timed | not timed | 4165.29 ± 0.3% | 31.42 ± 1.5% | not timed | not timed | 7030.78 ± 0.6% | | 1.00 | 1.69 | 223.52 |
| 03-date/ascii | 111817 | 127.00 ± 0.6% | not timed | not timed | 95.24 ± 0.1% | 0.20 ± 3.4% | not timed | not timed | 126.37 ± 0.5% | | 1.01 | 1.33 | 636.98 |
| 04-ruff-noqa/real | 84 | 554.04 ± 0.1% | not timed | not timed | 466.74 ± 0.5% | 19.56 ± 1.3% | not timed | not timed | 553.91 ± 0.1% | | 1.00 | 1.19 | 28.33 |
| 04-ruff-noqa/tweaked | 44 | 549.24 ± 0.1% | not timed | not timed | 467.01 ± 0.1% | 366.82 ± 0.9% | not timed | not timed | 547.92 ± 0.1% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 4.22 ± 0.5% | not timed | not timed | 5.20 ± 0.1% | 0.20 ± 2.4% | not timed | not timed | 4.24 ± 0.4% | | 1.00 | 0.81 | 20.76 |
| 06-cloud-flare-redos/original | 107 | 263.33 ± 0.4% | not timed | not timed | 216.99 ± 0.1% | 24.90 ± 0.2% | not timed | not timed | 263.49 ± 0.2% | | 1.00 | 1.21 | 10.57 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.38 ± 0.2% | not timed | not timed | 228.37 ± 0.1% | 26.74 ± 0.2% | not timed | not timed | 259.54 ± 0.3% | | 1.00 | 1.14 | 9.70 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.13 ± 0.2% | not timed | not timed | 254.91 ± 0.3% | 28.78 ± 0.1% | not timed | not timed | 286.25 ± 0.3% | | 1.00 | 1.12 | 9.94 |
| 07-unicode-character-data/parse-line | 558784 | 232.75 ± 0.2% | not timed | not timed | 179.49 ± 0.1% | 43.49 ± 6.7% | not timed | not timed | 230.56 ± 2.4% | | 1.01 | 1.30 | 5.35 |
| 08-words/all-english | 56691 | 120.83 ± 0.3% | not timed | not timed | 83.24 ± 0.1% | 11.80 ± 4.3% | not timed | not timed | 120.18 ± 0.3% | | 1.01 | 1.45 | 10.24 |
| 08-words/long-english | 839 | 1006.36 ± 0.1% | not timed | not timed | 597.55 ± 0.1% | 32.48 ± 4.2% | not timed | not timed | 1006.33 ± 0.2% | | 1.00 | 1.68 | 30.98 |
| 09-aws-keys/full | 0 | 409.03 ± 0.2% | not timed | not timed | 493.85 ± 0.1% | 64.63 ± 0.1% | not timed | not timed | 409.20 ± 0.1% | | 1.00 | 0.83 | 6.33 |
| 09-aws-keys/quick | 0 | 744.72 ± 0.1% | not timed | not timed | 1000.82 ± 0.2% | 423.52 ± 2.1% | not timed | not timed | 742.13 ± 0.2% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 638.28 ± 0.5% | not timed | not timed | 518.03 ± 0.5% | 19.45 ± 0.3% | not timed | not timed | 637.62 ± 0.2% | | 1.00 | 1.23 | 32.82 |
| 10-bounded-repeat/letters-ru | 3475 | 385.01 ± 0.1% | not timed | not timed | 477.84 ± 0.2% | 23.61 ± 3.9% | not timed | not timed | 383.94 ± 0.6% | | 1.00 | 0.81 | 16.31 |
| 10-bounded-repeat/context | 53 | 79.25 ± 1.1% | not timed | not timed | 66.41 ± 1.0% | 19.82 ± 0.2% | not timed | not timed | 79.08 ± 1.2% | | 1.00 | 1.19 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1042.01 ± 0.1% | not timed | not timed | 618.66 ± 0.0% | 36.62 ± 0.1% | not timed | not timed | 1042.29 ± 0.1% | | 1.00 | 1.68 | 28.45 |
| 11-unstructured-to-json/extract | 600 | 49.79 ± 0.3% | not timed | not timed | 77.05 ± 0.3% | 49.09 ± 3.8% | not timed | not timed | 48.46 ± 1.2% | | 1.03 | 0.65 | 1.01 |
| 12-dictionary/single | 1 | 565.71 ± 0.4% | not timed | not timed | 560.90 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 568.07 ± 0.7% | | 1.00 | 1.01 | 1390.73 |
| 14-quadratic/1x | 100 | 9.67 ± 0.6% | not timed | not timed | 10.03 ± 0.1% | 0.99 ± 2.6% | not timed | not timed | 9.58 ± 1.1% | | 1.01 | 0.96 | 9.81 |
| 14-quadratic/2x | 200 | 5.57 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 5.56 ± 0.5% | | 1.00 | 1.00 | 10.51 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 1.26 ± 0.5% | | 1.00 | 1.04 | 10.91 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.7% | not timed | not timed | 0.35 ± 1.2% | 0.56 ± 1.8% | not timed | not timed | 1.44 ± 1.2% | | 1.01 | 4.19 | 2.59 |
| 04-ruff-noqa/compile-real | 1 | 92.69 ± 0.2% | not timed | not timed | 13.97 ± 0.1% | 142.24 ± 2.5% | not timed | not timed | 92.61 ± 1.3% | | 1.00 | 6.64 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.59 ± 1.4% | not timed | not timed | 2.55 ± 1.0% | 6.55 ± 1.8% | not timed | not timed | 14.46 ± 1.1% | | 1.01 | 5.71 | 2.23 |
| 07-unicode-character-data/compile | 1 | 58.36 ± 0.2% | not timed | not timed | 26.23 ± 0.4% | 36.62 ± 1.7% | not timed | not timed | 58.50 ± 0.3% | | 1.00 | 2.23 | 1.59 |
| 09-aws-keys/compile-full | 1 | 43.75 ± 0.2% | not timed | not timed | 8.37 ± 0.2% | 23.64 ± 1.5% | not timed | not timed | 43.50 ± 0.2% | | 1.01 | 5.22 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 186.69 ± 1.5% | not timed | not timed | 48.14 ± 0.1% | 135.53 ± 2.9% | not timed | not timed | 187.47 ± 0.4% | | 1.00 | 3.88 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.66 ± 0.9% | not timed | not timed | 11.17 ± 0.2% | 16.31 ± 4.1% | not timed | not timed | 14.58 ± 1.7% | | 1.01 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.28 ± 1.5% | not timed | not timed | 8.09 ± 0.1% | 24.15 ± 1.1% | not timed | not timed | 84.77 ± 0.6% | | 1.01 | 10.54 | 3.53 |
| 11-unstructured-to-json/compile | 1 | 90.52 ± 0.4% | not timed | not timed | 40.59 ± 0.8% | 70.03 ± 3.1% | not timed | not timed | 90.36 ± 0.9% | | 1.00 | 2.23 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 0.7% | 0.10 ± 10.1% | not timed | not timed | 0.36 ± 1.6% | | 1.01 | 5.14 | 3.73 |

