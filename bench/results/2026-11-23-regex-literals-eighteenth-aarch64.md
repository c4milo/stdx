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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243558241 |
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
| literal: a word | 217 | 19240.47 ± 2.5% | 4983.59 ± 0.3% | 28.23 ± 0.8% | 17907.89 ± 3.2% | 9111.18 ± 8.7% | 17.45 ± 0.3% | 84.26 ± 0.4% | 19275.16 ± 2.1% | 3.86 | 1.00 | 1.07 | 2.11 |
| literal: a word that is not there | 0 | 21205.52 ± 2.5% | 4859.55 ± 0.8% | 28.42 ± 0.8% | 19438.36 ± 10.9% | 28775.18 ± 8.0% | 17.29 ± 0.2% | 79.79 ± 0.5% | 21286.18 ± 0.6% | 4.36 | 1.00 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6377.82 ± 0.7% | 1929.29 ± 0.3% | 14.37 ± 0.1% | 3943.44 ± 0.2% | 21.86 ± 0.3% | 5.26 ± 0.4% | 6.85 ± 0.8% | 6346.07 ± 0.2% | 3.31 | 1.01 | 1.62 | 291.79 |
| literal: a word in any case | 217 | 15077.34 ± 1.2% | 2069.88 ± 0.2% | 21.39 ± 0.3% | 3967.50 ± 0.4% | 38.05 ± 0.5% | refused | differs | 15045.61 ± 0.7% | 7.28 | 1.00 | 3.80 | 396.27 |
| literal: an href attribute | 33 | 16811.37 ± 1.1% | 606.93 ± 0.8% | 27.06 ± 0.4% | 17040.30 ± 2.4% | 2250.71 ± 6.1% | 13.28 ± 0.3% | 73.92 ± 0.5% | 16761.93 ± 1.0% | 27.70 | 1.00 | 0.99 | 7.47 |
| literal: a word, second text | 123 | 19639.05 ± 1.5% | 3351.01 ± 0.2% | 27.98 ± 0.3% | 18439.77 ± 0.6% | 7561.87 ± 4.3% | 19.65 ± 0.3% | 69.94 ± 2.0% | 19734.19 ± 3.1% | 5.86 | 1.00 | 1.07 | 2.60 |
| class: two capitalized words | 1331 | 1056.53 ± 0.3% | 597.19 ± 0.6% | 25.84 ± 0.4% | 585.59 ± 0.1% | 40.55 ± 3.1% | 14.82 ± 0.4% | 67.25 ± 0.6% | 1055.67 ± 0.4% | 1.77 | 1.00 | 1.80 | 26.05 |
| class: a word that ends in ing | 3399 | 572.13 ± 0.3% | 571.68 ± 0.5% | 17.88 ± 0.4% | 547.84 ± 0.1% | 29.56 ± 0.3% | 8.18 ± 0.2% | 18.22 ± 0.7% | 571.76 ± 0.3% | 1.00 | 1.00 | 1.04 | 19.35 |
| class: a word in capitals | 2332 | 1367.44 ± 0.6% | 602.35 ± 0.4% | 27.51 ± 0.6% | 572.16 ± 0.1% | 43.67 ± 0.3% | 17.20 ± 0.1% | 82.55 ± 0.3% | 1368.64 ± 0.3% | 2.27 | 1.00 | 2.39 | 31.31 |
| class: a number | 8288 | 1960.28 ± 0.6% | 826.84 ± 0.1% | 27.76 ± 0.5% | 1713.23 ± 0.4% | 41.90 ± 9.7% | 0.55 ± 0.6% | 57.42 ± 0.6% | 1954.74 ± 0.2% | 2.37 | 1.00 | 1.14 | 46.78 |
| class: two capitalized words, second text | 5359 | 515.33 ± 0.3% | 523.23 ± 0.2% | 23.14 ± 0.1% | 485.56 ± 0.0% | 35.25 ± 8.4% | 16.64 ± 0.2% | 62.61 ± 1.5% | 514.78 ± 0.1% | 0.98 | 1.00 | 1.06 | 14.62 |
| other: a word between two words | 6104 | 794.77 ± 0.3% | 593.69 ± 0.5% | 23.38 ± 0.2% | 738.89 ± 0.3% | 109.65 ± 7.6% | 11.30 ± 0.2% | 68.34 ± 0.3% | 794.91 ± 0.2% | 1.34 | 1.00 | 1.08 | 7.25 |
| other: a number before a unit, second text | 1481 | 5962.50 ± 1.3% | 1119.08 ± 0.2% | 26.00 ± 0.2% | 5655.38 ± 0.4% | 40.73 ± 9.1% | 17.80 ± 0.1% | 65.26 ± 0.6% | 5935.90 ± 0.8% | 5.33 | 1.00 | 1.05 | 146.38 |
| other: a heading's start tag | 110 | 14114.11 ± 0.8% | 742.16 ± 0.2% | 27.49 ± 0.2% | 1710.27 ± 0.4% | 1584.50 ± 6.1% | 16.15 ± 11.7% | 85.95 ± 2.0% | 14122.74 ± 0.8% | 19.02 | 1.00 | 8.25 | 8.91 |
| other: a whole word | 217 | 15878.55 ± 0.6% | 598.50 ± 1.3% | 29.04 ± 0.2% | 14493.31 ± 1.4% | 49.46 ± 0.5% | 13.60 ± 0.2% | 54.96 ± 0.7% | 15870.88 ± 0.7% | 26.53 | 1.00 | 1.10 | 321.04 |
| other: a line's first word, second text | 3716 | 2036.07 ± 0.5% | 587.25 ± 0.2% | 30.59 ± 0.3% | 1718.98 ± 0.3% | 61.60 ± 8.2% | refused | refused | 2028.61 ± 0.3% | 3.47 | 1.00 | 1.18 | 33.05 |
| other: fourteen octets before an x | 87 | 23590.69 ± 3.0% | 241.37 ± 0.5% | 6.53 ± 0.1% | 3964.27 ± 0.6% | 10.64 ± 0.1% | differs | 17.71 ± 0.2% | 23625.72 ± 2.0% | 97.74 | 1.00 | 5.95 | 2216.28 |
| other: a Greek word | 21815 | 486.46 ± 0.9% | 408.91 ± 0.2% | 30.81 ± 0.3% | 289.17 ± 0.2% | 44.67 ± 8.1% | differs | refused | 484.75 ± 0.6% | 1.19 | 1.00 | 1.68 | 10.89 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.39 ± 0.2% | 18.46 ± 0.1% | 0.85 ± 0.4% | 19.77 ± 0.7% | 2.76 ± 0.6% | differs | 3.98 ± 0.3% | 18.45 ± 0.4% | 1.00 | 1.00 | 0.93 | 6.65 |
| a UUID | 32895 | 20.12 ± 0.2% | 20.10 ± 0.3% | 0.64 ± 0.2% | 15.10 ± 0.2% | 3.09 ± 0.4% | 0.72 ± 0.4% | 3.61 ± 0.6% | 20.10 ± 0.1% | 1.00 | 1.00 | 1.33 | 6.51 |
| an IPv4 address | 33176 | 33.64 ± 0.2% | 33.37 ± 0.1% | 2.07 ± 0.3% | 29.19 ± 0.5% | 6.63 ± 0.1% | differs | 4.13 ± 0.1% | 33.64 ± 0.1% | 1.01 | 1.00 | 1.15 | 5.07 |
| a date and time | 32954 | 28.87 ± 0.2% | 28.85 ± 0.3% | 1.44 ± 0.3% | 21.41 ± 0.6% | 7.04 ± 0.1% | 1.17 ± 0.1% | 7.14 ± 0.4% | 28.80 ± 0.2% | 1.00 | 1.00 | 1.35 | 4.10 |
| a field path | 32606 | 21.77 ± 0.3% | 21.72 ± 0.3% | 1.02 ± 0.4% | 23.08 ± 0.3% | 3.48 ± 0.7% | differs | 2.93 ± 0.1% | 21.73 ± 0.4% | 1.00 | 1.00 | 0.94 | 6.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.14 ± 0.1% | 11.10 ± 0.2% | 11.13 ± 0.3% | 11.36 ± 0.2% | 4.94 ± 0.8% | 0.91 ± 0.4% | none | 11.10 ± 0.2% | 1.00 | 1.00 | 0.98 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.26 ± 1.7% | 230.99 ± 1.0% | 276.21 ± 0.9% | 86.54 ± 0.4% | 222.41 ± 1.5% | 485.34 ± 0.6% | 3807.28 ± 0.3% | 230.57 ± 0.7% | 1.00 | 1.00 | 2.66 | 1.04 |
| a UUID | 62 | 147.60 ± 1.6% | 148.07 ± 2.3% | 166.16 ± 1.6% | 45.86 ± 1.1% | 99.41 ± 0.7% | 185.15 ± 2.3% | 4273.59 ± 0.3% | 147.90 ± 1.5% | 1.00 | 1.00 | 3.22 | 1.48 |
| an IPv4 address | 29 | 418.50 ± 0.5% | 421.73 ± 0.4% | 596.52 ± 0.4% | 78.28 ± 0.5% | 132.15 ± 0.2% | 296.43 ± 0.8% | 7585.29 ± 0.7% | 417.54 ± 0.5% | 0.99 | 1.00 | 5.35 | 3.17 |
| a date and time | 56 | 297.51 ± 0.2% | 298.54 ± 0.3% | 374.73 ± 0.3% | 73.21 ± 1.2% | 138.30 ± 0.8% | 330.74 ± 2.3% | 4924.58 ± 0.7% | 297.37 ± 0.2% | 1.00 | 1.00 | 4.06 | 2.15 |
| a field path | 39 | 223.80 ± 1.3% | 224.69 ± 0.7% | 265.55 ± 1.0% | 79.56 ± 0.5% | 205.85 ± 1.2% | 505.52 ± 2.3% | 4826.17 ± 0.8% | 222.67 ± 1.9% | 1.00 | 1.01 | 2.81 | 1.09 |
| literal: a word | 7 | 621.25 ± 0.4% | 672.39 ± 0.8% | 1205.66 ± 0.2% | 495.66 ± 1.0% | 633.72 ± 1.4% | 964.39 ± 0.6% | 30323.44 ± 0.1% | 621.01 ± 0.4% | 0.92 | 1.00 | 1.25 | 0.98 |
| literal: a word that is not there | 8 | 598.10 ± 0.1% | 649.80 ± 0.5% | 1141.41 ± 0.2% | 450.77 ± 0.2% | 608.85 ± 1.6% | 908.98 ± 0.6% | 29141.77 ± 0.1% | 597.74 ± 0.2% | 0.92 | 1.00 | 1.33 | 0.98 |
| literal: one of four words | 26 | 240.58 ± 0.1% | 396.97 ± 0.5% | 542.15 ± 0.7% | 50.71 ± 0.8% | 244.28 ± 1.7% | 385.87 ± 2.9% | 15873.07 ± 0.2% | 240.55 ± 0.1% | 0.61 | 1.00 | 4.74 | 0.98 |
| literal: a word in any case | 11 | 442.36 ± 0.5% | 474.06 ± 0.3% | 694.74 ± 0.2% | 15.51 ± 0.5% | 661.69 ± 2.9% | refused | 23640.19 ± 0.2% | 442.06 ± 0.6% | 0.93 | 1.00 | 28.52 | 0.67 |
| literal: an href attribute | 12 | 340.05 ± 0.2% | 352.24 ± 0.4% | 463.67 ± 0.5% | 45.99 ± 0.3% | 503.97 ± 1.7% | 759.92 ± 0.4% | 21348.08 ± 0.3% | 339.35 ± 0.3% | 0.97 | 1.00 | 7.39 | 0.67 |
| literal: a word, second text | 10 | 558.03 ± 0.2% | 616.44 ± 0.2% | 1037.43 ± 0.3% | 409.01 ± 0.3% | 539.70 ± 2.1% | 792.13 ± 0.6% | 27065.00 ± 0.2% | 557.71 ± 0.3% | 0.91 | 1.00 | 1.36 | 1.03 |
| class: two capitalized words | 23 | 432.38 ± 0.5% | 461.75 ± 0.1% | 672.59 ± 0.2% | 101.23 ± 0.2% | 505.84 ± 2.2% | 753.12 ± 0.7% | 6453.07 ± 0.4% | 432.42 ± 0.4% | 0.94 | 1.00 | 4.27 | 0.85 |
| class: a word that ends in ing | 9 | 558.17 ± 0.2% | 622.69 ± 0.3% | 1096.25 ± 0.3% | 133.03 ± 0.1% | 766.37 ± 0.9% | 1084.43 ± 0.3% | 15809.60 ± 0.2% | 557.68 ± 0.3% | 0.90 | 1.00 | 4.20 | 0.73 |
| class: a word in capitals | 16 | 494.62 ± 0.6% | 536.73 ± 0.1% | 867.63 ± 0.2% | 136.23 ± 0.4% | 760.13 ± 1.3% | 1011.52 ± 0.4% | 8528.13 ± 0.1% | 494.21 ± 0.6% | 0.92 | 1.00 | 3.63 | 0.65 |
| class: a number | 6 | 624.04 ± 0.5% | 688.73 ± 0.4% | 1316.63 ± 0.1% | 41.74 ± 1.1% | 1411.84 ± 0.5% | 1872.50 ± 1.4% | 22653.41 ± 0.1% | 624.89 ± 0.3% | 0.91 | 1.00 | 14.95 | 0.44 |
| class: two capitalized words, second text | 23 | 431.66 ± 1.0% | 461.31 ± 0.5% | 672.49 ± 0.4% | 102.47 ± 0.4% | 506.78 ± 1.9% | 735.99 ± 0.5% | 6447.81 ± 0.3% | 432.19 ± 0.8% | 0.94 | 1.00 | 4.21 | 0.85 |
| other: a word between two words | 13 | 534.17 ± 0.5% | 554.62 ± 0.3% | 895.52 ± 0.3% | 133.88 ± 0.5% | 506.26 ± 0.7% | 816.49 ± 0.2% | 14734.76 ± 0.1% | 535.26 ± 0.5% | 0.96 | 1.00 | 3.99 | 1.06 |
| other: a number before a unit, second text | 15 | 394.04 ± 0.7% | 432.27 ± 0.8% | 611.99 ± 1.1% | 39.37 ± 0.4% | 644.00 ± 1.4% | 897.03 ± 1.1% | 15052.00 ± 0.5% | 395.77 ± 0.7% | 0.91 | 1.00 | 10.01 | 0.61 |
| other: a heading's start tag | 13 | 349.16 ± 0.5% | 356.47 ± 0.7% | 472.98 ± 0.3% | 43.79 ± 0.2% | 637.55 ± 0.6% | 861.55 ± 0.4% | 17878.02 ± 0.5% | 349.39 ± 0.7% | 0.98 | 1.00 | 7.97 | 0.55 |
| other: a whole word | 11 | 574.85 ± 0.4% | 613.38 ± 0.3% | 1031.13 ± 0.5% | 118.96 ± 1.0% | 573.51 ± 2.0% | 830.69 ± 1.0% | 26771.94 ± 0.2% | 575.23 ± 0.7% | 0.94 | 1.00 | 4.83 | 1.00 |
| other: a line's first word, second text | 17 | 531.65 ± 0.1% | 555.29 ± 0.3% | 892.32 ± 0.1% | 129.32 ± 0.1% | 708.32 ± 4.6% | refused | refused | 527.23 ± 0.9% | 0.96 | 1.01 | 4.11 | 0.75 |
| other: fourteen octets before an x | 16 | 107.05 ± 1.0% | 152.59 ± 0.6% | 175.87 ± 0.7% | 15.34 ± 0.6% | 451.15 ± 2.7% | 411.10 ± 1.1% | 12727.51 ± 1.8% | 106.94 ± 0.5% | 0.70 | 1.00 | 6.98 | 0.24 |
| other: a Greek word | 8 | 430.03 ± 0.3% | 591.39 ± 0.3% | 1018.34 ± 0.2% | 58.99 ± 0.2% | 1375.11 ± 0.9% | 1830.09 ± 0.8% | refused | 430.21 ± 0.1% | 0.73 | 1.00 | 7.29 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15495.40 ± 1.4% | not timed | not timed | 16181.36 ± 2.2% | 2090.76 ± 17.2% | not timed | not timed | 15488.83 ± 1.1% | | 1.00 | 0.96 | 7.41 |
| 01-literal/sherlock-casei-en | 522 | 5152.23 ± 0.9% | not timed | not timed | 3585.24 ± 0.2% | 32.50 ± 0.2% | not timed | not timed | 5142.84 ± 0.5% | | 1.00 | 1.44 | 158.55 |
| 01-literal/sherlock-ru | 724 | 17048.44 ± 0.4% | not timed | not timed | 17231.99 ± 0.5% | 1327.20 ± 19.5% | not timed | not timed | 17025.70 ± 0.4% | | 1.00 | 0.99 | 12.85 |
| 01-literal/sherlock-casei-ru | 746 | 6171.21 ± 0.3% | not timed | not timed | 3318.05 ± 0.1% | 30.83 ± 0.9% | not timed | not timed | 6173.84 ± 0.2% | | 1.00 | 1.86 | 200.19 |
| 01-literal/sherlock-zh | 30 | 19411.20 ± 0.9% | not timed | not timed | 18279.25 ± 0.8% | 2755.19 ± 3.1% | not timed | not timed | 19349.49 ± 0.7% | | 1.00 | 1.06 | 7.05 |
| 02-literal-alternate/sherlock-en | 714 | 6037.79 ± 0.3% | not timed | not timed | 3938.50 ± 0.2% | 16.00 ± 0.1% | not timed | not timed | 6041.53 ± 0.2% | | 1.00 | 1.53 | 377.39 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1935.03 ± 1.5% | not timed | not timed | 697.16 ± 0.2% | 11.11 ± 0.5% | not timed | not timed | 1927.02 ± 1.0% | | 1.00 | 2.78 | 174.23 |
| 02-literal-alternate/sherlock-ru | 899 | 5556.38 ± 0.2% | not timed | not timed | 3254.05 ± 0.2% | 22.61 ± 0.1% | not timed | not timed | 5557.12 ± 0.1% | | 1.00 | 1.71 | 245.77 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.92 ± 0.5% | not timed | not timed | 1232.35 ± 0.3% | 9.07 ± 0.1% | not timed | not timed | 2049.41 ± 0.2% | | 1.00 | 1.67 | 226.80 |
| 02-literal-alternate/sherlock-zh | 207 | 7272.40 ± 0.3% | not timed | not timed | 4162.06 ± 0.1% | 31.41 ± 0.2% | not timed | not timed | 7270.86 ± 0.5% | | 1.00 | 1.75 | 231.54 |
| 03-date/ascii | 111817 | 124.06 ± 0.6% | not timed | not timed | 96.26 ± 0.2% | 0.20 ± 1.6% | not timed | not timed | 123.29 ± 0.1% | | 1.01 | 1.29 | 612.35 |
| 04-ruff-noqa/real | 84 | 403.10 ± 0.1% | not timed | not timed | 459.09 ± 0.2% | 19.54 ± 1.4% | not timed | not timed | 403.24 ± 0.1% | | 1.00 | 0.88 | 20.63 |
| 04-ruff-noqa/tweaked | 44 | 561.89 ± 0.2% | not timed | not timed | 462.45 ± 0.1% | 367.75 ± 0.4% | not timed | not timed | 561.19 ± 0.1% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.23 ± 0.5% | not timed | not timed | 4.94 ± 0.1% | 0.20 ± 3.7% | not timed | not timed | 5.06 ± 3.4% | | 1.03 | 1.06 | 25.69 |
| 06-cloud-flare-redos/original | 107 | 415.89 ± 0.2% | not timed | not timed | 217.04 ± 0.1% | 24.87 ± 0.2% | not timed | not timed | 415.62 ± 0.1% | | 1.00 | 1.92 | 16.72 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.55 ± 0.1% | not timed | not timed | 228.21 ± 0.1% | 26.77 ± 0.1% | not timed | not timed | 411.01 ± 0.2% | | 1.00 | 1.80 | 15.38 |
| 06-cloud-flare-redos/simplified-long | 10000 | 581.24 ± 0.3% | not timed | not timed | 254.50 ± 0.3% | 28.85 ± 0.1% | not timed | not timed | 580.83 ± 0.2% | | 1.00 | 2.28 | 20.15 |
| 07-unicode-character-data/parse-line | 558784 | 235.27 ± 2.8% | not timed | not timed | 171.47 ± 0.1% | 43.17 ± 6.1% | not timed | not timed | 237.53 ± 2.1% | | 0.99 | 1.37 | 5.45 |
| 08-words/all-english | 56691 | 116.90 ± 0.3% | not timed | not timed | 82.68 ± 0.1% | 11.97 ± 10.1% | not timed | not timed | 116.49 ± 0.1% | | 1.00 | 1.41 | 9.77 |
| 08-words/long-english | 839 | 613.32 ± 0.6% | not timed | not timed | 597.42 ± 0.2% | 32.65 ± 0.2% | not timed | not timed | 613.60 ± 0.4% | | 1.00 | 1.03 | 18.79 |
| 09-aws-keys/full | 0 | 409.32 ± 0.2% | not timed | not timed | 464.31 ± 0.1% | 64.67 ± 3.2% | not timed | not timed | 409.58 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 946.29 ± 0.1% | not timed | not timed | 961.31 ± 0.2% | 422.73 ± 0.7% | not timed | not timed | 946.47 ± 0.1% | | 1.00 | 0.98 | 2.24 |
| 10-bounded-repeat/letters-en | 1833 | 581.38 ± 2.5% | not timed | not timed | 515.69 ± 0.4% | 19.49 ± 0.5% | not timed | not timed | 578.19 ± 2.0% | | 1.01 | 1.13 | 29.83 |
| 10-bounded-repeat/letters-ru | 3475 | 509.91 ± 1.2% | not timed | not timed | 477.66 ± 0.2% | 21.80 ± 10.8% | not timed | not timed | 509.06 ± 1.6% | | 1.00 | 1.07 | 23.39 |
| 10-bounded-repeat/context | 53 | 76.69 ± 1.3% | not timed | not timed | 65.82 ± 1.8% | 19.83 ± 0.2% | not timed | not timed | 77.12 ± 1.3% | | 0.99 | 1.17 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 635.06 ± 8.4% | not timed | not timed | 615.63 ± 0.1% | 36.27 ± 0.2% | not timed | not timed | 634.60 ± 8.4% | | 1.00 | 1.03 | 17.51 |
| 11-unstructured-to-json/extract | 600 | 82.79 ± 0.1% | not timed | not timed | 76.84 ± 0.2% | 48.79 ± 0.8% | not timed | not timed | 82.48 ± 0.8% | | 1.00 | 1.08 | 1.70 |
| 12-dictionary/single | 1 | 560.03 ± 0.3% | not timed | not timed | 554.72 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 560.04 ± 0.3% | | 1.00 | 1.01 | 1368.76 |
| 14-quadratic/1x | 100 | 21.14 ± 1.0% | not timed | not timed | 9.96 ± 0.6% | 0.99 ± 3.2% | not timed | not timed | 21.31 ± 1.8% | | 0.99 | 2.12 | 21.46 |
| 14-quadratic/2x | 200 | 17.39 ± 1.0% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 0.5% | not timed | not timed | 17.51 ± 0.5% | | 0.99 | 3.14 | 32.50 |
| 14-quadratic/10x | 1000 | 7.62 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.5% | not timed | not timed | 7.68 ± 0.4% | | 0.99 | 6.29 | 65.87 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.2% | not timed | not timed | 0.34 ± 0.6% | 0.56 ± 2.9% | not timed | not timed | 1.25 ± 0.6% | | 1.00 | 3.66 | 2.26 |
| 04-ruff-noqa/compile-real | 1 | 91.49 ± 0.1% | not timed | not timed | 13.73 ± 0.2% | 141.30 ± 3.0% | not timed | not timed | 91.09 ± 1.0% | | 1.00 | 6.66 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.75 ± 0.4% | not timed | not timed | 2.50 ± 0.5% | 6.47 ± 1.9% | not timed | not timed | 13.64 ± 1.4% | | 1.01 | 5.49 | 2.12 |
| 07-unicode-character-data/compile | 1 | 54.76 ± 1.1% | not timed | not timed | 25.64 ± 0.3% | 36.11 ± 1.1% | not timed | not timed | 54.34 ± 0.6% | | 1.01 | 2.14 | 1.52 |
| 09-aws-keys/compile-full | 1 | 41.51 ± 0.3% | not timed | not timed | 8.26 ± 0.4% | 23.54 ± 2.7% | not timed | not timed | 41.03 ± 2.1% | | 1.01 | 5.03 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 181.58 ± 0.2% | not timed | not timed | 47.13 ± 0.1% | 134.76 ± 2.2% | not timed | not timed | 181.50 ± 1.1% | | 1.00 | 3.85 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 13.59 ± 0.6% | not timed | not timed | 11.24 ± 0.2% | 16.16 ± 2.1% | not timed | not timed | 13.56 ± 1.6% | | 1.00 | 1.21 | 0.84 |
| 10-bounded-repeat/compile-capitals | 1 | 81.14 ± 0.2% | not timed | not timed | 8.13 ± 0.3% | 24.04 ± 0.9% | not timed | not timed | 81.14 ± 1.0% | | 1.00 | 9.98 | 3.38 |
| 11-unstructured-to-json/compile | 1 | 85.68 ± 0.4% | not timed | not timed | 41.23 ± 0.2% | 69.55 ± 1.5% | not timed | not timed | 83.97 ± 0.7% | | 1.02 | 2.08 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 16.3% | 0.09 ± 8.3% | not timed | not timed | 0.35 ± 1.8% | | 1.01 | 5.09 | 3.86 |

