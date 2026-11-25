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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507025939 |
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
| literal: a word | 217 | 48473.95 ± 1.2% | 4002.80 ± 0.2% | 29.78 ± 1.7% | 38903.32 ± 0.6% | 12146.90 ± 5.6% | 12.66 ± 0.4% | 102.06 ± 0.3% | 48466.07 ± 0.5% | 12.11 | 1.00 | 1.25 | 3.99 |
| literal: a word that is not there | 0 | 63231.79 ± 0.3% | 3890.62 ± 0.1% | 31.37 ± 12.1% | 45726.97 ± 0.8% | 43592.81 ± 2.7% | 12.52 ± 0.3% | 98.78 ± 2.7% | 63008.19 ± 1.9% | 16.25 | 1.00 | 1.38 | 1.45 |
| literal: one of four words | 661 | 16988.82 ± 8.3% | 1691.51 ± 0.4% | 16.95 ± 0.5% | 11163.58 ± 0.2% | 25.02 ± 1.7% | 4.46 ± 0.7% | 8.63 ± 1.7% | 17029.68 ± 0.3% | 10.04 | 1.00 | 1.52 | 678.95 |
| literal: a word in any case | 217 | 42628.49 ± 5.9% | 1809.30 ± 4.0% | 24.07 ± 3.2% | 11356.43 ± 0.6% | 47.19 ± 1.9% | refused | differs | 42574.13 ± 1.3% | 23.56 | 1.00 | 3.75 | 903.42 |
| literal: an href attribute | 33 | 40859.59 ± 1.5% | 615.67 ± 0.2% | 30.00 ± 0.9% | 34745.17 ± 1.1% | 3019.60 ± 3.6% | 9.55 ± 0.2% | 91.45 ± 0.4% | 40918.15 ± 2.2% | 66.37 | 1.00 | 1.18 | 13.53 |
| literal: a word, second text | 123 | 51051.65 ± 0.7% | 3127.35 ± 1.1% | 30.91 ± 1.5% | 39090.45 ± 0.5% | 10874.22 ± 16.9% | 14.48 ± 7.5% | 88.29 ± 1.3% | 51053.91 ± 0.5% | 16.32 | 1.00 | 1.31 | 4.69 |
| class: two capitalized words | 1331 | 925.76 ± 0.3% | 612.25 ± 0.4% | 28.89 ± 0.3% | 576.23 ± 0.4% | 44.45 ± 1.2% | 10.85 ± 0.3% | 79.71 ± 0.1% | 921.94 ± 0.1% | 1.51 | 1.00 | 1.61 | 20.83 |
| class: a word that ends in ing | 3399 | 584.85 ± 0.5% | 585.50 ± 0.3% | 19.58 ± 0.6% | 538.51 ± 0.6% | 32.84 ± 7.2% | 6.16 ± 0.1% | 20.63 ± 0.7% | 583.17 ± 0.5% | 1.00 | 1.00 | 1.09 | 17.81 |
| class: a word in capitals | 2332 | 1161.01 ± 2.3% | 614.99 ± 3.3% | 30.59 ± 0.9% | 564.85 ± 1.0% | 47.49 ± 4.6% | 12.40 ± 0.5% | 101.27 ± 10.5% | 1162.17 ± 0.3% | 1.89 | 1.00 | 2.06 | 24.45 |
| class: a number | 8288 | 2028.55 ± 4.3% | 852.93 ± 5.7% | 30.85 ± 7.1% | 1801.39 ± 1.1% | 49.14 ± 13.5% | 0.38 ± 1.3% | 73.03 ± 1.3% | 2026.42 ± 6.2% | 2.38 | 1.00 | 1.13 | 41.28 |
| class: two capitalized words, second text | 5359 | 522.99 ± 0.3% | 530.43 ± 0.2% | 26.03 ± 6.1% | 478.58 ± 0.3% | 38.77 ± 15.5% | 12.71 ± 1.2% | 73.93 ± 0.5% | 523.06 ± 0.2% | 0.99 | 1.00 | 1.09 | 13.49 |
| other: a word between two words | 6104 | 925.83 ± 0.4% | 606.96 ± 0.3% | 26.03 ± 4.7% | 812.66 ± 1.7% | 124.10 ± 13.9% | 8.46 ± 0.4% | 82.49 ± 4.8% | 926.55 ± 0.1% | 1.53 | 1.00 | 1.14 | 7.46 |
| other: a number before a unit, second text | 1481 | 11230.25 ± 7.0% | 1071.50 ± 0.6% | 28.92 ± 0.4% | 8153.18 ± 0.3% | 45.31 ± 1.8% | 13.28 ± 0.3% | 77.88 ± 8.4% | 11255.48 ± 5.5% | 10.48 | 1.00 | 1.38 | 247.86 |
| other: a heading's start tag | 110 | 26097.35 ± 5.3% | 747.31 ± 0.1% | 27.44 ± 1.5% | 2498.94 ± 1.9% | 1959.36 ± 11.8% | 11.68 ± 0.5% | 107.27 ± 13.1% | 26222.35 ± 0.2% | 34.92 | 1.00 | 10.44 | 13.32 |
| other: a whole word | 217 | 34124.55 ± 0.6% | 607.86 ± 0.5% | 31.49 ± 0.2% | 28165.65 ± 0.6% | 54.15 ± 1.0% | 11.03 ± 0.1% | 63.39 ± 1.5% | 34039.03 ± 0.4% | 56.14 | 1.00 | 1.21 | 630.23 |
| other: a line's first word, second text | 3716 | 2799.93 ± 0.9% | 600.29 ± 0.2% | 35.02 ± 1.0% | 2317.97 ± 3.6% | 65.79 ± 4.2% | refused | refused | 2791.02 ± 1.7% | 4.66 | 1.00 | 1.21 | 42.56 |
| other: fourteen octets before an x | 87 | 38359.77 ± 1.3% | 246.69 ± 1.3% | 7.62 ± 9.0% | 3431.09 ± 1.6% | 11.60 ± 0.3% | differs | 21.55 ± 4.0% | 38712.29 ± 1.7% | 155.50 | 0.99 | 11.18 | 3306.54 |
| other: a Greek word | 21815 | 516.69 ± 1.0% | 440.89 ± 0.6% | 34.42 ± 0.4% | 305.63 ± 0.2% | 56.40 ± 10.8% | differs | refused | 519.32 ± 1.4% | 1.17 | 0.99 | 1.69 | 9.16 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 32.20 ± 3.2% | 32.14 ± 3.1% | 1.00 ± 22.3% | 19.83 ± 0.4% | 2.11 ± 0.6% | differs | 4.27 ± 2.4% | 32.28 ± 3.6% | 1.00 | 1.00 | 1.62 | 15.29 |
| a UUID | 32895 | 27.65 ± 0.5% | 27.58 ± 0.9% | 0.70 ± 2.5% | 15.10 ± 0.2% | 3.06 ± 2.1% | 0.52 ± 0.3% | 3.82 ± 5.1% | 27.52 ± 1.2% | 1.00 | 1.00 | 1.83 | 9.02 |
| an IPv4 address | 33176 | 40.07 ± 1.7% | 40.37 ± 1.5% | 2.19 ± 1.8% | 28.26 ± 6.2% | 6.93 ± 13.1% | differs | 3.92 ± 2.0% | 40.14 ± 2.7% | 0.99 | 1.00 | 1.42 | 5.78 |
| a date and time | 32954 | 37.91 ± 0.2% | 37.71 ± 2.3% | 1.66 ± 0.8% | 21.63 ± 1.9% | 8.18 ± 1.8% | 0.91 ± 0.2% | 8.08 ± 2.1% | 37.92 ± 1.6% | 1.01 | 1.00 | 1.75 | 4.64 |
| a field path | 32606 | 34.90 ± 0.3% | 34.79 ± 2.2% | 1.05 ± 1.6% | 22.87 ± 0.3% | 3.47 ± 3.4% | differs | 3.07 ± 1.3% | 34.91 ± 2.5% | 1.00 | 1.00 | 1.53 | 10.06 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.74 ± 0.4% | 10.73 ± 24.7% | 10.83 ± 0.3% | 10.41 ± 0.6% | 5.78 ± 3.3% | 0.75 ± 0.5% | none | 10.42 ± 22.4% | 1.00 | 1.03 | 1.03 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 255.40 ± 0.3% | 255.73 ± 0.6% | 299.28 ± 0.3% | 101.03 ± 2.0% | 240.47 ± 4.2% | 704.20 ± 2.5% | 4956.71 ± 1.0% | 255.58 ± 0.6% | 1.00 | 1.00 | 2.53 | 1.06 |
| a UUID | 62 | 168.21 ± 0.2% | 168.18 ± 0.4% | 187.88 ± 0.9% | 58.84 ± 1.1% | 117.16 ± 3.1% | 253.97 ± 2.2% | 5521.84 ± 0.8% | 168.31 ± 0.3% | 1.00 | 1.00 | 2.86 | 1.44 |
| an IPv4 address | 29 | 497.56 ± 0.3% | 497.44 ± 0.2% | 682.97 ± 6.3% | 88.23 ± 0.3% | 145.20 ± 3.0% | 417.56 ± 0.6% | 8990.61 ± 0.3% | 496.58 ± 8.5% | 1.00 | 1.00 | 5.64 | 3.43 |
| a date and time | 56 | 357.77 ± 0.2% | 357.37 ± 17.7% | 449.39 ± 0.2% | 86.22 ± 1.3% | 156.44 ± 24.2% | 467.43 ± 0.7% | 5709.95 ± 0.4% | 357.82 ± 0.4% | 1.00 | 1.00 | 4.15 | 2.29 |
| a field path | 39 | 252.26 ± 0.3% | 252.91 ± 4.9% | 285.28 ± 11.3% | 95.86 ± 2.3% | 226.16 ± 3.9% | 755.91 ± 1.1% | 6028.51 ± 1.5% | 252.78 ± 0.3% | 1.00 | 1.00 | 2.63 | 1.12 |
| literal: a word | 7 | 736.95 ± 0.3% | 790.26 ± 0.9% | 1383.71 ± 0.7% | 650.22 ± 1.8% | 769.63 ± 2.8% | 1608.99 ± 0.6% | 34757.53 ± 0.3% | 737.44 ± 0.3% | 0.93 | 1.00 | 1.13 | 0.96 |
| literal: a word that is not there | 8 | 709.30 ± 18.3% | 764.23 ± 0.2% | 1320.76 ± 1.8% | 595.39 ± 0.5% | 741.87 ± 4.1% | 1524.53 ± 0.6% | 33909.03 ± 1.3% | 710.12 ± 1.3% | 0.93 | 1.00 | 1.19 | 0.96 |
| literal: one of four words | 26 | 273.08 ± 12.1% | 454.95 ± 0.3% | 612.05 ± 0.2% | 53.52 ± 1.5% | 283.46 ± 3.5% | 582.59 ± 14.8% | 18020.13 ± 0.8% | 273.34 ± 0.5% | 0.60 | 1.00 | 5.10 | 0.96 |
| literal: a word in any case | 11 | 493.17 ± 0.8% | 525.34 ± 0.4% | 735.38 ± 5.1% | 18.90 ± 0.3% | 784.46 ± 26.4% | refused | 27811.02 ± 16.1% | 493.68 ± 0.8% | 0.94 | 1.00 | 26.09 | 0.63 |
| literal: an href attribute | 12 | 407.03 ± 0.7% | 420.73 ± 2.8% | 487.39 ± 12.0% | 49.53 ± 0.8% | 564.56 ± 3.3% | 1264.34 ± 1.5% | 21663.68 ± 3.1% | 407.94 ± 0.1% | 0.97 | 1.00 | 8.22 | 0.72 |
| literal: a word, second text | 10 | 660.03 ± 0.5% | 717.07 ± 1.8% | 1181.20 ± 0.3% | 548.63 ± 1.5% | 649.38 ± 7.5% | 1323.53 ± 20.4% | 32258.40 ± 0.4% | 660.54 ± 0.6% | 0.92 | 1.00 | 1.20 | 1.02 |
| class: two capitalized words | 23 | 513.74 ± 16.0% | 553.80 ± 5.6% | 796.32 ± 0.7% | 122.83 ± 1.3% | 584.40 ± 3.6% | 1224.64 ± 17.8% | 8130.89 ± 5.7% | 515.44 ± 2.5% | 0.93 | 1.00 | 4.18 | 0.88 |
| class: a word that ends in ing | 9 | 636.90 ± 0.3% | 726.52 ± 0.2% | 1245.14 ± 0.7% | 152.73 ± 1.2% | 835.25 ± 12.8% | 1854.85 ± 4.1% | 19436.04 ± 21.3% | 636.64 ± 0.2% | 0.88 | 1.00 | 4.17 | 0.76 |
| class: a word in capitals | 16 | 573.05 ± 1.5% | 619.85 ± 0.2% | 981.89 ± 0.6% | 158.41 ± 2.1% | 869.71 ± 14.4% | 1737.60 ± 13.3% | 10660.21 ± 0.4% | 573.46 ± 0.2% | 0.92 | 1.00 | 3.62 | 0.66 |
| class: a number | 6 | 718.44 ± 0.8% | 793.49 ± 1.0% | 1470.62 ± 0.4% | 47.23 ± 1.9% | 1577.93 ± 12.5% | 3034.03 ± 5.8% | 25935.07 ± 0.1% | 688.79 ± 21.6% | 0.91 | 1.04 | 15.21 | 0.46 |
| class: two capitalized words, second text | 23 | 514.81 ± 0.7% | 553.29 ± 0.4% | 795.43 ± 1.0% | 122.70 ± 1.0% | 591.07 ± 3.2% | 1269.40 ± 0.4% | 8142.10 ± 3.0% | 514.87 ± 3.1% | 0.93 | 1.00 | 4.20 | 0.87 |
| other: a word between two words | 13 | 630.87 ± 9.2% | 655.48 ± 0.7% | 1025.27 ± 0.2% | 160.97 ± 2.0% | 568.82 ± 6.0% | 1320.65 ± 11.1% | 17966.96 ± 9.0% | 630.90 ± 0.4% | 0.96 | 1.00 | 3.92 | 1.11 |
| other: a number before a unit, second text | 15 | 456.29 ± 0.7% | 508.63 ± 0.3% | 704.76 ± 0.4% | 44.36 ± 1.5% | 712.41 ± 2.1% | 1478.96 ± 0.9% | 17914.05 ± 0.5% | 456.39 ± 1.0% | 0.90 | 1.00 | 10.29 | 0.64 |
| other: a heading's start tag | 13 | 414.95 ± 1.3% | 424.18 ± 1.2% | 560.34 ± 0.1% | 47.96 ± 0.5% | 695.16 ± 11.9% | 1398.62 ± 0.4% | 20539.33 ± 1.9% | 414.64 ± 0.4% | 0.98 | 1.00 | 8.65 | 0.60 |
| other: a whole word | 11 | 649.50 ± 0.5% | 690.78 ± 0.5% | 1126.58 ± 0.2% | 141.71 ± 2.0% | 651.67 ± 3.0% | 1367.82 ± 5.0% | 31871.00 ± 19.6% | 648.82 ± 2.0% | 0.94 | 1.00 | 4.58 | 1.00 |
| other: a line's first word, second text | 17 | 596.99 ± 2.6% | 633.48 ± 4.5% | 993.97 ± 1.4% | 147.38 ± 0.4% | 767.31 ± 21.5% | refused | refused | 596.66 ± 2.4% | 0.94 | 1.00 | 4.05 | 0.78 |
| other: fourteen octets before an x | 16 | 116.80 ± 3.3% | 175.19 ± 0.3% | 205.43 ± 1.0% | 18.00 ± 1.2% | 498.21 ± 1.6% | 576.47 ± 0.5% | 15605.42 ± 0.4% | 116.81 ± 0.6% | 0.67 | 1.00 | 6.49 | 0.23 |
| other: a Greek word | 8 | 480.08 ± 0.2% | 674.90 ± 0.5% | 1124.15 ± 0.3% | 62.46 ± 0.2% | 1543.71 ± 8.7% | 2785.11 ± 1.1% | refused | 480.53 ± 0.2% | 0.71 | 1.00 | 7.69 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37305.91 ± 6.4% | not timed | not timed | 32944.10 ± 1.2% | 2798.13 ± 12.4% | not timed | not timed | 37311.97 ± 19.0% | | 1.00 | 1.13 | 13.33 |
| 01-literal/sherlock-casei-en | 522 | 29618.47 ± 12.6% | not timed | not timed | 9040.97 ± 2.5% | 34.07 ± 2.6% | not timed | not timed | 29610.30 ± 21.0% | | 1.00 | 3.28 | 869.40 |
| 01-literal/sherlock-ru | 724 | 39145.59 ± 0.3% | not timed | not timed | 34384.25 ± 1.1% | 1276.55 ± 7.4% | not timed | not timed | 39204.24 ± 0.9% | | 1.00 | 1.14 | 30.67 |
| 01-literal/sherlock-casei-ru | 746 | 12363.50 ± 0.3% | not timed | not timed | 7799.24 ± 0.5% | 37.47 ± 2.2% | not timed | not timed | 12311.77 ± 1.2% | | 1.00 | 1.59 | 329.98 |
| 01-literal/sherlock-zh | 30 | 59308.47 ± 0.8% | not timed | not timed | 42543.42 ± 0.3% | 1634.24 ± 2.0% | not timed | not timed | 59259.60 ± 0.2% | | 1.00 | 1.39 | 36.29 |
| 02-literal-alternate/sherlock-en | 714 | 15565.49 ± 2.5% | not timed | not timed | 10921.17 ± 0.6% | 19.09 ± 0.5% | not timed | not timed | 15601.76 ± 1.9% | | 1.00 | 1.43 | 815.19 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5096.94 ± 4.1% | not timed | not timed | 2298.33 ± 3.0% | 12.29 ± 0.2% | not timed | not timed | 5110.53 ± 4.9% | | 1.00 | 2.22 | 414.86 |
| 02-literal-alternate/sherlock-ru | 899 | 10721.39 ± 1.0% | not timed | not timed | 9757.92 ± 1.5% | 25.42 ± 1.7% | not timed | not timed | 10769.30 ± 25.4% | | 1.00 | 1.10 | 421.71 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2537.58 ± 2.0% | not timed | not timed | 1196.29 ± 2.4% | 10.61 ± 3.3% | not timed | not timed | 2524.50 ± 3.2% | | 1.01 | 2.12 | 239.12 |
| 02-literal-alternate/sherlock-zh | 207 | 20542.25 ± 0.2% | not timed | not timed | 12679.72 ± 0.3% | 35.53 ± 1.2% | not timed | not timed | 20558.88 ± 0.4% | | 1.00 | 1.62 | 578.11 |
| 03-date/ascii | 111817 | 147.55 ± 0.8% | not timed | not timed | 99.80 ± 0.6% | 0.23 ± 4.0% | not timed | not timed | 148.03 ± 1.6% | | 1.00 | 1.48 | 650.47 |
| 04-ruff-noqa/real | 84 | 512.06 ± 2.6% | not timed | not timed | 498.53 ± 4.2% | 18.97 ± 1.8% | not timed | not timed | 512.02 ± 1.0% | | 1.00 | 1.03 | 27.00 |
| 04-ruff-noqa/tweaked | 44 | 653.20 ± 0.5% | not timed | not timed | 495.81 ± 0.7% | 363.97 ± 12.1% | not timed | not timed | 653.44 ± 23.5% | | 1.00 | 1.32 | 1.79 |
| 05-lexer-veryl/single | 124800 | 4.78 ± 2.5% | not timed | not timed | 5.42 ± 0.7% | 0.26 ± 9.2% | not timed | not timed | 4.84 ± 0.8% | | 0.99 | 0.88 | 18.69 |
| 06-cloud-flare-redos/original | 107 | 432.78 ± 0.7% | not timed | not timed | 228.37 ± 1.5% | 24.93 ± 6.8% | not timed | not timed | 432.58 ± 0.6% | | 1.00 | 1.90 | 17.36 |
| 06-cloud-flare-redos/simplified-short | 102 | 423.83 ± 1.2% | not timed | not timed | 234.87 ± 0.3% | 23.64 ± 0.7% | not timed | not timed | 420.13 ± 0.9% | | 1.01 | 1.80 | 17.93 |
| 06-cloud-flare-redos/simplified-long | 10000 | 530.19 ± 3.1% | not timed | not timed | 259.32 ± 0.8% | 29.44 ± 4.8% | not timed | not timed | 528.83 ± 0.9% | | 1.00 | 2.04 | 18.01 |
| 07-unicode-character-data/parse-line | 558784 | 248.56 ± 2.0% | not timed | not timed | 197.78 ± 1.9% | 47.77 ± 4.0% | not timed | not timed | 232.49 ± 16.8% | | 1.07 | 1.26 | 5.20 |
| 08-words/all-english | 56691 | 134.11 ± 1.7% | not timed | not timed | 83.85 ± 0.4% | 14.71 ± 6.5% | not timed | not timed | 134.99 ± 13.2% | | 0.99 | 1.60 | 9.12 |
| 08-words/long-english | 839 | 617.56 ± 0.4% | not timed | not timed | 584.51 ± 0.1% | 35.30 ± 0.7% | not timed | not timed | 616.79 ± 1.3% | | 1.00 | 1.06 | 17.49 |
| 09-aws-keys/full | 0 | 522.24 ± 0.9% | not timed | not timed | 533.40 ± 0.2% | 67.03 ± 4.4% | not timed | not timed | 522.50 ± 0.9% | | 1.00 | 0.98 | 7.79 |
| 09-aws-keys/quick | 0 | 1148.18 ± 1.0% | not timed | not timed | 961.81 ± 1.5% | 384.18 ± 3.3% | not timed | not timed | 1149.04 ± 1.3% | | 1.00 | 1.19 | 2.99 |
| 10-bounded-repeat/letters-en | 1833 | 675.41 ± 9.5% | not timed | not timed | 554.80 ± 0.3% | 22.74 ± 1.0% | not timed | not timed | 679.00 ± 0.7% | | 0.99 | 1.22 | 29.71 |
| 10-bounded-repeat/letters-ru | 3475 | 525.99 ± 1.0% | not timed | not timed | 481.50 ± 0.7% | 24.78 ± 11.7% | not timed | not timed | 526.86 ± 1.1% | | 1.00 | 1.09 | 21.22 |
| 10-bounded-repeat/context | 53 | 87.28 ± 2.1% | not timed | not timed | 68.64 ± 3.9% | 22.68 ± 0.5% | not timed | not timed | 85.10 ± 3.6% | | 1.03 | 1.27 | 3.85 |
| 10-bounded-repeat/capitals | 11 | 636.73 ± 8.2% | not timed | not timed | 604.57 ± 0.1% | 40.26 ± 0.4% | not timed | not timed | 637.48 ± 8.1% | | 1.00 | 1.05 | 15.82 |
| 11-unstructured-to-json/extract | 600 | 49.95 ± 0.9% | not timed | not timed | 81.06 ± 0.9% | 33.40 ± 16.2% | not timed | not timed | 51.68 ± 2.1% | | 0.97 | 0.62 | 1.50 |
| 12-dictionary/single | 1 | 514.96 ± 0.7% | not timed | not timed | 481.46 ± 0.1% | 0.40 ± 2.5% | not timed | not timed | 512.70 ± 2.2% | | 1.00 | 1.07 | 1278.83 |
| 14-quadratic/1x | 100 | 26.19 ± 0.3% | not timed | not timed | 12.18 ± 0.4% | 0.99 ± 3.1% | not timed | not timed | 26.10 ± 23.8% | | 1.00 | 2.15 | 26.45 |
| 14-quadratic/2x | 200 | 19.84 ± 1.2% | not timed | not timed | 6.07 ± 0.3% | 0.54 ± 2.1% | not timed | not timed | 19.81 ± 0.9% | | 1.00 | 3.27 | 36.66 |
| 14-quadratic/10x | 1000 | 6.84 ± 2.3% | not timed | not timed | 1.22 ± 0.3% | 0.12 ± 0.6% | not timed | not timed | 6.84 ± 1.2% | | 1.00 | 5.63 | 59.19 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.39 ± 0.5% | not timed | not timed | 0.47 ± 0.9% | 0.60 ± 4.3% | not timed | not timed | 1.38 ± 0.9% | | 1.01 | 2.97 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 120.71 ± 0.5% | not timed | not timed | 17.06 ± 0.9% | 160.84 ± 4.9% | not timed | not timed | 120.18 ± 0.4% | | 1.00 | 7.08 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 16.48 ± 1.0% | not timed | not timed | 2.98 ± 1.0% | 7.67 ± 3.2% | not timed | not timed | 16.48 ± 1.0% | | 1.00 | 5.54 | 2.15 |
| 07-unicode-character-data/compile | 1 | 125.20 ± 1.5% | not timed | not timed | 30.54 ± 0.4% | 43.37 ± 4.2% | not timed | not timed | 123.15 ± 1.1% | | 1.02 | 4.10 | 2.89 |
| 09-aws-keys/compile-full | 1 | 55.52 ± 1.5% | not timed | not timed | 10.03 ± 1.0% | 26.91 ± 1.6% | not timed | not timed | 55.46 ± 1.2% | | 1.00 | 5.54 | 2.06 |
| 09-aws-keys/compile-quick | 1 | 198.06 ± 4.2% | not timed | not timed | 57.40 ± 12.8% | 153.10 ± 19.3% | not timed | not timed | 196.07 ± 0.8% | | 1.01 | 3.45 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 60.55 ± 0.8% | not timed | not timed | 14.58 ± 1.0% | 19.54 ± 18.8% | not timed | not timed | 60.19 ± 1.0% | | 1.01 | 4.15 | 3.10 |
| 10-bounded-repeat/compile-capitals | 1 | 93.75 ± 1.0% | not timed | not timed | 10.49 ± 0.6% | 28.60 ± 11.7% | not timed | not timed | 94.64 ± 0.5% | | 0.99 | 8.94 | 3.28 |
| 11-unstructured-to-json/compile | 1 | 191.83 ± 0.7% | not timed | not timed | 47.36 ± 0.2% | 75.95 ± 3.1% | not timed | not timed | 187.65 ± 7.3% | | 1.02 | 4.05 | 2.53 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.8% | not timed | not timed | 0.08 ± 6.0% | 0.10 ± 27.0% | not timed | not timed | 0.34 ± 0.6% | | 1.00 | 4.24 | 3.35 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.30 ± 2.5% | not timed | not timed | 6.72 ± 1.3% | 0.67 ± 14.2% | not timed | not timed | 7.28 ± 1.2% | | 1.00 | 1.09 | 10.97 |
| dictionary/search/english-10 | 690 | 1.29 ± 1.3% | not timed | not timed | 152.49 ± 1.5% | 0.01 ± 0.8% | not timed | not timed | 1.29 ± 3.6% | | 1.00 | 0.0084 | 181.78 |
| dictionary/search/english-15 | 15 | 512.95 ± 1.3% | not timed | not timed | 482.15 ± 0.6% | 0.37 ± 2.0% | not timed | not timed | 512.89 ± 1.0% | | 1.00 | 1.06 | 1379.14 |
| folly/awyer-inn-busted | 1 | 4247.73 ± 0.1% | not timed | not timed | 131.74 ± 0.6% | 48.42 ± 1.9% | not timed | not timed | 4246.18 ± 0.6% | | 1.00 | 32.24 | 87.72 |
| folly/literal-never-match-rare | 0 | 67616.87 ± 2.2% | not timed | not timed | 46454.18 ± 0.4% | 68930.48 ± 0.9% | not timed | not timed | 67704.94 ± 7.4% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 26449.99 ± 9.0% | not timed | not timed | 46136.41 ± 0.2% | 2586.20 ± 0.2% | not timed | not timed | 26992.34 ± 5.7% | | 0.98 | 0.57 | 10.23 |
| folly/literal-never-match-tricksy | 1 | 3988.87 ± 19.1% | not timed | not timed | 6152.31 ± 0.4% | 1720.88 ± 9.3% | not timed | not timed | 3980.46 ± 3.5% | | 1.00 | 0.65 | 2.32 |
| grep/every-line | 239963 | 1474.29 ± 4.7% | not timed | not timed | 964.87 ± 15.5% | 382.99 ± 16.8% | not timed | not timed | 1445.83 ± 7.7% | | 1.02 | 1.53 | 3.85 |
| grep/long-words-ascii | 5073 | 503.91 ± 0.6% | not timed | not timed | 475.78 ± 0.7% | 50.20 ± 7.5% | not timed | not timed | 502.92 ± 0.3% | | 1.00 | 1.06 | 10.04 |
| imported/leipzig/twain | 811 | 56682.66 ± 4.1% | not timed | not timed | 43628.74 ± 0.3% | 13127.20 ± 12.6% | not timed | not timed | 57351.74 ± 2.0% | | 0.99 | 1.30 | 4.32 |
| imported/leipzig/twain-insensitive | 965 | 15525.50 ± 0.9% | not timed | not timed | 13413.66 ± 0.8% | 43.79 ± 4.1% | not timed | not timed | 15505.90 ± 0.3% | | 1.00 | 1.16 | 354.51 |
| imported/leipzig/shing | 1540 | 29914.19 ± 1.2% | not timed | not timed | 22157.31 ± 5.4% | 37.98 ± 3.8% | not timed | not timed | 30042.17 ± 0.6% | | 1.00 | 1.35 | 787.72 |
| imported/leipzig/huck-saw | 262 | 24917.65 ± 11.4% | not timed | not timed | 18593.76 ± 20.0% | 35.06 ± 0.8% | not timed | not timed | 24899.64 ± 0.5% | | 1.00 | 1.34 | 710.78 |
| imported/leipzig/word-ending-nn | 262 | 609.56 ± 0.8% | not timed | not timed | 603.01 ± 0.5% | 27.66 ± 3.2% | not timed | not timed | 609.57 ± 0.4% | | 1.00 | 1.01 | 22.04 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11648.00 ± 6.1% | not timed | not timed | 3843.71 ± 2.9% | 12.27 ± 2.2% | not timed | not timed | 11945.34 ± 2.5% | | 0.98 | 3.03 | 949.15 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 22068.22 ± 1.2% | not timed | not timed | 17537.12 ± 0.4% | 19.33 ± 2.2% | not timed | not timed | 22093.57 ± 1.4% | | 1.00 | 1.26 | 1141.82 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5566.72 ± 3.7% | not timed | not timed | 792.86 ± 1.4% | 12.29 ± 1.6% | not timed | not timed | 5572.92 ± 0.5% | | 1.00 | 7.02 | 452.93 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 607.43 ± 0.4% | not timed | not timed | 602.53 ± 0.4% | 12.32 ± 1.1% | not timed | not timed | 608.08 ± 0.2% | | 1.00 | 1.01 | 49.30 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 607.99 ± 0.1% | not timed | not timed | 602.63 ± 0.2% | 10.73 ± 1.4% | not timed | not timed | 608.39 ± 0.2% | | 1.00 | 1.01 | 56.66 |
| imported/leipzig/tom-river | 2 | 12893.23 ± 0.6% | not timed | not timed | 13309.18 ± 1.6% | 34.91 ± 2.4% | not timed | not timed | 12915.29 ± 1.0% | | 1.00 | 0.97 | 369.30 |
| imported/leipzig/ing | 78424 | 599.12 ± 0.6% | not timed | not timed | 561.99 ± 0.2% | 30.53 ± 5.3% | not timed | not timed | 599.77 ± 0.8% | | 1.00 | 1.07 | 19.62 |
| imported/leipzig/ing-whitespace | 55248 | 733.41 ± 2.0% | not timed | not timed | 2149.32 ± 0.3% | 22.48 ± 3.1% | not timed | not timed | 741.29 ± 0.8% | | 0.99 | 0.34 | 32.63 |
| imported/leipzig/awyer-inn | 209 | 771.11 ± 1.5% | not timed | not timed | 13755.00 ± 0.7% | 25.12 ± 0.7% | not timed | not timed | 771.50 ± 1.6% | | 1.00 | 0.0561 | 30.70 |
| imported/leipzig/quotes-bounded | 8886 | 1847.54 ± 0.3% | not timed | not timed | 3267.40 ± 0.4% | 41.00 ± 3.8% | not timed | not timed | 1842.31 ± 9.0% | | 1.00 | 0.57 | 45.07 |
| imported/leipzig/non-ascii-alternate | 2 | 40122.78 ± 1.8% | not timed | not timed | 19534.49 ± 0.4% | 55.99 ± 1.8% | not timed | not timed | 40191.56 ± 1.3% | | 1.00 | 2.05 | 716.58 |
| imported/leipzig/math-symbols | 69 | 2428.38 ± 0.2% | not timed | not timed | 603.74 ± 0.3% | 39.43 ± 1.5% | not timed | not timed | 2428.51 ± 0.4% | | 1.00 | 4.02 | 61.59 |
| imported/leipzig/bounded-strings-ending-z | 0 | 609.72 ± 0.1% | not timed | not timed | 604.29 ± 0.4% | 25.28 ± 2.6% | not timed | not timed | 610.02 ± 0.1% | | 1.00 | 1.01 | 24.12 |
| imported/lh3lh3-reb/uri | 17549 | 815.64 ± 4.1% | not timed | not timed | 1131.43 ± 1.3% | 24.66 ± 14.7% | not timed | not timed | 814.82 ± 0.2% | | 1.00 | 0.72 | 33.07 |
| imported/lh3lh3-reb/email | 15057 | 808.90 ± 18.6% | not timed | not timed | 1127.67 ± 9.4% | 25.34 ± 3.0% | not timed | not timed | 809.02 ± 0.4% | | 1.00 | 0.72 | 31.93 |
| imported/lh3lh3-reb/date | 668 | 931.75 ± 2.3% | not timed | not timed | 1015.75 ± 1.3% | 52.99 ± 4.8% | not timed | not timed | 930.15 ± 1.1% | | 1.00 | 0.92 | 17.58 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 749.00 ± 21.1% | not timed | not timed | 440.68 ± 0.9% | 12.83 ± 2.0% | not timed | not timed | 739.86 ± 9.0% | | 1.01 | 1.70 | 58.37 |
| imported/mariomka/email | 92 | 42713.33 ± 1.3% | not timed | not timed | 60692.44 ± 0.6% | 28.17 ± 0.4% | not timed | not timed | 42883.19 ± 0.8% | | 1.00 | 0.70 | 1516.52 |
| imported/mariomka/uri | 5301 | 6653.23 ± 0.6% | not timed | not timed | 7849.56 ± 0.4% | 27.72 ± 2.7% | not timed | not timed | 6677.33 ± 0.4% | | 1.00 | 0.85 | 239.98 |
| imported/mariomka/ip | 5 | 1817.35 ± 2.9% | not timed | not timed | 2317.12 ± 1.0% | 15.83 ± 2.1% | not timed | not timed | 1810.78 ± 3.8% | | 1.00 | 0.78 | 114.83 |
| imported/rsc/no-exponential | 0 | 893.88 ± 0.4% | not timed | not timed | 421.40 ± 0.9% | 24.11 ± 21.5% | not timed | not timed | 897.92 ± 0.4% | | 1.00 | 2.12 | 37.08 |
| imported/rsc/literal | 1 | 880.78 ± 8.2% | not timed | not timed | 2237.27 ± 0.9% | 215.07 ± 22.2% | not timed | not timed | 895.87 ± 13.8% | | 0.98 | 0.39 | 4.10 |
| imported/rsc/not-literal | 2 | 964.67 ± 3.1% | not timed | not timed | 848.86 ± 0.3% | 47.76 ± 92.0% | not timed | not timed | 968.52 ± 2.9% | | 1.00 | 1.14 | 20.20 |
| imported/rsc/match-class | 1 | 1676.62 ± 10.9% | not timed | not timed | 1808.32 ± 0.4% | 67.72 ± 7.0% | not timed | not timed | 1676.90 ± 2.5% | | 1.00 | 0.93 | 24.76 |
| imported/rsc/match-class-in-range | 1 | 1675.46 ± 2.6% | not timed | not timed | 3435.31 ± 1.3% | 68.90 ± 7.0% | not timed | not timed | 1680.93 ± 0.3% | | 1.00 | 0.49 | 24.32 |
| imported/rsc/match-class-unicode | 1 | 571.39 ± 0.3% | not timed | not timed | 523.54 ± 0.2% | 83.09 ± 1.1% | not timed | not timed | 570.58 ± 0.6% | | 1.00 | 1.09 | 6.88 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1698.26 ± 1.2% | not timed | not timed | 1130.03 ± 0.2% | 339.70 ± 29.0% | not timed | not timed | 1696.42 ± 0.9% | | 1.00 | 1.50 | 5.00 |
| imported/rsc/anchored-literal-long-non-match | 0 | 25310.83 ± 1.0% | not timed | not timed | 16983.90 ± 0.2% | 5123.55 ± 1.7% | not timed | not timed | 25497.85 ± 0.3% | | 0.99 | 1.49 | 4.94 |
| imported/rsc/anchored-literal-short-match | 4 | 875.17 ± 31.4% | not timed | not timed | 552.55 ± 0.6% | 107.11 ± 5.1% | not timed | not timed | 881.79 ± 4.0% | | 0.99 | 1.58 | 8.17 |
| imported/rsc/anchored-literal-long-match | 4 | 13135.68 ± 3.6% | not timed | not timed | 8477.41 ± 17.8% | 1619.14 ± 3.4% | not timed | not timed | 13311.87 ± 1.3% | | 0.99 | 1.55 | 8.11 |
| imported/rsc/one-pass-short | 17 | 501.48 ± 2.0% | not timed | not timed | 257.72 ± 1.1% | 37.72 ± 13.4% | not timed | not timed | 498.33 ± 5.1% | | 1.01 | 1.95 | 13.29 |
| imported/rsc/one-pass-short-not | 17 | 325.71 ± 8.4% | not timed | not timed | 271.17 ± 0.8% | 33.15 ± 13.0% | not timed | not timed | 321.40 ± 2.1% | | 1.01 | 1.20 | 9.83 |
| imported/rsc/one-pass-long-prefix | 26 | 444.37 ± 2.4% | not timed | not timed | 314.85 ± 0.5% | 124.70 ± 10.9% | not timed | not timed | 450.29 ± 3.4% | | 0.99 | 1.41 | 3.56 |
| imported/rsc/one-pass-long-prefix-not | 26 | 449.63 ± 11.1% | not timed | not timed | 305.84 ± 6.0% | 91.62 ± 10.5% | not timed | not timed | 451.46 ± 7.5% | | 1.00 | 1.47 | 4.91 |
| imported/rsc/long-needle1 | 31 | 67484.77 ± 25.5% | not timed | not timed | 45782.45 ± 0.2% | 4.18 ± 0.2% | not timed | not timed | 67634.59 ± 0.3% | | 1.00 | 1.47 | 16140.94 |
| imported/rsc/long-needle2 | 31 | 67753.81 ± 0.3% | not timed | not timed | 227.14 ± 0.7% | 4.18 ± 0.4% | not timed | not timed | 67783.82 ± 0.4% | | 1.00 | 298.30 | 16201.76 |
| imported/rsc/easy0-32 | 26 | 1268.02 ± 5.5% | not timed | not timed | 1941.11 ± 0.3% | 144.31 ± 7.3% | not timed | not timed | 1268.84 ± 1.9% | | 1.00 | 0.65 | 8.79 |
| imported/rsc/easy0-1k | 26 | 21288.43 ± 2.2% | not timed | not timed | 20385.20 ± 0.2% | 2161.85 ± 33.6% | not timed | not timed | 21413.44 ± 1.0% | | 0.99 | 1.04 | 9.85 |
| imported/rsc/easy0-32k | 26 | 64688.93 ± 6.9% | not timed | not timed | 43855.40 ± 0.4% | 26044.06 ± 32.0% | not timed | not timed | 64947.51 ± 2.2% | | 1.00 | 1.48 | 2.48 |
| imported/rsc/easy0-1mb | 26 | 67105.58 ± 0.5% | not timed | not timed | 46196.38 ± 20.4% | 68114.03 ± 0.8% | not timed | not timed | 66792.51 ± 1.3% | | 1.00 | 1.45 | 0.99 |
| imported/rsc/easy1-32 | 19 | 925.29 ± 2.0% | not timed | not timed | 738.75 ± 0.8% | 127.57 ± 32.8% | not timed | not timed | 930.16 ± 9.3% | | 0.99 | 1.25 | 7.25 |
| imported/rsc/easy1-1k | 19 | 19018.09 ± 3.0% | not timed | not timed | 15757.49 ± 0.7% | 2413.68 ± 23.8% | not timed | not timed | 19058.98 ± 2.6% | | 1.00 | 1.21 | 7.88 |
| imported/rsc/easy1-32k | 19 | 596610.57 ± 2.7% | not timed | not timed | 488051.93 ± 0.7% | 29380.75 ± 16.1% | not timed | not timed | 598848.20 ± 0.1% | | 1.00 | 1.22 | 20.31 |
| imported/rsc/easy1-1mb | 19 | 19158286.18 ± 1.8% | not timed | not timed | 15760052.37 ± 0.6% | 68076.77 ± 0.6% | not timed | not timed | 19154365.66 ± 0.8% | | 1.00 | 1.22 | 281.42 |
| imported/rsc/medium-32 | 27 | 873.03 ± 2.2% | not timed | not timed | 742.48 ± 0.2% | 80.75 ± 17.0% | not timed | not timed | 855.08 ± 0.5% | | 1.02 | 1.18 | 10.81 |
| imported/rsc/medium-1k | 27 | 15527.12 ± 0.5% | not timed | not timed | 12937.06 ± 0.7% | 81.33 ± 2.4% | not timed | not timed | 15192.79 ± 1.2% | | 1.02 | 1.20 | 190.92 |
| imported/rsc/medium-32k | 27 | 484318.76 ± 7.1% | not timed | not timed | 405002.05 ± 3.7% | 54.39 ± 1.0% | not timed | not timed | 475168.10 ± 0.3% | | 1.02 | 1.20 | 8904.95 |
| imported/rsc/medium-1mb | 27 | 15555313.92 ± 1.3% | not timed | not timed | 13153033.11 ± 1.3% | 54.65 ± 3.0% | not timed | not timed | 15241810.09 ± 16.6% | | 1.02 | 1.18 | 284653.66 |
| imported/rsc/hard-32 | 58 | 449.78 ± 6.9% | not timed | not timed | 390.55 ± 0.8% | 48.80 ± 7.2% | not timed | not timed | 446.29 ± 0.2% | | 1.01 | 1.15 | 9.22 |
| imported/rsc/hard-1k | 27 | 14522.71 ± 3.2% | not timed | not timed | 13029.27 ± 0.5% | 44.40 ± 1.4% | not timed | not timed | 14168.92 ± 5.9% | | 1.02 | 1.11 | 327.05 |
| imported/rsc/hard-32k | 27 | 461899.90 ± 4.7% | not timed | not timed | 407022.53 ± 1.3% | 33.01 ± 6.2% | not timed | not timed | 455789.56 ± 2.7% | | 1.01 | 1.13 | 13994.77 |
| imported/rsc/hard-1mb | 51 | 8929602.89 ± 0.4% | not timed | not timed | 7855467.95 ± 0.3% | 33.05 ± 0.7% | not timed | not timed | 8917749.97 ± 0.3% | | 1.00 | 1.14 | 270196.29 |
| imported/rsc/reallyhard0-32 | 58 | 281.97 ± 2.2% | not timed | not timed | 244.63 ± 0.5% | 49.03 ± 35.4% | not timed | not timed | 282.33 ± 0.4% | | 1.00 | 1.15 | 5.75 |
| imported/rsc/reallyhard0-1k | 27 | 591.06 ± 0.4% | not timed | not timed | 580.06 ± 0.4% | 44.60 ± 0.7% | not timed | not timed | 591.41 ± 0.5% | | 1.00 | 1.02 | 13.25 |
| imported/rsc/reallyhard0-32k | 27 | 607.87 ± 0.4% | not timed | not timed | 602.92 ± 0.6% | 32.97 ± 0.3% | not timed | not timed | 608.21 ± 0.6% | | 1.00 | 1.01 | 18.44 |
| imported/rsc/reallyhard0-1mb | 51 | 608.58 ± 0.6% | not timed | not timed | 605.49 ± 0.2% | 33.17 ± 2.4% | not timed | not timed | 609.68 ± 0.1% | | 1.00 | 1.01 | 18.35 |
| imported/rsc/reallyreallyhard0-32 | 47 | 331.31 ± 1.8% | not timed | not timed | 209.06 ± 0.2% | 62.50 ± 35.9% | not timed | not timed | 336.12 ± 1.4% | | 0.99 | 1.58 | 5.30 |
| imported/rsc/reallyreallyhard0-1k | 16 | 8209.75 ± 2.0% | not timed | not timed | 7652.43 ± 0.2% | 36.73 ± 1.8% | not timed | not timed | 8216.24 ± 0.3% | | 1.00 | 1.07 | 223.50 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52531.85 ± 0.3% | not timed | not timed | 36636.32 ± 0.1% | 26.57 ± 0.1% | not timed | not timed | 52694.90 ± 0.3% | | 1.00 | 1.43 | 1977.29 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 71575.28 ± 0.4% | not timed | not timed | 45527.85 ± 0.2% | 26.93 ± 0.2% | not timed | not timed | 71390.73 ± 23.6% | | 1.00 | 1.57 | 2657.96 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 324.83 ± 1.5% | not timed | not timed | 216.99 ± 8.2% | 61.84 ± 8.9% | not timed | not timed | 324.84 ± 12.8% | | 1.00 | 1.50 | 5.25 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6799.90 ± 1.7% | not timed | not timed | 7512.57 ± 13.2% | 36.66 ± 1.9% | not timed | not timed | 6811.98 ± 0.2% | | 1.00 | 0.91 | 185.47 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 49392.93 ± 0.3% | not timed | not timed | 37197.48 ± 0.3% | 26.81 ± 0.2% | not timed | not timed | 47515.49 ± 0.2% | | 1.04 | 1.33 | 1842.05 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 64014.20 ± 22.2% | not timed | not timed | 45280.49 ± 0.7% | 26.91 ± 10.0% | not timed | not timed | 64407.00 ± 0.4% | | 0.99 | 1.41 | 2378.54 |
| imported/sherlock/name-sherlock | 776 | 47425.81 ± 8.6% | not timed | not timed | 40224.63 ± 1.9% | 13634.76 ± 15.2% | not timed | not timed | 51182.47 ± 9.4% | | 0.93 | 1.18 | 3.48 |
| imported/sherlock/name-holmes | 2766 | 27498.87 ± 4.4% | not timed | not timed | 29808.36 ± 1.8% | 3934.92 ± 10.4% | not timed | not timed | 28150.00 ± 2.7% | | 0.98 | 0.92 | 6.99 |
| imported/sherlock/name-sherlock-holmes | 1365 | 51680.54 ± 8.9% | not timed | not timed | 40155.82 ± 1.0% | 10350.79 ± 18.3% | not timed | not timed | 51658.34 ± 8.6% | | 1.00 | 1.29 | 4.99 |
| imported/sherlock/name-sherlock-casei | 816 | 46559.16 ± 0.7% | not timed | not timed | 11559.31 ± 1.1% | 34.04 ± 0.3% | not timed | not timed | 46629.17 ± 1.1% | | 1.00 | 4.03 | 1367.90 |
| imported/sherlock/name-holmes-casei | 2802 | 22653.39 ± 0.6% | not timed | not timed | 7656.70 ± 0.4% | 44.53 ± 2.1% | not timed | not timed | 22682.37 ± 0.4% | | 1.00 | 2.96 | 508.76 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36814.87 ± 0.4% | not timed | not timed | 11213.18 ± 1.2% | 33.91 ± 1.9% | not timed | not timed | 36710.01 ± 2.4% | | 1.00 | 3.28 | 1085.60 |
| imported/sherlock/name-whitespace | 1461 | 29626.38 ± 8.7% | not timed | not timed | 28183.74 ± 2.5% | 8515.46 ± 14.9% | not timed | not timed | 30465.45 ± 1.7% | | 0.97 | 1.05 | 3.48 |
| imported/sherlock/name-alt1 | 1142 | 31293.28 ± 1.1% | not timed | not timed | 30028.47 ± 0.3% | 5644.90 ± 22.0% | not timed | not timed | 31415.53 ± 1.6% | | 1.00 | 1.04 | 5.54 |
| imported/sherlock/name-alt2 | 3542 | 21143.43 ± 0.6% | not timed | not timed | 10079.75 ± 0.2% | 36.07 ± 0.2% | not timed | not timed | 21222.12 ± 0.3% | | 1.00 | 2.10 | 586.20 |
| imported/sherlock/name-alt3 | 4507 | 13608.23 ± 1.6% | not timed | not timed | 9194.27 ± 0.5% | 11.28 ± 0.4% | not timed | not timed | 13631.88 ± 0.6% | | 1.00 | 1.48 | 1206.69 |
| imported/sherlock/name-alt3-casei | 4593 | 3533.91 ± 4.3% | not timed | not timed | 1310.56 ± 0.2% | 7.50 ± 1.3% | not timed | not timed | 3550.81 ± 3.1% | | 1.00 | 2.70 | 471.28 |
| imported/sherlock/name-alt4 | 3686 | 9945.20 ± 0.7% | not timed | not timed | 8106.23 ± 0.3% | 35.52 ± 0.8% | not timed | not timed | 9949.92 ± 0.5% | | 1.00 | 1.23 | 279.97 |
| imported/sherlock/name-alt4-casei | 4254 | 5422.25 ± 1.6% | not timed | not timed | 4445.13 ± 0.9% | 20.75 ± 1.3% | not timed | not timed | 5475.97 ± 1.2% | | 0.99 | 1.22 | 261.25 |
| imported/sherlock/name-alt5 | 4028 | 17271.63 ± 0.1% | not timed | not timed | 9674.87 ± 0.6% | 24.92 ± 0.6% | not timed | not timed | 17299.65 ± 0.6% | | 1.00 | 1.79 | 692.97 |
| imported/sherlock/name-alt5-casei | 4104 | 7012.78 ± 0.6% | not timed | not timed | 3006.61 ± 1.7% | 15.48 ± 3.0% | not timed | not timed | 7048.14 ± 14.0% | | 0.99 | 2.33 | 452.90 |
| imported/sherlock/no-match-uncommon | 0 | 68460.89 ± 0.2% | not timed | not timed | 58030.00 ± 0.5% | 57968.35 ± 1.8% | not timed | not timed | 68579.76 ± 1.0% | | 1.00 | 1.18 | 1.18 |
| imported/sherlock/no-match-common | 0 | 66913.02 ± 1.1% | not timed | not timed | 58081.99 ± 1.2% | 2133.62 ± 0.3% | not timed | not timed | 67027.99 ± 0.2% | | 1.00 | 1.15 | 31.36 |
| imported/sherlock/no-match-really-common | 0 | 42964.07 ± 20.0% | not timed | not timed | 49756.11 ± 0.7% | 2136.12 ± 7.4% | not timed | not timed | 42991.51 ± 0.8% | | 1.00 | 0.86 | 20.11 |
| imported/sherlock/the-lower | 21654 | 3997.42 ± 1.2% | not timed | not timed | 3945.04 ± 3.1% | 268.34 ± 15.9% | not timed | not timed | 4000.82 ± 4.5% | | 1.00 | 1.01 | 14.90 |
| imported/sherlock/the-upper | 2223 | 20899.81 ± 1.7% | not timed | not timed | 29035.64 ± 0.7% | 3046.81 ± 14.7% | not timed | not timed | 20977.46 ± 1.9% | | 1.00 | 0.72 | 6.86 |
| imported/sherlock/the-casei | 23961 | 3492.30 ± 3.6% | not timed | not timed | 1359.64 ± 0.2% | 41.57 ± 16.6% | not timed | not timed | 3503.84 ± 0.5% | | 1.00 | 2.57 | 84.01 |
| imported/sherlock/everything-greedy | 581881 | 295.08 ± 0.9% | not timed | not timed | 172.69 ± 1.0% | 30.64 ± 29.3% | not timed | not timed | 295.32 ± 1.0% | | 1.00 | 1.71 | 9.63 |
| imported/sherlock/everything-greedy-nl | 594933 | 464.66 ± 0.4% | not timed | not timed | 219.95 ± 0.7% | 34.68 ± 1.0% | not timed | not timed | 464.68 ± 0.1% | | 1.00 | 2.11 | 13.40 |
| imported/sherlock/letters | 447175 | 66.72 ± 9.2% | not timed | not timed | 33.46 ± 1.3% | 5.51 ± 44.2% | not timed | not timed | 67.41 ± 21.7% | | 0.99 | 1.99 | 12.12 |
| imported/sherlock/letters-upper | 14180 | 451.97 ± 1.4% | not timed | not timed | 361.73 ± 1.4% | 29.63 ± 23.2% | not timed | not timed | 452.94 ± 0.8% | | 1.00 | 1.25 | 15.26 |
| imported/sherlock/letters-lower | 432995 | 68.10 ± 3.0% | not timed | not timed | 34.44 ± 4.0% | 6.76 ± 43.8% | not timed | not timed | 67.09 ± 1.9% | | 1.02 | 1.98 | 10.07 |
| imported/sherlock/words | 447639 | 120.84 ± 4.5% | not timed | not timed | 82.65 ± 0.6% | 14.77 ± 19.0% | not timed | not timed | 120.18 ± 4.1% | | 1.01 | 1.46 | 8.18 |
| imported/sherlock/before-holmes | 4073 | 15204.78 ± 2.8% | not timed | not timed | 13336.31 ± 0.4% | 25.60 ± 1.0% | not timed | not timed | 15274.35 ± 0.4% | | 1.00 | 1.14 | 593.98 |
| imported/sherlock/before-after-holmes | 2593 | 14965.11 ± 0.2% | not timed | not timed | 15025.74 ± 1.2% | 25.67 ± 1.0% | not timed | not timed | 15064.91 ± 3.2% | | 0.99 | 1.00 | 582.90 |
| imported/sherlock/holmes-cochar-watson | 150 | 10020.65 ± 0.4% | not timed | not timed | 7680.74 ± 0.5% | 35.41 ± 0.7% | not timed | not timed | 10088.36 ± 0.4% | | 0.99 | 1.30 | 282.97 |
| imported/sherlock/holmes-coword-watson | 14309 | 1271.53 ± 1.0% | not timed | not timed | 1231.04 ± 0.2% | 7.58 ± 9.8% | not timed | not timed | 1275.48 ± 0.4% | | 1.00 | 1.03 | 167.83 |
| imported/sherlock/quotes | 14437 | 1362.54 ± 0.7% | not timed | not timed | 2254.03 ± 3.2% | 37.64 ± 0.2% | not timed | not timed | 1355.28 ± 1.4% | | 1.01 | 0.60 | 36.20 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 606.07 ± 0.8% | not timed | not timed | 31485.94 ± 0.9% | 40.37 ± 0.4% | not timed | not timed | 606.12 ± 0.6% | | 1.00 | 0.0192 | 15.01 |
| imported/sherlock/word-ending-n | 35297 | 476.62 ± 0.5% | not timed | not timed | 401.53 ± 0.5% | 25.83 ± 3.3% | not timed | not timed | 474.84 ± 11.3% | | 1.00 | 1.19 | 18.45 |
| imported/sherlock/repeated-class-negation | 2130 | 19169.67 ± 0.3% | not timed | not timed | 16428.90 ± 0.3% | 12.39 ± 11.4% | not timed | not timed | 19163.23 ± 0.4% | | 1.00 | 1.17 | 1547.53 |
| imported/sherlock/ing-suffix | 20547 | 573.59 ± 1.4% | not timed | not timed | 488.22 ± 0.6% | 30.55 ± 23.0% | not timed | not timed | 572.94 ± 3.4% | | 1.00 | 1.17 | 18.78 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 605.15 ± 5.0% | not timed | not timed | 2911.07 ± 2.2% | 22.85 ± 3.2% | not timed | not timed | 606.61 ± 0.3% | | 1.00 | 0.21 | 26.48 |
| opt/accelerate/whole-line | 239963 | 504.46 ± 0.3% | not timed | not timed | 414.51 ± 0.4% | 92.31 ± 15.8% | not timed | not timed | 502.61 ± 1.2% | | 1.00 | 1.22 | 5.46 |
| opt/accelerate/non-dna | 16745 | 449.52 ± 1.8% | not timed | not timed | 438.10 ± 0.1% | 32.32 ± 67.7% | not timed | not timed | 453.41 ± 0.4% | | 0.99 | 1.03 | 13.91 |
| opt/backtrack/words-english | 40536 | 141.30 ± 3.0% | not timed | not timed | 110.76 ± 15.4% | 18.61 ± 18.8% | not timed | not timed | 140.70 ± 5.3% | | 1.00 | 1.28 | 7.59 |
| opt/fixed-length/too-small-ascii | 0 | 391.33 ± 0.6% | not timed | not timed | 708.25 ± 0.5% | 121.94 ± 5.6% | not timed | not timed | 391.01 ± 0.2% | | 1.00 | 0.55 | 3.21 |
| opt/fixed-length/too-big-ascii | 0 | 4306.62 ± 1.7% | not timed | not timed | 6317.76 ± 5.1% | 149.90 ± 2.7% | not timed | not timed | 4342.64 ± 1.6% | | 0.99 | 0.68 | 28.73 |
| opt/fixed-length/go33484-1 | 0 | 835733.55 ± 2.3% | not timed | not timed | 1213387.88 ± 0.7% | 89070.11 ± 2.9% | not timed | not timed | 834139.60 ± 0.5% | | 1.00 | 0.69 | 9.38 |
| opt/fixed-length/go33484-2 | 0 | 829815.86 ± 1.6% | not timed | not timed | 1215641.74 ± 0.4% | 29666.90 ± 13.9% | not timed | not timed | 835331.99 ± 1.1% | | 0.99 | 0.68 | 27.97 |
| opt/fixed-length/go33484-3 | 0 | 2456.17 ± 0.6% | not timed | not timed | 121391.54 ± 0.5% | 939.47 ± 0.3% | not timed | not timed | 2410.37 ± 0.3% | | 1.02 | 0.0202 | 2.61 |
| opt/literal-alt/one-pattern | 1 | 580.99 ± 1.2% | not timed | not timed | 570.40 ± 0.7% | 0.39 ± 2.1% | not timed | not timed | 581.37 ± 1.2% | | 1.00 | 1.02 | 1494.19 |
| opt/onepass/fn-predicate | 916 | 431.54 ± 2.3% | not timed | not timed | 385.12 ± 0.9% | 209.04 ± 15.7% | not timed | not timed | 436.34 ± 0.7% | | 0.99 | 1.12 | 2.06 |
| opt/onepass/first-three-words-english | 35128 | 175.50 ± 2.4% | not timed | not timed | 229.51 ± 0.4% | 73.18 ± 12.7% | not timed | not timed | 178.27 ± 2.1% | | 0.98 | 0.76 | 2.40 |
| opt/prefilter/literal-english | 1 | 69094.36 ± 0.4% | not timed | not timed | 46538.26 ± 0.5% | 26992.53 ± 0.8% | not timed | not timed | 69029.74 ± 0.3% | | 1.00 | 1.48 | 2.56 |
| opt/prefilter/literal-casei-english | 1 | 47192.08 ± 34.6% | not timed | not timed | 14257.93 ± 0.3% | 34.14 ± 3.1% | not timed | not timed | 47250.88 ± 0.3% | | 1.00 | 3.31 | 1382.34 |
| opt/prefilter/literal-russian | 1 | 67803.51 ± 11.4% | not timed | not timed | 46347.55 ± 2.2% | 1803.09 ± 10.4% | not timed | not timed | 67332.12 ± 1.2% | | 1.01 | 1.46 | 37.60 |
| opt/prefilter/literal-casei-russian | 1 | 26160.48 ± 17.5% | not timed | not timed | 11023.51 ± 0.2% | 37.69 ± 0.9% | not timed | not timed | 26161.74 ± 0.2% | | 1.00 | 2.37 | 694.08 |
| opt/prefilter/rust-functions | 948 | 14271.38 ± 1.2% | not timed | not timed | 12790.75 ± 16.3% | 1950.81 ± 7.2% | not timed | not timed | 14651.13 ± 2.6% | | 0.97 | 1.12 | 7.32 |
| opt/reverse-anchored/word-end | 1 | 35619391.15 ± 0.3% | not timed | not timed | 27264367.58 ± 0.6% | 56.62 ± 0.5% | not timed | not timed | 35172719.36 ± 0.9% | | 1.01 | 1.31 | 629055.62 |
| opt/reverse-inner/holmes | 2593 | 14958.90 ± 0.5% | not timed | not timed | 15025.63 ± 0.1% | 25.39 ± 2.1% | not timed | not timed | 15047.38 ± 0.4% | | 0.99 | 1.00 | 589.11 |
| opt/reverse-inner/email | 47 | 84386.71 ± 0.9% | not timed | not timed | 92530.99 ± 1.6% | 35.23 ± 0.5% | not timed | not timed | 84731.36 ± 12.0% | | 1.00 | 0.91 | 2395.06 |
| opt/reverse-inner/factored-prefix | 3542 | 600.05 ± 0.3% | not timed | not timed | 585.34 ± 0.3% | 13.96 ± 13.8% | not timed | not timed | 600.18 ± 0.1% | | 1.00 | 1.03 | 42.98 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4193.66 ± 0.1% | not timed | not timed | 603.61 ± 0.6% | 85.96 ± 0.2% | not timed | not timed | 4198.21 ± 1.3% | | 1.00 | 6.95 | 48.79 |
| opt/reverse-inner/no-quadratic-forward | 0 | 707.94 ± 11.9% | not timed | not timed | 279.01 ± 0.5% | 25.60 ± 2.9% | not timed | not timed | 708.58 ± 1.8% | | 1.00 | 2.54 | 27.65 |
| opt/reverse-suffix/holmes | 4073 | 15254.59 ± 1.4% | not timed | not timed | 13351.24 ± 0.2% | 25.66 ± 0.2% | not timed | not timed | 15278.46 ± 0.3% | | 1.00 | 1.14 | 594.41 |
| opt/reverse-suffix/no-quadratic | 0 | 4195.20 ± 5.4% | not timed | not timed | 604.64 ± 0.2% | 85.84 ± 2.1% | not timed | not timed | 4194.24 ± 24.4% | | 1.00 | 6.94 | 48.87 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 140.70 ± 29.9% | not timed | not timed | 181.77 ± 26.1% | 15.26 ± 23.2% | not timed | not timed | 141.81 ± 13.2% | | 0.99 | 0.77 | 9.22 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 142.22 ± 1.6% | not timed | not timed | 181.16 ± 1.0% | 16.12 ± 22.2% | not timed | not timed | 135.95 ± 9.3% | | 1.05 | 0.79 | 8.82 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.31 ± 2.0% | not timed | not timed | 0.48 ± 0.5% | 120.91 ± 1.3% | not timed | not timed | 0.31 ± 12.9% | | 1.01 | 0.66 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 301.71 ± 0.7% | not timed | not timed | 284.11 ± 0.8% | 109.38 ± 4.8% | not timed | not timed | 301.36 ± 0.4% | | 1.00 | 1.06 | 2.76 |
| reported/i13-subset-regex/original-ascii | 4094 | 11886.89 ± 0.8% | not timed | not timed | 3946.64 ± 3.8% | 12.11 ± 2.4% | not timed | not timed | 11897.94 ± 11.2% | | 1.00 | 3.01 | 981.67 |
| reported/i13-subset-regex/original-unicode | 4094 | 11868.24 ± 1.0% | not timed | not timed | 208.70 ± 1.5% | 12.23 ± 1.6% | not timed | not timed | 10268.12 ± 1.1% | | 1.16 | 56.87 | 970.74 |
| reported/i13-subset-regex/big-ascii | 1955 | 11097.15 ± 1.0% | not timed | not timed | 54.15 ± 3.2% | 10.54 ± 1.5% | not timed | not timed | 11121.52 ± 0.4% | | 1.00 | 204.94 | 1053.15 |
| reported/i13-subset-regex/big-unicode | 1955 | 10965.15 ± 3.0% | not timed | not timed | 9.35 ± 55.7% | 10.52 ± 2.1% | not timed | not timed | 11030.15 ± 1.0% | | 0.99 | 1173.27 | 1042.08 |
| reported/i13-subset-regex/huge-ascii | 55 | 10097.41 ± 1.2% | not timed | not timed | 8.81 ± 0.9% | 9.54 ± 2.9% | not timed | not timed | 10089.97 ± 2.6% | | 1.00 | 1146.71 | 1058.51 |
| reported/i13-subset-regex/huge-unicode | 55 | 9783.26 ± 3.4% | not timed | not timed | 8.91 ± 0.9% | 9.41 ± 2.1% | not timed | not timed | 9882.17 ± 3.2% | | 0.99 | 1098.58 | 1039.27 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.21 ± 0.9% | not timed | not timed | 9.04 ± 0.7% | 9.46 ± 3.6% | not timed | not timed | 4.16 ± 0.5% | | 1.01 | 0.47 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.76 ± 1.0% | not timed | not timed | 8.92 ± 0.4% | 9.60 ± 1.1% | not timed | not timed | 5.83 ± 1.0% | | 0.99 | 0.65 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 541.58 ± 3.4% | not timed | not timed | 172.28 ± 1.1% | 7.36 ± 0.2% | not timed | not timed | 557.67 ± 4.8% | | 0.97 | 3.14 | 73.54 |
| reported/i787-keywords/opt-ascii | 5674 | 555.66 ± 1.8% | not timed | not timed | 274.53 ± 0.3% | 12.02 ± 2.9% | not timed | not timed | 559.89 ± 0.5% | | 0.99 | 2.02 | 46.24 |
| slow/quadratic-regex-1x | 100 | 8.23 ± 7.4% | not timed | not timed | 6.02 ± 0.4% | 0.05 ± 11.9% | not timed | not timed | 8.23 ± 32.3% | | 1.00 | 1.37 | 162.17 |
| slow/quadratic-regex-2x | 199 | 3.71 ± 0.3% | not timed | not timed | 3.05 ± 0.6% | 0.01 ± 1.2% | not timed | not timed | 3.70 ± 0.3% | | 1.00 | 1.22 | 280.20 |
| slow/quadratic-haystack-1x | 100 | 26.19 ± 5.6% | not timed | not timed | 12.16 ± 0.5% | 1.01 ± 15.6% | not timed | not timed | 26.04 ± 3.6% | | 1.01 | 2.15 | 25.85 |
| slow/quadratic-haystack-2x | 200 | 19.83 ± 6.5% | not timed | not timed | 6.13 ± 0.3% | 0.55 ± 5.2% | not timed | not timed | 19.88 ± 1.5% | | 1.00 | 3.24 | 35.95 |
| unicode/codepoints/any-one | 1112064 | 336.58 ± 2.6% | not timed | not timed | 238.94 ± 3.8% | 20.64 ± 7.9% | not timed | not timed | 335.92 ± 0.5% | | 1.00 | 1.41 | 16.31 |
| unicode/codepoints/any-all | 4382592 | 267.84 ± 0.8% | not timed | not timed | 261.32 ± 1.6% | 125.63 ± 19.8% | not timed | not timed | 268.76 ± 1.8% | | 1.00 | 1.02 | 2.13 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.88 ± 0.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.59 ± 2.4% | not timed | not timed | 603.02 ± 0.3% | 148.67 ± 0.9% | not timed | not timed | 609.68 ± 9.6% | | 1.00 | 1.01 | 4.10 |
| unicode/overlapping-words/ascii | 6156 | 28.82 ± 1.6% | not timed | not timed | 42.95 ± 1.3% | 4.07 ± 3.5% | not timed | not timed | 28.99 ± 2.4% | | 0.99 | 0.67 | 7.08 |
| unicode/overlapping-words/english | 6156 | 1.42 ± 6.5% | not timed | not timed | 2.70 ± 3.1% | 2.85 ± 2.6% | not timed | not timed | 1.44 ± 0.9% | | 0.99 | 0.53 | 0.50 |
| unicode/overlapping-words/russian | 5710 | 1.27 ± 17.9% | not timed | not timed | 2.96 ± 5.8% | 6.44 ± 9.4% | not timed | not timed | 1.28 ± 5.2% | | 0.99 | 0.43 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 138.09 ± 0.8% | not timed | not timed | 84.68 ± 1.8% | 11.75 ± 22.1% | not timed | not timed | 138.88 ± 2.7% | | 0.99 | 1.63 | 11.75 |
| unicode/word/boundary-long-english | 3466 | 610.98 ± 0.6% | not timed | not timed | 593.97 ± 0.1% | 35.35 ± 0.4% | not timed | not timed | 612.25 ± 0.1% | | 1.00 | 1.03 | 17.28 |
| unicode/word/around-holmes-english | 27 | 64977.71 ± 0.4% | not timed | not timed | 45187.92 ± 0.5% | 23.97 ± 0.6% | not timed | not timed | 64838.69 ± 0.8% | | 1.00 | 1.44 | 2710.27 |
| wild/bibleref/long | 874 | 569.72 ± 0.2% | not timed | not timed | 573.86 ± 0.2% | 7.96 ± 0.1% | not timed | not timed | 571.05 ± 0.4% | | 1.00 | 0.99 | 71.61 |
| wild/bibleref/short | 30 | 22.82 ± 4.0% | not timed | not timed | 32.78 ± 1.0% | 13.21 ± 13.2% | not timed | not timed | 23.99 ± 1.7% | | 0.95 | 0.70 | 1.73 |
| wild/bibleref/line | 874 | 509.45 ± 0.3% | not timed | not timed | 270.59 ± 0.2% | 9.50 ± 2.7% | not timed | not timed | 513.26 ± 0.3% | | 0.99 | 1.88 | 53.62 |
| wild/caddy/caddy | 6 | 441.40 ± 3.3% | not timed | not timed | 291.55 ± 23.3% | 75.86 ± 12.6% | not timed | not timed | 445.49 ± 1.3% | | 0.99 | 1.51 | 5.82 |
| wild/dot-star-capture/rust-src-tools | 6 | 1454.20 ± 0.3% | not timed | not timed | 404.00 ± 0.5% | 15.87 ± 0.4% | not timed | not timed | 1452.87 ± 0.2% | | 1.00 | 3.60 | 91.62 |
| wild/ruff/noqa | 84 | 511.66 ± 0.5% | not timed | not timed | 498.36 ± 5.1% | 21.04 ± 5.0% | not timed | not timed | 512.58 ± 16.6% | | 1.00 | 1.03 | 24.32 |
| wild/ruff/unnecessary-coding-comment | 16 | 1074.17 ± 0.5% | not timed | not timed | 724.02 ± 0.7% | 86.36 ± 9.4% | not timed | not timed | 1072.62 ± 12.8% | | 1.00 | 1.48 | 12.44 |
| wild/ruff/string-quote-prefix | 2972 | 1579.09 ± 4.5% | not timed | not timed | 445.44 ± 0.2% | 318.12 ± 29.6% | not timed | not timed | 1587.13 ± 0.8% | | 0.99 | 3.55 | 4.96 |
| wild/ruff/space-around-operator | 1224378 | 236.53 ± 3.7% | not timed | not timed | 221.74 ± 0.4% | 18.67 ± 3.1% | not timed | not timed | 236.78 ± 1.9% | | 1.00 | 1.07 | 12.67 |
| wild/ruff/shebang | 282 | 1117.53 ± 10.0% | not timed | not timed | 386.74 ± 0.3% | 113.29 ± 8.4% | not timed | not timed | 1121.15 ± 2.3% | | 1.00 | 2.89 | 9.86 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22535.91 ± 0.6% | not timed | not timed | 23375.64 ± 1.4% | 8902.11 ± 2.0% | not timed | not timed | 21901.72 ± 0.4% | | 1.03 | 0.96 | 2.53 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20379.23 ± 2.8% | not timed | not timed | 22321.64 ± 1.1% | 8352.24 ± 0.6% | not timed | not timed | 20451.21 ± 1.9% | | 1.00 | 0.91 | 2.44 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22990.73 ± 1.5% | not timed | not timed | 23274.05 ± 2.0% | 8734.04 ± 33.7% | not timed | not timed | 22876.16 ± 4.2% | | 1.01 | 0.99 | 2.63 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 18101.19 ± 14.2% | not timed | not timed | 23457.70 ± 0.5% | 8748.80 ± 9.4% | not timed | not timed | 18181.95 ± 4.4% | | 1.00 | 0.77 | 2.07 |
| wild/url/search | 234965 | 127.61 ± 13.8% | not timed | not timed | 59.55 ± 17.5% | 2.44 ± 1.1% | not timed | not timed | 125.13 ± 13.0% | | 1.02 | 2.14 | 52.29 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 67.4% | not timed | not timed | 0.01 ± 3.6% | 0.01 ± 23.8% | not timed | not timed | 0.03 ± 15.3% | | 1.00 | 2.55 | 4.31 |
| dictionary/compile/english-15 | 1 | 0.34 ± 5.4% | not timed | not timed | 0.09 ± 5.7% | 0.11 ± 32.2% | not timed | not timed | 0.35 ± 16.7% | | 0.99 | 3.84 | 3.13 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.28 ± 10.5% | not timed | not timed | 0.02 ± 2.7% | 36.55 ± 32.4% | not timed | not timed | 0.29 ± 29.8% | | 0.96 | 12.21 | 0.0078 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.06 ± 10.6% | not timed | not timed | 17.06 ± 1.2% | 62.33 ± 20.8% | not timed | not timed | 44.23 ± 3.5% | | 1.02 | 2.64 | 0.72 |
| reported/i787-keywords/compile | 1 | 40.50 ± 4.5% | not timed | not timed | 2.39 ± 3.8% | 16.35 ± 23.4% | not timed | not timed | 40.46 ± 4.2% | | 1.00 | 16.96 | 2.48 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 378.10 ± 6.2% | not timed | not timed | 146.38 ± 0.6% | 590.88 ± 27.8% | not timed | not timed | 378.84 ± 9.9% | | 1.00 | 2.58 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.45 ± 6.9% | not timed | not timed | 5.47 ± 30.8% | 46.66 ± 9.9% | not timed | not timed | 53.16 ± 4.5% | | 1.01 | 9.77 | 1.15 |
| unicode/compile/one-letter | 53 | 6.95 ± 1.6% | not timed | not timed | 5.70 ± 4.2% | 62.12 ± 6.1% | not timed | not timed | 6.87 ± 28.6% | | 1.01 | 1.22 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.24 ± 18.6% | not timed | not timed | 0.12 ± 1.3% | 64.09 ± 8.7% | not timed | not timed | 1.25 ± 1.5% | | 0.99 | 10.06 | 0.0193 |
| unicode/compile/fifty-letters-ascii | 1 | 192.54 ± 10.8% | not timed | not timed | 70.17 ± 0.3% | 206.15 ± 12.0% | not timed | not timed | 205.00 ± 7.6% | | 0.94 | 2.74 | 0.93 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 447.58 ± 4.8% | not timed | not timed | 50.12 ± 1.9% | 702.91 ± 16.9% | not timed | not timed | 455.78 ± 3.2% | | 0.98 | 8.93 | 0.64 |
| unicode/compile/match-every-line-ascii | 4 | 709.60 ± 4.0% | not timed | not timed | 166.47 ± 0.7% | 725.20 ± 15.0% | not timed | not timed | 712.06 ± 4.3% | | 1.00 | 4.26 | 0.98 |
| unicode/compile/negated-class-matches-codepoint | 1 | 372.44 ± 21.7% | not timed | not timed | 55.30 ± 0.8% | 1332.95 ± 16.2% | not timed | not timed | 370.76 ± 1.4% | | 1.00 | 6.73 | 0.28 |
| wild/bibleref/compile | 3 | 6.00 ± 11.8% | not timed | not timed | 2.42 ± 1.6% | 34.30 ± 22.8% | not timed | not timed | 6.24 ± 7.4% | | 0.96 | 2.48 | 0.17 |
| wild/url/compile | 1 | 0.72 ± 18.3% | not timed | not timed | 0.20 ± 2.9% | 0.49 ± 26.7% | not timed | not timed | 0.72 ± 18.7% | | 1.00 | 3.60 | 1.47 |

