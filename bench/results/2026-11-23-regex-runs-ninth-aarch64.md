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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148086974 |
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
| literal: a word | 217 | 16050.99 ± 0.9% | 1039.03 ± 0.2% | 28.86 ± 0.1% | 18230.87 ± 1.8% | 9162.23 ± 9.5% | 17.21 ± 0.4% | 86.63 ± 0.2% | 15969.57 ± 1.1% | 15.45 | 1.01 | 0.88 | 1.75 |
| literal: a word that is not there | 0 | 18465.43 ± 1.6% | 1048.36 ± 0.2% | 28.82 ± 0.1% | 19639.41 ± 2.9% | 28934.26 ± 0.4% | 17.02 ± 0.6% | 82.36 ± 0.4% | 18593.26 ± 1.7% | 17.61 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6045.57 ± 0.7% | 1022.94 ± 0.2% | 14.74 ± 0.5% | 3941.07 ± 0.3% | 21.86 ± 0.2% | 5.31 ± 0.2% | 6.93 ± 0.7% | 6042.59 ± 0.3% | 5.91 | 1.00 | 1.53 | 276.55 |
| literal: a word in any case | 217 | 12632.48 ± 0.3% | 1040.86 ± 0.1% | 21.56 ± 1.9% | 3968.09 ± 0.4% | 37.91 ± 0.7% | refused | differs | 12608.10 ± 0.5% | 12.14 | 1.00 | 3.18 | 333.20 |
| literal: an href attribute | 33 | 13662.28 ± 0.6% | 1046.44 ± 0.2% | 27.53 ± 0.3% | 16917.87 ± 1.0% | 2266.57 ± 7.3% | 13.07 ± 0.3% | 75.32 ± 0.2% | 13639.20 ± 0.6% | 13.06 | 1.00 | 0.81 | 6.03 |
| literal: a word, second text | 123 | 16239.84 ± 1.5% | 1043.81 ± 0.1% | 28.33 ± 0.3% | 18204.40 ± 1.3% | 7648.71 ± 2.8% | 20.15 ± 0.4% | 70.08 ± 0.7% | 16284.73 ± 1.5% | 15.56 | 1.00 | 0.89 | 2.12 |
| class: two capitalized words | 1331 | 1091.35 ± 0.6% | 977.71 ± 0.1% | 26.27 ± 0.4% | 585.08 ± 0.1% | 40.55 ± 8.3% | 14.70 ± 0.1% | 68.82 ± 0.2% | 1106.01 ± 0.4% | 1.12 | 0.99 | 1.87 | 26.91 |
| class: a word that ends in ing | 3399 | 894.60 ± 0.2% | 894.28 ± 0.1% | 18.24 ± 0.3% | 547.84 ± 0.1% | 29.64 ± 12.6% | 8.11 ± 0.1% | 18.36 ± 0.3% | 894.04 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.18 |
| class: a word in capitals | 2332 | 1453.70 ± 0.3% | 949.02 ± 0.2% | 27.89 ± 0.1% | 572.36 ± 0.1% | 43.45 ± 0.2% | 17.03 ± 0.1% | 83.06 ± 0.2% | 1455.05 ± 0.7% | 1.53 | 1.00 | 2.54 | 33.46 |
| class: a number | 8288 | 1981.47 ± 0.3% | 836.14 ± 0.2% | 28.12 ± 0.1% | 1723.96 ± 0.3% | 40.68 ± 15.7% | 0.54 ± 0.1% | 56.48 ± 0.6% | 1986.70 ± 0.1% | 2.37 | 1.00 | 1.15 | 48.71 |
| class: two capitalized words, second text | 5359 | 742.72 ± 0.1% | 739.98 ± 0.2% | 23.53 ± 0.1% | 484.07 ± 0.2% | 34.38 ± 10.5% | 17.12 ± 0.4% | 63.81 ± 0.1% | 742.47 ± 0.2% | 1.00 | 1.00 | 1.53 | 21.60 |
| other: a word between two words | 6104 | 741.93 ± 0.2% | 777.74 ± 0.1% | 23.70 ± 0.6% | 741.32 ± 0.4% | 108.88 ± 12.8% | 11.06 ± 0.1% | 69.58 ± 0.3% | 753.13 ± 0.1% | 0.95 | 0.99 | 1.00 | 6.81 |
| other: a number before a unit, second text | 1481 | 5442.64 ± 0.3% | 984.67 ± 0.1% | 26.21 ± 0.3% | 5621.56 ± 0.3% | 40.69 ± 10.8% | 18.15 ± 0.2% | 66.94 ± 0.4% | 5428.97 ± 0.6% | 5.53 | 1.00 | 0.97 | 133.75 |
| other: a heading's start tag | 110 | 12565.60 ± 0.3% | 1036.18 ± 0.1% | 27.74 ± 0.1% | 1714.05 ± 0.2% | 1585.48 ± 6.2% | 15.96 ± 0.3% | 88.93 ± 0.6% | 12559.40 ± 0.8% | 12.13 | 1.00 | 7.33 | 7.93 |
| other: a whole word | 217 | 14018.17 ± 0.6% | 1037.01 ± 0.2% | 29.91 ± 0.3% | 14622.40 ± 1.7% | 49.51 ± 0.2% | 13.07 ± 0.1% | 55.61 ± 0.3% | 13968.37 ± 0.9% | 13.52 | 1.00 | 0.96 | 283.15 |
| other: a line's first word, second text | 3716 | 1970.54 ± 1.1% | 867.07 ± 0.1% | 31.41 ± 0.3% | 1721.79 ± 0.6% | 61.60 ± 6.6% | refused | refused | 1966.07 ± 1.0% | 2.27 | 1.00 | 1.14 | 31.99 |
| other: fourteen octets before an x | 87 | 19698.51 ± 1.6% | 241.86 ± 0.7% | 6.60 ± 0.1% | 3995.11 ± 0.4% | 10.64 ± 0.2% | differs | 17.77 ± 0.1% | 19788.00 ± 2.1% | 81.45 | 1.00 | 4.93 | 1851.99 |
| other: a Greek word | 21815 | 515.48 ± 0.4% | 413.02 ± 0.1% | 31.37 ± 0.2% | 289.79 ± 0.4% | 44.51 ± 9.8% | differs | refused | 510.33 ± 0.7% | 1.25 | 1.01 | 1.78 | 11.58 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.93 ± 0.2% | 25.92 ± 0.3% | 0.87 ± 0.1% | 19.80 ± 0.5% | 2.78 ± 0.5% | differs | 4.00 ± 0.2% | 25.93 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.34 |
| a UUID | 32895 | 21.12 ± 0.2% | 21.18 ± 0.2% | 0.65 ± 0.2% | 15.06 ± 0.4% | 3.09 ± 0.6% | 0.73 ± 0.6% | 3.60 ± 0.8% | 21.24 ± 0.1% | 1.00 | 0.99 | 1.40 | 6.83 |
| an IPv4 address | 33176 | 37.00 ± 0.5% | 36.94 ± 0.3% | 2.11 ± 0.7% | 29.42 ± 0.1% | 6.68 ± 0.2% | differs | 4.18 ± 0.4% | 37.04 ± 0.6% | 1.00 | 1.00 | 1.26 | 5.54 |
| a date and time | 32954 | 31.31 ± 0.2% | 31.36 ± 0.2% | 1.47 ± 0.3% | 21.50 ± 0.7% | 7.04 ± 0.1% | 1.25 ± 0.1% | 7.15 ± 0.2% | 31.24 ± 0.4% | 1.00 | 1.00 | 1.46 | 4.44 |
| a field path | 32606 | 29.52 ± 0.1% | 29.38 ± 0.2% | 1.03 ± 0.2% | 23.18 ± 0.4% | 3.51 ± 1.2% | differs | 2.92 ± 0.2% | 29.53 ± 0.1% | 1.01 | 1.00 | 1.27 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.3% | 11.48 ± 0.4% | 11.51 ± 0.6% | 11.53 ± 0.1% | 4.96 ± 1.9% | 0.93 ± 0.1% | none | 11.47 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.84 ± 0.3% | 235.56 ± 0.4% | 286.31 ± 0.3% | 87.31 ± 0.2% | 222.68 ± 1.0% | 482.41 ± 0.3% | 3857.04 ± 1.0% | 233.69 ± 0.4% | 0.99 | 1.00 | 2.68 | 1.05 |
| a UUID | 62 | 156.74 ± 0.3% | 157.17 ± 0.2% | 178.77 ± 0.1% | 45.93 ± 0.2% | 99.35 ± 0.4% | 181.47 ± 1.1% | 4429.02 ± 1.0% | 156.75 ± 0.2% | 1.00 | 1.00 | 3.41 | 1.58 |
| an IPv4 address | 29 | 417.17 ± 0.4% | 422.93 ± 0.6% | 612.59 ± 0.7% | 77.48 ± 1.0% | 131.87 ± 1.1% | 290.53 ± 0.5% | 7615.72 ± 0.4% | 416.09 ± 0.7% | 0.99 | 1.00 | 5.38 | 3.16 |
| a date and time | 56 | 306.11 ± 0.5% | 308.78 ± 0.3% | 397.66 ± 0.2% | 72.88 ± 0.1% | 137.58 ± 16.1% | 318.07 ± 0.5% | 4906.07 ± 0.6% | 305.90 ± 0.3% | 0.99 | 1.00 | 4.20 | 2.22 |
| a field path | 39 | 226.30 ± 0.2% | 227.82 ± 0.2% | 274.21 ± 0.2% | 80.22 ± 0.4% | 206.81 ± 1.9% | 484.75 ± 0.8% | 4940.16 ± 3.9% | 226.28 ± 0.1% | 0.99 | 1.00 | 2.82 | 1.09 |
| literal: a word | 7 | 620.33 ± 0.4% | 664.33 ± 0.5% | 1253.53 ± 0.7% | 518.06 ± 1.7% | 631.19 ± 1.9% | 915.29 ± 0.4% | 29483.89 ± 0.4% | 620.26 ± 0.2% | 0.93 | 1.00 | 1.20 | 0.98 |
| literal: a word that is not there | 8 | 596.17 ± 0.3% | 645.63 ± 0.9% | 1183.51 ± 0.3% | 473.05 ± 0.2% | 608.02 ± 2.2% | 868.34 ± 0.6% | 28528.52 ± 0.2% | 595.53 ± 0.5% | 0.92 | 1.00 | 1.26 | 0.98 |
| literal: one of four words | 26 | 240.56 ± 0.2% | 400.19 ± 0.5% | 564.53 ± 0.8% | 49.70 ± 0.3% | 244.02 ± 2.0% | 353.89 ± 0.7% | 15430.15 ± 0.8% | 240.71 ± 0.2% | 0.60 | 1.00 | 4.84 | 0.99 |
| literal: a word in any case | 11 | 482.32 ± 0.1% | 515.04 ± 0.5% | 842.35 ± 0.9% | 15.82 ± 1.0% | 668.58 ± 2.5% | refused | 23445.96 ± 0.4% | 482.74 ± 0.3% | 0.94 | 1.00 | 30.49 | 0.72 |
| literal: an href attribute | 12 | 350.31 ± 0.6% | 363.62 ± 0.5% | 497.48 ± 0.7% | 45.45 ± 0.6% | 503.69 ± 1.3% | 766.79 ± 2.5% | 21444.97 ± 0.3% | 350.37 ± 0.2% | 0.96 | 1.00 | 7.71 | 0.70 |
| literal: a word, second text | 10 | 556.31 ± 0.2% | 610.58 ± 0.5% | 1068.28 ± 0.8% | 419.58 ± 0.3% | 543.33 ± 10.3% | 795.05 ± 0.6% | 26455.20 ± 0.4% | 556.44 ± 0.4% | 0.91 | 1.00 | 1.33 | 1.02 |
| class: two capitalized words | 23 | 433.59 ± 0.7% | 465.56 ± 0.5% | 705.12 ± 0.7% | 102.45 ± 0.3% | 510.26 ± 1.4% | 736.62 ± 0.7% | 6571.00 ± 0.1% | 433.32 ± 0.3% | 0.93 | 1.00 | 4.23 | 0.85 |
| class: a word that ends in ing | 9 | 551.70 ± 0.8% | 623.19 ± 0.7% | 1162.94 ± 0.1% | 134.39 ± 0.8% | 765.30 ± 1.6% | 1074.57 ± 1.8% | 16012.10 ± 0.2% | 551.95 ± 0.6% | 0.89 | 1.00 | 4.11 | 0.72 |
| class: a word in capitals | 16 | 484.25 ± 0.2% | 527.86 ± 0.3% | 901.32 ± 0.3% | 137.43 ± 0.9% | 761.03 ± 0.9% | 1008.29 ± 0.8% | 8633.50 ± 0.2% | 484.14 ± 0.1% | 0.92 | 1.00 | 3.52 | 0.64 |
| class: a number | 6 | 603.61 ± 0.8% | 676.59 ± 0.3% | 1363.18 ± 0.1% | 42.21 ± 0.5% | 1420.02 ± 1.1% | 1929.68 ± 1.4% | 22494.12 ± 0.3% | 603.92 ± 0.4% | 0.89 | 1.00 | 14.30 | 0.43 |
| class: two capitalized words, second text | 23 | 433.36 ± 0.6% | 465.29 ± 0.3% | 704.78 ± 0.4% | 104.35 ± 0.2% | 510.83 ± 1.6% | 737.06 ± 0.5% | 6570.24 ± 0.2% | 433.60 ± 0.4% | 0.93 | 1.00 | 4.15 | 0.85 |
| other: a word between two words | 13 | 548.72 ± 0.1% | 566.52 ± 0.4% | 950.26 ± 0.4% | 137.82 ± 0.4% | 510.00 ± 0.3% | 810.33 ± 1.4% | 14797.42 ± 0.1% | 547.77 ± 0.6% | 0.97 | 1.00 | 3.98 | 1.08 |
| other: a number before a unit, second text | 15 | 403.82 ± 0.3% | 445.18 ± 0.4% | 652.60 ± 0.2% | 39.57 ± 0.3% | 643.12 ± 8.3% | 891.30 ± 0.7% | 15085.47 ± 0.1% | 403.77 ± 0.2% | 0.91 | 1.00 | 10.20 | 0.63 |
| other: a heading's start tag | 13 | 358.24 ± 0.7% | 364.12 ± 0.5% | 499.02 ± 0.4% | 43.70 ± 0.3% | 638.25 ± 1.4% | 857.70 ± 0.5% | 17851.91 ± 0.3% | 358.24 ± 0.4% | 0.98 | 1.00 | 8.20 | 0.56 |
| other: a whole word | 11 | 580.62 ± 0.5% | 615.84 ± 0.5% | 1086.89 ± 0.1% | 122.24 ± 0.3% | 571.95 ± 3.0% | 820.62 ± 0.4% | 26477.04 ± 0.4% | 580.11 ± 0.7% | 0.94 | 1.00 | 4.75 | 1.02 |
| other: a line's first word, second text | 17 | 527.93 ± 0.7% | 547.69 ± 0.4% | 932.70 ± 0.2% | 130.07 ± 0.1% | 720.41 ± 1.3% | refused | refused | 526.85 ± 1.0% | 0.96 | 1.00 | 4.06 | 0.73 |
| other: fourteen octets before an x | 16 | 111.65 ± 0.3% | 161.15 ± 0.5% | 190.03 ± 0.7% | 15.24 ± 0.3% | 458.77 ± 1.5% | 416.93 ± 0.2% | 12558.58 ± 0.7% | 111.52 ± 0.4% | 0.69 | 1.00 | 7.33 | 0.24 |
| other: a Greek word | 8 | 420.73 ± 0.3% | 580.55 ± 0.8% | 1040.55 ± 0.1% | 58.92 ± 0.3% | 1389.33 ± 3.6% | 1840.36 ± 0.4% | refused | 420.62 ± 0.1% | 0.72 | 1.00 | 7.14 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12808.13 ± 0.6% | not timed | not timed | 16260.74 ± 1.3% | 1986.49 ± 18.0% | not timed | not timed | 12788.44 ± 1.0% | | 1.00 | 0.79 | 6.45 |
| 01-literal/sherlock-casei-en | 522 | 4493.89 ± 0.9% | not timed | not timed | 3592.57 ± 0.2% | 32.58 ± 0.1% | not timed | not timed | 4485.13 ± 0.5% | | 1.00 | 1.25 | 137.94 |
| 01-literal/sherlock-ru | 724 | 13517.54 ± 4.0% | not timed | not timed | 17288.12 ± 1.4% | 1438.70 ± 12.1% | not timed | not timed | 13538.30 ± 7.7% | | 1.00 | 0.78 | 9.40 |
| 01-literal/sherlock-casei-ru | 746 | 5255.33 ± 0.4% | not timed | not timed | 3328.44 ± 0.1% | 31.62 ± 0.6% | not timed | not timed | 5298.60 ± 0.1% | | 0.99 | 1.58 | 166.20 |
| 01-literal/sherlock-zh | 30 | 17122.93 ± 0.5% | not timed | not timed | 18840.73 ± 0.6% | 2605.80 ± 17.6% | not timed | not timed | 17111.42 ± 0.3% | | 1.00 | 0.91 | 6.57 |
| 02-literal-alternate/sherlock-en | 714 | 5746.88 ± 0.2% | not timed | not timed | 3939.80 ± 0.3% | 16.63 ± 0.2% | not timed | not timed | 5749.73 ± 0.2% | | 1.00 | 1.46 | 345.56 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1713.11 ± 1.0% | not timed | not timed | 696.83 ± 0.1% | 11.10 ± 0.1% | not timed | not timed | 1706.94 ± 0.4% | | 1.00 | 2.46 | 154.33 |
| 02-literal-alternate/sherlock-ru | 899 | 4653.95 ± 0.1% | not timed | not timed | 3252.68 ± 0.1% | 22.61 ± 0.1% | not timed | not timed | 4660.25 ± 0.4% | | 1.00 | 1.43 | 205.81 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1815.86 ± 0.6% | not timed | not timed | 1231.87 ± 0.1% | 9.12 ± 0.2% | not timed | not timed | 1806.06 ± 0.3% | | 1.01 | 1.47 | 199.10 |
| 02-literal-alternate/sherlock-zh | 207 | 7052.33 ± 0.1% | not timed | not timed | 4167.02 ± 0.2% | 31.51 ± 0.1% | not timed | not timed | 7053.24 ± 0.2% | | 1.00 | 1.69 | 223.80 |
| 03-date/ascii | 111817 | 127.09 ± 0.6% | not timed | not timed | 95.77 ± 0.2% | 0.21 ± 6.4% | not timed | not timed | 126.57 ± 0.6% | | 1.00 | 1.33 | 600.70 |
| 04-ruff-noqa/real | 84 | 554.00 ± 0.1% | not timed | not timed | 479.05 ± 0.2% | 19.70 ± 0.9% | not timed | not timed | 553.82 ± 0.1% | | 1.00 | 1.16 | 28.12 |
| 04-ruff-noqa/tweaked | 44 | 549.39 ± 0.4% | not timed | not timed | 461.92 ± 0.1% | 366.50 ± 0.4% | not timed | not timed | 548.03 ± 0.4% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 4.22 ± 0.5% | not timed | not timed | 5.15 ± 0.1% | 0.20 ± 1.7% | not timed | not timed | 4.23 ± 2.6% | | 1.00 | 0.82 | 20.63 |
| 06-cloud-flare-redos/original | 107 | 263.83 ± 0.2% | not timed | not timed | 217.18 ± 0.2% | 24.93 ± 0.2% | not timed | not timed | 263.53 ± 0.1% | | 1.00 | 1.21 | 10.58 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.21 ± 0.1% | not timed | not timed | 227.62 ± 0.0% | 26.66 ± 0.2% | not timed | not timed | 259.44 ± 0.1% | | 1.00 | 1.14 | 9.72 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.14 ± 0.4% | not timed | not timed | 255.00 ± 0.0% | 28.75 ± 0.2% | not timed | not timed | 286.22 ± 0.3% | | 1.00 | 1.12 | 9.95 |
| 07-unicode-character-data/parse-line | 558784 | 232.63 ± 14.2% | not timed | not timed | 178.82 ± 0.3% | 42.02 ± 4.3% | not timed | not timed | 229.55 ± 2.3% | | 1.01 | 1.30 | 5.54 |
| 08-words/all-english | 56691 | 120.78 ± 0.7% | not timed | not timed | 83.05 ± 0.1% | 11.83 ± 2.4% | not timed | not timed | 120.21 ± 0.4% | | 1.00 | 1.45 | 10.21 |
| 08-words/long-english | 839 | 1006.54 ± 0.1% | not timed | not timed | 595.77 ± 0.1% | 32.42 ± 0.6% | not timed | not timed | 1005.97 ± 0.2% | | 1.00 | 1.69 | 31.05 |
| 09-aws-keys/full | 0 | 408.93 ± 0.0% | not timed | not timed | 494.43 ± 0.2% | 64.35 ± 0.1% | not timed | not timed | 409.10 ± 0.0% | | 1.00 | 0.83 | 6.35 |
| 09-aws-keys/quick | 0 | 743.86 ± 0.1% | not timed | not timed | 998.84 ± 0.1% | 419.33 ± 1.7% | not timed | not timed | 740.73 ± 0.1% | | 1.00 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 638.78 ± 0.3% | not timed | not timed | 518.24 ± 0.4% | 19.46 ± 0.5% | not timed | not timed | 638.04 ± 0.2% | | 1.00 | 1.23 | 32.82 |
| 10-bounded-repeat/letters-ru | 3475 | 384.99 ± 0.2% | not timed | not timed | 477.88 ± 0.2% | 21.77 ± 17.2% | not timed | not timed | 384.21 ± 0.5% | | 1.00 | 0.81 | 17.68 |
| 10-bounded-repeat/context | 53 | 79.14 ± 0.9% | not timed | not timed | 66.14 ± 0.5% | 19.81 ± 0.1% | not timed | not timed | 79.01 ± 1.3% | | 1.00 | 1.20 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1041.47 ± 0.1% | not timed | not timed | 618.15 ± 0.1% | 36.54 ± 0.1% | not timed | not timed | 1041.36 ± 0.1% | | 1.00 | 1.68 | 28.50 |
| 11-unstructured-to-json/extract | 600 | 49.90 ± 0.3% | not timed | not timed | 76.96 ± 0.1% | 49.16 ± 0.3% | not timed | not timed | 48.35 ± 0.2% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 566.64 ± 0.4% | not timed | not timed | 561.86 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 567.84 ± 0.2% | | 1.00 | 1.01 | 1397.61 |
| 14-quadratic/1x | 100 | 9.65 ± 0.4% | not timed | not timed | 10.05 ± 0.1% | 0.98 ± 3.7% | not timed | not timed | 9.64 ± 1.2% | | 1.00 | 0.96 | 9.89 |
| 14-quadratic/2x | 200 | 5.57 ± 0.3% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.7% | not timed | not timed | 5.56 ± 1.1% | | 1.00 | 1.01 | 10.55 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.9% | not timed | not timed | 1.26 ± 0.5% | | 1.00 | 1.04 | 10.91 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.44 ± 0.7% | not timed | not timed | 0.34 ± 0.2% | 0.55 ± 2.8% | not timed | not timed | 1.44 ± 1.4% | | 1.00 | 4.17 | 2.60 |
| 04-ruff-noqa/compile-real | 1 | 92.57 ± 0.1% | not timed | not timed | 13.76 ± 0.1% | 139.53 ± 3.8% | not timed | not timed | 92.52 ± 0.9% | | 1.00 | 6.73 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.47 ± 0.4% | not timed | not timed | 2.51 ± 0.7% | 6.51 ± 2.2% | not timed | not timed | 14.44 ± 1.4% | | 1.00 | 5.76 | 2.22 |
| 07-unicode-character-data/compile | 1 | 58.41 ± 0.1% | not timed | not timed | 25.87 ± 0.1% | 35.96 ± 3.4% | not timed | not timed | 58.49 ± 0.1% | | 1.00 | 2.26 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.54 ± 0.4% | not timed | not timed | 8.30 ± 0.4% | 23.48 ± 1.1% | not timed | not timed | 43.37 ± 0.2% | | 1.00 | 5.25 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 186.27 ± 0.1% | not timed | not timed | 46.87 ± 0.1% | 135.49 ± 1.7% | not timed | not timed | 186.74 ± 1.0% | | 1.00 | 3.97 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 14.66 ± 1.9% | not timed | not timed | 11.12 ± 0.3% | 16.02 ± 3.8% | not timed | not timed | 14.61 ± 0.9% | | 1.00 | 1.32 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.22 ± 0.9% | not timed | not timed | 8.06 ± 0.1% | 23.88 ± 0.6% | not timed | not timed | 85.18 ± 0.9% | | 1.00 | 10.57 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 90.60 ± 0.2% | not timed | not timed | 41.27 ± 0.3% | 68.67 ± 3.6% | not timed | not timed | 90.29 ± 1.3% | | 1.00 | 2.20 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 21.8% | 0.09 ± 4.3% | not timed | not timed | 0.35 ± 1.9% | | 1.02 | 5.30 | 3.90 |

