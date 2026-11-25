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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506983354 |
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
| literal: a word | 217 | 19454.58 ± 4.4% | 5086.24 ± 0.2% | 28.19 ± 0.6% | 17822.70 ± 4.4% | 9156.84 ± 10.5% | 17.39 ± 0.2% | 86.05 ± 0.2% | 19250.48 ± 4.5% | 3.82 | 1.01 | 1.09 | 2.12 |
| literal: a word that is not there | 0 | 21152.29 ± 4.1% | 4914.59 ± 0.6% | 28.22 ± 0.5% | 19262.75 ± 5.3% | 27894.70 ± 4.3% | 17.11 ± 0.1% | 82.11 ± 0.3% | 21165.05 ± 3.8% | 4.30 | 1.00 | 1.10 | 0.76 |
| literal: one of four words | 661 | 6289.25 ± 2.9% | 1967.63 ± 0.6% | 14.33 ± 0.1% | 3932.39 ± 0.5% | 21.88 ± 0.2% | 5.41 ± 0.1% | 6.78 ± 0.3% | 6307.38 ± 2.7% | 3.20 | 1.00 | 1.60 | 287.39 |
| literal: a word in any case | 217 | 15069.46 ± 0.7% | 2100.90 ± 0.1% | 21.43 ± 0.6% | 3971.70 ± 0.2% | 38.05 ± 0.3% | refused | differs | 15136.79 ± 1.7% | 7.17 | 1.00 | 3.79 | 396.05 |
| literal: an href attribute | 33 | 16524.84 ± 2.6% | 617.76 ± 0.5% | 27.38 ± 0.3% | 16738.45 ± 2.7% | 2258.31 ± 0.8% | 13.07 ± 0.1% | 75.31 ± 0.4% | 16570.59 ± 3.5% | 26.75 | 1.00 | 0.99 | 7.32 |
| literal: a word, second text | 123 | 19713.99 ± 5.4% | 3421.25 ± 0.2% | 28.08 ± 0.3% | 18112.97 ± 5.0% | 7628.24 ± 6.4% | 20.10 ± 0.2% | 69.77 ± 0.3% | 19365.54 ± 2.6% | 5.76 | 1.02 | 1.09 | 2.58 |
| class: two capitalized words | 1331 | 1065.51 ± 0.4% | 609.50 ± 0.8% | 26.03 ± 0.2% | 585.39 ± 0.1% | 40.62 ± 13.0% | 14.75 ± 0.1% | 68.31 ± 0.1% | 1063.92 ± 0.7% | 1.75 | 1.00 | 1.82 | 26.23 |
| class: a word that ends in ing | 3399 | 583.00 ± 0.1% | 582.77 ± 0.2% | 17.98 ± 0.4% | 547.77 ± 0.1% | 29.62 ± 8.3% | 8.21 ± 0.2% | 18.22 ± 0.3% | 583.62 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.68 |
| class: a word in capitals | 2332 | 1391.51 ± 0.6% | 614.87 ± 0.1% | 27.54 ± 0.6% | 572.10 ± 1.0% | 43.54 ± 16.7% | 17.15 ± 0.4% | 83.04 ± 0.3% | 1390.70 ± 0.4% | 2.26 | 1.00 | 2.43 | 31.96 |
| class: a number | 8288 | 2125.82 ± 0.4% | 852.62 ± 0.2% | 27.74 ± 0.4% | 1721.59 ± 0.2% | 42.43 ± 17.3% | 0.55 ± 0.1% | 57.03 ± 0.1% | 2133.19 ± 0.5% | 2.49 | 1.00 | 1.23 | 50.11 |
| class: two capitalized words, second text | 5359 | 524.87 ± 0.2% | 535.02 ± 0.1% | 23.36 ± 0.2% | 484.18 ± 0.2% | 35.42 ± 13.8% | 17.08 ± 0.2% | 63.54 ± 0.1% | 525.77 ± 0.1% | 0.98 | 1.00 | 1.08 | 14.82 |
| other: a word between two words | 6104 | 808.15 ± 0.1% | 609.22 ± 0.3% | 23.51 ± 0.2% | 739.06 ± 0.3% | 111.92 ± 16.0% | 11.18 ± 0.2% | 69.34 ± 0.4% | 807.56 ± 0.4% | 1.33 | 1.00 | 1.09 | 7.22 |
| other: a number before a unit, second text | 1481 | 6210.27 ± 1.2% | 1133.72 ± 0.3% | 25.98 ± 0.2% | 5620.92 ± 1.0% | 40.74 ± 0.3% | 18.15 ± 0.2% | 66.87 ± 0.3% | 6168.67 ± 1.1% | 5.48 | 1.01 | 1.10 | 152.45 |
| other: a heading's start tag | 110 | 13737.66 ± 0.6% | 750.86 ± 0.1% | 27.42 ± 0.4% | 1707.09 ± 0.3% | 1582.27 ± 5.0% | 16.13 ± 0.8% | 88.49 ± 0.3% | 13692.24 ± 2.8% | 18.30 | 1.00 | 8.05 | 8.68 |
| other: a whole word | 217 | 15848.86 ± 1.9% | 605.30 ± 0.7% | 29.36 ± 0.5% | 14267.91 ± 1.3% | 48.00 ± 0.3% | 13.30 ± 0.2% | 55.89 ± 0.3% | 16104.93 ± 2.5% | 26.18 | 0.98 | 1.11 | 330.19 |
| other: a line's first word, second text | 3716 | 2108.37 ± 0.6% | 600.44 ± 0.1% | 30.75 ± 0.1% | 1720.87 ± 0.4% | 62.61 ± 2.5% | refused | refused | 2115.15 ± 1.3% | 3.51 | 1.00 | 1.23 | 33.67 |
| other: fourteen octets before an x | 87 | 23311.65 ± 6.0% | 233.54 ± 0.9% | 6.54 ± 0.1% | 3966.48 ± 1.3% | 10.64 ± 0.1% | differs | 17.57 ± 0.0% | 23735.66 ± 10.5% | 99.82 | 0.98 | 5.88 | 2190.65 |
| other: a Greek word | 21815 | 520.40 ± 0.3% | 425.43 ± 0.2% | 30.82 ± 0.2% | 289.86 ± 0.8% | 49.57 ± 11.6% | differs | refused | 521.11 ± 0.5% | 1.22 | 1.00 | 1.80 | 10.50 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.15 ± 0.2% | 29.24 ± 0.3% | 0.86 ± 0.3% | 19.85 ± 0.6% | 2.78 ± 0.3% | differs | 4.03 ± 0.2% | 29.27 ± 0.5% | 1.00 | 1.00 | 1.47 | 10.49 |
| a UUID | 32895 | 24.71 ± 0.1% | 24.68 ± 0.1% | 0.64 ± 0.1% | 15.14 ± 0.5% | 3.09 ± 0.5% | 0.73 ± 0.4% | 3.63 ± 0.6% | 24.76 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.99 |
| an IPv4 address | 33176 | 38.48 ± 0.1% | 38.49 ± 0.3% | 2.07 ± 0.4% | 29.40 ± 0.2% | 6.66 ± 0.4% | differs | 4.17 ± 0.1% | 38.42 ± 0.5% | 1.00 | 1.00 | 1.31 | 5.78 |
| a date and time | 32954 | 34.41 ± 0.1% | 34.22 ± 0.2% | 1.45 ± 0.3% | 21.51 ± 0.6% | 7.04 ± 0.2% | 1.25 ± 0.3% | 7.14 ± 0.1% | 34.34 ± 0.2% | 1.01 | 1.00 | 1.60 | 4.89 |
| a field path | 32606 | 32.57 ± 0.1% | 32.61 ± 0.3% | 1.01 ± 0.4% | 23.31 ± 0.1% | 3.49 ± 0.7% | differs | 2.93 ± 0.8% | 32.60 ± 0.4% | 1.00 | 1.00 | 1.40 | 9.34 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.09 ± 0.4% | 11.13 ± 0.4% | 11.11 ± 0.1% | 11.79 ± 0.1% | 4.96 ± 1.8% | 0.93 ± 0.9% | none | 11.13 ± 0.2% | 1.00 | 1.00 | 0.94 | 2.23 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.79 ± 0.3% | 228.08 ± 0.2% | 270.29 ± 0.3% | 87.05 ± 0.2% | 219.91 ± 1.8% | 486.61 ± 0.4% | 3706.24 ± 3.9% | 227.95 ± 0.2% | 1.00 | 1.00 | 2.62 | 1.04 |
| a UUID | 62 | 149.40 ± 0.2% | 149.60 ± 0.1% | 167.37 ± 0.1% | 45.91 ± 0.6% | 99.28 ± 5.8% | 183.80 ± 1.0% | 4492.85 ± 0.7% | 149.53 ± 0.2% | 1.00 | 1.00 | 3.25 | 1.50 |
| an IPv4 address | 29 | 417.40 ± 0.3% | 418.81 ± 0.4% | 587.45 ± 0.6% | 76.11 ± 0.9% | 130.45 ± 2.0% | 296.05 ± 0.4% | 7658.85 ± 0.3% | 417.33 ± 0.4% | 1.00 | 1.00 | 5.48 | 3.20 |
| a date and time | 56 | 301.25 ± 0.3% | 301.41 ± 0.2% | 380.48 ± 0.2% | 72.32 ± 1.1% | 136.00 ± 1.3% | 323.15 ± 1.1% | 4966.35 ± 0.3% | 301.31 ± 0.4% | 1.00 | 1.00 | 4.17 | 2.21 |
| a field path | 39 | 221.76 ± 0.1% | 221.85 ± 0.3% | 261.53 ± 0.6% | 79.26 ± 0.2% | 205.63 ± 0.8% | 485.98 ± 1.0% | 4856.96 ± 0.2% | 221.47 ± 0.2% | 1.00 | 1.00 | 2.80 | 1.08 |
| literal: a word | 7 | 605.49 ± 1.1% | 659.58 ± 0.7% | 1186.61 ± 0.3% | 495.40 ± 1.4% | 623.28 ± 2.0% | 920.27 ± 0.3% | 30814.06 ± 0.1% | 608.29 ± 0.3% | 0.92 | 1.00 | 1.22 | 0.97 |
| literal: a word that is not there | 8 | 584.17 ± 0.4% | 635.39 ± 0.7% | 1122.34 ± 0.7% | 456.18 ± 0.1% | 599.74 ± 1.9% | 870.02 ± 0.8% | 29391.18 ± 0.3% | 584.94 ± 0.5% | 0.92 | 1.00 | 1.28 | 0.97 |
| literal: one of four words | 26 | 238.94 ± 0.5% | 389.54 ± 0.2% | 532.21 ± 0.4% | 49.35 ± 0.3% | 240.96 ± 4.8% | 355.08 ± 0.3% | 15751.09 ± 0.1% | 239.15 ± 0.2% | 0.61 | 1.00 | 4.84 | 0.99 |
| literal: a word in any case | 11 | 442.15 ± 0.1% | 472.44 ± 0.4% | 699.58 ± 0.2% | 15.68 ± 0.6% | 647.13 ± 1.2% | refused | 23634.68 ± 0.2% | 442.47 ± 0.1% | 0.94 | 1.00 | 28.20 | 0.68 |
| literal: an href attribute | 12 | 336.13 ± 0.3% | 349.07 ± 0.3% | 459.57 ± 0.5% | 10.79 ± 28.7% | 493.90 ± 1.3% | 755.49 ± 0.2% | 22254.91 ± 0.2% | 336.53 ± 0.5% | 0.96 | 1.00 | 31.16 | 0.68 |
| literal: a word, second text | 10 | 542.08 ± 0.5% | 599.35 ± 0.6% | 1011.62 ± 0.7% | 413.19 ± 0.3% | 534.18 ± 1.3% | 784.30 ± 0.4% | 27257.12 ± 0.2% | 542.93 ± 0.3% | 0.90 | 1.00 | 1.31 | 1.01 |
| class: two capitalized words | 23 | 427.65 ± 0.7% | 458.17 ± 0.9% | 662.15 ± 0.9% | 99.52 ± 0.9% | 499.71 ± 1.3% | 757.42 ± 0.6% | 6377.72 ± 0.2% | 426.62 ± 0.7% | 0.93 | 1.00 | 4.30 | 0.86 |
| class: a word that ends in ing | 9 | 541.94 ± 0.5% | 614.28 ± 0.5% | 1079.99 ± 0.1% | 131.51 ± 1.0% | 756.41 ± 0.8% | 1080.75 ± 1.4% | 15941.21 ± 0.1% | 543.35 ± 0.5% | 0.88 | 1.00 | 4.12 | 0.72 |
| class: a word in capitals | 16 | 485.66 ± 0.6% | 523.99 ± 0.4% | 831.17 ± 0.3% | 135.02 ± 0.7% | 743.14 ± 1.7% | 996.79 ± 0.6% | 8380.89 ± 0.1% | 485.17 ± 0.7% | 0.93 | 1.00 | 3.60 | 0.65 |
| class: a number | 6 | 614.94 ± 0.9% | 673.65 ± 0.5% | 1255.52 ± 0.2% | 41.67 ± 0.8% | 1390.84 ± 0.8% | 1929.94 ± 0.5% | 22918.38 ± 0.1% | 613.56 ± 0.3% | 0.91 | 1.00 | 14.76 | 0.44 |
| class: two capitalized words, second text | 23 | 427.23 ± 0.7% | 457.61 ± 0.1% | 661.78 ± 0.4% | 99.21 ± 2.7% | 497.63 ± 1.0% | 740.67 ± 0.7% | 6378.43 ± 0.3% | 427.20 ± 0.4% | 0.93 | 1.00 | 4.31 | 0.86 |
| other: a word between two words | 13 | 527.37 ± 0.3% | 549.14 ± 0.5% | 879.75 ± 0.1% | 133.89 ± 0.9% | 497.40 ± 0.4% | 813.67 ± 0.8% | 14783.66 ± 0.1% | 528.04 ± 0.5% | 0.96 | 1.00 | 3.94 | 1.06 |
| other: a number before a unit, second text | 15 | 387.95 ± 0.3% | 431.61 ± 0.1% | 610.56 ± 0.1% | 39.50 ± 0.7% | 633.24 ± 1.7% | 887.15 ± 0.5% | 15418.89 ± 0.1% | 387.39 ± 0.3% | 0.90 | 1.00 | 9.82 | 0.61 |
| other: a heading's start tag | 13 | 347.18 ± 0.5% | 356.24 ± 0.7% | 469.77 ± 0.3% | 11.89 ± 44.3% | 626.63 ± 1.3% | 867.02 ± 0.3% | 18414.63 ± 0.0% | 348.15 ± 0.3% | 0.97 | 1.00 | 29.19 | 0.55 |
| other: a whole word | 11 | 562.05 ± 0.3% | 601.23 ± 0.6% | 1015.73 ± 0.3% | 119.24 ± 1.4% | 560.62 ± 1.1% | 817.96 ± 0.6% | 26879.96 ± 0.6% | 562.89 ± 0.4% | 0.93 | 1.00 | 4.71 | 1.00 |
| other: a line's first word, second text | 17 | 508.90 ± 0.6% | 541.31 ± 0.2% | 871.58 ± 0.4% | 127.98 ± 0.2% | 707.98 ± 1.0% | refused | refused | 510.38 ± 0.5% | 0.94 | 1.00 | 3.98 | 0.72 |
| other: fourteen octets before an x | 16 | 106.51 ± 0.3% | 151.71 ± 0.7% | 175.45 ± 0.4% | 6.68 ± 23.2% | 450.11 ± 2.3% | 416.93 ± 0.4% | 12808.50 ± 0.5% | 106.61 ± 0.5% | 0.70 | 1.00 | 15.95 | 0.24 |
| other: a Greek word | 8 | 426.24 ± 0.3% | 583.29 ± 0.3% | 986.66 ± 0.6% | 13.40 ± 35.1% | 1388.31 ± 1.6% | 1825.65 ± 0.5% | refused | 426.37 ± 0.2% | 0.73 | 1.00 | 31.80 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15399.57 ± 1.6% | not timed | not timed | 15841.35 ± 0.6% | 2102.22 ± 11.8% | not timed | not timed | 15335.74 ± 1.1% | | 1.00 | 0.97 | 7.33 |
| 01-literal/sherlock-casei-en | 522 | 11043.13 ± 5.2% | not timed | not timed | 3598.22 ± 0.2% | 32.56 ± 0.2% | not timed | not timed | 11031.35 ± 1.0% | | 1.00 | 3.07 | 339.13 |
| 01-literal/sherlock-ru | 724 | 17175.27 ± 1.0% | not timed | not timed | 17205.88 ± 0.7% | 1547.82 ± 9.1% | not timed | not timed | 17210.35 ± 0.4% | | 1.00 | 1.00 | 11.10 |
| 01-literal/sherlock-casei-ru | 746 | 6152.22 ± 0.2% | not timed | not timed | 3324.87 ± 0.4% | 31.71 ± 0.2% | not timed | not timed | 6146.67 ± 0.4% | | 1.00 | 1.85 | 194.02 |
| 01-literal/sherlock-zh | 30 | 19341.26 ± 1.4% | not timed | not timed | 18345.44 ± 1.1% | 2725.81 ± 11.6% | not timed | not timed | 19243.55 ± 0.6% | | 1.01 | 1.05 | 7.10 |
| 02-literal-alternate/sherlock-en | 714 | 6161.13 ± 0.5% | not timed | not timed | 3935.04 ± 0.2% | 16.63 ± 0.2% | not timed | not timed | 6155.38 ± 0.3% | | 1.00 | 1.57 | 370.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1970.28 ± 1.6% | not timed | not timed | 698.28 ± 0.3% | 11.06 ± 0.2% | not timed | not timed | 1983.25 ± 0.6% | | 0.99 | 2.82 | 178.12 |
| 02-literal-alternate/sherlock-ru | 899 | 5540.88 ± 0.1% | not timed | not timed | 3253.21 ± 0.1% | 22.63 ± 0.2% | not timed | not timed | 5534.13 ± 0.2% | | 1.00 | 1.70 | 244.83 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.62 ± 0.4% | not timed | not timed | 1231.01 ± 0.5% | 8.90 ± 0.1% | not timed | not timed | 2055.08 ± 0.4% | | 1.00 | 1.67 | 231.11 |
| 02-literal-alternate/sherlock-zh | 207 | 7340.86 ± 0.2% | not timed | not timed | 4164.09 ± 0.2% | 31.51 ± 0.1% | not timed | not timed | 7337.61 ± 0.3% | | 1.00 | 1.76 | 233.01 |
| 03-date/ascii | 111817 | 133.56 ± 0.6% | not timed | not timed | 94.72 ± 0.1% | 0.22 ± 2.4% | not timed | not timed | 133.67 ± 0.5% | | 1.00 | 1.41 | 618.48 |
| 04-ruff-noqa/real | 84 | 435.53 ± 0.1% | not timed | not timed | 475.70 ± 0.1% | 19.50 ± 0.2% | not timed | not timed | 435.99 ± 0.1% | | 1.00 | 0.92 | 22.34 |
| 04-ruff-noqa/tweaked | 44 | 590.89 ± 0.2% | not timed | not timed | 466.84 ± 0.1% | 364.26 ± 0.7% | not timed | not timed | 593.77 ± 0.5% | | 1.00 | 1.27 | 1.62 |
| 05-lexer-veryl/single | 124800 | 5.19 ± 3.8% | not timed | not timed | 5.22 ± 0.3% | 0.21 ± 3.2% | not timed | not timed | 5.22 ± 2.0% | | 1.00 | 1.00 | 25.06 |
| 06-cloud-flare-redos/original | 107 | 425.87 ± 0.2% | not timed | not timed | 212.23 ± 0.0% | 24.93 ± 0.4% | not timed | not timed | 430.58 ± 0.1% | | 0.99 | 2.01 | 17.08 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.55 ± 0.2% | not timed | not timed | 227.92 ± 0.1% | 26.66 ± 0.3% | not timed | not timed | 430.50 ± 0.3% | | 1.00 | 1.89 | 16.19 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.68 ± 0.3% | not timed | not timed | 256.93 ± 0.3% | 28.75 ± 0.1% | not timed | not timed | 588.69 ± 0.1% | | 1.00 | 2.29 | 20.48 |
| 07-unicode-character-data/parse-line | 558784 | 238.57 ± 2.1% | not timed | not timed | 180.17 ± 0.3% | 43.45 ± 5.9% | not timed | not timed | 240.11 ± 0.6% | | 0.99 | 1.32 | 5.49 |
| 08-words/all-english | 56691 | 127.33 ± 0.9% | not timed | not timed | 83.30 ± 0.1% | 12.71 ± 9.8% | not timed | not timed | 127.08 ± 0.3% | | 1.00 | 1.53 | 10.02 |
| 08-words/long-english | 839 | 623.39 ± 0.3% | not timed | not timed | 597.95 ± 0.1% | 32.43 ± 0.2% | not timed | not timed | 623.50 ± 0.4% | | 1.00 | 1.04 | 19.22 |
| 09-aws-keys/full | 0 | 440.68 ± 0.2% | not timed | not timed | 478.92 ± 0.1% | 64.47 ± 3.4% | not timed | not timed | 439.11 ± 0.1% | | 1.00 | 0.92 | 6.84 |
| 09-aws-keys/quick | 0 | 876.96 ± 0.2% | not timed | not timed | 1003.15 ± 0.3% | 425.10 ± 2.4% | not timed | not timed | 876.46 ± 0.3% | | 1.00 | 0.87 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 585.92 ± 3.5% | not timed | not timed | 517.22 ± 0.3% | 19.55 ± 0.3% | not timed | not timed | 582.25 ± 1.8% | | 1.01 | 1.13 | 29.96 |
| 10-bounded-repeat/letters-ru | 3475 | 506.82 ± 1.5% | not timed | not timed | 478.85 ± 0.1% | 23.70 ± 4.1% | not timed | not timed | 506.09 ± 1.1% | | 1.00 | 1.06 | 21.39 |
| 10-bounded-repeat/context | 53 | 85.15 ± 2.2% | not timed | not timed | 66.09 ± 0.6% | 19.80 ± 0.2% | not timed | not timed | 85.29 ± 1.7% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 632.38 ± 8.1% | not timed | not timed | 618.73 ± 0.1% | 36.50 ± 0.1% | not timed | not timed | 633.87 ± 8.1% | | 1.00 | 1.02 | 17.32 |
| 11-unstructured-to-json/extract | 600 | 57.39 ± 0.4% | not timed | not timed | 76.38 ± 0.3% | 49.20 ± 2.7% | not timed | not timed | 57.30 ± 0.2% | | 1.00 | 0.75 | 1.17 |
| 12-dictionary/single | 1 | 560.02 ± 1.0% | not timed | not timed | 559.40 ± 0.3% | 0.40 ± 0.1% | not timed | not timed | 560.67 ± 1.4% | | 1.00 | 1.00 | 1383.15 |
| 14-quadratic/1x | 100 | 21.41 ± 1.1% | not timed | not timed | 10.04 ± 0.5% | 0.97 ± 3.1% | not timed | not timed | 21.34 ± 1.0% | | 1.00 | 2.13 | 22.10 |
| 14-quadratic/2x | 200 | 17.73 ± 0.7% | not timed | not timed | 5.56 ± 0.0% | 0.53 ± 1.6% | not timed | not timed | 17.78 ± 0.8% | | 1.00 | 3.19 | 33.26 |
| 14-quadratic/10x | 1000 | 7.77 ± 0.4% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.7% | not timed | not timed | 7.76 ± 0.4% | | 1.00 | 6.42 | 67.17 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 1.1% | not timed | not timed | 0.34 ± 0.6% | 0.56 ± 5.1% | not timed | not timed | 1.26 ± 0.4% | | 1.00 | 3.64 | 2.25 |
| 04-ruff-noqa/compile-real | 1 | 101.34 ± 1.5% | not timed | not timed | 13.97 ± 0.6% | 141.90 ± 1.6% | not timed | not timed | 101.31 ± 1.5% | | 1.00 | 7.25 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 14.01 ± 1.5% | not timed | not timed | 2.52 ± 0.2% | 6.46 ± 2.7% | not timed | not timed | 14.01 ± 1.0% | | 1.00 | 5.57 | 2.17 |
| 07-unicode-character-data/compile | 1 | 107.19 ± 1.3% | not timed | not timed | 25.97 ± 0.3% | 36.58 ± 2.2% | not timed | not timed | 107.33 ± 1.4% | | 1.00 | 4.13 | 2.93 |
| 09-aws-keys/compile-full | 1 | 51.99 ± 0.4% | not timed | not timed | 8.20 ± 1.2% | 23.51 ± 1.7% | not timed | not timed | 52.12 ± 1.5% | | 1.00 | 6.34 | 2.21 |
| 09-aws-keys/compile-quick | 1 | 180.12 ± 1.2% | not timed | not timed | 47.14 ± 0.2% | 134.33 ± 1.8% | not timed | not timed | 179.56 ± 0.3% | | 1.00 | 3.82 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 69.08 ± 0.2% | not timed | not timed | 11.13 ± 0.1% | 15.99 ± 3.5% | not timed | not timed | 69.27 ± 0.8% | | 1.00 | 6.21 | 4.32 |
| 10-bounded-repeat/compile-capitals | 1 | 81.28 ± 1.5% | not timed | not timed | 8.05 ± 0.2% | 23.88 ± 1.3% | not timed | not timed | 81.65 ± 0.6% | | 1.00 | 10.10 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 169.10 ± 0.8% | not timed | not timed | 40.64 ± 0.6% | 69.23 ± 1.4% | not timed | not timed | 168.40 ± 3.2% | | 1.00 | 4.16 | 2.44 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.3% | not timed | not timed | 0.07 ± 1.1% | 0.10 ± 12.8% | not timed | not timed | 0.35 ± 1.3% | | 0.99 | 5.01 | 3.59 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.30 ± 0.4% | not timed | not timed | 6.55 ± 0.2% | 0.57 ± 9.4% | not timed | not timed | 7.28 ± 0.7% | | 1.00 | 1.12 | 12.82 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.6% | not timed | not timed | 165.16 ± 0.5% | 0.00 ± 1.0% | not timed | not timed | 1.16 ± 0.2% | | 1.00 | 0.0070 | 440.69 |
| dictionary/search/english-15 | 15 | 566.44 ± 0.9% | not timed | not timed | 560.55 ± 0.2% | 0.37 ± 0.3% | not timed | not timed | 567.59 ± 1.0% | | 1.00 | 1.01 | 1550.01 |
| folly/awyer-inn-busted | 1 | 5593.08 ± 0.1% | not timed | not timed | 142.95 ± 0.1% | 42.69 ± 0.2% | not timed | not timed | 5613.09 ± 0.0% | | 1.00 | 39.13 | 131.02 |
| folly/literal-never-match-rare | 0 | 21046.77 ± 0.8% | not timed | not timed | 19873.12 ± 0.7% | 40655.08 ± 0.9% | not timed | not timed | 21078.76 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12488.68 ± 7.8% | not timed | not timed | 19748.51 ± 5.3% | 2176.11 ± 1.2% | not timed | not timed | 12483.23 ± 6.8% | | 1.00 | 0.63 | 5.74 |
| folly/literal-never-match-tricksy | 1 | 3232.59 ± 0.2% | not timed | not timed | 4413.68 ± 0.2% | 3049.99 ± 0.1% | not timed | not timed | 3242.42 ± 0.4% | | 1.00 | 0.73 | 1.06 |
| grep/every-line | 239963 | 1314.25 ± 0.9% | not timed | not timed | 929.46 ± 0.4% | 385.68 ± 17.6% | not timed | not timed | 1321.35 ± 0.6% | | 0.99 | 1.41 | 3.41 |
| grep/long-words-ascii | 5073 | 458.79 ± 0.1% | not timed | not timed | 468.72 ± 0.3% | 46.27 ± 8.0% | not timed | not timed | 403.92 ± 1.4% | | 1.14 | 0.98 | 9.91 |
| imported/leipzig/twain | 811 | 20709.88 ± 4.4% | not timed | not timed | 19582.80 ± 0.4% | 11927.59 ± 10.0% | not timed | not timed | 20748.03 ± 0.3% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9052.14 ± 0.8% | not timed | not timed | 4253.33 ± 0.1% | 37.82 ± 0.3% | not timed | not timed | 9079.62 ± 1.8% | | 1.00 | 2.13 | 239.34 |
| imported/leipzig/shing | 1540 | 15203.40 ± 2.2% | not timed | not timed | 13515.09 ± 0.7% | 34.03 ± 0.1% | not timed | not timed | 15462.11 ± 2.9% | | 0.98 | 1.12 | 446.79 |
| imported/leipzig/huck-saw | 262 | 8187.89 ± 3.4% | not timed | not timed | 5609.02 ± 0.2% | 31.88 ± 0.1% | not timed | not timed | 8445.74 ± 3.4% | | 0.97 | 1.46 | 256.81 |
| imported/leipzig/word-ending-nn | 262 | 604.75 ± 0.1% | not timed | not timed | 615.96 ± 0.1% | 24.74 ± 0.3% | not timed | not timed | 605.00 ± 0.6% | | 1.00 | 0.98 | 24.44 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11191.74 ± 1.2% | not timed | not timed | 4522.80 ± 0.5% | 11.49 ± 0.2% | not timed | not timed | 11127.32 ± 1.1% | | 1.01 | 2.47 | 973.70 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7798.82 ± 2.7% | not timed | not timed | 5488.03 ± 0.2% | 16.88 ± 0.1% | not timed | not timed | 7933.42 ± 3.1% | | 0.98 | 1.42 | 462.06 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4178.89 ± 1.5% | not timed | not timed | 404.19 ± 1.3% | 11.12 ± 0.1% | not timed | not timed | 4218.50 ± 1.7% | | 0.99 | 10.34 | 375.95 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 601.66 ± 0.5% | not timed | not timed | 615.00 ± 0.1% | 11.06 ± 0.1% | not timed | not timed | 601.75 ± 0.8% | | 1.00 | 0.98 | 54.39 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 600.44 ± 0.7% | not timed | not timed | 616.06 ± 0.0% | 9.71 ± 0.0% | not timed | not timed | 601.16 ± 0.5% | | 1.00 | 0.97 | 61.86 |
| imported/leipzig/tom-river | 2 | 6473.91 ± 1.7% | not timed | not timed | 5155.48 ± 15.7% | 30.95 ± 0.2% | not timed | not timed | 6603.77 ± 1.9% | | 0.98 | 1.26 | 209.16 |
| imported/leipzig/ing | 78424 | 601.78 ± 0.6% | not timed | not timed | 571.38 ± 0.2% | 28.12 ± 3.2% | not timed | not timed | 600.48 ± 1.0% | | 1.00 | 1.05 | 21.40 |
| imported/leipzig/ing-whitespace | 55248 | 751.82 ± 1.4% | not timed | not timed | 2082.24 ± 0.7% | 20.55 ± 2.9% | not timed | not timed | 754.76 ± 0.4% | | 1.00 | 0.36 | 36.58 |
| imported/leipzig/awyer-inn | 209 | 769.30 ± 1.4% | not timed | not timed | 4262.42 ± 0.6% | 22.59 ± 0.0% | not timed | not timed | 767.19 ± 1.2% | | 1.00 | 0.18 | 34.05 |
| imported/leipzig/quotes-bounded | 8886 | 2124.50 ± 0.4% | not timed | not timed | 3014.38 ± 0.6% | 38.25 ± 0.2% | not timed | not timed | 2132.01 ± 0.5% | | 1.00 | 0.70 | 55.54 |
| imported/leipzig/non-ascii-alternate | 2 | 12805.13 ± 2.3% | not timed | not timed | 5666.58 ± 0.2% | 50.86 ± 0.1% | not timed | not timed | 13087.84 ± 2.5% | | 0.98 | 2.26 | 251.76 |
| imported/leipzig/math-symbols | 69 | 1973.82 ± 0.7% | not timed | not timed | 613.63 ± 0.1% | 36.58 ± 0.3% | not timed | not timed | 1980.53 ± 0.8% | | 1.00 | 3.22 | 53.96 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.13 ± 1.3% | not timed | not timed | 615.20 ± 0.1% | 22.50 ± 0.1% | not timed | not timed | 586.90 ± 0.8% | | 1.00 | 0.95 | 26.05 |
| imported/lh3lh3-reb/uri | 17549 | 679.29 ± 0.1% | not timed | not timed | 1082.40 ± 0.1% | 27.85 ± 2.0% | not timed | not timed | 679.65 ± 0.1% | | 1.00 | 0.63 | 24.39 |
| imported/lh3lh3-reb/email | 15057 | 674.38 ± 0.1% | not timed | not timed | 1173.58 ± 0.2% | 29.91 ± 2.3% | not timed | not timed | 673.35 ± 0.1% | | 1.00 | 0.57 | 22.55 |
| imported/lh3lh3-reb/date | 668 | 859.80 ± 0.1% | not timed | not timed | 1046.26 ± 0.2% | 48.75 ± 3.7% | not timed | not timed | 861.09 ± 0.2% | | 1.00 | 0.82 | 17.64 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.80 ± 0.1% | not timed | not timed | 423.38 ± 0.1% | 15.60 ± 1.3% | not timed | not timed | 645.76 ± 0.2% | | 1.00 | 1.53 | 41.39 |
| imported/mariomka/email | 92 | 24287.30 ± 0.9% | not timed | not timed | 29421.12 ± 1.4% | 32.81 ± 0.3% | not timed | not timed | 24309.56 ± 1.7% | | 1.00 | 0.83 | 740.25 |
| imported/mariomka/uri | 5301 | 5365.19 ± 0.6% | not timed | not timed | 6083.22 ± 0.4% | 32.85 ± 0.3% | not timed | not timed | 5373.59 ± 0.6% | | 1.00 | 0.88 | 163.33 |
| imported/mariomka/ip | 5 | 2158.81 ± 2.3% | not timed | not timed | 2955.79 ± 0.1% | 21.09 ± 0.5% | not timed | not timed | 2155.99 ± 2.2% | | 1.00 | 0.73 | 102.37 |
| imported/rsc/no-exponential | 0 | 604.81 ± 0.1% | not timed | not timed | 321.02 ± 0.1% | 23.52 ± 0.3% | not timed | not timed | 600.50 ± 0.2% | | 1.01 | 1.88 | 25.72 |
| imported/rsc/literal | 1 | 763.01 ± 2.5% | not timed | not timed | 1626.37 ± 5.7% | 188.93 ± 28.3% | not timed | not timed | 761.39 ± 4.8% | | 1.00 | 0.47 | 4.04 |
| imported/rsc/not-literal | 2 | 781.59 ± 0.2% | not timed | not timed | 719.97 ± 0.3% | 45.74 ± 5.0% | not timed | not timed | 779.77 ± 5.6% | | 1.00 | 1.09 | 17.09 |
| imported/rsc/match-class | 1 | 1441.41 ± 0.4% | not timed | not timed | 1654.99 ± 0.4% | 58.48 ± 12.5% | not timed | not timed | 1437.34 ± 2.0% | | 1.00 | 0.87 | 24.65 |
| imported/rsc/match-class-in-range | 1 | 1443.97 ± 0.3% | not timed | not timed | 2303.25 ± 5.9% | 59.73 ± 14.4% | not timed | not timed | 1441.91 ± 2.5% | | 1.00 | 0.63 | 24.17 |
| imported/rsc/match-class-unicode | 1 | 547.92 ± 0.2% | not timed | not timed | 511.94 ± 0.0% | 72.19 ± 0.4% | not timed | not timed | 548.52 ± 0.2% | | 1.00 | 1.07 | 7.59 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1439.25 ± 0.1% | not timed | not timed | 957.43 ± 0.1% | 227.81 ± 0.3% | not timed | not timed | 1433.07 ± 0.1% | | 1.00 | 1.50 | 6.32 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21579.92 ± 0.2% | not timed | not timed | 14136.81 ± 0.1% | 3418.35 ± 0.6% | not timed | not timed | 21456.26 ± 0.1% | | 1.01 | 1.53 | 6.31 |
| imported/rsc/anchored-literal-short-match | 4 | 710.65 ± 0.6% | not timed | not timed | 483.14 ± 0.3% | 81.14 ± 1.6% | not timed | not timed | 712.03 ± 0.1% | | 1.00 | 1.47 | 8.76 |
| imported/rsc/anchored-literal-long-match | 4 | 10626.17 ± 0.6% | not timed | not timed | 7319.50 ± 0.1% | 1232.95 ± 1.1% | not timed | not timed | 10671.21 ± 0.6% | | 1.00 | 1.45 | 8.62 |
| imported/rsc/one-pass-short | 17 | 370.72 ± 9.9% | not timed | not timed | 214.69 ± 0.2% | 30.09 ± 10.8% | not timed | not timed | 367.97 ± 1.5% | | 1.01 | 1.73 | 12.32 |
| imported/rsc/one-pass-short-not | 17 | 278.92 ± 2.0% | not timed | not timed | 223.50 ± 0.1% | 32.38 ± 14.3% | not timed | not timed | 280.21 ± 2.0% | | 1.00 | 1.25 | 8.61 |
| imported/rsc/one-pass-long-prefix | 26 | 360.16 ± 1.8% | not timed | not timed | 282.70 ± 0.3% | 97.42 ± 11.7% | not timed | not timed | 362.09 ± 1.0% | | 0.99 | 1.27 | 3.70 |
| imported/rsc/one-pass-long-prefix-not | 26 | 360.10 ± 1.7% | not timed | not timed | 281.26 ± 0.2% | 64.67 ± 15.1% | not timed | not timed | 360.65 ± 6.3% | | 1.00 | 1.28 | 5.57 |
| imported/rsc/long-needle1 | 31 | 22184.41 ± 0.0% | not timed | not timed | 20130.96 ± 0.3% | 3.76 ± 0.1% | not timed | not timed | 22188.67 ± 0.2% | | 1.00 | 1.10 | 5897.79 |
| imported/rsc/long-needle2 | 31 | 22326.26 ± 0.2% | not timed | not timed | 216.34 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 22336.54 ± 0.1% | | 1.00 | 103.20 | 5931.81 |
| imported/rsc/easy0-32 | 26 | 1083.40 ± 2.7% | not timed | not timed | 1594.18 ± 3.7% | 148.37 ± 19.4% | not timed | not timed | 1082.69 ± 0.3% | | 1.00 | 0.68 | 7.30 |
| imported/rsc/easy0-1k | 26 | 14874.98 ± 1.9% | not timed | not timed | 12458.90 ± 1.7% | 2302.88 ± 11.8% | not timed | not timed | 14923.98 ± 0.2% | | 1.00 | 1.19 | 6.46 |
| imported/rsc/easy0-32k | 26 | 23043.31 ± 0.2% | not timed | not timed | 20296.94 ± 0.1% | 18834.01 ± 0.3% | not timed | not timed | 23049.01 ± 0.2% | | 1.00 | 1.14 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21419.61 ± 1.8% | not timed | not timed | 19676.40 ± 2.4% | 35176.44 ± 2.9% | not timed | not timed | 21265.34 ± 2.2% | | 1.01 | 1.09 | 0.61 |
| imported/rsc/easy1-32 | 19 | 808.54 ± 2.6% | not timed | not timed | 632.96 ± 0.1% | 131.59 ± 17.0% | not timed | not timed | 804.75 ± 2.6% | | 1.00 | 1.28 | 6.14 |
| imported/rsc/easy1-1k | 19 | 16518.95 ± 2.2% | not timed | not timed | 12910.52 ± 0.1% | 2499.17 ± 17.3% | not timed | not timed | 16476.67 ± 2.0% | | 1.00 | 1.28 | 6.61 |
| imported/rsc/easy1-32k | 19 | 517990.64 ± 2.8% | not timed | not timed | 403283.67 ± 0.3% | 20450.60 ± 27.2% | not timed | not timed | 517465.62 ± 0.2% | | 1.00 | 1.28 | 25.33 |
| imported/rsc/easy1-1mb | 19 | 16631003.68 ± 0.1% | not timed | not timed | 12931139.85 ± 0.2% | 38201.10 ± 5.0% | not timed | not timed | 16601794.16 ± 0.4% | | 1.00 | 1.29 | 435.35 |
| imported/rsc/medium-32 | 27 | 770.77 ± 1.9% | not timed | not timed | 636.55 ± 0.5% | 69.78 ± 10.9% | not timed | not timed | 774.49 ± 0.6% | | 1.00 | 1.21 | 11.05 |
| imported/rsc/medium-1k | 27 | 13705.17 ± 0.6% | not timed | not timed | 11238.12 ± 0.3% | 72.42 ± 0.1% | not timed | not timed | 13792.97 ± 0.8% | | 0.99 | 1.22 | 189.25 |
| imported/rsc/medium-32k | 27 | 426983.81 ± 0.8% | not timed | not timed | 352557.50 ± 0.1% | 48.80 ± 0.1% | not timed | not timed | 430219.31 ± 0.5% | | 0.99 | 1.21 | 8749.60 |
| imported/rsc/medium-1mb | 27 | 13705448.86 ± 0.6% | not timed | not timed | 11263374.43 ± 0.4% | 48.61 ± 0.1% | not timed | not timed | 13785044.17 ± 0.4% | | 0.99 | 1.22 | 281973.61 |
| imported/rsc/hard-32 | 58 | 422.49 ± 2.1% | not timed | not timed | 366.66 ± 0.1% | 49.65 ± 8.6% | not timed | not timed | 420.57 ± 0.2% | | 1.00 | 1.15 | 8.51 |
| imported/rsc/hard-1k | 27 | 13488.97 ± 0.2% | not timed | not timed | 11681.73 ± 0.5% | 40.77 ± 0.1% | not timed | not timed | 13414.86 ± 0.4% | | 1.01 | 1.15 | 330.88 |
| imported/rsc/hard-32k | 27 | 419486.56 ± 0.4% | not timed | not timed | 363158.83 ± 0.3% | 29.42 ± 0.1% | not timed | not timed | 418860.84 ± 0.2% | | 1.00 | 1.16 | 14258.99 |
| imported/rsc/hard-1mb | 51 | 8418742.05 ± 0.3% | not timed | not timed | 7255097.76 ± 0.2% | 29.42 ± 0.2% | not timed | not timed | 8381354.67 ± 0.2% | | 1.00 | 1.16 | 286167.93 |
| imported/rsc/reallyhard0-32 | 58 | 267.18 ± 2.7% | not timed | not timed | 224.24 ± 0.3% | 49.63 ± 7.9% | not timed | not timed | 267.27 ± 0.1% | | 1.00 | 1.19 | 5.38 |
| imported/rsc/reallyhard0-1k | 27 | 591.89 ± 0.2% | not timed | not timed | 582.34 ± 0.2% | 40.84 ± 0.1% | not timed | not timed | 592.45 ± 0.1% | | 1.00 | 1.02 | 14.49 |
| imported/rsc/reallyhard0-32k | 27 | 610.34 ± 0.1% | not timed | not timed | 613.62 ± 0.0% | 29.38 ± 0.1% | not timed | not timed | 611.07 ± 0.1% | | 1.00 | 0.99 | 20.77 |
| imported/rsc/reallyhard0-1mb | 51 | 593.77 ± 0.5% | not timed | not timed | 613.15 ± 0.5% | 29.39 ± 0.1% | not timed | not timed | 590.43 ± 1.3% | | 1.01 | 0.97 | 20.20 |
| imported/rsc/reallyreallyhard0-32 | 47 | 287.35 ± 1.5% | not timed | not timed | 196.65 ± 0.0% | 60.03 ± 12.3% | not timed | not timed | 288.06 ± 1.6% | | 1.00 | 1.46 | 4.79 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6866.77 ± 0.1% | not timed | not timed | 6034.27 ± 0.4% | 34.41 ± 0.4% | not timed | not timed | 6855.42 ± 0.1% | | 1.00 | 1.14 | 199.57 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21494.83 ± 0.1% | not timed | not timed | 19261.55 ± 0.0% | 24.85 ± 1.9% | not timed | not timed | 21554.47 ± 0.0% | | 1.00 | 1.12 | 865.04 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 20975.17 ± 3.5% | not timed | not timed | 19002.23 ± 2.1% | 24.62 ± 0.3% | not timed | not timed | 20761.94 ± 2.4% | | 1.01 | 1.10 | 851.98 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.31 ± 1.8% | not timed | not timed | 212.17 ± 0.3% | 60.60 ± 10.1% | not timed | not timed | 282.16 ± 1.3% | | 1.00 | 1.33 | 4.66 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5901.32 ± 0.1% | not timed | not timed | 6192.33 ± 0.1% | 34.62 ± 1.1% | not timed | not timed | 5891.28 ± 0.1% | | 1.00 | 0.95 | 170.45 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21427.58 ± 0.2% | not timed | not timed | 19240.49 ± 0.1% | 24.73 ± 3.4% | not timed | not timed | 21415.41 ± 0.1% | | 1.00 | 1.11 | 866.52 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20518.87 ± 2.2% | not timed | not timed | 19129.58 ± 2.0% | 24.33 ± 2.2% | not timed | not timed | 20413.44 ± 1.5% | | 1.01 | 1.07 | 843.22 |
| imported/sherlock/name-sherlock | 776 | 20123.91 ± 1.9% | not timed | not timed | 18752.10 ± 0.4% | 10239.18 ± 23.1% | not timed | not timed | 20123.35 ± 1.8% | | 1.00 | 1.07 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15208.48 ± 1.7% | not timed | not timed | 15648.23 ± 0.4% | 3151.04 ± 16.9% | not timed | not timed | 15409.55 ± 2.1% | | 0.99 | 0.97 | 4.83 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20126.72 ± 1.6% | not timed | not timed | 18766.47 ± 0.2% | 8129.08 ± 26.2% | not timed | not timed | 20121.13 ± 1.6% | | 1.00 | 1.07 | 2.48 |
| imported/sherlock/name-sherlock-casei | 816 | 15852.04 ± 0.3% | not timed | not timed | 4022.72 ± 0.2% | 32.57 ± 0.4% | not timed | not timed | 15869.82 ± 0.2% | | 1.00 | 3.94 | 486.66 |
| imported/sherlock/name-holmes-casei | 2802 | 9475.89 ± 12.7% | not timed | not timed | 3324.19 ± 0.1% | 37.71 ± 0.1% | not timed | not timed | 9479.51 ± 7.1% | | 1.00 | 2.85 | 251.31 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13184.84 ± 3.4% | not timed | not timed | 3957.42 ± 0.1% | 32.58 ± 0.2% | not timed | not timed | 13178.31 ± 0.9% | | 1.00 | 3.33 | 404.68 |
| imported/sherlock/name-whitespace | 1461 | 15484.36 ± 1.9% | not timed | not timed | 14792.30 ± 0.2% | 6469.44 ± 20.4% | not timed | not timed | 15555.16 ± 1.7% | | 1.00 | 1.05 | 2.39 |
| imported/sherlock/name-alt1 | 1142 | 11706.80 ± 0.5% | not timed | not timed | 16629.86 ± 1.1% | 4119.37 ± 25.6% | not timed | not timed | 11708.32 ± 2.5% | | 1.00 | 0.70 | 2.84 |
| imported/sherlock/name-alt2 | 3542 | 9008.04 ± 0.3% | not timed | not timed | 3834.11 ± 0.1% | 31.47 ± 0.1% | not timed | not timed | 9008.42 ± 0.2% | | 1.00 | 2.35 | 286.25 |
| imported/sherlock/name-alt3 | 4507 | 5594.89 ± 0.7% | not timed | not timed | 3631.29 ± 0.2% | 9.58 ± 3.7% | not timed | not timed | 5588.54 ± 0.4% | | 1.00 | 1.54 | 584.04 |
| imported/sherlock/name-alt3-casei | 4593 | 1530.20 ± 0.9% | not timed | not timed | 284.95 ± 0.2% | 6.45 ± 0.2% | not timed | not timed | 1531.46 ± 1.2% | | 1.00 | 5.37 | 237.39 |
| imported/sherlock/name-alt4 | 3686 | 6406.59 ± 0.2% | not timed | not timed | 3803.84 ± 0.1% | 31.34 ± 0.2% | not timed | not timed | 6401.22 ± 0.1% | | 1.00 | 1.68 | 204.41 |
| imported/sherlock/name-alt4-casei | 4254 | 2808.40 ± 2.2% | not timed | not timed | 2584.07 ± 0.4% | 19.47 ± 0.1% | not timed | not timed | 2825.15 ± 1.2% | | 0.99 | 1.09 | 144.25 |
| imported/sherlock/name-alt5 | 4028 | 6463.51 ± 0.3% | not timed | not timed | 3751.95 ± 0.1% | 21.90 ± 0.1% | not timed | not timed | 6466.69 ± 0.2% | | 1.00 | 1.72 | 295.13 |
| imported/sherlock/name-alt5-casei | 4104 | 3527.07 ± 2.3% | not timed | not timed | 2228.15 ± 0.1% | 14.31 ± 0.1% | not timed | not timed | 3525.25 ± 0.7% | | 1.00 | 1.58 | 246.50 |
| imported/sherlock/no-match-uncommon | 0 | 22187.56 ± 0.1% | not timed | not timed | 19875.90 ± 0.3% | 37968.76 ± 0.4% | not timed | not timed | 22189.10 ± 0.3% | | 1.00 | 1.12 | 0.58 |
| imported/sherlock/no-match-common | 0 | 21845.98 ± 0.3% | not timed | not timed | 19906.16 ± 0.3% | 1282.71 ± 0.9% | not timed | not timed | 21864.06 ± 0.8% | | 1.00 | 1.10 | 17.03 |
| imported/sherlock/no-match-really-common | 0 | 16223.15 ± 5.9% | not timed | not timed | 19041.01 ± 0.2% | 1285.22 ± 0.9% | not timed | not timed | 16335.37 ± 1.8% | | 0.99 | 0.85 | 12.62 |
| imported/sherlock/the-lower | 21654 | 2311.98 ± 0.8% | not timed | not timed | 2335.31 ± 0.4% | 233.48 ± 18.6% | not timed | not timed | 2326.25 ± 1.3% | | 0.99 | 0.99 | 9.90 |
| imported/sherlock/the-upper | 2223 | 12830.18 ± 11.4% | not timed | not timed | 13674.61 ± 0.5% | 2829.65 ± 20.7% | not timed | not timed | 12877.65 ± 1.7% | | 1.00 | 0.94 | 4.53 |
| imported/sherlock/the-casei | 23961 | 2014.66 ± 0.6% | not timed | not timed | 1320.92 ± 0.3% | 34.94 ± 34.0% | not timed | not timed | 2016.23 ± 1.4% | | 1.00 | 1.53 | 57.66 |
| imported/sherlock/everything-greedy | 581881 | 282.31 ± 0.7% | not timed | not timed | 164.43 ± 0.2% | 28.79 ± 31.8% | not timed | not timed | 282.62 ± 0.8% | | 1.00 | 1.72 | 9.80 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.81 ± 0.1% | not timed | not timed | 214.12 ± 0.2% | 32.93 ± 0.1% | not timed | not timed | 462.85 ± 0.1% | | 1.00 | 2.16 | 14.05 |
| imported/sherlock/letters | 447175 | 62.42 ± 0.6% | not timed | not timed | 32.93 ± 0.1% | 6.76 ± 6.8% | not timed | not timed | 62.27 ± 0.1% | | 1.00 | 1.90 | 9.23 |
| imported/sherlock/letters-upper | 14180 | 453.40 ± 1.3% | not timed | not timed | 371.41 ± 0.1% | 29.61 ± 21.8% | not timed | not timed | 450.97 ± 0.1% | | 1.01 | 1.22 | 15.31 |
| imported/sherlock/letters-lower | 432995 | 63.42 ± 1.0% | not timed | not timed | 33.66 ± 0.2% | 6.82 ± 51.9% | not timed | not timed | 63.53 ± 0.7% | | 1.00 | 1.88 | 9.30 |
| imported/sherlock/words | 447639 | 115.40 ± 0.3% | not timed | not timed | 83.03 ± 0.1% | 14.37 ± 25.9% | not timed | not timed | 114.93 ± 0.4% | | 1.00 | 1.39 | 8.03 |
| imported/sherlock/before-holmes | 4073 | 10400.16 ± 0.4% | not timed | not timed | 8497.91 ± 0.3% | 24.10 ± 0.7% | not timed | not timed | 10378.59 ± 0.2% | | 1.00 | 1.22 | 431.58 |
| imported/sherlock/before-after-holmes | 2593 | 9975.56 ± 0.7% | not timed | not timed | 9567.98 ± 0.3% | 23.99 ± 1.3% | not timed | not timed | 9996.16 ± 0.6% | | 1.00 | 1.04 | 415.79 |
| imported/sherlock/holmes-cochar-watson | 150 | 5193.14 ± 0.4% | not timed | not timed | 3433.95 ± 0.1% | 31.08 ± 0.1% | not timed | not timed | 5208.20 ± 0.2% | | 1.00 | 1.51 | 167.07 |
| imported/sherlock/holmes-coword-watson | 14309 | 1190.88 ± 0.5% | not timed | not timed | 1126.14 ± 0.3% | 6.79 ± 0.4% | not timed | not timed | 1191.11 ± 0.4% | | 1.00 | 1.06 | 175.29 |
| imported/sherlock/quotes | 14437 | 1399.70 ± 0.3% | not timed | not timed | 1767.93 ± 0.5% | 35.10 ± 0.2% | not timed | not timed | 1400.83 ± 0.2% | | 1.00 | 0.79 | 39.88 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 610.25 ± 0.3% | not timed | not timed | 16293.95 ± 0.2% | 36.74 ± 0.2% | not timed | not timed | 609.57 ± 0.2% | | 1.00 | 0.0375 | 16.61 |
| imported/sherlock/word-ending-n | 35297 | 480.36 ± 0.9% | not timed | not timed | 410.14 ± 0.1% | 23.47 ± 17.6% | not timed | not timed | 479.73 ± 0.2% | | 1.00 | 1.17 | 20.47 |
| imported/sherlock/repeated-class-negation | 2130 | 14961.39 ± 1.0% | not timed | not timed | 11203.78 ± 1.0% | 11.58 ± 0.2% | not timed | not timed | 14905.85 ± 1.1% | | 1.00 | 1.34 | 1292.05 |
| imported/sherlock/ing-suffix | 20547 | 566.41 ± 0.2% | not timed | not timed | 517.64 ± 0.1% | 28.88 ± 0.3% | not timed | not timed | 565.67 ± 0.3% | | 1.00 | 1.09 | 19.61 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 608.34 ± 0.3% | not timed | not timed | 2110.63 ± 0.3% | 20.51 ± 0.2% | not timed | not timed | 607.37 ± 0.5% | | 1.00 | 0.29 | 29.66 |
| opt/accelerate/whole-line | 239963 | 458.09 ± 0.4% | not timed | not timed | 373.32 ± 0.3% | 76.31 ± 11.0% | not timed | not timed | 458.00 ± 0.2% | | 1.00 | 1.23 | 6.00 |
| opt/accelerate/non-dna | 16745 | 426.07 ± 0.3% | not timed | not timed | 398.62 ± 0.1% | 29.48 ± 54.3% | not timed | not timed | 427.96 ± 0.8% | | 1.00 | 1.07 | 14.45 |
| opt/backtrack/words-english | 40536 | 136.53 ± 0.3% | not timed | not timed | 94.47 ± 0.1% | 20.02 ± 8.2% | not timed | not timed | 134.91 ± 1.5% | | 1.01 | 1.45 | 6.82 |
| opt/fixed-length/too-small-ascii | 0 | 311.37 ± 0.4% | not timed | not timed | 692.22 ± 4.0% | 80.17 ± 0.6% | not timed | not timed | 312.33 ± 0.4% | | 1.00 | 0.45 | 3.88 |
| opt/fixed-length/too-big-ascii | 0 | 3481.91 ± 0.5% | not timed | not timed | 5853.11 ± 0.6% | 127.27 ± 0.4% | not timed | not timed | 3463.05 ± 0.1% | | 1.01 | 0.59 | 27.36 |
| opt/fixed-length/go33484-1 | 0 | 670783.04 ± 0.2% | not timed | not timed | 1117891.20 ± 0.5% | 61309.14 ± 0.4% | not timed | not timed | 664440.77 ± 0.3% | | 1.01 | 0.60 | 10.94 |
| opt/fixed-length/go33484-2 | 0 | 670434.55 ± 0.1% | not timed | not timed | 1117507.30 ± 0.8% | 32262.60 ± 2.5% | not timed | not timed | 664169.83 ± 0.2% | | 1.01 | 0.60 | 20.78 |
| opt/fixed-length/go33484-3 | 0 | 2377.95 ± 1.1% | not timed | not timed | 111858.60 ± 0.4% | 762.36 ± 0.5% | not timed | not timed | 2291.85 ± 6.2% | | 1.04 | 0.0213 | 3.12 |
| opt/literal-alt/one-pattern | 1 | 546.87 ± 3.3% | not timed | not timed | 541.96 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 545.00 ± 1.8% | | 1.00 | 1.01 | 1380.75 |
| opt/onepass/fn-predicate | 916 | 369.59 ± 0.5% | not timed | not timed | 332.90 ± 0.2% | 199.30 ± 13.9% | not timed | not timed | 367.81 ± 0.8% | | 1.00 | 1.11 | 1.85 |
| opt/onepass/first-three-words-english | 35128 | 175.93 ± 2.4% | not timed | not timed | 198.83 ± 0.1% | 76.80 ± 13.1% | not timed | not timed | 176.21 ± 2.6% | | 1.00 | 0.88 | 2.29 |
| opt/prefilter/literal-english | 1 | 20759.04 ± 0.2% | not timed | not timed | 19902.62 ± 0.3% | 17507.74 ± 0.3% | not timed | not timed | 20799.47 ± 0.3% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14548.95 ± 0.6% | not timed | not timed | 4312.11 ± 0.2% | 32.84 ± 0.2% | not timed | not timed | 14566.40 ± 0.8% | | 1.00 | 3.37 | 443.01 |
| opt/prefilter/literal-russian | 1 | 21210.54 ± 0.4% | not timed | not timed | 19729.63 ± 0.6% | 3329.26 ± 0.3% | not timed | not timed | 21285.77 ± 0.8% | | 1.00 | 1.08 | 6.37 |
| opt/prefilter/literal-casei-russian | 1 | 8513.27 ± 0.5% | not timed | not timed | 3890.49 ± 0.1% | 31.77 ± 0.4% | not timed | not timed | 8529.07 ± 0.1% | | 1.00 | 2.19 | 267.95 |
| opt/prefilter/rust-functions | 948 | 6830.06 ± 0.3% | not timed | not timed | 8927.27 ± 0.4% | 1867.61 ± 0.5% | not timed | not timed | 6828.80 ± 0.4% | | 1.00 | 0.77 | 3.66 |
| opt/reverse-anchored/word-end | 1 | 30115931.08 ± 0.3% | not timed | not timed | 21247570.05 ± 0.1% | 50.34 ± 0.1% | not timed | not timed | 30054072.42 ± 0.2% | | 1.00 | 1.42 | 598262.66 |
| opt/reverse-inner/holmes | 2593 | 9967.18 ± 0.4% | not timed | not timed | 9574.98 ± 0.2% | 23.90 ± 0.8% | not timed | not timed | 9987.73 ± 0.4% | | 1.00 | 1.04 | 417.01 |
| opt/reverse-inner/email | 47 | 36249.53 ± 2.4% | not timed | not timed | 45106.92 ± 0.8% | 32.23 ± 0.3% | not timed | not timed | 36663.35 ± 3.0% | | 0.99 | 0.80 | 1124.83 |
| opt/reverse-inner/factored-prefix | 3542 | 600.89 ± 0.2% | not timed | not timed | 595.34 ± 0.1% | 12.53 ± 0.9% | not timed | not timed | 599.74 ± 0.2% | | 1.00 | 1.01 | 47.94 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5556.71 ± 0.1% | not timed | not timed | 611.88 ± 0.3% | 75.06 ± 0.2% | not timed | not timed | 5530.86 ± 0.1% | | 1.00 | 9.08 | 74.03 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.35 ± 3.9% | not timed | not timed | 286.52 ± 0.8% | 24.86 ± 0.1% | not timed | not timed | 691.18 ± 2.4% | | 0.99 | 2.40 | 27.65 |
| opt/reverse-suffix/holmes | 4073 | 10386.35 ± 0.4% | not timed | not timed | 8478.16 ± 0.3% | 23.99 ± 0.5% | not timed | not timed | 10380.82 ± 0.4% | | 1.00 | 1.23 | 432.90 |
| opt/reverse-suffix/no-quadratic | 0 | 5531.77 ± 0.2% | not timed | not timed | 612.69 ± 0.3% | 75.26 ± 0.1% | not timed | not timed | 5561.15 ± 0.0% | | 0.99 | 9.03 | 73.50 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.97 ± 2.9% | not timed | not timed | 133.13 ± 0.2% | 13.54 ± 15.2% | not timed | not timed | 121.51 ± 1.8% | | 1.00 | 0.92 | 9.01 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.17 ± 2.3% | not timed | not timed | 134.95 ± 0.1% | 13.65 ± 13.9% | not timed | not timed | 121.62 ± 5.8% | | 1.00 | 0.91 | 8.95 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.4% | 110.76 ± 0.9% | not timed | not timed | 0.28 ± 0.2% | | 1.00 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.48 ± 12.5% | not timed | not timed | 294.12 ± 0.2% | 103.34 ± 0.1% | not timed | not timed | 316.02 ± 0.2% | | 1.00 | 1.08 | 3.07 |
| reported/i13-subset-regex/original-ascii | 4094 | 11200.99 ± 0.9% | not timed | not timed | 4519.72 ± 1.2% | 11.49 ± 0.1% | not timed | not timed | 11131.50 ± 1.4% | | 1.01 | 2.48 | 974.51 |
| reported/i13-subset-regex/original-unicode | 4094 | 11040.00 ± 1.1% | not timed | not timed | 251.18 ± 3.1% | 11.50 ± 0.1% | not timed | not timed | 11167.79 ± 1.0% | | 0.99 | 43.95 | 959.93 |
| reported/i13-subset-regex/big-ascii | 1955 | 10686.97 ± 1.0% | not timed | not timed | 67.85 ± 3.7% | 9.84 ± 0.1% | not timed | not timed | 10649.81 ± 3.6% | | 1.00 | 157.51 | 1085.81 |
| reported/i13-subset-regex/big-unicode | 1955 | 10598.74 ± 2.5% | not timed | not timed | 12.17 ± 54.9% | 9.77 ± 0.9% | not timed | not timed | 10684.20 ± 1.1% | | 0.99 | 870.79 | 1084.83 |
| reported/i13-subset-regex/huge-ascii | 55 | 10113.70 ± 1.3% | not timed | not timed | 11.03 ± 0.1% | 8.73 ± 0.2% | not timed | not timed | 10072.11 ± 3.0% | | 1.00 | 917.10 | 1158.24 |
| reported/i13-subset-regex/huge-unicode | 55 | 9925.58 ± 2.6% | not timed | not timed | 11.00 ± 0.3% | 8.75 ± 0.1% | not timed | not timed | 9881.59 ± 2.3% | | 1.00 | 902.38 | 1133.88 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 11.05 ± 0.1% | 8.75 ± 1.2% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.04 ± 0.0% | not timed | not timed | 10.96 ± 0.3% | 8.76 ± 0.3% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 487.34 ± 0.2% | not timed | not timed | 104.51 ± 0.2% | 6.64 ± 0.2% | not timed | not timed | 486.52 ± 0.4% | | 1.00 | 4.66 | 73.37 |
| reported/i787-keywords/opt-ascii | 5674 | 488.42 ± 0.2% | not timed | not timed | 277.83 ± 0.2% | 10.30 ± 0.2% | not timed | not timed | 486.98 ± 0.4% | | 1.00 | 1.76 | 47.43 |
| slow/quadratic-regex-1x | 100 | 7.11 ± 0.1% | not timed | not timed | 4.97 ± 0.6% | 0.05 ± 0.3% | not timed | not timed | 7.16 ± 0.2% | | 0.99 | 1.43 | 143.82 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.2% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.4% | not timed | not timed | 3.44 ± 0.1% | | 1.00 | 1.24 | 269.01 |
| slow/quadratic-haystack-1x | 100 | 21.50 ± 7.8% | not timed | not timed | 10.03 ± 0.2% | 1.02 ± 13.4% | not timed | not timed | 21.46 ± 2.0% | | 1.00 | 2.15 | 21.16 |
| slow/quadratic-haystack-2x | 200 | 17.78 ± 0.9% | not timed | not timed | 5.55 ± 0.2% | 0.55 ± 1.5% | not timed | not timed | 17.78 ± 12.6% | | 1.00 | 3.20 | 32.48 |
| unicode/codepoints/any-one | 1112064 | 291.37 ± 0.3% | not timed | not timed | 174.27 ± 0.8% | 18.35 ± 4.7% | not timed | not timed | 289.96 ± 0.4% | | 1.00 | 1.67 | 15.88 |
| unicode/codepoints/any-all | 4382592 | 268.99 ± 0.5% | not timed | not timed | 246.07 ± 0.3% | 117.74 ± 0.1% | not timed | not timed | 269.52 ± 0.5% | | 1.00 | 1.09 | 2.28 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.81 ± 1.2% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 601.92 ± 0.8% | not timed | not timed | 615.31 ± 0.2% | 135.51 ± 0.2% | not timed | not timed | 601.46 ± 0.5% | | 1.00 | 0.98 | 4.44 |
| unicode/overlapping-words/ascii | 6156 | 31.97 ± 0.5% | not timed | not timed | 38.87 ± 0.1% | 3.95 ± 0.6% | not timed | not timed | 32.02 ± 0.2% | | 1.00 | 0.82 | 8.10 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.1% | not timed | not timed | 3.40 ± 0.2% | 2.35 ± 0.9% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.43 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.6% | not timed | not timed | 2.86 ± 0.1% | 6.23 ± 10.7% | not timed | not timed | 1.29 ± 0.2% | | 0.99 | 0.45 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 127.65 ± 7.6% | not timed | not timed | 82.67 ± 0.2% | 11.73 ± 24.7% | not timed | not timed | 128.06 ± 1.3% | | 1.00 | 1.54 | 10.89 |
| unicode/word/boundary-long-english | 3466 | 614.28 ± 0.1% | not timed | not timed | 603.22 ± 0.4% | 32.39 ± 0.6% | not timed | not timed | 615.43 ± 0.4% | | 1.00 | 1.02 | 18.96 |
| unicode/word/around-holmes-english | 27 | 19903.40 ± 0.6% | not timed | not timed | 19478.04 ± 0.5% | 22.06 ± 0.4% | not timed | not timed | 19924.33 ± 0.2% | | 1.00 | 1.02 | 902.05 |
| wild/bibleref/long | 874 | 561.83 ± 0.3% | not timed | not timed | 583.83 ± 0.1% | 6.74 ± 0.1% | not timed | not timed | 561.76 ± 0.3% | | 1.00 | 0.96 | 83.41 |
| wild/bibleref/short | 30 | 23.58 ± 2.2% | not timed | not timed | 31.45 ± 0.5% | 14.54 ± 14.3% | not timed | not timed | 24.17 ± 6.5% | | 0.98 | 0.75 | 1.62 |
| wild/bibleref/line | 874 | 394.31 ± 0.2% | not timed | not timed | 217.93 ± 0.1% | 9.12 ± 8.3% | not timed | not timed | 394.49 ± 1.6% | | 1.00 | 1.81 | 43.24 |
| wild/caddy/caddy | 6 | 415.30 ± 3.9% | not timed | not timed | 244.42 ± 0.2% | 68.37 ± 12.2% | not timed | not timed | 417.38 ± 0.1% | | 1.00 | 1.70 | 6.07 |
| wild/dot-star-capture/rust-src-tools | 6 | 1071.07 ± 0.3% | not timed | not timed | 344.36 ± 0.9% | 12.93 ± 0.5% | not timed | not timed | 1072.76 ± 0.2% | | 1.00 | 3.11 | 82.86 |
| wild/ruff/noqa | 84 | 436.63 ± 0.1% | not timed | not timed | 463.71 ± 0.1% | 19.57 ± 2.1% | not timed | not timed | 434.30 ± 0.0% | | 1.01 | 0.94 | 22.32 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.80 ± 0.3% | not timed | not timed | 703.33 ± 0.2% | 137.28 ± 11.2% | not timed | not timed | 960.43 ± 0.4% | | 1.00 | 1.36 | 6.98 |
| wild/ruff/string-quote-prefix | 2972 | 1349.51 ± 0.7% | not timed | not timed | 443.90 ± 0.1% | 319.60 ± 25.6% | not timed | not timed | 1342.26 ± 0.7% | | 1.01 | 3.04 | 4.22 |
| wild/ruff/space-around-operator | 1224378 | 220.63 ± 1.8% | not timed | not timed | 186.88 ± 0.1% | 18.43 ± 1.8% | not timed | not timed | 220.09 ± 1.8% | | 1.00 | 1.18 | 11.97 |
| wild/ruff/shebang | 282 | 982.68 ± 0.4% | not timed | not timed | 325.39 ± 0.1% | 112.51 ± 11.5% | not timed | not timed | 985.49 ± 0.5% | | 1.00 | 3.02 | 8.73 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13810.98 ± 0.4% | not timed | not timed | 13855.98 ± 0.5% | 6932.56 ± 1.0% | not timed | not timed | 13810.29 ± 0.5% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12780.12 ± 0.6% | not timed | not timed | 13402.38 ± 1.0% | 6398.38 ± 1.1% | not timed | not timed | 12776.26 ± 0.5% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13198.62 ± 0.6% | not timed | not timed | 13656.65 ± 0.5% | 6627.44 ± 1.2% | not timed | not timed | 13206.86 ± 0.5% | | 1.00 | 0.97 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9577.64 ± 0.2% | not timed | not timed | 13578.38 ± 0.4% | 6753.13 ± 1.0% | not timed | not timed | 9583.44 ± 0.2% | | 1.00 | 0.71 | 1.42 |
| wild/url/search | 234965 | 122.60 ± 13.9% | not timed | not timed | 65.50 ± 0.5% | 2.21 ± 0.8% | not timed | not timed | 121.68 ± 14.1% | | 1.01 | 1.87 | 55.46 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.5% | not timed | not timed | 0.01 ± 11.5% | 0.01 ± 23.5% | not timed | not timed | 0.03 ± 1.6% | | 0.99 | 3.04 | 3.65 |
| dictionary/compile/english-15 | 1 | 0.35 ± 1.5% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 30.9% | not timed | not timed | 0.35 ± 20.0% | | 1.00 | 4.99 | 3.42 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 14.8% | not timed | not timed | 0.02 ± 0.2% | 37.03 ± 8.3% | not timed | not timed | 0.24 ± 1.9% | | 0.97 | 12.29 | 0.0064 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.33 ± 5.3% | not timed | not timed | 11.41 ± 0.3% | 57.28 ± 22.0% | not timed | not timed | 45.90 ± 1.9% | | 0.99 | 3.97 | 0.79 |
| reported/i787-keywords/compile | 1 | 35.39 ± 16.3% | not timed | not timed | 2.12 ± 1.0% | 17.60 ± 21.0% | not timed | not timed | 35.42 ± 1.4% | | 1.00 | 16.70 | 2.01 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 334.85 ± 5.2% | not timed | not timed | 118.92 ± 0.3% | 593.79 ± 24.2% | not timed | not timed | 336.43 ± 1.3% | | 1.00 | 2.82 | 0.56 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.67 ± 7.6% | not timed | not timed | 4.10 ± 0.4% | 44.29 ± 14.6% | not timed | not timed | 47.43 ± 2.5% | | 0.98 | 11.39 | 1.05 |
| unicode/compile/one-letter | 53 | 6.63 ± 11.4% | not timed | not timed | 4.54 ± 0.5% | 66.57 ± 8.0% | not timed | not timed | 6.74 ± 1.8% | | 0.98 | 1.46 | 0.0996 |
| unicode/compile/fifty-letters | 1 | 1.02 ± 1.8% | not timed | not timed | 0.10 ± 0.6% | 68.23 ± 13.4% | not timed | not timed | 1.06 ± 15.4% | | 0.96 | 10.23 | 0.0149 |
| unicode/compile/fifty-letters-ascii | 1 | 206.33 ± 2.6% | not timed | not timed | 52.84 ± 0.2% | 199.06 ± 20.0% | not timed | not timed | 207.61 ± 2.6% | | 0.99 | 3.90 | 1.04 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 381.26 ± 7.7% | not timed | not timed | 47.30 ± 0.3% | 701.15 ± 20.1% | not timed | not timed | 376.62 ± 1.8% | | 1.01 | 8.06 | 0.54 |
| unicode/compile/match-every-line-ascii | 4 | 585.77 ± 3.6% | not timed | not timed | 144.28 ± 0.3% | 682.61 ± 25.4% | not timed | not timed | 590.16 ± 10.6% | | 0.99 | 4.06 | 0.86 |
| unicode/compile/negated-class-matches-codepoint | 1 | 306.79 ± 3.3% | not timed | not timed | 51.22 ± 0.5% | 1242.69 ± 3.7% | not timed | not timed | 311.66 ± 4.0% | | 0.98 | 5.99 | 0.25 |
| wild/bibleref/compile | 3 | 5.81 ± 3.3% | not timed | not timed | 1.89 ± 0.8% | 32.56 ± 6.0% | not timed | not timed | 5.92 ± 3.3% | | 0.98 | 3.08 | 0.18 |
| wild/url/compile | 1 | 0.56 ± 16.1% | not timed | not timed | 0.14 ± 1.6% | 0.48 ± 10.9% | not timed | not timed | 0.65 ± 18.7% | | 0.85 | 3.83 | 1.17 |

