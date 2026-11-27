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
| literal: a word | 217 | 19305.73 ± 1.1% | 10810.21 ± 0.4% | 27.60 ± 0.4% | 17840.99 ± 0.9% | 9061.79 ± 7.9% | 17.33 ± 0.4% | 86.02 ± 0.3% | 19163.74 ± 1.5% | 1.79 | 1.01 | 1.08 | 2.13 |
| literal: a word that is not there | 0 | 21335.95 ± 1.4% | 9825.24 ± 0.4% | 27.72 ± 0.3% | 19360.72 ± 3.5% | 28580.07 ± 1.5% | 17.09 ± 0.3% | 80.44 ± 0.2% | 21294.77 ± 2.4% | 2.17 | 1.00 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6420.55 ± 0.2% | 1789.41 ± 0.3% | 14.25 ± 0.1% | 3940.64 ± 0.3% | 21.80 ± 0.2% | 5.37 ± 0.1% | 6.93 ± 0.3% | 6425.41 ± 1.0% | 3.59 | 1.00 | 1.63 | 294.51 |
| literal: a word in any case | 217 | 15051.88 ± 0.8% | 1912.68 ± 0.6% | 21.26 ± 2.2% | 3962.00 ± 0.4% | 38.08 ± 1.3% | refused | differs | 15042.61 ± 1.1% | 7.87 | 1.00 | 3.80 | 395.31 |
| literal: an href attribute | 33 | 16766.83 ± 1.8% | 606.09 ± 0.4% | 26.85 ± 0.2% | 17050.01 ± 0.4% | 2244.38 ± 0.7% | 13.04 ± 0.4% | 74.82 ± 1.0% | 16882.88 ± 1.8% | 27.66 | 0.99 | 0.98 | 7.47 |
| literal: a word, second text | 123 | 20173.20 ± 3.0% | 4590.49 ± 0.4% | 27.43 ± 0.2% | 18208.15 ± 2.2% | 7733.29 ± 4.6% | 20.18 ± 1.1% | 70.26 ± 0.2% | 19982.65 ± 2.0% | 4.39 | 1.01 | 1.11 | 2.61 |
| class: two capitalized words | 1331 | 1179.24 ± 0.6% | 597.82 ± 0.3% | 25.60 ± 0.2% | 585.97 ± 0.1% | 40.67 ± 8.9% | 14.66 ± 0.3% | 67.67 ± 0.5% | 1178.96 ± 0.2% | 1.97 | 1.00 | 2.01 | 29.00 |
| class: a word that ends in ing | 3399 | 574.38 ± 0.3% | 574.05 ± 0.4% | 17.65 ± 2.2% | 547.95 ± 0.1% | 29.60 ± 6.7% | 7.81 ± 0.3% | 18.39 ± 0.4% | 575.30 ± 0.6% | 1.00 | 1.00 | 1.05 | 19.40 |
| class: a word in capitals | 2332 | 1533.88 ± 0.2% | 608.03 ± 0.1% | 27.08 ± 0.2% | 572.36 ± 0.3% | 43.42 ± 6.3% | 17.11 ± 0.1% | 83.11 ± 0.2% | 1533.69 ± 0.1% | 2.52 | 1.00 | 2.68 | 35.33 |
| class: a number | 8288 | 2661.12 ± 0.8% | 840.60 ± 0.1% | 27.23 ± 0.3% | 1716.42 ± 0.2% | 42.84 ± 7.0% | 0.55 ± 0.2% | 57.18 ± 0.2% | 2670.90 ± 0.7% | 3.17 | 1.00 | 1.55 | 62.12 |
| class: two capitalized words, second text | 5359 | 521.61 ± 0.3% | 528.03 ± 0.2% | 22.89 ± 0.1% | 484.65 ± 0.2% | 35.06 ± 12.8% | 17.02 ± 0.2% | 63.12 ± 0.2% | 521.50 ± 0.2% | 0.99 | 1.00 | 1.08 | 14.88 |
| other: a word between two words | 6104 | 814.72 ± 0.1% | 602.75 ± 0.3% | 23.15 ± 0.1% | 738.41 ± 0.3% | 108.69 ± 10.7% | 11.09 ± 0.3% | 68.98 ± 0.5% | 813.09 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.50 |
| other: a number before a unit, second text | 1481 | 6229.95 ± 0.3% | 1144.00 ± 0.3% | 25.53 ± 0.4% | 5634.58 ± 0.3% | 40.82 ± 15.7% | 18.02 ± 0.2% | 65.58 ± 0.3% | 6227.35 ± 1.5% | 5.45 | 1.00 | 1.11 | 152.62 |
| other: a heading's start tag | 110 | 14099.90 ± 0.9% | 737.85 ± 0.6% | 26.87 ± 0.1% | 1707.21 ± 0.3% | 1577.95 ± 4.4% | 16.19 ± 0.5% | 87.66 ± 0.5% | 14157.47 ± 1.4% | 19.11 | 1.00 | 8.26 | 8.94 |
| other: a whole word | 217 | 16309.60 ± 0.7% | 601.13 ± 0.7% | 28.13 ± 0.2% | 14676.02 ± 0.6% | 49.36 ± 0.3% | 13.17 ± 0.1% | 55.00 ± 1.0% | 16425.42 ± 1.2% | 27.13 | 0.99 | 1.11 | 330.45 |
| other: a line's first word, second text | 3716 | 2099.02 ± 0.4% | 591.56 ± 0.2% | 29.96 ± 0.5% | 1727.18 ± 0.4% | 62.21 ± 7.0% | refused | refused | 2109.50 ± 0.9% | 3.55 | 1.00 | 1.22 | 33.74 |
| other: fourteen octets before an x | 87 | 23935.16 ± 1.0% | 241.89 ± 0.6% | 6.45 ± 0.0% | 3967.41 ± 1.4% | 10.65 ± 0.2% | differs | 17.93 ± 0.1% | 23705.88 ± 8.1% | 98.95 | 1.01 | 6.03 | 2246.92 |
| other: a Greek word | 21815 | 528.44 ± 0.9% | 423.19 ± 0.2% | 30.13 ± 0.2% | 289.92 ± 0.2% | 48.74 ± 8.9% | differs | refused | 529.63 ± 1.2% | 1.25 | 1.00 | 1.82 | 10.84 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.62 ± 0.1% | 29.63 ± 0.2% | 0.86 ± 0.2% | 19.71 ± 0.7% | 2.75 ± 0.8% | differs | 4.06 ± 0.1% | 29.61 ± 0.2% | 1.00 | 1.00 | 1.50 | 10.79 |
| a UUID | 32895 | 24.75 ± 0.1% | 24.82 ± 0.1% | 0.64 ± 0.1% | 15.28 ± 0.3% | 3.09 ± 0.7% | 0.73 ± 0.2% | 3.62 ± 0.6% | 24.83 ± 0.2% | 1.00 | 1.00 | 1.62 | 8.02 |
| an IPv4 address | 33176 | 38.82 ± 0.2% | 38.71 ± 0.2% | 2.07 ± 0.3% | 29.29 ± 0.5% | 6.68 ± 0.1% | differs | 4.22 ± 0.1% | 38.86 ± 0.2% | 1.00 | 1.00 | 1.33 | 5.81 |
| a date and time | 32954 | 34.05 ± 0.2% | 34.28 ± 0.1% | 1.44 ± 0.2% | 21.55 ± 0.1% | 7.03 ± 0.2% | 1.25 ± 0.1% | 7.18 ± 0.2% | 34.23 ± 0.3% | 0.99 | 0.99 | 1.58 | 4.85 |
| a field path | 32606 | 32.80 ± 0.2% | 32.74 ± 0.2% | 1.02 ± 0.2% | 23.24 ± 0.6% | 3.51 ± 0.7% | differs | 2.97 ± 0.1% | 32.84 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.22 ± 0.4% | 11.21 ± 0.5% | 11.25 ± 0.5% | 11.44 ± 0.2% | 4.91 ± 1.6% | 0.94 ± 0.5% | none | 11.14 ± 0.2% | 1.00 | 1.01 | 0.98 | 2.28 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.45 ± 1.8% | 222.14 ± 1.4% | 268.50 ± 0.4% | 87.22 ± 0.3% | 219.45 ± 0.7% | 484.97 ± 3.8% | 3745.82 ± 0.3% | 221.97 ± 0.2% | 0.99 | 0.99 | 2.53 | 1.00 |
| a UUID | 62 | 146.47 ± 1.1% | 146.57 ± 2.1% | 165.13 ± 2.2% | 45.85 ± 0.5% | 97.85 ± 0.8% | 191.64 ± 3.0% | 4373.63 ± 0.4% | 146.37 ± 1.7% | 1.00 | 1.00 | 3.19 | 1.50 |
| an IPv4 address | 29 | 403.87 ± 0.2% | 404.20 ± 0.1% | 577.77 ± 0.4% | 78.10 ± 0.5% | 130.41 ± 1.2% | 306.37 ± 0.5% | 7560.41 ± 0.5% | 403.81 ± 0.4% | 1.00 | 1.00 | 5.17 | 3.10 |
| a date and time | 56 | 290.48 ± 0.3% | 290.74 ± 0.2% | 371.24 ± 0.2% | 73.72 ± 0.6% | 135.61 ± 2.1% | 326.57 ± 2.3% | 4963.64 ± 0.3% | 290.44 ± 0.5% | 1.00 | 1.00 | 3.94 | 2.14 |
| a field path | 39 | 212.02 ± 2.3% | 214.09 ± 2.3% | 259.51 ± 2.9% | 82.65 ± 2.1% | 203.93 ± 1.0% | 531.43 ± 2.0% | 4739.62 ± 0.1% | 215.96 ± 1.3% | 0.99 | 0.98 | 2.57 | 1.04 |
| literal: a word | 7 | 573.91 ± 0.4% | 613.85 ± 0.4% | 1121.71 ± 0.1% | 535.67 ± 0.3% | 624.28 ± 1.9% | 959.23 ± 0.3% | 30664.18 ± 0.3% | 574.07 ± 0.2% | 0.93 | 1.00 | 1.07 | 0.92 |
| literal: a word that is not there | 8 | 557.01 ± 0.2% | 600.62 ± 0.3% | 1082.79 ± 0.6% | 482.64 ± 0.7% | 602.96 ± 3.0% | 907.54 ± 0.5% | 29475.31 ± 0.3% | 557.51 ± 0.2% | 0.93 | 1.00 | 1.15 | 0.92 |
| literal: one of four words | 26 | 232.24 ± 0.3% | 373.78 ± 0.4% | 522.14 ± 0.4% | 50.69 ± 0.4% | 240.16 ± 2.1% | 378.81 ± 0.4% | 15808.16 ± 0.2% | 232.45 ± 0.2% | 0.62 | 1.00 | 4.58 | 0.97 |
| literal: a word in any case | 11 | 419.30 ± 0.3% | 447.31 ± 0.4% | 671.61 ± 0.2% | 15.82 ± 0.9% | 647.57 ± 2.8% | refused | 23726.38 ± 0.3% | 419.89 ± 0.3% | 0.94 | 1.00 | 26.51 | 0.65 |
| literal: an href attribute | 12 | 322.91 ± 0.7% | 334.40 ± 0.4% | 445.94 ± 0.3% | 45.27 ± 0.3% | 493.20 ± 1.8% | 767.93 ± 0.6% | 22280.11 ± 0.2% | 323.00 ± 0.4% | 0.97 | 1.00 | 7.13 | 0.65 |
| literal: a word, second text | 10 | 515.44 ± 0.6% | 562.44 ± 0.3% | 965.75 ± 0.2% | 425.90 ± 0.3% | 532.31 ± 3.7% | 795.99 ± 0.6% | 27608.08 ± 1.2% | 515.48 ± 0.2% | 0.92 | 1.00 | 1.21 | 0.97 |
| class: two capitalized words | 23 | 412.68 ± 0.6% | 440.55 ± 0.4% | 653.41 ± 0.5% | 100.66 ± 2.9% | 503.46 ± 1.3% | 739.84 ± 1.7% | 6328.29 ± 0.2% | 413.01 ± 0.4% | 0.94 | 1.00 | 4.10 | 0.82 |
| class: a word that ends in ing | 9 | 518.82 ± 0.2% | 581.78 ± 0.4% | 1049.81 ± 0.4% | 132.71 ± 0.4% | 752.76 ± 0.7% | 1124.67 ± 0.4% | 15791.48 ± 0.3% | 518.77 ± 0.2% | 0.89 | 1.00 | 3.91 | 0.69 |
| class: a word in capitals | 16 | 464.49 ± 0.4% | 499.95 ± 0.4% | 813.88 ± 0.1% | 137.41 ± 1.7% | 753.12 ± 1.5% | 1027.12 ± 0.6% | 8336.66 ± 0.1% | 464.84 ± 0.3% | 0.93 | 1.00 | 3.38 | 0.62 |
| class: a number | 6 | 583.28 ± 0.5% | 637.94 ± 0.5% | 1229.53 ± 0.2% | 41.73 ± 1.5% | 1413.38 ± 1.0% | 1933.28 ± 3.3% | 22978.19 ± 0.2% | 583.24 ± 0.4% | 0.91 | 1.00 | 13.98 | 0.41 |
| class: two capitalized words, second text | 23 | 412.69 ± 0.4% | 440.58 ± 0.2% | 653.40 ± 0.6% | 102.65 ± 2.6% | 503.38 ± 2.6% | 743.07 ± 0.4% | 6333.97 ± 0.2% | 412.91 ± 0.3% | 0.94 | 1.00 | 4.02 | 0.82 |
| other: a word between two words | 13 | 504.48 ± 0.3% | 522.87 ± 0.5% | 856.63 ± 0.1% | 135.74 ± 0.2% | 498.98 ± 1.0% | 811.99 ± 0.6% | 14661.97 ± 0.2% | 503.78 ± 0.7% | 0.96 | 1.00 | 3.72 | 1.01 |
| other: a number before a unit, second text | 15 | 368.31 ± 0.5% | 404.30 ± 0.6% | 581.17 ± 1.0% | 39.52 ± 0.5% | 632.81 ± 1.6% | 889.01 ± 0.2% | 15329.28 ± 0.4% | 368.16 ± 0.7% | 0.91 | 1.00 | 9.32 | 0.58 |
| other: a heading's start tag | 13 | 333.37 ± 0.4% | 339.55 ± 0.2% | 454.34 ± 0.3% | 44.04 ± 0.1% | 628.31 ± 1.2% | 859.12 ± 0.4% | 17991.46 ± 0.2% | 333.29 ± 0.4% | 0.98 | 1.00 | 7.57 | 0.53 |
| other: a whole word | 11 | 531.17 ± 1.2% | 569.55 ± 0.7% | 986.88 ± 0.6% | 121.71 ± 0.3% | 561.93 ± 3.0% | 828.02 ± 0.4% | 27249.88 ± 0.2% | 534.05 ± 0.6% | 0.93 | 0.99 | 4.36 | 0.95 |
| other: a line's first word, second text | 17 | 483.22 ± 0.6% | 515.45 ± 0.3% | 850.36 ± 0.2% | 129.67 ± 0.1% | 709.27 ± 1.3% | refused | refused | 484.53 ± 0.6% | 0.94 | 1.00 | 3.73 | 0.68 |
| other: fourteen octets before an x | 16 | 106.25 ± 0.5% | 151.84 ± 0.8% | 177.58 ± 0.3% | 15.20 ± 0.3% | 455.16 ± 1.6% | 413.39 ± 0.6% | 12985.93 ± 0.3% | 106.44 ± 0.7% | 0.70 | 1.00 | 6.99 | 0.23 |
| other: a Greek word | 8 | 405.96 ± 0.3% | 552.08 ± 0.6% | 952.91 ± 1.4% | 59.33 ± 0.9% | 1394.56 ± 1.9% | 1794.48 ± 0.5% | refused | 405.91 ± 0.2% | 0.74 | 1.00 | 6.84 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15611.00 ± 1.4% | not timed | not timed | 16221.22 ± 0.9% | 2029.36 ± 14.5% | not timed | not timed | 15546.85 ± 0.9% | | 1.00 | 0.96 | 7.69 |
| 01-literal/sherlock-casei-en | 522 | 10909.92 ± 4.2% | not timed | not timed | 3593.97 ± 0.3% | 32.43 ± 0.1% | not timed | not timed | 10930.37 ± 1.0% | | 1.00 | 3.04 | 336.38 |
| 01-literal/sherlock-ru | 724 | 17099.54 ± 0.9% | not timed | not timed | 17299.74 ± 0.3% | 1471.71 ± 8.3% | not timed | not timed | 17142.87 ± 0.3% | | 1.00 | 0.99 | 11.62 |
| 01-literal/sherlock-casei-ru | 746 | 6123.70 ± 0.4% | not timed | not timed | 3328.56 ± 0.2% | 31.63 ± 0.3% | not timed | not timed | 6129.84 ± 0.3% | | 1.00 | 1.84 | 193.61 |
| 01-literal/sherlock-zh | 30 | 19663.06 ± 0.6% | not timed | not timed | 18458.24 ± 0.8% | 2630.28 ± 21.5% | not timed | not timed | 19522.06 ± 1.6% | | 1.01 | 1.07 | 7.48 |
| 02-literal-alternate/sherlock-en | 714 | 6119.92 ± 0.2% | not timed | not timed | 3936.83 ± 0.3% | 16.61 ± 0.3% | not timed | not timed | 6125.10 ± 0.1% | | 1.00 | 1.55 | 368.47 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1962.98 ± 1.4% | not timed | not timed | 697.14 ± 0.2% | 11.04 ± 0.1% | not timed | not timed | 1968.73 ± 0.8% | | 1.00 | 2.82 | 177.88 |
| 02-literal-alternate/sherlock-ru | 899 | 5491.02 ± 0.5% | not timed | not timed | 3252.31 ± 0.2% | 22.67 ± 0.2% | not timed | not timed | 5492.75 ± 0.1% | | 1.00 | 1.69 | 242.26 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2047.63 ± 0.5% | not timed | not timed | 1222.73 ± 0.9% | 9.13 ± 0.3% | not timed | not timed | 2046.18 ± 0.6% | | 1.00 | 1.67 | 224.18 |
| 02-literal-alternate/sherlock-zh | 207 | 7337.01 ± 0.3% | not timed | not timed | 4165.27 ± 0.2% | 31.53 ± 0.1% | not timed | not timed | 7337.75 ± 0.2% | | 1.00 | 1.76 | 232.71 |
| 03-date/ascii | 111817 | 133.90 ± 0.7% | not timed | not timed | 95.86 ± 0.1% | 0.20 ± 3.0% | not timed | not timed | 134.66 ± 0.7% | | 0.99 | 1.40 | 670.42 |
| 04-ruff-noqa/real | 84 | 436.43 ± 0.3% | not timed | not timed | 467.51 ± 0.2% | 19.56 ± 1.5% | not timed | not timed | 436.25 ± 0.4% | | 1.00 | 0.93 | 22.31 |
| 04-ruff-noqa/tweaked | 44 | 844.92 ± 0.1% | not timed | not timed | 467.48 ± 0.1% | 365.26 ± 0.3% | not timed | not timed | 846.96 ± 0.2% | | 1.00 | 1.81 | 2.31 |
| 05-lexer-veryl/single | 124800 | 5.44 ± 0.4% | not timed | not timed | 5.24 ± 0.2% | 0.20 ± 5.6% | not timed | not timed | 5.59 ± 0.4% | | 0.97 | 1.04 | 26.76 |
| 06-cloud-flare-redos/original | 107 | 440.55 ± 0.2% | not timed | not timed | 216.77 ± 0.2% | 24.88 ± 0.3% | not timed | not timed | 441.28 ± 0.1% | | 1.00 | 2.03 | 17.71 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.42 ± 0.4% | not timed | not timed | 228.80 ± 0.2% | 26.57 ± 0.3% | not timed | not timed | 438.13 ± 0.3% | | 1.00 | 1.92 | 16.50 |
| 06-cloud-flare-redos/simplified-long | 10000 | 629.00 ± 0.2% | not timed | not timed | 255.36 ± 0.2% | 28.77 ± 0.1% | not timed | not timed | 628.70 ± 0.3% | | 1.00 | 2.46 | 21.86 |
| 07-unicode-character-data/parse-line | 558784 | 234.36 ± 2.1% | not timed | not timed | 179.36 ± 0.1% | 43.04 ± 5.8% | not timed | not timed | 235.83 ± 0.6% | | 0.99 | 1.31 | 5.45 |
| 08-words/all-english | 56691 | 129.37 ± 0.5% | not timed | not timed | 83.19 ± 0.3% | 13.05 ± 5.0% | not timed | not timed | 129.29 ± 0.8% | | 1.00 | 1.56 | 9.91 |
| 08-words/long-english | 839 | 617.67 ± 0.6% | not timed | not timed | 596.17 ± 0.0% | 32.58 ± 0.4% | not timed | not timed | 617.37 ± 0.8% | | 1.00 | 1.04 | 18.96 |
| 09-aws-keys/full | 0 | 441.23 ± 0.4% | not timed | not timed | 479.84 ± 0.1% | 63.92 ± 0.1% | not timed | not timed | 440.57 ± 0.2% | | 1.00 | 0.92 | 6.90 |
| 09-aws-keys/quick | 0 | 875.56 ± 0.1% | not timed | not timed | 1001.39 ± 0.4% | 420.77 ± 0.8% | not timed | not timed | 876.13 ± 0.4% | | 1.00 | 0.87 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 581.19 ± 3.2% | not timed | not timed | 514.96 ± 0.3% | 19.58 ± 0.8% | not timed | not timed | 578.14 ± 1.3% | | 1.01 | 1.13 | 29.69 |
| 10-bounded-repeat/letters-ru | 3475 | 505.51 ± 1.5% | not timed | not timed | 478.23 ± 0.2% | 21.95 ± 8.9% | not timed | not timed | 506.90 ± 1.0% | | 1.00 | 1.06 | 23.03 |
| 10-bounded-repeat/context | 53 | 84.90 ± 1.8% | not timed | not timed | 65.99 ± 0.6% | 19.77 ± 0.2% | not timed | not timed | 85.25 ± 1.8% | | 1.00 | 1.29 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 638.49 ± 8.1% | not timed | not timed | 618.17 ± 0.1% | 36.58 ± 0.2% | not timed | not timed | 637.72 ± 8.6% | | 1.00 | 1.03 | 17.45 |
| 11-unstructured-to-json/extract | 600 | 57.70 ± 1.3% | not timed | not timed | 76.71 ± 0.2% | 49.10 ± 0.4% | not timed | not timed | 57.50 ± 0.2% | | 1.00 | 0.75 | 1.17 |
| 12-dictionary/single | 1 | 560.24 ± 2.0% | not timed | not timed | 561.53 ± 0.2% | 0.41 ± 0.2% | not timed | not timed | 560.83 ± 1.5% | | 1.00 | 1.00 | 1368.45 |
| 14-quadratic/1x | 100 | 22.02 ± 1.3% | not timed | not timed | 9.96 ± 0.1% | 0.98 ± 3.2% | not timed | not timed | 22.12 ± 1.5% | | 1.00 | 2.21 | 22.57 |
| 14-quadratic/2x | 200 | 19.75 ± 0.8% | not timed | not timed | 5.53 ± 0.3% | 0.53 ± 0.6% | not timed | not timed | 19.83 ± 0.6% | | 1.00 | 3.57 | 37.05 |
| 14-quadratic/10x | 1000 | 12.35 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 12.35 ± 1.4% | | 1.00 | 10.19 | 107.25 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.20 ± 1.6% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 3.9% | not timed | not timed | 1.22 ± 0.8% | | 0.99 | 3.51 | 2.17 |
| 04-ruff-noqa/compile-real | 1 | 102.63 ± 1.2% | not timed | not timed | 13.77 ± 0.5% | 138.38 ± 3.5% | not timed | not timed | 103.33 ± 0.6% | | 0.99 | 7.45 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 13.97 ± 0.7% | not timed | not timed | 2.53 ± 1.4% | 6.45 ± 2.4% | not timed | not timed | 13.96 ± 0.4% | | 1.00 | 5.52 | 2.17 |
| 07-unicode-character-data/compile | 1 | 106.96 ± 0.3% | not timed | not timed | 25.88 ± 0.3% | 35.89 ± 1.8% | not timed | not timed | 107.27 ± 1.3% | | 1.00 | 4.13 | 2.98 |
| 09-aws-keys/compile-full | 1 | 52.25 ± 0.6% | not timed | not timed | 8.23 ± 0.7% | 23.28 ± 1.2% | not timed | not timed | 52.48 ± 0.4% | | 1.00 | 6.35 | 2.24 |
| 09-aws-keys/compile-quick | 1 | 180.68 ± 1.1% | not timed | not timed | 47.66 ± 0.2% | 131.66 ± 3.5% | not timed | not timed | 182.09 ± 0.6% | | 0.99 | 3.79 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 70.49 ± 2.1% | not timed | not timed | 11.12 ± 0.2% | 15.97 ± 0.9% | not timed | not timed | 70.71 ± 2.1% | | 1.00 | 6.34 | 4.41 |
| 10-bounded-repeat/compile-capitals | 1 | 83.61 ± 0.3% | not timed | not timed | 8.03 ± 0.3% | 23.64 ± 1.8% | not timed | not timed | 83.82 ± 0.3% | | 1.00 | 10.41 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 168.23 ± 0.6% | not timed | not timed | 40.89 ± 0.7% | 67.45 ± 2.3% | not timed | not timed | 168.85 ± 0.3% | | 1.00 | 4.11 | 2.49 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.4% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 3.8% | not timed | not timed | 0.34 ± 1.3% | | 1.00 | 5.03 | 3.61 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.53 ± 1.8% | not timed | not timed | 6.57 ± 0.0% | 0.56 ± 19.1% | not timed | not timed | 7.53 ± 5.6% | | 1.00 | 1.15 | 13.38 |
| dictionary/search/english-10 | 690 | 212.48 ± 0.7% | not timed | not timed | 166.62 ± 0.4% | 0.00 ± 0.3% | not timed | not timed | 212.26 ± 3.3% | | 1.00 | 1.28 | 78018.13 |
| dictionary/search/english-15 | 15 | 559.45 ± 1.7% | not timed | not timed | 560.88 ± 0.1% | 0.36 ± 0.3% | not timed | not timed | 561.70 ± 1.4% | | 1.00 | 1.00 | 1533.34 |
| folly/awyer-inn-busted | 1 | 21496.92 ± 0.1% | not timed | not timed | 143.56 ± 0.1% | 42.85 ± 0.2% | not timed | not timed | 21549.91 ± 0.2% | | 1.00 | 149.75 | 501.74 |
| folly/literal-never-match-rare | 0 | 21142.61 ± 0.3% | not timed | not timed | 19932.48 ± 0.1% | 40935.08 ± 0.2% | not timed | not timed | 21148.32 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12533.62 ± 1.7% | not timed | not timed | 19852.62 ± 0.6% | 2196.44 ± 0.7% | not timed | not timed | 12523.99 ± 1.6% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3252.62 ± 0.5% | not timed | not timed | 4410.36 ± 0.1% | 2892.67 ± 11.5% | not timed | not timed | 3260.24 ± 0.6% | | 1.00 | 0.74 | 1.12 |
| grep/every-line | 239963 | 1300.15 ± 0.5% | not timed | not timed | 957.90 ± 0.5% | 367.92 ± 16.3% | not timed | not timed | 1308.16 ± 0.5% | | 0.99 | 1.36 | 3.53 |
| grep/long-words-ascii | 5073 | 458.77 ± 0.3% | not timed | not timed | 468.42 ± 0.1% | 46.03 ± 6.1% | not timed | not timed | 459.76 ± 0.3% | | 1.00 | 0.98 | 9.97 |
| imported/leipzig/twain | 811 | 20723.85 ± 1.4% | not timed | not timed | 19625.46 ± 0.5% | 12000.46 ± 9.5% | not timed | not timed | 20774.46 ± 0.4% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9086.29 ± 1.3% | not timed | not timed | 4249.64 ± 0.2% | 37.70 ± 0.1% | not timed | not timed | 9147.48 ± 1.2% | | 0.99 | 2.14 | 241.04 |
| imported/leipzig/shing | 1540 | 15321.92 ± 2.3% | not timed | not timed | 13521.31 ± 0.5% | 34.01 ± 0.1% | not timed | not timed | 15600.73 ± 1.9% | | 0.98 | 1.13 | 450.50 |
| imported/leipzig/huck-saw | 262 | 8261.80 ± 3.0% | not timed | not timed | 5603.55 ± 0.1% | 31.71 ± 0.1% | not timed | not timed | 8381.14 ± 3.1% | | 0.99 | 1.47 | 260.52 |
| imported/leipzig/word-ending-nn | 262 | 603.13 ± 1.0% | not timed | not timed | 615.91 ± 0.1% | 24.81 ± 0.2% | not timed | not timed | 604.45 ± 1.0% | | 1.00 | 0.98 | 24.31 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11243.76 ± 0.7% | not timed | not timed | 4525.73 ± 0.9% | 11.51 ± 1.1% | not timed | not timed | 11302.34 ± 2.1% | | 0.99 | 2.48 | 976.52 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7813.67 ± 1.6% | not timed | not timed | 5490.08 ± 0.1% | 16.92 ± 0.1% | not timed | not timed | 7936.59 ± 2.3% | | 0.98 | 1.42 | 461.67 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4166.17 ± 1.2% | not timed | not timed | 426.32 ± 0.6% | 11.09 ± 0.0% | not timed | not timed | 4188.12 ± 1.1% | | 0.99 | 9.77 | 375.81 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7300.86 ± 2.3% | not timed | not timed | 615.43 ± 0.1% | 11.02 ± 0.1% | not timed | not timed | 7363.63 ± 3.3% | | 0.99 | 11.86 | 662.77 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7187.46 ± 2.7% | not timed | not timed | 615.15 ± 0.1% | 9.65 ± 0.0% | not timed | not timed | 7162.89 ± 2.5% | | 1.00 | 11.68 | 744.99 |
| imported/leipzig/tom-river | 2 | 6479.76 ± 1.6% | not timed | not timed | 5146.11 ± 0.4% | 30.99 ± 0.1% | not timed | not timed | 6586.00 ± 2.4% | | 0.98 | 1.26 | 209.08 |
| imported/leipzig/ing | 78424 | 602.22 ± 0.9% | not timed | not timed | 571.42 ± 0.1% | 28.27 ± 2.7% | not timed | not timed | 602.24 ± 0.7% | | 1.00 | 1.05 | 21.30 |
| imported/leipzig/ing-whitespace | 55248 | 1929.05 ± 1.0% | not timed | not timed | 2054.23 ± 0.5% | 20.57 ± 2.9% | not timed | not timed | 1932.67 ± 1.1% | | 1.00 | 0.94 | 93.76 |
| imported/leipzig/awyer-inn | 209 | 6397.86 ± 0.6% | not timed | not timed | 4283.25 ± 0.2% | 22.57 ± 0.1% | not timed | not timed | 6450.41 ± 1.2% | | 0.99 | 1.49 | 283.50 |
| imported/leipzig/quotes-bounded | 8886 | 2490.70 ± 1.0% | not timed | not timed | 3018.61 ± 0.6% | 38.16 ± 0.2% | not timed | not timed | 2491.09 ± 0.9% | | 1.00 | 0.83 | 65.28 |
| imported/leipzig/non-ascii-alternate | 2 | 12882.87 ± 1.8% | not timed | not timed | 5669.37 ± 0.1% | 50.57 ± 0.1% | not timed | not timed | 13004.45 ± 2.1% | | 0.99 | 2.27 | 254.78 |
| imported/leipzig/math-symbols | 69 | 1990.36 ± 0.6% | not timed | not timed | 618.12 ± 0.1% | 36.53 ± 0.1% | not timed | not timed | 1984.73 ± 0.6% | | 1.00 | 3.22 | 54.48 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.40 ± 1.2% | not timed | not timed | 614.94 ± 0.0% | 22.41 ± 0.1% | not timed | not timed | 629.00 ± 2.2% | | 1.01 | 1.03 | 28.22 |
| imported/lh3lh3-reb/uri | 17549 | 676.57 ± 0.4% | not timed | not timed | 1079.63 ± 0.3% | 27.83 ± 2.1% | not timed | not timed | 681.41 ± 0.2% | | 0.99 | 0.63 | 24.31 |
| imported/lh3lh3-reb/email | 15057 | 674.04 ± 0.1% | not timed | not timed | 1163.92 ± 0.4% | 30.98 ± 2.5% | not timed | not timed | 676.58 ± 0.1% | | 1.00 | 0.58 | 21.76 |
| imported/lh3lh3-reb/date | 668 | 892.10 ± 0.2% | not timed | not timed | 1037.27 ± 0.1% | 51.35 ± 3.9% | not timed | not timed | 893.76 ± 0.2% | | 1.00 | 0.86 | 17.37 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.08 ± 0.2% | not timed | not timed | 424.17 ± 0.1% | 15.75 ± 1.3% | not timed | not timed | 647.15 ± 0.1% | | 1.00 | 1.52 | 40.96 |
| imported/mariomka/email | 92 | 24218.01 ± 1.6% | not timed | not timed | 29583.28 ± 0.5% | 32.84 ± 0.2% | not timed | not timed | 24457.82 ± 1.4% | | 0.99 | 0.82 | 737.43 |
| imported/mariomka/uri | 5301 | 5544.03 ± 1.0% | not timed | not timed | 6099.17 ± 0.2% | 32.70 ± 0.5% | not timed | not timed | 5583.72 ± 1.1% | | 0.99 | 0.91 | 169.56 |
| imported/mariomka/ip | 5 | 2594.99 ± 2.8% | not timed | not timed | 2970.09 ± 0.1% | 21.02 ± 0.3% | not timed | not timed | 2599.47 ± 3.5% | | 1.00 | 0.87 | 123.45 |
| imported/rsc/no-exponential | 0 | 606.74 ± 0.3% | not timed | not timed | 320.83 ± 0.1% | 23.84 ± 0.3% | not timed | not timed | 608.20 ± 0.4% | | 1.00 | 1.89 | 25.45 |
| imported/rsc/literal | 1 | 1422.88 ± 7.6% | not timed | not timed | 1649.60 ± 9.5% | 212.76 ± 15.7% | not timed | not timed | 1520.23 ± 8.3% | | 0.94 | 0.86 | 6.69 |
| imported/rsc/not-literal | 2 | 777.77 ± 0.3% | not timed | not timed | 740.53 ± 0.1% | 45.95 ± 0.7% | not timed | not timed | 778.82 ± 8.3% | | 1.00 | 1.05 | 16.92 |
| imported/rsc/match-class | 1 | 1479.48 ± 3.1% | not timed | not timed | 1670.60 ± 0.3% | 58.38 ± 13.8% | not timed | not timed | 1477.45 ± 0.4% | | 1.00 | 0.89 | 25.34 |
| imported/rsc/match-class-in-range | 1 | 1472.07 ± 0.4% | not timed | not timed | 2319.78 ± 6.0% | 59.77 ± 0.2% | not timed | not timed | 1473.87 ± 0.3% | | 1.00 | 0.63 | 24.63 |
| imported/rsc/match-class-unicode | 1 | 539.41 ± 0.6% | not timed | not timed | 509.99 ± 0.1% | 72.43 ± 7.6% | not timed | not timed | 540.04 ± 2.4% | | 1.00 | 1.06 | 7.45 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1459.90 ± 0.2% | not timed | not timed | 944.73 ± 0.1% | 228.05 ± 0.4% | not timed | not timed | 1451.93 ± 0.1% | | 1.01 | 1.55 | 6.40 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21881.65 ± 0.2% | not timed | not timed | 14131.97 ± 0.0% | 3411.58 ± 0.9% | not timed | not timed | 21740.36 ± 0.2% | | 1.01 | 1.55 | 6.41 |
| imported/rsc/anchored-literal-short-match | 4 | 724.09 ± 6.0% | not timed | not timed | 489.18 ± 0.2% | 85.26 ± 6.5% | not timed | not timed | 722.52 ± 2.0% | | 1.00 | 1.48 | 8.49 |
| imported/rsc/anchored-literal-long-match | 4 | 10850.33 ± 1.7% | not timed | not timed | 7225.79 ± 0.6% | 1251.13 ± 10.3% | not timed | not timed | 10815.48 ± 1.4% | | 1.00 | 1.50 | 8.67 |
| imported/rsc/one-pass-short | 17 | 370.56 ± 1.2% | not timed | not timed | 216.32 ± 0.6% | 32.12 ± 11.5% | not timed | not timed | 370.63 ± 12.3% | | 1.00 | 1.71 | 11.54 |
| imported/rsc/one-pass-short-not | 17 | 270.01 ± 7.6% | not timed | not timed | 226.24 ± 0.1% | 31.29 ± 10.6% | not timed | not timed | 270.96 ± 2.1% | | 1.00 | 1.19 | 8.63 |
| imported/rsc/one-pass-long-prefix | 26 | 361.21 ± 7.6% | not timed | not timed | 285.77 ± 0.8% | 95.53 ± 14.6% | not timed | not timed | 362.34 ± 1.7% | | 1.00 | 1.26 | 3.78 |
| imported/rsc/one-pass-long-prefix-not | 26 | 358.12 ± 4.5% | not timed | not timed | 282.88 ± 0.2% | 68.42 ± 17.1% | not timed | not timed | 362.48 ± 1.7% | | 0.99 | 1.27 | 5.23 |
| imported/rsc/long-needle1 | 31 | 21930.00 ± 0.2% | not timed | not timed | 20154.73 ± 0.2% | 3.77 ± 0.1% | not timed | not timed | 21959.01 ± 0.2% | | 1.00 | 1.09 | 5812.23 |
| imported/rsc/long-needle2 | 31 | 22095.23 ± 0.1% | not timed | not timed | 216.03 ± 0.3% | 3.78 ± 0.0% | not timed | not timed | 22089.73 ± 0.2% | | 1.00 | 102.28 | 5851.17 |
| imported/rsc/easy0-32 | 26 | 1590.24 ± 2.8% | not timed | not timed | 1515.53 ± 0.4% | 148.78 ± 19.7% | not timed | not timed | 1570.99 ± 1.9% | | 1.01 | 1.05 | 10.69 |
| imported/rsc/easy0-1k | 26 | 13674.67 ± 0.9% | not timed | not timed | 12269.26 ± 0.4% | 2307.51 ± 16.3% | not timed | not timed | 13594.27 ± 2.7% | | 1.01 | 1.11 | 5.93 |
| imported/rsc/easy0-32k | 26 | 22805.39 ± 0.3% | not timed | not timed | 20321.49 ± 0.1% | 18724.93 ± 26.6% | not timed | not timed | 22819.46 ± 2.7% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21546.27 ± 2.2% | not timed | not timed | 19931.54 ± 2.3% | 37098.70 ± 3.5% | not timed | not timed | 21686.37 ± 2.7% | | 0.99 | 1.08 | 0.58 |
| imported/rsc/easy1-32 | 19 | 759.62 ± 5.2% | not timed | not timed | 625.86 ± 0.7% | 130.83 ± 15.4% | not timed | not timed | 768.49 ± 0.3% | | 0.99 | 1.21 | 5.81 |
| imported/rsc/easy1-1k | 19 | 15844.50 ± 2.4% | not timed | not timed | 12819.36 ± 0.3% | 2450.39 ± 13.5% | not timed | not timed | 15736.29 ± 0.3% | | 1.01 | 1.24 | 6.47 |
| imported/rsc/easy1-32k | 19 | 495823.56 ± 0.1% | not timed | not timed | 396382.25 ± 0.1% | 20544.75 ± 0.1% | not timed | not timed | 492564.23 ± 0.2% | | 1.01 | 1.25 | 24.13 |
| imported/rsc/easy1-1mb | 19 | 15929181.97 ± 0.3% | not timed | not timed | 12944702.23 ± 0.2% | 35987.31 ± 5.0% | not timed | not timed | 15817374.91 ± 0.2% | | 1.01 | 1.23 | 442.63 |
| imported/rsc/medium-32 | 27 | 738.69 ± 1.9% | not timed | not timed | 630.00 ± 0.3% | 69.84 ± 12.6% | not timed | not timed | 739.71 ± 0.3% | | 1.00 | 1.17 | 10.58 |
| imported/rsc/medium-1k | 27 | 13161.38 ± 0.2% | not timed | not timed | 11040.15 ± 0.1% | 72.15 ± 0.1% | not timed | not timed | 13132.57 ± 0.3% | | 1.00 | 1.19 | 182.42 |
| imported/rsc/medium-32k | 27 | 410737.54 ± 0.2% | not timed | not timed | 347126.00 ± 0.1% | 48.63 ± 0.2% | not timed | not timed | 410112.24 ± 0.2% | | 1.00 | 1.18 | 8446.10 |
| imported/rsc/medium-1mb | 27 | 13148560.02 ± 0.3% | not timed | not timed | 11219871.50 ± 0.8% | 48.64 ± 0.4% | not timed | not timed | 13066708.36 ± 0.3% | | 1.01 | 1.17 | 270326.89 |
| imported/rsc/hard-32 | 58 | 423.18 ± 1.9% | not timed | not timed | 363.29 ± 0.4% | 49.50 ± 7.5% | not timed | not timed | 421.36 ± 0.2% | | 1.00 | 1.16 | 8.55 |
| imported/rsc/hard-1k | 27 | 12917.25 ± 0.4% | not timed | not timed | 11432.08 ± 0.1% | 40.65 ± 0.1% | not timed | not timed | 12849.96 ± 0.1% | | 1.01 | 1.13 | 317.74 |
| imported/rsc/hard-32k | 27 | 403265.34 ± 0.1% | not timed | not timed | 359501.19 ± 0.2% | 29.10 ± 0.0% | not timed | not timed | 401709.80 ± 0.3% | | 1.00 | 1.12 | 13859.80 |
| imported/rsc/hard-1mb | 51 | 8371649.21 ± 0.3% | not timed | not timed | 7246324.54 ± 0.1% | 29.11 ± 0.1% | not timed | not timed | 8367867.18 ± 0.2% | | 1.00 | 1.16 | 287627.84 |
| imported/rsc/reallyhard0-32 | 58 | 263.82 ± 2.3% | not timed | not timed | 223.87 ± 0.0% | 49.58 ± 8.6% | not timed | not timed | 263.82 ± 0.5% | | 1.00 | 1.18 | 5.32 |
| imported/rsc/reallyhard0-1k | 27 | 581.36 ± 0.3% | not timed | not timed | 583.70 ± 0.2% | 40.70 ± 0.1% | not timed | not timed | 581.40 ± 0.4% | | 1.00 | 1.00 | 14.28 |
| imported/rsc/reallyhard0-32k | 27 | 603.94 ± 0.4% | not timed | not timed | 615.94 ± 0.0% | 28.92 ± 0.1% | not timed | not timed | 602.05 ± 0.5% | | 1.00 | 0.98 | 20.88 |
| imported/rsc/reallyhard0-1mb | 51 | 629.01 ± 1.4% | not timed | not timed | 616.17 ± 0.2% | 28.90 ± 0.1% | not timed | not timed | 626.18 ± 1.3% | | 1.00 | 1.02 | 21.77 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.68 ± 1.9% | not timed | not timed | 192.46 ± 2.4% | 60.43 ± 14.4% | not timed | not timed | 286.74 ± 1.4% | | 0.99 | 1.48 | 4.71 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7064.33 ± 0.1% | not timed | not timed | 5942.12 ± 0.0% | 34.04 ± 1.2% | not timed | not timed | 7083.75 ± 0.0% | | 1.00 | 1.19 | 207.53 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21452.21 ± 0.1% | not timed | not timed | 19301.56 ± 0.1% | 24.77 ± 1.2% | not timed | not timed | 21460.69 ± 0.0% | | 1.00 | 1.11 | 866.16 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21762.28 ± 0.7% | not timed | not timed | 19946.69 ± 1.0% | 24.74 ± 1.3% | not timed | not timed | 21713.18 ± 0.9% | | 1.00 | 1.09 | 879.69 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 280.75 ± 1.8% | not timed | not timed | 212.03 ± 0.2% | 60.87 ± 16.7% | not timed | not timed | 282.03 ± 1.5% | | 1.00 | 1.32 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5927.67 ± 0.0% | not timed | not timed | 6186.33 ± 0.1% | 34.17 ± 6.8% | not timed | not timed | 5934.67 ± 0.0% | | 1.00 | 0.96 | 173.50 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21331.77 ± 0.1% | not timed | not timed | 19019.20 ± 0.1% | 24.00 ± 2.5% | not timed | not timed | 21404.65 ± 0.2% | | 1.00 | 1.12 | 888.72 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21034.84 ± 1.1% | not timed | not timed | 19530.00 ± 1.2% | 24.89 ± 0.3% | not timed | not timed | 21124.71 ± 1.1% | | 1.00 | 1.08 | 844.96 |
| imported/sherlock/name-sherlock | 776 | 19852.13 ± 2.3% | not timed | not timed | 18539.43 ± 0.7% | 10002.95 ± 24.9% | not timed | not timed | 19828.50 ± 2.0% | | 1.00 | 1.07 | 1.98 |
| imported/sherlock/name-holmes | 2766 | 15113.95 ± 1.5% | not timed | not timed | 15473.56 ± 0.4% | 3158.16 ± 15.7% | not timed | not timed | 15295.31 ± 2.0% | | 0.99 | 0.98 | 4.79 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19864.86 ± 1.8% | not timed | not timed | 18514.86 ± 0.4% | 8026.20 ± 25.0% | not timed | not timed | 19907.66 ± 2.1% | | 1.00 | 1.07 | 2.48 |
| imported/sherlock/name-sherlock-casei | 816 | 15706.42 ± 0.3% | not timed | not timed | 3998.21 ± 0.2% | 32.51 ± 0.5% | not timed | not timed | 15718.76 ± 0.2% | | 1.00 | 3.93 | 483.15 |
| imported/sherlock/name-holmes-casei | 2802 | 9319.38 ± 5.5% | not timed | not timed | 3302.06 ± 0.1% | 37.01 ± 3.3% | not timed | not timed | 9378.35 ± 1.8% | | 0.99 | 2.82 | 251.78 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12938.97 ± 9.6% | not timed | not timed | 3937.86 ± 0.2% | 32.44 ± 0.2% | not timed | not timed | 12911.14 ± 1.4% | | 1.00 | 3.29 | 398.90 |
| imported/sherlock/name-whitespace | 1461 | 15324.22 ± 1.6% | not timed | not timed | 14466.32 ± 0.3% | 6432.80 ± 19.9% | not timed | not timed | 15362.63 ± 1.6% | | 1.00 | 1.06 | 2.38 |
| imported/sherlock/name-alt1 | 1142 | 11554.71 ± 0.5% | not timed | not timed | 16323.32 ± 0.7% | 4089.04 ± 35.4% | not timed | not timed | 11537.19 ± 6.6% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8879.89 ± 0.3% | not timed | not timed | 3825.67 ± 0.1% | 30.71 ± 0.1% | not timed | not timed | 8885.39 ± 0.3% | | 1.00 | 2.32 | 289.20 |
| imported/sherlock/name-alt3 | 4507 | 5538.51 ± 0.5% | not timed | not timed | 3632.58 ± 0.1% | 9.65 ± 0.2% | not timed | not timed | 5527.80 ± 0.4% | | 1.00 | 1.52 | 574.18 |
| imported/sherlock/name-alt3-casei | 4593 | 1516.32 ± 2.1% | not timed | not timed | 284.72 ± 0.4% | 6.32 ± 0.2% | not timed | not timed | 1524.43 ± 0.6% | | 0.99 | 5.33 | 239.77 |
| imported/sherlock/name-alt4 | 3686 | 6408.32 ± 0.6% | not timed | not timed | 3784.68 ± 0.0% | 31.03 ± 0.2% | not timed | not timed | 6418.73 ± 0.3% | | 1.00 | 1.69 | 206.55 |
| imported/sherlock/name-alt4-casei | 4254 | 2815.35 ± 2.3% | not timed | not timed | 2587.28 ± 0.1% | 19.68 ± 0.2% | not timed | not timed | 2818.63 ± 1.0% | | 1.00 | 1.09 | 143.07 |
| imported/sherlock/name-alt5 | 4028 | 6368.68 ± 0.4% | not timed | not timed | 3745.43 ± 0.2% | 21.77 ± 0.3% | not timed | not timed | 6366.50 ± 0.2% | | 1.00 | 1.70 | 292.49 |
| imported/sherlock/name-alt5-casei | 4104 | 3489.51 ± 2.0% | not timed | not timed | 2210.65 ± 0.2% | 14.08 ± 0.1% | not timed | not timed | 3493.35 ± 1.3% | | 1.00 | 1.58 | 247.77 |
| imported/sherlock/no-match-uncommon | 0 | 21634.15 ± 0.3% | not timed | not timed | 19471.33 ± 0.4% | 35573.53 ± 0.7% | not timed | not timed | 21618.34 ± 0.6% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21485.10 ± 0.2% | not timed | not timed | 19581.58 ± 0.2% | 1275.67 ± 0.5% | not timed | not timed | 21500.54 ± 0.4% | | 1.00 | 1.10 | 16.84 |
| imported/sherlock/no-match-really-common | 0 | 16130.76 ± 1.7% | not timed | not timed | 18758.13 ± 0.5% | 1279.89 ± 0.9% | not timed | not timed | 16172.05 ± 1.8% | | 1.00 | 0.86 | 12.60 |
| imported/sherlock/the-lower | 21654 | 2293.42 ± 0.7% | not timed | not timed | 2340.66 ± 0.3% | 241.46 ± 17.8% | not timed | not timed | 2299.93 ± 2.9% | | 1.00 | 0.98 | 9.50 |
| imported/sherlock/the-upper | 2223 | 12716.23 ± 1.5% | not timed | not timed | 13580.77 ± 0.4% | 2723.77 ± 1.4% | not timed | not timed | 12786.54 ± 0.8% | | 0.99 | 0.94 | 4.67 |
| imported/sherlock/the-casei | 23961 | 1986.43 ± 0.9% | not timed | not timed | 1311.28 ± 0.5% | 34.74 ± 27.2% | not timed | not timed | 1989.76 ± 0.4% | | 1.00 | 1.51 | 57.19 |
| imported/sherlock/everything-greedy | 581881 | 282.46 ± 0.3% | not timed | not timed | 165.22 ± 0.2% | 28.29 ± 24.2% | not timed | not timed | 282.47 ± 0.7% | | 1.00 | 1.71 | 9.98 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.59 ± 0.1% | not timed | not timed | 212.70 ± 0.5% | 32.17 ± 0.1% | not timed | not timed | 489.70 ± 0.1% | | 1.00 | 2.31 | 15.25 |
| imported/sherlock/letters | 447175 | 61.64 ± 1.5% | not timed | not timed | 32.77 ± 0.3% | 6.67 ± 18.3% | not timed | not timed | 61.68 ± 0.6% | | 1.00 | 1.88 | 9.24 |
| imported/sherlock/letters-upper | 14180 | 447.90 ± 1.5% | not timed | not timed | 369.34 ± 0.2% | 29.54 ± 22.1% | not timed | not timed | 445.88 ± 0.2% | | 1.00 | 1.21 | 15.16 |
| imported/sherlock/letters-lower | 432995 | 62.50 ± 1.0% | not timed | not timed | 33.82 ± 0.1% | 6.25 ± 41.0% | not timed | not timed | 62.85 ± 1.0% | | 0.99 | 1.85 | 10.00 |
| imported/sherlock/words | 447639 | 112.87 ± 0.7% | not timed | not timed | 81.76 ± 0.2% | 13.94 ± 2.6% | not timed | not timed | 113.06 ± 0.7% | | 1.00 | 1.38 | 8.10 |
| imported/sherlock/before-holmes | 4073 | 10253.04 ± 0.3% | not timed | not timed | 8451.29 ± 0.3% | 23.77 ± 1.9% | not timed | not timed | 10234.24 ± 0.4% | | 1.00 | 1.21 | 431.33 |
| imported/sherlock/before-after-holmes | 2593 | 9932.47 ± 0.7% | not timed | not timed | 9513.12 ± 0.3% | 23.93 ± 0.7% | not timed | not timed | 9948.23 ± 0.7% | | 1.00 | 1.04 | 415.13 |
| imported/sherlock/holmes-cochar-watson | 150 | 5206.26 ± 0.2% | not timed | not timed | 3425.42 ± 0.2% | 30.72 ± 0.1% | not timed | not timed | 5202.73 ± 0.4% | | 1.00 | 1.52 | 169.48 |
| imported/sherlock/holmes-coword-watson | 14309 | 1149.97 ± 0.3% | not timed | not timed | 1121.67 ± 0.2% | 6.76 ± 0.1% | not timed | not timed | 1153.11 ± 0.3% | | 1.00 | 1.03 | 170.07 |
| imported/sherlock/quotes | 14437 | 1571.32 ± 0.7% | not timed | not timed | 1746.49 ± 1.1% | 35.00 ± 0.1% | not timed | not timed | 1571.23 ± 0.3% | | 1.00 | 0.90 | 44.90 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17426.52 ± 0.3% | not timed | not timed | 16031.18 ± 0.3% | 36.45 ± 0.1% | not timed | not timed | 17308.40 ± 0.4% | | 1.01 | 1.09 | 478.15 |
| imported/sherlock/word-ending-n | 35297 | 481.48 ± 1.4% | not timed | not timed | 408.53 ± 0.1% | 23.55 ± 24.7% | not timed | not timed | 480.67 ± 0.6% | | 1.00 | 1.18 | 20.44 |
| imported/sherlock/repeated-class-negation | 2130 | 14909.14 ± 0.7% | not timed | not timed | 10752.31 ± 0.8% | 11.58 ± 0.2% | not timed | not timed | 14851.23 ± 0.4% | | 1.00 | 1.39 | 1287.95 |
| imported/sherlock/ing-suffix | 20547 | 559.29 ± 0.4% | not timed | not timed | 517.12 ± 0.3% | 28.86 ± 0.1% | not timed | not timed | 558.45 ± 0.5% | | 1.00 | 1.08 | 19.38 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1672.11 ± 1.4% | not timed | not timed | 2104.43 ± 0.9% | 20.53 ± 0.3% | not timed | not timed | 1666.83 ± 0.7% | | 1.00 | 0.79 | 81.44 |
| opt/accelerate/whole-line | 239963 | 458.10 ± 0.4% | not timed | not timed | 372.68 ± 0.3% | 91.57 ± 16.9% | not timed | not timed | 457.58 ± 0.1% | | 1.00 | 1.23 | 5.00 |
| opt/accelerate/non-dna | 16745 | 431.88 ± 0.2% | not timed | not timed | 398.69 ± 0.1% | 29.45 ± 17.0% | not timed | not timed | 431.42 ± 0.9% | | 1.00 | 1.08 | 14.67 |
| opt/backtrack/words-english | 40536 | 141.54 ± 8.3% | not timed | not timed | 94.33 ± 0.1% | 19.74 ± 6.9% | not timed | not timed | 141.57 ± 1.8% | | 1.00 | 1.50 | 7.17 |
| opt/fixed-length/too-small-ascii | 0 | 315.13 ± 1.0% | not timed | not timed | 691.66 ± 4.5% | 80.34 ± 0.5% | not timed | not timed | 315.00 ± 0.4% | | 1.00 | 0.46 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3467.04 ± 0.5% | not timed | not timed | 5864.92 ± 0.5% | 124.26 ± 0.4% | not timed | not timed | 3483.15 ± 0.5% | | 1.00 | 0.59 | 27.90 |
| opt/fixed-length/go33484-1 | 0 | 669034.22 ± 0.3% | not timed | not timed | 1117747.63 ± 0.5% | 61377.28 ± 0.3% | not timed | not timed | 669009.89 ± 0.4% | | 1.00 | 0.60 | 10.90 |
| opt/fixed-length/go33484-2 | 0 | 668136.92 ± 0.4% | not timed | not timed | 1120364.64 ± 0.4% | 32300.56 ± 2.6% | not timed | not timed | 667308.03 ± 0.4% | | 1.00 | 0.60 | 20.68 |
| opt/fixed-length/go33484-3 | 0 | 67150.03 ± 0.8% | not timed | not timed | 111656.44 ± 0.5% | 769.05 ± 0.7% | not timed | not timed | 66638.65 ± 0.6% | | 1.01 | 0.60 | 87.32 |
| opt/literal-alt/one-pattern | 1 | 548.21 ± 1.5% | not timed | not timed | 539.89 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 548.92 ± 1.6% | | 1.00 | 1.02 | 1367.64 |
| opt/onepass/fn-predicate | 916 | 364.06 ± 0.6% | not timed | not timed | 333.87 ± 0.1% | 201.60 ± 12.5% | not timed | not timed | 368.51 ± 0.6% | | 0.99 | 1.09 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 178.29 ± 7.3% | not timed | not timed | 199.89 ± 0.2% | 78.64 ± 9.9% | not timed | not timed | 182.01 ± 1.6% | | 0.98 | 0.89 | 2.27 |
| opt/prefilter/literal-english | 1 | 21065.24 ± 0.1% | not timed | not timed | 20119.57 ± 0.3% | 17523.18 ± 0.3% | not timed | not timed | 20990.86 ± 0.2% | | 1.00 | 1.05 | 1.20 |
| opt/prefilter/literal-casei-english | 1 | 14597.36 ± 0.6% | not timed | not timed | 4315.57 ± 0.2% | 32.58 ± 0.7% | not timed | not timed | 14600.89 ± 0.5% | | 1.00 | 3.38 | 448.07 |
| opt/prefilter/literal-russian | 1 | 21171.25 ± 0.5% | not timed | not timed | 19645.18 ± 0.7% | 3319.65 ± 0.1% | not timed | not timed | 21178.00 ± 0.7% | | 1.00 | 1.08 | 6.38 |
| opt/prefilter/literal-casei-russian | 1 | 8532.86 ± 0.9% | not timed | not timed | 3888.95 ± 0.2% | 31.75 ± 0.8% | not timed | not timed | 8542.96 ± 0.4% | | 1.00 | 2.19 | 268.78 |
| opt/prefilter/rust-functions | 948 | 6810.34 ± 0.3% | not timed | not timed | 8915.76 ± 0.5% | 1867.70 ± 0.3% | not timed | not timed | 6814.45 ± 0.2% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29547373.30 ± 0.1% | not timed | not timed | 20855473.19 ± 0.1% | 50.54 ± 0.1% | not timed | not timed | 29573901.75 ± 0.1% | | 1.00 | 1.42 | 584630.79 |
| opt/reverse-inner/holmes | 2593 | 9929.24 ± 0.9% | not timed | not timed | 9521.43 ± 0.3% | 23.86 ± 2.1% | not timed | not timed | 9951.54 ± 0.5% | | 1.00 | 1.04 | 416.19 |
| opt/reverse-inner/email | 47 | 36198.10 ± 5.0% | not timed | not timed | 44972.19 ± 0.8% | 32.47 ± 0.6% | not timed | not timed | 36225.78 ± 2.6% | | 1.00 | 0.80 | 1114.70 |
| opt/reverse-inner/factored-prefix | 3542 | 593.20 ± 0.4% | not timed | not timed | 597.20 ± 0.1% | 12.55 ± 0.2% | not timed | not timed | 590.39 ± 0.5% | | 1.00 | 0.99 | 47.26 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20997.69 ± 0.2% | not timed | not timed | 614.59 ± 0.6% | 74.81 ± 0.1% | not timed | not timed | 21151.16 ± 0.0% | | 0.99 | 34.17 | 280.67 |
| opt/reverse-inner/no-quadratic-forward | 0 | 726.54 ± 1.6% | not timed | not timed | 288.21 ± 0.1% | 24.68 ± 0.1% | not timed | not timed | 730.64 ± 1.4% | | 0.99 | 2.52 | 29.44 |
| opt/reverse-suffix/holmes | 4073 | 10260.92 ± 0.4% | not timed | not timed | 8452.18 ± 0.6% | 24.14 ± 0.7% | not timed | not timed | 10255.61 ± 0.5% | | 1.00 | 1.21 | 425.04 |
| opt/reverse-suffix/no-quadratic | 0 | 21054.90 ± 0.1% | not timed | not timed | 611.38 ± 0.1% | 74.62 ± 0.1% | not timed | not timed | 21133.81 ± 0.0% | | 1.00 | 34.44 | 282.17 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.49 ± 2.0% | not timed | not timed | 131.32 ± 0.2% | 13.53 ± 13.2% | not timed | not timed | 120.40 ± 1.8% | | 1.00 | 0.92 | 8.90 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.90 ± 1.0% | not timed | not timed | 134.04 ± 0.1% | 14.63 ± 17.5% | not timed | not timed | 120.82 ± 9.9% | | 1.00 | 0.90 | 8.26 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 3.7% | not timed | not timed | 0.55 ± 0.5% | 109.77 ± 8.2% | not timed | not timed | 0.28 ± 0.6% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.43 ± 0.1% | not timed | not timed | 289.11 ± 0.4% | 104.50 ± 0.1% | not timed | not timed | 323.18 ± 0.3% | | 1.00 | 1.12 | 3.09 |
| reported/i13-subset-regex/original-ascii | 4094 | 11248.44 ± 0.5% | not timed | not timed | 4541.23 ± 0.7% | 11.51 ± 0.1% | not timed | not timed | 11288.52 ± 1.0% | | 1.00 | 2.48 | 977.06 |
| reported/i13-subset-regex/original-unicode | 4094 | 11119.85 ± 1.6% | not timed | not timed | 252.00 ± 3.1% | 11.50 ± 0.1% | not timed | not timed | 11278.00 ± 0.8% | | 0.99 | 44.13 | 966.53 |
| reported/i13-subset-regex/big-ascii | 1955 | 10741.72 ± 1.0% | not timed | not timed | 67.98 ± 3.6% | 9.79 ± 0.2% | not timed | not timed | 10793.08 ± 0.8% | | 1.00 | 158.02 | 1097.27 |
| reported/i13-subset-regex/big-unicode | 1955 | 10633.39 ± 1.4% | not timed | not timed | 12.22 ± 54.9% | 9.84 ± 0.1% | not timed | not timed | 10756.99 ± 1.1% | | 0.99 | 870.22 | 1080.53 |
| reported/i13-subset-regex/huge-ascii | 55 | 10119.61 ± 1.4% | not timed | not timed | 11.03 ± 0.1% | 8.78 ± 0.1% | not timed | not timed | 10089.99 ± 2.9% | | 1.00 | 917.60 | 1152.55 |
| reported/i13-subset-regex/huge-unicode | 55 | 10076.56 ± 2.5% | not timed | not timed | 11.00 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9873.32 ± 3.3% | | 1.02 | 915.97 | 1149.22 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.0% | not timed | not timed | 11.08 ± 0.0% | 8.76 ± 1.3% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 10.99 ± 0.4% | 8.78 ± 0.3% | not timed | not timed | 4.97 ± 0.0% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.59 ± 0.2% | not timed | not timed | 104.30 ± 0.2% | 6.50 ± 0.2% | not timed | not timed | 484.46 ± 0.6% | | 1.00 | 4.64 | 74.42 |
| reported/i787-keywords/opt-ascii | 5674 | 483.80 ± 0.5% | not timed | not timed | 270.37 ± 0.3% | 10.30 ± 0.1% | not timed | not timed | 483.73 ± 0.2% | | 1.00 | 1.79 | 46.99 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 0.4% | not timed | not timed | 4.97 ± 0.4% | 0.05 ± 0.2% | not timed | not timed | 7.11 ± 0.4% | | 1.00 | 1.42 | 143.80 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.3% | not timed | not timed | 2.76 ± 0.3% | 0.01 ± 0.2% | not timed | not timed | 3.43 ± 0.3% | | 1.00 | 1.24 | 268.57 |
| slow/quadratic-haystack-1x | 100 | 21.98 ± 7.6% | not timed | not timed | 10.01 ± 0.3% | 1.01 ± 15.2% | not timed | not timed | 21.86 ± 1.1% | | 1.01 | 2.20 | 21.70 |
| slow/quadratic-haystack-2x | 200 | 19.68 ± 1.2% | not timed | not timed | 5.54 ± 0.2% | 0.54 ± 1.6% | not timed | not timed | 19.60 ± 6.3% | | 1.00 | 3.55 | 36.22 |
| unicode/codepoints/any-one | 1112064 | 282.52 ± 0.3% | not timed | not timed | 173.00 ± 0.1% | 18.14 ± 1.9% | not timed | not timed | 281.46 ± 0.5% | | 1.00 | 1.63 | 15.57 |
| unicode/codepoints/any-all | 4382592 | 281.92 ± 1.8% | not timed | not timed | 247.07 ± 0.3% | 117.47 ± 0.1% | not timed | not timed | 282.45 ± 1.6% | | 1.00 | 1.14 | 2.40 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.71 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 603.30 ± 1.1% | not timed | not timed | 616.17 ± 0.2% | 135.43 ± 0.1% | not timed | not timed | 600.38 ± 1.2% | | 1.00 | 0.98 | 4.45 |
| unicode/overlapping-words/ascii | 6156 | 31.71 ± 0.3% | not timed | not timed | 38.94 ± 0.1% | 3.92 ± 1.0% | not timed | not timed | 31.83 ± 0.2% | | 1.00 | 0.81 | 8.09 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 3.78 ± 1.0% | 2.35 ± 0.7% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.38 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.3% | not timed | not timed | 3.59 ± 0.2% | 6.31 ± 9.8% | not timed | not timed | 1.28 ± 0.1% | | 1.00 | 0.36 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.08 ± 3.2% | not timed | not timed | 82.45 ± 0.2% | 12.10 ± 18.2% | not timed | not timed | 129.49 ± 0.6% | | 1.00 | 1.57 | 10.67 |
| unicode/word/boundary-long-english | 3466 | 607.24 ± 0.3% | not timed | not timed | 606.55 ± 0.1% | 31.81 ± 0.6% | not timed | not timed | 606.88 ± 0.5% | | 1.00 | 1.00 | 19.09 |
| unicode/word/around-holmes-english | 27 | 20228.05 ± 0.2% | not timed | not timed | 19645.67 ± 0.2% | 22.18 ± 1.4% | not timed | not timed | 20152.65 ± 0.2% | | 1.00 | 1.03 | 912.09 |
| wild/bibleref/long | 874 | 565.70 ± 0.2% | not timed | not timed | 581.14 ± 0.3% | 6.77 ± 0.2% | not timed | not timed | 568.37 ± 0.2% | | 1.00 | 0.97 | 83.51 |
| wild/bibleref/short | 30 | 25.36 ± 2.7% | not timed | not timed | 31.04 ± 0.3% | 14.25 ± 12.4% | not timed | not timed | 26.06 ± 3.9% | | 0.97 | 0.82 | 1.78 |
| wild/bibleref/line | 874 | 395.15 ± 0.1% | not timed | not timed | 216.79 ± 0.0% | 9.21 ± 8.2% | not timed | not timed | 395.82 ± 1.6% | | 1.00 | 1.82 | 42.89 |
| wild/caddy/caddy | 6 | 419.48 ± 3.8% | not timed | not timed | 242.08 ± 0.0% | 68.49 ± 14.8% | not timed | not timed | 422.35 ± 0.8% | | 0.99 | 1.73 | 6.12 |
| wild/dot-star-capture/rust-src-tools | 6 | 1069.14 ± 0.6% | not timed | not timed | 349.72 ± 0.5% | 13.51 ± 0.2% | not timed | not timed | 1061.83 ± 0.6% | | 1.01 | 3.06 | 79.13 |
| wild/ruff/noqa | 84 | 437.53 ± 0.3% | not timed | not timed | 467.68 ± 0.2% | 19.70 ± 2.2% | not timed | not timed | 436.70 ± 1.6% | | 1.00 | 0.94 | 22.21 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.70 ± 0.5% | not timed | not timed | 701.43 ± 0.3% | 136.06 ± 10.9% | not timed | not timed | 962.17 ± 0.4% | | 1.00 | 1.37 | 7.04 |
| wild/ruff/string-quote-prefix | 2972 | 1365.18 ± 0.7% | not timed | not timed | 441.33 ± 0.1% | 315.20 ± 25.5% | not timed | not timed | 1364.08 ± 0.8% | | 1.00 | 3.09 | 4.33 |
| wild/ruff/space-around-operator | 1224378 | 222.25 ± 1.9% | not timed | not timed | 187.50 ± 0.0% | 18.32 ± 1.6% | not timed | not timed | 223.05 ± 1.9% | | 1.00 | 1.19 | 12.13 |
| wild/ruff/shebang | 282 | 972.02 ± 0.5% | not timed | not timed | 330.54 ± 0.0% | 111.38 ± 9.3% | not timed | not timed | 972.67 ± 0.5% | | 1.00 | 2.94 | 8.73 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13840.21 ± 0.3% | not timed | not timed | 13840.80 ± 0.4% | 6939.33 ± 1.1% | not timed | not timed | 13853.32 ± 0.3% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12866.16 ± 0.3% | not timed | not timed | 13526.38 ± 0.4% | 6413.25 ± 0.6% | not timed | not timed | 12849.90 ± 0.1% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13197.27 ± 0.4% | not timed | not timed | 13688.93 ± 0.6% | 6613.64 ± 0.5% | not timed | not timed | 13260.89 ± 0.8% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9568.28 ± 0.1% | not timed | not timed | 13616.94 ± 0.3% | 6730.49 ± 1.0% | not timed | not timed | 9574.58 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.59 ± 13.9% | not timed | not timed | 65.88 ± 0.5% | 2.20 ± 0.8% | not timed | not timed | 120.47 ± 13.9% | | 1.01 | 1.85 | 55.23 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 45.4% | not timed | not timed | 0.01 ± 0.8% | 0.01 ± 15.6% | not timed | not timed | 0.03 ± 64.6% | | 0.99 | 3.05 | 3.94 |
| dictionary/compile/english-15 | 1 | 0.34 ± 23.2% | not timed | not timed | 0.07 ± 1.0% | 0.10 ± 11.0% | not timed | not timed | 0.34 ± 1.0% | | 0.99 | 4.91 | 3.39 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 1.6% | not timed | not timed | 0.02 ± 1.3% | 35.39 ± 1.0% | not timed | not timed | 0.25 ± 0.5% | | 0.98 | 12.64 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.34 ± 2.1% | not timed | not timed | 11.53 ± 0.3% | 56.31 ± 20.8% | not timed | not timed | 46.73 ± 6.4% | | 0.99 | 4.02 | 0.82 |
| reported/i787-keywords/compile | 1 | 35.14 ± 1.5% | not timed | not timed | 2.12 ± 1.1% | 16.95 ± 29.3% | not timed | not timed | 35.03 ± 17.9% | | 1.00 | 16.56 | 2.07 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 336.95 ± 4.6% | not timed | not timed | 125.83 ± 0.3% | 570.73 ± 22.6% | not timed | not timed | 344.99 ± 6.6% | | 0.98 | 2.68 | 0.59 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.84 ± 1.5% | not timed | not timed | 4.13 ± 0.5% | 43.10 ± 7.6% | not timed | not timed | 47.59 ± 2.6% | | 0.98 | 11.35 | 1.09 |
| unicode/compile/one-letter | 53 | 6.61 ± 13.7% | not timed | not timed | 4.53 ± 0.8% | 64.90 ± 4.5% | not timed | not timed | 6.72 ± 12.5% | | 0.98 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.04 ± 14.7% | not timed | not timed | 0.10 ± 1.0% | 66.05 ± 6.8% | not timed | not timed | 1.07 ± 1.9% | | 0.96 | 10.46 | 0.0157 |
| unicode/compile/fifty-letters-ascii | 1 | 213.91 ± 1.9% | not timed | not timed | 52.60 ± 0.1% | 194.60 ± 31.7% | not timed | not timed | 214.03 ± 6.6% | | 1.00 | 4.07 | 1.10 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 357.55 ± 17.4% | not timed | not timed | 47.35 ± 0.8% | 675.61 ± 21.3% | not timed | not timed | 367.42 ± 18.1% | | 0.97 | 7.55 | 0.53 |
| unicode/compile/match-every-line-ascii | 4 | 563.84 ± 3.3% | not timed | not timed | 144.87 ± 0.2% | 664.95 ± 17.2% | not timed | not timed | 581.04 ± 18.2% | | 0.97 | 3.89 | 0.85 |
| unicode/compile/negated-class-matches-codepoint | 1 | 288.04 ± 6.1% | not timed | not timed | 51.26 ± 0.3% | 1294.52 ± 23.5% | not timed | not timed | 307.47 ± 1.1% | | 0.94 | 5.62 | 0.22 |
| wild/bibleref/compile | 3 | 5.73 ± 5.6% | not timed | not timed | 1.92 ± 0.7% | 32.22 ± 7.3% | not timed | not timed | 5.90 ± 6.0% | | 0.97 | 2.99 | 0.18 |
| wild/url/compile | 1 | 0.62 ± 18.3% | not timed | not timed | 0.15 ± 0.5% | 0.45 ± 29.6% | not timed | not timed | 0.62 ± 16.5% | | 0.99 | 4.27 | 1.39 |

