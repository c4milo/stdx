# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127334123 |
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
| literal: a word | 217 | 24051.85 ± 2.4% | 867.42 ± 0.5% | 28.91 ± 1.8% | 24653.25 ± 0.5% | 9383.32 ± 7.9% | 12.06 ± 0.2% | 88.67 ± 2.4% | 23948.10 ± 1.8% | 27.73 | 1.00 | 0.98 | 2.56 |
| literal: a word that is not there | 0 | 30537.95 ± 1.1% | 877.62 ± 0.3% | 28.90 ± 0.7% | 27090.44 ± 5.1% | 30021.84 ± 1.2% | 11.76 ± 0.4% | 85.10 ± 1.5% | 30534.60 ± 1.7% | 34.80 | 1.00 | 1.13 | 1.02 |
| literal: one of four words | 661 | 10475.06 ± 4.0% | 852.67 ± 0.1% | 15.44 ± 1.6% | 7794.82 ± 1.1% | 23.33 ± 2.1% | 3.53 ± 0.2% | 7.66 ± 0.8% | 10322.14 ± 3.0% | 12.29 | 1.01 | 1.34 | 448.95 |
| literal: a word in any case | 217 | 20932.33 ± 0.8% | 868.91 ± 0.3% | 19.85 ± 1.9% | 8008.97 ± 2.1% | 43.81 ± 1.5% | refused | differs | 21031.30 ± 1.1% | 24.09 | 1.00 | 2.61 | 477.82 |
| literal: an href attribute | 33 | 21904.21 ± 0.5% | 874.85 ± 0.2% | 25.58 ± 0.7% | 22289.44 ± 1.3% | 2043.53 ± 0.8% | 8.62 ± 0.6% | 79.01 ± 4.4% | 21736.69 ± 4.6% | 25.04 | 1.01 | 0.98 | 10.72 |
| literal: a word, second text | 123 | 24546.07 ± 1.4% | 870.69 ± 7.4% | 27.83 ± 9.0% | 23909.59 ± 1.4% | 7057.05 ± 5.2% | 15.77 ± 0.3% | 76.09 ± 2.1% | 24491.77 ± 2.5% | 28.19 | 1.00 | 1.03 | 3.48 |
| class: two capitalized words | 1331 | 798.60 ± 1.0% | 809.38 ± 1.0% | 26.41 ± 1.9% | 488.98 ± 0.1% | 38.85 ± 5.6% | 10.28 ± 0.5% | 63.71 ± 2.1% | 798.99 ± 5.1% | 0.99 | 1.00 | 1.63 | 20.56 |
| class: a word that ends in ing | 3399 | 733.84 ± 0.6% | 732.20 ± 0.7% | 17.07 ± 0.9% | 460.57 ± 0.1% | 28.04 ± 7.2% | 5.80 ± 0.5% | 17.35 ± 0.6% | 733.62 ± 0.6% | 1.00 | 1.00 | 1.59 | 26.18 |
| class: a word in capitals | 2332 | 1069.32 ± 7.7% | 785.72 ± 10.9% | 28.26 ± 1.0% | 481.95 ± 0.4% | 42.34 ± 5.1% | 12.42 ± 10.9% | 81.13 ± 1.0% | 1073.14 ± 2.0% | 1.36 | 1.00 | 2.22 | 25.25 |
| class: a number | 8288 | 1570.18 ± 0.5% | 682.19 ± 0.1% | 27.49 ± 2.2% | 1672.61 ± 0.3% | 41.89 ± 7.5% | 0.34 ± 0.2% | 60.23 ± 0.6% | 1570.85 ± 1.5% | 2.30 | 1.00 | 0.94 | 37.48 |
| class: two capitalized words, second text | 5359 | 599.84 ± 19.3% | 599.94 ± 5.7% | 23.55 ± 2.3% | 405.84 ± 0.2% | 32.11 ± 6.3% | 13.47 ± 1.2% | 58.25 ± 4.8% | 599.17 ± 0.3% | 1.00 | 1.00 | 1.48 | 18.68 |
| other: a word between two words | 6104 | 623.24 ± 0.4% | 630.36 ± 0.7% | 23.39 ± 0.6% | 693.85 ± 9.4% | 105.75 ± 10.0% | 7.84 ± 0.7% | 68.13 ± 3.4% | 622.54 ± 1.8% | 0.99 | 1.00 | 0.90 | 5.89 |
| other: a number before a unit, second text | 1481 | 6867.84 ± 2.4% | 821.48 ± 0.6% | 26.25 ± 2.8% | 7246.42 ± 0.6% | 39.62 ± 3.5% | 14.20 ± 1.3% | 61.82 ± 1.3% | 6697.47 ± 1.7% | 8.36 | 1.03 | 0.95 | 173.34 |
| other: a heading's start tag | 110 | 16176.30 ± 0.6% | 863.62 ± 0.2% | 27.91 ± 1.2% | 2107.92 ± 2.0% | 1542.12 ± 4.5% | 10.73 ± 0.2% | 93.57 ± 0.7% | 16211.20 ± 1.9% | 18.73 | 1.00 | 7.67 | 10.49 |
| other: a whole word | 217 | 19120.63 ± 0.4% | 869.68 ± 0.2% | 29.12 ± 0.8% | 19983.01 ± 0.2% | 46.03 ± 0.9% | 10.23 ± 0.1% | 53.54 ± 1.8% | 19095.27 ± 2.2% | 21.99 | 1.00 | 0.96 | 415.42 |
| other: a line's first word, second text | 3716 | 1774.63 ± 4.6% | 720.26 ± 13.4% | 30.10 ± 6.9% | 1940.88 ± 2.4% | 63.62 ± 7.7% | refused | refused | 1773.49 ± 1.3% | 2.46 | 1.00 | 0.91 | 27.89 |
| other: fourteen octets before an x | 87 | 26841.48 ± 4.2% | 241.42 ± 3.1% | 5.88 ± 4.1% | 3367.88 ± 11.2% | 9.10 ± 1.5% | differs | 16.86 ± 4.6% | 26755.91 ± 3.7% | 111.18 | 1.00 | 7.97 | 2948.68 |
| other: a Greek word | 21815 | 410.12 ± 0.5% | 286.66 ± 1.3% | 29.86 ± 3.3% | 250.41 ± 1.2% | 47.33 ± 7.8% | differs | refused | 409.63 ± 1.6% | 1.43 | 1.00 | 1.64 | 8.67 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.43 ± 0.5% | 23.42 ± 0.8% | 0.84 ± 2.4% | 16.98 ± 0.3% | 2.53 ± 0.4% | differs | 3.93 ± 0.4% | 23.27 ± 0.6% | 1.00 | 1.01 | 1.38 | 9.27 |
| a UUID | 32895 | 20.99 ± 0.3% | 21.02 ± 1.3% | 0.59 ± 1.6% | 13.12 ± 0.2% | 2.55 ± 0.7% | 0.57 ± 0.4% | 3.27 ± 1.0% | 20.98 ± 0.5% | 1.00 | 1.00 | 1.60 | 8.23 |
| an IPv4 address | 33176 | 31.14 ± 0.2% | 31.11 ± 0.2% | 1.93 ± 0.3% | 25.03 ± 0.1% | 6.05 ± 0.4% | differs | 3.82 ± 0.3% | 31.10 ± 0.2% | 1.00 | 1.00 | 1.24 | 5.15 |
| a date and time | 32954 | 31.34 ± 0.5% | 31.23 ± 0.8% | 1.36 ± 2.2% | 19.02 ± 0.3% | 7.85 ± 0.5% | 1.05 ± 0.3% | 7.36 ± 2.7% | 31.34 ± 0.3% | 1.00 | 1.00 | 1.65 | 3.99 |
| a field path | 32606 | 25.42 ± 0.2% | 25.34 ± 0.6% | 0.99 ± 0.4% | 19.55 ± 0.2% | 2.82 ± 1.0% | differs | 2.47 ± 0.5% | 25.40 ± 0.2% | 1.00 | 1.00 | 1.30 | 9.02 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.82 ± 0.4% | 9.76 ± 1.0% | 9.79 ± 2.6% | 11.97 ± 7.5% | 5.18 ± 14.2% | 0.83 ± 0.5% | none | 9.83 ± 0.8% | 1.01 | 1.00 | 0.82 | 1.90 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.08 ± 1.1% | 233.93 ± 1.5% | 278.18 ± 0.3% | 86.64 ± 3.6% | 202.60 ± 2.2% | 559.87 ± 13.0% | 3285.81 ± 14.5% | 233.41 ± 3.6% | 1.00 | 1.00 | 2.69 | 1.15 |
| a UUID | 62 | 154.33 ± 0.6% | 154.73 ± 7.9% | 173.96 ± 0.7% | 46.63 ± 3.4% | 91.81 ± 13.3% | 195.97 ± 21.6% | 4140.89 ± 4.3% | 154.62 ± 0.5% | 1.00 | 1.00 | 3.31 | 1.68 |
| an IPv4 address | 29 | 466.47 ± 0.5% | 471.92 ± 0.6% | 676.55 ± 10.3% | 77.27 ± 2.3% | 122.05 ± 2.9% | 348.65 ± 1.9% | 6830.52 ± 3.1% | 466.28 ± 0.4% | 0.99 | 1.00 | 6.04 | 3.82 |
| a date and time | 56 | 361.14 ± 0.8% | 364.59 ± 0.6% | 473.37 ± 0.2% | 72.35 ± 1.8% | 127.08 ± 5.0% | 357.10 ± 2.4% | 4390.16 ± 1.0% | 362.24 ± 0.3% | 0.99 | 1.00 | 4.99 | 2.84 |
| a field path | 39 | 227.77 ± 0.4% | 229.10 ± 0.2% | 268.31 ± 0.2% | 80.22 ± 1.3% | 190.47 ± 21.2% | 562.50 ± 1.8% | 4154.48 ± 0.8% | 227.93 ± 0.2% | 0.99 | 1.00 | 2.84 | 1.20 |
| literal: a word | 7 | 707.97 ± 1.3% | 754.07 ± 1.2% | 1438.69 ± 1.1% | 518.49 ± 0.7% | 620.33 ± 19.8% | 1174.63 ± 0.6% | 27336.14 ± 1.1% | 710.04 ± 0.9% | 0.94 | 1.00 | 1.37 | 1.14 |
| literal: a word that is not there | 8 | 682.26 ± 0.5% | 728.08 ± 0.5% | 1354.80 ± 2.9% | 480.30 ± 17.8% | 594.28 ± 4.7% | 1103.54 ± 3.3% | 26437.64 ± 3.5% | 682.07 ± 1.2% | 0.94 | 1.00 | 1.42 | 1.15 |
| literal: one of four words | 26 | 275.26 ± 6.5% | 472.29 ± 0.4% | 674.48 ± 0.4% | 39.42 ± 0.8% | 236.77 ± 1.8% | 410.51 ± 3.3% | 14470.36 ± 2.6% | 275.08 ± 2.8% | 0.58 | 1.00 | 6.98 | 1.16 |
| literal: a word in any case | 11 | 537.41 ± 5.0% | 576.00 ± 12.7% | 901.39 ± 0.6% | 13.08 ± 0.5% | 639.60 ± 7.2% | refused | 22161.16 ± 3.1% | 536.73 ± 4.7% | 0.93 | 1.00 | 41.09 | 0.84 |
| literal: an href attribute | 12 | 376.81 ± 0.3% | 387.42 ± 0.7% | 512.02 ± 5.4% | 38.97 ± 1.0% | 464.95 ± 6.3% | 926.02 ± 2.4% | 19456.53 ± 2.4% | 377.30 ± 0.7% | 0.97 | 1.00 | 9.67 | 0.81 |
| literal: a word, second text | 10 | 636.69 ± 7.3% | 693.48 ± 0.7% | 1230.42 ± 0.4% | 445.82 ± 0.3% | 517.40 ± 3.9% | 954.04 ± 1.3% | 24138.40 ± 0.9% | 637.76 ± 0.3% | 0.92 | 1.00 | 1.43 | 1.23 |
| class: two capitalized words | 23 | 525.70 ± 0.4% | 562.65 ± 0.6% | 869.25 ± 5.2% | 104.60 ± 8.1% | 477.79 ± 9.6% | 878.70 ± 5.8% | 5995.47 ± 1.5% | 525.78 ± 0.3% | 0.93 | 1.00 | 5.03 | 1.10 |
| class: a word that ends in ing | 9 | 609.73 ± 1.2% | 689.48 ± 1.9% | 1277.32 ± 1.8% | 134.80 ± 0.8% | 706.06 ± 12.6% | 1356.50 ± 19.0% | 14688.41 ± 3.0% | 609.92 ± 6.5% | 0.88 | 1.00 | 4.52 | 0.86 |
| class: a word in capitals | 16 | 549.61 ± 1.0% | 594.86 ± 0.4% | 1036.91 ± 1.4% | 139.86 ± 0.8% | 716.37 ± 12.3% | 1249.46 ± 1.9% | 7963.98 ± 6.7% | 549.61 ± 0.6% | 0.92 | 1.00 | 3.93 | 0.77 |
| class: a number | 6 | 662.90 ± 0.9% | 735.28 ± 1.8% | 1467.09 ± 0.7% | 35.02 ± 1.3% | 1300.58 ± 3.2% | 2300.01 ± 1.9% | 20961.63 ± 2.8% | 665.08 ± 0.2% | 0.90 | 1.00 | 18.93 | 0.51 |
| class: two capitalized words, second text | 23 | 524.96 ± 0.7% | 562.78 ± 1.5% | 869.13 ± 1.5% | 105.88 ± 0.5% | 480.83 ± 2.4% | 889.30 ± 1.0% | 6006.86 ± 0.3% | 524.13 ± 0.8% | 0.93 | 1.00 | 4.96 | 1.09 |
| other: a word between two words | 13 | 617.56 ± 16.1% | 632.83 ± 2.8% | 1057.63 ± 1.1% | 138.22 ± 0.9% | 482.05 ± 13.5% | 966.81 ± 1.4% | 13444.26 ± 0.3% | 615.24 ± 4.7% | 0.98 | 1.00 | 4.47 | 1.28 |
| other: a number before a unit, second text | 15 | 431.87 ± 0.3% | 475.18 ± 4.4% | 677.96 ± 12.5% | 33.16 ± 6.7% | 593.59 ± 6.6% | 1052.36 ± 3.0% | 13397.38 ± 1.3% | 431.75 ± 1.6% | 0.91 | 1.00 | 13.02 | 0.73 |
| other: a heading's start tag | 13 | 385.38 ± 0.8% | 391.87 ± 4.1% | 522.16 ± 2.8% | 38.04 ± 0.8% | 582.28 ± 13.7% | 1022.50 ± 0.9% | 15908.33 ± 2.9% | 385.40 ± 4.3% | 0.98 | 1.00 | 10.13 | 0.66 |
| other: a whole word | 11 | 650.17 ± 0.7% | 684.31 ± 0.8% | 1203.97 ± 1.3% | 118.15 ± 4.6% | 541.66 ± 15.9% | 986.96 ± 4.8% | 23380.30 ± 1.9% | 649.13 ± 0.5% | 0.95 | 1.00 | 5.50 | 1.20 |
| other: a line's first word, second text | 17 | 589.73 ± 3.1% | 620.30 ± 0.3% | 1044.70 ± 0.5% | 134.50 ± 0.1% | 649.56 ± 4.5% | refused | refused | 582.78 ± 3.1% | 0.95 | 1.01 | 4.38 | 0.91 |
| other: fourteen octets before an x | 16 | 105.73 ± 0.8% | 149.40 ± 1.2% | 182.44 ± 0.3% | 14.67 ± 2.8% | 422.52 ± 5.4% | 466.55 ± 0.7% | 12073.95 ± 0.3% | 105.56 ± 0.5% | 0.71 | 1.00 | 7.20 | 0.25 |
| other: a Greek word | 8 | 433.22 ± 2.4% | 612.48 ± 3.2% | 1042.83 ± 0.5% | 48.36 ± 0.5% | 1295.19 ± 1.7% | 2256.85 ± 0.8% | refused | 432.64 ± 4.2% | 0.71 | 1.00 | 8.96 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 17748.27 ± 0.5% | not timed | not timed | 21377.45 ± 3.0% | 1974.34 ± 20.3% | not timed | not timed | 17753.94 ± 0.8% | | 1.00 | 0.83 | 8.99 |
| 01-literal/sherlock-casei-en | 522 | 5039.57 ± 1.1% | not timed | not timed | 6734.42 ± 0.5% | 29.88 ± 0.9% | not timed | not timed | 4981.57 ± 2.5% | | 1.01 | 0.75 | 168.68 |
| 01-literal/sherlock-ru | 724 | 18553.46 ± 22.5% | not timed | not timed | 21202.66 ± 1.8% | 1126.07 ± 4.0% | not timed | not timed | 18390.13 ± 10.3% | | 1.01 | 0.88 | 16.48 |
| 01-literal/sherlock-casei-ru | 746 | 6917.66 ± 0.2% | not timed | not timed | 5269.50 ± 1.7% | 32.84 ± 2.1% | not timed | not timed | 6912.72 ± 0.2% | | 1.00 | 1.31 | 210.64 |
| 01-literal/sherlock-zh | 30 | 27848.75 ± 7.9% | not timed | not timed | 26058.57 ± 1.4% | 1255.27 ± 2.4% | not timed | not timed | 27792.42 ± 0.4% | | 1.00 | 1.07 | 22.19 |
| 02-literal-alternate/sherlock-en | 714 | 9566.41 ± 11.0% | not timed | not timed | 7451.67 ± 15.2% | 17.80 ± 9.2% | not timed | not timed | 9490.57 ± 24.4% | | 1.01 | 1.28 | 537.35 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1634.16 ± 1.5% | not timed | not timed | 1918.18 ± 0.3% | 10.36 ± 5.2% | not timed | not timed | 1630.85 ± 3.0% | | 1.00 | 0.85 | 157.73 |
| 02-literal-alternate/sherlock-ru | 899 | 5882.22 ± 2.8% | not timed | not timed | 4082.11 ± 7.0% | 23.01 ± 7.2% | not timed | not timed | 5882.16 ± 15.3% | | 1.00 | 1.44 | 255.62 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1708.34 ± 3.5% | not timed | not timed | 983.33 ± 1.5% | 8.76 ± 1.3% | not timed | not timed | 1709.30 ± 4.0% | | 1.00 | 1.74 | 195.10 |
| 02-literal-alternate/sherlock-zh | 207 | 12894.55 ± 0.3% | not timed | not timed | 8539.86 ± 0.3% | 32.99 ± 5.6% | not timed | not timed | 12873.82 ± 1.2% | | 1.00 | 1.51 | 390.86 |
| 03-date/ascii | 111817 | 98.79 ± 0.8% | not timed | not timed | 88.32 ± 0.8% | 0.20 ± 5.2% | not timed | not timed | 98.56 ± 0.3% | | 1.00 | 1.12 | 503.92 |
| 04-ruff-noqa/real | 84 | 574.20 ± 1.2% | not timed | not timed | 449.86 ± 0.3% | 15.56 ± 0.4% | not timed | not timed | 574.71 ± 0.9% | | 1.00 | 1.28 | 36.90 |
| 04-ruff-noqa/tweaked | 44 | 502.23 ± 1.0% | not timed | not timed | 450.60 ± 0.1% | 315.57 ± 11.8% | not timed | not timed | 500.77 ± 7.3% | | 1.00 | 1.11 | 1.59 |
| 05-lexer-veryl/single | 124800 | 3.42 ± 0.6% | not timed | not timed | 4.77 ± 0.5% | 0.21 ± 5.0% | not timed | not timed | 3.42 ± 0.4% | | 1.00 | 0.72 | 16.44 |
| 06-cloud-flare-redos/original | 107 | 247.57 ± 0.2% | not timed | not timed | 195.78 ± 1.6% | 24.97 ± 0.7% | not timed | not timed | 247.51 ± 0.2% | | 1.00 | 1.26 | 9.91 |
| 06-cloud-flare-redos/simplified-short | 102 | 241.17 ± 1.8% | not timed | not timed | 179.46 ± 3.1% | 26.36 ± 2.0% | not timed | not timed | 240.92 ± 1.0% | | 1.00 | 1.34 | 9.15 |
| 06-cloud-flare-redos/simplified-long | 10000 | 236.06 ± 7.4% | not timed | not timed | 213.98 ± 16.9% | 28.66 ± 2.4% | not timed | not timed | 235.87 ± 0.2% | | 1.00 | 1.10 | 8.24 |
| 07-unicode-character-data/parse-line | 558784 | 225.41 ± 5.3% | not timed | not timed | 168.58 ± 1.4% | 39.83 ± 5.4% | not timed | not timed | 225.30 ± 2.3% | | 1.00 | 1.34 | 5.66 |
| 08-words/all-english | 56691 | 91.81 ± 1.1% | not timed | not timed | 74.28 ± 3.0% | 10.79 ± 16.2% | not timed | not timed | 91.60 ± 0.7% | | 1.00 | 1.24 | 8.51 |
| 08-words/long-english | 839 | 831.64 ± 0.6% | not timed | not timed | 495.05 ± 0.9% | 29.50 ± 0.5% | not timed | not timed | 830.92 ± 0.4% | | 1.00 | 1.68 | 28.19 |
| 09-aws-keys/full | 0 | 450.54 ± 1.1% | not timed | not timed | 458.09 ± 0.4% | 62.93 ± 4.2% | not timed | not timed | 451.31 ± 0.0% | | 1.00 | 0.98 | 7.16 |
| 09-aws-keys/quick | 0 | 870.64 ± 0.3% | not timed | not timed | 743.71 ± 2.3% | 361.68 ± 1.0% | not timed | not timed | 870.09 ± 0.2% | | 1.00 | 1.17 | 2.41 |
| 10-bounded-repeat/letters-en | 1833 | 508.21 ± 1.0% | not timed | not timed | 449.03 ± 2.4% | 19.15 ± 1.4% | not timed | not timed | 504.26 ± 0.9% | | 1.01 | 1.13 | 26.54 |
| 10-bounded-repeat/letters-ru | 3475 | 310.83 ± 0.8% | not timed | not timed | 403.03 ± 1.9% | 20.76 ± 14.5% | not timed | not timed | 309.61 ± 0.9% | | 1.00 | 0.77 | 14.97 |
| 10-bounded-repeat/context | 53 | 71.70 ± 3.4% | not timed | not timed | 59.91 ± 0.5% | 19.00 ± 3.1% | not timed | not timed | 71.83 ± 1.9% | | 1.00 | 1.20 | 3.77 |
| 10-bounded-repeat/capitals | 11 | 861.97 ± 1.1% | not timed | not timed | 511.40 ± 0.7% | 35.55 ± 0.4% | not timed | not timed | 863.62 ± 0.5% | | 1.00 | 1.69 | 24.24 |
| 11-unstructured-to-json/extract | 600 | 37.45 ± 0.3% | not timed | not timed | 64.39 ± 0.2% | 49.69 ± 0.5% | not timed | not timed | 37.31 ± 0.3% | | 1.00 | 0.58 | 0.75 |
| 12-dictionary/single | 1 | 454.61 ± 1.2% | not timed | not timed | 436.91 ± 0.5% | 0.38 ± 0.3% | not timed | not timed | 456.47 ± 0.7% | | 1.00 | 1.04 | 1193.22 |
| 14-quadratic/1x | 100 | 11.67 ± 2.1% | not timed | not timed | 10.91 ± 1.2% | 0.99 ± 1.5% | not timed | not timed | 11.55 ± 1.0% | | 1.01 | 1.07 | 11.82 |
| 14-quadratic/2x | 200 | 6.95 ± 0.4% | not timed | not timed | 5.33 ± 0.3% | 0.55 ± 1.3% | not timed | not timed | 6.93 ± 1.6% | | 1.00 | 1.31 | 12.73 |
| 14-quadratic/10x | 1000 | 1.55 ± 0.6% | not timed | not timed | 1.03 ± 0.1% | 0.12 ± 2.7% | not timed | not timed | 1.55 ± 0.5% | | 1.00 | 1.50 | 13.16 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.58 ± 0.5% | not timed | not timed | 0.34 ± 0.4% | 0.51 ± 2.4% | not timed | not timed | 1.57 ± 1.6% | | 1.01 | 4.66 | 3.08 |
| 04-ruff-noqa/compile-real | 1 | 104.42 ± 8.0% | not timed | not timed | 11.85 ± 7.7% | 133.61 ± 6.4% | not timed | not timed | 103.54 ± 6.3% | | 1.01 | 8.81 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 17.08 ± 1.6% | not timed | not timed | 2.30 ± 0.6% | 6.10 ± 2.9% | not timed | not timed | 17.00 ± 0.8% | | 1.00 | 7.43 | 2.80 |
| 07-unicode-character-data/compile | 1 | 62.33 ± 4.2% | not timed | not timed | 24.97 ± 10.2% | 34.10 ± 15.6% | not timed | not timed | 62.27 ± 0.8% | | 1.00 | 2.50 | 1.83 |
| 09-aws-keys/compile-full | 1 | 41.19 ± 0.7% | not timed | not timed | 7.02 ± 1.3% | 22.13 ± 1.1% | not timed | not timed | 41.22 ± 2.2% | | 1.00 | 5.87 | 1.86 |
| 09-aws-keys/compile-quick | 1 | 198.82 ± 1.5% | not timed | not timed | 46.29 ± 2.6% | 127.09 ± 7.7% | not timed | not timed | 198.19 ± 1.0% | | 1.00 | 4.30 | 1.56 |
| 10-bounded-repeat/compile-context | 1 | 12.34 ± 0.2% | not timed | not timed | 11.01 ± 0.3% | 16.16 ± 2.2% | not timed | not timed | 12.36 ± 0.3% | | 1.00 | 1.12 | 0.76 |
| 10-bounded-repeat/compile-capitals | 1 | 75.11 ± 0.5% | not timed | not timed | 8.23 ± 0.4% | 23.58 ± 0.9% | not timed | not timed | 74.82 ± 1.9% | | 1.00 | 9.13 | 3.18 |
| 11-unstructured-to-json/compile | 1 | 95.53 ± 0.6% | not timed | not timed | 38.05 ± 6.6% | 63.65 ± 1.6% | not timed | not timed | 95.47 ± 1.4% | | 1.00 | 2.51 | 1.50 |
| 12-dictionary/compile-single | 1 | 0.30 ± 1.3% | not timed | not timed | 0.06 ± 2.2% | 0.09 ± 17.2% | not timed | not timed | 0.29 ± 4.8% | | 1.01 | 4.75 | 3.48 |

