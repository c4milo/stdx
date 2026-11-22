# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054923452 |
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
| literal: a word | 217 | 44083.65 ± 0.6% | 1027.87 ± 0.3% | 32.90 ± 1.0% | 40541.86 ± 24.2% | 11608.75 ± 9.4% | 12.73 ± 0.2% | 104.30 ± 0.0% | 44143.87 ± 3.0% | 42.89 | 1.00 | 1.09 | 3.80 |
| literal: a word that is not there | 0 | 63000.21 ± 0.5% | 1038.25 ± 0.4% | 32.71 ± 2.5% | 46038.64 ± 0.4% | 43405.30 ± 2.8% | 12.55 ± 0.5% | 97.11 ± 0.4% | 62905.50 ± 2.0% | 60.68 | 1.00 | 1.37 | 1.45 |
| literal: one of four words | 661 | 13449.32 ± 0.6% | 1006.71 ± 0.2% | 17.16 ± 0.6% | 11533.50 ± 0.2% | 20.97 ± 1.0% | 4.49 ± 0.1% | 7.96 ± 1.7% | 13386.72 ± 1.0% | 13.36 | 1.00 | 1.17 | 641.32 |
| literal: a word in any case | 217 | 37895.82 ± 5.2% | 1028.02 ± 0.3% | 24.11 ± 2.2% | 11438.66 ± 0.3% | 47.73 ± 1.1% | refused | differs | 37803.63 ± 0.2% | 36.86 | 1.00 | 3.31 | 794.03 |
| literal: an href attribute | 33 | 44352.97 ± 1.2% | 1033.78 ± 0.2% | 31.86 ± 1.3% | 34917.69 ± 1.9% | 2907.29 ± 6.3% | 9.53 ± 0.2% | 91.44 ± 0.3% | 44186.89 ± 0.8% | 42.90 | 1.00 | 1.27 | 15.26 |
| literal: a word, second text | 123 | 47646.04 ± 0.3% | 1029.54 ± 0.2% | 32.35 ± 0.4% | 40752.10 ± 2.1% | 10512.83 ± 11.1% | 14.42 ± 0.5% | 87.88 ± 0.3% | 47653.56 ± 0.4% | 46.28 | 1.00 | 1.17 | 4.53 |
| class: two capitalized words | 1331 | 870.83 ± 0.1% | 950.62 ± 2.3% | 30.43 ± 6.2% | 576.48 ± 1.7% | 43.83 ± 0.6% | 10.88 ± 0.7% | 72.69 ± 24.6% | 912.66 ± 0.2% | 0.92 | 0.95 | 1.51 | 19.87 |
| class: a word that ends in ing | 3399 | 873.77 ± 0.2% | 873.61 ± 0.3% | 19.97 ± 0.8% | 541.82 ± 0.7% | 30.52 ± 3.0% | 6.19 ± 0.8% | 20.18 ± 0.9% | 873.70 ± 0.7% | 1.00 | 1.00 | 1.61 | 28.63 |
| class: a word in capitals | 2332 | 1015.62 ± 1.5% | 929.83 ± 0.4% | 32.23 ± 3.4% | 565.87 ± 0.6% | 47.05 ± 6.6% | 12.34 ± 0.4% | 101.55 ± 0.4% | 1146.51 ± 0.1% | 1.09 | 0.89 | 1.79 | 21.59 |
| class: a number | 8288 | 1869.85 ± 2.2% | 792.52 ± 0.2% | 32.83 ± 0.2% | 1858.39 ± 3.9% | 44.72 ± 12.4% | 0.38 ± 0.3% | 73.39 ± 1.8% | 1865.35 ± 0.3% | 2.36 | 1.00 | 1.01 | 41.81 |
| class: two capitalized words, second text | 5359 | 691.06 ± 0.3% | 690.78 ± 0.1% | 27.38 ± 0.7% | 479.45 ± 0.4% | 37.63 ± 15.6% | 12.71 ± 0.3% | 74.25 ± 0.5% | 688.69 ± 0.2% | 1.00 | 1.00 | 1.44 | 18.37 |
| other: a word between two words | 6104 | 833.39 ± 0.3% | 738.98 ± 0.4% | 27.22 ± 1.4% | 836.58 ± 1.3% | 120.39 ± 24.4% | 8.45 ± 0.1% | 82.03 ± 0.2% | 831.65 ± 2.6% | 1.13 | 1.00 | 1.00 | 6.92 |
| other: a number before a unit, second text | 1481 | 10656.16 ± 0.6% | 978.34 ± 0.1% | 30.35 ± 0.3% | 9046.17 ± 0.4% | 44.27 ± 7.3% | 13.27 ± 0.7% | 78.08 ± 0.8% | 10601.59 ± 0.3% | 10.89 | 1.01 | 1.18 | 240.71 |
| other: a heading's start tag | 110 | 25581.56 ± 0.9% | 1024.84 ± 0.1% | 32.34 ± 0.4% | 2671.25 ± 1.9% | 1949.02 ± 2.2% | 11.68 ± 0.4% | 107.10 ± 0.3% | 25560.67 ± 0.2% | 24.96 | 1.00 | 9.58 | 13.13 |
| other: a whole word | 217 | 31508.23 ± 0.7% | 1027.52 ± 0.3% | 33.37 ± 0.4% | 29279.67 ± 0.6% | 54.46 ± 11.4% | 11.02 ± 0.4% | 62.93 ± 0.6% | 31532.36 ± 0.3% | 30.66 | 1.00 | 1.08 | 578.54 |
| other: a line's first word, second text | 3716 | 2650.58 ± 1.7% | 851.51 ± 0.3% | 36.65 ± 0.2% | 2428.16 ± 2.7% | 70.29 ± 3.0% | refused | refused | 2627.42 ± 0.8% | 3.11 | 1.01 | 1.09 | 37.71 |
| other: fourteen octets before an x | 87 | 38101.88 ± 0.3% | 1.74 ± 1.9% | 1.71 ± 2.9% | 3536.53 ± 0.3% | 11.62 ± 4.3% | differs | 21.90 ± 0.6% | 37962.65 ± 0.3% | 21937.55 | 1.00 | 10.77 | 3279.86 |
| other: a Greek word | 21815 | 467.15 ± 0.6% | 334.48 ± 0.9% | 34.91 ± 17.6% | 307.43 ± 3.6% | 57.41 ± 7.8% | differs | refused | 466.82 ± 0.5% | 1.40 | 1.00 | 1.52 | 8.14 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.74 ± 0.4% | 30.64 ± 1.0% | 0.61 ± 4.1% | 25.78 ± 3.8% | 2.81 ± 6.0% | differs | 4.01 ± 0.6% | 30.82 ± 0.5% | 1.00 | 1.00 | 1.19 | 10.93 |
| a UUID | 32895 | 25.73 ± 1.3% | 25.68 ± 1.1% | 0.75 ± 0.6% | 18.92 ± 0.6% | 3.08 ± 1.7% | 0.52 ± 0.2% | 3.81 ± 1.4% | 25.76 ± 0.3% | 1.00 | 1.00 | 1.36 | 8.35 |
| an IPv4 address | 33176 | 44.15 ± 0.8% | 44.13 ± 0.4% | 2.42 ± 0.7% | 36.24 ± 0.5% | 7.01 ± 2.6% | differs | 4.17 ± 0.2% | 44.26 ± 0.9% | 1.00 | 1.00 | 1.22 | 6.30 |
| a date and time | 32954 | 38.76 ± 5.7% | 38.86 ± 5.7% | 1.79 ± 0.6% | 29.60 ± 0.1% | 8.55 ± 0.5% | 0.90 ± 0.2% | 7.86 ± 1.2% | 38.91 ± 0.3% | 1.00 | 1.00 | 1.31 | 4.53 |
| a field path | 32606 | 34.72 ± 0.3% | 34.76 ± 1.1% | 0.95 ± 5.6% | 29.34 ± 0.4% | 3.57 ± 7.2% | differs | 2.99 ± 1.6% | 34.73 ± 6.0% | 1.00 | 1.00 | 1.18 | 9.72 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.57 ± 0.2% | 11.59 ± 6.0% | 11.50 ± 0.1% | 13.29 ± 0.6% | 5.83 ± 2.1% | 0.74 ± 0.5% | none | 11.63 ± 0.4% | 1.00 | 0.99 | 0.87 | 1.98 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 204.81 ± 0.3% | 205.69 ± 0.3% | 226.91 ± 0.1% | 101.33 ± 1.5% | 243.39 ± 1.9% | 701.64 ± 4.5% | 4883.80 ± 6.6% | 204.55 ± 0.2% | 1.00 | 1.00 | 2.02 | 0.84 |
| a UUID | 62 | 154.17 ± 0.5% | 154.50 ± 0.5% | 169.57 ± 0.2% | 57.63 ± 1.0% | 116.43 ± 13.3% | 254.33 ± 2.2% | 5385.22 ± 0.5% | 153.98 ± 0.7% | 1.00 | 1.00 | 2.68 | 1.32 |
| an IPv4 address | 29 | 311.92 ± 0.3% | 313.22 ± 0.3% | 365.38 ± 1.4% | 87.68 ± 0.8% | 148.59 ± 0.5% | 398.83 ± 2.5% | 8918.94 ± 0.6% | 311.69 ± 0.6% | 1.00 | 1.00 | 3.56 | 2.10 |
| a date and time | 56 | 252.41 ± 0.3% | 253.20 ± 0.2% | 284.92 ± 0.1% | 85.82 ± 2.2% | 160.17 ± 16.9% | 464.21 ± 7.1% | 5543.73 ± 0.3% | 252.26 ± 0.1% | 1.00 | 1.00 | 2.94 | 1.58 |
| a field path | 39 | 211.90 ± 0.3% | 212.60 ± 0.3% | 234.89 ± 0.2% | 96.09 ± 2.6% | 229.35 ± 0.9% | 736.00 ± 1.4% | 5872.69 ± 1.3% | 211.79 ± 0.1% | 1.00 | 1.00 | 2.21 | 0.92 |
| literal: a word | 7 | 396.59 ± 0.3% | 402.29 ± 0.9% | 481.11 ± 0.3% | 647.69 ± 3.2% | 795.33 ± 2.7% | 1624.12 ± 0.5% | 33886.47 ± 0.3% | 396.96 ± 0.4% | 0.99 | 1.00 | 0.61 | 0.50 |
| literal: a word that is not there | 8 | 387.98 ± 0.4% | 393.62 ± 4.0% | 471.92 ± 0.2% | 599.05 ± 1.6% | 759.99 ± 2.2% | 1508.78 ± 0.5% | 33168.19 ± 0.9% | 387.28 ± 3.7% | 0.99 | 1.00 | 0.65 | 0.51 |
| literal: one of four words | 26 | 278.00 ± 0.6% | 294.31 ± 0.5% | 337.48 ± 0.2% | 58.33 ± 1.1% | 288.17 ± 10.6% | 587.64 ± 1.0% | 17243.84 ± 0.4% | 277.93 ± 0.4% | 0.94 | 1.00 | 4.77 | 0.96 |
| literal: a word in any case | 11 | 247.15 ± 0.6% | 250.36 ± 0.6% | 280.56 ± 0.5% | 19.64 ± 0.5% | 825.49 ± 2.4% | refused | 25590.06 ± 2.5% | 246.92 ± 0.2% | 0.99 | 1.00 | 12.58 | 0.30 |
| literal: an href attribute | 12 | 302.00 ± 0.3% | 305.00 ± 0.8% | 353.06 ± 0.4% | 51.05 ± 0.6% | 568.21 ± 2.5% | 1287.53 ± 0.4% | 24511.18 ± 0.4% | 302.11 ± 0.2% | 0.99 | 1.00 | 5.92 | 0.53 |
| literal: a word, second text | 10 | 377.81 ± 0.6% | 383.69 ± 0.2% | 454.98 ± 4.3% | 543.53 ± 0.7% | 654.35 ± 3.8% | 1352.64 ± 0.2% | 30695.36 ± 0.7% | 377.54 ± 0.4% | 0.98 | 1.00 | 0.70 | 0.58 |
| class: two capitalized words | 23 | 327.30 ± 0.3% | 334.51 ± 4.0% | 385.95 ± 0.9% | 123.60 ± 0.7% | 591.81 ± 17.3% | 1268.94 ± 0.7% | 7838.50 ± 0.3% | 326.95 ± 0.2% | 0.98 | 1.00 | 2.65 | 0.55 |
| class: a word that ends in ing | 9 | 381.71 ± 0.4% | 392.84 ± 0.2% | 468.98 ± 1.6% | 151.75 ± 0.5% | 860.11 ± 3.2% | 1837.45 ± 0.5% | 19164.99 ± 1.6% | 382.23 ± 0.4% | 0.97 | 1.00 | 2.52 | 0.44 |
| class: a word in capitals | 16 | 351.41 ± 0.1% | 358.80 ± 0.3% | 421.76 ± 0.1% | 158.62 ± 0.7% | 881.22 ± 8.0% | 1731.91 ± 5.7% | 10396.36 ± 6.4% | 350.87 ± 1.0% | 0.98 | 1.00 | 2.22 | 0.40 |
| class: a number | 6 | 400.33 ± 0.1% | 409.61 ± 0.6% | 490.74 ± 0.2% | 49.28 ± 0.5% | 1655.76 ± 2.8% | 2872.45 ± 0.5% | 25899.24 ± 0.3% | 400.05 ± 1.2% | 0.98 | 1.00 | 8.12 | 0.24 |
| class: two capitalized words, second text | 23 | 326.77 ± 0.9% | 334.65 ± 0.6% | 383.81 ± 9.0% | 121.53 ± 16.9% | 592.95 ± 6.4% | 1255.70 ± 0.6% | 7844.79 ± 1.2% | 326.86 ± 0.2% | 0.98 | 1.00 | 2.69 | 0.55 |
| other: a word between two words | 13 | 365.75 ± 2.1% | 370.07 ± 0.6% | 436.09 ± 1.5% | 156.48 ± 0.9% | 583.39 ± 18.7% | 1332.29 ± 3.4% | 17253.62 ± 4.3% | 367.07 ± 0.2% | 0.99 | 1.00 | 2.34 | 0.63 |
| other: a number before a unit, second text | 15 | 317.09 ± 1.0% | 329.27 ± 0.1% | 383.64 ± 0.2% | 45.88 ± 0.9% | 722.53 ± 2.9% | 1459.88 ± 1.1% | 17302.47 ± 0.9% | 317.69 ± 0.5% | 0.96 | 1.00 | 6.91 | 0.44 |
| other: a heading's start tag | 13 | 299.06 ± 0.6% | 301.13 ± 0.5% | 352.47 ± 4.7% | 48.79 ± 6.5% | 708.78 ± 2.1% | 1417.03 ± 1.4% | 20530.96 ± 1.6% | 299.64 ± 0.1% | 0.99 | 1.00 | 6.13 | 0.42 |
| other: a whole word | 11 | 376.81 ± 2.3% | 382.89 ± 0.6% | 453.51 ± 0.2% | 147.83 ± 1.0% | 680.74 ± 5.2% | 1412.67 ± 2.0% | 30005.82 ± 1.0% | 377.78 ± 0.3% | 0.98 | 1.00 | 2.55 | 0.55 |
| other: a line's first word, second text | 17 | 359.61 ± 1.2% | 367.23 ± 1.0% | 436.07 ± 3.6% | 151.91 ± 0.9% | 800.97 ± 9.3% | refused | refused | 358.73 ± 0.5% | 0.98 | 1.00 | 2.37 | 0.45 |
| other: fourteen octets before an x | 16 | 108.38 ± 1.8% | 141.59 ± 0.1% | 158.71 ± 0.2% | 18.16 ± 0.8% | 514.30 ± 10.4% | 595.25 ± 0.6% | 15198.99 ± 0.9% | 108.27 ± 0.1% | 0.77 | 1.00 | 5.97 | 0.21 |
| other: a Greek word | 8 | 386.06 ± 0.3% | 400.20 ± 0.3% | 479.35 ± 4.0% | 63.74 ± 7.0% | 1634.49 ± 3.7% | 2612.82 ± 0.6% | refused | 385.53 ± 0.1% | 0.96 | 1.00 | 6.06 | 0.24 |

