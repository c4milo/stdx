# bench-regex

| Field | Value |
|---|---|
| Commit | 988748a |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45024984481 |
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
| literal: a word | 217 | 15673.65 ± 1.6% | 1047.99 ± 0.6% | 28.86 ± 0.3% | 18285.40 ± 1.4% | 9034.58 ± 9.0% | 17.36 ± 0.4% | 86.63 ± 0.4% | 15650.01 ± 2.2% | 14.96 | 1.00 | 0.86 | 1.73 |
| literal: a word that is not there | 0 | 18576.79 ± 0.9% | 1057.98 ± 0.1% | 28.39 ± 0.8% | 19392.30 ± 1.2% | 28518.06 ± 2.1% | 17.10 ± 0.2% | 83.15 ± 0.4% | 18647.92 ± 0.9% | 17.56 | 1.00 | 0.96 | 0.65 |
| literal: one of four words | 661 | 4175.13 ± 0.2% | 1027.57 ± 0.6% | 14.98 ± 0.1% | 3980.16 ± 0.6% | 21.95 ± 0.1% | 5.43 ± 0.2% | 6.88 ± 0.9% | 4176.73 ± 0.3% | 4.06 | 1.00 | 1.05 | 190.20 |
| literal: a word in any case | 217 | 11610.92 ± 0.4% | 1047.99 ± 0.2% | 21.95 ± 0.1% | 3983.09 ± 0.2% | 38.59 ± 0.3% | refused | differs | 11604.30 ± 0.7% | 11.08 | 1.00 | 2.92 | 300.85 |
| literal: an href attribute | 33 | 16268.15 ± 2.5% | 1053.80 ± 0.1% | 27.72 ± 0.3% | 17015.74 ± 1.4% | 2257.73 ± 0.6% | 13.15 ± 0.1% | 75.88 ± 0.3% | 16358.26 ± 0.8% | 15.44 | 0.99 | 0.96 | 7.21 |
| literal: a word, second text | 123 | 15759.55 ± 0.4% | 1049.84 ± 0.0% | 28.35 ± 0.1% | 18563.23 ± 2.4% | 7781.44 ± 4.4% | 19.98 ± 0.5% | 70.12 ± 0.1% | 15720.31 ± 1.4% | 15.01 | 1.00 | 0.85 | 2.03 |
| class: two capitalized words | 1331 | 1100.77 ± 0.5% | 964.58 ± 0.5% | 26.49 ± 0.2% | 584.10 ± 0.1% | 40.89 ± 8.2% | 14.79 ± 0.3% | 69.54 ± 0.2% | 1099.41 ± 0.3% | 1.14 | 1.00 | 1.88 | 26.92 |
| class: a word that ends in ing | 3399 | 892.33 ± 0.1% | 892.87 ± 0.1% | 18.40 ± 0.2% | 547.82 ± 0.1% | 29.56 ± 1.9% | 8.19 ± 0.1% | 18.59 ± 0.2% | 891.08 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.19 |
| class: a word in capitals | 2332 | 1476.74 ± 0.6% | 961.69 ± 0.1% | 27.74 ± 0.4% | 575.03 ± 0.1% | 43.73 ± 10.1% | 17.12 ± 0.2% | 84.38 ± 0.6% | 1476.60 ± 0.6% | 1.54 | 1.00 | 2.57 | 33.77 |
| class: a number | 8288 | 2120.95 ± 0.2% | 815.10 ± 0.1% | 27.93 ± 0.3% | 1803.28 ± 0.2% | 43.05 ± 13.9% | 0.56 ± 0.1% | 57.83 ± 0.1% | 2119.93 ± 0.1% | 2.60 | 1.00 | 1.18 | 49.27 |
| class: two capitalized words, second text | 5359 | 699.81 ± 0.1% | 699.27 ± 0.1% | 23.78 ± 0.2% | 490.27 ± 0.2% | 35.49 ± 6.8% | 17.23 ± 0.2% | 64.67 ± 0.2% | 699.80 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.72 |
| other: a word between two words | 6104 | 740.30 ± 0.2% | 753.50 ± 0.2% | 23.84 ± 0.4% | 751.61 ± 0.3% | 109.00 ± 14.9% | 11.28 ± 0.3% | 70.06 ± 0.1% | 740.77 ± 0.1% | 0.98 | 1.00 | 0.98 | 6.79 |
| other: a number before a unit, second text | 1481 | 5425.31 ± 0.4% | 984.66 ± 0.4% | 26.32 ± 0.2% | 5910.71 ± 0.7% | 40.97 ± 0.2% | 18.08 ± 0.2% | 67.59 ± 0.2% | 5414.85 ± 0.5% | 5.51 | 1.00 | 0.92 | 132.42 |
| other: a heading's start tag | 110 | 12442.34 ± 0.9% | 1046.06 ± 0.1% | 27.41 ± 0.3% | 1719.76 ± 0.8% | 1584.44 ± 6.6% | 16.08 ± 0.5% | 90.48 ± 0.3% | 12406.36 ± 1.4% | 11.89 | 1.00 | 7.23 | 7.85 |
| other: a whole word | 217 | 13704.50 ± 0.9% | 1048.19 ± 0.1% | 30.20 ± 0.5% | 14533.94 ± 2.0% | 49.36 ± 0.2% | 13.31 ± 0.1% | 56.51 ± 0.5% | 13677.75 ± 0.4% | 13.07 | 1.00 | 0.94 | 277.65 |
| other: a line's first word, second text | 3716 | 1934.00 ± 0.3% | 869.49 ± 0.1% | 31.21 ± 0.3% | 1742.22 ± 0.1% | 62.22 ± 4.8% | refused | refused | 1924.75 ± 0.2% | 2.22 | 1.00 | 1.11 | 31.08 |
| other: fourteen octets before an x | 87 | 18967.89 ± 1.6% | 1.53 ± 0.1% | 1.52 ± 0.2% | 3956.48 ± 1.2% | 10.70 ± 0.1% | differs | 17.79 ± 0.2% | 18863.46 ± 1.2% | 12375.56 | 1.01 | 4.79 | 1773.11 |
| other: a Greek word | 21815 | 477.60 ± 0.4% | 322.55 ± 0.5% | 31.56 ± 0.3% | 293.84 ± 0.5% | 49.17 ± 11.1% | differs | refused | 476.06 ± 0.5% | 1.48 | 1.00 | 1.63 | 9.71 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.75 ± 0.2% | 28.73 ± 0.2% | 0.50 ± 0.2% | 21.35 ± 0.1% | 2.76 ± 0.5% | differs | 4.07 ± 0.1% | 28.73 ± 0.2% | 1.00 | 1.00 | 1.35 | 10.43 |
| a UUID | 32895 | 23.21 ± 0.3% | 23.19 ± 0.2% | 0.67 ± 0.1% | 15.99 ± 0.1% | 3.09 ± 0.6% | 0.73 ± 0.6% | 3.61 ± 0.5% | 23.21 ± 0.3% | 1.00 | 1.00 | 1.45 | 7.52 |
| an IPv4 address | 33176 | 42.52 ± 0.1% | 42.50 ± 0.1% | 2.18 ± 0.3% | 32.65 ± 0.2% | 6.70 ± 0.2% | differs | 4.12 ± 0.3% | 42.52 ± 0.1% | 1.00 | 1.00 | 1.30 | 6.35 |
| a date and time | 32954 | 35.26 ± 0.2% | 35.30 ± 0.1% | 1.51 ± 0.2% | 23.60 ± 0.5% | 7.07 ± 0.1% | 1.24 ± 0.1% | 7.10 ± 0.2% | 35.31 ± 0.3% | 1.00 | 1.00 | 1.49 | 4.99 |
| a field path | 32606 | 33.04 ± 0.4% | 33.02 ± 0.2% | 0.83 ± 0.2% | 25.49 ± 0.5% | 3.50 ± 1.5% | differs | 2.98 ± 0.3% | 32.99 ± 0.4% | 1.00 | 1.00 | 1.30 | 9.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.28 ± 0.2% | 10.29 ± 0.2% | 10.29 ± 0.1% | 11.53 ± 0.2% | 4.93 ± 1.4% | 0.92 ± 0.2% | none | 10.28 ± 0.4% | 1.00 | 1.00 | 0.89 | 2.09 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 286.57 ± 0.4% | 287.91 ± 0.3% | 337.86 ± 0.2% | 86.85 ± 0.2% | 220.94 ± 4.3% | 478.20 ± 0.7% | 3855.74 ± 1.2% | 286.56 ± 0.4% | 1.00 | 1.00 | 3.30 | 1.30 |
| a UUID | 62 | 214.23 ± 0.2% | 214.97 ± 0.3% | 244.01 ± 0.2% | 46.43 ± 0.3% | 98.08 ± 0.8% | 182.46 ± 2.4% | 4490.61 ± 0.7% | 214.22 ± 0.3% | 1.00 | 1.00 | 4.61 | 2.18 |
| an IPv4 address | 29 | 439.81 ± 0.2% | 442.90 ± 0.5% | 574.76 ± 0.6% | 76.71 ± 0.5% | 130.36 ± 1.1% | 294.96 ± 0.9% | 7576.19 ± 0.6% | 439.88 ± 0.1% | 0.99 | 1.00 | 5.73 | 3.37 |
| a date and time | 56 | 284.32 ± 1.4% | 285.95 ± 0.3% | 338.00 ± 0.2% | 72.99 ± 0.6% | 137.41 ± 2.0% | 315.95 ± 1.1% | 5004.56 ± 0.4% | 284.46 ± 0.2% | 0.99 | 1.00 | 3.90 | 2.07 |
| a field path | 39 | 319.89 ± 0.4% | 321.71 ± 0.3% | 387.74 ± 0.3% | 80.57 ± 0.5% | 203.12 ± 2.5% | 503.67 ± 2.2% | 4881.86 ± 1.5% | 319.75 ± 0.4% | 0.99 | 1.00 | 3.97 | 1.57 |
| literal: a word | 7 | 793.82 ± 0.4% | 817.68 ± 0.6% | 1412.95 ± 0.2% | 523.21 ± 0.5% | 625.05 ± 3.3% | 943.44 ± 0.3% | 30847.50 ± 0.1% | 793.34 ± 0.5% | 0.97 | 1.00 | 1.52 | 1.27 |
| literal: a word that is not there | 8 | 762.57 ± 0.3% | 786.17 ± 0.9% | 1322.83 ± 0.1% | 472.35 ± 0.3% | 603.00 ± 1.9% | 895.60 ± 0.5% | 29711.09 ± 0.5% | 762.09 ± 0.3% | 0.97 | 1.00 | 1.61 | 1.26 |
| literal: one of four words | 26 | 417.35 ± 0.5% | 456.85 ± 0.5% | 601.56 ± 0.2% | 49.03 ± 0.9% | 244.77 ± 2.2% | 364.37 ± 1.8% | 15791.43 ± 0.1% | 418.71 ± 0.6% | 0.91 | 1.00 | 8.51 | 1.71 |
| literal: a word in any case | 11 | 693.42 ± 0.2% | 716.09 ± 0.1% | 1137.07 ± 0.2% | 15.70 ± 0.3% | 665.45 ± 5.9% | refused | 23937.04 ± 0.3% | 693.13 ± 0.1% | 0.97 | 1.00 | 44.18 | 1.04 |
| literal: an href attribute | 12 | 408.94 ± 0.3% | 414.37 ± 0.5% | 528.02 ± 0.3% | 45.75 ± 0.9% | 497.16 ± 3.0% | 778.47 ± 0.7% | 22415.18 ± 7.6% | 408.93 ± 0.4% | 0.99 | 1.00 | 8.94 | 0.82 |
| literal: a word, second text | 10 | 708.14 ± 0.4% | 731.45 ± 0.4% | 1179.58 ± 0.2% | 424.71 ± 0.4% | 540.98 ± 1.6% | 805.99 ± 0.4% | 27656.89 ± 0.2% | 707.33 ± 0.6% | 0.97 | 1.00 | 1.67 | 1.31 |
| class: two capitalized words | 23 | 429.72 ± 0.7% | 443.69 ± 0.8% | 577.34 ± 0.6% | 100.44 ± 0.5% | 503.78 ± 2.2% | 746.12 ± 0.2% | 6562.04 ± 0.5% | 430.46 ± 0.5% | 0.97 | 1.00 | 4.28 | 0.85 |
| class: a word that ends in ing | 9 | 670.65 ± 0.5% | 708.26 ± 0.2% | 1111.15 ± 0.1% | 130.96 ± 1.2% | 763.83 ± 1.6% | 1113.07 ± 2.2% | 16043.95 ± 0.2% | 670.09 ± 0.4% | 0.95 | 1.00 | 5.12 | 0.88 |
| class: a word in capitals | 16 | 517.79 ± 0.3% | 537.21 ± 0.6% | 736.61 ± 0.1% | 134.95 ± 0.6% | 756.48 ± 0.8% | 1018.66 ± 0.8% | 8608.52 ± 0.1% | 517.73 ± 0.2% | 0.96 | 1.00 | 3.84 | 0.68 |
| class: a number | 6 | 740.57 ± 0.5% | 779.09 ± 0.7% | 1274.76 ± 0.1% | 41.83 ± 0.7% | 1406.59 ± 1.0% | 1898.64 ± 0.9% | 23168.87 ± 0.2% | 740.70 ± 0.3% | 0.95 | 1.00 | 17.70 | 0.53 |
| class: two capitalized words, second text | 23 | 429.95 ± 0.4% | 443.89 ± 0.7% | 575.99 ± 0.2% | 103.18 ± 0.4% | 505.33 ± 1.7% | 736.28 ± 0.5% | 6563.71 ± 0.3% | 430.11 ± 0.6% | 0.97 | 1.00 | 4.17 | 0.85 |
| other: a word between two words | 13 | 618.34 ± 0.5% | 625.82 ± 0.2% | 924.22 ± 0.3% | 134.69 ± 1.1% | 505.90 ± 3.5% | 806.79 ± 1.3% | 14953.92 ± 0.3% | 616.91 ± 0.5% | 0.99 | 1.00 | 4.59 | 1.22 |
| other: a number before a unit, second text | 15 | 527.39 ± 0.3% | 557.93 ± 0.4% | 783.47 ± 0.4% | 39.29 ± 0.2% | 635.75 ± 1.5% | 889.53 ± 0.1% | 15409.43 ± 0.1% | 528.35 ± 0.6% | 0.95 | 1.00 | 13.42 | 0.83 |
| other: a heading's start tag | 13 | 392.20 ± 0.5% | 396.80 ± 0.4% | 502.93 ± 0.4% | 44.58 ± 0.3% | 635.09 ± 0.5% | 866.12 ± 0.2% | 18592.99 ± 0.4% | 391.86 ± 0.4% | 0.99 | 1.00 | 8.80 | 0.62 |
| other: a whole word | 11 | 726.54 ± 0.2% | 748.96 ± 1.2% | 1202.72 ± 0.4% | 121.38 ± 0.7% | 568.14 ± 2.1% | 820.85 ± 1.3% | 27247.76 ± 0.3% | 726.73 ± 0.3% | 0.97 | 1.00 | 5.99 | 1.28 |
| other: a line's first word, second text | 17 | 579.26 ± 0.8% | 601.33 ± 0.8% | 869.56 ± 0.6% | 129.01 ± 0.2% | 709.63 ± 2.0% | refused | refused | 576.56 ± 1.0% | 0.96 | 1.00 | 4.49 | 0.82 |
| other: fourteen octets before an x | 16 | 116.65 ± 0.4% | 156.82 ± 0.3% | 179.79 ± 0.3% | 15.18 ± 0.3% | 457.25 ± 2.2% | 406.29 ± 0.5% | 12908.59 ± 0.1% | 116.58 ± 0.2% | 0.74 | 1.00 | 7.68 | 0.26 |
| other: a Greek word | 8 | 709.92 ± 0.5% | 761.68 ± 0.3% | 1229.05 ± 0.6% | 59.31 ± 0.3% | 1403.94 ± 1.7% | 1805.11 ± 1.3% | refused | 710.40 ± 0.4% | 0.93 | 1.00 | 11.97 | 0.51 |

