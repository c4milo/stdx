# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215394112 |
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
| literal: a word | 217 | 16286.27 ± 0.9% | 5000.45 ± 0.2% | 28.00 ± 0.2% | 18350.73 ± 3.0% | 9150.88 ± 7.4% | 17.62 ± 0.3% | 84.04 ± 1.4% | 16327.74 ± 0.3% | 3.26 | 1.00 | 0.89 | 1.78 |
| literal: a word that is not there | 0 | 18752.60 ± 2.3% | 4880.58 ± 0.3% | 28.06 ± 0.3% | 19902.53 ± 1.9% | 29078.91 ± 1.0% | 17.42 ± 0.2% | 79.39 ± 0.3% | 18759.23 ± 3.0% | 3.84 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6093.26 ± 0.2% | 1932.53 ± 0.2% | 14.22 ± 0.1% | 3947.10 ± 0.1% | 21.92 ± 0.1% | 5.31 ± 0.1% | 6.86 ± 0.8% | 6084.30 ± 0.2% | 3.15 | 1.00 | 1.54 | 278.04 |
| literal: a word in any case | 217 | 12647.55 ± 0.6% | 2069.47 ± 0.1% | 20.95 ± 1.7% | 3967.73 ± 1.0% | 36.81 ± 0.2% | refused | differs | 12608.85 ± 0.5% | 6.11 | 1.00 | 3.19 | 343.57 |
| literal: an href attribute | 33 | 13700.36 ± 0.7% | 616.08 ± 0.1% | 26.69 ± 0.6% | 16921.94 ± 2.7% | 2255.57 ± 0.4% | 13.46 ± 0.2% | 73.85 ± 0.7% | 13650.95 ± 0.8% | 22.24 | 1.00 | 0.81 | 6.07 |
| literal: a word, second text | 123 | 16376.00 ± 0.2% | 3350.39 ± 0.3% | 27.64 ± 0.2% | 18239.34 ± 1.9% | 7552.00 ± 11.2% | 19.78 ± 0.3% | 69.89 ± 0.6% | 16353.14 ± 0.7% | 4.89 | 1.00 | 0.90 | 2.17 |
| class: two capitalized words | 1331 | 1064.16 ± 0.5% | 603.68 ± 0.1% | 25.61 ± 0.1% | 585.25 ± 0.1% | 40.46 ± 8.1% | 14.99 ± 0.2% | 67.38 ± 1.1% | 1063.39 ± 0.2% | 1.76 | 1.00 | 1.82 | 26.30 |
| class: a word that ends in ing | 3399 | 580.40 ± 0.1% | 578.96 ± 0.2% | 17.76 ± 0.1% | 548.01 ± 0.1% | 29.54 ± 2.8% | 8.28 ± 0.1% | 18.40 ± 0.3% | 579.72 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.65 |
| class: a word in capitals | 2332 | 1350.67 ± 0.2% | 614.91 ± 0.1% | 27.24 ± 0.3% | 572.58 ± 0.1% | 43.11 ± 7.3% | 17.26 ± 0.3% | 82.50 ± 2.6% | 1371.60 ± 0.7% | 2.20 | 0.98 | 2.36 | 31.33 |
| class: a number | 8288 | 2000.51 ± 0.4% | 833.48 ± 0.1% | 27.52 ± 0.1% | 1725.41 ± 0.2% | 41.61 ± 6.2% | 0.57 ± 0.0% | 57.46 ± 0.6% | 1999.51 ± 0.4% | 2.40 | 1.00 | 1.16 | 48.08 |
| class: two capitalized words, second text | 5359 | 521.39 ± 0.4% | 528.40 ± 0.6% | 22.86 ± 0.1% | 484.99 ± 0.1% | 34.32 ± 13.0% | 16.76 ± 0.1% | 62.75 ± 0.8% | 520.42 ± 0.1% | 0.99 | 1.00 | 1.08 | 15.19 |
| other: a word between two words | 6104 | 742.47 ± 0.1% | 598.15 ± 0.1% | 23.13 ± 0.2% | 733.35 ± 0.3% | 108.58 ± 20.5% | 11.29 ± 0.2% | 68.13 ± 0.6% | 737.90 ± 0.2% | 1.24 | 1.01 | 1.01 | 6.84 |
| other: a number before a unit, second text | 1481 | 5338.66 ± 0.7% | 1107.55 ± 0.1% | 25.78 ± 0.1% | 5633.31 ± 0.6% | 40.57 ± 7.1% | 17.86 ± 0.1% | 65.81 ± 0.8% | 5323.50 ± 0.3% | 4.82 | 1.00 | 0.95 | 131.59 |
| other: a heading's start tag | 110 | 12545.95 ± 0.5% | 751.01 ± 0.1% | 27.05 ± 0.1% | 1709.69 ± 0.5% | 1577.93 ± 3.1% | 16.41 ± 0.7% | 86.00 ± 2.7% | 12531.83 ± 0.5% | 16.71 | 1.00 | 7.34 | 7.95 |
| other: a whole word | 217 | 14101.09 ± 1.5% | 607.81 ± 0.2% | 29.02 ± 0.3% | 14483.88 ± 1.0% | 47.56 ± 0.2% | 13.87 ± 0.2% | 54.69 ± 0.4% | 14140.64 ± 1.6% | 23.20 | 1.00 | 0.97 | 296.51 |
| other: a line's first word, second text | 3716 | 1953.39 ± 0.9% | 594.34 ± 0.1% | 30.39 ± 0.2% | 1726.96 ± 0.9% | 63.08 ± 7.0% | refused | refused | 1941.53 ± 0.5% | 3.29 | 1.01 | 1.13 | 30.97 |
| other: fourteen octets before an x | 87 | 19616.72 ± 2.2% | 250.86 ± 1.1% | 6.29 ± 0.1% | 4000.71 ± 0.6% | 10.63 ± 0.2% | differs | 17.70 ± 0.3% | 19561.89 ± 0.9% | 78.20 | 1.00 | 4.90 | 1845.67 |
| other: a Greek word | 21815 | 503.79 ± 0.9% | 413.64 ± 0.3% | 30.64 ± 0.2% | 289.39 ± 0.3% | 48.51 ± 10.3% | differs | refused | 500.59 ± 0.7% | 1.22 | 1.01 | 1.74 | 10.38 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.88 ± 0.3% | 19.85 ± 0.3% | 0.84 ± 0.2% | 19.74 ± 0.5% | 2.77 ± 0.4% | differs | 4.05 ± 0.1% | 19.85 ± 0.2% | 1.00 | 1.00 | 1.01 | 7.18 |
| a UUID | 32895 | 21.29 ± 0.2% | 21.36 ± 0.3% | 0.64 ± 0.2% | 15.11 ± 0.6% | 3.08 ± 0.4% | 0.72 ± 0.3% | 3.62 ± 0.4% | 21.37 ± 1.1% | 1.00 | 1.00 | 1.41 | 6.90 |
| an IPv4 address | 33176 | 36.86 ± 0.5% | 36.83 ± 0.6% | 2.05 ± 0.1% | 29.08 ± 0.4% | 6.65 ± 0.1% | differs | 4.14 ± 0.2% | 36.92 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.54 |
| a date and time | 32954 | 31.43 ± 0.2% | 31.39 ± 0.4% | 1.41 ± 0.3% | 21.13 ± 0.6% | 7.02 ± 0.2% | 1.20 ± 0.1% | 7.12 ± 0.5% | 31.42 ± 0.1% | 1.00 | 1.00 | 1.49 | 4.47 |
| a field path | 32606 | 23.48 ± 0.2% | 23.58 ± 0.2% | 1.00 ± 0.1% | 23.06 ± 0.2% | 3.52 ± 0.8% | differs | 2.96 ± 0.2% | 23.57 ± 0.2% | 1.00 | 1.00 | 1.02 | 6.68 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.6% | 11.10 ± 0.4% | 11.08 ± 0.3% | 11.48 ± 0.1% | 4.93 ± 1.1% | 0.92 ± 0.3% | none | 11.11 ± 0.3% | 1.00 | 1.00 | 0.96 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.47 ± 0.2% | 226.20 ± 0.2% | 263.96 ± 0.1% | 86.63 ± 0.2% | 220.75 ± 0.8% | 482.24 ± 0.3% | 3776.47 ± 0.8% | 225.38 ± 0.1% | 1.00 | 1.00 | 2.60 | 1.02 |
| a UUID | 62 | 145.61 ± 0.8% | 145.91 ± 0.2% | 161.23 ± 0.2% | 45.52 ± 0.1% | 98.36 ± 0.8% | 180.17 ± 1.2% | 4215.91 ± 0.9% | 145.65 ± 0.2% | 1.00 | 1.00 | 3.20 | 1.48 |
| an IPv4 address | 29 | 430.59 ± 0.5% | 434.18 ± 0.4% | 599.85 ± 0.5% | 76.14 ± 1.0% | 130.58 ± 1.1% | 289.51 ± 0.3% | 7524.15 ± 0.8% | 429.78 ± 0.3% | 0.99 | 1.00 | 5.66 | 3.30 |
| a date and time | 56 | 302.50 ± 0.2% | 303.71 ± 0.1% | 375.42 ± 0.1% | 71.84 ± 0.2% | 135.06 ± 1.9% | 317.34 ± 1.0% | 4880.46 ± 0.5% | 302.18 ± 0.2% | 1.00 | 1.00 | 4.21 | 2.24 |
| a field path | 39 | 216.87 ± 0.2% | 217.76 ± 0.2% | 252.07 ± 0.3% | 79.26 ± 0.5% | 204.43 ± 1.1% | 483.11 ± 0.6% | 4821.77 ± 0.9% | 216.71 ± 0.3% | 1.00 | 1.00 | 2.74 | 1.06 |
| literal: a word | 7 | 653.80 ± 0.6% | 700.28 ± 0.2% | 1234.90 ± 0.2% | 502.43 ± 1.6% | 629.14 ± 1.9% | 920.86 ± 0.6% | 29582.38 ± 0.1% | 653.65 ± 0.4% | 0.93 | 1.00 | 1.30 | 1.04 |
| literal: a word that is not there | 8 | 627.49 ± 0.2% | 679.14 ± 0.1% | 1163.80 ± 0.3% | 459.75 ± 0.2% | 602.80 ± 1.2% | 872.35 ± 0.5% | 28590.26 ± 0.1% | 626.85 ± 0.6% | 0.92 | 1.00 | 1.36 | 1.04 |
| literal: one of four words | 26 | 250.77 ± 0.1% | 409.00 ± 0.5% | 548.02 ± 0.5% | 49.37 ± 0.3% | 240.61 ± 1.2% | 355.06 ± 0.5% | 15761.07 ± 0.4% | 250.58 ± 0.3% | 0.61 | 1.00 | 5.08 | 1.04 |
| literal: a word in any case | 11 | 455.01 ± 0.1% | 484.88 ± 0.1% | 697.22 ± 0.1% | 15.66 ± 1.0% | 645.00 ± 0.8% | refused | 23454.52 ± 0.3% | 454.97 ± 0.3% | 0.94 | 1.00 | 29.06 | 0.71 |
| literal: an href attribute | 12 | 345.83 ± 0.5% | 357.03 ± 0.4% | 460.77 ± 0.4% | 44.96 ± 0.4% | 500.51 ± 1.2% | 766.51 ± 2.4% | 21285.00 ± 0.6% | 345.66 ± 0.3% | 0.97 | 1.00 | 7.69 | 0.69 |
| literal: a word, second text | 10 | 581.49 ± 0.4% | 638.02 ± 0.4% | 1051.29 ± 0.6% | 408.97 ± 0.4% | 533.35 ± 0.5% | 797.51 ± 0.4% | 26373.79 ± 0.4% | 580.54 ± 0.6% | 0.91 | 1.00 | 1.42 | 1.09 |
| class: two capitalized words | 23 | 444.18 ± 0.8% | 474.23 ± 1.1% | 674.36 ± 0.9% | 100.95 ± 0.3% | 504.28 ± 0.8% | 737.17 ± 0.4% | 6439.52 ± 0.3% | 444.29 ± 0.5% | 0.94 | 1.00 | 4.40 | 0.88 |
| class: a word that ends in ing | 9 | 580.05 ± 0.3% | 648.25 ± 0.5% | 1110.62 ± 0.2% | 132.94 ± 0.7% | 766.34 ± 0.8% | 1075.16 ± 1.8% | 15777.52 ± 0.1% | 578.80 ± 0.6% | 0.89 | 1.00 | 4.36 | 0.76 |
| class: a word in capitals | 16 | 510.60 ± 0.4% | 550.89 ± 0.3% | 871.51 ± 0.2% | 135.38 ± 0.9% | 756.56 ± 0.1% | 1005.52 ± 0.9% | 8487.14 ± 0.1% | 511.05 ± 0.2% | 0.93 | 1.00 | 3.77 | 0.67 |
| class: a number | 6 | 652.37 ± 0.5% | 716.09 ± 0.5% | 1337.08 ± 0.1% | 41.75 ± 0.5% | 1410.09 ± 0.9% | 1929.16 ± 0.9% | 22315.78 ± 0.1% | 651.44 ± 0.4% | 0.91 | 1.00 | 15.63 | 0.46 |
| class: two capitalized words, second text | 23 | 443.82 ± 0.6% | 474.45 ± 0.3% | 673.01 ± 0.2% | 103.04 ± 0.2% | 503.28 ± 1.0% | 737.58 ± 0.5% | 6441.26 ± 0.3% | 444.44 ± 0.3% | 0.94 | 1.00 | 4.31 | 0.88 |
| other: a word between two words | 13 | 561.10 ± 0.3% | 578.13 ± 0.4% | 904.47 ± 0.3% | 135.90 ± 0.2% | 504.00 ± 1.6% | 811.27 ± 0.5% | 14640.82 ± 0.1% | 561.43 ± 0.3% | 0.97 | 1.00 | 4.13 | 1.11 |
| other: a number before a unit, second text | 15 | 399.90 ± 0.7% | 436.94 ± 0.3% | 599.92 ± 0.3% | 39.19 ± 0.6% | 634.58 ± 1.7% | 892.66 ± 0.3% | 14944.37 ± 0.5% | 400.10 ± 0.4% | 0.92 | 1.00 | 10.20 | 0.63 |
| other: a heading's start tag | 13 | 357.24 ± 0.4% | 362.61 ± 0.4% | 470.29 ± 0.4% | 43.35 ± 0.2% | 629.87 ± 1.3% | 858.53 ± 0.2% | 17655.60 ± 0.3% | 357.03 ± 0.2% | 0.99 | 1.00 | 8.24 | 0.57 |
| other: a whole word | 11 | 596.70 ± 0.5% | 630.85 ± 0.7% | 1039.37 ± 0.4% | 120.29 ± 0.4% | 564.54 ± 0.8% | 819.79 ± 0.7% | 26618.41 ± 0.1% | 596.18 ± 0.3% | 0.95 | 1.00 | 4.96 | 1.06 |
| other: a line's first word, second text | 17 | 545.64 ± 0.4% | 564.89 ± 0.2% | 891.24 ± 0.3% | 128.17 ± 0.2% | 712.58 ± 0.5% | refused | refused | 544.88 ± 0.6% | 0.97 | 1.00 | 4.26 | 0.77 |
| other: fourteen octets before an x | 16 | 109.35 ± 0.4% | 156.58 ± 0.3% | 177.85 ± 0.3% | 15.06 ± 1.0% | 454.31 ± 1.2% | 414.48 ± 0.6% | 12698.86 ± 0.4% | 109.35 ± 0.5% | 0.70 | 1.00 | 7.26 | 0.24 |
| other: a Greek word | 8 | 456.86 ± 0.4% | 603.96 ± 0.4% | 996.00 ± 0.1% | 58.47 ± 0.4% | 1402.05 ± 0.9% | 1841.19 ± 0.6% | refused | 457.55 ± 0.4% | 0.76 | 1.00 | 7.81 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12766.76 ± 0.1% | not timed | not timed | 16185.89 ± 1.1% | 1920.99 ± 15.9% | not timed | not timed | 12768.49 ± 0.4% | | 1.00 | 0.79 | 6.65 |
| 01-literal/sherlock-casei-en | 522 | 4942.93 ± 1.0% | not timed | not timed | 3587.77 ± 0.2% | 32.08 ± 0.2% | not timed | not timed | 4912.95 ± 0.5% | | 1.01 | 1.38 | 154.09 |
| 01-literal/sherlock-ru | 724 | 13539.44 ± 0.8% | not timed | not timed | 17287.77 ± 0.9% | 1306.93 ± 7.3% | not timed | not timed | 13516.71 ± 0.5% | | 1.00 | 0.78 | 10.36 |
| 01-literal/sherlock-casei-ru | 746 | 5986.49 ± 0.3% | not timed | not timed | 3327.13 ± 0.1% | 31.41 ± 0.6% | not timed | not timed | 5967.14 ± 0.1% | | 1.00 | 1.80 | 190.62 |
| 01-literal/sherlock-zh | 30 | 16927.33 ± 0.4% | not timed | not timed | 18561.77 ± 1.0% | 2666.87 ± 8.3% | not timed | not timed | 16889.77 ± 0.9% | | 1.00 | 0.91 | 6.35 |
| 02-literal-alternate/sherlock-en | 714 | 5757.39 ± 0.2% | not timed | not timed | 3942.89 ± 0.5% | 16.65 ± 0.2% | not timed | not timed | 5754.49 ± 0.2% | | 1.00 | 1.46 | 345.88 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1802.25 ± 1.3% | not timed | not timed | 696.99 ± 0.3% | 11.03 ± 0.2% | not timed | not timed | 1789.50 ± 0.6% | | 1.01 | 2.59 | 163.40 |
| 02-literal-alternate/sherlock-ru | 899 | 5336.94 ± 0.1% | not timed | not timed | 3265.66 ± 0.1% | 22.66 ± 0.1% | not timed | not timed | 5324.96 ± 0.1% | | 1.00 | 1.63 | 235.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1921.63 ± 0.5% | not timed | not timed | 1231.86 ± 0.2% | 9.14 ± 0.1% | not timed | not timed | 1913.30 ± 0.3% | | 1.00 | 1.56 | 210.21 |
| 02-literal-alternate/sherlock-zh | 207 | 7054.23 ± 1.1% | not timed | not timed | 4159.74 ± 0.3% | 31.52 ± 0.1% | not timed | not timed | 7047.86 ± 0.5% | | 1.00 | 1.70 | 223.79 |
| 03-date/ascii | 111817 | 126.47 ± 0.2% | not timed | not timed | 95.87 ± 0.1% | 0.20 ± 2.2% | not timed | not timed | 126.08 ± 0.4% | | 1.00 | 1.32 | 624.47 |
| 04-ruff-noqa/real | 84 | 408.68 ± 0.1% | not timed | not timed | 457.76 ± 0.1% | 19.54 ± 0.1% | not timed | not timed | 407.72 ± 0.1% | | 1.00 | 0.89 | 20.91 |
| 04-ruff-noqa/tweaked | 44 | 550.88 ± 0.1% | not timed | not timed | 462.08 ± 0.1% | 364.18 ± 0.4% | not timed | not timed | 549.40 ± 0.3% | | 1.00 | 1.19 | 1.51 |
| 05-lexer-veryl/single | 124800 | 5.16 ± 0.2% | not timed | not timed | 5.08 ± 0.2% | 0.20 ± 2.7% | not timed | not timed | 5.07 ± 0.3% | | 1.02 | 1.02 | 25.25 |
| 06-cloud-flare-redos/original | 107 | 415.73 ± 0.5% | not timed | not timed | 215.58 ± 0.1% | 24.97 ± 0.5% | not timed | not timed | 414.43 ± 0.4% | | 1.00 | 1.93 | 16.65 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.45 ± 0.3% | not timed | not timed | 228.69 ± 0.1% | 26.79 ± 0.3% | not timed | not timed | 409.53 ± 0.4% | | 1.00 | 1.79 | 15.32 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.51 ± 0.2% | not timed | not timed | 255.80 ± 0.2% | 28.79 ± 0.1% | not timed | not timed | 587.01 ± 0.2% | | 1.00 | 2.30 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 234.78 ± 0.1% | not timed | not timed | 172.19 ± 0.5% | 42.77 ± 17.0% | not timed | not timed | 235.99 ± 6.6% | | 0.99 | 1.36 | 5.49 |
| 08-words/all-english | 56691 | 117.04 ± 0.9% | not timed | not timed | 82.64 ± 0.3% | 11.80 ± 24.7% | not timed | not timed | 116.78 ± 0.6% | | 1.00 | 1.42 | 9.91 |
| 08-words/long-english | 839 | 620.64 ± 0.2% | not timed | not timed | 595.96 ± 0.4% | 32.11 ± 0.5% | not timed | not timed | 621.17 ± 0.2% | | 1.00 | 1.04 | 19.33 |
| 09-aws-keys/full | 0 | 415.07 ± 0.1% | not timed | not timed | 453.23 ± 0.2% | 64.86 ± 0.0% | not timed | not timed | 414.78 ± 0.1% | | 1.00 | 0.92 | 6.40 |
| 09-aws-keys/quick | 0 | 735.98 ± 0.1% | not timed | not timed | 987.24 ± 0.6% | 422.99 ± 0.7% | not timed | not timed | 734.88 ± 0.1% | | 1.00 | 0.75 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 585.55 ± 2.4% | not timed | not timed | 517.04 ± 0.2% | 19.57 ± 0.6% | not timed | not timed | 578.14 ± 1.9% | | 1.01 | 1.13 | 29.92 |
| 10-bounded-repeat/letters-ru | 3475 | 509.17 ± 0.9% | not timed | not timed | 477.87 ± 0.1% | 22.02 ± 8.4% | not timed | not timed | 506.77 ± 0.9% | | 1.00 | 1.07 | 23.13 |
| 10-bounded-repeat/context | 53 | 77.38 ± 0.5% | not timed | not timed | 65.66 ± 0.5% | 19.81 ± 0.2% | not timed | not timed | 77.52 ± 0.3% | | 1.00 | 1.18 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 631.79 ± 8.3% | not timed | not timed | 618.16 ± 0.4% | 36.55 ± 0.1% | not timed | not timed | 631.34 ± 8.4% | | 1.00 | 1.02 | 17.28 |
| 11-unstructured-to-json/extract | 600 | 83.04 ± 0.1% | not timed | not timed | 77.58 ± 0.3% | 48.88 ± 0.3% | not timed | not timed | 82.91 ± 0.3% | | 1.00 | 1.07 | 1.70 |
| 12-dictionary/single | 1 | 561.30 ± 0.5% | not timed | not timed | 559.49 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 560.56 ± 0.5% | | 1.00 | 1.00 | 1385.50 |
| 14-quadratic/1x | 100 | 21.52 ± 2.7% | not timed | not timed | 10.03 ± 0.2% | 0.96 ± 3.0% | not timed | not timed | 21.38 ± 2.2% | | 1.01 | 2.15 | 22.41 |
| 14-quadratic/2x | 200 | 17.61 ± 4.4% | not timed | not timed | 5.52 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 17.63 ± 0.7% | | 1.00 | 3.19 | 33.18 |
| 14-quadratic/10x | 1000 | 7.69 ± 2.8% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.66 ± 2.3% | | 1.00 | 6.34 | 66.79 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 1.8% | not timed | not timed | 0.34 ± 0.9% | 0.55 ± 3.7% | not timed | not timed | 1.27 ± 1.5% | | 1.00 | 3.72 | 2.33 |
| 04-ruff-noqa/compile-real | 1 | 89.81 ± 0.3% | not timed | not timed | 13.70 ± 0.3% | 141.38 ± 4.0% | not timed | not timed | 89.18 ± 1.2% | | 1.01 | 6.55 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 13.98 ± 0.1% | not timed | not timed | 2.50 ± 1.4% | 6.46 ± 2.0% | not timed | not timed | 13.95 ± 1.2% | | 1.00 | 5.58 | 2.17 |
| 07-unicode-character-data/compile | 1 | 54.18 ± 0.4% | not timed | not timed | 25.65 ± 0.3% | 36.13 ± 3.3% | not timed | not timed | 54.01 ± 0.1% | | 1.00 | 2.11 | 1.50 |
| 09-aws-keys/compile-full | 1 | 41.64 ± 0.2% | not timed | not timed | 8.29 ± 0.1% | 23.49 ± 1.3% | not timed | not timed | 41.50 ± 0.2% | | 1.00 | 5.02 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 187.69 ± 0.2% | not timed | not timed | 46.76 ± 0.4% | 135.66 ± 2.6% | not timed | not timed | 186.45 ± 1.2% | | 1.01 | 4.01 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.02 ± 0.6% | not timed | not timed | 11.15 ± 0.2% | 15.99 ± 17.9% | not timed | not timed | 14.00 ± 0.9% | | 1.00 | 1.26 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 83.74 ± 0.2% | not timed | not timed | 8.03 ± 0.4% | 24.11 ± 2.1% | not timed | not timed | 83.60 ± 0.3% | | 1.00 | 10.43 | 3.47 |
| 11-unstructured-to-json/compile | 1 | 85.17 ± 0.2% | not timed | not timed | 40.33 ± 0.3% | 68.90 ± 3.1% | not timed | not timed | 84.98 ± 1.0% | | 1.00 | 2.11 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 0.6% | 0.09 ± 19.4% | not timed | not timed | 0.35 ± 2.3% | | 1.00 | 5.05 | 3.75 |

