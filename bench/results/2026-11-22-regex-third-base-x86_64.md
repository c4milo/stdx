# bench-regex

| Field | Value |
|---|---|
| Commit | 1b0002a |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
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
| literal: a word | 217 | 35167.80 ± 2.9% | 895.54 ± 0.5% | 19.90 ± 3.0% | 33050.94 ± 1.0% | 8929.19 ± 9.2% | 10.73 ± 0.2% | 76.11 ± 0.4% | 34560.48 ± 0.4% | 39.27 | 1.02 | 1.06 | 3.94 |
| literal: a word that is not there | 0 | 52032.88 ± 21.5% | 906.55 ± 5.2% | 19.77 ± 5.4% | 35958.79 ± 15.8% | 30076.00 ± 1.7% | 10.66 ± 0.3% | 72.03 ± 2.1% | 51345.02 ± 0.9% | 57.40 | 1.01 | 1.45 | 1.73 |
| literal: one of four words | 661 | 6213.68 ± 0.4% | 871.46 ± 0.1% | 11.01 ± 1.4% | 9551.65 ± 0.4% | 18.76 ± 10.5% | 3.98 ± 2.1% | 6.51 ± 3.7% | 6225.15 ± 0.5% | 7.13 | 1.00 | 0.65 | 331.21 |
| literal: a word in any case | 217 | 27083.24 ± 2.1% | 893.99 ± 0.1% | 15.23 ± 1.1% | 9329.78 ± 0.9% | 36.77 ± 0.7% | refused | differs | 26926.81 ± 3.1% | 30.29 | 1.01 | 2.90 | 736.66 |
| literal: an href attribute | 33 | 35310.05 ± 2.0% | 902.49 ± 0.9% | 18.30 ± 2.3% | 25067.32 ± 0.4% | 2060.10 ± 0.8% | 8.23 ± 0.5% | 67.08 ± 0.7% | 35059.64 ± 0.3% | 39.12 | 1.01 | 1.41 | 17.14 |
| literal: a word, second text | 123 | 35351.55 ± 1.9% | 898.93 ± 0.0% | 19.87 ± 1.8% | 28530.52 ± 0.9% | 7203.75 ± 6.7% | 11.80 ± 0.4% | 65.73 ± 1.1% | 35297.74 ± 2.0% | 39.33 | 1.00 | 1.24 | 4.91 |
| class: two capitalized words | 1331 | 776.24 ± 0.3% | 817.63 ± 1.1% | 18.52 ± 4.2% | 507.30 ± 0.7% | 33.75 ± 13.4% | 9.29 ± 0.1% | 59.37 ± 9.7% | 775.47 ± 0.6% | 0.95 | 1.00 | 1.53 | 23.00 |
| class: a word that ends in ing | 3399 | 739.98 ± 0.2% | 740.11 ± 0.1% | 13.10 ± 5.7% | 474.34 ± 0.5% | 25.43 ± 5.9% | 5.32 ± 0.1% | 17.11 ± 0.3% | 740.35 ± 0.2% | 1.00 | 1.00 | 1.56 | 29.10 |
| class: a word in capitals | 2332 | 983.62 ± 0.4% | 800.32 ± 0.1% | 19.35 ± 1.2% | 499.12 ± 0.6% | 35.87 ± 10.6% | 10.26 ± 0.3% | 77.12 ± 0.7% | 984.02 ± 0.3% | 1.23 | 1.00 | 1.97 | 27.42 |
| class: a number | 8288 | 1508.61 ± 2.1% | 660.87 ± 1.3% | 19.43 ± 2.8% | 1525.82 ± 7.5% | 36.32 ± 14.5% | 0.33 ± 0.3% | 56.52 ± 2.5% | 1503.92 ± 1.9% | 2.28 | 1.00 | 0.99 | 41.54 |
| class: two capitalized words, second text | 5359 | 584.85 ± 0.2% | 584.32 ± 0.3% | 17.06 ± 1.6% | 420.95 ± 4.7% | 29.74 ± 55.6% | 10.43 ± 0.2% | 54.38 ± 1.7% | 585.37 ± 0.4% | 1.00 | 1.00 | 1.39 | 19.67 |
| other: a word between two words | 6104 | 698.00 ± 0.3% | 628.19 ± 0.4% | 16.89 ± 8.0% | 723.94 ± 3.2% | 101.12 ± 8.2% | 7.24 ± 0.4% | 60.72 ± 12.2% | 698.21 ± 0.2% | 1.11 | 1.00 | 0.96 | 6.90 |
| other: a number before a unit, second text | 1481 | 7622.05 ± 0.9% | 830.29 ± 0.9% | 18.59 ± 2.5% | 6914.36 ± 5.6% | 34.30 ± 3.0% | 10.80 ± 0.4% | 59.35 ± 0.8% | 7555.63 ± 0.7% | 9.18 | 1.01 | 1.10 | 222.24 |
| other: a heading's start tag | 110 | 19691.49 ± 2.0% | 894.34 ± 0.2% | 19.27 ± 9.9% | 2042.53 ± 1.5% | 1473.48 ± 3.4% | 10.00 ± 0.3% | 78.73 ± 1.0% | 19441.76 ± 7.0% | 22.02 | 1.01 | 9.64 | 13.36 |
| other: a whole word | 217 | 24014.26 ± 1.3% | 894.57 ± 0.2% | 19.44 ± 10.2% | 23497.04 ± 1.2% | 41.08 ± 1.3% | 9.53 ± 8.4% | 46.02 ± 4.5% | 23790.86 ± 1.3% | 26.84 | 1.01 | 1.02 | 584.59 |
| other: a line's first word, second text | 3716 | 1841.47 ± 0.6% | 726.62 ± 0.2% | 21.08 ± 2.2% | 1769.42 ± 2.4% | 54.51 ± 16.8% | refused | refused | 1841.05 ± 5.3% | 2.53 | 1.00 | 1.04 | 33.78 |
| other: fourteen octets before an x | 87 | 23169.42 ± 2.7% | 1.28 ± 0.8% | 1.36 ± 0.8% | 2943.43 ± 0.8% | 9.07 ± 0.5% | differs | 16.99 ± 6.8% | 23393.89 ± 2.2% | 18133.82 | 0.99 | 7.87 | 2553.74 |
| other: a Greek word | 21815 | 394.62 ± 0.6% | 273.13 ± 0.5% | 23.15 ± 1.0% | 268.88 ± 0.8% | 44.02 ± 10.0% | differs | refused | 393.51 ± 1.6% | 1.44 | 1.00 | 1.47 | 8.96 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.74 ± 0.4% | 26.76 ± 0.8% | 0.46 ± 1.3% | 20.09 ± 0.1% | 2.33 ± 0.4% | differs | 3.45 ± 2.5% | 26.82 ± 1.1% | 1.00 | 1.00 | 1.33 | 11.46 |
| a UUID | 32895 | 22.02 ± 0.8% | 22.00 ± 0.3% | 0.55 ± 9.8% | 14.72 ± 0.8% | 2.44 ± 0.6% | 0.44 ± 0.5% | 3.16 ± 2.6% | 22.05 ± 0.1% | 1.00 | 1.00 | 1.50 | 9.03 |
| an IPv4 address | 33176 | 38.45 ± 1.8% | 38.08 ± 2.3% | 1.79 ± 6.2% | 30.03 ± 2.2% | 5.48 ± 3.6% | differs | 3.28 ± 4.3% | 37.89 ± 1.5% | 1.01 | 1.01 | 1.28 | 7.02 |
| a date and time | 32954 | 33.13 ± 0.1% | 33.28 ± 8.4% | 1.27 ± 4.0% | 21.80 ± 1.1% | 6.24 ± 2.8% | 0.76 ± 0.2% | 6.04 ± 1.3% | 33.26 ± 0.5% | 1.00 | 1.00 | 1.52 | 5.31 |
| a field path | 32606 | 30.22 ± 7.6% | 30.23 ± 7.8% | 0.73 ± 3.7% | 23.45 ± 0.1% | 2.87 ± 1.2% | differs | 2.33 ± 1.0% | 30.13 ± 0.4% | 1.00 | 1.00 | 1.29 | 10.52 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.09 ± 13.0% | 7.75 ± 6.7% | 7.82 ± 2.8% | 10.55 ± 0.1% | 4.47 ± 2.7% | 0.63 ± 0.6% | none | 7.85 ± 4.2% | 0.91 | 0.90 | 0.67 | 1.59 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 251.03 ± 1.3% | 251.06 ± 0.3% | 294.31 ± 0.3% | 79.81 ± 3.7% | 183.45 ± 2.6% | 523.06 ± 5.1% | 3824.50 ± 11.6% | 250.49 ± 2.5% | 1.00 | 1.00 | 3.15 | 1.37 |
| a UUID | 62 | 178.27 ± 1.1% | 178.65 ± 1.4% | 203.76 ± 1.2% | 46.21 ± 1.9% | 89.87 ± 3.1% | 196.37 ± 3.0% | 4119.82 ± 1.3% | 178.86 ± 0.7% | 1.00 | 1.00 | 3.86 | 1.98 |
| an IPv4 address | 29 | 407.00 ± 0.3% | 409.88 ± 0.8% | 536.93 ± 0.8% | 68.94 ± 1.3% | 112.61 ± 1.6% | 315.22 ± 1.8% | 7174.93 ± 0.3% | 407.58 ± 0.3% | 0.99 | 1.00 | 5.90 | 3.61 |
| a date and time | 56 | 264.36 ± 0.2% | 265.57 ± 0.2% | 314.04 ± 0.4% | 67.67 ± 2.5% | 123.79 ± 0.7% | 371.87 ± 5.0% | 4296.08 ± 0.9% | 263.90 ± 0.2% | 1.00 | 1.00 | 3.91 | 2.14 |
| a field path | 39 | 288.20 ± 0.3% | 289.08 ± 0.2% | 344.84 ± 0.9% | 73.88 ± 2.2% | 172.16 ± 0.8% | 581.20 ± 12.7% | 4909.35 ± 0.8% | 288.21 ± 0.5% | 1.00 | 1.00 | 3.90 | 1.67 |
| literal: a word | 7 | 723.48 ± 0.9% | 748.49 ± 0.6% | 1264.53 ± 0.7% | 502.54 ± 0.7% | 580.37 ± 1.9% | 1228.28 ± 0.6% | 25108.55 ± 0.9% | 724.02 ± 0.3% | 0.97 | 1.00 | 1.44 | 1.25 |
| literal: a word that is not there | 8 | 682.95 ± 0.3% | 706.14 ± 1.8% | 1179.52 ± 0.9% | 463.13 ± 0.5% | 559.17 ± 3.2% | 1123.57 ± 1.0% | 23931.24 ± 1.8% | 682.70 ± 0.3% | 0.97 | 1.00 | 1.47 | 1.22 |
| literal: one of four words | 26 | 379.41 ± 1.0% | 410.49 ± 0.5% | 539.58 ± 0.5% | 44.89 ± 0.7% | 218.85 ± 1.9% | 447.85 ± 2.0% | 12709.93 ± 1.4% | 379.13 ± 1.2% | 0.92 | 1.00 | 8.45 | 1.73 |
| literal: a word in any case | 11 | 632.95 ± 1.0% | 660.36 ± 0.3% | 1049.61 ± 0.6% | 14.80 ± 1.1% | 603.55 ± 3.4% | refused | 20076.13 ± 0.9% | 629.55 ± 0.6% | 0.96 | 1.01 | 42.78 | 1.05 |
| literal: an href attribute | 12 | 371.64 ± 0.9% | 375.20 ± 0.4% | 482.79 ± 0.7% | 36.91 ± 0.9% | 424.59 ± 1.3% | 928.37 ± 1.8% | 19226.18 ± 0.9% | 371.82 ± 0.4% | 0.99 | 1.00 | 10.07 | 0.88 |
| literal: a word, second text | 10 | 642.77 ± 1.2% | 666.99 ± 1.3% | 1061.57 ± 1.9% | 413.98 ± 0.7% | 482.75 ± 3.5% | 982.13 ± 9.3% | 22117.83 ± 4.2% | 643.15 ± 0.4% | 0.96 | 1.00 | 1.55 | 1.33 |
| class: two capitalized words | 23 | 397.86 ± 0.3% | 407.80 ± 0.5% | 526.04 ± 0.3% | 94.11 ± 0.4% | 444.77 ± 3.3% | 921.15 ± 3.3% | 6457.22 ± 0.3% | 397.93 ± 0.7% | 0.98 | 1.00 | 4.23 | 0.89 |
| class: a word that ends in ing | 9 | 628.53 ± 6.1% | 665.92 ± 8.1% | 1042.67 ± 0.9% | 111.64 ± 1.1% | 627.63 ± 2.3% | 1395.34 ± 0.6% | 15255.51 ± 10.4% | 625.85 ± 13.6% | 0.94 | 1.00 | 5.63 | 1.00 |
| class: a word in capitals | 16 | 478.20 ± 0.4% | 496.38 ± 0.5% | 676.58 ± 0.2% | 118.53 ± 1.9% | 642.73 ± 14.9% | 1272.81 ± 18.6% | 8466.63 ± 15.4% | 478.18 ± 0.4% | 0.96 | 1.00 | 4.03 | 0.74 |
| class: a number | 6 | 697.34 ± 0.9% | 733.97 ± 0.4% | 1209.17 ± 0.2% | 36.73 ± 1.7% | 1164.28 ± 1.8% | 2179.18 ± 2.8% | 20692.38 ± 0.5% | 697.97 ± 0.5% | 0.95 | 1.00 | 18.99 | 0.60 |
| class: two capitalized words, second text | 23 | 397.38 ± 2.5% | 408.48 ± 2.7% | 525.23 ± 2.0% | 93.66 ± 3.5% | 444.83 ± 5.2% | 907.03 ± 2.8% | 6382.34 ± 2.3% | 397.39 ± 1.8% | 0.97 | 1.00 | 4.24 | 0.89 |
| other: a word between two words | 13 | 571.58 ± 0.4% | 580.24 ± 1.3% | 846.24 ± 0.5% | 121.54 ± 1.4% | 433.36 ± 3.4% | 1021.20 ± 10.3% | 14260.27 ± 2.3% | 571.30 ± 0.7% | 0.99 | 1.00 | 4.70 | 1.32 |
| other: a number before a unit, second text | 15 | 492.75 ± 0.2% | 525.19 ± 1.4% | 732.23 ± 7.8% | 34.29 ± 0.7% | 531.74 ± 12.3% | 1085.28 ± 3.0% | 13748.24 ± 1.1% | 492.32 ± 0.3% | 0.94 | 1.00 | 14.37 | 0.93 |
| other: a heading's start tag | 13 | 359.76 ± 0.3% | 362.30 ± 0.4% | 465.22 ± 1.1% | 35.30 ± 1.3% | 522.69 ± 0.5% | 1060.54 ± 1.0% | 16510.25 ± 2.8% | 359.82 ± 5.6% | 0.99 | 1.00 | 10.19 | 0.69 |
| other: a whole word | 11 | 622.00 ± 1.9% | 635.37 ± 1.5% | 995.78 ± 3.1% | 113.03 ± 8.4% | 497.20 ± 1.4% | 1046.17 ± 1.5% | 21812.12 ± 4.3% | 624.33 ± 1.6% | 0.98 | 1.00 | 5.50 | 1.25 |
| other: a line's first word, second text | 17 | 551.05 ± 1.0% | 576.93 ± 0.8% | 832.88 ± 9.1% | 114.02 ± 1.0% | 586.04 ± 13.9% | refused | refused | 550.85 ± 0.6% | 0.96 | 1.00 | 4.83 | 0.94 |
| other: fourteen octets before an x | 16 | 92.70 ± 2.8% | 117.58 ± 4.4% | 135.85 ± 4.7% | 14.14 ± 0.6% | 392.79 ± 2.4% | 451.50 ± 0.5% | 12248.44 ± 0.8% | 92.49 ± 2.0% | 0.79 | 1.00 | 6.56 | 0.24 |
| other: a Greek word | 8 | 654.09 ± 0.8% | 697.74 ± 0.9% | 1161.26 ± 0.2% | 46.40 ± 2.4% | 1129.78 ± 11.6% | 2097.16 ± 0.6% | refused | 654.84 ± 0.1% | 0.94 | 1.00 | 14.10 | 0.58 |

