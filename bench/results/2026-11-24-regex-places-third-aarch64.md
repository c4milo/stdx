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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506979120 |
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
| literal: a word | 217 | 18787.59 ± 3.3% | 5071.59 ± 0.3% | 28.28 ± 0.3% | 17636.46 ± 2.7% | 9113.44 ± 7.8% | 17.59 ± 0.2% | 86.16 ± 0.2% | 18736.51 ± 0.9% | 3.70 | 1.00 | 1.07 | 2.06 |
| literal: a word that is not there | 0 | 20999.23 ± 6.4% | 4934.08 ± 0.3% | 28.22 ± 0.7% | 19215.44 ± 2.4% | 27303.44 ± 5.6% | 17.41 ± 0.2% | 81.74 ± 0.8% | 21064.67 ± 3.5% | 4.26 | 1.00 | 1.09 | 0.77 |
| literal: one of four words | 661 | 6410.85 ± 0.5% | 1975.24 ± 0.3% | 14.40 ± 0.3% | 3940.42 ± 0.4% | 21.86 ± 0.2% | 5.30 ± 0.1% | 6.74 ± 0.3% | 6430.05 ± 0.3% | 3.25 | 1.00 | 1.63 | 293.30 |
| literal: a word in any case | 217 | 15056.28 ± 1.9% | 2100.01 ± 0.3% | 21.54 ± 0.1% | 3962.01 ± 0.2% | 37.98 ± 0.4% | refused | differs | 15039.78 ± 1.3% | 7.17 | 1.00 | 3.80 | 396.42 |
| literal: an href attribute | 33 | 16863.23 ± 1.3% | 617.76 ± 0.0% | 27.27 ± 0.4% | 17227.20 ± 1.8% | 2264.01 ± 0.2% | 13.42 ± 0.2% | 75.22 ± 1.0% | 16972.60 ± 1.6% | 27.30 | 0.99 | 0.98 | 7.45 |
| literal: a word, second text | 123 | 19560.24 ± 2.5% | 3419.32 ± 0.7% | 27.94 ± 0.4% | 18249.30 ± 1.9% | 7642.82 ± 5.9% | 19.59 ± 0.3% | 68.98 ± 0.2% | 19514.37 ± 1.9% | 5.72 | 1.00 | 1.07 | 2.56 |
| class: two capitalized words | 1331 | 1066.03 ± 0.5% | 609.09 ± 0.2% | 26.01 ± 0.2% | 584.95 ± 0.1% | 40.56 ± 2.3% | 14.99 ± 0.4% | 68.13 ± 0.8% | 1062.62 ± 0.3% | 1.75 | 1.00 | 1.82 | 26.28 |
| class: a word that ends in ing | 3399 | 583.13 ± 0.1% | 583.14 ± 0.3% | 17.99 ± 0.4% | 547.71 ± 0.3% | 29.67 ± 2.9% | 8.23 ± 0.1% | 18.26 ± 0.3% | 583.80 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.65 |
| class: a word in capitals | 2332 | 1393.75 ± 0.5% | 614.48 ± 0.1% | 27.55 ± 0.4% | 572.28 ± 0.2% | 43.56 ± 13.1% | 17.26 ± 0.6% | 83.06 ± 0.4% | 1390.77 ± 0.5% | 2.27 | 1.00 | 2.44 | 32.00 |
| class: a number | 8288 | 2129.94 ± 0.4% | 853.07 ± 0.1% | 27.75 ± 0.4% | 1723.26 ± 0.1% | 42.87 ± 3.2% | 0.57 ± 0.2% | 56.73 ± 0.6% | 2129.70 ± 0.3% | 2.50 | 1.00 | 1.24 | 49.69 |
| class: two capitalized words, second text | 5359 | 523.90 ± 0.4% | 534.19 ± 0.3% | 23.33 ± 0.2% | 483.78 ± 0.0% | 35.37 ± 8.9% | 16.71 ± 0.4% | 63.42 ± 0.2% | 525.16 ± 0.1% | 0.98 | 1.00 | 1.08 | 14.81 |
| other: a word between two words | 6104 | 810.56 ± 0.1% | 608.64 ± 0.1% | 23.55 ± 0.4% | 736.53 ± 0.3% | 111.71 ± 22.9% | 11.37 ± 0.1% | 69.28 ± 0.3% | 808.46 ± 0.2% | 1.33 | 1.00 | 1.10 | 7.26 |
| other: a number before a unit, second text | 1481 | 6209.88 ± 1.3% | 1132.46 ± 0.4% | 25.99 ± 0.3% | 5609.33 ± 0.7% | 40.83 ± 0.2% | 17.82 ± 0.1% | 66.81 ± 0.1% | 6161.38 ± 1.8% | 5.48 | 1.01 | 1.11 | 152.08 |
| other: a heading's start tag | 110 | 14000.18 ± 3.6% | 750.82 ± 0.1% | 27.41 ± 0.3% | 1708.51 ± 0.3% | 1584.65 ± 5.4% | 16.36 ± 0.6% | 88.39 ± 0.3% | 14063.23 ± 2.3% | 18.65 | 1.00 | 8.19 | 8.83 |
| other: a whole word | 217 | 16055.21 ± 0.6% | 606.72 ± 0.6% | 29.38 ± 0.2% | 14381.06 ± 1.2% | 47.98 ± 0.3% | 13.91 ± 0.4% | 55.47 ± 0.3% | 16157.03 ± 1.8% | 26.46 | 0.99 | 1.12 | 334.61 |
| other: a line's first word, second text | 3716 | 2096.83 ± 0.6% | 599.75 ± 0.2% | 31.05 ± 0.4% | 1724.61 ± 0.2% | 62.56 ± 6.3% | refused | refused | 2101.79 ± 1.2% | 3.50 | 1.00 | 1.22 | 33.52 |
| other: fourteen octets before an x | 87 | 23046.03 ± 2.9% | 244.78 ± 0.5% | 6.55 ± 0.2% | 3918.79 ± 0.7% | 10.45 ± 1.7% | differs | 17.47 ± 0.1% | 23213.30 ± 8.4% | 94.15 | 0.99 | 5.88 | 2204.99 |
| other: a Greek word | 21815 | 520.37 ± 0.6% | 424.91 ± 0.4% | 30.79 ± 0.2% | 289.61 ± 0.4% | 48.69 ± 11.1% | differs | refused | 521.86 ± 0.3% | 1.22 | 1.00 | 1.80 | 10.69 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.17 ± 0.2% | 29.30 ± 0.1% | 0.86 ± 0.4% | 19.69 ± 0.1% | 2.76 ± 0.6% | differs | 4.01 ± 0.3% | 29.26 ± 0.3% | 1.00 | 1.00 | 1.48 | 10.58 |
| a UUID | 32895 | 24.69 ± 0.1% | 24.64 ± 0.1% | 0.64 ± 0.2% | 15.11 ± 0.5% | 3.11 ± 0.1% | 0.72 ± 0.4% | 3.59 ± 0.5% | 24.73 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.94 |
| an IPv4 address | 33176 | 38.47 ± 0.3% | 38.43 ± 0.2% | 2.07 ± 0.2% | 28.98 ± 0.4% | 6.63 ± 0.2% | differs | 4.15 ± 0.2% | 38.42 ± 0.3% | 1.00 | 1.00 | 1.33 | 5.80 |
| a date and time | 32954 | 34.36 ± 0.2% | 34.10 ± 0.3% | 1.45 ± 0.3% | 21.06 ± 0.7% | 7.05 ± 0.2% | 1.19 ± 0.5% | 7.04 ± 0.4% | 34.33 ± 0.1% | 1.01 | 1.00 | 1.63 | 4.87 |
| a field path | 32606 | 32.49 ± 0.3% | 32.45 ± 0.1% | 1.01 ± 0.4% | 22.94 ± 0.5% | 3.49 ± 0.7% | differs | 2.92 ± 0.3% | 32.45 ± 0.2% | 1.00 | 1.00 | 1.42 | 9.31 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.2% | 11.04 ± 0.1% | 11.12 ± 0.5% | 11.46 ± 0.1% | 4.96 ± 1.4% | 0.91 ± 0.2% | none | 11.08 ± 0.2% | 1.01 | 1.00 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.63 ± 0.4% | 222.79 ± 0.3% | 260.66 ± 0.2% | 86.19 ± 0.5% | 221.53 ± 1.0% | 475.62 ± 1.0% | 3724.75 ± 0.6% | 222.78 ± 0.3% | 1.00 | 1.00 | 2.58 | 1.01 |
| a UUID | 62 | 144.15 ± 0.2% | 144.25 ± 0.1% | 159.50 ± 0.2% | 45.94 ± 0.9% | 98.25 ± 0.4% | 187.17 ± 2.6% | 4450.23 ± 0.4% | 143.99 ± 0.2% | 1.00 | 1.00 | 3.14 | 1.47 |
| an IPv4 address | 29 | 420.16 ± 0.5% | 421.24 ± 0.1% | 584.17 ± 0.3% | 77.32 ± 0.9% | 130.45 ± 0.6% | 293.36 ± 0.8% | 7575.26 ± 0.3% | 420.42 ± 0.2% | 1.00 | 1.00 | 5.43 | 3.22 |
| a date and time | 56 | 302.00 ± 0.3% | 302.52 ± 0.2% | 376.72 ± 0.2% | 72.25 ± 1.0% | 135.72 ± 1.5% | 321.07 ± 4.0% | 4937.52 ± 0.5% | 302.20 ± 0.1% | 1.00 | 1.00 | 4.18 | 2.23 |
| a field path | 39 | 213.77 ± 0.3% | 213.97 ± 0.3% | 248.25 ± 0.2% | 79.32 ± 1.4% | 205.79 ± 1.2% | 501.79 ± 5.2% | 4818.50 ± 2.2% | 213.76 ± 0.2% | 1.00 | 1.00 | 2.69 | 1.04 |
| literal: a word | 7 | 620.05 ± 0.7% | 670.32 ± 0.5% | 1187.59 ± 0.8% | 506.13 ± 0.2% | 628.88 ± 2.0% | 946.53 ± 0.5% | 29714.65 ± 0.4% | 619.14 ± 0.7% | 0.93 | 1.00 | 1.23 | 0.99 |
| literal: a word that is not there | 8 | 596.00 ± 0.4% | 654.91 ± 0.5% | 1121.39 ± 0.7% | 462.80 ± 0.2% | 598.44 ± 7.5% | 890.52 ± 0.4% | 28556.67 ± 0.1% | 596.77 ± 0.6% | 0.91 | 1.00 | 1.29 | 1.00 |
| literal: one of four words | 26 | 246.41 ± 0.1% | 395.78 ± 0.3% | 532.93 ± 0.2% | 49.69 ± 1.0% | 241.43 ± 1.5% | 366.50 ± 0.7% | 15447.21 ± 0.3% | 246.36 ± 0.2% | 0.62 | 1.00 | 4.96 | 1.02 |
| literal: a word in any case | 11 | 448.01 ± 0.2% | 479.75 ± 0.2% | 702.47 ± 0.2% | 15.88 ± 1.6% | 644.85 ± 1.6% | refused | 23275.78 ± 0.3% | 448.46 ± 0.2% | 0.93 | 1.00 | 28.21 | 0.69 |
| literal: an href attribute | 12 | 336.16 ± 0.5% | 347.03 ± 0.4% | 450.50 ± 0.7% | 44.25 ± 1.1% | 496.61 ± 1.0% | 764.29 ± 0.4% | 21493.04 ± 0.6% | 336.09 ± 0.4% | 0.97 | 1.00 | 7.60 | 0.68 |
| literal: a word, second text | 10 | 553.93 ± 0.6% | 614.89 ± 0.5% | 1007.63 ± 0.7% | 415.85 ± 1.1% | 533.18 ± 1.0% | 788.82 ± 0.4% | 26336.87 ± 0.1% | 554.14 ± 0.5% | 0.90 | 1.00 | 1.33 | 1.04 |
| class: two capitalized words | 23 | 436.37 ± 0.1% | 464.43 ± 0.4% | 663.09 ± 0.4% | 100.22 ± 1.1% | 500.66 ± 1.4% | 741.61 ± 0.4% | 6333.65 ± 0.2% | 435.93 ± 0.2% | 0.94 | 1.00 | 4.35 | 0.87 |
| class: a word that ends in ing | 9 | 549.66 ± 0.2% | 618.58 ± 0.7% | 1060.65 ± 0.4% | 132.04 ± 0.6% | 759.73 ± 1.0% | 1105.61 ± 0.6% | 15688.23 ± 0.1% | 549.46 ± 0.5% | 0.89 | 1.00 | 4.16 | 0.72 |
| class: a word in capitals | 16 | 492.70 ± 0.5% | 529.12 ± 0.2% | 830.76 ± 0.1% | 134.70 ± 1.1% | 747.39 ± 1.5% | 1020.33 ± 0.4% | 8326.95 ± 0.1% | 492.02 ± 0.3% | 0.93 | 1.00 | 3.66 | 0.66 |
| class: a number | 6 | 627.21 ± 0.2% | 688.02 ± 0.2% | 1262.05 ± 0.4% | 41.56 ± 1.2% | 1401.92 ± 1.4% | 1861.30 ± 1.4% | 22427.86 ± 0.3% | 626.41 ± 0.2% | 0.91 | 1.00 | 15.09 | 0.45 |
| class: two capitalized words, second text | 23 | 435.93 ± 0.6% | 463.96 ± 0.5% | 662.97 ± 0.5% | 100.40 ± 0.9% | 500.89 ± 0.9% | 763.23 ± 0.4% | 6331.13 ± 0.2% | 435.40 ± 0.3% | 0.94 | 1.00 | 4.34 | 0.87 |
| other: a word between two words | 13 | 532.94 ± 0.2% | 554.64 ± 0.1% | 870.09 ± 0.4% | 133.32 ± 0.8% | 502.85 ± 1.3% | 808.90 ± 1.0% | 14537.82 ± 0.2% | 532.55 ± 0.3% | 0.96 | 1.00 | 4.00 | 1.06 |
| other: a number before a unit, second text | 15 | 384.76 ± 0.1% | 424.88 ± 0.1% | 587.43 ± 0.2% | 39.37 ± 1.3% | 634.65 ± 0.9% | 882.97 ± 2.7% | 15089.74 ± 0.1% | 384.71 ± 0.2% | 0.91 | 1.00 | 9.77 | 0.61 |
| other: a heading's start tag | 13 | 345.94 ± 0.5% | 353.96 ± 0.2% | 461.03 ± 0.6% | 43.38 ± 0.2% | 632.55 ± 0.4% | 871.56 ± 0.2% | 17843.17 ± 0.1% | 346.66 ± 0.4% | 0.98 | 1.00 | 7.97 | 0.55 |
| other: a whole word | 11 | 572.17 ± 0.2% | 616.26 ± 0.2% | 1012.77 ± 0.1% | 119.26 ± 0.5% | 561.97 ± 1.8% | 827.43 ± 0.5% | 26251.90 ± 0.2% | 572.95 ± 0.2% | 0.93 | 1.00 | 4.80 | 1.02 |
| other: a line's first word, second text | 17 | 517.93 ± 0.8% | 547.95 ± 0.5% | 869.45 ± 0.7% | 128.49 ± 0.2% | 709.14 ± 0.7% | refused | refused | 518.14 ± 0.4% | 0.95 | 1.00 | 4.03 | 0.73 |
| other: fourteen octets before an x | 16 | 107.62 ± 0.4% | 154.29 ± 0.4% | 175.37 ± 0.4% | 14.61 ± 0.3% | 455.28 ± 1.3% | 410.07 ± 0.7% | 12621.30 ± 0.3% | 107.70 ± 0.3% | 0.70 | 1.00 | 7.37 | 0.24 |
| other: a Greek word | 8 | 443.84 ± 0.1% | 578.45 ± 0.1% | 946.41 ± 0.2% | 58.62 ± 2.1% | 1389.56 ± 0.8% | 1813.98 ± 0.3% | refused | 444.05 ± 0.3% | 0.77 | 1.00 | 7.57 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15479.54 ± 0.9% | not timed | not timed | 16017.78 ± 2.1% | 2179.32 ± 20.7% | not timed | not timed | 15431.19 ± 0.8% | | 1.00 | 0.97 | 7.10 |
| 01-literal/sherlock-casei-en | 522 | 10993.62 ± 3.6% | not timed | not timed | 3593.88 ± 0.6% | 32.58 ± 0.2% | not timed | not timed | 11027.06 ± 1.0% | | 1.00 | 3.06 | 337.40 |
| 01-literal/sherlock-ru | 724 | 17213.60 ± 0.6% | not timed | not timed | 17298.60 ± 0.1% | 1506.39 ± 8.8% | not timed | not timed | 17222.87 ± 1.1% | | 1.00 | 1.00 | 11.43 |
| 01-literal/sherlock-casei-ru | 746 | 6160.64 ± 0.4% | not timed | not timed | 3334.30 ± 0.1% | 31.67 ± 0.4% | not timed | not timed | 6143.93 ± 0.1% | | 1.00 | 1.85 | 194.55 |
| 01-literal/sherlock-zh | 30 | 19512.45 ± 1.2% | not timed | not timed | 18444.32 ± 1.8% | 2660.42 ± 10.9% | not timed | not timed | 19452.43 ± 1.0% | | 1.00 | 1.06 | 7.33 |
| 02-literal-alternate/sherlock-en | 714 | 6135.08 ± 0.7% | not timed | not timed | 3936.83 ± 0.2% | 16.59 ± 7.2% | not timed | not timed | 6142.19 ± 0.7% | | 1.00 | 1.56 | 369.80 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1967.53 ± 1.6% | not timed | not timed | 697.91 ± 0.3% | 11.11 ± 0.1% | not timed | not timed | 1975.38 ± 0.8% | | 1.00 | 2.82 | 177.11 |
| 02-literal-alternate/sherlock-ru | 899 | 5540.24 ± 0.2% | not timed | not timed | 3253.02 ± 0.2% | 22.61 ± 0.4% | not timed | not timed | 5529.77 ± 0.1% | | 1.00 | 1.70 | 245.07 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.55 ± 0.6% | not timed | not timed | 1231.79 ± 0.8% | 9.14 ± 0.2% | not timed | not timed | 2054.71 ± 0.5% | | 1.00 | 1.67 | 225.00 |
| 02-literal-alternate/sherlock-zh | 207 | 7337.02 ± 0.2% | not timed | not timed | 4162.62 ± 0.2% | 31.46 ± 0.1% | not timed | not timed | 7343.57 ± 0.3% | | 1.00 | 1.76 | 233.19 |
| 03-date/ascii | 111817 | 133.66 ± 1.1% | not timed | not timed | 95.33 ± 0.2% | 0.20 ± 1.7% | not timed | not timed | 134.52 ± 1.1% | | 0.99 | 1.40 | 658.24 |
| 04-ruff-noqa/real | 84 | 436.13 ± 0.1% | not timed | not timed | 462.90 ± 0.2% | 19.66 ± 1.2% | not timed | not timed | 436.03 ± 0.1% | | 1.00 | 0.94 | 22.19 |
| 04-ruff-noqa/tweaked | 44 | 594.64 ± 0.4% | not timed | not timed | 460.00 ± 0.1% | 368.49 ± 0.2% | not timed | not timed | 595.18 ± 0.2% | | 1.00 | 1.29 | 1.61 |
| 05-lexer-veryl/single | 124800 | 5.36 ± 3.5% | not timed | not timed | 5.01 ± 0.2% | 0.21 ± 3.4% | not timed | not timed | 5.51 ± 0.8% | | 0.97 | 1.07 | 26.00 |
| 06-cloud-flare-redos/original | 107 | 425.94 ± 0.2% | not timed | not timed | 216.79 ± 0.0% | 24.83 ± 0.3% | not timed | not timed | 431.53 ± 0.1% | | 0.99 | 1.96 | 17.15 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.72 ± 0.3% | not timed | not timed | 229.44 ± 0.1% | 26.69 ± 0.1% | not timed | not timed | 430.10 ± 0.1% | | 1.00 | 1.88 | 16.18 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.31 ± 0.2% | not timed | not timed | 256.45 ± 0.4% | 28.77 ± 0.1% | not timed | not timed | 588.47 ± 0.1% | | 1.00 | 2.29 | 20.45 |
| 07-unicode-character-data/parse-line | 558784 | 234.24 ± 2.3% | not timed | not timed | 171.44 ± 0.4% | 43.39 ± 5.3% | not timed | not timed | 233.26 ± 2.2% | | 1.00 | 1.37 | 5.40 |
| 08-words/all-english | 56691 | 127.77 ± 0.7% | not timed | not timed | 82.78 ± 0.1% | 11.98 ± 5.1% | not timed | not timed | 127.98 ± 0.6% | | 1.00 | 1.54 | 10.66 |
| 08-words/long-english | 839 | 623.05 ± 0.2% | not timed | not timed | 594.05 ± 0.2% | 32.32 ± 9.1% | not timed | not timed | 623.77 ± 0.3% | | 1.00 | 1.05 | 19.28 |
| 09-aws-keys/full | 0 | 440.57 ± 0.2% | not timed | not timed | 463.45 ± 0.1% | 64.63 ± 0.1% | not timed | not timed | 439.37 ± 0.1% | | 1.00 | 0.95 | 6.82 |
| 09-aws-keys/quick | 0 | 874.82 ± 0.1% | not timed | not timed | 991.55 ± 0.3% | 424.81 ± 0.7% | not timed | not timed | 874.84 ± 0.2% | | 1.00 | 0.88 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 585.07 ± 3.3% | not timed | not timed | 515.40 ± 0.3% | 19.56 ± 0.4% | not timed | not timed | 579.25 ± 2.4% | | 1.01 | 1.14 | 29.91 |
| 10-bounded-repeat/letters-ru | 3475 | 507.12 ± 1.2% | not timed | not timed | 475.97 ± 0.2% | 21.60 ± 12.7% | not timed | not timed | 506.89 ± 1.4% | | 1.00 | 1.07 | 23.48 |
| 10-bounded-repeat/context | 53 | 84.78 ± 1.8% | not timed | not timed | 65.54 ± 0.4% | 19.82 ± 0.1% | not timed | not timed | 85.23 ± 1.6% | | 0.99 | 1.29 | 4.28 |
| 10-bounded-repeat/capitals | 11 | 633.49 ± 8.0% | not timed | not timed | 616.27 ± 0.1% | 36.52 ± 0.1% | not timed | not timed | 633.15 ± 8.1% | | 1.00 | 1.03 | 17.34 |
| 11-unstructured-to-json/extract | 600 | 57.24 ± 0.3% | not timed | not timed | 77.21 ± 0.2% | 49.04 ± 0.4% | not timed | not timed | 57.37 ± 0.5% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 561.81 ± 0.9% | not timed | not timed | 560.77 ± 0.3% | 0.40 ± 0.2% | not timed | not timed | 562.12 ± 1.3% | | 1.00 | 1.00 | 1387.45 |
| 14-quadratic/1x | 100 | 21.31 ± 1.5% | not timed | not timed | 10.03 ± 0.1% | 0.96 ± 3.5% | not timed | not timed | 21.44 ± 0.6% | | 0.99 | 2.12 | 22.24 |
| 14-quadratic/2x | 200 | 17.71 ± 1.5% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 0.9% | not timed | not timed | 17.84 ± 0.8% | | 0.99 | 3.19 | 33.18 |
| 14-quadratic/10x | 1000 | 7.76 ± 0.5% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.9% | not timed | not timed | 7.78 ± 0.2% | | 1.00 | 6.44 | 67.08 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 0.7% | not timed | not timed | 0.34 ± 1.0% | 0.54 ± 4.0% | not timed | not timed | 1.22 ± 2.4% | | 1.00 | 3.57 | 2.25 |
| 04-ruff-noqa/compile-real | 1 | 106.18 ± 1.2% | not timed | not timed | 13.93 ± 0.2% | 139.04 ± 2.4% | not timed | not timed | 106.48 ± 0.5% | | 1.00 | 7.62 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 14.02 ± 2.6% | not timed | not timed | 2.52 ± 0.6% | 6.44 ± 2.5% | not timed | not timed | 14.03 ± 1.3% | | 1.00 | 5.56 | 2.18 |
| 07-unicode-character-data/compile | 1 | 107.91 ± 1.3% | not timed | not timed | 26.14 ± 0.4% | 36.03 ± 2.0% | not timed | not timed | 108.02 ± 0.5% | | 1.00 | 4.13 | 2.99 |
| 09-aws-keys/compile-full | 1 | 52.95 ± 0.9% | not timed | not timed | 8.28 ± 0.3% | 23.30 ± 2.2% | not timed | not timed | 53.16 ± 1.4% | | 1.00 | 6.39 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 186.95 ± 1.2% | not timed | not timed | 47.59 ± 0.1% | 133.26 ± 1.9% | not timed | not timed | 187.46 ± 1.6% | | 1.00 | 3.93 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 70.93 ± 1.9% | not timed | not timed | 11.25 ± 0.5% | 15.66 ± 3.3% | not timed | not timed | 71.84 ± 1.7% | | 0.99 | 6.31 | 4.53 |
| 10-bounded-repeat/compile-capitals | 1 | 85.03 ± 0.7% | not timed | not timed | 8.15 ± 0.3% | 23.58 ± 2.9% | not timed | not timed | 84.78 ± 1.0% | | 1.00 | 10.43 | 3.61 |
| 11-unstructured-to-json/compile | 1 | 169.72 ± 1.0% | not timed | not timed | 40.83 ± 0.4% | 68.13 ± 1.0% | not timed | not timed | 170.85 ± 1.1% | | 0.99 | 4.16 | 2.49 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.7% | not timed | not timed | 0.07 ± 2.9% | 0.10 ± 18.9% | not timed | not timed | 0.35 ± 0.5% | | 1.00 | 5.11 | 3.62 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.34 ± 5.4% | not timed | not timed | 6.47 ± 0.1% | 0.52 ± 7.0% | not timed | not timed | 7.37 ± 0.8% | | 1.00 | 1.13 | 14.16 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.2% | not timed | not timed | 164.64 ± 0.5% | 0.00 ± 0.4% | not timed | not timed | 1.16 ± 0.4% | | 1.00 | 0.0071 | 448.39 |
| dictionary/search/english-15 | 15 | 566.44 ± 0.9% | not timed | not timed | 559.96 ± 0.2% | 0.37 ± 0.1% | not timed | not timed | 567.18 ± 1.0% | | 1.00 | 1.01 | 1540.60 |
| folly/awyer-inn-busted | 1 | 5590.39 ± 0.1% | not timed | not timed | 142.03 ± 0.0% | 43.77 ± 0.3% | not timed | not timed | 5612.25 ± 0.1% | | 1.00 | 39.36 | 127.73 |
| folly/literal-never-match-rare | 0 | 21107.87 ± 1.0% | not timed | not timed | 19915.38 ± 0.3% | 40897.15 ± 0.3% | not timed | not timed | 21116.96 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12495.54 ± 1.7% | not timed | not timed | 19883.75 ± 0.2% | 2189.41 ± 1.0% | not timed | not timed | 12548.28 ± 1.5% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3244.21 ± 0.2% | not timed | not timed | 4408.87 ± 0.2% | 3054.15 ± 0.7% | not timed | not timed | 3239.09 ± 0.3% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1318.53 ± 0.6% | not timed | not timed | 949.11 ± 0.4% | 386.68 ± 19.8% | not timed | not timed | 1324.95 ± 0.6% | | 1.00 | 1.39 | 3.41 |
| grep/long-words-ascii | 5073 | 459.34 ± 0.2% | not timed | not timed | 468.31 ± 0.2% | 45.64 ± 6.0% | not timed | not timed | 457.67 ± 0.3% | | 1.00 | 0.98 | 10.06 |
| imported/leipzig/twain | 811 | 20765.83 ± 1.4% | not timed | not timed | 19641.88 ± 0.3% | 11995.60 ± 11.3% | not timed | not timed | 20811.16 ± 0.9% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9050.44 ± 0.8% | not timed | not timed | 4251.19 ± 0.1% | 37.73 ± 0.0% | not timed | not timed | 9080.71 ± 1.1% | | 1.00 | 2.13 | 239.84 |
| imported/leipzig/shing | 1540 | 15218.64 ± 2.3% | not timed | not timed | 13568.63 ± 0.2% | 34.02 ± 0.1% | not timed | not timed | 15503.37 ± 2.6% | | 0.98 | 1.12 | 447.36 |
| imported/leipzig/huck-saw | 262 | 8285.75 ± 2.6% | not timed | not timed | 5603.36 ± 0.1% | 31.86 ± 0.2% | not timed | not timed | 8471.15 ± 2.9% | | 0.98 | 1.48 | 260.04 |
| imported/leipzig/word-ending-nn | 262 | 604.68 ± 0.4% | not timed | not timed | 615.71 ± 0.3% | 24.64 ± 0.5% | not timed | not timed | 604.44 ± 0.5% | | 1.00 | 0.98 | 24.55 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10951.49 ± 0.9% | not timed | not timed | 4489.81 ± 1.0% | 11.49 ± 0.1% | not timed | not timed | 11206.65 ± 1.0% | | 0.98 | 2.44 | 953.35 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7821.03 ± 1.9% | not timed | not timed | 5489.26 ± 0.1% | 16.71 ± 0.1% | not timed | not timed | 7955.37 ± 1.9% | | 0.98 | 1.42 | 468.07 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4183.59 ± 1.3% | not timed | not timed | 415.37 ± 1.3% | 11.12 ± 0.2% | not timed | not timed | 4207.15 ± 1.5% | | 0.99 | 10.07 | 376.18 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 601.46 ± 0.7% | not timed | not timed | 615.06 ± 0.1% | 11.12 ± 0.0% | not timed | not timed | 603.38 ± 0.6% | | 1.00 | 0.98 | 54.10 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 601.76 ± 0.8% | not timed | not timed | 615.45 ± 0.0% | 9.73 ± 0.1% | not timed | not timed | 601.17 ± 0.3% | | 1.00 | 0.98 | 61.86 |
| imported/leipzig/tom-river | 2 | 6519.81 ± 1.4% | not timed | not timed | 5148.76 ± 0.2% | 30.90 ± 0.2% | not timed | not timed | 6608.92 ± 1.8% | | 0.99 | 1.27 | 211.02 |
| imported/leipzig/ing | 78424 | 600.26 ± 0.5% | not timed | not timed | 570.11 ± 0.2% | 28.26 ± 3.3% | not timed | not timed | 600.31 ± 0.5% | | 1.00 | 1.05 | 21.24 |
| imported/leipzig/ing-whitespace | 55248 | 751.24 ± 1.1% | not timed | not timed | 2076.40 ± 0.9% | 20.58 ± 2.9% | not timed | not timed | 754.85 ± 0.6% | | 1.00 | 0.36 | 36.50 |
| imported/leipzig/awyer-inn | 209 | 768.86 ± 1.7% | not timed | not timed | 4275.36 ± 0.5% | 22.62 ± 0.1% | not timed | not timed | 768.05 ± 1.5% | | 1.00 | 0.18 | 33.99 |
| imported/leipzig/quotes-bounded | 8886 | 2118.07 ± 0.7% | not timed | not timed | 3013.81 ± 0.2% | 38.20 ± 0.2% | not timed | not timed | 2131.66 ± 0.5% | | 0.99 | 0.70 | 55.44 |
| imported/leipzig/non-ascii-alternate | 2 | 12905.53 ± 3.1% | not timed | not timed | 5669.86 ± 0.1% | 50.69 ± 0.0% | not timed | not timed | 13099.66 ± 2.1% | | 0.99 | 2.28 | 254.57 |
| imported/leipzig/math-symbols | 69 | 1975.46 ± 1.5% | not timed | not timed | 618.44 ± 0.1% | 36.47 ± 0.4% | not timed | not timed | 1972.75 ± 0.6% | | 1.00 | 3.19 | 54.17 |
| imported/leipzig/bounded-strings-ending-z | 0 | 587.33 ± 1.2% | not timed | not timed | 615.21 ± 0.0% | 22.42 ± 0.1% | not timed | not timed | 585.91 ± 0.7% | | 1.00 | 0.95 | 26.20 |
| imported/lh3lh3-reb/uri | 17549 | 679.59 ± 0.2% | not timed | not timed | 1060.78 ± 0.1% | 28.44 ± 2.1% | not timed | not timed | 679.66 ± 0.2% | | 1.00 | 0.64 | 23.90 |
| imported/lh3lh3-reb/email | 15057 | 673.86 ± 0.1% | not timed | not timed | 1156.81 ± 0.2% | 31.01 ± 2.4% | not timed | not timed | 673.74 ± 0.2% | | 1.00 | 0.58 | 21.73 |
| imported/lh3lh3-reb/date | 668 | 860.66 ± 0.2% | not timed | not timed | 1029.67 ± 0.2% | 50.23 ± 3.8% | not timed | not timed | 860.09 ± 0.2% | | 1.00 | 0.84 | 17.14 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.81 ± 0.1% | not timed | not timed | 423.92 ± 0.1% | 15.83 ± 1.3% | not timed | not timed | 645.23 ± 0.1% | | 1.00 | 1.52 | 40.80 |
| imported/mariomka/email | 92 | 24373.86 ± 1.0% | not timed | not timed | 29267.94 ± 1.8% | 32.80 ± 0.8% | not timed | not timed | 24325.56 ± 1.3% | | 1.00 | 0.83 | 743.11 |
| imported/mariomka/uri | 5301 | 5341.40 ± 0.8% | not timed | not timed | 6122.31 ± 0.2% | 32.74 ± 0.4% | not timed | not timed | 5384.30 ± 0.8% | | 0.99 | 0.87 | 163.16 |
| imported/mariomka/ip | 5 | 2157.83 ± 2.1% | not timed | not timed | 2968.51 ± 0.1% | 21.11 ± 0.4% | not timed | not timed | 2152.14 ± 2.3% | | 1.00 | 0.73 | 102.20 |
| imported/rsc/no-exponential | 0 | 606.14 ± 0.1% | not timed | not timed | 317.17 ± 0.0% | 23.92 ± 0.5% | not timed | not timed | 602.45 ± 0.1% | | 1.01 | 1.91 | 25.34 |
| imported/rsc/literal | 1 | 759.06 ± 1.7% | not timed | not timed | 1571.73 ± 6.4% | 189.98 ± 17.4% | not timed | not timed | 757.90 ± 5.6% | | 1.00 | 0.48 | 4.00 |
| imported/rsc/not-literal | 2 | 781.67 ± 0.4% | not timed | not timed | 728.52 ± 0.3% | 46.47 ± 9.6% | not timed | not timed | 783.02 ± 2.2% | | 1.00 | 1.07 | 16.82 |
| imported/rsc/match-class | 1 | 1437.87 ± 9.4% | not timed | not timed | 1581.99 ± 0.2% | 58.12 ± 0.8% | not timed | not timed | 1440.29 ± 0.3% | | 1.00 | 0.91 | 24.74 |
| imported/rsc/match-class-in-range | 1 | 1443.66 ± 2.5% | not timed | not timed | 2257.06 ± 5.8% | 60.24 ± 6.2% | not timed | not timed | 1439.35 ± 0.2% | | 1.00 | 0.64 | 23.96 |
| imported/rsc/match-class-unicode | 1 | 547.61 ± 1.8% | not timed | not timed | 513.11 ± 0.1% | 72.82 ± 7.2% | not timed | not timed | 548.81 ± 0.2% | | 1.00 | 1.07 | 7.52 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1440.11 ± 0.1% | not timed | not timed | 934.71 ± 0.1% | 228.82 ± 0.8% | not timed | not timed | 1438.82 ± 0.3% | | 1.00 | 1.54 | 6.29 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21589.86 ± 0.2% | not timed | not timed | 14215.91 ± 0.1% | 3424.60 ± 0.4% | not timed | not timed | 21539.74 ± 0.1% | | 1.00 | 1.52 | 6.30 |
| imported/rsc/anchored-literal-short-match | 4 | 711.35 ± 1.7% | not timed | not timed | 485.31 ± 0.1% | 86.26 ± 11.6% | not timed | not timed | 707.54 ± 1.9% | | 1.01 | 1.47 | 8.25 |
| imported/rsc/anchored-literal-long-match | 4 | 10653.26 ± 1.2% | not timed | not timed | 7293.14 ± 0.4% | 1245.63 ± 5.3% | not timed | not timed | 10626.61 ± 1.4% | | 1.00 | 1.46 | 8.55 |
| imported/rsc/one-pass-short | 17 | 372.92 ± 11.2% | not timed | not timed | 213.99 ± 0.2% | 31.31 ± 11.6% | not timed | not timed | 370.90 ± 1.7% | | 1.01 | 1.74 | 11.91 |
| imported/rsc/one-pass-short-not | 17 | 281.05 ± 2.6% | not timed | not timed | 224.68 ± 0.1% | 29.88 ± 10.7% | not timed | not timed | 280.70 ± 1.5% | | 1.00 | 1.25 | 9.41 |
| imported/rsc/one-pass-long-prefix | 26 | 363.32 ± 2.1% | not timed | not timed | 285.92 ± 0.1% | 97.29 ± 17.2% | not timed | not timed | 367.28 ± 0.3% | | 0.99 | 1.27 | 3.73 |
| imported/rsc/one-pass-long-prefix-not | 26 | 363.81 ± 2.5% | not timed | not timed | 281.32 ± 0.5% | 61.97 ± 20.3% | not timed | not timed | 366.46 ± 5.9% | | 0.99 | 1.29 | 5.87 |
| imported/rsc/long-needle1 | 31 | 22206.51 ± 0.1% | not timed | not timed | 20158.61 ± 0.2% | 3.76 ± 0.1% | not timed | not timed | 22210.81 ± 0.1% | | 1.00 | 1.10 | 5898.49 |
| imported/rsc/long-needle2 | 31 | 22336.21 ± 0.1% | not timed | not timed | 216.01 ± 0.2% | 3.77 ± 0.1% | not timed | not timed | 22339.24 ± 0.2% | | 1.00 | 103.40 | 5928.68 |
| imported/rsc/easy0-32 | 26 | 1065.35 ± 3.4% | not timed | not timed | 1551.85 ± 1.4% | 148.67 ± 18.8% | not timed | not timed | 1069.04 ± 0.1% | | 1.00 | 0.69 | 7.17 |
| imported/rsc/easy0-1k | 26 | 14931.61 ± 2.4% | not timed | not timed | 12510.07 ± 1.2% | 2322.51 ± 16.3% | not timed | not timed | 14918.36 ± 0.3% | | 1.00 | 1.19 | 6.43 |
| imported/rsc/easy0-32k | 26 | 22988.83 ± 1.9% | not timed | not timed | 20349.85 ± 0.1% | 18791.73 ± 31.3% | not timed | not timed | 23005.20 ± 0.2% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21188.47 ± 2.3% | not timed | not timed | 19654.61 ± 4.4% | 35272.77 ± 3.0% | not timed | not timed | 21355.17 ± 3.3% | | 0.99 | 1.08 | 0.60 |
| imported/rsc/easy1-32 | 19 | 807.09 ± 8.0% | not timed | not timed | 632.73 ± 0.3% | 138.37 ± 18.3% | not timed | not timed | 804.63 ± 2.3% | | 1.00 | 1.28 | 5.83 |
| imported/rsc/easy1-1k | 19 | 16493.17 ± 8.1% | not timed | not timed | 12887.47 ± 0.4% | 2497.93 ± 21.3% | not timed | not timed | 16464.60 ± 0.1% | | 1.00 | 1.28 | 6.60 |
| imported/rsc/easy1-32k | 19 | 516814.96 ± 2.2% | not timed | not timed | 402810.41 ± 0.1% | 20503.61 ± 32.9% | not timed | not timed | 516949.60 ± 0.2% | | 1.00 | 1.28 | 25.21 |
| imported/rsc/easy1-1mb | 19 | 16575126.40 ± 0.3% | not timed | not timed | 12948605.23 ± 0.1% | 38026.20 ± 1.4% | not timed | not timed | 16549246.32 ± 0.3% | | 1.00 | 1.28 | 435.89 |
| imported/rsc/medium-32 | 27 | 767.44 ± 1.8% | not timed | not timed | 639.29 ± 0.4% | 69.92 ± 13.0% | not timed | not timed | 772.35 ± 0.3% | | 0.99 | 1.20 | 10.98 |
| imported/rsc/medium-1k | 27 | 13644.33 ± 0.3% | not timed | not timed | 11312.67 ± 0.2% | 72.34 ± 0.2% | not timed | not timed | 13773.70 ± 0.4% | | 0.99 | 1.21 | 188.62 |
| imported/rsc/medium-32k | 27 | 425645.14 ± 0.1% | not timed | not timed | 353201.24 ± 0.5% | 48.61 ± 0.1% | not timed | not timed | 429455.95 ± 0.3% | | 0.99 | 1.21 | 8756.93 |
| imported/rsc/medium-1mb | 27 | 13597923.33 ± 0.3% | not timed | not timed | 11347461.02 ± 0.2% | 48.55 ± 0.1% | not timed | not timed | 13738453.96 ± 0.2% | | 0.99 | 1.20 | 280100.90 |
| imported/rsc/hard-32 | 58 | 421.31 ± 2.3% | not timed | not timed | 366.99 ± 0.2% | 49.29 ± 8.3% | not timed | not timed | 417.57 ± 0.3% | | 1.01 | 1.15 | 8.55 |
| imported/rsc/hard-1k | 27 | 13338.53 ± 0.5% | not timed | not timed | 11615.55 ± 0.6% | 40.87 ± 0.2% | not timed | not timed | 13313.52 ± 0.5% | | 1.00 | 1.15 | 326.38 |
| imported/rsc/hard-32k | 27 | 416570.26 ± 0.3% | not timed | not timed | 360123.45 ± 0.2% | 29.40 ± 0.3% | not timed | not timed | 417005.00 ± 0.1% | | 1.00 | 1.16 | 14169.40 |
| imported/rsc/hard-1mb | 51 | 8388304.91 ± 0.6% | not timed | not timed | 7240413.29 ± 0.4% | 29.44 ± 0.0% | not timed | not timed | 8315056.78 ± 0.4% | | 1.01 | 1.16 | 284907.36 |
| imported/rsc/reallyhard0-32 | 58 | 266.45 ± 2.6% | not timed | not timed | 222.51 ± 0.2% | 49.40 ± 7.9% | not timed | not timed | 267.23 ± 0.3% | | 1.00 | 1.20 | 5.39 |
| imported/rsc/reallyhard0-1k | 27 | 592.54 ± 0.5% | not timed | not timed | 585.06 ± 0.1% | 40.87 ± 0.1% | not timed | not timed | 590.19 ± 0.2% | | 1.00 | 1.01 | 14.50 |
| imported/rsc/reallyhard0-32k | 27 | 611.22 ± 0.1% | not timed | not timed | 618.51 ± 0.1% | 29.40 ± 0.2% | not timed | not timed | 611.17 ± 0.1% | | 1.00 | 0.99 | 20.79 |
| imported/rsc/reallyhard0-1mb | 51 | 590.69 ± 0.5% | not timed | not timed | 616.11 ± 0.2% | 29.37 ± 0.1% | not timed | not timed | 590.83 ± 0.2% | | 1.00 | 0.96 | 20.11 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.81 ± 4.3% | not timed | not timed | 196.72 ± 1.0% | 60.57 ± 7.9% | not timed | not timed | 288.92 ± 4.0% | | 1.00 | 1.47 | 4.77 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6769.76 ± 0.1% | not timed | not timed | 5941.94 ± 0.1% | 34.31 ± 0.2% | not timed | not timed | 6769.65 ± 0.1% | | 1.00 | 1.14 | 197.31 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21499.00 ± 0.1% | not timed | not timed | 19306.25 ± 0.0% | 24.67 ± 2.3% | not timed | not timed | 21501.46 ± 0.1% | | 1.00 | 1.11 | 871.39 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21232.62 ± 2.3% | not timed | not timed | 19445.30 ± 2.4% | 25.17 ± 0.2% | not timed | not timed | 21417.04 ± 2.9% | | 0.99 | 1.09 | 843.49 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.70 ± 1.4% | not timed | not timed | 214.09 ± 0.4% | 60.78 ± 9.0% | not timed | not timed | 282.80 ± 1.6% | | 1.00 | 1.32 | 4.65 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5887.44 ± 0.1% | not timed | not timed | 6265.65 ± 0.1% | 34.34 ± 0.8% | not timed | not timed | 5869.67 ± 0.2% | | 1.00 | 0.94 | 171.46 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21414.47 ± 0.3% | not timed | not timed | 19341.51 ± 0.1% | 25.01 ± 1.7% | not timed | not timed | 21415.81 ± 0.2% | | 1.00 | 1.11 | 856.26 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20698.27 ± 2.3% | not timed | not timed | 19612.76 ± 3.7% | 25.02 ± 0.3% | not timed | not timed | 21153.52 ± 3.2% | | 0.98 | 1.06 | 827.41 |
| imported/sherlock/name-sherlock | 776 | 19550.02 ± 1.7% | not timed | not timed | 18158.84 ± 1.1% | 9910.73 ± 21.8% | not timed | not timed | 19518.31 ± 1.8% | | 1.00 | 1.08 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15009.09 ± 1.6% | not timed | not timed | 15363.64 ± 1.2% | 3144.22 ± 17.7% | not timed | not timed | 15156.97 ± 1.4% | | 0.99 | 0.98 | 4.77 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19611.67 ± 2.1% | not timed | not timed | 18306.52 ± 0.9% | 7952.59 ± 17.3% | not timed | not timed | 19594.00 ± 1.9% | | 1.00 | 1.07 | 2.47 |
| imported/sherlock/name-sherlock-casei | 816 | 15621.25 ± 1.1% | not timed | not timed | 4014.31 ± 0.2% | 32.62 ± 0.1% | not timed | not timed | 15610.76 ± 0.5% | | 1.00 | 3.89 | 478.83 |
| imported/sherlock/name-holmes-casei | 2802 | 9427.10 ± 10.2% | not timed | not timed | 3315.10 ± 0.1% | 37.68 ± 0.2% | not timed | not timed | 9471.55 ± 6.6% | | 1.00 | 2.84 | 250.19 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13177.32 ± 2.3% | not timed | not timed | 3951.23 ± 0.4% | 32.48 ± 0.3% | not timed | not timed | 13188.16 ± 0.5% | | 1.00 | 3.33 | 405.70 |
| imported/sherlock/name-whitespace | 1461 | 14844.92 ± 1.6% | not timed | not timed | 14367.68 ± 0.6% | 6437.03 ± 19.1% | not timed | not timed | 15188.40 ± 0.9% | | 0.98 | 1.03 | 2.31 |
| imported/sherlock/name-alt1 | 1142 | 11627.43 ± 0.7% | not timed | not timed | 16168.86 ± 0.9% | 4078.81 ± 14.6% | not timed | not timed | 11624.62 ± 2.6% | | 1.00 | 0.72 | 2.85 |
| imported/sherlock/name-alt2 | 3542 | 8960.04 ± 0.6% | not timed | not timed | 3830.16 ± 0.1% | 31.23 ± 0.2% | not timed | not timed | 8970.96 ± 0.6% | | 1.00 | 2.34 | 286.94 |
| imported/sherlock/name-alt3 | 4507 | 5567.68 ± 0.4% | not timed | not timed | 3632.17 ± 0.2% | 9.92 ± 4.1% | not timed | not timed | 5573.16 ± 0.3% | | 1.00 | 1.53 | 561.10 |
| imported/sherlock/name-alt3-casei | 4593 | 1529.62 ± 0.9% | not timed | not timed | 285.20 ± 0.2% | 6.47 ± 0.2% | not timed | not timed | 1533.93 ± 0.9% | | 1.00 | 5.36 | 236.25 |
| imported/sherlock/name-alt4 | 3686 | 6399.56 ± 0.4% | not timed | not timed | 3798.42 ± 0.1% | 31.27 ± 0.2% | not timed | not timed | 6386.67 ± 0.4% | | 1.00 | 1.68 | 204.66 |
| imported/sherlock/name-alt4-casei | 4254 | 2808.75 ± 2.1% | not timed | not timed | 2580.66 ± 0.2% | 19.87 ± 0.3% | not timed | not timed | 2812.48 ± 0.8% | | 1.00 | 1.09 | 141.36 |
| imported/sherlock/name-alt5 | 4028 | 6448.34 ± 0.3% | not timed | not timed | 3744.83 ± 0.1% | 21.74 ± 0.2% | not timed | not timed | 6454.16 ± 0.5% | | 1.00 | 1.72 | 296.65 |
| imported/sherlock/name-alt5-casei | 4104 | 3514.20 ± 1.5% | not timed | not timed | 2218.62 ± 0.3% | 14.41 ± 0.1% | not timed | not timed | 3521.64 ± 1.0% | | 1.00 | 1.58 | 243.94 |
| imported/sherlock/no-match-uncommon | 0 | 21374.38 ± 0.7% | not timed | not timed | 19256.42 ± 0.7% | 34695.57 ± 0.8% | not timed | not timed | 21406.12 ± 0.5% | | 1.00 | 1.11 | 0.62 |
| imported/sherlock/no-match-common | 0 | 21066.33 ± 0.4% | not timed | not timed | 19201.33 ± 1.0% | 1281.30 ± 1.1% | not timed | not timed | 21044.73 ± 0.6% | | 1.00 | 1.10 | 16.44 |
| imported/sherlock/no-match-really-common | 0 | 15891.34 ± 3.1% | not timed | not timed | 18491.43 ± 1.0% | 1275.58 ± 1.0% | not timed | not timed | 15985.41 ± 1.5% | | 0.99 | 0.86 | 12.46 |
| imported/sherlock/the-lower | 21654 | 2319.42 ± 1.0% | not timed | not timed | 2326.66 ± 0.3% | 231.99 ± 16.2% | not timed | not timed | 2331.55 ± 1.4% | | 0.99 | 1.00 | 10.00 |
| imported/sherlock/the-upper | 2223 | 12678.22 ± 11.3% | not timed | not timed | 13487.39 ± 0.5% | 2788.46 ± 19.7% | not timed | not timed | 12734.48 ± 1.1% | | 1.00 | 0.94 | 4.55 |
| imported/sherlock/the-casei | 23961 | 2014.52 ± 0.4% | not timed | not timed | 1319.45 ± 0.5% | 34.86 ± 33.5% | not timed | not timed | 2016.15 ± 1.4% | | 1.00 | 1.53 | 57.78 |
| imported/sherlock/everything-greedy | 581881 | 283.29 ± 8.0% | not timed | not timed | 165.30 ± 0.3% | 28.81 ± 31.3% | not timed | not timed | 283.25 ± 0.9% | | 1.00 | 1.71 | 9.83 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.83 ± 0.1% | not timed | not timed | 212.66 ± 0.3% | 33.03 ± 0.4% | not timed | not timed | 462.70 ± 0.1% | | 1.00 | 2.18 | 14.01 |
| imported/sherlock/letters | 447175 | 62.19 ± 0.7% | not timed | not timed | 33.06 ± 0.2% | 6.73 ± 3.6% | not timed | not timed | 62.36 ± 0.7% | | 1.00 | 1.88 | 9.24 |
| imported/sherlock/letters-upper | 14180 | 453.54 ± 1.2% | not timed | not timed | 369.29 ± 0.1% | 29.41 ± 20.5% | not timed | not timed | 453.25 ± 0.2% | | 1.00 | 1.23 | 15.42 |
| imported/sherlock/letters-lower | 432995 | 63.43 ± 0.9% | not timed | not timed | 33.71 ± 0.3% | 6.85 ± 43.9% | not timed | not timed | 63.63 ± 0.7% | | 1.00 | 1.88 | 9.26 |
| imported/sherlock/words | 447639 | 115.78 ± 6.5% | not timed | not timed | 82.82 ± 0.2% | 13.83 ± 11.8% | not timed | not timed | 116.01 ± 0.2% | | 1.00 | 1.40 | 8.37 |
| imported/sherlock/before-holmes | 4073 | 10252.50 ± 0.5% | not timed | not timed | 8455.34 ± 0.4% | 24.05 ± 0.5% | not timed | not timed | 10274.12 ± 0.5% | | 1.00 | 1.21 | 426.25 |
| imported/sherlock/before-after-holmes | 2593 | 9898.00 ± 1.0% | not timed | not timed | 9493.81 ± 0.7% | 24.08 ± 0.7% | not timed | not timed | 9894.77 ± 0.7% | | 1.00 | 1.04 | 411.10 |
| imported/sherlock/holmes-cochar-watson | 150 | 5195.73 ± 0.5% | not timed | not timed | 3427.48 ± 0.4% | 31.07 ± 0.2% | not timed | not timed | 5196.42 ± 0.6% | | 1.00 | 1.52 | 167.23 |
| imported/sherlock/holmes-coword-watson | 14309 | 1189.22 ± 0.2% | not timed | not timed | 1125.26 ± 0.3% | 6.77 ± 0.2% | not timed | not timed | 1188.55 ± 0.7% | | 1.00 | 1.06 | 175.64 |
| imported/sherlock/quotes | 14437 | 1395.66 ± 0.3% | not timed | not timed | 1751.81 ± 2.4% | 35.14 ± 0.1% | not timed | not timed | 1401.00 ± 0.4% | | 1.00 | 0.80 | 39.72 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.79 ± 0.2% | not timed | not timed | 15978.05 ± 0.4% | 36.63 ± 0.1% | not timed | not timed | 609.61 ± 0.2% | | 1.00 | 0.0382 | 16.65 |
| imported/sherlock/word-ending-n | 35297 | 480.63 ± 2.8% | not timed | not timed | 409.12 ± 0.2% | 23.48 ± 16.3% | not timed | not timed | 481.62 ± 0.5% | | 1.00 | 1.17 | 20.47 |
| imported/sherlock/repeated-class-negation | 2130 | 14314.32 ± 1.6% | not timed | not timed | 10946.43 ± 0.5% | 11.57 ± 0.3% | not timed | not timed | 14479.71 ± 0.5% | | 0.99 | 1.31 | 1236.83 |
| imported/sherlock/ing-suffix | 20547 | 566.48 ± 0.3% | not timed | not timed | 517.34 ± 0.0% | 28.88 ± 0.2% | not timed | not timed | 567.55 ± 0.3% | | 1.00 | 1.09 | 19.61 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.16 ± 0.5% | not timed | not timed | 2098.70 ± 0.8% | 20.54 ± 0.2% | not timed | not timed | 608.73 ± 0.3% | | 1.00 | 0.29 | 29.56 |
| opt/accelerate/whole-line | 239963 | 458.10 ± 0.3% | not timed | not timed | 372.09 ± 0.4% | 92.81 ± 16.4% | not timed | not timed | 458.42 ± 0.1% | | 1.00 | 1.23 | 4.94 |
| opt/accelerate/non-dna | 16745 | 425.29 ± 0.2% | not timed | not timed | 396.87 ± 0.2% | 29.66 ± 53.4% | not timed | not timed | 428.04 ± 1.9% | | 0.99 | 1.07 | 14.34 |
| opt/backtrack/words-english | 40536 | 136.62 ± 0.2% | not timed | not timed | 94.50 ± 0.1% | 20.00 ± 8.8% | not timed | not timed | 136.33 ± 1.9% | | 1.00 | 1.45 | 6.83 |
| opt/fixed-length/too-small-ascii | 0 | 311.59 ± 0.2% | not timed | not timed | 702.12 ± 2.4% | 80.02 ± 0.2% | not timed | not timed | 314.82 ± 0.3% | | 0.99 | 0.44 | 3.89 |
| opt/fixed-length/too-big-ascii | 0 | 3494.39 ± 0.3% | not timed | not timed | 5814.76 ± 0.4% | 125.39 ± 4.0% | not timed | not timed | 3471.34 ± 0.3% | | 1.01 | 0.60 | 27.87 |
| opt/fixed-length/go33484-1 | 0 | 671737.63 ± 0.5% | not timed | not timed | 1105264.19 ± 0.5% | 61335.22 ± 0.3% | not timed | not timed | 668344.63 ± 0.4% | | 1.01 | 0.61 | 10.95 |
| opt/fixed-length/go33484-2 | 0 | 671282.50 ± 0.5% | not timed | not timed | 1104422.66 ± 0.8% | 32250.99 ± 2.7% | not timed | not timed | 667801.88 ± 0.5% | | 1.01 | 0.61 | 20.81 |
| opt/fixed-length/go33484-3 | 0 | 2414.49 ± 2.8% | not timed | not timed | 109235.78 ± 0.2% | 767.59 ± 0.6% | not timed | not timed | 2428.14 ± 2.6% | | 0.99 | 0.0221 | 3.15 |
| opt/literal-alt/one-pattern | 1 | 545.95 ± 1.4% | not timed | not timed | 540.28 ± 0.1% | 0.39 ± 0.2% | not timed | not timed | 545.82 ± 1.3% | | 1.00 | 1.01 | 1388.93 |
| opt/onepass/fn-predicate | 916 | 371.05 ± 0.6% | not timed | not timed | 335.59 ± 0.2% | 201.82 ± 14.3% | not timed | not timed | 373.91 ± 1.0% | | 0.99 | 1.11 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 174.30 ± 9.0% | not timed | not timed | 200.71 ± 0.2% | 81.90 ± 9.6% | not timed | not timed | 176.45 ± 7.2% | | 0.99 | 0.87 | 2.13 |
| opt/prefilter/literal-english | 1 | 20779.81 ± 0.3% | not timed | not timed | 19962.10 ± 0.2% | 17400.47 ± 0.6% | not timed | not timed | 20681.61 ± 0.5% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14560.21 ± 0.3% | not timed | not timed | 4316.31 ± 0.8% | 32.75 ± 0.6% | not timed | not timed | 14566.39 ± 0.7% | | 1.00 | 3.37 | 444.59 |
| opt/prefilter/literal-russian | 1 | 21296.38 ± 0.4% | not timed | not timed | 19648.52 ± 0.7% | 3323.46 ± 0.3% | not timed | not timed | 21281.48 ± 0.4% | | 1.00 | 1.08 | 6.41 |
| opt/prefilter/literal-casei-russian | 1 | 8550.52 ± 0.7% | not timed | not timed | 3884.26 ± 0.1% | 31.61 ± 0.4% | not timed | not timed | 8519.87 ± 0.8% | | 1.00 | 2.20 | 270.48 |
| opt/prefilter/rust-functions | 948 | 6818.29 ± 0.5% | not timed | not timed | 8919.54 ± 0.4% | 1866.93 ± 0.4% | not timed | not timed | 6834.47 ± 0.2% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29948684.91 ± 0.2% | not timed | not timed | 21302167.45 ± 0.2% | 50.54 ± 0.2% | not timed | not timed | 29867601.44 ± 0.2% | | 1.00 | 1.41 | 592590.23 |
| opt/reverse-inner/holmes | 2593 | 9867.42 ± 1.0% | not timed | not timed | 9472.27 ± 0.4% | 23.64 ± 1.1% | not timed | not timed | 9892.57 ± 0.4% | | 1.00 | 1.04 | 417.42 |
| opt/reverse-inner/email | 47 | 36297.62 ± 2.0% | not timed | not timed | 45053.87 ± 0.4% | 32.49 ± 0.1% | not timed | not timed | 36847.32 ± 2.2% | | 0.99 | 0.81 | 1117.18 |
| opt/reverse-inner/factored-prefix | 3542 | 601.22 ± 0.2% | not timed | not timed | 596.93 ± 0.1% | 12.55 ± 0.2% | not timed | not timed | 600.19 ± 0.2% | | 1.00 | 1.01 | 47.90 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5553.83 ± 0.4% | not timed | not timed | 614.34 ± 0.1% | 75.09 ± 0.2% | not timed | not timed | 5531.91 ± 0.1% | | 1.00 | 9.04 | 73.96 |
| opt/reverse-inner/no-quadratic-forward | 0 | 685.86 ± 1.9% | not timed | not timed | 287.98 ± 0.0% | 24.80 ± 0.1% | not timed | not timed | 687.44 ± 1.8% | | 1.00 | 2.38 | 27.65 |
| opt/reverse-suffix/holmes | 4073 | 10266.35 ± 0.7% | not timed | not timed | 8418.72 ± 0.5% | 24.14 ± 1.2% | not timed | not timed | 10289.75 ± 0.5% | | 1.00 | 1.22 | 425.27 |
| opt/reverse-suffix/no-quadratic | 0 | 5526.67 ± 0.1% | not timed | not timed | 613.08 ± 0.4% | 75.00 ± 0.1% | not timed | not timed | 5559.50 ± 0.1% | | 0.99 | 9.01 | 73.69 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.65 ± 8.2% | not timed | not timed | 130.60 ± 0.6% | 13.46 ± 15.6% | not timed | not timed | 122.47 ± 2.4% | | 0.99 | 0.93 | 9.04 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.39 ± 0.4% | not timed | not timed | 131.93 ± 0.1% | 13.32 ± 11.4% | not timed | not timed | 121.95 ± 2.4% | | 1.00 | 0.93 | 9.19 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.4% | not timed | not timed | 0.55 ± 0.3% | 112.99 ± 7.1% | not timed | not timed | 0.28 ± 3.0% | | 1.00 | 0.50 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.41 ± 0.4% | not timed | not timed | 294.19 ± 0.1% | 104.28 ± 0.1% | not timed | not timed | 316.42 ± 0.2% | | 1.00 | 1.08 | 3.04 |
| reported/i13-subset-regex/original-ascii | 4094 | 11171.34 ± 2.0% | not timed | not timed | 4520.97 ± 0.6% | 11.50 ± 0.3% | not timed | not timed | 11159.17 ± 1.2% | | 1.00 | 2.47 | 971.70 |
| reported/i13-subset-regex/original-unicode | 4094 | 10965.85 ± 0.6% | not timed | not timed | 250.33 ± 3.4% | 11.50 ± 0.2% | not timed | not timed | 11082.12 ± 1.1% | | 0.99 | 43.81 | 953.59 |
| reported/i13-subset-regex/big-ascii | 1955 | 10609.35 ± 2.8% | not timed | not timed | 67.86 ± 3.7% | 9.84 ± 0.2% | not timed | not timed | 10679.61 ± 1.7% | | 0.99 | 156.33 | 1078.27 |
| reported/i13-subset-regex/big-unicode | 1955 | 10584.75 ± 1.0% | not timed | not timed | 12.23 ± 55.0% | 9.87 ± 0.1% | not timed | not timed | 10708.09 ± 2.0% | | 0.99 | 865.19 | 1072.51 |
| reported/i13-subset-regex/huge-ascii | 55 | 10067.50 ± 2.3% | not timed | not timed | 10.97 ± 0.1% | 8.73 ± 0.1% | not timed | not timed | 9924.08 ± 2.5% | | 1.01 | 917.31 | 1152.84 |
| reported/i13-subset-regex/huge-unicode | 55 | 9926.60 ± 2.1% | not timed | not timed | 10.92 ± 0.3% | 8.75 ± 0.1% | not timed | not timed | 9881.06 ± 2.5% | | 1.00 | 909.05 | 1134.17 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.57 ± 0.0% | not timed | not timed | 11.04 ± 0.1% | 8.77 ± 1.1% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.2% | not timed | not timed | 10.93 ± 0.3% | 8.77 ± 0.3% | not timed | not timed | 5.04 ± 0.2% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 486.97 ± 0.3% | not timed | not timed | 104.09 ± 0.1% | 6.56 ± 0.2% | not timed | not timed | 488.30 ± 0.4% | | 1.00 | 4.68 | 74.25 |
| reported/i787-keywords/opt-ascii | 5674 | 488.21 ± 0.3% | not timed | not timed | 275.64 ± 0.3% | 10.26 ± 0.4% | not timed | not timed | 489.06 ± 0.2% | | 1.00 | 1.77 | 47.58 |
| slow/quadratic-regex-1x | 100 | 7.11 ± 0.5% | not timed | not timed | 4.95 ± 0.1% | 0.05 ± 0.5% | not timed | not timed | 7.13 ± 0.1% | | 1.00 | 1.44 | 143.97 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.2% | not timed | not timed | 2.75 ± 0.1% | 0.01 ± 0.3% | not timed | not timed | 3.43 ± 0.1% | | 1.00 | 1.25 | 269.65 |
| slow/quadratic-haystack-1x | 100 | 21.22 ± 1.7% | not timed | not timed | 9.99 ± 0.1% | 1.02 ± 8.8% | not timed | not timed | 21.28 ± 5.6% | | 1.00 | 2.12 | 20.89 |
| slow/quadratic-haystack-2x | 200 | 17.70 ± 10.2% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 6.2% | not timed | not timed | 17.82 ± 2.5% | | 0.99 | 3.19 | 32.51 |
| unicode/codepoints/any-one | 1112064 | 289.98 ± 0.3% | not timed | not timed | 171.28 ± 0.6% | 18.41 ± 3.3% | not timed | not timed | 288.53 ± 0.3% | | 1.01 | 1.69 | 15.75 |
| unicode/codepoints/any-all | 4382592 | 270.11 ± 0.3% | not timed | not timed | 246.52 ± 0.2% | 117.43 ± 0.1% | not timed | not timed | 270.62 ± 0.5% | | 1.00 | 1.10 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.71 ± 1.4% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 602.00 ± 0.7% | not timed | not timed | 615.84 ± 0.3% | 135.40 ± 0.2% | not timed | not timed | 603.18 ± 0.7% | | 1.00 | 0.98 | 4.45 |
| unicode/overlapping-words/ascii | 6156 | 31.63 ± 0.3% | not timed | not timed | 38.97 ± 0.0% | 3.95 ± 0.4% | not timed | not timed | 31.64 ± 0.3% | | 1.00 | 0.81 | 8.00 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 4.45 ± 0.4% | 2.34 ± 0.7% | not timed | not timed | 1.45 ± 0.1% | | 0.99 | 0.32 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.8% | not timed | not timed | 3.85 ± 0.2% | 6.23 ± 9.6% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.33 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 128.06 ± 3.9% | not timed | not timed | 82.62 ± 0.3% | 11.61 ± 17.8% | not timed | not timed | 128.92 ± 0.3% | | 0.99 | 1.55 | 11.03 |
| unicode/word/boundary-long-english | 3466 | 615.09 ± 0.3% | not timed | not timed | 605.19 ± 0.1% | 32.28 ± 0.7% | not timed | not timed | 615.68 ± 0.1% | | 1.00 | 1.02 | 19.05 |
| unicode/word/around-holmes-english | 27 | 19909.83 ± 0.4% | not timed | not timed | 19689.78 ± 0.2% | 21.84 ± 0.9% | not timed | not timed | 19732.54 ± 0.3% | | 1.01 | 1.01 | 911.80 |
| wild/bibleref/long | 874 | 563.80 ± 0.2% | not timed | not timed | 580.64 ± 0.1% | 6.82 ± 0.3% | not timed | not timed | 563.99 ± 0.3% | | 1.00 | 0.97 | 82.65 |
| wild/bibleref/short | 30 | 24.82 ± 2.3% | not timed | not timed | 30.82 ± 0.5% | 14.13 ± 10.9% | not timed | not timed | 25.39 ± 3.8% | | 0.98 | 0.81 | 1.76 |
| wild/bibleref/line | 874 | 393.59 ± 0.2% | not timed | not timed | 213.97 ± 0.3% | 9.05 ± 9.5% | not timed | not timed | 393.69 ± 4.1% | | 1.00 | 1.84 | 43.51 |
| wild/caddy/caddy | 6 | 417.56 ± 3.5% | not timed | not timed | 246.13 ± 0.1% | 67.98 ± 12.1% | not timed | not timed | 418.56 ± 0.2% | | 1.00 | 1.70 | 6.14 |
| wild/dot-star-capture/rust-src-tools | 6 | 1069.41 ± 0.5% | not timed | not timed | 343.91 ± 0.3% | 13.49 ± 0.2% | not timed | not timed | 1070.98 ± 0.4% | | 1.00 | 3.11 | 79.25 |
| wild/ruff/noqa | 84 | 436.12 ± 0.2% | not timed | not timed | 465.00 ± 0.1% | 19.55 ± 2.0% | not timed | not timed | 434.88 ± 0.2% | | 1.00 | 0.94 | 22.31 |
| wild/ruff/unnecessary-coding-comment | 16 | 963.17 ± 0.5% | not timed | not timed | 700.46 ± 0.2% | 134.13 ± 10.9% | not timed | not timed | 960.56 ± 0.3% | | 1.00 | 1.38 | 7.18 |
| wild/ruff/string-quote-prefix | 2972 | 1357.49 ± 0.7% | not timed | not timed | 439.55 ± 0.1% | 318.78 ± 25.6% | not timed | not timed | 1359.52 ± 0.8% | | 1.00 | 3.09 | 4.26 |
| wild/ruff/space-around-operator | 1224378 | 220.10 ± 1.8% | not timed | not timed | 186.93 ± 0.1% | 18.31 ± 1.7% | not timed | not timed | 220.54 ± 1.8% | | 1.00 | 1.18 | 12.02 |
| wild/ruff/shebang | 282 | 984.92 ± 0.6% | not timed | not timed | 329.60 ± 0.0% | 118.43 ± 12.0% | not timed | not timed | 988.65 ± 0.3% | | 1.00 | 2.99 | 8.32 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13809.23 ± 0.2% | not timed | not timed | 13901.19 ± 0.3% | 6956.05 ± 0.6% | not timed | not timed | 13841.18 ± 0.2% | | 1.00 | 0.99 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12829.33 ± 0.3% | not timed | not timed | 13541.34 ± 0.2% | 6411.67 ± 1.2% | not timed | not timed | 12826.05 ± 0.3% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13227.55 ± 1.2% | not timed | not timed | 13717.96 ± 0.3% | 6617.40 ± 0.8% | not timed | not timed | 13230.15 ± 0.5% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9560.46 ± 0.3% | not timed | not timed | 13660.80 ± 0.2% | 6732.36 ± 0.5% | not timed | not timed | 9585.13 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.38 ± 14.1% | not timed | not timed | 65.08 ± 7.0% | 2.21 ± 0.7% | not timed | not timed | 120.27 ± 13.9% | | 1.01 | 1.87 | 54.95 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.9% | not timed | not timed | 0.01 ± 2.5% | 0.01 ± 16.2% | not timed | not timed | 0.03 ± 46.1% | | 1.00 | 3.09 | 4.15 |
| dictionary/compile/english-15 | 1 | 0.35 ± 19.4% | not timed | not timed | 0.07 ± 0.9% | 0.10 ± 24.8% | not timed | not timed | 0.35 ± 1.3% | | 0.99 | 5.00 | 3.37 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 3.0% | not timed | not timed | 0.02 ± 0.9% | 35.28 ± 12.4% | not timed | not timed | 0.25 ± 4.1% | | 1.00 | 13.31 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.27 ± 2.5% | not timed | not timed | 11.53 ± 0.5% | 52.37 ± 19.1% | not timed | not timed | 47.49 ± 2.6% | | 1.00 | 4.10 | 0.90 |
| reported/i787-keywords/compile | 1 | 34.62 ± 15.8% | not timed | not timed | 2.10 ± 1.3% | 16.98 ± 23.5% | not timed | not timed | 34.61 ± 2.1% | | 1.00 | 16.48 | 2.04 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 365.64 ± 4.2% | not timed | not timed | 128.72 ± 0.2% | 562.98 ± 25.8% | not timed | not timed | 370.38 ± 3.3% | | 0.99 | 2.84 | 0.65 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.23 ± 2.1% | not timed | not timed | 4.10 ± 0.7% | 44.51 ± 6.7% | not timed | not timed | 47.92 ± 2.1% | | 0.99 | 11.52 | 1.06 |
| unicode/compile/one-letter | 53 | 6.71 ± 13.7% | not timed | not timed | 4.53 ± 0.6% | 66.28 ± 2.4% | not timed | not timed | 6.72 ± 12.8% | | 1.00 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 0.97 ± 17.1% | not timed | not timed | 0.10 ± 0.4% | 66.85 ± 8.6% | not timed | not timed | 1.09 ± 3.7% | | 0.89 | 9.88 | 0.0145 |
| unicode/compile/fifty-letters-ascii | 1 | 219.57 ± 2.5% | not timed | not timed | 52.41 ± 0.3% | 191.43 ± 12.1% | not timed | not timed | 222.41 ± 5.8% | | 0.99 | 4.19 | 1.15 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 383.98 ± 8.0% | not timed | not timed | 47.24 ± 0.4% | 705.07 ± 22.8% | not timed | not timed | 384.99 ± 8.9% | | 1.00 | 8.13 | 0.54 |
| unicode/compile/match-every-line-ascii | 4 | 602.67 ± 18.3% | not timed | not timed | 145.94 ± 0.3% | 661.22 ± 22.0% | not timed | not timed | 615.68 ± 5.7% | | 0.98 | 4.13 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 324.51 ± 13.7% | not timed | not timed | 50.96 ± 0.3% | 1196.92 ± 16.1% | not timed | not timed | 332.04 ± 2.7% | | 0.98 | 6.37 | 0.27 |
| wild/bibleref/compile | 3 | 5.86 ± 1.8% | not timed | not timed | 1.90 ± 0.5% | 31.96 ± 8.0% | not timed | not timed | 5.88 ± 2.3% | | 1.00 | 3.08 | 0.18 |
| wild/url/compile | 1 | 0.63 ± 18.2% | not timed | not timed | 0.14 ± 1.0% | 0.43 ± 38.6% | not timed | not timed | 0.63 ± 17.3% | | 1.00 | 4.34 | 1.45 |

