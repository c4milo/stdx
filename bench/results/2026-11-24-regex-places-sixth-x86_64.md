# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506993528 |
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
| literal: a word | 217 | 38691.13 ± 7.4% | 3383.08 ± 1.9% | 20.15 ± 6.2% | 30816.43 ± 3.4% | 8786.39 ± 9.8% | 10.73 ± 1.3% | 74.58 ± 4.9% | 39341.10 ± 5.8% | 11.44 | 0.98 | 1.26 | 4.40 |
| literal: a word that is not there | 0 | 52788.25 ± 2.4% | 3247.44 ± 0.5% | 19.94 ± 2.9% | 39646.23 ± 1.8% | 30419.44 ± 2.3% | 10.70 ± 0.1% | 71.44 ± 1.1% | 53753.10 ± 2.8% | 16.26 | 0.98 | 1.33 | 1.74 |
| literal: one of four words | 661 | 12625.75 ± 1.1% | 1422.68 ± 2.8% | 10.93 ± 4.5% | 9160.88 ± 0.4% | 18.05 ± 25.0% | 3.56 ± 1.4% | 6.69 ± 1.3% | 12569.65 ± 1.7% | 8.87 | 1.00 | 1.38 | 699.54 |
| literal: a word in any case | 217 | 29783.34 ± 2.0% | 1508.03 ± 2.8% | 14.97 ± 7.3% | 9178.84 ± 0.8% | 37.21 ± 0.7% | refused | differs | 29812.68 ± 2.8% | 19.75 | 1.00 | 3.24 | 800.48 |
| literal: an href attribute | 33 | 29104.20 ± 1.1% | 541.00 ± 0.1% | 18.65 ± 1.5% | 27082.86 ± 1.0% | 2053.77 ± 0.8% | 8.24 ± 0.3% | 61.53 ± 1.6% | 29434.27 ± 2.3% | 53.80 | 0.99 | 1.07 | 14.17 |
| literal: a word, second text | 123 | 37757.18 ± 1.1% | 2403.96 ± 0.4% | 19.82 ± 2.6% | 31990.20 ± 2.6% | 7055.85 ± 5.0% | 11.65 ± 0.8% | 63.99 ± 1.5% | 38593.04 ± 2.7% | 15.71 | 0.98 | 1.18 | 5.35 |
| class: two capitalized words | 1331 | 778.21 ± 0.3% | 533.05 ± 0.4% | 18.62 ± 1.6% | 506.41 ± 0.1% | 33.99 ± 2.3% | 9.34 ± 0.3% | 55.58 ± 0.8% | 778.56 ± 0.4% | 1.46 | 1.00 | 1.54 | 22.89 |
| class: a word that ends in ing | 3399 | 507.65 ± 0.3% | 507.52 ± 0.3% | 13.22 ± 1.3% | 472.70 ± 0.2% | 20.21 ± 0.5% | 5.32 ± 0.6% | 17.22 ± 3.7% | 507.19 ± 1.4% | 1.00 | 1.00 | 1.07 | 25.12 |
| class: a word in capitals | 2332 | 979.47 ± 0.2% | 538.82 ± 0.3% | 19.90 ± 6.0% | 496.44 ± 0.6% | 36.57 ± 11.2% | 10.45 ± 0.5% | 76.48 ± 5.0% | 978.65 ± 1.2% | 1.82 | 1.00 | 1.97 | 26.78 |
| class: a number | 8288 | 1648.02 ± 0.1% | 735.39 ± 0.1% | 19.40 ± 1.1% | 1486.90 ± 1.1% | 36.35 ± 11.9% | 0.33 ± 0.3% | 55.87 ± 10.1% | 1647.85 ± 0.7% | 2.24 | 1.00 | 1.11 | 45.33 |
| class: two capitalized words, second text | 5359 | 452.44 ± 1.4% | 458.51 ± 1.5% | 16.78 ± 4.3% | 418.34 ± 1.9% | 28.65 ± 6.6% | 10.61 ± 1.5% | 51.49 ± 0.9% | 447.26 ± 1.6% | 0.99 | 1.01 | 1.08 | 15.79 |
| other: a word between two words | 6104 | 743.59 ± 0.2% | 527.28 ± 0.2% | 16.87 ± 2.0% | 694.53 ± 0.5% | 83.01 ± 8.8% | 7.25 ± 0.2% | 56.49 ± 1.0% | 742.40 ± 0.2% | 1.41 | 1.00 | 1.07 | 8.96 |
| other: a number before a unit, second text | 1481 | 7323.57 ± 1.3% | 871.71 ± 0.5% | 18.99 ± 1.3% | 6398.81 ± 0.2% | 34.69 ± 9.3% | 11.04 ± 0.5% | 55.15 ± 0.1% | 7354.37 ± 0.7% | 8.40 | 1.00 | 1.14 | 211.14 |
| other: a heading's start tag | 110 | 19348.42 ± 2.4% | 655.47 ± 0.9% | 18.28 ± 1.1% | 2010.69 ± 2.2% | 1465.56 ± 18.3% | 9.99 ± 0.4% | 72.73 ± 9.6% | 19718.10 ± 2.6% | 29.52 | 0.98 | 9.62 | 13.20 |
| other: a whole word | 217 | 24794.28 ± 5.3% | 533.39 ± 0.5% | 19.63 ± 1.3% | 22536.08 ± 8.6% | 41.37 ± 3.5% | 9.50 ± 0.7% | 46.61 ± 1.3% | 25257.29 ± 3.5% | 46.48 | 0.98 | 1.10 | 599.40 |
| other: a line's first word, second text | 3716 | 1952.55 ± 1.1% | 522.72 ± 0.2% | 22.08 ± 3.1% | 1702.49 ± 5.3% | 49.79 ± 14.8% | refused | refused | 1923.57 ± 9.1% | 3.74 | 1.02 | 1.15 | 39.21 |
| other: fourteen octets before an x | 87 | 27268.42 ± 0.9% | 196.65 ± 2.5% | 5.55 ± 2.9% | 2793.11 ± 1.6% | 8.97 ± 0.2% | differs | 15.54 ± 3.2% | 27782.81 ± 3.2% | 138.67 | 0.98 | 9.76 | 3038.89 |
| other: a Greek word | 21815 | 436.34 ± 0.7% | 384.01 ± 5.6% | 23.52 ± 4.0% | 261.11 ± 2.1% | 44.06 ± 10.4% | differs | refused | 439.27 ± 0.3% | 1.14 | 0.99 | 1.67 | 9.90 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.94 ± 0.9% | 26.88 ± 0.8% | 0.77 ± 8.8% | 17.02 ± 0.6% | 1.71 ± 0.7% | differs | 3.62 ± 8.0% | 26.85 ± 1.4% | 1.00 | 1.00 | 1.58 | 15.74 |
| a UUID | 32895 | 23.19 ± 0.4% | 23.24 ± 5.8% | 0.54 ± 1.3% | 12.89 ± 0.2% | 2.43 ± 1.0% | 0.43 ± 0.4% | 3.08 ± 2.9% | 23.24 ± 1.1% | 1.00 | 1.00 | 1.80 | 9.53 |
| an IPv4 address | 33176 | 34.48 ± 2.3% | 34.51 ± 11.1% | 1.74 ± 0.2% | 24.28 ± 0.1% | 5.64 ± 1.4% | differs | 3.14 ± 0.6% | 34.51 ± 0.7% | 1.00 | 1.00 | 1.42 | 6.11 |
| a date and time | 32954 | 31.62 ± 0.9% | 31.56 ± 0.2% | 1.23 ± 0.3% | 18.09 ± 0.1% | 6.61 ± 1.2% | 0.75 ± 0.2% | 6.16 ± 1.3% | 31.57 ± 0.5% | 1.00 | 1.00 | 1.75 | 4.79 |
| a field path | 32606 | 29.35 ± 1.5% | 29.37 ± 0.5% | 0.86 ± 0.3% | 19.64 ± 0.3% | 2.90 ± 0.3% | differs | 2.46 ± 0.3% | 29.30 ± 0.7% | 1.00 | 1.00 | 1.49 | 10.11 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.70 ± 2.6% | 8.71 ± 3.1% | 8.57 ± 12.2% | 10.65 ± 0.2% | 4.67 ± 1.5% | 0.62 ± 0.7% | none | 8.46 ± 3.1% | 1.00 | 1.03 | 0.82 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 187.47 ± 1.1% | 187.72 ± 0.2% | 219.68 ± 0.5% | 80.45 ± 2.2% | 183.43 ± 2.0% | 542.66 ± 3.9% | 3988.85 ± 2.6% | 187.51 ± 1.7% | 1.00 | 1.00 | 2.33 | 1.02 |
| a UUID | 62 | 121.67 ± 0.6% | 121.92 ± 0.2% | 136.28 ± 0.2% | 46.83 ± 1.1% | 89.58 ± 0.8% | 197.44 ± 2.4% | 4139.20 ± 0.6% | 121.73 ± 0.3% | 1.00 | 1.00 | 2.60 | 1.36 |
| an IPv4 address | 29 | 376.58 ± 1.1% | 372.94 ± 1.0% | 530.41 ± 1.6% | 71.82 ± 0.7% | 113.33 ± 1.4% | 330.33 ± 0.8% | 7178.27 ± 0.7% | 376.82 ± 1.2% | 1.01 | 1.00 | 5.24 | 3.32 |
| a date and time | 56 | 268.84 ± 0.6% | 269.33 ± 0.8% | 340.86 ± 0.9% | 68.83 ± 1.1% | 121.38 ± 2.5% | 372.65 ± 0.3% | 4174.34 ± 0.4% | 268.77 ± 1.1% | 1.00 | 1.00 | 3.91 | 2.21 |
| a field path | 39 | 183.20 ± 0.5% | 183.42 ± 0.3% | 213.96 ± 0.7% | 74.35 ± 5.3% | 172.52 ± 15.6% | 585.08 ± 2.7% | 4794.52 ± 2.7% | 183.45 ± 2.1% | 1.00 | 1.00 | 2.46 | 1.06 |
| literal: a word | 7 | 537.15 ± 12.0% | 576.60 ± 2.4% | 1027.87 ± 1.9% | 494.11 ± 3.1% | 577.10 ± 5.5% | 1250.40 ± 2.3% | 25051.09 ± 2.7% | 537.57 ± 3.0% | 0.93 | 1.00 | 1.09 | 0.93 |
| literal: a word that is not there | 8 | 513.27 ± 1.3% | 556.46 ± 0.2% | 977.30 ± 0.8% | 447.53 ± 3.8% | 559.10 ± 1.9% | 1179.28 ± 0.8% | 23970.49 ± 1.3% | 514.16 ± 0.1% | 0.92 | 1.00 | 1.15 | 0.92 |
| literal: one of four words | 26 | 207.95 ± 2.1% | 345.15 ± 0.7% | 471.61 ± 0.4% | 41.88 ± 4.2% | 221.85 ± 1.4% | 459.89 ± 0.3% | 11575.65 ± 7.3% | 208.40 ± 1.4% | 0.60 | 1.00 | 4.97 | 0.94 |
| literal: a word in any case | 11 | 390.92 ± 0.8% | 414.06 ± 0.4% | 614.86 ± 0.5% | 14.59 ± 0.9% | 609.21 ± 1.7% | refused | 18921.93 ± 2.8% | 391.99 ± 0.3% | 0.94 | 1.00 | 26.80 | 0.64 |
| literal: an href attribute | 12 | 307.00 ± 0.4% | 319.32 ± 0.3% | 424.56 ± 9.1% | 37.61 ± 1.4% | 431.43 ± 4.1% | 991.74 ± 1.0% | 18329.35 ± 2.3% | 307.42 ± 0.2% | 0.96 | 1.00 | 8.16 | 0.71 |
| literal: a word, second text | 10 | 476.30 ± 0.4% | 521.07 ± 0.4% | 869.92 ± 0.8% | 412.46 ± 1.6% | 483.11 ± 2.4% | 1027.58 ± 12.6% | 21705.17 ± 2.1% | 475.54 ± 0.2% | 0.91 | 1.00 | 1.15 | 0.99 |
| class: two capitalized words | 23 | 379.82 ± 6.7% | 409.16 ± 4.1% | 603.93 ± 3.5% | 94.40 ± 0.7% | 448.42 ± 2.7% | 970.82 ± 3.0% | 6396.61 ± 11.8% | 379.90 ± 3.2% | 0.93 | 1.00 | 4.02 | 0.85 |
| class: a word that ends in ing | 9 | 459.08 ± 1.1% | 525.47 ± 0.2% | 939.43 ± 0.3% | 116.66 ± 1.0% | 635.58 ± 3.5% | 1464.13 ± 1.6% | 15230.56 ± 0.5% | 459.33 ± 0.3% | 0.87 | 1.00 | 3.94 | 0.72 |
| class: a word in capitals | 16 | 406.68 ± 0.3% | 441.55 ± 0.6% | 748.85 ± 1.0% | 123.36 ± 1.7% | 631.57 ± 9.8% | 1344.52 ± 3.5% | 8388.35 ± 0.2% | 407.76 ± 0.4% | 0.92 | 1.00 | 3.30 | 0.64 |
| class: a number | 6 | 515.90 ± 0.7% | 571.35 ± 1.3% | 1152.12 ± 1.1% | 36.68 ± 1.1% | 1162.41 ± 2.3% | 2294.66 ± 5.0% | 20449.29 ± 0.3% | 516.04 ± 0.7% | 0.90 | 1.00 | 14.07 | 0.44 |
| class: two capitalized words, second text | 23 | 379.81 ± 2.0% | 411.92 ± 2.5% | 617.18 ± 3.8% | 94.94 ± 0.8% | 450.00 ± 2.3% | 936.43 ± 3.7% | 6389.11 ± 0.8% | 378.86 ± 2.3% | 0.92 | 1.00 | 4.00 | 0.84 |
| other: a word between two words | 13 | 461.85 ± 10.6% | 484.93 ± 0.3% | 767.89 ± 4.9% | 124.54 ± 1.2% | 442.65 ± 1.2% | 1006.93 ± 0.5% | 14121.23 ± 0.3% | 465.60 ± 0.7% | 0.95 | 0.99 | 3.71 | 1.04 |
| other: a number before a unit, second text | 15 | 336.53 ± 0.5% | 375.85 ± 5.5% | 529.97 ± 3.2% | 34.13 ± 0.4% | 540.63 ± 1.8% | 1149.00 ± 1.1% | 13796.57 ± 0.5% | 336.41 ± 0.7% | 0.90 | 1.00 | 9.86 | 0.62 |
| other: a heading's start tag | 13 | 317.06 ± 0.2% | 323.86 ± 0.7% | 434.83 ± 0.6% | 35.90 ± 2.5% | 534.40 ± 1.7% | 1093.13 ± 0.6% | 16375.74 ± 0.4% | 317.57 ± 0.5% | 0.98 | 1.00 | 8.83 | 0.59 |
| other: a whole word | 11 | 474.87 ± 1.9% | 504.05 ± 0.3% | 836.62 ± 0.7% | 112.53 ± 1.0% | 505.93 ± 1.9% | 1055.72 ± 2.2% | 21044.15 ± 19.3% | 476.72 ± 0.5% | 0.94 | 1.00 | 4.22 | 0.94 |
| other: a line's first word, second text | 17 | 449.13 ± 1.4% | 471.79 ± 2.0% | 791.98 ± 0.4% | 116.14 ± 0.9% | 600.46 ± 1.9% | refused | refused | 448.36 ± 1.0% | 0.95 | 1.00 | 3.87 | 0.75 |
| other: fourteen octets before an x | 16 | 88.62 ± 3.2% | 122.23 ± 0.3% | 142.13 ± 0.7% | 14.29 ± 2.1% | 401.96 ± 1.9% | 449.82 ± 0.6% | 11677.95 ± 1.2% | 88.60 ± 0.3% | 0.73 | 1.00 | 6.20 | 0.22 |
| other: a Greek word | 8 | 355.60 ± 0.6% | 496.00 ± 0.9% | 859.63 ± 0.5% | 47.79 ± 1.3% | 1150.42 ± 3.5% | 2174.12 ± 1.6% | refused | 356.09 ± 0.6% | 0.72 | 1.00 | 7.44 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27181.97 ± 3.7% | not timed | not timed | 26882.69 ± 0.9% | 1890.12 ± 24.6% | not timed | not timed | 27278.72 ± 1.0% | | 1.00 | 1.01 | 14.38 |
| 01-literal/sherlock-casei-en | 522 | 21486.24 ± 2.5% | not timed | not timed | 7035.89 ± 0.3% | 23.94 ± 0.2% | not timed | not timed | 21609.16 ± 4.6% | | 0.99 | 3.05 | 897.65 |
| 01-literal/sherlock-ru | 724 | 28637.00 ± 0.8% | not timed | not timed | 27884.15 ± 0.3% | 1064.72 ± 5.1% | not timed | not timed | 28738.75 ± 1.0% | | 1.00 | 1.03 | 26.90 |
| 01-literal/sherlock-casei-ru | 746 | 9443.39 ± 0.6% | not timed | not timed | 5506.04 ± 0.3% | 30.50 ± 1.5% | not timed | not timed | 9328.99 ± 0.4% | | 1.01 | 1.72 | 309.58 |
| 01-literal/sherlock-zh | 30 | 47045.69 ± 1.8% | not timed | not timed | 36813.97 ± 0.9% | 1262.58 ± 10.3% | not timed | not timed | 47343.56 ± 3.0% | | 0.99 | 1.28 | 37.26 |
| 02-literal-alternate/sherlock-en | 714 | 11045.84 ± 0.7% | not timed | not timed | 8901.15 ± 11.1% | 12.90 ± 18.4% | not timed | not timed | 11053.60 ± 0.5% | | 1.00 | 1.24 | 856.33 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2051.76 ± 2.9% | not timed | not timed | 1781.31 ± 2.7% | 8.22 ± 2.7% | not timed | not timed | 2029.61 ± 8.0% | | 1.01 | 1.15 | 249.55 |
| 02-literal-alternate/sherlock-ru | 899 | 7936.19 ± 1.3% | not timed | not timed | 4264.60 ± 0.3% | 18.59 ± 3.8% | not timed | not timed | 7830.27 ± 11.1% | | 1.01 | 1.86 | 426.91 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2076.82 ± 0.3% | not timed | not timed | 1042.14 ± 0.4% | 8.37 ± 0.7% | not timed | not timed | 2067.91 ± 8.3% | | 1.00 | 1.99 | 248.02 |
| 02-literal-alternate/sherlock-zh | 207 | 14886.12 ± 6.5% | not timed | not timed | 10430.65 ± 0.1% | 27.00 ± 9.8% | not timed | not timed | 14894.98 ± 0.7% | | 1.00 | 1.43 | 551.40 |
| 03-date/ascii | 111817 | 118.03 ± 0.5% | not timed | not timed | 85.41 ± 18.7% | 0.18 ± 2.7% | not timed | not timed | 117.82 ± 0.7% | | 1.00 | 1.38 | 670.67 |
| 04-ruff-noqa/real | 84 | 434.08 ± 0.3% | not timed | not timed | 426.53 ± 0.2% | 15.18 ± 2.2% | not timed | not timed | 435.31 ± 1.2% | | 1.00 | 1.02 | 28.59 |
| 04-ruff-noqa/tweaked | 44 | 539.86 ± 0.3% | not timed | not timed | 423.16 ± 10.7% | 287.47 ± 0.7% | not timed | not timed | 540.14 ± 0.7% | | 1.00 | 1.28 | 1.88 |
| 05-lexer-veryl/single | 124800 | 3.58 ± 9.7% | not timed | not timed | 4.23 ± 1.4% | 0.21 ± 8.1% | not timed | not timed | 3.59 ± 11.4% | | 1.00 | 0.85 | 16.99 |
| 06-cloud-flare-redos/original | 107 | 365.60 ± 0.4% | not timed | not timed | 190.85 ± 5.8% | 13.05 ± 0.3% | not timed | not timed | 365.24 ± 0.7% | | 1.00 | 1.92 | 28.01 |
| 06-cloud-flare-redos/simplified-short | 102 | 338.90 ± 0.4% | not timed | not timed | 192.42 ± 0.4% | 14.16 ± 16.6% | not timed | not timed | 339.21 ± 7.4% | | 1.00 | 1.76 | 23.94 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.05 ± 0.1% | not timed | not timed | 211.86 ± 6.6% | 14.82 ± 0.8% | not timed | not timed | 464.59 ± 0.5% | | 1.00 | 2.20 | 31.37 |
| 07-unicode-character-data/parse-line | 558784 | 197.60 ± 10.5% | not timed | not timed | 158.66 ± 3.7% | 35.70 ± 8.4% | not timed | not timed | 201.49 ± 3.6% | | 0.98 | 1.25 | 5.54 |
| 08-words/all-english | 56691 | 111.85 ± 1.5% | not timed | not timed | 73.87 ± 0.7% | 10.67 ± 14.0% | not timed | not timed | 111.79 ± 0.4% | | 1.00 | 1.51 | 10.48 |
| 08-words/long-english | 839 | 540.73 ± 0.4% | not timed | not timed | 512.52 ± 0.3% | 26.67 ± 1.0% | not timed | not timed | 540.29 ± 0.7% | | 1.00 | 1.06 | 20.27 |
| 09-aws-keys/full | 0 | 444.21 ± 0.4% | not timed | not timed | 436.66 ± 5.5% | 51.82 ± 6.4% | not timed | not timed | 440.86 ± 5.3% | | 1.01 | 1.02 | 8.57 |
| 09-aws-keys/quick | 0 | 941.65 ± 3.0% | not timed | not timed | 802.94 ± 2.6% | 301.63 ± 4.6% | not timed | not timed | 933.77 ± 4.1% | | 1.01 | 1.17 | 3.12 |
| 10-bounded-repeat/letters-en | 1833 | 486.39 ± 0.9% | not timed | not timed | 432.11 ± 0.1% | 16.93 ± 1.7% | not timed | not timed | 485.69 ± 0.8% | | 1.00 | 1.13 | 28.72 |
| 10-bounded-repeat/letters-ru | 3475 | 430.87 ± 0.5% | not timed | not timed | 408.88 ± 0.5% | 19.57 ± 24.4% | not timed | not timed | 431.50 ± 1.1% | | 1.00 | 1.05 | 22.02 |
| 10-bounded-repeat/context | 53 | 69.58 ± 3.4% | not timed | not timed | 55.78 ± 1.6% | 16.69 ± 3.2% | not timed | not timed | 69.59 ± 2.1% | | 1.00 | 1.25 | 4.17 |
| 10-bounded-repeat/capitals | 11 | 556.40 ± 8.0% | not timed | not timed | 532.85 ± 0.2% | 30.97 ± 0.2% | not timed | not timed | 556.20 ± 7.8% | | 1.00 | 1.04 | 17.97 |
| 11-unstructured-to-json/extract | 600 | 37.82 ± 1.4% | not timed | not timed | 62.62 ± 18.2% | 23.09 ± 13.5% | not timed | not timed | 37.84 ± 3.9% | | 1.00 | 0.60 | 1.64 |
| 12-dictionary/single | 1 | 465.17 ± 1.2% | not timed | not timed | 440.73 ± 1.7% | 0.32 ± 0.4% | not timed | not timed | 463.64 ± 2.1% | | 1.00 | 1.06 | 1449.03 |
| 14-quadratic/1x | 100 | 21.39 ± 0.6% | not timed | not timed | 9.11 ± 0.3% | 0.79 ± 1.1% | not timed | not timed | 21.47 ± 0.5% | | 1.00 | 2.35 | 27.23 |
| 14-quadratic/2x | 200 | 16.25 ± 4.1% | not timed | not timed | 4.92 ± 0.2% | 0.41 ± 1.5% | not timed | not timed | 16.07 ± 2.7% | | 1.01 | 3.30 | 39.42 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.8% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 3.3% | not timed | not timed | 5.62 ± 0.8% | | 1.00 | 5.35 | 60.61 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.05 ± 1.5% | not timed | not timed | 0.39 ± 0.9% | 0.47 ± 7.6% | not timed | not timed | 1.05 ± 0.6% | | 1.00 | 2.73 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 94.41 ± 1.3% | not timed | not timed | 12.86 ± 0.6% | 123.28 ± 2.3% | not timed | not timed | 94.08 ± 0.8% | | 1.00 | 7.34 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 12.38 ± 0.7% | not timed | not timed | 2.35 ± 1.3% | 5.83 ± 3.1% | not timed | not timed | 12.38 ± 9.8% | | 1.00 | 5.27 | 2.12 |
| 07-unicode-character-data/compile | 1 | 99.08 ± 1.0% | not timed | not timed | 24.03 ± 27.8% | 32.53 ± 1.5% | not timed | not timed | 99.36 ± 1.0% | | 1.00 | 4.12 | 3.05 |
| 09-aws-keys/compile-full | 1 | 43.75 ± 1.6% | not timed | not timed | 7.38 ± 1.2% | 19.83 ± 5.0% | not timed | not timed | 43.69 ± 0.5% | | 1.00 | 5.93 | 2.21 |
| 09-aws-keys/compile-quick | 1 | 152.35 ± 0.9% | not timed | not timed | 45.51 ± 3.2% | 115.48 ± 7.4% | not timed | not timed | 152.18 ± 14.0% | | 1.00 | 3.35 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 49.75 ± 4.3% | not timed | not timed | 11.73 ± 4.4% | 14.86 ± 12.4% | not timed | not timed | 49.99 ± 0.6% | | 1.00 | 4.24 | 3.35 |
| 10-bounded-repeat/compile-capitals | 1 | 73.56 ± 0.5% | not timed | not timed | 8.81 ± 0.5% | 22.03 ± 27.1% | not timed | not timed | 73.29 ± 1.1% | | 1.00 | 8.35 | 3.34 |
| 11-unstructured-to-json/compile | 1 | 149.81 ± 1.8% | not timed | not timed | 36.90 ± 2.0% | 60.22 ± 5.9% | not timed | not timed | 148.32 ± 2.2% | | 1.01 | 4.06 | 2.49 |
| 12-dictionary/compile-single | 1 | 0.28 ± 2.8% | not timed | not timed | 0.07 ± 4.1% | 0.08 ± 18.0% | not timed | not timed | 0.28 ± 2.4% | | 0.99 | 4.18 | 3.44 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.18 ± 14.7% | not timed | not timed | 5.64 ± 0.5% | 0.50 ± 16.1% | not timed | not timed | 5.27 ± 1.3% | | 0.98 | 0.92 | 10.31 |
| dictionary/search/english-10 | 690 | 0.93 ± 1.6% | not timed | not timed | 114.47 ± 2.4% | 0.00 ± 0.3% | not timed | not timed | 0.93 ± 3.9% | | 1.01 | 0.0082 | 203.35 |
| dictionary/search/english-15 | 15 | 466.26 ± 1.0% | not timed | not timed | 442.60 ± 0.1% | 0.28 ± 0.6% | not timed | not timed | 465.58 ± 1.0% | | 1.00 | 1.05 | 1652.21 |
| folly/awyer-inn-busted | 1 | 3682.48 ± 0.7% | not timed | not timed | 112.78 ± 0.2% | 37.20 ± 1.5% | not timed | not timed | 3682.33 ± 0.3% | | 1.00 | 32.65 | 98.98 |
| folly/literal-never-match-rare | 0 | 55350.31 ± 4.4% | not timed | not timed | 40213.77 ± 0.7% | 55604.21 ± 2.5% | not timed | not timed | 55186.10 ± 2.3% | | 1.00 | 1.38 | 1.00 |
| folly/literal-never-match-frequent | 0 | 18007.75 ± 1.0% | not timed | not timed | 39702.43 ± 3.4% | 2086.63 ± 1.3% | not timed | not timed | 18045.73 ± 0.8% | | 1.00 | 0.45 | 8.63 |
| folly/literal-never-match-tricksy | 1 | 3228.72 ± 5.7% | not timed | not timed | 4777.41 ± 1.5% | 1508.27 ± 0.6% | not timed | not timed | 3235.61 ± 0.2% | | 1.00 | 0.68 | 2.14 |
| grep/every-line | 239963 | 1227.13 ± 0.7% | not timed | not timed | 796.13 ± 0.4% | 305.38 ± 34.5% | not timed | not timed | 1231.45 ± 0.9% | | 1.00 | 1.54 | 4.02 |
| grep/long-words-ascii | 5073 | 445.22 ± 3.2% | not timed | not timed | 413.90 ± 0.5% | 37.85 ± 13.8% | not timed | not timed | 445.89 ± 0.3% | | 1.00 | 1.08 | 11.76 |
| imported/leipzig/twain | 811 | 40287.94 ± 8.9% | not timed | not timed | 34940.38 ± 5.7% | 10061.60 ± 22.2% | not timed | not timed | 40324.41 ± 10.1% | | 1.00 | 1.15 | 4.00 |
| imported/leipzig/twain-insensitive | 965 | 12758.85 ± 6.7% | not timed | not timed | 11089.60 ± 2.9% | 35.38 ± 0.4% | not timed | not timed | 12825.74 ± 4.7% | | 0.99 | 1.15 | 360.62 |
| imported/leipzig/shing | 1540 | 22461.67 ± 2.8% | not timed | not timed | 18205.93 ± 1.3% | 30.02 ± 3.1% | not timed | not timed | 22752.32 ± 3.2% | | 0.99 | 1.23 | 748.14 |
| imported/leipzig/huck-saw | 262 | 19789.13 ± 6.9% | not timed | not timed | 15394.73 ± 4.1% | 27.14 ± 2.5% | not timed | not timed | 20118.48 ± 5.2% | | 0.98 | 1.29 | 729.26 |
| imported/leipzig/word-ending-nn | 262 | 533.46 ± 0.2% | not timed | not timed | 532.63 ± 0.1% | 21.63 ± 1.4% | not timed | not timed | 533.44 ± 0.3% | | 1.00 | 1.00 | 24.67 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 9571.11 ± 2.4% | not timed | not timed | 3032.73 ± 2.9% | 9.68 ± 2.2% | not timed | not timed | 9601.03 ± 2.3% | | 1.00 | 3.16 | 988.82 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 16224.45 ± 15.1% | not timed | not timed | 13467.95 ± 12.5% | 15.04 ± 1.5% | not timed | not timed | 16311.88 ± 5.7% | | 0.99 | 1.20 | 1078.71 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4932.07 ± 4.8% | not timed | not timed | 704.35 ± 0.3% | 8.85 ± 1.4% | not timed | not timed | 4926.24 ± 0.3% | | 1.00 | 7.00 | 557.40 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 531.50 ± 0.2% | not timed | not timed | 530.89 ± 0.3% | 9.88 ± 0.6% | not timed | not timed | 531.65 ± 0.3% | | 1.00 | 1.00 | 53.80 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 532.13 ± 0.2% | not timed | not timed | 530.78 ± 0.2% | 8.46 ± 1.2% | not timed | not timed | 531.49 ± 0.1% | | 1.00 | 1.00 | 62.88 |
| imported/leipzig/tom-river | 2 | 10620.78 ± 1.7% | not timed | not timed | 11024.49 ± 5.0% | 26.77 ± 3.6% | not timed | not timed | 10722.58 ± 5.4% | | 0.99 | 0.96 | 396.72 |
| imported/leipzig/ing | 78424 | 522.81 ± 1.6% | not timed | not timed | 492.82 ± 1.5% | 23.95 ± 5.8% | not timed | not timed | 524.58 ± 0.5% | | 1.00 | 1.06 | 21.83 |
| imported/leipzig/ing-whitespace | 55248 | 643.60 ± 0.6% | not timed | not timed | 1894.60 ± 0.6% | 17.73 ± 3.7% | not timed | not timed | 651.25 ± 0.1% | | 0.99 | 0.34 | 36.31 |
| imported/leipzig/awyer-inn | 209 | 672.93 ± 1.3% | not timed | not timed | 11438.97 ± 0.3% | 19.43 ± 1.2% | not timed | not timed | 672.95 ± 1.3% | | 1.00 | 0.0588 | 34.63 |
| imported/leipzig/quotes-bounded | 8886 | 1619.95 ± 0.1% | not timed | not timed | 2832.84 ± 0.8% | 31.98 ± 0.3% | not timed | not timed | 1618.05 ± 1.0% | | 1.00 | 0.57 | 50.65 |
| imported/leipzig/non-ascii-alternate | 2 | 29116.78 ± 9.1% | not timed | not timed | 16206.11 ± 2.3% | 42.66 ± 0.5% | not timed | not timed | 28473.24 ± 8.9% | | 1.02 | 1.80 | 682.59 |
| imported/leipzig/math-symbols | 69 | 1602.23 ± 0.7% | not timed | not timed | 532.51 ± 0.3% | 31.37 ± 0.3% | not timed | not timed | 1600.80 ± 0.6% | | 1.00 | 3.01 | 51.07 |
| imported/leipzig/bounded-strings-ending-z | 0 | 534.99 ± 1.2% | not timed | not timed | 531.65 ± 0.3% | 20.12 ± 0.2% | not timed | not timed | 534.73 ± 0.1% | | 1.00 | 1.01 | 26.58 |
| imported/lh3lh3-reb/uri | 17549 | 665.12 ± 10.7% | not timed | not timed | 890.72 ± 0.8% | 18.55 ± 2.9% | not timed | not timed | 662.72 ± 1.0% | | 1.00 | 0.75 | 35.85 |
| imported/lh3lh3-reb/email | 15057 | 660.89 ± 0.3% | not timed | not timed | 921.85 ± 0.8% | 18.90 ± 1.1% | not timed | not timed | 661.70 ± 9.3% | | 1.00 | 0.72 | 34.97 |
| imported/lh3lh3-reb/date | 668 | 787.27 ± 15.6% | not timed | not timed | 819.84 ± 24.7% | 41.32 ± 7.0% | not timed | not timed | 788.80 ± 2.0% | | 1.00 | 0.96 | 19.05 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 622.37 ± 0.6% | not timed | not timed | 372.44 ± 0.5% | 9.62 ± 2.7% | not timed | not timed | 622.05 ± 0.4% | | 1.00 | 1.67 | 64.72 |
| imported/mariomka/email | 92 | 30196.83 ± 5.8% | not timed | not timed | 42235.46 ± 2.3% | 27.84 ± 0.5% | not timed | not timed | 32192.05 ± 5.4% | | 0.94 | 0.71 | 1084.59 |
| imported/mariomka/uri | 5301 | 5504.70 ± 3.1% | not timed | not timed | 6446.59 ± 0.9% | 27.55 ± 0.9% | not timed | not timed | 5521.57 ± 1.4% | | 1.00 | 0.85 | 199.82 |
| imported/mariomka/ip | 5 | 1530.53 ± 4.7% | not timed | not timed | 2035.18 ± 2.3% | 17.64 ± 1.6% | not timed | not timed | 1546.16 ± 12.7% | | 0.99 | 0.75 | 86.78 |
| imported/rsc/no-exponential | 0 | 664.98 ± 35.7% | not timed | not timed | 335.28 ± 0.4% | 13.75 ± 5.7% | not timed | not timed | 662.23 ± 3.6% | | 1.00 | 1.98 | 48.35 |
| imported/rsc/literal | 1 | 749.81 ± 24.7% | not timed | not timed | 1739.76 ± 1.1% | 151.83 ± 14.8% | not timed | not timed | 750.74 ± 3.3% | | 1.00 | 0.43 | 4.94 |
| imported/rsc/not-literal | 2 | 700.90 ± 22.8% | not timed | not timed | 721.22 ± 0.3% | 20.42 ± 3.2% | not timed | not timed | 708.82 ± 6.7% | | 0.99 | 0.97 | 34.33 |
| imported/rsc/match-class | 1 | 1361.90 ± 8.8% | not timed | not timed | 1504.26 ± 1.1% | 50.08 ± 4.9% | not timed | not timed | 1361.43 ± 1.1% | | 1.00 | 0.91 | 27.20 |
| imported/rsc/match-class-in-range | 1 | 1359.29 ± 1.1% | not timed | not timed | 2809.87 ± 0.5% | 51.69 ± 0.7% | not timed | not timed | 1359.87 ± 0.3% | | 1.00 | 0.48 | 26.29 |
| imported/rsc/match-class-unicode | 1 | 485.39 ± 0.6% | not timed | not timed | 459.31 ± 0.4% | 61.94 ± 4.9% | not timed | not timed | 486.16 ± 4.1% | | 1.00 | 1.06 | 7.84 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1320.74 ± 0.5% | not timed | not timed | 897.34 ± 0.3% | 264.94 ± 1.9% | not timed | not timed | 1323.69 ± 8.6% | | 1.00 | 1.47 | 4.99 |
| imported/rsc/anchored-literal-long-non-match | 0 | 19814.90 ± 2.0% | not timed | not timed | 13467.70 ± 0.3% | 3987.58 ± 4.0% | not timed | not timed | 19869.76 ± 0.6% | | 1.00 | 1.47 | 4.97 |
| imported/rsc/anchored-literal-short-match | 4 | 689.72 ± 1.7% | not timed | not timed | 517.90 ± 0.9% | 80.14 ± 10.7% | not timed | not timed | 689.03 ± 2.3% | | 1.00 | 1.33 | 8.61 |
| imported/rsc/anchored-literal-long-match | 4 | 10207.69 ± 3.1% | not timed | not timed | 7813.53 ± 0.9% | 1204.96 ± 21.2% | not timed | not timed | 10298.95 ± 1.5% | | 0.99 | 1.31 | 8.47 |
| imported/rsc/one-pass-short | 17 | 330.01 ± 1.4% | not timed | not timed | 216.89 ± 0.2% | 27.25 ± 11.9% | not timed | not timed | 330.34 ± 3.2% | | 1.00 | 1.52 | 12.11 |
| imported/rsc/one-pass-short-not | 17 | 246.64 ± 13.6% | not timed | not timed | 229.30 ± 1.0% | 23.12 ± 30.6% | not timed | not timed | 249.87 ± 1.4% | | 0.99 | 1.08 | 10.67 |
| imported/rsc/one-pass-long-prefix | 26 | 351.76 ± 1.2% | not timed | not timed | 285.34 ± 0.4% | 90.57 ± 17.2% | not timed | not timed | 351.35 ± 9.4% | | 1.00 | 1.23 | 3.88 |
| imported/rsc/one-pass-long-prefix-not | 26 | 333.29 ± 9.1% | not timed | not timed | 285.56 ± 1.9% | 66.21 ± 16.6% | not timed | not timed | 347.56 ± 2.0% | | 0.96 | 1.17 | 5.03 |
| imported/rsc/long-needle1 | 31 | 57562.96 ± 7.1% | not timed | not timed | 39851.54 ± 41.8% | 3.33 ± 1.4% | not timed | not timed | 55688.14 ± 3.9% | | 1.03 | 1.44 | 17311.34 |
| imported/rsc/long-needle2 | 31 | 56883.05 ± 17.1% | not timed | not timed | 170.54 ± 5.5% | 3.32 ± 0.3% | not timed | not timed | 55666.10 ± 4.4% | | 1.02 | 333.54 | 17124.38 |
| imported/rsc/easy0-32 | 26 | 1044.52 ± 5.0% | not timed | not timed | 1515.49 ± 0.3% | 63.95 ± 12.8% | not timed | not timed | 1044.36 ± 21.5% | | 1.00 | 0.69 | 16.33 |
| imported/rsc/easy0-1k | 26 | 17156.27 ± 20.0% | not timed | not timed | 16246.96 ± 0.2% | 1031.33 ± 3.9% | not timed | not timed | 16635.96 ± 22.9% | | 1.03 | 1.06 | 16.64 |
| imported/rsc/easy0-32k | 26 | 55441.42 ± 0.8% | not timed | not timed | 38528.38 ± 0.3% | 19494.49 ± 0.5% | not timed | not timed | 55620.10 ± 0.8% | | 1.00 | 1.44 | 2.84 |
| imported/rsc/easy0-1mb | 26 | 56191.02 ± 2.9% | not timed | not timed | 40254.97 ± 0.3% | 56346.17 ± 2.2% | not timed | not timed | 56032.00 ± 1.0% | | 1.00 | 1.40 | 1.00 |
| imported/rsc/easy1-32 | 19 | 727.92 ± 0.4% | not timed | not timed | 646.40 ± 0.5% | 77.78 ± 11.4% | not timed | not timed | 716.33 ± 10.3% | | 1.02 | 1.13 | 9.36 |
| imported/rsc/easy1-1k | 19 | 14833.12 ± 2.1% | not timed | not timed | 13247.21 ± 1.3% | 1334.47 ± 14.9% | not timed | not timed | 14873.32 ± 2.1% | | 1.00 | 1.12 | 11.12 |
| imported/rsc/easy1-32k | 19 | 467396.56 ± 1.8% | not timed | not timed | 416015.91 ± 0.5% | 22468.93 ± 12.5% | not timed | not timed | 468015.99 ± 1.2% | | 1.00 | 1.12 | 20.80 |
| imported/rsc/easy1-1mb | 19 | 14906779.99 ± 0.4% | not timed | not timed | 13260065.62 ± 0.4% | 54395.28 ± 1.7% | not timed | not timed | 14969275.95 ± 0.4% | | 1.00 | 1.12 | 274.05 |
| imported/rsc/medium-32 | 27 | 691.46 ± 1.5% | not timed | not timed | 625.43 ± 3.9% | 39.67 ± 11.3% | not timed | not timed | 692.46 ± 0.6% | | 1.00 | 1.11 | 17.43 |
| imported/rsc/medium-1k | 27 | 12344.38 ± 4.4% | not timed | not timed | 10712.33 ± 0.5% | 59.01 ± 22.4% | not timed | not timed | 12310.49 ± 4.8% | | 1.00 | 1.15 | 209.17 |
| imported/rsc/medium-32k | 27 | 383575.33 ± 0.3% | not timed | not timed | 349872.99 ± 0.4% | 41.31 ± 1.0% | not timed | not timed | 383629.05 ± 2.9% | | 1.00 | 1.10 | 9284.71 |
| imported/rsc/medium-1mb | 27 | 12290666.89 ± 1.6% | not timed | not timed | 10986209.11 ± 3.2% | 41.56 ± 20.2% | not timed | not timed | 12291714.41 ± 2.1% | | 1.00 | 1.12 | 295726.33 |
| imported/rsc/hard-32 | 58 | 371.39 ± 1.8% | not timed | not timed | 341.28 ± 0.5% | 24.72 ± 7.6% | not timed | not timed | 370.87 ± 1.4% | | 1.00 | 1.09 | 15.03 |
| imported/rsc/hard-1k | 27 | 11676.93 ± 0.3% | not timed | not timed | 11132.44 ± 0.8% | 19.94 ± 1.2% | not timed | not timed | 11681.69 ± 2.8% | | 1.00 | 1.05 | 585.74 |
| imported/rsc/hard-32k | 27 | 364655.59 ± 0.3% | not timed | not timed | 347021.10 ± 1.8% | 25.23 ± 21.7% | not timed | not timed | 364732.01 ± 0.5% | | 1.00 | 1.05 | 14450.53 |
| imported/rsc/hard-1mb | 51 | 7374392.24 ± 0.3% | not timed | not timed | 6737808.15 ± 10.4% | 25.40 ± 0.2% | not timed | not timed | 7359978.23 ± 1.0% | | 1.00 | 1.09 | 290308.50 |
| imported/rsc/reallyhard0-32 | 58 | 239.93 ± 1.1% | not timed | not timed | 215.62 ± 0.3% | 24.74 ± 1.1% | not timed | not timed | 240.04 ± 0.5% | | 1.00 | 1.11 | 9.70 |
| imported/rsc/reallyhard0-1k | 27 | 516.87 ± 0.1% | not timed | not timed | 511.87 ± 0.8% | 19.90 ± 2.0% | not timed | not timed | 516.84 ± 0.4% | | 1.00 | 1.01 | 25.97 |
| imported/rsc/reallyhard0-32k | 27 | 533.65 ± 0.8% | not timed | not timed | 533.02 ± 0.3% | 25.18 ± 0.8% | not timed | not timed | 533.87 ± 1.1% | | 1.00 | 1.00 | 21.19 |
| imported/rsc/reallyhard0-1mb | 51 | 533.52 ± 0.3% | not timed | not timed | 533.41 ± 0.2% | 25.31 ± 0.5% | not timed | not timed | 534.13 ± 0.2% | | 1.00 | 1.00 | 21.08 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.21 ± 2.1% | not timed | not timed | 179.59 ± 2.3% | 44.24 ± 12.1% | not timed | not timed | 274.46 ± 1.7% | | 1.00 | 1.53 | 6.20 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6881.48 ± 0.4% | not timed | not timed | 6394.21 ± 0.3% | 27.23 ± 0.3% | not timed | not timed | 6881.70 ± 14.3% | | 1.00 | 1.08 | 252.75 |
| imported/rsc/reallyreallyhard0-32k | 16 | 42234.04 ± 24.3% | not timed | not timed | 32671.91 ± 0.3% | 20.48 ± 0.7% | not timed | not timed | 46101.61 ± 0.2% | | 0.92 | 1.29 | 2062.08 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 57235.12 ± 2.6% | not timed | not timed | 38724.23 ± 2.2% | 19.98 ± 2.7% | not timed | not timed | 57923.20 ± 2.1% | | 0.99 | 1.48 | 2864.24 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 267.26 ± 11.6% | not timed | not timed | 189.65 ± 2.9% | 44.00 ± 5.8% | not timed | not timed | 267.21 ± 5.4% | | 1.00 | 1.41 | 6.07 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5582.12 ± 0.1% | not timed | not timed | 6421.52 ± 0.4% | 27.27 ± 0.6% | not timed | not timed | 5579.36 ± 1.0% | | 1.00 | 0.87 | 204.72 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 43482.90 ± 0.2% | not timed | not timed | 32872.39 ± 2.4% | 20.55 ± 0.2% | not timed | not timed | 43284.86 ± 0.1% | | 1.00 | 1.32 | 2116.42 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 53579.42 ± 3.5% | not timed | not timed | 39600.81 ± 27.7% | 20.46 ± 0.3% | not timed | not timed | 53869.07 ± 4.0% | | 0.99 | 1.35 | 2618.11 |
| imported/sherlock/name-sherlock | 776 | 38827.69 ± 9.4% | not timed | not timed | 31546.20 ± 2.8% | 9108.23 ± 24.1% | not timed | not timed | 39009.10 ± 2.4% | | 1.00 | 1.23 | 4.26 |
| imported/sherlock/name-holmes | 2766 | 20045.63 ± 1.3% | not timed | not timed | 18375.03 ± 1.1% | 2971.64 ± 18.9% | not timed | not timed | 19892.77 ± 2.5% | | 1.01 | 1.09 | 6.75 |
| imported/sherlock/name-sherlock-holmes | 1365 | 39401.56 ± 9.7% | not timed | not timed | 31881.48 ± 44.3% | 7454.09 ± 14.3% | not timed | not timed | 39310.68 ± 21.7% | | 1.00 | 1.24 | 5.29 |
| imported/sherlock/name-sherlock-casei | 816 | 31131.50 ± 1.0% | not timed | not timed | 9438.96 ± 0.1% | 23.97 ± 1.0% | not timed | not timed | 30928.20 ± 2.3% | | 1.01 | 3.30 | 1298.51 |
| imported/sherlock/name-holmes-casei | 2802 | 16884.97 ± 2.3% | not timed | not timed | 5872.68 ± 7.3% | 34.99 ± 23.0% | not timed | not timed | 16955.46 ± 2.3% | | 1.00 | 2.88 | 482.63 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 27982.65 ± 1.5% | not timed | not timed | 9051.61 ± 0.7% | 23.90 ± 0.7% | not timed | not timed | 28019.67 ± 1.6% | | 1.00 | 3.09 | 1171.02 |
| imported/sherlock/name-whitespace | 1461 | 22544.09 ± 10.9% | not timed | not timed | 22499.90 ± 0.9% | 6054.84 ± 18.6% | not timed | not timed | 22704.04 ± 1.0% | | 0.99 | 1.00 | 3.72 |
| imported/sherlock/name-alt1 | 1142 | 21516.72 ± 0.6% | not timed | not timed | 22726.12 ± 1.8% | 3685.93 ± 17.1% | not timed | not timed | 21614.06 ± 2.4% | | 1.00 | 0.95 | 5.84 |
| imported/sherlock/name-alt2 | 3542 | 13475.52 ± 1.8% | not timed | not timed | 7777.79 ± 0.5% | 27.15 ± 0.2% | not timed | not timed | 13516.52 ± 1.1% | | 1.00 | 1.73 | 496.36 |
| imported/sherlock/name-alt3 | 4507 | 9241.25 ± 0.7% | not timed | not timed | 6987.40 ± 0.8% | 8.55 ± 0.5% | not timed | not timed | 9277.72 ± 1.1% | | 1.00 | 1.32 | 1080.35 |
| imported/sherlock/name-alt3-casei | 4593 | 1590.85 ± 0.8% | not timed | not timed | 1086.78 ± 17.7% | 5.33 ± 0.8% | not timed | not timed | 1587.57 ± 1.3% | | 1.00 | 1.46 | 298.30 |
| imported/sherlock/name-alt4 | 3686 | 7290.84 ± 2.5% | not timed | not timed | 6073.78 ± 1.4% | 26.83 ± 28.1% | not timed | not timed | 7299.56 ± 0.3% | | 1.00 | 1.20 | 271.76 |
| imported/sherlock/name-alt4-casei | 4254 | 3161.89 ± 9.4% | not timed | not timed | 3159.46 ± 13.8% | 14.97 ± 0.6% | not timed | not timed | 3168.66 ± 0.7% | | 1.00 | 1.00 | 211.24 |
| imported/sherlock/name-alt5 | 4028 | 11417.61 ± 18.2% | not timed | not timed | 7412.10 ± 0.2% | 19.08 ± 2.4% | not timed | not timed | 11447.02 ± 1.0% | | 1.00 | 1.54 | 598.30 |
| imported/sherlock/name-alt5-casei | 4104 | 4818.73 ± 1.3% | not timed | not timed | 2403.84 ± 0.1% | 11.22 ± 3.1% | not timed | not timed | 4832.39 ± 1.6% | | 1.00 | 2.00 | 429.50 |
| imported/sherlock/no-match-uncommon | 0 | 54209.13 ± 3.0% | not timed | not timed | 47043.24 ± 0.6% | 44974.46 ± 2.3% | not timed | not timed | 54039.78 ± 1.7% | | 1.00 | 1.15 | 1.21 |
| imported/sherlock/no-match-common | 0 | 52186.83 ± 1.3% | not timed | not timed | 46971.85 ± 0.7% | 1570.17 ± 0.6% | not timed | not timed | 52110.32 ± 1.4% | | 1.00 | 1.11 | 33.24 |
| imported/sherlock/no-match-really-common | 0 | 32030.77 ± 3.5% | not timed | not timed | 28378.27 ± 1.4% | 1574.93 ± 0.2% | not timed | not timed | 32084.91 ± 2.6% | | 1.00 | 1.13 | 20.34 |
| imported/sherlock/the-lower | 21654 | 2476.66 ± 0.9% | not timed | not timed | 2184.43 ± 1.7% | 223.03 ± 15.2% | not timed | not timed | 2488.94 ± 3.9% | | 1.00 | 1.13 | 11.10 |
| imported/sherlock/the-upper | 2223 | 14430.04 ± 1.8% | not timed | not timed | 18145.55 ± 1.5% | 2402.27 ± 3.9% | not timed | not timed | 14580.60 ± 1.1% | | 0.99 | 0.80 | 6.01 |
| imported/sherlock/the-casei | 23961 | 2213.45 ± 5.4% | not timed | not timed | 1133.46 ± 0.5% | 31.81 ± 33.7% | not timed | not timed | 2217.62 ± 1.0% | | 1.00 | 1.95 | 69.58 |
| imported/sherlock/everything-greedy | 581881 | 247.41 ± 0.6% | not timed | not timed | 143.86 ± 1.3% | 23.62 ± 27.0% | not timed | not timed | 249.39 ± 0.3% | | 0.99 | 1.72 | 10.47 |
| imported/sherlock/everything-greedy-nl | 594933 | 406.30 ± 1.3% | not timed | not timed | 188.75 ± 0.1% | 26.59 ± 0.5% | not timed | not timed | 407.18 ± 0.2% | | 1.00 | 2.15 | 15.28 |
| imported/sherlock/letters | 447175 | 51.58 ± 22.2% | not timed | not timed | 29.62 ± 0.4% | 5.42 ± 38.8% | not timed | not timed | 56.75 ± 0.8% | | 0.91 | 1.74 | 9.52 |
| imported/sherlock/letters-upper | 14180 | 391.26 ± 1.0% | not timed | not timed | 323.79 ± 1.3% | 25.17 ± 22.5% | not timed | not timed | 390.89 ± 0.5% | | 1.00 | 1.21 | 15.54 |
| imported/sherlock/letters-lower | 432995 | 57.52 ± 1.6% | not timed | not timed | 30.86 ± 1.1% | 4.73 ± 34.2% | not timed | not timed | 57.49 ± 0.2% | | 1.00 | 1.86 | 12.17 |
| imported/sherlock/words | 447639 | 104.04 ± 7.2% | not timed | not timed | 72.81 ± 2.9% | 12.02 ± 12.3% | not timed | not timed | 103.01 ± 3.6% | | 1.01 | 1.43 | 8.66 |
| imported/sherlock/before-holmes | 4073 | 10763.49 ± 1.4% | not timed | not timed | 9796.74 ± 1.1% | 19.79 ± 1.5% | not timed | not timed | 10768.06 ± 2.8% | | 1.00 | 1.10 | 543.98 |
| imported/sherlock/before-after-holmes | 2593 | 10506.69 ± 2.7% | not timed | not timed | 11054.06 ± 0.6% | 19.80 ± 17.5% | not timed | not timed | 10499.41 ± 1.8% | | 1.00 | 0.95 | 530.75 |
| imported/sherlock/holmes-cochar-watson | 150 | 7363.36 ± 0.7% | not timed | not timed | 5561.17 ± 0.9% | 26.94 ± 3.0% | not timed | not timed | 7389.77 ± 1.3% | | 1.00 | 1.32 | 273.31 |
| imported/sherlock/holmes-coword-watson | 14309 | 1118.60 ± 0.3% | not timed | not timed | 1077.27 ± 0.2% | 5.24 ± 1.6% | not timed | not timed | 1120.46 ± 1.0% | | 1.00 | 1.04 | 213.44 |
| imported/sherlock/quotes | 14437 | 1109.93 ± 1.3% | not timed | not timed | 1533.24 ± 1.6% | 28.51 ± 2.6% | not timed | not timed | 1109.63 ± 1.4% | | 1.00 | 0.72 | 38.94 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 533.78 ± 1.3% | not timed | not timed | 25068.70 ± 3.9% | 31.66 ± 7.0% | not timed | not timed | 533.03 ± 0.9% | | 1.00 | 0.0213 | 16.86 |
| imported/sherlock/word-ending-n | 35297 | 411.25 ± 4.2% | not timed | not timed | 353.43 ± 1.3% | 19.75 ± 15.9% | not timed | not timed | 411.33 ± 0.1% | | 1.00 | 1.16 | 20.83 |
| imported/sherlock/repeated-class-negation | 2130 | 12668.34 ± 0.8% | not timed | not timed | 11913.17 ± 1.5% | 9.51 ± 1.2% | not timed | not timed | 12654.69 ± 1.8% | | 1.00 | 1.06 | 1331.79 |
| imported/sherlock/ing-suffix | 20547 | 492.29 ± 0.1% | not timed | not timed | 446.65 ± 1.0% | 24.17 ± 0.6% | not timed | not timed | 492.59 ± 0.2% | | 1.00 | 1.10 | 20.37 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 523.79 ± 0.3% | not timed | not timed | 1944.22 ± 0.2% | 16.86 ± 15.8% | not timed | not timed | 523.68 ± 0.3% | | 1.00 | 0.27 | 31.06 |
| opt/accelerate/whole-line | 239963 | 446.94 ± 0.3% | not timed | not timed | 345.41 ± 0.4% | 75.38 ± 18.2% | not timed | not timed | 446.15 ± 1.3% | | 1.00 | 1.29 | 5.93 |
| opt/accelerate/non-dna | 16745 | 390.57 ± 5.1% | not timed | not timed | 366.25 ± 2.0% | 24.77 ± 20.4% | not timed | not timed | 396.05 ± 6.7% | | 0.99 | 1.07 | 15.77 |
| opt/backtrack/words-english | 40536 | 105.95 ± 3.1% | not timed | not timed | 81.67 ± 23.2% | 15.88 ± 8.5% | not timed | not timed | 107.15 ± 6.3% | | 0.99 | 1.30 | 6.67 |
| opt/fixed-length/too-small-ascii | 0 | 291.78 ± 0.2% | not timed | not timed | 622.12 ± 0.4% | 99.33 ± 3.4% | not timed | not timed | 291.83 ± 41.9% | | 1.00 | 0.47 | 2.94 |
| opt/fixed-length/too-big-ascii | 0 | 3339.00 ± 0.5% | not timed | not timed | 4923.95 ± 3.4% | 115.43 ± 20.4% | not timed | not timed | 3343.25 ± 0.2% | | 1.00 | 0.68 | 28.93 |
| opt/fixed-length/go33484-1 | 0 | 642725.89 ± 0.1% | not timed | not timed | 945851.78 ± 1.5% | 67199.99 ± 1.6% | not timed | not timed | 642796.45 ± 0.2% | | 1.00 | 0.68 | 9.56 |
| opt/fixed-length/go33484-2 | 0 | 642336.66 ± 1.4% | not timed | not timed | 944562.81 ± 1.1% | 19343.65 ± 1.7% | not timed | not timed | 642156.55 ± 0.3% | | 1.00 | 0.68 | 33.21 |
| opt/fixed-length/go33484-3 | 0 | 2165.28 ± 0.9% | not timed | not timed | 94431.70 ± 1.0% | 746.46 ± 0.6% | not timed | not timed | 2141.86 ± 0.4% | | 1.01 | 0.0229 | 2.90 |
| opt/literal-alt/one-pattern | 1 | 490.29 ± 1.4% | not timed | not timed | 484.55 ± 0.3% | 0.30 ± 4.1% | not timed | not timed | 486.23 ± 1.2% | | 1.01 | 1.01 | 1607.69 |
| opt/onepass/fn-predicate | 916 | 315.02 ± 1.4% | not timed | not timed | 325.20 ± 0.8% | 176.03 ± 43.6% | not timed | not timed | 315.77 ± 0.9% | | 1.00 | 0.97 | 1.79 |
| opt/onepass/first-three-words-english | 35128 | 125.84 ± 4.5% | not timed | not timed | 186.17 ± 0.6% | 59.46 ± 18.6% | not timed | not timed | 128.26 ± 3.9% | | 0.98 | 0.68 | 2.12 |
| opt/prefilter/literal-english | 1 | 55390.74 ± 3.0% | not timed | not timed | 40052.69 ± 1.1% | 19396.88 ± 0.6% | not timed | not timed | 55469.55 ± 0.8% | | 1.00 | 1.38 | 2.86 |
| opt/prefilter/literal-casei-english | 1 | 32999.43 ± 11.4% | not timed | not timed | 11838.40 ± 1.3% | 24.19 ± 0.4% | not timed | not timed | 32572.62 ± 7.4% | | 1.01 | 2.79 | 1364.40 |
| opt/prefilter/literal-russian | 1 | 56142.57 ± 2.2% | not timed | not timed | 39701.63 ± 0.4% | 1583.04 ± 0.1% | not timed | not timed | 56267.43 ± 0.9% | | 1.00 | 1.41 | 35.47 |
| opt/prefilter/literal-casei-russian | 1 | 21796.42 ± 4.1% | not timed | not timed | 8198.02 ± 0.5% | 30.55 ± 0.9% | not timed | not timed | 21631.53 ± 4.3% | | 1.01 | 2.66 | 713.54 |
| opt/prefilter/rust-functions | 948 | 11503.05 ± 8.9% | not timed | not timed | 10345.66 ± 0.5% | 1556.41 ± 0.9% | not timed | not timed | 11659.28 ± 0.9% | | 0.99 | 1.11 | 7.39 |
| opt/reverse-anchored/word-end | 1 | 26334024.17 ± 0.5% | not timed | not timed | 22711272.35 ± 0.4% | 41.85 ± 0.7% | not timed | not timed | 26413532.46 ± 0.2% | | 1.00 | 1.16 | 629282.10 |
| opt/reverse-inner/holmes | 2593 | 10599.77 ± 0.9% | not timed | not timed | 11131.68 ± 0.7% | 20.27 ± 0.6% | not timed | not timed | 10599.51 ± 1.2% | | 1.00 | 0.95 | 522.82 |
| opt/reverse-inner/email | 47 | 62904.47 ± 6.0% | not timed | not timed | 72551.90 ± 1.9% | 27.70 ± 6.6% | not timed | not timed | 65193.91 ± 4.3% | | 0.96 | 0.87 | 2270.72 |
| opt/reverse-inner/factored-prefix | 3542 | 526.04 ± 0.3% | not timed | not timed | 515.63 ± 0.5% | 11.08 ± 1.6% | not timed | not timed | 525.34 ± 0.3% | | 1.00 | 1.02 | 47.47 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3642.12 ± 0.3% | not timed | not timed | 532.90 ± 1.1% | 64.53 ± 0.5% | not timed | not timed | 3646.11 ± 0.2% | | 1.00 | 6.83 | 56.44 |
| opt/reverse-inner/no-quadratic-forward | 0 | 622.59 ± 4.8% | not timed | not timed | 246.11 ± 0.7% | 11.60 ± 0.5% | not timed | not timed | 622.98 ± 4.9% | | 1.00 | 2.53 | 53.66 |
| opt/reverse-suffix/holmes | 4073 | 10799.64 ± 0.9% | not timed | not timed | 9800.25 ± 0.5% | 19.93 ± 0.5% | not timed | not timed | 10758.91 ± 3.4% | | 1.00 | 1.10 | 541.80 |
| opt/reverse-suffix/no-quadratic | 0 | 3640.90 ± 0.4% | not timed | not timed | 532.08 ± 0.9% | 64.64 ± 0.6% | not timed | not timed | 3644.48 ± 0.2% | | 1.00 | 6.84 | 56.32 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 108.80 ± 1.7% | not timed | not timed | 136.94 ± 0.5% | 9.66 ± 18.1% | not timed | not timed | 108.72 ± 1.7% | | 1.00 | 0.79 | 11.27 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 108.72 ± 2.1% | not timed | not timed | 136.07 ± 0.7% | 9.83 ± 17.3% | not timed | not timed | 108.99 ± 1.5% | | 1.00 | 0.80 | 11.06 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.26 ± 0.6% | not timed | not timed | 0.40 ± 8.8% | 93.37 ± 24.8% | not timed | not timed | 0.27 ± 0.3% | | 0.97 | 0.64 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 266.07 ± 0.9% | not timed | not timed | 245.63 ± 0.0% | 81.19 ± 0.5% | not timed | not timed | 268.12 ± 2.3% | | 0.99 | 1.08 | 3.28 |
| reported/i13-subset-regex/original-ascii | 4094 | 9819.15 ± 3.4% | not timed | not timed | 3110.98 ± 3.8% | 9.66 ± 3.6% | not timed | not timed | 9888.42 ± 3.2% | | 0.99 | 3.16 | 1016.69 |
| reported/i13-subset-regex/original-unicode | 4094 | 9651.51 ± 3.1% | not timed | not timed | 171.28 ± 2.0% | 9.66 ± 0.8% | not timed | not timed | 9610.68 ± 0.5% | | 1.00 | 56.35 | 999.19 |
| reported/i13-subset-regex/big-ascii | 1955 | 9225.67 ± 2.6% | not timed | not timed | 44.59 ± 3.2% | 8.25 ± 0.5% | not timed | not timed | 9279.97 ± 2.9% | | 0.99 | 206.91 | 1118.24 |
| reported/i13-subset-regex/big-unicode | 1955 | 9144.32 ± 1.3% | not timed | not timed | 7.89 ± 56.3% | 8.18 ± 1.2% | not timed | not timed | 9189.54 ± 2.7% | | 1.00 | 1159.04 | 1118.14 |
| reported/i13-subset-regex/huge-ascii | 55 | 8560.93 ± 6.8% | not timed | not timed | 7.28 ± 0.8% | 7.27 ± 0.7% | not timed | not timed | 8628.85 ± 7.0% | | 0.99 | 1175.27 | 1178.21 |
| reported/i13-subset-regex/huge-unicode | 55 | 8523.31 ± 1.8% | not timed | not timed | 6.72 ± 0.3% | 7.26 ± 1.3% | not timed | not timed | 8551.74 ± 2.3% | | 1.00 | 1268.01 | 1174.48 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.11 ± 0.6% | not timed | not timed | 7.27 ± 1.5% | 7.29 ± 1.0% | not timed | not timed | 3.11 ± 0.9% | | 1.00 | 0.43 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.39 ± 0.7% | not timed | not timed | 7.14 ± 0.8% | 7.26 ± 1.1% | not timed | not timed | 4.38 ± 0.3% | | 1.00 | 0.62 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 419.35 ± 0.2% | not timed | not timed | 120.77 ± 0.7% | 5.41 ± 1.0% | not timed | not timed | 422.24 ± 0.6% | | 0.99 | 3.47 | 77.50 |
| reported/i787-keywords/opt-ascii | 5674 | 420.84 ± 0.5% | not timed | not timed | 206.59 ± 8.8% | 8.87 ± 0.5% | not timed | not timed | 422.88 ± 0.2% | | 1.00 | 2.04 | 47.43 |
| slow/quadratic-regex-1x | 100 | 6.47 ± 7.3% | not timed | not timed | 4.63 ± 0.3% | 0.02 ± 0.2% | not timed | not timed | 6.32 ± 13.0% | | 1.02 | 1.40 | 344.19 |
| slow/quadratic-regex-2x | 199 | 3.02 ± 4.7% | not timed | not timed | 2.49 ± 0.3% | 0.00 ± 9.0% | not timed | not timed | 2.97 ± 4.9% | | 1.02 | 1.21 | 625.82 |
| slow/quadratic-haystack-1x | 100 | 21.44 ± 0.4% | not timed | not timed | 9.11 ± 2.1% | 0.81 ± 24.8% | not timed | not timed | 21.38 ± 6.7% | | 1.00 | 2.35 | 26.38 |
| slow/quadratic-haystack-2x | 200 | 16.36 ± 1.5% | not timed | not timed | 4.92 ± 0.4% | 0.42 ± 26.7% | not timed | not timed | 16.17 ± 1.7% | | 1.01 | 3.33 | 38.80 |
| unicode/codepoints/any-one | 1112064 | 276.70 ± 9.6% | not timed | not timed | 185.58 ± 1.6% | 16.20 ± 19.2% | not timed | not timed | 277.13 ± 2.2% | | 1.00 | 1.49 | 17.07 |
| unicode/codepoints/any-all | 4382592 | 235.79 ± 0.3% | not timed | not timed | 234.49 ± 7.2% | 98.84 ± 28.3% | not timed | not timed | 235.39 ± 1.4% | | 1.00 | 1.01 | 2.39 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.30 ± 0.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 534.12 ± 0.1% | not timed | not timed | 532.04 ± 0.9% | 121.37 ± 1.5% | not timed | not timed | 533.62 ± 0.4% | | 1.00 | 1.00 | 4.40 |
| unicode/overlapping-words/ascii | 6156 | 21.29 ± 4.8% | not timed | not timed | 33.93 ± 1.1% | 3.45 ± 1.9% | not timed | not timed | 21.32 ± 13.6% | | 1.00 | 0.63 | 6.17 |
| unicode/overlapping-words/english | 6156 | 1.12 ± 1.4% | not timed | not timed | 2.71 ± 0.3% | 2.15 ± 2.2% | not timed | not timed | 1.13 ± 25.8% | | 1.00 | 0.41 | 0.52 |
| unicode/overlapping-words/russian | 5710 | 1.05 ± 0.4% | not timed | not timed | 2.56 ± 0.5% | 5.30 ± 59.9% | not timed | not timed | 1.04 ± 0.3% | | 1.00 | 0.41 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 112.14 ± 3.9% | not timed | not timed | 73.11 ± 0.7% | 8.65 ± 17.3% | not timed | not timed | 113.78 ± 5.4% | | 0.99 | 1.53 | 12.96 |
| unicode/word/boundary-long-english | 3466 | 535.70 ± 0.2% | not timed | not timed | 523.06 ± 0.2% | 26.68 ± 11.4% | not timed | not timed | 536.03 ± 0.9% | | 1.00 | 1.02 | 20.08 |
| unicode/word/around-holmes-english | 27 | 42816.61 ± 2.1% | not timed | not timed | 38394.59 ± 31.3% | 18.53 ± 0.2% | not timed | not timed | 43078.95 ± 1.5% | | 0.99 | 1.12 | 2311.10 |
| wild/bibleref/long | 874 | 487.59 ± 0.7% | not timed | not timed | 500.49 ± 0.4% | 6.38 ± 1.3% | not timed | not timed | 488.69 ± 0.3% | | 1.00 | 0.97 | 76.46 |
| wild/bibleref/short | 30 | 16.56 ± 1.5% | not timed | not timed | 24.89 ± 0.5% | 9.77 ± 13.6% | not timed | not timed | 16.93 ± 0.8% | | 0.98 | 0.67 | 1.69 |
| wild/bibleref/line | 874 | 399.92 ± 0.7% | not timed | not timed | 212.10 ± 9.3% | 7.37 ± 2.4% | not timed | not timed | 400.03 ± 2.1% | | 1.00 | 1.89 | 54.26 |
| wild/caddy/caddy | 6 | 342.65 ± 2.1% | not timed | not timed | 243.95 ± 0.6% | 61.25 ± 27.7% | not timed | not timed | 341.37 ± 8.8% | | 1.00 | 1.40 | 5.59 |
| wild/dot-star-capture/rust-src-tools | 6 | 1274.68 ± 19.0% | not timed | not timed | 353.85 ± 4.5% | 11.18 ± 2.8% | not timed | not timed | 1278.84 ± 23.0% | | 1.00 | 3.60 | 114.03 |
| wild/ruff/noqa | 84 | 431.04 ± 1.8% | not timed | not timed | 427.78 ± 0.2% | 15.91 ± 9.4% | not timed | not timed | 427.38 ± 1.8% | | 1.01 | 1.01 | 27.10 |
| wild/ruff/unnecessary-coding-comment | 16 | 915.98 ± 1.3% | not timed | not timed | 604.94 ± 1.1% | 66.30 ± 3.3% | not timed | not timed | 916.56 ± 3.2% | | 1.00 | 1.51 | 13.82 |
| wild/ruff/string-quote-prefix | 2972 | 1293.56 ± 0.8% | not timed | not timed | 346.18 ± 0.6% | 303.94 ± 33.7% | not timed | not timed | 1301.94 ± 0.4% | | 0.99 | 3.74 | 4.26 |
| wild/ruff/space-around-operator | 1224378 | 185.22 ± 6.9% | not timed | not timed | 181.88 ± 3.7% | 14.61 ± 4.1% | not timed | not timed | 188.67 ± 1.3% | | 0.98 | 1.02 | 12.68 |
| wild/ruff/shebang | 282 | 927.10 ± 0.9% | not timed | not timed | 321.35 ± 3.3% | 82.77 ± 11.6% | not timed | not timed | 925.80 ± 10.0% | | 1.00 | 2.89 | 11.20 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16843.18 ± 4.2% | not timed | not timed | 18892.56 ± 6.7% | 6337.78 ± 0.9% | not timed | not timed | 16579.82 ± 3.7% | | 1.02 | 0.89 | 2.66 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15251.20 ± 1.7% | not timed | not timed | 18057.76 ± 4.9% | 5936.82 ± 1.1% | not timed | not timed | 15312.98 ± 19.8% | | 1.00 | 0.84 | 2.57 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 16797.37 ± 2.3% | not timed | not timed | 19389.34 ± 16.1% | 6010.32 ± 3.8% | not timed | not timed | 16839.04 ± 1.4% | | 1.00 | 0.87 | 2.79 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13845.30 ± 2.1% | not timed | not timed | 17676.68 ± 6.9% | 6164.39 ± 0.9% | not timed | not timed | 13784.21 ± 1.4% | | 1.00 | 0.78 | 2.25 |
| wild/url/search | 234965 | 102.05 ± 14.9% | not timed | not timed | 49.89 ± 2.4% | 1.89 ± 17.9% | not timed | not timed | 103.91 ± 13.9% | | 0.98 | 2.05 | 53.92 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 2.8% | not timed | not timed | 0.01 ± 13.2% | 0.01 ± 28.0% | not timed | not timed | 0.02 ± 44.5% | | 0.99 | 2.52 | 4.33 |
| dictionary/compile/english-15 | 1 | 0.28 ± 5.9% | not timed | not timed | 0.07 ± 2.1% | 0.09 ± 8.4% | not timed | not timed | 0.29 ± 21.4% | | 1.00 | 3.83 | 3.11 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 17.6% | not timed | not timed | 0.02 ± 5.8% | 29.58 ± 7.2% | not timed | not timed | 0.21 ± 2.4% | | 1.00 | 11.78 | 0.0072 |
| reported/i1095-word-repetition/ascii-compile | 1 | 35.11 ± 12.2% | not timed | not timed | 13.46 ± 5.3% | 47.93 ± 20.2% | not timed | not timed | 35.66 ± 14.1% | | 0.98 | 2.61 | 0.73 |
| reported/i787-keywords/compile | 1 | 29.86 ± 16.5% | not timed | not timed | 1.97 ± 0.7% | 15.74 ± 11.9% | not timed | not timed | 30.24 ± 3.0% | | 0.99 | 15.17 | 1.90 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 277.82 ± 7.0% | not timed | not timed | 115.31 ± 11.8% | 494.39 ± 30.7% | not timed | not timed | 285.58 ± 9.8% | | 0.97 | 2.41 | 0.56 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 39.19 ± 12.5% | not timed | not timed | 4.28 ± 0.8% | 38.31 ± 11.3% | not timed | not timed | 40.75 ± 11.3% | | 0.96 | 9.16 | 1.02 |
| unicode/compile/one-letter | 53 | 5.42 ± 2.5% | not timed | not timed | 4.46 ± 2.3% | 54.87 ± 25.6% | not timed | not timed | 5.50 ± 1.5% | | 0.99 | 1.22 | 0.0989 |
| unicode/compile/fifty-letters | 1 | 0.91 ± 5.3% | not timed | not timed | 0.10 ± 0.8% | 57.20 ± 18.7% | not timed | not timed | 0.92 ± 3.2% | | 0.99 | 8.89 | 0.0159 |
| unicode/compile/fifty-letters-ascii | 1 | 161.97 ± 3.1% | not timed | not timed | 56.24 ± 0.3% | 168.41 ± 29.9% | not timed | not timed | 162.51 ± 8.1% | | 1.00 | 2.88 | 0.96 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 348.65 ± 10.0% | not timed | not timed | 37.70 ± 8.7% | 549.18 ± 36.1% | not timed | not timed | 348.96 ± 0.9% | | 1.00 | 9.25 | 0.63 |
| unicode/compile/match-every-line-ascii | 4 | 517.24 ± 5.6% | not timed | not timed | 133.05 ± 1.1% | 590.55 ± 39.3% | not timed | not timed | 526.50 ± 4.6% | | 0.98 | 3.89 | 0.88 |
| unicode/compile/negated-class-matches-codepoint | 1 | 282.04 ± 7.3% | not timed | not timed | 42.11 ± 1.3% | 1080.45 ± 7.1% | not timed | not timed | 281.51 ± 7.5% | | 1.00 | 6.70 | 0.26 |
| wild/bibleref/compile | 3 | 4.63 ± 12.6% | not timed | not timed | 1.94 ± 1.5% | 29.24 ± 11.9% | not timed | not timed | 4.87 ± 23.0% | | 0.95 | 2.39 | 0.16 |
| wild/url/compile | 1 | 0.54 ± 10.6% | not timed | not timed | 0.17 ± 1.2% | 0.37 ± 19.1% | not timed | not timed | 0.54 ± 2.7% | | 1.00 | 3.29 | 1.46 |

