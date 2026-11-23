# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117687915 |
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
| literal: a word | 217 | 55620.20 ± 2.0% | 1248.92 ± 2.8% | 46.79 ± 2.5% | 53108.72 ± 7.8% | 16769.41 ± 5.7% | 15.99 ± 3.3% | 156.41 ± 5.0% | 55733.34 ± 2.3% | 44.53 | 1.00 | 1.05 | 3.32 |
| literal: a word that is not there | 0 | 80065.02 ± 2.8% | 1267.11 ± 4.0% | 46.14 ± 3.3% | 66420.59 ± 3.4% | 56241.24 ± 5.0% | 15.66 ± 4.6% | 145.57 ± 2.5% | 80061.20 ± 5.0% | 63.19 | 1.00 | 1.21 | 1.42 |
| literal: one of four words | 661 | 19754.89 ± 3.5% | 1224.03 ± 4.9% | 25.22 ± 4.2% | 14695.84 ± 5.1% | 38.93 ± 4.2% | 5.07 ± 1.7% | 12.75 ± 5.4% | 19465.95 ± 5.2% | 16.14 | 1.01 | 1.34 | 507.45 |
| literal: a word in any case | 217 | 49770.36 ± 3.4% | 1233.19 ± 5.1% | 33.77 ± 4.3% | 14728.21 ± 4.1% | 72.60 ± 6.7% | refused | differs | 49922.58 ± 3.9% | 40.36 | 1.00 | 3.38 | 685.56 |
| literal: an href attribute | 33 | 47265.35 ± 2.6% | 1273.70 ± 4.5% | 39.34 ± 3.4% | 47591.93 ± 1.7% | 3644.38 ± 3.9% | 11.41 ± 3.5% | 131.02 ± 3.5% | 46380.04 ± 5.1% | 37.11 | 1.02 | 0.99 | 12.97 |
| literal: a word, second text | 123 | 54217.50 ± 12.2% | 1235.01 ± 83.7% | 43.86 ± 6.5% | 48943.47 ± 7.2% | 15380.58 ± 7.7% | 21.60 ± 5.6% | 127.73 ± 6.7% | 53774.83 ± 3.7% | 43.90 | 1.01 | 1.11 | 3.53 |
| class: two capitalized words | 1331 | 1105.28 ± 1.8% | 1110.50 ± 1.5% | 39.83 ± 5.2% | 677.34 ± 1.9% | 60.36 ± 2.9% | 13.76 ± 2.8% | 102.62 ± 2.9% | 1103.68 ± 3.1% | 1.00 | 1.00 | 1.63 | 18.31 |
| class: a word that ends in ing | 3399 | 1028.79 ± 3.1% | 1024.43 ± 6.5% | 27.52 ± 6.9% | 648.07 ± 5.5% | 45.23 ± 12.0% | 8.00 ± 3.3% | 30.19 ± 5.1% | 1024.27 ± 6.4% | 1.00 | 1.00 | 1.59 | 22.74 |
| class: a word in capitals | 2332 | 1597.64 ± 7.5% | 1099.21 ± 33.5% | 43.01 ± 23.5% | 684.30 ± 4.1% | 65.20 ± 3.4% | 16.36 ± 3.9% | 132.98 ± 4.3% | 1619.84 ± 7.4% | 1.45 | 0.99 | 2.33 | 24.50 |
| class: a number | 8288 | 2439.57 ± 1.3% | 926.70 ± 2.8% | 42.11 ± 1.9% | 2226.97 ± 0.6% | 59.08 ± 17.0% | 0.44 ± 0.8% | 95.89 ± 4.7% | 2486.80 ± 2.1% | 2.63 | 0.98 | 1.10 | 41.29 |
| class: two capitalized words, second text | 5359 | 822.54 ± 3.7% | 827.22 ± 4.5% | 36.80 ± 4.6% | 579.85 ± 5.2% | 49.54 ± 11.7% | 17.82 ± 2.5% | 94.51 ± 8.6% | 830.11 ± 3.2% | 0.99 | 0.99 | 1.42 | 16.60 |
| other: a word between two words | 6104 | 970.41 ± 5.0% | 867.15 ± 4.5% | 35.12 ± 9.6% | 972.95 ± 2.7% | 164.72 ± 24.5% | 10.20 ± 22.0% | 109.88 ± 1.3% | 970.39 ± 3.9% | 1.12 | 1.00 | 1.00 | 5.89 |
| other: a number before a unit, second text | 1481 | 11803.64 ± 3.4% | 1139.56 ± 4.5% | 39.58 ± 47.0% | 10683.96 ± 3.3% | 59.42 ± 30.4% | 18.95 ± 2.0% | 103.00 ± 2.6% | 11667.37 ± 3.5% | 10.36 | 1.01 | 1.10 | 198.65 |
| other: a heading's start tag | 110 | 29490.87 ± 3.9% | 1206.97 ± 3.6% | 41.12 ± 4.4% | 3366.07 ± 3.0% | 2544.19 ± 13.9% | 13.76 ± 4.7% | 152.10 ± 4.5% | 29829.41 ± 1.3% | 24.43 | 0.99 | 8.76 | 11.59 |
| other: a whole word | 217 | 37508.20 ± 3.3% | 1212.24 ± 3.9% | 45.36 ± 2.4% | 36953.86 ± 4.8% | 75.87 ± 3.7% | 13.45 ± 3.8% | 83.25 ± 2.0% | 37313.48 ± 23.0% | 30.94 | 1.01 | 1.02 | 494.39 |
| other: a line's first word, second text | 3716 | 2891.48 ± 4.6% | 1000.94 ± 2.3% | 48.73 ± 5.0% | 3475.88 ± 6.3% | 99.63 ± 5.9% | refused | refused | 2933.77 ± 5.3% | 2.89 | 0.99 | 0.83 | 29.02 |
| other: fourteen octets before an x | 87 | 45116.42 ± 4.7% | 336.82 ± 3.2% | 8.85 ± 7.5% | 4822.84 ± 5.1% | 14.36 ± 3.7% | differs | 24.81 ± 8.2% | 45495.50 ± 4.6% | 133.95 | 0.99 | 9.35 | 3142.13 |
| other: a Greek word | 21815 | 613.32 ± 4.3% | 402.28 ± 9.0% | 48.08 ± 4.7% | 362.57 ± 4.4% | 68.98 ± 26.4% | differs | refused | 616.71 ± 5.2% | 1.52 | 0.99 | 1.69 | 8.89 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 34.78 ± 1.8% | 34.60 ± 3.5% | 1.42 ± 4.1% | 24.06 ± 4.4% | 3.56 ± 47.3% | differs | 5.69 ± 84.6% | 34.65 ± 3.4% | 1.00 | 1.00 | 1.45 | 9.76 |
| a UUID | 32895 | 29.66 ± 2.1% | 29.95 ± 2.9% | 1.00 ± 3.1% | 18.16 ± 5.2% | 3.60 ± 4.1% | 0.75 ± 4.1% | 4.58 ± 9.8% | 30.30 ± 2.8% | 0.99 | 0.98 | 1.63 | 8.23 |
| an IPv4 address | 33176 | 47.94 ± 3.3% | 49.01 ± 4.6% | 3.21 ± 6.7% | 34.74 ± 4.6% | 8.94 ± 3.6% | differs | 5.94 ± 3.8% | 48.34 ± 4.9% | 0.98 | 0.99 | 1.38 | 5.37 |
| a date and time | 32954 | 45.85 ± 10.3% | 45.46 ± 4.4% | 2.49 ± 4.3% | 26.16 ± 4.8% | 10.78 ± 7.5% | 1.31 ± 1.8% | 11.07 ± 5.5% | 45.59 ± 2.3% | 1.01 | 1.01 | 1.75 | 4.25 |
| a field path | 32606 | 37.51 ± 1.9% | 37.63 ± 1.4% | 1.72 ± 2.3% | 28.12 ± 4.0% | 4.85 ± 6.9% | differs | 4.02 ± 17.1% | 37.78 ± 2.0% | 1.00 | 0.99 | 1.33 | 7.73 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 14.72 ± 2.8% | 14.93 ± 14.5% | 14.61 ± 3.9% | 17.22 ± 3.7% | 7.57 ± 4.7% | 1.04 ± 6.6% | none | 14.79 ± 5.1% | 0.99 | 1.00 | 0.85 | 1.95 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 368.56 ± 5.4% | 374.76 ± 3.5% | 437.89 ± 8.0% | 133.94 ± 1.3% | 322.71 ± 19.5% | 857.98 ± 9.2% | 5772.08 ± 5.0% | 369.35 ± 4.8% | 0.98 | 1.00 | 2.75 | 1.14 |
| a UUID | 62 | 239.64 ± 1.0% | 241.76 ± 1.1% | 272.81 ± 3.6% | 74.07 ± 5.9% | 155.46 ± 12.5% | 308.77 ± 6.4% | 7017.82 ± 9.9% | 241.39 ± 1.4% | 0.99 | 0.99 | 3.24 | 1.54 |
| an IPv4 address | 29 | 745.40 ± 1.4% | 774.27 ± 4.1% | 1060.23 ± 2.4% | 120.68 ± 3.5% | 204.00 ± 1.3% | 537.78 ± 1.7% | 12899.63 ± 2.9% | 744.53 ± 5.3% | 0.96 | 1.00 | 6.18 | 3.65 |
| a date and time | 56 | 552.74 ± 3.7% | 547.59 ± 3.7% | 671.40 ± 3.9% | 115.55 ± 1.2% | 219.89 ± 20.4% | 564.70 ± 1.3% | 8215.04 ± 6.3% | 546.35 ± 4.1% | 1.01 | 1.01 | 4.78 | 2.51 |
| a field path | 39 | 372.65 ± 6.1% | 372.22 ± 5.2% | 427.71 ± 1.4% | 129.42 ± 6.4% | 314.12 ± 4.3% | 920.56 ± 6.8% | 7559.44 ± 3.3% | 380.31 ± 5.0% | 1.00 | 0.98 | 2.88 | 1.19 |
| literal: a word | 7 | 1175.01 ± 3.6% | 1282.28 ± 3.1% | 2233.95 ± 3.6% | 869.95 ± 11.6% | 1002.61 ± 8.2% | 1793.28 ± 4.7% | 49959.11 ± 1.6% | 1187.88 ± 5.4% | 0.92 | 0.99 | 1.35 | 1.17 |
| literal: a word that is not there | 8 | 1139.98 ± 4.0% | 1226.73 ± 5.2% | 2081.13 ± 2.5% | 805.93 ± 6.8% | 973.37 ± 2.0% | 1725.53 ± 3.5% | 48659.90 ± 5.4% | 1146.74 ± 5.3% | 0.93 | 0.99 | 1.41 | 1.17 |
| literal: one of four words | 26 | 427.23 ± 3.4% | 693.12 ± 3.5% | 906.34 ± 2.5% | 67.60 ± 6.7% | 384.32 ± 54.8% | 671.51 ± 3.5% | 24390.61 ± 4.9% | 429.46 ± 3.1% | 0.62 | 0.99 | 6.32 | 1.11 |
| literal: a word in any case | 11 | 896.64 ± 3.4% | 988.04 ± 5.5% | 1472.07 ± 5.3% | 23.01 ± 5.2% | 1060.22 ± 3.0% | refused | 37640.73 ± 5.6% | 879.55 ± 9.7% | 0.91 | 1.02 | 38.97 | 0.85 |
| literal: an href attribute | 12 | 597.30 ± 4.5% | 628.00 ± 1.9% | 813.33 ± 9.0% | 62.29 ± 4.4% | 765.22 ± 6.1% | 1461.76 ± 2.2% | 33349.04 ± 3.1% | 595.59 ± 3.2% | 0.95 | 1.00 | 9.59 | 0.78 |
| literal: a word, second text | 10 | 1027.17 ± 3.3% | 1154.92 ± 11.2% | 1888.72 ± 5.3% | 712.34 ± 4.7% | 774.77 ± 44.9% | 1521.77 ± 88.1% | 44825.44 ± 16.0% | 1016.99 ± 2.6% | 0.89 | 1.01 | 1.44 | 1.33 |
| class: two capitalized words | 23 | 835.31 ± 28.4% | 892.40 ± 40.2% | 1267.83 ± 6.1% | 162.92 ± 3.1% | 777.73 ± 6.1% | 1415.58 ± 2.2% | 9454.77 ± 6.0% | 842.45 ± 5.1% | 0.94 | 0.99 | 5.13 | 1.07 |
| class: a word that ends in ing | 9 | 1034.48 ± 3.8% | 1158.16 ± 4.6% | 1998.69 ± 3.9% | 206.88 ± 4.5% | 1098.85 ± 7.2% | 2227.97 ± 7.6% | 25507.00 ± 6.4% | 1047.25 ± 3.4% | 0.89 | 0.99 | 5.00 | 0.94 |
| class: a word in capitals | 16 | 921.88 ± 3.9% | 984.08 ± 3.5% | 1572.06 ± 2.4% | 209.56 ± 1.6% | 1179.98 ± 7.0% | 2060.62 ± 5.0% | 12972.95 ± 5.6% | 930.23 ± 5.7% | 0.94 | 0.99 | 4.40 | 0.78 |
| class: a number | 6 | 1144.11 ± 6.3% | 1238.68 ± 8.0% | 2257.11 ± 3.4% | 58.61 ± 2.6% | 2125.22 ± 5.8% | 3687.54 ± 1.9% | 36390.33 ± 4.0% | 1154.22 ± 3.7% | 0.92 | 0.99 | 19.52 | 0.54 |
| class: two capitalized words, second text | 23 | 843.16 ± 5.9% | 884.22 ± 3.5% | 1266.40 ± 5.3% | 159.51 ± 3.1% | 782.60 ± 4.5% | 1425.38 ± 1.9% | 9585.42 ± 3.3% | 839.35 ± 5.9% | 0.95 | 1.00 | 5.29 | 1.08 |
| other: a word between two words | 13 | 984.61 ± 2.7% | 1031.16 ± 5.5% | 1627.81 ± 5.5% | 210.94 ± 3.8% | 768.13 ± 3.8% | 1491.79 ± 3.1% | 23084.27 ± 0.8% | 987.03 ± 1.5% | 0.95 | 1.00 | 4.67 | 1.28 |
| other: a number before a unit, second text | 15 | 692.81 ± 8.1% | 785.40 ± 3.2% | 1088.25 ± 1.2% | 56.13 ± 2.0% | 949.24 ± 6.2% | 1751.08 ± 1.8% | 24377.28 ± 3.1% | 692.16 ± 3.9% | 0.88 | 1.00 | 12.34 | 0.73 |
| other: a heading's start tag | 13 | 626.44 ± 6.3% | 634.74 ± 6.4% | 836.09 ± 2.5% | 60.03 ± 3.3% | 948.84 ± 11.2% | 1649.47 ± 3.9% | 28392.59 ± 1.7% | 628.54 ± 2.1% | 0.99 | 1.00 | 10.43 | 0.66 |
| other: a whole word | 11 | 1000.69 ± 2.9% | 1094.49 ± 3.9% | 1810.26 ± 5.6% | 190.39 ± 4.3% | 905.72 ± 7.1% | 1612.02 ± 3.4% | 43028.90 ± 2.3% | 1008.87 ± 1.5% | 0.91 | 0.99 | 5.26 | 1.10 |
| other: a line's first word, second text | 17 | 996.29 ± 6.1% | 1044.78 ± 5.9% | 1665.86 ± 3.2% | 198.98 ± 1.9% | 1031.37 ± 7.3% | refused | refused | 989.76 ± 3.2% | 0.95 | 1.01 | 5.01 | 0.97 |
| other: fourteen octets before an x | 16 | 186.78 ± 1.4% | 271.63 ± 5.7% | 307.62 ± 5.3% | 22.36 ± 25.9% | 681.38 ± 6.1% | 738.04 ± 1.6% | 20542.52 ± 3.5% | 185.90 ± 2.1% | 0.69 | 1.00 | 8.35 | 0.27 |
| other: a Greek word | 8 | 742.92 ± 6.3% | 982.13 ± 4.6% | 1566.94 ± 4.0% | 74.01 ± 1.3% | 2071.76 ± 2.9% | 3391.71 ± 3.8% | refused | 753.98 ± 3.3% | 0.76 | 0.99 | 10.04 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34669.80 ± 4.7% | not timed | not timed | 43893.82 ± 3.5% | 3951.00 ± 29.8% | not timed | not timed | 34623.49 ± 3.6% | | 1.00 | 0.79 | 8.77 |
| 01-literal/sherlock-casei-en | 522 | 7430.06 ± 2.6% | not timed | not timed | 11516.99 ± 3.4% | 51.03 ± 19.0% | not timed | not timed | 7422.99 ± 2.4% | | 1.00 | 0.65 | 145.60 |
| 01-literal/sherlock-ru | 724 | 35450.28 ± 4.3% | not timed | not timed | 43207.81 ± 15.6% | 2430.65 ± 5.6% | not timed | not timed | 35530.70 ± 6.0% | | 1.00 | 0.82 | 14.58 |
| 01-literal/sherlock-casei-ru | 746 | 11128.53 ± 5.8% | not timed | not timed | 9233.68 ± 3.4% | 56.76 ± 2.2% | not timed | not timed | 11106.87 ± 4.7% | | 1.00 | 1.21 | 196.05 |
| 01-literal/sherlock-zh | 30 | 73258.84 ± 2.9% | not timed | not timed | 59059.52 ± 4.2% | 2125.10 ± 8.0% | not timed | not timed | 72858.91 ± 3.6% | | 1.01 | 1.24 | 34.47 |
| 02-literal-alternate/sherlock-en | 714 | 15991.96 ± 7.3% | not timed | not timed | 13341.81 ± 5.3% | 29.45 ± 6.0% | not timed | not timed | 15986.11 ± 4.3% | | 1.00 | 1.20 | 543.10 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2867.63 ± 5.3% | not timed | not timed | 2908.61 ± 2.2% | 17.76 ± 4.0% | not timed | not timed | 2769.85 ± 5.9% | | 1.04 | 0.99 | 161.43 |
| 02-literal-alternate/sherlock-ru | 899 | 9144.73 ± 1.7% | not timed | not timed | 7409.32 ± 3.7% | 37.28 ± 22.2% | not timed | not timed | 9089.97 ± 4.5% | | 1.01 | 1.23 | 245.33 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2542.37 ± 71.7% | not timed | not timed | 1419.22 ± 4.3% | 16.26 ± 2.9% | not timed | not timed | 2532.29 ± 3.9% | | 1.00 | 1.79 | 156.39 |
| 02-literal-alternate/sherlock-zh | 207 | 23033.75 ± 5.4% | not timed | not timed | 15619.79 ± 3.6% | 53.10 ± 2.9% | not timed | not timed | 23189.14 ± 6.0% | | 0.99 | 1.47 | 433.74 |
| 03-date/ascii | 111817 | 150.54 ± 4.6% | not timed | not timed | 126.20 ± 4.0% | 0.31 ± 10.1% | not timed | not timed | 153.74 ± 2.6% | | 0.98 | 1.19 | 491.15 |
| 04-ruff-noqa/real | 84 | 851.11 ± 8.3% | not timed | not timed | 678.90 ± 3.4% | 29.02 ± 4.4% | not timed | not timed | 862.69 ± 4.9% | | 0.99 | 1.25 | 29.33 |
| 04-ruff-noqa/tweaked | 44 | 776.23 ± 4.5% | not timed | not timed | 685.92 ± 5.6% | 477.81 ± 17.3% | not timed | not timed | 799.53 ± 6.8% | | 0.97 | 1.13 | 1.62 |
| 05-lexer-veryl/single | 124800 | 5.66 ± 4.0% | not timed | not timed | 7.68 ± 7.5% | 0.35 ± 7.8% | not timed | not timed | 5.82 ± 7.0% | | 0.97 | 0.74 | 16.18 |
| 06-cloud-flare-redos/original | 107 | 279.55 ± 4.6% | not timed | not timed | 288.24 ± 3.8% | 38.29 ± 7.0% | not timed | not timed | 268.48 ± 8.1% | | 1.04 | 0.97 | 7.30 |
| 06-cloud-flare-redos/simplified-short | 102 | 207.14 ± 3.1% | not timed | not timed | 299.14 ± 2.7% | 41.86 ± 3.6% | not timed | not timed | 211.52 ± 3.0% | | 0.98 | 0.69 | 4.95 |
| 06-cloud-flare-redos/simplified-long | 10000 | 240.35 ± 4.7% | not timed | not timed | 319.01 ± 3.6% | 45.25 ± 2.1% | not timed | not timed | 238.43 ± 3.8% | | 1.01 | 0.75 | 5.31 |
| 07-unicode-character-data/parse-line | 558784 | 351.07 ± 6.8% | not timed | not timed | 263.48 ± 2.3% | 67.50 ± 4.2% | not timed | not timed | 340.85 ± 12.3% | | 1.03 | 1.33 | 5.20 |
| 08-words/all-english | 56691 | 120.11 ± 4.6% | not timed | not timed | 99.39 ± 2.9% | 19.36 ± 14.8% | not timed | not timed | 125.77 ± 5.2% | | 0.95 | 1.21 | 6.21 |
| 08-words/long-english | 839 | 1171.45 ± 2.9% | not timed | not timed | 697.00 ± 3.8% | 49.05 ± 6.9% | not timed | not timed | 1169.72 ± 4.1% | | 1.00 | 1.68 | 23.88 |
| 09-aws-keys/full | 0 | 685.20 ± 8.1% | not timed | not timed | 721.90 ± 5.5% | 94.06 ± 10.5% | not timed | not timed | 677.27 ± 4.7% | | 1.01 | 0.95 | 7.28 |
| 09-aws-keys/quick | 0 | 1298.97 ± 7.5% | not timed | not timed | 1252.84 ± 4.3% | 566.32 ± 29.9% | not timed | not timed | 1300.72 ± 4.1% | | 1.00 | 1.04 | 2.29 |
| 10-bounded-repeat/letters-en | 1833 | 699.21 ± 6.8% | not timed | not timed | 742.16 ± 6.4% | 30.02 ± 16.1% | not timed | not timed | 718.17 ± 5.9% | | 0.97 | 0.94 | 23.29 |
| 10-bounded-repeat/letters-ru | 3475 | 437.61 ± 5.4% | not timed | not timed | 650.52 ± 6.9% | 30.38 ± 16.8% | not timed | not timed | 444.80 ± 2.7% | | 0.98 | 0.67 | 14.40 |
| 10-bounded-repeat/context | 53 | 108.66 ± 4.3% | not timed | not timed | 90.95 ± 3.7% | 29.35 ± 6.4% | not timed | not timed | 109.70 ± 2.4% | | 0.99 | 1.19 | 3.70 |
| 10-bounded-repeat/capitals | 11 | 1227.48 ± 1.6% | not timed | not timed | 716.11 ± 3.1% | 53.30 ± 4.7% | not timed | not timed | 1225.76 ± 1.8% | | 1.00 | 1.71 | 23.03 |
| 11-unstructured-to-json/extract | 600 | 58.89 ± 5.9% | not timed | not timed | 103.38 ± 1.0% | 74.81 ± 2.2% | not timed | not timed | 58.78 ± 2.3% | | 1.00 | 0.57 | 0.79 |
| 12-dictionary/single | 1 | 645.42 ± 5.1% | not timed | not timed | 623.00 ± 4.7% | 0.64 ± 5.0% | not timed | not timed | 646.75 ± 13.2% | | 1.00 | 1.04 | 1008.61 |
| 14-quadratic/1x | 100 | 16.33 ± 3.3% | not timed | not timed | 17.20 ± 1.8% | 1.42 ± 20.0% | not timed | not timed | 16.58 ± 4.7% | | 0.99 | 0.95 | 11.48 |
| 14-quadratic/2x | 200 | 9.65 ± 2.1% | not timed | not timed | 7.93 ± 5.2% | 0.78 ± 9.0% | not timed | not timed | 9.64 ± 4.1% | | 1.00 | 1.22 | 12.30 |
| 14-quadratic/10x | 1000 | 2.16 ± 6.5% | not timed | not timed | 1.46 ± 5.9% | 0.17 ± 6.7% | not timed | not timed | 2.13 ± 7.1% | | 1.02 | 1.48 | 12.94 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.39 ± 2.3% | not timed | not timed | 0.53 ± 4.5% | 0.81 ± 7.7% | not timed | not timed | 2.40 ± 3.2% | | 0.99 | 4.54 | 2.95 |
| 04-ruff-noqa/compile-real | 1 | 159.46 ± 9.2% | not timed | not timed | 21.18 ± 3.0% | 225.18 ± 10.5% | not timed | not timed | 160.08 ± 2.2% | | 1.00 | 7.53 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 23.48 ± 6.4% | not timed | not timed | 3.87 ± 5.0% | 10.67 ± 11.2% | not timed | not timed | 23.76 ± 5.7% | | 0.99 | 6.06 | 2.20 |
| 07-unicode-character-data/compile | 1 | 93.26 ± 2.4% | not timed | not timed | 38.58 ± 4.8% | 57.21 ± 8.4% | not timed | not timed | 92.86 ± 2.0% | | 1.00 | 2.42 | 1.63 |
| 09-aws-keys/compile-full | 1 | 64.02 ± 6.5% | not timed | not timed | 12.45 ± 2.7% | 36.50 ± 21.0% | not timed | not timed | 63.87 ± 5.8% | | 1.00 | 5.14 | 1.75 |
| 09-aws-keys/compile-quick | 1 | 296.37 ± 3.4% | not timed | not timed | 76.53 ± 6.2% | 210.82 ± 9.4% | not timed | not timed | 294.65 ± 2.4% | | 1.01 | 3.87 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 23.39 ± 1.0% | not timed | not timed | 17.33 ± 4.3% | 25.83 ± 3.6% | not timed | not timed | 22.85 ± 2.7% | | 1.02 | 1.35 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 131.36 ± 4.5% | not timed | not timed | 12.68 ± 1.5% | 37.39 ± 4.5% | not timed | not timed | 132.20 ± 5.8% | | 0.99 | 10.36 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 144.66 ± 5.5% | not timed | not timed | 63.54 ± 4.2% | 109.32 ± 11.2% | not timed | not timed | 141.62 ± 6.0% | | 1.02 | 2.28 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.46 ± 3.8% | not timed | not timed | 0.10 ± 26.5% | 0.13 ± 10.2% | not timed | not timed | 0.46 ± 4.4% | | 1.01 | 4.81 | 3.48 |

