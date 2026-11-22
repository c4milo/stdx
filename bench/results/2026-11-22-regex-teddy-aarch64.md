# bench-regex

| Field | Value |
|---|---|
| Commit | 822c457 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45024984481 |
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
| literal: a word | 217 | 15424.19 ± 1.2% | 1037.78 ± 0.2% | 28.06 ± 0.2% | 18353.47 ± 3.3% | 9139.59 ± 7.8% | 17.54 ± 0.5% | 86.75 ± 0.2% | 15397.05 ± 1.4% | 14.86 | 1.00 | 0.84 | 1.69 |
| literal: a word that is not there | 0 | 18222.24 ± 1.6% | 1048.67 ± 0.0% | 27.82 ± 0.4% | 19543.29 ± 1.9% | 28456.37 ± 1.9% | 17.37 ± 0.5% | 82.38 ± 0.3% | 18332.81 ± 1.7% | 17.38 | 0.99 | 0.93 | 0.64 |
| literal: one of four words | 661 | 5253.41 ± 0.8% | 1018.10 ± 0.1% | 14.73 ± 1.3% | 3977.18 ± 0.7% | 21.91 ± 0.3% | 5.31 ± 0.2% | 6.92 ± 0.2% | 5241.79 ± 0.2% | 5.16 | 1.00 | 1.32 | 239.79 |
| literal: a word in any case | 217 | 11526.86 ± 1.3% | 1038.54 ± 0.1% | 21.66 ± 2.0% | 3986.33 ± 0.3% | 38.61 ± 0.1% | refused | differs | 11523.86 ± 1.0% | 11.10 | 1.00 | 2.89 | 298.56 |
| literal: an href attribute | 33 | 15925.20 ± 1.0% | 1045.11 ± 0.1% | 27.14 ± 0.2% | 16662.66 ± 1.7% | 2259.51 ± 0.5% | 13.31 ± 0.3% | 75.49 ± 0.7% | 15990.07 ± 1.6% | 15.24 | 1.00 | 0.96 | 7.05 |
| literal: a word, second text | 123 | 15694.03 ± 2.1% | 1039.10 ± 0.1% | 27.58 ± 0.2% | 18116.98 ± 1.8% | 7740.85 ± 8.2% | 19.66 ± 0.5% | 69.85 ± 0.6% | 15600.24 ± 2.9% | 15.10 | 1.01 | 0.87 | 2.03 |
| class: two capitalized words | 1331 | 1098.07 ± 0.4% | 956.67 ± 0.1% | 25.94 ± 0.3% | 587.24 ± 0.1% | 40.91 ± 2.3% | 14.91 ± 0.3% | 68.86 ± 0.1% | 1096.38 ± 0.3% | 1.15 | 1.00 | 1.87 | 26.84 |
| class: a word that ends in ing | 3399 | 885.90 ± 0.1% | 882.05 ± 0.1% | 18.23 ± 0.2% | 550.37 ± 0.2% | 29.54 ± 10.4% | 8.24 ± 0.1% | 18.50 ± 0.6% | 884.36 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.99 |
| class: a word in capitals | 2332 | 1487.56 ± 0.8% | 954.12 ± 0.1% | 27.11 ± 0.2% | 575.20 ± 0.1% | 43.72 ± 10.2% | 17.16 ± 0.3% | 83.37 ± 0.3% | 1483.84 ± 0.3% | 1.56 | 1.00 | 2.59 | 34.03 |
| class: a number | 8288 | 2142.49 ± 0.2% | 809.00 ± 0.1% | 27.42 ± 0.1% | 1804.31 ± 0.4% | 41.01 ± 12.5% | 0.55 ± 0.3% | 56.52 ± 0.6% | 2138.32 ± 0.2% | 2.65 | 1.00 | 1.19 | 52.24 |
| class: two capitalized words, second text | 5359 | 695.38 ± 0.2% | 670.66 ± 0.3% | 23.39 ± 0.3% | 487.22 ± 0.1% | 35.56 ± 15.5% | 16.66 ± 0.4% | 64.00 ± 0.3% | 695.25 ± 0.2% | 1.04 | 1.00 | 1.43 | 19.56 |
| other: a word between two words | 6104 | 725.82 ± 0.8% | 752.40 ± 0.1% | 23.44 ± 0.3% | 755.60 ± 0.5% | 109.29 ± 22.5% | 11.32 ± 0.1% | 69.72 ± 0.2% | 724.59 ± 0.2% | 0.96 | 1.00 | 0.96 | 6.64 |
| other: a number before a unit, second text | 1481 | 5477.31 ± 0.8% | 975.35 ± 0.1% | 25.72 ± 0.1% | 5934.91 ± 0.4% | 40.90 ± 0.2% | 17.79 ± 0.2% | 67.05 ± 0.2% | 5484.23 ± 0.9% | 5.62 | 1.00 | 0.92 | 133.91 |
| other: a heading's start tag | 110 | 12239.40 ± 0.8% | 1038.92 ± 0.1% | 26.77 ± 0.2% | 1719.48 ± 0.2% | 1583.84 ± 2.9% | 16.13 ± 0.5% | 89.02 ± 0.3% | 12254.81 ± 0.5% | 11.78 | 1.00 | 7.12 | 7.73 |
| other: a whole word | 217 | 13562.20 ± 1.0% | 1038.53 ± 0.1% | 29.19 ± 0.3% | 14646.75 ± 1.3% | 49.36 ± 0.3% | 13.70 ± 0.4% | 55.65 ± 0.4% | 13530.30 ± 1.1% | 13.06 | 1.00 | 0.93 | 274.76 |
| other: a line's first word, second text | 3716 | 1972.09 ± 0.5% | 863.51 ± 0.2% | 30.75 ± 0.2% | 1762.53 ± 0.6% | 62.05 ± 6.5% | refused | refused | 1967.42 ± 0.8% | 2.28 | 1.00 | 1.12 | 31.78 |
| other: fourteen octets before an x | 87 | 18948.31 ± 1.7% | 1.54 ± 0.2% | 1.54 ± 0.3% | 3924.80 ± 0.6% | 10.67 ± 0.4% | differs | 17.77 ± 0.2% | 18895.93 ± 1.6% | 12264.69 | 1.00 | 4.83 | 1775.21 |
| other: a Greek word | 21815 | 477.67 ± 0.8% | 324.06 ± 0.3% | 31.24 ± 0.2% | 294.35 ± 0.1% | 47.62 ± 9.4% | differs | refused | 475.05 ± 0.6% | 1.47 | 1.01 | 1.62 | 10.03 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.70 ± 0.2% | 28.68 ± 0.2% | 0.50 ± 0.1% | 21.55 ± 0.2% | 2.74 ± 0.6% | differs | 4.02 ± 0.4% | 28.70 ± 0.1% | 1.00 | 1.00 | 1.33 | 10.49 |
| a UUID | 32895 | 23.25 ± 0.2% | 23.23 ± 0.5% | 0.67 ± 0.1% | 16.05 ± 0.1% | 3.10 ± 0.6% | 0.72 ± 0.5% | 3.59 ± 0.4% | 23.25 ± 0.3% | 1.00 | 1.00 | 1.45 | 7.50 |
| an IPv4 address | 33176 | 42.46 ± 0.2% | 42.45 ± 0.1% | 2.18 ± 0.3% | 32.60 ± 0.2% | 6.67 ± 0.2% | differs | 4.17 ± 0.2% | 42.47 ± 0.3% | 1.00 | 1.00 | 1.30 | 6.37 |
| a date and time | 32954 | 35.38 ± 0.2% | 35.40 ± 0.1% | 1.51 ± 0.2% | 23.29 ± 0.4% | 7.10 ± 0.2% | 1.19 ± 0.2% | 7.02 ± 0.4% | 35.40 ± 0.6% | 1.00 | 1.00 | 1.52 | 4.98 |
| a field path | 32606 | 33.02 ± 0.4% | 33.03 ± 0.3% | 0.84 ± 0.3% | 25.27 ± 0.2% | 3.50 ± 0.6% | differs | 2.97 ± 0.3% | 33.01 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.16 ± 2.5% | 10.18 ± 2.6% | 10.16 ± 2.5% | 11.04 ± 0.2% | 4.82 ± 1.1% | 0.91 ± 1.3% | none | 10.16 ± 2.4% | 1.00 | 1.00 | 0.92 | 2.11 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 292.74 ± 0.2% | 294.26 ± 0.3% | 348.56 ± 0.3% | 86.13 ± 0.4% | 218.64 ± 3.3% | 484.99 ± 0.8% | 3854.90 ± 0.4% | 293.10 ± 0.5% | 0.99 | 1.00 | 3.40 | 1.34 |
| a UUID | 62 | 219.37 ± 0.2% | 220.08 ± 0.6% | 251.56 ± 0.3% | 46.41 ± 0.8% | 97.56 ± 1.7% | 189.39 ± 3.2% | 4440.70 ± 0.3% | 219.15 ± 0.3% | 1.00 | 1.00 | 4.73 | 2.25 |
| an IPv4 address | 29 | 453.37 ± 0.2% | 458.10 ± 0.2% | 603.21 ± 0.2% | 76.94 ± 0.5% | 127.89 ± 0.2% | 292.06 ± 0.9% | 7626.24 ± 0.4% | 452.62 ± 0.6% | 0.99 | 1.00 | 5.89 | 3.55 |
| a date and time | 56 | 293.04 ± 0.3% | 294.44 ± 0.6% | 350.56 ± 0.1% | 72.80 ± 0.1% | 134.08 ± 2.9% | 326.44 ± 2.1% | 4913.93 ± 0.3% | 293.15 ± 0.3% | 1.00 | 1.00 | 4.03 | 2.19 |
| a field path | 39 | 331.58 ± 0.4% | 332.65 ± 0.4% | 403.06 ± 0.2% | 80.84 ± 1.8% | 203.43 ± 3.8% | 506.04 ± 2.6% | 4946.61 ± 0.7% | 331.65 ± 0.3% | 1.00 | 1.00 | 4.10 | 1.63 |
| literal: a word | 7 | 785.35 ± 0.9% | 807.69 ± 0.3% | 1401.92 ± 0.1% | 513.87 ± 0.2% | 617.92 ± 2.7% | 965.93 ± 1.4% | 30410.79 ± 0.2% | 785.76 ± 0.6% | 0.97 | 1.00 | 1.53 | 1.27 |
| literal: a word that is not there | 8 | 757.12 ± 0.2% | 779.02 ± 0.3% | 1313.18 ± 0.2% | 465.85 ± 0.3% | 597.91 ± 9.5% | 915.81 ± 0.2% | 29155.51 ± 0.6% | 756.51 ± 0.2% | 0.97 | 1.00 | 1.63 | 1.27 |
| literal: one of four words | 26 | 412.62 ± 0.4% | 453.77 ± 0.3% | 599.81 ± 0.4% | 49.60 ± 0.9% | 239.74 ± 4.0% | 368.92 ± 1.5% | 15617.55 ± 0.2% | 412.16 ± 0.2% | 0.91 | 1.00 | 8.32 | 1.72 |
| literal: a word in any case | 11 | 684.56 ± 0.3% | 714.55 ± 0.2% | 1152.93 ± 0.2% | 15.64 ± 0.2% | 649.29 ± 7.2% | refused | 23587.70 ± 0.6% | 684.60 ± 0.2% | 0.96 | 1.00 | 43.76 | 1.05 |
| literal: an href attribute | 12 | 415.32 ± 0.7% | 421.63 ± 0.4% | 542.60 ± 0.5% | 45.83 ± 0.3% | 494.66 ± 3.7% | 787.00 ± 0.9% | 21773.35 ± 0.3% | 414.46 ± 0.6% | 0.99 | 1.00 | 9.06 | 0.84 |
| literal: a word, second text | 10 | 704.65 ± 0.2% | 727.76 ± 0.3% | 1179.00 ± 0.2% | 383.68 ± 0.2% | 532.98 ± 1.1% | 822.65 ± 0.4% | 27007.58 ± 0.6% | 704.75 ± 0.1% | 0.97 | 1.00 | 1.84 | 1.32 |
| class: two capitalized words | 23 | 443.50 ± 0.6% | 459.59 ± 0.6% | 607.83 ± 1.0% | 99.04 ± 0.1% | 495.56 ± 1.2% | 767.23 ± 1.5% | 6507.84 ± 0.6% | 443.15 ± 0.5% | 0.96 | 1.00 | 4.48 | 0.89 |
| class: a word that ends in ing | 9 | 679.33 ± 0.6% | 726.12 ± 0.8% | 1166.93 ± 0.2% | 131.51 ± 0.2% | 749.53 ± 1.7% | 1109.91 ± 1.1% | 15953.73 ± 0.3% | 680.90 ± 0.2% | 0.94 | 1.00 | 5.17 | 0.91 |
| class: a word in capitals | 16 | 534.52 ± 0.6% | 559.13 ± 0.6% | 788.43 ± 0.2% | 135.36 ± 0.4% | 736.30 ± 1.7% | 1033.50 ± 3.2% | 8601.71 ± 0.8% | 534.08 ± 0.4% | 0.96 | 1.00 | 3.95 | 0.73 |
| class: a number | 6 | 760.49 ± 0.6% | 802.68 ± 0.7% | 1363.11 ± 0.1% | 41.77 ± 1.2% | 1378.87 ± 1.9% | 1885.11 ± 2.1% | 22848.56 ± 0.2% | 758.23 ± 0.4% | 0.95 | 1.00 | 18.21 | 0.55 |
| class: two capitalized words, second text | 23 | 443.73 ± 0.4% | 458.71 ± 0.5% | 606.50 ± 0.3% | 100.66 ± 0.7% | 495.44 ± 3.2% | 764.24 ± 0.8% | 6500.18 ± 0.3% | 443.77 ± 1.0% | 0.97 | 1.00 | 4.41 | 0.90 |
| other: a word between two words | 13 | 629.14 ± 0.7% | 640.19 ± 0.5% | 961.90 ± 0.2% | 133.70 ± 0.3% | 503.95 ± 2.7% | 814.71 ± 0.7% | 14875.51 ± 0.1% | 626.39 ± 0.4% | 0.98 | 1.00 | 4.71 | 1.25 |
| other: a number before a unit, second text | 15 | 538.90 ± 0.6% | 578.74 ± 0.6% | 827.47 ± 0.5% | 39.35 ± 0.9% | 629.13 ± 5.9% | 891.50 ± 1.8% | 15171.11 ± 0.1% | 538.51 ± 0.9% | 0.93 | 1.00 | 13.69 | 0.86 |
| other: a heading's start tag | 13 | 401.46 ± 0.9% | 406.12 ± 0.5% | 518.89 ± 0.4% | 43.61 ± 0.8% | 630.11 ± 2.1% | 866.26 ± 0.7% | 18096.83 ± 0.1% | 399.91 ± 0.4% | 0.99 | 1.00 | 9.20 | 0.64 |
| other: a whole word | 11 | 716.30 ± 0.3% | 738.41 ± 0.4% | 1208.62 ± 0.3% | 118.57 ± 0.2% | 560.90 ± 1.3% | 826.26 ± 0.4% | 26906.47 ± 0.5% | 716.23 ± 0.4% | 0.97 | 1.00 | 6.04 | 1.28 |
| other: a line's first word, second text | 17 | 597.92 ± 0.2% | 620.52 ± 0.1% | 911.58 ± 0.3% | 129.61 ± 0.2% | 705.23 ± 2.3% | refused | refused | 596.92 ± 1.5% | 0.96 | 1.00 | 4.61 | 0.85 |
| other: fourteen octets before an x | 16 | 117.13 ± 1.5% | 157.48 ± 0.8% | 180.97 ± 1.0% | 15.04 ± 0.3% | 446.14 ± 3.8% | 413.01 ± 1.2% | 12972.47 ± 0.2% | 117.33 ± 1.8% | 0.74 | 1.00 | 7.79 | 0.26 |
| other: a Greek word | 8 | 717.28 ± 0.8% | 768.17 ± 1.4% | 1268.93 ± 0.6% | 59.13 ± 0.2% | 1381.33 ± 5.8% | 1833.33 ± 0.7% | refused | 716.34 ± 0.2% | 0.93 | 1.00 | 12.13 | 0.52 |

