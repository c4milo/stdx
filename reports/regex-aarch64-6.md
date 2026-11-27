# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261122.195.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 19537.41 ± 3.1% | 10814.02 ± 0.8% | 28.09 ± 0.2% | 18203.19 ± 2.4% | 9139.75 ± 8.0% | 17.44 ± 0.4% | 86.84 ± 0.4% | 19531.62 ± 1.0% | 1.81 | 1.00 | 1.07 | 2.14 |
| literal: a word that is not there | 0 | 21890.17 ± 2.2% | 9836.00 ± 1.1% | 28.34 ± 0.4% | 19835.81 ± 2.8% | 29049.98 ± 1.5% | 17.22 ± 0.1% | 80.88 ± 0.5% | 21507.51 ± 2.5% | 2.23 | 1.02 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6436.41 ± 0.3% | 1789.82 ± 0.3% | 14.43 ± 0.1% | 3948.04 ± 0.1% | 21.88 ± 0.2% | 5.25 ± 0.1% | 6.94 ± 0.2% | 6427.87 ± 0.4% | 3.60 | 1.00 | 1.63 | 294.14 |
| literal: a word in any case | 217 | 15169.67 ± 0.7% | 1911.90 ± 0.2% | 21.53 ± 0.1% | 3965.17 ± 0.5% | 38.06 ± 1.9% | refused | differs | 15203.93 ± 0.2% | 7.93 | 1.00 | 3.83 | 398.62 |
| literal: an href attribute | 33 | 16955.74 ± 1.8% | 609.56 ± 0.4% | 27.26 ± 0.3% | 17015.37 ± 1.3% | 2256.33 ± 0.4% | 13.26 ± 0.2% | 75.61 ± 0.2% | 16989.24 ± 1.2% | 27.82 | 1.00 | 1.00 | 7.51 |
| literal: a word, second text | 123 | 19687.50 ± 3.7% | 4584.90 ± 0.4% | 27.97 ± 0.3% | 18006.90 ± 1.3% | 7768.84 ± 4.5% | 19.70 ± 0.3% | 70.97 ± 0.4% | 19829.98 ± 2.6% | 4.29 | 0.99 | 1.09 | 2.53 |
| class: two capitalized words | 1331 | 1178.96 ± 0.2% | 598.88 ± 0.5% | 25.95 ± 0.4% | 585.14 ± 0.1% | 40.72 ± 13.2% | 14.81 ± 0.2% | 68.03 ± 0.6% | 1179.47 ± 0.4% | 1.97 | 1.00 | 2.01 | 28.95 |
| class: a word that ends in ing | 3399 | 575.02 ± 0.1% | 574.19 ± 0.2% | 17.89 ± 0.2% | 548.44 ± 0.0% | 29.68 ± 7.3% | 8.13 ± 0.2% | 18.39 ± 0.2% | 575.65 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.38 |
| class: a word in capitals | 2332 | 1533.04 ± 0.3% | 608.83 ± 0.3% | 27.56 ± 0.3% | 572.83 ± 0.4% | 43.48 ± 2.9% | 17.17 ± 0.3% | 83.22 ± 0.8% | 1533.04 ± 0.2% | 2.52 | 1.00 | 2.68 | 35.26 |
| class: a number | 8288 | 2673.67 ± 0.5% | 841.34 ± 0.1% | 27.74 ± 0.3% | 1722.77 ± 0.1% | 40.82 ± 16.3% | 0.54 ± 1.1% | 57.16 ± 0.3% | 2678.92 ± 0.6% | 3.18 | 1.00 | 1.55 | 65.50 |
| class: two capitalized words, second text | 5359 | 521.79 ± 0.7% | 529.01 ± 0.4% | 23.22 ± 0.2% | 484.85 ± 0.0% | 35.45 ± 15.3% | 16.64 ± 0.3% | 63.34 ± 0.4% | 521.63 ± 0.3% | 0.99 | 1.00 | 1.08 | 14.72 |
| other: a word between two words | 6104 | 809.94 ± 0.2% | 602.88 ± 0.2% | 23.45 ± 0.1% | 732.24 ± 0.2% | 107.86 ± 9.1% | 11.24 ± 0.2% | 69.55 ± 0.8% | 809.54 ± 0.2% | 1.34 | 1.00 | 1.11 | 7.51 |
| other: a number before a unit, second text | 1481 | 6268.53 ± 1.5% | 1142.47 ± 0.2% | 25.95 ± 0.2% | 5643.02 ± 0.4% | 40.80 ± 0.2% | 17.75 ± 0.2% | 65.84 ± 0.3% | 6258.23 ± 1.4% | 5.49 | 1.00 | 1.11 | 153.65 |
| other: a heading's start tag | 110 | 14158.82 ± 1.0% | 740.22 ± 0.2% | 27.30 ± 0.2% | 1712.95 ± 0.4% | 1582.83 ± 3.9% | 16.21 ± 0.5% | 87.61 ± 0.5% | 14213.23 ± 1.2% | 19.13 | 1.00 | 8.27 | 8.95 |
| other: a whole word | 217 | 16269.39 ± 1.3% | 599.64 ± 0.6% | 28.79 ± 0.5% | 14627.26 ± 1.9% | 49.41 ± 0.2% | 13.49 ± 0.2% | 55.44 ± 0.2% | 16412.74 ± 1.2% | 27.13 | 0.99 | 1.11 | 329.26 |
| other: a line's first word, second text | 3716 | 2102.36 ± 0.8% | 592.15 ± 0.1% | 30.85 ± 0.3% | 1729.53 ± 0.5% | 62.19 ± 8.9% | refused | refused | 2105.21 ± 0.7% | 3.55 | 1.00 | 1.22 | 33.80 |
| other: fourteen octets before an x | 87 | 24281.99 ± 1.6% | 236.35 ± 0.8% | 6.46 ± 0.1% | 3983.77 ± 1.4% | 10.63 ± 0.1% | differs | 17.92 ± 0.1% | 24151.34 ± 7.4% | 102.74 | 1.01 | 6.10 | 2284.69 |
| other: a Greek word | 21815 | 528.77 ± 0.4% | 423.75 ± 0.4% | 30.43 ± 0.1% | 290.36 ± 0.3% | 49.31 ± 12.4% | differs | refused | 529.23 ± 0.2% | 1.25 | 1.00 | 1.82 | 10.72 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.69 ± 0.2% | 29.61 ± 0.2% | 0.86 ± 0.3% | 19.76 ± 0.2% | 2.74 ± 0.5% | differs | 4.04 ± 0.1% | 29.63 ± 0.3% | 1.00 | 1.00 | 1.50 | 10.85 |
| a UUID | 32895 | 24.67 ± 0.1% | 24.80 ± 0.1% | 0.64 ± 0.2% | 15.13 ± 0.1% | 3.10 ± 0.3% | 0.72 ± 0.2% | 3.61 ± 0.3% | 24.77 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.96 |
| an IPv4 address | 33176 | 38.80 ± 0.5% | 38.81 ± 0.4% | 2.09 ± 0.7% | 29.27 ± 0.7% | 6.66 ± 0.2% | differs | 4.21 ± 0.2% | 38.80 ± 0.4% | 1.00 | 1.00 | 1.33 | 5.83 |
| a date and time | 32954 | 33.94 ± 0.1% | 34.11 ± 0.3% | 1.44 ± 0.2% | 21.48 ± 0.5% | 7.02 ± 0.1% | 1.19 ± 0.0% | 7.09 ± 0.5% | 34.10 ± 0.3% | 1.00 | 1.00 | 1.58 | 4.83 |
| a field path | 32606 | 32.81 ± 0.1% | 32.84 ± 0.2% | 1.02 ± 0.2% | 23.16 ± 0.4% | 3.50 ± 1.0% | differs | 2.96 ± 0.2% | 32.86 ± 0.4% | 1.00 | 1.00 | 1.42 | 9.38 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.22 ± 0.5% | 11.18 ± 0.6% | 11.17 ± 0.5% | 11.44 ± 0.8% | 4.90 ± 1.2% | 0.90 ± 1.0% | none | 11.17 ± 0.7% | 1.00 | 1.00 | 0.98 | 2.29 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 228.57 ± 0.2% | 228.48 ± 0.2% | 269.53 ± 0.1% | 86.07 ± 0.6% | 222.16 ± 0.5% | 479.22 ± 0.5% | 3661.64 ± 3.1% | 228.67 ± 0.4% | 1.00 | 1.00 | 2.66 | 1.03 |
| a UUID | 62 | 151.82 ± 0.3% | 151.83 ± 0.1% | 169.32 ± 0.1% | 45.92 ± 0.4% | 99.17 ± 0.9% | 182.60 ± 1.3% | 4358.05 ± 0.5% | 151.80 ± 0.2% | 1.00 | 1.00 | 3.31 | 1.53 |
| an IPv4 address | 29 | 422.57 ± 0.4% | 422.11 ± 0.3% | 589.42 ± 0.5% | 76.64 ± 0.6% | 131.36 ± 1.5% | 293.28 ± 1.3% | 7559.76 ± 0.3% | 423.22 ± 0.3% | 1.00 | 1.00 | 5.51 | 3.22 |
| a date and time | 56 | 302.21 ± 0.5% | 302.30 ± 0.4% | 378.52 ± 0.4% | 71.71 ± 1.6% | 137.28 ± 20.1% | 319.85 ± 1.3% | 4937.42 ± 0.4% | 302.37 ± 0.3% | 1.00 | 1.00 | 4.21 | 2.20 |
| a field path | 39 | 224.15 ± 0.4% | 224.09 ± 0.4% | 263.43 ± 0.3% | 80.20 ± 1.4% | 206.58 ± 1.1% | 492.34 ± 1.1% | 4747.50 ± 0.5% | 224.17 ± 0.4% | 1.00 | 1.00 | 2.79 | 1.09 |
| literal: a word | 7 | 603.09 ± 0.3% | 648.40 ± 0.4% | 1124.51 ± 0.2% | 505.22 ± 0.2% | 635.79 ± 1.3% | 926.04 ± 0.5% | 30208.43 ± 0.2% | 603.32 ± 0.3% | 0.93 | 1.00 | 1.19 | 0.95 |
| literal: a word that is not there | 8 | 586.46 ± 0.4% | 634.60 ± 0.5% | 1088.92 ± 0.6% | 461.88 ± 0.1% | 601.63 ± 4.2% | 892.45 ± 0.5% | 29069.13 ± 0.5% | 586.77 ± 0.4% | 0.92 | 1.00 | 1.27 | 0.97 |
| literal: one of four words | 26 | 244.77 ± 0.4% | 387.06 ± 0.4% | 523.86 ± 0.3% | 49.67 ± 1.1% | 241.45 ± 1.2% | 364.87 ± 0.7% | 15550.15 ± 0.2% | 244.42 ± 0.3% | 0.63 | 1.00 | 4.93 | 1.01 |
| literal: a word in any case | 11 | 439.06 ± 0.2% | 467.47 ± 0.4% | 683.49 ± 0.6% | 15.76 ± 0.5% | 653.09 ± 1.6% | refused | 23630.23 ± 0.4% | 439.15 ± 0.3% | 0.94 | 1.00 | 27.85 | 0.67 |
| literal: an href attribute | 12 | 339.27 ± 0.6% | 351.35 ± 0.4% | 459.67 ± 0.3% | 45.40 ± 0.5% | 499.97 ± 0.4% | 778.29 ± 1.8% | 21533.20 ± 0.3% | 339.29 ± 0.3% | 0.97 | 1.00 | 7.47 | 0.68 |
| literal: a word, second text | 10 | 540.87 ± 0.5% | 591.71 ± 0.5% | 973.22 ± 0.1% | 420.24 ± 0.5% | 536.47 ± 3.1% | 819.81 ± 0.6% | 27014.14 ± 1.9% | 541.00 ± 0.2% | 0.91 | 1.00 | 1.29 | 1.01 |
| class: two capitalized words | 23 | 432.48 ± 0.4% | 458.83 ± 0.5% | 658.30 ± 0.7% | 100.97 ± 0.3% | 502.08 ± 0.6% | 759.62 ± 0.4% | 6288.76 ± 0.4% | 432.06 ± 0.3% | 0.94 | 1.00 | 4.28 | 0.86 |
| class: a word that ends in ing | 9 | 553.68 ± 0.3% | 617.28 ± 0.2% | 1067.64 ± 0.2% | 132.97 ± 0.3% | 758.16 ± 1.1% | 1117.90 ± 2.5% | 15665.96 ± 0.1% | 553.59 ± 0.3% | 0.90 | 1.00 | 4.16 | 0.73 |
| class: a word in capitals | 16 | 492.51 ± 0.2% | 529.01 ± 0.1% | 835.80 ± 0.2% | 135.83 ± 0.9% | 749.93 ± 1.2% | 1036.17 ± 0.9% | 8285.29 ± 0.2% | 492.59 ± 0.2% | 0.93 | 1.00 | 3.63 | 0.66 |
| class: a number | 6 | 620.46 ± 0.3% | 678.54 ± 0.2% | 1246.68 ± 0.1% | 42.14 ± 0.7% | 1393.92 ± 5.2% | 1908.45 ± 0.7% | 22728.87 ± 0.1% | 620.23 ± 0.2% | 0.91 | 1.00 | 14.72 | 0.45 |
| class: two capitalized words, second text | 23 | 432.14 ± 0.4% | 459.43 ± 0.2% | 658.74 ± 0.2% | 102.06 ± 1.4% | 501.46 ± 1.3% | 765.82 ± 0.4% | 6293.26 ± 0.1% | 431.76 ± 0.3% | 0.94 | 1.00 | 4.23 | 0.86 |
| other: a word between two words | 13 | 529.05 ± 0.2% | 550.00 ± 0.2% | 867.62 ± 0.2% | 136.34 ± 0.6% | 499.58 ± 1.9% | 819.06 ± 0.5% | 14530.83 ± 0.0% | 529.09 ± 0.3% | 0.96 | 1.00 | 3.88 | 1.06 |
| other: a number before a unit, second text | 15 | 391.27 ± 0.2% | 429.44 ± 0.1% | 599.32 ± 0.1% | 39.53 ± 0.5% | 637.13 ± 4.6% | 892.80 ± 0.4% | 15083.02 ± 0.4% | 390.85 ± 0.3% | 0.91 | 1.00 | 9.90 | 0.61 |
| other: a heading's start tag | 13 | 350.82 ± 0.4% | 357.42 ± 0.2% | 468.44 ± 0.3% | 44.48 ± 0.5% | 633.78 ± 0.6% | 869.94 ± 0.2% | 17970.44 ± 0.1% | 351.10 ± 0.3% | 0.98 | 1.00 | 7.89 | 0.55 |
| other: a whole word | 11 | 561.29 ± 0.8% | 599.90 ± 0.9% | 988.24 ± 0.9% | 120.91 ± 0.3% | 570.55 ± 2.1% | 832.55 ± 0.5% | 26860.68 ± 0.1% | 561.42 ± 1.2% | 0.94 | 1.00 | 4.64 | 0.98 |
| other: a line's first word, second text | 17 | 508.88 ± 0.7% | 544.42 ± 0.4% | 862.66 ± 0.2% | 129.22 ± 0.3% | 706.61 ± 4.5% | refused | refused | 510.44 ± 0.4% | 0.93 | 1.00 | 3.94 | 0.72 |
| other: fourteen octets before an x | 16 | 109.34 ± 0.4% | 156.82 ± 0.8% | 179.59 ± 0.4% | 15.22 ± 0.4% | 453.43 ± 2.5% | 407.67 ± 1.1% | 12696.19 ± 0.1% | 109.48 ± 0.5% | 0.70 | 1.00 | 7.18 | 0.24 |
| other: a Greek word | 8 | 448.00 ± 0.6% | 589.11 ± 0.8% | 982.33 ± 0.5% | 58.83 ± 0.5% | 1384.76 ± 1.5% | 1857.77 ± 0.7% | refused | 448.95 ± 0.4% | 0.76 | 1.00 | 7.61 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15638.45 ± 0.7% | not timed | not timed | 16187.69 ± 1.1% | 2057.95 ± 9.9% | not timed | not timed | 15608.57 ± 1.5% | | 1.00 | 0.97 | 7.60 |
| 01-literal/sherlock-casei-en | 522 | 10977.25 ± 6.9% | not timed | not timed | 3587.51 ± 0.2% | 32.47 ± 5.7% | not timed | not timed | 11003.29 ± 1.7% | | 1.00 | 3.06 | 338.06 |
| 01-literal/sherlock-ru | 724 | 17106.87 ± 1.0% | not timed | not timed | 17229.53 ± 1.0% | 1402.43 ± 12.7% | not timed | not timed | 17126.21 ± 0.7% | | 1.00 | 0.99 | 12.20 |
| 01-literal/sherlock-casei-ru | 746 | 6128.55 ± 0.4% | not timed | not timed | 3325.63 ± 0.3% | 31.67 ± 1.1% | not timed | not timed | 6140.15 ± 0.0% | | 1.00 | 1.84 | 193.49 |
| 01-literal/sherlock-zh | 30 | 19637.41 ± 0.8% | not timed | not timed | 18560.54 ± 0.9% | 2613.11 ± 1.9% | not timed | not timed | 19621.47 ± 0.7% | | 1.00 | 1.06 | 7.51 |
| 02-literal-alternate/sherlock-en | 714 | 6139.28 ± 0.1% | not timed | not timed | 3941.83 ± 0.3% | 16.61 ± 0.1% | not timed | not timed | 6148.00 ± 0.3% | | 1.00 | 1.56 | 369.71 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1965.67 ± 1.2% | not timed | not timed | 696.96 ± 0.3% | 11.05 ± 0.3% | not timed | not timed | 1967.50 ± 0.9% | | 1.00 | 2.82 | 177.92 |
| 02-literal-alternate/sherlock-ru | 899 | 5510.43 ± 0.1% | not timed | not timed | 3256.02 ± 0.3% | 22.44 ± 0.1% | not timed | not timed | 5509.02 ± 0.1% | | 1.00 | 1.69 | 245.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2051.21 ± 0.6% | not timed | not timed | 1226.94 ± 0.6% | 9.14 ± 0.2% | not timed | not timed | 2048.45 ± 0.5% | | 1.00 | 1.67 | 224.40 |
| 02-literal-alternate/sherlock-zh | 207 | 7337.80 ± 0.2% | not timed | not timed | 4165.00 ± 0.2% | 31.54 ± 0.1% | not timed | not timed | 7338.66 ± 0.5% | | 1.00 | 1.76 | 232.66 |
| 03-date/ascii | 111817 | 133.96 ± 1.2% | not timed | not timed | 96.12 ± 0.1% | 0.20 ± 4.3% | not timed | not timed | 134.05 ± 1.2% | | 1.00 | 1.39 | 668.79 |
| 04-ruff-noqa/real | 84 | 438.82 ± 0.3% | not timed | not timed | 463.02 ± 0.1% | 19.31 ± 1.1% | not timed | not timed | 437.89 ± 0.3% | | 1.00 | 0.95 | 22.73 |
| 04-ruff-noqa/tweaked | 44 | 846.46 ± 0.2% | not timed | not timed | 462.04 ± 0.0% | 364.28 ± 1.7% | not timed | not timed | 844.97 ± 0.1% | | 1.00 | 1.83 | 2.32 |
| 05-lexer-veryl/single | 124800 | 5.24 ± 0.5% | not timed | not timed | 4.98 ± 0.1% | 0.20 ± 3.7% | not timed | not timed | 5.29 ± 0.3% | | 0.99 | 1.05 | 25.79 |
| 06-cloud-flare-redos/original | 107 | 440.18 ± 0.2% | not timed | not timed | 214.02 ± 0.0% | 24.85 ± 0.1% | not timed | not timed | 440.17 ± 0.3% | | 1.00 | 2.06 | 17.71 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.73 ± 0.1% | not timed | not timed | 229.30 ± 0.0% | 26.59 ± 0.1% | not timed | not timed | 438.24 ± 0.4% | | 1.00 | 1.91 | 16.50 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.79 ± 0.1% | not timed | not timed | 256.24 ± 0.1% | 28.81 ± 0.4% | not timed | not timed | 629.30 ± 0.1% | | 1.00 | 2.45 | 21.82 |
| 07-unicode-character-data/parse-line | 558784 | 240.81 ± 0.5% | not timed | not timed | 169.10 ± 0.1% | 42.89 ± 5.7% | not timed | not timed | 242.97 ± 1.0% | | 0.99 | 1.42 | 5.61 |
| 08-words/all-english | 56691 | 129.01 ± 0.6% | not timed | not timed | 83.19 ± 0.1% | 12.60 ± 10.5% | not timed | not timed | 129.35 ± 0.4% | | 1.00 | 1.55 | 10.24 |
| 08-words/long-english | 839 | 618.10 ± 0.9% | not timed | not timed | 597.04 ± 0.2% | 32.68 ± 0.4% | not timed | not timed | 618.27 ± 1.2% | | 1.00 | 1.04 | 18.91 |
| 09-aws-keys/full | 0 | 442.68 ± 0.3% | not timed | not timed | 462.35 ± 0.1% | 63.84 ± 0.2% | not timed | not timed | 443.15 ± 0.1% | | 1.00 | 0.96 | 6.93 |
| 09-aws-keys/quick | 0 | 873.60 ± 0.2% | not timed | not timed | 986.84 ± 0.3% | 419.86 ± 0.8% | not timed | not timed | 873.93 ± 0.2% | | 1.00 | 0.89 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 589.62 ± 3.6% | not timed | not timed | 516.02 ± 0.4% | 19.60 ± 0.4% | not timed | not timed | 579.97 ± 2.4% | | 1.02 | 1.14 | 30.09 |
| 10-bounded-repeat/letters-ru | 3475 | 505.49 ± 1.5% | not timed | not timed | 476.97 ± 0.1% | 21.91 ± 8.9% | not timed | not timed | 506.51 ± 0.8% | | 1.00 | 1.06 | 23.07 |
| 10-bounded-repeat/context | 53 | 84.86 ± 2.2% | not timed | not timed | 66.08 ± 0.5% | 19.78 ± 0.2% | not timed | not timed | 84.78 ± 1.9% | | 1.00 | 1.28 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 637.51 ± 8.5% | not timed | not timed | 618.33 ± 0.1% | 36.65 ± 0.2% | not timed | not timed | 637.68 ± 7.9% | | 1.00 | 1.03 | 17.39 |
| 11-unstructured-to-json/extract | 600 | 58.04 ± 0.3% | not timed | not timed | 77.72 ± 0.1% | 49.11 ± 0.5% | not timed | not timed | 57.84 ± 0.4% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 559.71 ± 2.0% | not timed | not timed | 561.49 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 562.74 ± 1.3% | | 0.99 | 1.00 | 1385.34 |
| 14-quadratic/1x | 100 | 21.97 ± 0.7% | not timed | not timed | 10.00 ± 0.2% | 0.97 ± 3.0% | not timed | not timed | 22.11 ± 0.2% | | 0.99 | 2.20 | 22.69 |
| 14-quadratic/2x | 200 | 19.78 ± 1.1% | not timed | not timed | 5.53 ± 0.1% | 0.53 ± 1.9% | not timed | not timed | 19.90 ± 0.6% | | 0.99 | 3.58 | 37.36 |
| 14-quadratic/10x | 1000 | 12.31 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.0% | not timed | not timed | 12.34 ± 0.6% | | 1.00 | 10.21 | 106.99 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 1.9% | not timed | not timed | 0.35 ± 0.6% | 0.54 ± 3.4% | not timed | not timed | 1.27 ± 0.3% | | 1.00 | 3.65 | 2.35 |
| 04-ruff-noqa/compile-real | 1 | 104.92 ± 0.8% | not timed | not timed | 13.81 ± 0.5% | 140.99 ± 1.8% | not timed | not timed | 105.01 ± 1.3% | | 1.00 | 7.60 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 14.12 ± 1.8% | not timed | not timed | 2.53 ± 0.8% | 6.51 ± 2.4% | not timed | not timed | 14.16 ± 1.8% | | 1.00 | 5.59 | 2.17 |
| 07-unicode-character-data/compile | 1 | 109.02 ± 1.1% | not timed | not timed | 26.00 ± 0.4% | 36.29 ± 3.3% | not timed | not timed | 108.91 ± 0.4% | | 1.00 | 4.19 | 3.00 |
| 09-aws-keys/compile-full | 1 | 53.25 ± 0.3% | not timed | not timed | 8.27 ± 0.3% | 23.39 ± 0.6% | not timed | not timed | 53.20 ± 0.2% | | 1.00 | 6.44 | 2.28 |
| 09-aws-keys/compile-quick | 1 | 187.92 ± 1.0% | not timed | not timed | 46.62 ± 0.3% | 133.22 ± 3.2% | not timed | not timed | 187.99 ± 1.0% | | 1.00 | 4.03 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 71.52 ± 0.5% | not timed | not timed | 11.15 ± 0.3% | 16.23 ± 2.2% | not timed | not timed | 71.49 ± 1.2% | | 1.00 | 6.41 | 4.41 |
| 10-bounded-repeat/compile-capitals | 1 | 86.09 ± 1.3% | not timed | not timed | 8.11 ± 0.6% | 23.97 ± 1.6% | not timed | not timed | 85.99 ± 1.3% | | 1.00 | 10.61 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 172.33 ± 0.8% | not timed | not timed | 41.19 ± 0.7% | 69.11 ± 2.6% | not timed | not timed | 172.94 ± 1.8% | | 1.00 | 4.18 | 2.49 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.9% | not timed | not timed | 0.07 ± 18.5% | 0.09 ± 16.3% | not timed | not timed | 0.35 ± 0.5% | | 1.00 | 5.03 | 3.80 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.46 ± 0.3% | not timed | not timed | 6.49 ± 0.2% | 0.53 ± 1.0% | not timed | not timed | 7.46 ± 0.4% | | 1.00 | 1.15 | 14.16 |
| dictionary/search/english-10 | 690 | 208.11 ± 1.9% | not timed | not timed | 166.78 ± 0.3% | 0.00 ± 0.3% | not timed | not timed | 199.23 ± 6.1% | | 1.04 | 1.25 | 74681.29 |
| dictionary/search/english-15 | 15 | 561.01 ± 1.2% | not timed | not timed | 559.42 ± 0.2% | 0.37 ± 0.4% | not timed | not timed | 563.22 ± 2.0% | | 1.00 | 1.00 | 1536.76 |
| folly/awyer-inn-busted | 1 | 21487.02 ± 0.1% | not timed | not timed | 143.57 ± 0.1% | 43.93 ± 0.3% | not timed | not timed | 21539.54 ± 0.2% | | 1.00 | 149.66 | 489.16 |
| folly/literal-never-match-rare | 0 | 21155.19 ± 0.3% | not timed | not timed | 19942.84 ± 0.3% | 40908.69 ± 0.3% | not timed | not timed | 21171.01 ± 0.1% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12562.35 ± 1.5% | not timed | not timed | 19883.39 ± 0.3% | 2191.46 ± 1.0% | not timed | not timed | 12560.40 ± 1.3% | | 1.00 | 0.63 | 5.73 |
| folly/literal-never-match-tricksy | 1 | 3257.76 ± 0.4% | not timed | not timed | 4409.87 ± 0.4% | 3057.09 ± 0.2% | not timed | not timed | 3256.05 ± 0.5% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1298.25 ± 0.6% | not timed | not timed | 955.95 ± 0.2% | 385.34 ± 20.3% | not timed | not timed | 1304.96 ± 0.5% | | 0.99 | 1.36 | 3.37 |
| grep/long-words-ascii | 5073 | 459.30 ± 0.2% | not timed | not timed | 466.02 ± 0.1% | 46.11 ± 8.4% | not timed | not timed | 458.82 ± 0.3% | | 1.00 | 0.99 | 9.96 |
| imported/leipzig/twain | 811 | 20397.46 ± 2.7% | not timed | not timed | 19284.60 ± 1.7% | 11796.35 ± 9.6% | not timed | not timed | 20418.66 ± 1.6% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9064.47 ± 0.7% | not timed | not timed | 4249.16 ± 0.1% | 37.72 ± 0.0% | not timed | not timed | 9089.11 ± 0.9% | | 1.00 | 2.13 | 240.34 |
| imported/leipzig/shing | 1540 | 15326.19 ± 2.0% | not timed | not timed | 13483.09 ± 0.4% | 34.02 ± 0.1% | not timed | not timed | 15549.17 ± 2.6% | | 0.99 | 1.14 | 450.45 |
| imported/leipzig/huck-saw | 262 | 8257.84 ± 2.9% | not timed | not timed | 5598.38 ± 0.1% | 31.77 ± 0.3% | not timed | not timed | 8428.92 ± 2.5% | | 0.98 | 1.48 | 259.93 |
| imported/leipzig/word-ending-nn | 262 | 603.72 ± 0.8% | not timed | not timed | 616.76 ± 0.1% | 24.73 ± 0.6% | not timed | not timed | 603.86 ± 1.1% | | 1.00 | 0.98 | 24.42 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11245.28 ± 1.0% | not timed | not timed | 4518.72 ± 0.5% | 11.51 ± 0.1% | not timed | not timed | 11270.58 ± 0.8% | | 1.00 | 2.49 | 977.02 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7834.49 ± 0.9% | not timed | not timed | 5486.50 ± 0.1% | 16.73 ± 0.0% | not timed | not timed | 7928.22 ± 2.1% | | 0.99 | 1.43 | 468.33 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4179.79 ± 0.6% | not timed | not timed | 419.19 ± 0.7% | 11.01 ± 0.1% | not timed | not timed | 4181.82 ± 0.6% | | 1.00 | 9.97 | 379.80 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7335.35 ± 3.3% | not timed | not timed | 615.51 ± 0.1% | 11.10 ± 0.1% | not timed | not timed | 7355.36 ± 2.6% | | 1.00 | 11.92 | 660.71 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7183.94 ± 3.3% | not timed | not timed | 615.48 ± 0.1% | 9.74 ± 0.1% | not timed | not timed | 7206.66 ± 2.3% | | 1.00 | 11.67 | 737.37 |
| imported/leipzig/tom-river | 2 | 6482.26 ± 1.5% | not timed | not timed | 5150.19 ± 0.1% | 31.06 ± 0.1% | not timed | not timed | 6592.38 ± 1.8% | | 0.98 | 1.26 | 208.72 |
| imported/leipzig/ing | 78424 | 602.96 ± 0.5% | not timed | not timed | 570.63 ± 0.1% | 28.05 ± 3.3% | not timed | not timed | 602.60 ± 1.2% | | 1.00 | 1.06 | 21.49 |
| imported/leipzig/ing-whitespace | 55248 | 1927.38 ± 1.3% | not timed | not timed | 2085.54 ± 0.5% | 20.57 ± 2.8% | not timed | not timed | 1928.09 ± 0.5% | | 1.00 | 0.92 | 93.71 |
| imported/leipzig/awyer-inn | 209 | 6392.98 ± 1.2% | not timed | not timed | 4283.04 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 6434.49 ± 1.4% | | 0.99 | 1.49 | 282.89 |
| imported/leipzig/quotes-bounded | 8886 | 2480.64 ± 3.8% | not timed | not timed | 3018.84 ± 0.5% | 38.18 ± 0.2% | not timed | not timed | 2489.99 ± 1.2% | | 1.00 | 0.82 | 64.97 |
| imported/leipzig/non-ascii-alternate | 2 | 12866.61 ± 1.9% | not timed | not timed | 5666.83 ± 0.2% | 50.59 ± 0.2% | not timed | not timed | 13079.35 ± 2.2% | | 0.98 | 2.27 | 254.32 |
| imported/leipzig/math-symbols | 69 | 1982.54 ± 0.5% | not timed | not timed | 614.80 ± 0.3% | 36.50 ± 0.1% | not timed | not timed | 1975.99 ± 0.8% | | 1.00 | 3.22 | 54.31 |
| imported/leipzig/bounded-strings-ending-z | 0 | 630.41 ± 2.0% | not timed | not timed | 617.87 ± 0.2% | 22.47 ± 0.3% | not timed | not timed | 629.06 ± 1.5% | | 1.00 | 1.02 | 28.05 |
| imported/lh3lh3-reb/uri | 17549 | 678.19 ± 0.0% | not timed | not timed | 1072.86 ± 0.3% | 27.97 ± 2.2% | not timed | not timed | 679.95 ± 0.2% | | 1.00 | 0.63 | 24.25 |
| imported/lh3lh3-reb/email | 15057 | 674.24 ± 0.1% | not timed | not timed | 1155.35 ± 0.2% | 30.55 ± 3.1% | not timed | not timed | 676.42 ± 0.1% | | 1.00 | 0.58 | 22.07 |
| imported/lh3lh3-reb/date | 668 | 892.39 ± 0.2% | not timed | not timed | 1032.50 ± 0.2% | 50.64 ± 4.4% | not timed | not timed | 893.21 ± 0.2% | | 1.00 | 0.86 | 17.62 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.54 ± 0.1% | not timed | not timed | 423.37 ± 0.1% | 15.67 ± 1.6% | not timed | not timed | 646.85 ± 0.4% | | 1.00 | 1.52 | 41.20 |
| imported/mariomka/email | 92 | 24210.03 ± 1.4% | not timed | not timed | 29420.82 ± 1.2% | 32.80 ± 0.1% | not timed | not timed | 24459.00 ± 1.4% | | 0.99 | 0.82 | 738.22 |
| imported/mariomka/uri | 5301 | 5556.64 ± 0.6% | not timed | not timed | 6105.86 ± 7.6% | 32.73 ± 0.3% | not timed | not timed | 5587.09 ± 9.7% | | 0.99 | 0.91 | 169.79 |
| imported/mariomka/ip | 5 | 2597.33 ± 2.8% | not timed | not timed | 2966.57 ± 0.2% | 21.04 ± 0.2% | not timed | not timed | 2605.18 ± 3.2% | | 1.00 | 0.88 | 123.43 |
| imported/rsc/no-exponential | 0 | 607.97 ± 0.1% | not timed | not timed | 323.61 ± 0.1% | 23.76 ± 0.3% | not timed | not timed | 607.98 ± 0.0% | | 1.00 | 1.88 | 25.59 |
| imported/rsc/literal | 1 | 1496.67 ± 0.8% | not timed | not timed | 1611.57 ± 9.3% | 191.02 ± 92.3% | not timed | not timed | 1492.71 ± 5.7% | | 1.00 | 0.93 | 7.84 |
| imported/rsc/not-literal | 2 | 777.44 ± 8.4% | not timed | not timed | 732.42 ± 0.4% | 46.35 ± 9.4% | not timed | not timed | 780.48 ± 2.4% | | 1.00 | 1.06 | 16.77 |
| imported/rsc/match-class | 1 | 1471.20 ± 2.5% | not timed | not timed | 1629.16 ± 0.6% | 59.23 ± 12.8% | not timed | not timed | 1474.53 ± 0.7% | | 1.00 | 0.90 | 24.84 |
| imported/rsc/match-class-in-range | 1 | 1468.61 ± 2.7% | not timed | not timed | 2281.00 ± 6.5% | 60.10 ± 6.5% | not timed | not timed | 1475.72 ± 0.5% | | 1.00 | 0.64 | 24.44 |
| imported/rsc/match-class-unicode | 1 | 539.48 ± 0.6% | not timed | not timed | 510.41 ± 0.1% | 70.84 ± 0.2% | not timed | not timed | 541.05 ± 0.5% | | 1.00 | 1.06 | 7.62 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1452.38 ± 0.1% | not timed | not timed | 950.32 ± 0.1% | 229.36 ± 0.3% | not timed | not timed | 1450.82 ± 0.1% | | 1.00 | 1.53 | 6.33 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21780.50 ± 0.2% | not timed | not timed | 14350.36 ± 0.1% | 3435.05 ± 0.8% | not timed | not timed | 21755.09 ± 0.2% | | 1.00 | 1.52 | 6.34 |
| imported/rsc/anchored-literal-short-match | 4 | 714.36 ± 3.3% | not timed | not timed | 482.01 ± 0.3% | 83.73 ± 10.3% | not timed | not timed | 722.65 ± 1.8% | | 0.99 | 1.48 | 8.53 |
| imported/rsc/anchored-literal-long-match | 4 | 10658.12 ± 2.6% | not timed | not timed | 7455.09 ± 0.2% | 1276.82 ± 15.0% | not timed | not timed | 10829.36 ± 2.0% | | 0.98 | 1.43 | 8.35 |
| imported/rsc/one-pass-short | 17 | 366.40 ± 1.2% | not timed | not timed | 215.34 ± 0.3% | 31.50 ± 8.9% | not timed | not timed | 368.47 ± 10.8% | | 0.99 | 1.70 | 11.63 |
| imported/rsc/one-pass-short-not | 17 | 269.82 ± 1.7% | not timed | not timed | 227.47 ± 0.1% | 31.65 ± 12.8% | not timed | not timed | 269.87 ± 8.0% | | 1.00 | 1.19 | 8.53 |
| imported/rsc/one-pass-long-prefix | 26 | 360.42 ± 2.0% | not timed | not timed | 285.66 ± 0.4% | 98.52 ± 17.0% | not timed | not timed | 361.77 ± 0.6% | | 1.00 | 1.26 | 3.66 |
| imported/rsc/one-pass-long-prefix-not | 26 | 358.58 ± 1.8% | not timed | not timed | 284.31 ± 0.6% | 64.87 ± 12.7% | not timed | not timed | 361.83 ± 2.5% | | 0.99 | 1.26 | 5.53 |
| imported/rsc/long-needle1 | 31 | 21947.79 ± 0.2% | not timed | not timed | 20190.09 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 21972.86 ± 0.2% | | 1.00 | 1.09 | 5844.47 |
| imported/rsc/long-needle2 | 31 | 22083.90 ± 0.1% | not timed | not timed | 216.35 ± 0.3% | 3.76 ± 0.2% | not timed | not timed | 22079.34 ± 0.2% | | 1.00 | 102.07 | 5876.15 |
| imported/rsc/easy0-32 | 26 | 1577.05 ± 0.2% | not timed | not timed | 1585.53 ± 3.8% | 147.84 ± 18.6% | not timed | not timed | 1561.71 ± 2.1% | | 1.01 | 0.99 | 10.67 |
| imported/rsc/easy0-1k | 26 | 13640.34 ± 0.4% | not timed | not timed | 12340.06 ± 1.3% | 2301.33 ± 13.9% | not timed | not timed | 13623.74 ± 3.5% | | 1.00 | 1.11 | 5.93 |
| imported/rsc/easy0-32k | 26 | 22764.03 ± 0.0% | not timed | not timed | 20399.65 ± 0.2% | 18680.20 ± 0.1% | not timed | not timed | 22776.22 ± 0.1% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21688.82 ± 2.8% | not timed | not timed | 19728.09 ± 4.7% | 37772.24 ± 18.1% | not timed | not timed | 21359.80 ± 4.0% | | 1.02 | 1.10 | 0.57 |
| imported/rsc/easy1-32 | 19 | 771.84 ± 2.4% | not timed | not timed | 644.98 ± 0.7% | 128.70 ± 21.0% | not timed | not timed | 770.11 ± 2.3% | | 1.00 | 1.20 | 6.00 |
| imported/rsc/easy1-1k | 19 | 15807.91 ± 2.4% | not timed | not timed | 13052.95 ± 0.3% | 2473.19 ± 17.4% | not timed | not timed | 15789.43 ± 0.3% | | 1.00 | 1.21 | 6.39 |
| imported/rsc/easy1-32k | 19 | 493599.50 ± 0.3% | not timed | not timed | 410917.18 ± 0.4% | 20440.42 ± 31.6% | not timed | not timed | 493041.78 ± 2.3% | | 1.00 | 1.20 | 24.15 |
| imported/rsc/easy1-1mb | 19 | 15879361.99 ± 0.4% | not timed | not timed | 13026294.98 ± 0.1% | 37938.66 ± 2.7% | not timed | not timed | 15886446.14 ± 0.8% | | 1.00 | 1.22 | 418.55 |
| imported/rsc/medium-32 | 27 | 738.74 ± 1.5% | not timed | not timed | 644.35 ± 0.4% | 69.80 ± 10.0% | not timed | not timed | 737.09 ± 0.4% | | 1.00 | 1.15 | 10.58 |
| imported/rsc/medium-1k | 27 | 13134.17 ± 0.4% | not timed | not timed | 11218.61 ± 0.4% | 72.01 ± 0.1% | not timed | not timed | 13081.50 ± 0.3% | | 1.00 | 1.17 | 182.40 |
| imported/rsc/medium-32k | 27 | 408987.36 ± 0.4% | not timed | not timed | 357011.53 ± 0.2% | 48.93 ± 0.2% | not timed | not timed | 408377.74 ± 0.3% | | 1.00 | 1.15 | 8359.47 |
| imported/rsc/medium-1mb | 27 | 13113294.56 ± 0.2% | not timed | not timed | 11490046.56 ± 0.7% | 48.89 ± 0.1% | not timed | not timed | 13021736.63 ± 0.1% | | 1.01 | 1.14 | 268199.69 |
| imported/rsc/hard-32 | 58 | 423.43 ± 2.2% | not timed | not timed | 370.20 ± 0.3% | 49.48 ± 8.0% | not timed | not timed | 420.91 ± 0.2% | | 1.01 | 1.14 | 8.56 |
| imported/rsc/hard-1k | 27 | 12875.44 ± 0.4% | not timed | not timed | 11661.85 ± 0.1% | 40.53 ± 0.1% | not timed | not timed | 12822.75 ± 0.2% | | 1.00 | 1.10 | 317.66 |
| imported/rsc/hard-32k | 27 | 402072.16 ± 0.1% | not timed | not timed | 364811.03 ± 0.4% | 29.36 ± 0.1% | not timed | not timed | 400425.95 ± 0.3% | | 1.00 | 1.10 | 13694.31 |
| imported/rsc/hard-1mb | 51 | 8379171.42 ± 0.1% | not timed | not timed | 7279315.22 ± 0.3% | 29.44 ± 0.1% | not timed | not timed | 8356552.37 ± 0.1% | | 1.00 | 1.15 | 284659.84 |
| imported/rsc/reallyhard0-32 | 58 | 262.53 ± 2.6% | not timed | not timed | 225.39 ± 0.1% | 49.71 ± 8.5% | not timed | not timed | 262.51 ± 0.2% | | 1.00 | 1.16 | 5.28 |
| imported/rsc/reallyhard0-1k | 27 | 579.73 ± 0.7% | not timed | not timed | 582.01 ± 0.1% | 40.75 ± 0.2% | not timed | not timed | 579.72 ± 0.6% | | 1.00 | 1.00 | 14.23 |
| imported/rsc/reallyhard0-32k | 27 | 603.36 ± 0.8% | not timed | not timed | 616.93 ± 0.1% | 29.38 ± 0.1% | not timed | not timed | 601.80 ± 0.3% | | 1.00 | 0.98 | 20.54 |
| imported/rsc/reallyhard0-1mb | 51 | 628.52 ± 1.6% | not timed | not timed | 617.99 ± 0.2% | 29.43 ± 0.1% | not timed | not timed | 622.72 ± 0.9% | | 1.01 | 1.02 | 21.35 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.52 ± 5.1% | not timed | not timed | 195.94 ± 1.2% | 60.48 ± 7.4% | not timed | not timed | 285.56 ± 1.3% | | 1.00 | 1.45 | 4.70 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7016.82 ± 0.1% | not timed | not timed | 5980.24 ± 0.1% | 34.26 ± 4.5% | not timed | not timed | 6993.91 ± 0.1% | | 1.00 | 1.17 | 204.83 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21449.51 ± 0.1% | not timed | not timed | 19388.70 ± 0.1% | 24.55 ± 4.1% | not timed | not timed | 21446.09 ± 0.1% | | 1.00 | 1.11 | 873.78 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21503.64 ± 1.3% | not timed | not timed | 19772.61 ± 2.0% | 24.54 ± 1.5% | not timed | not timed | 21546.49 ± 1.1% | | 1.00 | 1.09 | 876.35 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 280.88 ± 1.7% | not timed | not timed | 213.45 ± 0.2% | 56.64 ± 13.5% | not timed | not timed | 281.40 ± 1.2% | | 1.00 | 1.32 | 4.96 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5919.69 ± 0.0% | not timed | not timed | 6188.45 ± 0.2% | 34.19 ± 1.3% | not timed | not timed | 5930.68 ± 0.0% | | 1.00 | 0.96 | 173.16 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21367.68 ± 0.1% | not timed | not timed | 19372.69 ± 0.1% | 25.04 ± 3.4% | not timed | not timed | 21379.63 ± 0.1% | | 1.00 | 1.10 | 853.22 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21218.90 ± 1.5% | not timed | not timed | 19757.11 ± 1.2% | 25.20 ± 0.1% | not timed | not timed | 21195.43 ± 2.6% | | 1.00 | 1.07 | 841.89 |
| imported/sherlock/name-sherlock | 776 | 19855.66 ± 1.9% | not timed | not timed | 18591.39 ± 0.5% | 10203.09 ± 28.5% | not timed | not timed | 19874.98 ± 1.8% | | 1.00 | 1.07 | 1.95 |
| imported/sherlock/name-holmes | 2766 | 15157.44 ± 2.0% | not timed | not timed | 15632.92 ± 0.5% | 3123.73 ± 14.9% | not timed | not timed | 15320.75 ± 1.7% | | 0.99 | 0.97 | 4.85 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19886.19 ± 2.0% | not timed | not timed | 18568.88 ± 0.3% | 8103.91 ± 18.6% | not timed | not timed | 19911.10 ± 2.0% | | 1.00 | 1.07 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15729.72 ± 0.7% | not timed | not timed | 4013.46 ± 0.2% | 32.55 ± 0.1% | not timed | not timed | 15749.83 ± 0.2% | | 1.00 | 3.92 | 483.29 |
| imported/sherlock/name-holmes-casei | 2802 | 9405.43 ± 7.2% | not timed | not timed | 3326.88 ± 0.1% | 38.36 ± 2.8% | not timed | not timed | 9371.58 ± 6.7% | | 1.00 | 2.83 | 245.16 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12982.81 ± 5.6% | not timed | not timed | 3953.52 ± 0.1% | 32.47 ± 0.4% | not timed | not timed | 13012.17 ± 2.2% | | 1.00 | 3.28 | 399.80 |
| imported/sherlock/name-whitespace | 1461 | 15397.51 ± 7.5% | not timed | not timed | 14531.86 ± 0.4% | 7135.28 ± 34.8% | not timed | not timed | 15382.77 ± 5.4% | | 1.00 | 1.06 | 2.16 |
| imported/sherlock/name-alt1 | 1142 | 11642.30 ± 0.2% | not timed | not timed | 16400.33 ± 1.0% | 4108.12 ± 19.7% | not timed | not timed | 11640.79 ± 2.3% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8966.86 ± 0.3% | not timed | not timed | 3830.59 ± 0.2% | 31.36 ± 0.1% | not timed | not timed | 8971.40 ± 0.2% | | 1.00 | 2.34 | 285.97 |
| imported/sherlock/name-alt3 | 4507 | 5555.66 ± 0.4% | not timed | not timed | 3632.72 ± 0.3% | 9.97 ± 0.1% | not timed | not timed | 5547.19 ± 0.2% | | 1.00 | 1.53 | 557.34 |
| imported/sherlock/name-alt3-casei | 4593 | 1527.63 ± 1.4% | not timed | not timed | 285.37 ± 0.2% | 6.44 ± 0.2% | not timed | not timed | 1529.52 ± 1.0% | | 1.00 | 5.35 | 237.05 |
| imported/sherlock/name-alt4 | 3686 | 6437.04 ± 0.1% | not timed | not timed | 3794.67 ± 0.2% | 31.40 ± 0.3% | not timed | not timed | 6442.62 ± 0.2% | | 1.00 | 1.70 | 205.03 |
| imported/sherlock/name-alt4-casei | 4254 | 2814.84 ± 2.0% | not timed | not timed | 2591.42 ± 0.1% | 19.80 ± 0.1% | not timed | not timed | 2819.32 ± 1.3% | | 1.00 | 1.09 | 142.18 |
| imported/sherlock/name-alt5 | 4028 | 6414.87 ± 0.4% | not timed | not timed | 3751.54 ± 0.2% | 21.85 ± 0.1% | not timed | not timed | 6426.27 ± 0.6% | | 1.00 | 1.71 | 293.57 |
| imported/sherlock/name-alt5-casei | 4104 | 3482.75 ± 1.7% | not timed | not timed | 2225.99 ± 0.1% | 14.32 ± 0.1% | not timed | not timed | 3491.12 ± 1.0% | | 1.00 | 1.56 | 243.21 |
| imported/sherlock/no-match-uncommon | 0 | 21639.88 ± 0.4% | not timed | not timed | 19552.01 ± 0.7% | 36071.96 ± 1.0% | not timed | not timed | 21633.51 ± 0.4% | | 1.00 | 1.11 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21499.23 ± 0.9% | not timed | not timed | 19558.54 ± 0.4% | 1285.29 ± 0.8% | not timed | not timed | 21477.96 ± 0.8% | | 1.00 | 1.10 | 16.73 |
| imported/sherlock/no-match-really-common | 0 | 16158.62 ± 2.9% | not timed | not timed | 18789.28 ± 1.0% | 1275.95 ± 1.0% | not timed | not timed | 16153.03 ± 1.6% | | 1.00 | 0.86 | 12.66 |
| imported/sherlock/the-lower | 21654 | 2307.25 ± 1.1% | not timed | not timed | 2341.98 ± 0.5% | 239.83 ± 15.7% | not timed | not timed | 2313.44 ± 1.8% | | 1.00 | 0.99 | 9.62 |
| imported/sherlock/the-upper | 2223 | 12758.82 ± 1.3% | not timed | not timed | 13627.21 ± 0.8% | 2587.80 ± 22.7% | not timed | not timed | 12816.82 ± 0.9% | | 1.00 | 0.94 | 4.93 |
| imported/sherlock/the-casei | 23961 | 1999.50 ± 0.5% | not timed | not timed | 1316.22 ± 0.4% | 34.81 ± 29.3% | not timed | not timed | 2000.65 ± 1.5% | | 1.00 | 1.52 | 57.44 |
| imported/sherlock/everything-greedy | 581881 | 282.51 ± 0.6% | not timed | not timed | 165.65 ± 0.1% | 28.95 ± 22.8% | not timed | not timed | 281.86 ± 1.0% | | 1.00 | 1.71 | 9.76 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.12 ± 0.1% | not timed | not timed | 212.30 ± 0.0% | 33.03 ± 0.2% | not timed | not timed | 490.33 ± 0.0% | | 1.00 | 2.31 | 14.87 |
| imported/sherlock/letters | 447175 | 61.60 ± 1.2% | not timed | not timed | 33.06 ± 0.1% | 6.60 ± 18.6% | not timed | not timed | 61.84 ± 0.4% | | 1.00 | 1.86 | 9.33 |
| imported/sherlock/letters-upper | 14180 | 448.49 ± 1.2% | not timed | not timed | 372.41 ± 0.3% | 29.56 ± 24.5% | not timed | not timed | 446.70 ± 0.2% | | 1.00 | 1.20 | 15.17 |
| imported/sherlock/letters-lower | 432995 | 62.66 ± 1.2% | not timed | not timed | 34.04 ± 0.2% | 5.31 ± 35.2% | not timed | not timed | 63.04 ± 1.0% | | 0.99 | 1.84 | 11.79 |
| imported/sherlock/words | 447639 | 112.52 ± 0.6% | not timed | not timed | 82.61 ± 0.1% | 15.62 ± 35.9% | not timed | not timed | 113.26 ± 0.7% | | 0.99 | 1.36 | 7.20 |
| imported/sherlock/before-holmes | 4073 | 10301.50 ± 0.3% | not timed | not timed | 8477.88 ± 0.2% | 24.04 ± 1.3% | not timed | not timed | 10283.03 ± 0.4% | | 1.00 | 1.22 | 428.50 |
| imported/sherlock/before-after-holmes | 2593 | 9950.90 ± 1.9% | not timed | not timed | 9531.76 ± 0.3% | 23.97 ± 1.5% | not timed | not timed | 9982.19 ± 0.7% | | 1.00 | 1.04 | 415.06 |
| imported/sherlock/holmes-cochar-watson | 150 | 5211.27 ± 0.5% | not timed | not timed | 3427.06 ± 0.1% | 31.06 ± 0.2% | not timed | not timed | 5208.21 ± 0.2% | | 1.00 | 1.52 | 167.77 |
| imported/sherlock/holmes-coword-watson | 14309 | 1152.96 ± 0.3% | not timed | not timed | 1123.99 ± 0.1% | 6.78 ± 0.2% | not timed | not timed | 1157.10 ± 0.2% | | 1.00 | 1.03 | 170.03 |
| imported/sherlock/quotes | 14437 | 1575.67 ± 0.3% | not timed | not timed | 1749.47 ± 0.4% | 35.13 ± 0.1% | not timed | not timed | 1574.36 ± 0.3% | | 1.00 | 0.90 | 44.85 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17426.64 ± 0.4% | not timed | not timed | 16080.63 ± 0.7% | 36.78 ± 0.2% | not timed | not timed | 17443.31 ± 0.4% | | 1.00 | 1.08 | 473.82 |
| imported/sherlock/word-ending-n | 35297 | 480.37 ± 0.9% | not timed | not timed | 409.69 ± 0.1% | 23.55 ± 24.5% | not timed | not timed | 480.76 ± 0.3% | | 1.00 | 1.17 | 20.40 |
| imported/sherlock/repeated-class-negation | 2130 | 14868.68 ± 1.0% | not timed | not timed | 11086.29 ± 1.6% | 11.59 ± 0.2% | not timed | not timed | 14874.87 ± 0.4% | | 1.00 | 1.34 | 1282.80 |
| imported/sherlock/ing-suffix | 20547 | 559.60 ± 0.3% | not timed | not timed | 517.52 ± 0.1% | 28.86 ± 0.2% | not timed | not timed | 559.36 ± 0.4% | | 1.00 | 1.08 | 19.39 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1673.78 ± 0.4% | not timed | not timed | 2107.48 ± 0.8% | 20.52 ± 0.2% | not timed | not timed | 1673.41 ± 0.7% | | 1.00 | 0.79 | 81.59 |
| opt/accelerate/whole-line | 239963 | 457.23 ± 0.4% | not timed | not timed | 373.42 ± 0.5% | 92.25 ± 16.7% | not timed | not timed | 457.22 ± 0.3% | | 1.00 | 1.22 | 4.96 |
| opt/accelerate/non-dna | 16745 | 431.62 ± 0.3% | not timed | not timed | 399.17 ± 0.2% | 29.52 ± 50.6% | not timed | not timed | 430.31 ± 2.0% | | 1.00 | 1.08 | 14.62 |
| opt/backtrack/words-english | 40536 | 141.67 ± 0.1% | not timed | not timed | 94.41 ± 0.1% | 19.82 ± 7.2% | not timed | not timed | 141.58 ± 1.9% | | 1.00 | 1.50 | 7.15 |
| opt/fixed-length/too-small-ascii | 0 | 311.93 ± 0.3% | not timed | not timed | 702.26 ± 0.9% | 80.29 ± 0.2% | not timed | not timed | 317.88 ± 0.6% | | 0.98 | 0.44 | 3.89 |
| opt/fixed-length/too-big-ascii | 0 | 3468.94 ± 0.1% | not timed | not timed | 5752.54 ± 0.5% | 126.25 ± 0.6% | not timed | not timed | 3458.40 ± 0.1% | | 1.00 | 0.60 | 27.48 |
| opt/fixed-length/go33484-1 | 0 | 665358.04 ± 0.2% | not timed | not timed | 1114549.06 ± 1.1% | 61723.11 ± 0.1% | not timed | not timed | 665609.42 ± 0.2% | | 1.00 | 0.60 | 10.78 |
| opt/fixed-length/go33484-2 | 0 | 665958.49 ± 0.1% | not timed | not timed | 1118990.77 ± 1.6% | 32625.31 ± 2.9% | not timed | not timed | 665825.63 ± 0.2% | | 1.00 | 0.60 | 20.41 |
| opt/fixed-length/go33484-3 | 0 | 66553.19 ± 0.7% | not timed | not timed | 112757.23 ± 1.9% | 767.92 ± 0.4% | not timed | not timed | 66540.25 ± 0.5% | | 1.00 | 0.59 | 86.67 |
| opt/literal-alt/one-pattern | 1 | 544.65 ± 3.2% | not timed | not timed | 541.76 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 549.27 ± 1.9% | | 0.99 | 1.01 | 1378.69 |
| opt/onepass/fn-predicate | 916 | 367.42 ± 0.4% | not timed | not timed | 336.16 ± 0.2% | 204.78 ± 15.6% | not timed | not timed | 368.61 ± 0.9% | | 1.00 | 1.09 | 1.79 |
| opt/onepass/first-three-words-english | 35128 | 179.89 ± 8.3% | not timed | not timed | 199.79 ± 0.1% | 82.47 ± 13.3% | not timed | not timed | 182.39 ± 8.8% | | 0.99 | 0.90 | 2.18 |
| opt/prefilter/literal-english | 1 | 20745.98 ± 0.4% | not timed | not timed | 20235.71 ± 0.4% | 17760.30 ± 0.5% | not timed | not timed | 20784.12 ± 0.5% | | 1.00 | 1.03 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14572.37 ± 0.4% | not timed | not timed | 4316.62 ± 0.2% | 32.59 ± 0.4% | not timed | not timed | 14583.04 ± 0.5% | | 1.00 | 3.38 | 447.18 |
| opt/prefilter/literal-russian | 1 | 21478.13 ± 0.5% | not timed | not timed | 20036.19 ± 0.5% | 3331.48 ± 0.1% | not timed | not timed | 21483.07 ± 0.2% | | 1.00 | 1.07 | 6.45 |
| opt/prefilter/literal-casei-russian | 1 | 8609.79 ± 0.2% | not timed | not timed | 3896.45 ± 0.1% | 31.86 ± 0.3% | not timed | not timed | 8606.83 ± 0.3% | | 1.00 | 2.21 | 270.21 |
| opt/prefilter/rust-functions | 948 | 6819.54 ± 0.2% | not timed | not timed | 8974.21 ± 0.3% | 1870.24 ± 0.4% | not timed | not timed | 6817.95 ± 0.3% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29636359.27 ± 0.2% | not timed | not timed | 21652998.25 ± 0.2% | 50.65 ± 0.1% | not timed | not timed | 29631920.94 ± 0.1% | | 1.00 | 1.37 | 585122.33 |
| opt/reverse-inner/holmes | 2593 | 9972.07 ± 1.1% | not timed | not timed | 9524.23 ± 0.5% | 23.94 ± 1.0% | not timed | not timed | 9967.53 ± 0.8% | | 1.00 | 1.05 | 416.53 |
| opt/reverse-inner/email | 47 | 36422.64 ± 1.8% | not timed | not timed | 44910.93 ± 0.6% | 32.46 ± 0.1% | not timed | not timed | 36521.65 ± 2.9% | | 1.00 | 0.81 | 1122.07 |
| opt/reverse-inner/factored-prefix | 3542 | 592.53 ± 0.7% | not timed | not timed | 597.53 ± 0.1% | 12.57 ± 0.1% | not timed | not timed | 592.61 ± 0.2% | | 1.00 | 0.99 | 47.15 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20994.86 ± 0.1% | not timed | not timed | 616.06 ± 0.5% | 74.93 ± 0.2% | not timed | not timed | 21169.80 ± 0.1% | | 0.99 | 34.08 | 280.19 |
| opt/reverse-inner/no-quadratic-forward | 0 | 735.77 ± 3.0% | not timed | not timed | 288.62 ± 0.1% | 24.70 ± 0.1% | not timed | not timed | 740.09 ± 1.9% | | 0.99 | 2.55 | 29.79 |
| opt/reverse-suffix/holmes | 4073 | 10311.78 ± 0.4% | not timed | not timed | 8487.96 ± 0.2% | 24.16 ± 0.9% | not timed | not timed | 10274.56 ± 0.4% | | 1.00 | 1.21 | 426.88 |
| opt/reverse-suffix/no-quadratic | 0 | 21075.43 ± 0.2% | not timed | not timed | 614.47 ± 0.4% | 74.72 ± 0.1% | not timed | not timed | 21149.02 ± 0.1% | | 1.00 | 34.30 | 282.05 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.06 ± 2.7% | not timed | not timed | 132.21 ± 0.1% | 13.35 ± 15.9% | not timed | not timed | 121.12 ± 2.2% | | 1.00 | 0.92 | 9.07 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.29 ± 2.8% | not timed | not timed | 132.01 ± 0.2% | 12.97 ± 16.8% | not timed | not timed | 121.06 ± 0.7% | | 0.99 | 0.91 | 9.28 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.9% | not timed | not timed | 0.55 ± 0.2% | 113.24 ± 1.2% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.31 ± 0.3% | not timed | not timed | 294.10 ± 0.4% | 103.30 ± 8.4% | not timed | not timed | 322.81 ± 3.0% | | 1.00 | 1.10 | 3.12 |
| reported/i13-subset-regex/original-ascii | 4094 | 11243.29 ± 0.7% | not timed | not timed | 4538.88 ± 1.0% | 11.34 ± 0.1% | not timed | not timed | 11289.06 ± 0.8% | | 1.00 | 2.48 | 991.27 |
| reported/i13-subset-regex/original-unicode | 4094 | 10720.03 ± 1.2% | not timed | not timed | 253.48 ± 3.1% | 11.53 ± 0.1% | not timed | not timed | 11253.21 ± 0.9% | | 0.95 | 42.29 | 929.67 |
| reported/i13-subset-regex/big-ascii | 1955 | 10729.23 ± 1.0% | not timed | not timed | 67.91 ± 3.4% | 9.86 ± 0.2% | not timed | not timed | 10788.93 ± 0.8% | | 0.99 | 158.00 | 1088.07 |
| reported/i13-subset-regex/big-unicode | 1955 | 10652.05 ± 1.3% | not timed | not timed | 12.21 ± 54.9% | 9.87 ± 0.1% | not timed | not timed | 10791.32 ± 0.5% | | 0.99 | 872.29 | 1079.08 |
| reported/i13-subset-regex/huge-ascii | 55 | 10110.07 ± 1.0% | not timed | not timed | 11.07 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 10088.93 ± 1.3% | | 1.00 | 913.62 | 1153.75 |
| reported/i13-subset-regex/huge-unicode | 55 | 10056.26 ± 2.5% | not timed | not timed | 11.00 ± 0.3% | 8.78 ± 0.3% | not timed | not timed | 9900.52 ± 2.3% | | 1.02 | 914.01 | 1145.34 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.00 ± 0.0% | 8.72 ± 0.3% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.6% | not timed | not timed | 11.00 ± 0.5% | 8.77 ± 1.7% | not timed | not timed | 4.96 ± 0.2% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.73 ± 0.2% | not timed | not timed | 104.68 ± 0.0% | 6.56 ± 0.3% | not timed | not timed | 484.36 ± 0.4% | | 1.00 | 4.62 | 73.76 |
| reported/i787-keywords/opt-ascii | 5674 | 485.59 ± 0.4% | not timed | not timed | 272.96 ± 0.3% | 10.29 ± 0.1% | not timed | not timed | 484.06 ± 0.5% | | 1.00 | 1.78 | 47.18 |
| slow/quadratic-regex-1x | 100 | 7.11 ± 0.3% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 0.2% | not timed | not timed | 7.15 ± 0.4% | | 0.99 | 1.43 | 144.18 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.1% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.2% | not timed | not timed | 3.44 ± 0.1% | | 1.00 | 1.24 | 269.26 |
| slow/quadratic-haystack-1x | 100 | 22.00 ± 7.6% | not timed | not timed | 10.04 ± 0.3% | 1.01 ± 13.9% | not timed | not timed | 21.90 ± 1.0% | | 1.00 | 2.19 | 21.73 |
| slow/quadratic-haystack-2x | 200 | 19.72 ± 0.8% | not timed | not timed | 5.53 ± 0.2% | 0.54 ± 0.9% | not timed | not timed | 19.65 ± 7.2% | | 1.00 | 3.57 | 36.22 |
| unicode/codepoints/any-one | 1112064 | 281.66 ± 1.0% | not timed | not timed | 176.46 ± 0.2% | 18.10 ± 15.7% | not timed | not timed | 282.31 ± 0.3% | | 1.00 | 1.60 | 15.56 |
| unicode/codepoints/any-all | 4382592 | 283.23 ± 1.1% | not timed | not timed | 246.72 ± 0.1% | 117.43 ± 0.0% | not timed | not timed | 282.41 ± 0.5% | | 1.00 | 1.15 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 601.79 ± 1.0% | not timed | not timed | 616.80 ± 0.4% | 135.45 ± 0.7% | not timed | not timed | 602.37 ± 0.5% | | 1.00 | 0.98 | 4.44 |
| unicode/overlapping-words/ascii | 6156 | 32.25 ± 0.2% | not timed | not timed | 38.84 ± 0.2% | 3.93 ± 0.2% | not timed | not timed | 32.28 ± 0.3% | | 1.00 | 0.83 | 8.21 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 4.45 ± 0.1% | 2.35 ± 0.2% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.32 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 14.1% | not timed | not timed | 3.86 ± 0.2% | 6.26 ± 9.9% | not timed | not timed | 1.28 ± 0.5% | | 1.00 | 0.33 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.52 ± 3.3% | not timed | not timed | 82.51 ± 0.2% | 11.62 ± 15.3% | not timed | not timed | 129.49 ± 3.7% | | 1.00 | 1.57 | 11.15 |
| unicode/word/boundary-long-english | 3466 | 609.02 ± 0.3% | not timed | not timed | 604.37 ± 0.2% | 31.59 ± 3.7% | not timed | not timed | 607.42 ± 1.0% | | 1.00 | 1.01 | 19.28 |
| unicode/word/around-holmes-english | 27 | 19920.75 ± 0.3% | not timed | not timed | 19722.23 ± 0.5% | 22.29 ± 1.4% | not timed | not timed | 19925.70 ± 0.3% | | 1.00 | 1.01 | 893.62 |
| wild/bibleref/long | 874 | 564.70 ± 0.2% | not timed | not timed | 580.22 ± 0.1% | 6.82 ± 0.2% | not timed | not timed | 566.71 ± 0.1% | | 1.00 | 0.97 | 82.81 |
| wild/bibleref/short | 30 | 23.95 ± 3.3% | not timed | not timed | 30.98 ± 0.3% | 14.58 ± 9.5% | not timed | not timed | 24.57 ± 3.6% | | 0.97 | 0.77 | 1.64 |
| wild/bibleref/line | 874 | 399.18 ± 1.8% | not timed | not timed | 212.62 ± 0.0% | 9.18 ± 8.3% | not timed | not timed | 399.92 ± 0.1% | | 1.00 | 1.88 | 43.48 |
| wild/caddy/caddy | 6 | 419.85 ± 1.9% | not timed | not timed | 249.90 ± 0.1% | 68.69 ± 14.6% | not timed | not timed | 421.15 ± 0.7% | | 1.00 | 1.68 | 6.11 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.11 ± 0.7% | not timed | not timed | 350.61 ± 0.4% | 13.54 ± 0.2% | not timed | not timed | 1064.34 ± 0.4% | | 1.01 | 3.05 | 79.02 |
| wild/ruff/noqa | 84 | 439.05 ± 0.2% | not timed | not timed | 460.96 ± 0.3% | 19.66 ± 1.7% | not timed | not timed | 438.66 ± 0.1% | | 1.00 | 0.95 | 22.33 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.60 ± 0.5% | not timed | not timed | 700.09 ± 0.2% | 136.65 ± 11.6% | not timed | not timed | 959.46 ± 0.4% | | 1.00 | 1.37 | 7.01 |
| wild/ruff/string-quote-prefix | 2972 | 1362.04 ± 0.7% | not timed | not timed | 406.51 ± 0.1% | 373.71 ± 29.8% | not timed | not timed | 1364.72 ± 0.8% | | 1.00 | 3.35 | 3.64 |
| wild/ruff/space-around-operator | 1224378 | 223.04 ± 1.8% | not timed | not timed | 185.29 ± 0.3% | 18.32 ± 1.8% | not timed | not timed | 223.88 ± 1.8% | | 1.00 | 1.20 | 12.18 |
| wild/ruff/shebang | 282 | 972.78 ± 0.5% | not timed | not timed | 328.66 ± 0.1% | 117.95 ± 9.5% | not timed | not timed | 977.82 ± 0.4% | | 0.99 | 2.96 | 8.25 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13822.05 ± 0.2% | not timed | not timed | 13899.18 ± 0.4% | 6930.64 ± 1.1% | not timed | not timed | 13823.71 ± 0.3% | | 1.00 | 0.99 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12814.85 ± 1.0% | not timed | not timed | 13482.69 ± 1.1% | 6414.63 ± 1.1% | not timed | not timed | 12846.55 ± 0.5% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13211.50 ± 0.3% | not timed | not timed | 13676.08 ± 0.4% | 6620.14 ± 0.6% | not timed | not timed | 13226.78 ± 0.3% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9552.90 ± 0.2% | not timed | not timed | 13545.74 ± 0.7% | 6715.91 ± 0.8% | not timed | not timed | 9573.14 ± 0.2% | | 1.00 | 0.71 | 1.42 |
| wild/url/search | 234965 | 121.70 ± 14.3% | not timed | not timed | 65.76 ± 0.5% | 2.21 ± 0.8% | not timed | not timed | 120.09 ± 14.1% | | 1.01 | 1.85 | 55.01 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.6% | not timed | not timed | 0.01 ± 0.7% | 0.01 ± 15.4% | not timed | not timed | 0.03 ± 1.5% | | 1.00 | 3.13 | 4.27 |
| dictionary/compile/english-15 | 1 | 0.35 ± 37.8% | not timed | not timed | 0.07 ± 1.0% | 0.10 ± 23.5% | not timed | not timed | 0.35 ± 1.6% | | 1.00 | 5.01 | 3.41 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 5.9% | not timed | not timed | 0.02 ± 0.6% | 36.54 ± 8.0% | not timed | not timed | 0.25 ± 5.6% | | 0.96 | 12.66 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.68 ± 5.1% | not timed | not timed | 11.59 ± 0.3% | 62.49 ± 21.5% | not timed | not timed | 47.90 ± 2.2% | | 1.00 | 4.12 | 0.76 |
| reported/i787-keywords/compile | 1 | 35.52 ± 4.8% | not timed | not timed | 2.13 ± 0.7% | 17.61 ± 43.5% | not timed | not timed | 35.54 ± 3.6% | | 1.00 | 16.70 | 2.02 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 360.63 ± 3.3% | not timed | not timed | 128.27 ± 0.4% | 568.87 ± 24.2% | not timed | not timed | 365.31 ± 1.3% | | 0.99 | 2.81 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.91 ± 1.8% | not timed | not timed | 4.12 ± 0.5% | 43.39 ± 11.9% | not timed | not timed | 48.55 ± 3.4% | | 0.99 | 11.62 | 1.10 |
| unicode/compile/one-letter | 53 | 6.74 ± 14.0% | not timed | not timed | 4.59 ± 0.6% | 66.27 ± 2.2% | not timed | not timed | 6.80 ± 14.5% | | 0.99 | 1.47 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.10 ± 4.2% | not timed | not timed | 0.10 ± 0.5% | 66.24 ± 18.5% | not timed | not timed | 1.11 ± 16.5% | | 0.99 | 11.00 | 0.0166 |
| unicode/compile/fifty-letters-ascii | 1 | 222.53 ± 12.2% | not timed | not timed | 52.64 ± 0.2% | 194.38 ± 7.8% | not timed | not timed | 224.18 ± 9.3% | | 0.99 | 4.23 | 1.14 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 382.19 ± 26.3% | not timed | not timed | 46.71 ± 0.7% | 666.34 ± 8.9% | not timed | not timed | 387.50 ± 25.2% | | 0.99 | 8.18 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 593.81 ± 12.6% | not timed | not timed | 146.33 ± 0.3% | 676.25 ± 28.1% | not timed | not timed | 615.37 ± 1.3% | | 0.96 | 4.06 | 0.88 |
| unicode/compile/negated-class-matches-codepoint | 1 | 327.14 ± 13.6% | not timed | not timed | 51.29 ± 0.7% | 1278.59 ± 27.1% | not timed | not timed | 332.67 ± 3.1% | | 0.98 | 6.38 | 0.26 |
| wild/bibleref/compile | 3 | 5.80 ± 7.9% | not timed | not timed | 1.94 ± 0.8% | 32.94 ± 13.1% | not timed | not timed | 5.96 ± 20.9% | | 0.97 | 2.99 | 0.18 |
| wild/url/compile | 1 | 0.57 ± 15.8% | not timed | not timed | 0.15 ± 0.7% | 0.46 ± 7.6% | not timed | not timed | 0.66 ± 19.0% | | 0.86 | 3.89 | 1.24 |

