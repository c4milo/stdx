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
| literal: a word | 217 | 15851.97 ± 1.2% | 1038.78 ± 0.1% | 28.69 ± 0.3% | 18635.92 ± 2.3% | 9224.91 ± 8.0% | 17.33 ± 0.3% | 86.81 ± 0.2% | 15851.37 ± 0.7% | 15.26 | 1.00 | 0.85 | 1.72 |
| literal: a word that is not there | 0 | 18773.96 ± 1.0% | 1048.60 ± 0.6% | 28.44 ± 0.3% | 19901.57 ± 1.2% | 29289.07 ± 1.2% | 17.15 ± 0.6% | 82.78 ± 0.1% | 18834.19 ± 1.3% | 17.90 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 5263.34 ± 0.5% | 1018.79 ± 0.1% | 14.87 ± 1.8% | 3973.58 ± 0.3% | 21.90 ± 0.2% | 5.23 ± 0.2% | 6.89 ± 0.8% | 5249.60 ± 0.4% | 5.17 | 1.00 | 1.32 | 240.29 |
| literal: a word in any case | 217 | 11602.05 ± 0.2% | 1038.79 ± 0.3% | 21.81 ± 0.1% | 3989.22 ± 0.3% | 38.63 ± 0.2% | refused | differs | 11590.71 ± 0.2% | 11.17 | 1.00 | 2.91 | 300.31 |
| literal: an href attribute | 33 | 16191.88 ± 0.7% | 1045.54 ± 0.1% | 27.51 ± 0.2% | 16827.04 ± 2.2% | 2257.96 ± 1.6% | 13.30 ± 0.3% | 75.76 ± 0.2% | 16183.51 ± 0.2% | 15.49 | 1.00 | 0.96 | 7.17 |
| literal: a word, second text | 123 | 15932.04 ± 0.7% | 1039.38 ± 0.2% | 28.06 ± 0.2% | 18726.72 ± 1.6% | 7800.86 ± 2.5% | 19.72 ± 0.9% | 70.64 ± 0.6% | 15946.04 ± 0.8% | 15.33 | 1.00 | 0.85 | 2.04 |
| class: two capitalized words | 1331 | 1096.53 ± 0.6% | 956.17 ± 0.2% | 26.39 ± 0.2% | 587.41 ± 0.1% | 40.82 ± 2.3% | 14.65 ± 0.4% | 69.03 ± 0.2% | 1097.38 ± 0.2% | 1.15 | 1.00 | 1.87 | 26.86 |
| class: a word that ends in ing | 3399 | 886.97 ± 0.1% | 886.73 ± 0.1% | 18.39 ± 0.4% | 550.28 ± 0.1% | 29.58 ± 10.3% | 8.19 ± 0.2% | 18.44 ± 0.2% | 886.37 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.99 |
| class: a word in capitals | 2332 | 1487.12 ± 0.6% | 954.70 ± 0.4% | 27.68 ± 0.2% | 575.20 ± 0.0% | 43.67 ± 17.2% | 17.13 ± 0.3% | 83.20 ± 0.4% | 1485.10 ± 0.6% | 1.56 | 1.00 | 2.59 | 34.05 |
| class: a number | 8288 | 2141.71 ± 0.2% | 809.46 ± 0.1% | 27.94 ± 0.2% | 1806.02 ± 0.1% | 41.75 ± 16.0% | 0.55 ± 0.1% | 56.51 ± 0.5% | 2138.70 ± 0.1% | 2.65 | 1.00 | 1.19 | 51.30 |
| class: two capitalized words, second text | 5359 | 696.12 ± 0.2% | 697.01 ± 0.1% | 23.73 ± 0.1% | 489.53 ± 0.1% | 35.52 ± 14.7% | 16.71 ± 0.1% | 64.13 ± 0.4% | 677.31 ± 0.1% | 1.00 | 1.03 | 1.42 | 19.60 |
| other: a word between two words | 6104 | 724.96 ± 0.1% | 753.05 ± 0.2% | 23.79 ± 0.2% | 758.07 ± 0.7% | 111.90 ± 16.9% | 11.27 ± 0.2% | 69.99 ± 0.2% | 724.29 ± 0.1% | 0.96 | 1.00 | 0.96 | 6.48 |
| other: a number before a unit, second text | 1481 | 5486.24 ± 0.5% | 976.56 ± 0.1% | 26.27 ± 0.1% | 5930.65 ± 0.3% | 40.90 ± 0.2% | 17.87 ± 0.2% | 66.98 ± 0.6% | 5483.43 ± 0.5% | 5.62 | 1.00 | 0.93 | 134.13 |
| other: a heading's start tag | 110 | 12370.93 ± 0.2% | 1039.25 ± 0.1% | 27.21 ± 0.2% | 1719.63 ± 0.3% | 1583.13 ± 3.1% | 16.17 ± 0.3% | 88.96 ± 0.5% | 12365.74 ± 0.2% | 11.90 | 1.00 | 7.19 | 7.81 |
| other: a whole word | 217 | 13816.78 ± 0.5% | 1038.40 ± 0.1% | 29.72 ± 0.3% | 14767.16 ± 1.0% | 49.39 ± 0.1% | 13.43 ± 0.2% | 56.13 ± 0.3% | 13783.78 ± 1.0% | 13.31 | 1.00 | 0.94 | 279.76 |
| other: a line's first word, second text | 3716 | 1971.44 ± 0.5% | 865.78 ± 0.2% | 31.30 ± 0.7% | 1756.38 ± 0.3% | 62.08 ± 6.2% | refused | refused | 1965.69 ± 0.3% | 2.28 | 1.00 | 1.12 | 31.75 |
| other: fourteen octets before an x | 87 | 19590.10 ± 1.4% | 1.55 ± 0.2% | 1.55 ± 0.2% | 4027.94 ± 0.5% | 10.66 ± 0.2% | differs | 17.78 ± 0.2% | 19430.69 ± 1.1% | 12679.16 | 1.01 | 4.86 | 1838.40 |
| other: a Greek word | 21815 | 478.94 ± 0.4% | 324.61 ± 0.3% | 31.40 ± 0.4% | 294.83 ± 0.0% | 47.61 ± 14.5% | differs | refused | 477.45 ± 0.5% | 1.48 | 1.00 | 1.62 | 10.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.75 ± 0.1% | 28.74 ± 0.2% | 0.50 ± 0.2% | 21.50 ± 0.1% | 2.76 ± 4.0% | differs | 4.02 ± 0.1% | 28.76 ± 0.2% | 1.00 | 1.00 | 1.34 | 10.43 |
| a UUID | 32895 | 23.27 ± 0.1% | 23.25 ± 0.2% | 0.67 ± 0.1% | 16.02 ± 0.1% | 3.08 ± 0.6% | 0.72 ± 0.4% | 3.60 ± 0.6% | 23.25 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.55 |
| an IPv4 address | 33176 | 42.47 ± 0.2% | 42.39 ± 0.2% | 2.18 ± 0.1% | 32.51 ± 0.2% | 6.66 ± 0.4% | differs | 4.17 ± 0.1% | 42.48 ± 0.1% | 1.00 | 1.00 | 1.31 | 6.37 |
| a date and time | 32954 | 35.39 ± 0.2% | 35.40 ± 0.3% | 1.51 ± 0.1% | 23.21 ± 0.2% | 7.10 ± 0.4% | 1.20 ± 0.3% | 7.05 ± 0.5% | 35.40 ± 0.2% | 1.00 | 1.00 | 1.52 | 4.99 |
| a field path | 32606 | 33.05 ± 0.3% | 33.02 ± 0.2% | 0.83 ± 0.1% | 25.19 ± 0.2% | 3.51 ± 0.9% | differs | 2.97 ± 0.3% | 32.97 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.17 ± 0.2% | 10.17 ± 0.3% | 10.17 ± 0.2% | 11.24 ± 0.2% | 4.90 ± 2.8% | 0.91 ± 0.7% | none | 10.17 ± 0.4% | 1.00 | 1.00 | 0.91 | 2.08 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 292.67 ± 1.7% | 293.01 ± 0.3% | 347.69 ± 0.2% | 86.24 ± 0.1% | 223.30 ± 0.6% | 481.97 ± 0.2% | 3849.11 ± 0.2% | 292.49 ± 0.2% | 1.00 | 1.00 | 3.39 | 1.31 |
| a UUID | 62 | 218.68 ± 0.3% | 219.39 ± 0.3% | 250.76 ± 0.5% | 45.37 ± 0.1% | 100.13 ± 1.0% | 180.52 ± 0.7% | 4430.59 ± 0.6% | 218.69 ± 0.3% | 1.00 | 1.00 | 4.82 | 2.18 |
| an IPv4 address | 29 | 445.75 ± 0.4% | 450.63 ± 0.4% | 589.90 ± 0.4% | 75.83 ± 1.1% | 131.99 ± 3.0% | 288.59 ± 0.3% | 7631.85 ± 0.4% | 445.47 ± 0.3% | 0.99 | 1.00 | 5.88 | 3.38 |
| a date and time | 56 | 293.22 ± 0.6% | 295.34 ± 0.6% | 352.43 ± 0.2% | 71.67 ± 0.2% | 137.77 ± 0.8% | 317.66 ± 1.0% | 4914.13 ± 0.3% | 293.20 ± 0.1% | 0.99 | 1.00 | 4.09 | 2.13 |
| a field path | 39 | 327.70 ± 0.3% | 328.93 ± 0.2% | 398.90 ± 0.3% | 79.13 ± 0.5% | 209.52 ± 1.7% | 484.33 ± 0.9% | 4954.31 ± 0.1% | 327.91 ± 0.1% | 1.00 | 1.00 | 4.14 | 1.56 |
| literal: a word | 7 | 776.06 ± 0.7% | 798.95 ± 0.7% | 1372.89 ± 0.1% | 504.01 ± 1.6% | 635.12 ± 2.1% | 921.66 ± 0.6% | 29819.17 ± 1.2% | 776.30 ± 0.7% | 0.97 | 1.00 | 1.54 | 1.22 |
| literal: a word that is not there | 8 | 748.64 ± 0.1% | 772.21 ± 0.3% | 1286.76 ± 0.1% | 459.84 ± 0.3% | 603.39 ± 1.5% | 874.43 ± 0.5% | 28597.67 ± 0.5% | 748.49 ± 0.2% | 0.97 | 1.00 | 1.63 | 1.24 |
| literal: one of four words | 26 | 410.01 ± 0.5% | 449.03 ± 0.3% | 592.26 ± 0.4% | 48.96 ± 0.6% | 240.10 ± 2.4% | 355.03 ± 0.4% | 15430.26 ± 0.4% | 410.34 ± 0.3% | 0.91 | 1.00 | 8.37 | 1.71 |
| literal: a word in any case | 11 | 672.57 ± 0.4% | 699.55 ± 0.2% | 1121.73 ± 0.2% | 15.67 ± 1.0% | 641.33 ± 4.4% | refused | 23278.43 ± 0.7% | 672.75 ± 0.1% | 0.96 | 1.00 | 42.93 | 1.05 |
| literal: an href attribute | 12 | 411.12 ± 0.4% | 417.45 ± 0.4% | 536.81 ± 0.5% | 44.17 ± 0.4% | 502.11 ± 2.8% | 767.85 ± 2.1% | 21467.22 ± 0.3% | 411.12 ± 0.6% | 0.98 | 1.00 | 9.31 | 0.82 |
| literal: a word, second text | 10 | 697.63 ± 0.2% | 719.43 ± 0.3% | 1155.92 ± 0.2% | 407.52 ± 0.3% | 544.01 ± 2.3% | 795.40 ± 0.7% | 26509.33 ± 0.2% | 698.11 ± 0.2% | 0.97 | 1.00 | 1.71 | 1.28 |
| class: two capitalized words | 23 | 444.46 ± 0.7% | 459.56 ± 0.4% | 606.69 ± 0.5% | 100.22 ± 0.2% | 499.42 ± 2.7% | 737.25 ± 0.7% | 6479.58 ± 0.9% | 444.09 ± 0.4% | 0.97 | 1.00 | 4.43 | 0.89 |
| class: a word that ends in ing | 9 | 675.27 ± 0.6% | 719.54 ± 0.3% | 1152.07 ± 0.1% | 131.29 ± 0.8% | 747.61 ± 2.2% | 1076.87 ± 2.4% | 15782.60 ± 0.1% | 674.63 ± 0.6% | 0.94 | 1.00 | 5.14 | 0.90 |
| class: a word in capitals | 16 | 533.38 ± 0.4% | 557.17 ± 0.5% | 783.43 ± 0.2% | 134.38 ± 1.0% | 747.57 ± 2.1% | 1002.63 ± 1.1% | 8539.70 ± 0.1% | 532.42 ± 0.2% | 0.96 | 1.00 | 3.97 | 0.71 |
| class: a number | 6 | 760.45 ± 0.5% | 801.64 ± 0.9% | 1365.21 ± 0.1% | 41.84 ± 0.5% | 1410.00 ± 1.0% | 1921.07 ± 0.7% | 22395.28 ± 0.1% | 758.22 ± 0.3% | 0.95 | 1.00 | 18.18 | 0.54 |
| class: two capitalized words, second text | 23 | 445.55 ± 0.8% | 460.35 ± 0.3% | 608.38 ± 0.7% | 102.14 ± 0.3% | 501.08 ± 2.2% | 738.66 ± 0.8% | 6485.38 ± 0.7% | 444.60 ± 0.6% | 0.97 | 1.00 | 4.36 | 0.89 |
| other: a word between two words | 13 | 625.50 ± 0.4% | 637.85 ± 0.6% | 952.67 ± 0.3% | 135.19 ± 0.4% | 507.85 ± 2.3% | 811.73 ± 0.7% | 14680.29 ± 0.5% | 624.80 ± 0.5% | 0.98 | 1.00 | 4.63 | 1.23 |
| other: a number before a unit, second text | 15 | 537.74 ± 0.5% | 575.40 ± 0.4% | 820.52 ± 0.8% | 39.18 ± 0.9% | 638.28 ± 1.7% | 892.74 ± 0.6% | 14968.68 ± 0.1% | 537.68 ± 0.5% | 0.93 | 1.00 | 13.73 | 0.84 |
| other: a heading's start tag | 13 | 398.76 ± 0.6% | 403.80 ± 1.1% | 514.79 ± 0.8% | 42.73 ± 0.5% | 647.57 ± 4.9% | 854.79 ± 0.7% | 17858.86 ± 0.1% | 397.86 ± 0.5% | 0.99 | 1.00 | 9.33 | 0.62 |
| other: a whole word | 11 | 709.09 ± 0.6% | 729.84 ± 0.7% | 1185.37 ± 0.7% | 119.48 ± 0.4% | 560.93 ± 3.5% | 820.65 ± 1.0% | 26511.75 ± 0.1% | 709.20 ± 0.5% | 0.97 | 1.00 | 5.93 | 1.26 |
| other: a line's first word, second text | 17 | 596.12 ± 0.1% | 616.64 ± 0.2% | 904.25 ± 0.1% | 127.07 ± 0.2% | 712.15 ± 8.1% | refused | refused | 594.56 ± 0.9% | 0.97 | 1.00 | 4.69 | 0.84 |
| other: fourteen octets before an x | 16 | 117.28 ± 0.6% | 157.67 ± 0.5% | 181.45 ± 0.7% | 14.85 ± 0.6% | 450.07 ± 1.2% | 418.41 ± 0.6% | 12860.84 ± 0.2% | 117.54 ± 0.9% | 0.74 | 1.00 | 7.90 | 0.26 |
| other: a Greek word | 8 | 717.39 ± 0.6% | 770.15 ± 0.4% | 1271.63 ± 0.1% | 57.61 ± 1.1% | 1382.18 ± 2.0% | 1835.25 ± 0.3% | refused | 716.88 ± 0.3% | 0.93 | 1.00 | 12.45 | 0.52 |

