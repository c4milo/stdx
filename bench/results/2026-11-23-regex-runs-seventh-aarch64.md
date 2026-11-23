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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148077778 |
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
| literal: a word | 217 | 16109.90 ± 12.9% | 1040.23 ± 0.5% | 28.88 ± 0.3% | 18247.23 ± 14.9% | 9099.86 ± 13.5% | 17.21 ± 0.4% | 86.61 ± 0.3% | 16180.89 ± 19.1% | 15.49 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18723.48 ± 0.7% | 1048.15 ± 0.1% | 28.84 ± 0.4% | 19854.14 ± 1.3% | 29168.07 ± 0.7% | 17.03 ± 0.6% | 82.31 ± 0.3% | 18700.42 ± 1.0% | 17.86 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6051.97 ± 0.8% | 1023.80 ± 0.1% | 14.77 ± 0.2% | 3945.79 ± 0.2% | 21.87 ± 0.1% | 5.34 ± 0.2% | 6.92 ± 0.9% | 6033.12 ± 0.2% | 5.91 | 1.00 | 1.53 | 276.75 |
| literal: a word in any case | 217 | 12572.82 ± 0.6% | 1040.53 ± 0.1% | 21.60 ± 1.6% | 3972.21 ± 0.1% | 38.04 ± 0.5% | refused | differs | 12554.21 ± 0.4% | 12.08 | 1.00 | 3.17 | 330.52 |
| literal: an href attribute | 33 | 13745.56 ± 0.7% | 1046.70 ± 0.1% | 27.51 ± 0.4% | 17012.92 ± 1.7% | 2255.64 ± 0.8% | 13.04 ± 0.1% | 75.37 ± 0.5% | 13765.77 ± 0.4% | 13.13 | 1.00 | 0.81 | 6.09 |
| literal: a word, second text | 123 | 16488.81 ± 1.3% | 1044.39 ± 0.1% | 28.36 ± 0.4% | 18231.44 ± 2.3% | 8057.35 ± 5.5% | 20.16 ± 0.4% | 70.17 ± 0.3% | 16487.25 ± 0.8% | 15.79 | 1.00 | 0.90 | 2.05 |
| class: two capitalized words | 1331 | 1105.00 ± 0.3% | 978.02 ± 0.1% | 26.23 ± 0.2% | 585.30 ± 0.1% | 40.51 ± 1.0% | 14.68 ± 0.2% | 68.78 ± 0.1% | 1104.75 ± 0.2% | 1.13 | 1.00 | 1.89 | 27.28 |
| class: a word that ends in ing | 3399 | 894.57 ± 0.1% | 894.58 ± 0.1% | 18.26 ± 0.2% | 547.89 ± 0.0% | 29.60 ± 3.0% | 8.11 ± 0.3% | 18.40 ± 0.4% | 894.08 ± 0.2% | 1.00 | 1.00 | 1.63 | 30.22 |
| class: a word in capitals | 2332 | 1453.77 ± 0.2% | 949.77 ± 0.1% | 27.93 ± 0.2% | 572.42 ± 0.1% | 43.48 ± 10.2% | 17.11 ± 0.3% | 83.09 ± 1.0% | 1452.86 ± 0.3% | 1.53 | 1.00 | 2.54 | 33.44 |
| class: a number | 8288 | 1984.80 ± 0.2% | 836.14 ± 0.0% | 28.12 ± 0.2% | 1723.28 ± 0.2% | 40.71 ± 12.2% | 0.52 ± 0.3% | 56.49 ± 0.2% | 1987.93 ± 0.2% | 2.37 | 1.00 | 1.15 | 48.75 |
| class: two capitalized words, second text | 5359 | 743.15 ± 0.1% | 744.22 ± 0.1% | 23.53 ± 0.2% | 484.30 ± 0.0% | 35.31 ± 8.3% | 17.14 ± 0.2% | 63.83 ± 0.2% | 742.91 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.05 |
| other: a word between two words | 6104 | 754.20 ± 0.1% | 740.08 ± 0.1% | 23.72 ± 0.0% | 737.53 ± 0.4% | 110.61 ± 14.9% | 11.15 ± 0.1% | 69.64 ± 0.1% | 752.36 ± 0.1% | 1.02 | 1.00 | 1.02 | 6.82 |
| other: a number before a unit, second text | 1481 | 5468.00 ± 0.8% | 985.23 ± 0.0% | 26.20 ± 0.1% | 5647.79 ± 0.4% | 40.77 ± 0.4% | 18.11 ± 0.1% | 66.82 ± 0.7% | 5456.74 ± 0.5% | 5.55 | 1.00 | 0.97 | 134.10 |
| other: a heading's start tag | 110 | 12610.77 ± 0.3% | 1036.33 ± 0.1% | 27.71 ± 0.3% | 1710.80 ± 0.3% | 1588.52 ± 4.6% | 15.78 ± 0.5% | 89.11 ± 0.4% | 12582.33 ± 0.3% | 12.17 | 1.00 | 7.37 | 7.94 |
| other: a whole word | 217 | 14073.82 ± 1.6% | 1038.54 ± 0.2% | 29.90 ± 0.2% | 14561.89 ± 1.5% | 49.45 ± 0.1% | 13.06 ± 0.0% | 55.62 ± 0.1% | 14023.25 ± 1.7% | 13.55 | 1.00 | 0.97 | 284.62 |
| other: a line's first word, second text | 3716 | 1974.63 ± 0.4% | 877.30 ± 0.1% | 31.35 ± 0.3% | 1723.59 ± 0.3% | 61.86 ± 7.3% | refused | refused | 1967.05 ± 0.3% | 2.25 | 1.00 | 1.15 | 31.92 |
| other: fourteen octets before an x | 87 | 19564.70 ± 0.7% | 237.23 ± 0.2% | 6.60 ± 0.1% | 3966.21 ± 0.4% | 10.63 ± 0.5% | differs | 17.73 ± 0.3% | 19690.38 ± 0.6% | 82.47 | 0.99 | 4.93 | 1839.66 |
| other: a Greek word | 21815 | 514.87 ± 0.8% | 412.75 ± 0.4% | 31.36 ± 0.1% | 289.67 ± 0.3% | 48.61 ± 6.8% | differs | refused | 510.63 ± 0.5% | 1.25 | 1.01 | 1.78 | 10.59 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.97 ± 0.2% | 25.95 ± 0.2% | 0.87 ± 0.2% | 19.78 ± 0.7% | 2.74 ± 1.0% | differs | 4.00 ± 0.2% | 25.95 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.47 |
| a UUID | 32895 | 21.09 ± 0.1% | 21.15 ± 0.2% | 0.65 ± 0.2% | 14.89 ± 1.3% | 3.11 ± 0.1% | 0.73 ± 0.4% | 3.60 ± 0.7% | 21.22 ± 0.3% | 1.00 | 0.99 | 1.42 | 6.79 |
| an IPv4 address | 33176 | 37.05 ± 0.2% | 37.02 ± 0.1% | 2.11 ± 0.5% | 29.37 ± 0.5% | 6.66 ± 0.2% | differs | 4.19 ± 0.4% | 37.12 ± 0.1% | 1.00 | 1.00 | 1.26 | 5.56 |
| a date and time | 32954 | 31.29 ± 0.5% | 31.30 ± 0.5% | 1.47 ± 0.3% | 21.40 ± 0.3% | 7.04 ± 0.2% | 1.25 ± 0.3% | 7.15 ± 0.4% | 31.27 ± 0.5% | 1.00 | 1.00 | 1.46 | 4.45 |
| a field path | 32606 | 29.53 ± 0.0% | 29.50 ± 0.1% | 1.03 ± 0.1% | 23.25 ± 0.3% | 3.50 ± 0.8% | differs | 2.93 ± 0.2% | 29.52 ± 0.1% | 1.00 | 1.00 | 1.27 | 8.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.1% | 11.48 ± 0.3% | 11.51 ± 0.4% | 11.53 ± 0.2% | 4.91 ± 2.8% | 0.93 ± 0.6% | none | 11.46 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.37 ± 0.5% | 236.12 ± 0.4% | 286.67 ± 0.2% | 86.38 ± 0.4% | 218.69 ± 1.2% | 470.11 ± 1.5% | 3864.62 ± 1.7% | 234.24 ± 0.2% | 0.99 | 1.00 | 2.71 | 1.07 |
| a UUID | 62 | 157.26 ± 0.2% | 157.69 ± 0.1% | 179.02 ± 0.2% | 46.43 ± 0.7% | 98.81 ± 1.2% | 181.98 ± 3.1% | 4394.66 ± 1.3% | 157.12 ± 0.6% | 1.00 | 1.00 | 3.39 | 1.59 |
| an IPv4 address | 29 | 417.87 ± 0.2% | 423.54 ± 0.2% | 612.69 ± 0.2% | 77.22 ± 0.3% | 131.06 ± 0.8% | 296.66 ± 1.4% | 7617.05 ± 0.5% | 417.66 ± 0.2% | 0.99 | 1.00 | 5.41 | 3.19 |
| a date and time | 56 | 306.15 ± 0.4% | 308.92 ± 0.5% | 397.67 ± 0.4% | 73.07 ± 0.4% | 136.77 ± 2.4% | 320.81 ± 1.6% | 4911.81 ± 0.4% | 306.21 ± 0.4% | 0.99 | 1.00 | 4.19 | 2.24 |
| a field path | 39 | 226.60 ± 0.1% | 228.19 ± 0.1% | 274.78 ± 0.1% | 80.73 ± 1.0% | 205.71 ± 0.8% | 494.72 ± 3.4% | 4940.02 ± 2.4% | 226.40 ± 0.4% | 0.99 | 1.00 | 2.81 | 1.10 |
| literal: a word | 7 | 620.70 ± 0.2% | 664.76 ± 0.4% | 1253.71 ± 0.1% | 526.01 ± 0.2% | 622.11 ± 3.4% | 946.83 ± 0.3% | 29432.98 ± 0.2% | 620.42 ± 0.2% | 0.93 | 1.00 | 1.18 | 1.00 |
| literal: a word that is not there | 8 | 596.56 ± 0.3% | 645.26 ± 0.3% | 1184.02 ± 0.1% | 483.03 ± 0.2% | 600.30 ± 0.8% | 898.95 ± 0.3% | 28544.95 ± 0.2% | 596.41 ± 0.4% | 0.92 | 1.00 | 1.24 | 0.99 |
| literal: one of four words | 26 | 241.18 ± 0.2% | 400.23 ± 0.3% | 564.21 ± 0.4% | 50.09 ± 1.2% | 240.03 ± 1.7% | 371.90 ± 1.5% | 15425.30 ± 0.2% | 241.06 ± 0.2% | 0.60 | 1.00 | 4.82 | 1.00 |
| literal: a word in any case | 11 | 482.09 ± 0.5% | 515.18 ± 0.6% | 841.64 ± 0.4% | 15.87 ± 1.7% | 643.80 ± 3.2% | refused | 23425.10 ± 0.5% | 481.90 ± 0.3% | 0.94 | 1.00 | 30.38 | 0.75 |
| literal: an href attribute | 12 | 351.03 ± 0.1% | 363.70 ± 0.6% | 498.65 ± 0.5% | 45.78 ± 0.6% | 497.27 ± 1.1% | 769.57 ± 0.4% | 21473.57 ± 0.2% | 350.93 ± 0.2% | 0.97 | 1.00 | 7.67 | 0.71 |
| literal: a word, second text | 10 | 557.04 ± 0.2% | 611.09 ± 0.1% | 1068.70 ± 0.2% | 400.47 ± 0.1% | 533.14 ± 0.6% | 797.50 ± 0.3% | 26446.74 ± 0.2% | 556.76 ± 0.4% | 0.91 | 1.00 | 1.39 | 1.04 |
| class: two capitalized words | 23 | 432.76 ± 0.5% | 465.38 ± 0.5% | 703.96 ± 0.3% | 100.21 ± 0.0% | 496.68 ± 1.0% | 738.20 ± 0.6% | 6574.53 ± 0.7% | 432.93 ± 0.3% | 0.93 | 1.00 | 4.32 | 0.87 |
| class: a word that ends in ing | 9 | 551.86 ± 0.9% | 622.26 ± 0.2% | 1161.93 ± 0.2% | 132.89 ± 2.0% | 755.33 ± 1.0% | 1089.73 ± 0.3% | 15995.45 ± 0.1% | 552.40 ± 0.2% | 0.89 | 1.00 | 4.15 | 0.73 |
| class: a word in capitals | 16 | 485.10 ± 0.3% | 528.76 ± 0.5% | 902.72 ± 0.2% | 135.55 ± 0.5% | 749.55 ± 0.6% | 1016.13 ± 0.8% | 8632.85 ± 0.2% | 484.69 ± 0.3% | 0.92 | 1.00 | 3.58 | 0.65 |
| class: a number | 6 | 605.02 ± 0.1% | 678.26 ± 0.3% | 1362.55 ± 0.1% | 41.82 ± 0.9% | 1396.64 ± 2.2% | 1864.02 ± 1.6% | 22512.34 ± 0.3% | 604.95 ± 0.2% | 0.89 | 1.00 | 14.47 | 0.43 |
| class: two capitalized words, second text | 23 | 433.59 ± 0.3% | 466.18 ± 0.2% | 705.19 ± 0.3% | 101.78 ± 0.4% | 496.77 ± 1.8% | 760.73 ± 0.5% | 6562.81 ± 0.5% | 433.69 ± 0.5% | 0.93 | 1.00 | 4.26 | 0.87 |
| other: a word between two words | 13 | 549.33 ± 0.2% | 567.87 ± 0.2% | 950.31 ± 0.2% | 133.67 ± 0.6% | 500.94 ± 1.1% | 804.72 ± 0.5% | 14802.89 ± 0.1% | 548.32 ± 0.3% | 0.97 | 1.00 | 4.11 | 1.10 |
| other: a number before a unit, second text | 15 | 403.58 ± 0.5% | 445.30 ± 0.9% | 652.00 ± 0.4% | 39.58 ± 0.4% | 633.52 ± 0.9% | 888.31 ± 1.0% | 15081.00 ± 0.2% | 403.71 ± 0.2% | 0.91 | 1.00 | 10.20 | 0.64 |
| other: a heading's start tag | 13 | 358.15 ± 0.4% | 363.76 ± 0.6% | 498.92 ± 0.5% | 43.98 ± 0.5% | 628.02 ± 1.0% | 880.26 ± 0.8% | 17864.38 ± 0.2% | 358.19 ± 0.4% | 0.98 | 1.00 | 8.14 | 0.57 |
| other: a whole word | 11 | 581.01 ± 0.6% | 616.73 ± 0.5% | 1087.06 ± 0.6% | 118.36 ± 0.5% | 561.92 ± 1.7% | 829.68 ± 0.3% | 26551.06 ± 0.3% | 580.85 ± 0.5% | 0.94 | 1.00 | 4.91 | 1.03 |
| other: a line's first word, second text | 17 | 529.44 ± 0.1% | 547.83 ± 0.4% | 931.22 ± 0.1% | 129.40 ± 0.1% | 704.57 ± 0.9% | refused | refused | 527.95 ± 0.8% | 0.97 | 1.00 | 4.09 | 0.75 |
| other: fourteen octets before an x | 16 | 111.67 ± 0.6% | 161.82 ± 0.3% | 190.58 ± 0.4% | 15.21 ± 0.3% | 450.93 ± 1.4% | 393.88 ± 0.3% | 12570.24 ± 0.6% | 111.53 ± 0.3% | 0.69 | 1.00 | 7.34 | 0.25 |
| other: a Greek word | 8 | 421.17 ± 0.2% | 581.45 ± 0.5% | 1041.29 ± 0.1% | 59.25 ± 0.7% | 1378.60 ± 1.9% | 1804.78 ± 0.7% | refused | 421.11 ± 0.2% | 0.72 | 1.00 | 7.11 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12844.54 ± 0.4% | not timed | not timed | 16233.42 ± 2.1% | 2123.58 ± 18.5% | not timed | not timed | 12859.39 ± 0.6% | | 1.00 | 0.79 | 6.05 |
| 01-literal/sherlock-casei-en | 522 | 4494.27 ± 1.0% | not timed | not timed | 3587.98 ± 0.1% | 32.46 ± 0.2% | not timed | not timed | 4488.12 ± 0.2% | | 1.00 | 1.25 | 138.44 |
| 01-literal/sherlock-ru | 724 | 13532.59 ± 0.5% | not timed | not timed | 17350.01 ± 0.5% | 1497.40 ± 13.6% | not timed | not timed | 13495.99 ± 1.0% | | 1.00 | 0.78 | 9.04 |
| 01-literal/sherlock-casei-ru | 746 | 5291.42 ± 0.2% | not timed | not timed | 3329.01 ± 0.1% | 31.58 ± 0.8% | not timed | not timed | 5291.14 ± 0.2% | | 1.00 | 1.59 | 167.53 |
| 01-literal/sherlock-zh | 30 | 16948.98 ± 0.7% | not timed | not timed | 18581.27 ± 0.7% | 2757.48 ± 9.2% | not timed | not timed | 16886.70 ± 0.3% | | 1.00 | 0.91 | 6.15 |
| 02-literal-alternate/sherlock-en | 714 | 5743.72 ± 0.2% | not timed | not timed | 3938.80 ± 0.3% | 16.63 ± 6.3% | not timed | not timed | 5748.26 ± 0.6% | | 1.00 | 1.46 | 345.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.34 ± 1.0% | not timed | not timed | 695.92 ± 0.2% | 11.11 ± 0.1% | not timed | not timed | 1707.02 ± 0.3% | | 1.00 | 2.46 | 154.09 |
| 02-literal-alternate/sherlock-ru | 899 | 4638.53 ± 0.1% | not timed | not timed | 3254.98 ± 0.1% | 22.61 ± 0.1% | not timed | not timed | 4649.24 ± 0.1% | | 1.00 | 1.43 | 205.15 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1812.58 ± 0.5% | not timed | not timed | 1231.95 ± 0.1% | 9.13 ± 0.2% | not timed | not timed | 1805.10 ± 0.2% | | 1.00 | 1.47 | 198.63 |
| 02-literal-alternate/sherlock-zh | 207 | 7049.63 ± 0.7% | not timed | not timed | 4163.27 ± 0.5% | 31.42 ± 0.1% | not timed | not timed | 7043.85 ± 0.3% | | 1.00 | 1.69 | 224.37 |
| 03-date/ascii | 111817 | 127.15 ± 0.6% | not timed | not timed | 95.97 ± 0.1% | 0.21 ± 2.2% | not timed | not timed | 126.57 ± 1.1% | | 1.00 | 1.32 | 617.66 |
| 04-ruff-noqa/real | 84 | 553.96 ± 0.1% | not timed | not timed | 467.04 ± 0.1% | 19.86 ± 1.3% | not timed | not timed | 553.30 ± 0.2% | | 1.00 | 1.19 | 27.90 |
| 04-ruff-noqa/tweaked | 44 | 549.60 ± 0.1% | not timed | not timed | 446.77 ± 0.2% | 365.04 ± 1.9% | not timed | not timed | 547.87 ± 0.1% | | 1.00 | 1.23 | 1.51 |
| 05-lexer-veryl/single | 124800 | 4.18 ± 0.2% | not timed | not timed | 5.18 ± 0.2% | 0.21 ± 2.8% | not timed | not timed | 4.24 ± 3.2% | | 0.99 | 0.81 | 20.29 |
| 06-cloud-flare-redos/original | 107 | 263.59 ± 0.2% | not timed | not timed | 216.85 ± 0.1% | 24.89 ± 0.2% | not timed | not timed | 263.44 ± 0.2% | | 1.00 | 1.22 | 10.59 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.14 ± 0.3% | not timed | not timed | 227.83 ± 0.1% | 26.76 ± 0.2% | not timed | not timed | 259.23 ± 0.2% | | 1.00 | 1.14 | 9.68 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.13 ± 0.2% | not timed | not timed | 255.86 ± 0.1% | 28.81 ± 0.5% | not timed | not timed | 286.15 ± 0.3% | | 1.00 | 1.12 | 9.93 |
| 07-unicode-character-data/parse-line | 558784 | 232.64 ± 0.5% | not timed | not timed | 178.42 ± 1.6% | 42.74 ± 6.2% | not timed | not timed | 230.52 ± 2.1% | | 1.01 | 1.30 | 5.44 |
| 08-words/all-english | 56691 | 120.88 ± 0.2% | not timed | not timed | 82.72 ± 0.1% | 11.98 ± 2.3% | not timed | not timed | 120.16 ± 0.6% | | 1.01 | 1.46 | 10.09 |
| 08-words/long-english | 839 | 1006.60 ± 0.0% | not timed | not timed | 596.92 ± 0.6% | 32.37 ± 15.0% | not timed | not timed | 1006.08 ± 0.2% | | 1.00 | 1.69 | 31.09 |
| 09-aws-keys/full | 0 | 409.09 ± 0.1% | not timed | not timed | 495.13 ± 0.1% | 64.61 ± 0.1% | not timed | not timed | 409.09 ± 0.1% | | 1.00 | 0.83 | 6.33 |
| 09-aws-keys/quick | 0 | 740.51 ± 0.0% | not timed | not timed | 998.50 ± 0.2% | 419.77 ± 0.6% | not timed | not timed | 737.82 ± 0.0% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 638.48 ± 0.3% | not timed | not timed | 518.03 ± 0.1% | 19.52 ± 0.5% | not timed | not timed | 637.90 ± 0.3% | | 1.00 | 1.23 | 32.70 |
| 10-bounded-repeat/letters-ru | 3475 | 385.49 ± 0.3% | not timed | not timed | 478.23 ± 0.1% | 21.89 ± 9.7% | not timed | not timed | 383.74 ± 0.5% | | 1.00 | 0.81 | 17.61 |
| 10-bounded-repeat/context | 53 | 78.96 ± 1.3% | not timed | not timed | 65.99 ± 0.4% | 19.69 ± 0.1% | not timed | not timed | 78.76 ± 0.9% | | 1.00 | 1.20 | 4.01 |
| 10-bounded-repeat/capitals | 11 | 1041.82 ± 0.2% | not timed | not timed | 616.79 ± 0.1% | 36.63 ± 0.2% | not timed | not timed | 1040.89 ± 0.1% | | 1.00 | 1.69 | 28.44 |
| 11-unstructured-to-json/extract | 600 | 49.87 ± 0.1% | not timed | not timed | 77.14 ± 0.2% | 48.98 ± 0.4% | not timed | not timed | 48.51 ± 0.1% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 565.63 ± 0.2% | not timed | not timed | 560.72 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 566.59 ± 0.5% | | 1.00 | 1.01 | 1380.66 |
| 14-quadratic/1x | 100 | 9.64 ± 0.5% | not timed | not timed | 10.04 ± 0.1% | 0.98 ± 2.5% | not timed | not timed | 9.59 ± 1.5% | | 1.01 | 0.96 | 9.80 |
| 14-quadratic/2x | 200 | 5.56 ± 1.4% | not timed | not timed | 5.55 ± 0.4% | 0.54 ± 1.0% | not timed | not timed | 5.53 ± 1.2% | | 1.01 | 1.00 | 10.39 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.2% | not timed | not timed | 1.21 ± 0.0% | 0.11 ± 1.6% | not timed | not timed | 1.26 ± 0.3% | | 1.00 | 1.04 | 10.96 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.35 ± 0.3% | 0.54 ± 4.1% | not timed | not timed | 1.44 ± 1.4% | | 1.00 | 4.18 | 2.67 |
| 04-ruff-noqa/compile-real | 1 | 92.72 ± 0.1% | not timed | not timed | 13.89 ± 0.3% | 136.37 ± 2.9% | not timed | not timed | 92.42 ± 1.3% | | 1.00 | 6.68 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 14.61 ± 0.1% | not timed | not timed | 2.55 ± 1.3% | 6.32 ± 2.0% | not timed | not timed | 14.55 ± 1.9% | | 1.00 | 5.72 | 2.31 |
| 07-unicode-character-data/compile | 1 | 58.41 ± 0.3% | not timed | not timed | 26.15 ± 0.1% | 35.46 ± 3.3% | not timed | not timed | 58.36 ± 1.6% | | 1.00 | 2.23 | 1.65 |
| 09-aws-keys/compile-full | 1 | 43.54 ± 0.2% | not timed | not timed | 8.29 ± 0.2% | 23.12 ± 1.0% | not timed | not timed | 43.41 ± 0.2% | | 1.00 | 5.25 | 1.88 |
| 09-aws-keys/compile-quick | 1 | 187.14 ± 0.1% | not timed | not timed | 47.44 ± 0.3% | 131.34 ± 3.9% | not timed | not timed | 187.56 ± 1.3% | | 1.00 | 3.95 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.64 ± 0.7% | not timed | not timed | 11.15 ± 0.6% | 15.79 ± 1.3% | not timed | not timed | 14.53 ± 1.0% | | 1.01 | 1.31 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 85.42 ± 0.8% | not timed | not timed | 8.10 ± 0.2% | 23.65 ± 1.4% | not timed | not timed | 84.44 ± 1.2% | | 1.01 | 10.55 | 3.61 |
| 11-unstructured-to-json/compile | 1 | 90.64 ± 0.1% | not timed | not timed | 41.43 ± 0.3% | 66.78 ± 2.8% | not timed | not timed | 89.81 ± 1.0% | | 1.01 | 2.19 | 1.36 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 1.6% | 0.10 ± 19.0% | not timed | not timed | 0.36 ± 1.7% | | 1.01 | 5.27 | 3.74 |

