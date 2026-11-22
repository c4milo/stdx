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
| Run URL | https://github.com/c4milo/stdx/actions/runs/44986663680 |
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
| literal: a word | 217 | 15678.07 ± 1.0% | 1040.16 ± 0.3% | 28.66 ± 0.5% | 18269.27 ± 2.5% | 9076.95 ± 11.5% | 17.29 ± 0.4% | 86.19 ± 0.4% | 15650.41 ± 0.6% | 15.07 | 1.00 | 0.86 | 1.73 |
| literal: a word that is not there | 0 | 18636.07 ± 2.4% | 1045.59 ± 0.3% | 28.54 ± 0.3% | 19637.25 ± 3.0% | 29187.26 ± 0.8% | 17.14 ± 0.5% | 82.39 ± 0.3% | 18762.83 ± 1.7% | 17.82 | 0.99 | 0.95 | 0.64 |
| literal: one of four words | 661 | 4162.39 ± 0.3% | 1020.72 ± 0.4% | 14.88 ± 0.4% | 3968.94 ± 0.2% | 21.94 ± 0.2% | 5.23 ± 0.3% | 6.76 ± 0.3% | 4156.92 ± 0.1% | 4.08 | 1.00 | 1.05 | 189.73 |
| literal: a word in any case | 217 | 11648.75 ± 0.4% | 1040.63 ± 0.4% | 21.78 ± 0.1% | 3978.81 ± 0.2% | 38.59 ± 0.1% | refused | differs | 11626.41 ± 0.3% | 11.19 | 1.00 | 2.93 | 301.82 |
| literal: an href attribute | 33 | 16038.86 ± 0.6% | 1047.29 ± 0.3% | 27.54 ± 0.1% | 16941.75 ± 2.5% | 2257.15 ± 5.8% | 13.22 ± 0.3% | 75.70 ± 0.4% | 16118.78 ± 1.6% | 15.31 | 1.00 | 0.95 | 7.11 |
| literal: a word, second text | 123 | 15786.91 ± 1.2% | 1040.45 ± 0.2% | 28.23 ± 0.3% | 18470.46 ± 2.9% | 7609.71 ± 5.5% | 19.68 ± 0.3% | 69.60 ± 0.2% | 15800.96 ± 2.4% | 15.17 | 1.00 | 0.85 | 2.07 |
| class: two capitalized words | 1331 | 1106.19 ± 0.6% | 960.85 ± 0.1% | 26.42 ± 0.2% | 587.25 ± 0.2% | 40.94 ± 10.0% | 14.74 ± 0.5% | 68.34 ± 0.8% | 1106.12 ± 0.3% | 1.15 | 1.00 | 1.88 | 27.02 |
| class: a word that ends in ing | 3399 | 883.45 ± 0.2% | 885.14 ± 0.1% | 18.42 ± 0.2% | 549.98 ± 0.1% | 29.58 ± 4.7% | 8.18 ± 0.1% | 18.21 ± 0.2% | 883.40 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.87 |
| class: a word in capitals | 2332 | 1486.06 ± 0.5% | 960.13 ± 0.1% | 27.65 ± 0.1% | 574.90 ± 0.1% | 43.83 ± 0.1% | 17.17 ± 0.2% | 83.01 ± 0.2% | 1485.26 ± 0.3% | 1.55 | 1.00 | 2.58 | 33.91 |
| class: a number | 8288 | 2148.90 ± 0.2% | 810.46 ± 0.1% | 27.97 ± 0.3% | 1806.17 ± 0.1% | 41.04 ± 16.4% | 0.55 ± 0.2% | 56.67 ± 0.2% | 2144.31 ± 0.2% | 2.65 | 1.00 | 1.19 | 52.36 |
| class: two capitalized words, second text | 5359 | 699.30 ± 0.2% | 700.07 ± 0.1% | 23.71 ± 0.2% | 488.24 ± 0.2% | 35.39 ± 7.3% | 16.69 ± 0.1% | 63.40 ± 0.2% | 698.85 ± 0.2% | 1.00 | 1.00 | 1.43 | 19.76 |
| other: a word between two words | 6104 | 722.48 ± 0.2% | 753.45 ± 0.3% | 23.83 ± 0.2% | 752.13 ± 0.5% | 107.82 ± 16.7% | 11.25 ± 0.1% | 69.28 ± 0.5% | 722.91 ± 0.3% | 0.96 | 1.00 | 0.96 | 6.70 |
| other: a number before a unit, second text | 1481 | 5397.36 ± 0.5% | 979.99 ± 0.1% | 26.31 ± 0.2% | 5878.08 ± 0.5% | 40.96 ± 7.3% | 17.84 ± 0.2% | 66.83 ± 0.3% | 5381.02 ± 0.2% | 5.51 | 1.00 | 0.92 | 131.77 |
| other: a heading's start tag | 110 | 12329.72 ± 0.7% | 1040.85 ± 0.1% | 27.34 ± 0.2% | 1718.84 ± 0.2% | 1589.61 ± 3.6% | 16.04 ± 0.5% | 88.44 ± 0.2% | 12340.46 ± 0.8% | 11.85 | 1.00 | 7.17 | 7.76 |
| other: a whole word | 217 | 13720.24 ± 0.8% | 1040.91 ± 0.2% | 29.85 ± 0.6% | 14758.57 ± 1.6% | 49.42 ± 0.1% | 13.43 ± 0.3% | 55.91 ± 0.5% | 13682.62 ± 0.5% | 13.18 | 1.00 | 0.93 | 277.60 |
| other: a line's first word, second text | 3716 | 1771.64 ± 0.8% | 867.76 ± 0.6% | 31.42 ± 0.2% | 1757.89 ± 0.4% | 61.99 ± 6.3% | refused | refused | 1763.66 ± 0.3% | 2.04 | 1.00 | 1.01 | 28.58 |
| other: fourteen octets before an x | 87 | 13445.21 ± 1.0% | 1.53 ± 0.3% | 1.53 ± 0.3% | 4006.06 ± 0.7% | 10.67 ± 0.5% | differs | 17.68 ± 0.1% | 13418.99 ± 0.8% | 8792.42 | 1.00 | 3.36 | 1260.16 |
| other: a Greek word | 21815 | 474.70 ± 0.9% | 321.54 ± 0.2% | 31.33 ± 0.2% | 285.24 ± 0.2% | 49.16 ± 12.1% | differs | refused | 473.48 ± 1.0% | 1.48 | 1.00 | 1.66 | 9.66 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.88 ± 0.1% | 28.91 ± 0.3% | 0.49 ± 1.1% | 21.44 ± 0.1% | 2.76 ± 0.6% | differs | 4.00 ± 0.2% | 28.86 ± 0.3% | 1.00 | 1.00 | 1.35 | 10.47 |
| a UUID | 32895 | 23.43 ± 0.4% | 23.46 ± 0.3% | 0.66 ± 0.1% | 15.96 ± 0.3% | 3.10 ± 0.4% | 0.71 ± 0.2% | 3.61 ± 0.8% | 23.48 ± 0.4% | 1.00 | 1.00 | 1.47 | 7.56 |
| an IPv4 address | 33176 | 42.50 ± 0.3% | 42.47 ± 0.2% | 2.17 ± 0.1% | 32.45 ± 0.3% | 6.68 ± 0.1% | differs | 4.10 ± 0.2% | 42.48 ± 0.2% | 1.00 | 1.00 | 1.31 | 6.36 |
| a date and time | 32954 | 35.76 ± 0.7% | 35.75 ± 0.8% | 1.51 ± 0.2% | 23.15 ± 0.1% | 7.08 ± 0.1% | 1.20 ± 0.4% | 7.02 ± 0.1% | 35.76 ± 0.1% | 1.00 | 1.00 | 1.55 | 5.05 |
| a field path | 32606 | 33.16 ± 0.6% | 33.23 ± 0.5% | 0.83 ± 0.3% | 25.12 ± 0.3% | 3.50 ± 0.8% | differs | 2.94 ± 0.3% | 33.18 ± 0.5% | 1.00 | 1.00 | 1.32 | 9.48 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.41 ± 0.2% | 10.40 ± 0.3% | 10.41 ± 0.3% | 11.20 ± 0.1% | 4.95 ± 2.2% | 0.90 ± 0.4% | none | 10.40 ± 0.2% | 1.00 | 1.00 | 0.93 | 2.11 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 286.68 ± 0.3% | 288.30 ± 0.5% | 337.72 ± 0.2% | 86.45 ± 0.3% | 220.56 ± 6.7% | 484.47 ± 0.3% | 3785.57 ± 0.4% | 286.81 ± 0.4% | 0.99 | 1.00 | 3.32 | 1.30 |
| a UUID | 62 | 213.06 ± 0.8% | 214.15 ± 0.2% | 242.79 ± 0.4% | 45.71 ± 0.2% | 99.52 ± 1.6% | 180.04 ± 0.8% | 4281.83 ± 0.4% | 213.40 ± 0.3% | 0.99 | 1.00 | 4.66 | 2.14 |
| an IPv4 address | 29 | 439.25 ± 0.2% | 441.48 ± 0.4% | 573.19 ± 0.5% | 76.52 ± 0.9% | 130.71 ± 1.5% | 289.21 ± 0.3% | 7589.59 ± 0.5% | 438.84 ± 0.2% | 0.99 | 1.00 | 5.74 | 3.36 |
| a date and time | 56 | 283.40 ± 0.5% | 285.76 ± 0.3% | 336.80 ± 0.3% | 72.27 ± 0.3% | 130.07 ± 17.1% | 317.04 ± 1.3% | 4922.77 ± 0.8% | 283.42 ± 0.5% | 0.99 | 1.00 | 3.92 | 2.18 |
| a field path | 39 | 320.13 ± 0.3% | 322.06 ± 0.1% | 387.53 ± 0.3% | 79.79 ± 0.6% | 203.11 ± 3.2% | 484.14 ± 0.9% | 4857.32 ± 2.9% | 319.67 ± 0.3% | 0.99 | 1.00 | 4.01 | 1.58 |
| literal: a word | 7 | 790.37 ± 0.4% | 826.58 ± 0.2% | 1412.05 ± 0.1% | 509.69 ± 1.6% | 620.33 ± 2.8% | 916.90 ± 0.2% | 29768.68 ± 0.2% | 789.54 ± 0.3% | 0.96 | 1.00 | 1.55 | 1.27 |
| literal: a word that is not there | 8 | 758.26 ± 0.3% | 786.16 ± 0.3% | 1323.02 ± 0.2% | 466.01 ± 0.2% | 601.50 ± 4.9% | 868.65 ± 0.6% | 28502.61 ± 0.2% | 757.80 ± 0.3% | 0.96 | 1.00 | 1.63 | 1.26 |
| literal: one of four words | 26 | 419.94 ± 0.5% | 460.27 ± 0.8% | 604.74 ± 0.3% | 49.13 ± 0.5% | 242.59 ± 2.4% | 353.54 ± 0.4% | 15642.32 ± 0.2% | 420.45 ± 0.6% | 0.91 | 1.00 | 8.55 | 1.73 |
| literal: a word in any case | 11 | 690.90 ± 0.4% | 715.71 ± 0.7% | 1129.95 ± 0.5% | 15.67 ± 1.0% | 648.40 ± 1.5% | refused | 23367.41 ± 0.5% | 690.22 ± 0.4% | 0.97 | 1.00 | 44.08 | 1.07 |
| literal: an href attribute | 12 | 410.42 ± 0.5% | 415.87 ± 0.4% | 525.69 ± 0.7% | 44.87 ± 0.7% | 495.74 ± 1.5% | 783.16 ± 1.8% | 21264.38 ± 0.2% | 410.47 ± 0.3% | 0.99 | 1.00 | 9.15 | 0.83 |
| literal: a word, second text | 10 | 705.94 ± 0.2% | 733.24 ± 0.2% | 1180.32 ± 0.3% | 415.16 ± 0.4% | 540.13 ± 5.4% | 798.54 ± 0.4% | 26408.76 ± 0.1% | 705.42 ± 0.3% | 0.96 | 1.00 | 1.70 | 1.31 |
| class: two capitalized words | 23 | 432.80 ± 0.5% | 447.44 ± 0.5% | 579.85 ± 0.8% | 101.49 ± 0.3% | 501.83 ± 2.4% | 744.22 ± 0.8% | 6439.12 ± 0.5% | 432.45 ± 0.5% | 0.97 | 1.00 | 4.26 | 0.86 |
| class: a word that ends in ing | 9 | 672.66 ± 1.0% | 714.24 ± 0.9% | 1110.44 ± 0.0% | 133.35 ± 1.3% | 748.60 ± 1.7% | 1085.95 ± 0.7% | 15789.85 ± 0.2% | 671.86 ± 0.5% | 0.94 | 1.00 | 5.04 | 0.90 |
| class: a word in capitals | 16 | 518.57 ± 0.3% | 538.04 ± 0.5% | 733.64 ± 0.1% | 136.87 ± 0.9% | 741.18 ± 2.3% | 1035.14 ± 0.7% | 8483.39 ± 0.3% | 518.41 ± 0.3% | 0.96 | 1.00 | 3.79 | 0.70 |
| class: a number | 6 | 744.74 ± 0.3% | 780.80 ± 0.9% | 1271.13 ± 0.1% | 41.78 ± 1.0% | 1373.86 ± 6.4% | 1906.01 ± 1.7% | 22309.09 ± 0.2% | 743.71 ± 0.4% | 0.95 | 1.00 | 17.83 | 0.54 |
| class: two capitalized words, second text | 23 | 432.71 ± 0.7% | 446.29 ± 0.5% | 578.94 ± 0.5% | 103.46 ± 0.1% | 495.42 ± 2.2% | 764.70 ± 0.8% | 6438.99 ± 0.2% | 432.80 ± 0.2% | 0.97 | 1.00 | 4.18 | 0.87 |
| other: a word between two words | 13 | 619.80 ± 0.5% | 629.24 ± 0.5% | 923.54 ± 0.2% | 135.66 ± 0.5% | 495.47 ± 2.4% | 811.87 ± 0.6% | 14644.02 ± 0.4% | 619.94 ± 0.2% | 0.99 | 1.00 | 4.57 | 1.25 |
| other: a number before a unit, second text | 15 | 531.27 ± 0.5% | 564.78 ± 0.4% | 788.62 ± 0.1% | 39.51 ± 0.5% | 632.10 ± 2.8% | 886.69 ± 0.2% | 14909.14 ± 0.2% | 531.09 ± 0.3% | 0.94 | 1.00 | 13.45 | 0.84 |
| other: a heading's start tag | 13 | 392.35 ± 0.3% | 397.10 ± 0.1% | 500.89 ± 0.7% | 43.75 ± 1.7% | 620.06 ± 1.4% | 873.07 ± 0.8% | 17692.64 ± 0.3% | 391.92 ± 0.3% | 0.99 | 1.00 | 8.97 | 0.63 |
| other: a whole word | 11 | 729.77 ± 0.6% | 753.21 ± 0.4% | 1214.42 ± 0.4% | 121.04 ± 0.7% | 550.86 ± 4.6% | 822.75 ± 1.4% | 26657.06 ± 0.1% | 731.59 ± 0.5% | 0.97 | 1.00 | 6.03 | 1.32 |
| other: a line's first word, second text | 17 | 584.29 ± 0.6% | 606.95 ± 0.4% | 876.41 ± 0.2% | 127.59 ± 0.2% | 697.04 ± 1.1% | refused | refused | 581.05 ± 0.7% | 0.96 | 1.01 | 4.58 | 0.84 |
| other: fourteen octets before an x | 16 | 117.05 ± 0.4% | 157.72 ± 0.6% | 179.77 ± 0.8% | 14.95 ± 0.5% | 444.89 ± 2.9% | 404.70 ± 1.0% | 12761.49 ± 0.8% | 116.79 ± 0.7% | 0.74 | 1.00 | 7.83 | 0.26 |
| other: a Greek word | 8 | 710.01 ± 0.4% | 763.50 ± 1.1% | 1229.55 ± 0.6% | 58.85 ± 0.6% | 1361.29 ± 1.0% | 1802.38 ± 0.7% | refused | 709.08 ± 0.4% | 0.93 | 1.00 | 12.06 | 0.52 |

