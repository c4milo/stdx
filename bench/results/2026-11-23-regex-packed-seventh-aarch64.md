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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102071050 |
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
| literal: a word | 217 | 16100.22 ± 1.5% | 1041.76 ± 0.5% | 28.60 ± 0.3% | 18274.18 ± 0.7% | 9058.47 ± 9.5% | 17.50 ± 0.4% | 86.68 ± 0.2% | 16013.64 ± 1.8% | 15.45 | 1.01 | 0.88 | 1.78 |
| literal: a word that is not there | 0 | 18828.11 ± 0.9% | 1047.09 ± 0.2% | 28.50 ± 0.4% | 19871.31 ± 2.1% | 29210.55 ± 1.5% | 17.31 ± 0.4% | 82.41 ± 0.2% | 18853.48 ± 1.1% | 17.98 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6149.66 ± 0.5% | 1021.05 ± 0.2% | 14.54 ± 0.1% | 3945.96 ± 0.1% | 21.87 ± 0.1% | 5.29 ± 0.1% | 6.91 ± 0.5% | 6132.18 ± 0.4% | 6.02 | 1.00 | 1.56 | 281.18 |
| literal: a word in any case | 217 | 12530.04 ± 0.5% | 1039.53 ± 0.1% | 21.72 ± 0.3% | 3960.89 ± 0.2% | 37.97 ± 0.4% | refused | differs | 12530.31 ± 1.0% | 12.05 | 1.00 | 3.16 | 330.04 |
| literal: an href attribute | 33 | 13745.35 ± 1.0% | 1044.22 ± 0.8% | 27.11 ± 0.1% | 16738.77 ± 1.2% | 2259.83 ± 0.5% | 13.39 ± 0.1% | 75.55 ± 0.2% | 13672.69 ± 0.7% | 13.16 | 1.01 | 0.82 | 6.08 |
| literal: a word, second text | 123 | 16296.62 ± 0.4% | 1047.46 ± 0.1% | 27.96 ± 0.3% | 18110.41 ± 1.6% | 7623.61 ± 9.9% | 19.72 ± 1.4% | 69.87 ± 0.7% | 16300.02 ± 0.9% | 15.56 | 1.00 | 0.90 | 2.14 |
| class: two capitalized words | 1331 | 1102.33 ± 0.7% | 958.87 ± 0.2% | 25.91 ± 0.0% | 584.69 ± 0.1% | 40.68 ± 8.9% | 14.89 ± 0.4% | 68.87 ± 0.4% | 1100.21 ± 0.2% | 1.15 | 1.00 | 1.89 | 27.10 |
| class: a word that ends in ing | 3399 | 879.43 ± 0.1% | 881.30 ± 0.2% | 17.94 ± 0.2% | 546.97 ± 0.1% | 29.63 ± 6.7% | 8.21 ± 0.5% | 18.43 ± 0.7% | 879.06 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.68 |
| class: a word in capitals | 2332 | 1465.73 ± 0.3% | 945.23 ± 0.1% | 27.59 ± 0.2% | 572.27 ± 0.3% | 43.38 ± 6.8% | 17.15 ± 0.2% | 83.03 ± 1.5% | 1468.41 ± 0.6% | 1.55 | 1.00 | 2.56 | 33.79 |
| class: a number | 8288 | 2052.14 ± 0.4% | 792.62 ± 0.2% | 27.76 ± 0.3% | 1722.16 ± 0.2% | 42.96 ± 5.7% | 0.56 ± 0.0% | 56.69 ± 1.0% | 2035.00 ± 0.7% | 2.59 | 1.01 | 1.19 | 47.77 |
| class: two capitalized words, second text | 5359 | 688.58 ± 0.2% | 686.97 ± 0.1% | 23.15 ± 0.1% | 484.23 ± 0.2% | 35.33 ± 13.3% | 16.70 ± 0.2% | 63.99 ± 0.2% | 688.51 ± 0.2% | 1.00 | 1.00 | 1.42 | 19.49 |
| other: a word between two words | 6104 | 775.65 ± 0.1% | 743.48 ± 0.3% | 23.37 ± 0.1% | 733.65 ± 0.1% | 109.81 ± 22.2% | 11.31 ± 0.1% | 69.75 ± 0.2% | 775.26 ± 0.1% | 1.04 | 1.00 | 1.06 | 7.06 |
| other: a number before a unit, second text | 1481 | 5415.88 ± 0.8% | 977.49 ± 0.2% | 25.80 ± 0.1% | 5623.29 ± 0.6% | 40.73 ± 0.2% | 17.80 ± 0.3% | 66.90 ± 0.2% | 5411.37 ± 1.6% | 5.54 | 1.00 | 0.96 | 132.98 |
| other: a heading's start tag | 110 | 12684.19 ± 1.9% | 1029.44 ± 0.2% | 27.22 ± 0.2% | 1706.26 ± 0.3% | 1577.32 ± 4.3% | 16.28 ± 0.6% | 88.94 ± 0.3% | 12611.37 ± 0.5% | 12.32 | 1.01 | 7.43 | 8.04 |
| other: a whole word | 217 | 14004.84 ± 1.4% | 1040.49 ± 0.3% | 29.46 ± 0.8% | 14557.93 ± 1.0% | 49.21 ± 0.6% | 13.56 ± 0.2% | 55.53 ± 0.9% | 13974.44 ± 2.0% | 13.46 | 1.00 | 0.96 | 284.59 |
| other: a line's first word, second text | 3716 | 1946.99 ± 0.9% | 855.77 ± 0.2% | 31.11 ± 0.1% | 1721.37 ± 0.3% | 62.74 ± 6.4% | refused | refused | 1937.23 ± 0.9% | 2.28 | 1.01 | 1.13 | 31.03 |
| other: fourteen octets before an x | 87 | 19651.91 ± 2.2% | 233.58 ± 0.6% | 5.31 ± 0.1% | 3974.73 ± 1.7% | 10.64 ± 0.1% | differs | 17.72 ± 0.1% | 19637.63 ± 0.8% | 84.13 | 1.00 | 4.94 | 1846.74 |
| other: a Greek word | 21815 | 470.02 ± 0.5% | 315.80 ± 0.2% | 30.66 ± 0.2% | 289.49 ± 0.3% | 49.44 ± 16.9% | differs | refused | 467.74 ± 0.8% | 1.49 | 1.00 | 1.62 | 9.51 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.02 ± 0.2% | 26.01 ± 0.2% | 0.82 ± 0.2% | 19.72 ± 0.7% | 2.77 ± 0.3% | differs | 3.99 ± 0.7% | 25.86 ± 0.2% | 1.00 | 1.01 | 1.32 | 9.40 |
| a UUID | 32895 | 21.19 ± 0.1% | 21.29 ± 0.1% | 0.64 ± 0.2% | 15.09 ± 0.7% | 3.11 ± 1.0% | 0.72 ± 0.3% | 3.58 ± 0.6% | 21.22 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.82 |
| an IPv4 address | 33176 | 36.77 ± 0.1% | 36.68 ± 0.4% | 2.08 ± 0.2% | 28.76 ± 0.6% | 6.64 ± 0.3% | differs | 4.12 ± 0.3% | 36.75 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.54 |
| a date and time | 32954 | 31.09 ± 0.4% | 31.18 ± 0.6% | 1.44 ± 0.4% | 21.10 ± 0.9% | 7.05 ± 0.2% | 1.20 ± 0.1% | 7.09 ± 0.2% | 31.12 ± 0.6% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.25 ± 0.1% | 29.42 ± 0.2% | 0.97 ± 0.1% | 22.95 ± 0.5% | 3.50 ± 1.5% | differs | 2.95 ± 0.2% | 29.30 ± 0.3% | 0.99 | 1.00 | 1.27 | 8.35 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.83 ± 0.3% | 8.88 ± 0.5% | 8.84 ± 0.5% | 11.50 ± 0.2% | 4.88 ± 2.6% | 0.91 ± 0.7% | none | 8.88 ± 0.2% | 0.99 | 0.99 | 0.77 | 1.81 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.08 ± 0.4% | 218.06 ± 0.2% | 252.53 ± 0.3% | 86.36 ± 0.4% | 205.99 ± 2.3% | 481.44 ± 1.0% | 3878.20 ± 1.1% | 217.44 ± 0.3% | 1.00 | 1.00 | 2.51 | 1.05 |
| a UUID | 62 | 142.61 ± 0.4% | 142.84 ± 0.1% | 157.40 ± 0.2% | 46.32 ± 0.6% | 94.65 ± 1.9% | 189.97 ± 3.1% | 4258.67 ± 0.7% | 142.48 ± 0.1% | 1.00 | 1.00 | 3.08 | 1.51 |
| an IPv4 address | 29 | 437.91 ± 0.7% | 440.75 ± 0.2% | 615.78 ± 0.7% | 76.43 ± 0.3% | 122.28 ± 10.4% | 302.04 ± 1.9% | 7620.92 ± 0.3% | 436.98 ± 0.6% | 0.99 | 1.00 | 5.73 | 3.58 |
| a date and time | 56 | 318.73 ± 0.2% | 319.85 ± 0.4% | 402.03 ± 0.5% | 72.53 ± 0.5% | 125.79 ± 10.4% | 323.49 ± 1.5% | 4880.24 ± 0.6% | 318.49 ± 0.0% | 1.00 | 1.00 | 4.39 | 2.53 |
| a field path | 39 | 202.58 ± 0.2% | 202.89 ± 0.2% | 233.20 ± 0.1% | 80.22 ± 1.2% | 190.05 ± 6.2% | 497.69 ± 3.0% | 4949.78 ± 4.3% | 202.54 ± 0.2% | 1.00 | 1.00 | 2.53 | 1.07 |
| literal: a word | 7 | 666.65 ± 0.7% | 718.07 ± 0.9% | 1292.86 ± 0.7% | 512.90 ± 0.3% | 573.40 ± 7.8% | 952.64 ± 0.7% | 31079.51 ± 0.2% | 666.50 ± 0.2% | 0.93 | 1.00 | 1.30 | 1.16 |
| literal: a word that is not there | 8 | 633.53 ± 0.5% | 690.74 ± 0.6% | 1213.12 ± 0.6% | 468.96 ± 0.3% | 567.35 ± 5.5% | 902.14 ± 0.3% | 29511.90 ± 0.1% | 633.99 ± 0.5% | 0.92 | 1.00 | 1.35 | 1.12 |
| literal: one of four words | 26 | 255.57 ± 0.2% | 420.63 ± 0.4% | 571.49 ± 0.4% | 49.83 ± 1.0% | 232.70 ± 6.7% | 372.26 ± 1.5% | 15820.76 ± 0.1% | 255.80 ± 0.5% | 0.61 | 1.00 | 5.13 | 1.10 |
| literal: a word in any case | 11 | 518.63 ± 0.2% | 558.99 ± 0.3% | 867.16 ± 0.4% | 15.84 ± 1.7% | 621.01 ± 4.3% | refused | 23674.16 ± 0.6% | 518.07 ± 0.1% | 0.93 | 1.00 | 32.75 | 0.84 |
| literal: an href attribute | 12 | 351.35 ± 0.4% | 361.84 ± 0.6% | 473.36 ± 0.3% | 45.40 ± 0.6% | 476.88 ± 10.0% | 767.37 ± 1.5% | 22283.45 ± 0.1% | 351.34 ± 0.3% | 0.97 | 1.00 | 7.74 | 0.74 |
| literal: a word, second text | 10 | 590.81 ± 0.5% | 651.98 ± 0.8% | 1094.29 ± 0.6% | 393.64 ± 0.2% | 518.82 ± 3.1% | 797.07 ± 0.7% | 27517.80 ± 0.2% | 592.28 ± 0.2% | 0.91 | 1.00 | 1.50 | 1.14 |
| class: two capitalized words | 23 | 455.06 ± 0.6% | 483.79 ± 0.6% | 700.08 ± 0.4% | 99.06 ± 0.2% | 484.44 ± 4.3% | 738.28 ± 0.4% | 6404.76 ± 0.2% | 455.43 ± 0.2% | 0.94 | 1.00 | 4.59 | 0.94 |
| class: a word that ends in ing | 9 | 597.88 ± 0.4% | 668.88 ± 0.4% | 1179.44 ± 0.4% | 131.05 ± 1.9% | 742.70 ± 4.9% | 1099.55 ± 0.6% | 16296.59 ± 0.1% | 596.47 ± 0.6% | 0.89 | 1.00 | 4.56 | 0.81 |
| class: a word in capitals | 16 | 515.41 ± 0.2% | 550.87 ± 0.6% | 866.12 ± 1.1% | 134.43 ± 0.4% | 714.55 ± 4.7% | 1005.18 ± 1.0% | 8158.45 ± 0.8% | 515.35 ± 0.7% | 0.94 | 1.00 | 3.83 | 0.72 |
| class: a number | 6 | 649.06 ± 0.2% | 709.88 ± 0.4% | 1300.47 ± 0.2% | 41.66 ± 0.7% | 1349.15 ± 3.0% | 1813.69 ± 1.4% | 22440.59 ± 0.2% | 649.02 ± 0.2% | 0.91 | 1.00 | 15.58 | 0.48 |
| class: two capitalized words, second text | 23 | 455.27 ± 0.4% | 483.57 ± 0.5% | 701.04 ± 0.8% | 100.40 ± 0.5% | 477.55 ± 2.4% | 758.22 ± 0.5% | 6400.68 ± 1.3% | 455.19 ± 0.4% | 0.94 | 1.00 | 4.53 | 0.95 |
| other: a word between two words | 13 | 581.14 ± 0.5% | 603.53 ± 0.1% | 964.86 ± 0.2% | 131.51 ± 0.5% | 477.21 ± 1.9% | 811.03 ± 0.4% | 15025.07 ± 0.3% | 580.81 ± 0.1% | 0.96 | 1.00 | 4.42 | 1.22 |
| other: a number before a unit, second text | 15 | 399.57 ± 0.5% | 433.74 ± 0.7% | 596.05 ± 0.7% | 39.31 ± 0.5% | 599.96 ± 5.6% | 882.99 ± 1.0% | 15332.65 ± 0.3% | 400.46 ± 0.5% | 0.92 | 1.00 | 10.17 | 0.67 |
| other: a heading's start tag | 13 | 357.68 ± 0.3% | 362.96 ± 0.4% | 471.99 ± 0.3% | 43.71 ± 0.4% | 597.92 ± 1.8% | 876.36 ± 0.6% | 18548.93 ± 0.1% | 357.74 ± 0.3% | 0.99 | 1.00 | 8.18 | 0.60 |
| other: a whole word | 11 | 615.14 ± 0.4% | 655.22 ± 0.5% | 1098.25 ± 0.4% | 116.74 ± 0.4% | 535.32 ± 5.7% | 834.50 ± 0.8% | 26211.01 ± 0.1% | 615.29 ± 0.3% | 0.94 | 1.00 | 5.27 | 1.15 |
| other: a line's first word, second text | 17 | 547.14 ± 0.3% | 566.57 ± 0.2% | 902.92 ± 0.6% | 127.39 ± 0.2% | 666.67 ± 25.5% | refused | refused | 542.43 ± 2.0% | 0.97 | 1.01 | 4.29 | 0.82 |
| other: fourteen octets before an x | 16 | 112.48 ± 0.3% | 162.32 ± 0.6% | 185.25 ± 0.8% | 14.85 ± 0.4% | 437.92 ± 1.5% | 409.69 ± 0.7% | 12742.68 ± 0.5% | 112.74 ± 1.0% | 0.69 | 1.00 | 7.58 | 0.26 |
| other: a Greek word | 8 | 447.43 ± 0.2% | 589.13 ± 0.4% | 963.04 ± 0.5% | 58.81 ± 0.3% | 1303.90 ± 10.4% | 1738.56 ± 0.5% | refused | 447.21 ± 0.3% | 0.76 | 1.00 | 7.61 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12883.44 ± 0.6% | not timed | not timed | 16220.98 ± 1.5% | 1938.41 ± 24.4% | not timed | not timed | 12883.09 ± 0.6% | | 1.00 | 0.79 | 6.65 |
| 01-literal/sherlock-casei-en | 522 | 3940.43 ± 0.3% | not timed | not timed | 3588.60 ± 0.1% | 32.33 ± 5.4% | not timed | not timed | 3924.45 ± 0.6% | | 1.00 | 1.10 | 121.88 |
| 01-literal/sherlock-ru | 724 | 13614.01 ± 1.1% | not timed | not timed | 17201.83 ± 0.3% | 1546.21 ± 11.0% | not timed | not timed | 13594.11 ± 1.2% | | 1.00 | 0.79 | 8.80 |
| 01-literal/sherlock-casei-ru | 746 | 5389.84 ± 0.2% | not timed | not timed | 3328.76 ± 0.2% | 30.63 ± 9.7% | not timed | not timed | 5373.69 ± 0.3% | | 1.00 | 1.62 | 175.94 |
| 01-literal/sherlock-zh | 30 | 17017.86 ± 0.4% | not timed | not timed | 18441.37 ± 0.6% | 2783.80 ± 8.7% | not timed | not timed | 17009.76 ± 0.4% | | 1.00 | 0.92 | 6.11 |
| 02-literal-alternate/sherlock-en | 714 | 5884.38 ± 0.6% | not timed | not timed | 3925.06 ± 0.3% | 16.61 ± 6.5% | not timed | not timed | 5890.70 ± 0.9% | | 1.00 | 1.50 | 354.28 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1701.82 ± 0.8% | not timed | not timed | 697.58 ± 0.4% | 11.03 ± 0.1% | not timed | not timed | 1693.69 ± 0.3% | | 1.00 | 2.44 | 154.30 |
| 02-literal-alternate/sherlock-ru | 899 | 4783.01 ± 0.4% | not timed | not timed | 3253.10 ± 0.8% | 22.58 ± 0.1% | not timed | not timed | 4782.08 ± 0.3% | | 1.00 | 1.47 | 211.80 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1818.59 ± 0.7% | not timed | not timed | 1232.63 ± 0.2% | 9.10 ± 0.1% | not timed | not timed | 1811.36 ± 0.2% | | 1.00 | 1.48 | 199.95 |
| 02-literal-alternate/sherlock-zh | 207 | 7101.94 ± 0.6% | not timed | not timed | 4158.56 ± 0.4% | 31.47 ± 0.2% | not timed | not timed | 7086.66 ± 0.3% | | 1.00 | 1.71 | 225.64 |
| 03-date/ascii | 111817 | 124.39 ± 0.7% | not timed | not timed | 96.33 ± 0.1% | 0.20 ± 2.0% | not timed | not timed | 122.74 ± 0.4% | | 1.01 | 1.29 | 622.28 |
| 04-ruff-noqa/real | 84 | 551.66 ± 0.2% | not timed | not timed | 462.23 ± 0.1% | 19.66 ± 1.3% | not timed | not timed | 552.09 ± 0.1% | | 1.00 | 1.19 | 28.06 |
| 04-ruff-noqa/tweaked | 44 | 553.75 ± 0.1% | not timed | not timed | 459.70 ± 0.1% | 357.63 ± 4.2% | not timed | not timed | 553.08 ± 0.4% | | 1.00 | 1.20 | 1.55 |
| 05-lexer-veryl/single | 124800 | 3.72 ± 0.5% | not timed | not timed | 4.96 ± 0.1% | 0.20 ± 2.5% | not timed | not timed | 3.74 ± 0.7% | | 0.99 | 0.75 | 18.84 |
| 06-cloud-flare-redos/original | 107 | 184.13 ± 0.5% | not timed | not timed | 216.51 ± 0.1% | 24.85 ± 0.2% | not timed | not timed | 183.21 ± 0.3% | | 1.01 | 0.85 | 7.41 |
| 06-cloud-flare-redos/simplified-short | 102 | 144.32 ± 0.7% | not timed | not timed | 228.68 ± 0.2% | 26.62 ± 0.2% | not timed | not timed | 145.76 ± 0.9% | | 0.99 | 0.63 | 5.42 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.74 ± 5.7% | not timed | not timed | 255.33 ± 0.3% | 28.85 ± 0.1% | not timed | not timed | 156.77 ± 1.9% | | 1.00 | 0.61 | 5.43 |
| 07-unicode-character-data/parse-line | 558784 | 40.02 ± 0.2% | not timed | not timed | 172.44 ± 0.1% | 40.64 ± 3.6% | not timed | not timed | 39.92 ± 0.2% | | 1.00 | 0.23 | 0.98 |
| 08-words/all-english | 56691 | 103.79 ± 0.4% | not timed | not timed | 82.84 ± 0.2% | 12.50 ± 10.5% | not timed | not timed | 103.00 ± 0.4% | | 1.01 | 1.25 | 8.30 |
| 08-words/long-english | 839 | 996.63 ± 0.3% | not timed | not timed | 595.74 ± 0.1% | 32.57 ± 0.5% | not timed | not timed | 996.08 ± 0.2% | | 1.00 | 1.67 | 30.60 |
| 09-aws-keys/full | 0 | 422.14 ± 0.1% | not timed | not timed | 465.63 ± 0.1% | 64.55 ± 3.8% | not timed | not timed | 422.21 ± 0.0% | | 1.00 | 0.91 | 6.54 |
| 09-aws-keys/quick | 0 | 398.74 ± 0.1% | not timed | not timed | 937.62 ± 0.6% | 412.50 ± 3.6% | not timed | not timed | 398.47 ± 0.3% | | 1.00 | 0.43 | 0.97 |
| 10-bounded-repeat/letters-en | 1833 | 592.37 ± 0.2% | not timed | not timed | 517.17 ± 0.2% | 19.50 ± 0.7% | not timed | not timed | 591.66 ± 0.3% | | 1.00 | 1.15 | 30.38 |
| 10-bounded-repeat/letters-ru | 3475 | 404.07 ± 0.4% | not timed | not timed | 478.26 ± 0.2% | 21.78 ± 8.9% | not timed | not timed | 402.16 ± 0.5% | | 1.00 | 0.84 | 18.55 |
| 10-bounded-repeat/context | 53 | 72.58 ± 1.2% | not timed | not timed | 64.48 ± 1.6% | 19.82 ± 0.2% | not timed | not timed | 72.30 ± 0.7% | | 1.00 | 1.13 | 3.66 |
| 10-bounded-repeat/capitals | 11 | 1037.37 ± 0.1% | not timed | not timed | 615.27 ± 0.0% | 36.58 ± 0.1% | not timed | not timed | 1037.18 ± 0.1% | | 1.00 | 1.69 | 28.36 |
| 11-unstructured-to-json/extract | 600 | 24.44 ± 0.1% | not timed | not timed | 77.24 ± 0.1% | 48.68 ± 1.0% | not timed | not timed | 24.23 ± 0.9% | | 1.01 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 602.53 ± 0.4% | not timed | not timed | 557.90 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 601.73 ± 0.4% | | 1.00 | 1.08 | 1500.55 |
| 14-quadratic/1x | 100 | 12.67 ± 0.8% | not timed | not timed | 9.99 ± 0.3% | 0.97 ± 4.3% | not timed | not timed | 12.57 ± 2.0% | | 1.01 | 1.27 | 13.04 |
| 14-quadratic/2x | 200 | 7.79 ± 0.7% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 2.3% | not timed | not timed | 7.76 ± 0.5% | | 1.00 | 1.40 | 14.69 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.3% | not timed | not timed | 1.83 ± 1.3% | | 1.00 | 1.51 | 15.92 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 1.7% | not timed | not timed | 0.34 ± 1.2% | 0.53 ± 7.1% | not timed | not timed | 1.51 ± 1.8% | | 1.01 | 4.48 | 2.91 |
| 04-ruff-noqa/compile-real | 1 | 85.24 ± 0.2% | not timed | not timed | 13.92 ± 0.3% | 129.96 ± 25.4% | not timed | not timed | 84.30 ± 0.4% | | 1.01 | 6.12 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.48 ± 0.1% | not timed | not timed | 2.53 ± 0.6% | 6.21 ± 3.5% | not timed | not timed | 14.46 ± 0.4% | | 1.00 | 5.73 | 2.33 |
| 07-unicode-character-data/compile | 1 | 54.97 ± 1.8% | not timed | not timed | 25.96 ± 0.2% | 33.65 ± 4.3% | not timed | not timed | 54.96 ± 1.6% | | 1.00 | 2.12 | 1.63 |
| 09-aws-keys/compile-full | 1 | 42.16 ± 1.3% | not timed | not timed | 8.35 ± 0.4% | 21.85 ± 2.3% | not timed | not timed | 42.04 ± 0.8% | | 1.00 | 5.05 | 1.93 |
| 09-aws-keys/compile-quick | 1 | 188.90 ± 0.2% | not timed | not timed | 48.36 ± 0.3% | 123.36 ± 2.9% | not timed | not timed | 188.63 ± 0.8% | | 1.00 | 3.91 | 1.53 |
| 10-bounded-repeat/compile-context | 1 | 14.54 ± 2.5% | not timed | not timed | 11.23 ± 0.2% | 14.99 ± 7.6% | not timed | not timed | 14.49 ± 2.6% | | 1.00 | 1.29 | 0.97 |
| 10-bounded-repeat/compile-capitals | 1 | 84.41 ± 1.2% | not timed | not timed | 8.08 ± 0.2% | 22.82 ± 22.0% | not timed | not timed | 83.76 ± 1.7% | | 1.01 | 10.45 | 3.70 |
| 11-unstructured-to-json/compile | 1 | 86.55 ± 0.3% | not timed | not timed | 40.50 ± 0.6% | 63.30 ± 18.9% | not timed | not timed | 86.27 ± 1.4% | | 1.00 | 2.14 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.06 ± 15.1% | 0.09 ± 12.0% | not timed | not timed | 0.35 ± 1.9% | | 1.02 | 5.57 | 4.00 |

