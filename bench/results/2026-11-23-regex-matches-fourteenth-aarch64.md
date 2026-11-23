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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127373415 |
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
| literal: a word | 217 | 16065.38 ± 1.9% | 1039.63 ± 0.1% | 28.76 ± 0.3% | 17663.08 ± 2.8% | 9152.78 ± 7.0% | 17.60 ± 0.3% | 86.09 ± 0.2% | 16146.80 ± 2.9% | 15.45 | 0.99 | 0.91 | 1.76 |
| literal: a word that is not there | 0 | 18744.43 ± 2.0% | 1048.03 ± 0.1% | 28.72 ± 0.5% | 19404.27 ± 3.0% | 27838.17 ± 5.5% | 17.41 ± 0.1% | 81.87 ± 0.2% | 18790.39 ± 1.2% | 17.89 | 1.00 | 0.97 | 0.67 |
| literal: one of four words | 661 | 6073.86 ± 0.2% | 1021.81 ± 0.2% | 14.75 ± 0.2% | 3953.23 ± 0.1% | 21.88 ± 0.2% | 5.30 ± 0.2% | 6.72 ± 0.3% | 6073.01 ± 0.3% | 5.94 | 1.00 | 1.54 | 277.55 |
| literal: a word in any case | 217 | 12552.42 ± 0.5% | 1039.61 ± 0.1% | 22.03 ± 0.4% | 3970.43 ± 0.2% | 38.09 ± 0.4% | refused | differs | 12545.66 ± 0.3% | 12.07 | 1.00 | 3.16 | 329.58 |
| literal: an href attribute | 33 | 13671.78 ± 1.7% | 1047.17 ± 0.1% | 27.45 ± 0.4% | 16695.59 ± 1.4% | 2264.03 ± 0.2% | 13.37 ± 0.2% | 75.33 ± 0.7% | 13687.88 ± 1.4% | 13.06 | 1.00 | 0.82 | 6.04 |
| literal: a word, second text | 123 | 16087.81 ± 0.9% | 1043.63 ± 0.1% | 28.30 ± 0.2% | 17412.84 ± 2.6% | 7684.58 ± 6.1% | 19.70 ± 0.1% | 68.91 ± 1.4% | 16014.97 ± 1.3% | 15.42 | 1.00 | 0.92 | 2.09 |
| class: two capitalized words | 1331 | 1127.51 ± 0.3% | 977.54 ± 0.2% | 26.16 ± 0.1% | 585.47 ± 0.1% | 40.57 ± 0.1% | 15.00 ± 0.3% | 68.31 ± 0.6% | 1126.94 ± 0.5% | 1.15 | 1.00 | 1.93 | 27.79 |
| class: a word that ends in ing | 3399 | 890.56 ± 0.2% | 891.55 ± 0.1% | 18.23 ± 0.1% | 548.22 ± 0.0% | 29.46 ± 2.4% | 8.24 ± 0.1% | 18.26 ± 0.3% | 887.50 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.23 |
| class: a word in capitals | 2332 | 1446.08 ± 0.4% | 950.55 ± 0.1% | 27.78 ± 0.2% | 572.98 ± 0.1% | 43.62 ± 16.8% | 17.23 ± 0.3% | 82.81 ± 0.3% | 1449.47 ± 0.0% | 1.52 | 1.00 | 2.52 | 33.15 |
| class: a number | 8288 | 1997.16 ± 0.6% | 828.13 ± 0.3% | 28.03 ± 0.3% | 1718.12 ± 0.2% | 42.89 ± 17.2% | 0.54 ± 0.6% | 56.79 ± 0.1% | 1992.35 ± 0.1% | 2.41 | 1.00 | 1.16 | 46.56 |
| class: two capitalized words, second text | 5359 | 738.13 ± 0.2% | 736.57 ± 0.1% | 23.46 ± 0.1% | 484.40 ± 0.1% | 35.33 ± 6.5% | 16.67 ± 0.6% | 63.50 ± 0.5% | 737.83 ± 0.1% | 1.00 | 1.00 | 1.52 | 20.89 |
| other: a word between two words | 6104 | 761.76 ± 0.3% | 764.40 ± 0.3% | 23.65 ± 0.2% | 737.33 ± 0.3% | 107.02 ± 10.2% | 11.35 ± 0.2% | 69.33 ± 0.4% | 758.02 ± 0.1% | 1.00 | 1.00 | 1.03 | 7.12 |
| other: a number before a unit, second text | 1481 | 5505.13 ± 0.3% | 983.38 ± 0.0% | 26.06 ± 0.3% | 5626.28 ± 0.6% | 40.76 ± 6.8% | 17.82 ± 0.2% | 66.83 ± 0.3% | 5499.64 ± 0.2% | 5.60 | 1.00 | 0.98 | 135.05 |
| other: a heading's start tag | 110 | 12488.19 ± 1.4% | 1036.48 ± 0.1% | 27.71 ± 0.1% | 1711.67 ± 0.2% | 1581.70 ± 5.3% | 16.13 ± 0.6% | 88.56 ± 0.3% | 12530.99 ± 1.4% | 12.05 | 1.00 | 7.30 | 7.90 |
| other: a whole word | 217 | 13977.49 ± 2.4% | 1039.01 ± 0.1% | 29.99 ± 0.2% | 14488.47 ± 3.6% | 49.51 ± 0.3% | 13.78 ± 0.1% | 55.57 ± 0.2% | 14086.12 ± 2.3% | 13.45 | 0.99 | 0.96 | 282.30 |
| other: a line's first word, second text | 3716 | 1959.62 ± 0.5% | 873.82 ± 0.1% | 31.38 ± 0.3% | 1731.17 ± 0.6% | 63.14 ± 8.5% | refused | refused | 1945.59 ± 0.3% | 2.24 | 1.01 | 1.13 | 31.03 |
| other: fourteen octets before an x | 87 | 19742.40 ± 4.9% | 222.04 ± 0.4% | 6.14 ± 0.1% | 3998.72 ± 0.5% | 10.64 ± 0.2% | differs | 17.69 ± 0.2% | 19708.59 ± 4.5% | 88.91 | 1.00 | 4.94 | 1855.84 |
| other: a Greek word | 21815 | 470.08 ± 0.6% | 358.66 ± 0.3% | 31.18 ± 0.2% | 289.67 ± 0.3% | 49.55 ± 10.8% | differs | refused | 467.41 ± 0.6% | 1.31 | 1.01 | 1.62 | 9.49 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.3% | 25.84 ± 0.1% | 0.82 ± 0.4% | 19.66 ± 0.4% | 2.77 ± 11.4% | differs | 4.03 ± 0.4% | 25.90 ± 0.2% | 1.00 | 1.00 | 1.32 | 9.34 |
| a UUID | 32895 | 21.07 ± 0.4% | 21.17 ± 0.2% | 0.65 ± 0.2% | 15.09 ± 0.6% | 3.10 ± 0.1% | 0.72 ± 0.5% | 3.61 ± 0.1% | 21.16 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.79 |
| an IPv4 address | 33176 | 36.99 ± 0.2% | 36.88 ± 0.2% | 2.09 ± 0.1% | 29.01 ± 0.3% | 6.67 ± 0.1% | differs | 4.15 ± 0.2% | 37.01 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.55 |
| a date and time | 32954 | 31.13 ± 0.4% | 31.15 ± 0.2% | 1.42 ± 0.3% | 21.12 ± 0.8% | 7.06 ± 0.5% | 1.19 ± 0.3% | 7.05 ± 0.3% | 30.94 ± 0.3% | 1.00 | 1.01 | 1.47 | 4.41 |
| a field path | 32606 | 29.58 ± 0.1% | 29.50 ± 0.3% | 1.01 ± 0.9% | 22.98 ± 0.1% | 3.52 ± 0.8% | differs | 2.92 ± 0.2% | 29.54 ± 0.2% | 1.00 | 1.00 | 1.29 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.45 ± 0.4% | 11.53 ± 0.3% | 11.55 ± 0.4% | 11.38 ± 0.3% | 4.97 ± 1.9% | 0.91 ± 0.3% | none | 11.42 ± 0.4% | 0.99 | 1.00 | 1.01 | 2.30 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 215.59 ± 0.3% | 216.49 ± 0.2% | 250.51 ± 0.1% | 86.79 ± 0.5% | 222.86 ± 0.5% | 481.18 ± 1.1% | 3765.03 ± 3.9% | 215.61 ± 0.1% | 1.00 | 1.00 | 2.48 | 0.97 |
| a UUID | 62 | 141.38 ± 0.2% | 141.90 ± 0.1% | 155.92 ± 0.2% | 46.69 ± 0.6% | 98.68 ± 1.3% | 191.04 ± 2.7% | 4464.84 ± 0.5% | 141.42 ± 0.2% | 1.00 | 1.00 | 3.03 | 1.43 |
| an IPv4 address | 29 | 435.28 ± 0.5% | 441.16 ± 0.5% | 610.53 ± 0.7% | 77.37 ± 0.3% | 131.73 ± 1.3% | 303.93 ± 1.2% | 7713.84 ± 0.6% | 434.62 ± 0.1% | 0.99 | 1.00 | 5.63 | 3.30 |
| a date and time | 56 | 317.34 ± 0.2% | 319.52 ± 0.3% | 400.12 ± 0.4% | 73.24 ± 0.5% | 136.69 ± 5.2% | 326.28 ± 1.4% | 4986.19 ± 0.4% | 317.57 ± 0.1% | 0.99 | 1.00 | 4.33 | 2.32 |
| a field path | 39 | 201.25 ± 0.3% | 202.18 ± 0.2% | 231.38 ± 0.2% | 81.59 ± 0.4% | 206.14 ± 0.6% | 501.27 ± 1.2% | 4847.02 ± 0.5% | 201.47 ± 0.1% | 1.00 | 1.00 | 2.47 | 0.98 |
| literal: a word | 7 | 665.60 ± 0.4% | 719.01 ± 0.7% | 1280.35 ± 0.1% | 515.27 ± 0.6% | 627.92 ± 2.2% | 955.24 ± 0.4% | 30943.85 ± 0.4% | 664.18 ± 0.5% | 0.93 | 1.00 | 1.29 | 1.06 |
| literal: a word that is not there | 8 | 637.78 ± 0.1% | 695.66 ± 0.3% | 1209.07 ± 0.1% | 469.75 ± 0.1% | 604.12 ± 1.3% | 911.35 ± 0.3% | 29449.90 ± 0.1% | 637.34 ± 0.2% | 0.92 | 1.00 | 1.36 | 1.06 |
| literal: one of four words | 26 | 255.93 ± 0.2% | 419.78 ± 0.4% | 565.30 ± 0.4% | 50.39 ± 1.4% | 244.34 ± 11.4% | 375.98 ± 2.7% | 15722.98 ± 0.5% | 256.16 ± 0.1% | 0.61 | 1.00 | 5.08 | 1.05 |
| literal: a word in any case | 11 | 518.83 ± 0.2% | 562.44 ± 0.4% | 861.92 ± 0.1% | 15.86 ± 0.4% | 653.04 ± 1.6% | refused | 23673.81 ± 0.1% | 518.70 ± 0.1% | 0.92 | 1.00 | 32.71 | 0.79 |
| literal: an href attribute | 12 | 345.91 ± 0.5% | 357.99 ± 0.4% | 461.40 ± 0.5% | 45.75 ± 0.6% | 499.13 ± 1.2% | 782.58 ± 1.2% | 22096.89 ± 0.3% | 346.13 ± 0.7% | 0.97 | 1.00 | 7.56 | 0.69 |
| literal: a word, second text | 10 | 593.42 ± 0.3% | 656.54 ± 0.3% | 1093.30 ± 0.0% | 407.94 ± 0.1% | 538.32 ± 2.2% | 818.50 ± 0.6% | 27268.73 ± 0.6% | 592.14 ± 0.3% | 0.90 | 1.00 | 1.45 | 1.10 |
| class: two capitalized words | 23 | 458.57 ± 0.2% | 490.73 ± 0.5% | 707.87 ± 0.1% | 99.06 ± 0.7% | 504.34 ± 0.4% | 761.80 ± 0.5% | 6372.11 ± 0.2% | 459.04 ± 0.2% | 0.93 | 1.00 | 4.63 | 0.91 |
| class: a word that ends in ing | 9 | 596.73 ± 0.3% | 667.68 ± 0.1% | 1169.43 ± 0.2% | 132.27 ± 1.1% | 762.23 ± 0.6% | 1097.17 ± 0.7% | 15930.09 ± 0.1% | 597.42 ± 0.4% | 0.89 | 1.00 | 4.51 | 0.78 |
| class: a word in capitals | 16 | 519.48 ± 0.6% | 561.16 ± 0.4% | 885.36 ± 0.4% | 136.15 ± 0.4% | 755.14 ± 0.8% | 1011.46 ± 1.6% | 8378.16 ± 0.3% | 519.22 ± 0.2% | 0.93 | 1.00 | 3.82 | 0.69 |
| class: a number | 6 | 658.12 ± 0.3% | 723.58 ± 0.4% | 1335.66 ± 0.1% | 41.94 ± 0.6% | 1398.77 ± 0.9% | 1832.96 ± 1.5% | 22793.25 ± 0.1% | 657.95 ± 0.5% | 0.91 | 1.00 | 15.69 | 0.47 |
| class: two capitalized words, second text | 23 | 459.33 ± 0.2% | 490.51 ± 0.4% | 707.63 ± 0.3% | 100.27 ± 0.5% | 505.01 ± 3.1% | 768.56 ± 0.9% | 6373.14 ± 0.1% | 459.53 ± 0.2% | 0.94 | 1.00 | 4.58 | 0.91 |
| other: a word between two words | 13 | 583.34 ± 0.4% | 604.56 ± 0.4% | 959.50 ± 0.1% | 134.37 ± 1.3% | 504.90 ± 1.8% | 816.93 ± 0.5% | 14761.45 ± 0.1% | 582.83 ± 0.2% | 0.96 | 1.00 | 4.34 | 1.16 |
| other: a number before a unit, second text | 15 | 399.18 ± 0.2% | 435.19 ± 0.1% | 593.93 ± 0.1% | 39.48 ± 0.5% | 636.66 ± 1.6% | 891.61 ± 0.8% | 15291.18 ± 0.0% | 399.48 ± 0.1% | 0.92 | 1.00 | 10.11 | 0.63 |
| other: a heading's start tag | 13 | 354.45 ± 0.3% | 360.39 ± 0.1% | 467.02 ± 0.2% | 43.66 ± 0.3% | 630.01 ± 3.8% | 866.75 ± 0.7% | 18384.17 ± 0.1% | 354.36 ± 0.4% | 0.98 | 1.00 | 8.12 | 0.56 |
| other: a whole word | 11 | 615.01 ± 0.4% | 656.90 ± 1.0% | 1088.18 ± 0.2% | 119.59 ± 0.4% | 567.75 ± 1.0% | 819.31 ± 0.8% | 26925.16 ± 0.1% | 614.86 ± 0.5% | 0.94 | 1.00 | 5.14 | 1.08 |
| other: a line's first word, second text | 17 | 555.48 ± 0.5% | 579.75 ± 0.4% | 926.29 ± 0.2% | 131.26 ± 0.4% | 709.38 ± 0.8% | refused | refused | 554.68 ± 0.4% | 0.96 | 1.00 | 4.23 | 0.78 |
| other: fourteen octets before an x | 16 | 110.02 ± 0.1% | 157.19 ± 0.9% | 178.15 ± 0.3% | 15.09 ± 0.4% | 455.54 ± 1.1% | 423.04 ± 0.3% | 13026.01 ± 0.2% | 110.00 ± 1.1% | 0.70 | 1.00 | 7.29 | 0.24 |
| other: a Greek word | 8 | 444.22 ± 0.3% | 583.74 ± 0.7% | 940.10 ± 0.2% | 59.23 ± 0.5% | 1383.50 ± 0.8% | 1837.99 ± 0.4% | refused | 445.21 ± 0.4% | 0.76 | 1.00 | 7.50 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12779.73 ± 1.5% | not timed | not timed | 16041.09 ± 2.3% | 2172.91 ± 12.4% | not timed | not timed | 12792.68 ± 0.6% | | 1.00 | 0.80 | 5.88 |
| 01-literal/sherlock-casei-en | 522 | 3882.46 ± 0.3% | not timed | not timed | 3592.51 ± 0.3% | 32.47 ± 0.1% | not timed | not timed | 3882.27 ± 0.3% | | 1.00 | 1.08 | 119.56 |
| 01-literal/sherlock-ru | 724 | 13579.15 ± 0.5% | not timed | not timed | 17274.47 ± 0.4% | 1445.24 ± 5.7% | not timed | not timed | 13571.39 ± 0.8% | | 1.00 | 0.79 | 9.40 |
| 01-literal/sherlock-casei-ru | 746 | 5255.97 ± 0.2% | not timed | not timed | 3330.91 ± 0.1% | 31.61 ± 1.7% | not timed | not timed | 5256.98 ± 0.1% | | 1.00 | 1.58 | 166.26 |
| 01-literal/sherlock-zh | 30 | 16754.24 ± 0.5% | not timed | not timed | 18226.85 ± 0.8% | 2627.77 ± 22.7% | not timed | not timed | 16735.84 ± 0.1% | | 1.00 | 0.92 | 6.38 |
| 02-literal-alternate/sherlock-en | 714 | 5820.93 ± 0.4% | not timed | not timed | 3940.45 ± 0.1% | 16.51 ± 0.1% | not timed | not timed | 5821.81 ± 0.3% | | 1.00 | 1.48 | 352.52 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1668.16 ± 0.6% | not timed | not timed | 697.71 ± 0.1% | 11.13 ± 5.7% | not timed | not timed | 1662.66 ± 0.4% | | 1.00 | 2.39 | 149.92 |
| 02-literal-alternate/sherlock-ru | 899 | 4654.78 ± 0.6% | not timed | not timed | 3258.33 ± 0.1% | 22.18 ± 0.2% | not timed | not timed | 4645.41 ± 0.2% | | 1.00 | 1.43 | 209.87 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1778.61 ± 0.4% | not timed | not timed | 1232.13 ± 0.2% | 9.14 ± 0.1% | not timed | not timed | 1776.55 ± 0.4% | | 1.00 | 1.44 | 194.51 |
| 02-literal-alternate/sherlock-zh | 207 | 7069.86 ± 0.4% | not timed | not timed | 4166.20 ± 0.2% | 31.56 ± 16.9% | not timed | not timed | 7067.64 ± 0.6% | | 1.00 | 1.70 | 224.04 |
| 03-date/ascii | 111817 | 124.36 ± 0.4% | not timed | not timed | 95.96 ± 0.1% | 0.22 ± 6.4% | not timed | not timed | 124.47 ± 0.6% | | 1.00 | 1.30 | 576.18 |
| 04-ruff-noqa/real | 84 | 554.15 ± 0.0% | not timed | not timed | 461.66 ± 0.1% | 19.10 ± 2.2% | not timed | not timed | 553.62 ± 0.1% | | 1.00 | 1.20 | 29.01 |
| 04-ruff-noqa/tweaked | 44 | 545.91 ± 0.2% | not timed | not timed | 460.79 ± 0.1% | 367.85 ± 0.7% | not timed | not timed | 543.99 ± 0.2% | | 1.00 | 1.18 | 1.48 |
| 05-lexer-veryl/single | 124800 | 3.66 ± 0.6% | not timed | not timed | 4.93 ± 0.2% | 0.21 ± 3.1% | not timed | not timed | 3.69 ± 3.1% | | 0.99 | 0.74 | 17.80 |
| 06-cloud-flare-redos/original | 107 | 270.84 ± 0.2% | not timed | not timed | 213.27 ± 0.1% | 24.90 ± 0.1% | not timed | not timed | 269.94 ± 0.2% | | 1.00 | 1.27 | 10.88 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.85 ± 1.4% | not timed | not timed | 228.32 ± 0.1% | 26.74 ± 0.2% | not timed | not timed | 264.26 ± 1.0% | | 1.00 | 1.16 | 9.90 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.30 ± 0.2% | not timed | not timed | 255.82 ± 0.2% | 28.75 ± 0.1% | not timed | not timed | 294.27 ± 0.1% | | 1.00 | 1.15 | 10.23 |
| 07-unicode-character-data/parse-line | 558784 | 241.62 ± 0.3% | not timed | not timed | 168.31 ± 0.2% | 43.27 ± 6.2% | not timed | not timed | 241.99 ± 1.6% | | 1.00 | 1.44 | 5.58 |
| 08-words/all-english | 56691 | 119.63 ± 0.2% | not timed | not timed | 82.95 ± 0.1% | 11.59 ± 4.7% | not timed | not timed | 119.27 ± 0.6% | | 1.00 | 1.44 | 10.32 |
| 08-words/long-english | 839 | 1005.97 ± 0.2% | not timed | not timed | 595.47 ± 0.1% | 32.61 ± 0.4% | not timed | not timed | 1005.55 ± 0.1% | | 1.00 | 1.69 | 30.85 |
| 09-aws-keys/full | 0 | 412.48 ± 0.2% | not timed | not timed | 463.28 ± 0.1% | 64.58 ± 0.2% | not timed | not timed | 412.63 ± 0.0% | | 1.00 | 0.89 | 6.39 |
| 09-aws-keys/quick | 0 | 734.27 ± 0.1% | not timed | not timed | 992.94 ± 0.2% | 421.31 ± 1.7% | not timed | not timed | 730.74 ± 0.1% | | 1.00 | 0.74 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 633.72 ± 0.2% | not timed | not timed | 518.15 ± 0.6% | 19.48 ± 0.4% | not timed | not timed | 633.08 ± 0.2% | | 1.00 | 1.22 | 32.52 |
| 10-bounded-repeat/letters-ru | 3475 | 380.45 ± 2.0% | not timed | not timed | 477.24 ± 5.6% | 22.22 ± 14.0% | not timed | not timed | 378.99 ± 2.8% | | 1.00 | 0.80 | 17.12 |
| 10-bounded-repeat/context | 53 | 79.20 ± 1.5% | not timed | not timed | 65.67 ± 0.3% | 19.81 ± 0.2% | not timed | not timed | 79.17 ± 1.1% | | 1.00 | 1.21 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1046.12 ± 0.1% | not timed | not timed | 617.03 ± 0.0% | 36.51 ± 0.1% | not timed | not timed | 1046.33 ± 0.0% | | 1.00 | 1.70 | 28.65 |
| 11-unstructured-to-json/extract | 600 | 48.24 ± 0.2% | not timed | not timed | 77.80 ± 0.3% | 49.27 ± 0.5% | not timed | not timed | 47.01 ± 0.3% | | 1.03 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 571.81 ± 0.3% | not timed | not timed | 558.44 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 572.86 ± 0.1% | | 1.00 | 1.02 | 1444.14 |
| 14-quadratic/1x | 100 | 13.06 ± 0.4% | not timed | not timed | 9.95 ± 0.3% | 0.98 ± 2.5% | not timed | not timed | 13.01 ± 0.5% | | 1.00 | 1.31 | 13.31 |
| 14-quadratic/2x | 200 | 7.99 ± 0.4% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 2.0% | not timed | not timed | 7.98 ± 0.3% | | 1.00 | 1.44 | 14.92 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.1% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.8% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.53 | 16.13 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.34 ± 0.7% | 0.55 ± 4.4% | not timed | not timed | 1.54 ± 1.0% | | 1.00 | 4.51 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 85.63 ± 0.1% | not timed | not timed | 13.96 ± 0.3% | 142.20 ± 2.1% | not timed | not timed | 85.30 ± 0.8% | | 1.00 | 6.13 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 14.54 ± 0.2% | not timed | not timed | 2.52 ± 1.1% | 6.47 ± 5.9% | not timed | not timed | 14.45 ± 1.4% | | 1.01 | 5.76 | 2.25 |
| 07-unicode-character-data/compile | 1 | 54.99 ± 0.1% | not timed | not timed | 26.04 ± 0.2% | 36.70 ± 2.8% | not timed | not timed | 54.51 ± 1.0% | | 1.01 | 2.11 | 1.50 |
| 09-aws-keys/compile-full | 1 | 42.16 ± 0.3% | not timed | not timed | 8.32 ± 0.2% | 23.38 ± 1.5% | not timed | not timed | 42.14 ± 0.2% | | 1.00 | 5.07 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 189.33 ± 0.2% | not timed | not timed | 47.94 ± 0.2% | 133.87 ± 4.0% | not timed | not timed | 189.58 ± 0.7% | | 1.00 | 3.95 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.53 ± 0.6% | not timed | not timed | 11.24 ± 0.2% | 16.12 ± 2.6% | not timed | not timed | 14.44 ± 1.3% | | 1.01 | 1.29 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.40 ± 0.7% | not timed | not timed | 8.16 ± 0.2% | 23.75 ± 1.6% | not timed | not timed | 84.79 ± 1.1% | | 1.01 | 10.47 | 3.60 |
| 11-unstructured-to-json/compile | 1 | 86.49 ± 0.1% | not timed | not timed | 40.84 ± 0.7% | 68.68 ± 2.5% | not timed | not timed | 86.27 ± 1.1% | | 1.00 | 2.12 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 0.4% | 0.10 ± 17.5% | not timed | not timed | 0.36 ± 2.5% | | 1.01 | 5.14 | 3.63 |

