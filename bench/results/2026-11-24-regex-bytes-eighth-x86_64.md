# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391514216 |
| Date | 2026-11-24 |
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
| literal: a word | 217 | 60945.55 ± 2.1% | 6115.39 ± 1.7% | 44.33 ± 1.5% | 50333.00 ± 2.2% | 15336.35 ± 3.5% | 15.55 ± 2.0% | 148.48 ± 1.9% | 61119.99 ± 1.8% | 9.97 | 1.00 | 1.21 | 3.97 |
| literal: a word that is not there | 0 | 79225.16 ± 1.5% | 5973.69 ± 5.0% | 43.49 ± 3.7% | 62256.57 ± 4.6% | 53465.97 ± 4.6% | 15.24 ± 18.5% | 138.73 ± 4.3% | 78408.94 ± 3.0% | 13.26 | 1.01 | 1.27 | 1.48 |
| literal: one of four words | 661 | 18958.37 ± 2.8% | 2201.09 ± 2.4% | 23.48 ± 2.7% | 14079.83 ± 1.0% | 37.27 ± 8.5% | 4.99 ± 0.9% | 12.23 ± 5.4% | 18954.09 ± 1.9% | 8.61 | 1.00 | 1.35 | 508.65 |
| literal: a word in any case | 217 | 57167.79 ± 2.9% | 2460.98 ± 2.2% | 31.46 ± 3.3% | 13972.44 ± 3.0% | 70.02 ± 1.7% | refused | differs | 56141.98 ± 4.1% | 23.23 | 1.02 | 4.09 | 816.40 |
| literal: an href attribute | 33 | 49720.17 ± 57.4% | 710.83 ± 4.3% | 36.50 ± 2.0% | 43703.99 ± 2.9% | 3349.33 ± 2.1% | 11.00 ± 2.3% | 123.08 ± 3.8% | 49467.41 ± 3.5% | 69.95 | 1.01 | 1.14 | 14.84 |
| literal: a word, second text | 123 | 63312.92 ± 84.3% | 4292.04 ± 26.5% | 43.18 ± 1.3% | 47994.60 ± 3.9% | 14068.52 ± 4.3% | 20.36 ± 2.3% | 124.13 ± 14.9% | 63339.56 ± 7.0% | 14.75 | 1.00 | 1.32 | 4.50 |
| class: two capitalized words | 1331 | 1065.87 ± 52.9% | 694.93 ± 76.0% | 36.31 ± 117.1% | 550.21 ± 110.1% | 59.14 ± 108.8% | 13.34 ± 54.1% | 99.67 ± 77.5% | 1066.57 ± 78.6% | 1.53 | 1.00 | 1.94 | 18.02 |
| class: a word that ends in ing | 3399 | 683.30 ± 3.0% | 685.26 ± 4.6% | 26.98 ± 1.3% | 646.38 ± 2.2% | 44.95 ± 67.6% | 7.83 ± 2.3% | 29.35 ± 5.4% | 681.30 ± 3.8% | 1.00 | 1.00 | 1.06 | 15.20 |
| class: a word in capitals | 2332 | 1559.50 ± 1.3% | 709.77 ± 3.8% | 41.87 ± 5.5% | 665.67 ± 3.7% | 63.83 ± 10.9% | 16.34 ± 2.8% | 132.41 ± 2.0% | 1557.54 ± 2.9% | 2.20 | 1.00 | 2.34 | 24.43 |
| class: a number | 8288 | 2609.12 ± 37.8% | 979.02 ± 41.1% | 42.48 ± 7.9% | 2299.84 ± 1.4% | 60.06 ± 17.0% | 0.46 ± 6.8% | 93.97 ± 4.9% | 2579.44 ± 3.5% | 2.67 | 1.01 | 1.13 | 43.44 |
| class: two capitalized words, second text | 5359 | 604.12 ± 7.1% | 627.64 ± 4.1% | 34.76 ± 15.9% | 566.54 ± 6.8% | 49.86 ± 11.0% | 17.53 ± 2.0% | 93.85 ± 2.9% | 603.16 ± 2.5% | 0.96 | 1.00 | 1.07 | 12.12 |
| other: a word between two words | 6104 | 1073.87 ± 1.4% | 691.34 ± 3.8% | 34.20 ± 4.9% | 959.34 ± 1.8% | 165.80 ± 10.0% | 10.31 ± 2.5% | 105.14 ± 4.9% | 1075.67 ± 1.9% | 1.55 | 1.00 | 1.12 | 6.48 |
| other: a number before a unit, second text | 1481 | 12880.97 ± 7.0% | 1436.95 ± 6.5% | 39.75 ± 45.5% | 10634.96 ± 40.1% | 59.66 ± 25.9% | 18.77 ± 4.4% | 103.52 ± 4.8% | 13046.45 ± 6.7% | 8.96 | 0.99 | 1.21 | 215.92 |
| other: a heading's start tag | 110 | 30641.65 ± 4.1% | 875.08 ± 5.5% | 40.45 ± 5.4% | 3294.05 ± 5.2% | 2524.15 ± 13.7% | 14.59 ± 4.5% | 152.94 ± 25.1% | 30569.06 ± 6.3% | 35.02 | 1.00 | 9.30 | 12.14 |
| other: a whole word | 217 | 37468.85 ± 2.2% | 703.10 ± 1.5% | 44.37 ± 2.9% | 35545.34 ± 0.6% | 72.90 ± 24.6% | 13.04 ± 2.3% | 82.40 ± 3.0% | 38449.44 ± 1.3% | 53.29 | 0.97 | 1.05 | 514.01 |
| other: a line's first word, second text | 3716 | 3406.97 ± 8.7% | 697.37 ± 4.7% | 47.67 ± 3.3% | 3469.28 ± 8.1% | 95.41 ± 8.5% | refused | refused | 3410.00 ± 3.1% | 4.89 | 1.00 | 0.98 | 35.71 |
| other: fourteen octets before an x | 87 | 50678.12 ± 6.7% | 353.07 ± 2.8% | 9.26 ± 7.4% | 4767.28 ± 0.8% | 14.36 ± 1.3% | differs | 24.83 ± 1.6% | 50862.12 ± 3.1% | 143.54 | 1.00 | 10.63 | 3530.03 |
| other: a Greek word | 21815 | 586.38 ± 2.5% | 467.57 ± 1.5% | 46.67 ± 1.4% | 347.71 ± 1.8% | 58.30 ± 20.5% | differs | refused | 586.63 ± 1.5% | 1.25 | 1.00 | 1.69 | 10.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.57 ± 0.9% | 26.54 ± 1.2% | 1.50 ± 1.8% | 23.89 ± 3.6% | 3.51 ± 7.2% | differs | 5.77 ± 3.7% | 26.70 ± 1.8% | 1.00 | 1.00 | 1.11 | 7.56 |
| a UUID | 32895 | 29.52 ± 55.8% | 29.50 ± 75.7% | 1.00 ± 2.1% | 18.27 ± 3.6% | 3.56 ± 2.1% | 0.73 ± 1.5% | 4.60 ± 11.3% | 28.86 ± 2.0% | 1.00 | 1.02 | 1.62 | 8.29 |
| an IPv4 address | 33176 | 46.13 ± 5.5% | 46.34 ± 2.5% | 3.17 ± 27.3% | 34.88 ± 1.5% | 8.96 ± 12.9% | differs | 5.72 ± 75.3% | 44.27 ± 59.3% | 1.00 | 1.04 | 1.32 | 5.15 |
| a date and time | 32954 | 42.43 ± 13.4% | 42.95 ± 1.3% | 2.39 ± 2.1% | 26.04 ± 1.5% | 10.62 ± 5.1% | 1.27 ± 1.6% | 10.94 ± 7.8% | 40.61 ± 2.5% | 0.99 | 1.04 | 1.63 | 4.00 |
| a field path | 32606 | 29.73 ± 66.0% | 29.74 ± 11.2% | 1.69 ± 1.5% | 27.48 ± 1.8% | 4.60 ± 0.6% | differs | 4.06 ± 40.1% | 29.98 ± 3.6% | 1.00 | 0.99 | 1.08 | 6.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.30 ± 6.8% | 15.23 ± 27.3% | 14.87 ± 2.6% | 17.01 ± 12.9% | 7.30 ± 5.6% | 1.03 ± 1.2% | none | 14.77 ± 4.8% | 1.00 | 1.04 | 0.90 | 2.10 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 352.28 ± 5.2% | 355.34 ± 2.0% | 414.00 ± 2.4% | 131.65 ± 1.9% | 303.30 ± 6.3% | 869.58 ± 2.7% | 5670.86 ± 14.1% | 353.60 ± 2.6% | 0.99 | 1.00 | 2.68 | 1.16 |
| a UUID | 62 | 231.77 ± 2.0% | 233.47 ± 6.6% | 257.83 ± 1.8% | 73.49 ± 1.5% | 150.04 ± 11.9% | 302.47 ± 3.0% | 7034.46 ± 1.9% | 233.11 ± 0.6% | 0.99 | 0.99 | 3.15 | 1.54 |
| an IPv4 address | 29 | 688.35 ± 2.7% | 690.35 ± 2.9% | 913.65 ± 2.6% | 116.01 ± 6.2% | 194.73 ± 8.9% | 552.17 ± 2.0% | 12731.07 ± 1.8% | 681.41 ± 3.0% | 1.00 | 1.01 | 5.93 | 3.53 |
| a date and time | 56 | 487.22 ± 1.3% | 491.26 ± 1.9% | 603.32 ± 1.2% | 112.42 ± 1.3% | 195.97 ± 7.6% | 556.00 ± 1.1% | 7997.79 ± 2.3% | 487.12 ± 0.9% | 0.99 | 1.00 | 4.33 | 2.49 |
| a field path | 39 | 355.81 ± 1.5% | 359.36 ± 2.1% | 411.28 ± 2.5% | 124.02 ± 1.2% | 281.62 ± 4.0% | 904.08 ± 2.1% | 7356.34 ± 1.7% | 353.73 ± 1.3% | 0.99 | 1.01 | 2.87 | 1.26 |
| literal: a word | 7 | 1066.93 ± 2.0% | 1148.22 ± 12.1% | 1998.95 ± 11.1% | 834.07 ± 41.8% | 961.42 ± 61.9% | 1805.41 ± 1.0% | 47035.03 ± 1.5% | 1062.40 ± 1.4% | 0.93 | 1.00 | 1.28 | 1.11 |
| literal: a word that is not there | 8 | 939.99 ± 83.7% | 1090.14 ± 86.9% | 1802.93 ± 44.9% | 772.88 ± 64.2% | 769.35 ± 142.6% | 1084.07 ± 82.8% | 40454.81 ± 152.3% | 690.54 ± 71.3% | 0.86 | 1.36 | 1.22 | 1.22 |
| literal: one of four words | 26 | 399.14 ± 2.4% | 624.58 ± 3.2% | 813.87 ± 2.6% | 65.30 ± 17.9% | 356.52 ± 7.4% | 637.11 ± 2.1% | 23655.66 ± 2.1% | 401.13 ± 27.5% | 0.64 | 1.00 | 6.11 | 1.12 |
| literal: a word in any case | 11 | 718.53 ± 39.6% | 768.81 ± 9.3% | 1100.10 ± 59.6% | 22.37 ± 1.7% | 1049.29 ± 21.3% | refused | 35313.18 ± 22.5% | 721.95 ± 2.2% | 0.93 | 1.00 | 32.12 | 0.68 |
| literal: an href attribute | 12 | 558.00 ± 5.6% | 575.14 ± 11.3% | 752.22 ± 15.8% | 59.96 ± 18.7% | 688.51 ± 54.7% | 1452.45 ± 46.1% | 33810.98 ± 5.0% | 554.66 ± 1.8% | 0.97 | 1.01 | 9.31 | 0.81 |
| literal: a word, second text | 10 | 934.24 ± 1.8% | 1032.60 ± 2.2% | 1617.93 ± 6.1% | 704.96 ± 2.3% | 814.34 ± 13.0% | 1477.52 ± 14.8% | 43701.81 ± 42.8% | 936.41 ± 1.1% | 0.90 | 1.00 | 1.33 | 1.15 |
| class: two capitalized words | 23 | 749.14 ± 4.5% | 812.19 ± 2.0% | 1130.33 ± 4.0% | 156.68 ± 14.1% | 774.34 ± 7.3% | 1424.90 ± 2.4% | 9498.84 ± 3.0% | 743.95 ± 5.2% | 0.92 | 1.01 | 4.78 | 0.97 |
| class: a word that ends in ing | 9 | 918.74 ± 2.4% | 1062.02 ± 4.2% | 1759.41 ± 1.8% | 204.19 ± 2.0% | 1066.79 ± 4.3% | 2204.38 ± 1.2% | 24502.63 ± 0.8% | 917.79 ± 2.2% | 0.87 | 1.00 | 4.50 | 0.86 |
| class: a word in capitals | 16 | 825.19 ± 7.9% | 907.79 ± 3.3% | 1415.31 ± 5.2% | 212.21 ± 3.0% | 1176.75 ± 9.3% | 2031.85 ± 7.0% | 12279.05 ± 11.7% | 837.90 ± 7.7% | 0.91 | 0.98 | 3.89 | 0.70 |
| class: a number | 6 | 1047.35 ± 2.5% | 1165.15 ± 1.8% | 2087.96 ± 5.3% | 58.55 ± 40.8% | 2104.68 ± 2.1% | 3719.07 ± 3.4% | 35410.63 ± 1.8% | 1041.17 ± 2.7% | 0.90 | 1.01 | 17.89 | 0.50 |
| class: two capitalized words, second text | 23 | 750.58 ± 2.0% | 807.35 ± 3.1% | 1143.80 ± 15.9% | 158.39 ± 4.0% | 793.30 ± 3.4% | 1420.02 ± 4.6% | 9499.26 ± 3.4% | 747.47 ± 3.8% | 0.93 | 1.00 | 4.74 | 0.95 |
| other: a word between two words | 13 | 901.51 ± 10.4% | 960.36 ± 2.2% | 1469.87 ± 2.7% | 217.42 ± 3.1% | 804.23 ± 5.6% | 1537.51 ± 6.0% | 23382.94 ± 15.0% | 921.60 ± 2.2% | 0.94 | 0.98 | 4.15 | 1.12 |
| other: a number before a unit, second text | 15 | 645.96 ± 3.7% | 741.94 ± 4.0% | 1039.65 ± 5.5% | 56.92 ± 3.4% | 953.31 ± 4.6% | 1744.30 ± 5.6% | 24783.39 ± 13.9% | 655.10 ± 3.4% | 0.87 | 0.99 | 11.35 | 0.68 |
| other: a heading's start tag | 13 | 583.63 ± 4.0% | 597.24 ± 5.3% | 784.37 ± 3.1% | 58.54 ± 1.2% | 922.14 ± 9.6% | 1656.38 ± 1.6% | 28990.62 ± 2.8% | 581.96 ± 2.8% | 0.98 | 1.00 | 9.97 | 0.63 |
| other: a whole word | 11 | 949.31 ± 2.2% | 1019.20 ± 2.5% | 1581.84 ± 2.0% | 186.10 ± 1.2% | 872.13 ± 9.5% | 1567.05 ± 1.6% | 42560.60 ± 1.3% | 945.81 ± 1.5% | 0.93 | 1.00 | 5.10 | 1.09 |
| other: a line's first word, second text | 17 | 878.13 ± 5.3% | 941.58 ± 4.6% | 1449.86 ± 2.3% | 195.50 ± 3.8% | 997.63 ± 3.1% | refused | refused | 868.87 ± 5.0% | 0.93 | 1.01 | 4.49 | 0.88 |
| other: fourteen octets before an x | 16 | 183.72 ± 4.0% | 256.49 ± 3.9% | 291.58 ± 4.2% | 23.35 ± 3.7% | 699.93 ± 2.1% | 766.86 ± 2.6% | 21688.11 ± 2.4% | 184.19 ± 2.2% | 0.72 | 1.00 | 7.87 | 0.26 |
| other: a Greek word | 8 | 709.63 ± 10.7% | 989.33 ± 4.1% | 1554.18 ± 4.9% | 76.32 ± 4.3% | 2112.89 ± 4.4% | 3330.40 ± 4.1% | refused | 718.22 ± 3.9% | 0.72 | 0.99 | 9.30 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 45099.26 ± 2.4% | not timed | not timed | 43673.90 ± 4.3% | 3522.84 ± 24.2% | not timed | not timed | 45486.89 ± 5.5% | | 0.99 | 1.03 | 12.80 |
| 01-literal/sherlock-casei-en | 522 | 40572.51 ± 4.3% | not timed | not timed | 11432.67 ± 4.3% | 52.54 ± 5.0% | not timed | not timed | 40415.44 ± 5.2% | | 1.00 | 3.55 | 772.24 |
| 01-literal/sherlock-ru | 724 | 44884.35 ± 0.9% | not timed | not timed | 44073.94 ± 6.7% | 2321.39 ± 5.6% | not timed | not timed | 44997.80 ± 1.1% | | 1.00 | 1.02 | 19.34 |
| 01-literal/sherlock-casei-ru | 746 | 14598.50 ± 1.1% | not timed | not timed | 9242.57 ± 1.1% | 55.47 ± 4.5% | not timed | not timed | 14713.33 ± 1.2% | | 0.99 | 1.58 | 263.16 |
| 01-literal/sherlock-zh | 30 | 79032.03 ± 0.6% | not timed | not timed | 57772.04 ± 2.1% | 2079.85 ± 2.1% | not timed | not timed | 78657.88 ± 1.4% | | 1.00 | 1.37 | 38.00 |
| 02-literal-alternate/sherlock-en | 714 | 16764.31 ± 4.5% | not timed | not timed | 13763.65 ± 4.2% | 29.32 ± 3.1% | not timed | not timed | 16544.15 ± 4.1% | | 1.01 | 1.22 | 571.83 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3077.63 ± 7.4% | not timed | not timed | 2906.85 ± 1.0% | 17.86 ± 3.2% | not timed | not timed | 3048.59 ± 8.1% | | 1.01 | 1.06 | 172.30 |
| 02-literal-alternate/sherlock-ru | 899 | 12539.79 ± 3.8% | not timed | not timed | 7267.03 ± 5.6% | 37.57 ± 3.1% | not timed | not timed | 12611.19 ± 3.2% | | 0.99 | 1.73 | 333.75 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2649.01 ± 7.4% | not timed | not timed | 1407.28 ± 33.2% | 15.57 ± 30.3% | not timed | not timed | 2687.51 ± 7.2% | | 0.99 | 1.88 | 170.10 |
| 02-literal-alternate/sherlock-zh | 207 | 23576.90 ± 2.0% | not timed | not timed | 15749.85 ± 2.9% | 52.97 ± 3.5% | not timed | not timed | 23300.20 ± 27.0% | | 1.01 | 1.50 | 445.11 |
| 03-date/ascii | 111817 | 151.23 ± 5.2% | not timed | not timed | 122.97 ± 4.0% | 0.32 ± 10.3% | not timed | not timed | 149.11 ± 2.8% | | 1.01 | 1.23 | 479.43 |
| 04-ruff-noqa/real | 84 | 670.09 ± 4.3% | not timed | not timed | 692.75 ± 4.2% | 29.91 ± 8.1% | not timed | not timed | 642.72 ± 2.2% | | 1.04 | 0.97 | 22.41 |
| 04-ruff-noqa/tweaked | 44 | 829.63 ± 24.0% | not timed | not timed | 714.68 ± 6.6% | 488.93 ± 12.0% | not timed | not timed | 833.62 ± 54.0% | | 1.00 | 1.16 | 1.70 |
| 05-lexer-veryl/single | 124800 | 6.26 ± 18.3% | not timed | not timed | 7.59 ± 2.5% | 0.34 ± 7.3% | not timed | not timed | 6.66 ± 16.0% | | 0.94 | 0.82 | 18.15 |
| 06-cloud-flare-redos/original | 107 | 535.51 ± 3.9% | not timed | not timed | 283.33 ± 4.7% | 35.48 ± 2.7% | not timed | not timed | 530.66 ± 2.9% | | 1.01 | 1.89 | 15.09 |
| 06-cloud-flare-redos/simplified-short | 102 | 547.31 ± 3.6% | not timed | not timed | 301.66 ± 1.6% | 40.94 ± 0.5% | not timed | not timed | 538.46 ± 3.7% | | 1.02 | 1.81 | 13.37 |
| 06-cloud-flare-redos/simplified-long | 10000 | 645.24 ± 4.4% | not timed | not timed | 316.69 ± 63.3% | 45.11 ± 1.1% | not timed | not timed | 644.30 ± 17.7% | | 1.00 | 2.04 | 14.30 |
| 07-unicode-character-data/parse-line | 558784 | 329.89 ± 1.3% | not timed | not timed | 249.13 ± 1.9% | 61.72 ± 8.6% | not timed | not timed | 331.18 ± 7.6% | | 1.00 | 1.32 | 5.34 |
| 08-words/all-english | 56691 | 135.41 ± 3.2% | not timed | not timed | 103.78 ± 2.8% | 18.10 ± 3.3% | not timed | not timed | 131.67 ± 1.7% | | 1.03 | 1.30 | 7.48 |
| 08-words/long-english | 839 | 725.40 ± 3.6% | not timed | not timed | 707.56 ± 3.7% | 47.11 ± 3.3% | not timed | not timed | 717.83 ± 4.7% | | 1.01 | 1.03 | 15.40 |
| 09-aws-keys/full | 0 | 668.51 ± 5.0% | not timed | not timed | 705.51 ± 3.2% | 93.00 ± 19.0% | not timed | not timed | 650.82 ± 19.2% | | 1.03 | 0.95 | 7.19 |
| 09-aws-keys/quick | 0 | 1418.08 ± 32.9% | not timed | not timed | 1205.85 ± 57.3% | 532.34 ± 2.8% | not timed | not timed | 1438.65 ± 23.0% | | 0.99 | 1.18 | 2.66 |
| 10-bounded-repeat/letters-en | 1833 | 821.30 ± 44.9% | not timed | not timed | 721.63 ± 4.6% | 29.05 ± 1.9% | not timed | not timed | 821.84 ± 4.0% | | 1.00 | 1.14 | 28.27 |
| 10-bounded-repeat/letters-ru | 3475 | 702.71 ± 2.4% | not timed | not timed | 630.11 ± 1.8% | 28.22 ± 27.7% | not timed | not timed | 672.17 ± 24.6% | | 1.05 | 1.12 | 24.90 |
| 10-bounded-repeat/context | 53 | 110.20 ± 10.6% | not timed | not timed | 87.94 ± 35.3% | 28.36 ± 21.9% | not timed | not timed | 115.81 ± 2.1% | | 0.95 | 1.25 | 3.89 |
| 10-bounded-repeat/capitals | 11 | 750.94 ± 9.2% | not timed | not timed | 707.29 ± 0.8% | 51.11 ± 5.6% | not timed | not timed | 734.11 ± 10.6% | | 1.02 | 1.06 | 14.69 |
| 11-unstructured-to-json/extract | 600 | 73.30 ± 1.7% | not timed | not timed | 102.81 ± 8.8% | 73.52 ± 16.2% | not timed | not timed | 74.09 ± 1.0% | | 0.99 | 0.71 | 1.00 |
| 12-dictionary/single | 1 | 660.45 ± 2.1% | not timed | not timed | 630.92 ± 2.3% | 0.62 ± 4.7% | not timed | not timed | 660.04 ± 5.2% | | 1.00 | 1.05 | 1060.73 |
| 14-quadratic/1x | 100 | 39.42 ± 2.0% | not timed | not timed | 17.35 ± 1.5% | 1.39 ± 4.7% | not timed | not timed | 38.83 ± 1.4% | | 1.02 | 2.27 | 28.27 |
| 14-quadratic/2x | 200 | 31.58 ± 5.0% | not timed | not timed | 8.05 ± 2.8% | 0.77 ± 2.0% | not timed | not timed | 31.31 ± 5.6% | | 1.01 | 3.92 | 40.89 |
| 14-quadratic/10x | 1000 | 10.70 ± 0.7% | not timed | not timed | 1.47 ± 3.4% | 0.17 ± 1.3% | not timed | not timed | 10.71 ± 0.8% | | 1.00 | 7.29 | 62.60 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.89 ± 8.1% | not timed | not timed | 0.52 ± 10.0% | 0.77 ± 42.8% | not timed | not timed | 1.88 ± 4.8% | | 1.00 | 3.61 | 2.47 |
| 04-ruff-noqa/compile-real | 1 | 182.16 ± 2.2% | not timed | not timed | 20.61 ± 44.1% | 193.75 ± 36.3% | not timed | not timed | 183.07 ± 6.7% | | 0.99 | 8.84 | 0.94 |
| 05-lexer-veryl/compile-single | 1 | 21.96 ± 11.9% | not timed | not timed | 3.80 ± 8.2% | 9.82 ± 5.3% | not timed | not timed | 22.21 ± 4.8% | | 0.99 | 5.77 | 2.24 |
| 07-unicode-character-data/compile | 1 | 174.30 ± 1.6% | not timed | not timed | 39.60 ± 14.3% | 53.55 ± 5.9% | not timed | not timed | 174.74 ± 1.9% | | 1.00 | 4.40 | 3.25 |
| 09-aws-keys/compile-full | 1 | 74.16 ± 4.2% | not timed | not timed | 12.23 ± 2.9% | 33.45 ± 5.1% | not timed | not timed | 74.09 ± 6.1% | | 1.00 | 6.06 | 2.22 |
| 09-aws-keys/compile-quick | 1 | 278.75 ± 1.4% | not timed | not timed | 74.79 ± 2.9% | 184.78 ± 22.8% | not timed | not timed | 277.53 ± 10.0% | | 1.00 | 3.73 | 1.51 |
| 10-bounded-repeat/compile-context | 1 | 83.95 ± 1.4% | not timed | not timed | 17.00 ± 0.8% | 23.98 ± 4.3% | not timed | not timed | 84.08 ± 1.0% | | 1.00 | 4.94 | 3.50 |
| 10-bounded-repeat/compile-capitals | 1 | 128.07 ± 1.7% | not timed | not timed | 12.50 ± 1.2% | 36.52 ± 2.9% | not timed | not timed | 128.13 ± 1.9% | | 1.00 | 10.25 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 270.90 ± 1.3% | not timed | not timed | 62.95 ± 2.8% | 97.67 ± 4.3% | not timed | not timed | 270.05 ± 1.9% | | 1.00 | 4.30 | 2.77 |
| 12-dictionary/compile-single | 1 | 0.44 ± 4.1% | not timed | not timed | 0.08 ± 1.8% | 0.13 ± 14.9% | not timed | not timed | 0.44 ± 0.6% | | 1.00 | 5.24 | 3.33 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.68 ± 7.0% | not timed | not timed | 9.74 ± 4.6% | 0.78 ± 20.6% | not timed | not timed | 10.85 ± 3.7% | | 0.98 | 1.10 | 13.66 |
| dictionary/search/english-10 | 690 | 1.70 ± 4.3% | not timed | not timed | 241.86 ± 2.7% | 0.01 ± 2.7% | not timed | not timed | 1.72 ± 8.9% | | 0.99 | 0.0070 | 163.03 |
| dictionary/search/english-15 | 15 | 624.91 ± 33.4% | not timed | not timed | 599.85 ± 1.8% | 0.59 ± 10.4% | not timed | not timed | 632.24 ± 2.0% | | 0.99 | 1.04 | 1064.41 |
| folly/awyer-inn-busted | 1 | 6746.28 ± 14.6% | not timed | not timed | 158.66 ± 2.3% | 68.52 ± 2.1% | not timed | not timed | 6684.61 ± 13.5% | | 1.01 | 42.52 | 98.45 |
| folly/literal-never-match-rare | 0 | 81995.03 ± 0.2% | not timed | not timed | 64260.52 ± 14.1% | 86432.14 ± 0.9% | not timed | not timed | 81584.22 ± 1.1% | | 1.01 | 1.28 | 0.95 |
| folly/literal-never-match-frequent | 0 | 35964.66 ± 8.6% | not timed | not timed | 62197.06 ± 1.0% | 2842.85 ± 1.5% | not timed | not timed | 36897.63 ± 10.5% | | 0.97 | 0.58 | 12.65 |
| folly/literal-never-match-tricksy | 1 | 5061.03 ± 4.9% | not timed | not timed | 8369.70 ± 22.3% | 3680.01 ± 68.3% | not timed | not timed | 5103.41 ± 5.4% | | 0.99 | 0.60 | 1.38 |
| grep/every-line | 239963 | 1750.21 ± 2.9% | not timed | not timed | 1250.89 ± 1.3% | 479.51 ± 13.7% | not timed | not timed | 1754.96 ± 3.1% | | 1.00 | 1.40 | 3.65 |
| grep/long-words-ascii | 5073 | 634.56 ± 1.4% | not timed | not timed | 582.10 ± 7.2% | 62.36 ± 8.2% | not timed | not timed | 618.93 ± 4.2% | | 1.03 | 1.09 | 10.18 |
| imported/leipzig/twain | 811 | 62818.07 ± 79.9% | not timed | not timed | 53276.55 ± 2.7% | 14314.63 ± 1.1% | not timed | not timed | 62146.09 ± 61.8% | | 1.01 | 1.18 | 4.39 |
| imported/leipzig/twain-insensitive | 965 | 18550.39 ± 1.0% | not timed | not timed | 16448.44 ± 14.3% | 63.00 ± 1.8% | not timed | not timed | 18570.40 ± 0.8% | | 1.00 | 1.13 | 294.46 |
| imported/leipzig/shing | 1540 | 733.98 ± 3.7% | not timed | not timed | 26630.93 ± 4.5% | 50.87 ± 2.0% | not timed | not timed | 731.95 ± 0.9% | | 1.00 | 0.0276 | 14.43 |
| imported/leipzig/huck-saw | 262 | 31940.04 ± 4.0% | not timed | not timed | 22826.65 ± 2.6% | 46.06 ± 3.9% | not timed | not timed | 32382.44 ± 4.5% | | 0.99 | 1.40 | 693.44 |
| imported/leipzig/word-ending-nn | 262 | 706.47 ± 1.4% | not timed | not timed | 707.00 ± 2.9% | 34.87 ± 12.0% | not timed | not timed | 706.70 ± 2.5% | | 1.00 | 1.00 | 20.26 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 14790.32 ± 3.9% | not timed | not timed | 4814.05 ± 5.7% | 15.17 ± 3.2% | not timed | not timed | 14572.04 ± 3.6% | | 1.01 | 3.07 | 975.27 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 27060.68 ± 8.6% | not timed | not timed | 21406.41 ± 1.3% | 28.50 ± 7.8% | not timed | not timed | 27273.47 ± 1.5% | | 0.99 | 1.26 | 949.54 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6420.12 ± 4.5% | not timed | not timed | 1124.52 ± 1.2% | 17.88 ± 8.8% | not timed | not timed | 6440.71 ± 3.1% | | 1.00 | 5.71 | 359.06 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 702.91 ± 6.1% | not timed | not timed | 706.23 ± 9.4% | 18.61 ± 6.0% | not timed | not timed | 699.48 ± 8.9% | | 1.00 | 1.00 | 37.77 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 721.41 ± 7.1% | not timed | not timed | 705.37 ± 5.4% | 16.22 ± 5.6% | not timed | not timed | 699.71 ± 7.3% | | 1.03 | 1.02 | 44.47 |
| imported/leipzig/tom-river | 2 | 16554.51 ± 7.5% | not timed | not timed | 17170.20 ± 4.4% | 51.88 ± 2.8% | not timed | not timed | 16526.23 ± 2.0% | | 1.00 | 0.96 | 319.07 |
| imported/leipzig/ing | 78424 | 722.54 ± 6.5% | not timed | not timed | 670.88 ± 6.6% | 44.37 ± 10.9% | not timed | not timed | 709.89 ± 4.6% | | 1.02 | 1.08 | 16.29 |
| imported/leipzig/ing-whitespace | 55248 | 903.97 ± 6.1% | not timed | not timed | 2916.88 ± 3.3% | 32.60 ± 4.8% | not timed | not timed | 904.08 ± 6.7% | | 1.00 | 0.31 | 27.73 |
| imported/leipzig/awyer-inn | 209 | 900.59 ± 13.0% | not timed | not timed | 17257.05 ± 66.7% | 34.19 ± 10.7% | not timed | not timed | 904.22 ± 1.8% | | 1.00 | 0.0522 | 26.34 |
| imported/leipzig/quotes-bounded | 8886 | 2436.37 ± 6.7% | not timed | not timed | 3858.74 ± 6.5% | 57.94 ± 2.9% | not timed | not timed | 2466.70 ± 6.0% | | 0.99 | 0.63 | 42.05 |
| imported/leipzig/non-ascii-alternate | 2 | 59047.82 ± 3.8% | not timed | not timed | 24264.57 ± 1.5% | 82.80 ± 32.7% | not timed | not timed | 57303.88 ± 4.2% | | 1.03 | 2.43 | 713.14 |
| imported/leipzig/math-symbols | 69 | 4232.27 ± 7.2% | not timed | not timed | 710.40 ± 13.7% | 55.70 ± 5.8% | not timed | not timed | 4260.98 ± 5.1% | | 0.99 | 5.96 | 75.98 |
| imported/leipzig/bounded-strings-ending-z | 0 | 706.09 ± 5.4% | not timed | not timed | 713.97 ± 1.5% | 38.05 ± 19.6% | not timed | not timed | 709.35 ± 10.5% | | 1.00 | 0.99 | 18.56 |
| imported/lh3lh3-reb/uri | 17549 | 879.05 ± 49.8% | not timed | not timed | 1495.42 ± 40.4% | 39.71 ± 3.1% | not timed | not timed | 898.93 ± 2.6% | | 0.98 | 0.59 | 22.14 |
| imported/lh3lh3-reb/email | 15057 | 981.00 ± 1.3% | not timed | not timed | 1433.97 ± 7.4% | 42.10 ± 6.9% | not timed | not timed | 975.12 ± 1.6% | | 1.01 | 0.68 | 23.30 |
| imported/lh3lh3-reb/date | 668 | 1114.07 ± 1.7% | not timed | not timed | 1271.83 ± 1.8% | 70.33 ± 4.1% | not timed | not timed | 1117.35 ± 1.1% | | 1.00 | 0.88 | 15.84 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 916.30 ± 6.4% | not timed | not timed | 530.56 ± 0.4% | 21.92 ± 1.4% | not timed | not timed | 907.33 ± 10.5% | | 1.01 | 1.73 | 41.81 |
| imported/mariomka/email | 92 | 835.30 ± 4.2% | not timed | not timed | 73437.53 ± 3.5% | 49.78 ± 4.1% | not timed | not timed | 833.33 ± 4.7% | | 1.00 | 0.0114 | 16.78 |
| imported/mariomka/uri | 5301 | 711.64 ± 4.8% | not timed | not timed | 9125.26 ± 6.5% | 49.87 ± 2.3% | not timed | not timed | 709.29 ± 3.6% | | 1.00 | 0.0780 | 14.27 |
| imported/mariomka/ip | 5 | 2381.45 ± 4.1% | not timed | not timed | 2878.85 ± 2.6% | 33.10 ± 12.1% | not timed | not timed | 2383.33 ± 5.6% | | 1.00 | 0.83 | 71.94 |
| imported/rsc/no-exponential | 0 | 1127.18 ± 3.1% | not timed | not timed | 768.83 ± 4.4% | 35.49 ± 1.1% | not timed | not timed | 1092.19 ± 2.1% | | 1.03 | 1.47 | 31.76 |
| imported/rsc/literal | 1 | 1387.61 ± 6.7% | not timed | not timed | 2915.83 ± 2.2% | 323.23 ± 48.6% | not timed | not timed | 1421.51 ± 1.3% | | 0.98 | 0.48 | 4.29 |
| imported/rsc/not-literal | 2 | 1263.24 ± 8.2% | not timed | not timed | 1333.78 ± 30.4% | 75.02 ± 70.0% | not timed | not timed | 1265.86 ± 6.2% | | 1.00 | 0.95 | 16.84 |
| imported/rsc/match-class | 1 | 2259.05 ± 3.4% | not timed | not timed | 3001.61 ± 3.1% | 97.06 ± 7.9% | not timed | not timed | 2253.90 ± 1.6% | | 1.00 | 0.75 | 23.28 |
| imported/rsc/match-class-in-range | 1 | 2242.71 ± 48.4% | not timed | not timed | 4628.15 ± 0.9% | 97.66 ± 24.2% | not timed | not timed | 2255.89 ± 60.6% | | 0.99 | 0.48 | 22.96 |
| imported/rsc/match-class-unicode | 1 | 664.17 ± 4.2% | not timed | not timed | 654.74 ± 1.7% | 117.08 ± 30.5% | not timed | not timed | 650.75 ± 4.3% | | 1.02 | 1.01 | 5.67 |
| imported/rsc/anchored-literal-short-non-match | 0 | 906.69 ± 88.6% | not timed | not timed | 1722.79 ± 13.9% | 445.45 ± 4.6% | not timed | not timed | 906.84 ± 34.1% | | 1.00 | 0.53 | 2.04 |
| imported/rsc/anchored-literal-long-non-match | 0 | 14793.62 ± 3.4% | not timed | not timed | 25893.69 ± 1.5% | 6636.70 ± 2.4% | not timed | not timed | 14895.79 ± 2.3% | | 0.99 | 0.57 | 2.23 |
| imported/rsc/anchored-literal-short-match | 4 | 648.53 ± 2.3% | not timed | not timed | 940.48 ± 2.5% | 148.40 ± 24.1% | not timed | not timed | 637.56 ± 5.6% | | 1.02 | 0.69 | 4.37 |
| imported/rsc/anchored-literal-long-match | 4 | 4309.78 ± 24.0% | not timed | not timed | 14117.87 ± 76.8% | 2199.67 ± 8.2% | not timed | not timed | 4285.85 ± 2.8% | | 1.01 | 0.31 | 1.96 |
| imported/rsc/one-pass-short | 17 | 521.98 ± 4.2% | not timed | not timed | 436.08 ± 3.1% | 49.69 ± 8.7% | not timed | not timed | 499.91 ± 2.8% | | 1.04 | 1.20 | 10.50 |
| imported/rsc/one-pass-short-not | 17 | 346.92 ± 3.8% | not timed | not timed | 461.13 ± 1.8% | 45.35 ± 7.1% | not timed | not timed | 343.98 ± 3.9% | | 1.01 | 0.75 | 7.65 |
| imported/rsc/one-pass-long-prefix | 26 | 362.23 ± 65.9% | not timed | not timed | 504.21 ± 3.1% | 180.88 ± 58.2% | not timed | not timed | 361.94 ± 12.8% | | 1.00 | 0.72 | 2.00 |
| imported/rsc/one-pass-long-prefix-not | 26 | 477.35 ± 5.8% | not timed | not timed | 516.53 ± 1.8% | 108.31 ± 12.3% | not timed | not timed | 470.32 ± 3.1% | | 1.01 | 0.92 | 4.41 |
| imported/rsc/long-needle1 | 31 | 85808.68 ± 2.0% | not timed | not timed | 66015.72 ± 21.3% | 5.82 ± 7.9% | not timed | not timed | 86435.85 ± 2.0% | | 0.99 | 1.30 | 14755.20 |
| imported/rsc/long-needle2 | 31 | 86067.79 ± 0.9% | not timed | not timed | 349.42 ± 23.3% | 5.81 ± 7.1% | not timed | not timed | 86619.14 ± 2.1% | | 0.99 | 246.32 | 14809.65 |
| imported/rsc/easy0-32 | 26 | 1837.82 ± 16.4% | not timed | not timed | 2786.22 ± 2.2% | 239.46 ± 1.5% | not timed | not timed | 1928.47 ± 7.5% | | 0.95 | 0.66 | 7.67 |
| imported/rsc/easy0-1k | 26 | 30670.71 ± 3.1% | not timed | not timed | 30648.55 ± 1.9% | 3353.62 ± 13.3% | not timed | not timed | 31255.36 ± 3.3% | | 0.98 | 1.00 | 9.15 |
| imported/rsc/easy0-32k | 26 | 80968.01 ± 20.0% | not timed | not timed | 63071.11 ± 19.2% | 38660.24 ± 25.0% | not timed | not timed | 81859.41 ± 2.8% | | 0.99 | 1.28 | 2.09 |
| imported/rsc/easy0-1mb | 26 | 83906.16 ± 0.5% | not timed | not timed | 66661.68 ± 1.9% | 98709.19 ± 1.5% | not timed | not timed | 83330.23 ± 0.9% | | 1.01 | 1.26 | 0.85 |
| imported/rsc/easy1-32 | 19 | 521.41 ± 2.5% | not timed | not timed | 1206.03 ± 3.7% | 207.73 ± 15.2% | not timed | not timed | 516.13 ± 2.5% | | 1.01 | 0.43 | 2.51 |
| imported/rsc/easy1-1k | 19 | 703.82 ± 8.6% | not timed | not timed | 25863.37 ± 4.7% | 3675.99 ± 11.3% | not timed | not timed | 696.52 ± 5.7% | | 1.01 | 0.0272 | 0.19 |
| imported/rsc/easy1-32k | 19 | 710.50 ± 1.1% | not timed | not timed | 839871.64 ± 5.6% | 42272.93 ± 24.6% | not timed | not timed | 709.94 ± 2.2% | | 1.00 | 0.0008 | 0.0168 |
| imported/rsc/easy1-1mb | 19 | 707.94 ± 6.1% | not timed | not timed | 26700484.86 ± 33.9% | 97322.83 ± 3.7% | not timed | not timed | 714.80 ± 2.4% | | 0.99 | 0.0000 | 0.0073 |
| imported/rsc/medium-32 | 27 | 697.36 ± 2.8% | not timed | not timed | 1129.67 ± 1.8% | 114.58 ± 19.6% | not timed | not timed | 691.08 ± 1.4% | | 1.01 | 0.62 | 6.09 |
| imported/rsc/medium-1k | 27 | 10854.22 ± 0.8% | not timed | not timed | 20865.57 ± 1.5% | 113.97 ± 2.6% | not timed | not timed | 10842.61 ± 14.3% | | 1.00 | 0.52 | 95.24 |
| imported/rsc/medium-32k | 27 | 71928.98 ± 1.7% | not timed | not timed | 649182.83 ± 0.5% | 77.97 ± 3.8% | not timed | not timed | 71939.01 ± 1.5% | | 1.00 | 0.11 | 922.49 |
| imported/rsc/medium-1mb | 27 | 81992.97 ± 1.8% | not timed | not timed | 20593308.49 ± 1.6% | 78.78 ± 1.7% | not timed | not timed | 82192.56 ± 0.9% | | 1.00 | 0.0040 | 1040.83 |
| imported/rsc/hard-32 | 58 | 350.86 ± 2.6% | not timed | not timed | 519.39 ± 1.3% | 74.47 ± 32.1% | not timed | not timed | 346.40 ± 2.1% | | 1.01 | 0.68 | 4.71 |
| imported/rsc/hard-1k | 27 | 680.52 ± 0.7% | not timed | not timed | 20007.02 ± 10.9% | 60.09 ± 2.7% | not timed | not timed | 679.28 ± 0.8% | | 1.00 | 0.0340 | 11.32 |
| imported/rsc/hard-32k | 27 | 704.25 ± 2.6% | not timed | not timed | 638650.54 ± 21.3% | 48.31 ± 1.2% | not timed | not timed | 703.28 ± 4.2% | | 1.00 | 0.0011 | 14.58 |
| imported/rsc/hard-1mb | 51 | 692.73 ± 3.4% | not timed | not timed | 10611379.67 ± 3.6% | 46.91 ± 7.3% | not timed | not timed | 702.39 ± 4.8% | | 0.99 | 0.0001 | 14.77 |
| imported/rsc/reallyhard0-32 | 58 | 349.35 ± 1.1% | not timed | not timed | 330.31 ± 1.3% | 74.69 ± 9.1% | not timed | not timed | 344.67 ± 1.1% | | 1.01 | 1.06 | 4.68 |
| imported/rsc/reallyhard0-1k | 27 | 686.00 ± 1.2% | not timed | not timed | 685.63 ± 1.1% | 59.58 ± 2.4% | not timed | not timed | 687.81 ± 1.4% | | 1.00 | 1.00 | 11.51 |
| imported/rsc/reallyhard0-32k | 27 | 705.28 ± 2.4% | not timed | not timed | 710.21 ± 1.8% | 48.03 ± 3.8% | not timed | not timed | 706.16 ± 2.7% | | 1.00 | 0.99 | 14.69 |
| imported/rsc/reallyhard0-1mb | 51 | 707.51 ± 1.1% | not timed | not timed | 704.84 ± 1.3% | 48.14 ± 1.5% | not timed | not timed | 702.38 ± 1.6% | | 1.01 | 1.00 | 14.70 |
| imported/rsc/reallyreallyhard0-32 | 47 | 397.92 ± 1.7% | not timed | not timed | 265.24 ± 1.4% | 90.70 ± 8.6% | not timed | not timed | 399.47 ± 1.0% | | 1.00 | 1.50 | 4.39 |
| imported/rsc/reallyreallyhard0-1k | 16 | 1015.19 ± 1.7% | not timed | not timed | 10794.15 ± 3.7% | 49.57 ± 2.2% | not timed | not timed | 1017.36 ± 1.7% | | 1.00 | 0.0940 | 20.48 |
| imported/rsc/reallyreallyhard0-32k | 16 | 736.58 ± 2.6% | not timed | not timed | 57065.51 ± 16.3% | 38.77 ± 69.9% | not timed | not timed | 737.25 ± 3.1% | | 1.00 | 0.0129 | 19.00 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 703.78 ± 0.7% | not timed | not timed | 65596.47 ± 0.4% | 39.24 ± 0.8% | not timed | not timed | 702.76 ± 0.8% | | 1.00 | 0.0107 | 17.94 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 387.56 ± 15.4% | not timed | not timed | 275.56 ± 2.2% | 91.90 ± 8.3% | not timed | not timed | 391.05 ± 1.7% | | 0.99 | 1.41 | 4.22 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 982.88 ± 0.8% | not timed | not timed | 10410.80 ± 1.8% | 49.35 ± 1.8% | not timed | not timed | 979.79 ± 0.6% | | 1.00 | 0.0944 | 19.92 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 729.96 ± 3.1% | not timed | not timed | 56655.73 ± 1.2% | 39.14 ± 1.2% | not timed | not timed | 732.24 ± 3.7% | | 1.00 | 0.0129 | 18.65 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 701.01 ± 1.7% | not timed | not timed | 64903.15 ± 2.5% | 39.12 ± 3.0% | not timed | not timed | 700.43 ± 2.9% | | 1.00 | 0.0108 | 17.92 |
| imported/sherlock/name-sherlock | 776 | 63173.88 ± 4.9% | not timed | not timed | 50844.32 ± 3.1% | 15893.95 ± 18.9% | not timed | not timed | 64222.26 ± 0.8% | | 0.98 | 1.24 | 3.97 |
| imported/sherlock/name-holmes | 2766 | 36743.90 ± 1.7% | not timed | not timed | 35297.75 ± 2.0% | 4934.69 ± 4.1% | not timed | not timed | 37084.16 ± 3.0% | | 0.99 | 1.04 | 7.45 |
| imported/sherlock/name-sherlock-holmes | 1365 | 62941.79 ± 6.0% | not timed | not timed | 51662.49 ± 1.2% | 13159.47 ± 3.7% | not timed | not timed | 65701.60 ± 6.3% | | 0.96 | 1.22 | 4.78 |
| imported/sherlock/name-sherlock-casei | 816 | 64903.90 ± 4.7% | not timed | not timed | 14261.63 ± 3.4% | 51.30 ± 1.3% | not timed | not timed | 65186.14 ± 3.6% | | 1.00 | 4.55 | 1265.21 |
| imported/sherlock/name-holmes-casei | 2802 | 31143.97 ± 13.2% | not timed | not timed | 8883.32 ± 2.2% | 63.43 ± 3.2% | not timed | not timed | 30963.33 ± 3.0% | | 1.01 | 3.51 | 491.02 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 51232.83 ± 4.4% | not timed | not timed | 13994.80 ± 2.0% | 51.15 ± 1.7% | not timed | not timed | 51607.80 ± 3.5% | | 0.99 | 3.66 | 1001.62 |
| imported/sherlock/name-whitespace | 1461 | 35978.98 ± 2.0% | not timed | not timed | 36874.22 ± 1.9% | 11395.22 ± 25.2% | not timed | not timed | 35700.95 ± 2.8% | | 1.01 | 0.98 | 3.16 |
| imported/sherlock/name-alt1 | 1142 | 40239.89 ± 2.9% | not timed | not timed | 43929.88 ± 1.5% | 6170.73 ± 37.0% | not timed | not timed | 40216.36 ± 2.7% | | 1.00 | 0.92 | 6.52 |
| imported/sherlock/name-alt2 | 3542 | 22455.98 ± 3.9% | not timed | not timed | 11983.34 ± 3.2% | 53.93 ± 4.0% | not timed | not timed | 22535.88 ± 5.0% | | 1.00 | 1.87 | 416.38 |
| imported/sherlock/name-alt3 | 4507 | 14350.57 ± 2.4% | not timed | not timed | 11149.67 ± 1.5% | 16.81 ± 2.1% | not timed | not timed | 14234.16 ± 8.5% | | 1.01 | 1.29 | 853.52 |
| imported/sherlock/name-alt3-casei | 4593 | 2400.35 ± 6.1% | not timed | not timed | 1644.90 ± 1.3% | 10.44 ± 4.8% | not timed | not timed | 2392.90 ± 11.2% | | 1.00 | 1.46 | 229.82 |
| imported/sherlock/name-alt4 | 3686 | 11221.64 ± 2.1% | not timed | not timed | 9270.79 ± 1.5% | 52.84 ± 0.9% | not timed | not timed | 11159.74 ± 0.2% | | 1.01 | 1.21 | 212.37 |
| imported/sherlock/name-alt4-casei | 4254 | 6575.70 ± 3.9% | not timed | not timed | 5082.45 ± 2.4% | 31.45 ± 2.8% | not timed | not timed | 6494.38 ± 3.3% | | 1.01 | 1.29 | 209.11 |
| imported/sherlock/name-alt5 | 4028 | 17865.21 ± 1.7% | not timed | not timed | 11417.51 ± 2.3% | 37.02 ± 2.8% | not timed | not timed | 17338.81 ± 23.3% | | 1.03 | 1.56 | 482.56 |
| imported/sherlock/name-alt5-casei | 4104 | 8241.06 ± 1.4% | not timed | not timed | 3698.01 ± 1.3% | 22.69 ± 2.3% | not timed | not timed | 8313.23 ± 0.9% | | 0.99 | 2.23 | 363.26 |
| imported/sherlock/no-match-uncommon | 0 | 89127.91 ± 0.3% | not timed | not timed | 88705.17 ± 31.5% | 75765.79 ± 22.7% | not timed | not timed | 88509.74 ± 2.3% | | 1.01 | 1.00 | 1.18 |
| imported/sherlock/no-match-common | 0 | 86822.99 ± 1.2% | not timed | not timed | 88500.67 ± 2.1% | 2283.44 ± 4.0% | not timed | not timed | 86368.37 ± 2.3% | | 1.01 | 0.98 | 38.02 |
| imported/sherlock/no-match-really-common | 0 | 60297.16 ± 1.3% | not timed | not timed | 65099.43 ± 6.9% | 2311.41 ± 9.6% | not timed | not timed | 60002.53 ± 4.1% | | 1.00 | 0.93 | 26.09 |
| imported/sherlock/the-lower | 21654 | 3887.51 ± 1.1% | not timed | not timed | 3880.71 ± 3.4% | 348.61 ± 7.9% | not timed | not timed | 3913.66 ± 1.0% | | 0.99 | 1.00 | 11.15 |
| imported/sherlock/the-upper | 2223 | 25977.64 ± 10.3% | not timed | not timed | 33039.53 ± 0.9% | 4306.56 ± 30.5% | not timed | not timed | 25956.53 ± 7.7% | | 1.00 | 0.79 | 6.03 |
| imported/sherlock/the-casei | 23961 | 3558.25 ± 5.3% | not timed | not timed | 1650.04 ± 1.5% | 58.81 ± 24.5% | not timed | not timed | 3595.53 ± 1.0% | | 0.99 | 2.16 | 60.50 |
| imported/sherlock/everything-greedy | 581881 | 342.27 ± 1.9% | not timed | not timed | 219.14 ± 2.0% | 42.05 ± 47.8% | not timed | not timed | 341.78 ± 1.5% | | 1.00 | 1.56 | 8.14 |
| imported/sherlock/everything-greedy-nl | 594933 | 559.89 ± 1.0% | not timed | not timed | 291.99 ± 3.7% | 49.80 ± 3.9% | not timed | not timed | 558.58 ± 1.8% | | 1.00 | 1.92 | 11.24 |
| imported/sherlock/letters | 447175 | 71.05 ± 7.9% | not timed | not timed | 43.66 ± 2.0% | 8.35 ± 18.9% | not timed | not timed | 67.35 ± 9.3% | | 1.05 | 1.63 | 8.51 |
| imported/sherlock/letters-upper | 14180 | 509.47 ± 5.3% | not timed | not timed | 440.34 ± 3.1% | 41.14 ± 29.1% | not timed | not timed | 507.39 ± 3.4% | | 1.00 | 1.16 | 12.38 |
| imported/sherlock/letters-lower | 432995 | 74.76 ± 3.0% | not timed | not timed | 46.28 ± 3.4% | 9.46 ± 34.1% | not timed | not timed | 70.30 ± 3.3% | | 1.06 | 1.62 | 7.90 |
| imported/sherlock/words | 447639 | 122.13 ± 9.7% | not timed | not timed | 102.19 ± 4.5% | 19.97 ± 11.8% | not timed | not timed | 120.49 ± 5.6% | | 1.01 | 1.20 | 6.12 |
| imported/sherlock/before-holmes | 4073 | 703.39 ± 1.2% | not timed | not timed | 16307.79 ± 1.8% | 37.15 ± 0.9% | not timed | not timed | 702.28 ± 1.3% | | 1.00 | 0.0431 | 18.93 |
| imported/sherlock/before-after-holmes | 2593 | 694.64 ± 2.4% | not timed | not timed | 18896.05 ± 1.7% | 35.60 ± 32.2% | not timed | not timed | 689.29 ± 2.7% | | 1.01 | 0.0368 | 19.51 |
| imported/sherlock/holmes-cochar-watson | 150 | 11875.64 ± 13.5% | not timed | not timed | 9550.20 ± 2.5% | 52.11 ± 1.4% | not timed | not timed | 11827.65 ± 39.5% | | 1.00 | 1.24 | 227.88 |
| imported/sherlock/holmes-coword-watson | 14309 | 1491.71 ± 2.0% | not timed | not timed | 1462.09 ± 2.2% | 10.95 ± 1.4% | not timed | not timed | 1494.09 ± 1.7% | | 1.00 | 1.02 | 136.28 |
| imported/sherlock/quotes | 14437 | 1625.22 ± 63.0% | not timed | not timed | 2777.65 ± 2.1% | 52.66 ± 1.4% | not timed | not timed | 1645.59 ± 18.4% | | 0.99 | 0.59 | 30.86 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 712.65 ± 0.6% | not timed | not timed | 40937.20 ± 1.9% | 60.01 ± 1.5% | not timed | not timed | 712.80 ± 1.5% | | 1.00 | 0.0174 | 11.88 |
| imported/sherlock/word-ending-n | 35297 | 536.35 ± 2.7% | not timed | not timed | 482.02 ± 5.1% | 33.26 ± 39.5% | not timed | not timed | 532.68 ± 61.6% | | 1.01 | 1.11 | 16.13 |
| imported/sherlock/repeated-class-negation | 2130 | 24045.90 ± 2.1% | not timed | not timed | 23157.05 ± 1.2% | 15.26 ± 2.2% | not timed | not timed | 24090.91 ± 0.6% | | 1.00 | 1.04 | 1576.05 |
| imported/sherlock/ing-suffix | 20547 | 663.28 ± 2.7% | not timed | not timed | 606.17 ± 0.7% | 44.05 ± 1.3% | not timed | not timed | 662.24 ± 0.8% | | 1.00 | 1.09 | 15.06 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 691.23 ± 20.3% | not timed | not timed | 3623.18 ± 1.5% | 31.52 ± 20.4% | not timed | not timed | 699.37 ± 1.2% | | 0.99 | 0.19 | 21.93 |
| opt/accelerate/whole-line | 239963 | 642.72 ± 26.4% | not timed | not timed | 497.03 ± 26.2% | 126.82 ± 21.4% | not timed | not timed | 647.03 ± 5.9% | | 0.99 | 1.29 | 5.07 |
| opt/accelerate/non-dna | 16745 | 548.50 ± 4.8% | not timed | not timed | 559.69 ± 0.7% | 45.51 ± 24.0% | not timed | not timed | 554.22 ± 1.8% | | 0.99 | 0.98 | 12.05 |
| opt/backtrack/words-english | 40536 | 187.74 ± 4.1% | not timed | not timed | 140.16 ± 11.5% | 31.25 ± 10.7% | not timed | not timed | 186.62 ± 19.7% | | 1.01 | 1.34 | 6.01 |
| opt/fixed-length/too-small-ascii | 0 | 530.57 ± 4.1% | not timed | not timed | 1087.44 ± 20.0% | 163.16 ± 3.4% | not timed | not timed | 532.49 ± 15.9% | | 1.00 | 0.49 | 3.25 |
| opt/fixed-length/too-big-ascii | 0 | 1077.84 ± 4.8% | not timed | not timed | 8313.94 ± 27.6% | 205.53 ± 60.7% | not timed | not timed | 1018.56 ± 2.8% | | 1.06 | 0.13 | 5.24 |
| opt/fixed-length/go33484-1 | 0 | 87.47 ± 2.1% | not timed | not timed | 1687305.83 ± 1.6% | 120240.61 ± 1.9% | not timed | not timed | 73.71 ± 0.6% | | 1.19 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 6680.86 ± 2.7% | not timed | not timed | 1668818.69 ± 28.7% | 43688.93 ± 4.6% | not timed | not timed | 6639.64 ± 1.1% | | 1.01 | 0.0040 | 0.15 |
| opt/fixed-length/go33484-3 | 0 | 2197.88 ± 1.2% | not timed | not timed | 164876.36 ± 27.9% | 1215.51 ± 1.4% | not timed | not timed | 2165.65 ± 1.4% | | 1.01 | 0.0133 | 1.81 |
| opt/literal-alt/one-pattern | 1 | 702.04 ± 4.1% | not timed | not timed | 703.37 ± 2.8% | 0.62 ± 25.6% | not timed | not timed | 693.72 ± 1.2% | | 1.01 | 1.00 | 1129.45 |
| opt/onepass/fn-predicate | 916 | 586.24 ± 1.5% | not timed | not timed | 514.24 ± 1.8% | 275.41 ± 16.6% | not timed | not timed | 580.41 ± 15.2% | | 1.01 | 1.14 | 2.13 |
| opt/onepass/first-three-words-english | 35128 | 207.49 ± 4.3% | not timed | not timed | 296.05 ± 61.2% | 109.95 ± 10.2% | not timed | not timed | 206.44 ± 22.1% | | 1.01 | 0.70 | 1.89 |
| opt/prefilter/literal-english | 1 | 88662.19 ± 2.6% | not timed | not timed | 67016.35 ± 15.8% | 34503.89 ± 4.2% | not timed | not timed | 88193.14 ± 1.8% | | 1.01 | 1.32 | 2.57 |
| opt/prefilter/literal-casei-english | 1 | 66659.86 ± 49.7% | not timed | not timed | 17726.65 ± 1.5% | 51.53 ± 12.7% | not timed | not timed | 66215.84 ± 3.0% | | 1.01 | 3.76 | 1293.62 |
| opt/prefilter/literal-russian | 1 | 87900.16 ± 1.3% | not timed | not timed | 66751.17 ± 1.7% | 3995.99 ± 10.9% | not timed | not timed | 87952.45 ± 2.4% | | 1.00 | 1.32 | 22.00 |
| opt/prefilter/literal-casei-russian | 1 | 35427.53 ± 2.4% | not timed | not timed | 12671.15 ± 0.7% | 54.57 ± 2.2% | not timed | not timed | 35335.04 ± 1.2% | | 1.00 | 2.80 | 649.23 |
| opt/prefilter/rust-functions | 948 | 19028.21 ± 8.9% | not timed | not timed | 15946.63 ± 1.3% | 2349.18 ± 15.2% | not timed | not timed | 19162.28 ± 50.5% | | 0.99 | 1.19 | 8.10 |
| opt/reverse-anchored/word-end | 1 | 6607.20 ± 2.4% | not timed | not timed | 32256106.68 ± 3.3% | 81.15 ± 3.8% | not timed | not timed | 6572.63 ± 3.9% | | 1.01 | 0.0002 | 81.42 |
| opt/reverse-inner/holmes | 2593 | 690.73 ± 0.8% | not timed | not timed | 18763.42 ± 1.8% | 35.46 ± 24.9% | not timed | not timed | 692.91 ± 1.2% | | 1.00 | 0.0368 | 19.48 |
| opt/reverse-inner/email | 47 | 1200.95 ± 1.2% | not timed | not timed | 102503.72 ± 46.5% | 47.49 ± 1.6% | not timed | not timed | 1197.29 ± 31.1% | | 1.00 | 0.0117 | 25.29 |
| opt/reverse-inner/factored-prefix | 3542 | 686.85 ± 1.4% | not timed | not timed | 682.59 ± 2.3% | 19.48 ± 17.0% | not timed | not timed | 686.64 ± 1.1% | | 1.00 | 1.01 | 35.26 |
| opt/reverse-inner/no-quadratic-backward | 0 | 6138.68 ± 69.8% | not timed | not timed | 643.23 ± 112.5% | 94.61 ± 182.5% | not timed | not timed | 6543.34 ± 52.4% | | 0.94 | 9.54 | 64.88 |
| opt/reverse-inner/no-quadratic-forward | 0 | 811.58 ± 4.9% | not timed | not timed | 324.05 ± 4.7% | 37.88 ± 2.2% | not timed | not timed | 810.74 ± 2.0% | | 1.00 | 2.50 | 21.42 |
| opt/reverse-suffix/holmes | 4073 | 692.40 ± 1.8% | not timed | not timed | 16331.03 ± 1.5% | 36.64 ± 0.9% | not timed | not timed | 695.18 ± 0.9% | | 1.00 | 0.0424 | 18.90 |
| opt/reverse-suffix/no-quadratic | 0 | 6579.12 ± 0.3% | not timed | not timed | 696.94 ± 0.8% | 115.59 ± 25.1% | not timed | not timed | 6556.99 ± 1.5% | | 1.00 | 9.44 | 56.92 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 210.47 ± 7.9% | not timed | not timed | 251.57 ± 4.7% | 23.60 ± 6.7% | not timed | not timed | 205.08 ± 10.4% | | 1.03 | 0.84 | 8.92 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 207.41 ± 65.9% | not timed | not timed | 268.52 ± 2.2% | 23.35 ± 8.1% | not timed | not timed | 207.47 ± 69.2% | | 1.00 | 0.77 | 8.88 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.47 ± 4.2% | not timed | not timed | 0.80 ± 2.5% | 168.99 ± 4.8% | not timed | not timed | 0.47 ± 7.1% | | 1.00 | 0.58 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 361.15 ± 7.4% | not timed | not timed | 352.98 ± 4.7% | 155.14 ± 15.2% | not timed | not timed | 365.23 ± 5.8% | | 0.99 | 1.02 | 2.33 |
| reported/i13-subset-regex/original-ascii | 4094 | 14702.67 ± 3.8% | not timed | not timed | 5278.17 ± 4.6% | 14.96 ± 3.9% | not timed | not timed | 14757.29 ± 3.1% | | 1.00 | 2.79 | 982.68 |
| reported/i13-subset-regex/original-unicode | 4094 | 14882.81 ± 1.0% | not timed | not timed | 276.82 ± 10.7% | 15.07 ± 2.0% | not timed | not timed | 14901.14 ± 63.0% | | 1.00 | 53.76 | 987.85 |
| reported/i13-subset-regex/big-ascii | 1955 | 13840.89 ± 2.1% | not timed | not timed | 79.74 ± 3.9% | 13.20 ± 3.8% | not timed | not timed | 13819.60 ± 2.1% | | 1.00 | 173.57 | 1048.35 |
| reported/i13-subset-regex/big-unicode | 1955 | 13837.38 ± 2.8% | not timed | not timed | 13.81 ± 56.0% | 13.17 ± 4.9% | not timed | not timed | 13833.08 ± 5.1% | | 1.00 | 1002.20 | 1050.75 |
| reported/i13-subset-regex/huge-ascii | 55 | 12898.45 ± 4.4% | not timed | not timed | 12.45 ± 4.8% | 12.35 ± 5.8% | not timed | not timed | 12789.37 ± 1.3% | | 1.01 | 1035.88 | 1044.47 |
| reported/i13-subset-regex/huge-unicode | 55 | 12847.39 ± 4.6% | not timed | not timed | 13.33 ± 6.0% | 12.29 ± 7.6% | not timed | not timed | 12737.11 ± 2.3% | | 1.01 | 963.58 | 1045.47 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.60 ± 2.9% | not timed | not timed | 12.91 ± 4.7% | 11.93 ± 6.6% | not timed | not timed | 5.64 ± 4.1% | | 0.99 | 0.43 | 0.47 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.41 ± 3.8% | not timed | not timed | 13.25 ± 2.2% | 11.92 ± 6.3% | not timed | not timed | 7.45 ± 3.6% | | 0.99 | 0.56 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 576.10 ± 2.9% | not timed | not timed | 210.47 ± 1.9% | 10.21 ± 3.6% | not timed | not timed | 573.85 ± 5.2% | | 1.00 | 2.74 | 56.40 |
| reported/i787-keywords/opt-ascii | 5674 | 573.99 ± 9.9% | not timed | not timed | 332.75 ± 6.3% | 16.99 ± 6.4% | not timed | not timed | 575.35 ± 2.6% | | 1.00 | 1.73 | 33.79 |
| slow/quadratic-regex-1x | 100 | 10.77 ± 11.0% | not timed | not timed | 8.47 ± 4.0% | 0.08 ± 11.2% | not timed | not timed | 10.86 ± 60.2% | | 0.99 | 1.27 | 137.19 |
| slow/quadratic-regex-2x | 199 | 4.50 ± 2.0% | not timed | not timed | 3.91 ± 1.5% | 0.02 ± 1.8% | not timed | not timed | 4.48 ± 1.2% | | 1.01 | 1.15 | 224.76 |
| slow/quadratic-haystack-1x | 100 | 38.81 ± 45.4% | not timed | not timed | 16.48 ± 6.9% | 1.39 ± 57.6% | not timed | not timed | 37.95 ± 78.3% | | 1.02 | 2.35 | 27.89 |
| slow/quadratic-haystack-2x | 200 | 31.16 ± 1.4% | not timed | not timed | 7.89 ± 12.9% | 0.76 ± 44.3% | not timed | not timed | 31.35 ± 10.4% | | 0.99 | 3.95 | 40.88 |
| unicode/codepoints/any-one | 1112064 | 499.17 ± 4.5% | not timed | not timed | 340.50 ± 6.8% | 25.43 ± 27.6% | not timed | not timed | 494.61 ± 56.2% | | 1.01 | 1.47 | 19.63 |
| unicode/codepoints/any-all | 4382592 | 333.99 ± 1.2% | not timed | not timed | 333.09 ± 3.1% | 190.47 ± 2.8% | not timed | not timed | 333.73 ± 2.9% | | 1.00 | 1.00 | 1.75 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.56 ± 3.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 712.45 ± 1.9% | not timed | not timed | 710.16 ± 5.8% | 221.88 ± 5.3% | not timed | not timed | 712.69 ± 4.5% | | 1.00 | 1.00 | 3.21 |
| unicode/overlapping-words/ascii | 6156 | 44.24 ± 1.6% | not timed | not timed | 56.19 ± 1.8% | 6.10 ± 4.7% | not timed | not timed | 44.15 ± 2.9% | | 1.00 | 0.79 | 7.25 |
| unicode/overlapping-words/english | 6156 | 2.07 ± 30.4% | not timed | not timed | 5.23 ± 1.4% | 3.63 ± 6.8% | not timed | not timed | 2.15 ± 22.3% | | 0.96 | 0.40 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.84 ± 6.6% | not timed | not timed | 4.86 ± 0.6% | 9.18 ± 26.3% | not timed | not timed | 1.93 ± 1.0% | | 0.95 | 0.38 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 135.85 ± 1.2% | not timed | not timed | 105.50 ± 1.0% | 17.24 ± 11.5% | not timed | not timed | 132.81 ± 0.9% | | 1.02 | 1.29 | 7.88 |
| unicode/word/boundary-long-english | 3466 | 708.03 ± 25.8% | not timed | not timed | 690.30 ± 2.1% | 40.34 ± 30.8% | not timed | not timed | 706.90 ± 1.3% | | 1.00 | 1.03 | 17.55 |
| unicode/word/around-holmes-english | 27 | 710.84 ± 4.5% | not timed | not timed | 64829.03 ± 3.9% | 32.97 ± 2.9% | not timed | not timed | 714.05 ± 2.4% | | 1.00 | 0.0110 | 21.56 |
| wild/bibleref/long | 874 | 672.27 ± 1.2% | not timed | not timed | 679.35 ± 0.9% | 10.47 ± 1.6% | not timed | not timed | 671.95 ± 2.0% | | 1.00 | 0.99 | 64.22 |
| wild/bibleref/short | 30 | 35.25 ± 6.0% | not timed | not timed | 44.66 ± 1.1% | 23.20 ± 22.2% | not timed | not timed | 35.24 ± 27.2% | | 1.00 | 0.79 | 1.52 |
| wild/bibleref/line | 874 | 656.02 ± 2.7% | not timed | not timed | 329.30 ± 3.0% | 13.14 ± 5.6% | not timed | not timed | 649.35 ± 1.7% | | 1.01 | 1.99 | 49.92 |
| wild/caddy/caddy | 6 | 608.22 ± 18.0% | not timed | not timed | 345.18 ± 39.3% | 100.17 ± 60.8% | not timed | not timed | 602.78 ± 11.1% | | 1.01 | 1.76 | 6.07 |
| wild/dot-star-capture/rust-src-tools | 6 | 2021.71 ± 1.3% | not timed | not timed | 462.06 ± 3.1% | 22.34 ± 15.5% | not timed | not timed | 2025.08 ± 6.5% | | 1.00 | 4.38 | 90.48 |
| wild/ruff/noqa | 84 | 629.03 ± 18.3% | not timed | not timed | 660.01 ± 4.4% | 28.05 ± 3.9% | not timed | not timed | 620.41 ± 27.7% | | 1.01 | 0.95 | 22.43 |
| wild/ruff/unnecessary-coding-comment | 16 | 704.63 ± 3.6% | not timed | not timed | 864.68 ± 2.3% | 192.27 ± 15.8% | not timed | not timed | 711.51 ± 3.0% | | 0.99 | 0.81 | 3.66 |
| wild/ruff/string-quote-prefix | 2972 | 652.90 ± 3.7% | not timed | not timed | 670.29 ± 1.4% | 500.78 ± 35.0% | not timed | not timed | 642.30 ± 3.0% | | 1.02 | 0.97 | 1.30 |
| wild/ruff/space-around-operator | 1224378 | 297.61 ± 27.2% | not timed | not timed | 272.60 ± 27.7% | 25.75 ± 2.1% | not timed | not timed | 301.00 ± 10.3% | | 0.99 | 1.09 | 11.56 |
| wild/ruff/shebang | 282 | 649.85 ± 2.7% | not timed | not timed | 520.98 ± 12.2% | 170.00 ± 14.3% | not timed | not timed | 636.92 ± 5.7% | | 1.02 | 1.25 | 3.82 |
| wild/rustsec-cargo-audit/original-unix | 471 | 28894.61 ± 3.2% | not timed | not timed | 31456.88 ± 59.5% | 11922.06 ± 12.3% | not timed | not timed | 28503.45 ± 27.6% | | 1.01 | 0.92 | 2.42 |
| wild/rustsec-cargo-audit/original-windows | 462 | 27219.92 ± 8.4% | not timed | not timed | 29990.13 ± 63.9% | 11150.57 ± 42.1% | not timed | not timed | 27199.14 ± 1.2% | | 1.00 | 0.91 | 2.44 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 29643.27 ± 26.4% | not timed | not timed | 31121.43 ± 13.0% | 11580.82 ± 28.0% | not timed | not timed | 29578.98 ± 30.6% | | 1.00 | 0.95 | 2.56 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 25206.57 ± 133.7% | not timed | not timed | 31484.73 ± 29.6% | 11736.79 ± 97.3% | not timed | not timed | 25439.52 ± 44.5% | | 0.99 | 0.80 | 2.15 |
| wild/url/search | 234965 | 160.86 ± 13.6% | not timed | not timed | 78.85 ± 45.2% | 3.44 ± 4.4% | not timed | not timed | 163.64 ± 9.1% | | 0.98 | 2.04 | 46.70 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 22.2% | not timed | not timed | 0.01 ± 1.2% | 0.01 ± 20.2% | not timed | not timed | 0.04 ± 12.1% | | 0.99 | 2.98 | 4.43 |
| dictionary/compile/english-15 | 1 | 0.42 ± 11.7% | not timed | not timed | 0.11 ± 4.4% | 0.15 ± 24.0% | not timed | not timed | 0.44 ± 9.5% | | 0.94 | 3.97 | 2.73 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.41 ± 7.1% | not timed | not timed | 0.03 ± 5.6% | 47.76 ± 20.9% | not timed | not timed | 0.41 ± 19.6% | | 1.00 | 14.06 | 0.0086 |
| reported/i1095-word-repetition/ascii-compile | 1 | 57.08 ± 5.8% | not timed | not timed | 18.86 ± 2.1% | 75.69 ± 21.1% | not timed | not timed | 56.72 ± 8.4% | | 1.01 | 3.03 | 0.75 |
| reported/i787-keywords/compile | 1 | 53.59 ± 5.8% | not timed | not timed | 3.09 ± 2.2% | 23.33 ± 23.5% | not timed | not timed | 53.45 ± 6.7% | | 1.00 | 17.35 | 2.30 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 568.55 ± 8.2% | not timed | not timed | 187.75 ± 6.1% | 786.69 ± 2.7% | not timed | not timed | 585.91 ± 11.6% | | 0.97 | 3.03 | 0.72 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 72.66 ± 13.5% | not timed | not timed | 7.14 ± 1.2% | 61.89 ± 12.7% | not timed | not timed | 75.87 ± 12.7% | | 0.96 | 10.18 | 1.17 |
| unicode/compile/one-letter | 53 | 10.01 ± 9.1% | not timed | not timed | 7.61 ± 3.9% | 79.95 ± 12.1% | not timed | not timed | 10.14 ± 7.7% | | 0.99 | 1.32 | 0.13 |
| unicode/compile/fifty-letters | 1 | 1.75 ± 8.4% | not timed | not timed | 0.16 ± 71.5% | 74.32 ± 31.5% | not timed | not timed | 1.79 ± 4.0% | | 0.98 | 10.69 | 0.0236 |
| unicode/compile/fifty-letters-ascii | 1 | 291.64 ± 11.2% | not timed | not timed | 81.30 ± 1.0% | 259.39 ± 14.7% | not timed | not timed | 300.78 ± 1.8% | | 0.97 | 3.59 | 1.12 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 640.14 ± 55.9% | not timed | not timed | 60.92 ± 9.9% | 924.10 ± 4.2% | not timed | not timed | 608.13 ± 52.5% | | 1.05 | 10.51 | 0.69 |
| unicode/compile/match-every-line-ascii | 4 | 1067.56 ± 12.2% | not timed | not timed | 220.30 ± 0.9% | 914.38 ± 9.7% | not timed | not timed | 1091.90 ± 15.7% | | 0.98 | 4.85 | 1.17 |
| unicode/compile/negated-class-matches-codepoint | 1 | 512.96 ± 7.6% | not timed | not timed | 64.49 ± 2.9% | 1730.82 ± 4.1% | not timed | not timed | 511.78 ± 18.3% | | 1.00 | 7.95 | 0.30 |
| wild/bibleref/compile | 3 | 8.77 ± 13.5% | not timed | not timed | 3.18 ± 5.5% | 41.79 ± 14.6% | not timed | not timed | 8.98 ± 13.0% | | 0.98 | 2.76 | 0.21 |
| wild/url/compile | 1 | 0.94 ± 11.4% | not timed | not timed | 0.22 ± 43.6% | 0.60 ± 38.9% | not timed | not timed | 1.01 ± 20.0% | | 0.93 | 4.26 | 1.58 |

