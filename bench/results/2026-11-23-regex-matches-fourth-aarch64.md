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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127331443 |
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
| literal: a word | 217 | 16089.87 ± 1.6% | 1039.52 ± 0.2% | 28.74 ± 0.3% | 18061.67 ± 2.4% | 9251.87 ± 8.7% | 17.54 ± 0.3% | 86.18 ± 0.3% | 16127.08 ± 1.1% | 15.48 | 1.00 | 0.89 | 1.74 |
| literal: a word that is not there | 0 | 18604.67 ± 2.0% | 1049.17 ± 0.3% | 28.71 ± 0.3% | 19533.13 ± 2.9% | 27716.40 ± 1.3% | 17.38 ± 0.1% | 81.96 ± 0.4% | 18652.29 ± 1.9% | 17.73 | 1.00 | 0.95 | 0.67 |
| literal: one of four words | 661 | 6082.78 ± 0.3% | 1022.05 ± 0.1% | 14.79 ± 0.4% | 3951.44 ± 0.3% | 21.86 ± 0.1% | 5.30 ± 0.3% | 6.71 ± 0.2% | 6066.63 ± 0.2% | 5.95 | 1.00 | 1.54 | 278.24 |
| literal: a word in any case | 217 | 12626.31 ± 1.0% | 1040.47 ± 0.2% | 22.07 ± 2.5% | 3969.95 ± 0.4% | 37.51 ± 0.7% | refused | differs | 12630.13 ± 0.4% | 12.14 | 1.00 | 3.18 | 336.65 |
| literal: an href attribute | 33 | 13706.35 ± 0.8% | 1046.07 ± 0.3% | 27.45 ± 0.3% | 16633.61 ± 1.4% | 2268.74 ± 0.7% | 13.43 ± 0.2% | 75.46 ± 0.2% | 13694.82 ± 0.8% | 13.10 | 1.00 | 0.82 | 6.04 |
| literal: a word, second text | 123 | 16308.33 ± 0.9% | 1043.30 ± 0.1% | 28.29 ± 0.2% | 17958.82 ± 0.9% | 7716.31 ± 5.6% | 19.73 ± 0.3% | 68.93 ± 0.1% | 16284.41 ± 0.6% | 15.63 | 1.00 | 0.91 | 2.11 |
| class: two capitalized words | 1331 | 1128.67 ± 0.5% | 977.67 ± 0.2% | 26.17 ± 0.4% | 584.94 ± 0.6% | 40.61 ± 7.6% | 14.93 ± 0.3% | 68.45 ± 0.2% | 1127.21 ± 0.3% | 1.15 | 1.00 | 1.93 | 27.79 |
| class: a word that ends in ing | 3399 | 889.74 ± 0.1% | 891.85 ± 0.1% | 18.23 ± 0.3% | 548.30 ± 0.0% | 29.68 ± 3.3% | 8.25 ± 0.2% | 18.26 ± 0.5% | 889.19 ± 0.1% | 1.00 | 1.00 | 1.62 | 29.98 |
| class: a word in capitals | 2332 | 1453.50 ± 0.5% | 950.86 ± 0.1% | 27.81 ± 0.2% | 572.64 ± 0.4% | 43.61 ± 2.8% | 17.25 ± 0.3% | 83.04 ± 0.6% | 1450.99 ± 0.2% | 1.53 | 1.00 | 2.54 | 33.33 |
| class: a number | 8288 | 1995.14 ± 0.2% | 828.38 ± 0.1% | 28.04 ± 0.1% | 1718.17 ± 0.2% | 42.90 ± 16.2% | 0.57 ± 0.1% | 56.65 ± 0.4% | 1991.34 ± 0.2% | 2.41 | 1.00 | 1.16 | 46.50 |
| class: two capitalized words, second text | 5359 | 738.02 ± 0.2% | 736.28 ± 0.4% | 23.46 ± 0.1% | 484.31 ± 0.1% | 35.09 ± 6.6% | 16.70 ± 0.3% | 63.56 ± 0.3% | 737.44 ± 0.2% | 1.00 | 1.00 | 1.52 | 21.03 |
| other: a word between two words | 6104 | 761.83 ± 0.1% | 764.64 ± 0.4% | 23.65 ± 0.2% | 738.10 ± 0.1% | 107.79 ± 16.3% | 11.35 ± 0.2% | 69.28 ± 0.4% | 758.12 ± 0.1% | 1.00 | 1.00 | 1.03 | 7.07 |
| other: a number before a unit, second text | 1481 | 5507.12 ± 0.1% | 983.17 ± 0.1% | 26.07 ± 0.1% | 5627.49 ± 0.8% | 40.80 ± 6.6% | 17.75 ± 0.5% | 66.91 ± 0.2% | 5426.49 ± 0.3% | 5.60 | 1.01 | 0.98 | 134.96 |
| other: a heading's start tag | 110 | 12542.57 ± 0.4% | 1036.42 ± 0.0% | 27.68 ± 0.2% | 1713.13 ± 0.7% | 1585.98 ± 3.3% | 16.39 ± 0.3% | 88.47 ± 0.2% | 12554.23 ± 0.5% | 12.10 | 1.00 | 7.32 | 7.91 |
| other: a whole word | 217 | 13895.99 ± 1.0% | 1039.52 ± 0.1% | 29.98 ± 0.4% | 14315.94 ± 1.6% | 49.42 ± 0.3% | 13.75 ± 0.2% | 55.59 ± 0.7% | 13908.84 ± 0.9% | 13.37 | 1.00 | 0.97 | 281.19 |
| other: a line's first word, second text | 3716 | 1957.07 ± 0.4% | 873.54 ± 0.1% | 31.37 ± 0.3% | 1729.96 ± 0.4% | 61.59 ± 8.5% | refused | refused | 1942.61 ± 0.7% | 2.24 | 1.01 | 1.13 | 31.77 |
| other: fourteen octets before an x | 87 | 19527.59 ± 4.1% | 243.52 ± 0.4% | 6.15 ± 0.1% | 4034.27 ± 0.6% | 10.65 ± 0.1% | differs | 17.68 ± 0.3% | 19422.03 ± 2.8% | 80.19 | 1.01 | 4.84 | 1833.93 |
| other: a Greek word | 21815 | 469.48 ± 0.3% | 358.64 ± 0.2% | 31.21 ± 0.2% | 289.84 ± 0.4% | 49.34 ± 12.9% | differs | refused | 467.59 ± 0.1% | 1.31 | 1.00 | 1.62 | 9.52 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.89 ± 0.3% | 25.86 ± 0.2% | 0.82 ± 0.4% | 19.65 ± 0.4% | 2.74 ± 0.5% | differs | 4.02 ± 0.2% | 25.90 ± 0.2% | 1.00 | 1.00 | 1.32 | 9.44 |
| a UUID | 32895 | 21.04 ± 0.2% | 21.16 ± 0.3% | 0.65 ± 0.2% | 15.08 ± 0.6% | 3.09 ± 1.5% | 0.72 ± 0.2% | 3.60 ± 0.8% | 21.15 ± 0.4% | 0.99 | 0.99 | 1.40 | 6.81 |
| an IPv4 address | 33176 | 36.87 ± 0.6% | 36.92 ± 0.3% | 2.09 ± 0.3% | 29.07 ± 0.9% | 6.68 ± 0.2% | differs | 4.15 ± 0.3% | 37.03 ± 0.1% | 1.00 | 1.00 | 1.27 | 5.52 |
| a date and time | 32954 | 31.06 ± 0.5% | 30.60 ± 0.4% | 1.42 ± 0.3% | 21.12 ± 0.6% | 7.04 ± 0.1% | 1.19 ± 0.3% | 7.04 ± 0.3% | 31.02 ± 0.5% | 1.02 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.55 ± 0.2% | 29.46 ± 0.1% | 1.01 ± 0.7% | 22.96 ± 0.1% | 3.52 ± 1.1% | differs | 2.92 ± 0.4% | 29.50 ± 0.1% | 1.00 | 1.00 | 1.29 | 8.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.5% | 11.52 ± 0.5% | 11.53 ± 0.7% | 11.46 ± 0.1% | 4.96 ± 1.8% | 0.91 ± 0.1% | none | 11.49 ± 0.3% | 1.00 | 1.00 | 1.00 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.35 ± 0.2% | 217.96 ± 0.2% | 252.53 ± 0.2% | 86.75 ± 0.1% | 224.41 ± 0.9% | 488.27 ± 0.4% | 3746.56 ± 0.7% | 217.36 ± 0.1% | 1.00 | 1.00 | 2.51 | 0.97 |
| a UUID | 62 | 142.80 ± 0.2% | 143.11 ± 0.1% | 157.66 ± 0.1% | 45.60 ± 0.1% | 100.26 ± 4.8% | 185.02 ± 0.7% | 4478.96 ± 0.6% | 142.70 ± 0.2% | 1.00 | 1.00 | 3.13 | 1.42 |
| an IPv4 address | 29 | 439.36 ± 0.5% | 443.80 ± 0.2% | 615.03 ± 0.5% | 76.40 ± 0.9% | 132.66 ± 1.1% | 295.09 ± 0.4% | 7723.48 ± 0.6% | 438.29 ± 0.4% | 0.99 | 1.00 | 5.75 | 3.31 |
| a date and time | 56 | 318.70 ± 0.4% | 320.19 ± 0.4% | 401.69 ± 0.1% | 71.78 ± 0.2% | 139.08 ± 1.5% | 322.66 ± 0.9% | 4983.70 ± 0.4% | 318.77 ± 0.6% | 1.00 | 1.00 | 4.44 | 2.29 |
| a field path | 39 | 202.92 ± 0.3% | 203.57 ± 0.2% | 233.35 ± 0.1% | 79.59 ± 0.6% | 207.42 ± 2.5% | 485.09 ± 0.1% | 4859.15 ± 0.1% | 202.64 ± 0.3% | 1.00 | 1.00 | 2.55 | 0.98 |
| literal: a word | 7 | 669.62 ± 0.5% | 721.15 ± 0.6% | 1293.11 ± 0.6% | 503.69 ± 1.8% | 630.22 ± 2.1% | 920.89 ± 0.5% | 30940.31 ± 0.3% | 669.01 ± 0.5% | 0.93 | 1.00 | 1.33 | 1.06 |
| literal: a word that is not there | 8 | 640.05 ± 0.3% | 695.66 ± 0.3% | 1219.66 ± 0.1% | 461.33 ± 0.1% | 608.98 ± 1.6% | 874.30 ± 0.3% | 29426.93 ± 0.3% | 640.25 ± 0.4% | 0.92 | 1.00 | 1.39 | 1.05 |
| literal: one of four words | 26 | 256.98 ± 0.3% | 422.11 ± 0.5% | 570.22 ± 0.2% | 49.10 ± 0.4% | 245.86 ± 2.1% | 355.61 ± 0.6% | 15730.12 ± 0.4% | 256.91 ± 0.2% | 0.61 | 1.00 | 5.23 | 1.05 |
| literal: a word in any case | 11 | 523.91 ± 0.2% | 566.79 ± 0.2% | 873.63 ± 0.5% | 15.75 ± 0.9% | 664.66 ± 2.8% | refused | 23678.19 ± 0.3% | 523.79 ± 0.3% | 0.92 | 1.00 | 33.27 | 0.79 |
| literal: an href attribute | 12 | 350.80 ± 0.6% | 362.09 ± 0.6% | 471.97 ± 0.7% | 13.22 ± 26.7% | 503.36 ± 0.8% | 758.30 ± 2.8% | 22110.10 ± 0.3% | 350.80 ± 0.4% | 0.97 | 1.00 | 26.53 | 0.70 |
| literal: a word, second text | 10 | 595.78 ± 0.3% | 658.21 ± 0.2% | 1102.58 ± 0.1% | 410.83 ± 0.1% | 541.59 ± 3.4% | 797.23 ± 0.4% | 27275.25 ± 0.1% | 595.71 ± 0.2% | 0.91 | 1.00 | 1.45 | 1.10 |
| class: two capitalized words | 23 | 459.52 ± 0.4% | 490.80 ± 0.2% | 711.51 ± 0.2% | 100.06 ± 0.1% | 507.81 ± 1.3% | 747.10 ± 0.6% | 6374.31 ± 0.2% | 460.91 ± 0.3% | 0.94 | 1.00 | 4.59 | 0.90 |
| class: a word that ends in ing | 9 | 598.70 ± 0.4% | 668.16 ± 0.3% | 1179.06 ± 0.1% | 132.20 ± 1.2% | 768.08 ± 1.0% | 1104.59 ± 2.0% | 15935.60 ± 0.2% | 599.15 ± 0.4% | 0.90 | 1.00 | 4.53 | 0.78 |
| class: a word in capitals | 16 | 521.21 ± 0.7% | 560.74 ± 0.6% | 884.88 ± 0.3% | 135.09 ± 0.6% | 759.11 ± 0.8% | 1019.68 ± 3.7% | 8372.11 ± 0.1% | 521.11 ± 0.5% | 0.93 | 1.00 | 3.86 | 0.69 |
| class: a number | 6 | 660.09 ± 0.4% | 723.32 ± 0.4% | 1336.73 ± 0.2% | 41.77 ± 0.6% | 1410.16 ± 0.9% | 1858.93 ± 1.1% | 22788.24 ± 0.1% | 660.79 ± 0.3% | 0.91 | 1.00 | 15.80 | 0.47 |
| class: two capitalized words, second text | 23 | 460.36 ± 0.2% | 490.82 ± 0.3% | 710.35 ± 0.4% | 101.24 ± 0.4% | 510.42 ± 1.6% | 741.24 ± 1.1% | 6372.51 ± 0.1% | 459.93 ± 0.4% | 0.94 | 1.00 | 4.55 | 0.90 |
| other: a word between two words | 13 | 583.87 ± 0.2% | 604.87 ± 0.2% | 964.60 ± 0.3% | 134.43 ± 0.8% | 509.42 ± 0.5% | 814.45 ± 1.1% | 14756.10 ± 0.1% | 584.06 ± 0.7% | 0.97 | 1.00 | 4.34 | 1.15 |
| other: a number before a unit, second text | 15 | 402.12 ± 0.1% | 436.98 ± 0.3% | 599.74 ± 0.2% | 39.40 ± 0.5% | 643.19 ± 0.7% | 888.41 ± 0.4% | 15290.37 ± 0.1% | 402.04 ± 0.5% | 0.92 | 1.00 | 10.21 | 0.63 |
| other: a heading's start tag | 13 | 361.30 ± 0.3% | 366.43 ± 0.3% | 477.35 ± 0.4% | 13.21 ± 29.1% | 636.50 ± 0.5% | 870.38 ± 0.6% | 18380.23 ± 0.2% | 361.47 ± 0.3% | 0.99 | 1.00 | 27.35 | 0.57 |
| other: a whole word | 11 | 617.78 ± 0.1% | 658.23 ± 0.5% | 1100.30 ± 0.5% | 120.02 ± 0.4% | 571.57 ± 1.4% | 819.68 ± 0.7% | 26946.52 ± 0.2% | 617.87 ± 0.5% | 0.94 | 1.00 | 5.15 | 1.08 |
| other: a line's first word, second text | 17 | 557.77 ± 0.3% | 579.54 ± 0.3% | 929.82 ± 0.2% | 127.12 ± 0.8% | 716.68 ± 0.6% | refused | refused | 556.17 ± 0.5% | 0.96 | 1.00 | 4.39 | 0.78 |
| other: fourteen octets before an x | 16 | 112.90 ± 0.4% | 162.69 ± 0.8% | 186.14 ± 0.9% | 7.62 ± 13.5% | 459.04 ± 1.1% | 415.38 ± 0.8% | 13016.96 ± 0.1% | 112.75 ± 1.1% | 0.69 | 1.00 | 14.82 | 0.25 |
| other: a Greek word | 8 | 450.73 ± 0.2% | 591.69 ± 0.4% | 965.62 ± 0.1% | 15.82 ± 25.6% | 1393.99 ± 0.6% | 1744.29 ± 0.3% | refused | 450.85 ± 0.4% | 0.76 | 1.00 | 28.48 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12861.36 ± 1.2% | not timed | not timed | 16168.55 ± 0.6% | 2121.04 ± 9.8% | not timed | not timed | 12877.16 ± 1.3% | | 1.00 | 0.80 | 6.06 |
| 01-literal/sherlock-casei-en | 522 | 3884.89 ± 0.4% | not timed | not timed | 3596.95 ± 0.1% | 32.50 ± 8.4% | not timed | not timed | 3875.28 ± 0.4% | | 1.00 | 1.08 | 119.54 |
| 01-literal/sherlock-ru | 724 | 13590.07 ± 0.6% | not timed | not timed | 17334.26 ± 0.3% | 1468.03 ± 10.0% | not timed | not timed | 13586.55 ± 0.5% | | 1.00 | 0.78 | 9.26 |
| 01-literal/sherlock-casei-ru | 746 | 5252.01 ± 0.1% | not timed | not timed | 3331.66 ± 0.1% | 31.69 ± 0.4% | not timed | not timed | 5256.78 ± 0.2% | | 1.00 | 1.58 | 165.73 |
| 01-literal/sherlock-zh | 30 | 16961.94 ± 0.6% | not timed | not timed | 18517.58 ± 0.6% | 2703.31 ± 10.0% | not timed | not timed | 16958.49 ± 0.5% | | 1.00 | 0.92 | 6.27 |
| 02-literal-alternate/sherlock-en | 714 | 5820.19 ± 0.4% | not timed | not timed | 3945.94 ± 0.2% | 16.63 ± 0.2% | not timed | not timed | 5829.67 ± 0.2% | | 1.00 | 1.47 | 350.07 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1669.83 ± 0.8% | not timed | not timed | 697.22 ± 0.3% | 11.11 ± 0.8% | not timed | not timed | 1663.78 ± 0.4% | | 1.00 | 2.39 | 150.31 |
| 02-literal-alternate/sherlock-ru | 899 | 4657.95 ± 0.1% | not timed | not timed | 3260.20 ± 0.1% | 22.63 ± 0.1% | not timed | not timed | 4654.58 ± 0.2% | | 1.00 | 1.43 | 205.85 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1783.10 ± 0.3% | not timed | not timed | 1228.09 ± 0.5% | 9.14 ± 0.3% | not timed | not timed | 1775.73 ± 0.4% | | 1.00 | 1.45 | 194.98 |
| 02-literal-alternate/sherlock-zh | 207 | 7042.14 ± 0.5% | not timed | not timed | 4165.13 ± 0.3% | 31.55 ± 0.1% | not timed | not timed | 7046.10 ± 0.8% | | 1.00 | 1.69 | 223.19 |
| 03-date/ascii | 111817 | 124.88 ± 0.4% | not timed | not timed | 95.85 ± 0.1% | 0.20 ± 7.5% | not timed | not timed | 123.79 ± 0.6% | | 1.01 | 1.30 | 612.33 |
| 04-ruff-noqa/real | 84 | 554.20 ± 0.1% | not timed | not timed | 464.87 ± 0.1% | 19.60 ± 1.3% | not timed | not timed | 554.06 ± 0.1% | | 1.00 | 1.19 | 28.28 |
| 04-ruff-noqa/tweaked | 44 | 546.04 ± 0.3% | not timed | not timed | 457.04 ± 0.1% | 366.61 ± 1.3% | not timed | not timed | 543.84 ± 0.2% | | 1.00 | 1.19 | 1.49 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.5% | not timed | not timed | 5.01 ± 0.2% | 0.21 ± 4.6% | not timed | not timed | 3.67 ± 2.5% | | 1.00 | 0.73 | 17.77 |
| 06-cloud-flare-redos/original | 107 | 271.02 ± 0.3% | not timed | not timed | 215.32 ± 0.1% | 24.85 ± 0.4% | not timed | not timed | 270.22 ± 0.1% | | 1.00 | 1.26 | 10.91 |
| 06-cloud-flare-redos/simplified-short | 102 | 266.72 ± 1.2% | not timed | not timed | 226.96 ± 0.1% | 26.62 ± 0.3% | not timed | not timed | 265.69 ± 1.4% | | 1.00 | 1.18 | 10.02 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.36 ± 0.1% | not timed | not timed | 253.65 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 294.21 ± 0.1% | | 1.00 | 1.16 | 10.21 |
| 07-unicode-character-data/parse-line | 558784 | 242.10 ± 0.5% | not timed | not timed | 167.87 ± 0.1% | 42.67 ± 6.4% | not timed | not timed | 241.12 ± 2.0% | | 1.00 | 1.44 | 5.67 |
| 08-words/all-english | 56691 | 119.66 ± 0.1% | not timed | not timed | 82.92 ± 0.3% | 11.72 ± 5.8% | not timed | not timed | 119.75 ± 0.3% | | 1.00 | 1.44 | 10.21 |
| 08-words/long-english | 839 | 1004.59 ± 0.1% | not timed | not timed | 597.85 ± 0.0% | 32.56 ± 0.5% | not timed | not timed | 1005.29 ± 0.1% | | 1.00 | 1.68 | 30.86 |
| 09-aws-keys/full | 0 | 412.58 ± 0.0% | not timed | not timed | 461.33 ± 0.0% | 64.80 ± 3.4% | not timed | not timed | 412.51 ± 0.1% | | 1.00 | 0.89 | 6.37 |
| 09-aws-keys/quick | 0 | 734.63 ± 0.1% | not timed | not timed | 992.73 ± 0.1% | 424.28 ± 3.6% | not timed | not timed | 730.36 ± 0.2% | | 1.01 | 0.74 | 1.73 |
| 10-bounded-repeat/letters-en | 1833 | 635.75 ± 0.7% | not timed | not timed | 516.37 ± 0.7% | 19.56 ± 0.4% | not timed | not timed | 635.45 ± 0.1% | | 1.00 | 1.23 | 32.50 |
| 10-bounded-repeat/letters-ru | 3475 | 380.62 ± 0.3% | not timed | not timed | 477.50 ± 0.1% | 23.10 ± 8.6% | not timed | not timed | 380.07 ± 1.7% | | 1.00 | 0.80 | 16.48 |
| 10-bounded-repeat/context | 53 | 79.67 ± 1.0% | not timed | not timed | 65.78 ± 0.8% | 19.80 ± 0.3% | not timed | not timed | 79.06 ± 1.1% | | 1.01 | 1.21 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 1046.43 ± 0.1% | not timed | not timed | 618.55 ± 0.1% | 36.55 ± 0.1% | not timed | not timed | 1046.10 ± 0.1% | | 1.00 | 1.69 | 28.63 |
| 11-unstructured-to-json/extract | 600 | 48.23 ± 0.1% | not timed | not timed | 77.00 ± 0.3% | 49.38 ± 0.4% | not timed | not timed | 47.01 ± 0.1% | | 1.03 | 0.63 | 0.98 |
| 12-dictionary/single | 1 | 571.93 ± 0.4% | not timed | not timed | 561.32 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 572.75 ± 0.1% | | 1.00 | 1.02 | 1423.94 |
| 14-quadratic/1x | 100 | 13.06 ± 0.2% | not timed | not timed | 10.03 ± 0.3% | 0.98 ± 3.0% | not timed | not timed | 13.02 ± 1.7% | | 1.00 | 1.30 | 13.34 |
| 14-quadratic/2x | 200 | 7.99 ± 0.3% | not timed | not timed | 5.53 ± 0.4% | 0.47 ± 12.7% | not timed | not timed | 7.95 ± 1.5% | | 1.00 | 1.44 | 16.94 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 22.6% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.53 | 16.04 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.35 ± 0.5% | 0.56 ± 2.8% | not timed | not timed | 1.54 ± 0.4% | | 1.00 | 4.46 | 2.77 |
| 04-ruff-noqa/compile-real | 1 | 85.42 ± 0.2% | not timed | not timed | 13.91 ± 0.2% | 144.20 ± 2.6% | not timed | not timed | 85.04 ± 0.7% | | 1.00 | 6.14 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 14.44 ± 0.3% | not timed | not timed | 2.52 ± 0.8% | 6.60 ± 2.3% | not timed | not timed | 14.34 ± 1.2% | | 1.01 | 5.74 | 2.19 |
| 07-unicode-character-data/compile | 1 | 54.70 ± 0.6% | not timed | not timed | 26.10 ± 0.1% | 36.97 ± 2.9% | not timed | not timed | 54.59 ± 0.8% | | 1.00 | 2.10 | 1.48 |
| 09-aws-keys/compile-full | 1 | 41.99 ± 0.3% | not timed | not timed | 8.32 ± 0.5% | 23.83 ± 6.8% | not timed | not timed | 41.86 ± 0.4% | | 1.00 | 5.04 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 189.15 ± 0.1% | not timed | not timed | 47.28 ± 0.2% | 135.71 ± 2.1% | not timed | not timed | 189.23 ± 1.1% | | 1.00 | 4.00 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.52 ± 0.9% | not timed | not timed | 11.19 ± 0.4% | 16.52 ± 3.7% | not timed | not timed | 14.56 ± 0.9% | | 1.00 | 1.30 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 85.28 ± 0.9% | not timed | not timed | 8.13 ± 0.1% | 24.32 ± 1.0% | not timed | not timed | 84.77 ± 0.8% | | 1.01 | 10.49 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 86.07 ± 0.3% | not timed | not timed | 40.90 ± 0.2% | 68.74 ± 2.8% | not timed | not timed | 85.97 ± 0.3% | | 1.00 | 2.10 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 7.7% | not timed | not timed | 0.36 ± 1.2% | | 1.01 | 5.19 | 3.63 |

