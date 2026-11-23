# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102092242 |
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
| literal: a word | 217 | 16047.33 ± 1.0% | 1042.72 ± 0.3% | 28.67 ± 0.2% | 18071.58 ± 2.5% | 9208.86 ± 8.0% | 17.38 ± 0.3% | 86.80 ± 0.7% | 16085.71 ± 0.3% | 15.39 | 1.00 | 0.89 | 1.74 |
| literal: a word that is not there | 0 | 18857.34 ± 1.8% | 1050.02 ± 0.9% | 28.65 ± 0.2% | 19792.84 ± 3.2% | 28649.09 ± 3.7% | 17.21 ± 0.5% | 82.66 ± 0.2% | 18899.96 ± 2.1% | 17.96 | 1.00 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6175.04 ± 0.5% | 1022.24 ± 0.3% | 14.55 ± 0.1% | 3951.95 ± 0.1% | 21.90 ± 0.1% | 5.22 ± 0.0% | 6.90 ± 0.4% | 6148.87 ± 0.2% | 6.04 | 1.00 | 1.56 | 281.93 |
| literal: a word in any case | 217 | 12516.34 ± 0.2% | 1040.72 ± 0.5% | 21.25 ± 1.2% | 3971.85 ± 0.3% | 37.80 ± 1.1% | refused | differs | 12527.62 ± 0.5% | 12.03 | 1.00 | 3.15 | 331.11 |
| literal: an href attribute | 33 | 13744.65 ± 0.8% | 1048.18 ± 0.3% | 27.13 ± 0.2% | 16887.29 ± 1.0% | 2266.89 ± 0.7% | 13.29 ± 0.3% | 75.83 ± 0.4% | 13701.78 ± 0.7% | 13.11 | 1.00 | 0.81 | 6.06 |
| literal: a word, second text | 123 | 16248.59 ± 1.1% | 1048.06 ± 0.4% | 27.92 ± 0.3% | 17959.70 ± 2.4% | 7755.63 ± 5.1% | 19.70 ± 0.6% | 71.20 ± 0.5% | 16300.37 ± 1.6% | 15.50 | 1.00 | 0.90 | 2.10 |
| class: two capitalized words | 1331 | 1105.06 ± 0.3% | 959.64 ± 0.1% | 25.85 ± 0.1% | 585.18 ± 0.1% | 40.73 ± 8.4% | 14.68 ± 0.2% | 68.72 ± 1.2% | 1101.96 ± 0.2% | 1.15 | 1.00 | 1.89 | 27.13 |
| class: a word that ends in ing | 3399 | 881.03 ± 0.2% | 882.50 ± 0.2% | 17.93 ± 0.1% | 547.61 ± 0.1% | 29.70 ± 3.0% | 8.16 ± 0.2% | 18.43 ± 0.4% | 880.46 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.66 |
| class: a word in capitals | 2332 | 1470.28 ± 0.6% | 946.45 ± 0.1% | 27.46 ± 0.3% | 572.46 ± 0.1% | 43.53 ± 17.0% | 17.08 ± 0.2% | 83.10 ± 0.6% | 1468.63 ± 0.2% | 1.55 | 1.00 | 2.57 | 33.77 |
| class: a number | 8288 | 2058.95 ± 0.1% | 793.19 ± 0.1% | 27.76 ± 0.3% | 1727.47 ± 0.1% | 41.46 ± 16.4% | 0.55 ± 0.2% | 56.49 ± 0.9% | 2054.86 ± 0.3% | 2.60 | 1.00 | 1.19 | 49.66 |
| class: two capitalized words, second text | 5359 | 689.44 ± 0.1% | 688.11 ± 0.1% | 23.11 ± 0.2% | 485.05 ± 0.1% | 34.23 ± 14.8% | 16.65 ± 0.4% | 64.08 ± 0.3% | 689.37 ± 0.1% | 1.00 | 1.00 | 1.42 | 20.14 |
| other: a word between two words | 6104 | 776.69 ± 0.3% | 743.90 ± 0.2% | 23.35 ± 0.1% | 736.49 ± 0.4% | 102.19 ± 13.6% | 11.24 ± 0.1% | 70.03 ± 0.2% | 777.53 ± 0.2% | 1.04 | 1.00 | 1.05 | 7.60 |
| other: a number before a unit, second text | 1481 | 5453.92 ± 0.5% | 979.67 ± 0.2% | 25.74 ± 0.2% | 5630.30 ± 0.9% | 40.81 ± 16.0% | 17.82 ± 0.3% | 66.99 ± 0.4% | 5449.30 ± 0.5% | 5.57 | 1.00 | 0.97 | 133.64 |
| other: a heading's start tag | 110 | 12719.77 ± 0.6% | 1032.07 ± 0.2% | 27.21 ± 0.1% | 1709.21 ± 0.4% | 1583.15 ± 4.5% | 16.14 ± 0.3% | 88.80 ± 2.5% | 12749.50 ± 1.4% | 12.32 | 1.00 | 7.44 | 8.03 |
| other: a whole word | 217 | 14014.53 ± 0.5% | 1041.10 ± 0.4% | 29.49 ± 0.6% | 14559.39 ± 1.1% | 49.39 ± 0.1% | 13.38 ± 0.1% | 55.76 ± 1.0% | 14015.63 ± 0.7% | 13.46 | 1.00 | 0.96 | 283.74 |
| other: a line's first word, second text | 3716 | 1951.39 ± 0.7% | 855.95 ± 0.2% | 31.12 ± 0.1% | 1718.81 ± 0.3% | 61.86 ± 7.2% | refused | refused | 1939.49 ± 0.5% | 2.28 | 1.01 | 1.14 | 31.55 |
| other: fourteen octets before an x | 87 | 19763.97 ± 1.7% | 251.43 ± 0.4% | 5.30 ± 0.1% | 4021.40 ± 0.4% | 10.66 ± 0.1% | differs | 17.79 ± 0.2% | 19873.78 ± 0.8% | 78.61 | 0.99 | 4.91 | 1854.19 |
| other: a Greek word | 21815 | 471.71 ± 0.2% | 316.55 ± 0.2% | 30.68 ± 0.1% | 289.07 ± 0.1% | 43.61 ± 9.9% | differs | refused | 470.10 ± 0.6% | 1.49 | 1.00 | 1.63 | 10.82 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.94 ± 0.4% | 25.97 ± 0.2% | 0.82 ± 0.2% | 19.77 ± 0.8% | 2.77 ± 0.4% | differs | 3.99 ± 0.3% | 26.00 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.37 |
| a UUID | 32895 | 21.18 ± 0.3% | 21.27 ± 0.1% | 0.64 ± 0.1% | 15.18 ± 0.7% | 3.08 ± 1.2% | 0.71 ± 0.4% | 3.58 ± 0.4% | 21.33 ± 0.2% | 1.00 | 0.99 | 1.40 | 6.87 |
| an IPv4 address | 33176 | 36.75 ± 0.2% | 36.69 ± 0.3% | 2.10 ± 0.2% | 29.03 ± 0.8% | 6.66 ± 0.3% | differs | 4.12 ± 0.1% | 36.81 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.52 |
| a date and time | 32954 | 31.06 ± 0.2% | 31.18 ± 0.3% | 1.45 ± 0.2% | 21.20 ± 0.2% | 7.04 ± 0.1% | 1.20 ± 0.4% | 7.09 ± 0.3% | 31.12 ± 0.2% | 1.00 | 1.00 | 1.46 | 4.41 |
| a field path | 32606 | 29.37 ± 0.1% | 29.36 ± 0.1% | 0.97 ± 0.1% | 23.01 ± 0.1% | 3.52 ± 0.2% | differs | 2.96 ± 0.1% | 29.44 ± 0.3% | 1.00 | 1.00 | 1.28 | 8.34 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.86 ± 0.3% | 8.92 ± 0.5% | 8.88 ± 0.5% | 11.37 ± 0.2% | 4.94 ± 1.2% | 0.91 ± 0.6% | none | 8.94 ± 0.1% | 0.99 | 0.99 | 0.78 | 1.79 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.04 ± 0.2% | 221.56 ± 0.2% | 258.13 ± 0.1% | 86.53 ± 0.2% | 221.16 ± 1.1% | 485.33 ± 0.4% | 3891.31 ± 0.3% | 220.97 ± 0.4% | 1.00 | 1.00 | 2.55 | 1.00 |
| a UUID | 62 | 145.29 ± 0.2% | 145.64 ± 0.3% | 160.76 ± 0.1% | 45.56 ± 0.1% | 98.98 ± 0.7% | 183.97 ± 1.0% | 4255.53 ± 0.6% | 145.25 ± 0.2% | 1.00 | 1.00 | 3.19 | 1.47 |
| an IPv4 address | 29 | 437.13 ± 0.4% | 440.75 ± 0.5% | 613.27 ± 0.5% | 76.26 ± 0.9% | 130.86 ± 4.1% | 294.59 ± 0.5% | 7597.26 ± 0.5% | 437.13 ± 0.7% | 0.99 | 1.00 | 5.73 | 3.34 |
| a date and time | 56 | 317.22 ± 0.2% | 318.02 ± 0.1% | 398.40 ± 0.2% | 72.01 ± 0.3% | 136.16 ± 0.6% | 321.26 ± 1.0% | 4875.72 ± 0.3% | 317.13 ± 0.2% | 1.00 | 1.00 | 4.41 | 2.33 |
| a field path | 39 | 208.45 ± 0.2% | 208.79 ± 0.2% | 240.67 ± 0.1% | 79.31 ± 0.3% | 203.43 ± 1.2% | 484.62 ± 0.9% | 4920.74 ± 4.3% | 208.24 ± 0.5% | 1.00 | 1.00 | 2.63 | 1.02 |
| literal: a word | 7 | 645.35 ± 0.7% | 697.49 ± 0.6% | 1231.17 ± 1.1% | 504.54 ± 1.7% | 630.80 ± 2.0% | 927.20 ± 0.3% | 30549.34 ± 0.5% | 644.95 ± 1.0% | 0.93 | 1.00 | 1.28 | 1.02 |
| literal: a word that is not there | 8 | 616.56 ± 0.6% | 672.49 ± 0.6% | 1157.37 ± 0.6% | 461.64 ± 0.3% | 606.56 ± 1.7% | 877.83 ± 0.4% | 29610.12 ± 0.2% | 616.52 ± 0.4% | 0.92 | 1.00 | 1.34 | 1.02 |
| literal: one of four words | 26 | 249.47 ± 0.3% | 403.87 ± 0.7% | 542.60 ± 0.6% | 49.34 ± 0.3% | 242.75 ± 1.0% | 354.75 ± 0.7% | 15866.15 ± 0.3% | 249.69 ± 0.1% | 0.62 | 1.00 | 5.06 | 1.03 |
| literal: a word in any case | 11 | 513.23 ± 0.5% | 553.16 ± 1.1% | 862.91 ± 0.2% | 15.76 ± 1.9% | 648.45 ± 2.6% | refused | 23784.94 ± 0.6% | 513.77 ± 0.2% | 0.93 | 1.00 | 32.57 | 0.79 |
| literal: an href attribute | 12 | 348.02 ± 0.5% | 358.93 ± 0.5% | 466.74 ± 0.6% | 45.02 ± 0.2% | 499.89 ± 1.4% | 768.84 ± 1.2% | 22310.59 ± 0.2% | 347.98 ± 0.2% | 0.97 | 1.00 | 7.73 | 0.70 |
| literal: a word, second text | 10 | 570.34 ± 0.6% | 631.17 ± 0.5% | 1047.12 ± 0.5% | 410.39 ± 0.5% | 536.44 ± 1.2% | 803.46 ± 0.6% | 27778.72 ± 0.4% | 571.05 ± 0.3% | 0.90 | 1.00 | 1.39 | 1.06 |
| class: two capitalized words | 23 | 457.20 ± 1.3% | 488.32 ± 0.4% | 704.85 ± 0.6% | 100.91 ± 0.1% | 506.52 ± 1.7% | 741.58 ± 0.4% | 6629.61 ± 0.1% | 457.95 ± 0.3% | 0.94 | 1.00 | 4.53 | 0.90 |
| class: a word that ends in ing | 9 | 589.89 ± 1.2% | 659.36 ± 0.2% | 1146.09 ± 0.1% | 132.29 ± 1.3% | 759.30 ± 0.6% | 1088.76 ± 1.9% | 16323.33 ± 0.3% | 589.55 ± 0.2% | 0.89 | 1.00 | 4.46 | 0.78 |
| class: a word in capitals | 16 | 524.17 ± 0.4% | 562.60 ± 0.5% | 905.89 ± 0.4% | 134.91 ± 0.9% | 753.44 ± 2.0% | 1007.55 ± 0.4% | 8716.61 ± 0.1% | 524.16 ± 0.2% | 0.93 | 1.00 | 3.89 | 0.70 |
| class: a number | 6 | 661.96 ± 0.4% | 724.30 ± 1.2% | 1359.68 ± 1.9% | 41.79 ± 0.5% | 1408.72 ± 1.8% | 1899.49 ± 1.1% | 23325.41 ± 0.1% | 662.42 ± 0.3% | 0.91 | 1.00 | 15.84 | 0.47 |
| class: two capitalized words, second text | 23 | 458.15 ± 0.2% | 489.55 ± 0.4% | 706.91 ± 0.7% | 102.83 ± 0.3% | 501.28 ± 2.0% | 743.20 ± 0.6% | 6630.89 ± 0.3% | 458.07 ± 0.3% | 0.94 | 1.00 | 4.46 | 0.91 |
| other: a word between two words | 13 | 565.47 ± 0.2% | 585.46 ± 0.3% | 923.89 ± 0.2% | 134.87 ± 0.3% | 505.99 ± 1.6% | 813.70 ± 0.2% | 15057.27 ± 0.5% | 564.18 ± 0.8% | 0.97 | 1.00 | 4.19 | 1.12 |
| other: a number before a unit, second text | 15 | 402.00 ± 0.3% | 438.00 ± 0.3% | 603.23 ± 0.3% | 39.19 ± 0.3% | 636.50 ± 0.8% | 891.02 ± 0.7% | 15389.68 ± 0.5% | 402.07 ± 0.4% | 0.92 | 1.00 | 10.26 | 0.63 |
| other: a heading's start tag | 13 | 360.21 ± 0.2% | 364.98 ± 0.2% | 476.17 ± 0.5% | 43.18 ± 0.3% | 626.09 ± 0.8% | 860.10 ± 0.1% | 18616.07 ± 0.4% | 359.83 ± 0.2% | 0.99 | 1.00 | 8.34 | 0.58 |
| other: a whole word | 11 | 596.10 ± 0.2% | 634.19 ± 0.6% | 1045.30 ± 0.4% | 119.81 ± 0.6% | 566.35 ± 1.5% | 826.10 ± 0.7% | 26937.59 ± 0.7% | 595.27 ± 0.4% | 0.94 | 1.00 | 4.98 | 1.05 |
| other: a line's first word, second text | 17 | 557.89 ± 0.1% | 578.07 ± 0.3% | 929.32 ± 0.1% | 127.77 ± 0.1% | 699.18 ± 1.0% | refused | refused | 555.90 ± 0.6% | 0.97 | 1.00 | 4.37 | 0.80 |
| other: fourteen octets before an x | 16 | 112.75 ± 0.4% | 162.59 ± 0.6% | 185.90 ± 0.9% | 15.05 ± 0.2% | 444.21 ± 1.3% | 426.13 ± 0.5% | 12793.70 ± 0.3% | 112.76 ± 0.2% | 0.69 | 1.00 | 7.49 | 0.25 |
| other: a Greek word | 8 | 445.73 ± 0.3% | 591.42 ± 0.4% | 962.07 ± 0.5% | 58.41 ± 0.2% | 1378.33 ± 1.3% | 1788.02 ± 0.6% | refused | 446.39 ± 0.3% | 0.75 | 1.00 | 7.63 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12871.90 ± 0.6% | not timed | not timed | 16259.21 ± 1.7% | 2076.45 ± 8.1% | not timed | not timed | 12856.98 ± 0.5% | | 1.00 | 0.79 | 6.20 |
| 01-literal/sherlock-casei-en | 522 | 3938.70 ± 0.7% | not timed | not timed | 3589.22 ± 1.1% | 32.43 ± 9.0% | not timed | not timed | 3929.98 ± 0.4% | | 1.00 | 1.10 | 121.45 |
| 01-literal/sherlock-ru | 724 | 13585.69 ± 0.4% | not timed | not timed | 17244.58 ± 0.8% | 1532.27 ± 19.5% | not timed | not timed | 13568.96 ± 0.2% | | 1.00 | 0.79 | 8.87 |
| 01-literal/sherlock-casei-ru | 746 | 5390.58 ± 0.3% | not timed | not timed | 3318.85 ± 0.1% | 30.73 ± 0.4% | not timed | not timed | 5393.11 ± 0.5% | | 1.00 | 1.62 | 175.41 |
| 01-literal/sherlock-zh | 30 | 16953.31 ± 0.5% | not timed | not timed | 18698.10 ± 0.7% | 2830.41 ± 11.0% | not timed | not timed | 16941.18 ± 0.8% | | 1.00 | 0.91 | 5.99 |
| 02-literal-alternate/sherlock-en | 714 | 5875.81 ± 0.4% | not timed | not timed | 3937.16 ± 0.3% | 16.64 ± 0.1% | not timed | not timed | 5884.15 ± 0.2% | | 1.00 | 1.49 | 353.04 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1703.28 ± 0.7% | not timed | not timed | 696.77 ± 0.3% | 10.96 ± 0.0% | not timed | not timed | 1696.92 ± 0.2% | | 1.00 | 2.44 | 155.35 |
| 02-literal-alternate/sherlock-ru | 899 | 4790.72 ± 0.2% | not timed | not timed | 3255.76 ± 0.1% | 22.69 ± 0.1% | not timed | not timed | 4789.88 ± 0.2% | | 1.00 | 1.47 | 211.10 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1813.95 ± 0.4% | not timed | not timed | 1231.63 ± 0.2% | 9.11 ± 0.2% | not timed | not timed | 1815.13 ± 0.2% | | 1.00 | 1.47 | 199.22 |
| 02-literal-alternate/sherlock-zh | 207 | 7063.09 ± 0.6% | not timed | not timed | 4154.18 ± 0.3% | 31.52 ± 0.1% | not timed | not timed | 7082.27 ± 0.3% | | 1.00 | 1.70 | 224.08 |
| 03-date/ascii | 111817 | 124.43 ± 0.7% | not timed | not timed | 95.83 ± 0.1% | 0.20 ± 4.2% | not timed | not timed | 123.73 ± 0.3% | | 1.01 | 1.30 | 614.70 |
| 04-ruff-noqa/real | 84 | 550.53 ± 0.1% | not timed | not timed | 458.55 ± 0.1% | 19.65 ± 1.3% | not timed | not timed | 551.26 ± 0.2% | | 1.00 | 1.20 | 28.02 |
| 04-ruff-noqa/tweaked | 44 | 554.56 ± 0.2% | not timed | not timed | 455.23 ± 0.1% | 364.71 ± 0.7% | not timed | not timed | 553.78 ± 0.2% | | 1.00 | 1.22 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.72 ± 0.6% | not timed | not timed | 5.10 ± 0.1% | 0.21 ± 5.3% | not timed | not timed | 3.72 ± 0.7% | | 1.00 | 0.73 | 18.06 |
| 06-cloud-flare-redos/original | 107 | 183.44 ± 0.5% | not timed | not timed | 215.21 ± 0.1% | 24.92 ± 0.1% | not timed | not timed | 183.16 ± 0.4% | | 1.00 | 0.85 | 7.36 |
| 06-cloud-flare-redos/simplified-short | 102 | 147.41 ± 0.1% | not timed | not timed | 228.88 ± 0.3% | 26.78 ± 0.5% | not timed | not timed | 147.29 ± 0.1% | | 1.00 | 0.64 | 5.51 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.86 ± 1.8% | not timed | not timed | 255.75 ± 0.2% | 28.85 ± 0.1% | not timed | not timed | 156.80 ± 2.0% | | 1.00 | 0.61 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 40.04 ± 0.3% | not timed | not timed | 172.44 ± 1.3% | 42.94 ± 6.3% | not timed | not timed | 39.94 ± 3.3% | | 1.00 | 0.23 | 0.93 |
| 08-words/all-english | 56691 | 103.49 ± 0.4% | not timed | not timed | 82.75 ± 0.1% | 11.95 ± 24.6% | not timed | not timed | 103.11 ± 0.3% | | 1.00 | 1.25 | 8.66 |
| 08-words/long-english | 839 | 998.17 ± 0.1% | not timed | not timed | 596.33 ± 0.1% | 32.54 ± 0.3% | not timed | not timed | 997.56 ± 0.1% | | 1.00 | 1.67 | 30.68 |
| 09-aws-keys/full | 0 | 420.28 ± 0.1% | not timed | not timed | 460.76 ± 0.1% | 64.82 ± 0.1% | not timed | not timed | 420.94 ± 0.1% | | 1.00 | 0.91 | 6.48 |
| 09-aws-keys/quick | 0 | 396.52 ± 0.1% | not timed | not timed | 983.92 ± 0.5% | 419.86 ± 0.9% | not timed | not timed | 400.39 ± 0.1% | | 0.99 | 0.40 | 0.94 |
| 10-bounded-repeat/letters-en | 1833 | 593.14 ± 0.4% | not timed | not timed | 516.66 ± 0.2% | 19.54 ± 0.8% | not timed | not timed | 592.02 ± 0.2% | | 1.00 | 1.15 | 30.36 |
| 10-bounded-repeat/letters-ru | 3475 | 403.29 ± 0.3% | not timed | not timed | 478.47 ± 0.1% | 22.34 ± 16.1% | not timed | not timed | 402.27 ± 0.7% | | 1.00 | 0.84 | 18.05 |
| 10-bounded-repeat/context | 53 | 73.56 ± 1.5% | not timed | not timed | 65.60 ± 0.6% | 19.55 ± 0.3% | not timed | not timed | 73.23 ± 0.7% | | 1.00 | 1.12 | 3.76 |
| 10-bounded-repeat/capitals | 11 | 1039.55 ± 0.2% | not timed | not timed | 615.47 ± 0.1% | 36.76 ± 0.1% | not timed | not timed | 1039.64 ± 0.1% | | 1.00 | 1.69 | 28.28 |
| 11-unstructured-to-json/extract | 600 | 24.55 ± 0.1% | not timed | not timed | 77.43 ± 0.2% | 48.99 ± 0.4% | not timed | not timed | 24.24 ± 0.9% | | 1.01 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 602.74 ± 0.7% | not timed | not timed | 560.40 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 601.84 ± 0.3% | | 1.00 | 1.08 | 1487.14 |
| 14-quadratic/1x | 100 | 12.62 ± 0.6% | not timed | not timed | 10.04 ± 0.3% | 0.98 ± 4.3% | not timed | not timed | 12.51 ± 1.9% | | 1.01 | 1.26 | 12.92 |
| 14-quadratic/2x | 200 | 7.78 ± 0.7% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 2.0% | not timed | not timed | 7.74 ± 2.1% | | 1.01 | 1.40 | 14.61 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.8% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 1.82 ± 0.5% | | 1.00 | 1.51 | 15.85 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 0.1% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 1.4% | not timed | not timed | 1.52 ± 1.3% | | 1.01 | 4.46 | 2.80 |
| 04-ruff-noqa/compile-real | 1 | 87.05 ± 0.1% | not timed | not timed | 13.85 ± 0.1% | 136.56 ± 4.5% | not timed | not timed | 86.85 ± 1.1% | | 1.00 | 6.28 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 14.34 ± 0.2% | not timed | not timed | 2.51 ± 0.4% | 6.34 ± 4.1% | not timed | not timed | 14.30 ± 0.7% | | 1.00 | 5.72 | 2.26 |
| 07-unicode-character-data/compile | 1 | 55.50 ± 0.3% | not timed | not timed | 26.07 ± 0.2% | 35.38 ± 1.4% | not timed | not timed | 55.05 ± 1.1% | | 1.01 | 2.13 | 1.57 |
| 09-aws-keys/compile-full | 1 | 42.37 ± 0.1% | not timed | not timed | 8.28 ± 0.6% | 22.92 ± 1.3% | not timed | not timed | 42.30 ± 0.3% | | 1.00 | 5.11 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 190.66 ± 0.1% | not timed | not timed | 47.20 ± 0.2% | 131.13 ± 2.6% | not timed | not timed | 190.22 ± 0.8% | | 1.00 | 4.04 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 14.60 ± 0.4% | not timed | not timed | 11.20 ± 0.1% | 15.62 ± 1.8% | not timed | not timed | 14.47 ± 1.0% | | 1.01 | 1.30 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 85.10 ± 1.9% | not timed | not timed | 8.03 ± 0.1% | 23.17 ± 2.9% | not timed | not timed | 84.74 ± 1.2% | | 1.00 | 10.59 | 3.67 |
| 11-unstructured-to-json/compile | 1 | 87.12 ± 0.3% | not timed | not timed | 40.78 ± 0.5% | 65.75 ± 0.9% | not timed | not timed | 86.85 ± 1.3% | | 1.00 | 2.14 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.9% | 0.09 ± 10.7% | not timed | not timed | 0.35 ± 2.5% | | 1.02 | 5.29 | 3.87 |

