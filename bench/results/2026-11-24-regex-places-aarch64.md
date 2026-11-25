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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506970245 |
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
| literal: a word | 217 | 19901.49 ± 2.8% | 5084.16 ± 0.2% | 28.26 ± 0.4% | 18404.52 ± 2.0% | 9234.28 ± 6.7% | 17.58 ± 0.3% | 71.66 ± 1.2% | 19901.44 ± 2.0% | 3.91 | 1.00 | 1.08 | 2.16 |
| literal: a word that is not there | 0 | 22014.66 ± 1.6% | 4944.65 ± 0.2% | 28.13 ± 0.6% | 20017.14 ± 1.2% | 29637.24 ± 0.5% | 17.40 ± 0.2% | 69.26 ± 0.1% | 21900.91 ± 1.6% | 4.45 | 1.01 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6435.49 ± 0.3% | 1977.75 ± 0.3% | 14.41 ± 0.2% | 3946.11 ± 0.2% | 21.88 ± 0.1% | 5.30 ± 0.2% | 6.75 ± 0.1% | 6437.53 ± 0.5% | 3.25 | 1.00 | 1.63 | 294.13 |
| literal: a word in any case | 217 | 15168.22 ± 0.3% | 2105.54 ± 0.3% | 21.53 ± 0.4% | 3966.79 ± 0.1% | 38.08 ± 0.4% | refused | differs | 15212.29 ± 0.6% | 7.20 | 1.00 | 3.82 | 398.28 |
| literal: an href attribute | 33 | 16889.10 ± 1.0% | 617.85 ± 0.1% | 27.30 ± 0.4% | 17146.11 ± 1.7% | 2258.79 ± 0.5% | 13.43 ± 0.1% | 66.41 ± 0.2% | 17023.19 ± 0.9% | 27.34 | 0.99 | 0.99 | 7.48 |
| literal: a word, second text | 123 | 20182.03 ± 1.0% | 3433.49 ± 0.1% | 27.99 ± 0.1% | 18636.85 ± 0.9% | 7658.94 ± 4.5% | 19.52 ± 0.2% | 53.73 ± 1.5% | 20180.77 ± 0.6% | 5.88 | 1.00 | 1.08 | 2.64 |
| class: two capitalized words | 1331 | 1063.57 ± 0.4% | 609.22 ± 0.1% | 26.01 ± 0.2% | 585.26 ± 0.1% | 40.57 ± 10.2% | 14.98 ± 0.3% | 61.40 ± 0.3% | 1064.15 ± 0.6% | 1.75 | 1.00 | 1.82 | 26.21 |
| class: a word that ends in ing | 3399 | 576.15 ± 0.3% | 582.85 ± 0.4% | 17.95 ± 1.4% | 548.01 ± 0.1% | 29.59 ± 1.6% | 8.23 ± 0.3% | 17.09 ± 0.1% | 583.50 ± 0.2% | 0.99 | 0.99 | 1.05 | 19.47 |
| class: a word in capitals | 2332 | 1391.70 ± 0.8% | 614.87 ± 0.1% | 27.61 ± 0.3% | 572.60 ± 0.1% | 43.64 ± 14.0% | 17.23 ± 0.3% | 70.91 ± 0.3% | 1392.34 ± 0.5% | 2.26 | 1.00 | 2.43 | 31.89 |
| class: a number | 8288 | 2127.36 ± 0.2% | 853.29 ± 0.1% | 27.84 ± 0.3% | 1722.52 ± 0.2% | 41.23 ± 13.3% | 0.57 ± 0.1% | 49.63 ± 0.2% | 2130.40 ± 0.3% | 2.49 | 1.00 | 1.24 | 51.60 |
| class: two capitalized words, second text | 5359 | 525.70 ± 0.3% | 534.98 ± 0.2% | 23.33 ± 0.0% | 484.00 ± 0.1% | 35.35 ± 6.8% | 16.68 ± 0.1% | 57.67 ± 0.3% | 526.03 ± 0.2% | 0.98 | 1.00 | 1.09 | 14.87 |
| other: a word between two words | 6104 | 809.95 ± 0.2% | 608.93 ± 0.2% | 23.56 ± 0.2% | 736.66 ± 0.4% | 102.23 ± 19.2% | 11.29 ± 0.1% | 62.19 ± 0.3% | 808.32 ± 0.3% | 1.33 | 1.00 | 1.10 | 7.92 |
| other: a number before a unit, second text | 1481 | 6208.75 ± 0.9% | 1132.61 ± 0.5% | 25.96 ± 0.3% | 5643.69 ± 1.1% | 40.79 ± 0.2% | 17.83 ± 0.1% | 58.56 ± 0.3% | 6180.20 ± 1.0% | 5.48 | 1.00 | 1.10 | 152.21 |
| other: a heading's start tag | 110 | 14242.34 ± 1.4% | 750.77 ± 0.1% | 27.41 ± 0.3% | 1714.02 ± 0.6% | 1581.37 ± 5.1% | 16.34 ± 0.4% | 70.94 ± 0.2% | 14215.51 ± 1.4% | 18.97 | 1.00 | 8.31 | 9.01 |
| other: a whole word | 217 | 16405.92 ± 1.6% | 607.96 ± 0.5% | 29.38 ± 0.4% | 14605.46 ± 1.5% | 47.98 ± 0.4% | 13.74 ± 0.1% | 47.50 ± 0.4% | 16263.78 ± 1.9% | 26.99 | 1.01 | 1.12 | 341.92 |
| other: a line's first word, second text | 3716 | 2105.91 ± 0.3% | 600.22 ± 0.0% | 31.03 ± 0.5% | 1730.07 ± 0.5% | 62.73 ± 6.2% | refused | refused | 2107.62 ± 1.1% | 3.51 | 1.00 | 1.22 | 33.57 |
| other: fourteen octets before an x | 87 | 24265.81 ± 1.7% | 240.37 ± 0.4% | 6.55 ± 0.1% | 4043.63 ± 0.9% | 10.64 ± 0.3% | differs | 17.07 ± 0.1% | 24252.33 ± 5.9% | 100.95 | 1.00 | 6.00 | 2280.38 |
| other: a Greek word | 21815 | 521.55 ± 0.3% | 425.08 ± 0.2% | 30.87 ± 0.4% | 289.57 ± 0.2% | 49.69 ± 13.2% | differs | refused | 524.33 ± 0.2% | 1.23 | 0.99 | 1.80 | 10.50 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.30 ± 0.1% | 29.30 ± 0.2% | 0.86 ± 0.2% | 19.75 ± 0.6% | 2.77 ± 0.5% | differs | 4.01 ± 0.2% | 29.25 ± 0.4% | 1.00 | 1.00 | 1.48 | 10.56 |
| a UUID | 32895 | 24.71 ± 0.3% | 24.66 ± 0.3% | 0.64 ± 0.1% | 15.08 ± 0.1% | 3.09 ± 0.2% | 0.72 ± 0.4% | 3.61 ± 0.4% | 24.74 ± 0.2% | 1.00 | 1.00 | 1.64 | 7.99 |
| an IPv4 address | 33176 | 38.46 ± 0.2% | 38.44 ± 0.2% | 2.07 ± 0.5% | 28.94 ± 0.3% | 6.66 ± 0.1% | differs | 4.15 ± 0.2% | 38.41 ± 0.1% | 1.00 | 1.00 | 1.33 | 5.77 |
| a date and time | 32954 | 34.35 ± 0.1% | 34.07 ± 0.2% | 1.45 ± 0.1% | 21.14 ± 0.2% | 7.04 ± 0.2% | 1.19 ± 0.1% | 7.03 ± 0.2% | 34.32 ± 0.1% | 1.01 | 1.00 | 1.62 | 4.88 |
| a field path | 32606 | 32.56 ± 0.5% | 32.52 ± 0.4% | 1.02 ± 0.4% | 23.02 ± 0.3% | 3.50 ± 1.5% | differs | 2.92 ± 0.2% | 32.53 ± 0.1% | 1.00 | 1.00 | 1.41 | 9.31 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.1% | 11.04 ± 0.3% | 11.12 ± 0.1% | 11.46 ± 0.1% | 4.98 ± 1.8% | 0.91 ± 0.4% | none | 11.08 ± 0.2% | 1.01 | 1.00 | 0.97 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.59 ± 0.3% | 222.55 ± 0.3% | 260.05 ± 0.3% | 86.72 ± 0.1% | 222.04 ± 2.0% | 464.70 ± 0.5% | 3739.49 ± 0.8% | 222.57 ± 0.2% | 1.00 | 1.00 | 2.57 | 1.00 |
| a UUID | 62 | 144.21 ± 0.3% | 144.31 ± 0.3% | 159.76 ± 0.2% | 45.75 ± 0.6% | 100.75 ± 10.0% | 173.48 ± 1.2% | 4458.20 ± 0.2% | 144.30 ± 0.2% | 1.00 | 1.00 | 3.15 | 1.43 |
| an IPv4 address | 29 | 421.14 ± 0.6% | 420.90 ± 0.4% | 582.82 ± 0.8% | 75.97 ± 0.6% | 132.48 ± 1.1% | 279.46 ± 0.4% | 7589.03 ± 0.2% | 420.17 ± 0.2% | 1.00 | 1.00 | 5.54 | 3.18 |
| a date and time | 56 | 302.32 ± 0.2% | 302.54 ± 0.3% | 376.33 ± 0.2% | 72.43 ± 1.2% | 138.10 ± 0.7% | 307.12 ± 2.2% | 4948.04 ± 0.4% | 302.34 ± 0.1% | 1.00 | 1.00 | 4.17 | 2.19 |
| a field path | 39 | 213.24 ± 0.3% | 213.41 ± 0.4% | 247.66 ± 0.2% | 79.08 ± 0.2% | 205.08 ± 1.6% | 464.22 ± 1.2% | 4821.40 ± 0.4% | 213.36 ± 0.4% | 1.00 | 1.00 | 2.70 | 1.04 |
| literal: a word | 7 | 619.07 ± 0.4% | 671.31 ± 0.6% | 1187.03 ± 0.2% | 493.63 ± 1.5% | 636.49 ± 3.0% | 875.00 ± 0.6% | 29753.79 ± 0.1% | 621.05 ± 0.4% | 0.92 | 1.00 | 1.25 | 0.97 |
| literal: a word that is not there | 8 | 596.26 ± 0.4% | 655.13 ± 0.4% | 1121.21 ± 0.7% | 453.33 ± 0.1% | 605.39 ± 1.7% | 822.30 ± 0.4% | 28650.35 ± 0.5% | 597.14 ± 0.5% | 0.91 | 1.00 | 1.32 | 0.98 |
| literal: one of four words | 26 | 246.79 ± 0.2% | 396.54 ± 0.4% | 532.71 ± 0.2% | 49.30 ± 0.2% | 243.93 ± 2.6% | 333.43 ± 0.3% | 15474.31 ± 0.1% | 246.80 ± 0.1% | 0.62 | 1.00 | 5.01 | 1.01 |
| literal: a word in any case | 11 | 447.35 ± 0.1% | 479.42 ± 0.5% | 703.03 ± 0.2% | 15.65 ± 0.6% | 662.91 ± 1.6% | refused | 23321.45 ± 0.1% | 447.39 ± 0.3% | 0.93 | 1.00 | 28.58 | 0.67 |
| literal: an href attribute | 12 | 336.41 ± 0.4% | 347.97 ± 0.4% | 451.34 ± 0.3% | 45.30 ± 0.3% | 503.87 ± 2.0% | 716.29 ± 0.2% | 21619.81 ± 0.5% | 336.51 ± 0.3% | 0.97 | 1.00 | 7.43 | 0.67 |
| literal: a word, second text | 10 | 552.58 ± 0.3% | 615.08 ± 0.7% | 1006.91 ± 0.7% | 414.15 ± 0.8% | 541.75 ± 1.4% | 740.20 ± 0.6% | 26397.55 ± 0.1% | 553.16 ± 0.7% | 0.90 | 1.00 | 1.33 | 1.02 |
| class: two capitalized words | 23 | 436.69 ± 0.6% | 463.81 ± 0.5% | 662.64 ± 0.6% | 97.85 ± 1.3% | 509.57 ± 2.3% | 692.05 ± 4.1% | 6332.31 ± 0.1% | 435.98 ± 0.1% | 0.94 | 1.00 | 4.46 | 0.86 |
| class: a word that ends in ing | 9 | 545.49 ± 0.3% | 618.17 ± 0.5% | 1060.15 ± 0.1% | 131.93 ± 0.2% | 762.29 ± 1.4% | 1023.96 ± 0.3% | 15701.14 ± 0.1% | 545.57 ± 0.3% | 0.88 | 1.00 | 4.13 | 0.72 |
| class: a word in capitals | 16 | 492.81 ± 0.2% | 528.79 ± 0.5% | 830.31 ± 0.3% | 134.21 ± 1.3% | 755.12 ± 1.1% | 960.34 ± 0.5% | 8325.71 ± 0.1% | 492.41 ± 0.3% | 0.93 | 1.00 | 3.67 | 0.65 |
| class: a number | 6 | 627.89 ± 0.7% | 687.38 ± 0.3% | 1262.85 ± 0.2% | 41.80 ± 0.6% | 1404.92 ± 0.6% | 1741.23 ± 1.4% | 22442.13 ± 0.0% | 626.56 ± 0.3% | 0.91 | 1.00 | 15.02 | 0.45 |
| class: two capitalized words, second text | 23 | 437.06 ± 0.3% | 464.83 ± 0.2% | 662.21 ± 0.6% | 100.24 ± 1.8% | 506.55 ± 1.4% | 700.21 ± 0.4% | 6333.65 ± 0.2% | 435.57 ± 0.3% | 0.94 | 1.00 | 4.36 | 0.86 |
| other: a word between two words | 13 | 532.97 ± 0.2% | 554.08 ± 0.3% | 869.83 ± 0.1% | 134.20 ± 0.3% | 505.33 ± 0.7% | 775.14 ± 1.2% | 14563.68 ± 0.1% | 532.34 ± 0.1% | 0.96 | 1.00 | 3.97 | 1.05 |
| other: a number before a unit, second text | 15 | 383.67 ± 0.4% | 425.13 ± 0.3% | 587.66 ± 0.1% | 39.52 ± 0.7% | 638.00 ± 1.4% | 841.54 ± 0.5% | 15108.49 ± 0.1% | 383.57 ± 0.3% | 0.90 | 1.00 | 9.71 | 0.60 |
| other: a heading's start tag | 13 | 346.71 ± 0.4% | 353.57 ± 0.5% | 461.37 ± 0.3% | 43.33 ± 0.8% | 631.71 ± 0.9% | 821.28 ± 0.3% | 17856.13 ± 0.1% | 347.06 ± 0.2% | 0.98 | 1.00 | 8.00 | 0.55 |
| other: a whole word | 11 | 571.43 ± 0.3% | 615.14 ± 0.7% | 1012.75 ± 0.1% | 119.49 ± 0.6% | 569.66 ± 0.3% | 777.92 ± 0.6% | 26205.37 ± 0.3% | 572.34 ± 0.1% | 0.93 | 1.00 | 4.78 | 1.00 |
| other: a line's first word, second text | 17 | 514.13 ± 0.6% | 546.68 ± 0.2% | 865.86 ± 0.2% | 127.60 ± 0.3% | 708.47 ± 11.0% | refused | refused | 514.63 ± 0.4% | 0.94 | 1.00 | 4.03 | 0.73 |
| other: fourteen octets before an x | 16 | 107.54 ± 0.4% | 153.84 ± 0.5% | 174.71 ± 0.9% | 15.12 ± 0.4% | 456.45 ± 1.9% | 394.68 ± 0.7% | 12617.49 ± 0.3% | 107.62 ± 0.5% | 0.70 | 1.00 | 7.11 | 0.24 |
| other: a Greek word | 8 | 442.88 ± 0.4% | 577.99 ± 0.2% | 946.63 ± 0.2% | 58.41 ± 1.0% | 1376.25 ± 0.6% | 1706.78 ± 0.6% | refused | 443.03 ± 0.1% | 0.77 | 1.00 | 7.58 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15935.28 ± 1.0% | not timed | not timed | 16528.75 ± 1.5% | 2133.42 ± 7.3% | not timed | not timed | 15953.11 ± 0.6% | | 1.00 | 0.96 | 7.47 |
| 01-literal/sherlock-casei-en | 522 | 11158.00 ± 7.2% | not timed | not timed | 3591.90 ± 0.1% | 32.57 ± 0.2% | not timed | not timed | 11200.78 ± 1.8% | | 1.00 | 3.11 | 342.62 |
| 01-literal/sherlock-ru | 724 | 17229.88 ± 0.5% | not timed | not timed | 17357.66 ± 0.3% | 1471.66 ± 13.4% | not timed | not timed | 17246.99 ± 0.1% | | 1.00 | 0.99 | 11.71 |
| 01-literal/sherlock-casei-ru | 746 | 6148.49 ± 0.4% | not timed | not timed | 3325.98 ± 0.2% | 31.72 ± 0.2% | not timed | not timed | 6135.43 ± 0.2% | | 1.00 | 1.85 | 193.81 |
| 01-literal/sherlock-zh | 30 | 20006.17 ± 1.1% | not timed | not timed | 18948.21 ± 1.3% | 2617.71 ± 17.2% | not timed | not timed | 20058.53 ± 0.6% | | 1.00 | 1.06 | 7.64 |
| 02-literal-alternate/sherlock-en | 714 | 6149.68 ± 0.1% | not timed | not timed | 3931.95 ± 0.0% | 16.58 ± 0.1% | not timed | not timed | 6153.35 ± 0.2% | | 1.00 | 1.56 | 370.98 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1975.29 ± 0.9% | not timed | not timed | 697.70 ± 0.2% | 11.13 ± 0.2% | not timed | not timed | 1978.19 ± 0.9% | | 1.00 | 2.83 | 177.48 |
| 02-literal-alternate/sherlock-ru | 899 | 5538.68 ± 0.2% | not timed | not timed | 3253.26 ± 0.1% | 22.65 ± 0.1% | not timed | not timed | 5526.32 ± 0.1% | | 1.00 | 1.70 | 244.49 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.84 ± 0.5% | not timed | not timed | 1233.24 ± 0.2% | 9.16 ± 0.2% | not timed | not timed | 2058.12 ± 0.4% | | 1.00 | 1.67 | 224.88 |
| 02-literal-alternate/sherlock-zh | 207 | 7354.19 ± 0.2% | not timed | not timed | 4158.84 ± 0.0% | 31.54 ± 0.1% | not timed | not timed | 7347.16 ± 0.2% | | 1.00 | 1.77 | 233.14 |
| 03-date/ascii | 111817 | 133.54 ± 0.7% | not timed | not timed | 95.63 ± 0.1% | 0.20 ± 4.7% | not timed | not timed | 134.44 ± 1.1% | | 0.99 | 1.40 | 659.38 |
| 04-ruff-noqa/real | 84 | 435.91 ± 0.1% | not timed | not timed | 462.51 ± 0.1% | 19.68 ± 1.4% | not timed | not timed | 435.93 ± 0.1% | | 1.00 | 0.94 | 22.15 |
| 04-ruff-noqa/tweaked | 44 | 594.25 ± 0.2% | not timed | not timed | 461.56 ± 0.1% | 365.12 ± 1.0% | not timed | not timed | 595.48 ± 0.1% | | 1.00 | 1.29 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.3% | not timed | not timed | 4.92 ± 0.1% | 0.20 ± 3.5% | not timed | not timed | 5.51 ± 3.1% | | 0.97 | 1.09 | 26.17 |
| 06-cloud-flare-redos/original | 107 | 426.39 ± 0.2% | not timed | not timed | 216.23 ± 0.0% | 24.92 ± 0.2% | not timed | not timed | 432.42 ± 0.2% | | 0.99 | 1.97 | 17.11 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.74 ± 0.3% | not timed | not timed | 229.62 ± 0.0% | 26.65 ± 0.2% | not timed | not timed | 430.95 ± 0.2% | | 1.00 | 1.88 | 16.20 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.40 ± 0.1% | not timed | not timed | 256.24 ± 0.3% | 28.84 ± 0.2% | not timed | not timed | 588.73 ± 0.1% | | 1.00 | 2.30 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 233.79 ± 1.3% | not timed | not timed | 171.97 ± 0.1% | 43.45 ± 5.4% | not timed | not timed | 232.83 ± 0.4% | | 1.00 | 1.36 | 5.38 |
| 08-words/all-english | 56691 | 127.83 ± 0.7% | not timed | not timed | 82.75 ± 0.1% | 11.85 ± 4.4% | not timed | not timed | 128.03 ± 0.5% | | 1.00 | 1.54 | 10.78 |
| 08-words/long-english | 839 | 609.29 ± 0.4% | not timed | not timed | 593.92 ± 0.1% | 32.17 ± 0.4% | not timed | not timed | 623.48 ± 0.2% | | 0.98 | 1.03 | 18.94 |
| 09-aws-keys/full | 0 | 440.74 ± 0.2% | not timed | not timed | 466.09 ± 0.1% | 64.67 ± 3.4% | not timed | not timed | 439.63 ± 0.1% | | 1.00 | 0.95 | 6.81 |
| 09-aws-keys/quick | 0 | 874.74 ± 0.2% | not timed | not timed | 988.88 ± 0.2% | 418.34 ± 0.4% | not timed | not timed | 874.86 ± 0.2% | | 1.00 | 0.88 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 581.87 ± 2.5% | not timed | not timed | 515.90 ± 0.6% | 19.49 ± 0.5% | not timed | not timed | 583.47 ± 2.9% | | 1.00 | 1.13 | 29.86 |
| 10-bounded-repeat/letters-ru | 3475 | 505.35 ± 1.4% | not timed | not timed | 478.05 ± 0.1% | 22.10 ± 9.7% | not timed | not timed | 507.51 ± 1.4% | | 1.00 | 1.06 | 22.86 |
| 10-bounded-repeat/context | 53 | 85.46 ± 1.7% | not timed | not timed | 66.23 ± 0.2% | 19.78 ± 0.1% | not timed | not timed | 85.54 ± 1.5% | | 1.00 | 1.29 | 4.32 |
| 10-bounded-repeat/capitals | 11 | 634.02 ± 8.2% | not timed | not timed | 618.45 ± 0.0% | 35.57 ± 0.2% | not timed | not timed | 633.41 ± 7.9% | | 1.00 | 1.03 | 17.83 |
| 11-unstructured-to-json/extract | 600 | 57.21 ± 1.1% | not timed | not timed | 77.38 ± 0.1% | 49.15 ± 0.5% | not timed | not timed | 57.34 ± 0.1% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 561.63 ± 0.8% | not timed | not timed | 560.65 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 561.14 ± 1.4% | | 1.00 | 1.00 | 1380.45 |
| 14-quadratic/1x | 100 | 21.26 ± 1.5% | not timed | not timed | 10.00 ± 0.3% | 0.98 ± 2.8% | not timed | not timed | 21.49 ± 1.4% | | 0.99 | 2.13 | 21.64 |
| 14-quadratic/2x | 200 | 17.69 ± 1.0% | not timed | not timed | 5.55 ± 0.3% | 0.54 ± 1.0% | not timed | not timed | 17.79 ± 0.7% | | 0.99 | 3.19 | 33.04 |
| 14-quadratic/10x | 1000 | 7.76 ± 0.4% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.5% | not timed | not timed | 7.78 ± 0.3% | | 1.00 | 6.43 | 66.97 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 0.2% | not timed | not timed | 0.35 ± 0.7% | 0.56 ± 2.3% | not timed | not timed | 1.22 ± 0.9% | | 1.00 | 3.53 | 2.20 |
| 04-ruff-noqa/compile-real | 1 | 106.34 ± 1.0% | not timed | not timed | 13.88 ± 0.6% | 140.08 ± 3.6% | not timed | not timed | 106.50 ± 0.9% | | 1.00 | 7.66 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 13.96 ± 1.1% | not timed | not timed | 2.53 ± 0.9% | 6.57 ± 3.7% | not timed | not timed | 14.06 ± 0.1% | | 0.99 | 5.51 | 2.13 |
| 07-unicode-character-data/compile | 1 | 108.14 ± 0.4% | not timed | not timed | 25.92 ± 0.3% | 36.57 ± 3.1% | not timed | not timed | 108.21 ± 0.3% | | 1.00 | 4.17 | 2.96 |
| 09-aws-keys/compile-full | 1 | 53.23 ± 0.7% | not timed | not timed | 8.28 ± 0.4% | 23.62 ± 1.5% | not timed | not timed | 53.26 ± 1.4% | | 1.00 | 6.43 | 2.25 |
| 09-aws-keys/compile-quick | 1 | 187.17 ± 1.2% | not timed | not timed | 47.08 ± 0.3% | 136.03 ± 1.5% | not timed | not timed | 187.49 ± 0.2% | | 1.00 | 3.98 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 72.23 ± 0.5% | not timed | not timed | 11.23 ± 0.2% | 16.28 ± 3.4% | not timed | not timed | 72.11 ± 1.4% | | 1.00 | 6.43 | 4.44 |
| 10-bounded-repeat/compile-capitals | 1 | 84.92 ± 1.0% | not timed | not timed | 8.09 ± 0.4% | 24.21 ± 1.1% | not timed | not timed | 84.75 ± 0.5% | | 1.00 | 10.49 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 170.42 ± 1.5% | not timed | not timed | 40.86 ± 0.3% | 69.40 ± 3.5% | not timed | not timed | 170.85 ± 1.2% | | 1.00 | 4.17 | 2.46 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.2% | not timed | not timed | 0.07 ± 15.7% | 0.10 ± 16.7% | not timed | not timed | 0.35 ± 1.2% | | 0.99 | 4.99 | 3.50 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.36 ± 1.9% | not timed | not timed | 6.47 ± 0.2% | 0.59 ± 25.6% | not timed | not timed | 7.36 ± 2.3% | | 1.00 | 1.14 | 12.38 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.4% | not timed | not timed | 165.20 ± 0.5% | 0.00 ± 0.4% | not timed | not timed | 1.17 ± 0.5% | | 1.00 | 0.0070 | 389.45 |
| dictionary/search/english-15 | 15 | 566.40 ± 1.0% | not timed | not timed | 558.40 ± 0.2% | 0.37 ± 0.1% | not timed | not timed | 567.52 ± 0.9% | | 1.00 | 1.01 | 1544.01 |
| folly/awyer-inn-busted | 1 | 5594.95 ± 0.1% | not timed | not timed | 142.18 ± 0.1% | 43.81 ± 0.1% | not timed | not timed | 5614.21 ± 0.0% | | 1.00 | 39.35 | 127.70 |
| folly/literal-never-match-rare | 0 | 21088.41 ± 0.1% | not timed | not timed | 19906.24 ± 0.3% | 40960.08 ± 0.3% | not timed | not timed | 21108.99 ± 0.2% | | 1.00 | 1.06 | 0.51 |
| folly/literal-never-match-frequent | 0 | 12496.70 ± 1.5% | not timed | not timed | 19850.31 ± 0.4% | 2192.03 ± 1.2% | not timed | not timed | 12556.44 ± 1.5% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3245.61 ± 0.2% | not timed | not timed | 4407.83 ± 0.2% | 3045.97 ± 0.9% | not timed | not timed | 3244.71 ± 0.3% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1317.92 ± 1.8% | not timed | not timed | 948.42 ± 0.3% | 379.05 ± 18.2% | not timed | not timed | 1321.48 ± 0.5% | | 1.00 | 1.39 | 3.48 |
| grep/long-words-ascii | 5073 | 459.09 ± 0.3% | not timed | not timed | 468.32 ± 0.2% | 46.28 ± 6.4% | not timed | not timed | 458.50 ± 0.3% | | 1.00 | 0.98 | 9.92 |
| imported/leipzig/twain | 811 | 20464.60 ± 0.9% | not timed | not timed | 19308.33 ± 0.8% | 11958.67 ± 0.7% | not timed | not timed | 20560.54 ± 1.1% | | 1.00 | 1.06 | 1.71 |
| imported/leipzig/twain-insensitive | 965 | 9022.53 ± 0.8% | not timed | not timed | 4247.50 ± 0.2% | 37.65 ± 2.1% | not timed | not timed | 9064.53 ± 0.9% | | 1.00 | 2.12 | 239.63 |
| imported/leipzig/shing | 1540 | 15225.69 ± 2.4% | not timed | not timed | 13576.35 ± 0.2% | 33.98 ± 0.1% | not timed | not timed | 15518.78 ± 2.5% | | 0.98 | 1.12 | 448.11 |
| imported/leipzig/huck-saw | 262 | 8233.75 ± 3.3% | not timed | not timed | 5611.27 ± 0.1% | 31.71 ± 0.1% | not timed | not timed | 8467.67 ± 3.5% | | 0.97 | 1.47 | 259.67 |
| imported/leipzig/word-ending-nn | 262 | 604.05 ± 0.4% | not timed | not timed | 617.81 ± 0.6% | 24.80 ± 2.6% | not timed | not timed | 599.60 ± 0.8% | | 1.01 | 0.98 | 24.36 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11135.62 ± 1.1% | not timed | not timed | 4557.32 ± 0.7% | 11.49 ± 0.1% | not timed | not timed | 11202.78 ± 1.4% | | 0.99 | 2.44 | 969.36 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7818.28 ± 2.0% | not timed | not timed | 5491.89 ± 0.1% | 16.87 ± 0.2% | not timed | not timed | 7958.73 ± 2.5% | | 0.98 | 1.42 | 463.36 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4161.36 ± 2.1% | not timed | not timed | 415.56 ± 0.7% | 11.12 ± 0.0% | not timed | not timed | 4161.33 ± 3.1% | | 1.00 | 10.01 | 374.30 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.59 ± 0.3% | not timed | not timed | 615.80 ± 0.1% | 11.16 ± 0.1% | not timed | not timed | 602.50 ± 0.5% | | 1.00 | 0.98 | 54.01 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 602.29 ± 0.5% | not timed | not timed | 615.75 ± 0.1% | 9.74 ± 0.0% | not timed | not timed | 602.55 ± 0.5% | | 1.00 | 0.98 | 61.86 |
| imported/leipzig/tom-river | 2 | 6500.16 ± 1.6% | not timed | not timed | 5150.68 ± 0.2% | 31.04 ± 0.3% | not timed | not timed | 6599.23 ± 2.3% | | 0.98 | 1.26 | 209.39 |
| imported/leipzig/ing | 78424 | 600.85 ± 0.6% | not timed | not timed | 570.05 ± 0.1% | 28.20 ± 4.0% | not timed | not timed | 601.47 ± 0.7% | | 1.00 | 1.05 | 21.31 |
| imported/leipzig/ing-whitespace | 55248 | 750.58 ± 0.6% | not timed | not timed | 2065.99 ± 0.4% | 20.52 ± 2.9% | not timed | not timed | 753.42 ± 0.2% | | 1.00 | 0.36 | 36.57 |
| imported/leipzig/awyer-inn | 209 | 768.69 ± 1.5% | not timed | not timed | 4197.62 ± 1.1% | 22.61 ± 0.0% | not timed | not timed | 767.96 ± 1.3% | | 1.00 | 0.18 | 34.00 |
| imported/leipzig/quotes-bounded | 8886 | 2115.71 ± 0.4% | not timed | not timed | 2976.98 ± 0.8% | 38.18 ± 0.1% | not timed | not timed | 2120.58 ± 0.6% | | 1.00 | 0.71 | 55.41 |
| imported/leipzig/non-ascii-alternate | 2 | 12694.20 ± 3.7% | not timed | not timed | 5657.36 ± 0.2% | 51.07 ± 0.1% | not timed | not timed | 12642.04 ± 2.2% | | 1.00 | 2.24 | 248.55 |
| imported/leipzig/math-symbols | 69 | 1982.97 ± 0.2% | not timed | not timed | 614.65 ± 0.1% | 36.47 ± 0.1% | not timed | not timed | 1981.39 ± 0.5% | | 1.00 | 3.23 | 54.37 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.34 ± 1.8% | not timed | not timed | 615.06 ± 0.0% | 22.49 ± 0.2% | not timed | not timed | 585.19 ± 1.5% | | 1.00 | 0.95 | 26.07 |
| imported/lh3lh3-reb/uri | 17549 | 676.94 ± 0.1% | not timed | not timed | 1063.44 ± 0.2% | 28.26 ± 2.2% | not timed | not timed | 676.46 ± 0.1% | | 1.00 | 0.64 | 23.96 |
| imported/lh3lh3-reb/email | 15057 | 673.72 ± 0.2% | not timed | not timed | 1157.78 ± 0.3% | 30.82 ± 0.8% | not timed | not timed | 674.17 ± 0.3% | | 1.00 | 0.58 | 21.86 |
| imported/lh3lh3-reb/date | 668 | 860.09 ± 0.4% | not timed | not timed | 1032.16 ± 0.1% | 51.50 ± 4.0% | not timed | not timed | 860.64 ± 0.2% | | 1.00 | 0.83 | 16.70 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.32 ± 0.2% | not timed | not timed | 422.20 ± 0.2% | 15.84 ± 1.3% | not timed | not timed | 645.33 ± 0.3% | | 1.00 | 1.53 | 40.80 |
| imported/mariomka/email | 92 | 24268.68 ± 1.2% | not timed | not timed | 29565.97 ± 1.1% | 32.84 ± 0.1% | not timed | not timed | 24264.48 ± 1.3% | | 1.00 | 0.82 | 738.96 |
| imported/mariomka/uri | 5301 | 5225.87 ± 2.3% | not timed | not timed | 5955.87 ± 4.5% | 32.66 ± 0.1% | not timed | not timed | 5261.58 ± 2.3% | | 0.99 | 0.88 | 160.03 |
| imported/mariomka/ip | 5 | 2150.57 ± 2.4% | not timed | not timed | 2956.12 ± 1.9% | 21.09 ± 0.3% | not timed | not timed | 2150.26 ± 2.5% | | 1.00 | 0.73 | 101.98 |
| imported/rsc/no-exponential | 0 | 606.62 ± 0.2% | not timed | not timed | 320.18 ± 0.3% | 23.85 ± 0.1% | not timed | not timed | 602.50 ± 0.5% | | 1.01 | 1.89 | 25.43 |
| imported/rsc/literal | 1 | 755.59 ± 2.3% | not timed | not timed | 1584.16 ± 3.5% | 187.11 ± 16.9% | not timed | not timed | 751.76 ± 3.9% | | 1.01 | 0.48 | 4.04 |
| imported/rsc/not-literal | 2 | 781.06 ± 0.3% | not timed | not timed | 736.06 ± 0.5% | 46.26 ± 0.9% | not timed | not timed | 783.25 ± 8.4% | | 1.00 | 1.06 | 16.88 |
| imported/rsc/match-class | 1 | 1440.95 ± 0.3% | not timed | not timed | 1620.84 ± 0.2% | 58.66 ± 12.7% | not timed | not timed | 1438.95 ± 2.2% | | 1.00 | 0.89 | 24.57 |
| imported/rsc/match-class-in-range | 1 | 1446.78 ± 0.2% | not timed | not timed | 2332.41 ± 4.0% | 60.18 ± 7.1% | not timed | not timed | 1438.19 ± 2.5% | | 1.01 | 0.62 | 24.04 |
| imported/rsc/match-class-unicode | 1 | 548.05 ± 0.2% | not timed | not timed | 510.25 ± 0.0% | 72.44 ± 0.5% | not timed | not timed | 548.74 ± 0.2% | | 1.00 | 1.07 | 7.57 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1441.23 ± 0.2% | not timed | not timed | 943.90 ± 0.0% | 228.01 ± 0.6% | not timed | not timed | 1439.46 ± 0.1% | | 1.00 | 1.53 | 6.32 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21614.83 ± 0.1% | not timed | not timed | 14089.97 ± 0.1% | 3433.00 ± 1.5% | not timed | not timed | 21549.62 ± 0.1% | | 1.00 | 1.53 | 6.30 |
| imported/rsc/anchored-literal-short-match | 4 | 709.11 ± 1.6% | not timed | not timed | 490.02 ± 0.3% | 86.51 ± 4.7% | not timed | not timed | 707.44 ± 7.1% | | 1.00 | 1.45 | 8.20 |
| imported/rsc/anchored-literal-long-match | 4 | 10557.97 ± 2.1% | not timed | not timed | 7334.12 ± 0.1% | 1231.39 ± 8.7% | not timed | not timed | 10612.80 ± 1.8% | | 0.99 | 1.44 | 8.57 |
| imported/rsc/one-pass-short | 17 | 373.39 ± 1.0% | not timed | not timed | 215.16 ± 0.2% | 32.05 ± 10.8% | not timed | not timed | 371.04 ± 11.8% | | 1.01 | 1.74 | 11.65 |
| imported/rsc/one-pass-short-not | 17 | 281.32 ± 2.4% | not timed | not timed | 227.56 ± 0.1% | 29.56 ± 10.0% | not timed | not timed | 273.93 ± 2.4% | | 1.03 | 1.24 | 9.52 |
| imported/rsc/one-pass-long-prefix | 26 | 361.34 ± 6.5% | not timed | not timed | 281.98 ± 0.4% | 98.51 ± 18.2% | not timed | not timed | 366.83 ± 1.4% | | 0.99 | 1.28 | 3.67 |
| imported/rsc/one-pass-long-prefix-not | 26 | 363.26 ± 1.9% | not timed | not timed | 280.54 ± 0.2% | 64.93 ± 14.0% | not timed | not timed | 365.95 ± 2.7% | | 0.99 | 1.29 | 5.59 |
| imported/rsc/long-needle1 | 31 | 22206.56 ± 0.0% | not timed | not timed | 20157.78 ± 0.0% | 3.76 ± 0.2% | not timed | not timed | 22214.02 ± 0.0% | | 1.00 | 1.10 | 5900.94 |
| imported/rsc/long-needle2 | 31 | 22332.18 ± 0.1% | not timed | not timed | 216.03 ± 0.6% | 3.76 ± 0.3% | not timed | not timed | 22335.52 ± 0.1% | | 1.00 | 103.38 | 5931.93 |
| imported/rsc/easy0-32 | 26 | 1064.64 ± 11.2% | not timed | not timed | 1622.36 ± 2.0% | 148.33 ± 19.7% | not timed | not timed | 1067.01 ± 2.4% | | 1.00 | 0.66 | 7.18 |
| imported/rsc/easy0-1k | 26 | 14941.02 ± 0.2% | not timed | not timed | 12582.32 ± 1.0% | 2301.70 ± 14.5% | not timed | not timed | 14935.70 ± 1.8% | | 1.00 | 1.19 | 6.49 |
| imported/rsc/easy0-32k | 26 | 23051.34 ± 1.7% | not timed | not timed | 20308.02 ± 0.1% | 18747.17 ± 27.1% | not timed | not timed | 23066.66 ± 0.1% | | 1.00 | 1.14 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 22048.94 ± 1.1% | not timed | not timed | 20124.63 ± 1.7% | 37822.99 ± 1.8% | not timed | not timed | 21918.06 ± 1.5% | | 1.01 | 1.10 | 0.58 |
| imported/rsc/easy1-32 | 19 | 808.84 ± 2.2% | not timed | not timed | 637.70 ± 0.2% | 130.79 ± 19.0% | not timed | not timed | 787.01 ± 2.1% | | 1.03 | 1.27 | 6.18 |
| imported/rsc/easy1-1k | 19 | 16462.67 ± 2.7% | not timed | not timed | 12986.00 ± 0.3% | 2505.94 ± 16.6% | not timed | not timed | 16087.04 ± 0.3% | | 1.02 | 1.27 | 6.57 |
| imported/rsc/easy1-32k | 19 | 517234.30 ± 0.3% | not timed | not timed | 406838.47 ± 0.1% | 20473.73 ± 0.8% | not timed | not timed | 505657.94 ± 0.1% | | 1.02 | 1.27 | 25.26 |
| imported/rsc/easy1-1mb | 19 | 16577377.25 ± 0.2% | not timed | not timed | 13021446.37 ± 0.3% | 39484.79 ± 1.6% | not timed | not timed | 16198065.51 ± 0.2% | | 1.02 | 1.27 | 419.84 |
| imported/rsc/medium-32 | 27 | 767.51 ± 1.7% | not timed | not timed | 638.85 ± 0.5% | 69.80 ± 12.6% | not timed | not timed | 760.08 ± 0.5% | | 1.01 | 1.20 | 11.00 |
| imported/rsc/medium-1k | 27 | 13663.77 ± 0.5% | not timed | not timed | 11460.15 ± 0.2% | 72.58 ± 0.4% | not timed | not timed | 13548.71 ± 0.2% | | 1.01 | 1.19 | 188.25 |
| imported/rsc/medium-32k | 27 | 428034.87 ± 0.4% | not timed | not timed | 353167.91 ± 0.2% | 48.50 ± 0.2% | not timed | not timed | 422539.17 ± 0.2% | | 1.01 | 1.21 | 8824.76 |
| imported/rsc/medium-1mb | 27 | 13669113.93 ± 0.8% | not timed | not timed | 11231563.41 ± 0.7% | 48.46 ± 0.3% | not timed | not timed | 13524471.75 ± 0.6% | | 1.01 | 1.22 | 282057.88 |
| imported/rsc/hard-32 | 58 | 421.16 ± 2.0% | not timed | not timed | 370.80 ± 0.1% | 49.75 ± 7.9% | not timed | not timed | 416.51 ± 0.2% | | 1.01 | 1.14 | 8.47 |
| imported/rsc/hard-1k | 27 | 13428.33 ± 0.2% | not timed | not timed | 11691.07 ± 0.1% | 40.88 ± 0.0% | not timed | not timed | 13216.38 ± 0.2% | | 1.02 | 1.15 | 328.48 |
| imported/rsc/hard-32k | 27 | 417526.75 ± 0.3% | not timed | not timed | 366267.86 ± 0.2% | 29.39 ± 0.1% | not timed | not timed | 413033.09 ± 0.0% | | 1.01 | 1.14 | 14206.59 |
| imported/rsc/hard-1mb | 51 | 8404240.56 ± 0.3% | not timed | not timed | 7276611.23 ± 0.2% | 29.42 ± 0.1% | not timed | not timed | 8279311.36 ± 0.2% | | 1.02 | 1.15 | 285712.03 |
| imported/rsc/reallyhard0-32 | 58 | 266.09 ± 0.3% | not timed | not timed | 224.47 ± 0.1% | 49.73 ± 7.2% | not timed | not timed | 268.36 ± 2.7% | | 0.99 | 1.19 | 5.35 |
| imported/rsc/reallyhard0-1k | 27 | 592.24 ± 0.2% | not timed | not timed | 581.24 ± 0.4% | 40.69 ± 0.1% | not timed | not timed | 591.11 ± 0.1% | | 1.00 | 1.02 | 14.55 |
| imported/rsc/reallyhard0-32k | 27 | 609.85 ± 0.1% | not timed | not timed | 613.15 ± 0.1% | 29.36 ± 0.1% | not timed | not timed | 609.82 ± 0.4% | | 1.00 | 0.99 | 20.77 |
| imported/rsc/reallyhard0-1mb | 51 | 594.77 ± 0.9% | not timed | not timed | 618.29 ± 0.1% | 29.41 ± 0.1% | not timed | not timed | 594.69 ± 1.0% | | 1.00 | 0.96 | 20.22 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.82 ± 1.8% | not timed | not timed | 196.04 ± 0.8% | 60.75 ± 16.3% | not timed | not timed | 288.76 ± 3.4% | | 1.00 | 1.47 | 4.75 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6778.70 ± 0.2% | not timed | not timed | 5965.20 ± 0.2% | 33.79 ± 2.4% | not timed | not timed | 6776.02 ± 0.0% | | 1.00 | 1.14 | 200.60 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21492.29 ± 0.1% | not timed | not timed | 19272.74 ± 0.1% | 24.08 ± 3.6% | not timed | not timed | 21503.28 ± 0.0% | | 1.00 | 1.12 | 892.39 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21925.55 ± 0.7% | not timed | not timed | 19967.27 ± 1.8% | 25.17 ± 0.2% | not timed | not timed | 21958.91 ± 1.1% | | 1.00 | 1.10 | 871.12 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.77 ± 1.5% | not timed | not timed | 214.45 ± 0.2% | 60.72 ± 11.4% | not timed | not timed | 282.91 ± 1.3% | | 1.00 | 1.32 | 4.66 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5887.25 ± 0.1% | not timed | not timed | 6263.30 ± 0.3% | 34.49 ± 0.3% | not timed | not timed | 5871.94 ± 0.0% | | 1.00 | 0.94 | 170.68 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21402.13 ± 0.3% | not timed | not timed | 19268.28 ± 0.1% | 24.54 ± 1.8% | not timed | not timed | 21396.31 ± 0.1% | | 1.00 | 1.11 | 872.25 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21449.29 ± 0.9% | not timed | not timed | 19837.88 ± 0.5% | 25.14 ± 5.0% | not timed | not timed | 21497.24 ± 1.1% | | 1.00 | 1.08 | 853.29 |
| imported/sherlock/name-sherlock | 776 | 19764.59 ± 2.5% | not timed | not timed | 18438.91 ± 0.7% | 8943.20 ± 22.1% | not timed | not timed | 19777.08 ± 2.9% | | 1.00 | 1.07 | 2.21 |
| imported/sherlock/name-holmes | 2766 | 14665.90 ± 5.1% | not timed | not timed | 15494.05 ± 1.4% | 3216.98 ± 9.2% | not timed | not timed | 15285.45 ± 4.7% | | 0.96 | 0.95 | 4.56 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19710.70 ± 2.3% | not timed | not timed | 18401.27 ± 0.7% | 8070.57 ± 34.6% | not timed | not timed | 19758.97 ± 0.5% | | 1.00 | 1.07 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15767.15 ± 0.7% | not timed | not timed | 4011.19 ± 0.4% | 32.60 ± 0.6% | not timed | not timed | 15775.87 ± 0.8% | | 1.00 | 3.93 | 483.60 |
| imported/sherlock/name-holmes-casei | 2802 | 9482.55 ± 5.2% | not timed | not timed | 3308.96 ± 0.0% | 37.67 ± 0.1% | not timed | not timed | 9480.45 ± 4.7% | | 1.00 | 2.87 | 251.74 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13069.21 ± 8.4% | not timed | not timed | 3944.84 ± 0.1% | 32.38 ± 0.1% | not timed | not timed | 13111.85 ± 1.8% | | 1.00 | 3.31 | 403.64 |
| imported/sherlock/name-whitespace | 1461 | 15326.12 ± 6.2% | not timed | not timed | 14243.19 ± 0.4% | 7412.08 ± 23.6% | not timed | not timed | 15378.91 ± 8.0% | | 1.00 | 1.08 | 2.07 |
| imported/sherlock/name-alt1 | 1142 | 11639.85 ± 2.2% | not timed | not timed | 16131.93 ± 0.6% | 4117.81 ± 25.2% | not timed | not timed | 11655.04 ± 0.3% | | 1.00 | 0.72 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8977.78 ± 0.5% | not timed | not timed | 3827.67 ± 0.1% | 31.27 ± 0.3% | not timed | not timed | 8986.52 ± 0.5% | | 1.00 | 2.35 | 287.09 |
| imported/sherlock/name-alt3 | 4507 | 5574.80 ± 0.6% | not timed | not timed | 3631.79 ± 0.1% | 9.95 ± 0.1% | not timed | not timed | 5577.67 ± 0.4% | | 1.00 | 1.54 | 560.15 |
| imported/sherlock/name-alt3-casei | 4593 | 1529.13 ± 2.2% | not timed | not timed | 285.86 ± 0.2% | 6.48 ± 0.1% | not timed | not timed | 1533.91 ± 1.1% | | 1.00 | 5.35 | 235.92 |
| imported/sherlock/name-alt4 | 3686 | 6407.14 ± 0.3% | not timed | not timed | 3776.43 ± 0.2% | 31.39 ± 0.2% | not timed | not timed | 6401.12 ± 0.4% | | 1.00 | 1.70 | 204.12 |
| imported/sherlock/name-alt4-casei | 4254 | 2808.41 ± 1.5% | not timed | not timed | 2578.06 ± 0.2% | 19.87 ± 13.2% | not timed | not timed | 2820.17 ± 3.8% | | 1.00 | 1.09 | 141.32 |
| imported/sherlock/name-alt5 | 4028 | 6447.41 ± 0.4% | not timed | not timed | 3746.51 ± 0.1% | 21.69 ± 0.0% | not timed | not timed | 6448.60 ± 0.4% | | 1.00 | 1.72 | 297.24 |
| imported/sherlock/name-alt5-casei | 4104 | 3512.57 ± 1.6% | not timed | not timed | 2223.87 ± 0.5% | 14.36 ± 0.2% | not timed | not timed | 3521.70 ± 0.9% | | 1.00 | 1.58 | 244.61 |
| imported/sherlock/no-match-uncommon | 0 | 21554.13 ± 0.9% | not timed | not timed | 19347.05 ± 1.2% | 34766.28 ± 0.7% | not timed | not timed | 21525.04 ± 1.0% | | 1.00 | 1.11 | 0.62 |
| imported/sherlock/no-match-common | 0 | 21223.35 ± 0.6% | not timed | not timed | 19355.16 ± 0.8% | 1283.71 ± 1.4% | not timed | not timed | 21259.98 ± 0.3% | | 1.00 | 1.10 | 16.53 |
| imported/sherlock/no-match-really-common | 0 | 16014.28 ± 3.1% | not timed | not timed | 18676.53 ± 1.3% | 1283.06 ± 1.0% | not timed | not timed | 16155.25 ± 4.5% | | 0.99 | 0.86 | 12.48 |
| imported/sherlock/the-lower | 21654 | 2322.62 ± 1.2% | not timed | not timed | 2322.68 ± 0.2% | 237.77 ± 21.1% | not timed | not timed | 2328.56 ± 0.8% | | 1.00 | 1.00 | 9.77 |
| imported/sherlock/the-upper | 2223 | 12657.54 ± 7.6% | not timed | not timed | 13492.53 ± 0.4% | 2560.10 ± 15.7% | not timed | not timed | 12772.23 ± 1.1% | | 0.99 | 0.94 | 4.94 |
| imported/sherlock/the-casei | 23961 | 2015.76 ± 0.3% | not timed | not timed | 1316.84 ± 0.3% | 35.19 ± 0.4% | not timed | not timed | 2017.74 ± 0.3% | | 1.00 | 1.53 | 57.29 |
| imported/sherlock/everything-greedy | 581881 | 283.48 ± 0.2% | not timed | not timed | 165.96 ± 0.1% | 28.43 ± 34.8% | not timed | not timed | 282.86 ± 1.4% | | 1.00 | 1.71 | 9.97 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.78 ± 0.1% | not timed | not timed | 212.38 ± 0.4% | 32.96 ± 0.1% | not timed | not timed | 462.39 ± 0.1% | | 1.00 | 2.18 | 14.04 |
| imported/sherlock/letters | 447175 | 62.19 ± 1.5% | not timed | not timed | 32.94 ± 0.1% | 6.64 ± 17.4% | not timed | not timed | 62.10 ± 0.3% | | 1.00 | 1.89 | 9.37 |
| imported/sherlock/letters-upper | 14180 | 453.35 ± 1.2% | not timed | not timed | 371.87 ± 0.0% | 29.55 ± 23.7% | not timed | not timed | 453.01 ± 0.1% | | 1.00 | 1.22 | 15.34 |
| imported/sherlock/letters-lower | 432995 | 62.97 ± 1.1% | not timed | not timed | 33.90 ± 0.1% | 6.84 ± 40.3% | not timed | not timed | 63.09 ± 0.5% | | 1.00 | 1.86 | 9.21 |
| imported/sherlock/words | 447639 | 115.60 ± 1.2% | not timed | not timed | 82.86 ± 0.2% | 13.89 ± 4.3% | not timed | not timed | 116.04 ± 0.9% | | 1.00 | 1.40 | 8.32 |
| imported/sherlock/before-holmes | 4073 | 10267.77 ± 0.8% | not timed | not timed | 8427.37 ± 0.4% | 23.88 ± 1.2% | not timed | not timed | 10298.99 ± 0.4% | | 1.00 | 1.22 | 430.04 |
| imported/sherlock/before-after-holmes | 2593 | 9861.91 ± 0.5% | not timed | not timed | 9514.65 ± 0.2% | 23.86 ± 1.6% | not timed | not timed | 9861.02 ± 0.6% | | 1.00 | 1.04 | 413.40 |
| imported/sherlock/holmes-cochar-watson | 150 | 5193.46 ± 0.2% | not timed | not timed | 3430.46 ± 0.1% | 31.03 ± 0.2% | not timed | not timed | 5204.55 ± 0.2% | | 1.00 | 1.51 | 167.38 |
| imported/sherlock/holmes-coword-watson | 14309 | 1192.14 ± 0.5% | not timed | not timed | 1124.23 ± 0.2% | 6.79 ± 0.3% | not timed | not timed | 1188.55 ± 0.4% | | 1.00 | 1.06 | 175.50 |
| imported/sherlock/quotes | 14437 | 1396.07 ± 0.9% | not timed | not timed | 1759.28 ± 0.9% | 35.08 ± 0.5% | not timed | not timed | 1398.17 ± 0.4% | | 1.00 | 0.79 | 39.80 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 610.03 ± 0.1% | not timed | not timed | 16056.00 ± 0.5% | 36.73 ± 0.3% | not timed | not timed | 609.87 ± 0.0% | | 1.00 | 0.0380 | 16.61 |
| imported/sherlock/word-ending-n | 35297 | 479.90 ± 0.1% | not timed | not timed | 408.94 ± 0.1% | 23.43 ± 1.2% | not timed | not timed | 390.94 ± 0.4% | | 1.23 | 1.17 | 20.48 |
| imported/sherlock/repeated-class-negation | 2130 | 14572.84 ± 0.8% | not timed | not timed | 10962.88 ± 0.3% | 11.56 ± 0.2% | not timed | not timed | 14611.82 ± 0.8% | | 1.00 | 1.33 | 1260.12 |
| imported/sherlock/ing-suffix | 20547 | 566.05 ± 0.4% | not timed | not timed | 516.99 ± 0.1% | 28.88 ± 29.4% | not timed | not timed | 566.56 ± 1.9% | | 1.00 | 1.09 | 19.60 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.91 ± 0.4% | not timed | not timed | 2094.82 ± 0.2% | 20.55 ± 0.0% | not timed | not timed | 608.42 ± 0.3% | | 1.00 | 0.29 | 29.58 |
| opt/accelerate/whole-line | 239963 | 458.38 ± 0.1% | not timed | not timed | 373.49 ± 0.2% | 92.49 ± 16.7% | not timed | not timed | 458.41 ± 0.4% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 426.45 ± 2.0% | not timed | not timed | 394.98 ± 0.1% | 29.41 ± 21.2% | not timed | not timed | 427.92 ± 0.5% | | 1.00 | 1.08 | 14.50 |
| opt/backtrack/words-english | 40536 | 136.26 ± 1.3% | not timed | not timed | 92.17 ± 0.1% | 19.79 ± 8.0% | not timed | not timed | 136.27 ± 1.9% | | 1.00 | 1.48 | 6.88 |
| opt/fixed-length/too-small-ascii | 0 | 311.93 ± 0.1% | not timed | not timed | 681.51 ± 2.0% | 80.14 ± 0.6% | not timed | not timed | 314.57 ± 0.3% | | 0.99 | 0.46 | 3.89 |
| opt/fixed-length/too-big-ascii | 0 | 3505.97 ± 0.4% | not timed | not timed | 5829.75 ± 0.2% | 120.48 ± 0.3% | not timed | not timed | 3482.53 ± 0.3% | | 1.01 | 0.60 | 29.10 |
| opt/fixed-length/go33484-1 | 0 | 672428.15 ± 0.5% | not timed | not timed | 1108862.12 ± 0.4% | 61358.97 ± 0.7% | not timed | not timed | 669365.95 ± 0.3% | | 1.00 | 0.61 | 10.96 |
| opt/fixed-length/go33484-2 | 0 | 672700.79 ± 0.2% | not timed | not timed | 1108702.66 ± 0.2% | 32028.09 ± 0.7% | not timed | not timed | 669521.52 ± 0.4% | | 1.00 | 0.61 | 21.00 |
| opt/fixed-length/go33484-3 | 0 | 2442.93 ± 2.9% | not timed | not timed | 111789.34 ± 0.1% | 756.62 ± 0.6% | not timed | not timed | 2498.04 ± 2.6% | | 0.98 | 0.0219 | 3.23 |
| opt/literal-alt/one-pattern | 1 | 550.65 ± 1.7% | not timed | not timed | 543.05 ± 0.1% | 0.39 ± 0.2% | not timed | not timed | 551.83 ± 1.2% | | 1.00 | 1.01 | 1404.35 |
| opt/onepass/fn-predicate | 916 | 370.27 ± 0.8% | not timed | not timed | 336.26 ± 0.1% | 202.06 ± 14.9% | not timed | not timed | 373.48 ± 0.3% | | 0.99 | 1.10 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 174.78 ± 2.0% | not timed | not timed | 199.71 ± 0.2% | 77.49 ± 13.0% | not timed | not timed | 176.80 ± 1.0% | | 0.99 | 0.88 | 2.26 |
| opt/prefilter/literal-english | 1 | 20931.48 ± 0.3% | not timed | not timed | 20126.69 ± 0.2% | 17678.47 ± 0.3% | not timed | not timed | 20955.12 ± 0.2% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14641.56 ± 0.6% | not timed | not timed | 4318.97 ± 0.1% | 32.66 ± 0.3% | not timed | not timed | 14653.70 ± 0.3% | | 1.00 | 3.39 | 448.36 |
| opt/prefilter/literal-russian | 1 | 21417.95 ± 0.7% | not timed | not timed | 19925.23 ± 0.6% | 3325.20 ± 0.1% | not timed | not timed | 21431.31 ± 0.3% | | 1.00 | 1.07 | 6.44 |
| opt/prefilter/literal-casei-russian | 1 | 8568.76 ± 0.4% | not timed | not timed | 3891.72 ± 0.2% | 31.71 ± 0.2% | not timed | not timed | 8578.38 ± 0.3% | | 1.00 | 2.20 | 270.19 |
| opt/prefilter/rust-functions | 948 | 6779.37 ± 0.9% | not timed | not timed | 8997.80 ± 0.8% | 1865.64 ± 0.4% | not timed | not timed | 6806.05 ± 0.7% | | 1.00 | 0.75 | 3.63 |
| opt/reverse-anchored/word-end | 1 | 29947021.73 ± 0.1% | not timed | not timed | 21678293.41 ± 0.3% | 50.33 ± 0.2% | not timed | not timed | 29403876.86 ± 0.1% | | 1.02 | 1.38 | 594978.84 |
| opt/reverse-inner/holmes | 2593 | 9837.22 ± 0.8% | not timed | not timed | 9480.49 ± 0.3% | 24.00 ± 1.1% | not timed | not timed | 9854.59 ± 1.0% | | 1.00 | 1.04 | 409.84 |
| opt/reverse-inner/email | 47 | 36157.41 ± 1.7% | not timed | not timed | 44814.83 ± 0.7% | 32.42 ± 0.2% | not timed | not timed | 36740.24 ± 2.1% | | 0.98 | 0.81 | 1115.39 |
| opt/reverse-inner/factored-prefix | 3542 | 601.49 ± 0.1% | not timed | not timed | 595.17 ± 0.1% | 12.55 ± 0.2% | not timed | not timed | 600.72 ± 0.2% | | 1.00 | 1.01 | 47.94 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5556.20 ± 0.1% | not timed | not timed | 614.26 ± 0.5% | 75.40 ± 0.1% | not timed | not timed | 5531.38 ± 0.0% | | 1.00 | 9.05 | 73.69 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.86 ± 2.3% | not timed | not timed | 288.10 ± 0.1% | 24.75 ± 0.1% | not timed | not timed | 688.43 ± 3.5% | | 1.00 | 2.39 | 27.80 |
| opt/reverse-suffix/holmes | 4073 | 10252.66 ± 0.7% | not timed | not timed | 8434.23 ± 0.2% | 23.80 ± 1.7% | not timed | not timed | 10305.49 ± 0.4% | | 0.99 | 1.22 | 430.79 |
| opt/reverse-suffix/no-quadratic | 0 | 5532.98 ± 0.1% | not timed | not timed | 615.08 ± 0.1% | 75.12 ± 0.1% | not timed | not timed | 5561.25 ± 0.0% | | 0.99 | 9.00 | 73.66 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 122.18 ± 6.9% | not timed | not timed | 131.28 ± 0.1% | 13.29 ± 17.3% | not timed | not timed | 122.73 ± 2.0% | | 1.00 | 0.93 | 9.20 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.10 ± 2.8% | not timed | not timed | 132.61 ± 0.1% | 12.98 ± 71.6% | not timed | not timed | 116.75 ± 0.4% | | 1.03 | 0.91 | 9.25 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.2% | 110.84 ± 0.3% | not timed | not timed | 0.28 ± 0.6% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.66 ± 0.4% | not timed | not timed | 294.36 ± 0.2% | 103.08 ± 0.1% | not timed | not timed | 316.30 ± 0.3% | | 1.00 | 1.08 | 3.08 |
| reported/i13-subset-regex/original-ascii | 4094 | 11135.41 ± 2.8% | not timed | not timed | 4537.69 ± 2.2% | 11.48 ± 0.1% | not timed | not timed | 11210.83 ± 2.0% | | 0.99 | 2.45 | 969.75 |
| reported/i13-subset-regex/original-unicode | 4094 | 10955.88 ± 3.2% | not timed | not timed | 253.57 ± 3.1% | 11.50 ± 1.2% | not timed | not timed | 11129.40 ± 1.0% | | 0.98 | 43.21 | 952.74 |
| reported/i13-subset-regex/big-ascii | 1955 | 10620.68 ± 1.5% | not timed | not timed | 68.29 ± 3.5% | 9.76 ± 0.0% | not timed | not timed | 10701.78 ± 0.6% | | 0.99 | 155.52 | 1088.65 |
| reported/i13-subset-regex/big-unicode | 1955 | 10631.07 ± 1.3% | not timed | not timed | 12.20 ± 54.9% | 9.84 ± 0.2% | not timed | not timed | 10713.86 ± 0.9% | | 0.99 | 871.65 | 1080.54 |
| reported/i13-subset-regex/huge-ascii | 55 | 10098.27 ± 3.3% | not timed | not timed | 11.02 ± 0.0% | 8.76 ± 0.3% | not timed | not timed | 9864.00 ± 3.8% | | 1.02 | 916.37 | 1152.65 |
| reported/i13-subset-regex/huge-unicode | 55 | 9915.69 ± 2.8% | not timed | not timed | 10.95 ± 0.3% | 8.78 ± 0.1% | not timed | not timed | 9891.21 ± 3.0% | | 1.00 | 905.21 | 1129.25 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.57 ± 0.0% | not timed | not timed | 11.04 ± 0.0% | 8.77 ± 1.1% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.1% | not timed | not timed | 11.00 ± 0.3% | 8.75 ± 0.6% | not timed | not timed | 5.04 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 487.19 ± 0.4% | not timed | not timed | 104.36 ± 0.1% | 6.65 ± 0.2% | not timed | not timed | 487.36 ± 0.5% | | 1.00 | 4.67 | 73.26 |
| reported/i787-keywords/opt-ascii | 5674 | 488.64 ± 0.2% | not timed | not timed | 273.19 ± 0.3% | 10.30 ± 0.6% | not timed | not timed | 488.29 ± 0.3% | | 1.00 | 1.79 | 47.43 |
| slow/quadratic-regex-1x | 100 | 7.13 ± 0.2% | not timed | not timed | 4.94 ± 0.1% | 0.05 ± 0.2% | not timed | not timed | 7.14 ± 0.0% | | 1.00 | 1.44 | 144.38 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.0% | not timed | not timed | 2.75 ± 0.1% | 0.01 ± 10.7% | not timed | not timed | 3.42 ± 1.3% | | 1.00 | 1.25 | 268.64 |
| slow/quadratic-haystack-1x | 100 | 21.21 ± 0.9% | not timed | not timed | 9.98 ± 0.3% | 1.02 ± 8.5% | not timed | not timed | 21.26 ± 8.2% | | 1.00 | 2.13 | 20.86 |
| slow/quadratic-haystack-2x | 200 | 17.61 ± 13.1% | not timed | not timed | 5.56 ± 0.3% | 0.55 ± 1.7% | not timed | not timed | 17.89 ± 2.2% | | 0.98 | 3.17 | 32.21 |
| unicode/codepoints/any-one | 1112064 | 289.21 ± 0.3% | not timed | not timed | 175.57 ± 0.1% | 18.54 ± 2.0% | not timed | not timed | 289.81 ± 0.2% | | 1.00 | 1.65 | 15.60 |
| unicode/codepoints/any-all | 4382592 | 270.33 ± 2.0% | not timed | not timed | 246.42 ± 0.2% | 117.18 ± 0.2% | not timed | not timed | 270.04 ± 0.2% | | 1.00 | 1.10 | 2.31 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.77 ± 0.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 603.96 ± 0.4% | not timed | not timed | 616.01 ± 0.3% | 135.27 ± 0.4% | not timed | not timed | 603.45 ± 0.7% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.66 ± 0.2% | not timed | not timed | 38.87 ± 0.2% | 3.94 ± 1.1% | not timed | not timed | 31.62 ± 0.2% | | 1.00 | 0.81 | 8.03 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 4.11 ± 0.5% | 2.36 ± 0.1% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.35 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.5% | not timed | not timed | 4.13 ± 0.2% | 6.32 ± 10.4% | not timed | not timed | 1.29 ± 0.4% | | 0.99 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 128.80 ± 3.3% | not timed | not timed | 82.65 ± 0.2% | 11.74 ± 17.4% | not timed | not timed | 128.50 ± 0.6% | | 1.00 | 1.56 | 10.97 |
| unicode/word/boundary-long-english | 3466 | 615.81 ± 0.1% | not timed | not timed | 607.11 ± 0.1% | 32.22 ± 0.5% | not timed | not timed | 615.96 ± 0.1% | | 1.00 | 1.01 | 19.11 |
| unicode/word/around-holmes-english | 27 | 20065.82 ± 0.3% | not timed | not timed | 19821.04 ± 0.4% | 22.10 ± 0.9% | not timed | not timed | 20094.76 ± 0.2% | | 1.00 | 1.01 | 907.96 |
| wild/bibleref/long | 874 | 564.02 ± 0.2% | not timed | not timed | 584.13 ± 0.1% | 6.77 ± 0.5% | not timed | not timed | 564.38 ± 0.1% | | 1.00 | 0.97 | 83.30 |
| wild/bibleref/short | 30 | 24.80 ± 4.0% | not timed | not timed | 30.71 ± 1.0% | 14.22 ± 10.2% | not timed | not timed | 25.50 ± 2.5% | | 0.97 | 0.81 | 1.74 |
| wild/bibleref/line | 874 | 393.85 ± 0.2% | not timed | not timed | 213.55 ± 0.2% | 9.14 ± 0.3% | not timed | not timed | 394.23 ± 0.1% | | 1.00 | 1.84 | 43.10 |
| wild/caddy/caddy | 6 | 417.87 ± 9.1% | not timed | not timed | 247.31 ± 0.2% | 68.12 ± 13.6% | not timed | not timed | 416.83 ± 0.1% | | 1.00 | 1.69 | 6.13 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.79 ± 0.2% | not timed | not timed | 350.97 ± 0.3% | 13.50 ± 0.1% | not timed | not timed | 1071.01 ± 0.1% | | 1.00 | 3.05 | 79.30 |
| wild/ruff/noqa | 84 | 436.52 ± 0.5% | not timed | not timed | 461.88 ± 0.1% | 19.76 ± 2.0% | not timed | not timed | 433.84 ± 2.3% | | 1.01 | 0.95 | 22.10 |
| wild/ruff/unnecessary-coding-comment | 16 | 961.50 ± 0.5% | not timed | not timed | 703.45 ± 0.1% | 136.38 ± 3.8% | not timed | not timed | 958.94 ± 0.5% | | 1.00 | 1.37 | 7.05 |
| wild/ruff/string-quote-prefix | 2972 | 1357.15 ± 0.6% | not timed | not timed | 439.83 ± 0.1% | 314.59 ± 25.7% | not timed | not timed | 1358.16 ± 0.6% | | 1.00 | 3.09 | 4.31 |
| wild/ruff/space-around-operator | 1224378 | 220.17 ± 1.8% | not timed | not timed | 187.11 ± 0.1% | 18.41 ± 1.6% | not timed | not timed | 220.97 ± 1.8% | | 1.00 | 1.18 | 11.96 |
| wild/ruff/shebang | 282 | 984.16 ± 0.4% | not timed | not timed | 328.72 ± 0.1% | 111.93 ± 9.4% | not timed | not timed | 988.92 ± 0.5% | | 1.00 | 2.99 | 8.79 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13829.60 ± 0.2% | not timed | not timed | 13866.54 ± 0.2% | 6950.97 ± 0.7% | not timed | not timed | 13845.07 ± 0.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12861.46 ± 0.3% | not timed | not timed | 13538.82 ± 0.5% | 6426.52 ± 0.5% | not timed | not timed | 12868.42 ± 0.5% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13228.72 ± 0.3% | not timed | not timed | 13736.78 ± 0.3% | 6677.60 ± 1.2% | not timed | not timed | 13227.75 ± 0.3% | | 1.00 | 0.96 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9568.08 ± 0.3% | not timed | not timed | 13652.23 ± 0.2% | 6786.59 ± 1.3% | not timed | not timed | 9576.51 ± 0.1% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 123.35 ± 14.5% | not timed | not timed | 66.17 ± 0.7% | 2.24 ± 0.7% | not timed | not timed | 123.06 ± 13.5% | | 1.00 | 1.86 | 54.95 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.4% | not timed | not timed | 0.01 ± 1.7% | 0.01 ± 20.9% | not timed | not timed | 0.03 ± 73.9% | | 0.98 | 3.09 | 3.98 |
| dictionary/compile/english-15 | 1 | 0.35 ± 17.5% | not timed | not timed | 0.07 ± 1.6% | 0.10 ± 33.2% | not timed | not timed | 0.35 ± 1.0% | | 1.00 | 5.04 | 3.33 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 5.1% | not timed | not timed | 0.02 ± 0.6% | 34.93 ± 13.9% | not timed | not timed | 0.25 ± 14.2% | | 0.98 | 12.94 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.26 ± 5.3% | not timed | not timed | 11.53 ± 0.2% | 62.18 ± 23.4% | not timed | not timed | 47.40 ± 2.4% | | 1.00 | 4.10 | 0.76 |
| reported/i787-keywords/compile | 1 | 34.11 ± 17.6% | not timed | not timed | 2.15 ± 0.9% | 16.32 ± 38.1% | not timed | not timed | 34.60 ± 0.7% | | 0.99 | 15.90 | 2.09 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 364.99 ± 1.8% | not timed | not timed | 118.14 ± 0.2% | 578.18 ± 16.0% | not timed | not timed | 369.25 ± 3.5% | | 0.99 | 3.09 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.72 ± 0.7% | not timed | not timed | 4.15 ± 0.6% | 42.59 ± 2.7% | not timed | not timed | 47.93 ± 0.8% | | 1.00 | 11.50 | 1.12 |
| unicode/compile/one-letter | 53 | 6.70 ± 2.4% | not timed | not timed | 4.60 ± 0.3% | 65.52 ± 8.6% | not timed | not timed | 6.70 ± 13.4% | | 1.00 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 19.0% | not timed | not timed | 0.10 ± 1.0% | 65.75 ± 9.7% | not timed | not timed | 1.09 ± 13.2% | | 0.99 | 10.86 | 0.0164 |
| unicode/compile/fifty-letters-ascii | 1 | 220.32 ± 3.6% | not timed | not timed | 52.18 ± 0.3% | 188.49 ± 21.7% | not timed | not timed | 221.61 ± 3.5% | | 0.99 | 4.22 | 1.17 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 380.73 ± 23.7% | not timed | not timed | 47.36 ± 0.3% | 680.38 ± 16.7% | not timed | not timed | 386.83 ± 8.4% | | 0.98 | 8.04 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 603.22 ± 12.4% | not timed | not timed | 146.92 ± 0.2% | 672.18 ± 22.3% | not timed | not timed | 618.83 ± 20.3% | | 0.97 | 4.11 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 317.59 ± 4.5% | not timed | not timed | 51.05 ± 0.9% | 1242.49 ± 5.1% | not timed | not timed | 331.11 ± 3.9% | | 0.96 | 6.22 | 0.26 |
| wild/bibleref/compile | 3 | 5.83 ± 19.2% | not timed | not timed | 1.96 ± 0.5% | 31.53 ± 19.8% | not timed | not timed | 5.88 ± 4.9% | | 0.99 | 2.97 | 0.18 |
| wild/url/compile | 1 | 0.55 ± 15.7% | not timed | not timed | 0.14 ± 1.2% | 0.46 ± 9.6% | not timed | not timed | 0.63 ± 19.3% | | 0.86 | 3.76 | 1.18 |

