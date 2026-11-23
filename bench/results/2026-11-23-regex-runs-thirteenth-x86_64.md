# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148111589 |
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
| literal: a word | 217 | 41563.87 ± 3.3% | 1034.11 ± 0.1% | 30.06 ± 0.4% | 39064.64 ± 0.3% | 12006.96 ± 4.4% | 12.75 ± 0.3% | 104.42 ± 2.7% | 41594.90 ± 0.4% | 40.19 | 1.00 | 1.06 | 3.46 |
| literal: a word that is not there | 0 | 58633.65 ± 0.2% | 1044.61 ± 0.3% | 30.07 ± 0.5% | 45661.48 ± 4.2% | 44175.65 ± 2.0% | 12.62 ± 0.2% | 97.06 ± 2.0% | 58613.80 ± 0.5% | 56.13 | 1.00 | 1.28 | 1.33 |
| literal: one of four words | 661 | 14160.76 ± 0.3% | 1014.09 ± 0.4% | 16.87 ± 1.4% | 11173.22 ± 5.2% | 24.95 ± 5.9% | 4.48 ± 0.1% | 8.29 ± 2.7% | 14129.82 ± 4.6% | 13.96 | 1.00 | 1.27 | 567.55 |
| literal: a word in any case | 217 | 37064.19 ± 0.3% | 1032.70 ± 0.1% | 22.88 ± 3.2% | 11365.93 ± 3.4% | 47.24 ± 0.5% | refused | differs | 36944.06 ± 2.1% | 35.89 | 1.00 | 3.26 | 784.52 |
| literal: an href attribute | 33 | 35406.66 ± 1.2% | 1039.93 ± 0.1% | 29.06 ± 0.2% | 34649.29 ± 1.9% | 3030.98 ± 7.6% | 9.57 ± 0.3% | 91.20 ± 0.2% | 35447.16 ± 0.2% | 34.05 | 1.00 | 1.02 | 11.68 |
| literal: a word, second text | 123 | 43711.49 ± 0.5% | 1035.64 ± 0.1% | 29.80 ± 0.1% | 39062.91 ± 2.7% | 11102.07 ± 8.5% | 14.46 ± 0.4% | 87.52 ± 0.4% | 43800.96 ± 0.6% | 42.21 | 1.00 | 1.12 | 3.94 |
| class: two capitalized words | 1331 | 919.80 ± 0.3% | 962.76 ± 0.8% | 28.13 ± 0.5% | 576.80 ± 0.3% | 44.50 ± 6.3% | 10.93 ± 0.4% | 79.77 ± 2.0% | 918.83 ± 0.3% | 0.96 | 1.00 | 1.59 | 20.67 |
| class: a word that ends in ing | 3399 | 882.90 ± 3.5% | 886.71 ± 0.5% | 20.06 ± 0.5% | 538.96 ± 0.2% | 32.53 ± 9.8% | 6.19 ± 0.2% | 20.35 ± 0.6% | 885.03 ± 0.8% | 1.00 | 1.00 | 1.64 | 27.14 |
| class: a word in capitals | 2332 | 1158.83 ± 1.0% | 938.93 ± 0.3% | 29.58 ± 0.2% | 566.63 ± 0.7% | 47.89 ± 3.4% | 12.39 ± 0.2% | 100.80 ± 0.9% | 1158.57 ± 0.3% | 1.23 | 1.00 | 2.05 | 24.20 |
| class: a number | 8288 | 1700.75 ± 4.2% | 816.32 ± 0.2% | 29.69 ± 0.7% | 1813.08 ± 0.5% | 44.57 ± 11.5% | 0.38 ± 0.3% | 72.51 ± 2.1% | 1711.54 ± 0.3% | 2.08 | 0.99 | 0.94 | 38.16 |
| class: two capitalized words, second text | 5359 | 725.29 ± 3.1% | 724.75 ± 0.5% | 23.87 ± 0.3% | 477.49 ± 0.2% | 38.65 ± 5.0% | 12.74 ± 0.3% | 74.28 ± 1.1% | 724.87 ± 0.1% | 1.00 | 1.00 | 1.52 | 18.76 |
| other: a word between two words | 6104 | 840.24 ± 1.9% | 753.99 ± 0.2% | 25.47 ± 1.2% | 815.73 ± 0.4% | 124.26 ± 10.7% | 8.47 ± 0.4% | 81.37 ± 6.3% | 840.11 ± 0.2% | 1.11 | 1.00 | 1.03 | 6.76 |
| other: a number before a unit, second text | 1481 | 9848.93 ± 8.3% | 990.30 ± 0.2% | 27.71 ± 6.1% | 8178.31 ± 0.5% | 44.97 ± 0.1% | 13.26 ± 1.1% | 78.56 ± 1.5% | 9828.91 ± 0.3% | 9.95 | 1.00 | 1.20 | 219.00 |
| other: a heading's start tag | 110 | 24465.00 ± 0.4% | 1030.18 ± 0.1% | 29.90 ± 0.2% | 2572.67 ± 1.6% | 2016.74 ± 12.9% | 11.69 ± 0.5% | 107.17 ± 0.3% | 24331.61 ± 4.1% | 23.75 | 1.01 | 9.51 | 12.13 |
| other: a whole word | 217 | 29589.94 ± 0.3% | 1032.48 ± 0.2% | 17.67 ± 8.2% | 28106.04 ± 0.3% | 54.28 ± 0.3% | 11.03 ± 1.2% | 62.34 ± 0.2% | 29472.30 ± 0.1% | 28.66 | 1.00 | 1.05 | 545.10 |
| other: a line's first word, second text | 3716 | 2567.36 ± 2.9% | 862.26 ± 0.2% | 32.04 ± 1.0% | 2343.23 ± 1.7% | 71.00 ± 5.0% | refused | refused | 2561.02 ± 0.7% | 2.98 | 1.00 | 1.10 | 36.16 |
| other: fourteen octets before an x | 87 | 36206.15 ± 0.4% | 251.57 ± 0.6% | 7.54 ± 5.1% | 3538.81 ± 1.3% | 11.58 ± 1.8% | differs | 20.90 ± 2.1% | 36344.97 ± 9.6% | 143.92 | 1.00 | 10.23 | 3125.38 |
| other: a Greek word | 21815 | 481.50 ± 0.3% | 404.12 ± 0.8% | 33.78 ± 6.2% | 304.51 ± 0.2% | 54.88 ± 11.4% | differs | refused | 480.07 ± 3.7% | 1.19 | 1.00 | 1.58 | 8.77 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.08 ± 1.4% | 29.09 ± 0.5% | 1.03 ± 0.2% | 19.26 ± 0.2% | 2.69 ± 0.7% | differs | 4.11 ± 12.8% | 29.29 ± 2.3% | 1.00 | 0.99 | 1.51 | 10.80 |
| a UUID | 32895 | 24.12 ± 0.8% | 24.14 ± 3.9% | 0.73 ± 0.3% | 15.12 ± 0.2% | 3.07 ± 9.1% | 0.52 ± 0.9% | 3.82 ± 0.9% | 24.02 ± 0.2% | 1.00 | 1.00 | 1.60 | 7.86 |
| an IPv4 address | 33176 | 39.70 ± 2.7% | 39.78 ± 2.9% | 2.34 ± 1.1% | 28.54 ± 0.2% | 7.02 ± 2.2% | differs | 4.23 ± 1.6% | 40.02 ± 2.0% | 1.00 | 0.99 | 1.39 | 5.65 |
| a date and time | 32954 | 35.96 ± 0.2% | 35.96 ± 0.5% | 1.74 ± 1.1% | 21.70 ± 0.4% | 8.21 ± 0.5% | 0.91 ± 0.2% | 7.92 ± 5.6% | 35.96 ± 0.3% | 1.00 | 1.00 | 1.66 | 4.38 |
| a field path | 32606 | 32.27 ± 0.6% | 32.38 ± 0.5% | 1.15 ± 3.5% | 22.94 ± 0.8% | 3.52 ± 3.4% | differs | 3.00 ± 1.7% | 32.42 ± 0.5% | 1.00 | 1.00 | 1.41 | 9.17 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.02 ± 1.5% | 10.96 ± 0.2% | 11.00 ± 0.2% | 13.24 ± 1.5% | 5.83 ± 2.3% | 0.75 ± 0.2% | none | 10.95 ± 0.2% | 1.00 | 1.01 | 0.83 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.37 ± 1.1% | 237.35 ± 1.0% | 274.70 ± 0.4% | 100.47 ± 1.7% | 243.65 ± 2.2% | 653.48 ± 7.7% | 4710.76 ± 0.9% | 235.51 ± 0.4% | 0.99 | 1.00 | 2.34 | 0.97 |
| a UUID | 62 | 153.14 ± 1.4% | 153.69 ± 0.3% | 169.67 ± 0.2% | 57.76 ± 0.6% | 116.79 ± 15.1% | 251.50 ± 4.2% | 5372.02 ± 0.8% | 152.93 ± 0.1% | 1.00 | 1.00 | 2.65 | 1.31 |
| an IPv4 address | 29 | 506.25 ± 0.4% | 512.11 ± 0.6% | 727.29 ± 0.5% | 86.88 ± 12.7% | 148.49 ± 1.1% | 401.26 ± 1.4% | 8968.95 ± 0.6% | 505.17 ± 0.5% | 0.99 | 1.00 | 5.83 | 3.41 |
| a date and time | 56 | 372.86 ± 0.6% | 375.86 ± 1.4% | 475.10 ± 0.2% | 85.67 ± 1.7% | 162.24 ± 0.9% | 475.30 ± 5.0% | 5532.08 ± 11.6% | 373.53 ± 7.2% | 0.99 | 1.00 | 4.35 | 2.30 |
| a field path | 39 | 223.52 ± 0.4% | 224.52 ± 0.7% | 256.83 ± 0.2% | 93.88 ± 2.4% | 229.00 ± 3.3% | 759.22 ± 1.9% | 5623.27 ± 0.7% | 223.26 ± 0.2% | 1.00 | 1.00 | 2.38 | 0.98 |
| literal: a word | 7 | 772.71 ± 6.2% | 821.52 ± 0.9% | 1508.99 ± 0.9% | 623.35 ± 2.3% | 789.79 ± 2.8% | 1633.63 ± 0.4% | 34763.20 ± 2.9% | 772.29 ± 6.2% | 0.94 | 1.00 | 1.24 | 0.98 |
| literal: a word that is not there | 8 | 743.01 ± 0.5% | 795.21 ± 0.8% | 1417.45 ± 9.5% | 576.23 ± 0.6% | 762.55 ± 21.8% | 1540.73 ± 0.7% | 34190.57 ± 0.5% | 743.47 ± 9.9% | 0.93 | 1.00 | 1.29 | 0.97 |
| literal: one of four words | 26 | 276.66 ± 0.1% | 471.26 ± 11.5% | 645.50 ± 13.4% | 52.95 ± 8.0% | 294.21 ± 3.0% | 570.76 ± 5.2% | 18366.38 ± 0.3% | 277.22 ± 0.2% | 0.59 | 1.00 | 5.23 | 0.94 |
| literal: a word in any case | 11 | 597.11 ± 2.2% | 631.17 ± 0.4% | 974.60 ± 0.2% | 18.65 ± 0.6% | 824.78 ± 10.8% | refused | 24840.59 ± 4.4% | 592.92 ± 9.3% | 0.95 | 1.01 | 32.01 | 0.72 |
| literal: an href attribute | 12 | 407.09 ± 0.3% | 421.65 ± 0.3% | 558.01 ± 0.2% | 50.70 ± 0.3% | 574.78 ± 2.9% | 1254.82 ± 14.5% | 24224.09 ± 0.6% | 407.27 ± 9.3% | 0.97 | 1.00 | 8.03 | 0.71 |
| literal: a word, second text | 10 | 689.29 ± 17.4% | 749.64 ± 0.2% | 1275.10 ± 0.2% | 518.21 ± 0.7% | 663.88 ± 24.4% | 1319.34 ± 0.4% | 32268.01 ± 0.2% | 690.06 ± 0.2% | 0.92 | 1.00 | 1.33 | 1.04 |
| class: two capitalized words | 23 | 533.42 ± 0.3% | 579.21 ± 1.3% | 853.03 ± 0.7% | 120.76 ± 1.2% | 594.85 ± 3.9% | 1246.47 ± 1.8% | 7835.55 ± 1.0% | 533.73 ± 0.3% | 0.92 | 1.00 | 4.42 | 0.90 |
| class: a word that ends in ing | 9 | 659.34 ± 1.2% | 756.01 ± 0.3% | 1331.90 ± 0.2% | 152.42 ± 0.6% | 866.11 ± 1.8% | 1840.34 ± 0.5% | 19316.49 ± 0.2% | 660.14 ± 1.3% | 0.87 | 1.00 | 4.33 | 0.76 |
| class: a word in capitals | 16 | 591.06 ± 0.4% | 649.51 ± 14.5% | 1058.79 ± 0.3% | 158.19 ± 0.9% | 888.08 ± 1.1% | 1721.76 ± 0.7% | 10597.60 ± 0.3% | 590.32 ± 1.0% | 0.91 | 1.00 | 3.74 | 0.67 |
| class: a number | 6 | 722.67 ± 0.2% | 811.51 ± 2.3% | 1528.43 ± 0.4% | 46.79 ± 0.5% | 1627.61 ± 9.8% | 2986.64 ± 5.8% | 25982.10 ± 0.4% | 723.56 ± 0.4% | 0.89 | 1.00 | 15.45 | 0.44 |
| class: two capitalized words, second text | 23 | 534.00 ± 0.2% | 581.86 ± 13.0% | 851.06 ± 7.6% | 118.85 ± 1.7% | 600.29 ± 2.5% | 1261.74 ± 1.1% | 7841.95 ± 0.6% | 532.17 ± 0.5% | 0.92 | 1.00 | 4.49 | 0.89 |
| other: a word between two words | 13 | 658.49 ± 15.8% | 681.85 ± 5.1% | 1091.82 ± 0.4% | 156.83 ± 1.0% | 588.93 ± 1.8% | 1364.21 ± 23.7% | 17859.24 ± 17.8% | 659.04 ± 0.6% | 0.97 | 1.00 | 4.20 | 1.12 |
| other: a number before a unit, second text | 15 | 440.95 ± 0.2% | 489.37 ± 1.9% | 669.93 ± 6.1% | 43.96 ± 1.5% | 722.54 ± 1.2% | 1486.07 ± 18.7% | 17560.76 ± 0.5% | 440.14 ± 0.2% | 0.90 | 1.00 | 10.03 | 0.61 |
| other: a heading's start tag | 13 | 418.95 ± 0.3% | 426.60 ± 0.2% | 565.50 ± 0.4% | 47.87 ± 1.6% | 707.91 ± 7.1% | 1415.58 ± 1.2% | 19400.85 ± 1.6% | 418.74 ± 9.4% | 0.98 | 1.00 | 8.75 | 0.59 |
| other: a whole word | 11 | 670.80 ± 0.3% | 707.08 ± 0.5% | 1181.21 ± 0.5% | 140.50 ± 0.8% | 677.53 ± 1.3% | 1380.30 ± 0.6% | 29514.56 ± 11.2% | 665.88 ± 15.5% | 0.95 | 1.01 | 4.77 | 0.99 |
| other: a line's first word, second text | 17 | 630.53 ± 0.9% | 661.51 ± 7.1% | 1064.56 ± 0.5% | 148.49 ± 0.5% | 800.23 ± 10.9% | refused | refused | 629.62 ± 0.7% | 0.95 | 1.00 | 4.25 | 0.79 |
| other: fourteen octets before an x | 16 | 119.01 ± 2.0% | 176.98 ± 0.5% | 208.05 ± 0.5% | 17.97 ± 11.7% | 518.21 ± 78.8% | 561.41 ± 1.7% | 15671.50 ± 0.3% | 118.97 ± 2.1% | 0.67 | 1.00 | 6.62 | 0.23 |
| other: a Greek word | 8 | 457.62 ± 0.6% | 632.67 ± 1.0% | 994.45 ± 8.5% | 62.88 ± 0.2% | 1608.23 ± 8.7% | 2821.95 ± 0.5% | refused | 457.56 ± 0.2% | 0.72 | 1.00 | 7.28 | 0.28 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 28957.62 ± 1.5% | not timed | not timed | 33774.81 ± 1.6% | 2846.16 ± 13.2% | not timed | not timed | 28880.56 ± 0.3% | | 1.00 | 0.86 | 10.17 |
| 01-literal/sherlock-casei-en | 522 | 8419.28 ± 0.3% | not timed | not timed | 9027.09 ± 0.3% | 33.97 ± 0.6% | not timed | not timed | 8441.46 ± 0.1% | | 1.00 | 0.93 | 247.83 |
| 01-literal/sherlock-ru | 724 | 30754.73 ± 0.2% | not timed | not timed | 34143.81 ± 0.6% | 1293.89 ± 5.5% | not timed | not timed | 30656.72 ± 0.4% | | 1.00 | 0.90 | 23.77 |
| 01-literal/sherlock-casei-ru | 746 | 8830.17 ± 0.8% | not timed | not timed | 7655.59 ± 1.4% | 37.76 ± 1.7% | not timed | not timed | 8857.34 ± 0.4% | | 1.00 | 1.15 | 233.82 |
| 01-literal/sherlock-zh | 30 | 52398.51 ± 0.2% | not timed | not timed | 42980.73 ± 1.0% | 1639.66 ± 0.9% | not timed | not timed | 52305.25 ± 0.4% | | 1.00 | 1.22 | 31.96 |
| 02-literal-alternate/sherlock-en | 714 | 12870.78 ± 0.6% | not timed | not timed | 10935.31 ± 0.3% | 19.13 ± 1.3% | not timed | not timed | 12858.24 ± 0.5% | | 1.00 | 1.18 | 672.96 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4182.82 ± 7.8% | not timed | not timed | 2279.45 ± 5.3% | 12.23 ± 15.3% | not timed | not timed | 3850.09 ± 1.6% | | 1.09 | 1.84 | 342.03 |
| 02-literal-alternate/sherlock-ru | 899 | 7478.51 ± 0.5% | not timed | not timed | 9771.37 ± 0.7% | 25.42 ± 0.5% | not timed | not timed | 7465.41 ± 0.4% | | 1.00 | 0.77 | 294.25 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2135.01 ± 1.9% | not timed | not timed | 1188.91 ± 1.0% | 10.37 ± 6.5% | not timed | not timed | 2123.23 ± 2.3% | | 1.01 | 1.80 | 205.91 |
| 02-literal-alternate/sherlock-zh | 207 | 18406.10 ± 0.6% | not timed | not timed | 12664.92 ± 1.3% | 35.55 ± 0.2% | not timed | not timed | 18383.18 ± 0.3% | | 1.00 | 1.45 | 517.81 |
| 03-date/ascii | 111817 | 131.89 ± 0.3% | not timed | not timed | 100.30 ± 0.3% | 0.23 ± 4.4% | not timed | not timed | 131.92 ± 0.6% | | 1.00 | 1.32 | 572.53 |
| 04-ruff-noqa/real | 84 | 696.88 ± 1.6% | not timed | not timed | 516.47 ± 7.7% | 20.97 ± 1.4% | not timed | not timed | 700.02 ± 6.1% | | 1.00 | 1.35 | 33.24 |
| 04-ruff-noqa/tweaked | 44 | 588.10 ± 20.8% | not timed | not timed | 499.40 ± 0.4% | 371.37 ± 0.3% | not timed | not timed | 589.15 ± 1.2% | | 1.00 | 1.18 | 1.58 |
| 05-lexer-veryl/single | 124800 | 4.10 ± 5.9% | not timed | not timed | 5.24 ± 6.2% | 0.26 ± 1.4% | not timed | not timed | 4.13 ± 2.0% | | 0.99 | 0.78 | 15.60 |
| 06-cloud-flare-redos/original | 107 | 268.78 ± 0.4% | not timed | not timed | 228.54 ± 1.4% | 25.87 ± 0.9% | not timed | not timed | 268.47 ± 0.3% | | 1.00 | 1.18 | 10.39 |
| 06-cloud-flare-redos/simplified-short | 102 | 265.77 ± 0.5% | not timed | not timed | 236.36 ± 0.4% | 27.76 ± 0.5% | not timed | not timed | 265.58 ± 0.5% | | 1.00 | 1.12 | 9.58 |
| 06-cloud-flare-redos/simplified-long | 10000 | 280.99 ± 0.1% | not timed | not timed | 258.78 ± 0.6% | 29.77 ± 0.3% | not timed | not timed | 280.82 ± 0.2% | | 1.00 | 1.09 | 9.44 |
| 07-unicode-character-data/parse-line | 558784 | 243.77 ± 3.0% | not timed | not timed | 202.71 ± 0.4% | 48.03 ± 2.8% | not timed | not timed | 244.80 ± 2.3% | | 1.00 | 1.20 | 5.08 |
| 08-words/all-english | 56691 | 112.81 ± 0.8% | not timed | not timed | 84.72 ± 0.2% | 14.88 ± 11.9% | not timed | not timed | 112.66 ± 0.9% | | 1.00 | 1.33 | 7.58 |
| 08-words/long-english | 839 | 988.92 ± 0.2% | not timed | not timed | 583.85 ± 0.3% | 35.09 ± 0.4% | not timed | not timed | 988.46 ± 0.1% | | 1.00 | 1.69 | 28.18 |
| 09-aws-keys/full | 0 | 517.68 ± 0.9% | not timed | not timed | 541.23 ± 1.6% | 67.22 ± 0.3% | not timed | not timed | 517.50 ± 0.2% | | 1.00 | 0.96 | 7.70 |
| 09-aws-keys/quick | 0 | 989.04 ± 0.3% | not timed | not timed | 958.71 ± 1.5% | 417.11 ± 0.3% | not timed | not timed | 987.07 ± 0.5% | | 1.00 | 1.03 | 2.37 |
| 10-bounded-repeat/letters-en | 1833 | 673.99 ± 1.9% | not timed | not timed | 556.76 ± 0.7% | 22.48 ± 0.6% | not timed | not timed | 665.93 ± 3.3% | | 1.01 | 1.21 | 29.98 |
| 10-bounded-repeat/letters-ru | 3475 | 370.63 ± 0.2% | not timed | not timed | 483.60 ± 0.3% | 24.85 ± 10.0% | not timed | not timed | 370.01 ± 1.5% | | 1.00 | 0.77 | 14.91 |
| 10-bounded-repeat/context | 53 | 80.13 ± 1.6% | not timed | not timed | 70.64 ± 1.2% | 22.56 ± 1.2% | not timed | not timed | 80.28 ± 1.7% | | 1.00 | 1.13 | 3.55 |
| 10-bounded-repeat/capitals | 11 | 1033.29 ± 0.7% | not timed | not timed | 604.80 ± 0.5% | 40.28 ± 0.4% | not timed | not timed | 1032.94 ± 0.2% | | 1.00 | 1.71 | 25.66 |
| 11-unstructured-to-json/extract | 600 | 46.16 ± 0.8% | not timed | not timed | 79.88 ± 2.6% | 50.09 ± 3.1% | not timed | not timed | 46.24 ± 0.3% | | 1.00 | 0.58 | 0.92 |
| 12-dictionary/single | 1 | 508.82 ± 0.9% | not timed | not timed | 481.97 ± 0.1% | 0.40 ± 0.7% | not timed | not timed | 512.29 ± 0.3% | | 0.99 | 1.06 | 1265.92 |
| 14-quadratic/1x | 100 | 9.44 ± 0.8% | not timed | not timed | 12.15 ± 0.4% | 1.01 ± 3.5% | not timed | not timed | 9.48 ± 1.2% | | 1.00 | 0.78 | 9.32 |
| 14-quadratic/2x | 200 | 5.33 ± 0.2% | not timed | not timed | 6.12 ± 0.2% | 0.55 ± 0.3% | not timed | not timed | 5.34 ± 0.6% | | 1.00 | 0.87 | 9.69 |
| 14-quadratic/10x | 1000 | 1.19 ± 0.2% | not timed | not timed | 1.22 ± 0.5% | 0.12 ± 2.4% | not timed | not timed | 1.19 ± 0.3% | | 1.00 | 0.98 | 9.99 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.68 ± 1.1% | not timed | not timed | 0.48 ± 0.4% | 0.63 ± 3.5% | not timed | not timed | 1.66 ± 1.6% | | 1.01 | 3.53 | 2.65 |
| 04-ruff-noqa/compile-real | 1 | 100.38 ± 0.2% | not timed | not timed | 17.21 ± 0.4% | 168.77 ± 5.8% | not timed | not timed | 100.03 ± 1.0% | | 1.00 | 5.83 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 16.74 ± 1.2% | not timed | not timed | 2.99 ± 1.0% | 7.83 ± 1.5% | not timed | not timed | 16.65 ± 0.8% | | 1.01 | 5.60 | 2.14 |
| 07-unicode-character-data/compile | 1 | 62.63 ± 0.4% | not timed | not timed | 30.22 ± 0.5% | 44.20 ± 2.3% | not timed | not timed | 62.88 ± 0.8% | | 1.00 | 2.07 | 1.42 |
| 09-aws-keys/compile-full | 1 | 43.92 ± 0.2% | not timed | not timed | 9.90 ± 0.9% | 27.76 ± 1.0% | not timed | not timed | 44.47 ± 0.6% | | 0.99 | 4.44 | 1.58 |
| 09-aws-keys/compile-quick | 1 | 199.05 ± 1.3% | not timed | not timed | 56.34 ± 1.2% | 154.65 ± 3.3% | not timed | not timed | 198.11 ± 1.2% | | 1.00 | 3.53 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 15.46 ± 0.5% | not timed | not timed | 14.28 ± 1.2% | 20.12 ± 1.3% | not timed | not timed | 15.46 ± 0.8% | | 1.00 | 1.08 | 0.77 |
| 10-bounded-repeat/compile-capitals | 1 | 92.89 ± 0.9% | not timed | not timed | 10.20 ± 1.5% | 29.21 ± 3.0% | not timed | not timed | 92.19 ± 0.3% | | 1.01 | 9.11 | 3.18 |
| 11-unstructured-to-json/compile | 1 | 97.39 ± 0.4% | not timed | not timed | 46.96 ± 1.4% | 79.43 ± 2.2% | not timed | not timed | 97.70 ± 0.5% | | 1.00 | 2.07 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.7% | not timed | not timed | 0.08 ± 2.3% | 0.11 ± 14.3% | not timed | not timed | 0.34 ± 22.7% | | 1.02 | 4.10 | 3.22 |

