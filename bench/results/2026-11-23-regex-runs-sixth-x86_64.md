# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148066797 |
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
| literal: a word | 217 | 32319.77 ± 0.4% | 1088.96 ± 0.3% | 32.18 ± 0.7% | 32823.85 ± 0.9% | 13035.65 ± 2.5% | 14.94 ± 0.7% | 106.99 ± 0.9% | 32322.05 ± 0.3% | 29.68 | 1.00 | 0.98 | 2.48 |
| literal: a word that is not there | 0 | 42812.11 ± 0.5% | 1100.86 ± 0.2% | 32.14 ± 2.1% | 36332.11 ± 0.0% | 40507.13 ± 0.1% | 14.47 ± 0.1% | 109.06 ± 0.7% | 42807.63 ± 0.1% | 38.89 | 1.00 | 1.18 | 1.06 |
| literal: one of four words | 661 | 13510.23 ± 1.3% | 1066.94 ± 2.5% | 18.58 ± 2.8% | 9773.33 ± 0.5% | 29.21 ± 1.2% | 4.33 ± 0.3% | 7.95 ± 0.3% | 13382.32 ± 0.5% | 12.66 | 1.01 | 1.38 | 462.52 |
| literal: a word in any case | 217 | 27559.55 ± 0.7% | 1088.71 ± 0.6% | 23.75 ± 3.6% | 10040.41 ± 1.0% | 58.45 ± 2.6% | refused | differs | 27468.76 ± 1.0% | 25.31 | 1.00 | 2.74 | 471.51 |
| literal: an href attribute | 33 | 27317.66 ± 1.2% | 1096.29 ± 0.4% | 29.07 ± 2.4% | 28051.14 ± 0.4% | 2584.12 ± 8.3% | 10.59 ± 0.3% | 100.98 ± 1.2% | 27270.80 ± 0.2% | 24.92 | 1.00 | 0.97 | 10.57 |
| literal: a word, second text | 123 | 33865.31 ± 1.7% | 1093.73 ± 0.0% | 31.86 ± 3.4% | 32840.01 ± 0.2% | 9201.14 ± 4.5% | 19.15 ± 0.2% | 95.08 ± 0.4% | 33814.81 ± 0.2% | 30.96 | 1.00 | 1.03 | 3.68 |
| class: two capitalized words | 1331 | 1023.85 ± 0.4% | 1013.87 ± 0.2% | 30.55 ± 2.6% | 613.07 ± 0.5% | 49.21 ± 1.4% | 12.65 ± 0.2% | 79.53 ± 0.7% | 1022.07 ± 0.4% | 1.01 | 1.00 | 1.67 | 20.80 |
| class: a word that ends in ing | 3399 | 925.00 ± 0.5% | 923.69 ± 0.3% | 19.77 ± 2.7% | 576.12 ± 0.1% | 35.58 ± 8.2% | 7.14 ± 0.5% | 21.88 ± 0.1% | 924.37 ± 0.6% | 1.00 | 1.00 | 1.61 | 26.00 |
| class: a word in capitals | 2332 | 1379.81 ± 0.9% | 991.29 ± 0.2% | 32.78 ± 1.2% | 604.63 ± 0.0% | 52.41 ± 11.9% | 15.31 ± 0.1% | 96.42 ± 0.5% | 1376.81 ± 0.1% | 1.39 | 1.00 | 2.28 | 26.33 |
| class: a number | 8288 | 1982.97 ± 0.1% | 859.40 ± 0.1% | 32.23 ± 1.2% | 2126.55 ± 0.4% | 52.62 ± 14.6% | 0.42 ± 0.1% | 75.89 ± 0.3% | 1981.19 ± 0.2% | 2.31 | 1.00 | 0.93 | 37.69 |
| class: two capitalized words, second text | 5359 | 763.70 ± 0.4% | 761.99 ± 0.1% | 28.17 ± 1.0% | 506.92 ± 0.2% | 40.57 ± 14.7% | 16.49 ± 0.1% | 72.76 ± 0.4% | 761.42 ± 0.1% | 1.00 | 1.00 | 1.51 | 18.82 |
| other: a word between two words | 6104 | 825.21 ± 0.4% | 796.61 ± 0.4% | 27.66 ± 1.2% | 877.96 ± 0.2% | 135.06 ± 12.5% | 9.58 ± 0.1% | 87.76 ± 0.4% | 826.13 ± 0.3% | 1.04 | 1.00 | 0.94 | 6.11 |
| other: a number before a unit, second text | 1481 | 9215.75 ± 1.9% | 1025.63 ± 0.1% | 30.91 ± 1.2% | 9554.37 ± 0.6% | 49.26 ± 17.9% | 17.33 ± 0.2% | 78.41 ± 0.8% | 9057.54 ± 1.0% | 8.99 | 1.02 | 0.96 | 187.08 |
| other: a heading's start tag | 110 | 20148.35 ± 0.3% | 1088.75 ± 0.1% | 31.72 ± 1.9% | 2689.05 ± 1.6% | 1909.31 ± 1.3% | 13.20 ± 0.4% | 116.70 ± 0.5% | 20130.96 ± 0.3% | 18.51 | 1.00 | 7.49 | 10.55 |
| other: a whole word | 217 | 25518.51 ± 0.2% | 1088.86 ± 0.2% | 33.06 ± 0.8% | 26294.35 ± 0.9% | 60.31 ± 0.4% | 12.60 ± 0.1% | 66.42 ± 0.5% | 25507.02 ± 0.4% | 23.44 | 1.00 | 0.97 | 423.10 |
| other: a line's first word, second text | 3716 | 2577.26 ± 0.8% | 914.27 ± 0.2% | 35.72 ± 0.6% | 2469.98 ± 0.8% | 82.19 ± 3.2% | refused | refused | 2565.16 ± 0.3% | 2.82 | 1.00 | 1.04 | 31.36 |
| other: fourteen octets before an x | 87 | 36072.73 ± 0.8% | 297.44 ± 1.0% | 7.63 ± 0.4% | 4135.49 ± 2.3% | 11.59 ± 0.6% | differs | 19.75 ± 2.3% | 36189.74 ± 0.5% | 121.28 | 1.00 | 8.72 | 3112.12 |
| other: a Greek word | 21815 | 539.47 ± 1.6% | 417.55 ± 0.1% | 36.44 ± 2.1% | 313.45 ± 0.7% | 63.08 ± 11.2% | differs | refused | 543.30 ± 0.5% | 1.29 | 0.99 | 1.72 | 8.55 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.19 ± 0.5% | 29.19 ± 0.5% | 1.08 ± 3.4% | 21.53 ± 0.7% | 3.22 ± 0.5% | differs | 4.81 ± 0.1% | 29.13 ± 0.7% | 1.00 | 1.00 | 1.36 | 9.05 |
| a UUID | 32895 | 26.38 ± 0.1% | 26.38 ± 0.2% | 0.74 ± 1.4% | 16.52 ± 0.1% | 3.23 ± 1.3% | 0.71 ± 0.2% | 3.94 ± 0.5% | 26.37 ± 0.2% | 1.00 | 1.00 | 1.60 | 8.16 |
| an IPv4 address | 33176 | 38.44 ± 0.6% | 38.32 ± 0.8% | 2.41 ± 0.3% | 31.57 ± 0.1% | 8.07 ± 0.2% | differs | 4.61 ± 0.3% | 38.23 ± 1.8% | 1.00 | 1.01 | 1.22 | 4.76 |
| a date and time | 32954 | 39.14 ± 0.3% | 39.11 ± 0.8% | 1.73 ± 1.5% | 23.78 ± 0.1% | 10.28 ± 0.6% | 1.30 ± 0.2% | 8.53 ± 0.2% | 39.23 ± 0.8% | 1.00 | 1.00 | 1.65 | 3.81 |
| a field path | 32606 | 31.47 ± 0.6% | 31.52 ± 0.7% | 1.24 ± 0.6% | 24.84 ± 0.1% | 3.71 ± 0.3% | differs | 3.13 ± 0.3% | 31.45 ± 0.9% | 1.00 | 1.00 | 1.27 | 8.49 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.28 ± 0.5% | 12.23 ± 0.3% | 12.27 ± 1.0% | 14.60 ± 1.2% | 6.80 ± 0.8% | 1.01 ± 0.4% | none | 12.30 ± 0.9% | 1.00 | 1.00 | 0.84 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 293.31 ± 0.9% | 294.74 ± 0.4% | 349.68 ± 0.2% | 117.15 ± 1.5% | 262.30 ± 9.0% | 696.77 ± 2.7% | 4025.03 ± 0.6% | 293.03 ± 0.8% | 1.00 | 1.00 | 2.50 | 1.12 |
| a UUID | 62 | 189.07 ± 0.3% | 189.68 ± 0.2% | 213.43 ± 0.2% | 61.86 ± 1.4% | 117.81 ± 1.0% | 250.98 ± 1.7% | 5542.66 ± 0.9% | 188.73 ± 0.4% | 1.00 | 1.00 | 3.06 | 1.60 |
| an IPv4 address | 29 | 565.33 ± 0.4% | 570.09 ± 0.8% | 826.67 ± 0.6% | 100.65 ± 0.3% | 156.09 ± 0.4% | 432.86 ± 0.4% | 10148.80 ± 1.3% | 564.99 ± 0.5% | 0.99 | 1.00 | 5.62 | 3.62 |
| a date and time | 56 | 442.70 ± 0.2% | 446.39 ± 0.6% | 581.12 ± 0.4% | 97.05 ± 0.9% | 164.84 ± 2.2% | 446.70 ± 1.9% | 5541.75 ± 1.4% | 442.46 ± 0.5% | 0.99 | 1.00 | 4.56 | 2.69 |
| a field path | 39 | 284.93 ± 0.2% | 285.82 ± 0.6% | 337.01 ± 0.4% | 105.89 ± 1.1% | 246.13 ± 0.9% | 711.12 ± 0.9% | 5346.05 ± 0.9% | 284.23 ± 0.3% | 1.00 | 1.00 | 2.69 | 1.16 |
| literal: a word | 7 | 884.55 ± 0.3% | 945.79 ± 0.5% | 1817.26 ± 0.8% | 717.51 ± 1.2% | 813.13 ± 1.0% | 1459.28 ± 0.4% | 36071.42 ± 0.6% | 883.40 ± 0.7% | 0.94 | 1.00 | 1.23 | 1.09 |
| literal: a word that is not there | 8 | 843.19 ± 0.3% | 911.24 ± 1.5% | 1707.45 ± 0.7% | 640.92 ± 0.4% | 773.46 ± 8.9% | 1375.17 ± 0.4% | 33890.88 ± 1.2% | 841.34 ± 0.3% | 0.93 | 1.00 | 1.32 | 1.09 |
| literal: one of four words | 26 | 336.30 ± 0.4% | 586.04 ± 0.6% | 838.96 ± 0.8% | 50.87 ± 0.7% | 299.62 ± 9.3% | 511.87 ± 2.0% | 16787.82 ± 0.6% | 336.76 ± 0.1% | 0.57 | 1.00 | 6.61 | 1.12 |
| literal: a word in any case | 11 | 669.55 ± 0.4% | 716.11 ± 0.2% | 1132.31 ± 0.4% | 17.89 ± 0.4% | 858.98 ± 1.0% | refused | 26742.79 ± 3.0% | 669.43 ± 0.3% | 0.93 | 1.00 | 37.42 | 0.78 |
| literal: an href attribute | 12 | 457.68 ± 0.2% | 476.13 ± 1.1% | 636.92 ± 1.1% | 50.13 ± 0.2% | 617.86 ± 10.6% | 1147.85 ± 1.0% | 25386.61 ± 5.3% | 458.97 ± 4.6% | 0.96 | 1.00 | 9.13 | 0.74 |
| literal: a word, second text | 10 | 789.57 ± 0.2% | 868.27 ± 0.8% | 1558.77 ± 0.3% | 597.71 ± 0.5% | 674.67 ± 2.2% | 1188.19 ± 0.5% | 30753.45 ± 2.2% | 789.34 ± 0.2% | 0.91 | 1.00 | 1.32 | 1.17 |
| class: two capitalized words | 23 | 633.82 ± 0.5% | 691.35 ± 0.2% | 1066.74 ± 0.2% | 137.24 ± 0.5% | 638.50 ± 13.5% | 1103.45 ± 0.7% | 6806.69 ± 0.9% | 633.39 ± 0.5% | 0.92 | 1.00 | 4.62 | 0.99 |
| class: a word that ends in ing | 9 | 756.61 ± 0.3% | 868.89 ± 0.6% | 1656.87 ± 0.2% | 172.92 ± 0.4% | 939.80 ± 1.8% | 1737.98 ± 1.0% | 18934.74 ± 1.7% | 756.61 ± 0.2% | 0.87 | 1.00 | 4.38 | 0.81 |
| class: a word in capitals | 16 | 677.54 ± 0.3% | 741.53 ± 0.2% | 1307.44 ± 0.5% | 182.19 ± 3.3% | 943.48 ± 0.8% | 1600.57 ± 0.5% | 9027.33 ± 1.5% | 677.69 ± 0.4% | 0.91 | 1.00 | 3.72 | 0.72 |
| class: a number | 6 | 821.89 ± 3.4% | 919.10 ± 0.2% | 1896.70 ± 4.0% | 44.56 ± 1.2% | 1748.33 ± 0.5% | 3020.81 ± 3.7% | 29332.90 ± 1.9% | 821.21 ± 0.2% | 0.89 | 1.00 | 18.44 | 0.47 |
| class: two capitalized words, second text | 23 | 633.49 ± 5.1% | 690.84 ± 0.2% | 1068.44 ± 0.2% | 136.34 ± 0.7% | 640.33 ± 2.9% | 1128.93 ± 0.5% | 6812.12 ± 1.1% | 634.94 ± 0.2% | 0.92 | 1.00 | 4.65 | 0.99 |
| other: a word between two words | 13 | 759.56 ± 3.2% | 792.08 ± 0.2% | 1334.14 ± 5.2% | 182.28 ± 0.8% | 627.82 ± 1.5% | 1204.47 ± 5.3% | 16919.37 ± 5.6% | 759.08 ± 0.2% | 0.96 | 1.00 | 4.17 | 1.21 |
| other: a number before a unit, second text | 15 | 529.87 ± 4.7% | 593.68 ± 0.3% | 852.21 ± 0.2% | 41.77 ± 0.5% | 797.14 ± 0.7% | 1357.63 ± 1.9% | 18268.96 ± 2.9% | 529.49 ± 0.2% | 0.89 | 1.00 | 12.69 | 0.66 |
| other: a heading's start tag | 13 | 472.40 ± 0.5% | 482.76 ± 0.5% | 645.78 ± 0.5% | 48.15 ± 0.4% | 779.07 ± 2.0% | 1316.68 ± 0.4% | 21568.16 ± 1.4% | 472.32 ± 1.1% | 0.98 | 1.00 | 9.81 | 0.61 |
| other: a whole word | 11 | 794.31 ± 0.4% | 853.77 ± 0.5% | 1509.66 ± 0.4% | 161.82 ± 0.4% | 724.94 ± 13.2% | 1252.77 ± 1.1% | 29692.84 ± 4.4% | 795.66 ± 0.4% | 0.93 | 1.00 | 4.91 | 1.10 |
| other: a line's first word, second text | 17 | 723.64 ± 1.6% | 759.12 ± 3.1% | 1304.38 ± 0.3% | 173.94 ± 0.3% | 880.44 ± 1.5% | refused | refused | 724.66 ± 0.4% | 0.95 | 1.00 | 4.16 | 0.82 |
| other: fourteen octets before an x | 16 | 132.09 ± 0.4% | 190.08 ± 0.5% | 223.71 ± 0.3% | 18.64 ± 0.2% | 553.29 ± 1.3% | 588.01 ± 0.7% | 15831.50 ± 0.9% | 132.32 ± 0.2% | 0.69 | 1.00 | 7.09 | 0.24 |
| other: a Greek word | 8 | 537.41 ± 2.0% | 762.77 ± 0.2% | 1328.85 ± 0.2% | 61.51 ± 0.1% | 1740.25 ± 1.0% | 2867.38 ± 0.6% | refused | 538.54 ± 1.0% | 0.70 | 1.00 | 8.74 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 24542.84 ± 0.2% | not timed | not timed | 29013.51 ± 0.5% | 3003.99 ± 12.5% | not timed | not timed | 24460.74 ± 0.6% | | 1.00 | 0.85 | 8.17 |
| 01-literal/sherlock-casei-en | 522 | 7507.63 ± 1.2% | not timed | not timed | 8478.97 ± 0.1% | 40.09 ± 0.4% | not timed | not timed | 7442.82 ± 4.5% | | 1.01 | 0.89 | 187.29 |
| 01-literal/sherlock-ru | 724 | 25016.41 ± 0.5% | not timed | not timed | 28369.24 ± 0.2% | 1641.62 ± 4.2% | not timed | not timed | 25001.25 ± 0.3% | | 1.00 | 0.88 | 15.24 |
| 01-literal/sherlock-casei-ru | 746 | 8641.51 ± 2.9% | not timed | not timed | 6490.08 ± 1.4% | 42.75 ± 0.2% | not timed | not timed | 8636.28 ± 0.3% | | 1.00 | 1.33 | 202.13 |
| 01-literal/sherlock-zh | 30 | 38561.73 ± 0.2% | not timed | not timed | 35264.25 ± 0.3% | 1612.75 ± 0.6% | not timed | not timed | 38516.91 ± 0.1% | | 1.00 | 1.09 | 23.91 |
| 02-literal-alternate/sherlock-en | 714 | 12165.04 ± 0.4% | not timed | not timed | 9446.16 ± 0.4% | 22.49 ± 0.6% | not timed | not timed | 12123.81 ± 0.3% | | 1.00 | 1.29 | 540.85 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2056.24 ± 0.9% | not timed | not timed | 2308.00 ± 0.4% | 13.66 ± 3.8% | not timed | not timed | 2038.26 ± 0.3% | | 1.01 | 0.89 | 150.53 |
| 02-literal-alternate/sherlock-ru | 899 | 7035.37 ± 4.6% | not timed | not timed | 5180.73 ± 0.2% | 29.11 ± 0.6% | not timed | not timed | 7030.26 ± 0.3% | | 1.00 | 1.36 | 241.68 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2185.57 ± 0.4% | not timed | not timed | 1254.89 ± 0.4% | 11.78 ± 2.0% | not timed | not timed | 2176.74 ± 0.3% | | 1.00 | 1.74 | 185.57 |
| 02-literal-alternate/sherlock-zh | 207 | 16577.14 ± 0.6% | not timed | not timed | 10780.95 ± 0.7% | 41.64 ± 0.9% | not timed | not timed | 16533.87 ± 0.2% | | 1.00 | 1.54 | 398.11 |
| 03-date/ascii | 111817 | 130.77 ± 1.3% | not timed | not timed | 110.49 ± 0.2% | 0.27 ± 5.0% | not timed | not timed | 130.08 ± 0.7% | | 1.01 | 1.18 | 492.52 |
| 04-ruff-noqa/real | 84 | 730.07 ± 0.6% | not timed | not timed | 567.33 ± 0.3% | 25.64 ± 1.7% | not timed | not timed | 729.62 ± 0.3% | | 1.00 | 1.29 | 28.47 |
| 04-ruff-noqa/tweaked | 44 | 620.85 ± 1.1% | not timed | not timed | 570.37 ± 0.6% | 390.94 ± 19.3% | not timed | not timed | 619.77 ± 0.5% | | 1.00 | 1.09 | 1.59 |
| 05-lexer-veryl/single | 124800 | 4.27 ± 3.4% | not timed | not timed | 5.74 ± 0.1% | 0.27 ± 5.2% | not timed | not timed | 4.28 ± 0.1% | | 1.00 | 0.74 | 15.72 |
| 06-cloud-flare-redos/original | 107 | 305.27 ± 0.7% | not timed | not timed | 262.57 ± 0.3% | 32.21 ± 0.8% | not timed | not timed | 305.16 ± 0.1% | | 1.00 | 1.16 | 9.48 |
| 06-cloud-flare-redos/simplified-short | 102 | 279.32 ± 0.4% | not timed | not timed | 266.79 ± 5.2% | 35.17 ± 8.5% | not timed | not timed | 279.31 ± 2.2% | | 1.00 | 1.05 | 7.94 |
| 06-cloud-flare-redos/simplified-long | 10000 | 296.39 ± 1.1% | not timed | not timed | 279.62 ± 0.4% | 37.90 ± 0.4% | not timed | not timed | 296.45 ± 0.1% | | 1.00 | 1.06 | 7.82 |
| 07-unicode-character-data/parse-line | 558784 | 277.07 ± 0.5% | not timed | not timed | 207.40 ± 0.5% | 53.85 ± 2.0% | not timed | not timed | 275.45 ± 0.6% | | 1.01 | 1.34 | 5.15 |
| 08-words/all-english | 56691 | 116.63 ± 0.5% | not timed | not timed | 92.66 ± 0.6% | 14.23 ± 4.0% | not timed | not timed | 116.34 ± 0.5% | | 1.00 | 1.26 | 8.20 |
| 08-words/long-english | 839 | 1049.88 ± 0.1% | not timed | not timed | 624.78 ± 0.2% | 38.02 ± 0.3% | not timed | not timed | 1049.31 ± 0.3% | | 1.00 | 1.68 | 27.62 |
| 09-aws-keys/full | 0 | 568.41 ± 1.3% | not timed | not timed | 581.87 ± 0.1% | 82.71 ± 2.5% | not timed | not timed | 568.60 ± 0.7% | | 1.00 | 0.98 | 6.87 |
| 09-aws-keys/quick | 0 | 1075.42 ± 4.6% | not timed | not timed | 904.74 ± 1.2% | 431.72 ± 3.3% | not timed | not timed | 1075.00 ± 1.6% | | 1.00 | 1.19 | 2.49 |
| 10-bounded-repeat/letters-en | 1833 | 634.22 ± 0.5% | not timed | not timed | 549.56 ± 0.7% | 24.21 ± 0.4% | not timed | not timed | 633.03 ± 0.4% | | 1.00 | 1.15 | 26.19 |
| 10-bounded-repeat/letters-ru | 3475 | 391.72 ± 0.3% | not timed | not timed | 493.19 ± 0.7% | 26.48 ± 19.4% | not timed | not timed | 391.05 ± 0.3% | | 1.00 | 0.79 | 14.79 |
| 10-bounded-repeat/context | 53 | 91.37 ± 1.0% | not timed | not timed | 73.85 ± 3.0% | 24.25 ± 0.2% | not timed | not timed | 91.25 ± 1.1% | | 1.00 | 1.24 | 3.77 |
| 10-bounded-repeat/capitals | 11 | 1089.40 ± 0.5% | not timed | not timed | 641.80 ± 0.1% | 44.44 ± 0.3% | not timed | not timed | 1086.23 ± 0.1% | | 1.00 | 1.70 | 24.51 |
| 11-unstructured-to-json/extract | 600 | 49.28 ± 0.1% | not timed | not timed | 80.82 ± 0.2% | 64.24 ± 1.7% | not timed | not timed | 49.22 ± 0.6% | | 1.00 | 0.61 | 0.77 |
| 12-dictionary/single | 1 | 569.82 ± 0.1% | not timed | not timed | 549.09 ± 0.2% | 0.52 ± 0.3% | not timed | not timed | 573.22 ± 0.2% | | 0.99 | 1.04 | 1088.47 |
| 14-quadratic/1x | 100 | 10.03 ± 0.3% | not timed | not timed | 13.51 ± 4.1% | 1.25 ± 1.6% | not timed | not timed | 10.03 ± 0.2% | | 1.00 | 0.74 | 8.00 |
| 14-quadratic/2x | 200 | 5.65 ± 0.3% | not timed | not timed | 6.62 ± 0.3% | 0.69 ± 0.9% | not timed | not timed | 5.62 ± 0.4% | | 1.00 | 0.85 | 8.14 |
| 14-quadratic/10x | 1000 | 1.25 ± 0.2% | not timed | not timed | 1.30 ± 0.5% | 0.15 ± 4.3% | not timed | not timed | 1.25 ± 0.3% | | 1.00 | 0.97 | 8.23 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.99 ± 0.6% | not timed | not timed | 0.45 ± 3.9% | 0.67 ± 2.5% | not timed | not timed | 1.99 ± 1.2% | | 1.00 | 4.41 | 2.97 |
| 04-ruff-noqa/compile-real | 1 | 128.90 ± 0.5% | not timed | not timed | 15.86 ± 0.2% | 176.48 ± 3.1% | not timed | not timed | 128.27 ± 2.3% | | 1.00 | 8.13 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 21.66 ± 2.1% | not timed | not timed | 3.06 ± 1.6% | 7.88 ± 2.6% | not timed | not timed | 21.58 ± 0.5% | | 1.00 | 7.08 | 2.75 |
| 07-unicode-character-data/compile | 1 | 77.51 ± 1.0% | not timed | not timed | 32.60 ± 0.5% | 44.43 ± 5.5% | not timed | not timed | 77.01 ± 0.9% | | 1.01 | 2.38 | 1.74 |
| 09-aws-keys/compile-full | 1 | 52.41 ± 0.3% | not timed | not timed | 9.04 ± 0.4% | 27.93 ± 13.0% | not timed | not timed | 52.22 ± 1.2% | | 1.00 | 5.80 | 1.88 |
| 09-aws-keys/compile-quick | 1 | 241.21 ± 0.3% | not timed | not timed | 59.86 ± 0.6% | 163.80 ± 4.9% | not timed | not timed | 240.31 ± 0.2% | | 1.00 | 4.03 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 16.71 ± 0.2% | not timed | not timed | 14.52 ± 0.5% | 20.91 ± 4.3% | not timed | not timed | 16.78 ± 0.5% | | 1.00 | 1.15 | 0.80 |
| 10-bounded-repeat/compile-capitals | 1 | 100.00 ± 0.5% | not timed | not timed | 10.98 ± 0.5% | 29.40 ± 2.6% | not timed | not timed | 99.03 ± 1.6% | | 1.01 | 9.11 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 118.37 ± 1.6% | not timed | not timed | 51.11 ± 0.4% | 83.57 ± 2.9% | not timed | not timed | 117.51 ± 1.1% | | 1.01 | 2.32 | 1.42 |
| 12-dictionary/compile-single | 1 | 0.38 ± 0.4% | not timed | not timed | 0.08 ± 12.7% | 0.11 ± 21.1% | not timed | not timed | 0.37 ± 1.5% | | 1.01 | 4.61 | 3.31 |

