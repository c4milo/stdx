# bench-regex

| Field | Value |
|---|---|
| Commit | 822c457 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45024988951 |
| Date | 2026-11-22 |
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
| literal: a word | 217 | 29940.57 ± 0.5% | 872.36 ± 2.5% | 28.05 ± 1.5% | 26413.50 ± 0.4% | 8469.88 ± 4.6% | 12.14 ± 11.1% | 88.56 ± 0.6% | 29976.85 ± 2.3% | 34.32 | 1.00 | 1.13 | 3.53 |
| literal: a word that is not there | 0 | 40804.93 ± 0.3% | 937.82 ± 4.8% | 27.68 ± 1.8% | 29077.33 ± 0.4% | 23783.63 ± 0.5% | 11.87 ± 1.2% | 84.15 ± 0.7% | 40566.52 ± 0.4% | 43.51 | 1.01 | 1.40 | 1.72 |
| literal: one of four words | 661 | 7872.31 ± 0.8% | 832.12 ± 1.3% | 14.82 ± 0.5% | 8079.16 ± 1.3% | 20.54 ± 2.0% | 3.72 ± 0.6% | 6.64 ± 1.1% | 7830.48 ± 0.8% | 9.46 | 1.01 | 0.97 | 383.21 |
| literal: a word in any case | 217 | 24206.87 ± 2.3% | 870.73 ± 1.3% | 20.48 ± 4.2% | 8250.09 ± 0.6% | 41.52 ± 0.9% | refused | differs | 24077.08 ± 1.2% | 27.80 | 1.01 | 2.93 | 583.04 |
| literal: an href attribute | 33 | 31061.97 ± 0.5% | 892.59 ± 1.9% | 25.02 ± 1.9% | 23801.42 ± 0.5% | 1905.63 ± 1.6% | 8.89 ± 0.4% | 78.43 ± 0.4% | 31019.10 ± 2.7% | 34.80 | 1.00 | 1.31 | 16.30 |
| literal: a word, second text | 123 | 31188.67 ± 12.4% | 838.96 ± 1.5% | 27.31 ± 4.4% | 26057.17 ± 5.4% | 6495.60 ± 5.3% | 15.04 ± 0.3% | 76.64 ± 2.8% | 31225.96 ± 0.3% | 37.18 | 1.00 | 1.20 | 4.80 |
| class: two capitalized words | 1331 | 852.08 ± 0.5% | 773.79 ± 2.4% | 25.59 ± 0.7% | 548.71 ± 0.2% | 36.54 ± 7.5% | 10.36 ± 0.6% | 63.31 ± 0.3% | 850.53 ± 0.4% | 1.10 | 1.00 | 1.55 | 23.32 |
| class: a word that ends in ing | 3399 | 718.65 ± 2.8% | 717.28 ± 2.7% | 17.53 ± 0.3% | 513.68 ± 0.2% | 26.82 ± 32.0% | 5.82 ± 0.5% | 18.86 ± 0.5% | 731.86 ± 3.5% | 1.00 | 0.98 | 1.40 | 26.79 |
| class: a word in capitals | 2332 | 1129.70 ± 1.0% | 776.72 ± 3.2% | 26.93 ± 0.4% | 540.02 ± 0.2% | 39.12 ± 3.4% | 12.33 ± 0.3% | 83.58 ± 0.5% | 1132.29 ± 2.1% | 1.45 | 1.00 | 2.09 | 28.88 |
| class: a number | 8288 | 1693.56 ± 0.6% | 658.62 ± 1.9% | 26.66 ± 2.4% | 1677.44 ± 0.5% | 37.52 ± 13.7% | 0.36 ± 0.3% | 61.61 ± 0.2% | 1690.59 ± 0.4% | 2.57 | 1.00 | 1.01 | 45.14 |
| class: two capitalized words, second text | 5359 | 573.80 ± 1.1% | 579.76 ± 0.9% | 23.37 ± 1.4% | 451.30 ± 0.8% | 30.90 ± 11.4% | 13.05 ± 1.6% | 61.62 ± 0.1% | 576.56 ± 1.1% | 0.99 | 1.00 | 1.27 | 18.57 |
| other: a word between two words | 6104 | 751.39 ± 1.6% | 623.53 ± 1.0% | 22.90 ± 0.7% | 737.95 ± 0.4% | 99.29 ± 8.8% | 7.73 ± 0.3% | 70.11 ± 0.2% | 750.56 ± 0.3% | 1.21 | 1.00 | 1.02 | 7.57 |
| other: a number before a unit, second text | 1481 | 8125.16 ± 0.8% | 814.53 ± 4.6% | 24.19 ± 2.3% | 7205.80 ± 0.9% | 37.19 ± 0.6% | 13.82 ± 0.4% | 64.65 ± 5.3% | 7971.49 ± 2.7% | 9.98 | 1.02 | 1.13 | 218.45 |
| other: a heading's start tag | 110 | 19138.04 ± 1.7% | 837.53 ± 0.8% | 26.46 ± 0.1% | 2026.47 ± 0.4% | 1355.35 ± 6.3% | 10.85 ± 0.2% | 89.80 ± 0.4% | 19249.90 ± 1.2% | 22.85 | 0.99 | 9.44 | 14.12 |
| other: a whole word | 217 | 22730.95 ± 0.3% | 862.59 ± 2.2% | 29.04 ± 0.2% | 20102.78 ± 0.5% | 45.88 ± 0.9% | 10.48 ± 0.2% | 53.32 ± 0.4% | 22741.44 ± 0.3% | 26.35 | 1.00 | 1.13 | 495.42 |
| other: a line's first word, second text | 3716 | 2175.01 ± 1.2% | 719.18 ± 2.4% | 30.35 ± 2.4% | 1971.72 ± 0.9% | 59.26 ± 13.4% | refused | refused | 2159.70 ± 0.8% | 3.02 | 1.01 | 1.10 | 36.70 |
| other: fourteen octets before an x | 87 | 32593.05 ± 5.8% | 1.50 ± 1.2% | 1.47 ± 1.4% | 3602.50 ± 0.8% | 9.14 ± 0.3% | differs | 17.21 ± 3.9% | 32226.01 ± 1.3% | 21665.09 | 1.01 | 9.05 | 3564.05 |
| other: a Greek word | 21815 | 427.56 ± 2.6% | 278.42 ± 0.2% | 29.76 ± 3.7% | 264.92 ± 0.9% | 46.10 ± 20.9% | differs | refused | 427.33 ± 0.4% | 1.54 | 1.00 | 1.61 | 9.28 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.32 ± 2.2% | 25.28 ± 3.4% | 0.52 ± 2.3% | 23.68 ± 3.3% | 2.47 ± 0.6% | differs | 4.07 ± 0.1% | 25.19 ± 0.3% | 1.00 | 1.01 | 1.07 | 10.26 |
| a UUID | 32895 | 20.86 ± 1.0% | 20.98 ± 0.7% | 0.62 ± 0.8% | 19.51 ± 0.4% | 2.42 ± 0.4% | 0.54 ± 0.1% | 3.18 ± 0.8% | 20.52 ± 1.1% | 0.99 | 1.02 | 1.07 | 8.63 |
| an IPv4 address | 33176 | 35.25 ± 0.4% | 33.95 ± 0.3% | 2.04 ± 1.5% | 32.03 ± 0.2% | 5.87 ± 0.3% | differs | 3.88 ± 0.6% | 35.03 ± 0.5% | 1.04 | 1.01 | 1.10 | 6.01 |
| a date and time | 32954 | 30.54 ± 1.6% | 29.84 ± 0.9% | 1.45 ± 0.6% | 28.05 ± 0.6% | 7.02 ± 0.4% | 0.95 ± 0.2% | 7.38 ± 1.5% | 30.35 ± 0.9% | 1.02 | 1.01 | 1.09 | 4.35 |
| a field path | 32606 | 28.13 ± 0.3% | 28.16 ± 0.3% | 0.82 ± 4.3% | 25.69 ± 0.6% | 2.83 ± 0.3% | differs | 2.52 ± 0.3% | 28.14 ± 2.0% | 1.00 | 1.00 | 1.09 | 9.96 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.93 ± 0.8% | 8.91 ± 0.3% | 8.91 ± 0.3% | 11.59 ± 0.4% | 4.76 ± 1.4% | 0.77 ± 4.1% | none | 8.90 ± 0.6% | 1.00 | 1.00 | 0.77 | 1.88 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 289.73 ± 1.0% | 292.42 ± 0.2% | 343.81 ± 0.2% | 86.97 ± 3.4% | 181.90 ± 3.1% | 542.30 ± 2.9% | 3549.65 ± 4.7% | 290.43 ± 1.3% | 0.99 | 1.00 | 3.33 | 1.59 |
| a UUID | 62 | 211.44 ± 0.6% | 212.35 ± 0.3% | 240.91 ± 0.1% | 47.76 ± 0.6% | 88.25 ± 1.0% | 196.19 ± 2.4% | 4360.27 ± 0.7% | 211.69 ± 1.1% | 1.00 | 1.00 | 4.43 | 2.40 |
| an IPv4 address | 29 | 449.84 ± 0.1% | 453.96 ± 0.3% | 583.23 ± 0.6% | 75.55 ± 1.1% | 114.10 ± 2.8% | 325.33 ± 1.6% | 7452.36 ± 1.5% | 449.75 ± 0.5% | 0.99 | 1.00 | 5.95 | 3.94 |
| a date and time | 56 | 304.28 ± 0.2% | 306.64 ± 0.3% | 358.74 ± 0.1% | 73.81 ± 1.8% | 119.56 ± 2.3% | 354.26 ± 1.1% | 4548.84 ± 1.8% | 304.08 ± 0.3% | 0.99 | 1.00 | 4.12 | 2.54 |
| a field path | 39 | 336.26 ± 0.1% | 338.35 ± 0.2% | 403.79 ± 0.3% | 78.59 ± 2.3% | 171.60 ± 3.1% | 533.57 ± 0.8% | 4473.78 ± 0.6% | 336.13 ± 0.5% | 0.99 | 1.00 | 4.28 | 1.96 |
| literal: a word | 7 | 867.23 ± 0.3% | 906.11 ± 0.3% | 1471.64 ± 0.1% | 509.47 ± 1.1% | 549.83 ± 2.2% | 1215.84 ± 1.1% | 29743.43 ± 0.3% | 866.55 ± 0.3% | 0.96 | 1.00 | 1.70 | 1.58 |
| literal: a word that is not there | 8 | 821.40 ± 0.2% | 854.51 ± 0.4% | 1354.10 ± 0.2% | 468.86 ± 0.4% | 516.03 ± 20.1% | 1133.42 ± 1.5% | 28692.36 ± 0.6% | 820.76 ± 0.4% | 0.96 | 1.00 | 1.75 | 1.59 |
| literal: one of four words | 26 | 421.10 ± 0.2% | 464.07 ± 0.3% | 590.60 ± 0.5% | 43.90 ± 0.1% | 213.03 ± 1.5% | 435.75 ± 0.7% | 16419.85 ± 0.9% | 421.14 ± 0.2% | 0.91 | 1.00 | 9.59 | 1.98 |
| literal: a word in any case | 11 | 740.23 ± 0.3% | 780.59 ± 0.3% | 1214.28 ± 0.6% | 13.31 ± 0.8% | 562.01 ± 22.2% | refused | 22572.09 ± 0.7% | 739.75 ± 0.4% | 0.95 | 1.00 | 55.63 | 1.32 |
| literal: an href attribute | 12 | 405.26 ± 4.3% | 410.40 ± 4.5% | 512.87 ± 4.2% | 37.65 ± 4.9% | 414.70 ± 3.2% | 899.70 ± 0.8% | 21192.12 ± 0.4% | 404.83 ± 2.8% | 0.99 | 1.00 | 10.76 | 0.98 |
| literal: a word, second text | 10 | 758.92 ± 0.4% | 791.44 ± 0.4% | 1200.60 ± 0.3% | 425.36 ± 0.4% | 453.61 ± 1.2% | 955.64 ± 0.5% | 26688.82 ± 0.5% | 759.93 ± 0.3% | 0.96 | 1.00 | 1.78 | 1.67 |
| class: two capitalized words | 23 | 476.74 ± 0.3% | 490.35 ± 0.2% | 636.71 ± 0.6% | 105.18 ± 1.0% | 427.18 ± 4.4% | 867.87 ± 1.0% | 5731.17 ± 2.4% | 476.50 ± 0.8% | 0.97 | 1.00 | 4.53 | 1.12 |
| class: a word that ends in ing | 9 | 734.52 ± 0.5% | 780.56 ± 4.5% | 1191.79 ± 0.5% | 129.66 ± 1.1% | 617.89 ± 4.0% | 1317.97 ± 7.5% | 14626.25 ± 0.5% | 733.51 ± 4.4% | 0.94 | 1.00 | 5.67 | 1.19 |
| class: a word in capitals | 16 | 578.55 ± 0.3% | 597.78 ± 3.5% | 813.35 ± 0.5% | 136.02 ± 0.8% | 624.77 ± 1.1% | 1187.67 ± 5.7% | 7555.89 ± 0.3% | 578.54 ± 0.2% | 0.97 | 1.00 | 4.25 | 0.93 |
| class: a number | 6 | 838.47 ± 0.7% | 880.24 ± 0.3% | 1424.97 ± 3.6% | 36.55 ± 2.1% | 1144.27 ± 1.8% | 2179.81 ± 1.7% | 21664.88 ± 0.7% | 837.75 ± 0.3% | 0.95 | 1.00 | 22.94 | 0.73 |
| class: two capitalized words, second text | 23 | 477.07 ± 1.2% | 489.41 ± 1.6% | 636.30 ± 0.5% | 104.41 ± 1.5% | 422.88 ± 3.9% | 899.70 ± 0.6% | 5725.09 ± 0.7% | 476.29 ± 0.4% | 0.97 | 1.00 | 4.57 | 1.13 |
| other: a word between two words | 13 | 666.01 ± 7.2% | 676.78 ± 2.4% | 967.29 ± 0.4% | 132.68 ± 2.2% | 416.69 ± 14.6% | 981.98 ± 2.1% | 13751.99 ± 0.4% | 665.91 ± 0.3% | 0.98 | 1.00 | 5.02 | 1.60 |
| other: a number before a unit, second text | 15 | 565.49 ± 0.2% | 605.15 ± 1.9% | 833.59 ± 0.4% | 34.47 ± 0.7% | 517.82 ± 3.1% | 1035.69 ± 3.5% | 13869.33 ± 5.9% | 565.45 ± 0.4% | 0.93 | 1.00 | 16.41 | 1.09 |
| other: a heading's start tag | 13 | 393.34 ± 0.4% | 397.03 ± 0.2% | 494.76 ± 0.3% | 36.47 ± 4.3% | 518.99 ± 0.8% | 982.02 ± 5.1% | 16929.56 ± 0.9% | 393.34 ± 0.3% | 0.99 | 1.00 | 10.79 | 0.76 |
| other: a whole word | 11 | 753.24 ± 0.3% | 782.62 ± 4.8% | 1177.59 ± 0.3% | 119.80 ± 0.8% | 476.94 ± 4.4% | 1005.13 ± 1.0% | 26021.22 ± 0.6% | 751.98 ± 4.3% | 0.96 | 1.00 | 6.29 | 1.58 |
| other: a line's first word, second text | 17 | 628.26 ± 0.6% | 658.39 ± 1.1% | 944.90 ± 0.4% | 128.44 ± 0.6% | 586.28 ± 2.0% | refused | refused | 626.49 ± 1.5% | 0.95 | 1.00 | 4.89 | 1.07 |
| other: fourteen octets before an x | 16 | 107.11 ± 0.2% | 139.68 ± 0.4% | 162.52 ± 0.4% | 15.17 ± 0.4% | 380.26 ± 1.2% | 453.41 ± 0.5% | 11873.93 ± 1.5% | 107.12 ± 0.4% | 0.77 | 1.00 | 7.06 | 0.28 |
| other: a Greek word | 8 | 736.55 ± 2.0% | 791.61 ± 0.2% | 1249.17 ± 0.3% | 45.62 ± 0.4% | 1124.53 ± 2.4% | 2152.83 ± 2.0% | refused | 737.57 ± 2.0% | 0.93 | 1.00 | 16.14 | 0.65 |

