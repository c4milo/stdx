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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159329785 |
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
| literal: a word | 217 | 15851.03 ± 1.4% | 1049.67 ± 0.2% | 27.95 ± 0.2% | 17970.72 ± 4.0% | 9121.82 ± 7.3% | 17.39 ± 0.2% | 87.18 ± 0.2% | 15879.54 ± 1.1% | 15.10 | 1.00 | 0.88 | 1.74 |
| literal: a word that is not there | 0 | 18494.57 ± 1.8% | 1056.29 ± 0.0% | 27.86 ± 0.2% | 19469.53 ± 2.0% | 28480.37 ± 2.0% | 17.23 ± 0.2% | 82.90 ± 0.3% | 18637.78 ± 1.4% | 17.51 | 0.99 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6075.56 ± 0.9% | 1031.30 ± 0.1% | 14.55 ± 0.2% | 3947.53 ± 0.1% | 21.88 ± 0.1% | 5.24 ± 0.1% | 6.90 ± 0.4% | 6065.41 ± 0.4% | 5.89 | 1.00 | 1.54 | 277.71 |
| literal: a word in any case | 217 | 12558.03 ± 0.4% | 1048.32 ± 0.1% | 21.42 ± 0.7% | 3972.26 ± 0.2% | 38.10 ± 0.5% | refused | differs | 12529.64 ± 0.4% | 11.98 | 1.00 | 3.16 | 329.61 |
| literal: an href attribute | 33 | 13452.95 ± 0.9% | 1054.69 ± 0.2% | 26.94 ± 0.4% | 16709.21 ± 1.1% | 2256.38 ± 0.5% | 13.29 ± 0.1% | 76.02 ± 0.1% | 13450.22 ± 1.0% | 12.76 | 1.00 | 0.81 | 5.96 |
| literal: a word, second text | 123 | 16264.61 ± 1.3% | 1050.78 ± 0.1% | 27.64 ± 0.1% | 18085.07 ± 2.1% | 7732.75 ± 6.8% | 19.70 ± 0.5% | 71.03 ± 0.5% | 16311.49 ± 1.6% | 15.48 | 1.00 | 0.90 | 2.10 |
| class: two capitalized words | 1331 | 1123.60 ± 0.7% | 979.14 ± 0.1% | 25.67 ± 0.2% | 585.72 ± 0.4% | 40.55 ± 8.0% | 14.71 ± 0.9% | 68.96 ± 0.2% | 1125.00 ± 0.8% | 1.15 | 1.00 | 1.92 | 27.71 |
| class: a word that ends in ing | 3399 | 902.31 ± 0.1% | 901.92 ± 0.1% | 17.93 ± 0.1% | 547.87 ± 0.0% | 29.62 ± 6.9% | 8.17 ± 0.2% | 18.37 ± 1.1% | 882.99 ± 0.2% | 1.00 | 1.02 | 1.65 | 30.47 |
| class: a word in capitals | 2332 | 1454.51 ± 0.6% | 956.12 ± 0.1% | 27.33 ± 0.5% | 572.59 ± 0.1% | 43.55 ± 6.4% | 17.05 ± 0.2% | 82.98 ± 0.3% | 1459.39 ± 0.6% | 1.52 | 1.00 | 2.54 | 33.39 |
| class: a number | 8288 | 2015.85 ± 0.5% | 839.63 ± 0.1% | 27.40 ± 0.3% | 1721.01 ± 0.2% | 40.31 ± 16.2% | 0.55 ± 0.2% | 56.48 ± 0.4% | 2010.30 ± 0.2% | 2.40 | 1.00 | 1.17 | 50.01 |
| class: two capitalized words, second text | 5359 | 744.04 ± 0.1% | 744.81 ± 0.1% | 23.04 ± 0.1% | 485.53 ± 0.1% | 34.25 ± 10.4% | 16.69 ± 0.2% | 64.10 ± 0.2% | 743.23 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.72 |
| other: a word between two words | 6104 | 751.69 ± 0.2% | 780.31 ± 0.2% | 23.23 ± 0.1% | 737.92 ± 0.3% | 110.24 ± 13.3% | 11.25 ± 0.2% | 70.22 ± 0.2% | 752.68 ± 0.2% | 0.96 | 1.00 | 1.02 | 6.82 |
| other: a number before a unit, second text | 1481 | 5403.12 ± 0.5% | 991.18 ± 0.1% | 25.59 ± 0.1% | 5647.97 ± 0.3% | 40.72 ± 7.6% | 17.80 ± 0.8% | 67.02 ± 0.1% | 5379.04 ± 0.6% | 5.45 | 1.00 | 0.96 | 132.68 |
| other: a heading's start tag | 110 | 12442.96 ± 1.0% | 1044.65 ± 0.1% | 27.09 ± 0.5% | 1715.55 ± 0.9% | 1578.41 ± 5.6% | 16.14 ± 0.3% | 88.88 ± 0.5% | 12459.82 ± 0.8% | 11.91 | 1.00 | 7.25 | 7.88 |
| other: a whole word | 217 | 13910.74 ± 0.7% | 1045.59 ± 0.2% | 28.96 ± 0.2% | 14317.60 ± 1.2% | 49.48 ± 0.4% | 13.42 ± 0.1% | 55.94 ± 1.2% | 13880.92 ± 1.1% | 13.30 | 1.00 | 0.97 | 281.16 |
| other: a line's first word, second text | 3716 | 1964.61 ± 1.1% | 880.02 ± 0.2% | 30.36 ± 0.2% | 1719.02 ± 0.3% | 61.70 ± 7.1% | refused | refused | 1958.33 ± 0.6% | 2.23 | 1.00 | 1.14 | 31.84 |
| other: fourteen octets before an x | 87 | 19541.99 ± 0.9% | 225.21 ± 0.2% | 6.63 ± 0.1% | 3959.55 ± 0.3% | 10.65 ± 0.3% | differs | 17.77 ± 0.1% | 19451.21 ± 0.6% | 86.77 | 1.00 | 4.94 | 1835.36 |
| other: a Greek word | 21815 | 512.09 ± 0.6% | 411.06 ± 0.3% | 30.86 ± 1.3% | 289.28 ± 0.4% | 44.38 ± 8.3% | differs | refused | 509.97 ± 0.3% | 1.25 | 1.00 | 1.77 | 11.54 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.1% | 25.88 ± 0.2% | 0.88 ± 0.2% | 19.75 ± 0.3% | 2.78 ± 0.8% | differs | 4.00 ± 0.2% | 25.86 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.30 |
| a UUID | 32895 | 21.12 ± 0.2% | 21.17 ± 0.2% | 0.65 ± 0.1% | 15.15 ± 0.5% | 3.08 ± 0.3% | 0.72 ± 0.3% | 3.59 ± 0.3% | 21.20 ± 0.4% | 1.00 | 1.00 | 1.39 | 6.86 |
| an IPv4 address | 33176 | 36.88 ± 0.5% | 36.84 ± 0.2% | 2.12 ± 0.2% | 28.82 ± 0.6% | 6.66 ± 0.2% | differs | 4.13 ± 0.6% | 36.91 ± 0.3% | 1.00 | 1.00 | 1.28 | 5.54 |
| a date and time | 32954 | 30.98 ± 0.2% | 30.56 ± 0.5% | 1.47 ± 2.5% | 21.09 ± 0.7% | 7.03 ± 0.4% | 1.20 ± 0.1% | 7.11 ± 0.3% | 31.01 ± 0.3% | 1.01 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.49 ± 0.1% | 29.44 ± 0.2% | 1.04 ± 0.2% | 23.06 ± 0.3% | 3.47 ± 1.3% | differs | 2.93 ± 0.4% | 29.01 ± 0.2% | 1.00 | 1.02 | 1.28 | 8.50 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.5% | 11.53 ± 0.3% | 11.51 ± 0.7% | 11.45 ± 0.2% | 4.98 ± 1.4% | 0.91 ± 0.5% | none | 11.51 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.31 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.95 ± 0.4% | 221.47 ± 0.4% | 258.08 ± 0.1% | 86.79 ± 0.7% | 222.88 ± 0.7% | 480.17 ± 0.8% | 3888.35 ± 0.7% | 220.98 ± 0.2% | 1.00 | 1.00 | 2.55 | 0.99 |
| a UUID | 62 | 145.50 ± 0.2% | 145.82 ± 0.2% | 160.99 ± 0.2% | 46.64 ± 0.6% | 99.69 ± 0.5% | 190.83 ± 2.6% | 4455.41 ± 1.0% | 145.32 ± 0.3% | 1.00 | 1.00 | 3.12 | 1.46 |
| an IPv4 address | 29 | 436.20 ± 1.1% | 440.98 ± 0.8% | 611.03 ± 0.4% | 77.29 ± 0.4% | 132.33 ± 1.5% | 300.49 ± 1.2% | 7667.65 ± 0.2% | 437.75 ± 0.5% | 0.99 | 1.00 | 5.64 | 3.30 |
| a date and time | 56 | 319.88 ± 0.3% | 321.39 ± 0.1% | 402.71 ± 0.2% | 73.26 ± 0.4% | 134.79 ± 22.1% | 325.35 ± 2.2% | 4941.56 ± 0.4% | 319.91 ± 0.3% | 1.00 | 1.00 | 4.37 | 2.37 |
| a field path | 39 | 208.23 ± 0.2% | 209.20 ± 0.2% | 241.47 ± 0.4% | 81.15 ± 1.2% | 205.70 ± 0.3% | 502.54 ± 3.5% | 4953.88 ± 1.7% | 208.22 ± 0.2% | 1.00 | 1.00 | 2.57 | 1.01 |
| literal: a word | 7 | 660.97 ± 0.4% | 709.92 ± 0.3% | 1254.40 ± 0.1% | 526.62 ± 0.3% | 628.62 ± 1.2% | 954.20 ± 0.5% | 30856.96 ± 0.8% | 659.71 ± 0.2% | 0.93 | 1.00 | 1.26 | 1.05 |
| literal: a word that is not there | 8 | 632.94 ± 0.2% | 685.43 ± 0.3% | 1173.26 ± 0.7% | 485.37 ± 0.1% | 605.16 ± 12.7% | 904.28 ± 0.6% | 29697.67 ± 0.3% | 633.06 ± 0.3% | 0.92 | 1.00 | 1.30 | 1.05 |
| literal: one of four words | 26 | 254.39 ± 0.1% | 416.69 ± 0.3% | 562.33 ± 0.2% | 50.21 ± 1.2% | 243.94 ± 1.8% | 373.54 ± 1.3% | 15872.55 ± 0.4% | 254.32 ± 0.3% | 0.61 | 1.00 | 5.07 | 1.04 |
| literal: a word in any case | 11 | 516.99 ± 0.3% | 557.95 ± 0.4% | 856.60 ± 0.6% | 15.88 ± 1.7% | 649.18 ± 1.4% | refused | 23865.57 ± 0.4% | 516.99 ± 0.4% | 0.93 | 1.00 | 32.56 | 0.80 |
| literal: an href attribute | 12 | 348.21 ± 0.2% | 358.90 ± 0.5% | 464.61 ± 0.5% | 45.91 ± 0.8% | 498.63 ± 3.4% | 774.69 ± 1.3% | 22494.17 ± 0.2% | 348.21 ± 0.3% | 0.97 | 1.00 | 7.58 | 0.70 |
| literal: a word, second text | 10 | 586.86 ± 0.3% | 645.59 ± 0.6% | 1071.41 ± 0.2% | 403.20 ± 0.3% | 536.53 ± 1.0% | 798.82 ± 0.6% | 27786.17 ± 0.1% | 587.07 ± 0.8% | 0.91 | 1.00 | 1.46 | 1.09 |
| class: two capitalized words | 23 | 459.26 ± 0.3% | 485.86 ± 0.4% | 704.14 ± 0.4% | 100.09 ± 0.1% | 499.47 ± 1.8% | 747.28 ± 0.3% | 6646.15 ± 0.4% | 459.34 ± 0.3% | 0.95 | 1.00 | 4.59 | 0.92 |
| class: a word that ends in ing | 9 | 594.44 ± 0.2% | 660.86 ± 0.2% | 1155.37 ± 0.4% | 132.06 ± 1.7% | 756.42 ± 0.7% | 1108.07 ± 0.5% | 16331.88 ± 0.1% | 593.44 ± 0.3% | 0.90 | 1.00 | 4.50 | 0.79 |
| class: a word in capitals | 16 | 522.62 ± 0.3% | 560.55 ± 0.3% | 897.20 ± 0.5% | 135.52 ± 0.7% | 752.19 ± 1.2% | 1025.65 ± 0.7% | 8736.32 ± 0.3% | 523.17 ± 0.4% | 0.93 | 1.00 | 3.86 | 0.69 |
| class: a number | 6 | 657.05 ± 0.3% | 716.12 ± 0.4% | 1339.27 ± 0.2% | 41.95 ± 0.5% | 1409.36 ± 0.6% | 1866.15 ± 1.6% | 23349.49 ± 0.1% | 657.70 ± 0.7% | 0.92 | 1.00 | 15.66 | 0.47 |
| class: two capitalized words, second text | 23 | 458.75 ± 0.3% | 485.97 ± 0.3% | 703.17 ± 0.4% | 101.52 ± 0.5% | 503.75 ± 1.5% | 767.67 ± 0.4% | 6650.96 ± 0.4% | 458.68 ± 0.3% | 0.94 | 1.00 | 4.52 | 0.91 |
| other: a word between two words | 13 | 573.57 ± 0.5% | 591.50 ± 0.5% | 936.08 ± 0.1% | 133.43 ± 0.7% | 498.61 ± 1.3% | 811.48 ± 0.7% | 15112.87 ± 0.1% | 573.09 ± 0.2% | 0.97 | 1.00 | 4.30 | 1.15 |
| other: a number before a unit, second text | 15 | 402.28 ± 0.2% | 437.44 ± 0.3% | 602.18 ± 0.1% | 39.65 ± 0.4% | 639.81 ± 1.8% | 895.04 ± 1.1% | 15414.43 ± 0.2% | 402.13 ± 0.2% | 0.92 | 1.00 | 10.15 | 0.63 |
| other: a heading's start tag | 13 | 360.87 ± 0.6% | 364.64 ± 0.6% | 476.62 ± 0.6% | 44.06 ± 0.4% | 628.44 ± 0.8% | 875.87 ± 1.1% | 18601.13 ± 0.3% | 360.89 ± 0.2% | 0.99 | 1.00 | 8.19 | 0.57 |
| other: a whole word | 11 | 607.33 ± 0.4% | 645.06 ± 0.4% | 1071.10 ± 0.1% | 118.63 ± 0.6% | 565.69 ± 1.1% | 837.63 ± 0.3% | 27272.03 ± 0.6% | 607.53 ± 0.4% | 0.94 | 1.00 | 5.12 | 1.07 |
| other: a line's first word, second text | 17 | 553.36 ± 0.8% | 575.02 ± 0.8% | 924.36 ± 0.4% | 129.07 ± 0.2% | 710.88 ± 1.8% | refused | refused | 551.63 ± 0.4% | 0.96 | 1.00 | 4.29 | 0.78 |
| other: fourteen octets before an x | 16 | 112.71 ± 0.5% | 163.07 ± 0.6% | 186.51 ± 0.7% | 15.26 ± 0.2% | 453.54 ± 2.8% | 413.92 ± 0.3% | 12893.46 ± 0.5% | 112.65 ± 0.5% | 0.69 | 1.00 | 7.39 | 0.25 |
| other: a Greek word | 8 | 447.54 ± 0.3% | 585.07 ± 0.4% | 952.19 ± 0.1% | 59.29 ± 0.4% | 1384.94 ± 1.0% | 1791.80 ± 0.7% | refused | 447.55 ± 0.4% | 0.76 | 1.00 | 7.55 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12795.82 ± 0.8% | not timed | not timed | 16158.42 ± 1.8% | 1960.85 ± 22.1% | not timed | not timed | 12818.96 ± 0.9% | | 1.00 | 0.79 | 6.53 |
| 01-literal/sherlock-casei-en | 522 | 4472.11 ± 1.2% | not timed | not timed | 3588.79 ± 0.2% | 32.40 ± 5.0% | not timed | not timed | 4473.00 ± 1.1% | | 1.00 | 1.25 | 138.02 |
| 01-literal/sherlock-ru | 724 | 13527.13 ± 0.5% | not timed | not timed | 17288.37 ± 0.4% | 1359.55 ± 22.4% | not timed | not timed | 13485.39 ± 1.0% | | 1.00 | 0.78 | 9.95 |
| 01-literal/sherlock-casei-ru | 746 | 5287.36 ± 0.5% | not timed | not timed | 3322.87 ± 0.1% | 31.54 ± 0.6% | not timed | not timed | 5289.78 ± 0.7% | | 1.00 | 1.59 | 167.63 |
| 01-literal/sherlock-zh | 30 | 16785.19 ± 0.7% | not timed | not timed | 18372.81 ± 1.5% | 2576.50 ± 7.3% | not timed | not timed | 16796.57 ± 0.9% | | 1.00 | 0.91 | 6.51 |
| 02-literal-alternate/sherlock-en | 714 | 5759.25 ± 0.4% | not timed | not timed | 3945.09 ± 0.2% | 16.64 ± 0.1% | not timed | not timed | 5765.98 ± 0.2% | | 1.00 | 1.46 | 346.19 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1706.16 ± 1.5% | not timed | not timed | 696.65 ± 0.4% | 11.13 ± 0.1% | not timed | not timed | 1696.74 ± 0.4% | | 1.01 | 2.45 | 153.36 |
| 02-literal-alternate/sherlock-ru | 899 | 4646.56 ± 0.2% | not timed | not timed | 3255.40 ± 0.2% | 22.61 ± 0.1% | not timed | not timed | 4642.13 ± 0.2% | | 1.00 | 1.43 | 205.54 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1804.52 ± 0.5% | not timed | not timed | 1230.74 ± 0.1% | 9.15 ± 0.1% | not timed | not timed | 1796.74 ± 0.3% | | 1.00 | 1.47 | 197.26 |
| 02-literal-alternate/sherlock-zh | 207 | 7055.09 ± 0.3% | not timed | not timed | 4164.12 ± 0.1% | 31.52 ± 0.1% | not timed | not timed | 7058.06 ± 0.2% | | 1.00 | 1.69 | 223.85 |
| 03-date/ascii | 111817 | 126.95 ± 0.1% | not timed | not timed | 96.52 ± 0.1% | 0.21 ± 5.2% | not timed | not timed | 126.24 ± 1.0% | | 1.01 | 1.32 | 616.97 |
| 04-ruff-noqa/real | 84 | 555.98 ± 0.1% | not timed | not timed | 461.72 ± 0.1% | 19.63 ± 1.1% | not timed | not timed | 556.41 ± 0.1% | | 1.00 | 1.20 | 28.32 |
| 04-ruff-noqa/tweaked | 44 | 541.27 ± 0.1% | not timed | not timed | 458.48 ± 0.1% | 368.17 ± 0.3% | not timed | not timed | 539.26 ± 0.4% | | 1.00 | 1.18 | 1.47 |
| 05-lexer-veryl/single | 124800 | 3.97 ± 0.2% | not timed | not timed | 5.11 ± 0.1% | 0.21 ± 5.2% | not timed | not timed | 4.19 ± 2.0% | | 0.95 | 0.78 | 19.22 |
| 06-cloud-flare-redos/original | 107 | 260.17 ± 0.5% | not timed | not timed | 211.67 ± 0.3% | 24.99 ± 0.3% | not timed | not timed | 260.15 ± 0.5% | | 1.00 | 1.23 | 10.41 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.62 ± 0.1% | not timed | not timed | 227.17 ± 0.1% | 26.72 ± 0.3% | not timed | not timed | 255.00 ± 0.2% | | 1.00 | 1.12 | 9.53 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.20 ± 0.1% | not timed | not timed | 255.54 ± 0.2% | 28.73 ± 0.0% | not timed | not timed | 292.30 ± 0.2% | | 1.00 | 1.14 | 10.17 |
| 07-unicode-character-data/parse-line | 558784 | 239.30 ± 4.5% | not timed | not timed | 172.87 ± 0.1% | 42.63 ± 2.4% | not timed | not timed | 239.64 ± 0.7% | | 1.00 | 1.38 | 5.61 |
| 08-words/all-english | 56691 | 121.72 ± 0.2% | not timed | not timed | 82.85 ± 0.1% | 11.94 ± 7.5% | not timed | not timed | 121.17 ± 0.4% | | 1.00 | 1.47 | 10.19 |
| 08-words/long-english | 839 | 1012.89 ± 0.2% | not timed | not timed | 597.85 ± 0.1% | 32.43 ± 0.6% | not timed | not timed | 1011.42 ± 0.1% | | 1.00 | 1.69 | 31.23 |
| 09-aws-keys/full | 0 | 409.55 ± 0.0% | not timed | not timed | 461.20 ± 0.1% | 61.46 ± 0.2% | not timed | not timed | 409.04 ± 0.0% | | 1.00 | 0.89 | 6.66 |
| 09-aws-keys/quick | 0 | 740.21 ± 0.1% | not timed | not timed | 991.38 ± 0.3% | 419.69 ± 0.4% | not timed | not timed | 737.71 ± 0.1% | | 1.00 | 0.75 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 639.06 ± 0.4% | not timed | not timed | 517.32 ± 0.6% | 19.61 ± 0.5% | not timed | not timed | 636.27 ± 0.3% | | 1.00 | 1.24 | 32.59 |
| 10-bounded-repeat/letters-ru | 3475 | 382.58 ± 0.2% | not timed | not timed | 478.69 ± 0.2% | 21.79 ± 10.6% | not timed | not timed | 381.90 ± 0.4% | | 1.00 | 0.80 | 17.55 |
| 10-bounded-repeat/context | 53 | 79.96 ± 1.0% | not timed | not timed | 65.83 ± 0.8% | 19.81 ± 0.2% | not timed | not timed | 79.92 ± 1.0% | | 1.00 | 1.21 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 1055.38 ± 0.2% | not timed | not timed | 616.60 ± 0.1% | 36.38 ± 0.1% | not timed | not timed | 1055.08 ± 0.0% | | 1.00 | 1.71 | 29.01 |
| 11-unstructured-to-json/extract | 600 | 49.37 ± 0.1% | not timed | not timed | 77.15 ± 0.1% | 48.95 ± 0.9% | not timed | not timed | 49.45 ± 1.2% | | 1.00 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 566.86 ± 0.6% | not timed | not timed | 561.09 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 569.41 ± 0.5% | | 1.00 | 1.01 | 1393.28 |
| 14-quadratic/1x | 100 | 12.83 ± 0.4% | not timed | not timed | 9.94 ± 0.2% | 0.98 ± 4.7% | not timed | not timed | 12.79 ± 1.9% | | 1.00 | 1.29 | 13.11 |
| 14-quadratic/2x | 200 | 7.96 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 7.95 ± 0.5% | | 1.00 | 1.43 | 14.97 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.8% | 0.12 ± 2.1% | not timed | not timed | 1.88 ± 0.4% | | 1.00 | 1.55 | 16.34 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.1% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 2.7% | not timed | not timed | 1.54 ± 1.0% | | 1.00 | 4.50 | 2.82 |
| 04-ruff-noqa/compile-real | 1 | 86.87 ± 0.1% | not timed | not timed | 13.95 ± 0.2% | 140.90 ± 2.9% | not timed | not timed | 86.66 ± 0.7% | | 1.00 | 6.23 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.29 ± 0.2% | not timed | not timed | 2.54 ± 0.5% | 6.49 ± 2.3% | not timed | not timed | 14.25 ± 1.4% | | 1.00 | 5.63 | 2.20 |
| 07-unicode-character-data/compile | 1 | 54.37 ± 0.4% | not timed | not timed | 26.14 ± 0.1% | 35.80 ± 2.5% | not timed | not timed | 54.41 ± 1.1% | | 1.00 | 2.08 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.15 ± 0.1% | not timed | not timed | 8.32 ± 0.3% | 23.34 ± 1.6% | not timed | not timed | 42.07 ± 1.0% | | 1.00 | 5.06 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 189.13 ± 0.3% | not timed | not timed | 47.44 ± 0.4% | 133.96 ± 1.5% | not timed | not timed | 188.24 ± 1.1% | | 1.00 | 3.99 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.72 ± 0.8% | not timed | not timed | 11.25 ± 0.1% | 16.08 ± 1.7% | not timed | not timed | 14.59 ± 1.2% | | 1.01 | 1.31 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.11 ± 0.9% | not timed | not timed | 8.13 ± 0.2% | 23.85 ± 2.4% | not timed | not timed | 84.17 ± 1.2% | | 1.01 | 10.47 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 85.20 ± 0.2% | not timed | not timed | 40.70 ± 0.3% | 68.95 ± 2.5% | not timed | not timed | 84.95 ± 0.4% | | 1.00 | 2.09 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 0.4% | 0.09 ± 8.8% | not timed | not timed | 0.35 ± 2.3% | | 1.01 | 5.06 | 3.76 |

