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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102089674 |
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
| literal: a word | 217 | 16053.84 ± 2.1% | 1042.99 ± 0.1% | 28.61 ± 0.1% | 18015.23 ± 2.3% | 9067.98 ± 8.0% | 17.52 ± 0.1% | 86.67 ± 0.3% | 16021.30 ± 1.6% | 15.39 | 1.00 | 0.89 | 1.77 |
| literal: a word that is not there | 0 | 18608.27 ± 2.5% | 1046.76 ± 0.6% | 28.49 ± 0.5% | 19648.10 ± 1.9% | 28706.13 ± 1.1% | 17.35 ± 0.1% | 82.41 ± 0.1% | 18724.03 ± 1.6% | 17.78 | 0.99 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6159.60 ± 0.6% | 1021.11 ± 0.2% | 14.55 ± 0.1% | 3944.78 ± 0.1% | 21.90 ± 0.2% | 5.30 ± 0.1% | 6.93 ± 0.8% | 6145.45 ± 0.6% | 6.03 | 1.00 | 1.56 | 281.32 |
| literal: a word in any case | 217 | 12478.70 ± 1.0% | 1040.92 ± 0.2% | 21.73 ± 0.1% | 3964.85 ± 0.2% | 38.04 ± 0.3% | refused | differs | 12516.12 ± 0.5% | 11.99 | 1.00 | 3.15 | 328.04 |
| literal: an href attribute | 33 | 13676.83 ± 0.7% | 1046.68 ± 0.4% | 27.13 ± 0.1% | 16641.08 ± 3.1% | 2261.17 ± 0.2% | 13.30 ± 0.2% | 75.65 ± 0.3% | 13734.91 ± 0.7% | 13.07 | 1.00 | 0.82 | 6.05 |
| literal: a word, second text | 123 | 16258.22 ± 1.4% | 1047.47 ± 0.2% | 28.00 ± 0.2% | 18259.60 ± 2.9% | 7803.25 ± 4.3% | 19.73 ± 0.5% | 69.73 ± 0.4% | 16258.28 ± 0.6% | 15.52 | 1.00 | 0.89 | 2.08 |
| class: two capitalized words | 1331 | 1101.74 ± 1.0% | 958.86 ± 0.1% | 25.93 ± 0.2% | 584.90 ± 0.1% | 40.71 ± 12.5% | 14.91 ± 0.4% | 68.87 ± 0.2% | 1102.18 ± 0.3% | 1.15 | 1.00 | 1.88 | 27.06 |
| class: a word that ends in ing | 3399 | 880.87 ± 0.1% | 882.07 ± 0.1% | 17.96 ± 0.2% | 546.93 ± 0.3% | 29.63 ± 3.3% | 8.24 ± 0.2% | 18.43 ± 0.3% | 880.23 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.73 |
| class: a word in capitals | 2332 | 1468.02 ± 0.4% | 946.10 ± 0.1% | 27.60 ± 0.3% | 572.45 ± 0.3% | 43.47 ± 16.7% | 17.15 ± 0.7% | 83.37 ± 0.2% | 1468.23 ± 0.4% | 1.55 | 1.00 | 2.56 | 33.77 |
| class: a number | 8288 | 2059.21 ± 0.5% | 793.42 ± 0.2% | 27.75 ± 0.2% | 1722.99 ± 0.2% | 42.81 ± 11.6% | 0.54 ± 0.9% | 56.67 ± 0.8% | 2052.26 ± 0.7% | 2.60 | 1.00 | 1.20 | 48.10 |
| class: two capitalized words, second text | 5359 | 689.35 ± 0.3% | 687.34 ± 0.4% | 23.14 ± 0.1% | 484.71 ± 0.1% | 35.33 ± 6.3% | 16.76 ± 0.2% | 63.84 ± 0.2% | 686.97 ± 0.1% | 1.00 | 1.00 | 1.42 | 19.51 |
| other: a word between two words | 6104 | 775.92 ± 0.1% | 743.65 ± 0.4% | 23.37 ± 0.2% | 734.07 ± 0.3% | 109.13 ± 15.8% | 11.32 ± 0.2% | 69.85 ± 0.2% | 774.88 ± 0.3% | 1.04 | 1.00 | 1.06 | 7.11 |
| other: a number before a unit, second text | 1481 | 5435.66 ± 0.6% | 978.95 ± 0.1% | 25.83 ± 0.2% | 5633.58 ± 0.4% | 40.79 ± 0.2% | 17.84 ± 0.1% | 66.99 ± 0.3% | 5416.56 ± 0.2% | 5.55 | 1.00 | 0.96 | 133.26 |
| other: a heading's start tag | 110 | 12580.13 ± 0.9% | 1030.54 ± 0.2% | 27.24 ± 0.2% | 1705.33 ± 0.3% | 1583.04 ± 5.9% | 16.13 ± 0.7% | 88.77 ± 0.5% | 12582.26 ± 0.4% | 12.21 | 1.00 | 7.38 | 7.95 |
| other: a whole word | 217 | 13915.21 ± 1.1% | 1040.86 ± 0.2% | 29.54 ± 0.6% | 14176.44 ± 1.5% | 49.34 ± 0.3% | 13.66 ± 0.2% | 55.80 ± 0.5% | 13874.25 ± 0.7% | 13.37 | 1.00 | 0.98 | 282.04 |
| other: a line's first word, second text | 3716 | 1954.56 ± 0.9% | 856.42 ± 0.2% | 31.11 ± 0.1% | 1725.78 ± 0.7% | 62.41 ± 8.4% | refused | refused | 1937.35 ± 0.9% | 2.28 | 1.01 | 1.13 | 31.32 |
| other: fourteen octets before an x | 87 | 19393.36 ± 2.1% | 243.14 ± 0.9% | 5.30 ± 0.2% | 4005.24 ± 0.5% | 10.65 ± 0.2% | differs | 17.74 ± 0.2% | 19341.89 ± 1.2% | 79.76 | 1.00 | 4.84 | 1820.14 |
| other: a Greek word | 21815 | 469.59 ± 0.4% | 316.72 ± 0.4% | 30.66 ± 0.4% | 289.49 ± 0.1% | 49.17 ± 10.0% | differs | refused | 464.56 ± 1.0% | 1.48 | 1.01 | 1.62 | 9.55 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.02 ± 0.1% | 26.00 ± 0.2% | 0.82 ± 0.2% | 19.72 ± 0.4% | 2.77 ± 0.5% | differs | 3.98 ± 0.4% | 26.00 ± 0.1% | 1.00 | 1.00 | 1.32 | 9.40 |
| a UUID | 32895 | 21.19 ± 0.5% | 21.30 ± 0.4% | 0.64 ± 0.1% | 15.08 ± 0.5% | 3.11 ± 0.7% | 0.72 ± 0.6% | 3.58 ± 0.1% | 21.27 ± 0.3% | 0.99 | 1.00 | 1.41 | 6.82 |
| an IPv4 address | 33176 | 36.78 ± 0.3% | 36.72 ± 0.2% | 2.08 ± 0.1% | 28.94 ± 0.2% | 6.66 ± 0.1% | differs | 4.12 ± 0.2% | 36.72 ± 0.1% | 1.00 | 1.00 | 1.27 | 5.53 |
| a date and time | 32954 | 31.15 ± 0.2% | 31.24 ± 0.2% | 1.45 ± 0.2% | 21.15 ± 0.1% | 7.06 ± 0.2% | 1.19 ± 0.1% | 7.09 ± 0.5% | 31.15 ± 0.2% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.51 ± 0.1% | 29.45 ± 0.2% | 0.97 ± 0.2% | 23.04 ± 0.2% | 3.53 ± 0.8% | differs | 2.95 ± 0.3% | 29.47 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.82 ± 0.5% | 8.88 ± 0.5% | 8.83 ± 0.4% | 11.50 ± 0.1% | 4.89 ± 1.6% | 0.91 ± 0.7% | none | 8.89 ± 0.4% | 0.99 | 0.99 | 0.77 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.37 ± 0.3% | 218.00 ± 0.3% | 252.82 ± 0.2% | 86.65 ± 0.6% | 217.17 ± 52.3% | 480.57 ± 1.5% | 3902.11 ± 2.0% | 217.41 ± 0.2% | 1.00 | 1.00 | 2.51 | 1.00 |
| a UUID | 62 | 142.55 ± 0.2% | 142.84 ± 0.3% | 157.40 ± 0.2% | 46.64 ± 0.6% | 97.63 ± 1.6% | 189.61 ± 2.9% | 4268.31 ± 0.5% | 142.54 ± 0.4% | 1.00 | 1.00 | 3.06 | 1.46 |
| an IPv4 address | 29 | 438.30 ± 0.5% | 441.84 ± 0.3% | 616.44 ± 0.3% | 77.20 ± 0.4% | 118.55 ± 13.6% | 301.94 ± 2.4% | 7621.88 ± 0.6% | 437.68 ± 0.9% | 0.99 | 1.00 | 5.68 | 3.70 |
| a date and time | 56 | 319.04 ± 0.3% | 319.76 ± 0.2% | 402.71 ± 0.4% | 73.19 ± 0.5% | 134.31 ± 1.8% | 324.52 ± 1.2% | 4871.37 ± 0.5% | 319.00 ± 0.3% | 1.00 | 1.00 | 4.36 | 2.38 |
| a field path | 39 | 202.79 ± 0.3% | 203.01 ± 0.4% | 233.46 ± 0.2% | 81.14 ± 1.3% | 202.76 ± 2.3% | 498.17 ± 2.8% | 4952.83 ± 3.2% | 202.86 ± 0.3% | 1.00 | 1.00 | 2.50 | 1.00 |
| literal: a word | 7 | 666.95 ± 0.3% | 720.37 ± 0.2% | 1293.93 ± 0.5% | 525.09 ± 0.5% | 618.14 ± 0.5% | 955.83 ± 0.8% | 31148.37 ± 0.1% | 667.37 ± 0.2% | 0.93 | 1.00 | 1.27 | 1.08 |
| literal: a word that is not there | 8 | 635.01 ± 0.6% | 690.45 ± 0.5% | 1213.84 ± 0.6% | 483.42 ± 0.4% | 594.86 ± 1.2% | 903.64 ± 0.6% | 29539.85 ± 0.2% | 634.89 ± 0.7% | 0.92 | 1.00 | 1.31 | 1.07 |
| literal: one of four words | 26 | 255.56 ± 0.2% | 422.09 ± 0.3% | 572.52 ± 0.6% | 50.13 ± 1.1% | 237.02 ± 1.8% | 374.10 ± 1.2% | 15783.61 ± 0.2% | 255.56 ± 0.4% | 0.61 | 1.00 | 5.10 | 1.08 |
| literal: a word in any case | 11 | 518.04 ± 0.6% | 558.32 ± 0.6% | 863.33 ± 0.5% | 15.90 ± 1.5% | 638.86 ± 3.2% | refused | 23675.43 ± 0.2% | 518.43 ± 0.2% | 0.93 | 1.00 | 32.57 | 0.81 |
| literal: an href attribute | 12 | 351.45 ± 0.6% | 362.71 ± 0.7% | 474.18 ± 0.6% | 45.88 ± 0.2% | 493.46 ± 1.7% | 772.94 ± 0.8% | 22284.34 ± 0.1% | 351.15 ± 0.3% | 0.97 | 1.00 | 7.66 | 0.71 |
| literal: a word, second text | 10 | 592.66 ± 1.2% | 654.61 ± 1.0% | 1098.67 ± 0.6% | 403.84 ± 0.2% | 530.45 ± 3.0% | 801.09 ± 0.5% | 27527.04 ± 0.1% | 592.19 ± 0.9% | 0.91 | 1.00 | 1.47 | 1.12 |
| class: two capitalized words | 23 | 458.49 ± 0.3% | 488.05 ± 0.7% | 710.69 ± 0.8% | 100.30 ± 0.2% | 490.83 ± 1.3% | 734.34 ± 0.4% | 6610.32 ± 0.2% | 459.10 ± 0.3% | 0.94 | 1.00 | 4.57 | 0.93 |
| class: a word that ends in ing | 9 | 598.27 ± 0.5% | 667.95 ± 0.6% | 1179.88 ± 0.1% | 131.77 ± 1.6% | 749.24 ± 1.5% | 1095.55 ± 0.8% | 16287.56 ± 0.3% | 598.78 ± 0.2% | 0.90 | 1.00 | 4.54 | 0.80 |
| class: a word in capitals | 16 | 521.73 ± 0.4% | 558.06 ± 0.3% | 885.70 ± 0.7% | 135.57 ± 0.5% | 736.38 ± 0.9% | 1022.96 ± 1.7% | 8721.60 ± 0.2% | 521.43 ± 0.7% | 0.93 | 1.00 | 3.85 | 0.71 |
| class: a number | 6 | 658.38 ± 1.1% | 721.35 ± 1.4% | 1342.40 ± 1.7% | 41.90 ± 0.6% | 1382.65 ± 2.0% | 1847.26 ± 1.6% | 23095.36 ± 0.2% | 658.34 ± 0.3% | 0.91 | 1.00 | 15.71 | 0.48 |
| class: two capitalized words, second text | 23 | 459.23 ± 0.6% | 488.59 ± 0.6% | 712.76 ± 0.5% | 101.83 ± 0.4% | 489.51 ± 1.8% | 757.51 ± 0.5% | 6609.83 ± 0.6% | 458.75 ± 0.2% | 0.94 | 1.00 | 4.51 | 0.94 |
| other: a word between two words | 13 | 582.09 ± 0.6% | 603.08 ± 0.4% | 964.76 ± 0.7% | 132.90 ± 0.5% | 501.19 ± 1.1% | 814.08 ± 0.4% | 15044.82 ± 0.4% | 581.20 ± 0.5% | 0.97 | 1.00 | 4.38 | 1.16 |
| other: a number before a unit, second text | 15 | 401.16 ± 0.4% | 435.34 ± 0.2% | 599.58 ± 0.3% | 39.53 ± 0.4% | 630.36 ± 0.4% | 888.98 ± 1.1% | 15396.09 ± 0.9% | 400.74 ± 0.2% | 0.92 | 1.00 | 10.15 | 0.64 |
| other: a heading's start tag | 13 | 361.57 ± 0.3% | 366.40 ± 0.4% | 478.57 ± 0.4% | 43.77 ± 0.4% | 625.06 ± 0.6% | 878.12 ± 0.6% | 18551.04 ± 0.3% | 361.54 ± 0.1% | 0.99 | 1.00 | 8.26 | 0.58 |
| other: a whole word | 11 | 616.24 ± 0.4% | 655.07 ± 0.4% | 1099.87 ± 0.2% | 117.78 ± 0.4% | 559.27 ± 3.0% | 836.70 ± 0.2% | 27202.18 ± 0.2% | 615.86 ± 0.4% | 0.94 | 1.00 | 5.23 | 1.10 |
| other: a line's first word, second text | 17 | 557.42 ± 0.3% | 577.54 ± 0.4% | 928.25 ± 0.1% | 129.09 ± 0.1% | 696.32 ± 0.8% | refused | refused | 555.95 ± 0.8% | 0.97 | 1.00 | 4.32 | 0.80 |
| other: fourteen octets before an x | 16 | 112.49 ± 0.2% | 161.81 ± 0.2% | 185.65 ± 0.7% | 14.89 ± 0.6% | 446.09 ± 1.7% | 412.09 ± 0.5% | 12011.88 ± 0.5% | 112.51 ± 0.5% | 0.70 | 1.00 | 7.56 | 0.25 |
| other: a Greek word | 8 | 449.85 ± 0.7% | 596.86 ± 1.2% | 977.63 ± 1.3% | 59.08 ± 0.6% | 1375.84 ± 1.1% | 1795.12 ± 0.7% | refused | 450.17 ± 0.3% | 0.75 | 1.00 | 7.61 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12835.00 ± 0.5% | not timed | not timed | 16107.29 ± 1.6% | 2006.50 ± 14.7% | not timed | not timed | 12788.22 ± 0.6% | | 1.00 | 0.80 | 6.40 |
| 01-literal/sherlock-casei-en | 522 | 3936.94 ± 0.7% | not timed | not timed | 3590.50 ± 0.3% | 32.48 ± 0.2% | not timed | not timed | 3931.37 ± 0.2% | | 1.00 | 1.10 | 121.19 |
| 01-literal/sherlock-ru | 724 | 13489.56 ± 0.8% | not timed | not timed | 16851.30 ± 1.3% | 1472.30 ± 14.3% | not timed | not timed | 13516.03 ± 0.8% | | 1.00 | 0.80 | 9.16 |
| 01-literal/sherlock-casei-ru | 746 | 5392.55 ± 0.2% | not timed | not timed | 3328.43 ± 0.1% | 30.62 ± 0.6% | not timed | not timed | 5394.11 ± 0.2% | | 1.00 | 1.62 | 176.14 |
| 01-literal/sherlock-zh | 30 | 16887.86 ± 0.5% | not timed | not timed | 18509.53 ± 1.3% | 2661.34 ± 13.0% | not timed | not timed | 16877.59 ± 0.5% | | 1.00 | 0.91 | 6.35 |
| 02-literal-alternate/sherlock-en | 714 | 5900.35 ± 0.2% | not timed | not timed | 3934.22 ± 0.3% | 16.65 ± 0.1% | not timed | not timed | 5899.58 ± 0.1% | | 1.00 | 1.50 | 354.42 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1700.37 ± 1.3% | not timed | not timed | 697.19 ± 0.3% | 11.06 ± 0.1% | not timed | not timed | 1692.46 ± 0.4% | | 1.00 | 2.44 | 153.72 |
| 02-literal-alternate/sherlock-ru | 899 | 4783.83 ± 0.5% | not timed | not timed | 3251.49 ± 0.1% | 22.65 ± 0.2% | not timed | not timed | 4783.13 ± 0.5% | | 1.00 | 1.47 | 211.19 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1816.05 ± 0.6% | not timed | not timed | 1227.10 ± 0.1% | 9.11 ± 0.1% | not timed | not timed | 1812.10 ± 0.3% | | 1.00 | 1.48 | 199.32 |
| 02-literal-alternate/sherlock-zh | 207 | 7093.28 ± 0.3% | not timed | not timed | 4165.88 ± 0.3% | 31.50 ± 0.1% | not timed | not timed | 7095.80 ± 0.2% | | 1.00 | 1.70 | 225.16 |
| 03-date/ascii | 111817 | 124.40 ± 0.7% | not timed | not timed | 96.36 ± 0.1% | 0.20 ± 4.6% | not timed | not timed | 122.75 ± 0.1% | | 1.01 | 1.29 | 624.10 |
| 04-ruff-noqa/real | 84 | 551.28 ± 0.1% | not timed | not timed | 462.11 ± 0.1% | 19.80 ± 1.2% | not timed | not timed | 552.09 ± 0.2% | | 1.00 | 1.19 | 27.84 |
| 04-ruff-noqa/tweaked | 44 | 553.72 ± 0.3% | not timed | not timed | 459.95 ± 0.1% | 364.20 ± 0.2% | not timed | not timed | 552.53 ± 0.4% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.72 ± 0.1% | not timed | not timed | 4.97 ± 0.1% | 0.21 ± 2.7% | not timed | not timed | 3.71 ± 3.4% | | 1.00 | 0.75 | 18.14 |
| 06-cloud-flare-redos/original | 107 | 183.56 ± 0.5% | not timed | not timed | 216.60 ± 0.4% | 24.91 ± 0.1% | not timed | not timed | 183.34 ± 0.2% | | 1.00 | 0.85 | 7.37 |
| 06-cloud-flare-redos/simplified-short | 102 | 144.43 ± 0.5% | not timed | not timed | 229.01 ± 0.3% | 26.72 ± 0.2% | not timed | not timed | 147.18 ± 0.1% | | 0.98 | 0.63 | 5.41 |
| 06-cloud-flare-redos/simplified-long | 10000 | 157.10 ± 2.2% | not timed | not timed | 255.71 ± 0.2% | 28.84 ± 0.1% | not timed | not timed | 156.98 ± 1.5% | | 1.00 | 0.61 | 5.45 |
| 07-unicode-character-data/parse-line | 558784 | 40.03 ± 0.2% | not timed | not timed | 172.52 ± 0.2% | 41.78 ± 6.1% | not timed | not timed | 39.78 ± 1.3% | | 1.01 | 0.23 | 0.96 |
| 08-words/all-english | 56691 | 103.70 ± 0.5% | not timed | not timed | 82.84 ± 0.1% | 11.73 ± 12.8% | not timed | not timed | 102.99 ± 0.5% | | 1.01 | 1.25 | 8.84 |
| 08-words/long-english | 839 | 997.88 ± 0.2% | not timed | not timed | 597.37 ± 0.1% | 32.57 ± 0.8% | not timed | not timed | 996.65 ± 0.2% | | 1.00 | 1.67 | 30.64 |
| 09-aws-keys/full | 0 | 422.26 ± 0.2% | not timed | not timed | 464.74 ± 0.2% | 64.27 ± 0.1% | not timed | not timed | 422.29 ± 0.1% | | 1.00 | 0.91 | 6.57 |
| 09-aws-keys/quick | 0 | 398.80 ± 0.1% | not timed | not timed | 981.82 ± 0.2% | 421.94 ± 1.5% | not timed | not timed | 398.66 ± 0.1% | | 1.00 | 0.41 | 0.95 |
| 10-bounded-repeat/letters-en | 1833 | 592.50 ± 0.3% | not timed | not timed | 516.03 ± 0.7% | 19.59 ± 0.5% | not timed | not timed | 591.73 ± 0.3% | | 1.00 | 1.15 | 30.25 |
| 10-bounded-repeat/letters-ru | 3475 | 404.55 ± 0.3% | not timed | not timed | 478.89 ± 0.1% | 22.09 ± 9.2% | not timed | not timed | 402.63 ± 0.4% | | 1.00 | 0.84 | 18.31 |
| 10-bounded-repeat/context | 53 | 72.79 ± 2.0% | not timed | not timed | 65.51 ± 3.0% | 19.83 ± 0.1% | not timed | not timed | 73.27 ± 1.8% | | 0.99 | 1.11 | 3.67 |
| 10-bounded-repeat/capitals | 11 | 1039.84 ± 0.2% | not timed | not timed | 616.87 ± 0.1% | 36.72 ± 0.1% | not timed | not timed | 1039.60 ± 0.2% | | 1.00 | 1.69 | 28.32 |
| 11-unstructured-to-json/extract | 600 | 24.43 ± 0.1% | not timed | not timed | 77.88 ± 0.3% | 48.80 ± 0.4% | not timed | not timed | 24.26 ± 0.8% | | 1.01 | 0.31 | 0.50 |
| 12-dictionary/single | 1 | 602.07 ± 0.5% | not timed | not timed | 563.15 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 602.37 ± 0.2% | | 1.00 | 1.07 | 1465.35 |
| 14-quadratic/1x | 100 | 12.64 ± 0.3% | not timed | not timed | 10.06 ± 0.4% | 0.97 ± 4.7% | not timed | not timed | 12.55 ± 2.0% | | 1.01 | 1.26 | 13.01 |
| 14-quadratic/2x | 200 | 7.79 ± 0.8% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.7% | not timed | not timed | 7.74 ± 1.2% | | 1.01 | 1.40 | 14.65 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.5% | not timed | not timed | 1.21 ± 0.2% | 0.11 ± 1.4% | not timed | not timed | 1.83 ± 0.3% | | 1.00 | 1.51 | 15.95 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.52 ± 0.2% | not timed | not timed | 0.34 ± 0.4% | 0.54 ± 3.7% | not timed | not timed | 1.50 ± 1.0% | | 1.01 | 4.43 | 2.78 |
| 04-ruff-noqa/compile-real | 1 | 85.36 ± 0.1% | not timed | not timed | 13.72 ± 0.7% | 138.00 ± 9.1% | not timed | not timed | 84.49 ± 0.8% | | 1.01 | 6.22 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.47 ± 0.3% | not timed | not timed | 2.50 ± 0.2% | 6.39 ± 2.5% | not timed | not timed | 14.42 ± 1.2% | | 1.00 | 5.78 | 2.26 |
| 07-unicode-character-data/compile | 1 | 54.22 ± 0.1% | not timed | not timed | 25.84 ± 0.2% | 35.69 ± 3.0% | not timed | not timed | 53.79 ± 0.6% | | 1.01 | 2.10 | 1.52 |
| 09-aws-keys/compile-full | 1 | 41.94 ± 0.3% | not timed | not timed | 8.17 ± 0.1% | 23.23 ± 2.0% | not timed | not timed | 41.67 ± 0.8% | | 1.01 | 5.13 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 189.23 ± 0.3% | not timed | not timed | 47.03 ± 0.3% | 133.51 ± 3.4% | not timed | not timed | 188.78 ± 0.2% | | 1.00 | 4.02 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.51 ± 1.2% | not timed | not timed | 11.09 ± 0.2% | 15.63 ± 4.5% | not timed | not timed | 14.52 ± 1.6% | | 1.00 | 1.31 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 84.97 ± 1.7% | not timed | not timed | 8.04 ± 0.2% | 23.65 ± 2.3% | not timed | not timed | 83.99 ± 1.3% | | 1.01 | 10.57 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 85.30 ± 0.2% | not timed | not timed | 40.80 ± 0.2% | 67.30 ± 3.4% | not timed | not timed | 84.83 ± 0.5% | | 1.01 | 2.09 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 38.3% | 0.10 ± 31.1% | not timed | not timed | 0.36 ± 0.4% | | 1.01 | 5.22 | 3.76 |

