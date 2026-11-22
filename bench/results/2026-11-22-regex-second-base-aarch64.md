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
| Run URL | https://github.com/c4milo/stdx/actions/runs/44986665628 |
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
| literal: a word | 217 | 15713.72 ± 1.8% | 1040.35 ± 0.1% | 28.69 ± 0.2% | 18622.93 ± 0.7% | 9201.08 ± 9.1% | 17.31 ± 0.6% | 85.93 ± 0.3% | 15835.82 ± 1.7% | 15.10 | 0.99 | 0.84 | 1.71 |
| literal: a word that is not there | 0 | 18645.00 ± 0.7% | 1044.48 ± 0.2% | 28.50 ± 0.1% | 19865.34 ± 1.6% | 29289.98 ± 1.0% | 17.15 ± 0.3% | 81.95 ± 0.5% | 18658.04 ± 1.0% | 17.85 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 4150.76 ± 0.1% | 1020.62 ± 0.2% | 14.98 ± 0.2% | 3981.52 ± 0.2% | 21.93 ± 0.3% | 5.37 ± 0.4% | 6.75 ± 0.4% | 4144.52 ± 0.1% | 4.07 | 1.00 | 1.04 | 189.27 |
| literal: a word in any case | 217 | 11666.47 ± 0.2% | 1040.96 ± 0.3% | 21.93 ± 0.2% | 3985.35 ± 0.2% | 38.61 ± 0.1% | refused | differs | 11665.55 ± 0.1% | 11.21 | 1.00 | 2.93 | 302.16 |
| literal: an href attribute | 33 | 16298.56 ± 1.2% | 1048.27 ± 0.3% | 27.66 ± 0.2% | 17192.28 ± 0.7% | 2265.88 ± 0.4% | 13.19 ± 0.3% | 75.26 ± 0.5% | 16330.96 ± 1.0% | 15.55 | 1.00 | 0.95 | 7.19 |
| literal: a word, second text | 123 | 15934.88 ± 1.1% | 1042.06 ± 0.2% | 28.29 ± 0.2% | 18726.83 ± 1.2% | 7767.71 ± 4.8% | 20.12 ± 0.4% | 68.34 ± 0.3% | 15951.18 ± 2.4% | 15.29 | 1.00 | 0.85 | 2.05 |
| class: two capitalized words | 1331 | 1103.45 ± 0.5% | 960.74 ± 0.2% | 26.49 ± 0.1% | 587.50 ± 0.1% | 40.93 ± 7.5% | 14.78 ± 0.2% | 68.10 ± 0.7% | 1103.69 ± 0.2% | 1.15 | 1.00 | 1.88 | 26.96 |
| class: a word that ends in ing | 3399 | 883.56 ± 0.1% | 884.29 ± 0.1% | 18.50 ± 0.4% | 550.65 ± 0.1% | 29.58 ± 2.6% | 8.17 ± 0.2% | 18.25 ± 0.2% | 882.83 ± 0.1% | 1.00 | 1.00 | 1.60 | 29.87 |
| class: a word in capitals | 2332 | 1486.76 ± 0.4% | 960.32 ± 0.1% | 27.75 ± 0.1% | 575.37 ± 0.1% | 43.66 ± 0.6% | 17.21 ± 0.2% | 82.86 ± 0.3% | 1485.75 ± 0.1% | 1.55 | 1.00 | 2.58 | 34.05 |
| class: a number | 8288 | 2147.97 ± 0.5% | 809.40 ± 0.2% | 28.08 ± 0.1% | 1811.48 ± 0.3% | 41.73 ± 16.7% | 0.55 ± 0.3% | 56.61 ± 0.3% | 2146.73 ± 0.4% | 2.65 | 1.00 | 1.19 | 51.48 |
| class: two capitalized words, second text | 5359 | 698.64 ± 0.2% | 694.88 ± 0.3% | 23.84 ± 0.0% | 488.54 ± 0.1% | 33.59 ± 11.5% | 17.08 ± 0.2% | 63.35 ± 0.4% | 698.24 ± 0.2% | 1.01 | 1.00 | 1.43 | 20.80 |
| other: a word between two words | 6104 | 724.65 ± 0.1% | 753.61 ± 0.1% | 23.87 ± 0.1% | 753.72 ± 0.2% | 109.38 ± 13.7% | 11.19 ± 0.1% | 69.18 ± 0.4% | 724.03 ± 0.1% | 0.96 | 1.00 | 0.96 | 6.63 |
| other: a number before a unit, second text | 1481 | 5425.18 ± 0.4% | 980.33 ± 0.2% | 26.35 ± 0.2% | 5474.45 ± 0.3% | 40.98 ± 9.1% | 18.20 ± 0.2% | 66.78 ± 0.3% | 5415.51 ± 0.5% | 5.53 | 1.00 | 0.99 | 132.39 |
| other: a heading's start tag | 110 | 12519.39 ± 1.2% | 1042.36 ± 0.2% | 27.45 ± 0.2% | 1723.21 ± 0.3% | 1590.81 ± 6.0% | 16.04 ± 0.4% | 88.41 ± 0.2% | 12534.32 ± 0.5% | 12.01 | 1.00 | 7.27 | 7.87 |
| other: a whole word | 217 | 13800.33 ± 1.3% | 1041.73 ± 0.4% | 30.29 ± 0.6% | 14780.48 ± 1.4% | 49.35 ± 0.4% | 13.12 ± 0.1% | 55.67 ± 0.2% | 13925.62 ± 1.3% | 13.25 | 0.99 | 0.93 | 279.64 |
| other: a line's first word, second text | 3716 | 1773.29 ± 0.1% | 844.23 ± 0.1% | 31.83 ± 0.3% | 1606.93 ± 0.7% | 62.01 ± 6.9% | refused | refused | 1767.00 ± 0.3% | 2.10 | 1.00 | 1.10 | 28.59 |
| other: fourteen octets before an x | 87 | 13460.60 ± 0.7% | 1.53 ± 0.3% | 1.53 ± 0.2% | 4012.10 ± 0.2% | 10.67 ± 0.1% | differs | 17.69 ± 0.1% | 13484.37 ± 0.9% | 8791.39 | 1.00 | 3.35 | 1261.46 |
| other: a Greek word | 21815 | 473.34 ± 1.2% | 321.29 ± 0.4% | 31.43 ± 0.1% | 294.64 ± 0.2% | 44.53 ± 10.7% | differs | refused | 471.38 ± 0.9% | 1.47 | 1.00 | 1.61 | 10.63 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.76 ± 0.3% | 28.75 ± 0.4% | 0.50 ± 1.1% | 21.50 ± 0.0% | 2.75 ± 0.4% | differs | 4.01 ± 0.3% | 28.75 ± 0.1% | 1.00 | 1.00 | 1.34 | 10.46 |
| a UUID | 32895 | 23.45 ± 0.2% | 23.43 ± 0.3% | 0.67 ± 0.1% | 16.03 ± 0.2% | 3.09 ± 0.2% | 0.73 ± 0.3% | 3.59 ± 0.5% | 23.48 ± 0.1% | 1.00 | 1.00 | 1.46 | 7.58 |
| an IPv4 address | 33176 | 42.59 ± 0.4% | 42.63 ± 0.4% | 2.18 ± 0.2% | 32.80 ± 0.3% | 6.69 ± 0.5% | differs | 4.11 ± 0.1% | 42.65 ± 0.4% | 1.00 | 1.00 | 1.30 | 6.36 |
| a date and time | 32954 | 35.74 ± 0.5% | 35.76 ± 0.5% | 1.51 ± 0.1% | 23.32 ± 0.3% | 7.08 ± 0.4% | 1.25 ± 0.2% | 7.04 ± 0.1% | 35.74 ± 0.3% | 1.00 | 1.00 | 1.53 | 5.05 |
| a field path | 32606 | 33.34 ± 0.1% | 33.36 ± 0.2% | 0.83 ± 0.2% | 25.36 ± 0.2% | 3.53 ± 1.1% | differs | 2.94 ± 0.3% | 33.30 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.47 ± 0.3% | 10.49 ± 0.2% | 10.49 ± 0.3% | 11.70 ± 0.1% | 4.98 ± 1.4% | 0.94 ± 0.4% | none | 10.48 ± 0.4% | 1.00 | 1.00 | 0.89 | 2.10 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 295.41 ± 0.2% | 297.60 ± 0.3% | 353.54 ± 0.2% | 86.04 ± 0.7% | 224.28 ± 1.3% | 481.63 ± 0.6% | 3809.32 ± 3.6% | 295.34 ± 0.2% | 0.99 | 1.00 | 3.43 | 1.32 |
| a UUID | 62 | 216.01 ± 0.2% | 217.36 ± 0.4% | 251.47 ± 0.2% | 46.24 ± 0.7% | 100.48 ± 2.6% | 186.98 ± 3.0% | 4312.13 ± 0.9% | 216.12 ± 0.1% | 0.99 | 1.00 | 4.67 | 2.15 |
| an IPv4 address | 29 | 452.02 ± 0.2% | 455.19 ± 0.3% | 601.90 ± 0.3% | 76.13 ± 0.1% | 133.11 ± 1.0% | 300.35 ± 1.5% | 7653.71 ± 0.2% | 452.00 ± 0.2% | 0.99 | 1.00 | 5.94 | 3.40 |
| a date and time | 56 | 296.07 ± 0.2% | 298.15 ± 0.2% | 356.81 ± 0.2% | 72.22 ± 0.6% | 139.10 ± 1.4% | 323.13 ± 1.0% | 4957.83 ± 0.7% | 296.13 ± 0.1% | 0.99 | 1.00 | 4.10 | 2.13 |
| a field path | 39 | 330.93 ± 0.2% | 333.49 ± 0.1% | 406.95 ± 0.3% | 80.11 ± 1.1% | 208.02 ± 0.9% | 503.08 ± 2.9% | 4885.28 ± 0.8% | 330.74 ± 0.1% | 0.99 | 1.00 | 4.13 | 1.59 |
| literal: a word | 7 | 787.36 ± 0.3% | 819.50 ± 0.1% | 1417.79 ± 0.1% | 512.72 ± 0.3% | 631.11 ± 2.0% | 961.59 ± 0.6% | 30665.47 ± 0.2% | 787.34 ± 0.6% | 0.96 | 1.00 | 1.54 | 1.25 |
| literal: a word that is not there | 8 | 750.50 ± 0.4% | 782.94 ± 0.8% | 1325.91 ± 0.1% | 471.40 ± 0.2% | 603.98 ± 2.5% | 909.19 ± 0.3% | 29266.20 ± 0.2% | 750.06 ± 0.2% | 0.96 | 1.00 | 1.59 | 1.24 |
| literal: one of four words | 26 | 416.79 ± 0.1% | 454.67 ± 0.3% | 605.57 ± 0.3% | 49.48 ± 0.9% | 245.46 ± 2.2% | 374.37 ± 1.9% | 16062.51 ± 0.2% | 416.51 ± 0.3% | 0.92 | 1.00 | 8.42 | 1.70 |
| literal: a word in any case | 11 | 684.39 ± 0.3% | 712.71 ± 0.5% | 1154.46 ± 0.2% | 15.67 ± 1.7% | 666.78 ± 2.8% | refused | 23635.12 ± 0.6% | 684.75 ± 0.4% | 0.96 | 1.00 | 43.67 | 1.03 |
| literal: an href attribute | 12 | 413.54 ± 0.3% | 419.52 ± 0.6% | 544.53 ± 0.8% | 44.36 ± 0.5% | 509.20 ± 1.4% | 777.40 ± 1.4% | 22050.77 ± 0.4% | 413.47 ± 0.2% | 0.99 | 1.00 | 9.32 | 0.81 |
| literal: a word, second text | 10 | 702.05 ± 0.3% | 731.24 ± 0.5% | 1186.33 ± 0.1% | 393.73 ± 0.3% | 545.36 ± 9.1% | 803.16 ± 0.5% | 27285.96 ± 0.2% | 701.83 ± 0.6% | 0.96 | 1.00 | 1.78 | 1.29 |
| class: two capitalized words | 23 | 452.00 ± 0.3% | 465.43 ± 0.7% | 618.99 ± 0.4% | 98.71 ± 0.5% | 505.29 ± 1.2% | 747.71 ± 0.6% | 6490.27 ± 0.9% | 451.68 ± 0.5% | 0.97 | 1.00 | 4.58 | 0.89 |
| class: a word that ends in ing | 9 | 690.17 ± 0.2% | 731.53 ± 0.5% | 1181.03 ± 0.0% | 130.73 ± 1.7% | 755.53 ± 5.6% | 1105.09 ± 1.5% | 16037.16 ± 0.5% | 691.11 ± 0.6% | 0.94 | 1.00 | 5.28 | 0.91 |
| class: a word in capitals | 16 | 541.94 ± 0.4% | 562.11 ± 1.1% | 797.95 ± 0.1% | 133.44 ± 0.7% | 748.75 ± 2.5% | 1024.17 ± 1.7% | 8542.84 ± 0.8% | 541.75 ± 0.4% | 0.96 | 1.00 | 4.06 | 0.72 |
| class: a number | 6 | 767.94 ± 0.8% | 803.53 ± 0.3% | 1371.30 ± 0.2% | 41.51 ± 0.5% | 1399.13 ± 1.4% | 1854.26 ± 1.7% | 22714.99 ± 0.1% | 765.46 ± 0.3% | 0.96 | 1.00 | 18.50 | 0.55 |
| class: two capitalized words, second text | 23 | 451.59 ± 0.2% | 466.20 ± 0.5% | 619.39 ± 0.3% | 99.87 ± 0.5% | 503.71 ± 3.9% | 769.05 ± 0.3% | 6490.01 ± 1.2% | 451.99 ± 0.7% | 0.97 | 1.00 | 4.52 | 0.90 |
| other: a word between two words | 13 | 633.55 ± 0.2% | 647.74 ± 0.7% | 971.18 ± 0.3% | 131.61 ± 0.7% | 511.49 ± 2.4% | 815.09 ± 0.7% | 14870.77 ± 0.4% | 632.12 ± 0.4% | 0.98 | 1.00 | 4.81 | 1.24 |
| other: a number before a unit, second text | 15 | 544.32 ± 0.6% | 583.60 ± 0.5% | 834.90 ± 0.9% | 39.26 ± 0.3% | 637.91 ± 1.3% | 887.28 ± 1.2% | 15177.72 ± 0.2% | 544.19 ± 0.4% | 0.93 | 1.00 | 13.86 | 0.85 |
| other: a heading's start tag | 13 | 399.13 ± 0.7% | 403.98 ± 0.5% | 521.70 ± 0.6% | 43.44 ± 0.4% | 634.30 ± 1.6% | 879.86 ± 1.5% | 18360.73 ± 0.2% | 399.01 ± 0.3% | 0.99 | 1.00 | 9.19 | 0.63 |
| other: a whole word | 11 | 725.30 ± 0.5% | 748.70 ± 0.1% | 1220.72 ± 0.4% | 116.42 ± 0.6% | 559.36 ± 1.1% | 841.42 ± 0.5% | 27202.03 ± 0.3% | 725.40 ± 0.1% | 0.97 | 1.00 | 6.23 | 1.30 |
| other: a line's first word, second text | 17 | 606.89 ± 0.2% | 627.78 ± 0.2% | 927.27 ± 0.4% | 126.48 ± 0.3% | 710.65 ± 1.4% | refused | refused | 603.70 ± 1.0% | 0.97 | 1.01 | 4.80 | 0.85 |
| other: fourteen octets before an x | 16 | 116.08 ± 1.1% | 155.80 ± 1.2% | 183.67 ± 0.4% | 15.03 ± 0.2% | 451.66 ± 0.8% | 410.05 ± 0.5% | 13100.08 ± 0.6% | 115.85 ± 1.0% | 0.75 | 1.00 | 7.73 | 0.26 |
| other: a Greek word | 8 | 713.79 ± 0.3% | 769.66 ± 0.4% | 1271.06 ± 0.2% | 58.74 ± 0.6% | 1387.97 ± 1.1% | 1792.05 ± 0.5% | refused | 713.93 ± 0.5% | 0.93 | 1.00 | 12.15 | 0.51 |

