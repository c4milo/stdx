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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063438911 |
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
| literal: a word | 217 | 15703.84 ± 0.8% | 1049.18 ± 0.2% | 28.79 ± 0.5% | 18701.26 ± 2.5% | 9274.16 ± 6.5% | 17.39 ± 0.3% | 87.00 ± 0.7% | 15726.47 ± 1.3% | 14.97 | 1.00 | 0.84 | 1.69 |
| literal: a word that is not there | 0 | 18313.24 ± 0.9% | 1056.07 ± 0.3% | 27.75 ± 0.5% | 19736.58 ± 1.5% | 29502.85 ± 0.6% | 17.25 ± 0.6% | 81.35 ± 0.2% | 18388.66 ± 1.3% | 17.34 | 1.00 | 0.93 | 0.62 |
| literal: one of four words | 661 | 5814.40 ± 0.6% | 1025.87 ± 0.4% | 15.00 ± 0.2% | 3979.58 ± 0.4% | 21.90 ± 0.1% | 5.25 ± 0.2% | 6.95 ± 0.2% | 5799.25 ± 0.6% | 5.67 | 1.00 | 1.46 | 265.44 |
| literal: a word in any case | 217 | 11706.54 ± 0.7% | 1046.69 ± 0.2% | 22.08 ± 1.8% | 3984.17 ± 0.1% | 38.63 ± 0.2% | refused | differs | 11674.89 ± 0.7% | 11.18 | 1.00 | 2.94 | 303.07 |
| literal: an href attribute | 33 | 16126.84 ± 0.8% | 1052.94 ± 0.1% | 27.74 ± 0.2% | 17068.31 ± 0.9% | 2263.06 ± 0.4% | 12.99 ± 2.5% | 76.07 ± 0.8% | 16126.77 ± 0.1% | 15.32 | 1.00 | 0.94 | 7.13 |
| literal: a word, second text | 123 | 15785.72 ± 1.2% | 1051.45 ± 0.1% | 27.98 ± 0.3% | 18708.00 ± 1.5% | 7780.22 ± 6.1% | 19.50 ± 1.2% | 71.39 ± 0.6% | 15818.75 ± 0.5% | 15.01 | 1.00 | 0.84 | 2.03 |
| class: two capitalized words | 1331 | 1108.34 ± 0.4% | 964.04 ± 0.2% | 26.48 ± 0.2% | 584.12 ± 0.2% | 40.97 ± 0.1% | 14.90 ± 0.3% | 68.03 ± 0.2% | 1108.78 ± 0.3% | 1.15 | 1.00 | 1.90 | 27.06 |
| class: a word that ends in ing | 3399 | 888.49 ± 0.2% | 890.20 ± 0.1% | 18.55 ± 0.3% | 546.24 ± 0.1% | 29.62 ± 2.8% | 8.17 ± 0.1% | 18.31 ± 0.3% | 887.96 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.00 |
| class: a word in capitals | 2332 | 1463.34 ± 0.3% | 960.87 ± 0.1% | 27.96 ± 0.4% | 575.28 ± 0.1% | 43.80 ± 17.1% | 17.06 ± 0.1% | 83.37 ± 0.5% | 1460.82 ± 0.7% | 1.52 | 1.00 | 2.54 | 33.41 |
| class: a number | 8288 | 2116.66 ± 0.3% | 800.86 ± 0.1% | 28.19 ± 0.4% | 1801.87 ± 0.1% | 42.51 ± 10.3% | 0.53 ± 0.4% | 57.34 ± 0.3% | 2113.38 ± 0.2% | 2.64 | 1.00 | 1.17 | 49.80 |
| class: two capitalized words, second text | 5359 | 702.17 ± 0.2% | 702.74 ± 0.2% | 23.79 ± 0.2% | 491.01 ± 0.1% | 35.48 ± 6.6% | 16.93 ± 0.1% | 63.22 ± 0.4% | 701.96 ± 0.5% | 1.00 | 1.00 | 1.43 | 19.79 |
| other: a word between two words | 6104 | 748.58 ± 0.2% | 755.46 ± 0.1% | 23.99 ± 0.3% | 752.58 ± 0.2% | 109.29 ± 16.0% | 11.31 ± 0.2% | 69.71 ± 0.7% | 748.42 ± 0.1% | 0.99 | 1.00 | 0.99 | 6.85 |
| other: a number before a unit, second text | 1481 | 5321.77 ± 0.6% | 986.14 ± 0.1% | 26.37 ± 0.3% | 5934.97 ± 0.6% | 41.01 ± 0.2% | 17.90 ± 0.2% | 65.76 ± 0.1% | 5313.62 ± 0.3% | 5.40 | 1.00 | 0.90 | 129.76 |
| other: a heading's start tag | 110 | 12452.54 ± 0.5% | 1041.57 ± 0.1% | 27.51 ± 0.2% | 1721.93 ± 0.4% | 1585.09 ± 7.1% | 16.19 ± 0.2% | 87.84 ± 1.6% | 12466.93 ± 0.8% | 11.96 | 1.00 | 7.23 | 7.86 |
| other: a whole word | 217 | 13664.36 ± 1.2% | 1047.79 ± 0.2% | 29.91 ± 0.3% | 14800.32 ± 0.6% | 49.42 ± 0.2% | 13.33 ± 0.2% | 55.61 ± 0.4% | 13714.92 ± 0.6% | 13.04 | 1.00 | 0.92 | 276.50 |
| other: a line's first word, second text | 3716 | 1923.13 ± 0.6% | 869.92 ± 0.1% | 31.39 ± 0.3% | 1762.99 ± 0.5% | 63.46 ± 2.5% | refused | refused | 1913.53 ± 0.7% | 2.21 | 1.01 | 1.09 | 30.31 |
| other: fourteen octets before an x | 87 | 19345.98 ± 1.0% | 1.54 ± 0.1% | 1.54 ± 0.3% | 4021.60 ± 0.7% | 10.69 ± 0.2% | differs | 17.89 ± 0.2% | 19259.22 ± 1.7% | 12585.52 | 1.00 | 4.81 | 1809.04 |
| other: a Greek word | 21815 | 479.00 ± 0.5% | 323.26 ± 0.2% | 31.47 ± 0.3% | 294.68 ± 0.1% | 48.63 ± 13.1% | differs | refused | 477.40 ± 1.0% | 1.48 | 1.00 | 1.63 | 9.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.13 ± 0.1% | 28.12 ± 0.2% | 0.50 ± 0.2% | 21.08 ± 0.2% | 2.49 ± 10.7% | differs | 4.03 ± 0.3% | 28.12 ± 0.1% | 1.00 | 1.00 | 1.33 | 11.29 |
| a UUID | 32895 | 23.18 ± 0.2% | 23.19 ± 0.1% | 0.67 ± 0.1% | 16.04 ± 0.1% | 3.09 ± 0.7% | 0.72 ± 0.1% | 3.62 ± 0.4% | 23.21 ± 0.3% | 1.00 | 1.00 | 1.45 | 7.51 |
| an IPv4 address | 33176 | 41.47 ± 0.2% | 41.47 ± 0.3% | 2.19 ± 0.3% | 32.50 ± 0.5% | 6.71 ± 0.4% | differs | 4.08 ± 0.2% | 41.49 ± 0.4% | 1.00 | 1.00 | 1.28 | 6.18 |
| a date and time | 32954 | 34.89 ± 0.5% | 34.99 ± 0.3% | 1.51 ± 0.2% | 23.32 ± 0.1% | 7.08 ± 0.2% | 1.19 ± 0.1% | 7.06 ± 0.2% | 34.91 ± 0.1% | 1.00 | 1.00 | 1.50 | 4.93 |
| a field path | 32606 | 32.23 ± 0.1% | 32.24 ± 0.3% | 0.83 ± 0.1% | 25.38 ± 0.2% | 3.51 ± 1.2% | differs | 2.91 ± 0.3% | 32.20 ± 0.1% | 1.00 | 1.00 | 1.27 | 9.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.24 ± 0.1% | 10.24 ± 0.1% | 10.25 ± 0.2% | 11.29 ± 0.1% | 4.94 ± 1.2% | 0.90 ± 0.6% | none | 10.23 ± 0.0% | 1.00 | 1.00 | 0.91 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 182.15 ± 0.4% | 183.04 ± 0.2% | 202.59 ± 0.1% | 86.64 ± 0.4% | 224.19 ± 0.6% | 486.11 ± 0.6% | 3783.17 ± 0.3% | 182.21 ± 0.9% | 1.00 | 1.00 | 2.10 | 0.81 |
| a UUID | 62 | 119.39 ± 0.3% | 119.52 ± 0.2% | 129.04 ± 0.2% | 46.49 ± 0.2% | 100.09 ± 1.4% | 185.92 ± 2.7% | 4459.24 ± 0.4% | 119.39 ± 1.5% | 1.00 | 1.00 | 2.57 | 1.19 |
| an IPv4 address | 29 | 476.21 ± 0.4% | 479.16 ± 0.4% | 641.16 ± 0.4% | 76.80 ± 0.6% | 133.61 ± 4.6% | 297.59 ± 0.6% | 7553.49 ± 0.5% | 474.91 ± 0.5% | 0.99 | 1.00 | 6.20 | 3.56 |
| a date and time | 56 | 337.30 ± 0.4% | 338.76 ± 0.3% | 413.87 ± 0.4% | 72.99 ± 0.6% | 138.23 ± 1.9% | 318.51 ± 0.9% | 4969.46 ± 1.1% | 337.07 ± 0.2% | 1.00 | 1.00 | 4.62 | 2.44 |
| a field path | 39 | 159.60 ± 0.4% | 159.67 ± 0.3% | 175.50 ± 0.2% | 80.58 ± 0.4% | 208.86 ± 6.0% | 510.48 ± 1.9% | 4841.47 ± 3.0% | 159.39 ± 2.6% | 1.00 | 1.00 | 1.98 | 0.76 |
| literal: a word | 7 | 759.73 ± 0.4% | 788.54 ± 0.7% | 1330.19 ± 0.1% | 521.36 ± 0.1% | 638.82 ± 2.0% | 946.13 ± 0.5% | 30860.69 ± 1.4% | 760.19 ± 0.4% | 0.96 | 1.00 | 1.46 | 1.19 |
| literal: a word that is not there | 8 | 729.29 ± 0.1% | 757.67 ± 0.2% | 1246.67 ± 0.2% | 470.58 ± 0.5% | 613.00 ± 2.2% | 899.55 ± 0.2% | 29781.13 ± 0.3% | 728.64 ± 0.2% | 0.96 | 1.00 | 1.55 | 1.19 |
| literal: one of four words | 26 | 405.92 ± 0.4% | 444.50 ± 0.2% | 585.55 ± 0.5% | 48.90 ± 0.8% | 245.42 ± 2.2% | 362.25 ± 1.9% | 15801.22 ± 0.4% | 406.80 ± 0.3% | 0.91 | 1.00 | 8.30 | 1.65 |
| literal: a word in any case | 11 | 574.73 ± 0.3% | 595.07 ± 0.3% | 888.19 ± 0.1% | 15.69 ± 0.4% | 668.10 ± 0.4% | refused | 23958.54 ± 0.2% | 575.25 ± 0.3% | 0.97 | 1.00 | 36.63 | 0.86 |
| literal: an href attribute | 12 | 438.24 ± 0.6% | 445.50 ± 0.8% | 591.06 ± 0.9% | 45.64 ± 1.0% | 508.40 ± 0.7% | 777.12 ± 0.4% | 22333.56 ± 1.4% | 438.76 ± 0.7% | 0.98 | 1.00 | 9.60 | 0.86 |
| literal: a word, second text | 10 | 677.79 ± 0.2% | 708.68 ± 0.8% | 1128.24 ± 0.1% | 424.14 ± 0.7% | 547.26 ± 1.3% | 804.71 ± 0.5% | 27696.52 ± 1.8% | 678.23 ± 0.1% | 0.96 | 1.00 | 1.60 | 1.24 |
| class: two capitalized words | 23 | 507.18 ± 0.7% | 525.67 ± 0.4% | 733.12 ± 0.3% | 100.84 ± 0.3% | 510.58 ± 1.7% | 747.65 ± 0.6% | 6342.88 ± 0.2% | 507.54 ± 0.5% | 0.96 | 1.00 | 5.03 | 0.99 |
| class: a word that ends in ing | 9 | 701.49 ± 0.6% | 746.89 ± 0.4% | 1222.29 ± 0.3% | 131.11 ± 1.1% | 771.84 ± 1.6% | 1106.00 ± 1.8% | 15866.44 ± 0.2% | 701.83 ± 0.3% | 0.94 | 1.00 | 5.35 | 0.91 |
| class: a word in capitals | 16 | 594.89 ± 0.4% | 620.64 ± 0.3% | 911.19 ± 0.3% | 135.33 ± 0.4% | 764.70 ± 1.5% | 1013.24 ± 1.1% | 8347.99 ± 0.2% | 594.15 ± 1.0% | 0.96 | 1.00 | 4.40 | 0.78 |
| class: a number | 6 | 777.56 ± 0.3% | 819.42 ± 0.5% | 1400.33 ± 0.1% | 41.91 ± 0.5% | 1429.29 ± 0.8% | 1885.34 ± 1.3% | 22962.44 ± 0.3% | 777.45 ± 0.4% | 0.95 | 1.00 | 18.55 | 0.54 |
| class: two capitalized words, second text | 23 | 506.72 ± 0.5% | 526.25 ± 0.3% | 732.13 ± 0.2% | 103.86 ± 0.7% | 515.59 ± 1.2% | 734.72 ± 0.6% | 6345.68 ± 0.2% | 507.38 ± 0.5% | 0.96 | 1.00 | 4.88 | 0.98 |
| other: a word between two words | 13 | 643.36 ± 0.4% | 652.53 ± 0.4% | 994.44 ± 0.1% | 134.28 ± 1.2% | 516.11 ± 0.7% | 808.72 ± 0.9% | 14778.94 ± 0.2% | 643.36 ± 0.3% | 0.99 | 1.00 | 4.79 | 1.25 |
| other: a number before a unit, second text | 15 | 382.83 ± 0.4% | 402.20 ± 0.3% | 512.58 ± 0.1% | 39.35 ± 0.4% | 649.46 ± 0.6% | 887.06 ± 0.1% | 15285.33 ± 0.3% | 382.55 ± 1.0% | 0.95 | 1.00 | 9.73 | 0.59 |
| other: a heading's start tag | 13 | 434.22 ± 0.5% | 440.46 ± 0.3% | 587.00 ± 0.4% | 43.76 ± 0.2% | 647.15 ± 0.6% | 864.48 ± 0.3% | 18537.31 ± 0.4% | 432.97 ± 0.3% | 0.99 | 1.00 | 9.92 | 0.67 |
| other: a whole word | 11 | 702.83 ± 0.3% | 719.84 ± 0.1% | 1158.52 ± 0.2% | 120.84 ± 0.7% | 577.41 ± 2.1% | 821.61 ± 1.2% | 27213.86 ± 0.5% | 704.45 ± 0.3% | 0.98 | 1.00 | 5.82 | 1.22 |
| other: a line's first word, second text | 17 | 629.51 ± 0.4% | 654.59 ± 0.5% | 984.83 ± 0.4% | 128.52 ± 0.4% | 719.04 ± 1.8% | refused | refused | 627.30 ± 0.8% | 0.96 | 1.00 | 4.90 | 0.88 |
| other: fourteen octets before an x | 16 | 119.50 ± 0.9% | 160.64 ± 1.4% | 187.99 ± 1.0% | 15.21 ± 0.1% | 461.93 ± 0.7% | 414.20 ± 0.3% | 13048.76 ± 0.2% | 119.13 ± 0.7% | 0.74 | 1.00 | 7.86 | 0.26 |
| other: a Greek word | 8 | 725.68 ± 1.0% | 777.24 ± 0.7% | 1284.18 ± 0.3% | 59.00 ± 0.5% | 1406.45 ± 0.8% | 1787.85 ± 0.7% | refused | 724.74 ± 0.7% | 0.93 | 1.00 | 12.30 | 0.52 |

