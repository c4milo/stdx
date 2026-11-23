# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148082327 |
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
| literal: a word | 217 | 55870.88 ± 5.5% | 1273.01 ± 5.7% | 47.57 ± 2.4% | 54071.71 ± 2.4% | 16061.86 ± 3.5% | 16.85 ± 1.4% | 158.10 ± 2.4% | 55923.05 ± 6.5% | 43.89 | 1.00 | 1.03 | 3.48 |
| literal: a word that is not there | 0 | 82788.82 ± 5.3% | 1284.88 ± 2.0% | 45.72 ± 1.9% | 66560.50 ± 5.6% | 57586.70 ± 2.5% | 16.45 ± 2.2% | 145.52 ± 4.0% | 82186.99 ± 5.8% | 64.43 | 1.01 | 1.24 | 1.44 |
| literal: one of four words | 661 | 19142.40 ± 6.0% | 1236.72 ± 3.4% | 25.40 ± 5.1% | 14967.55 ± 22.2% | 39.54 ± 6.8% | 5.29 ± 2.4% | 12.94 ± 11.7% | 19858.07 ± 4.0% | 15.48 | 0.96 | 1.28 | 484.12 |
| literal: a word in any case | 217 | 49984.03 ± 3.7% | 1274.05 ± 2.0% | 34.51 ± 2.2% | 14967.90 ± 4.5% | 74.97 ± 6.6% | refused | differs | 49897.19 ± 2.3% | 39.23 | 1.00 | 3.34 | 666.73 |
| literal: an href attribute | 33 | 47293.94 ± 5.3% | 1249.72 ± 4.2% | 38.89 ± 5.3% | 46580.21 ± 5.6% | 3643.07 ± 3.8% | 11.90 ± 5.9% | 128.94 ± 4.2% | 47572.59 ± 4.6% | 37.84 | 0.99 | 1.02 | 12.98 |
| literal: a word, second text | 123 | 56665.61 ± 4.2% | 1243.55 ± 3.9% | 42.72 ± 5.5% | 50026.58 ± 5.2% | 14456.02 ± 3.7% | 21.20 ± 7.9% | 124.48 ± 6.6% | 54203.91 ± 35.0% | 45.57 | 1.05 | 1.13 | 3.92 |
| class: two capitalized words | 1331 | 1110.41 ± 11.3% | 1131.04 ± 21.2% | 41.58 ± 5.2% | 700.02 ± 3.7% | 60.78 ± 6.3% | 13.93 ± 10.0% | 105.72 ± 4.6% | 1088.69 ± 9.3% | 0.98 | 1.02 | 1.59 | 18.27 |
| class: a word that ends in ing | 3399 | 1064.00 ± 3.1% | 1050.29 ± 4.1% | 28.69 ± 2.7% | 659.83 ± 3.6% | 45.78 ± 8.5% | 8.26 ± 5.0% | 29.66 ± 3.7% | 1073.32 ± 2.3% | 1.01 | 0.99 | 1.61 | 23.24 |
| class: a word in capitals | 2332 | 1668.05 ± 8.5% | 1151.57 ± 6.2% | 43.61 ± 6.1% | 690.44 ± 5.9% | 62.65 ± 21.8% | 16.87 ± 4.4% | 135.72 ± 8.0% | 1599.30 ± 5.6% | 1.45 | 1.04 | 2.42 | 26.62 |
| class: a number | 8288 | 2585.71 ± 5.8% | 1006.03 ± 7.7% | 43.48 ± 4.6% | 2443.12 ± 1.0% | 62.08 ± 13.4% | 0.47 ± 1.4% | 97.71 ± 19.0% | 2612.49 ± 2.5% | 2.57 | 0.99 | 1.06 | 41.65 |
| class: two capitalized words, second text | 5359 | 849.76 ± 4.7% | 849.25 ± 3.2% | 36.99 ± 3.6% | 579.85 ± 4.8% | 51.18 ± 7.9% | 18.01 ± 4.8% | 96.26 ± 4.4% | 859.29 ± 4.1% | 1.00 | 0.99 | 1.47 | 16.60 |
| other: a word between two words | 6104 | 1099.15 ± 3.6% | 921.59 ± 5.8% | 36.00 ± 5.2% | 1008.71 ± 29.5% | 167.63 ± 11.3% | 10.89 ± 4.9% | 110.93 ± 10.7% | 1109.77 ± 1.2% | 1.19 | 0.99 | 1.09 | 6.56 |
| other: a number before a unit, second text | 1481 | 13270.85 ± 2.2% | 1213.63 ± 1.4% | 42.55 ± 2.0% | 11419.25 ± 1.9% | 62.30 ± 10.5% | 19.62 ± 1.0% | 109.32 ± 6.8% | 13106.03 ± 11.0% | 10.93 | 1.01 | 1.16 | 213.02 |
| other: a heading's start tag | 110 | 31312.48 ± 3.4% | 1266.18 ± 1.5% | 42.71 ± 2.4% | 3485.88 ± 7.4% | 2542.16 ± 12.3% | 15.03 ± 5.0% | 158.36 ± 2.3% | 31341.40 ± 3.2% | 24.73 | 1.00 | 8.98 | 12.32 |
| other: a whole word | 217 | 38857.40 ± 6.9% | 1272.28 ± 3.5% | 47.48 ± 10.9% | 37978.50 ± 9.4% | 79.06 ± 0.6% | 14.63 ± 0.5% | 87.34 ± 0.7% | 38398.90 ± 2.0% | 30.54 | 1.01 | 1.02 | 491.51 |
| other: a line's first word, second text | 3716 | 3508.40 ± 4.5% | 1064.37 ± 1.8% | 50.71 ± 5.8% | 3668.15 ± 2.4% | 105.34 ± 3.4% | refused | refused | 3486.15 ± 4.6% | 3.30 | 1.01 | 0.96 | 33.31 |
| other: fourteen octets before an x | 87 | 48116.33 ± 5.0% | 345.77 ± 2.5% | 10.27 ± 3.4% | 5012.93 ± 2.4% | 14.98 ± 3.5% | differs | 26.50 ± 6.2% | 48202.62 ± 4.6% | 139.16 | 1.00 | 9.60 | 3212.15 |
| other: a Greek word | 21815 | 626.83 ± 2.3% | 498.58 ± 1.5% | 50.05 ± 3.3% | 379.54 ± 4.2% | 74.67 ± 26.5% | differs | refused | 624.64 ± 0.6% | 1.26 | 1.00 | 1.65 | 8.40 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 36.45 ± 1.1% | 36.25 ± 2.9% | 1.60 ± 0.8% | 25.25 ± 6.1% | 3.74 ± 3.5% | differs | 6.03 ± 4.2% | 36.17 ± 0.9% | 1.01 | 1.01 | 1.44 | 9.76 |
| a UUID | 32895 | 30.72 ± 2.9% | 30.63 ± 1.7% | 1.09 ± 1.8% | 19.25 ± 0.3% | 3.78 ± 1.6% | 0.77 ± 1.1% | 4.98 ± 6.8% | 30.67 ± 1.6% | 1.00 | 1.00 | 1.60 | 8.12 |
| an IPv4 address | 33176 | 50.32 ± 4.3% | 50.22 ± 4.9% | 3.49 ± 1.0% | 36.82 ± 0.8% | 9.61 ± 1.3% | differs | 6.35 ± 2.0% | 50.22 ± 0.6% | 1.00 | 1.00 | 1.37 | 5.23 |
| a date and time | 32954 | 46.29 ± 1.4% | 46.37 ± 2.6% | 2.62 ± 1.1% | 27.68 ± 0.2% | 11.29 ± 2.8% | 1.36 ± 0.2% | 11.38 ± 9.9% | 43.43 ± 3.2% | 1.00 | 1.07 | 1.67 | 4.10 |
| a field path | 32606 | 39.70 ± 3.0% | 39.52 ± 2.7% | 1.86 ± 4.2% | 29.15 ± 2.6% | 4.92 ± 4.9% | differs | 4.33 ± 2.4% | 39.34 ± 3.1% | 1.00 | 1.01 | 1.36 | 8.07 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 13.54 ± 7.4% | 13.90 ± 27.2% | 13.61 ± 6.7% | 17.56 ± 6.7% | 7.97 ± 4.4% | 1.10 ± 1.7% | none | 14.04 ± 1.1% | 0.97 | 0.96 | 0.77 | 1.70 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 381.06 ± 4.9% | 385.99 ± 1.9% | 450.03 ± 3.4% | 139.59 ± 1.9% | 341.11 ± 2.9% | 912.50 ± 3.8% | 5998.55 ± 20.9% | 386.39 ± 1.4% | 0.99 | 0.99 | 2.73 | 1.12 |
| a UUID | 62 | 246.83 ± 2.7% | 248.22 ± 5.3% | 275.69 ± 7.6% | 77.57 ± 7.3% | 165.11 ± 6.1% | 319.73 ± 4.2% | 7535.01 ± 7.6% | 249.55 ± 3.9% | 0.99 | 0.99 | 3.18 | 1.49 |
| an IPv4 address | 29 | 774.86 ± 26.6% | 772.91 ± 24.6% | 1050.24 ± 8.4% | 126.89 ± 6.9% | 206.06 ± 11.5% | 562.74 ± 36.1% | 12958.29 ± 4.3% | 753.59 ± 6.9% | 1.00 | 1.03 | 6.11 | 3.76 |
| a date and time | 56 | 551.35 ± 1.2% | 554.56 ± 0.9% | 665.46 ± 22.8% | 118.93 ± 7.1% | 223.04 ± 2.7% | 575.12 ± 4.8% | 8114.28 ± 18.0% | 538.01 ± 3.3% | 0.99 | 1.02 | 4.64 | 2.47 |
| a field path | 39 | 368.78 ± 7.5% | 376.58 ± 5.6% | 428.98 ± 4.1% | 130.50 ± 4.8% | 313.40 ± 25.5% | 910.85 ± 12.5% | 7493.15 ± 57.6% | 374.47 ± 34.2% | 0.98 | 0.98 | 2.83 | 1.18 |
| literal: a word | 7 | 1162.47 ± 2.4% | 1228.71 ± 4.9% | 2153.38 ± 4.9% | 890.54 ± 2.1% | 1033.18 ± 4.5% | 1811.38 ± 5.2% | 47010.81 ± 4.0% | 1150.81 ± 2.9% | 0.95 | 1.01 | 1.31 | 1.13 |
| literal: a word that is not there | 8 | 1118.29 ± 5.6% | 1211.22 ± 7.6% | 2064.62 ± 16.9% | 824.35 ± 10.9% | 1000.26 ± 3.7% | 1805.58 ± 11.2% | 48918.39 ± 4.2% | 1130.59 ± 3.4% | 0.92 | 0.99 | 1.36 | 1.12 |
| literal: one of four words | 26 | 429.64 ± 3.1% | 681.53 ± 4.6% | 899.77 ± 5.8% | 70.14 ± 4.7% | 400.97 ± 3.9% | 692.62 ± 12.3% | 24880.75 ± 4.1% | 427.10 ± 4.8% | 0.63 | 1.01 | 6.13 | 1.07 |
| literal: a word in any case | 11 | 914.53 ± 6.0% | 940.84 ± 5.7% | 1407.91 ± 7.3% | 23.66 ± 22.4% | 1095.41 ± 5.2% | refused | 39540.03 ± 1.0% | 916.18 ± 3.5% | 0.97 | 1.00 | 38.65 | 0.83 |
| literal: an href attribute | 12 | 625.05 ± 1.7% | 643.37 ± 3.0% | 832.93 ± 4.0% | 64.44 ± 2.4% | 777.57 ± 0.6% | 1569.60 ± 0.5% | 35488.17 ± 0.8% | 620.82 ± 3.3% | 0.97 | 1.01 | 9.70 | 0.80 |
| literal: a word, second text | 10 | 1038.76 ± 1.9% | 1127.22 ± 2.8% | 1803.62 ± 4.4% | 749.22 ± 0.5% | 889.81 ± 3.5% | 1605.59 ± 6.0% | 47173.72 ± 9.4% | 1042.00 ± 3.3% | 0.92 | 1.00 | 1.39 | 1.17 |
| class: two capitalized words | 23 | 829.48 ± 0.5% | 889.32 ± 22.1% | 1268.67 ± 7.7% | 171.03 ± 1.7% | 826.95 ± 2.2% | 1520.57 ± 0.3% | 9916.46 ± 6.7% | 827.63 ± 1.6% | 0.93 | 1.00 | 4.85 | 1.00 |
| class: a word that ends in ing | 9 | 1034.39 ± 1.7% | 1140.42 ± 12.2% | 1944.50 ± 4.9% | 209.99 ± 4.0% | 1136.07 ± 4.0% | 2261.80 ± 7.7% | 25191.65 ± 4.3% | 1027.80 ± 2.5% | 0.91 | 1.01 | 4.93 | 0.91 |
| class: a word in capitals | 16 | 910.66 ± 3.7% | 985.07 ± 10.2% | 1541.80 ± 5.6% | 217.11 ± 3.6% | 1202.97 ± 2.6% | 2105.26 ± 9.1% | 12760.16 ± 4.0% | 885.94 ± 1.6% | 0.92 | 1.03 | 4.19 | 0.76 |
| class: a number | 6 | 1087.75 ± 25.1% | 1242.93 ± 5.6% | 2227.64 ± 5.7% | 61.56 ± 30.3% | 2226.26 ± 122.9% | 3740.06 ± 32.8% | 36043.18 ± 42.6% | 1050.25 ± 21.3% | 0.88 | 1.04 | 17.67 | 0.49 |
| class: two capitalized words, second text | 23 | 777.59 ± 26.5% | 836.17 ± 18.5% | 1264.04 ± 7.5% | 165.57 ± 56.1% | 809.36 ± 247.0% | 1439.52 ± 124.1% | 9376.39 ± 117.7% | 780.42 ± 27.8% | 0.93 | 1.00 | 4.70 | 0.96 |
| other: a word between two words | 13 | 995.93 ± 8.5% | 1034.16 ± 7.5% | 1584.37 ± 6.8% | 219.84 ± 8.6% | 786.88 ± 7.4% | 1573.97 ± 7.9% | 23628.01 ± 7.3% | 1012.63 ± 16.5% | 0.96 | 0.98 | 4.53 | 1.27 |
| other: a number before a unit, second text | 15 | 713.45 ± 3.6% | 792.71 ± 4.5% | 1089.21 ± 2.6% | 59.13 ± 2.2% | 988.77 ± 1.3% | 1827.44 ± 2.7% | 25936.01 ± 1.5% | 716.91 ± 2.2% | 0.90 | 1.00 | 12.07 | 0.72 |
| other: a heading's start tag | 13 | 649.35 ± 2.7% | 659.95 ± 4.2% | 854.84 ± 8.3% | 61.54 ± 20.7% | 965.14 ± 4.0% | 1745.62 ± 6.0% | 30925.59 ± 0.7% | 646.89 ± 1.2% | 0.98 | 1.00 | 10.55 | 0.67 |
| other: a whole word | 11 | 1031.52 ± 3.0% | 1102.34 ± 6.1% | 1772.46 ± 4.6% | 196.00 ± 0.6% | 927.90 ± 11.2% | 1669.85 ± 1.7% | 44748.08 ± 15.0% | 1050.70 ± 3.2% | 0.94 | 0.98 | 5.26 | 1.11 |
| other: a line's first word, second text | 17 | 988.06 ± 4.6% | 1046.69 ± 2.2% | 1640.36 ± 4.4% | 204.64 ± 3.8% | 1085.38 ± 5.0% | refused | refused | 984.05 ± 2.9% | 0.94 | 1.00 | 4.83 | 0.91 |
| other: fourteen octets before an x | 16 | 185.46 ± 5.3% | 259.59 ± 4.1% | 297.56 ± 10.0% | 23.07 ± 4.2% | 688.94 ± 3.0% | 781.71 ± 2.8% | 20594.97 ± 3.4% | 186.72 ± 7.2% | 0.71 | 0.99 | 8.04 | 0.27 |
| other: a Greek word | 8 | 728.78 ± 11.3% | 959.66 ± 20.6% | 1491.35 ± 52.0% | 74.69 ± 7.2% | 2083.84 ± 5.0% | 3314.70 ± 7.8% | refused | 717.65 ± 6.7% | 0.76 | 1.02 | 9.76 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34851.98 ± 1.1% | not timed | not timed | 44016.43 ± 0.9% | 3366.28 ± 24.7% | not timed | not timed | 35049.41 ± 1.1% | | 0.99 | 0.79 | 10.35 |
| 01-literal/sherlock-casei-en | 522 | 10786.06 ± 5.3% | not timed | not timed | 11270.93 ± 41.8% | 51.23 ± 2.6% | not timed | not timed | 10750.74 ± 0.2% | | 1.00 | 0.96 | 210.53 |
| 01-literal/sherlock-ru | 724 | 36359.14 ± 9.1% | not timed | not timed | 45094.67 ± 4.8% | 2318.07 ± 4.1% | not timed | not timed | 35863.53 ± 8.5% | | 1.01 | 0.81 | 15.69 |
| 01-literal/sherlock-casei-ru | 746 | 11319.62 ± 3.6% | not timed | not timed | 9688.84 ± 5.5% | 59.05 ± 4.3% | not timed | not timed | 11495.32 ± 4.1% | | 0.98 | 1.17 | 191.71 |
| 01-literal/sherlock-zh | 30 | 75597.50 ± 4.8% | not timed | not timed | 61195.21 ± 2.3% | 2196.35 ± 3.3% | not timed | not timed | 75832.73 ± 4.3% | | 1.00 | 1.24 | 34.42 |
| 02-literal-alternate/sherlock-en | 714 | 16272.32 ± 31.6% | not timed | not timed | 13651.15 ± 3.8% | 30.24 ± 1.6% | not timed | not timed | 16737.06 ± 26.0% | | 0.97 | 1.19 | 538.05 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2775.78 ± 7.0% | not timed | not timed | 3061.88 ± 1.9% | 18.49 ± 4.1% | not timed | not timed | 2705.70 ± 31.1% | | 1.03 | 0.91 | 150.15 |
| 02-literal-alternate/sherlock-ru | 899 | 9036.61 ± 32.1% | not timed | not timed | 7710.38 ± 4.6% | 37.75 ± 8.6% | not timed | not timed | 9350.72 ± 33.1% | | 0.97 | 1.17 | 239.40 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2549.58 ± 12.6% | not timed | not timed | 1469.00 ± 23.5% | 16.20 ± 9.1% | not timed | not timed | 2534.77 ± 4.5% | | 1.01 | 1.74 | 157.41 |
| 02-literal-alternate/sherlock-zh | 207 | 23515.89 ± 4.5% | not timed | not timed | 15892.37 ± 4.8% | 53.32 ± 6.7% | not timed | not timed | 23279.07 ± 24.2% | | 1.01 | 1.48 | 441.01 |
| 03-date/ascii | 111817 | 150.61 ± 4.1% | not timed | not timed | 125.68 ± 2.2% | 0.32 ± 7.3% | not timed | not timed | 151.88 ± 3.0% | | 0.99 | 1.20 | 474.53 |
| 04-ruff-noqa/real | 84 | 873.36 ± 5.1% | not timed | not timed | 695.17 ± 3.3% | 27.45 ± 4.1% | not timed | not timed | 874.98 ± 5.2% | | 1.00 | 1.26 | 31.82 |
| 04-ruff-noqa/tweaked | 44 | 813.25 ± 2.2% | not timed | not timed | 699.93 ± 3.2% | 482.16 ± 13.8% | not timed | not timed | 812.94 ± 33.8% | | 1.00 | 1.16 | 1.69 |
| 05-lexer-veryl/single | 124800 | 6.24 ± 3.2% | not timed | not timed | 7.64 ± 3.8% | 0.36 ± 9.9% | not timed | not timed | 6.30 ± 17.5% | | 0.99 | 0.82 | 17.35 |
| 06-cloud-flare-redos/original | 107 | 329.12 ± 5.7% | not timed | not timed | 297.72 ± 4.3% | 39.88 ± 27.0% | not timed | not timed | 329.78 ± 7.8% | | 1.00 | 1.11 | 8.25 |
| 06-cloud-flare-redos/simplified-short | 102 | 331.37 ± 11.8% | not timed | not timed | 313.14 ± 32.9% | 43.53 ± 8.7% | not timed | not timed | 331.72 ± 8.6% | | 1.00 | 1.06 | 7.61 |
| 06-cloud-flare-redos/simplified-long | 10000 | 346.47 ± 3.3% | not timed | not timed | 336.63 ± 1.6% | 47.67 ± 1.5% | not timed | not timed | 346.87 ± 1.1% | | 1.00 | 1.03 | 7.27 |
| 07-unicode-character-data/parse-line | 558784 | 332.64 ± 3.3% | not timed | not timed | 263.42 ± 5.6% | 68.06 ± 5.7% | not timed | not timed | 327.94 ± 7.0% | | 1.01 | 1.26 | 4.89 |
| 08-words/all-english | 56691 | 142.10 ± 1.8% | not timed | not timed | 109.67 ± 4.1% | 19.53 ± 15.9% | not timed | not timed | 139.26 ± 3.5% | | 1.02 | 1.30 | 7.28 |
| 08-words/long-english | 839 | 1217.61 ± 5.0% | not timed | not timed | 727.28 ± 24.0% | 51.42 ± 15.6% | not timed | not timed | 1178.83 ± 4.2% | | 1.03 | 1.67 | 23.68 |
| 09-aws-keys/full | 0 | 677.42 ± 3.6% | not timed | not timed | 740.89 ± 2.6% | 95.91 ± 5.4% | not timed | not timed | 644.85 ± 4.0% | | 1.05 | 0.91 | 7.06 |
| 09-aws-keys/quick | 0 | 1338.50 ± 6.5% | not timed | not timed | 1241.81 ± 3.6% | 576.97 ± 15.5% | not timed | not timed | 1304.46 ± 12.3% | | 1.03 | 1.08 | 2.32 |
| 10-bounded-repeat/letters-en | 1833 | 790.99 ± 4.1% | not timed | not timed | 760.20 ± 5.0% | 30.23 ± 18.7% | not timed | not timed | 786.32 ± 3.1% | | 1.01 | 1.04 | 26.17 |
| 10-bounded-repeat/letters-ru | 3475 | 464.37 ± 4.1% | not timed | not timed | 669.76 ± 4.6% | 31.97 ± 8.6% | not timed | not timed | 463.29 ± 1.8% | | 1.00 | 0.69 | 14.52 |
| 10-bounded-repeat/context | 53 | 111.84 ± 3.6% | not timed | not timed | 92.20 ± 5.1% | 30.08 ± 6.8% | not timed | not timed | 111.35 ± 7.8% | | 1.00 | 1.21 | 3.72 |
| 10-bounded-repeat/capitals | 11 | 1290.78 ± 5.6% | not timed | not timed | 748.44 ± 4.7% | 54.67 ± 4.2% | not timed | not timed | 1263.25 ± 2.7% | | 1.02 | 1.72 | 23.61 |
| 11-unstructured-to-json/extract | 600 | 62.41 ± 16.4% | not timed | not timed | 104.89 ± 33.9% | 76.29 ± 2.8% | not timed | not timed | 61.61 ± 6.4% | | 1.01 | 0.59 | 0.82 |
| 12-dictionary/single | 1 | 658.00 ± 4.6% | not timed | not timed | 637.35 ± 5.1% | 0.66 ± 4.2% | not timed | not timed | 664.54 ± 4.5% | | 0.99 | 1.03 | 1000.93 |
| 14-quadratic/1x | 100 | 11.83 ± 11.0% | not timed | not timed | 17.61 ± 0.8% | 1.48 ± 3.4% | not timed | not timed | 11.76 ± 1.0% | | 1.01 | 0.67 | 8.00 |
| 14-quadratic/2x | 200 | 6.66 ± 5.0% | not timed | not timed | 8.21 ± 4.7% | 0.81 ± 4.0% | not timed | not timed | 6.57 ± 5.4% | | 1.01 | 0.81 | 8.17 |
| 14-quadratic/10x | 1000 | 1.40 ± 6.0% | not timed | not timed | 1.46 ± 22.7% | 0.17 ± 28.8% | not timed | not timed | 1.39 ± 5.5% | | 1.01 | 0.96 | 8.10 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.50 ± 3.1% | not timed | not timed | 0.55 ± 3.7% | 0.84 ± 9.6% | not timed | not timed | 2.44 ± 3.1% | | 1.02 | 4.57 | 2.97 |
| 04-ruff-noqa/compile-real | 1 | 161.05 ± 3.8% | not timed | not timed | 21.76 ± 2.8% | 230.32 ± 33.1% | not timed | not timed | 157.09 ± 8.8% | | 1.03 | 7.40 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 24.13 ± 22.0% | not timed | not timed | 4.06 ± 5.7% | 11.09 ± 15.4% | not timed | not timed | 24.59 ± 3.1% | | 0.98 | 5.94 | 2.17 |
| 07-unicode-character-data/compile | 1 | 95.89 ± 5.9% | not timed | not timed | 40.60 ± 22.7% | 62.54 ± 5.0% | not timed | not timed | 95.95 ± 5.3% | | 1.00 | 2.36 | 1.53 |
| 09-aws-keys/compile-full | 1 | 65.23 ± 16.3% | not timed | not timed | 13.01 ± 3.1% | 38.08 ± 5.2% | not timed | not timed | 64.40 ± 2.2% | | 1.01 | 5.01 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 306.01 ± 3.2% | not timed | not timed | 78.19 ± 3.6% | 218.62 ± 1.9% | not timed | not timed | 307.46 ± 3.0% | | 1.00 | 3.91 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 23.52 ± 2.7% | not timed | not timed | 18.19 ± 6.6% | 27.36 ± 5.2% | not timed | not timed | 23.37 ± 7.0% | | 1.01 | 1.29 | 0.86 |
| 10-bounded-repeat/compile-capitals | 1 | 136.10 ± 1.9% | not timed | not timed | 13.22 ± 0.5% | 39.72 ± 4.6% | not timed | not timed | 135.69 ± 10.1% | | 1.00 | 10.30 | 3.43 |
| 11-unstructured-to-json/compile | 1 | 147.76 ± 1.8% | not timed | not timed | 67.16 ± 1.6% | 115.16 ± 1.4% | not timed | not timed | 147.16 ± 2.1% | | 1.00 | 2.20 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.48 ± 0.7% | not timed | not timed | 0.10 ± 4.5% | 0.15 ± 22.6% | not timed | not timed | 0.48 ± 7.5% | | 1.01 | 4.97 | 3.24 |

