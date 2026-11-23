# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127349194 |
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
| literal: a word | 217 | 16006.93 ± 0.9% | 1038.72 ± 0.1% | 28.67 ± 0.3% | 17861.90 ± 1.3% | 9323.64 ± 7.3% | 17.46 ± 0.4% | 86.14 ± 0.2% | 15983.28 ± 0.7% | 15.41 | 1.00 | 0.90 | 1.72 |
| literal: a word that is not there | 0 | 18583.93 ± 1.6% | 1047.81 ± 0.4% | 28.75 ± 0.3% | 19670.71 ± 0.7% | 28641.24 ± 1.0% | 17.24 ± 0.4% | 82.15 ± 0.2% | 18587.67 ± 1.1% | 17.74 | 1.00 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6073.28 ± 0.6% | 1021.16 ± 0.1% | 14.76 ± 0.1% | 3945.09 ± 0.2% | 21.51 ± 0.1% | 5.24 ± 0.1% | 6.74 ± 0.2% | 6053.48 ± 0.3% | 5.95 | 1.00 | 1.54 | 282.30 |
| literal: a word in any case | 217 | 12601.48 ± 0.5% | 1039.71 ± 0.1% | 21.96 ± 2.2% | 3974.76 ± 0.2% | 38.11 ± 0.4% | refused | differs | 12565.95 ± 0.2% | 12.12 | 1.00 | 3.17 | 330.63 |
| literal: an href attribute | 33 | 13701.77 ± 0.3% | 1045.94 ± 0.1% | 27.50 ± 0.3% | 16926.00 ± 1.0% | 2259.25 ± 0.4% | 13.32 ± 0.2% | 75.71 ± 0.1% | 13655.21 ± 1.0% | 13.10 | 1.00 | 0.81 | 6.06 |
| literal: a word, second text | 123 | 16499.33 ± 1.2% | 1043.53 ± 0.3% | 28.36 ± 0.2% | 18353.67 ± 1.8% | 7762.45 ± 7.7% | 19.66 ± 0.7% | 69.74 ± 0.3% | 16552.90 ± 1.2% | 15.81 | 1.00 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1127.74 ± 0.3% | 978.18 ± 0.1% | 26.12 ± 0.1% | 585.70 ± 0.1% | 40.42 ± 0.1% | 14.89 ± 0.2% | 68.60 ± 0.2% | 1125.61 ± 0.5% | 1.15 | 1.00 | 1.93 | 27.90 |
| class: a word that ends in ing | 3399 | 890.29 ± 0.1% | 890.93 ± 0.0% | 18.24 ± 0.2% | 548.11 ± 0.1% | 29.46 ± 9.5% | 8.22 ± 0.1% | 18.22 ± 0.4% | 889.44 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.22 |
| class: a word in capitals | 2332 | 1452.55 ± 0.4% | 949.85 ± 0.2% | 27.76 ± 0.5% | 572.63 ± 0.2% | 43.44 ± 2.9% | 17.22 ± 0.3% | 82.63 ± 0.7% | 1454.73 ± 0.3% | 1.53 | 1.00 | 2.54 | 33.44 |
| class: a number | 8288 | 1998.31 ± 0.2% | 828.35 ± 0.2% | 28.04 ± 0.2% | 1718.69 ± 0.2% | 42.25 ± 10.1% | 0.56 ± 0.1% | 56.65 ± 0.6% | 1993.44 ± 0.1% | 2.41 | 1.00 | 1.16 | 47.30 |
| class: two capitalized words, second text | 5359 | 737.64 ± 0.2% | 737.17 ± 0.1% | 23.44 ± 0.1% | 484.92 ± 0.1% | 35.14 ± 5.5% | 16.69 ± 0.3% | 63.59 ± 0.3% | 737.18 ± 0.3% | 1.00 | 1.00 | 1.52 | 20.99 |
| other: a word between two words | 6104 | 760.25 ± 0.1% | 764.02 ± 0.1% | 23.66 ± 0.1% | 739.53 ± 0.1% | 108.56 ± 15.6% | 11.28 ± 0.1% | 69.53 ± 0.3% | 756.87 ± 0.1% | 1.00 | 1.00 | 1.03 | 7.00 |
| other: a number before a unit, second text | 1481 | 5533.85 ± 0.9% | 983.59 ± 0.2% | 26.01 ± 0.2% | 5674.38 ± 0.4% | 40.55 ± 0.2% | 17.84 ± 0.1% | 66.84 ± 0.2% | 5538.04 ± 1.1% | 5.63 | 1.00 | 0.98 | 136.46 |
| other: a heading's start tag | 110 | 12574.42 ± 0.4% | 1035.58 ± 0.1% | 27.57 ± 0.2% | 1710.49 ± 0.1% | 1571.36 ± 8.8% | 16.20 ± 0.2% | 88.39 ± 0.2% | 12599.06 ± 0.4% | 12.14 | 1.00 | 7.35 | 8.00 |
| other: a whole word | 217 | 13941.37 ± 0.5% | 1038.57 ± 0.2% | 29.85 ± 0.2% | 14574.45 ± 1.0% | 49.19 ± 0.4% | 13.47 ± 0.2% | 55.82 ± 0.2% | 13916.68 ± 0.5% | 13.42 | 1.00 | 0.96 | 283.42 |
| other: a line's first word, second text | 3716 | 1962.02 ± 0.8% | 874.03 ± 0.0% | 31.33 ± 0.2% | 1727.13 ± 0.2% | 62.12 ± 5.1% | refused | refused | 1952.46 ± 0.3% | 2.24 | 1.00 | 1.14 | 31.59 |
| other: fourteen octets before an x | 87 | 19615.36 ± 0.8% | 234.92 ± 0.4% | 6.14 ± 0.1% | 3964.06 ± 0.3% | 10.61 ± 0.1% | differs | 17.67 ± 0.2% | 19661.59 ± 1.1% | 83.50 | 1.00 | 4.95 | 1849.38 |
| other: a Greek word | 21815 | 462.21 ± 0.4% | 358.02 ± 0.6% | 31.11 ± 0.1% | 289.32 ± 0.4% | 49.07 ± 7.9% | differs | refused | 468.70 ± 0.4% | 1.29 | 0.99 | 1.60 | 9.42 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.92 ± 0.1% | 25.94 ± 0.3% | 0.82 ± 0.2% | 19.46 ± 0.4% | 2.79 ± 0.3% | differs | 4.01 ± 0.2% | 25.94 ± 0.1% | 1.00 | 1.00 | 1.33 | 9.29 |
| a UUID | 32895 | 21.09 ± 0.3% | 21.16 ± 0.2% | 0.65 ± 0.2% | 15.17 ± 0.5% | 3.12 ± 0.4% | 0.71 ± 0.5% | 3.61 ± 0.4% | 21.18 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.76 |
| an IPv4 address | 33176 | 37.05 ± 0.2% | 36.93 ± 0.2% | 2.09 ± 0.5% | 28.92 ± 0.1% | 6.65 ± 0.1% | differs | 4.15 ± 0.1% | 37.06 ± 0.3% | 1.00 | 1.00 | 1.28 | 5.57 |
| a date and time | 32954 | 31.01 ± 0.4% | 31.17 ± 0.4% | 1.42 ± 0.2% | 21.12 ± 0.4% | 7.06 ± 0.2% | 1.20 ± 0.1% | 7.07 ± 0.2% | 31.08 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.39 |
| a field path | 32606 | 29.48 ± 0.2% | 29.40 ± 0.1% | 1.01 ± 0.7% | 22.98 ± 0.2% | 3.50 ± 1.3% | differs | 2.92 ± 0.4% | 29.47 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.4% | 11.47 ± 0.2% | 11.51 ± 0.2% | 11.39 ± 0.2% | 4.93 ± 2.9% | 0.91 ± 0.5% | none | 11.52 ± 0.3% | 1.00 | 1.00 | 1.01 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.40 ± 0.2% | 223.00 ± 0.2% | 258.89 ± 0.1% | 86.59 ± 0.4% | 221.70 ± 1.1% | 479.73 ± 1.0% | 3756.40 ± 0.3% | 222.34 ± 0.3% | 1.00 | 1.00 | 2.57 | 1.00 |
| a UUID | 62 | 145.09 ± 0.2% | 145.38 ± 0.2% | 160.35 ± 0.2% | 46.51 ± 1.1% | 99.55 ± 1.0% | 187.92 ± 2.8% | 4468.19 ± 0.3% | 144.98 ± 0.2% | 1.00 | 1.00 | 3.12 | 1.46 |
| an IPv4 address | 29 | 435.99 ± 0.6% | 440.22 ± 0.5% | 606.63 ± 0.5% | 77.23 ± 0.3% | 131.00 ± 1.1% | 303.19 ± 1.5% | 7728.09 ± 0.4% | 435.68 ± 0.3% | 0.99 | 1.00 | 5.65 | 3.33 |
| a date and time | 56 | 312.60 ± 0.2% | 314.03 ± 0.2% | 390.71 ± 0.2% | 72.97 ± 0.4% | 137.87 ± 1.1% | 322.25 ± 1.0% | 4974.81 ± 0.9% | 312.53 ± 0.2% | 1.00 | 1.00 | 4.28 | 2.27 |
| a field path | 39 | 208.40 ± 0.5% | 209.21 ± 0.3% | 240.34 ± 0.4% | 80.99 ± 1.2% | 205.70 ± 0.8% | 502.95 ± 2.9% | 4856.02 ± 0.1% | 208.44 ± 0.3% | 1.00 | 1.00 | 2.57 | 1.01 |
| literal: a word | 7 | 671.78 ± 0.6% | 720.72 ± 0.2% | 1288.50 ± 0.1% | 522.90 ± 0.2% | 630.44 ± 1.4% | 952.52 ± 0.6% | 30597.82 ± 0.7% | 669.95 ± 0.5% | 0.93 | 1.00 | 1.28 | 1.07 |
| literal: a word that is not there | 8 | 640.19 ± 0.4% | 694.81 ± 0.2% | 1205.59 ± 0.1% | 479.83 ± 0.3% | 606.60 ± 1.6% | 903.03 ± 0.4% | 29583.27 ± 0.1% | 640.30 ± 0.2% | 0.92 | 1.00 | 1.33 | 1.06 |
| literal: one of four words | 26 | 255.75 ± 0.2% | 420.48 ± 0.3% | 567.10 ± 0.1% | 50.30 ± 1.3% | 243.39 ± 1.5% | 374.74 ± 1.1% | 15799.51 ± 0.2% | 256.02 ± 0.3% | 0.61 | 1.00 | 5.08 | 1.05 |
| literal: a word in any case | 11 | 523.77 ± 0.5% | 565.82 ± 0.4% | 875.89 ± 0.3% | 15.92 ± 1.6% | 664.87 ± 0.6% | refused | 23854.96 ± 0.1% | 523.44 ± 0.1% | 0.93 | 1.00 | 32.90 | 0.79 |
| literal: an href attribute | 12 | 348.28 ± 0.5% | 360.01 ± 0.4% | 466.65 ± 0.4% | 45.87 ± 0.5% | 502.00 ± 1.4% | 774.02 ± 1.1% | 22405.44 ± 0.4% | 348.00 ± 0.5% | 0.97 | 1.00 | 7.59 | 0.69 |
| literal: a word, second text | 10 | 594.95 ± 0.4% | 655.55 ± 0.5% | 1093.81 ± 0.1% | 402.03 ± 0.2% | 539.64 ± 2.0% | 799.64 ± 0.4% | 27517.40 ± 0.3% | 594.49 ± 0.2% | 0.91 | 1.00 | 1.48 | 1.10 |
| class: two capitalized words | 23 | 452.87 ± 0.3% | 481.24 ± 0.7% | 688.55 ± 0.4% | 100.03 ± 0.4% | 507.17 ± 0.7% | 748.58 ± 0.3% | 6391.28 ± 0.1% | 452.97 ± 0.3% | 0.94 | 1.00 | 4.53 | 0.89 |
| class: a word that ends in ing | 9 | 590.63 ± 0.4% | 656.75 ± 0.4% | 1139.02 ± 0.5% | 131.48 ± 2.0% | 760.79 ± 0.8% | 1107.87 ± 0.3% | 15984.79 ± 0.2% | 590.14 ± 0.2% | 0.90 | 1.00 | 4.49 | 0.78 |
| class: a word in capitals | 16 | 517.93 ± 0.5% | 557.19 ± 0.7% | 882.01 ± 0.4% | 135.13 ± 0.5% | 755.82 ± 0.9% | 1020.92 ± 0.7% | 8405.65 ± 0.2% | 518.08 ± 0.3% | 0.93 | 1.00 | 3.83 | 0.69 |
| class: a number | 6 | 661.84 ± 0.4% | 722.34 ± 0.2% | 1341.84 ± 0.1% | 41.86 ± 0.7% | 1408.29 ± 1.2% | 1847.46 ± 1.7% | 23176.31 ± 0.2% | 661.74 ± 0.3% | 0.92 | 1.00 | 15.81 | 0.47 |
| class: two capitalized words, second text | 23 | 452.20 ± 0.2% | 481.31 ± 0.5% | 687.94 ± 0.3% | 101.56 ± 0.4% | 508.11 ± 1.2% | 768.74 ± 0.2% | 6393.55 ± 0.2% | 452.19 ± 0.3% | 0.94 | 1.00 | 4.45 | 0.89 |
| other: a word between two words | 13 | 574.39 ± 0.3% | 592.94 ± 0.3% | 937.13 ± 0.3% | 133.47 ± 1.0% | 505.20 ± 1.0% | 812.55 ± 0.6% | 14756.23 ± 0.1% | 573.99 ± 0.4% | 0.97 | 1.00 | 4.30 | 1.14 |
| other: a number before a unit, second text | 15 | 402.77 ± 0.4% | 437.89 ± 0.2% | 602.03 ± 0.2% | 39.59 ± 0.2% | 637.09 ± 8.5% | 888.94 ± 1.2% | 15376.08 ± 0.2% | 402.48 ± 0.2% | 0.92 | 1.00 | 10.17 | 0.63 |
| other: a heading's start tag | 13 | 358.99 ± 0.2% | 363.98 ± 0.5% | 472.40 ± 0.3% | 43.77 ± 0.4% | 625.81 ± 4.6% | 877.54 ± 0.7% | 18577.70 ± 0.1% | 358.63 ± 0.4% | 0.99 | 1.00 | 8.20 | 0.57 |
| other: a whole word | 11 | 614.46 ± 0.1% | 653.06 ± 0.3% | 1083.86 ± 0.1% | 118.56 ± 0.4% | 566.65 ± 2.3% | 836.65 ± 0.5% | 26951.02 ± 1.5% | 615.02 ± 0.5% | 0.94 | 1.00 | 5.18 | 1.08 |
| other: a line's first word, second text | 17 | 554.94 ± 0.7% | 576.83 ± 0.5% | 919.89 ± 0.3% | 129.00 ± 0.2% | 713.77 ± 1.0% | refused | refused | 553.17 ± 0.5% | 0.96 | 1.00 | 4.30 | 0.78 |
| other: fourteen octets before an x | 16 | 112.51 ± 0.7% | 161.36 ± 1.1% | 184.19 ± 1.1% | 15.22 ± 0.5% | 457.57 ± 0.7% | 406.15 ± 0.4% | 13039.94 ± 0.5% | 112.42 ± 0.2% | 0.70 | 1.00 | 7.39 | 0.25 |
| other: a Greek word | 8 | 445.64 ± 0.2% | 586.20 ± 0.5% | 946.63 ± 0.2% | 59.11 ± 0.1% | 1394.57 ± 0.6% | 1785.94 ± 0.4% | refused | 445.58 ± 0.2% | 0.76 | 1.00 | 7.54 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12889.90 ± 1.4% | not timed | not timed | 16440.11 ± 2.1% | 2114.38 ± 15.8% | not timed | not timed | 12967.44 ± 1.0% | | 0.99 | 0.78 | 6.10 |
| 01-literal/sherlock-casei-en | 522 | 3882.43 ± 0.4% | not timed | not timed | 3595.46 ± 0.2% | 32.45 ± 0.5% | not timed | not timed | 3876.30 ± 0.5% | | 1.00 | 1.08 | 119.66 |
| 01-literal/sherlock-ru | 724 | 13609.29 ± 2.1% | not timed | not timed | 17306.42 ± 0.3% | 1536.83 ± 15.2% | not timed | not timed | 13605.31 ± 1.0% | | 1.00 | 0.79 | 8.86 |
| 01-literal/sherlock-casei-ru | 746 | 5231.66 ± 0.3% | not timed | not timed | 3322.20 ± 0.2% | 31.58 ± 1.0% | not timed | not timed | 5243.81 ± 0.3% | | 1.00 | 1.57 | 165.66 |
| 01-literal/sherlock-zh | 30 | 16997.30 ± 0.9% | not timed | not timed | 18736.29 ± 0.8% | 2688.55 ± 6.7% | not timed | not timed | 16927.21 ± 0.7% | | 1.00 | 0.91 | 6.32 |
| 02-literal-alternate/sherlock-en | 714 | 5828.53 ± 0.2% | not timed | not timed | 3948.36 ± 0.1% | 16.61 ± 0.2% | not timed | not timed | 5827.97 ± 0.2% | | 1.00 | 1.48 | 350.85 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1663.26 ± 0.7% | not timed | not timed | 697.49 ± 0.4% | 11.10 ± 7.1% | not timed | not timed | 1662.50 ± 1.1% | | 1.00 | 2.38 | 149.83 |
| 02-literal-alternate/sherlock-ru | 899 | 4643.55 ± 0.3% | not timed | not timed | 3256.81 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 4649.49 ± 0.1% | | 1.00 | 1.43 | 205.45 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1781.63 ± 0.3% | not timed | not timed | 1231.47 ± 0.2% | 9.14 ± 0.2% | not timed | not timed | 1778.41 ± 0.3% | | 1.00 | 1.45 | 194.84 |
| 02-literal-alternate/sherlock-zh | 207 | 7083.59 ± 0.2% | not timed | not timed | 4165.84 ± 0.1% | 31.54 ± 0.1% | not timed | not timed | 7074.03 ± 0.3% | | 1.00 | 1.70 | 224.61 |
| 03-date/ascii | 111817 | 124.88 ± 0.9% | not timed | not timed | 96.27 ± 0.1% | 0.20 ± 3.3% | not timed | not timed | 123.49 ± 1.3% | | 1.01 | 1.30 | 621.16 |
| 04-ruff-noqa/real | 84 | 551.51 ± 0.1% | not timed | not timed | 460.36 ± 0.2% | 19.52 ± 1.2% | not timed | not timed | 555.51 ± 0.1% | | 0.99 | 1.20 | 28.25 |
| 04-ruff-noqa/tweaked | 44 | 545.40 ± 0.3% | not timed | not timed | 460.30 ± 0.1% | 363.62 ± 0.6% | not timed | not timed | 539.48 ± 0.2% | | 1.01 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.68 ± 0.2% | not timed | not timed | 5.10 ± 0.2% | 0.20 ± 3.8% | not timed | not timed | 3.69 ± 0.2% | | 1.00 | 0.72 | 18.03 |
| 06-cloud-flare-redos/original | 107 | 270.57 ± 0.3% | not timed | not timed | 217.62 ± 0.0% | 24.99 ± 0.1% | not timed | not timed | 269.38 ± 0.2% | | 1.00 | 1.24 | 10.83 |
| 06-cloud-flare-redos/simplified-short | 102 | 263.65 ± 0.5% | not timed | not timed | 228.83 ± 0.1% | 26.74 ± 0.3% | not timed | not timed | 265.09 ± 0.6% | | 0.99 | 1.15 | 9.86 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.34 ± 0.1% | not timed | not timed | 255.75 ± 0.1% | 28.85 ± 0.1% | not timed | not timed | 294.35 ± 0.0% | | 1.00 | 1.15 | 10.20 |
| 07-unicode-character-data/parse-line | 558784 | 239.87 ± 0.8% | not timed | not timed | 167.17 ± 0.1% | 42.72 ± 8.0% | not timed | not timed | 240.60 ± 1.3% | | 1.00 | 1.43 | 5.61 |
| 08-words/all-english | 56691 | 119.39 ± 0.2% | not timed | not timed | 82.71 ± 0.1% | 11.56 ± 10.6% | not timed | not timed | 119.49 ± 0.4% | | 1.00 | 1.44 | 10.33 |
| 08-words/long-english | 839 | 1005.74 ± 0.1% | not timed | not timed | 597.92 ± 0.2% | 32.60 ± 10.1% | not timed | not timed | 1005.01 ± 0.3% | | 1.00 | 1.68 | 30.85 |
| 09-aws-keys/full | 0 | 412.96 ± 0.0% | not timed | not timed | 458.25 ± 0.1% | 64.46 ± 0.3% | not timed | not timed | 412.96 ± 0.2% | | 1.00 | 0.90 | 6.41 |
| 09-aws-keys/quick | 0 | 738.02 ± 0.1% | not timed | not timed | 992.33 ± 0.1% | 418.81 ± 1.8% | not timed | not timed | 730.76 ± 0.1% | | 1.01 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 633.74 ± 0.6% | not timed | not timed | 517.33 ± 1.3% | 19.50 ± 0.6% | not timed | not timed | 632.73 ± 0.5% | | 1.00 | 1.23 | 32.49 |
| 10-bounded-repeat/letters-ru | 3475 | 380.36 ± 0.1% | not timed | not timed | 477.97 ± 0.2% | 21.92 ± 20.0% | not timed | not timed | 378.73 ± 0.3% | | 1.00 | 0.80 | 17.35 |
| 10-bounded-repeat/context | 53 | 79.34 ± 1.0% | not timed | not timed | 65.81 ± 0.5% | 19.81 ± 0.2% | not timed | not timed | 79.32 ± 1.1% | | 1.00 | 1.21 | 4.01 |
| 10-bounded-repeat/capitals | 11 | 1045.49 ± 0.1% | not timed | not timed | 618.54 ± 0.1% | 36.40 ± 0.1% | not timed | not timed | 1045.34 ± 0.1% | | 1.00 | 1.69 | 28.72 |
| 11-unstructured-to-json/extract | 600 | 47.72 ± 0.1% | not timed | not timed | 77.80 ± 0.3% | 49.60 ± 0.7% | not timed | not timed | 46.78 ± 0.8% | | 1.02 | 0.61 | 0.96 |
| 12-dictionary/single | 1 | 573.24 ± 0.4% | not timed | not timed | 562.53 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 572.33 ± 0.2% | | 1.00 | 1.02 | 1434.25 |
| 14-quadratic/1x | 100 | 13.06 ± 0.5% | not timed | not timed | 10.00 ± 0.1% | 0.98 ± 3.2% | not timed | not timed | 12.92 ± 1.2% | | 1.01 | 1.31 | 13.28 |
| 14-quadratic/2x | 200 | 8.00 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.54 ± 1.8% | not timed | not timed | 7.96 ± 1.5% | | 1.01 | 1.44 | 14.90 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.4% | not timed | not timed | 1.86 ± 0.2% | | 1.00 | 1.53 | 16.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.34 ± 0.8% | 0.55 ± 3.1% | not timed | not timed | 1.54 ± 0.6% | | 1.01 | 4.49 | 2.82 |
| 04-ruff-noqa/compile-real | 1 | 87.05 ± 0.6% | not timed | not timed | 13.92 ± 0.2% | 139.83 ± 1.9% | not timed | not timed | 86.54 ± 0.9% | | 1.01 | 6.25 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.19 ± 0.1% | not timed | not timed | 2.52 ± 1.0% | 6.51 ± 1.5% | not timed | not timed | 14.05 ± 1.5% | | 1.01 | 5.64 | 2.18 |
| 07-unicode-character-data/compile | 1 | 55.35 ± 0.2% | not timed | not timed | 25.79 ± 0.1% | 36.27 ± 4.8% | not timed | not timed | 55.26 ± 1.2% | | 1.00 | 2.15 | 1.53 |
| 09-aws-keys/compile-full | 1 | 42.21 ± 1.3% | not timed | not timed | 8.31 ± 0.3% | 23.40 ± 2.3% | not timed | not timed | 42.10 ± 1.3% | | 1.00 | 5.08 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 189.19 ± 0.1% | not timed | not timed | 47.22 ± 0.2% | 134.10 ± 2.1% | not timed | not timed | 189.38 ± 0.7% | | 1.00 | 4.01 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.55 ± 0.7% | not timed | not timed | 11.24 ± 0.3% | 16.26 ± 3.1% | not timed | not timed | 14.39 ± 1.9% | | 1.01 | 1.29 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.39 ± 0.3% | not timed | not timed | 8.13 ± 0.2% | 24.06 ± 3.1% | not timed | not timed | 84.89 ± 1.0% | | 1.01 | 10.50 | 3.55 |
| 11-unstructured-to-json/compile | 1 | 86.76 ± 0.4% | not timed | not timed | 41.10 ± 0.6% | 69.06 ± 2.7% | not timed | not timed | 85.89 ± 1.0% | | 1.01 | 2.11 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 15.5% | not timed | not timed | 0.35 ± 0.6% | | 1.01 | 5.06 | 3.70 |

