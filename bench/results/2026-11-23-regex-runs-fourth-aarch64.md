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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148056260 |
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
| literal: a word | 217 | 15817.21 ± 0.6% | 1039.61 ± 0.1% | 28.57 ± 0.2% | 17689.96 ± 1.9% | 9287.35 ± 8.0% | 17.45 ± 0.4% | 86.84 ± 0.2% | 15832.19 ± 0.8% | 15.21 | 1.00 | 0.89 | 1.70 |
| literal: a word that is not there | 0 | 18308.77 ± 2.1% | 1047.59 ± 0.3% | 28.61 ± 0.3% | 19258.13 ± 2.2% | 28510.10 ± 1.3% | 17.27 ± 0.3% | 82.68 ± 0.2% | 18422.96 ± 1.9% | 17.48 | 0.99 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6028.90 ± 0.5% | 1022.80 ± 0.2% | 14.68 ± 0.2% | 3936.11 ± 0.2% | 21.87 ± 0.1% | 5.29 ± 0.1% | 6.72 ± 0.6% | 6015.46 ± 0.2% | 5.89 | 1.00 | 1.53 | 275.72 |
| literal: a word in any case | 217 | 12541.63 ± 0.9% | 1040.16 ± 0.2% | 21.87 ± 2.1% | 3955.54 ± 0.6% | 38.03 ± 0.6% | refused | differs | 12536.99 ± 0.6% | 12.06 | 1.00 | 3.17 | 329.81 |
| literal: an href attribute | 33 | 13628.77 ± 1.2% | 1046.94 ± 0.2% | 27.30 ± 0.2% | 16650.60 ± 2.4% | 2252.08 ± 0.8% | 13.35 ± 0.1% | 75.53 ± 0.6% | 13540.88 ± 1.2% | 13.02 | 1.01 | 0.82 | 6.05 |
| literal: a word, second text | 123 | 16277.62 ± 1.7% | 1043.80 ± 0.1% | 28.29 ± 0.2% | 18272.72 ± 1.5% | 7621.86 ± 8.6% | 19.74 ± 0.4% | 69.83 ± 0.5% | 16395.93 ± 1.3% | 15.59 | 0.99 | 0.89 | 2.14 |
| class: two capitalized words | 1331 | 1104.94 ± 0.4% | 977.27 ± 0.3% | 26.17 ± 0.1% | 585.06 ± 0.1% | 40.56 ± 7.7% | 14.85 ± 0.2% | 68.77 ± 0.3% | 1104.11 ± 0.5% | 1.13 | 1.00 | 1.89 | 27.24 |
| class: a word that ends in ing | 3399 | 895.44 ± 0.3% | 895.40 ± 0.1% | 18.03 ± 0.4% | 547.98 ± 0.1% | 29.63 ± 5.1% | 8.13 ± 0.3% | 18.42 ± 0.3% | 894.17 ± 0.2% | 1.00 | 1.00 | 1.63 | 30.22 |
| class: a word in capitals | 2332 | 1453.30 ± 0.7% | 949.84 ± 0.3% | 27.90 ± 0.4% | 572.29 ± 0.1% | 43.52 ± 2.5% | 17.18 ± 0.6% | 83.35 ± 0.2% | 1453.25 ± 0.2% | 1.53 | 1.00 | 2.54 | 33.39 |
| class: a number | 8288 | 1992.22 ± 0.3% | 836.74 ± 0.0% | 28.06 ± 0.5% | 1720.00 ± 0.3% | 38.82 ± 15.1% | 0.54 ± 0.3% | 56.45 ± 0.7% | 1988.19 ± 0.2% | 2.38 | 1.00 | 1.16 | 51.32 |
| class: two capitalized words, second text | 5359 | 743.59 ± 0.4% | 744.63 ± 0.1% | 23.40 ± 0.2% | 481.22 ± 0.2% | 34.27 ± 14.4% | 16.48 ± 0.2% | 63.82 ± 0.6% | 743.02 ± 0.1% | 1.00 | 1.00 | 1.55 | 21.70 |
| other: a word between two words | 6104 | 751.80 ± 0.1% | 776.79 ± 0.1% | 23.55 ± 0.2% | 737.36 ± 0.4% | 104.40 ± 21.1% | 11.32 ± 0.3% | 69.84 ± 0.3% | 747.63 ± 0.1% | 0.97 | 1.01 | 1.02 | 7.20 |
| other: a number before a unit, second text | 1481 | 5441.66 ± 0.7% | 984.88 ± 0.1% | 26.07 ± 0.1% | 5626.43 ± 0.4% | 40.78 ± 15.3% | 17.87 ± 0.4% | 66.91 ± 0.2% | 5445.34 ± 0.6% | 5.53 | 1.00 | 0.97 | 133.43 |
| other: a heading's start tag | 110 | 12436.38 ± 1.7% | 1035.85 ± 0.3% | 27.58 ± 0.3% | 1711.81 ± 0.5% | 1584.02 ± 5.9% | 16.22 ± 0.6% | 89.07 ± 0.4% | 12455.54 ± 1.4% | 12.01 | 1.00 | 7.27 | 7.85 |
| other: a whole word | 217 | 13771.81 ± 1.7% | 1038.11 ± 0.4% | 29.63 ± 0.5% | 14190.97 ± 1.4% | 49.37 ± 0.2% | 13.69 ± 0.3% | 55.90 ± 0.4% | 13875.58 ± 1.0% | 13.27 | 0.99 | 0.97 | 278.92 |
| other: a line's first word, second text | 3716 | 1975.69 ± 0.5% | 876.99 ± 0.2% | 31.03 ± 0.4% | 1722.81 ± 0.3% | 61.74 ± 8.0% | refused | refused | 1963.76 ± 0.5% | 2.25 | 1.01 | 1.15 | 32.00 |
| other: fourteen octets before an x | 87 | 19288.38 ± 3.1% | 234.64 ± 0.4% | 6.59 ± 0.2% | 3980.44 ± 0.7% | 10.44 ± 0.3% | differs | 17.77 ± 0.2% | 19434.68 ± 2.0% | 82.20 | 0.99 | 4.85 | 1848.11 |
| other: a Greek word | 21815 | 513.81 ± 0.4% | 413.15 ± 0.1% | 31.20 ± 0.1% | 289.73 ± 0.1% | 43.61 ± 10.2% | differs | refused | 512.83 ± 0.6% | 1.24 | 1.00 | 1.77 | 11.78 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.85 ± 0.3% | 25.81 ± 0.2% | 0.87 ± 0.6% | 19.76 ± 0.2% | 2.78 ± 1.1% | differs | 4.00 ± 0.2% | 25.88 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.30 |
| a UUID | 32895 | 21.05 ± 0.2% | 21.15 ± 0.1% | 0.65 ± 0.1% | 15.13 ± 0.5% | 3.10 ± 0.1% | 0.72 ± 0.3% | 3.59 ± 0.5% | 21.16 ± 0.2% | 0.99 | 0.99 | 1.39 | 6.79 |
| an IPv4 address | 33176 | 36.83 ± 0.4% | 36.81 ± 0.2% | 2.10 ± 0.2% | 29.00 ± 0.3% | 6.68 ± 0.1% | differs | 4.16 ± 0.1% | 36.85 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.51 |
| a date and time | 32954 | 31.04 ± 0.2% | 31.22 ± 0.2% | 1.47 ± 0.3% | 21.14 ± 0.2% | 7.03 ± 0.1% | 1.20 ± 0.3% | 7.13 ± 0.2% | 31.19 ± 0.2% | 0.99 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.46 ± 0.1% | 29.35 ± 0.2% | 1.03 ± 0.1% | 23.02 ± 0.4% | 3.50 ± 0.8% | differs | 2.91 ± 0.2% | 29.42 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.46 ± 0.1% | 11.48 ± 0.4% | 11.44 ± 0.4% | 11.50 ± 0.2% | 4.94 ± 1.2% | 0.91 ± 0.4% | none | 11.50 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.09 ± 0.4% | 217.14 ± 0.3% | 251.35 ± 0.3% | 86.44 ± 0.4% | 219.77 ± 1.3% | 480.04 ± 1.5% | 3886.49 ± 0.9% | 216.08 ± 0.3% | 1.00 | 1.00 | 2.50 | 0.98 |
| a UUID | 62 | 142.37 ± 0.3% | 142.58 ± 0.1% | 156.92 ± 0.1% | 46.48 ± 0.6% | 98.85 ± 0.8% | 190.21 ± 2.8% | 4435.09 ± 0.9% | 142.30 ± 0.1% | 1.00 | 1.00 | 3.06 | 1.44 |
| an IPv4 address | 29 | 436.06 ± 0.5% | 440.33 ± 0.6% | 610.66 ± 0.7% | 77.04 ± 0.3% | 130.11 ± 1.1% | 302.62 ± 1.9% | 7679.05 ± 0.3% | 437.04 ± 0.3% | 0.99 | 1.00 | 5.66 | 3.35 |
| a date and time | 56 | 318.29 ± 0.5% | 320.25 ± 0.2% | 400.83 ± 0.1% | 73.11 ± 0.5% | 136.98 ± 1.4% | 324.75 ± 1.1% | 4935.93 ± 0.2% | 318.41 ± 0.2% | 0.99 | 1.00 | 4.35 | 2.32 |
| a field path | 39 | 202.60 ± 0.3% | 203.26 ± 0.2% | 233.01 ± 0.1% | 81.09 ± 1.1% | 204.02 ± 1.6% | 498.26 ± 3.3% | 4978.60 ± 0.7% | 202.60 ± 0.3% | 1.00 | 1.00 | 2.50 | 0.99 |
| literal: a word | 7 | 659.92 ± 0.5% | 711.43 ± 0.7% | 1274.05 ± 0.7% | 522.42 ± 0.3% | 627.08 ± 0.6% | 956.44 ± 0.6% | 30873.20 ± 0.0% | 659.44 ± 0.7% | 0.93 | 1.00 | 1.26 | 1.05 |
| literal: a word that is not there | 8 | 630.45 ± 0.4% | 686.49 ± 0.4% | 1202.20 ± 0.1% | 482.47 ± 0.4% | 598.94 ± 2.7% | 905.94 ± 0.6% | 29448.82 ± 0.1% | 631.00 ± 0.3% | 0.92 | 1.00 | 1.31 | 1.05 |
| literal: one of four words | 26 | 254.44 ± 0.2% | 418.48 ± 0.7% | 563.79 ± 0.8% | 50.14 ± 1.2% | 242.09 ± 2.6% | 374.35 ± 1.6% | 15810.28 ± 0.2% | 254.51 ± 0.4% | 0.61 | 1.00 | 5.07 | 1.05 |
| literal: a word in any case | 11 | 517.26 ± 0.7% | 560.13 ± 0.2% | 863.58 ± 0.4% | 15.90 ± 1.6% | 643.26 ± 1.9% | refused | 23625.88 ± 0.9% | 517.29 ± 0.2% | 0.92 | 1.00 | 32.54 | 0.80 |
| literal: an href attribute | 12 | 349.34 ± 0.2% | 360.48 ± 0.4% | 471.38 ± 0.3% | 45.83 ± 0.4% | 497.61 ± 1.1% | 773.42 ± 0.4% | 22180.98 ± 0.3% | 349.36 ± 0.5% | 0.97 | 1.00 | 7.62 | 0.70 |
| literal: a word, second text | 10 | 588.28 ± 0.4% | 649.79 ± 1.0% | 1086.77 ± 0.7% | 401.28 ± 0.2% | 531.36 ± 2.0% | 800.29 ± 0.2% | 27408.43 ± 0.1% | 587.78 ± 0.1% | 0.91 | 1.00 | 1.47 | 1.11 |
| class: two capitalized words | 23 | 457.55 ± 0.4% | 487.38 ± 0.4% | 704.79 ± 0.2% | 100.12 ± 0.5% | 503.08 ± 0.6% | 741.38 ± 0.6% | 6617.02 ± 0.1% | 457.31 ± 0.5% | 0.94 | 1.00 | 4.57 | 0.91 |
| class: a word that ends in ing | 9 | 595.35 ± 0.3% | 662.70 ± 0.2% | 1163.91 ± 0.1% | 132.47 ± 1.9% | 757.04 ± 1.2% | 1107.18 ± 0.7% | 16309.62 ± 0.1% | 594.13 ± 0.3% | 0.90 | 1.00 | 4.49 | 0.79 |
| class: a word in capitals | 16 | 518.04 ± 0.3% | 555.78 ± 0.2% | 880.18 ± 0.5% | 135.42 ± 0.6% | 751.91 ± 1.2% | 1027.58 ± 0.7% | 8701.86 ± 0.1% | 518.23 ± 0.4% | 0.93 | 1.00 | 3.83 | 0.69 |
| class: a number | 6 | 651.87 ± 0.2% | 714.40 ± 0.9% | 1329.38 ± 0.1% | 41.86 ± 0.6% | 1402.83 ± 3.2% | 1862.64 ± 1.7% | 23103.24 ± 0.2% | 652.23 ± 0.3% | 0.91 | 1.00 | 15.57 | 0.46 |
| class: two capitalized words, second text | 23 | 456.49 ± 0.5% | 485.17 ± 0.4% | 703.93 ± 0.4% | 101.72 ± 0.4% | 502.75 ± 1.4% | 762.73 ± 0.5% | 6617.96 ± 0.3% | 456.88 ± 0.3% | 0.94 | 1.00 | 4.49 | 0.91 |
| other: a word between two words | 13 | 577.51 ± 0.5% | 596.18 ± 0.4% | 949.05 ± 0.2% | 133.46 ± 0.6% | 499.68 ± 0.8% | 813.08 ± 1.0% | 15091.54 ± 0.1% | 577.74 ± 0.4% | 0.97 | 1.00 | 4.33 | 1.16 |
| other: a number before a unit, second text | 15 | 399.66 ± 0.3% | 432.27 ± 0.7% | 595.17 ± 0.6% | 39.59 ± 0.3% | 631.70 ± 1.1% | 889.29 ± 1.0% | 15395.61 ± 0.2% | 399.68 ± 0.2% | 0.92 | 1.00 | 10.10 | 0.63 |
| other: a heading's start tag | 13 | 358.60 ± 0.1% | 363.56 ± 0.3% | 473.23 ± 0.5% | 43.77 ± 0.4% | 623.42 ± 1.4% | 878.97 ± 0.6% | 18488.89 ± 0.4% | 358.49 ± 0.4% | 0.99 | 1.00 | 8.19 | 0.58 |
| other: a whole word | 11 | 611.25 ± 0.2% | 649.57 ± 0.5% | 1086.74 ± 0.6% | 118.21 ± 0.6% | 558.54 ± 2.7% | 836.74 ± 0.4% | 26985.50 ± 0.3% | 610.91 ± 0.5% | 0.94 | 1.00 | 5.17 | 1.09 |
| other: a line's first word, second text | 17 | 553.25 ± 0.5% | 574.82 ± 0.6% | 917.28 ± 0.3% | 129.14 ± 0.1% | 710.98 ± 1.2% | refused | refused | 551.34 ± 0.6% | 0.96 | 1.00 | 4.28 | 0.78 |
| other: fourteen octets before an x | 16 | 112.65 ± 0.2% | 162.37 ± 0.6% | 185.78 ± 0.7% | 14.98 ± 0.5% | 451.94 ± 2.3% | 413.22 ± 0.5% | 12805.29 ± 1.0% | 112.45 ± 0.4% | 0.69 | 1.00 | 7.52 | 0.25 |
| other: a Greek word | 8 | 447.50 ± 0.5% | 586.58 ± 0.4% | 954.55 ± 0.2% | 59.19 ± 0.3% | 1381.82 ± 0.7% | 1799.00 ± 0.6% | refused | 447.71 ± 0.3% | 0.76 | 1.00 | 7.56 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12761.44 ± 1.0% | not timed | not timed | 16089.40 ± 1.8% | 2040.24 ± 19.6% | not timed | not timed | 12717.61 ± 0.8% | | 1.00 | 0.79 | 6.25 |
| 01-literal/sherlock-casei-en | 522 | 4488.84 ± 0.9% | not timed | not timed | 3588.49 ± 0.4% | 32.55 ± 0.2% | not timed | not timed | 4491.60 ± 0.5% | | 1.00 | 1.25 | 137.91 |
| 01-literal/sherlock-ru | 724 | 13549.18 ± 0.4% | not timed | not timed | 17332.44 ± 0.3% | 1421.01 ± 11.8% | not timed | not timed | 13535.12 ± 0.1% | | 1.00 | 0.78 | 9.53 |
| 01-literal/sherlock-casei-ru | 746 | 5293.82 ± 0.6% | not timed | not timed | 3332.92 ± 0.4% | 31.64 ± 1.4% | not timed | not timed | 5296.61 ± 0.8% | | 1.00 | 1.59 | 167.29 |
| 01-literal/sherlock-zh | 30 | 16786.72 ± 0.7% | not timed | not timed | 18263.20 ± 0.9% | 2584.11 ± 6.5% | not timed | not timed | 16675.78 ± 0.7% | | 1.01 | 0.92 | 6.50 |
| 02-literal-alternate/sherlock-en | 714 | 5749.30 ± 0.3% | not timed | not timed | 3940.47 ± 0.2% | 16.61 ± 0.2% | not timed | not timed | 5758.42 ± 0.3% | | 1.00 | 1.46 | 346.06 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1716.24 ± 1.2% | not timed | not timed | 696.11 ± 0.5% | 11.13 ± 0.2% | not timed | not timed | 1704.88 ± 0.9% | | 1.01 | 2.47 | 154.17 |
| 02-literal-alternate/sherlock-ru | 899 | 4653.88 ± 0.2% | not timed | not timed | 3254.46 ± 0.1% | 22.59 ± 4.2% | not timed | not timed | 4650.10 ± 0.2% | | 1.00 | 1.43 | 205.98 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1813.41 ± 0.4% | not timed | not timed | 1232.71 ± 0.2% | 9.12 ± 0.2% | not timed | not timed | 1807.80 ± 0.2% | | 1.00 | 1.47 | 198.75 |
| 02-literal-alternate/sherlock-zh | 207 | 7047.46 ± 0.6% | not timed | not timed | 4163.96 ± 0.1% | 31.37 ± 0.3% | not timed | not timed | 7038.10 ± 0.3% | | 1.00 | 1.69 | 224.65 |
| 03-date/ascii | 111817 | 127.50 ± 0.3% | not timed | not timed | 96.24 ± 0.1% | 0.20 ± 5.4% | not timed | not timed | 126.77 ± 1.0% | | 1.01 | 1.32 | 625.37 |
| 04-ruff-noqa/real | 84 | 553.70 ± 0.1% | not timed | not timed | 461.73 ± 0.2% | 19.73 ± 1.2% | not timed | not timed | 553.24 ± 0.1% | | 1.00 | 1.20 | 28.07 |
| 04-ruff-noqa/tweaked | 44 | 549.71 ± 0.2% | not timed | not timed | 460.71 ± 0.1% | 364.71 ± 1.5% | not timed | not timed | 547.97 ± 0.2% | | 1.00 | 1.19 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.23 ± 0.3% | not timed | not timed | 4.95 ± 0.1% | 0.20 ± 3.3% | not timed | not timed | 3.25 ± 0.3% | | 0.99 | 0.65 | 16.03 |
| 06-cloud-flare-redos/original | 107 | 263.83 ± 0.2% | not timed | not timed | 216.62 ± 0.1% | 24.38 ± 0.2% | not timed | not timed | 263.59 ± 0.3% | | 1.00 | 1.22 | 10.82 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.36 ± 0.0% | not timed | not timed | 228.79 ± 0.1% | 26.67 ± 0.1% | not timed | not timed | 259.28 ± 0.3% | | 1.00 | 1.13 | 9.72 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.20 ± 0.3% | not timed | not timed | 255.74 ± 0.1% | 28.84 ± 0.1% | not timed | not timed | 286.30 ± 0.3% | | 1.00 | 1.12 | 9.92 |
| 07-unicode-character-data/parse-line | 558784 | 239.14 ± 0.7% | not timed | not timed | 170.90 ± 0.1% | 43.04 ± 6.2% | not timed | not timed | 238.49 ± 2.5% | | 1.00 | 1.40 | 5.56 |
| 08-words/all-english | 56691 | 121.12 ± 0.5% | not timed | not timed | 82.88 ± 0.1% | 12.85 ± 4.3% | not timed | not timed | 120.60 ± 0.7% | | 1.00 | 1.46 | 9.43 |
| 08-words/long-english | 839 | 1007.05 ± 0.1% | not timed | not timed | 596.90 ± 0.0% | 32.41 ± 11.1% | not timed | not timed | 1006.27 ± 0.2% | | 1.00 | 1.69 | 31.07 |
| 09-aws-keys/full | 0 | 408.97 ± 0.1% | not timed | not timed | 465.98 ± 0.2% | 64.59 ± 3.4% | not timed | not timed | 408.48 ± 0.2% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 736.07 ± 0.2% | not timed | not timed | 983.81 ± 0.2% | 417.19 ± 0.4% | not timed | not timed | 734.07 ± 0.3% | | 1.00 | 0.75 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 639.17 ± 0.4% | not timed | not timed | 518.52 ± 0.7% | 19.53 ± 0.4% | not timed | not timed | 636.55 ± 0.3% | | 1.00 | 1.23 | 32.72 |
| 10-bounded-repeat/letters-ru | 3475 | 385.34 ± 0.2% | not timed | not timed | 477.73 ± 0.1% | 21.78 ± 12.1% | not timed | not timed | 383.86 ± 0.5% | | 1.00 | 0.81 | 17.69 |
| 10-bounded-repeat/context | 53 | 78.55 ± 1.2% | not timed | not timed | 65.64 ± 0.9% | 19.81 ± 0.2% | not timed | not timed | 78.83 ± 1.1% | | 1.00 | 1.20 | 3.96 |
| 10-bounded-repeat/capitals | 11 | 1041.76 ± 0.1% | not timed | not timed | 615.61 ± 0.1% | 36.56 ± 0.1% | not timed | not timed | 1040.80 ± 0.1% | | 1.00 | 1.69 | 28.50 |
| 11-unstructured-to-json/extract | 600 | 49.80 ± 0.1% | not timed | not timed | 77.32 ± 0.2% | 48.98 ± 0.9% | not timed | not timed | 49.45 ± 0.8% | | 1.01 | 0.64 | 1.02 |
| 12-dictionary/single | 1 | 567.21 ± 0.2% | not timed | not timed | 561.29 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 566.74 ± 0.2% | | 1.00 | 1.01 | 1408.31 |
| 14-quadratic/1x | 100 | 9.67 ± 0.5% | not timed | not timed | 10.04 ± 0.3% | 0.96 ± 2.6% | not timed | not timed | 9.68 ± 0.8% | | 1.00 | 0.96 | 10.04 |
| 14-quadratic/2x | 200 | 5.57 ± 0.2% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.9% | not timed | not timed | 5.56 ± 0.7% | | 1.00 | 1.00 | 10.42 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.5% | not timed | not timed | 1.21 ± 0.6% | 0.12 ± 1.9% | not timed | not timed | 1.26 ± 0.4% | | 1.00 | 1.04 | 10.90 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.34 ± 11.2% | 0.54 ± 11.5% | not timed | not timed | 1.53 ± 1.1% | | 1.01 | 4.53 | 2.85 |
| 04-ruff-noqa/compile-real | 1 | 85.37 ± 0.3% | not timed | not timed | 13.84 ± 0.3% | 138.02 ± 0.9% | not timed | not timed | 84.93 ± 1.3% | | 1.01 | 6.17 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.52 ± 0.2% | not timed | not timed | 2.52 ± 0.5% | 6.41 ± 2.2% | not timed | not timed | 14.46 ± 1.3% | | 1.00 | 5.75 | 2.27 |
| 07-unicode-character-data/compile | 1 | 55.03 ± 1.9% | not timed | not timed | 25.93 ± 0.2% | 35.70 ± 5.0% | not timed | not timed | 54.77 ± 1.5% | | 1.00 | 2.12 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.26 ± 0.3% | not timed | not timed | 8.26 ± 0.2% | 23.01 ± 16.8% | not timed | not timed | 41.82 ± 0.7% | | 1.01 | 5.12 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 188.81 ± 0.4% | not timed | not timed | 47.07 ± 0.1% | 134.20 ± 2.7% | not timed | not timed | 188.53 ± 1.1% | | 1.00 | 4.01 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.60 ± 0.6% | not timed | not timed | 11.19 ± 0.8% | 15.86 ± 18.2% | not timed | not timed | 14.59 ± 1.1% | | 1.00 | 1.30 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.16 ± 0.8% | not timed | not timed | 8.14 ± 0.3% | 23.73 ± 3.0% | not timed | not timed | 84.80 ± 0.6% | | 1.00 | 10.47 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 86.27 ± 0.3% | not timed | not timed | 40.85 ± 0.3% | 67.84 ± 1.8% | not timed | not timed | 85.79 ± 1.0% | | 1.01 | 2.11 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 1.0% | 0.09 ± 14.8% | not timed | not timed | 0.36 ± 2.7% | | 1.01 | 5.28 | 3.82 |

