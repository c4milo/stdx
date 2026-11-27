# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
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
| literal: a word | 217 | 19511.67 ± 1.1% | 10809.43 ± 0.7% | 27.67 ± 0.3% | 18285.84 ± 2.0% | 9194.25 ± 7.9% | 17.30 ± 0.3% | 86.12 ± 0.1% | 19619.47 ± 1.4% | 1.81 | 0.99 | 1.07 | 2.12 |
| literal: a word that is not there | 0 | 21737.34 ± 2.5% | 9890.07 ± 0.5% | 27.73 ± 0.2% | 19776.79 ± 0.9% | 29215.42 ± 3.3% | 17.11 ± 0.2% | 80.43 ± 0.7% | 21536.12 ± 2.3% | 2.20 | 1.01 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6435.25 ± 0.2% | 1791.75 ± 0.5% | 14.24 ± 0.2% | 3949.85 ± 0.2% | 21.87 ± 0.4% | 5.36 ± 0.1% | 6.93 ± 0.1% | 6442.13 ± 0.5% | 3.59 | 1.00 | 1.63 | 294.30 |
| literal: a word in any case | 217 | 15158.23 ± 0.6% | 1917.02 ± 0.6% | 21.27 ± 0.1% | 3973.09 ± 0.1% | 37.85 ± 1.3% | refused | differs | 15175.22 ± 0.8% | 7.91 | 1.00 | 3.82 | 400.53 |
| literal: an href attribute | 33 | 16881.14 ± 1.7% | 609.27 ± 0.7% | 26.85 ± 0.1% | 16793.01 ± 2.3% | 2260.58 ± 0.6% | 13.10 ± 0.1% | 75.04 ± 0.3% | 16948.74 ± 1.0% | 27.71 | 1.00 | 1.01 | 7.47 |
| literal: a word, second text | 123 | 19779.59 ± 3.0% | 4588.71 ± 0.3% | 27.42 ± 0.4% | 18276.59 ± 3.0% | 7717.80 ± 10.6% | 20.19 ± 0.3% | 70.21 ± 0.3% | 19814.15 ± 3.3% | 4.31 | 1.00 | 1.08 | 2.56 |
| class: two capitalized words | 1331 | 1178.95 ± 0.3% | 599.10 ± 0.3% | 25.58 ± 0.1% | 585.53 ± 0.0% | 40.66 ± 7.9% | 14.78 ± 0.3% | 67.78 ± 0.4% | 1178.88 ± 0.2% | 1.97 | 1.00 | 2.01 | 28.99 |
| class: a word that ends in ing | 3399 | 574.33 ± 0.1% | 573.73 ± 0.2% | 17.68 ± 0.3% | 548.36 ± 0.1% | 29.69 ± 9.3% | 8.15 ± 0.3% | 18.40 ± 0.2% | 575.03 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.34 |
| class: a word in capitals | 2332 | 1535.22 ± 0.2% | 607.09 ± 0.4% | 27.14 ± 0.1% | 577.83 ± 0.1% | 43.50 ± 2.5% | 17.06 ± 0.3% | 83.08 ± 0.4% | 1532.83 ± 0.2% | 2.53 | 1.00 | 2.66 | 35.30 |
| class: a number | 8288 | 2673.77 ± 0.4% | 840.57 ± 0.1% | 27.25 ± 0.2% | 1719.93 ± 0.3% | 42.07 ± 16.9% | 0.55 ± 0.3% | 57.31 ± 0.4% | 2674.41 ± 0.5% | 3.18 | 1.00 | 1.55 | 63.55 |
| class: two capitalized words, second text | 5359 | 522.36 ± 0.2% | 528.47 ± 0.2% | 22.90 ± 0.1% | 484.51 ± 0.2% | 35.26 ± 15.4% | 17.06 ± 0.2% | 63.12 ± 0.2% | 522.46 ± 0.5% | 0.99 | 1.00 | 1.08 | 14.81 |
| other: a word between two words | 6104 | 815.23 ± 0.2% | 602.54 ± 0.1% | 23.17 ± 0.1% | 738.37 ± 0.4% | 108.52 ± 21.1% | 11.26 ± 0.1% | 69.04 ± 0.7% | 813.60 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.51 |
| other: a number before a unit, second text | 1481 | 6220.85 ± 1.8% | 1143.34 ± 0.4% | 25.55 ± 0.1% | 5227.34 ± 0.4% | 40.88 ± 8.4% | 18.16 ± 0.4% | 65.54 ± 0.3% | 6201.97 ± 1.3% | 5.44 | 1.00 | 1.19 | 152.18 |
| other: a heading's start tag | 110 | 14158.51 ± 0.6% | 740.32 ± 0.1% | 26.84 ± 0.1% | 1711.42 ± 0.4% | 1585.18 ± 3.3% | 16.03 ± 0.4% | 87.78 ± 0.4% | 14176.21 ± 0.7% | 19.12 | 1.00 | 8.27 | 8.93 |
| other: a whole word | 217 | 16401.92 ± 1.7% | 600.31 ± 0.7% | 28.15 ± 0.2% | 14579.09 ± 1.0% | 49.41 ± 0.6% | 13.15 ± 0.1% | 55.06 ± 0.7% | 16461.27 ± 1.4% | 27.32 | 1.00 | 1.13 | 331.96 |
| other: a line's first word, second text | 3716 | 2104.66 ± 0.3% | 592.19 ± 0.1% | 30.04 ± 0.1% | 1565.24 ± 0.2% | 63.21 ± 7.0% | refused | refused | 2109.19 ± 0.4% | 3.55 | 1.00 | 1.34 | 33.29 |
| other: fourteen octets before an x | 87 | 24237.42 ± 4.5% | 230.86 ± 0.5% | 6.45 ± 0.1% | 3947.83 ± 1.4% | 10.63 ± 0.4% | differs | 17.94 ± 0.1% | 24020.39 ± 8.4% | 104.99 | 1.01 | 6.14 | 2279.87 |
| other: a Greek word | 21815 | 529.44 ± 0.7% | 423.44 ± 0.1% | 30.16 ± 0.3% | 289.73 ± 0.3% | 49.62 ± 11.5% | differs | refused | 530.73 ± 0.5% | 1.25 | 1.00 | 1.83 | 10.67 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.61 ± 0.1% | 29.60 ± 0.1% | 0.86 ± 0.1% | 19.75 ± 0.3% | 2.77 ± 0.5% | differs | 4.06 ± 0.2% | 29.61 ± 0.3% | 1.00 | 1.00 | 1.50 | 10.69 |
| a UUID | 32895 | 24.65 ± 0.3% | 24.78 ± 0.2% | 0.64 ± 0.2% | 14.91 ± 1.3% | 3.12 ± 0.8% | 0.74 ± 0.3% | 3.63 ± 1.0% | 24.78 ± 0.4% | 0.99 | 0.99 | 1.65 | 7.91 |
| an IPv4 address | 33176 | 38.78 ± 0.3% | 38.66 ± 0.3% | 2.07 ± 0.4% | 29.40 ± 0.4% | 6.67 ± 0.2% | differs | 4.22 ± 0.2% | 38.80 ± 0.1% | 1.00 | 1.00 | 1.32 | 5.82 |
| a date and time | 32954 | 34.09 ± 0.2% | 34.28 ± 0.2% | 1.44 ± 0.2% | 21.72 ± 0.8% | 7.03 ± 0.5% | 1.26 ± 0.3% | 7.17 ± 0.3% | 34.26 ± 0.1% | 0.99 | 1.00 | 1.57 | 4.85 |
| a field path | 32606 | 32.79 ± 0.2% | 32.70 ± 0.1% | 1.02 ± 0.2% | 23.22 ± 0.5% | 3.49 ± 0.6% | differs | 2.97 ± 0.1% | 32.83 ± 0.3% | 1.00 | 1.00 | 1.41 | 9.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.2% | 11.22 ± 0.4% | 11.27 ± 0.6% | 11.60 ± 0.1% | 4.96 ± 2.1% | 0.94 ± 0.5% | none | 11.14 ± 0.3% | 1.00 | 1.01 | 0.97 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 223.86 ± 0.7% | 224.14 ± 0.4% | 270.07 ± 0.1% | 88.03 ± 1.2% | 223.06 ± 0.5% | 472.66 ± 2.9% | 3755.70 ± 0.3% | 223.67 ± 0.8% | 1.00 | 1.00 | 2.54 | 1.00 |
| a UUID | 62 | 146.45 ± 0.5% | 146.68 ± 1.0% | 166.08 ± 0.3% | 46.20 ± 0.4% | 100.07 ± 1.1% | 184.88 ± 3.2% | 4375.18 ± 0.9% | 146.85 ± 0.9% | 1.00 | 1.00 | 3.17 | 1.46 |
| an IPv4 address | 29 | 401.06 ± 0.9% | 401.89 ± 0.7% | 573.44 ± 0.6% | 76.80 ± 0.4% | 132.81 ± 1.6% | 295.41 ± 0.4% | 7578.04 ± 0.4% | 401.34 ± 0.2% | 1.00 | 1.00 | 5.22 | 3.02 |
| a date and time | 56 | 289.98 ± 0.4% | 289.98 ± 0.2% | 369.92 ± 0.2% | 72.36 ± 0.5% | 138.29 ± 1.2% | 322.46 ± 0.9% | 4965.26 ± 0.2% | 289.98 ± 0.1% | 1.00 | 1.00 | 4.01 | 2.10 |
| a field path | 39 | 217.73 ± 1.2% | 217.86 ± 0.8% | 261.15 ± 1.8% | 80.83 ± 1.3% | 207.21 ± 0.7% | 490.39 ± 0.7% | 4755.64 ± 2.9% | 217.65 ± 1.0% | 1.00 | 1.00 | 2.69 | 1.05 |
| literal: a word | 7 | 574.53 ± 0.4% | 614.02 ± 0.3% | 1122.16 ± 0.2% | 522.38 ± 0.4% | 624.08 ± 2.6% | 938.05 ± 0.6% | 30572.97 ± 0.3% | 574.12 ± 0.1% | 0.94 | 1.00 | 1.10 | 0.92 |
| literal: a word that is not there | 8 | 557.50 ± 0.4% | 600.55 ± 0.2% | 1083.69 ± 0.6% | 467.15 ± 0.4% | 605.40 ± 1.0% | 895.33 ± 0.5% | 29352.77 ± 0.8% | 557.62 ± 0.3% | 0.93 | 1.00 | 1.19 | 0.92 |
| literal: one of four words | 26 | 232.19 ± 0.4% | 373.80 ± 0.3% | 521.13 ± 0.3% | 49.72 ± 1.1% | 242.67 ± 4.4% | 355.58 ± 0.8% | 15803.33 ± 0.4% | 232.16 ± 0.4% | 0.62 | 1.00 | 4.67 | 0.96 |
| literal: a word in any case | 11 | 418.20 ± 0.2% | 445.61 ± 0.3% | 667.08 ± 0.3% | 15.66 ± 0.3% | 650.31 ± 2.7% | refused | 23943.20 ± 0.6% | 418.61 ± 0.2% | 0.94 | 1.00 | 26.70 | 0.64 |
| literal: an href attribute | 12 | 322.70 ± 0.2% | 334.35 ± 0.3% | 446.45 ± 0.3% | 45.49 ± 0.5% | 500.03 ± 1.9% | 777.55 ± 0.7% | 22299.80 ± 0.3% | 322.78 ± 0.2% | 0.97 | 1.00 | 7.09 | 0.65 |
| literal: a word, second text | 10 | 516.03 ± 0.4% | 563.01 ± 0.4% | 967.86 ± 0.2% | 417.88 ± 0.3% | 540.27 ± 1.0% | 804.43 ± 0.5% | 27609.11 ± 1.7% | 515.91 ± 0.4% | 0.92 | 1.00 | 1.23 | 0.96 |
| class: two capitalized words | 23 | 412.60 ± 0.3% | 440.31 ± 0.4% | 652.41 ± 0.6% | 101.82 ± 0.2% | 503.52 ± 1.7% | 756.39 ± 1.6% | 6335.33 ± 0.2% | 412.94 ± 0.5% | 0.94 | 1.00 | 4.05 | 0.82 |
| class: a word that ends in ing | 9 | 517.93 ± 0.6% | 582.01 ± 0.2% | 1049.07 ± 0.1% | 133.12 ± 0.3% | 754.14 ± 2.3% | 1099.11 ± 2.6% | 15871.73 ± 0.0% | 518.63 ± 0.3% | 0.89 | 1.00 | 3.89 | 0.69 |
| class: a word in capitals | 16 | 464.51 ± 0.3% | 500.30 ± 0.2% | 814.62 ± 0.1% | 135.04 ± 1.3% | 751.34 ± 0.7% | 1008.10 ± 0.5% | 8348.28 ± 0.2% | 464.78 ± 0.1% | 0.93 | 1.00 | 3.44 | 0.62 |
| class: a number | 6 | 582.67 ± 0.4% | 638.29 ± 0.3% | 1229.96 ± 0.1% | 42.30 ± 0.7% | 1396.51 ± 1.1% | 1833.35 ± 0.7% | 23137.84 ± 0.1% | 582.62 ± 0.2% | 0.91 | 1.00 | 13.78 | 0.42 |
| class: two capitalized words, second text | 23 | 412.97 ± 0.3% | 441.60 ± 0.6% | 653.28 ± 0.3% | 102.86 ± 1.0% | 501.81 ± 2.5% | 765.20 ± 0.6% | 6335.20 ± 0.3% | 413.47 ± 0.3% | 0.94 | 1.00 | 4.01 | 0.82 |
| other: a word between two words | 13 | 504.46 ± 0.1% | 522.91 ± 0.3% | 856.30 ± 0.1% | 134.40 ± 0.5% | 504.19 ± 0.6% | 798.13 ± 0.5% | 14689.60 ± 0.2% | 504.42 ± 0.1% | 0.96 | 1.00 | 3.75 | 1.00 |
| other: a number before a unit, second text | 15 | 370.81 ± 0.6% | 409.06 ± 0.5% | 589.86 ± 0.6% | 39.83 ± 0.4% | 635.50 ± 1.0% | 880.05 ± 0.4% | 15335.73 ± 0.3% | 371.43 ± 0.3% | 0.91 | 1.00 | 9.31 | 0.58 |
| other: a heading's start tag | 13 | 332.94 ± 0.4% | 339.48 ± 0.5% | 456.16 ± 0.5% | 44.39 ± 0.5% | 630.90 ± 2.0% | 862.87 ± 0.2% | 18462.48 ± 0.1% | 333.22 ± 0.5% | 0.98 | 1.00 | 7.50 | 0.53 |
| other: a whole word | 11 | 533.63 ± 1.2% | 568.21 ± 1.0% | 988.69 ± 0.8% | 121.97 ± 0.4% | 568.04 ± 1.8% | 827.28 ± 0.4% | 26960.99 ± 0.7% | 532.56 ± 0.5% | 0.94 | 1.00 | 4.38 | 0.94 |
| other: a line's first word, second text | 17 | 483.52 ± 0.4% | 515.54 ± 0.3% | 850.99 ± 0.5% | 128.47 ± 0.2% | 708.26 ± 1.1% | refused | refused | 484.30 ± 0.5% | 0.94 | 1.00 | 3.76 | 0.68 |
| other: fourteen octets before an x | 16 | 103.43 ± 0.5% | 146.33 ± 0.5% | 169.98 ± 0.6% | 15.18 ± 0.5% | 452.46 ± 2.8% | 414.99 ± 0.8% | 12984.04 ± 0.2% | 103.50 ± 0.7% | 0.71 | 1.00 | 6.81 | 0.23 |
| other: a Greek word | 8 | 404.49 ± 0.4% | 554.41 ± 0.6% | 965.91 ± 0.5% | 59.06 ± 0.9% | 1382.77 ± 2.8% | 1783.88 ± 0.5% | refused | 404.59 ± 0.9% | 0.73 | 1.00 | 6.85 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15714.99 ± 0.6% | not timed | not timed | 16342.72 ± 2.0% | 1940.28 ± 21.0% | not timed | not timed | 15668.27 ± 0.8% | | 1.00 | 0.96 | 8.10 |
| 01-literal/sherlock-casei-en | 522 | 11003.68 ± 4.2% | not timed | not timed | 3597.05 ± 0.3% | 32.52 ± 11.2% | not timed | not timed | 11003.12 ± 3.2% | | 1.00 | 3.06 | 338.40 |
| 01-literal/sherlock-ru | 724 | 17090.92 ± 0.7% | not timed | not timed | 17265.27 ± 0.8% | 1432.91 ± 12.2% | not timed | not timed | 17131.70 ± 0.2% | | 1.00 | 0.99 | 11.93 |
| 01-literal/sherlock-casei-ru | 746 | 6135.60 ± 0.2% | not timed | not timed | 3333.39 ± 0.2% | 31.73 ± 0.6% | not timed | not timed | 6137.14 ± 0.1% | | 1.00 | 1.84 | 193.40 |
| 01-literal/sherlock-zh | 30 | 19944.58 ± 0.6% | not timed | not timed | 18646.50 ± 0.4% | 2559.43 ± 10.0% | not timed | not timed | 19920.45 ± 0.4% | | 1.00 | 1.07 | 7.79 |
| 02-literal-alternate/sherlock-en | 714 | 6138.41 ± 0.4% | not timed | not timed | 3937.99 ± 0.2% | 16.66 ± 0.2% | not timed | not timed | 6142.71 ± 0.3% | | 1.00 | 1.56 | 368.36 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1969.68 ± 1.5% | not timed | not timed | 696.97 ± 0.2% | 11.05 ± 0.1% | not timed | not timed | 1970.76 ± 0.8% | | 1.00 | 2.83 | 178.19 |
| 02-literal-alternate/sherlock-ru | 899 | 5503.74 ± 0.2% | not timed | not timed | 3252.55 ± 0.2% | 22.71 ± 0.1% | not timed | not timed | 5504.83 ± 0.1% | | 1.00 | 1.69 | 242.37 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.66 ± 0.4% | not timed | not timed | 1222.91 ± 0.6% | 9.15 ± 0.1% | not timed | not timed | 2044.20 ± 0.5% | | 1.00 | 1.68 | 224.08 |
| 02-literal-alternate/sherlock-zh | 207 | 7319.49 ± 0.3% | not timed | not timed | 4161.43 ± 0.1% | 31.53 ± 0.2% | not timed | not timed | 7311.24 ± 0.3% | | 1.00 | 1.76 | 232.12 |
| 03-date/ascii | 111817 | 133.60 ± 1.2% | not timed | not timed | 96.31 ± 0.1% | 0.20 ± 1.2% | not timed | not timed | 134.76 ± 0.6% | | 0.99 | 1.39 | 658.63 |
| 04-ruff-noqa/real | 84 | 436.50 ± 0.2% | not timed | not timed | 468.43 ± 0.3% | 19.44 ± 0.2% | not timed | not timed | 435.96 ± 0.2% | | 1.00 | 0.93 | 22.45 |
| 04-ruff-noqa/tweaked | 44 | 844.62 ± 0.1% | not timed | not timed | 467.09 ± 0.1% | 365.97 ± 0.6% | not timed | not timed | 846.37 ± 0.1% | | 1.00 | 1.81 | 2.31 |
| 05-lexer-veryl/single | 124800 | 5.44 ± 0.5% | not timed | not timed | 5.17 ± 0.3% | 0.20 ± 3.5% | not timed | not timed | 5.59 ± 0.6% | | 0.97 | 1.05 | 26.57 |
| 06-cloud-flare-redos/original | 107 | 440.14 ± 0.2% | not timed | not timed | 215.71 ± 0.0% | 25.05 ± 0.2% | not timed | not timed | 439.80 ± 0.1% | | 1.00 | 2.04 | 17.57 |
| 06-cloud-flare-redos/simplified-short | 102 | 439.77 ± 0.2% | not timed | not timed | 228.45 ± 0.2% | 26.69 ± 0.2% | not timed | not timed | 438.80 ± 0.4% | | 1.00 | 1.93 | 16.48 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.93 ± 0.1% | not timed | not timed | 256.20 ± 0.1% | 28.79 ± 0.3% | not timed | not timed | 629.43 ± 0.1% | | 1.00 | 2.45 | 21.85 |
| 07-unicode-character-data/parse-line | 558784 | 235.78 ± 2.3% | not timed | not timed | 179.74 ± 0.1% | 41.17 ± 19.5% | not timed | not timed | 236.00 ± 13.8% | | 1.00 | 1.31 | 5.73 |
| 08-words/all-english | 56691 | 129.24 ± 0.5% | not timed | not timed | 83.00 ± 0.2% | 13.25 ± 9.5% | not timed | not timed | 129.09 ± 0.5% | | 1.00 | 1.56 | 9.75 |
| 08-words/long-english | 839 | 617.13 ± 0.6% | not timed | not timed | 595.33 ± 0.2% | 32.74 ± 0.1% | not timed | not timed | 616.54 ± 1.1% | | 1.00 | 1.04 | 18.85 |
| 09-aws-keys/full | 0 | 440.80 ± 0.2% | not timed | not timed | 479.91 ± 0.1% | 64.33 ± 0.2% | not timed | not timed | 440.82 ± 0.3% | | 1.00 | 0.92 | 6.85 |
| 09-aws-keys/quick | 0 | 875.82 ± 0.3% | not timed | not timed | 998.99 ± 0.3% | 422.07 ± 2.7% | not timed | not timed | 875.28 ± 0.3% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 584.58 ± 3.3% | not timed | not timed | 518.82 ± 0.5% | 19.57 ± 0.5% | not timed | not timed | 577.31 ± 3.1% | | 1.01 | 1.13 | 29.87 |
| 10-bounded-repeat/letters-ru | 3475 | 505.60 ± 1.6% | not timed | not timed | 479.61 ± 0.2% | 22.04 ± 9.8% | not timed | not timed | 504.60 ± 0.7% | | 1.00 | 1.05 | 22.94 |
| 10-bounded-repeat/context | 53 | 84.86 ± 2.0% | not timed | not timed | 66.06 ± 0.5% | 19.82 ± 0.2% | not timed | not timed | 85.22 ± 1.7% | | 1.00 | 1.28 | 4.28 |
| 10-bounded-repeat/capitals | 11 | 639.40 ± 8.2% | not timed | not timed | 618.24 ± 0.1% | 36.63 ± 0.2% | not timed | not timed | 637.26 ± 8.0% | | 1.00 | 1.03 | 17.45 |
| 11-unstructured-to-json/extract | 600 | 57.67 ± 0.2% | not timed | not timed | 76.89 ± 0.1% | 48.99 ± 0.3% | not timed | not timed | 57.50 ± 0.3% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 558.86 ± 1.7% | not timed | not timed | 562.56 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 561.74 ± 1.4% | | 0.99 | 0.99 | 1380.31 |
| 14-quadratic/1x | 100 | 22.12 ± 1.2% | not timed | not timed | 10.03 ± 0.3% | 0.98 ± 3.6% | not timed | not timed | 22.29 ± 0.8% | | 0.99 | 2.21 | 22.65 |
| 14-quadratic/2x | 200 | 19.77 ± 0.5% | not timed | not timed | 5.53 ± 0.2% | 0.53 ± 1.7% | not timed | not timed | 19.87 ± 0.5% | | 0.99 | 3.58 | 37.30 |
| 14-quadratic/10x | 1000 | 12.33 ± 1.2% | not timed | not timed | 1.21 ± 0.0% | 0.11 ± 1.9% | not timed | not timed | 12.34 ± 1.2% | | 1.00 | 10.16 | 107.92 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 0.7% | not timed | not timed | 0.34 ± 0.8% | 0.54 ± 4.5% | not timed | not timed | 1.22 ± 0.5% | | 1.00 | 3.52 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 102.91 ± 0.4% | not timed | not timed | 14.01 ± 0.4% | 139.43 ± 2.5% | not timed | not timed | 103.48 ± 0.2% | | 0.99 | 7.34 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 13.90 ± 1.4% | not timed | not timed | 2.52 ± 0.8% | 6.44 ± 1.2% | not timed | not timed | 13.97 ± 1.6% | | 1.00 | 5.52 | 2.16 |
| 07-unicode-character-data/compile | 1 | 107.09 ± 0.4% | not timed | not timed | 26.15 ± 0.2% | 37.07 ± 2.9% | not timed | not timed | 107.22 ± 0.3% | | 1.00 | 4.10 | 2.89 |
| 09-aws-keys/compile-full | 1 | 52.35 ± 0.3% | not timed | not timed | 8.37 ± 0.6% | 23.36 ± 0.5% | not timed | not timed | 52.44 ± 1.5% | | 1.00 | 6.25 | 2.24 |
| 09-aws-keys/compile-quick | 1 | 180.93 ± 1.4% | not timed | not timed | 48.06 ± 0.2% | 134.38 ± 1.9% | not timed | not timed | 181.94 ± 0.2% | | 0.99 | 3.76 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 70.45 ± 1.7% | not timed | not timed | 11.19 ± 0.4% | 15.90 ± 12.9% | not timed | not timed | 71.12 ± 0.4% | | 0.99 | 6.30 | 4.43 |
| 10-bounded-repeat/compile-capitals | 1 | 83.60 ± 0.7% | not timed | not timed | 8.12 ± 0.4% | 23.80 ± 1.1% | not timed | not timed | 83.90 ± 1.1% | | 1.00 | 10.29 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 168.67 ± 1.5% | not timed | not timed | 40.65 ± 0.5% | 69.00 ± 3.2% | not timed | not timed | 169.47 ± 0.3% | | 1.00 | 4.15 | 2.44 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.5% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 18.5% | not timed | not timed | 0.35 ± 1.6% | | 1.00 | 4.97 | 3.60 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.54 ± 5.6% | not timed | not timed | 6.55 ± 0.3% | 0.60 ± 23.1% | not timed | not timed | 7.53 ± 2.5% | | 1.00 | 1.15 | 12.66 |
| dictionary/search/english-10 | 690 | 211.69 ± 1.9% | not timed | not timed | 166.09 ± 0.4% | 0.00 ± 0.5% | not timed | not timed | 198.53 ± 6.1% | | 1.07 | 1.27 | 75259.34 |
| dictionary/search/english-15 | 15 | 559.68 ± 1.4% | not timed | not timed | 561.48 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 562.00 ± 1.6% | | 1.00 | 1.00 | 1522.75 |
| folly/awyer-inn-busted | 1 | 21509.21 ± 0.1% | not timed | not timed | 143.30 ± 0.1% | 43.78 ± 0.2% | not timed | not timed | 21570.92 ± 0.1% | | 1.00 | 150.10 | 491.28 |
| folly/literal-never-match-rare | 0 | 21130.95 ± 0.9% | not timed | not timed | 19913.31 ± 0.3% | 40899.09 ± 0.4% | not timed | not timed | 21150.42 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12551.99 ± 0.7% | not timed | not timed | 19876.21 ± 0.2% | 2184.89 ± 0.8% | not timed | not timed | 12558.12 ± 0.4% | | 1.00 | 0.63 | 5.74 |
| folly/literal-never-match-tricksy | 1 | 3254.43 ± 0.1% | not timed | not timed | 4410.71 ± 0.2% | 2982.49 ± 6.1% | not timed | not timed | 3254.40 ± 0.3% | | 1.00 | 0.74 | 1.09 |
| grep/every-line | 239963 | 1300.88 ± 0.6% | not timed | not timed | 959.63 ± 1.0% | 384.66 ± 19.0% | not timed | not timed | 1306.74 ± 0.5% | | 1.00 | 1.36 | 3.38 |
| grep/long-words-ascii | 5073 | 459.15 ± 0.2% | not timed | not timed | 468.14 ± 0.4% | 45.94 ± 8.1% | not timed | not timed | 459.83 ± 0.3% | | 1.00 | 0.98 | 10.00 |
| imported/leipzig/twain | 811 | 20626.81 ± 1.1% | not timed | not timed | 19482.99 ± 1.0% | 11920.86 ± 10.4% | not timed | not timed | 20628.22 ± 0.5% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9097.23 ± 1.3% | not timed | not timed | 4251.26 ± 0.1% | 37.71 ± 0.4% | not timed | not timed | 9107.32 ± 0.9% | | 1.00 | 2.14 | 241.26 |
| imported/leipzig/shing | 1540 | 15252.83 ± 1.7% | not timed | not timed | 13462.67 ± 0.7% | 34.04 ± 0.1% | not timed | not timed | 15468.13 ± 1.8% | | 0.99 | 1.13 | 448.10 |
| imported/leipzig/huck-saw | 262 | 8244.96 ± 2.8% | not timed | not timed | 5601.41 ± 0.3% | 31.67 ± 0.1% | not timed | not timed | 8381.35 ± 3.1% | | 0.98 | 1.47 | 260.31 |
| imported/leipzig/word-ending-nn | 262 | 603.46 ± 0.2% | not timed | not timed | 617.76 ± 0.1% | 24.77 ± 0.2% | not timed | not timed | 605.68 ± 0.2% | | 1.00 | 0.98 | 24.37 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11247.72 ± 0.9% | not timed | not timed | 4513.27 ± 1.0% | 11.49 ± 0.2% | not timed | not timed | 11294.13 ± 1.3% | | 1.00 | 2.49 | 978.68 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7828.99 ± 16.5% | not timed | not timed | 5485.06 ± 2.6% | 16.91 ± 0.1% | not timed | not timed | 7876.65 ± 1.5% | | 0.99 | 1.43 | 462.94 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4180.01 ± 0.4% | not timed | not timed | 415.76 ± 0.7% | 11.09 ± 0.2% | not timed | not timed | 4172.71 ± 1.5% | | 1.00 | 10.05 | 377.06 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7276.45 ± 3.6% | not timed | not timed | 615.45 ± 0.1% | 11.13 ± 0.1% | not timed | not timed | 7358.86 ± 3.2% | | 0.99 | 11.82 | 653.92 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7047.85 ± 4.4% | not timed | not timed | 615.31 ± 0.1% | 9.74 ± 0.0% | not timed | not timed | 7118.02 ± 3.8% | | 0.99 | 11.45 | 723.85 |
| imported/leipzig/tom-river | 2 | 6387.02 ± 1.4% | not timed | not timed | 5111.05 ± 0.8% | 31.01 ± 0.1% | not timed | not timed | 6423.41 ± 3.2% | | 0.99 | 1.25 | 205.95 |
| imported/leipzig/ing | 78424 | 604.55 ± 0.5% | not timed | not timed | 570.34 ± 0.0% | 28.08 ± 3.2% | not timed | not timed | 603.50 ± 0.6% | | 1.00 | 1.06 | 21.53 |
| imported/leipzig/ing-whitespace | 55248 | 1907.56 ± 6.0% | not timed | not timed | 2068.16 ± 0.6% | 20.53 ± 2.8% | not timed | not timed | 1923.49 ± 2.4% | | 0.99 | 0.92 | 92.93 |
| imported/leipzig/awyer-inn | 209 | 6358.32 ± 1.4% | not timed | not timed | 4272.35 ± 0.1% | 22.65 ± 0.1% | not timed | not timed | 6396.14 ± 1.2% | | 0.99 | 1.49 | 280.76 |
| imported/leipzig/quotes-bounded | 8886 | 2480.80 ± 1.0% | not timed | not timed | 2967.58 ± 1.0% | 38.28 ± 0.2% | not timed | not timed | 2460.82 ± 1.0% | | 1.01 | 0.84 | 64.81 |
| imported/leipzig/non-ascii-alternate | 2 | 12666.03 ± 5.7% | not timed | not timed | 5657.57 ± 0.3% | 50.69 ± 0.1% | not timed | not timed | 12897.42 ± 2.0% | | 0.98 | 2.24 | 249.87 |
| imported/leipzig/math-symbols | 69 | 1984.00 ± 0.4% | not timed | not timed | 619.35 ± 0.0% | 36.57 ± 0.2% | not timed | not timed | 1984.03 ± 0.7% | | 1.00 | 3.20 | 54.25 |
| imported/leipzig/bounded-strings-ending-z | 0 | 635.79 ± 2.4% | not timed | not timed | 615.00 ± 0.0% | 22.46 ± 0.2% | not timed | not timed | 631.96 ± 1.7% | | 1.01 | 1.03 | 28.31 |
| imported/lh3lh3-reb/uri | 17549 | 676.75 ± 0.1% | not timed | not timed | 1078.19 ± 0.2% | 28.27 ± 2.3% | not timed | not timed | 681.18 ± 0.1% | | 0.99 | 0.63 | 23.94 |
| imported/lh3lh3-reb/email | 15057 | 674.60 ± 0.1% | not timed | not timed | 1161.80 ± 0.2% | 30.90 ± 2.5% | not timed | not timed | 676.52 ± 0.2% | | 1.00 | 0.58 | 21.83 |
| imported/lh3lh3-reb/date | 668 | 892.96 ± 0.2% | not timed | not timed | 1036.63 ± 0.3% | 51.25 ± 4.0% | not timed | not timed | 893.36 ± 0.3% | | 1.00 | 0.86 | 17.42 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.02 ± 0.1% | not timed | not timed | 424.14 ± 0.1% | 15.78 ± 1.3% | not timed | not timed | 647.26 ± 0.1% | | 1.00 | 1.52 | 40.82 |
| imported/mariomka/email | 92 | 24268.45 ± 1.8% | not timed | not timed | 29497.56 ± 1.0% | 32.84 ± 0.2% | not timed | not timed | 24525.48 ± 1.5% | | 0.99 | 0.82 | 738.99 |
| imported/mariomka/uri | 5301 | 5554.02 ± 0.9% | not timed | not timed | 6125.31 ± 0.1% | 32.77 ± 0.1% | not timed | not timed | 5593.60 ± 1.0% | | 0.99 | 0.91 | 169.49 |
| imported/mariomka/ip | 5 | 2600.58 ± 3.1% | not timed | not timed | 2968.01 ± 0.1% | 21.02 ± 0.1% | not timed | not timed | 2603.47 ± 3.5% | | 1.00 | 0.88 | 123.71 |
| imported/rsc/no-exponential | 0 | 606.88 ± 0.1% | not timed | not timed | 320.80 ± 0.5% | 23.82 ± 0.1% | not timed | not timed | 608.73 ± 0.1% | | 1.00 | 1.89 | 25.48 |
| imported/rsc/literal | 1 | 1526.84 ± 1.9% | not timed | not timed | 1602.87 ± 4.0% | 186.85 ± 15.5% | not timed | not timed | 1522.86 ± 5.4% | | 1.00 | 0.95 | 8.17 |
| imported/rsc/not-literal | 2 | 778.07 ± 0.1% | not timed | not timed | 744.34 ± 0.5% | 46.07 ± 8.8% | not timed | not timed | 779.47 ± 2.2% | | 1.00 | 1.05 | 16.89 |
| imported/rsc/match-class | 1 | 1474.99 ± 10.7% | not timed | not timed | 1676.25 ± 0.2% | 58.32 ± 1.8% | not timed | not timed | 1475.53 ± 0.4% | | 1.00 | 0.88 | 25.29 |
| imported/rsc/match-class-in-range | 1 | 1470.30 ± 2.6% | not timed | not timed | 2368.49 ± 6.1% | 59.88 ± 6.9% | not timed | not timed | 1472.04 ± 0.4% | | 1.00 | 0.62 | 24.55 |
| imported/rsc/match-class-unicode | 1 | 538.81 ± 7.0% | not timed | not timed | 507.18 ± 0.2% | 72.63 ± 1.0% | not timed | not timed | 540.23 ± 0.2% | | 1.00 | 1.06 | 7.42 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1461.13 ± 0.2% | not timed | not timed | 941.45 ± 0.3% | 228.07 ± 0.5% | not timed | not timed | 1452.92 ± 0.1% | | 1.01 | 1.55 | 6.41 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21879.85 ± 0.2% | not timed | not timed | 14089.00 ± 0.4% | 3409.57 ± 0.4% | not timed | not timed | 21798.22 ± 0.4% | | 1.00 | 1.55 | 6.42 |
| imported/rsc/anchored-literal-short-match | 4 | 722.39 ± 1.6% | not timed | not timed | 462.38 ± 0.4% | 84.27 ± 4.3% | not timed | not timed | 724.53 ± 1.8% | | 1.00 | 1.56 | 8.57 |
| imported/rsc/anchored-literal-long-match | 4 | 10870.33 ± 1.7% | not timed | not timed | 7368.22 ± 0.2% | 1231.45 ± 8.0% | not timed | not timed | 10842.57 ± 1.8% | | 1.00 | 1.48 | 8.83 |
| imported/rsc/one-pass-short | 17 | 371.41 ± 1.2% | not timed | not timed | 219.83 ± 0.4% | 31.92 ± 10.9% | not timed | not timed | 371.65 ± 12.8% | | 1.00 | 1.69 | 11.64 |
| imported/rsc/one-pass-short-not | 17 | 270.09 ± 7.0% | not timed | not timed | 224.50 ± 0.3% | 30.44 ± 9.6% | not timed | not timed | 270.71 ± 2.5% | | 1.00 | 1.20 | 8.87 |
| imported/rsc/one-pass-long-prefix | 26 | 360.49 ± 7.7% | not timed | not timed | 284.20 ± 0.3% | 96.45 ± 14.3% | not timed | not timed | 362.40 ± 1.2% | | 0.99 | 1.27 | 3.74 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.32 ± 2.0% | not timed | not timed | 283.16 ± 0.6% | 66.26 ± 19.4% | not timed | not timed | 363.31 ± 2.0% | | 0.99 | 1.27 | 5.42 |
| imported/rsc/long-needle1 | 31 | 21963.15 ± 0.1% | not timed | not timed | 20156.97 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 21956.29 ± 0.1% | | 1.00 | 1.09 | 5840.02 |
| imported/rsc/long-needle2 | 31 | 22105.71 ± 0.1% | not timed | not timed | 216.50 ± 0.3% | 3.75 ± 0.1% | not timed | not timed | 22098.18 ± 0.1% | | 1.00 | 102.10 | 5891.06 |
| imported/rsc/easy0-32 | 26 | 1588.42 ± 0.5% | not timed | not timed | 1523.92 ± 0.4% | 148.97 ± 20.9% | not timed | not timed | 1572.17 ± 2.5% | | 1.01 | 1.04 | 10.66 |
| imported/rsc/easy0-1k | 26 | 13635.40 ± 2.2% | not timed | not timed | 12324.58 ± 0.4% | 2290.65 ± 20.2% | not timed | not timed | 13634.80 ± 0.4% | | 1.00 | 1.11 | 5.95 |
| imported/rsc/easy0-32k | 26 | 22752.32 ± 0.2% | not timed | not timed | 20307.56 ± 0.2% | 18859.69 ± 0.1% | not timed | not timed | 22754.81 ± 0.1% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21714.18 ± 1.4% | not timed | not timed | 19960.32 ± 1.8% | 36975.83 ± 1.5% | not timed | not timed | 21578.92 ± 1.4% | | 1.01 | 1.09 | 0.59 |
| imported/rsc/easy1-32 | 19 | 774.39 ± 2.2% | not timed | not timed | 633.36 ± 0.1% | 123.23 ± 20.4% | not timed | not timed | 768.83 ± 2.5% | | 1.01 | 1.22 | 6.28 |
| imported/rsc/easy1-1k | 19 | 15872.08 ± 2.3% | not timed | not timed | 12769.61 ± 0.3% | 2499.86 ± 19.6% | not timed | not timed | 15724.16 ± 0.3% | | 1.01 | 1.24 | 6.35 |
| imported/rsc/easy1-32k | 19 | 496693.94 ± 0.3% | not timed | not timed | 400741.09 ± 0.4% | 20527.27 ± 0.1% | not timed | not timed | 493062.75 ± 0.2% | | 1.01 | 1.24 | 24.20 |
| imported/rsc/easy1-1mb | 19 | 15922456.93 ± 0.3% | not timed | not timed | 12777840.47 ± 0.2% | 39014.78 ± 2.4% | not timed | not timed | 15810634.12 ± 0.4% | | 1.01 | 1.25 | 408.11 |
| imported/rsc/medium-32 | 27 | 738.65 ± 6.7% | not timed | not timed | 631.62 ± 0.2% | 69.82 ± 2.0% | not timed | not timed | 740.55 ± 0.2% | | 1.00 | 1.17 | 10.58 |
| imported/rsc/medium-1k | 27 | 13171.71 ± 0.1% | not timed | not timed | 11143.71 ± 0.4% | 72.17 ± 0.1% | not timed | not timed | 13161.43 ± 0.1% | | 1.00 | 1.18 | 182.51 |
| imported/rsc/medium-32k | 27 | 410782.29 ± 0.1% | not timed | not timed | 345837.82 ± 0.1% | 48.95 ± 0.1% | not timed | not timed | 408013.67 ± 0.1% | | 1.01 | 1.19 | 8392.48 |
| imported/rsc/medium-1mb | 27 | 13142465.00 ± 0.2% | not timed | not timed | 11127425.04 ± 0.1% | 48.82 ± 0.2% | not timed | not timed | 13117708.31 ± 0.2% | | 1.00 | 1.18 | 269211.81 |
| imported/rsc/hard-32 | 58 | 424.72 ± 2.1% | not timed | not timed | 366.57 ± 0.1% | 49.70 ± 8.0% | not timed | not timed | 422.88 ± 0.2% | | 1.00 | 1.16 | 8.55 |
| imported/rsc/hard-1k | 27 | 12933.34 ± 0.2% | not timed | not timed | 11600.80 ± 0.2% | 40.62 ± 0.1% | not timed | not timed | 12877.92 ± 0.2% | | 1.00 | 1.11 | 318.41 |
| imported/rsc/hard-32k | 27 | 404538.19 ± 0.2% | not timed | not timed | 360528.96 ± 0.5% | 29.38 ± 0.0% | not timed | not timed | 402102.16 ± 0.1% | | 1.01 | 1.12 | 13767.37 |
| imported/rsc/hard-1mb | 51 | 8409939.06 ± 0.1% | not timed | not timed | 7256124.94 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 8400543.53 ± 0.2% | | 1.00 | 1.16 | 286503.20 |
| imported/rsc/reallyhard0-32 | 58 | 264.48 ± 2.5% | not timed | not timed | 221.55 ± 0.0% | 49.52 ± 8.3% | not timed | not timed | 264.07 ± 0.3% | | 1.00 | 1.19 | 5.34 |
| imported/rsc/reallyhard0-1k | 27 | 577.43 ± 0.7% | not timed | not timed | 582.44 ± 0.1% | 40.52 ± 0.1% | not timed | not timed | 579.50 ± 0.4% | | 1.00 | 0.99 | 14.25 |
| imported/rsc/reallyhard0-32k | 27 | 603.59 ± 0.5% | not timed | not timed | 617.11 ± 0.1% | 29.39 ± 0.1% | not timed | not timed | 601.22 ± 0.3% | | 1.00 | 0.98 | 20.54 |
| imported/rsc/reallyhard0-1mb | 51 | 626.45 ± 1.1% | not timed | not timed | 617.16 ± 0.2% | 29.41 ± 0.2% | not timed | not timed | 626.02 ± 0.7% | | 1.00 | 1.02 | 21.30 |
| imported/rsc/reallyreallyhard0-32 | 47 | 285.04 ± 1.7% | not timed | not timed | 197.17 ± 1.1% | 60.30 ± 15.6% | not timed | not timed | 286.88 ± 1.4% | | 0.99 | 1.45 | 4.73 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7067.07 ± 0.1% | not timed | not timed | 5934.56 ± 0.1% | 34.00 ± 0.5% | not timed | not timed | 7088.58 ± 0.0% | | 1.00 | 1.19 | 207.87 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21467.21 ± 0.2% | not timed | not timed | 19204.82 ± 0.2% | 25.02 ± 1.6% | not timed | not timed | 21475.47 ± 0.0% | | 1.00 | 1.12 | 857.91 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21853.68 ± 0.8% | not timed | not timed | 19929.37 ± 1.5% | 24.92 ± 0.2% | not timed | not timed | 21850.27 ± 1.1% | | 1.00 | 1.10 | 877.09 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.15 ± 1.7% | not timed | not timed | 211.74 ± 0.3% | 60.97 ± 14.0% | not timed | not timed | 282.29 ± 1.3% | | 1.00 | 1.33 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5937.42 ± 0.2% | not timed | not timed | 6160.35 ± 0.1% | 34.07 ± 2.0% | not timed | not timed | 5945.96 ± 0.1% | | 1.00 | 0.96 | 174.26 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21393.28 ± 0.2% | not timed | not timed | 19252.72 ± 0.0% | 24.40 ± 3.6% | not timed | not timed | 21398.98 ± 0.1% | | 1.00 | 1.11 | 876.91 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21388.39 ± 1.6% | not timed | not timed | 19840.95 ± 1.3% | 24.93 ± 3.1% | not timed | not timed | 21330.68 ± 2.3% | | 1.00 | 1.08 | 858.00 |
| imported/sherlock/name-sherlock | 776 | 19897.22 ± 6.3% | not timed | not timed | 18574.22 ± 0.6% | 10121.92 ± 17.2% | not timed | not timed | 19927.87 ± 3.2% | | 1.00 | 1.07 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15266.45 ± 1.4% | not timed | not timed | 15619.57 ± 0.3% | 3228.32 ± 13.4% | not timed | not timed | 15397.09 ± 1.5% | | 0.99 | 0.98 | 4.73 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19939.03 ± 2.0% | not timed | not timed | 18565.93 ± 0.5% | 8088.88 ± 49.6% | not timed | not timed | 19956.20 ± 2.3% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15770.23 ± 0.5% | not timed | not timed | 4013.38 ± 0.2% | 32.57 ± 0.1% | not timed | not timed | 15775.70 ± 0.6% | | 1.00 | 3.93 | 484.25 |
| imported/sherlock/name-holmes-casei | 2802 | 9088.65 ± 5.9% | not timed | not timed | 3314.98 ± 0.6% | 37.41 ± 0.1% | not timed | not timed | 9088.33 ± 5.3% | | 1.00 | 2.74 | 242.97 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12910.73 ± 5.5% | not timed | not timed | 3957.53 ± 0.1% | 32.49 ± 0.2% | not timed | not timed | 12920.47 ± 1.7% | | 1.00 | 3.26 | 397.38 |
| imported/sherlock/name-whitespace | 1461 | 15410.04 ± 1.6% | not timed | not timed | 14543.60 ± 0.2% | 6603.56 ± 20.5% | not timed | not timed | 15503.65 ± 1.6% | | 0.99 | 1.06 | 2.33 |
| imported/sherlock/name-alt1 | 1142 | 11625.35 ± 0.2% | not timed | not timed | 16447.74 ± 0.8% | 4124.99 ± 23.7% | not timed | not timed | 11598.83 ± 2.6% | | 1.00 | 0.71 | 2.82 |
| imported/sherlock/name-alt2 | 3542 | 8915.15 ± 0.4% | not timed | not timed | 3830.67 ± 0.1% | 31.18 ± 0.1% | not timed | not timed | 8929.02 ± 0.2% | | 1.00 | 2.33 | 285.94 |
| imported/sherlock/name-alt3 | 4507 | 5553.38 ± 0.5% | not timed | not timed | 3634.02 ± 0.1% | 9.95 ± 4.4% | not timed | not timed | 5548.37 ± 0.5% | | 1.00 | 1.53 | 557.90 |
| imported/sherlock/name-alt3-casei | 4593 | 1523.60 ± 1.1% | not timed | not timed | 285.65 ± 0.1% | 6.44 ± 0.1% | not timed | not timed | 1529.65 ± 0.8% | | 1.00 | 5.33 | 236.75 |
| imported/sherlock/name-alt4 | 3686 | 6460.20 ± 0.2% | not timed | not timed | 3779.29 ± 0.1% | 31.41 ± 0.1% | not timed | not timed | 6463.43 ± 0.2% | | 1.00 | 1.71 | 205.67 |
| imported/sherlock/name-alt4-casei | 4254 | 2819.20 ± 1.9% | not timed | not timed | 2585.48 ± 0.2% | 19.77 ± 0.3% | not timed | not timed | 2817.64 ± 1.3% | | 1.00 | 1.09 | 142.57 |
| imported/sherlock/name-alt5 | 4028 | 6390.88 ± 0.2% | not timed | not timed | 3748.57 ± 0.1% | 21.85 ± 0.2% | not timed | not timed | 6393.18 ± 0.1% | | 1.00 | 1.70 | 292.48 |
| imported/sherlock/name-alt5-casei | 4104 | 3500.40 ± 1.7% | not timed | not timed | 2222.43 ± 0.1% | 14.31 ± 0.1% | not timed | not timed | 3501.99 ± 0.7% | | 1.00 | 1.58 | 244.60 |
| imported/sherlock/no-match-uncommon | 0 | 21788.57 ± 0.2% | not timed | not timed | 19665.70 ± 0.5% | 36302.56 ± 0.7% | not timed | not timed | 21780.67 ± 0.3% | | 1.00 | 1.11 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21563.65 ± 0.4% | not timed | not timed | 19624.40 ± 0.5% | 1287.14 ± 1.3% | not timed | not timed | 21605.05 ± 0.5% | | 1.00 | 1.10 | 16.75 |
| imported/sherlock/no-match-really-common | 0 | 16203.46 ± 2.7% | not timed | not timed | 18790.74 ± 0.6% | 1278.14 ± 1.4% | not timed | not timed | 16335.58 ± 2.0% | | 0.99 | 0.86 | 12.68 |
| imported/sherlock/the-lower | 21654 | 2299.43 ± 0.7% | not timed | not timed | 2337.48 ± 0.1% | 237.82 ± 15.8% | not timed | not timed | 2303.76 ± 1.6% | | 1.00 | 0.98 | 9.67 |
| imported/sherlock/the-upper | 2223 | 12731.14 ± 1.1% | not timed | not timed | 13614.95 ± 1.1% | 2689.84 ± 1.5% | not timed | not timed | 12805.35 ± 1.1% | | 0.99 | 0.94 | 4.73 |
| imported/sherlock/the-casei | 23961 | 1990.97 ± 1.2% | not timed | not timed | 1315.01 ± 0.1% | 34.66 ± 25.5% | not timed | not timed | 1990.18 ± 0.2% | | 1.00 | 1.51 | 57.45 |
| imported/sherlock/everything-greedy | 581881 | 282.33 ± 0.1% | not timed | not timed | 166.09 ± 0.0% | 28.32 ± 17.6% | not timed | not timed | 282.47 ± 1.4% | | 1.00 | 1.70 | 9.97 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.80 ± 0.1% | not timed | not timed | 212.23 ± 0.3% | 32.94 ± 0.1% | not timed | not timed | 490.83 ± 0.0% | | 1.00 | 2.32 | 14.93 |
| imported/sherlock/letters | 447175 | 61.58 ± 1.3% | not timed | not timed | 32.90 ± 0.2% | 5.96 ± 22.8% | not timed | not timed | 61.83 ± 0.5% | | 1.00 | 1.87 | 10.33 |
| imported/sherlock/letters-upper | 14180 | 447.90 ± 1.4% | not timed | not timed | 367.88 ± 0.1% | 29.64 ± 23.4% | not timed | not timed | 445.99 ± 0.2% | | 1.00 | 1.22 | 15.11 |
| imported/sherlock/letters-lower | 432995 | 62.39 ± 1.1% | not timed | not timed | 33.75 ± 0.1% | 6.78 ± 43.4% | not timed | not timed | 62.89 ± 0.8% | | 0.99 | 1.85 | 9.21 |
| imported/sherlock/words | 447639 | 113.17 ± 0.8% | not timed | not timed | 82.55 ± 0.1% | 14.06 ± 30.1% | not timed | not timed | 113.19 ± 0.7% | | 1.00 | 1.37 | 8.05 |
| imported/sherlock/before-holmes | 4073 | 10316.92 ± 0.4% | not timed | not timed | 8501.25 ± 0.2% | 24.10 ± 1.5% | not timed | not timed | 10334.00 ± 0.3% | | 1.00 | 1.21 | 428.15 |
| imported/sherlock/before-after-holmes | 2593 | 9980.64 ± 0.9% | not timed | not timed | 9538.91 ± 0.3% | 23.93 ± 0.6% | not timed | not timed | 10002.35 ± 0.5% | | 1.00 | 1.05 | 417.04 |
| imported/sherlock/holmes-cochar-watson | 150 | 5196.48 ± 0.3% | not timed | not timed | 3433.22 ± 0.2% | 30.97 ± 0.1% | not timed | not timed | 5213.42 ± 0.2% | | 1.00 | 1.51 | 167.80 |
| imported/sherlock/holmes-coword-watson | 14309 | 1156.58 ± 0.4% | not timed | not timed | 1124.40 ± 0.2% | 6.78 ± 0.2% | not timed | not timed | 1155.29 ± 0.2% | | 1.00 | 1.03 | 170.62 |
| imported/sherlock/quotes | 14437 | 1575.15 ± 0.2% | not timed | not timed | 1755.43 ± 1.3% | 35.20 ± 0.1% | not timed | not timed | 1577.13 ± 0.2% | | 1.00 | 0.90 | 44.75 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17565.99 ± 0.4% | not timed | not timed | 16177.78 ± 0.1% | 36.81 ± 0.3% | not timed | not timed | 17488.14 ± 0.2% | | 1.00 | 1.09 | 477.16 |
| imported/sherlock/word-ending-n | 35297 | 480.32 ± 1.0% | not timed | not timed | 409.01 ± 0.1% | 23.62 ± 16.7% | not timed | not timed | 480.31 ± 0.4% | | 1.00 | 1.17 | 20.34 |
| imported/sherlock/repeated-class-negation | 2130 | 14977.80 ± 0.9% | not timed | not timed | 11031.07 ± 0.4% | 11.59 ± 0.1% | not timed | not timed | 14988.42 ± 0.4% | | 1.00 | 1.36 | 1292.25 |
| imported/sherlock/ing-suffix | 20547 | 558.72 ± 0.3% | not timed | not timed | 516.38 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 559.16 ± 0.2% | | 1.00 | 1.08 | 19.38 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1673.90 ± 0.5% | not timed | not timed | 2105.41 ± 0.5% | 20.53 ± 0.3% | not timed | not timed | 1672.11 ± 0.8% | | 1.00 | 0.80 | 81.55 |
| opt/accelerate/whole-line | 239963 | 458.10 ± 0.3% | not timed | not timed | 375.02 ± 0.2% | 92.43 ± 15.4% | not timed | not timed | 457.69 ± 0.2% | | 1.00 | 1.22 | 4.96 |
| opt/accelerate/non-dna | 16745 | 432.03 ± 0.3% | not timed | not timed | 398.79 ± 0.1% | 29.45 ± 21.1% | not timed | not timed | 431.32 ± 9.7% | | 1.00 | 1.08 | 14.67 |
| opt/backtrack/words-english | 40536 | 141.27 ± 0.2% | not timed | not timed | 94.18 ± 0.2% | 19.83 ± 6.1% | not timed | not timed | 141.11 ± 5.4% | | 1.00 | 1.50 | 7.12 |
| opt/fixed-length/too-small-ascii | 0 | 314.97 ± 0.3% | not timed | not timed | 686.57 ± 6.0% | 80.34 ± 1.0% | not timed | not timed | 315.05 ± 0.4% | | 1.00 | 0.46 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3481.36 ± 0.3% | not timed | not timed | 5783.93 ± 0.4% | 124.96 ± 0.1% | not timed | not timed | 3488.34 ± 0.5% | | 1.00 | 0.60 | 27.86 |
| opt/fixed-length/go33484-1 | 0 | 668957.12 ± 0.3% | not timed | not timed | 1109622.65 ± 0.1% | 61398.70 ± 0.4% | not timed | not timed | 669440.70 ± 0.4% | | 1.00 | 0.60 | 10.90 |
| opt/fixed-length/go33484-2 | 0 | 669480.63 ± 0.3% | not timed | not timed | 1112324.76 ± 0.1% | 32415.95 ± 0.5% | not timed | not timed | 669539.24 ± 0.1% | | 1.00 | 0.60 | 20.65 |
| opt/fixed-length/go33484-3 | 0 | 67001.80 ± 0.7% | not timed | not timed | 111727.44 ± 0.1% | 764.33 ± 0.2% | not timed | not timed | 66889.51 ± 0.6% | | 1.00 | 0.60 | 87.66 |
| opt/literal-alt/one-pattern | 1 | 550.00 ± 1.9% | not timed | not timed | 543.87 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 548.37 ± 1.4% | | 1.00 | 1.01 | 1377.78 |
| opt/onepass/fn-predicate | 916 | 364.72 ± 0.7% | not timed | not timed | 338.43 ± 0.2% | 201.49 ± 16.0% | not timed | not timed | 368.33 ± 0.8% | | 0.99 | 1.08 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 180.35 ± 13.8% | not timed | not timed | 202.48 ± 0.3% | 82.21 ± 10.9% | not timed | not timed | 181.92 ± 7.5% | | 0.99 | 0.89 | 2.19 |
| opt/prefilter/literal-english | 1 | 20497.98 ± 0.5% | not timed | not timed | 19698.08 ± 0.3% | 17403.46 ± 0.8% | not timed | not timed | 20551.90 ± 1.0% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14434.72 ± 0.4% | not timed | not timed | 4313.68 ± 0.2% | 32.76 ± 0.2% | not timed | not timed | 14461.70 ± 0.3% | | 1.00 | 3.35 | 440.63 |
| opt/prefilter/literal-russian | 1 | 21339.95 ± 0.3% | not timed | not timed | 19864.47 ± 0.3% | 3325.72 ± 0.1% | not timed | not timed | 21372.46 ± 0.4% | | 1.00 | 1.07 | 6.42 |
| opt/prefilter/literal-casei-russian | 1 | 8594.53 ± 0.6% | not timed | not timed | 3891.74 ± 0.2% | 31.86 ± 0.4% | not timed | not timed | 8585.54 ± 0.5% | | 1.00 | 2.21 | 269.79 |
| opt/prefilter/rust-functions | 948 | 6818.57 ± 0.1% | not timed | not timed | 8930.13 ± 0.5% | 1875.55 ± 0.5% | not timed | not timed | 6824.24 ± 0.1% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29531510.76 ± 0.2% | not timed | not timed | 20984354.09 ± 0.1% | 50.42 ± 0.1% | not timed | not timed | 29569226.53 ± 0.2% | | 1.00 | 1.41 | 585743.97 |
| opt/reverse-inner/holmes | 2593 | 9964.51 ± 0.4% | not timed | not timed | 9558.32 ± 0.3% | 23.75 ± 1.7% | not timed | not timed | 9993.92 ± 0.5% | | 1.00 | 1.04 | 419.51 |
| opt/reverse-inner/email | 47 | 36386.20 ± 2.1% | not timed | not timed | 45096.27 ± 0.4% | 32.49 ± 0.1% | not timed | not timed | 36941.52 ± 2.3% | | 0.98 | 0.81 | 1120.08 |
| opt/reverse-inner/factored-prefix | 3542 | 592.30 ± 0.4% | not timed | not timed | 596.89 ± 0.1% | 12.55 ± 0.2% | not timed | not timed | 591.90 ± 0.6% | | 1.00 | 0.99 | 47.20 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21016.99 ± 0.1% | not timed | not timed | 619.09 ± 0.5% | 74.75 ± 0.1% | not timed | not timed | 21175.04 ± 0.1% | | 0.99 | 33.95 | 281.15 |
| opt/reverse-inner/no-quadratic-forward | 0 | 730.33 ± 1.6% | not timed | not timed | 289.22 ± 0.2% | 24.66 ± 0.1% | not timed | not timed | 733.88 ± 2.1% | | 1.00 | 2.53 | 29.62 |
| opt/reverse-suffix/holmes | 4073 | 10325.22 ± 0.4% | not timed | not timed | 8493.29 ± 0.2% | 23.79 ± 0.9% | not timed | not timed | 10324.14 ± 0.2% | | 1.00 | 1.22 | 433.93 |
| opt/reverse-suffix/no-quadratic | 0 | 21081.38 ± 0.1% | not timed | not timed | 618.74 ± 0.1% | 74.91 ± 0.1% | not timed | not timed | 21159.86 ± 0.1% | | 1.00 | 34.07 | 281.44 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.16 ± 8.1% | not timed | not timed | 132.08 ± 0.2% | 13.40 ± 14.9% | not timed | not timed | 119.15 ± 1.4% | | 1.01 | 0.91 | 8.97 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.70 ± 1.6% | not timed | not timed | 134.07 ± 0.1% | 13.85 ± 14.0% | not timed | not timed | 120.53 ± 7.9% | | 1.00 | 0.90 | 8.72 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 3.3% | not timed | not timed | 0.55 ± 0.3% | 111.90 ± 7.1% | not timed | not timed | 0.28 ± 1.0% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.03 ± 0.5% | not timed | not timed | 293.40 ± 0.2% | 104.11 ± 0.9% | not timed | not timed | 323.50 ± 0.4% | | 0.98 | 1.08 | 3.05 |
| reported/i13-subset-regex/original-ascii | 4094 | 11268.57 ± 0.9% | not timed | not timed | 4543.01 ± 0.3% | 11.49 ± 0.2% | not timed | not timed | 11322.93 ± 0.8% | | 1.00 | 2.48 | 980.71 |
| reported/i13-subset-regex/original-unicode | 4094 | 11136.41 ± 1.5% | not timed | not timed | 252.74 ± 3.3% | 11.49 ± 0.1% | not timed | not timed | 11289.87 ± 0.7% | | 0.99 | 44.06 | 969.23 |
| reported/i13-subset-regex/big-ascii | 1955 | 10743.04 ± 1.1% | not timed | not timed | 67.99 ± 3.5% | 9.85 ± 0.3% | not timed | not timed | 10788.94 ± 1.1% | | 1.00 | 158.02 | 1091.14 |
| reported/i13-subset-regex/big-unicode | 1955 | 10643.24 ± 2.1% | not timed | not timed | 12.29 ± 54.9% | 9.85 ± 1.2% | not timed | not timed | 10791.35 ± 12.4% | | 0.99 | 866.10 | 1080.45 |
| reported/i13-subset-regex/huge-ascii | 55 | 10103.03 ± 3.4% | not timed | not timed | 11.00 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 10086.47 ± 3.2% | | 1.00 | 918.44 | 1151.69 |
| reported/i13-subset-regex/huge-unicode | 55 | 9921.15 ± 2.1% | not timed | not timed | 11.00 ± 0.3% | 8.75 ± 0.1% | not timed | not timed | 9874.76 ± 2.9% | | 1.00 | 902.14 | 1133.25 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.03 ± 0.2% | 8.77 ± 0.9% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 10.85 ± 0.3% | 8.79 ± 0.1% | not timed | not timed | 4.96 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 482.35 ± 0.2% | not timed | not timed | 104.34 ± 0.1% | 6.57 ± 0.2% | not timed | not timed | 484.37 ± 0.2% | | 1.00 | 4.62 | 73.37 |
| reported/i787-keywords/opt-ascii | 5674 | 485.69 ± 0.3% | not timed | not timed | 272.69 ± 0.2% | 10.33 ± 0.1% | not timed | not timed | 483.80 ± 0.3% | | 1.00 | 1.78 | 47.02 |
| slow/quadratic-regex-1x | 100 | 7.07 ± 0.1% | not timed | not timed | 4.99 ± 0.3% | 0.05 ± 0.3% | not timed | not timed | 7.15 ± 0.6% | | 0.99 | 1.42 | 144.83 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.2% | not timed | not timed | 2.76 ± 0.0% | 0.01 ± 0.3% | not timed | not timed | 3.42 ± 0.1% | | 1.00 | 1.24 | 268.40 |
| slow/quadratic-haystack-1x | 100 | 22.12 ± 6.6% | not timed | not timed | 10.01 ± 0.2% | 1.01 ± 13.7% | not timed | not timed | 21.95 ± 1.1% | | 1.01 | 2.21 | 21.89 |
| slow/quadratic-haystack-2x | 200 | 19.65 ± 0.8% | not timed | not timed | 5.54 ± 0.1% | 0.54 ± 0.9% | not timed | not timed | 19.60 ± 6.9% | | 1.00 | 3.55 | 36.12 |
| unicode/codepoints/any-one | 1112064 | 282.84 ± 0.5% | not timed | not timed | 176.27 ± 0.1% | 18.15 ± 15.7% | not timed | not timed | 282.29 ± 0.5% | | 1.00 | 1.60 | 15.59 |
| unicode/codepoints/any-all | 4382592 | 282.59 ± 0.9% | not timed | not timed | 247.04 ± 0.2% | 117.48 ± 0.2% | not timed | not timed | 282.64 ± 0.6% | | 1.00 | 1.14 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.69 ± 2.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.19 ± 0.9% | not timed | not timed | 616.53 ± 0.2% | 135.42 ± 0.6% | not timed | not timed | 602.34 ± 0.6% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.67 ± 0.2% | not timed | not timed | 38.86 ± 0.2% | 3.93 ± 1.4% | not timed | not timed | 31.84 ± 0.4% | | 0.99 | 0.82 | 8.06 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 3.26 ± 0.6% | 2.34 ± 0.7% | not timed | not timed | 1.43 ± 0.3% | | 1.01 | 0.44 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.7% | not timed | not timed | 3.60 ± 0.3% | 6.32 ± 9.0% | not timed | not timed | 1.28 ± 0.1% | | 1.01 | 0.36 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.20 ± 7.6% | not timed | not timed | 82.28 ± 2.1% | 11.59 ± 23.4% | not timed | not timed | 129.81 ± 0.5% | | 1.00 | 1.57 | 11.15 |
| unicode/word/boundary-long-english | 3466 | 608.63 ± 0.8% | not timed | not timed | 603.06 ± 0.2% | 32.76 ± 0.4% | not timed | not timed | 606.32 ± 1.3% | | 1.00 | 1.01 | 18.58 |
| unicode/word/around-holmes-english | 27 | 19683.67 ± 0.3% | not timed | not timed | 19454.54 ± 0.3% | 22.36 ± 1.5% | not timed | not timed | 19785.09 ± 0.5% | | 0.99 | 1.01 | 880.19 |
| wild/bibleref/long | 874 | 565.76 ± 0.2% | not timed | not timed | 584.36 ± 0.1% | 6.82 ± 0.2% | not timed | not timed | 568.45 ± 0.1% | | 1.00 | 0.97 | 82.95 |
| wild/bibleref/short | 30 | 25.42 ± 2.3% | not timed | not timed | 31.24 ± 0.4% | 14.01 ± 8.2% | not timed | not timed | 25.88 ± 6.9% | | 0.98 | 0.81 | 1.81 |
| wild/bibleref/line | 874 | 395.35 ± 0.2% | not timed | not timed | 218.62 ± 0.1% | 9.21 ± 0.4% | not timed | not timed | 396.15 ± 0.3% | | 1.00 | 1.81 | 42.93 |
| wild/caddy/caddy | 6 | 422.95 ± 2.6% | not timed | not timed | 244.51 ± 0.1% | 68.07 ± 13.3% | not timed | not timed | 423.09 ± 0.4% | | 1.00 | 1.73 | 6.21 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.41 ± 0.4% | not timed | not timed | 348.68 ± 0.1% | 13.56 ± 0.1% | not timed | not timed | 1066.59 ± 0.6% | | 1.00 | 3.07 | 78.93 |
| wild/ruff/noqa | 84 | 437.71 ± 0.2% | not timed | not timed | 478.25 ± 0.1% | 19.55 ± 1.9% | not timed | not timed | 437.35 ± 0.3% | | 1.00 | 0.92 | 22.39 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.27 ± 0.4% | not timed | not timed | 703.35 ± 0.3% | 136.42 ± 11.0% | not timed | not timed | 961.66 ± 0.3% | | 1.00 | 1.36 | 7.02 |
| wild/ruff/string-quote-prefix | 2972 | 1364.94 ± 0.7% | not timed | not timed | 441.99 ± 0.1% | 316.56 ± 25.1% | not timed | not timed | 1364.62 ± 0.6% | | 1.00 | 3.09 | 4.31 |
| wild/ruff/space-around-operator | 1224378 | 222.27 ± 1.7% | not timed | not timed | 186.43 ± 0.1% | 18.42 ± 1.8% | not timed | not timed | 223.00 ± 1.8% | | 1.00 | 1.19 | 12.07 |
| wild/ruff/shebang | 282 | 971.64 ± 0.4% | not timed | not timed | 328.17 ± 0.1% | 118.46 ± 12.4% | not timed | not timed | 974.10 ± 0.4% | | 1.00 | 2.96 | 8.20 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13822.06 ± 0.1% | not timed | not timed | 13609.55 ± 0.4% | 6819.31 ± 1.1% | not timed | not timed | 13848.15 ± 0.2% | | 1.00 | 1.02 | 2.03 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12836.69 ± 0.6% | not timed | not timed | 13440.23 ± 0.8% | 6319.66 ± 0.3% | not timed | not timed | 12878.34 ± 0.2% | | 1.00 | 0.96 | 2.03 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13229.83 ± 0.8% | not timed | not timed | 13687.52 ± 0.7% | 6502.09 ± 0.7% | not timed | not timed | 13250.38 ± 0.2% | | 1.00 | 0.97 | 2.03 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9585.35 ± 0.3% | not timed | not timed | 13646.42 ± 0.6% | 6593.71 ± 0.5% | not timed | not timed | 9598.99 ± 0.2% | | 1.00 | 0.70 | 1.45 |
| wild/url/search | 234965 | 121.93 ± 13.9% | not timed | not timed | 65.96 ± 0.5% | 2.25 ± 0.1% | not timed | not timed | 122.24 ± 14.2% | | 1.00 | 1.85 | 54.23 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 66.4% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 15.3% | not timed | not timed | 0.03 ± 1.9% | | 0.95 | 2.93 | 3.69 |
| dictionary/compile/english-15 | 1 | 0.34 ± 1.6% | not timed | not timed | 0.07 ± 0.4% | 0.11 ± 11.8% | not timed | not timed | 0.34 ± 22.9% | | 1.00 | 4.89 | 3.23 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 16.5% | not timed | not timed | 0.02 ± 0.8% | 35.34 ± 5.9% | not timed | not timed | 0.24 ± 4.3% | | 0.96 | 12.23 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.32 ± 6.1% | not timed | not timed | 11.52 ± 0.4% | 63.52 ± 22.3% | not timed | not timed | 46.73 ± 2.1% | | 0.99 | 4.02 | 0.73 |
| reported/i787-keywords/compile | 1 | 34.68 ± 2.9% | not timed | not timed | 2.13 ± 1.2% | 17.16 ± 26.0% | not timed | not timed | 34.80 ± 15.4% | | 1.00 | 16.27 | 2.02 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 340.45 ± 9.3% | not timed | not timed | 122.91 ± 0.6% | 572.42 ± 27.2% | not timed | not timed | 344.32 ± 8.5% | | 0.99 | 2.77 | 0.59 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.83 ± 2.0% | not timed | not timed | 4.08 ± 0.6% | 44.66 ± 5.0% | not timed | not timed | 47.64 ± 3.4% | | 0.98 | 11.48 | 1.05 |
| unicode/compile/one-letter | 53 | 6.63 ± 4.6% | not timed | not timed | 4.54 ± 0.6% | 67.72 ± 11.6% | not timed | not timed | 6.71 ± 13.3% | | 0.99 | 1.46 | 0.0980 |
| unicode/compile/fifty-letters | 1 | 0.95 ± 17.3% | not timed | not timed | 0.10 ± 0.8% | 66.14 ± 11.3% | not timed | not timed | 1.07 ± 3.6% | | 0.89 | 9.47 | 0.0144 |
| unicode/compile/fifty-letters-ascii | 1 | 210.01 ± 6.8% | not timed | not timed | 52.56 ± 0.1% | 193.38 ± 36.6% | not timed | not timed | 214.55 ± 2.5% | | 0.98 | 4.00 | 1.09 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 362.00 ± 15.9% | not timed | not timed | 47.07 ± 0.7% | 684.66 ± 20.5% | not timed | not timed | 366.99 ± 2.7% | | 0.99 | 7.69 | 0.53 |
| unicode/compile/match-every-line-ascii | 4 | 563.21 ± 13.9% | not timed | not timed | 144.10 ± 0.1% | 669.07 ± 21.4% | not timed | not timed | 582.71 ± 13.6% | | 0.97 | 3.91 | 0.84 |
| unicode/compile/negated-class-matches-codepoint | 1 | 301.50 ± 5.9% | not timed | not timed | 51.32 ± 0.5% | 1236.87 ± 24.1% | not timed | not timed | 307.95 ± 2.6% | | 0.98 | 5.88 | 0.24 |
| wild/bibleref/compile | 3 | 5.73 ± 5.0% | not timed | not timed | 1.94 ± 1.1% | 31.39 ± 15.0% | not timed | not timed | 5.89 ± 19.8% | | 0.97 | 2.96 | 0.18 |
| wild/url/compile | 1 | 0.55 ± 15.2% | not timed | not timed | 0.15 ± 0.8% | 0.47 ± 8.6% | not timed | not timed | 0.63 ± 19.2% | | 0.87 | 3.77 | 1.16 |

