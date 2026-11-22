# bench-regex

| Field | Value |
|---|---|
| Commit | 988748a |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
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
| literal: a word | 217 | 29593.44 ± 0.5% | 867.69 ± 0.6% | 28.13 ± 0.7% | 25001.59 ± 0.5% | 8492.26 ± 6.1% | 12.30 ± 0.2% | 89.65 ± 1.3% | 29585.48 ± 1.2% | 34.11 | 1.00 | 1.18 | 3.48 |
| literal: a word that is not there | 0 | 39967.93 ± 2.1% | 944.49 ± 0.9% | 25.96 ± 0.2% | 27152.33 ± 1.9% | 23474.37 ± 0.6% | 12.04 ± 0.3% | 85.72 ± 1.9% | 40014.91 ± 0.6% | 42.32 | 1.00 | 1.47 | 1.70 |
| literal: one of four words | 661 | 6678.94 ± 1.1% | 814.68 ± 0.1% | 14.73 ± 0.7% | 7993.46 ± 2.1% | 20.58 ± 1.2% | 3.74 ± 0.5% | 7.19 ± 1.7% | 6662.36 ± 1.6% | 8.20 | 1.00 | 0.84 | 324.61 |
| literal: a word in any case | 217 | 23662.70 ± 0.7% | 865.30 ± 0.5% | 20.67 ± 0.7% | 8239.60 ± 0.8% | 41.62 ± 3.2% | refused | differs | 23453.71 ± 0.8% | 27.35 | 1.01 | 2.87 | 568.60 |
| literal: an href attribute | 33 | 30250.97 ± 2.6% | 889.39 ± 1.2% | 25.29 ± 1.6% | 23017.87 ± 5.2% | 1910.16 ± 3.9% | 8.95 ± 3.2% | 79.07 ± 2.0% | 30256.79 ± 0.4% | 34.01 | 1.00 | 1.31 | 15.84 |
| literal: a word, second text | 123 | 31157.20 ± 2.2% | 846.17 ± 0.9% | 27.81 ± 0.9% | 24680.37 ± 5.8% | 6688.90 ± 4.5% | 15.11 ± 0.7% | 75.93 ± 2.4% | 31050.78 ± 0.3% | 36.82 | 1.00 | 1.26 | 4.66 |
| class: two capitalized words | 1331 | 868.28 ± 0.8% | 757.90 ± 0.6% | 26.38 ± 0.7% | 545.48 ± 0.3% | 36.95 ± 0.7% | 10.45 ± 0.4% | 65.05 ± 1.3% | 865.07 ± 1.3% | 1.15 | 1.00 | 1.59 | 23.50 |
| class: a word that ends in ing | 3399 | 699.12 ± 0.6% | 697.95 ± 0.8% | 17.62 ± 0.4% | 504.67 ± 0.5% | 27.13 ± 4.1% | 5.82 ± 0.8% | 18.28 ± 0.3% | 699.21 ± 0.7% | 1.00 | 1.00 | 1.39 | 25.77 |
| class: a word in capitals | 2332 | 1139.26 ± 0.6% | 745.05 ± 0.4% | 24.97 ± 2.1% | 535.36 ± 0.3% | 36.67 ± 11.2% | 12.39 ± 0.2% | 81.95 ± 3.1% | 1138.46 ± 0.5% | 1.53 | 1.00 | 2.13 | 31.06 |
| class: a number | 8288 | 1680.16 ± 0.3% | 638.53 ± 0.5% | 25.84 ± 0.7% | 1692.30 ± 0.4% | 39.76 ± 3.7% | 0.36 ± 0.2% | 59.22 ± 0.9% | 1681.86 ± 0.6% | 2.63 | 1.00 | 0.99 | 42.26 |
| class: two capitalized words, second text | 5359 | 562.93 ± 1.2% | 559.61 ± 1.0% | 23.80 ± 0.3% | 443.94 ± 1.1% | 32.43 ± 8.8% | 13.13 ± 1.7% | 59.93 ± 1.0% | 562.45 ± 0.8% | 1.01 | 1.00 | 1.27 | 17.36 |
| other: a word between two words | 6104 | 751.34 ± 1.5% | 597.01 ± 0.8% | 23.24 ± 0.1% | 735.50 ± 1.8% | 105.43 ± 11.7% | 8.00 ± 0.1% | 69.49 ± 0.6% | 750.57 ± 0.2% | 1.26 | 1.00 | 1.02 | 7.13 |
| other: a number before a unit, second text | 1481 | 8111.56 ± 2.7% | 772.24 ± 0.3% | 26.23 ± 0.3% | 7068.81 ± 0.9% | 37.44 ± 0.7% | 13.87 ± 1.9% | 61.58 ± 0.4% | 8020.74 ± 2.8% | 10.50 | 1.01 | 1.15 | 216.63 |
| other: a heading's start tag | 110 | 18747.84 ± 0.6% | 841.26 ± 0.9% | 26.98 ± 0.7% | 2040.22 ± 0.4% | 1363.79 ± 4.6% | 11.06 ± 0.4% | 91.01 ± 1.0% | 18716.64 ± 0.4% | 22.29 | 1.00 | 9.19 | 13.75 |
| other: a whole word | 217 | 22660.63 ± 2.6% | 865.38 ± 0.6% | 28.57 ± 0.2% | 19790.16 ± 0.8% | 45.94 ± 8.9% | 10.51 ± 0.3% | 52.93 ± 1.1% | 22663.87 ± 3.6% | 26.19 | 1.00 | 1.15 | 493.31 |
| other: a line's first word, second text | 3716 | 2212.55 ± 5.2% | 697.00 ± 1.5% | 30.61 ± 1.4% | 1843.11 ± 2.6% | 59.70 ± 2.5% | refused | refused | 2199.12 ± 2.1% | 3.17 | 1.01 | 1.20 | 37.06 |
| other: fourteen octets before an x | 87 | 32067.06 ± 5.1% | 1.45 ± 0.4% | 1.43 ± 0.5% | 3592.77 ± 0.3% | 9.22 ± 2.3% | differs | 17.62 ± 0.8% | 31889.25 ± 0.7% | 22130.53 | 1.01 | 8.93 | 3477.18 |
| other: a Greek word | 21815 | 412.43 ± 1.0% | 277.49 ± 1.7% | 30.38 ± 0.5% | 261.37 ± 0.7% | 42.19 ± 30.0% | differs | refused | 413.62 ± 0.8% | 1.49 | 1.00 | 1.58 | 9.78 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.17 ± 1.9% | 25.11 ± 1.8% | 0.51 ± 0.5% | 23.62 ± 0.3% | 2.46 ± 0.6% | differs | 4.18 ± 0.7% | 25.25 ± 0.3% | 1.00 | 1.00 | 1.07 | 10.22 |
| a UUID | 32895 | 20.10 ± 0.6% | 19.60 ± 0.3% | 0.62 ± 2.7% | 19.01 ± 0.4% | 2.47 ± 0.4% | 0.54 ± 1.4% | 3.27 ± 0.5% | 20.08 ± 0.4% | 1.03 | 1.00 | 1.06 | 8.13 |
| an IPv4 address | 33176 | 34.69 ± 0.5% | 34.87 ± 0.4% | 2.01 ± 0.3% | 30.48 ± 0.7% | 5.84 ± 0.9% | differs | 3.95 ± 6.2% | 35.12 ± 0.9% | 0.99 | 0.99 | 1.14 | 5.94 |
| a date and time | 32954 | 29.93 ± 0.5% | 29.91 ± 0.7% | 1.37 ± 0.4% | 28.41 ± 0.2% | 7.03 ± 0.6% | 0.95 ± 0.9% | 7.73 ± 0.4% | 29.84 ± 0.4% | 1.00 | 1.00 | 1.05 | 4.26 |
| a field path | 32606 | 27.92 ± 1.5% | 28.33 ± 2.0% | 0.82 ± 1.2% | 26.24 ± 0.4% | 2.83 ± 0.6% | differs | 2.61 ± 0.1% | 28.28 ± 1.1% | 0.99 | 0.99 | 1.06 | 9.85 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.67 ± 3.6% | 9.68 ± 3.3% | 9.67 ± 3.3% | 11.37 ± 0.6% | 4.71 ± 0.9% | 0.77 ± 0.5% | none | 9.60 ± 2.8% | 1.00 | 1.01 | 0.85 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 289.58 ± 0.4% | 291.41 ± 1.3% | 337.80 ± 3.3% | 85.50 ± 3.3% | 180.76 ± 5.5% | 547.82 ± 4.3% | 3287.97 ± 1.6% | 288.67 ± 5.5% | 0.99 | 1.00 | 3.39 | 1.60 |
| a UUID | 62 | 210.58 ± 0.4% | 211.30 ± 0.8% | 239.14 ± 0.6% | 47.23 ± 0.8% | 84.67 ± 30.0% | 196.14 ± 2.6% | 3873.36 ± 1.0% | 210.53 ± 0.7% | 1.00 | 1.00 | 4.46 | 2.49 |
| an IPv4 address | 29 | 448.92 ± 0.4% | 453.33 ± 0.2% | 580.29 ± 0.7% | 75.12 ± 1.2% | 111.44 ± 2.3% | 320.89 ± 1.8% | 6772.70 ± 0.9% | 449.05 ± 0.3% | 0.99 | 1.00 | 5.98 | 4.03 |
| a date and time | 56 | 303.83 ± 1.1% | 305.91 ± 6.8% | 356.26 ± 0.8% | 73.06 ± 2.4% | 116.57 ± 12.4% | 359.89 ± 0.4% | 4149.02 ± 1.4% | 304.35 ± 7.4% | 0.99 | 1.00 | 4.16 | 2.61 |
| a field path | 39 | 334.76 ± 7.0% | 337.89 ± 0.4% | 402.32 ± 0.7% | 76.38 ± 2.6% | 171.64 ± 2.5% | 534.64 ± 1.5% | 4108.04 ± 0.8% | 334.47 ± 0.7% | 0.99 | 1.00 | 4.38 | 1.95 |
| literal: a word | 7 | 845.71 ± 0.8% | 875.82 ± 0.5% | 1458.89 ± 0.7% | 502.87 ± 1.0% | 537.00 ± 2.9% | 1215.94 ± 0.6% | 27031.28 ± 0.2% | 846.14 ± 0.5% | 0.97 | 1.00 | 1.68 | 1.57 |
| literal: a word that is not there | 8 | 790.37 ± 4.6% | 819.44 ± 0.3% | 1329.24 ± 0.7% | 468.05 ± 1.0% | 513.00 ± 22.7% | 1138.43 ± 1.5% | 25471.79 ± 0.9% | 791.57 ± 1.0% | 0.96 | 1.00 | 1.69 | 1.54 |
| literal: one of four words | 26 | 426.88 ± 2.4% | 466.29 ± 0.9% | 594.23 ± 0.5% | 43.71 ± 0.2% | 209.81 ± 6.5% | 436.05 ± 4.6% | 12949.27 ± 3.2% | 426.09 ± 4.2% | 0.92 | 1.00 | 9.77 | 2.03 |
| literal: a word in any case | 11 | 751.77 ± 0.8% | 785.46 ± 0.4% | 1205.44 ± 0.3% | 14.22 ± 1.6% | 556.34 ± 2.9% | refused | 20095.83 ± 1.3% | 750.80 ± 0.4% | 0.96 | 1.00 | 52.87 | 1.35 |
| literal: an href attribute | 12 | 406.30 ± 0.3% | 412.00 ± 1.2% | 518.04 ± 1.4% | 37.42 ± 1.3% | 412.27 ± 0.8% | 889.20 ± 1.0% | 18832.54 ± 2.0% | 405.81 ± 0.7% | 0.99 | 1.00 | 10.86 | 0.99 |
| literal: a word, second text | 10 | 739.13 ± 4.6% | 765.30 ± 0.5% | 1185.63 ± 0.4% | 420.47 ± 4.8% | 446.96 ± 22.1% | 948.15 ± 1.6% | 23151.56 ± 4.5% | 739.34 ± 0.5% | 0.97 | 1.00 | 1.76 | 1.65 |
| class: two capitalized words | 23 | 480.97 ± 0.3% | 492.96 ± 2.2% | 636.49 ± 0.5% | 103.75 ± 1.3% | 427.78 ± 2.5% | 875.51 ± 5.4% | 5971.88 ± 1.0% | 480.37 ± 0.2% | 0.98 | 1.00 | 4.64 | 1.12 |
| class: a word that ends in ing | 9 | 737.26 ± 0.8% | 784.51 ± 0.7% | 1197.33 ± 0.8% | 127.36 ± 1.0% | 611.85 ± 3.6% | 1316.55 ± 1.4% | 14762.51 ± 0.4% | 736.86 ± 0.7% | 0.94 | 1.00 | 5.79 | 1.20 |
| class: a word in capitals | 16 | 582.69 ± 0.6% | 601.84 ± 1.7% | 818.47 ± 0.7% | 134.89 ± 0.6% | 618.92 ± 2.3% | 1207.94 ± 1.0% | 7966.59 ± 0.3% | 583.12 ± 0.3% | 0.97 | 1.00 | 4.32 | 0.94 |
| class: a number | 6 | 844.22 ± 0.4% | 889.00 ± 0.8% | 1434.62 ± 1.0% | 36.55 ± 1.1% | 1137.81 ± 1.0% | 2279.33 ± 5.0% | 20362.07 ± 1.4% | 845.10 ± 0.3% | 0.95 | 1.00 | 23.10 | 0.74 |
| class: two capitalized words, second text | 23 | 481.01 ± 0.5% | 493.97 ± 0.4% | 635.48 ± 0.7% | 103.57 ± 0.7% | 423.73 ± 14.6% | 896.18 ± 3.3% | 5961.64 ± 2.0% | 480.48 ± 0.4% | 0.97 | 1.00 | 4.64 | 1.14 |
| other: a word between two words | 13 | 662.28 ± 0.7% | 678.89 ± 0.4% | 967.53 ± 0.3% | 134.05 ± 1.1% | 418.76 ± 30.0% | 947.35 ± 0.8% | 13069.48 ± 0.9% | 663.00 ± 0.5% | 0.98 | 1.00 | 4.94 | 1.58 |
| other: a number before a unit, second text | 15 | 567.48 ± 0.2% | 610.61 ± 0.2% | 839.48 ± 0.2% | 34.40 ± 0.7% | 518.36 ± 18.6% | 1029.36 ± 3.4% | 12929.51 ± 0.7% | 567.79 ± 0.1% | 0.93 | 1.00 | 16.50 | 1.09 |
| other: a heading's start tag | 13 | 396.96 ± 0.4% | 401.09 ± 0.3% | 500.79 ± 0.4% | 36.40 ± 0.5% | 510.89 ± 18.8% | 1009.57 ± 2.7% | 16021.72 ± 0.2% | 396.38 ± 0.4% | 0.99 | 1.00 | 10.91 | 0.78 |
| other: a whole word | 11 | 744.65 ± 0.4% | 768.24 ± 1.1% | 1178.00 ± 0.6% | 118.17 ± 4.9% | 468.56 ± 8.5% | 996.39 ± 1.5% | 23109.73 ± 0.9% | 743.81 ± 0.9% | 0.97 | 1.00 | 6.30 | 1.59 |
| other: a line's first word, second text | 17 | 630.97 ± 0.6% | 664.06 ± 0.6% | 943.68 ± 0.5% | 127.15 ± 0.7% | 580.27 ± 1.6% | refused | refused | 629.99 ± 1.1% | 0.95 | 1.00 | 4.96 | 1.09 |
| other: fourteen octets before an x | 16 | 105.89 ± 0.5% | 136.75 ± 0.5% | 159.55 ± 0.6% | 15.14 ± 2.0% | 364.28 ± 5.6% | 454.57 ± 1.5% | 12059.77 ± 4.6% | 105.78 ± 0.4% | 0.77 | 1.00 | 6.99 | 0.29 |
| other: a Greek word | 8 | 740.74 ± 1.2% | 797.16 ± 4.6% | 1244.70 ± 0.4% | 45.38 ± 0.3% | 1116.00 ± 2.5% | 2168.92 ± 1.2% | refused | 740.16 ± 1.1% | 0.93 | 1.00 | 16.32 | 0.66 |

