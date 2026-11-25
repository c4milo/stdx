# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507041020 |
| Date | 2026-11-24 |
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
| literal: a word | 217 | 19319.76 ± 2.0% | 5082.64 ± 0.3% | 28.30 ± 0.3% | 18353.10 ± 1.0% | 9184.08 ± 5.3% | 17.57 ± 0.2% | 86.08 ± 0.3% | 19516.16 ± 1.7% | 3.80 | 0.99 | 1.05 | 2.10 |
| literal: a word that is not there | 0 | 21581.82 ± 2.0% | 4943.95 ± 0.3% | 28.19 ± 0.6% | 19832.58 ± 2.8% | 29008.36 ± 0.9% | 17.42 ± 0.1% | 81.88 ± 0.3% | 21593.60 ± 4.6% | 4.37 | 1.00 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6432.45 ± 0.3% | 1975.76 ± 0.2% | 14.41 ± 0.2% | 3946.23 ± 0.1% | 21.88 ± 0.0% | 5.31 ± 0.2% | 6.74 ± 0.1% | 6437.77 ± 0.3% | 3.26 | 1.00 | 1.63 | 293.95 |
| literal: a word in any case | 217 | 15153.85 ± 0.4% | 2103.85 ± 0.2% | 21.48 ± 0.2% | 3970.12 ± 0.3% | 38.05 ± 0.2% | refused | differs | 15169.88 ± 1.1% | 7.20 | 1.00 | 3.82 | 398.25 |
| literal: an href attribute | 33 | 16744.77 ± 1.2% | 617.89 ± 0.1% | 26.72 ± 0.3% | 16977.83 ± 1.3% | 2263.24 ± 7.2% | 13.43 ± 0.3% | 75.31 ± 0.2% | 16877.99 ± 1.4% | 27.10 | 0.99 | 0.99 | 7.40 |
| literal: a word, second text | 123 | 19726.77 ± 1.9% | 3426.46 ± 0.1% | 27.94 ± 0.3% | 18409.70 ± 2.6% | 7669.01 ± 2.3% | 19.61 ± 0.5% | 68.93 ± 0.1% | 19581.56 ± 0.9% | 5.76 | 1.01 | 1.07 | 2.57 |
| class: two capitalized words | 1331 | 1064.56 ± 0.5% | 609.61 ± 0.1% | 26.00 ± 0.2% | 585.16 ± 0.1% | 40.63 ± 2.7% | 14.99 ± 0.2% | 68.10 ± 0.4% | 1065.82 ± 0.5% | 1.75 | 1.00 | 1.82 | 26.20 |
| class: a word that ends in ing | 3399 | 583.02 ± 0.1% | 582.98 ± 0.3% | 17.99 ± 0.2% | 547.88 ± 0.1% | 29.67 ± 9.3% | 8.25 ± 0.2% | 18.26 ± 0.2% | 583.36 ± 0.4% | 1.00 | 1.00 | 1.06 | 19.65 |
| class: a word in capitals | 2332 | 1390.78 ± 0.4% | 614.41 ± 0.1% | 27.60 ± 0.2% | 572.35 ± 0.1% | 43.73 ± 0.3% | 17.27 ± 0.3% | 82.92 ± 0.4% | 1389.80 ± 0.2% | 2.26 | 1.00 | 2.43 | 31.80 |
| class: a number | 8288 | 2130.34 ± 0.7% | 852.98 ± 0.1% | 27.88 ± 0.6% | 1708.46 ± 0.1% | 40.98 ± 15.7% | 0.57 ± 0.1% | 56.88 ± 0.2% | 2133.63 ± 0.2% | 2.50 | 1.00 | 1.25 | 51.99 |
| class: two capitalized words, second text | 5359 | 525.87 ± 0.1% | 534.76 ± 0.1% | 23.34 ± 0.2% | 484.37 ± 0.1% | 33.63 ± 12.6% | 16.70 ± 0.1% | 63.48 ± 0.2% | 525.89 ± 0.1% | 0.98 | 1.00 | 1.09 | 15.64 |
| other: a word between two words | 6104 | 801.11 ± 0.1% | 609.55 ± 0.7% | 23.54 ± 0.3% | 737.93 ± 0.3% | 109.20 ± 12.7% | 11.33 ± 0.1% | 69.29 ± 0.7% | 809.13 ± 0.1% | 1.31 | 0.99 | 1.09 | 7.34 |
| other: a number before a unit, second text | 1481 | 6180.24 ± 0.4% | 1132.94 ± 0.3% | 25.97 ± 0.2% | 5642.11 ± 0.4% | 40.82 ± 11.5% | 17.82 ± 0.3% | 66.77 ± 0.3% | 6171.14 ± 1.1% | 5.46 | 1.00 | 1.10 | 151.41 |
| other: a heading's start tag | 110 | 14102.65 ± 0.4% | 750.70 ± 0.1% | 27.41 ± 0.1% | 1709.73 ± 0.3% | 1590.39 ± 6.4% | 16.37 ± 0.3% | 88.61 ± 0.3% | 14082.90 ± 1.1% | 18.79 | 1.00 | 8.25 | 8.87 |
| other: a whole word | 217 | 16110.29 ± 0.7% | 608.97 ± 0.1% | 29.37 ± 0.3% | 14563.04 ± 0.9% | 48.11 ± 0.2% | 13.78 ± 0.1% | 55.45 ± 0.2% | 16374.27 ± 1.9% | 26.46 | 0.98 | 1.11 | 334.84 |
| other: a line's first word, second text | 3716 | 2101.16 ± 0.3% | 600.42 ± 0.1% | 31.05 ± 0.2% | 1724.71 ± 0.5% | 62.29 ± 6.8% | refused | refused | 2103.88 ± 0.5% | 3.50 | 1.00 | 1.22 | 33.73 |
| other: fourteen octets before an x | 87 | 23716.28 ± 1.1% | 229.92 ± 0.7% | 6.55 ± 0.1% | 3981.44 ± 0.8% | 10.65 ± 0.2% | differs | 17.48 ± 0.3% | 23803.11 ± 7.6% | 103.15 | 1.00 | 5.96 | 2227.10 |
| other: a Greek word | 21815 | 520.53 ± 0.5% | 424.56 ± 0.2% | 30.80 ± 0.1% | 289.71 ± 0.2% | 47.64 ± 10.7% | differs | refused | 523.84 ± 0.5% | 1.23 | 0.99 | 1.80 | 10.93 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.29 ± 0.2% | 29.16 ± 0.2% | 0.86 ± 0.3% | 19.72 ± 0.2% | 2.78 ± 0.9% | differs | 4.01 ± 0.5% | 29.27 ± 0.2% | 1.00 | 1.00 | 1.49 | 10.55 |
| a UUID | 32895 | 24.70 ± 0.3% | 24.67 ± 0.2% | 0.64 ± 0.1% | 15.13 ± 0.4% | 2.99 ± 0.5% | 0.72 ± 0.3% | 3.60 ± 0.5% | 24.73 ± 0.2% | 1.00 | 1.00 | 1.63 | 8.27 |
| an IPv4 address | 33176 | 38.44 ± 0.1% | 38.43 ± 0.2% | 2.07 ± 0.3% | 28.94 ± 0.7% | 6.64 ± 0.2% | differs | 4.14 ± 0.6% | 38.45 ± 0.2% | 1.00 | 1.00 | 1.33 | 5.79 |
| a date and time | 32954 | 34.40 ± 0.2% | 34.13 ± 0.1% | 1.45 ± 0.1% | 21.09 ± 0.4% | 7.06 ± 0.2% | 1.20 ± 0.3% | 7.04 ± 0.2% | 34.37 ± 0.3% | 1.01 | 1.00 | 1.63 | 4.87 |
| a field path | 32606 | 32.58 ± 0.3% | 32.57 ± 0.7% | 1.01 ± 0.4% | 22.99 ± 0.2% | 3.51 ± 1.0% | differs | 2.92 ± 0.2% | 32.60 ± 0.2% | 1.00 | 1.00 | 1.42 | 9.29 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.3% | 11.05 ± 0.1% | 11.12 ± 0.1% | 11.47 ± 0.1% | 4.94 ± 2.7% | 0.91 ± 0.3% | none | 11.08 ± 0.1% | 1.01 | 1.00 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.99 ± 0.3% | 223.03 ± 0.2% | 260.70 ± 0.3% | 86.34 ± 0.4% | 221.68 ± 3.0% | 474.12 ± 1.3% | 3727.88 ± 1.5% | 222.97 ± 0.2% | 1.00 | 1.00 | 2.58 | 1.01 |
| a UUID | 62 | 144.42 ± 0.4% | 144.34 ± 0.3% | 159.93 ± 0.3% | 46.12 ± 1.2% | 99.17 ± 2.2% | 187.83 ± 2.3% | 4449.41 ± 1.0% | 144.51 ± 0.3% | 1.00 | 1.00 | 3.13 | 1.46 |
| an IPv4 address | 29 | 420.85 ± 0.7% | 421.19 ± 0.5% | 584.25 ± 0.2% | 77.75 ± 0.8% | 131.26 ± 1.6% | 293.16 ± 0.8% | 7572.18 ± 0.5% | 420.85 ± 0.2% | 1.00 | 1.00 | 5.41 | 3.21 |
| a date and time | 56 | 302.47 ± 0.3% | 302.69 ± 0.2% | 377.08 ± 0.2% | 72.75 ± 0.1% | 137.72 ± 1.7% | 323.87 ± 2.6% | 4927.63 ± 0.5% | 302.33 ± 0.1% | 1.00 | 1.00 | 4.16 | 2.20 |
| a field path | 39 | 213.80 ± 0.3% | 214.02 ± 0.2% | 248.64 ± 0.2% | 79.80 ± 2.2% | 207.56 ± 2.1% | 508.76 ± 4.5% | 4824.99 ± 0.6% | 213.87 ± 0.2% | 1.00 | 1.00 | 2.68 | 1.03 |
| literal: a word | 7 | 618.23 ± 1.0% | 671.37 ± 0.4% | 1187.56 ± 0.9% | 505.36 ± 0.2% | 628.14 ± 1.7% | 954.86 ± 0.5% | 29677.55 ± 0.0% | 620.05 ± 0.7% | 0.92 | 1.00 | 1.22 | 0.98 |
| literal: a word that is not there | 8 | 595.51 ± 0.2% | 654.73 ± 0.6% | 1114.71 ± 0.6% | 461.53 ± 0.4% | 603.95 ± 2.1% | 900.15 ± 0.6% | 28578.24 ± 0.2% | 596.14 ± 0.3% | 0.91 | 1.00 | 1.29 | 0.99 |
| literal: one of four words | 26 | 246.35 ± 0.2% | 396.42 ± 0.4% | 533.50 ± 0.2% | 49.67 ± 0.8% | 237.06 ± 10.4% | 363.34 ± 0.3% | 15432.36 ± 0.2% | 246.56 ± 0.2% | 0.62 | 1.00 | 4.96 | 1.04 |
| literal: a word in any case | 11 | 448.26 ± 0.2% | 479.49 ± 0.2% | 703.01 ± 0.1% | 15.58 ± 0.3% | 653.64 ± 2.7% | refused | 23261.42 ± 0.3% | 448.25 ± 0.3% | 0.93 | 1.00 | 28.78 | 0.69 |
| literal: an href attribute | 12 | 336.77 ± 0.6% | 347.69 ± 0.2% | 451.46 ± 0.4% | 44.68 ± 0.4% | 494.53 ± 1.4% | 773.27 ± 0.6% | 21505.15 ± 0.5% | 335.82 ± 0.3% | 0.97 | 1.00 | 7.54 | 0.68 |
| literal: a word, second text | 10 | 553.91 ± 0.4% | 615.91 ± 0.3% | 1013.07 ± 0.9% | 420.15 ± 1.9% | 539.29 ± 1.8% | 789.15 ± 0.4% | 26354.80 ± 0.2% | 553.51 ± 0.5% | 0.90 | 1.00 | 1.32 | 1.03 |
| class: two capitalized words | 23 | 436.95 ± 0.3% | 464.59 ± 0.4% | 662.27 ± 0.3% | 100.75 ± 0.4% | 502.21 ± 1.1% | 734.82 ± 0.4% | 6333.69 ± 0.1% | 436.00 ± 0.3% | 0.94 | 1.00 | 4.34 | 0.87 |
| class: a word that ends in ing | 9 | 549.73 ± 0.2% | 618.57 ± 0.2% | 1061.88 ± 0.1% | 133.86 ± 1.2% | 758.03 ± 2.5% | 1127.32 ± 0.6% | 15687.74 ± 0.1% | 549.60 ± 0.3% | 0.89 | 1.00 | 4.11 | 0.73 |
| class: a word in capitals | 16 | 492.90 ± 0.2% | 528.70 ± 0.2% | 831.23 ± 0.2% | 137.57 ± 1.1% | 752.01 ± 0.7% | 1048.40 ± 0.5% | 8322.00 ± 0.4% | 492.13 ± 0.3% | 0.93 | 1.00 | 3.58 | 0.66 |
| class: a number | 6 | 628.11 ± 0.4% | 687.26 ± 0.2% | 1263.53 ± 0.1% | 41.98 ± 0.8% | 1404.59 ± 1.2% | 1861.16 ± 1.0% | 22443.33 ± 0.1% | 627.17 ± 0.3% | 0.91 | 1.00 | 14.96 | 0.45 |
| class: two capitalized words, second text | 23 | 436.48 ± 0.3% | 464.19 ± 0.8% | 664.20 ± 0.5% | 100.55 ± 0.6% | 503.52 ± 0.7% | 734.38 ± 0.7% | 6333.07 ± 0.1% | 435.87 ± 0.2% | 0.94 | 1.00 | 4.34 | 0.87 |
| other: a word between two words | 13 | 532.45 ± 0.2% | 554.69 ± 0.4% | 870.39 ± 0.1% | 133.08 ± 0.3% | 500.36 ± 3.0% | 801.52 ± 1.3% | 14545.20 ± 0.1% | 532.71 ± 0.3% | 0.96 | 1.00 | 4.00 | 1.06 |
| other: a number before a unit, second text | 15 | 385.30 ± 0.1% | 425.29 ± 0.1% | 588.31 ± 0.1% | 39.56 ± 1.2% | 631.81 ± 1.1% | 894.94 ± 1.2% | 15090.86 ± 0.2% | 385.03 ± 0.1% | 0.91 | 1.00 | 9.74 | 0.61 |
| other: a heading's start tag | 13 | 346.74 ± 0.4% | 354.01 ± 0.4% | 461.38 ± 0.2% | 44.64 ± 0.2% | 630.78 ± 2.2% | 856.78 ± 0.3% | 17844.90 ± 0.1% | 346.60 ± 0.5% | 0.98 | 1.00 | 7.77 | 0.55 |
| other: a whole word | 11 | 572.85 ± 0.6% | 615.66 ± 0.5% | 1012.90 ± 0.6% | 120.47 ± 1.3% | 561.17 ± 2.6% | 826.94 ± 0.5% | 26236.73 ± 0.4% | 573.37 ± 0.2% | 0.93 | 1.00 | 4.76 | 1.02 |
| other: a line's first word, second text | 17 | 518.03 ± 0.7% | 547.23 ± 0.2% | 867.16 ± 0.6% | 129.03 ± 0.2% | 710.96 ± 0.4% | refused | refused | 518.14 ± 0.4% | 0.95 | 1.00 | 4.01 | 0.73 |
| other: fourteen octets before an x | 16 | 107.60 ± 0.4% | 153.99 ± 0.9% | 175.38 ± 0.8% | 15.04 ± 0.4% | 450.71 ± 2.9% | 407.82 ± 1.5% | 12615.13 ± 0.1% | 107.77 ± 0.5% | 0.70 | 1.00 | 7.15 | 0.24 |
| other: a Greek word | 8 | 444.16 ± 0.3% | 579.03 ± 0.1% | 948.68 ± 0.2% | 59.16 ± 1.7% | 1393.18 ± 1.6% | 1817.25 ± 0.5% | refused | 443.78 ± 0.1% | 0.77 | 1.00 | 7.51 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15686.01 ± 0.8% | not timed | not timed | 16115.46 ± 1.8% | 2078.87 ± 9.2% | not timed | not timed | 15599.09 ± 0.6% | | 1.01 | 0.97 | 7.55 |
| 01-literal/sherlock-casei-en | 522 | 11014.85 ± 7.0% | not timed | not timed | 3589.65 ± 0.2% | 32.58 ± 14.6% | not timed | not timed | 11069.08 ± 4.6% | | 1.00 | 3.07 | 338.13 |
| 01-literal/sherlock-ru | 724 | 17174.61 ± 0.3% | not timed | not timed | 17271.31 ± 1.5% | 1601.28 ± 12.5% | not timed | not timed | 17176.35 ± 0.1% | | 1.00 | 0.99 | 10.73 |
| 01-literal/sherlock-casei-ru | 746 | 6153.48 ± 0.3% | not timed | not timed | 3329.92 ± 0.1% | 31.80 ± 4.0% | not timed | not timed | 6140.42 ± 0.3% | | 1.00 | 1.85 | 193.49 |
| 01-literal/sherlock-zh | 30 | 19973.96 ± 0.6% | not timed | not timed | 18876.95 ± 0.8% | 2900.19 ± 22.6% | not timed | not timed | 19950.72 ± 0.5% | | 1.00 | 1.06 | 6.89 |
| 02-literal-alternate/sherlock-en | 714 | 6112.54 ± 0.6% | not timed | not timed | 3934.03 ± 0.4% | 16.63 ± 0.3% | not timed | not timed | 6131.80 ± 0.4% | | 1.00 | 1.55 | 367.67 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1970.39 ± 1.1% | not timed | not timed | 697.70 ± 0.3% | 11.02 ± 0.1% | not timed | not timed | 1974.09 ± 0.8% | | 1.00 | 2.82 | 178.88 |
| 02-literal-alternate/sherlock-ru | 899 | 5538.48 ± 0.1% | not timed | not timed | 3252.24 ± 0.2% | 22.64 ± 0.1% | not timed | not timed | 5529.93 ± 0.2% | | 1.00 | 1.70 | 244.60 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.80 ± 0.5% | not timed | not timed | 1226.53 ± 0.1% | 9.14 ± 0.2% | not timed | not timed | 2056.89 ± 0.4% | | 1.00 | 1.68 | 225.02 |
| 02-literal-alternate/sherlock-zh | 207 | 7317.07 ± 0.4% | not timed | not timed | 4163.90 ± 0.1% | 31.48 ± 0.1% | not timed | not timed | 7328.95 ± 0.6% | | 1.00 | 1.76 | 232.42 |
| 03-date/ascii | 111817 | 133.58 ± 0.6% | not timed | not timed | 95.53 ± 0.1% | 0.20 ± 4.8% | not timed | not timed | 134.56 ± 0.6% | | 0.99 | 1.40 | 671.25 |
| 04-ruff-noqa/real | 84 | 436.08 ± 0.1% | not timed | not timed | 458.25 ± 0.0% | 19.55 ± 1.4% | not timed | not timed | 435.98 ± 0.0% | | 1.00 | 0.95 | 22.31 |
| 04-ruff-noqa/tweaked | 44 | 594.10 ± 0.1% | not timed | not timed | 462.13 ± 0.1% | 365.02 ± 0.2% | not timed | not timed | 595.19 ± 0.4% | | 1.00 | 1.29 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 8.8% | not timed | not timed | 5.00 ± 0.2% | 0.21 ± 5.0% | not timed | not timed | 5.52 ± 4.0% | | 0.97 | 1.07 | 25.90 |
| 06-cloud-flare-redos/original | 107 | 426.63 ± 0.1% | not timed | not timed | 214.26 ± 0.1% | 24.94 ± 0.5% | not timed | not timed | 432.22 ± 0.1% | | 0.99 | 1.99 | 17.11 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.75 ± 0.2% | not timed | not timed | 198.95 ± 1.8% | 26.67 ± 0.2% | not timed | not timed | 431.13 ± 0.1% | | 1.00 | 2.17 | 16.19 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.60 ± 0.1% | not timed | not timed | 254.87 ± 0.2% | 28.83 ± 0.1% | not timed | not timed | 588.65 ± 0.1% | | 1.00 | 2.31 | 20.42 |
| 07-unicode-character-data/parse-line | 558784 | 233.39 ± 2.2% | not timed | not timed | 171.57 ± 1.6% | 42.62 ± 4.2% | not timed | not timed | 233.26 ± 2.6% | | 1.00 | 1.36 | 5.48 |
| 08-words/all-english | 56691 | 127.73 ± 0.8% | not timed | not timed | 83.08 ± 0.2% | 12.80 ± 11.4% | not timed | not timed | 127.75 ± 0.7% | | 1.00 | 1.54 | 9.98 |
| 08-words/long-english | 839 | 623.35 ± 0.2% | not timed | not timed | 596.47 ± 0.0% | 32.31 ± 0.2% | not timed | not timed | 623.92 ± 0.2% | | 1.00 | 1.05 | 19.29 |
| 09-aws-keys/full | 0 | 440.76 ± 0.2% | not timed | not timed | 464.80 ± 0.1% | 64.63 ± 3.5% | not timed | not timed | 439.58 ± 0.1% | | 1.00 | 0.95 | 6.82 |
| 09-aws-keys/quick | 0 | 874.43 ± 0.2% | not timed | not timed | 989.28 ± 0.0% | 420.33 ± 0.7% | not timed | not timed | 874.76 ± 0.2% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 581.00 ± 3.2% | not timed | not timed | 515.91 ± 0.2% | 19.55 ± 0.4% | not timed | not timed | 586.36 ± 2.4% | | 0.99 | 1.13 | 29.71 |
| 10-bounded-repeat/letters-ru | 3475 | 504.39 ± 1.4% | not timed | not timed | 477.17 ± 0.1% | 22.02 ± 15.4% | not timed | not timed | 506.55 ± 0.9% | | 1.00 | 1.06 | 22.90 |
| 10-bounded-repeat/context | 53 | 85.36 ± 1.8% | not timed | not timed | 65.89 ± 0.6% | 19.83 ± 0.2% | not timed | not timed | 85.43 ± 1.6% | | 1.00 | 1.30 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 631.66 ± 8.3% | not timed | not timed | 616.88 ± 0.1% | 36.58 ± 0.1% | not timed | not timed | 633.70 ± 8.3% | | 1.00 | 1.02 | 17.27 |
| 11-unstructured-to-json/extract | 600 | 57.22 ± 0.7% | not timed | not timed | 77.12 ± 0.6% | 49.05 ± 0.9% | not timed | not timed | 57.33 ± 1.5% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 561.14 ± 0.7% | not timed | not timed | 558.53 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 561.23 ± 1.3% | | 1.00 | 1.00 | 1404.78 |
| 14-quadratic/1x | 100 | 21.36 ± 1.0% | not timed | not timed | 10.03 ± 0.3% | 0.96 ± 2.6% | not timed | not timed | 21.43 ± 2.0% | | 1.00 | 2.13 | 22.16 |
| 14-quadratic/2x | 200 | 17.72 ± 0.8% | not timed | not timed | 5.56 ± 0.2% | 0.53 ± 1.8% | not timed | not timed | 17.85 ± 0.7% | | 0.99 | 3.19 | 33.15 |
| 14-quadratic/10x | 1000 | 7.77 ± 0.5% | not timed | not timed | 1.21 ± 0.6% | 0.12 ± 1.8% | not timed | not timed | 7.78 ± 0.4% | | 1.00 | 6.42 | 67.42 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 1.3% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 7.8% | not timed | not timed | 1.23 ± 0.6% | | 0.99 | 3.54 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 105.48 ± 1.0% | not timed | not timed | 13.69 ± 0.6% | 140.80 ± 8.2% | not timed | not timed | 106.54 ± 0.5% | | 0.99 | 7.71 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.03 ± 0.9% | not timed | not timed | 2.53 ± 0.3% | 6.46 ± 3.2% | not timed | not timed | 14.04 ± 0.3% | | 1.00 | 5.55 | 2.17 |
| 07-unicode-character-data/compile | 1 | 108.03 ± 1.0% | not timed | not timed | 25.85 ± 0.2% | 36.07 ± 4.7% | not timed | not timed | 108.19 ± 0.2% | | 1.00 | 4.18 | 2.99 |
| 09-aws-keys/compile-full | 1 | 53.14 ± 1.6% | not timed | not timed | 8.24 ± 0.3% | 23.38 ± 0.9% | not timed | not timed | 53.17 ± 0.4% | | 1.00 | 6.45 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 186.87 ± 1.2% | not timed | not timed | 46.72 ± 0.3% | 136.49 ± 3.0% | not timed | not timed | 187.48 ± 0.3% | | 1.00 | 4.00 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 72.01 ± 1.8% | not timed | not timed | 11.18 ± 0.4% | 16.35 ± 5.7% | not timed | not timed | 72.08 ± 2.0% | | 1.00 | 6.44 | 4.41 |
| 10-bounded-repeat/compile-capitals | 1 | 85.08 ± 1.0% | not timed | not timed | 8.11 ± 0.2% | 23.90 ± 1.3% | not timed | not timed | 84.94 ± 1.1% | | 1.00 | 10.49 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 170.00 ± 1.3% | not timed | not timed | 40.59 ± 0.6% | 68.20 ± 5.5% | not timed | not timed | 170.89 ± 0.9% | | 0.99 | 4.19 | 2.49 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.6% | not timed | not timed | 0.07 ± 2.9% | 0.10 ± 18.8% | not timed | not timed | 0.35 ± 0.8% | | 1.00 | 4.99 | 3.64 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.34 ± 0.6% | not timed | not timed | 6.47 ± 0.2% | 0.56 ± 6.0% | not timed | not timed | 7.35 ± 2.0% | | 1.00 | 1.13 | 13.14 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.5% | not timed | not timed | 164.78 ± 1.0% | 0.00 ± 0.2% | not timed | not timed | 1.16 ± 0.6% | | 1.00 | 0.0071 | 390.61 |
| dictionary/search/english-15 | 15 | 566.67 ± 0.9% | not timed | not timed | 560.87 ± 0.1% | 0.37 ± 0.5% | not timed | not timed | 567.43 ± 0.9% | | 1.00 | 1.01 | 1525.77 |
| folly/awyer-inn-busted | 1 | 5593.46 ± 0.0% | not timed | not timed | 141.50 ± 0.2% | 44.04 ± 0.1% | not timed | not timed | 5613.67 ± 0.2% | | 1.00 | 39.53 | 127.00 |
| folly/literal-never-match-rare | 0 | 21035.48 ± 0.3% | not timed | not timed | 19959.43 ± 0.4% | 40967.59 ± 0.5% | not timed | not timed | 21099.05 ± 0.6% | | 1.00 | 1.05 | 0.51 |
| folly/literal-never-match-frequent | 0 | 12480.92 ± 1.5% | not timed | not timed | 19905.36 ± 0.2% | 2196.20 ± 1.1% | not timed | not timed | 12532.55 ± 1.4% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3243.04 ± 0.2% | not timed | not timed | 4341.79 ± 1.7% | 3056.00 ± 0.0% | not timed | not timed | 3244.86 ± 0.2% | | 1.00 | 0.75 | 1.06 |
| grep/every-line | 239963 | 1318.13 ± 0.7% | not timed | not timed | 947.14 ± 0.4% | 362.00 ± 19.8% | not timed | not timed | 1324.66 ± 0.4% | | 1.00 | 1.39 | 3.64 |
| grep/long-words-ascii | 5073 | 459.17 ± 0.1% | not timed | not timed | 469.24 ± 0.1% | 46.23 ± 7.5% | not timed | not timed | 403.50 ± 0.6% | | 1.14 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20757.27 ± 1.1% | not timed | not timed | 19602.83 ± 0.5% | 11999.21 ± 10.2% | not timed | not timed | 20733.17 ± 0.9% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9087.13 ± 1.6% | not timed | not timed | 4251.44 ± 0.1% | 37.41 ± 0.8% | not timed | not timed | 9092.40 ± 2.6% | | 1.00 | 2.14 | 242.88 |
| imported/leipzig/shing | 1540 | 15279.47 ± 1.8% | not timed | not timed | 13526.69 ± 0.7% | 33.63 ± 0.1% | not timed | not timed | 15489.16 ± 1.8% | | 0.99 | 1.13 | 454.31 |
| imported/leipzig/huck-saw | 262 | 8253.27 ± 2.6% | not timed | not timed | 5602.23 ± 0.2% | 31.61 ± 0.2% | not timed | not timed | 8436.71 ± 2.5% | | 0.98 | 1.47 | 261.07 |
| imported/leipzig/word-ending-nn | 262 | 605.36 ± 1.0% | not timed | not timed | 615.64 ± 0.5% | 24.82 ± 0.2% | not timed | not timed | 604.09 ± 0.4% | | 1.00 | 0.98 | 24.39 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11152.44 ± 0.7% | not timed | not timed | 4541.79 ± 0.6% | 11.50 ± 0.1% | not timed | not timed | 11184.35 ± 0.8% | | 1.00 | 2.46 | 969.40 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7833.24 ± 1.3% | not timed | not timed | 5485.39 ± 0.3% | 16.86 ± 0.0% | not timed | not timed | 7846.37 ± 2.3% | | 1.00 | 1.43 | 464.70 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4169.22 ± 1.9% | not timed | not timed | 413.53 ± 0.7% | 11.12 ± 0.1% | not timed | not timed | 4180.12 ± 0.7% | | 1.00 | 10.08 | 374.89 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 603.94 ± 0.5% | not timed | not timed | 615.40 ± 0.1% | 11.15 ± 0.2% | not timed | not timed | 602.72 ± 0.4% | | 1.00 | 0.98 | 54.16 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 602.79 ± 0.3% | not timed | not timed | 616.03 ± 0.1% | 9.74 ± 0.0% | not timed | not timed | 600.73 ± 0.5% | | 1.00 | 0.98 | 61.88 |
| imported/leipzig/tom-river | 2 | 6478.96 ± 1.4% | not timed | not timed | 5138.09 ± 0.7% | 30.92 ± 0.0% | not timed | not timed | 6553.14 ± 3.5% | | 0.99 | 1.26 | 209.57 |
| imported/leipzig/ing | 78424 | 601.40 ± 0.8% | not timed | not timed | 570.76 ± 0.1% | 28.27 ± 3.3% | not timed | not timed | 600.32 ± 1.1% | | 1.00 | 1.05 | 21.28 |
| imported/leipzig/ing-whitespace | 55248 | 750.78 ± 0.8% | not timed | not timed | 2070.19 ± 0.8% | 20.58 ± 2.8% | not timed | not timed | 752.68 ± 0.2% | | 1.00 | 0.36 | 36.48 |
| imported/leipzig/awyer-inn | 209 | 767.86 ± 1.5% | not timed | not timed | 4271.63 ± 0.9% | 22.59 ± 0.0% | not timed | not timed | 767.71 ± 1.4% | | 1.00 | 0.18 | 33.98 |
| imported/leipzig/quotes-bounded | 8886 | 2114.20 ± 0.5% | not timed | not timed | 3006.57 ± 2.2% | 38.28 ± 0.2% | not timed | not timed | 2122.47 ± 0.6% | | 1.00 | 0.70 | 55.23 |
| imported/leipzig/non-ascii-alternate | 2 | 12883.95 ± 2.5% | not timed | not timed | 5669.57 ± 0.7% | 50.66 ± 0.1% | not timed | not timed | 13017.07 ± 1.9% | | 0.99 | 2.27 | 254.31 |
| imported/leipzig/math-symbols | 69 | 1979.65 ± 0.8% | not timed | not timed | 619.32 ± 0.1% | 36.41 ± 0.2% | not timed | not timed | 1983.18 ± 0.8% | | 1.00 | 3.20 | 54.37 |
| imported/leipzig/bounded-strings-ending-z | 0 | 587.47 ± 1.5% | not timed | not timed | 616.52 ± 0.1% | 22.48 ± 0.5% | not timed | not timed | 587.43 ± 1.6% | | 1.00 | 0.95 | 26.13 |
| imported/lh3lh3-reb/uri | 17549 | 679.89 ± 0.1% | not timed | not timed | 1064.79 ± 0.1% | 28.35 ± 2.6% | not timed | not timed | 679.53 ± 0.1% | | 1.00 | 0.64 | 23.98 |
| imported/lh3lh3-reb/email | 15057 | 674.13 ± 0.1% | not timed | not timed | 1156.61 ± 0.2% | 31.07 ± 2.4% | not timed | not timed | 674.13 ± 0.0% | | 1.00 | 0.58 | 21.70 |
| imported/lh3lh3-reb/date | 668 | 860.55 ± 0.2% | not timed | not timed | 1020.60 ± 0.4% | 50.15 ± 3.8% | not timed | not timed | 860.65 ± 0.2% | | 1.00 | 0.84 | 17.16 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.12 ± 0.1% | not timed | not timed | 422.73 ± 0.1% | 15.78 ± 1.2% | not timed | not timed | 645.28 ± 0.4% | | 1.00 | 1.53 | 40.94 |
| imported/mariomka/email | 92 | 24357.60 ± 1.1% | not timed | not timed | 29464.78 ± 0.4% | 32.85 ± 0.1% | not timed | not timed | 24385.37 ± 1.5% | | 1.00 | 0.83 | 741.53 |
| imported/mariomka/uri | 5301 | 5317.75 ± 1.0% | not timed | not timed | 6101.45 ± 0.7% | 32.54 ± 0.9% | not timed | not timed | 5375.90 ± 1.3% | | 0.99 | 0.87 | 163.43 |
| imported/mariomka/ip | 5 | 2156.66 ± 2.1% | not timed | not timed | 2964.79 ± 0.2% | 21.06 ± 0.2% | not timed | not timed | 2157.28 ± 2.5% | | 1.00 | 0.73 | 102.40 |
| imported/rsc/no-exponential | 0 | 606.46 ± 0.2% | not timed | not timed | 320.73 ± 0.1% | 23.92 ± 0.1% | not timed | not timed | 602.36 ± 0.1% | | 1.01 | 1.89 | 25.35 |
| imported/rsc/literal | 1 | 759.26 ± 2.0% | not timed | not timed | 1544.43 ± 6.0% | 189.78 ± 18.1% | not timed | not timed | 758.28 ± 4.5% | | 1.00 | 0.49 | 4.00 |
| imported/rsc/not-literal | 2 | 781.81 ± 0.2% | not timed | not timed | 728.15 ± 1.1% | 46.31 ± 7.8% | not timed | not timed | 783.45 ± 2.1% | | 1.00 | 1.07 | 16.88 |
| imported/rsc/match-class | 1 | 1438.58 ± 2.1% | not timed | not timed | 1589.46 ± 0.3% | 58.75 ± 6.9% | not timed | not timed | 1441.66 ± 0.4% | | 1.00 | 0.91 | 24.48 |
| imported/rsc/match-class-in-range | 1 | 1446.49 ± 2.4% | not timed | not timed | 2328.27 ± 4.6% | 60.30 ± 6.2% | not timed | not timed | 1438.89 ± 0.3% | | 1.01 | 0.62 | 23.99 |
| imported/rsc/match-class-unicode | 1 | 548.00 ± 1.9% | not timed | not timed | 514.57 ± 0.1% | 72.57 ± 8.1% | not timed | not timed | 548.87 ± 0.2% | | 1.00 | 1.06 | 7.55 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1439.44 ± 0.2% | not timed | not timed | 942.33 ± 0.2% | 227.77 ± 0.9% | not timed | not timed | 1438.47 ± 0.3% | | 1.00 | 1.53 | 6.32 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21606.97 ± 0.2% | not timed | not timed | 14181.86 ± 0.1% | 3430.55 ± 0.4% | not timed | not timed | 21560.33 ± 0.1% | | 1.00 | 1.52 | 6.30 |
| imported/rsc/anchored-literal-short-match | 4 | 709.50 ± 2.0% | not timed | not timed | 490.12 ± 0.1% | 85.83 ± 7.2% | not timed | not timed | 708.12 ± 1.6% | | 1.00 | 1.45 | 8.27 |
| imported/rsc/anchored-literal-long-match | 4 | 10700.36 ± 1.4% | not timed | not timed | 7252.92 ± 0.2% | 1217.67 ± 7.7% | not timed | not timed | 10627.69 ± 2.0% | | 1.01 | 1.48 | 8.79 |
| imported/rsc/one-pass-short | 17 | 372.42 ± 1.2% | not timed | not timed | 214.24 ± 0.1% | 32.44 ± 11.9% | not timed | not timed | 370.53 ± 11.8% | | 1.01 | 1.74 | 11.48 |
| imported/rsc/one-pass-short-not | 17 | 281.09 ± 2.3% | not timed | not timed | 227.13 ± 0.1% | 29.50 ± 10.3% | not timed | not timed | 280.76 ± 2.7% | | 1.00 | 1.24 | 9.53 |
| imported/rsc/one-pass-long-prefix | 26 | 366.08 ± 8.3% | not timed | not timed | 281.73 ± 0.3% | 95.01 ± 13.9% | not timed | not timed | 368.00 ± 1.8% | | 0.99 | 1.30 | 3.85 |
| imported/rsc/one-pass-long-prefix-not | 26 | 363.36 ± 2.0% | not timed | not timed | 279.98 ± 0.1% | 61.74 ± 18.8% | not timed | not timed | 366.19 ± 2.3% | | 0.99 | 1.30 | 5.89 |
| imported/rsc/long-needle1 | 31 | 22227.25 ± 0.1% | not timed | not timed | 20190.58 ± 0.1% | 3.77 ± 0.1% | not timed | not timed | 22231.58 ± 0.1% | | 1.00 | 1.10 | 5890.65 |
| imported/rsc/long-needle2 | 31 | 22345.35 ± 0.3% | not timed | not timed | 216.33 ± 0.3% | 3.78 ± 0.0% | not timed | not timed | 22353.99 ± 0.1% | | 1.00 | 103.29 | 5918.38 |
| imported/rsc/easy0-32 | 26 | 1068.54 ± 3.2% | not timed | not timed | 1628.16 ± 3.7% | 148.88 ± 17.9% | not timed | not timed | 1070.40 ± 0.3% | | 1.00 | 0.66 | 7.18 |
| imported/rsc/easy0-1k | 26 | 14963.81 ± 1.9% | not timed | not timed | 12716.21 ± 1.2% | 2301.09 ± 13.1% | not timed | not timed | 14951.45 ± 0.2% | | 1.00 | 1.18 | 6.50 |
| imported/rsc/easy0-32k | 26 | 23072.85 ± 0.2% | not timed | not timed | 20426.81 ± 0.1% | 18803.30 ± 0.4% | not timed | not timed | 23073.95 ± 0.0% | | 1.00 | 1.13 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 21695.23 ± 2.3% | not timed | not timed | 20014.42 ± 0.9% | 36769.43 ± 8.9% | not timed | not timed | 21802.26 ± 2.6% | | 1.00 | 1.08 | 0.59 |
| imported/rsc/easy1-32 | 19 | 805.62 ± 2.4% | not timed | not timed | 645.10 ± 0.1% | 131.81 ± 16.8% | not timed | not timed | 804.46 ± 7.5% | | 1.00 | 1.25 | 6.11 |
| imported/rsc/easy1-1k | 19 | 16453.65 ± 2.1% | not timed | not timed | 12850.00 ± 0.1% | 2500.99 ± 18.2% | not timed | not timed | 16460.40 ± 0.2% | | 1.00 | 1.28 | 6.58 |
| imported/rsc/easy1-32k | 19 | 516887.54 ± 0.3% | not timed | not timed | 401117.82 ± 0.1% | 20565.80 ± 0.2% | not timed | not timed | 517024.97 ± 0.3% | | 1.00 | 1.29 | 25.13 |
| imported/rsc/easy1-1mb | 19 | 16582945.38 ± 0.5% | not timed | not timed | 13125042.86 ± 0.2% | 39645.95 ± 2.4% | not timed | not timed | 16525999.70 ± 0.3% | | 1.00 | 1.26 | 418.28 |
| imported/rsc/medium-32 | 27 | 770.23 ± 2.4% | not timed | not timed | 629.39 ± 0.2% | 70.18 ± 12.0% | not timed | not timed | 775.39 ± 0.4% | | 0.99 | 1.22 | 10.98 |
| imported/rsc/medium-1k | 27 | 13705.28 ± 0.1% | not timed | not timed | 11318.14 ± 0.1% | 72.32 ± 0.1% | not timed | not timed | 13786.98 ± 0.4% | | 0.99 | 1.21 | 189.50 |
| imported/rsc/medium-32k | 27 | 427024.93 ± 0.6% | not timed | not timed | 350302.08 ± 0.0% | 48.55 ± 0.3% | not timed | not timed | 429863.16 ± 0.3% | | 0.99 | 1.22 | 8795.33 |
| imported/rsc/medium-1mb | 27 | 13665880.76 ± 0.8% | not timed | not timed | 11321592.98 ± 0.5% | 48.53 ± 0.1% | not timed | not timed | 13731754.83 ± 0.6% | | 1.00 | 1.21 | 281590.81 |
| imported/rsc/hard-32 | 58 | 422.28 ± 0.5% | not timed | not timed | 367.99 ± 0.0% | 49.52 ± 10.9% | not timed | not timed | 419.96 ± 0.2% | | 1.01 | 1.15 | 8.53 |
| imported/rsc/hard-1k | 27 | 13415.00 ± 0.3% | not timed | not timed | 11571.13 ± 0.7% | 40.72 ± 0.1% | not timed | not timed | 13453.19 ± 0.6% | | 1.00 | 1.16 | 329.42 |
| imported/rsc/hard-32k | 27 | 417640.54 ± 0.8% | not timed | not timed | 361325.16 ± 0.1% | 29.34 ± 0.1% | not timed | not timed | 419988.84 ± 0.3% | | 0.99 | 1.16 | 14235.42 |
| imported/rsc/hard-1mb | 51 | 8405909.65 ± 0.3% | not timed | not timed | 7221481.97 ± 0.2% | 29.38 ± 0.2% | not timed | not timed | 8359941.39 ± 0.1% | | 1.01 | 1.16 | 286112.65 |
| imported/rsc/reallyhard0-32 | 58 | 267.13 ± 2.4% | not timed | not timed | 225.37 ± 0.1% | 49.64 ± 8.6% | not timed | not timed | 267.24 ± 0.2% | | 1.00 | 1.19 | 5.38 |
| imported/rsc/reallyhard0-1k | 27 | 591.87 ± 0.2% | not timed | not timed | 581.47 ± 0.2% | 40.85 ± 0.1% | not timed | not timed | 590.42 ± 0.2% | | 1.00 | 1.02 | 14.49 |
| imported/rsc/reallyhard0-32k | 27 | 610.03 ± 0.4% | not timed | not timed | 617.37 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 611.08 ± 0.2% | | 1.00 | 0.99 | 20.78 |
| imported/rsc/reallyhard0-1mb | 51 | 591.33 ± 0.4% | not timed | not timed | 617.75 ± 0.5% | 29.35 ± 0.1% | not timed | not timed | 591.60 ± 0.6% | | 1.00 | 0.96 | 20.15 |
| imported/rsc/reallyreallyhard0-32 | 47 | 289.19 ± 1.8% | not timed | not timed | 197.18 ± 0.2% | 60.90 ± 10.6% | not timed | not timed | 289.03 ± 1.5% | | 1.00 | 1.47 | 4.75 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6770.12 ± 0.1% | not timed | not timed | 5924.41 ± 0.1% | 34.27 ± 5.0% | not timed | not timed | 6767.28 ± 0.1% | | 1.00 | 1.14 | 197.56 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21492.16 ± 0.1% | not timed | not timed | 19274.44 ± 0.1% | 24.90 ± 1.7% | not timed | not timed | 21499.16 ± 0.1% | | 1.00 | 1.12 | 863.22 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21776.12 ± 0.5% | not timed | not timed | 19792.91 ± 0.7% | 25.02 ± 2.4% | not timed | not timed | 21678.01 ± 0.7% | | 1.00 | 1.10 | 870.43 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.89 ± 1.4% | not timed | not timed | 214.68 ± 0.2% | 60.71 ± 18.0% | not timed | not timed | 282.92 ± 1.3% | | 1.00 | 1.32 | 4.66 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5890.51 ± 0.1% | not timed | not timed | 6256.02 ± 0.1% | 34.53 ± 0.3% | not timed | not timed | 5873.99 ± 0.1% | | 1.00 | 0.94 | 170.57 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21417.02 ± 0.1% | not timed | not timed | 19385.26 ± 0.1% | 25.13 ± 0.6% | not timed | not timed | 21424.26 ± 0.1% | | 1.00 | 1.10 | 852.40 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21535.42 ± 0.5% | not timed | not timed | 20038.28 ± 1.3% | 24.99 ± 1.0% | not timed | not timed | 21504.95 ± 0.7% | | 1.00 | 1.07 | 861.91 |
| imported/sherlock/name-sherlock | 776 | 19896.78 ± 3.8% | not timed | not timed | 18526.89 ± 0.6% | 10155.22 ± 27.5% | not timed | not timed | 19860.76 ± 2.0% | | 1.00 | 1.07 | 1.96 |
| imported/sherlock/name-holmes | 2766 | 15177.09 ± 1.3% | not timed | not timed | 15605.65 ± 0.8% | 3247.34 ± 15.2% | not timed | not timed | 15333.35 ± 1.4% | | 0.99 | 0.97 | 4.67 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19893.55 ± 1.7% | not timed | not timed | 18570.15 ± 0.6% | 8098.68 ± 48.0% | not timed | not timed | 19917.89 ± 2.4% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15725.59 ± 0.4% | not timed | not timed | 4014.60 ± 0.4% | 32.62 ± 0.2% | not timed | not timed | 15735.35 ± 0.2% | | 1.00 | 3.92 | 482.05 |
| imported/sherlock/name-holmes-casei | 2802 | 9403.50 ± 5.0% | not timed | not timed | 3309.37 ± 0.1% | 37.55 ± 5.3% | not timed | not timed | 9467.60 ± 4.0% | | 0.99 | 2.84 | 250.43 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13163.12 ± 3.9% | not timed | not timed | 3947.41 ± 0.1% | 32.56 ± 0.2% | not timed | not timed | 13169.36 ± 1.0% | | 1.00 | 3.33 | 404.24 |
| imported/sherlock/name-whitespace | 1461 | 15401.24 ± 1.7% | not timed | not timed | 14512.44 ± 0.3% | 7397.89 ± 23.5% | not timed | not timed | 15411.08 ± 1.5% | | 1.00 | 1.06 | 2.08 |
| imported/sherlock/name-alt1 | 1142 | 11625.37 ± 0.4% | not timed | not timed | 16477.45 ± 0.8% | 4105.19 ± 18.2% | not timed | not timed | 11585.38 ± 2.6% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8962.33 ± 0.3% | not timed | not timed | 3830.24 ± 0.1% | 31.24 ± 0.4% | not timed | not timed | 8972.96 ± 0.2% | | 1.00 | 2.34 | 286.91 |
| imported/sherlock/name-alt3 | 4507 | 5575.14 ± 0.5% | not timed | not timed | 3633.31 ± 0.1% | 9.94 ± 3.9% | not timed | not timed | 5578.63 ± 0.4% | | 1.00 | 1.53 | 560.67 |
| imported/sherlock/name-alt3-casei | 4593 | 1531.66 ± 2.4% | not timed | not timed | 285.54 ± 0.1% | 6.49 ± 0.1% | not timed | not timed | 1533.95 ± 0.9% | | 1.00 | 5.36 | 236.13 |
| imported/sherlock/name-alt4 | 3686 | 6409.81 ± 0.2% | not timed | not timed | 3790.00 ± 0.1% | 31.21 ± 0.2% | not timed | not timed | 6409.21 ± 0.2% | | 1.00 | 1.69 | 205.39 |
| imported/sherlock/name-alt4-casei | 4254 | 2812.18 ± 1.8% | not timed | not timed | 2577.64 ± 0.2% | 19.56 ± 0.1% | not timed | not timed | 2811.63 ± 0.9% | | 1.00 | 1.09 | 143.78 |
| imported/sherlock/name-alt5 | 4028 | 6444.07 ± 0.2% | not timed | not timed | 3752.85 ± 0.2% | 21.74 ± 0.1% | not timed | not timed | 6450.56 ± 0.3% | | 1.00 | 1.72 | 296.40 |
| imported/sherlock/name-alt5-casei | 4104 | 3522.53 ± 1.9% | not timed | not timed | 2235.19 ± 0.1% | 14.38 ± 0.2% | not timed | not timed | 3527.95 ± 1.0% | | 1.00 | 1.58 | 244.88 |
| imported/sherlock/no-match-uncommon | 0 | 21841.81 ± 0.4% | not timed | not timed | 19540.09 ± 0.6% | 36288.68 ± 0.5% | not timed | not timed | 21816.62 ± 0.4% | | 1.00 | 1.12 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21501.50 ± 0.4% | not timed | not timed | 19562.29 ± 0.6% | 1287.85 ± 1.2% | not timed | not timed | 21495.66 ± 0.3% | | 1.00 | 1.10 | 16.70 |
| imported/sherlock/no-match-really-common | 0 | 16006.23 ± 2.4% | not timed | not timed | 18763.39 ± 0.5% | 1286.64 ± 1.0% | not timed | not timed | 16126.83 ± 3.0% | | 0.99 | 0.85 | 12.44 |
| imported/sherlock/the-lower | 21654 | 2321.20 ± 1.3% | not timed | not timed | 2336.76 ± 0.4% | 241.22 ± 16.2% | not timed | not timed | 2330.14 ± 7.2% | | 1.00 | 0.99 | 9.62 |
| imported/sherlock/the-upper | 2223 | 12737.58 ± 1.4% | not timed | not timed | 13558.03 ± 1.8% | 2535.39 ± 21.5% | not timed | not timed | 12843.02 ± 1.2% | | 0.99 | 0.94 | 5.02 |
| imported/sherlock/the-casei | 23961 | 2013.18 ± 1.1% | not timed | not timed | 1318.87 ± 0.2% | 34.57 ± 37.6% | not timed | not timed | 2017.69 ± 0.3% | | 1.00 | 1.53 | 58.24 |
| imported/sherlock/everything-greedy | 581881 | 283.59 ± 7.8% | not timed | not timed | 166.22 ± 0.1% | 28.60 ± 20.4% | not timed | not timed | 283.73 ± 0.2% | | 1.00 | 1.71 | 9.92 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.91 ± 0.1% | not timed | not timed | 213.11 ± 0.4% | 33.05 ± 0.2% | not timed | not timed | 462.62 ± 0.1% | | 1.00 | 2.17 | 14.01 |
| imported/sherlock/letters | 447175 | 62.32 ± 0.6% | not timed | not timed | 32.86 ± 0.2% | 6.54 ± 3.9% | not timed | not timed | 62.52 ± 0.6% | | 1.00 | 1.90 | 9.53 |
| imported/sherlock/letters-upper | 14180 | 453.73 ± 1.2% | not timed | not timed | 372.02 ± 0.1% | 29.68 ± 21.8% | not timed | not timed | 453.06 ± 0.1% | | 1.00 | 1.22 | 15.29 |
| imported/sherlock/letters-lower | 432995 | 63.29 ± 1.0% | not timed | not timed | 33.75 ± 0.1% | 6.71 ± 41.8% | not timed | not timed | 63.61 ± 1.8% | | 1.00 | 1.87 | 9.44 |
| imported/sherlock/words | 447639 | 115.73 ± 0.8% | not timed | not timed | 81.39 ± 0.1% | 14.49 ± 29.9% | not timed | not timed | 115.94 ± 0.5% | | 1.00 | 1.42 | 7.99 |
| imported/sherlock/before-holmes | 4073 | 10335.51 ± 0.6% | not timed | not timed | 8458.37 ± 0.6% | 23.96 ± 1.4% | not timed | not timed | 10374.01 ± 0.4% | | 1.00 | 1.22 | 431.39 |
| imported/sherlock/before-after-holmes | 2593 | 9936.79 ± 0.8% | not timed | not timed | 9573.80 ± 0.2% | 23.84 ± 0.7% | not timed | not timed | 9938.11 ± 0.4% | | 1.00 | 1.04 | 416.86 |
| imported/sherlock/holmes-cochar-watson | 150 | 5203.77 ± 0.2% | not timed | not timed | 3434.84 ± 0.1% | 31.10 ± 0.2% | not timed | not timed | 5204.98 ± 0.2% | | 1.00 | 1.51 | 167.34 |
| imported/sherlock/holmes-coword-watson | 14309 | 1189.58 ± 0.7% | not timed | not timed | 1125.13 ± 0.2% | 6.79 ± 0.2% | not timed | not timed | 1189.83 ± 0.3% | | 1.00 | 1.06 | 175.09 |
| imported/sherlock/quotes | 14437 | 1399.52 ± 0.4% | not timed | not timed | 1767.74 ± 1.1% | 35.09 ± 0.2% | not timed | not timed | 1400.07 ± 0.4% | | 1.00 | 0.79 | 39.88 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.75 ± 0.2% | not timed | not timed | 16155.05 ± 0.1% | 36.64 ± 0.1% | not timed | not timed | 609.81 ± 0.1% | | 1.00 | 0.0377 | 16.64 |
| imported/sherlock/word-ending-n | 35297 | 481.40 ± 1.8% | not timed | not timed | 408.91 ± 0.1% | 23.42 ± 17.5% | not timed | not timed | 481.59 ± 0.4% | | 1.00 | 1.18 | 20.56 |
| imported/sherlock/repeated-class-negation | 2130 | 14763.04 ± 0.8% | not timed | not timed | 11010.15 ± 0.2% | 11.58 ± 0.1% | not timed | not timed | 14760.88 ± 0.6% | | 1.00 | 1.34 | 1274.54 |
| imported/sherlock/ing-suffix | 20547 | 566.03 ± 0.2% | not timed | not timed | 515.38 ± 0.3% | 28.94 ± 0.1% | not timed | not timed | 566.92 ± 0.3% | | 1.00 | 1.10 | 19.56 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 608.19 ± 0.4% | not timed | not timed | 2110.84 ± 0.1% | 20.56 ± 0.2% | not timed | not timed | 608.03 ± 0.3% | | 1.00 | 0.29 | 29.59 |
| opt/accelerate/whole-line | 239963 | 458.25 ± 0.4% | not timed | not timed | 371.81 ± 0.2% | 90.82 ± 15.8% | not timed | not timed | 458.26 ± 0.1% | | 1.00 | 1.23 | 5.05 |
| opt/accelerate/non-dna | 16745 | 426.50 ± 0.8% | not timed | not timed | 401.31 ± 0.1% | 29.70 ± 22.5% | not timed | not timed | 428.82 ± 0.4% | | 0.99 | 1.06 | 14.36 |
| opt/backtrack/words-english | 40536 | 136.14 ± 1.4% | not timed | not timed | 94.81 ± 0.2% | 20.00 ± 7.0% | not timed | not timed | 135.56 ± 2.0% | | 1.00 | 1.44 | 6.81 |
| opt/fixed-length/too-small-ascii | 0 | 311.15 ± 0.4% | not timed | not timed | 693.43 ± 2.6% | 80.16 ± 1.0% | not timed | not timed | 314.76 ± 0.4% | | 0.99 | 0.45 | 3.88 |
| opt/fixed-length/too-big-ascii | 0 | 3507.91 ± 0.8% | not timed | not timed | 5827.16 ± 0.4% | 126.36 ± 0.7% | not timed | not timed | 3471.00 ± 0.5% | | 1.01 | 0.60 | 27.76 |
| opt/fixed-length/go33484-1 | 0 | 672878.92 ± 0.4% | not timed | not timed | 1114213.58 ± 0.3% | 61052.96 ± 0.3% | not timed | not timed | 668898.08 ± 0.8% | | 1.01 | 0.60 | 11.02 |
| opt/fixed-length/go33484-2 | 0 | 673617.36 ± 0.5% | not timed | not timed | 1102316.69 ± 0.2% | 32195.59 ± 1.3% | not timed | not timed | 668472.36 ± 0.5% | | 1.01 | 0.61 | 20.92 |
| opt/fixed-length/go33484-3 | 0 | 2448.24 ± 2.5% | not timed | not timed | 106189.25 ± 0.3% | 767.91 ± 0.4% | not timed | not timed | 2496.14 ± 0.7% | | 0.98 | 0.0231 | 3.19 |
| opt/literal-alt/one-pattern | 1 | 547.31 ± 6.5% | not timed | not timed | 539.76 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 548.10 ± 1.5% | | 1.00 | 1.01 | 1358.83 |
| opt/onepass/fn-predicate | 916 | 371.65 ± 0.7% | not timed | not timed | 336.06 ± 0.1% | 202.81 ± 12.3% | not timed | not timed | 372.30 ± 1.0% | | 1.00 | 1.11 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 176.15 ± 2.8% | not timed | not timed | 199.70 ± 0.1% | 76.50 ± 10.1% | not timed | not timed | 176.51 ± 3.9% | | 1.00 | 0.88 | 2.30 |
| opt/prefilter/literal-english | 1 | 19913.76 ± 0.6% | not timed | not timed | 19061.95 ± 1.1% | 17138.47 ± 0.7% | not timed | not timed | 19990.99 ± 0.6% | | 1.00 | 1.04 | 1.16 |
| opt/prefilter/literal-casei-english | 1 | 14364.99 ± 0.8% | not timed | not timed | 4317.50 ± 0.2% | 32.74 ± 0.3% | not timed | not timed | 14374.46 ± 0.4% | | 1.00 | 3.33 | 438.76 |
| opt/prefilter/literal-russian | 1 | 21416.69 ± 1.1% | not timed | not timed | 19946.33 ± 0.9% | 3325.57 ± 0.2% | not timed | not timed | 21456.65 ± 0.3% | | 1.00 | 1.07 | 6.44 |
| opt/prefilter/literal-casei-russian | 1 | 8562.36 ± 0.4% | not timed | not timed | 3892.12 ± 0.2% | 31.68 ± 0.1% | not timed | not timed | 8579.32 ± 0.3% | | 1.00 | 2.20 | 270.25 |
| opt/prefilter/rust-functions | 948 | 6823.84 ± 0.2% | not timed | not timed | 8948.03 ± 0.6% | 1868.94 ± 0.4% | not timed | not timed | 6827.14 ± 0.2% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29947502.41 ± 0.1% | not timed | not timed | 21517386.84 ± 0.3% | 50.08 ± 0.2% | not timed | not timed | 29896510.13 ± 0.1% | | 1.00 | 1.39 | 597989.09 |
| opt/reverse-inner/holmes | 2593 | 9966.43 ± 0.7% | not timed | not timed | 9539.62 ± 0.3% | 24.00 ± 2.4% | not timed | not timed | 9950.87 ± 0.6% | | 1.00 | 1.04 | 415.27 |
| opt/reverse-inner/email | 47 | 36368.67 ± 1.6% | not timed | not timed | 45047.30 ± 0.2% | 32.44 ± 0.2% | not timed | not timed | 36867.74 ± 1.5% | | 0.99 | 0.81 | 1121.15 |
| opt/reverse-inner/factored-prefix | 3542 | 600.76 ± 0.2% | not timed | not timed | 596.44 ± 0.1% | 12.54 ± 0.2% | not timed | not timed | 600.56 ± 0.2% | | 1.00 | 1.01 | 47.92 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5557.71 ± 0.1% | not timed | not timed | 615.46 ± 0.1% | 75.18 ± 0.2% | not timed | not timed | 5533.65 ± 0.0% | | 1.00 | 9.03 | 73.93 |
| opt/reverse-inner/no-quadratic-forward | 0 | 671.45 ± 5.9% | not timed | not timed | 288.21 ± 0.5% | 24.57 ± 10.4% | not timed | not timed | 687.61 ± 1.6% | | 0.98 | 2.33 | 27.33 |
| opt/reverse-suffix/holmes | 4073 | 10330.99 ± 0.4% | not timed | not timed | 8472.97 ± 0.3% | 23.94 ± 1.3% | not timed | not timed | 10365.78 ± 0.5% | | 1.00 | 1.22 | 431.62 |
| opt/reverse-suffix/no-quadratic | 0 | 5533.29 ± 0.1% | not timed | not timed | 615.37 ± 0.2% | 75.22 ± 0.1% | not timed | not timed | 5561.37 ± 0.1% | | 0.99 | 8.99 | 73.56 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.87 ± 1.6% | not timed | not timed | 133.20 ± 0.1% | 13.40 ± 15.7% | not timed | not timed | 122.49 ± 2.3% | | 0.99 | 0.91 | 9.10 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.17 ± 2.3% | not timed | not timed | 128.85 ± 0.4% | 14.41 ± 17.3% | not timed | not timed | 122.76 ± 9.0% | | 1.00 | 0.95 | 8.48 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.2% | 112.51 ± 7.6% | not timed | not timed | 0.28 ± 3.0% | | 1.00 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.86 ± 0.5% | not timed | not timed | 293.10 ± 0.2% | 103.49 ± 0.7% | not timed | not timed | 316.44 ± 0.2% | | 1.00 | 1.08 | 3.07 |
| reported/i13-subset-regex/original-ascii | 4094 | 11163.26 ± 1.1% | not timed | not timed | 4519.26 ± 2.8% | 11.43 ± 0.2% | not timed | not timed | 11200.96 ± 0.7% | | 1.00 | 2.47 | 977.08 |
| reported/i13-subset-regex/original-unicode | 4094 | 11015.88 ± 0.8% | not timed | not timed | 251.81 ± 3.7% | 11.51 ± 0.0% | not timed | not timed | 11141.25 ± 1.0% | | 0.99 | 43.75 | 957.24 |
| reported/i13-subset-regex/big-ascii | 1955 | 10552.43 ± 1.9% | not timed | not timed | 67.86 ± 3.6% | 9.85 ± 0.3% | not timed | not timed | 10709.93 ± 0.9% | | 0.99 | 155.51 | 1070.86 |
| reported/i13-subset-regex/big-unicode | 1955 | 10595.05 ± 2.5% | not timed | not timed | 12.25 ± 54.9% | 9.84 ± 0.1% | not timed | not timed | 10701.10 ± 1.0% | | 0.99 | 864.98 | 1076.29 |
| reported/i13-subset-regex/huge-ascii | 55 | 9870.98 ± 4.2% | not timed | not timed | 11.03 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 9965.41 ± 2.8% | | 0.99 | 894.64 | 1125.58 |
| reported/i13-subset-regex/huge-unicode | 55 | 9916.07 ± 2.9% | not timed | not timed | 10.94 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9900.06 ± 3.3% | | 1.00 | 906.54 | 1130.21 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.57 ± 0.0% | not timed | not timed | 11.05 ± 0.1% | 8.70 ± 1.0% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.0% | not timed | not timed | 10.98 ± 0.4% | 8.77 ± 0.1% | not timed | not timed | 5.04 ± 0.0% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 486.90 ± 0.3% | not timed | not timed | 103.22 ± 0.1% | 6.52 ± 0.2% | not timed | not timed | 487.85 ± 0.5% | | 1.00 | 4.72 | 74.65 |
| reported/i787-keywords/opt-ascii | 5674 | 488.76 ± 0.4% | not timed | not timed | 276.87 ± 0.3% | 10.32 ± 0.1% | not timed | not timed | 489.51 ± 0.3% | | 1.00 | 1.77 | 47.34 |
| slow/quadratic-regex-1x | 100 | 7.12 ± 0.3% | not timed | not timed | 4.92 ± 0.3% | 0.05 ± 0.5% | not timed | not timed | 7.01 ± 0.1% | | 1.01 | 1.45 | 144.32 |
| slow/quadratic-regex-2x | 199 | 3.44 ± 0.2% | not timed | not timed | 2.75 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.44 ± 0.3% | | 1.00 | 1.25 | 269.62 |
| slow/quadratic-haystack-1x | 100 | 20.52 ± 6.1% | not timed | not timed | 9.99 ± 0.2% | 1.01 ± 13.0% | not timed | not timed | 20.48 ± 3.6% | | 1.00 | 2.05 | 20.23 |
| slow/quadratic-haystack-2x | 200 | 17.76 ± 1.3% | not timed | not timed | 5.56 ± 0.4% | 0.55 ± 0.9% | not timed | not timed | 17.84 ± 13.0% | | 1.00 | 3.19 | 32.46 |
| unicode/codepoints/any-one | 1112064 | 289.54 ± 0.4% | not timed | not timed | 174.47 ± 0.1% | 18.01 ± 16.0% | not timed | not timed | 289.63 ± 0.3% | | 1.00 | 1.66 | 16.08 |
| unicode/codepoints/any-all | 4382592 | 269.94 ± 0.3% | not timed | not timed | 246.70 ± 0.1% | 117.18 ± 0.0% | not timed | not timed | 269.69 ± 0.4% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.76 ± 0.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.89 ± 0.8% | not timed | not timed | 615.29 ± 0.6% | 135.30 ± 0.2% | not timed | not timed | 603.02 ± 1.1% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 31.60 ± 0.3% | not timed | not timed | 38.75 ± 0.2% | 3.95 ± 1.3% | not timed | not timed | 31.62 ± 0.2% | | 1.00 | 0.82 | 8.01 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.2% | not timed | not timed | 4.10 ± 0.3% | 2.36 ± 0.7% | not timed | not timed | 1.45 ± 0.1% | | 0.99 | 0.35 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 1.3% | not timed | not timed | 4.09 ± 0.9% | 6.33 ± 8.0% | not timed | not timed | 1.29 ± 22.4% | | 0.99 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 127.29 ± 4.1% | not timed | not timed | 81.40 ± 0.1% | 12.00 ± 14.6% | not timed | not timed | 128.87 ± 3.8% | | 0.99 | 1.56 | 10.61 |
| unicode/word/boundary-long-english | 3466 | 615.29 ± 0.1% | not timed | not timed | 607.18 ± 0.1% | 32.16 ± 0.4% | not timed | not timed | 616.39 ± 0.1% | | 1.00 | 1.01 | 19.13 |
| unicode/word/around-holmes-english | 27 | 19227.98 ± 0.7% | not timed | not timed | 19133.62 ± 2.0% | 22.12 ± 1.1% | not timed | not timed | 19235.63 ± 0.9% | | 1.00 | 1.00 | 869.31 |
| wild/bibleref/long | 874 | 563.93 ± 0.2% | not timed | not timed | 581.33 ± 0.0% | 6.70 ± 0.1% | not timed | not timed | 564.21 ± 0.1% | | 1.00 | 0.97 | 84.11 |
| wild/bibleref/short | 30 | 24.76 ± 2.5% | not timed | not timed | 30.90 ± 0.4% | 14.17 ± 8.7% | not timed | not timed | 25.34 ± 7.0% | | 0.98 | 0.80 | 1.75 |
| wild/bibleref/line | 874 | 393.86 ± 0.1% | not timed | not timed | 213.35 ± 0.1% | 9.07 ± 8.1% | not timed | not timed | 393.86 ± 1.6% | | 1.00 | 1.85 | 43.45 |
| wild/caddy/caddy | 6 | 417.79 ± 2.4% | not timed | not timed | 245.08 ± 0.1% | 67.20 ± 14.0% | not timed | not timed | 418.74 ± 0.1% | | 1.00 | 1.70 | 6.22 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.86 ± 0.4% | not timed | not timed | 344.38 ± 0.4% | 13.50 ± 0.1% | not timed | not timed | 1059.04 ± 0.3% | | 1.00 | 3.07 | 78.45 |
| wild/ruff/noqa | 84 | 436.16 ± 0.5% | not timed | not timed | 460.81 ± 0.1% | 19.74 ± 1.6% | not timed | not timed | 434.71 ± 0.1% | | 1.00 | 0.95 | 22.10 |
| wild/ruff/unnecessary-coding-comment | 16 | 961.21 ± 0.2% | not timed | not timed | 703.53 ± 0.2% | 135.17 ± 11.1% | not timed | not timed | 959.43 ± 0.4% | | 1.00 | 1.37 | 7.11 |
| wild/ruff/string-quote-prefix | 2972 | 1356.44 ± 0.7% | not timed | not timed | 441.08 ± 0.2% | 313.52 ± 25.6% | not timed | not timed | 1357.58 ± 0.6% | | 1.00 | 3.08 | 4.33 |
| wild/ruff/space-around-operator | 1224378 | 220.08 ± 1.9% | not timed | not timed | 185.29 ± 0.1% | 18.25 ± 1.6% | not timed | not timed | 220.96 ± 1.3% | | 1.00 | 1.19 | 12.06 |
| wild/ruff/shebang | 282 | 983.70 ± 0.6% | not timed | not timed | 329.44 ± 0.1% | 120.89 ± 9.8% | not timed | not timed | 988.24 ± 0.3% | | 1.00 | 2.99 | 8.14 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13801.98 ± 1.8% | not timed | not timed | 13819.53 ± 1.1% | 6942.96 ± 2.3% | not timed | not timed | 13801.10 ± 2.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12751.08 ± 0.7% | not timed | not timed | 13441.82 ± 0.7% | 6388.22 ± 0.7% | not timed | not timed | 12782.11 ± 0.8% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13181.01 ± 0.4% | not timed | not timed | 13666.51 ± 0.8% | 6627.63 ± 35.9% | not timed | not timed | 13186.86 ± 5.7% | | 1.00 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9567.81 ± 0.2% | not timed | not timed | 13566.88 ± 0.9% | 6773.22 ± 0.5% | not timed | not timed | 9572.31 ± 0.5% | | 1.00 | 0.71 | 1.41 |
| wild/url/search | 234965 | 122.13 ± 13.9% | not timed | not timed | 65.54 ± 1.5% | 2.22 ± 0.7% | not timed | not timed | 122.08 ± 13.5% | | 1.00 | 1.86 | 54.89 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.1% | not timed | not timed | 0.01 ± 1.3% | 0.01 ± 30.8% | not timed | not timed | 0.03 ± 41.6% | | 1.00 | 3.11 | 4.26 |
| dictionary/compile/english-15 | 1 | 0.35 ± 5.2% | not timed | not timed | 0.07 ± 3.4% | 0.10 ± 7.9% | not timed | not timed | 0.35 ± 20.4% | | 1.00 | 5.12 | 3.47 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 15.6% | not timed | not timed | 0.02 ± 1.8% | 34.93 ± 2.9% | not timed | not timed | 0.25 ± 1.3% | | 1.00 | 13.23 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.17 ± 2.3% | not timed | not timed | 11.56 ± 0.2% | 58.83 ± 20.3% | not timed | not timed | 47.46 ± 4.8% | | 0.99 | 4.08 | 0.80 |
| reported/i787-keywords/compile | 1 | 33.81 ± 14.4% | not timed | not timed | 2.12 ± 1.0% | 16.46 ± 36.7% | not timed | not timed | 34.56 ± 4.6% | | 0.98 | 15.93 | 2.05 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 364.35 ± 1.7% | not timed | not timed | 119.91 ± 0.1% | 561.74 ± 14.9% | not timed | not timed | 368.49 ± 2.2% | | 0.99 | 3.04 | 0.65 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.22 ± 4.8% | not timed | not timed | 4.07 ± 0.7% | 40.90 ± 8.5% | not timed | not timed | 47.93 ± 3.6% | | 0.99 | 11.61 | 1.15 |
| unicode/compile/one-letter | 53 | 6.67 ± 2.9% | not timed | not timed | 4.53 ± 0.1% | 64.89 ± 4.3% | not timed | not timed | 6.72 ± 14.3% | | 0.99 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 17.3% | not timed | not timed | 0.10 ± 1.8% | 64.50 ± 3.9% | not timed | not timed | 1.09 ± 17.8% | | 0.99 | 10.98 | 0.0166 |
| unicode/compile/fifty-letters-ascii | 1 | 222.18 ± 3.4% | not timed | not timed | 53.26 ± 0.2% | 194.75 ± 15.1% | not timed | not timed | 222.35 ± 7.5% | | 1.00 | 4.17 | 1.14 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 380.13 ± 27.5% | not timed | not timed | 47.43 ± 0.3% | 662.43 ± 31.5% | not timed | not timed | 386.86 ± 5.4% | | 0.98 | 8.01 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 602.28 ± 19.9% | not timed | not timed | 145.66 ± 0.2% | 662.53 ± 28.8% | not timed | not timed | 619.66 ± 3.1% | | 0.97 | 4.13 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 324.35 ± 7.1% | not timed | not timed | 51.05 ± 0.2% | 1311.51 ± 25.9% | not timed | not timed | 330.58 ± 7.7% | | 0.98 | 6.35 | 0.25 |
| wild/bibleref/compile | 3 | 5.78 ± 3.9% | not timed | not timed | 1.92 ± 0.7% | 31.34 ± 9.9% | not timed | not timed | 5.89 ± 3.7% | | 0.98 | 3.00 | 0.18 |
| wild/url/compile | 1 | 0.63 ± 20.5% | not timed | not timed | 0.14 ± 0.5% | 0.44 ± 15.0% | not timed | not timed | 0.63 ± 17.3% | | 1.00 | 4.34 | 1.41 |

