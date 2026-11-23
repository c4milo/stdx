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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159283718 |
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
| literal: a word | 217 | 16110.34 ± 0.9% | 1048.94 ± 0.1% | 27.92 ± 0.1% | 18361.12 ± 1.6% | 9112.13 ± 8.2% | 16.99 ± 0.2% | 87.13 ± 0.1% | 16131.68 ± 0.8% | 15.36 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18741.20 ± 1.7% | 1056.07 ± 0.1% | 27.81 ± 0.2% | 19966.80 ± 1.7% | 29119.82 ± 1.7% | 16.79 ± 0.1% | 82.97 ± 0.2% | 18831.45 ± 1.0% | 17.75 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6079.47 ± 0.3% | 1030.74 ± 0.1% | 14.54 ± 0.3% | 3945.76 ± 0.5% | 21.85 ± 0.1% | 5.10 ± 0.2% | 6.91 ± 0.4% | 6068.31 ± 0.1% | 5.90 | 1.00 | 1.54 | 278.30 |
| literal: a word in any case | 217 | 12648.61 ± 0.4% | 1048.22 ± 0.3% | 21.46 ± 2.2% | 3969.34 ± 0.2% | 38.08 ± 0.4% | refused | differs | 12604.18 ± 0.4% | 12.07 | 1.00 | 3.19 | 332.15 |
| literal: an href attribute | 33 | 13618.07 ± 0.4% | 1055.45 ± 0.4% | 26.92 ± 0.5% | 17165.06 ± 0.8% | 2258.17 ± 0.7% | 12.90 ± 0.4% | 76.00 ± 0.3% | 13658.53 ± 0.8% | 12.90 | 1.00 | 0.79 | 6.03 |
| literal: a word, second text | 123 | 16376.25 ± 0.5% | 1051.39 ± 0.4% | 27.60 ± 0.0% | 18306.61 ± 2.5% | 7734.10 ± 5.7% | 18.52 ± 0.5% | 71.32 ± 0.4% | 16331.65 ± 1.1% | 15.58 | 1.00 | 0.89 | 2.12 |
| class: two capitalized words | 1331 | 1124.53 ± 0.4% | 978.86 ± 0.3% | 25.70 ± 0.2% | 585.48 ± 0.1% | 40.46 ± 2.2% | 14.34 ± 0.3% | 68.93 ± 0.2% | 1124.13 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.80 |
| class: a word that ends in ing | 3399 | 902.29 ± 0.2% | 901.75 ± 0.1% | 17.90 ± 0.4% | 548.06 ± 0.2% | 29.62 ± 6.1% | 7.98 ± 0.3% | 18.40 ± 0.8% | 901.32 ± 0.1% | 1.00 | 1.00 | 1.65 | 30.46 |
| class: a word in capitals | 2332 | 1457.52 ± 0.5% | 955.85 ± 0.1% | 27.26 ± 0.4% | 572.60 ± 0.1% | 43.49 ± 7.1% | 16.66 ± 0.3% | 83.08 ± 0.8% | 1462.41 ± 0.6% | 1.52 | 1.00 | 2.55 | 33.51 |
| class: a number | 8288 | 2018.40 ± 0.3% | 840.51 ± 0.1% | 27.37 ± 0.5% | 1724.41 ± 0.2% | 42.94 ± 7.2% | 0.54 ± 0.3% | 56.68 ± 0.4% | 1969.35 ± 0.1% | 2.40 | 1.02 | 1.17 | 47.00 |
| class: two capitalized words, second text | 5359 | 744.10 ± 0.1% | 745.22 ± 0.2% | 23.01 ± 0.1% | 485.69 ± 0.1% | 35.02 ± 12.5% | 15.38 ± 0.3% | 64.10 ± 0.2% | 743.22 ± 0.2% | 1.00 | 1.00 | 1.53 | 21.25 |
| other: a word between two words | 6104 | 752.08 ± 0.2% | 780.99 ± 0.1% | 23.22 ± 0.1% | 738.43 ± 0.3% | 109.33 ± 13.1% | 10.89 ± 0.1% | 70.20 ± 0.2% | 753.56 ± 0.1% | 0.96 | 1.00 | 1.02 | 6.88 |
| other: a number before a unit, second text | 1481 | 5417.10 ± 0.7% | 990.91 ± 0.2% | 25.58 ± 0.2% | 5662.77 ± 0.3% | 40.76 ± 15.2% | 16.66 ± 0.2% | 67.09 ± 0.5% | 5390.05 ± 0.4% | 5.47 | 1.01 | 0.96 | 132.90 |
| other: a heading's start tag | 110 | 12589.46 ± 0.6% | 1045.38 ± 0.1% | 27.07 ± 0.1% | 1717.46 ± 0.6% | 1591.94 ± 5.2% | 15.67 ± 0.3% | 88.93 ± 0.2% | 12659.50 ± 0.7% | 12.04 | 0.99 | 7.33 | 7.91 |
| other: a whole word | 217 | 14058.96 ± 0.4% | 1045.90 ± 0.2% | 28.94 ± 0.3% | 14468.14 ± 0.8% | 49.40 ± 0.3% | 13.12 ± 0.2% | 56.08 ± 0.3% | 14041.22 ± 0.7% | 13.44 | 1.00 | 0.97 | 284.61 |
| other: a line's first word, second text | 3716 | 1961.62 ± 1.1% | 878.01 ± 0.2% | 30.36 ± 0.1% | 1720.01 ± 0.4% | 61.71 ± 7.5% | refused | refused | 1958.86 ± 0.8% | 2.23 | 1.00 | 1.14 | 31.79 |
| other: fourteen octets before an x | 87 | 20036.06 ± 1.0% | 253.39 ± 0.9% | 6.63 ± 0.1% | 4053.17 ± 0.4% | 10.65 ± 0.2% | differs | 17.79 ± 0.2% | 20154.83 ± 0.7% | 79.07 | 0.99 | 4.94 | 1880.52 |
| other: a Greek word | 21815 | 512.50 ± 0.6% | 412.33 ± 0.4% | 30.95 ± 1.3% | 289.15 ± 0.6% | 44.86 ± 10.4% | differs | refused | 509.55 ± 0.7% | 1.24 | 1.01 | 1.77 | 11.42 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.1% | 25.87 ± 0.2% | 0.87 ± 0.4% | 19.71 ± 0.5% | 2.75 ± 1.6% | differs | 4.01 ± 0.1% | 25.83 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.40 |
| a UUID | 32895 | 21.10 ± 0.2% | 21.13 ± 0.4% | 0.65 ± 0.3% | 15.08 ± 0.6% | 3.07 ± 0.2% | 0.72 ± 0.4% | 3.59 ± 0.5% | 21.19 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.86 |
| an IPv4 address | 33176 | 36.91 ± 0.2% | 36.80 ± 0.2% | 2.11 ± 0.2% | 28.84 ± 0.6% | 6.64 ± 0.1% | differs | 4.15 ± 0.5% | 36.89 ± 0.1% | 1.00 | 1.00 | 1.28 | 5.56 |
| a date and time | 32954 | 31.00 ± 0.3% | 31.14 ± 0.2% | 1.47 ± 0.9% | 21.07 ± 0.6% | 7.02 ± 0.2% | 1.20 ± 0.1% | 7.11 ± 0.3% | 31.08 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.42 |
| a field path | 32606 | 29.47 ± 0.2% | 29.43 ± 0.2% | 1.04 ± 0.2% | 23.00 ± 0.3% | 3.47 ± 0.9% | differs | 2.95 ± 0.4% | 29.43 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.50 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.47 ± 0.4% | 11.54 ± 0.3% | 11.55 ± 0.4% | 11.38 ± 0.1% | 4.97 ± 1.4% | 0.91 ± 0.3% | none | 11.53 ± 0.5% | 0.99 | 0.99 | 1.01 | 2.31 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.76 ± 0.3% | 221.29 ± 0.4% | 257.75 ± 0.1% | 86.95 ± 0.2% | 223.78 ± 1.7% | 487.86 ± 0.6% | 3885.95 ± 1.5% | 220.80 ± 0.2% | 1.00 | 1.00 | 2.54 | 0.99 |
| a UUID | 62 | 145.22 ± 0.3% | 145.65 ± 0.3% | 160.95 ± 0.2% | 45.69 ± 0.1% | 99.80 ± 0.8% | 183.54 ± 1.5% | 4441.63 ± 1.2% | 145.15 ± 0.1% | 1.00 | 1.00 | 3.18 | 1.46 |
| an IPv4 address | 29 | 436.56 ± 0.6% | 440.55 ± 0.3% | 609.39 ± 0.3% | 76.52 ± 1.0% | 133.05 ± 0.7% | 294.53 ± 0.7% | 7673.92 ± 0.2% | 436.46 ± 0.8% | 0.99 | 1.00 | 5.70 | 3.28 |
| a date and time | 56 | 319.06 ± 0.4% | 320.21 ± 0.1% | 401.05 ± 0.3% | 72.18 ± 0.3% | 140.10 ± 1.5% | 321.57 ± 0.5% | 4950.94 ± 0.4% | 318.66 ± 0.4% | 1.00 | 1.00 | 4.42 | 2.28 |
| a field path | 39 | 208.57 ± 0.2% | 209.03 ± 0.1% | 240.99 ± 0.1% | 79.60 ± 0.4% | 209.98 ± 0.8% | 486.86 ± 0.4% | 4960.63 ± 0.6% | 208.59 ± 0.2% | 1.00 | 1.00 | 2.62 | 0.99 |
| literal: a word | 7 | 660.11 ± 0.6% | 709.75 ± 0.6% | 1254.41 ± 0.8% | 508.14 ± 1.6% | 636.16 ± 1.5% | 924.56 ± 0.4% | 30813.05 ± 0.5% | 659.72 ± 0.4% | 0.93 | 1.00 | 1.30 | 1.04 |
| literal: a word that is not there | 8 | 632.86 ± 0.5% | 684.42 ± 0.6% | 1171.85 ± 0.1% | 464.19 ± 0.2% | 610.22 ± 2.0% | 877.42 ± 0.5% | 29712.55 ± 0.2% | 632.62 ± 0.2% | 0.92 | 1.00 | 1.36 | 1.04 |
| literal: one of four words | 26 | 253.75 ± 0.3% | 416.81 ± 0.2% | 560.57 ± 0.5% | 49.41 ± 0.4% | 247.20 ± 0.8% | 355.36 ± 0.4% | 15842.04 ± 0.4% | 253.76 ± 0.4% | 0.61 | 1.00 | 5.14 | 1.03 |
| literal: a word in any case | 11 | 517.04 ± 0.4% | 557.83 ± 0.6% | 857.22 ± 0.5% | 15.76 ± 0.9% | 662.99 ± 3.0% | refused | 23894.85 ± 0.5% | 517.50 ± 0.2% | 0.93 | 1.00 | 32.81 | 0.78 |
| literal: an href attribute | 12 | 347.59 ± 0.2% | 358.25 ± 0.2% | 464.55 ± 0.4% | 12.86 ± 30.3% | 502.30 ± 1.6% | 759.21 ± 2.5% | 22504.95 ± 0.2% | 347.70 ± 0.1% | 0.97 | 1.00 | 27.02 | 0.69 |
| literal: a word, second text | 10 | 587.62 ± 0.3% | 645.11 ± 0.3% | 1070.85 ± 0.1% | 413.15 ± 0.1% | 546.57 ± 2.3% | 798.37 ± 0.3% | 27757.82 ± 0.2% | 587.41 ± 0.2% | 0.91 | 1.00 | 1.42 | 1.08 |
| class: two capitalized words | 23 | 456.57 ± 0.4% | 485.65 ± 0.6% | 699.99 ± 0.3% | 100.21 ± 0.2% | 511.18 ± 0.8% | 745.22 ± 1.0% | 6651.97 ± 0.5% | 456.95 ± 0.4% | 0.94 | 1.00 | 4.56 | 0.89 |
| class: a word that ends in ing | 9 | 591.86 ± 0.7% | 657.27 ± 0.7% | 1146.79 ± 0.4% | 132.81 ± 1.1% | 761.04 ± 1.0% | 1113.23 ± 2.1% | 16326.94 ± 0.3% | 591.89 ± 0.2% | 0.90 | 1.00 | 4.46 | 0.78 |
| class: a word in capitals | 16 | 519.97 ± 0.1% | 559.67 ± 0.4% | 893.43 ± 0.4% | 135.21 ± 0.8% | 758.78 ± 1.3% | 1025.15 ± 2.8% | 8723.85 ± 0.3% | 520.76 ± 0.2% | 0.93 | 1.00 | 3.85 | 0.69 |
| class: a number | 6 | 654.24 ± 0.4% | 715.08 ± 0.4% | 1330.26 ± 0.2% | 41.80 ± 1.2% | 1415.18 ± 1.7% | 1853.57 ± 1.1% | 23352.84 ± 0.1% | 655.75 ± 0.4% | 0.91 | 1.00 | 15.65 | 0.46 |
| class: two capitalized words, second text | 23 | 456.54 ± 0.5% | 485.71 ± 0.8% | 699.66 ± 0.3% | 101.84 ± 0.5% | 506.55 ± 1.8% | 739.49 ± 0.9% | 6651.60 ± 0.6% | 456.80 ± 0.4% | 0.94 | 1.00 | 4.48 | 0.90 |
| other: a word between two words | 13 | 570.23 ± 1.0% | 587.16 ± 0.8% | 928.21 ± 1.2% | 135.11 ± 0.6% | 510.45 ± 2.1% | 817.94 ± 1.1% | 15111.01 ± 0.0% | 570.44 ± 0.3% | 0.97 | 1.00 | 4.22 | 1.12 |
| other: a number before a unit, second text | 15 | 400.32 ± 0.2% | 435.52 ± 0.3% | 598.88 ± 0.2% | 39.40 ± 0.4% | 641.16 ± 1.4% | 892.35 ± 0.2% | 15417.87 ± 0.0% | 400.93 ± 0.2% | 0.92 | 1.00 | 10.16 | 0.62 |
| other: a heading's start tag | 13 | 359.78 ± 0.5% | 363.68 ± 0.3% | 474.17 ± 0.5% | 12.26 ± 20.7% | 634.90 ± 1.3% | 873.98 ± 0.9% | 18609.97 ± 0.0% | 359.66 ± 0.2% | 0.99 | 1.00 | 29.35 | 0.57 |
| other: a whole word | 11 | 605.49 ± 0.4% | 642.27 ± 0.4% | 1063.03 ± 0.3% | 120.56 ± 0.4% | 573.05 ± 1.5% | 821.49 ± 1.0% | 27071.88 ± 0.6% | 606.33 ± 0.3% | 0.94 | 1.00 | 5.02 | 1.06 |
| other: a line's first word, second text | 17 | 551.22 ± 0.3% | 573.83 ± 0.6% | 917.78 ± 0.6% | 127.61 ± 0.7% | 722.23 ± 1.5% | refused | refused | 549.82 ± 0.6% | 0.96 | 1.00 | 4.32 | 0.76 |
| other: fourteen octets before an x | 16 | 112.20 ± 0.6% | 162.56 ± 0.6% | 186.06 ± 0.8% | 7.62 ± 34.4% | 457.07 ± 2.1% | 415.51 ± 0.8% | 12884.95 ± 0.4% | 112.17 ± 0.3% | 0.69 | 1.00 | 14.72 | 0.25 |
| other: a Greek word | 8 | 445.44 ± 0.3% | 584.39 ± 0.6% | 946.19 ± 0.1% | 16.13 ± 36.8% | 1392.00 ± 0.9% | 1730.29 ± 0.5% | refused | 445.90 ± 0.1% | 0.76 | 1.00 | 27.62 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12964.93 ± 0.4% | not timed | not timed | 16370.03 ± 1.7% | 2177.40 ± 8.7% | not timed | not timed | 12963.86 ± 1.1% | | 1.00 | 0.79 | 5.95 |
| 01-literal/sherlock-casei-en | 522 | 4478.02 ± 1.3% | not timed | not timed | 3592.46 ± 0.2% | 32.18 ± 0.3% | not timed | not timed | 4478.48 ± 0.4% | | 1.00 | 1.25 | 139.15 |
| 01-literal/sherlock-ru | 724 | 13539.69 ± 0.4% | not timed | not timed | 17338.78 ± 0.2% | 1498.36 ± 8.8% | not timed | not timed | 13524.28 ± 0.5% | | 1.00 | 0.78 | 9.04 |
| 01-literal/sherlock-casei-ru | 746 | 5297.29 ± 0.2% | not timed | not timed | 3329.79 ± 0.1% | 31.35 ± 0.9% | not timed | not timed | 5305.83 ± 0.2% | | 1.00 | 1.59 | 168.98 |
| 01-literal/sherlock-zh | 30 | 17147.30 ± 0.5% | not timed | not timed | 18864.43 ± 1.6% | 2712.34 ± 16.8% | not timed | not timed | 17135.53 ± 0.7% | | 1.00 | 0.91 | 6.32 |
| 02-literal-alternate/sherlock-en | 714 | 5780.34 ± 0.3% | not timed | not timed | 3940.36 ± 0.3% | 16.58 ± 0.1% | not timed | not timed | 5775.80 ± 0.4% | | 1.00 | 1.47 | 348.56 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1709.70 ± 0.9% | not timed | not timed | 696.20 ± 0.4% | 10.98 ± 11.8% | not timed | not timed | 1702.69 ± 0.8% | | 1.00 | 2.46 | 155.75 |
| 02-literal-alternate/sherlock-ru | 899 | 4651.81 ± 0.1% | not timed | not timed | 3259.20 ± 0.2% | 22.58 ± 0.2% | not timed | not timed | 4652.31 ± 0.1% | | 1.00 | 1.43 | 206.00 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1805.86 ± 1.0% | not timed | not timed | 1231.14 ± 0.2% | 9.07 ± 0.3% | not timed | not timed | 1800.05 ± 0.4% | | 1.00 | 1.47 | 199.19 |
| 02-literal-alternate/sherlock-zh | 207 | 7055.56 ± 0.3% | not timed | not timed | 4163.81 ± 0.2% | 31.50 ± 0.2% | not timed | not timed | 7045.05 ± 0.3% | | 1.00 | 1.69 | 223.99 |
| 03-date/ascii | 111817 | 126.94 ± 0.3% | not timed | not timed | 96.50 ± 0.1% | 0.20 ± 1.8% | not timed | not timed | 126.33 ± 0.3% | | 1.00 | 1.32 | 636.03 |
| 04-ruff-noqa/real | 84 | 555.63 ± 0.1% | not timed | not timed | 455.65 ± 0.1% | 19.59 ± 1.5% | not timed | not timed | 556.17 ± 0.2% | | 1.00 | 1.22 | 28.37 |
| 04-ruff-noqa/tweaked | 44 | 541.12 ± 0.2% | not timed | not timed | 460.51 ± 0.0% | 367.92 ± 0.5% | not timed | not timed | 540.33 ± 0.2% | | 1.00 | 1.18 | 1.47 |
| 05-lexer-veryl/single | 124800 | 3.98 ± 0.4% | not timed | not timed | 5.11 ± 0.4% | 0.21 ± 3.5% | not timed | not timed | 4.16 ± 0.4% | | 0.96 | 0.78 | 19.38 |
| 06-cloud-flare-redos/original | 107 | 260.50 ± 0.3% | not timed | not timed | 218.04 ± 0.1% | 24.84 ± 0.4% | not timed | not timed | 260.02 ± 0.2% | | 1.00 | 1.19 | 10.49 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.72 ± 0.2% | not timed | not timed | 227.55 ± 0.2% | 26.69 ± 0.1% | not timed | not timed | 254.52 ± 0.4% | | 1.00 | 1.12 | 9.54 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.58 ± 0.3% | not timed | not timed | 255.70 ± 0.0% | 28.80 ± 0.1% | not timed | not timed | 291.78 ± 0.4% | | 1.00 | 1.14 | 10.12 |
| 07-unicode-character-data/parse-line | 558784 | 240.04 ± 2.3% | not timed | not timed | 172.40 ± 0.1% | 42.93 ± 4.4% | not timed | not timed | 241.69 ± 0.3% | | 0.99 | 1.39 | 5.59 |
| 08-words/all-english | 56691 | 121.75 ± 0.5% | not timed | not timed | 83.22 ± 0.2% | 12.12 ± 11.0% | not timed | not timed | 121.38 ± 0.3% | | 1.00 | 1.46 | 10.05 |
| 08-words/long-english | 839 | 1012.73 ± 0.2% | not timed | not timed | 595.59 ± 0.0% | 32.44 ± 0.6% | not timed | not timed | 1012.38 ± 0.2% | | 1.00 | 1.70 | 31.22 |
| 09-aws-keys/full | 0 | 409.44 ± 0.1% | not timed | not timed | 463.42 ± 0.1% | 64.66 ± 0.2% | not timed | not timed | 409.01 ± 0.2% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 740.10 ± 0.1% | not timed | not timed | 992.54 ± 0.3% | 418.99 ± 0.9% | not timed | not timed | 735.89 ± 0.1% | | 1.01 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 637.35 ± 0.4% | not timed | not timed | 513.79 ± 1.1% | 19.56 ± 0.5% | not timed | not timed | 636.66 ± 0.3% | | 1.00 | 1.24 | 32.59 |
| 10-bounded-repeat/letters-ru | 3475 | 382.53 ± 0.2% | not timed | not timed | 477.15 ± 0.3% | 21.91 ± 8.5% | not timed | not timed | 380.48 ± 0.5% | | 1.01 | 0.80 | 17.46 |
| 10-bounded-repeat/context | 53 | 80.17 ± 2.3% | not timed | not timed | 66.13 ± 2.0% | 19.83 ± 0.1% | not timed | not timed | 79.66 ± 0.6% | | 1.01 | 1.21 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 1057.03 ± 0.3% | not timed | not timed | 618.68 ± 0.0% | 36.57 ± 0.0% | not timed | not timed | 1055.39 ± 0.2% | | 1.00 | 1.71 | 28.90 |
| 11-unstructured-to-json/extract | 600 | 49.82 ± 0.1% | not timed | not timed | 76.96 ± 0.2% | 49.13 ± 0.4% | not timed | not timed | 49.60 ± 0.1% | | 1.00 | 0.65 | 1.01 |
| 12-dictionary/single | 1 | 568.19 ± 0.3% | not timed | not timed | 560.60 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 568.19 ± 0.4% | | 1.00 | 1.01 | 1405.49 |
| 14-quadratic/1x | 100 | 12.83 ± 0.5% | not timed | not timed | 9.99 ± 0.2% | 0.99 ± 3.3% | not timed | not timed | 12.70 ± 0.9% | | 1.01 | 1.28 | 12.98 |
| 14-quadratic/2x | 200 | 7.96 ± 0.3% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.7% | not timed | not timed | 7.93 ± 0.5% | | 1.00 | 1.44 | 14.94 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 0.2% | not timed | not timed | 1.87 ± 1.4% | | 1.00 | 1.55 | 16.18 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.3% | not timed | not timed | 0.35 ± 0.6% | 0.55 ± 4.1% | not timed | not timed | 1.54 ± 1.4% | | 1.01 | 4.49 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 87.01 ± 0.1% | not timed | not timed | 13.69 ± 0.8% | 143.05 ± 2.5% | not timed | not timed | 86.43 ± 0.8% | | 1.01 | 6.36 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.30 ± 0.1% | not timed | not timed | 2.52 ± 1.3% | 6.55 ± 1.5% | not timed | not timed | 14.22 ± 1.2% | | 1.01 | 5.67 | 2.18 |
| 07-unicode-character-data/compile | 1 | 55.31 ± 0.1% | not timed | not timed | 25.52 ± 0.2% | 36.49 ± 1.2% | not timed | not timed | 55.25 ± 0.3% | | 1.00 | 2.17 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.36 ± 0.2% | not timed | not timed | 8.21 ± 0.2% | 23.61 ± 1.4% | not timed | not timed | 42.29 ± 0.5% | | 1.00 | 5.16 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 189.59 ± 0.1% | not timed | not timed | 46.77 ± 0.2% | 135.62 ± 4.8% | not timed | not timed | 188.79 ± 1.1% | | 1.00 | 4.05 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.70 ± 0.8% | not timed | not timed | 11.11 ± 0.2% | 16.53 ± 1.0% | not timed | not timed | 14.53 ± 1.2% | | 1.01 | 1.32 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 85.16 ± 0.8% | not timed | not timed | 8.12 ± 0.1% | 24.38 ± 1.6% | not timed | not timed | 84.36 ± 1.2% | | 1.01 | 10.48 | 3.49 |
| 11-unstructured-to-json/compile | 1 | 86.80 ± 0.3% | not timed | not timed | 41.34 ± 0.2% | 69.50 ± 3.6% | not timed | not timed | 85.91 ± 1.1% | | 1.01 | 2.10 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.3% | 0.10 ± 8.2% | not timed | not timed | 0.35 ± 1.6% | | 1.01 | 5.09 | 3.64 |

