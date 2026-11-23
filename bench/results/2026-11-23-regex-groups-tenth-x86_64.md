# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215399884 |
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
| literal: a word | 217 | 31970.62 ± 0.5% | 4096.41 ± 0.4% | 36.10 ± 0.8% | 32581.41 ± 0.5% | 12339.83 ± 8.6% | 14.75 ± 0.6% | 114.50 ± 0.4% | 31960.59 ± 0.8% | 7.80 | 1.00 | 0.98 | 2.59 |
| literal: a word that is not there | 0 | 42354.87 ± 0.4% | 4021.08 ± 0.7% | 36.01 ± 1.4% | 36123.76 ± 1.0% | 40092.68 ± 0.8% | 14.26 ± 0.5% | 109.35 ± 1.0% | 42342.97 ± 0.9% | 10.53 | 1.00 | 1.17 | 1.06 |
| literal: one of four words | 661 | 13251.12 ± 1.5% | 1942.51 ± 0.8% | 19.17 ± 0.1% | 9702.27 ± 0.6% | 29.08 ± 0.6% | 4.28 ± 0.3% | 9.63 ± 0.5% | 13106.52 ± 1.1% | 6.82 | 1.01 | 1.37 | 455.66 |
| literal: a word in any case | 217 | 27288.87 ± 1.1% | 2058.99 ± 0.5% | 25.53 ± 0.8% | 10006.27 ± 0.7% | 58.10 ± 0.9% | refused | differs | 27250.84 ± 0.3% | 13.25 | 1.00 | 2.73 | 469.69 |
| literal: an href attribute | 33 | 28036.66 ± 0.3% | 646.17 ± 0.2% | 30.41 ± 0.5% | 29058.39 ± 1.2% | 2573.66 ± 0.4% | 10.46 ± 0.5% | 101.03 ± 0.8% | 28045.87 ± 0.3% | 43.39 | 1.00 | 0.96 | 10.89 |
| literal: a word, second text | 123 | 33442.21 ± 1.6% | 3085.23 ± 0.3% | 35.51 ± 0.6% | 32560.42 ± 0.8% | 8942.44 ± 13.9% | 19.33 ± 0.4% | 98.75 ± 0.4% | 33585.02 ± 0.4% | 10.84 | 1.00 | 1.03 | 3.74 |
| class: two capitalized words | 1331 | 995.09 ± 0.4% | 632.10 ± 0.4% | 30.16 ± 0.5% | 610.83 ± 0.5% | 48.61 ± 10.6% | 12.51 ± 0.5% | 82.68 ± 0.7% | 992.32 ± 0.3% | 1.57 | 1.00 | 1.63 | 20.47 |
| class: a word that ends in ing | 3399 | 601.24 ± 0.5% | 600.66 ± 0.4% | 21.98 ± 1.4% | 574.54 ± 0.6% | 35.34 ± 13.3% | 7.14 ± 0.4% | 23.23 ± 0.6% | 600.90 ± 0.3% | 1.00 | 1.00 | 1.05 | 17.01 |
| class: a word in capitals | 2332 | 1353.05 ± 1.3% | 639.02 ± 0.4% | 35.63 ± 0.3% | 602.63 ± 0.3% | 52.34 ± 2.8% | 15.22 ± 0.2% | 106.77 ± 1.7% | 1349.02 ± 0.4% | 2.12 | 1.00 | 2.25 | 25.85 |
| class: a number | 8288 | 2068.53 ± 1.7% | 864.98 ± 0.3% | 34.96 ± 0.5% | 2120.57 ± 0.2% | 50.38 ± 16.5% | 0.42 ± 0.1% | 80.33 ± 0.7% | 2068.53 ± 1.9% | 2.39 | 1.00 | 0.98 | 41.06 |
| class: two capitalized words, second text | 5359 | 535.68 ± 0.7% | 543.03 ± 0.2% | 22.20 ± 0.8% | 507.12 ± 0.1% | 42.52 ± 11.5% | 16.52 ± 1.4% | 75.71 ± 0.3% | 535.21 ± 0.1% | 0.99 | 1.00 | 1.06 | 12.60 |
| other: a word between two words | 6104 | 855.04 ± 0.4% | 617.97 ± 0.2% | 27.91 ± 1.5% | 876.16 ± 0.1% | 134.36 ± 6.2% | 9.58 ± 0.3% | 87.79 ± 0.3% | 855.46 ± 0.4% | 1.38 | 1.00 | 0.98 | 6.36 |
| other: a number before a unit, second text | 1481 | 9208.39 ± 1.5% | 1152.35 ± 2.2% | 33.49 ± 2.0% | 9533.83 ± 0.9% | 49.15 ± 8.9% | 17.28 ± 0.2% | 78.80 ± 1.9% | 9093.69 ± 0.6% | 7.99 | 1.01 | 0.97 | 187.36 |
| other: a heading's start tag | 110 | 20667.50 ± 2.9% | 787.72 ± 0.0% | 35.16 ± 2.3% | 2701.00 ± 0.2% | 1910.24 ± 5.9% | 13.14 ± 0.9% | 119.95 ± 0.5% | 20628.21 ± 0.4% | 26.24 | 1.00 | 7.65 | 10.82 |
| other: a whole word | 217 | 25484.81 ± 0.6% | 639.75 ± 0.1% | 36.44 ± 0.4% | 26327.95 ± 0.1% | 60.52 ± 0.6% | 12.52 ± 0.3% | 68.63 ± 0.2% | 25514.97 ± 1.8% | 39.84 | 1.00 | 0.97 | 421.07 |
| other: a line's first word, second text | 3716 | 2525.81 ± 0.8% | 619.18 ± 0.1% | 39.64 ± 2.9% | 2436.70 ± 0.6% | 81.84 ± 3.3% | refused | refused | 2518.32 ± 0.7% | 4.08 | 1.00 | 1.04 | 30.86 |
| other: fourteen octets before an x | 87 | 36191.39 ± 0.5% | 311.55 ± 0.2% | 7.49 ± 0.5% | 4181.46 ± 0.4% | 11.63 ± 0.8% | differs | 20.91 ± 0.2% | 36009.96 ± 1.0% | 116.17 | 1.01 | 8.66 | 3111.72 |
| other: a Greek word | 21815 | 531.84 ± 0.3% | 411.91 ± 0.5% | 38.60 ± 0.7% | 313.00 ± 0.2% | 61.44 ± 13.0% | differs | refused | 531.44 ± 0.5% | 1.29 | 1.00 | 1.70 | 8.66 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.59 ± 1.1% | 23.58 ± 0.8% | 1.11 ± 0.8% | 21.39 ± 0.5% | 3.19 ± 1.7% | differs | 4.98 ± 0.8% | 23.53 ± 0.5% | 1.00 | 1.00 | 1.10 | 7.39 |
| a UUID | 32895 | 26.37 ± 0.2% | 26.42 ± 0.8% | 0.78 ± 3.4% | 16.32 ± 0.9% | 3.15 ± 2.0% | 0.70 ± 1.1% | 4.12 ± 2.2% | 26.36 ± 2.9% | 1.00 | 1.00 | 1.62 | 8.36 |
| an IPv4 address | 33176 | 38.33 ± 2.3% | 38.55 ± 0.5% | 2.46 ± 0.8% | 31.30 ± 0.8% | 8.07 ± 0.5% | differs | 4.90 ± 2.1% | 38.36 ± 0.9% | 0.99 | 1.00 | 1.22 | 4.75 |
| a date and time | 32954 | 38.64 ± 0.8% | 38.70 ± 0.8% | 1.81 ± 0.3% | 23.90 ± 0.6% | 10.26 ± 2.7% | 1.29 ± 0.5% | 9.25 ± 1.9% | 38.69 ± 1.5% | 1.00 | 1.00 | 1.62 | 3.77 |
| a field path | 32606 | 26.80 ± 0.5% | 26.78 ± 0.6% | 1.31 ± 0.8% | 24.79 ± 0.3% | 3.71 ± 0.7% | differs | 3.16 ± 0.6% | 26.76 ± 0.4% | 1.00 | 1.00 | 1.08 | 7.23 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.98 ± 1.8% | 13.01 ± 1.1% | 12.97 ± 0.7% | 14.68 ± 1.1% | 6.75 ± 1.9% | 1.02 ± 0.8% | none | 12.89 ± 0.9% | 1.00 | 1.01 | 0.88 | 1.92 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 293.86 ± 0.6% | 295.54 ± 0.2% | 344.68 ± 0.4% | 115.72 ± 1.3% | 264.92 ± 1.8% | 697.29 ± 4.1% | 4327.62 ± 3.5% | 293.65 ± 0.3% | 0.99 | 1.00 | 2.54 | 1.11 |
| a UUID | 62 | 190.67 ± 0.9% | 191.47 ± 0.5% | 212.87 ± 0.7% | 61.49 ± 0.8% | 119.36 ± 1.9% | 254.55 ± 2.2% | 5597.10 ± 0.8% | 190.35 ± 1.2% | 1.00 | 1.00 | 3.10 | 1.60 |
| an IPv4 address | 29 | 559.29 ± 0.8% | 566.26 ± 1.1% | 771.84 ± 0.8% | 99.63 ± 0.5% | 157.25 ± 1.2% | 436.93 ± 0.9% | 10247.30 ± 1.1% | 559.52 ± 0.8% | 0.99 | 1.00 | 5.61 | 3.56 |
| a date and time | 56 | 424.21 ± 0.4% | 426.77 ± 3.7% | 535.73 ± 0.8% | 96.19 ± 1.4% | 167.24 ± 6.7% | 451.50 ± 0.9% | 5592.35 ± 1.2% | 423.56 ± 3.1% | 0.99 | 1.00 | 4.41 | 2.54 |
| a field path | 39 | 285.84 ± 4.7% | 287.53 ± 0.5% | 333.69 ± 0.5% | 104.68 ± 1.5% | 247.17 ± 1.5% | 707.73 ± 2.4% | 5366.21 ± 0.9% | 285.92 ± 0.5% | 0.99 | 1.00 | 2.73 | 1.16 |
| literal: a word | 7 | 883.90 ± 3.8% | 948.55 ± 0.6% | 1645.55 ± 0.7% | 720.91 ± 2.7% | 787.78 ± 29.1% | 1436.54 ± 2.9% | 36935.43 ± 1.7% | 886.36 ± 0.7% | 0.93 | 1.00 | 1.23 | 1.12 |
| literal: a word that is not there | 8 | 841.36 ± 0.4% | 911.42 ± 0.6% | 1535.14 ± 0.8% | 644.52 ± 0.3% | 780.23 ± 1.5% | 1360.13 ± 1.6% | 35914.29 ± 2.6% | 841.85 ± 0.3% | 0.92 | 1.00 | 1.31 | 1.08 |
| literal: one of four words | 26 | 322.58 ± 0.4% | 549.02 ± 0.6% | 735.25 ± 0.4% | 50.44 ± 1.3% | 302.53 ± 27.3% | 514.26 ± 1.9% | 19274.34 ± 2.6% | 322.36 ± 0.5% | 0.59 | 1.00 | 6.40 | 1.07 |
| literal: a word in any case | 11 | 609.30 ± 3.0% | 645.93 ± 2.1% | 917.90 ± 0.4% | 17.75 ± 0.5% | 852.39 ± 0.6% | refused | 30248.12 ± 1.0% | 608.69 ± 0.2% | 0.94 | 1.00 | 34.33 | 0.71 |
| literal: an href attribute | 12 | 450.85 ± 0.8% | 464.04 ± 0.8% | 591.16 ± 0.5% | 49.79 ± 0.5% | 617.10 ± 1.4% | 1164.08 ± 0.3% | 26751.26 ± 0.8% | 452.08 ± 1.1% | 0.97 | 1.00 | 9.05 | 0.73 |
| literal: a word, second text | 10 | 772.36 ± 0.4% | 853.82 ± 0.4% | 1374.87 ± 0.5% | 605.84 ± 0.9% | 673.84 ± 1.4% | 1183.74 ± 0.2% | 32992.11 ± 6.7% | 773.10 ± 0.9% | 0.90 | 1.00 | 1.27 | 1.15 |
| class: two capitalized words | 23 | 633.25 ± 5.0% | 682.88 ± 0.1% | 991.20 ± 0.4% | 136.29 ± 1.2% | 632.90 ± 31.4% | 1118.55 ± 1.3% | 7691.29 ± 0.6% | 633.98 ± 0.3% | 0.93 | 1.00 | 4.65 | 1.00 |
| class: a word that ends in ing | 9 | 787.14 ± 3.3% | 888.06 ± 0.3% | 1545.29 ± 0.4% | 172.09 ± 2.0% | 939.78 ± 1.0% | 1746.85 ± 0.7% | 20204.01 ± 4.9% | 786.70 ± 0.6% | 0.89 | 1.00 | 4.57 | 0.84 |
| class: a word in capitals | 16 | 708.15 ± 2.8% | 770.78 ± 0.1% | 1259.06 ± 0.3% | 181.40 ± 4.3% | 936.13 ± 1.5% | 1623.28 ± 0.8% | 10168.43 ± 3.3% | 707.61 ± 0.3% | 0.92 | 1.00 | 3.90 | 0.76 |
| class: a number | 6 | 878.27 ± 0.3% | 979.21 ± 0.7% | 1840.81 ± 2.7% | 44.41 ± 2.0% | 1729.68 ± 1.2% | 3059.36 ± 4.5% | 30022.84 ± 0.4% | 878.04 ± 0.0% | 0.90 | 1.00 | 19.77 | 0.51 |
| class: two capitalized words, second text | 23 | 630.58 ± 0.7% | 681.22 ± 0.3% | 988.43 ± 0.5% | 135.32 ± 0.6% | 634.43 ± 0.7% | 1141.27 ± 1.9% | 7669.67 ± 0.3% | 633.34 ± 0.3% | 0.93 | 1.00 | 4.66 | 0.99 |
| other: a word between two words | 13 | 751.37 ± 0.9% | 783.98 ± 0.9% | 1211.14 ± 4.4% | 180.10 ± 3.8% | 623.45 ± 21.3% | 1226.85 ± 2.9% | 18298.17 ± 1.7% | 750.88 ± 0.6% | 0.96 | 1.00 | 4.17 | 1.21 |
| other: a number before a unit, second text | 15 | 541.17 ± 0.6% | 599.90 ± 4.8% | 821.17 ± 0.7% | 41.46 ± 0.6% | 787.35 ± 3.9% | 1378.73 ± 2.0% | 18851.92 ± 4.4% | 539.70 ± 0.2% | 0.90 | 1.00 | 13.05 | 0.69 |
| other: a heading's start tag | 13 | 460.36 ± 0.3% | 469.80 ± 0.4% | 603.98 ± 5.0% | 47.40 ± 0.5% | 767.67 ± 9.1% | 1326.78 ± 0.9% | 22615.79 ± 3.3% | 460.91 ± 1.0% | 0.98 | 1.00 | 9.71 | 0.60 |
| other: a whole word | 11 | 794.78 ± 1.2% | 839.36 ± 3.5% | 1347.31 ± 1.8% | 161.81 ± 1.0% | 716.67 ± 21.9% | 1255.68 ± 4.3% | 32853.95 ± 3.8% | 792.11 ± 0.5% | 0.95 | 1.00 | 4.91 | 1.11 |
| other: a line's first word, second text | 17 | 720.51 ± 0.4% | 751.62 ± 0.4% | 1195.91 ± 0.2% | 173.10 ± 0.2% | 877.40 ± 1.1% | refused | refused | 716.57 ± 0.5% | 0.96 | 1.01 | 4.16 | 0.82 |
| other: fourteen octets before an x | 16 | 129.11 ± 0.7% | 184.50 ± 0.5% | 210.14 ± 0.5% | 18.43 ± 0.6% | 546.93 ± 11.1% | 592.86 ± 1.4% | 16211.13 ± 0.9% | 129.00 ± 1.6% | 0.70 | 1.00 | 7.00 | 0.24 |
| other: a Greek word | 8 | 580.92 ± 5.7% | 809.27 ± 0.3% | 1314.25 ± 0.3% | 61.26 ± 0.1% | 1721.95 ± 1.7% | 2905.52 ± 1.0% | refused | 579.55 ± 0.4% | 0.72 | 1.00 | 9.48 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 24259.98 ± 0.8% | not timed | not timed | 27223.18 ± 0.5% | 2971.11 ± 12.4% | not timed | not timed | 24243.97 ± 0.8% | | 1.00 | 0.89 | 8.17 |
| 01-literal/sherlock-casei-en | 522 | 9477.74 ± 2.3% | not timed | not timed | 8436.00 ± 0.5% | 40.30 ± 0.5% | not timed | not timed | 9386.71 ± 1.2% | | 1.01 | 1.12 | 235.20 |
| 01-literal/sherlock-ru | 724 | 25167.40 ± 0.6% | not timed | not timed | 28734.64 ± 0.5% | 1628.89 ± 3.6% | not timed | not timed | 25092.12 ± 0.4% | | 1.00 | 0.88 | 15.45 |
| 01-literal/sherlock-casei-ru | 746 | 10997.78 ± 0.1% | not timed | not timed | 6538.76 ± 0.5% | 42.65 ± 0.4% | not timed | not timed | 10933.92 ± 0.7% | | 1.01 | 1.68 | 257.84 |
| 01-literal/sherlock-zh | 30 | 38188.95 ± 2.5% | not timed | not timed | 34897.38 ± 0.9% | 1614.14 ± 1.0% | not timed | not timed | 38159.47 ± 1.2% | | 1.00 | 1.09 | 23.66 |
| 02-literal-alternate/sherlock-en | 714 | 12107.96 ± 0.7% | not timed | not timed | 9383.65 ± 0.5% | 22.33 ± 0.8% | not timed | not timed | 12080.98 ± 0.2% | | 1.00 | 1.29 | 542.18 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2214.61 ± 1.2% | not timed | not timed | 2304.76 ± 0.5% | 13.59 ± 0.5% | not timed | not timed | 2198.67 ± 0.7% | | 1.01 | 0.96 | 162.95 |
| 02-literal-alternate/sherlock-ru | 899 | 9225.42 ± 0.5% | not timed | not timed | 5147.31 ± 0.7% | 29.00 ± 0.7% | not timed | not timed | 9213.69 ± 0.3% | | 1.00 | 1.79 | 318.15 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2360.96 ± 0.3% | not timed | not timed | 1245.34 ± 0.2% | 11.87 ± 0.5% | not timed | not timed | 2347.61 ± 0.7% | | 1.01 | 1.90 | 198.84 |
| 02-literal-alternate/sherlock-zh | 207 | 16410.66 ± 0.7% | not timed | not timed | 10718.08 ± 0.4% | 41.28 ± 1.2% | not timed | not timed | 16358.18 ± 0.5% | | 1.00 | 1.53 | 397.56 |
| 03-date/ascii | 111817 | 127.78 ± 1.5% | not timed | not timed | 109.72 ± 2.7% | 0.26 ± 4.0% | not timed | not timed | 127.01 ± 0.9% | | 1.01 | 1.16 | 482.21 |
| 04-ruff-noqa/real | 84 | 557.29 ± 0.7% | not timed | not timed | 562.03 ± 0.5% | 19.23 ± 1.0% | not timed | not timed | 555.59 ± 0.4% | | 1.00 | 0.99 | 28.98 |
| 04-ruff-noqa/tweaked | 44 | 623.52 ± 0.6% | not timed | not timed | 563.53 ± 2.3% | 370.61 ± 3.5% | not timed | not timed | 621.54 ± 0.8% | | 1.00 | 1.11 | 1.68 |
| 05-lexer-veryl/single | 124800 | 5.56 ± 0.6% | not timed | not timed | 5.75 ± 0.8% | 0.27 ± 4.3% | not timed | not timed | 5.53 ± 0.5% | | 1.01 | 0.97 | 20.91 |
| 06-cloud-flare-redos/original | 107 | 469.84 ± 0.8% | not timed | not timed | 259.49 ± 0.8% | 31.60 ± 0.8% | not timed | not timed | 469.96 ± 0.8% | | 1.00 | 1.81 | 14.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 419.89 ± 1.0% | not timed | not timed | 265.82 ± 0.3% | 31.59 ± 6.7% | not timed | not timed | 419.34 ± 4.8% | | 1.00 | 1.58 | 13.29 |
| 06-cloud-flare-redos/simplified-long | 10000 | 555.74 ± 0.5% | not timed | not timed | 277.74 ± 0.8% | 37.66 ± 0.6% | not timed | not timed | 555.33 ± 1.0% | | 1.00 | 2.00 | 14.75 |
| 07-unicode-character-data/parse-line | 558784 | 284.99 ± 0.7% | not timed | not timed | 206.36 ± 0.5% | 53.23 ± 2.7% | not timed | not timed | 285.64 ± 8.0% | | 1.00 | 1.38 | 5.35 |
| 08-words/all-english | 56691 | 113.11 ± 0.8% | not timed | not timed | 92.86 ± 2.0% | 14.07 ± 8.7% | not timed | not timed | 113.18 ± 0.5% | | 1.00 | 1.22 | 8.04 |
| 08-words/long-english | 839 | 643.26 ± 0.4% | not timed | not timed | 621.58 ± 0.7% | 37.80 ± 6.0% | not timed | not timed | 642.30 ± 0.7% | | 1.00 | 1.03 | 17.02 |
| 09-aws-keys/full | 0 | 567.31 ± 0.5% | not timed | not timed | 577.81 ± 0.3% | 81.67 ± 5.4% | not timed | not timed | 566.81 ± 1.1% | | 1.00 | 0.98 | 6.95 |
| 09-aws-keys/quick | 0 | 996.95 ± 4.1% | not timed | not timed | 879.17 ± 2.7% | 411.58 ± 3.2% | not timed | not timed | 1011.71 ± 1.1% | | 0.99 | 1.13 | 2.42 |
| 10-bounded-repeat/letters-en | 1833 | 609.93 ± 1.7% | not timed | not timed | 548.32 ± 0.6% | 24.13 ± 1.0% | not timed | not timed | 604.63 ± 2.6% | | 1.01 | 1.11 | 25.27 |
| 10-bounded-repeat/letters-ru | 3475 | 525.31 ± 1.3% | not timed | not timed | 491.58 ± 0.2% | 25.30 ± 24.5% | not timed | not timed | 521.55 ± 0.3% | | 1.01 | 1.07 | 20.76 |
| 10-bounded-repeat/context | 53 | 88.48 ± 0.9% | not timed | not timed | 73.45 ± 3.0% | 24.22 ± 1.6% | not timed | not timed | 88.50 ± 0.8% | | 1.00 | 1.20 | 3.65 |
| 10-bounded-repeat/capitals | 11 | 670.63 ± 8.4% | not timed | not timed | 640.23 ± 0.2% | 44.51 ± 0.2% | not timed | not timed | 669.46 ± 7.6% | | 1.00 | 1.05 | 15.07 |
| 11-unstructured-to-json/extract | 600 | 88.69 ± 1.1% | not timed | not timed | 81.16 ± 0.6% | 63.07 ± 0.9% | not timed | not timed | 87.94 ± 0.3% | | 1.01 | 1.09 | 1.41 |
| 12-dictionary/single | 1 | 572.36 ± 0.3% | not timed | not timed | 546.99 ± 0.2% | 0.52 ± 0.3% | not timed | not timed | 571.22 ± 0.4% | | 1.00 | 1.05 | 1092.21 |
| 14-quadratic/1x | 100 | 29.11 ± 3.6% | not timed | not timed | 13.50 ± 0.3% | 1.23 ± 2.5% | not timed | not timed | 29.01 ± 3.4% | | 1.00 | 2.16 | 23.57 |
| 14-quadratic/2x | 200 | 22.74 ± 0.4% | not timed | not timed | 6.60 ± 0.4% | 0.66 ± 0.6% | not timed | not timed | 22.73 ± 0.6% | | 1.00 | 3.45 | 34.35 |
| 14-quadratic/10x | 1000 | 7.08 ± 0.3% | not timed | not timed | 1.29 ± 0.3% | 0.15 ± 1.5% | not timed | not timed | 7.05 ± 0.3% | | 1.00 | 5.48 | 46.64 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.66 ± 0.8% | not timed | not timed | 0.45 ± 0.4% | 0.66 ± 1.5% | not timed | not timed | 1.66 ± 1.4% | | 1.00 | 3.72 | 2.51 |
| 04-ruff-noqa/compile-real | 1 | 119.24 ± 4.8% | not timed | not timed | 15.73 ± 0.6% | 175.62 ± 3.9% | not timed | not timed | 118.71 ± 0.4% | | 1.00 | 7.58 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 19.59 ± 0.3% | not timed | not timed | 3.03 ± 0.2% | 7.85 ± 2.7% | not timed | not timed | 19.55 ± 1.1% | | 1.00 | 6.47 | 2.50 |
| 07-unicode-character-data/compile | 1 | 72.07 ± 0.5% | not timed | not timed | 31.91 ± 0.3% | 43.97 ± 0.8% | not timed | not timed | 71.62 ± 1.5% | | 1.01 | 2.26 | 1.64 |
| 09-aws-keys/compile-full | 1 | 49.58 ± 0.2% | not timed | not timed | 9.02 ± 0.6% | 28.05 ± 0.3% | not timed | not timed | 49.57 ± 0.9% | | 1.00 | 5.50 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 225.30 ± 1.4% | not timed | not timed | 59.22 ± 0.1% | 161.83 ± 3.2% | not timed | not timed | 223.33 ± 0.6% | | 1.01 | 3.80 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 15.41 ± 0.3% | not timed | not timed | 14.47 ± 3.9% | 20.39 ± 5.3% | not timed | not timed | 15.34 ± 1.1% | | 1.00 | 1.07 | 0.76 |
| 10-bounded-repeat/compile-capitals | 1 | 96.15 ± 0.7% | not timed | not timed | 10.84 ± 1.2% | 29.28 ± 1.2% | not timed | not timed | 96.30 ± 1.1% | | 1.00 | 8.87 | 3.28 |
| 11-unstructured-to-json/compile | 1 | 108.91 ± 0.4% | not timed | not timed | 48.49 ± 0.9% | 82.99 ± 2.2% | not timed | not timed | 108.09 ± 0.7% | | 1.01 | 2.25 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.37 ± 0.3% | not timed | not timed | 0.08 ± 9.5% | 0.11 ± 18.7% | not timed | not timed | 0.37 ± 1.0% | | 1.00 | 4.79 | 3.37 |

