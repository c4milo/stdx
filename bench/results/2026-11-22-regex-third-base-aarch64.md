# bench-regex

| Field | Value |
|---|---|
| Commit | 1b0002a |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44986667813 |
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
| literal: a word | 217 | 15714.70 ± 1.0% | 1042.14 ± 0.2% | 28.09 ± 0.2% | 18451.06 ± 1.4% | 9143.17 ± 8.6% | 17.57 ± 0.2% | 86.09 ± 0.3% | 15686.28 ± 2.0% | 15.08 | 1.00 | 0.85 | 1.72 |
| literal: a word that is not there | 0 | 18551.25 ± 2.9% | 1045.86 ± 1.0% | 27.87 ± 0.4% | 19627.27 ± 3.6% | 28691.31 ± 1.9% | 17.39 ± 0.1% | 81.78 ± 0.4% | 18533.54 ± 3.3% | 17.74 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 4162.16 ± 0.3% | 1021.92 ± 0.2% | 14.82 ± 0.2% | 3979.62 ± 0.3% | 21.92 ± 0.2% | 5.31 ± 0.7% | 6.73 ± 0.4% | 4156.45 ± 0.2% | 4.07 | 1.00 | 1.05 | 189.90 |
| literal: a word in any case | 217 | 11639.17 ± 0.4% | 1041.96 ± 0.4% | 21.67 ± 0.2% | 3991.80 ± 0.2% | 38.25 ± 1.1% | refused | differs | 11616.18 ± 0.2% | 11.17 | 1.00 | 2.92 | 304.32 |
| literal: an href attribute | 33 | 16161.74 ± 1.3% | 1049.06 ± 0.3% | 27.13 ± 0.2% | 16908.65 ± 4.4% | 2264.10 ± 0.7% | 13.34 ± 0.3% | 75.35 ± 0.2% | 16012.69 ± 1.8% | 15.41 | 1.01 | 0.96 | 7.14 |
| literal: a word, second text | 123 | 15845.18 ± 1.8% | 1039.67 ± 0.2% | 27.68 ± 0.1% | 18487.45 ± 1.4% | 7859.92 ± 6.3% | 19.60 ± 0.6% | 69.01 ± 0.2% | 15835.51 ± 1.8% | 15.24 | 1.00 | 0.86 | 2.02 |
| class: two capitalized words | 1331 | 1105.09 ± 0.3% | 960.11 ± 0.1% | 26.00 ± 0.1% | 587.45 ± 0.2% | 40.87 ± 8.7% | 14.96 ± 0.2% | 68.28 ± 0.4% | 1104.60 ± 0.3% | 1.15 | 1.00 | 1.88 | 27.04 |
| class: a word that ends in ing | 3399 | 883.77 ± 0.2% | 884.41 ± 0.1% | 18.23 ± 0.4% | 550.78 ± 0.1% | 29.56 ± 3.0% | 8.24 ± 0.2% | 18.20 ± 0.7% | 882.89 ± 0.0% | 1.00 | 1.00 | 1.60 | 29.90 |
| class: a word in capitals | 2332 | 1484.87 ± 0.4% | 960.91 ± 0.2% | 27.21 ± 0.2% | 573.71 ± 0.2% | 43.62 ± 10.2% | 17.19 ± 0.2% | 83.26 ± 0.1% | 1488.33 ± 0.4% | 1.55 | 1.00 | 2.59 | 34.04 |
| class: a number | 8288 | 2148.26 ± 0.6% | 810.71 ± 0.1% | 27.45 ± 0.2% | 1809.92 ± 0.5% | 41.26 ± 12.9% | 0.55 ± 0.4% | 56.68 ± 0.1% | 2141.81 ± 0.3% | 2.65 | 1.00 | 1.19 | 52.06 |
| class: two capitalized words, second text | 5359 | 699.46 ± 0.2% | 700.83 ± 0.1% | 23.42 ± 0.4% | 488.11 ± 0.1% | 35.55 ± 8.1% | 16.64 ± 0.4% | 63.35 ± 0.6% | 699.63 ± 0.2% | 1.00 | 1.00 | 1.43 | 19.68 |
| other: a word between two words | 6104 | 723.19 ± 0.2% | 754.28 ± 0.1% | 23.50 ± 0.1% | 755.42 ± 0.3% | 109.31 ± 21.2% | 11.31 ± 0.1% | 68.93 ± 0.4% | 723.52 ± 0.1% | 0.96 | 1.00 | 0.96 | 6.62 |
| other: a number before a unit, second text | 1481 | 5414.61 ± 0.8% | 980.45 ± 0.1% | 25.81 ± 0.2% | 5971.37 ± 0.3% | 40.96 ± 0.1% | 17.77 ± 0.1% | 66.82 ± 0.2% | 5411.01 ± 0.3% | 5.52 | 1.00 | 0.91 | 132.20 |
| other: a heading's start tag | 110 | 12356.49 ± 0.7% | 1041.18 ± 0.3% | 26.91 ± 0.4% | 1720.65 ± 0.4% | 1581.11 ± 2.4% | 16.14 ± 0.6% | 88.33 ± 0.2% | 12349.92 ± 0.4% | 11.87 | 1.00 | 7.18 | 7.82 |
| other: a whole word | 217 | 13681.89 ± 0.6% | 1041.82 ± 0.1% | 29.28 ± 0.4% | 14756.45 ± 1.4% | 49.27 ± 0.1% | 13.71 ± 0.1% | 55.43 ± 0.1% | 13685.41 ± 0.4% | 13.13 | 1.00 | 0.93 | 277.71 |
| other: a line's first word, second text | 3716 | 1771.48 ± 0.1% | 867.16 ± 0.2% | 30.88 ± 0.3% | 1766.16 ± 0.6% | 62.20 ± 6.6% | refused | refused | 1763.83 ± 0.1% | 2.04 | 1.00 | 1.00 | 28.48 |
| other: fourteen octets before an x | 87 | 13514.77 ± 0.6% | 1.53 ± 0.2% | 1.53 ± 0.2% | 4044.51 ± 1.2% | 10.68 ± 0.3% | differs | 17.73 ± 0.2% | 13446.56 ± 0.7% | 8854.76 | 1.01 | 3.34 | 1264.87 |
| other: a Greek word | 21815 | 472.10 ± 0.8% | 320.95 ± 0.3% | 31.09 ± 0.2% | 294.68 ± 0.0% | 49.26 ± 7.8% | differs | refused | 471.69 ± 0.8% | 1.47 | 1.00 | 1.60 | 9.58 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.83 ± 0.6% | 28.81 ± 0.4% | 0.49 ± 0.1% | 21.47 ± 0.5% | 2.73 ± 0.4% | differs | 4.01 ± 0.3% | 28.83 ± 0.2% | 1.00 | 1.00 | 1.34 | 10.57 |
| a UUID | 32895 | 23.49 ± 0.6% | 23.49 ± 0.3% | 0.66 ± 0.3% | 16.04 ± 0.2% | 3.11 ± 1.4% | 0.72 ± 0.4% | 3.59 ± 0.7% | 23.48 ± 0.6% | 1.00 | 1.00 | 1.46 | 7.56 |
| an IPv4 address | 33176 | 42.65 ± 0.6% | 42.64 ± 0.7% | 2.17 ± 0.2% | 32.68 ± 0.2% | 6.66 ± 1.2% | differs | 4.10 ± 0.3% | 42.65 ± 0.5% | 1.00 | 1.00 | 1.31 | 6.40 |
| a date and time | 32954 | 35.72 ± 0.3% | 35.73 ± 0.2% | 1.51 ± 0.1% | 23.31 ± 0.3% | 7.09 ± 1.2% | 1.20 ± 0.2% | 6.96 ± 0.2% | 35.71 ± 0.4% | 1.00 | 1.00 | 1.53 | 5.04 |
| a field path | 32606 | 33.30 ± 0.4% | 33.31 ± 0.2% | 0.83 ± 0.2% | 25.22 ± 0.3% | 3.49 ± 0.8% | differs | 2.94 ± 0.2% | 33.26 ± 0.5% | 1.00 | 1.00 | 1.32 | 9.55 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.42 ± 0.7% | 10.42 ± 0.5% | 10.43 ± 0.4% | 11.06 ± 0.3% | 4.97 ± 2.4% | 0.91 ± 0.4% | none | 10.43 ± 0.3% | 1.00 | 1.00 | 0.94 | 2.10 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 285.77 ± 0.3% | 287.81 ± 0.5% | 337.11 ± 0.3% | 86.26 ± 0.6% | 222.17 ± 1.2% | 486.53 ± 0.4% | 3793.01 ± 0.6% | 285.94 ± 0.2% | 0.99 | 1.00 | 3.31 | 1.29 |
| a UUID | 62 | 214.30 ± 0.3% | 215.22 ± 0.2% | 244.25 ± 0.2% | 46.46 ± 0.6% | 99.45 ± 1.0% | 188.64 ± 2.7% | 4276.66 ± 0.8% | 214.59 ± 0.3% | 1.00 | 1.00 | 4.61 | 2.15 |
| an IPv4 address | 29 | 438.65 ± 0.2% | 442.79 ± 0.6% | 572.55 ± 0.3% | 77.01 ± 0.3% | 131.93 ± 0.8% | 300.26 ± 1.1% | 7566.35 ± 0.3% | 438.62 ± 0.3% | 0.99 | 1.00 | 5.70 | 3.32 |
| a date and time | 56 | 282.71 ± 0.7% | 284.97 ± 0.3% | 335.48 ± 0.2% | 72.96 ± 0.3% | 138.23 ± 1.8% | 330.13 ± 1.5% | 4905.72 ± 0.7% | 282.77 ± 0.4% | 0.99 | 1.00 | 3.87 | 2.05 |
| a field path | 39 | 320.82 ± 0.2% | 322.77 ± 0.2% | 388.26 ± 0.1% | 81.14 ± 1.3% | 208.92 ± 1.4% | 505.98 ± 2.3% | 4872.17 ± 0.5% | 320.86 ± 0.2% | 0.99 | 1.00 | 3.95 | 1.54 |
| literal: a word | 7 | 790.13 ± 0.6% | 825.50 ± 0.4% | 1412.51 ± 1.1% | 507.24 ± 0.2% | 636.04 ± 2.8% | 970.72 ± 0.6% | 29394.50 ± 0.2% | 790.19 ± 0.7% | 0.96 | 1.00 | 1.56 | 1.24 |
| literal: a word that is not there | 8 | 756.08 ± 0.3% | 783.62 ± 0.4% | 1321.86 ± 0.1% | 472.05 ± 0.4% | 600.93 ± 1.6% | 919.42 ± 0.6% | 28497.81 ± 0.1% | 756.21 ± 0.2% | 0.96 | 1.00 | 1.60 | 1.26 |
| literal: one of four words | 26 | 418.76 ± 0.4% | 458.59 ± 0.4% | 601.12 ± 0.4% | 49.65 ± 2.0% | 237.05 ± 3.8% | 374.84 ± 0.7% | 15754.12 ± 0.1% | 419.00 ± 0.4% | 0.91 | 1.00 | 8.43 | 1.77 |
| literal: a word in any case | 11 | 686.49 ± 0.5% | 714.55 ± 0.5% | 1130.06 ± 0.4% | 15.55 ± 0.2% | 647.91 ± 2.8% | refused | 23268.42 ± 0.2% | 688.55 ± 0.2% | 0.96 | 1.00 | 44.16 | 1.06 |
| literal: an href attribute | 12 | 413.65 ± 0.2% | 418.03 ± 0.3% | 529.86 ± 1.2% | 45.53 ± 0.5% | 500.39 ± 2.4% | 775.15 ± 1.0% | 21156.49 ± 0.1% | 413.55 ± 0.2% | 0.99 | 1.00 | 9.09 | 0.83 |
| literal: a word, second text | 10 | 707.31 ± 0.5% | 736.66 ± 0.4% | 1187.55 ± 0.2% | 386.61 ± 0.1% | 536.26 ± 1.0% | 805.21 ± 0.4% | 26447.45 ± 0.3% | 707.54 ± 0.2% | 0.96 | 1.00 | 1.83 | 1.32 |
| class: two capitalized words | 23 | 429.55 ± 0.4% | 442.93 ± 0.8% | 574.53 ± 0.7% | 99.98 ± 0.3% | 501.03 ± 2.5% | 749.33 ± 2.2% | 6410.42 ± 0.4% | 429.81 ± 0.5% | 0.97 | 1.00 | 4.30 | 0.86 |
| class: a word that ends in ing | 9 | 672.89 ± 0.5% | 713.61 ± 0.7% | 1110.17 ± 0.5% | 131.75 ± 0.9% | 751.99 ± 1.4% | 1099.98 ± 1.0% | 15723.92 ± 0.3% | 672.24 ± 0.2% | 0.94 | 1.00 | 5.11 | 0.89 |
| class: a word in capitals | 16 | 521.94 ± 0.3% | 541.84 ± 0.1% | 747.51 ± 0.1% | 134.93 ± 0.7% | 752.80 ± 1.0% | 1020.92 ± 1.0% | 8476.74 ± 0.4% | 521.88 ± 0.1% | 0.96 | 1.00 | 3.87 | 0.69 |
| class: a number | 6 | 745.37 ± 1.2% | 784.08 ± 1.2% | 1287.32 ± 0.1% | 41.96 ± 0.3% | 1401.31 ± 1.3% | 1849.20 ± 1.0% | 22209.11 ± 0.1% | 743.84 ± 0.4% | 0.95 | 1.00 | 17.77 | 0.53 |
| class: two capitalized words, second text | 23 | 430.00 ± 0.6% | 442.58 ± 0.5% | 573.35 ± 0.6% | 102.05 ± 0.9% | 502.50 ± 9.2% | 746.38 ± 1.1% | 6416.49 ± 0.4% | 429.19 ± 0.3% | 0.97 | 1.00 | 4.21 | 0.86 |
| other: a word between two words | 13 | 619.14 ± 0.6% | 629.86 ± 0.8% | 920.48 ± 0.2% | 132.10 ± 0.5% | 506.58 ± 0.4% | 808.08 ± 0.5% | 14576.95 ± 0.2% | 618.45 ± 0.5% | 0.98 | 1.00 | 4.69 | 1.22 |
| other: a number before a unit, second text | 15 | 531.62 ± 0.2% | 564.12 ± 0.3% | 789.55 ± 0.8% | 39.34 ± 0.4% | 639.00 ± 1.0% | 887.84 ± 0.3% | 14878.17 ± 0.4% | 531.55 ± 0.1% | 0.94 | 1.00 | 13.51 | 0.83 |
| other: a heading's start tag | 13 | 393.47 ± 0.3% | 399.55 ± 0.8% | 504.28 ± 0.4% | 43.95 ± 0.4% | 631.35 ± 1.1% | 875.80 ± 0.3% | 17738.52 ± 0.1% | 393.14 ± 0.5% | 0.98 | 1.00 | 8.95 | 0.62 |
| other: a whole word | 11 | 728.87 ± 0.4% | 752.28 ± 0.2% | 1212.07 ± 0.3% | 117.74 ± 0.2% | 569.08 ± 1.4% | 847.11 ± 0.4% | 26453.50 ± 0.4% | 731.03 ± 0.4% | 0.97 | 1.00 | 6.19 | 1.28 |
| other: a line's first word, second text | 17 | 584.20 ± 0.6% | 607.29 ± 0.4% | 873.96 ± 0.2% | 128.88 ± 0.4% | 712.86 ± 0.4% | refused | refused | 582.53 ± 0.5% | 0.96 | 1.00 | 4.53 | 0.82 |
| other: fourteen octets before an x | 16 | 116.99 ± 0.5% | 157.04 ± 0.6% | 180.13 ± 1.0% | 15.07 ± 0.4% | 457.10 ± 1.3% | 413.40 ± 0.8% | 12807.84 ± 0.2% | 117.07 ± 0.5% | 0.74 | 1.00 | 7.76 | 0.26 |
| other: a Greek word | 8 | 710.22 ± 0.2% | 759.76 ± 0.5% | 1220.90 ± 0.6% | 59.03 ± 0.9% | 1385.76 ± 1.4% | 1853.22 ± 0.4% | refused | 708.95 ± 0.3% | 0.93 | 1.00 | 12.03 | 0.51 |

