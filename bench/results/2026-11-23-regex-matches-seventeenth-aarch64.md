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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127383966 |
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
| literal: a word | 217 | 15989.90 ± 0.5% | 1038.81 ± 0.1% | 28.72 ± 0.2% | 18091.75 ± 1.2% | 9215.24 ± 8.9% | 17.41 ± 0.4% | 86.22 ± 0.2% | 15984.27 ± 1.5% | 15.39 | 1.00 | 0.88 | 1.74 |
| literal: a word that is not there | 0 | 18538.83 ± 1.5% | 1047.54 ± 0.5% | 28.76 ± 0.1% | 19687.62 ± 2.7% | 28798.11 ± 0.8% | 17.26 ± 0.6% | 82.15 ± 0.2% | 18575.59 ± 2.5% | 17.70 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6065.48 ± 0.5% | 1021.13 ± 0.1% | 14.74 ± 0.2% | 3949.58 ± 0.1% | 21.85 ± 0.0% | 5.25 ± 0.1% | 6.74 ± 0.3% | 6048.71 ± 0.2% | 5.94 | 1.00 | 1.54 | 277.55 |
| literal: a word in any case | 217 | 12523.03 ± 0.5% | 1040.02 ± 0.1% | 22.03 ± 0.5% | 3972.23 ± 0.3% | 38.05 ± 0.5% | refused | differs | 12544.05 ± 0.6% | 12.04 | 1.00 | 3.15 | 329.10 |
| literal: an href attribute | 33 | 13577.30 ± 1.1% | 1046.72 ± 0.1% | 27.50 ± 0.2% | 16448.22 ± 0.9% | 2257.37 ± 0.5% | 13.30 ± 0.2% | 75.68 ± 0.3% | 13524.86 ± 1.7% | 12.97 | 1.00 | 0.83 | 6.01 |
| literal: a word, second text | 123 | 16282.99 ± 1.7% | 1043.19 ± 0.2% | 28.38 ± 0.2% | 18187.26 ± 2.7% | 7695.07 ± 6.9% | 19.53 ± 0.7% | 69.67 ± 0.3% | 16265.71 ± 2.3% | 15.61 | 1.00 | 0.90 | 2.12 |
| class: two capitalized words | 1331 | 1128.66 ± 0.5% | 977.28 ± 0.1% | 26.14 ± 0.2% | 585.44 ± 0.1% | 40.54 ± 8.6% | 14.83 ± 0.3% | 68.48 ± 0.4% | 1127.31 ± 0.3% | 1.15 | 1.00 | 1.93 | 27.84 |
| class: a word that ends in ing | 3399 | 890.57 ± 0.1% | 891.01 ± 0.2% | 18.26 ± 0.2% | 547.99 ± 0.1% | 29.56 ± 1.3% | 8.15 ± 0.1% | 18.16 ± 0.4% | 889.93 ± 0.2% | 1.00 | 1.00 | 1.63 | 30.13 |
| class: a word in capitals | 2332 | 1452.92 ± 0.5% | 941.50 ± 0.5% | 27.86 ± 0.2% | 570.17 ± 0.0% | 43.58 ± 6.9% | 17.20 ± 0.3% | 82.97 ± 1.1% | 1454.24 ± 0.4% | 1.54 | 1.00 | 2.55 | 33.34 |
| class: a number | 8288 | 1994.50 ± 0.4% | 827.68 ± 0.2% | 28.03 ± 0.5% | 1718.15 ± 0.2% | 42.24 ± 7.3% | 0.56 ± 0.2% | 56.25 ± 1.3% | 1990.06 ± 0.4% | 2.41 | 1.00 | 1.16 | 47.22 |
| class: two capitalized words, second text | 5359 | 737.66 ± 0.1% | 736.63 ± 0.2% | 23.44 ± 0.1% | 484.62 ± 0.1% | 35.16 ± 14.5% | 16.69 ± 0.3% | 63.47 ± 1.2% | 736.61 ± 0.0% | 1.00 | 1.00 | 1.52 | 20.98 |
| other: a word between two words | 6104 | 759.88 ± 0.1% | 763.65 ± 0.2% | 23.67 ± 0.2% | 739.08 ± 0.2% | 109.59 ± 21.8% | 11.29 ± 0.2% | 69.27 ± 0.4% | 756.51 ± 0.1% | 1.00 | 1.00 | 1.03 | 6.93 |
| other: a number before a unit, second text | 1481 | 5495.64 ± 1.3% | 982.49 ± 0.1% | 26.00 ± 0.3% | 5635.71 ± 0.9% | 40.75 ± 0.1% | 17.81 ± 0.1% | 66.78 ± 0.2% | 5522.71 ± 0.9% | 5.59 | 1.00 | 0.98 | 134.87 |
| other: a heading's start tag | 110 | 12403.33 ± 1.0% | 1035.39 ± 0.2% | 27.58 ± 0.2% | 1710.97 ± 0.2% | 1578.67 ± 4.1% | 16.21 ± 0.6% | 88.45 ± 0.1% | 12491.43 ± 1.6% | 11.98 | 0.99 | 7.25 | 7.86 |
| other: a whole word | 217 | 13880.57 ± 1.0% | 1038.41 ± 0.1% | 29.85 ± 0.2% | 14504.80 ± 1.7% | 49.40 ± 0.1% | 13.47 ± 0.1% | 55.77 ± 0.2% | 13858.06 ± 0.4% | 13.37 | 1.00 | 0.96 | 280.98 |
| other: a line's first word, second text | 3716 | 1951.94 ± 0.7% | 868.28 ± 0.2% | 31.32 ± 0.2% | 1721.49 ± 0.3% | 62.85 ± 6.3% | refused | refused | 1949.16 ± 0.7% | 2.25 | 1.00 | 1.13 | 31.06 |
| other: fourteen octets before an x | 87 | 19466.80 ± 2.6% | 229.56 ± 0.7% | 6.14 ± 0.1% | 3971.54 ± 0.4% | 10.64 ± 0.2% | differs | 17.67 ± 0.1% | 19615.32 ± 0.6% | 84.80 | 0.99 | 4.90 | 1830.07 |
| other: a Greek word | 21815 | 470.34 ± 0.7% | 357.93 ± 0.2% | 31.10 ± 0.1% | 289.10 ± 0.5% | 46.97 ± 10.3% | differs | refused | 469.16 ± 0.2% | 1.31 | 1.00 | 1.63 | 10.01 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.2% | 25.86 ± 0.4% | 0.82 ± 0.2% | 19.70 ± 0.5% | 2.78 ± 0.8% | differs | 4.01 ± 0.3% | 25.77 ± 0.3% | 1.00 | 1.00 | 1.31 | 9.32 |
| a UUID | 32895 | 21.07 ± 0.3% | 21.11 ± 0.2% | 0.65 ± 0.1% | 15.18 ± 0.4% | 3.12 ± 0.2% | 0.71 ± 0.1% | 3.59 ± 0.5% | 21.09 ± 0.1% | 1.00 | 1.00 | 1.39 | 6.75 |
| an IPv4 address | 33176 | 37.00 ± 0.2% | 36.89 ± 0.6% | 2.09 ± 0.3% | 28.94 ± 0.2% | 6.65 ± 0.2% | differs | 4.07 ± 0.1% | 37.00 ± 0.1% | 1.00 | 1.00 | 1.28 | 5.57 |
| a date and time | 32954 | 30.99 ± 0.1% | 31.10 ± 0.1% | 1.42 ± 0.2% | 20.75 ± 1.5% | 7.06 ± 0.1% | 1.19 ± 0.1% | 7.06 ± 0.2% | 30.98 ± 0.2% | 1.00 | 1.00 | 1.49 | 4.39 |
| a field path | 32606 | 29.51 ± 0.1% | 29.41 ± 0.3% | 1.01 ± 0.8% | 22.97 ± 0.2% | 3.50 ± 1.0% | differs | 2.89 ± 0.2% | 29.50 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.52 ± 0.3% | 11.48 ± 0.3% | 11.51 ± 0.3% | 11.35 ± 0.1% | 4.93 ± 1.8% | 0.91 ± 0.6% | none | 11.53 ± 0.2% | 1.00 | 1.00 | 1.02 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.50 ± 0.2% | 223.19 ± 0.3% | 259.46 ± 0.4% | 87.00 ± 0.4% | 218.66 ± 1.0% | 487.64 ± 0.1% | 3764.56 ± 0.3% | 222.34 ± 0.2% | 1.00 | 1.00 | 2.56 | 1.02 |
| a UUID | 62 | 145.88 ± 0.3% | 146.27 ± 0.1% | 161.19 ± 0.2% | 45.71 ± 0.1% | 98.08 ± 0.9% | 184.26 ± 0.9% | 4473.03 ± 0.7% | 145.78 ± 0.3% | 1.00 | 1.00 | 3.19 | 1.49 |
| an IPv4 address | 29 | 439.62 ± 0.5% | 443.71 ± 0.4% | 613.52 ± 0.5% | 76.50 ± 0.9% | 129.35 ± 1.4% | 293.39 ± 0.9% | 7706.37 ± 0.8% | 439.21 ± 0.8% | 0.99 | 1.00 | 5.75 | 3.40 |
| a date and time | 56 | 319.12 ± 0.6% | 320.17 ± 0.3% | 400.94 ± 0.4% | 72.05 ± 0.1% | 135.37 ± 1.4% | 321.50 ± 0.6% | 4980.73 ± 0.3% | 319.24 ± 0.3% | 1.00 | 1.00 | 4.43 | 2.36 |
| a field path | 39 | 208.87 ± 0.4% | 209.72 ± 0.2% | 241.16 ± 0.4% | 79.63 ± 0.5% | 201.71 ± 18.6% | 486.03 ± 0.5% | 4856.36 ± 0.4% | 209.11 ± 0.4% | 1.00 | 1.00 | 2.62 | 1.04 |
| literal: a word | 7 | 666.48 ± 0.9% | 717.07 ± 0.6% | 1281.24 ± 0.9% | 507.56 ± 1.6% | 614.98 ± 1.2% | 921.26 ± 0.6% | 30662.29 ± 0.2% | 666.78 ± 0.5% | 0.93 | 1.00 | 1.31 | 1.08 |
| literal: a word that is not there | 8 | 640.49 ± 0.3% | 695.32 ± 0.4% | 1204.73 ± 0.2% | 463.52 ± 0.2% | 594.77 ± 2.3% | 874.70 ± 0.7% | 29598.98 ± 0.1% | 640.60 ± 0.2% | 0.92 | 1.00 | 1.38 | 1.08 |
| literal: one of four words | 26 | 256.26 ± 0.4% | 420.42 ± 0.4% | 567.95 ± 0.3% | 49.47 ± 0.3% | 238.67 ± 2.0% | 354.48 ± 0.5% | 15810.81 ± 0.3% | 256.45 ± 0.2% | 0.61 | 1.00 | 5.18 | 1.07 |
| literal: a word in any case | 11 | 523.73 ± 0.2% | 565.36 ± 0.3% | 871.33 ± 0.2% | 15.80 ± 1.1% | 642.07 ± 2.2% | refused | 23834.35 ± 0.3% | 523.68 ± 0.3% | 0.93 | 1.00 | 33.15 | 0.82 |
| literal: an href attribute | 12 | 351.26 ± 0.3% | 362.58 ± 0.3% | 470.77 ± 0.6% | 12.68 ± 41.2% | 491.50 ± 1.3% | 753.00 ± 2.8% | 22437.43 ± 0.2% | 351.36 ± 0.4% | 0.97 | 1.00 | 27.70 | 0.71 |
| literal: a word, second text | 10 | 593.97 ± 0.2% | 654.80 ± 0.1% | 1093.59 ± 0.1% | 415.04 ± 0.3% | 527.88 ± 0.7% | 791.43 ± 0.5% | 27575.69 ± 0.1% | 593.87 ± 0.4% | 0.91 | 1.00 | 1.43 | 1.13 |
| class: two capitalized words | 23 | 461.81 ± 0.3% | 491.71 ± 0.2% | 709.43 ± 0.3% | 100.45 ± 0.2% | 495.31 ± 1.4% | 745.07 ± 0.8% | 6392.25 ± 0.1% | 462.36 ± 0.4% | 0.94 | 1.00 | 4.60 | 0.93 |
| class: a word that ends in ing | 9 | 599.45 ± 0.4% | 667.61 ± 0.4% | 1170.69 ± 0.2% | 132.16 ± 0.6% | 750.71 ± 0.8% | 1103.79 ± 1.4% | 15983.50 ± 0.1% | 599.33 ± 0.2% | 0.90 | 1.00 | 4.54 | 0.80 |
| class: a word in capitals | 16 | 526.53 ± 0.8% | 566.43 ± 0.5% | 902.86 ± 1.2% | 135.01 ± 0.9% | 743.79 ± 0.5% | 1004.38 ± 1.3% | 8402.72 ± 0.2% | 526.71 ± 0.8% | 0.93 | 1.00 | 3.90 | 0.71 |
| class: a number | 6 | 666.08 ± 0.3% | 726.69 ± 0.9% | 1364.54 ± 0.1% | 41.99 ± 0.7% | 1383.97 ± 1.0% | 1842.46 ± 1.1% | 23185.49 ± 0.1% | 667.62 ± 0.2% | 0.92 | 1.00 | 15.86 | 0.48 |
| class: two capitalized words, second text | 23 | 462.17 ± 0.2% | 491.55 ± 0.5% | 709.98 ± 0.2% | 101.39 ± 0.2% | 493.50 ± 1.5% | 766.89 ± 0.7% | 6391.90 ± 0.2% | 461.96 ± 0.5% | 0.94 | 1.00 | 4.56 | 0.94 |
| other: a word between two words | 13 | 582.02 ± 0.2% | 601.46 ± 0.3% | 957.48 ± 0.2% | 134.82 ± 0.7% | 493.79 ± 1.5% | 805.94 ± 2.5% | 14754.22 ± 0.1% | 580.79 ± 0.4% | 0.97 | 1.00 | 4.32 | 1.18 |
| other: a number before a unit, second text | 15 | 405.76 ± 0.1% | 442.26 ± 0.2% | 609.90 ± 0.1% | 39.18 ± 0.3% | 627.55 ± 0.5% | 882.10 ± 0.7% | 15385.62 ± 0.6% | 405.86 ± 0.4% | 0.92 | 1.00 | 10.36 | 0.65 |
| other: a heading's start tag | 13 | 363.72 ± 0.2% | 368.58 ± 0.5% | 480.07 ± 0.2% | 11.52 ± 32.7% | 617.08 ± 1.4% | 864.67 ± 1.1% | 18583.80 ± 0.1% | 363.70 ± 0.3% | 0.99 | 1.00 | 31.58 | 0.59 |
| other: a whole word | 11 | 614.22 ± 0.6% | 653.19 ± 0.5% | 1085.87 ± 0.7% | 121.10 ± 0.1% | 558.20 ± 1.9% | 816.70 ± 0.7% | 26983.64 ± 1.9% | 615.58 ± 0.8% | 0.94 | 1.00 | 5.07 | 1.10 |
| other: a line's first word, second text | 17 | 560.12 ± 1.1% | 582.43 ± 0.1% | 934.71 ± 0.0% | 128.29 ± 0.2% | 701.50 ± 1.3% | refused | refused | 559.81 ± 1.6% | 0.96 | 1.00 | 4.37 | 0.80 |
| other: fourteen octets before an x | 16 | 113.29 ± 0.5% | 163.10 ± 0.6% | 185.98 ± 0.6% | 6.59 ± 35.2% | 446.15 ± 2.4% | 416.61 ± 0.7% | 13047.36 ± 0.3% | 113.39 ± 0.6% | 0.69 | 1.00 | 17.18 | 0.25 |
| other: a Greek word | 8 | 449.98 ± 0.3% | 592.37 ± 0.3% | 962.31 ± 0.1% | 14.84 ± 6.8% | 1360.54 ± 1.0% | 1735.30 ± 0.7% | refused | 450.12 ± 0.5% | 0.76 | 1.00 | 30.31 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12711.08 ± 1.3% | not timed | not timed | 15908.74 ± 1.9% | 2042.43 ± 15.2% | not timed | not timed | 12636.54 ± 2.7% | | 1.01 | 0.80 | 6.22 |
| 01-literal/sherlock-casei-en | 522 | 3879.40 ± 0.4% | not timed | not timed | 3589.42 ± 0.1% | 32.49 ± 0.2% | not timed | not timed | 3876.62 ± 0.2% | | 1.00 | 1.08 | 119.39 |
| 01-literal/sherlock-ru | 724 | 13614.33 ± 0.4% | not timed | not timed | 17281.06 ± 0.5% | 1356.94 ± 9.5% | not timed | not timed | 13605.56 ± 0.3% | | 1.00 | 0.79 | 10.03 |
| 01-literal/sherlock-casei-ru | 746 | 5242.68 ± 0.3% | not timed | not timed | 3328.86 ± 0.2% | 31.28 ± 3.0% | not timed | not timed | 5230.24 ± 0.3% | | 1.00 | 1.57 | 167.61 |
| 01-literal/sherlock-zh | 30 | 16678.98 ± 0.6% | not timed | not timed | 18207.09 ± 1.3% | 2706.19 ± 14.5% | not timed | not timed | 16512.53 ± 1.0% | | 1.01 | 0.92 | 6.16 |
| 02-literal-alternate/sherlock-en | 714 | 5830.34 ± 0.3% | not timed | not timed | 3945.89 ± 0.1% | 16.61 ± 0.0% | not timed | not timed | 5830.96 ± 0.3% | | 1.00 | 1.48 | 350.94 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1668.09 ± 0.8% | not timed | not timed | 698.44 ± 0.4% | 11.13 ± 0.1% | not timed | not timed | 1663.36 ± 0.2% | | 1.00 | 2.39 | 149.84 |
| 02-literal-alternate/sherlock-ru | 899 | 4654.61 ± 0.2% | not timed | not timed | 3257.73 ± 0.1% | 22.64 ± 0.1% | not timed | not timed | 4622.31 ± 0.2% | | 1.01 | 1.43 | 205.63 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1778.86 ± 0.5% | not timed | not timed | 1231.24 ± 0.5% | 9.15 ± 0.1% | not timed | not timed | 1759.85 ± 0.3% | | 1.01 | 1.44 | 194.46 |
| 02-literal-alternate/sherlock-zh | 207 | 7032.98 ± 0.4% | not timed | not timed | 4155.87 ± 0.1% | 31.49 ± 0.1% | not timed | not timed | 7039.86 ± 0.4% | | 1.00 | 1.69 | 223.36 |
| 03-date/ascii | 111817 | 124.98 ± 0.7% | not timed | not timed | 95.72 ± 0.1% | 0.20 ± 3.2% | not timed | not timed | 123.46 ± 0.3% | | 1.01 | 1.31 | 617.63 |
| 04-ruff-noqa/real | 84 | 555.02 ± 0.4% | not timed | not timed | 461.66 ± 0.1% | 19.53 ± 2.4% | not timed | not timed | 555.47 ± 0.1% | | 1.00 | 1.20 | 28.42 |
| 04-ruff-noqa/tweaked | 44 | 545.52 ± 0.2% | not timed | not timed | 460.56 ± 0.0% | 363.58 ± 0.2% | not timed | not timed | 544.64 ± 0.1% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.3% | not timed | not timed | 5.07 ± 0.3% | 0.20 ± 4.8% | not timed | not timed | 3.65 ± 2.5% | | 1.01 | 0.72 | 18.35 |
| 06-cloud-flare-redos/original | 107 | 270.44 ± 0.2% | not timed | not timed | 214.71 ± 0.1% | 24.83 ± 0.1% | not timed | not timed | 269.20 ± 0.2% | | 1.00 | 1.26 | 10.89 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.58 ± 0.3% | not timed | not timed | 227.23 ± 0.0% | 26.66 ± 0.2% | not timed | not timed | 264.54 ± 0.9% | | 1.00 | 1.16 | 9.93 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.34 ± 0.2% | not timed | not timed | 255.90 ± 0.3% | 28.72 ± 0.2% | not timed | not timed | 294.25 ± 0.2% | | 1.00 | 1.15 | 10.25 |
| 07-unicode-character-data/parse-line | 558784 | 239.49 ± 2.7% | not timed | not timed | 168.84 ± 1.5% | 42.79 ± 5.0% | not timed | not timed | 240.88 ± 2.3% | | 0.99 | 1.42 | 5.60 |
| 08-words/all-english | 56691 | 119.65 ± 0.3% | not timed | not timed | 82.85 ± 0.1% | 13.05 ± 2.7% | not timed | not timed | 119.45 ± 0.3% | | 1.00 | 1.44 | 9.17 |
| 08-words/long-english | 839 | 1005.47 ± 0.1% | not timed | not timed | 596.05 ± 0.1% | 32.60 ± 0.5% | not timed | not timed | 1005.62 ± 0.1% | | 1.00 | 1.69 | 30.84 |
| 09-aws-keys/full | 0 | 413.04 ± 0.1% | not timed | not timed | 460.59 ± 0.1% | 64.57 ± 3.4% | not timed | not timed | 412.96 ± 0.1% | | 1.00 | 0.90 | 6.40 |
| 09-aws-keys/quick | 0 | 738.41 ± 0.1% | not timed | not timed | 994.26 ± 0.1% | 419.79 ± 0.5% | not timed | not timed | 735.41 ± 0.2% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 636.08 ± 0.4% | not timed | not timed | 516.62 ± 0.1% | 19.53 ± 0.5% | not timed | not timed | 634.68 ± 0.3% | | 1.00 | 1.23 | 32.57 |
| 10-bounded-repeat/letters-ru | 3475 | 380.37 ± 0.1% | not timed | not timed | 477.20 ± 0.2% | 21.99 ± 9.0% | not timed | not timed | 376.08 ± 0.4% | | 1.01 | 0.80 | 17.30 |
| 10-bounded-repeat/context | 53 | 79.23 ± 1.1% | not timed | not timed | 65.38 ± 0.6% | 19.80 ± 0.2% | not timed | not timed | 78.70 ± 2.1% | | 1.01 | 1.21 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1044.96 ± 0.1% | not timed | not timed | 618.63 ± 0.1% | 36.55 ± 0.1% | not timed | not timed | 1045.08 ± 0.0% | | 1.00 | 1.69 | 28.59 |
| 11-unstructured-to-json/extract | 600 | 47.70 ± 0.1% | not timed | not timed | 77.93 ± 0.3% | 49.11 ± 0.6% | not timed | not timed | 47.01 ± 0.1% | | 1.01 | 0.61 | 0.97 |
| 12-dictionary/single | 1 | 571.95 ± 0.1% | not timed | not timed | 556.05 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 573.18 ± 0.1% | | 1.00 | 1.03 | 1428.18 |
| 14-quadratic/1x | 100 | 13.03 ± 0.2% | not timed | not timed | 9.92 ± 0.1% | 0.96 ± 2.7% | not timed | not timed | 12.99 ± 1.3% | | 1.00 | 1.31 | 13.52 |
| 14-quadratic/2x | 200 | 7.99 ± 0.2% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 0.5% | not timed | not timed | 7.95 ± 1.5% | | 1.00 | 1.44 | 14.97 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.1% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.53 | 16.05 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.3% | not timed | not timed | 0.34 ± 0.7% | 0.54 ± 2.7% | not timed | not timed | 1.53 ± 0.9% | | 1.00 | 4.50 | 2.83 |
| 04-ruff-noqa/compile-real | 1 | 87.21 ± 0.1% | not timed | not timed | 13.84 ± 0.3% | 138.60 ± 1.6% | not timed | not timed | 86.74 ± 0.8% | | 1.01 | 6.30 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 14.30 ± 0.1% | not timed | not timed | 2.51 ± 0.5% | 6.41 ± 4.3% | not timed | not timed | 14.16 ± 1.1% | | 1.01 | 5.69 | 2.23 |
| 07-unicode-character-data/compile | 1 | 55.38 ± 0.2% | not timed | not timed | 26.01 ± 0.3% | 35.43 ± 2.0% | not timed | not timed | 55.17 ± 1.5% | | 1.00 | 2.13 | 1.56 |
| 09-aws-keys/compile-full | 1 | 42.28 ± 0.2% | not timed | not timed | 8.25 ± 0.4% | 23.16 ± 0.5% | not timed | not timed | 42.22 ± 1.0% | | 1.00 | 5.12 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 190.24 ± 0.1% | not timed | not timed | 47.38 ± 0.3% | 134.06 ± 2.5% | not timed | not timed | 190.35 ± 1.0% | | 1.00 | 4.02 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.59 ± 0.6% | not timed | not timed | 11.10 ± 0.1% | 15.74 ± 2.4% | not timed | not timed | 14.50 ± 1.1% | | 1.01 | 1.31 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 85.24 ± 0.2% | not timed | not timed | 8.10 ± 0.1% | 23.32 ± 1.2% | not timed | not timed | 84.68 ± 0.9% | | 1.01 | 10.53 | 3.66 |
| 11-unstructured-to-json/compile | 1 | 86.83 ± 0.4% | not timed | not timed | 41.42 ± 0.5% | 67.98 ± 3.0% | not timed | not timed | 86.42 ± 0.7% | | 1.00 | 2.10 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.2% | not timed | not timed | 0.07 ± 20.9% | 0.09 ± 13.1% | not timed | not timed | 0.35 ± 0.9% | | 1.00 | 5.19 | 3.70 |

