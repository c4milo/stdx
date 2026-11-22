# bench-regex

| Field | Value |
|---|---|
| Commit | 822c457 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45024986799 |
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
| literal: a word | 217 | 15683.03 ± 0.9% | 1037.72 ± 0.1% | 28.71 ± 0.4% | 18490.16 ± 1.8% | 9398.17 ± 7.3% | 17.35 ± 0.3% | 86.92 ± 0.3% | 15670.25 ± 0.6% | 15.11 | 1.00 | 0.85 | 1.67 |
| literal: a word that is not there | 0 | 18787.38 ± 0.8% | 1049.59 ± 0.7% | 28.50 ± 0.3% | 19937.04 ± 0.9% | 29297.79 ± 1.1% | 17.10 ± 0.8% | 82.83 ± 0.2% | 18861.52 ± 1.0% | 17.90 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 5259.68 ± 0.4% | 1018.56 ± 0.1% | 15.00 ± 1.0% | 3981.07 ± 0.3% | 21.49 ± 0.1% | 5.43 ± 0.3% | 6.93 ± 0.2% | 5252.95 ± 0.5% | 5.16 | 1.00 | 1.32 | 244.70 |
| literal: a word in any case | 217 | 11614.05 ± 0.4% | 1037.99 ± 0.4% | 21.92 ± 0.3% | 3983.50 ± 0.2% | 38.36 ± 1.1% | refused | differs | 11601.96 ± 0.1% | 11.19 | 1.00 | 2.92 | 302.80 |
| literal: an href attribute | 33 | 16388.48 ± 1.3% | 1045.60 ± 0.1% | 27.75 ± 0.2% | 17098.98 ± 0.6% | 2264.11 ± 0.3% | 13.13 ± 0.1% | 75.84 ± 0.2% | 16453.02 ± 1.1% | 15.67 | 1.00 | 0.96 | 7.24 |
| literal: a word, second text | 123 | 15967.31 ± 0.7% | 1040.01 ± 0.1% | 28.28 ± 0.1% | 18770.74 ± 0.7% | 7797.39 ± 5.2% | 20.00 ± 0.5% | 71.14 ± 0.6% | 15978.47 ± 0.6% | 15.35 | 1.00 | 0.85 | 2.05 |
| class: two capitalized words | 1331 | 1097.60 ± 0.3% | 955.39 ± 0.1% | 26.51 ± 0.2% | 587.14 ± 0.1% | 40.78 ± 0.3% | 14.68 ± 0.2% | 69.04 ± 0.4% | 1095.60 ± 0.4% | 1.15 | 1.00 | 1.87 | 26.92 |
| class: a word that ends in ing | 3399 | 885.95 ± 0.1% | 885.94 ± 0.1% | 18.49 ± 0.1% | 550.13 ± 0.1% | 29.45 ± 11.1% | 8.21 ± 0.3% | 18.46 ± 0.4% | 885.23 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.08 |
| class: a word in capitals | 2332 | 1487.00 ± 0.6% | 953.78 ± 0.1% | 27.76 ± 0.4% | 574.84 ± 0.0% | 43.61 ± 3.4% | 17.11 ± 0.3% | 83.34 ± 0.3% | 1484.18 ± 0.2% | 1.56 | 1.00 | 2.59 | 34.10 |
| class: a number | 8288 | 2148.32 ± 0.2% | 808.93 ± 0.1% | 27.95 ± 0.1% | 1796.36 ± 0.1% | 42.78 ± 16.2% | 0.54 ± 0.3% | 56.52 ± 0.4% | 2147.10 ± 0.1% | 2.66 | 1.00 | 1.20 | 50.22 |
| class: two capitalized words, second text | 5359 | 694.51 ± 0.1% | 689.90 ± 0.2% | 23.86 ± 0.1% | 489.26 ± 0.1% | 35.07 ± 6.0% | 17.12 ± 0.2% | 64.18 ± 0.1% | 694.35 ± 0.0% | 1.01 | 1.00 | 1.42 | 19.80 |
| other: a word between two words | 6104 | 722.91 ± 0.6% | 751.39 ± 0.3% | 23.92 ± 0.4% | 756.75 ± 0.6% | 105.76 ± 10.6% | 11.20 ± 0.4% | 70.04 ± 0.4% | 722.79 ± 0.4% | 0.96 | 1.00 | 0.96 | 6.84 |
| other: a number before a unit, second text | 1481 | 5473.44 ± 0.7% | 976.28 ± 0.1% | 26.32 ± 0.3% | 5949.20 ± 0.5% | 40.69 ± 16.1% | 18.17 ± 0.7% | 67.22 ± 0.3% | 5462.47 ± 1.3% | 5.61 | 1.00 | 0.92 | 134.53 |
| other: a heading's start tag | 110 | 12417.25 ± 0.7% | 1038.94 ± 0.2% | 27.38 ± 0.4% | 1720.60 ± 0.1% | 1583.01 ± 7.7% | 16.12 ± 0.6% | 88.96 ± 0.4% | 12413.01 ± 0.9% | 11.95 | 1.00 | 7.22 | 7.84 |
| other: a whole word | 217 | 13804.93 ± 1.5% | 1038.27 ± 0.2% | 30.15 ± 0.2% | 14705.36 ± 0.6% | 49.24 ± 0.2% | 13.20 ± 0.2% | 56.31 ± 0.3% | 13771.31 ± 1.0% | 13.30 | 1.00 | 0.94 | 280.34 |
| other: a line's first word, second text | 3716 | 1975.74 ± 0.5% | 864.51 ± 0.1% | 31.65 ± 0.4% | 1757.78 ± 0.6% | 61.97 ± 4.2% | refused | refused | 1968.40 ± 0.7% | 2.29 | 1.00 | 1.12 | 31.88 |
| other: fourteen octets before an x | 87 | 19473.86 ± 0.8% | 1.55 ± 0.1% | 1.55 ± 0.1% | 3975.36 ± 0.5% | 10.62 ± 0.2% | differs | 17.82 ± 0.1% | 19433.63 ± 0.6% | 12582.54 | 1.00 | 4.90 | 1833.65 |
| other: a Greek word | 21815 | 473.48 ± 1.1% | 323.83 ± 0.3% | 31.52 ± 0.5% | 294.40 ± 0.4% | 49.24 ± 11.0% | differs | refused | 478.10 ± 0.6% | 1.46 | 0.99 | 1.61 | 9.62 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.75 ± 0.1% | 28.76 ± 0.2% | 0.50 ± 0.1% | 21.62 ± 0.2% | 2.76 ± 0.7% | differs | 4.03 ± 0.2% | 28.75 ± 0.2% | 1.00 | 1.00 | 1.33 | 10.43 |
| a UUID | 32895 | 23.25 ± 0.2% | 23.25 ± 0.2% | 0.67 ± 0.1% | 16.01 ± 0.1% | 3.10 ± 0.2% | 0.73 ± 0.1% | 3.61 ± 1.0% | 23.22 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.49 |
| an IPv4 address | 33176 | 42.55 ± 0.2% | 42.56 ± 0.3% | 2.19 ± 0.1% | 32.65 ± 0.2% | 6.70 ± 0.2% | differs | 4.19 ± 0.3% | 42.57 ± 0.1% | 1.00 | 1.00 | 1.30 | 6.35 |
| a date and time | 32954 | 35.36 ± 0.7% | 35.39 ± 0.4% | 1.52 ± 0.2% | 23.65 ± 0.3% | 7.10 ± 0.3% | 1.25 ± 0.2% | 7.05 ± 0.8% | 35.36 ± 0.3% | 1.00 | 1.00 | 1.50 | 4.98 |
| a field path | 32606 | 33.11 ± 0.3% | 33.12 ± 0.1% | 0.83 ± 0.2% | 25.60 ± 0.1% | 3.51 ± 0.8% | differs | 2.97 ± 0.3% | 33.10 ± 0.2% | 1.00 | 1.00 | 1.29 | 9.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.22 ± 0.2% | 10.22 ± 0.1% | 10.21 ± 0.3% | 11.40 ± 0.1% | 4.94 ± 2.0% | 0.93 ± 0.3% | none | 10.21 ± 0.3% | 1.00 | 1.00 | 0.90 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 283.22 ± 0.4% | 284.87 ± 0.3% | 336.94 ± 0.4% | 85.91 ± 0.8% | 223.24 ± 1.0% | 482.79 ± 0.2% | 3871.84 ± 3.7% | 283.10 ± 0.6% | 0.99 | 1.00 | 3.30 | 1.27 |
| a UUID | 62 | 211.94 ± 0.1% | 212.84 ± 0.4% | 245.17 ± 0.1% | 45.64 ± 1.0% | 100.20 ± 1.6% | 185.14 ± 2.2% | 4461.59 ± 0.2% | 211.81 ± 0.2% | 1.00 | 1.00 | 4.64 | 2.12 |
| an IPv4 address | 29 | 434.94 ± 0.2% | 439.84 ± 0.4% | 577.72 ± 0.2% | 77.34 ± 0.2% | 132.13 ± 1.5% | 296.28 ± 0.6% | 7671.38 ± 0.2% | 434.86 ± 0.3% | 0.99 | 1.00 | 5.62 | 3.29 |
| a date and time | 56 | 283.29 ± 0.2% | 284.56 ± 0.6% | 338.60 ± 0.2% | 72.61 ± 1.1% | 138.84 ± 2.0% | 328.47 ± 1.1% | 4936.76 ± 0.8% | 283.44 ± 0.1% | 1.00 | 1.00 | 3.90 | 2.04 |
| a field path | 39 | 317.83 ± 0.2% | 319.61 ± 0.1% | 388.70 ± 0.1% | 80.02 ± 0.8% | 209.00 ± 2.1% | 529.49 ± 5.5% | 4977.38 ± 4.3% | 317.73 ± 0.2% | 0.99 | 1.00 | 3.97 | 1.52 |
| literal: a word | 7 | 784.38 ± 0.4% | 808.88 ± 0.3% | 1414.78 ± 0.1% | 500.48 ± 0.2% | 641.21 ± 1.4% | 966.31 ± 1.0% | 30761.41 ± 0.5% | 783.29 ± 0.8% | 0.97 | 1.00 | 1.57 | 1.22 |
| literal: a word that is not there | 8 | 754.13 ± 0.3% | 778.70 ± 1.1% | 1327.01 ± 0.1% | 452.71 ± 0.2% | 609.62 ± 1.9% | 909.94 ± 0.6% | 29736.69 ± 0.7% | 754.37 ± 0.3% | 0.97 | 1.00 | 1.67 | 1.24 |
| literal: one of four words | 26 | 411.83 ± 0.4% | 453.27 ± 0.2% | 602.79 ± 0.3% | 50.10 ± 0.5% | 244.28 ± 4.2% | 374.72 ± 0.6% | 15779.91 ± 0.1% | 411.07 ± 0.5% | 0.91 | 1.00 | 8.22 | 1.69 |
| literal: a word in any case | 11 | 674.11 ± 0.2% | 706.70 ± 0.5% | 1133.95 ± 0.1% | 15.48 ± 0.4% | 670.72 ± 2.9% | refused | 23849.23 ± 0.2% | 673.63 ± 0.2% | 0.95 | 1.00 | 43.53 | 1.01 |
| literal: an href attribute | 12 | 404.28 ± 0.3% | 409.20 ± 0.2% | 527.49 ± 0.3% | 45.54 ± 0.3% | 507.77 ± 0.7% | 773.49 ± 0.3% | 22440.55 ± 0.2% | 404.01 ± 0.4% | 0.99 | 1.00 | 8.88 | 0.80 |
| literal: a word, second text | 10 | 697.06 ± 0.4% | 720.47 ± 0.4% | 1181.73 ± 0.0% | 403.32 ± 0.3% | 545.52 ± 2.0% | 803.36 ± 0.3% | 27581.68 ± 1.4% | 696.29 ± 0.3% | 0.97 | 1.00 | 1.73 | 1.28 |
| class: two capitalized words | 23 | 426.21 ± 0.3% | 438.77 ± 1.0% | 577.78 ± 0.6% | 98.12 ± 0.1% | 510.17 ± 3.1% | 745.56 ± 0.4% | 6547.64 ± 0.4% | 426.40 ± 0.4% | 0.97 | 1.00 | 4.34 | 0.84 |
| class: a word that ends in ing | 9 | 654.96 ± 0.4% | 698.28 ± 0.5% | 1106.93 ± 0.1% | 128.97 ± 1.3% | 770.88 ± 0.9% | 1100.88 ± 0.6% | 16052.17 ± 0.2% | 653.61 ± 0.2% | 0.94 | 1.00 | 5.08 | 0.85 |
| class: a word in capitals | 16 | 512.99 ± 0.3% | 531.61 ± 1.1% | 735.41 ± 0.1% | 133.59 ± 1.1% | 760.14 ± 1.6% | 1023.56 ± 0.7% | 8601.61 ± 0.8% | 512.73 ± 0.2% | 0.96 | 1.00 | 3.84 | 0.67 |
| class: a number | 6 | 731.25 ± 0.9% | 768.29 ± 0.8% | 1270.29 ± 0.1% | 41.77 ± 0.7% | 1421.71 ± 2.0% | 1847.22 ± 0.9% | 23025.12 ± 0.1% | 728.51 ± 0.7% | 0.95 | 1.00 | 17.51 | 0.51 |
| class: two capitalized words, second text | 23 | 427.20 ± 0.7% | 440.72 ± 0.5% | 577.62 ± 0.7% | 99.18 ± 0.2% | 513.60 ± 1.5% | 734.74 ± 3.7% | 6555.42 ± 0.1% | 426.38 ± 0.3% | 0.97 | 1.00 | 4.31 | 0.83 |
| other: a word between two words | 13 | 611.59 ± 1.0% | 623.87 ± 1.1% | 923.95 ± 0.2% | 132.25 ± 0.6% | 516.64 ± 0.9% | 806.24 ± 1.0% | 14989.38 ± 0.8% | 610.96 ± 0.2% | 0.98 | 1.00 | 4.62 | 1.18 |
| other: a number before a unit, second text | 15 | 519.70 ± 0.6% | 557.59 ± 0.4% | 791.62 ± 0.9% | 39.35 ± 0.3% | 647.10 ± 2.0% | 889.98 ± 0.7% | 15365.11 ± 0.1% | 520.51 ± 0.7% | 0.93 | 1.00 | 13.21 | 0.80 |
| other: a heading's start tag | 13 | 386.67 ± 0.6% | 392.16 ± 0.5% | 502.64 ± 0.6% | 44.18 ± 0.2% | 650.96 ± 0.5% | 878.79 ± 0.2% | 18611.35 ± 0.3% | 387.17 ± 0.4% | 0.99 | 1.00 | 8.75 | 0.59 |
| other: a whole word | 11 | 715.26 ± 0.3% | 737.76 ± 0.2% | 1213.15 ± 0.2% | 117.61 ± 0.7% | 575.82 ± 1.6% | 838.95 ± 0.2% | 27161.09 ± 0.3% | 715.99 ± 0.6% | 0.97 | 1.00 | 6.08 | 1.24 |
| other: a line's first word, second text | 17 | 578.94 ± 0.2% | 599.34 ± 0.5% | 875.71 ± 0.4% | 126.96 ± 0.1% | 722.60 ± 1.9% | refused | refused | 578.06 ± 0.8% | 0.97 | 1.00 | 4.56 | 0.80 |
| other: fourteen octets before an x | 16 | 115.42 ± 0.5% | 154.14 ± 0.6% | 178.63 ± 1.1% | 15.13 ± 0.7% | 459.93 ± 3.3% | 419.34 ± 0.7% | 13149.86 ± 0.4% | 115.30 ± 1.0% | 0.75 | 1.00 | 7.63 | 0.25 |
| other: a Greek word | 8 | 699.55 ± 0.2% | 749.38 ± 0.4% | 1232.03 ± 0.6% | 59.04 ± 0.5% | 1413.53 ± 1.3% | 1777.28 ± 0.2% | refused | 700.20 ± 0.4% | 0.93 | 1.00 | 11.85 | 0.49 |

