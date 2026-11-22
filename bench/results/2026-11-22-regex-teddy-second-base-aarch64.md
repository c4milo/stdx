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
| literal: a word | 217 | 15710.48 ± 1.0% | 1048.58 ± 0.2% | 28.73 ± 0.5% | 18595.75 ± 2.6% | 9253.28 ± 8.2% | 17.42 ± 0.5% | 86.64 ± 0.1% | 15745.70 ± 1.5% | 14.98 | 1.00 | 0.84 | 1.70 |
| literal: a word that is not there | 0 | 18766.32 ± 1.3% | 1059.15 ± 0.1% | 28.50 ± 0.4% | 19830.87 ± 0.2% | 29470.34 ± 1.0% | 17.21 ± 0.2% | 83.70 ± 0.4% | 18825.14 ± 1.5% | 17.72 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 4180.57 ± 0.1% | 1028.53 ± 0.1% | 14.91 ± 0.4% | 3980.67 ± 0.4% | 21.90 ± 0.2% | 5.24 ± 0.1% | 6.89 ± 0.6% | 4155.71 ± 0.3% | 4.06 | 1.01 | 1.05 | 190.92 |
| literal: a word in any case | 217 | 11589.54 ± 0.1% | 1048.14 ± 0.1% | 21.82 ± 1.3% | 3979.28 ± 0.6% | 38.62 ± 0.4% | refused | differs | 11595.84 ± 0.2% | 11.06 | 1.00 | 2.91 | 300.12 |
| literal: an href attribute | 33 | 16428.87 ± 0.4% | 1055.45 ± 0.1% | 27.41 ± 0.2% | 17184.46 ± 0.6% | 2263.33 ± 0.4% | 13.00 ± 0.1% | 76.14 ± 0.8% | 16454.38 ± 0.7% | 15.57 | 1.00 | 0.96 | 7.26 |
| literal: a word, second text | 123 | 15793.24 ± 0.5% | 1050.51 ± 0.2% | 27.86 ± 0.4% | 18612.56 ± 1.1% | 7658.03 ± 10.0% | 19.49 ± 0.4% | 70.51 ± 0.3% | 15809.31 ± 1.4% | 15.03 | 1.00 | 0.85 | 2.06 |
| class: two capitalized words | 1331 | 1101.79 ± 0.4% | 966.91 ± 0.2% | 26.47 ± 0.2% | 584.19 ± 0.0% | 40.95 ± 12.5% | 14.85 ± 0.3% | 69.63 ± 0.2% | 1101.61 ± 0.4% | 1.14 | 1.00 | 1.89 | 26.90 |
| class: a word that ends in ing | 3399 | 893.26 ± 0.1% | 894.59 ± 0.1% | 18.38 ± 0.1% | 548.02 ± 0.0% | 29.54 ± 9.4% | 8.16 ± 0.1% | 18.58 ± 0.4% | 892.53 ± 0.4% | 1.00 | 1.00 | 1.63 | 30.23 |
| class: a word in capitals | 2332 | 1481.41 ± 0.8% | 962.88 ± 0.1% | 27.51 ± 0.3% | 575.28 ± 0.0% | 43.77 ± 12.6% | 17.18 ± 0.3% | 84.13 ± 0.5% | 1479.80 ± 0.4% | 1.54 | 1.00 | 2.58 | 33.85 |
| class: a number | 8288 | 2114.26 ± 0.2% | 813.99 ± 0.3% | 27.99 ± 0.7% | 1809.24 ± 0.4% | 41.72 ± 16.6% | 0.56 ± 0.2% | 57.71 ± 0.1% | 2113.53 ± 0.1% | 2.60 | 1.00 | 1.17 | 50.68 |
| class: two capitalized words, second text | 5359 | 700.58 ± 0.5% | 701.19 ± 0.1% | 23.76 ± 0.1% | 491.12 ± 0.0% | 34.68 ± 15.2% | 16.90 ± 0.2% | 64.67 ± 0.1% | 700.74 ± 0.1% | 1.00 | 1.00 | 1.43 | 20.20 |
| other: a word between two words | 6104 | 741.99 ± 0.3% | 755.73 ± 0.1% | 23.83 ± 0.1% | 750.69 ± 0.4% | 101.83 ± 19.1% | 11.34 ± 0.1% | 70.24 ± 0.3% | 741.53 ± 0.4% | 0.98 | 1.00 | 0.99 | 7.29 |
| other: a number before a unit, second text | 1481 | 5436.81 ± 0.7% | 984.84 ± 0.6% | 26.24 ± 0.1% | 5900.07 ± 0.5% | 41.03 ± 16.3% | 17.84 ± 0.4% | 67.52 ± 0.2% | 5425.91 ± 0.8% | 5.52 | 1.00 | 0.92 | 132.50 |
| other: a heading's start tag | 110 | 12550.12 ± 0.4% | 1046.18 ± 0.1% | 27.08 ± 0.3% | 1719.77 ± 0.4% | 1585.02 ± 0.3% | 16.19 ± 0.4% | 90.49 ± 0.2% | 12551.99 ± 0.5% | 12.00 | 1.00 | 7.30 | 7.92 |
| other: a whole word | 217 | 13776.06 ± 0.4% | 1048.81 ± 0.1% | 29.92 ± 1.4% | 14851.81 ± 0.8% | 49.36 ± 0.1% | 13.51 ± 0.3% | 56.44 ± 0.5% | 13671.47 ± 0.5% | 13.14 | 1.01 | 0.93 | 279.10 |
| other: a line's first word, second text | 3716 | 1932.53 ± 0.3% | 870.24 ± 0.1% | 31.49 ± 0.4% | 1745.12 ± 0.5% | 62.34 ± 5.8% | refused | refused | 1923.76 ± 0.3% | 2.22 | 1.00 | 1.11 | 31.00 |
| other: fourteen octets before an x | 87 | 19316.35 ± 0.6% | 1.53 ± 0.1% | 1.53 ± 0.1% | 4010.00 ± 0.4% | 10.70 ± 0.3% | differs | 17.72 ± 0.2% | 19318.73 ± 0.4% | 12595.54 | 1.00 | 4.82 | 1805.42 |
| other: a Greek word | 21815 | 476.66 ± 1.3% | 323.89 ± 0.2% | 31.00 ± 0.2% | 294.74 ± 0.5% | 44.33 ± 10.6% | differs | refused | 473.74 ± 1.3% | 1.47 | 1.01 | 1.62 | 10.75 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.74 ± 0.1% | 28.62 ± 0.3% | 0.50 ± 0.1% | 21.20 ± 0.2% | 2.74 ± 0.8% | differs | 4.05 ± 0.2% | 28.74 ± 0.2% | 1.00 | 1.00 | 1.36 | 10.50 |
| a UUID | 32895 | 23.22 ± 0.0% | 23.21 ± 0.1% | 0.67 ± 0.1% | 16.02 ± 0.1% | 3.07 ± 0.8% | 0.72 ± 0.3% | 3.60 ± 0.4% | 23.23 ± 0.3% | 1.00 | 1.00 | 1.45 | 7.56 |
| an IPv4 address | 33176 | 42.47 ± 0.3% | 42.45 ± 0.4% | 2.18 ± 0.1% | 32.51 ± 0.2% | 6.69 ± 0.4% | differs | 4.12 ± 0.1% | 42.51 ± 0.2% | 1.00 | 1.00 | 1.31 | 6.35 |
| a date and time | 32954 | 35.38 ± 0.2% | 35.38 ± 0.1% | 1.51 ± 0.1% | 23.28 ± 0.1% | 7.06 ± 0.3% | 1.18 ± 0.1% | 7.09 ± 0.2% | 35.35 ± 0.2% | 1.00 | 1.00 | 1.52 | 5.01 |
| a field path | 32606 | 32.94 ± 0.3% | 32.98 ± 0.4% | 0.83 ± 0.1% | 25.36 ± 0.4% | 3.48 ± 1.4% | differs | 2.98 ± 0.2% | 32.95 ± 0.3% | 1.00 | 1.00 | 1.30 | 9.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.21 ± 0.5% | 10.22 ± 0.2% | 10.22 ± 0.4% | 11.31 ± 0.1% | 4.98 ± 1.8% | 0.90 ± 0.6% | none | 10.22 ± 0.3% | 1.00 | 1.00 | 0.90 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 293.33 ± 0.3% | 295.39 ± 0.2% | 351.08 ± 0.3% | 86.87 ± 0.2% | 222.10 ± 0.7% | 479.13 ± 0.5% | 3826.84 ± 0.6% | 293.49 ± 0.2% | 0.99 | 1.00 | 3.38 | 1.32 |
| a UUID | 62 | 215.69 ± 0.3% | 217.18 ± 0.6% | 251.12 ± 0.2% | 46.30 ± 0.3% | 99.96 ± 6.6% | 182.78 ± 2.2% | 4427.53 ± 1.0% | 215.60 ± 0.5% | 0.99 | 1.00 | 4.66 | 2.16 |
| an IPv4 address | 29 | 449.54 ± 1.0% | 454.86 ± 0.5% | 599.52 ± 0.5% | 76.62 ± 0.7% | 132.07 ± 1.1% | 290.81 ± 0.3% | 7505.96 ± 0.6% | 448.99 ± 0.4% | 0.99 | 1.00 | 5.87 | 3.40 |
| a date and time | 56 | 295.87 ± 0.5% | 297.60 ± 0.2% | 356.06 ± 0.3% | 72.64 ± 0.6% | 138.65 ± 1.9% | 316.03 ± 1.1% | 4954.88 ± 0.8% | 295.93 ± 0.5% | 0.99 | 1.00 | 4.07 | 2.13 |
| a field path | 39 | 328.78 ± 0.7% | 331.03 ± 0.4% | 403.06 ± 0.5% | 79.63 ± 0.4% | 206.93 ± 4.4% | 503.76 ± 2.0% | 4872.85 ± 1.6% | 328.79 ± 0.3% | 0.99 | 1.00 | 4.13 | 1.59 |
| literal: a word | 7 | 789.79 ± 0.6% | 815.93 ± 1.0% | 1411.85 ± 0.1% | 521.07 ± 0.2% | 634.43 ± 2.7% | 934.38 ± 0.5% | 29921.01 ± 0.6% | 788.72 ± 0.5% | 0.97 | 1.00 | 1.52 | 1.24 |
| literal: a word that is not there | 8 | 754.68 ± 0.3% | 777.48 ± 0.4% | 1320.96 ± 0.1% | 470.16 ± 0.2% | 609.39 ± 0.8% | 886.83 ± 0.5% | 28693.79 ± 0.3% | 755.04 ± 0.3% | 0.97 | 1.00 | 1.61 | 1.24 |
| literal: one of four words | 26 | 414.50 ± 1.0% | 451.76 ± 0.5% | 601.22 ± 0.2% | 49.05 ± 0.7% | 243.93 ± 0.9% | 362.18 ± 2.1% | 15392.17 ± 0.2% | 415.26 ± 0.7% | 0.92 | 1.00 | 8.45 | 1.70 |
| literal: a word in any case | 11 | 685.50 ± 0.1% | 711.39 ± 0.2% | 1151.55 ± 0.5% | 15.70 ± 0.3% | 671.13 ± 0.8% | refused | 23270.61 ± 0.2% | 684.31 ± 0.1% | 0.96 | 1.00 | 43.65 | 1.02 |
| literal: an href attribute | 12 | 410.03 ± 0.4% | 416.85 ± 0.5% | 542.20 ± 0.5% | 45.77 ± 0.4% | 505.52 ± 1.7% | 770.90 ± 0.3% | 21598.94 ± 0.2% | 409.98 ± 0.6% | 0.98 | 1.00 | 8.96 | 0.81 |
| literal: a word, second text | 10 | 702.94 ± 0.6% | 725.62 ± 0.7% | 1175.27 ± 0.1% | 422.09 ± 0.7% | 545.23 ± 2.1% | 802.02 ± 0.4% | 26617.18 ± 0.7% | 703.01 ± 0.3% | 0.97 | 1.00 | 1.67 | 1.29 |
| class: two capitalized words | 23 | 447.29 ± 1.1% | 461.08 ± 1.0% | 612.25 ± 1.5% | 100.37 ± 0.2% | 510.57 ± 0.4% | 744.04 ± 0.8% | 6513.37 ± 0.4% | 446.60 ± 0.8% | 0.97 | 1.00 | 4.46 | 0.88 |
| class: a word that ends in ing | 9 | 681.75 ± 0.8% | 727.70 ± 0.2% | 1170.38 ± 0.4% | 130.97 ± 1.0% | 764.98 ± 1.5% | 1097.31 ± 2.4% | 15846.45 ± 0.1% | 682.88 ± 0.5% | 0.94 | 1.00 | 5.21 | 0.89 |
| class: a word in capitals | 16 | 539.87 ± 0.5% | 557.64 ± 0.3% | 794.82 ± 0.2% | 134.57 ± 0.6% | 756.97 ± 1.8% | 1013.28 ± 0.4% | 8541.86 ± 0.8% | 537.69 ± 0.6% | 0.97 | 1.00 | 4.01 | 0.71 |
| class: a number | 6 | 762.44 ± 0.5% | 801.97 ± 0.3% | 1365.35 ± 0.1% | 41.85 ± 0.5% | 1416.44 ± 1.5% | 1911.90 ± 1.4% | 22494.70 ± 0.2% | 763.99 ± 0.5% | 0.95 | 1.00 | 18.22 | 0.54 |
| class: two capitalized words, second text | 23 | 446.34 ± 0.5% | 459.68 ± 0.6% | 610.51 ± 0.8% | 103.24 ± 0.4% | 507.22 ± 0.5% | 733.62 ± 0.6% | 6514.63 ± 0.2% | 446.08 ± 0.4% | 0.97 | 1.00 | 4.32 | 0.88 |
| other: a word between two words | 13 | 628.12 ± 0.3% | 639.97 ± 1.0% | 963.62 ± 0.2% | 134.24 ± 1.4% | 509.58 ± 1.3% | 805.04 ± 0.6% | 14722.65 ± 0.0% | 628.30 ± 0.4% | 0.98 | 1.00 | 4.68 | 1.23 |
| other: a number before a unit, second text | 15 | 539.23 ± 0.5% | 574.05 ± 0.3% | 823.34 ± 0.9% | 39.31 ± 0.4% | 638.15 ± 2.9% | 888.99 ± 0.3% | 15093.68 ± 0.2% | 539.05 ± 0.8% | 0.94 | 1.00 | 13.72 | 0.84 |
| other: a heading's start tag | 13 | 398.48 ± 0.5% | 402.45 ± 0.5% | 520.28 ± 0.7% | 44.60 ± 0.3% | 641.00 ± 0.8% | 865.93 ± 0.4% | 17911.89 ± 0.1% | 398.67 ± 0.4% | 0.99 | 1.00 | 8.93 | 0.62 |
| other: a whole word | 11 | 720.90 ± 0.3% | 743.68 ± 0.8% | 1201.45 ± 0.2% | 121.33 ± 0.8% | 569.73 ± 2.5% | 815.06 ± 1.0% | 26601.62 ± 0.3% | 720.52 ± 0.4% | 0.97 | 1.00 | 5.94 | 1.27 |
| other: a line's first word, second text | 17 | 598.20 ± 0.2% | 619.99 ± 0.9% | 911.07 ± 0.4% | 128.47 ± 0.1% | 718.33 ± 0.6% | refused | refused | 596.90 ± 0.7% | 0.96 | 1.00 | 4.66 | 0.83 |
| other: fourteen octets before an x | 16 | 115.76 ± 0.2% | 155.26 ± 0.3% | 183.09 ± 0.2% | 15.23 ± 0.2% | 460.16 ± 1.4% | 403.52 ± 0.4% | 12667.05 ± 0.2% | 115.67 ± 0.4% | 0.75 | 1.00 | 7.60 | 0.25 |
| other: a Greek word | 8 | 717.35 ± 0.5% | 772.78 ± 0.3% | 1266.60 ± 0.3% | 59.29 ± 0.4% | 1394.16 ± 5.3% | 1837.20 ± 0.6% | refused | 719.33 ± 0.4% | 0.93 | 1.00 | 12.10 | 0.51 |

