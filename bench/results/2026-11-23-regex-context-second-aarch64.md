# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117637541 |
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
| literal: a word | 217 | 16027.80 ± 2.2% | 1036.86 ± 0.1% | 27.80 ± 0.8% | 17985.53 ± 2.9% | 9098.53 ± 7.8% | 17.17 ± 0.4% | 86.41 ± 0.2% | 16042.20 ± 3.2% | 15.46 | 1.00 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18568.44 ± 2.0% | 1047.42 ± 0.2% | 27.77 ± 0.2% | 19416.49 ± 2.3% | 28894.48 ± 1.8% | 17.06 ± 0.2% | 82.14 ± 0.2% | 18691.83 ± 1.8% | 17.73 | 0.99 | 0.96 | 0.64 |
| literal: one of four words | 661 | 6043.67 ± 0.5% | 1013.30 ± 0.2% | 14.44 ± 0.2% | 3944.60 ± 0.4% | 21.88 ± 0.4% | 5.36 ± 0.2% | 6.91 ± 0.8% | 6037.11 ± 0.8% | 5.96 | 1.00 | 1.53 | 276.23 |
| literal: a word in any case | 217 | 12535.30 ± 0.8% | 1036.27 ± 0.3% | 21.21 ± 0.6% | 3969.92 ± 1.0% | 38.05 ± 0.5% | refused | differs | 12564.28 ± 0.6% | 12.10 | 1.00 | 3.16 | 329.43 |
| literal: an href attribute | 33 | 13833.42 ± 1.9% | 1045.40 ± 0.2% | 26.78 ± 0.8% | 17081.89 ± 2.4% | 2242.65 ± 5.7% | 12.73 ± 1.8% | 75.29 ± 0.1% | 13795.64 ± 1.1% | 13.23 | 1.00 | 0.81 | 6.17 |
| literal: a word, second text | 123 | 16474.83 ± 1.0% | 1041.88 ± 0.1% | 27.52 ± 0.2% | 18399.27 ± 2.2% | 7671.99 ± 4.2% | 19.97 ± 0.5% | 70.25 ± 0.7% | 16477.93 ± 2.6% | 15.81 | 1.00 | 0.90 | 2.15 |
| class: two capitalized words | 1331 | 1125.18 ± 1.0% | 953.49 ± 0.1% | 25.59 ± 0.1% | 582.44 ± 0.1% | 40.71 ± 12.4% | 14.76 ± 0.4% | 68.87 ± 0.3% | 1122.29 ± 0.5% | 1.18 | 1.00 | 1.93 | 27.64 |
| class: a word that ends in ing | 3399 | 876.10 ± 0.2% | 876.32 ± 0.1% | 17.84 ± 0.1% | 545.38 ± 0.1% | 29.61 ± 3.1% | 8.16 ± 0.5% | 18.45 ± 0.7% | 875.86 ± 0.2% | 1.00 | 1.00 | 1.61 | 29.59 |
| class: a word in capitals | 2332 | 1473.64 ± 1.0% | 937.21 ± 0.1% | 27.19 ± 0.2% | 572.68 ± 0.1% | 43.58 ± 2.6% | 17.09 ± 0.2% | 83.05 ± 0.7% | 1471.88 ± 1.3% | 1.57 | 1.00 | 2.57 | 33.82 |
| class: a number | 8288 | 1988.89 ± 0.2% | 786.96 ± 0.0% | 27.32 ± 0.3% | 1734.25 ± 1.1% | 42.49 ± 17.8% | 0.55 ± 0.1% | 56.65 ± 0.4% | 1992.17 ± 0.1% | 2.53 | 1.00 | 1.15 | 46.81 |
| class: two capitalized words, second text | 5359 | 683.45 ± 0.2% | 679.33 ± 0.3% | 22.99 ± 0.1% | 486.55 ± 0.1% | 34.02 ± 10.4% | 17.35 ± 0.2% | 63.99 ± 0.4% | 683.34 ± 0.1% | 1.01 | 1.00 | 1.40 | 20.09 |
| other: a word between two words | 6104 | 764.18 ± 0.2% | 739.00 ± 0.2% | 23.19 ± 0.2% | 737.02 ± 0.2% | 108.41 ± 13.7% | 11.23 ± 0.1% | 69.52 ± 0.4% | 764.64 ± 0.1% | 1.03 | 1.00 | 1.04 | 7.05 |
| other: a number before a unit, second text | 1481 | 5576.16 ± 0.8% | 973.18 ± 0.1% | 25.50 ± 0.1% | 5668.02 ± 0.2% | 40.84 ± 10.9% | 18.22 ± 0.2% | 66.75 ± 0.5% | 5570.28 ± 1.6% | 5.73 | 1.00 | 0.98 | 136.53 |
| other: a heading's start tag | 110 | 12664.37 ± 1.3% | 1035.88 ± 0.2% | 26.90 ± 0.1% | 1711.84 ± 0.3% | 1569.32 ± 5.5% | 16.03 ± 0.2% | 88.97 ± 0.5% | 12729.26 ± 0.4% | 12.23 | 0.99 | 7.40 | 8.07 |
| other: a whole word | 217 | 13859.12 ± 0.9% | 1036.36 ± 0.1% | 28.81 ± 0.4% | 14407.43 ± 0.7% | 49.51 ± 0.3% | 13.09 ± 0.1% | 55.70 ± 0.3% | 13889.58 ± 0.9% | 13.37 | 1.00 | 0.96 | 279.93 |
| other: a line's first word, second text | 3716 | 1979.28 ± 0.4% | 854.59 ± 0.1% | 30.32 ± 0.0% | 1736.34 ± 0.5% | 61.58 ± 7.0% | refused | refused | 1969.88 ± 0.4% | 2.32 | 1.00 | 1.14 | 32.14 |
| other: fourteen octets before an x | 87 | 19326.96 ± 0.9% | 214.72 ± 0.5% | 6.08 ± 0.2% | 4014.37 ± 0.3% | 10.65 ± 0.2% | differs | 17.78 ± 0.1% | 19359.19 ± 0.7% | 90.01 | 1.00 | 4.81 | 1815.01 |
| other: a Greek word | 21815 | 487.48 ± 0.4% | 308.66 ± 0.2% | 30.59 ± 1.4% | 290.21 ± 0.2% | 44.69 ± 8.7% | differs | refused | 483.79 ± 0.6% | 1.58 | 1.01 | 1.68 | 10.91 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.89 ± 0.2% | 25.89 ± 0.2% | 0.82 ± 0.4% | 19.82 ± 0.3% | 2.77 ± 0.6% | differs | 4.01 ± 0.2% | 25.86 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.33 |
| a UUID | 32895 | 21.10 ± 0.2% | 21.08 ± 0.2% | 0.65 ± 0.2% | 15.17 ± 0.3% | 3.12 ± 0.1% | 0.73 ± 0.3% | 3.62 ± 0.3% | 21.17 ± 0.3% | 1.00 | 1.00 | 1.39 | 6.76 |
| an IPv4 address | 33176 | 36.89 ± 0.3% | 36.85 ± 0.5% | 2.10 ± 0.3% | 29.26 ± 0.4% | 6.66 ± 0.2% | differs | 4.15 ± 0.2% | 36.72 ± 0.4% | 1.00 | 1.00 | 1.26 | 5.54 |
| a date and time | 32954 | 30.98 ± 0.5% | 31.04 ± 0.4% | 1.46 ± 0.1% | 21.63 ± 0.7% | 7.07 ± 0.1% | 1.25 ± 0.2% | 7.16 ± 0.4% | 30.95 ± 0.6% | 1.00 | 1.00 | 1.43 | 4.38 |
| a field path | 32606 | 29.44 ± 0.2% | 29.39 ± 0.3% | 1.01 ± 0.1% | 23.35 ± 0.2% | 3.49 ± 1.0% | differs | 2.97 ± 0.3% | 29.43 ± 0.2% | 1.00 | 1.00 | 1.26 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.60 ± 1.6% | 11.65 ± 1.0% | 11.64 ± 0.9% | 11.54 ± 0.3% | 4.96 ± 1.5% | 0.93 ± 0.6% | none | 11.65 ± 0.4% | 1.00 | 1.00 | 1.01 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.98 ± 0.4% | 236.52 ± 0.3% | 287.64 ± 0.5% | 87.22 ± 0.3% | 221.23 ± 1.3% | 475.02 ± 0.8% | 3646.47 ± 1.7% | 234.90 ± 0.3% | 0.99 | 1.00 | 2.69 | 1.06 |
| a UUID | 62 | 157.58 ± 0.2% | 158.06 ± 0.2% | 179.40 ± 0.1% | 46.54 ± 0.3% | 98.68 ± 7.1% | 182.82 ± 2.0% | 4004.56 ± 0.9% | 157.57 ± 0.1% | 1.00 | 1.00 | 3.39 | 1.60 |
| an IPv4 address | 29 | 421.67 ± 0.5% | 426.99 ± 0.5% | 618.82 ± 0.6% | 77.25 ± 0.8% | 131.25 ± 1.1% | 291.08 ± 1.0% | 7031.13 ± 0.1% | 421.83 ± 0.3% | 0.99 | 1.00 | 5.46 | 3.21 |
| a date and time | 56 | 306.41 ± 0.1% | 309.26 ± 0.3% | 398.53 ± 0.4% | 73.41 ± 0.6% | 136.43 ± 2.6% | 316.37 ± 0.5% | 4361.86 ± 0.3% | 306.24 ± 0.1% | 0.99 | 1.00 | 4.17 | 2.25 |
| a field path | 39 | 227.05 ± 0.3% | 228.46 ± 0.3% | 275.50 ± 0.5% | 80.92 ± 0.3% | 204.78 ± 1.3% | 502.99 ± 2.2% | 4491.14 ± 0.4% | 227.33 ± 0.2% | 0.99 | 1.00 | 2.81 | 1.11 |
| literal: a word | 7 | 623.49 ± 0.4% | 667.68 ± 0.5% | 1273.11 ± 0.1% | 523.94 ± 0.3% | 628.23 ± 2.2% | 937.05 ± 0.2% | 29629.34 ± 0.1% | 623.57 ± 0.7% | 0.93 | 1.00 | 1.19 | 0.99 |
| literal: a word that is not there | 8 | 599.73 ± 0.4% | 648.21 ± 0.2% | 1194.66 ± 0.2% | 472.14 ± 0.2% | 606.85 ± 3.3% | 890.21 ± 0.3% | 28595.82 ± 0.1% | 599.96 ± 0.4% | 0.93 | 1.00 | 1.27 | 0.99 |
| literal: one of four words | 26 | 241.65 ± 0.2% | 400.91 ± 0.4% | 564.94 ± 0.3% | 49.08 ± 0.4% | 243.29 ± 1.5% | 360.67 ± 1.9% | 15496.17 ± 0.7% | 241.69 ± 0.4% | 0.60 | 1.00 | 4.92 | 0.99 |
| literal: a word in any case | 11 | 485.52 ± 0.4% | 518.11 ± 0.2% | 846.65 ± 0.4% | 15.43 ± 0.4% | 643.98 ± 1.5% | refused | 23468.09 ± 0.1% | 485.85 ± 0.3% | 0.94 | 1.00 | 31.47 | 0.75 |
| literal: an href attribute | 12 | 350.69 ± 0.2% | 363.34 ± 0.3% | 495.75 ± 0.2% | 45.64 ± 0.6% | 500.46 ± 0.8% | 774.59 ± 0.6% | 21005.12 ± 0.2% | 350.85 ± 0.3% | 0.97 | 1.00 | 7.68 | 0.70 |
| literal: a word, second text | 10 | 562.25 ± 0.3% | 616.81 ± 0.4% | 1087.61 ± 0.1% | 426.58 ± 0.8% | 534.97 ± 4.4% | 802.95 ± 0.7% | 26586.24 ± 0.4% | 562.00 ± 0.3% | 0.91 | 1.00 | 1.32 | 1.05 |
| class: two capitalized words | 23 | 437.41 ± 0.5% | 468.43 ± 0.5% | 710.83 ± 0.5% | 101.32 ± 0.3% | 501.88 ± 1.4% | 740.12 ± 0.6% | 5720.84 ± 0.2% | 436.93 ± 0.3% | 0.93 | 1.00 | 4.32 | 0.87 |
| class: a word that ends in ing | 9 | 558.23 ± 0.5% | 628.97 ± 0.5% | 1175.79 ± 0.3% | 132.80 ± 0.9% | 762.04 ± 0.7% | 1092.53 ± 2.0% | 14502.36 ± 0.3% | 557.82 ± 0.5% | 0.89 | 1.00 | 4.20 | 0.73 |
| class: a word in capitals | 16 | 492.11 ± 0.3% | 534.52 ± 0.6% | 916.08 ± 0.2% | 136.54 ± 0.4% | 754.47 ± 1.0% | 1017.60 ± 0.8% | 7397.52 ± 0.4% | 492.23 ± 0.3% | 0.92 | 1.00 | 3.60 | 0.65 |
| class: a number | 6 | 613.61 ± 0.2% | 684.03 ± 1.0% | 1387.21 ± 0.2% | 41.81 ± 0.4% | 1413.54 ± 0.9% | 1899.74 ± 1.6% | 19381.47 ± 0.1% | 613.36 ± 0.2% | 0.90 | 1.00 | 14.68 | 0.43 |
| class: two capitalized words, second text | 23 | 437.82 ± 0.4% | 468.76 ± 0.2% | 711.61 ± 0.1% | 104.34 ± 0.5% | 502.76 ± 1.3% | 725.73 ± 0.6% | 5721.98 ± 0.1% | 437.84 ± 0.2% | 0.93 | 1.00 | 4.20 | 0.87 |
| other: a word between two words | 13 | 552.98 ± 0.2% | 571.14 ± 0.2% | 960.69 ± 0.1% | 135.64 ± 1.1% | 507.30 ± 2.5% | 804.76 ± 0.8% | 14044.06 ± 0.2% | 551.90 ± 0.3% | 0.97 | 1.00 | 4.08 | 1.09 |
| other: a number before a unit, second text | 15 | 406.23 ± 0.4% | 447.80 ± 0.4% | 657.03 ± 0.3% | 39.28 ± 0.3% | 638.87 ± 1.3% | 883.97 ± 0.3% | 12656.86 ± 0.2% | 406.45 ± 0.2% | 0.91 | 1.00 | 10.34 | 0.64 |
| other: a heading's start tag | 13 | 360.21 ± 0.3% | 365.73 ± 0.4% | 501.25 ± 0.5% | 44.63 ± 0.1% | 635.57 ± 0.8% | 863.80 ± 0.3% | 16125.10 ± 0.3% | 359.67 ± 0.1% | 0.98 | 1.00 | 8.07 | 0.57 |
| other: a whole word | 11 | 584.74 ± 0.3% | 620.45 ± 0.4% | 1090.20 ± 0.3% | 122.01 ± 0.7% | 570.43 ± 2.0% | 812.20 ± 0.9% | 26694.83 ± 0.2% | 585.31 ± 0.2% | 0.94 | 1.00 | 4.79 | 1.03 |
| other: a line's first word, second text | 17 | 533.53 ± 0.7% | 552.38 ± 0.7% | 946.05 ± 0.5% | 129.96 ± 0.1% | 711.51 ± 1.8% | refused | refused | 532.53 ± 0.7% | 0.97 | 1.00 | 4.11 | 0.75 |
| other: fourteen octets before an x | 16 | 111.80 ± 0.3% | 162.35 ± 0.7% | 190.41 ± 0.8% | 15.25 ± 0.3% | 456.92 ± 1.6% | 403.75 ± 0.4% | 10868.63 ± 0.3% | 111.62 ± 0.2% | 0.69 | 1.00 | 7.33 | 0.24 |
| other: a Greek word | 8 | 424.15 ± 0.4% | 586.43 ± 0.4% | 1059.34 ± 0.6% | 59.21 ± 0.5% | 1390.13 ± 1.5% | 1827.92 ± 1.0% | refused | 423.86 ± 0.5% | 0.72 | 1.00 | 7.16 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12916.76 ± 0.7% | not timed | not timed | 16260.36 ± 1.1% | 2062.59 ± 18.2% | not timed | not timed | 13027.39 ± 1.8% | | 0.99 | 0.79 | 6.26 |
| 01-literal/sherlock-casei-en | 522 | 3905.16 ± 0.6% | not timed | not timed | 3597.01 ± 0.3% | 32.37 ± 0.2% | not timed | not timed | 3897.35 ± 0.2% | | 1.00 | 1.09 | 120.62 |
| 01-literal/sherlock-ru | 724 | 13642.79 ± 0.4% | not timed | not timed | 17300.51 ± 0.4% | 1582.60 ± 11.5% | not timed | not timed | 13634.53 ± 0.1% | | 1.00 | 0.79 | 8.62 |
| 01-literal/sherlock-casei-ru | 746 | 5303.74 ± 0.3% | not timed | not timed | 3331.66 ± 0.1% | 30.60 ± 0.5% | not timed | not timed | 5314.90 ± 0.5% | | 1.00 | 1.59 | 173.32 |
| 01-literal/sherlock-zh | 30 | 16740.99 ± 0.5% | not timed | not timed | 18320.67 ± 1.2% | 2735.33 ± 5.5% | not timed | not timed | 16741.36 ± 0.5% | | 1.00 | 0.91 | 6.12 |
| 02-literal-alternate/sherlock-en | 714 | 5808.89 ± 0.2% | not timed | not timed | 3937.48 ± 0.1% | 16.60 ± 0.4% | not timed | not timed | 5811.11 ± 0.2% | | 1.00 | 1.48 | 349.93 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1671.43 ± 0.9% | not timed | not timed | 696.05 ± 0.4% | 10.95 ± 0.3% | not timed | not timed | 1667.19 ± 0.4% | | 1.00 | 2.40 | 152.65 |
| 02-literal-alternate/sherlock-ru | 899 | 4706.74 ± 0.3% | not timed | not timed | 3256.31 ± 0.3% | 22.66 ± 3.7% | not timed | not timed | 4709.74 ± 0.3% | | 1.00 | 1.45 | 207.72 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1787.72 ± 0.6% | not timed | not timed | 1231.72 ± 0.2% | 9.07 ± 0.1% | not timed | not timed | 1783.49 ± 0.2% | | 1.00 | 1.45 | 197.09 |
| 02-literal-alternate/sherlock-zh | 207 | 7019.77 ± 0.6% | not timed | not timed | 4159.28 ± 0.2% | 31.53 ± 0.0% | not timed | not timed | 7048.26 ± 0.1% | | 1.00 | 1.69 | 222.64 |
| 03-date/ascii | 111817 | 123.86 ± 0.3% | not timed | not timed | 95.57 ± 0.1% | 0.20 ± 7.4% | not timed | not timed | 122.72 ± 0.5% | | 1.01 | 1.30 | 605.25 |
| 04-ruff-noqa/real | 84 | 555.31 ± 0.1% | not timed | not timed | 479.43 ± 0.2% | 19.51 ± 1.2% | not timed | not timed | 555.90 ± 0.1% | | 1.00 | 1.16 | 28.46 |
| 04-ruff-noqa/tweaked | 44 | 558.72 ± 0.3% | not timed | not timed | 460.39 ± 0.4% | 366.75 ± 0.5% | not timed | not timed | 557.59 ± 0.3% | | 1.00 | 1.21 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.50 ± 1.9% | not timed | not timed | 5.24 ± 0.2% | 0.20 ± 3.9% | not timed | not timed | 3.65 ± 3.9% | | 0.96 | 0.67 | 17.22 |
| 06-cloud-flare-redos/original | 107 | 184.37 ± 1.1% | not timed | not timed | 215.12 ± 0.6% | 24.76 ± 1.0% | not timed | not timed | 183.38 ± 3.2% | | 1.01 | 0.86 | 7.45 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.13 ± 0.1% | not timed | not timed | 226.80 ± 0.7% | 26.72 ± 3.5% | not timed | not timed | 136.46 ± 0.7% | | 1.06 | 0.64 | 5.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.75 ± 2.4% | not timed | not timed | 254.73 ± 0.2% | 28.85 ± 0.1% | not timed | not timed | 154.58 ± 2.8% | | 1.00 | 0.61 | 5.36 |
| 07-unicode-character-data/parse-line | 558784 | 232.98 ± 0.3% | not timed | not timed | 180.71 ± 0.1% | 43.15 ± 8.2% | not timed | not timed | 227.35 ± 2.0% | | 1.02 | 1.29 | 5.40 |
| 08-words/all-english | 56691 | 103.52 ± 0.3% | not timed | not timed | 81.39 ± 0.0% | 12.05 ± 13.8% | not timed | not timed | 102.71 ± 0.5% | | 1.01 | 1.27 | 8.59 |
| 08-words/long-english | 839 | 998.04 ± 0.2% | not timed | not timed | 597.63 ± 0.1% | 32.76 ± 0.2% | not timed | not timed | 999.00 ± 0.1% | | 1.00 | 1.67 | 30.47 |
| 09-aws-keys/full | 0 | 425.01 ± 0.1% | not timed | not timed | 491.81 ± 0.1% | 64.52 ± 0.1% | not timed | not timed | 425.01 ± 0.1% | | 1.00 | 0.86 | 6.59 |
| 09-aws-keys/quick | 0 | 740.74 ± 0.2% | not timed | not timed | 997.31 ± 0.4% | 423.56 ± 0.9% | not timed | not timed | 738.26 ± 0.1% | | 1.00 | 0.74 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 588.06 ± 0.4% | not timed | not timed | 519.21 ± 0.1% | 19.53 ± 0.2% | not timed | not timed | 586.44 ± 0.2% | | 1.00 | 1.13 | 30.10 |
| 10-bounded-repeat/letters-ru | 3475 | 402.35 ± 0.1% | not timed | not timed | 479.72 ± 0.1% | 21.89 ± 17.6% | not timed | not timed | 400.92 ± 0.6% | | 1.00 | 0.84 | 18.38 |
| 10-bounded-repeat/context | 53 | 79.74 ± 1.0% | not timed | not timed | 66.01 ± 0.5% | 19.78 ± 0.2% | not timed | not timed | 79.82 ± 1.1% | | 1.00 | 1.21 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 1046.94 ± 0.2% | not timed | not timed | 618.07 ± 0.1% | 36.66 ± 0.1% | not timed | not timed | 1047.20 ± 0.1% | | 1.00 | 1.69 | 28.56 |
| 11-unstructured-to-json/extract | 600 | 47.78 ± 0.2% | not timed | not timed | 76.63 ± 0.5% | 48.98 ± 1.2% | not timed | not timed | 47.39 ± 0.4% | | 1.01 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 603.07 ± 0.5% | not timed | not timed | 561.29 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 603.31 ± 0.5% | | 1.00 | 1.07 | 1466.52 |
| 14-quadratic/1x | 100 | 12.59 ± 0.3% | not timed | not timed | 10.00 ± 0.2% | 0.98 ± 3.9% | not timed | not timed | 12.51 ± 1.6% | | 1.01 | 1.26 | 12.85 |
| 14-quadratic/2x | 200 | 7.83 ± 0.4% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 0.8% | not timed | not timed | 7.80 ± 1.3% | | 1.00 | 1.41 | 14.74 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.11 ± 1.5% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.54 | 16.26 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.3% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 5.6% | not timed | not timed | 1.44 ± 0.5% | | 1.00 | 4.22 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 92.54 ± 0.3% | not timed | not timed | 13.65 ± 0.2% | 139.78 ± 1.1% | not timed | not timed | 91.98 ± 0.9% | | 1.01 | 6.78 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.55 ± 0.2% | not timed | not timed | 2.54 ± 0.9% | 6.42 ± 10.2% | not timed | not timed | 14.44 ± 1.6% | | 1.01 | 5.74 | 2.27 |
| 07-unicode-character-data/compile | 1 | 58.36 ± 0.1% | not timed | not timed | 25.75 ± 0.5% | 35.82 ± 3.0% | not timed | not timed | 58.35 ± 1.5% | | 1.00 | 2.27 | 1.63 |
| 09-aws-keys/compile-full | 1 | 43.53 ± 0.4% | not timed | not timed | 8.28 ± 0.4% | 23.26 ± 0.8% | not timed | not timed | 43.37 ± 1.0% | | 1.00 | 5.26 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 187.49 ± 0.2% | not timed | not timed | 47.07 ± 0.3% | 130.45 ± 15.6% | not timed | not timed | 187.18 ± 0.8% | | 1.00 | 3.98 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 14.50 ± 2.8% | not timed | not timed | 11.05 ± 0.1% | 15.89 ± 7.3% | not timed | not timed | 14.42 ± 3.1% | | 1.01 | 1.31 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.44 ± 0.2% | not timed | not timed | 7.95 ± 0.5% | 23.77 ± 2.0% | not timed | not timed | 84.81 ± 0.9% | | 1.01 | 10.75 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 90.54 ± 0.2% | not timed | not timed | 41.06 ± 0.6% | 68.30 ± 1.6% | not timed | not timed | 90.13 ± 1.3% | | 1.00 | 2.20 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 1.8% | 0.10 ± 12.0% | not timed | not timed | 0.36 ± 1.2% | | 1.00 | 5.17 | 3.68 |

