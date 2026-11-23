# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159239987 |
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
| literal: a word | 217 | 15952.62 ± 1.2% | 1048.69 ± 0.1% | 28.73 ± 0.5% | 18273.46 ± 1.3% | 9185.72 ± 8.3% | 17.19 ± 0.5% | 86.61 ± 0.1% | 15990.68 ± 1.4% | 15.21 | 1.00 | 0.87 | 1.74 |
| literal: a word that is not there | 0 | 18652.31 ± 1.6% | 1056.96 ± 0.3% | 28.82 ± 0.2% | 19789.34 ± 3.0% | 29168.52 ± 1.8% | 17.04 ± 0.1% | 82.28 ± 0.2% | 18841.65 ± 1.0% | 17.65 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6062.65 ± 0.7% | 1031.01 ± 0.1% | 14.71 ± 0.4% | 3947.05 ± 0.3% | 21.87 ± 0.2% | 5.35 ± 0.5% | 6.93 ± 0.7% | 6063.95 ± 0.3% | 5.88 | 1.00 | 1.54 | 277.25 |
| literal: a word in any case | 217 | 12589.51 ± 0.7% | 1046.60 ± 0.6% | 21.87 ± 0.3% | 3974.43 ± 0.2% | 38.02 ± 0.4% | refused | differs | 12566.71 ± 0.5% | 12.03 | 1.00 | 3.17 | 331.09 |
| literal: an href attribute | 33 | 13484.80 ± 0.9% | 1053.79 ± 0.1% | 27.35 ± 0.3% | 16866.66 ± 2.9% | 2253.74 ± 0.5% | 13.12 ± 0.3% | 75.37 ± 0.2% | 13425.91 ± 0.6% | 12.80 | 1.00 | 0.80 | 5.98 |
| literal: a word, second text | 123 | 16196.69 ± 2.2% | 1050.90 ± 0.1% | 28.14 ± 0.2% | 18326.00 ± 2.0% | 7889.42 ± 7.1% | 20.14 ± 0.4% | 70.07 ± 0.7% | 16338.60 ± 2.3% | 15.41 | 0.99 | 0.88 | 2.05 |
| class: two capitalized words | 1331 | 1124.06 ± 0.8% | 980.48 ± 0.1% | 26.13 ± 0.4% | 585.17 ± 0.1% | 40.55 ± 2.4% | 14.68 ± 0.3% | 68.88 ± 0.3% | 1124.86 ± 0.9% | 1.15 | 1.00 | 1.92 | 27.72 |
| class: a word that ends in ing | 3399 | 901.46 ± 0.1% | 901.43 ± 0.1% | 18.22 ± 0.2% | 547.61 ± 0.0% | 29.56 ± 12.3% | 8.14 ± 0.2% | 18.43 ± 1.0% | 900.16 ± 0.2% | 1.00 | 1.00 | 1.65 | 30.49 |
| class: a word in capitals | 2332 | 1460.20 ± 0.5% | 956.19 ± 0.0% | 27.69 ± 0.4% | 572.62 ± 0.1% | 43.51 ± 7.4% | 17.10 ± 0.2% | 83.06 ± 0.2% | 1459.02 ± 0.5% | 1.53 | 1.00 | 2.55 | 33.56 |
| class: a number | 8288 | 2003.09 ± 0.2% | 839.47 ± 0.1% | 27.95 ± 0.2% | 1717.84 ± 0.1% | 42.87 ± 13.6% | 0.54 ± 0.2% | 56.56 ± 0.5% | 2003.82 ± 0.2% | 2.39 | 1.00 | 1.17 | 46.72 |
| class: two capitalized words, second text | 5359 | 744.04 ± 0.2% | 745.89 ± 0.2% | 23.39 ± 0.2% | 485.41 ± 0.1% | 35.33 ± 6.5% | 17.13 ± 0.3% | 64.05 ± 0.2% | 743.91 ± 0.3% | 1.00 | 1.00 | 1.53 | 21.06 |
| other: a word between two words | 6104 | 753.09 ± 0.1% | 781.29 ± 0.1% | 23.53 ± 0.1% | 738.19 ± 0.2% | 109.24 ± 15.4% | 11.14 ± 0.1% | 69.70 ± 0.1% | 749.67 ± 0.1% | 0.96 | 1.00 | 1.02 | 6.89 |
| other: a number before a unit, second text | 1481 | 5405.60 ± 0.8% | 991.30 ± 0.1% | 26.07 ± 0.1% | 5651.10 ± 0.4% | 40.71 ± 0.1% | 18.18 ± 0.1% | 66.91 ± 0.3% | 5391.53 ± 0.6% | 5.45 | 1.00 | 0.96 | 132.78 |
| other: a heading's start tag | 110 | 12435.17 ± 0.4% | 1044.14 ± 0.2% | 27.56 ± 0.4% | 1713.40 ± 0.5% | 1580.90 ± 7.4% | 15.93 ± 0.3% | 88.69 ± 0.5% | 12349.37 ± 0.1% | 11.91 | 1.01 | 7.26 | 7.87 |
| other: a whole word | 217 | 14016.23 ± 0.6% | 1046.77 ± 0.1% | 29.59 ± 0.8% | 14536.42 ± 1.6% | 49.35 ± 0.2% | 13.07 ± 0.1% | 55.74 ± 0.4% | 13907.21 ± 0.5% | 13.39 | 1.01 | 0.96 | 284.01 |
| other: a line's first word, second text | 3716 | 1965.50 ± 0.2% | 879.26 ± 0.1% | 31.19 ± 0.2% | 1720.24 ± 0.4% | 62.21 ± 4.7% | refused | refused | 1958.16 ± 0.5% | 2.24 | 1.00 | 1.14 | 31.60 |
| other: fourteen octets before an x | 87 | 19330.51 ± 1.6% | 239.71 ± 0.6% | 6.64 ± 0.0% | 3901.16 ± 1.1% | 10.66 ± 0.2% | differs | 17.75 ± 0.1% | 19302.69 ± 1.3% | 80.64 | 1.00 | 4.96 | 1813.05 |
| other: a Greek word | 21815 | 512.83 ± 0.5% | 411.78 ± 0.3% | 31.28 ± 0.2% | 289.38 ± 0.5% | 45.24 ± 9.3% | differs | refused | 508.93 ± 0.5% | 1.25 | 1.01 | 1.77 | 11.33 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.3% | 25.85 ± 0.1% | 0.87 ± 0.1% | 19.75 ± 0.2% | 2.78 ± 0.1% | differs | 4.03 ± 0.1% | 25.85 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.30 |
| a UUID | 32895 | 21.06 ± 0.3% | 21.13 ± 0.3% | 0.65 ± 0.3% | 15.05 ± 0.6% | 3.10 ± 0.1% | 0.69 ± 0.1% | 3.60 ± 0.5% | 21.19 ± 0.4% | 1.00 | 0.99 | 1.40 | 6.79 |
| an IPv4 address | 33176 | 36.84 ± 0.2% | 36.83 ± 0.2% | 2.10 ± 0.4% | 29.39 ± 0.2% | 6.66 ± 0.2% | differs | 4.15 ± 0.1% | 36.89 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.53 |
| a date and time | 32954 | 30.95 ± 0.6% | 31.01 ± 0.6% | 1.48 ± 0.3% | 21.51 ± 0.6% | 7.03 ± 0.3% | 1.18 ± 0.1% | 7.14 ± 0.7% | 30.91 ± 0.6% | 1.00 | 1.00 | 1.44 | 4.40 |
| a field path | 32606 | 29.48 ± 0.2% | 29.44 ± 0.2% | 1.04 ± 0.2% | 23.24 ± 0.4% | 3.47 ± 1.0% | differs | 2.97 ± 0.3% | 29.46 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.49 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.54 ± 0.2% | 11.52 ± 0.2% | 11.56 ± 0.4% | 11.56 ± 0.2% | 4.94 ± 1.4% | 0.89 ± 0.5% | none | 11.50 ± 0.3% | 1.00 | 1.00 | 1.00 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.03 ± 0.1% | 235.84 ± 0.5% | 286.86 ± 0.4% | 86.25 ± 0.1% | 220.41 ± 0.9% | 483.17 ± 0.5% | 3883.45 ± 2.0% | 234.07 ± 0.2% | 0.99 | 1.00 | 2.71 | 1.06 |
| a UUID | 62 | 156.97 ± 0.3% | 157.51 ± 0.2% | 179.07 ± 0.2% | 45.39 ± 0.0% | 98.96 ± 9.7% | 180.48 ± 1.0% | 4447.56 ± 2.2% | 157.07 ± 0.2% | 1.00 | 1.00 | 3.46 | 1.59 |
| an IPv4 address | 29 | 419.18 ± 0.4% | 424.18 ± 0.4% | 613.97 ± 0.2% | 76.12 ± 1.0% | 131.05 ± 1.9% | 289.98 ± 0.5% | 7634.34 ± 0.2% | 419.24 ± 0.3% | 0.99 | 1.00 | 5.51 | 3.20 |
| a date and time | 56 | 307.28 ± 0.3% | 310.09 ± 0.1% | 400.06 ± 0.4% | 71.58 ± 0.1% | 136.47 ± 6.0% | 316.89 ± 0.8% | 4911.67 ± 0.4% | 307.15 ± 0.3% | 0.99 | 1.00 | 4.29 | 2.25 |
| a field path | 39 | 226.49 ± 0.2% | 227.91 ± 0.2% | 274.47 ± 0.2% | 79.09 ± 0.3% | 203.86 ± 3.2% | 484.13 ± 0.6% | 4938.61 ± 1.1% | 226.41 ± 0.2% | 0.99 | 1.00 | 2.86 | 1.11 |
| literal: a word | 7 | 619.26 ± 0.4% | 663.28 ± 0.3% | 1246.60 ± 0.8% | 498.89 ± 1.5% | 625.24 ± 1.4% | 913.75 ± 0.6% | 29516.83 ± 0.1% | 619.59 ± 0.3% | 0.93 | 1.00 | 1.24 | 0.99 |
| literal: a word that is not there | 8 | 597.56 ± 0.3% | 645.32 ± 0.3% | 1171.25 ± 0.8% | 455.90 ± 0.2% | 602.83 ± 2.2% | 867.65 ± 0.4% | 28595.96 ± 0.2% | 597.75 ± 0.2% | 0.93 | 1.00 | 1.31 | 0.99 |
| literal: one of four words | 26 | 241.12 ± 0.4% | 399.30 ± 0.3% | 562.23 ± 0.2% | 49.23 ± 0.1% | 241.77 ± 2.5% | 353.93 ± 0.2% | 15405.31 ± 0.1% | 241.61 ± 0.3% | 0.60 | 1.00 | 4.90 | 1.00 |
| literal: a word in any case | 11 | 481.66 ± 0.2% | 514.66 ± 0.2% | 838.25 ± 0.3% | 15.68 ± 0.8% | 646.77 ± 1.4% | refused | 23418.76 ± 0.2% | 481.83 ± 0.2% | 0.94 | 1.00 | 30.72 | 0.74 |
| literal: an href attribute | 12 | 348.08 ± 0.4% | 360.48 ± 0.4% | 491.42 ± 0.5% | 44.10 ± 0.7% | 500.34 ± 0.5% | 767.32 ± 2.1% | 21484.22 ± 0.2% | 347.98 ± 0.3% | 0.97 | 1.00 | 7.89 | 0.70 |
| literal: a word, second text | 10 | 557.82 ± 0.4% | 610.22 ± 0.2% | 1061.37 ± 0.3% | 406.71 ± 0.6% | 534.30 ± 2.0% | 795.29 ± 0.2% | 26488.68 ± 0.1% | 558.00 ± 0.3% | 0.91 | 1.00 | 1.37 | 1.04 |
| class: two capitalized words | 23 | 434.07 ± 0.3% | 465.48 ± 0.3% | 705.40 ± 0.3% | 100.65 ± 0.2% | 496.45 ± 2.4% | 738.99 ± 0.5% | 6569.32 ± 0.7% | 434.15 ± 0.6% | 0.93 | 1.00 | 4.31 | 0.87 |
| class: a word that ends in ing | 9 | 550.03 ± 0.5% | 621.43 ± 0.8% | 1161.70 ± 0.1% | 133.23 ± 1.0% | 755.38 ± 0.8% | 1076.35 ± 1.7% | 16015.29 ± 0.2% | 549.84 ± 0.5% | 0.89 | 1.00 | 4.13 | 0.73 |
| class: a word in capitals | 16 | 486.14 ± 0.5% | 528.34 ± 0.7% | 901.69 ± 0.3% | 135.25 ± 0.9% | 756.27 ± 0.5% | 1013.19 ± 0.4% | 8648.91 ± 0.2% | 486.06 ± 0.9% | 0.92 | 1.00 | 3.59 | 0.64 |
| class: a number | 6 | 603.24 ± 0.8% | 675.96 ± 1.0% | 1359.06 ± 0.1% | 41.88 ± 0.5% | 1395.07 ± 2.3% | 1935.49 ± 0.9% | 22504.21 ± 0.1% | 603.36 ± 0.4% | 0.89 | 1.00 | 14.40 | 0.43 |
| class: two capitalized words, second text | 23 | 433.79 ± 0.4% | 465.70 ± 0.3% | 705.55 ± 0.3% | 102.76 ± 0.4% | 499.74 ± 1.5% | 740.16 ± 0.5% | 6571.48 ± 0.8% | 434.07 ± 0.2% | 0.93 | 1.00 | 4.22 | 0.87 |
| other: a word between two words | 13 | 547.89 ± 0.4% | 566.32 ± 0.2% | 944.66 ± 0.4% | 135.51 ± 0.5% | 503.65 ± 0.9% | 810.82 ± 0.8% | 14809.62 ± 0.1% | 547.57 ± 0.2% | 0.97 | 1.00 | 4.04 | 1.09 |
| other: a number before a unit, second text | 15 | 403.07 ± 0.3% | 445.52 ± 0.4% | 652.81 ± 0.1% | 39.21 ± 0.4% | 632.88 ± 1.2% | 894.17 ± 0.5% | 15079.71 ± 0.1% | 403.45 ± 0.2% | 0.90 | 1.00 | 10.28 | 0.64 |
| other: a heading's start tag | 13 | 357.88 ± 0.5% | 363.99 ± 0.5% | 498.55 ± 0.3% | 43.09 ± 0.4% | 627.40 ± 0.2% | 856.21 ± 0.2% | 17865.24 ± 0.1% | 358.05 ± 0.7% | 0.98 | 1.00 | 8.31 | 0.57 |
| other: a whole word | 11 | 579.72 ± 0.5% | 615.62 ± 0.4% | 1081.53 ± 0.3% | 120.28 ± 0.4% | 563.70 ± 1.9% | 822.32 ± 1.3% | 26543.85 ± 0.5% | 579.92 ± 0.8% | 0.94 | 1.00 | 4.82 | 1.03 |
| other: a line's first word, second text | 17 | 529.10 ± 0.3% | 547.64 ± 0.3% | 936.59 ± 0.3% | 128.18 ± 0.1% | 706.94 ± 1.0% | refused | refused | 528.60 ± 0.5% | 0.97 | 1.00 | 4.13 | 0.75 |
| other: fourteen octets before an x | 16 | 111.75 ± 0.5% | 162.31 ± 0.5% | 190.72 ± 0.4% | 14.97 ± 0.5% | 451.71 ± 1.7% | 416.78 ± 0.5% | 12592.57 ± 0.7% | 111.50 ± 0.6% | 0.69 | 1.00 | 7.47 | 0.25 |
| other: a Greek word | 8 | 421.23 ± 0.2% | 580.19 ± 0.4% | 1038.82 ± 0.3% | 58.27 ± 1.0% | 1371.36 ± 4.7% | 1835.65 ± 0.6% | refused | 420.89 ± 0.2% | 0.73 | 1.00 | 7.23 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12748.06 ± 1.0% | not timed | not timed | 16082.81 ± 1.4% | 1981.83 ± 11.3% | not timed | not timed | 12762.51 ± 0.5% | | 1.00 | 0.79 | 6.43 |
| 01-literal/sherlock-casei-en | 522 | 4490.39 ± 0.8% | not timed | not timed | 3585.79 ± 0.1% | 32.45 ± 0.6% | not timed | not timed | 4479.30 ± 0.4% | | 1.00 | 1.25 | 138.39 |
| 01-literal/sherlock-ru | 724 | 13551.55 ± 0.6% | not timed | not timed | 17284.83 ± 1.0% | 1447.02 ± 20.0% | not timed | not timed | 13526.67 ± 0.2% | | 1.00 | 0.78 | 9.37 |
| 01-literal/sherlock-casei-ru | 746 | 5305.81 ± 0.2% | not timed | not timed | 3323.45 ± 0.3% | 31.83 ± 0.3% | not timed | not timed | 5299.67 ± 0.8% | | 1.00 | 1.60 | 166.68 |
| 01-literal/sherlock-zh | 30 | 16816.39 ± 0.4% | not timed | not timed | 18262.43 ± 0.4% | 2822.70 ± 22.8% | not timed | not timed | 16788.25 ± 0.5% | | 1.00 | 0.92 | 5.96 |
| 02-literal-alternate/sherlock-en | 714 | 5761.73 ± 0.5% | not timed | not timed | 3941.26 ± 0.2% | 16.61 ± 0.0% | not timed | not timed | 5760.60 ± 0.1% | | 1.00 | 1.46 | 346.98 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.20 ± 1.5% | not timed | not timed | 697.12 ± 0.3% | 11.14 ± 0.1% | not timed | not timed | 1703.18 ± 0.4% | | 1.01 | 2.46 | 153.75 |
| 02-literal-alternate/sherlock-ru | 899 | 4650.14 ± 0.1% | not timed | not timed | 3254.38 ± 0.4% | 22.65 ± 0.1% | not timed | not timed | 4655.31 ± 0.2% | | 1.00 | 1.43 | 205.28 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1809.55 ± 0.5% | not timed | not timed | 1229.20 ± 0.3% | 9.15 ± 0.1% | not timed | not timed | 1801.03 ± 0.3% | | 1.00 | 1.47 | 197.84 |
| 02-literal-alternate/sherlock-zh | 207 | 7059.17 ± 0.7% | not timed | not timed | 4162.98 ± 0.2% | 31.50 ± 0.1% | not timed | not timed | 7061.23 ± 0.6% | | 1.00 | 1.70 | 224.08 |
| 03-date/ascii | 111817 | 126.55 ± 0.6% | not timed | not timed | 95.70 ± 0.2% | 0.20 ± 4.7% | not timed | not timed | 125.80 ± 0.4% | | 1.01 | 1.32 | 631.79 |
| 04-ruff-noqa/real | 84 | 555.83 ± 0.1% | not timed | not timed | 467.15 ± 0.1% | 19.66 ± 1.2% | not timed | not timed | 555.79 ± 0.1% | | 1.00 | 1.19 | 28.27 |
| 04-ruff-noqa/tweaked | 44 | 541.97 ± 0.1% | not timed | not timed | 460.48 ± 0.3% | 367.64 ± 0.5% | not timed | not timed | 540.29 ± 0.2% | | 1.00 | 1.18 | 1.47 |
| 05-lexer-veryl/single | 124800 | 4.25 ± 0.4% | not timed | not timed | 5.17 ± 0.2% | 0.21 ± 4.3% | not timed | not timed | 4.26 ± 2.1% | | 1.00 | 0.82 | 20.61 |
| 06-cloud-flare-redos/original | 107 | 260.70 ± 0.1% | not timed | not timed | 215.41 ± 0.2% | 24.78 ± 6.9% | not timed | not timed | 259.98 ± 4.6% | | 1.00 | 1.21 | 10.52 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.13 ± 0.1% | not timed | not timed | 227.73 ± 0.1% | 26.61 ± 5.7% | not timed | not timed | 254.32 ± 2.3% | | 1.00 | 1.12 | 9.59 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.13 ± 0.2% | not timed | not timed | 255.77 ± 0.1% | 28.79 ± 0.5% | not timed | not timed | 292.14 ± 0.3% | | 1.00 | 1.14 | 10.15 |
| 07-unicode-character-data/parse-line | 558784 | 234.56 ± 1.2% | not timed | not timed | 180.99 ± 0.2% | 43.20 ± 1.9% | not timed | not timed | 231.18 ± 0.2% | | 1.01 | 1.30 | 5.43 |
| 08-words/all-english | 56691 | 121.73 ± 0.3% | not timed | not timed | 83.32 ± 0.3% | 11.72 ± 6.4% | not timed | not timed | 120.96 ± 0.6% | | 1.01 | 1.46 | 10.39 |
| 08-words/long-english | 839 | 1012.32 ± 0.1% | not timed | not timed | 595.32 ± 0.1% | 32.44 ± 9.5% | not timed | not timed | 1012.58 ± 0.4% | | 1.00 | 1.70 | 31.20 |
| 09-aws-keys/full | 0 | 408.62 ± 0.1% | not timed | not timed | 492.04 ± 0.2% | 64.55 ± 0.3% | not timed | not timed | 408.86 ± 0.1% | | 1.00 | 0.83 | 6.33 |
| 09-aws-keys/quick | 0 | 739.72 ± 0.1% | not timed | not timed | 1002.97 ± 0.3% | 419.42 ± 1.8% | not timed | not timed | 737.23 ± 0.1% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 636.78 ± 0.4% | not timed | not timed | 517.10 ± 0.2% | 19.60 ± 0.5% | not timed | not timed | 636.85 ± 0.1% | | 1.00 | 1.23 | 32.48 |
| 10-bounded-repeat/letters-ru | 3475 | 383.27 ± 0.2% | not timed | not timed | 477.83 ± 0.1% | 22.47 ± 17.8% | not timed | not timed | 381.70 ± 0.6% | | 1.00 | 0.80 | 17.06 |
| 10-bounded-repeat/context | 53 | 79.37 ± 1.2% | not timed | not timed | 65.97 ± 0.3% | 19.83 ± 0.2% | not timed | not timed | 79.47 ± 1.1% | | 1.00 | 1.20 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1055.47 ± 0.1% | not timed | not timed | 618.59 ± 0.0% | 36.53 ± 0.1% | not timed | not timed | 1055.85 ± 0.2% | | 1.00 | 1.71 | 28.89 |
| 11-unstructured-to-json/extract | 600 | 49.94 ± 0.1% | not timed | not timed | 76.84 ± 0.3% | 49.15 ± 0.5% | not timed | not timed | 48.55 ± 0.9% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 568.28 ± 0.3% | not timed | not timed | 561.15 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 570.23 ± 0.3% | | 1.00 | 1.01 | 1398.34 |
| 14-quadratic/1x | 100 | 12.82 ± 0.3% | not timed | not timed | 10.01 ± 0.1% | 0.97 ± 2.7% | not timed | not timed | 12.75 ± 1.2% | | 1.01 | 1.28 | 13.25 |
| 14-quadratic/2x | 200 | 7.92 ± 0.2% | not timed | not timed | 5.52 ± 0.2% | 0.53 ± 1.5% | not timed | not timed | 7.90 ± 0.8% | | 1.00 | 1.44 | 14.86 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.0% | not timed | not timed | 1.88 ± 0.6% | | 1.00 | 1.56 | 16.28 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 1.2% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 3.0% | not timed | not timed | 1.45 ± 1.4% | | 1.00 | 4.21 | 2.62 |
| 04-ruff-noqa/compile-real | 1 | 92.70 ± 0.1% | not timed | not timed | 13.90 ± 0.1% | 139.87 ± 3.2% | not timed | not timed | 92.51 ± 1.0% | | 1.00 | 6.67 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.59 ± 1.4% | not timed | not timed | 2.53 ± 0.9% | 6.44 ± 0.5% | not timed | not timed | 14.54 ± 0.5% | | 1.00 | 5.76 | 2.26 |
| 07-unicode-character-data/compile | 1 | 58.62 ± 0.2% | not timed | not timed | 26.15 ± 0.2% | 36.28 ± 2.1% | not timed | not timed | 58.17 ± 1.2% | | 1.01 | 2.24 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.69 ± 0.4% | not timed | not timed | 8.25 ± 0.2% | 23.40 ± 0.8% | not timed | not timed | 43.57 ± 0.3% | | 1.00 | 5.30 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 187.27 ± 0.1% | not timed | not timed | 47.59 ± 0.1% | 134.28 ± 16.3% | not timed | not timed | 187.01 ± 1.2% | | 1.00 | 3.94 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.60 ± 0.5% | not timed | not timed | 11.15 ± 0.3% | 16.18 ± 1.1% | not timed | not timed | 14.57 ± 1.2% | | 1.00 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.32 ± 0.4% | not timed | not timed | 8.06 ± 0.1% | 23.63 ± 2.3% | not timed | not timed | 85.23 ± 0.8% | | 1.00 | 10.58 | 3.61 |
| 11-unstructured-to-json/compile | 1 | 91.00 ± 0.0% | not timed | not timed | 41.18 ± 0.3% | 68.32 ± 2.9% | not timed | not timed | 90.71 ± 0.6% | | 1.00 | 2.21 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 0.6% | 0.10 ± 12.3% | not timed | not timed | 0.36 ± 1.4% | | 1.01 | 5.25 | 3.68 |

