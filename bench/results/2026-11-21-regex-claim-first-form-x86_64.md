# bench-regex

| Field | Value |
|---|---|
| Commit | c65ceab |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44943142279 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache, `stdx, no skip` the same with claim R1 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed.

The patterns of the search table:

- prose: a word, in canterbury-large/bible.txt: `Pharaoh`
- prose: a word that is not there, in canterbury-large/bible.txt: `Sherlock`
- prose: one of four words, in canterbury-large/bible.txt: `Abraham|Isaac|Jacob|Joseph`
- prose: a word in any case, in canterbury-large/bible.txt: `(?i)pharaoh`
- prose: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- prose: two capitalized words, in canterbury-large/bible.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- prose: a word that ends in ing, in canterbury-large/bible.txt: `[a-z]+ing`
- prose: a word in capitals, in canterbury-large/bible.txt: `[A-Z][A-Z][A-Z]+`
- markup: an href attribute, in http/html-1m: `href="[^"]*"`
- markup: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- markup: a number, in http/html-1m: `[0-9]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| prose: a word | 217 | 3813.76 ± 2.9% | 438.46 ± 0.2% | 26.71 ± 0.4% | 26133.70 ± 0.6% | 8599.51 ± 7.0% | 12.29 ± 0.9% | 89.74 ± 0.8% | 8.70 | 0.15 | 0.44 |
| prose: a word that is not there | 0 | 3837.93 ± 0.3% | 441.01 ± 1.7% | 26.69 ± 1.6% | 28842.26 ± 0.1% | 23445.90 ± 0.5% | 12.03 ± 1.1% | 85.38 ± 1.1% | 8.70 | 0.13 | 0.16 |
| prose: one of four words | 661 | 1880.32 ± 2.1% | 433.21 ± 0.2% | 13.84 ± 0.9% | 8084.73 ± 1.2% | 20.36 ± 0.5% | 3.75 ± 0.2% | 5.90 ± 0.1% | 4.34 | 0.23 | 92.35 |
| prose: a word in any case | 217 | 2107.82 ± 1.1% | 438.74 ± 0.6% | 19.39 ± 1.1% | 8627.33 ± 0.8% | 40.63 ± 3.1% | refused | differs | 4.80 | 0.24 | 51.88 |
| prose: a word between two words | 6104 | 360.69 ± 0.9% | 361.12 ± 0.9% | 22.02 ± 1.2% | 869.82 ± 0.2% | 100.69 ± 12.2% | 8.03 ± 0.0% | 70.30 ± 0.7% | 1.00 | 0.41 | 3.58 |
| prose: two capitalized words | 1331 | 832.15 ± 0.6% | 421.57 ± 0.1% | 24.23 ± 0.2% | 562.90 ± 0.4% | 36.79 ± 6.3% | 10.56 ± 0.4% | 65.71 ± 0.5% | 1.97 | 1.48 | 22.62 |
| prose: a word that ends in ing | 3399 | 396.35 ± 0.4% | 396.17 ± 0.2% | 16.96 ± 3.7% | 551.32 ± 0.3% | 27.29 ± 33.4% | 5.85 ± 0.2% | 18.68 ± 1.4% | 1.00 | 0.72 | 14.52 |
| prose: a word in capitals | 2332 | 1135.42 ± 1.3% | 417.31 ± 0.4% | 26.07 ± 1.3% | 559.30 ± 0.2% | 39.41 ± 2.1% | 12.50 ± 0.8% | 81.63 ± 0.8% | 2.72 | 2.03 | 28.81 |
| markup: an href attribute | 33 | 1248.72 ± 0.4% | 440.05 ± 0.3% | 23.96 ± 0.2% | 25226.70 ± 0.7% | 1949.08 ± 0.3% | 8.99 ± 0.6% | 79.58 ± 0.2% | 2.84 | 0.05 | 0.64 |
| markup: a heading's start tag | 110 | 1096.30 ± 1.0% | 438.01 ± 0.5% | 25.40 ± 0.7% | 2058.21 ± 0.2% | 1362.98 ± 5.0% | 11.00 ± 0.6% | 91.43 ± 0.8% | 2.50 | 0.53 | 0.80 |
| markup: a number | 8288 | 1542.43 ± 0.2% | 378.29 ± 0.3% | 25.72 ± 2.0% | 2244.26 ± 0.5% | 40.59 ± 9.5% | 0.36 ± 0.7% | 59.05 ± 0.6% | 4.08 | 0.69 | 38.00 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 15.25 ± 6.9% | 15.08 ± 7.3% | 0.49 ± 0.3% | 21.45 ± 1.8% | 2.39 ± 0.6% | differs | 4.08 ± 3.3% | 1.01 | 0.71 | 6.37 |
| a UUID | 512 | 12.52 ± 0.2% | 12.12 ± 0.2% | 0.62 ± 0.5% | 13.19 ± 0.1% | 2.46 ± 0.4% | 0.53 ± 0.5% | 3.00 ± 1.9% | 1.03 | 0.95 | 5.10 |
| an IPv4 address | 512 | 29.67 ± 9.7% | 30.52 ± 8.5% | 2.02 ± 0.5% | 38.93 ± 0.7% | 5.88 ± 0.5% | differs | 3.85 ± 0.3% | 0.97 | 0.76 | 5.05 |
| a date and time | 512 | 21.28 ± 0.3% | 20.74 ± 0.5% | 1.44 ± 3.1% | 26.21 ± 0.5% | 6.86 ± 0.6% | 0.93 ± 0.2% | 7.05 ± 0.5% | 1.03 | 0.81 | 3.10 |
| a field path | 512 | 18.46 ± 7.7% | 18.30 ± 7.8% | 0.80 ± 0.3% | 27.49 ± 7.5% | 2.88 ± 0.3% | differs | 2.60 ± 1.2% | 1.01 | 0.67 | 6.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.07 ± 0.3% | 2.03 ± 4.0% | 0.99 ± 0.3% | 10.85 ± 0.4% | 4.61 ± 4.9% | 0.76 ± 0.8% | none | 1.02 | 0.19 | 0.45 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.84 ± 0.2% | 235.56 ± 0.3% | 339.83 ± 5.1% | 86.14 ± 1.6% | 180.66 ± 5.1% | 517.66 ± 3.8% | 3481.70 ± 1.7% | 1.00 | 2.73 | 1.30 |
| a UUID | 62 | 164.80 ± 2.1% | 165.55 ± 0.3% | 236.97 ± 0.3% | 47.26 ± 2.5% | 87.05 ± 1.2% | 186.60 ± 1.4% | 4289.81 ± 0.3% | 1.00 | 3.49 | 1.89 |
| an IPv4 address | 29 | 306.32 ± 0.3% | 307.47 ± 0.3% | 592.54 ± 0.9% | 75.01 ± 1.2% | 110.51 ± 1.8% | 327.19 ± 0.7% | 7156.67 ± 3.7% | 1.00 | 4.08 | 2.77 |
| a date and time | 56 | 228.59 ± 0.5% | 229.56 ± 0.3% | 352.36 ± 0.4% | 72.30 ± 0.6% | 117.94 ± 2.1% | 340.18 ± 6.1% | 4234.89 ± 12.6% | 1.00 | 3.16 | 1.94 |
| a field path | 39 | 241.11 ± 3.5% | 241.91 ± 0.3% | 401.43 ± 1.3% | 80.16 ± 0.8% | 170.88 ± 1.0% | 561.42 ± 1.6% | 4349.05 ± 0.3% | 1.00 | 3.01 | 1.41 |
| prose: a word | 7 | 427.82 ± 0.1% | 430.95 ± 2.5% | 1450.52 ± 0.2% | 557.43 ± 1.4% | 543.54 ± 4.1% | 1191.61 ± 0.9% | 27402.08 ± 2.4% | 0.99 | 0.77 | 0.79 |
| prose: a word that is not there | 8 | 453.25 ± 0.6% | 455.70 ± 0.9% | 1333.00 ± 0.4% | 503.22 ± 0.4% | 521.28 ± 2.1% | 1112.78 ± 0.9% | 26037.85 ± 2.4% | 0.99 | 0.90 | 0.87 |
| prose: one of four words | 26 | 335.68 ± 0.6% | 337.23 ± 0.7% | 575.35 ± 0.1% | 44.13 ± 1.2% | 210.43 ± 2.9% | 418.61 ± 0.4% | 13705.08 ± 0.8% | 1.00 | 7.61 | 1.60 |
| prose: a word in any case | 11 | 455.46 ± 0.4% | 456.86 ± 0.7% | 1188.56 ± 0.5% | 13.35 ± 1.3% | 561.86 ± 1.5% | refused | 19994.10 ± 2.1% | 1.00 | 34.11 | 0.81 |
| prose: a word between two words | 13 | 379.26 ± 0.5% | 381.58 ± 0.4% | 946.14 ± 0.4% | 138.42 ± 0.6% | 424.56 ± 3.5% | 956.60 ± 1.1% | 13114.59 ± 0.2% | 0.99 | 2.74 | 0.89 |
| prose: two capitalized words | 23 | 271.41 ± 0.3% | 272.37 ± 0.1% | 616.70 ± 1.0% | 101.19 ± 0.8% | 428.61 ± 1.7% | 875.41 ± 3.3% | 5636.10 ± 0.6% | 1.00 | 2.68 | 0.63 |
| prose: a word that ends in ing | 9 | 373.03 ± 0.6% | 374.75 ± 1.1% | 1164.59 ± 1.0% | 130.13 ± 1.0% | 619.15 ± 1.7% | 1350.67 ± 0.4% | 14371.09 ± 0.9% | 1.00 | 2.87 | 0.60 |
| prose: a word in capitals | 16 | 244.59 ± 0.3% | 244.73 ± 1.4% | 780.34 ± 0.7% | 137.12 ± 0.3% | 616.91 ± 1.3% | 1226.63 ± 2.5% | 7409.95 ± 0.8% | 1.00 | 1.78 | 0.40 |
| markup: an href attribute | 12 | 314.58 ± 0.6% | 315.69 ± 0.3% | 512.57 ± 1.0% | 37.33 ± 0.6% | 414.74 ± 3.0% | 904.15 ± 2.2% | 19768.90 ± 0.6% | 1.00 | 8.43 | 0.76 |
| markup: a heading's start tag | 13 | 298.27 ± 0.9% | 299.17 ± 1.2% | 490.07 ± 0.4% | 36.04 ± 0.6% | 518.28 ± 1.6% | 984.28 ± 2.3% | 16521.00 ± 5.5% | 1.00 | 8.28 | 0.58 |
| markup: a number | 6 | 290.96 ± 0.3% | 291.45 ± 3.2% | 1405.28 ± 2.6% | 37.31 ± 0.8% | 1138.80 ± 1.5% | 2175.91 ± 3.0% | 21789.37 ± 0.7% | 1.00 | 7.80 | 0.26 |

