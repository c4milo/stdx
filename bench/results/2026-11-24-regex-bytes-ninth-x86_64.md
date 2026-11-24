# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391520861 |
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
| literal: a word | 217 | 25161.95 ± 0.1% | 3191.51 ± 0.6% | 25.02 ± 0.6% | 23033.59 ± 0.3% | 8743.29 ± 9.8% | 11.66 ± 0.4% | 82.06 ± 2.4% | 25140.90 ± 0.3% | 7.88 | 1.00 | 1.09 | 2.88 |
| literal: a word that is not there | 0 | 28852.69 ± 0.5% | 3141.27 ± 0.6% | 25.52 ± 0.9% | 25284.31 ± 0.1% | 28807.45 ± 1.1% | 11.39 ± 0.3% | 77.45 ± 1.1% | 28893.42 ± 0.3% | 9.19 | 1.00 | 1.14 | 1.00 |
| literal: one of four words | 661 | 9962.61 ± 2.4% | 1510.00 ± 0.5% | 14.37 ± 1.0% | 7575.39 ± 2.0% | 22.53 ± 0.4% | 3.41 ± 0.3% | 5.89 ± 0.6% | 10017.57 ± 2.2% | 6.60 | 0.99 | 1.32 | 442.27 |
| literal: a word in any case | 217 | 21889.68 ± 1.5% | 1612.89 ± 0.4% | 18.44 ± 1.5% | 7756.30 ± 0.6% | 42.80 ± 1.9% | refused | differs | 21967.10 ± 0.9% | 13.57 | 1.00 | 2.82 | 511.44 |
| literal: an href attribute | 33 | 21684.12 ± 1.9% | 499.73 ± 3.6% | 22.52 ± 1.3% | 20808.36 ± 1.1% | 2010.44 ± 0.8% | 8.35 ± 0.4% | 73.55 ± 1.0% | 21789.69 ± 11.0% | 43.39 | 1.00 | 1.04 | 10.79 |
| literal: a word, second text | 123 | 25191.67 ± 0.6% | 2400.78 ± 0.6% | 25.37 ± 2.2% | 22252.83 ± 1.4% | 6945.96 ± 2.4% | 15.13 ± 0.6% | 71.12 ± 2.3% | 25211.14 ± 0.7% | 10.49 | 1.00 | 1.13 | 3.63 |
| class: two capitalized words | 1331 | 759.65 ± 0.9% | 489.56 ± 1.2% | 24.12 ± 1.1% | 473.27 ± 0.6% | 37.43 ± 1.1% | 9.90 ± 0.8% | 60.56 ± 0.5% | 759.68 ± 0.4% | 1.55 | 1.00 | 1.61 | 20.29 |
| class: a word that ends in ing | 3399 | 465.77 ± 1.0% | 464.45 ± 0.4% | 15.52 ± 1.1% | 444.53 ± 0.5% | 26.52 ± 2.9% | 5.55 ± 0.5% | 16.54 ± 0.9% | 466.41 ± 0.4% | 1.00 | 1.00 | 1.05 | 17.57 |
| class: a word in capitals | 2332 | 1026.58 ± 0.4% | 495.99 ± 0.8% | 25.66 ± 1.0% | 466.41 ± 0.6% | 40.44 ± 14.9% | 11.89 ± 0.6% | 77.02 ± 0.3% | 1026.28 ± 1.1% | 2.07 | 1.00 | 2.20 | 25.38 |
| class: a number | 8288 | 1587.77 ± 0.7% | 671.29 ± 0.2% | 25.13 ± 2.3% | 1632.95 ± 0.7% | 40.74 ± 11.6% | 0.33 ± 0.5% | 56.02 ± 6.7% | 1583.48 ± 1.0% | 2.37 | 1.00 | 0.97 | 38.98 |
| class: two capitalized words, second text | 5359 | 412.82 ± 1.0% | 420.93 ± 0.5% | 21.81 ± 0.9% | 394.99 ± 1.2% | 32.46 ± 12.6% | 12.93 ± 0.7% | 55.27 ± 0.8% | 413.90 ± 0.3% | 0.98 | 1.00 | 1.05 | 12.72 |
| other: a word between two words | 6104 | 678.33 ± 0.5% | 476.48 ± 0.5% | 21.35 ± 1.2% | 667.92 ± 0.8% | 103.87 ± 11.0% | 7.57 ± 0.4% | 63.91 ± 0.7% | 680.41 ± 0.6% | 1.42 | 1.00 | 1.02 | 6.53 |
| other: a number before a unit, second text | 1481 | 6662.62 ± 0.9% | 889.07 ± 0.6% | 24.63 ± 2.2% | 6914.38 ± 1.2% | 38.24 ± 0.9% | 13.55 ± 0.5% | 58.31 ± 1.4% | 6761.97 ± 2.8% | 7.49 | 0.99 | 0.96 | 174.22 |
| other: a heading's start tag | 110 | 15779.60 ± 0.9% | 605.42 ± 1.5% | 24.27 ± 3.2% | 2049.45 ± 0.9% | 1482.91 ± 7.1% | 10.33 ± 1.1% | 86.06 ± 1.1% | 15787.31 ± 0.4% | 26.06 | 1.00 | 7.70 | 10.64 |
| other: a whole word | 217 | 18723.39 ± 0.6% | 493.83 ± 1.4% | 25.53 ± 1.5% | 18525.28 ± 0.7% | 44.34 ± 0.7% | 9.90 ± 2.5% | 47.13 ± 1.0% | 18713.77 ± 0.3% | 37.91 | 1.00 | 1.01 | 422.30 |
| other: a line's first word, second text | 3716 | 1926.77 ± 1.2% | 477.01 ± 0.5% | 27.29 ± 1.4% | 1886.64 ± 0.8% | 62.56 ± 6.8% | refused | refused | 1924.68 ± 1.9% | 4.04 | 1.00 | 1.02 | 30.80 |
| other: fourteen octets before an x | 87 | 27415.95 ± 2.8% | 242.21 ± 5.5% | 5.77 ± 0.8% | 3278.40 ± 0.8% | 8.87 ± 1.0% | differs | 15.27 ± 0.8% | 27351.17 ± 2.4% | 113.19 | 1.00 | 8.36 | 3092.04 |
| other: a Greek word | 21815 | 409.17 ± 0.7% | 320.69 ± 0.5% | 28.68 ± 1.3% | 241.86 ± 1.2% | 48.73 ± 24.9% | differs | refused | 409.18 ± 1.0% | 1.28 | 1.00 | 1.69 | 8.40 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 17.67 ± 0.2% | 17.71 ± 0.8% | 0.83 ± 0.8% | 16.32 ± 0.7% | 2.45 ± 2.0% | differs | 3.60 ± 1.4% | 17.69 ± 0.9% | 1.00 | 1.00 | 1.08 | 7.22 |
| a UUID | 32895 | 19.97 ± 2.4% | 20.08 ± 1.0% | 0.56 ± 1.1% | 12.67 ± 1.3% | 2.44 ± 0.8% | 0.56 ± 0.2% | 3.08 ± 0.9% | 20.07 ± 0.5% | 0.99 | 1.00 | 1.58 | 8.18 |
| an IPv4 address | 33176 | 29.20 ± 1.0% | 29.24 ± 1.5% | 1.81 ± 1.1% | 24.17 ± 0.1% | 5.86 ± 0.7% | differs | 3.41 ± 1.0% | 29.29 ± 1.4% | 1.00 | 1.00 | 1.21 | 4.99 |
| a date and time | 32954 | 28.88 ± 0.2% | 28.88 ± 0.4% | 1.28 ± 2.3% | 18.41 ± 0.7% | 7.62 ± 2.1% | 1.02 ± 7.5% | 6.67 ± 0.9% | 28.86 ± 0.2% | 1.00 | 1.00 | 1.57 | 3.79 |
| a field path | 32606 | 19.94 ± 0.4% | 19.93 ± 1.8% | 0.96 ± 0.3% | 18.89 ± 0.4% | 2.74 ± 0.5% | differs | 2.32 ± 1.8% | 19.93 ± 3.4% | 1.00 | 1.00 | 1.06 | 7.28 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.66 ± 5.1% | 9.68 ± 3.9% | 9.69 ± 0.2% | 11.52 ± 0.7% | 5.02 ± 9.1% | 0.81 ± 4.0% | none | 9.69 ± 0.5% | 1.00 | 1.00 | 0.84 | 1.93 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 224.19 ± 0.4% | 225.12 ± 2.5% | 263.21 ± 0.5% | 86.03 ± 4.3% | 194.45 ± 21.1% | 545.14 ± 3.3% | 3149.74 ± 1.4% | 224.28 ± 1.6% | 1.00 | 1.00 | 2.61 | 1.15 |
| a UUID | 62 | 148.20 ± 0.8% | 148.99 ± 0.6% | 165.50 ± 0.3% | 45.95 ± 1.4% | 89.47 ± 2.0% | 192.54 ± 1.3% | 3896.66 ± 1.4% | 148.28 ± 0.3% | 0.99 | 1.00 | 3.23 | 1.66 |
| an IPv4 address | 29 | 439.19 ± 0.4% | 444.47 ± 0.6% | 612.24 ± 0.6% | 73.89 ± 1.2% | 118.57 ± 0.9% | 329.60 ± 1.1% | 6245.42 ± 2.2% | 438.38 ± 3.0% | 0.99 | 1.00 | 5.94 | 3.70 |
| a date and time | 56 | 333.39 ± 0.3% | 336.20 ± 0.6% | 423.71 ± 0.6% | 70.86 ± 2.4% | 123.27 ± 1.8% | 350.38 ± 0.6% | 4156.99 ± 0.8% | 332.79 ± 0.5% | 0.99 | 1.00 | 4.70 | 2.70 |
| a field path | 39 | 221.70 ± 0.5% | 222.73 ± 3.2% | 259.51 ± 0.5% | 79.17 ± 4.3% | 185.40 ± 27.4% | 550.26 ± 0.6% | 3996.86 ± 2.8% | 221.73 ± 0.6% | 1.00 | 1.00 | 2.80 | 1.20 |
| literal: a word | 7 | 651.15 ± 0.4% | 709.64 ± 0.6% | 1246.81 ± 1.3% | 523.53 ± 0.9% | 595.18 ± 31.2% | 1069.15 ± 1.1% | 25087.12 ± 0.9% | 651.16 ± 0.5% | 0.92 | 1.00 | 1.24 | 1.09 |
| literal: a word that is not there | 8 | 631.64 ± 0.8% | 687.47 ± 1.7% | 1173.36 ± 0.2% | 480.24 ± 0.7% | 576.19 ± 1.6% | 1001.79 ± 0.5% | 23794.91 ± 1.5% | 630.00 ± 8.0% | 0.92 | 1.00 | 1.32 | 1.10 |
| literal: one of four words | 26 | 255.04 ± 0.5% | 415.01 ± 0.5% | 558.75 ± 0.3% | 38.40 ± 0.7% | 225.77 ± 11.3% | 379.84 ± 0.5% | 11953.36 ± 2.2% | 253.92 ± 1.3% | 0.61 | 1.00 | 6.64 | 1.13 |
| literal: a word in any case | 11 | 454.58 ± 0.2% | 487.93 ± 0.5% | 691.51 ± 2.9% | 12.97 ± 16.2% | 620.87 ± 17.4% | refused | 19088.85 ± 6.9% | 453.13 ± 1.0% | 0.93 | 1.00 | 35.06 | 0.73 |
| literal: an href attribute | 12 | 348.07 ± 1.0% | 362.25 ± 3.7% | 471.90 ± 3.1% | 37.96 ± 2.0% | 454.81 ± 14.7% | 881.94 ± 1.5% | 17411.38 ± 1.2% | 348.23 ± 4.4% | 0.96 | 1.00 | 9.17 | 0.77 |
| literal: a word, second text | 10 | 579.85 ± 0.9% | 644.89 ± 1.2% | 1054.57 ± 0.8% | 446.26 ± 1.1% | 501.70 ± 7.9% | 877.25 ± 0.6% | 21877.00 ± 1.5% | 581.94 ± 0.8% | 0.90 | 1.00 | 1.30 | 1.16 |
| class: two capitalized words | 23 | 492.64 ± 0.6% | 527.38 ± 2.9% | 784.72 ± 7.5% | 101.59 ± 1.6% | 467.55 ± 13.5% | 875.12 ± 5.1% | 5522.15 ± 1.0% | 493.06 ± 2.4% | 0.93 | 1.00 | 4.85 | 1.05 |
| class: a word that ends in ing | 9 | 578.97 ± 1.7% | 671.36 ± 1.8% | 1171.95 ± 1.4% | 133.60 ± 8.3% | 682.43 ± 19.2% | 1356.36 ± 1.1% | 13619.41 ± 1.6% | 580.66 ± 4.0% | 0.86 | 1.00 | 4.33 | 0.85 |
| class: a word in capitals | 16 | 530.47 ± 0.9% | 575.79 ± 1.6% | 941.78 ± 1.1% | 138.48 ± 4.9% | 694.99 ± 1.0% | 1248.30 ± 2.7% | 7402.58 ± 1.2% | 531.03 ± 1.5% | 0.92 | 1.00 | 3.83 | 0.76 |
| class: a number | 6 | 652.20 ± 1.0% | 721.30 ± 1.5% | 1350.68 ± 2.1% | 34.13 ± 9.6% | 1262.25 ± 1.7% | 2299.66 ± 5.0% | 19955.77 ± 1.9% | 652.32 ± 4.1% | 0.90 | 1.00 | 19.11 | 0.52 |
| class: two capitalized words, second text | 23 | 493.67 ± 1.7% | 531.55 ± 6.7% | 787.73 ± 7.0% | 102.97 ± 1.2% | 470.32 ± 2.3% | 836.15 ± 2.6% | 5557.12 ± 2.4% | 494.66 ± 1.3% | 0.93 | 1.00 | 4.79 | 1.05 |
| other: a word between two words | 13 | 569.63 ± 2.0% | 596.64 ± 1.5% | 940.61 ± 1.2% | 137.26 ± 1.8% | 458.75 ± 2.1% | 908.89 ± 0.9% | 12084.32 ± 0.7% | 571.11 ± 0.5% | 0.95 | 1.00 | 4.15 | 1.24 |
| other: a number before a unit, second text | 15 | 412.71 ± 0.8% | 456.90 ± 0.5% | 643.27 ± 0.6% | 32.75 ± 0.4% | 577.03 ± 0.6% | 1067.51 ± 0.5% | 12495.55 ± 1.0% | 413.22 ± 0.8% | 0.90 | 1.00 | 12.60 | 0.72 |
| other: a heading's start tag | 13 | 362.40 ± 0.5% | 371.86 ± 0.8% | 485.75 ± 0.7% | 36.58 ± 1.3% | 563.61 ± 1.9% | 1015.16 ± 0.8% | 14459.23 ± 1.4% | 362.91 ± 0.7% | 0.97 | 1.00 | 9.91 | 0.64 |
| other: a whole word | 11 | 590.63 ± 5.7% | 631.90 ± 7.0% | 1026.37 ± 5.8% | 119.89 ± 6.3% | 527.91 ± 8.9% | 964.28 ± 0.9% | 20644.22 ± 3.2% | 588.37 ± 5.2% | 0.93 | 1.00 | 4.93 | 1.12 |
| other: a line's first word, second text | 17 | 554.38 ± 0.7% | 592.43 ± 1.0% | 960.65 ± 2.9% | 131.89 ± 0.6% | 629.73 ± 11.1% | refused | refused | 555.69 ± 0.5% | 0.94 | 1.00 | 4.20 | 0.88 |
| other: fourteen octets before an x | 16 | 105.30 ± 0.3% | 143.39 ± 6.3% | 169.65 ± 0.6% | 14.21 ± 1.0% | 407.98 ± 1.7% | 460.78 ± 1.0% | 11068.31 ± 1.0% | 105.20 ± 0.9% | 0.73 | 1.00 | 7.41 | 0.26 |
| other: a Greek word | 8 | 445.84 ± 1.0% | 609.64 ± 0.8% | 1040.25 ± 0.8% | 46.80 ± 0.6% | 1249.86 ± 16.3% | 2165.19 ± 0.8% | refused | 445.59 ± 1.4% | 0.73 | 1.00 | 9.53 | 0.36 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20989.90 ± 1.4% | not timed | not timed | 20287.96 ± 0.4% | 1966.26 ± 28.5% | not timed | not timed | 20851.52 ± 1.9% | | 1.01 | 1.03 | 10.68 |
| 01-literal/sherlock-casei-en | 522 | 17368.13 ± 3.3% | not timed | not timed | 6515.60 ± 6.3% | 29.20 ± 10.8% | not timed | not timed | 17275.49 ± 4.7% | | 1.01 | 2.67 | 594.72 |
| 01-literal/sherlock-ru | 724 | 21138.90 ± 1.3% | not timed | not timed | 20370.66 ± 1.1% | 1114.66 ± 5.0% | not timed | not timed | 21167.91 ± 1.2% | | 1.00 | 1.04 | 18.96 |
| 01-literal/sherlock-casei-ru | 746 | 8653.39 ± 9.8% | not timed | not timed | 5166.22 ± 1.6% | 31.76 ± 2.5% | not timed | not timed | 8662.85 ± 10.5% | | 1.00 | 1.67 | 272.43 |
| 01-literal/sherlock-zh | 30 | 27235.88 ± 0.4% | not timed | not timed | 24341.49 ± 8.7% | 1230.26 ± 0.4% | not timed | not timed | 27285.44 ± 1.5% | | 1.00 | 1.12 | 22.14 |
| 02-literal-alternate/sherlock-en | 714 | 9251.50 ± 1.3% | not timed | not timed | 7216.97 ± 0.8% | 17.24 ± 3.0% | not timed | not timed | 9274.97 ± 1.6% | | 1.00 | 1.28 | 536.70 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1756.49 ± 1.1% | not timed | not timed | 1865.20 ± 3.1% | 10.08 ± 2.9% | not timed | not timed | 1761.37 ± 1.7% | | 1.00 | 0.94 | 174.31 |
| 02-literal-alternate/sherlock-ru | 899 | 7574.65 ± 1.0% | not timed | not timed | 3920.59 ± 3.6% | 22.38 ± 1.2% | not timed | not timed | 7539.98 ± 2.1% | | 1.00 | 1.93 | 338.40 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1834.22 ± 1.4% | not timed | not timed | 960.72 ± 0.7% | 8.52 ± 1.2% | not timed | not timed | 1833.02 ± 0.6% | | 1.00 | 1.91 | 215.24 |
| 02-literal-alternate/sherlock-zh | 207 | 12625.84 ± 4.1% | not timed | not timed | 8279.76 ± 1.0% | 32.12 ± 0.6% | not timed | not timed | 12627.13 ± 5.2% | | 1.00 | 1.52 | 393.04 |
| 03-date/ascii | 111817 | 98.05 ± 0.8% | not timed | not timed | 85.64 ± 0.8% | 0.19 ± 5.3% | not timed | not timed | 98.40 ± 0.8% | | 1.00 | 1.14 | 509.70 |
| 04-ruff-noqa/real | 84 | 426.90 ± 2.0% | not timed | not timed | 433.96 ± 0.8% | 19.20 ± 0.3% | not timed | not timed | 428.64 ± 1.3% | | 1.00 | 0.98 | 22.24 |
| 04-ruff-noqa/tweaked | 44 | 508.84 ± 1.4% | not timed | not timed | 429.71 ± 0.4% | 343.59 ± 14.8% | not timed | not timed | 507.07 ± 1.5% | | 1.00 | 1.18 | 1.48 |
| 05-lexer-veryl/single | 124800 | 4.35 ± 0.4% | not timed | not timed | 4.50 ± 1.3% | 0.20 ± 4.6% | not timed | not timed | 4.35 ± 5.4% | | 1.00 | 0.96 | 22.02 |
| 06-cloud-flare-redos/original | 107 | 366.55 ± 0.5% | not timed | not timed | 190.94 ± 2.2% | 23.86 ± 0.9% | not timed | not timed | 366.01 ± 0.1% | | 1.00 | 1.92 | 15.36 |
| 06-cloud-flare-redos/simplified-short | 102 | 356.58 ± 4.3% | not timed | not timed | 175.51 ± 1.0% | 25.35 ± 5.9% | not timed | not timed | 357.24 ± 3.8% | | 1.00 | 2.03 | 14.07 |
| 06-cloud-flare-redos/simplified-long | 10000 | 431.65 ± 0.8% | not timed | not timed | 207.44 ± 1.4% | 27.90 ± 0.6% | not timed | not timed | 433.01 ± 0.9% | | 1.00 | 2.08 | 15.47 |
| 07-unicode-character-data/parse-line | 558784 | 221.91 ± 11.0% | not timed | not timed | 160.66 ± 2.1% | 38.23 ± 8.1% | not timed | not timed | 222.14 ± 10.3% | | 1.00 | 1.38 | 5.80 |
| 08-words/all-english | 56691 | 87.51 ± 0.8% | not timed | not timed | 71.90 ± 0.9% | 10.44 ± 8.0% | not timed | not timed | 88.36 ± 1.4% | | 0.99 | 1.22 | 8.38 |
| 08-words/long-english | 839 | 500.22 ± 0.9% | not timed | not timed | 481.25 ± 0.4% | 28.65 ± 1.1% | not timed | not timed | 500.30 ± 1.0% | | 1.00 | 1.04 | 17.46 |
| 09-aws-keys/full | 0 | 437.86 ± 1.0% | not timed | not timed | 419.89 ± 0.9% | 58.92 ± 4.4% | not timed | not timed | 435.61 ± 0.9% | | 1.01 | 1.04 | 7.43 |
| 09-aws-keys/quick | 0 | 933.80 ± 0.5% | not timed | not timed | 726.02 ± 0.6% | 349.80 ± 16.6% | not timed | not timed | 935.93 ± 0.7% | | 1.00 | 1.29 | 2.67 |
| 10-bounded-repeat/letters-en | 1833 | 513.71 ± 4.1% | not timed | not timed | 440.56 ± 1.3% | 18.71 ± 1.8% | not timed | not timed | 501.92 ± 4.7% | | 1.02 | 1.17 | 27.45 |
| 10-bounded-repeat/letters-ru | 3475 | 423.98 ± 2.1% | not timed | not timed | 395.17 ± 0.9% | 20.26 ± 15.7% | not timed | not timed | 425.31 ± 2.6% | | 1.00 | 1.07 | 20.92 |
| 10-bounded-repeat/context | 53 | 73.50 ± 1.2% | not timed | not timed | 58.26 ± 1.6% | 18.64 ± 0.4% | not timed | not timed | 74.44 ± 2.2% | | 0.99 | 1.26 | 3.94 |
| 10-bounded-repeat/capitals | 11 | 519.88 ± 8.1% | not timed | not timed | 494.19 ± 0.9% | 34.43 ± 1.9% | not timed | not timed | 519.84 ± 7.3% | | 1.00 | 1.05 | 15.10 |
| 11-unstructured-to-json/extract | 600 | 40.49 ± 1.5% | not timed | not timed | 62.19 ± 0.4% | 48.57 ± 6.1% | not timed | not timed | 40.45 ± 8.9% | | 1.00 | 0.65 | 0.83 |
| 12-dictionary/single | 1 | 442.74 ± 0.6% | not timed | not timed | 423.76 ± 1.2% | 0.36 ± 0.5% | not timed | not timed | 443.65 ± 0.3% | | 1.00 | 1.04 | 1214.44 |
| 14-quadratic/1x | 100 | 22.68 ± 1.7% | not timed | not timed | 10.60 ± 1.2% | 0.91 ± 7.1% | not timed | not timed | 22.67 ± 1.7% | | 1.00 | 2.14 | 25.05 |
| 14-quadratic/2x | 200 | 17.55 ± 1.7% | not timed | not timed | 5.15 ± 0.3% | 0.53 ± 8.1% | not timed | not timed | 17.59 ± 1.3% | | 1.00 | 3.41 | 33.41 |
| 14-quadratic/10x | 1000 | 5.57 ± 0.8% | not timed | not timed | 1.00 ± 0.6% | 0.11 ± 2.4% | not timed | not timed | 5.58 ± 1.1% | | 1.00 | 5.58 | 51.46 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.17 ± 1.7% | not timed | not timed | 0.33 ± 1.4% | 0.50 ± 3.1% | not timed | not timed | 1.16 ± 1.9% | | 1.01 | 3.53 | 2.33 |
| 04-ruff-noqa/compile-real | 1 | 115.28 ± 1.0% | not timed | not timed | 11.77 ± 1.5% | 131.04 ± 3.9% | not timed | not timed | 115.44 ± 1.1% | | 1.00 | 9.80 | 0.88 |
| 05-lexer-veryl/compile-single | 1 | 14.52 ± 2.0% | not timed | not timed | 2.22 ± 3.2% | 5.91 ± 1.3% | not timed | not timed | 14.45 ± 2.4% | | 1.00 | 6.54 | 2.46 |
| 07-unicode-character-data/compile | 1 | 116.07 ± 1.3% | not timed | not timed | 24.20 ± 8.9% | 33.19 ± 2.3% | not timed | not timed | 116.35 ± 1.3% | | 1.00 | 4.80 | 3.50 |
| 09-aws-keys/compile-full | 1 | 47.69 ± 0.9% | not timed | not timed | 6.77 ± 0.4% | 21.28 ± 0.7% | not timed | not timed | 46.89 ± 0.9% | | 1.02 | 7.05 | 2.24 |
| 09-aws-keys/compile-quick | 1 | 171.78 ± 1.1% | not timed | not timed | 45.68 ± 0.7% | 123.79 ± 2.1% | not timed | not timed | 172.72 ± 0.6% | | 0.99 | 3.76 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 48.84 ± 1.5% | not timed | not timed | 10.74 ± 0.6% | 15.87 ± 2.9% | not timed | not timed | 49.09 ± 2.8% | | 0.99 | 4.55 | 3.08 |
| 10-bounded-repeat/compile-capitals | 1 | 66.51 ± 8.9% | not timed | not timed | 8.00 ± 2.4% | 22.94 ± 2.0% | not timed | not timed | 66.28 ± 5.9% | | 1.00 | 8.32 | 2.90 |
| 11-unstructured-to-json/compile | 1 | 177.91 ± 2.3% | not timed | not timed | 37.72 ± 0.4% | 62.26 ± 3.3% | not timed | not timed | 177.64 ± 1.0% | | 1.00 | 4.72 | 2.86 |
| 12-dictionary/compile-single | 1 | 0.28 ± 5.1% | not timed | not timed | 0.06 ± 3.7% | 0.09 ± 21.4% | not timed | not timed | 0.29 ± 0.8% | | 1.00 | 4.68 | 3.24 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.93 ± 3.0% | not timed | not timed | 5.97 ± 0.9% | 0.52 ± 6.1% | not timed | not timed | 6.00 ± 1.5% | | 0.99 | 0.99 | 11.41 |
| dictionary/search/english-10 | 690 | 1.08 ± 1.7% | not timed | not timed | 96.20 ± 0.6% | 0.01 ± 0.4% | not timed | not timed | 1.13 ± 1.4% | | 0.95 | 0.0112 | 181.26 |
| dictionary/search/english-15 | 15 | 442.51 ± 1.1% | not timed | not timed | 423.82 ± 0.8% | 0.34 ± 0.6% | not timed | not timed | 442.31 ± 0.7% | | 1.00 | 1.04 | 1285.78 |
| folly/awyer-inn-busted | 1 | 3412.31 ± 1.3% | not timed | not timed | 104.92 ± 1.1% | 40.32 ± 1.4% | not timed | not timed | 3419.08 ± 1.0% | | 1.00 | 32.52 | 84.63 |
| folly/literal-never-match-rare | 0 | 23322.99 ± 0.2% | not timed | not timed | 21229.88 ± 0.7% | 26858.68 ± 0.7% | not timed | not timed | 23337.85 ± 0.5% | | 1.00 | 1.10 | 0.87 |
| folly/literal-never-match-frequent | 0 | 13935.58 ± 2.6% | not timed | not timed | 21204.93 ± 0.7% | 2016.63 ± 0.6% | not timed | not timed | 13977.99 ± 1.2% | | 1.00 | 0.66 | 6.91 |
| folly/literal-never-match-tricksy | 1 | 3252.78 ± 0.6% | not timed | not timed | 4085.50 ± 1.5% | 1258.63 ± 0.7% | not timed | not timed | 3244.87 ± 2.3% | | 1.00 | 0.80 | 2.58 |
| grep/every-line | 239963 | 1115.91 ± 0.4% | not timed | not timed | 723.96 ± 1.6% | 311.52 ± 35.2% | not timed | not timed | 1115.34 ± 2.3% | | 1.00 | 1.54 | 3.58 |
| grep/long-words-ascii | 5073 | 419.14 ± 0.9% | not timed | not timed | 402.13 ± 0.8% | 39.97 ± 6.2% | not timed | not timed | 419.76 ± 0.7% | | 1.00 | 1.04 | 10.49 |
| imported/leipzig/twain | 811 | 21992.84 ± 0.7% | not timed | not timed | 20832.97 ± 0.7% | 9594.86 ± 15.3% | not timed | not timed | 21995.88 ± 0.3% | | 1.00 | 1.06 | 2.29 |
| imported/leipzig/twain-insensitive | 965 | 10128.71 ± 3.5% | not timed | not timed | 8693.27 ± 1.1% | 39.49 ± 0.6% | not timed | not timed | 10217.16 ± 1.2% | | 0.99 | 1.17 | 256.51 |
| imported/leipzig/shing | 1540 | 511.49 ± 0.4% | not timed | not timed | 13301.37 ± 0.5% | 31.55 ± 0.3% | not timed | not timed | 510.83 ± 0.4% | | 1.00 | 0.0385 | 16.21 |
| imported/leipzig/huck-saw | 262 | 14214.73 ± 3.6% | not timed | not timed | 13411.14 ± 0.5% | 32.62 ± 0.6% | not timed | not timed | 14544.24 ± 3.6% | | 0.98 | 1.06 | 435.76 |
| imported/leipzig/word-ending-nn | 262 | 495.32 ± 0.4% | not timed | not timed | 494.38 ± 0.6% | 22.22 ± 0.4% | not timed | not timed | 495.08 ± 0.7% | | 1.00 | 1.00 | 22.29 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 8605.21 ± 1.7% | not timed | not timed | 3389.75 ± 2.1% | 9.57 ± 0.7% | not timed | not timed | 8702.51 ± 2.8% | | 0.99 | 2.54 | 898.78 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 12452.63 ± 2.9% | not timed | not timed | 12281.61 ± 4.4% | 17.50 ± 2.2% | not timed | not timed | 12632.38 ± 2.9% | | 0.99 | 1.01 | 711.41 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4386.83 ± 1.6% | not timed | not timed | 779.00 ± 0.8% | 9.88 ± 0.4% | not timed | not timed | 4406.56 ± 3.9% | | 1.00 | 5.63 | 444.15 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 494.74 ± 0.6% | not timed | not timed | 491.85 ± 0.7% | 10.98 ± 1.5% | not timed | not timed | 494.75 ± 1.3% | | 1.00 | 1.01 | 45.08 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 494.37 ± 0.6% | not timed | not timed | 491.97 ± 0.6% | 9.15 ± 0.7% | not timed | not timed | 495.11 ± 0.5% | | 1.00 | 1.00 | 54.01 |
| imported/leipzig/tom-river | 2 | 8971.29 ± 3.1% | not timed | not timed | 10004.18 ± 0.5% | 31.31 ± 1.4% | not timed | not timed | 9137.04 ± 4.0% | | 0.98 | 0.90 | 286.57 |
| imported/leipzig/ing | 78424 | 486.30 ± 0.4% | not timed | not timed | 457.35 ± 0.9% | 25.67 ± 3.0% | not timed | not timed | 486.12 ± 1.3% | | 1.00 | 1.06 | 18.94 |
| imported/leipzig/ing-whitespace | 55248 | 608.24 ± 1.1% | not timed | not timed | 1741.22 ± 0.8% | 18.59 ± 2.7% | not timed | not timed | 610.73 ± 1.1% | | 1.00 | 0.35 | 32.71 |
| imported/leipzig/awyer-inn | 209 | 628.38 ± 1.2% | not timed | not timed | 8655.42 ± 1.3% | 21.08 ± 1.8% | not timed | not timed | 629.93 ± 2.1% | | 1.00 | 0.0726 | 29.81 |
| imported/leipzig/quotes-bounded | 8886 | 1597.71 ± 3.2% | not timed | not timed | 2650.16 ± 0.9% | 34.58 ± 0.4% | not timed | not timed | 1610.84 ± 1.0% | | 0.99 | 0.60 | 46.21 |
| imported/leipzig/non-ascii-alternate | 2 | 17364.66 ± 8.6% | not timed | not timed | 13741.52 ± 0.9% | 46.37 ± 1.0% | not timed | not timed | 17635.20 ± 3.4% | | 0.98 | 1.26 | 374.45 |
| imported/leipzig/math-symbols | 69 | 1954.35 ± 15.7% | not timed | not timed | 495.76 ± 1.0% | 33.63 ± 1.7% | not timed | not timed | 1977.26 ± 0.8% | | 0.99 | 3.94 | 58.12 |
| imported/leipzig/bounded-strings-ending-z | 0 | 496.30 ± 0.6% | not timed | not timed | 493.06 ± 0.8% | 23.21 ± 0.6% | not timed | not timed | 494.89 ± 1.7% | | 1.00 | 1.01 | 21.38 |
| imported/lh3lh3-reb/uri | 17549 | 604.95 ± 1.0% | not timed | not timed | 827.40 ± 0.6% | 24.28 ± 2.8% | not timed | not timed | 605.09 ± 1.6% | | 1.00 | 0.73 | 24.91 |
| imported/lh3lh3-reb/email | 15057 | 672.17 ± 1.1% | not timed | not timed | 831.14 ± 1.2% | 28.01 ± 2.5% | not timed | not timed | 670.77 ± 0.8% | | 1.00 | 0.81 | 24.00 |
| imported/lh3lh3-reb/date | 668 | 696.30 ± 2.4% | not timed | not timed | 746.01 ± 0.9% | 42.99 ± 4.0% | not timed | not timed | 696.94 ± 0.8% | | 1.00 | 0.93 | 16.20 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 622.49 ± 0.2% | not timed | not timed | 368.48 ± 1.0% | 13.94 ± 1.5% | not timed | not timed | 623.63 ± 1.2% | | 1.00 | 1.69 | 44.67 |
| imported/mariomka/email | 92 | 573.80 ± 0.7% | not timed | not timed | 24068.52 ± 1.0% | 29.54 ± 1.0% | not timed | not timed | 572.07 ± 0.4% | | 1.00 | 0.0238 | 19.42 |
| imported/mariomka/uri | 5301 | 490.50 ± 0.6% | not timed | not timed | 5684.75 ± 0.7% | 30.15 ± 0.1% | not timed | not timed | 488.65 ± 1.1% | | 1.00 | 0.0863 | 16.27 |
| imported/mariomka/ip | 5 | 1483.64 ± 3.2% | not timed | not timed | 1890.41 ± 0.7% | 20.22 ± 1.0% | not timed | not timed | 1499.81 ± 3.4% | | 0.99 | 0.78 | 73.39 |
| imported/rsc/no-exponential | 0 | 766.68 ± 1.4% | not timed | not timed | 501.11 ± 2.0% | 22.06 ± 7.9% | not timed | not timed | 765.72 ± 0.9% | | 1.00 | 1.53 | 34.76 |
| imported/rsc/literal | 1 | 718.04 ± 9.9% | not timed | not timed | 2129.16 ± 1.7% | 215.03 ± 17.3% | not timed | not timed | 779.86 ± 10.0% | | 0.92 | 0.34 | 3.34 |
| imported/rsc/not-literal | 2 | 721.51 ± 2.2% | not timed | not timed | 1056.29 ± 0.8% | 44.21 ± 7.9% | not timed | not timed | 719.30 ± 1.9% | | 1.00 | 0.68 | 16.32 |
| imported/rsc/match-class | 1 | 1329.42 ± 1.5% | not timed | not timed | 2133.59 ± 0.8% | 51.20 ± 1.5% | not timed | not timed | 1330.58 ± 1.2% | | 1.00 | 0.62 | 25.96 |
| imported/rsc/match-class-in-range | 1 | 1322.91 ± 2.9% | not timed | not timed | 3395.51 ± 1.1% | 55.73 ± 7.7% | not timed | not timed | 1328.81 ± 0.8% | | 1.00 | 0.39 | 23.74 |
| imported/rsc/match-class-unicode | 1 | 469.78 ± 0.8% | not timed | not timed | 460.71 ± 0.3% | 61.79 ± 7.8% | not timed | not timed | 468.98 ± 1.8% | | 1.00 | 1.02 | 7.60 |
| imported/rsc/anchored-literal-short-non-match | 0 | 528.53 ± 0.8% | not timed | not timed | 1182.25 ± 0.4% | 280.38 ± 5.7% | not timed | not timed | 528.90 ± 1.5% | | 1.00 | 0.45 | 1.89 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8909.91 ± 1.8% | not timed | not timed | 17771.29 ± 1.9% | 4207.99 ± 8.8% | not timed | not timed | 9034.13 ± 1.2% | | 0.99 | 0.50 | 2.12 |
| imported/rsc/anchored-literal-short-match | 4 | 433.30 ± 2.8% | not timed | not timed | 784.21 ± 0.7% | 83.69 ± 12.2% | not timed | not timed | 432.46 ± 2.5% | | 1.00 | 0.55 | 5.18 |
| imported/rsc/anchored-literal-long-match | 4 | 2415.51 ± 1.2% | not timed | not timed | 11789.61 ± 0.6% | 1230.32 ± 10.6% | not timed | not timed | 2433.66 ± 2.1% | | 0.99 | 0.20 | 1.96 |
| imported/rsc/one-pass-short | 17 | 379.47 ± 3.9% | not timed | not timed | 361.41 ± 0.5% | 31.19 ± 14.7% | not timed | not timed | 377.32 ± 13.3% | | 1.01 | 1.05 | 12.17 |
| imported/rsc/one-pass-short-not | 17 | 232.33 ± 1.5% | not timed | not timed | 345.36 ± 1.7% | 27.01 ± 16.5% | not timed | not timed | 232.01 ± 2.3% | | 1.00 | 0.67 | 8.60 |
| imported/rsc/one-pass-long-prefix | 26 | 245.56 ± 3.3% | not timed | not timed | 423.09 ± 0.5% | 96.39 ± 19.0% | not timed | not timed | 244.76 ± 3.0% | | 1.00 | 0.58 | 2.55 |
| imported/rsc/one-pass-long-prefix-not | 26 | 395.11 ± 2.1% | not timed | not timed | 424.40 ± 1.0% | 72.89 ± 22.3% | not timed | not timed | 395.15 ± 9.7% | | 1.00 | 0.93 | 5.42 |
| imported/rsc/long-needle1 | 31 | 28853.08 ± 0.9% | not timed | not timed | 25754.44 ± 1.0% | 3.71 ± 1.3% | not timed | not timed | 28912.00 ± 0.7% | | 1.00 | 1.12 | 7781.69 |
| imported/rsc/long-needle2 | 31 | 28674.98 ± 0.9% | not timed | not timed | 168.88 ± 1.1% | 3.71 ± 1.2% | not timed | not timed | 28626.98 ± 0.8% | | 1.00 | 169.80 | 7734.34 |
| imported/rsc/easy0-32 | 26 | 1116.91 ± 13.0% | not timed | not timed | 2011.51 ± 0.4% | 148.33 ± 23.5% | not timed | not timed | 1142.68 ± 5.6% | | 0.98 | 0.56 | 7.53 |
| imported/rsc/easy0-1k | 26 | 18529.74 ± 3.8% | not timed | not timed | 17624.47 ± 0.5% | 2514.74 ± 20.2% | not timed | not timed | 18402.38 ± 0.3% | | 1.01 | 1.05 | 7.37 |
| imported/rsc/easy0-32k | 26 | 36695.43 ± 7.3% | not timed | not timed | 30600.33 ± 0.8% | 19761.95 ± 31.5% | not timed | not timed | 36797.39 ± 3.5% | | 1.00 | 1.20 | 1.86 |
| imported/rsc/easy0-1mb | 26 | 29404.77 ± 1.3% | not timed | not timed | 28868.53 ± 0.9% | 39027.69 ± 0.7% | not timed | not timed | 29386.56 ± 1.9% | | 1.00 | 1.02 | 0.75 |
| imported/rsc/easy1-32 | 19 | 364.31 ± 0.6% | not timed | not timed | 1033.22 ± 2.0% | 132.53 ± 22.5% | not timed | not timed | 364.77 ± 2.8% | | 1.00 | 0.35 | 2.75 |
| imported/rsc/easy1-1k | 19 | 488.43 ± 10.1% | not timed | not timed | 21104.59 ± 1.2% | 2532.64 ± 14.7% | not timed | not timed | 488.45 ± 2.7% | | 1.00 | 0.0231 | 0.19 |
| imported/rsc/easy1-32k | 19 | 496.43 ± 0.2% | not timed | not timed | 663097.93 ± 0.9% | 21873.12 ± 4.5% | not timed | not timed | 496.01 ± 10.1% | | 1.00 | 0.0007 | 0.0227 |
| imported/rsc/easy1-1mb | 19 | 496.31 ± 0.3% | not timed | not timed | 21272947.58 ± 0.4% | 40902.58 ± 1.1% | not timed | not timed | 496.99 ± 0.6% | | 1.00 | 0.0000 | 0.0121 |
| imported/rsc/medium-32 | 27 | 450.72 ± 4.1% | not timed | not timed | 946.17 ± 5.3% | 66.07 ± 13.5% | not timed | not timed | 443.21 ± 4.7% | | 1.02 | 0.48 | 6.82 |
| imported/rsc/medium-1k | 27 | 6951.25 ± 2.8% | not timed | not timed | 17116.60 ± 1.1% | 69.02 ± 8.1% | not timed | not timed | 6948.89 ± 0.6% | | 1.00 | 0.41 | 100.72 |
| imported/rsc/medium-32k | 27 | 33314.21 ± 1.1% | not timed | not timed | 356634.39 ± 0.7% | 50.31 ± 0.5% | not timed | not timed | 33505.52 ± 1.0% | | 0.99 | 0.0934 | 662.20 |
| imported/rsc/medium-1mb | 27 | 29133.41 ± 1.5% | not timed | not timed | 17011790.20 ± 0.5% | 50.72 ± 1.7% | not timed | not timed | 29124.38 ± 1.3% | | 1.00 | 0.0017 | 574.36 |
| imported/rsc/hard-32 | 58 | 251.79 ± 6.0% | not timed | not timed | 385.26 ± 0.8% | 48.64 ± 5.9% | not timed | not timed | 252.61 ± 0.5% | | 1.00 | 0.65 | 5.18 |
| imported/rsc/hard-1k | 27 | 485.32 ± 0.8% | not timed | not timed | 15087.39 ± 0.7% | 39.95 ± 1.1% | not timed | not timed | 485.71 ± 0.4% | | 1.00 | 0.0322 | 12.15 |
| imported/rsc/hard-32k | 27 | 495.89 ± 0.7% | not timed | not timed | 471720.77 ± 1.9% | 28.41 ± 0.7% | not timed | not timed | 495.41 ± 1.4% | | 1.00 | 0.0011 | 17.46 |
| imported/rsc/hard-1mb | 51 | 496.81 ± 0.6% | not timed | not timed | 7865533.55 ± 0.7% | 28.53 ± 2.0% | not timed | not timed | 495.64 ± 0.7% | | 1.00 | 0.0001 | 17.41 |
| imported/rsc/reallyhard0-32 | 58 | 251.62 ± 10.0% | not timed | not timed | 232.14 ± 0.8% | 49.25 ± 7.1% | not timed | not timed | 252.06 ± 0.9% | | 1.00 | 1.08 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 484.02 ± 1.4% | not timed | not timed | 483.82 ± 0.5% | 39.69 ± 1.0% | not timed | not timed | 483.74 ± 2.7% | | 1.00 | 1.00 | 12.19 |
| imported/rsc/reallyhard0-32k | 27 | 496.02 ± 0.7% | not timed | not timed | 498.28 ± 7.4% | 28.31 ± 13.4% | not timed | not timed | 494.97 ± 1.7% | | 1.00 | 1.00 | 17.52 |
| imported/rsc/reallyhard0-1mb | 51 | 495.78 ± 1.1% | not timed | not timed | 497.50 ± 0.5% | 28.51 ± 1.6% | not timed | not timed | 496.20 ± 0.6% | | 1.00 | 1.00 | 17.39 |
| imported/rsc/reallyreallyhard0-32 | 47 | 276.51 ± 12.7% | not timed | not timed | 210.84 ± 2.0% | 58.22 ± 9.6% | not timed | not timed | 275.96 ± 0.8% | | 1.00 | 1.31 | 4.75 |
| imported/rsc/reallyreallyhard0-1k | 16 | 721.66 ± 1.0% | not timed | not timed | 8072.46 ± 1.1% | 31.45 ± 1.4% | not timed | not timed | 720.63 ± 6.3% | | 1.00 | 0.0894 | 22.95 |
| imported/rsc/reallyreallyhard0-32k | 16 | 517.69 ± 4.8% | not timed | not timed | 28828.40 ± 1.6% | 23.57 ± 0.7% | not timed | not timed | 520.65 ± 6.0% | | 0.99 | 0.0180 | 21.96 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 497.32 ± 0.7% | not timed | not timed | 28463.81 ± 2.3% | 23.69 ± 0.6% | not timed | not timed | 497.70 ± 0.6% | | 1.00 | 0.0175 | 20.99 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.59 ± 14.0% | not timed | not timed | 199.25 ± 0.5% | 57.86 ± 1.9% | not timed | not timed | 269.60 ± 0.8% | | 1.00 | 1.35 | 4.66 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 697.84 ± 1.2% | not timed | not timed | 7756.03 ± 0.6% | 31.56 ± 0.6% | not timed | not timed | 700.16 ± 0.8% | | 1.00 | 0.0900 | 22.11 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 521.06 ± 5.4% | not timed | not timed | 28715.79 ± 5.0% | 23.40 ± 0.9% | not timed | not timed | 521.07 ± 4.4% | | 1.00 | 0.0181 | 22.27 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 497.48 ± 0.7% | not timed | not timed | 25287.11 ± 4.6% | 23.64 ± 0.8% | not timed | not timed | 497.84 ± 0.8% | | 1.00 | 0.0197 | 21.04 |
| imported/sherlock/name-sherlock | 776 | 25244.20 ± 13.6% | not timed | not timed | 23508.27 ± 1.2% | 9627.91 ± 14.4% | not timed | not timed | 25603.25 ± 1.3% | | 0.99 | 1.07 | 2.62 |
| imported/sherlock/name-holmes | 2766 | 17381.12 ± 1.0% | not timed | not timed | 18605.45 ± 1.3% | 3219.31 ± 6.6% | not timed | not timed | 17539.47 ± 2.5% | | 0.99 | 0.93 | 5.40 |
| imported/sherlock/name-sherlock-holmes | 1365 | 25685.93 ± 1.1% | not timed | not timed | 23079.16 ± 0.5% | 7838.15 ± 50.0% | not timed | not timed | 25759.10 ± 2.5% | | 1.00 | 1.11 | 3.28 |
| imported/sherlock/name-sherlock-casei | 816 | 23219.03 ± 1.4% | not timed | not timed | 7920.07 ± 1.0% | 28.95 ± 1.5% | not timed | not timed | 22969.82 ± 1.2% | | 1.01 | 2.93 | 802.16 |
| imported/sherlock/name-holmes-casei | 2802 | 14383.22 ± 2.2% | not timed | not timed | 5521.41 ± 1.1% | 40.13 ± 1.4% | not timed | not timed | 14439.94 ± 1.5% | | 1.00 | 2.60 | 358.45 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 20129.16 ± 1.7% | not timed | not timed | 7737.37 ± 1.0% | 29.33 ± 1.6% | not timed | not timed | 19953.02 ± 5.0% | | 1.01 | 2.60 | 686.20 |
| imported/sherlock/name-whitespace | 1461 | 17626.75 ± 3.7% | not timed | not timed | 18536.89 ± 1.5% | 7233.87 ± 23.2% | not timed | not timed | 17590.07 ± 1.8% | | 1.00 | 0.95 | 2.44 |
| imported/sherlock/name-alt1 | 1142 | 16319.56 ± 3.9% | not timed | not timed | 26884.99 ± 2.6% | 3872.10 ± 53.3% | not timed | not timed | 16343.16 ± 2.3% | | 1.00 | 0.61 | 4.21 |
| imported/sherlock/name-alt2 | 3542 | 11043.12 ± 0.6% | not timed | not timed | 6883.81 ± 1.3% | 31.92 ± 1.6% | not timed | not timed | 11053.45 ± 2.0% | | 1.00 | 1.60 | 345.98 |
| imported/sherlock/name-alt3 | 4507 | 8120.98 ± 2.6% | not timed | not timed | 6197.57 ± 0.8% | 10.08 ± 1.3% | not timed | not timed | 8147.42 ± 2.2% | | 1.00 | 1.31 | 805.97 |
| imported/sherlock/name-alt3-casei | 4593 | 1330.68 ± 1.1% | not timed | not timed | 1112.14 ± 0.1% | 6.12 ± 1.3% | not timed | not timed | 1332.84 ± 4.0% | | 1.00 | 1.20 | 217.44 |
| imported/sherlock/name-alt4 | 3686 | 6776.85 ± 0.4% | not timed | not timed | 6467.10 ± 5.8% | 31.61 ± 0.9% | not timed | not timed | 6761.40 ± 0.5% | | 1.00 | 1.05 | 214.40 |
| imported/sherlock/name-alt4-casei | 4254 | 2927.56 ± 2.5% | not timed | not timed | 3312.47 ± 1.0% | 17.58 ± 0.6% | not timed | not timed | 2919.56 ± 2.6% | | 1.00 | 0.88 | 166.54 |
| imported/sherlock/name-alt5 | 4028 | 9599.32 ± 1.6% | not timed | not timed | 6633.50 ± 1.1% | 22.38 ± 7.2% | not timed | not timed | 9642.27 ± 1.1% | | 1.00 | 1.45 | 428.93 |
| imported/sherlock/name-alt5-casei | 4104 | 4392.70 ± 3.2% | not timed | not timed | 2307.52 ± 0.8% | 12.75 ± 2.0% | not timed | not timed | 4358.06 ± 5.5% | | 1.01 | 1.90 | 344.46 |
| imported/sherlock/no-match-uncommon | 0 | 29090.15 ± 1.1% | not timed | not timed | 24969.38 ± 1.1% | 36547.24 ± 1.0% | not timed | not timed | 28969.47 ± 3.1% | | 1.00 | 1.17 | 0.80 |
| imported/sherlock/no-match-common | 0 | 28682.71 ± 1.0% | not timed | not timed | 24754.83 ± 1.0% | 1560.60 ± 0.1% | not timed | not timed | 28780.35 ± 0.6% | | 1.00 | 1.16 | 18.38 |
| imported/sherlock/no-match-really-common | 0 | 23660.94 ± 2.7% | not timed | not timed | 23925.85 ± 3.5% | 1557.91 ± 0.5% | not timed | not timed | 23601.61 ± 1.4% | | 1.00 | 0.99 | 15.19 |
| imported/sherlock/the-lower | 21654 | 2225.51 ± 5.2% | not timed | not timed | 1887.20 ± 0.6% | 235.58 ± 16.0% | not timed | not timed | 2231.37 ± 5.3% | | 1.00 | 1.18 | 9.45 |
| imported/sherlock/the-upper | 2223 | 13055.25 ± 19.6% | not timed | not timed | 16333.69 ± 1.1% | 2728.33 ± 25.3% | not timed | not timed | 13436.88 ± 5.2% | | 0.97 | 0.80 | 4.79 |
| imported/sherlock/the-casei | 23961 | 2038.84 ± 1.4% | not timed | not timed | 1118.01 ± 1.3% | 35.66 ± 40.4% | not timed | not timed | 2049.46 ± 2.4% | | 0.99 | 1.82 | 57.18 |
| imported/sherlock/everything-greedy | 581881 | 238.13 ± 1.7% | not timed | not timed | 146.49 ± 1.4% | 24.86 ± 22.2% | not timed | not timed | 238.52 ± 1.6% | | 1.00 | 1.63 | 9.58 |
| imported/sherlock/everything-greedy-nl | 594933 | 378.63 ± 0.6% | not timed | not timed | 186.41 ± 0.8% | 26.73 ± 2.1% | not timed | not timed | 378.55 ± 0.6% | | 1.00 | 2.03 | 14.16 |
| imported/sherlock/letters | 447175 | 46.34 ± 1.8% | not timed | not timed | 33.05 ± 0.9% | 5.62 ± 0.8% | not timed | not timed | 46.42 ± 0.7% | | 1.00 | 1.40 | 8.24 |
| imported/sherlock/letters-upper | 14180 | 355.73 ± 2.1% | not timed | not timed | 314.07 ± 1.0% | 24.79 ± 22.0% | not timed | not timed | 355.53 ± 1.8% | | 1.00 | 1.13 | 14.35 |
| imported/sherlock/letters-lower | 432995 | 47.20 ± 0.7% | not timed | not timed | 33.72 ± 0.9% | 5.99 ± 38.6% | not timed | not timed | 47.19 ± 1.1% | | 1.00 | 1.40 | 7.88 |
| imported/sherlock/words | 447639 | 85.09 ± 14.0% | not timed | not timed | 72.61 ± 1.0% | 12.70 ± 31.6% | not timed | not timed | 85.65 ± 0.9% | | 0.99 | 1.17 | 6.70 |
| imported/sherlock/before-holmes | 4073 | 492.01 ± 2.7% | not timed | not timed | 11457.35 ± 2.2% | 21.62 ± 1.5% | not timed | not timed | 490.29 ± 0.4% | | 1.00 | 0.0429 | 22.76 |
| imported/sherlock/before-after-holmes | 2593 | 492.86 ± 0.7% | not timed | not timed | 12404.73 ± 4.0% | 21.65 ± 0.8% | not timed | not timed | 492.73 ± 0.7% | | 1.00 | 0.0397 | 22.76 |
| imported/sherlock/holmes-cochar-watson | 150 | 7416.18 ± 1.1% | not timed | not timed | 5675.20 ± 1.7% | 31.84 ± 1.3% | not timed | not timed | 7438.74 ± 1.2% | | 1.00 | 1.31 | 232.96 |
| imported/sherlock/holmes-coword-watson | 14309 | 1020.09 ± 0.7% | not timed | not timed | 1012.72 ± 0.6% | 6.44 ± 0.5% | not timed | not timed | 1021.08 ± 0.9% | | 1.00 | 1.01 | 158.29 |
| imported/sherlock/quotes | 14437 | 1086.11 ± 0.3% | not timed | not timed | 1576.98 ± 3.9% | 31.67 ± 1.4% | not timed | not timed | 1092.26 ± 0.8% | | 0.99 | 0.69 | 34.30 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 494.56 ± 0.4% | not timed | not timed | 20189.03 ± 1.2% | 37.33 ± 0.3% | not timed | not timed | 497.55 ± 0.8% | | 0.99 | 0.0245 | 13.25 |
| imported/sherlock/word-ending-n | 35297 | 370.56 ± 2.4% | not timed | not timed | 335.72 ± 0.8% | 20.70 ± 21.4% | not timed | not timed | 371.08 ± 1.8% | | 1.00 | 1.10 | 17.90 |
| imported/sherlock/repeated-class-negation | 2130 | 13615.96 ± 4.9% | not timed | not timed | 14397.34 ± 1.6% | 9.57 ± 0.3% | not timed | not timed | 13692.98 ± 6.9% | | 0.99 | 0.95 | 1423.10 |
| imported/sherlock/ing-suffix | 20547 | 451.51 ± 0.8% | not timed | not timed | 421.92 ± 1.1% | 26.01 ± 0.5% | not timed | not timed | 451.02 ± 0.7% | | 1.00 | 1.07 | 17.36 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 486.48 ± 0.6% | not timed | not timed | 2073.16 ± 4.1% | 18.58 ± 0.4% | not timed | not timed | 487.45 ± 1.0% | | 1.00 | 0.23 | 26.19 |
| opt/accelerate/whole-line | 239963 | 426.24 ± 1.8% | not timed | not timed | 340.89 ± 0.4% | 86.63 ± 16.4% | not timed | not timed | 426.24 ± 2.4% | | 1.00 | 1.25 | 4.92 |
| opt/accelerate/non-dna | 16745 | 364.38 ± 1.3% | not timed | not timed | 389.05 ± 0.4% | 28.08 ± 20.2% | not timed | not timed | 365.16 ± 1.2% | | 1.00 | 0.94 | 12.98 |
| opt/backtrack/words-english | 40536 | 119.79 ± 0.8% | not timed | not timed | 96.39 ± 1.7% | 18.48 ± 8.3% | not timed | not timed | 119.32 ± 2.6% | | 1.00 | 1.24 | 6.48 |
| opt/fixed-length/too-small-ascii | 0 | 311.59 ± 1.0% | not timed | not timed | 744.90 ± 3.9% | 104.69 ± 1.7% | not timed | not timed | 311.65 ± 0.9% | | 1.00 | 0.42 | 2.98 |
| opt/fixed-length/too-big-ascii | 0 | 753.49 ± 0.5% | not timed | not timed | 6280.20 ± 9.3% | 130.25 ± 1.2% | not timed | not timed | 750.83 ± 0.3% | | 1.00 | 0.12 | 5.79 |
| opt/fixed-length/go33484-1 | 0 | 58.52 ± 1.8% | not timed | not timed | 1188412.04 ± 3.3% | 68612.55 ± 2.2% | not timed | not timed | 58.84 ± 0.6% | | 0.99 | 0.0000 | 0.0009 |
| opt/fixed-length/go33484-2 | 0 | 3380.23 ± 0.4% | not timed | not timed | 1212530.79 ± 2.8% | 36249.25 ± 0.5% | not timed | not timed | 3382.86 ± 0.5% | | 1.00 | 0.0028 | 0.0932 |
| opt/fixed-length/go33484-3 | 0 | 1431.52 ± 2.1% | not timed | not timed | 121829.73 ± 3.2% | 857.38 ± 0.5% | not timed | not timed | 1404.78 ± 1.2% | | 1.02 | 0.0118 | 1.67 |
| opt/literal-alt/one-pattern | 1 | 503.39 ± 2.4% | not timed | not timed | 505.10 ± 0.6% | 0.36 ± 1.7% | not timed | not timed | 503.84 ± 0.5% | | 1.00 | 1.00 | 1408.80 |
| opt/onepass/fn-predicate | 916 | 368.57 ± 0.4% | not timed | not timed | 326.86 ± 0.4% | 146.84 ± 36.4% | not timed | not timed | 366.77 ± 4.4% | | 1.00 | 1.13 | 2.51 |
| opt/onepass/first-three-words-english | 35128 | 127.48 ± 10.0% | not timed | not timed | 188.30 ± 10.8% | 74.71 ± 31.0% | not timed | not timed | 129.33 ± 0.9% | | 0.99 | 0.68 | 1.71 |
| opt/prefilter/literal-english | 1 | 28524.91 ± 1.6% | not timed | not timed | 25411.69 ± 1.3% | 18583.62 ± 1.4% | not timed | not timed | 28609.23 ± 1.2% | | 1.00 | 1.12 | 1.53 |
| opt/prefilter/literal-casei-english | 1 | 22665.95 ± 1.4% | not timed | not timed | 9166.23 ± 1.0% | 29.69 ± 2.1% | not timed | not timed | 22517.99 ± 1.4% | | 1.01 | 2.47 | 763.43 |
| opt/prefilter/literal-russian | 1 | 29443.56 ± 1.1% | not timed | not timed | 25542.76 ± 1.5% | 1477.84 ± 1.5% | not timed | not timed | 29355.67 ± 2.6% | | 1.00 | 1.15 | 19.92 |
| opt/prefilter/literal-casei-russian | 1 | 16776.66 ± 2.9% | not timed | not timed | 7260.19 ± 2.6% | 32.19 ± 0.7% | not timed | not timed | 16874.55 ± 1.4% | | 0.99 | 2.31 | 521.16 |
| opt/prefilter/rust-functions | 948 | 9899.51 ± 2.3% | not timed | not timed | 8771.67 ± 1.2% | 1609.16 ± 0.3% | not timed | not timed | 9920.99 ± 1.3% | | 1.00 | 1.13 | 6.15 |
| opt/reverse-anchored/word-end | 1 | 3425.87 ± 0.8% | not timed | not timed | 29418251.00 ± 0.9% | 47.20 ± 2.9% | not timed | not timed | 3430.72 ± 0.4% | | 1.00 | 0.0001 | 72.58 |
| opt/reverse-inner/holmes | 2593 | 492.47 ± 0.6% | not timed | not timed | 12148.47 ± 4.8% | 21.66 ± 1.8% | not timed | not timed | 492.24 ± 0.9% | | 1.00 | 0.0405 | 22.74 |
| opt/reverse-inner/email | 47 | 840.74 ± 1.9% | not timed | not timed | 28644.02 ± 122.7% | 29.63 ± 4.3% | not timed | not timed | 845.55 ± 0.8% | | 0.99 | 0.0294 | 28.37 |
| opt/reverse-inner/factored-prefix | 3542 | 485.10 ± 1.0% | not timed | not timed | 484.19 ± 0.9% | 11.30 ± 7.6% | not timed | not timed | 485.58 ± 1.0% | | 1.00 | 1.00 | 42.94 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3390.97 ± 0.5% | not timed | not timed | 497.53 ± 1.1% | 65.76 ± 2.8% | not timed | not timed | 3390.52 ± 0.4% | | 1.00 | 6.82 | 51.56 |
| opt/reverse-inner/no-quadratic-forward | 0 | 576.74 ± 4.9% | not timed | not timed | 229.55 ± 0.8% | 25.60 ± 1.0% | not timed | not timed | 578.76 ± 5.4% | | 1.00 | 2.51 | 22.53 |
| opt/reverse-suffix/holmes | 4073 | 490.52 ± 0.4% | not timed | not timed | 11455.85 ± 1.7% | 21.66 ± 1.8% | not timed | not timed | 491.59 ± 1.0% | | 1.00 | 0.0428 | 22.65 |
| opt/reverse-suffix/no-quadratic | 0 | 3387.10 ± 0.6% | not timed | not timed | 497.02 ± 0.5% | 64.96 ± 1.6% | not timed | not timed | 3387.91 ± 0.6% | | 1.00 | 6.81 | 52.14 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 110.40 ± 4.7% | not timed | not timed | 160.96 ± 2.8% | 12.97 ± 17.5% | not timed | not timed | 110.29 ± 3.2% | | 1.00 | 0.69 | 8.51 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 110.39 ± 4.7% | not timed | not timed | 161.37 ± 2.2% | 12.80 ± 16.3% | not timed | not timed | 110.14 ± 4.1% | | 1.00 | 0.68 | 8.63 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.29 ± 0.9% | not timed | not timed | 0.47 ± 0.4% | 97.48 ± 1.2% | not timed | not timed | 0.29 ± 1.8% | | 1.00 | 0.62 | 0.0030 |
| reported/i1095-word-repetition/ascii-search | 256 | 262.05 ± 0.8% | not timed | not timed | 247.07 ± 0.5% | 91.85 ± 7.5% | not timed | not timed | 260.57 ± 3.0% | | 1.01 | 1.06 | 2.85 |
| reported/i13-subset-regex/original-ascii | 4094 | 8518.81 ± 3.0% | not timed | not timed | 3367.02 ± 0.9% | 9.59 ± 0.7% | not timed | not timed | 8713.06 ± 3.4% | | 0.98 | 2.53 | 888.43 |
| reported/i13-subset-regex/original-unicode | 4094 | 8510.33 ± 5.3% | not timed | not timed | 186.82 ± 2.9% | 9.58 ± 0.3% | not timed | not timed | 8532.77 ± 2.2% | | 1.00 | 45.55 | 888.38 |
| reported/i13-subset-regex/big-ascii | 1955 | 8043.47 ± 2.1% | not timed | not timed | 51.24 ± 3.1% | 8.35 ± 1.0% | not timed | not timed | 8024.50 ± 2.3% | | 1.00 | 156.97 | 963.68 |
| reported/i13-subset-regex/big-unicode | 1955 | 7989.69 ± 2.7% | not timed | not timed | 9.07 ± 55.2% | 8.37 ± 1.1% | not timed | not timed | 7967.54 ± 2.2% | | 1.00 | 880.79 | 954.43 |
| reported/i13-subset-regex/huge-ascii | 55 | 7442.95 ± 2.4% | not timed | not timed | 8.67 ± 0.6% | 7.91 ± 0.1% | not timed | not timed | 7453.45 ± 2.0% | | 1.00 | 858.18 | 940.62 |
| reported/i13-subset-regex/huge-unicode | 55 | 7363.86 ± 2.3% | not timed | not timed | 8.64 ± 0.3% | 7.90 ± 0.7% | not timed | not timed | 7385.68 ± 3.0% | | 1.00 | 852.14 | 931.78 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.43 ± 1.1% | not timed | not timed | 8.49 ± 0.3% | 7.91 ± 0.5% | not timed | not timed | 3.43 ± 0.9% | | 1.00 | 0.40 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.68 ± 0.5% | not timed | not timed | 8.61 ± 0.8% | 7.91 ± 1.7% | not timed | not timed | 4.69 ± 0.9% | | 1.00 | 0.54 | 0.59 |
| reported/i787-keywords/ascii | 5674 | 395.27 ± 0.9% | not timed | not timed | 112.97 ± 1.1% | 6.34 ± 0.5% | not timed | not timed | 397.49 ± 1.9% | | 0.99 | 3.50 | 62.30 |
| reported/i787-keywords/opt-ascii | 5674 | 396.71 ± 1.0% | not timed | not timed | 233.38 ± 0.6% | 10.16 ± 0.6% | not timed | not timed | 397.11 ± 1.2% | | 1.00 | 1.70 | 39.06 |
| slow/quadratic-regex-1x | 100 | 7.20 ± 1.0% | not timed | not timed | 5.30 ± 0.5% | 0.05 ± 0.3% | not timed | not timed | 7.21 ± 0.2% | | 1.00 | 1.36 | 147.91 |
| slow/quadratic-regex-2x | 199 | 3.12 ± 4.0% | not timed | not timed | 2.60 ± 0.6% | 0.01 ± 0.3% | not timed | not timed | 3.12 ± 0.6% | | 1.00 | 1.20 | 250.37 |
| slow/quadratic-haystack-1x | 100 | 22.77 ± 8.6% | not timed | not timed | 10.58 ± 0.6% | 0.99 ± 15.5% | not timed | not timed | 22.81 ± 3.1% | | 1.00 | 2.15 | 23.01 |
| slow/quadratic-haystack-2x | 200 | 17.48 ± 2.4% | not timed | not timed | 5.15 ± 0.6% | 0.54 ± 14.5% | not timed | not timed | 17.57 ± 0.4% | | 0.99 | 3.39 | 32.28 |
| unicode/codepoints/any-one | 1112064 | 301.15 ± 5.7% | not timed | not timed | 236.54 ± 1.2% | 14.79 ± 19.7% | not timed | not timed | 302.81 ± 1.0% | | 0.99 | 1.27 | 20.35 |
| unicode/codepoints/any-all | 4382592 | 229.91 ± 0.4% | not timed | not timed | 225.17 ± 1.6% | 98.26 ± 2.4% | not timed | not timed | 230.47 ± 1.5% | | 1.00 | 1.02 | 2.34 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.46 ± 0.9% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 495.94 ± 0.5% | not timed | not timed | 496.27 ± 1.0% | 134.45 ± 0.9% | not timed | not timed | 496.06 ± 0.7% | | 1.00 | 1.00 | 3.69 |
| unicode/overlapping-words/ascii | 6156 | 25.57 ± 0.9% | not timed | not timed | 39.19 ± 0.7% | 3.89 ± 0.8% | not timed | not timed | 25.64 ± 0.6% | | 1.00 | 0.65 | 6.57 |
| unicode/overlapping-words/english | 6156 | 1.23 ± 1.0% | not timed | not timed | 1.72 ± 1.5% | 2.24 ± 1.5% | not timed | not timed | 1.27 ± 2.1% | | 0.97 | 0.71 | 0.55 |
| unicode/overlapping-words/russian | 5710 | 1.18 ± 0.6% | not timed | not timed | 1.71 ± 1.0% | 5.80 ± 8.8% | not timed | not timed | 1.20 ± 0.4% | | 0.98 | 0.69 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 88.16 ± 1.1% | not timed | not timed | 71.95 ± 3.0% | 10.20 ± 32.3% | not timed | not timed | 87.92 ± 13.2% | | 1.00 | 1.23 | 8.64 |
| unicode/word/boundary-long-english | 3466 | 498.36 ± 0.8% | not timed | not timed | 488.32 ± 0.9% | 28.76 ± 0.7% | not timed | not timed | 496.97 ± 0.4% | | 1.00 | 1.02 | 17.33 |
| unicode/word/around-holmes-english | 27 | 495.23 ± 0.4% | not timed | not timed | 25375.97 ± 0.7% | 19.31 ± 0.8% | not timed | not timed | 495.48 ± 0.8% | | 1.00 | 0.0195 | 25.65 |
| wild/bibleref/long | 874 | 464.53 ± 1.5% | not timed | not timed | 472.68 ± 6.6% | 7.24 ± 0.8% | not timed | not timed | 464.10 ± 0.9% | | 1.00 | 0.98 | 64.16 |
| wild/bibleref/short | 30 | 19.13 ± 6.3% | not timed | not timed | 29.66 ± 0.4% | 13.25 ± 16.5% | not timed | not timed | 19.71 ± 1.6% | | 0.97 | 0.65 | 1.44 |
| wild/bibleref/line | 874 | 394.80 ± 10.5% | not timed | not timed | 223.00 ± 0.3% | 8.00 ± 5.8% | not timed | not timed | 395.76 ± 1.1% | | 1.00 | 1.77 | 49.36 |
| wild/caddy/caddy | 6 | 404.77 ± 2.2% | not timed | not timed | 230.91 ± 3.8% | 67.98 ± 17.5% | not timed | not timed | 404.49 ± 11.5% | | 1.00 | 1.75 | 5.95 |
| wild/dot-star-capture/rust-src-tools | 6 | 995.59 ± 1.2% | not timed | not timed | 284.12 ± 3.2% | 12.84 ± 1.1% | not timed | not timed | 993.50 ± 1.8% | | 1.00 | 3.50 | 77.52 |
| wild/ruff/noqa | 84 | 427.56 ± 1.1% | not timed | not timed | 434.68 ± 0.9% | 19.19 ± 2.5% | not timed | not timed | 428.48 ± 1.7% | | 1.00 | 0.98 | 22.28 |
| wild/ruff/unnecessary-coding-comment | 16 | 470.34 ± 5.5% | not timed | not timed | 567.57 ± 6.5% | 119.60 ± 11.0% | not timed | not timed | 471.05 ± 4.5% | | 1.00 | 0.83 | 3.93 |
| wild/ruff/string-quote-prefix | 2972 | 432.55 ± 1.2% | not timed | not timed | 402.16 ± 6.2% | 267.90 ± 25.5% | not timed | not timed | 432.72 ± 0.5% | | 1.00 | 1.08 | 1.61 |
| wild/ruff/space-around-operator | 1224378 | 198.51 ± 1.8% | not timed | not timed | 188.97 ± 1.6% | 16.30 ± 2.0% | not timed | not timed | 198.46 ± 1.9% | | 1.00 | 1.05 | 12.18 |
| wild/ruff/shebang | 282 | 425.92 ± 0.7% | not timed | not timed | 324.10 ± 0.9% | 101.55 ± 11.4% | not timed | not timed | 427.49 ± 1.0% | | 1.00 | 1.31 | 4.19 |
| wild/rustsec-cargo-audit/original-unix | 471 | 12558.45 ± 1.8% | not timed | not timed | 14049.89 ± 0.8% | 6096.41 ± 2.2% | not timed | not timed | 12576.45 ± 1.1% | | 1.00 | 0.89 | 2.06 |
| wild/rustsec-cargo-audit/original-windows | 462 | 11919.80 ± 0.8% | not timed | not timed | 13586.76 ± 1.6% | 5734.72 ± 2.2% | not timed | not timed | 11872.82 ± 1.1% | | 1.00 | 0.88 | 2.08 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 12529.79 ± 2.1% | not timed | not timed | 13767.56 ± 1.0% | 5824.01 ± 3.3% | not timed | not timed | 12562.37 ± 2.8% | | 1.00 | 0.91 | 2.15 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 10899.20 ± 1.1% | not timed | not timed | 13789.77 ± 0.6% | 6006.28 ± 1.3% | not timed | not timed | 10941.29 ± 1.6% | | 1.00 | 0.79 | 1.81 |
| wild/url/search | 234965 | 109.32 ± 13.0% | not timed | not timed | 56.85 ± 0.3% | 2.01 ± 0.7% | not timed | not timed | 112.33 ± 13.1% | | 0.97 | 1.92 | 54.29 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 68.8% | not timed | not timed | 0.01 ± 8.2% | 0.01 ± 26.9% | not timed | not timed | 0.02 ± 0.5% | | 0.99 | 3.34 | 4.03 |
| dictionary/compile/english-15 | 1 | 0.28 ± 20.3% | not timed | not timed | 0.06 ± 2.1% | 0.10 ± 11.2% | not timed | not timed | 0.28 ± 0.9% | | 0.99 | 4.46 | 2.92 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.20 ± 3.6% | not timed | not timed | 0.02 ± 1.7% | 29.43 ± 8.4% | not timed | not timed | 0.20 ± 18.0% | | 1.00 | 10.67 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 34.90 ± 13.0% | not timed | not timed | 11.85 ± 3.9% | 51.28 ± 14.5% | not timed | not timed | 35.98 ± 4.7% | | 0.97 | 2.94 | 0.68 |
| reported/i787-keywords/compile | 1 | 34.18 ± 4.4% | not timed | not timed | 1.70 ± 1.0% | 15.51 ± 36.7% | not timed | not timed | 34.24 ± 5.1% | | 1.00 | 20.06 | 2.20 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 337.29 ± 27.9% | not timed | not timed | 128.91 ± 0.9% | 523.93 ± 10.2% | not timed | not timed | 338.24 ± 1.2% | | 1.00 | 2.62 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.03 ± 7.4% | not timed | not timed | 3.62 ± 0.6% | 38.64 ± 26.9% | not timed | not timed | 46.71 ± 11.4% | | 1.01 | 13.00 | 1.22 |
| unicode/compile/one-letter | 53 | 5.84 ± 22.7% | not timed | not timed | 4.63 ± 1.4% | 52.77 ± 7.3% | not timed | not timed | 5.89 ± 3.9% | | 0.99 | 1.26 | 0.11 |
| unicode/compile/fifty-letters | 1 | 0.89 ± 5.5% | not timed | not timed | 0.10 ± 1.1% | 57.05 ± 16.0% | not timed | not timed | 0.89 ± 4.3% | | 1.00 | 8.74 | 0.0156 |
| unicode/compile/fifty-letters-ascii | 1 | 194.55 ± 2.8% | not timed | not timed | 52.80 ± 4.7% | 183.61 ± 35.0% | not timed | not timed | 190.31 ± 5.7% | | 1.02 | 3.68 | 1.06 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 386.84 ± 1.4% | not timed | not timed | 38.61 ± 1.3% | 598.60 ± 5.1% | not timed | not timed | 388.18 ± 8.2% | | 1.00 | 10.02 | 0.65 |
| unicode/compile/match-every-line-ascii | 4 | 620.89 ± 23.4% | not timed | not timed | 146.75 ± 0.6% | 590.50 ± 27.6% | not timed | not timed | 622.52 ± 24.6% | | 1.00 | 4.23 | 1.05 |
| unicode/compile/negated-class-matches-codepoint | 1 | 312.37 ± 3.1% | not timed | not timed | 41.97 ± 1.0% | 1120.31 ± 12.9% | not timed | not timed | 316.31 ± 26.8% | | 0.99 | 7.44 | 0.28 |
| wild/bibleref/compile | 3 | 4.77 ± 13.8% | not timed | not timed | 1.76 ± 0.9% | 28.16 ± 15.3% | not timed | not timed | 5.08 ± 22.2% | | 0.94 | 2.72 | 0.17 |
| wild/url/compile | 1 | 0.60 ± 13.5% | not timed | not timed | 0.14 ± 2.9% | 0.38 ± 14.7% | not timed | not timed | 0.60 ± 12.7% | | 1.00 | 4.45 | 1.60 |

