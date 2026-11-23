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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102065472 |
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
| literal: a word | 217 | 16145.52 ± 1.0% | 1041.76 ± 0.2% | 27.69 ± 0.4% | 18110.50 ± 1.3% | 9171.37 ± 6.9% | 17.18 ± 0.4% | 86.36 ± 0.2% | 16173.11 ± 1.1% | 15.50 | 1.00 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18791.10 ± 0.5% | 1048.73 ± 0.5% | 27.62 ± 0.2% | 19770.33 ± 1.2% | 29096.02 ± 1.6% | 16.96 ± 0.4% | 82.06 ± 0.2% | 18833.71 ± 1.1% | 17.92 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6161.94 ± 0.7% | 1018.78 ± 0.3% | 14.29 ± 0.7% | 3947.25 ± 0.8% | 21.89 ± 0.2% | 5.34 ± 0.6% | 6.90 ± 0.5% | 6142.58 ± 1.5% | 6.05 | 1.00 | 1.56 | 281.54 |
| literal: a word in any case | 217 | 12505.42 ± 0.7% | 1040.83 ± 0.2% | 21.19 ± 2.2% | 3976.71 ± 0.3% | 38.03 ± 0.6% | refused | differs | 12498.88 ± 0.4% | 12.01 | 1.00 | 3.14 | 328.79 |
| literal: an href attribute | 33 | 13884.01 ± 1.3% | 1047.78 ± 0.2% | 26.71 ± 0.1% | 17047.01 ± 1.4% | 2263.49 ± 0.6% | 13.09 ± 0.1% | 75.20 ± 1.5% | 13929.42 ± 0.7% | 13.25 | 1.00 | 0.81 | 6.13 |
| literal: a word, second text | 123 | 16423.89 ± 1.1% | 1048.43 ± 0.2% | 27.38 ± 0.1% | 18397.07 ± 0.8% | 7653.17 ± 5.6% | 20.14 ± 0.8% | 70.40 ± 0.7% | 16421.50 ± 1.2% | 15.67 | 1.00 | 0.89 | 2.15 |
| class: two capitalized words | 1331 | 1102.70 ± 0.1% | 958.60 ± 0.1% | 25.50 ± 0.1% | 585.18 ± 0.1% | 40.73 ± 8.4% | 14.66 ± 0.3% | 68.90 ± 0.2% | 1102.47 ± 0.4% | 1.15 | 1.00 | 1.88 | 27.07 |
| class: a word that ends in ing | 3399 | 879.05 ± 0.1% | 881.08 ± 0.2% | 17.72 ± 0.0% | 547.36 ± 0.1% | 29.68 ± 6.1% | 8.14 ± 0.4% | 18.44 ± 0.4% | 877.79 ± 0.3% | 1.00 | 1.00 | 1.61 | 29.62 |
| class: a word in capitals | 2332 | 1468.66 ± 0.4% | 944.87 ± 0.1% | 27.14 ± 0.1% | 572.36 ± 0.0% | 43.49 ± 6.2% | 17.07 ± 0.2% | 82.96 ± 0.8% | 1465.85 ± 0.3% | 1.55 | 1.00 | 2.57 | 33.77 |
| class: a number | 8288 | 2062.39 ± 0.2% | 791.71 ± 0.1% | 27.20 ± 0.1% | 1724.90 ± 0.2% | 40.36 ± 15.0% | 0.54 ± 0.1% | 56.63 ± 0.7% | 2064.91 ± 0.1% | 2.60 | 1.00 | 1.20 | 51.09 |
| class: two capitalized words, second text | 5359 | 688.82 ± 0.4% | 687.39 ± 0.2% | 22.85 ± 0.1% | 484.93 ± 0.1% | 33.70 ± 9.6% | 17.13 ± 0.2% | 63.97 ± 0.4% | 688.51 ± 0.2% | 1.00 | 1.00 | 1.42 | 20.44 |
| other: a word between two words | 6104 | 777.60 ± 0.2% | 742.51 ± 0.2% | 23.09 ± 0.1% | 736.52 ± 0.1% | 109.28 ± 13.7% | 11.09 ± 0.1% | 69.57 ± 0.2% | 778.10 ± 0.4% | 1.05 | 1.00 | 1.06 | 7.12 |
| other: a number before a unit, second text | 1481 | 5467.43 ± 0.3% | 978.86 ± 0.1% | 25.42 ± 0.1% | 5674.37 ± 0.6% | 40.82 ± 11.7% | 18.14 ± 0.3% | 66.83 ± 0.5% | 5458.83 ± 0.2% | 5.59 | 1.00 | 0.96 | 133.92 |
| other: a heading's start tag | 110 | 12861.50 ± 0.8% | 1032.70 ± 0.2% | 26.83 ± 0.2% | 1707.14 ± 0.2% | 1585.18 ± 6.1% | 15.94 ± 0.3% | 88.89 ± 0.3% | 12884.00 ± 0.2% | 12.45 | 1.00 | 7.53 | 8.11 |
| other: a whole word | 217 | 14032.72 ± 0.8% | 1041.31 ± 0.3% | 28.67 ± 0.4% | 14708.36 ± 0.8% | 49.38 ± 0.2% | 13.07 ± 0.2% | 55.64 ± 0.4% | 13994.91 ± 0.5% | 13.48 | 1.00 | 0.95 | 284.17 |
| other: a line's first word, second text | 3716 | 1953.59 ± 0.3% | 854.41 ± 0.2% | 30.06 ± 0.1% | 1722.90 ± 0.7% | 61.72 ± 6.3% | refused | refused | 1943.38 ± 0.5% | 2.29 | 1.01 | 1.13 | 31.65 |
| other: fourteen octets before an x | 87 | 19673.20 ± 1.2% | 244.23 ± 0.4% | 5.30 ± 0.1% | 3910.49 ± 0.4% | 10.64 ± 0.4% | differs | 17.79 ± 0.1% | 19835.64 ± 0.7% | 80.55 | 0.99 | 5.03 | 1848.80 |
| other: a Greek word | 21815 | 471.78 ± 0.3% | 315.47 ± 0.5% | 30.28 ± 0.1% | 289.60 ± 0.5% | 44.62 ± 8.4% | differs | refused | 469.84 ± 0.5% | 1.50 | 1.00 | 1.63 | 10.57 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.02 ± 0.2% | 26.03 ± 0.1% | 0.82 ± 0.2% | 19.77 ± 0.4% | 2.75 ± 0.4% | differs | 4.01 ± 0.2% | 25.98 ± 0.2% | 1.00 | 1.00 | 1.32 | 9.45 |
| a UUID | 32895 | 21.23 ± 0.3% | 21.33 ± 0.3% | 0.64 ± 0.3% | 15.03 ± 0.8% | 3.11 ± 0.2% | 0.73 ± 0.1% | 3.61 ± 0.4% | 21.34 ± 0.5% | 1.00 | 0.99 | 1.41 | 6.84 |
| an IPv4 address | 33176 | 36.78 ± 0.1% | 36.81 ± 0.1% | 2.08 ± 0.4% | 29.36 ± 0.2% | 6.67 ± 0.2% | differs | 4.13 ± 0.1% | 36.82 ± 0.1% | 1.00 | 1.00 | 1.25 | 5.51 |
| a date and time | 32954 | 31.16 ± 0.4% | 31.25 ± 0.3% | 1.45 ± 0.2% | 21.50 ± 0.7% | 7.05 ± 0.1% | 1.24 ± 0.2% | 7.14 ± 0.6% | 31.14 ± 0.2% | 1.00 | 1.00 | 1.45 | 4.42 |
| a field path | 32606 | 29.52 ± 0.2% | 29.38 ± 0.2% | 0.97 ± 0.1% | 23.21 ± 0.8% | 3.49 ± 0.4% | differs | 2.96 ± 0.2% | 29.55 ± 0.2% | 1.01 | 1.00 | 1.27 | 8.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.02 ± 0.2% | 9.06 ± 0.2% | 9.01 ± 0.3% | 11.56 ± 0.1% | 4.97 ± 1.3% | 0.93 ± 0.5% | none | 9.03 ± 0.2% | 1.00 | 1.00 | 0.78 | 1.82 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.18 ± 0.3% | 237.01 ± 0.1% | 288.21 ± 0.1% | 86.66 ± 0.2% | 220.58 ± 1.3% | 482.84 ± 0.8% | 3822.89 ± 2.1% | 235.05 ± 0.6% | 0.99 | 1.00 | 2.71 | 1.07 |
| a UUID | 62 | 157.62 ± 0.3% | 158.03 ± 0.2% | 179.59 ± 0.2% | 45.56 ± 0.2% | 99.69 ± 0.4% | 180.34 ± 0.7% | 4236.17 ± 0.5% | 157.69 ± 0.2% | 1.00 | 1.00 | 3.46 | 1.58 |
| an IPv4 address | 29 | 421.43 ± 0.4% | 425.64 ± 0.7% | 619.10 ± 0.4% | 76.46 ± 1.0% | 131.21 ± 2.7% | 289.42 ± 0.2% | 7549.44 ± 0.3% | 420.94 ± 0.6% | 0.99 | 1.00 | 5.51 | 3.21 |
| a date and time | 56 | 305.66 ± 0.4% | 307.20 ± 0.2% | 397.45 ± 0.3% | 71.79 ± 0.2% | 137.54 ± 1.6% | 318.54 ± 0.6% | 4853.04 ± 0.8% | 305.60 ± 0.7% | 1.00 | 1.00 | 4.26 | 2.22 |
| a field path | 39 | 227.23 ± 0.3% | 228.38 ± 0.4% | 275.26 ± 0.3% | 79.26 ± 0.5% | 206.33 ± 1.0% | 485.33 ± 0.6% | 4912.81 ± 0.9% | 227.08 ± 0.4% | 0.99 | 1.00 | 2.87 | 1.10 |
| literal: a word | 7 | 622.50 ± 0.6% | 666.04 ± 0.4% | 1275.39 ± 0.2% | 500.99 ± 1.8% | 634.61 ± 2.1% | 917.37 ± 0.2% | 29630.83 ± 0.1% | 622.00 ± 0.3% | 0.93 | 1.00 | 1.24 | 0.98 |
| literal: a word that is not there | 8 | 595.72 ± 0.8% | 645.64 ± 0.6% | 1191.49 ± 0.7% | 457.46 ± 0.1% | 609.23 ± 1.1% | 869.45 ± 0.5% | 28626.15 ± 0.3% | 596.20 ± 0.7% | 0.92 | 1.00 | 1.30 | 0.98 |
| literal: one of four words | 26 | 241.44 ± 0.4% | 400.54 ± 0.8% | 565.03 ± 0.4% | 49.35 ± 0.3% | 246.47 ± 3.1% | 351.77 ± 0.6% | 15522.01 ± 0.2% | 241.48 ± 0.3% | 0.60 | 1.00 | 4.89 | 0.98 |
| literal: a word in any case | 11 | 483.52 ± 0.4% | 517.17 ± 0.6% | 846.51 ± 0.6% | 15.74 ± 0.9% | 654.64 ± 1.9% | refused | 23321.95 ± 0.3% | 483.46 ± 0.3% | 0.93 | 1.00 | 30.73 | 0.74 |
| literal: an href attribute | 12 | 350.54 ± 0.6% | 361.10 ± 0.7% | 497.66 ± 0.4% | 43.48 ± 0.6% | 503.67 ± 0.8% | 766.80 ± 2.1% | 21572.60 ± 0.2% | 350.67 ± 0.4% | 0.97 | 1.00 | 8.06 | 0.70 |
| literal: a word, second text | 10 | 562.08 ± 1.0% | 617.33 ± 0.8% | 1091.61 ± 1.2% | 407.06 ± 0.2% | 539.82 ± 1.5% | 793.35 ± 0.6% | 26575.13 ± 0.2% | 562.00 ± 0.4% | 0.91 | 1.00 | 1.38 | 1.04 |
| class: two capitalized words | 23 | 435.85 ± 0.6% | 467.03 ± 0.5% | 706.36 ± 0.7% | 100.87 ± 0.1% | 508.32 ± 1.1% | 736.13 ± 0.5% | 6569.51 ± 0.2% | 435.74 ± 0.5% | 0.93 | 1.00 | 4.32 | 0.86 |
| class: a word that ends in ing | 9 | 556.56 ± 0.3% | 626.59 ± 0.1% | 1178.33 ± 0.1% | 132.66 ± 0.9% | 764.24 ± 0.9% | 1069.03 ± 1.7% | 16016.85 ± 0.2% | 556.81 ± 0.5% | 0.89 | 1.00 | 4.20 | 0.73 |
| class: a word in capitals | 16 | 491.94 ± 0.7% | 532.87 ± 0.6% | 916.95 ± 0.2% | 135.64 ± 0.8% | 756.75 ± 1.4% | 1006.30 ± 1.3% | 8630.36 ± 0.2% | 492.82 ± 1.1% | 0.92 | 1.00 | 3.63 | 0.65 |
| class: a number | 6 | 610.11 ± 1.1% | 680.48 ± 1.1% | 1389.60 ± 2.0% | 41.85 ± 0.5% | 1415.78 ± 0.6% | 1918.88 ± 1.2% | 22450.46 ± 0.1% | 611.22 ± 0.7% | 0.90 | 1.00 | 14.58 | 0.43 |
| class: two capitalized words, second text | 23 | 435.99 ± 0.5% | 467.89 ± 0.3% | 710.14 ± 0.5% | 102.93 ± 0.3% | 507.38 ± 1.1% | 740.30 ± 0.4% | 6574.01 ± 0.3% | 435.45 ± 0.4% | 0.93 | 1.00 | 4.24 | 0.86 |
| other: a word between two words | 13 | 551.60 ± 0.3% | 568.35 ± 0.3% | 957.38 ± 0.3% | 135.35 ± 0.6% | 512.51 ± 1.9% | 808.64 ± 0.7% | 14785.56 ± 0.7% | 552.01 ± 0.3% | 0.97 | 1.00 | 4.08 | 1.08 |
| other: a number before a unit, second text | 15 | 406.49 ± 0.6% | 447.05 ± 0.5% | 659.37 ± 0.6% | 39.18 ± 0.3% | 640.16 ± 1.9% | 894.63 ± 0.5% | 15063.92 ± 0.4% | 406.35 ± 0.0% | 0.91 | 1.00 | 10.38 | 0.63 |
| other: a heading's start tag | 13 | 359.94 ± 0.3% | 366.37 ± 0.5% | 502.26 ± 0.7% | 43.00 ± 0.3% | 637.08 ± 0.8% | 856.78 ± 0.7% | 17936.14 ± 0.2% | 359.74 ± 0.6% | 0.98 | 1.00 | 8.37 | 0.56 |
| other: a whole word | 11 | 582.71 ± 0.3% | 617.92 ± 0.4% | 1096.77 ± 0.6% | 119.98 ± 0.3% | 572.04 ± 1.9% | 820.56 ± 0.6% | 26612.40 ± 0.4% | 582.40 ± 0.5% | 0.94 | 1.00 | 4.86 | 1.02 |
| other: a line's first word, second text | 17 | 533.28 ± 0.2% | 551.54 ± 0.5% | 944.60 ± 0.1% | 128.06 ± 0.2% | 712.90 ± 1.7% | refused | refused | 531.87 ± 0.5% | 0.97 | 1.00 | 4.16 | 0.75 |
| other: fourteen octets before an x | 16 | 112.06 ± 0.9% | 161.45 ± 1.5% | 190.06 ± 0.8% | 14.83 ± 0.5% | 460.19 ± 1.8% | 414.62 ± 0.2% | 12407.78 ± 0.4% | 111.96 ± 0.8% | 0.69 | 1.00 | 7.55 | 0.24 |
| other: a Greek word | 8 | 423.95 ± 0.3% | 588.48 ± 0.5% | 1061.66 ± 0.3% | 58.08 ± 0.1% | 1403.28 ± 1.1% | 1829.04 ± 0.5% | refused | 423.64 ± 0.2% | 0.72 | 1.00 | 7.30 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12888.27 ± 0.5% | not timed | not timed | 16282.72 ± 1.1% | 1982.53 ± 18.9% | not timed | not timed | 12919.03 ± 0.7% | | 1.00 | 0.79 | 6.50 |
| 01-literal/sherlock-casei-en | 522 | 3948.24 ± 0.6% | not timed | not timed | 3592.37 ± 0.2% | 32.46 ± 0.1% | not timed | not timed | 3940.15 ± 0.6% | | 1.00 | 1.10 | 121.63 |
| 01-literal/sherlock-ru | 724 | 13553.17 ± 0.5% | not timed | not timed | 17277.73 ± 0.3% | 1479.27 ± 4.5% | not timed | not timed | 13544.64 ± 0.4% | | 1.00 | 0.78 | 9.16 |
| 01-literal/sherlock-casei-ru | 746 | 5397.61 ± 0.2% | not timed | not timed | 3321.34 ± 0.1% | 30.62 ± 0.5% | not timed | not timed | 5410.12 ± 0.1% | | 1.00 | 1.63 | 176.25 |
| 01-literal/sherlock-zh | 30 | 17118.89 ± 0.2% | not timed | not timed | 18620.35 ± 0.8% | 2837.74 ± 6.0% | not timed | not timed | 17112.29 ± 0.3% | | 1.00 | 0.92 | 6.03 |
| 02-literal-alternate/sherlock-en | 714 | 5908.36 ± 0.2% | not timed | not timed | 3942.14 ± 0.2% | 16.64 ± 0.1% | not timed | not timed | 5897.93 ± 0.1% | | 1.00 | 1.50 | 354.97 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1705.15 ± 1.0% | not timed | not timed | 698.18 ± 0.2% | 11.03 ± 0.1% | not timed | not timed | 1698.46 ± 0.5% | | 1.00 | 2.44 | 154.57 |
| 02-literal-alternate/sherlock-ru | 899 | 4802.10 ± 0.1% | not timed | not timed | 3256.98 ± 0.1% | 22.66 ± 0.1% | not timed | not timed | 4810.66 ± 0.3% | | 1.00 | 1.47 | 211.93 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1820.76 ± 0.4% | not timed | not timed | 1232.21 ± 0.2% | 9.09 ± 0.0% | not timed | not timed | 1813.62 ± 0.2% | | 1.00 | 1.48 | 200.26 |
| 02-literal-alternate/sherlock-zh | 207 | 7107.71 ± 0.2% | not timed | not timed | 4167.12 ± 0.4% | 31.54 ± 0.3% | not timed | not timed | 7103.06 ± 0.3% | | 1.00 | 1.71 | 225.37 |
| 03-date/ascii | 111817 | 123.98 ± 0.6% | not timed | not timed | 95.36 ± 0.1% | 0.20 ± 1.8% | not timed | not timed | 121.90 ± 0.2% | | 1.02 | 1.30 | 612.21 |
| 04-ruff-noqa/real | 84 | 550.98 ± 0.4% | not timed | not timed | 467.23 ± 0.2% | 19.48 ± 0.2% | not timed | not timed | 552.79 ± 0.1% | | 1.00 | 1.18 | 28.28 |
| 04-ruff-noqa/tweaked | 44 | 553.39 ± 0.3% | not timed | not timed | 461.01 ± 0.1% | 365.41 ± 0.3% | not timed | not timed | 552.08 ± 0.7% | | 1.00 | 1.20 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.3% | not timed | not timed | 5.17 ± 0.2% | 0.21 ± 0.6% | not timed | not timed | 3.61 ± 1.6% | | 0.97 | 0.68 | 17.04 |
| 06-cloud-flare-redos/original | 107 | 184.21 ± 0.4% | not timed | not timed | 215.09 ± 0.1% | 24.80 ± 0.1% | not timed | not timed | 183.40 ± 0.6% | | 1.00 | 0.86 | 7.43 |
| 06-cloud-flare-redos/simplified-short | 102 | 143.84 ± 0.2% | not timed | not timed | 227.40 ± 0.0% | 26.62 ± 0.1% | not timed | not timed | 147.06 ± 0.2% | | 0.98 | 0.63 | 5.40 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.98 ± 1.7% | not timed | not timed | 255.83 ± 0.2% | 28.87 ± 0.2% | not timed | not timed | 156.71 ± 1.9% | | 1.00 | 0.61 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 40.01 ± 1.0% | not timed | not timed | 180.21 ± 0.2% | 43.27 ± 5.8% | not timed | not timed | 40.00 ± 0.1% | | 1.00 | 0.22 | 0.92 |
| 08-words/all-english | 56691 | 103.12 ± 0.3% | not timed | not timed | 83.20 ± 0.2% | 12.32 ± 12.8% | not timed | not timed | 102.30 ± 0.3% | | 1.01 | 1.24 | 8.37 |
| 08-words/long-english | 839 | 997.01 ± 0.3% | not timed | not timed | 595.99 ± 0.1% | 32.61 ± 0.3% | not timed | not timed | 997.45 ± 0.2% | | 1.00 | 1.67 | 30.58 |
| 09-aws-keys/full | 0 | 421.48 ± 0.1% | not timed | not timed | 487.46 ± 0.1% | 64.73 ± 3.6% | not timed | not timed | 421.35 ± 0.1% | | 1.00 | 0.86 | 6.51 |
| 09-aws-keys/quick | 0 | 413.76 ± 0.1% | not timed | not timed | 996.06 ± 0.3% | 425.28 ± 1.6% | not timed | not timed | 410.16 ± 0.0% | | 1.01 | 0.42 | 0.97 |
| 10-bounded-repeat/letters-en | 1833 | 592.39 ± 0.4% | not timed | not timed | 517.39 ± 0.2% | 19.58 ± 0.6% | not timed | not timed | 590.96 ± 0.2% | | 1.00 | 1.14 | 30.25 |
| 10-bounded-repeat/letters-ru | 3475 | 404.41 ± 0.4% | not timed | not timed | 479.13 ± 0.2% | 21.89 ± 9.5% | not timed | not timed | 403.23 ± 0.5% | | 1.00 | 0.84 | 18.47 |
| 10-bounded-repeat/context | 53 | 73.31 ± 1.0% | not timed | not timed | 66.01 ± 0.6% | 19.83 ± 0.3% | not timed | not timed | 73.17 ± 1.2% | | 1.00 | 1.11 | 3.70 |
| 10-bounded-repeat/capitals | 11 | 1039.67 ± 0.1% | not timed | not timed | 616.55 ± 0.1% | 36.54 ± 0.2% | not timed | not timed | 1038.66 ± 0.2% | | 1.00 | 1.69 | 28.45 |
| 11-unstructured-to-json/extract | 600 | 24.56 ± 0.2% | not timed | not timed | 76.59 ± 0.1% | 49.02 ± 0.4% | not timed | not timed | 24.46 ± 0.3% | | 1.00 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 602.35 ± 0.7% | not timed | not timed | 560.76 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 601.23 ± 0.4% | | 1.00 | 1.07 | 1479.69 |
| 14-quadratic/1x | 100 | 12.61 ± 0.6% | not timed | not timed | 10.01 ± 0.2% | 0.98 ± 1.8% | not timed | not timed | 12.46 ± 1.8% | | 1.01 | 1.26 | 12.92 |
| 14-quadratic/2x | 200 | 7.78 ± 0.5% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.9% | not timed | not timed | 7.75 ± 0.3% | | 1.00 | 1.41 | 14.69 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.7% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.4% | not timed | not timed | 1.83 ± 0.5% | | 1.00 | 1.51 | 15.88 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 3.9% | not timed | not timed | 1.44 ± 1.7% | | 1.00 | 4.21 | 2.62 |
| 04-ruff-noqa/compile-real | 1 | 92.59 ± 0.3% | not timed | not timed | 13.92 ± 0.3% | 140.51 ± 1.5% | not timed | not timed | 91.95 ± 0.8% | | 1.01 | 6.65 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.57 ± 0.9% | not timed | not timed | 2.54 ± 1.1% | 6.53 ± 1.4% | not timed | not timed | 14.54 ± 1.2% | | 1.00 | 5.74 | 2.23 |
| 07-unicode-character-data/compile | 1 | 58.45 ± 0.1% | not timed | not timed | 26.02 ± 0.5% | 36.61 ± 2.2% | not timed | not timed | 58.48 ± 1.1% | | 1.00 | 2.25 | 1.60 |
| 09-aws-keys/compile-full | 1 | 43.66 ± 0.3% | not timed | not timed | 8.26 ± 0.7% | 23.60 ± 1.3% | not timed | not timed | 43.44 ± 0.5% | | 1.01 | 5.29 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 187.69 ± 0.3% | not timed | not timed | 47.53 ± 0.5% | 136.38 ± 2.2% | not timed | not timed | 188.55 ± 1.0% | | 1.00 | 3.95 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.64 ± 1.0% | not timed | not timed | 11.16 ± 0.2% | 16.35 ± 1.8% | not timed | not timed | 14.43 ± 1.4% | | 1.01 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.14 ± 0.9% | not timed | not timed | 7.98 ± 0.1% | 24.18 ± 3.0% | not timed | not timed | 84.94 ± 0.8% | | 1.00 | 10.67 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 90.86 ± 0.3% | not timed | not timed | 41.34 ± 0.4% | 69.04 ± 3.5% | not timed | not timed | 90.68 ± 1.0% | | 1.00 | 2.20 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.36 ± 1.6% | not timed | not timed | 0.07 ± 0.3% | 0.10 ± 10.3% | not timed | not timed | 0.36 ± 1.3% | | 1.00 | 5.16 | 3.64 |

