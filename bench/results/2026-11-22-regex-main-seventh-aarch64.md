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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45058341871 |
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
| literal: a word | 217 | 15584.58 ± 1.1% | 1040.56 ± 0.1% | 28.60 ± 0.4% | 18216.59 ± 4.4% | 9146.31 ± 9.0% | 17.43 ± 0.4% | 84.44 ± 0.3% | 15611.58 ± 0.9% | 14.98 | 1.00 | 0.86 | 1.70 |
| literal: a word that is not there | 0 | 18352.11 ± 2.1% | 1047.76 ± 0.6% | 28.61 ± 0.3% | 19346.84 ± 2.2% | 28476.71 ± 1.8% | 17.14 ± 0.3% | 79.83 ± 0.5% | 18488.07 ± 2.5% | 17.52 | 0.99 | 0.95 | 0.64 |
| literal: one of four words | 661 | 5776.03 ± 0.4% | 1018.10 ± 0.6% | 15.02 ± 0.2% | 3975.48 ± 0.4% | 21.86 ± 0.2% | 5.44 ± 0.3% | 6.89 ± 0.5% | 5779.83 ± 0.6% | 5.67 | 1.00 | 1.45 | 264.26 |
| literal: a word in any case | 217 | 11581.62 ± 0.2% | 1038.02 ± 0.5% | 21.57 ± 1.9% | 3979.29 ± 0.2% | 38.43 ± 0.9% | refused | differs | 11577.06 ± 0.3% | 11.16 | 1.00 | 2.91 | 301.34 |
| literal: an href attribute | 33 | 16208.24 ± 2.1% | 1046.11 ± 0.3% | 27.71 ± 0.4% | 16964.15 ± 3.0% | 2259.36 ± 0.5% | 13.11 ± 0.2% | 74.12 ± 2.5% | 16246.05 ± 1.9% | 15.49 | 1.00 | 0.96 | 7.17 |
| literal: a word, second text | 123 | 15887.43 ± 1.1% | 1043.51 ± 0.1% | 28.26 ± 0.3% | 18615.81 ± 0.7% | 7659.21 ± 4.2% | 20.19 ± 0.3% | 70.34 ± 0.5% | 15982.88 ± 0.7% | 15.23 | 0.99 | 0.85 | 2.07 |
| class: two capitalized words | 1331 | 1111.08 ± 0.3% | 956.94 ± 0.1% | 26.38 ± 0.2% | 587.20 ± 0.0% | 40.87 ± 3.8% | 14.75 ± 0.4% | 67.26 ± 1.6% | 1109.17 ± 0.4% | 1.16 | 1.00 | 1.89 | 27.18 |
| class: a word that ends in ing | 3399 | 884.64 ± 0.1% | 885.79 ± 0.1% | 18.45 ± 0.2% | 550.60 ± 0.1% | 29.57 ± 7.9% | 8.19 ± 0.2% | 18.22 ± 0.3% | 883.80 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.92 |
| class: a word in capitals | 2332 | 1476.60 ± 0.6% | 953.52 ± 0.1% | 27.91 ± 0.1% | 575.04 ± 0.1% | 43.77 ± 13.7% | 17.21 ± 0.3% | 82.70 ± 0.2% | 1476.23 ± 0.3% | 1.55 | 1.00 | 2.57 | 33.74 |
| class: a number | 8288 | 2125.69 ± 0.4% | 807.33 ± 0.1% | 28.10 ± 0.2% | 1792.57 ± 0.3% | 40.28 ± 13.4% | 0.53 ± 0.7% | 57.78 ± 0.2% | 2121.98 ± 0.2% | 2.63 | 1.00 | 1.19 | 52.77 |
| class: two capitalized words, second text | 5359 | 694.22 ± 0.2% | 696.32 ± 0.1% | 23.70 ± 0.1% | 489.72 ± 0.1% | 34.24 ± 14.4% | 17.13 ± 0.3% | 62.72 ± 0.9% | 693.88 ± 0.1% | 1.00 | 1.00 | 1.42 | 20.27 |
| other: a word between two words | 6104 | 722.31 ± 0.1% | 748.46 ± 0.2% | 23.86 ± 0.1% | 754.97 ± 0.4% | 104.15 ± 19.4% | 11.20 ± 0.2% | 68.25 ± 2.2% | 726.47 ± 0.4% | 0.97 | 0.99 | 0.96 | 6.94 |
| other: a number before a unit, second text | 1481 | 5480.83 ± 0.4% | 979.88 ± 0.1% | 26.29 ± 0.1% | 5946.10 ± 0.3% | 40.97 ± 16.3% | 18.23 ± 0.4% | 65.51 ± 0.2% | 5471.80 ± 0.6% | 5.59 | 1.00 | 0.92 | 133.78 |
| other: a heading's start tag | 110 | 12383.02 ± 0.5% | 1035.85 ± 0.1% | 27.48 ± 0.1% | 1724.35 ± 0.2% | 1592.76 ± 0.8% | 16.07 ± 0.5% | 86.40 ± 0.8% | 12394.41 ± 0.8% | 11.95 | 1.00 | 7.18 | 7.77 |
| other: a whole word | 217 | 13620.99 ± 0.6% | 1040.01 ± 0.1% | 30.05 ± 0.4% | 14638.18 ± 1.6% | 49.38 ± 0.1% | 13.32 ± 0.1% | 55.24 ± 0.2% | 13715.22 ± 0.6% | 13.10 | 0.99 | 0.93 | 275.83 |
| other: a line's first word, second text | 3716 | 1966.60 ± 0.4% | 863.09 ± 0.1% | 31.85 ± 0.2% | 1753.16 ± 0.5% | 62.30 ± 5.9% | refused | refused | 1958.21 ± 0.5% | 2.28 | 1.00 | 1.12 | 31.57 |
| other: fourteen octets before an x | 87 | 19065.91 ± 1.1% | 1.53 ± 0.5% | 1.53 ± 0.6% | 3969.24 ± 0.1% | 10.68 ± 0.2% | differs | 17.78 ± 0.3% | 19154.50 ± 1.1% | 12469.55 | 1.00 | 4.80 | 1785.18 |
| other: a Greek word | 21815 | 479.86 ± 0.5% | 311.24 ± 0.2% | 31.51 ± 0.2% | 293.89 ± 0.3% | 44.21 ± 8.2% | differs | refused | 476.96 ± 0.4% | 1.54 | 1.01 | 1.63 | 10.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.97 ± 0.2% | 27.96 ± 0.1% | 0.50 ± 0.1% | 21.64 ± 0.2% | 2.76 ± 0.5% | differs | 4.02 ± 0.1% | 27.97 ± 0.1% | 1.00 | 1.00 | 1.29 | 10.13 |
| a UUID | 32895 | 23.24 ± 0.2% | 23.22 ± 0.1% | 0.66 ± 0.1% | 16.08 ± 0.1% | 3.10 ± 0.3% | 0.73 ± 0.3% | 3.64 ± 0.7% | 23.23 ± 0.1% | 1.00 | 1.00 | 1.45 | 7.49 |
| an IPv4 address | 33176 | 41.44 ± 0.3% | 41.40 ± 0.2% | 2.17 ± 0.1% | 32.80 ± 0.2% | 6.68 ± 0.1% | differs | 4.07 ± 0.1% | 41.45 ± 0.1% | 1.00 | 1.00 | 1.26 | 6.21 |
| a date and time | 32954 | 34.79 ± 0.2% | 34.82 ± 0.1% | 1.50 ± 0.2% | 23.51 ± 0.1% | 7.05 ± 0.1% | 1.25 ± 0.2% | 7.11 ± 0.4% | 34.81 ± 0.3% | 1.00 | 1.00 | 1.48 | 4.93 |
| a field path | 32606 | 32.32 ± 0.2% | 32.33 ± 0.3% | 0.83 ± 0.1% | 25.31 ± 0.1% | 3.49 ± 1.1% | differs | 2.91 ± 0.2% | 32.28 ± 0.2% | 1.00 | 1.00 | 1.28 | 9.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.17 ± 0.2% | 10.17 ± 0.3% | 10.16 ± 0.2% | 11.54 ± 0.2% | 4.96 ± 2.7% | 0.93 ± 0.6% | none | 10.17 ± 0.2% | 1.00 | 1.00 | 0.88 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.65 ± 0.2% | 226.76 ± 0.2% | 256.93 ± 0.2% | 85.70 ± 0.4% | 220.58 ± 1.1% | 487.02 ± 0.4% | 3748.42 ± 3.4% | 225.71 ± 0.2% | 1.00 | 1.00 | 2.63 | 1.02 |
| a UUID | 62 | 169.89 ± 0.3% | 170.49 ± 0.2% | 188.93 ± 0.2% | 46.34 ± 0.7% | 97.60 ± 6.3% | 188.95 ± 3.2% | 4461.03 ± 0.5% | 169.95 ± 0.3% | 1.00 | 1.00 | 3.67 | 1.74 |
| an IPv4 address | 29 | 346.91 ± 0.4% | 349.80 ± 0.3% | 427.88 ± 0.2% | 76.72 ± 0.2% | 131.06 ± 1.7% | 299.21 ± 1.9% | 7626.92 ± 0.3% | 346.98 ± 0.4% | 0.99 | 1.00 | 4.52 | 2.65 |
| a date and time | 56 | 265.69 ± 0.5% | 266.87 ± 0.4% | 310.18 ± 0.2% | 72.79 ± 0.3% | 135.80 ± 7.5% | 331.87 ± 0.9% | 4935.02 ± 0.5% | 265.50 ± 0.3% | 1.00 | 1.00 | 3.65 | 1.96 |
| a field path | 39 | 232.37 ± 0.3% | 232.98 ± 0.3% | 266.16 ± 0.3% | 80.97 ± 1.3% | 205.33 ± 1.2% | 507.47 ± 2.0% | 4933.06 ± 3.0% | 232.28 ± 0.6% | 1.00 | 1.00 | 2.87 | 1.13 |
| literal: a word | 7 | 478.02 ± 0.7% | 488.03 ± 0.3% | 656.07 ± 0.4% | 501.30 ± 0.2% | 629.14 ± 1.6% | 964.13 ± 0.4% | 29745.51 ± 0.3% | 478.23 ± 0.5% | 0.98 | 1.00 | 0.95 | 0.76 |
| literal: a word that is not there | 8 | 468.46 ± 0.3% | 477.78 ± 0.3% | 637.64 ± 0.2% | 467.70 ± 0.1% | 604.66 ± 1.7% | 921.62 ± 0.3% | 28919.90 ± 0.2% | 468.25 ± 0.4% | 0.98 | 1.00 | 1.00 | 0.77 |
| literal: one of four words | 26 | 311.79 ± 0.2% | 332.51 ± 0.1% | 404.51 ± 0.2% | 49.76 ± 0.9% | 241.32 ± 1.4% | 376.11 ± 0.8% | 15539.53 ± 0.2% | 311.83 ± 0.2% | 0.94 | 1.00 | 6.27 | 1.29 |
| literal: a word in any case | 11 | 271.07 ± 0.2% | 274.75 ± 0.4% | 322.92 ± 0.1% | 15.63 ± 0.2% | 643.07 ± 2.7% | refused | 23416.68 ± 0.4% | 270.99 ± 0.1% | 0.99 | 1.00 | 17.34 | 0.42 |
| literal: an href attribute | 12 | 332.20 ± 0.4% | 334.13 ± 0.6% | 408.18 ± 0.2% | 45.55 ± 1.2% | 501.01 ± 2.5% | 782.64 ± 1.3% | 21460.18 ± 0.2% | 332.07 ± 0.3% | 0.99 | 1.00 | 7.29 | 0.66 |
| literal: a word, second text | 10 | 445.67 ± 0.2% | 456.82 ± 0.2% | 602.83 ± 0.1% | 400.38 ± 0.5% | 535.02 ± 2.7% | 803.48 ± 0.2% | 26846.41 ± 0.1% | 446.17 ± 0.2% | 0.98 | 1.00 | 1.11 | 0.83 |
| class: two capitalized words | 23 | 361.55 ± 0.5% | 370.43 ± 0.3% | 459.93 ± 0.4% | 99.35 ± 0.7% | 499.54 ± 2.0% | 750.65 ± 1.2% | 6498.83 ± 0.2% | 361.75 ± 0.2% | 0.98 | 1.00 | 3.64 | 0.72 |
| class: a word that ends in ing | 9 | 455.68 ± 0.2% | 475.43 ± 0.3% | 631.23 ± 0.3% | 132.55 ± 0.7% | 761.98 ± 0.8% | 1103.67 ± 2.3% | 15830.96 ± 0.1% | 455.62 ± 0.3% | 0.96 | 1.00 | 3.44 | 0.60 |
| class: a word in capitals | 16 | 407.08 ± 0.2% | 418.29 ± 0.4% | 534.08 ± 0.1% | 135.26 ± 0.7% | 757.24 ± 0.8% | 1032.26 ± 1.2% | 8576.12 ± 0.7% | 407.02 ± 0.1% | 0.97 | 1.00 | 3.01 | 0.54 |
| class: a number | 6 | 491.10 ± 0.6% | 505.62 ± 0.7% | 683.44 ± 0.1% | 41.89 ± 0.6% | 1409.77 ± 1.6% | 1862.79 ± 0.9% | 22718.73 ± 0.1% | 491.18 ± 0.3% | 0.97 | 1.00 | 11.72 | 0.35 |
| class: two capitalized words, second text | 23 | 360.97 ± 0.7% | 370.25 ± 0.4% | 459.30 ± 0.6% | 103.60 ± 0.5% | 502.34 ± 0.7% | 747.05 ± 0.7% | 6499.02 ± 0.2% | 361.52 ± 0.4% | 0.97 | 1.00 | 3.48 | 0.72 |
| other: a word between two words | 13 | 429.04 ± 0.3% | 433.66 ± 0.2% | 560.49 ± 0.2% | 132.45 ± 1.6% | 507.21 ± 1.4% | 809.97 ± 1.4% | 14757.53 ± 0.6% | 429.81 ± 0.4% | 0.99 | 1.00 | 3.24 | 0.85 |
| other: a number before a unit, second text | 15 | 372.54 ± 0.2% | 389.03 ± 0.4% | 489.16 ± 0.3% | 39.28 ± 0.3% | 640.51 ± 1.3% | 888.05 ± 1.1% | 14931.85 ± 0.1% | 372.21 ± 0.2% | 0.96 | 1.00 | 9.48 | 0.58 |
| other: a heading's start tag | 13 | 333.38 ± 0.6% | 336.23 ± 0.7% | 410.82 ± 0.6% | 43.65 ± 0.3% | 638.43 ± 1.1% | 863.80 ± 1.7% | 18000.99 ± 0.2% | 333.55 ± 0.5% | 0.99 | 1.00 | 7.64 | 0.52 |
| other: a whole word | 11 | 453.81 ± 0.4% | 459.58 ± 0.5% | 606.38 ± 0.3% | 117.78 ± 0.4% | 565.96 ± 2.1% | 830.91 ± 1.3% | 26575.28 ± 0.3% | 453.96 ± 0.3% | 0.99 | 1.00 | 3.85 | 0.80 |
| other: a line's first word, second text | 17 | 422.38 ± 0.3% | 432.60 ± 0.4% | 558.04 ± 0.1% | 127.52 ± 0.1% | 717.73 ± 1.8% | refused | refused | 421.59 ± 0.5% | 0.98 | 1.00 | 3.31 | 0.59 |
| other: fourteen octets before an x | 16 | 111.66 ± 0.1% | 147.64 ± 0.7% | 168.10 ± 0.9% | 15.00 ± 0.6% | 456.64 ± 1.8% | 406.63 ± 0.4% | 12816.77 ± 0.6% | 111.59 ± 0.3% | 0.76 | 1.00 | 7.44 | 0.24 |
| other: a Greek word | 8 | 474.41 ± 0.3% | 494.98 ± 0.6% | 663.40 ± 0.1% | 59.05 ± 0.2% | 1404.45 ± 1.4% | 1820.40 ± 0.6% | refused | 474.08 ± 0.2% | 0.96 | 1.00 | 8.03 | 0.34 |

