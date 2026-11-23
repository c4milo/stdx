# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215329391 |
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
| literal: a word | 217 | 15811.64 ± 0.4% | 4988.56 ± 0.3% | 27.91 ± 0.6% | 17891.75 ± 4.7% | 9096.89 ± 7.3% | 17.42 ± 0.3% | 83.84 ± 1.0% | 15787.05 ± 1.5% | 3.17 | 1.00 | 0.88 | 1.74 |
| literal: a word that is not there | 0 | 18175.17 ± 4.0% | 4877.37 ± 0.3% | 28.04 ± 0.2% | 19122.63 ± 4.9% | 27641.83 ± 4.5% | 17.18 ± 0.1% | 79.43 ± 1.3% | 18322.03 ± 2.7% | 3.73 | 0.99 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6083.20 ± 0.4% | 1932.76 ± 0.1% | 14.28 ± 0.3% | 3921.24 ± 0.4% | 21.93 ± 0.1% | 5.43 ± 0.2% | 6.89 ± 0.6% | 6063.53 ± 0.6% | 3.15 | 1.00 | 1.55 | 277.45 |
| literal: a word in any case | 217 | 12586.72 ± 1.2% | 2073.45 ± 0.2% | 21.02 ± 2.0% | 3963.50 ± 0.3% | 36.77 ± 0.3% | refused | differs | 12546.31 ± 1.1% | 6.07 | 1.00 | 3.18 | 342.33 |
| literal: an href attribute | 33 | 13594.53 ± 2.2% | 616.00 ± 0.1% | 27.05 ± 0.1% | 16657.91 ± 3.5% | 2263.68 ± 0.4% | 13.16 ± 0.2% | 73.65 ± 1.2% | 13633.96 ± 1.9% | 22.07 | 1.00 | 0.82 | 6.01 |
| literal: a word, second text | 123 | 16521.22 ± 2.5% | 3349.46 ± 0.5% | 27.80 ± 0.3% | 18089.62 ± 1.9% | 7525.49 ± 4.1% | 20.14 ± 0.4% | 69.86 ± 1.2% | 16624.16 ± 1.3% | 4.93 | 0.99 | 0.91 | 2.20 |
| class: two capitalized words | 1331 | 1063.61 ± 0.8% | 603.80 ± 0.1% | 25.82 ± 0.4% | 585.22 ± 0.1% | 40.49 ± 2.8% | 14.75 ± 0.3% | 67.50 ± 1.0% | 1061.82 ± 0.4% | 1.76 | 1.00 | 1.82 | 26.27 |
| class: a word that ends in ing | 3399 | 580.13 ± 0.2% | 578.65 ± 0.2% | 16.96 ± 0.1% | 547.96 ± 0.1% | 29.00 ± 4.4% | 8.22 ± 0.1% | 18.40 ± 0.3% | 579.46 ± 0.1% | 1.00 | 1.00 | 1.06 | 20.00 |
| class: a word in capitals | 2332 | 1371.08 ± 0.5% | 614.82 ± 0.0% | 27.37 ± 0.3% | 572.60 ± 0.0% | 43.01 ± 2.8% | 17.20 ± 0.3% | 82.43 ± 0.9% | 1370.95 ± 0.4% | 2.23 | 1.00 | 2.39 | 31.88 |
| class: a number | 8288 | 2004.58 ± 0.8% | 834.13 ± 0.1% | 27.51 ± 0.5% | 1725.04 ± 0.1% | 38.30 ± 13.6% | 0.54 ± 0.5% | 57.62 ± 1.1% | 1999.16 ± 0.5% | 2.40 | 1.00 | 1.16 | 52.34 |
| class: two capitalized words, second text | 5359 | 521.27 ± 0.3% | 528.60 ± 0.2% | 23.07 ± 0.1% | 484.95 ± 0.0% | 34.85 ± 9.9% | 17.11 ± 0.2% | 62.42 ± 1.5% | 520.75 ± 0.2% | 0.99 | 1.00 | 1.07 | 14.96 |
| other: a word between two words | 6104 | 740.95 ± 0.2% | 598.49 ± 0.2% | 23.32 ± 0.2% | 727.99 ± 0.2% | 104.70 ± 18.7% | 11.21 ± 0.1% | 68.06 ± 0.9% | 740.42 ± 0.2% | 1.24 | 1.00 | 1.02 | 7.08 |
| other: a number before a unit, second text | 1481 | 5326.36 ± 0.8% | 1107.54 ± 0.6% | 25.87 ± 0.1% | 5657.69 ± 0.7% | 39.98 ± 0.2% | 18.21 ± 0.1% | 65.90 ± 0.2% | 5341.23 ± 0.8% | 4.81 | 1.00 | 0.94 | 133.22 |
| other: a heading's start tag | 110 | 12352.98 ± 0.8% | 751.08 ± 0.1% | 27.09 ± 0.3% | 1709.17 ± 0.6% | 1577.89 ± 4.9% | 16.11 ± 0.5% | 85.74 ± 0.4% | 12389.81 ± 1.9% | 16.45 | 1.00 | 7.23 | 7.83 |
| other: a whole word | 217 | 13764.48 ± 1.1% | 607.44 ± 0.3% | 29.16 ± 0.2% | 13956.31 ± 2.9% | 47.64 ± 0.1% | 13.39 ± 0.2% | 54.93 ± 0.5% | 13756.73 ± 0.6% | 22.66 | 1.00 | 0.99 | 288.90 |
| other: a line's first word, second text | 3716 | 1946.75 ± 0.7% | 594.16 ± 0.0% | 30.96 ± 0.2% | 1723.72 ± 0.3% | 62.56 ± 3.5% | refused | refused | 1938.97 ± 0.9% | 3.28 | 1.00 | 1.13 | 31.12 |
| other: fourteen octets before an x | 87 | 19137.82 ± 5.0% | 244.62 ± 0.2% | 6.30 ± 0.0% | 3995.11 ± 0.5% | 10.60 ± 0.1% | differs | 17.73 ± 0.4% | 19192.31 ± 5.8% | 78.23 | 1.00 | 4.79 | 1804.62 |
| other: a Greek word | 21815 | 501.32 ± 1.1% | 412.95 ± 0.2% | 30.71 ± 0.3% | 289.61 ± 0.1% | 43.76 ± 9.8% | differs | refused | 497.31 ± 0.6% | 1.21 | 1.01 | 1.73 | 11.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.92 ± 0.2% | 19.94 ± 0.1% | 0.84 ± 0.1% | 19.87 ± 0.4% | 2.76 ± 1.0% | differs | 3.87 ± 0.2% | 19.94 ± 0.3% | 1.00 | 1.00 | 1.00 | 7.21 |
| a UUID | 32895 | 21.36 ± 0.1% | 21.41 ± 0.1% | 0.64 ± 0.2% | 15.15 ± 0.4% | 3.09 ± 0.3% | 0.73 ± 0.3% | 3.65 ± 0.8% | 21.43 ± 0.1% | 1.00 | 1.00 | 1.41 | 6.91 |
| an IPv4 address | 33176 | 36.89 ± 0.4% | 36.95 ± 0.3% | 2.05 ± 0.1% | 29.32 ± 0.5% | 6.66 ± 0.8% | differs | 4.15 ± 0.1% | 36.95 ± 0.6% | 1.00 | 1.00 | 1.26 | 5.54 |
| a date and time | 32954 | 31.52 ± 0.2% | 31.41 ± 0.2% | 1.41 ± 0.1% | 21.59 ± 0.7% | 7.03 ± 0.2% | 1.25 ± 0.3% | 7.20 ± 0.2% | 31.27 ± 0.6% | 1.00 | 1.01 | 1.46 | 4.48 |
| a field path | 32606 | 23.50 ± 0.2% | 23.56 ± 0.3% | 1.00 ± 0.2% | 23.33 ± 0.5% | 3.51 ± 0.4% | differs | 2.90 ± 0.2% | 23.54 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.69 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.9% | 11.10 ± 0.7% | 11.08 ± 0.2% | 11.71 ± 0.1% | 4.96 ± 1.5% | 0.94 ± 0.6% | none | 11.12 ± 0.4% | 1.00 | 1.00 | 0.95 | 2.23 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.13 ± 0.4% | 231.34 ± 0.2% | 276.30 ± 0.3% | 87.03 ± 0.7% | 220.72 ± 1.6% | 482.44 ± 0.5% | 3798.34 ± 0.3% | 230.04 ± 0.3% | 0.99 | 1.00 | 2.64 | 1.04 |
| a UUID | 62 | 151.31 ± 0.5% | 151.65 ± 0.4% | 170.85 ± 0.3% | 45.78 ± 1.0% | 98.52 ± 1.5% | 186.17 ± 2.0% | 4234.16 ± 0.5% | 151.34 ± 0.4% | 1.00 | 1.00 | 3.30 | 1.54 |
| an IPv4 address | 29 | 416.67 ± 0.6% | 421.80 ± 0.5% | 603.04 ± 0.7% | 77.74 ± 0.1% | 131.29 ± 1.9% | 294.43 ± 0.4% | 7572.79 ± 0.3% | 416.96 ± 0.3% | 0.99 | 1.00 | 5.36 | 3.17 |
| a date and time | 56 | 300.68 ± 0.2% | 302.89 ± 0.2% | 384.23 ± 0.3% | 73.10 ± 1.3% | 136.95 ± 1.1% | 328.61 ± 1.8% | 4911.28 ± 0.4% | 300.78 ± 0.5% | 0.99 | 1.00 | 4.11 | 2.20 |
| a field path | 39 | 225.39 ± 0.3% | 226.21 ± 0.3% | 268.18 ± 0.3% | 80.30 ± 1.4% | 205.48 ± 3.0% | 503.28 ± 1.8% | 4861.82 ± 0.6% | 225.29 ± 0.3% | 1.00 | 1.00 | 2.81 | 1.10 |
| literal: a word | 7 | 627.28 ± 1.1% | 674.90 ± 0.9% | 1243.84 ± 0.3% | 493.75 ± 0.3% | 630.43 ± 1.1% | 962.70 ± 0.7% | 31003.58 ± 0.5% | 626.55 ± 1.0% | 0.93 | 1.00 | 1.27 | 0.99 |
| literal: a word that is not there | 8 | 606.27 ± 0.5% | 654.41 ± 0.5% | 1171.23 ± 0.1% | 445.78 ± 0.3% | 609.77 ± 1.6% | 905.02 ± 0.7% | 29484.37 ± 0.1% | 605.92 ± 0.3% | 0.93 | 1.00 | 1.36 | 0.99 |
| literal: one of four words | 26 | 239.29 ± 0.2% | 398.48 ± 0.6% | 551.01 ± 0.5% | 50.28 ± 1.7% | 243.22 ± 1.8% | 373.71 ± 1.8% | 16043.87 ± 0.1% | 239.56 ± 0.3% | 0.60 | 1.00 | 4.76 | 0.98 |
| literal: a word in any case | 11 | 444.86 ± 0.4% | 474.05 ± 0.2% | 705.70 ± 0.3% | 15.47 ± 0.3% | 650.05 ± 2.3% | refused | 23716.26 ± 0.3% | 444.45 ± 0.2% | 0.94 | 1.00 | 28.76 | 0.68 |
| literal: an href attribute | 12 | 343.45 ± 0.5% | 355.45 ± 0.3% | 474.55 ± 0.4% | 45.62 ± 0.4% | 499.92 ± 2.0% | 773.86 ± 0.7% | 22007.96 ± 0.5% | 342.78 ± 0.4% | 0.97 | 1.00 | 7.53 | 0.69 |
| literal: a word, second text | 10 | 558.21 ± 0.3% | 612.11 ± 1.1% | 1049.05 ± 0.7% | 402.58 ± 0.1% | 541.81 ± 1.7% | 803.49 ± 0.6% | 27330.23 ± 0.3% | 558.05 ± 0.2% | 0.91 | 1.00 | 1.39 | 1.03 |
| class: two capitalized words | 23 | 428.00 ± 0.3% | 461.82 ± 0.2% | 684.63 ± 0.5% | 99.40 ± 0.3% | 500.58 ± 1.6% | 748.74 ± 0.6% | 6479.53 ± 0.6% | 427.52 ± 0.4% | 0.93 | 1.00 | 4.31 | 0.86 |
| class: a word that ends in ing | 9 | 550.76 ± 0.4% | 624.60 ± 0.4% | 1133.32 ± 0.2% | 132.31 ± 0.2% | 761.36 ± 1.0% | 1114.28 ± 0.6% | 16039.10 ± 0.6% | 548.79 ± 0.4% | 0.88 | 1.00 | 4.16 | 0.72 |
| class: a word in capitals | 16 | 481.29 ± 0.4% | 525.17 ± 0.5% | 880.43 ± 0.2% | 134.77 ± 0.9% | 753.92 ± 1.2% | 1022.52 ± 0.9% | 8538.09 ± 0.3% | 480.89 ± 0.4% | 0.92 | 1.00 | 3.57 | 0.64 |
| class: a number | 6 | 606.37 ± 0.2% | 677.01 ± 0.4% | 1350.42 ± 0.1% | 41.74 ± 1.0% | 1409.72 ± 0.5% | 1847.47 ± 0.2% | 22788.47 ± 0.1% | 605.35 ± 0.5% | 0.90 | 1.00 | 14.53 | 0.43 |
| class: two capitalized words, second text | 23 | 428.32 ± 0.6% | 462.51 ± 0.5% | 685.98 ± 0.3% | 100.65 ± 0.2% | 503.22 ± 1.6% | 758.11 ± 3.0% | 6487.27 ± 0.5% | 428.17 ± 0.2% | 0.93 | 1.00 | 4.26 | 0.85 |
| other: a word between two words | 13 | 542.42 ± 0.5% | 559.08 ± 0.4% | 920.93 ± 0.2% | 132.85 ± 0.1% | 507.74 ± 1.5% | 808.61 ± 0.7% | 14876.29 ± 0.3% | 540.89 ± 0.3% | 0.97 | 1.00 | 4.08 | 1.07 |
| other: a number before a unit, second text | 15 | 394.57 ± 0.5% | 437.03 ± 0.4% | 624.63 ± 0.1% | 39.23 ± 0.9% | 637.99 ± 2.6% | 888.93 ± 0.2% | 15222.20 ± 0.4% | 393.99 ± 0.3% | 0.90 | 1.00 | 10.06 | 0.62 |
| other: a heading's start tag | 13 | 354.72 ± 0.7% | 359.98 ± 0.4% | 484.77 ± 0.1% | 44.00 ± 0.5% | 632.37 ± 1.0% | 874.77 ± 0.8% | 18250.71 ± 0.3% | 354.11 ± 0.3% | 0.99 | 1.00 | 8.06 | 0.56 |
| other: a whole word | 11 | 574.95 ± 0.8% | 607.99 ± 0.3% | 1036.62 ± 0.3% | 117.78 ± 0.1% | 569.70 ± 1.4% | 834.73 ± 0.3% | 27248.00 ± 0.5% | 574.18 ± 0.7% | 0.95 | 1.00 | 4.88 | 1.01 |
| other: a line's first word, second text | 17 | 522.52 ± 0.8% | 542.51 ± 0.6% | 894.39 ± 0.7% | 129.16 ± 0.2% | 711.38 ± 1.2% | refused | refused | 520.86 ± 0.7% | 0.96 | 1.00 | 4.05 | 0.73 |
| other: fourteen octets before an x | 16 | 107.73 ± 0.4% | 155.22 ± 0.4% | 180.68 ± 0.6% | 14.98 ± 0.5% | 456.30 ± 1.1% | 419.82 ± 0.6% | 12930.53 ± 0.7% | 107.66 ± 0.3% | 0.69 | 1.00 | 7.19 | 0.24 |
| other: a Greek word | 8 | 422.65 ± 0.2% | 585.80 ± 0.5% | 1041.81 ± 0.1% | 59.20 ± 0.8% | 1399.66 ± 0.5% | 1822.23 ± 0.4% | refused | 422.47 ± 0.2% | 0.72 | 1.00 | 7.14 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12649.26 ± 0.4% | not timed | not timed | 16022.63 ± 1.1% | 1950.09 ± 15.2% | not timed | not timed | 12660.91 ± 0.9% | | 1.00 | 0.79 | 6.49 |
| 01-literal/sherlock-casei-en | 522 | 4947.01 ± 0.7% | not timed | not timed | 3590.46 ± 0.3% | 32.02 ± 3.1% | not timed | not timed | 4949.14 ± 0.4% | | 1.00 | 1.38 | 154.52 |
| 01-literal/sherlock-ru | 724 | 13515.31 ± 0.6% | not timed | not timed | 17247.30 ± 0.4% | 1475.55 ± 15.9% | not timed | not timed | 13491.11 ± 0.3% | | 1.00 | 0.78 | 9.16 |
| 01-literal/sherlock-casei-ru | 746 | 5974.54 ± 0.4% | not timed | not timed | 3326.70 ± 0.2% | 31.34 ± 0.2% | not timed | not timed | 5965.24 ± 0.2% | | 1.00 | 1.80 | 190.64 |
| 01-literal/sherlock-zh | 30 | 16739.90 ± 0.6% | not timed | not timed | 18200.76 ± 0.9% | 2747.03 ± 19.8% | not timed | not timed | 16643.07 ± 0.8% | | 1.01 | 0.92 | 6.09 |
| 02-literal-alternate/sherlock-en | 714 | 5777.86 ± 0.4% | not timed | not timed | 3944.04 ± 0.2% | 16.63 ± 0.1% | not timed | not timed | 5772.49 ± 0.4% | | 1.00 | 1.46 | 347.44 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1797.39 ± 1.2% | not timed | not timed | 695.36 ± 0.3% | 11.06 ± 0.2% | not timed | not timed | 1789.50 ± 0.6% | | 1.00 | 2.58 | 162.56 |
| 02-literal-alternate/sherlock-ru | 899 | 5331.02 ± 0.1% | not timed | not timed | 3265.40 ± 0.2% | 22.68 ± 0.1% | not timed | not timed | 5332.13 ± 0.3% | | 1.00 | 1.63 | 235.08 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1914.94 ± 0.5% | not timed | not timed | 1232.85 ± 0.2% | 9.15 ± 0.1% | not timed | not timed | 1907.15 ± 0.2% | | 1.00 | 1.55 | 209.34 |
| 02-literal-alternate/sherlock-zh | 207 | 7052.32 ± 0.7% | not timed | not timed | 4160.76 ± 0.2% | 31.50 ± 0.1% | not timed | not timed | 7047.81 ± 0.5% | | 1.00 | 1.69 | 223.91 |
| 03-date/ascii | 111817 | 126.53 ± 0.6% | not timed | not timed | 96.05 ± 0.1% | 0.21 ± 5.9% | not timed | not timed | 125.96 ± 1.1% | | 1.00 | 1.32 | 600.13 |
| 04-ruff-noqa/real | 84 | 409.32 ± 0.1% | not timed | not timed | 465.14 ± 0.0% | 19.53 ± 1.3% | not timed | not timed | 407.93 ± 0.2% | | 1.00 | 0.88 | 20.96 |
| 04-ruff-noqa/tweaked | 44 | 550.08 ± 0.2% | not timed | not timed | 461.88 ± 0.1% | 366.21 ± 0.3% | not timed | not timed | 549.74 ± 0.3% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.2% | not timed | not timed | 5.16 ± 0.2% | 0.20 ± 2.4% | not timed | not timed | 5.36 ± 2.5% | | 1.00 | 1.04 | 26.14 |
| 06-cloud-flare-redos/original | 107 | 415.22 ± 0.4% | not timed | not timed | 216.83 ± 0.2% | 24.95 ± 0.2% | not timed | not timed | 414.78 ± 0.2% | | 1.00 | 1.91 | 16.64 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.22 ± 0.1% | not timed | not timed | 227.72 ± 0.1% | 26.77 ± 0.1% | not timed | not timed | 410.52 ± 0.1% | | 1.00 | 1.80 | 15.33 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.88 ± 0.1% | not timed | not timed | 255.76 ± 1.0% | 28.83 ± 0.1% | not timed | not timed | 587.03 ± 0.1% | | 1.00 | 2.30 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 231.03 ± 0.2% | not timed | not timed | 178.44 ± 0.1% | 43.06 ± 6.7% | not timed | not timed | 232.37 ± 2.0% | | 0.99 | 1.29 | 5.36 |
| 08-words/all-english | 56691 | 117.03 ± 0.3% | not timed | not timed | 82.76 ± 0.1% | 12.04 ± 7.8% | not timed | not timed | 116.56 ± 0.3% | | 1.00 | 1.41 | 9.72 |
| 08-words/long-english | 839 | 621.15 ± 0.2% | not timed | not timed | 595.35 ± 0.1% | 32.24 ± 9.6% | not timed | not timed | 620.59 ± 0.2% | | 1.00 | 1.04 | 19.27 |
| 09-aws-keys/full | 0 | 415.57 ± 0.1% | not timed | not timed | 493.53 ± 0.2% | 64.82 ± 0.3% | not timed | not timed | 414.94 ± 0.1% | | 1.00 | 0.84 | 6.41 |
| 09-aws-keys/quick | 0 | 732.71 ± 0.1% | not timed | not timed | 997.42 ± 0.3% | 425.97 ± 1.7% | not timed | not timed | 730.04 ± 0.1% | | 1.00 | 0.73 | 1.72 |
| 10-bounded-repeat/letters-en | 1833 | 587.24 ± 1.9% | not timed | not timed | 517.97 ± 0.3% | 19.55 ± 0.4% | not timed | not timed | 582.30 ± 1.2% | | 1.01 | 1.13 | 30.04 |
| 10-bounded-repeat/letters-ru | 3475 | 508.74 ± 0.6% | not timed | not timed | 479.79 ± 0.2% | 23.74 ± 4.0% | not timed | not timed | 506.94 ± 1.1% | | 1.00 | 1.06 | 21.43 |
| 10-bounded-repeat/context | 53 | 77.95 ± 0.5% | not timed | not timed | 65.39 ± 0.7% | 19.66 ± 0.2% | not timed | not timed | 77.59 ± 0.5% | | 1.00 | 1.19 | 3.97 |
| 10-bounded-repeat/capitals | 11 | 631.89 ± 8.3% | not timed | not timed | 618.90 ± 0.1% | 36.59 ± 0.4% | not timed | not timed | 631.08 ± 8.4% | | 1.00 | 1.02 | 17.27 |
| 11-unstructured-to-json/extract | 600 | 79.58 ± 0.1% | not timed | not timed | 76.93 ± 0.1% | 48.90 ± 3.4% | not timed | not timed | 81.32 ± 0.7% | | 0.98 | 1.03 | 1.63 |
| 12-dictionary/single | 1 | 560.78 ± 0.2% | not timed | not timed | 562.91 ± 0.0% | 0.41 ± 0.2% | not timed | not timed | 560.69 ± 0.4% | | 1.00 | 1.00 | 1375.98 |
| 14-quadratic/1x | 100 | 21.59 ± 1.0% | not timed | not timed | 10.03 ± 0.0% | 0.99 ± 2.4% | not timed | not timed | 21.38 ± 1.0% | | 1.01 | 2.15 | 21.91 |
| 14-quadratic/2x | 200 | 17.64 ± 3.5% | not timed | not timed | 5.51 ± 0.2% | 0.53 ± 1.0% | not timed | not timed | 17.61 ± 3.3% | | 1.00 | 3.20 | 32.98 |
| 14-quadratic/10x | 1000 | 7.71 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.4% | not timed | not timed | 7.69 ± 0.7% | | 1.00 | 6.35 | 67.12 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.2% | not timed | not timed | 0.34 ± 0.7% | 0.55 ± 3.1% | not timed | not timed | 1.28 ± 2.9% | | 1.01 | 3.78 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 91.38 ± 1.5% | not timed | not timed | 13.94 ± 0.2% | 141.58 ± 3.3% | not timed | not timed | 91.16 ± 0.8% | | 1.00 | 6.56 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.95 ± 1.4% | not timed | not timed | 2.49 ± 0.7% | 6.49 ± 1.7% | not timed | not timed | 13.86 ± 1.4% | | 1.01 | 5.61 | 2.15 |
| 07-unicode-character-data/compile | 1 | 55.59 ± 0.1% | not timed | not timed | 26.27 ± 0.4% | 36.36 ± 2.4% | not timed | not timed | 55.16 ± 0.9% | | 1.01 | 2.12 | 1.53 |
| 09-aws-keys/compile-full | 1 | 42.29 ± 0.5% | not timed | not timed | 8.21 ± 0.3% | 23.33 ± 0.8% | not timed | not timed | 42.02 ± 0.1% | | 1.01 | 5.15 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 182.34 ± 1.2% | not timed | not timed | 48.10 ± 0.2% | 134.74 ± 2.8% | not timed | not timed | 181.30 ± 0.8% | | 1.01 | 3.79 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 13.89 ± 0.6% | not timed | not timed | 11.05 ± 0.3% | 16.04 ± 4.6% | not timed | not timed | 13.85 ± 0.4% | | 1.00 | 1.26 | 0.87 |
| 10-bounded-repeat/compile-capitals | 1 | 82.48 ± 0.1% | not timed | not timed | 8.00 ± 0.2% | 23.67 ± 8.3% | not timed | not timed | 82.28 ± 1.9% | | 1.00 | 10.30 | 3.48 |
| 11-unstructured-to-json/compile | 1 | 86.49 ± 0.2% | not timed | not timed | 40.88 ± 0.3% | 68.67 ± 2.0% | not timed | not timed | 85.87 ± 0.8% | | 1.01 | 2.12 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 13.2% | 0.10 ± 15.4% | not timed | not timed | 0.34 ± 1.5% | | 1.00 | 5.01 | 3.55 |

