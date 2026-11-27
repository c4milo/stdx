# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 61122.86 ± 0.7% | 16069.96 ± 0.2% | 47.19 ± 0.9% | 54193.72 ± 1.0% | 17453.69 ± 4.2% | 17.24 ± 0.4% | 156.36 ± 1.1% | 61239.60 ± 0.9% | 3.80 | 1.00 | 1.13 | 3.50 |
| literal: a word that is not there | 0 | 86989.25 ± 0.2% | 15474.86 ± 0.2% | 47.17 ± 1.8% | 67106.05 ± 0.3% | 57914.02 ± 1.2% | 16.71 ± 0.2% | 146.82 ± 3.0% | 86998.26 ± 2.8% | 5.62 | 1.00 | 1.30 | 1.50 |
| literal: one of four words | 661 | 21034.55 ± 0.5% | 2338.84 ± 0.9% | 25.53 ± 0.5% | 15102.28 ± 0.4% | 40.51 ± 0.7% | 5.40 ± 1.5% | 13.17 ± 2.5% | 20786.24 ± 0.9% | 8.99 | 1.01 | 1.39 | 519.24 |
| literal: a word in any case | 217 | 58243.10 ± 1.6% | 2514.31 ± 0.5% | 34.59 ± 0.5% | 14951.73 ± 4.9% | 76.73 ± 0.9% | refused | differs | 58558.54 ± 3.1% | 23.16 | 0.99 | 3.90 | 759.07 |
| literal: an href attribute | 33 | 52387.62 ± 1.1% | 758.70 ± 0.5% | 39.71 ± 0.9% | 48027.94 ± 4.4% | 3686.26 ± 4.3% | 12.22 ± 0.3% | 131.15 ± 3.7% | 52374.71 ± 4.3% | 69.05 | 1.00 | 1.09 | 14.21 |
| literal: a word, second text | 123 | 65116.13 ± 2.6% | 8373.11 ± 2.9% | 45.69 ± 0.8% | 50851.52 ± 3.5% | 15618.95 ± 6.4% | 21.86 ± 0.3% | 129.72 ± 1.4% | 65158.54 ± 2.4% | 7.78 | 1.00 | 1.28 | 4.17 |
| class: two capitalized words | 1331 | 1395.78 ± 0.7% | 757.29 ± 0.2% | 42.47 ± 1.0% | 717.52 ± 0.2% | 64.41 ± 11.1% | 14.49 ± 0.5% | 106.32 ± 6.1% | 1401.19 ± 0.6% | 1.84 | 1.00 | 1.95 | 21.67 |
| class: a word that ends in ing | 3399 | 732.97 ± 1.9% | 730.91 ± 0.4% | 29.62 ± 0.4% | 674.72 ± 0.2% | 47.96 ± 7.1% | 8.23 ± 0.2% | 30.48 ± 0.9% | 734.37 ± 0.5% | 1.00 | 1.00 | 1.09 | 15.28 |
| class: a word in capitals | 2332 | 2065.76 ± 0.4% | 764.76 ± 0.1% | 44.40 ± 0.4% | 703.72 ± 0.3% | 68.59 ± 5.3% | 17.35 ± 2.7% | 140.25 ± 1.5% | 2066.71 ± 1.1% | 2.70 | 1.00 | 2.94 | 30.12 |
| class: a number | 8288 | 4555.28 ± 0.5% | 1068.24 ± 0.5% | 45.17 ± 5.6% | 2407.97 ± 8.4% | 64.59 ± 18.4% | 0.48 ± 1.3% | 97.49 ± 1.2% | 4510.03 ± 1.8% | 4.26 | 1.01 | 1.89 | 70.53 |
| class: two capitalized words, second text | 5359 | 650.96 ± 0.4% | 664.39 ± 2.1% | 38.68 ± 0.8% | 600.25 ± 0.7% | 54.31 ± 15.9% | 18.79 ± 0.4% | 99.20 ± 2.6% | 654.70 ± 5.1% | 0.98 | 0.99 | 1.08 | 11.99 |
| other: a word between two words | 6104 | 1186.39 ± 1.2% | 757.44 ± 0.2% | 31.51 ± 0.8% | 1009.33 ± 6.3% | 187.09 ± 5.5% | 10.91 ± 0.1% | 113.33 ± 4.2% | 1146.60 ± 1.4% | 1.57 | 1.03 | 1.18 | 6.34 |
| other: a number before a unit, second text | 1481 | 12934.08 ± 3.6% | 1609.77 ± 1.1% | 42.67 ± 6.4% | 11331.76 ± 0.4% | 64.13 ± 22.7% | 19.75 ± 0.6% | 108.36 ± 3.0% | 12872.25 ± 1.3% | 8.03 | 1.00 | 1.14 | 201.68 |
| other: a heading's start tag | 110 | 29637.24 ± 7.9% | 871.48 ± 6.4% | 42.38 ± 6.0% | 3469.73 ± 6.9% | 2544.19 ± 6.2% | 14.73 ± 5.8% | 149.45 ± 8.7% | 29605.60 ± 5.9% | 34.01 | 1.00 | 8.54 | 11.65 |
| other: a whole word | 217 | 41859.27 ± 0.2% | 750.70 ± 0.1% | 47.07 ± 3.7% | 37553.69 ± 0.5% | 78.70 ± 2.0% | 14.22 ± 1.4% | 86.70 ± 2.2% | 42064.93 ± 0.3% | 55.76 | 1.00 | 1.11 | 531.90 |
| other: a line's first word, second text | 3716 | 3277.79 ± 1.1% | 753.13 ± 0.2% | 34.30 ± 0.9% | 3636.69 ± 0.5% | 105.44 ± 3.7% | refused | refused | 3282.35 ± 1.5% | 4.35 | 1.00 | 0.90 | 31.09 |
| other: fourteen octets before an x | 87 | 48853.35 ± 2.1% | 355.81 ± 1.7% | 9.94 ± 1.0% | 5068.24 ± 0.4% | 15.01 ± 4.4% | differs | 25.95 ± 1.9% | 49133.93 ± 2.8% | 137.30 | 0.99 | 9.64 | 3253.94 |
| other: a Greek word | 21815 | 753.67 ± 0.2% | 570.12 ± 1.0% | 50.60 ± 0.6% | 386.75 ± 0.2% | 66.88 ± 11.9% | differs | refused | 754.53 ± 5.2% | 1.32 | 1.00 | 1.95 | 11.27 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 39.19 ± 5.0% | 39.16 ± 1.5% | 1.61 ± 1.3% | 25.06 ± 0.4% | 3.70 ± 3.8% | differs | 5.88 ± 1.7% | 39.03 ± 0.6% | 1.00 | 1.00 | 1.56 | 10.60 |
| a UUID | 32895 | 35.85 ± 0.6% | 35.88 ± 0.2% | 1.07 ± 1.0% | 19.11 ± 0.4% | 3.75 ± 2.1% | 0.79 ± 0.4% | 4.75 ± 3.1% | 35.71 ± 0.3% | 1.00 | 1.00 | 1.88 | 9.57 |
| an IPv4 address | 33176 | 49.38 ± 0.6% | 49.25 ± 0.8% | 3.38 ± 1.5% | 36.37 ± 0.5% | 9.57 ± 0.5% | differs | 6.21 ± 4.2% | 49.10 ± 0.3% | 1.00 | 1.01 | 1.36 | 5.16 |
| a date and time | 32954 | 47.98 ± 0.3% | 48.85 ± 0.3% | 2.49 ± 0.9% | 27.43 ± 0.9% | 11.34 ± 4.1% | 1.38 ± 0.4% | 11.13 ± 14.8% | 48.87 ± 0.8% | 0.98 | 0.98 | 1.75 | 4.23 |
| a field path | 32606 | 39.56 ± 5.9% | 40.05 ± 6.4% | 1.73 ± 6.4% | 27.27 ± 1.8% | 4.63 ± 1.4% | differs | 4.06 ± 3.0% | 39.72 ± 1.2% | 0.99 | 1.00 | 1.45 | 8.54 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.28 ± 6.5% | 15.53 ± 5.2% | 15.41 ± 5.2% | 17.25 ± 5.6% | 7.69 ± 7.1% | 1.06 ± 5.9% | none | 15.76 ± 5.2% | 0.98 | 0.97 | 0.89 | 1.99 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 380.23 ± 0.6% | 380.44 ± 4.8% | 442.94 ± 5.5% | 143.69 ± 2.1% | 347.90 ± 23.4% | 929.67 ± 6.1% | 5972.99 ± 2.0% | 380.83 ± 0.7% | 1.00 | 1.00 | 2.65 | 1.09 |
| a UUID | 62 | 249.32 ± 0.3% | 249.13 ± 0.3% | 274.13 ± 0.4% | 76.99 ± 1.3% | 168.69 ± 1.6% | 328.01 ± 2.0% | 7476.10 ± 2.2% | 249.24 ± 0.7% | 1.00 | 1.00 | 3.24 | 1.48 |
| an IPv4 address | 29 | 726.62 ± 1.0% | 726.21 ± 3.2% | 977.84 ± 0.9% | 125.97 ± 0.6% | 218.23 ± 1.7% | 596.54 ± 0.6% | 13119.28 ± 0.4% | 729.36 ± 1.9% | 1.00 | 1.00 | 5.77 | 3.33 |
| a date and time | 56 | 524.78 ± 1.1% | 525.54 ± 1.0% | 640.51 ± 1.1% | 118.18 ± 0.9% | 235.93 ± 6.2% | 611.09 ± 0.9% | 8357.27 ± 2.1% | 527.55 ± 1.0% | 1.00 | 0.99 | 4.44 | 2.22 |
| a field path | 39 | 372.72 ± 0.6% | 373.09 ± 1.1% | 430.82 ± 2.4% | 130.29 ± 1.3% | 332.27 ± 1.4% | 957.97 ± 1.7% | 7711.16 ± 1.2% | 373.39 ± 3.7% | 1.00 | 1.00 | 2.86 | 1.12 |
| literal: a word | 7 | 1129.89 ± 1.3% | 1219.89 ± 1.0% | 2089.65 ± 0.6% | 853.57 ± 0.8% | 1098.44 ± 3.2% | 1899.02 ± 6.0% | 42762.45 ± 4.8% | 1131.02 ± 1.1% | 0.93 | 1.00 | 1.32 | 1.03 |
| literal: a word that is not there | 8 | 1062.46 ± 0.9% | 1150.10 ± 3.6% | 1898.85 ± 1.1% | 791.31 ± 26.0% | 1061.28 ± 1.0% | 1786.08 ± 2.2% | 42356.60 ± 2.5% | 1056.57 ± 1.2% | 0.92 | 1.01 | 1.34 | 1.00 |
| literal: one of four words | 26 | 430.97 ± 0.8% | 669.37 ± 5.3% | 870.12 ± 6.2% | 70.20 ± 5.0% | 414.91 ± 1.9% | 708.56 ± 0.4% | 25268.71 ± 5.1% | 431.41 ± 0.7% | 0.64 | 1.00 | 6.14 | 1.04 |
| literal: a word in any case | 11 | 786.00 ± 0.9% | 835.58 ± 1.1% | 1181.29 ± 1.1% | 23.89 ± 0.7% | 1156.94 ± 2.9% | refused | 38931.67 ± 1.4% | 785.07 ± 1.1% | 0.94 | 1.00 | 32.90 | 0.68 |
| literal: an href attribute | 12 | 590.29 ± 0.6% | 616.42 ± 0.7% | 790.40 ± 0.5% | 63.76 ± 0.4% | 801.55 ± 24.6% | 1522.79 ± 1.6% | 32644.25 ± 3.1% | 590.16 ± 0.9% | 0.96 | 1.00 | 9.26 | 0.74 |
| literal: a word, second text | 10 | 938.10 ± 6.1% | 1040.03 ± 4.8% | 1706.08 ± 4.9% | 720.04 ± 5.3% | 914.52 ± 6.8% | 1578.33 ± 5.9% | 39834.42 ± 16.0% | 978.72 ± 4.7% | 0.90 | 0.96 | 1.30 | 1.03 |
| class: two capitalized words | 23 | 794.66 ± 0.7% | 851.36 ± 6.1% | 1191.32 ± 0.8% | 161.90 ± 2.9% | 802.61 ± 11.6% | 1502.92 ± 1.1% | 9909.22 ± 0.9% | 793.79 ± 0.3% | 0.93 | 1.00 | 4.91 | 0.99 |
| class: a word that ends in ing | 9 | 967.13 ± 1.5% | 1104.12 ± 2.0% | 1819.33 ± 20.6% | 213.81 ± 0.4% | 1176.46 ± 1.1% | 2284.68 ± 1.8% | 25468.75 ± 7.1% | 966.69 ± 14.9% | 0.88 | 1.00 | 4.52 | 0.82 |
| class: a word in capitals | 16 | 875.97 ± 6.1% | 897.75 ± 5.4% | 1397.13 ± 5.8% | 211.20 ± 6.8% | 1245.36 ± 6.1% | 2113.52 ± 6.7% | 12942.90 ± 6.6% | 875.79 ± 6.6% | 0.98 | 1.00 | 4.15 | 0.70 |
| class: a number | 6 | 1057.13 ± 3.9% | 1160.58 ± 4.4% | 2044.09 ± 6.4% | 59.53 ± 2.3% | 2173.80 ± 4.8% | 3677.74 ± 1.8% | 32138.01 ± 1.3% | 1055.88 ± 2.6% | 0.91 | 1.00 | 17.76 | 0.49 |
| class: two capitalized words, second text | 23 | 794.32 ± 5.1% | 845.19 ± 5.4% | 1207.28 ± 4.8% | 166.36 ± 4.9% | 806.53 ± 10.2% | 1543.35 ± 4.6% | 9896.26 ± 4.9% | 796.57 ± 5.3% | 0.94 | 1.00 | 4.77 | 0.98 |
| other: a word between two words | 13 | 951.85 ± 6.5% | 987.99 ± 5.7% | 1487.57 ± 7.1% | 218.59 ± 1.7% | 823.45 ± 1.8% | 1613.73 ± 2.2% | 24006.44 ± 0.2% | 957.24 ± 1.7% | 0.96 | 0.99 | 4.35 | 1.16 |
| other: a number before a unit, second text | 15 | 676.43 ± 4.3% | 764.33 ± 6.0% | 1047.29 ± 1.2% | 58.49 ± 0.6% | 1024.85 ± 1.4% | 1798.27 ± 0.4% | 24247.56 ± 0.4% | 679.09 ± 1.1% | 0.89 | 1.00 | 11.57 | 0.66 |
| other: a heading's start tag | 13 | 621.56 ± 1.9% | 635.21 ± 1.3% | 815.45 ± 1.2% | 61.77 ± 4.4% | 996.85 ± 1.4% | 1712.52 ± 1.4% | 26957.37 ± 0.2% | 615.62 ± 1.7% | 0.98 | 1.01 | 10.06 | 0.62 |
| other: a whole word | 11 | 988.99 ± 0.9% | 1054.68 ± 0.8% | 1657.63 ± 1.3% | 196.24 ± 1.1% | 950.54 ± 1.7% | 1690.57 ± 0.7% | 42784.90 ± 13.7% | 991.04 ± 1.8% | 0.94 | 1.00 | 5.04 | 1.04 |
| other: a line's first word, second text | 17 | 924.11 ± 2.7% | 995.67 ± 4.0% | 1540.82 ± 1.3% | 206.48 ± 0.4% | 1109.42 ± 1.8% | refused | refused | 923.11 ± 2.2% | 0.93 | 1.00 | 4.48 | 0.83 |
| other: fourteen octets before an x | 16 | 187.34 ± 1.0% | 267.20 ± 1.2% | 304.28 ± 1.7% | 23.25 ± 0.5% | 729.06 ± 4.3% | 780.65 ± 7.4% | 20932.97 ± 2.8% | 188.08 ± 1.4% | 0.70 | 1.00 | 8.06 | 0.26 |
| other: a Greek word | 8 | 754.70 ± 3.4% | 1011.36 ± 1.4% | 1581.90 ± 1.2% | 77.86 ± 0.3% | 2232.02 ± 1.2% | 3622.65 ± 0.5% | refused | 753.29 ± 3.4% | 0.75 | 1.00 | 9.69 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 43746.82 ± 0.6% | not timed | not timed | 46375.71 ± 2.1% | 3785.89 ± 13.8% | not timed | not timed | 43737.19 ± 0.9% | | 1.00 | 0.94 | 11.56 |
| 01-literal/sherlock-casei-en | 522 | 39468.61 ± 0.7% | not timed | not timed | 11993.99 ± 0.4% | 55.13 ± 19.1% | not timed | not timed | 39602.11 ± 2.5% | | 1.00 | 3.29 | 715.90 |
| 01-literal/sherlock-ru | 724 | 43641.72 ± 2.5% | not timed | not timed | 44701.06 ± 3.7% | 2501.69 ± 6.6% | not timed | not timed | 43631.38 ± 1.0% | | 1.00 | 0.98 | 17.44 |
| 01-literal/sherlock-casei-ru | 746 | 15536.51 ± 0.5% | not timed | not timed | 9748.83 ± 0.5% | 59.22 ± 1.3% | not timed | not timed | 15563.35 ± 0.3% | | 1.00 | 1.59 | 262.36 |
| 01-literal/sherlock-zh | 30 | 82302.24 ± 0.9% | not timed | not timed | 61391.20 ± 2.5% | 2211.78 ± 0.6% | not timed | not timed | 82152.97 ± 0.8% | | 1.00 | 1.34 | 37.21 |
| 02-literal-alternate/sherlock-en | 714 | 17737.90 ± 1.0% | not timed | not timed | 13970.61 ± 0.2% | 30.40 ± 4.0% | not timed | not timed | 17786.17 ± 1.0% | | 1.00 | 1.27 | 583.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3175.48 ± 5.2% | not timed | not timed | 3065.67 ± 0.3% | 18.76 ± 1.3% | not timed | not timed | 3191.12 ± 4.8% | | 1.00 | 1.04 | 169.29 |
| 02-literal-alternate/sherlock-ru | 899 | 13227.95 ± 4.0% | not timed | not timed | 7849.12 ± 13.3% | 39.62 ± 6.5% | not timed | not timed | 13239.35 ± 0.3% | | 1.00 | 1.69 | 333.86 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2852.38 ± 1.8% | not timed | not timed | 1497.51 ± 0.8% | 16.76 ± 1.3% | not timed | not timed | 2852.36 ± 2.8% | | 1.00 | 1.90 | 170.15 |
| 02-literal-alternate/sherlock-zh | 207 | 25449.80 ± 3.5% | not timed | not timed | 16511.64 ± 4.5% | 55.82 ± 0.4% | not timed | not timed | 25447.16 ± 6.0% | | 1.00 | 1.54 | 455.94 |
| 03-date/ascii | 111817 | 189.22 ± 0.7% | not timed | not timed | 125.52 ± 0.2% | 0.33 ± 2.8% | not timed | not timed | 187.68 ± 4.0% | | 1.01 | 1.51 | 580.46 |
| 04-ruff-noqa/real | 84 | 692.78 ± 0.4% | not timed | not timed | 710.55 ± 0.3% | 31.93 ± 1.8% | not timed | not timed | 693.45 ± 0.5% | | 1.00 | 0.97 | 21.69 |
| 04-ruff-noqa/tweaked | 44 | 1270.72 ± 0.8% | not timed | not timed | 719.31 ± 0.5% | 503.96 ± 3.3% | not timed | not timed | 1268.33 ± 1.6% | | 1.00 | 1.77 | 2.52 |
| 05-lexer-veryl/single | 124800 | 7.40 ± 5.4% | not timed | not timed | 7.94 ± 0.4% | 0.36 ± 5.9% | not timed | not timed | 7.40 ± 4.1% | | 1.00 | 0.93 | 20.42 |
| 06-cloud-flare-redos/original | 107 | 593.90 ± 11.9% | not timed | not timed | 297.77 ± 0.8% | 40.65 ± 6.2% | not timed | not timed | 588.15 ± 8.1% | | 1.01 | 1.99 | 14.61 |
| 06-cloud-flare-redos/simplified-short | 102 | 592.05 ± 0.2% | not timed | not timed | 314.55 ± 0.5% | 44.10 ± 1.0% | not timed | not timed | 592.23 ± 4.0% | | 1.00 | 1.88 | 13.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 721.74 ± 0.1% | not timed | not timed | 336.41 ± 4.1% | 47.68 ± 0.3% | not timed | not timed | 721.67 ± 0.2% | | 1.00 | 2.15 | 15.14 |
| 07-unicode-character-data/parse-line | 558784 | 352.80 ± 13.7% | not timed | not timed | 267.82 ± 0.7% | 70.32 ± 2.3% | not timed | not timed | 356.02 ± 6.6% | | 0.99 | 1.32 | 5.02 |
| 08-words/all-english | 56691 | 179.51 ± 0.8% | not timed | not timed | 107.44 ± 3.1% | 19.87 ± 2.2% | not timed | not timed | 181.27 ± 2.4% | | 0.99 | 1.67 | 9.03 |
| 08-words/long-english | 839 | 763.10 ± 0.2% | not timed | not timed | 724.88 ± 0.2% | 51.86 ± 11.1% | not timed | not timed | 763.02 ± 0.5% | | 1.00 | 1.05 | 14.71 |
| 09-aws-keys/full | 0 | 705.95 ± 0.3% | not timed | not timed | 749.40 ± 0.5% | 100.41 ± 3.2% | not timed | not timed | 705.34 ± 0.5% | | 1.00 | 0.94 | 7.03 |
| 09-aws-keys/quick | 0 | 1504.65 ± 0.5% | not timed | not timed | 1290.11 ± 0.6% | 575.26 ± 0.5% | not timed | not timed | 1512.02 ± 0.6% | | 1.00 | 1.17 | 2.62 |
| 10-bounded-repeat/letters-en | 1833 | 852.07 ± 3.8% | not timed | not timed | 771.62 ± 0.9% | 31.29 ± 0.5% | not timed | not timed | 869.87 ± 7.3% | | 0.98 | 1.10 | 27.23 |
| 10-bounded-repeat/letters-ru | 3475 | 739.15 ± 1.2% | not timed | not timed | 673.67 ± 0.6% | 29.58 ± 10.3% | not timed | not timed | 740.45 ± 3.6% | | 1.00 | 1.10 | 24.99 |
| 10-bounded-repeat/context | 53 | 119.95 ± 2.0% | not timed | not timed | 93.64 ± 2.4% | 29.74 ± 3.5% | not timed | not timed | 123.09 ± 3.9% | | 0.97 | 1.28 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 788.17 ± 9.0% | not timed | not timed | 747.91 ± 3.8% | 54.62 ± 2.5% | not timed | not timed | 786.73 ± 11.6% | | 1.00 | 1.05 | 14.43 |
| 11-unstructured-to-json/extract | 600 | 75.62 ± 3.1% | not timed | not timed | 104.76 ± 2.8% | 75.36 ± 7.9% | not timed | not timed | 75.60 ± 13.9% | | 1.00 | 0.72 | 1.00 |
| 12-dictionary/single | 1 | 667.22 ± 2.8% | not timed | not timed | 645.34 ± 5.4% | 0.68 ± 1.8% | not timed | not timed | 671.46 ± 4.2% | | 0.99 | 1.03 | 985.31 |
| 14-quadratic/1x | 100 | 42.01 ± 6.7% | not timed | not timed | 17.51 ± 4.2% | 1.51 ± 5.5% | not timed | not timed | 43.06 ± 4.2% | | 0.98 | 2.40 | 27.89 |
| 14-quadratic/2x | 200 | 38.39 ± 4.3% | not timed | not timed | 8.15 ± 4.3% | 0.82 ± 1.8% | not timed | not timed | 39.49 ± 8.1% | | 0.97 | 4.71 | 46.83 |
| 14-quadratic/10x | 1000 | 22.77 ± 4.2% | not timed | not timed | 1.52 ± 4.6% | 0.18 ± 5.2% | not timed | not timed | 23.01 ± 4.3% | | 0.99 | 14.99 | 127.69 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.91 ± 3.6% | not timed | not timed | 0.54 ± 4.9% | 0.85 ± 4.6% | not timed | not timed | 1.92 ± 3.4% | | 1.00 | 3.56 | 2.24 |
| 04-ruff-noqa/compile-real | 1 | 192.82 ± 4.7% | not timed | not timed | 21.88 ± 8.6% | 238.72 ± 9.9% | not timed | not timed | 193.54 ± 1.9% | | 1.00 | 8.81 | 0.81 |
| 05-lexer-veryl/compile-single | 1 | 23.72 ± 3.1% | not timed | not timed | 4.03 ± 9.2% | 11.41 ± 1.1% | not timed | not timed | 23.82 ± 1.4% | | 1.00 | 5.88 | 2.08 |
| 07-unicode-character-data/compile | 1 | 174.28 ± 3.2% | not timed | not timed | 39.70 ± 4.7% | 60.66 ± 4.1% | not timed | not timed | 175.53 ± 5.2% | | 0.99 | 4.39 | 2.87 |
| 09-aws-keys/compile-full | 1 | 75.77 ± 5.6% | not timed | not timed | 12.46 ± 5.7% | 37.51 ± 8.4% | not timed | not timed | 76.60 ± 7.1% | | 0.99 | 6.08 | 2.02 |
| 09-aws-keys/compile-quick | 1 | 297.76 ± 1.3% | not timed | not timed | 79.11 ± 2.1% | 226.78 ± 1.0% | not timed | not timed | 299.24 ± 3.2% | | 1.00 | 3.76 | 1.31 |
| 10-bounded-repeat/compile-context | 1 | 89.46 ± 2.2% | not timed | not timed | 18.01 ± 0.4% | 27.80 ± 4.3% | not timed | not timed | 89.58 ± 0.5% | | 1.00 | 4.97 | 3.22 |
| 10-bounded-repeat/compile-capitals | 1 | 136.99 ± 1.8% | not timed | not timed | 13.30 ± 0.4% | 40.20 ± 3.3% | not timed | not timed | 137.02 ± 1.2% | | 1.00 | 10.30 | 3.41 |
| 11-unstructured-to-json/compile | 1 | 288.31 ± 1.6% | not timed | not timed | 67.28 ± 0.7% | 119.14 ± 1.3% | not timed | not timed | 288.12 ± 1.7% | | 1.00 | 4.28 | 2.42 |
| 12-dictionary/compile-single | 1 | 0.47 ± 2.9% | not timed | not timed | 0.10 ± 1.5% | 0.16 ± 17.0% | not timed | not timed | 0.47 ± 1.2% | | 1.00 | 4.67 | 2.95 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.84 ± 7.8% | not timed | not timed | 10.32 ± 1.1% | 0.91 ± 23.0% | not timed | not timed | 10.98 ± 9.3% | | 0.99 | 1.05 | 11.93 |
| dictionary/search/english-10 | 690 | 276.27 ± 0.7% | not timed | not timed | 259.56 ± 1.4% | 0.01 ± 2.9% | not timed | not timed | 275.50 ± 1.2% | | 1.00 | 1.06 | 25956.86 |
| dictionary/search/english-15 | 15 | 675.56 ± 0.7% | not timed | not timed | 647.70 ± 0.1% | 0.61 ± 1.6% | not timed | not timed | 679.46 ± 3.9% | | 0.99 | 1.04 | 1104.99 |
| folly/awyer-inn-busted | 1 | 37827.17 ± 2.2% | not timed | not timed | 171.56 ± 0.1% | 74.21 ± 1.4% | not timed | not timed | 37990.48 ± 0.4% | | 1.00 | 220.49 | 509.71 |
| folly/literal-never-match-rare | 0 | 88689.26 ± 18.6% | not timed | not timed | 70663.14 ± 39.5% | 93013.68 ± 6.5% | not timed | not timed | 88575.40 ± 1.7% | | 1.00 | 1.26 | 0.95 |
| folly/literal-never-match-frequent | 0 | 40044.02 ± 10.5% | not timed | not timed | 68327.72 ± 0.7% | 3143.39 ± 0.5% | not timed | not timed | 41803.74 ± 7.4% | | 0.96 | 0.59 | 12.74 |
| folly/literal-never-match-tricksy | 1 | 5339.88 ± 12.4% | not timed | not timed | 8817.06 ± 2.5% | 3912.81 ± 6.1% | not timed | not timed | 5339.42 ± 12.9% | | 1.00 | 0.61 | 1.36 |
| grep/every-line | 239963 | 1864.69 ± 6.1% | not timed | not timed | 1338.46 ± 0.2% | 533.83 ± 13.1% | not timed | not timed | 1865.81 ± 2.2% | | 1.00 | 1.39 | 3.49 |
| grep/long-words-ascii | 5073 | 689.92 ± 0.9% | not timed | not timed | 635.15 ± 0.3% | 68.53 ± 7.4% | not timed | not timed | 688.02 ± 0.3% | | 1.00 | 1.09 | 10.07 |
| imported/leipzig/twain | 811 | 74072.33 ± 2.1% | not timed | not timed | 62836.67 ± 1.4% | 15724.83 ± 9.2% | not timed | not timed | 73938.16 ± 6.4% | | 1.00 | 1.18 | 4.71 |
| imported/leipzig/twain-insensitive | 965 | 20054.15 ± 0.5% | not timed | not timed | 17986.21 ± 0.6% | 66.88 ± 4.5% | not timed | not timed | 20055.15 ± 0.7% | | 1.00 | 1.11 | 299.84 |
| imported/leipzig/shing | 1540 | 43891.31 ± 6.5% | not timed | not timed | 29529.70 ± 0.9% | 55.07 ± 2.7% | not timed | not timed | 43469.45 ± 2.5% | | 1.01 | 1.49 | 797.03 |
| imported/leipzig/huck-saw | 262 | 36078.90 ± 0.6% | not timed | not timed | 24885.14 ± 0.2% | 55.13 ± 4.7% | not timed | not timed | 36090.06 ± 0.5% | | 1.00 | 1.45 | 654.39 |
| imported/leipzig/word-ending-nn | 262 | 750.71 ± 0.4% | not timed | not timed | 751.26 ± 0.0% | 41.85 ± 1.5% | not timed | not timed | 751.25 ± 0.1% | | 1.00 | 1.00 | 17.94 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 14488.26 ± 1.0% | not timed | not timed | 5693.99 ± 0.5% | 16.18 ± 0.4% | not timed | not timed | 14465.69 ± 1.4% | | 1.00 | 2.54 | 895.57 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 29440.45 ± 0.9% | not timed | not timed | 22879.56 ± 0.7% | 30.87 ± 1.6% | not timed | not timed | 29325.80 ± 0.6% | | 1.00 | 1.29 | 953.74 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6932.67 ± 3.3% | not timed | not timed | 1209.02 ± 8.6% | 18.95 ± 1.9% | not timed | not timed | 6942.97 ± 0.6% | | 1.00 | 5.73 | 365.91 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 25117.24 ± 5.5% | not timed | not timed | 748.53 ± 1.8% | 19.53 ± 1.5% | not timed | not timed | 25187.78 ± 0.3% | | 1.00 | 33.56 | 1285.97 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 23562.04 ± 0.4% | not timed | not timed | 748.62 ± 0.6% | 17.02 ± 0.6% | not timed | not timed | 23542.89 ± 0.4% | | 1.00 | 31.47 | 1384.29 |
| imported/leipzig/tom-river | 2 | 17454.50 ± 1.3% | not timed | not timed | 18168.28 ± 3.1% | 54.46 ± 1.0% | not timed | not timed | 17549.33 ± 0.8% | | 0.99 | 0.96 | 320.50 |
| imported/leipzig/ing | 78424 | 734.86 ± 2.1% | not timed | not timed | 697.33 ± 2.7% | 46.32 ± 5.3% | not timed | not timed | 735.44 ± 0.9% | | 1.00 | 1.05 | 15.87 |
| imported/leipzig/ing-whitespace | 55248 | 2493.55 ± 3.2% | not timed | not timed | 2940.00 ± 0.2% | 33.12 ± 4.7% | not timed | not timed | 2475.99 ± 0.9% | | 1.01 | 0.85 | 75.28 |
| imported/leipzig/awyer-inn | 209 | 13457.00 ± 0.3% | not timed | not timed | 18440.59 ± 0.3% | 36.12 ± 2.4% | not timed | not timed | 13461.74 ± 0.2% | | 1.00 | 0.73 | 372.53 |
| imported/leipzig/quotes-bounded | 8886 | 2988.21 ± 0.5% | not timed | not timed | 4111.28 ± 0.8% | 60.00 ± 3.3% | not timed | not timed | 2989.37 ± 0.8% | | 1.00 | 0.73 | 49.80 |
| imported/leipzig/non-ascii-alternate | 2 | 67291.16 ± 6.7% | not timed | not timed | 25946.77 ± 0.2% | 84.78 ± 11.9% | not timed | not timed | 67345.47 ± 1.0% | | 1.00 | 2.59 | 793.69 |
| imported/leipzig/math-symbols | 69 | 4485.83 ± 0.8% | not timed | not timed | 750.73 ± 0.1% | 58.19 ± 0.7% | not timed | not timed | 4455.92 ± 1.2% | | 1.01 | 5.98 | 77.08 |
| imported/leipzig/bounded-strings-ending-z | 0 | 749.35 ± 0.1% | not timed | not timed | 750.31 ± 4.3% | 39.22 ± 11.8% | not timed | not timed | 749.70 ± 5.8% | | 1.00 | 1.00 | 19.10 |
| imported/lh3lh3-reb/uri | 17549 | 1051.49 ± 7.4% | not timed | not timed | 1577.80 ± 0.5% | 42.47 ± 6.0% | not timed | not timed | 1055.87 ± 2.1% | | 1.00 | 0.67 | 24.76 |
| imported/lh3lh3-reb/email | 15057 | 1043.73 ± 6.9% | not timed | not timed | 1536.45 ± 1.0% | 45.59 ± 6.1% | not timed | not timed | 1044.16 ± 6.7% | | 1.00 | 0.68 | 22.90 |
| imported/lh3lh3-reb/date | 668 | 1199.08 ± 0.8% | not timed | not timed | 1358.00 ± 0.6% | 74.52 ± 7.4% | not timed | not timed | 1196.91 ± 0.8% | | 1.00 | 0.88 | 16.09 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 964.87 ± 5.8% | not timed | not timed | 563.83 ± 0.4% | 23.24 ± 1.7% | not timed | not timed | 967.45 ± 9.0% | | 1.00 | 1.71 | 41.53 |
| imported/mariomka/email | 92 | 49980.35 ± 6.9% | not timed | not timed | 75698.76 ± 0.1% | 52.41 ± 1.3% | not timed | not timed | 50347.42 ± 0.7% | | 0.99 | 0.66 | 953.71 |
| imported/mariomka/uri | 5301 | 8909.39 ± 13.5% | not timed | not timed | 9680.05 ± 1.5% | 52.51 ± 6.4% | not timed | not timed | 8932.97 ± 1.8% | | 1.00 | 0.92 | 169.67 |
| imported/mariomka/ip | 5 | 3060.56 ± 2.9% | not timed | not timed | 3029.36 ± 0.1% | 34.27 ± 1.1% | not timed | not timed | 3058.94 ± 2.7% | | 1.00 | 1.01 | 89.30 |
| imported/rsc/no-exponential | 0 | 1177.00 ± 1.2% | not timed | not timed | 666.35 ± 0.7% | 37.01 ± 0.9% | not timed | not timed | 1222.97 ± 0.5% | | 0.96 | 1.77 | 31.80 |
| imported/rsc/literal | 1 | 3193.03 ± 1.9% | not timed | not timed | 3236.01 ± 3.6% | 356.36 ± 19.9% | not timed | not timed | 3174.00 ± 17.1% | | 1.01 | 0.99 | 8.96 |
| imported/rsc/not-literal | 2 | 1513.76 ± 17.0% | not timed | not timed | 1430.56 ± 0.6% | 80.03 ± 6.2% | not timed | not timed | 1525.35 ± 1.1% | | 0.99 | 1.06 | 18.91 |
| imported/rsc/match-class | 1 | 3078.99 ± 6.4% | not timed | not timed | 3298.92 ± 0.3% | 102.07 ± 3.4% | not timed | not timed | 3070.32 ± 9.4% | | 1.00 | 0.93 | 30.17 |
| imported/rsc/match-class-in-range | 1 | 3080.04 ± 2.1% | not timed | not timed | 5000.21 ± 0.1% | 102.50 ± 1.7% | not timed | not timed | 3050.03 ± 6.7% | | 1.01 | 0.62 | 30.05 |
| imported/rsc/match-class-unicode | 1 | 716.80 ± 2.7% | not timed | not timed | 689.54 ± 0.2% | 122.91 ± 3.7% | not timed | not timed | 713.37 ± 2.4% | | 1.00 | 1.04 | 5.83 |
| imported/rsc/anchored-literal-short-non-match | 0 | 2488.54 ± 31.4% | not timed | not timed | 1818.27 ± 0.6% | 467.80 ± 0.5% | not timed | not timed | 2502.52 ± 1.5% | | 0.99 | 1.37 | 5.32 |
| imported/rsc/anchored-literal-long-non-match | 0 | 37344.54 ± 3.3% | not timed | not timed | 27289.29 ± 0.4% | 7045.33 ± 1.9% | not timed | not timed | 37323.56 ± 2.1% | | 1.00 | 1.37 | 5.30 |
| imported/rsc/anchored-literal-short-match | 4 | 1302.49 ± 1.9% | not timed | not timed | 984.31 ± 0.1% | 158.52 ± 4.9% | not timed | not timed | 1349.30 ± 2.3% | | 0.97 | 1.32 | 8.22 |
| imported/rsc/anchored-literal-long-match | 4 | 19621.87 ± 2.1% | not timed | not timed | 14750.02 ± 2.9% | 2383.14 ± 4.0% | not timed | not timed | 19936.07 ± 10.0% | | 0.98 | 1.33 | 8.23 |
| imported/rsc/one-pass-short | 17 | 707.70 ± 23.6% | not timed | not timed | 462.18 ± 1.0% | 52.40 ± 4.8% | not timed | not timed | 683.33 ± 2.0% | | 1.04 | 1.53 | 13.51 |
| imported/rsc/one-pass-short-not | 17 | 479.49 ± 1.1% | not timed | not timed | 499.37 ± 0.9% | 49.28 ± 6.1% | not timed | not timed | 478.81 ± 4.6% | | 1.00 | 0.96 | 9.73 |
| imported/rsc/one-pass-long-prefix | 26 | 612.30 ± 1.4% | not timed | not timed | 530.66 ± 5.7% | 189.97 ± 13.6% | not timed | not timed | 593.23 ± 4.3% | | 1.03 | 1.15 | 3.22 |
| imported/rsc/one-pass-long-prefix-not | 26 | 593.28 ± 9.3% | not timed | not timed | 524.78 ± 0.4% | 114.96 ± 17.6% | not timed | not timed | 614.91 ± 3.3% | | 0.96 | 1.13 | 5.16 |
| imported/rsc/long-needle1 | 31 | 91880.78 ± 1.9% | not timed | not timed | 69669.89 ± 1.4% | 6.33 ± 29.5% | not timed | not timed | 92078.78 ± 1.2% | | 1.00 | 1.32 | 14522.29 |
| imported/rsc/long-needle2 | 31 | 91246.24 ± 0.1% | not timed | not timed | 370.78 ± 20.4% | 6.44 ± 0.8% | not timed | not timed | 91200.48 ± 0.2% | | 1.00 | 246.09 | 14161.24 |
| imported/rsc/easy0-32 | 26 | 3313.13 ± 1.0% | not timed | not timed | 2965.47 ± 0.5% | 232.12 ± 12.4% | not timed | not timed | 3344.04 ± 2.3% | | 0.99 | 1.12 | 14.27 |
| imported/rsc/easy0-1k | 26 | 27054.50 ± 0.9% | not timed | not timed | 32400.46 ± 0.5% | 3644.78 ± 12.5% | not timed | not timed | 27097.86 ± 5.0% | | 1.00 | 0.84 | 7.42 |
| imported/rsc/easy0-32k | 26 | 85836.00 ± 2.6% | not timed | not timed | 67280.76 ± 17.8% | 40166.51 ± 18.0% | not timed | not timed | 85604.83 ± 1.5% | | 1.00 | 1.28 | 2.14 |
| imported/rsc/easy0-1mb | 26 | 90832.91 ± 2.8% | not timed | not timed | 70969.37 ± 0.2% | 105007.26 ± 5.4% | not timed | not timed | 90773.66 ± 2.4% | | 1.00 | 1.28 | 0.87 |
| imported/rsc/easy1-32 | 19 | 1272.72 ± 2.5% | not timed | not timed | 1316.53 ± 0.9% | 225.11 ± 13.6% | not timed | not timed | 1325.17 ± 3.3% | | 0.96 | 0.97 | 5.65 |
| imported/rsc/easy1-1k | 19 | 26034.53 ± 2.0% | not timed | not timed | 26738.69 ± 3.2% | 3893.21 ± 11.7% | not timed | not timed | 27456.98 ± 6.8% | | 0.95 | 0.97 | 6.69 |
| imported/rsc/easy1-32k | 19 | 818318.40 ± 1.3% | not timed | not timed | 824947.25 ± 0.5% | 44664.43 ± 28.3% | not timed | not timed | 846730.82 ± 4.4% | | 0.97 | 0.99 | 18.32 |
| imported/rsc/easy1-1mb | 19 | 26250700.81 ± 1.9% | not timed | not timed | 25325763.48 ± 2.3% | 105392.96 ± 2.0% | not timed | not timed | 27349216.86 ± 3.1% | | 0.96 | 1.04 | 249.07 |
| imported/rsc/medium-32 | 27 | 1164.40 ± 0.7% | not timed | not timed | 1124.81 ± 12.3% | 121.24 ± 6.8% | not timed | not timed | 1164.10 ± 2.2% | | 1.00 | 1.04 | 9.60 |
| imported/rsc/medium-1k | 27 | 20747.72 ± 2.7% | not timed | not timed | 22051.96 ± 1.5% | 121.48 ± 0.6% | not timed | not timed | 20701.33 ± 1.4% | | 1.00 | 0.94 | 170.79 |
| imported/rsc/medium-32k | 27 | 648953.47 ± 5.0% | not timed | not timed | 643810.09 ± 6.6% | 83.02 ± 5.6% | not timed | not timed | 646061.54 ± 0.9% | | 1.00 | 1.01 | 7816.40 |
| imported/rsc/medium-1mb | 27 | 20610622.13 ± 4.1% | not timed | not timed | 22020069.27 ± 0.9% | 83.41 ± 1.8% | not timed | not timed | 20656034.44 ± 0.6% | | 1.00 | 0.94 | 247096.15 |
| imported/rsc/hard-32 | 58 | 594.33 ± 3.8% | not timed | not timed | 541.68 ± 0.7% | 77.50 ± 8.2% | not timed | not timed | 595.91 ± 2.5% | | 1.00 | 1.10 | 7.67 |
| imported/rsc/hard-1k | 27 | 20409.67 ± 2.3% | not timed | not timed | 21897.39 ± 1.5% | 63.35 ± 2.0% | not timed | not timed | 20460.19 ± 1.9% | | 1.00 | 0.93 | 322.17 |
| imported/rsc/hard-32k | 27 | 633132.48 ± 1.3% | not timed | not timed | 682337.75 ± 0.5% | 51.26 ± 0.5% | not timed | not timed | 634161.66 ± 7.5% | | 1.00 | 0.93 | 12351.88 |
| imported/rsc/hard-1mb | 51 | 11858341.60 ± 0.9% | not timed | not timed | 11422523.81 ± 0.9% | 51.03 ± 1.2% | not timed | not timed | 11858602.76 ± 1.2% | | 1.00 | 1.04 | 232386.77 |
| imported/rsc/reallyhard0-32 | 58 | 382.33 ± 1.2% | not timed | not timed | 343.18 ± 0.2% | 80.42 ± 8.9% | not timed | not timed | 383.23 ± 6.1% | | 1.00 | 1.11 | 4.75 |
| imported/rsc/reallyhard0-1k | 27 | 737.44 ± 2.4% | not timed | not timed | 734.83 ± 0.1% | 63.08 ± 1.1% | not timed | not timed | 737.57 ± 0.1% | | 1.00 | 1.00 | 11.69 |
| imported/rsc/reallyhard0-32k | 27 | 749.54 ± 0.1% | not timed | not timed | 750.61 ± 0.1% | 51.11 ± 1.9% | not timed | not timed | 749.65 ± 0.2% | | 1.00 | 1.00 | 14.67 |
| imported/rsc/reallyhard0-1mb | 51 | 749.77 ± 0.2% | not timed | not timed | 751.20 ± 0.1% | 51.13 ± 0.5% | not timed | not timed | 749.93 ± 0.1% | | 1.00 | 1.00 | 14.66 |
| imported/rsc/reallyreallyhard0-32 | 47 | 446.24 ± 6.8% | not timed | not timed | 279.91 ± 0.3% | 99.65 ± 7.6% | not timed | not timed | 449.96 ± 1.4% | | 0.99 | 1.59 | 4.48 |
| imported/rsc/reallyreallyhard0-1k | 16 | 11645.33 ± 4.5% | not timed | not timed | 11470.03 ± 3.2% | 52.04 ± 2.4% | not timed | not timed | 11701.64 ± 3.4% | | 1.00 | 1.02 | 223.77 |
| imported/rsc/reallyreallyhard0-32k | 16 | 77492.61 ± 3.6% | not timed | not timed | 60502.58 ± 0.1% | 41.01 ± 0.8% | not timed | not timed | 76888.73 ± 4.4% | | 1.01 | 1.28 | 1889.53 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 100503.92 ± 6.8% | not timed | not timed | 69876.34 ± 13.2% | 41.53 ± 3.7% | not timed | not timed | 102031.02 ± 6.2% | | 0.99 | 1.44 | 2419.78 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 433.53 ± 1.7% | not timed | not timed | 292.81 ± 0.4% | 99.77 ± 8.0% | not timed | not timed | 437.48 ± 0.9% | | 0.99 | 1.48 | 4.35 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 9457.17 ± 0.4% | not timed | not timed | 11093.80 ± 0.2% | 49.83 ± 12.2% | not timed | not timed | 9421.14 ± 6.1% | | 1.00 | 0.85 | 189.80 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 72813.13 ± 1.4% | not timed | not timed | 60695.58 ± 0.3% | 42.19 ± 25.8% | not timed | not timed | 72795.94 ± 1.5% | | 1.00 | 1.20 | 1725.65 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 86663.37 ± 0.5% | not timed | not timed | 69032.92 ± 2.5% | 42.05 ± 0.5% | not timed | not timed | 86220.36 ± 5.4% | | 1.01 | 1.26 | 2060.85 |
| imported/sherlock/name-sherlock | 776 | 64472.14 ± 0.7% | not timed | not timed | 54502.20 ± 5.7% | 16846.38 ± 20.9% | not timed | not timed | 64334.06 ± 1.8% | | 1.00 | 1.18 | 3.83 |
| imported/sherlock/name-holmes | 2766 | 33373.27 ± 1.4% | not timed | not timed | 38070.12 ± 1.1% | 5607.10 ± 3.0% | not timed | not timed | 33436.81 ± 0.8% | | 1.00 | 0.88 | 5.95 |
| imported/sherlock/name-sherlock-holmes | 1365 | 65476.35 ± 1.3% | not timed | not timed | 55291.65 ± 2.5% | 13636.61 ± 32.8% | not timed | not timed | 66081.06 ± 2.8% | | 0.99 | 1.18 | 4.80 |
| imported/sherlock/name-sherlock-casei | 816 | 64664.96 ± 0.7% | not timed | not timed | 15049.81 ± 1.7% | 53.76 ± 2.6% | not timed | not timed | 64756.52 ± 1.0% | | 1.00 | 4.30 | 1202.88 |
| imported/sherlock/name-holmes-casei | 2802 | 28728.79 ± 0.7% | not timed | not timed | 9341.17 ± 0.2% | 68.53 ± 2.6% | not timed | not timed | 28700.75 ± 0.4% | | 1.00 | 3.08 | 419.20 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 53116.86 ± 0.7% | not timed | not timed | 14819.56 ± 1.9% | 54.18 ± 1.2% | not timed | not timed | 53165.20 ± 0.3% | | 1.00 | 3.58 | 980.36 |
| imported/sherlock/name-whitespace | 1461 | 37264.40 ± 5.0% | not timed | not timed | 38837.68 ± 0.9% | 13201.43 ± 15.0% | not timed | not timed | 38754.13 ± 5.6% | | 0.96 | 0.96 | 2.82 |
| imported/sherlock/name-alt1 | 1142 | 43359.44 ± 1.7% | not timed | not timed | 46273.42 ± 0.5% | 7074.33 ± 20.9% | not timed | not timed | 43029.00 ± 2.4% | | 1.01 | 0.94 | 6.13 |
| imported/sherlock/name-alt2 | 3542 | 25484.30 ± 0.3% | not timed | not timed | 12710.88 ± 1.5% | 57.10 ± 5.3% | not timed | not timed | 25473.59 ± 2.1% | | 1.00 | 2.00 | 446.27 |
| imported/sherlock/name-alt3 | 4507 | 15850.98 ± 3.0% | not timed | not timed | 11781.38 ± 0.3% | 17.87 ± 0.4% | not timed | not timed | 15562.08 ± 3.2% | | 1.02 | 1.35 | 887.24 |
| imported/sherlock/name-alt3-casei | 4593 | 2568.89 ± 2.9% | not timed | not timed | 1745.37 ± 0.9% | 11.07 ± 4.9% | not timed | not timed | 2580.78 ± 8.3% | | 1.00 | 1.47 | 232.03 |
| imported/sherlock/name-alt4 | 3686 | 13160.97 ± 6.3% | not timed | not timed | 9862.36 ± 0.5% | 54.77 ± 0.9% | not timed | not timed | 13143.71 ± 0.6% | | 1.00 | 1.33 | 240.31 |
| imported/sherlock/name-alt4-casei | 4254 | 7474.11 ± 5.9% | not timed | not timed | 5378.18 ± 1.1% | 34.12 ± 1.3% | not timed | not timed | 7416.63 ± 3.4% | | 1.01 | 1.39 | 219.03 |
| imported/sherlock/name-alt5 | 4028 | 20406.71 ± 1.9% | not timed | not timed | 12317.59 ± 0.3% | 40.55 ± 20.8% | not timed | not timed | 20504.21 ± 0.8% | | 1.00 | 1.66 | 503.22 |
| imported/sherlock/name-alt5-casei | 4104 | 9834.45 ± 1.0% | not timed | not timed | 3961.19 ± 8.7% | 24.17 ± 0.9% | not timed | not timed | 9826.00 ± 0.9% | | 1.00 | 2.48 | 406.85 |
| imported/sherlock/no-match-uncommon | 0 | 95334.25 ± 0.1% | not timed | not timed | 94846.15 ± 17.3% | 83651.70 ± 0.5% | not timed | not timed | 95384.92 ± 0.3% | | 1.00 | 1.01 | 1.14 |
| imported/sherlock/no-match-common | 0 | 93086.29 ± 0.3% | not timed | not timed | 94673.47 ± 3.9% | 2491.49 ± 1.2% | not timed | not timed | 93124.83 ± 2.0% | | 1.00 | 0.98 | 37.36 |
| imported/sherlock/no-match-really-common | 0 | 64540.48 ± 9.5% | not timed | not timed | 67109.91 ± 4.7% | 2495.46 ± 0.2% | not timed | not timed | 64605.78 ± 0.2% | | 1.00 | 0.96 | 25.86 |
| imported/sherlock/the-lower | 21654 | 3613.69 ± 5.9% | not timed | not timed | 4100.28 ± 1.9% | 403.68 ± 12.5% | not timed | not timed | 3628.73 ± 3.5% | | 1.00 | 0.88 | 8.95 |
| imported/sherlock/the-upper | 2223 | 22783.95 ± 5.8% | not timed | not timed | 35505.41 ± 1.2% | 4526.23 ± 21.4% | not timed | not timed | 22804.89 ± 9.0% | | 1.00 | 0.64 | 5.03 |
| imported/sherlock/the-casei | 23961 | 3373.78 ± 0.8% | not timed | not timed | 1788.87 ± 0.9% | 61.23 ± 26.5% | not timed | not timed | 3380.85 ± 0.5% | | 1.00 | 1.89 | 55.10 |
| imported/sherlock/everything-greedy | 581881 | 393.65 ± 0.8% | not timed | not timed | 233.32 ± 16.6% | 43.41 ± 67.1% | not timed | not timed | 392.91 ± 10.1% | | 1.00 | 1.69 | 9.07 |
| imported/sherlock/everything-greedy-nl | 594933 | 631.97 ± 4.3% | not timed | not timed | 307.66 ± 12.6% | 56.01 ± 6.3% | not timed | not timed | 631.69 ± 0.2% | | 1.00 | 2.05 | 11.28 |
| imported/sherlock/letters | 447175 | 103.58 ± 26.9% | not timed | not timed | 47.12 ± 8.2% | 9.55 ± 19.1% | not timed | not timed | 101.52 ± 13.9% | | 1.02 | 2.20 | 10.84 |
| imported/sherlock/letters-upper | 14180 | 576.99 ± 1.3% | not timed | not timed | 463.51 ± 0.2% | 47.22 ± 17.0% | not timed | not timed | 574.09 ± 2.3% | | 1.01 | 1.24 | 12.22 |
| imported/sherlock/letters-lower | 432995 | 103.84 ± 0.5% | not timed | not timed | 47.50 ± 0.3% | 8.34 ± 30.7% | not timed | not timed | 100.37 ± 2.9% | | 1.03 | 2.19 | 12.46 |
| imported/sherlock/words | 447639 | 163.24 ± 5.4% | not timed | not timed | 108.14 ± 0.6% | 21.13 ± 8.3% | not timed | not timed | 161.36 ± 0.6% | | 1.01 | 1.51 | 7.72 |
| imported/sherlock/before-holmes | 4073 | 18547.56 ± 6.7% | not timed | not timed | 17431.43 ± 0.5% | 39.27 ± 0.6% | not timed | not timed | 18520.61 ± 0.5% | | 1.00 | 1.06 | 472.36 |
| imported/sherlock/before-after-holmes | 2593 | 18667.53 ± 1.8% | not timed | not timed | 20436.57 ± 3.4% | 39.25 ± 0.3% | not timed | not timed | 18654.66 ± 3.3% | | 1.00 | 0.91 | 475.59 |
| imported/sherlock/holmes-cochar-watson | 150 | 12672.27 ± 3.8% | not timed | not timed | 10234.32 ± 0.7% | 55.53 ± 1.5% | not timed | not timed | 12655.55 ± 0.6% | | 1.00 | 1.24 | 228.22 |
| imported/sherlock/holmes-coword-watson | 14309 | 1594.05 ± 0.2% | not timed | not timed | 1563.75 ± 0.1% | 11.73 ± 1.2% | not timed | not timed | 1593.18 ± 0.3% | | 1.00 | 1.02 | 135.92 |
| imported/sherlock/quotes | 14437 | 1928.44 ± 0.6% | not timed | not timed | 3008.23 ± 0.9% | 55.99 ± 1.3% | not timed | not timed | 1923.98 ± 0.6% | | 1.00 | 0.64 | 34.44 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 48523.14 ± 0.7% | not timed | not timed | 42642.31 ± 0.6% | 63.41 ± 3.0% | not timed | not timed | 48539.70 ± 5.1% | | 1.00 | 1.14 | 765.26 |
| imported/sherlock/word-ending-n | 35297 | 591.53 ± 10.4% | not timed | not timed | 496.41 ± 0.6% | 39.41 ± 9.9% | not timed | not timed | 592.28 ± 5.9% | | 1.00 | 1.19 | 15.01 |
| imported/sherlock/repeated-class-negation | 2130 | 21942.07 ± 2.4% | not timed | not timed | 24331.16 ± 0.8% | 16.39 ± 1.8% | not timed | not timed | 21900.62 ± 3.0% | | 1.00 | 0.90 | 1338.41 |
| imported/sherlock/ing-suffix | 20547 | 730.50 ± 3.2% | not timed | not timed | 640.50 ± 5.6% | 46.30 ± 12.4% | not timed | not timed | 731.68 ± 1.9% | | 1.00 | 1.14 | 15.78 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 2241.45 ± 3.5% | not timed | not timed | 3874.24 ± 1.0% | 33.96 ± 0.7% | not timed | not timed | 2236.13 ± 0.3% | | 1.00 | 0.58 | 66.01 |
| opt/accelerate/whole-line | 239963 | 698.86 ± 0.8% | not timed | not timed | 529.59 ± 0.3% | 136.35 ± 17.3% | not timed | not timed | 697.56 ± 0.8% | | 1.00 | 1.32 | 5.13 |
| opt/accelerate/non-dna | 16745 | 611.85 ± 0.8% | not timed | not timed | 580.96 ± 0.6% | 51.21 ± 23.0% | not timed | not timed | 614.14 ± 0.3% | | 1.00 | 1.05 | 11.95 |
| opt/backtrack/words-english | 40536 | 192.31 ± 4.5% | not timed | not timed | 148.75 ± 0.4% | 32.34 ± 8.8% | not timed | not timed | 190.14 ± 5.2% | | 1.01 | 1.29 | 5.95 |
| opt/fixed-length/too-small-ascii | 0 | 600.34 ± 0.1% | not timed | not timed | 1169.76 ± 0.5% | 174.60 ± 2.5% | not timed | not timed | 590.57 ± 0.5% | | 1.02 | 0.51 | 3.44 |
| opt/fixed-length/too-big-ascii | 0 | 6738.14 ± 1.0% | not timed | not timed | 9339.79 ± 0.4% | 222.21 ± 2.0% | not timed | not timed | 6735.40 ± 3.5% | | 1.00 | 0.72 | 30.32 |
| opt/fixed-length/go33484-1 | 0 | 1303540.64 ± 2.2% | not timed | not timed | 1797243.17 ± 1.0% | 127923.89 ± 1.0% | not timed | not timed | 1301603.41 ± 0.7% | | 1.00 | 0.73 | 10.19 |
| opt/fixed-length/go33484-2 | 0 | 1271684.25 ± 0.4% | not timed | not timed | 1793697.88 ± 0.7% | 47046.70 ± 0.7% | not timed | not timed | 1297267.25 ± 1.9% | | 0.98 | 0.71 | 27.03 |
| opt/fixed-length/go33484-3 | 0 | 129825.77 ± 2.1% | not timed | not timed | 179529.53 ± 3.2% | 1369.36 ± 0.5% | not timed | not timed | 129096.07 ± 1.0% | | 1.01 | 0.72 | 94.81 |
| opt/literal-alt/one-pattern | 1 | 745.47 ± 1.0% | not timed | not timed | 740.69 ± 0.4% | 0.67 ± 0.3% | not timed | not timed | 739.91 ± 1.2% | | 1.01 | 1.01 | 1119.57 |
| opt/onepass/fn-predicate | 916 | 618.61 ± 0.7% | not timed | not timed | 545.59 ± 0.2% | 302.39 ± 15.7% | not timed | not timed | 620.87 ± 1.4% | | 1.00 | 1.13 | 2.05 |
| opt/onepass/first-three-words-english | 35128 | 248.22 ± 4.2% | not timed | not timed | 317.61 ± 0.3% | 117.93 ± 8.0% | not timed | not timed | 251.86 ± 3.5% | | 0.99 | 0.78 | 2.10 |
| opt/prefilter/literal-english | 1 | 94054.68 ± 0.1% | not timed | not timed | 71300.01 ± 0.6% | 37008.87 ± 0.2% | not timed | not timed | 94044.43 ± 0.9% | | 1.00 | 1.32 | 2.54 |
| opt/prefilter/literal-casei-english | 1 | 71307.35 ± 4.4% | not timed | not timed | 19114.17 ± 4.9% | 53.88 ± 1.1% | not timed | not timed | 71365.01 ± 0.6% | | 1.00 | 3.73 | 1323.36 |
| opt/prefilter/literal-russian | 1 | 93207.48 ± 0.7% | not timed | not timed | 71188.65 ± 0.3% | 4361.41 ± 0.4% | not timed | not timed | 93159.50 ± 0.4% | | 1.00 | 1.31 | 21.37 |
| opt/prefilter/literal-casei-russian | 1 | 38141.88 ± 3.3% | not timed | not timed | 13746.64 ± 1.5% | 59.22 ± 1.3% | not timed | not timed | 38204.01 ± 0.1% | | 1.00 | 2.77 | 644.12 |
| opt/prefilter/rust-functions | 948 | 20759.32 ± 2.2% | not timed | not timed | 16918.23 ± 0.9% | 2553.19 ± 23.6% | not timed | not timed | 20857.78 ± 1.4% | | 1.00 | 1.23 | 8.13 |
| opt/reverse-anchored/word-end | 1 | 52637284.67 ± 1.8% | not timed | not timed | 37365734.77 ± 0.9% | 87.29 ± 1.2% | not timed | not timed | 52658286.35 ± 1.0% | | 1.00 | 1.41 | 603039.27 |
| opt/reverse-inner/holmes | 2593 | 18626.34 ± 2.8% | not timed | not timed | 20375.11 ± 0.9% | 38.82 ± 1.8% | not timed | not timed | 18701.35 ± 2.8% | | 1.00 | 0.91 | 479.78 |
| opt/reverse-inner/email | 47 | 96084.56 ± 0.2% | not timed | not timed | 102315.54 ± 0.4% | 51.19 ± 1.1% | not timed | not timed | 96104.46 ± 0.7% | | 1.00 | 0.94 | 1877.17 |
| opt/reverse-inner/factored-prefix | 3542 | 739.52 ± 0.3% | not timed | not timed | 729.69 ± 0.2% | 20.67 ± 0.4% | not timed | not timed | 738.16 ± 0.4% | | 1.00 | 1.01 | 35.79 |
| opt/reverse-inner/no-quadratic-backward | 0 | 34641.92 ± 4.1% | not timed | not timed | 750.99 ± 0.2% | 124.90 ± 20.0% | not timed | not timed | 34542.64 ± 4.9% | | 1.00 | 46.13 | 277.35 |
| opt/reverse-inner/no-quadratic-forward | 0 | 872.60 ± 2.1% | not timed | not timed | 346.30 ± 0.5% | 41.18 ± 1.7% | not timed | not timed | 872.08 ± 2.2% | | 1.00 | 2.52 | 21.19 |
| opt/reverse-suffix/holmes | 4073 | 18551.60 ± 0.3% | not timed | not timed | 17412.20 ± 10.0% | 39.02 ± 24.3% | not timed | not timed | 18497.50 ± 0.8% | | 1.00 | 1.07 | 475.40 |
| opt/reverse-suffix/no-quadratic | 0 | 34449.57 ± 4.0% | not timed | not timed | 751.01 ± 0.2% | 127.83 ± 0.9% | not timed | not timed | 34880.80 ± 0.7% | | 0.99 | 45.87 | 269.49 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 218.69 ± 2.8% | not timed | not timed | 270.18 ± 0.3% | 25.25 ± 11.3% | not timed | not timed | 215.96 ± 0.7% | | 1.01 | 0.81 | 8.66 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 224.69 ± 3.3% | not timed | not timed | 276.66 ± 13.2% | 24.90 ± 4.9% | not timed | not timed | 218.02 ± 1.3% | | 1.03 | 0.81 | 9.02 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.49 ± 5.0% | not timed | not timed | 0.86 ± 4.0% | 179.61 ± 5.2% | not timed | not timed | 0.49 ± 2.0% | | 1.02 | 0.58 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 397.69 ± 7.9% | not timed | not timed | 377.45 ± 0.9% | 167.15 ± 2.3% | not timed | not timed | 399.23 ± 0.2% | | 1.00 | 1.05 | 2.38 |
| reported/i13-subset-regex/original-ascii | 4094 | 14500.42 ± 0.3% | not timed | not timed | 5750.25 ± 0.4% | 16.13 ± 1.6% | not timed | not timed | 14525.99 ± 4.4% | | 1.00 | 2.52 | 899.16 |
| reported/i13-subset-regex/original-unicode | 4094 | 14354.64 ± 1.5% | not timed | not timed | 305.25 ± 3.4% | 16.02 ± 1.4% | not timed | not timed | 14502.71 ± 1.7% | | 0.99 | 47.03 | 895.82 |
| reported/i13-subset-regex/big-ascii | 1955 | 13418.83 ± 1.1% | not timed | not timed | 76.77 ± 2.1% | 13.87 ± 3.1% | not timed | not timed | 13442.58 ± 0.8% | | 1.00 | 174.80 | 967.44 |
| reported/i13-subset-regex/big-unicode | 1955 | 13447.26 ± 0.7% | not timed | not timed | 14.20 ± 55.5% | 13.95 ± 1.8% | not timed | not timed | 13468.31 ± 0.6% | | 1.00 | 946.72 | 964.18 |
| reported/i13-subset-regex/huge-ascii | 55 | 12441.12 ± 1.3% | not timed | not timed | 14.09 ± 1.5% | 13.01 ± 1.7% | not timed | not timed | 12452.98 ± 0.4% | | 1.00 | 882.96 | 955.93 |
| reported/i13-subset-regex/huge-unicode | 55 | 12421.70 ± 0.4% | not timed | not timed | 14.05 ± 1.1% | 13.10 ± 1.4% | not timed | not timed | 12436.26 ± 0.4% | | 1.00 | 884.20 | 948.43 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 6.03 ± 0.3% | not timed | not timed | 14.00 ± 1.4% | 13.10 ± 2.1% | not timed | not timed | 6.03 ± 0.6% | | 1.00 | 0.43 | 0.46 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.98 ± 6.3% | not timed | not timed | 13.81 ± 2.8% | 13.05 ± 1.9% | not timed | not timed | 7.99 ± 0.7% | | 1.00 | 0.58 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 717.87 ± 0.5% | not timed | not timed | 226.01 ± 2.2% | 10.93 ± 0.4% | not timed | not timed | 713.52 ± 0.8% | | 1.01 | 3.18 | 65.65 |
| reported/i787-keywords/opt-ascii | 5674 | 717.24 ± 2.4% | not timed | not timed | 358.11 ± 1.7% | 18.70 ± 21.6% | not timed | not timed | 710.16 ± 0.6% | | 1.01 | 2.00 | 38.36 |
| slow/quadratic-regex-1x | 100 | 11.11 ± 0.9% | not timed | not timed | 8.64 ± 0.8% | 0.08 ± 4.3% | not timed | not timed | 11.10 ± 0.3% | | 1.00 | 1.29 | 136.27 |
| slow/quadratic-regex-2x | 199 | 4.71 ± 0.2% | not timed | not timed | 4.16 ± 0.5% | 0.02 ± 0.3% | not timed | not timed | 4.76 ± 0.1% | | 0.99 | 1.13 | 222.96 |
| slow/quadratic-haystack-1x | 100 | 43.82 ± 2.0% | not timed | not timed | 17.82 ± 2.3% | 1.55 ± 7.8% | not timed | not timed | 43.43 ± 1.0% | | 1.01 | 2.46 | 28.27 |
| slow/quadratic-haystack-2x | 200 | 40.14 ± 1.5% | not timed | not timed | 8.32 ± 0.1% | 0.84 ± 6.4% | not timed | not timed | 39.84 ± 0.3% | | 1.01 | 4.83 | 47.63 |
| unicode/codepoints/any-one | 1112064 | 525.14 ± 0.7% | not timed | not timed | 352.82 ± 3.7% | 31.96 ± 16.7% | not timed | not timed | 512.81 ± 1.1% | | 1.02 | 1.49 | 16.43 |
| unicode/codepoints/any-all | 4382592 | 357.49 ± 0.1% | not timed | not timed | 355.20 ± 0.3% | 196.58 ± 22.9% | not timed | not timed | 357.43 ± 1.4% | | 1.00 | 1.01 | 1.82 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 12.43 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 752.32 ± 1.4% | not timed | not timed | 750.78 ± 2.4% | 236.58 ± 0.2% | not timed | not timed | 752.39 ± 0.2% | | 1.00 | 1.00 | 3.18 |
| unicode/overlapping-words/ascii | 6156 | 45.31 ± 4.5% | not timed | not timed | 58.98 ± 4.0% | 6.33 ± 9.9% | not timed | not timed | 45.25 ± 3.9% | | 1.00 | 0.77 | 7.16 |
| unicode/overlapping-words/english | 6156 | 2.31 ± 1.5% | not timed | not timed | 5.46 ± 0.4% | 3.92 ± 5.4% | not timed | not timed | 2.23 ± 4.0% | | 1.04 | 0.42 | 0.59 |
| unicode/overlapping-words/russian | 5710 | 2.05 ± 6.3% | not timed | not timed | 5.22 ± 0.4% | 9.64 ± 28.0% | not timed | not timed | 2.03 ± 4.8% | | 1.01 | 0.39 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 180.64 ± 9.4% | not timed | not timed | 107.74 ± 0.5% | 20.00 ± 10.9% | not timed | not timed | 181.40 ± 3.8% | | 1.00 | 1.68 | 9.03 |
| unicode/word/boundary-long-english | 3466 | 754.86 ± 0.2% | not timed | not timed | 737.39 ± 0.3% | 52.36 ± 18.8% | not timed | not timed | 755.19 ± 0.3% | | 1.00 | 1.02 | 14.42 |
| unicode/word/around-holmes-english | 27 | 86349.48 ± 0.6% | not timed | not timed | 68417.88 ± 0.9% | 36.41 ± 3.2% | not timed | not timed | 86616.39 ± 0.2% | | 1.00 | 1.26 | 2371.66 |
| wild/bibleref/long | 874 | 707.06 ± 3.3% | not timed | not timed | 719.00 ± 0.1% | 11.73 ± 0.3% | not timed | not timed | 707.34 ± 0.8% | | 1.00 | 0.98 | 60.27 |
| wild/bibleref/short | 30 | 34.11 ± 3.4% | not timed | not timed | 47.85 ± 0.5% | 23.08 ± 28.6% | not timed | not timed | 34.60 ± 3.8% | | 0.99 | 0.71 | 1.48 |
| wild/bibleref/line | 874 | 719.80 ± 0.7% | not timed | not timed | 346.63 ± 0.5% | 13.93 ± 3.0% | not timed | not timed | 718.33 ± 2.2% | | 1.00 | 2.08 | 51.69 |
| wild/caddy/caddy | 6 | 674.08 ± 2.6% | not timed | not timed | 368.28 ± 2.4% | 110.52 ± 10.2% | not timed | not timed | 671.04 ± 4.2% | | 1.00 | 1.83 | 6.10 |
| wild/dot-star-capture/rust-src-tools | 6 | 2220.55 ± 3.1% | not timed | not timed | 497.50 ± 0.7% | 23.19 ± 4.2% | not timed | not timed | 2221.02 ± 0.4% | | 1.00 | 4.46 | 95.75 |
| wild/ruff/noqa | 84 | 690.67 ± 0.3% | not timed | not timed | 705.99 ± 1.0% | 30.42 ± 2.6% | not timed | not timed | 692.15 ± 3.5% | | 1.00 | 0.98 | 22.70 |
| wild/ruff/unnecessary-coding-comment | 16 | 1392.04 ± 0.6% | not timed | not timed | 932.22 ± 1.5% | 208.06 ± 12.9% | not timed | not timed | 1391.71 ± 0.6% | | 1.00 | 1.49 | 6.69 |
| wild/ruff/string-quote-prefix | 2972 | 2120.46 ± 0.9% | not timed | not timed | 706.00 ± 0.4% | 465.00 ± 28.2% | not timed | not timed | 2121.46 ± 0.5% | | 1.00 | 3.00 | 4.56 |
| wild/ruff/space-around-operator | 1224378 | 307.72 ± 4.4% | not timed | not timed | 296.31 ± 2.0% | 27.67 ± 1.5% | not timed | not timed | 320.90 ± 3.2% | | 0.96 | 1.04 | 11.12 |
| wild/ruff/shebang | 282 | 1467.23 ± 1.1% | not timed | not timed | 553.91 ± 1.0% | 169.62 ± 17.5% | not timed | not timed | 1469.16 ± 1.0% | | 1.00 | 2.65 | 8.65 |
| wild/rustsec-cargo-audit/original-unix | 471 | 30220.02 ± 2.6% | not timed | not timed | 34104.04 ± 0.7% | 12774.61 ± 0.8% | not timed | not timed | 30377.13 ± 1.0% | | 0.99 | 0.89 | 2.37 |
| wild/rustsec-cargo-audit/original-windows | 462 | 26996.93 ± 7.1% | not timed | not timed | 31061.98 ± 3.0% | 11472.69 ± 4.4% | not timed | not timed | 27397.76 ± 6.6% | | 0.99 | 0.87 | 2.35 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 31099.33 ± 1.5% | not timed | not timed | 33608.18 ± 2.0% | 12291.85 ± 2.7% | not timed | not timed | 31286.85 ± 7.0% | | 0.99 | 0.93 | 2.53 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 27150.67 ± 4.7% | not timed | not timed | 33567.34 ± 2.9% | 12453.27 ± 9.2% | not timed | not timed | 27256.43 ± 9.6% | | 1.00 | 0.81 | 2.18 |
| wild/url/search | 234965 | 184.28 ± 4.6% | not timed | not timed | 89.98 ± 1.4% | 3.73 ± 2.2% | not timed | not timed | 180.57 ± 6.1% | | 1.02 | 2.05 | 49.41 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 23.0% | not timed | not timed | 0.01 ± 1.7% | 0.01 ± 26.8% | not timed | not timed | 0.04 ± 4.6% | | 1.00 | 2.87 | 4.07 |
| dictionary/compile/english-15 | 1 | 0.47 ± 12.9% | not timed | not timed | 0.11 ± 2.9% | 0.16 ± 14.7% | not timed | not timed | 0.47 ± 78.4% | | 1.00 | 4.20 | 2.94 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.44 ± 4.8% | not timed | not timed | 0.03 ± 1.2% | 50.79 ± 4.8% | not timed | not timed | 0.45 ± 4.3% | | 0.99 | 12.89 | 0.0087 |
| reported/i1095-word-repetition/ascii-compile | 1 | 61.00 ± 5.5% | not timed | not timed | 19.69 ± 12.1% | 87.26 ± 52.0% | not timed | not timed | 61.49 ± 4.5% | | 0.99 | 3.10 | 0.70 |
| reported/i787-keywords/compile | 1 | 55.07 ± 5.2% | not timed | not timed | 3.15 ± 5.4% | 26.83 ± 23.3% | not timed | not timed | 55.17 ± 5.9% | | 1.00 | 17.49 | 2.05 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 566.64 ± 7.2% | not timed | not timed | 201.49 ± 3.2% | 849.58 ± 9.0% | not timed | not timed | 595.09 ± 6.5% | | 0.95 | 2.81 | 0.67 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 79.04 ± 3.3% | not timed | not timed | 7.48 ± 12.5% | 68.72 ± 8.1% | not timed | not timed | 81.40 ± 10.6% | | 0.97 | 10.57 | 1.15 |
| unicode/compile/one-letter | 53 | 10.69 ± 10.5% | not timed | not timed | 8.09 ± 1.6% | 99.40 ± 6.1% | not timed | not timed | 10.69 ± 3.0% | | 1.00 | 1.32 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.95 ± 8.0% | not timed | not timed | 0.17 ± 8.3% | 91.93 ± 22.5% | not timed | not timed | 1.95 ± 3.3% | | 1.00 | 11.14 | 0.0212 |
| unicode/compile/fifty-letters-ascii | 1 | 300.27 ± 11.4% | not timed | not timed | 83.85 ± 14.0% | 287.65 ± 11.5% | not timed | not timed | 290.13 ± 26.2% | | 1.03 | 3.58 | 1.04 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 653.70 ± 22.3% | not timed | not timed | 63.16 ± 6.0% | 1016.38 ± 12.9% | not timed | not timed | 690.68 ± 6.0% | | 0.95 | 10.35 | 0.64 |
| unicode/compile/match-every-line-ascii | 4 | 1079.22 ± 11.2% | not timed | not timed | 221.67 ± 11.1% | 1023.92 ± 28.8% | not timed | not timed | 1100.22 ± 4.6% | | 0.98 | 4.87 | 1.05 |
| unicode/compile/negated-class-matches-codepoint | 1 | 544.00 ± 12.1% | not timed | not timed | 65.78 ± 15.4% | 1937.98 ± 10.4% | not timed | not timed | 563.06 ± 5.8% | | 0.97 | 8.27 | 0.28 |
| wild/bibleref/compile | 3 | 9.06 ± 14.4% | not timed | not timed | 3.19 ± 5.1% | 47.52 ± 11.7% | not timed | not timed | 9.06 ± 4.2% | | 1.00 | 2.84 | 0.19 |
| wild/url/compile | 1 | 0.98 ± 8.8% | not timed | not timed | 0.23 ± 12.7% | 0.62 ± 28.4% | not timed | not timed | 0.98 ± 9.4% | | 1.00 | 4.33 | 1.56 |

