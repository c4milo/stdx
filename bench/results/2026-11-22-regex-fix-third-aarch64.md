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
| literal: a word | 217 | 15432.85 ± 1.1% | 1047.60 ± 0.1% | 28.17 ± 0.4% | 18366.72 ± 1.7% | 9097.52 ± 9.6% | 17.63 ± 0.0% | 86.58 ± 0.1% | 15392.64 ± 0.4% | 14.73 | 1.00 | 0.84 | 1.70 |
| literal: a word that is not there | 0 | 18163.34 ± 2.1% | 1055.02 ± 0.8% | 28.14 ± 0.3% | 19492.82 ± 3.6% | 28729.11 ± 3.1% | 17.46 ± 0.2% | 80.78 ± 0.3% | 18170.60 ± 1.9% | 17.22 | 1.00 | 0.93 | 0.63 |
| literal: one of four words | 661 | 5797.19 ± 0.5% | 1025.32 ± 0.1% | 14.87 ± 0.3% | 3975.29 ± 0.3% | 21.89 ± 0.2% | 5.30 ± 0.1% | 6.94 ± 0.2% | 5796.85 ± 0.5% | 5.65 | 1.00 | 1.46 | 264.79 |
| literal: a word in any case | 217 | 11632.28 ± 1.0% | 1044.46 ± 0.1% | 21.72 ± 1.7% | 3985.18 ± 0.1% | 38.68 ± 0.2% | refused | differs | 11613.72 ± 0.3% | 11.14 | 1.00 | 2.92 | 300.71 |
| literal: an href attribute | 33 | 15950.94 ± 0.5% | 1053.18 ± 0.1% | 27.27 ± 0.2% | 16729.56 ± 0.9% | 2260.14 ± 0.4% | 13.49 ± 0.1% | 75.55 ± 0.2% | 15927.86 ± 1.1% | 15.15 | 1.00 | 0.95 | 7.06 |
| literal: a word, second text | 123 | 15549.77 ± 1.1% | 1049.37 ± 0.2% | 27.77 ± 0.3% | 18299.54 ± 2.8% | 7607.10 ± 5.2% | 19.63 ± 1.2% | 70.59 ± 0.6% | 15536.90 ± 0.7% | 14.82 | 1.00 | 0.85 | 2.04 |
| class: two capitalized words | 1331 | 1108.94 ± 0.4% | 964.06 ± 0.2% | 26.09 ± 0.1% | 587.33 ± 0.1% | 40.93 ± 2.3% | 15.01 ± 0.2% | 67.82 ± 0.4% | 1107.43 ± 0.3% | 1.15 | 1.00 | 1.89 | 27.10 |
| class: a word that ends in ing | 3399 | 887.57 ± 0.2% | 889.73 ± 0.1% | 18.40 ± 0.1% | 550.29 ± 0.1% | 29.58 ± 6.1% | 8.23 ± 0.2% | 18.39 ± 0.2% | 887.50 ± 0.3% | 1.00 | 1.00 | 1.61 | 30.01 |
| class: a word in capitals | 2332 | 1461.00 ± 0.4% | 960.07 ± 0.2% | 27.46 ± 0.3% | 575.08 ± 0.2% | 43.76 ± 6.7% | 17.16 ± 0.3% | 83.30 ± 0.3% | 1461.32 ± 0.3% | 1.52 | 1.00 | 2.54 | 33.39 |
| class: a number | 8288 | 2118.21 ± 0.7% | 812.26 ± 0.1% | 27.67 ± 0.6% | 1801.80 ± 0.3% | 43.03 ± 7.5% | 0.57 ± 0.3% | 57.26 ± 0.2% | 2110.65 ± 0.3% | 2.61 | 1.00 | 1.18 | 49.23 |
| class: two capitalized words, second text | 5359 | 701.06 ± 0.4% | 702.30 ± 0.1% | 23.49 ± 0.4% | 488.75 ± 0.1% | 35.04 ± 12.5% | 16.64 ± 0.4% | 63.14 ± 0.2% | 701.36 ± 0.1% | 1.00 | 1.00 | 1.43 | 20.01 |
| other: a word between two words | 6104 | 747.40 ± 0.1% | 753.51 ± 0.1% | 23.65 ± 0.3% | 753.82 ± 0.4% | 108.70 ± 13.3% | 11.35 ± 0.1% | 69.45 ± 0.3% | 741.05 ± 0.1% | 0.99 | 1.01 | 0.99 | 6.88 |
| other: a number before a unit, second text | 1481 | 5281.95 ± 0.9% | 983.86 ± 0.1% | 25.89 ± 0.5% | 5956.56 ± 1.0% | 40.96 ± 15.7% | 17.74 ± 0.3% | 65.82 ± 0.3% | 5270.29 ± 0.5% | 5.37 | 1.00 | 0.89 | 128.95 |
| other: a heading's start tag | 110 | 12418.08 ± 0.8% | 1040.94 ± 0.1% | 27.10 ± 0.2% | 1720.00 ± 0.3% | 1580.97 ± 5.4% | 16.40 ± 0.5% | 87.88 ± 0.2% | 12369.32 ± 0.8% | 11.93 | 1.00 | 7.22 | 7.85 |
| other: a whole word | 217 | 13569.05 ± 0.8% | 1046.58 ± 0.1% | 29.13 ± 0.1% | 14767.19 ± 1.5% | 49.25 ± 0.2% | 13.71 ± 0.2% | 55.11 ± 1.1% | 13512.42 ± 0.9% | 12.97 | 1.00 | 0.92 | 275.50 |
| other: a line's first word, second text | 3716 | 1920.08 ± 0.6% | 867.67 ± 0.2% | 30.84 ± 0.1% | 1763.53 ± 0.7% | 62.26 ± 6.1% | refused | refused | 1915.74 ± 0.4% | 2.21 | 1.00 | 1.09 | 30.84 |
| other: fourteen octets before an x | 87 | 18700.50 ± 2.0% | 1.54 ± 0.1% | 1.54 ± 0.1% | 3997.00 ± 0.3% | 10.69 ± 0.2% | differs | 17.92 ± 0.3% | 18614.76 ± 1.2% | 12169.62 | 1.00 | 4.68 | 1749.12 |
| other: a Greek word | 21815 | 479.35 ± 0.9% | 318.68 ± 0.4% | 31.21 ± 0.3% | 294.10 ± 0.1% | 44.18 ± 9.6% | differs | refused | 477.00 ± 0.5% | 1.50 | 1.00 | 1.63 | 10.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.95 ± 0.1% | 27.96 ± 0.3% | 0.50 ± 0.3% | 21.47 ± 0.3% | 2.78 ± 0.6% | differs | 4.03 ± 0.1% | 27.93 ± 0.1% | 1.00 | 1.00 | 1.30 | 10.05 |
| a UUID | 32895 | 23.07 ± 0.1% | 23.07 ± 0.0% | 0.67 ± 0.1% | 16.03 ± 0.1% | 3.08 ± 0.9% | 0.72 ± 0.4% | 3.63 ± 0.4% | 23.08 ± 0.1% | 1.00 | 1.00 | 1.44 | 7.49 |
| an IPv4 address | 33176 | 41.45 ± 0.1% | 41.45 ± 0.2% | 2.19 ± 0.1% | 32.64 ± 0.2% | 6.68 ± 0.3% | differs | 4.08 ± 0.3% | 41.44 ± 0.4% | 1.00 | 1.00 | 1.27 | 6.20 |
| a date and time | 32954 | 34.82 ± 0.2% | 34.81 ± 0.3% | 1.51 ± 1.2% | 23.29 ± 0.2% | 7.07 ± 0.2% | 1.20 ± 0.3% | 6.99 ± 0.3% | 34.84 ± 0.2% | 1.00 | 1.00 | 1.49 | 4.93 |
| a field path | 32606 | 32.30 ± 0.2% | 32.30 ± 0.3% | 0.83 ± 0.2% | 25.26 ± 0.2% | 3.52 ± 2.0% | differs | 2.90 ± 0.4% | 32.26 ± 0.3% | 1.00 | 1.00 | 1.28 | 9.19 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.25 ± 0.2% | 10.26 ± 0.2% | 10.26 ± 0.5% | 11.14 ± 0.1% | 4.91 ± 1.0% | 0.91 ± 0.4% | none | 10.26 ± 0.3% | 1.00 | 1.00 | 0.92 | 2.09 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 275.70 ± 0.7% | 276.84 ± 0.7% | 325.24 ± 0.6% | 85.81 ± 0.4% | 218.09 ± 1.4% | 482.92 ± 1.5% | 3775.81 ± 0.2% | 275.32 ± 0.5% | 1.00 | 1.00 | 3.21 | 1.26 |
| a UUID | 62 | 195.73 ± 0.3% | 196.62 ± 0.3% | 224.56 ± 0.2% | 45.96 ± 0.7% | 97.31 ± 1.0% | 190.48 ± 2.8% | 4473.05 ± 0.3% | 195.85 ± 0.2% | 1.00 | 1.00 | 4.26 | 2.01 |
| an IPv4 address | 29 | 476.41 ± 0.2% | 480.82 ± 0.7% | 646.49 ± 0.6% | 75.92 ± 0.5% | 128.97 ± 1.4% | 303.27 ± 2.2% | 7554.72 ± 0.1% | 476.49 ± 0.3% | 0.99 | 1.00 | 6.28 | 3.69 |
| a date and time | 56 | 337.16 ± 0.3% | 338.55 ± 0.4% | 415.08 ± 0.1% | 72.00 ± 0.3% | 133.94 ± 0.8% | 326.13 ± 1.7% | 4973.35 ± 0.2% | 337.56 ± 0.2% | 1.00 | 1.00 | 4.68 | 2.52 |
| a field path | 39 | 279.44 ± 0.2% | 281.03 ± 0.2% | 331.60 ± 0.4% | 79.84 ± 1.1% | 202.84 ± 0.8% | 504.29 ± 2.3% | 4852.67 ± 0.6% | 279.74 ± 0.2% | 0.99 | 1.00 | 3.50 | 1.38 |
| literal: a word | 7 | 756.70 ± 0.6% | 785.35 ± 0.6% | 1325.58 ± 0.8% | 511.00 ± 0.1% | 621.75 ± 3.0% | 960.44 ± 0.4% | 30872.70 ± 0.7% | 757.53 ± 0.4% | 0.96 | 1.00 | 1.48 | 1.22 |
| literal: a word that is not there | 8 | 727.28 ± 0.5% | 754.90 ± 0.3% | 1240.03 ± 0.2% | 470.40 ± 0.2% | 597.31 ± 1.6% | 909.09 ± 0.6% | 29245.93 ± 0.3% | 727.70 ± 0.1% | 0.96 | 1.00 | 1.55 | 1.22 |
| literal: one of four words | 26 | 403.25 ± 0.3% | 441.63 ± 0.6% | 581.06 ± 0.7% | 49.46 ± 1.5% | 235.98 ± 1.7% | 374.68 ± 1.5% | 15736.33 ± 0.2% | 403.70 ± 0.5% | 0.91 | 1.00 | 8.15 | 1.71 |
| literal: a word in any case | 11 | 574.97 ± 0.2% | 595.00 ± 0.5% | 891.35 ± 0.2% | 15.75 ± 1.3% | 640.42 ± 2.1% | refused | 23702.00 ± 0.5% | 574.59 ± 0.2% | 0.97 | 1.00 | 36.50 | 0.90 |
| literal: an href attribute | 12 | 435.80 ± 0.4% | 443.14 ± 0.8% | 587.93 ± 0.7% | 43.92 ± 0.3% | 495.74 ± 1.3% | 771.56 ± 1.0% | 22165.46 ± 0.2% | 435.69 ± 0.5% | 0.98 | 1.00 | 9.92 | 0.88 |
| literal: a word, second text | 10 | 674.44 ± 0.4% | 702.33 ± 0.6% | 1122.74 ± 0.1% | 393.28 ± 0.3% | 534.14 ± 1.7% | 800.43 ± 0.9% | 27275.40 ± 0.5% | 675.10 ± 0.2% | 0.96 | 1.00 | 1.71 | 1.26 |
| class: two capitalized words | 23 | 508.12 ± 1.8% | 527.64 ± 0.6% | 735.12 ± 0.5% | 98.30 ± 0.2% | 500.91 ± 2.3% | 744.36 ± 0.3% | 6329.11 ± 0.2% | 508.48 ± 0.3% | 0.96 | 1.00 | 5.17 | 1.01 |
| class: a word that ends in ing | 9 | 701.74 ± 0.3% | 747.89 ± 0.2% | 1224.00 ± 0.3% | 129.73 ± 1.7% | 754.18 ± 0.8% | 1101.28 ± 0.5% | 15795.33 ± 0.2% | 701.18 ± 0.2% | 0.94 | 1.00 | 5.41 | 0.93 |
| class: a word in capitals | 16 | 603.00 ± 0.3% | 628.78 ± 0.7% | 933.95 ± 0.4% | 133.10 ± 0.4% | 742.47 ± 1.6% | 1018.98 ± 2.1% | 8314.89 ± 0.3% | 602.88 ± 0.2% | 0.96 | 1.00 | 4.53 | 0.81 |
| class: a number | 6 | 781.02 ± 0.4% | 823.01 ± 0.4% | 1437.02 ± 0.1% | 41.46 ± 0.6% | 1385.99 ± 2.4% | 1855.21 ± 1.2% | 22642.85 ± 0.3% | 779.65 ± 0.4% | 0.95 | 1.00 | 18.84 | 0.56 |
| class: two capitalized words, second text | 23 | 507.68 ± 0.6% | 525.95 ± 0.9% | 735.34 ± 0.4% | 99.73 ± 0.4% | 493.06 ± 1.6% | 763.64 ± 0.7% | 6326.77 ± 0.2% | 507.98 ± 1.1% | 0.97 | 1.00 | 5.09 | 1.03 |
| other: a word between two words | 13 | 640.42 ± 0.6% | 653.44 ± 0.7% | 995.38 ± 0.9% | 131.03 ± 0.7% | 496.70 ± 1.7% | 814.88 ± 1.0% | 14753.31 ± 0.0% | 642.01 ± 0.6% | 0.98 | 1.00 | 4.89 | 1.29 |
| other: a number before a unit, second text | 15 | 514.21 ± 0.3% | 549.20 ± 0.3% | 776.64 ± 0.1% | 39.20 ± 0.5% | 622.70 ± 1.1% | 889.15 ± 1.2% | 15237.22 ± 0.2% | 513.97 ± 0.5% | 0.94 | 1.00 | 13.12 | 0.83 |
| other: a heading's start tag | 13 | 434.38 ± 0.7% | 440.76 ± 0.7% | 587.16 ± 0.4% | 43.15 ± 0.7% | 624.98 ± 1.5% | 882.70 ± 0.8% | 18418.30 ± 0.1% | 434.21 ± 0.6% | 0.99 | 1.00 | 10.07 | 0.70 |
| other: a whole word | 11 | 701.37 ± 0.2% | 717.55 ± 0.3% | 1154.71 ± 0.3% | 115.73 ± 0.3% | 558.19 ± 1.9% | 838.29 ± 0.4% | 27006.37 ± 0.8% | 701.56 ± 0.2% | 0.98 | 1.00 | 6.06 | 1.26 |
| other: a line's first word, second text | 17 | 632.15 ± 0.4% | 656.45 ± 0.2% | 992.60 ± 0.2% | 126.40 ± 0.1% | 702.86 ± 0.5% | refused | refused | 630.80 ± 0.9% | 0.96 | 1.00 | 5.00 | 0.90 |
| other: fourteen octets before an x | 16 | 117.82 ± 0.6% | 158.86 ± 0.5% | 188.74 ± 0.4% | 14.64 ± 0.6% | 449.44 ± 1.0% | 414.59 ± 0.3% | 13023.38 ± 0.3% | 117.76 ± 0.5% | 0.74 | 1.00 | 8.05 | 0.26 |
| other: a Greek word | 8 | 719.69 ± 0.6% | 772.45 ± 0.5% | 1276.50 ± 0.8% | 58.74 ± 0.2% | 1374.55 ± 0.7% | 1802.27 ± 0.3% | refused | 718.75 ± 0.3% | 0.93 | 1.00 | 12.25 | 0.52 |

