# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506974679 |
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
| literal: a word | 217 | 60668.16 ± 2.6% | 6130.74 ± 2.6% | 44.15 ± 4.1% | 50021.30 ± 1.9% | 15799.96 ± 2.3% | 15.26 ± 5.7% | 155.98 ± 2.7% | 60303.12 ± 3.1% | 9.90 | 1.01 | 1.21 | 3.84 |
| literal: a word that is not there | 0 | 78832.75 ± 2.6% | 5804.79 ± 1.3% | 43.67 ± 2.1% | 62059.10 ± 2.8% | 53162.47 ± 2.4% | 14.66 ± 1.4% | 140.28 ± 1.4% | 79070.56 ± 4.1% | 13.58 | 1.00 | 1.27 | 1.48 |
| literal: one of four words | 661 | 21326.00 ± 1.5% | 2300.74 ± 2.3% | 24.40 ± 4.5% | 13962.41 ± 2.1% | 37.43 ± 2.2% | 4.96 ± 1.3% | 13.02 ± 1.3% | 21249.30 ± 5.5% | 9.27 | 1.00 | 1.53 | 569.69 |
| literal: a word in any case | 217 | 56806.58 ± 1.5% | 2507.57 ± 1.8% | 30.91 ± 1.5% | 13758.28 ± 2.3% | 70.75 ± 6.0% | refused | differs | 57118.43 ± 1.3% | 22.65 | 0.99 | 4.13 | 802.92 |
| literal: an href attribute | 33 | 50469.04 ± 3.5% | 698.03 ± 3.3% | 36.42 ± 3.2% | 45135.93 ± 7.6% | 3466.80 ± 0.7% | 11.27 ± 2.4% | 126.83 ± 2.1% | 50352.36 ± 2.4% | 72.30 | 1.00 | 1.12 | 14.56 |
| literal: a word, second text | 123 | 61756.06 ± 1.8% | 4311.41 ± 1.7% | 42.67 ± 2.6% | 47564.53 ± 4.1% | 14099.57 ± 4.0% | 20.28 ± 2.3% | 126.67 ± 3.5% | 62144.83 ± 4.2% | 14.32 | 0.99 | 1.30 | 4.38 |
| class: two capitalized words | 1331 | 1060.98 ± 3.9% | 698.51 ± 4.0% | 39.42 ± 4.4% | 660.05 ± 2.1% | 59.19 ± 2.4% | 13.31 ± 1.7% | 101.69 ± 3.3% | 1077.75 ± 2.9% | 1.52 | 0.98 | 1.61 | 17.92 |
| class: a word that ends in ing | 3399 | 677.47 ± 4.0% | 673.86 ± 7.8% | 25.88 ± 5.0% | 609.57 ± 4.1% | 43.65 ± 21.0% | 7.61 ± 3.9% | 30.08 ± 5.2% | 675.32 ± 3.4% | 1.01 | 1.00 | 1.11 | 15.52 |
| class: a word in capitals | 2332 | 1553.18 ± 2.7% | 704.82 ± 1.9% | 41.89 ± 1.8% | 649.95 ± 2.5% | 63.96 ± 24.1% | 15.90 ± 3.2% | 128.98 ± 3.1% | 1574.35 ± 2.4% | 2.20 | 0.99 | 2.39 | 24.29 |
| class: a number | 8288 | 2839.18 ± 3.8% | 1005.01 ± 2.7% | 42.90 ± 5.3% | 2207.86 ± 4.0% | 59.23 ± 13.1% | 0.44 ± 1.9% | 95.25 ± 3.1% | 2895.30 ± 5.4% | 2.83 | 0.98 | 1.29 | 47.93 |
| class: two capitalized words, second text | 5359 | 599.83 ± 2.0% | 611.78 ± 1.4% | 36.18 ± 0.9% | 554.13 ± 1.7% | 49.14 ± 16.3% | 17.23 ± 1.9% | 95.00 ± 2.0% | 604.46 ± 2.2% | 0.98 | 0.99 | 1.08 | 12.21 |
| other: a word between two words | 6104 | 1139.53 ± 5.1% | 705.81 ± 2.2% | 35.03 ± 2.0% | 935.53 ± 1.6% | 167.31 ± 21.8% | 10.02 ± 0.9% | 112.13 ± 3.4% | 1145.01 ± 2.2% | 1.61 | 1.00 | 1.22 | 6.81 |
| other: a number before a unit, second text | 1481 | 12828.24 ± 6.6% | 1390.94 ± 4.5% | 39.97 ± 2.3% | 10430.57 ± 2.4% | 57.94 ± 10.2% | 18.60 ± 2.3% | 105.13 ± 4.1% | 12870.12 ± 2.4% | 9.22 | 1.00 | 1.23 | 221.41 |
| other: a heading's start tag | 110 | 30539.00 ± 2.6% | 855.65 ± 0.9% | 40.68 ± 1.5% | 3226.41 ± 3.2% | 2467.54 ± 6.5% | 13.55 ± 1.4% | 160.40 ± 3.0% | 30620.93 ± 3.0% | 35.69 | 1.00 | 9.47 | 12.38 |
| other: a whole word | 217 | 40422.11 ± 1.3% | 697.00 ± 0.6% | 44.09 ± 2.3% | 35642.07 ± 1.9% | 73.23 ± 2.6% | 13.19 ± 2.0% | 82.20 ± 2.1% | 40519.47 ± 1.9% | 57.99 | 1.00 | 1.13 | 552.02 |
| other: a line's first word, second text | 3716 | 3415.14 ± 7.5% | 695.11 ± 3.1% | 48.00 ± 2.4% | 3327.37 ± 8.0% | 99.11 ± 4.4% | refused | refused | 3400.87 ± 2.7% | 4.91 | 1.00 | 1.03 | 34.46 |
| other: fourteen octets before an x | 87 | 50096.38 ± 1.6% | 324.24 ± 2.8% | 8.63 ± 2.8% | 4738.30 ± 2.9% | 13.74 ± 2.6% | differs | 24.54 ± 2.9% | 49708.33 ± 2.5% | 154.51 | 1.01 | 10.57 | 3644.77 |
| other: a Greek word | 21815 | 636.91 ± 3.9% | 532.03 ± 9.8% | 48.24 ± 2.4% | 336.95 ± 2.1% | 76.33 ± 8.0% | differs | refused | 647.18 ± 22.8% | 1.20 | 0.98 | 1.89 | 8.34 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 37.16 ± 2.7% | 37.42 ± 2.6% | 1.47 ± 4.0% | 23.14 ± 7.3% | 3.51 ± 1.5% | differs | 5.91 ± 5.2% | 37.09 ± 1.1% | 0.99 | 1.00 | 1.61 | 10.59 |
| a UUID | 32895 | 33.40 ± 1.5% | 33.02 ± 1.6% | 0.99 ± 2.5% | 17.38 ± 3.0% | 3.30 ± 2.5% | 0.72 ± 1.9% | 4.60 ± 4.7% | 32.11 ± 1.8% | 1.01 | 1.04 | 1.92 | 10.13 |
| an IPv4 address | 33176 | 46.63 ± 1.2% | 46.56 ± 2.2% | 3.16 ± 2.8% | 33.64 ± 2.0% | 8.96 ± 3.5% | differs | 5.73 ± 3.5% | 46.47 ± 1.9% | 1.00 | 1.00 | 1.39 | 5.20 |
| a date and time | 32954 | 45.53 ± 1.5% | 43.66 ± 2.7% | 2.27 ± 3.4% | 25.49 ± 2.8% | 10.64 ± 4.5% | 1.27 ± 2.5% | 11.55 ± 5.9% | 45.89 ± 2.3% | 1.04 | 0.99 | 1.79 | 4.28 |
| a field path | 32606 | 39.73 ± 3.5% | 39.95 ± 3.8% | 1.65 ± 4.4% | 27.03 ± 3.6% | 4.49 ± 5.7% | differs | 4.08 ± 2.6% | 39.76 ± 3.2% | 0.99 | 1.00 | 1.47 | 8.84 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 14.97 ± 5.3% | 15.55 ± 4.8% | 15.00 ± 3.1% | 17.04 ± 1.9% | 7.55 ± 3.3% | 1.01 ± 2.6% | none | 15.18 ± 2.7% | 0.96 | 0.99 | 0.88 | 1.98 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 360.31 ± 13.0% | 358.01 ± 6.0% | 422.20 ± 1.2% | 133.64 ± 1.5% | 324.46 ± 11.3% | 882.23 ± 24.8% | 5598.69 ± 7.1% | 359.58 ± 1.5% | 1.01 | 1.00 | 2.70 | 1.11 |
| a UUID | 62 | 236.38 ± 3.6% | 234.99 ± 2.5% | 262.95 ± 1.1% | 74.17 ± 1.5% | 156.47 ± 11.7% | 308.75 ± 4.0% | 7197.73 ± 15.1% | 236.78 ± 0.2% | 1.01 | 1.00 | 3.19 | 1.51 |
| an IPv4 address | 29 | 699.73 ± 4.7% | 697.84 ± 2.9% | 963.80 ± 3.4% | 118.24 ± 2.4% | 201.41 ± 10.0% | 552.58 ± 2.8% | 12844.80 ± 3.9% | 702.97 ± 3.0% | 1.00 | 1.00 | 5.92 | 3.47 |
| a date and time | 56 | 504.41 ± 0.6% | 503.18 ± 1.2% | 618.19 ± 4.5% | 111.85 ± 1.2% | 222.05 ± 1.1% | 565.94 ± 1.5% | 7961.54 ± 6.1% | 502.05 ± 0.5% | 1.00 | 1.00 | 4.51 | 2.27 |
| a field path | 39 | 355.62 ± 2.7% | 352.88 ± 2.2% | 414.25 ± 8.8% | 125.35 ± 4.1% | 303.84 ± 13.0% | 906.22 ± 4.4% | 7278.04 ± 3.5% | 357.05 ± 3.9% | 1.01 | 1.00 | 2.84 | 1.17 |
| literal: a word | 7 | 1061.53 ± 6.4% | 1143.43 ± 4.2% | 1948.35 ± 3.2% | 816.32 ± 4.7% | 995.01 ± 9.7% | 1779.42 ± 1.4% | 47101.42 ± 2.2% | 1048.23 ± 3.4% | 0.93 | 1.01 | 1.30 | 1.07 |
| literal: a word that is not there | 8 | 1006.08 ± 3.4% | 1093.31 ± 2.9% | 1776.97 ± 4.8% | 764.91 ± 3.5% | 969.20 ± 3.3% | 1696.66 ± 2.4% | 45941.32 ± 1.3% | 1009.73 ± 3.7% | 0.92 | 1.00 | 1.32 | 1.04 |
| literal: one of four words | 26 | 397.17 ± 3.3% | 627.86 ± 4.3% | 816.61 ± 3.4% | 65.04 ± 1.4% | 378.82 ± 1.3% | 629.73 ± 6.0% | 26550.59 ± 8.4% | 396.11 ± 3.6% | 0.63 | 1.00 | 6.11 | 1.05 |
| literal: a word in any case | 11 | 741.00 ± 2.7% | 796.27 ± 5.8% | 1127.33 ± 2.7% | 22.33 ± 5.4% | 1059.76 ± 4.6% | refused | 39414.40 ± 2.9% | 748.53 ± 2.3% | 0.93 | 0.99 | 33.19 | 0.70 |
| literal: an href attribute | 12 | 559.99 ± 2.5% | 575.43 ± 1.9% | 741.05 ± 2.9% | 59.10 ± 3.8% | 733.10 ± 2.8% | 1429.09 ± 2.5% | 32414.15 ± 1.4% | 558.09 ± 2.5% | 0.97 | 1.00 | 9.48 | 0.76 |
| literal: a word, second text | 10 | 926.10 ± 2.0% | 1005.32 ± 2.8% | 1611.59 ± 3.2% | 692.05 ± 1.6% | 843.34 ± 13.0% | 1496.96 ± 4.2% | 44155.46 ± 1.1% | 918.19 ± 0.7% | 0.92 | 1.01 | 1.34 | 1.10 |
| class: two capitalized words | 23 | 735.38 ± 2.0% | 788.13 ± 2.1% | 1121.87 ± 1.7% | 157.02 ± 3.5% | 783.76 ± 1.1% | 1383.12 ± 2.3% | 9511.63 ± 2.1% | 728.58 ± 2.3% | 0.93 | 1.01 | 4.68 | 0.94 |
| class: a word that ends in ing | 9 | 911.56 ± 5.5% | 1041.28 ± 5.9% | 1774.52 ± 1.8% | 204.36 ± 2.2% | 1101.38 ± 2.2% | 2191.96 ± 1.5% | 24662.24 ± 2.0% | 921.09 ± 4.5% | 0.88 | 0.99 | 4.46 | 0.83 |
| class: a word in capitals | 16 | 837.12 ± 4.6% | 909.22 ± 3.0% | 1418.66 ± 3.0% | 201.63 ± 3.5% | 1150.64 ± 3.6% | 1971.73 ± 3.0% | 12464.41 ± 2.9% | 836.43 ± 3.3% | 0.92 | 1.00 | 4.15 | 0.73 |
| class: a number | 6 | 1042.17 ± 4.3% | 1142.53 ± 4.1% | 2075.60 ± 2.7% | 57.91 ± 2.0% | 2095.10 ± 1.7% | 3611.12 ± 2.3% | 36075.02 ± 0.8% | 1037.77 ± 4.5% | 0.91 | 1.00 | 18.00 | 0.50 |
| class: two capitalized words, second text | 23 | 738.70 ± 1.7% | 799.41 ± 2.9% | 1140.85 ± 6.1% | 157.09 ± 6.4% | 792.56 ± 6.3% | 1403.36 ± 3.3% | 9641.45 ± 2.8% | 738.26 ± 1.9% | 0.92 | 1.00 | 4.70 | 0.93 |
| other: a word between two words | 13 | 906.07 ± 3.3% | 940.28 ± 3.2% | 1456.52 ± 3.0% | 208.24 ± 2.9% | 764.49 ± 2.7% | 1511.30 ± 1.1% | 23516.79 ± 0.6% | 901.62 ± 1.9% | 0.96 | 1.00 | 4.35 | 1.19 |
| other: a number before a unit, second text | 15 | 655.02 ± 1.7% | 739.63 ± 2.6% | 1018.41 ± 1.8% | 55.20 ± 1.2% | 939.22 ± 11.9% | 1683.09 ± 4.1% | 24289.73 ± 2.4% | 656.46 ± 1.6% | 0.89 | 1.00 | 11.87 | 0.70 |
| other: a heading's start tag | 13 | 586.90 ± 2.6% | 597.35 ± 3.0% | 782.80 ± 0.9% | 58.77 ± 1.1% | 920.54 ± 1.2% | 1643.51 ± 0.9% | 28231.90 ± 0.7% | 589.28 ± 1.9% | 0.98 | 1.00 | 9.99 | 0.64 |
| other: a whole word | 11 | 944.01 ± 2.8% | 1017.51 ± 3.2% | 1610.42 ± 3.5% | 187.23 ± 0.7% | 894.79 ± 1.6% | 1577.63 ± 0.6% | 44018.06 ± 0.9% | 947.42 ± 2.3% | 0.93 | 1.00 | 5.04 | 1.06 |
| other: a line's first word, second text | 17 | 888.98 ± 4.3% | 944.36 ± 2.8% | 1497.89 ± 6.6% | 198.93 ± 1.5% | 1050.37 ± 1.2% | refused | refused | 891.35 ± 7.3% | 0.94 | 1.00 | 4.47 | 0.85 |
| other: fourteen octets before an x | 16 | 181.92 ± 3.6% | 257.26 ± 3.0% | 295.91 ± 1.2% | 22.61 ± 1.6% | 677.66 ± 2.4% | 754.97 ± 0.7% | 21004.56 ± 0.4% | 182.53 ± 4.8% | 0.71 | 1.00 | 8.05 | 0.27 |
| other: a Greek word | 8 | 721.83 ± 3.6% | 964.81 ± 5.0% | 1554.78 ± 2.8% | 73.67 ± 0.6% | 2086.90 ± 13.1% | 3343.75 ± 6.3% | refused | 711.88 ± 2.7% | 0.75 | 1.01 | 9.80 | 0.35 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 44934.44 ± 2.1% | not timed | not timed | 43924.94 ± 1.2% | 3574.40 ± 21.2% | not timed | not timed | 44925.25 ± 2.0% | | 1.00 | 1.02 | 12.57 |
| 01-literal/sherlock-casei-en | 522 | 40320.60 ± 1.5% | not timed | not timed | 11223.44 ± 3.4% | 51.62 ± 4.4% | not timed | not timed | 40167.73 ± 1.8% | | 1.00 | 3.59 | 781.13 |
| 01-literal/sherlock-ru | 724 | 44914.99 ± 0.8% | not timed | not timed | 42235.64 ± 1.3% | 2370.60 ± 3.4% | not timed | not timed | 45056.36 ± 5.0% | | 1.00 | 1.06 | 18.95 |
| 01-literal/sherlock-casei-ru | 746 | 14655.97 ± 0.8% | not timed | not timed | 9071.27 ± 0.9% | 54.84 ± 1.1% | not timed | not timed | 14679.95 ± 1.0% | | 1.00 | 1.62 | 267.24 |
| 01-literal/sherlock-zh | 30 | 78095.26 ± 1.2% | not timed | not timed | 57905.36 ± 1.4% | 2076.04 ± 2.4% | not timed | not timed | 78426.83 ± 2.8% | | 1.00 | 1.35 | 37.62 |
| 02-literal-alternate/sherlock-en | 714 | 18367.21 ± 1.5% | not timed | not timed | 13144.84 ± 0.3% | 28.29 ± 2.3% | not timed | not timed | 18244.94 ± 2.0% | | 1.01 | 1.40 | 649.30 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3010.65 ± 6.2% | not timed | not timed | 2882.25 ± 1.2% | 17.95 ± 3.6% | not timed | not timed | 3013.52 ± 4.8% | | 1.00 | 1.04 | 167.75 |
| 02-literal-alternate/sherlock-ru | 899 | 12128.71 ± 22.4% | not timed | not timed | 7153.58 ± 2.2% | 36.72 ± 3.3% | not timed | not timed | 12372.62 ± 13.9% | | 0.98 | 1.70 | 330.29 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2679.46 ± 1.3% | not timed | not timed | 1400.79 ± 1.3% | 15.56 ± 2.3% | not timed | not timed | 2691.42 ± 2.9% | | 1.00 | 1.91 | 172.16 |
| 02-literal-alternate/sherlock-zh | 207 | 24602.26 ± 5.5% | not timed | not timed | 15496.66 ± 1.3% | 51.73 ± 11.3% | not timed | not timed | 24464.84 ± 1.2% | | 1.01 | 1.59 | 475.58 |
| 03-date/ascii | 111817 | 180.07 ± 2.1% | not timed | not timed | 121.50 ± 7.5% | 0.32 ± 5.6% | not timed | not timed | 181.09 ± 3.2% | | 0.99 | 1.48 | 568.31 |
| 04-ruff-noqa/real | 84 | 647.71 ± 1.5% | not timed | not timed | 668.98 ± 12.8% | 24.40 ± 0.6% | not timed | not timed | 649.26 ± 3.7% | | 1.00 | 0.97 | 26.54 |
| 04-ruff-noqa/tweaked | 44 | 811.12 ± 11.3% | not timed | not timed | 674.69 ± 1.7% | 422.20 ± 10.4% | not timed | not timed | 826.62 ± 1.1% | | 0.98 | 1.20 | 1.92 |
| 05-lexer-veryl/single | 124800 | 7.25 ± 2.7% | not timed | not timed | 7.51 ± 6.2% | 0.35 ± 5.6% | not timed | not timed | 7.29 ± 40.0% | | 0.99 | 0.97 | 20.97 |
| 06-cloud-flare-redos/original | 107 | 548.58 ± 8.3% | not timed | not timed | 280.31 ± 0.6% | 38.38 ± 1.3% | not timed | not timed | 549.15 ± 0.9% | | 1.00 | 1.96 | 14.29 |
| 06-cloud-flare-redos/simplified-short | 102 | 545.33 ± 6.6% | not timed | not timed | 294.33 ± 1.1% | 41.51 ± 3.9% | not timed | not timed | 543.57 ± 13.0% | | 1.00 | 1.85 | 13.14 |
| 06-cloud-flare-redos/simplified-long | 10000 | 639.50 ± 0.6% | not timed | not timed | 317.61 ± 1.7% | 44.79 ± 1.3% | not timed | not timed | 639.12 ± 0.7% | | 1.00 | 2.01 | 14.28 |
| 07-unicode-character-data/parse-line | 558784 | 329.01 ± 8.3% | not timed | not timed | 252.92 ± 2.5% | 64.31 ± 5.1% | not timed | not timed | 322.74 ± 7.3% | | 1.02 | 1.30 | 5.12 |
| 08-words/all-english | 56691 | 166.74 ± 0.8% | not timed | not timed | 104.71 ± 1.9% | 18.85 ± 13.5% | not timed | not timed | 168.82 ± 2.4% | | 0.99 | 1.59 | 8.85 |
| 08-words/long-english | 839 | 743.55 ± 7.1% | not timed | not timed | 701.13 ± 4.3% | 49.65 ± 1.7% | not timed | not timed | 755.70 ± 2.4% | | 0.98 | 1.06 | 14.98 |
| 09-aws-keys/full | 0 | 686.25 ± 5.6% | not timed | not timed | 695.80 ± 6.1% | 90.39 ± 7.5% | not timed | not timed | 673.66 ± 5.4% | | 1.02 | 0.99 | 7.59 |
| 09-aws-keys/quick | 0 | 1513.13 ± 6.1% | not timed | not timed | 1287.80 ± 6.0% | 572.29 ± 14.0% | not timed | not timed | 1503.94 ± 5.8% | | 1.01 | 1.17 | 2.64 |
| 10-bounded-repeat/letters-en | 1833 | 828.37 ± 6.8% | not timed | not timed | 729.26 ± 5.4% | 29.88 ± 11.4% | not timed | not timed | 827.80 ± 5.4% | | 1.00 | 1.14 | 27.72 |
| 10-bounded-repeat/letters-ru | 3475 | 701.91 ± 1.0% | not timed | not timed | 627.93 ± 4.6% | 31.10 ± 16.8% | not timed | not timed | 703.10 ± 1.1% | | 1.00 | 1.12 | 22.57 |
| 10-bounded-repeat/context | 53 | 117.65 ± 3.4% | not timed | not timed | 89.98 ± 0.4% | 29.35 ± 3.0% | not timed | not timed | 115.73 ± 6.9% | | 1.02 | 1.31 | 4.01 |
| 10-bounded-repeat/capitals | 11 | 749.22 ± 8.5% | not timed | not timed | 708.91 ± 5.2% | 52.16 ± 4.1% | not timed | not timed | 745.32 ± 8.6% | | 1.01 | 1.06 | 14.36 |
| 11-unstructured-to-json/extract | 600 | 72.92 ± 14.0% | not timed | not timed | 103.72 ± 0.6% | 74.97 ± 14.8% | not timed | not timed | 72.32 ± 6.0% | | 1.01 | 0.70 | 0.97 |
| 12-dictionary/single | 1 | 642.47 ± 4.9% | not timed | not timed | 638.22 ± 6.1% | 0.64 ± 5.5% | not timed | not timed | 636.09 ± 6.6% | | 1.01 | 1.01 | 1007.24 |
| 14-quadratic/1x | 100 | 40.51 ± 5.2% | not timed | not timed | 17.35 ± 5.6% | 1.44 ± 4.9% | not timed | not timed | 39.23 ± 12.4% | | 1.03 | 2.34 | 28.07 |
| 14-quadratic/2x | 200 | 31.56 ± 8.8% | not timed | not timed | 8.05 ± 8.7% | 0.81 ± 69.8% | not timed | not timed | 32.90 ± 14.2% | | 0.96 | 3.92 | 38.74 |
| 14-quadratic/10x | 1000 | 10.73 ± 1.4% | not timed | not timed | 1.44 ± 4.8% | 0.17 ± 3.5% | not timed | not timed | 10.80 ± 1.7% | | 0.99 | 7.44 | 62.44 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.95 ± 7.0% | not timed | not timed | 0.55 ± 7.8% | 0.87 ± 12.3% | not timed | not timed | 2.04 ± 11.5% | | 0.96 | 3.53 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 181.68 ± 2.0% | not timed | not timed | 21.23 ± 16.3% | 226.34 ± 1.9% | not timed | not timed | 181.86 ± 1.4% | | 1.00 | 8.56 | 0.80 |
| 05-lexer-veryl/compile-single | 1 | 22.68 ± 1.8% | not timed | not timed | 3.87 ± 3.7% | 10.77 ± 19.2% | not timed | not timed | 22.79 ± 1.8% | | 1.00 | 5.87 | 2.11 |
| 07-unicode-character-data/compile | 1 | 175.88 ± 35.3% | not timed | not timed | 40.41 ± 2.9% | 57.87 ± 47.3% | not timed | not timed | 177.61 ± 1.5% | | 0.99 | 4.35 | 3.04 |
| 09-aws-keys/compile-full | 1 | 75.79 ± 7.7% | not timed | not timed | 12.51 ± 1.0% | 36.62 ± 2.4% | not timed | not timed | 75.34 ± 1.8% | | 1.01 | 6.06 | 2.07 |
| 09-aws-keys/compile-quick | 1 | 280.92 ± 2.6% | not timed | not timed | 78.06 ± 0.9% | 206.75 ± 7.1% | not timed | not timed | 282.11 ± 2.2% | | 1.00 | 3.60 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 86.50 ± 1.5% | not timed | not timed | 17.45 ± 1.0% | 26.22 ± 2.0% | not timed | not timed | 86.29 ± 1.4% | | 1.00 | 4.96 | 3.30 |
| 10-bounded-repeat/compile-capitals | 1 | 139.48 ± 4.7% | not timed | not timed | 12.78 ± 4.9% | 38.25 ± 4.5% | not timed | not timed | 138.69 ± 6.7% | | 1.01 | 10.91 | 3.65 |
| 11-unstructured-to-json/compile | 1 | 282.64 ± 5.1% | not timed | not timed | 65.68 ± 6.8% | 109.35 ± 5.5% | not timed | not timed | 283.40 ± 3.9% | | 1.00 | 4.30 | 2.58 |
| 12-dictionary/compile-single | 1 | 0.45 ± 3.1% | not timed | not timed | 0.10 ± 9.6% | 0.15 ± 21.3% | not timed | not timed | 0.46 ± 5.3% | | 0.99 | 4.67 | 3.01 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.50 ± 5.7% | not timed | not timed | 10.48 ± 5.3% | 0.90 ± 23.4% | not timed | not timed | 10.66 ± 10.0% | | 0.98 | 1.00 | 11.62 |
| dictionary/search/english-10 | 690 | 1.82 ± 3.4% | not timed | not timed | 225.57 ± 5.4% | 0.01 ± 3.7% | not timed | not timed | 1.82 ± 3.7% | | 1.00 | 0.0081 | 180.98 |
| dictionary/search/english-15 | 15 | 626.78 ± 0.7% | not timed | not timed | 600.66 ± 0.8% | 0.57 ± 1.5% | not timed | not timed | 627.50 ± 3.1% | | 1.00 | 1.04 | 1107.10 |
| folly/awyer-inn-busted | 1 | 6766.93 ± 5.5% | not timed | not timed | 158.78 ± 0.8% | 70.16 ± 0.4% | not timed | not timed | 6768.77 ± 3.7% | | 1.00 | 42.62 | 96.46 |
| folly/literal-never-match-rare | 0 | 82765.89 ± 2.0% | not timed | not timed | 65762.95 ± 0.6% | 87724.93 ± 20.4% | not timed | not timed | 82819.02 ± 0.6% | | 1.00 | 1.26 | 0.94 |
| folly/literal-never-match-frequent | 0 | 36459.20 ± 11.2% | not timed | not timed | 63810.11 ± 0.7% | 2922.04 ± 1.4% | not timed | not timed | 37516.99 ± 10.0% | | 0.97 | 0.57 | 12.48 |
| folly/literal-never-match-tricksy | 1 | 5092.30 ± 1.2% | not timed | not timed | 8484.64 ± 3.9% | 3681.44 ± 2.2% | not timed | not timed | 5120.93 ± 1.5% | | 0.99 | 0.60 | 1.38 |
| grep/every-line | 239963 | 1775.55 ± 1.3% | not timed | not timed | 1241.69 ± 0.6% | 500.35 ± 11.7% | not timed | not timed | 1762.50 ± 4.1% | | 1.01 | 1.43 | 3.55 |
| grep/long-words-ascii | 5073 | 635.25 ± 3.5% | not timed | not timed | 592.63 ± 1.5% | 64.30 ± 8.8% | not timed | not timed | 644.03 ± 3.6% | | 0.99 | 1.07 | 9.88 |
| imported/leipzig/twain | 811 | 73830.40 ± 5.8% | not timed | not timed | 61314.77 ± 26.7% | 15046.57 ± 9.7% | not timed | not timed | 73699.74 ± 4.8% | | 1.00 | 1.20 | 4.91 |
| imported/leipzig/twain-insensitive | 965 | 19262.65 ± 5.4% | not timed | not timed | 17581.91 ± 8.4% | 64.94 ± 4.5% | not timed | not timed | 19035.88 ± 4.4% | | 1.01 | 1.10 | 296.60 |
| imported/leipzig/shing | 1540 | 41844.88 ± 4.1% | not timed | not timed | 27678.75 ± 2.3% | 52.64 ± 0.9% | not timed | not timed | 41861.78 ± 9.5% | | 1.00 | 1.51 | 794.86 |
| imported/leipzig/huck-saw | 262 | 35518.09 ± 1.2% | not timed | not timed | 24709.73 ± 3.1% | 54.80 ± 11.2% | not timed | not timed | 35719.01 ± 8.3% | | 0.99 | 1.44 | 648.15 |
| imported/leipzig/word-ending-nn | 262 | 710.87 ± 0.5% | not timed | not timed | 715.09 ± 1.4% | 39.71 ± 1.4% | not timed | not timed | 706.80 ± 2.1% | | 1.01 | 0.99 | 17.90 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 15080.24 ± 4.6% | not timed | not timed | 5428.91 ± 5.4% | 15.38 ± 4.9% | not timed | not timed | 15190.13 ± 3.1% | | 0.99 | 2.78 | 980.29 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 28501.13 ± 0.7% | not timed | not timed | 21591.06 ± 0.6% | 29.46 ± 2.4% | not timed | not timed | 28408.80 ± 2.0% | | 1.00 | 1.32 | 967.61 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6502.21 ± 5.3% | not timed | not timed | 1153.77 ± 7.4% | 18.28 ± 2.9% | not timed | not timed | 6579.48 ± 8.9% | | 0.99 | 5.64 | 355.76 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 709.38 ± 2.4% | not timed | not timed | 709.04 ± 0.3% | 18.75 ± 4.3% | not timed | not timed | 711.79 ± 1.6% | | 1.00 | 1.00 | 37.84 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 714.31 ± 1.5% | not timed | not timed | 711.94 ± 2.3% | 16.03 ± 2.5% | not timed | not timed | 713.51 ± 2.5% | | 1.00 | 1.00 | 44.55 |
| imported/leipzig/tom-river | 2 | 16704.58 ± 3.1% | not timed | not timed | 17246.87 ± 2.3% | 52.91 ± 1.5% | not timed | not timed | 16695.66 ± 0.8% | | 1.00 | 0.97 | 315.70 |
| imported/leipzig/ing | 78424 | 705.33 ± 3.3% | not timed | not timed | 663.34 ± 2.4% | 44.05 ± 7.2% | not timed | not timed | 702.74 ± 3.3% | | 1.00 | 1.06 | 16.01 |
| imported/leipzig/ing-whitespace | 55248 | 873.62 ± 2.3% | not timed | not timed | 2803.88 ± 5.0% | 32.70 ± 5.7% | not timed | not timed | 883.10 ± 4.3% | | 0.99 | 0.31 | 26.72 |
| imported/leipzig/awyer-inn | 209 | 907.98 ± 7.0% | not timed | not timed | 17378.82 ± 6.0% | 34.37 ± 6.3% | not timed | not timed | 914.72 ± 5.0% | | 0.99 | 0.0522 | 26.42 |
| imported/leipzig/quotes-bounded | 8886 | 2450.28 ± 1.8% | not timed | not timed | 3848.95 ± 2.2% | 56.54 ± 8.3% | not timed | not timed | 2448.60 ± 1.4% | | 1.00 | 0.64 | 43.34 |
| imported/leipzig/non-ascii-alternate | 2 | 62464.17 ± 5.1% | not timed | not timed | 24178.92 ± 1.9% | 83.10 ± 8.8% | not timed | not timed | 62874.98 ± 24.2% | | 0.99 | 2.58 | 751.67 |
| imported/leipzig/math-symbols | 69 | 4254.84 ± 2.5% | not timed | not timed | 707.26 ± 1.8% | 55.67 ± 1.7% | not timed | not timed | 4223.56 ± 4.8% | | 1.01 | 6.02 | 76.43 |
| imported/leipzig/bounded-strings-ending-z | 0 | 702.00 ± 1.5% | not timed | not timed | 704.04 ± 0.8% | 37.40 ± 1.5% | not timed | not timed | 701.84 ± 0.6% | | 1.00 | 1.00 | 18.77 |
| imported/lh3lh3-reb/uri | 17549 | 991.16 ± 1.6% | not timed | not timed | 1493.13 ± 3.2% | 40.34 ± 2.0% | not timed | not timed | 979.10 ± 1.9% | | 1.01 | 0.66 | 24.57 |
| imported/lh3lh3-reb/email | 15057 | 955.05 ± 5.6% | not timed | not timed | 1451.15 ± 6.6% | 43.07 ± 6.6% | not timed | not timed | 982.76 ± 6.2% | | 0.97 | 0.66 | 22.18 |
| imported/lh3lh3-reb/date | 668 | 1156.23 ± 10.1% | not timed | not timed | 1290.14 ± 5.1% | 71.36 ± 3.7% | not timed | not timed | 1152.17 ± 7.1% | | 1.00 | 0.90 | 16.20 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 977.97 ± 5.1% | not timed | not timed | 560.42 ± 6.7% | 22.76 ± 6.0% | not timed | not timed | 962.91 ± 3.5% | | 1.02 | 1.75 | 42.97 |
| imported/mariomka/email | 92 | 55252.04 ± 4.9% | not timed | not timed | 76831.71 ± 6.1% | 52.21 ± 10.8% | not timed | not timed | 55525.73 ± 4.8% | | 1.00 | 0.72 | 1058.31 |
| imported/mariomka/uri | 5301 | 8779.03 ± 7.7% | not timed | not timed | 9238.55 ± 5.3% | 49.48 ± 13.0% | not timed | not timed | 8808.10 ± 7.6% | | 1.00 | 0.95 | 177.43 |
| imported/mariomka/ip | 5 | 2516.19 ± 8.5% | not timed | not timed | 2995.47 ± 13.9% | 34.48 ± 16.8% | not timed | not timed | 2531.22 ± 5.9% | | 0.99 | 0.84 | 72.97 |
| imported/rsc/no-exponential | 0 | 1226.15 ± 22.2% | not timed | not timed | 792.70 ± 20.1% | 36.71 ± 5.2% | not timed | not timed | 1188.97 ± 6.7% | | 1.03 | 1.55 | 33.40 |
| imported/rsc/literal | 1 | 1402.52 ± 9.5% | not timed | not timed | 3231.66 ± 1.1% | 340.35 ± 18.0% | not timed | not timed | 1396.73 ± 4.7% | | 1.00 | 0.43 | 4.12 |
| imported/rsc/not-literal | 2 | 1441.64 ± 8.6% | not timed | not timed | 970.35 ± 5.6% | 76.13 ± 4.7% | not timed | not timed | 1425.94 ± 8.8% | | 1.01 | 1.49 | 18.94 |
| imported/rsc/match-class | 1 | 2573.14 ± 7.4% | not timed | not timed | 3054.19 ± 1.3% | 94.85 ± 3.8% | not timed | not timed | 2566.20 ± 1.5% | | 1.00 | 0.84 | 27.13 |
| imported/rsc/match-class-in-range | 1 | 2580.60 ± 1.3% | not timed | not timed | 4767.14 ± 5.2% | 99.02 ± 2.3% | not timed | not timed | 2571.61 ± 12.3% | | 1.00 | 0.54 | 26.06 |
| imported/rsc/match-class-unicode | 1 | 685.49 ± 5.3% | not timed | not timed | 657.57 ± 1.3% | 116.10 ± 6.9% | not timed | not timed | 706.20 ± 4.3% | | 0.97 | 1.04 | 5.90 |
| imported/rsc/anchored-literal-short-non-match | 0 | 2516.36 ± 1.1% | not timed | not timed | 1737.71 ± 2.9% | 449.18 ± 6.3% | not timed | not timed | 2505.17 ± 32.2% | | 1.00 | 1.45 | 5.60 |
| imported/rsc/anchored-literal-long-non-match | 0 | 37533.45 ± 4.6% | not timed | not timed | 25969.05 ± 26.2% | 6702.08 ± 3.4% | not timed | not timed | 37566.15 ± 5.7% | | 1.00 | 1.45 | 5.60 |
| imported/rsc/anchored-literal-short-match | 4 | 1279.18 ± 37.2% | not timed | not timed | 948.40 ± 1.2% | 150.02 ± 3.7% | not timed | not timed | 1282.04 ± 8.7% | | 1.00 | 1.35 | 8.53 |
| imported/rsc/anchored-literal-long-match | 4 | 19175.44 ± 10.0% | not timed | not timed | 14335.75 ± 4.9% | 2164.69 ± 7.3% | not timed | not timed | 19346.89 ± 41.4% | | 0.99 | 1.34 | 8.86 |
| imported/rsc/one-pass-short | 17 | 677.66 ± 3.5% | not timed | not timed | 455.61 ± 5.2% | 48.66 ± 9.2% | not timed | not timed | 676.10 ± 1.2% | | 1.00 | 1.49 | 13.93 |
| imported/rsc/one-pass-short-not | 17 | 465.51 ± 2.5% | not timed | not timed | 479.04 ± 1.3% | 46.04 ± 12.6% | not timed | not timed | 472.67 ± 4.6% | | 0.98 | 0.97 | 10.11 |
| imported/rsc/one-pass-long-prefix | 26 | 584.63 ± 3.2% | not timed | not timed | 504.12 ± 1.3% | 179.46 ± 11.5% | not timed | not timed | 563.89 ± 9.3% | | 1.04 | 1.16 | 3.26 |
| imported/rsc/one-pass-long-prefix-not | 26 | 581.77 ± 2.0% | not timed | not timed | 489.42 ± 1.5% | 109.06 ± 12.0% | not timed | not timed | 567.75 ± 5.4% | | 1.02 | 1.19 | 5.33 |
| imported/rsc/long-needle1 | 31 | 86834.95 ± 5.3% | not timed | not timed | 66723.19 ± 1.1% | 5.77 ± 3.2% | not timed | not timed | 87269.63 ± 20.1% | | 1.00 | 1.30 | 15061.80 |
| imported/rsc/long-needle2 | 31 | 86708.47 ± 2.7% | not timed | not timed | 362.41 ± 3.6% | 5.95 ± 2.7% | not timed | not timed | 86959.11 ± 6.2% | | 1.00 | 239.25 | 14574.65 |
| imported/rsc/easy0-32 | 26 | 1861.67 ± 7.5% | not timed | not timed | 2805.49 ± 3.9% | 219.29 ± 12.5% | not timed | not timed | 1902.58 ± 8.4% | | 0.98 | 0.66 | 8.49 |
| imported/rsc/easy0-1k | 26 | 30698.69 ± 2.5% | not timed | not timed | 30258.60 ± 4.3% | 3439.37 ± 11.7% | not timed | not timed | 30572.36 ± 2.3% | | 1.00 | 1.01 | 8.93 |
| imported/rsc/easy0-32k | 26 | 81733.36 ± 3.0% | not timed | not timed | 64150.72 ± 1.9% | 38785.66 ± 21.5% | not timed | not timed | 82710.98 ± 0.8% | | 0.99 | 1.27 | 2.11 |
| imported/rsc/easy0-1mb | 26 | 82446.72 ± 10.2% | not timed | not timed | 67414.72 ± 5.5% | 97548.27 ± 5.2% | not timed | not timed | 84244.86 ± 4.7% | | 0.98 | 1.22 | 0.85 |
| imported/rsc/easy1-32 | 19 | 1340.93 ± 5.3% | not timed | not timed | 1327.05 ± 5.7% | 219.11 ± 11.6% | not timed | not timed | 1377.23 ± 5.2% | | 0.97 | 1.01 | 6.12 |
| imported/rsc/easy1-1k | 19 | 28268.66 ± 1.8% | not timed | not timed | 25946.40 ± 3.5% | 3861.50 ± 10.3% | not timed | not timed | 28400.45 ± 5.1% | | 1.00 | 1.09 | 7.32 |
| imported/rsc/easy1-32k | 19 | 896360.85 ± 3.0% | not timed | not timed | 894161.93 ± 0.3% | 42874.49 ± 25.7% | not timed | not timed | 891869.34 ± 1.8% | | 1.01 | 1.00 | 20.91 |
| imported/rsc/easy1-1mb | 19 | 28608340.84 ± 1.1% | not timed | not timed | 26276368.18 ± 0.6% | 104170.64 ± 8.7% | not timed | not timed | 28666699.54 ± 43.5% | | 1.00 | 1.09 | 274.63 |
| imported/rsc/medium-32 | 27 | 1244.16 ± 1.7% | not timed | not timed | 1105.83 ± 1.6% | 117.13 ± 7.1% | not timed | not timed | 1233.14 ± 1.6% | | 1.01 | 1.13 | 10.62 |
| imported/rsc/medium-1k | 27 | 22175.29 ± 5.7% | not timed | not timed | 20840.89 ± 1.9% | 121.12 ± 1.8% | not timed | not timed | 22238.13 ± 7.0% | | 1.00 | 1.06 | 183.08 |
| imported/rsc/medium-32k | 27 | 691644.73 ± 5.5% | not timed | not timed | 611056.69 ± 0.4% | 82.77 ± 1.9% | not timed | not timed | 692482.22 ± 4.5% | | 1.00 | 1.13 | 8356.12 |
| imported/rsc/medium-1mb | 27 | 22125098.04 ± 0.6% | not timed | not timed | 22113275.28 ± 0.8% | 83.65 ± 1.8% | not timed | not timed | 22194456.84 ± 0.7% | | 1.00 | 1.00 | 264496.07 |
| imported/rsc/hard-32 | 58 | 558.37 ± 7.4% | not timed | not timed | 525.50 ± 5.2% | 75.13 ± 13.0% | not timed | not timed | 573.82 ± 7.1% | | 0.97 | 1.06 | 7.43 |
| imported/rsc/hard-1k | 27 | 19752.29 ± 1.3% | not timed | not timed | 20570.11 ± 1.7% | 63.91 ± 0.5% | not timed | not timed | 20358.09 ± 0.7% | | 0.97 | 0.96 | 309.06 |
| imported/rsc/hard-32k | 27 | 636139.76 ± 23.8% | not timed | not timed | 686857.56 ± 1.3% | 50.95 ± 12.9% | not timed | not timed | 659863.81 ± 0.9% | | 0.96 | 0.93 | 12484.85 |
| imported/rsc/hard-1mb | 51 | 11723166.68 ± 0.8% | not timed | not timed | 9607203.50 ± 0.7% | 50.95 ± 1.4% | not timed | not timed | 11963103.53 ± 1.3% | | 0.98 | 1.22 | 230109.68 |
| imported/rsc/reallyhard0-32 | 58 | 365.50 ± 6.8% | not timed | not timed | 342.09 ± 6.5% | 74.01 ± 16.9% | not timed | not timed | 363.82 ± 1.5% | | 1.00 | 1.07 | 4.94 |
| imported/rsc/reallyhard0-1k | 27 | 735.23 ± 1.2% | not timed | not timed | 736.00 ± 1.1% | 64.04 ± 1.8% | not timed | not timed | 736.98 ± 0.9% | | 1.00 | 1.00 | 11.48 |
| imported/rsc/reallyhard0-32k | 27 | 751.07 ± 0.1% | not timed | not timed | 751.21 ± 0.6% | 51.37 ± 32.9% | not timed | not timed | 750.15 ± 0.4% | | 1.00 | 1.00 | 14.62 |
| imported/rsc/reallyhard0-1mb | 51 | 746.89 ± 2.2% | not timed | not timed | 746.05 ± 26.9% | 50.63 ± 15.2% | not timed | not timed | 749.61 ± 5.9% | | 1.00 | 1.00 | 14.75 |
| imported/rsc/reallyreallyhard0-32 | 47 | 455.50 ± 1.7% | not timed | not timed | 273.13 ± 3.0% | 95.90 ± 7.0% | not timed | not timed | 458.27 ± 1.6% | | 0.99 | 1.67 | 4.75 |
| imported/rsc/reallyreallyhard0-1k | 16 | 11929.15 ± 4.2% | not timed | not timed | 10415.15 ± 3.7% | 51.29 ± 4.3% | not timed | not timed | 11920.16 ± 5.2% | | 1.00 | 1.15 | 232.57 |
| imported/rsc/reallyreallyhard0-32k | 16 | 78321.29 ± 0.9% | not timed | not timed | 58807.97 ± 2.4% | 40.97 ± 3.5% | not timed | not timed | 78391.96 ± 4.2% | | 1.00 | 1.33 | 1911.50 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 99615.80 ± 1.5% | not timed | not timed | 70151.26 ± 5.5% | 41.96 ± 1.1% | not timed | not timed | 100187.85 ± 1.8% | | 0.99 | 1.42 | 2374.17 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 432.10 ± 6.0% | not timed | not timed | 283.05 ± 9.5% | 98.74 ± 8.2% | not timed | not timed | 438.83 ± 2.3% | | 0.98 | 1.53 | 4.38 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 9654.85 ± 5.8% | not timed | not timed | 10595.46 ± 5.3% | 52.91 ± 5.9% | not timed | not timed | 9563.19 ± 5.3% | | 1.01 | 0.91 | 182.47 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 74255.97 ± 5.4% | not timed | not timed | 59407.20 ± 5.0% | 40.44 ± 6.9% | not timed | not timed | 74509.41 ± 5.1% | | 1.00 | 1.25 | 1836.18 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 88651.51 ± 1.3% | not timed | not timed | 70180.83 ± 0.5% | 42.02 ± 1.9% | not timed | not timed | 88838.90 ± 4.0% | | 1.00 | 1.26 | 2109.95 |
| imported/sherlock/name-sherlock | 776 | 63253.76 ± 7.4% | not timed | not timed | 50647.36 ± 3.7% | 16782.42 ± 21.1% | not timed | not timed | 63176.48 ± 4.1% | | 1.00 | 1.25 | 3.77 |
| imported/sherlock/name-holmes | 2766 | 36604.77 ± 4.5% | not timed | not timed | 35893.77 ± 0.9% | 5337.86 ± 7.9% | not timed | not timed | 36817.79 ± 1.9% | | 0.99 | 1.02 | 6.86 |
| imported/sherlock/name-sherlock-holmes | 1365 | 65832.82 ± 9.9% | not timed | not timed | 52465.10 ± 6.7% | 14046.80 ± 15.8% | not timed | not timed | 66400.09 ± 11.1% | | 0.99 | 1.25 | 4.69 |
| imported/sherlock/name-sherlock-casei | 816 | 69536.07 ± 7.9% | not timed | not timed | 15226.54 ± 3.7% | 53.69 ± 20.6% | not timed | not timed | 69054.02 ± 4.3% | | 1.01 | 4.57 | 1295.13 |
| imported/sherlock/name-holmes-casei | 2802 | 32567.51 ± 2.1% | not timed | not timed | 9417.69 ± 9.9% | 67.21 ± 21.2% | not timed | not timed | 33048.78 ± 3.7% | | 0.99 | 3.46 | 484.56 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 55383.25 ± 5.6% | not timed | not timed | 14608.41 ± 1.3% | 54.57 ± 3.0% | not timed | not timed | 55518.89 ± 25.6% | | 1.00 | 3.79 | 1014.85 |
| imported/sherlock/name-whitespace | 1461 | 40150.76 ± 12.8% | not timed | not timed | 38785.03 ± 12.4% | 12114.09 ± 46.1% | not timed | not timed | 40352.43 ± 40.9% | | 1.00 | 1.04 | 3.31 |
| imported/sherlock/name-alt1 | 1142 | 45809.97 ± 1.4% | not timed | not timed | 45044.85 ± 2.2% | 6854.11 ± 41.0% | not timed | not timed | 45770.39 ± 10.6% | | 1.00 | 1.02 | 6.68 |
| imported/sherlock/name-alt2 | 3542 | 29658.94 ± 1.7% | not timed | not timed | 12695.82 ± 1.0% | 57.22 ± 5.1% | not timed | not timed | 29634.61 ± 3.6% | | 1.00 | 2.34 | 518.33 |
| imported/sherlock/name-alt3 | 4507 | 18127.15 ± 1.4% | not timed | not timed | 11836.43 ± 0.4% | 17.73 ± 1.6% | not timed | not timed | 18155.13 ± 1.1% | | 1.00 | 1.53 | 1022.27 |
| imported/sherlock/name-alt3-casei | 4593 | 2636.16 ± 7.6% | not timed | not timed | 1754.16 ± 0.6% | 11.17 ± 1.5% | not timed | not timed | 2629.55 ± 7.5% | | 1.00 | 1.50 | 235.98 |
| imported/sherlock/name-alt4 | 3686 | 13341.80 ± 6.1% | not timed | not timed | 9851.42 ± 5.6% | 56.68 ± 5.5% | not timed | not timed | 13322.74 ± 6.0% | | 1.00 | 1.35 | 235.40 |
| imported/sherlock/name-alt4-casei | 4254 | 7479.79 ± 2.4% | not timed | not timed | 5400.28 ± 5.0% | 34.00 ± 2.8% | not timed | not timed | 7503.88 ± 0.8% | | 1.00 | 1.39 | 220.02 |
| imported/sherlock/name-alt5 | 4028 | 23555.65 ± 7.7% | not timed | not timed | 12329.71 ± 3.7% | 40.09 ± 3.2% | not timed | not timed | 23532.29 ± 3.0% | | 1.00 | 1.91 | 587.63 |
| imported/sherlock/name-alt5-casei | 4104 | 9920.88 ± 1.7% | not timed | not timed | 3984.97 ± 0.5% | 24.49 ± 2.0% | not timed | not timed | 9922.52 ± 1.8% | | 1.00 | 2.49 | 405.08 |
| imported/sherlock/no-match-uncommon | 0 | 95305.71 ± 0.4% | not timed | not timed | 94740.54 ± 6.4% | 83825.54 ± 2.1% | not timed | not timed | 95202.83 ± 3.5% | | 1.00 | 1.01 | 1.14 |
| imported/sherlock/no-match-common | 0 | 92945.22 ± 0.4% | not timed | not timed | 95188.72 ± 1.0% | 2493.25 ± 3.2% | not timed | not timed | 92958.53 ± 0.8% | | 1.00 | 0.98 | 37.28 |
| imported/sherlock/no-match-really-common | 0 | 64138.16 ± 1.8% | not timed | not timed | 70309.54 ± 2.2% | 2495.13 ± 0.3% | not timed | not timed | 64616.30 ± 0.2% | | 0.99 | 0.91 | 25.71 |
| imported/sherlock/the-lower | 21654 | 4167.04 ± 0.8% | not timed | not timed | 4143.52 ± 2.4% | 385.66 ± 8.6% | not timed | not timed | 4140.32 ± 5.0% | | 1.01 | 1.01 | 10.80 |
| imported/sherlock/the-upper | 2223 | 27202.87 ± 5.0% | not timed | not timed | 35197.04 ± 5.4% | 4464.99 ± 18.8% | not timed | not timed | 27283.09 ± 4.9% | | 1.00 | 0.77 | 6.09 |
| imported/sherlock/the-casei | 23961 | 3772.31 ± 3.6% | not timed | not timed | 1790.60 ± 0.3% | 61.31 ± 26.2% | not timed | not timed | 3788.67 ± 2.8% | | 1.00 | 2.11 | 61.52 |
| imported/sherlock/everything-greedy | 581881 | 387.36 ± 2.2% | not timed | not timed | 231.22 ± 1.9% | 44.81 ± 17.3% | not timed | not timed | 393.27 ± 0.5% | | 0.98 | 1.68 | 8.64 |
| imported/sherlock/everything-greedy-nl | 594933 | 591.62 ± 6.1% | not timed | not timed | 309.16 ± 2.5% | 56.27 ± 0.6% | not timed | not timed | 591.82 ± 3.4% | | 1.00 | 1.91 | 10.51 |
| imported/sherlock/letters | 447175 | 103.07 ± 2.3% | not timed | not timed | 46.00 ± 0.4% | 10.18 ± 20.8% | not timed | not timed | 102.54 ± 2.2% | | 1.01 | 2.24 | 10.13 |
| imported/sherlock/letters-upper | 14180 | 568.72 ± 5.8% | not timed | not timed | 464.15 ± 5.5% | 42.52 ± 31.8% | not timed | not timed | 555.53 ± 5.4% | | 1.02 | 1.23 | 13.38 |
| imported/sherlock/letters-lower | 432995 | 102.79 ± 5.0% | not timed | not timed | 47.69 ± 2.0% | 8.86 ± 24.9% | not timed | not timed | 103.72 ± 0.9% | | 0.99 | 2.16 | 11.60 |
| imported/sherlock/words | 447639 | 164.44 ± 1.9% | not timed | not timed | 108.39 ± 0.2% | 21.02 ± 6.1% | not timed | not timed | 165.49 ± 0.8% | | 0.99 | 1.52 | 7.82 |
| imported/sherlock/before-holmes | 4073 | 20365.21 ± 0.5% | not timed | not timed | 17207.63 ± 0.9% | 39.20 ± 0.6% | not timed | not timed | 20370.62 ± 0.5% | | 1.00 | 1.18 | 519.53 |
| imported/sherlock/before-after-holmes | 2593 | 20139.26 ± 2.2% | not timed | not timed | 20326.38 ± 1.3% | 39.15 ± 1.8% | not timed | not timed | 20445.69 ± 2.3% | | 0.99 | 0.99 | 514.43 |
| imported/sherlock/holmes-cochar-watson | 150 | 12720.82 ± 4.9% | not timed | not timed | 10221.78 ± 2.1% | 55.38 ± 1.0% | not timed | not timed | 12734.62 ± 0.4% | | 1.00 | 1.24 | 229.69 |
| imported/sherlock/holmes-coword-watson | 14309 | 1590.30 ± 0.3% | not timed | not timed | 1563.98 ± 1.4% | 11.77 ± 1.3% | not timed | not timed | 1593.83 ± 0.3% | | 1.00 | 1.02 | 135.14 |
| imported/sherlock/quotes | 14437 | 1762.10 ± 1.4% | not timed | not timed | 3027.05 ± 6.0% | 56.12 ± 2.0% | not timed | not timed | 1760.20 ± 0.5% | | 1.00 | 0.58 | 31.40 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 748.80 ± 1.0% | not timed | not timed | 42383.44 ± 37.6% | 63.23 ± 24.1% | not timed | not timed | 746.17 ± 6.5% | | 1.00 | 0.0177 | 11.84 |
| imported/sherlock/word-ending-n | 35297 | 587.91 ± 1.9% | not timed | not timed | 508.07 ± 1.0% | 39.24 ± 38.1% | not timed | not timed | 588.56 ± 0.9% | | 1.00 | 1.16 | 14.98 |
| imported/sherlock/repeated-class-negation | 2130 | 25649.10 ± 3.2% | not timed | not timed | 24136.60 ± 0.9% | 16.26 ± 8.8% | not timed | not timed | 25570.20 ± 2.7% | | 1.00 | 1.06 | 1577.15 |
| imported/sherlock/ing-suffix | 20547 | 722.07 ± 4.3% | not timed | not timed | 637.89 ± 0.7% | 46.08 ± 2.9% | not timed | not timed | 728.24 ± 5.3% | | 0.99 | 1.13 | 15.67 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 768.05 ± 1.1% | not timed | not timed | 3761.21 ± 1.1% | 33.56 ± 2.0% | not timed | not timed | 764.20 ± 0.2% | | 1.01 | 0.20 | 22.89 |
| opt/accelerate/whole-line | 239963 | 696.88 ± 5.9% | not timed | not timed | 528.00 ± 4.5% | 132.75 ± 23.0% | not timed | not timed | 691.17 ± 4.9% | | 1.01 | 1.32 | 5.25 |
| opt/accelerate/non-dna | 16745 | 617.34 ± 0.4% | not timed | not timed | 588.19 ± 3.3% | 47.59 ± 27.5% | not timed | not timed | 618.51 ± 11.5% | | 1.00 | 1.05 | 12.97 |
| opt/backtrack/words-english | 40536 | 194.46 ± 1.4% | not timed | not timed | 147.13 ± 0.5% | 32.31 ± 8.5% | not timed | not timed | 191.86 ± 2.1% | | 1.01 | 1.32 | 6.02 |
| opt/fixed-length/too-small-ascii | 0 | 566.12 ± 1.2% | not timed | not timed | 1173.99 ± 4.4% | 174.35 ± 2.3% | not timed | not timed | 582.81 ± 0.8% | | 0.97 | 0.48 | 3.25 |
| opt/fixed-length/too-big-ascii | 0 | 6671.90 ± 1.9% | not timed | not timed | 8971.64 ± 1.4% | 222.34 ± 2.8% | not timed | not timed | 6708.04 ± 1.7% | | 0.99 | 0.74 | 30.01 |
| opt/fixed-length/go33484-1 | 0 | 1285794.69 ± 5.0% | not timed | not timed | 1784013.42 ± 1.3% | 127401.71 ± 1.8% | not timed | not timed | 1300208.22 ± 2.5% | | 0.99 | 0.72 | 10.09 |
| opt/fixed-length/go33484-2 | 0 | 1292490.06 ± 3.3% | not timed | not timed | 1758126.21 ± 2.9% | 40018.18 ± 14.9% | not timed | not timed | 1271636.50 ± 8.1% | | 1.02 | 0.74 | 32.30 |
| opt/fixed-length/go33484-3 | 0 | 3153.28 ± 0.8% | not timed | not timed | 178469.77 ± 1.7% | 1369.45 ± 1.3% | not timed | not timed | 3137.10 ± 0.5% | | 1.01 | 0.0177 | 2.30 |
| opt/literal-alt/one-pattern | 1 | 744.39 ± 3.7% | not timed | not timed | 736.06 ± 0.2% | 0.64 ± 5.1% | not timed | not timed | 742.40 ± 1.5% | | 1.00 | 1.01 | 1165.68 |
| opt/onepass/fn-predicate | 916 | 626.43 ± 1.0% | not timed | not timed | 536.52 ± 2.0% | 294.62 ± 18.3% | not timed | not timed | 616.55 ± 0.9% | | 1.02 | 1.17 | 2.13 |
| opt/onepass/first-three-words-english | 35128 | 250.86 ± 4.4% | not timed | not timed | 318.08 ± 1.4% | 114.06 ± 9.9% | not timed | not timed | 252.39 ± 3.1% | | 0.99 | 0.79 | 2.20 |
| opt/prefilter/literal-english | 1 | 93716.13 ± 3.1% | not timed | not timed | 71028.37 ± 0.8% | 36944.50 ± 0.6% | not timed | not timed | 93753.21 ± 0.4% | | 1.00 | 1.32 | 2.54 |
| opt/prefilter/literal-casei-english | 1 | 71769.18 ± 0.8% | not timed | not timed | 19128.87 ± 0.2% | 55.15 ± 1.5% | not timed | not timed | 71870.14 ± 5.3% | | 1.00 | 3.75 | 1301.37 |
| opt/prefilter/literal-russian | 1 | 92688.49 ± 0.3% | not timed | not timed | 70504.67 ± 1.8% | 4341.42 ± 1.3% | not timed | not timed | 92881.23 ± 0.8% | | 1.00 | 1.31 | 21.35 |
| opt/prefilter/literal-casei-russian | 1 | 37739.43 ± 5.0% | not timed | not timed | 13572.11 ± 4.9% | 57.77 ± 5.3% | not timed | not timed | 37627.27 ± 3.7% | | 1.00 | 2.78 | 653.23 |
| opt/prefilter/rust-functions | 948 | 20606.61 ± 16.7% | not timed | not timed | 17042.27 ± 0.8% | 2336.03 ± 52.6% | not timed | not timed | 20903.24 ± 16.0% | | 0.99 | 1.21 | 8.82 |
| opt/reverse-anchored/word-end | 1 | 57502760.51 ± 2.5% | not timed | not timed | 39157791.71 ± 3.4% | 83.94 ± 2.8% | not timed | not timed | 57506771.90 ± 6.2% | | 1.00 | 1.47 | 685024.28 |
| opt/reverse-inner/holmes | 2593 | 20385.26 ± 0.7% | not timed | not timed | 19991.03 ± 1.3% | 36.58 ± 3.4% | not timed | not timed | 20417.24 ± 3.7% | | 1.00 | 1.02 | 557.28 |
| opt/reverse-inner/email | 47 | 103341.28 ± 0.9% | not timed | not timed | 106110.12 ± 0.5% | 48.47 ± 1.4% | not timed | not timed | 103185.58 ± 5.4% | | 1.00 | 0.97 | 2131.90 |
| opt/reverse-inner/factored-prefix | 3542 | 738.96 ± 0.7% | not timed | not timed | 728.50 ± 0.2% | 19.95 ± 0.5% | not timed | not timed | 739.59 ± 0.6% | | 1.00 | 1.01 | 37.04 |
| opt/reverse-inner/no-quadratic-backward | 0 | 7101.30 ± 0.9% | not timed | not timed | 750.35 ± 0.6% | 123.92 ± 3.3% | not timed | not timed | 7114.10 ± 0.5% | | 1.00 | 9.46 | 57.30 |
| opt/reverse-inner/no-quadratic-forward | 0 | 867.65 ± 4.0% | not timed | not timed | 345.42 ± 0.8% | 40.28 ± 3.7% | not timed | not timed | 872.21 ± 1.7% | | 0.99 | 2.51 | 21.54 |
| opt/reverse-suffix/holmes | 4073 | 20282.81 ± 5.6% | not timed | not timed | 16893.30 ± 16.0% | 35.15 ± 11.4% | not timed | not timed | 20352.75 ± 3.2% | | 1.00 | 1.20 | 577.11 |
| opt/reverse-suffix/no-quadratic | 0 | 7109.66 ± 2.7% | not timed | not timed | 750.77 ± 2.2% | 126.93 ± 1.2% | not timed | not timed | 7127.95 ± 1.1% | | 1.00 | 9.47 | 56.01 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 224.96 ± 9.1% | not timed | not timed | 273.47 ± 1.2% | 24.05 ± 16.0% | not timed | not timed | 226.94 ± 9.2% | | 0.99 | 0.82 | 9.35 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 224.75 ± 1.7% | not timed | not timed | 268.93 ± 1.4% | 23.60 ± 15.5% | not timed | not timed | 225.74 ± 1.2% | | 1.00 | 0.84 | 9.52 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.49 ± 1.4% | not timed | not timed | 0.85 ± 3.2% | 177.84 ± 7.4% | not timed | not timed | 0.50 ± 4.9% | | 0.99 | 0.58 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 395.22 ± 4.4% | not timed | not timed | 381.62 ± 4.4% | 164.91 ± 12.6% | not timed | not timed | 397.74 ± 4.2% | | 0.99 | 1.04 | 2.40 |
| reported/i13-subset-regex/original-ascii | 4094 | 15710.08 ± 1.7% | not timed | not timed | 5542.29 ± 1.6% | 16.12 ± 1.4% | not timed | not timed | 15733.18 ± 1.4% | | 1.00 | 2.83 | 974.40 |
| reported/i13-subset-regex/original-unicode | 4094 | 15680.84 ± 4.5% | not timed | not timed | 290.89 ± 2.8% | 16.16 ± 1.5% | not timed | not timed | 15672.35 ± 1.5% | | 1.00 | 53.91 | 970.64 |
| reported/i13-subset-regex/big-ascii | 1955 | 14529.20 ± 1.4% | not timed | not timed | 78.55 ± 2.7% | 13.90 ± 2.5% | not timed | not timed | 14509.38 ± 0.9% | | 1.00 | 184.96 | 1045.02 |
| reported/i13-subset-regex/big-unicode | 1955 | 14533.71 ± 3.6% | not timed | not timed | 14.12 ± 56.7% | 13.97 ± 2.9% | not timed | not timed | 14551.31 ± 1.3% | | 1.00 | 1029.51 | 1040.09 |
| reported/i13-subset-regex/huge-ascii | 55 | 13296.69 ± 2.0% | not timed | not timed | 13.74 ± 6.5% | 12.84 ± 1.7% | not timed | not timed | 13262.30 ± 3.9% | | 1.00 | 967.70 | 1035.39 |
| reported/i13-subset-regex/huge-unicode | 55 | 13272.12 ± 1.1% | not timed | not timed | 13.86 ± 1.9% | 12.99 ± 3.7% | not timed | not timed | 13274.26 ± 0.8% | | 1.00 | 957.54 | 1021.36 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.94 ± 3.9% | not timed | not timed | 13.83 ± 3.8% | 12.70 ± 4.3% | not timed | not timed | 5.96 ± 2.9% | | 1.00 | 0.43 | 0.47 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.49 ± 5.2% | not timed | not timed | 13.55 ± 3.8% | 12.61 ± 6.5% | not timed | not timed | 7.44 ± 4.1% | | 1.01 | 0.55 | 0.59 |
| reported/i787-keywords/ascii | 5674 | 674.10 ± 2.3% | not timed | not timed | 211.15 ± 1.6% | 10.14 ± 2.2% | not timed | not timed | 682.35 ± 1.1% | | 0.99 | 3.19 | 66.50 |
| reported/i787-keywords/opt-ascii | 5674 | 680.20 ± 0.6% | not timed | not timed | 340.90 ± 5.5% | 16.51 ± 31.8% | not timed | not timed | 682.39 ± 2.0% | | 1.00 | 2.00 | 41.20 |
| slow/quadratic-regex-1x | 100 | 10.92 ± 7.5% | not timed | not timed | 8.02 ± 5.1% | 0.08 ± 1.3% | not timed | not timed | 11.14 ± 5.9% | | 0.98 | 1.36 | 134.58 |
| slow/quadratic-regex-2x | 199 | 4.71 ± 1.1% | not timed | not timed | 4.11 ± 5.9% | 0.02 ± 3.3% | not timed | not timed | 4.76 ± 0.5% | | 0.99 | 1.15 | 223.22 |
| slow/quadratic-haystack-1x | 100 | 41.35 ± 10.6% | not timed | not timed | 17.85 ± 0.2% | 1.53 ± 7.3% | not timed | not timed | 39.73 ± 10.4% | | 1.04 | 2.32 | 26.97 |
| slow/quadratic-haystack-2x | 200 | 31.75 ± 11.6% | not timed | not timed | 7.54 ± 3.6% | 0.81 ± 7.2% | not timed | not timed | 31.21 ± 8.6% | | 1.02 | 4.21 | 39.11 |
| unicode/codepoints/any-one | 1112064 | 534.49 ± 2.2% | not timed | not timed | 372.41 ± 3.8% | 27.98 ± 16.4% | not timed | not timed | 526.48 ± 4.3% | | 1.02 | 1.44 | 19.10 |
| unicode/codepoints/any-all | 4382592 | 350.08 ± 6.2% | not timed | not timed | 347.65 ± 0.3% | 201.71 ± 1.3% | not timed | not timed | 356.19 ± 2.7% | | 0.98 | 1.01 | 1.74 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 12.26 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 750.40 ± 0.4% | not timed | not timed | 749.63 ± 0.3% | 234.45 ± 0.8% | not timed | not timed | 751.16 ± 0.1% | | 1.00 | 1.00 | 3.20 |
| unicode/overlapping-words/ascii | 6156 | 44.49 ± 9.5% | not timed | not timed | 58.35 ± 4.3% | 6.41 ± 4.4% | not timed | not timed | 45.16 ± 4.2% | | 0.99 | 0.76 | 6.94 |
| unicode/overlapping-words/english | 6156 | 2.15 ± 4.0% | not timed | not timed | 5.36 ± 4.4% | 3.92 ± 5.2% | not timed | not timed | 2.18 ± 13.1% | | 0.99 | 0.40 | 0.55 |
| unicode/overlapping-words/russian | 5710 | 2.00 ± 4.1% | not timed | not timed | 5.15 ± 4.7% | 9.49 ± 7.5% | not timed | not timed | 1.94 ± 8.2% | | 1.03 | 0.39 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 178.70 ± 4.5% | not timed | not timed | 105.13 ± 3.9% | 19.12 ± 7.8% | not timed | not timed | 179.06 ± 0.7% | | 1.00 | 1.70 | 9.35 |
| unicode/word/boundary-long-english | 3466 | 752.54 ± 0.4% | not timed | not timed | 734.66 ± 2.3% | 50.95 ± 3.2% | not timed | not timed | 752.04 ± 1.1% | | 1.00 | 1.02 | 14.77 |
| unicode/word/around-holmes-english | 27 | 81798.21 ± 4.4% | not timed | not timed | 65811.01 ± 44.4% | 35.43 ± 4.0% | not timed | not timed | 82271.36 ± 4.6% | | 0.99 | 1.24 | 2308.65 |
| wild/bibleref/long | 874 | 701.40 ± 1.7% | not timed | not timed | 716.37 ± 4.5% | 11.19 ± 12.1% | not timed | not timed | 707.03 ± 0.5% | | 0.99 | 0.98 | 62.66 |
| wild/bibleref/short | 30 | 34.44 ± 6.2% | not timed | not timed | 47.03 ± 4.4% | 22.99 ± 10.6% | not timed | not timed | 34.87 ± 6.4% | | 0.99 | 0.73 | 1.50 |
| wild/bibleref/line | 874 | 714.61 ± 6.3% | not timed | not timed | 348.92 ± 0.6% | 13.62 ± 5.9% | not timed | not timed | 719.70 ± 5.2% | | 0.99 | 2.05 | 52.46 |
| wild/caddy/caddy | 6 | 625.01 ± 7.5% | not timed | not timed | 367.05 ± 3.7% | 103.87 ± 13.6% | not timed | not timed | 648.30 ± 7.4% | | 0.96 | 1.70 | 6.02 |
| wild/dot-star-capture/rust-src-tools | 6 | 2149.22 ± 4.2% | not timed | not timed | 491.65 ± 1.2% | 23.11 ± 3.1% | not timed | not timed | 2152.30 ± 3.6% | | 1.00 | 4.37 | 92.99 |
| wild/ruff/noqa | 84 | 653.75 ± 6.8% | not timed | not timed | 675.69 ± 5.4% | 31.26 ± 4.8% | not timed | not timed | 658.34 ± 15.0% | | 0.99 | 0.97 | 20.91 |
| wild/ruff/unnecessary-coding-comment | 16 | 1399.10 ± 3.8% | not timed | not timed | 929.49 ± 4.7% | 203.71 ± 16.0% | not timed | not timed | 1401.07 ± 0.9% | | 1.00 | 1.51 | 6.87 |
| wild/ruff/string-quote-prefix | 2972 | 2127.16 ± 3.1% | not timed | not timed | 708.27 ± 0.4% | 453.65 ± 27.5% | not timed | not timed | 2126.83 ± 1.0% | | 1.00 | 3.00 | 4.69 |
| wild/ruff/space-around-operator | 1224378 | 321.57 ± 5.2% | not timed | not timed | 297.98 ± 4.6% | 27.70 ± 3.8% | not timed | not timed | 314.48 ± 11.7% | | 1.02 | 1.08 | 11.61 |
| wild/ruff/shebang | 282 | 1405.15 ± 3.5% | not timed | not timed | 528.15 ± 15.0% | 162.91 ± 11.0% | not timed | not timed | 1429.42 ± 3.1% | | 0.98 | 2.66 | 8.63 |
| wild/rustsec-cargo-audit/original-unix | 471 | 30454.43 ± 6.9% | not timed | not timed | 33581.15 ± 3.2% | 12744.72 ± 3.3% | not timed | not timed | 29904.52 ± 3.6% | | 1.02 | 0.91 | 2.39 |
| wild/rustsec-cargo-audit/original-windows | 462 | 28536.53 ± 5.2% | not timed | not timed | 31713.05 ± 10.5% | 11766.57 ± 0.8% | not timed | not timed | 28607.54 ± 2.6% | | 1.00 | 0.90 | 2.43 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 31608.80 ± 1.8% | not timed | not timed | 33382.81 ± 0.8% | 12205.42 ± 1.2% | not timed | not timed | 31439.41 ± 0.7% | | 1.01 | 0.95 | 2.59 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 26645.16 ± 4.9% | not timed | not timed | 33372.88 ± 1.8% | 12218.92 ± 30.0% | not timed | not timed | 27062.85 ± 1.3% | | 0.98 | 0.80 | 2.18 |
| wild/url/search | 234965 | 179.00 ± 9.3% | not timed | not timed | 86.47 ± 5.7% | 3.67 ± 5.1% | not timed | not timed | 178.23 ± 8.3% | | 1.00 | 2.07 | 48.75 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 0.9% | not timed | not timed | 0.01 ± 3.9% | 0.01 ± 16.8% | not timed | not timed | 0.04 ± 16.7% | | 1.00 | 2.94 | 4.29 |
| dictionary/compile/english-15 | 1 | 0.47 ± 5.1% | not timed | not timed | 0.12 ± 1.3% | 0.16 ± 9.3% | not timed | not timed | 0.48 ± 0.6% | | 0.99 | 4.09 | 2.92 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.45 ± 3.3% | not timed | not timed | 0.03 ± 1.0% | 51.76 ± 1.7% | not timed | not timed | 0.45 ± 4.8% | | 0.98 | 12.73 | 0.0086 |
| reported/i1095-word-repetition/ascii-compile | 1 | 62.39 ± 9.2% | not timed | not timed | 19.98 ± 1.1% | 85.62 ± 10.5% | not timed | not timed | 63.69 ± 2.2% | | 0.98 | 3.12 | 0.73 |
| reported/i787-keywords/compile | 1 | 55.34 ± 5.7% | not timed | not timed | 3.27 ± 1.1% | 26.32 ± 27.8% | not timed | not timed | 56.36 ± 2.3% | | 0.98 | 16.92 | 2.10 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 599.93 ± 12.5% | not timed | not timed | 207.90 ± 1.6% | 808.97 ± 42.4% | not timed | not timed | 598.22 ± 12.0% | | 1.00 | 2.89 | 0.74 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 78.95 ± 4.0% | not timed | not timed | 7.50 ± 1.4% | 65.81 ± 6.3% | not timed | not timed | 78.84 ± 6.7% | | 1.00 | 10.53 | 1.20 |
| unicode/compile/one-letter | 53 | 10.56 ± 28.1% | not timed | not timed | 8.00 ± 16.9% | 88.28 ± 20.6% | not timed | not timed | 10.29 ± 7.9% | | 1.03 | 1.32 | 0.12 |
| unicode/compile/fifty-letters | 1 | 1.88 ± 11.3% | not timed | not timed | 0.17 ± 31.5% | 88.37 ± 24.9% | not timed | not timed | 1.81 ± 68.9% | | 1.04 | 10.88 | 0.0212 |
| unicode/compile/fifty-letters-ascii | 1 | 314.73 ± 12.0% | not timed | not timed | 88.77 ± 10.9% | 282.32 ± 12.9% | not timed | not timed | 320.29 ± 4.4% | | 0.98 | 3.55 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 698.93 ± 17.9% | not timed | not timed | 64.44 ± 5.2% | 1017.76 ± 16.2% | not timed | not timed | 699.47 ± 6.0% | | 1.00 | 10.85 | 0.69 |
| unicode/compile/match-every-line-ascii | 4 | 1115.23 ± 11.3% | not timed | not timed | 229.68 ± 5.4% | 1032.26 ± 18.1% | not timed | not timed | 1122.45 ± 8.0% | | 0.99 | 4.86 | 1.08 |
| unicode/compile/negated-class-matches-codepoint | 1 | 577.78 ± 12.9% | not timed | not timed | 69.09 ± 2.2% | 1994.98 ± 10.7% | not timed | not timed | 580.35 ± 17.4% | | 1.00 | 8.36 | 0.29 |
| wild/bibleref/compile | 3 | 9.58 ± 1.7% | not timed | not timed | 3.38 ± 2.1% | 47.19 ± 15.7% | not timed | not timed | 9.55 ± 8.0% | | 1.00 | 2.84 | 0.20 |
| wild/url/compile | 1 | 1.01 ± 14.5% | not timed | not timed | 0.23 ± 4.1% | 0.63 ± 8.5% | not timed | not timed | 1.01 ± 9.4% | | 1.00 | 4.38 | 1.59 |

