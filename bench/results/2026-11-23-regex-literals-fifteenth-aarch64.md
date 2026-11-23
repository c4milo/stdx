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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243543024 |
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
| literal: a word | 217 | 19767.09 ± 2.4% | 4995.51 ± 0.2% | 27.75 ± 0.1% | 18318.31 ± 1.8% | 9224.55 ± 11.4% | 17.60 ± 0.4% | 84.15 ± 0.6% | 19817.92 ± 0.9% | 3.96 | 1.00 | 1.08 | 2.14 |
| literal: a word that is not there | 0 | 21633.28 ± 1.0% | 4874.69 ± 0.2% | 27.82 ± 0.2% | 19867.32 ± 1.0% | 28952.69 ± 2.2% | 17.43 ± 0.3% | 79.84 ± 0.6% | 21650.13 ± 2.0% | 4.44 | 1.00 | 1.09 | 0.75 |
| literal: one of four words | 661 | 6384.42 ± 0.4% | 1933.92 ± 0.2% | 14.26 ± 0.1% | 3949.31 ± 0.1% | 21.89 ± 0.1% | 5.30 ± 0.5% | 6.81 ± 0.7% | 6364.56 ± 0.3% | 3.30 | 1.00 | 1.62 | 291.72 |
| literal: a word in any case | 217 | 15228.69 ± 0.7% | 2072.58 ± 0.1% | 21.12 ± 0.3% | 3965.58 ± 0.3% | 38.12 ± 0.2% | refused | differs | 15212.22 ± 0.7% | 7.35 | 1.00 | 3.84 | 399.48 |
| literal: an href attribute | 33 | 16893.46 ± 0.9% | 610.24 ± 0.2% | 26.64 ± 0.3% | 17050.01 ± 1.9% | 2265.37 ± 0.7% | 13.51 ± 0.2% | 74.00 ± 0.2% | 16812.35 ± 1.0% | 27.68 | 1.00 | 0.99 | 7.46 |
| literal: a word, second text | 123 | 19641.53 ± 3.2% | 3359.68 ± 0.4% | 27.36 ± 0.2% | 18302.72 ± 1.8% | 7682.33 ± 6.4% | 19.75 ± 0.3% | 70.25 ± 0.3% | 19911.38 ± 3.1% | 5.85 | 0.99 | 1.07 | 2.56 |
| class: two capitalized words | 1331 | 1055.89 ± 0.5% | 600.33 ± 0.5% | 25.41 ± 0.2% | 585.55 ± 0.1% | 40.57 ± 13.1% | 15.02 ± 0.2% | 67.25 ± 1.5% | 1055.56 ± 0.4% | 1.76 | 1.00 | 1.80 | 26.03 |
| class: a word that ends in ing | 3399 | 574.33 ± 0.4% | 573.89 ± 0.5% | 17.72 ± 0.4% | 547.78 ± 0.1% | 29.62 ± 2.9% | 8.26 ± 0.3% | 18.16 ± 0.2% | 574.06 ± 0.4% | 1.00 | 1.00 | 1.05 | 19.39 |
| class: a word in capitals | 2332 | 1369.26 ± 0.1% | 603.49 ± 0.4% | 26.96 ± 0.5% | 572.83 ± 0.1% | 43.53 ± 6.3% | 17.32 ± 0.4% | 82.56 ± 1.9% | 1370.18 ± 0.4% | 2.27 | 1.00 | 2.39 | 31.46 |
| class: a number | 8288 | 1947.02 ± 0.4% | 827.89 ± 0.1% | 27.25 ± 0.2% | 1713.31 ± 0.8% | 40.31 ± 15.7% | 0.57 ± 0.1% | 57.48 ± 0.5% | 1947.26 ± 0.2% | 2.35 | 1.00 | 1.14 | 48.30 |
| class: two capitalized words, second text | 5359 | 516.32 ± 0.3% | 524.38 ± 0.3% | 22.80 ± 0.1% | 485.19 ± 0.1% | 34.23 ± 10.7% | 16.72 ± 0.2% | 62.59 ± 0.5% | 515.31 ± 0.5% | 0.98 | 1.00 | 1.06 | 15.08 |
| other: a word between two words | 6104 | 797.39 ± 0.1% | 594.68 ± 0.2% | 23.02 ± 0.4% | 737.25 ± 0.2% | 109.99 ± 13.5% | 11.34 ± 0.1% | 68.20 ± 0.5% | 797.20 ± 0.1% | 1.34 | 1.00 | 1.08 | 7.25 |
| other: a number before a unit, second text | 1481 | 5973.51 ± 0.8% | 1121.20 ± 0.3% | 25.54 ± 0.4% | 5672.46 ± 0.4% | 40.80 ± 11.2% | 17.88 ± 0.2% | 65.63 ± 0.6% | 5905.80 ± 0.4% | 5.33 | 1.01 | 1.05 | 146.40 |
| other: a heading's start tag | 110 | 14127.14 ± 0.7% | 742.47 ± 0.1% | 26.83 ± 0.3% | 1720.00 ± 0.4% | 1585.61 ± 6.4% | 16.40 ± 0.3% | 86.23 ± 0.2% | 14030.47 ± 1.1% | 19.03 | 1.01 | 8.21 | 8.91 |
| other: a whole word | 217 | 16004.15 ± 1.4% | 601.06 ± 0.6% | 28.66 ± 0.8% | 14486.95 ± 0.6% | 49.43 ± 0.2% | 13.88 ± 0.1% | 54.87 ± 1.0% | 16182.71 ± 1.6% | 26.63 | 0.99 | 1.10 | 323.77 |
| other: a line's first word, second text | 3716 | 2041.22 ± 0.5% | 588.11 ± 0.1% | 30.03 ± 0.5% | 1730.17 ± 0.6% | 61.68 ± 6.7% | refused | refused | 2033.50 ± 0.5% | 3.47 | 1.00 | 1.18 | 33.09 |
| other: fourteen octets before an x | 87 | 24236.25 ± 1.2% | 239.64 ± 0.2% | 6.51 ± 0.1% | 4022.13 ± 0.5% | 10.66 ± 0.2% | differs | 17.71 ± 0.1% | 24126.85 ± 0.6% | 101.14 | 1.00 | 6.03 | 2273.74 |
| other: a Greek word | 21815 | 486.42 ± 0.4% | 409.13 ± 0.1% | 30.50 ± 0.2% | 289.69 ± 0.5% | 47.47 ± 7.2% | differs | refused | 484.28 ± 0.5% | 1.19 | 1.00 | 1.68 | 10.25 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.49 ± 0.2% | 18.52 ± 0.2% | 0.85 ± 0.7% | 19.79 ± 0.1% | 2.77 ± 1.0% | differs | 3.99 ± 0.1% | 18.52 ± 0.2% | 1.00 | 1.00 | 0.93 | 6.68 |
| a UUID | 32895 | 20.09 ± 0.2% | 20.13 ± 0.1% | 0.64 ± 0.1% | 15.15 ± 0.5% | 3.09 ± 0.7% | 0.72 ± 0.3% | 3.63 ± 0.3% | 20.12 ± 0.1% | 1.00 | 1.00 | 1.33 | 6.51 |
| an IPv4 address | 33176 | 33.60 ± 0.3% | 33.71 ± 0.4% | 2.08 ± 0.4% | 29.00 ± 0.4% | 6.62 ± 0.9% | differs | 4.14 ± 0.1% | 33.68 ± 0.2% | 1.00 | 1.00 | 1.16 | 5.08 |
| a date and time | 32954 | 28.71 ± 0.3% | 28.86 ± 0.5% | 1.44 ± 0.3% | 21.20 ± 0.4% | 7.07 ± 0.1% | 1.20 ± 0.1% | 7.13 ± 0.9% | 28.87 ± 0.3% | 0.99 | 0.99 | 1.35 | 4.06 |
| a field path | 32606 | 21.76 ± 0.2% | 21.81 ± 0.2% | 1.02 ± 0.1% | 23.00 ± 0.2% | 3.49 ± 1.2% | differs | 2.93 ± 0.2% | 21.81 ± 0.1% | 1.00 | 1.00 | 0.95 | 6.24 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.2% | 11.09 ± 0.5% | 11.08 ± 0.2% | 11.50 ± 0.1% | 4.98 ± 2.7% | 0.92 ± 0.6% | none | 11.11 ± 0.1% | 1.00 | 1.00 | 0.96 | 2.22 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.93 ± 0.2% | 221.86 ± 0.3% | 263.59 ± 0.1% | 86.16 ± 0.4% | 223.12 ± 1.5% | 476.35 ± 1.7% | 3798.86 ± 0.7% | 220.97 ± 0.1% | 1.00 | 1.00 | 2.56 | 0.99 |
| a UUID | 62 | 143.49 ± 0.3% | 143.76 ± 0.3% | 161.06 ± 0.2% | 46.21 ± 0.7% | 100.19 ± 0.4% | 186.76 ± 3.2% | 4272.86 ± 0.2% | 143.34 ± 0.3% | 1.00 | 1.00 | 3.10 | 1.43 |
| an IPv4 address | 29 | 411.71 ± 0.1% | 415.75 ± 0.3% | 594.00 ± 0.3% | 76.59 ± 0.2% | 133.04 ± 1.7% | 296.97 ± 1.9% | 7554.55 ± 0.4% | 411.76 ± 0.3% | 0.99 | 1.00 | 5.38 | 3.09 |
| a date and time | 56 | 295.38 ± 0.2% | 297.08 ± 0.4% | 376.06 ± 0.2% | 72.35 ± 0.2% | 138.11 ± 0.7% | 321.66 ± 1.0% | 4922.77 ± 0.3% | 295.24 ± 0.1% | 0.99 | 1.00 | 4.08 | 2.14 |
| a field path | 39 | 212.99 ± 0.3% | 213.66 ± 0.2% | 251.68 ± 0.1% | 80.14 ± 1.0% | 208.74 ± 1.3% | 500.60 ± 3.5% | 4831.93 ± 3.6% | 212.76 ± 0.3% | 1.00 | 1.00 | 2.66 | 1.02 |
| literal: a word | 7 | 609.97 ± 0.9% | 665.45 ± 0.7% | 1223.90 ± 0.6% | 512.50 ± 0.2% | 624.32 ± 3.8% | 946.40 ± 0.5% | 29726.61 ± 0.1% | 608.74 ± 0.7% | 0.92 | 1.00 | 1.19 | 0.98 |
| literal: a word that is not there | 8 | 593.75 ± 0.3% | 645.52 ± 0.3% | 1155.79 ± 0.1% | 470.44 ± 0.1% | 604.91 ± 1.9% | 898.01 ± 0.5% | 28555.97 ± 0.1% | 593.03 ± 0.4% | 0.92 | 1.00 | 1.26 | 0.98 |
| literal: one of four words | 26 | 237.75 ± 0.3% | 394.30 ± 0.6% | 543.63 ± 0.7% | 49.89 ± 1.3% | 244.72 ± 1.1% | 371.97 ± 1.0% | 15722.32 ± 0.2% | 237.66 ± 0.2% | 0.60 | 1.00 | 4.77 | 0.97 |
| literal: a word in any case | 11 | 434.36 ± 0.5% | 465.02 ± 0.3% | 690.48 ± 0.4% | 15.75 ± 1.4% | 650.65 ± 5.6% | refused | 23434.24 ± 0.5% | 434.46 ± 0.4% | 0.93 | 1.00 | 27.57 | 0.67 |
| literal: an href attribute | 12 | 332.77 ± 0.6% | 345.75 ± 0.4% | 459.08 ± 0.7% | 45.23 ± 0.6% | 500.27 ± 1.6% | 766.93 ± 0.5% | 21305.18 ± 0.2% | 332.65 ± 0.3% | 0.96 | 1.00 | 7.36 | 0.67 |
| literal: a word, second text | 10 | 547.35 ± 0.3% | 605.34 ± 0.2% | 1040.45 ± 0.2% | 392.36 ± 0.2% | 537.38 ± 1.0% | 796.93 ± 0.1% | 26394.85 ± 0.2% | 547.36 ± 0.3% | 0.90 | 1.00 | 1.39 | 1.02 |
| class: two capitalized words | 23 | 420.00 ± 0.5% | 455.10 ± 0.3% | 672.67 ± 0.2% | 98.90 ± 0.1% | 506.32 ± 2.2% | 735.77 ± 0.4% | 6451.81 ± 0.3% | 420.33 ± 0.3% | 0.92 | 1.00 | 4.25 | 0.83 |
| class: a word that ends in ing | 9 | 540.32 ± 0.3% | 611.86 ± 0.2% | 1104.40 ± 0.4% | 131.17 ± 1.8% | 764.71 ± 1.7% | 1088.53 ± 0.5% | 15773.84 ± 0.1% | 539.83 ± 0.2% | 0.88 | 1.00 | 4.12 | 0.71 |
| class: a word in capitals | 16 | 473.52 ± 0.1% | 519.80 ± 0.4% | 867.87 ± 0.2% | 134.30 ± 0.6% | 762.36 ± 1.1% | 1005.88 ± 1.2% | 8498.96 ± 0.2% | 473.46 ± 0.1% | 0.91 | 1.00 | 3.53 | 0.62 |
| class: a number | 6 | 596.66 ± 0.3% | 670.12 ± 0.3% | 1324.27 ± 0.1% | 41.59 ± 0.8% | 1405.49 ± 0.6% | 1874.25 ± 1.0% | 22281.23 ± 0.1% | 597.47 ± 0.2% | 0.89 | 1.00 | 14.35 | 0.42 |
| class: two capitalized words, second text | 23 | 419.97 ± 0.2% | 455.23 ± 0.1% | 672.73 ± 0.1% | 100.08 ± 0.4% | 505.53 ± 1.9% | 754.49 ± 0.4% | 6436.51 ± 1.0% | 420.39 ± 0.2% | 0.92 | 1.00 | 4.20 | 0.83 |
| other: a word between two words | 13 | 529.76 ± 0.4% | 550.94 ± 0.3% | 900.85 ± 0.5% | 132.78 ± 0.7% | 503.58 ± 1.1% | 805.27 ± 0.6% | 14654.78 ± 0.1% | 528.74 ± 0.2% | 0.96 | 1.00 | 3.99 | 1.05 |
| other: a number before a unit, second text | 15 | 381.23 ± 0.3% | 421.79 ± 0.2% | 597.27 ± 0.4% | 39.36 ± 0.5% | 635.38 ± 1.0% | 884.52 ± 1.1% | 14938.79 ± 0.3% | 381.02 ± 0.3% | 0.90 | 1.00 | 9.68 | 0.60 |
| other: a heading's start tag | 13 | 341.36 ± 0.7% | 349.71 ± 0.3% | 466.91 ± 0.6% | 43.38 ± 0.7% | 632.72 ± 1.0% | 871.43 ± 0.8% | 17673.10 ± 0.2% | 341.72 ± 0.3% | 0.98 | 1.00 | 7.87 | 0.54 |
| other: a whole word | 11 | 566.50 ± 0.4% | 605.79 ± 0.4% | 1036.85 ± 0.9% | 117.33 ± 0.5% | 563.03 ± 9.0% | 824.75 ± 0.4% | 26651.10 ± 0.2% | 566.03 ± 0.4% | 0.94 | 1.00 | 4.83 | 1.01 |
| other: a line's first word, second text | 17 | 518.85 ± 0.7% | 543.77 ± 0.3% | 893.93 ± 0.4% | 128.15 ± 0.1% | 716.30 ± 3.5% | refused | refused | 517.48 ± 0.4% | 0.95 | 1.00 | 4.05 | 0.72 |
| other: fourteen octets before an x | 16 | 105.46 ± 0.6% | 151.48 ± 0.4% | 175.40 ± 0.8% | 14.83 ± 0.2% | 455.21 ± 3.1% | 400.59 ± 0.5% | 12619.48 ± 1.8% | 105.68 ± 0.4% | 0.70 | 1.00 | 7.11 | 0.23 |
| other: a Greek word | 8 | 411.50 ± 0.1% | 567.78 ± 0.3% | 989.31 ± 0.2% | 58.74 ± 0.1% | 1386.18 ± 0.5% | 1840.26 ± 0.4% | refused | 411.48 ± 0.1% | 0.72 | 1.00 | 7.01 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15781.56 ± 0.8% | not timed | not timed | 16294.13 ± 0.8% | 1974.55 ± 21.4% | not timed | not timed | 15769.38 ± 0.5% | | 1.00 | 0.97 | 7.99 |
| 01-literal/sherlock-casei-en | 522 | 5165.53 ± 1.1% | not timed | not timed | 3593.08 ± 0.1% | 32.56 ± 0.1% | not timed | not timed | 5167.99 ± 0.4% | | 1.00 | 1.44 | 158.66 |
| 01-literal/sherlock-ru | 724 | 17140.31 ± 0.6% | not timed | not timed | 17319.12 ± 0.4% | 1495.65 ± 23.2% | not timed | not timed | 17106.35 ± 0.3% | | 1.00 | 0.99 | 11.46 |
| 01-literal/sherlock-casei-ru | 746 | 6156.00 ± 0.1% | not timed | not timed | 3332.05 ± 0.1% | 30.96 ± 7.4% | not timed | not timed | 6173.92 ± 0.6% | | 1.00 | 1.85 | 198.82 |
| 01-literal/sherlock-zh | 30 | 19859.22 ± 0.8% | not timed | not timed | 18652.40 ± 1.3% | 2693.88 ± 8.3% | not timed | not timed | 19893.65 ± 1.0% | | 1.00 | 1.06 | 7.37 |
| 02-literal-alternate/sherlock-en | 714 | 6047.88 ± 0.2% | not timed | not timed | 3938.95 ± 0.2% | 16.40 ± 11.2% | not timed | not timed | 6047.85 ± 0.6% | | 1.00 | 1.54 | 368.83 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1937.91 ± 1.0% | not timed | not timed | 696.38 ± 0.3% | 10.82 ± 0.2% | not timed | not timed | 1929.23 ± 0.8% | | 1.00 | 2.78 | 179.07 |
| 02-literal-alternate/sherlock-ru | 899 | 5571.52 ± 0.1% | not timed | not timed | 3251.42 ± 0.1% | 22.58 ± 0.1% | not timed | not timed | 5562.14 ± 0.1% | | 1.00 | 1.71 | 246.74 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.23 ± 0.6% | not timed | not timed | 1232.05 ± 0.2% | 9.08 ± 0.2% | not timed | not timed | 2051.99 ± 0.2% | | 1.00 | 1.67 | 226.77 |
| 02-literal-alternate/sherlock-zh | 207 | 7308.54 ± 0.1% | not timed | not timed | 4166.31 ± 0.2% | 31.40 ± 0.1% | not timed | not timed | 7304.07 ± 0.2% | | 1.00 | 1.75 | 232.74 |
| 03-date/ascii | 111817 | 123.98 ± 0.3% | not timed | not timed | 96.56 ± 0.1% | 0.20 ± 2.6% | not timed | not timed | 123.10 ± 0.2% | | 1.01 | 1.28 | 622.25 |
| 04-ruff-noqa/real | 84 | 401.96 ± 0.2% | not timed | not timed | 461.68 ± 0.0% | 19.56 ± 1.2% | not timed | not timed | 401.48 ± 0.2% | | 1.00 | 0.87 | 20.55 |
| 04-ruff-noqa/tweaked | 44 | 561.39 ± 0.2% | not timed | not timed | 457.66 ± 0.1% | 366.00 ± 0.3% | not timed | not timed | 562.06 ± 0.1% | | 1.00 | 1.23 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.14 ± 0.2% | not timed | not timed | 5.12 ± 0.2% | 0.21 ± 3.8% | not timed | not timed | 5.04 ± 4.1% | | 1.02 | 1.00 | 24.80 |
| 06-cloud-flare-redos/original | 107 | 415.38 ± 0.1% | not timed | not timed | 186.41 ± 0.4% | 24.87 ± 0.5% | not timed | not timed | 415.49 ± 0.1% | | 1.00 | 2.23 | 16.70 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.18 ± 0.0% | not timed | not timed | 228.53 ± 0.2% | 26.61 ± 0.1% | not timed | not timed | 411.55 ± 0.2% | | 1.00 | 1.80 | 15.45 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.54 ± 0.3% | not timed | not timed | 255.59 ± 0.2% | 28.79 ± 0.1% | not timed | not timed | 583.31 ± 0.1% | | 1.00 | 2.28 | 20.27 |
| 07-unicode-character-data/parse-line | 558784 | 235.42 ± 0.1% | not timed | not timed | 169.92 ± 0.5% | 41.89 ± 6.1% | not timed | not timed | 235.74 ± 2.0% | | 1.00 | 1.39 | 5.62 |
| 08-words/all-english | 56691 | 116.47 ± 0.5% | not timed | not timed | 82.77 ± 0.2% | 11.85 ± 10.3% | not timed | not timed | 116.73 ± 0.4% | | 1.00 | 1.41 | 9.83 |
| 08-words/long-english | 839 | 613.68 ± 0.3% | not timed | not timed | 597.57 ± 0.1% | 32.46 ± 0.5% | not timed | not timed | 614.50 ± 0.4% | | 1.00 | 1.03 | 18.91 |
| 09-aws-keys/full | 0 | 408.29 ± 0.1% | not timed | not timed | 461.65 ± 0.3% | 64.49 ± 3.3% | not timed | not timed | 407.97 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 943.56 ± 0.1% | not timed | not timed | 991.94 ± 0.1% | 421.68 ± 5.4% | not timed | not timed | 942.83 ± 0.1% | | 1.00 | 0.95 | 2.24 |
| 10-bounded-repeat/letters-en | 1833 | 547.99 ± 1.8% | not timed | not timed | 517.96 ± 0.2% | 19.61 ± 0.5% | not timed | not timed | 577.71 ± 1.9% | | 0.95 | 1.06 | 27.94 |
| 10-bounded-repeat/letters-ru | 3475 | 509.08 ± 1.1% | not timed | not timed | 478.44 ± 0.1% | 22.49 ± 17.8% | not timed | not timed | 507.14 ± 0.9% | | 1.00 | 1.06 | 22.63 |
| 10-bounded-repeat/context | 53 | 77.47 ± 0.7% | not timed | not timed | 66.02 ± 0.4% | 19.82 ± 0.3% | not timed | not timed | 76.94 ± 0.4% | | 1.01 | 1.17 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 636.24 ± 8.3% | not timed | not timed | 618.76 ± 0.1% | 36.58 ± 0.1% | not timed | not timed | 634.48 ± 8.4% | | 1.00 | 1.03 | 17.39 |
| 11-unstructured-to-json/extract | 600 | 82.84 ± 0.2% | not timed | not timed | 78.06 ± 0.3% | 49.07 ± 0.9% | not timed | not timed | 82.48 ± 0.3% | | 1.00 | 1.06 | 1.69 |
| 12-dictionary/single | 1 | 560.24 ± 0.1% | not timed | not timed | 562.19 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 559.67 ± 0.3% | | 1.00 | 1.00 | 1378.05 |
| 14-quadratic/1x | 100 | 21.19 ± 1.1% | not timed | not timed | 10.02 ± 0.1% | 0.96 ± 3.0% | not timed | not timed | 21.22 ± 1.5% | | 1.00 | 2.12 | 22.00 |
| 14-quadratic/2x | 200 | 17.51 ± 0.6% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 17.51 ± 0.4% | | 1.00 | 3.16 | 32.97 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.4% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.6% | not timed | not timed | 7.68 ± 0.6% | | 1.00 | 6.35 | 66.75 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.4% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 5.4% | not timed | not timed | 1.25 ± 2.6% | | 1.01 | 3.65 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 82.96 ± 0.0% | not timed | not timed | 13.84 ± 0.4% | 137.92 ± 3.9% | not timed | not timed | 82.82 ± 1.2% | | 1.00 | 5.99 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 13.88 ± 1.3% | not timed | not timed | 2.51 ± 0.4% | 6.48 ± 2.2% | not timed | not timed | 13.85 ± 0.9% | | 1.00 | 5.53 | 2.14 |
| 07-unicode-character-data/compile | 1 | 53.68 ± 0.1% | not timed | not timed | 26.09 ± 0.2% | 36.29 ± 4.4% | not timed | not timed | 53.23 ± 0.7% | | 1.01 | 2.06 | 1.48 |
| 09-aws-keys/compile-full | 1 | 41.03 ± 0.3% | not timed | not timed | 8.25 ± 1.2% | 23.54 ± 1.4% | not timed | not timed | 40.52 ± 1.7% | | 1.01 | 4.98 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 164.07 ± 0.1% | not timed | not timed | 47.61 ± 0.2% | 134.22 ± 2.8% | not timed | not timed | 163.74 ± 1.7% | | 1.00 | 3.45 | 1.22 |
| 10-bounded-repeat/compile-context | 1 | 13.37 ± 1.2% | not timed | not timed | 11.24 ± 0.2% | 16.25 ± 2.8% | not timed | not timed | 13.39 ± 2.2% | | 1.00 | 1.19 | 0.82 |
| 10-bounded-repeat/compile-capitals | 1 | 80.78 ± 0.4% | not timed | not timed | 8.08 ± 0.1% | 24.24 ± 1.7% | not timed | not timed | 79.93 ± 1.6% | | 1.01 | 9.99 | 3.33 |
| 11-unstructured-to-json/compile | 1 | 83.94 ± 0.2% | not timed | not timed | 40.55 ± 0.8% | 69.16 ± 1.3% | not timed | not timed | 83.01 ± 2.0% | | 1.01 | 2.07 | 1.21 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 23.1% | 0.09 ± 12.3% | not timed | not timed | 0.35 ± 2.3% | | 1.00 | 5.06 | 3.74 |

