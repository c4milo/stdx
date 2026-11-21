# bench-regex

| Field | Value |
|---|---|
| Commit | 22f6bba |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44951172875 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache, `stdx, no skip` the same with claim R1 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 5309.99 ± 0.7% | 561.16 ± 0.1% | 28.83 ± 0.6% | 18654.49 ± 2.6% | 9189.82 ± 8.0% | 17.41 ± 0.2% | 86.32 ± 0.5% | 5310.70 ± 0.2% | 9.46 | 1.00 | 0.28 | 0.58 |
| literal: a word that is not there | 0 | 5368.72 ± 0.9% | 562.22 ± 0.4% | 29.07 ± 0.1% | 19841.39 ± 1.4% | 29235.67 ± 2.7% | 17.19 ± 0.1% | 80.94 ± 0.4% | 5389.80 ± 0.1% | 9.55 | 1.00 | 0.27 | 0.18 |
| literal: one of four words | 661 | 2488.66 ± 0.8% | 556.18 ± 0.2% | 15.12 ± 0.2% | 3979.77 ± 0.5% | 21.93 ± 0.1% | 5.43 ± 0.1% | 6.96 ± 0.1% | 2482.29 ± 0.6% | 4.47 | 1.00 | 0.63 | 113.49 |
| literal: a word in any case | 217 | 2706.71 ± 1.9% | 557.92 ± 0.8% | 22.02 ± 0.3% | 3981.91 ± 0.1% | 38.53 ± 0.5% | refused | differs | 2698.29 ± 0.6% | 4.85 | 1.00 | 0.68 | 70.24 |
| literal: an href attribute | 33 | 1613.45 ± 0.6% | 562.36 ± 0.1% | 27.77 ± 0.3% | 17154.78 ± 1.7% | 2265.24 ± 0.5% | 13.18 ± 0.3% | 75.60 ± 0.2% | 1610.55 ± 0.4% | 2.87 | 1.00 | 0.0941 | 0.71 |
| literal: a word, second text | 123 | 4109.02 ± 2.9% | 561.56 ± 0.1% | 28.55 ± 0.3% | 18583.21 ± 2.9% | 7515.00 ± 5.5% | 20.16 ± 1.0% | 71.04 ± 0.4% | 4089.57 ± 1.8% | 7.32 | 1.00 | 0.22 | 0.55 |
| class: two capitalized words | 1331 | 1157.86 ± 0.5% | 546.81 ± 0.1% | 26.45 ± 0.5% | 587.36 ± 0.1% | 40.93 ± 8.6% | 14.78 ± 0.3% | 68.06 ± 0.3% | 1158.37 ± 0.3% | 2.12 | 1.00 | 1.97 | 28.29 |
| class: a word that ends in ing | 3399 | 522.56 ± 0.3% | 523.21 ± 0.1% | 18.47 ± 0.2% | 550.37 ± 0.1% | 29.58 ± 5.8% | 8.20 ± 0.3% | 18.41 ± 0.2% | 522.72 ± 0.1% | 1.00 | 1.00 | 0.95 | 17.67 |
| class: a word in capitals | 2332 | 1504.55 ± 0.5% | 543.62 ± 0.1% | 28.01 ± 0.6% | 575.24 ± 0.1% | 43.79 ± 2.6% | 16.83 ± 0.4% | 83.31 ± 0.5% | 1500.91 ± 0.3% | 2.77 | 1.00 | 2.62 | 34.36 |
| class: a number | 8288 | 2195.90 ± 0.4% | 508.87 ± 0.0% | 28.37 ± 0.7% | 1798.52 ± 0.3% | 42.64 ± 15.6% | 0.55 ± 0.3% | 57.54 ± 0.2% | 2195.89 ± 0.3% | 4.32 | 1.00 | 1.22 | 51.50 |
| class: two capitalized words, second text | 5359 | 480.55 ± 0.2% | 479.85 ± 0.3% | 23.78 ± 0.3% | 488.43 ± 0.1% | 34.37 ± 12.2% | 17.01 ± 0.2% | 63.35 ± 0.2% | 480.37 ± 0.2% | 1.00 | 1.00 | 0.98 | 13.98 |
| other: a word between two words | 6104 | 484.09 ± 0.1% | 484.02 ± 0.0% | 23.89 ± 0.5% | 752.96 ± 0.1% | 108.90 ± 21.6% | 10.73 ± 0.2% | 69.52 ± 0.3% | 484.14 ± 0.0% | 1.00 | 1.00 | 0.64 | 4.45 |
| other: a number before a unit, second text | 1481 | 1430.49 ± 0.3% | 546.95 ± 0.1% | 26.51 ± 0.5% | 5956.82 ± 0.7% | 40.97 ± 8.4% | 18.04 ± 0.3% | 65.91 ± 0.2% | 1426.62 ± 0.4% | 2.62 | 1.00 | 0.24 | 34.91 |
| other: a heading's start tag | 110 | 1429.95 ± 0.3% | 559.61 ± 0.1% | 27.72 ± 0.5% | 1718.13 ± 0.2% | 1588.47 ± 3.3% | 16.10 ± 0.4% | 87.96 ± 0.3% | 1432.28 ± 0.5% | 2.56 | 1.00 | 0.83 | 0.90 |
| other: a whole word | 217 | 561.34 ± 0.1% | 561.29 ± 0.2% | 29.99 ± 0.4% | 14891.01 ± 0.9% | 49.25 ± 0.2% | 13.25 ± 0.1% | 55.21 ± 0.5% | 559.99 ± 0.8% | 1.00 | 1.00 | 0.0377 | 11.40 |
| other: a line's first word, second text | 3716 | 517.94 ± 0.5% | 518.27 ± 0.1% | 31.83 ± 0.6% | 1764.18 ± 0.2% | 63.46 ± 6.9% | refused | refused | 516.63 ± 0.3% | 1.00 | 1.00 | 0.29 | 8.16 |
| other: fourteen octets before an x | 87 | 1.54 ± 0.1% | 1.53 ± 0.2% | 1.54 ± 0.1% | 4050.44 ± 0.4% | 10.68 ± 0.2% | differs | 17.93 ± 0.2% | 1.53 ± 0.1% | 1.00 | 1.00 | 0.0004 | 0.14 |
| other: a Greek word | 21815 | 536.36 ± 0.4% | 355.03 ± 0.2% | 31.71 ± 0.3% | 294.20 ± 0.3% | 49.44 ± 12.4% | differs | refused | 538.10 ± 0.4% | 1.51 | 1.00 | 1.82 | 10.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.09 ± 0.1% | 20.09 ± 0.1% | 0.50 ± 0.2% | 21.64 ± 0.5% | 2.76 ± 1.1% | differs | 4.08 ± 0.1% | 20.07 ± 0.2% | 1.00 | 1.00 | 0.93 | 7.28 |
| a UUID | 32895 | 14.27 ± 0.3% | 14.24 ± 0.2% | 0.66 ± 0.3% | 16.13 ± 0.5% | 3.09 ± 0.4% | 0.73 ± 0.2% | 3.65 ± 0.9% | 14.24 ± 0.3% | 1.00 | 1.00 | 0.88 | 4.62 |
| an IPv4 address | 33176 | 34.73 ± 0.2% | 34.73 ± 0.2% | 2.16 ± 0.6% | 32.59 ± 0.2% | 6.69 ± 0.3% | differs | 4.22 ± 0.1% | 34.79 ± 0.5% | 1.00 | 1.00 | 1.07 | 5.19 |
| a date and time | 32954 | 23.85 ± 0.1% | 23.75 ± 0.2% | 1.50 ± 0.3% | 23.41 ± 0.5% | 7.08 ± 0.1% | 1.25 ± 0.5% | 7.16 ± 0.1% | 23.76 ± 0.2% | 1.00 | 1.00 | 1.02 | 3.37 |
| a field path | 32606 | 24.57 ± 0.1% | 24.59 ± 0.1% | 0.83 ± 0.2% | 25.36 ± 0.2% | 3.47 ± 0.5% | differs | 2.97 ± 0.1% | 24.56 ± 0.0% | 1.00 | 1.00 | 0.97 | 7.07 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.51 ± 0.6% | 2.46 ± 0.9% | 1.15 ± 0.2% | 11.58 ± 0.4% | 4.96 ± 1.6% | 0.94 ± 0.8% | none | 2.48 ± 0.7% | 1.02 | 1.01 | 0.22 | 0.51 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 255.51 ± 0.3% | 256.18 ± 0.5% | 333.11 ± 0.4% | 86.35 ± 1.7% | 224.64 ± 0.9% | 496.61 ± 2.3% | 3799.10 ± 1.9% | 255.64 ± 0.3% | 1.00 | 1.00 | 2.96 | 1.14 |
| a UUID | 62 | 192.76 ± 0.1% | 193.03 ± 0.2% | 240.28 ± 0.4% | 45.59 ± 0.4% | 100.63 ± 1.2% | 184.74 ± 2.0% | 4389.13 ± 1.7% | 192.83 ± 0.2% | 1.00 | 1.00 | 4.23 | 1.92 |
| an IPv4 address | 29 | 359.72 ± 0.5% | 360.46 ± 0.4% | 568.87 ± 0.4% | 75.75 ± 0.5% | 133.33 ± 1.0% | 294.99 ± 1.0% | 7656.22 ± 0.3% | 360.00 ± 0.5% | 1.00 | 1.00 | 4.75 | 2.70 |
| a date and time | 56 | 255.91 ± 0.4% | 256.68 ± 0.5% | 337.86 ± 0.2% | 71.37 ± 0.6% | 138.21 ± 10.8% | 316.81 ± 1.7% | 4968.59 ± 0.7% | 256.01 ± 0.3% | 1.00 | 1.00 | 3.59 | 1.85 |
| a field path | 39 | 275.32 ± 0.4% | 275.63 ± 0.1% | 383.98 ± 0.2% | 80.51 ± 0.2% | 207.71 ± 1.6% | 496.94 ± 0.6% | 4890.70 ± 1.1% | 275.86 ± 0.5% | 1.00 | 1.00 | 3.42 | 1.33 |
| literal: a word | 7 | 566.79 ± 0.1% | 568.28 ± 0.5% | 1394.10 ± 0.1% | 503.31 ± 2.0% | 637.27 ± 1.8% | 945.12 ± 0.7% | 30625.32 ± 0.2% | 566.47 ± 0.4% | 1.00 | 1.00 | 1.13 | 0.89 |
| literal: a word that is not there | 8 | 587.81 ± 0.7% | 588.11 ± 0.5% | 1314.15 ± 0.1% | 458.42 ± 0.2% | 609.83 ± 1.6% | 892.62 ± 0.2% | 29299.60 ± 0.1% | 588.02 ± 0.5% | 1.00 | 1.00 | 1.28 | 0.96 |
| literal: one of four words | 26 | 394.69 ± 0.7% | 395.87 ± 0.6% | 602.30 ± 0.4% | 49.27 ± 1.5% | 245.77 ± 2.0% | 360.95 ± 0.8% | 15982.40 ± 0.1% | 394.82 ± 0.6% | 1.00 | 1.00 | 8.01 | 1.61 |
| literal: a word in any case | 11 | 554.32 ± 0.4% | 556.51 ± 0.3% | 1114.01 ± 0.4% | 15.45 ± 0.3% | 653.62 ± 2.7% | refused | 23584.72 ± 0.4% | 555.24 ± 0.3% | 1.00 | 1.00 | 35.87 | 0.85 |
| literal: an href attribute | 12 | 358.52 ± 0.6% | 359.12 ± 0.7% | 517.72 ± 0.9% | 10.42 ± 25.3% | 506.28 ± 2.4% | 764.44 ± 0.5% | 22153.20 ± 0.2% | 359.22 ± 0.7% | 1.00 | 1.00 | 34.41 | 0.71 |
| literal: a word, second text | 10 | 558.48 ± 0.6% | 557.43 ± 0.3% | 1179.40 ± 0.1% | 408.94 ± 0.2% | 541.75 ± 2.1% | 789.94 ± 0.3% | 27278.94 ± 0.1% | 559.16 ± 0.3% | 1.00 | 1.00 | 1.37 | 1.03 |
| class: two capitalized words | 23 | 342.54 ± 0.3% | 342.44 ± 0.6% | 573.23 ± 0.9% | 100.79 ± 0.4% | 501.36 ± 6.7% | 733.74 ± 1.1% | 6499.15 ± 0.6% | 342.87 ± 0.4% | 1.00 | 1.00 | 3.40 | 0.68 |
| class: a word that ends in ing | 9 | 497.07 ± 0.3% | 497.87 ± 0.6% | 1100.70 ± 0.5% | 130.66 ± 1.6% | 758.36 ± 1.1% | 1103.46 ± 0.4% | 16153.63 ± 0.2% | 497.47 ± 0.6% | 1.00 | 1.00 | 3.80 | 0.66 |
| class: a word in capitals | 16 | 373.10 ± 0.3% | 373.24 ± 0.3% | 733.15 ± 0.3% | 133.77 ± 0.5% | 749.05 ± 4.4% | 1017.52 ± 0.4% | 8545.51 ± 1.0% | 373.31 ± 0.2% | 1.00 | 1.00 | 2.79 | 0.50 |
| class: a number | 6 | 475.14 ± 0.3% | 476.18 ± 0.2% | 1258.94 ± 0.1% | 41.51 ± 1.8% | 1398.80 ± 1.4% | 1854.56 ± 1.0% | 22949.70 ± 0.3% | 475.61 ± 0.2% | 1.00 | 1.00 | 11.45 | 0.34 |
| class: two capitalized words, second text | 23 | 342.45 ± 0.2% | 342.71 ± 0.3% | 573.35 ± 0.6% | 101.91 ± 0.4% | 505.05 ± 1.1% | 759.86 ± 1.1% | 6518.22 ± 0.9% | 342.40 ± 0.5% | 1.00 | 1.00 | 3.36 | 0.68 |
| other: a word between two words | 13 | 478.38 ± 0.4% | 479.18 ± 0.5% | 913.97 ± 0.2% | 131.95 ± 0.3% | 511.65 ± 1.9% | 786.98 ± 0.6% | 14949.66 ± 0.1% | 478.93 ± 0.6% | 1.00 | 1.00 | 3.63 | 0.93 |
| other: a number before a unit, second text | 15 | 428.52 ± 0.5% | 428.73 ± 0.5% | 782.71 ± 0.4% | 39.65 ± 0.7% | 636.54 ± 2.7% | 888.59 ± 0.7% | 15295.68 ± 0.3% | 428.96 ± 0.2% | 1.00 | 1.00 | 10.81 | 0.67 |
| other: a heading's start tag | 13 | 343.32 ± 0.7% | 344.22 ± 0.5% | 495.81 ± 0.8% | 11.81 ± 25.4% | 638.77 ± 1.4% | 866.99 ± 0.9% | 18379.84 ± 0.6% | 343.67 ± 0.3% | 1.00 | 1.00 | 29.08 | 0.54 |
| other: a whole word | 11 | 584.06 ± 0.3% | 584.15 ± 0.6% | 1200.82 ± 0.4% | 119.34 ± 0.8% | 570.05 ± 3.8% | 823.27 ± 0.8% | 27190.85 ± 0.7% | 584.23 ± 0.9% | 1.00 | 1.00 | 4.89 | 1.02 |
| other: a line's first word, second text | 17 | 461.52 ± 0.3% | 461.56 ± 0.2% | 870.21 ± 0.2% | 127.23 ± 0.3% | 707.08 ± 1.3% | refused | refused | 459.54 ± 0.5% | 1.00 | 1.00 | 3.63 | 0.65 |
| other: fourteen octets before an x | 16 | 145.83 ± 0.5% | 145.87 ± 0.7% | 174.13 ± 0.6% | 7.94 ± 24.7% | 455.72 ± 1.7% | 417.06 ± 0.6% | 12926.87 ± 0.4% | 145.66 ± 0.3% | 1.00 | 1.00 | 18.38 | 0.32 |
| other: a Greek word | 8 | 499.30 ± 0.7% | 499.38 ± 0.4% | 1234.91 ± 0.7% | 11.32 ± 4.4% | 1393.13 ± 1.5% | 1812.83 ± 0.7% | refused | 500.59 ± 0.6% | 1.00 | 1.00 | 44.11 | 0.36 |

