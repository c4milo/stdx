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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507016562 |
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
| literal: a word | 217 | 48577.49 ± 1.5% | 4001.65 ± 0.5% | 31.36 ± 1.4% | 38816.65 ± 0.5% | 11937.59 ± 1.8% | 12.13 ± 0.2% | 103.36 ± 0.8% | 48627.32 ± 0.5% | 12.14 | 1.00 | 1.25 | 4.07 |
| literal: a word that is not there | 0 | 63790.30 ± 1.2% | 3895.55 ± 0.7% | 31.32 ± 0.4% | 45746.92 ± 0.7% | 44016.01 ± 3.2% | 12.09 ± 0.1% | 98.35 ± 0.4% | 63860.06 ± 0.5% | 16.38 | 1.00 | 1.39 | 1.45 |
| literal: one of four words | 661 | 16988.64 ± 7.2% | 1696.24 ± 0.3% | 16.98 ± 0.8% | 11107.86 ± 0.2% | 24.95 ± 0.6% | 4.44 ± 0.4% | 8.60 ± 0.4% | 17014.42 ± 7.6% | 10.02 | 1.00 | 1.53 | 680.95 |
| literal: a word in any case | 217 | 42361.02 ± 9.3% | 1810.01 ± 0.4% | 24.11 ± 1.3% | 10998.75 ± 0.2% | 47.31 ± 0.3% | refused | differs | 42524.31 ± 0.7% | 23.40 | 1.00 | 3.85 | 895.44 |
| literal: an href attribute | 33 | 41443.69 ± 0.4% | 615.89 ± 0.1% | 30.01 ± 4.9% | 34968.01 ± 0.7% | 2931.57 ± 5.4% | 9.38 ± 0.2% | 91.31 ± 0.5% | 41498.09 ± 0.6% | 67.29 | 1.00 | 1.19 | 14.14 |
| literal: a word, second text | 123 | 50835.24 ± 4.0% | 3143.08 ± 1.9% | 30.96 ± 0.6% | 39594.93 ± 1.3% | 11063.64 ± 7.8% | 12.88 ± 0.5% | 87.73 ± 0.4% | 50842.23 ± 0.3% | 16.17 | 1.00 | 1.28 | 4.59 |
| class: two capitalized words | 1331 | 925.73 ± 0.1% | 611.87 ± 0.2% | 28.92 ± 0.5% | 575.34 ± 0.3% | 44.56 ± 1.1% | 10.46 ± 0.1% | 79.71 ± 0.2% | 926.40 ± 0.3% | 1.51 | 1.00 | 1.61 | 20.78 |
| class: a word that ends in ing | 3399 | 584.55 ± 0.3% | 584.46 ± 0.7% | 20.31 ± 0.6% | 539.22 ± 0.2% | 32.93 ± 10.0% | 5.82 ± 0.5% | 20.62 ± 1.0% | 584.89 ± 0.6% | 1.00 | 1.00 | 1.08 | 17.75 |
| class: a word in capitals | 2332 | 1162.77 ± 0.2% | 617.97 ± 0.1% | 30.59 ± 0.1% | 566.43 ± 0.3% | 46.81 ± 3.2% | 11.48 ± 0.1% | 102.38 ± 0.2% | 1161.93 ± 0.3% | 1.88 | 1.00 | 2.05 | 24.84 |
| class: a number | 8288 | 2032.06 ± 0.5% | 856.25 ± 0.2% | 30.92 ± 0.7% | 1809.44 ± 0.2% | 48.05 ± 11.5% | 0.38 ± 0.4% | 73.24 ± 0.4% | 2017.05 ± 0.7% | 2.37 | 1.01 | 1.12 | 42.29 |
| class: two capitalized words, second text | 5359 | 521.19 ± 3.8% | 529.29 ± 2.4% | 26.15 ± 1.0% | 478.14 ± 0.3% | 34.70 ± 9.3% | 11.48 ± 2.4% | 73.96 ± 20.2% | 522.64 ± 0.9% | 0.98 | 1.00 | 1.09 | 15.02 |
| other: a word between two words | 6104 | 926.01 ± 0.1% | 606.68 ± 0.4% | 26.03 ± 0.2% | 813.00 ± 0.3% | 126.96 ± 9.1% | 8.04 ± 0.2% | 82.42 ± 0.3% | 924.48 ± 0.5% | 1.53 | 1.00 | 1.14 | 7.29 |
| other: a number before a unit, second text | 1481 | 11197.54 ± 0.4% | 1067.71 ± 0.7% | 28.00 ± 0.4% | 8206.01 ± 0.2% | 45.27 ± 1.2% | 11.96 ± 0.3% | 77.91 ± 0.2% | 11165.86 ± 0.6% | 10.49 | 1.00 | 1.36 | 247.34 |
| other: a heading's start tag | 110 | 26404.67 ± 0.2% | 747.51 ± 0.3% | 30.55 ± 1.1% | 2502.12 ± 1.3% | 1930.49 ± 9.2% | 11.38 ± 0.2% | 106.27 ± 0.3% | 26371.86 ± 0.1% | 35.32 | 1.00 | 10.55 | 13.68 |
| other: a whole word | 217 | 34137.83 ± 0.4% | 607.91 ± 0.2% | 31.45 ± 0.6% | 28305.16 ± 0.4% | 54.32 ± 0.8% | 10.71 ± 0.1% | 63.40 ± 0.4% | 34378.26 ± 0.1% | 56.16 | 0.99 | 1.21 | 628.48 |
| other: a line's first word, second text | 3716 | 2796.86 ± 0.3% | 600.33 ± 0.4% | 35.07 ± 0.7% | 2326.66 ± 1.7% | 71.21 ± 23.9% | refused | refused | 2811.48 ± 1.3% | 4.66 | 0.99 | 1.20 | 39.28 |
| other: fourteen octets before an x | 87 | 38609.94 ± 0.8% | 242.02 ± 2.1% | 7.38 ± 5.0% | 3509.13 ± 1.7% | 11.59 ± 1.5% | differs | 21.50 ± 1.9% | 39003.40 ± 1.2% | 159.53 | 0.99 | 11.00 | 3330.90 |
| other: a Greek word | 21815 | 516.91 ± 0.3% | 442.57 ± 0.2% | 34.42 ± 0.4% | 304.62 ± 0.2% | 54.65 ± 11.8% | differs | refused | 516.92 ± 5.7% | 1.17 | 1.00 | 1.70 | 9.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 32.35 ± 0.3% | 32.34 ± 11.4% | 0.99 ± 0.9% | 19.88 ± 0.3% | 2.11 ± 0.8% | differs | 4.30 ± 1.4% | 32.22 ± 7.7% | 1.00 | 1.00 | 1.63 | 15.32 |
| a UUID | 32895 | 26.84 ± 6.2% | 27.18 ± 0.3% | 0.68 ± 2.0% | 15.10 ± 0.2% | 3.04 ± 3.6% | 0.51 ± 0.6% | 3.83 ± 0.8% | 26.96 ± 4.9% | 0.99 | 1.00 | 1.78 | 8.84 |
| an IPv4 address | 33176 | 40.66 ± 0.3% | 40.68 ± 0.4% | 2.23 ± 1.8% | 28.47 ± 0.3% | 7.01 ± 2.0% | differs | 3.94 ± 4.6% | 40.68 ± 0.4% | 1.00 | 1.00 | 1.43 | 5.80 |
| a date and time | 32954 | 37.83 ± 0.4% | 38.02 ± 0.7% | 1.66 ± 1.1% | 21.67 ± 0.4% | 8.19 ± 2.2% | 0.89 ± 0.4% | 8.07 ± 1.7% | 37.16 ± 1.0% | 0.99 | 1.02 | 1.75 | 4.62 |
| a field path | 32606 | 34.91 ± 9.3% | 34.74 ± 1.8% | 1.05 ± 2.6% | 23.00 ± 0.2% | 3.47 ± 1.6% | differs | 3.08 ± 0.4% | 34.88 ± 2.2% | 1.00 | 1.00 | 1.52 | 10.05 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.15 ± 8.8% | 10.84 ± 0.7% | 10.90 ± 0.4% | 13.48 ± 0.9% | 5.85 ± 4.0% | 0.74 ± 0.5% | none | 10.87 ± 0.3% | 0.94 | 0.93 | 0.75 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 255.09 ± 1.5% | 255.36 ± 0.8% | 298.73 ± 0.3% | 101.29 ± 1.5% | 237.03 ± 14.4% | 710.95 ± 4.4% | 4961.55 ± 0.5% | 255.05 ± 0.7% | 1.00 | 1.00 | 2.52 | 1.08 |
| a UUID | 62 | 166.99 ± 0.2% | 166.92 ± 0.3% | 186.86 ± 0.4% | 59.32 ± 1.8% | 118.53 ± 13.7% | 254.70 ± 1.7% | 5539.40 ± 0.9% | 167.00 ± 0.3% | 1.00 | 1.00 | 2.81 | 1.41 |
| an IPv4 address | 29 | 492.24 ± 10.0% | 496.51 ± 2.5% | 691.51 ± 1.9% | 88.26 ± 0.5% | 147.63 ± 15.5% | 421.43 ± 2.9% | 8944.50 ± 0.7% | 496.14 ± 0.8% | 0.99 | 0.99 | 5.58 | 3.33 |
| a date and time | 56 | 356.81 ± 0.7% | 356.85 ± 0.2% | 449.49 ± 0.3% | 86.92 ± 0.2% | 159.60 ± 2.5% | 470.87 ± 1.2% | 5696.24 ± 0.4% | 356.83 ± 0.8% | 1.00 | 1.00 | 4.10 | 2.24 |
| a field path | 39 | 252.29 ± 0.3% | 252.42 ± 0.2% | 294.92 ± 0.2% | 95.67 ± 2.0% | 229.09 ± 2.6% | 754.66 ± 2.4% | 6029.47 ± 1.1% | 252.10 ± 0.2% | 1.00 | 1.00 | 2.64 | 1.10 |
| literal: a word | 7 | 730.48 ± 6.5% | 783.00 ± 0.6% | 1382.63 ± 0.1% | 647.85 ± 1.0% | 778.16 ± 1.4% | 1642.81 ± 0.5% | 34753.29 ± 1.6% | 729.71 ± 5.7% | 0.93 | 1.00 | 1.13 | 0.94 |
| literal: a word that is not there | 8 | 702.55 ± 0.3% | 756.33 ± 0.4% | 1317.02 ± 0.2% | 584.54 ± 1.8% | 734.76 ± 18.8% | 1540.15 ± 0.5% | 34148.88 ± 0.1% | 702.60 ± 0.1% | 0.93 | 1.00 | 1.20 | 0.96 |
| literal: one of four words | 26 | 269.88 ± 0.2% | 451.00 ± 0.4% | 608.00 ± 0.4% | 53.31 ± 1.0% | 286.19 ± 2.2% | 568.78 ± 0.5% | 17942.18 ± 0.3% | 269.54 ± 0.8% | 0.60 | 1.00 | 5.06 | 0.94 |
| literal: a word in any case | 11 | 502.09 ± 0.9% | 529.33 ± 0.5% | 752.29 ± 0.6% | 18.94 ± 1.6% | 794.67 ± 9.0% | refused | 27814.94 ± 0.3% | 500.01 ± 0.7% | 0.95 | 1.00 | 26.51 | 0.63 |
| literal: an href attribute | 12 | 407.51 ± 0.4% | 421.29 ± 0.1% | 554.40 ± 0.2% | 49.56 ± 1.0% | 555.70 ± 16.5% | 1264.66 ± 1.2% | 24245.99 ± 0.3% | 407.93 ± 1.1% | 0.97 | 1.00 | 8.22 | 0.73 |
| literal: a word, second text | 10 | 657.32 ± 0.2% | 714.89 ± 0.5% | 1179.46 ± 0.2% | 537.90 ± 0.6% | 639.85 ± 2.7% | 1316.48 ± 0.8% | 32250.65 ± 0.9% | 657.25 ± 0.3% | 0.92 | 1.00 | 1.22 | 1.03 |
| class: two capitalized words | 23 | 513.21 ± 0.7% | 549.25 ± 1.1% | 794.70 ± 2.8% | 122.52 ± 0.8% | 588.68 ± 0.9% | 1261.68 ± 0.5% | 8121.64 ± 0.4% | 511.66 ± 6.0% | 0.93 | 1.00 | 4.19 | 0.87 |
| class: a word that ends in ing | 9 | 632.32 ± 0.2% | 721.39 ± 7.0% | 1239.84 ± 0.2% | 152.61 ± 11.7% | 845.63 ± 0.7% | 1888.93 ± 1.6% | 16688.11 ± 12.0% | 632.76 ± 2.7% | 0.88 | 1.00 | 4.14 | 0.75 |
| class: a word in capitals | 16 | 568.75 ± 1.1% | 616.79 ± 0.3% | 980.78 ± 0.1% | 158.07 ± 0.9% | 882.22 ± 9.2% | 1757.71 ± 3.0% | 10661.72 ± 0.3% | 569.52 ± 0.2% | 0.92 | 1.00 | 3.60 | 0.64 |
| class: a number | 6 | 714.37 ± 0.5% | 791.76 ± 0.2% | 1473.01 ± 0.2% | 47.48 ± 1.2% | 1595.63 ± 1.8% | 3061.96 ± 4.0% | 26033.45 ± 1.7% | 715.56 ± 0.1% | 0.90 | 1.00 | 15.05 | 0.45 |
| class: two capitalized words, second text | 23 | 514.08 ± 0.3% | 549.59 ± 1.5% | 796.75 ± 0.8% | 122.41 ± 0.5% | 593.52 ± 1.0% | 1244.97 ± 0.4% | 8109.37 ± 0.6% | 514.61 ± 0.2% | 0.94 | 1.00 | 4.20 | 0.87 |
| other: a word between two words | 13 | 627.54 ± 4.6% | 653.49 ± 8.8% | 1023.40 ± 0.2% | 158.62 ± 13.1% | 571.17 ± 2.1% | 1345.81 ± 1.5% | 15443.42 ± 1.2% | 628.92 ± 0.4% | 0.96 | 1.00 | 3.96 | 1.10 |
| other: a number before a unit, second text | 15 | 456.25 ± 0.3% | 508.08 ± 0.1% | 709.79 ± 5.7% | 44.51 ± 7.1% | 718.85 ± 8.3% | 1431.68 ± 2.7% | 17914.50 ± 0.4% | 456.62 ± 0.4% | 0.90 | 1.00 | 10.25 | 0.63 |
| other: a heading's start tag | 13 | 416.01 ± 0.6% | 424.42 ± 0.7% | 562.10 ± 0.3% | 47.70 ± 7.8% | 701.09 ± 0.7% | 1349.29 ± 1.5% | 20721.37 ± 2.1% | 416.53 ± 0.4% | 0.98 | 1.00 | 8.72 | 0.59 |
| other: a whole word | 11 | 648.47 ± 0.8% | 686.22 ± 0.4% | 1122.32 ± 0.4% | 142.73 ± 1.3% | 655.10 ± 10.6% | 1354.80 ± 15.0% | 31914.96 ± 4.4% | 647.25 ± 0.3% | 0.94 | 1.00 | 4.54 | 0.99 |
| other: a line's first word, second text | 17 | 598.98 ± 0.6% | 635.56 ± 0.1% | 999.21 ± 3.3% | 149.06 ± 0.5% | 793.33 ± 1.4% | refused | refused | 599.93 ± 11.6% | 0.94 | 1.00 | 4.02 | 0.76 |
| other: fourteen octets before an x | 16 | 116.43 ± 4.0% | 174.29 ± 0.2% | 204.49 ± 1.6% | 18.01 ± 9.5% | 519.23 ± 3.2% | 574.89 ± 0.6% | 15401.89 ± 2.2% | 116.31 ± 0.4% | 0.67 | 1.00 | 6.46 | 0.22 |
| other: a Greek word | 8 | 475.69 ± 0.4% | 675.25 ± 4.4% | 1123.13 ± 0.2% | 62.79 ± 0.4% | 1570.45 ± 19.3% | 2862.50 ± 0.9% | refused | 475.62 ± 4.1% | 0.70 | 1.00 | 7.58 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37355.76 ± 2.5% | not timed | not timed | 33669.34 ± 1.8% | 2821.93 ± 4.0% | not timed | not timed | 37430.14 ± 0.2% | | 1.00 | 1.11 | 13.24 |
| 01-literal/sherlock-casei-en | 522 | 29477.58 ± 7.2% | not timed | not timed | 9038.42 ± 0.4% | 33.88 ± 0.7% | not timed | not timed | 29493.98 ± 7.9% | | 1.00 | 3.26 | 870.00 |
| 01-literal/sherlock-ru | 724 | 39176.97 ± 0.6% | not timed | not timed | 34477.05 ± 0.3% | 1283.68 ± 6.5% | not timed | not timed | 39186.43 ± 0.2% | | 1.00 | 1.14 | 30.52 |
| 01-literal/sherlock-casei-ru | 746 | 12366.83 ± 0.7% | not timed | not timed | 7743.92 ± 0.9% | 36.90 ± 2.4% | not timed | not timed | 11675.49 ± 9.5% | | 1.06 | 1.60 | 335.12 |
| 01-literal/sherlock-zh | 30 | 60663.72 ± 0.4% | not timed | not timed | 42740.47 ± 13.4% | 1627.53 ± 1.7% | not timed | not timed | 60535.28 ± 1.8% | | 1.00 | 1.42 | 37.27 |
| 02-literal-alternate/sherlock-en | 714 | 15513.20 ± 0.3% | not timed | not timed | 10941.99 ± 0.2% | 19.12 ± 5.5% | not timed | not timed | 13330.21 ± 10.9% | | 1.16 | 1.42 | 811.21 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5001.50 ± 8.6% | not timed | not timed | 2309.42 ± 0.7% | 12.31 ± 7.1% | not timed | not timed | 4931.76 ± 4.4% | | 1.01 | 2.17 | 406.19 |
| 02-literal-alternate/sherlock-ru | 899 | 10797.88 ± 0.8% | not timed | not timed | 9806.51 ± 0.3% | 25.51 ± 0.6% | not timed | not timed | 10135.14 ± 0.4% | | 1.07 | 1.10 | 423.28 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2526.23 ± 1.7% | not timed | not timed | 1197.86 ± 0.5% | 10.56 ± 0.3% | not timed | not timed | 2505.55 ± 2.5% | | 1.01 | 2.11 | 239.20 |
| 02-literal-alternate/sherlock-zh | 207 | 20767.55 ± 0.2% | not timed | not timed | 12651.10 ± 0.7% | 34.36 ± 0.6% | not timed | not timed | 19418.02 ± 0.4% | | 1.07 | 1.64 | 604.43 |
| 03-date/ascii | 111817 | 147.56 ± 11.5% | not timed | not timed | 100.94 ± 0.2% | 0.23 ± 4.2% | not timed | not timed | 147.97 ± 2.1% | | 1.00 | 1.46 | 638.11 |
| 04-ruff-noqa/real | 84 | 512.42 ± 0.4% | not timed | not timed | 500.25 ± 0.7% | 20.69 ± 3.7% | not timed | not timed | 514.63 ± 0.5% | | 1.00 | 1.02 | 24.77 |
| 04-ruff-noqa/tweaked | 44 | 653.91 ± 0.2% | not timed | not timed | 510.09 ± 0.3% | 366.16 ± 1.8% | not timed | not timed | 654.85 ± 6.6% | | 1.00 | 1.28 | 1.79 |
| 05-lexer-veryl/single | 124800 | 4.68 ± 3.4% | not timed | not timed | 5.49 ± 0.4% | 0.26 ± 4.7% | not timed | not timed | 4.85 ± 12.9% | | 0.97 | 0.85 | 18.20 |
| 06-cloud-flare-redos/original | 107 | 431.32 ± 0.8% | not timed | not timed | 228.26 ± 0.4% | 25.53 ± 7.4% | not timed | not timed | 432.49 ± 1.4% | | 1.00 | 1.89 | 16.90 |
| 06-cloud-flare-redos/simplified-short | 102 | 422.02 ± 1.5% | not timed | not timed | 236.25 ± 0.8% | 27.53 ± 1.7% | not timed | not timed | 426.96 ± 0.4% | | 0.99 | 1.79 | 15.33 |
| 06-cloud-flare-redos/simplified-long | 10000 | 531.07 ± 0.2% | not timed | not timed | 259.66 ± 4.7% | 29.60 ± 27.0% | not timed | not timed | 529.89 ± 0.7% | | 1.00 | 2.05 | 17.94 |
| 07-unicode-character-data/parse-line | 558784 | 250.98 ± 16.1% | not timed | not timed | 200.50 ± 0.2% | 48.16 ± 5.0% | not timed | not timed | 251.24 ± 2.2% | | 1.00 | 1.25 | 5.21 |
| 08-words/all-english | 56691 | 134.95 ± 11.9% | not timed | not timed | 84.21 ± 0.4% | 13.49 ± 12.0% | not timed | not timed | 135.01 ± 0.7% | | 1.00 | 1.60 | 10.00 |
| 08-words/long-english | 839 | 618.84 ± 0.2% | not timed | not timed | 583.52 ± 0.3% | 35.26 ± 0.3% | not timed | not timed | 619.01 ± 0.1% | | 1.00 | 1.06 | 17.55 |
| 09-aws-keys/full | 0 | 522.34 ± 6.9% | not timed | not timed | 538.69 ± 0.6% | 67.33 ± 3.0% | not timed | not timed | 515.57 ± 0.1% | | 1.01 | 0.97 | 7.76 |
| 09-aws-keys/quick | 0 | 1150.83 ± 0.7% | not timed | not timed | 960.10 ± 1.4% | 400.62 ± 3.6% | not timed | not timed | 1116.41 ± 0.2% | | 1.03 | 1.20 | 2.87 |
| 10-bounded-repeat/letters-en | 1833 | 680.76 ± 3.7% | not timed | not timed | 555.06 ± 4.2% | 22.82 ± 0.4% | not timed | not timed | 679.31 ± 0.7% | | 1.00 | 1.23 | 29.83 |
| 10-bounded-repeat/letters-ru | 3475 | 525.35 ± 1.0% | not timed | not timed | 481.06 ± 0.2% | 25.29 ± 20.1% | not timed | not timed | 528.02 ± 1.2% | | 0.99 | 1.09 | 20.78 |
| 10-bounded-repeat/context | 53 | 90.36 ± 1.1% | not timed | not timed | 70.41 ± 7.6% | 22.51 ± 3.3% | not timed | not timed | 90.53 ± 2.1% | | 1.00 | 1.28 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 639.44 ± 9.9% | not timed | not timed | 603.99 ± 0.2% | 40.28 ± 4.6% | not timed | not timed | 637.23 ± 8.1% | | 1.00 | 1.06 | 15.87 |
| 11-unstructured-to-json/extract | 600 | 49.54 ± 1.0% | not timed | not timed | 80.23 ± 1.0% | 35.66 ± 20.4% | not timed | not timed | 51.67 ± 2.1% | | 0.96 | 0.62 | 1.39 |
| 12-dictionary/single | 1 | 514.56 ± 0.9% | not timed | not timed | 482.42 ± 0.1% | 0.40 ± 1.1% | not timed | not timed | 513.27 ± 0.9% | | 1.00 | 1.07 | 1287.93 |
| 14-quadratic/1x | 100 | 26.18 ± 0.7% | not timed | not timed | 12.18 ± 0.5% | 1.00 ± 2.5% | not timed | not timed | 26.16 ± 0.4% | | 1.00 | 2.15 | 26.29 |
| 14-quadratic/2x | 200 | 19.92 ± 0.9% | not timed | not timed | 6.10 ± 0.5% | 0.54 ± 19.3% | not timed | not timed | 19.88 ± 0.6% | | 1.00 | 3.27 | 36.88 |
| 14-quadratic/10x | 1000 | 6.86 ± 1.0% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 6.85 ± 0.8% | | 1.00 | 5.64 | 58.66 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.39 ± 0.4% | not timed | not timed | 0.48 ± 0.4% | 0.64 ± 8.8% | not timed | not timed | 1.39 ± 0.9% | | 1.00 | 2.91 | 2.18 |
| 04-ruff-noqa/compile-real | 1 | 120.46 ± 0.9% | not timed | not timed | 17.03 ± 1.0% | 169.41 ± 0.9% | not timed | not timed | 120.07 ± 0.4% | | 1.00 | 7.07 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 16.46 ± 1.4% | not timed | not timed | 2.99 ± 0.7% | 7.83 ± 2.2% | not timed | not timed | 16.46 ± 0.2% | | 1.00 | 5.51 | 2.10 |
| 07-unicode-character-data/compile | 1 | 125.82 ± 10.1% | not timed | not timed | 30.23 ± 0.6% | 44.60 ± 8.1% | not timed | not timed | 125.99 ± 0.2% | | 1.00 | 4.16 | 2.82 |
| 09-aws-keys/compile-full | 1 | 55.42 ± 7.4% | not timed | not timed | 9.95 ± 0.7% | 27.93 ± 4.3% | not timed | not timed | 55.52 ± 0.3% | | 1.00 | 5.57 | 1.98 |
| 09-aws-keys/compile-quick | 1 | 196.75 ± 0.7% | not timed | not timed | 57.80 ± 1.7% | 157.40 ± 5.2% | not timed | not timed | 196.44 ± 7.6% | | 1.00 | 3.40 | 1.25 |
| 10-bounded-repeat/compile-context | 1 | 59.94 ± 1.3% | not timed | not timed | 14.07 ± 11.3% | 20.32 ± 1.6% | not timed | not timed | 60.05 ± 0.3% | | 1.00 | 4.26 | 2.95 |
| 10-bounded-repeat/compile-capitals | 1 | 94.31 ± 11.8% | not timed | not timed | 10.27 ± 1.2% | 29.55 ± 0.4% | not timed | not timed | 93.74 ± 22.9% | | 1.01 | 9.18 | 3.19 |
| 11-unstructured-to-json/compile | 1 | 192.42 ± 0.2% | not timed | not timed | 47.52 ± 0.4% | 80.52 ± 2.3% | not timed | not timed | 191.47 ± 0.6% | | 1.01 | 4.05 | 2.39 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.2% | not timed | not timed | 0.09 ± 0.3% | 0.10 ± 17.9% | not timed | not timed | 0.35 ± 0.5% | | 1.00 | 4.06 | 3.34 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.14 ± 2.1% | not timed | not timed | 6.84 ± 0.8% | 0.67 ± 12.2% | not timed | not timed | 7.29 ± 1.6% | | 0.98 | 1.04 | 10.66 |
| dictionary/search/english-10 | 690 | 1.31 ± 0.3% | not timed | not timed | 153.89 ± 2.3% | 0.01 ± 0.4% | not timed | not timed | 1.31 ± 1.1% | | 1.00 | 0.0085 | 189.62 |
| dictionary/search/english-15 | 15 | 514.19 ± 0.8% | not timed | not timed | 480.65 ± 0.2% | 0.36 ± 1.0% | not timed | not timed | 513.31 ± 0.7% | | 1.00 | 1.07 | 1447.95 |
| folly/awyer-inn-busted | 1 | 4245.01 ± 0.4% | not timed | not timed | 129.95 ± 0.9% | 48.22 ± 0.2% | not timed | not timed | 4249.59 ± 0.1% | | 1.00 | 32.67 | 88.04 |
| folly/literal-never-match-rare | 0 | 67527.66 ± 1.0% | not timed | not timed | 46469.56 ± 1.7% | 69228.32 ± 0.3% | not timed | not timed | 67778.64 ± 0.2% | | 1.00 | 1.45 | 0.98 |
| folly/literal-never-match-frequent | 0 | 26632.05 ± 5.9% | not timed | not timed | 46092.55 ± 2.5% | 2587.99 ± 5.5% | not timed | not timed | 26961.07 ± 5.7% | | 0.99 | 0.58 | 10.29 |
| folly/literal-never-match-tricksy | 1 | 3979.94 ± 16.3% | not timed | not timed | 6147.85 ± 0.3% | 1722.74 ± 0.2% | not timed | not timed | 3983.17 ± 5.5% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1470.00 ± 1.6% | not timed | not timed | 970.46 ± 0.9% | 372.16 ± 26.9% | not timed | not timed | 1478.97 ± 0.6% | | 0.99 | 1.51 | 3.95 |
| grep/long-words-ascii | 5073 | 504.48 ± 0.5% | not timed | not timed | 497.58 ± 0.3% | 51.21 ± 8.9% | not timed | not timed | 503.67 ± 0.3% | | 1.00 | 1.01 | 9.85 |
| imported/leipzig/twain | 811 | 58389.75 ± 1.0% | not timed | not timed | 43667.58 ± 14.8% | 13204.39 ± 10.5% | not timed | not timed | 58417.70 ± 0.8% | | 1.00 | 1.34 | 4.42 |
| imported/leipzig/twain-insensitive | 965 | 15522.82 ± 0.3% | not timed | not timed | 13489.91 ± 1.9% | 44.22 ± 1.0% | not timed | not timed | 15513.55 ± 0.5% | | 1.00 | 1.15 | 351.04 |
| imported/leipzig/shing | 1540 | 30385.98 ± 0.5% | not timed | not timed | 22336.81 ± 0.4% | 38.06 ± 0.6% | not timed | not timed | 30537.28 ± 2.0% | | 1.00 | 1.36 | 798.29 |
| imported/leipzig/huck-saw | 262 | 25048.80 ± 0.4% | not timed | not timed | 18724.58 ± 0.3% | 35.39 ± 0.4% | not timed | not timed | 24915.92 ± 0.7% | | 1.01 | 1.34 | 707.85 |
| imported/leipzig/word-ending-nn | 262 | 609.54 ± 0.2% | not timed | not timed | 603.06 ± 2.2% | 27.46 ± 1.0% | not timed | not timed | 609.76 ± 1.3% | | 1.00 | 1.01 | 22.19 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11938.76 ± 1.0% | not timed | not timed | 3971.07 ± 0.4% | 12.15 ± 1.5% | not timed | not timed | 11959.76 ± 0.7% | | 1.00 | 3.01 | 982.47 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 22081.30 ± 3.2% | not timed | not timed | 17599.97 ± 0.4% | 19.23 ± 0.2% | not timed | not timed | 21274.43 ± 2.0% | | 1.04 | 1.25 | 1148.14 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5575.31 ± 4.8% | not timed | not timed | 791.78 ± 1.1% | 12.06 ± 2.5% | not timed | not timed | 5495.08 ± 4.7% | | 1.01 | 7.04 | 462.25 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 607.76 ± 0.1% | not timed | not timed | 602.83 ± 0.4% | 12.09 ± 1.8% | not timed | not timed | 608.10 ± 0.2% | | 1.00 | 1.01 | 50.28 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.06 ± 0.1% | not timed | not timed | 602.47 ± 0.1% | 10.53 ± 1.3% | not timed | not timed | 608.07 ± 0.4% | | 1.00 | 1.01 | 57.76 |
| imported/leipzig/tom-river | 2 | 12934.99 ± 9.0% | not timed | not timed | 13387.75 ± 0.6% | 34.22 ± 2.4% | not timed | not timed | 12942.05 ± 5.9% | | 1.00 | 0.97 | 377.97 |
| imported/leipzig/ing | 78424 | 599.19 ± 0.9% | not timed | not timed | 559.08 ± 0.3% | 29.64 ± 3.7% | not timed | not timed | 599.44 ± 0.8% | | 1.00 | 1.07 | 20.21 |
| imported/leipzig/ing-whitespace | 55248 | 732.73 ± 0.7% | not timed | not timed | 2149.80 ± 0.2% | 22.62 ± 2.5% | not timed | not timed | 742.65 ± 1.8% | | 0.99 | 0.34 | 32.39 |
| imported/leipzig/awyer-inn | 209 | 771.12 ± 1.1% | not timed | not timed | 13747.65 ± 1.3% | 24.44 ± 1.4% | not timed | not timed | 770.80 ± 1.4% | | 1.00 | 0.0561 | 31.55 |
| imported/leipzig/quotes-bounded | 8886 | 1846.98 ± 0.5% | not timed | not timed | 3276.75 ± 5.2% | 40.68 ± 4.3% | not timed | not timed | 1845.23 ± 0.2% | | 1.00 | 0.56 | 45.40 |
| imported/leipzig/non-ascii-alternate | 2 | 40528.33 ± 1.0% | not timed | not timed | 19568.64 ± 0.6% | 56.08 ± 6.5% | not timed | not timed | 40717.48 ± 0.5% | | 1.00 | 2.07 | 722.63 |
| imported/leipzig/math-symbols | 69 | 2430.56 ± 0.4% | not timed | not timed | 603.11 ± 0.3% | 39.39 ± 0.4% | not timed | not timed | 2430.17 ± 0.5% | | 1.00 | 4.03 | 61.70 |
| imported/leipzig/bounded-strings-ending-z | 0 | 610.25 ± 1.1% | not timed | not timed | 604.65 ± 0.2% | 25.44 ± 2.4% | not timed | not timed | 610.13 ± 0.2% | | 1.00 | 1.01 | 23.99 |
| imported/lh3lh3-reb/uri | 17549 | 812.89 ± 0.2% | not timed | not timed | 1132.53 ± 1.0% | 24.44 ± 2.3% | not timed | not timed | 816.57 ± 0.2% | | 1.00 | 0.72 | 33.27 |
| imported/lh3lh3-reb/email | 15057 | 809.93 ± 0.3% | not timed | not timed | 1130.06 ± 1.2% | 25.24 ± 2.4% | not timed | not timed | 809.92 ± 0.5% | | 1.00 | 0.72 | 32.09 |
| imported/lh3lh3-reb/date | 668 | 933.39 ± 0.3% | not timed | not timed | 1012.95 ± 4.4% | 52.62 ± 4.2% | not timed | not timed | 935.00 ± 0.8% | | 1.00 | 0.92 | 17.74 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 750.65 ± 0.5% | not timed | not timed | 443.38 ± 0.3% | 12.80 ± 2.0% | not timed | not timed | 750.53 ± 0.8% | | 1.00 | 1.69 | 58.66 |
| imported/mariomka/email | 92 | 42912.52 ± 0.9% | not timed | not timed | 59750.07 ± 0.5% | 35.32 ± 6.8% | not timed | not timed | 42892.67 ± 0.7% | | 1.00 | 0.72 | 1214.95 |
| imported/mariomka/uri | 5301 | 6665.02 ± 1.4% | not timed | not timed | 7956.79 ± 1.1% | 35.07 ± 0.7% | not timed | not timed | 6655.82 ± 0.9% | | 1.00 | 0.84 | 190.07 |
| imported/mariomka/ip | 5 | 1818.31 ± 3.6% | not timed | not timed | 2184.74 ± 0.2% | 22.77 ± 0.9% | not timed | not timed | 1824.44 ± 4.0% | | 1.00 | 0.83 | 79.87 |
| imported/rsc/no-exponential | 0 | 898.03 ± 0.4% | not timed | not timed | 424.05 ± 0.2% | 23.94 ± 2.1% | not timed | not timed | 895.42 ± 1.0% | | 1.00 | 2.12 | 37.51 |
| imported/rsc/literal | 1 | 829.06 ± 14.4% | not timed | not timed | 2231.52 ± 0.4% | 234.43 ± 22.9% | not timed | not timed | 883.67 ± 11.9% | | 0.94 | 0.37 | 3.54 |
| imported/rsc/not-literal | 2 | 966.70 ± 0.8% | not timed | not timed | 845.43 ± 0.5% | 46.28 ± 90.5% | not timed | not timed | 966.38 ± 8.8% | | 1.00 | 1.14 | 20.89 |
| imported/rsc/match-class | 1 | 1675.21 ± 2.7% | not timed | not timed | 1749.70 ± 0.8% | 67.53 ± 7.9% | not timed | not timed | 1673.26 ± 2.1% | | 1.00 | 0.96 | 24.81 |
| imported/rsc/match-class-in-range | 1 | 1680.91 ± 0.8% | not timed | not timed | 3437.71 ± 0.5% | 69.62 ± 1.6% | not timed | not timed | 1677.06 ± 0.4% | | 1.00 | 0.49 | 24.14 |
| imported/rsc/match-class-unicode | 1 | 570.89 ± 3.3% | not timed | not timed | 522.31 ± 0.5% | 82.58 ± 7.0% | not timed | not timed | 571.13 ± 1.7% | | 1.00 | 1.09 | 6.91 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1694.44 ± 1.4% | not timed | not timed | 1153.33 ± 0.5% | 313.45 ± 0.8% | not timed | not timed | 1700.12 ± 1.4% | | 1.00 | 1.47 | 5.41 |
| imported/rsc/anchored-literal-long-non-match | 0 | 25499.36 ± 0.2% | not timed | not timed | 17144.09 ± 27.8% | 4642.24 ± 1.8% | not timed | not timed | 25465.49 ± 22.7% | | 1.00 | 1.49 | 5.49 |
| imported/rsc/anchored-literal-short-match | 4 | 876.18 ± 7.5% | not timed | not timed | 569.17 ± 0.8% | 106.68 ± 5.5% | not timed | not timed | 887.77 ± 2.1% | | 0.99 | 1.54 | 8.21 |
| imported/rsc/anchored-literal-long-match | 4 | 13053.71 ± 2.6% | not timed | not timed | 8541.61 ± 1.3% | 1610.02 ± 1.7% | not timed | not timed | 13339.50 ± 2.3% | | 0.98 | 1.53 | 8.11 |
| imported/rsc/one-pass-short | 17 | 493.14 ± 7.9% | not timed | not timed | 259.84 ± 1.3% | 37.92 ± 15.2% | not timed | not timed | 499.08 ± 0.3% | | 0.99 | 1.90 | 13.01 |
| imported/rsc/one-pass-short-not | 17 | 325.54 ± 10.9% | not timed | not timed | 271.94 ± 4.8% | 33.86 ± 9.4% | not timed | not timed | 325.89 ± 8.8% | | 1.00 | 1.20 | 9.62 |
| imported/rsc/one-pass-long-prefix | 26 | 444.84 ± 2.9% | not timed | not timed | 319.46 ± 0.6% | 123.86 ± 8.7% | not timed | not timed | 450.14 ± 1.8% | | 0.99 | 1.39 | 3.59 |
| imported/rsc/one-pass-long-prefix-not | 26 | 446.12 ± 2.4% | not timed | not timed | 287.71 ± 6.8% | 83.55 ± 9.8% | not timed | not timed | 451.99 ± 2.5% | | 0.99 | 1.55 | 5.34 |
| imported/rsc/long-needle1 | 31 | 68152.27 ± 0.2% | not timed | not timed | 45843.16 ± 0.6% | 4.20 ± 1.1% | not timed | not timed | 68156.96 ± 0.5% | | 1.00 | 1.49 | 16245.92 |
| imported/rsc/long-needle2 | 31 | 67729.35 ± 1.2% | not timed | not timed | 227.11 ± 0.9% | 4.20 ± 1.0% | not timed | not timed | 67638.37 ± 9.8% | | 1.00 | 298.22 | 16118.95 |
| imported/rsc/easy0-32 | 26 | 1267.78 ± 1.3% | not timed | not timed | 1935.73 ± 2.0% | 142.60 ± 54.4% | not timed | not timed | 1269.02 ± 1.2% | | 1.00 | 0.65 | 8.89 |
| imported/rsc/easy0-1k | 26 | 21502.38 ± 2.5% | not timed | not timed | 20259.74 ± 6.0% | 2260.93 ± 28.0% | not timed | not timed | 21468.70 ± 6.1% | | 1.00 | 1.06 | 9.51 |
| imported/rsc/easy0-32k | 26 | 64510.62 ± 1.2% | not timed | not timed | 43749.19 ± 0.3% | 26057.31 ± 26.8% | not timed | not timed | 64543.06 ± 1.8% | | 1.00 | 1.47 | 2.48 |
| imported/rsc/easy0-1mb | 26 | 64917.68 ± 0.6% | not timed | not timed | 46004.34 ± 0.4% | 67794.44 ± 6.9% | not timed | not timed | 64843.87 ± 0.5% | | 1.00 | 1.41 | 0.96 |
| imported/rsc/easy1-32 | 19 | 926.59 ± 2.6% | not timed | not timed | 758.67 ± 0.6% | 145.41 ± 32.5% | not timed | not timed | 923.70 ± 8.5% | | 1.00 | 1.22 | 6.37 |
| imported/rsc/easy1-1k | 19 | 18994.06 ± 0.7% | not timed | not timed | 15750.80 ± 0.6% | 2486.73 ± 21.5% | not timed | not timed | 18844.79 ± 3.3% | | 1.01 | 1.21 | 7.64 |
| imported/rsc/easy1-32k | 19 | 595793.04 ± 2.0% | not timed | not timed | 471492.75 ± 1.7% | 29164.35 ± 16.7% | not timed | not timed | 596066.68 ± 0.8% | | 1.00 | 1.26 | 20.43 |
| imported/rsc/easy1-1mb | 19 | 19003929.65 ± 0.6% | not timed | not timed | 15731794.10 ± 1.2% | 68039.37 ± 0.6% | not timed | not timed | 19002357.13 ± 1.0% | | 1.00 | 1.21 | 279.31 |
| imported/rsc/medium-32 | 27 | 870.61 ± 0.8% | not timed | not timed | 741.53 ± 0.6% | 75.93 ± 22.3% | not timed | not timed | 865.75 ± 2.5% | | 1.01 | 1.17 | 11.47 |
| imported/rsc/medium-1k | 27 | 15485.18 ± 0.6% | not timed | not timed | 13227.51 ± 0.4% | 82.53 ± 2.4% | not timed | not timed | 15488.05 ± 0.7% | | 1.00 | 1.17 | 187.64 |
| imported/rsc/medium-32k | 27 | 484418.70 ± 0.4% | not timed | not timed | 412065.96 ± 0.8% | 54.87 ± 1.0% | not timed | not timed | 483813.39 ± 1.0% | | 1.00 | 1.18 | 8828.63 |
| imported/rsc/medium-1mb | 27 | 15459994.00 ± 0.4% | not timed | not timed | 13155077.13 ± 0.5% | 54.90 ± 1.9% | not timed | not timed | 15444472.12 ± 1.2% | | 1.00 | 1.18 | 281591.04 |
| imported/rsc/hard-32 | 58 | 440.91 ± 1.8% | not timed | not timed | 390.84 ± 1.1% | 51.28 ± 13.2% | not timed | not timed | 436.66 ± 0.4% | | 1.01 | 1.13 | 8.60 |
| imported/rsc/hard-1k | 27 | 14803.26 ± 10.1% | not timed | not timed | 13044.63 ± 1.2% | 44.54 ± 0.8% | not timed | not timed | 14827.81 ± 0.5% | | 1.00 | 1.13 | 332.39 |
| imported/rsc/hard-32k | 27 | 462830.66 ± 0.3% | not timed | not timed | 403699.67 ± 0.2% | 32.89 ± 0.8% | not timed | not timed | 462695.94 ± 1.2% | | 1.00 | 1.15 | 14072.14 |
| imported/rsc/hard-1mb | 51 | 8839394.96 ± 0.3% | not timed | not timed | 7815184.58 ± 0.5% | 33.09 ± 2.0% | not timed | not timed | 8715302.55 ± 1.7% | | 1.01 | 1.13 | 267136.19 |
| imported/rsc/reallyhard0-32 | 58 | 282.34 ± 2.7% | not timed | not timed | 241.02 ± 0.9% | 49.14 ± 8.1% | not timed | not timed | 282.44 ± 7.7% | | 1.00 | 1.17 | 5.75 |
| imported/rsc/reallyhard0-1k | 27 | 591.32 ± 0.3% | not timed | not timed | 580.25 ± 0.3% | 44.79 ± 1.2% | not timed | not timed | 591.10 ± 0.2% | | 1.00 | 1.02 | 13.20 |
| imported/rsc/reallyhard0-32k | 27 | 607.79 ± 0.1% | not timed | not timed | 602.73 ± 0.4% | 32.80 ± 0.3% | not timed | not timed | 607.41 ± 1.1% | | 1.00 | 1.01 | 18.53 |
| imported/rsc/reallyhard0-1mb | 51 | 609.42 ± 0.3% | not timed | not timed | 604.68 ± 0.3% | 33.09 ± 0.2% | not timed | not timed | 608.16 ± 12.7% | | 1.00 | 1.01 | 18.42 |
| imported/rsc/reallyreallyhard0-32 | 47 | 336.16 ± 1.7% | not timed | not timed | 207.81 ± 0.2% | 63.89 ± 4.7% | not timed | not timed | 331.67 ± 6.6% | | 1.01 | 1.62 | 5.26 |
| imported/rsc/reallyreallyhard0-1k | 16 | 8185.17 ± 0.5% | not timed | not timed | 7740.75 ± 0.3% | 36.76 ± 0.6% | not timed | not timed | 8188.60 ± 0.7% | | 1.00 | 1.06 | 222.64 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52483.27 ± 0.3% | not timed | not timed | 36836.26 ± 1.3% | 26.45 ± 0.5% | not timed | not timed | 52751.75 ± 0.2% | | 0.99 | 1.42 | 1984.47 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 73533.22 ± 0.4% | not timed | not timed | 45546.36 ± 0.5% | 26.84 ± 0.2% | not timed | not timed | 73433.05 ± 1.0% | | 1.00 | 1.61 | 2739.84 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 324.73 ± 2.1% | not timed | not timed | 216.92 ± 0.4% | 63.45 ± 10.8% | not timed | not timed | 324.50 ± 1.1% | | 1.00 | 1.50 | 5.12 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6285.17 ± 1.0% | not timed | not timed | 7530.13 ± 0.4% | 36.62 ± 1.4% | not timed | not timed | 6277.68 ± 0.4% | | 1.00 | 0.83 | 171.64 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 47450.10 ± 0.2% | not timed | not timed | 36617.45 ± 0.4% | 26.49 ± 1.2% | not timed | not timed | 45955.98 ± 0.6% | | 1.03 | 1.30 | 1791.46 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 63319.01 ± 0.3% | not timed | not timed | 45272.04 ± 0.2% | 26.82 ± 0.8% | not timed | not timed | 63668.33 ± 0.4% | | 0.99 | 1.40 | 2360.48 |
| imported/sherlock/name-sherlock | 776 | 50647.44 ± 1.6% | not timed | not timed | 40200.47 ± 1.7% | 12771.73 ± 4.3% | not timed | not timed | 50875.10 ± 0.9% | | 1.00 | 1.26 | 3.97 |
| imported/sherlock/name-holmes | 2766 | 27848.51 ± 1.1% | not timed | not timed | 30087.82 ± 1.6% | 3968.91 ± 7.9% | not timed | not timed | 28119.28 ± 1.0% | | 0.99 | 0.93 | 7.02 |
| imported/sherlock/name-sherlock-holmes | 1365 | 51583.53 ± 1.6% | not timed | not timed | 40343.61 ± 0.9% | 10705.03 ± 20.7% | not timed | not timed | 51405.94 ± 0.8% | | 1.00 | 1.28 | 4.82 |
| imported/sherlock/name-sherlock-casei | 816 | 46550.85 ± 1.0% | not timed | not timed | 11598.54 ± 0.4% | 33.73 ± 1.2% | not timed | not timed | 46610.80 ± 0.3% | | 1.00 | 4.01 | 1379.99 |
| imported/sherlock/name-holmes-casei | 2802 | 22638.78 ± 2.0% | not timed | not timed | 7598.11 ± 0.4% | 44.62 ± 0.4% | not timed | not timed | 22603.86 ± 2.6% | | 1.00 | 2.98 | 507.33 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36621.09 ± 1.3% | not timed | not timed | 11018.53 ± 0.3% | 33.70 ± 1.8% | not timed | not timed | 36437.76 ± 5.2% | | 1.01 | 3.32 | 1086.55 |
| imported/sherlock/name-whitespace | 1461 | 29808.01 ± 0.9% | not timed | not timed | 28017.16 ± 31.2% | 8347.07 ± 24.3% | not timed | not timed | 30219.79 ± 10.1% | | 0.99 | 1.06 | 3.57 |
| imported/sherlock/name-alt1 | 1142 | 31194.88 ± 1.3% | not timed | not timed | 29965.71 ± 0.4% | 5627.89 ± 24.4% | not timed | not timed | 29352.79 ± 0.6% | | 1.06 | 1.04 | 5.54 |
| imported/sherlock/name-alt2 | 3542 | 21053.96 ± 0.2% | not timed | not timed | 10019.63 ± 0.5% | 35.46 ± 1.5% | not timed | not timed | 18200.21 ± 0.5% | | 1.16 | 2.10 | 593.66 |
| imported/sherlock/name-alt3 | 4507 | 13538.40 ± 0.5% | not timed | not timed | 9154.55 ± 0.3% | 11.26 ± 0.8% | not timed | not timed | 11234.87 ± 0.9% | | 1.21 | 1.48 | 1202.18 |
| imported/sherlock/name-alt3-casei | 4593 | 3533.46 ± 3.4% | not timed | not timed | 1309.31 ± 0.3% | 7.38 ± 1.5% | not timed | not timed | 3452.43 ± 2.5% | | 1.02 | 2.70 | 478.59 |
| imported/sherlock/name-alt4 | 3686 | 9945.54 ± 0.2% | not timed | not timed | 8145.92 ± 1.1% | 35.98 ± 0.9% | not timed | not timed | 9125.94 ± 0.8% | | 1.09 | 1.22 | 276.43 |
| imported/sherlock/name-alt4-casei | 4254 | 5433.85 ± 2.3% | not timed | not timed | 4451.85 ± 0.7% | 20.68 ± 1.0% | not timed | not timed | 5256.03 ± 1.6% | | 1.03 | 1.22 | 262.77 |
| imported/sherlock/name-alt5 | 4028 | 17176.44 ± 1.3% | not timed | not timed | 9627.24 ± 0.4% | 24.77 ± 0.4% | not timed | not timed | 15108.22 ± 1.6% | | 1.14 | 1.78 | 693.36 |
| imported/sherlock/name-alt5-casei | 4104 | 6983.65 ± 2.6% | not timed | not timed | 3003.15 ± 1.6% | 15.40 ± 3.3% | not timed | not timed | 6616.93 ± 5.7% | | 1.06 | 2.33 | 453.44 |
| imported/sherlock/no-match-uncommon | 0 | 68408.38 ± 0.3% | not timed | not timed | 57989.53 ± 0.4% | 57947.76 ± 1.8% | not timed | not timed | 68435.37 ± 0.3% | | 1.00 | 1.18 | 1.18 |
| imported/sherlock/no-match-common | 0 | 66768.41 ± 0.4% | not timed | not timed | 57983.77 ± 0.5% | 2157.10 ± 1.1% | not timed | not timed | 66883.95 ± 0.5% | | 1.00 | 1.15 | 30.95 |
| imported/sherlock/no-match-really-common | 0 | 42995.88 ± 0.4% | not timed | not timed | 49780.76 ± 0.1% | 2136.88 ± 1.3% | not timed | not timed | 42918.11 ± 0.5% | | 1.00 | 0.86 | 20.12 |
| imported/sherlock/the-lower | 21654 | 4005.18 ± 1.1% | not timed | not timed | 4533.67 ± 3.9% | 274.62 ± 14.7% | not timed | not timed | 4004.06 ± 2.1% | | 1.00 | 0.88 | 14.58 |
| imported/sherlock/the-upper | 2223 | 20907.80 ± 1.5% | not timed | not timed | 29345.17 ± 15.7% | 3060.20 ± 13.1% | not timed | not timed | 20921.61 ± 1.3% | | 1.00 | 0.71 | 6.83 |
| imported/sherlock/the-casei | 23961 | 3494.39 ± 0.9% | not timed | not timed | 1343.71 ± 0.7% | 41.28 ± 11.3% | not timed | not timed | 3497.57 ± 0.7% | | 1.00 | 2.60 | 84.66 |
| imported/sherlock/everything-greedy | 581881 | 295.67 ± 3.8% | not timed | not timed | 173.29 ± 0.4% | 30.86 ± 28.2% | not timed | not timed | 295.94 ± 0.1% | | 1.00 | 1.71 | 9.58 |
| imported/sherlock/everything-greedy-nl | 594933 | 464.42 ± 1.1% | not timed | not timed | 223.21 ± 0.5% | 34.64 ± 0.2% | not timed | not timed | 464.44 ± 0.1% | | 1.00 | 2.08 | 13.41 |
| imported/sherlock/letters | 447175 | 67.46 ± 12.3% | not timed | not timed | 33.39 ± 0.4% | 6.79 ± 44.3% | not timed | not timed | 67.38 ± 9.1% | | 1.00 | 2.02 | 9.94 |
| imported/sherlock/letters-upper | 14180 | 453.52 ± 1.3% | not timed | not timed | 365.50 ± 0.7% | 31.28 ± 24.1% | not timed | not timed | 453.01 ± 0.5% | | 1.00 | 1.24 | 14.50 |
| imported/sherlock/letters-lower | 432995 | 68.49 ± 1.4% | not timed | not timed | 34.83 ± 0.4% | 6.81 ± 40.9% | not timed | not timed | 68.35 ± 0.7% | | 1.00 | 1.97 | 10.06 |
| imported/sherlock/words | 447639 | 124.86 ± 4.8% | not timed | not timed | 84.05 ± 0.3% | 15.08 ± 10.8% | not timed | not timed | 124.88 ± 4.6% | | 1.00 | 1.49 | 8.28 |
| imported/sherlock/before-holmes | 4073 | 15225.13 ± 0.9% | not timed | not timed | 13264.07 ± 0.4% | 25.84 ± 0.3% | not timed | not timed | 15288.36 ± 0.7% | | 1.00 | 1.15 | 589.22 |
| imported/sherlock/before-after-holmes | 2593 | 14996.53 ± 0.4% | not timed | not timed | 14959.17 ± 0.9% | 25.84 ± 1.1% | not timed | not timed | 14991.55 ± 0.3% | | 1.00 | 1.00 | 580.27 |
| imported/sherlock/holmes-cochar-watson | 150 | 10022.38 ± 1.2% | not timed | not timed | 7653.46 ± 0.2% | 35.44 ± 1.2% | not timed | not timed | 10063.72 ± 0.3% | | 1.00 | 1.31 | 282.79 |
| imported/sherlock/holmes-coword-watson | 14309 | 1269.33 ± 0.8% | not timed | not timed | 1232.70 ± 0.2% | 7.62 ± 1.1% | not timed | not timed | 1273.06 ± 0.4% | | 1.00 | 1.03 | 166.61 |
| imported/sherlock/quotes | 14437 | 1362.24 ± 1.0% | not timed | not timed | 2239.13 ± 1.2% | 37.67 ± 0.3% | not timed | not timed | 1361.47 ± 0.6% | | 1.00 | 0.61 | 36.16 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 606.43 ± 0.3% | not timed | not timed | 31190.55 ± 0.9% | 40.33 ± 0.3% | not timed | not timed | 606.02 ± 0.4% | | 1.00 | 0.0194 | 15.04 |
| imported/sherlock/word-ending-n | 35297 | 478.48 ± 0.2% | not timed | not timed | 401.64 ± 0.4% | 26.10 ± 0.5% | not timed | not timed | 478.36 ± 0.3% | | 1.00 | 1.19 | 18.34 |
| imported/sherlock/repeated-class-negation | 2130 | 19066.13 ± 0.3% | not timed | not timed | 16517.35 ± 0.2% | 12.43 ± 1.2% | not timed | not timed | 19068.04 ± 0.4% | | 1.00 | 1.15 | 1534.26 |
| imported/sherlock/ing-suffix | 20547 | 574.53 ± 0.3% | not timed | not timed | 511.02 ± 0.3% | 30.78 ± 0.4% | not timed | not timed | 572.62 ± 0.7% | | 1.00 | 1.12 | 18.67 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 605.50 ± 0.9% | not timed | not timed | 2920.82 ± 1.4% | 22.71 ± 2.2% | not timed | not timed | 606.88 ± 0.4% | | 1.00 | 0.21 | 26.67 |
| opt/accelerate/whole-line | 239963 | 504.99 ± 0.2% | not timed | not timed | 412.00 ± 0.3% | 91.84 ± 18.3% | not timed | not timed | 502.85 ± 0.5% | | 1.00 | 1.23 | 5.50 |
| opt/accelerate/non-dna | 16745 | 452.52 ± 1.5% | not timed | not timed | 438.87 ± 0.2% | 33.33 ± 15.4% | not timed | not timed | 453.01 ± 0.6% | | 1.00 | 1.03 | 13.58 |
| opt/backtrack/words-english | 40536 | 134.43 ± 7.4% | not timed | not timed | 109.91 ± 0.3% | 21.58 ± 9.0% | not timed | not timed | 136.30 ± 4.1% | | 0.99 | 1.22 | 6.23 |
| opt/fixed-length/too-small-ascii | 0 | 391.26 ± 1.4% | not timed | not timed | 708.76 ± 1.3% | 105.51 ± 1.1% | not timed | not timed | 391.24 ± 0.4% | | 1.00 | 0.55 | 3.71 |
| opt/fixed-length/too-big-ascii | 0 | 4291.65 ± 1.0% | not timed | not timed | 6314.60 ± 22.0% | 147.98 ± 0.5% | not timed | not timed | 4303.79 ± 10.6% | | 1.00 | 0.68 | 29.00 |
| opt/fixed-length/go33484-1 | 0 | 826414.68 ± 0.8% | not timed | not timed | 1214419.98 ± 0.1% | 83790.86 ± 1.1% | not timed | not timed | 827187.56 ± 1.8% | | 1.00 | 0.68 | 9.86 |
| opt/fixed-length/go33484-2 | 0 | 826076.10 ± 3.1% | not timed | not timed | 1216598.79 ± 0.2% | 24744.55 ± 18.4% | not timed | not timed | 827367.64 ± 1.5% | | 1.00 | 0.68 | 33.38 |
| opt/fixed-length/go33484-3 | 0 | 2453.44 ± 0.5% | not timed | not timed | 121418.41 ± 2.3% | 932.94 ± 1.1% | not timed | not timed | 2461.99 ± 0.5% | | 1.00 | 0.0202 | 2.63 |
| opt/literal-alt/one-pattern | 1 | 579.92 ± 1.3% | not timed | not timed | 568.03 ± 0.9% | 0.38 ± 2.2% | not timed | not timed | 570.48 ± 1.2% | | 1.02 | 1.02 | 1532.15 |
| opt/onepass/fn-predicate | 916 | 435.75 ± 0.9% | not timed | not timed | 394.68 ± 0.8% | 211.39 ± 14.7% | not timed | not timed | 438.21 ± 0.7% | | 0.99 | 1.10 | 2.06 |
| opt/onepass/first-three-words-english | 35128 | 174.95 ± 2.4% | not timed | not timed | 232.46 ± 0.5% | 82.32 ± 21.1% | not timed | not timed | 177.26 ± 1.8% | | 0.99 | 0.75 | 2.13 |
| opt/prefilter/literal-english | 1 | 68213.47 ± 0.2% | not timed | not timed | 46399.06 ± 0.5% | 26895.99 ± 0.7% | not timed | not timed | 68115.61 ± 0.8% | | 1.00 | 1.47 | 2.54 |
| opt/prefilter/literal-casei-english | 1 | 47362.89 ± 0.3% | not timed | not timed | 14247.41 ± 0.5% | 34.15 ± 2.4% | not timed | not timed | 47380.91 ± 1.1% | | 1.00 | 3.32 | 1386.72 |
| opt/prefilter/literal-russian | 1 | 68800.57 ± 1.0% | not timed | not timed | 46423.84 ± 0.3% | 1805.30 ± 0.1% | not timed | not timed | 68936.96 ± 0.5% | | 1.00 | 1.48 | 38.11 |
| opt/prefilter/literal-casei-russian | 1 | 26178.79 ± 0.3% | not timed | not timed | 11011.89 ± 0.5% | 37.76 ± 0.8% | not timed | not timed | 26153.10 ± 1.1% | | 1.00 | 2.38 | 693.36 |
| opt/prefilter/rust-functions | 948 | 14279.26 ± 1.1% | not timed | not timed | 12872.43 ± 1.2% | 1927.03 ± 26.4% | not timed | not timed | 14549.07 ± 3.7% | | 0.98 | 1.11 | 7.41 |
| opt/reverse-anchored/word-end | 1 | 33718307.04 ± 0.9% | not timed | not timed | 27232556.63 ± 1.5% | 56.22 ± 0.8% | not timed | not timed | 35480470.87 ± 0.3% | | 0.95 | 1.24 | 599704.53 |
| opt/reverse-inner/holmes | 2593 | 14998.07 ± 0.4% | not timed | not timed | 14979.83 ± 0.3% | 25.60 ± 0.5% | not timed | not timed | 14987.57 ± 0.6% | | 1.00 | 1.00 | 585.91 |
| opt/reverse-inner/email | 47 | 84676.86 ± 0.8% | not timed | not timed | 92520.70 ± 0.3% | 34.95 ± 6.8% | not timed | not timed | 84603.58 ± 0.3% | | 1.00 | 0.92 | 2422.48 |
| opt/reverse-inner/factored-prefix | 3542 | 599.82 ± 0.2% | not timed | not timed | 585.65 ± 1.1% | 13.80 ± 2.3% | not timed | not timed | 600.23 ± 1.1% | | 1.00 | 1.02 | 43.47 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4193.87 ± 0.1% | not timed | not timed | 605.08 ± 0.7% | 85.76 ± 0.1% | not timed | not timed | 4195.38 ± 0.4% | | 1.00 | 6.93 | 48.90 |
| opt/reverse-inner/no-quadratic-forward | 0 | 708.17 ± 1.9% | not timed | not timed | 279.20 ± 0.5% | 26.09 ± 15.5% | not timed | not timed | 709.40 ± 2.1% | | 1.00 | 2.54 | 27.14 |
| opt/reverse-suffix/holmes | 4073 | 15230.97 ± 10.5% | not timed | not timed | 13295.36 ± 0.5% | 25.52 ± 0.7% | not timed | not timed | 15289.64 ± 0.3% | | 1.00 | 1.15 | 596.85 |
| opt/reverse-suffix/no-quadratic | 0 | 4199.86 ± 0.1% | not timed | not timed | 603.41 ± 0.3% | 85.49 ± 28.8% | not timed | not timed | 4199.27 ± 0.1% | | 1.00 | 6.96 | 49.13 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 143.12 ± 1.5% | not timed | not timed | 183.50 ± 1.4% | 14.47 ± 26.0% | not timed | not timed | 143.09 ± 7.1% | | 1.00 | 0.78 | 9.89 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 141.03 ± 13.0% | not timed | not timed | 183.20 ± 0.4% | 13.67 ± 33.0% | not timed | not timed | 140.70 ± 20.5% | | 1.00 | 0.77 | 10.32 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.32 ± 1.2% | not timed | not timed | 0.48 ± 0.5% | 119.10 ± 0.7% | not timed | not timed | 0.32 ± 0.9% | | 1.01 | 0.66 | 0.0027 |
| reported/i1095-word-repetition/ascii-search | 256 | 301.62 ± 3.0% | not timed | not timed | 283.16 ± 0.3% | 109.23 ± 1.1% | not timed | not timed | 302.06 ± 0.3% | | 1.00 | 1.07 | 2.76 |
| reported/i13-subset-regex/original-ascii | 4094 | 11900.30 ± 0.5% | not timed | not timed | 3968.29 ± 1.1% | 12.26 ± 2.0% | not timed | not timed | 11929.05 ± 0.6% | | 1.00 | 3.00 | 970.40 |
| reported/i13-subset-regex/original-unicode | 4094 | 11857.25 ± 2.4% | not timed | not timed | 211.56 ± 1.5% | 12.27 ± 1.1% | not timed | not timed | 11952.73 ± 0.5% | | 0.99 | 56.05 | 966.68 |
| reported/i13-subset-regex/big-ascii | 1955 | 11114.00 ± 0.6% | not timed | not timed | 54.64 ± 2.3% | 10.57 ± 0.4% | not timed | not timed | 11140.00 ± 0.6% | | 1.00 | 203.39 | 1051.96 |
| reported/i13-subset-regex/big-unicode | 1955 | 11055.03 ± 4.4% | not timed | not timed | 9.67 ± 55.4% | 10.58 ± 1.6% | not timed | not timed | 11099.62 ± 3.3% | | 1.00 | 1143.23 | 1044.63 |
| reported/i13-subset-regex/huge-ascii | 55 | 10156.47 ± 1.1% | not timed | not timed | 9.02 ± 1.3% | 9.59 ± 1.4% | not timed | not timed | 10153.52 ± 3.6% | | 1.00 | 1126.36 | 1059.56 |
| reported/i13-subset-regex/huge-unicode | 55 | 10039.48 ± 4.8% | not timed | not timed | 8.98 ± 0.9% | 9.53 ± 2.5% | not timed | not timed | 10040.04 ± 3.3% | | 1.00 | 1117.54 | 1053.81 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.15 ± 0.5% | not timed | not timed | 8.94 ± 0.5% | 9.54 ± 2.9% | not timed | not timed | 4.21 ± 0.4% | | 0.99 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.84 ± 0.5% | not timed | not timed | 8.79 ± 0.8% | 9.53 ± 2.6% | not timed | not timed | 5.85 ± 0.3% | | 1.00 | 0.66 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 556.51 ± 0.8% | not timed | not timed | 170.81 ± 1.5% | 6.86 ± 2.1% | not timed | not timed | 558.51 ± 0.7% | | 1.00 | 3.26 | 81.09 |
| reported/i787-keywords/opt-ascii | 5674 | 557.95 ± 1.0% | not timed | not timed | 274.58 ± 0.8% | 10.83 ± 1.7% | not timed | not timed | 560.33 ± 1.7% | | 1.00 | 2.03 | 51.54 |
| slow/quadratic-regex-1x | 100 | 8.23 ± 1.7% | not timed | not timed | 5.98 ± 0.5% | 0.05 ± 0.8% | not timed | not timed | 8.21 ± 0.3% | | 1.00 | 1.38 | 179.35 |
| slow/quadratic-regex-2x | 199 | 3.70 ± 0.3% | not timed | not timed | 3.05 ± 0.3% | 0.01 ± 1.6% | not timed | not timed | 3.71 ± 0.1% | | 1.00 | 1.21 | 280.24 |
| slow/quadratic-haystack-1x | 100 | 26.21 ± 1.2% | not timed | not timed | 11.80 ± 0.9% | 1.01 ± 14.9% | not timed | not timed | 26.05 ± 7.2% | | 1.01 | 2.22 | 25.91 |
| slow/quadratic-haystack-2x | 200 | 19.88 ± 35.1% | not timed | not timed | 6.12 ± 0.2% | 0.52 ± 10.5% | not timed | not timed | 19.94 ± 0.3% | | 1.00 | 3.25 | 38.50 |
| unicode/codepoints/any-one | 1112064 | 338.11 ± 5.4% | not timed | not timed | 241.05 ± 0.4% | 21.96 ± 8.0% | not timed | not timed | 338.48 ± 0.3% | | 1.00 | 1.40 | 15.39 |
| unicode/codepoints/any-all | 4382592 | 267.84 ± 0.8% | not timed | not timed | 262.74 ± 0.6% | 125.77 ± 2.0% | not timed | not timed | 268.63 ± 3.0% | | 1.00 | 1.02 | 2.13 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.96 ± 0.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.72 ± 0.1% | not timed | not timed | 603.65 ± 0.2% | 153.24 ± 18.8% | not timed | not timed | 610.05 ± 0.2% | | 1.00 | 1.01 | 3.98 |
| unicode/overlapping-words/ascii | 6156 | 28.95 ± 7.5% | not timed | not timed | 43.11 ± 0.5% | 4.30 ± 5.4% | not timed | not timed | 29.17 ± 7.7% | | 0.99 | 0.67 | 6.74 |
| unicode/overlapping-words/english | 6156 | 1.43 ± 9.1% | not timed | not timed | 2.95 ± 0.3% | 2.86 ± 1.6% | not timed | not timed | 1.48 ± 0.9% | | 0.97 | 0.48 | 0.50 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 14.8% | not timed | not timed | 2.93 ± 10.1% | 7.07 ± 10.1% | not timed | not timed | 1.33 ± 0.1% | | 0.96 | 0.44 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 136.12 ± 7.1% | not timed | not timed | 84.83 ± 1.5% | 11.46 ± 18.8% | not timed | not timed | 137.84 ± 0.4% | | 0.99 | 1.60 | 11.88 |
| unicode/word/boundary-long-english | 3466 | 611.07 ± 1.1% | not timed | not timed | 593.16 ± 0.3% | 28.73 ± 0.3% | not timed | not timed | 612.00 ± 0.2% | | 1.00 | 1.03 | 21.27 |
| unicode/word/around-holmes-english | 27 | 64125.80 ± 0.7% | not timed | not timed | 44959.64 ± 0.2% | 19.36 ± 13.8% | not timed | not timed | 64319.44 ± 0.4% | | 1.00 | 1.43 | 3312.10 |
| wild/bibleref/long | 874 | 569.52 ± 0.1% | not timed | not timed | 574.14 ± 0.4% | 6.49 ± 11.8% | not timed | not timed | 571.00 ± 0.2% | | 1.00 | 0.99 | 87.73 |
| wild/bibleref/short | 30 | 22.93 ± 4.6% | not timed | not timed | 32.36 ± 0.8% | 13.18 ± 14.9% | not timed | not timed | 23.97 ± 1.8% | | 0.96 | 0.71 | 1.74 |
| wild/bibleref/line | 874 | 507.58 ± 0.5% | not timed | not timed | 269.45 ± 0.1% | 9.37 ± 2.5% | not timed | not timed | 514.38 ± 0.4% | | 0.99 | 1.88 | 54.17 |
| wild/caddy/caddy | 6 | 448.26 ± 2.6% | not timed | not timed | 292.56 ± 0.2% | 74.90 ± 7.0% | not timed | not timed | 447.95 ± 2.2% | | 1.00 | 1.53 | 5.98 |
| wild/dot-star-capture/rust-src-tools | 6 | 1454.32 ± 0.4% | not timed | not timed | 405.11 ± 1.3% | 15.77 ± 2.5% | not timed | not timed | 1456.81 ± 0.3% | | 1.00 | 3.59 | 92.25 |
| wild/ruff/noqa | 84 | 512.89 ± 0.5% | not timed | not timed | 507.79 ± 0.3% | 21.43 ± 37.5% | not timed | not timed | 512.50 ± 0.8% | | 1.00 | 1.01 | 23.94 |
| wild/ruff/unnecessary-coding-comment | 16 | 1070.99 ± 8.4% | not timed | not timed | 723.11 ± 0.5% | 90.38 ± 10.7% | not timed | not timed | 1074.00 ± 0.8% | | 1.00 | 1.48 | 11.85 |
| wild/ruff/string-quote-prefix | 2972 | 1589.81 ± 2.4% | not timed | not timed | 459.32 ± 0.3% | 320.81 ± 29.4% | not timed | not timed | 1589.40 ± 1.5% | | 1.00 | 3.46 | 4.96 |
| wild/ruff/space-around-operator | 1224378 | 237.96 ± 8.1% | not timed | not timed | 227.66 ± 1.6% | 18.96 ± 2.0% | not timed | not timed | 238.15 ± 1.5% | | 1.00 | 1.05 | 12.55 |
| wild/ruff/shebang | 282 | 1119.92 ± 14.7% | not timed | not timed | 391.53 ± 0.2% | 100.65 ± 17.9% | not timed | not timed | 1121.45 ± 1.3% | | 1.00 | 2.86 | 11.13 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22562.76 ± 0.8% | not timed | not timed | 23035.90 ± 5.1% | 8967.93 ± 2.8% | not timed | not timed | 21959.52 ± 1.9% | | 1.03 | 0.98 | 2.52 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20597.07 ± 0.9% | not timed | not timed | 22462.09 ± 0.2% | 8292.76 ± 21.0% | not timed | not timed | 20602.74 ± 0.1% | | 1.00 | 0.92 | 2.48 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 23057.99 ± 1.4% | not timed | not timed | 23254.43 ± 3.3% | 8687.98 ± 3.9% | not timed | not timed | 22908.13 ± 2.5% | | 1.01 | 0.99 | 2.65 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 18193.58 ± 3.8% | not timed | not timed | 23286.06 ± 24.8% | 8653.72 ± 23.2% | not timed | not timed | 18134.43 ± 0.5% | | 1.00 | 0.78 | 2.10 |
| wild/url/search | 234965 | 127.24 ± 13.2% | not timed | not timed | 60.70 ± 1.9% | 2.48 ± 1.1% | not timed | not timed | 124.22 ± 13.5% | | 1.02 | 2.10 | 51.30 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 69.1% | not timed | not timed | 0.01 ± 3.1% | 0.01 ± 11.7% | not timed | not timed | 0.03 ± 13.0% | | 1.01 | 2.49 | 3.81 |
| dictionary/compile/english-15 | 1 | 0.34 ± 0.7% | not timed | not timed | 0.10 ± 0.3% | 0.11 ± 8.5% | not timed | not timed | 0.35 ± 3.3% | | 0.99 | 3.57 | 3.00 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.30 ± 3.1% | not timed | not timed | 0.02 ± 1.0% | 37.19 ± 14.0% | not timed | not timed | 0.30 ± 20.5% | | 1.00 | 11.94 | 0.0080 |
| reported/i1095-word-repetition/ascii-compile | 1 | 44.15 ± 14.7% | not timed | not timed | 17.04 ± 1.5% | 62.90 ± 17.9% | not timed | not timed | 43.04 ± 2.3% | | 1.03 | 2.59 | 0.70 |
| reported/i787-keywords/compile | 1 | 40.24 ± 3.5% | not timed | not timed | 2.38 ± 0.7% | 18.45 ± 25.6% | not timed | not timed | 40.45 ± 0.8% | | 0.99 | 16.91 | 2.18 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 374.21 ± 3.3% | not timed | not timed | 157.46 ± 1.8% | 612.97 ± 25.5% | not timed | not timed | 380.21 ± 0.9% | | 0.98 | 2.38 | 0.61 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 52.83 ± 12.7% | not timed | not timed | 5.57 ± 0.6% | 49.78 ± 2.0% | not timed | not timed | 54.58 ± 3.3% | | 0.97 | 9.49 | 1.06 |
| unicode/compile/one-letter | 53 | 7.01 ± 11.5% | not timed | not timed | 5.84 ± 0.8% | 66.48 ± 6.2% | not timed | not timed | 7.00 ± 3.2% | | 1.00 | 1.20 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.24 ± 3.4% | not timed | not timed | 0.13 ± 0.5% | 67.96 ± 16.8% | not timed | not timed | 1.25 ± 5.3% | | 0.99 | 9.75 | 0.0182 |
| unicode/compile/fifty-letters-ascii | 1 | 196.89 ± 11.2% | not timed | not timed | 69.23 ± 0.1% | 219.80 ± 16.5% | not timed | not timed | 206.36 ± 10.1% | | 0.95 | 2.84 | 0.90 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 455.33 ± 6.3% | not timed | not timed | 51.50 ± 0.8% | 749.09 ± 13.5% | not timed | not timed | 456.26 ± 4.7% | | 1.00 | 8.84 | 0.61 |
| unicode/compile/match-every-line-ascii | 4 | 703.60 ± 11.0% | not timed | not timed | 165.28 ± 0.5% | 745.50 ± 12.1% | not timed | not timed | 707.18 ± 3.1% | | 0.99 | 4.26 | 0.94 |
| unicode/compile/negated-class-matches-codepoint | 1 | 375.71 ± 2.8% | not timed | not timed | 56.23 ± 1.1% | 1357.77 ± 8.0% | not timed | not timed | 374.51 ± 2.0% | | 1.00 | 6.68 | 0.28 |
| wild/bibleref/compile | 3 | 6.21 ± 3.3% | not timed | not timed | 2.43 ± 0.6% | 34.75 ± 5.2% | not timed | not timed | 6.25 ± 2.7% | | 0.99 | 2.56 | 0.18 |
| wild/url/compile | 1 | 0.72 ± 0.5% | not timed | not timed | 0.20 ± 0.5% | 0.46 ± 33.0% | not timed | not timed | 0.72 ± 18.5% | | 1.00 | 3.54 | 1.56 |

