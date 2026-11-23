# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159335181 |
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
| literal: a word | 217 | 16096.99 ± 1.8% | 1049.97 ± 0.2% | 28.66 ± 2.9% | 18271.91 ± 1.7% | 9377.99 ± 5.6% | 17.19 ± 0.2% | 86.63 ± 0.1% | 16120.69 ± 1.2% | 15.33 | 1.00 | 0.88 | 1.72 |
| literal: a word that is not there | 0 | 18590.09 ± 0.9% | 1057.35 ± 0.2% | 28.63 ± 0.7% | 19798.81 ± 1.5% | 29030.81 ± 1.8% | 17.00 ± 0.4% | 82.32 ± 0.2% | 18705.03 ± 0.8% | 17.58 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6062.98 ± 0.5% | 1030.78 ± 0.5% | 14.69 ± 0.2% | 3943.17 ± 0.2% | 21.90 ± 0.3% | 5.34 ± 0.2% | 6.93 ± 0.3% | 6052.49 ± 0.2% | 5.88 | 1.00 | 1.54 | 276.86 |
| literal: a word in any case | 217 | 12601.26 ± 0.9% | 1048.86 ± 0.2% | 21.89 ± 0.7% | 3968.98 ± 0.3% | 37.71 ± 0.1% | refused | differs | 12580.63 ± 0.4% | 12.01 | 1.00 | 3.17 | 334.16 |
| literal: an href attribute | 33 | 13493.92 ± 2.5% | 1055.10 ± 0.3% | 27.34 ± 0.1% | 16728.83 ± 4.3% | 2247.59 ± 1.1% | 13.13 ± 0.2% | 75.40 ± 0.1% | 13443.17 ± 4.4% | 12.79 | 1.00 | 0.81 | 6.00 |
| literal: a word, second text | 123 | 16287.12 ± 1.5% | 1049.91 ± 0.3% | 28.18 ± 0.4% | 18234.51 ± 2.0% | 7795.63 ± 10.0% | 20.10 ± 0.3% | 70.17 ± 0.5% | 16419.80 ± 1.1% | 15.51 | 0.99 | 0.89 | 2.09 |
| class: two capitalized words | 1331 | 1123.31 ± 0.5% | 979.79 ± 0.1% | 26.08 ± 0.3% | 583.40 ± 0.3% | 40.58 ± 0.1% | 14.67 ± 0.2% | 68.42 ± 0.2% | 1123.25 ± 0.4% | 1.15 | 1.00 | 1.93 | 27.68 |
| class: a word that ends in ing | 3399 | 901.39 ± 0.1% | 901.60 ± 0.2% | 18.21 ± 0.1% | 547.52 ± 0.1% | 29.52 ± 12.3% | 8.14 ± 0.1% | 17.13 ± 0.6% | 900.89 ± 0.1% | 1.00 | 1.00 | 1.65 | 30.53 |
| class: a word in capitals | 2332 | 1462.09 ± 0.7% | 955.58 ± 0.3% | 27.68 ± 0.4% | 572.31 ± 0.1% | 43.57 ± 9.9% | 17.11 ± 0.2% | 82.99 ± 1.2% | 1459.26 ± 0.3% | 1.53 | 1.00 | 2.55 | 33.56 |
| class: a number | 8288 | 2005.34 ± 0.4% | 839.89 ± 0.1% | 27.88 ± 0.4% | 1718.89 ± 0.2% | 43.36 ± 17.0% | 0.54 ± 0.1% | 56.48 ± 0.2% | 2007.07 ± 0.2% | 2.39 | 1.00 | 1.17 | 46.24 |
| class: two capitalized words, second text | 5359 | 744.19 ± 0.2% | 746.04 ± 0.1% | 23.37 ± 0.1% | 485.47 ± 0.1% | 35.36 ± 13.0% | 17.11 ± 0.3% | 63.49 ± 0.1% | 744.75 ± 0.4% | 1.00 | 1.00 | 1.53 | 21.05 |
| other: a word between two words | 6104 | 752.69 ± 0.1% | 775.28 ± 0.2% | 23.56 ± 0.4% | 737.81 ± 0.2% | 109.72 ± 11.5% | 11.13 ± 0.1% | 69.29 ± 0.3% | 749.65 ± 0.2% | 0.97 | 1.00 | 1.02 | 6.86 |
| other: a number before a unit, second text | 1481 | 5383.58 ± 0.6% | 991.04 ± 0.1% | 26.04 ± 0.2% | 5662.62 ± 0.1% | 40.70 ± 4.1% | 18.09 ± 0.6% | 66.94 ± 0.4% | 5369.47 ± 0.6% | 5.43 | 1.00 | 0.95 | 132.27 |
| other: a heading's start tag | 110 | 12493.52 ± 1.6% | 1045.21 ± 0.4% | 27.55 ± 0.1% | 1717.22 ± 0.7% | 1580.68 ± 0.6% | 15.96 ± 0.5% | 88.83 ± 0.8% | 12546.82 ± 1.2% | 11.95 | 1.00 | 7.28 | 7.90 |
| other: a whole word | 217 | 13947.76 ± 2.0% | 1046.52 ± 0.1% | 29.57 ± 0.4% | 14313.65 ± 1.1% | 49.40 ± 8.5% | 13.06 ± 0.2% | 55.75 ± 0.3% | 14020.30 ± 2.3% | 13.33 | 0.99 | 0.97 | 282.36 |
| other: a line's first word, second text | 3716 | 1970.27 ± 0.7% | 879.04 ± 0.2% | 31.15 ± 0.4% | 1724.87 ± 0.6% | 62.18 ± 7.1% | refused | refused | 1955.18 ± 1.0% | 2.24 | 1.01 | 1.14 | 31.69 |
| other: fourteen octets before an x | 87 | 19613.81 ± 2.1% | 227.70 ± 0.4% | 6.64 ± 0.1% | 3973.86 ± 0.6% | 10.66 ± 0.2% | differs | 17.66 ± 0.1% | 19696.22 ± 1.0% | 86.14 | 1.00 | 4.94 | 1840.34 |
| other: a Greek word | 21815 | 513.69 ± 0.5% | 412.69 ± 0.3% | 31.28 ± 0.6% | 289.24 ± 0.4% | 43.92 ± 8.7% | differs | refused | 509.98 ± 0.7% | 1.24 | 1.01 | 1.78 | 11.70 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.1% | 25.86 ± 0.1% | 0.87 ± 0.2% | 19.82 ± 0.2% | 2.75 ± 0.5% | differs | 4.03 ± 0.5% | 25.86 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.39 |
| a UUID | 32895 | 21.08 ± 0.3% | 21.14 ± 0.3% | 0.65 ± 0.2% | 15.06 ± 0.4% | 3.10 ± 0.2% | 0.73 ± 0.1% | 3.60 ± 0.8% | 21.21 ± 0.4% | 1.00 | 0.99 | 1.40 | 6.79 |
| an IPv4 address | 33176 | 36.87 ± 0.4% | 36.87 ± 0.3% | 2.11 ± 0.2% | 29.35 ± 0.6% | 6.65 ± 0.4% | differs | 4.14 ± 0.2% | 36.79 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.54 |
| a date and time | 32954 | 31.00 ± 0.6% | 31.06 ± 0.6% | 1.48 ± 0.2% | 21.53 ± 0.2% | 7.04 ± 0.2% | 1.25 ± 0.1% | 7.15 ± 0.4% | 30.99 ± 0.5% | 1.00 | 1.00 | 1.44 | 4.41 |
| a field path | 32606 | 29.46 ± 0.2% | 29.43 ± 0.1% | 1.04 ± 0.1% | 23.17 ± 0.3% | 3.52 ± 1.5% | differs | 2.97 ± 0.3% | 29.45 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.38 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.52 ± 0.6% | 11.52 ± 0.5% | 11.40 ± 0.7% | 11.58 ± 0.2% | 4.94 ± 1.6% | 0.93 ± 0.2% | none | 11.37 ± 0.8% | 1.00 | 1.01 | 0.99 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.26 ± 0.2% | 235.66 ± 0.3% | 286.82 ± 0.2% | 87.40 ± 0.2% | 220.97 ± 0.2% | 484.48 ± 0.3% | 3873.35 ± 1.6% | 234.41 ± 0.2% | 0.99 | 1.00 | 2.68 | 1.06 |
| a UUID | 62 | 157.62 ± 0.3% | 158.19 ± 0.2% | 179.65 ± 0.2% | 45.95 ± 0.3% | 98.79 ± 0.8% | 181.21 ± 0.8% | 4440.88 ± 0.8% | 157.54 ± 0.2% | 1.00 | 1.00 | 3.43 | 1.60 |
| an IPv4 address | 29 | 418.78 ± 0.3% | 423.95 ± 0.2% | 614.03 ± 0.3% | 77.53 ± 1.1% | 129.85 ± 1.7% | 290.51 ± 0.6% | 7639.44 ± 0.4% | 418.94 ± 0.4% | 0.99 | 1.00 | 5.40 | 3.23 |
| a date and time | 56 | 307.04 ± 0.2% | 309.71 ± 0.1% | 400.58 ± 0.2% | 72.75 ± 0.2% | 135.59 ± 1.6% | 319.28 ± 0.5% | 4898.82 ± 0.7% | 306.71 ± 0.3% | 0.99 | 1.00 | 4.22 | 2.26 |
| a field path | 39 | 226.97 ± 0.2% | 228.13 ± 0.1% | 275.00 ± 0.2% | 80.35 ± 0.3% | 205.48 ± 3.3% | 485.19 ± 1.0% | 4936.84 ± 1.1% | 226.99 ± 0.3% | 0.99 | 1.00 | 2.82 | 1.10 |
| literal: a word | 7 | 619.78 ± 0.2% | 662.27 ± 0.2% | 1246.33 ± 0.8% | 514.94 ± 2.3% | 624.69 ± 9.1% | 912.44 ± 1.0% | 29480.86 ± 0.2% | 620.23 ± 0.5% | 0.94 | 1.00 | 1.20 | 0.99 |
| literal: a word that is not there | 8 | 597.10 ± 0.3% | 644.96 ± 0.2% | 1170.20 ± 0.5% | 471.58 ± 0.2% | 601.87 ± 1.1% | 867.80 ± 0.6% | 28492.78 ± 0.1% | 597.29 ± 0.4% | 0.93 | 1.00 | 1.27 | 0.99 |
| literal: one of four words | 26 | 240.65 ± 0.2% | 398.60 ± 0.4% | 562.12 ± 0.5% | 49.44 ± 0.3% | 242.37 ± 1.2% | 355.37 ± 0.6% | 15381.93 ± 0.6% | 241.03 ± 0.2% | 0.60 | 1.00 | 4.87 | 0.99 |
| literal: a word in any case | 11 | 481.89 ± 0.3% | 514.47 ± 0.4% | 840.15 ± 0.4% | 15.77 ± 1.0% | 648.32 ± 2.8% | refused | 23389.58 ± 0.2% | 481.77 ± 0.3% | 0.94 | 1.00 | 30.55 | 0.74 |
| literal: an href attribute | 12 | 347.96 ± 0.3% | 360.43 ± 0.5% | 492.39 ± 0.4% | 9.63 ± 25.6% | 499.04 ± 1.1% | 757.42 ± 1.6% | 21461.87 ± 0.2% | 348.27 ± 0.3% | 0.97 | 1.00 | 36.14 | 0.70 |
| literal: a word, second text | 10 | 557.43 ± 0.2% | 608.32 ± 0.8% | 1061.41 ± 0.3% | 421.81 ± 0.3% | 532.60 ± 1.4% | 780.88 ± 0.5% | 26446.09 ± 0.1% | 557.21 ± 0.3% | 0.92 | 1.00 | 1.32 | 1.05 |
| class: two capitalized words | 23 | 433.33 ± 0.4% | 465.92 ± 0.6% | 705.66 ± 0.2% | 101.75 ± 0.5% | 500.79 ± 0.7% | 740.45 ± 0.9% | 6577.34 ± 0.2% | 433.92 ± 0.2% | 0.93 | 1.00 | 4.26 | 0.87 |
| class: a word that ends in ing | 9 | 551.07 ± 0.2% | 623.33 ± 0.3% | 1162.52 ± 0.1% | 134.28 ± 0.6% | 758.18 ± 1.3% | 1092.74 ± 3.0% | 16014.38 ± 0.2% | 551.18 ± 0.4% | 0.88 | 1.00 | 4.10 | 0.73 |
| class: a word in capitals | 16 | 485.80 ± 0.7% | 528.73 ± 0.5% | 901.44 ± 0.2% | 137.56 ± 1.2% | 752.35 ± 0.5% | 1014.84 ± 2.1% | 8640.65 ± 0.8% | 486.08 ± 0.2% | 0.92 | 1.00 | 3.53 | 0.65 |
| class: a number | 6 | 603.15 ± 0.3% | 676.84 ± 0.5% | 1359.97 ± 0.0% | 42.05 ± 0.8% | 1401.88 ± 0.5% | 1853.13 ± 1.9% | 22497.52 ± 0.1% | 602.97 ± 0.4% | 0.89 | 1.00 | 14.34 | 0.43 |
| class: two capitalized words, second text | 23 | 433.60 ± 0.4% | 465.88 ± 0.3% | 706.06 ± 0.1% | 101.10 ± 1.0% | 504.50 ± 2.0% | 733.17 ± 0.3% | 6581.04 ± 0.2% | 433.86 ± 0.2% | 0.93 | 1.00 | 4.29 | 0.86 |
| other: a word between two words | 13 | 547.58 ± 0.1% | 566.09 ± 0.4% | 944.40 ± 0.4% | 135.07 ± 0.6% | 506.27 ± 1.1% | 807.20 ± 1.1% | 14807.47 ± 0.3% | 547.06 ± 0.3% | 0.97 | 1.00 | 4.05 | 1.08 |
| other: a number before a unit, second text | 15 | 403.64 ± 0.2% | 445.44 ± 0.4% | 654.07 ± 0.1% | 39.79 ± 0.2% | 639.71 ± 0.5% | 886.18 ± 0.3% | 15075.34 ± 0.2% | 403.88 ± 0.2% | 0.91 | 1.00 | 10.14 | 0.63 |
| other: a heading's start tag | 13 | 358.40 ± 0.5% | 363.85 ± 0.9% | 499.76 ± 0.7% | 9.33 ± 18.5% | 629.33 ± 0.9% | 869.85 ± 0.4% | 17851.34 ± 0.5% | 359.00 ± 0.5% | 0.99 | 1.00 | 38.41 | 0.57 |
| other: a whole word | 11 | 579.42 ± 0.8% | 615.12 ± 0.2% | 1081.87 ± 0.0% | 121.73 ± 0.2% | 566.09 ± 1.9% | 820.21 ± 1.7% | 26522.75 ± 0.3% | 578.80 ± 0.3% | 0.94 | 1.00 | 4.76 | 1.02 |
| other: a line's first word, second text | 17 | 529.80 ± 0.5% | 547.39 ± 0.4% | 936.68 ± 0.3% | 130.59 ± 0.2% | 712.63 ± 1.5% | refused | refused | 529.03 ± 0.3% | 0.97 | 1.00 | 4.06 | 0.74 |
| other: fourteen octets before an x | 16 | 111.64 ± 0.5% | 161.99 ± 0.4% | 190.98 ± 0.6% | 7.03 ± 20.0% | 452.99 ± 1.6% | 411.11 ± 0.7% | 12573.98 ± 0.8% | 111.67 ± 0.5% | 0.69 | 1.00 | 15.87 | 0.25 |
| other: a Greek word | 8 | 421.00 ± 0.4% | 581.49 ± 0.3% | 1041.10 ± 0.2% | 10.02 ± 11.8% | 1382.48 ± 2.3% | 1848.54 ± 0.4% | refused | 420.98 ± 0.3% | 0.72 | 1.00 | 42.04 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12655.37 ± 1.5% | not timed | not timed | 15568.38 ± 1.0% | 2072.43 ± 9.4% | not timed | not timed | 12661.14 ± 0.7% | | 1.00 | 0.81 | 6.11 |
| 01-literal/sherlock-casei-en | 522 | 4484.07 ± 0.9% | not timed | not timed | 3591.15 ± 0.2% | 32.51 ± 0.2% | not timed | not timed | 4477.17 ± 0.2% | | 1.00 | 1.25 | 137.92 |
| 01-literal/sherlock-ru | 724 | 13509.31 ± 1.3% | not timed | not timed | 17204.40 ± 0.7% | 1378.35 ± 10.1% | not timed | not timed | 13505.39 ± 0.6% | | 1.00 | 0.79 | 9.80 |
| 01-literal/sherlock-casei-ru | 746 | 5306.21 ± 0.2% | not timed | not timed | 3327.81 ± 0.1% | 31.76 ± 0.4% | not timed | not timed | 5286.48 ± 0.1% | | 1.00 | 1.59 | 167.05 |
| 01-literal/sherlock-zh | 30 | 16589.88 ± 0.4% | not timed | not timed | 17764.00 ± 0.6% | 2688.28 ± 24.5% | not timed | not timed | 16529.12 ± 0.9% | | 1.00 | 0.93 | 6.17 |
| 02-literal-alternate/sherlock-en | 714 | 5756.15 ± 0.4% | not timed | not timed | 3942.79 ± 0.3% | 16.61 ± 0.2% | not timed | not timed | 5759.44 ± 0.2% | | 1.00 | 1.46 | 346.48 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1701.31 ± 1.1% | not timed | not timed | 698.34 ± 0.3% | 11.13 ± 0.1% | not timed | not timed | 1704.56 ± 0.5% | | 1.00 | 2.44 | 152.83 |
| 02-literal-alternate/sherlock-ru | 899 | 4646.45 ± 0.1% | not timed | not timed | 3254.66 ± 0.2% | 22.59 ± 9.4% | not timed | not timed | 4650.66 ± 0.2% | | 1.00 | 1.43 | 205.72 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1813.54 ± 0.9% | not timed | not timed | 1232.39 ± 0.1% | 9.15 ± 0.1% | not timed | not timed | 1807.51 ± 0.1% | | 1.00 | 1.47 | 198.22 |
| 02-literal-alternate/sherlock-zh | 207 | 7053.96 ± 0.3% | not timed | not timed | 4162.43 ± 0.1% | 31.49 ± 0.1% | not timed | not timed | 7058.84 ± 0.3% | | 1.00 | 1.69 | 224.02 |
| 03-date/ascii | 111817 | 126.23 ± 0.2% | not timed | not timed | 96.09 ± 0.1% | 0.20 ± 1.6% | not timed | not timed | 125.62 ± 0.1% | | 1.00 | 1.31 | 623.27 |
| 04-ruff-noqa/real | 84 | 556.20 ± 0.1% | not timed | not timed | 473.54 ± 0.1% | 19.42 ± 1.8% | not timed | not timed | 555.85 ± 0.1% | | 1.00 | 1.17 | 28.63 |
| 04-ruff-noqa/tweaked | 44 | 541.41 ± 0.1% | not timed | not timed | 464.70 ± 0.1% | 335.50 ± 2.0% | not timed | not timed | 540.48 ± 0.2% | | 1.00 | 1.17 | 1.61 |
| 05-lexer-veryl/single | 124800 | 4.21 ± 0.4% | not timed | not timed | 5.15 ± 0.3% | 0.20 ± 5.2% | not timed | not timed | 4.27 ± 0.5% | | 0.99 | 0.82 | 20.71 |
| 06-cloud-flare-redos/original | 107 | 260.86 ± 0.3% | not timed | not timed | 215.98 ± 0.0% | 24.89 ± 0.3% | not timed | not timed | 260.09 ± 0.1% | | 1.00 | 1.21 | 10.48 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.13 ± 0.2% | not timed | not timed | 228.15 ± 0.1% | 26.66 ± 0.1% | not timed | not timed | 254.65 ± 0.6% | | 1.00 | 1.12 | 9.57 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.33 ± 0.1% | not timed | not timed | 255.72 ± 0.1% | 28.71 ± 0.1% | not timed | not timed | 292.34 ± 0.1% | | 1.00 | 1.14 | 10.18 |
| 07-unicode-character-data/parse-line | 558784 | 234.69 ± 0.3% | not timed | not timed | 176.91 ± 0.5% | 41.33 ± 4.9% | not timed | not timed | 230.56 ± 2.7% | | 1.02 | 1.33 | 5.68 |
| 08-words/all-english | 56691 | 121.52 ± 0.4% | not timed | not timed | 83.24 ± 0.1% | 11.37 ± 6.6% | not timed | not timed | 120.63 ± 0.5% | | 1.01 | 1.46 | 10.68 |
| 08-words/long-english | 839 | 1012.95 ± 0.3% | not timed | not timed | 597.52 ± 0.0% | 32.70 ± 2.1% | not timed | not timed | 1012.12 ± 0.2% | | 1.00 | 1.70 | 30.98 |
| 09-aws-keys/full | 0 | 408.62 ± 0.1% | not timed | not timed | 476.16 ± 0.3% | 63.25 ± 0.5% | not timed | not timed | 408.78 ± 0.2% | | 1.00 | 0.86 | 6.46 |
| 09-aws-keys/quick | 0 | 739.66 ± 0.0% | not timed | not timed | 991.32 ± 0.3% | 375.87 ± 1.1% | not timed | not timed | 738.22 ± 0.1% | | 1.00 | 0.75 | 1.97 |
| 10-bounded-repeat/letters-en | 1833 | 637.89 ± 0.4% | not timed | not timed | 516.52 ± 0.2% | 19.54 ± 0.6% | not timed | not timed | 636.86 ± 0.2% | | 1.00 | 1.23 | 32.64 |
| 10-bounded-repeat/letters-ru | 3475 | 382.71 ± 0.2% | not timed | not timed | 478.34 ± 0.1% | 21.65 ± 17.1% | not timed | not timed | 381.12 ± 0.6% | | 1.00 | 0.80 | 17.68 |
| 10-bounded-repeat/context | 53 | 78.19 ± 1.3% | not timed | not timed | 65.23 ± 0.9% | 19.81 ± 0.2% | not timed | not timed | 78.91 ± 1.2% | | 0.99 | 1.20 | 3.95 |
| 10-bounded-repeat/capitals | 11 | 1054.37 ± 0.1% | not timed | not timed | 615.57 ± 0.0% | 36.62 ± 0.2% | not timed | not timed | 1054.09 ± 0.2% | | 1.00 | 1.71 | 28.79 |
| 11-unstructured-to-json/extract | 600 | 49.97 ± 0.1% | not timed | not timed | 77.24 ± 0.1% | 49.00 ± 0.5% | not timed | not timed | 48.50 ± 0.3% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 567.76 ± 0.4% | not timed | not timed | 561.68 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 568.43 ± 1.0% | | 1.00 | 1.01 | 1401.92 |
| 14-quadratic/1x | 100 | 12.82 ± 0.3% | not timed | not timed | 10.02 ± 0.1% | 0.98 ± 3.0% | not timed | not timed | 12.74 ± 1.2% | | 1.01 | 1.28 | 13.14 |
| 14-quadratic/2x | 200 | 7.91 ± 0.6% | not timed | not timed | 5.52 ± 0.1% | 0.53 ± 1.0% | not timed | not timed | 7.85 ± 1.0% | | 1.01 | 1.43 | 14.86 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.0% | not timed | not timed | 1.88 ± 0.5% | | 1.00 | 1.55 | 16.28 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.6% | 0.53 ± 4.1% | not timed | not timed | 1.44 ± 1.7% | | 1.01 | 4.26 | 2.72 |
| 04-ruff-noqa/compile-real | 1 | 92.70 ± 0.2% | not timed | not timed | 13.79 ± 0.3% | 132.61 ± 13.6% | not timed | not timed | 92.59 ± 1.1% | | 1.00 | 6.72 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 14.59 ± 1.5% | not timed | not timed | 2.51 ± 0.6% | 6.16 ± 3.2% | not timed | not timed | 14.53 ± 1.1% | | 1.00 | 5.80 | 2.37 |
| 07-unicode-character-data/compile | 1 | 58.35 ± 0.1% | not timed | not timed | 25.70 ± 0.4% | 35.12 ± 1.4% | not timed | not timed | 58.34 ± 0.8% | | 1.00 | 2.27 | 1.66 |
| 09-aws-keys/compile-full | 1 | 43.74 ± 0.5% | not timed | not timed | 8.24 ± 0.2% | 22.87 ± 2.2% | not timed | not timed | 43.52 ± 0.2% | | 1.01 | 5.31 | 1.91 |
| 09-aws-keys/compile-quick | 1 | 187.26 ± 0.1% | not timed | not timed | 46.89 ± 0.1% | 128.76 ± 2.0% | not timed | not timed | 187.13 ± 1.0% | | 1.00 | 3.99 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 14.68 ± 0.6% | not timed | not timed | 11.12 ± 0.3% | 15.52 ± 3.3% | not timed | not timed | 14.59 ± 1.0% | | 1.01 | 1.32 | 0.95 |
| 10-bounded-repeat/compile-capitals | 1 | 85.31 ± 1.0% | not timed | not timed | 8.06 ± 0.1% | 23.07 ± 2.6% | not timed | not timed | 84.46 ± 1.6% | | 1.01 | 10.58 | 3.70 |
| 11-unstructured-to-json/compile | 1 | 90.59 ± 0.3% | not timed | not timed | 40.83 ± 1.2% | 66.01 ± 5.2% | not timed | not timed | 90.32 ± 0.5% | | 1.00 | 2.22 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 0.7% | 0.09 ± 13.3% | not timed | not timed | 0.36 ± 1.3% | | 1.01 | 5.37 | 3.87 |

