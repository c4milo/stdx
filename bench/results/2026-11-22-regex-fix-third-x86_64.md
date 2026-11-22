# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063425000 |
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
| literal: a word | 217 | 36119.96 ± 2.9% | 895.30 ± 0.6% | 20.11 ± 2.5% | 32690.26 ± 1.0% | 8896.92 ± 10.4% | 10.78 ± 0.4% | 76.81 ± 0.8% | 35080.66 ± 1.4% | 40.34 | 1.03 | 1.10 | 4.06 |
| literal: a word that is not there | 0 | 54190.35 ± 1.1% | 906.42 ± 0.4% | 20.19 ± 3.3% | 39186.69 ± 16.2% | 30285.25 ± 0.3% | 10.72 ± 0.3% | 72.99 ± 1.1% | 53314.06 ± 3.3% | 59.79 | 1.02 | 1.38 | 1.79 |
| literal: one of four words | 661 | 10040.64 ± 0.5% | 871.32 ± 0.6% | 11.16 ± 1.9% | 9572.32 ± 3.4% | 18.77 ± 1.7% | 3.99 ± 0.2% | 6.53 ± 0.2% | 10025.27 ± 0.5% | 11.52 | 1.00 | 1.05 | 535.05 |
| literal: a word in any case | 217 | 26591.67 ± 6.1% | 894.53 ± 0.1% | 15.35 ± 3.6% | 9386.81 ± 3.9% | 36.78 ± 0.3% | refused | differs | 25888.15 ± 5.5% | 29.73 | 1.03 | 2.83 | 723.06 |
| literal: an href attribute | 33 | 35866.48 ± 4.6% | 901.04 ± 0.1% | 18.80 ± 1.6% | 24808.13 ± 2.0% | 2061.07 ± 0.4% | 8.21 ± 0.3% | 67.62 ± 1.1% | 34558.48 ± 5.2% | 39.81 | 1.04 | 1.45 | 17.40 |
| literal: a word, second text | 123 | 36220.83 ± 4.1% | 899.23 ± 0.9% | 20.15 ± 1.9% | 28673.02 ± 0.3% | 7081.59 ± 6.0% | 12.00 ± 0.2% | 65.76 ± 5.1% | 35844.72 ± 2.5% | 40.28 | 1.01 | 1.26 | 5.11 |
| class: two capitalized words | 1331 | 775.37 ± 1.1% | 816.37 ± 1.4% | 19.02 ± 5.7% | 506.88 ± 0.1% | 33.52 ± 2.6% | 9.30 ± 0.2% | 58.83 ± 0.5% | 775.83 ± 0.1% | 0.95 | 1.00 | 1.53 | 23.13 |
| class: a word that ends in ing | 3399 | 742.03 ± 0.1% | 742.42 ± 1.0% | 13.53 ± 1.5% | 472.96 ± 0.3% | 25.34 ± 3.2% | 5.29 ± 0.2% | 17.02 ± 1.0% | 742.47 ± 0.2% | 1.00 | 1.00 | 1.57 | 29.28 |
| class: a word in capitals | 2332 | 978.39 ± 2.4% | 798.43 ± 13.3% | 20.02 ± 27.0% | 497.66 ± 4.9% | 35.34 ± 15.2% | 10.30 ± 1.5% | 77.04 ± 2.5% | 978.73 ± 1.7% | 1.23 | 1.00 | 1.97 | 27.69 |
| class: a number | 8288 | 1521.76 ± 0.3% | 661.24 ± 2.3% | 19.67 ± 2.4% | 1512.69 ± 0.3% | 34.57 ± 13.3% | 0.33 ± 0.2% | 56.49 ± 0.4% | 1521.73 ± 0.6% | 2.30 | 1.00 | 1.01 | 44.02 |
| class: two capitalized words, second text | 5359 | 585.51 ± 0.4% | 585.26 ± 0.3% | 17.40 ± 1.4% | 418.80 ± 0.8% | 28.90 ± 9.8% | 10.50 ± 0.5% | 54.83 ± 1.1% | 585.17 ± 0.3% | 1.00 | 1.00 | 1.40 | 20.26 |
| other: a word between two words | 6104 | 694.45 ± 0.1% | 631.08 ± 0.1% | 17.49 ± 2.3% | 716.21 ± 0.2% | 101.08 ± 12.8% | 7.25 ± 5.6% | 59.36 ± 0.6% | 694.79 ± 0.4% | 1.10 | 1.00 | 0.97 | 6.87 |
| other: a number before a unit, second text | 1481 | 7663.82 ± 0.6% | 831.50 ± 2.6% | 19.01 ± 1.9% | 6948.12 ± 1.2% | 34.40 ± 0.1% | 10.92 ± 0.3% | 59.12 ± 1.8% | 7620.20 ± 0.3% | 9.22 | 1.01 | 1.10 | 222.77 |
| other: a heading's start tag | 110 | 19836.65 ± 1.8% | 893.37 ± 0.2% | 19.53 ± 3.2% | 2050.61 ± 0.7% | 1473.32 ± 17.0% | 10.02 ± 0.1% | 78.55 ± 0.3% | 19828.35 ± 1.1% | 22.20 | 1.00 | 9.67 | 13.46 |
| other: a whole word | 217 | 24293.90 ± 2.7% | 894.62 ± 0.1% | 20.07 ± 1.6% | 23199.89 ± 1.1% | 41.13 ± 0.4% | 9.45 ± 0.1% | 46.43 ± 0.9% | 23899.93 ± 0.6% | 27.16 | 1.02 | 1.05 | 590.69 |
| other: a line's first word, second text | 3716 | 1965.70 ± 4.1% | 727.57 ± 0.1% | 22.77 ± 2.0% | 1807.41 ± 3.4% | 54.13 ± 5.5% | refused | refused | 1957.82 ± 1.0% | 2.70 | 1.00 | 1.09 | 36.31 |
| other: fourteen octets before an x | 87 | 26903.51 ± 3.9% | 1.32 ± 1.0% | 1.32 ± 1.1% | 2961.37 ± 3.4% | 8.98 ± 2.4% | differs | 17.05 ± 11.3% | 26957.09 ± 3.6% | 20381.81 | 1.00 | 9.08 | 2996.98 |
| other: a Greek word | 21815 | 395.37 ± 0.6% | 273.22 ± 1.5% | 24.11 ± 1.2% | 269.46 ± 0.6% | 44.52 ± 17.0% | differs | refused | 395.37 ± 0.8% | 1.45 | 1.00 | 1.47 | 8.88 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.47 ± 1.6% | 26.30 ± 2.1% | 0.47 ± 0.9% | 19.36 ± 0.6% | 2.32 ± 5.2% | differs | 3.45 ± 1.9% | 26.75 ± 1.6% | 1.01 | 0.99 | 1.37 | 11.43 |
| a UUID | 32895 | 22.01 ± 0.5% | 21.99 ± 0.1% | 0.57 ± 0.7% | 14.54 ± 0.2% | 2.44 ± 0.4% | 0.44 ± 0.3% | 3.15 ± 0.8% | 22.04 ± 0.2% | 1.00 | 1.00 | 1.51 | 9.04 |
| an IPv4 address | 33176 | 37.72 ± 3.1% | 37.24 ± 1.5% | 1.81 ± 3.8% | 30.11 ± 0.4% | 5.61 ± 5.2% | differs | 3.32 ± 1.7% | 38.43 ± 1.6% | 1.01 | 0.98 | 1.25 | 6.73 |
| a date and time | 32954 | 33.52 ± 6.4% | 33.55 ± 0.3% | 1.31 ± 0.8% | 22.14 ± 2.4% | 6.48 ± 0.2% | 0.76 ± 1.0% | 6.04 ± 0.7% | 32.35 ± 0.4% | 1.00 | 1.04 | 1.51 | 5.17 |
| a field path | 32606 | 29.78 ± 1.5% | 29.73 ± 1.4% | 0.75 ± 0.3% | 23.37 ± 0.1% | 2.86 ± 6.3% | differs | 2.32 ± 5.3% | 29.80 ± 0.7% | 1.00 | 1.00 | 1.27 | 10.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.13 ± 0.8% | 9.10 ± 0.6% | 9.13 ± 1.2% | 10.69 ± 2.0% | 4.53 ± 5.1% | 0.63 ± 1.0% | none | 9.10 ± 12.4% | 1.00 | 1.00 | 0.85 | 2.02 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.98 ± 2.8% | 235.37 ± 0.9% | 270.97 ± 1.2% | 79.40 ± 4.2% | 183.55 ± 0.9% | 539.83 ± 11.5% | 3520.73 ± 9.0% | 235.00 ± 0.6% | 1.00 | 1.00 | 2.96 | 1.28 |
| a UUID | 62 | 158.28 ± 1.3% | 158.75 ± 0.4% | 179.44 ± 0.7% | 45.89 ± 4.4% | 89.38 ± 3.0% | 200.15 ± 6.5% | 3900.83 ± 9.2% | 158.31 ± 0.4% | 1.00 | 1.00 | 3.45 | 1.77 |
| an IPv4 address | 29 | 429.39 ± 1.4% | 430.75 ± 1.0% | 575.67 ± 0.7% | 69.74 ± 0.6% | 112.37 ± 2.2% | 312.21 ± 5.5% | 6716.17 ± 1.6% | 431.51 ± 0.4% | 1.00 | 1.00 | 6.16 | 3.82 |
| a date and time | 56 | 307.48 ± 0.4% | 307.88 ± 0.6% | 374.13 ± 0.6% | 68.04 ± 0.5% | 121.13 ± 1.7% | 373.90 ± 1.1% | 3922.50 ± 1.1% | 307.38 ± 8.3% | 1.00 | 1.00 | 4.52 | 2.54 |
| a field path | 39 | 253.10 ± 0.9% | 253.51 ± 0.3% | 295.33 ± 1.0% | 73.91 ± 0.7% | 171.81 ± 0.7% | 591.92 ± 3.2% | 4433.74 ± 1.1% | 252.47 ± 0.3% | 1.00 | 1.00 | 3.42 | 1.47 |
| literal: a word | 7 | 712.71 ± 1.3% | 726.43 ± 1.1% | 1207.39 ± 0.8% | 487.14 ± 0.5% | 574.10 ± 3.2% | 1255.31 ± 1.4% | 24534.08 ± 0.9% | 711.86 ± 1.6% | 0.98 | 1.00 | 1.46 | 1.24 |
| literal: a word that is not there | 8 | 684.29 ± 0.8% | 701.30 ± 0.3% | 1136.06 ± 1.0% | 457.66 ± 1.4% | 556.62 ± 2.4% | 1164.77 ± 0.6% | 23158.50 ± 1.4% | 682.65 ± 0.9% | 0.98 | 1.00 | 1.50 | 1.23 |
| literal: one of four words | 26 | 364.80 ± 2.6% | 392.31 ± 5.6% | 509.55 ± 0.5% | 44.84 ± 4.2% | 220.68 ± 1.5% | 453.84 ± 0.8% | 9727.67 ± 1.8% | 364.87 ± 21.3% | 0.93 | 1.00 | 8.14 | 1.65 |
| literal: a word in any case | 11 | 532.82 ± 1.6% | 548.56 ± 0.7% | 790.71 ± 0.9% | 15.10 ± 2.3% | 601.16 ± 1.9% | refused | 18224.80 ± 2.1% | 533.16 ± 0.3% | 0.97 | 1.00 | 35.28 | 0.89 |
| literal: an href attribute | 12 | 397.01 ± 2.9% | 400.86 ± 0.9% | 520.77 ± 1.1% | 36.93 ± 1.6% | 426.23 ± 2.7% | 964.03 ± 2.7% | 16883.40 ± 0.6% | 396.27 ± 0.8% | 0.99 | 1.00 | 10.75 | 0.93 |
| literal: a word, second text | 10 | 638.54 ± 0.7% | 655.02 ± 3.5% | 1017.48 ± 0.6% | 420.49 ± 0.4% | 485.44 ± 1.8% | 1024.86 ± 0.7% | 19826.06 ± 1.3% | 638.29 ± 0.8% | 0.97 | 1.00 | 1.52 | 1.32 |
| class: two capitalized words | 23 | 489.63 ± 0.5% | 503.55 ± 0.4% | 689.21 ± 1.4% | 93.92 ± 0.5% | 447.47 ± 44.4% | 934.03 ± 0.8% | 6077.49 ± 4.7% | 489.07 ± 3.0% | 0.97 | 1.00 | 5.21 | 1.09 |
| class: a word that ends in ing | 9 | 635.85 ± 2.8% | 680.55 ± 2.5% | 1051.26 ± 3.0% | 112.92 ± 4.5% | 601.36 ± 9.4% | 1373.20 ± 9.6% | 14623.74 ± 2.5% | 634.73 ± 3.1% | 0.93 | 1.00 | 5.63 | 1.06 |
| class: a word in capitals | 16 | 547.29 ± 0.6% | 569.75 ± 0.2% | 807.39 ± 5.1% | 119.92 ± 1.7% | 647.59 ± 3.1% | 1285.22 ± 0.7% | 8153.78 ± 0.3% | 547.40 ± 0.9% | 0.96 | 1.00 | 4.56 | 0.85 |
| class: a number | 6 | 715.72 ± 1.0% | 752.93 ± 0.9% | 1245.41 ± 2.8% | 37.39 ± 1.3% | 1194.71 ± 2.7% | 2320.03 ± 6.9% | 19557.31 ± 0.3% | 715.71 ± 1.5% | 0.95 | 1.00 | 19.14 | 0.60 |
| class: two capitalized words, second text | 23 | 488.06 ± 0.3% | 502.28 ± 0.6% | 688.43 ± 1.4% | 94.05 ± 0.5% | 450.09 ± 1.5% | 902.65 ± 6.6% | 6067.86 ± 0.9% | 487.94 ± 0.9% | 0.97 | 1.00 | 5.19 | 1.08 |
| other: a word between two words | 13 | 580.72 ± 0.8% | 588.04 ± 0.4% | 855.85 ± 0.8% | 121.03 ± 1.6% | 431.40 ± 1.8% | 1015.09 ± 1.1% | 12328.96 ± 1.2% | 578.75 ± 0.4% | 0.99 | 1.00 | 4.80 | 1.35 |
| other: a number before a unit, second text | 15 | 478.93 ± 0.6% | 506.48 ± 1.3% | 702.26 ± 0.4% | 34.56 ± 0.8% | 530.66 ± 0.7% | 1125.19 ± 8.0% | 12631.45 ± 0.7% | 479.84 ± 0.6% | 0.95 | 1.00 | 13.86 | 0.90 |
| other: a heading's start tag | 13 | 400.88 ± 5.6% | 403.36 ± 0.4% | 536.05 ± 1.0% | 35.46 ± 0.3% | 522.64 ± 0.9% | 1089.31 ± 0.6% | 15142.75 ± 7.6% | 401.54 ± 0.2% | 0.99 | 1.00 | 11.31 | 0.77 |
| other: a whole word | 11 | 603.44 ± 0.8% | 622.87 ± 2.2% | 913.21 ± 1.1% | 113.19 ± 0.7% | 505.96 ± 1.5% | 1035.35 ± 1.4% | 18677.46 ± 3.2% | 605.99 ± 1.0% | 0.97 | 1.00 | 5.33 | 1.19 |
| other: a line's first word, second text | 17 | 586.05 ± 1.3% | 614.93 ± 1.1% | 907.93 ± 0.2% | 114.47 ± 2.5% | 590.80 ± 1.0% | refused | refused | 585.56 ± 9.4% | 0.95 | 1.00 | 5.12 | 0.99 |
| other: fourteen octets before an x | 16 | 93.86 ± 3.2% | 120.37 ± 6.3% | 137.09 ± 0.4% | 14.28 ± 0.7% | 392.44 ± 3.2% | 443.91 ± 6.1% | 11748.50 ± 6.0% | 93.89 ± 0.4% | 0.78 | 1.00 | 6.57 | 0.24 |
| other: a Greek word | 8 | 667.32 ± 0.8% | 709.77 ± 0.6% | 1147.55 ± 0.2% | 46.70 ± 0.4% | 1169.84 ± 3.5% | 2192.65 ± 1.0% | refused | 666.63 ± 0.6% | 0.94 | 1.00 | 14.29 | 0.57 |

