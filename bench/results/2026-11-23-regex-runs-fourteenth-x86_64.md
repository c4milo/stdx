# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
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
| literal: a word | 217 | 33196.06 ± 2.1% | 903.27 ± 0.4% | 20.11 ± 0.6% | 31398.60 ± 3.1% | 9110.93 ± 8.5% | 10.88 ± 0.1% | 75.84 ± 1.0% | 33075.11 ± 4.7% | 36.75 | 1.00 | 1.06 | 3.64 |
| literal: a word that is not there | 0 | 49122.75 ± 0.7% | 913.58 ± 0.2% | 20.08 ± 0.8% | 39884.04 ± 28.0% | 30269.03 ± 1.2% | 10.83 ± 0.3% | 72.16 ± 1.3% | 48859.15 ± 3.0% | 53.77 | 1.01 | 1.23 | 1.62 |
| literal: one of four words | 661 | 11147.92 ± 3.6% | 881.85 ± 0.6% | 11.32 ± 0.5% | 9135.58 ± 0.3% | 19.26 ± 1.6% | 3.96 ± 0.4% | 6.45 ± 0.5% | 11135.58 ± 1.6% | 12.64 | 1.00 | 1.22 | 578.90 |
| literal: a word in any case | 217 | 26100.00 ± 0.8% | 903.05 ± 0.5% | 15.90 ± 1.6% | 9253.92 ± 0.6% | 37.29 ± 0.4% | refused | differs | 26064.08 ± 0.7% | 28.90 | 1.00 | 2.82 | 699.84 |
| literal: an href attribute | 33 | 26762.09 ± 3.0% | 909.18 ± 0.1% | 18.92 ± 0.6% | 27334.44 ± 1.9% | 2054.49 ± 1.0% | 8.28 ± 0.3% | 60.09 ± 1.5% | 27272.57 ± 1.8% | 29.44 | 0.98 | 0.98 | 13.03 |
| literal: a word, second text | 123 | 33946.64 ± 1.6% | 906.32 ± 0.6% | 19.91 ± 2.0% | 32096.34 ± 1.1% | 7378.31 ± 3.1% | 11.99 ± 0.6% | 64.78 ± 1.0% | 34110.56 ± 1.5% | 37.46 | 1.00 | 1.06 | 4.60 |
| class: two capitalized words | 1331 | 780.33 ± 0.3% | 838.28 ± 1.4% | 18.88 ± 0.6% | 505.91 ± 0.2% | 34.42 ± 0.2% | 9.45 ± 0.7% | 54.78 ± 0.4% | 780.83 ± 0.2% | 0.93 | 1.00 | 1.54 | 22.67 |
| class: a word that ends in ing | 3399 | 764.07 ± 1.4% | 765.13 ± 1.5% | 13.15 ± 2.4% | 471.12 ± 1.5% | 25.73 ± 9.0% | 5.31 ± 1.3% | 15.77 ± 3.8% | 765.21 ± 1.4% | 1.00 | 1.00 | 1.62 | 29.70 |
| class: a word in capitals | 2332 | 980.91 ± 0.3% | 818.92 ± 0.1% | 19.70 ± 8.9% | 497.74 ± 0.3% | 36.74 ± 13.8% | 10.56 ± 0.7% | 76.46 ± 0.2% | 933.11 ± 0.5% | 1.20 | 1.05 | 1.97 | 26.70 |
| class: a number | 8288 | 1377.94 ± 0.4% | 701.18 ± 0.2% | 19.45 ± 9.0% | 1420.50 ± 0.3% | 37.41 ± 4.7% | 0.34 ± 0.4% | 53.98 ± 9.9% | 1371.79 ± 1.0% | 1.97 | 1.00 | 0.97 | 36.84 |
| class: two capitalized words, second text | 5359 | 628.95 ± 0.4% | 628.30 ± 2.9% | 17.39 ± 0.3% | 418.19 ± 0.2% | 29.34 ± 9.5% | 10.73 ± 0.3% | 50.51 ± 0.6% | 626.92 ± 0.9% | 1.00 | 1.00 | 1.50 | 21.44 |
| other: a word between two words | 6104 | 685.30 ± 0.9% | 654.66 ± 0.2% | 17.18 ± 0.4% | 691.70 ± 0.1% | 101.21 ± 8.4% | 7.28 ± 0.2% | 55.50 ± 1.9% | 689.21 ± 0.5% | 1.05 | 0.99 | 0.99 | 6.77 |
| other: a number before a unit, second text | 1481 | 7040.11 ± 0.7% | 846.80 ± 0.7% | 18.83 ± 1.3% | 6464.48 ± 0.7% | 35.19 ± 9.1% | 11.18 ± 0.2% | 53.85 ± 1.4% | 7024.00 ± 5.8% | 8.31 | 1.00 | 1.09 | 200.07 |
| other: a heading's start tag | 110 | 19108.16 ± 0.6% | 901.68 ± 0.1% | 19.60 ± 0.3% | 2006.52 ± 1.0% | 1480.43 ± 3.8% | 10.11 ± 0.3% | 71.23 ± 0.3% | 19109.12 ± 1.2% | 21.19 | 1.00 | 9.52 | 12.91 |
| other: a whole word | 217 | 22431.03 ± 0.4% | 903.02 ± 0.1% | 20.75 ± 0.1% | 22836.96 ± 0.6% | 41.19 ± 10.3% | 9.54 ± 0.1% | 46.06 ± 0.9% | 22368.95 ± 2.6% | 24.84 | 1.00 | 0.98 | 544.54 |
| other: a line's first word, second text | 3716 | 1886.19 ± 5.1% | 746.40 ± 0.1% | 24.00 ± 1.0% | 1691.75 ± 1.8% | 53.29 ± 6.1% | refused | refused | 1885.31 ± 0.5% | 2.53 | 1.00 | 1.11 | 35.40 |
| other: fourteen octets before an x | 87 | 25649.51 ± 1.1% | 198.61 ± 1.9% | 5.54 ± 3.3% | 2843.20 ± 0.7% | 8.99 ± 6.0% | differs | 14.99 ± 0.4% | 25875.58 ± 1.6% | 129.15 | 0.99 | 9.02 | 2853.62 |
| other: a Greek word | 21815 | 412.89 ± 2.8% | 346.85 ± 3.0% | 24.38 ± 0.2% | 264.79 ± 0.7% | 44.29 ± 6.4% | differs | refused | 409.12 ± 0.4% | 1.19 | 1.01 | 1.56 | 9.32 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.27 ± 8.5% | 23.97 ± 6.5% | 0.80 ± 2.1% | 16.91 ± 1.7% | 2.33 ± 2.6% | differs | 3.37 ± 2.9% | 24.53 ± 3.5% | 1.01 | 0.99 | 1.44 | 10.41 |
| a UUID | 32895 | 20.52 ± 0.3% | 20.48 ± 0.5% | 0.56 ± 6.7% | 12.71 ± 0.3% | 2.50 ± 7.1% | 0.43 ± 0.1% | 2.99 ± 12.0% | 20.50 ± 0.2% | 1.00 | 1.00 | 1.61 | 8.20 |
| an IPv4 address | 33176 | 33.63 ± 1.3% | 33.49 ± 5.2% | 1.81 ± 4.3% | 24.33 ± 0.2% | 5.79 ± 5.4% | differs | 3.33 ± 0.9% | 33.89 ± 1.3% | 1.00 | 0.99 | 1.38 | 5.81 |
| a date and time | 32954 | 30.29 ± 0.3% | 30.00 ± 0.5% | 1.26 ± 2.0% | 18.06 ± 3.2% | 6.69 ± 0.8% | 0.76 ± 0.8% | 5.72 ± 2.0% | 30.21 ± 0.4% | 1.01 | 1.00 | 1.68 | 4.53 |
| a field path | 32606 | 27.17 ± 0.3% | 27.02 ± 0.7% | 0.91 ± 3.5% | 19.43 ± 0.2% | 2.95 ± 0.7% | differs | 2.38 ± 0.5% | 27.20 ± 0.6% | 1.01 | 1.00 | 1.40 | 9.22 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.28 ± 0.2% | 8.25 ± 0.2% | 8.24 ± 0.8% | 10.61 ± 0.4% | 4.74 ± 9.6% | 0.62 ± 2.0% | none | 8.24 ± 0.3% | 1.00 | 1.00 | 0.78 | 1.75 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 191.61 ± 0.2% | 192.38 ± 8.2% | 227.41 ± 0.9% | 80.21 ± 3.5% | 185.97 ± 2.1% | 541.52 ± 2.5% | 3727.07 ± 0.4% | 191.64 ± 1.0% | 1.00 | 1.00 | 2.39 | 1.03 |
| a UUID | 62 | 124.28 ± 0.3% | 124.88 ± 10.0% | 139.27 ± 0.8% | 46.53 ± 18.6% | 91.32 ± 19.4% | 201.18 ± 2.3% | 3911.55 ± 0.7% | 124.00 ± 1.6% | 1.00 | 1.00 | 2.67 | 1.36 |
| an IPv4 address | 29 | 380.29 ± 0.7% | 384.12 ± 0.8% | 546.72 ± 0.7% | 71.12 ± 0.9% | 114.50 ± 13.5% | 334.58 ± 1.1% | 6591.58 ± 12.2% | 380.19 ± 0.8% | 0.99 | 1.00 | 5.35 | 3.32 |
| a date and time | 56 | 276.20 ± 0.8% | 278.15 ± 1.0% | 352.55 ± 0.6% | 69.45 ± 12.0% | 124.41 ± 4.2% | 370.56 ± 3.0% | 4020.62 ± 13.8% | 275.57 ± 0.4% | 0.99 | 1.00 | 3.98 | 2.22 |
| a field path | 39 | 188.25 ± 0.2% | 188.94 ± 7.8% | 222.17 ± 0.4% | 74.87 ± 1.9% | 175.95 ± 1.4% | 595.89 ± 12.8% | 4405.39 ± 0.5% | 187.96 ± 15.5% | 1.00 | 1.00 | 2.51 | 1.07 |
| literal: a word | 7 | 557.16 ± 1.7% | 608.58 ± 0.2% | 1124.41 ± 0.6% | 491.40 ± 0.7% | 586.38 ± 1.5% | 1272.92 ± 15.4% | 24542.55 ± 19.7% | 556.18 ± 0.3% | 0.92 | 1.00 | 1.13 | 0.95 |
| literal: a word that is not there | 8 | 534.64 ± 1.0% | 589.13 ± 0.4% | 1057.26 ± 7.7% | 443.74 ± 0.7% | 565.35 ± 29.5% | 1185.32 ± 1.7% | 23430.05 ± 9.6% | 533.81 ± 0.3% | 0.91 | 1.00 | 1.20 | 0.95 |
| literal: one of four words | 26 | 216.82 ± 0.2% | 356.93 ± 0.6% | 492.13 ± 11.1% | 42.12 ± 1.3% | 219.20 ± 3.1% | 441.67 ± 1.5% | 10485.15 ± 8.3% | 216.78 ± 1.2% | 0.61 | 1.00 | 5.15 | 0.99 |
| literal: a word in any case | 11 | 436.20 ± 0.4% | 466.71 ± 0.5% | 723.57 ± 0.6% | 14.29 ± 0.4% | 604.32 ± 4.8% | refused | 19328.93 ± 0.8% | 435.81 ± 0.2% | 0.93 | 1.00 | 30.52 | 0.72 |
| literal: an href attribute | 12 | 315.02 ± 0.8% | 328.01 ± 0.2% | 446.00 ± 0.6% | 37.03 ± 3.9% | 430.08 ± 11.8% | 930.42 ± 10.0% | 16786.37 ± 1.3% | 315.14 ± 0.6% | 0.96 | 1.00 | 8.51 | 0.73 |
| literal: a word, second text | 10 | 495.43 ± 0.5% | 552.44 ± 1.3% | 952.51 ± 3.2% | 412.80 ± 10.7% | 484.26 ± 5.3% | 1017.20 ± 0.8% | 20429.43 ± 1.7% | 494.97 ± 0.4% | 0.90 | 1.00 | 1.20 | 1.02 |
| class: two capitalized words | 23 | 406.26 ± 0.4% | 433.32 ± 0.3% | 650.55 ± 1.8% | 95.88 ± 0.4% | 458.67 ± 1.2% | 919.83 ± 1.0% | 5571.47 ± 0.9% | 405.54 ± 1.4% | 0.94 | 1.00 | 4.24 | 0.89 |
| class: a word that ends in ing | 9 | 489.85 ± 0.4% | 544.46 ± 1.0% | 1012.42 ± 0.2% | 115.56 ± 0.8% | 646.45 ± 1.7% | 1449.71 ± 1.5% | 14476.12 ± 3.1% | 488.78 ± 0.2% | 0.90 | 1.00 | 4.24 | 0.76 |
| class: a word in capitals | 16 | 421.27 ± 0.2% | 450.95 ± 0.4% | 773.02 ± 0.5% | 122.06 ± 1.6% | 666.65 ± 2.4% | 1244.45 ± 4.8% | 7849.04 ± 1.5% | 421.71 ± 0.4% | 0.93 | 1.00 | 3.45 | 0.63 |
| class: a number | 6 | 529.29 ± 0.6% | 578.25 ± 0.2% | 1153.73 ± 0.3% | 36.60 ± 2.0% | 1165.86 ± 3.0% | 2232.98 ± 6.9% | 20509.35 ± 0.5% | 529.03 ± 2.6% | 0.92 | 1.00 | 14.46 | 0.45 |
| class: two capitalized words, second text | 23 | 406.69 ± 4.3% | 430.62 ± 3.9% | 649.93 ± 5.5% | 95.06 ± 3.4% | 442.19 ± 4.9% | 917.44 ± 2.4% | 5520.22 ± 2.4% | 405.37 ± 3.8% | 0.94 | 1.00 | 4.28 | 0.92 |
| other: a word between two words | 13 | 478.11 ± 0.5% | 500.15 ± 0.5% | 818.28 ± 1.7% | 122.55 ± 3.2% | 446.33 ± 1.9% | 1037.89 ± 0.5% | 12706.29 ± 1.4% | 478.22 ± 0.3% | 0.96 | 1.00 | 3.90 | 1.07 |
| other: a number before a unit, second text | 15 | 352.47 ± 1.2% | 388.04 ± 0.4% | 558.09 ± 0.4% | 34.03 ± 0.8% | 547.58 ± 3.0% | 1107.55 ± 1.7% | 12162.66 ± 1.7% | 353.33 ± 0.2% | 0.91 | 1.00 | 10.36 | 0.64 |
| other: a heading's start tag | 13 | 325.71 ± 3.9% | 334.49 ± 0.1% | 456.77 ± 1.1% | 35.18 ± 0.7% | 529.02 ± 3.0% | 1075.88 ± 0.7% | 13618.16 ± 1.2% | 326.80 ± 2.3% | 0.97 | 1.00 | 9.26 | 0.62 |
| other: a whole word | 11 | 488.20 ± 0.6% | 524.29 ± 1.1% | 876.62 ± 0.7% | 110.91 ± 0.7% | 513.05 ± 1.4% | 1056.59 ± 0.4% | 19712.61 ± 0.3% | 488.16 ± 0.9% | 0.93 | 1.00 | 4.40 | 0.95 |
| other: a line's first word, second text | 17 | 467.78 ± 0.6% | 487.75 ± 0.4% | 833.50 ± 1.6% | 114.49 ± 1.0% | 602.23 ± 2.6% | refused | refused | 467.88 ± 1.2% | 0.96 | 1.00 | 4.09 | 0.78 |
| other: fourteen octets before an x | 16 | 86.04 ± 0.7% | 122.10 ± 0.3% | 142.50 ± 2.5% | 14.13 ± 2.9% | 395.56 ± 3.4% | 451.17 ± 1.4% | 10533.96 ± 1.0% | 86.04 ± 0.5% | 0.70 | 1.00 | 6.09 | 0.22 |
| other: a Greek word | 8 | 359.36 ± 0.8% | 499.75 ± 1.8% | 864.64 ± 0.5% | 46.35 ± 0.5% | 1152.36 ± 1.5% | 2202.94 ± 0.5% | refused | 359.59 ± 0.3% | 0.72 | 1.00 | 7.75 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22224.38 ± 1.0% | not timed | not timed | 26993.62 ± 2.7% | 1947.05 ± 23.6% | not timed | not timed | 22305.48 ± 0.9% | | 1.00 | 0.82 | 11.41 |
| 01-literal/sherlock-casei-en | 522 | 6265.47 ± 2.1% | not timed | not timed | 7042.76 ± 0.4% | 28.63 ± 0.5% | not timed | not timed | 6256.83 ± 0.6% | | 1.00 | 0.89 | 218.82 |
| 01-literal/sherlock-ru | 724 | 23671.09 ± 1.3% | not timed | not timed | 27906.18 ± 0.7% | 1055.73 ± 3.7% | not timed | not timed | 23744.49 ± 0.8% | | 1.00 | 0.85 | 22.42 |
| 01-literal/sherlock-casei-ru | 746 | 7327.82 ± 12.5% | not timed | not timed | 5516.87 ± 3.6% | 30.46 ± 0.7% | not timed | not timed | 7338.41 ± 0.3% | | 1.00 | 1.33 | 240.57 |
| 01-literal/sherlock-zh | 30 | 41344.10 ± 2.7% | not timed | not timed | 36923.81 ± 0.8% | 1264.17 ± 9.5% | not timed | not timed | 41593.68 ± 0.9% | | 0.99 | 1.12 | 32.70 |
| 02-literal-alternate/sherlock-en | 714 | 9691.32 ± 0.3% | not timed | not timed | 8918.03 ± 0.5% | 14.64 ± 3.6% | not timed | not timed | 9705.38 ± 0.6% | | 1.00 | 1.09 | 662.02 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1823.11 ± 0.3% | not timed | not timed | 1821.06 ± 0.4% | 9.47 ± 0.6% | not timed | not timed | 1828.39 ± 0.2% | | 1.00 | 1.00 | 192.49 |
| 02-literal-alternate/sherlock-ru | 899 | 5935.08 ± 1.1% | not timed | not timed | 4258.83 ± 0.6% | 19.53 ± 0.6% | not timed | not timed | 5965.40 ± 9.6% | | 0.99 | 1.39 | 303.90 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1874.99 ± 0.6% | not timed | not timed | 1044.13 ± 0.3% | 8.52 ± 5.8% | not timed | not timed | 1871.98 ± 0.1% | | 1.00 | 1.80 | 220.12 |
| 02-literal-alternate/sherlock-zh | 207 | 14008.12 ± 12.3% | not timed | not timed | 10427.00 ± 0.5% | 26.97 ± 14.8% | not timed | not timed | 13949.03 ± 3.7% | | 1.00 | 1.34 | 519.42 |
| 03-date/ascii | 111817 | 101.77 ± 0.3% | not timed | not timed | 84.77 ± 0.9% | 0.18 ± 1.5% | not timed | not timed | 101.41 ± 0.5% | | 1.00 | 1.20 | 560.96 |
| 04-ruff-noqa/real | 84 | 554.75 ± 8.5% | not timed | not timed | 431.17 ± 0.3% | 15.90 ± 2.5% | not timed | not timed | 562.82 ± 4.9% | | 0.99 | 1.29 | 34.89 |
| 04-ruff-noqa/tweaked | 44 | 475.12 ± 1.0% | not timed | not timed | 421.16 ± 0.1% | 295.14 ± 1.8% | not timed | not timed | 473.22 ± 15.0% | | 1.00 | 1.13 | 1.61 |
| 05-lexer-veryl/single | 124800 | 2.97 ± 2.4% | not timed | not timed | 4.19 ± 0.8% | 0.21 ± 7.9% | not timed | not timed | 2.95 ± 5.9% | | 1.01 | 0.71 | 13.92 |
| 06-cloud-flare-redos/original | 107 | 228.48 ± 1.9% | not timed | not timed | 192.73 ± 1.0% | 20.68 ± 1.7% | not timed | not timed | 225.24 ± 0.3% | | 1.01 | 1.19 | 11.05 |
| 06-cloud-flare-redos/simplified-short | 102 | 218.39 ± 0.3% | not timed | not timed | 192.40 ± 1.2% | 21.99 ± 0.2% | not timed | not timed | 218.06 ± 1.3% | | 1.00 | 1.14 | 9.93 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.62 ± 1.2% | not timed | not timed | 211.59 ± 0.4% | 24.17 ± 0.1% | not timed | not timed | 246.78 ± 0.0% | | 1.00 | 1.17 | 10.20 |
| 07-unicode-character-data/parse-line | 558784 | 187.16 ± 1.7% | not timed | not timed | 161.64 ± 9.3% | 38.15 ± 2.4% | not timed | not timed | 183.72 ± 1.8% | | 1.02 | 1.16 | 4.91 |
| 08-words/all-english | 56691 | 97.55 ± 8.6% | not timed | not timed | 73.97 ± 0.6% | 11.31 ± 0.4% | not timed | not timed | 97.46 ± 8.2% | | 1.00 | 1.32 | 8.62 |
| 08-words/long-english | 839 | 865.04 ± 0.2% | not timed | not timed | 515.13 ± 0.1% | 26.35 ± 2.5% | not timed | not timed | 864.26 ± 2.2% | | 1.00 | 1.68 | 32.83 |
| 09-aws-keys/full | 0 | 427.40 ± 0.3% | not timed | not timed | 441.32 ± 2.1% | 55.00 ± 2.0% | not timed | not timed | 427.21 ± 0.2% | | 1.00 | 0.97 | 7.77 |
| 09-aws-keys/quick | 0 | 823.71 ± 9.1% | not timed | not timed | 802.26 ± 0.4% | 331.83 ± 0.8% | not timed | not timed | 825.18 ± 27.4% | | 1.00 | 1.03 | 2.48 |
| 10-bounded-repeat/letters-en | 1833 | 514.47 ± 6.1% | not timed | not timed | 431.44 ± 0.1% | 16.84 ± 1.1% | not timed | not timed | 521.78 ± 0.4% | | 0.99 | 1.19 | 30.54 |
| 10-bounded-repeat/letters-ru | 3475 | 323.04 ± 2.3% | not timed | not timed | 404.17 ± 0.3% | 19.82 ± 4.2% | not timed | not timed | 322.88 ± 1.1% | | 1.00 | 0.80 | 16.30 |
| 10-bounded-repeat/context | 53 | 66.46 ± 1.5% | not timed | not timed | 55.99 ± 1.8% | 16.86 ± 2.9% | not timed | not timed | 66.81 ± 6.2% | | 0.99 | 1.19 | 3.94 |
| 10-bounded-repeat/capitals | 11 | 903.13 ± 0.2% | not timed | not timed | 532.07 ± 0.2% | 30.90 ± 5.4% | not timed | not timed | 901.47 ± 0.2% | | 1.00 | 1.70 | 29.22 |
| 11-unstructured-to-json/extract | 600 | 36.99 ± 5.7% | not timed | not timed | 61.90 ± 0.4% | 39.98 ± 1.1% | not timed | not timed | 37.07 ± 1.0% | | 1.00 | 0.60 | 0.93 |
| 12-dictionary/single | 1 | 461.92 ± 0.3% | not timed | not timed | 439.56 ± 0.2% | 0.33 ± 3.3% | not timed | not timed | 463.77 ± 0.4% | | 1.00 | 1.05 | 1397.72 |
| 14-quadratic/1x | 100 | 7.63 ± 3.6% | not timed | not timed | 8.95 ± 0.3% | 0.80 ± 2.5% | not timed | not timed | 7.53 ± 5.1% | | 1.01 | 0.85 | 9.53 |
| 14-quadratic/2x | 200 | 4.46 ± 0.1% | not timed | not timed | 4.92 ± 2.4% | 0.43 ± 0.1% | not timed | not timed | 4.45 ± 0.1% | | 1.00 | 0.91 | 10.44 |
| 14-quadratic/10x | 1000 | 1.03 ± 0.1% | not timed | not timed | 1.05 ± 0.8% | 0.09 ± 0.5% | not timed | not timed | 1.03 ± 2.5% | | 1.00 | 0.98 | 11.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 0.5% | not timed | not timed | 0.39 ± 1.4% | 0.47 ± 3.9% | not timed | not timed | 1.31 ± 1.2% | | 1.00 | 3.39 | 2.77 |
| 04-ruff-noqa/compile-real | 1 | 80.27 ± 0.4% | not timed | not timed | 12.83 ± 0.9% | 125.88 ± 3.9% | not timed | not timed | 79.12 ± 16.9% | | 1.01 | 6.26 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.71 ± 6.8% | not timed | not timed | 2.37 ± 7.8% | 5.92 ± 4.7% | not timed | not timed | 12.70 ± 1.4% | | 1.00 | 5.36 | 2.15 |
| 07-unicode-character-data/compile | 1 | 50.46 ± 2.3% | not timed | not timed | 24.06 ± 1.7% | 32.86 ± 1.2% | not timed | not timed | 50.76 ± 8.9% | | 0.99 | 2.10 | 1.54 |
| 09-aws-keys/compile-full | 1 | 34.08 ± 15.9% | not timed | not timed | 7.06 ± 5.2% | 19.63 ± 3.8% | not timed | not timed | 33.64 ± 2.7% | | 1.01 | 4.82 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 155.04 ± 2.6% | not timed | not timed | 44.59 ± 3.9% | 117.84 ± 2.6% | not timed | not timed | 155.40 ± 0.9% | | 1.00 | 3.48 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 10.55 ± 0.5% | not timed | not timed | 11.85 ± 0.7% | 15.04 ± 2.6% | not timed | not timed | 10.50 ± 0.6% | | 1.01 | 0.89 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 72.72 ± 4.0% | not timed | not timed | 8.89 ± 1.3% | 22.38 ± 2.6% | not timed | not timed | 72.41 ± 19.1% | | 1.00 | 8.18 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 76.35 ± 16.0% | not timed | not timed | 36.90 ± 0.9% | 60.45 ± 5.7% | not timed | not timed | 76.07 ± 3.7% | | 1.00 | 2.07 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.4% | not timed | not timed | 0.07 ± 12.3% | 0.08 ± 14.1% | not timed | not timed | 0.28 ± 5.4% | | 1.03 | 4.30 | 3.56 |

