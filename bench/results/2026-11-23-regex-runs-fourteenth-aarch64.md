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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148116252 |
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
| literal: a word | 217 | 16096.81 ± 0.9% | 1040.61 ± 0.2% | 28.09 ± 0.3% | 18074.65 ± 1.1% | 8877.33 ± 9.5% | 17.35 ± 0.5% | 87.13 ± 0.2% | 16031.87 ± 3.0% | 15.47 | 1.00 | 0.89 | 1.81 |
| literal: a word that is not there | 0 | 18634.93 ± 0.9% | 1048.63 ± 0.1% | 28.05 ± 0.2% | 19786.64 ± 1.9% | 29036.01 ± 1.0% | 17.22 ± 0.1% | 83.02 ± 0.2% | 18758.21 ± 0.5% | 17.77 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6057.92 ± 0.5% | 1023.40 ± 0.3% | 14.56 ± 0.1% | 3947.51 ± 0.2% | 21.87 ± 0.1% | 5.25 ± 0.1% | 6.73 ± 0.4% | 6025.80 ± 0.7% | 5.92 | 1.01 | 1.53 | 276.96 |
| literal: a word in any case | 217 | 12603.47 ± 0.2% | 1040.27 ± 0.2% | 21.07 ± 1.3% | 3972.40 ± 0.2% | 37.93 ± 0.2% | refused | differs | 12605.43 ± 0.2% | 12.12 | 1.00 | 3.17 | 332.28 |
| literal: an href attribute | 33 | 13850.65 ± 0.8% | 1047.65 ± 0.2% | 27.02 ± 0.3% | 17259.09 ± 1.4% | 2263.33 ± 1.9% | 13.32 ± 0.5% | 76.11 ± 0.2% | 13856.06 ± 0.9% | 13.22 | 1.00 | 0.80 | 6.12 |
| literal: a word, second text | 123 | 16283.73 ± 0.7% | 1043.57 ± 0.1% | 27.80 ± 0.2% | 18285.14 ± 1.2% | 7678.00 ± 6.7% | 19.55 ± 1.1% | 71.22 ± 0.8% | 16316.40 ± 0.2% | 15.60 | 1.00 | 0.89 | 2.12 |
| class: two capitalized words | 1331 | 1089.65 ± 0.2% | 977.09 ± 0.4% | 25.78 ± 0.3% | 585.67 ± 0.4% | 40.53 ± 0.2% | 14.74 ± 0.1% | 68.84 ± 0.2% | 1106.38 ± 0.3% | 1.12 | 0.98 | 1.86 | 26.88 |
| class: a word that ends in ing | 3399 | 895.34 ± 0.1% | 895.08 ± 0.1% | 17.96 ± 0.5% | 548.14 ± 0.1% | 29.63 ± 9.7% | 8.16 ± 0.2% | 18.39 ± 0.4% | 894.58 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.22 |
| class: a word in capitals | 2332 | 1455.75 ± 0.3% | 949.50 ± 0.4% | 27.50 ± 0.1% | 572.57 ± 0.1% | 43.51 ± 13.8% | 17.08 ± 0.3% | 83.07 ± 0.3% | 1455.86 ± 0.2% | 1.53 | 1.00 | 2.54 | 33.46 |
| class: a number | 8288 | 2002.12 ± 0.2% | 836.74 ± 0.1% | 27.60 ± 0.3% | 1725.35 ± 0.1% | 42.74 ± 8.7% | 0.55 ± 0.2% | 56.45 ± 0.7% | 1996.47 ± 0.1% | 2.39 | 1.00 | 1.16 | 46.85 |
| class: two capitalized words, second text | 5359 | 743.83 ± 0.2% | 743.77 ± 0.1% | 23.16 ± 0.1% | 484.49 ± 0.1% | 35.29 ± 15.1% | 16.69 ± 0.3% | 63.70 ± 0.8% | 743.42 ± 0.2% | 1.00 | 1.00 | 1.54 | 21.08 |
| other: a word between two words | 6104 | 752.94 ± 0.1% | 777.11 ± 0.1% | 23.35 ± 0.3% | 739.89 ± 0.4% | 109.58 ± 10.0% | 11.26 ± 0.1% | 70.12 ± 0.2% | 754.17 ± 0.1% | 0.97 | 1.00 | 1.02 | 6.87 |
| other: a number before a unit, second text | 1481 | 5466.31 ± 0.3% | 985.20 ± 0.5% | 25.75 ± 0.1% | 5625.08 ± 0.5% | 40.69 ± 0.2% | 17.85 ± 0.1% | 66.99 ± 0.1% | 5433.76 ± 0.4% | 5.55 | 1.01 | 0.97 | 134.33 |
| other: a heading's start tag | 110 | 12692.01 ± 1.0% | 1037.03 ± 0.1% | 27.17 ± 0.3% | 1712.63 ± 0.2% | 1589.74 ± 8.5% | 16.16 ± 0.6% | 89.15 ± 0.3% | 12695.77 ± 0.4% | 12.24 | 1.00 | 7.41 | 7.98 |
| other: a whole word | 217 | 14104.81 ± 1.6% | 1038.77 ± 0.2% | 29.17 ± 0.3% | 14632.98 ± 1.8% | 49.41 ± 0.2% | 13.42 ± 0.3% | 56.10 ± 0.3% | 14138.72 ± 1.9% | 13.58 | 1.00 | 0.96 | 285.49 |
| other: a line's first word, second text | 3716 | 1973.70 ± 0.9% | 876.47 ± 0.2% | 30.44 ± 0.1% | 1717.97 ± 0.3% | 62.77 ± 6.7% | refused | refused | 1963.55 ± 0.4% | 2.25 | 1.01 | 1.15 | 31.44 |
| other: fourteen octets before an x | 87 | 19655.47 ± 1.6% | 240.39 ± 0.8% | 6.58 ± 0.2% | 4010.06 ± 0.1% | 10.60 ± 0.3% | differs | 17.76 ± 0.5% | 19776.10 ± 1.9% | 81.77 | 0.99 | 4.90 | 1854.16 |
| other: a Greek word | 21815 | 513.21 ± 0.3% | 414.01 ± 0.3% | 31.01 ± 0.3% | 289.61 ± 0.3% | 47.48 ± 9.2% | differs | refused | 511.83 ± 0.2% | 1.24 | 1.00 | 1.77 | 10.81 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.3% | 25.89 ± 0.2% | 0.87 ± 0.3% | 19.81 ± 0.2% | 2.77 ± 0.4% | differs | 3.99 ± 1.1% | 25.84 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.35 |
| a UUID | 32895 | 21.08 ± 0.2% | 21.14 ± 0.1% | 0.65 ± 0.1% | 15.21 ± 0.2% | 3.11 ± 0.5% | 0.71 ± 0.6% | 3.59 ± 0.6% | 21.15 ± 0.3% | 1.00 | 1.00 | 1.39 | 6.78 |
| an IPv4 address | 33176 | 36.89 ± 0.2% | 36.81 ± 0.2% | 2.11 ± 0.5% | 28.95 ± 0.2% | 6.63 ± 0.1% | differs | 4.17 ± 0.1% | 36.85 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.56 |
| a date and time | 32954 | 31.14 ± 0.6% | 31.26 ± 0.6% | 1.47 ± 0.3% | 21.17 ± 0.1% | 7.07 ± 0.2% | 1.20 ± 0.1% | 7.10 ± 0.5% | 31.11 ± 0.5% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.48 ± 0.2% | 29.37 ± 0.2% | 1.03 ± 0.2% | 23.05 ± 0.1% | 3.45 ± 1.0% | differs | 2.92 ± 0.2% | 29.43 ± 0.4% | 1.00 | 1.00 | 1.28 | 8.53 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.43 ± 0.1% | 11.12 ± 0.3% | 11.50 ± 0.5% | 11.43 ± 0.2% | 4.92 ± 3.2% | 0.90 ± 0.6% | none | 11.39 ± 0.2% | 1.03 | 1.00 | 1.00 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.33 ± 0.3% | 221.23 ± 0.3% | 257.16 ± 0.2% | 86.81 ± 0.5% | 215.41 ± 2.5% | 480.88 ± 1.3% | 3876.37 ± 2.3% | 220.55 ± 0.2% | 1.00 | 1.00 | 2.54 | 1.02 |
| a UUID | 62 | 145.34 ± 0.2% | 145.71 ± 0.1% | 160.87 ± 0.1% | 46.62 ± 0.6% | 99.84 ± 0.5% | 190.08 ± 2.8% | 4411.35 ± 1.6% | 145.28 ± 0.1% | 1.00 | 1.00 | 3.12 | 1.46 |
| an IPv4 address | 29 | 436.78 ± 1.0% | 440.98 ± 0.3% | 610.79 ± 0.2% | 77.42 ± 0.4% | 131.79 ± 0.8% | 301.90 ± 1.7% | 7649.99 ± 0.1% | 436.99 ± 0.5% | 0.99 | 1.00 | 5.64 | 3.31 |
| a date and time | 56 | 318.45 ± 0.5% | 319.72 ± 0.2% | 400.29 ± 0.1% | 73.39 ± 0.4% | 137.99 ± 1.4% | 324.91 ± 0.9% | 4947.28 ± 0.5% | 318.36 ± 0.1% | 1.00 | 1.00 | 4.34 | 2.31 |
| a field path | 39 | 208.38 ± 0.3% | 209.14 ± 0.4% | 241.21 ± 0.2% | 81.09 ± 1.4% | 206.64 ± 0.8% | 499.56 ± 3.0% | 4970.02 ± 0.8% | 208.52 ± 0.1% | 1.00 | 1.00 | 2.57 | 1.01 |
| literal: a word | 7 | 660.27 ± 0.4% | 710.51 ± 0.3% | 1261.81 ± 0.2% | 529.59 ± 0.2% | 627.05 ± 1.9% | 953.78 ± 0.6% | 30571.62 ± 0.3% | 660.41 ± 0.2% | 0.93 | 1.00 | 1.25 | 1.05 |
| literal: a word that is not there | 8 | 631.14 ± 0.4% | 684.41 ± 0.1% | 1185.89 ± 0.1% | 487.11 ± 0.1% | 598.98 ± 3.1% | 904.92 ± 0.1% | 29582.08 ± 0.1% | 631.51 ± 0.1% | 0.92 | 1.00 | 1.30 | 1.05 |
| literal: one of four words | 26 | 253.34 ± 0.7% | 415.84 ± 0.2% | 562.14 ± 0.3% | 50.25 ± 1.3% | 240.98 ± 1.3% | 374.26 ± 1.0% | 15887.06 ± 0.1% | 253.83 ± 0.6% | 0.61 | 1.00 | 5.04 | 1.05 |
| literal: a word in any case | 11 | 518.08 ± 0.4% | 558.41 ± 0.4% | 862.24 ± 0.4% | 15.90 ± 1.5% | 654.26 ± 6.4% | refused | 23854.38 ± 0.2% | 517.16 ± 0.3% | 0.93 | 1.00 | 32.57 | 0.79 |
| literal: an href attribute | 12 | 351.25 ± 0.2% | 363.14 ± 0.5% | 472.52 ± 0.5% | 45.90 ± 0.5% | 493.45 ± 2.1% | 775.36 ± 0.7% | 22477.03 ± 0.1% | 350.78 ± 0.4% | 0.97 | 1.00 | 7.65 | 0.71 |
| literal: a word, second text | 10 | 587.47 ± 0.8% | 645.09 ± 0.6% | 1076.57 ± 0.1% | 404.81 ± 0.2% | 534.14 ± 3.3% | 801.71 ± 0.5% | 27646.08 ± 0.3% | 586.88 ± 0.2% | 0.91 | 1.00 | 1.45 | 1.10 |
| class: two capitalized words | 23 | 458.66 ± 0.5% | 488.16 ± 0.4% | 703.35 ± 0.7% | 100.64 ± 0.1% | 494.79 ± 1.1% | 740.66 ± 0.4% | 6648.17 ± 0.2% | 459.07 ± 0.4% | 0.94 | 1.00 | 4.56 | 0.93 |
| class: a word that ends in ing | 9 | 594.52 ± 0.7% | 659.18 ± 0.9% | 1155.18 ± 1.2% | 132.91 ± 2.0% | 744.73 ± 1.8% | 1108.45 ± 0.4% | 16303.80 ± 0.2% | 593.08 ± 0.5% | 0.90 | 1.00 | 4.47 | 0.80 |
| class: a word in capitals | 16 | 521.12 ± 0.8% | 560.45 ± 0.2% | 896.40 ± 0.3% | 135.59 ± 0.5% | 727.44 ± 2.3% | 1023.62 ± 1.0% | 8728.14 ± 0.1% | 522.13 ± 0.2% | 0.93 | 1.00 | 3.84 | 0.72 |
| class: a number | 6 | 660.02 ± 0.2% | 721.71 ± 0.8% | 1341.98 ± 0.1% | 41.92 ± 0.4% | 1379.87 ± 2.3% | 1856.72 ± 1.3% | 23350.84 ± 0.1% | 659.23 ± 0.3% | 0.91 | 1.00 | 15.75 | 0.48 |
| class: two capitalized words, second text | 23 | 458.44 ± 0.1% | 487.82 ± 0.9% | 703.58 ± 0.8% | 102.01 ± 0.4% | 491.45 ± 6.3% | 760.80 ± 0.6% | 6651.51 ± 0.5% | 458.32 ± 0.3% | 0.94 | 1.00 | 4.49 | 0.93 |
| other: a word between two words | 13 | 574.12 ± 0.4% | 593.94 ± 0.9% | 941.23 ± 0.2% | 134.08 ± 0.7% | 492.83 ± 2.5% | 810.75 ± 0.6% | 15084.83 ± 0.1% | 574.47 ± 0.7% | 0.97 | 1.00 | 4.28 | 1.16 |
| other: a number before a unit, second text | 15 | 401.79 ± 0.5% | 435.82 ± 0.5% | 601.54 ± 0.4% | 39.68 ± 0.5% | 612.98 ± 3.7% | 890.66 ± 1.1% | 15417.36 ± 0.2% | 401.74 ± 0.4% | 0.92 | 1.00 | 10.13 | 0.66 |
| other: a heading's start tag | 13 | 360.85 ± 0.3% | 365.14 ± 0.5% | 477.19 ± 0.1% | 44.02 ± 0.5% | 611.67 ± 10.9% | 870.41 ± 1.1% | 18532.07 ± 0.4% | 360.70 ± 0.3% | 0.99 | 1.00 | 8.20 | 0.59 |
| other: a whole word | 11 | 607.34 ± 0.3% | 643.74 ± 0.6% | 1071.35 ± 0.9% | 118.63 ± 0.5% | 550.70 ± 2.4% | 835.59 ± 0.9% | 27247.49 ± 1.1% | 606.52 ± 2.0% | 0.94 | 1.00 | 5.12 | 1.10 |
| other: a line's first word, second text | 17 | 554.51 ± 0.4% | 575.12 ± 0.2% | 921.69 ± 0.2% | 129.62 ± 0.2% | 693.64 ± 21.5% | refused | refused | 551.78 ± 1.2% | 0.96 | 1.00 | 4.28 | 0.80 |
| other: fourteen octets before an x | 16 | 112.95 ± 0.4% | 163.12 ± 0.3% | 186.39 ± 0.3% | 15.25 ± 0.2% | 440.97 ± 2.3% | 411.75 ± 0.6% | 12906.78 ± 1.5% | 112.91 ± 0.4% | 0.69 | 1.00 | 7.41 | 0.26 |
| other: a Greek word | 8 | 447.09 ± 0.3% | 586.66 ± 0.5% | 951.33 ± 0.1% | 59.23 ± 0.3% | 1366.60 ± 6.9% | 1785.77 ± 0.5% | refused | 446.87 ± 0.3% | 0.76 | 1.00 | 7.55 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12822.61 ± 0.3% | not timed | not timed | 16126.32 ± 1.0% | 2113.59 ± 15.9% | not timed | not timed | 12862.81 ± 0.5% | | 1.00 | 0.80 | 6.07 |
| 01-literal/sherlock-casei-en | 522 | 4483.66 ± 3.3% | not timed | not timed | 3591.69 ± 0.2% | 32.47 ± 0.1% | not timed | not timed | 4485.21 ± 1.8% | | 1.00 | 1.25 | 138.09 |
| 01-literal/sherlock-ru | 724 | 13523.93 ± 0.4% | not timed | not timed | 17315.83 ± 0.4% | 1468.34 ± 19.3% | not timed | not timed | 13513.56 ± 1.1% | | 1.00 | 0.78 | 9.21 |
| 01-literal/sherlock-casei-ru | 746 | 5286.17 ± 0.1% | not timed | not timed | 3331.10 ± 0.1% | 31.30 ± 0.4% | not timed | not timed | 5290.86 ± 0.1% | | 1.00 | 1.59 | 168.88 |
| 01-literal/sherlock-zh | 30 | 16850.14 ± 0.4% | not timed | not timed | 18401.20 ± 0.7% | 2824.62 ± 10.4% | not timed | not timed | 16869.36 ± 0.4% | | 1.00 | 0.92 | 5.97 |
| 02-literal-alternate/sherlock-en | 714 | 5753.43 ± 0.2% | not timed | not timed | 3943.41 ± 0.2% | 16.57 ± 0.1% | not timed | not timed | 5761.93 ± 0.4% | | 1.00 | 1.46 | 347.17 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.34 ± 1.0% | not timed | not timed | 693.86 ± 0.2% | 11.00 ± 1.0% | not timed | not timed | 1703.49 ± 0.2% | | 1.00 | 2.47 | 155.51 |
| 02-literal-alternate/sherlock-ru | 899 | 4639.10 ± 0.2% | not timed | not timed | 3254.24 ± 0.1% | 22.22 ± 0.5% | not timed | not timed | 4637.37 ± 0.1% | | 1.00 | 1.43 | 208.81 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1812.72 ± 0.5% | not timed | not timed | 1230.79 ± 0.2% | 9.09 ± 0.0% | not timed | not timed | 1801.50 ± 0.2% | | 1.01 | 1.47 | 199.42 |
| 02-literal-alternate/sherlock-zh | 207 | 7042.56 ± 0.2% | not timed | not timed | 4161.79 ± 1.0% | 30.84 ± 8.3% | not timed | not timed | 7038.10 ± 0.7% | | 1.00 | 1.69 | 228.33 |
| 03-date/ascii | 111817 | 127.68 ± 0.8% | not timed | not timed | 96.24 ± 0.1% | 0.20 ± 4.5% | not timed | not timed | 126.70 ± 1.0% | | 1.01 | 1.33 | 629.41 |
| 04-ruff-noqa/real | 84 | 553.50 ± 0.1% | not timed | not timed | 461.39 ± 0.1% | 19.59 ± 1.1% | not timed | not timed | 553.66 ± 0.1% | | 1.00 | 1.20 | 28.26 |
| 04-ruff-noqa/tweaked | 44 | 546.88 ± 0.2% | not timed | not timed | 461.78 ± 0.1% | 363.70 ± 0.8% | not timed | not timed | 544.91 ± 0.1% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.97 ± 0.5% | not timed | not timed | 5.08 ± 0.5% | 0.21 ± 2.6% | not timed | not timed | 4.16 ± 2.2% | | 0.95 | 0.78 | 19.20 |
| 06-cloud-flare-redos/original | 107 | 263.74 ± 0.2% | not timed | not timed | 217.63 ± 0.0% | 24.83 ± 0.3% | not timed | not timed | 263.47 ± 0.1% | | 1.00 | 1.21 | 10.62 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.58 ± 0.3% | not timed | not timed | 228.79 ± 0.1% | 26.70 ± 0.0% | not timed | not timed | 259.55 ± 0.2% | | 1.00 | 1.13 | 9.72 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.03 ± 0.2% | not timed | not timed | 256.25 ± 0.3% | 28.83 ± 0.1% | not timed | not timed | 286.48 ± 0.3% | | 1.00 | 1.12 | 9.92 |
| 07-unicode-character-data/parse-line | 558784 | 239.97 ± 2.1% | not timed | not timed | 170.62 ± 0.1% | 42.05 ± 6.4% | not timed | not timed | 239.87 ± 0.7% | | 1.00 | 1.41 | 5.71 |
| 08-words/all-english | 56691 | 121.12 ± 0.2% | not timed | not timed | 82.86 ± 0.1% | 12.70 ± 11.8% | not timed | not timed | 120.51 ± 0.6% | | 1.01 | 1.46 | 9.53 |
| 08-words/long-english | 839 | 1006.53 ± 0.1% | not timed | not timed | 597.78 ± 0.0% | 32.51 ± 0.3% | not timed | not timed | 1006.06 ± 0.0% | | 1.00 | 1.68 | 30.96 |
| 09-aws-keys/full | 0 | 409.54 ± 0.1% | not timed | not timed | 461.03 ± 0.2% | 64.66 ± 3.5% | not timed | not timed | 409.51 ± 0.0% | | 1.00 | 0.89 | 6.33 |
| 09-aws-keys/quick | 0 | 728.05 ± 0.2% | not timed | not timed | 987.71 ± 0.1% | 418.78 ± 2.0% | not timed | not timed | 732.48 ± 0.0% | | 0.99 | 0.74 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 639.69 ± 0.5% | not timed | not timed | 517.12 ± 0.6% | 19.40 ± 0.5% | not timed | not timed | 637.66 ± 0.3% | | 1.00 | 1.24 | 32.98 |
| 10-bounded-repeat/letters-ru | 3475 | 385.27 ± 0.4% | not timed | not timed | 478.19 ± 0.1% | 21.84 ± 8.9% | not timed | not timed | 383.66 ± 0.6% | | 1.00 | 0.81 | 17.64 |
| 10-bounded-repeat/context | 53 | 78.60 ± 1.6% | not timed | not timed | 65.57 ± 0.8% | 19.79 ± 0.3% | not timed | not timed | 78.67 ± 1.5% | | 1.00 | 1.20 | 3.97 |
| 10-bounded-repeat/capitals | 11 | 1040.69 ± 0.2% | not timed | not timed | 618.64 ± 0.1% | 36.57 ± 0.3% | not timed | not timed | 1040.95 ± 0.1% | | 1.00 | 1.68 | 28.45 |
| 11-unstructured-to-json/extract | 600 | 49.76 ± 0.1% | not timed | not timed | 77.62 ± 0.1% | 48.87 ± 0.5% | not timed | not timed | 49.52 ± 0.8% | | 1.00 | 0.64 | 1.02 |
| 12-dictionary/single | 1 | 566.98 ± 0.4% | not timed | not timed | 559.60 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 567.48 ± 0.3% | | 1.00 | 1.01 | 1418.60 |
| 14-quadratic/1x | 100 | 9.66 ± 0.4% | not timed | not timed | 10.01 ± 0.1% | 0.97 ± 3.2% | not timed | not timed | 9.67 ± 0.7% | | 1.00 | 0.97 | 9.95 |
| 14-quadratic/2x | 200 | 5.52 ± 0.3% | not timed | not timed | 5.54 ± 0.0% | 0.53 ± 1.5% | not timed | not timed | 5.52 ± 0.6% | | 1.00 | 1.00 | 10.39 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.26 ± 0.2% | | 1.00 | 1.05 | 10.94 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.4% | not timed | not timed | 0.34 ± 0.6% | 0.54 ± 5.3% | not timed | not timed | 1.54 ± 0.6% | | 1.00 | 4.49 | 2.87 |
| 04-ruff-noqa/compile-real | 1 | 87.11 ± 0.2% | not timed | not timed | 13.88 ± 0.2% | 138.45 ± 4.0% | not timed | not timed | 86.74 ± 1.1% | | 1.00 | 6.27 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 14.32 ± 0.4% | not timed | not timed | 2.54 ± 0.8% | 6.27 ± 4.3% | not timed | not timed | 14.30 ± 0.4% | | 1.00 | 5.64 | 2.28 |
| 07-unicode-character-data/compile | 1 | 55.44 ± 0.2% | not timed | not timed | 26.08 ± 0.2% | 34.99 ± 3.7% | not timed | not timed | 55.13 ± 1.2% | | 1.01 | 2.13 | 1.58 |
| 09-aws-keys/compile-full | 1 | 42.43 ± 0.2% | not timed | not timed | 8.34 ± 0.3% | 22.44 ± 1.9% | not timed | not timed | 42.37 ± 0.7% | | 1.00 | 5.09 | 1.89 |
| 09-aws-keys/compile-quick | 1 | 189.56 ± 0.2% | not timed | not timed | 47.97 ± 0.2% | 127.82 ± 10.0% | not timed | not timed | 189.46 ± 1.1% | | 1.00 | 3.95 | 1.48 |
| 10-bounded-repeat/compile-context | 1 | 14.72 ± 2.5% | not timed | not timed | 11.29 ± 0.7% | 15.58 ± 3.9% | not timed | not timed | 14.64 ± 1.2% | | 1.01 | 1.30 | 0.94 |
| 10-bounded-repeat/compile-capitals | 1 | 85.19 ± 0.4% | not timed | not timed | 8.15 ± 0.2% | 23.18 ± 9.4% | not timed | not timed | 84.70 ± 0.9% | | 1.01 | 10.46 | 3.68 |
| 11-unstructured-to-json/compile | 1 | 86.73 ± 0.2% | not timed | not timed | 40.93 ± 0.4% | 65.79 ± 2.1% | not timed | not timed | 85.82 ± 1.1% | | 1.01 | 2.12 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 19.8% | 0.09 ± 17.6% | not timed | not timed | 0.35 ± 2.1% | | 1.00 | 5.21 | 3.87 |

