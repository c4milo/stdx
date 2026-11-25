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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506988364 |
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
| literal: a word | 217 | 19483.01 ± 0.7% | 5080.83 ± 0.1% | 27.74 ± 0.1% | 18018.60 ± 1.5% | 9016.75 ± 7.5% | 17.32 ± 0.3% | 85.88 ± 0.3% | 19516.92 ± 0.4% | 3.83 | 1.00 | 1.08 | 2.16 |
| literal: a word that is not there | 0 | 21533.48 ± 1.4% | 4943.42 ± 0.4% | 27.73 ± 0.5% | 19722.24 ± 2.4% | 28411.56 ± 3.0% | 17.18 ± 0.2% | 81.76 ± 0.4% | 21311.88 ± 3.6% | 4.36 | 1.01 | 1.09 | 0.76 |
| literal: one of four words | 661 | 6426.10 ± 0.5% | 1976.40 ± 0.4% | 14.27 ± 0.2% | 3943.04 ± 0.4% | 21.91 ± 0.2% | 5.38 ± 0.2% | 6.75 ± 0.3% | 6415.26 ± 0.6% | 3.25 | 1.00 | 1.63 | 293.29 |
| literal: a word in any case | 217 | 15147.06 ± 0.5% | 2104.54 ± 0.3% | 21.22 ± 0.3% | 3973.44 ± 0.1% | 38.06 ± 0.4% | refused | differs | 15135.27 ± 0.7% | 7.20 | 1.00 | 3.81 | 397.99 |
| literal: an href attribute | 33 | 16941.61 ± 2.3% | 618.32 ± 0.1% | 26.83 ± 0.3% | 17151.17 ± 0.5% | 2257.02 ± 0.5% | 13.13 ± 0.2% | 74.90 ± 0.1% | 17072.81 ± 2.0% | 27.40 | 0.99 | 0.99 | 7.51 |
| literal: a word, second text | 123 | 20050.27 ± 2.2% | 3400.92 ± 0.5% | 27.58 ± 0.4% | 18521.56 ± 1.3% | 7786.70 ± 5.6% | 20.09 ± 0.4% | 68.47 ± 0.2% | 20050.14 ± 0.8% | 5.90 | 1.00 | 1.08 | 2.57 |
| class: two capitalized words | 1331 | 1063.17 ± 0.5% | 609.39 ± 0.2% | 25.65 ± 0.3% | 585.24 ± 0.1% | 40.60 ± 1.2% | 14.73 ± 0.3% | 68.23 ± 0.6% | 1063.48 ± 0.4% | 1.74 | 1.00 | 1.82 | 26.19 |
| class: a word that ends in ing | 3399 | 582.55 ± 0.1% | 583.18 ± 0.3% | 17.86 ± 0.1% | 547.09 ± 0.5% | 29.63 ± 6.9% | 8.12 ± 0.1% | 18.21 ± 0.3% | 583.62 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.66 |
| class: a word in capitals | 2332 | 1385.03 ± 0.7% | 614.23 ± 0.3% | 27.20 ± 0.4% | 572.40 ± 0.2% | 43.56 ± 9.4% | 17.16 ± 0.3% | 82.75 ± 0.9% | 1389.00 ± 0.6% | 2.25 | 1.00 | 2.42 | 31.80 |
| class: a number | 8288 | 2132.63 ± 0.7% | 853.39 ± 0.2% | 27.31 ± 0.3% | 1723.48 ± 0.1% | 38.99 ± 15.5% | 0.55 ± 0.2% | 56.69 ± 0.2% | 2136.66 ± 0.3% | 2.50 | 1.00 | 1.24 | 54.69 |
| class: two capitalized words, second text | 5359 | 525.78 ± 0.2% | 534.70 ± 0.1% | 23.10 ± 0.1% | 484.43 ± 0.2% | 35.39 ± 15.0% | 17.09 ± 0.3% | 63.36 ± 0.5% | 526.25 ± 0.2% | 0.98 | 1.00 | 1.09 | 14.86 |
| other: a word between two words | 6104 | 807.53 ± 0.4% | 609.75 ± 0.2% | 23.34 ± 0.1% | 740.25 ± 0.4% | 108.80 ± 22.1% | 11.18 ± 0.1% | 69.09 ± 0.6% | 804.35 ± 0.3% | 1.32 | 1.00 | 1.09 | 7.42 |
| other: a number before a unit, second text | 1481 | 6197.19 ± 1.2% | 1132.03 ± 0.2% | 25.57 ± 0.1% | 5665.99 ± 0.4% | 40.70 ± 0.2% | 18.18 ± 0.1% | 66.69 ± 0.3% | 6166.72 ± 0.9% | 5.47 | 1.00 | 1.09 | 152.26 |
| other: a heading's start tag | 110 | 14258.54 ± 1.9% | 750.96 ± 0.1% | 26.88 ± 0.3% | 1710.63 ± 0.7% | 1584.54 ± 2.5% | 16.00 ± 0.2% | 88.35 ± 0.4% | 14236.71 ± 0.7% | 18.99 | 1.00 | 8.34 | 9.00 |
| other: a whole word | 217 | 16278.70 ± 0.8% | 607.88 ± 0.3% | 28.68 ± 0.3% | 14631.57 ± 1.2% | 48.00 ± 0.3% | 13.16 ± 0.2% | 55.11 ± 1.6% | 16390.24 ± 1.2% | 26.78 | 0.99 | 1.11 | 339.16 |
| other: a line's first word, second text | 3716 | 2105.68 ± 0.5% | 600.25 ± 0.2% | 30.15 ± 0.3% | 1725.67 ± 0.6% | 62.18 ± 6.2% | refused | refused | 2117.69 ± 0.9% | 3.51 | 0.99 | 1.22 | 33.86 |
| other: fourteen octets before an x | 87 | 24234.70 ± 2.2% | 241.41 ± 0.1% | 6.52 ± 0.1% | 3936.42 ± 0.9% | 10.65 ± 0.3% | differs | 17.45 ± 0.1% | 24362.12 ± 9.0% | 100.39 | 0.99 | 6.16 | 2275.58 |
| other: a Greek word | 21815 | 522.56 ± 0.5% | 425.35 ± 0.2% | 30.52 ± 0.7% | 290.05 ± 0.3% | 49.19 ± 11.7% | differs | refused | 522.02 ± 0.2% | 1.23 | 1.00 | 1.80 | 10.62 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.27 ± 0.3% | 29.20 ± 0.4% | 0.86 ± 0.3% | 19.78 ± 0.4% | 2.77 ± 1.1% | differs | 4.03 ± 0.4% | 29.26 ± 0.2% | 1.00 | 1.00 | 1.48 | 10.56 |
| a UUID | 32895 | 24.54 ± 0.1% | 24.61 ± 0.3% | 0.64 ± 0.1% | 15.07 ± 0.5% | 3.09 ± 0.3% | 0.73 ± 0.4% | 3.60 ± 0.5% | 24.77 ± 0.1% | 1.00 | 0.99 | 1.63 | 7.93 |
| an IPv4 address | 33176 | 38.47 ± 0.6% | 38.43 ± 0.2% | 2.09 ± 0.3% | 29.33 ± 0.6% | 6.66 ± 0.1% | differs | 4.16 ± 0.3% | 38.27 ± 0.4% | 1.00 | 1.01 | 1.31 | 5.77 |
| a date and time | 32954 | 34.42 ± 0.2% | 33.96 ± 0.2% | 1.45 ± 0.2% | 21.51 ± 0.8% | 7.05 ± 0.1% | 1.26 ± 0.3% | 7.12 ± 0.2% | 34.28 ± 0.3% | 1.01 | 1.00 | 1.60 | 4.89 |
| a field path | 32606 | 32.53 ± 0.5% | 32.54 ± 0.5% | 1.02 ± 0.1% | 23.21 ± 0.4% | 3.50 ± 0.9% | differs | 2.93 ± 0.5% | 32.46 ± 0.4% | 1.00 | 1.00 | 1.40 | 9.29 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.4% | 11.09 ± 0.2% | 11.13 ± 0.1% | 11.47 ± 0.1% | 4.95 ± 1.5% | 0.94 ± 0.6% | none | 11.07 ± 0.3% | 1.00 | 1.01 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.97 ± 0.4% | 223.30 ± 0.5% | 265.86 ± 0.2% | 86.54 ± 0.2% | 220.35 ± 1.7% | 486.43 ± 0.8% | 3746.24 ± 0.3% | 222.86 ± 0.3% | 1.00 | 1.00 | 2.58 | 1.01 |
| a UUID | 62 | 145.67 ± 0.3% | 145.98 ± 0.4% | 163.90 ± 0.1% | 45.86 ± 0.9% | 98.64 ± 1.4% | 181.92 ± 1.9% | 4486.48 ± 1.9% | 145.76 ± 0.3% | 1.00 | 1.00 | 3.18 | 1.48 |
| an IPv4 address | 29 | 411.85 ± 0.4% | 412.50 ± 1.8% | 586.40 ± 0.8% | 76.02 ± 0.7% | 130.89 ± 1.6% | 291.98 ± 0.9% | 7665.24 ± 0.3% | 412.23 ± 0.5% | 1.00 | 1.00 | 5.42 | 3.15 |
| a date and time | 56 | 299.68 ± 0.5% | 300.06 ± 0.3% | 383.52 ± 0.2% | 72.34 ± 1.0% | 137.57 ± 1.0% | 322.44 ± 1.3% | 4962.18 ± 0.7% | 299.92 ± 0.3% | 1.00 | 1.00 | 4.14 | 2.18 |
| a field path | 39 | 214.35 ± 0.4% | 214.64 ± 0.4% | 254.08 ± 0.3% | 79.04 ± 0.4% | 206.89 ± 2.1% | 485.43 ± 1.4% | 4852.36 ± 2.8% | 214.06 ± 0.2% | 1.00 | 1.00 | 2.71 | 1.04 |
| literal: a word | 7 | 596.59 ± 0.6% | 646.39 ± 0.6% | 1194.48 ± 0.5% | 496.48 ± 1.5% | 624.03 ± 1.3% | 919.49 ± 0.3% | 30562.41 ± 0.1% | 597.86 ± 0.2% | 0.92 | 1.00 | 1.20 | 0.96 |
| literal: a word that is not there | 8 | 574.76 ± 0.7% | 624.89 ± 0.3% | 1127.19 ± 0.6% | 456.90 ± 0.3% | 603.08 ± 2.7% | 868.61 ± 0.3% | 29581.61 ± 0.3% | 575.20 ± 0.3% | 0.92 | 1.00 | 1.26 | 0.95 |
| literal: one of four words | 26 | 236.30 ± 0.2% | 385.44 ± 0.2% | 537.72 ± 0.4% | 49.33 ± 0.2% | 241.54 ± 1.9% | 355.07 ± 0.5% | 15784.76 ± 0.1% | 236.39 ± 0.2% | 0.61 | 1.00 | 4.79 | 0.98 |
| literal: a word in any case | 11 | 437.01 ± 0.4% | 467.67 ± 0.3% | 705.43 ± 0.2% | 15.67 ± 0.9% | 652.46 ± 1.3% | refused | 23811.59 ± 0.5% | 437.44 ± 0.4% | 0.93 | 1.00 | 27.89 | 0.67 |
| literal: an href attribute | 12 | 334.66 ± 0.5% | 347.78 ± 0.6% | 464.12 ± 0.2% | 10.00 ± 3.4% | 496.71 ± 1.4% | 757.08 ± 0.5% | 22423.57 ± 0.2% | 334.98 ± 0.2% | 0.96 | 1.00 | 33.46 | 0.67 |
| literal: a word, second text | 10 | 530.84 ± 0.6% | 586.02 ± 0.9% | 1006.56 ± 0.8% | 412.08 ± 0.3% | 532.29 ± 7.9% | 784.46 ± 0.3% | 27487.53 ± 0.3% | 532.29 ± 0.5% | 0.91 | 1.00 | 1.29 | 1.00 |
| class: two capitalized words | 23 | 419.61 ± 0.6% | 449.71 ± 0.6% | 662.41 ± 0.7% | 99.93 ± 1.3% | 504.02 ± 1.5% | 759.67 ± 0.5% | 6384.10 ± 0.1% | 418.86 ± 0.4% | 0.93 | 1.00 | 4.20 | 0.83 |
| class: a word that ends in ing | 9 | 525.09 ± 0.3% | 594.01 ± 0.2% | 1074.19 ± 0.3% | 131.54 ± 1.1% | 760.59 ± 1.8% | 1083.13 ± 4.2% | 15955.55 ± 0.2% | 524.54 ± 0.5% | 0.88 | 1.00 | 3.99 | 0.69 |
| class: a word in capitals | 16 | 467.88 ± 0.4% | 508.27 ± 0.5% | 835.21 ± 0.3% | 134.06 ± 0.9% | 752.35 ± 1.5% | 1000.15 ± 0.6% | 8390.50 ± 0.1% | 467.21 ± 0.5% | 0.92 | 1.00 | 3.49 | 0.62 |
| class: a number | 6 | 590.06 ± 0.5% | 653.40 ± 0.7% | 1265.85 ± 0.3% | 41.99 ± 0.6% | 1397.05 ± 0.6% | 1902.18 ± 0.2% | 23133.68 ± 0.1% | 589.35 ± 0.6% | 0.90 | 1.00 | 14.05 | 0.42 |
| class: two capitalized words, second text | 23 | 419.85 ± 0.4% | 450.64 ± 0.4% | 662.60 ± 0.2% | 100.06 ± 1.5% | 500.77 ± 0.8% | 758.58 ± 0.3% | 6384.39 ± 0.1% | 419.04 ± 0.5% | 0.93 | 1.00 | 4.20 | 0.84 |
| other: a word between two words | 13 | 520.06 ± 0.5% | 541.23 ± 0.5% | 885.44 ± 0.5% | 133.88 ± 0.5% | 497.22 ± 0.7% | 821.94 ± 1.0% | 14771.24 ± 0.1% | 520.40 ± 0.4% | 0.96 | 1.00 | 3.88 | 1.05 |
| other: a number before a unit, second text | 15 | 379.27 ± 0.2% | 420.64 ± 0.1% | 600.29 ± 0.3% | 39.57 ± 0.3% | 629.11 ± 1.0% | 897.63 ± 0.3% | 15428.04 ± 0.2% | 378.52 ± 0.2% | 0.90 | 1.00 | 9.59 | 0.60 |
| other: a heading's start tag | 13 | 345.99 ± 0.3% | 353.86 ± 0.3% | 474.41 ± 0.5% | 10.51 ± 28.5% | 623.83 ± 2.0% | 853.93 ± 0.3% | 18528.48 ± 0.1% | 346.07 ± 0.7% | 0.98 | 1.00 | 32.91 | 0.55 |
| other: a whole word | 11 | 550.45 ± 0.4% | 587.99 ± 0.4% | 1013.31 ± 0.3% | 119.67 ± 0.2% | 561.88 ± 1.6% | 818.96 ± 0.8% | 26981.53 ± 0.4% | 550.95 ± 0.5% | 0.94 | 1.00 | 4.60 | 0.98 |
| other: a line's first word, second text | 17 | 498.65 ± 0.5% | 528.03 ± 0.2% | 873.22 ± 0.8% | 128.09 ± 0.2% | 710.16 ± 1.4% | refused | refused | 499.02 ± 0.7% | 0.94 | 1.00 | 3.89 | 0.70 |
| other: fourteen octets before an x | 16 | 106.11 ± 0.5% | 151.40 ± 0.7% | 176.87 ± 2.0% | 7.74 ± 17.8% | 452.37 ± 1.4% | 417.56 ± 1.4% | 12799.34 ± 0.4% | 106.11 ± 0.8% | 0.70 | 1.00 | 13.71 | 0.23 |
| other: a Greek word | 8 | 411.66 ± 0.4% | 566.92 ± 0.3% | 990.33 ± 0.2% | 11.06 ± 41.4% | 1379.98 ± 13.4% | 1745.06 ± 1.3% | refused | 411.63 ± 0.3% | 0.73 | 1.00 | 37.22 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15774.02 ± 0.7% | not timed | not timed | 16233.91 ± 1.6% | 2150.34 ± 16.5% | not timed | not timed | 15738.96 ± 0.9% | | 1.00 | 0.97 | 7.34 |
| 01-literal/sherlock-casei-en | 522 | 11078.16 ± 3.9% | not timed | not timed | 3590.63 ± 0.2% | 32.60 ± 0.1% | not timed | not timed | 11085.04 ± 1.1% | | 1.00 | 3.09 | 339.87 |
| 01-literal/sherlock-ru | 724 | 17195.86 ± 0.3% | not timed | not timed | 17168.60 ± 1.7% | 1566.52 ± 14.3% | not timed | not timed | 17200.67 ± 1.7% | | 1.00 | 1.00 | 10.98 |
| 01-literal/sherlock-casei-ru | 746 | 6151.14 ± 0.2% | not timed | not timed | 3325.55 ± 0.2% | 31.66 ± 0.5% | not timed | not timed | 6160.02 ± 0.1% | | 1.00 | 1.85 | 194.31 |
| 01-literal/sherlock-zh | 30 | 19562.24 ± 1.3% | not timed | not timed | 18564.56 ± 1.8% | 2906.96 ± 3.7% | not timed | not timed | 19517.70 ± 1.7% | | 1.00 | 1.05 | 6.73 |
| 02-literal-alternate/sherlock-en | 714 | 6155.49 ± 0.3% | not timed | not timed | 3934.50 ± 0.3% | 16.58 ± 0.4% | not timed | not timed | 6155.65 ± 0.4% | | 1.00 | 1.56 | 371.30 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1976.31 ± 2.1% | not timed | not timed | 696.49 ± 0.1% | 11.13 ± 13.3% | not timed | not timed | 1977.30 ± 1.3% | | 1.00 | 2.84 | 177.57 |
| 02-literal-alternate/sherlock-ru | 899 | 5542.40 ± 0.2% | not timed | not timed | 3250.93 ± 0.2% | 22.62 ± 0.1% | not timed | not timed | 5466.87 ± 0.1% | | 1.01 | 1.70 | 245.07 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.21 ± 0.4% | not timed | not timed | 1232.67 ± 0.6% | 9.14 ± 0.9% | not timed | not timed | 2059.24 ± 0.4% | | 1.00 | 1.67 | 225.15 |
| 02-literal-alternate/sherlock-zh | 207 | 7324.17 ± 0.4% | not timed | not timed | 4162.26 ± 0.5% | 31.56 ± 0.1% | not timed | not timed | 7338.94 ± 0.6% | | 1.00 | 1.76 | 232.08 |
| 03-date/ascii | 111817 | 133.71 ± 0.6% | not timed | not timed | 95.31 ± 0.1% | 0.20 ± 2.3% | not timed | not timed | 134.19 ± 0.4% | | 1.00 | 1.40 | 655.94 |
| 04-ruff-noqa/real | 84 | 438.49 ± 0.1% | not timed | not timed | 478.51 ± 0.1% | 19.56 ± 1.2% | not timed | not timed | 438.12 ± 0.2% | | 1.00 | 0.92 | 22.42 |
| 04-ruff-noqa/tweaked | 44 | 593.38 ± 0.2% | not timed | not timed | 465.51 ± 0.1% | 361.72 ± 0.3% | not timed | not timed | 594.02 ± 0.1% | | 1.00 | 1.27 | 1.64 |
| 05-lexer-veryl/single | 124800 | 5.28 ± 0.5% | not timed | not timed | 5.15 ± 0.4% | 0.20 ± 2.0% | not timed | not timed | 5.27 ± 0.2% | | 1.00 | 1.03 | 26.13 |
| 06-cloud-flare-redos/original | 107 | 427.15 ± 0.2% | not timed | not timed | 216.05 ± 0.1% | 24.93 ± 0.2% | not timed | not timed | 431.20 ± 0.1% | | 0.99 | 1.98 | 17.13 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.68 ± 0.1% | not timed | not timed | 227.39 ± 0.1% | 26.67 ± 0.3% | not timed | not timed | 429.70 ± 0.2% | | 1.00 | 1.90 | 16.18 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.56 ± 0.4% | not timed | not timed | 256.26 ± 0.2% | 28.70 ± 0.3% | not timed | not timed | 588.57 ± 0.1% | | 1.00 | 2.30 | 20.51 |
| 07-unicode-character-data/parse-line | 558784 | 239.01 ± 1.5% | not timed | not timed | 180.30 ± 0.4% | 42.43 ± 13.1% | not timed | not timed | 239.47 ± 2.0% | | 1.00 | 1.33 | 5.63 |
| 08-words/all-english | 56691 | 127.28 ± 0.9% | not timed | not timed | 79.96 ± 0.1% | 11.60 ± 4.7% | not timed | not timed | 127.25 ± 0.7% | | 1.00 | 1.59 | 10.97 |
| 08-words/long-english | 839 | 623.51 ± 0.2% | not timed | not timed | 597.36 ± 0.1% | 32.26 ± 0.2% | not timed | not timed | 623.81 ± 0.1% | | 1.00 | 1.04 | 19.33 |
| 09-aws-keys/full | 0 | 443.72 ± 0.2% | not timed | not timed | 475.02 ± 0.1% | 64.47 ± 0.1% | not timed | not timed | 442.06 ± 0.1% | | 1.00 | 0.93 | 6.88 |
| 09-aws-keys/quick | 0 | 875.64 ± 0.9% | not timed | not timed | 1000.96 ± 0.2% | 421.92 ± 0.5% | not timed | not timed | 875.64 ± 0.2% | | 1.00 | 0.87 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 585.87 ± 3.0% | not timed | not timed | 517.46 ± 0.3% | 19.57 ± 0.3% | not timed | not timed | 578.07 ± 3.3% | | 1.01 | 1.13 | 29.94 |
| 10-bounded-repeat/letters-ru | 3475 | 504.36 ± 1.1% | not timed | not timed | 477.80 ± 0.2% | 22.61 ± 17.1% | not timed | not timed | 506.29 ± 1.5% | | 1.00 | 1.06 | 22.31 |
| 10-bounded-repeat/context | 53 | 85.13 ± 1.8% | not timed | not timed | 66.18 ± 0.5% | 19.82 ± 0.1% | not timed | not timed | 85.57 ± 1.6% | | 0.99 | 1.29 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 633.40 ± 8.6% | not timed | not timed | 615.72 ± 0.1% | 36.51 ± 0.2% | not timed | not timed | 633.81 ± 8.0% | | 1.00 | 1.03 | 17.35 |
| 11-unstructured-to-json/extract | 600 | 57.37 ± 1.1% | not timed | not timed | 77.16 ± 0.3% | 49.03 ± 0.4% | not timed | not timed | 57.27 ± 0.5% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 560.47 ± 1.2% | not timed | not timed | 560.86 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 559.04 ± 0.9% | | 1.00 | 1.00 | 1370.10 |
| 14-quadratic/1x | 100 | 21.34 ± 1.2% | not timed | not timed | 10.02 ± 0.3% | 0.98 ± 4.0% | not timed | not timed | 21.43 ± 1.6% | | 1.00 | 2.13 | 21.77 |
| 14-quadratic/2x | 200 | 17.76 ± 1.5% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.6% | not timed | not timed | 17.86 ± 0.9% | | 0.99 | 3.20 | 33.32 |
| 14-quadratic/10x | 1000 | 7.76 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.78 ± 0.2% | | 1.00 | 6.44 | 67.27 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 1.5% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 1.5% | not timed | not timed | 1.26 ± 2.0% | | 0.99 | 3.63 | 2.27 |
| 04-ruff-noqa/compile-real | 1 | 104.63 ± 1.5% | not timed | not timed | 13.81 ± 0.5% | 140.91 ± 2.3% | not timed | not timed | 104.29 ± 1.1% | | 1.00 | 7.58 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 14.00 ± 1.5% | not timed | not timed | 2.51 ± 0.9% | 6.47 ± 1.6% | not timed | not timed | 14.03 ± 1.2% | | 1.00 | 5.58 | 2.17 |
| 07-unicode-character-data/compile | 1 | 108.09 ± 1.5% | not timed | not timed | 25.88 ± 0.3% | 36.21 ± 3.3% | not timed | not timed | 107.65 ± 1.2% | | 1.00 | 4.18 | 2.99 |
| 09-aws-keys/compile-full | 1 | 52.73 ± 1.7% | not timed | not timed | 8.22 ± 0.3% | 23.29 ± 0.7% | not timed | not timed | 52.65 ± 0.2% | | 1.00 | 6.41 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 182.93 ± 0.9% | not timed | not timed | 47.20 ± 0.2% | 132.91 ± 2.3% | not timed | not timed | 181.18 ± 0.3% | | 1.01 | 3.88 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 71.07 ± 1.1% | not timed | not timed | 11.15 ± 0.3% | 16.14 ± 1.4% | not timed | not timed | 71.16 ± 2.2% | | 1.00 | 6.38 | 4.40 |
| 10-bounded-repeat/compile-capitals | 1 | 81.89 ± 2.1% | not timed | not timed | 8.06 ± 0.2% | 23.87 ± 0.9% | not timed | not timed | 82.05 ± 0.4% | | 1.00 | 10.15 | 3.43 |
| 11-unstructured-to-json/compile | 1 | 172.22 ± 1.2% | not timed | not timed | 40.84 ± 0.3% | 68.39 ± 3.2% | not timed | not timed | 170.59 ± 0.3% | | 1.01 | 4.22 | 2.52 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.9% | not timed | not timed | 0.07 ± 13.5% | 0.10 ± 27.9% | not timed | not timed | 0.35 ± 0.7% | | 1.00 | 5.12 | 3.57 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.30 ± 2.9% | not timed | not timed | 6.57 ± 0.2% | 0.58 ± 15.0% | not timed | not timed | 7.26 ± 3.0% | | 1.01 | 1.11 | 12.68 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.7% | not timed | not timed | 164.40 ± 0.6% | 0.00 ± 0.6% | not timed | not timed | 1.16 ± 1.7% | | 1.00 | 0.0071 | 411.05 |
| dictionary/search/english-15 | 15 | 566.77 ± 0.9% | not timed | not timed | 561.78 ± 0.2% | 0.37 ± 0.8% | not timed | not timed | 566.94 ± 1.1% | | 1.00 | 1.01 | 1543.02 |
| folly/awyer-inn-busted | 1 | 5594.10 ± 0.1% | not timed | not timed | 143.58 ± 0.2% | 43.82 ± 0.1% | not timed | not timed | 5613.17 ± 0.1% | | 1.00 | 38.96 | 127.65 |
| folly/literal-never-match-rare | 0 | 21096.30 ± 0.5% | not timed | not timed | 19930.70 ± 0.1% | 40914.05 ± 0.7% | not timed | not timed | 21096.12 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12476.13 ± 1.6% | not timed | not timed | 19889.95 ± 0.2% | 2196.45 ± 0.4% | not timed | not timed | 12471.26 ± 1.3% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3238.82 ± 0.3% | not timed | not timed | 4412.05 ± 0.2% | 3055.73 ± 0.1% | not timed | not timed | 3243.80 ± 0.3% | | 1.00 | 0.73 | 1.06 |
| grep/every-line | 239963 | 1316.11 ± 0.5% | not timed | not timed | 952.81 ± 0.4% | 383.36 ± 16.6% | not timed | not timed | 1319.20 ± 0.9% | | 1.00 | 1.38 | 3.43 |
| grep/long-words-ascii | 5073 | 459.40 ± 0.2% | not timed | not timed | 469.72 ± 0.1% | 46.04 ± 7.9% | not timed | not timed | 404.65 ± 0.4% | | 1.14 | 0.98 | 9.98 |
| imported/leipzig/twain | 811 | 20663.88 ± 1.0% | not timed | not timed | 19552.84 ± 0.8% | 11948.85 ± 11.0% | not timed | not timed | 20683.17 ± 0.6% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9047.10 ± 1.2% | not timed | not timed | 4252.01 ± 0.4% | 37.77 ± 0.9% | not timed | not timed | 9096.45 ± 0.9% | | 0.99 | 2.13 | 239.56 |
| imported/leipzig/shing | 1540 | 15200.20 ± 2.1% | not timed | not timed | 13479.52 ± 0.5% | 33.99 ± 0.1% | not timed | not timed | 15438.77 ± 1.9% | | 0.98 | 1.13 | 447.15 |
| imported/leipzig/huck-saw | 262 | 8244.77 ± 2.8% | not timed | not timed | 5605.86 ± 0.1% | 31.82 ± 0.2% | not timed | not timed | 8430.82 ± 3.1% | | 0.98 | 1.47 | 259.09 |
| imported/leipzig/word-ending-nn | 262 | 604.93 ± 0.4% | not timed | not timed | 617.08 ± 0.2% | 24.66 ± 0.2% | not timed | not timed | 605.39 ± 0.3% | | 1.00 | 0.98 | 24.53 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11197.29 ± 0.6% | not timed | not timed | 4534.96 ± 0.6% | 11.49 ± 0.1% | not timed | not timed | 11252.46 ± 1.0% | | 1.00 | 2.47 | 974.26 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7803.92 ± 1.6% | not timed | not timed | 5480.38 ± 0.4% | 16.83 ± 0.0% | not timed | not timed | 7911.80 ± 2.0% | | 0.99 | 1.42 | 463.60 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4167.63 ± 0.7% | not timed | not timed | 417.50 ± 0.5% | 11.12 ± 0.1% | not timed | not timed | 4175.47 ± 1.2% | | 1.00 | 9.98 | 374.81 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 603.92 ± 0.1% | not timed | not timed | 615.22 ± 0.0% | 11.10 ± 0.1% | not timed | not timed | 602.26 ± 0.4% | | 1.00 | 0.98 | 54.39 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 603.71 ± 0.2% | not timed | not timed | 616.04 ± 0.1% | 9.75 ± 0.0% | not timed | not timed | 602.69 ± 0.4% | | 1.00 | 0.98 | 61.90 |
| imported/leipzig/tom-river | 2 | 6414.91 ± 1.9% | not timed | not timed | 5129.91 ± 0.7% | 30.57 ± 0.2% | not timed | not timed | 6508.00 ± 2.0% | | 0.99 | 1.25 | 209.86 |
| imported/leipzig/ing | 78424 | 601.67 ± 0.7% | not timed | not timed | 570.63 ± 0.1% | 28.10 ± 3.4% | not timed | not timed | 602.05 ± 0.8% | | 1.00 | 1.05 | 21.41 |
| imported/leipzig/ing-whitespace | 55248 | 751.31 ± 0.7% | not timed | not timed | 2042.46 ± 1.1% | 20.54 ± 2.9% | not timed | not timed | 752.83 ± 0.3% | | 1.00 | 0.37 | 36.57 |
| imported/leipzig/awyer-inn | 209 | 769.06 ± 1.5% | not timed | not timed | 4184.58 ± 5.8% | 22.66 ± 0.1% | not timed | not timed | 768.22 ± 1.4% | | 1.00 | 0.18 | 33.94 |
| imported/leipzig/quotes-bounded | 8886 | 2115.63 ± 1.5% | not timed | not timed | 2960.69 ± 1.3% | 38.23 ± 0.1% | not timed | not timed | 2115.14 ± 0.9% | | 1.00 | 0.71 | 55.33 |
| imported/leipzig/non-ascii-alternate | 2 | 12832.64 ± 1.7% | not timed | not timed | 5659.27 ± 0.3% | 50.70 ± 0.1% | not timed | not timed | 12974.92 ± 2.0% | | 0.99 | 2.27 | 253.12 |
| imported/leipzig/math-symbols | 69 | 1982.44 ± 0.5% | not timed | not timed | 619.30 ± 0.1% | 36.36 ± 0.1% | not timed | not timed | 1984.81 ± 1.1% | | 1.00 | 3.20 | 54.52 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.45 ± 1.2% | not timed | not timed | 615.18 ± 0.1% | 22.03 ± 0.2% | not timed | not timed | 586.31 ± 1.2% | | 1.00 | 0.95 | 26.62 |
| imported/lh3lh3-reb/uri | 17549 | 680.04 ± 0.1% | not timed | not timed | 1074.93 ± 0.3% | 28.35 ± 2.1% | not timed | not timed | 679.71 ± 0.1% | | 1.00 | 0.63 | 23.99 |
| imported/lh3lh3-reb/email | 15057 | 674.84 ± 0.1% | not timed | not timed | 1166.77 ± 0.1% | 30.90 ± 2.5% | not timed | not timed | 673.54 ± 0.1% | | 1.00 | 0.58 | 21.84 |
| imported/lh3lh3-reb/date | 668 | 860.90 ± 0.3% | not timed | not timed | 1038.40 ± 0.2% | 51.37 ± 3.9% | not timed | not timed | 859.83 ± 0.2% | | 1.00 | 0.83 | 16.76 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.57 ± 0.2% | not timed | not timed | 424.29 ± 0.2% | 15.78 ± 1.3% | not timed | not timed | 645.54 ± 0.1% | | 1.00 | 1.52 | 40.98 |
| imported/mariomka/email | 92 | 24352.73 ± 1.2% | not timed | not timed | 29633.78 ± 0.4% | 32.87 ± 0.2% | not timed | not timed | 24375.70 ± 1.2% | | 1.00 | 0.82 | 740.97 |
| imported/mariomka/uri | 5301 | 5338.06 ± 1.0% | not timed | not timed | 6086.09 ± 0.2% | 32.75 ± 0.4% | not timed | not timed | 5373.42 ± 0.8% | | 0.99 | 0.88 | 163.02 |
| imported/mariomka/ip | 5 | 2152.62 ± 2.1% | not timed | not timed | 2968.11 ± 0.4% | 21.04 ± 0.4% | not timed | not timed | 2150.34 ± 2.4% | | 1.00 | 0.73 | 102.31 |
| imported/rsc/no-exponential | 0 | 605.11 ± 0.2% | not timed | not timed | 320.54 ± 0.2% | 23.91 ± 0.3% | not timed | not timed | 600.74 ± 0.3% | | 1.01 | 1.89 | 25.31 |
| imported/rsc/literal | 1 | 770.21 ± 3.3% | not timed | not timed | 1615.63 ± 6.1% | 185.87 ± 15.4% | not timed | not timed | 770.34 ± 5.2% | | 1.00 | 0.48 | 4.14 |
| imported/rsc/not-literal | 2 | 779.87 ± 0.3% | not timed | not timed | 732.61 ± 0.2% | 46.40 ± 9.7% | not timed | not timed | 782.07 ± 2.4% | | 1.00 | 1.06 | 16.81 |
| imported/rsc/match-class | 1 | 1442.53 ± 0.3% | not timed | not timed | 1631.15 ± 0.2% | 58.77 ± 14.2% | not timed | not timed | 1438.91 ± 2.3% | | 1.00 | 0.88 | 24.55 |
| imported/rsc/match-class-in-range | 1 | 1442.47 ± 0.3% | not timed | not timed | 2404.55 ± 4.6% | 59.41 ± 7.1% | not timed | not timed | 1439.79 ± 2.5% | | 1.00 | 0.60 | 24.28 |
| imported/rsc/match-class-unicode | 1 | 547.73 ± 0.2% | not timed | not timed | 514.72 ± 0.1% | 72.11 ± 0.3% | not timed | not timed | 548.82 ± 0.2% | | 1.00 | 1.06 | 7.60 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1445.13 ± 0.1% | not timed | not timed | 942.32 ± 0.1% | 228.08 ± 0.8% | not timed | not timed | 1446.28 ± 0.2% | | 1.00 | 1.53 | 6.34 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21667.68 ± 0.1% | not timed | not timed | 14070.52 ± 0.1% | 3421.64 ± 0.3% | not timed | not timed | 21646.44 ± 0.0% | | 1.00 | 1.54 | 6.33 |
| imported/rsc/anchored-literal-short-match | 4 | 706.71 ± 2.0% | not timed | not timed | 482.82 ± 0.1% | 82.38 ± 7.2% | not timed | not timed | 714.62 ± 5.6% | | 0.99 | 1.46 | 8.58 |
| imported/rsc/anchored-literal-long-match | 4 | 10557.89 ± 2.1% | not timed | not timed | 7363.34 ± 0.2% | 1240.36 ± 4.5% | not timed | not timed | 10710.37 ± 1.9% | | 0.99 | 1.43 | 8.51 |
| imported/rsc/one-pass-short | 17 | 374.10 ± 0.8% | not timed | not timed | 216.17 ± 0.2% | 30.22 ± 12.4% | not timed | not timed | 373.02 ± 1.9% | | 1.00 | 1.73 | 12.38 |
| imported/rsc/one-pass-short-not | 17 | 280.18 ± 8.3% | not timed | not timed | 226.56 ± 0.1% | 31.03 ± 13.2% | not timed | not timed | 281.57 ± 2.1% | | 1.00 | 1.24 | 9.03 |
| imported/rsc/one-pass-long-prefix | 26 | 360.31 ± 8.1% | not timed | not timed | 281.72 ± 0.2% | 95.74 ± 18.6% | not timed | not timed | 365.67 ± 1.7% | | 0.99 | 1.28 | 3.76 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.53 ± 2.0% | not timed | not timed | 282.40 ± 0.1% | 65.60 ± 22.0% | not timed | not timed | 362.59 ± 2.1% | | 0.99 | 1.27 | 5.48 |
| imported/rsc/long-needle1 | 31 | 22184.33 ± 0.2% | not timed | not timed | 20157.92 ± 0.1% | 3.71 ± 0.1% | not timed | not timed | 22197.69 ± 0.2% | | 1.00 | 1.10 | 5975.16 |
| imported/rsc/long-needle2 | 31 | 22329.54 ± 0.1% | not timed | not timed | 216.41 ± 0.1% | 3.72 ± 0.2% | not timed | not timed | 22336.87 ± 0.2% | | 1.00 | 103.18 | 5999.62 |
| imported/rsc/easy0-32 | 26 | 1069.95 ± 10.4% | not timed | not timed | 1518.21 ± 0.4% | 145.92 ± 20.7% | not timed | not timed | 1091.40 ± 0.1% | | 0.98 | 0.70 | 7.33 |
| imported/rsc/easy0-1k | 26 | 14903.50 ± 8.2% | not timed | not timed | 12507.81 ± 0.3% | 2312.36 ± 12.1% | not timed | not timed | 14914.64 ± 0.1% | | 1.00 | 1.19 | 6.45 |
| imported/rsc/easy0-32k | 26 | 23006.14 ± 0.2% | not timed | not timed | 20316.41 ± 0.0% | 18868.03 ± 0.3% | not timed | not timed | 23011.90 ± 0.2% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21607.44 ± 2.1% | not timed | not timed | 19701.38 ± 2.4% | 36260.93 ± 8.2% | not timed | not timed | 21453.23 ± 2.2% | | 1.01 | 1.10 | 0.60 |
| imported/rsc/easy1-32 | 19 | 806.19 ± 2.4% | not timed | not timed | 624.48 ± 0.7% | 130.51 ± 18.2% | not timed | not timed | 804.98 ± 2.4% | | 1.00 | 1.29 | 6.18 |
| imported/rsc/easy1-1k | 19 | 16544.59 ± 2.2% | not timed | not timed | 12721.48 ± 0.2% | 2502.41 ± 17.9% | not timed | not timed | 16527.51 ± 2.0% | | 1.00 | 1.30 | 6.61 |
| imported/rsc/easy1-32k | 19 | 516991.10 ± 2.4% | not timed | not timed | 397682.66 ± 0.2% | 20422.17 ± 29.4% | not timed | not timed | 517355.24 ± 0.2% | | 1.00 | 1.30 | 25.32 |
| imported/rsc/easy1-1mb | 19 | 16651679.59 ± 0.0% | not timed | not timed | 12873654.81 ± 0.2% | 38398.09 ± 1.2% | not timed | not timed | 16635047.37 ± 0.5% | | 1.00 | 1.29 | 433.66 |
| imported/rsc/medium-32 | 27 | 771.18 ± 1.8% | not timed | not timed | 631.51 ± 0.3% | 70.04 ± 10.8% | not timed | not timed | 772.68 ± 0.3% | | 1.00 | 1.22 | 11.01 |
| imported/rsc/medium-1k | 27 | 13743.00 ± 0.7% | not timed | not timed | 11161.15 ± 0.3% | 72.41 ± 0.1% | not timed | not timed | 13831.01 ± 0.7% | | 0.99 | 1.23 | 189.81 |
| imported/rsc/medium-32k | 27 | 429406.87 ± 0.5% | not timed | not timed | 343958.92 ± 0.6% | 48.57 ± 0.1% | not timed | not timed | 431631.18 ± 0.7% | | 0.99 | 1.25 | 8841.17 |
| imported/rsc/medium-1mb | 27 | 13654509.28 ± 0.6% | not timed | not timed | 11226023.98 ± 0.2% | 48.59 ± 0.1% | not timed | not timed | 13752207.60 ± 0.5% | | 0.99 | 1.22 | 281028.52 |
| imported/rsc/hard-32 | 58 | 421.50 ± 2.1% | not timed | not timed | 362.98 ± 0.1% | 49.74 ± 7.8% | not timed | not timed | 418.08 ± 0.1% | | 1.01 | 1.16 | 8.47 |
| imported/rsc/hard-1k | 27 | 13424.18 ± 0.4% | not timed | not timed | 11405.27 ± 0.4% | 40.67 ± 0.1% | not timed | not timed | 13322.64 ± 1.0% | | 1.01 | 1.18 | 330.09 |
| imported/rsc/hard-32k | 27 | 418283.34 ± 0.8% | not timed | not timed | 361980.97 ± 0.1% | 29.36 ± 0.2% | not timed | not timed | 415745.34 ± 0.2% | | 1.01 | 1.16 | 14245.72 |
| imported/rsc/hard-1mb | 51 | 8389339.44 ± 0.3% | not timed | not timed | 7222332.09 ± 0.1% | 29.43 ± 0.3% | not timed | not timed | 8325624.42 ± 0.3% | | 1.01 | 1.16 | 285065.30 |
| imported/rsc/reallyhard0-32 | 58 | 267.09 ± 2.2% | not timed | not timed | 223.03 ± 0.2% | 49.49 ± 8.3% | not timed | not timed | 266.93 ± 0.3% | | 1.00 | 1.20 | 5.40 |
| imported/rsc/reallyhard0-1k | 27 | 591.63 ± 0.3% | not timed | not timed | 585.81 ± 0.1% | 40.82 ± 0.4% | not timed | not timed | 590.22 ± 0.1% | | 1.00 | 1.01 | 14.49 |
| imported/rsc/reallyhard0-32k | 27 | 611.52 ± 0.2% | not timed | not timed | 616.45 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 610.69 ± 0.1% | | 1.00 | 0.99 | 20.83 |
| imported/rsc/reallyhard0-1mb | 51 | 592.01 ± 0.5% | not timed | not timed | 618.28 ± 0.1% | 29.42 ± 0.2% | not timed | not timed | 590.63 ± 0.3% | | 1.00 | 0.96 | 20.13 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.72 ± 1.7% | not timed | not timed | 195.52 ± 0.1% | 58.05 ± 15.5% | not timed | not timed | 289.09 ± 1.7% | | 1.00 | 1.48 | 4.97 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6886.29 ± 0.2% | not timed | not timed | 5926.08 ± 0.1% | 34.06 ± 1.2% | not timed | not timed | 6882.09 ± 0.0% | | 1.00 | 1.16 | 202.17 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21511.42 ± 0.1% | not timed | not timed | 19275.07 ± 0.0% | 25.05 ± 0.2% | not timed | not timed | 21517.96 ± 0.1% | | 1.00 | 1.12 | 858.86 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 22114.97 ± 0.5% | not timed | not timed | 20094.97 ± 0.4% | 25.13 ± 0.5% | not timed | not timed | 22071.36 ± 1.0% | | 1.00 | 1.10 | 880.19 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.47 ± 1.9% | not timed | not timed | 212.38 ± 0.2% | 60.02 ± 11.5% | not timed | not timed | 283.14 ± 1.6% | | 1.00 | 1.33 | 4.71 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5904.49 ± 0.0% | not timed | not timed | 6199.86 ± 0.2% | 34.57 ± 0.7% | not timed | not timed | 5898.13 ± 0.1% | | 1.00 | 0.95 | 170.82 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21425.37 ± 0.0% | not timed | not timed | 19168.99 ± 0.1% | 24.64 ± 2.3% | not timed | not timed | 21434.04 ± 0.3% | | 1.00 | 1.12 | 869.40 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21350.53 ± 0.8% | not timed | not timed | 19582.34 ± 0.7% | 25.21 ± 0.1% | not timed | not timed | 21267.84 ± 0.3% | | 1.00 | 1.09 | 846.98 |
| imported/sherlock/name-sherlock | 776 | 19969.48 ± 1.8% | not timed | not timed | 18745.37 ± 0.2% | 10170.83 ± 27.7% | not timed | not timed | 19971.38 ± 2.3% | | 1.00 | 1.07 | 1.96 |
| imported/sherlock/name-holmes | 2766 | 15136.48 ± 1.6% | not timed | not timed | 15674.19 ± 0.3% | 3172.52 ± 13.7% | not timed | not timed | 15345.92 ± 1.9% | | 0.99 | 0.97 | 4.77 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20004.10 ± 2.0% | not timed | not timed | 18767.65 ± 0.4% | 8125.51 ± 25.5% | not timed | not timed | 19991.74 ± 2.4% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15771.17 ± 0.3% | not timed | not timed | 4014.99 ± 0.3% | 31.64 ± 0.2% | not timed | not timed | 15778.37 ± 0.3% | | 1.00 | 3.93 | 498.42 |
| imported/sherlock/name-holmes-casei | 2802 | 9340.64 ± 7.2% | not timed | not timed | 3292.20 ± 0.1% | 38.94 ± 8.0% | not timed | not timed | 9401.42 ± 1.8% | | 0.99 | 2.84 | 239.87 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13174.70 ± 4.8% | not timed | not timed | 3953.19 ± 0.3% | 31.62 ± 0.2% | not timed | not timed | 13160.17 ± 0.7% | | 1.00 | 3.33 | 416.67 |
| imported/sherlock/name-whitespace | 1461 | 15403.30 ± 1.8% | not timed | not timed | 14680.28 ± 0.2% | 6684.83 ± 19.9% | not timed | not timed | 15387.86 ± 1.8% | | 1.00 | 1.05 | 2.30 |
| imported/sherlock/name-alt1 | 1142 | 11636.89 ± 0.6% | not timed | not timed | 16354.52 ± 1.0% | 4124.37 ± 24.3% | not timed | not timed | 11629.97 ± 2.3% | | 1.00 | 0.71 | 2.82 |
| imported/sherlock/name-alt2 | 3542 | 8975.92 ± 0.2% | not timed | not timed | 3835.35 ± 0.1% | 31.19 ± 0.2% | not timed | not timed | 8957.30 ± 0.3% | | 1.00 | 2.34 | 287.74 |
| imported/sherlock/name-alt3 | 4507 | 5572.87 ± 0.3% | not timed | not timed | 3634.48 ± 0.2% | 9.56 ± 4.2% | not timed | not timed | 5571.26 ± 0.5% | | 1.00 | 1.53 | 582.97 |
| imported/sherlock/name-alt3-casei | 4593 | 1527.87 ± 2.2% | not timed | not timed | 285.13 ± 0.2% | 6.44 ± 0.1% | not timed | not timed | 1530.84 ± 0.9% | | 1.00 | 5.36 | 237.27 |
| imported/sherlock/name-alt4 | 3686 | 6399.14 ± 0.4% | not timed | not timed | 3771.77 ± 0.2% | 31.28 ± 0.3% | not timed | not timed | 6402.19 ± 0.3% | | 1.00 | 1.70 | 204.58 |
| imported/sherlock/name-alt4-casei | 4254 | 2807.66 ± 1.9% | not timed | not timed | 2579.08 ± 0.1% | 19.39 ± 0.3% | not timed | not timed | 2810.84 ± 1.1% | | 1.00 | 1.09 | 144.80 |
| imported/sherlock/name-alt5 | 4028 | 6436.18 ± 0.3% | not timed | not timed | 3748.02 ± 0.1% | 21.66 ± 0.1% | not timed | not timed | 6437.90 ± 0.3% | | 1.00 | 1.72 | 297.08 |
| imported/sherlock/name-alt5-casei | 4104 | 3519.27 ± 1.7% | not timed | not timed | 2226.68 ± 0.1% | 14.12 ± 0.2% | not timed | not timed | 3516.91 ± 0.8% | | 1.00 | 1.58 | 249.32 |
| imported/sherlock/no-match-uncommon | 0 | 21991.20 ± 0.4% | not timed | not timed | 19760.28 ± 0.3% | 37479.83 ± 0.4% | not timed | not timed | 21957.92 ± 0.5% | | 1.00 | 1.11 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21649.67 ± 0.3% | not timed | not timed | 19727.95 ± 0.3% | 1279.65 ± 1.2% | not timed | not timed | 21654.82 ± 0.3% | | 1.00 | 1.10 | 16.92 |
| imported/sherlock/no-match-really-common | 0 | 15752.00 ± 3.7% | not timed | not timed | 18924.89 ± 0.4% | 1290.48 ± 1.5% | not timed | not timed | 16059.76 ± 1.2% | | 0.98 | 0.83 | 12.21 |
| imported/sherlock/the-lower | 21654 | 2306.21 ± 1.5% | not timed | not timed | 2319.91 ± 0.2% | 240.78 ± 16.1% | not timed | not timed | 2321.50 ± 6.8% | | 0.99 | 0.99 | 9.58 |
| imported/sherlock/the-upper | 2223 | 12764.44 ± 10.5% | not timed | not timed | 13625.41 ± 0.5% | 2711.71 ± 19.7% | not timed | not timed | 12820.68 ± 1.7% | | 1.00 | 0.94 | 4.71 |
| imported/sherlock/the-casei | 23961 | 2004.76 ± 0.9% | not timed | not timed | 1317.50 ± 0.3% | 34.81 ± 38.4% | not timed | not timed | 2011.20 ± 1.3% | | 1.00 | 1.52 | 57.60 |
| imported/sherlock/everything-greedy | 581881 | 282.91 ± 6.6% | not timed | not timed | 164.89 ± 0.3% | 28.72 ± 22.7% | not timed | not timed | 283.82 ± 8.9% | | 1.00 | 1.72 | 9.85 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.64 ± 0.2% | not timed | not timed | 212.35 ± 0.2% | 33.01 ± 0.3% | not timed | not timed | 462.35 ± 0.2% | | 1.00 | 2.18 | 14.01 |
| imported/sherlock/letters | 447175 | 62.47 ± 0.7% | not timed | not timed | 32.81 ± 0.1% | 5.19 ± 36.4% | not timed | not timed | 62.65 ± 8.3% | | 1.00 | 1.90 | 12.03 |
| imported/sherlock/letters-upper | 14180 | 453.42 ± 1.2% | not timed | not timed | 370.63 ± 0.1% | 29.70 ± 23.3% | not timed | not timed | 452.88 ± 1.7% | | 1.00 | 1.22 | 15.27 |
| imported/sherlock/letters-lower | 432995 | 63.71 ± 0.4% | not timed | not timed | 33.89 ± 0.4% | 5.85 ± 2.8% | not timed | not timed | 63.65 ± 0.4% | | 1.00 | 1.88 | 10.89 |
| imported/sherlock/words | 447639 | 115.35 ± 1.0% | not timed | not timed | 82.27 ± 0.3% | 14.24 ± 4.8% | not timed | not timed | 115.62 ± 0.8% | | 1.00 | 1.40 | 8.10 |
| imported/sherlock/before-holmes | 4073 | 10366.70 ± 0.5% | not timed | not timed | 8256.89 ± 0.2% | 24.13 ± 0.7% | not timed | not timed | 10381.32 ± 0.5% | | 1.00 | 1.26 | 429.70 |
| imported/sherlock/before-after-holmes | 2593 | 9973.81 ± 0.6% | not timed | not timed | 9558.29 ± 0.3% | 23.68 ± 2.0% | not timed | not timed | 9970.05 ± 0.6% | | 1.00 | 1.04 | 421.27 |
| imported/sherlock/holmes-cochar-watson | 150 | 5198.04 ± 0.2% | not timed | not timed | 3430.48 ± 0.2% | 31.06 ± 0.3% | not timed | not timed | 5199.64 ± 0.2% | | 1.00 | 1.52 | 167.37 |
| imported/sherlock/holmes-coword-watson | 14309 | 1191.46 ± 0.2% | not timed | not timed | 1123.29 ± 0.1% | 6.78 ± 0.3% | not timed | not timed | 1192.71 ± 0.4% | | 1.00 | 1.06 | 175.69 |
| imported/sherlock/quotes | 14437 | 1398.97 ± 0.6% | not timed | not timed | 1763.38 ± 0.6% | 35.16 ± 0.2% | not timed | not timed | 1395.47 ± 0.5% | | 1.00 | 0.79 | 39.79 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.93 ± 0.1% | not timed | not timed | 16255.86 ± 0.2% | 36.64 ± 0.2% | not timed | not timed | 610.05 ± 0.2% | | 1.00 | 0.0375 | 16.65 |
| imported/sherlock/word-ending-n | 35297 | 480.02 ± 2.1% | not timed | not timed | 409.03 ± 0.1% | 23.37 ± 19.0% | not timed | not timed | 481.84 ± 0.2% | | 1.00 | 1.17 | 20.54 |
| imported/sherlock/repeated-class-negation | 2130 | 14896.30 ± 1.5% | not timed | not timed | 10948.11 ± 0.8% | 11.58 ± 0.2% | not timed | not timed | 14926.39 ± 1.1% | | 1.00 | 1.36 | 1286.39 |
| imported/sherlock/ing-suffix | 20547 | 565.44 ± 0.6% | not timed | not timed | 516.63 ± 0.1% | 28.92 ± 0.1% | not timed | not timed | 566.90 ± 0.3% | | 1.00 | 1.09 | 19.55 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.54 ± 0.3% | not timed | not timed | 2111.46 ± 0.4% | 20.50 ± 0.2% | not timed | not timed | 607.33 ± 0.4% | | 1.00 | 0.29 | 29.64 |
| opt/accelerate/whole-line | 239963 | 458.15 ± 0.1% | not timed | not timed | 372.99 ± 0.3% | 92.33 ± 13.8% | not timed | not timed | 457.72 ± 0.3% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 426.69 ± 1.3% | not timed | not timed | 399.59 ± 0.1% | 29.48 ± 23.9% | not timed | not timed | 428.82 ± 0.8% | | 1.00 | 1.07 | 14.48 |
| opt/backtrack/words-english | 40536 | 136.54 ± 0.1% | not timed | not timed | 94.76 ± 0.2% | 19.91 ± 6.4% | not timed | not timed | 135.31 ± 8.7% | | 1.01 | 1.44 | 6.86 |
| opt/fixed-length/too-small-ascii | 0 | 309.72 ± 0.2% | not timed | not timed | 699.38 ± 2.6% | 80.08 ± 0.6% | not timed | not timed | 316.05 ± 0.3% | | 0.98 | 0.44 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3447.35 ± 0.2% | not timed | not timed | 5767.21 ± 0.1% | 125.16 ± 1.5% | not timed | not timed | 3441.51 ± 0.2% | | 1.00 | 0.60 | 27.54 |
| opt/fixed-length/go33484-1 | 0 | 662732.84 ± 0.2% | not timed | not timed | 1112521.39 ± 0.5% | 61459.85 ± 0.3% | not timed | not timed | 661259.29 ± 0.2% | | 1.00 | 0.60 | 10.78 |
| opt/fixed-length/go33484-2 | 0 | 663831.26 ± 0.2% | not timed | not timed | 1109430.23 ± 0.3% | 32324.17 ± 1.1% | not timed | not timed | 660701.82 ± 0.1% | | 1.00 | 0.60 | 20.54 |
| opt/fixed-length/go33484-3 | 0 | 2417.89 ± 2.1% | not timed | not timed | 110860.36 ± 0.3% | 768.85 ± 0.1% | not timed | not timed | 2493.87 ± 3.3% | | 0.97 | 0.0218 | 3.14 |
| opt/literal-alt/one-pattern | 1 | 545.95 ± 2.7% | not timed | not timed | 544.07 ± 0.2% | 0.40 ± 0.3% | not timed | not timed | 548.16 ± 1.3% | | 1.00 | 1.00 | 1365.91 |
| opt/onepass/fn-predicate | 916 | 367.03 ± 0.7% | not timed | not timed | 336.99 ± 0.1% | 200.65 ± 15.6% | not timed | not timed | 367.32 ± 0.7% | | 1.00 | 1.09 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 176.60 ± 11.6% | not timed | not timed | 199.75 ± 0.2% | 83.03 ± 14.2% | not timed | not timed | 176.70 ± 1.4% | | 1.00 | 0.88 | 2.13 |
| opt/prefilter/literal-english | 1 | 20007.99 ± 0.2% | not timed | not timed | 19285.34 ± 0.7% | 17297.84 ± 0.5% | not timed | not timed | 19987.20 ± 0.1% | | 1.00 | 1.04 | 1.16 |
| opt/prefilter/literal-casei-english | 1 | 14379.60 ± 0.8% | not timed | not timed | 4316.96 ± 0.3% | 32.71 ± 0.3% | not timed | not timed | 14372.85 ± 0.4% | | 1.00 | 3.33 | 439.60 |
| opt/prefilter/literal-russian | 1 | 21328.38 ± 0.7% | not timed | not timed | 19862.06 ± 0.9% | 3325.80 ± 0.3% | not timed | not timed | 21372.23 ± 0.2% | | 1.00 | 1.07 | 6.41 |
| opt/prefilter/literal-casei-russian | 1 | 8539.78 ± 0.6% | not timed | not timed | 3894.85 ± 0.2% | 31.65 ± 0.4% | not timed | not timed | 8547.24 ± 0.4% | | 1.00 | 2.19 | 269.82 |
| opt/prefilter/rust-functions | 948 | 6823.04 ± 1.8% | not timed | not timed | 8911.47 ± 0.6% | 1869.60 ± 20.0% | not timed | not timed | 6831.18 ± 0.5% | | 1.00 | 0.77 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29982685.61 ± 0.7% | not timed | not timed | 20855151.31 ± 0.2% | 50.37 ± 0.2% | not timed | not timed | 29981622.58 ± 0.4% | | 1.00 | 1.44 | 595246.97 |
| opt/reverse-inner/holmes | 2593 | 9984.83 ± 0.4% | not timed | not timed | 9566.02 ± 0.4% | 24.19 ± 0.3% | not timed | not timed | 9961.34 ± 0.5% | | 1.00 | 1.04 | 412.71 |
| opt/reverse-inner/email | 47 | 36287.37 ± 2.0% | not timed | not timed | 44880.91 ± 0.6% | 32.44 ± 0.4% | not timed | not timed | 36773.52 ± 2.6% | | 0.99 | 0.81 | 1118.61 |
| opt/reverse-inner/factored-prefix | 3542 | 600.65 ± 0.2% | not timed | not timed | 597.48 ± 0.2% | 12.51 ± 0.9% | not timed | not timed | 600.52 ± 0.1% | | 1.00 | 1.01 | 48.00 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5555.14 ± 0.1% | not timed | not timed | 615.97 ± 0.5% | 75.07 ± 0.1% | not timed | not timed | 5533.58 ± 0.0% | | 1.00 | 9.02 | 74.00 |
| opt/reverse-inner/no-quadratic-forward | 0 | 691.01 ± 4.3% | not timed | not timed | 286.87 ± 0.8% | 24.82 ± 0.1% | not timed | not timed | 689.50 ± 0.4% | | 1.00 | 2.41 | 27.84 |
| opt/reverse-suffix/holmes | 4073 | 10372.06 ± 0.4% | not timed | not timed | 8509.76 ± 0.4% | 23.67 ± 0.5% | not timed | not timed | 10391.11 ± 0.4% | | 1.00 | 1.22 | 438.22 |
| opt/reverse-suffix/no-quadratic | 0 | 5533.87 ± 0.1% | not timed | not timed | 612.19 ± 0.6% | 75.06 ± 0.1% | not timed | not timed | 5563.82 ± 0.1% | | 0.99 | 9.04 | 73.73 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.97 ± 2.7% | not timed | not timed | 131.88 ± 0.1% | 13.36 ± 14.7% | not timed | not timed | 121.44 ± 2.2% | | 1.00 | 0.92 | 9.13 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 113.34 ± 2.8% | not timed | not timed | 131.14 ± 0.1% | 13.16 ± 18.7% | not timed | not timed | 121.56 ± 0.6% | | 0.93 | 0.86 | 8.61 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.27 ± 0.3% | not timed | not timed | 0.55 ± 0.4% | 113.81 ± 0.3% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.50 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 318.00 ± 0.2% | not timed | not timed | 287.99 ± 0.8% | 103.96 ± 8.3% | not timed | not timed | 310.88 ± 3.0% | | 1.02 | 1.10 | 3.06 |
| reported/i13-subset-regex/original-ascii | 4094 | 11187.49 ± 0.8% | not timed | not timed | 4549.98 ± 0.7% | 11.31 ± 0.1% | not timed | not timed | 11258.22 ± 0.9% | | 0.99 | 2.46 | 989.11 |
| reported/i13-subset-regex/original-unicode | 4094 | 11050.94 ± 1.5% | not timed | not timed | 251.13 ± 3.5% | 11.50 ± 0.2% | not timed | not timed | 11164.17 ± 1.0% | | 0.99 | 44.00 | 960.85 |
| reported/i13-subset-regex/big-ascii | 1955 | 10664.94 ± 1.1% | not timed | not timed | 68.07 ± 3.7% | 9.85 ± 0.2% | not timed | not timed | 10719.09 ± 1.0% | | 0.99 | 156.69 | 1082.54 |
| reported/i13-subset-regex/big-unicode | 1955 | 10615.14 ± 1.4% | not timed | not timed | 12.23 ± 54.9% | 9.87 ± 0.1% | not timed | not timed | 10747.68 ± 1.0% | | 0.99 | 867.90 | 1075.42 |
| reported/i13-subset-regex/huge-ascii | 55 | 10117.05 ± 1.0% | not timed | not timed | 11.05 ± 0.1% | 8.75 ± 0.1% | not timed | not timed | 10109.25 ± 3.2% | | 1.00 | 915.75 | 1156.39 |
| reported/i13-subset-regex/huge-unicode | 55 | 9906.61 ± 3.5% | not timed | not timed | 10.95 ± 0.4% | 8.75 ± 0.3% | not timed | not timed | 9830.45 ± 3.9% | | 1.01 | 905.09 | 1131.64 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.55 ± 0.0% | not timed | not timed | 11.04 ± 0.1% | 8.78 ± 0.3% | not timed | not timed | 3.55 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 11.01 ± 0.4% | 8.77 ± 1.1% | not timed | not timed | 5.02 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 485.75 ± 0.3% | not timed | not timed | 104.29 ± 0.1% | 6.64 ± 0.5% | not timed | not timed | 487.11 ± 0.1% | | 1.00 | 4.66 | 73.15 |
| reported/i787-keywords/opt-ascii | 5674 | 485.84 ± 0.2% | not timed | not timed | 273.04 ± 0.1% | 10.29 ± 0.3% | not timed | not timed | 489.13 ± 0.3% | | 0.99 | 1.78 | 47.22 |
| slow/quadratic-regex-1x | 100 | 7.12 ± 0.4% | not timed | not timed | 4.97 ± 0.3% | 0.05 ± 0.2% | not timed | not timed | 7.15 ± 0.2% | | 1.00 | 1.43 | 144.84 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.2% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.4% | not timed | not timed | 3.44 ± 0.2% | | 1.00 | 1.24 | 268.15 |
| slow/quadratic-haystack-1x | 100 | 21.31 ± 6.9% | not timed | not timed | 10.00 ± 0.3% | 1.01 ± 14.0% | not timed | not timed | 21.36 ± 1.6% | | 1.00 | 2.13 | 21.01 |
| slow/quadratic-haystack-2x | 200 | 17.72 ± 1.2% | not timed | not timed | 5.54 ± 0.1% | 0.55 ± 1.2% | not timed | not timed | 17.74 ± 12.4% | | 1.00 | 3.20 | 32.46 |
| unicode/codepoints/any-one | 1112064 | 291.32 ± 0.5% | not timed | not timed | 176.13 ± 0.1% | 18.48 ± 5.1% | not timed | not timed | 289.95 ± 0.2% | | 1.00 | 1.65 | 15.76 |
| unicode/codepoints/any-all | 4382592 | 270.24 ± 2.2% | not timed | not timed | 247.17 ± 0.5% | 117.49 ± 0.1% | not timed | not timed | 270.53 ± 1.6% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.72 ± 1.2% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.59 ± 0.1% | not timed | not timed | 616.34 ± 0.2% | 135.23 ± 0.4% | not timed | not timed | 602.26 ± 0.4% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 32.01 ± 0.5% | not timed | not timed | 38.99 ± 0.1% | 3.94 ± 1.5% | not timed | not timed | 32.01 ± 0.3% | | 1.00 | 0.82 | 8.12 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.2% | not timed | not timed | 3.82 ± 0.2% | 2.35 ± 0.5% | not timed | not timed | 1.44 ± 0.2% | | 1.01 | 0.38 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.1% | not timed | not timed | 3.07 ± 0.9% | 6.31 ± 9.3% | not timed | not timed | 1.29 ± 0.2% | | 1.00 | 0.42 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 127.38 ± 2.3% | not timed | not timed | 82.86 ± 0.1% | 11.01 ± 18.2% | not timed | not timed | 128.24 ± 0.4% | | 0.99 | 1.54 | 11.57 |
| unicode/word/boundary-long-english | 3466 | 615.34 ± 0.1% | not timed | not timed | 604.39 ± 0.2% | 32.20 ± 0.5% | not timed | not timed | 616.17 ± 0.1% | | 1.00 | 1.02 | 19.11 |
| unicode/word/around-holmes-english | 27 | 19210.32 ± 0.3% | not timed | not timed | 18972.64 ± 0.9% | 22.21 ± 0.6% | not timed | not timed | 19280.32 ± 0.4% | | 1.00 | 1.01 | 864.98 |
| wild/bibleref/long | 874 | 562.37 ± 0.2% | not timed | not timed | 581.96 ± 0.7% | 6.82 ± 0.1% | not timed | not timed | 561.94 ± 0.3% | | 1.00 | 0.97 | 82.46 |
| wild/bibleref/short | 30 | 24.50 ± 5.7% | not timed | not timed | 31.09 ± 0.7% | 14.17 ± 11.4% | not timed | not timed | 24.63 ± 2.3% | | 0.99 | 0.79 | 1.73 |
| wild/bibleref/line | 874 | 396.74 ± 0.2% | not timed | not timed | 210.97 ± 0.2% | 9.13 ± 0.1% | not timed | not timed | 396.03 ± 0.2% | | 1.00 | 1.88 | 43.46 |
| wild/caddy/caddy | 6 | 417.12 ± 10.7% | not timed | not timed | 243.52 ± 0.0% | 68.30 ± 13.4% | not timed | not timed | 416.78 ± 0.3% | | 1.00 | 1.71 | 6.11 |
| wild/dot-star-capture/rust-src-tools | 6 | 1069.81 ± 0.4% | not timed | not timed | 343.67 ± 0.4% | 13.52 ± 0.1% | not timed | not timed | 1072.13 ± 0.6% | | 1.00 | 3.11 | 79.10 |
| wild/ruff/noqa | 84 | 439.33 ± 0.2% | not timed | not timed | 481.07 ± 0.1% | 19.49 ± 2.3% | not timed | not timed | 437.11 ± 0.2% | | 1.01 | 0.91 | 22.54 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.93 ± 0.5% | not timed | not timed | 702.27 ± 0.1% | 136.24 ± 10.9% | not timed | not timed | 941.24 ± 0.3% | | 1.02 | 1.37 | 7.04 |
| wild/ruff/string-quote-prefix | 2972 | 1357.06 ± 0.7% | not timed | not timed | 444.67 ± 0.2% | 315.51 ± 25.5% | not timed | not timed | 1356.26 ± 0.5% | | 1.00 | 3.05 | 4.30 |
| wild/ruff/space-around-operator | 1224378 | 220.80 ± 1.8% | not timed | not timed | 185.28 ± 0.2% | 18.47 ± 1.9% | not timed | not timed | 221.42 ± 1.8% | | 1.00 | 1.19 | 11.95 |
| wild/ruff/shebang | 282 | 984.65 ± 0.5% | not timed | not timed | 330.95 ± 0.1% | 111.18 ± 11.6% | not timed | not timed | 983.67 ± 0.5% | | 1.00 | 2.98 | 8.86 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13780.79 ± 1.0% | not timed | not timed | 13775.09 ± 0.8% | 6943.28 ± 0.6% | not timed | not timed | 13796.81 ± 0.6% | | 1.00 | 1.00 | 1.98 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12804.99 ± 0.6% | not timed | not timed | 13484.59 ± 0.4% | 6407.72 ± 0.1% | not timed | not timed | 12834.19 ± 0.1% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13162.75 ± 0.3% | not timed | not timed | 13671.53 ± 0.3% | 6627.40 ± 1.1% | not timed | not timed | 13167.12 ± 0.5% | | 1.00 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9546.30 ± 0.1% | not timed | not timed | 13596.53 ± 0.5% | 6710.27 ± 0.5% | not timed | not timed | 9553.05 ± 0.3% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 122.41 ± 14.2% | not timed | not timed | 65.75 ± 0.7% | 2.20 ± 0.7% | not timed | not timed | 122.61 ± 14.0% | | 1.00 | 1.86 | 55.52 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 3.3% | not timed | not timed | 0.01 ± 1.7% | 0.01 ± 20.3% | not timed | not timed | 0.03 ± 69.3% | | 0.99 | 3.12 | 3.94 |
| dictionary/compile/english-15 | 1 | 0.35 ± 29.5% | not timed | not timed | 0.07 ± 0.7% | 0.10 ± 30.0% | not timed | not timed | 0.35 ± 0.9% | | 0.99 | 5.01 | 3.32 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 2.4% | not timed | not timed | 0.02 ± 1.0% | 36.00 ± 6.0% | not timed | not timed | 0.24 ± 1.6% | | 1.00 | 12.51 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.64 ± 2.1% | not timed | not timed | 11.50 ± 0.3% | 53.62 ± 19.2% | not timed | not timed | 46.17 ± 2.6% | | 0.99 | 3.97 | 0.85 |
| reported/i787-keywords/compile | 1 | 35.22 ± 4.6% | not timed | not timed | 2.14 ± 0.6% | 17.47 ± 41.3% | not timed | not timed | 35.23 ± 3.7% | | 1.00 | 16.46 | 2.02 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 348.08 ± 8.8% | not timed | not timed | 120.30 ± 0.2% | 568.29 ± 25.3% | not timed | not timed | 346.88 ± 6.4% | | 1.00 | 2.89 | 0.61 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.95 ± 1.6% | not timed | not timed | 4.13 ± 0.5% | 44.05 ± 6.5% | not timed | not timed | 48.35 ± 2.2% | | 0.99 | 11.60 | 1.09 |
| unicode/compile/one-letter | 53 | 6.70 ± 3.2% | not timed | not timed | 4.58 ± 0.6% | 66.31 ± 5.8% | not timed | not timed | 6.78 ± 14.6% | | 0.99 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.00 ± 13.9% | not timed | not timed | 0.10 ± 0.2% | 65.68 ± 1.4% | not timed | not timed | 1.05 ± 14.7% | | 0.96 | 10.01 | 0.0152 |
| unicode/compile/fifty-letters-ascii | 1 | 213.71 ± 3.6% | not timed | not timed | 52.66 ± 0.1% | 194.11 ± 9.5% | not timed | not timed | 212.16 ± 1.8% | | 1.01 | 4.06 | 1.10 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 388.07 ± 1.9% | not timed | not timed | 47.22 ± 0.6% | 672.10 ± 31.0% | not timed | not timed | 380.14 ± 18.6% | | 1.02 | 8.22 | 0.58 |
| unicode/compile/match-every-line-ascii | 4 | 598.35 ± 13.6% | not timed | not timed | 145.72 ± 0.3% | 668.91 ± 23.3% | not timed | not timed | 601.63 ± 1.5% | | 0.99 | 4.11 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 317.44 ± 2.2% | not timed | not timed | 50.84 ± 0.2% | 1268.35 ± 15.9% | not timed | not timed | 313.24 ± 14.7% | | 1.01 | 6.24 | 0.25 |
| wild/bibleref/compile | 3 | 5.95 ± 1.9% | not timed | not timed | 1.92 ± 0.6% | 30.99 ± 6.8% | not timed | not timed | 5.95 ± 2.3% | | 1.00 | 3.10 | 0.19 |
| wild/url/compile | 1 | 0.65 ± 19.2% | not timed | not timed | 0.14 ± 0.6% | 0.44 ± 32.7% | not timed | not timed | 0.65 ± 16.2% | | 1.00 | 4.48 | 1.46 |

