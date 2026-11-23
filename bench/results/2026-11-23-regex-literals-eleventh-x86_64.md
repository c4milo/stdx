# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243514938 |
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
| literal: a word | 217 | 26906.41 ± 1.5% | 3291.34 ± 0.6% | 28.59 ± 1.4% | 24651.87 ± 2.6% | 9297.17 ± 12.4% | 12.08 ± 9.3% | 87.70 ± 2.1% | 26886.42 ± 19.7% | 8.17 | 1.00 | 1.09 | 2.89 |
| literal: a word that is not there | 0 | 30924.80 ± 0.4% | 3235.68 ± 0.4% | 28.73 ± 2.3% | 27178.91 ± 4.1% | 30385.16 ± 1.2% | 11.74 ± 0.6% | 76.43 ± 2.1% | 30892.35 ± 1.7% | 9.56 | 1.00 | 1.14 | 1.02 |
| literal: one of four words | 661 | 10750.07 ± 2.9% | 1544.87 ± 1.1% | 15.11 ± 1.0% | 7814.50 ± 1.5% | 23.34 ± 1.0% | 3.53 ± 4.3% | 6.49 ± 8.5% | 10614.00 ± 3.3% | 6.96 | 1.01 | 1.38 | 460.52 |
| literal: a word in any case | 217 | 23531.29 ± 1.4% | 1644.40 ± 1.2% | 19.95 ± 1.0% | 8011.60 ± 0.4% | 44.33 ± 2.3% | refused | differs | 23399.86 ± 0.5% | 14.31 | 1.01 | 2.94 | 530.78 |
| literal: an href attribute | 33 | 23361.68 ± 1.4% | 515.86 ± 3.3% | 25.36 ± 8.5% | 22350.97 ± 1.0% | 2068.13 ± 1.4% | 8.61 ± 0.5% | 79.48 ± 0.5% | 23316.50 ± 0.7% | 45.29 | 1.00 | 1.05 | 11.30 |
| literal: a word, second text | 123 | 27522.20 ± 0.3% | 2471.13 ± 0.4% | 27.79 ± 0.4% | 24208.60 ± 0.7% | 7119.18 ± 6.5% | 15.61 ± 1.6% | 77.31 ± 1.3% | 27470.43 ± 2.6% | 11.14 | 1.00 | 1.14 | 3.87 |
| class: two capitalized words | 1331 | 779.42 ± 0.3% | 506.20 ± 0.1% | 26.30 ± 1.3% | 488.94 ± 1.0% | 39.00 ± 6.2% | 10.25 ± 0.4% | 64.23 ± 0.4% | 778.27 ± 1.0% | 1.54 | 1.00 | 1.59 | 19.99 |
| class: a word that ends in ing | 3399 | 481.24 ± 1.0% | 478.57 ± 0.6% | 16.53 ± 0.1% | 459.81 ± 0.7% | 28.15 ± 1.2% | 5.72 ± 1.4% | 16.97 ± 3.4% | 477.53 ± 8.3% | 1.01 | 1.01 | 1.05 | 17.10 |
| class: a word in capitals | 2332 | 1065.62 ± 5.8% | 509.45 ± 4.0% | 27.74 ± 8.0% | 481.61 ± 0.9% | 41.92 ± 5.4% | 12.21 ± 1.1% | 82.87 ± 1.3% | 1061.90 ± 2.3% | 2.09 | 1.00 | 2.21 | 25.42 |
| class: a number | 8288 | 1618.83 ± 0.8% | 674.52 ± 4.0% | 27.28 ± 2.6% | 1677.22 ± 0.8% | 41.52 ± 7.0% | 0.34 ± 0.4% | 56.70 ± 0.6% | 1615.07 ± 2.1% | 2.40 | 1.00 | 0.97 | 38.99 |
| class: two capitalized words, second text | 5359 | 426.62 ± 0.2% | 432.47 ± 0.3% | 23.01 ± 2.1% | 405.94 ± 0.3% | 32.79 ± 6.4% | 13.28 ± 0.6% | 58.18 ± 2.8% | 425.99 ± 0.2% | 0.99 | 1.00 | 1.05 | 13.01 |
| other: a word between two words | 6104 | 695.45 ± 1.4% | 485.20 ± 2.1% | 22.72 ± 5.6% | 691.46 ± 0.8% | 107.58 ± 7.7% | 7.82 ± 1.2% | 67.65 ± 2.5% | 688.94 ± 8.5% | 1.43 | 1.01 | 1.01 | 6.46 |
| other: a number before a unit, second text | 1481 | 6923.22 ± 6.4% | 912.80 ± 8.1% | 26.20 ± 2.4% | 7254.44 ± 1.1% | 39.44 ± 3.9% | 13.94 ± 2.0% | 62.24 ± 1.2% | 6796.45 ± 4.7% | 7.58 | 1.02 | 0.95 | 175.53 |
| other: a heading's start tag | 110 | 16779.99 ± 1.2% | 620.62 ± 0.3% | 27.75 ± 1.4% | 2105.50 ± 0.9% | 1542.22 ± 4.5% | 10.72 ± 0.5% | 90.29 ± 0.8% | 16788.12 ± 2.1% | 27.04 | 1.00 | 7.97 | 10.88 |
| other: a whole word | 217 | 19999.25 ± 0.5% | 509.91 ± 0.1% | 28.57 ± 2.3% | 19911.19 ± 2.0% | 45.39 ± 3.6% | 10.22 ± 10.0% | 52.71 ± 3.2% | 19962.66 ± 0.1% | 39.22 | 1.00 | 1.00 | 440.62 |
| other: a line's first word, second text | 3716 | 2000.72 ± 2.8% | 489.35 ± 1.3% | 28.93 ± 2.1% | 1942.07 ± 0.6% | 63.60 ± 15.4% | refused | refused | 2001.65 ± 0.8% | 4.09 | 1.00 | 1.03 | 31.46 |
| other: fourteen octets before an x | 87 | 29410.08 ± 3.0% | 250.56 ± 0.9% | 6.03 ± 1.2% | 3389.20 ± 0.6% | 9.12 ± 0.9% | differs | 15.18 ± 2.6% | 28794.26 ± 3.2% | 117.38 | 1.02 | 8.68 | 3226.26 |
| other: a Greek word | 21815 | 424.81 ± 0.8% | 326.15 ± 0.2% | 30.05 ± 3.0% | 249.73 ± 0.7% | 47.99 ± 9.5% | differs | refused | 423.19 ± 0.9% | 1.30 | 1.00 | 1.70 | 8.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 17.59 ± 0.9% | 17.58 ± 0.3% | 0.84 ± 3.1% | 16.97 ± 0.2% | 2.53 ± 0.6% | differs | 3.78 ± 1.0% | 17.59 ± 3.1% | 1.00 | 1.00 | 1.04 | 6.97 |
| a UUID | 32895 | 19.35 ± 0.6% | 19.39 ± 1.8% | 0.58 ± 1.7% | 13.14 ± 0.3% | 2.55 ± 0.5% | 0.57 ± 0.2% | 3.00 ± 1.8% | 19.39 ± 0.4% | 1.00 | 1.00 | 1.47 | 7.59 |
| an IPv4 address | 33176 | 28.31 ± 0.9% | 28.24 ± 2.7% | 1.86 ± 0.9% | 24.95 ± 0.5% | 6.04 ± 2.5% | differs | 3.59 ± 10.2% | 28.20 ± 0.6% | 1.00 | 1.00 | 1.13 | 4.69 |
| a date and time | 32954 | 27.31 ± 2.6% | 27.32 ± 0.5% | 1.32 ± 0.9% | 18.97 ± 0.7% | 7.82 ± 3.9% | 1.05 ± 5.1% | 6.78 ± 5.7% | 27.32 ± 6.3% | 1.00 | 1.00 | 1.44 | 3.49 |
| a field path | 32606 | 19.59 ± 2.1% | 19.56 ± 0.4% | 0.97 ± 1.8% | 19.52 ± 0.2% | 2.82 ± 0.4% | differs | 2.36 ± 2.5% | 19.56 ± 12.8% | 1.00 | 1.00 | 1.00 | 6.94 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.62 ± 1.6% | 9.62 ± 0.8% | 9.62 ± 3.8% | 11.93 ± 3.7% | 5.13 ± 1.8% | 0.84 ± 3.7% | none | 9.61 ± 0.8% | 1.00 | 1.00 | 0.81 | 1.88 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.39 ± 0.8% | 239.12 ± 0.4% | 279.35 ± 0.6% | 87.88 ± 3.1% | 201.00 ± 0.5% | 567.01 ± 2.1% | 3062.66 ± 1.0% | 238.11 ± 0.6% | 1.00 | 1.00 | 2.71 | 1.19 |
| a UUID | 62 | 153.53 ± 1.0% | 154.45 ± 0.3% | 169.41 ± 0.7% | 47.45 ± 0.7% | 91.22 ± 10.8% | 199.19 ± 1.6% | 3434.89 ± 1.7% | 153.81 ± 0.4% | 0.99 | 1.00 | 3.24 | 1.68 |
| an IPv4 address | 29 | 486.43 ± 0.9% | 493.04 ± 0.6% | 677.53 ± 7.4% | 77.65 ± 1.4% | 122.72 ± 1.1% | 340.11 ± 1.1% | 6154.39 ± 0.5% | 487.55 ± 0.8% | 0.99 | 1.00 | 6.26 | 3.96 |
| a date and time | 56 | 354.91 ± 1.9% | 357.53 ± 0.2% | 442.24 ± 0.1% | 73.53 ± 0.7% | 128.93 ± 4.2% | 360.12 ± 2.0% | 3703.89 ± 0.9% | 355.25 ± 2.0% | 0.99 | 1.00 | 4.83 | 2.75 |
| a field path | 39 | 235.34 ± 3.8% | 237.05 ± 4.3% | 274.53 ± 0.4% | 80.44 ± 1.2% | 189.96 ± 4.4% | 572.24 ± 0.2% | 3830.48 ± 8.1% | 235.86 ± 13.4% | 0.99 | 1.00 | 2.93 | 1.24 |
| literal: a word | 7 | 696.33 ± 0.9% | 757.18 ± 0.5% | 1324.49 ± 4.6% | 535.57 ± 0.3% | 607.85 ± 19.4% | 1135.72 ± 1.3% | 25045.62 ± 3.9% | 697.75 ± 3.6% | 0.92 | 1.00 | 1.30 | 1.15 |
| literal: a word that is not there | 8 | 658.59 ± 0.5% | 721.34 ± 2.8% | 1235.39 ± 4.3% | 494.73 ± 10.8% | 593.63 ± 18.0% | 1074.21 ± 1.5% | 23580.17 ± 2.7% | 659.65 ± 1.0% | 0.91 | 1.00 | 1.33 | 1.11 |
| literal: one of four words | 26 | 265.55 ± 1.1% | 432.29 ± 3.6% | 574.21 ± 4.5% | 39.56 ± 0.4% | 234.85 ± 7.1% | 411.20 ± 1.0% | 11581.36 ± 8.4% | 265.94 ± 2.2% | 0.61 | 1.00 | 6.71 | 1.13 |
| literal: a word in any case | 11 | 495.23 ± 10.4% | 532.48 ± 4.3% | 742.64 ± 2.5% | 13.21 ± 0.6% | 639.64 ± 14.5% | refused | 18989.82 ± 6.5% | 495.07 ± 14.6% | 0.93 | 1.00 | 37.49 | 0.77 |
| literal: an href attribute | 12 | 377.05 ± 4.2% | 390.19 ± 2.5% | 501.10 ± 5.6% | 38.79 ± 6.1% | 469.54 ± 18.1% | 935.81 ± 1.4% | 17065.73 ± 3.6% | 377.06 ± 4.0% | 0.97 | 1.00 | 9.72 | 0.80 |
| literal: a word, second text | 10 | 607.20 ± 0.5% | 669.52 ± 0.8% | 1107.98 ± 0.9% | 449.76 ± 1.3% | 511.22 ± 5.5% | 957.77 ± 0.7% | 21278.40 ± 0.8% | 610.51 ± 1.4% | 0.91 | 0.99 | 1.35 | 1.19 |
| class: two capitalized words | 23 | 534.17 ± 0.7% | 578.82 ± 1.2% | 821.76 ± 4.6% | 105.21 ± 18.7% | 483.53 ± 7.2% | 882.54 ± 0.9% | 5648.08 ± 3.3% | 533.94 ± 12.9% | 0.92 | 1.00 | 5.08 | 1.10 |
| class: a word that ends in ing | 9 | 652.87 ± 0.7% | 743.24 ± 4.7% | 1239.47 ± 2.2% | 137.19 ± 0.7% | 703.12 ± 2.0% | 1327.07 ± 6.9% | 13661.74 ± 8.8% | 653.25 ± 2.9% | 0.88 | 1.00 | 4.76 | 0.93 |
| class: a word in capitals | 16 | 600.79 ± 5.3% | 643.85 ± 0.4% | 1016.47 ± 1.3% | 142.90 ± 3.7% | 707.65 ± 13.0% | 1233.13 ± 5.9% | 7494.81 ± 3.5% | 600.51 ± 1.3% | 0.93 | 1.00 | 4.20 | 0.85 |
| class: a number | 6 | 754.33 ± 0.3% | 831.07 ± 0.8% | 1487.93 ± 3.6% | 34.53 ± 3.6% | 1271.14 ± 16.7% | 2314.94 ± 1.5% | 18106.39 ± 4.8% | 753.86 ± 15.7% | 0.91 | 1.00 | 21.85 | 0.59 |
| class: two capitalized words, second text | 23 | 532.69 ± 5.6% | 577.60 ± 1.1% | 829.81 ± 1.2% | 105.27 ± 1.4% | 483.07 ± 1.9% | 897.21 ± 5.4% | 5639.84 ± 3.8% | 532.76 ± 0.8% | 0.92 | 1.00 | 5.06 | 1.10 |
| other: a word between two words | 13 | 614.65 ± 0.6% | 648.60 ± 1.0% | 982.61 ± 2.8% | 139.68 ± 1.9% | 479.34 ± 2.1% | 982.84 ± 1.0% | 11956.05 ± 4.6% | 611.80 ± 13.3% | 0.95 | 1.00 | 4.40 | 1.28 |
| other: a number before a unit, second text | 15 | 448.11 ± 0.5% | 495.52 ± 1.6% | 671.86 ± 0.3% | 33.00 ± 5.3% | 592.58 ± 1.3% | 1061.76 ± 7.3% | 11811.75 ± 1.0% | 448.01 ± 1.7% | 0.90 | 1.00 | 13.58 | 0.76 |
| other: a heading's start tag | 13 | 394.07 ± 0.7% | 401.67 ± 1.1% | 516.64 ± 1.0% | 38.01 ± 0.4% | 580.17 ± 1.1% | 1043.28 ± 2.4% | 14674.66 ± 2.2% | 392.98 ± 1.0% | 0.98 | 1.00 | 10.37 | 0.68 |
| other: a whole word | 11 | 635.16 ± 5.4% | 683.16 ± 6.7% | 1109.67 ± 5.2% | 120.82 ± 6.3% | 543.91 ± 11.0% | 981.72 ± 1.6% | 20929.97 ± 2.1% | 633.42 ± 5.6% | 0.93 | 1.00 | 5.26 | 1.17 |
| other: a line's first word, second text | 17 | 618.14 ± 7.6% | 658.26 ± 0.6% | 1040.80 ± 0.2% | 137.08 ± 1.6% | 651.65 ± 3.2% | refused | refused | 617.17 ± 0.3% | 0.94 | 1.00 | 4.51 | 0.95 |
| other: fourteen octets before an x | 16 | 105.49 ± 0.6% | 149.10 ± 0.4% | 170.75 ± 0.6% | 14.72 ± 4.0% | 418.88 ± 9.9% | 474.02 ± 0.8% | 11188.96 ± 0.7% | 104.90 ± 0.8% | 0.71 | 1.01 | 7.17 | 0.25 |
| other: a Greek word | 8 | 491.32 ± 3.0% | 687.09 ± 0.9% | 1137.97 ± 0.2% | 48.30 ± 0.1% | 1286.72 ± 15.3% | 2255.37 ± 0.7% | refused | 494.35 ± 0.6% | 0.72 | 0.99 | 10.17 | 0.38 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22072.03 ± 0.4% | not timed | not timed | 21529.49 ± 0.3% | 1895.13 ± 20.5% | not timed | not timed | 22007.87 ± 0.8% | | 1.00 | 1.03 | 11.65 |
| 01-literal/sherlock-casei-en | 522 | 8310.63 ± 2.0% | not timed | not timed | 6731.99 ± 1.1% | 30.29 ± 2.8% | not timed | not timed | 8176.71 ± 2.7% | | 1.02 | 1.23 | 274.39 |
| 01-literal/sherlock-ru | 724 | 22103.68 ± 0.4% | not timed | not timed | 21523.13 ± 1.3% | 1144.77 ± 6.7% | not timed | not timed | 22016.20 ± 2.6% | | 1.00 | 1.03 | 19.31 |
| 01-literal/sherlock-casei-ru | 746 | 8950.01 ± 9.4% | not timed | not timed | 5244.84 ± 6.2% | 32.34 ± 5.2% | not timed | not timed | 9091.77 ± 19.1% | | 0.98 | 1.71 | 276.79 |
| 01-literal/sherlock-zh | 30 | 29156.28 ± 0.4% | not timed | not timed | 26025.69 ± 1.2% | 1269.65 ± 1.0% | not timed | not timed | 29146.80 ± 0.3% | | 1.00 | 1.12 | 22.96 |
| 02-literal-alternate/sherlock-en | 714 | 9764.74 ± 21.9% | not timed | not timed | 7410.86 ± 3.4% | 17.66 ± 4.4% | not timed | not timed | 9645.13 ± 11.1% | | 1.01 | 1.32 | 553.06 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1760.25 ± 1.8% | not timed | not timed | 1916.33 ± 1.5% | 10.46 ± 3.9% | not timed | not timed | 1761.73 ± 15.4% | | 1.00 | 0.92 | 168.36 |
| 02-literal-alternate/sherlock-ru | 899 | 7774.53 ± 7.3% | not timed | not timed | 4048.10 ± 3.2% | 22.95 ± 5.1% | not timed | not timed | 7799.63 ± 2.0% | | 1.00 | 1.92 | 338.79 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1889.59 ± 4.7% | not timed | not timed | 989.27 ± 3.1% | 8.68 ± 2.4% | not timed | not timed | 1886.12 ± 13.6% | | 1.00 | 1.91 | 217.81 |
| 02-literal-alternate/sherlock-zh | 207 | 13473.28 ± 0.8% | not timed | not timed | 8540.90 ± 2.9% | 32.93 ± 1.5% | not timed | not timed | 13427.54 ± 2.5% | | 1.00 | 1.58 | 409.17 |
| 03-date/ascii | 111817 | 99.43 ± 1.2% | not timed | not timed | 88.02 ± 2.4% | 0.20 ± 0.4% | not timed | not timed | 99.16 ± 1.4% | | 1.00 | 1.13 | 508.27 |
| 04-ruff-noqa/real | 84 | 439.66 ± 10.2% | not timed | not timed | 450.54 ± 0.9% | 19.80 ± 1.7% | not timed | not timed | 438.92 ± 3.4% | | 1.00 | 0.98 | 22.20 |
| 04-ruff-noqa/tweaked | 44 | 509.58 ± 0.6% | not timed | not timed | 451.22 ± 1.1% | 314.93 ± 2.6% | not timed | not timed | 509.61 ± 11.4% | | 1.00 | 1.13 | 1.62 |
| 05-lexer-veryl/single | 124800 | 4.46 ± 1.4% | not timed | not timed | 4.70 ± 1.6% | 0.21 ± 3.9% | not timed | not timed | 4.25 ± 2.5% | | 1.05 | 0.95 | 21.64 |
| 06-cloud-flare-redos/original | 107 | 373.97 ± 8.1% | not timed | not timed | 196.04 ± 4.1% | 24.71 ± 4.7% | not timed | not timed | 375.37 ± 3.6% | | 1.00 | 1.91 | 15.13 |
| 06-cloud-flare-redos/simplified-short | 102 | 367.94 ± 0.9% | not timed | not timed | 177.83 ± 1.8% | 26.41 ± 0.8% | not timed | not timed | 368.28 ± 0.2% | | 1.00 | 2.07 | 13.93 |
| 06-cloud-flare-redos/simplified-long | 10000 | 445.56 ± 0.9% | not timed | not timed | 214.11 ± 2.4% | 28.50 ± 1.0% | not timed | not timed | 444.21 ± 1.4% | | 1.00 | 2.08 | 15.63 |
| 07-unicode-character-data/parse-line | 558784 | 226.98 ± 2.2% | not timed | not timed | 167.38 ± 3.2% | 39.66 ± 4.2% | not timed | not timed | 224.86 ± 5.4% | | 1.01 | 1.36 | 5.72 |
| 08-words/all-english | 56691 | 88.45 ± 1.3% | not timed | not timed | 73.50 ± 0.9% | 10.46 ± 6.2% | not timed | not timed | 87.97 ± 0.9% | | 1.01 | 1.20 | 8.46 |
| 08-words/long-english | 839 | 515.16 ± 0.2% | not timed | not timed | 496.57 ± 0.1% | 29.46 ± 0.9% | not timed | not timed | 515.11 ± 0.6% | | 1.00 | 1.04 | 17.49 |
| 09-aws-keys/full | 0 | 450.35 ± 0.5% | not timed | not timed | 450.20 ± 0.3% | 58.34 ± 0.9% | not timed | not timed | 450.86 ± 0.4% | | 1.00 | 1.00 | 7.72 |
| 09-aws-keys/quick | 0 | 979.31 ± 3.1% | not timed | not timed | 750.76 ± 0.8% | 361.66 ± 16.9% | not timed | not timed | 979.65 ± 0.4% | | 1.00 | 1.30 | 2.71 |
| 10-bounded-repeat/letters-en | 1833 | 530.97 ± 3.4% | not timed | not timed | 453.09 ± 0.5% | 19.01 ± 0.7% | not timed | not timed | 519.08 ± 2.2% | | 1.02 | 1.17 | 27.94 |
| 10-bounded-repeat/letters-ru | 3475 | 442.20 ± 1.6% | not timed | not timed | 407.10 ± 0.8% | 20.71 ± 8.1% | not timed | not timed | 435.38 ± 1.3% | | 1.02 | 1.09 | 21.35 |
| 10-bounded-repeat/context | 53 | 70.88 ± 1.3% | not timed | not timed | 59.91 ± 1.2% | 19.22 ± 0.2% | not timed | not timed | 70.47 ± 0.7% | | 1.01 | 1.18 | 3.69 |
| 10-bounded-repeat/capitals | 11 | 535.27 ± 8.1% | not timed | not timed | 510.96 ± 0.3% | 35.40 ± 0.7% | not timed | not timed | 533.94 ± 8.3% | | 1.00 | 1.05 | 15.12 |
| 11-unstructured-to-json/extract | 600 | 64.61 ± 6.4% | not timed | not timed | 64.36 ± 2.4% | 49.46 ± 4.4% | not timed | not timed | 64.05 ± 12.4% | | 1.01 | 1.00 | 1.31 |
| 12-dictionary/single | 1 | 455.28 ± 0.2% | not timed | not timed | 436.68 ± 0.3% | 0.38 ± 0.3% | not timed | not timed | 454.83 ± 0.3% | | 1.00 | 1.04 | 1185.16 |
| 14-quadratic/1x | 100 | 22.95 ± 4.3% | not timed | not timed | 10.91 ± 1.3% | 0.98 ± 4.1% | not timed | not timed | 23.23 ± 2.4% | | 0.99 | 2.10 | 23.48 |
| 14-quadratic/2x | 200 | 17.99 ± 1.2% | not timed | not timed | 5.33 ± 0.7% | 0.52 ± 1.1% | not timed | not timed | 18.01 ± 0.6% | | 1.00 | 3.38 | 34.32 |
| 14-quadratic/10x | 1000 | 5.66 ± 2.3% | not timed | not timed | 1.03 ± 11.0% | 0.12 ± 2.4% | not timed | not timed | 5.66 ± 0.3% | | 1.00 | 5.49 | 47.77 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 1.0% | not timed | not timed | 0.34 ± 1.2% | 0.51 ± 4.4% | not timed | not timed | 1.34 ± 0.9% | | 1.00 | 3.92 | 2.62 |
| 04-ruff-noqa/compile-real | 1 | 105.84 ± 1.7% | not timed | not timed | 12.05 ± 1.9% | 134.34 ± 2.9% | not timed | not timed | 105.75 ± 4.1% | | 1.00 | 8.78 | 0.79 |
| 05-lexer-veryl/compile-single | 1 | 15.72 ± 0.7% | not timed | not timed | 2.30 ± 1.1% | 6.14 ± 2.5% | not timed | not timed | 15.56 ± 1.5% | | 1.01 | 6.84 | 2.56 |
| 07-unicode-character-data/compile | 1 | 59.94 ± 0.6% | not timed | not timed | 24.79 ± 1.3% | 33.69 ± 2.3% | not timed | not timed | 59.82 ± 1.2% | | 1.00 | 2.42 | 1.78 |
| 09-aws-keys/compile-full | 1 | 38.93 ± 2.0% | not timed | not timed | 6.95 ± 1.1% | 22.06 ± 2.4% | not timed | not timed | 38.74 ± 0.9% | | 1.01 | 5.60 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 186.59 ± 1.2% | not timed | not timed | 45.77 ± 0.3% | 127.30 ± 2.3% | not timed | not timed | 182.76 ± 0.8% | | 1.02 | 4.08 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 11.63 ± 0.7% | not timed | not timed | 10.98 ± 0.4% | 16.10 ± 2.3% | not timed | not timed | 11.62 ± 0.4% | | 1.00 | 1.06 | 0.72 |
| 10-bounded-repeat/compile-capitals | 1 | 69.18 ± 14.5% | not timed | not timed | 8.07 ± 14.6% | 23.48 ± 1.3% | not timed | not timed | 69.24 ± 5.8% | | 1.00 | 8.58 | 2.95 |
| 11-unstructured-to-json/compile | 1 | 90.22 ± 1.4% | not timed | not timed | 39.67 ± 6.3% | 64.35 ± 12.1% | not timed | not timed | 90.54 ± 1.3% | | 1.00 | 2.27 | 1.40 |
| 12-dictionary/compile-single | 1 | 0.29 ± 5.8% | not timed | not timed | 0.06 ± 3.5% | 0.09 ± 12.8% | not timed | not timed | 0.29 ± 1.9% | | 1.02 | 4.65 | 3.22 |

