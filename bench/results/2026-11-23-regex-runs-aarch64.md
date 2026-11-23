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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148042292 |
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
| literal: a word | 217 | 16019.95 ± 2.8% | 1040.00 ± 0.3% | 28.57 ± 0.3% | 17844.73 ± 2.3% | 9118.49 ± 7.4% | 17.54 ± 0.3% | 86.86 ± 0.2% | 15978.90 ± 2.1% | 15.40 | 1.00 | 0.90 | 1.76 |
| literal: a word that is not there | 0 | 18562.10 ± 1.7% | 1047.50 ± 0.2% | 28.60 ± 0.2% | 19728.50 ± 2.8% | 29060.31 ± 3.5% | 17.32 ± 0.2% | 82.66 ± 0.2% | 18714.55 ± 2.8% | 17.72 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6045.95 ± 0.6% | 1023.59 ± 0.1% | 14.67 ± 0.2% | 3945.80 ± 0.1% | 21.88 ± 0.1% | 5.29 ± 0.1% | 6.92 ± 0.3% | 6034.17 ± 0.3% | 5.91 | 1.00 | 1.53 | 276.27 |
| literal: a word in any case | 217 | 12570.77 ± 1.2% | 1040.76 ± 0.2% | 21.43 ± 1.9% | 3967.42 ± 0.1% | 37.98 ± 0.2% | refused | differs | 12567.20 ± 0.5% | 12.08 | 1.00 | 3.17 | 330.99 |
| literal: an href attribute | 33 | 13808.85 ± 1.3% | 1048.05 ± 0.1% | 27.36 ± 0.4% | 17151.13 ± 2.1% | 2268.12 ± 0.7% | 13.37 ± 0.2% | 75.72 ± 0.2% | 13796.06 ± 1.6% | 13.18 | 1.00 | 0.81 | 6.09 |
| literal: a word, second text | 123 | 16319.25 ± 1.6% | 1043.37 ± 0.3% | 28.27 ± 0.3% | 18005.18 ± 1.5% | 7708.69 ± 9.7% | 19.73 ± 0.8% | 69.71 ± 0.8% | 16386.47 ± 1.5% | 15.64 | 1.00 | 0.91 | 2.12 |
| class: two capitalized words | 1331 | 1090.24 ± 0.9% | 978.31 ± 0.1% | 26.17 ± 0.2% | 585.36 ± 0.3% | 40.50 ± 2.3% | 14.87 ± 0.3% | 68.77 ± 0.1% | 1105.38 ± 0.7% | 1.11 | 0.99 | 1.86 | 26.92 |
| class: a word that ends in ing | 3399 | 895.74 ± 0.3% | 895.48 ± 0.1% | 18.04 ± 0.3% | 548.15 ± 0.0% | 29.60 ± 3.9% | 8.21 ± 0.2% | 18.42 ± 0.7% | 894.21 ± 0.0% | 1.00 | 1.00 | 1.63 | 30.27 |
| class: a word in capitals | 2332 | 1450.17 ± 0.2% | 950.30 ± 0.2% | 27.92 ± 0.3% | 572.44 ± 0.1% | 43.41 ± 12.0% | 17.17 ± 0.4% | 83.35 ± 0.3% | 1448.28 ± 0.6% | 1.53 | 1.00 | 2.53 | 33.41 |
| class: a number | 8288 | 1978.30 ± 0.3% | 836.88 ± 0.1% | 28.07 ± 0.2% | 1724.37 ± 0.2% | 40.17 ± 13.3% | 0.56 ± 0.2% | 56.34 ± 0.9% | 1976.77 ± 0.1% | 2.36 | 1.00 | 1.15 | 49.25 |
| class: two capitalized words, second text | 5359 | 743.98 ± 0.2% | 744.57 ± 0.2% | 23.43 ± 0.2% | 484.11 ± 0.0% | 34.16 ± 14.8% | 16.71 ± 0.1% | 63.83 ± 0.2% | 743.25 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.78 |
| other: a word between two words | 6104 | 745.89 ± 0.2% | 777.12 ± 0.2% | 23.59 ± 0.2% | 739.39 ± 0.4% | 104.52 ± 18.8% | 11.31 ± 0.2% | 69.82 ± 0.1% | 741.82 ± 0.2% | 0.96 | 1.01 | 1.01 | 7.14 |
| other: a number before a unit, second text | 1481 | 5381.23 ± 1.0% | 978.60 ± 0.3% | 26.08 ± 0.1% | 5616.67 ± 0.5% | 40.71 ± 8.0% | 17.85 ± 0.3% | 66.98 ± 0.3% | 5372.38 ± 1.1% | 5.50 | 1.00 | 0.96 | 132.17 |
| other: a heading's start tag | 110 | 12594.78 ± 1.4% | 1037.09 ± 0.1% | 27.58 ± 0.3% | 1712.92 ± 0.5% | 1585.74 ± 3.7% | 16.31 ± 0.8% | 89.02 ± 0.2% | 12642.05 ± 0.9% | 12.14 | 1.00 | 7.35 | 7.94 |
| other: a whole word | 217 | 13838.05 ± 3.1% | 1038.69 ± 0.6% | 29.65 ± 0.2% | 14564.72 ± 1.0% | 49.48 ± 0.2% | 13.67 ± 0.4% | 55.94 ± 0.3% | 13820.12 ± 3.6% | 13.32 | 1.00 | 0.95 | 279.67 |
| other: a line's first word, second text | 3716 | 1939.72 ± 0.8% | 876.54 ± 0.1% | 31.08 ± 0.2% | 1726.19 ± 0.4% | 62.92 ± 6.9% | refused | refused | 1927.74 ± 0.7% | 2.21 | 1.01 | 1.12 | 30.83 |
| other: fourteen octets before an x | 87 | 19657.69 ± 1.9% | 231.57 ± 0.5% | 6.59 ± 0.1% | 3924.41 ± 0.4% | 10.64 ± 0.3% | differs | 17.75 ± 0.2% | 19686.51 ± 1.7% | 84.89 | 1.00 | 5.01 | 1848.00 |
| other: a Greek word | 21815 | 511.90 ± 0.5% | 413.65 ± 0.2% | 31.23 ± 0.2% | 289.72 ± 0.1% | 48.09 ± 9.2% | differs | refused | 510.77 ± 0.4% | 1.24 | 1.00 | 1.77 | 10.64 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.82 ± 0.2% | 25.75 ± 0.3% | 0.87 ± 0.2% | 19.80 ± 0.1% | 2.76 ± 0.2% | differs | 4.00 ± 0.1% | 25.84 ± 0.2% | 1.00 | 1.00 | 1.30 | 9.34 |
| a UUID | 32895 | 21.03 ± 0.2% | 21.15 ± 0.2% | 0.65 ± 0.2% | 15.15 ± 0.2% | 3.11 ± 0.1% | 0.72 ± 0.5% | 3.59 ± 0.3% | 21.12 ± 0.2% | 0.99 | 1.00 | 1.39 | 6.77 |
| an IPv4 address | 33176 | 36.81 ± 0.1% | 36.77 ± 0.2% | 2.10 ± 0.9% | 29.09 ± 0.4% | 6.67 ± 0.1% | differs | 4.17 ± 0.2% | 36.83 ± 0.1% | 1.00 | 1.00 | 1.27 | 5.52 |
| a date and time | 32954 | 31.14 ± 0.3% | 31.16 ± 0.5% | 1.47 ± 0.2% | 21.17 ± 0.0% | 7.05 ± 0.2% | 1.19 ± 0.3% | 7.11 ± 0.4% | 31.14 ± 0.4% | 1.00 | 1.00 | 1.47 | 4.42 |
| a field path | 32606 | 29.50 ± 0.0% | 29.40 ± 0.1% | 1.03 ± 0.5% | 23.05 ± 0.1% | 3.53 ± 0.6% | differs | 2.92 ± 0.2% | 29.40 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.35 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.45 ± 0.8% | 11.48 ± 0.5% | 11.44 ± 0.4% | 11.47 ± 0.2% | 4.95 ± 1.1% | 0.91 ± 0.9% | none | 11.50 ± 0.3% | 1.00 | 1.00 | 1.00 | 2.31 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 215.50 ± 0.5% | 216.38 ± 0.2% | 250.55 ± 0.2% | 86.90 ± 0.1% | 221.12 ± 1.0% | 484.36 ± 0.6% | 3883.75 ± 1.4% | 215.44 ± 0.3% | 1.00 | 1.00 | 2.48 | 0.97 |
| a UUID | 62 | 141.80 ± 0.1% | 142.14 ± 0.1% | 156.40 ± 0.4% | 45.51 ± 0.2% | 98.83 ± 0.9% | 183.51 ± 0.8% | 4423.79 ± 1.2% | 141.85 ± 0.4% | 1.00 | 1.00 | 3.12 | 1.43 |
| an IPv4 address | 29 | 432.91 ± 0.7% | 437.78 ± 1.0% | 605.95 ± 0.4% | 76.40 ± 0.8% | 131.72 ± 2.0% | 293.13 ± 0.4% | 7669.75 ± 0.2% | 432.71 ± 1.1% | 0.99 | 1.00 | 5.67 | 3.29 |
| a date and time | 56 | 315.63 ± 0.2% | 317.49 ± 0.4% | 396.78 ± 0.4% | 71.80 ± 0.2% | 136.46 ± 1.6% | 321.21 ± 0.4% | 4944.72 ± 0.5% | 315.88 ± 0.7% | 0.99 | 1.00 | 4.40 | 2.31 |
| a field path | 39 | 201.30 ± 0.2% | 201.92 ± 0.5% | 231.31 ± 0.3% | 79.26 ± 0.6% | 204.38 ± 2.3% | 484.57 ± 0.4% | 4972.16 ± 2.5% | 201.40 ± 0.4% | 1.00 | 1.00 | 2.54 | 0.98 |
| literal: a word | 7 | 643.80 ± 0.4% | 696.00 ± 0.4% | 1231.31 ± 0.6% | 506.48 ± 1.6% | 624.34 ± 1.2% | 923.44 ± 0.3% | 31207.81 ± 0.3% | 645.25 ± 0.5% | 0.92 | 1.00 | 1.27 | 1.03 |
| literal: a word that is not there | 8 | 615.24 ± 0.2% | 669.64 ± 0.2% | 1160.04 ± 0.1% | 463.70 ± 0.1% | 600.64 ± 2.1% | 875.94 ± 0.3% | 29465.11 ± 0.1% | 616.03 ± 0.2% | 0.92 | 1.00 | 1.33 | 1.02 |
| literal: one of four words | 26 | 249.53 ± 0.3% | 406.81 ± 0.3% | 545.24 ± 0.2% | 49.37 ± 0.3% | 243.57 ± 1.2% | 355.91 ± 0.6% | 15842.83 ± 0.4% | 249.45 ± 0.2% | 0.61 | 1.00 | 5.05 | 1.02 |
| literal: a word in any case | 11 | 514.03 ± 0.5% | 555.33 ± 0.4% | 853.94 ± 0.4% | 15.75 ± 0.9% | 649.44 ± 2.8% | refused | 23664.74 ± 0.3% | 513.79 ± 0.2% | 0.93 | 1.00 | 32.63 | 0.79 |
| literal: an href attribute | 12 | 344.84 ± 0.3% | 356.00 ± 0.3% | 463.19 ± 0.4% | 9.84 ± 27.2% | 497.76 ± 1.3% | 759.15 ± 2.0% | 22206.64 ± 0.2% | 344.68 ± 0.5% | 0.97 | 1.00 | 35.06 | 0.69 |
| literal: a word, second text | 10 | 572.71 ± 0.1% | 632.46 ± 0.3% | 1047.74 ± 0.1% | 413.77 ± 0.4% | 535.89 ± 1.7% | 799.43 ± 0.1% | 27415.85 ± 0.1% | 572.26 ± 0.2% | 0.91 | 1.00 | 1.38 | 1.07 |
| class: two capitalized words | 23 | 454.89 ± 0.4% | 485.42 ± 0.3% | 702.91 ± 0.6% | 100.90 ± 0.1% | 505.05 ± 0.7% | 739.32 ± 0.4% | 6611.29 ± 1.0% | 454.99 ± 0.2% | 0.94 | 1.00 | 4.51 | 0.90 |
| class: a word that ends in ing | 9 | 583.26 ± 0.4% | 653.44 ± 0.4% | 1135.38 ± 0.5% | 132.31 ± 0.6% | 760.90 ± 0.8% | 1108.94 ± 1.3% | 16300.86 ± 0.1% | 583.74 ± 0.3% | 0.89 | 1.00 | 4.41 | 0.77 |
| class: a word in capitals | 16 | 515.13 ± 0.3% | 554.55 ± 0.3% | 877.74 ± 0.5% | 134.65 ± 1.1% | 752.16 ± 1.7% | 1017.93 ± 1.1% | 8699.67 ± 0.1% | 514.99 ± 0.3% | 0.93 | 1.00 | 3.83 | 0.68 |
| class: a number | 6 | 647.08 ± 0.3% | 710.69 ± 0.3% | 1317.72 ± 0.1% | 41.71 ± 0.6% | 1404.37 ± 0.8% | 1849.36 ± 1.3% | 23067.32 ± 0.2% | 647.35 ± 0.1% | 0.91 | 1.00 | 15.51 | 0.46 |
| class: two capitalized words, second text | 23 | 455.38 ± 1.4% | 485.77 ± 0.3% | 703.11 ± 0.4% | 101.54 ± 0.6% | 503.00 ± 2.0% | 737.57 ± 0.4% | 6619.77 ± 0.2% | 455.21 ± 0.4% | 0.94 | 1.00 | 4.48 | 0.91 |
| other: a word between two words | 13 | 566.46 ± 0.4% | 586.15 ± 0.2% | 924.06 ± 0.1% | 134.92 ± 0.8% | 505.67 ± 1.2% | 809.73 ± 0.5% | 15097.01 ± 0.5% | 566.72 ± 0.4% | 0.97 | 1.00 | 4.20 | 1.12 |
| other: a number before a unit, second text | 15 | 395.32 ± 0.3% | 429.91 ± 0.1% | 588.72 ± 0.4% | 39.45 ± 0.3% | 637.60 ± 0.7% | 890.10 ± 0.4% | 15387.26 ± 0.1% | 394.83 ± 0.3% | 0.92 | 1.00 | 10.02 | 0.62 |
| other: a heading's start tag | 13 | 354.87 ± 0.4% | 359.06 ± 0.6% | 467.57 ± 0.7% | 11.83 ± 19.3% | 625.88 ± 0.5% | 867.82 ± 0.6% | 18449.63 ± 0.3% | 354.07 ± 0.7% | 0.99 | 1.00 | 29.99 | 0.57 |
| other: a whole word | 11 | 598.55 ± 0.3% | 636.60 ± 0.4% | 1053.70 ± 0.1% | 119.67 ± 0.4% | 567.90 ± 3.6% | 832.66 ± 0.8% | 27160.97 ± 0.8% | 598.68 ± 0.4% | 0.94 | 1.00 | 5.00 | 1.05 |
| other: a line's first word, second text | 17 | 547.17 ± 0.4% | 567.97 ± 0.2% | 903.21 ± 0.1% | 127.67 ± 0.3% | 716.15 ± 0.5% | refused | refused | 545.67 ± 0.7% | 0.96 | 1.00 | 4.29 | 0.76 |
| other: fourteen octets before an x | 16 | 112.33 ± 0.7% | 162.65 ± 0.4% | 186.00 ± 0.3% | 6.40 ± 19.8% | 453.45 ± 9.9% | 419.38 ± 1.4% | 12816.75 ± 0.5% | 112.14 ± 0.3% | 0.69 | 1.00 | 17.54 | 0.25 |
| other: a Greek word | 8 | 444.95 ± 0.3% | 584.04 ± 0.4% | 949.28 ± 0.1% | 10.58 ± 8.5% | 1390.64 ± 1.0% | 1744.50 ± 0.5% | refused | 445.33 ± 0.2% | 0.76 | 1.00 | 42.04 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12800.98 ± 1.2% | not timed | not timed | 16197.92 ± 2.7% | 1913.03 ± 21.1% | not timed | not timed | 12772.89 ± 1.2% | | 1.00 | 0.79 | 6.69 |
| 01-literal/sherlock-casei-en | 522 | 4496.94 ± 1.1% | not timed | not timed | 3594.68 ± 0.1% | 32.52 ± 0.4% | not timed | not timed | 4486.60 ± 0.7% | | 1.00 | 1.25 | 138.26 |
| 01-literal/sherlock-ru | 724 | 13556.48 ± 0.3% | not timed | not timed | 17310.53 ± 0.3% | 1480.58 ± 5.4% | not timed | not timed | 13532.09 ± 0.3% | | 1.00 | 0.78 | 9.16 |
| 01-literal/sherlock-casei-ru | 746 | 5300.80 ± 0.3% | not timed | not timed | 3328.84 ± 0.1% | 31.62 ± 9.0% | not timed | not timed | 5298.55 ± 0.4% | | 1.00 | 1.59 | 167.66 |
| 01-literal/sherlock-zh | 30 | 16936.64 ± 0.3% | not timed | not timed | 18642.39 ± 0.9% | 2660.82 ± 14.1% | not timed | not timed | 16893.12 ± 0.4% | | 1.00 | 0.91 | 6.37 |
| 02-literal-alternate/sherlock-en | 714 | 5768.00 ± 0.1% | not timed | not timed | 3942.89 ± 0.6% | 16.63 ± 6.4% | not timed | not timed | 5754.46 ± 0.6% | | 1.00 | 1.46 | 346.85 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1715.68 ± 0.9% | not timed | not timed | 697.47 ± 0.2% | 11.12 ± 0.2% | not timed | not timed | 1703.95 ± 0.3% | | 1.01 | 2.46 | 154.32 |
| 02-literal-alternate/sherlock-ru | 899 | 4652.39 ± 0.1% | not timed | not timed | 3256.11 ± 0.1% | 22.62 ± 0.1% | not timed | not timed | 4648.09 ± 0.1% | | 1.00 | 1.43 | 205.64 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1813.27 ± 0.6% | not timed | not timed | 1226.82 ± 0.3% | 9.13 ± 0.0% | not timed | not timed | 1805.39 ± 0.2% | | 1.00 | 1.48 | 198.68 |
| 02-literal-alternate/sherlock-zh | 207 | 7043.01 ± 0.3% | not timed | not timed | 4158.51 ± 0.2% | 31.43 ± 0.1% | not timed | not timed | 7040.71 ± 0.2% | | 1.00 | 1.69 | 224.06 |
| 03-date/ascii | 111817 | 127.44 ± 0.5% | not timed | not timed | 96.02 ± 0.4% | 0.20 ± 2.3% | not timed | not timed | 126.81 ± 1.3% | | 1.00 | 1.33 | 623.24 |
| 04-ruff-noqa/real | 84 | 553.69 ± 0.1% | not timed | not timed | 457.96 ± 0.2% | 19.56 ± 0.5% | not timed | not timed | 553.24 ± 0.1% | | 1.00 | 1.21 | 28.31 |
| 04-ruff-noqa/tweaked | 44 | 549.85 ± 0.2% | not timed | not timed | 462.37 ± 0.1% | 365.19 ± 0.8% | not timed | not timed | 548.37 ± 0.1% | | 1.00 | 1.19 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.94 ± 0.1% | not timed | not timed | 4.98 ± 0.1% | 0.20 ± 8.3% | not timed | not timed | 4.08 ± 2.9% | | 0.97 | 0.79 | 19.36 |
| 06-cloud-flare-redos/original | 107 | 263.80 ± 0.1% | not timed | not timed | 215.74 ± 1.9% | 24.92 ± 10.5% | not timed | not timed | 263.49 ± 13.1% | | 1.00 | 1.22 | 10.59 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.28 ± 5.6% | not timed | not timed | 228.64 ± 1.1% | 26.57 ± 5.1% | not timed | not timed | 259.21 ± 0.8% | | 1.00 | 1.13 | 9.76 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.13 ± 0.1% | not timed | not timed | 255.84 ± 0.4% | 28.80 ± 0.2% | not timed | not timed | 286.27 ± 0.3% | | 1.00 | 1.12 | 9.94 |
| 07-unicode-character-data/parse-line | 558784 | 238.99 ± 0.8% | not timed | not timed | 171.54 ± 0.1% | 42.98 ± 0.7% | not timed | not timed | 239.07 ± 0.4% | | 1.00 | 1.39 | 5.56 |
| 08-words/all-english | 56691 | 121.31 ± 0.4% | not timed | not timed | 82.73 ± 0.1% | 12.05 ± 10.4% | not timed | not timed | 120.90 ± 0.5% | | 1.00 | 1.47 | 10.07 |
| 08-words/long-english | 839 | 1006.86 ± 0.1% | not timed | not timed | 595.61 ± 0.1% | 32.45 ± 0.8% | not timed | not timed | 1006.27 ± 0.3% | | 1.00 | 1.69 | 31.03 |
| 09-aws-keys/full | 0 | 409.12 ± 0.0% | not timed | not timed | 464.84 ± 0.1% | 64.63 ± 0.1% | not timed | not timed | 408.55 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 728.30 ± 0.1% | not timed | not timed | 989.51 ± 0.2% | 420.74 ± 1.1% | not timed | not timed | 732.66 ± 0.0% | | 0.99 | 0.74 | 1.73 |
| 10-bounded-repeat/letters-en | 1833 | 638.79 ± 0.3% | not timed | not timed | 516.32 ± 0.1% | 19.48 ± 0.2% | not timed | not timed | 637.28 ± 0.2% | | 1.00 | 1.24 | 32.78 |
| 10-bounded-repeat/letters-ru | 3475 | 385.82 ± 0.1% | not timed | not timed | 477.73 ± 0.3% | 22.22 ± 9.7% | not timed | not timed | 384.16 ± 0.6% | | 1.00 | 0.81 | 17.37 |
| 10-bounded-repeat/context | 53 | 79.00 ± 1.1% | not timed | not timed | 65.99 ± 0.7% | 19.84 ± 0.3% | not timed | not timed | 79.16 ± 1.1% | | 1.00 | 1.20 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 1041.74 ± 0.1% | not timed | not timed | 618.24 ± 0.1% | 35.51 ± 0.1% | not timed | not timed | 1041.50 ± 0.4% | | 1.00 | 1.68 | 29.34 |
| 11-unstructured-to-json/extract | 600 | 49.84 ± 0.3% | not timed | not timed | 77.07 ± 0.3% | 48.76 ± 0.3% | not timed | not timed | 49.59 ± 0.8% | | 1.01 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 566.97 ± 0.6% | not timed | not timed | 561.61 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 568.09 ± 0.3% | | 1.00 | 1.01 | 1396.51 |
| 14-quadratic/1x | 100 | 9.67 ± 0.4% | not timed | not timed | 10.05 ± 0.3% | 0.98 ± 3.5% | not timed | not timed | 9.66 ± 1.2% | | 1.00 | 0.96 | 9.88 |
| 14-quadratic/2x | 200 | 5.57 ± 0.5% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 1.3% | not timed | not timed | 5.55 ± 1.2% | | 1.00 | 1.01 | 10.47 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.3% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.5% | not timed | not timed | 1.26 ± 0.8% | | 1.00 | 1.04 | 10.92 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 0.2% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 4.5% | not timed | not timed | 1.53 ± 0.3% | | 1.00 | 4.47 | 2.77 |
| 04-ruff-noqa/compile-real | 1 | 85.14 ± 0.1% | not timed | not timed | 14.02 ± 0.1% | 139.56 ± 2.2% | not timed | not timed | 84.86 ± 0.7% | | 1.00 | 6.07 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.34 ± 0.2% | not timed | not timed | 2.53 ± 0.7% | 6.46 ± 0.6% | not timed | not timed | 14.17 ± 2.3% | | 1.01 | 5.67 | 2.22 |
| 07-unicode-character-data/compile | 1 | 54.55 ± 0.1% | not timed | not timed | 26.02 ± 0.3% | 35.95 ± 2.4% | not timed | not timed | 54.64 ± 1.1% | | 1.00 | 2.10 | 1.52 |
| 09-aws-keys/compile-full | 1 | 41.87 ± 0.2% | not timed | not timed | 8.39 ± 0.3% | 23.40 ± 0.5% | not timed | not timed | 41.92 ± 0.4% | | 1.00 | 4.99 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 186.70 ± 0.1% | not timed | not timed | 48.15 ± 0.1% | 134.72 ± 2.0% | not timed | not timed | 186.40 ± 0.7% | | 1.00 | 3.88 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.62 ± 0.7% | not timed | not timed | 11.28 ± 0.1% | 15.99 ± 2.0% | not timed | not timed | 14.48 ± 0.8% | | 1.01 | 1.30 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 84.91 ± 0.1% | not timed | not timed | 8.16 ± 0.3% | 23.60 ± 1.8% | not timed | not timed | 84.81 ± 0.4% | | 1.00 | 10.40 | 3.60 |
| 11-unstructured-to-json/compile | 1 | 85.59 ± 0.2% | not timed | not timed | 40.25 ± 0.2% | 68.62 ± 1.5% | not timed | not timed | 85.18 ± 1.0% | | 1.00 | 2.13 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.5% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 7.2% | not timed | not timed | 0.36 ± 1.0% | | 1.00 | 5.28 | 3.77 |

