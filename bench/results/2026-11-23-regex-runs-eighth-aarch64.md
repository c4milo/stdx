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
| literal: a word | 217 | 16199.67 ± 1.6% | 1040.71 ± 0.2% | 28.10 ± 0.3% | 18158.97 ± 1.7% | 9539.05 ± 5.8% | 17.39 ± 0.4% | 87.12 ± 0.1% | 16273.16 ± 0.8% | 15.57 | 1.00 | 0.89 | 1.70 |
| literal: a word that is not there | 0 | 18604.85 ± 2.4% | 1048.60 ± 0.2% | 28.14 ± 0.5% | 19611.96 ± 1.8% | 27973.88 ± 5.9% | 17.22 ± 0.2% | 82.97 ± 0.3% | 18728.61 ± 1.1% | 17.74 | 0.99 | 0.95 | 0.67 |
| literal: one of four words | 661 | 6059.79 ± 0.5% | 1023.97 ± 0.1% | 14.58 ± 0.2% | 3944.34 ± 0.2% | 21.88 ± 0.1% | 5.25 ± 0.1% | 6.92 ± 0.4% | 6043.91 ± 0.3% | 5.92 | 1.00 | 1.54 | 276.93 |
| literal: a word in any case | 217 | 12613.47 ± 0.4% | 1040.34 ± 0.2% | 21.11 ± 1.8% | 3974.28 ± 0.2% | 38.08 ± 0.1% | refused | differs | 12625.74 ± 0.3% | 12.12 | 1.00 | 3.17 | 331.28 |
| literal: an href attribute | 33 | 13786.19 ± 0.5% | 1046.99 ± 0.1% | 27.05 ± 0.3% | 16940.19 ± 1.1% | 2256.97 ± 0.8% | 13.34 ± 1.0% | 75.99 ± 0.4% | 13779.94 ± 1.2% | 13.17 | 1.00 | 0.81 | 6.11 |
| literal: a word, second text | 123 | 16369.09 ± 1.3% | 1044.32 ± 0.2% | 27.80 ± 0.9% | 18260.59 ± 1.5% | 7671.02 ± 5.3% | 19.56 ± 0.9% | 71.30 ± 0.6% | 16500.04 ± 1.2% | 15.67 | 0.99 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1105.44 ± 0.6% | 977.43 ± 0.1% | 25.81 ± 0.1% | 585.46 ± 0.1% | 40.59 ± 0.3% | 14.74 ± 0.1% | 68.88 ± 0.9% | 1105.25 ± 0.4% | 1.13 | 1.00 | 1.89 | 27.24 |
| class: a word that ends in ing | 3399 | 895.28 ± 0.2% | 894.75 ± 0.1% | 17.97 ± 0.3% | 548.19 ± 0.1% | 29.63 ± 7.7% | 8.21 ± 0.1% | 18.42 ± 0.2% | 894.37 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.21 |
| class: a word in capitals | 2332 | 1454.60 ± 0.4% | 949.31 ± 0.1% | 27.53 ± 0.3% | 571.99 ± 0.1% | 43.56 ± 13.8% | 17.08 ± 0.3% | 83.09 ± 0.6% | 1456.62 ± 0.3% | 1.53 | 1.00 | 2.54 | 33.39 |
| class: a number | 8288 | 2000.89 ± 0.5% | 837.05 ± 0.1% | 27.61 ± 0.2% | 1728.58 ± 0.2% | 41.16 ± 13.8% | 0.55 ± 0.1% | 56.39 ± 1.4% | 1996.91 ± 0.1% | 2.39 | 1.00 | 1.16 | 48.62 |
| class: two capitalized words, second text | 5359 | 744.27 ± 0.2% | 744.10 ± 0.1% | 23.18 ± 0.1% | 484.69 ± 0.1% | 34.11 ± 13.8% | 16.70 ± 0.6% | 63.87 ± 0.8% | 743.70 ± 0.2% | 1.00 | 1.00 | 1.54 | 21.82 |
| other: a word between two words | 6104 | 752.96 ± 0.1% | 776.81 ± 0.1% | 23.37 ± 0.2% | 739.76 ± 0.2% | 109.86 ± 8.9% | 11.30 ± 0.1% | 70.03 ± 1.5% | 753.45 ± 0.1% | 0.97 | 1.00 | 1.02 | 6.85 |
| other: a number before a unit, second text | 1481 | 5472.70 ± 0.6% | 986.02 ± 0.1% | 25.73 ± 0.2% | 5275.18 ± 0.5% | 40.75 ± 7.5% | 17.85 ± 0.3% | 67.09 ± 0.2% | 5455.10 ± 0.6% | 5.55 | 1.00 | 1.04 | 134.29 |
| other: a heading's start tag | 110 | 12618.57 ± 1.2% | 1036.11 ± 0.1% | 27.16 ± 0.1% | 1715.97 ± 0.2% | 1586.04 ± 3.0% | 16.18 ± 0.6% | 89.06 ± 0.4% | 12624.64 ± 0.6% | 12.18 | 1.00 | 7.35 | 7.96 |
| other: a whole word | 217 | 14070.66 ± 1.5% | 1038.82 ± 0.1% | 29.21 ± 0.2% | 14636.34 ± 1.0% | 49.36 ± 0.6% | 13.52 ± 0.1% | 56.10 ± 0.2% | 14163.90 ± 1.6% | 13.54 | 0.99 | 0.96 | 285.04 |
| other: a line's first word, second text | 3716 | 1977.24 ± 0.7% | 876.88 ± 0.1% | 30.47 ± 0.2% | 1584.32 ± 0.1% | 62.19 ± 6.4% | refused | refused | 1969.73 ± 0.5% | 2.25 | 1.00 | 1.25 | 31.79 |
| other: fourteen octets before an x | 87 | 19908.64 ± 1.0% | 253.90 ± 0.7% | 6.58 ± 0.1% | 4022.78 ± 1.1% | 10.62 ± 0.2% | differs | 17.76 ± 0.6% | 19894.91 ± 1.0% | 78.41 | 1.00 | 4.95 | 1874.11 |
| other: a Greek word | 21815 | 513.46 ± 0.9% | 414.16 ± 0.1% | 31.02 ± 0.2% | 289.39 ± 0.2% | 43.81 ± 11.7% | differs | refused | 511.34 ± 0.5% | 1.24 | 1.00 | 1.77 | 11.72 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.2% | 25.84 ± 0.3% | 0.87 ± 0.4% | 19.80 ± 0.5% | 2.78 ± 0.4% | differs | 3.99 ± 0.3% | 25.80 ± 0.3% | 1.00 | 1.00 | 1.31 | 9.30 |
| a UUID | 32895 | 21.11 ± 0.2% | 21.16 ± 0.2% | 0.65 ± 0.1% | 15.15 ± 0.5% | 3.09 ± 0.9% | 0.71 ± 0.1% | 3.58 ± 1.1% | 21.18 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.84 |
| an IPv4 address | 33176 | 36.86 ± 0.4% | 36.77 ± 0.2% | 2.11 ± 0.4% | 28.90 ± 0.4% | 6.68 ± 0.2% | differs | 4.16 ± 0.3% | 36.86 ± 0.3% | 1.00 | 1.00 | 1.28 | 5.52 |
| a date and time | 32954 | 31.07 ± 0.5% | 31.19 ± 0.4% | 1.47 ± 0.2% | 21.16 ± 0.6% | 7.05 ± 0.2% | 1.20 ± 0.3% | 7.11 ± 0.2% | 31.11 ± 0.5% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.49 ± 0.2% | 29.43 ± 0.1% | 1.03 ± 0.2% | 23.04 ± 0.1% | 3.54 ± 0.4% | differs | 2.91 ± 0.1% | 29.46 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.44 ± 0.3% | 11.51 ± 0.4% | 11.50 ± 0.5% | 11.24 ± 0.2% | 4.99 ± 0.5% | 0.91 ± 0.7% | none | 11.49 ± 0.2% | 0.99 | 1.00 | 1.02 | 2.29 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.00 ± 0.3% | 222.00 ± 0.2% | 258.01 ± 0.2% | 86.79 ± 0.1% | 222.87 ± 6.6% | 485.15 ± 1.0% | 3882.93 ± 3.5% | 221.17 ± 0.5% | 1.00 | 1.00 | 2.55 | 0.99 |
| a UUID | 62 | 145.27 ± 0.1% | 145.59 ± 0.3% | 160.78 ± 0.2% | 45.57 ± 0.1% | 100.14 ± 6.7% | 183.10 ± 1.0% | 4425.22 ± 2.3% | 145.27 ± 0.2% | 1.00 | 1.00 | 3.19 | 1.45 |
| an IPv4 address | 29 | 435.82 ± 0.4% | 440.04 ± 0.4% | 609.76 ± 0.4% | 76.18 ± 0.9% | 132.49 ± 2.1% | 292.01 ± 0.8% | 7655.58 ± 0.4% | 434.84 ± 0.8% | 0.99 | 1.00 | 5.72 | 3.29 |
| a date and time | 56 | 318.40 ± 0.4% | 319.62 ± 0.3% | 399.77 ± 0.1% | 71.82 ± 0.3% | 137.63 ± 0.6% | 321.22 ± 0.3% | 4939.56 ± 0.4% | 318.31 ± 0.0% | 1.00 | 1.00 | 4.43 | 2.31 |
| a field path | 39 | 208.51 ± 0.6% | 209.21 ± 0.4% | 241.06 ± 0.8% | 79.33 ± 0.3% | 207.71 ± 0.6% | 485.50 ± 0.7% | 4898.78 ± 5.9% | 208.55 ± 0.5% | 1.00 | 1.00 | 2.63 | 1.00 |
| literal: a word | 7 | 658.84 ± 0.6% | 709.23 ± 0.7% | 1261.47 ± 0.8% | 506.69 ± 1.6% | 634.24 ± 2.3% | 923.58 ± 0.2% | 30692.57 ± 0.3% | 659.39 ± 0.5% | 0.93 | 1.00 | 1.30 | 1.04 |
| literal: a word that is not there | 8 | 631.24 ± 0.4% | 684.98 ± 0.4% | 1188.87 ± 0.1% | 462.60 ± 0.1% | 609.92 ± 1.1% | 876.30 ± 0.7% | 29748.15 ± 0.3% | 632.20 ± 0.2% | 0.92 | 1.00 | 1.36 | 1.03 |
| literal: one of four words | 26 | 254.08 ± 0.3% | 416.01 ± 0.4% | 562.04 ± 0.3% | 49.31 ± 0.2% | 246.76 ± 1.9% | 355.36 ± 0.2% | 15879.37 ± 0.2% | 254.31 ± 0.3% | 0.61 | 1.00 | 5.15 | 1.03 |
| literal: a word in any case | 11 | 516.48 ± 0.3% | 555.75 ± 0.2% | 859.69 ± 0.4% | 15.75 ± 0.9% | 668.18 ± 0.7% | refused | 23918.23 ± 0.3% | 516.61 ± 0.2% | 0.93 | 1.00 | 32.79 | 0.77 |
| literal: an href attribute | 12 | 351.39 ± 0.3% | 362.99 ± 0.4% | 472.86 ± 0.4% | 45.00 ± 0.5% | 509.54 ± 1.3% | 771.31 ± 2.0% | 22512.24 ± 0.1% | 351.41 ± 0.4% | 0.97 | 1.00 | 7.81 | 0.69 |
| literal: a word, second text | 10 | 586.81 ± 0.1% | 647.64 ± 0.3% | 1077.84 ± 0.1% | 409.75 ± 0.6% | 546.74 ± 4.2% | 801.89 ± 0.3% | 27660.64 ± 0.8% | 586.51 ± 0.4% | 0.91 | 1.00 | 1.43 | 1.07 |
| class: two capitalized words | 23 | 457.14 ± 0.7% | 486.35 ± 0.5% | 702.35 ± 0.7% | 100.99 ± 0.3% | 509.04 ± 0.8% | 737.88 ± 0.4% | 6646.39 ± 0.2% | 458.39 ± 0.4% | 0.94 | 1.00 | 4.53 | 0.90 |
| class: a word that ends in ing | 9 | 593.64 ± 0.3% | 661.16 ± 0.6% | 1154.73 ± 0.1% | 132.96 ± 0.9% | 764.76 ± 6.9% | 1095.07 ± 1.8% | 16328.43 ± 0.0% | 593.48 ± 0.4% | 0.90 | 1.00 | 4.46 | 0.78 |
| class: a word in capitals | 16 | 521.09 ± 0.3% | 561.23 ± 0.5% | 894.51 ± 0.3% | 135.61 ± 1.0% | 762.03 ± 1.3% | 1010.71 ± 0.5% | 8735.30 ± 0.1% | 521.71 ± 0.4% | 0.93 | 1.00 | 3.84 | 0.68 |
| class: a number | 6 | 657.22 ± 0.2% | 719.31 ± 0.2% | 1341.20 ± 0.1% | 41.81 ± 0.5% | 1417.02 ± 1.9% | 1902.73 ± 0.9% | 23350.37 ± 0.2% | 657.65 ± 0.3% | 0.91 | 1.00 | 15.72 | 0.46 |
| class: two capitalized words, second text | 23 | 458.29 ± 0.2% | 486.92 ± 0.3% | 703.02 ± 0.4% | 102.86 ± 0.3% | 509.77 ± 2.4% | 741.10 ± 0.3% | 6648.83 ± 0.1% | 457.22 ± 0.3% | 0.94 | 1.00 | 4.46 | 0.90 |
| other: a word between two words | 13 | 574.01 ± 0.1% | 591.45 ± 0.7% | 940.72 ± 0.1% | 135.88 ± 0.4% | 510.10 ± 0.7% | 812.69 ± 0.5% | 15104.01 ± 0.4% | 574.07 ± 0.2% | 0.97 | 1.00 | 4.22 | 1.13 |
| other: a number before a unit, second text | 15 | 401.20 ± 0.3% | 435.94 ± 0.8% | 601.31 ± 0.3% | 39.20 ± 0.3% | 640.29 ± 1.0% | 890.72 ± 0.8% | 15413.13 ± 0.2% | 401.82 ± 0.4% | 0.92 | 1.00 | 10.24 | 0.63 |
| other: a heading's start tag | 13 | 360.79 ± 0.2% | 364.87 ± 0.4% | 476.16 ± 0.3% | 43.41 ± 0.3% | 634.51 ± 1.3% | 859.06 ± 0.1% | 18608.64 ± 0.1% | 360.05 ± 0.2% | 0.99 | 1.00 | 8.31 | 0.57 |
| other: a whole word | 11 | 606.95 ± 0.9% | 644.44 ± 0.4% | 1073.59 ± 0.1% | 120.68 ± 0.3% | 571.09 ± 2.8% | 824.24 ± 0.6% | 27201.61 ± 1.0% | 606.37 ± 0.2% | 0.94 | 1.00 | 5.03 | 1.06 |
| other: a line's first word, second text | 17 | 553.51 ± 0.7% | 574.11 ± 0.6% | 920.70 ± 0.4% | 128.15 ± 0.2% | 723.32 ± 0.9% | refused | refused | 552.75 ± 0.7% | 0.96 | 1.00 | 4.32 | 0.77 |
| other: fourteen octets before an x | 16 | 112.91 ± 0.2% | 163.18 ± 0.2% | 186.87 ± 0.1% | 15.14 ± 0.2% | 460.52 ± 1.1% | 423.64 ± 0.8% | 12889.56 ± 0.3% | 112.81 ± 0.4% | 0.69 | 1.00 | 7.46 | 0.25 |
| other: a Greek word | 8 | 447.39 ± 0.1% | 587.06 ± 0.2% | 951.57 ± 0.0% | 57.97 ± 0.2% | 1402.67 ± 0.7% | 1786.33 ± 0.4% | refused | 446.93 ± 0.2% | 0.76 | 1.00 | 7.72 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12950.76 ± 0.7% | not timed | not timed | 16391.48 ± 3.6% | 1960.43 ± 17.3% | not timed | not timed | 12955.70 ± 0.5% | | 1.00 | 0.79 | 6.61 |
| 01-literal/sherlock-casei-en | 522 | 4506.30 ± 1.0% | not timed | not timed | 3591.16 ± 0.2% | 32.59 ± 0.3% | not timed | not timed | 4487.62 ± 0.1% | | 1.00 | 1.25 | 138.29 |
| 01-literal/sherlock-ru | 724 | 13525.34 ± 0.5% | not timed | not timed | 17335.13 ± 0.5% | 1350.83 ± 5.1% | not timed | not timed | 13538.36 ± 1.0% | | 1.00 | 0.78 | 10.01 |
| 01-literal/sherlock-casei-ru | 746 | 5295.92 ± 0.3% | not timed | not timed | 3329.22 ± 0.1% | 30.96 ± 0.9% | not timed | not timed | 5293.53 ± 0.2% | | 1.00 | 1.59 | 171.03 |
| 01-literal/sherlock-zh | 30 | 17206.30 ± 0.2% | not timed | not timed | 18887.79 ± 0.3% | 2552.33 ± 9.2% | not timed | not timed | 17193.13 ± 0.4% | | 1.00 | 0.91 | 6.74 |
| 02-literal-alternate/sherlock-en | 714 | 5758.02 ± 0.4% | not timed | not timed | 3946.60 ± 0.4% | 16.63 ± 0.3% | not timed | not timed | 5759.34 ± 0.3% | | 1.00 | 1.46 | 346.24 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1713.75 ± 1.1% | not timed | not timed | 698.07 ± 0.5% | 11.11 ± 0.4% | not timed | not timed | 1705.76 ± 0.6% | | 1.00 | 2.45 | 154.23 |
| 02-literal-alternate/sherlock-ru | 899 | 4647.45 ± 0.3% | not timed | not timed | 3255.96 ± 0.1% | 22.61 ± 5.6% | not timed | not timed | 4643.74 ± 0.3% | | 1.00 | 1.43 | 205.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1812.05 ± 0.5% | not timed | not timed | 1230.82 ± 0.5% | 8.87 ± 0.3% | not timed | not timed | 1805.15 ± 0.3% | | 1.00 | 1.47 | 204.18 |
| 02-literal-alternate/sherlock-zh | 207 | 7055.77 ± 0.6% | not timed | not timed | 4165.95 ± 0.1% | 31.50 ± 0.0% | not timed | not timed | 7057.45 ± 0.8% | | 1.00 | 1.69 | 223.99 |
| 03-date/ascii | 111817 | 127.65 ± 0.3% | not timed | not timed | 95.82 ± 0.4% | 0.21 ± 6.2% | not timed | not timed | 127.16 ± 0.4% | | 1.00 | 1.33 | 619.93 |
| 04-ruff-noqa/real | 84 | 553.22 ± 0.1% | not timed | not timed | 458.26 ± 0.1% | 19.57 ± 1.1% | not timed | not timed | 553.91 ± 0.1% | | 1.00 | 1.21 | 28.27 |
| 04-ruff-noqa/tweaked | 44 | 546.98 ± 0.1% | not timed | not timed | 443.15 ± 0.2% | 368.06 ± 0.5% | not timed | not timed | 545.26 ± 0.1% | | 1.00 | 1.23 | 1.49 |
| 05-lexer-veryl/single | 124800 | 3.97 ± 0.1% | not timed | not timed | 5.09 ± 0.2% | 0.21 ± 1.4% | not timed | not timed | 4.15 ± 0.2% | | 0.96 | 0.78 | 19.34 |
| 06-cloud-flare-redos/original | 107 | 264.11 ± 0.1% | not timed | not timed | 215.43 ± 0.0% | 24.85 ± 0.2% | not timed | not timed | 263.68 ± 0.3% | | 1.00 | 1.23 | 10.63 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.49 ± 0.1% | not timed | not timed | 228.71 ± 0.0% | 26.73 ± 0.2% | not timed | not timed | 259.43 ± 0.1% | | 1.00 | 1.13 | 9.71 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.25 ± 0.1% | not timed | not timed | 255.83 ± 0.1% | 28.79 ± 0.3% | not timed | not timed | 286.31 ± 0.2% | | 1.00 | 1.12 | 9.94 |
| 07-unicode-character-data/parse-line | 558784 | 240.03 ± 0.3% | not timed | not timed | 173.15 ± 0.2% | 43.42 ± 5.7% | not timed | not timed | 240.41 ± 1.9% | | 1.00 | 1.39 | 5.53 |
| 08-words/all-english | 56691 | 121.06 ± 0.6% | not timed | not timed | 82.82 ± 0.1% | 13.13 ± 11.6% | not timed | not timed | 120.84 ± 0.3% | | 1.00 | 1.46 | 9.22 |
| 08-words/long-english | 839 | 1006.33 ± 0.1% | not timed | not timed | 596.37 ± 0.1% | 32.55 ± 0.2% | not timed | not timed | 1006.06 ± 0.1% | | 1.00 | 1.69 | 30.92 |
| 09-aws-keys/full | 0 | 409.73 ± 0.1% | not timed | not timed | 461.71 ± 0.1% | 64.66 ± 3.4% | not timed | not timed | 409.66 ± 0.1% | | 1.00 | 0.89 | 6.34 |
| 09-aws-keys/quick | 0 | 736.25 ± 0.2% | not timed | not timed | 986.50 ± 0.4% | 423.26 ± 0.5% | not timed | not timed | 732.98 ± 0.1% | | 1.00 | 0.75 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 637.93 ± 0.3% | not timed | not timed | 517.41 ± 0.7% | 19.48 ± 0.6% | not timed | not timed | 637.61 ± 0.2% | | 1.00 | 1.23 | 32.75 |
| 10-bounded-repeat/letters-ru | 3475 | 385.34 ± 0.2% | not timed | not timed | 476.79 ± 0.2% | 22.10 ± 9.1% | not timed | not timed | 382.63 ± 1.5% | | 1.01 | 0.81 | 17.43 |
| 10-bounded-repeat/context | 53 | 79.31 ± 1.1% | not timed | not timed | 66.27 ± 0.4% | 19.84 ± 0.1% | not timed | not timed | 79.26 ± 1.3% | | 1.00 | 1.20 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1042.24 ± 0.1% | not timed | not timed | 616.89 ± 0.1% | 35.50 ± 0.2% | not timed | not timed | 1041.98 ± 0.1% | | 1.00 | 1.69 | 29.36 |
| 11-unstructured-to-json/extract | 600 | 49.72 ± 0.2% | not timed | not timed | 77.97 ± 0.2% | 49.03 ± 0.4% | not timed | not timed | 49.47 ± 0.8% | | 1.00 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 566.73 ± 0.9% | not timed | not timed | 561.77 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 567.10 ± 0.7% | | 1.00 | 1.01 | 1391.43 |
| 14-quadratic/1x | 100 | 9.68 ± 0.4% | not timed | not timed | 10.06 ± 0.3% | 0.97 ± 3.0% | not timed | not timed | 9.66 ± 1.1% | | 1.00 | 0.96 | 10.00 |
| 14-quadratic/2x | 200 | 5.57 ± 0.2% | not timed | not timed | 5.52 ± 0.1% | 0.54 ± 1.3% | not timed | not timed | 5.57 ± 1.2% | | 1.00 | 1.01 | 10.41 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 1.26 ± 0.6% | | 1.00 | 1.04 | 10.93 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.3% | not timed | not timed | 0.35 ± 1.0% | 0.56 ± 5.2% | not timed | not timed | 1.55 ± 0.8% | | 1.00 | 4.48 | 2.76 |
| 04-ruff-noqa/compile-real | 1 | 87.02 ± 1.4% | not timed | not timed | 13.81 ± 0.2% | 141.82 ± 2.3% | not timed | not timed | 86.82 ± 1.1% | | 1.00 | 6.30 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.33 ± 0.3% | not timed | not timed | 2.54 ± 1.0% | 6.54 ± 2.0% | not timed | not timed | 14.29 ± 1.1% | | 1.00 | 5.64 | 2.19 |
| 07-unicode-character-data/compile | 1 | 55.47 ± 0.1% | not timed | not timed | 26.09 ± 0.3% | 36.65 ± 3.0% | not timed | not timed | 55.42 ± 0.2% | | 1.00 | 2.13 | 1.51 |
| 09-aws-keys/compile-full | 1 | 42.46 ± 1.3% | not timed | not timed | 8.29 ± 0.2% | 23.73 ± 1.2% | not timed | not timed | 42.30 ± 0.3% | | 1.00 | 5.12 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 189.10 ± 0.1% | not timed | not timed | 47.01 ± 0.2% | 136.74 ± 17.3% | not timed | not timed | 189.35 ± 0.4% | | 1.00 | 4.02 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.69 ± 0.6% | not timed | not timed | 11.17 ± 0.4% | 16.38 ± 1.9% | not timed | not timed | 14.58 ± 1.3% | | 1.01 | 1.32 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.08 ± 0.3% | not timed | not timed | 8.11 ± 0.2% | 24.13 ± 1.8% | not timed | not timed | 84.57 ± 0.5% | | 1.01 | 10.49 | 3.53 |
| 11-unstructured-to-json/compile | 1 | 86.75 ± 0.2% | not timed | not timed | 41.32 ± 0.1% | 68.56 ± 2.1% | not timed | not timed | 86.29 ± 1.2% | | 1.01 | 2.10 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 18.4% | not timed | not timed | 0.35 ± 1.3% | | 1.01 | 5.12 | 3.60 |

