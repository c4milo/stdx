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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148137098 |
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
| literal: a word | 217 | 41464.56 ± 0.5% | 1033.74 ± 0.2% | 30.00 ± 1.7% | 38931.33 ± 1.2% | 12136.56 ± 4.5% | 12.73 ± 1.3% | 104.34 ± 19.2% | 41509.53 ± 1.6% | 40.11 | 1.00 | 1.07 | 3.42 |
| literal: a word that is not there | 0 | 58440.61 ± 0.3% | 1043.53 ± 0.2% | 30.09 ± 1.4% | 46066.91 ± 0.7% | 43390.28 ± 3.6% | 12.62 ± 0.7% | 97.17 ± 19.3% | 58461.26 ± 0.6% | 56.00 | 1.00 | 1.27 | 1.35 |
| literal: one of four words | 661 | 14144.49 ± 0.7% | 1013.90 ± 0.3% | 16.83 ± 0.9% | 11175.45 ± 0.2% | 25.03 ± 0.3% | 4.48 ± 0.3% | 8.27 ± 1.0% | 14191.81 ± 0.3% | 13.95 | 1.00 | 1.27 | 565.11 |
| literal: a word in any case | 217 | 36963.26 ± 4.6% | 1032.83 ± 0.7% | 22.89 ± 0.9% | 11406.66 ± 1.2% | 47.14 ± 0.7% | refused | differs | 36939.08 ± 0.3% | 35.79 | 1.00 | 3.24 | 784.15 |
| literal: an href attribute | 33 | 35283.14 ± 0.2% | 1040.07 ± 0.0% | 29.05 ± 1.1% | 35070.89 ± 0.5% | 2940.30 ± 5.5% | 9.56 ± 0.2% | 91.37 ± 0.3% | 35316.62 ± 0.2% | 33.92 | 1.00 | 1.01 | 12.00 |
| literal: a word, second text | 123 | 43594.85 ± 6.3% | 1035.56 ± 1.9% | 29.67 ± 1.4% | 39369.22 ± 0.9% | 11286.39 ± 7.5% | 14.47 ± 0.6% | 87.57 ± 4.7% | 43506.31 ± 6.8% | 42.10 | 1.00 | 1.11 | 3.86 |
| class: two capitalized words | 1331 | 919.51 ± 0.4% | 963.42 ± 0.1% | 28.12 ± 0.5% | 575.68 ± 0.5% | 44.23 ± 10.0% | 10.92 ± 0.2% | 79.95 ± 0.1% | 918.38 ± 0.1% | 0.95 | 1.00 | 1.60 | 20.79 |
| class: a word that ends in ing | 3399 | 885.32 ± 0.2% | 886.68 ± 1.0% | 19.60 ± 18.6% | 540.02 ± 11.0% | 32.83 ± 13.1% | 6.19 ± 0.3% | 20.30 ± 0.7% | 882.91 ± 0.3% | 1.00 | 1.00 | 1.64 | 26.97 |
| class: a word in capitals | 2332 | 1105.82 ± 0.4% | 940.69 ± 0.1% | 29.53 ± 5.4% | 567.30 ± 0.5% | 45.59 ± 9.2% | 12.40 ± 0.2% | 100.62 ± 0.3% | 1157.90 ± 0.4% | 1.18 | 0.96 | 1.95 | 24.25 |
| class: a number | 8288 | 1706.50 ± 0.5% | 815.99 ± 2.6% | 29.45 ± 5.2% | 1807.65 ± 0.2% | 46.56 ± 12.3% | 0.38 ± 0.9% | 72.51 ± 6.1% | 1716.35 ± 0.3% | 2.09 | 0.99 | 0.94 | 36.65 |
| class: two capitalized words, second text | 5359 | 724.78 ± 0.1% | 699.55 ± 0.3% | 25.78 ± 0.8% | 476.79 ± 0.2% | 37.62 ± 14.9% | 12.75 ± 0.2% | 74.22 ± 4.0% | 723.99 ± 0.1% | 1.04 | 1.00 | 1.52 | 19.27 |
| other: a word between two words | 6104 | 839.82 ± 0.9% | 753.72 ± 0.5% | 25.10 ± 0.6% | 815.94 ± 0.2% | 121.77 ± 22.2% | 8.47 ± 0.1% | 81.36 ± 0.2% | 839.56 ± 0.4% | 1.11 | 1.00 | 1.03 | 6.90 |
| other: a number before a unit, second text | 1481 | 9861.40 ± 0.6% | 990.58 ± 0.1% | 28.21 ± 0.4% | 8232.79 ± 5.8% | 44.87 ± 5.1% | 13.31 ± 0.2% | 78.85 ± 0.2% | 9808.14 ± 0.5% | 9.96 | 1.01 | 1.20 | 219.76 |
| other: a heading's start tag | 110 | 24009.81 ± 0.2% | 1029.47 ± 0.2% | 29.67 ± 1.1% | 2573.16 ± 1.3% | 2004.60 ± 4.1% | 11.66 ± 1.1% | 107.07 ± 0.9% | 24376.69 ± 0.1% | 23.32 | 0.98 | 9.33 | 11.98 |
| other: a whole word | 217 | 28743.33 ± 0.2% | 1032.98 ± 0.5% | 30.57 ± 0.2% | 28078.51 ± 1.8% | 54.15 ± 12.9% | 11.02 ± 1.9% | 62.58 ± 2.8% | 29422.37 ± 5.9% | 27.83 | 0.98 | 1.02 | 530.78 |
| other: a line's first word, second text | 3716 | 2577.52 ± 1.1% | 863.38 ± 1.6% | 32.11 ± 1.4% | 2323.68 ± 1.3% | 71.32 ± 9.6% | refused | refused | 2552.95 ± 3.7% | 2.99 | 1.01 | 1.11 | 36.14 |
| other: fourteen octets before an x | 87 | 36315.52 ± 0.3% | 250.80 ± 0.4% | 7.45 ± 4.8% | 3530.28 ± 0.3% | 11.57 ± 1.3% | differs | 20.60 ± 3.6% | 36522.52 ± 2.6% | 144.80 | 0.99 | 10.29 | 3138.19 |
| other: a Greek word | 21815 | 481.04 ± 0.8% | 402.37 ± 3.2% | 33.71 ± 5.7% | 301.61 ± 1.3% | 57.96 ± 6.5% | differs | refused | 479.31 ± 0.4% | 1.20 | 1.00 | 1.59 | 8.30 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.23 ± 0.8% | 29.07 ± 1.2% | 1.04 ± 0.3% | 19.90 ± 2.7% | 2.68 ± 1.9% | differs | 4.28 ± 1.5% | 29.31 ± 0.8% | 1.01 | 1.00 | 1.47 | 10.90 |
| a UUID | 32895 | 23.93 ± 0.3% | 24.18 ± 0.3% | 0.73 ± 0.9% | 15.14 ± 2.5% | 3.06 ± 2.2% | 0.52 ± 0.4% | 3.91 ± 5.0% | 23.95 ± 0.2% | 0.99 | 1.00 | 1.58 | 7.83 |
| an IPv4 address | 33176 | 39.73 ± 0.4% | 39.46 ± 1.1% | 2.34 ± 1.5% | 28.50 ± 1.0% | 7.01 ± 2.0% | differs | 4.19 ± 9.1% | 39.94 ± 13.2% | 1.01 | 0.99 | 1.39 | 5.67 |
| a date and time | 32954 | 35.97 ± 0.4% | 35.98 ± 0.3% | 1.74 ± 0.5% | 21.66 ± 0.7% | 8.21 ± 3.6% | 0.90 ± 0.4% | 7.55 ± 4.7% | 35.86 ± 0.3% | 1.00 | 1.00 | 1.66 | 4.38 |
| a field path | 32606 | 32.41 ± 0.4% | 32.27 ± 0.3% | 1.15 ± 0.5% | 23.03 ± 0.4% | 3.54 ± 1.9% | differs | 2.97 ± 1.8% | 32.35 ± 1.1% | 1.00 | 1.00 | 1.41 | 9.17 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.91 ± 0.6% | 10.95 ± 0.8% | 10.94 ± 0.3% | 13.28 ± 1.0% | 5.87 ± 1.5% | 0.74 ± 0.2% | none | 10.94 ± 0.4% | 1.00 | 1.00 | 0.82 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.63 ± 0.9% | 235.24 ± 0.4% | 271.04 ± 1.4% | 101.76 ± 1.3% | 243.77 ± 16.1% | 701.68 ± 5.2% | 4712.28 ± 0.9% | 233.57 ± 1.9% | 0.99 | 1.00 | 2.30 | 0.96 |
| a UUID | 62 | 150.98 ± 0.3% | 151.43 ± 0.3% | 167.10 ± 0.3% | 58.34 ± 2.2% | 118.62 ± 1.6% | 254.68 ± 2.4% | 5385.07 ± 0.4% | 151.02 ± 0.1% | 1.00 | 1.00 | 2.59 | 1.27 |
| an IPv4 address | 29 | 503.94 ± 0.5% | 508.99 ± 0.4% | 725.52 ± 0.3% | 88.52 ± 1.5% | 148.26 ± 2.7% | 410.37 ± 0.6% | 8993.96 ± 1.2% | 504.66 ± 0.2% | 0.99 | 1.00 | 5.69 | 3.40 |
| a date and time | 56 | 370.76 ± 0.2% | 374.10 ± 0.3% | 472.73 ± 0.6% | 87.47 ± 0.6% | 161.35 ± 31.1% | 477.27 ± 2.4% | 5559.02 ± 0.6% | 371.94 ± 0.3% | 0.99 | 1.00 | 4.24 | 2.30 |
| a field path | 39 | 220.56 ± 1.5% | 221.83 ± 0.3% | 253.43 ± 0.3% | 97.18 ± 2.8% | 227.93 ± 2.1% | 740.97 ± 1.2% | 5613.56 ± 0.5% | 220.98 ± 0.9% | 0.99 | 1.00 | 2.27 | 0.97 |
| literal: a word | 7 | 773.81 ± 0.3% | 821.61 ± 0.6% | 1507.49 ± 0.2% | 656.55 ± 0.7% | 791.79 ± 1.6% | 1609.61 ± 1.2% | 34750.44 ± 0.3% | 773.18 ± 0.3% | 0.94 | 1.00 | 1.18 | 0.98 |
| literal: a word that is not there | 8 | 744.56 ± 0.6% | 795.67 ± 0.4% | 1417.66 ± 2.2% | 604.06 ± 6.2% | 748.88 ± 14.2% | 1507.14 ± 1.2% | 34054.10 ± 0.5% | 744.35 ± 0.4% | 0.94 | 1.00 | 1.23 | 0.99 |
| literal: one of four words | 26 | 282.42 ± 0.5% | 473.16 ± 0.3% | 646.26 ± 0.6% | 53.87 ± 0.4% | 290.71 ± 1.7% | 585.75 ± 0.5% | 18368.54 ± 0.5% | 281.76 ± 0.2% | 0.60 | 1.00 | 5.24 | 0.97 |
| literal: a word in any case | 11 | 596.67 ± 2.3% | 634.40 ± 0.1% | 984.09 ± 0.4% | 18.80 ± 0.7% | 826.98 ± 2.2% | refused | 24799.57 ± 0.5% | 592.44 ± 1.3% | 0.94 | 1.01 | 31.73 | 0.72 |
| literal: an href attribute | 12 | 403.95 ± 0.5% | 416.89 ± 0.2% | 551.65 ± 0.4% | 50.52 ± 0.2% | 566.22 ± 4.9% | 1293.29 ± 0.4% | 24216.62 ± 0.8% | 404.15 ± 0.2% | 0.97 | 1.00 | 8.00 | 0.71 |
| literal: a word, second text | 10 | 689.72 ± 16.7% | 746.33 ± 18.4% | 1276.79 ± 2.0% | 545.86 ± 1.0% | 653.73 ± 4.4% | 1361.43 ± 0.5% | 32139.10 ± 0.5% | 688.69 ± 1.3% | 0.92 | 1.00 | 1.26 | 1.06 |
| class: two capitalized words | 23 | 532.30 ± 0.3% | 580.66 ± 0.3% | 850.16 ± 5.3% | 123.84 ± 0.5% | 598.94 ± 8.9% | 1286.66 ± 0.9% | 7837.95 ± 3.4% | 530.42 ± 0.6% | 0.92 | 1.00 | 4.30 | 0.89 |
| class: a word that ends in ing | 9 | 651.08 ± 0.6% | 750.33 ± 1.1% | 1322.69 ± 5.1% | 154.99 ± 13.6% | 850.63 ± 10.2% | 1899.72 ± 0.4% | 19272.73 ± 0.3% | 651.53 ± 0.9% | 0.87 | 1.00 | 4.20 | 0.77 |
| class: a word in capitals | 16 | 590.27 ± 0.5% | 649.27 ± 9.2% | 1046.82 ± 3.7% | 158.92 ± 2.4% | 881.23 ± 21.4% | 1795.91 ± 0.6% | 10598.08 ± 0.1% | 590.63 ± 1.5% | 0.91 | 1.00 | 3.71 | 0.67 |
| class: a number | 6 | 724.01 ± 3.3% | 814.27 ± 5.4% | 1529.23 ± 5.0% | 47.61 ± 1.5% | 1634.14 ± 2.5% | 3044.97 ± 3.6% | 25766.12 ± 10.3% | 723.82 ± 0.8% | 0.89 | 1.00 | 15.21 | 0.44 |
| class: two capitalized words, second text | 23 | 532.60 ± 0.2% | 579.53 ± 3.9% | 849.42 ± 2.1% | 121.30 ± 1.2% | 598.06 ± 3.2% | 1275.47 ± 0.6% | 7847.04 ± 1.2% | 532.53 ± 0.2% | 0.92 | 1.00 | 4.39 | 0.89 |
| other: a word between two words | 13 | 654.55 ± 1.4% | 675.33 ± 2.7% | 1082.29 ± 0.8% | 157.87 ± 0.8% | 581.92 ± 1.9% | 1332.51 ± 0.7% | 17884.45 ± 0.6% | 658.15 ± 0.7% | 0.97 | 0.99 | 4.15 | 1.12 |
| other: a number before a unit, second text | 15 | 437.23 ± 0.1% | 483.76 ± 0.4% | 658.38 ± 0.2% | 44.31 ± 1.3% | 720.23 ± 1.3% | 1433.66 ± 2.0% | 17700.49 ± 1.2% | 437.26 ± 0.5% | 0.90 | 1.00 | 9.87 | 0.61 |
| other: a heading's start tag | 13 | 417.18 ± 0.5% | 423.22 ± 0.7% | 559.34 ± 0.9% | 48.27 ± 2.5% | 709.27 ± 15.6% | 1364.19 ± 0.6% | 20184.05 ± 1.7% | 417.61 ± 0.2% | 0.99 | 1.00 | 8.64 | 0.59 |
| other: a whole word | 11 | 674.17 ± 4.6% | 716.22 ± 1.9% | 1183.62 ± 0.8% | 143.47 ± 1.0% | 675.65 ± 4.8% | 1344.37 ± 1.1% | 31661.08 ± 0.5% | 668.18 ± 7.8% | 0.94 | 1.01 | 4.70 | 1.00 |
| other: a line's first word, second text | 17 | 630.15 ± 13.2% | 664.32 ± 0.3% | 1072.22 ± 0.9% | 148.81 ± 0.5% | 804.49 ± 2.4% | refused | refused | 630.94 ± 0.8% | 0.95 | 1.00 | 4.23 | 0.78 |
| other: fourteen octets before an x | 16 | 117.69 ± 0.6% | 176.62 ± 0.7% | 208.14 ± 0.7% | 18.07 ± 0.7% | 513.64 ± 11.9% | 579.26 ± 0.9% | 15782.36 ± 0.5% | 117.61 ± 2.1% | 0.67 | 1.00 | 6.51 | 0.23 |
| other: a Greek word | 8 | 448.50 ± 0.5% | 629.04 ± 0.3% | 986.50 ± 0.5% | 62.66 ± 6.6% | 1604.31 ± 1.4% | 2828.69 ± 0.6% | refused | 448.62 ± 0.8% | 0.71 | 1.00 | 7.16 | 0.28 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29063.48 ± 0.1% | not timed | not timed | 33060.49 ± 0.3% | 2970.33 ± 6.2% | not timed | not timed | 28945.66 ± 0.3% | | 1.00 | 0.88 | 9.78 |
| 01-literal/sherlock-casei-en | 522 | 8449.85 ± 0.4% | not timed | not timed | 9015.51 ± 0.2% | 33.81 ± 2.4% | not timed | not timed | 8436.93 ± 0.2% | | 1.00 | 0.94 | 249.93 |
| 01-literal/sherlock-ru | 724 | 30996.19 ± 2.5% | not timed | not timed | 34505.83 ± 0.8% | 1298.53 ± 2.2% | not timed | not timed | 30972.91 ± 0.9% | | 1.00 | 0.90 | 23.87 |
| 01-literal/sherlock-casei-ru | 746 | 8875.16 ± 0.2% | not timed | not timed | 7713.62 ± 0.8% | 37.26 ± 24.1% | not timed | not timed | 8855.32 ± 0.3% | | 1.00 | 1.15 | 238.17 |
| 01-literal/sherlock-zh | 30 | 53102.46 ± 0.8% | not timed | not timed | 42815.38 ± 0.7% | 1661.32 ± 4.7% | not timed | not timed | 52966.30 ± 0.5% | | 1.00 | 1.24 | 31.96 |
| 02-literal-alternate/sherlock-en | 714 | 12879.73 ± 0.3% | not timed | not timed | 10899.05 ± 8.2% | 18.89 ± 21.3% | not timed | not timed | 12837.43 ± 1.7% | | 1.00 | 1.18 | 681.68 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4174.42 ± 5.9% | not timed | not timed | 2298.61 ± 1.0% | 12.34 ± 1.5% | not timed | not timed | 3841.06 ± 8.5% | | 1.09 | 1.82 | 338.41 |
| 02-literal-alternate/sherlock-ru | 899 | 7485.88 ± 0.7% | not timed | not timed | 9774.33 ± 8.2% | 25.39 ± 0.4% | not timed | not timed | 7463.78 ± 0.2% | | 1.00 | 0.77 | 294.85 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2166.72 ± 3.1% | not timed | not timed | 1189.88 ± 0.4% | 10.46 ± 3.8% | not timed | not timed | 2121.81 ± 2.4% | | 1.02 | 1.82 | 207.21 |
| 02-literal-alternate/sherlock-zh | 207 | 18564.16 ± 0.1% | not timed | not timed | 12586.29 ± 0.5% | 35.64 ± 0.4% | not timed | not timed | 18588.43 ± 2.0% | | 1.00 | 1.47 | 520.95 |
| 03-date/ascii | 111817 | 131.65 ± 0.3% | not timed | not timed | 100.51 ± 0.3% | 0.23 ± 0.3% | not timed | not timed | 131.71 ± 0.9% | | 1.00 | 1.31 | 573.96 |
| 04-ruff-noqa/real | 84 | 698.41 ± 23.4% | not timed | not timed | 509.93 ± 6.0% | 19.35 ± 1.2% | not timed | not timed | 697.15 ± 1.7% | | 1.00 | 1.37 | 36.10 |
| 04-ruff-noqa/tweaked | 44 | 591.26 ± 0.2% | not timed | not timed | 509.18 ± 0.6% | 364.18 ± 1.8% | not timed | not timed | 589.40 ± 0.4% | | 1.00 | 1.16 | 1.62 |
| 05-lexer-veryl/single | 124800 | 4.12 ± 2.5% | not timed | not timed | 5.31 ± 1.0% | 0.25 ± 4.8% | not timed | not timed | 4.14 ± 10.3% | | 1.00 | 0.78 | 16.21 |
| 06-cloud-flare-redos/original | 107 | 269.02 ± 0.6% | not timed | not timed | 227.42 ± 3.7% | 25.49 ± 0.7% | not timed | not timed | 268.93 ± 0.6% | | 1.00 | 1.18 | 10.55 |
| 06-cloud-flare-redos/simplified-short | 102 | 265.50 ± 0.9% | not timed | not timed | 236.60 ± 1.4% | 27.45 ± 20.7% | not timed | not timed | 265.70 ± 0.3% | | 1.00 | 1.12 | 9.67 |
| 06-cloud-flare-redos/simplified-long | 10000 | 280.86 ± 0.2% | not timed | not timed | 259.60 ± 0.3% | 29.83 ± 0.3% | not timed | not timed | 280.71 ± 0.1% | | 1.00 | 1.08 | 9.42 |
| 07-unicode-character-data/parse-line | 558784 | 242.28 ± 1.1% | not timed | not timed | 202.70 ± 0.9% | 47.21 ± 11.5% | not timed | not timed | 244.60 ± 4.9% | | 0.99 | 1.20 | 5.13 |
| 08-words/all-english | 56691 | 112.36 ± 0.3% | not timed | not timed | 84.82 ± 0.3% | 14.83 ± 5.7% | not timed | not timed | 112.41 ± 0.6% | | 1.00 | 1.32 | 7.58 |
| 08-words/long-english | 839 | 989.72 ± 0.4% | not timed | not timed | 584.11 ± 0.3% | 35.24 ± 0.5% | not timed | not timed | 988.40 ± 0.2% | | 1.00 | 1.69 | 28.08 |
| 09-aws-keys/full | 0 | 516.60 ± 0.9% | not timed | not timed | 552.25 ± 0.8% | 67.08 ± 0.2% | not timed | not timed | 517.23 ± 0.2% | | 1.00 | 0.94 | 7.70 |
| 09-aws-keys/quick | 0 | 992.53 ± 1.9% | not timed | not timed | 962.15 ± 7.1% | 415.71 ± 12.7% | not timed | not timed | 986.56 ± 0.6% | | 1.01 | 1.03 | 2.39 |
| 10-bounded-repeat/letters-en | 1833 | 673.97 ± 0.8% | not timed | not timed | 556.06 ± 0.7% | 22.91 ± 28.5% | not timed | not timed | 667.61 ± 1.0% | | 1.01 | 1.21 | 29.42 |
| 10-bounded-repeat/letters-ru | 3475 | 370.98 ± 0.7% | not timed | not timed | 483.02 ± 4.4% | 26.52 ± 17.4% | not timed | not timed | 370.40 ± 0.4% | | 1.00 | 0.77 | 13.99 |
| 10-bounded-repeat/context | 53 | 82.26 ± 1.3% | not timed | not timed | 70.55 ± 0.5% | 22.55 ± 1.2% | not timed | not timed | 83.01 ± 3.0% | | 0.99 | 1.17 | 3.65 |
| 10-bounded-repeat/capitals | 11 | 1032.88 ± 0.6% | not timed | not timed | 604.56 ± 0.1% | 40.28 ± 0.3% | not timed | not timed | 1032.49 ± 0.3% | | 1.00 | 1.71 | 25.64 |
| 11-unstructured-to-json/extract | 600 | 46.16 ± 0.4% | not timed | not timed | 80.43 ± 2.7% | 51.04 ± 2.6% | not timed | not timed | 46.27 ± 0.4% | | 1.00 | 0.57 | 0.90 |
| 12-dictionary/single | 1 | 508.92 ± 0.2% | not timed | not timed | 480.72 ± 0.2% | 0.40 ± 6.2% | not timed | not timed | 510.72 ± 1.0% | | 1.00 | 1.06 | 1282.41 |
| 14-quadratic/1x | 100 | 9.48 ± 11.1% | not timed | not timed | 12.19 ± 0.2% | 1.00 ± 2.3% | not timed | not timed | 9.47 ± 0.6% | | 1.00 | 0.78 | 9.45 |
| 14-quadratic/2x | 200 | 5.34 ± 0.8% | not timed | not timed | 6.13 ± 0.7% | 0.55 ± 1.0% | not timed | not timed | 5.33 ± 9.3% | | 1.00 | 0.87 | 9.76 |
| 14-quadratic/10x | 1000 | 1.19 ± 0.6% | not timed | not timed | 1.22 ± 0.2% | 0.12 ± 1.9% | not timed | not timed | 1.19 ± 0.3% | | 1.00 | 0.98 | 10.02 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.71 ± 0.3% | not timed | not timed | 0.48 ± 4.2% | 0.63 ± 8.6% | not timed | not timed | 1.69 ± 1.4% | | 1.01 | 3.57 | 2.69 |
| 04-ruff-noqa/compile-real | 1 | 98.10 ± 0.5% | not timed | not timed | 17.07 ± 0.8% | 169.37 ± 1.2% | not timed | not timed | 98.89 ± 9.0% | | 0.99 | 5.75 | 0.58 |
| 05-lexer-veryl/compile-single | 1 | 16.86 ± 0.8% | not timed | not timed | 3.01 ± 1.1% | 7.88 ± 1.2% | not timed | not timed | 16.90 ± 1.2% | | 1.00 | 5.60 | 2.14 |
| 07-unicode-character-data/compile | 1 | 62.36 ± 0.8% | not timed | not timed | 30.16 ± 1.0% | 44.35 ± 22.5% | not timed | not timed | 62.68 ± 0.5% | | 0.99 | 2.07 | 1.41 |
| 09-aws-keys/compile-full | 1 | 44.27 ± 0.7% | not timed | not timed | 9.91 ± 0.4% | 28.03 ± 0.8% | not timed | not timed | 44.63 ± 0.9% | | 0.99 | 4.47 | 1.58 |
| 09-aws-keys/compile-quick | 1 | 192.60 ± 0.3% | not timed | not timed | 57.26 ± 3.9% | 156.36 ± 2.2% | not timed | not timed | 196.51 ± 5.2% | | 0.98 | 3.36 | 1.23 |
| 10-bounded-repeat/compile-context | 1 | 15.44 ± 0.0% | not timed | not timed | 14.32 ± 1.0% | 20.27 ± 3.0% | not timed | not timed | 15.48 ± 2.4% | | 1.00 | 1.08 | 0.76 |
| 10-bounded-repeat/compile-capitals | 1 | 92.23 ± 0.4% | not timed | not timed | 10.35 ± 0.5% | 29.43 ± 4.3% | not timed | not timed | 92.69 ± 0.3% | | 0.99 | 8.91 | 3.13 |
| 11-unstructured-to-json/compile | 1 | 96.27 ± 0.4% | not timed | not timed | 47.37 ± 0.5% | 80.29 ± 1.6% | not timed | not timed | 96.82 ± 1.9% | | 0.99 | 2.03 | 1.20 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.5% | not timed | not timed | 0.08 ± 2.4% | 0.11 ± 21.1% | not timed | not timed | 0.35 ± 1.1% | | 1.01 | 4.14 | 3.05 |

