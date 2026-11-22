# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063430415 |
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
| literal: a word | 217 | 15507.62 ± 0.8% | 1048.20 ± 0.2% | 28.71 ± 0.3% | 18329.90 ± 1.4% | 9146.54 ± 8.3% | 17.35 ± 0.6% | 71.35 ± 0.1% | 15533.75 ± 0.4% | 14.79 | 1.00 | 0.85 | 1.70 |
| literal: a word that is not there | 0 | 18343.54 ± 0.5% | 1054.96 ± 0.2% | 28.60 ± 0.3% | 19651.09 ± 1.5% | 28848.84 ± 1.3% | 17.14 ± 0.2% | 62.14 ± 2.1% | 18368.17 ± 0.7% | 17.39 | 1.00 | 0.93 | 0.64 |
| literal: one of four words | 661 | 5828.24 ± 0.3% | 1025.94 ± 0.1% | 15.06 ± 0.1% | 3983.36 ± 0.1% | 21.88 ± 0.2% | 5.36 ± 0.2% | 6.96 ± 0.1% | 5813.84 ± 0.7% | 5.68 | 1.00 | 1.46 | 266.35 |
| literal: a word in any case | 217 | 11684.19 ± 0.2% | 1046.12 ± 0.2% | 21.97 ± 1.8% | 3983.25 ± 0.3% | 38.65 ± 0.5% | refused | differs | 11665.77 ± 1.9% | 11.17 | 1.00 | 2.93 | 302.29 |
| literal: an href attribute | 33 | 16085.97 ± 1.0% | 1052.71 ± 0.2% | 27.77 ± 0.4% | 16869.71 ± 1.9% | 2263.75 ± 0.1% | 13.14 ± 0.1% | 61.75 ± 0.3% | 16044.16 ± 0.7% | 15.28 | 1.00 | 0.95 | 7.11 |
| literal: a word, second text | 123 | 15618.10 ± 0.6% | 1051.13 ± 0.1% | 28.25 ± 0.1% | 18273.94 ± 1.5% | 7690.89 ± 6.9% | 20.07 ± 0.7% | 57.48 ± 0.3% | 15589.52 ± 0.6% | 14.86 | 1.00 | 0.85 | 2.03 |
| class: two capitalized words | 1331 | 1107.45 ± 0.3% | 963.71 ± 0.5% | 26.44 ± 0.2% | 587.55 ± 0.1% | 40.91 ± 13.4% | 14.75 ± 0.2% | 59.24 ± 0.4% | 1108.14 ± 0.3% | 1.15 | 1.00 | 1.88 | 27.07 |
| class: a word that ends in ing | 3399 | 888.37 ± 0.1% | 890.17 ± 0.1% | 18.64 ± 0.1% | 550.69 ± 0.1% | 29.57 ± 6.1% | 8.14 ± 0.1% | 17.11 ± 0.4% | 887.84 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.05 |
| class: a word in capitals | 2332 | 1460.45 ± 0.2% | 961.15 ± 0.2% | 28.01 ± 0.2% | 575.30 ± 0.2% | 43.77 ± 6.6% | 17.15 ± 0.2% | 69.86 ± 0.2% | 1460.17 ± 0.3% | 1.52 | 1.00 | 2.54 | 33.37 |
| class: a number | 8288 | 2120.67 ± 0.4% | 811.88 ± 0.2% | 28.27 ± 0.4% | 1802.69 ± 0.2% | 43.08 ± 6.0% | 0.54 ± 0.4% | 49.74 ± 0.2% | 2096.81 ± 0.6% | 2.61 | 1.01 | 1.18 | 49.22 |
| class: two capitalized words, second text | 5359 | 701.42 ± 0.3% | 699.01 ± 0.2% | 23.74 ± 0.2% | 489.08 ± 0.1% | 35.58 ± 13.8% | 17.03 ± 0.3% | 55.85 ± 0.1% | 700.99 ± 0.2% | 1.00 | 1.00 | 1.43 | 19.71 |
| other: a word between two words | 6104 | 748.25 ± 0.1% | 754.88 ± 0.3% | 24.00 ± 0.2% | 751.71 ± 0.3% | 111.29 ± 23.2% | 11.21 ± 0.3% | 58.56 ± 0.3% | 747.82 ± 0.1% | 0.99 | 1.00 | 1.00 | 6.72 |
| other: a number before a unit, second text | 1481 | 5319.90 ± 0.3% | 985.01 ± 0.1% | 26.28 ± 0.2% | 5887.64 ± 0.3% | 40.93 ± 0.2% | 18.20 ± 0.1% | 57.41 ± 0.3% | 5312.11 ± 0.3% | 5.40 | 1.00 | 0.90 | 129.99 |
| other: a heading's start tag | 110 | 12430.10 ± 0.6% | 1041.36 ± 0.1% | 27.42 ± 0.3% | 1720.55 ± 0.5% | 1587.68 ± 5.1% | 15.99 ± 0.8% | 73.15 ± 0.2% | 12427.19 ± 0.4% | 11.94 | 1.00 | 7.22 | 7.83 |
| other: a whole word | 217 | 13645.05 ± 0.6% | 1046.84 ± 0.7% | 30.05 ± 0.2% | 14700.59 ± 0.8% | 49.39 ± 0.1% | 13.15 ± 0.1% | 46.25 ± 0.4% | 13628.49 ± 0.8% | 13.03 | 1.00 | 0.93 | 276.27 |
| other: a line's first word, second text | 3716 | 1929.22 ± 0.7% | 869.34 ± 0.2% | 31.97 ± 0.2% | 1751.33 ± 0.6% | 62.60 ± 3.6% | refused | refused | 1915.54 ± 0.6% | 2.22 | 1.01 | 1.10 | 30.82 |
| other: fourteen octets before an x | 87 | 19164.40 ± 0.8% | 1.54 ± 0.2% | 1.54 ± 0.1% | 4000.42 ± 0.2% | 10.70 ± 0.2% | differs | 17.26 ± 0.1% | 18967.17 ± 1.0% | 12448.90 | 1.01 | 4.79 | 1791.86 |
| other: a Greek word | 21815 | 480.45 ± 0.4% | 323.31 ± 0.3% | 31.46 ± 0.2% | 294.34 ± 0.3% | 49.22 ± 11.1% | differs | refused | 479.19 ± 0.5% | 1.49 | 1.00 | 1.63 | 9.76 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.14 ± 0.2% | 28.12 ± 0.2% | 0.50 ± 0.3% | 21.59 ± 0.2% | 2.50 ± 10.2% | differs | 4.04 ± 0.2% | 28.13 ± 0.2% | 1.00 | 1.00 | 1.30 | 11.27 |
| a UUID | 32895 | 23.09 ± 0.1% | 23.07 ± 0.2% | 0.67 ± 0.3% | 16.06 ± 0.2% | 3.09 ± 0.6% | 0.73 ± 0.2% | 3.65 ± 0.6% | 23.09 ± 0.2% | 1.00 | 1.00 | 1.44 | 7.47 |
| an IPv4 address | 33176 | 41.60 ± 0.2% | 41.60 ± 0.3% | 2.20 ± 0.1% | 32.56 ± 0.3% | 6.70 ± 0.3% | differs | 4.09 ± 0.2% | 41.59 ± 0.2% | 1.00 | 1.00 | 1.28 | 6.21 |
| a date and time | 32954 | 34.89 ± 0.1% | 34.94 ± 0.2% | 1.52 ± 0.2% | 23.43 ± 0.5% | 7.08 ± 0.2% | 1.25 ± 0.2% | 7.07 ± 0.2% | 34.87 ± 0.2% | 1.00 | 1.00 | 1.49 | 4.93 |
| a field path | 32606 | 32.28 ± 0.3% | 32.31 ± 0.3% | 0.84 ± 0.3% | 25.48 ± 0.1% | 3.50 ± 0.9% | differs | 2.92 ± 0.3% | 32.27 ± 0.2% | 1.00 | 1.00 | 1.27 | 9.22 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.28 ± 0.1% | 10.28 ± 0.3% | 10.28 ± 0.1% | 11.63 ± 0.2% | 4.94 ± 1.1% | 0.94 ± 0.8% | none | 10.28 ± 0.2% | 1.00 | 1.00 | 0.88 | 2.08 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 277.57 ± 0.2% | 278.61 ± 0.3% | 325.22 ± 0.2% | 86.11 ± 0.7% | 223.40 ± 1.4% | 481.08 ± 0.2% | 3757.55 ± 0.4% | 277.71 ± 0.4% | 1.00 | 1.00 | 3.22 | 1.24 |
| a UUID | 62 | 198.10 ± 0.4% | 198.58 ± 0.4% | 223.81 ± 0.5% | 45.66 ± 0.9% | 99.41 ± 3.4% | 182.14 ± 2.0% | 4427.73 ± 0.4% | 197.98 ± 0.4% | 1.00 | 1.00 | 4.34 | 1.99 |
| an IPv4 address | 29 | 481.95 ± 0.4% | 484.74 ± 0.4% | 648.09 ± 0.6% | 77.78 ± 0.2% | 132.06 ± 16.0% | 293.96 ± 0.5% | 7273.82 ± 0.4% | 481.24 ± 0.3% | 0.99 | 1.00 | 6.20 | 3.65 |
| a date and time | 56 | 338.34 ± 0.2% | 339.87 ± 0.3% | 413.07 ± 0.2% | 73.44 ± 1.3% | 137.33 ± 15.7% | 326.86 ± 1.9% | 4935.08 ± 0.3% | 337.69 ± 0.3% | 1.00 | 1.00 | 4.61 | 2.46 |
| a field path | 39 | 285.02 ± 0.7% | 285.92 ± 0.5% | 335.81 ± 0.8% | 80.17 ± 2.2% | 205.79 ± 0.7% | 498.42 ± 6.0% | 4808.29 ± 0.5% | 285.12 ± 0.5% | 1.00 | 1.00 | 3.56 | 1.39 |
| literal: a word | 7 | 757.67 ± 0.2% | 782.71 ± 0.3% | 1309.30 ± 0.1% | 488.53 ± 0.5% | 630.56 ± 1.7% | 955.84 ± 0.3% | 29691.04 ± 0.9% | 758.12 ± 0.5% | 0.97 | 1.00 | 1.55 | 1.20 |
| literal: a word that is not there | 8 | 732.55 ± 0.4% | 755.37 ± 0.3% | 1233.60 ± 0.0% | 460.15 ± 0.3% | 603.46 ± 1.2% | 894.36 ± 0.4% | 28588.72 ± 0.8% | 732.86 ± 0.3% | 0.97 | 1.00 | 1.59 | 1.21 |
| literal: one of four words | 26 | 405.61 ± 0.4% | 442.46 ± 0.2% | 577.70 ± 0.4% | 50.04 ± 0.5% | 242.61 ± 1.8% | 368.42 ± 0.5% | 15368.96 ± 0.2% | 406.22 ± 0.4% | 0.92 | 1.00 | 8.11 | 1.67 |
| literal: a word in any case | 11 | 573.91 ± 0.7% | 591.34 ± 0.4% | 865.02 ± 0.2% | 15.46 ± 0.3% | 654.85 ± 1.1% | refused | 23358.88 ± 0.3% | 573.98 ± 0.2% | 0.97 | 1.00 | 37.12 | 0.88 |
| literal: an href attribute | 12 | 439.30 ± 0.4% | 446.30 ± 0.6% | 583.60 ± 0.8% | 45.25 ± 0.9% | 505.56 ± 1.2% | 787.16 ± 0.4% | 21298.43 ± 0.4% | 440.13 ± 0.6% | 0.98 | 1.00 | 9.71 | 0.87 |
| literal: a word, second text | 10 | 680.43 ± 0.1% | 704.91 ± 0.3% | 1110.98 ± 0.2% | 414.10 ± 0.3% | 540.56 ± 1.5% | 814.38 ± 0.5% | 26465.44 ± 0.1% | 680.66 ± 0.2% | 0.97 | 1.00 | 1.64 | 1.26 |
| class: two capitalized words | 23 | 511.23 ± 1.3% | 529.03 ± 0.3% | 730.06 ± 0.6% | 105.18 ± 0.2% | 506.25 ± 7.0% | 774.54 ± 0.5% | 6288.03 ± 0.1% | 511.19 ± 0.4% | 0.97 | 1.00 | 4.86 | 1.01 |
| class: a word that ends in ing | 9 | 708.75 ± 0.5% | 755.69 ± 0.4% | 1225.69 ± 0.5% | 133.48 ± 0.5% | 756.74 ± 1.4% | 1113.69 ± 2.3% | 15609.88 ± 0.3% | 709.54 ± 0.4% | 0.94 | 1.00 | 5.31 | 0.94 |
| class: a word in capitals | 16 | 602.80 ± 0.4% | 629.82 ± 0.5% | 930.38 ± 0.4% | 137.12 ± 1.0% | 752.58 ± 1.1% | 1029.68 ± 2.0% | 8271.36 ± 0.3% | 603.69 ± 0.5% | 0.96 | 1.00 | 4.40 | 0.80 |
| class: a number | 6 | 795.31 ± 0.4% | 836.69 ± 0.4% | 1449.81 ± 0.1% | 41.97 ± 0.7% | 1406.03 ± 1.1% | 1898.64 ± 0.8% | 22352.96 ± 0.1% | 795.18 ± 0.3% | 0.95 | 1.00 | 18.95 | 0.57 |
| class: two capitalized words, second text | 23 | 511.28 ± 0.5% | 529.79 ± 0.6% | 729.92 ± 0.4% | 101.96 ± 1.2% | 503.18 ± 1.3% | 729.17 ± 0.5% | 6288.85 ± 0.3% | 511.79 ± 0.4% | 0.97 | 1.00 | 5.01 | 1.02 |
| other: a word between two words | 13 | 646.82 ± 0.6% | 656.88 ± 0.2% | 994.25 ± 0.6% | 132.36 ± 0.7% | 507.90 ± 1.4% | 803.75 ± 0.7% | 14547.57 ± 0.1% | 647.16 ± 0.6% | 0.98 | 1.00 | 4.89 | 1.27 |
| other: a number before a unit, second text | 15 | 518.35 ± 0.5% | 552.64 ± 0.5% | 775.96 ± 0.1% | 39.57 ± 0.9% | 640.00 ± 0.7% | 885.94 ± 1.8% | 14951.98 ± 0.1% | 517.36 ± 0.5% | 0.94 | 1.00 | 13.10 | 0.81 |
| other: a heading's start tag | 13 | 440.01 ± 0.5% | 444.14 ± 0.4% | 583.46 ± 0.3% | 43.98 ± 0.4% | 636.16 ± 0.5% | 863.86 ± 1.0% | 17812.52 ± 0.1% | 440.47 ± 0.2% | 0.99 | 1.00 | 10.00 | 0.69 |
| other: a whole word | 11 | 709.92 ± 0.4% | 725.74 ± 0.5% | 1155.02 ± 0.5% | 117.20 ± 0.3% | 564.82 ± 0.5% | 820.70 ± 0.8% | 26462.32 ± 0.9% | 710.96 ± 0.3% | 0.98 | 1.00 | 6.06 | 1.26 |
| other: a line's first word, second text | 17 | 639.50 ± 0.2% | 662.74 ± 0.3% | 995.07 ± 0.3% | 129.09 ± 0.3% | 710.66 ± 2.2% | refused | refused | 635.68 ± 0.6% | 0.96 | 1.01 | 4.95 | 0.90 |
| other: fourteen octets before an x | 16 | 121.13 ± 0.5% | 164.08 ± 0.7% | 189.60 ± 0.8% | 15.31 ± 0.4% | 454.53 ± 1.5% | 418.32 ± 1.1% | 12735.20 ± 0.3% | 120.98 ± 0.6% | 0.74 | 1.00 | 7.91 | 0.27 |
| other: a Greek word | 8 | 737.15 ± 0.5% | 790.20 ± 0.3% | 1310.01 ± 0.1% | 58.89 ± 0.8% | 1393.59 ± 0.7% | 1848.69 ± 2.3% | refused | 737.62 ± 0.4% | 0.93 | 1.00 | 12.52 | 0.53 |

