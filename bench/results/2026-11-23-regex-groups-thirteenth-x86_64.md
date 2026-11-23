# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215443992 |
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
| literal: a word | 217 | 41168.51 ± 1.1% | 3972.36 ± 0.5% | 32.61 ± 0.5% | 38967.26 ± 1.2% | 12098.69 ± 2.3% | 12.74 ± 0.3% | 103.38 ± 0.8% | 41212.45 ± 1.2% | 10.36 | 1.00 | 1.06 | 3.40 |
| literal: a word that is not there | 0 | 58321.10 ± 0.3% | 3911.66 ± 0.3% | 32.66 ± 0.3% | 45898.39 ± 0.6% | 44000.85 ± 11.2% | 12.55 ± 0.3% | 98.56 ± 2.5% | 58297.52 ± 4.7% | 14.91 | 1.00 | 1.27 | 1.33 |
| literal: one of four words | 661 | 14234.39 ± 0.5% | 1669.78 ± 1.3% | 17.03 ± 0.6% | 11142.71 ± 0.3% | 24.10 ± 0.2% | 4.48 ± 0.3% | 8.66 ± 0.5% | 14210.61 ± 0.7% | 8.52 | 1.00 | 1.28 | 590.74 |
| literal: a word in any case | 217 | 36812.55 ± 6.7% | 1793.14 ± 0.5% | 24.05 ± 0.5% | 11336.73 ± 0.2% | 46.97 ± 0.7% | refused | differs | 36661.96 ± 6.8% | 20.53 | 1.00 | 3.25 | 783.82 |
| literal: an href attribute | 33 | 35931.30 ± 0.7% | 616.20 ± 0.2% | 30.72 ± 4.7% | 35255.55 ± 26.8% | 3054.88 ± 5.0% | 9.54 ± 0.6% | 91.39 ± 0.6% | 35794.80 ± 0.8% | 58.31 | 1.00 | 1.02 | 11.76 |
| literal: a word, second text | 123 | 43702.49 ± 3.9% | 2999.24 ± 0.8% | 32.34 ± 11.9% | 39418.50 ± 0.3% | 10954.17 ± 9.1% | 14.44 ± 0.4% | 88.47 ± 0.5% | 43862.54 ± 2.6% | 14.57 | 1.00 | 1.11 | 3.99 |
| class: two capitalized words | 1331 | 906.24 ± 0.1% | 605.46 ± 0.3% | 29.67 ± 1.1% | 576.88 ± 1.2% | 44.48 ± 8.0% | 10.84 ± 0.2% | 79.20 ± 0.9% | 904.93 ± 0.3% | 1.50 | 1.00 | 1.57 | 20.37 |
| class: a word that ends in ing | 3399 | 576.07 ± 0.4% | 575.39 ± 0.4% | 19.93 ± 6.5% | 538.16 ± 0.7% | 32.53 ± 11.7% | 6.17 ± 0.4% | 20.61 ± 1.4% | 575.75 ± 0.9% | 1.00 | 1.00 | 1.07 | 17.71 |
| class: a word in capitals | 2332 | 1142.50 ± 1.5% | 610.51 ± 0.7% | 31.97 ± 0.7% | 565.04 ± 0.3% | 47.52 ± 1.4% | 12.40 ± 1.2% | 102.08 ± 22.0% | 1142.31 ± 0.3% | 1.87 | 1.00 | 2.02 | 24.04 |
| class: a number | 8288 | 1839.19 ± 0.4% | 813.78 ± 0.3% | 32.50 ± 0.8% | 1790.47 ± 5.2% | 47.62 ± 15.4% | 0.38 ± 0.5% | 72.46 ± 19.7% | 1744.59 ± 0.9% | 2.26 | 1.05 | 1.03 | 38.62 |
| class: two capitalized words, second text | 5359 | 513.00 ± 0.1% | 519.11 ± 0.2% | 22.10 ± 0.4% | 478.60 ± 0.3% | 37.17 ± 11.1% | 12.68 ± 0.3% | 73.41 ± 5.2% | 510.91 ± 0.3% | 0.99 | 1.00 | 1.07 | 13.80 |
| other: a word between two words | 6104 | 831.63 ± 0.6% | 585.53 ± 0.4% | 26.09 ± 0.5% | 816.99 ± 0.2% | 119.02 ± 14.4% | 8.47 ± 0.3% | 82.20 ± 0.2% | 832.06 ± 4.2% | 1.42 | 1.00 | 1.02 | 6.99 |
| other: a number before a unit, second text | 1481 | 9976.57 ± 0.6% | 1047.63 ± 1.0% | 30.17 ± 0.7% | 8277.38 ± 0.4% | 44.92 ± 0.7% | 13.23 ± 0.5% | 77.51 ± 11.8% | 9918.00 ± 3.5% | 9.52 | 1.01 | 1.21 | 222.08 |
| other: a heading's start tag | 110 | 24576.18 ± 0.6% | 747.26 ± 0.2% | 32.34 ± 0.5% | 2590.12 ± 1.8% | 1967.30 ± 6.7% | 11.68 ± 0.4% | 107.13 ± 0.3% | 24661.25 ± 0.5% | 32.89 | 1.00 | 9.49 | 12.49 |
| other: a whole word | 217 | 29628.55 ± 0.5% | 607.95 ± 0.3% | 32.38 ± 0.7% | 28275.79 ± 0.4% | 54.33 ± 1.0% | 11.03 ± 0.6% | 63.26 ± 0.7% | 29555.71 ± 0.1% | 48.74 | 1.00 | 1.05 | 545.39 |
| other: a line's first word, second text | 3716 | 2577.39 ± 2.1% | 587.56 ± 0.5% | 35.77 ± 0.5% | 2324.72 ± 1.2% | 69.02 ± 14.7% | refused | refused | 2538.27 ± 1.5% | 4.39 | 1.02 | 1.11 | 37.34 |
| other: fourteen octets before an x | 87 | 36397.83 ± 0.7% | 259.45 ± 1.9% | 6.96 ± 0.4% | 3530.65 ± 1.6% | 11.49 ± 8.0% | differs | 21.24 ± 2.1% | 36332.40 ± 23.5% | 140.29 | 1.00 | 10.31 | 3167.94 |
| other: a Greek word | 21815 | 461.20 ± 4.2% | 395.76 ± 0.4% | 34.66 ± 8.4% | 294.18 ± 0.4% | 57.23 ± 13.9% | differs | refused | 458.98 ± 0.4% | 1.17 | 1.00 | 1.57 | 8.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 21.69 ± 12.1% | 21.71 ± 4.7% | 1.01 ± 1.2% | 19.90 ± 0.1% | 2.69 ± 0.7% | differs | 4.31 ± 1.2% | 21.42 ± 0.9% | 1.00 | 1.01 | 1.09 | 8.06 |
| a UUID | 32895 | 24.32 ± 5.1% | 24.35 ± 0.2% | 0.71 ± 0.6% | 15.08 ± 0.1% | 3.06 ± 4.9% | 0.52 ± 1.0% | 3.77 ± 0.6% | 24.43 ± 0.7% | 1.00 | 1.00 | 1.61 | 7.94 |
| an IPv4 address | 33176 | 40.97 ± 11.9% | 41.00 ± 1.1% | 2.30 ± 9.3% | 28.49 ± 20.3% | 7.00 ± 18.1% | differs | 4.23 ± 0.4% | 41.04 ± 0.7% | 1.00 | 1.00 | 1.44 | 5.85 |
| a date and time | 32954 | 36.31 ± 4.2% | 36.28 ± 1.9% | 1.70 ± 0.3% | 21.69 ± 0.3% | 8.12 ± 2.5% | 0.90 ± 1.1% | 7.82 ± 17.6% | 36.19 ± 4.3% | 1.00 | 1.00 | 1.67 | 4.47 |
| a field path | 32606 | 25.46 ± 9.2% | 25.45 ± 1.2% | 1.13 ± 14.3% | 22.96 ± 0.6% | 3.57 ± 4.3% | differs | 3.07 ± 1.4% | 25.35 ± 1.4% | 1.00 | 1.00 | 1.11 | 7.14 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.60 ± 0.5% | 10.98 ± 6.3% | 10.96 ± 2.2% | 13.25 ± 0.9% | 5.95 ± 3.0% | 0.75 ± 0.7% | none | 11.00 ± 1.1% | 0.97 | 0.96 | 0.80 | 1.78 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 259.81 ± 0.6% | 261.88 ± 0.2% | 304.59 ± 0.2% | 101.62 ± 1.4% | 245.75 ± 3.5% | 700.60 ± 5.7% | 4952.12 ± 1.7% | 260.13 ± 0.4% | 0.99 | 1.00 | 2.56 | 1.06 |
| a UUID | 62 | 169.60 ± 19.1% | 169.41 ± 1.2% | 188.81 ± 0.9% | 58.07 ± 1.0% | 119.39 ± 3.2% | 256.70 ± 3.3% | 5511.93 ± 7.2% | 169.21 ± 15.1% | 1.00 | 1.00 | 2.92 | 1.42 |
| an IPv4 address | 29 | 503.62 ± 1.7% | 510.02 ± 12.6% | 699.27 ± 3.0% | 87.82 ± 0.7% | 150.42 ± 1.9% | 415.62 ± 0.7% | 9012.90 ± 7.6% | 502.90 ± 1.2% | 0.99 | 1.00 | 5.73 | 3.35 |
| a date and time | 56 | 361.09 ± 0.5% | 364.75 ± 0.2% | 447.33 ± 0.9% | 87.22 ± 1.0% | 160.64 ± 2.9% | 478.55 ± 2.2% | 5684.52 ± 0.8% | 361.49 ± 2.5% | 0.99 | 1.00 | 4.14 | 2.25 |
| a field path | 39 | 258.05 ± 0.3% | 259.82 ± 0.9% | 301.29 ± 0.3% | 95.01 ± 2.6% | 232.43 ± 3.8% | 726.91 ± 4.2% | 6027.00 ± 1.4% | 258.38 ± 0.4% | 0.99 | 1.00 | 2.72 | 1.11 |
| literal: a word | 7 | 766.92 ± 0.4% | 813.69 ± 0.4% | 1378.62 ± 1.4% | 641.07 ± 6.1% | 800.97 ± 189.6% | 1577.02 ± 8.6% | 34729.98 ± 0.9% | 767.09 ± 9.7% | 0.94 | 1.00 | 1.20 | 0.96 |
| literal: a word that is not there | 8 | 737.91 ± 0.4% | 791.93 ± 5.4% | 1309.61 ± 7.6% | 594.14 ± 4.9% | 745.14 ± 26.1% | 1498.47 ± 3.2% | 34140.17 ± 0.3% | 737.11 ± 9.1% | 0.93 | 1.00 | 1.24 | 0.99 |
| literal: one of four words | 26 | 276.13 ± 0.9% | 453.06 ± 0.3% | 588.13 ± 0.5% | 54.08 ± 1.0% | 279.49 ± 19.7% | 591.07 ± 0.8% | 18021.57 ± 1.5% | 276.67 ± 0.2% | 0.61 | 1.00 | 5.11 | 0.99 |
| literal: a word in any case | 11 | 534.96 ± 0.5% | 563.41 ± 0.3% | 791.87 ± 0.4% | 18.88 ± 0.9% | 826.31 ± 10.7% | refused | 27736.51 ± 2.5% | 530.64 ± 1.1% | 0.95 | 1.01 | 28.33 | 0.65 |
| literal: an href attribute | 12 | 416.54 ± 1.5% | 430.84 ± 10.2% | 557.30 ± 6.4% | 51.13 ± 10.3% | 570.48 ± 1.4% | 1266.04 ± 13.5% | 24245.80 ± 0.3% | 416.60 ± 0.4% | 0.97 | 1.00 | 8.15 | 0.73 |
| literal: a word, second text | 10 | 675.65 ± 17.1% | 735.09 ± 2.8% | 1170.90 ± 0.5% | 541.40 ± 1.1% | 665.40 ± 7.7% | 1345.86 ± 0.4% | 32387.50 ± 0.5% | 676.25 ± 0.6% | 0.92 | 1.00 | 1.25 | 1.02 |
| class: two capitalized words | 23 | 529.24 ± 0.6% | 575.64 ± 0.7% | 812.14 ± 1.2% | 122.13 ± 1.0% | 607.93 ± 2.1% | 1243.00 ± 0.4% | 8144.46 ± 1.0% | 528.18 ± 10.1% | 0.92 | 1.00 | 4.33 | 0.87 |
| class: a word that ends in ing | 9 | 670.84 ± 0.6% | 765.29 ± 1.5% | 1284.93 ± 13.7% | 154.19 ± 1.2% | 866.58 ± 2.9% | 1872.22 ± 11.0% | 19420.59 ± 10.9% | 669.49 ± 0.3% | 0.88 | 1.00 | 4.35 | 0.77 |
| class: a word in capitals | 16 | 589.41 ± 10.7% | 644.37 ± 17.2% | 1003.25 ± 1.9% | 158.76 ± 0.7% | 892.11 ± 15.2% | 1757.65 ± 0.3% | 10688.10 ± 0.4% | 590.34 ± 1.3% | 0.91 | 1.00 | 3.71 | 0.66 |
| class: a number | 6 | 743.31 ± 1.0% | 838.58 ± 1.1% | 1511.08 ± 0.5% | 47.63 ± 2.8% | 1646.83 ± 1.3% | 3026.92 ± 3.0% | 26058.69 ± 0.3% | 742.99 ± 0.4% | 0.89 | 1.00 | 15.61 | 0.45 |
| class: two capitalized words, second text | 23 | 529.21 ± 0.7% | 574.60 ± 0.4% | 804.96 ± 1.3% | 122.30 ± 0.8% | 601.95 ± 1.4% | 1190.53 ± 1.3% | 8170.06 ± 0.9% | 529.53 ± 0.2% | 0.92 | 1.00 | 4.33 | 0.88 |
| other: a word between two words | 13 | 654.39 ± 0.3% | 676.37 ± 0.9% | 1025.54 ± 0.4% | 159.88 ± 1.4% | 587.94 ± 1.1% | 1351.00 ± 0.6% | 17995.01 ± 0.4% | 654.23 ± 0.5% | 0.97 | 1.00 | 4.09 | 1.11 |
| other: a number before a unit, second text | 15 | 469.13 ± 0.6% | 528.24 ± 0.4% | 720.36 ± 1.2% | 44.40 ± 0.9% | 728.35 ± 21.1% | 1450.85 ± 4.2% | 17840.13 ± 0.6% | 469.88 ± 10.0% | 0.89 | 1.00 | 10.56 | 0.64 |
| other: a heading's start tag | 13 | 430.86 ± 0.2% | 437.00 ± 1.3% | 567.06 ± 4.9% | 47.96 ± 6.2% | 717.40 ± 5.4% | 1364.86 ± 0.5% | 20416.91 ± 0.3% | 430.66 ± 0.2% | 0.99 | 1.00 | 8.98 | 0.60 |
| other: a whole word | 11 | 665.42 ± 1.4% | 701.91 ± 0.2% | 1096.27 ± 0.5% | 143.99 ± 0.7% | 684.71 ± 19.9% | 1370.93 ± 2.5% | 32032.93 ± 0.6% | 664.37 ± 0.5% | 0.95 | 1.00 | 4.62 | 0.97 |
| other: a line's first word, second text | 17 | 636.83 ± 0.4% | 666.54 ± 12.6% | 1036.13 ± 3.6% | 148.75 ± 1.1% | 809.42 ± 10.5% | refused | refused | 634.63 ± 5.2% | 0.96 | 1.00 | 4.28 | 0.79 |
| other: fourteen octets before an x | 16 | 118.70 ± 1.5% | 175.89 ± 1.0% | 202.08 ± 9.9% | 17.95 ± 0.3% | 520.62 ± 2.0% | 581.82 ± 2.6% | 15758.39 ± 22.6% | 118.69 ± 6.0% | 0.67 | 1.00 | 6.61 | 0.23 |
| other: a Greek word | 8 | 494.64 ± 0.9% | 706.31 ± 0.8% | 1125.63 ± 0.5% | 61.90 ± 0.7% | 1634.55 ± 3.8% | 2732.30 ± 0.7% | refused | 493.58 ± 6.1% | 0.70 | 1.00 | 7.99 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29115.79 ± 6.4% | not timed | not timed | 33605.58 ± 1.0% | 2803.08 ± 6.5% | not timed | not timed | 29082.46 ± 0.2% | | 1.00 | 0.87 | 10.39 |
| 01-literal/sherlock-casei-en | 522 | 10712.51 ± 0.3% | not timed | not timed | 9049.55 ± 1.1% | 34.00 ± 1.3% | not timed | not timed | 10701.97 ± 0.3% | | 1.00 | 1.18 | 315.09 |
| 01-literal/sherlock-ru | 724 | 30619.43 ± 1.1% | not timed | not timed | 33956.39 ± 0.7% | 1276.19 ± 3.9% | not timed | not timed | 30567.86 ± 1.5% | | 1.00 | 0.90 | 23.99 |
| 01-literal/sherlock-casei-ru | 746 | 11867.07 ± 1.4% | not timed | not timed | 7823.07 ± 0.7% | 37.53 ± 2.7% | not timed | not timed | 11813.89 ± 0.2% | | 1.00 | 1.52 | 316.18 |
| 01-literal/sherlock-zh | 30 | 52998.03 ± 0.4% | not timed | not timed | 42671.27 ± 0.5% | 1642.58 ± 4.5% | not timed | not timed | 52834.64 ± 1.2% | | 1.00 | 1.24 | 32.27 |
| 02-literal-alternate/sherlock-en | 714 | 12662.37 ± 1.0% | not timed | not timed | 10903.52 ± 0.5% | 19.14 ± 0.5% | not timed | not timed | 12644.44 ± 0.3% | | 1.00 | 1.16 | 661.49 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4799.67 ± 6.4% | not timed | not timed | 2314.02 ± 0.7% | 12.21 ± 1.6% | not timed | not timed | 4420.00 ± 0.8% | | 1.09 | 2.07 | 393.20 |
| 02-literal-alternate/sherlock-ru | 899 | 10247.20 ± 0.5% | not timed | not timed | 9805.31 ± 0.6% | 25.45 ± 1.5% | not timed | not timed | 10216.43 ± 0.4% | | 1.00 | 1.05 | 402.64 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2478.05 ± 2.3% | not timed | not timed | 1189.62 ± 5.5% | 10.52 ± 9.7% | not timed | not timed | 2439.23 ± 1.8% | | 1.02 | 2.08 | 235.53 |
| 02-literal-alternate/sherlock-zh | 207 | 18440.87 ± 0.3% | not timed | not timed | 12697.37 ± 0.8% | 35.66 ± 0.1% | not timed | not timed | 18424.03 ± 0.2% | | 1.00 | 1.45 | 517.13 |
| 03-date/ascii | 111817 | 126.38 ± 0.7% | not timed | not timed | 99.87 ± 0.3% | 0.23 ± 3.3% | not timed | not timed | 127.22 ± 2.8% | | 0.99 | 1.27 | 558.48 |
| 04-ruff-noqa/real | 84 | 487.50 ± 1.5% | not timed | not timed | 505.19 ± 0.4% | 20.71 ± 2.6% | not timed | not timed | 489.26 ± 18.6% | | 1.00 | 0.96 | 23.54 |
| 04-ruff-noqa/tweaked | 44 | 584.31 ± 0.6% | not timed | not timed | 507.39 ± 0.9% | 362.16 ± 4.9% | not timed | not timed | 584.26 ± 0.3% | | 1.00 | 1.15 | 1.61 |
| 05-lexer-veryl/single | 124800 | 4.80 ± 1.0% | not timed | not timed | 5.41 ± 0.6% | 0.26 ± 3.3% | not timed | not timed | 4.70 ± 12.4% | | 1.02 | 0.89 | 18.29 |
| 06-cloud-flare-redos/original | 107 | 410.81 ± 8.4% | not timed | not timed | 227.31 ± 14.1% | 24.65 ± 5.8% | not timed | not timed | 402.44 ± 2.3% | | 1.02 | 1.81 | 16.67 |
| 06-cloud-flare-redos/simplified-short | 102 | 398.66 ± 8.6% | not timed | not timed | 236.41 ± 5.5% | 27.60 ± 17.0% | not timed | not timed | 398.11 ± 0.3% | | 1.00 | 1.69 | 14.44 |
| 06-cloud-flare-redos/simplified-long | 10000 | 509.86 ± 0.1% | not timed | not timed | 259.37 ± 0.9% | 29.45 ± 13.5% | not timed | not timed | 511.04 ± 0.5% | | 1.00 | 1.97 | 17.31 |
| 07-unicode-character-data/parse-line | 558784 | 247.82 ± 5.9% | not timed | not timed | 200.58 ± 3.4% | 47.33 ± 3.4% | not timed | not timed | 243.93 ± 2.5% | | 1.02 | 1.24 | 5.24 |
| 08-words/all-english | 56691 | 111.59 ± 8.4% | not timed | not timed | 83.61 ± 10.9% | 13.67 ± 10.8% | not timed | not timed | 112.32 ± 1.7% | | 0.99 | 1.33 | 8.16 |
| 08-words/long-english | 839 | 614.04 ± 0.7% | not timed | not timed | 583.74 ± 0.3% | 33.52 ± 2.9% | not timed | not timed | 614.68 ± 0.1% | | 1.00 | 1.05 | 18.32 |
| 09-aws-keys/full | 0 | 494.09 ± 4.3% | not timed | not timed | 544.39 ± 3.9% | 66.65 ± 0.4% | not timed | not timed | 494.71 ± 2.5% | | 1.00 | 0.91 | 7.41 |
| 09-aws-keys/quick | 0 | 906.25 ± 0.5% | not timed | not timed | 964.71 ± 0.8% | 409.89 ± 1.0% | not timed | not timed | 901.74 ± 0.9% | | 1.00 | 0.94 | 2.21 |
| 10-bounded-repeat/letters-en | 1833 | 681.37 ± 0.5% | not timed | not timed | 557.29 ± 0.3% | 22.85 ± 1.3% | not timed | not timed | 676.53 ± 0.6% | | 1.01 | 1.22 | 29.82 |
| 10-bounded-repeat/letters-ru | 3475 | 529.56 ± 3.4% | not timed | not timed | 483.48 ± 0.5% | 26.96 ± 16.4% | not timed | not timed | 515.47 ± 2.3% | | 1.03 | 1.10 | 19.64 |
| 10-bounded-repeat/context | 53 | 81.18 ± 6.3% | not timed | not timed | 68.50 ± 5.2% | 22.38 ± 2.9% | not timed | not timed | 81.02 ± 3.3% | | 1.00 | 1.18 | 3.63 |
| 10-bounded-repeat/capitals | 11 | 639.57 ± 7.9% | not timed | not timed | 604.31 ± 0.3% | 40.17 ± 0.6% | not timed | not timed | 637.01 ± 8.2% | | 1.00 | 1.06 | 15.92 |
| 11-unstructured-to-json/extract | 600 | 63.34 ± 3.3% | not timed | not timed | 78.41 ± 3.7% | 50.24 ± 1.8% | not timed | not timed | 63.39 ± 0.6% | | 1.00 | 0.81 | 1.26 |
| 12-dictionary/single | 1 | 510.07 ± 0.2% | not timed | not timed | 480.00 ± 0.2% | 0.40 ± 1.7% | not timed | not timed | 512.17 ± 0.3% | | 1.00 | 1.06 | 1284.28 |
| 14-quadratic/1x | 100 | 26.33 ± 0.1% | not timed | not timed | 12.19 ± 1.0% | 0.97 ± 3.4% | not timed | not timed | 25.94 ± 1.8% | | 1.01 | 2.16 | 27.23 |
| 14-quadratic/2x | 200 | 19.98 ± 0.2% | not timed | not timed | 6.12 ± 0.2% | 0.53 ± 0.9% | not timed | not timed | 19.93 ± 1.8% | | 1.00 | 3.26 | 37.58 |
| 14-quadratic/10x | 1000 | 6.88 ± 0.6% | not timed | not timed | 1.22 ± 0.0% | 0.12 ± 1.9% | not timed | not timed | 6.87 ± 1.0% | | 1.00 | 5.65 | 59.15 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.48 ± 5.3% | not timed | not timed | 0.48 ± 1.6% | 0.64 ± 3.6% | not timed | not timed | 1.48 ± 2.1% | | 1.00 | 3.12 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 108.50 ± 0.2% | not timed | not timed | 17.30 ± 2.7% | 169.66 ± 4.4% | not timed | not timed | 107.80 ± 0.4% | | 1.01 | 6.27 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 16.54 ± 1.9% | not timed | not timed | 2.96 ± 5.9% | 7.82 ± 25.6% | not timed | not timed | 16.48 ± 1.0% | | 1.00 | 5.58 | 2.12 |
| 07-unicode-character-data/compile | 1 | 65.76 ± 0.6% | not timed | not timed | 30.67 ± 0.4% | 44.58 ± 2.1% | not timed | not timed | 65.47 ± 2.1% | | 1.00 | 2.14 | 1.48 |
| 09-aws-keys/compile-full | 1 | 45.84 ± 2.2% | not timed | not timed | 9.93 ± 0.7% | 28.04 ± 3.1% | not timed | not timed | 45.68 ± 0.7% | | 1.00 | 4.61 | 1.64 |
| 09-aws-keys/compile-quick | 1 | 197.89 ± 0.2% | not timed | not timed | 57.64 ± 1.9% | 157.90 ± 2.5% | not timed | not timed | 194.40 ± 0.7% | | 1.02 | 3.43 | 1.25 |
| 10-bounded-repeat/compile-context | 1 | 15.34 ± 0.8% | not timed | not timed | 14.41 ± 0.5% | 20.00 ± 2.0% | not timed | not timed | 15.11 ± 1.0% | | 1.01 | 1.06 | 0.77 |
| 10-bounded-repeat/compile-capitals | 1 | 94.35 ± 0.8% | not timed | not timed | 10.44 ± 0.4% | 29.27 ± 1.7% | not timed | not timed | 93.99 ± 0.8% | | 1.00 | 9.03 | 3.22 |
| 11-unstructured-to-json/compile | 1 | 99.75 ± 0.9% | not timed | not timed | 47.76 ± 0.3% | 80.96 ± 4.4% | not timed | not timed | 100.02 ± 0.2% | | 1.00 | 2.09 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.35 ± 4.8% | not timed | not timed | 0.08 ± 4.2% | 0.11 ± 24.1% | not timed | not timed | 0.34 ± 1.0% | | 1.01 | 4.13 | 3.25 |

