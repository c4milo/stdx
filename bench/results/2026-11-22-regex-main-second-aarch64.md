# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054920956 |
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
| literal: a word | 217 | 15216.04 ± 1.1% | 1039.83 ± 0.2% | 28.60 ± 0.4% | 17768.12 ± 2.5% | 9054.30 ± 9.7% | 17.23 ± 0.3% | 84.08 ± 0.7% | 15251.66 ± 2.1% | 14.63 | 1.00 | 0.86 | 1.68 |
| literal: a word that is not there | 0 | 17996.75 ± 1.6% | 1045.97 ± 0.6% | 28.58 ± 0.2% | 19199.10 ± 3.9% | 27991.13 ± 4.7% | 17.03 ± 0.2% | 79.23 ± 0.4% | 18136.28 ± 2.4% | 17.21 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 5759.81 ± 0.5% | 1017.51 ± 0.2% | 15.01 ± 0.3% | 3976.06 ± 0.1% | 21.87 ± 0.1% | 5.34 ± 0.3% | 6.87 ± 0.6% | 5733.03 ± 0.6% | 5.66 | 1.00 | 1.45 | 263.41 |
| literal: a word in any case | 217 | 11457.19 ± 1.2% | 1037.76 ± 0.1% | 21.65 ± 2.2% | 3980.51 ± 0.2% | 38.77 ± 0.7% | refused | differs | 11423.38 ± 1.1% | 11.04 | 1.00 | 2.88 | 295.55 |
| literal: an href attribute | 33 | 16000.05 ± 1.2% | 1045.22 ± 0.2% | 27.76 ± 0.2% | 16680.99 ± 2.0% | 2260.19 ± 0.6% | 13.16 ± 0.2% | 73.79 ± 0.3% | 16167.18 ± 2.3% | 15.31 | 0.99 | 0.96 | 7.08 |
| literal: a word, second text | 123 | 15603.97 ± 1.1% | 1042.53 ± 0.3% | 28.35 ± 0.2% | 18084.57 ± 3.4% | 7598.38 ± 7.9% | 20.15 ± 0.4% | 69.77 ± 0.6% | 15746.26 ± 2.0% | 14.97 | 0.99 | 0.86 | 2.05 |
| class: two capitalized words | 1331 | 1108.64 ± 0.3% | 956.95 ± 0.1% | 26.37 ± 0.3% | 587.18 ± 0.1% | 40.85 ± 8.9% | 14.70 ± 0.2% | 66.42 ± 1.8% | 1109.02 ± 0.5% | 1.16 | 1.00 | 1.89 | 27.14 |
| class: a word that ends in ing | 3399 | 883.70 ± 0.2% | 884.94 ± 0.2% | 18.46 ± 0.2% | 550.21 ± 0.1% | 29.51 ± 9.3% | 8.15 ± 0.1% | 18.17 ± 0.4% | 883.35 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.94 |
| class: a word in capitals | 2332 | 1472.26 ± 0.4% | 952.07 ± 0.1% | 27.93 ± 0.7% | 574.92 ± 0.1% | 43.73 ± 14.3% | 17.22 ± 0.3% | 82.42 ± 0.7% | 1474.82 ± 0.3% | 1.55 | 1.00 | 2.56 | 33.67 |
| class: a number | 8288 | 2122.74 ± 0.6% | 806.85 ± 0.2% | 28.17 ± 0.6% | 1805.69 ± 0.3% | 38.74 ± 15.4% | 0.54 ± 0.1% | 57.07 ± 1.0% | 2119.19 ± 0.4% | 2.63 | 1.00 | 1.18 | 54.80 |
| class: two capitalized words, second text | 5359 | 693.43 ± 0.2% | 695.50 ± 0.2% | 23.69 ± 0.3% | 489.42 ± 0.1% | 35.48 ± 15.4% | 17.14 ± 0.4% | 62.51 ± 0.4% | 693.57 ± 0.1% | 1.00 | 1.00 | 1.42 | 19.54 |
| other: a word between two words | 6104 | 725.54 ± 0.2% | 748.20 ± 0.2% | 23.88 ± 0.4% | 755.37 ± 0.6% | 108.44 ± 21.2% | 11.20 ± 0.1% | 68.03 ± 0.3% | 725.40 ± 0.2% | 0.97 | 1.00 | 0.96 | 6.69 |
| other: a number before a unit, second text | 1481 | 5473.95 ± 0.8% | 979.05 ± 0.1% | 26.27 ± 0.5% | 5879.30 ± 0.9% | 40.90 ± 0.1% | 18.24 ± 0.3% | 65.39 ± 0.3% | 5460.60 ± 0.7% | 5.59 | 1.00 | 0.93 | 133.84 |
| other: a heading's start tag | 110 | 12259.27 ± 0.9% | 1035.35 ± 0.1% | 27.52 ± 0.2% | 1720.47 ± 0.1% | 1587.19 ± 3.1% | 16.03 ± 0.3% | 86.06 ± 0.4% | 12275.74 ± 1.5% | 11.84 | 1.00 | 7.13 | 7.72 |
| other: a whole word | 217 | 13585.48 ± 0.9% | 1038.95 ± 0.1% | 30.28 ± 0.2% | 14616.50 ± 1.8% | 49.45 ± 0.3% | 13.24 ± 0.1% | 54.80 ± 0.5% | 13565.97 ± 0.8% | 13.08 | 1.00 | 0.93 | 274.73 |
| other: a line's first word, second text | 3716 | 1966.69 ± 0.4% | 862.76 ± 0.1% | 31.99 ± 0.6% | 1737.77 ± 0.4% | 62.19 ± 6.7% | refused | refused | 1958.67 ± 0.7% | 2.28 | 1.00 | 1.13 | 31.62 |
| other: fourteen octets before an x | 87 | 18676.07 ± 0.5% | 1.53 ± 0.1% | 1.53 ± 0.1% | 3955.15 ± 0.6% | 10.69 ± 0.2% | differs | 17.76 ± 0.2% | 18572.76 ± 0.9% | 12195.10 | 1.01 | 4.72 | 1746.64 |
| other: a Greek word | 21815 | 479.73 ± 1.0% | 323.26 ± 0.4% | 31.49 ± 0.3% | 294.65 ± 0.4% | 48.89 ± 11.4% | differs | refused | 478.47 ± 0.7% | 1.48 | 1.00 | 1.63 | 9.81 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.10 ± 0.1% | 28.10 ± 0.5% | 0.50 ± 0.2% | 21.53 ± 0.2% | 2.76 ± 0.7% | differs | 4.01 ± 0.2% | 28.08 ± 0.2% | 1.00 | 1.00 | 1.30 | 10.18 |
| a UUID | 32895 | 23.09 ± 0.1% | 23.08 ± 0.2% | 0.67 ± 0.1% | 16.06 ± 0.1% | 3.08 ± 0.6% | 0.73 ± 0.3% | 3.64 ± 0.3% | 23.10 ± 0.1% | 1.00 | 1.00 | 1.44 | 7.49 |
| an IPv4 address | 33176 | 41.45 ± 0.2% | 41.46 ± 0.3% | 2.18 ± 0.2% | 32.75 ± 0.1% | 6.66 ± 0.2% | differs | 4.06 ± 0.2% | 41.46 ± 0.1% | 1.00 | 1.00 | 1.27 | 6.22 |
| a date and time | 32954 | 34.89 ± 0.2% | 34.93 ± 0.3% | 1.51 ± 0.2% | 23.24 ± 0.3% | 7.04 ± 0.2% | 1.26 ± 0.4% | 7.14 ± 0.6% | 34.88 ± 0.2% | 1.00 | 1.00 | 1.50 | 4.95 |
| a field path | 32606 | 32.22 ± 0.5% | 32.28 ± 0.2% | 0.83 ± 0.2% | 25.34 ± 0.5% | 3.46 ± 0.9% | differs | 2.93 ± 0.2% | 32.24 ± 0.5% | 1.00 | 1.00 | 1.27 | 9.31 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.18 ± 0.2% | 10.19 ± 0.1% | 10.19 ± 0.3% | 11.72 ± 0.1% | 4.96 ± 1.3% | 0.94 ± 0.4% | none | 10.18 ± 0.5% | 1.00 | 1.00 | 0.87 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.81 ± 0.7% | 226.65 ± 0.2% | 256.59 ± 0.1% | 85.38 ± 0.5% | 221.05 ± 1.1% | 477.47 ± 0.4% | 3845.82 ± 0.5% | 225.77 ± 0.1% | 1.00 | 1.00 | 2.64 | 1.02 |
| a UUID | 62 | 170.30 ± 0.1% | 170.72 ± 0.2% | 189.29 ± 0.1% | 46.00 ± 0.6% | 98.05 ± 3.0% | 186.55 ± 3.4% | 4468.00 ± 0.2% | 170.19 ± 0.2% | 1.00 | 1.00 | 3.70 | 1.74 |
| an IPv4 address | 29 | 347.67 ± 0.4% | 349.03 ± 0.2% | 427.70 ± 0.4% | 75.73 ± 0.3% | 129.74 ± 2.1% | 296.50 ± 1.4% | 7600.74 ± 0.2% | 347.46 ± 0.3% | 1.00 | 1.00 | 4.59 | 2.68 |
| a date and time | 56 | 266.16 ± 0.4% | 267.80 ± 0.2% | 311.72 ± 0.3% | 71.91 ± 0.5% | 134.72 ± 19.3% | 324.86 ± 0.8% | 4912.30 ± 0.5% | 266.07 ± 0.5% | 0.99 | 1.00 | 3.70 | 1.98 |
| a field path | 39 | 232.57 ± 0.3% | 232.98 ± 0.1% | 265.90 ± 0.2% | 79.45 ± 1.2% | 204.43 ± 0.7% | 499.39 ± 3.9% | 4926.27 ± 0.9% | 232.47 ± 0.1% | 1.00 | 1.00 | 2.93 | 1.14 |
| literal: a word | 7 | 480.15 ± 0.3% | 490.76 ± 0.2% | 660.38 ± 0.2% | 511.56 ± 0.1% | 624.52 ± 2.2% | 947.37 ± 0.8% | 29736.69 ± 0.1% | 479.89 ± 0.2% | 0.98 | 1.00 | 0.94 | 0.77 |
| literal: a word that is not there | 8 | 469.39 ± 0.5% | 479.52 ± 0.4% | 640.46 ± 0.2% | 469.43 ± 0.2% | 595.25 ± 1.8% | 895.60 ± 0.5% | 28641.04 ± 0.5% | 469.70 ± 0.1% | 0.98 | 1.00 | 1.00 | 0.79 |
| literal: one of four words | 26 | 312.81 ± 0.2% | 333.04 ± 0.3% | 406.08 ± 0.3% | 49.66 ± 1.3% | 238.04 ± 2.6% | 371.92 ± 1.3% | 15435.95 ± 0.2% | 312.95 ± 0.3% | 0.94 | 1.00 | 6.30 | 1.31 |
| literal: a word in any case | 11 | 272.44 ± 0.4% | 275.88 ± 0.5% | 324.45 ± 0.5% | 15.75 ± 1.5% | 637.99 ± 3.4% | refused | 23299.99 ± 0.4% | 272.27 ± 0.4% | 0.99 | 1.00 | 17.30 | 0.43 |
| literal: an href attribute | 12 | 331.92 ± 0.9% | 334.33 ± 0.7% | 408.17 ± 0.8% | 44.83 ± 0.6% | 493.92 ± 1.6% | 765.28 ± 0.9% | 21380.83 ± 0.2% | 331.37 ± 1.1% | 0.99 | 1.00 | 7.40 | 0.67 |
| literal: a word, second text | 10 | 448.34 ± 0.2% | 458.59 ± 0.4% | 606.61 ± 0.1% | 391.56 ± 0.1% | 530.23 ± 1.7% | 794.32 ± 0.7% | 26519.87 ± 0.2% | 448.23 ± 0.2% | 0.98 | 1.00 | 1.15 | 0.85 |
| class: two capitalized words | 23 | 361.67 ± 0.4% | 370.07 ± 0.7% | 460.15 ± 0.7% | 98.18 ± 0.8% | 494.69 ± 1.8% | 740.38 ± 0.6% | 6489.76 ± 0.5% | 361.64 ± 0.4% | 0.98 | 1.00 | 3.68 | 0.73 |
| class: a word that ends in ing | 9 | 455.53 ± 0.5% | 474.71 ± 0.2% | 630.42 ± 0.1% | 130.10 ± 2.1% | 749.16 ± 1.4% | 1080.47 ± 0.6% | 15847.28 ± 0.2% | 455.26 ± 0.5% | 0.96 | 1.00 | 3.50 | 0.61 |
| class: a word in capitals | 16 | 406.17 ± 0.4% | 418.14 ± 0.4% | 534.08 ± 0.3% | 133.18 ± 0.7% | 742.45 ± 1.3% | 1000.16 ± 1.6% | 8550.29 ± 0.5% | 406.42 ± 0.6% | 0.97 | 1.00 | 3.05 | 0.55 |
| class: a number | 6 | 490.23 ± 0.5% | 506.81 ± 0.2% | 683.44 ± 0.1% | 41.44 ± 0.6% | 1383.54 ± 1.5% | 1858.60 ± 1.6% | 22487.37 ± 0.1% | 490.05 ± 0.2% | 0.97 | 1.00 | 11.83 | 0.35 |
| class: two capitalized words, second text | 23 | 361.18 ± 0.4% | 369.96 ± 0.3% | 459.78 ± 0.7% | 99.21 ± 0.3% | 494.59 ± 1.9% | 758.67 ± 0.5% | 6477.94 ± 0.7% | 361.56 ± 0.4% | 0.98 | 1.00 | 3.64 | 0.73 |
| other: a word between two words | 13 | 429.98 ± 0.2% | 435.17 ± 0.4% | 563.50 ± 0.4% | 131.02 ± 0.6% | 496.84 ± 0.8% | 806.91 ± 0.3% | 14722.89 ± 0.1% | 429.98 ± 0.2% | 0.99 | 1.00 | 3.28 | 0.87 |
| other: a number before a unit, second text | 15 | 370.98 ± 0.2% | 387.22 ± 0.6% | 487.45 ± 0.1% | 39.15 ± 0.3% | 624.50 ± 1.9% | 880.34 ± 1.4% | 15068.71 ± 0.1% | 370.70 ± 0.2% | 0.96 | 1.00 | 9.48 | 0.59 |
| other: a heading's start tag | 13 | 333.17 ± 0.4% | 335.49 ± 0.3% | 410.33 ± 0.4% | 43.52 ± 0.3% | 628.31 ± 1.0% | 872.45 ± 1.6% | 17903.50 ± 0.2% | 332.90 ± 0.3% | 0.99 | 1.00 | 7.66 | 0.53 |
| other: a whole word | 11 | 455.57 ± 0.2% | 462.15 ± 0.2% | 610.18 ± 0.3% | 116.06 ± 0.7% | 555.09 ± 1.6% | 824.89 ± 0.6% | 26572.19 ± 0.3% | 455.51 ± 0.1% | 0.99 | 1.00 | 3.93 | 0.82 |
| other: a line's first word, second text | 17 | 422.54 ± 0.4% | 433.51 ± 0.3% | 559.00 ± 0.3% | 126.28 ± 0.2% | 696.81 ± 2.1% | refused | refused | 422.23 ± 0.2% | 0.97 | 1.00 | 3.35 | 0.61 |
| other: fourteen octets before an x | 16 | 111.34 ± 1.3% | 146.92 ± 1.4% | 167.57 ± 1.4% | 15.03 ± 0.3% | 443.19 ± 1.1% | 399.31 ± 0.7% | 12870.44 ± 0.4% | 111.24 ± 0.6% | 0.76 | 1.00 | 7.41 | 0.25 |
| other: a Greek word | 8 | 473.37 ± 0.2% | 494.32 ± 0.3% | 664.07 ± 0.4% | 58.73 ± 0.1% | 1362.99 ± 0.8% | 1825.42 ± 0.3% | refused | 473.93 ± 0.1% | 0.96 | 1.00 | 8.06 | 0.35 |

