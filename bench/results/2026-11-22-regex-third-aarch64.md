# bench-regex

| Field | Value |
|---|---|
| Commit | 43d309e |
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
| literal: a word | 217 | 15794.40 ± 0.6% | 1042.21 ± 0.8% | 28.08 ± 0.2% | 18834.22 ± 0.9% | 9326.64 ± 4.9% | 17.58 ± 0.2% | 86.98 ± 0.1% | 15850.34 ± 0.3% | 15.15 | 1.00 | 0.84 | 1.69 |
| literal: a word that is not there | 0 | 18787.50 ± 0.8% | 1045.41 ± 0.6% | 27.87 ± 0.3% | 20098.76 ± 1.5% | 29550.63 ± 1.0% | 17.39 ± 0.2% | 82.54 ± 0.3% | 18792.29 ± 0.7% | 17.97 | 1.00 | 0.93 | 0.64 |
| literal: one of four words | 661 | 4175.59 ± 0.3% | 1022.37 ± 0.5% | 14.74 ± 0.1% | 3987.67 ± 0.6% | 21.89 ± 0.1% | 5.30 ± 0.2% | 6.89 ± 1.2% | 4167.98 ± 0.4% | 4.08 | 1.00 | 1.05 | 190.76 |
| literal: a word in any case | 217 | 11697.35 ± 0.6% | 1041.85 ± 0.3% | 21.54 ± 0.2% | 3992.88 ± 0.1% | 38.72 ± 0.7% | refused | differs | 11712.36 ± 0.6% | 11.23 | 1.00 | 2.93 | 302.11 |
| literal: an href attribute | 33 | 16449.44 ± 1.2% | 1049.29 ± 0.4% | 27.09 ± 0.1% | 17161.28 ± 2.1% | 2263.59 ± 0.6% | 13.43 ± 0.1% | 75.63 ± 0.1% | 16448.86 ± 1.3% | 15.68 | 1.00 | 0.96 | 7.27 |
| literal: a word, second text | 123 | 15912.19 ± 0.5% | 1040.02 ± 0.3% | 27.65 ± 0.2% | 18775.43 ± 0.8% | 7770.08 ± 4.9% | 19.29 ± 1.4% | 69.96 ± 0.4% | 15892.80 ± 0.9% | 15.30 | 1.00 | 0.85 | 2.05 |
| class: two capitalized words | 1331 | 1108.49 ± 0.2% | 961.02 ± 0.1% | 25.92 ± 0.1% | 584.59 ± 0.1% | 40.93 ± 0.1% | 14.98 ± 0.1% | 68.73 ± 0.3% | 1107.58 ± 0.4% | 1.15 | 1.00 | 1.90 | 27.08 |
| class: a word that ends in ing | 3399 | 886.70 ± 0.2% | 889.34 ± 0.3% | 18.13 ± 0.1% | 548.01 ± 0.1% | 29.56 ± 3.2% | 8.19 ± 0.2% | 18.44 ± 0.5% | 887.15 ± 0.2% | 1.00 | 1.00 | 1.62 | 29.99 |
| class: a word in capitals | 2332 | 1486.78 ± 0.3% | 961.02 ± 0.2% | 27.19 ± 0.2% | 575.20 ± 0.1% | 43.76 ± 16.7% | 17.15 ± 0.2% | 83.28 ± 0.4% | 1487.34 ± 0.4% | 1.55 | 1.00 | 2.58 | 33.98 |
| class: a number | 8288 | 2144.09 ± 0.3% | 809.91 ± 0.1% | 27.40 ± 0.2% | 1811.09 ± 0.4% | 42.90 ± 17.4% | 0.57 ± 0.1% | 56.47 ± 0.3% | 2144.87 ± 0.2% | 2.65 | 1.00 | 1.18 | 49.98 |
| class: two capitalized words, second text | 5359 | 699.58 ± 0.1% | 700.94 ± 0.1% | 23.33 ± 0.2% | 490.60 ± 0.1% | 35.50 ± 7.2% | 16.91 ± 0.2% | 63.93 ± 0.2% | 699.89 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.71 |
| other: a word between two words | 6104 | 725.53 ± 0.3% | 755.64 ± 0.2% | 23.38 ± 0.1% | 756.08 ± 0.3% | 106.03 ± 10.4% | 11.49 ± 0.1% | 69.81 ± 0.2% | 725.75 ± 0.2% | 0.96 | 1.00 | 0.96 | 6.84 |
| other: a number before a unit, second text | 1481 | 5450.75 ± 0.8% | 980.37 ± 0.1% | 25.79 ± 0.2% | 5929.42 ± 0.4% | 40.99 ± 16.9% | 17.87 ± 0.2% | 67.03 ± 0.2% | 5446.84 ± 0.6% | 5.56 | 1.00 | 0.92 | 132.98 |
| other: a heading's start tag | 110 | 12418.44 ± 0.8% | 1042.06 ± 0.2% | 26.83 ± 0.1% | 1719.07 ± 0.2% | 1585.06 ± 7.7% | 16.30 ± 0.3% | 89.03 ± 0.5% | 12449.43 ± 0.9% | 11.92 | 1.00 | 7.22 | 7.83 |
| other: a whole word | 217 | 13842.48 ± 0.6% | 1041.69 ± 0.4% | 29.13 ± 0.3% | 14998.09 ± 0.4% | 49.41 ± 0.3% | 13.69 ± 0.1% | 55.77 ± 0.2% | 13877.76 ± 1.1% | 13.29 | 1.00 | 0.92 | 280.18 |
| other: a line's first word, second text | 3716 | 1964.06 ± 0.3% | 867.50 ± 0.1% | 30.79 ± 0.2% | 1757.78 ± 0.5% | 62.30 ± 4.2% | refused | refused | 1957.13 ± 0.4% | 2.26 | 1.00 | 1.12 | 31.52 |
| other: fourteen octets before an x | 87 | 19476.95 ± 1.1% | 1.53 ± 0.0% | 1.53 ± 0.0% | 4031.55 ± 0.5% | 10.69 ± 0.2% | differs | 17.78 ± 0.4% | 19486.83 ± 0.9% | 12738.48 | 1.00 | 4.83 | 1822.68 |
| other: a Greek word | 21815 | 472.75 ± 0.7% | 321.34 ± 0.5% | 31.00 ± 0.1% | 294.63 ± 0.2% | 49.22 ± 24.6% | differs | refused | 472.05 ± 0.9% | 1.47 | 1.00 | 1.60 | 9.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.82 ± 0.1% | 28.84 ± 0.2% | 0.49 ± 0.1% | 21.28 ± 0.1% | 2.75 ± 0.8% | differs | 4.01 ± 0.3% | 28.84 ± 0.2% | 1.00 | 1.00 | 1.35 | 10.46 |
| a UUID | 32895 | 23.48 ± 0.5% | 23.45 ± 0.3% | 0.66 ± 0.1% | 16.02 ± 0.1% | 3.09 ± 0.5% | 0.72 ± 0.3% | 3.59 ± 0.7% | 23.49 ± 0.3% | 1.00 | 1.00 | 1.47 | 7.59 |
| an IPv4 address | 33176 | 42.59 ± 0.3% | 42.57 ± 0.3% | 2.17 ± 0.1% | 32.56 ± 0.1% | 6.70 ± 0.3% | differs | 4.13 ± 0.4% | 42.62 ± 0.4% | 1.00 | 1.00 | 1.31 | 6.36 |
| a date and time | 32954 | 35.66 ± 0.6% | 35.70 ± 0.7% | 1.51 ± 0.2% | 23.48 ± 0.3% | 7.10 ± 0.0% | 1.20 ± 0.1% | 7.01 ± 0.5% | 35.65 ± 0.5% | 1.00 | 1.00 | 1.52 | 5.02 |
| a field path | 32606 | 33.28 ± 0.4% | 33.28 ± 0.3% | 0.83 ± 0.4% | 25.45 ± 0.2% | 3.51 ± 1.2% | differs | 2.96 ± 0.3% | 33.21 ± 0.4% | 1.00 | 1.00 | 1.31 | 9.49 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.26 ± 0.4% | 10.26 ± 0.4% | 10.27 ± 0.4% | 11.01 ± 0.0% | 5.00 ± 1.1% | 0.92 ± 0.4% | none | 10.27 ± 0.3% | 1.00 | 1.00 | 0.93 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 285.32 ± 0.3% | 287.10 ± 0.3% | 336.41 ± 0.2% | 86.79 ± 0.2% | 222.23 ± 1.3% | 483.08 ± 0.5% | 3856.07 ± 0.5% | 285.33 ± 0.2% | 0.99 | 1.00 | 3.29 | 1.28 |
| a UUID | 62 | 214.91 ± 1.2% | 215.79 ± 0.2% | 245.11 ± 0.2% | 46.32 ± 0.4% | 99.58 ± 0.3% | 184.66 ± 3.0% | 4475.66 ± 0.8% | 215.05 ± 0.2% | 1.00 | 1.00 | 4.64 | 2.16 |
| an IPv4 address | 29 | 439.38 ± 0.1% | 444.09 ± 0.2% | 575.23 ± 0.3% | 76.93 ± 0.7% | 132.15 ± 1.2% | 293.47 ± 1.1% | 7669.75 ± 0.4% | 439.40 ± 0.1% | 0.99 | 1.00 | 5.71 | 3.32 |
| a date and time | 56 | 282.76 ± 0.3% | 284.55 ± 0.3% | 335.44 ± 0.1% | 72.82 ± 0.6% | 137.58 ± 2.0% | 318.78 ± 0.3% | 4966.30 ± 0.4% | 282.72 ± 0.1% | 0.99 | 1.00 | 3.88 | 2.06 |
| a field path | 39 | 320.42 ± 0.6% | 322.02 ± 0.5% | 387.88 ± 0.5% | 80.23 ± 0.5% | 208.98 ± 1.7% | 505.61 ± 1.7% | 4951.92 ± 1.1% | 321.47 ± 0.4% | 1.00 | 1.00 | 3.99 | 1.53 |
| literal: a word | 7 | 789.14 ± 0.2% | 815.13 ± 1.1% | 1409.66 ± 0.3% | 519.61 ± 0.1% | 642.05 ± 2.8% | 948.79 ± 0.6% | 30073.07 ± 0.4% | 788.50 ± 0.5% | 0.97 | 1.00 | 1.52 | 1.23 |
| literal: a word that is not there | 8 | 755.73 ± 0.1% | 776.53 ± 0.5% | 1319.77 ± 0.2% | 469.01 ± 0.2% | 607.35 ± 1.9% | 897.95 ± 0.2% | 28925.13 ± 0.1% | 755.45 ± 0.2% | 0.97 | 1.00 | 1.61 | 1.24 |
| literal: one of four words | 26 | 419.09 ± 0.4% | 457.33 ± 0.3% | 602.22 ± 0.2% | 49.08 ± 1.2% | 243.82 ± 1.7% | 368.15 ± 2.2% | 15550.44 ± 0.5% | 418.97 ± 0.4% | 0.92 | 1.00 | 8.54 | 1.72 |
| literal: a word in any case | 11 | 685.95 ± 0.2% | 716.24 ± 0.8% | 1130.70 ± 0.4% | 15.67 ± 0.2% | 666.23 ± 1.0% | refused | 23420.79 ± 0.4% | 685.56 ± 0.4% | 0.96 | 1.00 | 43.76 | 1.03 |
| literal: an href attribute | 12 | 413.32 ± 0.6% | 418.69 ± 0.2% | 531.72 ± 0.1% | 45.67 ± 0.9% | 508.28 ± 1.4% | 780.43 ± 0.6% | 21516.01 ± 0.3% | 413.13 ± 0.4% | 0.99 | 1.00 | 9.05 | 0.81 |
| literal: a word, second text | 10 | 706.38 ± 0.6% | 730.13 ± 0.7% | 1185.51 ± 0.7% | 420.17 ± 0.8% | 540.12 ± 2.1% | 811.05 ± 0.3% | 26843.67 ± 1.9% | 706.65 ± 0.4% | 0.97 | 1.00 | 1.68 | 1.31 |
| class: two capitalized words | 23 | 429.41 ± 0.6% | 442.34 ± 0.5% | 572.16 ± 0.5% | 100.44 ± 0.3% | 509.85 ± 1.7% | 744.74 ± 1.0% | 6483.59 ± 0.4% | 429.80 ± 0.2% | 0.97 | 1.00 | 4.28 | 0.84 |
| class: a word that ends in ing | 9 | 673.16 ± 0.5% | 713.97 ± 0.5% | 1111.87 ± 0.4% | 131.02 ± 1.2% | 768.37 ± 0.9% | 1105.89 ± 2.6% | 15806.68 ± 0.3% | 672.96 ± 0.4% | 0.94 | 1.00 | 5.14 | 0.88 |
| class: a word in capitals | 16 | 523.25 ± 0.4% | 541.26 ± 0.4% | 748.32 ± 0.1% | 134.45 ± 0.3% | 759.79 ± 1.6% | 1017.54 ± 0.9% | 8567.28 ± 0.6% | 523.50 ± 0.1% | 0.97 | 1.00 | 3.89 | 0.69 |
| class: a number | 6 | 747.77 ± 0.4% | 784.38 ± 0.5% | 1292.26 ± 0.1% | 41.80 ± 0.9% | 1415.58 ± 0.7% | 1900.53 ± 1.7% | 22660.64 ± 0.3% | 748.22 ± 0.3% | 0.95 | 1.00 | 17.89 | 0.53 |
| class: two capitalized words, second text | 23 | 429.74 ± 0.3% | 442.49 ± 0.4% | 573.23 ± 0.9% | 103.29 ± 0.4% | 507.99 ± 1.8% | 738.06 ± 0.4% | 6485.95 ± 0.5% | 429.23 ± 0.4% | 0.97 | 1.00 | 4.16 | 0.85 |
| other: a word between two words | 13 | 618.08 ± 0.9% | 629.50 ± 0.5% | 921.68 ± 0.1% | 134.60 ± 0.9% | 512.42 ± 1.4% | 813.30 ± 1.2% | 14775.44 ± 0.1% | 617.17 ± 0.7% | 0.98 | 1.00 | 4.59 | 1.21 |
| other: a number before a unit, second text | 15 | 533.05 ± 0.9% | 563.94 ± 0.6% | 790.62 ± 0.8% | 39.35 ± 0.4% | 638.37 ± 2.4% | 890.42 ± 0.6% | 15078.16 ± 0.1% | 532.76 ± 0.5% | 0.95 | 1.00 | 13.55 | 0.84 |
| other: a heading's start tag | 13 | 393.78 ± 0.3% | 399.12 ± 0.4% | 504.80 ± 0.3% | 44.57 ± 0.2% | 640.54 ± 0.9% | 865.47 ± 0.3% | 17987.87 ± 0.3% | 394.47 ± 0.2% | 0.99 | 1.00 | 8.84 | 0.61 |
| other: a whole word | 11 | 724.21 ± 0.7% | 743.07 ± 0.5% | 1204.90 ± 0.2% | 121.40 ± 0.8% | 567.72 ± 2.9% | 820.18 ± 1.5% | 26640.52 ± 0.1% | 723.59 ± 0.3% | 0.97 | 1.00 | 5.97 | 1.28 |
| other: a line's first word, second text | 17 | 582.62 ± 0.3% | 605.16 ± 0.3% | 871.47 ± 0.2% | 128.31 ± 0.2% | 716.08 ± 0.7% | refused | refused | 582.03 ± 0.5% | 0.96 | 1.00 | 4.54 | 0.81 |
| other: fourteen octets before an x | 16 | 116.43 ± 0.6% | 156.61 ± 0.8% | 179.91 ± 0.7% | 15.21 ± 0.4% | 457.55 ± 0.9% | 407.83 ± 0.7% | 12704.22 ± 0.8% | 116.39 ± 0.4% | 0.74 | 1.00 | 7.66 | 0.25 |
| other: a Greek word | 8 | 710.57 ± 0.6% | 760.92 ± 1.0% | 1218.47 ± 0.3% | 59.20 ± 0.2% | 1400.05 ± 0.7% | 1818.41 ± 0.6% | refused | 708.28 ± 0.4% | 0.93 | 1.00 | 12.00 | 0.51 |

