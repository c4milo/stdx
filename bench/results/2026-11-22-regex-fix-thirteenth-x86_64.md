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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45065559244 |
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
| literal: a word | 217 | 35503.33 ± 8.2% | 894.00 ± 0.2% | 20.37 ± 4.9% | 33139.73 ± 1.1% | 8825.18 ± 10.5% | 10.74 ± 0.4% | 76.64 ± 1.0% | 34558.93 ± 3.8% | 39.71 | 1.03 | 1.07 | 4.02 |
| literal: a word that is not there | 0 | 50949.07 ± 4.0% | 906.28 ± 0.3% | 20.29 ± 0.9% | 39352.02 ± 16.3% | 29485.70 ± 1.0% | 10.67 ± 0.1% | 72.68 ± 4.5% | 50759.31 ± 3.3% | 56.22 | 1.00 | 1.29 | 1.73 |
| literal: one of four words | 661 | 9951.85 ± 4.7% | 867.11 ± 0.4% | 11.17 ± 0.5% | 9566.71 ± 0.6% | 18.77 ± 0.7% | 3.98 ± 0.2% | 6.51 ± 3.3% | 9978.55 ± 0.7% | 11.48 | 1.00 | 1.04 | 530.30 |
| literal: a word in any case | 217 | 26108.09 ± 1.9% | 894.30 ± 0.2% | 15.32 ± 1.3% | 9379.20 ± 0.7% | 36.80 ± 0.5% | refused | differs | 25525.43 ± 5.4% | 29.19 | 1.02 | 2.78 | 709.46 |
| literal: an href attribute | 33 | 35218.96 ± 4.6% | 901.64 ± 0.2% | 18.86 ± 2.4% | 24828.34 ± 0.8% | 2059.11 ± 0.5% | 8.19 ± 0.5% | 67.50 ± 2.5% | 34221.70 ± 3.2% | 39.06 | 1.03 | 1.42 | 17.10 |
| literal: a word, second text | 123 | 34779.71 ± 4.7% | 899.56 ± 0.2% | 20.06 ± 1.6% | 28466.45 ± 1.2% | 7039.19 ± 8.6% | 11.85 ± 0.4% | 66.46 ± 1.1% | 34195.76 ± 1.5% | 38.66 | 1.02 | 1.22 | 4.94 |
| class: two capitalized words | 1331 | 775.94 ± 0.2% | 816.32 ± 1.6% | 18.68 ± 11.7% | 507.03 ± 1.3% | 33.64 ± 13.7% | 9.22 ± 1.1% | 58.90 ± 2.5% | 774.95 ± 1.4% | 0.95 | 1.00 | 1.53 | 23.06 |
| class: a word that ends in ing | 3399 | 742.31 ± 0.4% | 743.23 ± 0.1% | 13.68 ± 6.1% | 473.95 ± 0.3% | 25.48 ± 8.8% | 5.30 ± 0.1% | 17.13 ± 0.7% | 742.89 ± 1.7% | 1.00 | 1.00 | 1.57 | 29.13 |
| class: a word in capitals | 2332 | 979.66 ± 0.1% | 797.50 ± 0.1% | 20.02 ± 0.8% | 496.48 ± 0.4% | 35.71 ± 0.9% | 10.26 ± 0.2% | 77.14 ± 0.4% | 978.72 ± 0.6% | 1.23 | 1.00 | 1.97 | 27.43 |
| class: a number | 8288 | 1510.11 ± 0.2% | 662.11 ± 0.2% | 19.72 ± 8.9% | 1564.36 ± 0.6% | 33.99 ± 10.0% | 0.33 ± 0.1% | 56.71 ± 10.8% | 1518.82 ± 0.4% | 2.28 | 0.99 | 0.97 | 44.43 |
| class: two capitalized words, second text | 5359 | 584.48 ± 1.5% | 584.61 ± 3.0% | 17.42 ± 2.9% | 420.94 ± 0.1% | 28.99 ± 7.4% | 10.42 ± 0.4% | 54.03 ± 2.4% | 585.22 ± 0.3% | 1.00 | 1.00 | 1.39 | 20.16 |
| other: a word between two words | 6104 | 693.36 ± 1.0% | 629.72 ± 1.0% | 17.41 ± 3.0% | 724.76 ± 0.5% | 98.62 ± 11.0% | 7.22 ± 0.2% | 59.42 ± 0.8% | 692.94 ± 0.4% | 1.10 | 1.00 | 0.96 | 7.03 |
| other: a number before a unit, second text | 1481 | 7638.47 ± 1.7% | 831.29 ± 0.8% | 19.15 ± 0.9% | 6928.72 ± 0.5% | 34.38 ± 0.3% | 10.92 ± 0.9% | 59.01 ± 2.1% | 7602.99 ± 0.8% | 9.19 | 1.00 | 1.10 | 222.19 |
| other: a heading's start tag | 110 | 19672.43 ± 2.4% | 894.30 ± 0.2% | 19.49 ± 2.6% | 2050.51 ± 1.7% | 1471.29 ± 5.2% | 9.97 ± 0.6% | 78.39 ± 0.5% | 19324.85 ± 1.4% | 22.00 | 1.02 | 9.59 | 13.37 |
| other: a whole word | 217 | 24011.30 ± 4.7% | 894.03 ± 0.2% | 19.93 ± 3.1% | 23439.81 ± 0.5% | 41.07 ± 3.9% | 9.40 ± 0.7% | 46.36 ± 0.6% | 23728.95 ± 1.8% | 26.86 | 1.01 | 1.02 | 584.69 |
| other: a line's first word, second text | 3716 | 1965.35 ± 2.3% | 729.28 ± 0.1% | 22.88 ± 1.8% | 1779.74 ± 4.5% | 54.19 ± 6.9% | refused | refused | 1964.75 ± 1.2% | 2.69 | 1.00 | 1.10 | 36.27 |
| other: fourteen octets before an x | 87 | 27036.10 ± 2.4% | 1.32 ± 2.3% | 1.31 ± 0.7% | 2739.52 ± 2.1% | 9.06 ± 0.2% | differs | 17.05 ± 7.2% | 26978.17 ± 3.0% | 20410.06 | 1.00 | 9.87 | 2983.27 |
| other: a Greek word | 21815 | 394.70 ± 1.2% | 273.53 ± 0.5% | 24.12 ± 0.2% | 269.50 ± 0.2% | 44.29 ± 7.8% | differs | refused | 396.77 ± 1.5% | 1.44 | 0.99 | 1.46 | 8.91 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.52 ± 1.5% | 26.18 ± 8.4% | 0.47 ± 0.2% | 20.08 ± 0.2% | 2.15 ± 1.8% | differs | 3.45 ± 14.2% | 26.69 ± 0.6% | 1.01 | 0.99 | 1.32 | 12.32 |
| a UUID | 32895 | 21.47 ± 0.4% | 22.03 ± 4.6% | 0.57 ± 0.6% | 14.33 ± 3.3% | 2.41 ± 0.6% | 0.44 ± 0.4% | 3.15 ± 10.0% | 22.05 ± 0.3% | 0.97 | 0.97 | 1.50 | 8.89 |
| an IPv4 address | 33176 | 37.61 ± 2.6% | 37.29 ± 3.0% | 1.84 ± 6.5% | 30.13 ± 0.3% | 5.64 ± 1.5% | differs | 3.32 ± 1.6% | 38.41 ± 1.7% | 1.01 | 0.98 | 1.25 | 6.67 |
| a date and time | 32954 | 33.57 ± 0.1% | 33.53 ± 0.1% | 1.31 ± 5.0% | 22.06 ± 3.8% | 6.48 ± 5.3% | 0.76 ± 0.1% | 6.01 ± 1.2% | 33.52 ± 8.8% | 1.00 | 1.00 | 1.52 | 5.18 |
| a field path | 32606 | 29.73 ± 1.0% | 29.78 ± 8.7% | 0.75 ± 8.6% | 23.48 ± 0.2% | 2.90 ± 0.4% | differs | 2.32 ± 0.7% | 29.85 ± 0.5% | 1.00 | 1.00 | 1.27 | 10.27 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.14 ± 0.1% | 9.11 ± 0.3% | 8.97 ± 0.5% | 10.72 ± 0.2% | 4.47 ± 1.4% | 0.62 ± 0.1% | none | 9.14 ± 0.2% | 1.00 | 1.00 | 0.85 | 2.04 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.61 ± 0.1% | 234.58 ± 1.0% | 270.29 ± 0.8% | 80.10 ± 3.3% | 180.92 ± 1.1% | 538.08 ± 4.3% | 3414.40 ± 1.9% | 234.45 ± 0.4% | 1.00 | 1.00 | 2.93 | 1.30 |
| a UUID | 62 | 157.57 ± 0.3% | 157.63 ± 0.4% | 177.49 ± 0.2% | 46.71 ± 0.9% | 86.02 ± 7.3% | 200.59 ± 5.3% | 3890.69 ± 13.0% | 157.48 ± 0.2% | 1.00 | 1.00 | 3.37 | 1.83 |
| an IPv4 address | 29 | 425.07 ± 0.8% | 425.19 ± 0.4% | 563.08 ± 0.4% | 69.37 ± 6.8% | 110.70 ± 2.7% | 329.64 ± 1.8% | 6709.80 ± 11.4% | 426.13 ± 0.6% | 1.00 | 1.00 | 6.13 | 3.84 |
| a date and time | 56 | 302.03 ± 0.5% | 303.24 ± 1.6% | 365.47 ± 0.9% | 69.09 ± 4.1% | 117.87 ± 9.8% | 372.36 ± 0.5% | 3908.36 ± 1.3% | 302.14 ± 0.6% | 1.00 | 1.00 | 4.37 | 2.56 |
| a field path | 39 | 250.65 ± 1.1% | 251.24 ± 0.3% | 292.10 ± 9.5% | 74.32 ± 1.4% | 166.25 ± 3.6% | 570.73 ± 3.4% | 4453.26 ± 0.5% | 250.49 ± 0.9% | 1.00 | 1.00 | 3.37 | 1.51 |
| literal: a word | 7 | 723.90 ± 0.4% | 740.01 ± 0.9% | 1220.55 ± 0.9% | 493.33 ± 1.6% | 581.00 ± 2.3% | 1243.52 ± 2.6% | 24304.58 ± 7.9% | 723.67 ± 8.4% | 0.98 | 1.00 | 1.47 | 1.25 |
| literal: a word that is not there | 8 | 692.18 ± 15.4% | 709.89 ± 1.1% | 1143.14 ± 0.9% | 457.35 ± 1.0% | 559.59 ± 1.4% | 1158.59 ± 0.7% | 23183.96 ± 16.5% | 692.86 ± 0.5% | 0.98 | 1.00 | 1.51 | 1.24 |
| literal: one of four words | 26 | 357.77 ± 0.8% | 382.96 ± 0.3% | 488.98 ± 0.8% | 45.13 ± 0.4% | 219.76 ± 0.9% | 443.39 ± 6.8% | 9719.21 ± 0.4% | 359.17 ± 0.8% | 0.93 | 1.00 | 7.93 | 1.63 |
| literal: a word in any case | 11 | 520.58 ± 1.5% | 534.62 ± 0.6% | 755.22 ± 2.6% | 14.85 ± 1.0% | 602.27 ± 2.3% | refused | 18209.02 ± 3.2% | 519.01 ± 8.3% | 0.97 | 1.00 | 35.06 | 0.86 |
| literal: an href attribute | 12 | 373.82 ± 0.4% | 377.26 ± 0.4% | 481.57 ± 0.5% | 36.36 ± 2.3% | 426.28 ± 7.5% | 897.71 ± 3.7% | 16818.31 ± 1.2% | 373.87 ± 0.3% | 0.99 | 1.00 | 10.28 | 0.88 |
| literal: a word, second text | 10 | 628.05 ± 2.1% | 646.35 ± 3.9% | 1017.08 ± 2.1% | 422.83 ± 4.5% | 480.48 ± 5.3% | 938.71 ± 2.9% | 20217.99 ± 3.1% | 634.01 ± 15.9% | 0.97 | 0.99 | 1.49 | 1.31 |
| class: two capitalized words | 23 | 491.83 ± 1.4% | 507.06 ± 1.5% | 691.85 ± 1.8% | 95.49 ± 0.7% | 451.88 ± 12.6% | 901.53 ± 0.4% | 6084.87 ± 0.8% | 492.30 ± 6.6% | 0.97 | 1.00 | 5.15 | 1.09 |
| class: a word that ends in ing | 9 | 638.10 ± 1.3% | 677.38 ± 1.4% | 1056.06 ± 1.2% | 113.29 ± 1.2% | 636.70 ± 1.7% | 1409.76 ± 3.7% | 14662.16 ± 6.6% | 636.12 ± 0.8% | 0.94 | 1.00 | 5.63 | 1.00 |
| class: a word in capitals | 16 | 551.88 ± 0.6% | 571.68 ± 0.5% | 817.10 ± 8.2% | 121.09 ± 3.3% | 649.95 ± 4.3% | 1362.97 ± 0.8% | 8139.54 ± 2.7% | 552.42 ± 1.1% | 0.97 | 1.00 | 4.56 | 0.85 |
| class: a number | 6 | 719.12 ± 1.6% | 751.18 ± 0.3% | 1243.13 ± 0.4% | 37.24 ± 1.7% | 1208.16 ± 0.8% | 2255.72 ± 4.0% | 19586.64 ± 0.8% | 721.68 ± 1.4% | 0.96 | 1.00 | 19.31 | 0.60 |
| class: two capitalized words, second text | 23 | 493.22 ± 0.9% | 505.33 ± 0.5% | 691.69 ± 1.0% | 95.84 ± 0.6% | 453.09 ± 1.5% | 937.23 ± 2.4% | 6091.97 ± 0.2% | 492.86 ± 2.4% | 0.98 | 1.00 | 5.15 | 1.09 |
| other: a word between two words | 13 | 580.23 ± 0.5% | 588.48 ± 0.7% | 851.78 ± 1.3% | 121.59 ± 1.9% | 438.39 ± 9.9% | 1002.24 ± 1.8% | 12388.37 ± 0.5% | 580.27 ± 0.9% | 0.99 | 1.00 | 4.77 | 1.32 |
| other: a number before a unit, second text | 15 | 481.90 ± 0.3% | 509.57 ± 10.6% | 704.56 ± 7.1% | 34.55 ± 1.3% | 536.21 ± 2.8% | 1106.89 ± 4.4% | 12648.67 ± 2.9% | 482.23 ± 0.7% | 0.95 | 1.00 | 13.95 | 0.90 |
| other: a heading's start tag | 13 | 388.86 ± 0.6% | 391.36 ± 0.7% | 514.14 ± 0.3% | 35.28 ± 1.1% | 526.58 ± 2.4% | 1110.76 ± 7.7% | 15118.70 ± 2.1% | 389.04 ± 0.1% | 0.99 | 1.00 | 11.02 | 0.74 |
| other: a whole word | 11 | 601.93 ± 2.0% | 620.75 ± 1.8% | 916.80 ± 0.2% | 112.62 ± 7.8% | 497.64 ± 12.2% | 1074.60 ± 0.3% | 18450.27 ± 1.7% | 605.86 ± 0.8% | 0.97 | 0.99 | 5.34 | 1.21 |
| other: a line's first word, second text | 17 | 588.24 ± 0.4% | 616.99 ± 0.9% | 904.37 ± 0.4% | 115.06 ± 1.1% | 604.86 ± 1.2% | refused | refused | 583.52 ± 0.9% | 0.95 | 1.01 | 5.11 | 0.97 |
| other: fourteen octets before an x | 16 | 93.76 ± 17.2% | 119.59 ± 0.3% | 136.19 ± 0.5% | 13.97 ± 1.0% | 393.12 ± 4.8% | 467.21 ± 0.5% | 11752.63 ± 19.9% | 93.56 ± 0.4% | 0.78 | 1.00 | 6.71 | 0.24 |
| other: a Greek word | 8 | 668.47 ± 16.3% | 711.53 ± 0.4% | 1144.63 ± 0.4% | 45.51 ± 0.8% | 1203.26 ± 2.0% | 2217.48 ± 4.6% | refused | 667.84 ± 4.5% | 0.94 | 1.00 | 14.69 | 0.56 |

