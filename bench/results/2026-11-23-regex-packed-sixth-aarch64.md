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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102068513 |
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
| literal: a word | 217 | 15964.93 ± 0.8% | 1041.89 ± 0.3% | 28.65 ± 0.4% | 17842.51 ± 1.8% | 9130.60 ± 8.3% | 17.30 ± 0.3% | 86.83 ± 0.2% | 15982.54 ± 0.7% | 15.32 | 1.00 | 0.89 | 1.75 |
| literal: a word that is not there | 0 | 18587.91 ± 2.4% | 1044.72 ± 0.3% | 28.61 ± 0.3% | 19153.06 ± 2.4% | 28625.09 ± 4.5% | 17.17 ± 0.3% | 82.60 ± 0.2% | 18667.71 ± 2.0% | 17.79 | 1.00 | 0.97 | 0.65 |
| literal: one of four words | 661 | 6154.67 ± 0.5% | 1019.70 ± 0.1% | 14.55 ± 0.1% | 3945.29 ± 0.1% | 21.90 ± 0.1% | 5.23 ± 0.3% | 6.93 ± 0.4% | 6145.40 ± 0.5% | 6.04 | 1.00 | 1.56 | 280.97 |
| literal: a word in any case | 217 | 12429.74 ± 0.6% | 1040.67 ± 0.3% | 21.66 ± 2.4% | 3973.25 ± 0.1% | 38.04 ± 0.4% | refused | differs | 12462.12 ± 0.5% | 11.94 | 1.00 | 3.13 | 326.76 |
| literal: an href attribute | 33 | 13601.60 ± 1.2% | 1045.91 ± 0.4% | 27.14 ± 0.1% | 16744.41 ± 3.0% | 2261.76 ± 0.4% | 13.28 ± 0.1% | 75.87 ± 0.5% | 13682.82 ± 0.7% | 13.00 | 0.99 | 0.81 | 6.01 |
| literal: a word, second text | 123 | 16428.82 ± 1.7% | 1046.40 ± 0.2% | 27.92 ± 0.2% | 18312.01 ± 1.6% | 7764.64 ± 5.2% | 19.73 ± 0.5% | 70.96 ± 0.8% | 16490.46 ± 0.9% | 15.70 | 1.00 | 0.90 | 2.12 |
| class: two capitalized words | 1331 | 1103.89 ± 0.4% | 958.12 ± 0.2% | 25.84 ± 0.2% | 585.08 ± 0.0% | 40.72 ± 7.9% | 14.66 ± 0.3% | 68.94 ± 0.3% | 1099.08 ± 0.3% | 1.15 | 1.00 | 1.89 | 27.11 |
| class: a word that ends in ing | 3399 | 880.14 ± 0.2% | 881.20 ± 0.4% | 17.93 ± 0.1% | 547.15 ± 0.1% | 29.65 ± 2.9% | 8.15 ± 0.1% | 18.44 ± 0.5% | 879.68 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.68 |
| class: a word in capitals | 2332 | 1469.05 ± 0.7% | 946.00 ± 0.1% | 27.42 ± 0.1% | 572.49 ± 0.1% | 43.49 ± 14.1% | 17.08 ± 0.3% | 83.13 ± 0.1% | 1469.11 ± 0.3% | 1.55 | 1.00 | 2.57 | 33.78 |
| class: a number | 8288 | 2059.71 ± 0.1% | 792.43 ± 0.1% | 27.77 ± 0.3% | 1725.97 ± 0.1% | 38.65 ± 15.6% | 0.55 ± 0.0% | 56.55 ± 0.2% | 2052.77 ± 0.1% | 2.60 | 1.00 | 1.19 | 53.29 |
| class: two capitalized words, second text | 5359 | 688.74 ± 0.2% | 687.92 ± 0.1% | 23.13 ± 0.1% | 485.26 ± 0.1% | 35.32 ± 15.3% | 16.63 ± 0.9% | 64.02 ± 0.4% | 688.78 ± 0.2% | 1.00 | 1.00 | 1.42 | 19.50 |
| other: a word between two words | 6104 | 776.10 ± 0.2% | 742.83 ± 0.4% | 23.35 ± 0.0% | 736.20 ± 0.5% | 107.83 ± 14.9% | 11.26 ± 0.1% | 70.01 ± 0.1% | 776.62 ± 0.1% | 1.04 | 1.00 | 1.05 | 7.20 |
| other: a number before a unit, second text | 1481 | 5451.07 ± 0.4% | 978.12 ± 0.2% | 25.73 ± 0.1% | 5641.45 ± 0.2% | 40.74 ± 0.1% | 17.85 ± 0.2% | 66.91 ± 0.3% | 5458.21 ± 0.6% | 5.57 | 1.00 | 0.97 | 133.81 |
| other: a heading's start tag | 110 | 12605.14 ± 1.0% | 1030.66 ± 0.9% | 27.21 ± 0.1% | 1704.62 ± 0.2% | 1581.12 ± 3.6% | 16.08 ± 0.3% | 88.95 ± 0.2% | 12641.21 ± 1.2% | 12.23 | 1.00 | 7.39 | 7.97 |
| other: a whole word | 217 | 13880.91 ± 1.2% | 1040.27 ± 0.1% | 29.45 ± 0.6% | 14370.36 ± 1.1% | 49.30 ± 0.4% | 13.40 ± 0.0% | 56.21 ± 0.2% | 13924.92 ± 1.1% | 13.34 | 1.00 | 0.97 | 281.54 |
| other: a line's first word, second text | 3716 | 1952.55 ± 0.6% | 855.24 ± 0.1% | 31.12 ± 0.2% | 1717.50 ± 0.4% | 62.47 ± 8.8% | refused | refused | 1940.18 ± 0.6% | 2.28 | 1.01 | 1.14 | 31.26 |
| other: fourteen octets before an x | 87 | 19328.72 ± 1.6% | 245.30 ± 0.5% | 5.30 ± 0.2% | 3915.52 ± 0.6% | 10.63 ± 0.1% | differs | 17.78 ± 0.2% | 19373.35 ± 1.3% | 78.79 | 1.00 | 4.94 | 1817.52 |
| other: a Greek word | 21815 | 470.76 ± 0.5% | 316.20 ± 0.4% | 30.67 ± 0.5% | 289.19 ± 0.2% | 47.79 ± 7.2% | differs | refused | 470.26 ± 0.5% | 1.49 | 1.00 | 1.63 | 9.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.97 ± 0.1% | 26.00 ± 0.1% | 0.82 ± 0.2% | 19.74 ± 0.4% | 2.78 ± 0.2% | differs | 3.99 ± 0.5% | 25.99 ± 0.1% | 1.00 | 1.00 | 1.32 | 9.34 |
| a UUID | 32895 | 21.21 ± 0.2% | 21.31 ± 0.1% | 0.64 ± 0.1% | 15.17 ± 1.0% | 3.12 ± 0.1% | 0.71 ± 0.2% | 3.59 ± 0.5% | 21.36 ± 0.2% | 1.00 | 0.99 | 1.40 | 6.80 |
| an IPv4 address | 33176 | 36.75 ± 0.2% | 36.68 ± 0.2% | 2.09 ± 0.2% | 29.01 ± 0.2% | 6.67 ± 0.1% | differs | 4.11 ± 0.1% | 36.78 ± 0.1% | 1.00 | 1.00 | 1.27 | 5.51 |
| a date and time | 32954 | 31.03 ± 0.4% | 31.15 ± 0.7% | 1.45 ± 0.2% | 21.13 ± 0.4% | 7.04 ± 0.2% | 1.20 ± 0.3% | 7.11 ± 0.1% | 31.04 ± 0.4% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.48 ± 0.2% | 29.41 ± 0.2% | 0.97 ± 0.1% | 22.93 ± 0.2% | 3.49 ± 0.6% | differs | 2.96 ± 0.2% | 29.48 ± 0.2% | 1.00 | 1.00 | 1.29 | 8.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.89 ± 0.7% | 8.93 ± 0.2% | 8.90 ± 0.2% | 9.89 ± 0.2% | 4.95 ± 1.4% | 0.91 ± 0.2% | none | 8.96 ± 0.2% | 1.00 | 0.99 | 0.90 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.08 ± 0.2% | 221.58 ± 0.2% | 258.88 ± 0.2% | 86.60 ± 0.1% | 219.78 ± 1.7% | 485.61 ± 0.4% | 3878.31 ± 1.0% | 220.96 ± 0.3% | 1.00 | 1.00 | 2.55 | 1.01 |
| a UUID | 62 | 145.74 ± 0.5% | 145.90 ± 0.2% | 161.40 ± 0.4% | 45.63 ± 0.4% | 97.92 ± 0.6% | 183.87 ± 1.0% | 4260.09 ± 0.8% | 145.66 ± 0.2% | 1.00 | 1.00 | 3.19 | 1.49 |
| an IPv4 address | 29 | 440.35 ± 0.6% | 443.90 ± 0.3% | 617.27 ± 0.1% | 76.35 ± 1.0% | 129.59 ± 0.6% | 294.38 ± 0.6% | 7585.28 ± 0.2% | 440.06 ± 0.2% | 0.99 | 1.00 | 5.77 | 3.40 |
| a date and time | 56 | 319.24 ± 0.5% | 319.47 ± 0.4% | 400.73 ± 0.4% | 72.01 ± 0.3% | 134.76 ± 15.9% | 320.47 ± 0.7% | 4893.23 ± 0.6% | 318.83 ± 0.3% | 1.00 | 1.00 | 4.43 | 2.37 |
| a field path | 39 | 209.12 ± 0.4% | 209.34 ± 0.3% | 241.46 ± 0.3% | 79.36 ± 0.4% | 202.28 ± 1.6% | 484.80 ± 0.6% | 4957.85 ± 1.5% | 209.06 ± 0.3% | 1.00 | 1.00 | 2.64 | 1.03 |
| literal: a word | 7 | 667.77 ± 0.3% | 719.60 ± 0.2% | 1289.10 ± 0.2% | 505.35 ± 2.1% | 626.63 ± 2.0% | 925.30 ± 0.6% | 30871.02 ± 0.3% | 665.96 ± 0.6% | 0.93 | 1.00 | 1.32 | 1.07 |
| literal: a word that is not there | 8 | 638.27 ± 0.5% | 694.69 ± 0.5% | 1212.46 ± 0.7% | 461.58 ± 0.2% | 598.54 ± 1.8% | 878.64 ± 0.6% | 29585.91 ± 0.2% | 638.52 ± 0.3% | 0.92 | 1.00 | 1.38 | 1.07 |
| literal: one of four words | 26 | 254.24 ± 0.2% | 417.66 ± 0.3% | 565.12 ± 0.3% | 49.37 ± 0.1% | 241.95 ± 1.8% | 354.19 ± 0.4% | 15865.09 ± 0.3% | 254.08 ± 0.2% | 0.61 | 1.00 | 5.15 | 1.05 |
| literal: a word in any case | 11 | 522.58 ± 0.4% | 562.00 ± 0.4% | 871.85 ± 0.3% | 15.77 ± 1.0% | 648.06 ± 1.6% | refused | 23855.33 ± 0.5% | 522.56 ± 0.2% | 0.93 | 1.00 | 33.13 | 0.81 |
| literal: an href attribute | 12 | 351.68 ± 0.4% | 362.52 ± 0.6% | 473.83 ± 0.8% | 11.94 ± 62.2% | 495.82 ± 0.5% | 758.19 ± 2.2% | 22306.32 ± 0.3% | 352.45 ± 0.5% | 0.97 | 1.00 | 29.46 | 0.71 |
| literal: a word, second text | 10 | 578.54 ± 0.7% | 635.47 ± 0.8% | 1044.73 ± 1.2% | 412.58 ± 0.2% | 532.00 ± 1.5% | 785.41 ± 0.5% | 27806.11 ± 0.1% | 578.60 ± 0.4% | 0.91 | 1.00 | 1.40 | 1.09 |
| class: two capitalized words | 23 | 462.32 ± 0.8% | 491.91 ± 0.6% | 714.26 ± 1.0% | 101.26 ± 0.1% | 498.61 ± 1.3% | 744.21 ± 0.6% | 6627.73 ± 0.9% | 462.61 ± 0.2% | 0.94 | 1.00 | 4.57 | 0.93 |
| class: a word that ends in ing | 9 | 601.29 ± 0.3% | 669.14 ± 0.4% | 1179.04 ± 0.4% | 131.89 ± 1.0% | 750.78 ± 0.6% | 1094.27 ± 1.8% | 16321.01 ± 0.2% | 600.82 ± 0.2% | 0.90 | 1.00 | 4.56 | 0.80 |
| class: a word in capitals | 16 | 527.22 ± 0.4% | 566.21 ± 1.1% | 917.27 ± 1.1% | 133.83 ± 1.6% | 752.71 ± 0.7% | 1002.09 ± 1.8% | 8727.86 ± 0.2% | 528.24 ± 0.2% | 0.93 | 1.00 | 3.94 | 0.70 |
| class: a number | 6 | 665.36 ± 0.2% | 728.59 ± 0.4% | 1374.02 ± 0.1% | 41.75 ± 0.5% | 1394.05 ± 1.4% | 1896.94 ± 1.1% | 23323.79 ± 0.4% | 666.01 ± 0.4% | 0.91 | 1.00 | 15.94 | 0.48 |
| class: two capitalized words, second text | 23 | 461.15 ± 1.3% | 492.19 ± 1.1% | 711.90 ± 1.6% | 100.37 ± 0.4% | 499.78 ± 1.1% | 734.53 ± 2.0% | 6624.35 ± 1.5% | 461.12 ± 0.4% | 0.94 | 1.00 | 4.59 | 0.92 |
| other: a word between two words | 13 | 578.54 ± 0.6% | 599.09 ± 0.5% | 957.61 ± 0.3% | 134.02 ± 0.6% | 500.59 ± 1.2% | 795.23 ± 1.4% | 15040.94 ± 0.2% | 578.02 ± 0.4% | 0.97 | 1.00 | 4.32 | 1.16 |
| other: a number before a unit, second text | 15 | 405.50 ± 0.3% | 440.78 ± 0.3% | 609.53 ± 0.2% | 39.34 ± 0.4% | 634.05 ± 0.8% | 871.12 ± 0.2% | 15423.51 ± 0.8% | 404.62 ± 0.4% | 0.92 | 1.00 | 10.31 | 0.64 |
| other: a heading's start tag | 13 | 363.12 ± 0.7% | 367.28 ± 0.8% | 480.45 ± 0.7% | 10.43 ± 32.1% | 628.12 ± 1.3% | 854.20 ± 0.2% | 18616.60 ± 0.2% | 362.98 ± 0.3% | 0.99 | 1.00 | 34.82 | 0.58 |
| other: a whole word | 11 | 614.64 ± 0.2% | 652.95 ± 0.5% | 1092.27 ± 0.5% | 119.84 ± 0.6% | 564.74 ± 1.8% | 820.58 ± 1.3% | 27249.66 ± 0.4% | 614.26 ± 0.2% | 0.94 | 1.00 | 5.13 | 1.09 |
| other: a line's first word, second text | 17 | 561.92 ± 0.3% | 581.92 ± 0.2% | 938.06 ± 0.2% | 128.29 ± 0.1% | 702.34 ± 1.8% | refused | refused | 559.70 ± 0.6% | 0.97 | 1.00 | 4.38 | 0.80 |
| other: fourteen octets before an x | 16 | 112.89 ± 0.6% | 162.89 ± 0.8% | 186.20 ± 0.7% | 7.19 ± 26.4% | 452.03 ± 2.3% | 420.92 ± 0.2% | 12793.43 ± 0.4% | 112.83 ± 0.5% | 0.69 | 1.00 | 15.70 | 0.25 |
| other: a Greek word | 8 | 448.76 ± 0.7% | 595.07 ± 0.5% | 969.68 ± 0.8% | 11.00 ± 39.7% | 1378.22 ± 2.1% | 1749.77 ± 0.2% | refused | 449.26 ± 0.4% | 0.75 | 1.00 | 40.80 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12720.52 ± 1.3% | not timed | not timed | 15845.29 ± 0.8% | 1944.53 ± 13.0% | not timed | not timed | 12682.19 ± 0.7% | | 1.00 | 0.80 | 6.54 |
| 01-literal/sherlock-casei-en | 522 | 3939.82 ± 0.5% | not timed | not timed | 3588.96 ± 0.3% | 32.49 ± 1.9% | not timed | not timed | 3936.84 ± 0.4% | | 1.00 | 1.10 | 121.27 |
| 01-literal/sherlock-ru | 724 | 13589.75 ± 0.6% | not timed | not timed | 17216.97 ± 0.3% | 1518.00 ± 9.4% | not timed | not timed | 13563.87 ± 0.9% | | 1.00 | 0.79 | 8.95 |
| 01-literal/sherlock-casei-ru | 746 | 5385.20 ± 0.8% | not timed | not timed | 3325.36 ± 1.0% | 30.72 ± 0.7% | not timed | not timed | 5393.90 ± 0.7% | | 1.00 | 1.62 | 175.32 |
| 01-literal/sherlock-zh | 30 | 16704.40 ± 0.7% | not timed | not timed | 18037.22 ± 1.3% | 2786.09 ± 9.2% | not timed | not timed | 16683.03 ± 0.5% | | 1.00 | 0.93 | 6.00 |
| 02-literal-alternate/sherlock-en | 714 | 5898.34 ± 0.4% | not timed | not timed | 3936.18 ± 0.1% | 16.68 ± 0.1% | not timed | not timed | 5902.70 ± 0.2% | | 1.00 | 1.50 | 353.66 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1701.69 ± 0.7% | not timed | not timed | 697.37 ± 0.2% | 11.05 ± 0.3% | not timed | not timed | 1695.83 ± 0.6% | | 1.00 | 2.44 | 154.01 |
| 02-literal-alternate/sherlock-ru | 899 | 4799.30 ± 0.2% | not timed | not timed | 3254.82 ± 0.3% | 22.67 ± 0.2% | not timed | not timed | 4799.15 ± 0.3% | | 1.00 | 1.47 | 211.73 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1818.39 ± 0.6% | not timed | not timed | 1235.09 ± 0.2% | 9.10 ± 0.3% | not timed | not timed | 1815.62 ± 0.3% | | 1.00 | 1.47 | 199.78 |
| 02-literal-alternate/sherlock-zh | 207 | 7072.26 ± 0.9% | not timed | not timed | 4146.63 ± 0.7% | 31.55 ± 0.1% | not timed | not timed | 7066.84 ± 0.4% | | 1.00 | 1.71 | 224.15 |
| 03-date/ascii | 111817 | 124.30 ± 0.6% | not timed | not timed | 96.40 ± 0.1% | 0.20 ± 1.6% | not timed | not timed | 123.76 ± 0.2% | | 1.00 | 1.29 | 614.80 |
| 04-ruff-noqa/real | 84 | 550.65 ± 0.1% | not timed | not timed | 462.22 ± 0.1% | 19.63 ± 0.2% | not timed | not timed | 551.91 ± 0.1% | | 1.00 | 1.19 | 28.04 |
| 04-ruff-noqa/tweaked | 44 | 554.31 ± 0.1% | not timed | not timed | 459.20 ± 0.1% | 365.74 ± 0.4% | not timed | not timed | 553.42 ± 0.4% | | 1.00 | 1.21 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.72 ± 0.7% | not timed | not timed | 5.10 ± 0.1% | 0.20 ± 6.6% | not timed | not timed | 3.72 ± 1.6% | | 1.00 | 0.73 | 18.57 |
| 06-cloud-flare-redos/original | 107 | 183.14 ± 0.5% | not timed | not timed | 216.54 ± 0.2% | 24.89 ± 0.5% | not timed | not timed | 183.04 ± 0.4% | | 1.00 | 0.85 | 7.36 |
| 06-cloud-flare-redos/simplified-short | 102 | 147.14 ± 0.0% | not timed | not timed | 227.88 ± 0.3% | 26.69 ± 0.2% | not timed | not timed | 146.90 ± 0.1% | | 1.00 | 0.65 | 5.51 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.86 ± 2.0% | not timed | not timed | 255.95 ± 0.3% | 28.81 ± 0.1% | not timed | not timed | 156.90 ± 2.1% | | 1.00 | 0.61 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 40.03 ± 0.1% | not timed | not timed | 171.58 ± 0.3% | 42.12 ± 6.9% | not timed | not timed | 39.95 ± 0.7% | | 1.00 | 0.23 | 0.95 |
| 08-words/all-english | 56691 | 103.31 ± 0.3% | not timed | not timed | 82.99 ± 0.2% | 12.53 ± 14.9% | not timed | not timed | 103.08 ± 0.3% | | 1.00 | 1.24 | 8.24 |
| 08-words/long-english | 839 | 996.58 ± 0.2% | not timed | not timed | 596.28 ± 0.1% | 32.66 ± 0.4% | not timed | not timed | 997.14 ± 0.2% | | 1.00 | 1.67 | 30.52 |
| 09-aws-keys/full | 0 | 420.36 ± 0.1% | not timed | not timed | 460.27 ± 0.4% | 64.49 ± 0.1% | not timed | not timed | 420.82 ± 0.1% | | 1.00 | 0.91 | 6.52 |
| 09-aws-keys/quick | 0 | 396.89 ± 0.1% | not timed | not timed | 989.59 ± 0.3% | 419.99 ± 1.1% | not timed | not timed | 400.28 ± 0.0% | | 0.99 | 0.40 | 0.94 |
| 10-bounded-repeat/letters-en | 1833 | 591.13 ± 0.2% | not timed | not timed | 516.68 ± 0.4% | 19.55 ± 0.8% | not timed | not timed | 591.62 ± 0.1% | | 1.00 | 1.14 | 30.23 |
| 10-bounded-repeat/letters-ru | 3475 | 404.30 ± 0.2% | not timed | not timed | 479.36 ± 0.1% | 22.40 ± 9.8% | not timed | not timed | 402.07 ± 0.6% | | 1.01 | 0.84 | 18.05 |
| 10-bounded-repeat/context | 53 | 73.46 ± 1.3% | not timed | not timed | 65.22 ± 0.5% | 19.68 ± 0.2% | not timed | not timed | 73.21 ± 1.1% | | 1.00 | 1.13 | 3.73 |
| 10-bounded-repeat/capitals | 11 | 1039.03 ± 0.2% | not timed | not timed | 615.70 ± 0.1% | 36.65 ± 0.1% | not timed | not timed | 1038.81 ± 0.1% | | 1.00 | 1.69 | 28.35 |
| 11-unstructured-to-json/extract | 600 | 24.55 ± 0.1% | not timed | not timed | 77.73 ± 0.4% | 48.94 ± 0.4% | not timed | not timed | 24.24 ± 0.7% | | 1.01 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 604.51 ± 0.7% | not timed | not timed | 561.15 ± 0.0% | 0.40 ± 0.1% | not timed | not timed | 602.79 ± 0.2% | | 1.00 | 1.08 | 1495.30 |
| 14-quadratic/1x | 100 | 12.61 ± 0.7% | not timed | not timed | 10.01 ± 0.2% | 0.96 ± 2.9% | not timed | not timed | 12.54 ± 1.5% | | 1.01 | 1.26 | 13.17 |
| 14-quadratic/2x | 200 | 7.79 ± 0.4% | not timed | not timed | 5.55 ± 0.1% | 0.52 ± 1.1% | not timed | not timed | 7.74 ± 0.6% | | 1.01 | 1.41 | 14.95 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.2% | not timed | not timed | 1.83 ± 0.3% | | 1.00 | 1.51 | 15.89 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 0.2% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 5.1% | not timed | not timed | 1.51 ± 0.7% | | 1.01 | 4.48 | 2.79 |
| 04-ruff-noqa/compile-real | 1 | 87.05 ± 0.1% | not timed | not timed | 13.74 ± 0.3% | 137.59 ± 2.4% | not timed | not timed | 86.51 ± 0.9% | | 1.01 | 6.34 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 14.36 ± 0.2% | not timed | not timed | 2.52 ± 0.5% | 6.40 ± 1.7% | not timed | not timed | 14.31 ± 1.0% | | 1.00 | 5.71 | 2.24 |
| 07-unicode-character-data/compile | 1 | 55.49 ± 0.1% | not timed | not timed | 25.66 ± 0.4% | 35.42 ± 3.8% | not timed | not timed | 55.27 ± 1.1% | | 1.00 | 2.16 | 1.57 |
| 09-aws-keys/compile-full | 1 | 42.42 ± 0.2% | not timed | not timed | 8.25 ± 0.5% | 23.08 ± 2.0% | not timed | not timed | 42.19 ± 1.0% | | 1.01 | 5.14 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 190.38 ± 0.1% | not timed | not timed | 46.35 ± 0.1% | 132.82 ± 1.3% | not timed | not timed | 189.50 ± 1.1% | | 1.00 | 4.11 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.54 ± 2.4% | not timed | not timed | 11.08 ± 0.2% | 15.74 ± 3.1% | not timed | not timed | 14.56 ± 1.4% | | 1.00 | 1.31 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.02 ± 2.3% | not timed | not timed | 8.03 ± 0.2% | 23.50 ± 1.0% | not timed | not timed | 84.49 ± 0.3% | | 1.01 | 10.59 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 87.16 ± 0.2% | not timed | not timed | 41.00 ± 0.6% | 67.31 ± 2.7% | not timed | not timed | 86.50 ± 0.9% | | 1.01 | 2.13 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 39.3% | 0.10 ± 17.1% | not timed | not timed | 0.35 ± 1.3% | | 1.00 | 5.15 | 3.64 |

