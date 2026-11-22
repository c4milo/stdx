# bench-regex

| Field | Value |
|---|---|
| Commit | 1b0002a |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
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
| literal: a word | 217 | 24680.64 ± 1.3% | 835.44 ± 0.1% | 24.61 ± 1.1% | 23300.58 ± 2.0% | 8895.83 ± 7.5% | 11.61 ± 0.6% | 88.17 ± 0.8% | 24677.10 ± 0.2% | 29.54 | 1.00 | 1.06 | 2.77 |
| literal: a word that is not there | 0 | 29718.98 ± 0.7% | 844.47 ± 0.6% | 24.36 ± 2.1% | 25242.83 ± 0.7% | 28279.37 ± 1.0% | 11.32 ± 0.3% | 83.06 ± 0.7% | 29641.40 ± 1.3% | 35.19 | 1.00 | 1.18 | 1.05 |
| literal: one of four words | 661 | 5659.63 ± 1.2% | 817.16 ± 0.4% | 14.56 ± 0.8% | 7546.73 ± 0.9% | 21.31 ± 1.2% | 3.40 ± 0.2% | 6.64 ± 1.9% | 5649.36 ± 0.6% | 6.93 | 1.00 | 0.75 | 265.54 |
| literal: a word in any case | 217 | 19748.37 ± 0.8% | 833.84 ± 0.5% | 18.26 ± 0.8% | 7718.11 ± 0.8% | 42.43 ± 2.5% | refused | differs | 19665.11 ± 1.2% | 23.68 | 1.00 | 2.56 | 465.47 |
| literal: an href attribute | 33 | 23544.93 ± 0.3% | 839.01 ± 0.7% | 22.48 ± 1.5% | 20704.00 ± 12.2% | 1991.35 ± 2.8% | 8.28 ± 3.2% | 76.15 ± 4.4% | 23512.27 ± 1.4% | 28.06 | 1.00 | 1.14 | 11.82 |
| literal: a word, second text | 123 | 25492.14 ± 0.4% | 836.57 ± 0.2% | 24.60 ± 1.5% | 23074.20 ± 0.5% | 6863.21 ± 4.1% | 15.09 ± 0.6% | 74.07 ± 0.5% | 25378.33 ± 0.5% | 30.47 | 1.00 | 1.10 | 3.71 |
| class: two capitalized words | 1331 | 767.40 ± 0.8% | 771.10 ± 0.4% | 23.06 ± 1.4% | 471.09 ± 1.2% | 37.02 ± 9.0% | 9.88 ± 0.2% | 63.23 ± 0.9% | 765.38 ± 1.6% | 1.00 | 1.00 | 1.63 | 20.73 |
| class: a word that ends in ing | 3399 | 701.61 ± 0.5% | 704.09 ± 0.6% | 15.74 ± 1.0% | 443.30 ± 0.5% | 26.44 ± 3.3% | 5.55 ± 3.0% | 16.96 ± 1.1% | 704.74 ± 0.2% | 1.00 | 1.00 | 1.58 | 26.53 |
| class: a word in capitals | 2332 | 1048.56 ± 0.8% | 757.53 ± 0.6% | 24.03 ± 3.2% | 463.65 ± 0.2% | 40.14 ± 14.5% | 11.92 ± 0.8% | 78.97 ± 0.6% | 1041.64 ± 0.9% | 1.38 | 1.01 | 2.26 | 26.12 |
| class: a number | 8288 | 1578.40 ± 0.9% | 646.84 ± 0.4% | 23.75 ± 1.9% | 1646.65 ± 2.4% | 41.56 ± 15.2% | 0.33 ± 0.1% | 55.51 ± 1.9% | 1577.52 ± 2.8% | 2.44 | 1.00 | 0.96 | 37.98 |
| class: two capitalized words, second text | 5359 | 557.83 ± 0.7% | 554.23 ± 0.9% | 20.94 ± 1.9% | 392.86 ± 0.4% | 32.14 ± 11.6% | 12.93 ± 0.1% | 57.58 ± 3.8% | 555.09 ± 0.6% | 1.01 | 1.00 | 1.42 | 17.36 |
| other: a word between two words | 6104 | 660.96 ± 0.4% | 597.97 ± 0.4% | 20.84 ± 1.9% | 672.10 ± 1.5% | 103.68 ± 16.3% | 7.53 ± 0.3% | 66.56 ± 2.1% | 659.56 ± 1.6% | 1.11 | 1.00 | 0.98 | 6.37 |
| other: a number before a unit, second text | 1481 | 7738.24 ± 3.9% | 788.23 ± 0.5% | 23.34 ± 0.9% | 7208.09 ± 0.5% | 37.57 ± 0.5% | 13.63 ± 0.3% | 61.57 ± 0.6% | 7524.60 ± 1.7% | 9.82 | 1.03 | 1.07 | 205.94 |
| other: a heading's start tag | 110 | 15712.59 ± 1.4% | 831.59 ± 0.3% | 24.09 ± 1.1% | 2012.00 ± 0.3% | 1473.18 ± 3.8% | 10.27 ± 2.7% | 89.59 ± 4.5% | 15676.52 ± 4.0% | 18.89 | 1.00 | 7.81 | 10.67 |
| other: a whole word | 217 | 19183.74 ± 0.3% | 834.76 ± 0.2% | 23.86 ± 1.9% | 18473.89 ± 0.6% | 42.95 ± 1.1% | 9.83 ± 0.3% | 51.90 ± 1.3% | 19141.90 ± 0.4% | 22.98 | 1.00 | 1.04 | 446.70 |
| other: a line's first word, second text | 3716 | 1972.99 ± 1.8% | 690.00 ± 0.5% | 25.40 ± 1.0% | 1932.07 ± 0.6% | 61.43 ± 6.3% | refused | refused | 1957.37 ± 0.9% | 2.86 | 1.01 | 1.02 | 32.12 |
| other: fourteen octets before an x | 87 | 19531.40 ± 1.0% | 1.52 ± 0.6% | 1.47 ± 0.5% | 3254.49 ± 1.9% | 8.89 ± 0.6% | differs | 15.96 ± 2.0% | 19346.92 ± 1.6% | 12890.73 | 1.01 | 6.00 | 2198.06 |
| other: a Greek word | 21815 | 392.20 ± 0.3% | 264.16 ± 0.4% | 27.87 ± 1.4% | 248.22 ± 1.0% | 46.00 ± 9.9% | differs | refused | 391.67 ± 0.7% | 1.48 | 1.00 | 1.58 | 8.53 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.40 ± 0.8% | 23.43 ± 0.9% | 0.51 ± 0.5% | 21.71 ± 0.4% | 2.44 ± 0.6% | differs | 3.71 ± 0.8% | 23.39 ± 0.4% | 1.00 | 1.00 | 1.08 | 9.59 |
| a UUID | 32895 | 20.90 ± 0.5% | 20.87 ± 0.4% | 0.56 ± 0.7% | 16.22 ± 1.0% | 2.39 ± 2.6% | 0.55 ± 0.4% | 3.05 ± 1.7% | 20.88 ± 0.6% | 1.00 | 1.00 | 1.29 | 8.73 |
| an IPv4 address | 33176 | 31.84 ± 0.8% | 31.73 ± 0.3% | 1.79 ± 2.3% | 29.62 ± 0.5% | 5.82 ± 0.2% | differs | 3.43 ± 0.4% | 31.78 ± 0.3% | 1.00 | 1.00 | 1.07 | 5.47 |
| a date and time | 32954 | 31.36 ± 0.5% | 31.28 ± 0.7% | 1.23 ± 2.6% | 26.48 ± 0.3% | 7.31 ± 1.1% | 1.01 ± 0.4% | 6.76 ± 2.0% | 31.39 ± 0.9% | 1.00 | 1.00 | 1.18 | 4.29 |
| a field path | 32606 | 25.44 ± 0.7% | 25.40 ± 0.7% | 0.81 ± 0.5% | 23.69 ± 0.4% | 2.73 ± 0.2% | differs | 2.27 ± 0.8% | 25.38 ± 0.8% | 1.00 | 1.00 | 1.07 | 9.31 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.54 ± 0.4% | 8.53 ± 0.9% | 8.53 ± 0.5% | 11.82 ± 0.7% | 4.73 ± 3.0% | 0.79 ± 2.4% | none | 8.55 ± 1.1% | 1.00 | 1.00 | 0.72 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 291.14 ± 0.2% | 292.56 ± 0.4% | 336.60 ± 0.8% | 83.03 ± 2.7% | 193.87 ± 1.6% | 527.45 ± 2.4% | 3174.61 ± 3.3% | 291.27 ± 0.1% | 1.00 | 1.00 | 3.51 | 1.50 |
| a UUID | 62 | 213.27 ± 2.8% | 214.09 ± 1.9% | 244.25 ± 1.0% | 44.98 ± 3.2% | 89.38 ± 13.8% | 191.94 ± 2.5% | 4115.99 ± 0.8% | 214.07 ± 0.6% | 1.00 | 1.00 | 4.74 | 2.39 |
| an IPv4 address | 29 | 477.41 ± 1.3% | 481.50 ± 0.6% | 613.90 ± 0.7% | 73.16 ± 1.1% | 116.97 ± 2.3% | 326.37 ± 2.3% | 6784.22 ± 2.7% | 477.89 ± 2.0% | 0.99 | 1.00 | 6.53 | 4.08 |
| a date and time | 56 | 308.78 ± 0.6% | 309.39 ± 1.2% | 359.49 ± 0.9% | 69.84 ± 0.9% | 123.11 ± 0.6% | 349.83 ± 1.8% | 4329.88 ± 0.1% | 308.34 ± 0.2% | 1.00 | 1.00 | 4.42 | 2.51 |
| a field path | 39 | 339.03 ± 0.8% | 340.17 ± 0.6% | 399.08 ± 1.0% | 75.91 ± 4.2% | 182.63 ± 36.0% | 539.79 ± 4.8% | 4030.31 ± 1.3% | 338.60 ± 0.7% | 1.00 | 1.00 | 4.47 | 1.86 |
| literal: a word | 7 | 898.09 ± 4.9% | 934.07 ± 0.9% | 1542.73 ± 1.3% | 504.25 ± 1.0% | 605.04 ± 0.9% | 1092.18 ± 2.3% | 26721.07 ± 1.4% | 904.80 ± 2.3% | 0.96 | 0.99 | 1.78 | 1.48 |
| literal: a word that is not there | 8 | 838.65 ± 1.4% | 865.76 ± 4.0% | 1401.16 ± 5.5% | 467.71 ± 5.1% | 575.10 ± 8.2% | 1022.99 ± 4.7% | 25746.46 ± 1.4% | 842.38 ± 0.5% | 0.97 | 1.00 | 1.79 | 1.46 |
| literal: one of four words | 26 | 484.72 ± 0.8% | 531.07 ± 5.7% | 691.77 ± 6.4% | 39.93 ± 2.0% | 225.33 ± 13.0% | 389.71 ± 0.8% | 15223.25 ± 0.6% | 485.23 ± 0.7% | 0.91 | 1.00 | 12.14 | 2.15 |
| literal: a word in any case | 11 | 774.79 ± 4.2% | 807.59 ± 0.8% | 1235.58 ± 0.7% | 11.94 ± 0.8% | 621.67 ± 3.4% | refused | 20248.79 ± 4.7% | 775.37 ± 0.9% | 0.96 | 1.00 | 64.91 | 1.25 |
| literal: an href attribute | 12 | 426.52 ± 0.9% | 431.96 ± 0.9% | 547.87 ± 1.1% | 37.20 ± 1.1% | 456.23 ± 2.6% | 877.74 ± 1.1% | 18692.81 ± 2.2% | 425.81 ± 0.8% | 0.99 | 1.00 | 11.47 | 0.93 |
| literal: a word, second text | 10 | 794.42 ± 0.5% | 819.19 ± 1.5% | 1272.38 ± 1.2% | 428.68 ± 1.1% | 503.75 ± 2.4% | 907.14 ± 0.8% | 24131.43 ± 0.6% | 794.62 ± 0.7% | 0.97 | 1.00 | 1.85 | 1.58 |
| class: two capitalized words | 23 | 485.04 ± 0.8% | 496.12 ± 0.6% | 636.02 ± 1.1% | 101.93 ± 1.0% | 462.89 ± 1.1% | 862.79 ± 2.3% | 5743.32 ± 1.0% | 484.71 ± 0.6% | 0.98 | 1.00 | 4.76 | 1.05 |
| class: a word that ends in ing | 9 | 759.74 ± 0.3% | 797.42 ± 0.2% | 1209.65 ± 0.9% | 127.61 ± 4.8% | 688.31 ± 2.2% | 1315.23 ± 1.3% | 14204.34 ± 1.2% | 759.66 ± 1.2% | 0.95 | 1.00 | 5.95 | 1.10 |
| class: a word in capitals | 16 | 573.58 ± 0.8% | 588.42 ± 0.6% | 789.54 ± 1.1% | 135.29 ± 1.5% | 689.21 ± 20.1% | 1224.41 ± 1.5% | 7558.63 ± 3.7% | 571.89 ± 5.8% | 0.97 | 1.00 | 4.24 | 0.83 |
| class: a number | 6 | 843.64 ± 0.6% | 877.82 ± 0.7% | 1393.19 ± 0.5% | 34.45 ± 3.3% | 1250.02 ± 7.1% | 2275.64 ± 0.9% | 20277.39 ± 2.0% | 845.44 ± 0.2% | 0.96 | 1.00 | 24.49 | 0.67 |
| class: two capitalized words, second text | 23 | 483.53 ± 4.5% | 498.12 ± 0.6% | 636.80 ± 6.1% | 99.66 ± 1.3% | 464.61 ± 0.4% | 854.99 ± 0.8% | 5750.68 ± 0.7% | 485.71 ± 0.7% | 0.97 | 1.00 | 4.85 | 1.04 |
| other: a word between two words | 13 | 695.81 ± 0.7% | 708.48 ± 0.6% | 1013.10 ± 0.5% | 132.09 ± 0.6% | 462.53 ± 1.6% | 914.87 ± 0.8% | 12944.62 ± 0.8% | 699.80 ± 0.7% | 0.98 | 0.99 | 5.27 | 1.50 |
| other: a number before a unit, second text | 15 | 582.04 ± 0.4% | 614.65 ± 4.1% | 837.61 ± 1.1% | 32.23 ± 1.5% | 571.23 ± 15.1% | 1045.51 ± 1.4% | 13216.59 ± 0.9% | 581.74 ± 0.8% | 0.95 | 1.00 | 18.06 | 1.02 |
| other: a heading's start tag | 13 | 406.49 ± 1.0% | 409.13 ± 0.6% | 517.85 ± 1.0% | 36.25 ± 1.9% | 564.04 ± 2.1% | 1003.29 ± 1.6% | 15752.57 ± 2.7% | 406.55 ± 1.3% | 0.99 | 1.00 | 11.21 | 0.72 |
| other: a whole word | 11 | 820.05 ± 0.8% | 839.90 ± 0.6% | 1304.45 ± 0.9% | 118.58 ± 1.1% | 526.03 ± 28.3% | 964.69 ± 0.9% | 22651.76 ± 0.8% | 820.22 ± 0.3% | 0.98 | 1.00 | 6.92 | 1.56 |
| other: a line's first word, second text | 17 | 649.02 ± 1.6% | 676.36 ± 1.3% | 951.59 ± 1.2% | 130.71 ± 0.8% | 630.74 ± 1.9% | refused | refused | 646.53 ± 0.9% | 0.96 | 1.00 | 4.97 | 1.03 |
| other: fourteen octets before an x | 16 | 105.71 ± 0.2% | 138.17 ± 0.8% | 162.51 ± 6.5% | 13.86 ± 0.9% | 410.36 ± 12.4% | 452.94 ± 1.6% | 11560.81 ± 3.0% | 105.52 ± 4.3% | 0.77 | 1.00 | 7.62 | 0.26 |
| other: a Greek word | 8 | 756.01 ± 1.0% | 806.17 ± 1.1% | 1251.38 ± 0.8% | 46.11 ± 3.1% | 1233.34 ± 1.5% | 2164.79 ± 0.3% | refused | 762.04 ± 0.6% | 0.94 | 0.99 | 16.40 | 0.61 |

