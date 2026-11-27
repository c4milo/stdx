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
| literal: a word | 217 | 19324.92 ± 1.1% | 10817.17 ± 0.7% | 28.32 ± 0.3% | 17971.58 ± 1.9% | 9276.42 ± 6.0% | 17.31 ± 0.2% | 86.48 ± 0.3% | 19294.22 ± 2.4% | 1.79 | 1.00 | 1.08 | 2.08 |
| literal: a word that is not there | 0 | 21428.78 ± 2.1% | 9862.86 ± 0.5% | 28.28 ± 0.3% | 19435.31 ± 1.9% | 28221.98 ± 2.2% | 17.12 ± 0.4% | 80.89 ± 0.3% | 21264.79 ± 2.2% | 2.17 | 1.01 | 1.10 | 0.76 |
| literal: one of four words | 661 | 6427.15 ± 0.2% | 1789.24 ± 0.2% | 14.34 ± 0.1% | 3936.94 ± 0.4% | 21.89 ± 0.1% | 5.39 ± 0.1% | 6.98 ± 0.2% | 6419.74 ± 0.7% | 3.59 | 1.00 | 1.63 | 293.58 |
| literal: a word in any case | 217 | 15105.72 ± 1.0% | 1918.19 ± 0.3% | 21.41 ± 0.2% | 3961.73 ± 0.2% | 38.03 ± 0.1% | refused | differs | 15127.15 ± 0.7% | 7.87 | 1.00 | 3.81 | 397.20 |
| literal: an href attribute | 33 | 16930.19 ± 0.5% | 609.64 ± 0.8% | 27.30 ± 0.3% | 17057.19 ± 2.0% | 2257.45 ± 0.5% | 12.83 ± 0.5% | 75.53 ± 1.1% | 16882.48 ± 1.4% | 27.77 | 1.00 | 0.99 | 7.50 |
| literal: a word, second text | 123 | 19798.75 ± 2.8% | 4593.21 ± 0.4% | 27.94 ± 0.4% | 18319.40 ± 1.6% | 7767.95 ± 5.1% | 20.07 ± 0.7% | 71.32 ± 0.5% | 19846.94 ± 1.8% | 4.31 | 1.00 | 1.08 | 2.55 |
| class: two capitalized words | 1331 | 1179.30 ± 0.1% | 598.67 ± 0.5% | 26.00 ± 0.3% | 585.11 ± 0.1% | 40.72 ± 2.8% | 14.88 ± 0.3% | 68.12 ± 0.4% | 1177.56 ± 0.2% | 1.97 | 1.00 | 2.02 | 28.96 |
| class: a word that ends in ing | 3399 | 574.12 ± 0.3% | 573.88 ± 0.2% | 17.77 ± 0.2% | 547.76 ± 0.2% | 29.64 ± 5.2% | 8.14 ± 0.1% | 18.45 ± 0.1% | 575.02 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.37 |
| class: a word in capitals | 2332 | 1531.36 ± 0.5% | 607.75 ± 0.2% | 27.64 ± 0.1% | 577.62 ± 0.2% | 43.46 ± 2.0% | 17.11 ± 0.3% | 83.34 ± 0.4% | 1531.11 ± 0.4% | 2.52 | 1.00 | 2.65 | 35.24 |
| class: a number | 8288 | 2675.02 ± 0.2% | 840.35 ± 0.0% | 27.74 ± 0.3% | 1710.27 ± 0.4% | 40.70 ± 13.1% | 0.52 ± 0.3% | 57.39 ± 0.4% | 2679.10 ± 0.2% | 3.18 | 1.00 | 1.56 | 65.73 |
| class: two capitalized words, second text | 5359 | 521.55 ± 0.5% | 528.03 ± 0.2% | 23.14 ± 0.2% | 484.76 ± 0.1% | 35.42 ± 14.4% | 17.08 ± 0.1% | 63.33 ± 0.5% | 522.05 ± 0.4% | 0.99 | 1.00 | 1.08 | 14.73 |
| other: a word between two words | 6104 | 810.89 ± 0.2% | 601.68 ± 0.2% | 23.41 ± 0.1% | 737.25 ± 0.2% | 109.19 ± 19.5% | 11.27 ± 0.0% | 69.77 ± 0.4% | 813.48 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.43 |
| other: a number before a unit, second text | 1481 | 6256.17 ± 1.4% | 1141.61 ± 0.2% | 25.95 ± 0.3% | 5637.30 ± 0.5% | 40.71 ± 0.3% | 18.16 ± 0.2% | 65.87 ± 0.2% | 6232.63 ± 1.1% | 5.48 | 1.00 | 1.11 | 153.66 |
| other: a heading's start tag | 110 | 14171.01 ± 0.7% | 740.05 ± 0.2% | 27.30 ± 0.1% | 1708.81 ± 0.3% | 1586.89 ± 3.4% | 16.07 ± 0.4% | 87.94 ± 0.9% | 14221.80 ± 1.4% | 19.15 | 1.00 | 8.29 | 8.93 |
| other: a whole word | 217 | 16145.19 ± 0.7% | 601.92 ± 0.3% | 28.42 ± 0.3% | 14538.82 ± 0.7% | 49.46 ± 0.4% | 13.29 ± 0.3% | 55.43 ± 0.5% | 16258.90 ± 1.2% | 26.82 | 0.99 | 1.11 | 326.41 |
| other: a line's first word, second text | 3716 | 2105.67 ± 0.4% | 592.56 ± 0.5% | 30.56 ± 0.2% | 1728.89 ± 2.7% | 62.28 ± 7.4% | refused | refused | 2098.98 ± 0.8% | 3.55 | 1.00 | 1.22 | 33.81 |
| other: fourteen octets before an x | 87 | 23812.76 ± 0.6% | 249.38 ± 0.6% | 6.45 ± 0.1% | 4005.16 ± 0.3% | 10.63 ± 0.1% | differs | 17.92 ± 0.4% | 24117.36 ± 6.8% | 95.49 | 0.99 | 5.95 | 2240.05 |
| other: a Greek word | 21815 | 526.51 ± 0.6% | 423.40 ± 0.1% | 30.41 ± 0.2% | 289.20 ± 0.4% | 49.59 ± 12.8% | differs | refused | 529.21 ± 0.5% | 1.24 | 0.99 | 1.82 | 10.62 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.74 ± 0.2% | 29.67 ± 0.1% | 0.85 ± 0.3% | 19.83 ± 0.2% | 2.74 ± 1.1% | differs | 4.07 ± 0.2% | 29.64 ± 0.2% | 1.00 | 1.00 | 1.50 | 10.84 |
| a UUID | 32895 | 24.71 ± 0.2% | 24.80 ± 0.2% | 0.64 ± 0.3% | 15.16 ± 0.3% | 3.11 ± 0.1% | 0.73 ± 0.3% | 3.62 ± 0.7% | 24.80 ± 0.4% | 1.00 | 1.00 | 1.63 | 7.93 |
| an IPv4 address | 33176 | 38.37 ± 0.2% | 38.80 ± 0.3% | 2.07 ± 0.3% | 29.43 ± 0.3% | 6.65 ± 0.2% | differs | 4.23 ± 0.1% | 38.78 ± 0.2% | 0.99 | 0.99 | 1.30 | 5.77 |
| a date and time | 32954 | 34.12 ± 0.1% | 34.25 ± 0.2% | 1.43 ± 0.2% | 21.80 ± 0.1% | 7.03 ± 0.3% | 1.26 ± 0.3% | 7.18 ± 0.3% | 34.22 ± 0.1% | 1.00 | 1.00 | 1.57 | 4.85 |
| a field path | 32606 | 32.85 ± 0.5% | 32.84 ± 0.2% | 1.02 ± 0.2% | 23.31 ± 0.4% | 3.51 ± 0.5% | differs | 2.97 ± 0.3% | 32.84 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.36 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.22 ± 0.3% | 11.18 ± 0.2% | 11.22 ± 0.3% | 11.81 ± 0.1% | 4.93 ± 1.3% | 0.94 ± 1.0% | none | 11.16 ± 0.2% | 1.00 | 1.01 | 0.95 | 2.28 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 215.20 ± 0.2% | 215.34 ± 0.2% | 257.98 ± 0.1% | 88.10 ± 1.0% | 222.02 ± 0.7% | 473.21 ± 2.2% | 3757.77 ± 2.7% | 215.02 ± 0.2% | 1.00 | 1.00 | 2.44 | 0.97 |
| a UUID | 62 | 142.04 ± 0.2% | 142.30 ± 0.2% | 160.34 ± 0.2% | 46.28 ± 0.7% | 99.21 ± 0.9% | 185.09 ± 2.9% | 4391.48 ± 0.7% | 142.22 ± 0.1% | 1.00 | 1.00 | 3.07 | 1.43 |
| an IPv4 address | 29 | 401.94 ± 0.3% | 402.37 ± 0.4% | 579.88 ± 0.6% | 76.60 ± 0.4% | 130.86 ± 1.9% | 296.42 ± 0.8% | 7591.27 ± 0.4% | 402.09 ± 0.3% | 1.00 | 1.00 | 5.25 | 3.07 |
| a date and time | 56 | 290.31 ± 0.2% | 290.85 ± 0.2% | 373.48 ± 0.4% | 72.43 ± 0.4% | 136.63 ± 1.2% | 322.33 ± 1.6% | 4968.29 ± 0.3% | 290.53 ± 0.3% | 1.00 | 1.00 | 4.01 | 2.12 |
| a field path | 39 | 208.14 ± 0.1% | 208.37 ± 0.3% | 247.72 ± 0.4% | 80.94 ± 1.6% | 205.42 ± 0.6% | 490.46 ± 1.2% | 4764.60 ± 0.3% | 207.92 ± 0.4% | 1.00 | 1.00 | 2.57 | 1.01 |
| literal: a word | 7 | 570.41 ± 0.3% | 610.68 ± 0.3% | 1120.25 ± 0.3% | 519.97 ± 0.1% | 635.28 ± 2.3% | 937.50 ± 0.6% | 30987.56 ± 0.2% | 570.69 ± 0.3% | 0.93 | 1.00 | 1.10 | 0.90 |
| literal: a word that is not there | 8 | 553.37 ± 0.7% | 595.53 ± 0.4% | 1080.51 ± 0.6% | 467.16 ± 0.2% | 604.46 ± 2.3% | 895.34 ± 0.3% | 29471.23 ± 0.1% | 553.40 ± 0.3% | 0.93 | 1.00 | 1.18 | 0.92 |
| literal: one of four words | 26 | 232.15 ± 0.4% | 372.31 ± 0.3% | 521.18 ± 0.5% | 49.64 ± 1.1% | 241.88 ± 1.9% | 354.75 ± 0.5% | 15741.10 ± 0.3% | 232.05 ± 0.3% | 0.62 | 1.00 | 4.68 | 0.96 |
| literal: a word in any case | 11 | 419.04 ± 0.2% | 447.04 ± 0.2% | 677.14 ± 0.3% | 15.68 ± 0.2% | 645.30 ± 3.0% | refused | 23694.16 ± 0.7% | 419.03 ± 0.3% | 0.94 | 1.00 | 26.73 | 0.65 |
| literal: an href attribute | 12 | 319.49 ± 0.4% | 331.16 ± 0.1% | 442.49 ± 0.1% | 45.53 ± 0.9% | 498.11 ± 3.7% | 777.41 ± 0.5% | 22336.36 ± 0.3% | 319.70 ± 0.1% | 0.96 | 1.00 | 7.02 | 0.64 |
| literal: a word, second text | 10 | 513.77 ± 0.3% | 560.38 ± 0.3% | 965.83 ± 0.1% | 415.11 ± 0.4% | 535.68 ± 3.1% | 805.88 ± 0.5% | 27504.79 ± 0.1% | 513.91 ± 0.3% | 0.92 | 1.00 | 1.24 | 0.96 |
| class: two capitalized words | 23 | 408.55 ± 0.5% | 439.79 ± 0.5% | 656.00 ± 0.4% | 101.73 ± 0.3% | 505.93 ± 1.1% | 755.17 ± 1.4% | 6319.39 ± 0.2% | 408.68 ± 0.2% | 0.93 | 1.00 | 4.02 | 0.81 |
| class: a word that ends in ing | 9 | 506.46 ± 0.5% | 573.84 ± 0.3% | 1049.49 ± 3.0% | 133.12 ± 0.3% | 760.55 ± 1.2% | 1098.25 ± 2.5% | 15861.88 ± 0.2% | 506.26 ± 0.2% | 0.88 | 1.00 | 3.80 | 0.67 |
| class: a word in capitals | 16 | 453.72 ± 0.2% | 493.09 ± 0.4% | 820.54 ± 0.1% | 135.23 ± 1.3% | 756.84 ± 0.9% | 1006.09 ± 0.9% | 8329.41 ± 0.2% | 454.25 ± 0.4% | 0.92 | 1.00 | 3.36 | 0.60 |
| class: a number | 6 | 568.81 ± 0.5% | 630.69 ± 0.4% | 1239.56 ± 0.1% | 42.34 ± 0.5% | 1405.99 ± 4.3% | 1843.25 ± 1.2% | 22916.98 ± 0.2% | 569.34 ± 0.2% | 0.90 | 1.00 | 13.43 | 0.40 |
| class: two capitalized words, second text | 23 | 408.80 ± 0.3% | 440.22 ± 0.4% | 655.78 ± 0.4% | 102.73 ± 0.9% | 504.51 ± 1.4% | 762.08 ± 0.8% | 6313.99 ± 0.4% | 408.17 ± 0.2% | 0.93 | 1.00 | 3.98 | 0.81 |
| other: a word between two words | 13 | 502.96 ± 0.3% | 520.72 ± 0.3% | 860.25 ± 0.5% | 133.95 ± 0.3% | 505.03 ± 1.5% | 802.32 ± 0.5% | 14722.50 ± 0.3% | 502.32 ± 0.6% | 0.97 | 1.00 | 3.75 | 1.00 |
| other: a number before a unit, second text | 15 | 360.87 ± 0.2% | 399.82 ± 0.2% | 574.13 ± 0.1% | 39.82 ± 0.5% | 634.69 ± 0.7% | 885.96 ± 0.6% | 15299.84 ± 0.2% | 361.33 ± 0.1% | 0.90 | 1.00 | 9.06 | 0.57 |
| other: a heading's start tag | 13 | 330.52 ± 0.3% | 336.96 ± 0.2% | 452.32 ± 0.1% | 44.33 ± 0.1% | 632.46 ± 0.7% | 862.69 ± 0.5% | 18397.85 ± 0.3% | 330.45 ± 0.2% | 0.98 | 1.00 | 7.46 | 0.52 |
| other: a whole word | 11 | 529.40 ± 1.5% | 565.41 ± 1.4% | 984.94 ± 1.8% | 121.27 ± 0.2% | 565.50 ± 4.6% | 826.98 ± 0.3% | 27203.07 ± 0.3% | 530.96 ± 0.7% | 0.94 | 1.00 | 4.37 | 0.94 |
| other: a line's first word, second text | 17 | 479.26 ± 0.6% | 511.61 ± 0.2% | 855.29 ± 0.2% | 128.62 ± 0.3% | 712.35 ± 2.4% | refused | refused | 480.13 ± 0.8% | 0.94 | 1.00 | 3.73 | 0.67 |
| other: fourteen octets before an x | 16 | 106.08 ± 0.6% | 150.93 ± 1.1% | 177.14 ± 0.4% | 15.27 ± 0.3% | 454.33 ± 1.1% | 416.81 ± 0.9% | 12954.20 ± 0.4% | 105.94 ± 0.4% | 0.70 | 1.00 | 6.95 | 0.23 |
| other: a Greek word | 8 | 402.12 ± 0.4% | 540.35 ± 0.5% | 939.40 ± 0.6% | 59.10 ± 0.7% | 1386.45 ± 2.0% | 1785.24 ± 0.5% | refused | 402.42 ± 0.2% | 0.74 | 1.00 | 6.80 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15791.14 ± 1.0% | not timed | not timed | 16284.82 ± 0.7% | 2109.49 ± 25.8% | not timed | not timed | 15665.87 ± 1.7% | | 1.01 | 0.97 | 7.49 |
| 01-literal/sherlock-casei-en | 522 | 10948.05 ± 7.6% | not timed | not timed | 3602.54 ± 0.1% | 32.43 ± 4.7% | not timed | not timed | 10981.52 ± 2.2% | | 1.00 | 3.04 | 337.64 |
| 01-literal/sherlock-ru | 724 | 17087.94 ± 1.0% | not timed | not timed | 17350.78 ± 0.3% | 1541.93 ± 21.1% | not timed | not timed | 17142.25 ± 0.3% | | 1.00 | 0.98 | 11.08 |
| 01-literal/sherlock-casei-ru | 746 | 6124.58 ± 0.3% | not timed | not timed | 3336.57 ± 0.2% | 31.65 ± 0.2% | not timed | not timed | 6137.36 ± 0.2% | | 1.00 | 1.84 | 193.53 |
| 01-literal/sherlock-zh | 30 | 19761.51 ± 0.7% | not timed | not timed | 18715.60 ± 0.4% | 2615.91 ± 12.6% | not timed | not timed | 19765.94 ± 0.6% | | 1.00 | 1.06 | 7.55 |
| 02-literal-alternate/sherlock-en | 714 | 6155.76 ± 0.2% | not timed | not timed | 3941.24 ± 0.1% | 16.58 ± 0.3% | not timed | not timed | 6153.64 ± 0.2% | | 1.00 | 1.56 | 371.28 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1966.79 ± 1.3% | not timed | not timed | 697.36 ± 0.3% | 11.04 ± 0.2% | not timed | not timed | 1972.75 ± 0.8% | | 1.00 | 2.82 | 178.20 |
| 02-literal-alternate/sherlock-ru | 899 | 5507.11 ± 0.1% | not timed | not timed | 3249.75 ± 0.1% | 22.66 ± 0.3% | not timed | not timed | 5500.85 ± 0.1% | | 1.00 | 1.69 | 243.03 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2047.68 ± 0.8% | not timed | not timed | 1223.99 ± 0.2% | 9.15 ± 0.1% | not timed | not timed | 2051.52 ± 0.5% | | 1.00 | 1.67 | 223.87 |
| 02-literal-alternate/sherlock-zh | 207 | 7299.18 ± 0.5% | not timed | not timed | 4165.13 ± 0.3% | 31.53 ± 0.3% | not timed | not timed | 7306.56 ± 0.5% | | 1.00 | 1.75 | 231.50 |
| 03-date/ascii | 111817 | 133.78 ± 0.6% | not timed | not timed | 96.52 ± 0.1% | 0.20 ± 3.8% | not timed | not timed | 134.69 ± 0.6% | | 0.99 | 1.39 | 661.37 |
| 04-ruff-noqa/real | 84 | 438.54 ± 0.4% | not timed | not timed | 469.59 ± 0.2% | 19.44 ± 1.3% | not timed | not timed | 436.90 ± 0.1% | | 1.00 | 0.93 | 22.56 |
| 04-ruff-noqa/tweaked | 44 | 848.00 ± 0.4% | not timed | not timed | 468.83 ± 0.1% | 364.23 ± 0.3% | not timed | not timed | 846.76 ± 0.1% | | 1.00 | 1.81 | 2.33 |
| 05-lexer-veryl/single | 124800 | 5.43 ± 3.6% | not timed | not timed | 5.23 ± 0.2% | 0.21 ± 4.1% | not timed | not timed | 5.59 ± 0.2% | | 0.97 | 1.04 | 26.45 |
| 06-cloud-flare-redos/original | 107 | 439.08 ± 0.2% | not timed | not timed | 216.09 ± 0.1% | 24.94 ± 0.1% | not timed | not timed | 439.39 ± 0.2% | | 1.00 | 2.03 | 17.61 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.37 ± 0.1% | not timed | not timed | 228.26 ± 0.1% | 26.66 ± 0.0% | not timed | not timed | 438.46 ± 0.2% | | 1.00 | 1.92 | 16.44 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.87 ± 0.1% | not timed | not timed | 256.19 ± 0.1% | 28.81 ± 0.3% | not timed | not timed | 629.28 ± 0.2% | | 1.00 | 2.45 | 21.83 |
| 07-unicode-character-data/parse-line | 558784 | 235.44 ± 3.3% | not timed | not timed | 180.06 ± 0.2% | 43.16 ± 5.3% | not timed | not timed | 236.82 ± 0.8% | | 0.99 | 1.31 | 5.45 |
| 08-words/all-english | 56691 | 128.76 ± 0.5% | not timed | not timed | 83.34 ± 0.1% | 12.06 ± 9.4% | not timed | not timed | 128.97 ± 0.4% | | 1.00 | 1.55 | 10.68 |
| 08-words/long-english | 839 | 616.01 ± 0.7% | not timed | not timed | 595.12 ± 0.1% | 32.49 ± 0.8% | not timed | not timed | 616.94 ± 0.6% | | 1.00 | 1.04 | 18.96 |
| 09-aws-keys/full | 0 | 442.71 ± 0.3% | not timed | not timed | 493.94 ± 0.2% | 64.10 ± 3.5% | not timed | not timed | 443.39 ± 0.2% | | 1.00 | 0.90 | 6.91 |
| 09-aws-keys/quick | 0 | 872.76 ± 0.1% | not timed | not timed | 997.31 ± 0.6% | 419.66 ± 1.0% | not timed | not timed | 872.36 ± 0.2% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 583.71 ± 2.1% | not timed | not timed | 517.43 ± 0.3% | 19.49 ± 0.2% | not timed | not timed | 577.43 ± 2.9% | | 1.01 | 1.13 | 29.95 |
| 10-bounded-repeat/letters-ru | 3475 | 504.84 ± 1.0% | not timed | not timed | 478.55 ± 0.2% | 21.60 ± 7.8% | not timed | not timed | 506.35 ± 1.2% | | 1.00 | 1.05 | 23.37 |
| 10-bounded-repeat/context | 53 | 84.86 ± 1.8% | not timed | not timed | 66.22 ± 0.4% | 19.80 ± 0.2% | not timed | not timed | 84.93 ± 1.2% | | 1.00 | 1.28 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 636.37 ± 8.2% | not timed | not timed | 615.54 ± 0.1% | 36.61 ± 0.1% | not timed | not timed | 638.77 ± 8.4% | | 1.00 | 1.03 | 17.38 |
| 11-unstructured-to-json/extract | 600 | 57.86 ± 0.1% | not timed | not timed | 76.70 ± 0.4% | 48.97 ± 0.2% | not timed | not timed | 57.63 ± 0.3% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 560.01 ± 1.5% | not timed | not timed | 554.14 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 561.49 ± 1.7% | | 1.00 | 1.01 | 1391.17 |
| 14-quadratic/1x | 100 | 21.37 ± 0.8% | not timed | not timed | 10.01 ± 0.8% | 0.98 ± 3.6% | not timed | not timed | 21.45 ± 1.8% | | 1.00 | 2.14 | 21.91 |
| 14-quadratic/2x | 200 | 19.75 ± 0.9% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 0.4% | not timed | not timed | 19.84 ± 0.4% | | 1.00 | 3.57 | 37.13 |
| 14-quadratic/10x | 1000 | 12.32 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.3% | not timed | not timed | 12.35 ± 0.5% | | 1.00 | 10.15 | 107.13 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 0.6% | not timed | not timed | 0.35 ± 0.4% | 0.56 ± 4.5% | not timed | not timed | 1.22 ± 1.8% | | 1.00 | 3.53 | 2.19 |
| 04-ruff-noqa/compile-real | 1 | 102.64 ± 0.9% | not timed | not timed | 13.82 ± 0.8% | 139.65 ± 1.9% | not timed | not timed | 103.21 ± 1.7% | | 0.99 | 7.43 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 14.00 ± 1.0% | not timed | not timed | 2.53 ± 0.7% | 6.47 ± 1.2% | not timed | not timed | 14.01 ± 1.6% | | 1.00 | 5.53 | 2.16 |
| 07-unicode-character-data/compile | 1 | 107.13 ± 1.3% | not timed | not timed | 25.77 ± 0.2% | 36.52 ± 2.7% | not timed | not timed | 107.57 ± 2.5% | | 1.00 | 4.16 | 2.93 |
| 09-aws-keys/compile-full | 1 | 52.42 ± 0.3% | not timed | not timed | 8.24 ± 0.6% | 23.43 ± 1.5% | not timed | not timed | 52.59 ± 0.6% | | 1.00 | 6.36 | 2.24 |
| 09-aws-keys/compile-quick | 1 | 180.45 ± 0.4% | not timed | not timed | 47.22 ± 0.4% | 134.86 ± 2.6% | not timed | not timed | 182.49 ± 0.6% | | 0.99 | 3.82 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 70.63 ± 0.7% | not timed | not timed | 11.11 ± 0.2% | 16.25 ± 1.1% | not timed | not timed | 71.13 ± 2.0% | | 0.99 | 6.36 | 4.35 |
| 10-bounded-repeat/compile-capitals | 1 | 83.87 ± 0.8% | not timed | not timed | 8.06 ± 0.3% | 24.04 ± 1.9% | not timed | not timed | 84.34 ± 1.5% | | 0.99 | 10.41 | 3.49 |
| 11-unstructured-to-json/compile | 1 | 168.21 ± 1.0% | not timed | not timed | 40.74 ± 0.6% | 68.53 ± 2.0% | not timed | not timed | 170.34 ± 0.9% | | 0.99 | 4.13 | 2.45 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.6% | not timed | not timed | 0.07 ± 0.9% | 0.10 ± 16.0% | not timed | not timed | 0.35 ± 1.0% | | 1.00 | 5.07 | 3.57 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.56 ± 0.3% | not timed | not timed | 6.59 ± 0.2% | 0.53 ± 16.6% | not timed | not timed | 7.54 ± 2.3% | | 1.00 | 1.15 | 14.25 |
| dictionary/search/english-10 | 690 | 206.52 ± 2.5% | not timed | not timed | 166.02 ± 0.9% | 0.00 ± 0.6% | not timed | not timed | 197.07 ± 4.9% | | 1.05 | 1.24 | 73936.74 |
| dictionary/search/english-15 | 15 | 558.66 ± 1.9% | not timed | not timed | 553.60 ± 0.3% | 0.37 ± 0.3% | not timed | not timed | 560.25 ± 1.3% | | 1.00 | 1.01 | 1522.24 |
| folly/awyer-inn-busted | 1 | 21500.60 ± 0.1% | not timed | not timed | 143.79 ± 0.1% | 43.86 ± 0.3% | not timed | not timed | 21565.17 ± 0.1% | | 1.00 | 149.53 | 490.17 |
| folly/literal-never-match-rare | 0 | 21138.98 ± 0.7% | not timed | not timed | 19945.18 ± 0.3% | 40958.13 ± 0.3% | not timed | not timed | 21150.50 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12563.22 ± 0.7% | not timed | not timed | 19860.53 ± 0.2% | 2195.56 ± 0.7% | not timed | not timed | 12537.68 ± 0.6% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3259.41 ± 0.3% | not timed | not timed | 4413.17 ± 0.2% | 2898.33 ± 7.5% | not timed | not timed | 3255.07 ± 0.7% | | 1.00 | 0.74 | 1.12 |
| grep/every-line | 239963 | 1301.23 ± 0.4% | not timed | not timed | 961.27 ± 0.4% | 372.71 ± 18.1% | not timed | not timed | 1306.54 ± 0.5% | | 1.00 | 1.35 | 3.49 |
| grep/long-words-ascii | 5073 | 459.46 ± 0.2% | not timed | not timed | 469.97 ± 0.3% | 46.08 ± 7.8% | not timed | not timed | 459.21 ± 0.2% | | 1.00 | 0.98 | 9.97 |
| imported/leipzig/twain | 811 | 20720.72 ± 1.2% | not timed | not timed | 19619.21 ± 0.3% | 11696.65 ± 10.1% | not timed | not timed | 20782.09 ± 0.4% | | 1.00 | 1.06 | 1.77 |
| imported/leipzig/twain-insensitive | 965 | 9025.04 ± 2.1% | not timed | not timed | 4248.43 ± 0.1% | 37.72 ± 0.3% | not timed | not timed | 9128.14 ± 2.0% | | 0.99 | 2.12 | 239.27 |
| imported/leipzig/shing | 1540 | 15222.88 ± 2.6% | not timed | not timed | 13552.99 ± 0.2% | 34.00 ± 0.1% | not timed | not timed | 15538.54 ± 3.2% | | 0.98 | 1.12 | 447.72 |
| imported/leipzig/huck-saw | 262 | 8229.99 ± 3.1% | not timed | not timed | 5600.39 ± 0.0% | 31.67 ± 0.0% | not timed | not timed | 8463.88 ± 4.2% | | 0.97 | 1.47 | 259.83 |
| imported/leipzig/word-ending-nn | 262 | 602.76 ± 0.9% | not timed | not timed | 615.04 ± 0.3% | 24.73 ± 1.0% | not timed | not timed | 602.71 ± 0.5% | | 1.00 | 0.98 | 24.37 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11228.37 ± 0.9% | not timed | not timed | 4550.46 ± 0.4% | 11.50 ± 0.1% | not timed | not timed | 11284.96 ± 1.0% | | 0.99 | 2.47 | 976.57 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7742.20 ± 3.2% | not timed | not timed | 5483.74 ± 0.2% | 16.88 ± 0.2% | not timed | not timed | 7945.45 ± 3.0% | | 0.97 | 1.41 | 458.70 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4162.87 ± 1.2% | not timed | not timed | 421.58 ± 1.6% | 11.07 ± 0.1% | not timed | not timed | 4185.18 ± 1.2% | | 0.99 | 9.87 | 375.96 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7268.85 ± 4.1% | not timed | not timed | 615.11 ± 0.1% | 11.13 ± 0.2% | not timed | not timed | 7445.68 ± 2.4% | | 0.98 | 11.82 | 652.84 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7090.31 ± 4.3% | not timed | not timed | 614.96 ± 0.2% | 9.74 ± 0.1% | not timed | not timed | 7282.57 ± 4.1% | | 0.97 | 11.53 | 728.30 |
| imported/leipzig/tom-river | 2 | 6463.81 ± 2.4% | not timed | not timed | 5148.96 ± 0.3% | 30.97 ± 0.1% | not timed | not timed | 6592.83 ± 3.2% | | 0.98 | 1.26 | 208.69 |
| imported/leipzig/ing | 78424 | 602.98 ± 0.9% | not timed | not timed | 572.56 ± 0.1% | 28.13 ± 3.2% | not timed | not timed | 601.76 ± 1.0% | | 1.00 | 1.05 | 21.44 |
| imported/leipzig/ing-whitespace | 55248 | 1924.62 ± 2.0% | not timed | not timed | 2088.48 ± 0.2% | 20.52 ± 2.9% | not timed | not timed | 1934.30 ± 1.8% | | 0.99 | 0.92 | 93.77 |
| imported/leipzig/awyer-inn | 209 | 6360.23 ± 1.9% | not timed | not timed | 4280.48 ± 0.1% | 22.51 ± 0.1% | not timed | not timed | 6440.29 ± 1.4% | | 0.99 | 1.49 | 282.54 |
| imported/leipzig/quotes-bounded | 8886 | 2479.71 ± 1.4% | not timed | not timed | 3008.94 ± 0.7% | 38.22 ± 0.1% | not timed | not timed | 2499.05 ± 1.8% | | 0.99 | 0.82 | 64.88 |
| imported/leipzig/non-ascii-alternate | 2 | 12776.67 ± 3.1% | not timed | not timed | 5667.30 ± 0.1% | 50.58 ± 0.1% | not timed | not timed | 13069.19 ± 3.0% | | 0.98 | 2.25 | 252.59 |
| imported/leipzig/math-symbols | 69 | 1980.38 ± 0.3% | not timed | not timed | 614.47 ± 0.2% | 36.48 ± 0.1% | not timed | not timed | 1981.50 ± 1.1% | | 1.00 | 3.22 | 54.29 |
| imported/leipzig/bounded-strings-ending-z | 0 | 629.15 ± 2.0% | not timed | not timed | 616.32 ± 0.2% | 22.42 ± 0.2% | not timed | not timed | 630.62 ± 1.3% | | 1.00 | 1.02 | 28.06 |
| imported/lh3lh3-reb/uri | 17549 | 677.41 ± 0.2% | not timed | not timed | 1081.48 ± 0.2% | 28.25 ± 2.2% | not timed | not timed | 681.06 ± 0.2% | | 0.99 | 0.63 | 23.98 |
| imported/lh3lh3-reb/email | 15057 | 675.05 ± 0.1% | not timed | not timed | 1163.65 ± 0.3% | 30.73 ± 0.9% | not timed | not timed | 676.94 ± 0.3% | | 1.00 | 0.58 | 21.97 |
| imported/lh3lh3-reb/date | 668 | 891.59 ± 0.2% | not timed | not timed | 1039.63 ± 0.3% | 51.01 ± 3.9% | not timed | not timed | 890.74 ± 0.2% | | 1.00 | 0.86 | 17.48 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.39 ± 0.2% | not timed | not timed | 417.97 ± 0.4% | 15.75 ± 1.2% | not timed | not timed | 647.33 ± 0.5% | | 1.00 | 1.54 | 40.98 |
| imported/mariomka/email | 92 | 24143.44 ± 1.6% | not timed | not timed | 29460.86 ± 0.4% | 32.81 ± 0.2% | not timed | not timed | 24496.37 ± 1.6% | | 0.99 | 0.82 | 735.88 |
| imported/mariomka/uri | 5301 | 5539.68 ± 0.8% | not timed | not timed | 6111.21 ± 0.2% | 32.74 ± 0.3% | not timed | not timed | 5589.35 ± 1.1% | | 0.99 | 0.91 | 169.18 |
| imported/mariomka/ip | 5 | 2597.71 ± 2.9% | not timed | not timed | 2948.09 ± 0.2% | 21.04 ± 0.2% | not timed | not timed | 2606.76 ± 3.4% | | 1.00 | 0.88 | 123.46 |
| imported/rsc/no-exponential | 0 | 610.56 ± 0.1% | not timed | not timed | 319.74 ± 0.1% | 23.79 ± 0.1% | not timed | not timed | 611.22 ± 0.1% | | 1.00 | 1.91 | 25.67 |
| imported/rsc/literal | 1 | 1546.32 ± 6.4% | not timed | not timed | 1535.22 ± 7.8% | 192.03 ± 20.1% | not timed | not timed | 1538.71 ± 8.6% | | 1.00 | 1.01 | 8.05 |
| imported/rsc/not-literal | 2 | 775.82 ± 1.9% | not timed | not timed | 735.18 ± 0.2% | 46.36 ± 9.8% | not timed | not timed | 778.77 ± 0.3% | | 1.00 | 1.06 | 16.73 |
| imported/rsc/match-class | 1 | 1471.97 ± 2.6% | not timed | not timed | 1647.10 ± 0.2% | 58.84 ± 7.1% | not timed | not timed | 1478.21 ± 0.5% | | 1.00 | 0.89 | 25.02 |
| imported/rsc/match-class-in-range | 1 | 1472.05 ± 0.6% | not timed | not timed | 2306.13 ± 6.0% | 60.00 ± 2.3% | not timed | not timed | 1472.24 ± 8.9% | | 1.00 | 0.64 | 24.53 |
| imported/rsc/match-class-unicode | 1 | 541.64 ± 0.3% | not timed | not timed | 511.87 ± 0.2% | 72.33 ± 2.7% | not timed | not timed | 540.55 ± 0.4% | | 1.00 | 1.06 | 7.49 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1459.14 ± 0.2% | not timed | not timed | 949.29 ± 0.1% | 229.33 ± 0.6% | not timed | not timed | 1453.96 ± 0.2% | | 1.00 | 1.54 | 6.36 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21866.72 ± 0.4% | not timed | not timed | 14229.20 ± 0.2% | 3447.74 ± 0.9% | not timed | not timed | 21762.08 ± 0.4% | | 1.00 | 1.54 | 6.34 |
| imported/rsc/anchored-literal-short-match | 4 | 710.08 ± 2.5% | not timed | not timed | 497.29 ± 0.4% | 82.16 ± 11.7% | not timed | not timed | 723.69 ± 2.4% | | 0.98 | 1.43 | 8.64 |
| imported/rsc/anchored-literal-long-match | 4 | 10906.31 ± 1.7% | not timed | not timed | 7423.39 ± 0.5% | 1255.29 ± 6.0% | not timed | not timed | 10849.05 ± 2.5% | | 1.01 | 1.47 | 8.69 |
| imported/rsc/one-pass-short | 17 | 368.16 ± 10.0% | not timed | not timed | 217.65 ± 0.1% | 29.82 ± 11.0% | not timed | not timed | 358.91 ± 3.1% | | 1.03 | 1.69 | 12.35 |
| imported/rsc/one-pass-short-not | 17 | 267.56 ± 1.8% | not timed | not timed | 224.00 ± 0.2% | 32.28 ± 12.4% | not timed | not timed | 266.80 ± 2.1% | | 1.00 | 1.19 | 8.29 |
| imported/rsc/one-pass-long-prefix | 26 | 358.27 ± 1.9% | not timed | not timed | 284.77 ± 0.4% | 96.89 ± 13.9% | not timed | not timed | 359.88 ± 0.8% | | 1.00 | 1.26 | 3.70 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.24 ± 2.1% | not timed | not timed | 279.00 ± 0.3% | 64.94 ± 15.2% | not timed | not timed | 361.42 ± 6.6% | | 0.99 | 1.29 | 5.53 |
| imported/rsc/long-needle1 | 31 | 21980.80 ± 0.3% | not timed | not timed | 20148.66 ± 0.2% | 3.75 ± 0.1% | not timed | not timed | 21977.66 ± 0.2% | | 1.00 | 1.09 | 5865.73 |
| imported/rsc/long-needle2 | 31 | 22076.07 ± 0.2% | not timed | not timed | 216.09 ± 0.7% | 3.75 ± 0.2% | not timed | not timed | 22096.79 ± 0.1% | | 1.00 | 102.16 | 5892.95 |
| imported/rsc/easy0-32 | 26 | 1589.39 ± 1.7% | not timed | not timed | 1561.30 ± 5.6% | 145.80 ± 15.1% | not timed | not timed | 1585.72 ± 0.9% | | 1.00 | 1.02 | 10.90 |
| imported/rsc/easy0-1k | 26 | 13601.45 ± 1.8% | not timed | not timed | 12541.41 ± 1.5% | 2317.19 ± 12.3% | not timed | not timed | 13637.17 ± 0.8% | | 1.00 | 1.08 | 5.87 |
| imported/rsc/easy0-32k | 26 | 22750.12 ± 0.1% | not timed | not timed | 20295.81 ± 0.2% | 18789.06 ± 0.3% | not timed | not timed | 22750.85 ± 0.0% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21742.96 ± 2.7% | not timed | not timed | 19711.90 ± 2.7% | 36795.56 ± 5.4% | not timed | not timed | 21444.60 ± 2.1% | | 1.01 | 1.10 | 0.59 |
| imported/rsc/easy1-32 | 19 | 763.68 ± 2.4% | not timed | not timed | 626.24 ± 0.3% | 122.59 ± 13.9% | not timed | not timed | 763.85 ± 4.3% | | 1.00 | 1.22 | 6.23 |
| imported/rsc/easy1-1k | 19 | 15666.60 ± 2.4% | not timed | not timed | 12677.63 ± 0.1% | 2485.44 ± 15.1% | not timed | not timed | 15649.60 ± 0.3% | | 1.00 | 1.24 | 6.30 |
| imported/rsc/easy1-32k | 19 | 492045.62 ± 0.3% | not timed | not timed | 408134.07 ± 0.3% | 20292.25 ± 0.1% | not timed | not timed | 490966.94 ± 0.1% | | 1.00 | 1.21 | 24.25 |
| imported/rsc/easy1-1mb | 19 | 15821878.11 ± 0.3% | not timed | not timed | 13273652.79 ± 0.2% | 38737.05 ± 2.7% | not timed | not timed | 15755569.84 ± 0.3% | | 1.00 | 1.19 | 408.44 |
| imported/rsc/medium-32 | 27 | 730.78 ± 1.9% | not timed | not timed | 627.83 ± 0.1% | 69.69 ± 11.5% | not timed | not timed | 732.88 ± 0.2% | | 1.00 | 1.16 | 10.49 |
| imported/rsc/medium-1k | 27 | 13032.91 ± 0.2% | not timed | not timed | 11291.71 ± 0.3% | 72.33 ± 0.1% | not timed | not timed | 13014.68 ± 0.2% | | 1.00 | 1.15 | 180.17 |
| imported/rsc/medium-32k | 27 | 406584.71 ± 0.3% | not timed | not timed | 345364.49 ± 0.1% | 48.78 ± 0.2% | not timed | not timed | 405456.26 ± 0.2% | | 1.00 | 1.18 | 8335.12 |
| imported/rsc/medium-1mb | 27 | 13003370.10 ± 0.4% | not timed | not timed | 11242858.62 ± 0.3% | 48.78 ± 0.2% | not timed | not timed | 12995145.43 ± 0.2% | | 1.00 | 1.16 | 266554.46 |
| imported/rsc/hard-32 | 58 | 422.73 ± 1.9% | not timed | not timed | 364.07 ± 0.2% | 49.53 ± 8.7% | not timed | not timed | 422.32 ± 0.2% | | 1.00 | 1.16 | 8.53 |
| imported/rsc/hard-1k | 27 | 12884.75 ± 0.2% | not timed | not timed | 11664.23 ± 0.4% | 40.47 ± 0.1% | not timed | not timed | 12831.57 ± 0.2% | | 1.00 | 1.10 | 318.36 |
| imported/rsc/hard-32k | 27 | 399905.80 ± 0.3% | not timed | not timed | 362265.08 ± 0.3% | 29.41 ± 0.1% | not timed | not timed | 400368.96 ± 0.4% | | 1.00 | 1.10 | 13597.68 |
| imported/rsc/hard-1mb | 51 | 8371618.36 ± 0.1% | not timed | not timed | 7274323.20 ± 0.2% | 29.36 ± 0.1% | not timed | not timed | 8374387.86 ± 0.3% | | 1.00 | 1.15 | 285135.05 |
| imported/rsc/reallyhard0-32 | 58 | 263.29 ± 2.6% | not timed | not timed | 223.81 ± 0.1% | 49.63 ± 8.8% | not timed | not timed | 262.74 ± 0.4% | | 1.00 | 1.18 | 5.30 |
| imported/rsc/reallyhard0-1k | 27 | 580.33 ± 0.3% | not timed | not timed | 583.16 ± 0.3% | 40.58 ± 0.1% | not timed | not timed | 581.09 ± 0.3% | | 1.00 | 1.00 | 14.30 |
| imported/rsc/reallyhard0-32k | 27 | 603.65 ± 0.4% | not timed | not timed | 617.53 ± 0.1% | 29.41 ± 0.1% | not timed | not timed | 601.88 ± 0.5% | | 1.00 | 0.98 | 20.53 |
| imported/rsc/reallyhard0-1mb | 51 | 624.63 ± 1.1% | not timed | not timed | 617.69 ± 0.2% | 29.33 ± 0.3% | not timed | not timed | 626.95 ± 1.3% | | 1.00 | 1.01 | 21.30 |
| imported/rsc/reallyreallyhard0-32 | 47 | 283.34 ± 1.7% | not timed | not timed | 197.21 ± 0.8% | 60.52 ± 15.6% | not timed | not timed | 286.06 ± 1.7% | | 0.99 | 1.44 | 4.68 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7052.18 ± 0.1% | not timed | not timed | 5953.71 ± 0.1% | 33.80 ± 2.9% | not timed | not timed | 7070.74 ± 0.1% | | 1.00 | 1.18 | 208.65 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21452.05 ± 0.2% | not timed | not timed | 19361.67 ± 0.1% | 25.06 ± 3.2% | not timed | not timed | 21456.11 ± 0.1% | | 1.00 | 1.11 | 856.01 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21177.62 ± 1.7% | not timed | not timed | 19437.97 ± 1.5% | 25.01 ± 0.2% | not timed | not timed | 21227.60 ± 2.7% | | 1.00 | 1.09 | 846.75 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 279.96 ± 2.0% | not timed | not timed | 213.74 ± 0.2% | 61.55 ± 12.0% | not timed | not timed | 281.97 ± 1.4% | | 0.99 | 1.31 | 4.55 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5937.61 ± 0.1% | not timed | not timed | 6195.85 ± 4.0% | 34.27 ± 1.4% | not timed | not timed | 5936.69 ± 0.1% | | 1.00 | 0.96 | 173.28 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21375.25 ± 0.0% | not timed | not timed | 19269.94 ± 0.0% | 25.11 ± 1.1% | not timed | not timed | 21379.64 ± 0.1% | | 1.00 | 1.11 | 851.22 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21123.71 ± 0.7% | not timed | not timed | 19620.49 ± 0.8% | 25.16 ± 0.3% | not timed | not timed | 21150.37 ± 1.1% | | 1.00 | 1.08 | 839.58 |
| imported/sherlock/name-sherlock | 776 | 19782.01 ± 6.9% | not timed | not timed | 18478.04 ± 0.4% | 10141.26 ± 15.9% | not timed | not timed | 19785.69 ± 2.2% | | 1.00 | 1.07 | 1.95 |
| imported/sherlock/name-holmes | 2766 | 15127.27 ± 1.7% | not timed | not timed | 15479.56 ± 0.4% | 3181.44 ± 14.7% | not timed | not timed | 15225.73 ± 1.4% | | 0.99 | 0.98 | 4.75 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19835.61 ± 2.1% | not timed | not timed | 18491.36 ± 0.6% | 8082.35 ± 39.4% | not timed | not timed | 19845.00 ± 2.2% | | 1.00 | 1.07 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15703.17 ± 0.3% | not timed | not timed | 4015.46 ± 0.1% | 32.46 ± 0.3% | not timed | not timed | 15708.77 ± 0.4% | | 1.00 | 3.91 | 483.71 |
| imported/sherlock/name-holmes-casei | 2802 | 9347.42 ± 6.5% | not timed | not timed | 3322.45 ± 0.2% | 37.33 ± 0.8% | not timed | not timed | 9312.78 ± 6.3% | | 1.00 | 2.81 | 250.42 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12815.65 ± 7.9% | not timed | not timed | 3944.74 ± 0.2% | 32.47 ± 0.7% | not timed | not timed | 12945.75 ± 1.7% | | 0.99 | 3.25 | 394.73 |
| imported/sherlock/name-whitespace | 1461 | 15262.56 ± 1.7% | not timed | not timed | 14419.58 ± 0.5% | 6597.69 ± 20.7% | not timed | not timed | 15341.19 ± 1.8% | | 0.99 | 1.06 | 2.31 |
| imported/sherlock/name-alt1 | 1142 | 11632.20 ± 0.3% | not timed | not timed | 15908.78 ± 0.9% | 4130.06 ± 22.2% | not timed | not timed | 11639.31 ± 2.7% | | 1.00 | 0.73 | 2.82 |
| imported/sherlock/name-alt2 | 3542 | 8943.11 ± 0.3% | not timed | not timed | 3824.08 ± 0.2% | 31.39 ± 0.6% | not timed | not timed | 8949.56 ± 0.3% | | 1.00 | 2.34 | 284.92 |
| imported/sherlock/name-alt3 | 4507 | 5548.32 ± 0.5% | not timed | not timed | 3630.99 ± 0.2% | 9.95 ± 0.3% | not timed | not timed | 5530.22 ± 0.5% | | 1.00 | 1.53 | 557.53 |
| imported/sherlock/name-alt3-casei | 4593 | 1522.87 ± 2.1% | not timed | not timed | 285.12 ± 0.3% | 6.44 ± 0.1% | not timed | not timed | 1526.01 ± 1.0% | | 1.00 | 5.34 | 236.35 |
| imported/sherlock/name-alt4 | 3686 | 6405.59 ± 0.3% | not timed | not timed | 3788.27 ± 0.2% | 31.37 ± 0.5% | not timed | not timed | 6393.95 ± 0.2% | | 1.00 | 1.69 | 204.22 |
| imported/sherlock/name-alt4-casei | 4254 | 2807.50 ± 2.4% | not timed | not timed | 2588.34 ± 0.1% | 19.82 ± 0.1% | not timed | not timed | 2806.85 ± 1.4% | | 1.00 | 1.08 | 141.66 |
| imported/sherlock/name-alt5 | 4028 | 6379.52 ± 0.3% | not timed | not timed | 3744.98 ± 0.2% | 21.87 ± 0.1% | not timed | not timed | 6380.74 ± 0.3% | | 1.00 | 1.70 | 291.73 |
| imported/sherlock/name-alt5-casei | 4104 | 3478.66 ± 1.5% | not timed | not timed | 2219.81 ± 0.2% | 14.33 ± 0.1% | not timed | not timed | 3483.84 ± 1.0% | | 1.00 | 1.57 | 242.82 |
| imported/sherlock/no-match-uncommon | 0 | 21632.13 ± 0.4% | not timed | not timed | 19470.32 ± 0.4% | 35434.23 ± 0.8% | not timed | not timed | 21638.31 ± 0.5% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21449.44 ± 0.2% | not timed | not timed | 19463.57 ± 0.9% | 1277.55 ± 0.5% | not timed | not timed | 21450.82 ± 0.7% | | 1.00 | 1.10 | 16.79 |
| imported/sherlock/no-match-really-common | 0 | 16054.86 ± 3.6% | not timed | not timed | 18698.00 ± 0.2% | 1280.82 ± 1.5% | not timed | not timed | 16145.76 ± 2.1% | | 0.99 | 0.86 | 12.53 |
| imported/sherlock/the-lower | 21654 | 2297.54 ± 0.8% | not timed | not timed | 2326.33 ± 0.6% | 233.85 ± 16.8% | not timed | not timed | 2301.88 ± 1.8% | | 1.00 | 0.99 | 9.82 |
| imported/sherlock/the-upper | 2223 | 12617.75 ± 1.6% | not timed | not timed | 13536.65 ± 0.6% | 2713.29 ± 3.2% | not timed | not timed | 12721.20 ± 1.0% | | 0.99 | 0.93 | 4.65 |
| imported/sherlock/the-casei | 23961 | 1991.30 ± 1.3% | not timed | not timed | 1316.69 ± 0.3% | 34.62 ± 38.2% | not timed | not timed | 1990.54 ± 0.4% | | 1.00 | 1.51 | 57.53 |
| imported/sherlock/everything-greedy | 581881 | 282.11 ± 8.3% | not timed | not timed | 165.67 ± 0.1% | 28.76 ± 12.9% | not timed | not timed | 282.26 ± 0.1% | | 1.00 | 1.70 | 9.81 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.01 ± 0.1% | not timed | not timed | 213.19 ± 0.5% | 32.97 ± 0.7% | not timed | not timed | 490.01 ± 0.1% | | 1.00 | 2.30 | 14.89 |
| imported/sherlock/letters | 447175 | 61.55 ± 0.8% | not timed | not timed | 32.98 ± 0.1% | 6.54 ± 30.0% | not timed | not timed | 61.63 ± 7.5% | | 1.00 | 1.87 | 9.41 |
| imported/sherlock/letters-upper | 14180 | 448.01 ± 3.4% | not timed | not timed | 370.31 ± 0.2% | 29.52 ± 21.0% | not timed | not timed | 446.22 ± 0.2% | | 1.00 | 1.21 | 15.18 |
| imported/sherlock/letters-lower | 432995 | 62.68 ± 1.1% | not timed | not timed | 33.94 ± 0.2% | 5.71 ± 10.3% | not timed | not timed | 62.92 ± 0.5% | | 1.00 | 1.85 | 10.98 |
| imported/sherlock/words | 447639 | 112.48 ± 1.7% | not timed | not timed | 83.29 ± 0.3% | 13.96 ± 4.9% | not timed | not timed | 113.18 ± 0.7% | | 0.99 | 1.35 | 8.06 |
| imported/sherlock/before-holmes | 4073 | 10258.62 ± 0.6% | not timed | not timed | 8425.69 ± 0.3% | 24.11 ± 1.0% | not timed | not timed | 10291.98 ± 0.4% | | 1.00 | 1.22 | 425.58 |
| imported/sherlock/before-after-holmes | 2593 | 9891.40 ± 0.7% | not timed | not timed | 9376.62 ± 0.4% | 23.77 ± 1.4% | not timed | not timed | 9949.97 ± 0.5% | | 0.99 | 1.05 | 416.08 |
| imported/sherlock/holmes-cochar-watson | 150 | 5188.34 ± 0.5% | not timed | not timed | 3423.34 ± 0.3% | 30.96 ± 0.1% | not timed | not timed | 5187.98 ± 0.3% | | 1.00 | 1.52 | 167.57 |
| imported/sherlock/holmes-coword-watson | 14309 | 1154.57 ± 0.4% | not timed | not timed | 1122.99 ± 0.1% | 6.71 ± 0.3% | not timed | not timed | 1153.58 ± 0.3% | | 1.00 | 1.03 | 172.02 |
| imported/sherlock/quotes | 14437 | 1572.04 ± 0.4% | not timed | not timed | 1753.65 ± 0.5% | 35.11 ± 0.3% | not timed | not timed | 1570.52 ± 0.4% | | 1.00 | 0.90 | 44.78 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17251.04 ± 0.5% | not timed | not timed | 15994.25 ± 0.6% | 36.79 ± 0.2% | not timed | not timed | 17344.00 ± 0.5% | | 0.99 | 1.08 | 468.85 |
| imported/sherlock/word-ending-n | 35297 | 480.05 ± 1.0% | not timed | not timed | 409.74 ± 0.1% | 23.52 ± 24.2% | not timed | not timed | 480.18 ± 0.4% | | 1.00 | 1.17 | 20.41 |
| imported/sherlock/repeated-class-negation | 2130 | 14795.92 ± 0.7% | not timed | not timed | 11020.42 ± 2.2% | 11.59 ± 0.2% | not timed | not timed | 14798.67 ± 0.9% | | 1.00 | 1.34 | 1276.97 |
| imported/sherlock/ing-suffix | 20547 | 558.89 ± 0.3% | not timed | not timed | 517.33 ± 0.2% | 28.95 ± 0.3% | not timed | not timed | 558.32 ± 0.3% | | 1.00 | 1.08 | 19.31 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1671.81 ± 0.4% | not timed | not timed | 2112.52 ± 0.3% | 20.57 ± 0.1% | not timed | not timed | 1675.05 ± 0.2% | | 1.00 | 0.79 | 81.28 |
| opt/accelerate/whole-line | 239963 | 458.12 ± 0.1% | not timed | not timed | 373.69 ± 0.5% | 92.16 ± 14.8% | not timed | not timed | 457.40 ± 0.4% | | 1.00 | 1.23 | 4.97 |
| opt/accelerate/non-dna | 16745 | 430.71 ± 0.7% | not timed | not timed | 398.74 ± 0.1% | 29.50 ± 24.4% | not timed | not timed | 430.84 ± 0.2% | | 1.00 | 1.08 | 14.60 |
| opt/backtrack/words-english | 40536 | 141.51 ± 0.3% | not timed | not timed | 94.28 ± 0.1% | 19.59 ± 8.4% | not timed | not timed | 141.57 ± 2.1% | | 1.00 | 1.50 | 7.22 |
| opt/fixed-length/too-small-ascii | 0 | 316.06 ± 0.4% | not timed | not timed | 689.09 ± 3.2% | 80.54 ± 3.0% | not timed | not timed | 318.01 ± 0.4% | | 0.99 | 0.46 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3352.39 ± 0.1% | not timed | not timed | 5876.55 ± 1.2% | 124.68 ± 0.1% | not timed | not timed | 3337.69 ± 0.1% | | 1.00 | 0.57 | 26.89 |
| opt/fixed-length/go33484-1 | 0 | 644719.61 ± 0.2% | not timed | not timed | 1114913.27 ± 0.3% | 61601.11 ± 0.3% | not timed | not timed | 641187.00 ± 0.1% | | 1.01 | 0.58 | 10.47 |
| opt/fixed-length/go33484-2 | 0 | 644867.73 ± 0.2% | not timed | not timed | 1113551.11 ± 0.4% | 32227.16 ± 2.6% | not timed | not timed | 641098.64 ± 0.1% | | 1.01 | 0.58 | 20.01 |
| opt/fixed-length/go33484-3 | 0 | 64485.26 ± 0.7% | not timed | not timed | 112294.84 ± 0.9% | 767.09 ± 0.3% | not timed | not timed | 64105.19 ± 0.5% | | 1.01 | 0.57 | 84.07 |
| opt/literal-alt/one-pattern | 1 | 527.20 ± 3.2% | not timed | not timed | 543.10 ± 0.2% | 0.40 ± 0.3% | not timed | not timed | 547.31 ± 1.5% | | 0.96 | 0.97 | 1334.59 |
| opt/onepass/fn-predicate | 916 | 365.95 ± 0.6% | not timed | not timed | 335.63 ± 0.1% | 199.11 ± 15.7% | not timed | not timed | 367.60 ± 0.6% | | 1.00 | 1.09 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 179.31 ± 12.6% | not timed | not timed | 201.08 ± 0.2% | 80.87 ± 10.8% | not timed | not timed | 181.84 ± 8.1% | | 0.99 | 0.89 | 2.22 |
| opt/prefilter/literal-english | 1 | 20486.68 ± 0.2% | not timed | not timed | 19751.25 ± 0.5% | 17490.63 ± 0.4% | not timed | not timed | 20510.26 ± 0.3% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14475.40 ± 1.1% | not timed | not timed | 4312.49 ± 0.2% | 32.65 ± 0.4% | not timed | not timed | 14464.71 ± 0.5% | | 1.00 | 3.36 | 443.29 |
| opt/prefilter/literal-russian | 1 | 21529.77 ± 0.5% | not timed | not timed | 20043.42 ± 0.5% | 3327.66 ± 0.2% | not timed | not timed | 21511.34 ± 0.1% | | 1.00 | 1.07 | 6.47 |
| opt/prefilter/literal-casei-russian | 1 | 8583.97 ± 0.4% | not timed | not timed | 3888.96 ± 0.2% | 31.76 ± 0.7% | not timed | not timed | 8592.09 ± 0.3% | | 1.00 | 2.21 | 270.24 |
| opt/prefilter/rust-functions | 948 | 6798.20 ± 0.3% | not timed | not timed | 9032.63 ± 0.5% | 1869.42 ± 0.2% | not timed | not timed | 6816.53 ± 0.4% | | 1.00 | 0.75 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29367516.60 ± 0.1% | not timed | not timed | 21284075.92 ± 0.1% | 50.43 ± 0.2% | not timed | not timed | 29265886.49 ± 0.2% | | 1.00 | 1.38 | 582287.68 |
| opt/reverse-inner/holmes | 2593 | 9920.68 ± 0.8% | not timed | not timed | 9515.39 ± 0.3% | 24.09 ± 1.7% | not timed | not timed | 9970.41 ± 0.5% | | 1.00 | 1.04 | 411.86 |
| opt/reverse-inner/email | 47 | 36338.65 ± 2.5% | not timed | not timed | 44913.27 ± 0.2% | 32.22 ± 0.9% | not timed | not timed | 36829.59 ± 2.9% | | 0.99 | 0.81 | 1127.80 |
| opt/reverse-inner/factored-prefix | 3542 | 591.44 ± 0.5% | not timed | not timed | 596.27 ± 0.1% | 12.52 ± 0.3% | not timed | not timed | 591.74 ± 0.5% | | 1.00 | 0.99 | 47.23 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20987.43 ± 0.2% | not timed | not timed | 613.44 ± 0.4% | 74.78 ± 0.1% | not timed | not timed | 21146.81 ± 0.1% | | 0.99 | 34.21 | 280.65 |
| opt/reverse-inner/no-quadratic-forward | 0 | 728.86 ± 2.0% | not timed | not timed | 287.87 ± 0.3% | 24.64 ± 0.1% | not timed | not timed | 737.99 ± 2.0% | | 0.99 | 2.53 | 29.59 |
| opt/reverse-suffix/holmes | 4073 | 10294.12 ± 0.6% | not timed | not timed | 8422.33 ± 0.3% | 24.20 ± 0.2% | not timed | not timed | 10295.73 ± 0.4% | | 1.00 | 1.22 | 425.41 |
| opt/reverse-suffix/no-quadratic | 0 | 21057.82 ± 0.1% | not timed | not timed | 618.90 ± 0.1% | 75.08 ± 0.2% | not timed | not timed | 21132.81 ± 0.1% | | 1.00 | 34.02 | 280.48 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.74 ± 8.3% | not timed | not timed | 135.12 ± 0.3% | 13.26 ± 15.2% | not timed | not timed | 120.77 ± 2.7% | | 1.00 | 0.89 | 9.11 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.61 ± 1.9% | not timed | not timed | 132.90 ± 0.5% | 14.05 ± 13.7% | not timed | not timed | 120.63 ± 8.0% | | 1.00 | 0.91 | 8.58 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.2% | 111.84 ± 6.9% | not timed | not timed | 0.28 ± 3.7% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.68 ± 0.3% | not timed | not timed | 287.95 ± 0.1% | 103.43 ± 0.3% | not timed | not timed | 316.12 ± 0.6% | | 1.02 | 1.12 | 3.12 |
| reported/i13-subset-regex/original-ascii | 4094 | 11229.94 ± 0.9% | not timed | not timed | 4551.80 ± 2.4% | 11.51 ± 0.1% | not timed | not timed | 11233.61 ± 1.3% | | 1.00 | 2.47 | 975.79 |
| reported/i13-subset-regex/original-unicode | 4094 | 11062.65 ± 1.9% | not timed | not timed | 249.89 ± 3.3% | 11.52 ± 0.2% | not timed | not timed | 11252.46 ± 1.4% | | 0.98 | 44.27 | 960.25 |
| reported/i13-subset-regex/big-ascii | 1955 | 10690.68 ± 1.0% | not timed | not timed | 67.73 ± 3.5% | 9.86 ± 0.2% | not timed | not timed | 10748.90 ± 1.3% | | 0.99 | 157.85 | 1084.26 |
| reported/i13-subset-regex/big-unicode | 1955 | 10614.94 ± 2.2% | not timed | not timed | 12.23 ± 54.9% | 9.84 ± 1.3% | not timed | not timed | 10754.15 ± 1.0% | | 0.99 | 868.20 | 1078.62 |
| reported/i13-subset-regex/huge-ascii | 55 | 9917.08 ± 2.9% | not timed | not timed | 11.01 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 9890.88 ± 3.9% | | 1.00 | 900.34 | 1130.92 |
| reported/i13-subset-regex/huge-unicode | 55 | 9864.12 ± 4.1% | not timed | not timed | 10.98 ± 0.2% | 8.78 ± 0.1% | not timed | not timed | 9868.41 ± 3.4% | | 1.00 | 898.33 | 1123.52 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.0% | not timed | not timed | 10.99 ± 0.1% | 8.77 ± 1.4% | not timed | not timed | 3.52 ± 0.1% | | 1.01 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 11.02 ± 0.4% | 8.78 ± 0.2% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.47 ± 0.3% | not timed | not timed | 104.56 ± 0.2% | 6.53 ± 0.2% | not timed | not timed | 484.84 ± 0.3% | | 1.00 | 4.62 | 74.06 |
| reported/i787-keywords/opt-ascii | 5674 | 484.68 ± 0.4% | not timed | not timed | 272.72 ± 0.2% | 10.28 ± 0.1% | not timed | not timed | 483.99 ± 0.3% | | 1.00 | 1.78 | 47.15 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 0.4% | not timed | not timed | 4.98 ± 0.5% | 0.05 ± 0.4% | not timed | not timed | 7.17 ± 0.3% | | 0.99 | 1.42 | 143.77 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.1% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.4% | not timed | not timed | 3.42 ± 0.1% | | 1.00 | 1.24 | 267.80 |
| slow/quadratic-haystack-1x | 100 | 21.99 ± 6.8% | not timed | not timed | 10.07 ± 0.5% | 1.01 ± 12.6% | not timed | not timed | 22.11 ± 2.2% | | 0.99 | 2.18 | 21.79 |
| slow/quadratic-haystack-2x | 200 | 19.83 ± 2.1% | not timed | not timed | 5.54 ± 0.1% | 0.55 ± 12.1% | not timed | not timed | 19.76 ± 1.0% | | 1.00 | 3.58 | 36.36 |
| unicode/codepoints/any-one | 1112064 | 281.80 ± 0.7% | not timed | not timed | 177.97 ± 0.2% | 18.59 ± 2.3% | not timed | not timed | 281.48 ± 0.4% | | 1.00 | 1.58 | 15.16 |
| unicode/codepoints/any-all | 4382592 | 280.80 ± 1.0% | not timed | not timed | 246.42 ± 0.2% | 117.66 ± 0.2% | not timed | not timed | 280.30 ± 1.3% | | 1.00 | 1.14 | 2.39 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 0.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.19 ± 1.1% | not timed | not timed | 615.60 ± 0.2% | 135.44 ± 0.2% | not timed | not timed | 603.55 ± 0.8% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.77 ± 0.3% | not timed | not timed | 38.94 ± 0.1% | 3.92 ± 1.0% | not timed | not timed | 31.78 ± 0.3% | | 1.00 | 0.82 | 8.11 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 3.41 ± 0.3% | 2.35 ± 0.7% | not timed | not timed | 1.44 ± 0.1% | | 1.01 | 0.42 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.3% | not timed | not timed | 2.86 ± 0.8% | 6.25 ± 8.9% | not timed | not timed | 1.28 ± 0.1% | | 1.00 | 0.45 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 126.22 ± 6.9% | not timed | not timed | 83.11 ± 0.2% | 11.74 ± 19.5% | not timed | not timed | 129.48 ± 0.3% | | 0.97 | 1.52 | 10.75 |
| unicode/word/boundary-long-english | 3466 | 607.00 ± 0.4% | not timed | not timed | 604.86 ± 0.2% | 32.54 ± 0.9% | not timed | not timed | 606.09 ± 0.4% | | 1.00 | 1.00 | 18.66 |
| unicode/word/around-holmes-english | 27 | 19669.27 ± 0.7% | not timed | not timed | 19567.89 ± 0.6% | 22.34 ± 1.0% | not timed | not timed | 19607.61 ± 0.4% | | 1.00 | 1.01 | 880.53 |
| wild/bibleref/long | 874 | 566.06 ± 0.3% | not timed | not timed | 584.06 ± 0.1% | 6.53 ± 0.2% | not timed | not timed | 568.53 ± 0.3% | | 1.00 | 0.97 | 86.70 |
| wild/bibleref/short | 30 | 25.26 ± 2.6% | not timed | not timed | 31.40 ± 0.7% | 14.17 ± 11.9% | not timed | not timed | 25.84 ± 3.5% | | 0.98 | 0.80 | 1.78 |
| wild/bibleref/line | 874 | 398.48 ± 1.7% | not timed | not timed | 218.89 ± 0.3% | 9.22 ± 8.6% | not timed | not timed | 400.03 ± 0.1% | | 1.00 | 1.82 | 43.21 |
| wild/caddy/caddy | 6 | 419.99 ± 2.9% | not timed | not timed | 243.90 ± 0.1% | 68.04 ± 13.4% | not timed | not timed | 423.47 ± 0.6% | | 0.99 | 1.72 | 6.17 |
| wild/dot-star-capture/rust-src-tools | 6 | 1068.77 ± 0.4% | not timed | not timed | 347.15 ± 0.3% | 13.52 ± 0.4% | not timed | not timed | 1063.96 ± 0.3% | | 1.00 | 3.08 | 79.02 |
| wild/ruff/noqa | 84 | 439.11 ± 0.2% | not timed | not timed | 463.78 ± 0.3% | 19.51 ± 2.2% | not timed | not timed | 438.16 ± 0.2% | | 1.00 | 0.95 | 22.51 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.62 ± 0.4% | not timed | not timed | 703.72 ± 0.2% | 136.03 ± 11.0% | not timed | not timed | 960.16 ± 0.4% | | 1.00 | 1.36 | 7.04 |
| wild/ruff/string-quote-prefix | 2972 | 1357.02 ± 1.1% | not timed | not timed | 440.20 ± 0.2% | 314.55 ± 25.3% | not timed | not timed | 1359.25 ± 0.7% | | 1.00 | 3.08 | 4.31 |
| wild/ruff/space-around-operator | 1224378 | 222.94 ± 1.8% | not timed | not timed | 188.16 ± 0.1% | 18.31 ± 1.6% | not timed | not timed | 223.49 ± 2.0% | | 1.00 | 1.18 | 12.18 |
| wild/ruff/shebang | 282 | 968.29 ± 0.5% | not timed | not timed | 328.80 ± 0.1% | 118.10 ± 9.5% | not timed | not timed | 974.58 ± 0.4% | | 0.99 | 2.94 | 8.20 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13848.34 ± 0.2% | not timed | not timed | 13837.07 ± 0.2% | 6935.07 ± 0.8% | not timed | not timed | 13860.39 ± 0.1% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12846.10 ± 0.3% | not timed | not timed | 13437.11 ± 0.5% | 6402.29 ± 0.8% | not timed | not timed | 12851.50 ± 0.5% | | 1.00 | 0.96 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13241.64 ± 0.9% | not timed | not timed | 13751.02 ± 0.4% | 6633.05 ± 1.4% | not timed | not timed | 13246.02 ± 0.4% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9573.44 ± 0.1% | not timed | not timed | 13672.09 ± 0.3% | 6738.21 ± 0.9% | not timed | not timed | 9590.18 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.80 ± 14.2% | not timed | not timed | 66.17 ± 0.4% | 2.22 ± 0.8% | not timed | not timed | 121.53 ± 14.5% | | 1.00 | 1.84 | 54.96 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 42.6% | not timed | not timed | 0.01 ± 1.3% | 0.01 ± 19.6% | not timed | not timed | 0.03 ± 1.7% | | 0.98 | 3.08 | 4.10 |
| dictionary/compile/english-15 | 1 | 0.35 ± 37.2% | not timed | not timed | 0.07 ± 0.4% | 0.10 ± 7.6% | not timed | not timed | 0.35 ± 2.5% | | 1.00 | 5.00 | 3.42 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 15.7% | not timed | not timed | 0.02 ± 0.7% | 34.32 ± 12.4% | not timed | not timed | 0.24 ± 3.5% | | 1.00 | 12.61 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.33 ± 2.2% | not timed | not timed | 11.61 ± 0.2% | 59.86 ± 20.5% | not timed | not timed | 46.70 ± 2.1% | | 0.99 | 3.99 | 0.77 |
| reported/i787-keywords/compile | 1 | 34.47 ± 1.4% | not timed | not timed | 2.14 ± 1.6% | 16.36 ± 20.6% | not timed | not timed | 34.46 ± 3.4% | | 1.00 | 16.10 | 2.11 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 341.10 ± 2.2% | not timed | not timed | 119.25 ± 0.3% | 574.28 ± 22.7% | not timed | not timed | 348.75 ± 6.9% | | 0.98 | 2.86 | 0.59 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.75 ± 1.7% | not timed | not timed | 4.11 ± 0.9% | 43.93 ± 19.4% | not timed | not timed | 47.70 ± 19.1% | | 0.98 | 11.37 | 1.06 |
| unicode/compile/one-letter | 53 | 6.66 ± 13.5% | not timed | not timed | 4.65 ± 0.7% | 66.04 ± 2.5% | not timed | not timed | 6.71 ± 13.8% | | 0.99 | 1.43 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.01 ± 18.1% | not timed | not timed | 0.10 ± 0.6% | 66.84 ± 7.7% | not timed | not timed | 1.07 ± 13.0% | | 0.95 | 10.11 | 0.0152 |
| unicode/compile/fifty-letters-ascii | 1 | 211.90 ± 8.9% | not timed | not timed | 51.97 ± 0.2% | 199.81 ± 3.6% | not timed | not timed | 215.43 ± 9.0% | | 0.98 | 4.08 | 1.06 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 366.13 ± 16.9% | not timed | not timed | 47.29 ± 0.6% | 668.30 ± 21.3% | not timed | not timed | 372.43 ± 2.1% | | 0.98 | 7.74 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 563.66 ± 17.8% | not timed | not timed | 145.58 ± 0.2% | 661.32 ± 23.1% | not timed | not timed | 595.82 ± 13.3% | | 0.95 | 3.87 | 0.85 |
| unicode/compile/negated-class-matches-codepoint | 1 | 296.91 ± 6.2% | not timed | not timed | 50.98 ± 0.1% | 1212.52 ± 25.7% | not timed | not timed | 310.65 ± 2.2% | | 0.96 | 5.82 | 0.24 |
| wild/bibleref/compile | 3 | 5.75 ± 4.1% | not timed | not timed | 1.93 ± 1.2% | 32.25 ± 6.1% | not timed | not timed | 5.89 ± 3.8% | | 0.98 | 2.97 | 0.18 |
| wild/url/compile | 1 | 0.61 ± 15.8% | not timed | not timed | 0.15 ± 0.2% | 0.43 ± 25.8% | not timed | not timed | 0.63 ± 2.4% | | 0.97 | 4.18 | 1.40 |

