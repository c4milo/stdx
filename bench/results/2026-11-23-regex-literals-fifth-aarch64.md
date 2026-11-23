# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243478352 |
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
| literal: a word | 217 | 19227.03 ± 1.5% | 4992.31 ± 0.1% | 28.37 ± 0.5% | 18052.64 ± 1.6% | 9192.58 ± 10.0% | 17.40 ± 0.3% | 84.31 ± 0.5% | 19123.70 ± 1.8% | 3.85 | 1.01 | 1.07 | 2.09 |
| literal: a word that is not there | 0 | 21415.64 ± 1.9% | 4869.31 ± 0.3% | 28.36 ± 0.1% | 19512.00 ± 2.0% | 28578.61 ± 1.6% | 17.17 ± 0.4% | 79.76 ± 1.6% | 21524.79 ± 2.5% | 4.40 | 0.99 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6365.49 ± 0.5% | 1932.03 ± 0.3% | 14.44 ± 0.1% | 3942.29 ± 0.2% | 21.90 ± 0.1% | 5.47 ± 0.2% | 6.86 ± 1.2% | 6349.36 ± 0.2% | 3.29 | 1.00 | 1.61 | 290.60 |
| literal: a word in any case | 217 | 15161.17 ± 0.6% | 2073.38 ± 0.3% | 21.44 ± 0.3% | 3965.99 ± 0.1% | 38.05 ± 0.2% | refused | differs | 15078.86 ± 0.6% | 7.31 | 1.01 | 3.82 | 398.49 |
| literal: an href attribute | 33 | 16706.69 ± 2.4% | 609.16 ± 0.2% | 27.34 ± 0.5% | 16965.67 ± 1.0% | 2251.79 ± 0.4% | 13.14 ± 0.1% | 74.14 ± 0.3% | 16828.28 ± 1.9% | 27.43 | 0.99 | 0.98 | 7.42 |
| literal: a word, second text | 123 | 19385.89 ± 3.7% | 3346.49 ± 0.1% | 28.08 ± 0.2% | 18192.66 ± 3.1% | 7497.03 ± 11.8% | 20.13 ± 0.7% | 70.33 ± 0.4% | 19536.94 ± 3.0% | 5.79 | 0.99 | 1.07 | 2.59 |
| class: two capitalized words | 1331 | 1055.13 ± 0.3% | 600.17 ± 0.3% | 26.02 ± 0.5% | 585.14 ± 0.1% | 40.60 ± 10.5% | 14.77 ± 0.4% | 67.24 ± 0.6% | 1056.23 ± 0.1% | 1.76 | 1.00 | 1.80 | 25.99 |
| class: a word that ends in ing | 3399 | 573.25 ± 0.1% | 572.95 ± 0.4% | 17.98 ± 0.4% | 547.75 ± 0.1% | 29.56 ± 2.9% | 8.21 ± 0.2% | 18.25 ± 0.3% | 573.46 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.40 |
| class: a word in capitals | 2332 | 1371.41 ± 0.2% | 603.56 ± 0.2% | 27.64 ± 0.6% | 572.51 ± 0.1% | 43.48 ± 6.6% | 17.20 ± 0.2% | 82.71 ± 0.4% | 1368.34 ± 0.2% | 2.27 | 1.00 | 2.40 | 31.54 |
| class: a number | 8288 | 1956.99 ± 0.2% | 827.45 ± 0.1% | 27.89 ± 0.2% | 1711.72 ± 0.1% | 39.27 ± 15.7% | 0.54 ± 0.4% | 57.84 ± 0.3% | 1955.60 ± 0.3% | 2.37 | 1.00 | 1.14 | 49.84 |
| class: two capitalized words, second text | 5359 | 515.60 ± 0.4% | 523.83 ± 0.4% | 23.33 ± 0.2% | 484.63 ± 0.3% | 34.27 ± 14.7% | 17.11 ± 0.2% | 62.73 ± 0.4% | 515.65 ± 0.1% | 0.98 | 1.00 | 1.06 | 15.05 |
| other: a word between two words | 6104 | 789.89 ± 0.3% | 593.83 ± 0.2% | 23.53 ± 0.3% | 737.96 ± 0.1% | 111.99 ± 11.5% | 11.18 ± 0.1% | 68.20 ± 0.1% | 790.77 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.05 |
| other: a number before a unit, second text | 1481 | 5963.84 ± 0.9% | 1120.43 ± 0.4% | 26.12 ± 0.1% | 5659.57 ± 0.5% | 40.76 ± 0.2% | 18.23 ± 0.0% | 65.66 ± 0.9% | 5903.71 ± 0.5% | 5.32 | 1.01 | 1.05 | 146.32 |
| other: a heading's start tag | 110 | 14130.24 ± 2.7% | 742.84 ± 0.2% | 27.52 ± 0.6% | 1711.63 ± 0.1% | 1582.67 ± 1.2% | 16.10 ± 0.3% | 86.11 ± 1.7% | 14227.63 ± 1.0% | 19.02 | 0.99 | 8.26 | 8.93 |
| other: a whole word | 217 | 15896.00 ± 0.4% | 598.47 ± 1.1% | 29.40 ± 0.5% | 14419.85 ± 0.6% | 49.42 ± 0.2% | 13.38 ± 0.1% | 55.08 ± 0.5% | 15850.96 ± 0.8% | 26.56 | 1.00 | 1.10 | 321.62 |
| other: a line's first word, second text | 3716 | 2045.51 ± 0.8% | 587.72 ± 0.2% | 31.09 ± 0.2% | 1717.89 ± 0.4% | 62.19 ± 8.4% | refused | refused | 2039.71 ± 0.5% | 3.48 | 1.00 | 1.19 | 32.89 |
| other: fourteen octets before an x | 87 | 23826.53 ± 2.2% | 234.45 ± 0.8% | 6.55 ± 0.1% | 4023.89 ± 0.6% | 10.65 ± 0.1% | differs | 17.75 ± 0.2% | 23858.01 ± 1.5% | 101.63 | 1.00 | 5.92 | 2236.55 |
| other: a Greek word | 21815 | 485.86 ± 0.4% | 408.08 ± 0.3% | 30.91 ± 0.6% | 289.81 ± 0.4% | 49.73 ± 16.7% | differs | refused | 485.58 ± 0.4% | 1.19 | 1.00 | 1.68 | 9.77 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.42 ± 0.1% | 18.46 ± 0.2% | 0.86 ± 0.3% | 19.85 ± 0.2% | 2.78 ± 0.3% | differs | 4.00 ± 0.1% | 18.46 ± 0.1% | 1.00 | 1.00 | 0.93 | 6.62 |
| a UUID | 32895 | 20.09 ± 0.3% | 20.07 ± 0.3% | 0.64 ± 0.1% | 15.19 ± 0.5% | 3.11 ± 0.1% | 0.73 ± 0.2% | 3.64 ± 0.5% | 19.96 ± 0.2% | 1.00 | 1.01 | 1.32 | 6.47 |
| an IPv4 address | 33176 | 33.54 ± 0.1% | 33.61 ± 0.1% | 2.07 ± 0.3% | 29.36 ± 0.2% | 6.61 ± 0.2% | differs | 4.16 ± 0.2% | 33.60 ± 0.4% | 1.00 | 1.00 | 1.14 | 5.08 |
| a date and time | 32954 | 28.85 ± 0.3% | 28.85 ± 0.2% | 1.43 ± 0.1% | 21.54 ± 0.8% | 6.99 ± 0.4% | 1.25 ± 0.2% | 7.22 ± 0.6% | 28.82 ± 0.1% | 1.00 | 1.00 | 1.34 | 4.12 |
| a field path | 32606 | 21.78 ± 0.3% | 21.75 ± 0.3% | 1.02 ± 0.2% | 23.23 ± 0.5% | 3.50 ± 0.5% | differs | 2.94 ± 0.3% | 21.74 ± 0.3% | 1.00 | 1.00 | 0.94 | 6.22 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.1% | 11.12 ± 0.2% | 11.10 ± 0.1% | 11.71 ± 0.3% | 4.91 ± 2.6% | 0.94 ± 0.6% | none | 11.11 ± 0.4% | 1.00 | 1.00 | 0.95 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.21 ± 0.4% | 234.19 ± 0.2% | 274.97 ± 0.3% | 86.69 ± 0.8% | 216.82 ± 1.6% | 483.73 ± 0.4% | 3831.40 ± 4.4% | 233.18 ± 0.2% | 1.00 | 1.00 | 2.69 | 1.08 |
| a UUID | 62 | 152.02 ± 0.4% | 152.41 ± 0.2% | 169.37 ± 0.1% | 45.77 ± 0.9% | 98.15 ± 3.0% | 187.27 ± 1.8% | 4303.02 ± 0.5% | 152.08 ± 0.2% | 1.00 | 1.00 | 3.32 | 1.55 |
| an IPv4 address | 29 | 427.60 ± 0.2% | 431.15 ± 0.1% | 593.14 ± 0.4% | 77.86 ± 0.2% | 127.96 ± 2.4% | 296.70 ± 1.1% | 7636.77 ± 0.4% | 427.38 ± 0.7% | 0.99 | 1.00 | 5.49 | 3.34 |
| a date and time | 56 | 306.24 ± 0.2% | 307.98 ± 0.1% | 382.43 ± 0.2% | 73.65 ± 1.2% | 129.32 ± 19.1% | 327.29 ± 1.2% | 4956.09 ± 0.2% | 306.11 ± 0.2% | 0.99 | 1.00 | 4.16 | 2.37 |
| a field path | 39 | 227.89 ± 0.4% | 229.19 ± 0.2% | 267.81 ± 0.4% | 79.76 ± 0.8% | 193.55 ± 2.7% | 494.49 ± 1.6% | 4863.61 ± 0.6% | 228.16 ± 0.1% | 0.99 | 1.00 | 2.86 | 1.18 |
| literal: a word | 7 | 641.60 ± 0.8% | 696.94 ± 0.6% | 1236.28 ± 0.2% | 494.75 ± 1.3% | 599.48 ± 3.6% | 956.30 ± 0.7% | 31098.50 ± 0.3% | 641.44 ± 0.6% | 0.92 | 1.00 | 1.30 | 1.07 |
| literal: a word that is not there | 8 | 617.42 ± 0.6% | 673.17 ± 0.4% | 1168.85 ± 0.2% | 450.26 ± 0.3% | 583.21 ± 3.4% | 903.81 ± 0.6% | 29546.73 ± 0.1% | 616.93 ± 0.5% | 0.92 | 1.00 | 1.37 | 1.06 |
| literal: one of four words | 26 | 247.56 ± 0.2% | 403.24 ± 0.6% | 542.34 ± 0.2% | 50.71 ± 0.1% | 233.60 ± 5.4% | 373.00 ± 1.6% | 16077.74 ± 0.2% | 247.43 ± 0.1% | 0.61 | 1.00 | 4.88 | 1.06 |
| literal: a word in any case | 11 | 451.18 ± 0.2% | 483.68 ± 0.4% | 697.91 ± 0.2% | 15.55 ± 0.1% | 628.72 ± 2.7% | refused | 23664.83 ± 0.5% | 451.06 ± 0.3% | 0.93 | 1.00 | 29.02 | 0.72 |
| literal: an href attribute | 12 | 347.04 ± 0.4% | 361.05 ± 0.3% | 468.38 ± 0.6% | 45.22 ± 0.7% | 483.46 ± 2.7% | 781.77 ± 0.2% | 22064.57 ± 0.1% | 347.46 ± 0.7% | 0.96 | 1.00 | 7.67 | 0.72 |
| literal: a word, second text | 10 | 572.95 ± 0.1% | 635.60 ± 0.4% | 1051.83 ± 0.1% | 401.92 ± 0.2% | 523.33 ± 0.5% | 792.32 ± 0.6% | 27420.98 ± 0.2% | 572.52 ± 0.4% | 0.90 | 1.00 | 1.43 | 1.09 |
| class: two capitalized words | 23 | 444.54 ± 0.1% | 474.16 ± 0.5% | 679.88 ± 0.2% | 99.44 ± 0.2% | 486.13 ± 2.8% | 750.72 ± 0.8% | 6482.22 ± 0.7% | 444.29 ± 0.5% | 0.94 | 1.00 | 4.47 | 0.91 |
| class: a word that ends in ing | 9 | 576.38 ± 0.2% | 645.22 ± 0.4% | 1114.37 ± 0.2% | 132.38 ± 1.1% | 734.13 ± 1.0% | 1114.32 ± 0.5% | 16040.49 ± 0.3% | 575.72 ± 0.2% | 0.89 | 1.00 | 4.35 | 0.79 |
| class: a word in capitals | 16 | 506.94 ± 0.2% | 546.65 ± 0.2% | 867.77 ± 0.6% | 136.00 ± 2.0% | 703.82 ± 11.2% | 1016.49 ± 0.6% | 8549.99 ± 1.1% | 507.06 ± 0.3% | 0.93 | 1.00 | 3.73 | 0.72 |
| class: a number | 6 | 645.98 ± 0.7% | 712.38 ± 0.4% | 1329.40 ± 0.1% | 42.01 ± 0.7% | 1284.44 ± 2.1% | 1863.27 ± 1.5% | 22866.43 ± 0.0% | 644.72 ± 0.5% | 0.91 | 1.00 | 15.38 | 0.50 |
| class: two capitalized words, second text | 23 | 443.80 ± 0.3% | 473.31 ± 0.4% | 678.23 ± 0.7% | 101.77 ± 0.2% | 477.50 ± 4.5% | 733.86 ± 0.4% | 6488.11 ± 0.6% | 443.78 ± 0.9% | 0.94 | 1.00 | 4.36 | 0.93 |
| other: a word between two words | 13 | 551.48 ± 0.6% | 574.60 ± 0.5% | 903.75 ± 0.5% | 130.99 ± 0.3% | 469.03 ± 4.6% | 806.44 ± 0.6% | 14903.82 ± 0.2% | 551.90 ± 0.6% | 0.96 | 1.00 | 4.21 | 1.18 |
| other: a number before a unit, second text | 15 | 404.78 ± 0.3% | 443.61 ± 0.1% | 617.77 ± 0.3% | 39.31 ± 0.3% | 605.43 ± 3.4% | 886.08 ± 0.4% | 15263.26 ± 0.4% | 404.37 ± 0.5% | 0.91 | 1.00 | 10.30 | 0.67 |
| other: a heading's start tag | 13 | 356.95 ± 0.2% | 364.19 ± 0.2% | 475.63 ± 0.3% | 43.56 ± 0.4% | 590.47 ± 1.1% | 857.46 ± 0.5% | 18362.95 ± 0.5% | 356.37 ± 0.2% | 0.98 | 1.00 | 8.19 | 0.60 |
| other: a whole word | 11 | 584.28 ± 0.2% | 626.57 ± 0.6% | 1036.15 ± 0.1% | 118.37 ± 0.1% | 540.42 ± 4.7% | 825.35 ± 0.6% | 27163.59 ± 0.5% | 584.78 ± 0.4% | 0.93 | 1.00 | 4.94 | 1.08 |
| other: a line's first word, second text | 17 | 535.14 ± 0.4% | 562.50 ± 0.3% | 886.99 ± 0.2% | 129.35 ± 0.2% | 677.95 ± 1.7% | refused | refused | 534.09 ± 0.4% | 0.95 | 1.00 | 4.14 | 0.79 |
| other: fourteen octets before an x | 16 | 108.18 ± 0.6% | 154.80 ± 0.3% | 175.70 ± 0.8% | 15.00 ± 0.3% | 434.82 ± 2.3% | 417.21 ± 0.8% | 12949.54 ± 0.5% | 107.90 ± 1.6% | 0.70 | 1.00 | 7.21 | 0.25 |
| other: a Greek word | 8 | 458.16 ± 0.2% | 611.00 ± 0.5% | 1023.80 ± 0.1% | 59.25 ± 0.3% | 1340.24 ± 3.0% | 1857.79 ± 0.3% | refused | 457.98 ± 0.2% | 0.75 | 1.00 | 7.73 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15504.72 ± 1.1% | not timed | not timed | 16089.66 ± 1.7% | 2160.02 ± 24.7% | not timed | not timed | 15420.38 ± 1.2% | | 1.01 | 0.96 | 7.18 |
| 01-literal/sherlock-casei-en | 522 | 5153.35 ± 1.0% | not timed | not timed | 3581.27 ± 0.1% | 32.52 ± 0.2% | not timed | not timed | 5162.13 ± 0.6% | | 1.00 | 1.44 | 158.48 |
| 01-literal/sherlock-ru | 724 | 17110.10 ± 0.7% | not timed | not timed | 17321.16 ± 0.3% | 1391.15 ± 9.2% | not timed | not timed | 17073.26 ± 0.4% | | 1.00 | 0.99 | 12.30 |
| 01-literal/sherlock-casei-ru | 746 | 6164.38 ± 0.1% | not timed | not timed | 3328.78 ± 0.1% | 30.89 ± 1.4% | not timed | not timed | 6160.29 ± 0.3% | | 1.00 | 1.85 | 199.57 |
| 01-literal/sherlock-zh | 30 | 19657.12 ± 1.5% | not timed | not timed | 18544.76 ± 2.1% | 2596.61 ± 16.0% | not timed | not timed | 19602.13 ± 0.8% | | 1.00 | 1.06 | 7.57 |
| 02-literal-alternate/sherlock-en | 714 | 6050.27 ± 0.4% | not timed | not timed | 3940.62 ± 0.2% | 16.61 ± 0.2% | not timed | not timed | 6039.37 ± 0.3% | | 1.00 | 1.54 | 364.34 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1937.39 ± 1.6% | not timed | not timed | 696.30 ± 0.1% | 11.11 ± 0.2% | not timed | not timed | 1927.61 ± 0.4% | | 1.01 | 2.78 | 174.33 |
| 02-literal-alternate/sherlock-ru | 899 | 5557.54 ± 0.2% | not timed | not timed | 3250.49 ± 0.1% | 22.45 ± 0.1% | not timed | not timed | 5557.22 ± 0.1% | | 1.00 | 1.71 | 247.55 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.18 ± 0.4% | not timed | not timed | 1231.60 ± 0.2% | 9.07 ± 5.2% | not timed | not timed | 2052.51 ± 0.3% | | 1.00 | 1.67 | 226.74 |
| 02-literal-alternate/sherlock-zh | 207 | 7285.62 ± 0.8% | not timed | not timed | 4164.33 ± 0.1% | 31.49 ± 0.1% | not timed | not timed | 7280.34 ± 0.6% | | 1.00 | 1.75 | 231.35 |
| 03-date/ascii | 111817 | 123.84 ± 0.8% | not timed | not timed | 96.20 ± 0.2% | 0.20 ± 1.1% | not timed | not timed | 123.01 ± 0.3% | | 1.01 | 1.29 | 611.68 |
| 04-ruff-noqa/real | 84 | 402.17 ± 0.1% | not timed | not timed | 465.43 ± 0.2% | 19.53 ± 1.4% | not timed | not timed | 402.24 ± 0.1% | | 1.00 | 0.86 | 20.60 |
| 04-ruff-noqa/tweaked | 44 | 558.00 ± 0.2% | not timed | not timed | 462.09 ± 0.1% | 364.92 ± 2.1% | not timed | not timed | 559.19 ± 0.4% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.33 ± 0.4% | not timed | not timed | 5.23 ± 0.1% | 0.20 ± 5.0% | not timed | not timed | 5.34 ± 0.4% | | 1.00 | 1.02 | 26.39 |
| 06-cloud-flare-redos/original | 107 | 415.18 ± 0.3% | not timed | not timed | 213.95 ± 0.0% | 24.48 ± 5.5% | not timed | not timed | 415.51 ± 3.3% | | 1.00 | 1.94 | 16.96 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.21 ± 1.8% | not timed | not timed | 226.99 ± 0.1% | 26.67 ± 6.1% | not timed | not timed | 411.76 ± 4.3% | | 1.00 | 1.81 | 15.42 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.80 ± 0.3% | not timed | not timed | 255.75 ± 0.3% | 28.83 ± 0.2% | not timed | not timed | 583.24 ± 0.1% | | 1.00 | 2.28 | 20.25 |
| 07-unicode-character-data/parse-line | 558784 | 231.13 ± 0.3% | not timed | not timed | 179.81 ± 0.0% | 40.67 ± 3.5% | not timed | not timed | 231.72 ± 0.8% | | 1.00 | 1.29 | 5.68 |
| 08-words/all-english | 56691 | 116.77 ± 0.9% | not timed | not timed | 83.06 ± 0.2% | 11.79 ± 9.7% | not timed | not timed | 116.59 ± 0.3% | | 1.00 | 1.41 | 9.91 |
| 08-words/long-english | 839 | 614.36 ± 0.3% | not timed | not timed | 595.82 ± 0.1% | 32.63 ± 0.3% | not timed | not timed | 614.03 ± 0.6% | | 1.00 | 1.03 | 18.83 |
| 09-aws-keys/full | 0 | 408.20 ± 0.1% | not timed | not timed | 475.11 ± 0.2% | 66.43 ± 3.5% | not timed | not timed | 408.00 ± 0.1% | | 1.00 | 0.86 | 6.15 |
| 09-aws-keys/quick | 0 | 953.44 ± 0.1% | not timed | not timed | 1000.44 ± 0.4% | 417.38 ± 0.5% | not timed | not timed | 952.56 ± 0.0% | | 1.00 | 0.95 | 2.28 |
| 10-bounded-repeat/letters-en | 1833 | 581.06 ± 1.1% | not timed | not timed | 517.42 ± 0.4% | 19.53 ± 0.5% | not timed | not timed | 578.15 ± 0.6% | | 1.01 | 1.12 | 29.75 |
| 10-bounded-repeat/letters-ru | 3475 | 508.56 ± 0.9% | not timed | not timed | 478.48 ± 0.2% | 21.80 ± 9.3% | not timed | not timed | 506.17 ± 0.6% | | 1.00 | 1.06 | 23.33 |
| 10-bounded-repeat/context | 53 | 76.42 ± 0.4% | not timed | not timed | 64.80 ± 0.9% | 19.85 ± 0.1% | not timed | not timed | 76.28 ± 0.5% | | 1.00 | 1.18 | 3.85 |
| 10-bounded-repeat/capitals | 11 | 634.62 ± 8.3% | not timed | not timed | 615.41 ± 0.1% | 35.15 ± 0.1% | not timed | not timed | 635.47 ± 8.3% | | 1.00 | 1.03 | 18.06 |
| 11-unstructured-to-json/extract | 600 | 79.33 ± 0.2% | not timed | not timed | 76.89 ± 0.3% | 48.85 ± 0.6% | not timed | not timed | 80.94 ± 0.4% | | 0.98 | 1.03 | 1.62 |
| 12-dictionary/single | 1 | 559.93 ± 0.5% | not timed | not timed | 559.14 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 559.84 ± 0.3% | | 1.00 | 1.00 | 1396.43 |
| 14-quadratic/1x | 100 | 21.21 ± 1.4% | not timed | not timed | 10.03 ± 0.1% | 0.96 ± 3.8% | not timed | not timed | 21.11 ± 2.0% | | 1.00 | 2.11 | 22.12 |
| 14-quadratic/2x | 200 | 17.55 ± 0.5% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 2.4% | not timed | not timed | 17.51 ± 0.4% | | 1.00 | 3.17 | 33.07 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.3% | not timed | not timed | 1.20 ± 0.1% | 0.12 ± 2.4% | not timed | not timed | 7.67 ± 1.8% | | 1.00 | 6.39 | 66.79 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 0.3% | not timed | not timed | 0.34 ± 0.9% | 0.53 ± 3.2% | not timed | not timed | 1.29 ± 1.0% | | 0.99 | 3.77 | 2.44 |
| 04-ruff-noqa/compile-real | 1 | 92.71 ± 0.3% | not timed | not timed | 13.69 ± 0.2% | 128.67 ± 2.2% | not timed | not timed | 92.25 ± 1.4% | | 1.00 | 6.77 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 13.89 ± 0.1% | not timed | not timed | 2.51 ± 0.4% | 6.14 ± 6.7% | not timed | not timed | 13.86 ± 1.7% | | 1.00 | 5.53 | 2.26 |
| 07-unicode-character-data/compile | 1 | 55.46 ± 0.1% | not timed | not timed | 25.83 ± 0.2% | 34.58 ± 7.5% | not timed | not timed | 55.19 ± 1.0% | | 1.00 | 2.15 | 1.60 |
| 09-aws-keys/compile-full | 1 | 41.95 ± 0.2% | not timed | not timed | 8.22 ± 0.6% | 22.54 ± 1.0% | not timed | not timed | 41.70 ± 0.6% | | 1.01 | 5.10 | 1.86 |
| 09-aws-keys/compile-quick | 1 | 188.17 ± 0.3% | not timed | not timed | 47.32 ± 0.2% | 124.27 ± 5.5% | not timed | not timed | 186.51 ± 1.6% | | 1.01 | 3.98 | 1.51 |
| 10-bounded-repeat/compile-context | 1 | 13.70 ± 0.4% | not timed | not timed | 11.08 ± 0.3% | 15.14 ± 4.1% | not timed | not timed | 13.66 ± 1.1% | | 1.00 | 1.24 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 83.11 ± 0.4% | not timed | not timed | 8.07 ± 0.1% | 23.63 ± 2.6% | not timed | not timed | 82.88 ± 2.6% | | 1.00 | 10.30 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 86.56 ± 0.3% | not timed | not timed | 41.28 ± 0.3% | 67.60 ± 2.5% | not timed | not timed | 85.87 ± 0.8% | | 1.01 | 2.10 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 1.0% | 0.10 ± 16.6% | not timed | not timed | 0.34 ± 1.0% | | 1.00 | 5.04 | 3.58 |

