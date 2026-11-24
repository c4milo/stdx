# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391564911 |
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
| literal: a word | 217 | 19113.02 ± 2.1% | 5033.27 ± 0.2% | 27.67 ± 0.3% | 17938.28 ± 1.0% | 9283.16 ± 7.4% | 17.61 ± 0.6% | 84.33 ± 0.9% | 19142.56 ± 1.3% | 3.80 | 1.00 | 1.07 | 2.06 |
| literal: a word that is not there | 0 | 20945.52 ± 1.0% | 4916.02 ± 0.3% | 27.83 ± 0.2% | 19323.97 ± 1.2% | 27126.64 ± 3.0% | 17.43 ± 0.0% | 79.81 ± 0.3% | 20963.68 ± 0.3% | 4.26 | 1.00 | 1.08 | 0.77 |
| literal: one of four words | 661 | 6350.84 ± 0.2% | 1948.60 ± 0.4% | 14.20 ± 0.2% | 3943.75 ± 0.4% | 21.88 ± 0.2% | 5.31 ± 0.2% | 6.87 ± 0.3% | 6358.59 ± 0.9% | 3.26 | 1.00 | 1.61 | 290.26 |
| literal: a word in any case | 217 | 14993.27 ± 0.6% | 2087.94 ± 0.3% | 21.11 ± 0.1% | 3955.68 ± 0.3% | 38.05 ± 0.2% | refused | differs | 15017.23 ± 1.3% | 7.18 | 1.00 | 3.79 | 394.04 |
| literal: an href attribute | 33 | 16729.85 ± 1.8% | 608.92 ± 0.3% | 26.62 ± 0.4% | 17126.98 ± 1.4% | 2260.92 ± 0.7% | 13.45 ± 0.1% | 74.16 ± 0.2% | 16741.84 ± 1.8% | 27.47 | 1.00 | 0.98 | 7.40 |
| literal: a word, second text | 123 | 20043.69 ± 3.5% | 3393.07 ± 0.3% | 27.28 ± 0.2% | 18426.44 ± 2.8% | 7631.26 ± 7.3% | 19.60 ± 0.3% | 70.24 ± 0.7% | 19942.45 ± 2.7% | 5.91 | 1.01 | 1.09 | 2.63 |
| class: two capitalized words | 1331 | 1069.03 ± 0.3% | 598.72 ± 0.4% | 25.37 ± 0.1% | 581.49 ± 0.3% | 40.67 ± 11.5% | 15.07 ± 0.1% | 67.49 ± 0.4% | 1070.82 ± 0.5% | 1.79 | 1.00 | 1.84 | 26.29 |
| class: a word that ends in ing | 3399 | 572.67 ± 0.3% | 570.56 ± 0.3% | 17.71 ± 0.2% | 545.21 ± 0.1% | 29.62 ± 9.9% | 8.22 ± 0.2% | 18.44 ± 0.2% | 571.40 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.33 |
| class: a word in capitals | 2332 | 1373.10 ± 0.3% | 603.88 ± 0.3% | 26.87 ± 0.3% | 572.29 ± 0.2% | 43.58 ± 7.4% | 17.28 ± 0.3% | 82.63 ± 0.5% | 1373.17 ± 0.5% | 2.27 | 1.00 | 2.40 | 31.51 |
| class: a number | 8288 | 1997.79 ± 0.1% | 829.19 ± 0.1% | 27.09 ± 0.3% | 1728.80 ± 0.4% | 41.86 ± 16.3% | 0.57 ± 0.2% | 57.47 ± 0.7% | 2000.24 ± 0.3% | 2.41 | 1.00 | 1.16 | 47.73 |
| class: two capitalized words, second text | 5359 | 516.11 ± 0.4% | 524.07 ± 0.2% | 22.77 ± 0.1% | 486.31 ± 0.0% | 35.46 ± 13.8% | 17.00 ± 0.4% | 62.87 ± 0.2% | 517.06 ± 0.1% | 0.98 | 1.00 | 1.06 | 14.56 |
| other: a word between two words | 6104 | 792.25 ± 0.4% | 592.22 ± 0.4% | 23.09 ± 0.0% | 734.79 ± 0.3% | 108.50 ± 13.6% | 11.48 ± 0.2% | 68.31 ± 0.1% | 791.56 ± 0.6% | 1.34 | 1.00 | 1.08 | 7.30 |
| other: a number before a unit, second text | 1481 | 5992.86 ± 1.4% | 1121.98 ± 0.2% | 25.44 ± 0.2% | 5689.44 ± 0.6% | 40.86 ± 0.1% | 17.97 ± 0.1% | 65.84 ± 0.3% | 5982.20 ± 1.1% | 5.34 | 1.00 | 1.05 | 146.67 |
| other: a heading's start tag | 110 | 13989.87 ± 1.4% | 743.09 ± 0.2% | 26.77 ± 0.0% | 1709.96 ± 0.2% | 1573.23 ± 2.5% | 16.41 ± 0.4% | 86.15 ± 0.4% | 13906.39 ± 2.6% | 18.83 | 1.01 | 8.18 | 8.89 |
| other: a whole word | 217 | 15723.08 ± 0.6% | 600.95 ± 0.2% | 28.65 ± 0.3% | 14562.06 ± 1.7% | 49.44 ± 0.1% | 13.90 ± 0.1% | 54.86 ± 0.1% | 15761.78 ± 1.1% | 26.16 | 1.00 | 1.08 | 318.03 |
| other: a line's first word, second text | 3716 | 2042.28 ± 0.4% | 587.77 ± 0.2% | 29.99 ± 0.2% | 1728.33 ± 0.3% | 62.21 ± 11.1% | refused | refused | 2045.38 ± 1.0% | 3.47 | 1.00 | 1.18 | 32.83 |
| other: fourteen octets before an x | 87 | 23892.51 ± 1.7% | 243.30 ± 0.4% | 6.28 ± 0.1% | 4040.53 ± 1.1% | 10.66 ± 0.1% | differs | 17.77 ± 0.3% | 23426.19 ± 6.3% | 98.20 | 1.02 | 5.91 | 2242.20 |
| other: a Greek word | 21815 | 498.84 ± 0.2% | 413.16 ± 0.2% | 30.33 ± 0.2% | 290.36 ± 0.2% | 49.69 ± 12.1% | differs | refused | 500.05 ± 0.4% | 1.21 | 1.00 | 1.72 | 10.04 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.55 ± 0.2% | 19.51 ± 0.2% | 0.85 ± 0.2% | 19.49 ± 0.6% | 2.76 ± 0.4% | differs | 4.06 ± 0.1% | 19.25 ± 0.1% | 1.00 | 1.02 | 1.00 | 7.09 |
| a UUID | 32895 | 21.07 ± 0.3% | 21.08 ± 0.2% | 0.64 ± 0.2% | 15.06 ± 0.6% | 3.12 ± 0.2% | 0.72 ± 0.2% | 3.64 ± 0.5% | 21.08 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.76 |
| an IPv4 address | 33176 | 35.98 ± 0.1% | 35.98 ± 0.2% | 2.05 ± 0.1% | 29.04 ± 0.4% | 6.65 ± 0.3% | differs | 4.16 ± 0.4% | 35.99 ± 0.2% | 1.00 | 1.00 | 1.24 | 5.41 |
| a date and time | 32954 | 31.04 ± 0.6% | 30.89 ± 0.7% | 1.43 ± 0.1% | 21.40 ± 0.2% | 7.04 ± 0.2% | 1.20 ± 0.1% | 7.09 ± 0.4% | 30.99 ± 0.4% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 23.14 ± 0.5% | 23.06 ± 0.5% | 1.01 ± 0.4% | 23.14 ± 0.4% | 3.44 ± 0.5% | differs | 2.98 ± 0.2% | 23.06 ± 0.2% | 1.00 | 1.00 | 1.00 | 6.73 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 1.1% | 11.11 ± 4.4% | 11.09 ± 4.1% | 11.55 ± 0.1% | 5.00 ± 1.4% | 0.92 ± 0.3% | none | 11.09 ± 4.0% | 1.00 | 1.00 | 0.96 | 2.23 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.94 ± 0.4% | 224.32 ± 0.4% | 274.33 ± 1.0% | 87.08 ± 0.2% | 223.70 ± 0.3% | 478.87 ± 0.9% | 3761.07 ± 0.3% | 224.64 ± 1.0% | 0.99 | 0.99 | 2.56 | 1.00 |
| a UUID | 62 | 148.30 ± 1.1% | 149.07 ± 0.8% | 169.38 ± 0.5% | 45.98 ± 0.4% | 100.27 ± 0.8% | 180.82 ± 1.4% | 4134.98 ± 0.6% | 148.49 ± 0.4% | 0.99 | 1.00 | 3.22 | 1.48 |
| an IPv4 address | 29 | 406.44 ± 0.5% | 411.14 ± 0.5% | 594.62 ± 0.5% | 77.02 ± 0.9% | 131.87 ± 2.5% | 288.67 ± 0.9% | 7404.10 ± 0.3% | 405.34 ± 0.5% | 0.99 | 1.00 | 5.28 | 3.08 |
| a date and time | 56 | 294.62 ± 0.5% | 297.26 ± 0.1% | 382.39 ± 0.1% | 72.53 ± 0.7% | 138.82 ± 0.5% | 316.17 ± 2.2% | 4754.13 ± 0.5% | 294.73 ± 0.2% | 0.99 | 1.00 | 4.06 | 2.12 |
| a field path | 39 | 214.45 ± 1.9% | 217.56 ± 2.3% | 264.38 ± 2.1% | 79.44 ± 0.2% | 206.67 ± 1.4% | 492.80 ± 2.0% | 4821.66 ± 0.6% | 217.53 ± 0.5% | 0.99 | 0.99 | 2.70 | 1.04 |
| literal: a word | 7 | 594.10 ± 0.5% | 643.56 ± 0.4% | 1221.08 ± 0.6% | 522.11 ± 0.1% | 636.51 ± 2.2% | 923.00 ± 0.3% | 28880.15 ± 0.2% | 595.13 ± 0.4% | 0.92 | 1.00 | 1.14 | 0.93 |
| literal: a word that is not there | 8 | 570.47 ± 0.2% | 622.07 ± 0.5% | 1143.98 ± 0.6% | 468.80 ± 0.3% | 610.80 ± 1.4% | 874.00 ± 0.7% | 28065.44 ± 0.2% | 570.94 ± 0.4% | 0.92 | 1.00 | 1.22 | 0.93 |
| literal: one of four words | 26 | 235.06 ± 0.2% | 383.67 ± 0.4% | 541.60 ± 0.1% | 49.20 ± 1.1% | 246.43 ± 1.2% | 355.28 ± 2.8% | 15573.88 ± 0.5% | 235.14 ± 0.2% | 0.61 | 1.00 | 4.78 | 0.95 |
| literal: a word in any case | 11 | 431.85 ± 0.2% | 461.00 ± 0.1% | 707.79 ± 0.1% | 15.65 ± 0.2% | 663.95 ± 2.4% | refused | 23015.57 ± 0.5% | 431.77 ± 0.2% | 0.94 | 1.00 | 27.59 | 0.65 |
| literal: an href attribute | 12 | 328.64 ± 0.5% | 341.34 ± 0.4% | 463.96 ± 0.7% | 45.21 ± 1.1% | 504.09 ± 5.5% | 767.37 ± 0.4% | 20999.28 ± 0.6% | 329.64 ± 0.2% | 0.96 | 1.00 | 7.27 | 0.65 |
| literal: a word, second text | 10 | 532.25 ± 0.5% | 586.23 ± 0.5% | 1036.58 ± 0.6% | 415.30 ± 4.2% | 541.01 ± 4.2% | 792.17 ± 0.7% | 26198.11 ± 0.2% | 532.55 ± 0.4% | 0.91 | 1.00 | 1.28 | 0.98 |
| class: two capitalized words | 23 | 415.41 ± 0.3% | 450.94 ± 0.6% | 672.52 ± 0.3% | 101.43 ± 0.1% | 507.11 ± 2.2% | 735.03 ± 1.0% | 6395.49 ± 0.7% | 416.01 ± 0.3% | 0.92 | 1.00 | 4.10 | 0.82 |
| class: a word that ends in ing | 9 | 519.78 ± 0.3% | 588.75 ± 0.6% | 1091.30 ± 0.4% | 133.35 ± 0.6% | 765.55 ± 0.6% | 1096.54 ± 0.8% | 15595.48 ± 1.2% | 520.19 ± 0.3% | 0.88 | 1.00 | 3.90 | 0.68 |
| class: a word in capitals | 16 | 460.89 ± 0.1% | 505.95 ± 0.5% | 850.56 ± 0.3% | 137.10 ± 1.2% | 758.25 ± 1.7% | 1011.70 ± 0.5% | 8389.13 ± 0.4% | 460.77 ± 0.3% | 0.91 | 1.00 | 3.36 | 0.61 |
| class: a number | 6 | 577.01 ± 0.1% | 650.18 ± 0.4% | 1305.23 ± 0.1% | 41.92 ± 0.6% | 1401.43 ± 1.6% | 1868.66 ± 0.7% | 21866.56 ± 0.2% | 576.92 ± 0.4% | 0.89 | 1.00 | 13.76 | 0.41 |
| class: two capitalized words, second text | 23 | 415.64 ± 0.2% | 449.99 ± 0.6% | 673.51 ± 0.5% | 101.29 ± 2.0% | 507.94 ± 1.4% | 761.02 ± 0.6% | 6399.42 ± 0.4% | 416.08 ± 0.4% | 0.92 | 1.00 | 4.10 | 0.82 |
| other: a word between two words | 13 | 515.28 ± 0.3% | 534.40 ± 0.2% | 891.93 ± 0.2% | 135.93 ± 0.2% | 510.84 ± 1.5% | 813.78 ± 1.0% | 14312.49 ± 0.4% | 515.55 ± 0.4% | 0.96 | 1.00 | 3.79 | 1.01 |
| other: a number before a unit, second text | 15 | 374.69 ± 0.5% | 417.25 ± 0.7% | 611.90 ± 0.0% | 39.49 ± 1.2% | 644.27 ± 0.7% | 886.40 ± 0.5% | 14870.24 ± 0.6% | 376.88 ± 0.3% | 0.90 | 0.99 | 9.49 | 0.58 |
| other: a heading's start tag | 13 | 343.14 ± 0.6% | 350.34 ± 0.3% | 474.60 ± 0.9% | 43.27 ± 0.5% | 635.15 ± 1.0% | 863.78 ± 0.2% | 17483.78 ± 0.2% | 343.12 ± 0.4% | 0.98 | 1.00 | 7.93 | 0.54 |
| other: a whole word | 11 | 553.15 ± 0.3% | 588.26 ± 0.5% | 1036.28 ± 0.1% | 120.51 ± 1.1% | 576.47 ± 1.7% | 828.40 ± 0.4% | 26171.66 ± 0.4% | 552.83 ± 0.5% | 0.94 | 1.00 | 4.59 | 0.96 |
| other: a line's first word, second text | 17 | 495.68 ± 0.7% | 518.33 ± 0.7% | 876.20 ± 0.7% | 129.43 ± 0.7% | 712.15 ± 1.2% | refused | refused | 497.76 ± 0.4% | 0.96 | 1.00 | 3.83 | 0.70 |
| other: fourteen octets before an x | 16 | 106.89 ± 1.3% | 153.11 ± 1.1% | 180.58 ± 1.4% | 15.25 ± 0.1% | 456.52 ± 9.2% | 408.75 ± 0.3% | 12530.14 ± 0.3% | 107.33 ± 0.5% | 0.70 | 1.00 | 7.01 | 0.23 |
| other: a Greek word | 8 | 406.02 ± 0.1% | 557.08 ± 0.5% | 989.92 ± 0.8% | 59.32 ± 1.1% | 1395.67 ± 1.8% | 1832.21 ± 0.5% | refused | 405.88 ± 0.1% | 0.73 | 1.00 | 6.84 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15739.04 ± 0.4% | not timed | not timed | 16327.06 ± 0.8% | 2149.03 ± 13.8% | not timed | not timed | 15715.97 ± 1.7% | | 1.00 | 0.96 | 7.32 |
| 01-literal/sherlock-casei-en | 522 | 11028.47 ± 5.6% | not timed | not timed | 3593.85 ± 0.3% | 32.47 ± 7.1% | not timed | not timed | 10890.02 ± 4.9% | | 1.01 | 3.07 | 339.63 |
| 01-literal/sherlock-ru | 724 | 17154.92 ± 0.4% | not timed | not timed | 17270.70 ± 0.7% | 1372.77 ± 17.0% | not timed | not timed | 17178.87 ± 0.7% | | 1.00 | 0.99 | 12.50 |
| 01-literal/sherlock-casei-ru | 746 | 6200.17 ± 0.6% | not timed | not timed | 3327.74 ± 0.2% | 30.81 ± 0.3% | not timed | not timed | 6204.25 ± 0.5% | | 1.00 | 1.86 | 201.24 |
| 01-literal/sherlock-zh | 30 | 19894.53 ± 1.1% | not timed | not timed | 18813.02 ± 1.8% | 2674.22 ± 20.0% | not timed | not timed | 19891.74 ± 0.7% | | 1.00 | 1.06 | 7.44 |
| 02-literal-alternate/sherlock-en | 714 | 6067.40 ± 0.3% | not timed | not timed | 3944.75 ± 0.3% | 16.63 ± 0.2% | not timed | not timed | 6063.58 ± 0.3% | | 1.00 | 1.54 | 364.85 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1983.82 ± 1.6% | not timed | not timed | 699.81 ± 0.2% | 11.13 ± 0.1% | not timed | not timed | 1986.79 ± 0.9% | | 1.00 | 2.83 | 178.29 |
| 02-literal-alternate/sherlock-ru | 899 | 5566.07 ± 0.2% | not timed | not timed | 3254.93 ± 0.1% | 22.64 ± 0.1% | not timed | not timed | 5562.28 ± 0.2% | | 1.00 | 1.71 | 245.89 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.47 ± 0.6% | not timed | not timed | 1234.03 ± 0.1% | 9.11 ± 0.1% | not timed | not timed | 2060.39 ± 0.5% | | 1.00 | 1.67 | 225.80 |
| 02-literal-alternate/sherlock-zh | 207 | 7316.91 ± 0.8% | not timed | not timed | 4156.95 ± 0.3% | 31.50 ± 0.1% | not timed | not timed | 7300.53 ± 0.3% | | 1.00 | 1.76 | 232.30 |
| 03-date/ascii | 111817 | 124.98 ± 0.6% | not timed | not timed | 95.82 ± 0.2% | 0.21 ± 4.3% | not timed | not timed | 124.87 ± 0.5% | | 1.00 | 1.30 | 602.57 |
| 04-ruff-noqa/real | 84 | 404.22 ± 0.1% | not timed | not timed | 465.95 ± 0.1% | 19.54 ± 1.3% | not timed | not timed | 404.71 ± 0.2% | | 1.00 | 0.87 | 20.69 |
| 04-ruff-noqa/tweaked | 44 | 558.53 ± 0.3% | not timed | not timed | 458.51 ± 0.1% | 362.94 ± 2.0% | not timed | not timed | 557.31 ± 0.5% | | 1.00 | 1.22 | 1.54 |
| 05-lexer-veryl/single | 124800 | 5.29 ± 0.7% | not timed | not timed | 4.94 ± 0.1% | 0.21 ± 2.6% | not timed | not timed | 5.31 ± 0.4% | | 1.00 | 1.07 | 25.50 |
| 06-cloud-flare-redos/original | 107 | 415.31 ± 0.1% | not timed | not timed | 215.15 ± 0.1% | 24.92 ± 0.2% | not timed | not timed | 415.71 ± 0.2% | | 1.00 | 1.93 | 16.67 |
| 06-cloud-flare-redos/simplified-short | 102 | 416.11 ± 8.7% | not timed | not timed | 226.59 ± 0.0% | 26.28 ± 7.2% | not timed | not timed | 410.27 ± 0.2% | | 1.01 | 1.84 | 15.83 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.43 ± 0.1% | not timed | not timed | 253.66 ± 1.4% | 28.75 ± 0.1% | not timed | not timed | 577.69 ± 0.3% | | 1.02 | 2.32 | 20.43 |
| 07-unicode-character-data/parse-line | 558784 | 243.11 ± 0.9% | not timed | not timed | 173.87 ± 0.2% | 42.95 ± 1.1% | not timed | not timed | 243.07 ± 0.5% | | 1.00 | 1.40 | 5.66 |
| 08-words/all-english | 56691 | 116.46 ± 0.2% | not timed | not timed | 82.98 ± 0.1% | 12.59 ± 12.7% | not timed | not timed | 116.51 ± 0.5% | | 1.00 | 1.40 | 9.25 |
| 08-words/long-english | 839 | 614.33 ± 0.4% | not timed | not timed | 595.39 ± 0.3% | 32.60 ± 0.2% | not timed | not timed | 614.73 ± 0.5% | | 1.00 | 1.03 | 18.85 |
| 09-aws-keys/full | 0 | 409.20 ± 0.2% | not timed | not timed | 463.10 ± 0.1% | 64.54 ± 3.4% | not timed | not timed | 410.47 ± 0.2% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 873.16 ± 0.4% | not timed | not timed | 987.95 ± 0.7% | 424.81 ± 4.1% | not timed | not timed | 874.44 ± 0.2% | | 1.00 | 0.88 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 585.32 ± 3.1% | not timed | not timed | 516.30 ± 0.9% | 19.20 ± 0.5% | not timed | not timed | 585.90 ± 2.2% | | 1.00 | 1.13 | 30.49 |
| 10-bounded-repeat/letters-ru | 3475 | 508.56 ± 1.5% | not timed | not timed | 478.82 ± 0.1% | 22.02 ± 9.5% | not timed | not timed | 509.29 ± 1.2% | | 1.00 | 1.06 | 23.10 |
| 10-bounded-repeat/context | 53 | 85.46 ± 1.9% | not timed | not timed | 66.37 ± 0.6% | 19.60 ± 0.1% | not timed | not timed | 85.48 ± 1.4% | | 1.00 | 1.29 | 4.36 |
| 10-bounded-repeat/capitals | 11 | 641.61 ± 8.0% | not timed | not timed | 618.41 ± 0.0% | 36.48 ± 0.1% | not timed | not timed | 640.97 ± 8.2% | | 1.00 | 1.04 | 17.59 |
| 11-unstructured-to-json/extract | 600 | 56.89 ± 0.1% | not timed | not timed | 77.40 ± 0.2% | 49.19 ± 0.3% | not timed | not timed | 56.93 ± 0.5% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 567.43 ± 0.4% | not timed | not timed | 561.32 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 568.62 ± 0.2% | | 1.00 | 1.01 | 1392.49 |
| 14-quadratic/1x | 100 | 21.20 ± 0.5% | not timed | not timed | 10.03 ± 0.2% | 0.98 ± 4.1% | not timed | not timed | 21.18 ± 1.6% | | 1.00 | 2.11 | 21.54 |
| 14-quadratic/2x | 200 | 17.45 ± 0.5% | not timed | not timed | 5.55 ± 0.2% | 0.54 ± 1.7% | not timed | not timed | 17.43 ± 1.0% | | 1.00 | 3.14 | 32.54 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.68 ± 0.4% | | 1.00 | 6.34 | 66.59 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.23 ± 1.7% | not timed | not timed | 0.35 ± 0.4% | 0.54 ± 4.7% | not timed | not timed | 1.23 ± 0.5% | | 1.00 | 3.54 | 2.25 |
| 04-ruff-noqa/compile-real | 1 | 103.58 ± 1.9% | not timed | not timed | 13.80 ± 0.5% | 134.58 ± 17.1% | not timed | not timed | 103.58 ± 0.6% | | 1.00 | 7.50 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 14.00 ± 1.1% | not timed | not timed | 2.51 ± 0.5% | 6.52 ± 1.8% | not timed | not timed | 14.01 ± 0.6% | | 1.00 | 5.57 | 2.15 |
| 07-unicode-character-data/compile | 1 | 107.14 ± 1.2% | not timed | not timed | 26.00 ± 0.4% | 36.78 ± 1.7% | not timed | not timed | 107.47 ± 1.1% | | 1.00 | 4.12 | 2.91 |
| 09-aws-keys/compile-full | 1 | 52.15 ± 1.1% | not timed | not timed | 8.32 ± 0.7% | 23.73 ± 1.7% | not timed | not timed | 52.60 ± 0.9% | | 0.99 | 6.27 | 2.20 |
| 09-aws-keys/compile-quick | 1 | 178.16 ± 0.6% | not timed | not timed | 47.24 ± 0.2% | 135.76 ± 1.9% | not timed | not timed | 178.22 ± 0.1% | | 1.00 | 3.77 | 1.31 |
| 10-bounded-repeat/compile-context | 1 | 71.15 ± 1.6% | not timed | not timed | 11.25 ± 0.3% | 16.45 ± 3.6% | not timed | not timed | 71.52 ± 2.0% | | 0.99 | 6.33 | 4.33 |
| 10-bounded-repeat/compile-capitals | 1 | 83.39 ± 2.2% | not timed | not timed | 8.04 ± 0.3% | 24.31 ± 2.2% | not timed | not timed | 83.09 ± 0.6% | | 1.00 | 10.37 | 3.43 |
| 11-unstructured-to-json/compile | 1 | 165.90 ± 1.9% | not timed | not timed | 41.03 ± 0.6% | 69.24 ± 2.4% | not timed | not timed | 166.09 ± 0.1% | | 1.00 | 4.04 | 2.40 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.5% | not timed | not timed | 0.07 ± 0.4% | 0.09 ± 25.1% | not timed | not timed | 0.35 ± 2.3% | | 1.00 | 5.00 | 3.73 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.54 ± 2.5% | not timed | not timed | 6.51 ± 0.1% | 0.58 ± 28.3% | not timed | not timed | 7.55 ± 0.5% | | 1.00 | 1.16 | 13.06 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.7% | not timed | not timed | 164.90 ± 0.7% | 0.00 ± 0.5% | not timed | not timed | 1.05 ± 1.0% | | 1.00 | 0.0064 | 341.42 |
| dictionary/search/english-15 | 15 | 559.83 ± 0.3% | not timed | not timed | 560.08 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 561.54 ± 0.4% | | 1.00 | 1.00 | 1501.34 |
| folly/awyer-inn-busted | 1 | 5587.72 ± 0.1% | not timed | not timed | 142.21 ± 0.1% | 43.99 ± 0.3% | not timed | not timed | 5573.98 ± 0.1% | | 1.00 | 39.29 | 127.04 |
| folly/literal-never-match-rare | 0 | 21121.70 ± 0.8% | not timed | not timed | 19866.51 ± 0.4% | 40848.98 ± 0.8% | not timed | not timed | 21136.60 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12548.10 ± 1.5% | not timed | not timed | 19872.58 ± 0.6% | 2191.34 ± 0.8% | not timed | not timed | 12568.35 ± 1.0% | | 1.00 | 0.63 | 5.73 |
| folly/literal-never-match-tricksy | 1 | 3251.85 ± 0.5% | not timed | not timed | 4403.15 ± 0.7% | 3028.15 ± 2.1% | not timed | not timed | 3246.36 ± 0.3% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1311.78 ± 0.6% | not timed | not timed | 949.64 ± 0.2% | 364.99 ± 18.7% | not timed | not timed | 1314.49 ± 0.5% | | 1.00 | 1.38 | 3.59 |
| grep/long-words-ascii | 5073 | 459.58 ± 0.3% | not timed | not timed | 468.45 ± 0.1% | 46.09 ± 6.1% | not timed | not timed | 437.38 ± 0.4% | | 1.05 | 0.98 | 9.97 |
| imported/leipzig/twain | 811 | 20572.70 ± 0.8% | not timed | not timed | 19489.30 ± 1.6% | 11940.59 ± 8.8% | not timed | not timed | 20645.30 ± 1.4% | | 1.00 | 1.06 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 8944.20 ± 1.7% | not timed | not timed | 4235.22 ± 0.7% | 37.76 ± 0.1% | not timed | not timed | 8996.34 ± 0.9% | | 0.99 | 2.11 | 236.85 |
| imported/leipzig/shing | 1540 | 629.69 ± 0.1% | not timed | not timed | 13078.56 ± 4.4% | 34.07 ± 0.1% | not timed | not timed | 631.93 ± 0.1% | | 1.00 | 0.0481 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8092.90 ± 2.7% | not timed | not timed | 5563.16 ± 0.6% | 31.78 ± 0.2% | not timed | not timed | 8266.23 ± 2.7% | | 0.98 | 1.45 | 254.62 |
| imported/leipzig/word-ending-nn | 262 | 608.95 ± 0.1% | not timed | not timed | 615.74 ± 0.2% | 24.75 ± 0.3% | not timed | not timed | 611.51 ± 0.1% | | 1.00 | 0.99 | 24.61 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10939.17 ± 4.2% | not timed | not timed | 4451.64 ± 6.1% | 11.51 ± 1.1% | not timed | not timed | 10947.78 ± 3.4% | | 1.00 | 2.46 | 950.46 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7696.97 ± 2.8% | not timed | not timed | 5469.39 ± 1.0% | 16.88 ± 0.1% | not timed | not timed | 7705.82 ± 1.9% | | 1.00 | 1.41 | 456.04 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4114.15 ± 55.7% | not timed | not timed | 417.66 ± 1.7% | 11.09 ± 0.1% | not timed | not timed | 4141.84 ± 53.0% | | 0.99 | 9.85 | 370.85 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.96 ± 0.2% | not timed | not timed | 615.01 ± 0.1% | 11.14 ± 0.1% | not timed | not timed | 610.06 ± 0.0% | | 1.00 | 0.99 | 54.74 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.65 ± 0.1% | not timed | not timed | 615.33 ± 0.1% | 9.75 ± 0.0% | not timed | not timed | 610.22 ± 0.1% | | 1.00 | 0.99 | 62.55 |
| imported/leipzig/tom-river | 2 | 6402.78 ± 3.4% | not timed | not timed | 5121.17 ± 0.6% | 30.96 ± 0.2% | not timed | not timed | 6439.66 ± 2.4% | | 0.99 | 1.25 | 206.81 |
| imported/leipzig/ing | 78424 | 609.00 ± 0.7% | not timed | not timed | 569.99 ± 0.3% | 28.26 ± 2.9% | not timed | not timed | 607.49 ± 0.8% | | 1.00 | 1.07 | 21.55 |
| imported/leipzig/ing-whitespace | 55248 | 757.65 ± 0.7% | not timed | not timed | 2061.85 ± 0.5% | 20.56 ± 2.9% | not timed | not timed | 757.29 ± 1.2% | | 1.00 | 0.37 | 36.86 |
| imported/leipzig/awyer-inn | 209 | 774.46 ± 1.4% | not timed | not timed | 4129.05 ± 1.4% | 22.70 ± 0.0% | not timed | not timed | 774.89 ± 1.3% | | 1.00 | 0.19 | 34.11 |
| imported/leipzig/quotes-bounded | 8886 | 2093.10 ± 3.3% | not timed | not timed | 2961.09 ± 1.3% | 38.17 ± 0.2% | not timed | not timed | 2108.91 ± 0.3% | | 0.99 | 0.71 | 54.84 |
| imported/leipzig/non-ascii-alternate | 2 | 12646.76 ± 1.6% | not timed | not timed | 5649.30 ± 0.4% | 50.93 ± 0.1% | not timed | not timed | 12688.18 ± 2.1% | | 1.00 | 2.24 | 248.32 |
| imported/leipzig/math-symbols | 69 | 1975.21 ± 0.5% | not timed | not timed | 618.38 ± 0.1% | 36.50 ± 0.1% | not timed | not timed | 1974.83 ± 0.4% | | 1.00 | 3.19 | 54.11 |
| imported/leipzig/bounded-strings-ending-z | 0 | 596.18 ± 0.3% | not timed | not timed | 616.25 ± 0.1% | 22.49 ± 0.1% | not timed | not timed | 595.07 ± 0.3% | | 1.00 | 0.97 | 26.51 |
| imported/lh3lh3-reb/uri | 17549 | 632.22 ± 0.1% | not timed | not timed | 1066.04 ± 0.1% | 28.25 ± 2.2% | not timed | not timed | 633.23 ± 0.1% | | 1.00 | 0.59 | 22.38 |
| imported/lh3lh3-reb/email | 15057 | 668.48 ± 0.1% | not timed | not timed | 1162.02 ± 0.1% | 30.87 ± 0.8% | not timed | not timed | 668.63 ± 0.2% | | 1.00 | 0.58 | 21.66 |
| imported/lh3lh3-reb/date | 668 | 850.54 ± 0.2% | not timed | not timed | 1033.82 ± 0.2% | 51.46 ± 3.9% | not timed | not timed | 865.18 ± 0.2% | | 0.98 | 0.82 | 16.53 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.57 ± 0.1% | not timed | not timed | 421.89 ± 0.3% | 15.82 ± 1.2% | not timed | not timed | 643.21 ± 0.1% | | 1.00 | 1.52 | 40.62 |
| imported/mariomka/email | 92 | 705.89 ± 0.1% | not timed | not timed | 29580.25 ± 0.7% | 32.88 ± 0.1% | not timed | not timed | 706.53 ± 0.1% | | 1.00 | 0.0239 | 21.47 |
| imported/mariomka/uri | 5301 | 608.40 ± 0.3% | not timed | not timed | 6038.63 ± 0.3% | 32.79 ± 0.3% | not timed | not timed | 605.58 ± 0.1% | | 1.00 | 0.10 | 18.56 |
| imported/mariomka/ip | 5 | 2122.39 ± 2.1% | not timed | not timed | 2966.11 ± 0.1% | 21.09 ± 0.3% | not timed | not timed | 2153.24 ± 2.3% | | 0.99 | 0.72 | 100.61 |
| imported/rsc/no-exponential | 0 | 566.16 ± 0.1% | not timed | not timed | 320.83 ± 0.4% | 23.87 ± 0.1% | not timed | not timed | 567.63 ± 0.2% | | 1.00 | 1.76 | 23.72 |
| imported/rsc/literal | 1 | 741.86 ± 2.2% | not timed | not timed | 1646.48 ± 2.5% | 187.40 ± 17.3% | not timed | not timed | 742.00 ± 5.3% | | 1.00 | 0.45 | 3.96 |
| imported/rsc/not-literal | 2 | 706.99 ± 0.2% | not timed | not timed | 691.53 ± 0.1% | 46.18 ± 8.0% | not timed | not timed | 708.38 ± 2.1% | | 1.00 | 1.02 | 15.31 |
| imported/rsc/match-class | 1 | 1305.56 ± 8.1% | not timed | not timed | 1587.19 ± 0.2% | 58.66 ± 2.4% | not timed | not timed | 1283.78 ± 0.3% | | 1.02 | 0.82 | 22.26 |
| imported/rsc/match-class-in-range | 1 | 1310.68 ± 2.3% | not timed | not timed | 2388.68 ± 1.1% | 60.16 ± 7.0% | not timed | not timed | 1284.45 ± 0.1% | | 1.02 | 0.55 | 21.79 |
| imported/rsc/match-class-unicode | 1 | 525.36 ± 5.6% | not timed | not timed | 515.49 ± 0.1% | 72.81 ± 4.4% | not timed | not timed | 525.50 ± 0.2% | | 1.00 | 1.02 | 7.22 |
| imported/rsc/anchored-literal-short-non-match | 0 | 536.05 ± 0.8% | not timed | not timed | 950.96 ± 0.0% | 227.68 ± 0.7% | not timed | not timed | 533.90 ± 0.6% | | 1.00 | 0.56 | 2.35 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7939.83 ± 0.1% | not timed | not timed | 14206.74 ± 0.1% | 3429.24 ± 0.7% | not timed | not timed | 7927.71 ± 0.2% | | 1.00 | 0.56 | 2.32 |
| imported/rsc/anchored-literal-short-match | 4 | 421.34 ± 1.8% | not timed | not timed | 486.48 ± 0.2% | 84.45 ± 9.6% | not timed | not timed | 419.79 ± 2.3% | | 1.00 | 0.87 | 4.99 |
| imported/rsc/anchored-literal-long-match | 4 | 2966.38 ± 2.2% | not timed | not timed | 7249.65 ± 0.1% | 1235.16 ± 1.0% | not timed | not timed | 3028.00 ± 2.2% | | 0.98 | 0.41 | 2.40 |
| imported/rsc/one-pass-short | 17 | 311.89 ± 2.1% | not timed | not timed | 213.79 ± 0.1% | 31.91 ± 11.4% | not timed | not timed | 311.32 ± 11.2% | | 1.00 | 1.46 | 9.77 |
| imported/rsc/one-pass-short-not | 17 | 219.52 ± 5.9% | not timed | not timed | 224.02 ± 0.2% | 30.79 ± 9.7% | not timed | not timed | 219.61 ± 1.8% | | 1.00 | 0.98 | 7.13 |
| imported/rsc/one-pass-long-prefix | 26 | 235.74 ± 10.2% | not timed | not timed | 285.23 ± 0.5% | 95.50 ± 15.4% | not timed | not timed | 233.98 ± 0.4% | | 1.01 | 0.83 | 2.47 |
| imported/rsc/one-pass-long-prefix-not | 26 | 312.08 ± 5.6% | not timed | not timed | 286.05 ± 0.1% | 67.31 ± 17.7% | not timed | not timed | 313.55 ± 1.7% | | 1.00 | 1.09 | 4.64 |
| imported/rsc/long-needle1 | 31 | 21923.72 ± 0.1% | not timed | not timed | 20160.81 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 21933.20 ± 0.1% | | 1.00 | 1.09 | 5835.45 |
| imported/rsc/long-needle2 | 31 | 22081.51 ± 0.2% | not timed | not timed | 216.39 ± 0.2% | 3.76 ± 0.2% | not timed | not timed | 22100.44 ± 0.3% | | 1.00 | 102.05 | 5870.52 |
| imported/rsc/easy0-32 | 26 | 1053.28 ± 0.6% | not timed | not timed | 1634.09 ± 1.3% | 147.61 ± 19.8% | not timed | not timed | 1050.64 ± 2.6% | | 1.00 | 0.64 | 7.14 |
| imported/rsc/easy0-1k | 26 | 15004.14 ± 0.1% | not timed | not timed | 12316.50 ± 0.7% | 2306.41 ± 13.4% | not timed | not timed | 15010.04 ± 2.6% | | 1.00 | 1.22 | 6.51 |
| imported/rsc/easy0-32k | 26 | 22902.92 ± 1.3% | not timed | not timed | 20410.51 ± 0.0% | 18876.62 ± 21.7% | not timed | not timed | 22916.39 ± 0.3% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21778.30 ± 1.8% | not timed | not timed | 19836.81 ± 0.6% | 37394.64 ± 1.8% | not timed | not timed | 21558.88 ± 0.9% | | 1.01 | 1.10 | 0.58 |
| imported/rsc/easy1-32 | 19 | 354.11 ± 3.7% | not timed | not timed | 636.82 ± 0.1% | 130.73 ± 19.3% | not timed | not timed | 360.44 ± 0.1% | | 0.98 | 0.56 | 2.71 |
| imported/rsc/easy1-1k | 19 | 585.37 ± 2.7% | not timed | not timed | 12787.71 ± 0.2% | 2501.68 ± 14.9% | not timed | not timed | 582.21 ± 0.2% | | 1.01 | 0.0458 | 0.23 |
| imported/rsc/easy1-32k | 19 | 603.22 ± 10.5% | not timed | not timed | 409705.85 ± 0.2% | 20546.18 ± 1.7% | not timed | not timed | 598.16 ± 0.1% | | 1.01 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 603.96 ± 0.2% | not timed | not timed | 12954873.58 ± 0.4% | 38613.71 ± 2.3% | not timed | not timed | 601.85 ± 0.3% | | 1.00 | 0.0000 | 0.0156 |
| imported/rsc/medium-32 | 27 | 424.94 ± 2.0% | not timed | not timed | 631.37 ± 0.1% | 70.26 ± 11.2% | not timed | not timed | 425.14 ± 0.3% | | 1.00 | 0.67 | 6.05 |
| imported/rsc/medium-1k | 27 | 6755.57 ± 0.6% | not timed | not timed | 11308.56 ± 0.1% | 72.37 ± 0.1% | not timed | not timed | 6747.57 ± 0.4% | | 1.00 | 0.60 | 93.34 |
| imported/rsc/medium-32k | 27 | 21589.31 ± 0.1% | not timed | not timed | 351729.60 ± 0.1% | 48.81 ± 0.2% | not timed | not timed | 21580.56 ± 0.0% | | 1.00 | 0.0614 | 442.28 |
| imported/rsc/medium-1mb | 27 | 21354.22 ± 1.3% | not timed | not timed | 11360756.75 ± 0.2% | 48.78 ± 0.2% | not timed | not timed | 21439.45 ± 2.2% | | 1.00 | 0.0019 | 437.74 |
| imported/rsc/hard-32 | 58 | 254.94 ± 2.3% | not timed | not timed | 367.65 ± 0.1% | 49.80 ± 7.8% | not timed | not timed | 255.54 ± 0.2% | | 1.00 | 0.69 | 5.12 |
| imported/rsc/hard-1k | 27 | 577.58 ± 0.2% | not timed | not timed | 11578.67 ± 0.2% | 36.92 ± 10.1% | not timed | not timed | 575.34 ± 0.3% | | 1.00 | 0.0499 | 15.65 |
| imported/rsc/hard-32k | 27 | 602.70 ± 0.2% | not timed | not timed | 358855.58 ± 0.1% | 29.34 ± 0.1% | not timed | not timed | 599.06 ± 0.1% | | 1.01 | 0.0017 | 20.54 |
| imported/rsc/hard-1mb | 51 | 602.29 ± 0.2% | not timed | not timed | 7197652.25 ± 0.0% | 29.36 ± 0.1% | not timed | not timed | 599.59 ± 0.2% | | 1.00 | 0.0001 | 20.51 |
| imported/rsc/reallyhard0-32 | 58 | 254.48 ± 0.2% | not timed | not timed | 223.99 ± 0.1% | 49.72 ± 7.1% | not timed | not timed | 255.06 ± 2.4% | | 1.00 | 1.14 | 5.12 |
| imported/rsc/reallyhard0-1k | 27 | 578.82 ± 0.2% | not timed | not timed | 584.49 ± 0.4% | 40.87 ± 0.1% | not timed | not timed | 580.20 ± 0.2% | | 1.00 | 0.99 | 14.16 |
| imported/rsc/reallyhard0-32k | 27 | 602.41 ± 0.3% | not timed | not timed | 617.72 ± 0.0% | 29.36 ± 0.1% | not timed | not timed | 604.03 ± 0.3% | | 1.00 | 0.98 | 20.52 |
| imported/rsc/reallyhard0-1mb | 51 | 593.64 ± 0.5% | not timed | not timed | 618.14 ± 0.2% | 29.41 ± 0.1% | not timed | not timed | 595.94 ± 0.4% | | 1.00 | 0.96 | 20.18 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.06 ± 0.1% | not timed | not timed | 196.67 ± 0.2% | 60.27 ± 9.3% | not timed | not timed | 274.33 ± 4.9% | | 1.00 | 1.39 | 4.55 |
| imported/rsc/reallyreallyhard0-1k | 16 | 855.76 ± 3.5% | not timed | not timed | 5960.31 ± 0.1% | 34.30 ± 3.0% | not timed | not timed | 854.63 ± 4.4% | | 1.00 | 0.14 | 24.95 |
| imported/rsc/reallyreallyhard0-32k | 16 | 630.22 ± 7.1% | not timed | not timed | 19300.37 ± 0.2% | 24.89 ± 3.1% | not timed | not timed | 625.27 ± 7.6% | | 1.01 | 0.0327 | 25.32 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 593.14 ± 0.3% | not timed | not timed | 19894.08 ± 2.7% | 24.51 ± 1.7% | not timed | not timed | 587.66 ± 1.1% | | 1.01 | 0.0298 | 24.20 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.30 ± 2.8% | not timed | not timed | 215.02 ± 0.3% | 59.25 ± 10.4% | not timed | not timed | 268.43 ± 0.2% | | 1.00 | 1.25 | 4.55 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 845.02 ± 0.9% | not timed | not timed | 6241.94 ± 0.1% | 34.13 ± 6.6% | not timed | not timed | 845.53 ± 0.8% | | 1.00 | 0.14 | 24.76 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 624.68 ± 2.6% | not timed | not timed | 19238.42 ± 0.0% | 25.06 ± 3.3% | not timed | not timed | 622.26 ± 5.2% | | 1.00 | 0.0325 | 24.93 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 594.25 ± 0.2% | not timed | not timed | 20036.88 ± 0.5% | 25.12 ± 0.4% | not timed | not timed | 592.05 ± 0.1% | | 1.00 | 0.0297 | 23.66 |
| imported/sherlock/name-sherlock | 776 | 19665.83 ± 3.7% | not timed | not timed | 18560.22 ± 0.7% | 8625.93 ± 23.2% | not timed | not timed | 19668.96 ± 2.2% | | 1.00 | 1.06 | 2.28 |
| imported/sherlock/name-holmes | 2766 | 14751.61 ± 5.3% | not timed | not timed | 15501.52 ± 0.5% | 3312.63 ± 5.3% | not timed | not timed | 15158.66 ± 6.3% | | 0.97 | 0.95 | 4.45 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19687.81 ± 1.9% | not timed | not timed | 18494.80 ± 0.4% | 8098.41 ± 37.7% | not timed | not timed | 19692.88 ± 0.3% | | 1.00 | 1.06 | 2.43 |
| imported/sherlock/name-sherlock-casei | 816 | 15629.88 ± 0.6% | not timed | not timed | 4009.28 ± 0.2% | 32.48 ± 0.6% | not timed | not timed | 15653.15 ± 0.3% | | 1.00 | 3.90 | 481.21 |
| imported/sherlock/name-holmes-casei | 2802 | 9420.35 ± 13.6% | not timed | not timed | 3305.46 ± 0.3% | 37.74 ± 0.1% | not timed | not timed | 9386.22 ± 2.2% | | 1.00 | 2.85 | 249.62 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12989.00 ± 8.0% | not timed | not timed | 3940.22 ± 0.2% | 32.58 ± 0.3% | not timed | not timed | 13018.47 ± 3.9% | | 1.00 | 3.30 | 398.70 |
| imported/sherlock/name-whitespace | 1461 | 14930.82 ± 1.1% | not timed | not timed | 14385.95 ± 0.3% | 7402.25 ± 14.9% | not timed | not timed | 14891.30 ± 1.3% | | 1.00 | 1.04 | 2.02 |
| imported/sherlock/name-alt1 | 1142 | 11446.15 ± 2.4% | not timed | not timed | 16021.26 ± 0.8% | 4142.91 ± 51.3% | not timed | not timed | 11481.50 ± 0.5% | | 1.00 | 0.71 | 2.76 |
| imported/sherlock/name-alt2 | 3542 | 8587.09 ± 0.6% | not timed | not timed | 3821.45 ± 0.3% | 31.44 ± 0.2% | not timed | not timed | 8614.98 ± 0.2% | | 1.00 | 2.25 | 273.15 |
| imported/sherlock/name-alt3 | 4507 | 5448.70 ± 0.2% | not timed | not timed | 3630.58 ± 0.1% | 9.92 ± 4.2% | not timed | not timed | 5454.09 ± 0.2% | | 1.00 | 1.50 | 549.13 |
| imported/sherlock/name-alt3-casei | 4593 | 1521.19 ± 1.9% | not timed | not timed | 285.77 ± 0.3% | 6.48 ± 0.2% | not timed | not timed | 1518.83 ± 1.4% | | 1.00 | 5.32 | 234.74 |
| imported/sherlock/name-alt4 | 3686 | 6174.98 ± 0.3% | not timed | not timed | 3742.67 ± 0.3% | 31.48 ± 0.1% | not timed | not timed | 6193.37 ± 0.4% | | 1.00 | 1.65 | 196.14 |
| imported/sherlock/name-alt4-casei | 4254 | 2754.04 ± 12.1% | not timed | not timed | 2592.10 ± 0.2% | 19.87 ± 2.7% | not timed | not timed | 2762.08 ± 1.4% | | 1.00 | 1.06 | 138.60 |
| imported/sherlock/name-alt5 | 4028 | 6236.50 ± 0.4% | not timed | not timed | 3741.11 ± 0.2% | 21.79 ± 0.1% | not timed | not timed | 6240.35 ± 0.2% | | 1.00 | 1.67 | 286.24 |
| imported/sherlock/name-alt5-casei | 4104 | 3433.17 ± 2.3% | not timed | not timed | 2209.83 ± 0.2% | 14.34 ± 0.2% | not timed | not timed | 3452.45 ± 1.3% | | 0.99 | 1.55 | 239.38 |
| imported/sherlock/no-match-uncommon | 0 | 21492.04 ± 0.2% | not timed | not timed | 19596.86 ± 0.4% | 35491.60 ± 0.4% | not timed | not timed | 21497.59 ± 0.5% | | 1.00 | 1.10 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21270.77 ± 1.0% | not timed | not timed | 19525.14 ± 0.1% | 1278.41 ± 1.6% | not timed | not timed | 21243.06 ± 0.3% | | 1.00 | 1.09 | 16.64 |
| imported/sherlock/no-match-really-common | 0 | 16104.92 ± 2.8% | not timed | not timed | 18694.72 ± 0.8% | 1272.07 ± 0.8% | not timed | not timed | 16116.22 ± 2.6% | | 1.00 | 0.86 | 12.66 |
| imported/sherlock/the-lower | 21654 | 2315.01 ± 1.1% | not timed | not timed | 2324.70 ± 0.6% | 226.41 ± 21.3% | not timed | not timed | 2318.75 ± 1.9% | | 1.00 | 1.00 | 10.22 |
| imported/sherlock/the-upper | 2223 | 12645.84 ± 1.1% | not timed | not timed | 13614.60 ± 0.8% | 2684.04 ± 17.7% | not timed | not timed | 12758.51 ± 1.0% | | 0.99 | 0.93 | 4.71 |
| imported/sherlock/the-casei | 23961 | 2009.94 ± 0.3% | not timed | not timed | 1319.65 ± 0.3% | 34.57 ± 30.2% | not timed | not timed | 2014.17 ± 1.4% | | 1.00 | 1.52 | 58.14 |
| imported/sherlock/everything-greedy | 581881 | 270.02 ± 0.7% | not timed | not timed | 164.42 ± 0.1% | 28.94 ± 31.0% | not timed | not timed | 271.25 ± 0.2% | | 1.00 | 1.64 | 9.33 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.13 ± 0.1% | not timed | not timed | 211.05 ± 0.3% | 33.00 ± 0.1% | not timed | not timed | 463.19 ± 0.1% | | 1.00 | 2.19 | 14.00 |
| imported/sherlock/letters | 447175 | 53.79 ± 7.1% | not timed | not timed | 32.99 ± 0.1% | 5.20 ± 25.4% | not timed | not timed | 54.21 ± 7.3% | | 0.99 | 1.63 | 10.35 |
| imported/sherlock/letters-upper | 14180 | 433.33 ± 1.3% | not timed | not timed | 371.18 ± 0.3% | 28.94 ± 22.5% | not timed | not timed | 434.49 ± 0.1% | | 1.00 | 1.17 | 14.98 |
| imported/sherlock/letters-lower | 432995 | 55.30 ± 1.5% | not timed | not timed | 33.77 ± 0.2% | 5.65 ± 7.3% | not timed | not timed | 55.40 ± 0.3% | | 1.00 | 1.64 | 9.79 |
| imported/sherlock/words | 447639 | 106.84 ± 0.8% | not timed | not timed | 83.12 ± 0.1% | 14.10 ± 8.8% | not timed | not timed | 107.38 ± 6.2% | | 0.99 | 1.29 | 7.58 |
| imported/sherlock/before-holmes | 4073 | 598.01 ± 0.3% | not timed | not timed | 8495.36 ± 0.6% | 23.72 ± 1.5% | not timed | not timed | 596.06 ± 0.2% | | 1.00 | 0.0704 | 25.21 |
| imported/sherlock/before-after-holmes | 2593 | 596.49 ± 0.2% | not timed | not timed | 9498.47 ± 0.5% | 23.67 ± 1.6% | not timed | not timed | 597.70 ± 0.2% | | 1.00 | 0.0628 | 25.20 |
| imported/sherlock/holmes-cochar-watson | 150 | 5223.29 ± 0.2% | not timed | not timed | 3420.97 ± 0.2% | 30.87 ± 0.1% | not timed | not timed | 5240.17 ± 0.2% | | 1.00 | 1.53 | 169.22 |
| imported/sherlock/holmes-coword-watson | 14309 | 1257.36 ± 2.5% | not timed | not timed | 1122.44 ± 0.1% | 6.79 ± 0.1% | not timed | not timed | 1262.11 ± 3.0% | | 1.00 | 1.12 | 185.12 |
| imported/sherlock/quotes | 14437 | 1398.31 ± 0.2% | not timed | not timed | 1753.20 ± 0.4% | 35.10 ± 0.4% | not timed | not timed | 1412.07 ± 0.4% | | 0.99 | 0.80 | 39.84 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 600.49 ± 0.4% | not timed | not timed | 15892.17 ± 0.3% | 36.72 ± 0.6% | not timed | not timed | 600.54 ± 0.3% | | 1.00 | 0.0378 | 16.35 |
| imported/sherlock/word-ending-n | 35297 | 467.80 ± 0.4% | not timed | not timed | 409.10 ± 0.2% | 23.59 ± 0.7% | not timed | not timed | 467.69 ± 0.2% | | 1.00 | 1.14 | 19.83 |
| imported/sherlock/repeated-class-negation | 2130 | 14492.29 ± 0.9% | not timed | not timed | 10651.31 ± 0.3% | 11.58 ± 0.1% | not timed | not timed | 14521.23 ± 0.8% | | 1.00 | 1.36 | 1251.80 |
| imported/sherlock/ing-suffix | 20547 | 554.84 ± 1.2% | not timed | not timed | 516.96 ± 0.1% | 28.88 ± 29.7% | not timed | not timed | 553.98 ± 1.4% | | 1.00 | 1.07 | 19.21 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.54 ± 0.2% | not timed | not timed | 2094.64 ± 0.5% | 20.56 ± 0.2% | not timed | not timed | 594.44 ± 0.1% | | 1.00 | 0.28 | 28.92 |
| opt/accelerate/whole-line | 239963 | 459.41 ± 0.0% | not timed | not timed | 373.12 ± 0.1% | 92.28 ± 13.9% | not timed | not timed | 458.94 ± 0.3% | | 1.00 | 1.23 | 4.98 |
| opt/accelerate/non-dna | 16745 | 412.35 ± 0.9% | not timed | not timed | 397.14 ± 0.1% | 29.23 ± 18.3% | not timed | not timed | 413.38 ± 2.2% | | 1.00 | 1.04 | 14.11 |
| opt/backtrack/words-english | 40536 | 137.36 ± 1.3% | not timed | not timed | 94.82 ± 0.1% | 19.81 ± 8.6% | not timed | not timed | 134.85 ± 2.3% | | 1.02 | 1.45 | 6.93 |
| opt/fixed-length/too-small-ascii | 0 | 312.37 ± 0.1% | not timed | not timed | 677.61 ± 1.8% | 80.15 ± 0.5% | not timed | not timed | 310.20 ± 0.4% | | 1.01 | 0.46 | 3.90 |
| opt/fixed-length/too-big-ascii | 0 | 649.22 ± 0.6% | not timed | not timed | 5772.19 ± 0.3% | 127.33 ± 0.4% | not timed | not timed | 653.28 ± 0.4% | | 0.99 | 0.11 | 5.10 |
| opt/fixed-length/go33484-1 | 0 | 45.65 ± 0.5% | not timed | not timed | 1104492.46 ± 0.0% | 61591.33 ± 0.6% | not timed | not timed | 45.67 ± 0.1% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5533.78 ± 0.1% | not timed | not timed | 1100553.39 ± 0.3% | 32384.30 ± 1.2% | not timed | not timed | 5520.09 ± 0.0% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1807.09 ± 1.3% | not timed | not timed | 110680.37 ± 0.2% | 762.34 ± 0.2% | not timed | not timed | 1782.86 ± 0.2% | | 1.01 | 0.0163 | 2.37 |
| opt/literal-alt/one-pattern | 1 | 555.71 ± 0.1% | not timed | not timed | 542.99 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 555.72 ± 0.2% | | 1.00 | 1.02 | 1382.16 |
| opt/onepass/fn-predicate | 916 | 368.04 ± 0.7% | not timed | not timed | 333.96 ± 0.1% | 201.24 ± 13.1% | not timed | not timed | 370.90 ± 0.2% | | 0.99 | 1.10 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 148.52 ± 6.6% | not timed | not timed | 202.60 ± 0.3% | 79.24 ± 11.5% | not timed | not timed | 149.98 ± 1.4% | | 0.99 | 0.73 | 1.87 |
| opt/prefilter/literal-english | 1 | 20736.99 ± 0.5% | not timed | not timed | 19912.60 ± 0.4% | 17647.81 ± 0.8% | not timed | not timed | 20708.28 ± 0.5% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14518.19 ± 0.8% | not timed | not timed | 4318.66 ± 0.1% | 32.67 ± 0.6% | not timed | not timed | 14493.05 ± 0.3% | | 1.00 | 3.36 | 444.40 |
| opt/prefilter/literal-russian | 1 | 21163.46 ± 0.4% | not timed | not timed | 19767.48 ± 0.6% | 3331.86 ± 0.1% | not timed | not timed | 21173.43 ± 0.3% | | 1.00 | 1.07 | 6.35 |
| opt/prefilter/literal-casei-russian | 1 | 8599.88 ± 0.2% | not timed | not timed | 3893.61 ± 0.2% | 30.97 ± 0.3% | not timed | not timed | 8602.93 ± 0.2% | | 1.00 | 2.21 | 277.72 |
| opt/prefilter/rust-functions | 948 | 6806.59 ± 0.6% | not timed | not timed | 8951.48 ± 0.2% | 1872.88 ± 0.5% | not timed | not timed | 6802.99 ± 0.3% | | 1.00 | 0.76 | 3.63 |
| opt/reverse-anchored/word-end | 1 | 5585.17 ± 0.2% | not timed | not timed | 21471719.84 ± 0.1% | 50.08 ± 0.3% | not timed | not timed | 5584.55 ± 0.3% | | 1.00 | 0.0003 | 111.53 |
| opt/reverse-inner/holmes | 2593 | 596.87 ± 0.4% | not timed | not timed | 9521.17 ± 0.5% | 23.63 ± 2.3% | not timed | not timed | 597.59 ± 0.3% | | 1.00 | 0.0627 | 25.26 |
| opt/reverse-inner/email | 47 | 1045.49 ± 0.1% | not timed | not timed | 44643.84 ± 0.8% | 32.39 ± 0.8% | not timed | not timed | 1044.15 ± 0.2% | | 1.00 | 0.0234 | 32.27 |
| opt/reverse-inner/factored-prefix | 3542 | 590.92 ± 0.3% | not timed | not timed | 594.65 ± 0.1% | 12.36 ± 0.2% | not timed | not timed | 591.16 ± 0.2% | | 1.00 | 0.99 | 47.83 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5511.18 ± 0.1% | not timed | not timed | 613.47 ± 0.1% | 75.07 ± 0.2% | not timed | not timed | 5520.80 ± 0.1% | | 1.00 | 8.98 | 73.41 |
| opt/reverse-inner/no-quadratic-forward | 0 | 684.55 ± 2.2% | not timed | not timed | 287.25 ± 0.2% | 24.84 ± 0.1% | not timed | not timed | 685.60 ± 2.1% | | 1.00 | 2.38 | 27.55 |
| opt/reverse-suffix/holmes | 4073 | 598.39 ± 0.1% | not timed | not timed | 8463.17 ± 0.2% | 23.91 ± 2.0% | not timed | not timed | 597.07 ± 0.4% | | 1.00 | 0.0707 | 25.03 |
| opt/reverse-suffix/no-quadratic | 0 | 5520.87 ± 0.0% | not timed | not timed | 611.74 ± 0.4% | 74.79 ± 0.1% | not timed | not timed | 5509.73 ± 0.1% | | 1.00 | 9.02 | 73.82 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.42 ± 2.0% | not timed | not timed | 132.33 ± 0.0% | 13.17 ± 14.8% | not timed | not timed | 120.55 ± 2.9% | | 1.00 | 0.91 | 9.14 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.82 ± 3.4% | not timed | not timed | 131.52 ± 0.3% | 12.94 ± 14.6% | not timed | not timed | 120.88 ± 0.5% | | 1.00 | 0.92 | 9.34 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.3% | 111.00 ± 1.5% | not timed | not timed | 0.28 ± 0.3% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.40 ± 0.3% | not timed | not timed | 294.57 ± 0.1% | 103.43 ± 7.1% | not timed | not timed | 309.71 ± 2.9% | | 1.02 | 1.07 | 3.06 |
| reported/i13-subset-regex/original-ascii | 4094 | 11008.72 ± 1.6% | not timed | not timed | 4453.83 ± 0.8% | 11.51 ± 0.1% | not timed | not timed | 10969.40 ± 1.4% | | 1.00 | 2.47 | 956.53 |
| reported/i13-subset-regex/original-unicode | 4094 | 10781.57 ± 2.9% | not timed | not timed | 251.36 ± 3.1% | 11.51 ± 0.1% | not timed | not timed | 10946.18 ± 2.2% | | 0.98 | 42.89 | 936.42 |
| reported/i13-subset-regex/big-ascii | 1955 | 10642.45 ± 1.9% | not timed | not timed | 68.30 ± 3.6% | 9.86 ± 0.1% | not timed | not timed | 10693.67 ± 1.3% | | 1.00 | 155.82 | 1079.17 |
| reported/i13-subset-regex/big-unicode | 1955 | 10571.16 ± 1.6% | not timed | not timed | 12.28 ± 54.9% | 9.86 ± 0.1% | not timed | not timed | 10708.44 ± 1.0% | | 0.99 | 860.65 | 1071.72 |
| reported/i13-subset-regex/huge-ascii | 55 | 10140.00 ± 1.7% | not timed | not timed | 11.06 ± 0.1% | 8.75 ± 0.1% | not timed | not timed | 10123.81 ± 1.8% | | 1.00 | 916.49 | 1158.36 |
| reported/i13-subset-regex/huge-unicode | 55 | 10107.35 ± 18.9% | not timed | not timed | 11.05 ± 0.3% | 8.75 ± 0.1% | not timed | not timed | 10075.09 ± 2.8% | | 1.00 | 914.74 | 1155.78 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.0% | not timed | not timed | 11.03 ± 0.1% | 8.73 ± 0.5% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.02 ± 0.0% | not timed | not timed | 11.02 ± 0.3% | 8.77 ± 1.3% | not timed | not timed | 5.02 ± 0.0% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 470.13 ± 0.3% | not timed | not timed | 104.54 ± 0.1% | 6.64 ± 0.3% | not timed | not timed | 470.08 ± 0.3% | | 1.00 | 4.50 | 70.84 |
| reported/i787-keywords/opt-ascii | 5674 | 470.97 ± 0.4% | not timed | not timed | 275.10 ± 0.4% | 10.21 ± 0.1% | not timed | not timed | 470.85 ± 0.2% | | 1.00 | 1.71 | 46.12 |
| slow/quadratic-regex-1x | 100 | 6.95 ± 0.1% | not timed | not timed | 4.90 ± 0.2% | 0.05 ± 0.3% | not timed | not timed | 6.94 ± 0.1% | | 1.00 | 1.42 | 140.86 |
| slow/quadratic-regex-2x | 199 | 3.39 ± 0.1% | not timed | not timed | 2.75 ± 0.2% | 0.01 ± 0.2% | not timed | not timed | 3.39 ± 0.2% | | 1.00 | 1.23 | 266.53 |
| slow/quadratic-haystack-1x | 100 | 21.21 ± 6.1% | not timed | not timed | 9.99 ± 0.4% | 1.02 ± 14.1% | not timed | not timed | 21.19 ± 1.3% | | 1.00 | 2.12 | 20.85 |
| slow/quadratic-haystack-2x | 200 | 17.52 ± 0.4% | not timed | not timed | 5.55 ± 0.2% | 0.55 ± 1.5% | not timed | not timed | 17.48 ± 11.7% | | 1.00 | 3.16 | 32.07 |
| unicode/codepoints/any-one | 1112064 | 285.35 ± 0.2% | not timed | not timed | 176.89 ± 0.2% | 18.47 ± 3.2% | not timed | not timed | 284.33 ± 0.4% | | 1.00 | 1.61 | 15.45 |
| unicode/codepoints/any-all | 4382592 | 289.52 ± 0.4% | not timed | not timed | 247.01 ± 0.2% | 117.47 ± 0.3% | not timed | not timed | 289.25 ± 0.5% | | 1.00 | 1.17 | 2.46 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 1.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 611.00 ± 0.3% | not timed | not timed | 616.10 ± 0.6% | 135.48 ± 0.1% | not timed | not timed | 610.83 ± 0.4% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.84 ± 0.2% | not timed | not timed | 38.48 ± 0.2% | 3.94 ± 0.4% | not timed | not timed | 31.91 ± 0.4% | | 1.00 | 0.83 | 8.07 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.2% | not timed | not timed | 4.46 ± 0.2% | 2.35 ± 0.7% | not timed | not timed | 1.35 ± 0.1% | | 1.00 | 0.30 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 10.2% | not timed | not timed | 4.09 ± 0.2% | 6.33 ± 9.3% | not timed | not timed | 1.22 ± 0.3% | | 1.00 | 0.30 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 117.42 ± 4.4% | not timed | not timed | 82.94 ± 0.1% | 11.98 ± 25.8% | not timed | not timed | 117.11 ± 0.4% | | 1.00 | 1.42 | 9.80 |
| unicode/word/boundary-long-english | 3466 | 605.73 ± 0.5% | not timed | not timed | 603.29 ± 0.3% | 32.73 ± 0.5% | not timed | not timed | 605.93 ± 0.5% | | 1.00 | 1.00 | 18.51 |
| unicode/word/around-holmes-english | 27 | 601.91 ± 0.6% | not timed | not timed | 19619.37 ± 1.1% | 22.20 ± 0.4% | not timed | not timed | 601.95 ± 0.5% | | 1.00 | 0.0307 | 27.12 |
| wild/bibleref/long | 874 | 564.77 ± 0.2% | not timed | not timed | 580.79 ± 0.1% | 6.77 ± 0.1% | not timed | not timed | 564.61 ± 0.2% | | 1.00 | 0.97 | 83.39 |
| wild/bibleref/short | 30 | 24.78 ± 7.6% | not timed | not timed | 30.68 ± 0.6% | 14.02 ± 10.5% | not timed | not timed | 24.77 ± 3.7% | | 1.00 | 0.81 | 1.77 |
| wild/bibleref/line | 874 | 359.13 ± 2.8% | not timed | not timed | 213.91 ± 0.3% | 9.17 ± 8.2% | not timed | not timed | 359.41 ± 0.3% | | 1.00 | 1.68 | 39.15 |
| wild/caddy/caddy | 6 | 415.40 ± 7.6% | not timed | not timed | 248.29 ± 0.1% | 68.12 ± 11.8% | not timed | not timed | 418.47 ± 0.8% | | 0.99 | 1.67 | 6.10 |
| wild/dot-star-capture/rust-src-tools | 6 | 1057.25 ± 0.3% | not timed | not timed | 343.82 ± 0.5% | 13.50 ± 0.2% | not timed | not timed | 1056.28 ± 0.3% | | 1.00 | 3.08 | 78.31 |
| wild/ruff/noqa | 84 | 404.47 ± 0.1% | not timed | not timed | 458.22 ± 0.1% | 19.39 ± 2.0% | not timed | not timed | 404.79 ± 3.1% | | 1.00 | 0.88 | 20.86 |
| wild/ruff/unnecessary-coding-comment | 16 | 490.10 ± 0.6% | not timed | not timed | 701.52 ± 0.1% | 135.61 ± 10.9% | not timed | not timed | 489.77 ± 0.7% | | 1.00 | 0.70 | 3.61 |
| wild/ruff/string-quote-prefix | 2972 | 408.09 ± 0.6% | not timed | not timed | 435.81 ± 0.3% | 377.35 ± 29.9% | not timed | not timed | 408.27 ± 0.6% | | 1.00 | 0.94 | 1.08 |
| wild/ruff/space-around-operator | 1224378 | 217.70 ± 1.8% | not timed | not timed | 184.96 ± 0.1% | 18.30 ± 1.7% | not timed | not timed | 218.26 ± 3.6% | | 1.00 | 1.18 | 11.90 |
| wild/ruff/shebang | 282 | 402.08 ± 0.5% | not timed | not timed | 328.84 ± 0.1% | 121.55 ± 10.0% | not timed | not timed | 402.06 ± 0.4% | | 1.00 | 1.22 | 3.31 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13833.66 ± 0.1% | not timed | not timed | 13832.55 ± 0.3% | 6959.40 ± 0.6% | not timed | not timed | 13866.72 ± 0.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12839.02 ± 0.5% | not timed | not timed | 13480.81 ± 0.5% | 6411.11 ± 1.0% | not timed | not timed | 12823.22 ± 0.2% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13195.38 ± 1.1% | not timed | not timed | 13534.33 ± 0.9% | 6699.33 ± 36.7% | not timed | not timed | 13224.73 ± 5.1% | | 1.00 | 0.97 | 1.97 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9571.52 ± 0.2% | not timed | not timed | 13567.67 ± 0.3% | 6794.23 ± 0.7% | not timed | not timed | 9567.88 ± 0.6% | | 1.00 | 0.71 | 1.41 |
| wild/url/search | 234965 | 122.85 ± 14.3% | not timed | not timed | 66.20 ± 0.5% | 2.24 ± 0.8% | not timed | not timed | 122.63 ± 13.6% | | 1.00 | 1.86 | 54.91 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.4% | not timed | not timed | 0.01 ± 1.5% | 0.01 ± 12.1% | not timed | not timed | 0.03 ± 7.3% | | 1.00 | 3.09 | 4.06 |
| dictionary/compile/english-15 | 1 | 0.35 ± 34.5% | not timed | not timed | 0.07 ± 0.4% | 0.11 ± 8.6% | not timed | not timed | 0.35 ± 5.1% | | 1.00 | 4.99 | 3.31 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 2.3% | not timed | not timed | 0.02 ± 1.2% | 36.05 ± 11.1% | not timed | not timed | 0.25 ± 2.9% | | 1.02 | 12.95 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.30 ± 2.6% | not timed | not timed | 11.69 ± 0.2% | 54.28 ± 19.9% | not timed | not timed | 46.77 ± 2.1% | | 0.99 | 3.96 | 0.85 |
| reported/i787-keywords/compile | 1 | 34.36 ± 3.2% | not timed | not timed | 2.13 ± 0.9% | 17.74 ± 24.5% | not timed | not timed | 34.51 ± 12.4% | | 1.00 | 16.11 | 1.94 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 343.78 ± 1.0% | not timed | not timed | 117.50 ± 0.2% | 570.22 ± 8.5% | not timed | not timed | 344.52 ± 1.0% | | 1.00 | 2.93 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.85 ± 2.0% | not timed | not timed | 4.10 ± 0.7% | 44.88 ± 14.3% | not timed | not timed | 47.64 ± 19.6% | | 0.98 | 11.42 | 1.04 |
| unicode/compile/one-letter | 53 | 6.59 ± 11.6% | not timed | not timed | 4.53 ± 0.3% | 65.62 ± 5.4% | not timed | not timed | 6.72 ± 2.1% | | 0.98 | 1.45 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 14.4% | not timed | not timed | 0.10 ± 0.6% | 67.33 ± 2.9% | not timed | not timed | 1.09 ± 11.7% | | 0.97 | 10.54 | 0.0157 |
| unicode/compile/fifty-letters-ascii | 1 | 200.27 ± 9.9% | not timed | not timed | 52.23 ± 0.3% | 200.90 ± 15.1% | not timed | not timed | 215.40 ± 7.2% | | 0.93 | 3.83 | 1.00 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 361.33 ± 14.9% | not timed | not timed | 47.20 ± 0.4% | 689.78 ± 24.9% | not timed | not timed | 360.50 ± 1.9% | | 1.00 | 7.65 | 0.52 |
| unicode/compile/match-every-line-ascii | 4 | 546.40 ± 2.9% | not timed | not timed | 144.99 ± 0.1% | 686.34 ± 29.5% | not timed | not timed | 554.69 ± 12.9% | | 0.99 | 3.77 | 0.80 |
| unicode/compile/negated-class-matches-codepoint | 1 | 297.56 ± 4.7% | not timed | not timed | 48.81 ± 0.5% | 1269.80 ± 1.4% | not timed | not timed | 310.83 ± 4.5% | | 0.96 | 6.10 | 0.23 |
| wild/bibleref/compile | 3 | 5.72 ± 3.5% | not timed | not timed | 1.94 ± 0.7% | 32.47 ± 3.7% | not timed | not timed | 5.87 ± 3.8% | | 0.97 | 2.94 | 0.18 |
| wild/url/compile | 1 | 0.63 ± 19.2% | not timed | not timed | 0.15 ± 0.7% | 0.46 ± 34.4% | not timed | not timed | 0.63 ± 16.7% | | 0.99 | 4.31 | 1.38 |

