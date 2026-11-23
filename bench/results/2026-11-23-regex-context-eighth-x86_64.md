# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117667981 |
| Date | 2026-11-23 |
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
| literal: a word | 217 | 40748.42 ± 0.6% | 1029.58 ± 0.2% | 30.53 ± 0.6% | 38743.51 ± 0.9% | 12370.52 ± 3.4% | 12.94 ± 0.5% | 104.52 ± 0.6% | 40804.73 ± 0.5% | 39.58 | 1.00 | 1.05 | 3.29 |
| literal: a word that is not there | 0 | 56680.11 ± 2.3% | 1039.08 ± 0.2% | 30.46 ± 0.6% | 45414.50 ± 5.8% | 43609.73 ± 1.3% | 12.79 ± 0.3% | 98.29 ± 0.4% | 56750.00 ± 1.2% | 54.55 | 1.00 | 1.25 | 1.30 |
| literal: one of four words | 661 | 13727.83 ± 0.2% | 1005.66 ± 0.3% | 16.83 ± 0.2% | 11134.52 ± 0.2% | 24.91 ± 0.2% | 4.47 ± 0.1% | 8.26 ± 0.9% | 13835.09 ± 1.1% | 13.65 | 0.99 | 1.23 | 551.04 |
| literal: a word in any case | 217 | 36500.86 ± 0.3% | 1027.24 ± 0.3% | 22.74 ± 0.5% | 11351.52 ± 0.4% | 47.15 ± 1.4% | refused | differs | 36402.74 ± 0.6% | 35.53 | 1.00 | 3.22 | 774.12 |
| literal: an href attribute | 33 | 34966.31 ± 0.8% | 1034.61 ± 0.2% | 29.19 ± 1.1% | 35000.53 ± 1.2% | 2937.03 ± 7.8% | 9.68 ± 0.2% | 91.40 ± 0.3% | 35131.84 ± 0.6% | 33.80 | 1.00 | 1.00 | 11.91 |
| literal: a word, second text | 123 | 44594.72 ± 0.7% | 1030.88 ± 0.4% | 29.95 ± 0.4% | 39396.51 ± 0.7% | 11289.05 ± 3.8% | 14.48 ± 1.1% | 87.39 ± 0.3% | 44434.02 ± 0.8% | 43.26 | 1.00 | 1.13 | 3.95 |
| class: two capitalized words | 1331 | 902.36 ± 0.3% | 948.97 ± 0.4% | 28.39 ± 0.6% | 576.41 ± 0.4% | 44.30 ± 10.1% | 11.05 ± 0.2% | 79.12 ± 0.4% | 901.29 ± 0.3% | 0.95 | 1.00 | 1.57 | 20.37 |
| class: a word that ends in ing | 3399 | 869.66 ± 0.1% | 870.04 ± 0.5% | 20.00 ± 0.5% | 539.14 ± 0.3% | 32.40 ± 11.3% | 6.23 ± 0.1% | 20.77 ± 9.0% | 867.33 ± 0.3% | 1.00 | 1.00 | 1.61 | 26.84 |
| class: a word in capitals | 2332 | 1153.62 ± 0.3% | 930.75 ± 0.6% | 29.88 ± 5.7% | 565.90 ± 0.5% | 47.35 ± 9.5% | 12.49 ± 0.7% | 100.65 ± 1.9% | 1154.35 ± 0.1% | 1.24 | 1.00 | 2.04 | 24.36 |
| class: a number | 8288 | 1720.96 ± 0.3% | 785.63 ± 0.2% | 30.04 ± 0.4% | 1771.54 ± 0.5% | 44.75 ± 11.4% | 0.39 ± 0.4% | 70.04 ± 0.7% | 1717.80 ± 0.3% | 2.19 | 1.00 | 0.97 | 38.46 |
| class: two capitalized words, second text | 5359 | 686.49 ± 0.2% | 685.98 ± 0.3% | 25.70 ± 0.3% | 478.99 ± 0.3% | 37.03 ± 14.3% | 12.69 ± 0.2% | 72.82 ± 0.1% | 676.71 ± 0.2% | 1.00 | 1.01 | 1.43 | 18.54 |
| other: a word between two words | 6104 | 774.92 ± 0.4% | 732.31 ± 0.1% | 25.52 ± 0.1% | 813.93 ± 0.6% | 125.40 ± 13.0% | 8.54 ± 0.2% | 81.15 ± 0.6% | 778.96 ± 0.3% | 1.06 | 0.99 | 0.95 | 6.18 |
| other: a number before a unit, second text | 1481 | 9365.78 ± 0.5% | 976.81 ± 0.3% | 28.23 ± 0.5% | 8300.48 ± 0.4% | 45.34 ± 17.2% | 13.29 ± 0.3% | 76.75 ± 0.2% | 9356.29 ± 0.2% | 9.59 | 1.00 | 1.13 | 206.58 |
| other: a heading's start tag | 110 | 24393.40 ± 0.3% | 1025.80 ± 0.2% | 29.92 ± 0.2% | 2502.33 ± 3.0% | 2025.27 ± 2.5% | 11.83 ± 0.4% | 107.02 ± 0.2% | 24428.45 ± 0.3% | 23.78 | 1.00 | 9.75 | 12.04 |
| other: a whole word | 217 | 29231.71 ± 0.3% | 1027.85 ± 0.3% | 30.37 ± 0.9% | 28180.56 ± 0.2% | 54.33 ± 0.8% | 11.22 ± 0.2% | 62.56 ± 0.2% | 29135.07 ± 0.2% | 28.44 | 1.00 | 1.04 | 538.04 |
| other: a line's first word, second text | 3716 | 2334.09 ± 1.4% | 844.38 ± 0.2% | 32.35 ± 1.4% | 2330.09 ± 1.3% | 70.96 ± 4.0% | refused | refused | 2305.43 ± 1.6% | 2.76 | 1.01 | 1.00 | 32.89 |
| other: fourteen octets before an x | 87 | 35359.59 ± 9.1% | 249.53 ± 0.4% | 7.12 ± 0.6% | 3422.79 ± 0.4% | 11.60 ± 0.7% | differs | 20.19 ± 2.5% | 35371.72 ± 0.5% | 141.70 | 1.00 | 10.33 | 3047.47 |
| other: a Greek word | 21815 | 483.25 ± 1.1% | 322.70 ± 0.2% | 33.46 ± 8.5% | 299.31 ± 0.3% | 54.47 ± 24.6% | differs | refused | 483.82 ± 0.5% | 1.50 | 1.00 | 1.61 | 8.87 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.76 ± 0.6% | 28.39 ± 0.4% | 1.00 ± 0.2% | 19.90 ± 0.3% | 2.12 ± 12.5% | differs | 4.16 ± 1.1% | 28.79 ± 0.6% | 1.01 | 1.00 | 1.45 | 13.57 |
| a UUID | 32895 | 24.19 ± 0.4% | 24.21 ± 0.2% | 0.73 ± 0.8% | 15.11 ± 10.2% | 3.02 ± 2.5% | 0.52 ± 0.2% | 3.71 ± 0.7% | 23.98 ± 0.8% | 1.00 | 1.01 | 1.60 | 8.01 |
| an IPv4 address | 33176 | 40.10 ± 1.0% | 40.07 ± 0.6% | 2.33 ± 2.9% | 28.49 ± 0.1% | 6.96 ± 1.7% | differs | 4.16 ± 1.5% | 40.04 ± 0.9% | 1.00 | 1.00 | 1.41 | 5.76 |
| a date and time | 32954 | 36.46 ± 0.7% | 36.08 ± 0.8% | 1.74 ± 0.9% | 21.71 ± 0.2% | 8.04 ± 2.1% | 0.92 ± 0.4% | 7.15 ± 11.0% | 36.49 ± 0.1% | 1.01 | 1.00 | 1.68 | 4.53 |
| a field path | 32606 | 31.96 ± 6.7% | 31.73 ± 2.9% | 1.14 ± 0.5% | 23.02 ± 0.2% | 3.51 ± 1.4% | differs | 2.96 ± 0.5% | 31.58 ± 0.2% | 1.01 | 1.01 | 1.39 | 9.11 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.98 ± 0.6% | 11.02 ± 0.9% | 10.98 ± 0.7% | 13.48 ± 0.8% | 5.79 ± 2.5% | 0.76 ± 8.9% | none | 11.00 ± 0.2% | 1.00 | 1.00 | 0.81 | 1.90 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.17 ± 0.2% | 239.29 ± 0.3% | 281.10 ± 4.5% | 98.00 ± 6.9% | 243.58 ± 13.4% | 705.45 ± 4.4% | 4896.71 ± 1.3% | 238.18 ± 0.5% | 1.00 | 1.00 | 2.43 | 0.98 |
| a UUID | 62 | 154.65 ± 0.8% | 155.15 ± 8.5% | 173.80 ± 0.4% | 56.99 ± 2.5% | 118.15 ± 1.4% | 254.02 ± 3.1% | 5404.84 ± 0.5% | 153.38 ± 3.6% | 1.00 | 1.01 | 2.71 | 1.31 |
| an IPv4 address | 29 | 499.10 ± 2.1% | 503.74 ± 0.3% | 737.68 ± 0.5% | 87.48 ± 12.9% | 148.24 ± 24.2% | 408.61 ± 1.1% | 9025.79 ± 0.6% | 499.56 ± 0.4% | 0.99 | 1.00 | 5.71 | 3.37 |
| a date and time | 56 | 369.77 ± 0.5% | 372.56 ± 3.8% | 483.61 ± 5.5% | 85.32 ± 1.1% | 159.62 ± 13.2% | 471.11 ± 2.8% | 5553.04 ± 0.8% | 369.88 ± 7.8% | 0.99 | 1.00 | 4.33 | 2.32 |
| a field path | 39 | 228.91 ± 0.1% | 230.01 ± 0.5% | 267.87 ± 0.3% | 91.62 ± 2.0% | 230.19 ± 0.7% | 730.10 ± 16.8% | 5957.09 ± 1.1% | 228.96 ± 0.3% | 1.00 | 1.00 | 2.50 | 0.99 |
| literal: a word | 7 | 741.50 ± 13.6% | 787.31 ± 0.5% | 1491.01 ± 1.5% | 613.85 ± 1.8% | 798.16 ± 0.9% | 1586.17 ± 5.7% | 34165.25 ± 1.1% | 740.81 ± 0.4% | 0.94 | 1.00 | 1.21 | 0.93 |
| literal: a word that is not there | 8 | 713.46 ± 0.1% | 763.84 ± 0.2% | 1405.73 ± 0.2% | 551.01 ± 0.9% | 762.36 ± 1.1% | 1495.08 ± 0.2% | 33458.03 ± 0.4% | 713.30 ± 0.5% | 0.93 | 1.00 | 1.29 | 0.94 |
| literal: one of four words | 26 | 257.03 ± 0.6% | 462.92 ± 0.2% | 643.95 ± 0.4% | 53.62 ± 8.8% | 293.53 ± 8.7% | 581.01 ± 13.2% | 18358.70 ± 0.2% | 257.44 ± 0.4% | 0.56 | 1.00 | 4.79 | 0.88 |
| literal: a word in any case | 11 | 582.82 ± 0.4% | 621.19 ± 0.4% | 998.11 ± 0.2% | 18.38 ± 0.6% | 834.28 ± 1.8% | refused | 24654.13 ± 7.1% | 578.33 ± 2.9% | 0.94 | 1.01 | 31.71 | 0.70 |
| literal: an href attribute | 12 | 403.93 ± 9.1% | 417.76 ± 0.2% | 566.28 ± 1.1% | 50.89 ± 1.2% | 572.57 ± 3.8% | 1228.37 ± 0.8% | 24658.37 ± 1.0% | 404.02 ± 0.5% | 0.97 | 1.00 | 7.94 | 0.71 |
| literal: a word, second text | 10 | 661.40 ± 0.3% | 716.18 ± 0.3% | 1256.81 ± 1.7% | 499.90 ± 0.7% | 660.26 ± 2.2% | 1285.18 ± 1.0% | 31948.11 ± 0.7% | 660.45 ± 0.3% | 0.92 | 1.00 | 1.32 | 1.00 |
| class: two capitalized words | 23 | 523.42 ± 0.3% | 565.94 ± 0.3% | 855.13 ± 0.7% | 122.02 ± 8.2% | 597.98 ± 1.8% | 1244.38 ± 0.7% | 7930.26 ± 0.2% | 523.31 ± 0.2% | 0.92 | 1.00 | 4.29 | 0.88 |
| class: a word that ends in ing | 9 | 640.41 ± 0.2% | 723.63 ± 0.5% | 1341.60 ± 0.9% | 144.19 ± 0.7% | 864.93 ± 1.2% | 1727.98 ± 0.4% | 19308.97 ± 0.7% | 640.74 ± 0.5% | 0.88 | 1.00 | 4.44 | 0.74 |
| class: a word in capitals | 16 | 564.46 ± 1.0% | 614.16 ± 0.4% | 1046.89 ± 0.6% | 154.94 ± 1.2% | 884.32 ± 2.3% | 1696.06 ± 1.2% | 10569.40 ± 1.7% | 564.52 ± 0.8% | 0.92 | 1.00 | 3.64 | 0.64 |
| class: a number | 6 | 693.93 ± 0.3% | 773.65 ± 0.2% | 1539.22 ± 0.2% | 47.11 ± 0.6% | 1634.41 ± 2.3% | 2822.85 ± 3.6% | 25900.52 ± 0.5% | 693.86 ± 0.5% | 0.90 | 1.00 | 14.73 | 0.42 |
| class: two capitalized words, second text | 23 | 523.77 ± 0.2% | 567.02 ± 0.2% | 856.66 ± 0.2% | 120.57 ± 0.2% | 596.90 ± 2.9% | 1261.41 ± 1.5% | 7951.14 ± 0.2% | 522.47 ± 1.0% | 0.92 | 1.00 | 4.34 | 0.88 |
| other: a word between two words | 13 | 638.27 ± 0.4% | 662.38 ± 0.4% | 1093.38 ± 0.2% | 155.79 ± 1.3% | 582.44 ± 2.2% | 1339.92 ± 3.4% | 17881.38 ± 0.7% | 636.23 ± 0.9% | 0.96 | 1.00 | 4.10 | 1.10 |
| other: a number before a unit, second text | 15 | 441.99 ± 0.3% | 488.82 ± 0.3% | 693.42 ± 0.4% | 43.60 ± 1.2% | 731.73 ± 2.0% | 1442.73 ± 3.1% | 17700.66 ± 0.5% | 441.96 ± 0.5% | 0.90 | 1.00 | 10.14 | 0.60 |
| other: a heading's start tag | 13 | 418.93 ± 0.4% | 426.74 ± 0.5% | 582.38 ± 0.7% | 48.42 ± 0.3% | 702.78 ± 7.7% | 1374.13 ± 0.9% | 20498.25 ± 0.5% | 419.07 ± 0.2% | 0.98 | 1.00 | 8.65 | 0.60 |
| other: a whole word | 11 | 663.38 ± 1.2% | 697.85 ± 0.8% | 1200.15 ± 1.2% | 141.09 ± 1.0% | 677.78 ± 20.9% | 1352.67 ± 22.8% | 31493.29 ± 0.2% | 660.84 ± 0.5% | 0.95 | 1.00 | 4.70 | 0.98 |
| other: a line's first word, second text | 17 | 616.76 ± 0.3% | 645.12 ± 0.2% | 1088.75 ± 0.3% | 140.12 ± 4.3% | 802.07 ± 2.2% | refused | refused | 615.84 ± 0.4% | 0.96 | 1.00 | 4.40 | 0.77 |
| other: fourteen octets before an x | 16 | 117.36 ± 1.1% | 172.25 ± 0.1% | 205.55 ± 0.3% | 18.09 ± 1.3% | 473.14 ± 13.0% | 569.66 ± 0.9% | 15800.76 ± 0.3% | 117.37 ± 0.4% | 0.68 | 1.00 | 6.49 | 0.25 |
| other: a Greek word | 8 | 432.90 ± 1.1% | 625.46 ± 3.3% | 1032.08 ± 5.3% | 63.01 ± 6.1% | 1599.45 ± 9.9% | 2605.80 ± 0.8% | refused | 432.45 ± 0.1% | 0.69 | 1.00 | 6.87 | 0.27 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27770.65 ± 0.2% | not timed | not timed | 33297.24 ± 0.6% | 2932.07 ± 17.9% | not timed | not timed | 27681.24 ± 0.3% | | 1.00 | 0.83 | 9.47 |
| 01-literal/sherlock-casei-en | 522 | 6350.29 ± 9.2% | not timed | not timed | 9002.67 ± 10.1% | 33.79 ± 7.7% | not timed | not timed | 6335.22 ± 1.4% | | 1.00 | 0.71 | 187.92 |
| 01-literal/sherlock-ru | 724 | 29930.80 ± 0.4% | not timed | not timed | 34132.00 ± 1.2% | 1279.83 ± 2.9% | not timed | not timed | 29947.40 ± 0.3% | | 1.00 | 0.88 | 23.39 |
| 01-literal/sherlock-casei-ru | 746 | 8831.24 ± 1.5% | not timed | not timed | 7799.66 ± 1.4% | 37.79 ± 0.5% | not timed | not timed | 8816.15 ± 3.6% | | 1.00 | 1.13 | 233.72 |
| 01-literal/sherlock-zh | 30 | 52363.55 ± 0.8% | not timed | not timed | 42807.67 ± 0.9% | 1649.64 ± 1.4% | not timed | not timed | 52302.15 ± 1.4% | | 1.00 | 1.22 | 31.74 |
| 02-literal-alternate/sherlock-en | 714 | 12548.82 ± 0.4% | not timed | not timed | 10883.45 ± 0.2% | 19.07 ± 0.3% | not timed | not timed | 12518.60 ± 1.1% | | 1.00 | 1.15 | 657.92 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2092.93 ± 1.0% | not timed | not timed | 2294.77 ± 6.3% | 12.29 ± 0.3% | not timed | not timed | 2047.07 ± 0.5% | | 1.02 | 0.91 | 170.31 |
| 02-literal-alternate/sherlock-ru | 899 | 7478.52 ± 0.6% | not timed | not timed | 9679.97 ± 4.9% | 25.42 ± 8.0% | not timed | not timed | 7439.54 ± 0.4% | | 1.01 | 0.77 | 294.23 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2026.47 ± 0.4% | not timed | not timed | 1188.44 ± 0.6% | 10.56 ± 0.5% | not timed | not timed | 2021.78 ± 0.3% | | 1.00 | 1.71 | 191.84 |
| 02-literal-alternate/sherlock-zh | 207 | 18080.27 ± 0.1% | not timed | not timed | 12597.85 ± 0.3% | 35.57 ± 16.9% | not timed | not timed | 18058.84 ± 0.4% | | 1.00 | 1.44 | 508.31 |
| 03-date/ascii | 111817 | 128.13 ± 1.3% | not timed | not timed | 100.06 ± 1.9% | 0.23 ± 3.5% | not timed | not timed | 127.78 ± 0.6% | | 1.00 | 1.28 | 550.69 |
| 04-ruff-noqa/real | 84 | 688.05 ± 0.2% | not timed | not timed | 505.68 ± 0.4% | 17.19 ± 2.4% | not timed | not timed | 683.46 ± 0.5% | | 1.01 | 1.36 | 40.03 |
| 04-ruff-noqa/tweaked | 44 | 593.13 ± 0.1% | not timed | not timed | 512.25 ± 0.3% | 359.18 ± 1.3% | not timed | not timed | 587.63 ± 2.4% | | 1.01 | 1.16 | 1.65 |
| 05-lexer-veryl/single | 124800 | 3.83 ± 4.7% | not timed | not timed | 5.49 ± 0.8% | 0.26 ± 2.2% | not timed | not timed | 3.83 ± 6.0% | | 1.00 | 0.70 | 14.80 |
| 06-cloud-flare-redos/original | 107 | 220.02 ± 4.4% | not timed | not timed | 228.24 ± 1.3% | 24.81 ± 10.6% | not timed | not timed | 219.95 ± 0.2% | | 1.00 | 0.96 | 8.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 163.18 ± 0.5% | not timed | not timed | 236.84 ± 0.9% | 25.94 ± 2.2% | not timed | not timed | 162.99 ± 0.4% | | 1.00 | 0.69 | 6.29 |
| 06-cloud-flare-redos/simplified-long | 10000 | 169.90 ± 4.4% | not timed | not timed | 259.21 ± 0.6% | 29.48 ± 1.3% | not timed | not timed | 169.35 ± 5.1% | | 1.00 | 0.66 | 5.76 |
| 07-unicode-character-data/parse-line | 558784 | 243.76 ± 15.1% | not timed | not timed | 199.28 ± 2.2% | 48.63 ± 32.5% | not timed | not timed | 236.19 ± 1.3% | | 1.03 | 1.22 | 5.01 |
| 08-words/all-english | 56691 | 99.95 ± 0.8% | not timed | not timed | 82.31 ± 0.3% | 13.10 ± 4.0% | not timed | not timed | 99.54 ± 0.6% | | 1.00 | 1.21 | 7.63 |
| 08-words/long-english | 839 | 984.22 ± 0.5% | not timed | not timed | 583.61 ± 2.4% | 35.35 ± 7.6% | not timed | not timed | 983.22 ± 2.4% | | 1.00 | 1.69 | 27.84 |
| 09-aws-keys/full | 0 | 521.08 ± 0.8% | not timed | not timed | 540.38 ± 0.1% | 61.35 ± 2.5% | not timed | not timed | 517.95 ± 1.5% | | 1.01 | 0.96 | 8.49 |
| 09-aws-keys/quick | 0 | 924.82 ± 1.8% | not timed | not timed | 962.51 ± 0.6% | 392.01 ± 7.4% | not timed | not timed | 967.22 ± 2.7% | | 0.96 | 0.96 | 2.36 |
| 10-bounded-repeat/letters-en | 1833 | 637.29 ± 3.6% | not timed | not timed | 555.83 ± 4.1% | 22.78 ± 11.3% | not timed | not timed | 631.48 ± 1.0% | | 1.01 | 1.15 | 27.98 |
| 10-bounded-repeat/letters-ru | 3475 | 368.87 ± 0.4% | not timed | not timed | 481.20 ± 0.2% | 24.60 ± 9.8% | not timed | not timed | 366.27 ± 0.9% | | 1.01 | 0.77 | 15.00 |
| 10-bounded-repeat/context | 53 | 83.90 ± 0.7% | not timed | not timed | 70.67 ± 0.2% | 22.68 ± 1.6% | not timed | not timed | 80.03 ± 1.6% | | 1.05 | 1.19 | 3.70 |
| 10-bounded-repeat/capitals | 11 | 1030.72 ± 0.8% | not timed | not timed | 603.58 ± 0.3% | 40.25 ± 0.7% | not timed | not timed | 1028.68 ± 1.2% | | 1.00 | 1.71 | 25.61 |
| 11-unstructured-to-json/extract | 600 | 45.79 ± 0.3% | not timed | not timed | 80.96 ± 2.9% | 33.68 ± 19.8% | not timed | not timed | 45.63 ± 0.7% | | 1.00 | 0.57 | 1.36 |
| 12-dictionary/single | 1 | 508.37 ± 0.1% | not timed | not timed | 481.48 ± 0.3% | 0.39 ± 1.8% | not timed | not timed | 509.97 ± 0.8% | | 1.00 | 1.06 | 1296.18 |
| 14-quadratic/1x | 100 | 13.47 ± 1.3% | not timed | not timed | 12.18 ± 0.3% | 1.00 ± 3.9% | not timed | not timed | 13.44 ± 1.0% | | 1.00 | 1.11 | 13.48 |
| 14-quadratic/2x | 200 | 7.99 ± 0.8% | not timed | not timed | 6.12 ± 0.4% | 0.54 ± 0.6% | not timed | not timed | 7.99 ± 0.9% | | 1.00 | 1.31 | 14.69 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.2% | not timed | not timed | 1.22 ± 0.3% | 0.12 ± 1.8% | not timed | not timed | 1.82 ± 0.6% | | 1.00 | 1.50 | 15.64 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.66 ± 0.3% | not timed | not timed | 0.47 ± 0.9% | 0.62 ± 7.2% | not timed | not timed | 1.66 ± 1.6% | | 1.00 | 3.49 | 2.68 |
| 04-ruff-noqa/compile-real | 1 | 100.46 ± 0.2% | not timed | not timed | 16.03 ± 0.9% | 169.44 ± 4.5% | not timed | not timed | 100.43 ± 0.7% | | 1.00 | 6.27 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 17.00 ± 0.3% | not timed | not timed | 2.93 ± 0.3% | 7.85 ± 2.3% | not timed | not timed | 16.85 ± 0.9% | | 1.01 | 5.81 | 2.17 |
| 07-unicode-character-data/compile | 1 | 63.82 ± 0.9% | not timed | not timed | 30.18 ± 0.7% | 44.49 ± 1.6% | not timed | not timed | 64.21 ± 1.1% | | 0.99 | 2.11 | 1.43 |
| 09-aws-keys/compile-full | 1 | 44.83 ± 0.6% | not timed | not timed | 9.81 ± 0.6% | 27.87 ± 1.9% | not timed | not timed | 44.85 ± 0.3% | | 1.00 | 4.57 | 1.61 |
| 09-aws-keys/compile-quick | 1 | 196.12 ± 0.4% | not timed | not timed | 56.53 ± 3.1% | 157.06 ± 1.2% | not timed | not timed | 195.32 ± 0.9% | | 1.00 | 3.47 | 1.25 |
| 10-bounded-repeat/compile-context | 1 | 15.39 ± 13.2% | not timed | not timed | 14.24 ± 0.6% | 20.45 ± 2.1% | not timed | not timed | 15.37 ± 1.5% | | 1.00 | 1.08 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 93.28 ± 0.4% | not timed | not timed | 10.44 ± 0.2% | 29.57 ± 1.5% | not timed | not timed | 92.23 ± 20.3% | | 1.01 | 8.94 | 3.15 |
| 11-unstructured-to-json/compile | 1 | 98.42 ± 0.4% | not timed | not timed | 47.70 ± 0.3% | 80.01 ± 3.6% | not timed | not timed | 99.20 ± 0.3% | | 0.99 | 2.06 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.09 ± 44.5% | 0.11 ± 17.1% | not timed | not timed | 0.35 ± 2.0% | | 1.00 | 4.04 | 3.15 |

