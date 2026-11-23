# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102094978 |
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
| literal: a word | 217 | 31084.45 ± 1.2% | 894.94 ± 0.9% | 20.41 ± 2.0% | 31399.59 ± 2.1% | 8969.58 ± 10.1% | 10.78 ± 0.2% | 76.22 ± 2.5% | 30547.37 ± 2.4% | 34.73 | 1.02 | 0.99 | 3.47 |
| literal: a word that is not there | 0 | 42696.44 ± 3.4% | 906.18 ± 0.1% | 20.16 ± 3.4% | 39902.82 ± 3.6% | 30260.89 ± 0.7% | 10.73 ± 0.2% | 71.91 ± 0.8% | 42315.32 ± 1.3% | 47.12 | 1.01 | 1.07 | 1.41 |
| literal: one of four words | 661 | 11364.53 ± 4.2% | 868.88 ± 0.2% | 11.14 ± 1.3% | 9046.78 ± 1.1% | 19.27 ± 5.3% | 3.96 ± 0.2% | 6.68 ± 1.2% | 11323.28 ± 0.6% | 13.08 | 1.00 | 1.26 | 589.72 |
| literal: a word in any case | 217 | 24945.54 ± 1.7% | 893.26 ± 0.4% | 15.49 ± 2.7% | 9228.29 ± 1.3% | 37.20 ± 20.0% | refused | differs | 24504.36 ± 16.1% | 27.93 | 1.02 | 2.70 | 670.49 |
| literal: an href attribute | 33 | 26052.66 ± 1.1% | 901.53 ± 1.2% | 18.91 ± 2.2% | 27300.55 ± 0.8% | 2057.13 ± 0.2% | 8.27 ± 0.2% | 61.43 ± 11.4% | 25939.89 ± 4.2% | 28.90 | 1.00 | 0.95 | 12.66 |
| literal: a word, second text | 123 | 31606.37 ± 2.8% | 898.50 ± 2.2% | 20.30 ± 3.3% | 31892.11 ± 0.7% | 7251.90 ± 3.8% | 11.65 ± 0.9% | 65.11 ± 1.7% | 31581.04 ± 2.7% | 35.18 | 1.00 | 0.99 | 4.36 |
| class: two capitalized words | 1331 | 766.21 ± 0.2% | 815.52 ± 0.1% | 19.32 ± 3.9% | 505.53 ± 0.2% | 34.38 ± 1.5% | 9.12 ± 0.2% | 55.72 ± 0.6% | 764.28 ± 0.6% | 0.94 | 1.00 | 1.52 | 22.29 |
| class: a word that ends in ing | 3399 | 734.95 ± 1.4% | 733.91 ± 1.0% | 13.52 ± 1.2% | 473.23 ± 0.6% | 25.66 ± 1.4% | 5.33 ± 0.4% | 17.21 ± 3.4% | 733.85 ± 0.9% | 1.00 | 1.00 | 1.55 | 28.64 |
| class: a word in capitals | 2332 | 986.35 ± 1.6% | 797.44 ± 0.2% | 20.21 ± 6.0% | 497.94 ± 0.5% | 36.70 ± 1.6% | 10.45 ± 0.2% | 76.45 ± 0.9% | 987.01 ± 0.1% | 1.24 | 1.00 | 1.98 | 26.87 |
| class: a number | 8288 | 1437.82 ± 2.0% | 649.12 ± 1.0% | 19.75 ± 2.6% | 1447.49 ± 4.5% | 37.09 ± 12.6% | 0.34 ± 0.4% | 55.79 ± 2.6% | 1463.69 ± 2.0% | 2.22 | 0.98 | 0.99 | 38.77 |
| class: two capitalized words, second text | 5359 | 569.73 ± 0.5% | 579.40 ± 0.1% | 17.34 ± 2.7% | 417.61 ± 0.2% | 29.20 ± 9.0% | 10.59 ± 0.7% | 51.68 ± 0.5% | 578.51 ± 2.7% | 0.98 | 0.98 | 1.36 | 19.51 |
| other: a word between two words | 6104 | 651.26 ± 0.2% | 617.54 ± 0.4% | 17.41 ± 2.3% | 698.81 ± 3.4% | 96.73 ± 13.9% | 7.26 ± 0.2% | 56.53 ± 9.6% | 653.88 ± 0.1% | 1.05 | 1.00 | 0.93 | 6.73 |
| other: a number before a unit, second text | 1481 | 6778.34 ± 3.8% | 827.52 ± 0.1% | 18.81 ± 5.1% | 6431.92 ± 0.3% | 35.21 ± 5.9% | 11.03 ± 0.3% | 55.22 ± 0.2% | 6777.33 ± 3.7% | 8.19 | 1.00 | 1.05 | 192.49 |
| other: a heading's start tag | 110 | 18645.58 ± 0.6% | 894.06 ± 0.1% | 19.72 ± 2.8% | 2004.80 ± 2.1% | 1482.35 ± 3.8% | 10.05 ± 0.2% | 72.80 ± 0.3% | 18638.77 ± 0.4% | 20.85 | 1.00 | 9.30 | 12.58 |
| other: a whole word | 217 | 21862.20 ± 4.0% | 893.52 ± 0.8% | 19.92 ± 5.1% | 22641.75 ± 6.8% | 41.37 ± 0.2% | 9.51 ± 0.1% | 46.89 ± 1.2% | 21820.43 ± 7.4% | 24.47 | 1.00 | 0.97 | 528.47 |
| other: a line's first word, second text | 3716 | 1762.23 ± 0.5% | 716.54 ± 0.2% | 22.35 ± 8.5% | 1709.27 ± 1.2% | 53.47 ± 5.4% | refused | refused | 1755.25 ± 0.4% | 2.46 | 1.00 | 1.03 | 32.96 |
| other: fourteen octets before an x | 87 | 25381.10 ± 1.7% | 199.54 ± 0.4% | 4.39 ± 1.0% | 2973.00 ± 0.7% | 9.02 ± 0.3% | differs | 15.53 ± 1.6% | 25424.16 ± 1.5% | 127.20 | 1.00 | 8.54 | 2815.21 |
| other: a Greek word | 21815 | 382.02 ± 0.5% | 265.77 ± 0.1% | 23.91 ± 1.9% | 263.80 ± 0.7% | 38.79 ± 17.1% | differs | refused | 383.17 ± 5.9% | 1.44 | 1.00 | 1.45 | 9.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.31 ± 0.3% | 25.30 ± 0.3% | 0.74 ± 5.8% | 16.77 ± 0.5% | 1.72 ± 4.9% | differs | 3.65 ± 1.4% | 25.35 ± 0.5% | 1.00 | 1.00 | 1.51 | 14.68 |
| a UUID | 32895 | 20.79 ± 7.0% | 20.74 ± 0.7% | 0.57 ± 6.3% | 12.83 ± 0.2% | 2.50 ± 2.3% | 0.43 ± 0.2% | 3.10 ± 0.3% | 20.78 ± 2.4% | 1.00 | 1.00 | 1.62 | 8.30 |
| an IPv4 address | 33176 | 35.68 ± 0.5% | 35.73 ± 0.5% | 1.84 ± 1.8% | 23.96 ± 0.6% | 5.78 ± 1.4% | differs | 3.43 ± 9.7% | 35.68 ± 1.5% | 1.00 | 1.00 | 1.49 | 6.18 |
| a date and time | 32954 | 31.04 ± 8.6% | 30.98 ± 0.4% | 1.27 ± 0.3% | 17.97 ± 0.2% | 6.66 ± 2.3% | 0.75 ± 0.7% | 6.21 ± 0.5% | 30.93 ± 8.5% | 1.00 | 1.00 | 1.73 | 4.66 |
| a field path | 32606 | 28.30 ± 0.6% | 28.38 ± 8.4% | 0.85 ± 0.8% | 19.39 ± 0.4% | 2.93 ± 0.4% | differs | 2.47 ± 0.8% | 28.39 ± 1.4% | 1.00 | 1.00 | 1.46 | 9.66 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.71 ± 0.4% | 7.71 ± 0.4% | 7.71 ± 2.7% | 10.56 ± 6.2% | 4.74 ± 2.1% | 0.62 ± 1.8% | none | 7.71 ± 2.4% | 1.00 | 1.00 | 0.73 | 1.63 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 189.84 ± 8.8% | 193.02 ± 2.6% | 224.65 ± 2.0% | 78.13 ± 6.3% | 183.89 ± 6.4% | 529.03 ± 3.5% | 3936.87 ± 1.9% | 192.28 ± 2.4% | 0.98 | 0.99 | 2.43 | 1.03 |
| a UUID | 62 | 124.45 ± 3.1% | 125.06 ± 0.9% | 139.69 ± 0.4% | 47.03 ± 1.6% | 89.89 ± 1.5% | 198.12 ± 2.6% | 4142.81 ± 0.7% | 124.15 ± 0.7% | 1.00 | 1.00 | 2.65 | 1.38 |
| an IPv4 address | 29 | 387.78 ± 1.1% | 388.46 ± 3.0% | 559.14 ± 2.0% | 69.78 ± 2.4% | 114.17 ± 1.8% | 322.08 ± 4.4% | 7187.08 ± 0.3% | 388.41 ± 3.6% | 1.00 | 1.00 | 5.56 | 3.40 |
| a date and time | 56 | 280.46 ± 7.2% | 282.93 ± 0.2% | 361.40 ± 0.3% | 68.42 ± 2.0% | 124.05 ± 2.1% | 361.43 ± 11.0% | 4217.47 ± 1.2% | 280.23 ± 0.3% | 0.99 | 1.00 | 4.10 | 2.26 |
| a field path | 39 | 187.92 ± 0.3% | 188.96 ± 1.1% | 221.87 ± 0.6% | 74.42 ± 2.5% | 173.42 ± 1.2% | 591.48 ± 6.8% | 4828.11 ± 3.1% | 187.87 ± 0.4% | 0.99 | 1.00 | 2.52 | 1.08 |
| literal: a word | 7 | 570.14 ± 0.3% | 609.16 ± 0.9% | 1127.07 ± 0.9% | 504.23 ± 9.5% | 574.57 ± 3.8% | 1233.29 ± 0.7% | 24717.48 ± 2.2% | 569.35 ± 1.6% | 0.94 | 1.00 | 1.13 | 0.99 |
| literal: a word that is not there | 8 | 549.49 ± 0.2% | 591.34 ± 1.0% | 1063.32 ± 0.5% | 464.00 ± 0.9% | 560.98 ± 3.0% | 1164.86 ± 1.0% | 23723.33 ± 0.7% | 549.74 ± 12.4% | 0.93 | 1.00 | 1.18 | 0.98 |
| literal: one of four words | 26 | 216.18 ± 0.3% | 360.93 ± 0.2% | 498.20 ± 11.2% | 41.95 ± 0.9% | 220.35 ± 3.3% | 444.68 ± 8.3% | 11518.88 ± 2.8% | 216.28 ± 0.2% | 0.60 | 1.00 | 5.15 | 0.98 |
| literal: a word in any case | 11 | 446.36 ± 0.8% | 475.23 ± 2.5% | 750.10 ± 0.5% | 14.59 ± 1.8% | 611.25 ± 1.5% | refused | 19559.13 ± 1.1% | 445.42 ± 0.9% | 0.94 | 1.00 | 30.59 | 0.73 |
| literal: an href attribute | 12 | 318.16 ± 0.8% | 328.16 ± 0.8% | 445.47 ± 1.1% | 37.04 ± 0.3% | 427.45 ± 1.6% | 889.34 ± 6.4% | 18868.03 ± 0.7% | 317.36 ± 0.6% | 0.97 | 1.00 | 8.59 | 0.74 |
| literal: a word, second text | 10 | 511.78 ± 3.1% | 556.36 ± 8.3% | 961.90 ± 0.9% | 410.91 ± 1.4% | 482.55 ± 2.5% | 939.91 ± 1.1% | 21331.46 ± 2.4% | 510.35 ± 1.1% | 0.92 | 1.00 | 1.25 | 1.06 |
| class: two capitalized words | 23 | 414.34 ± 0.4% | 444.42 ± 2.4% | 669.77 ± 0.7% | 94.99 ± 0.6% | 445.32 ± 1.7% | 919.42 ± 0.9% | 6404.12 ± 10.3% | 413.77 ± 0.8% | 0.93 | 1.00 | 4.36 | 0.93 |
| class: a word that ends in ing | 9 | 496.98 ± 0.3% | 557.28 ± 0.2% | 1031.68 ± 0.7% | 112.93 ± 1.3% | 629.11 ± 2.5% | 1390.70 ± 0.8% | 15275.88 ± 0.6% | 495.80 ± 2.9% | 0.89 | 1.00 | 4.40 | 0.79 |
| class: a word in capitals | 16 | 430.17 ± 0.5% | 463.12 ± 0.8% | 789.83 ± 2.2% | 120.26 ± 1.1% | 643.46 ± 3.6% | 1278.03 ± 2.4% | 8381.02 ± 0.4% | 430.12 ± 0.4% | 0.93 | 1.00 | 3.58 | 0.67 |
| class: a number | 6 | 537.31 ± 0.5% | 591.01 ± 0.8% | 1173.19 ± 1.0% | 36.39 ± 1.0% | 1174.31 ± 7.4% | 2237.31 ± 6.1% | 20449.11 ± 0.3% | 537.69 ± 0.4% | 0.91 | 1.00 | 14.77 | 0.46 |
| class: two capitalized words, second text | 23 | 413.11 ± 1.5% | 444.86 ± 1.9% | 669.33 ± 11.0% | 95.53 ± 0.6% | 446.56 ± 2.0% | 921.08 ± 0.7% | 6391.43 ± 0.4% | 413.64 ± 0.9% | 0.93 | 1.00 | 4.32 | 0.93 |
| other: a word between two words | 13 | 491.71 ± 2.9% | 508.67 ± 0.9% | 837.61 ± 1.1% | 122.01 ± 1.8% | 437.49 ± 1.8% | 1025.64 ± 0.7% | 14105.95 ± 11.7% | 491.21 ± 0.6% | 0.97 | 1.00 | 4.03 | 1.12 |
| other: a number before a unit, second text | 15 | 357.98 ± 0.6% | 393.74 ± 0.4% | 562.09 ± 0.3% | 33.85 ± 0.7% | 534.78 ± 5.8% | 1099.23 ± 6.1% | 13942.47 ± 0.3% | 357.95 ± 0.3% | 0.91 | 1.00 | 10.57 | 0.67 |
| other: a heading's start tag | 13 | 331.05 ± 1.9% | 336.78 ± 0.2% | 460.14 ± 0.6% | 35.84 ± 0.2% | 521.39 ± 3.2% | 1065.30 ± 0.4% | 16167.37 ± 1.3% | 330.89 ± 0.2% | 0.98 | 1.00 | 9.24 | 0.63 |
| other: a whole word | 11 | 504.19 ± 0.6% | 534.50 ± 0.6% | 889.98 ± 1.2% | 108.35 ± 0.7% | 506.21 ± 2.1% | 1045.95 ± 0.9% | 20874.85 ± 2.4% | 503.50 ± 0.6% | 0.94 | 1.00 | 4.65 | 1.00 |
| other: a line's first word, second text | 17 | 473.57 ± 3.0% | 498.84 ± 0.6% | 853.32 ± 0.3% | 113.72 ± 3.9% | 584.13 ± 3.1% | refused | refused | 473.04 ± 0.9% | 0.95 | 1.00 | 4.16 | 0.81 |
| other: fourteen octets before an x | 16 | 86.72 ± 2.3% | 121.71 ± 2.8% | 144.40 ± 2.4% | 14.22 ± 4.2% | 384.02 ± 23.2% | 442.19 ± 2.8% | 11721.05 ± 19.8% | 86.04 ± 2.1% | 0.71 | 1.01 | 6.10 | 0.23 |
| other: a Greek word | 8 | 363.55 ± 5.1% | 506.45 ± 0.7% | 866.33 ± 0.4% | 46.83 ± 1.5% | 1145.12 ± 2.9% | 2153.40 ± 0.5% | refused | 362.46 ± 0.6% | 0.72 | 1.00 | 7.76 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20189.37 ± 2.3% | not timed | not timed | 27123.27 ± 1.1% | 1948.75 ± 27.6% | not timed | not timed | 20229.53 ± 1.2% | | 1.00 | 0.74 | 10.36 |
| 01-literal/sherlock-casei-en | 522 | 4573.89 ± 0.8% | not timed | not timed | 7044.40 ± 0.2% | 28.64 ± 1.0% | not timed | not timed | 4582.04 ± 0.2% | | 1.00 | 0.65 | 159.72 |
| 01-literal/sherlock-ru | 724 | 21878.79 ± 0.4% | not timed | not timed | 27545.08 ± 1.1% | 1048.85 ± 20.6% | not timed | not timed | 21998.91 ± 1.1% | | 0.99 | 0.79 | 20.86 |
| 01-literal/sherlock-casei-ru | 746 | 7324.87 ± 0.3% | not timed | not timed | 5397.25 ± 0.5% | 30.50 ± 1.2% | not timed | not timed | 7308.40 ± 14.1% | | 1.00 | 1.36 | 240.16 |
| 01-literal/sherlock-zh | 30 | 38636.18 ± 1.9% | not timed | not timed | 36712.44 ± 0.7% | 1265.69 ± 0.9% | not timed | not timed | 38477.57 ± 2.0% | | 1.00 | 1.05 | 30.53 |
| 02-literal-alternate/sherlock-en | 714 | 9859.59 ± 0.8% | not timed | not timed | 8867.30 ± 0.8% | 14.47 ± 4.5% | not timed | not timed | 9862.06 ± 17.8% | | 1.00 | 1.11 | 681.16 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1742.79 ± 1.1% | not timed | not timed | 1815.20 ± 0.3% | 9.51 ± 4.6% | not timed | not timed | 1719.95 ± 1.0% | | 1.01 | 0.96 | 183.30 |
| 02-literal-alternate/sherlock-ru | 899 | 5993.31 ± 1.1% | not timed | not timed | 4247.54 ± 0.4% | 19.54 ± 1.0% | not timed | not timed | 6003.04 ± 0.4% | | 1.00 | 1.41 | 306.73 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1812.68 ± 0.2% | not timed | not timed | 1045.32 ± 1.0% | 8.60 ± 0.6% | not timed | not timed | 1812.37 ± 1.8% | | 1.00 | 1.73 | 210.89 |
| 02-literal-alternate/sherlock-zh | 207 | 13851.25 ± 1.1% | not timed | not timed | 10333.21 ± 0.3% | 27.09 ± 0.5% | not timed | not timed | 13891.82 ± 0.7% | | 1.00 | 1.34 | 511.38 |
| 03-date/ascii | 111817 | 106.99 ± 0.6% | not timed | not timed | 84.15 ± 0.1% | 0.18 ± 4.2% | not timed | not timed | 107.66 ± 0.9% | | 0.99 | 1.27 | 603.13 |
| 04-ruff-noqa/real | 84 | 563.22 ± 16.2% | not timed | not timed | 441.47 ± 1.1% | 15.31 ± 3.7% | not timed | not timed | 562.46 ± 22.0% | | 1.00 | 1.28 | 36.79 |
| 04-ruff-noqa/tweaked | 44 | 489.46 ± 0.6% | not timed | not timed | 432.67 ± 0.3% | 288.46 ± 2.0% | not timed | not timed | 489.35 ± 0.3% | | 1.00 | 1.13 | 1.70 |
| 05-lexer-veryl/single | 124800 | 2.93 ± 2.0% | not timed | not timed | 4.12 ± 2.9% | 0.21 ± 4.7% | not timed | not timed | 2.91 ± 6.9% | | 1.01 | 0.71 | 13.81 |
| 06-cloud-flare-redos/original | 107 | 177.59 ± 1.5% | not timed | not timed | 192.83 ± 1.8% | 13.16 ± 1.3% | not timed | not timed | 177.20 ± 0.7% | | 1.00 | 0.92 | 13.49 |
| 06-cloud-flare-redos/simplified-short | 102 | 127.30 ± 0.5% | not timed | not timed | 192.07 ± 1.2% | 14.08 ± 2.0% | not timed | not timed | 126.68 ± 2.3% | | 1.00 | 0.66 | 9.04 |
| 06-cloud-flare-redos/simplified-long | 10000 | 134.55 ± 1.8% | not timed | not timed | 208.39 ± 1.8% | 14.61 ± 2.3% | not timed | not timed | 135.38 ± 2.3% | | 0.99 | 0.65 | 9.21 |
| 07-unicode-character-data/parse-line | 558784 | 31.15 ± 0.2% | not timed | not timed | 161.72 ± 0.6% | 37.07 ± 2.9% | not timed | not timed | 35.40 ± 2.2% | | 0.88 | 0.19 | 0.84 |
| 08-words/all-english | 56691 | 73.44 ± 0.8% | not timed | not timed | 73.17 ± 0.3% | 10.09 ± 7.2% | not timed | not timed | 73.46 ± 0.3% | | 1.00 | 1.00 | 7.28 |
| 08-words/long-english | 839 | 849.54 ± 0.3% | not timed | not timed | 514.74 ± 0.6% | 26.67 ± 10.1% | not timed | not timed | 848.75 ± 0.2% | | 1.00 | 1.65 | 31.85 |
| 09-aws-keys/full | 0 | 429.96 ± 1.7% | not timed | not timed | 436.28 ± 0.2% | 45.48 ± 5.3% | not timed | not timed | 430.83 ± 0.5% | | 1.00 | 0.99 | 9.45 |
| 09-aws-keys/quick | 0 | 443.91 ± 0.4% | not timed | not timed | 803.70 ± 0.2% | 301.41 ± 4.3% | not timed | not timed | 441.52 ± 0.5% | | 1.01 | 0.55 | 1.47 |
| 10-bounded-repeat/letters-en | 1833 | 470.40 ± 0.4% | not timed | not timed | 431.96 ± 1.5% | 16.82 ± 2.3% | not timed | not timed | 470.64 ± 0.5% | | 1.00 | 1.09 | 27.97 |
| 10-bounded-repeat/letters-ru | 3475 | 325.68 ± 0.6% | not timed | not timed | 408.26 ± 3.1% | 19.64 ± 15.3% | not timed | not timed | 323.04 ± 0.2% | | 1.01 | 0.80 | 16.58 |
| 10-bounded-repeat/context | 53 | 59.65 ± 6.0% | not timed | not timed | 55.88 ± 7.0% | 16.92 ± 3.5% | not timed | not timed | 59.37 ± 1.4% | | 1.00 | 1.07 | 3.53 |
| 10-bounded-repeat/capitals | 11 | 894.71 ± 0.8% | not timed | not timed | 531.98 ± 1.1% | 31.02 ± 1.9% | not timed | not timed | 893.62 ± 0.2% | | 1.00 | 1.68 | 28.84 |
| 11-unstructured-to-json/extract | 600 | 20.71 ± 1.6% | not timed | not timed | 61.47 ± 0.9% | 23.10 ± 1.5% | not timed | not timed | 20.36 ± 0.6% | | 1.02 | 0.34 | 0.90 |
| 12-dictionary/single | 1 | 460.51 ± 0.1% | not timed | not timed | 442.96 ± 1.9% | 0.32 ± 0.9% | not timed | not timed | 462.34 ± 0.4% | | 1.00 | 1.04 | 1417.72 |
| 14-quadratic/1x | 100 | 11.40 ± 16.0% | not timed | not timed | 9.11 ± 0.2% | 0.79 ± 17.8% | not timed | not timed | 11.46 ± 0.7% | | 1.00 | 1.25 | 14.48 |
| 14-quadratic/2x | 200 | 6.89 ± 0.6% | not timed | not timed | 4.92 ± 2.3% | 0.42 ± 1.4% | not timed | not timed | 6.91 ± 0.9% | | 1.00 | 1.40 | 16.24 |
| 14-quadratic/10x | 1000 | 1.57 ± 0.7% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 0.9% | not timed | not timed | 1.56 ± 5.6% | | 1.00 | 1.49 | 16.80 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.33 ± 0.4% | not timed | not timed | 0.39 ± 13.1% | 0.49 ± 3.8% | not timed | not timed | 1.32 ± 1.0% | | 1.01 | 3.44 | 2.74 |
| 04-ruff-noqa/compile-real | 1 | 78.10 ± 0.5% | not timed | not timed | 12.99 ± 0.7% | 124.15 ± 3.5% | not timed | not timed | 76.72 ± 2.3% | | 1.02 | 6.01 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 12.56 ± 1.7% | not timed | not timed | 2.39 ± 0.5% | 5.90 ± 1.3% | not timed | not timed | 12.52 ± 1.1% | | 1.00 | 5.26 | 2.13 |
| 07-unicode-character-data/compile | 1 | 50.73 ± 0.2% | not timed | not timed | 24.58 ± 1.1% | 32.94 ± 2.5% | not timed | not timed | 50.53 ± 0.7% | | 1.00 | 2.06 | 1.54 |
| 09-aws-keys/compile-full | 1 | 34.70 ± 0.3% | not timed | not timed | 7.39 ± 1.1% | 20.33 ± 17.4% | not timed | not timed | 34.51 ± 8.3% | | 1.01 | 4.69 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 156.26 ± 0.9% | not timed | not timed | 45.11 ± 1.9% | 116.70 ± 3.0% | not timed | not timed | 155.49 ± 0.7% | | 1.00 | 3.46 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 10.46 ± 0.4% | not timed | not timed | 11.60 ± 0.7% | 15.22 ± 1.4% | not timed | not timed | 10.45 ± 2.9% | | 1.00 | 0.90 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.65 ± 0.4% | not timed | not timed | 8.77 ± 1.4% | 22.40 ± 1.8% | not timed | not timed | 72.02 ± 2.1% | | 1.01 | 8.28 | 3.24 |
| 11-unstructured-to-json/compile | 1 | 77.09 ± 0.6% | not timed | not timed | 37.14 ± 0.5% | 60.74 ± 2.0% | not timed | not timed | 76.15 ± 1.9% | | 1.01 | 2.08 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.1% | not timed | not timed | 0.07 ± 1.4% | 0.08 ± 14.2% | not timed | not timed | 0.29 ± 0.9% | | 1.00 | 4.20 | 3.56 |

