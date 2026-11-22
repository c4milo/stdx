# bench-regex

| Field | Value |
|---|---|
| Commit | 988748a |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
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
| literal: a word | 217 | 15608.81 ± 2.1% | 1049.11 ± 0.6% | 28.80 ± 0.3% | 18441.22 ± 2.1% | 9139.37 ± 8.5% | 17.29 ± 0.4% | 86.19 ± 0.1% | 15649.78 ± 1.8% | 14.88 | 1.00 | 0.85 | 1.71 |
| literal: a word that is not there | 0 | 18705.47 ± 1.1% | 1058.71 ± 0.2% | 28.43 ± 0.2% | 19727.34 ± 1.7% | 28893.84 ± 1.7% | 17.14 ± 0.1% | 82.84 ± 0.1% | 18699.31 ± 1.7% | 17.67 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 4170.70 ± 0.1% | 1027.53 ± 0.9% | 14.97 ± 0.3% | 3979.70 ± 0.2% | 21.58 ± 0.1% | 5.36 ± 0.4% | 6.65 ± 0.6% | 4169.23 ± 0.5% | 4.06 | 1.00 | 1.05 | 193.30 |
| literal: a word in any case | 217 | 11624.07 ± 0.9% | 1048.39 ± 0.2% | 21.98 ± 0.1% | 3988.30 ± 0.5% | 38.63 ± 0.4% | refused | differs | 11627.96 ± 0.3% | 11.09 | 1.00 | 2.91 | 300.87 |
| literal: an href attribute | 33 | 16195.52 ± 1.2% | 1055.20 ± 0.2% | 27.71 ± 0.1% | 16900.81 ± 1.7% | 2255.53 ± 0.3% | 12.88 ± 0.6% | 75.62 ± 0.7% | 16182.64 ± 0.8% | 15.35 | 1.00 | 0.96 | 7.18 |
| literal: a word, second text | 123 | 15912.87 ± 1.5% | 1050.36 ± 0.3% | 28.35 ± 0.2% | 18613.27 ± 1.1% | 7649.73 ± 5.6% | 20.02 ± 0.5% | 70.18 ± 0.3% | 15934.48 ± 1.1% | 15.15 | 1.00 | 0.85 | 2.08 |
| class: two capitalized words | 1331 | 1096.41 ± 0.3% | 965.78 ± 0.1% | 26.51 ± 0.4% | 584.24 ± 0.1% | 40.83 ± 12.9% | 14.80 ± 0.3% | 69.36 ± 0.3% | 1096.83 ± 0.2% | 1.14 | 1.00 | 1.88 | 26.85 |
| class: a word that ends in ing | 3399 | 892.35 ± 0.1% | 893.56 ± 0.0% | 18.43 ± 0.2% | 547.96 ± 0.1% | 29.39 ± 2.8% | 8.15 ± 0.2% | 18.60 ± 0.1% | 891.57 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.36 |
| class: a word in capitals | 2332 | 1477.35 ± 0.6% | 961.94 ± 0.1% | 27.63 ± 0.3% | 575.46 ± 0.2% | 43.59 ± 2.6% | 17.15 ± 0.2% | 83.98 ± 0.4% | 1476.92 ± 0.5% | 1.54 | 1.00 | 2.57 | 33.89 |
| class: a number | 8288 | 2117.73 ± 0.2% | 815.13 ± 0.1% | 28.09 ± 0.3% | 1811.55 ± 0.2% | 43.06 ± 17.2% | 0.53 ± 0.3% | 57.41 ± 1.0% | 2118.09 ± 0.1% | 2.60 | 1.00 | 1.17 | 49.18 |
| class: two capitalized words, second text | 5359 | 699.60 ± 0.2% | 699.79 ± 0.1% | 23.82 ± 0.1% | 490.75 ± 0.0% | 35.08 ± 6.4% | 17.33 ± 0.3% | 64.46 ± 0.3% | 699.54 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.94 |
| other: a word between two words | 6104 | 742.83 ± 0.2% | 754.87 ± 0.1% | 23.88 ± 0.3% | 749.39 ± 0.6% | 107.84 ± 9.4% | 11.23 ± 0.2% | 69.85 ± 0.2% | 742.79 ± 0.2% | 0.98 | 1.00 | 0.99 | 6.89 |
| other: a number before a unit, second text | 1481 | 5363.63 ± 0.6% | 984.55 ± 0.1% | 26.26 ± 0.3% | 5898.01 ± 0.4% | 40.79 ± 15.6% | 18.25 ± 0.2% | 67.53 ± 0.2% | 5430.05 ± 0.3% | 5.45 | 0.99 | 0.91 | 131.50 |
| other: a heading's start tag | 110 | 12486.61 ± 0.4% | 1046.69 ± 0.1% | 27.49 ± 0.2% | 1720.64 ± 0.3% | 1580.52 ± 6.0% | 16.05 ± 0.5% | 90.31 ± 0.3% | 12485.88 ± 0.5% | 11.93 | 1.00 | 7.26 | 7.90 |
| other: a whole word | 217 | 13731.13 ± 0.6% | 1048.40 ± 0.2% | 30.18 ± 0.5% | 14832.16 ± 1.3% | 49.15 ± 0.4% | 13.26 ± 0.2% | 56.04 ± 0.4% | 13744.54 ± 0.8% | 13.10 | 1.00 | 0.93 | 279.38 |
| other: a line's first word, second text | 3716 | 1935.98 ± 0.4% | 869.61 ± 0.1% | 31.81 ± 0.2% | 1748.13 ± 0.3% | 62.13 ± 5.8% | refused | refused | 1931.52 ± 0.5% | 2.23 | 1.00 | 1.11 | 31.16 |
| other: fourteen octets before an x | 87 | 18960.23 ± 1.5% | 1.53 ± 0.1% | 1.53 ± 0.2% | 3962.79 ± 0.5% | 10.67 ± 0.2% | differs | 17.73 ± 0.1% | 18871.17 ± 0.5% | 12366.11 | 1.00 | 4.78 | 1777.24 |
| other: a Greek word | 21815 | 477.28 ± 0.8% | 323.53 ± 0.5% | 31.53 ± 0.1% | 295.43 ± 0.6% | 44.27 ± 9.9% | differs | refused | 474.35 ± 0.9% | 1.48 | 1.01 | 1.62 | 10.78 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.67 ± 0.4% | 28.68 ± 0.2% | 0.50 ± 0.1% | 21.33 ± 0.3% | 2.76 ± 0.6% | differs | 4.07 ± 0.2% | 28.68 ± 0.2% | 1.00 | 1.00 | 1.34 | 10.40 |
| a UUID | 32895 | 23.22 ± 0.2% | 23.22 ± 0.1% | 0.67 ± 0.1% | 16.06 ± 0.3% | 3.09 ± 0.7% | 0.73 ± 0.2% | 3.61 ± 0.3% | 23.21 ± 0.4% | 1.00 | 1.00 | 1.45 | 7.51 |
| an IPv4 address | 33176 | 42.67 ± 0.2% | 42.64 ± 0.2% | 2.19 ± 0.2% | 32.73 ± 0.3% | 6.69 ± 0.3% | differs | 4.11 ± 0.1% | 42.67 ± 0.3% | 1.00 | 1.00 | 1.30 | 6.38 |
| a date and time | 32954 | 35.44 ± 0.4% | 35.49 ± 0.2% | 1.52 ± 0.2% | 23.37 ± 0.5% | 7.09 ± 0.2% | 1.25 ± 0.1% | 7.09 ± 0.4% | 35.49 ± 0.2% | 1.00 | 1.00 | 1.52 | 5.00 |
| a field path | 32606 | 33.06 ± 0.3% | 33.10 ± 0.4% | 0.84 ± 0.2% | 25.49 ± 0.2% | 3.51 ± 1.1% | differs | 2.99 ± 0.3% | 33.04 ± 0.2% | 1.00 | 1.00 | 1.30 | 9.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.29 ± 0.3% | 10.28 ± 0.5% | 10.28 ± 0.3% | 11.67 ± 0.1% | 4.96 ± 0.9% | 0.94 ± 0.5% | none | 10.29 ± 0.2% | 1.00 | 1.00 | 0.88 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 285.84 ± 0.2% | 287.53 ± 0.5% | 337.28 ± 0.2% | 87.00 ± 0.2% | 221.57 ± 0.9% | 480.19 ± 0.8% | 3852.30 ± 0.6% | 285.67 ± 0.2% | 0.99 | 1.00 | 3.29 | 1.29 |
| a UUID | 62 | 214.40 ± 0.5% | 215.17 ± 0.4% | 244.51 ± 0.1% | 46.35 ± 0.2% | 99.33 ± 2.1% | 186.38 ± 2.9% | 4466.36 ± 0.5% | 214.38 ± 0.4% | 1.00 | 1.00 | 4.63 | 2.16 |
| an IPv4 address | 29 | 439.18 ± 0.6% | 443.33 ± 0.5% | 573.88 ± 0.2% | 76.52 ± 0.7% | 132.05 ± 2.2% | 295.33 ± 1.6% | 7480.03 ± 0.5% | 439.13 ± 0.5% | 0.99 | 1.00 | 5.74 | 3.33 |
| a date and time | 56 | 283.55 ± 0.2% | 285.65 ± 0.4% | 335.93 ± 0.2% | 72.78 ± 0.5% | 137.38 ± 1.4% | 318.76 ± 1.2% | 4968.69 ± 0.3% | 283.56 ± 0.3% | 0.99 | 1.00 | 3.90 | 2.06 |
| a field path | 39 | 320.81 ± 0.3% | 322.78 ± 0.4% | 388.75 ± 0.2% | 80.39 ± 0.5% | 206.48 ± 1.1% | 503.46 ± 2.4% | 4857.37 ± 1.0% | 320.79 ± 0.3% | 0.99 | 1.00 | 3.99 | 1.55 |
| literal: a word | 7 | 796.60 ± 0.8% | 821.87 ± 0.5% | 1411.54 ± 0.2% | 521.23 ± 0.2% | 632.84 ± 2.4% | 945.76 ± 0.5% | 29312.74 ± 0.4% | 795.77 ± 0.6% | 0.97 | 1.00 | 1.53 | 1.26 |
| literal: a word that is not there | 8 | 761.87 ± 0.4% | 786.24 ± 0.4% | 1321.52 ± 0.1% | 470.85 ± 0.1% | 609.26 ± 2.7% | 895.51 ± 0.2% | 28161.91 ± 0.7% | 761.03 ± 0.3% | 0.97 | 1.00 | 1.62 | 1.25 |
| literal: one of four words | 26 | 417.54 ± 0.4% | 456.72 ± 0.2% | 600.20 ± 0.2% | 48.94 ± 1.0% | 242.01 ± 2.6% | 362.88 ± 2.2% | 15441.72 ± 0.1% | 418.80 ± 0.7% | 0.91 | 1.00 | 8.53 | 1.73 |
| literal: a word in any case | 11 | 689.79 ± 0.1% | 715.89 ± 0.3% | 1137.35 ± 0.1% | 15.71 ± 0.4% | 649.37 ± 1.2% | refused | 22804.32 ± 0.3% | 689.74 ± 0.1% | 0.96 | 1.00 | 43.92 | 1.06 |
| literal: an href attribute | 12 | 412.68 ± 0.5% | 417.68 ± 0.6% | 532.58 ± 0.4% | 45.64 ± 0.8% | 502.32 ± 1.9% | 776.67 ± 0.3% | 21601.38 ± 0.2% | 411.85 ± 0.3% | 0.99 | 1.00 | 9.04 | 0.82 |
| literal: a word, second text | 10 | 710.77 ± 0.6% | 737.86 ± 0.7% | 1184.93 ± 0.8% | 424.77 ± 0.6% | 537.40 ± 1.7% | 804.47 ± 0.3% | 26338.58 ± 0.9% | 711.40 ± 0.6% | 0.96 | 1.00 | 1.67 | 1.32 |
| class: two capitalized words | 23 | 427.92 ± 0.6% | 440.71 ± 0.6% | 570.67 ± 0.3% | 100.16 ± 0.2% | 506.23 ± 1.8% | 744.35 ± 0.9% | 6499.10 ± 0.2% | 427.81 ± 0.3% | 0.97 | 1.00 | 4.27 | 0.85 |
| class: a word that ends in ing | 9 | 671.05 ± 0.4% | 708.16 ± 0.5% | 1111.28 ± 0.1% | 130.20 ± 1.5% | 768.33 ± 0.8% | 1108.96 ± 2.7% | 15626.66 ± 0.2% | 671.53 ± 0.3% | 0.95 | 1.00 | 5.15 | 0.87 |
| class: a word in capitals | 16 | 522.43 ± 0.3% | 541.05 ± 0.2% | 750.56 ± 0.2% | 134.30 ± 0.5% | 761.38 ± 1.8% | 1018.82 ± 0.8% | 8500.21 ± 0.5% | 521.71 ± 0.5% | 0.97 | 1.00 | 3.89 | 0.69 |
| class: a number | 6 | 744.09 ± 0.2% | 782.92 ± 0.2% | 1294.61 ± 0.1% | 41.79 ± 0.7% | 1414.82 ± 1.6% | 1905.31 ± 1.6% | 22427.97 ± 0.3% | 746.77 ± 0.3% | 0.95 | 1.00 | 17.80 | 0.53 |
| class: two capitalized words, second text | 23 | 428.06 ± 0.5% | 441.55 ± 0.5% | 572.15 ± 0.6% | 103.03 ± 0.3% | 507.79 ± 0.9% | 737.34 ± 0.8% | 6503.98 ± 0.5% | 427.72 ± 0.3% | 0.97 | 1.00 | 4.15 | 0.84 |
| other: a word between two words | 13 | 617.04 ± 0.4% | 624.42 ± 0.3% | 919.76 ± 0.4% | 134.13 ± 1.6% | 508.00 ± 1.6% | 807.57 ± 0.9% | 14620.30 ± 0.1% | 615.27 ± 0.5% | 0.99 | 1.00 | 4.60 | 1.21 |
| other: a number before a unit, second text | 15 | 528.22 ± 0.1% | 559.50 ± 0.3% | 785.43 ± 0.3% | 39.27 ± 0.4% | 639.70 ± 1.2% | 891.59 ± 0.2% | 15034.28 ± 0.2% | 528.17 ± 0.9% | 0.94 | 1.00 | 13.45 | 0.83 |
| other: a heading's start tag | 13 | 393.79 ± 0.3% | 398.34 ± 0.3% | 505.00 ± 0.2% | 44.48 ± 0.1% | 636.04 ± 0.8% | 866.63 ± 0.2% | 17982.84 ± 0.1% | 393.48 ± 0.4% | 0.99 | 1.00 | 8.85 | 0.62 |
| other: a whole word | 11 | 725.06 ± 0.6% | 750.30 ± 0.8% | 1198.53 ± 0.2% | 121.13 ± 0.8% | 567.30 ± 1.9% | 822.70 ± 1.2% | 26044.91 ± 1.0% | 723.96 ± 0.4% | 0.97 | 1.00 | 5.99 | 1.28 |
| other: a line's first word, second text | 17 | 581.24 ± 0.6% | 602.85 ± 0.3% | 868.29 ± 0.3% | 128.36 ± 0.2% | 719.15 ± 2.1% | refused | refused | 578.73 ± 0.7% | 0.96 | 1.00 | 4.53 | 0.81 |
| other: fourteen octets before an x | 16 | 116.80 ± 0.3% | 157.39 ± 0.2% | 180.60 ± 0.2% | 15.12 ± 0.3% | 458.24 ± 1.8% | 414.85 ± 0.5% | 12694.64 ± 0.3% | 116.88 ± 0.3% | 0.74 | 1.00 | 7.72 | 0.25 |
| other: a Greek word | 8 | 710.48 ± 0.7% | 758.19 ± 0.6% | 1223.67 ± 0.6% | 59.27 ± 0.9% | 1404.19 ± 0.8% | 1806.99 ± 0.6% | refused | 710.61 ± 0.3% | 0.94 | 1.00 | 11.99 | 0.51 |

