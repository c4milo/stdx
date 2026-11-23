# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148111589 |
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
| literal: a word | 217 | 15969.92 ± 1.7% | 1040.03 ± 0.1% | 28.11 ± 0.2% | 18055.51 ± 3.8% | 9212.95 ± 8.0% | 17.36 ± 0.4% | 87.08 ± 0.2% | 15964.90 ± 0.6% | 15.36 | 1.00 | 0.88 | 1.73 |
| literal: a word that is not there | 0 | 18463.28 ± 1.7% | 1048.36 ± 0.2% | 28.14 ± 0.3% | 19504.27 ± 1.4% | 27934.74 ± 4.1% | 17.21 ± 0.1% | 82.97 ± 0.3% | 18562.43 ± 1.7% | 17.61 | 0.99 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6059.63 ± 0.6% | 1023.55 ± 0.1% | 14.57 ± 0.2% | 3944.87 ± 1.0% | 21.89 ± 0.1% | 5.24 ± 0.1% | 6.92 ± 0.5% | 6034.36 ± 0.4% | 5.92 | 1.00 | 1.54 | 276.88 |
| literal: a word in any case | 217 | 12566.16 ± 0.7% | 1040.70 ± 0.3% | 21.10 ± 1.8% | 3973.03 ± 0.2% | 38.04 ± 0.2% | refused | differs | 12566.84 ± 0.7% | 12.07 | 1.00 | 3.16 | 330.33 |
| literal: an href attribute | 33 | 13710.58 ± 1.3% | 1047.66 ± 0.2% | 27.06 ± 0.3% | 17093.19 ± 1.0% | 2256.59 ± 0.8% | 13.34 ± 0.2% | 75.90 ± 0.2% | 13750.05 ± 0.5% | 13.09 | 1.00 | 0.80 | 6.08 |
| literal: a word, second text | 123 | 16302.82 ± 0.7% | 1044.45 ± 0.2% | 27.82 ± 0.3% | 18178.13 ± 2.8% | 7765.03 ± 4.8% | 19.68 ± 1.0% | 70.62 ± 0.3% | 16328.28 ± 1.3% | 15.61 | 1.00 | 0.90 | 2.10 |
| class: two capitalized words | 1331 | 1102.57 ± 0.8% | 977.24 ± 0.2% | 25.83 ± 0.2% | 585.39 ± 0.2% | 40.45 ± 12.2% | 14.74 ± 0.2% | 68.80 ± 0.2% | 1105.56 ± 0.2% | 1.13 | 1.00 | 1.88 | 27.26 |
| class: a word that ends in ing | 3399 | 895.48 ± 0.2% | 895.01 ± 0.1% | 17.93 ± 0.5% | 548.06 ± 0.1% | 29.63 ± 3.2% | 8.15 ± 0.3% | 18.39 ± 0.6% | 894.63 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.23 |
| class: a word in capitals | 2332 | 1452.74 ± 0.2% | 948.19 ± 0.1% | 27.50 ± 0.6% | 572.64 ± 0.1% | 43.52 ± 7.3% | 17.09 ± 0.2% | 82.95 ± 0.5% | 1453.73 ± 0.3% | 1.53 | 1.00 | 2.54 | 33.38 |
| class: a number | 8288 | 2001.15 ± 0.3% | 836.84 ± 0.1% | 27.65 ± 0.3% | 1717.11 ± 0.2% | 40.32 ± 15.9% | 0.55 ± 0.0% | 56.33 ± 0.6% | 1994.66 ± 0.7% | 2.39 | 1.00 | 1.17 | 49.63 |
| class: two capitalized words, second text | 5359 | 743.59 ± 0.1% | 743.09 ± 0.1% | 23.12 ± 0.3% | 484.44 ± 0.1% | 34.10 ± 10.1% | 16.67 ± 0.1% | 63.90 ± 0.5% | 742.86 ± 0.2% | 1.00 | 1.00 | 1.53 | 21.81 |
| other: a word between two words | 6104 | 753.17 ± 0.2% | 776.43 ± 0.2% | 23.38 ± 0.4% | 731.69 ± 0.2% | 108.87 ± 13.1% | 11.23 ± 0.1% | 70.02 ± 0.2% | 753.35 ± 0.1% | 0.97 | 1.00 | 1.03 | 6.92 |
| other: a number before a unit, second text | 1481 | 5467.57 ± 0.6% | 985.17 ± 0.2% | 25.70 ± 0.3% | 5633.59 ± 0.7% | 40.76 ± 11.1% | 17.82 ± 0.2% | 67.06 ± 0.4% | 5447.90 ± 0.6% | 5.55 | 1.00 | 0.97 | 134.14 |
| other: a heading's start tag | 110 | 12588.24 ± 0.5% | 1034.60 ± 0.3% | 27.16 ± 0.2% | 1713.26 ± 0.4% | 1583.74 ± 5.6% | 16.18 ± 0.3% | 89.18 ± 0.4% | 12590.70 ± 0.4% | 12.17 | 1.00 | 7.35 | 7.95 |
| other: a whole word | 217 | 13898.06 ± 1.2% | 1038.60 ± 0.1% | 29.14 ± 0.2% | 14433.72 ± 1.3% | 49.41 ± 0.1% | 13.40 ± 0.1% | 55.98 ± 0.3% | 13924.15 ± 1.1% | 13.38 | 1.00 | 0.96 | 281.30 |
| other: a line's first word, second text | 3716 | 1977.08 ± 0.3% | 876.79 ± 0.1% | 30.46 ± 0.3% | 1716.25 ± 0.5% | 61.51 ± 6.5% | refused | refused | 1967.94 ± 0.2% | 2.25 | 1.00 | 1.15 | 32.14 |
| other: fourteen octets before an x | 87 | 19400.69 ± 1.0% | 219.90 ± 0.7% | 6.58 ± 0.1% | 4011.61 ± 0.3% | 10.63 ± 0.4% | differs | 17.77 ± 0.2% | 19491.63 ± 1.1% | 88.22 | 1.00 | 4.84 | 1825.93 |
| other: a Greek word | 21815 | 514.04 ± 0.5% | 414.23 ± 0.4% | 31.02 ± 0.1% | 289.37 ± 0.3% | 44.30 ± 10.4% | differs | refused | 511.36 ± 0.5% | 1.24 | 1.01 | 1.78 | 11.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.1% | 25.65 ± 0.2% | 0.87 ± 0.4% | 19.79 ± 0.5% | 2.78 ± 0.4% | differs | 3.99 ± 0.2% | 25.81 ± 0.2% | 1.01 | 1.00 | 1.31 | 9.29 |
| a UUID | 32895 | 21.10 ± 0.3% | 21.14 ± 0.2% | 0.65 ± 0.2% | 15.16 ± 0.4% | 3.09 ± 0.2% | 0.72 ± 0.4% | 3.58 ± 0.3% | 21.17 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.83 |
| an IPv4 address | 33176 | 36.92 ± 0.1% | 36.88 ± 0.3% | 2.10 ± 0.5% | 28.89 ± 0.2% | 6.68 ± 0.2% | differs | 4.17 ± 0.2% | 36.89 ± 0.3% | 1.00 | 1.00 | 1.28 | 5.53 |
| a date and time | 32954 | 31.18 ± 0.3% | 31.27 ± 0.3% | 1.47 ± 0.2% | 21.16 ± 0.4% | 7.04 ± 0.5% | 1.20 ± 0.1% | 7.09 ± 0.5% | 31.16 ± 0.2% | 1.00 | 1.00 | 1.47 | 4.43 |
| a field path | 32606 | 29.49 ± 0.2% | 29.42 ± 0.2% | 1.03 ± 0.2% | 23.02 ± 0.1% | 3.50 ± 0.7% | differs | 2.91 ± 0.1% | 29.44 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.42 ± 0.6% | 11.50 ± 0.3% | 11.50 ± 0.2% | 11.43 ± 0.3% | 4.91 ± 2.9% | 0.91 ± 0.7% | none | 11.44 ± 0.4% | 0.99 | 1.00 | 1.00 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.16 ± 0.5% | 222.14 ± 0.3% | 258.09 ± 0.2% | 86.53 ± 0.4% | 220.01 ± 0.8% | 478.65 ± 2.0% | 3885.38 ± 2.6% | 221.15 ± 0.2% | 1.00 | 1.00 | 2.56 | 1.01 |
| a UUID | 62 | 145.28 ± 0.2% | 145.63 ± 0.2% | 160.79 ± 0.2% | 46.46 ± 0.6% | 99.14 ± 0.6% | 189.65 ± 2.7% | 4439.39 ± 1.0% | 145.23 ± 0.5% | 1.00 | 1.00 | 3.13 | 1.47 |
| an IPv4 address | 29 | 436.85 ± 0.3% | 440.74 ± 0.2% | 610.38 ± 0.3% | 77.16 ± 0.3% | 131.35 ± 1.3% | 302.35 ± 1.3% | 7644.32 ± 0.2% | 436.81 ± 0.5% | 0.99 | 1.00 | 5.66 | 3.33 |
| a date and time | 56 | 318.34 ± 0.5% | 319.84 ± 0.2% | 400.08 ± 0.2% | 73.21 ± 0.5% | 137.12 ± 2.8% | 324.35 ± 1.3% | 4939.91 ± 0.9% | 318.10 ± 0.5% | 1.00 | 1.00 | 4.35 | 2.32 |
| a field path | 39 | 208.79 ± 0.2% | 209.14 ± 0.1% | 241.14 ± 0.2% | 80.98 ± 1.3% | 206.11 ± 1.0% | 498.81 ± 2.8% | 4981.44 ± 0.8% | 208.73 ± 0.1% | 1.00 | 1.00 | 2.58 | 1.01 |
| literal: a word | 7 | 659.87 ± 1.0% | 710.75 ± 0.3% | 1261.33 ± 0.2% | 526.61 ± 0.1% | 628.64 ± 1.7% | 953.61 ± 0.6% | 30727.04 ± 0.1% | 659.65 ± 0.9% | 0.93 | 1.00 | 1.25 | 1.05 |
| literal: a word that is not there | 8 | 631.64 ± 0.3% | 685.19 ± 0.3% | 1187.20 ± 0.2% | 484.05 ± 0.1% | 603.89 ± 1.2% | 905.44 ± 0.5% | 29709.29 ± 0.2% | 631.54 ± 0.2% | 0.92 | 1.00 | 1.30 | 1.05 |
| literal: one of four words | 26 | 253.93 ± 0.3% | 416.71 ± 0.3% | 563.14 ± 0.3% | 50.32 ± 1.2% | 243.37 ± 1.1% | 373.69 ± 1.0% | 15899.58 ± 0.2% | 253.86 ± 0.2% | 0.61 | 1.00 | 5.05 | 1.04 |
| literal: a word in any case | 11 | 517.73 ± 0.6% | 558.33 ± 0.6% | 859.65 ± 0.3% | 15.86 ± 1.5% | 650.99 ± 1.7% | refused | 23893.83 ± 0.4% | 517.47 ± 0.8% | 0.93 | 1.00 | 32.65 | 0.80 |
| literal: an href attribute | 12 | 350.90 ± 0.6% | 362.29 ± 0.4% | 472.20 ± 0.3% | 45.92 ± 0.3% | 499.08 ± 1.5% | 775.11 ± 0.7% | 22495.90 ± 0.1% | 351.14 ± 0.9% | 0.97 | 1.00 | 7.64 | 0.70 |
| literal: a word, second text | 10 | 586.69 ± 0.6% | 646.45 ± 0.4% | 1078.19 ± 0.2% | 401.62 ± 0.2% | 532.65 ± 2.2% | 799.93 ± 0.4% | 27796.39 ± 0.4% | 587.24 ± 0.4% | 0.91 | 1.00 | 1.46 | 1.10 |
| class: two capitalized words | 23 | 457.63 ± 0.3% | 487.39 ± 0.1% | 702.62 ± 0.3% | 100.21 ± 0.1% | 504.67 ± 1.6% | 738.45 ± 0.6% | 6644.40 ± 1.1% | 457.84 ± 0.6% | 0.94 | 1.00 | 4.57 | 0.91 |
| class: a word that ends in ing | 9 | 594.47 ± 0.6% | 661.79 ± 0.2% | 1155.79 ± 0.1% | 132.55 ± 2.1% | 758.17 ± 8.9% | 1108.80 ± 0.5% | 16345.82 ± 0.3% | 592.39 ± 0.6% | 0.90 | 1.00 | 4.48 | 0.78 |
| class: a word in capitals | 16 | 521.28 ± 0.2% | 561.78 ± 0.3% | 897.58 ± 0.4% | 135.20 ± 0.7% | 754.30 ± 1.7% | 1022.98 ± 0.5% | 8732.58 ± 0.1% | 522.50 ± 0.5% | 0.93 | 1.00 | 3.86 | 0.69 |
| class: a number | 6 | 657.95 ± 0.3% | 719.33 ± 0.5% | 1340.45 ± 0.2% | 41.89 ± 0.7% | 1404.96 ± 1.5% | 1851.80 ± 1.4% | 23327.95 ± 0.2% | 658.18 ± 0.4% | 0.91 | 1.00 | 15.71 | 0.47 |
| class: two capitalized words, second text | 23 | 458.53 ± 0.3% | 488.02 ± 0.3% | 703.40 ± 0.2% | 101.68 ± 0.4% | 500.87 ± 1.8% | 760.23 ± 0.9% | 6650.91 ± 0.1% | 457.95 ± 0.3% | 0.94 | 1.00 | 4.51 | 0.92 |
| other: a word between two words | 13 | 574.90 ± 0.3% | 593.36 ± 0.9% | 942.05 ± 0.6% | 133.61 ± 0.7% | 501.56 ± 1.7% | 810.34 ± 0.5% | 15105.61 ± 0.1% | 574.33 ± 0.6% | 0.97 | 1.00 | 4.30 | 1.15 |
| other: a number before a unit, second text | 15 | 401.34 ± 0.2% | 436.14 ± 0.4% | 601.83 ± 0.5% | 39.64 ± 0.5% | 627.53 ± 3.3% | 888.85 ± 0.8% | 15421.59 ± 0.3% | 401.74 ± 0.1% | 0.92 | 1.00 | 10.12 | 0.64 |
| other: a heading's start tag | 13 | 360.90 ± 0.4% | 364.81 ± 0.4% | 476.28 ± 0.3% | 44.10 ± 0.4% | 620.76 ± 2.4% | 872.57 ± 0.7% | 18588.85 ± 0.4% | 360.01 ± 0.3% | 0.99 | 1.00 | 8.18 | 0.58 |
| other: a whole word | 11 | 608.45 ± 0.4% | 643.95 ± 0.6% | 1073.36 ± 0.2% | 118.66 ± 0.4% | 554.47 ± 2.6% | 834.93 ± 0.7% | 27114.66 ± 0.7% | 607.93 ± 0.3% | 0.94 | 1.00 | 5.13 | 1.10 |
| other: a line's first word, second text | 17 | 554.67 ± 0.5% | 575.33 ± 0.5% | 922.19 ± 0.1% | 129.45 ± 0.2% | 703.56 ± 1.4% | refused | refused | 552.70 ± 0.7% | 0.96 | 1.00 | 4.28 | 0.79 |
| other: fourteen octets before an x | 16 | 112.11 ± 0.4% | 162.93 ± 0.4% | 186.19 ± 0.7% | 15.16 ± 0.4% | 448.78 ± 1.8% | 411.42 ± 0.4% | 12886.55 ± 0.8% | 112.04 ± 0.6% | 0.69 | 1.00 | 7.39 | 0.25 |
| other: a Greek word | 8 | 446.99 ± 0.3% | 586.57 ± 0.6% | 951.32 ± 0.2% | 59.24 ± 1.2% | 1383.98 ± 1.0% | 1787.48 ± 0.3% | refused | 446.97 ± 0.2% | 0.76 | 1.00 | 7.55 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12799.30 ± 0.3% | not timed | not timed | 16203.06 ± 1.2% | 2153.77 ± 6.1% | not timed | not timed | 12771.22 ± 0.7% | | 1.00 | 0.79 | 5.94 |
| 01-literal/sherlock-casei-en | 522 | 4476.86 ± 0.9% | not timed | not timed | 3592.38 ± 0.2% | 32.55 ± 0.1% | not timed | not timed | 4479.34 ± 0.4% | | 1.00 | 1.25 | 137.55 |
| 01-literal/sherlock-ru | 724 | 13540.22 ± 0.7% | not timed | not timed | 17301.70 ± 0.5% | 1471.27 ± 11.6% | not timed | not timed | 13532.28 ± 0.2% | | 1.00 | 0.78 | 9.20 |
| 01-literal/sherlock-casei-ru | 746 | 5287.03 ± 0.2% | not timed | not timed | 3330.84 ± 0.1% | 31.65 ± 0.4% | not timed | not timed | 5289.14 ± 0.2% | | 1.00 | 1.59 | 167.03 |
| 01-literal/sherlock-zh | 30 | 16811.35 ± 0.8% | not timed | not timed | 18302.54 ± 0.8% | 2585.30 ± 7.7% | not timed | not timed | 16793.25 ± 0.8% | | 1.00 | 0.92 | 6.50 |
| 02-literal-alternate/sherlock-en | 714 | 5755.14 ± 0.3% | not timed | not timed | 3942.71 ± 0.1% | 16.62 ± 0.2% | not timed | not timed | 5753.44 ± 0.4% | | 1.00 | 1.46 | 346.20 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1708.48 ± 1.4% | not timed | not timed | 695.46 ± 0.2% | 11.12 ± 5.1% | not timed | not timed | 1699.95 ± 0.9% | | 1.01 | 2.46 | 153.69 |
| 02-literal-alternate/sherlock-ru | 899 | 4639.06 ± 0.1% | not timed | not timed | 3253.89 ± 0.2% | 22.62 ± 0.1% | not timed | not timed | 4642.43 ± 0.1% | | 1.00 | 1.43 | 205.13 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1809.32 ± 0.7% | not timed | not timed | 1227.34 ± 0.3% | 9.11 ± 0.2% | not timed | not timed | 1801.69 ± 0.3% | | 1.00 | 1.47 | 198.60 |
| 02-literal-alternate/sherlock-zh | 207 | 7041.47 ± 0.3% | not timed | not timed | 4166.09 ± 0.2% | 31.53 ± 0.1% | not timed | not timed | 7032.75 ± 0.5% | | 1.00 | 1.69 | 223.31 |
| 03-date/ascii | 111817 | 127.53 ± 0.7% | not timed | not timed | 93.73 ± 0.0% | 0.20 ± 1.6% | not timed | not timed | 126.69 ± 0.2% | | 1.01 | 1.36 | 638.80 |
| 04-ruff-noqa/real | 84 | 553.56 ± 0.2% | not timed | not timed | 461.40 ± 0.7% | 19.55 ± 1.3% | not timed | not timed | 553.48 ± 0.1% | | 1.00 | 1.20 | 28.32 |
| 04-ruff-noqa/tweaked | 44 | 547.08 ± 0.1% | not timed | not timed | 461.75 ± 0.1% | 362.73 ± 0.3% | not timed | not timed | 544.98 ± 0.1% | | 1.00 | 1.18 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.97 ± 0.2% | not timed | not timed | 5.10 ± 0.2% | 0.20 ± 6.2% | not timed | not timed | 4.16 ± 0.5% | | 0.95 | 0.78 | 19.52 |
| 06-cloud-flare-redos/original | 107 | 263.73 ± 0.1% | not timed | not timed | 217.63 ± 0.3% | 24.57 ± 4.3% | not timed | not timed | 262.13 ± 8.1% | | 1.01 | 1.21 | 10.73 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.19 ± 0.3% | not timed | not timed | 228.60 ± 0.1% | 26.57 ± 3.2% | not timed | not timed | 258.84 ± 0.6% | | 1.00 | 1.13 | 9.76 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.14 ± 0.3% | not timed | not timed | 255.82 ± 0.1% | 28.78 ± 0.2% | not timed | not timed | 286.14 ± 0.1% | | 1.00 | 1.12 | 9.94 |
| 07-unicode-character-data/parse-line | 558784 | 240.10 ± 0.2% | not timed | not timed | 171.65 ± 0.1% | 42.08 ± 1.5% | not timed | not timed | 240.15 ± 1.3% | | 1.00 | 1.40 | 5.71 |
| 08-words/all-english | 56691 | 120.89 ± 0.3% | not timed | not timed | 82.76 ± 0.2% | 11.65 ± 10.6% | not timed | not timed | 120.52 ± 0.4% | | 1.00 | 1.46 | 10.37 |
| 08-words/long-english | 839 | 1006.44 ± 0.1% | not timed | not timed | 597.57 ± 0.2% | 32.43 ± 1.6% | not timed | not timed | 1005.44 ± 0.2% | | 1.00 | 1.68 | 31.04 |
| 09-aws-keys/full | 0 | 409.57 ± 0.3% | not timed | not timed | 461.16 ± 0.1% | 64.58 ± 3.4% | not timed | not timed | 409.18 ± 0.1% | | 1.00 | 0.89 | 6.34 |
| 09-aws-keys/quick | 0 | 736.01 ± 0.2% | not timed | not timed | 987.36 ± 0.2% | 418.49 ± 0.5% | not timed | not timed | 732.90 ± 0.1% | | 1.00 | 0.75 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 639.52 ± 0.4% | not timed | not timed | 517.22 ± 1.1% | 19.53 ± 0.2% | not timed | not timed | 638.45 ± 0.3% | | 1.00 | 1.24 | 32.74 |
| 10-bounded-repeat/letters-ru | 3475 | 384.42 ± 0.2% | not timed | not timed | 478.35 ± 0.2% | 21.75 ± 16.8% | not timed | not timed | 384.40 ± 0.5% | | 1.00 | 0.80 | 17.67 |
| 10-bounded-repeat/context | 53 | 78.62 ± 1.2% | not timed | not timed | 65.64 ± 0.5% | 19.83 ± 0.2% | not timed | not timed | 78.02 ± 1.3% | | 1.01 | 1.20 | 3.96 |
| 10-bounded-repeat/capitals | 11 | 1040.13 ± 0.2% | not timed | not timed | 616.79 ± 0.1% | 36.59 ± 0.1% | not timed | not timed | 1040.66 ± 0.1% | | 1.00 | 1.69 | 28.42 |
| 11-unstructured-to-json/extract | 600 | 49.70 ± 0.1% | not timed | not timed | 77.42 ± 0.2% | 49.17 ± 1.0% | not timed | not timed | 49.45 ± 0.7% | | 1.01 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 566.46 ± 0.4% | not timed | not timed | 560.61 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 568.94 ± 0.4% | | 1.00 | 1.01 | 1415.64 |
| 14-quadratic/1x | 100 | 9.65 ± 0.7% | not timed | not timed | 10.04 ± 0.1% | 0.97 ± 3.4% | not timed | not timed | 9.67 ± 0.4% | | 1.00 | 0.96 | 9.91 |
| 14-quadratic/2x | 200 | 5.57 ± 0.1% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 0.7% | not timed | not timed | 5.56 ± 1.1% | | 1.00 | 1.01 | 10.46 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.4% | not timed | not timed | 1.20 ± 0.2% | 0.12 ± 2.0% | not timed | not timed | 1.26 ± 0.4% | | 1.00 | 1.05 | 10.92 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.5% | not timed | not timed | 0.34 ± 0.6% | 0.54 ± 3.9% | not timed | not timed | 1.53 ± 0.9% | | 1.01 | 4.47 | 2.88 |
| 04-ruff-noqa/compile-real | 1 | 86.76 ± 0.1% | not timed | not timed | 13.78 ± 0.2% | 134.28 ± 1.7% | not timed | not timed | 86.36 ± 0.4% | | 1.00 | 6.30 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.30 ± 0.2% | not timed | not timed | 2.52 ± 0.7% | 6.25 ± 2.9% | not timed | not timed | 14.25 ± 0.3% | | 1.00 | 5.67 | 2.29 |
| 07-unicode-character-data/compile | 1 | 54.44 ± 0.3% | not timed | not timed | 25.68 ± 0.3% | 35.35 ± 2.7% | not timed | not timed | 53.97 ± 1.0% | | 1.01 | 2.12 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.29 ± 0.2% | not timed | not timed | 8.25 ± 0.6% | 22.95 ± 2.2% | not timed | not timed | 42.09 ± 0.4% | | 1.00 | 5.13 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 189.08 ± 0.1% | not timed | not timed | 47.01 ± 0.2% | 131.62 ± 3.8% | not timed | not timed | 188.96 ± 1.1% | | 1.00 | 4.02 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 14.68 ± 1.7% | not timed | not timed | 11.09 ± 0.2% | 15.68 ± 3.0% | not timed | not timed | 14.60 ± 1.6% | | 1.01 | 1.32 | 0.94 |
| 10-bounded-repeat/compile-capitals | 1 | 84.97 ± 0.4% | not timed | not timed | 8.08 ± 0.2% | 23.29 ± 1.7% | not timed | not timed | 84.44 ± 0.8% | | 1.01 | 10.52 | 3.65 |
| 11-unstructured-to-json/compile | 1 | 85.47 ± 0.2% | not timed | not timed | 40.86 ± 0.8% | 66.19 ± 3.3% | not timed | not timed | 85.07 ± 0.6% | | 1.00 | 2.09 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.3% | 0.10 ± 14.2% | not timed | not timed | 0.35 ± 1.6% | | 1.01 | 5.23 | 3.67 |

