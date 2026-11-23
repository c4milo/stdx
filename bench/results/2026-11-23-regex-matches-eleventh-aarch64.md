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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127359545 |
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
| literal: a word | 217 | 16133.83 ± 1.4% | 1039.00 ± 0.2% | 28.70 ± 0.3% | 18262.85 ± 2.0% | 9226.96 ± 8.3% | 17.62 ± 0.5% | 86.10 ± 0.1% | 16094.00 ± 1.6% | 15.53 | 1.00 | 0.88 | 1.75 |
| literal: a word that is not there | 0 | 18672.31 ± 0.9% | 1047.27 ± 0.1% | 28.72 ± 0.4% | 19738.06 ± 2.1% | 28801.49 ± 1.5% | 17.45 ± 0.2% | 81.91 ± 0.2% | 18653.86 ± 1.1% | 17.83 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6079.39 ± 0.4% | 1020.70 ± 0.1% | 14.77 ± 0.2% | 3949.41 ± 0.4% | 21.91 ± 0.1% | 5.32 ± 0.1% | 6.72 ± 0.5% | 6063.58 ± 0.2% | 5.96 | 1.00 | 1.54 | 277.46 |
| literal: a word in any case | 217 | 12569.46 ± 0.9% | 1039.67 ± 0.1% | 21.77 ± 1.6% | 3971.24 ± 0.2% | 39.29 ± 4.0% | refused | differs | 12569.43 ± 0.3% | 12.09 | 1.00 | 3.17 | 319.88 |
| literal: an href attribute | 33 | 13721.75 ± 0.5% | 1046.46 ± 0.1% | 27.42 ± 0.3% | 17152.86 ± 1.2% | 2262.53 ± 0.3% | 13.12 ± 0.8% | 75.36 ± 0.2% | 13766.26 ± 0.7% | 13.11 | 1.00 | 0.80 | 6.06 |
| literal: a word, second text | 123 | 16502.19 ± 1.8% | 1042.84 ± 0.1% | 28.22 ± 0.3% | 18375.45 ± 1.7% | 7749.18 ± 6.4% | 19.46 ± 0.9% | 68.89 ± 0.3% | 16545.55 ± 0.9% | 15.82 | 1.00 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1125.85 ± 0.6% | 977.28 ± 0.1% | 26.15 ± 0.4% | 582.23 ± 0.1% | 40.55 ± 0.1% | 15.11 ± 0.2% | 68.39 ± 0.2% | 1126.85 ± 0.3% | 1.15 | 1.00 | 1.93 | 27.76 |
| class: a word that ends in ing | 3399 | 889.68 ± 0.4% | 891.16 ± 0.2% | 18.23 ± 0.2% | 545.68 ± 0.1% | 29.62 ± 1.8% | 8.23 ± 0.2% | 18.27 ± 0.2% | 889.10 ± 0.2% | 1.00 | 1.00 | 1.63 | 30.04 |
| class: a word in capitals | 2332 | 1451.54 ± 0.4% | 950.85 ± 0.2% | 27.80 ± 0.5% | 572.76 ± 0.2% | 43.49 ± 16.5% | 17.28 ± 0.3% | 83.10 ± 0.3% | 1450.83 ± 0.2% | 1.53 | 1.00 | 2.53 | 33.38 |
| class: a number | 8288 | 1992.37 ± 0.3% | 828.07 ± 0.1% | 27.99 ± 0.1% | 1713.12 ± 0.3% | 42.86 ± 7.0% | 0.52 ± 0.6% | 56.85 ± 0.3% | 1987.76 ± 0.2% | 2.41 | 1.00 | 1.16 | 46.49 |
| class: two capitalized words, second text | 5359 | 738.07 ± 0.3% | 736.25 ± 0.1% | 23.41 ± 0.1% | 485.28 ± 0.1% | 35.46 ± 8.2% | 16.94 ± 0.1% | 63.25 ± 1.1% | 737.78 ± 0.2% | 1.00 | 1.00 | 1.52 | 20.81 |
| other: a word between two words | 6104 | 761.29 ± 0.3% | 764.23 ± 0.1% | 23.63 ± 0.2% | 736.75 ± 0.1% | 108.47 ± 20.3% | 11.52 ± 0.1% | 68.87 ± 0.9% | 757.99 ± 0.3% | 1.00 | 1.00 | 1.03 | 7.02 |
| other: a number before a unit, second text | 1481 | 5511.95 ± 0.6% | 982.92 ± 0.2% | 26.06 ± 0.1% | 5678.34 ± 0.2% | 40.80 ± 0.2% | 17.91 ± 0.3% | 66.71 ± 0.4% | 5520.79 ± 0.7% | 5.61 | 1.00 | 0.97 | 135.10 |
| other: a heading's start tag | 110 | 12707.01 ± 0.7% | 1036.04 ± 0.1% | 27.68 ± 0.3% | 1712.85 ± 0.4% | 1580.12 ± 4.8% | 16.39 ± 0.5% | 88.52 ± 0.2% | 12720.85 ± 0.3% | 12.26 | 1.00 | 7.42 | 8.04 |
| other: a whole word | 217 | 13979.40 ± 0.6% | 1038.06 ± 0.2% | 29.95 ± 0.4% | 14589.55 ± 1.0% | 49.37 ± 0.5% | 13.85 ± 0.2% | 55.57 ± 0.4% | 13941.00 ± 0.8% | 13.47 | 1.00 | 0.96 | 283.15 |
| other: a line's first word, second text | 3716 | 1957.94 ± 0.6% | 862.73 ± 0.1% | 31.37 ± 0.2% | 1733.20 ± 0.4% | 62.88 ± 6.3% | refused | refused | 1936.29 ± 0.9% | 2.27 | 1.01 | 1.13 | 31.14 |
| other: fourteen octets before an x | 87 | 19493.91 ± 0.6% | 226.85 ± 0.7% | 6.15 ± 0.1% | 3958.77 ± 0.7% | 10.64 ± 0.1% | differs | 17.70 ± 0.2% | 19614.37 ± 0.6% | 85.93 | 0.99 | 4.92 | 1831.86 |
| other: a Greek word | 21815 | 470.18 ± 0.7% | 358.31 ± 0.3% | 31.16 ± 0.1% | 289.86 ± 0.1% | 48.98 ± 11.9% | differs | refused | 468.55 ± 0.6% | 1.31 | 1.00 | 1.62 | 9.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.89 ± 0.1% | 25.88 ± 0.3% | 0.82 ± 0.3% | 19.44 ± 0.2% | 2.76 ± 0.6% | differs | 4.01 ± 0.3% | 25.92 ± 0.1% | 1.00 | 1.00 | 1.33 | 9.37 |
| a UUID | 32895 | 21.02 ± 0.7% | 21.13 ± 0.7% | 0.65 ± 0.2% | 15.07 ± 0.6% | 3.09 ± 1.1% | 0.72 ± 0.3% | 3.57 ± 0.4% | 21.13 ± 0.6% | 0.99 | 0.99 | 1.39 | 6.81 |
| an IPv4 address | 33176 | 36.82 ± 0.2% | 36.86 ± 0.3% | 2.09 ± 0.4% | 29.01 ± 0.3% | 6.67 ± 0.3% | differs | 4.12 ± 0.1% | 36.97 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.52 |
| a date and time | 32954 | 31.05 ± 0.5% | 31.05 ± 0.5% | 1.42 ± 1.8% | 21.36 ± 0.5% | 7.04 ± 0.1% | 1.19 ± 0.1% | 6.87 ± 0.2% | 31.00 ± 0.2% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 29.51 ± 0.3% | 29.42 ± 0.3% | 1.01 ± 0.7% | 23.08 ± 0.1% | 3.50 ± 0.9% | differs | 2.91 ± 0.4% | 29.46 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.3% | 11.52 ± 0.4% | 11.54 ± 0.2% | 11.48 ± 0.1% | 4.87 ± 1.2% | 0.91 ± 0.5% | none | 11.40 ± 0.2% | 1.00 | 1.01 | 1.00 | 2.36 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.81 ± 0.2% | 217.43 ± 0.5% | 251.66 ± 0.2% | 87.19 ± 0.3% | 217.96 ± 8.2% | 484.97 ± 0.5% | 3756.16 ± 0.5% | 216.81 ± 0.3% | 1.00 | 1.00 | 2.49 | 0.99 |
| a UUID | 62 | 142.80 ± 0.4% | 143.09 ± 0.1% | 157.60 ± 0.2% | 46.61 ± 0.2% | 97.49 ± 1.7% | 186.98 ± 2.3% | 4482.51 ± 0.4% | 142.70 ± 0.3% | 1.00 | 1.00 | 3.06 | 1.46 |
| an IPv4 address | 29 | 436.91 ± 0.5% | 442.07 ± 0.3% | 612.27 ± 0.6% | 77.20 ± 0.7% | 130.30 ± 1.0% | 297.12 ± 0.7% | 7718.59 ± 0.4% | 437.38 ± 0.3% | 0.99 | 1.00 | 5.66 | 3.35 |
| a date and time | 56 | 318.97 ± 0.3% | 320.28 ± 0.2% | 401.64 ± 0.2% | 73.24 ± 0.4% | 135.92 ± 3.2% | 318.42 ± 0.7% | 4985.78 ± 0.3% | 318.87 ± 0.1% | 1.00 | 1.00 | 4.36 | 2.35 |
| a field path | 39 | 201.63 ± 0.2% | 202.43 ± 0.3% | 231.99 ± 0.1% | 80.89 ± 0.4% | 203.36 ± 0.9% | 504.72 ± 1.6% | 4860.52 ± 0.3% | 201.60 ± 0.4% | 1.00 | 1.00 | 2.49 | 0.99 |
| literal: a word | 7 | 662.01 ± 0.3% | 719.68 ± 0.2% | 1284.48 ± 0.3% | 518.74 ± 0.2% | 617.34 ± 1.6% | 941.95 ± 0.7% | 30923.24 ± 0.4% | 662.01 ± 0.2% | 0.92 | 1.00 | 1.28 | 1.07 |
| literal: a word that is not there | 8 | 633.35 ± 0.4% | 693.47 ± 0.7% | 1213.10 ± 0.1% | 467.67 ± 0.2% | 595.04 ± 1.6% | 894.29 ± 0.5% | 29435.49 ± 0.3% | 633.07 ± 0.2% | 0.91 | 1.00 | 1.35 | 1.06 |
| literal: one of four words | 26 | 254.84 ± 0.2% | 421.43 ± 0.2% | 568.93 ± 0.5% | 49.43 ± 0.3% | 237.25 ± 12.2% | 362.27 ± 1.6% | 15715.13 ± 0.1% | 254.65 ± 0.3% | 0.60 | 1.00 | 5.16 | 1.07 |
| literal: a word in any case | 11 | 514.65 ± 0.2% | 563.78 ± 0.1% | 864.75 ± 0.2% | 15.76 ± 0.3% | 642.69 ± 1.8% | refused | 23662.27 ± 0.5% | 514.33 ± 0.2% | 0.91 | 1.00 | 32.65 | 0.80 |
| literal: an href attribute | 12 | 349.47 ± 0.3% | 361.69 ± 0.4% | 470.62 ± 0.5% | 45.60 ± 0.7% | 496.80 ± 1.8% | 777.07 ± 0.9% | 22113.24 ± 0.4% | 349.90 ± 0.4% | 0.97 | 1.00 | 7.66 | 0.70 |
| literal: a word, second text | 10 | 589.02 ± 0.4% | 656.73 ± 0.3% | 1097.07 ± 0.1% | 423.87 ± 1.0% | 534.01 ± 4.0% | 804.85 ± 0.9% | 27306.81 ± 0.2% | 588.94 ± 0.3% | 0.90 | 1.00 | 1.39 | 1.10 |
| class: two capitalized words | 23 | 458.84 ± 0.7% | 491.31 ± 0.3% | 710.88 ± 0.3% | 101.05 ± 0.2% | 495.35 ± 1.4% | 745.74 ± 0.5% | 6369.93 ± 0.1% | 459.71 ± 0.3% | 0.93 | 1.00 | 4.54 | 0.93 |
| class: a word that ends in ing | 9 | 594.92 ± 0.3% | 666.56 ± 0.4% | 1172.40 ± 0.1% | 131.68 ± 1.2% | 748.33 ± 1.2% | 1111.37 ± 2.2% | 15933.34 ± 0.1% | 594.79 ± 0.3% | 0.89 | 1.00 | 4.52 | 0.79 |
| class: a word in capitals | 16 | 521.91 ± 0.3% | 561.45 ± 0.3% | 883.22 ± 0.1% | 135.86 ± 0.5% | 742.88 ± 1.7% | 1014.47 ± 0.8% | 8374.65 ± 0.1% | 521.03 ± 0.1% | 0.93 | 1.00 | 3.84 | 0.70 |
| class: a number | 6 | 660.47 ± 0.3% | 723.70 ± 0.2% | 1336.77 ± 0.2% | 41.93 ± 0.6% | 1384.12 ± 5.6% | 1894.36 ± 2.2% | 22788.99 ± 0.1% | 660.88 ± 0.4% | 0.91 | 1.00 | 15.75 | 0.48 |
| class: two capitalized words, second text | 23 | 459.45 ± 0.2% | 491.05 ± 0.3% | 710.11 ± 0.2% | 103.81 ± 0.3% | 495.18 ± 1.2% | 733.31 ± 0.6% | 6373.00 ± 0.1% | 459.80 ± 0.5% | 0.94 | 1.00 | 4.43 | 0.93 |
| other: a word between two words | 13 | 580.16 ± 0.4% | 602.31 ± 0.4% | 957.41 ± 0.2% | 134.31 ± 1.1% | 499.27 ± 1.5% | 807.57 ± 0.4% | 14755.44 ± 0.0% | 580.84 ± 0.4% | 0.96 | 1.00 | 4.32 | 1.16 |
| other: a number before a unit, second text | 15 | 400.07 ± 0.1% | 436.42 ± 0.2% | 598.91 ± 0.5% | 39.40 ± 0.2% | 630.19 ± 1.2% | 887.50 ± 0.2% | 15282.87 ± 0.1% | 399.80 ± 0.1% | 0.92 | 1.00 | 10.15 | 0.63 |
| other: a heading's start tag | 13 | 361.44 ± 0.4% | 366.45 ± 0.3% | 477.07 ± 0.4% | 44.43 ± 0.3% | 618.19 ± 2.5% | 864.93 ± 0.3% | 18373.85 ± 0.1% | 361.30 ± 0.6% | 0.99 | 1.00 | 8.13 | 0.58 |
| other: a whole word | 11 | 610.86 ± 0.2% | 654.24 ± 0.7% | 1091.14 ± 0.1% | 121.65 ± 0.7% | 553.63 ± 1.7% | 820.16 ± 1.3% | 26955.57 ± 1.3% | 610.38 ± 0.3% | 0.93 | 1.00 | 5.02 | 1.10 |
| other: a line's first word, second text | 17 | 553.32 ± 0.2% | 578.15 ± 0.5% | 925.50 ± 0.1% | 129.55 ± 0.2% | 699.55 ± 0.9% | refused | refused | 552.00 ± 0.7% | 0.96 | 1.00 | 4.27 | 0.79 |
| other: fourteen octets before an x | 16 | 111.66 ± 0.3% | 161.04 ± 0.4% | 184.54 ± 1.4% | 15.15 ± 0.3% | 449.33 ± 1.6% | 416.61 ± 0.8% | 13034.96 ± 0.2% | 111.58 ± 0.7% | 0.69 | 1.00 | 7.37 | 0.25 |
| other: a Greek word | 8 | 449.58 ± 0.3% | 590.73 ± 0.3% | 955.92 ± 0.1% | 59.16 ± 0.4% | 1364.22 ± 2.5% | 1788.07 ± 0.5% | refused | 449.77 ± 0.4% | 0.76 | 1.00 | 7.60 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12751.69 ± 1.5% | not timed | not timed | 16176.44 ± 1.8% | 2159.31 ± 20.0% | not timed | not timed | 12736.28 ± 1.3% | | 1.00 | 0.79 | 5.91 |
| 01-literal/sherlock-casei-en | 522 | 3878.84 ± 0.6% | not timed | not timed | 3595.76 ± 0.2% | 32.53 ± 0.3% | not timed | not timed | 3875.07 ± 0.3% | | 1.00 | 1.08 | 119.25 |
| 01-literal/sherlock-ru | 724 | 13605.80 ± 0.6% | not timed | not timed | 17245.03 ± 0.9% | 1627.43 ± 9.2% | not timed | not timed | 13560.95 ± 0.5% | | 1.00 | 0.79 | 8.36 |
| 01-literal/sherlock-casei-ru | 746 | 5245.09 ± 0.3% | not timed | not timed | 3333.24 ± 0.1% | 31.34 ± 0.5% | not timed | not timed | 5254.78 ± 0.3% | | 1.00 | 1.57 | 167.37 |
| 01-literal/sherlock-zh | 30 | 16871.29 ± 0.6% | not timed | not timed | 18261.23 ± 1.0% | 2608.00 ± 6.9% | not timed | not timed | 16886.19 ± 0.6% | | 1.00 | 0.92 | 6.47 |
| 02-literal-alternate/sherlock-en | 714 | 5820.58 ± 0.2% | not timed | not timed | 3941.30 ± 0.2% | 16.60 ± 0.0% | not timed | not timed | 5818.57 ± 0.1% | | 1.00 | 1.48 | 350.66 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1670.34 ± 0.8% | not timed | not timed | 695.78 ± 0.2% | 11.13 ± 0.3% | not timed | not timed | 1662.48 ± 0.3% | | 1.00 | 2.40 | 150.05 |
| 02-literal-alternate/sherlock-ru | 899 | 4652.97 ± 0.2% | not timed | not timed | 3257.38 ± 0.2% | 22.64 ± 0.2% | not timed | not timed | 4649.42 ± 0.2% | | 1.00 | 1.43 | 205.50 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1778.84 ± 0.8% | not timed | not timed | 1232.51 ± 0.1% | 9.15 ± 0.3% | not timed | not timed | 1775.29 ± 0.1% | | 1.00 | 1.44 | 194.30 |
| 02-literal-alternate/sherlock-zh | 207 | 7056.02 ± 0.2% | not timed | not timed | 4160.00 ± 0.1% | 31.53 ± 0.1% | not timed | not timed | 7057.57 ± 0.4% | | 1.00 | 1.70 | 223.76 |
| 03-date/ascii | 111817 | 124.29 ± 0.6% | not timed | not timed | 95.63 ± 0.1% | 0.20 ± 2.4% | not timed | not timed | 124.10 ± 0.7% | | 1.00 | 1.30 | 620.76 |
| 04-ruff-noqa/real | 84 | 554.26 ± 0.1% | not timed | not timed | 460.85 ± 0.1% | 19.49 ± 1.3% | not timed | not timed | 553.81 ± 0.1% | | 1.00 | 1.20 | 28.44 |
| 04-ruff-noqa/tweaked | 44 | 543.06 ± 0.4% | not timed | not timed | 459.96 ± 0.1% | 359.80 ± 4.5% | not timed | not timed | 542.10 ± 0.3% | | 1.00 | 1.18 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.2% | not timed | not timed | 5.01 ± 0.4% | 0.20 ± 5.1% | not timed | not timed | 3.70 ± 0.7% | | 0.99 | 0.73 | 17.92 |
| 06-cloud-flare-redos/original | 107 | 270.12 ± 0.2% | not timed | not timed | 215.31 ± 0.2% | 24.86 ± 0.4% | not timed | not timed | 270.46 ± 0.1% | | 1.00 | 1.25 | 10.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 265.39 ± 0.4% | not timed | not timed | 226.58 ± 0.3% | 26.61 ± 0.3% | not timed | not timed | 264.30 ± 0.4% | | 1.00 | 1.17 | 9.97 |
| 06-cloud-flare-redos/simplified-long | 10000 | 293.79 ± 0.4% | not timed | not timed | 253.64 ± 0.2% | 28.82 ± 0.2% | not timed | not timed | 294.23 ± 0.1% | | 1.00 | 1.16 | 10.19 |
| 07-unicode-character-data/parse-line | 558784 | 242.30 ± 2.1% | not timed | not timed | 167.23 ± 0.1% | 41.90 ± 4.9% | not timed | not timed | 241.11 ± 2.4% | | 1.00 | 1.45 | 5.78 |
| 08-words/all-english | 56691 | 119.81 ± 0.4% | not timed | not timed | 82.96 ± 0.2% | 11.71 ± 4.0% | not timed | not timed | 119.60 ± 0.4% | | 1.00 | 1.44 | 10.23 |
| 08-words/long-english | 839 | 1005.64 ± 0.8% | not timed | not timed | 597.59 ± 0.1% | 32.60 ± 0.2% | not timed | not timed | 1004.71 ± 0.1% | | 1.00 | 1.68 | 30.85 |
| 09-aws-keys/full | 0 | 412.35 ± 0.2% | not timed | not timed | 463.40 ± 0.2% | 64.50 ± 0.1% | not timed | not timed | 412.48 ± 0.0% | | 1.00 | 0.89 | 6.39 |
| 09-aws-keys/quick | 0 | 724.39 ± 0.1% | not timed | not timed | 991.71 ± 0.1% | 420.00 ± 1.2% | not timed | not timed | 721.19 ± 0.0% | | 1.00 | 0.73 | 1.72 |
| 10-bounded-repeat/letters-en | 1833 | 634.84 ± 0.5% | not timed | not timed | 518.35 ± 0.8% | 19.53 ± 0.6% | not timed | not timed | 633.66 ± 0.1% | | 1.00 | 1.22 | 32.51 |
| 10-bounded-repeat/letters-ru | 3475 | 380.74 ± 0.3% | not timed | not timed | 477.57 ± 0.1% | 21.86 ± 19.0% | not timed | not timed | 379.67 ± 0.4% | | 1.00 | 0.80 | 17.42 |
| 10-bounded-repeat/context | 53 | 79.03 ± 0.9% | not timed | not timed | 65.65 ± 0.4% | 19.78 ± 0.2% | not timed | not timed | 79.07 ± 1.2% | | 1.00 | 1.20 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1045.80 ± 0.2% | not timed | not timed | 618.14 ± 0.1% | 36.56 ± 0.2% | not timed | not timed | 1045.45 ± 0.0% | | 1.00 | 1.69 | 28.61 |
| 11-unstructured-to-json/extract | 600 | 48.21 ± 0.0% | not timed | not timed | 77.40 ± 0.5% | 49.03 ± 1.7% | not timed | not timed | 47.01 ± 0.4% | | 1.03 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 572.71 ± 0.3% | not timed | not timed | 560.40 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 573.22 ± 0.1% | | 1.00 | 1.02 | 1411.04 |
| 14-quadratic/1x | 100 | 13.06 ± 0.6% | not timed | not timed | 10.03 ± 0.3% | 0.98 ± 2.5% | not timed | not timed | 13.00 ± 1.5% | | 1.00 | 1.30 | 13.34 |
| 14-quadratic/2x | 200 | 8.00 ± 0.2% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 1.7% | not timed | not timed | 6.89 ± 0.8% | | 1.16 | 1.44 | 15.01 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.5% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.9% | not timed | not timed | 1.84 ± 0.2% | | 1.01 | 1.53 | 16.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.1% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 3.2% | not timed | not timed | 1.54 ± 0.8% | | 1.00 | 4.48 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 84.82 ± 0.1% | not timed | not timed | 13.86 ± 0.1% | 139.18 ± 2.7% | not timed | not timed | 84.52 ± 0.1% | | 1.00 | 6.12 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.50 ± 0.5% | not timed | not timed | 2.51 ± 0.4% | 6.49 ± 1.7% | not timed | not timed | 14.46 ± 0.7% | | 1.00 | 5.77 | 2.24 |
| 07-unicode-character-data/compile | 1 | 54.99 ± 0.2% | not timed | not timed | 26.10 ± 0.3% | 36.05 ± 2.6% | not timed | not timed | 54.83 ± 1.2% | | 1.00 | 2.11 | 1.53 |
| 09-aws-keys/compile-full | 1 | 42.09 ± 0.4% | not timed | not timed | 8.26 ± 0.4% | 23.56 ± 3.1% | not timed | not timed | 42.00 ± 0.6% | | 1.00 | 5.10 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 188.88 ± 0.1% | not timed | not timed | 47.44 ± 0.1% | 135.32 ± 4.3% | not timed | not timed | 189.33 ± 0.5% | | 1.00 | 3.98 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.50 ± 0.5% | not timed | not timed | 11.21 ± 0.3% | 15.97 ± 2.6% | not timed | not timed | 14.49 ± 1.4% | | 1.00 | 1.29 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.21 ± 1.1% | not timed | not timed | 8.14 ± 0.2% | 23.80 ± 1.5% | not timed | not timed | 84.84 ± 1.0% | | 1.00 | 10.47 | 3.58 |
| 11-unstructured-to-json/compile | 1 | 86.34 ± 1.4% | not timed | not timed | 40.73 ± 0.7% | 68.18 ± 3.1% | not timed | not timed | 85.86 ± 1.1% | | 1.01 | 2.12 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 7.3% | not timed | not timed | 0.36 ± 1.0% | | 1.01 | 5.18 | 3.68 |

