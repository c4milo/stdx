# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507059900 |
| Date | 2026-11-25 |
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
| literal: a word | 217 | 49484.23 ± 4.0% | 4007.86 ± 1.8% | 31.10 ± 1.6% | 38397.57 ± 0.3% | 12374.64 ± 6.5% | 12.76 ± 2.4% | 103.54 ± 6.4% | 49428.01 ± 0.2% | 12.35 | 1.00 | 1.29 | 4.00 |
| literal: a word that is not there | 0 | 64541.47 ± 1.3% | 3895.95 ± 6.5% | 31.18 ± 0.3% | 45811.19 ± 1.7% | 44006.87 ± 3.8% | 12.61 ± 0.1% | 98.78 ± 42.6% | 64617.72 ± 0.5% | 16.57 | 1.00 | 1.41 | 1.47 |
| literal: one of four words | 661 | 16738.41 ± 0.4% | 1695.79 ± 0.3% | 16.98 ± 1.0% | 11185.48 ± 0.2% | 24.94 ± 0.2% | 4.47 ± 0.1% | 8.66 ± 0.2% | 16948.22 ± 0.3% | 9.87 | 0.99 | 1.50 | 671.17 |
| literal: a word in any case | 217 | 42762.88 ± 0.4% | 1812.44 ± 3.9% | 24.12 ± 0.5% | 11403.33 ± 1.0% | 47.30 ± 0.4% | refused | differs | 42818.39 ± 0.2% | 23.59 | 1.00 | 3.75 | 904.08 |
| literal: an href attribute | 33 | 41608.97 ± 7.6% | 615.73 ± 0.3% | 30.00 ± 5.3% | 35026.96 ± 0.2% | 3021.27 ± 7.8% | 9.54 ± 0.3% | 91.54 ± 0.4% | 41835.66 ± 0.4% | 67.58 | 0.99 | 1.19 | 13.77 |
| literal: a word, second text | 123 | 50337.28 ± 0.1% | 3110.06 ± 0.9% | 31.01 ± 5.6% | 39506.18 ± 0.4% | 11347.73 ± 17.4% | 14.50 ± 1.5% | 88.74 ± 1.6% | 50327.78 ± 0.2% | 16.19 | 1.00 | 1.27 | 4.44 |
| class: two capitalized words | 1331 | 926.79 ± 0.3% | 612.23 ± 0.1% | 28.90 ± 0.3% | 575.90 ± 0.3% | 44.55 ± 10.2% | 10.94 ± 0.3% | 79.44 ± 3.2% | 927.65 ± 0.2% | 1.51 | 1.00 | 1.61 | 20.80 |
| class: a word that ends in ing | 3399 | 584.70 ± 1.1% | 585.66 ± 0.3% | 19.87 ± 11.2% | 539.02 ± 0.2% | 32.88 ± 12.6% | 6.19 ± 0.1% | 20.57 ± 0.8% | 586.10 ± 0.4% | 1.00 | 1.00 | 1.08 | 17.78 |
| class: a word in capitals | 2332 | 1157.85 ± 0.4% | 618.04 ± 0.2% | 30.59 ± 0.3% | 565.27 ± 0.6% | 47.64 ± 11.6% | 12.41 ± 0.6% | 102.50 ± 0.1% | 1160.74 ± 1.3% | 1.87 | 1.00 | 2.05 | 24.30 |
| class: a number | 8288 | 2028.00 ± 0.6% | 852.12 ± 0.3% | 30.98 ± 0.7% | 1812.97 ± 0.3% | 48.65 ± 10.9% | 0.38 ± 0.6% | 73.34 ± 0.7% | 2028.72 ± 0.3% | 2.38 | 1.00 | 1.12 | 41.69 |
| class: two capitalized words, second text | 5359 | 522.20 ± 0.2% | 530.55 ± 0.3% | 25.88 ± 0.1% | 478.58 ± 0.2% | 38.91 ± 16.5% | 12.75 ± 0.6% | 74.02 ± 0.1% | 522.67 ± 0.2% | 0.98 | 1.00 | 1.09 | 13.42 |
| other: a word between two words | 6104 | 927.07 ± 0.3% | 603.37 ± 0.2% | 25.92 ± 0.5% | 813.90 ± 0.7% | 123.68 ± 17.1% | 8.47 ± 0.3% | 82.36 ± 1.1% | 925.83 ± 0.4% | 1.54 | 1.00 | 1.14 | 7.50 |
| other: a number before a unit, second text | 1481 | 11275.25 ± 0.4% | 1073.98 ± 4.4% | 28.87 ± 6.1% | 8287.05 ± 1.7% | 45.03 ± 1.7% | 13.31 ± 1.2% | 77.73 ± 0.9% | 11245.51 ± 6.1% | 10.50 | 1.00 | 1.36 | 250.37 |
| other: a heading's start tag | 110 | 26517.87 ± 3.8% | 748.04 ± 0.3% | 30.72 ± 0.6% | 2500.81 ± 4.6% | 2018.99 ± 7.4% | 11.66 ± 0.4% | 107.27 ± 1.3% | 26432.45 ± 0.4% | 35.45 | 1.00 | 10.60 | 13.13 |
| other: a whole word | 217 | 34609.50 ± 0.3% | 608.34 ± 0.2% | 31.46 ± 0.5% | 28037.91 ± 0.4% | 54.20 ± 0.7% | 11.03 ± 0.2% | 63.36 ± 15.1% | 34690.32 ± 8.1% | 56.89 | 1.00 | 1.23 | 638.58 |
| other: a line's first word, second text | 3716 | 2797.83 ± 0.9% | 600.79 ± 1.5% | 35.11 ± 1.0% | 2311.07 ± 6.4% | 70.19 ± 3.2% | refused | refused | 2766.50 ± 1.7% | 4.66 | 1.01 | 1.21 | 39.86 |
| other: fourteen octets before an x | 87 | 38794.81 ± 0.9% | 251.18 ± 2.3% | 7.63 ± 5.5% | 3548.48 ± 0.4% | 11.54 ± 0.9% | differs | 21.46 ± 8.0% | 39072.06 ± 0.8% | 154.45 | 0.99 | 10.93 | 3361.42 |
| other: a Greek word | 21815 | 518.08 ± 0.4% | 440.85 ± 0.1% | 34.44 ± 3.2% | 305.01 ± 6.9% | 57.87 ± 10.6% | differs | refused | 519.28 ± 0.5% | 1.18 | 1.00 | 1.70 | 8.95 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 32.40 ± 0.3% | 32.44 ± 3.2% | 1.00 ± 1.1% | 19.87 ± 0.2% | 2.12 ± 0.4% | differs | 4.27 ± 4.3% | 32.38 ± 2.6% | 1.00 | 1.00 | 1.63 | 15.30 |
| a UUID | 32895 | 27.67 ± 6.8% | 27.60 ± 0.4% | 0.69 ± 8.7% | 15.13 ± 0.5% | 3.06 ± 7.3% | 0.52 ± 0.5% | 3.84 ± 6.6% | 27.70 ± 7.6% | 1.00 | 1.00 | 1.83 | 9.06 |
| an IPv4 address | 33176 | 40.56 ± 0.4% | 40.59 ± 0.3% | 2.22 ± 9.4% | 28.39 ± 0.3% | 6.98 ± 1.3% | differs | 3.90 ± 3.0% | 40.60 ± 0.5% | 1.00 | 1.00 | 1.43 | 5.81 |
| a date and time | 32954 | 37.99 ± 0.6% | 38.03 ± 1.2% | 1.66 ± 33.5% | 21.58 ± 0.5% | 8.05 ± 14.6% | 0.88 ± 1.2% | 8.08 ± 3.1% | 38.00 ± 0.7% | 1.00 | 1.00 | 1.76 | 4.72 |
| a field path | 32606 | 34.68 ± 3.4% | 34.21 ± 2.7% | 1.05 ± 2.4% | 22.94 ± 0.6% | 3.47 ± 2.9% | differs | 3.08 ± 0.2% | 34.40 ± 9.9% | 1.01 | 1.01 | 1.51 | 9.99 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.58 ± 0.8% | 10.84 ± 9.2% | 10.88 ± 0.9% | 13.39 ± 1.8% | 5.87 ± 2.1% | 0.75 ± 0.3% | none | 10.88 ± 1.2% | 0.98 | 0.97 | 0.79 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 255.61 ± 0.3% | 255.73 ± 2.7% | 298.96 ± 0.3% | 101.30 ± 1.3% | 240.00 ± 11.7% | 712.85 ± 3.1% | 4955.40 ± 0.4% | 255.69 ± 0.6% | 1.00 | 1.00 | 2.52 | 1.07 |
| a UUID | 62 | 167.81 ± 6.3% | 167.16 ± 1.5% | 187.84 ± 5.9% | 58.44 ± 1.1% | 118.52 ± 1.7% | 248.05 ± 4.6% | 5469.71 ± 20.3% | 168.22 ± 1.2% | 1.00 | 1.00 | 2.87 | 1.42 |
| an IPv4 address | 29 | 497.97 ± 1.6% | 496.93 ± 1.5% | 689.11 ± 2.5% | 87.30 ± 12.1% | 143.51 ± 5.0% | 414.02 ± 5.1% | 8877.22 ± 2.6% | 492.50 ± 1.6% | 1.00 | 1.01 | 5.70 | 3.47 |
| a date and time | 56 | 358.19 ± 1.7% | 358.35 ± 8.4% | 447.64 ± 2.0% | 86.38 ± 1.3% | 157.31 ± 16.6% | 478.48 ± 0.7% | 5703.40 ± 0.2% | 358.25 ± 7.7% | 1.00 | 1.00 | 4.15 | 2.28 |
| a field path | 39 | 252.58 ± 1.4% | 252.14 ± 0.8% | 294.24 ± 4.4% | 93.38 ± 4.6% | 225.23 ± 4.9% | 732.53 ± 2.4% | 6126.92 ± 0.6% | 252.41 ± 0.3% | 1.00 | 1.00 | 2.70 | 1.12 |
| literal: a word | 7 | 735.73 ± 0.4% | 788.09 ± 0.8% | 1385.21 ± 0.3% | 644.62 ± 2.1% | 766.24 ± 9.0% | 1615.88 ± 0.4% | 34849.54 ± 0.5% | 734.11 ± 0.7% | 0.93 | 1.00 | 1.14 | 0.96 |
| literal: a word that is not there | 8 | 709.07 ± 1.0% | 762.14 ± 17.6% | 1316.73 ± 0.3% | 587.17 ± 0.8% | 745.56 ± 0.9% | 1505.44 ± 1.1% | 34129.06 ± 0.4% | 710.30 ± 0.9% | 0.93 | 1.00 | 1.21 | 0.95 |
| literal: one of four words | 26 | 271.04 ± 0.7% | 453.17 ± 0.9% | 609.95 ± 0.5% | 53.14 ± 4.7% | 285.84 ± 32.4% | 564.17 ± 8.0% | 17955.02 ± 3.8% | 270.20 ± 10.4% | 0.60 | 1.00 | 5.10 | 0.95 |
| literal: a word in any case | 11 | 499.78 ± 0.5% | 530.94 ± 0.3% | 752.23 ± 5.5% | 18.80 ± 0.7% | 808.56 ± 12.0% | refused | 27922.02 ± 0.3% | 498.64 ± 0.2% | 0.94 | 1.00 | 26.58 | 0.62 |
| literal: an href attribute | 12 | 407.58 ± 0.9% | 420.76 ± 9.3% | 552.28 ± 0.2% | 51.31 ± 0.7% | 562.56 ± 1.8% | 1259.22 ± 0.5% | 24225.56 ± 0.3% | 407.17 ± 0.5% | 0.97 | 1.00 | 7.94 | 0.72 |
| literal: a word, second text | 10 | 659.59 ± 1.0% | 718.65 ± 15.1% | 1176.68 ± 5.6% | 542.29 ± 0.8% | 641.27 ± 2.6% | 1323.76 ± 0.6% | 32308.14 ± 1.0% | 660.05 ± 0.5% | 0.92 | 1.00 | 1.22 | 1.03 |
| class: two capitalized words | 23 | 514.40 ± 0.3% | 552.90 ± 0.9% | 794.40 ± 4.1% | 124.37 ± 3.2% | 590.25 ± 9.2% | 1277.58 ± 0.8% | 8150.73 ± 14.5% | 513.56 ± 0.6% | 0.93 | 1.00 | 4.14 | 0.87 |
| class: a word that ends in ing | 9 | 637.28 ± 1.2% | 727.05 ± 0.4% | 1249.19 ± 0.3% | 152.18 ± 10.0% | 838.31 ± 1.6% | 1903.74 ± 11.0% | 19432.44 ± 1.0% | 637.36 ± 0.9% | 0.88 | 1.00 | 4.19 | 0.76 |
| class: a word in capitals | 16 | 572.76 ± 1.1% | 619.77 ± 1.5% | 982.45 ± 0.2% | 159.03 ± 0.9% | 875.03 ± 1.5% | 1788.39 ± 3.1% | 10706.49 ± 0.3% | 572.95 ± 0.4% | 0.92 | 1.00 | 3.60 | 0.65 |
| class: a number | 6 | 720.02 ± 0.4% | 797.03 ± 0.9% | 1471.65 ± 0.7% | 47.22 ± 0.7% | 1575.68 ± 25.3% | 3016.01 ± 1.8% | 26119.20 ± 0.3% | 721.10 ± 0.2% | 0.90 | 1.00 | 15.25 | 0.46 |
| class: two capitalized words, second text | 23 | 512.52 ± 0.8% | 553.02 ± 0.7% | 794.30 ± 0.6% | 121.21 ± 1.4% | 589.81 ± 2.3% | 1273.86 ± 0.5% | 8141.46 ± 0.6% | 513.00 ± 1.6% | 0.93 | 1.00 | 4.23 | 0.87 |
| other: a word between two words | 13 | 626.41 ± 2.8% | 654.41 ± 1.1% | 1016.77 ± 1.4% | 159.11 ± 1.6% | 559.85 ± 21.9% | 1325.87 ± 1.9% | 17953.67 ± 1.8% | 621.44 ± 1.7% | 0.96 | 1.01 | 3.94 | 1.12 |
| other: a number before a unit, second text | 15 | 456.52 ± 0.5% | 509.79 ± 0.6% | 708.29 ± 0.8% | 43.94 ± 1.4% | 713.59 ± 1.4% | 1448.75 ± 2.5% | 17944.38 ± 0.2% | 455.32 ± 0.6% | 0.90 | 1.00 | 10.39 | 0.64 |
| other: a heading's start tag | 13 | 413.24 ± 0.2% | 420.58 ± 9.2% | 559.14 ± 0.7% | 48.09 ± 0.4% | 696.87 ± 1.8% | 1426.25 ± 0.5% | 20710.66 ± 0.4% | 411.48 ± 8.8% | 0.98 | 1.00 | 8.59 | 0.59 |
| other: a whole word | 11 | 649.40 ± 0.4% | 688.06 ± 0.4% | 1119.26 ± 1.1% | 145.38 ± 0.8% | 651.48 ± 3.5% | 1396.23 ± 8.5% | 32065.60 ± 1.7% | 649.12 ± 2.2% | 0.94 | 1.00 | 4.47 | 1.00 |
| other: a line's first word, second text | 17 | 598.24 ± 0.5% | 632.02 ± 0.8% | 991.89 ± 1.3% | 149.76 ± 10.1% | 787.53 ± 16.3% | refused | refused | 600.63 ± 1.7% | 0.95 | 1.00 | 3.99 | 0.76 |
| other: fourteen octets before an x | 16 | 117.16 ± 3.4% | 175.29 ± 0.5% | 205.82 ± 0.3% | 18.09 ± 0.8% | 515.42 ± 13.3% | 556.88 ± 12.6% | 15682.88 ± 0.5% | 117.01 ± 0.2% | 0.67 | 1.00 | 6.47 | 0.23 |
| other: a Greek word | 8 | 478.51 ± 0.3% | 677.14 ± 14.3% | 1123.79 ± 1.0% | 63.43 ± 11.3% | 1571.80 ± 1.9% | 2843.86 ± 0.1% | refused | 478.54 ± 8.4% | 0.71 | 1.00 | 7.54 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37074.75 ± 10.5% | not timed | not timed | 33816.41 ± 1.4% | 2871.50 ± 5.5% | not timed | not timed | 36892.79 ± 4.3% | | 1.00 | 1.10 | 12.91 |
| 01-literal/sherlock-casei-en | 522 | 29540.82 ± 13.9% | not timed | not timed | 9002.58 ± 0.3% | 34.04 ± 2.1% | not timed | not timed | 29538.57 ± 0.4% | | 1.00 | 3.28 | 867.80 |
| 01-literal/sherlock-ru | 724 | 38873.75 ± 0.3% | not timed | not timed | 34378.60 ± 0.8% | 1286.46 ± 2.6% | not timed | not timed | 38792.50 ± 0.4% | | 1.00 | 1.13 | 30.22 |
| 01-literal/sherlock-casei-ru | 746 | 12420.57 ± 1.3% | not timed | not timed | 7822.36 ± 0.4% | 37.79 ± 4.3% | not timed | not timed | 12414.71 ± 0.7% | | 1.00 | 1.59 | 328.63 |
| 01-literal/sherlock-zh | 30 | 60727.90 ± 1.1% | not timed | not timed | 42805.70 ± 0.8% | 1633.13 ± 0.9% | not timed | not timed | 60808.45 ± 1.0% | | 1.00 | 1.42 | 37.19 |
| 02-literal-alternate/sherlock-en | 714 | 15610.79 ± 0.7% | not timed | not timed | 10873.54 ± 0.3% | 19.05 ± 9.4% | not timed | not timed | 15663.49 ± 0.1% | | 1.00 | 1.44 | 819.27 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5114.01 ± 4.2% | not timed | not timed | 2308.85 ± 0.2% | 12.27 ± 0.2% | not timed | not timed | 5097.14 ± 3.9% | | 1.00 | 2.21 | 416.80 |
| 02-literal-alternate/sherlock-ru | 899 | 10829.19 ± 0.6% | not timed | not timed | 9777.60 ± 0.4% | 25.52 ± 0.4% | not timed | not timed | 10820.40 ± 0.6% | | 1.00 | 1.11 | 424.42 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2528.69 ± 3.0% | not timed | not timed | 1198.16 ± 0.7% | 10.60 ± 0.3% | not timed | not timed | 2529.72 ± 4.0% | | 1.00 | 2.11 | 238.63 |
| 02-literal-alternate/sherlock-zh | 207 | 20818.71 ± 0.3% | not timed | not timed | 12656.00 ± 0.4% | 35.17 ± 1.7% | not timed | not timed | 20825.23 ± 1.2% | | 1.00 | 1.64 | 591.95 |
| 03-date/ascii | 111817 | 147.06 ± 1.0% | not timed | not timed | 100.32 ± 0.4% | 0.23 ± 3.5% | not timed | not timed | 148.01 ± 1.7% | | 0.99 | 1.47 | 637.43 |
| 04-ruff-noqa/real | 84 | 513.61 ± 8.0% | not timed | not timed | 500.23 ± 4.3% | 20.41 ± 8.2% | not timed | not timed | 514.11 ± 1.3% | | 1.00 | 1.03 | 25.16 |
| 04-ruff-noqa/tweaked | 44 | 649.61 ± 1.3% | not timed | not timed | 514.16 ± 0.4% | 365.77 ± 1.2% | not timed | not timed | 653.37 ± 0.9% | | 0.99 | 1.26 | 1.78 |
| 05-lexer-veryl/single | 124800 | 4.76 ± 2.4% | not timed | not timed | 5.46 ± 0.3% | 0.26 ± 3.1% | not timed | not timed | 4.83 ± 4.7% | | 0.99 | 0.87 | 18.67 |
| 06-cloud-flare-redos/original | 107 | 430.71 ± 0.4% | not timed | not timed | 228.76 ± 1.5% | 25.44 ± 5.8% | not timed | not timed | 432.57 ± 0.2% | | 1.00 | 1.88 | 16.93 |
| 06-cloud-flare-redos/simplified-short | 102 | 418.10 ± 0.7% | not timed | not timed | 236.54 ± 1.3% | 27.28 ± 0.8% | not timed | not timed | 419.43 ± 0.9% | | 1.00 | 1.77 | 15.33 |
| 06-cloud-flare-redos/simplified-long | 10000 | 531.44 ± 0.3% | not timed | not timed | 259.49 ± 0.2% | 29.58 ± 0.5% | not timed | not timed | 528.96 ± 0.2% | | 1.00 | 2.05 | 17.97 |
| 07-unicode-character-data/parse-line | 558784 | 249.75 ± 3.1% | not timed | not timed | 191.17 ± 0.2% | 46.24 ± 7.8% | not timed | not timed | 178.60 ± 8.1% | | 1.40 | 1.31 | 5.40 |
| 08-words/all-english | 56691 | 134.01 ± 0.6% | not timed | not timed | 84.14 ± 0.9% | 13.62 ± 4.9% | not timed | not timed | 135.06 ± 0.7% | | 0.99 | 1.59 | 9.84 |
| 08-words/long-english | 839 | 618.98 ± 0.3% | not timed | not timed | 584.22 ± 0.2% | 35.20 ± 1.5% | not timed | not timed | 619.13 ± 0.1% | | 1.00 | 1.06 | 17.58 |
| 09-aws-keys/full | 0 | 515.64 ± 0.3% | not timed | not timed | 543.30 ± 0.4% | 53.19 ± 0.3% | not timed | not timed | 522.35 ± 0.5% | | 0.99 | 0.95 | 9.69 |
| 09-aws-keys/quick | 0 | 1154.60 ± 0.8% | not timed | not timed | 963.45 ± 0.8% | 393.64 ± 5.9% | not timed | not timed | 1155.86 ± 0.2% | | 1.00 | 1.20 | 2.93 |
| 10-bounded-repeat/letters-en | 1833 | 676.44 ± 0.7% | not timed | not timed | 556.50 ± 2.6% | 23.00 ± 0.8% | not timed | not timed | 679.60 ± 2.3% | | 1.00 | 1.22 | 29.41 |
| 10-bounded-repeat/letters-ru | 3475 | 524.59 ± 1.4% | not timed | not timed | 481.03 ± 0.6% | 24.53 ± 20.4% | not timed | not timed | 528.09 ± 1.5% | | 0.99 | 1.09 | 21.39 |
| 10-bounded-repeat/context | 53 | 90.57 ± 1.3% | not timed | not timed | 70.66 ± 1.8% | 22.77 ± 1.0% | not timed | not timed | 89.69 ± 1.5% | | 1.01 | 1.28 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 638.71 ± 8.2% | not timed | not timed | 604.11 ± 0.1% | 40.04 ± 7.8% | not timed | not timed | 637.79 ± 12.7% | | 1.00 | 1.06 | 15.95 |
| 11-unstructured-to-json/extract | 600 | 52.08 ± 13.7% | not timed | not timed | 80.32 ± 0.5% | 34.19 ± 47.2% | not timed | not timed | 51.48 ± 9.4% | | 1.01 | 0.65 | 1.52 |
| 12-dictionary/single | 1 | 514.95 ± 0.9% | not timed | not timed | 484.07 ± 0.1% | 0.39 ± 5.4% | not timed | not timed | 513.45 ± 0.8% | | 1.00 | 1.06 | 1328.31 |
| 14-quadratic/1x | 100 | 26.22 ± 2.7% | not timed | not timed | 12.18 ± 8.2% | 1.00 ± 2.2% | not timed | not timed | 26.18 ± 1.1% | | 1.00 | 2.15 | 26.32 |
| 14-quadratic/2x | 200 | 19.84 ± 6.1% | not timed | not timed | 6.12 ± 2.5% | 0.54 ± 8.9% | not timed | not timed | 19.81 ± 1.0% | | 1.00 | 3.24 | 36.46 |
| 14-quadratic/10x | 1000 | 6.85 ± 19.6% | not timed | not timed | 1.21 ± 0.7% | 0.12 ± 1.7% | not timed | not timed | 6.86 ± 5.1% | | 1.00 | 5.65 | 58.93 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.38 ± 4.4% | not timed | not timed | 0.48 ± 1.2% | 0.63 ± 6.1% | not timed | not timed | 1.38 ± 5.9% | | 1.00 | 2.89 | 2.19 |
| 04-ruff-noqa/compile-real | 1 | 119.11 ± 6.6% | not timed | not timed | 17.43 ± 1.2% | 165.84 ± 10.9% | not timed | not timed | 119.33 ± 0.9% | | 1.00 | 6.83 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 16.23 ± 1.4% | not timed | not timed | 2.99 ± 1.1% | 7.81 ± 3.0% | not timed | not timed | 16.32 ± 0.4% | | 0.99 | 5.43 | 2.08 |
| 07-unicode-character-data/compile | 1 | 123.01 ± 1.4% | not timed | not timed | 30.83 ± 0.4% | 44.24 ± 14.1% | not timed | not timed | 124.36 ± 1.2% | | 0.99 | 3.99 | 2.78 |
| 09-aws-keys/compile-full | 1 | 55.49 ± 10.0% | not timed | not timed | 9.99 ± 0.6% | 27.68 ± 1.5% | not timed | not timed | 55.26 ± 9.9% | | 1.00 | 5.56 | 2.01 |
| 09-aws-keys/compile-quick | 1 | 198.27 ± 9.5% | not timed | not timed | 59.28 ± 0.8% | 154.00 ± 4.0% | not timed | not timed | 197.42 ± 0.4% | | 1.00 | 3.34 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 60.73 ± 1.4% | not timed | not timed | 14.67 ± 1.0% | 20.36 ± 3.3% | not timed | not timed | 60.43 ± 7.6% | | 1.01 | 4.14 | 2.98 |
| 10-bounded-repeat/compile-capitals | 1 | 94.95 ± 1.2% | not timed | not timed | 10.48 ± 0.8% | 29.08 ± 12.5% | not timed | not timed | 94.67 ± 0.9% | | 1.00 | 9.06 | 3.27 |
| 11-unstructured-to-json/compile | 1 | 191.35 ± 1.7% | not timed | not timed | 47.54 ± 0.6% | 77.27 ± 23.1% | not timed | not timed | 191.56 ± 1.0% | | 1.00 | 4.03 | 2.48 |
| 12-dictionary/compile-single | 1 | 0.34 ± 1.3% | not timed | not timed | 0.08 ± 6.3% | 0.12 ± 18.1% | not timed | not timed | 0.34 ± 4.2% | | 1.00 | 4.21 | 2.97 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.23 ± 0.8% | not timed | not timed | 6.69 ± 17.2% | 0.60 ± 8.7% | not timed | not timed | 7.34 ± 20.1% | | 0.99 | 1.08 | 11.98 |
| dictionary/search/english-10 | 690 | 1.30 ± 3.0% | not timed | not timed | 153.23 ± 6.6% | 0.01 ± 1.2% | not timed | not timed | 1.30 ± 1.5% | | 1.00 | 0.0085 | 187.91 |
| dictionary/search/english-15 | 15 | 514.17 ± 0.9% | not timed | not timed | 480.02 ± 0.1% | 0.36 ± 7.4% | not timed | not timed | 513.87 ± 0.8% | | 1.00 | 1.07 | 1414.76 |
| folly/awyer-inn-busted | 1 | 4251.42 ± 0.2% | not timed | not timed | 130.50 ± 0.2% | 48.51 ± 1.0% | not timed | not timed | 4249.21 ± 0.4% | | 1.00 | 32.58 | 87.64 |
| folly/literal-never-match-rare | 0 | 67734.52 ± 1.6% | not timed | not timed | 46499.14 ± 1.0% | 69248.95 ± 1.3% | not timed | not timed | 67886.02 ± 0.5% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 28640.11 ± 10.4% | not timed | not timed | 46079.61 ± 0.4% | 2583.96 ± 0.2% | not timed | not timed | 28516.36 ± 19.8% | | 1.00 | 0.62 | 11.08 |
| folly/literal-never-match-tricksy | 1 | 3988.18 ± 1.3% | not timed | not timed | 6143.39 ± 0.3% | 1721.10 ± 0.5% | not timed | not timed | 3981.21 ± 0.8% | | 1.00 | 0.65 | 2.32 |
| grep/every-line | 239963 | 1468.89 ± 1.4% | not timed | not timed | 972.77 ± 0.6% | 366.90 ± 24.1% | not timed | not timed | 1475.33 ± 2.1% | | 1.00 | 1.51 | 4.00 |
| grep/long-words-ascii | 5073 | 502.73 ± 0.5% | not timed | not timed | 497.01 ± 0.3% | 49.52 ± 7.3% | not timed | not timed | 502.86 ± 0.8% | | 1.00 | 1.01 | 10.15 |
| imported/leipzig/twain | 811 | 57244.15 ± 3.7% | not timed | not timed | 43310.12 ± 1.3% | 12929.41 ± 10.5% | not timed | not timed | 57519.47 ± 6.4% | | 1.00 | 1.32 | 4.43 |
| imported/leipzig/twain-insensitive | 965 | 15464.52 ± 1.5% | not timed | not timed | 13392.17 ± 1.6% | 44.52 ± 1.9% | not timed | not timed | 15438.86 ± 0.9% | | 1.00 | 1.15 | 347.33 |
| imported/leipzig/shing | 1540 | 29919.93 ± 1.1% | not timed | not timed | 21996.85 ± 1.2% | 37.62 ± 0.9% | not timed | not timed | 30200.05 ± 1.7% | | 0.99 | 1.36 | 795.26 |
| imported/leipzig/huck-saw | 262 | 24940.38 ± 0.7% | not timed | not timed | 18711.26 ± 2.1% | 35.75 ± 2.3% | not timed | not timed | 24945.61 ± 2.6% | | 1.00 | 1.33 | 697.58 |
| imported/leipzig/word-ending-nn | 262 | 608.92 ± 0.2% | not timed | not timed | 603.00 ± 0.5% | 27.08 ± 2.4% | not timed | not timed | 609.38 ± 0.1% | | 1.00 | 1.01 | 22.49 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11673.47 ± 3.1% | not timed | not timed | 3871.63 ± 0.9% | 12.16 ± 1.8% | not timed | not timed | 11891.94 ± 1.4% | | 0.98 | 3.02 | 959.85 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 22205.00 ± 1.4% | not timed | not timed | 17677.98 ± 1.2% | 19.03 ± 1.4% | not timed | not timed | 22305.95 ± 1.0% | | 1.00 | 1.26 | 1166.93 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5561.36 ± 0.5% | not timed | not timed | 791.91 ± 0.5% | 12.06 ± 2.7% | not timed | not timed | 5566.24 ± 0.6% | | 1.00 | 7.02 | 461.01 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 607.57 ± 0.6% | not timed | not timed | 601.85 ± 0.4% | 12.27 ± 1.1% | not timed | not timed | 607.79 ± 0.1% | | 1.00 | 1.01 | 49.50 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.07 ± 0.1% | not timed | not timed | 602.48 ± 0.4% | 10.47 ± 0.7% | not timed | not timed | 607.89 ± 0.3% | | 1.00 | 1.01 | 58.06 |
| imported/leipzig/tom-river | 2 | 12901.66 ± 2.0% | not timed | not timed | 13258.08 ± 1.6% | 34.94 ± 0.9% | not timed | not timed | 12921.55 ± 1.9% | | 1.00 | 0.97 | 369.29 |
| imported/leipzig/ing | 78424 | 599.27 ± 0.4% | not timed | not timed | 560.16 ± 0.1% | 30.73 ± 4.4% | not timed | not timed | 599.79 ± 0.6% | | 1.00 | 1.07 | 19.50 |
| imported/leipzig/ing-whitespace | 55248 | 731.36 ± 0.9% | not timed | not timed | 2152.99 ± 0.4% | 22.42 ± 4.4% | not timed | not timed | 741.69 ± 1.1% | | 0.99 | 0.34 | 32.62 |
| imported/leipzig/awyer-inn | 209 | 770.76 ± 1.7% | not timed | not timed | 13721.42 ± 0.3% | 24.51 ± 2.2% | not timed | not timed | 770.98 ± 1.3% | | 1.00 | 0.0562 | 31.44 |
| imported/leipzig/quotes-bounded | 8886 | 1837.74 ± 0.5% | not timed | not timed | 3282.16 ± 0.6% | 40.85 ± 3.3% | not timed | not timed | 1844.66 ± 0.3% | | 1.00 | 0.56 | 44.99 |
| imported/leipzig/non-ascii-alternate | 2 | 40503.31 ± 0.6% | not timed | not timed | 19521.09 ± 1.5% | 57.01 ± 6.8% | not timed | not timed | 40646.95 ± 1.5% | | 1.00 | 2.07 | 710.50 |
| imported/leipzig/math-symbols | 69 | 2428.49 ± 0.3% | not timed | not timed | 603.90 ± 0.5% | 39.42 ± 0.2% | not timed | not timed | 2430.61 ± 0.4% | | 1.00 | 4.02 | 61.61 |
| imported/leipzig/bounded-strings-ending-z | 0 | 610.18 ± 0.1% | not timed | not timed | 604.10 ± 0.4% | 25.72 ± 2.6% | not timed | not timed | 609.76 ± 0.3% | | 1.00 | 1.01 | 23.73 |
| imported/lh3lh3-reb/uri | 17549 | 816.51 ± 0.7% | not timed | not timed | 1132.97 ± 0.9% | 23.88 ± 2.9% | not timed | not timed | 816.30 ± 0.1% | | 1.00 | 0.72 | 34.19 |
| imported/lh3lh3-reb/email | 15057 | 809.12 ± 2.4% | not timed | not timed | 1131.07 ± 0.2% | 24.80 ± 2.1% | not timed | not timed | 809.14 ± 6.7% | | 1.00 | 0.72 | 32.63 |
| imported/lh3lh3-reb/date | 668 | 933.30 ± 0.8% | not timed | not timed | 1008.67 ± 0.5% | 51.00 ± 4.2% | not timed | not timed | 934.74 ± 26.9% | | 1.00 | 0.93 | 18.30 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 749.61 ± 2.0% | not timed | not timed | 443.56 ± 0.5% | 12.37 ± 8.6% | not timed | not timed | 751.19 ± 0.4% | | 1.00 | 1.69 | 60.62 |
| imported/mariomka/email | 92 | 42940.15 ± 7.7% | not timed | not timed | 60385.60 ± 0.7% | 35.92 ± 0.4% | not timed | not timed | 43061.74 ± 0.9% | | 1.00 | 0.71 | 1195.49 |
| imported/mariomka/uri | 5301 | 6638.30 ± 11.3% | not timed | not timed | 7878.56 ± 1.2% | 35.96 ± 0.3% | not timed | not timed | 6670.07 ± 0.6% | | 1.00 | 0.84 | 184.58 |
| imported/mariomka/ip | 5 | 1813.13 ± 3.3% | not timed | not timed | 2321.00 ± 0.2% | 23.22 ± 5.7% | not timed | not timed | 1824.25 ± 3.3% | | 0.99 | 0.78 | 78.07 |
| imported/rsc/no-exponential | 0 | 894.86 ± 21.8% | not timed | not timed | 420.79 ± 2.4% | 20.14 ± 0.8% | not timed | not timed | 898.61 ± 0.9% | | 1.00 | 2.13 | 44.42 |
| imported/rsc/literal | 1 | 895.56 ± 3.3% | not timed | not timed | 2234.79 ± 16.7% | 206.70 ± 38.4% | not timed | not timed | 859.62 ± 12.2% | | 1.04 | 0.40 | 4.33 |
| imported/rsc/not-literal | 2 | 965.59 ± 2.3% | not timed | not timed | 845.19 ± 9.8% | 52.40 ± 50.7% | not timed | not timed | 970.75 ± 0.5% | | 0.99 | 1.14 | 18.43 |
| imported/rsc/match-class | 1 | 1673.98 ± 1.9% | not timed | not timed | 1821.54 ± 0.7% | 67.46 ± 7.7% | not timed | not timed | 1672.87 ± 0.5% | | 1.00 | 0.92 | 24.81 |
| imported/rsc/match-class-in-range | 1 | 1653.13 ± 20.8% | not timed | not timed | 3419.51 ± 0.3% | 68.39 ± 7.3% | not timed | not timed | 1671.57 ± 21.5% | | 0.99 | 0.48 | 24.17 |
| imported/rsc/match-class-unicode | 1 | 571.51 ± 0.3% | not timed | not timed | 519.71 ± 0.3% | 82.27 ± 0.6% | not timed | not timed | 570.92 ± 0.5% | | 1.00 | 1.10 | 6.95 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1696.74 ± 12.5% | not timed | not timed | 1138.18 ± 23.1% | 344.90 ± 2.2% | not timed | not timed | 1699.54 ± 6.3% | | 1.00 | 1.49 | 4.92 |
| imported/rsc/anchored-literal-long-non-match | 0 | 25473.50 ± 0.4% | not timed | not timed | 17226.37 ± 1.3% | 5193.87 ± 1.5% | not timed | not timed | 25470.76 ± 0.5% | | 1.00 | 1.48 | 4.90 |
| imported/rsc/anchored-literal-short-match | 4 | 881.31 ± 1.9% | not timed | not timed | 566.78 ± 1.3% | 112.90 ± 10.8% | not timed | not timed | 889.52 ± 8.4% | | 0.99 | 1.55 | 7.81 |
| imported/rsc/anchored-literal-long-match | 4 | 13162.79 ± 1.7% | not timed | not timed | 8626.51 ± 0.2% | 1616.94 ± 3.0% | not timed | not timed | 13320.06 ± 2.3% | | 0.99 | 1.53 | 8.14 |
| imported/rsc/one-pass-short | 17 | 471.07 ± 19.2% | not timed | not timed | 260.62 ± 1.1% | 38.03 ± 12.2% | not timed | not timed | 502.23 ± 2.3% | | 0.94 | 1.81 | 12.39 |
| imported/rsc/one-pass-short-not | 17 | 326.79 ± 2.6% | not timed | not timed | 265.25 ± 2.1% | 35.11 ± 18.0% | not timed | not timed | 325.73 ± 4.1% | | 1.00 | 1.23 | 9.31 |
| imported/rsc/one-pass-long-prefix | 26 | 444.02 ± 6.7% | not timed | not timed | 309.48 ± 1.2% | 126.03 ± 15.2% | not timed | not timed | 443.24 ± 2.2% | | 1.00 | 1.43 | 3.52 |
| imported/rsc/one-pass-long-prefix-not | 26 | 438.59 ± 2.3% | not timed | not timed | 324.37 ± 6.4% | 85.27 ± 11.2% | not timed | not timed | 451.98 ± 0.7% | | 0.97 | 1.35 | 5.14 |
| imported/rsc/long-needle1 | 31 | 68183.87 ± 0.4% | not timed | not timed | 45837.21 ± 0.7% | 4.10 ± 2.1% | not timed | not timed | 68067.46 ± 1.0% | | 1.00 | 1.49 | 16643.14 |
| imported/rsc/long-needle2 | 31 | 67674.06 ± 0.5% | not timed | not timed | 226.90 ± 0.4% | 4.10 ± 4.1% | not timed | not timed | 67519.75 ± 9.8% | | 1.00 | 298.26 | 16525.94 |
| imported/rsc/easy0-32 | 26 | 1266.69 ± 24.1% | not timed | not timed | 1921.77 ± 21.2% | 142.93 ± 27.1% | not timed | not timed | 1269.63 ± 1.9% | | 1.00 | 0.66 | 8.86 |
| imported/rsc/easy0-1k | 26 | 21395.19 ± 0.7% | not timed | not timed | 20394.85 ± 0.8% | 1997.04 ± 67.7% | not timed | not timed | 21440.26 ± 4.1% | | 1.00 | 1.05 | 10.71 |
| imported/rsc/easy0-32k | 26 | 64611.32 ± 6.2% | not timed | not timed | 43890.90 ± 1.6% | 25642.12 ± 41.3% | not timed | not timed | 64724.83 ± 11.4% | | 1.00 | 1.47 | 2.52 |
| imported/rsc/easy0-1mb | 26 | 66239.39 ± 0.7% | not timed | not timed | 46313.31 ± 0.5% | 68529.59 ± 0.4% | not timed | not timed | 66195.24 ± 0.3% | | 1.00 | 1.43 | 0.97 |
| imported/rsc/easy1-32 | 19 | 919.86 ± 8.2% | not timed | not timed | 753.18 ± 0.5% | 129.38 ± 37.8% | not timed | not timed | 931.44 ± 0.8% | | 0.99 | 1.22 | 7.11 |
| imported/rsc/easy1-1k | 19 | 18680.89 ± 4.6% | not timed | not timed | 15654.74 ± 3.2% | 2374.25 ± 38.4% | not timed | not timed | 19019.94 ± 5.0% | | 0.98 | 1.19 | 7.87 |
| imported/rsc/easy1-32k | 19 | 596832.64 ± 1.4% | not timed | not timed | 489191.19 ± 1.4% | 29376.77 ± 24.6% | not timed | not timed | 598825.21 ± 8.2% | | 1.00 | 1.22 | 20.32 |
| imported/rsc/easy1-1mb | 19 | 19127012.44 ± 1.4% | not timed | not timed | 15565557.57 ± 1.2% | 68628.30 ± 0.3% | not timed | not timed | 19183167.99 ± 0.5% | | 1.00 | 1.23 | 278.70 |
| imported/rsc/medium-32 | 27 | 868.74 ± 7.6% | not timed | not timed | 739.15 ± 0.6% | 74.13 ± 31.1% | not timed | not timed | 870.86 ± 10.1% | | 1.00 | 1.18 | 11.72 |
| imported/rsc/medium-1k | 27 | 15538.01 ± 0.5% | not timed | not timed | 13214.48 ± 0.5% | 82.23 ± 32.3% | not timed | not timed | 15514.42 ± 1.1% | | 1.00 | 1.18 | 188.96 |
| imported/rsc/medium-32k | 27 | 485497.66 ± 0.6% | not timed | not timed | 402453.97 ± 0.3% | 54.32 ± 1.9% | not timed | not timed | 483348.66 ± 0.8% | | 1.00 | 1.21 | 8937.73 |
| imported/rsc/medium-1mb | 27 | 15538905.30 ± 13.0% | not timed | not timed | 13079779.57 ± 0.3% | 54.90 ± 1.3% | not timed | not timed | 15503446.73 ± 0.5% | | 1.00 | 1.19 | 283064.41 |
| imported/rsc/hard-32 | 58 | 446.08 ± 7.5% | not timed | not timed | 391.97 ± 1.0% | 49.74 ± 7.4% | not timed | not timed | 445.30 ± 7.8% | | 1.00 | 1.14 | 8.97 |
| imported/rsc/hard-1k | 27 | 14783.13 ± 9.0% | not timed | not timed | 12886.59 ± 1.2% | 44.06 ± 15.3% | not timed | not timed | 14902.53 ± 0.6% | | 0.99 | 1.15 | 335.53 |
| imported/rsc/hard-32k | 27 | 462679.47 ± 1.2% | not timed | not timed | 406322.99 ± 0.6% | 33.07 ± 0.4% | not timed | not timed | 464812.89 ± 0.4% | | 1.00 | 1.14 | 13991.62 |
| imported/rsc/hard-1mb | 51 | 8932901.71 ± 2.4% | not timed | not timed | 7834098.13 ± 5.1% | 33.20 ± 11.3% | not timed | not timed | 8956503.70 ± 7.4% | | 1.00 | 1.14 | 269099.94 |
| imported/rsc/reallyhard0-32 | 58 | 282.45 ± 0.4% | not timed | not timed | 240.01 ± 0.5% | 51.84 ± 37.5% | not timed | not timed | 282.48 ± 2.5% | | 1.00 | 1.18 | 5.45 |
| imported/rsc/reallyhard0-1k | 27 | 591.50 ± 0.3% | not timed | not timed | 580.79 ± 0.4% | 44.54 ± 1.1% | not timed | not timed | 590.52 ± 2.0% | | 1.00 | 1.02 | 13.28 |
| imported/rsc/reallyhard0-32k | 27 | 608.27 ± 0.2% | not timed | not timed | 602.90 ± 0.2% | 32.92 ± 19.6% | not timed | not timed | 608.22 ± 0.2% | | 1.00 | 1.01 | 18.48 |
| imported/rsc/reallyhard0-1mb | 51 | 609.85 ± 0.1% | not timed | not timed | 604.46 ± 0.6% | 33.15 ± 0.2% | not timed | not timed | 609.45 ± 0.7% | | 1.00 | 1.01 | 18.40 |
| imported/rsc/reallyreallyhard0-32 | 47 | 336.16 ± 15.6% | not timed | not timed | 208.72 ± 0.3% | 58.27 ± 16.2% | not timed | not timed | 335.15 ± 7.0% | | 1.00 | 1.61 | 5.77 |
| imported/rsc/reallyreallyhard0-1k | 16 | 8198.67 ± 0.4% | not timed | not timed | 7727.29 ± 13.4% | 36.80 ± 1.1% | not timed | not timed | 8205.27 ± 0.4% | | 1.00 | 1.06 | 222.80 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52443.36 ± 1.9% | not timed | not timed | 36582.31 ± 0.8% | 26.61 ± 20.1% | not timed | not timed | 52790.19 ± 3.0% | | 0.99 | 1.43 | 1971.16 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 71925.59 ± 0.3% | not timed | not timed | 45401.20 ± 34.5% | 26.95 ± 0.3% | not timed | not timed | 71669.99 ± 0.6% | | 1.00 | 1.58 | 2668.93 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 324.45 ± 15.4% | not timed | not timed | 217.36 ± 0.3% | 65.00 ± 12.2% | not timed | not timed | 323.22 ± 10.6% | | 1.00 | 1.49 | 4.99 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6826.63 ± 0.8% | not timed | not timed | 7538.74 ± 0.5% | 36.68 ± 0.7% | not timed | not timed | 6809.67 ± 5.6% | | 1.00 | 0.91 | 186.09 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 49466.81 ± 21.6% | not timed | not timed | 36783.90 ± 3.3% | 26.99 ± 0.3% | not timed | not timed | 47819.77 ± 7.3% | | 1.03 | 1.34 | 1832.55 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 65554.93 ± 0.4% | not timed | not timed | 45307.21 ± 1.8% | 27.20 ± 0.4% | not timed | not timed | 65469.10 ± 1.0% | | 1.00 | 1.45 | 2410.11 |
| imported/sherlock/name-sherlock | 776 | 50678.81 ± 2.6% | not timed | not timed | 39993.62 ± 2.1% | 12263.59 ± 25.1% | not timed | not timed | 51019.33 ± 3.1% | | 0.99 | 1.27 | 4.13 |
| imported/sherlock/name-holmes | 2766 | 27832.97 ± 1.6% | not timed | not timed | 30174.60 ± 0.8% | 4135.53 ± 1.5% | not timed | not timed | 28049.83 ± 1.1% | | 0.99 | 0.92 | 6.73 |
| imported/sherlock/name-sherlock-holmes | 1365 | 51419.03 ± 1.3% | not timed | not timed | 40195.10 ± 3.3% | 10651.94 ± 32.2% | not timed | not timed | 51533.02 ± 1.4% | | 1.00 | 1.28 | 4.83 |
| imported/sherlock/name-sherlock-casei | 816 | 46605.45 ± 0.5% | not timed | not timed | 11546.46 ± 0.6% | 33.77 ± 1.0% | not timed | not timed | 46608.06 ± 0.4% | | 1.00 | 4.04 | 1380.20 |
| imported/sherlock/name-holmes-casei | 2802 | 22631.62 ± 0.5% | not timed | not timed | 7651.46 ± 1.3% | 44.49 ± 1.3% | not timed | not timed | 22629.11 ± 0.8% | | 1.00 | 2.96 | 508.73 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36655.75 ± 0.5% | not timed | not timed | 11123.51 ± 1.0% | 33.77 ± 1.7% | not timed | not timed | 36497.06 ± 1.3% | | 1.00 | 3.30 | 1085.52 |
| imported/sherlock/name-whitespace | 1461 | 29844.93 ± 7.6% | not timed | not timed | 27366.45 ± 13.3% | 8669.60 ± 20.4% | not timed | not timed | 30226.01 ± 1.3% | | 0.99 | 1.09 | 3.44 |
| imported/sherlock/name-alt1 | 1142 | 30941.53 ± 0.9% | not timed | not timed | 29966.47 ± 0.6% | 5649.44 ± 31.4% | not timed | not timed | 31323.85 ± 1.4% | | 0.99 | 1.03 | 5.48 |
| imported/sherlock/name-alt2 | 3542 | 20663.82 ± 2.2% | not timed | not timed | 10081.19 ± 0.7% | 36.08 ± 2.9% | not timed | not timed | 21125.74 ± 1.2% | | 0.98 | 2.05 | 572.74 |
| imported/sherlock/name-alt3 | 4507 | 13525.95 ± 0.8% | not timed | not timed | 9226.69 ± 0.9% | 11.28 ± 0.5% | not timed | not timed | 13605.14 ± 0.3% | | 0.99 | 1.47 | 1199.03 |
| imported/sherlock/name-alt3-casei | 4593 | 3508.06 ± 4.3% | not timed | not timed | 1308.72 ± 0.5% | 7.56 ± 0.6% | not timed | not timed | 3562.95 ± 4.7% | | 0.98 | 2.68 | 464.28 |
| imported/sherlock/name-alt4 | 3686 | 9953.44 ± 0.9% | not timed | not timed | 7853.95 ± 0.5% | 35.96 ± 1.7% | not timed | not timed | 9967.85 ± 0.3% | | 1.00 | 1.27 | 276.82 |
| imported/sherlock/name-alt4-casei | 4254 | 5425.92 ± 1.1% | not timed | not timed | 4372.39 ± 1.7% | 20.67 ± 1.8% | not timed | not timed | 5461.41 ± 1.4% | | 0.99 | 1.24 | 262.44 |
| imported/sherlock/name-alt5 | 4028 | 16839.16 ± 0.4% | not timed | not timed | 9691.50 ± 0.6% | 24.90 ± 0.7% | not timed | not timed | 17276.54 ± 0.8% | | 0.97 | 1.74 | 676.35 |
| imported/sherlock/name-alt5-casei | 4104 | 6985.55 ± 0.6% | not timed | not timed | 3001.73 ± 21.8% | 15.43 ± 0.8% | not timed | not timed | 7009.91 ± 1.2% | | 1.00 | 2.33 | 452.87 |
| imported/sherlock/no-match-uncommon | 0 | 68542.44 ± 0.7% | not timed | not timed | 58039.25 ± 7.5% | 57394.36 ± 2.7% | not timed | not timed | 68535.94 ± 12.1% | | 1.00 | 1.18 | 1.19 |
| imported/sherlock/no-match-common | 0 | 66999.47 ± 6.1% | not timed | not timed | 58045.43 ± 0.9% | 2138.11 ± 1.6% | not timed | not timed | 67054.41 ± 0.6% | | 1.00 | 1.15 | 31.34 |
| imported/sherlock/no-match-really-common | 0 | 42916.10 ± 0.4% | not timed | not timed | 49793.09 ± 0.2% | 2156.31 ± 7.8% | not timed | not timed | 42850.97 ± 1.3% | | 1.00 | 0.86 | 19.90 |
| imported/sherlock/the-lower | 21654 | 3992.03 ± 5.3% | not timed | not timed | 4589.96 ± 3.1% | 266.21 ± 16.6% | not timed | not timed | 3936.97 ± 7.1% | | 1.01 | 0.87 | 15.00 |
| imported/sherlock/the-upper | 2223 | 20912.63 ± 1.8% | not timed | not timed | 29375.20 ± 0.3% | 3061.48 ± 11.5% | not timed | not timed | 20946.19 ± 1.8% | | 1.00 | 0.71 | 6.83 |
| imported/sherlock/the-casei | 23961 | 3481.27 ± 15.5% | not timed | not timed | 1337.21 ± 2.2% | 41.48 ± 10.2% | not timed | not timed | 3484.59 ± 0.5% | | 1.00 | 2.60 | 83.93 |
| imported/sherlock/everything-greedy | 581881 | 295.30 ± 3.7% | not timed | not timed | 172.43 ± 0.6% | 30.65 ± 28.0% | not timed | not timed | 296.01 ± 0.5% | | 1.00 | 1.71 | 9.63 |
| imported/sherlock/everything-greedy-nl | 594933 | 464.68 ± 0.3% | not timed | not timed | 225.18 ± 0.7% | 34.55 ± 0.2% | not timed | not timed | 463.87 ± 2.3% | | 1.00 | 2.06 | 13.45 |
| imported/sherlock/letters | 447175 | 61.83 ± 7.9% | not timed | not timed | 33.73 ± 2.3% | 5.86 ± 22.5% | not timed | not timed | 65.81 ± 11.7% | | 0.94 | 1.83 | 10.55 |
| imported/sherlock/letters-upper | 14180 | 444.95 ± 1.6% | not timed | not timed | 364.15 ± 2.4% | 30.36 ± 19.9% | not timed | not timed | 447.03 ± 4.6% | | 1.00 | 1.22 | 14.66 |
| imported/sherlock/letters-lower | 432995 | 67.64 ± 2.1% | not timed | not timed | 34.19 ± 1.3% | 6.60 ± 44.0% | not timed | not timed | 68.17 ± 0.7% | | 0.99 | 1.98 | 10.25 |
| imported/sherlock/words | 447639 | 123.87 ± 15.3% | not timed | not timed | 83.09 ± 0.9% | 15.62 ± 3.4% | not timed | not timed | 124.18 ± 1.4% | | 1.00 | 1.49 | 7.93 |
| imported/sherlock/before-holmes | 4073 | 15266.92 ± 0.5% | not timed | not timed | 13338.06 ± 1.8% | 25.69 ± 0.3% | not timed | not timed | 15305.93 ± 0.6% | | 1.00 | 1.14 | 594.34 |
| imported/sherlock/before-after-holmes | 2593 | 15052.68 ± 0.5% | not timed | not timed | 15036.79 ± 0.4% | 25.75 ± 0.2% | not timed | not timed | 15070.87 ± 1.1% | | 1.00 | 1.00 | 584.57 |
| imported/sherlock/holmes-cochar-watson | 150 | 10016.41 ± 2.3% | not timed | not timed | 7659.12 ± 0.1% | 35.37 ± 1.6% | not timed | not timed | 10114.63 ± 1.3% | | 0.99 | 1.31 | 283.21 |
| imported/sherlock/holmes-coword-watson | 14309 | 1268.76 ± 10.7% | not timed | not timed | 1232.44 ± 1.8% | 7.64 ± 1.1% | not timed | not timed | 1266.13 ± 1.6% | | 1.00 | 1.03 | 165.97 |
| imported/sherlock/quotes | 14437 | 1336.44 ± 3.3% | not timed | not timed | 2215.22 ± 1.6% | 37.39 ± 43.8% | not timed | not timed | 1357.65 ± 2.6% | | 0.98 | 0.60 | 35.74 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 605.05 ± 0.4% | not timed | not timed | 31208.83 ± 1.4% | 40.37 ± 2.4% | not timed | not timed | 605.73 ± 0.9% | | 1.00 | 0.0194 | 14.99 |
| imported/sherlock/word-ending-n | 35297 | 475.73 ± 2.3% | not timed | not timed | 396.11 ± 1.5% | 26.11 ± 26.4% | not timed | not timed | 473.00 ± 2.2% | | 1.01 | 1.20 | 18.22 |
| imported/sherlock/repeated-class-negation | 2130 | 18742.18 ± 0.9% | not timed | not timed | 16644.72 ± 0.5% | 12.36 ± 1.1% | not timed | not timed | 19143.09 ± 0.2% | | 0.98 | 1.13 | 1516.10 |
| imported/sherlock/ing-suffix | 20547 | 571.46 ± 1.1% | not timed | not timed | 509.05 ± 0.7% | 31.07 ± 0.7% | not timed | not timed | 571.63 ± 2.2% | | 1.00 | 1.12 | 18.40 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 606.49 ± 1.5% | not timed | not timed | 2879.65 ± 1.3% | 22.88 ± 1.2% | not timed | not timed | 606.75 ± 1.0% | | 1.00 | 0.21 | 26.51 |
| opt/accelerate/whole-line | 239963 | 503.96 ± 1.1% | not timed | not timed | 414.37 ± 0.1% | 92.19 ± 16.9% | not timed | not timed | 504.65 ± 0.4% | | 1.00 | 1.22 | 5.47 |
| opt/accelerate/non-dna | 16745 | 451.86 ± 1.0% | not timed | not timed | 437.87 ± 0.4% | 32.68 ± 20.2% | not timed | not timed | 449.39 ± 1.9% | | 1.01 | 1.03 | 13.83 |
| opt/backtrack/words-english | 40536 | 140.35 ± 3.8% | not timed | not timed | 111.09 ± 0.7% | 20.64 ± 9.6% | not timed | not timed | 138.54 ± 3.2% | | 1.01 | 1.26 | 6.80 |
| opt/fixed-length/too-small-ascii | 0 | 391.48 ± 1.0% | not timed | not timed | 709.58 ± 0.4% | 121.96 ± 0.9% | not timed | not timed | 391.20 ± 0.5% | | 1.00 | 0.55 | 3.21 |
| opt/fixed-length/too-big-ascii | 0 | 4240.02 ± 4.4% | not timed | not timed | 6292.15 ± 2.4% | 150.69 ± 3.9% | not timed | not timed | 4261.47 ± 6.4% | | 0.99 | 0.67 | 28.14 |
| opt/fixed-length/go33484-1 | 0 | 816519.61 ± 5.7% | not timed | not timed | 1206492.77 ± 4.4% | 86956.81 ± 4.4% | not timed | not timed | 802498.57 ± 3.3% | | 1.02 | 0.68 | 9.39 |
| opt/fixed-length/go33484-2 | 0 | 820129.37 ± 4.2% | not timed | not timed | 1189438.41 ± 5.7% | 27758.73 ± 23.5% | not timed | not timed | 821103.61 ± 3.7% | | 1.00 | 0.69 | 29.54 |
| opt/fixed-length/go33484-3 | 0 | 2327.71 ± 2.7% | not timed | not timed | 120108.54 ± 4.1% | 929.34 ± 1.7% | not timed | not timed | 2386.28 ± 3.3% | | 0.98 | 0.0194 | 2.50 |
| opt/literal-alt/one-pattern | 1 | 543.70 ± 3.5% | not timed | not timed | 542.82 ± 5.2% | 0.38 ± 3.3% | not timed | not timed | 570.05 ± 2.9% | | 0.95 | 1.00 | 1445.66 |
| opt/onepass/fn-predicate | 916 | 428.31 ± 3.2% | not timed | not timed | 396.20 ± 1.8% | 204.53 ± 12.7% | not timed | not timed | 430.47 ± 3.4% | | 0.99 | 1.08 | 2.09 |
| opt/onepass/first-three-words-english | 35128 | 176.84 ± 2.9% | not timed | not timed | 228.97 ± 1.7% | 80.58 ± 25.4% | not timed | not timed | 178.44 ± 1.1% | | 0.99 | 0.77 | 2.19 |
| opt/prefilter/literal-english | 1 | 67707.90 ± 1.3% | not timed | not timed | 46282.71 ± 2.6% | 26633.29 ± 0.3% | not timed | not timed | 67356.99 ± 2.3% | | 1.01 | 1.46 | 2.54 |
| opt/prefilter/literal-casei-english | 1 | 46186.18 ± 2.7% | not timed | not timed | 14221.84 ± 1.3% | 33.75 ± 0.7% | not timed | not timed | 46630.68 ± 1.5% | | 0.99 | 3.25 | 1368.47 |
| opt/prefilter/literal-russian | 1 | 70039.28 ± 1.9% | not timed | not timed | 46071.28 ± 1.5% | 1789.25 ± 2.7% | not timed | not timed | 69332.43 ± 1.6% | | 1.01 | 1.52 | 39.14 |
| opt/prefilter/literal-casei-russian | 1 | 26166.17 ± 0.5% | not timed | not timed | 11016.83 ± 0.8% | 37.75 ± 1.8% | not timed | not timed | 26055.39 ± 0.9% | | 1.00 | 2.38 | 693.09 |
| opt/prefilter/rust-functions | 948 | 14498.23 ± 2.4% | not timed | not timed | 12834.32 ± 0.6% | 1931.27 ± 23.9% | not timed | not timed | 14577.10 ± 1.4% | | 0.99 | 1.13 | 7.51 |
| opt/reverse-anchored/word-end | 1 | 35628956.67 ± 0.5% | not timed | not timed | 27095726.61 ± 0.4% | 56.71 ± 1.1% | not timed | not timed | 35498603.56 ± 0.8% | | 1.00 | 1.31 | 628241.99 |
| opt/reverse-inner/holmes | 2593 | 14848.25 ± 1.5% | not timed | not timed | 14703.76 ± 2.3% | 25.02 ± 2.6% | not timed | not timed | 14845.09 ± 3.6% | | 1.00 | 1.01 | 593.42 |
| opt/reverse-inner/email | 47 | 83474.53 ± 1.6% | not timed | not timed | 90744.12 ± 1.4% | 35.04 ± 14.3% | not timed | not timed | 84049.14 ± 1.6% | | 0.99 | 0.92 | 2382.49 |
| opt/reverse-inner/factored-prefix | 3542 | 599.52 ± 7.3% | not timed | not timed | 583.81 ± 5.6% | 13.86 ± 3.7% | not timed | not timed | 583.04 ± 6.8% | | 1.03 | 1.03 | 43.25 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4190.10 ± 4.4% | not timed | not timed | 600.89 ± 5.0% | 84.43 ± 30.6% | not timed | not timed | 4198.93 ± 4.6% | | 1.00 | 6.97 | 49.63 |
| opt/reverse-inner/no-quadratic-forward | 0 | 709.10 ± 3.6% | not timed | not timed | 279.37 ± 0.5% | 25.40 ± 7.8% | not timed | not timed | 706.37 ± 3.3% | | 1.00 | 2.54 | 27.92 |
| opt/reverse-suffix/holmes | 4073 | 15233.89 ± 0.4% | not timed | not timed | 13356.55 ± 1.9% | 25.49 ± 4.8% | not timed | not timed | 15302.44 ± 2.3% | | 1.00 | 1.14 | 597.61 |
| opt/reverse-suffix/no-quadratic | 0 | 4192.94 ± 0.4% | not timed | not timed | 602.72 ± 1.3% | 85.02 ± 0.9% | not timed | not timed | 4196.88 ± 1.6% | | 1.00 | 6.96 | 49.32 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 142.13 ± 5.2% | not timed | not timed | 183.27 ± 1.0% | 15.35 ± 14.0% | not timed | not timed | 142.91 ± 2.0% | | 0.99 | 0.78 | 9.26 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 142.24 ± 3.9% | not timed | not timed | 181.33 ± 0.3% | 14.32 ± 17.7% | not timed | not timed | 143.13 ± 1.2% | | 0.99 | 0.78 | 9.94 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.31 ± 1.2% | not timed | not timed | 0.48 ± 0.6% | 120.34 ± 1.2% | not timed | not timed | 0.31 ± 1.0% | | 0.99 | 0.65 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 300.36 ± 0.3% | not timed | not timed | 283.68 ± 0.1% | 109.40 ± 1.3% | not timed | not timed | 299.66 ± 0.3% | | 1.00 | 1.06 | 2.75 |
| reported/i13-subset-regex/original-ascii | 4094 | 11940.96 ± 2.2% | not timed | not timed | 3923.02 ± 1.4% | 12.23 ± 0.7% | not timed | not timed | 11936.12 ± 0.6% | | 1.00 | 3.04 | 975.99 |
| reported/i13-subset-regex/original-unicode | 4094 | 11868.16 ± 1.7% | not timed | not timed | 206.61 ± 3.8% | 12.23 ± 1.3% | not timed | not timed | 11895.86 ± 3.2% | | 1.00 | 57.44 | 970.57 |
| reported/i13-subset-regex/big-ascii | 1955 | 11090.36 ± 1.7% | not timed | not timed | 53.41 ± 2.1% | 10.50 ± 1.7% | not timed | not timed | 11117.99 ± 0.5% | | 1.00 | 207.66 | 1056.16 |
| reported/i13-subset-regex/big-unicode | 1955 | 10932.84 ± 1.8% | not timed | not timed | 9.51 ± 55.1% | 10.53 ± 1.1% | not timed | not timed | 11052.96 ± 2.5% | | 0.99 | 1149.90 | 1038.08 |
| reported/i13-subset-regex/huge-ascii | 55 | 10110.68 ± 0.5% | not timed | not timed | 8.57 ± 0.6% | 9.53 ± 1.4% | not timed | not timed | 10181.07 ± 1.4% | | 0.99 | 1179.76 | 1060.54 |
| reported/i13-subset-regex/huge-unicode | 55 | 9733.02 ± 3.7% | not timed | not timed | 8.68 ± 1.2% | 9.53 ± 1.6% | not timed | not timed | 9898.86 ± 7.2% | | 0.98 | 1121.03 | 1021.66 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.16 ± 4.7% | not timed | not timed | 8.60 ± 2.4% | 9.44 ± 5.3% | not timed | not timed | 4.12 ± 3.7% | | 1.01 | 0.48 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.87 ± 1.0% | not timed | not timed | 8.76 ± 0.9% | 9.52 ± 2.8% | not timed | not timed | 5.83 ± 1.0% | | 1.01 | 0.67 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 553.68 ± 1.2% | not timed | not timed | 171.64 ± 0.2% | 7.19 ± 1.2% | not timed | not timed | 559.54 ± 1.0% | | 0.99 | 3.23 | 76.99 |
| reported/i787-keywords/opt-ascii | 5674 | 557.25 ± 0.9% | not timed | not timed | 269.93 ± 4.2% | 12.06 ± 1.3% | not timed | not timed | 554.92 ± 0.5% | | 1.00 | 2.06 | 46.21 |
| slow/quadratic-regex-1x | 100 | 8.24 ± 0.2% | not timed | not timed | 5.96 ± 0.2% | 0.05 ± 0.4% | not timed | not timed | 8.24 ± 0.6% | | 1.00 | 1.38 | 164.10 |
| slow/quadratic-regex-2x | 199 | 3.66 ± 1.3% | not timed | not timed | 3.05 ± 0.6% | 0.01 ± 13.0% | not timed | not timed | 3.70 ± 15.2% | | 0.99 | 1.20 | 278.74 |
| slow/quadratic-haystack-1x | 100 | 26.19 ± 5.5% | not timed | not timed | 11.93 ± 0.6% | 1.00 ± 12.8% | not timed | not timed | 26.18 ± 1.2% | | 1.00 | 2.19 | 26.31 |
| slow/quadratic-haystack-2x | 200 | 19.88 ± 1.4% | not timed | not timed | 6.12 ± 0.6% | 0.55 ± 24.4% | not timed | not timed | 19.92 ± 0.4% | | 1.00 | 3.25 | 36.03 |
| unicode/codepoints/any-one | 1112064 | 336.30 ± 1.1% | not timed | not timed | 241.82 ± 0.6% | 21.78 ± 19.6% | not timed | not timed | 337.82 ± 0.5% | | 1.00 | 1.39 | 15.44 |
| unicode/codepoints/any-all | 4382592 | 268.03 ± 0.3% | not timed | not timed | 259.47 ± 2.3% | 113.65 ± 0.2% | not timed | not timed | 268.89 ± 0.2% | | 1.00 | 1.03 | 2.36 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.63 ± 0.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.30 ± 0.6% | not timed | not timed | 602.88 ± 0.6% | 153.54 ± 0.8% | not timed | not timed | 610.08 ± 2.1% | | 1.00 | 1.01 | 3.97 |
| unicode/overlapping-words/ascii | 6156 | 29.08 ± 25.4% | not timed | not timed | 43.58 ± 0.4% | 4.15 ± 8.8% | not timed | not timed | 28.68 ± 1.7% | | 1.01 | 0.67 | 7.00 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 1.9% | not timed | not timed | 2.99 ± 0.2% | 2.89 ± 11.7% | not timed | not timed | 1.47 ± 1.4% | | 0.98 | 0.48 | 0.50 |
| unicode/overlapping-words/russian | 5710 | 1.27 ± 0.8% | not timed | not timed | 2.71 ± 0.3% | 7.07 ± 10.6% | not timed | not timed | 1.33 ± 0.5% | | 0.96 | 0.47 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 138.03 ± 0.7% | not timed | not timed | 84.77 ± 0.4% | 13.82 ± 10.9% | not timed | not timed | 138.42 ± 16.9% | | 1.00 | 1.63 | 9.99 |
| unicode/word/boundary-long-english | 3466 | 610.98 ± 1.2% | not timed | not timed | 592.73 ± 0.1% | 35.28 ± 0.8% | not timed | not timed | 611.99 ± 1.1% | | 1.00 | 1.03 | 17.32 |
| unicode/word/around-holmes-english | 27 | 64111.97 ± 0.7% | not timed | not timed | 45134.18 ± 0.1% | 24.09 ± 0.5% | not timed | not timed | 63552.23 ± 32.6% | | 1.01 | 1.42 | 2661.23 |
| wild/bibleref/long | 874 | 569.93 ± 2.8% | not timed | not timed | 573.88 ± 0.1% | 7.90 ± 0.4% | not timed | not timed | 570.96 ± 0.4% | | 1.00 | 0.99 | 72.12 |
| wild/bibleref/short | 30 | 22.82 ± 1.8% | not timed | not timed | 32.61 ± 0.4% | 14.23 ± 14.0% | not timed | not timed | 24.01 ± 8.5% | | 0.95 | 0.70 | 1.60 |
| wild/bibleref/line | 874 | 507.02 ± 3.7% | not timed | not timed | 276.56 ± 14.9% | 9.50 ± 8.5% | not timed | not timed | 515.49 ± 11.8% | | 0.98 | 1.83 | 53.38 |
| wild/caddy/caddy | 6 | 443.76 ± 9.0% | not timed | not timed | 290.30 ± 0.2% | 75.83 ± 6.4% | not timed | not timed | 445.84 ± 1.9% | | 1.00 | 1.53 | 5.85 |
| wild/dot-star-capture/rust-src-tools | 6 | 1453.61 ± 0.3% | not timed | not timed | 403.62 ± 0.5% | 15.89 ± 0.4% | not timed | not timed | 1456.22 ± 0.2% | | 1.00 | 3.60 | 91.45 |
| wild/ruff/noqa | 84 | 511.37 ± 2.8% | not timed | not timed | 505.56 ± 1.1% | 21.08 ± 3.8% | not timed | not timed | 510.57 ± 0.7% | | 1.00 | 1.01 | 24.25 |
| wild/ruff/unnecessary-coding-comment | 16 | 1066.90 ± 3.7% | not timed | not timed | 716.77 ± 1.5% | 82.36 ± 8.9% | not timed | not timed | 1067.14 ± 2.2% | | 1.00 | 1.49 | 12.95 |
| wild/ruff/string-quote-prefix | 2972 | 1577.34 ± 2.1% | not timed | not timed | 457.76 ± 0.3% | 317.66 ± 29.1% | not timed | not timed | 1589.12 ± 0.6% | | 0.99 | 3.45 | 4.97 |
| wild/ruff/space-around-operator | 1224378 | 238.05 ± 1.7% | not timed | not timed | 227.12 ± 0.2% | 18.43 ± 6.2% | not timed | not timed | 237.97 ± 1.8% | | 1.00 | 1.05 | 12.91 |
| wild/ruff/shebang | 282 | 1119.01 ± 1.7% | not timed | not timed | 386.05 ± 0.9% | 101.20 ± 10.3% | not timed | not timed | 1105.74 ± 0.6% | | 1.01 | 2.90 | 11.06 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22627.35 ± 2.1% | not timed | not timed | 23674.11 ± 0.6% | 8975.99 ± 3.0% | not timed | not timed | 22014.84 ± 1.0% | | 1.03 | 0.96 | 2.52 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20575.06 ± 0.8% | not timed | not timed | 22398.58 ± 0.6% | 8419.24 ± 0.8% | not timed | not timed | 20649.53 ± 0.6% | | 1.00 | 0.92 | 2.44 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22807.88 ± 0.9% | not timed | not timed | 23365.47 ± 2.3% | 8597.82 ± 2.8% | not timed | not timed | 22978.97 ± 24.8% | | 0.99 | 0.98 | 2.65 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 18209.26 ± 4.1% | not timed | not timed | 23377.08 ± 2.6% | 8346.22 ± 28.7% | not timed | not timed | 18202.60 ± 0.9% | | 1.00 | 0.78 | 2.18 |
| wild/url/search | 234965 | 120.73 ± 14.4% | not timed | not timed | 60.01 ± 3.5% | 2.44 ± 3.8% | not timed | not timed | 126.90 ± 15.8% | | 0.95 | 2.01 | 49.49 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 72.0% | not timed | not timed | 0.01 ± 13.6% | 0.01 ± 20.2% | not timed | not timed | 0.03 ± 3.7% | | 1.00 | 2.57 | 4.55 |
| dictionary/compile/english-15 | 1 | 0.34 ± 3.8% | not timed | not timed | 0.09 ± 4.1% | 0.11 ± 29.9% | not timed | not timed | 0.35 ± 2.5% | | 1.00 | 3.65 | 3.01 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.29 ± 10.5% | not timed | not timed | 0.02 ± 1.4% | 37.13 ± 6.3% | not timed | not timed | 0.30 ± 10.7% | | 0.96 | 12.66 | 0.0077 |
| reported/i1095-word-repetition/ascii-compile | 1 | 44.55 ± 9.9% | not timed | not timed | 17.06 ± 0.4% | 63.33 ± 18.6% | not timed | not timed | 43.84 ± 2.0% | | 1.02 | 2.61 | 0.70 |
| reported/i787-keywords/compile | 1 | 39.14 ± 9.8% | not timed | not timed | 2.27 ± 11.2% | 19.98 ± 33.3% | not timed | not timed | 38.84 ± 10.0% | | 1.01 | 17.23 | 1.96 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 373.73 ± 4.5% | not timed | not timed | 147.18 ± 6.5% | 586.08 ± 7.1% | not timed | not timed | 377.70 ± 3.9% | | 0.99 | 2.54 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 52.12 ± 6.1% | not timed | not timed | 5.54 ± 2.6% | 47.77 ± 12.8% | not timed | not timed | 52.85 ± 4.5% | | 0.99 | 9.41 | 1.09 |
| unicode/compile/one-letter | 53 | 6.69 ± 5.6% | not timed | not timed | 5.84 ± 1.0% | 61.15 ± 15.4% | not timed | not timed | 6.96 ± 2.9% | | 0.96 | 1.15 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.15 ± 17.2% | not timed | not timed | 0.13 ± 2.1% | 66.48 ± 14.7% | not timed | not timed | 1.24 ± 11.5% | | 0.93 | 9.04 | 0.0173 |
| unicode/compile/fifty-letters-ascii | 1 | 204.76 ± 6.6% | not timed | not timed | 69.67 ± 0.5% | 204.13 ± 6.7% | not timed | not timed | 205.28 ± 7.4% | | 1.00 | 2.94 | 1.00 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 455.51 ± 7.9% | not timed | not timed | 51.55 ± 0.3% | 739.25 ± 14.0% | not timed | not timed | 454.17 ± 4.6% | | 1.00 | 8.84 | 0.62 |
| unicode/compile/match-every-line-ascii | 4 | 694.86 ± 14.9% | not timed | not timed | 166.92 ± 6.5% | 695.67 ± 19.5% | not timed | not timed | 712.93 ± 2.6% | | 0.97 | 4.16 | 1.00 |
| unicode/compile/negated-class-matches-codepoint | 1 | 370.71 ± 17.6% | not timed | not timed | 55.82 ± 1.6% | 1330.27 ± 12.0% | not timed | not timed | 370.00 ± 2.8% | | 1.00 | 6.64 | 0.28 |
| wild/bibleref/compile | 3 | 6.18 ± 2.6% | not timed | not timed | 2.45 ± 0.6% | 33.29 ± 7.1% | not timed | not timed | 6.28 ± 2.2% | | 0.98 | 2.53 | 0.19 |
| wild/url/compile | 1 | 0.73 ± 0.5% | not timed | not timed | 0.20 ± 9.2% | 0.43 ± 36.2% | not timed | not timed | 0.71 ± 18.3% | | 1.02 | 3.60 | 1.70 |

