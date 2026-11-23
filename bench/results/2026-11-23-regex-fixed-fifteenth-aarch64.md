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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159324506 |
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
| literal: a word | 217 | 16008.92 ± 1.5% | 1048.13 ± 0.2% | 28.64 ± 0.3% | 18221.72 ± 2.1% | 9105.59 ± 9.2% | 17.33 ± 0.2% | 86.99 ± 0.2% | 16057.21 ± 1.1% | 15.27 | 1.00 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18688.13 ± 2.2% | 1055.98 ± 0.1% | 28.77 ± 0.5% | 19909.53 ± 3.4% | 29436.82 ± 2.3% | 17.07 ± 0.1% | 82.93 ± 0.0% | 18788.26 ± 1.6% | 17.70 | 0.99 | 0.94 | 0.63 |
| literal: one of four words | 661 | 6069.47 ± 0.5% | 1031.27 ± 0.1% | 14.70 ± 0.1% | 3939.06 ± 0.1% | 21.85 ± 0.1% | 5.42 ± 0.2% | 6.92 ± 0.5% | 6048.88 ± 0.8% | 5.89 | 1.00 | 1.54 | 277.80 |
| literal: a word in any case | 217 | 12597.26 ± 1.1% | 1047.24 ± 0.2% | 21.94 ± 2.0% | 3965.19 ± 0.2% | 38.06 ± 1.3% | refused | differs | 12553.73 ± 0.4% | 12.03 | 1.00 | 3.18 | 330.99 |
| literal: an href attribute | 33 | 13567.05 ± 1.0% | 1055.81 ± 0.3% | 27.35 ± 0.2% | 17095.85 ± 1.2% | 2252.57 ± 5.7% | 13.08 ± 0.3% | 75.72 ± 0.3% | 13565.39 ± 0.7% | 12.85 | 1.00 | 0.79 | 6.02 |
| literal: a word, second text | 123 | 16385.07 ± 1.3% | 1051.01 ± 0.4% | 28.20 ± 0.2% | 18428.98 ± 1.5% | 7695.32 ± 3.6% | 20.05 ± 0.4% | 71.16 ± 0.5% | 16409.38 ± 0.8% | 15.59 | 1.00 | 0.89 | 2.13 |
| class: two capitalized words | 1331 | 1122.51 ± 0.4% | 979.67 ± 0.2% | 26.03 ± 0.0% | 585.05 ± 0.0% | 40.52 ± 9.1% | 14.63 ± 0.3% | 69.05 ± 0.2% | 1121.78 ± 0.9% | 1.15 | 1.00 | 1.92 | 27.70 |
| class: a word that ends in ing | 3399 | 901.77 ± 0.3% | 901.54 ± 0.1% | 18.21 ± 0.1% | 547.27 ± 0.1% | 29.59 ± 0.5% | 8.18 ± 0.3% | 18.37 ± 1.1% | 900.66 ± 0.1% | 1.00 | 1.00 | 1.65 | 30.48 |
| class: a word in capitals | 2332 | 1461.43 ± 0.6% | 950.09 ± 0.1% | 27.73 ± 0.1% | 572.20 ± 0.0% | 43.52 ± 0.2% | 17.03 ± 0.3% | 83.16 ± 1.1% | 1459.70 ± 0.3% | 1.54 | 1.00 | 2.55 | 33.58 |
| class: a number | 8288 | 2003.92 ± 0.3% | 840.13 ± 0.0% | 27.88 ± 0.4% | 1718.28 ± 0.3% | 40.28 ± 11.8% | 0.55 ± 0.1% | 56.89 ± 0.3% | 1997.33 ± 0.2% | 2.39 | 1.00 | 1.17 | 49.74 |
| class: two capitalized words, second text | 5359 | 743.76 ± 0.0% | 745.59 ± 0.1% | 23.36 ± 0.2% | 484.75 ± 0.2% | 33.98 ± 11.9% | 17.07 ± 0.4% | 64.18 ± 0.1% | 744.75 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.89 |
| other: a word between two words | 6104 | 753.31 ± 0.2% | 780.47 ± 0.1% | 23.55 ± 0.2% | 737.20 ± 0.1% | 104.85 ± 10.9% | 11.12 ± 0.2% | 70.04 ± 0.1% | 750.51 ± 0.3% | 0.97 | 1.00 | 1.02 | 7.18 |
| other: a number before a unit, second text | 1481 | 5384.87 ± 0.3% | 991.80 ± 0.0% | 26.05 ± 0.3% | 5669.17 ± 0.4% | 40.68 ± 2.3% | 18.21 ± 0.2% | 67.10 ± 0.4% | 5393.84 ± 0.4% | 5.43 | 1.00 | 0.95 | 132.36 |
| other: a heading's start tag | 110 | 12594.14 ± 0.8% | 1044.53 ± 0.1% | 27.50 ± 0.2% | 1711.18 ± 0.2% | 1583.46 ± 1.4% | 16.09 ± 0.6% | 88.90 ± 0.5% | 12619.78 ± 0.9% | 12.06 | 1.00 | 7.36 | 7.95 |
| other: a whole word | 217 | 14032.82 ± 0.5% | 1046.53 ± 0.1% | 29.49 ± 0.5% | 14371.34 ± 1.0% | 49.40 ± 0.1% | 13.21 ± 0.2% | 56.31 ± 0.2% | 13979.69 ± 0.8% | 13.41 | 1.00 | 0.98 | 284.07 |
| other: a line's first word, second text | 3716 | 1962.84 ± 1.4% | 878.43 ± 0.3% | 31.18 ± 0.3% | 1724.25 ± 0.2% | 62.20 ± 8.1% | refused | refused | 1956.24 ± 0.8% | 2.23 | 1.00 | 1.14 | 31.56 |
| other: fourteen octets before an x | 87 | 19804.97 ± 2.0% | 243.10 ± 0.4% | 6.59 ± 0.1% | 3972.28 ± 0.4% | 10.65 ± 0.1% | differs | 17.83 ± 0.1% | 19736.36 ± 0.8% | 81.47 | 1.00 | 4.99 | 1859.97 |
| other: a Greek word | 21815 | 513.21 ± 0.5% | 414.35 ± 0.1% | 31.27 ± 0.5% | 289.19 ± 0.1% | 43.89 ± 11.0% | differs | refused | 510.41 ± 0.3% | 1.24 | 1.01 | 1.77 | 11.69 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.1% | 25.86 ± 0.1% | 0.87 ± 0.2% | 19.85 ± 0.3% | 2.77 ± 0.4% | differs | 4.03 ± 0.3% | 25.89 ± 0.1% | 1.00 | 1.00 | 1.30 | 9.32 |
| a UUID | 32895 | 21.04 ± 0.2% | 21.16 ± 0.2% | 0.65 ± 0.2% | 15.12 ± 0.4% | 3.09 ± 0.1% | 0.73 ± 0.2% | 3.62 ± 0.1% | 21.11 ± 0.2% | 0.99 | 1.00 | 1.39 | 6.80 |
| an IPv4 address | 33176 | 36.81 ± 0.2% | 36.76 ± 0.1% | 2.12 ± 0.3% | 29.15 ± 1.7% | 6.64 ± 0.2% | differs | 4.15 ± 0.6% | 36.64 ± 0.3% | 1.00 | 1.00 | 1.26 | 5.54 |
| a date and time | 32954 | 30.96 ± 0.1% | 31.02 ± 0.2% | 1.47 ± 0.3% | 21.51 ± 0.1% | 7.02 ± 0.3% | 1.25 ± 0.2% | 7.18 ± 0.3% | 30.96 ± 0.2% | 1.00 | 1.00 | 1.44 | 4.41 |
| a field path | 32606 | 29.44 ± 0.3% | 29.43 ± 0.1% | 1.04 ± 0.2% | 23.35 ± 0.6% | 3.45 ± 1.2% | differs | 2.97 ± 0.1% | 29.48 ± 0.3% | 1.00 | 1.00 | 1.26 | 8.53 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.4% | 11.47 ± 0.4% | 11.53 ± 0.4% | 11.83 ± 0.1% | 4.92 ± 1.6% | 0.93 ± 0.5% | none | 11.50 ± 0.4% | 1.00 | 1.00 | 0.97 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.68 ± 0.3% | 236.46 ± 0.3% | 286.23 ± 0.2% | 86.32 ± 0.6% | 215.23 ± 3.3% | 484.05 ± 0.7% | 3839.68 ± 2.3% | 234.46 ± 0.2% | 0.99 | 1.00 | 2.72 | 1.09 |
| a UUID | 62 | 157.20 ± 0.5% | 157.48 ± 0.1% | 178.49 ± 0.1% | 46.32 ± 0.5% | 97.41 ± 1.3% | 188.79 ± 2.9% | 4417.46 ± 1.0% | 157.07 ± 0.2% | 1.00 | 1.00 | 3.39 | 1.61 |
| an IPv4 address | 29 | 420.47 ± 0.5% | 426.22 ± 0.3% | 611.42 ± 0.8% | 76.52 ± 0.3% | 126.62 ± 1.5% | 300.33 ± 1.4% | 7649.13 ± 0.5% | 420.03 ± 0.5% | 0.99 | 1.00 | 5.50 | 3.32 |
| a date and time | 56 | 304.23 ± 0.3% | 307.50 ± 0.4% | 392.68 ± 0.1% | 72.53 ± 0.2% | 132.98 ± 1.1% | 329.34 ± 2.4% | 4921.38 ± 0.7% | 303.93 ± 0.3% | 0.99 | 1.00 | 4.19 | 2.29 |
| a field path | 39 | 227.19 ± 0.5% | 228.98 ± 0.3% | 273.72 ± 0.2% | 80.42 ± 0.7% | 198.90 ± 3.5% | 506.20 ± 5.2% | 4962.30 ± 4.3% | 227.08 ± 0.1% | 0.99 | 1.00 | 2.83 | 1.14 |
| literal: a word | 7 | 626.36 ± 0.1% | 670.31 ± 0.1% | 1238.66 ± 0.1% | 506.58 ± 0.2% | 610.19 ± 1.6% | 955.63 ± 0.7% | 30352.60 ± 0.2% | 624.94 ± 0.3% | 0.93 | 1.00 | 1.24 | 1.03 |
| literal: a word that is not there | 8 | 598.69 ± 0.4% | 646.71 ± 0.9% | 1160.05 ± 0.8% | 455.43 ± 0.4% | 586.61 ± 4.1% | 907.14 ± 0.4% | 29068.35 ± 0.2% | 598.81 ± 0.3% | 0.93 | 1.00 | 1.31 | 1.02 |
| literal: one of four words | 26 | 240.23 ± 0.8% | 398.02 ± 0.3% | 553.84 ± 0.2% | 50.35 ± 0.8% | 235.53 ± 2.2% | 384.00 ± 1.2% | 15649.82 ± 0.6% | 240.12 ± 0.1% | 0.60 | 1.00 | 4.77 | 1.02 |
| literal: a word in any case | 11 | 482.30 ± 0.3% | 515.61 ± 0.3% | 825.39 ± 0.6% | 15.76 ± 1.6% | 632.43 ± 2.9% | refused | 23759.25 ± 0.6% | 482.23 ± 0.3% | 0.94 | 1.00 | 30.60 | 0.76 |
| literal: an href attribute | 12 | 347.10 ± 0.4% | 360.29 ± 0.6% | 485.58 ± 0.4% | 44.78 ± 0.5% | 492.88 ± 0.9% | 789.81 ± 1.0% | 21665.69 ± 0.1% | 347.23 ± 0.4% | 0.96 | 1.00 | 7.75 | 0.70 |
| literal: a word, second text | 10 | 562.59 ± 0.2% | 616.49 ± 0.2% | 1057.79 ± 0.1% | 388.72 ± 0.2% | 528.49 ± 1.6% | 819.14 ± 0.8% | 26987.63 ± 0.2% | 562.20 ± 0.3% | 0.91 | 1.00 | 1.45 | 1.06 |
| class: two capitalized words | 23 | 436.20 ± 0.5% | 465.32 ± 0.4% | 693.72 ± 0.3% | 100.11 ± 0.3% | 486.14 ± 1.4% | 746.79 ± 0.4% | 6606.78 ± 0.2% | 435.75 ± 0.4% | 0.94 | 1.00 | 4.36 | 0.90 |
| class: a word that ends in ing | 9 | 563.56 ± 0.4% | 631.35 ± 0.6% | 1151.47 ± 1.9% | 130.81 ± 3.7% | 747.01 ± 7.4% | 1124.36 ± 0.6% | 16133.19 ± 0.1% | 562.74 ± 0.3% | 0.89 | 1.00 | 4.31 | 0.75 |
| class: a word in capitals | 16 | 499.85 ± 0.1% | 537.60 ± 0.3% | 893.59 ± 0.2% | 135.36 ± 0.6% | 739.85 ± 2.5% | 1040.37 ± 1.6% | 8678.87 ± 0.2% | 499.95 ± 0.2% | 0.93 | 1.00 | 3.69 | 0.68 |
| class: a number | 6 | 628.75 ± 0.2% | 694.22 ± 0.8% | 1366.02 ± 0.1% | 41.41 ± 0.9% | 1377.58 ± 2.2% | 1871.38 ± 1.3% | 22848.54 ± 0.1% | 628.89 ± 0.2% | 0.91 | 1.00 | 15.18 | 0.46 |
| class: two capitalized words, second text | 23 | 436.24 ± 0.3% | 465.21 ± 0.3% | 694.05 ± 0.2% | 101.47 ± 0.7% | 488.92 ± 1.5% | 769.15 ± 0.6% | 6603.43 ± 0.4% | 436.41 ± 0.3% | 0.94 | 1.00 | 4.30 | 0.89 |
| other: a word between two words | 13 | 545.79 ± 0.3% | 562.42 ± 0.2% | 922.22 ± 0.1% | 132.87 ± 0.4% | 494.05 ± 2.2% | 823.38 ± 0.8% | 14979.36 ± 0.1% | 545.80 ± 0.2% | 0.97 | 1.00 | 4.11 | 1.10 |
| other: a number before a unit, second text | 15 | 406.93 ± 0.3% | 446.77 ± 0.3% | 647.86 ± 0.2% | 39.11 ± 0.5% | 622.41 ± 2.3% | 905.67 ± 0.5% | 15205.44 ± 0.3% | 407.11 ± 0.1% | 0.91 | 1.00 | 10.40 | 0.65 |
| other: a heading's start tag | 13 | 358.88 ± 0.4% | 364.47 ± 0.3% | 493.82 ± 0.3% | 43.67 ± 0.8% | 614.14 ± 1.4% | 866.47 ± 0.3% | 18106.31 ± 0.1% | 358.13 ± 0.3% | 0.98 | 1.00 | 8.22 | 0.58 |
| other: a whole word | 11 | 582.73 ± 0.3% | 617.12 ± 0.4% | 1067.03 ± 0.1% | 117.56 ± 0.3% | 549.40 ± 5.4% | 831.41 ± 1.1% | 26913.79 ± 0.5% | 582.91 ± 0.2% | 0.94 | 1.00 | 4.96 | 1.06 |
| other: a line's first word, second text | 17 | 535.40 ± 0.3% | 555.20 ± 0.5% | 931.84 ± 0.5% | 130.13 ± 0.3% | 693.95 ± 0.9% | refused | refused | 533.97 ± 1.2% | 0.96 | 1.00 | 4.11 | 0.77 |
| other: fourteen octets before an x | 16 | 111.87 ± 0.4% | 162.86 ± 0.9% | 190.64 ± 0.6% | 14.99 ± 0.7% | 442.59 ± 5.8% | 418.18 ± 1.4% | 12698.20 ± 0.5% | 111.70 ± 0.3% | 0.69 | 1.00 | 7.46 | 0.25 |
| other: a Greek word | 8 | 431.45 ± 0.2% | 594.93 ± 0.2% | 1042.63 ± 0.1% | 58.78 ± 0.6% | 1361.81 ± 1.9% | 1813.45 ± 0.4% | refused | 431.39 ± 0.2% | 0.73 | 1.00 | 7.34 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12892.57 ± 0.1% | not timed | not timed | 16308.65 ± 0.8% | 1958.85 ± 14.6% | not timed | not timed | 12882.52 ± 0.5% | | 1.00 | 0.79 | 6.58 |
| 01-literal/sherlock-casei-en | 522 | 4459.60 ± 0.8% | not timed | not timed | 3589.58 ± 0.5% | 32.55 ± 0.2% | not timed | not timed | 4472.55 ± 0.4% | | 1.00 | 1.24 | 136.99 |
| 01-literal/sherlock-ru | 724 | 13516.66 ± 0.5% | not timed | not timed | 17326.29 ± 0.2% | 1364.32 ± 10.2% | not timed | not timed | 13488.71 ± 0.4% | | 1.00 | 0.78 | 9.91 |
| 01-literal/sherlock-casei-ru | 746 | 5280.93 ± 0.6% | not timed | not timed | 3330.38 ± 0.1% | 31.79 ± 0.3% | not timed | not timed | 5287.21 ± 0.5% | | 1.00 | 1.59 | 166.14 |
| 01-literal/sherlock-zh | 30 | 17096.23 ± 0.4% | not timed | not timed | 18648.22 ± 1.1% | 2767.24 ± 9.5% | not timed | not timed | 17069.69 ± 0.4% | | 1.00 | 0.92 | 6.18 |
| 02-literal-alternate/sherlock-en | 714 | 5761.77 ± 0.3% | not timed | not timed | 3935.39 ± 0.3% | 16.59 ± 0.2% | not timed | not timed | 5760.79 ± 0.1% | | 1.00 | 1.46 | 347.32 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1710.48 ± 1.1% | not timed | not timed | 697.59 ± 0.2% | 10.83 ± 11.1% | not timed | not timed | 1703.62 ± 0.9% | | 1.00 | 2.45 | 157.93 |
| 02-literal-alternate/sherlock-ru | 899 | 4653.03 ± 0.3% | not timed | not timed | 3253.59 ± 0.1% | 22.63 ± 0.1% | not timed | not timed | 4656.07 ± 0.4% | | 1.00 | 1.43 | 205.58 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1808.48 ± 0.7% | not timed | not timed | 1227.25 ± 0.4% | 9.15 ± 0.4% | not timed | not timed | 1803.18 ± 0.1% | | 1.00 | 1.47 | 197.75 |
| 02-literal-alternate/sherlock-zh | 207 | 7054.12 ± 0.6% | not timed | not timed | 4161.75 ± 0.2% | 31.53 ± 0.1% | not timed | not timed | 7055.41 ± 0.4% | | 1.00 | 1.69 | 223.75 |
| 03-date/ascii | 111817 | 126.73 ± 1.0% | not timed | not timed | 96.32 ± 0.2% | 0.20 ± 4.8% | not timed | not timed | 125.91 ± 0.5% | | 1.01 | 1.32 | 625.00 |
| 04-ruff-noqa/real | 84 | 555.64 ± 0.5% | not timed | not timed | 458.93 ± 0.1% | 19.67 ± 1.2% | not timed | not timed | 555.39 ± 0.1% | | 1.00 | 1.21 | 28.25 |
| 04-ruff-noqa/tweaked | 44 | 543.00 ± 0.0% | not timed | not timed | 461.89 ± 0.1% | 366.91 ± 0.4% | not timed | not timed | 542.02 ± 0.1% | | 1.00 | 1.18 | 1.48 |
| 05-lexer-veryl/single | 124800 | 4.21 ± 0.4% | not timed | not timed | 5.25 ± 0.3% | 0.20 ± 3.8% | not timed | not timed | 4.20 ± 3.4% | | 1.00 | 0.80 | 20.85 |
| 06-cloud-flare-redos/original | 107 | 260.39 ± 0.2% | not timed | not timed | 215.64 ± 0.1% | 24.91 ± 0.4% | not timed | not timed | 259.96 ± 0.1% | | 1.00 | 1.21 | 10.46 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.07 ± 0.1% | not timed | not timed | 226.84 ± 0.1% | 26.61 ± 0.2% | not timed | not timed | 254.62 ± 0.2% | | 1.00 | 1.12 | 9.59 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.76 ± 0.1% | not timed | not timed | 255.37 ± 0.1% | 28.71 ± 0.1% | not timed | not timed | 292.28 ± 0.1% | | 1.00 | 1.14 | 10.16 |
| 07-unicode-character-data/parse-line | 558784 | 234.55 ± 7.8% | not timed | not timed | 178.06 ± 0.1% | 42.78 ± 6.2% | not timed | not timed | 230.10 ± 2.3% | | 1.02 | 1.32 | 5.48 |
| 08-words/all-english | 56691 | 121.67 ± 0.2% | not timed | not timed | 83.16 ± 0.1% | 12.84 ± 12.9% | not timed | not timed | 121.13 ± 0.7% | | 1.00 | 1.46 | 9.48 |
| 08-words/long-english | 839 | 1011.36 ± 0.1% | not timed | not timed | 597.85 ± 0.2% | 32.37 ± 0.4% | not timed | not timed | 1011.75 ± 0.3% | | 1.00 | 1.69 | 31.24 |
| 09-aws-keys/full | 0 | 408.90 ± 0.3% | not timed | not timed | 476.98 ± 0.5% | 64.50 ± 5.3% | not timed | not timed | 408.41 ± 0.1% | | 1.00 | 0.86 | 6.34 |
| 09-aws-keys/quick | 0 | 744.97 ± 0.1% | not timed | not timed | 1001.45 ± 0.3% | 416.27 ± 1.2% | not timed | not timed | 743.65 ± 0.1% | | 1.00 | 0.74 | 1.79 |
| 10-bounded-repeat/letters-en | 1833 | 636.57 ± 0.4% | not timed | not timed | 516.05 ± 0.7% | 19.52 ± 0.5% | not timed | not timed | 634.31 ± 0.2% | | 1.00 | 1.23 | 32.62 |
| 10-bounded-repeat/letters-ru | 3475 | 382.16 ± 0.3% | not timed | not timed | 478.16 ± 0.1% | 21.59 ± 8.9% | not timed | not timed | 380.80 ± 0.6% | | 1.00 | 0.80 | 17.70 |
| 10-bounded-repeat/context | 53 | 79.78 ± 1.3% | not timed | not timed | 65.94 ± 0.9% | 19.81 ± 0.1% | not timed | not timed | 79.62 ± 0.8% | | 1.00 | 1.21 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 1056.04 ± 0.1% | not timed | not timed | 616.64 ± 0.1% | 36.54 ± 0.2% | not timed | not timed | 1054.82 ± 0.1% | | 1.00 | 1.71 | 28.90 |
| 11-unstructured-to-json/extract | 600 | 49.40 ± 0.1% | not timed | not timed | 76.45 ± 0.1% | 48.87 ± 0.8% | not timed | not timed | 48.54 ± 0.9% | | 1.02 | 0.65 | 1.01 |
| 12-dictionary/single | 1 | 567.19 ± 0.4% | not timed | not timed | 560.36 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 568.75 ± 0.3% | | 1.00 | 1.01 | 1411.11 |
| 14-quadratic/1x | 100 | 12.80 ± 0.4% | not timed | not timed | 10.14 ± 0.1% | 0.96 ± 3.0% | not timed | not timed | 12.71 ± 1.5% | | 1.01 | 1.26 | 13.32 |
| 14-quadratic/2x | 200 | 7.95 ± 0.2% | not timed | not timed | 5.57 ± 0.2% | 0.53 ± 2.1% | not timed | not timed | 7.89 ± 0.7% | | 1.01 | 1.43 | 14.98 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.4% | not timed | not timed | 1.21 ± 0.3% | 0.12 ± 0.8% | not timed | not timed | 1.88 ± 1.0% | | 1.00 | 1.55 | 16.35 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 1.1% | 0.54 ± 2.2% | not timed | not timed | 1.44 ± 1.2% | | 1.00 | 4.24 | 2.69 |
| 04-ruff-noqa/compile-real | 1 | 92.87 ± 0.2% | not timed | not timed | 13.98 ± 0.4% | 136.64 ± 2.9% | not timed | not timed | 92.96 ± 1.0% | | 1.00 | 6.65 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 14.67 ± 1.8% | not timed | not timed | 2.53 ± 0.3% | 6.35 ± 2.9% | not timed | not timed | 14.49 ± 1.8% | | 1.01 | 5.79 | 2.31 |
| 07-unicode-character-data/compile | 1 | 58.31 ± 0.2% | not timed | not timed | 26.14 ± 0.2% | 35.19 ± 3.2% | not timed | not timed | 58.06 ± 1.2% | | 1.00 | 2.23 | 1.66 |
| 09-aws-keys/compile-full | 1 | 43.76 ± 0.2% | not timed | not timed | 8.33 ± 1.2% | 22.93 ± 20.5% | not timed | not timed | 43.56 ± 0.8% | | 1.00 | 5.25 | 1.91 |
| 09-aws-keys/compile-quick | 1 | 187.78 ± 0.1% | not timed | not timed | 48.49 ± 0.9% | 131.49 ± 21.7% | not timed | not timed | 189.14 ± 1.3% | | 0.99 | 3.87 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.70 ± 0.6% | not timed | not timed | 11.24 ± 0.2% | 15.79 ± 2.0% | not timed | not timed | 14.54 ± 2.2% | | 1.01 | 1.31 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 86.00 ± 0.5% | not timed | not timed | 8.17 ± 0.2% | 23.50 ± 2.9% | not timed | not timed | 85.79 ± 0.3% | | 1.00 | 10.53 | 3.66 |
| 11-unstructured-to-json/compile | 1 | 90.82 ± 0.1% | not timed | not timed | 40.93 ± 0.3% | 67.47 ± 2.6% | not timed | not timed | 90.78 ± 0.7% | | 1.00 | 2.22 | 1.35 |
| 12-dictionary/compile-single | 1 | 0.36 ± 2.3% | not timed | not timed | 0.07 ± 1.0% | 0.10 ± 12.4% | not timed | not timed | 0.36 ± 1.5% | | 1.01 | 5.39 | 3.78 |

