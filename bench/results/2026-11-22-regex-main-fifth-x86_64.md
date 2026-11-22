# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054928587 |
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
| literal: a word | 217 | 35544.54 ± 1.1% | 1078.78 ± 1.0% | 36.39 ± 2.2% | 32690.80 ± 0.3% | 12581.68 ± 2.9% | 14.72 ± 1.0% | 114.76 ± 1.8% | 35502.13 ± 1.4% | 32.95 | 1.00 | 1.09 | 2.83 |
| literal: a word that is not there | 0 | 45222.76 ± 0.7% | 1091.17 ± 0.4% | 35.83 ± 1.1% | 35606.40 ± 1.0% | 39736.48 ± 1.9% | 14.24 ± 0.5% | 106.91 ± 0.7% | 45217.68 ± 1.2% | 41.44 | 1.00 | 1.27 | 1.14 |
| literal: one of four words | 661 | 11981.30 ± 1.1% | 1056.48 ± 1.4% | 19.97 ± 78.9% | 9713.60 ± 28.3% | 27.64 ± 82.7% | 4.30 ± 9.8% | 9.16 ± 0.4% | 11903.37 ± 1.3% | 11.34 | 1.01 | 1.23 | 433.53 |
| literal: a word in any case | 217 | 28530.03 ± 2.3% | 1081.14 ± 0.7% | 26.04 ± 0.8% | 9961.77 ± 1.1% | 57.58 ± 1.4% | refused | differs | 28625.17 ± 1.7% | 26.39 | 1.00 | 2.86 | 495.49 |
| literal: an href attribute | 33 | 33314.24 ± 1.9% | 1085.92 ± 0.4% | 32.09 ± 0.7% | 27983.78 ± 1.0% | 2559.63 ± 1.9% | 10.50 ± 0.3% | 98.83 ± 1.2% | 33353.84 ± 1.2% | 30.68 | 1.00 | 1.19 | 13.02 |
| literal: a word, second text | 123 | 37183.52 ± 2.0% | 1086.32 ± 0.6% | 34.92 ± 1.8% | 32764.10 ± 0.9% | 9166.29 ± 1.7% | 19.18 ± 1.5% | 96.61 ± 1.1% | 37228.17 ± 1.6% | 34.23 | 1.00 | 1.13 | 4.06 |
| class: two capitalized words | 1331 | 989.83 ± 0.8% | 996.45 ± 0.6% | 33.50 ± 1.4% | 612.60 ± 0.4% | 47.94 ± 0.5% | 12.54 ± 0.5% | 81.60 ± 0.8% | 990.34 ± 0.8% | 0.99 | 1.00 | 1.62 | 20.65 |
| class: a word that ends in ing | 3399 | 915.28 ± 0.3% | 914.52 ± 0.3% | 22.11 ± 1.1% | 577.26 ± 0.4% | 35.90 ± 6.8% | 7.11 ± 0.4% | 22.99 ± 0.5% | 912.34 ± 0.7% | 1.00 | 1.00 | 1.59 | 25.49 |
| class: a word in capitals | 2332 | 1371.99 ± 0.3% | 984.02 ± 0.2% | 35.79 ± 0.4% | 604.97 ± 0.6% | 52.35 ± 0.6% | 15.11 ± 0.3% | 101.03 ± 0.7% | 1370.84 ± 0.3% | 1.39 | 1.00 | 2.27 | 26.21 |
| class: a number | 8288 | 2043.63 ± 0.5% | 835.52 ± 0.7% | 34.45 ± 2.1% | 2144.08 ± 1.0% | 50.32 ± 14.3% | 0.42 ± 0.2% | 71.13 ± 1.0% | 2039.78 ± 0.6% | 2.45 | 1.00 | 0.95 | 40.62 |
| class: two capitalized words, second text | 5359 | 727.83 ± 0.3% | 726.63 ± 0.7% | 29.81 ± 1.6% | 511.25 ± 0.8% | 39.69 ± 13.6% | 16.34 ± 0.5% | 74.57 ± 0.6% | 727.14 ± 0.3% | 1.00 | 1.00 | 1.42 | 18.34 |
| other: a word between two words | 6104 | 842.41 ± 0.6% | 777.87 ± 0.5% | 29.88 ± 0.8% | 879.70 ± 0.9% | 127.01 ± 8.1% | 9.59 ± 1.0% | 85.82 ± 0.9% | 843.39 ± 1.0% | 1.08 | 1.00 | 0.96 | 6.63 |
| other: a number before a unit, second text | 1481 | 10015.93 ± 4.3% | 1021.93 ± 1.0% | 33.21 ± 0.8% | 9778.82 ± 1.4% | 47.96 ± 6.3% | 17.11 ± 0.5% | 79.19 ± 0.6% | 9862.69 ± 0.7% | 9.80 | 1.02 | 1.02 | 208.83 |
| other: a heading's start tag | 110 | 20788.99 ± 1.9% | 1078.91 ± 0.5% | 34.47 ± 1.5% | 2617.18 ± 0.9% | 1882.04 ± 8.2% | 13.07 ± 1.2% | 116.74 ± 1.7% | 20985.67 ± 2.7% | 19.27 | 0.99 | 7.94 | 11.05 |
| other: a whole word | 217 | 27228.20 ± 1.3% | 1083.15 ± 0.8% | 36.40 ± 1.8% | 26206.55 ± 1.0% | 59.41 ± 1.3% | 12.49 ± 0.9% | 66.87 ± 0.6% | 27342.53 ± 1.8% | 25.14 | 1.00 | 1.04 | 458.29 |
| other: a line's first word, second text | 3716 | 2721.00 ± 0.7% | 898.29 ± 0.8% | 38.25 ± 0.5% | 2540.08 ± 0.3% | 79.13 ± 4.2% | refused | refused | 2702.88 ± 2.1% | 3.03 | 1.01 | 1.07 | 34.39 |
| other: fourteen octets before an x | 87 | 36942.95 ± 0.9% | 1.76 ± 0.4% | 1.74 ± 0.7% | 4128.93 ± 0.3% | 11.52 ± 1.1% | differs | 20.03 ± 0.7% | 36770.03 ± 0.7% | 21036.97 | 1.00 | 8.95 | 3206.02 |
| other: a Greek word | 21815 | 478.65 ± 0.7% | 346.15 ± 0.4% | 38.56 ± 0.6% | 318.47 ± 0.4% | 53.26 ± 14.1% | differs | refused | 476.56 ± 1.1% | 1.38 | 1.00 | 1.50 | 8.99 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.66 ± 0.5% | 30.63 ± 0.4% | 0.60 ± 1.0% | 28.60 ± 0.5% | 3.23 ± 0.4% | differs | 4.95 ± 0.7% | 30.62 ± 0.4% | 1.00 | 1.00 | 1.07 | 9.48 |
| a UUID | 32895 | 27.02 ± 1.2% | 27.16 ± 0.9% | 0.76 ± 1.0% | 21.26 ± 0.5% | 3.08 ± 0.6% | 0.70 ± 0.4% | 4.08 ± 1.3% | 27.00 ± 0.9% | 0.99 | 1.00 | 1.27 | 8.77 |
| an IPv4 address | 33176 | 41.86 ± 0.5% | 41.84 ± 1.0% | 2.47 ± 1.2% | 39.04 ± 1.2% | 7.87 ± 1.2% | differs | 4.62 ± 1.0% | 41.71 ± 0.7% | 1.00 | 1.00 | 1.07 | 5.32 |
| a date and time | 32954 | 40.53 ± 0.9% | 40.28 ± 0.8% | 1.75 ± 1.9% | 34.86 ± 0.9% | 10.02 ± 0.5% | 1.27 ± 0.4% | 8.96 ± 0.9% | 40.44 ± 0.9% | 1.01 | 1.00 | 1.16 | 4.05 |
| a field path | 32606 | 33.57 ± 1.1% | 33.60 ± 1.1% | 1.07 ± 0.4% | 31.22 ± 1.1% | 3.65 ± 0.8% | differs | 3.07 ± 1.2% | 33.44 ± 0.9% | 1.00 | 1.00 | 1.08 | 9.21 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.27 ± 1.1% | 11.29 ± 0.8% | 11.28 ± 0.5% | 14.60 ± 2.3% | 6.52 ± 0.8% | 1.00 ± 1.0% | none | 11.30 ± 0.3% | 1.00 | 1.00 | 0.77 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 250.00 ± 1.1% | 250.32 ± 1.0% | 275.15 ± 1.3% | 114.78 ± 1.5% | 261.15 ± 0.5% | 704.24 ± 2.3% | 3905.69 ± 2.4% | 250.09 ± 0.7% | 1.00 | 1.00 | 2.18 | 0.96 |
| a UUID | 62 | 189.61 ± 0.4% | 190.03 ± 0.7% | 207.85 ± 1.0% | 60.90 ± 1.9% | 117.45 ± 1.9% | 256.02 ± 2.5% | 5462.09 ± 0.7% | 189.35 ± 0.7% | 1.00 | 1.00 | 3.11 | 1.61 |
| an IPv4 address | 29 | 378.15 ± 0.5% | 380.56 ± 0.2% | 442.06 ± 0.7% | 99.24 ± 1.0% | 158.39 ± 2.2% | 437.43 ± 2.6% | 9711.87 ± 1.6% | 378.14 ± 1.0% | 0.99 | 1.00 | 3.81 | 2.39 |
| a date and time | 56 | 307.22 ± 0.8% | 309.07 ± 0.8% | 348.60 ± 0.4% | 95.07 ± 1.3% | 166.73 ± 0.3% | 454.35 ± 0.7% | 5443.97 ± 1.6% | 306.74 ± 0.7% | 0.99 | 1.00 | 3.23 | 1.84 |
| a field path | 39 | 261.18 ± 0.3% | 262.09 ± 0.4% | 289.85 ± 2.5% | 104.91 ± 2.5% | 244.76 ± 2.1% | 710.94 ± 1.8% | 5194.79 ± 1.3% | 261.21 ± 0.3% | 1.00 | 1.00 | 2.49 | 1.07 |
| literal: a word | 7 | 503.46 ± 0.6% | 505.87 ± 0.4% | 616.84 ± 0.7% | 702.77 ± 2.0% | 819.87 ± 0.5% | 1462.33 ± 0.4% | 33237.05 ± 4.4% | 503.95 ± 0.3% | 1.00 | 1.00 | 0.72 | 0.61 |
| literal: a word that is not there | 8 | 496.70 ± 0.9% | 497.50 ± 2.1% | 605.35 ± 0.8% | 628.23 ± 0.5% | 782.27 ± 1.7% | 1372.07 ± 0.4% | 31653.34 ± 3.6% | 497.31 ± 0.6% | 1.00 | 1.00 | 0.79 | 0.63 |
| literal: one of four words | 26 | 362.60 ± 1.1% | 385.14 ± 0.8% | 444.51 ± 1.1% | 51.67 ± 1.3% | 307.28 ± 2.4% | 505.36 ± 1.7% | 16097.88 ± 2.2% | 360.33 ± 1.6% | 0.94 | 1.01 | 7.02 | 1.18 |
| literal: a word in any case | 11 | 305.02 ± 2.8% | 310.72 ± 1.0% | 349.25 ± 0.4% | 16.88 ± 0.6% | 857.73 ± 13.3% | refused | 24561.63 ± 3.5% | 306.30 ± 2.9% | 0.98 | 1.00 | 18.07 | 0.36 |
| literal: an href attribute | 12 | 361.40 ± 0.3% | 364.67 ± 0.3% | 421.52 ± 1.0% | 49.70 ± 0.5% | 619.57 ± 1.8% | 1169.42 ± 1.1% | 23971.63 ± 2.1% | 361.60 ± 1.6% | 0.99 | 1.00 | 7.27 | 0.58 |
| literal: a word, second text | 10 | 480.74 ± 0.6% | 487.41 ± 1.0% | 582.98 ± 0.9% | 575.74 ± 0.6% | 672.83 ± 19.6% | 1183.51 ± 4.5% | 28608.51 ± 1.5% | 480.91 ± 0.4% | 0.99 | 1.00 | 0.83 | 0.71 |
| class: two capitalized words | 23 | 412.57 ± 0.7% | 417.93 ± 1.6% | 484.71 ± 0.8% | 134.52 ± 2.5% | 631.39 ± 4.2% | 1134.06 ± 1.5% | 6626.12 ± 1.6% | 412.76 ± 0.9% | 0.99 | 1.00 | 3.07 | 0.65 |
| class: a word that ends in ing | 9 | 488.73 ± 2.3% | 501.76 ± 0.2% | 600.75 ± 0.4% | 171.47 ± 0.7% | 940.18 ± 1.8% | 1752.26 ± 1.4% | 18504.99 ± 1.0% | 488.37 ± 1.9% | 0.97 | 1.00 | 2.85 | 0.52 |
| class: a word in capitals | 16 | 445.64 ± 0.5% | 455.72 ± 0.4% | 534.74 ± 0.6% | 179.59 ± 2.4% | 941.53 ± 2.5% | 1633.93 ± 0.9% | 8690.44 ± 2.1% | 445.90 ± 0.8% | 0.98 | 1.00 | 2.48 | 0.47 |
| class: a number | 6 | 503.68 ± 0.5% | 516.27 ± 0.7% | 621.46 ± 0.4% | 44.35 ± 1.5% | 1722.69 ± 10.5% | 3053.65 ± 1.0% | 26874.78 ± 5.2% | 504.74 ± 0.5% | 0.98 | 1.00 | 11.36 | 0.29 |
| class: two capitalized words, second text | 23 | 410.36 ± 0.3% | 417.67 ± 0.9% | 485.54 ± 1.0% | 133.63 ± 0.7% | 632.44 ± 2.0% | 1142.35 ± 0.7% | 6605.35 ± 1.5% | 410.43 ± 0.5% | 0.98 | 1.00 | 3.07 | 0.65 |
| other: a word between two words | 13 | 466.02 ± 0.7% | 463.59 ± 0.7% | 554.73 ± 0.4% | 179.91 ± 0.8% | 626.37 ± 1.6% | 1233.52 ± 1.3% | 16382.17 ± 2.6% | 465.82 ± 0.1% | 1.01 | 1.00 | 2.59 | 0.74 |
| other: a number before a unit, second text | 15 | 401.33 ± 0.3% | 414.63 ± 0.2% | 484.67 ± 0.1% | 41.62 ± 0.5% | 791.68 ± 1.0% | 1391.93 ± 2.1% | 17645.48 ± 3.5% | 400.97 ± 0.2% | 0.97 | 1.00 | 9.64 | 0.51 |
| other: a heading's start tag | 13 | 360.70 ± 0.4% | 363.35 ± 0.5% | 421.55 ± 0.7% | 47.77 ± 0.7% | 771.41 ± 1.1% | 1340.23 ± 0.8% | 21011.74 ± 1.7% | 360.06 ± 0.8% | 0.99 | 1.00 | 7.55 | 0.47 |
| other: a whole word | 11 | 481.51 ± 0.7% | 482.82 ± 0.4% | 583.91 ± 0.9% | 163.51 ± 0.3% | 716.60 ± 21.9% | 1253.41 ± 1.4% | 27716.34 ± 1.1% | 481.66 ± 0.4% | 1.00 | 1.00 | 2.94 | 0.67 |
| other: a line's first word, second text | 17 | 448.01 ± 0.9% | 458.92 ± 0.7% | 544.54 ± 1.1% | 171.30 ± 0.2% | 867.97 ± 0.7% | refused | refused | 446.58 ± 0.5% | 0.98 | 1.00 | 2.62 | 0.52 |
| other: fourteen octets before an x | 16 | 122.65 ± 0.8% | 161.73 ± 0.6% | 183.16 ± 1.6% | 18.51 ± 0.7% | 549.71 ± 2.3% | 600.65 ± 0.6% | 15670.24 ± 2.8% | 122.97 ± 1.0% | 0.76 | 1.00 | 6.63 | 0.22 |
| other: a Greek word | 8 | 486.44 ± 0.6% | 503.39 ± 2.2% | 606.47 ± 1.5% | 61.14 ± 1.3% | 1697.36 ± 7.2% | 2944.84 ± 1.5% | refused | 486.07 ± 1.0% | 0.97 | 1.00 | 7.96 | 0.29 |

