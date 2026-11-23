# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117654979 |
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
| literal: a word | 217 | 32848.21 ± 4.8% | 894.30 ± 0.3% | 19.74 ± 3.8% | 30967.05 ± 1.8% | 8821.87 ± 10.0% | 10.75 ± 0.3% | 75.67 ± 0.4% | 32055.38 ± 1.4% | 36.73 | 1.02 | 1.06 | 3.72 |
| literal: a word that is not there | 0 | 49333.75 ± 6.1% | 901.90 ± 1.0% | 19.92 ± 5.8% | 39048.35 ± 4.6% | 30127.40 ± 1.0% | 10.72 ± 0.3% | 71.00 ± 2.3% | 48478.56 ± 1.7% | 54.70 | 1.02 | 1.26 | 1.64 |
| literal: one of four words | 661 | 10964.34 ± 3.2% | 868.54 ± 0.1% | 10.98 ± 13.0% | 9078.10 ± 1.1% | 19.28 ± 0.8% | 3.98 ± 0.3% | 6.43 ± 0.4% | 10949.96 ± 0.4% | 12.62 | 1.00 | 1.21 | 568.82 |
| literal: a word in any case | 217 | 25456.36 ± 4.2% | 893.31 ± 1.0% | 14.73 ± 4.2% | 9195.06 ± 0.7% | 37.22 ± 0.4% | refused | differs | 25150.69 ± 1.2% | 28.50 | 1.01 | 2.77 | 684.00 |
| literal: an href attribute | 33 | 26739.72 ± 3.1% | 901.61 ± 1.0% | 18.27 ± 1.8% | 26548.50 ± 0.9% | 2055.15 ± 4.2% | 8.22 ± 0.0% | 60.89 ± 2.4% | 26551.99 ± 2.2% | 29.66 | 1.01 | 1.01 | 13.01 |
| literal: a word, second text | 123 | 34134.01 ± 1.6% | 893.43 ± 0.1% | 19.49 ± 6.7% | 31678.47 ± 1.3% | 7192.06 ± 7.5% | 11.83 ± 0.6% | 64.99 ± 2.3% | 33729.22 ± 7.6% | 38.21 | 1.01 | 1.08 | 4.75 |
| class: two capitalized words | 1331 | 778.74 ± 1.1% | 814.63 ± 0.2% | 18.72 ± 2.3% | 505.77 ± 0.2% | 34.24 ± 5.8% | 9.34 ± 0.2% | 54.76 ± 1.0% | 779.24 ± 0.3% | 0.96 | 1.00 | 1.54 | 22.74 |
| class: a word that ends in ing | 3399 | 736.09 ± 0.4% | 737.22 ± 1.0% | 12.95 ± 1.9% | 473.29 ± 0.2% | 25.62 ± 23.1% | 5.28 ± 0.3% | 15.63 ± 0.8% | 736.91 ± 0.2% | 1.00 | 1.00 | 1.56 | 28.74 |
| class: a word in capitals | 2332 | 986.44 ± 0.1% | 797.18 ± 0.1% | 19.53 ± 1.3% | 496.96 ± 0.4% | 36.60 ± 12.8% | 10.39 ± 0.2% | 76.09 ± 2.1% | 987.24 ± 0.3% | 1.24 | 1.00 | 1.98 | 26.95 |
| class: a number | 8288 | 1401.51 ± 0.5% | 652.26 ± 0.2% | 19.26 ± 2.4% | 1477.94 ± 0.4% | 36.77 ± 5.6% | 0.33 ± 0.6% | 54.09 ± 1.4% | 1401.04 ± 0.2% | 2.15 | 1.00 | 0.95 | 38.12 |
| class: two capitalized words, second text | 5359 | 579.72 ± 0.3% | 582.08 ± 0.6% | 17.28 ± 2.7% | 417.43 ± 0.2% | 29.99 ± 13.0% | 10.55 ± 0.2% | 50.41 ± 1.0% | 579.80 ± 3.8% | 1.00 | 1.00 | 1.39 | 19.33 |
| other: a word between two words | 6104 | 648.75 ± 0.9% | 621.37 ± 0.3% | 16.87 ± 5.2% | 699.82 ± 0.3% | 101.12 ± 11.8% | 7.26 ± 0.3% | 55.66 ± 2.5% | 646.37 ± 0.3% | 1.04 | 1.00 | 0.93 | 6.42 |
| other: a number before a unit, second text | 1481 | 6860.55 ± 0.8% | 827.97 ± 0.2% | 18.56 ± 1.2% | 6430.51 ± 0.9% | 35.18 ± 1.0% | 10.98 ± 0.2% | 53.84 ± 0.4% | 6811.98 ± 0.7% | 8.29 | 1.01 | 1.07 | 194.99 |
| other: a heading's start tag | 110 | 18936.01 ± 1.6% | 894.09 ± 0.5% | 19.26 ± 2.8% | 2007.12 ± 0.6% | 1469.40 ± 6.9% | 10.04 ± 0.2% | 71.28 ± 0.4% | 18688.25 ± 2.3% | 21.18 | 1.01 | 9.43 | 12.89 |
| other: a whole word | 217 | 22774.26 ± 0.7% | 892.88 ± 0.1% | 19.53 ± 2.5% | 22267.99 ± 2.0% | 40.56 ± 0.1% | 9.43 ± 0.4% | 46.40 ± 0.8% | 22510.05 ± 1.2% | 25.51 | 1.01 | 1.02 | 561.54 |
| other: a line's first word, second text | 3716 | 1751.95 ± 2.5% | 719.38 ± 0.3% | 21.91 ± 1.2% | 1737.57 ± 2.7% | 53.14 ± 3.7% | refused | refused | 1750.21 ± 1.3% | 2.44 | 1.00 | 1.01 | 32.97 |
| other: fourteen octets before an x | 87 | 25316.21 ± 2.4% | 214.05 ± 0.5% | 5.02 ± 0.7% | 3108.11 ± 1.1% | 8.97 ± 0.6% | differs | 15.01 ± 0.3% | 25140.64 ± 1.0% | 118.27 | 1.01 | 8.15 | 2823.48 |
| other: a Greek word | 21815 | 407.50 ± 1.0% | 268.35 ± 1.6% | 23.32 ± 1.3% | 264.55 ± 0.3% | 40.88 ± 6.9% | differs | refused | 411.70 ± 0.4% | 1.52 | 0.99 | 1.54 | 9.97 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.47 ± 2.6% | 24.49 ± 0.6% | 0.72 ± 0.3% | 16.82 ± 0.6% | 1.72 ± 4.2% | differs | 3.43 ± 0.7% | 24.51 ± 1.3% | 1.00 | 1.00 | 1.45 | 14.21 |
| a UUID | 32895 | 20.67 ± 8.8% | 20.61 ± 0.2% | 0.56 ± 5.9% | 12.87 ± 0.3% | 2.51 ± 1.6% | 0.44 ± 0.5% | 2.99 ± 1.1% | 20.68 ± 0.4% | 1.00 | 1.00 | 1.61 | 8.25 |
| an IPv4 address | 33176 | 33.50 ± 3.8% | 33.67 ± 3.7% | 1.78 ± 2.6% | 24.09 ± 2.1% | 5.77 ± 3.3% | differs | 3.32 ± 3.3% | 34.34 ± 13.7% | 0.99 | 0.98 | 1.39 | 5.80 |
| a date and time | 32954 | 30.64 ± 0.4% | 30.38 ± 0.4% | 1.28 ± 0.8% | 18.08 ± 0.3% | 6.69 ± 0.6% | 0.75 ± 0.2% | 5.62 ± 1.5% | 30.38 ± 7.0% | 1.01 | 1.01 | 1.69 | 4.58 |
| a field path | 32606 | 27.27 ± 1.1% | 27.35 ± 0.3% | 0.88 ± 2.6% | 19.35 ± 0.4% | 2.95 ± 0.2% | differs | 2.36 ± 0.4% | 27.24 ± 0.9% | 1.00 | 1.00 | 1.41 | 9.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.12 ± 2.3% | 8.20 ± 2.4% | 8.13 ± 1.1% | 10.47 ± 0.4% | 4.77 ± 1.8% | 0.62 ± 0.3% | none | 8.18 ± 0.6% | 0.99 | 0.99 | 0.78 | 1.70 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 183.51 ± 2.2% | 183.91 ± 13.3% | 212.29 ± 0.4% | 78.87 ± 3.4% | 183.71 ± 2.3% | 539.76 ± 2.7% | 3881.94 ± 1.5% | 183.24 ± 0.5% | 1.00 | 1.00 | 2.33 | 1.00 |
| a UUID | 62 | 120.44 ± 0.2% | 120.85 ± 0.3% | 133.41 ± 0.8% | 46.62 ± 1.3% | 89.13 ± 6.5% | 199.57 ± 2.7% | 4020.13 ± 1.2% | 120.49 ± 8.4% | 1.00 | 1.00 | 2.58 | 1.35 |
| an IPv4 address | 29 | 393.34 ± 1.4% | 397.81 ± 1.3% | 550.07 ± 10.8% | 68.67 ± 5.8% | 112.83 ± 2.7% | 326.36 ± 2.1% | 6999.01 ± 2.4% | 393.38 ± 1.1% | 0.99 | 1.00 | 5.73 | 3.49 |
| a date and time | 56 | 283.53 ± 0.3% | 284.48 ± 0.8% | 356.79 ± 1.0% | 68.76 ± 1.9% | 120.67 ± 2.6% | 369.75 ± 1.0% | 4137.97 ± 0.6% | 283.20 ± 0.4% | 1.00 | 1.00 | 4.12 | 2.35 |
| a field path | 39 | 180.61 ± 0.3% | 181.43 ± 0.1% | 208.43 ± 0.3% | 74.25 ± 1.6% | 157.67 ± 21.1% | 574.17 ± 5.2% | 4641.32 ± 13.7% | 180.68 ± 0.9% | 1.00 | 1.00 | 2.43 | 1.15 |
| literal: a word | 7 | 587.01 ± 6.6% | 636.79 ± 0.6% | 1149.82 ± 0.7% | 500.05 ± 0.4% | 549.70 ± 3.3% | 1230.38 ± 11.9% | 24719.31 ± 1.2% | 587.42 ± 0.3% | 0.92 | 1.00 | 1.17 | 1.07 |
| literal: a word that is not there | 8 | 565.35 ± 0.8% | 615.83 ± 0.4% | 1080.89 ± 0.2% | 456.67 ± 0.7% | 532.52 ± 21.8% | 1162.16 ± 0.9% | 21463.43 ± 18.8% | 566.17 ± 0.4% | 0.92 | 1.00 | 1.24 | 1.06 |
| literal: one of four words | 26 | 220.01 ± 1.3% | 362.61 ± 0.7% | 488.43 ± 0.5% | 41.29 ± 2.8% | 209.29 ± 14.1% | 445.91 ± 2.2% | 10564.93 ± 0.2% | 219.85 ± 0.3% | 0.61 | 1.00 | 5.33 | 1.05 |
| literal: a word in any case | 11 | 449.05 ± 0.4% | 480.15 ± 0.7% | 730.04 ± 0.2% | 14.12 ± 1.8% | 579.08 ± 18.4% | refused | 19241.23 ± 0.9% | 448.29 ± 0.8% | 0.94 | 1.00 | 31.80 | 0.78 |
| literal: an href attribute | 12 | 315.96 ± 0.7% | 329.94 ± 0.5% | 435.55 ± 1.5% | 36.43 ± 2.1% | 414.12 ± 6.2% | 918.16 ± 1.1% | 18297.70 ± 1.8% | 316.46 ± 0.4% | 0.96 | 1.00 | 8.67 | 0.76 |
| literal: a word, second text | 10 | 521.82 ± 0.4% | 574.01 ± 1.3% | 961.15 ± 1.2% | 405.62 ± 1.0% | 482.82 ± 2.4% | 995.93 ± 0.9% | 20578.60 ± 3.1% | 520.93 ± 0.6% | 0.91 | 1.00 | 1.29 | 1.08 |
| class: two capitalized words | 23 | 414.46 ± 0.4% | 442.45 ± 7.7% | 643.10 ± 0.8% | 93.37 ± 1.3% | 444.22 ± 5.7% | 889.18 ± 0.9% | 6190.14 ± 0.5% | 413.83 ± 0.7% | 0.94 | 1.00 | 4.44 | 0.93 |
| class: a word that ends in ing | 9 | 510.85 ± 6.9% | 573.23 ± 0.3% | 1011.47 ± 0.8% | 112.76 ± 1.5% | 631.10 ± 1.3% | 1331.78 ± 4.1% | 15167.28 ± 0.5% | 510.77 ± 3.4% | 0.89 | 1.00 | 4.53 | 0.81 |
| class: a word in capitals | 16 | 445.90 ± 0.3% | 478.91 ± 0.3% | 787.66 ± 0.2% | 120.48 ± 1.8% | 647.81 ± 1.2% | 1232.09 ± 5.2% | 8329.28 ± 1.5% | 445.52 ± 0.5% | 0.93 | 1.00 | 3.70 | 0.69 |
| class: a number | 6 | 562.67 ± 0.3% | 613.85 ± 1.4% | 1183.78 ± 0.8% | 36.98 ± 0.9% | 1166.69 ± 1.6% | 2259.81 ± 1.5% | 20588.52 ± 0.4% | 562.79 ± 1.1% | 0.92 | 1.00 | 15.21 | 0.48 |
| class: two capitalized words, second text | 23 | 412.64 ± 1.5% | 441.40 ± 2.1% | 643.65 ± 3.8% | 95.85 ± 0.7% | 448.44 ± 1.1% | 934.06 ± 1.2% | 6190.76 ± 1.2% | 414.50 ± 1.6% | 0.93 | 1.00 | 4.31 | 0.92 |
| other: a word between two words | 13 | 496.14 ± 9.5% | 515.91 ± 0.4% | 815.09 ± 0.5% | 122.03 ± 1.2% | 433.23 ± 1.7% | 1006.60 ± 0.3% | 13241.16 ± 5.9% | 495.71 ± 0.4% | 0.96 | 1.00 | 4.07 | 1.15 |
| other: a number before a unit, second text | 15 | 356.62 ± 2.3% | 390.53 ± 4.6% | 539.71 ± 2.4% | 33.35 ± 4.4% | 523.84 ± 2.8% | 1082.06 ± 5.0% | 13674.29 ± 2.7% | 354.58 ± 2.5% | 0.91 | 1.01 | 10.69 | 0.68 |
| other: a heading's start tag | 13 | 332.16 ± 0.4% | 338.02 ± 1.0% | 448.04 ± 0.3% | 35.70 ± 3.1% | 516.37 ± 3.4% | 1059.69 ± 0.2% | 16004.99 ± 0.6% | 331.24 ± 2.2% | 0.98 | 1.00 | 9.31 | 0.64 |
| other: a whole word | 11 | 505.45 ± 0.8% | 541.45 ± 7.4% | 876.90 ± 2.3% | 110.04 ± 1.4% | 502.71 ± 1.6% | 1055.31 ± 0.7% | 19793.87 ± 3.1% | 501.95 ± 1.2% | 0.93 | 1.01 | 4.59 | 1.01 |
| other: a line's first word, second text | 17 | 481.43 ± 9.5% | 506.27 ± 0.4% | 822.97 ± 0.6% | 111.36 ± 8.9% | 590.32 ± 1.3% | refused | refused | 480.75 ± 0.9% | 0.95 | 1.00 | 4.32 | 0.82 |
| other: fourteen octets before an x | 16 | 87.08 ± 2.0% | 123.29 ± 0.2% | 141.86 ± 10.5% | 13.88 ± 26.0% | 391.01 ± 33.8% | 449.65 ± 11.7% | 11985.29 ± 12.0% | 87.18 ± 2.1% | 0.71 | 1.00 | 6.27 | 0.22 |
| other: a Greek word | 8 | 378.93 ± 0.6% | 512.36 ± 0.2% | 861.69 ± 5.5% | 46.34 ± 7.0% | 1143.69 ± 3.8% | 2200.03 ± 0.6% | refused | 379.13 ± 0.6% | 0.74 | 1.00 | 8.18 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20942.29 ± 1.6% | not timed | not timed | 26348.10 ± 0.5% | 1904.64 ± 16.9% | not timed | not timed | 20967.67 ± 1.7% | | 1.00 | 0.79 | 11.00 |
| 01-literal/sherlock-casei-en | 522 | 4653.62 ± 1.8% | not timed | not timed | 7045.78 ± 22.5% | 28.51 ± 0.8% | not timed | not timed | 4637.42 ± 1.0% | | 1.00 | 0.66 | 163.22 |
| 01-literal/sherlock-ru | 724 | 22814.06 ± 2.0% | not timed | not timed | 27396.58 ± 0.7% | 1049.62 ± 10.4% | not timed | not timed | 22582.00 ± 1.4% | | 1.01 | 0.83 | 21.74 |
| 01-literal/sherlock-casei-ru | 746 | 7245.56 ± 0.6% | not timed | not timed | 5498.75 ± 6.0% | 30.36 ± 1.5% | not timed | not timed | 7177.57 ± 0.8% | | 1.01 | 1.32 | 238.69 |
| 01-literal/sherlock-zh | 30 | 41923.37 ± 2.8% | not timed | not timed | 36266.65 ± 2.6% | 1260.75 ± 0.9% | not timed | not timed | 41196.34 ± 12.4% | | 1.02 | 1.16 | 33.25 |
| 02-literal-alternate/sherlock-en | 714 | 9481.09 ± 0.5% | not timed | not timed | 8868.00 ± 0.3% | 14.26 ± 4.5% | not timed | not timed | 9462.69 ± 0.6% | | 1.00 | 1.07 | 664.88 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1731.43 ± 0.6% | not timed | not timed | 1821.94 ± 0.5% | 9.47 ± 1.2% | not timed | not timed | 1637.83 ± 4.4% | | 1.06 | 0.95 | 182.81 |
| 02-literal-alternate/sherlock-ru | 899 | 5954.87 ± 0.2% | not timed | not timed | 4251.89 ± 0.8% | 19.62 ± 0.6% | not timed | not timed | 5923.27 ± 9.8% | | 1.01 | 1.40 | 303.58 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1794.73 ± 0.2% | not timed | not timed | 1040.56 ± 0.6% | 8.54 ± 6.0% | not timed | not timed | 1794.76 ± 0.2% | | 1.00 | 1.72 | 210.26 |
| 02-literal-alternate/sherlock-zh | 207 | 13708.49 ± 0.8% | not timed | not timed | 10416.24 ± 1.2% | 27.60 ± 2.3% | not timed | not timed | 13749.48 ± 0.7% | | 1.00 | 1.32 | 496.64 |
| 03-date/ascii | 111817 | 102.26 ± 1.4% | not timed | not timed | 83.99 ± 13.9% | 0.18 ± 2.4% | not timed | not timed | 101.97 ± 1.2% | | 1.00 | 1.22 | 582.20 |
| 04-ruff-noqa/real | 84 | 560.79 ± 1.8% | not timed | not timed | 425.08 ± 0.3% | 13.78 ± 1.0% | not timed | not timed | 557.44 ± 2.5% | | 1.01 | 1.32 | 40.71 |
| 04-ruff-noqa/tweaked | 44 | 448.98 ± 0.4% | not timed | not timed | 410.72 ± 0.3% | 286.41 ± 2.0% | not timed | not timed | 447.86 ± 0.7% | | 1.00 | 1.09 | 1.57 |
| 05-lexer-veryl/single | 124800 | 2.90 ± 1.8% | not timed | not timed | 4.19 ± 1.0% | 0.21 ± 2.3% | not timed | not timed | 2.80 ± 4.9% | | 1.03 | 0.69 | 13.72 |
| 06-cloud-flare-redos/original | 107 | 182.93 ± 1.1% | not timed | not timed | 193.02 ± 0.1% | 13.12 ± 0.9% | not timed | not timed | 183.07 ± 1.0% | | 1.00 | 0.95 | 13.94 |
| 06-cloud-flare-redos/simplified-short | 102 | 127.39 ± 0.6% | not timed | not timed | 192.15 ± 1.2% | 14.14 ± 1.7% | not timed | not timed | 127.35 ± 0.6% | | 1.00 | 0.66 | 9.01 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.32 ± 5.0% | not timed | not timed | 211.57 ± 0.2% | 14.79 ± 10.0% | not timed | not timed | 136.13 ± 5.1% | | 1.00 | 0.64 | 9.22 |
| 07-unicode-character-data/parse-line | 558784 | 191.94 ± 1.9% | not timed | not timed | 157.56 ± 1.9% | 36.46 ± 46.5% | not timed | not timed | 165.97 ± 1.4% | | 1.16 | 1.22 | 5.26 |
| 08-words/all-english | 56691 | 73.05 ± 0.5% | not timed | not timed | 73.09 ± 0.4% | 10.04 ± 3.8% | not timed | not timed | 73.08 ± 1.0% | | 1.00 | 1.00 | 7.27 |
| 08-words/long-english | 839 | 850.65 ± 0.5% | not timed | not timed | 513.50 ± 0.2% | 26.28 ± 2.1% | not timed | not timed | 849.45 ± 0.2% | | 1.00 | 1.66 | 32.37 |
| 09-aws-keys/full | 0 | 432.09 ± 0.7% | not timed | not timed | 451.45 ± 0.7% | 45.86 ± 4.3% | not timed | not timed | 427.94 ± 0.2% | | 1.01 | 0.96 | 9.42 |
| 09-aws-keys/quick | 0 | 816.95 ± 0.5% | not timed | not timed | 804.67 ± 0.8% | 289.10 ± 2.9% | not timed | not timed | 813.08 ± 1.0% | | 1.00 | 1.02 | 2.83 |
| 10-bounded-repeat/letters-en | 1833 | 465.87 ± 1.1% | not timed | not timed | 431.56 ± 0.5% | 17.06 ± 0.4% | not timed | not timed | 467.02 ± 0.2% | | 1.00 | 1.08 | 27.31 |
| 10-bounded-repeat/letters-ru | 3475 | 321.97 ± 0.7% | not timed | not timed | 408.20 ± 0.1% | 19.61 ± 8.5% | not timed | not timed | 322.38 ± 0.9% | | 1.00 | 0.79 | 16.42 |
| 10-bounded-repeat/context | 53 | 66.73 ± 14.5% | not timed | not timed | 55.66 ± 0.7% | 16.97 ± 4.3% | not timed | not timed | 66.22 ± 6.9% | | 1.01 | 1.20 | 3.93 |
| 10-bounded-repeat/capitals | 11 | 896.26 ± 1.1% | not timed | not timed | 532.56 ± 0.5% | 30.91 ± 1.0% | not timed | not timed | 894.86 ± 0.8% | | 1.00 | 1.68 | 28.99 |
| 11-unstructured-to-json/extract | 600 | 35.51 ± 0.8% | not timed | not timed | 62.46 ± 1.9% | 22.86 ± 1.3% | not timed | not timed | 35.58 ± 0.4% | | 1.00 | 0.57 | 1.55 |
| 12-dictionary/single | 1 | 460.03 ± 0.9% | not timed | not timed | 439.29 ± 0.3% | 0.31 ± 0.5% | not timed | not timed | 461.36 ± 0.7% | | 1.00 | 1.05 | 1494.97 |
| 14-quadratic/1x | 100 | 11.27 ± 1.1% | not timed | not timed | 9.13 ± 0.3% | 0.80 ± 1.1% | not timed | not timed | 11.37 ± 1.4% | | 0.99 | 1.23 | 14.16 |
| 14-quadratic/2x | 200 | 6.86 ± 1.7% | not timed | not timed | 4.92 ± 0.5% | 0.43 ± 2.5% | not timed | not timed | 6.87 ± 0.5% | | 1.00 | 1.39 | 15.99 |
| 14-quadratic/10x | 1000 | 1.59 ± 0.7% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 1.7% | not timed | not timed | 1.59 ± 1.3% | | 1.00 | 1.52 | 17.13 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.33 ± 0.6% | not timed | not timed | 0.38 ± 0.9% | 0.47 ± 3.1% | not timed | not timed | 1.32 ± 0.4% | | 1.00 | 3.45 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 79.10 ± 0.2% | not timed | not timed | 12.72 ± 6.5% | 123.86 ± 3.1% | not timed | not timed | 78.06 ± 1.5% | | 1.01 | 6.22 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.78 ± 0.6% | not timed | not timed | 2.33 ± 0.7% | 5.84 ± 22.0% | not timed | not timed | 12.52 ± 2.1% | | 1.02 | 5.49 | 2.19 |
| 07-unicode-character-data/compile | 1 | 49.68 ± 0.6% | not timed | not timed | 23.80 ± 1.6% | 32.44 ± 3.1% | not timed | not timed | 49.03 ± 5.3% | | 1.01 | 2.09 | 1.53 |
| 09-aws-keys/compile-full | 1 | 34.26 ± 14.3% | not timed | not timed | 7.32 ± 0.7% | 19.83 ± 3.3% | not timed | not timed | 33.83 ± 0.5% | | 1.01 | 4.68 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 158.29 ± 15.4% | not timed | not timed | 44.31 ± 0.6% | 116.22 ± 12.7% | not timed | not timed | 155.16 ± 8.5% | | 1.02 | 3.57 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 10.55 ± 5.4% | not timed | not timed | 11.60 ± 0.8% | 14.86 ± 5.1% | not timed | not timed | 10.46 ± 31.3% | | 1.01 | 0.91 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 71.74 ± 3.4% | not timed | not timed | 8.48 ± 5.9% | 20.46 ± 10.1% | not timed | not timed | 70.91 ± 3.1% | | 1.01 | 8.46 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 75.03 ± 2.3% | not timed | not timed | 36.42 ± 4.6% | 57.01 ± 24.8% | not timed | not timed | 74.17 ± 2.4% | | 1.01 | 2.06 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.29 ± 17.9% | not timed | not timed | 0.07 ± 2.9% | 0.08 ± 14.4% | not timed | not timed | 0.28 ± 0.7% | | 1.02 | 4.34 | 3.57 |

