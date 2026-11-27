# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
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
| literal: a word | 217 | 35500.65 ± 3.7% | 9568.65 ± 4.3% | 19.73 ± 1.8% | 31420.00 ± 0.4% | 9093.77 ± 7.3% | 10.79 ± 0.1% | 74.26 ± 2.5% | 36007.17 ± 2.1% | 3.71 | 0.99 | 1.13 | 3.90 |
| literal: a word that is not there | 0 | 53321.69 ± 3.1% | 8442.66 ± 2.6% | 19.72 ± 44.1% | 39541.55 ± 2.6% | 30211.59 ± 0.5% | 10.66 ± 1.3% | 69.84 ± 20.8% | 53956.65 ± 6.4% | 6.32 | 0.99 | 1.35 | 1.76 |
| literal: one of four words | 661 | 11898.59 ± 0.6% | 1369.83 ± 1.0% | 10.47 ± 1.1% | 9128.90 ± 0.5% | 17.19 ± 6.3% | 3.99 ± 0.9% | 6.00 ± 0.8% | 11869.45 ± 0.7% | 8.69 | 1.00 | 1.30 | 692.04 |
| literal: a word in any case | 217 | 28218.64 ± 2.9% | 1470.73 ± 0.7% | 14.38 ± 2.4% | 9248.88 ± 0.4% | 34.26 ± 3.6% | refused | differs | 28155.64 ± 2.0% | 19.19 | 1.00 | 3.05 | 823.59 |
| literal: an href attribute | 33 | 29159.24 ± 0.3% | 538.15 ± 0.3% | 17.87 ± 3.7% | 27521.36 ± 0.3% | 2033.27 ± 2.8% | 8.23 ± 2.3% | 58.80 ± 2.4% | 29144.31 ± 1.4% | 54.18 | 1.00 | 1.06 | 14.34 |
| literal: a word, second text | 123 | 35846.27 ± 1.2% | 3773.52 ± 0.7% | 18.93 ± 5.2% | 31900.67 ± 13.1% | 7030.66 ± 9.2% | 10.97 ± 0.4% | 59.25 ± 2.5% | 35402.32 ± 2.1% | 9.50 | 1.01 | 1.12 | 5.10 |
| class: two capitalized words | 1331 | 969.97 ± 1.1% | 525.96 ± 1.0% | 17.94 ± 2.4% | 505.06 ± 0.9% | 31.61 ± 10.8% | 9.30 ± 1.8% | 52.72 ± 0.5% | 959.57 ± 5.4% | 1.84 | 1.01 | 1.92 | 30.68 |
| class: a word that ends in ing | 3399 | 502.52 ± 0.4% | 501.62 ± 1.9% | 13.13 ± 1.0% | 471.02 ± 0.2% | 24.45 ± 2.8% | 5.34 ± 0.2% | 15.18 ± 8.1% | 502.86 ± 0.2% | 1.00 | 1.00 | 1.07 | 20.55 |
| class: a word in capitals | 2332 | 1310.52 ± 7.1% | 534.32 ± 0.4% | 18.82 ± 2.7% | 497.78 ± 0.7% | 34.15 ± 11.6% | 10.03 ± 0.3% | 71.71 ± 1.6% | 1299.34 ± 13.7% | 2.45 | 1.01 | 2.63 | 38.37 |
| class: a number | 8288 | 2280.81 ± 3.1% | 717.22 ± 0.6% | 18.82 ± 8.9% | 1489.72 ± 0.6% | 32.39 ± 12.8% | 0.33 ± 0.8% | 50.90 ± 3.5% | 2319.37 ± 3.5% | 3.18 | 0.98 | 1.53 | 70.41 |
| class: two capitalized words, second text | 5359 | 442.59 ± 2.3% | 451.20 ± 1.0% | 16.81 ± 3.9% | 414.03 ± 0.6% | 29.07 ± 12.8% | 9.99 ± 0.2% | 49.41 ± 1.1% | 445.28 ± 1.1% | 0.98 | 0.99 | 1.07 | 15.23 |
| other: a word between two words | 6104 | 710.21 ± 0.4% | 519.45 ± 3.7% | 16.63 ± 13.4% | 697.56 ± 0.4% | 89.88 ± 8.1% | 7.04 ± 0.2% | 53.27 ± 1.1% | 709.22 ± 0.9% | 1.37 | 1.00 | 1.02 | 7.90 |
| other: a number before a unit, second text | 1481 | 7217.13 ± 2.8% | 942.57 ± 2.2% | 17.74 ± 8.5% | 6306.79 ± 6.5% | 32.48 ± 11.1% | 11.00 ± 2.3% | 51.80 ± 2.4% | 7215.12 ± 2.2% | 7.66 | 1.00 | 1.14 | 222.21 |
| other: a heading's start tag | 110 | 18802.65 ± 1.8% | 652.74 ± 0.6% | 18.43 ± 5.8% | 1999.10 ± 0.7% | 1391.52 ± 9.9% | 10.03 ± 0.3% | 69.10 ± 1.1% | 19015.45 ± 2.0% | 28.81 | 0.99 | 9.41 | 13.51 |
| other: a whole word | 217 | 23954.59 ± 5.3% | 530.92 ± 0.6% | 18.87 ± 13.8% | 22723.03 ± 0.5% | 41.08 ± 1.9% | 9.39 ± 0.1% | 44.65 ± 3.4% | 24152.17 ± 2.0% | 45.12 | 0.99 | 1.05 | 583.12 |
| other: a line's first word, second text | 3716 | 1793.45 ± 2.9% | 511.70 ± 0.8% | 21.33 ± 3.1% | 1725.69 ± 2.8% | 49.33 ± 4.2% | refused | refused | 1796.43 ± 3.8% | 3.50 | 1.00 | 1.04 | 36.35 |
| other: fourteen octets before an x | 87 | 25114.10 ± 0.9% | 194.41 ± 1.6% | 5.22 ± 3.4% | 2907.00 ± 1.2% | 8.67 ± 5.4% | differs | 14.79 ± 2.2% | 25232.16 ± 2.4% | 129.18 | 1.00 | 8.64 | 2895.44 |
| other: a Greek word | 21815 | 462.27 ± 1.6% | 371.91 ± 0.3% | 22.95 ± 4.3% | 259.21 ± 3.5% | 41.40 ± 7.5% | differs | refused | 461.57 ± 0.8% | 1.24 | 1.00 | 1.78 | 11.16 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.02 ± 1.8% | 26.26 ± 1.6% | 0.77 ± 2.4% | 16.82 ± 1.5% | 2.26 ± 7.1% | differs | 3.34 ± 1.5% | 25.79 ± 1.6% | 0.99 | 1.01 | 1.55 | 11.54 |
| a UUID | 32895 | 22.36 ± 0.4% | 22.98 ± 0.5% | 0.53 ± 1.2% | 12.88 ± 0.3% | 2.45 ± 3.2% | 0.44 ± 0.1% | 2.96 ± 2.6% | 22.88 ± 2.9% | 0.97 | 0.98 | 1.74 | 9.14 |
| an IPv4 address | 33176 | 33.02 ± 1.7% | 33.94 ± 5.1% | 1.72 ± 2.5% | 23.94 ± 1.0% | 5.70 ± 2.5% | differs | 3.31 ± 1.9% | 33.62 ± 3.0% | 0.97 | 0.98 | 1.38 | 5.79 |
| a date and time | 32954 | 30.60 ± 0.6% | 30.68 ± 9.3% | 1.18 ± 1.3% | 18.04 ± 0.4% | 6.42 ± 5.0% | 0.76 ± 0.1% | 5.52 ± 1.2% | 30.69 ± 12.7% | 1.00 | 1.00 | 1.70 | 4.76 |
| a field path | 32606 | 28.23 ± 1.1% | 28.41 ± 1.1% | 0.88 ± 2.7% | 19.35 ± 0.8% | 2.87 ± 3.0% | differs | 2.30 ± 1.6% | 28.47 ± 2.6% | 0.99 | 0.99 | 1.46 | 9.84 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.07 ± 6.1% | 8.65 ± 2.7% | 8.59 ± 0.3% | 10.45 ± 1.0% | 4.56 ± 4.6% | 0.59 ± 0.5% | none | 8.63 ± 8.5% | 0.93 | 0.94 | 0.77 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 162.56 ± 18.2% | 180.89 ± 0.7% | 212.76 ± 0.7% | 79.81 ± 3.5% | 183.77 ± 4.3% | 519.63 ± 6.6% | 3669.48 ± 2.1% | 180.97 ± 0.4% | 0.90 | 0.90 | 2.04 | 0.88 |
| a UUID | 62 | 119.79 ± 9.9% | 120.02 ± 0.5% | 134.57 ± 0.6% | 46.00 ± 1.0% | 87.87 ± 1.4% | 197.88 ± 2.8% | 3772.09 ± 1.4% | 119.95 ± 0.8% | 1.00 | 1.00 | 2.60 | 1.36 |
| an IPv4 address | 29 | 363.32 ± 0.7% | 361.06 ± 11.9% | 520.03 ± 1.0% | 69.86 ± 0.5% | 112.20 ± 2.0% | 322.40 ± 1.2% | 6560.48 ± 3.1% | 360.68 ± 10.5% | 1.01 | 1.01 | 5.20 | 3.24 |
| a date and time | 56 | 266.56 ± 0.5% | 265.94 ± 1.0% | 343.14 ± 0.7% | 67.56 ± 1.3% | 119.47 ± 14.1% | 360.78 ± 1.6% | 3897.49 ± 2.7% | 266.16 ± 0.7% | 1.00 | 1.00 | 3.95 | 2.23 |
| a field path | 39 | 179.51 ± 0.3% | 179.61 ± 0.5% | 211.31 ± 0.3% | 72.85 ± 0.8% | 169.68 ± 1.8% | 557.67 ± 4.2% | 4399.28 ± 3.2% | 179.49 ± 0.4% | 1.00 | 1.00 | 2.46 | 1.06 |
| literal: a word | 7 | 519.22 ± 1.0% | 562.17 ± 0.8% | 1015.91 ± 3.1% | 481.21 ± 2.4% | 574.89 ± 3.9% | 1172.26 ± 1.1% | 23868.10 ± 1.5% | 521.10 ± 2.2% | 0.92 | 1.00 | 1.08 | 0.90 |
| literal: a word that is not there | 8 | 498.99 ± 3.5% | 542.57 ± 2.8% | 950.80 ± 2.3% | 438.90 ± 3.4% | 552.24 ± 1.3% | 1105.11 ± 1.4% | 21392.55 ± 1.6% | 504.63 ± 4.7% | 0.92 | 0.99 | 1.14 | 0.90 |
| literal: one of four words | 26 | 206.79 ± 5.1% | 333.53 ± 11.4% | 457.84 ± 13.0% | 40.76 ± 4.2% | 219.18 ± 9.5% | 440.55 ± 2.7% | 10555.53 ± 3.0% | 207.53 ± 2.6% | 0.62 | 1.00 | 5.07 | 0.94 |
| literal: a word in any case | 11 | 371.40 ± 0.7% | 394.33 ± 1.4% | 584.28 ± 0.5% | 14.34 ± 1.1% | 607.16 ± 2.9% | refused | 18210.91 ± 3.8% | 372.82 ± 0.6% | 0.94 | 1.00 | 25.91 | 0.61 |
| literal: an href attribute | 12 | 290.55 ± 1.9% | 301.44 ± 2.0% | 403.67 ± 1.7% | 36.48 ± 0.5% | 412.21 ± 2.2% | 919.05 ± 1.9% | 17643.74 ± 4.6% | 288.68 ± 1.7% | 0.96 | 1.01 | 7.97 | 0.70 |
| literal: a word, second text | 10 | 464.07 ± 0.9% | 509.31 ± 5.6% | 852.96 ± 9.8% | 412.79 ± 2.2% | 473.51 ± 3.9% | 995.24 ± 1.4% | 20160.75 ± 1.4% | 463.60 ± 2.2% | 0.91 | 1.00 | 1.12 | 0.98 |
| class: two capitalized words | 23 | 370.02 ± 2.2% | 394.83 ± 0.8% | 582.60 ± 3.2% | 92.02 ± 0.8% | 435.27 ± 2.1% | 905.48 ± 2.9% | 5819.96 ± 1.8% | 369.38 ± 0.5% | 0.94 | 1.00 | 4.02 | 0.85 |
| class: a word that ends in ing | 9 | 448.33 ± 0.6% | 509.46 ± 0.9% | 929.91 ± 1.2% | 113.15 ± 1.0% | 611.43 ± 16.1% | 1349.98 ± 2.1% | 13892.79 ± 2.5% | 449.48 ± 0.5% | 0.88 | 1.00 | 3.96 | 0.73 |
| class: a word in capitals | 16 | 396.89 ± 1.1% | 429.54 ± 0.7% | 736.25 ± 0.5% | 120.61 ± 1.9% | 636.02 ± 4.5% | 1230.64 ± 3.2% | 7740.29 ± 4.1% | 398.84 ± 2.6% | 0.92 | 1.00 | 3.29 | 0.62 |
| class: a number | 6 | 501.55 ± 1.7% | 554.71 ± 1.3% | 1119.57 ± 1.2% | 35.85 ± 2.0% | 1148.05 ± 1.2% | 2216.79 ± 0.9% | 18813.46 ± 2.1% | 506.67 ± 0.7% | 0.90 | 0.99 | 13.99 | 0.44 |
| class: two capitalized words, second text | 23 | 368.58 ± 1.8% | 398.37 ± 2.3% | 588.10 ± 2.5% | 92.75 ± 0.8% | 439.23 ± 2.2% | 906.96 ± 1.7% | 5817.82 ± 3.9% | 371.84 ± 1.9% | 0.93 | 0.99 | 3.97 | 0.84 |
| other: a word between two words | 13 | 450.65 ± 0.5% | 468.65 ± 0.3% | 755.82 ± 1.5% | 118.55 ± 1.1% | 429.81 ± 2.6% | 1017.20 ± 1.3% | 12834.35 ± 3.0% | 450.12 ± 1.0% | 0.96 | 1.00 | 3.80 | 1.05 |
| other: a number before a unit, second text | 15 | 327.06 ± 1.2% | 361.66 ± 0.8% | 514.26 ± 0.7% | 33.20 ± 1.2% | 531.21 ± 2.9% | 1063.32 ± 1.1% | 12951.07 ± 1.5% | 326.68 ± 1.9% | 0.90 | 1.00 | 9.85 | 0.62 |
| other: a heading's start tag | 13 | 301.58 ± 1.4% | 309.07 ± 0.5% | 416.72 ± 0.7% | 34.66 ± 0.6% | 511.95 ± 1.8% | 958.59 ± 1.4% | 15282.41 ± 2.9% | 302.03 ± 0.3% | 0.98 | 1.00 | 8.70 | 0.59 |
| other: a whole word | 11 | 456.26 ± 0.5% | 486.77 ± 0.8% | 802.75 ± 0.4% | 109.07 ± 1.2% | 499.43 ± 2.1% | 1035.46 ± 16.1% | 19535.63 ± 15.5% | 456.90 ± 0.9% | 0.94 | 1.00 | 4.18 | 0.91 |
| other: a line's first word, second text | 17 | 423.75 ± 1.0% | 456.98 ± 0.3% | 771.99 ± 1.3% | 113.55 ± 9.8% | 581.93 ± 4.7% | refused | refused | 427.85 ± 1.5% | 0.93 | 0.99 | 3.73 | 0.73 |
| other: fourteen octets before an x | 16 | 83.99 ± 1.2% | 117.96 ± 0.7% | 138.20 ± 0.4% | 13.75 ± 0.8% | 386.77 ± 3.9% | 437.46 ± 1.2% | 11242.53 ± 2.0% | 83.37 ± 1.0% | 0.71 | 1.01 | 6.11 | 0.22 |
| other: a Greek word | 8 | 344.57 ± 21.5% | 477.80 ± 0.6% | 846.22 ± 1.8% | 45.63 ± 1.2% | 1116.11 ± 2.9% | 2066.27 ± 1.3% | refused | 346.79 ± 1.3% | 0.72 | 0.99 | 7.55 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 24508.67 ± 2.8% | not timed | not timed | 27196.14 ± 0.4% | 1701.31 ± 26.3% | not timed | not timed | 24520.55 ± 1.4% | | 1.00 | 0.90 | 14.41 |
| 01-literal/sherlock-casei-en | 522 | 18873.85 ± 10.2% | not timed | not timed | 7036.32 ± 0.6% | 26.72 ± 6.6% | not timed | not timed | 19351.63 ± 7.2% | | 0.98 | 2.68 | 706.37 |
| 01-literal/sherlock-ru | 724 | 25550.36 ± 12.8% | not timed | not timed | 27743.75 ± 1.9% | 1047.33 ± 5.3% | not timed | not timed | 25656.56 ± 1.4% | | 1.00 | 0.92 | 24.40 |
| 01-literal/sherlock-casei-ru | 746 | 9459.50 ± 1.8% | not timed | not timed | 5510.70 ± 0.5% | 28.77 ± 4.1% | not timed | not timed | 9456.19 ± 0.7% | | 1.00 | 1.72 | 328.76 |
| 01-literal/sherlock-zh | 30 | 46943.75 ± 11.5% | not timed | not timed | 36989.97 ± 0.8% | 1265.57 ± 0.3% | not timed | not timed | 46657.54 ± 4.4% | | 1.01 | 1.27 | 37.09 |
| 02-literal-alternate/sherlock-en | 714 | 10419.08 ± 0.8% | not timed | not timed | 8887.13 ± 0.4% | 13.21 ± 3.6% | not timed | not timed | 10400.67 ± 0.8% | | 1.00 | 1.17 | 788.74 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2109.27 ± 0.2% | not timed | not timed | 1799.44 ± 0.3% | 9.01 ± 3.1% | not timed | not timed | 2105.34 ± 1.8% | | 1.00 | 1.17 | 234.13 |
| 02-literal-alternate/sherlock-ru | 899 | 7962.13 ± 0.5% | not timed | not timed | 4240.45 ± 0.3% | 18.06 ± 11.6% | not timed | not timed | 7934.47 ± 0.7% | | 1.00 | 1.88 | 440.89 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2077.47 ± 1.5% | not timed | not timed | 1039.18 ± 3.1% | 8.24 ± 7.8% | not timed | not timed | 2073.89 ± 1.6% | | 1.00 | 2.00 | 252.23 |
| 02-literal-alternate/sherlock-zh | 207 | 14736.54 ± 7.0% | not timed | not timed | 10437.81 ± 2.3% | 24.75 ± 1.8% | not timed | not timed | 14691.15 ± 2.7% | | 1.00 | 1.41 | 595.48 |
| 03-date/ascii | 111817 | 112.78 ± 1.5% | not timed | not timed | 84.18 ± 1.0% | 0.18 ± 2.4% | not timed | not timed | 112.90 ± 1.3% | | 1.00 | 1.34 | 635.25 |
| 04-ruff-noqa/real | 84 | 416.69 ± 0.6% | not timed | not timed | 430.09 ± 1.1% | 14.36 ± 1.3% | not timed | not timed | 416.26 ± 0.6% | | 1.00 | 0.97 | 29.01 |
| 04-ruff-noqa/tweaked | 44 | 693.77 ± 1.9% | not timed | not timed | 418.97 ± 0.9% | 288.12 ± 1.2% | not timed | not timed | 693.01 ± 2.3% | | 1.00 | 1.66 | 2.41 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 1.4% | not timed | not timed | 4.11 ± 5.2% | 0.21 ± 5.9% | not timed | not timed | 3.53 ± 2.9% | | 1.00 | 0.86 | 17.01 |
| 06-cloud-flare-redos/original | 107 | 374.26 ± 0.6% | not timed | not timed | 179.95 ± 3.2% | 20.66 ± 1.4% | not timed | not timed | 376.71 ± 0.6% | | 0.99 | 2.08 | 18.12 |
| 06-cloud-flare-redos/simplified-short | 102 | 346.09 ± 1.6% | not timed | not timed | 188.44 ± 1.3% | 21.75 ± 2.1% | not timed | not timed | 343.04 ± 1.9% | | 1.01 | 1.84 | 15.91 |
| 06-cloud-flare-redos/simplified-long | 10000 | 508.65 ± 0.9% | not timed | not timed | 182.18 ± 7.0% | 23.53 ± 17.3% | not timed | not timed | 507.06 ± 0.5% | | 1.00 | 2.79 | 21.61 |
| 07-unicode-character-data/parse-line | 558784 | 187.58 ± 2.8% | not timed | not timed | 161.14 ± 0.7% | 36.27 ± 7.7% | not timed | not timed | 189.77 ± 4.3% | | 0.99 | 1.16 | 5.17 |
| 08-words/all-english | 56691 | 106.35 ± 2.4% | not timed | not timed | 71.55 ± 0.2% | 11.19 ± 11.7% | not timed | not timed | 107.05 ± 4.4% | | 0.99 | 1.49 | 9.50 |
| 08-words/long-english | 839 | 538.00 ± 1.2% | not timed | not timed | 513.85 ± 0.2% | 24.60 ± 13.1% | not timed | not timed | 535.65 ± 0.4% | | 1.00 | 1.05 | 21.87 |
| 09-aws-keys/full | 0 | 431.86 ± 0.7% | not timed | not timed | 439.79 ± 0.9% | 52.69 ± 5.3% | not timed | not timed | 431.34 ± 2.2% | | 1.00 | 0.98 | 8.20 |
| 09-aws-keys/quick | 0 | 923.01 ± 2.4% | not timed | not timed | 750.49 ± 1.0% | 325.75 ± 17.1% | not timed | not timed | 919.97 ± 3.2% | | 1.00 | 1.23 | 2.83 |
| 10-bounded-repeat/letters-en | 1833 | 479.04 ± 2.0% | not timed | not timed | 429.92 ± 1.8% | 15.93 ± 12.4% | not timed | not timed | 476.34 ± 2.0% | | 1.01 | 1.11 | 30.06 |
| 10-bounded-repeat/letters-ru | 3475 | 427.78 ± 8.4% | not timed | not timed | 406.13 ± 0.3% | 17.47 ± 13.7% | not timed | not timed | 428.75 ± 1.9% | | 1.00 | 1.05 | 24.49 |
| 10-bounded-repeat/context | 53 | 68.07 ± 3.5% | not timed | not timed | 55.43 ± 0.9% | 16.13 ± 4.2% | not timed | not timed | 69.38 ± 2.6% | | 0.98 | 1.23 | 4.22 |
| 10-bounded-repeat/capitals | 11 | 555.18 ± 9.5% | not timed | not timed | 532.36 ± 0.3% | 28.73 ± 2.7% | not timed | not timed | 550.94 ± 9.6% | | 1.01 | 1.04 | 19.33 |
| 11-unstructured-to-json/extract | 600 | 35.78 ± 4.5% | not timed | not timed | 62.23 ± 1.2% | 40.34 ± 7.5% | not timed | not timed | 35.83 ± 4.1% | | 1.00 | 0.57 | 0.89 |
| 12-dictionary/single | 1 | 458.88 ± 1.6% | not timed | not timed | 439.64 ± 0.4% | 0.31 ± 0.9% | not timed | not timed | 462.22 ± 2.6% | | 0.99 | 1.04 | 1494.16 |
| 14-quadratic/1x | 100 | 20.52 ± 7.1% | not timed | not timed | 9.01 ± 0.9% | 0.77 ± 7.3% | not timed | not timed | 20.61 ± 3.4% | | 1.00 | 2.28 | 26.81 |
| 14-quadratic/2x | 200 | 18.91 ± 3.3% | not timed | not timed | 4.90 ± 0.9% | 0.41 ± 5.0% | not timed | not timed | 18.73 ± 4.1% | | 1.01 | 3.86 | 46.19 |
| 14-quadratic/10x | 1000 | 11.33 ± 2.8% | not timed | not timed | 1.05 ± 1.0% | 0.09 ± 4.6% | not timed | not timed | 11.21 ± 11.5% | | 1.01 | 10.78 | 129.49 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.03 ± 1.7% | not timed | not timed | 0.38 ± 0.9% | 0.47 ± 5.7% | not timed | not timed | 1.03 ± 0.6% | | 1.00 | 2.75 | 2.18 |
| 04-ruff-noqa/compile-real | 1 | 95.04 ± 1.3% | not timed | not timed | 12.66 ± 2.1% | 119.67 ± 3.7% | not timed | not timed | 95.31 ± 0.4% | | 1.00 | 7.51 | 0.79 |
| 05-lexer-veryl/compile-single | 1 | 12.17 ± 1.4% | not timed | not timed | 2.33 ± 1.3% | 5.81 ± 3.3% | not timed | not timed | 12.23 ± 1.0% | | 0.99 | 5.23 | 2.09 |
| 07-unicode-character-data/compile | 1 | 97.65 ± 0.3% | not timed | not timed | 23.91 ± 0.4% | 31.49 ± 5.6% | not timed | not timed | 97.93 ± 1.2% | | 1.00 | 4.08 | 3.10 |
| 09-aws-keys/compile-full | 1 | 42.59 ± 1.1% | not timed | not timed | 7.28 ± 2.8% | 19.94 ± 1.7% | not timed | not timed | 42.77 ± 5.7% | | 1.00 | 5.85 | 2.14 |
| 09-aws-keys/compile-quick | 1 | 150.61 ± 1.1% | not timed | not timed | 44.29 ± 29.4% | 117.11 ± 4.0% | not timed | not timed | 150.48 ± 3.4% | | 1.00 | 3.40 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 48.05 ± 3.5% | not timed | not timed | 11.28 ± 1.1% | 14.77 ± 5.5% | not timed | not timed | 49.28 ± 0.5% | | 0.97 | 4.26 | 3.25 |
| 10-bounded-repeat/compile-capitals | 1 | 70.95 ± 2.9% | not timed | not timed | 8.61 ± 1.0% | 21.58 ± 1.4% | not timed | not timed | 71.15 ± 3.1% | | 1.00 | 8.24 | 3.29 |
| 11-unstructured-to-json/compile | 1 | 145.31 ± 20.9% | not timed | not timed | 36.30 ± 3.8% | 58.88 ± 3.5% | not timed | not timed | 145.88 ± 0.7% | | 1.00 | 4.00 | 2.47 |
| 12-dictionary/compile-single | 1 | 0.27 ± 3.2% | not timed | not timed | 0.07 ± 2.0% | 0.08 ± 20.3% | not timed | not timed | 0.27 ± 2.5% | | 1.00 | 4.03 | 3.40 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.14 ± 20.0% | not timed | not timed | 5.58 ± 20.8% | 0.53 ± 9.4% | not timed | not timed | 5.19 ± 0.8% | | 0.99 | 0.92 | 9.76 |
| dictionary/search/english-10 | 690 | 166.49 ± 1.5% | not timed | not timed | 108.73 ± 0.4% | 0.00 ± 2.4% | not timed | not timed | 164.81 ± 2.6% | | 1.01 | 1.53 | 35771.57 |
| dictionary/search/english-15 | 15 | 460.79 ± 2.4% | not timed | not timed | 442.60 ± 0.2% | 0.29 ± 3.1% | not timed | not timed | 463.63 ± 2.0% | | 0.99 | 1.04 | 1611.03 |
| folly/awyer-inn-busted | 1 | 18868.42 ± 16.1% | not timed | not timed | 111.81 ± 0.4% | 34.06 ± 5.6% | not timed | not timed | 18861.33 ± 0.5% | | 1.00 | 168.75 | 553.93 |
| folly/literal-never-match-rare | 0 | 54057.15 ± 11.8% | not timed | not timed | 39937.87 ± 2.4% | 53725.13 ± 2.5% | not timed | not timed | 54202.01 ± 1.5% | | 1.00 | 1.35 | 1.01 |
| folly/literal-never-match-frequent | 0 | 18846.12 ± 0.7% | not timed | not timed | 39587.84 ± 0.3% | 2084.21 ± 0.2% | not timed | not timed | 18853.13 ± 0.7% | | 1.00 | 0.48 | 9.04 |
| folly/literal-never-match-tricksy | 1 | 3231.26 ± 5.8% | not timed | not timed | 4437.53 ± 1.9% | 1493.91 ± 1.3% | not timed | not timed | 3238.13 ± 1.6% | | 1.00 | 0.73 | 2.16 |
| grep/every-line | 239963 | 1187.57 ± 1.8% | not timed | not timed | 744.99 ± 5.0% | 263.14 ± 28.4% | not timed | not timed | 1177.11 ± 2.5% | | 1.01 | 1.59 | 4.51 |
| grep/long-words-ascii | 5073 | 422.68 ± 2.3% | not timed | not timed | 407.84 ± 0.8% | 36.64 ± 7.5% | not timed | not timed | 426.82 ± 2.9% | | 0.99 | 1.04 | 11.54 |
| imported/leipzig/twain | 811 | 40555.17 ± 12.8% | not timed | not timed | 36104.24 ± 11.7% | 10012.31 ± 21.7% | not timed | not timed | 42152.65 ± 12.4% | | 0.96 | 1.12 | 4.05 |
| imported/leipzig/twain-insensitive | 965 | 12582.85 ± 2.1% | not timed | not timed | 11125.82 ± 1.5% | 33.19 ± 1.8% | not timed | not timed | 12607.89 ± 1.6% | | 1.00 | 1.13 | 379.09 |
| imported/leipzig/shing | 1540 | 21251.52 ± 6.7% | not timed | not timed | 17914.13 ± 14.8% | 28.59 ± 1.3% | not timed | not timed | 20680.10 ± 9.5% | | 1.03 | 1.19 | 743.39 |
| imported/leipzig/huck-saw | 262 | 20136.18 ± 9.4% | not timed | not timed | 15160.04 ± 21.3% | 26.31 ± 1.8% | not timed | not timed | 20110.26 ± 15.7% | | 1.00 | 1.33 | 765.31 |
| imported/leipzig/word-ending-nn | 262 | 529.53 ± 1.9% | not timed | not timed | 531.95 ± 0.1% | 19.98 ± 0.8% | not timed | not timed | 531.69 ± 0.2% | | 1.00 | 1.00 | 26.50 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 8152.48 ± 1.4% | not timed | not timed | 2838.13 ± 6.0% | 9.39 ± 2.6% | not timed | not timed | 8044.52 ± 13.5% | | 1.01 | 2.87 | 867.89 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 12183.70 ± 25.3% | not timed | not timed | 11365.22 ± 10.3% | 14.92 ± 2.4% | not timed | not timed | 11855.30 ± 30.2% | | 1.03 | 1.07 | 816.71 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4863.83 ± 1.5% | not timed | not timed | 698.83 ± 1.3% | 9.41 ± 0.8% | not timed | not timed | 4870.63 ± 2.9% | | 1.00 | 6.96 | 516.70 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 9952.27 ± 12.1% | not timed | not timed | 528.91 ± 0.8% | 9.79 ± 1.5% | not timed | not timed | 10354.54 ± 17.8% | | 0.96 | 18.82 | 1016.86 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 10297.27 ± 12.1% | not timed | not timed | 529.70 ± 1.4% | 8.37 ± 1.2% | not timed | not timed | 10624.72 ± 32.1% | | 0.97 | 19.44 | 1230.90 |
| imported/leipzig/tom-river | 2 | 9311.54 ± 7.8% | not timed | not timed | 9562.20 ± 11.1% | 26.46 ± 6.6% | not timed | not timed | 9119.38 ± 4.6% | | 1.02 | 0.97 | 351.90 |
| imported/leipzig/ing | 78424 | 521.40 ± 3.0% | not timed | not timed | 491.44 ± 0.3% | 23.67 ± 6.9% | not timed | not timed | 517.97 ± 1.4% | | 1.01 | 1.06 | 22.03 |
| imported/leipzig/ing-whitespace | 55248 | 1530.53 ± 7.0% | not timed | not timed | 1673.21 ± 0.4% | 17.43 ± 4.7% | not timed | not timed | 1531.63 ± 0.4% | | 1.00 | 0.91 | 87.80 |
| imported/leipzig/awyer-inn | 209 | 8702.14 ± 6.5% | not timed | not timed | 10555.14 ± 8.7% | 18.76 ± 6.8% | not timed | not timed | 8539.63 ± 18.6% | | 1.02 | 0.82 | 463.77 |
| imported/leipzig/quotes-bounded | 8886 | 2005.77 ± 1.4% | not timed | not timed | 2782.10 ± 1.5% | 30.16 ± 4.9% | not timed | not timed | 2011.12 ± 1.5% | | 1.00 | 0.72 | 66.51 |
| imported/leipzig/non-ascii-alternate | 2 | 14633.70 ± 12.3% | not timed | not timed | 10766.28 ± 5.7% | 41.02 ± 3.1% | not timed | not timed | 14234.64 ± 19.5% | | 1.03 | 1.36 | 356.73 |
| imported/leipzig/math-symbols | 69 | 2092.74 ± 1.3% | not timed | not timed | 529.93 ± 0.7% | 29.95 ± 1.9% | not timed | not timed | 2074.38 ± 2.8% | | 1.01 | 3.95 | 69.88 |
| imported/leipzig/bounded-strings-ending-z | 0 | 533.65 ± 0.7% | not timed | not timed | 532.42 ± 0.2% | 19.72 ± 2.0% | not timed | not timed | 532.76 ± 1.3% | | 1.00 | 1.00 | 27.07 |
| imported/lh3lh3-reb/uri | 17549 | 656.31 ± 1.9% | not timed | not timed | 860.39 ± 5.1% | 23.20 ± 3.4% | not timed | not timed | 654.70 ± 12.2% | | 1.00 | 0.76 | 28.29 |
| imported/lh3lh3-reb/email | 15057 | 652.83 ± 4.7% | not timed | not timed | 884.53 ± 1.7% | 25.04 ± 2.5% | not timed | not timed | 648.56 ± 4.3% | | 1.01 | 0.74 | 26.07 |
| imported/lh3lh3-reb/date | 668 | 781.54 ± 2.2% | not timed | not timed | 772.72 ± 1.0% | 41.76 ± 5.4% | not timed | not timed | 781.95 ± 1.6% | | 1.00 | 1.01 | 18.72 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 604.22 ± 2.2% | not timed | not timed | 362.38 ± 1.5% | 12.60 ± 2.7% | not timed | not timed | 600.45 ± 4.3% | | 1.01 | 1.67 | 47.97 |
| imported/mariomka/email | 92 | 26997.30 ± 7.0% | not timed | not timed | 41241.01 ± 3.9% | 27.03 ± 2.3% | not timed | not timed | 28091.99 ± 5.2% | | 0.96 | 0.65 | 998.70 |
| imported/mariomka/uri | 5301 | 4297.09 ± 4.4% | not timed | not timed | 5227.25 ± 5.3% | 26.49 ± 9.5% | not timed | not timed | 4412.13 ± 3.9% | | 0.97 | 0.82 | 162.23 |
| imported/mariomka/ip | 5 | 2125.54 ± 3.6% | not timed | not timed | 1985.66 ± 3.1% | 17.21 ± 7.7% | not timed | not timed | 2120.92 ± 14.4% | | 1.00 | 1.07 | 123.51 |
| imported/rsc/no-exponential | 0 | 667.66 ± 2.5% | not timed | not timed | 332.02 ± 1.3% | 19.61 ± 1.8% | not timed | not timed | 675.47 ± 3.4% | | 0.99 | 2.01 | 34.04 |
| imported/rsc/literal | 1 | 1362.83 ± 16.3% | not timed | not timed | 1760.53 ± 0.4% | 182.13 ± 18.8% | not timed | not timed | 1482.42 ± 14.6% | | 0.92 | 0.77 | 7.48 |
| imported/rsc/not-literal | 2 | 686.94 ± 1.5% | not timed | not timed | 713.77 ± 2.1% | 40.70 ± 2.1% | not timed | not timed | 690.49 ± 13.4% | | 0.99 | 0.96 | 16.88 |
| imported/rsc/match-class | 1 | 1436.91 ± 3.0% | not timed | not timed | 1497.74 ± 1.9% | 48.13 ± 1.2% | not timed | not timed | 1427.54 ± 2.3% | | 1.01 | 0.96 | 29.85 |
| imported/rsc/match-class-in-range | 1 | 1437.63 ± 2.7% | not timed | not timed | 2689.78 ± 2.1% | 48.49 ± 17.9% | not timed | not timed | 1400.96 ± 17.5% | | 1.03 | 0.53 | 29.65 |
| imported/rsc/match-class-unicode | 1 | 480.58 ± 11.3% | not timed | not timed | 451.48 ± 0.4% | 58.23 ± 3.4% | not timed | not timed | 475.31 ± 2.2% | | 1.01 | 1.06 | 8.25 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1172.91 ± 2.8% | not timed | not timed | 892.97 ± 1.8% | 264.56 ± 2.1% | not timed | not timed | 1179.99 ± 4.3% | | 0.99 | 1.31 | 4.43 |
| imported/rsc/anchored-literal-long-non-match | 0 | 17799.67 ± 4.1% | not timed | not timed | 13248.42 ± 2.0% | 3880.65 ± 5.2% | not timed | not timed | 17731.58 ± 4.0% | | 1.00 | 1.34 | 4.59 |
| imported/rsc/anchored-literal-short-match | 4 | 595.63 ± 12.3% | not timed | not timed | 486.82 ± 3.5% | 75.84 ± 19.3% | not timed | not timed | 580.64 ± 48.1% | | 1.03 | 1.22 | 7.85 |
| imported/rsc/anchored-literal-long-match | 4 | 8923.33 ± 21.1% | not timed | not timed | 7094.44 ± 17.8% | 1123.65 ± 8.1% | not timed | not timed | 9122.16 ± 9.4% | | 0.98 | 1.26 | 7.94 |
| imported/rsc/one-pass-short | 17 | 310.73 ± 4.4% | not timed | not timed | 216.84 ± 2.9% | 26.19 ± 11.2% | not timed | not timed | 310.31 ± 5.4% | | 1.00 | 1.43 | 11.86 |
| imported/rsc/one-pass-short-not | 17 | 239.66 ± 3.4% | not timed | not timed | 226.67 ± 4.4% | 24.66 ± 59.6% | not timed | not timed | 239.23 ± 5.7% | | 1.00 | 1.06 | 9.72 |
| imported/rsc/one-pass-long-prefix | 26 | 334.80 ± 8.4% | not timed | not timed | 279.03 ± 0.3% | 85.12 ± 13.6% | not timed | not timed | 333.64 ± 2.7% | | 1.00 | 1.20 | 3.93 |
| imported/rsc/one-pass-long-prefix-not | 26 | 333.10 ± 10.4% | not timed | not timed | 272.88 ± 2.4% | 65.95 ± 20.4% | not timed | not timed | 336.60 ± 1.2% | | 0.99 | 1.22 | 5.05 |
| imported/rsc/long-needle1 | 31 | 54706.34 ± 4.3% | not timed | not timed | 39475.83 ± 2.7% | 3.18 ± 4.2% | not timed | not timed | 54316.89 ± 3.0% | | 1.01 | 1.39 | 17185.79 |
| imported/rsc/long-needle2 | 31 | 54900.34 ± 1.8% | not timed | not timed | 167.20 ± 1.2% | 3.21 ± 1.9% | not timed | not timed | 54830.69 ± 1.9% | | 1.00 | 328.36 | 17111.62 |
| imported/rsc/easy0-32 | 26 | 1542.10 ± 3.1% | not timed | not timed | 1482.65 ± 3.2% | 122.70 ± 18.9% | not timed | not timed | 1538.00 ± 2.4% | | 1.00 | 1.04 | 12.57 |
| imported/rsc/easy0-1k | 26 | 12783.07 ± 4.1% | not timed | not timed | 15698.95 ± 3.2% | 1758.37 ± 10.5% | not timed | not timed | 12765.41 ± 2.9% | | 1.00 | 0.81 | 7.27 |
| imported/rsc/easy0-32k | 26 | 50997.89 ± 2.6% | not timed | not timed | 37797.28 ± 2.9% | 20046.06 ± 40.4% | not timed | not timed | 51012.62 ± 4.1% | | 1.00 | 1.35 | 2.54 |
| imported/rsc/easy0-1mb | 26 | 53572.83 ± 2.4% | not timed | not timed | 39521.23 ± 3.0% | 55473.14 ± 4.4% | not timed | not timed | 52985.67 ± 3.9% | | 1.01 | 1.36 | 0.97 |
| imported/rsc/easy1-32 | 19 | 725.19 ± 2.6% | not timed | not timed | 643.47 ± 3.1% | 113.14 ± 20.2% | not timed | not timed | 747.21 ± 4.9% | | 0.97 | 1.13 | 6.41 |
| imported/rsc/easy1-1k | 19 | 14941.83 ± 2.5% | not timed | not timed | 13325.21 ± 2.3% | 1811.29 ± 13.8% | not timed | not timed | 15327.81 ± 1.8% | | 0.97 | 1.12 | 8.25 |
| imported/rsc/easy1-32k | 19 | 465686.96 ± 3.5% | not timed | not timed | 410320.12 ± 2.7% | 22197.92 ± 17.2% | not timed | not timed | 477575.84 ± 1.4% | | 0.98 | 1.13 | 20.98 |
| imported/rsc/easy1-1mb | 19 | 15191582.19 ± 1.0% | not timed | not timed | 13227483.46 ± 2.2% | 53905.28 ± 3.2% | not timed | not timed | 15361996.45 ± 2.4% | | 0.99 | 1.15 | 281.82 |
| imported/rsc/medium-32 | 27 | 702.71 ± 2.0% | not timed | not timed | 610.90 ± 2.1% | 56.21 ± 13.5% | not timed | not timed | 701.37 ± 3.8% | | 1.00 | 1.15 | 12.50 |
| imported/rsc/medium-1k | 27 | 12320.01 ± 2.1% | not timed | not timed | 11004.61 ± 1.3% | 57.88 ± 4.1% | not timed | not timed | 12263.70 ± 1.0% | | 1.00 | 1.12 | 212.85 |
| imported/rsc/medium-32k | 27 | 396445.28 ± 0.6% | not timed | not timed | 347292.29 ± 1.8% | 39.03 ± 1.8% | not timed | not timed | 395299.81 ± 1.1% | | 1.00 | 1.14 | 10156.92 |
| imported/rsc/medium-1mb | 27 | 12611570.20 ± 0.7% | not timed | not timed | 11117397.23 ± 0.6% | 39.68 ± 2.6% | not timed | not timed | 12475458.18 ± 27.5% | | 1.01 | 1.13 | 317833.79 |
| imported/rsc/hard-32 | 58 | 366.33 ± 0.6% | not timed | not timed | 341.17 ± 1.7% | 40.56 ± 16.5% | not timed | not timed | 329.08 ± 4.2% | | 1.11 | 1.07 | 9.03 |
| imported/rsc/hard-1k | 27 | 11449.05 ± 14.2% | not timed | not timed | 11093.67 ± 0.7% | 32.50 ± 2.1% | not timed | not timed | 10069.91 ± 3.0% | | 1.14 | 1.03 | 352.28 |
| imported/rsc/hard-32k | 27 | 358407.29 ± 0.3% | not timed | not timed | 349478.50 ± 0.6% | 24.67 ± 2.8% | not timed | not timed | 315238.81 ± 2.4% | | 1.14 | 1.03 | 14530.59 |
| imported/rsc/hard-1mb | 51 | 7236036.15 ± 1.4% | not timed | not timed | 6807485.58 ± 1.2% | 24.78 ± 3.5% | not timed | not timed | 6575111.61 ± 1.2% | | 1.10 | 1.06 | 291953.14 |
| imported/rsc/reallyhard0-32 | 58 | 242.12 ± 0.8% | not timed | not timed | 212.60 ± 0.7% | 39.78 ± 8.7% | not timed | not timed | 237.22 ± 2.7% | | 1.02 | 1.14 | 6.09 |
| imported/rsc/reallyhard0-1k | 27 | 510.38 ± 1.7% | not timed | not timed | 511.66 ± 0.2% | 32.26 ± 8.7% | not timed | not timed | 513.09 ± 1.4% | | 0.99 | 1.00 | 15.82 |
| imported/rsc/reallyhard0-32k | 27 | 521.81 ± 1.6% | not timed | not timed | 531.59 ± 1.0% | 24.63 ± 8.3% | not timed | not timed | 523.45 ± 1.0% | | 1.00 | 0.98 | 21.19 |
| imported/rsc/reallyhard0-1mb | 51 | 530.35 ± 3.0% | not timed | not timed | 526.95 ± 1.4% | 24.54 ± 3.0% | not timed | not timed | 529.64 ± 2.3% | | 1.00 | 1.01 | 21.61 |
| imported/rsc/reallyreallyhard0-32 | 47 | 261.48 ± 2.4% | not timed | not timed | 183.92 ± 1.8% | 49.01 ± 31.5% | not timed | not timed | 259.97 ± 2.4% | | 1.01 | 1.42 | 5.33 |
| imported/rsc/reallyreallyhard0-1k | 16 | 5919.51 ± 17.1% | not timed | not timed | 6313.56 ± 0.5% | 26.92 ± 4.3% | not timed | not timed | 5932.08 ± 1.9% | | 1.00 | 0.94 | 219.90 |
| imported/rsc/reallyreallyhard0-32k | 16 | 43568.54 ± 1.2% | not timed | not timed | 32415.44 ± 1.7% | 19.86 ± 2.1% | not timed | not timed | 43191.53 ± 2.2% | | 1.01 | 1.34 | 2193.25 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 53688.80 ± 5.6% | not timed | not timed | 39320.14 ± 1.9% | 20.43 ± 2.2% | not timed | not timed | 54128.82 ± 2.2% | | 0.99 | 1.37 | 2627.93 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 249.17 ± 4.0% | not timed | not timed | 190.46 ± 1.4% | 50.01 ± 10.8% | not timed | not timed | 254.74 ± 3.6% | | 0.98 | 1.31 | 4.98 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5207.58 ± 1.7% | not timed | not timed | 6566.07 ± 3.6% | 26.97 ± 2.1% | not timed | not timed | 5216.52 ± 2.8% | | 1.00 | 0.79 | 193.07 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 40752.56 ± 0.8% | not timed | not timed | 32838.52 ± 1.7% | 20.00 ± 3.1% | not timed | not timed | 40896.10 ± 0.4% | | 1.00 | 1.24 | 2037.69 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 52383.08 ± 3.6% | not timed | not timed | 39232.26 ± 1.9% | 20.66 ± 1.6% | not timed | not timed | 52760.18 ± 2.9% | | 0.99 | 1.34 | 2535.15 |
| imported/sherlock/name-sherlock | 776 | 35091.40 ± 2.5% | not timed | not timed | 31434.45 ± 1.5% | 9425.24 ± 25.9% | not timed | not timed | 35132.48 ± 2.9% | | 1.00 | 1.12 | 3.72 |
| imported/sherlock/name-holmes | 2766 | 16041.90 ± 4.2% | not timed | not timed | 18345.51 ± 1.2% | 2897.23 ± 3.0% | not timed | not timed | 15955.46 ± 7.2% | | 1.01 | 0.87 | 5.54 |
| imported/sherlock/name-sherlock-holmes | 1365 | 35275.90 ± 9.1% | not timed | not timed | 31795.47 ± 0.9% | 7362.92 ± 11.2% | not timed | not timed | 35613.23 ± 11.3% | | 0.99 | 1.11 | 4.79 |
| imported/sherlock/name-sherlock-casei | 816 | 29074.42 ± 4.7% | not timed | not timed | 9194.22 ± 5.5% | 27.01 ± 4.6% | not timed | not timed | 29379.98 ± 3.1% | | 0.99 | 3.16 | 1076.47 |
| imported/sherlock/name-holmes-casei | 2802 | 14219.94 ± 6.9% | not timed | not timed | 5759.12 ± 2.7% | 33.24 ± 6.4% | not timed | not timed | 14395.60 ± 4.1% | | 0.99 | 2.47 | 427.82 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 26106.44 ± 21.1% | not timed | not timed | 8994.55 ± 8.5% | 27.27 ± 36.7% | not timed | not timed | 26373.88 ± 2.4% | | 0.99 | 2.90 | 957.28 |
| imported/sherlock/name-whitespace | 1461 | 21359.16 ± 4.2% | not timed | not timed | 22303.32 ± 2.3% | 5849.74 ± 18.0% | not timed | not timed | 21295.90 ± 0.6% | | 1.00 | 0.96 | 3.65 |
| imported/sherlock/name-alt1 | 1142 | 20633.40 ± 1.5% | not timed | not timed | 23158.63 ± 5.3% | 3709.92 ± 19.2% | not timed | not timed | 20469.81 ± 2.8% | | 1.01 | 0.89 | 5.56 |
| imported/sherlock/name-alt2 | 3542 | 12361.48 ± 1.5% | not timed | not timed | 7708.52 ± 0.3% | 25.93 ± 1.8% | not timed | not timed | 12342.19 ± 1.1% | | 1.00 | 1.60 | 476.69 |
| imported/sherlock/name-alt3 | 4507 | 8503.29 ± 2.4% | not timed | not timed | 6869.70 ± 1.5% | 8.27 ± 2.3% | not timed | not timed | 8461.65 ± 0.6% | | 1.00 | 1.24 | 1027.93 |
| imported/sherlock/name-alt3-casei | 4593 | 1591.20 ± 0.9% | not timed | not timed | 1062.94 ± 1.1% | 5.58 ± 0.8% | not timed | not timed | 1584.74 ± 1.1% | | 1.00 | 1.50 | 285.12 |
| imported/sherlock/name-alt4 | 3686 | 7228.79 ± 1.7% | not timed | not timed | 5949.01 ± 2.2% | 25.85 ± 1.5% | not timed | not timed | 7200.76 ± 2.4% | | 1.00 | 1.22 | 279.65 |
| imported/sherlock/name-alt4-casei | 4254 | 3184.36 ± 1.2% | not timed | not timed | 3131.70 ± 0.6% | 16.56 ± 1.5% | not timed | not timed | 3198.83 ± 0.9% | | 1.00 | 1.02 | 192.25 |
| imported/sherlock/name-alt5 | 4028 | 10407.19 ± 0.9% | not timed | not timed | 7332.31 ± 5.7% | 18.41 ± 15.8% | not timed | not timed | 10446.81 ± 2.8% | | 1.00 | 1.42 | 565.23 |
| imported/sherlock/name-alt5-casei | 4104 | 4828.04 ± 2.9% | not timed | not timed | 2375.50 ± 1.2% | 11.72 ± 3.4% | not timed | not timed | 4647.29 ± 11.3% | | 1.04 | 2.03 | 411.77 |
| imported/sherlock/no-match-uncommon | 0 | 53747.22 ± 12.4% | not timed | not timed | 49276.22 ± 1.3% | 45281.07 ± 0.8% | not timed | not timed | 53523.20 ± 23.2% | | 1.00 | 1.09 | 1.19 |
| imported/sherlock/no-match-common | 0 | 52276.44 ± 14.3% | not timed | not timed | 49322.06 ± 1.0% | 1578.69 ± 0.4% | not timed | not timed | 52472.50 ± 1.9% | | 1.00 | 1.06 | 33.11 |
| imported/sherlock/no-match-really-common | 0 | 33176.79 ± 1.2% | not timed | not timed | 30567.61 ± 0.9% | 1575.68 ± 15.3% | not timed | not timed | 32867.43 ± 10.0% | | 1.01 | 1.09 | 21.06 |
| imported/sherlock/the-lower | 21654 | 2054.97 ± 0.7% | not timed | not timed | 2184.34 ± 1.3% | 221.75 ± 15.4% | not timed | not timed | 2059.26 ± 5.4% | | 1.00 | 0.94 | 9.27 |
| imported/sherlock/the-upper | 2223 | 11583.90 ± 0.7% | not timed | not timed | 18727.52 ± 1.3% | 2448.42 ± 6.2% | not timed | not timed | 11661.73 ± 1.4% | | 0.99 | 0.62 | 4.73 |
| imported/sherlock/the-casei | 23961 | 1912.70 ± 2.1% | not timed | not timed | 1119.22 ± 0.5% | 29.38 ± 26.4% | not timed | not timed | 1920.04 ± 6.9% | | 1.00 | 1.71 | 65.11 |
| imported/sherlock/everything-greedy | 581881 | 240.37 ± 0.8% | not timed | not timed | 143.49 ± 0.6% | 21.88 ± 26.6% | not timed | not timed | 239.11 ± 2.0% | | 1.01 | 1.68 | 10.99 |
| imported/sherlock/everything-greedy-nl | 594933 | 442.80 ± 1.7% | not timed | not timed | 183.48 ± 2.1% | 24.82 ± 5.2% | not timed | not timed | 442.41 ± 2.4% | | 1.00 | 2.41 | 17.84 |
| imported/sherlock/letters | 447175 | 50.37 ± 9.2% | not timed | not timed | 28.89 ± 2.6% | 4.81 ± 17.9% | not timed | not timed | 50.58 ± 19.5% | | 1.00 | 1.74 | 10.48 |
| imported/sherlock/letters-upper | 14180 | 380.90 ± 1.8% | not timed | not timed | 316.50 ± 0.5% | 23.90 ± 23.7% | not timed | not timed | 380.51 ± 1.0% | | 1.00 | 1.20 | 15.94 |
| imported/sherlock/letters-lower | 432995 | 51.03 ± 6.9% | not timed | not timed | 30.24 ± 14.3% | 5.68 ± 49.7% | not timed | not timed | 52.23 ± 9.8% | | 0.98 | 1.69 | 8.98 |
| imported/sherlock/words | 447639 | 93.78 ± 2.3% | not timed | not timed | 72.17 ± 0.4% | 11.64 ± 13.7% | not timed | not timed | 94.66 ± 1.7% | | 0.99 | 1.30 | 8.06 |
| imported/sherlock/before-holmes | 4073 | 9572.35 ± 2.1% | not timed | not timed | 9694.47 ± 24.6% | 18.29 ± 3.3% | not timed | not timed | 9657.20 ± 2.9% | | 0.99 | 0.99 | 523.39 |
| imported/sherlock/before-after-holmes | 2593 | 9365.77 ± 15.9% | not timed | not timed | 10897.19 ± 3.9% | 18.73 ± 4.3% | not timed | not timed | 9488.49 ± 1.1% | | 0.99 | 0.86 | 500.10 |
| imported/sherlock/holmes-cochar-watson | 150 | 7343.17 ± 1.0% | not timed | not timed | 5917.64 ± 0.6% | 25.58 ± 2.9% | not timed | not timed | 7339.13 ± 1.2% | | 1.00 | 1.24 | 287.08 |
| imported/sherlock/holmes-coword-watson | 14309 | 1108.49 ± 0.3% | not timed | not timed | 1065.05 ± 0.2% | 5.45 ± 2.2% | not timed | not timed | 1115.08 ± 0.7% | | 0.99 | 1.04 | 203.36 |
| imported/sherlock/quotes | 14437 | 1278.33 ± 7.8% | not timed | not timed | 1549.95 ± 7.6% | 26.53 ± 3.4% | not timed | not timed | 1272.16 ± 1.0% | | 1.00 | 0.82 | 48.19 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 25852.31 ± 2.7% | not timed | not timed | 25221.72 ± 1.1% | 30.61 ± 3.0% | not timed | not timed | 25794.85 ± 2.2% | | 1.00 | 1.03 | 844.52 |
| imported/sherlock/word-ending-n | 35297 | 402.07 ± 1.3% | not timed | not timed | 349.04 ± 1.2% | 19.58 ± 16.0% | not timed | not timed | 398.88 ± 1.4% | | 1.01 | 1.15 | 20.53 |
| imported/sherlock/repeated-class-negation | 2130 | 11063.51 ± 4.9% | not timed | not timed | 11702.57 ± 3.7% | 9.19 ± 2.0% | not timed | not timed | 11080.24 ± 17.3% | | 1.00 | 0.95 | 1203.38 |
| imported/sherlock/ing-suffix | 20547 | 482.61 ± 5.1% | not timed | not timed | 443.14 ± 1.4% | 23.83 ± 2.4% | not timed | not timed | 484.65 ± 1.6% | | 1.00 | 1.09 | 20.25 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1315.48 ± 6.5% | not timed | not timed | 1934.82 ± 2.6% | 16.68 ± 54.2% | not timed | not timed | 1318.99 ± 1.3% | | 1.00 | 0.68 | 78.86 |
| opt/accelerate/whole-line | 239963 | 427.72 ± 0.6% | not timed | not timed | 339.17 ± 0.6% | 74.28 ± 20.1% | not timed | not timed | 427.56 ± 1.4% | | 1.00 | 1.26 | 5.76 |
| opt/accelerate/non-dna | 16745 | 384.29 ± 1.0% | not timed | not timed | 366.42 ± 1.2% | 23.66 ± 18.3% | not timed | not timed | 383.91 ± 0.7% | | 1.00 | 1.05 | 16.24 |
| opt/backtrack/words-english | 40536 | 100.73 ± 4.7% | not timed | not timed | 83.83 ± 5.6% | 16.07 ± 5.4% | not timed | not timed | 101.15 ± 6.2% | | 1.00 | 1.20 | 6.27 |
| opt/fixed-length/too-small-ascii | 0 | 270.67 ± 3.5% | not timed | not timed | 597.17 ± 1.4% | 95.36 ± 8.5% | not timed | not timed | 264.94 ± 46.0% | | 1.02 | 0.45 | 2.84 |
| opt/fixed-length/too-big-ascii | 0 | 3198.40 ± 1.9% | not timed | not timed | 4794.85 ± 35.8% | 110.53 ± 2.6% | not timed | not timed | 3227.19 ± 16.8% | | 0.99 | 0.67 | 28.94 |
| opt/fixed-length/go33484-1 | 0 | 618681.66 ± 1.6% | not timed | not timed | 928230.86 ± 2.7% | 64914.56 ± 26.9% | not timed | not timed | 617793.75 ± 29.2% | | 1.00 | 0.67 | 9.53 |
| opt/fixed-length/go33484-2 | 0 | 610686.15 ± 9.9% | not timed | not timed | 922079.33 ± 1.1% | 22886.87 ± 1.6% | not timed | not timed | 614732.77 ± 2.8% | | 0.99 | 0.66 | 26.68 |
| opt/fixed-length/go33484-3 | 0 | 62501.41 ± 3.3% | not timed | not timed | 92701.44 ± 3.7% | 733.66 ± 1.3% | not timed | not timed | 61963.35 ± 2.1% | | 1.01 | 0.67 | 85.19 |
| opt/literal-alt/one-pattern | 1 | 478.29 ± 2.0% | not timed | not timed | 482.16 ± 0.9% | 0.30 ± 2.0% | not timed | not timed | 476.88 ± 6.1% | | 1.00 | 0.99 | 1620.38 |
| opt/onepass/fn-predicate | 916 | 321.43 ± 1.7% | not timed | not timed | 327.73 ± 1.4% | 170.71 ± 35.9% | not timed | not timed | 321.02 ± 1.3% | | 1.00 | 0.98 | 1.88 |
| opt/onepass/first-three-words-english | 35128 | 125.10 ± 9.9% | not timed | not timed | 189.73 ± 1.0% | 55.57 ± 20.4% | not timed | not timed | 124.79 ± 3.2% | | 1.00 | 0.66 | 2.25 |
| opt/prefilter/literal-english | 1 | 52361.69 ± 51.8% | not timed | not timed | 39239.89 ± 69.1% | 19169.66 ± 1.8% | not timed | not timed | 52686.28 ± 20.6% | | 0.99 | 1.33 | 2.73 |
| opt/prefilter/literal-casei-english | 1 | 32370.88 ± 2.7% | not timed | not timed | 11722.38 ± 2.3% | 27.58 ± 2.6% | not timed | not timed | 31979.63 ± 3.0% | | 1.01 | 2.76 | 1173.85 |
| opt/prefilter/literal-russian | 1 | 53285.27 ± 2.9% | not timed | not timed | 39309.75 ± 2.2% | 1567.12 ± 2.7% | not timed | not timed | 52969.61 ± 3.0% | | 1.01 | 1.36 | 34.00 |
| opt/prefilter/literal-casei-russian | 1 | 21733.31 ± 1.2% | not timed | not timed | 8212.79 ± 8.9% | 29.68 ± 1.1% | not timed | not timed | 21760.25 ± 3.1% | | 1.00 | 2.65 | 732.27 |
| opt/prefilter/rust-functions | 948 | 10756.35 ± 8.5% | not timed | not timed | 9681.52 ± 15.0% | 1446.37 ± 28.1% | not timed | not timed | 10943.71 ± 7.5% | | 0.98 | 1.11 | 7.44 |
| opt/reverse-anchored/word-end | 1 | 27661601.27 ± 3.8% | not timed | not timed | 22382180.19 ± 2.4% | 39.79 ± 17.2% | not timed | not timed | 27892380.26 ± 2.8% | | 0.99 | 1.24 | 695165.01 |
| opt/reverse-inner/holmes | 2593 | 9364.19 ± 2.7% | not timed | not timed | 10909.92 ± 4.9% | 19.13 ± 1.4% | not timed | not timed | 9450.49 ± 1.4% | | 0.99 | 0.86 | 489.52 |
| opt/reverse-inner/email | 47 | 58690.48 ± 19.8% | not timed | not timed | 69019.34 ± 1.9% | 25.98 ± 3.0% | not timed | not timed | 61208.21 ± 11.6% | | 0.96 | 0.85 | 2259.28 |
| opt/reverse-inner/factored-prefix | 3542 | 515.17 ± 2.2% | not timed | not timed | 511.42 ± 2.2% | 9.84 ± 0.9% | not timed | not timed | 517.80 ± 1.6% | | 0.99 | 1.01 | 52.34 |
| opt/reverse-inner/no-quadratic-backward | 0 | 17761.83 ± 1.0% | not timed | not timed | 531.25 ± 1.7% | 61.77 ± 4.7% | not timed | not timed | 17658.44 ± 1.7% | | 1.01 | 33.43 | 287.56 |
| opt/reverse-inner/no-quadratic-forward | 0 | 615.54 ± 6.0% | not timed | not timed | 241.70 ± 5.4% | 19.82 ± 4.5% | not timed | not timed | 619.69 ± 6.6% | | 0.99 | 2.55 | 31.05 |
| opt/reverse-suffix/holmes | 4073 | 9474.17 ± 9.8% | not timed | not timed | 9616.70 ± 12.0% | 19.00 ± 1.9% | not timed | not timed | 9435.07 ± 3.6% | | 1.00 | 0.99 | 498.76 |
| opt/reverse-suffix/no-quadratic | 0 | 17774.30 ± 3.5% | not timed | not timed | 532.00 ± 2.1% | 60.24 ± 2.1% | not timed | not timed | 17531.65 ± 5.6% | | 1.01 | 33.41 | 295.05 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 101.28 ± 4.5% | not timed | not timed | 133.25 ± 2.1% | 12.94 ± 15.4% | not timed | not timed | 101.31 ± 25.4% | | 1.00 | 0.76 | 7.83 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 99.55 ± 47.0% | not timed | not timed | 133.51 ± 0.8% | 10.47 ± 22.7% | not timed | not timed | 102.61 ± 2.9% | | 0.97 | 0.75 | 9.51 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.26 ± 1.2% | not timed | not timed | 0.40 ± 0.8% | 83.76 ± 4.3% | not timed | not timed | 0.26 ± 2.3% | | 1.03 | 0.65 | 0.0032 |
| reported/i1095-word-repetition/ascii-search | 256 | 263.97 ± 3.0% | not timed | not timed | 243.78 ± 1.0% | 76.69 ± 1.9% | not timed | not timed | 263.34 ± 0.8% | | 1.00 | 1.08 | 3.44 |
| reported/i13-subset-regex/original-ascii | 4094 | 7864.18 ± 1.9% | not timed | not timed | 2842.46 ± 3.8% | 9.27 ± 2.2% | not timed | not timed | 7952.53 ± 3.9% | | 0.99 | 2.77 | 848.73 |
| reported/i13-subset-regex/original-unicode | 4094 | 7717.59 ± 8.0% | not timed | not timed | 158.84 ± 10.4% | 9.23 ± 3.5% | not timed | not timed | 7820.47 ± 4.1% | | 0.99 | 48.59 | 836.15 |
| reported/i13-subset-regex/big-ascii | 1955 | 7444.26 ± 3.7% | not timed | not timed | 43.46 ± 1.8% | 7.94 ± 1.8% | not timed | not timed | 7562.77 ± 7.2% | | 0.98 | 171.28 | 937.31 |
| reported/i13-subset-regex/big-unicode | 1955 | 7484.90 ± 4.9% | not timed | not timed | 7.73 ± 55.9% | 7.88 ± 1.6% | not timed | not timed | 7437.78 ± 3.2% | | 1.01 | 967.87 | 950.39 |
| reported/i13-subset-regex/huge-ascii | 55 | 6894.38 ± 8.5% | not timed | not timed | 7.06 ± 0.8% | 7.09 ± 3.1% | not timed | not timed | 7053.24 ± 2.9% | | 0.98 | 977.21 | 972.16 |
| reported/i13-subset-regex/huge-unicode | 55 | 7184.42 ± 8.4% | not timed | not timed | 7.13 ± 1.5% | 7.08 ± 1.7% | not timed | not timed | 7086.46 ± 8.2% | | 1.01 | 1007.40 | 1014.25 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.05 ± 1.3% | not timed | not timed | 6.98 ± 1.0% | 7.10 ± 4.1% | not timed | not timed | 3.08 ± 1.3% | | 0.99 | 0.44 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.26 ± 1.3% | not timed | not timed | 7.03 ± 1.1% | 7.05 ± 3.3% | not timed | not timed | 4.28 ± 1.3% | | 0.99 | 0.61 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 400.73 ± 2.0% | not timed | not timed | 117.86 ± 2.3% | 5.17 ± 3.2% | not timed | not timed | 405.10 ± 3.3% | | 0.99 | 3.40 | 77.45 |
| reported/i787-keywords/opt-ascii | 5674 | 411.24 ± 1.6% | not timed | not timed | 210.98 ± 1.6% | 8.78 ± 1.7% | not timed | not timed | 408.41 ± 2.4% | | 1.01 | 1.95 | 46.84 |
| slow/quadratic-regex-1x | 100 | 5.97 ± 3.7% | not timed | not timed | 4.52 ± 1.1% | 0.04 ± 3.3% | not timed | not timed | 6.01 ± 2.6% | | 0.99 | 1.32 | 146.16 |
| slow/quadratic-regex-2x | 199 | 2.84 ± 4.0% | not timed | not timed | 2.47 ± 1.0% | 0.01 ± 1.1% | not timed | not timed | 2.83 ± 2.1% | | 1.00 | 1.15 | 272.70 |
| slow/quadratic-haystack-1x | 100 | 21.50 ± 10.9% | not timed | not timed | 8.97 ± 1.2% | 0.80 ± 19.0% | not timed | not timed | 21.22 ± 10.9% | | 1.01 | 2.40 | 26.75 |
| slow/quadratic-haystack-2x | 200 | 19.68 ± 2.9% | not timed | not timed | 4.89 ± 1.3% | 0.43 ± 2.6% | not timed | not timed | 19.78 ± 1.3% | | 1.00 | 4.03 | 46.03 |
| unicode/codepoints/any-one | 1112064 | 247.87 ± 4.9% | not timed | not timed | 179.93 ± 1.4% | 15.72 ± 20.3% | not timed | not timed | 243.19 ± 4.1% | | 1.02 | 1.38 | 15.77 |
| unicode/codepoints/any-all | 4382592 | 234.21 ± 0.2% | not timed | not timed | 234.95 ± 1.3% | 97.47 ± 2.4% | not timed | not timed | 234.49 ± 0.7% | | 1.00 | 1.00 | 2.40 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.32 ± 2.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 529.22 ± 0.6% | not timed | not timed | 531.82 ± 0.1% | 115.46 ± 3.0% | not timed | not timed | 529.07 ± 1.1% | | 1.00 | 1.00 | 4.58 |
| unicode/overlapping-words/ascii | 6156 | 20.78 ± 15.2% | not timed | not timed | 33.23 ± 6.7% | 3.41 ± 4.7% | not timed | not timed | 20.77 ± 1.9% | | 1.00 | 0.63 | 6.10 |
| unicode/overlapping-words/english | 6156 | 1.13 ± 5.1% | not timed | not timed | 2.40 ± 1.8% | 2.01 ± 7.2% | not timed | not timed | 1.11 ± 2.7% | | 1.02 | 0.47 | 0.56 |
| unicode/overlapping-words/russian | 5710 | 1.04 ± 3.1% | not timed | not timed | 2.35 ± 3.0% | 5.04 ± 7.5% | not timed | not timed | 1.04 ± 2.8% | | 1.00 | 0.44 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 106.74 ± 2.1% | not timed | not timed | 73.96 ± 0.4% | 10.38 ± 20.8% | not timed | not timed | 106.99 ± 7.3% | | 1.00 | 1.44 | 10.29 |
| unicode/word/boundary-long-english | 3466 | 533.09 ± 1.6% | not timed | not timed | 522.10 ± 3.2% | 26.01 ± 2.8% | not timed | not timed | 532.17 ± 0.6% | | 1.00 | 1.02 | 20.50 |
| unicode/word/around-holmes-english | 27 | 40810.57 ± 3.0% | not timed | not timed | 37692.61 ± 3.1% | 18.39 ± 1.0% | not timed | not timed | 41068.16 ± 2.6% | | 0.99 | 1.08 | 2219.33 |
| wild/bibleref/long | 874 | 473.09 ± 1.3% | not timed | not timed | 487.55 ± 0.4% | 6.37 ± 15.6% | not timed | not timed | 472.70 ± 0.9% | | 1.00 | 0.97 | 74.32 |
| wild/bibleref/short | 30 | 15.29 ± 14.2% | not timed | not timed | 26.67 ± 0.6% | 12.96 ± 23.3% | not timed | not timed | 16.59 ± 10.1% | | 0.92 | 0.57 | 1.18 |
| wild/bibleref/line | 874 | 384.45 ± 0.9% | not timed | not timed | 210.28 ± 6.0% | 7.56 ± 0.9% | not timed | not timed | 384.60 ± 1.8% | | 1.00 | 1.83 | 50.88 |
| wild/caddy/caddy | 6 | 329.95 ± 13.3% | not timed | not timed | 239.03 ± 0.7% | 61.07 ± 17.3% | not timed | not timed | 336.25 ± 2.8% | | 0.98 | 1.38 | 5.40 |
| wild/dot-star-capture/rust-src-tools | 6 | 1269.96 ± 1.4% | not timed | not timed | 352.05 ± 0.6% | 11.31 ± 0.8% | not timed | not timed | 1261.54 ± 1.1% | | 1.01 | 3.61 | 112.28 |
| wild/ruff/noqa | 84 | 418.54 ± 0.7% | not timed | not timed | 434.09 ± 1.1% | 15.94 ± 2.6% | not timed | not timed | 418.79 ± 0.7% | | 1.00 | 0.96 | 26.25 |
| wild/ruff/unnecessary-coding-comment | 16 | 864.97 ± 3.3% | not timed | not timed | 581.63 ± 3.2% | 106.68 ± 13.7% | not timed | not timed | 879.86 ± 2.7% | | 0.98 | 1.49 | 8.11 |
| wild/ruff/string-quote-prefix | 2972 | 1274.06 ± 0.9% | not timed | not timed | 316.58 ± 0.9% | 240.90 ± 27.7% | not timed | not timed | 1275.67 ± 2.0% | | 1.00 | 4.02 | 5.29 |
| wild/ruff/space-around-operator | 1224378 | 179.04 ± 2.4% | not timed | not timed | 181.70 ± 4.8% | 15.01 ± 2.9% | not timed | not timed | 182.20 ± 2.4% | | 0.98 | 0.99 | 11.92 |
| wild/ruff/shebang | 282 | 891.29 ± 2.4% | not timed | not timed | 326.45 ± 0.3% | 85.91 ± 9.3% | not timed | not timed | 896.44 ± 1.7% | | 0.99 | 2.73 | 10.37 |
| wild/rustsec-cargo-audit/original-unix | 471 | 15519.75 ± 3.9% | not timed | not timed | 19469.50 ± 4.1% | 6119.14 ± 12.1% | not timed | not timed | 16395.57 ± 1.8% | | 0.95 | 0.80 | 2.54 |
| wild/rustsec-cargo-audit/original-windows | 462 | 13860.15 ± 9.3% | not timed | not timed | 18292.18 ± 4.8% | 5757.49 ± 3.7% | not timed | not timed | 14880.56 ± 3.5% | | 0.93 | 0.76 | 2.41 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 15410.69 ± 4.0% | not timed | not timed | 19007.73 ± 54.7% | 5310.13 ± 8.4% | not timed | not timed | 16126.27 ± 3.7% | | 0.96 | 0.81 | 2.90 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 12917.83 ± 11.4% | not timed | not timed | 18964.66 ± 2.6% | 5748.71 ± 30.1% | not timed | not timed | 13489.70 ± 2.2% | | 0.96 | 0.68 | 2.25 |
| wild/url/search | 234965 | 90.98 ± 21.2% | not timed | not timed | 45.90 ± 10.6% | 1.87 ± 2.0% | not timed | not timed | 88.72 ± 15.6% | | 1.03 | 1.98 | 48.54 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 10.9% | not timed | not timed | 0.01 ± 6.1% | 0.00 ± 16.1% | not timed | not timed | 0.02 ± 35.1% | | 1.00 | 2.62 | 5.32 |
| dictionary/compile/english-15 | 1 | 0.27 ± 15.3% | not timed | not timed | 0.06 ± 5.1% | 0.08 ± 14.0% | not timed | not timed | 0.28 ± 23.0% | | 0.99 | 4.27 | 3.32 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.18 ± 5.2% | not timed | not timed | 0.01 ± 42.9% | 25.75 ± 25.5% | not timed | not timed | 0.18 ± 5.0% | | 1.00 | 12.53 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 34.98 ± 19.5% | not timed | not timed | 13.31 ± 4.9% | 45.17 ± 36.9% | not timed | not timed | 35.14 ± 2.6% | | 1.00 | 2.63 | 0.77 |
| reported/i787-keywords/compile | 1 | 29.93 ± 12.6% | not timed | not timed | 1.91 ± 1.2% | 14.28 ± 28.8% | not timed | not timed | 30.37 ± 2.4% | | 0.99 | 15.70 | 2.10 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 280.77 ± 7.0% | not timed | not timed | 115.54 ± 0.8% | 464.26 ± 12.0% | not timed | not timed | 284.14 ± 6.0% | | 0.99 | 2.43 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 39.00 ± 6.5% | not timed | not timed | 4.19 ± 1.6% | 33.53 ± 28.6% | not timed | not timed | 41.16 ± 15.3% | | 0.95 | 9.30 | 1.16 |
| unicode/compile/one-letter | 53 | 5.40 ± 11.1% | not timed | not timed | 4.48 ± 0.7% | 47.44 ± 12.1% | not timed | not timed | 5.41 ± 7.0% | | 1.00 | 1.21 | 0.11 |
| unicode/compile/fifty-letters | 1 | 0.85 ± 21.8% | not timed | not timed | 0.10 ± 6.8% | 47.57 ± 42.9% | not timed | not timed | 0.87 ± 8.6% | | 0.98 | 8.97 | 0.0179 |
| unicode/compile/fifty-letters-ascii | 1 | 134.38 ± 21.8% | not timed | not timed | 55.88 ± 0.8% | 152.07 ± 3.2% | not timed | not timed | 157.02 ± 17.4% | | 0.86 | 2.40 | 0.88 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 332.24 ± 27.7% | not timed | not timed | 35.62 ± 2.3% | 508.95 ± 20.5% | not timed | not timed | 333.38 ± 6.1% | | 1.00 | 9.33 | 0.65 |
| unicode/compile/match-every-line-ascii | 4 | 496.09 ± 7.6% | not timed | not timed | 130.37 ± 0.4% | 532.67 ± 35.6% | not timed | not timed | 499.26 ± 8.8% | | 0.99 | 3.81 | 0.93 |
| unicode/compile/negated-class-matches-codepoint | 1 | 254.59 ± 8.5% | not timed | not timed | 40.31 ± 8.6% | 1009.85 ± 4.6% | not timed | not timed | 274.30 ± 9.4% | | 0.93 | 6.32 | 0.25 |
| wild/bibleref/compile | 3 | 4.61 ± 6.2% | not timed | not timed | 1.91 ± 1.5% | 23.76 ± 2.9% | not timed | not timed | 4.77 ± 6.2% | | 0.97 | 2.41 | 0.19 |
| wild/url/compile | 1 | 0.52 ± 3.2% | not timed | not timed | 0.15 ± 11.3% | 0.29 ± 23.5% | not timed | not timed | 0.51 ± 6.0% | | 1.01 | 3.53 | 1.76 |

