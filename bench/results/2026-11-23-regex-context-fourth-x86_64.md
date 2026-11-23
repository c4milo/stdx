# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117644739 |
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
| literal: a word | 217 | 31964.72 ± 0.2% | 797.30 ± 0.2% | 23.71 ± 0.7% | 29545.95 ± 1.3% | 9129.33 ± 6.5% | 9.89 ± 0.3% | 80.78 ± 0.6% | 31764.57 ± 1.0% | 40.09 | 1.01 | 1.08 | 3.50 |
| literal: a word that is not there | 0 | 44725.05 ± 0.6% | 805.67 ± 0.1% | 23.68 ± 0.6% | 35177.42 ± 0.4% | 33015.37 ± 0.7% | 9.78 ± 0.3% | 75.46 ± 0.1% | 44673.07 ± 0.3% | 55.51 | 1.00 | 1.27 | 1.35 |
| literal: one of four words | 661 | 10800.85 ± 0.4% | 780.81 ± 0.2% | 13.13 ± 0.4% | 8820.74 ± 1.4% | 19.18 ± 0.8% | 3.45 ± 0.5% | 6.41 ± 2.9% | 10785.98 ± 0.1% | 13.83 | 1.00 | 1.22 | 563.26 |
| literal: a word in any case | 217 | 28694.06 ± 1.8% | 796.99 ± 0.4% | 17.84 ± 0.3% | 8898.75 ± 0.5% | 36.59 ± 0.4% | refused | differs | 28754.41 ± 0.2% | 36.00 | 1.00 | 3.22 | 784.13 |
| literal: an href attribute | 33 | 27632.64 ± 0.5% | 801.67 ± 0.7% | 22.70 ± 0.7% | 27022.22 ± 1.8% | 2273.33 ± 5.9% | 7.42 ± 0.2% | 70.57 ± 4.4% | 27643.54 ± 0.7% | 34.47 | 1.00 | 1.02 | 12.16 |
| literal: a word, second text | 123 | 34418.34 ± 0.7% | 799.75 ± 0.2% | 23.36 ± 0.2% | 30500.84 ± 9.3% | 8463.63 ± 8.5% | 11.22 ± 0.6% | 67.91 ± 0.5% | 34461.93 ± 8.3% | 43.04 | 1.00 | 1.13 | 4.07 |
| class: two capitalized words | 1331 | 695.81 ± 0.3% | 737.08 ± 0.3% | 22.12 ± 4.1% | 446.46 ± 0.5% | 34.30 ± 15.0% | 8.47 ± 0.6% | 61.22 ± 0.3% | 695.41 ± 1.8% | 0.94 | 1.00 | 1.56 | 20.29 |
| class: a word that ends in ing | 3399 | 673.87 ± 2.1% | 675.20 ± 0.3% | 15.45 ± 0.9% | 418.21 ± 0.2% | 25.47 ± 5.0% | 4.81 ± 0.2% | 16.14 ± 1.4% | 674.23 ± 0.4% | 1.00 | 1.00 | 1.61 | 26.46 |
| class: a word in capitals | 2332 | 886.66 ± 0.1% | 722.00 ± 0.6% | 23.23 ± 0.4% | 439.56 ± 0.8% | 36.82 ± 11.5% | 9.61 ± 0.7% | 78.15 ± 2.1% | 886.30 ± 0.1% | 1.23 | 1.00 | 2.02 | 24.08 |
| class: a number | 8288 | 1340.72 ± 3.7% | 612.56 ± 1.4% | 23.23 ± 2.6% | 1384.71 ± 1.7% | 36.36 ± 10.9% | 0.30 ± 0.2% | 54.76 ± 0.2% | 1343.11 ± 0.6% | 2.19 | 1.00 | 0.97 | 36.87 |
| class: two capitalized words, second text | 5359 | 533.30 ± 0.3% | 532.10 ± 0.2% | 19.96 ± 0.8% | 370.11 ± 0.3% | 29.96 ± 12.2% | 9.87 ± 0.2% | 56.78 ± 0.8% | 529.43 ± 0.3% | 1.00 | 1.01 | 1.44 | 17.80 |
| other: a word between two words | 6104 | 604.05 ± 0.4% | 566.94 ± 0.5% | 19.91 ± 10.4% | 629.96 ± 0.3% | 96.28 ± 11.9% | 6.58 ± 0.2% | 62.88 ± 0.8% | 599.63 ± 0.4% | 1.07 | 1.01 | 0.96 | 6.27 |
| other: a number before a unit, second text | 1481 | 7270.71 ± 0.4% | 758.92 ± 0.3% | 22.01 ± 15.7% | 6384.11 ± 1.3% | 35.13 ± 1.0% | 10.30 ± 0.1% | 59.60 ± 2.7% | 7265.18 ± 0.3% | 9.58 | 1.00 | 1.14 | 206.96 |
| other: a heading's start tag | 110 | 19178.80 ± 0.5% | 794.25 ± 0.4% | 23.36 ± 0.8% | 1934.02 ± 1.3% | 1562.99 ± 2.8% | 9.03 ± 0.7% | 82.87 ± 4.4% | 19141.41 ± 0.2% | 24.15 | 1.00 | 9.92 | 12.27 |
| other: a whole word | 217 | 22711.68 ± 0.3% | 797.52 ± 0.2% | 23.90 ± 0.4% | 21535.06 ± 2.4% | 42.15 ± 0.9% | 8.58 ± 0.2% | 48.51 ± 1.0% | 22642.63 ± 0.3% | 28.48 | 1.00 | 1.05 | 538.81 |
| other: a line's first word, second text | 3716 | 1813.63 ± 1.6% | 657.95 ± 0.1% | 25.06 ± 0.7% | 1793.98 ± 0.7% | 55.26 ± 2.4% | refused | refused | 1788.73 ± 1.2% | 2.76 | 1.01 | 1.01 | 32.82 |
| other: fourteen octets before an x | 87 | 27385.39 ± 0.3% | 189.73 ± 1.8% | 5.44 ± 3.7% | 2633.36 ± 6.9% | 8.95 ± 4.3% | differs | 15.59 ± 1.3% | 27422.14 ± 0.3% | 144.34 | 1.00 | 10.40 | 3059.58 |
| other: a Greek word | 21815 | 374.89 ± 0.2% | 254.23 ± 0.5% | 26.08 ± 0.3% | 234.78 ± 0.9% | 38.10 ± 1.9% | differs | refused | 371.64 ± 0.3% | 1.47 | 1.01 | 1.60 | 9.84 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.23 ± 16.2% | 22.26 ± 28.2% | 0.77 ± 2.4% | 15.36 ± 0.2% | 1.70 ± 16.6% | differs | 3.25 ± 2.7% | 22.26 ± 10.1% | 1.00 | 1.00 | 1.45 | 13.09 |
| a UUID | 32895 | 18.77 ± 0.4% | 18.80 ± 0.4% | 0.57 ± 0.4% | 11.72 ± 0.2% | 2.33 ± 1.2% | 0.40 ± 0.2% | 2.86 ± 5.6% | 18.76 ± 0.2% | 1.00 | 1.00 | 1.60 | 8.04 |
| an IPv4 address | 33176 | 31.03 ± 0.5% | 30.62 ± 0.4% | 1.83 ± 0.3% | 21.96 ± 0.3% | 5.38 ± 1.1% | differs | 3.26 ± 0.5% | 31.22 ± 0.9% | 1.01 | 0.99 | 1.41 | 5.77 |
| a date and time | 32954 | 28.24 ± 2.5% | 27.61 ± 2.4% | 1.35 ± 0.5% | 16.76 ± 0.1% | 6.36 ± 2.5% | 0.70 ± 0.3% | 5.57 ± 3.2% | 28.27 ± 0.6% | 1.02 | 1.00 | 1.68 | 4.44 |
| a field path | 32606 | 24.84 ± 0.5% | 24.74 ± 34.5% | 0.88 ± 2.2% | 17.74 ± 0.5% | 2.71 ± 1.2% | differs | 2.31 ± 0.9% | 24.85 ± 0.3% | 1.00 | 1.00 | 1.40 | 9.17 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.51 ± 0.2% | 8.50 ± 0.4% | 8.44 ± 0.5% | 10.45 ± 1.2% | 4.51 ± 2.3% | 0.58 ± 0.5% | none | 8.52 ± 0.3% | 1.00 | 1.00 | 0.81 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 180.06 ± 1.0% | 181.06 ± 0.3% | 209.08 ± 0.9% | 78.52 ± 4.7% | 190.23 ± 3.8% | 543.34 ± 2.3% | 3792.04 ± 0.2% | 180.32 ± 0.1% | 0.99 | 1.00 | 2.29 | 0.95 |
| a UUID | 62 | 116.86 ± 1.0% | 117.53 ± 0.1% | 129.59 ± 2.8% | 44.67 ± 1.8% | 92.09 ± 1.9% | 194.83 ± 9.1% | 4176.11 ± 1.9% | 117.11 ± 0.5% | 0.99 | 1.00 | 2.62 | 1.27 |
| an IPv4 address | 29 | 393.59 ± 9.4% | 399.04 ± 11.3% | 566.85 ± 0.2% | 66.88 ± 6.2% | 115.93 ± 1.7% | 319.17 ± 3.7% | 6879.22 ± 0.5% | 394.94 ± 0.2% | 0.99 | 1.00 | 5.89 | 3.40 |
| a date and time | 56 | 291.24 ± 1.4% | 293.77 ± 0.3% | 370.95 ± 0.5% | 66.38 ± 1.6% | 122.87 ± 4.1% | 367.24 ± 17.6% | 4302.41 ± 18.1% | 291.15 ± 0.3% | 0.99 | 1.00 | 4.39 | 2.37 |
| a field path | 39 | 171.65 ± 0.2% | 172.69 ± 0.4% | 197.18 ± 6.5% | 72.18 ± 2.1% | 177.99 ± 2.7% | 577.87 ± 5.2% | 4601.22 ± 1.2% | 171.72 ± 0.2% | 0.99 | 1.00 | 2.38 | 0.96 |
| literal: a word | 7 | 596.49 ± 0.9% | 640.03 ± 0.1% | 1154.63 ± 0.5% | 491.66 ± 0.9% | 607.95 ± 2.8% | 1237.87 ± 15.6% | 21412.99 ± 2.1% | 597.22 ± 0.2% | 0.93 | 1.00 | 1.21 | 0.98 |
| literal: a word that is not there | 8 | 574.27 ± 0.5% | 618.55 ± 0.2% | 1085.57 ± 0.6% | 456.14 ± 1.0% | 586.82 ± 3.4% | 1162.32 ± 0.6% | 20981.42 ± 16.6% | 574.29 ± 0.3% | 0.93 | 1.00 | 1.26 | 0.98 |
| literal: one of four words | 26 | 221.51 ± 0.8% | 363.74 ± 3.0% | 489.36 ± 3.3% | 41.43 ± 0.1% | 227.41 ± 3.2% | 453.83 ± 1.1% | 14163.70 ± 1.7% | 221.47 ± 0.4% | 0.61 | 1.00 | 5.35 | 0.97 |
| literal: a word in any case | 11 | 458.32 ± 0.6% | 490.24 ± 0.3% | 749.21 ± 0.4% | 14.41 ± 1.2% | 629.57 ± 3.2% | refused | 18462.74 ± 12.3% | 457.58 ± 2.1% | 0.93 | 1.00 | 31.82 | 0.73 |
| literal: an href attribute | 12 | 315.73 ± 12.7% | 328.76 ± 23.5% | 433.35 ± 5.4% | 39.37 ± 0.9% | 442.89 ± 3.0% | 966.83 ± 1.0% | 16368.01 ± 14.8% | 315.41 ± 15.4% | 0.96 | 1.00 | 8.02 | 0.71 |
| literal: a word, second text | 10 | 530.49 ± 0.4% | 581.46 ± 0.2% | 975.94 ± 0.3% | 416.99 ± 1.6% | 503.33 ± 1.7% | 1016.40 ± 0.9% | 20169.49 ± 18.6% | 530.51 ± 0.3% | 0.91 | 1.00 | 1.27 | 1.05 |
| class: two capitalized words | 23 | 419.90 ± 0.4% | 454.43 ± 0.7% | 665.46 ± 0.4% | 94.43 ± 0.2% | 465.53 ± 4.3% | 977.04 ± 0.9% | 6137.92 ± 13.8% | 419.69 ± 0.3% | 0.92 | 1.00 | 4.45 | 0.90 |
| class: a word that ends in ing | 9 | 517.27 ± 6.0% | 588.58 ± 0.8% | 1034.94 ± 0.3% | 115.25 ± 10.4% | 648.27 ± 19.8% | 1404.54 ± 3.3% | 14272.14 ± 7.1% | 518.48 ± 6.0% | 0.88 | 1.00 | 4.49 | 0.80 |
| class: a word in capitals | 16 | 463.04 ± 0.5% | 507.66 ± 0.4% | 822.13 ± 0.5% | 119.59 ± 2.8% | 681.44 ± 2.3% | 1310.19 ± 1.3% | 7960.06 ± 0.2% | 463.20 ± 0.6% | 0.91 | 1.00 | 3.87 | 0.68 |
| class: a number | 6 | 568.44 ± 0.7% | 637.21 ± 0.3% | 1195.66 ± 0.4% | 36.29 ± 1.1% | 1253.98 ± 1.0% | 2213.86 ± 1.1% | 17867.79 ± 0.5% | 568.47 ± 0.4% | 0.89 | 1.00 | 15.66 | 0.45 |
| class: two capitalized words, second text | 23 | 419.68 ± 0.1% | 454.95 ± 0.1% | 665.26 ± 0.3% | 94.93 ± 0.7% | 462.89 ± 1.8% | 979.20 ± 1.0% | 6135.86 ± 0.3% | 419.43 ± 2.1% | 0.92 | 1.00 | 4.42 | 0.91 |
| other: a word between two words | 13 | 512.45 ± 0.2% | 530.49 ± 1.5% | 840.54 ± 0.2% | 120.62 ± 1.1% | 447.98 ± 5.7% | 1013.60 ± 3.2% | 12265.06 ± 0.7% | 511.52 ± 0.7% | 0.97 | 1.00 | 4.25 | 1.14 |
| other: a number before a unit, second text | 15 | 343.66 ± 0.5% | 379.15 ± 0.5% | 517.48 ± 0.4% | 33.95 ± 2.4% | 553.51 ± 1.2% | 1120.35 ± 16.7% | 13334.94 ± 0.5% | 343.59 ± 0.7% | 0.91 | 1.00 | 10.12 | 0.62 |
| other: a heading's start tag | 13 | 327.54 ± 1.9% | 334.13 ± 14.2% | 444.16 ± 0.3% | 37.96 ± 0.7% | 546.55 ± 1.7% | 1085.63 ± 1.7% | 14228.56 ± 1.3% | 327.17 ± 0.7% | 0.98 | 1.00 | 8.63 | 0.60 |
| other: a whole word | 11 | 520.95 ± 0.9% | 550.35 ± 0.6% | 897.22 ± 0.4% | 110.91 ± 1.5% | 522.68 ± 2.4% | 1074.53 ± 1.7% | 20876.45 ± 0.8% | 519.47 ± 1.9% | 0.95 | 1.00 | 4.70 | 1.00 |
| other: a line's first word, second text | 17 | 497.32 ± 1.0% | 519.46 ± 0.5% | 834.73 ± 17.2% | 115.96 ± 1.3% | 608.65 ± 3.5% | refused | refused | 496.00 ± 12.5% | 0.96 | 1.00 | 4.29 | 0.82 |
| other: fourteen octets before an x | 16 | 92.84 ± 2.5% | 137.52 ± 1.0% | 162.00 ± 1.0% | 14.15 ± 1.9% | 401.76 ± 2.5% | 451.48 ± 1.5% | 11515.57 ± 3.5% | 92.99 ± 0.7% | 0.68 | 1.00 | 6.56 | 0.23 |
| other: a Greek word | 8 | 359.14 ± 0.2% | 492.38 ± 0.4% | 777.72 ± 0.2% | 49.23 ± 0.4% | 1223.62 ± 2.4% | 2089.76 ± 2.3% | refused | 359.09 ± 0.4% | 0.73 | 1.00 | 7.30 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21288.11 ± 0.6% | not timed | not timed | 25352.16 ± 0.8% | 1963.80 ± 17.4% | not timed | not timed | 21302.31 ± 0.7% | | 1.00 | 0.84 | 10.84 |
| 01-literal/sherlock-casei-en | 522 | 4937.56 ± 2.0% | not timed | not timed | 6974.20 ± 1.4% | 26.27 ± 0.7% | not timed | not timed | 4935.71 ± 1.6% | | 1.00 | 0.71 | 187.95 |
| 01-literal/sherlock-ru | 724 | 23035.06 ± 0.7% | not timed | not timed | 26253.54 ± 0.6% | 964.57 ± 6.4% | not timed | not timed | 23042.27 ± 0.4% | | 1.00 | 0.88 | 23.88 |
| 01-literal/sherlock-casei-ru | 746 | 6799.00 ± 1.1% | not timed | not timed | 6072.17 ± 1.0% | 28.96 ± 0.9% | not timed | not timed | 6794.08 ± 0.6% | | 1.00 | 1.12 | 234.75 |
| 01-literal/sherlock-zh | 30 | 40959.68 ± 0.9% | not timed | not timed | 33276.75 ± 0.5% | 1271.74 ± 4.0% | not timed | not timed | 40725.19 ± 0.8% | | 1.01 | 1.23 | 32.21 |
| 02-literal-alternate/sherlock-en | 714 | 9790.18 ± 0.5% | not timed | not timed | 8577.74 ± 14.3% | 14.77 ± 1.0% | not timed | not timed | 9748.56 ± 0.4% | | 1.00 | 1.14 | 663.02 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1604.99 ± 1.4% | not timed | not timed | 1771.47 ± 0.8% | 9.53 ± 0.8% | not timed | not timed | 1570.75 ± 1.2% | | 1.02 | 0.91 | 168.43 |
| 02-literal-alternate/sherlock-ru | 899 | 5796.90 ± 0.4% | not timed | not timed | 7625.42 ± 1.1% | 19.70 ± 16.0% | not timed | not timed | 5705.75 ± 1.6% | | 1.02 | 0.76 | 294.30 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1569.08 ± 1.7% | not timed | not timed | 913.34 ± 0.4% | 8.20 ± 0.7% | not timed | not timed | 1563.32 ± 1.4% | | 1.00 | 1.72 | 191.37 |
| 02-literal-alternate/sherlock-zh | 207 | 14202.11 ± 0.2% | not timed | not timed | 10020.08 ± 9.7% | 27.56 ± 0.7% | not timed | not timed | 14126.76 ± 0.5% | | 1.01 | 1.42 | 515.31 |
| 03-date/ascii | 111817 | 98.57 ± 0.7% | not timed | not timed | 77.53 ± 0.6% | 0.17 ± 4.6% | not timed | not timed | 97.59 ± 1.1% | | 1.01 | 1.27 | 570.11 |
| 04-ruff-noqa/real | 84 | 530.38 ± 0.4% | not timed | not timed | 395.57 ± 0.3% | 14.99 ± 1.7% | not timed | not timed | 532.66 ± 1.6% | | 1.00 | 1.34 | 35.39 |
| 04-ruff-noqa/tweaked | 44 | 469.77 ± 0.3% | not timed | not timed | 386.32 ± 0.6% | 285.31 ± 0.8% | not timed | not timed | 465.62 ± 0.7% | | 1.01 | 1.22 | 1.65 |
| 05-lexer-veryl/single | 124800 | 2.91 ± 0.8% | not timed | not timed | 4.13 ± 0.8% | 0.20 ± 5.1% | not timed | not timed | 2.78 ± 5.3% | | 1.05 | 0.70 | 14.24 |
| 06-cloud-flare-redos/original | 107 | 170.41 ± 0.3% | not timed | not timed | 173.83 ± 1.8% | 18.78 ± 10.3% | not timed | not timed | 170.29 ± 0.3% | | 1.00 | 0.98 | 9.07 |
| 06-cloud-flare-redos/simplified-short | 102 | 126.62 ± 0.7% | not timed | not timed | 183.13 ± 0.7% | 20.31 ± 7.9% | not timed | not timed | 126.44 ± 0.5% | | 1.00 | 0.69 | 6.23 |
| 06-cloud-flare-redos/simplified-long | 10000 | 131.59 ± 4.8% | not timed | not timed | 201.08 ± 0.3% | 22.77 ± 1.9% | not timed | not timed | 131.59 ± 4.4% | | 1.00 | 0.65 | 5.78 |
| 07-unicode-character-data/parse-line | 558784 | 190.70 ± 0.5% | not timed | not timed | 151.80 ± 10.3% | 35.73 ± 5.3% | not timed | not timed | 186.48 ± 2.1% | | 1.02 | 1.26 | 5.34 |
| 08-words/all-english | 56691 | 77.01 ± 2.4% | not timed | not timed | 64.37 ± 0.3% | 9.79 ± 5.7% | not timed | not timed | 76.28 ± 1.1% | | 1.01 | 1.20 | 7.86 |
| 08-words/long-english | 839 | 763.97 ± 0.4% | not timed | not timed | 452.63 ± 0.1% | 25.74 ± 12.4% | not timed | not timed | 761.80 ± 0.5% | | 1.00 | 1.69 | 29.68 |
| 09-aws-keys/full | 0 | 402.31 ± 0.2% | not timed | not timed | 407.28 ± 0.4% | 47.80 ± 2.0% | not timed | not timed | 401.35 ± 0.2% | | 1.00 | 0.99 | 8.42 |
| 09-aws-keys/quick | 0 | 731.42 ± 1.1% | not timed | not timed | 744.92 ± 1.3% | 302.76 ± 2.6% | not timed | not timed | 722.96 ± 1.3% | | 1.01 | 0.98 | 2.42 |
| 10-bounded-repeat/letters-en | 1833 | 487.08 ± 2.3% | not timed | not timed | 431.23 ± 4.5% | 17.65 ± 26.1% | not timed | not timed | 487.11 ± 0.4% | | 1.00 | 1.13 | 27.60 |
| 10-bounded-repeat/letters-ru | 3475 | 284.70 ± 0.6% | not timed | not timed | 372.72 ± 0.1% | 20.22 ± 16.1% | not timed | not timed | 282.10 ± 0.7% | | 1.01 | 0.76 | 14.08 |
| 10-bounded-repeat/context | 53 | 64.99 ± 3.1% | not timed | not timed | 54.74 ± 0.8% | 17.58 ± 0.6% | not timed | not timed | 63.91 ± 1.3% | | 1.02 | 1.19 | 3.70 |
| 10-bounded-repeat/capitals | 11 | 800.55 ± 0.8% | not timed | not timed | 468.46 ± 0.1% | 31.03 ± 0.7% | not timed | not timed | 796.94 ± 0.2% | | 1.00 | 1.71 | 25.80 |
| 11-unstructured-to-json/extract | 600 | 35.81 ± 0.4% | not timed | not timed | 62.92 ± 23.3% | 26.44 ± 21.9% | not timed | not timed | 35.82 ± 0.7% | | 1.00 | 0.57 | 1.35 |
| 12-dictionary/single | 1 | 394.05 ± 0.5% | not timed | not timed | 372.86 ± 0.5% | 0.31 ± 6.9% | not timed | not timed | 396.11 ± 0.2% | | 0.99 | 1.06 | 1286.09 |
| 14-quadratic/1x | 100 | 10.38 ± 0.7% | not timed | not timed | 9.45 ± 0.2% | 0.76 ± 2.7% | not timed | not timed | 10.21 ± 9.6% | | 1.02 | 1.10 | 13.72 |
| 14-quadratic/2x | 200 | 6.20 ± 11.1% | not timed | not timed | 4.75 ± 3.8% | 0.39 ± 2.3% | not timed | not timed | 6.13 ± 4.6% | | 1.01 | 1.31 | 16.07 |
| 14-quadratic/10x | 1000 | 1.42 ± 0.3% | not timed | not timed | 0.94 ± 0.1% | 0.09 ± 1.7% | not timed | not timed | 1.41 ± 3.3% | | 1.00 | 1.50 | 15.66 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 0.3% | not timed | not timed | 0.37 ± 0.6% | 0.49 ± 3.7% | not timed | not timed | 1.29 ± 8.9% | | 1.02 | 3.57 | 2.70 |
| 04-ruff-noqa/compile-real | 1 | 76.32 ± 0.6% | not timed | not timed | 13.36 ± 0.7% | 129.09 ± 2.6% | not timed | not timed | 75.78 ± 1.4% | | 1.01 | 5.71 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 12.96 ± 1.1% | not timed | not timed | 2.32 ± 0.8% | 6.01 ± 1.9% | not timed | not timed | 13.05 ± 0.7% | | 0.99 | 5.58 | 2.16 |
| 07-unicode-character-data/compile | 1 | 48.88 ± 0.3% | not timed | not timed | 23.90 ± 0.5% | 33.85 ± 1.8% | not timed | not timed | 48.91 ± 0.4% | | 1.00 | 2.04 | 1.44 |
| 09-aws-keys/compile-full | 1 | 34.57 ± 2.5% | not timed | not timed | 7.69 ± 0.8% | 21.14 ± 29.0% | not timed | not timed | 34.65 ± 1.2% | | 1.00 | 4.50 | 1.64 |
| 09-aws-keys/compile-quick | 1 | 153.94 ± 0.2% | not timed | not timed | 44.45 ± 1.4% | 119.66 ± 2.4% | not timed | not timed | 153.07 ± 1.6% | | 1.01 | 3.46 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 12.17 ± 0.1% | not timed | not timed | 11.31 ± 0.2% | 15.48 ± 18.9% | not timed | not timed | 12.14 ± 0.8% | | 1.00 | 1.08 | 0.79 |
| 10-bounded-repeat/compile-capitals | 1 | 73.72 ± 1.5% | not timed | not timed | 8.21 ± 0.2% | 22.51 ± 1.5% | not timed | not timed | 73.14 ± 21.4% | | 1.01 | 8.97 | 3.27 |
| 11-unstructured-to-json/compile | 1 | 75.83 ± 6.3% | not timed | not timed | 37.63 ± 11.3% | 61.32 ± 2.8% | not timed | not timed | 75.39 ± 1.2% | | 1.01 | 2.02 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.27 ± 0.9% | not timed | not timed | 0.06 ± 20.2% | 0.08 ± 15.0% | not timed | not timed | 0.27 ± 4.9% | | 1.01 | 4.19 | 3.20 |

