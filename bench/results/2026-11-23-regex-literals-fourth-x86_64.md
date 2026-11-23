# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243471575 |
| Date | 2026-11-23 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 36364.64 ± 1.1% | 4106.59 ± 0.3% | 36.26 ± 3.1% | 32695.65 ± 0.4% | 12654.73 ± 2.4% | 14.81 ± 0.7% | 112.99 ± 1.6% | 36332.44 ± 0.5% | 8.86 | 1.00 | 1.11 | 2.87 |
| literal: a word that is not there | 0 | 42356.01 ± 1.7% | 4036.82 ± 0.3% | 36.55 ± 2.4% | 36220.88 ± 0.4% | 40478.90 ± 0.3% | 14.32 ± 0.1% | 103.53 ± 0.6% | 42352.02 ± 0.4% | 10.49 | 1.00 | 1.17 | 1.05 |
| literal: one of four words | 661 | 13632.40 ± 1.2% | 1946.13 ± 1.4% | 19.08 ± 0.8% | 9692.36 ± 0.7% | 29.01 ± 0.6% | 4.33 ± 0.5% | 8.55 ± 2.1% | 13435.72 ± 0.9% | 7.00 | 1.01 | 1.41 | 469.90 |
| literal: a word in any case | 217 | 30507.40 ± 1.5% | 2074.43 ± 0.4% | 25.30 ± 1.6% | 10003.00 ± 0.3% | 57.96 ± 19.1% | refused | differs | 30435.14 ± 0.4% | 14.71 | 1.00 | 3.05 | 526.37 |
| literal: an href attribute | 33 | 29941.96 ± 0.4% | 645.82 ± 0.4% | 31.91 ± 1.0% | 29218.22 ± 2.1% | 2596.95 ± 0.9% | 10.54 ± 0.4% | 99.33 ± 0.5% | 29830.56 ± 0.5% | 46.36 | 1.00 | 1.02 | 11.53 |
| literal: a word, second text | 123 | 35357.28 ± 0.6% | 3088.93 ± 1.2% | 35.21 ± 3.8% | 31141.54 ± 0.7% | 8956.04 ± 6.0% | 19.14 ± 0.8% | 98.61 ± 1.0% | 35276.34 ± 2.0% | 11.45 | 1.00 | 1.14 | 3.95 |
| class: two capitalized words | 1331 | 974.50 ± 2.9% | 632.64 ± 0.5% | 32.41 ± 0.9% | 611.72 ± 0.4% | 48.69 ± 0.5% | 12.56 ± 0.8% | 82.61 ± 6.0% | 977.02 ± 0.3% | 1.54 | 1.00 | 1.59 | 20.02 |
| class: a word that ends in ing | 3399 | 601.57 ± 0.2% | 600.52 ± 0.3% | 20.53 ± 1.8% | 575.08 ± 0.5% | 35.38 ± 3.7% | 7.14 ± 0.2% | 22.49 ± 0.6% | 600.46 ± 0.3% | 1.00 | 1.00 | 1.05 | 17.00 |
| class: a word in capitals | 2332 | 1335.80 ± 0.5% | 638.69 ± 0.2% | 34.65 ± 1.5% | 603.34 ± 0.3% | 51.90 ± 1.2% | 15.09 ± 0.2% | 101.88 ± 1.4% | 1332.04 ± 0.4% | 2.09 | 1.00 | 2.21 | 25.74 |
| class: a number | 8288 | 2036.61 ± 0.3% | 845.24 ± 0.2% | 34.71 ± 1.4% | 2137.97 ± 0.2% | 54.19 ± 13.8% | 0.42 ± 0.3% | 76.58 ± 0.6% | 2035.03 ± 0.4% | 2.41 | 1.00 | 0.95 | 37.58 |
| class: two capitalized words, second text | 5359 | 533.60 ± 0.4% | 539.70 ± 0.9% | 28.83 ± 1.1% | 506.36 ± 0.5% | 42.15 ± 12.5% | 16.39 ± 0.3% | 75.56 ± 0.3% | 532.51 ± 0.3% | 0.99 | 1.00 | 1.05 | 12.66 |
| other: a word between two words | 6104 | 828.68 ± 1.1% | 611.06 ± 0.1% | 28.52 ± 1.2% | 876.68 ± 0.4% | 127.85 ± 8.6% | 9.62 ± 0.2% | 87.28 ± 0.5% | 832.09 ± 0.2% | 1.36 | 1.00 | 0.95 | 6.48 |
| other: a number before a unit, second text | 1481 | 8751.06 ± 3.0% | 1149.72 ± 0.4% | 32.61 ± 2.3% | 9363.21 ± 0.5% | 48.82 ± 7.9% | 17.20 ± 0.2% | 80.37 ± 0.5% | 8564.28 ± 0.4% | 7.61 | 1.02 | 0.93 | 179.26 |
| other: a heading's start tag | 110 | 21389.19 ± 0.3% | 780.31 ± 0.1% | 34.99 ± 2.6% | 2701.83 ± 0.3% | 1911.68 ± 8.0% | 13.17 ± 0.4% | 117.59 ± 1.7% | 21381.46 ± 0.4% | 27.41 | 1.00 | 7.92 | 11.19 |
| other: a whole word | 217 | 26504.32 ± 2.1% | 639.24 ± 0.1% | 36.12 ± 2.3% | 26150.90 ± 2.5% | 60.12 ± 0.5% | 12.55 ± 0.2% | 66.68 ± 0.5% | 26506.51 ± 0.3% | 41.46 | 1.00 | 1.01 | 440.84 |
| other: a line's first word, second text | 3716 | 2519.04 ± 0.6% | 614.90 ± 0.2% | 37.22 ± 0.4% | 2421.40 ± 1.0% | 79.75 ± 5.9% | refused | refused | 2510.37 ± 0.5% | 4.10 | 1.00 | 1.04 | 31.59 |
| other: fourteen octets before an x | 87 | 37107.82 ± 0.9% | 310.63 ± 0.2% | 7.73 ± 1.4% | 4156.67 ± 1.6% | 11.80 ± 0.5% | differs | 19.49 ± 1.0% | 36780.96 ± 1.2% | 119.46 | 1.01 | 8.93 | 3145.27 |
| other: a Greek word | 21815 | 531.02 ± 0.9% | 405.38 ± 0.2% | 37.32 ± 2.1% | 312.86 ± 0.4% | 53.52 ± 2.2% | differs | refused | 530.40 ± 0.4% | 1.31 | 1.00 | 1.70 | 9.92 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.13 ± 2.4% | 22.19 ± 1.3% | 1.07 ± 1.7% | 21.45 ± 0.3% | 3.22 ± 0.5% | differs | 4.80 ± 0.4% | 22.18 ± 0.9% | 1.00 | 1.00 | 1.03 | 6.88 |
| a UUID | 32895 | 24.36 ± 1.8% | 24.30 ± 0.5% | 0.73 ± 0.3% | 16.42 ± 0.2% | 3.23 ± 0.9% | 0.70 ± 1.2% | 3.82 ± 0.8% | 24.35 ± 0.4% | 1.00 | 1.00 | 1.48 | 7.54 |
| an IPv4 address | 33176 | 35.23 ± 0.4% | 35.24 ± 0.8% | 2.38 ± 1.7% | 31.40 ± 0.5% | 8.09 ± 0.8% | differs | 4.72 ± 0.7% | 35.09 ± 0.4% | 1.00 | 1.00 | 1.12 | 4.35 |
| a date and time | 32954 | 34.42 ± 0.4% | 34.41 ± 1.0% | 1.75 ± 0.7% | 23.84 ± 0.1% | 10.21 ± 1.4% | 1.29 ± 1.4% | 8.47 ± 1.5% | 34.39 ± 0.1% | 1.00 | 1.00 | 1.44 | 3.37 |
| a field path | 32606 | 24.80 ± 0.2% | 24.78 ± 0.2% | 1.24 ± 0.7% | 24.80 ± 0.1% | 3.73 ± 0.4% | differs | 3.12 ± 2.6% | 24.73 ± 0.4% | 1.00 | 1.00 | 1.00 | 6.64 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.67 ± 0.8% | 12.65 ± 1.1% | 12.59 ± 1.5% | 14.39 ± 2.4% | 6.73 ± 0.8% | 1.02 ± 0.4% | none | 11.89 ± 0.4% | 1.00 | 1.07 | 0.88 | 1.88 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 305.60 ± 0.5% | 307.38 ± 0.8% | 368.02 ± 0.3% | 117.51 ± 1.6% | 262.06 ± 1.5% | 700.45 ± 1.8% | 3652.16 ± 2.4% | 305.32 ± 0.3% | 0.99 | 1.00 | 2.60 | 1.17 |
| a UUID | 62 | 200.96 ± 0.2% | 201.95 ± 0.4% | 227.00 ± 0.2% | 61.95 ± 0.9% | 116.86 ± 7.6% | 256.63 ± 3.8% | 4552.70 ± 0.7% | 201.01 ± 0.4% | 1.00 | 1.00 | 3.24 | 1.72 |
| an IPv4 address | 29 | 572.38 ± 4.6% | 578.72 ± 0.2% | 820.36 ± 0.3% | 100.79 ± 0.1% | 154.66 ± 2.4% | 437.25 ± 0.4% | 8634.83 ± 1.3% | 572.38 ± 4.6% | 0.99 | 1.00 | 5.68 | 3.70 |
| a date and time | 56 | 427.56 ± 0.5% | 431.17 ± 0.4% | 547.21 ± 0.8% | 97.52 ± 0.7% | 163.08 ± 5.7% | 457.65 ± 1.2% | 4761.81 ± 3.5% | 426.97 ± 0.4% | 0.99 | 1.00 | 4.38 | 2.62 |
| a field path | 39 | 308.19 ± 0.5% | 309.94 ± 0.3% | 370.21 ± 0.3% | 106.33 ± 1.2% | 244.99 ± 1.3% | 723.59 ± 0.8% | 4711.77 ± 1.5% | 308.10 ± 0.8% | 0.99 | 1.00 | 2.90 | 1.26 |
| literal: a word | 7 | 842.46 ± 0.6% | 925.53 ± 0.6% | 1678.24 ± 0.4% | 713.48 ± 1.2% | 811.81 ± 9.5% | 1474.34 ± 0.3% | 31625.96 ± 0.2% | 841.04 ± 0.7% | 0.91 | 1.00 | 1.18 | 1.04 |
| literal: a word that is not there | 8 | 807.67 ± 1.0% | 890.39 ± 0.3% | 1576.96 ± 0.1% | 637.60 ± 0.9% | 769.53 ± 6.4% | 1375.54 ± 0.5% | 31105.06 ± 0.3% | 807.85 ± 0.6% | 0.91 | 1.00 | 1.27 | 1.05 |
| literal: one of four words | 26 | 322.95 ± 0.5% | 539.27 ± 0.3% | 729.93 ± 0.3% | 50.96 ± 1.0% | 301.63 ± 1.9% | 512.68 ± 2.1% | 15147.82 ± 0.4% | 322.63 ± 0.3% | 0.60 | 1.00 | 6.34 | 1.07 |
| literal: a word in any case | 11 | 591.86 ± 0.5% | 634.45 ± 0.5% | 932.77 ± 0.3% | 17.80 ± 0.4% | 847.21 ± 11.8% | refused | 25660.26 ± 3.6% | 592.19 ± 0.2% | 0.93 | 1.00 | 33.24 | 0.70 |
| literal: an href attribute | 12 | 459.27 ± 0.6% | 473.20 ± 0.9% | 621.24 ± 0.7% | 50.27 ± 0.4% | 618.18 ± 1.2% | 1173.19 ± 0.7% | 23222.38 ± 0.8% | 459.41 ± 0.5% | 0.97 | 1.00 | 9.14 | 0.74 |
| literal: a word, second text | 10 | 746.20 ± 0.5% | 833.04 ± 0.3% | 1404.27 ± 0.2% | 597.62 ± 0.7% | 669.09 ± 8.7% | 1192.80 ± 1.1% | 28242.14 ± 0.6% | 745.61 ± 0.5% | 0.90 | 1.00 | 1.25 | 1.12 |
| class: two capitalized words | 23 | 624.20 ± 0.2% | 685.29 ± 0.2% | 1017.61 ± 0.2% | 136.85 ± 0.7% | 632.63 ± 11.7% | 1120.18 ± 1.3% | 7115.80 ± 2.9% | 623.66 ± 0.2% | 0.91 | 1.00 | 4.56 | 0.99 |
| class: a word that ends in ing | 9 | 751.16 ± 0.2% | 869.27 ± 0.2% | 1574.08 ± 0.2% | 172.16 ± 0.7% | 926.20 ± 1.9% | 1745.35 ± 0.2% | 18739.40 ± 3.3% | 751.05 ± 0.4% | 0.86 | 1.00 | 4.36 | 0.81 |
| class: a word in capitals | 16 | 692.03 ± 0.4% | 765.84 ± 0.3% | 1283.52 ± 0.6% | 181.97 ± 2.0% | 926.52 ± 13.2% | 1622.00 ± 0.7% | 9046.40 ± 0.8% | 692.00 ± 0.1% | 0.90 | 1.00 | 3.80 | 0.75 |
| class: a number | 6 | 853.08 ± 0.4% | 965.05 ± 0.3% | 1875.27 ± 0.2% | 44.59 ± 1.7% | 1719.72 ± 0.8% | 3043.80 ± 0.8% | 25587.66 ± 0.5% | 853.23 ± 0.7% | 0.88 | 1.00 | 19.13 | 0.50 |
| class: two capitalized words, second text | 23 | 622.96 ± 0.4% | 683.05 ± 0.3% | 1014.85 ± 0.3% | 136.02 ± 0.5% | 623.35 ± 2.6% | 1130.49 ± 1.0% | 7086.31 ± 1.4% | 622.10 ± 0.3% | 0.91 | 1.00 | 4.58 | 1.00 |
| other: a word between two words | 13 | 734.20 ± 0.3% | 769.52 ± 0.5% | 1223.73 ± 0.5% | 182.77 ± 1.1% | 617.66 ± 13.8% | 1220.72 ± 2.0% | 16162.48 ± 1.3% | 735.89 ± 0.3% | 0.95 | 1.00 | 4.02 | 1.19 |
| other: a number before a unit, second text | 15 | 546.33 ± 0.6% | 617.84 ± 0.3% | 887.48 ± 3.5% | 41.76 ± 0.5% | 786.73 ± 9.2% | 1385.55 ± 2.1% | 15711.05 ± 1.8% | 545.68 ± 4.3% | 0.88 | 1.00 | 13.08 | 0.69 |
| other: a heading's start tag | 13 | 472.21 ± 0.5% | 482.56 ± 0.4% | 641.66 ± 0.8% | 48.06 ± 0.2% | 771.92 ± 10.4% | 1346.42 ± 4.8% | 19191.93 ± 1.1% | 473.70 ± 0.6% | 0.98 | 1.00 | 9.82 | 0.61 |
| other: a whole word | 11 | 763.41 ± 0.3% | 820.97 ± 1.3% | 1370.45 ± 0.4% | 161.80 ± 0.9% | 724.61 ± 1.6% | 1269.86 ± 0.7% | 28224.63 ± 2.1% | 763.28 ± 0.3% | 0.93 | 1.00 | 4.72 | 1.05 |
| other: a line's first word, second text | 17 | 719.86 ± 0.4% | 762.76 ± 0.4% | 1256.71 ± 0.2% | 173.88 ± 0.4% | 875.81 ± 1.2% | refused | refused | 719.01 ± 0.5% | 0.94 | 1.00 | 4.14 | 0.82 |
| other: fourteen octets before an x | 16 | 130.61 ± 0.6% | 187.30 ± 0.4% | 216.13 ± 0.4% | 18.76 ± 0.2% | 553.68 ± 2.2% | 593.05 ± 0.4% | 15135.18 ± 2.1% | 130.62 ± 0.3% | 0.70 | 1.00 | 6.96 | 0.24 |
| other: a Greek word | 8 | 559.67 ± 0.4% | 805.91 ± 0.2% | 1403.60 ± 0.5% | 61.54 ± 0.2% | 1712.80 ± 7.5% | 2911.70 ± 0.2% | refused | 558.98 ± 0.3% | 0.69 | 1.00 | 9.09 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29096.15 ± 0.6% | not timed | not timed | 29065.48 ± 0.4% | 2761.22 ± 15.0% | not timed | not timed | 29080.06 ± 0.6% | | 1.00 | 1.00 | 10.54 |
| 01-literal/sherlock-casei-en | 522 | 10275.18 ± 1.3% | not timed | not timed | 8499.43 ± 0.4% | 40.19 ± 0.6% | not timed | not timed | 10208.13 ± 0.6% | | 1.01 | 1.21 | 255.68 |
| 01-literal/sherlock-ru | 724 | 29169.66 ± 2.5% | not timed | not timed | 28300.29 ± 2.7% | 1560.93 ± 8.2% | not timed | not timed | 29137.62 ± 0.5% | | 1.00 | 1.03 | 18.69 |
| 01-literal/sherlock-casei-ru | 746 | 11419.84 ± 1.0% | not timed | not timed | 6541.72 ± 0.4% | 42.79 ± 0.2% | not timed | not timed | 11238.40 ± 4.4% | | 1.02 | 1.75 | 266.90 |
| 01-literal/sherlock-zh | 30 | 39831.35 ± 0.2% | not timed | not timed | 35257.78 ± 0.2% | 1608.60 ± 2.1% | not timed | not timed | 39801.75 ± 0.4% | | 1.00 | 1.13 | 24.76 |
| 02-literal-alternate/sherlock-en | 714 | 12466.34 ± 0.7% | not timed | not timed | 9448.98 ± 0.2% | 22.39 ± 1.4% | not timed | not timed | 12427.43 ± 0.5% | | 1.00 | 1.32 | 556.79 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2227.22 ± 0.8% | not timed | not timed | 2312.56 ± 5.0% | 13.62 ± 1.6% | not timed | not timed | 2211.31 ± 0.4% | | 1.01 | 0.96 | 163.58 |
| 02-literal-alternate/sherlock-ru | 899 | 9682.89 ± 1.7% | not timed | not timed | 5147.02 ± 0.2% | 28.91 ± 8.9% | not timed | not timed | 9496.55 ± 1.5% | | 1.02 | 1.88 | 334.96 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2368.80 ± 0.7% | not timed | not timed | 1250.01 ± 0.1% | 11.71 ± 0.5% | not timed | not timed | 2353.57 ± 0.4% | | 1.01 | 1.90 | 202.21 |
| 02-literal-alternate/sherlock-zh | 207 | 16983.34 ± 2.6% | not timed | not timed | 10766.47 ± 0.3% | 41.72 ± 1.0% | not timed | not timed | 16953.10 ± 0.2% | | 1.00 | 1.58 | 407.11 |
| 03-date/ascii | 111817 | 127.96 ± 0.4% | not timed | not timed | 110.44 ± 0.8% | 0.27 ± 1.8% | not timed | not timed | 127.34 ± 1.1% | | 1.00 | 1.16 | 474.77 |
| 04-ruff-noqa/real | 84 | 559.14 ± 0.2% | not timed | not timed | 570.83 ± 2.0% | 19.68 ± 0.3% | not timed | not timed | 557.63 ± 0.2% | | 1.00 | 0.98 | 28.41 |
| 04-ruff-noqa/tweaked | 44 | 648.46 ± 0.3% | not timed | not timed | 564.36 ± 2.7% | 462.72 ± 2.0% | not timed | not timed | 648.21 ± 0.6% | | 1.00 | 1.15 | 1.40 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.4% | not timed | not timed | 5.88 ± 4.6% | 0.27 ± 4.7% | not timed | not timed | 5.27 ± 3.3% | | 1.02 | 0.91 | 20.18 |
| 06-cloud-flare-redos/original | 107 | 474.59 ± 0.3% | not timed | not timed | 262.03 ± 5.1% | 32.33 ± 0.5% | not timed | not timed | 474.59 ± 0.2% | | 1.00 | 1.81 | 14.68 |
| 06-cloud-flare-redos/simplified-short | 102 | 419.07 ± 0.2% | not timed | not timed | 267.53 ± 0.3% | 35.22 ± 1.1% | not timed | not timed | 419.21 ± 0.2% | | 1.00 | 1.57 | 11.90 |
| 06-cloud-flare-redos/simplified-long | 10000 | 558.86 ± 0.3% | not timed | not timed | 279.96 ± 0.3% | 38.30 ± 0.3% | not timed | not timed | 558.80 ± 0.2% | | 1.00 | 2.00 | 14.59 |
| 07-unicode-character-data/parse-line | 558784 | 277.03 ± 6.8% | not timed | not timed | 208.69 ± 0.2% | 53.69 ± 3.9% | not timed | not timed | 246.57 ± 3.3% | | 1.12 | 1.33 | 5.16 |
| 08-words/all-english | 56691 | 114.23 ± 0.8% | not timed | not timed | 93.74 ± 0.5% | 14.17 ± 4.0% | not timed | not timed | 113.88 ± 1.2% | | 1.00 | 1.22 | 8.06 |
| 08-words/long-english | 839 | 645.94 ± 0.2% | not timed | not timed | 624.89 ± 0.3% | 37.95 ± 0.3% | not timed | not timed | 645.58 ± 0.1% | | 1.00 | 1.03 | 17.02 |
| 09-aws-keys/full | 0 | 570.47 ± 0.3% | not timed | not timed | 572.52 ± 0.2% | 84.02 ± 5.3% | not timed | not timed | 569.48 ± 0.2% | | 1.00 | 1.00 | 6.79 |
| 09-aws-keys/quick | 0 | 1251.89 ± 0.5% | not timed | not timed | 910.28 ± 0.3% | 532.83 ± 0.7% | not timed | not timed | 1248.04 ± 0.3% | | 1.00 | 1.38 | 2.35 |
| 10-bounded-repeat/letters-en | 1833 | 612.37 ± 1.2% | not timed | not timed | 549.20 ± 0.7% | 24.01 ± 0.9% | not timed | not timed | 607.49 ± 0.6% | | 1.01 | 1.12 | 25.50 |
| 10-bounded-repeat/letters-ru | 3475 | 537.79 ± 2.0% | not timed | not timed | 495.45 ± 0.9% | 26.25 ± 24.4% | not timed | not timed | 534.26 ± 0.6% | | 1.01 | 1.09 | 20.49 |
| 10-bounded-repeat/context | 53 | 88.24 ± 1.0% | not timed | not timed | 75.06 ± 0.3% | 24.24 ± 0.4% | not timed | not timed | 79.67 ± 0.8% | | 1.11 | 1.18 | 3.64 |
| 10-bounded-repeat/capitals | 11 | 671.30 ± 8.0% | not timed | not timed | 640.58 ± 0.3% | 44.33 ± 1.9% | not timed | not timed | 670.61 ± 8.1% | | 1.00 | 1.05 | 15.14 |
| 11-unstructured-to-json/extract | 600 | 83.95 ± 0.3% | not timed | not timed | 79.22 ± 0.2% | 62.82 ± 1.2% | not timed | not timed | 83.68 ± 0.4% | | 1.00 | 1.06 | 1.34 |
| 12-dictionary/single | 1 | 571.79 ± 0.4% | not timed | not timed | 547.31 ± 0.2% | 0.53 ± 0.4% | not timed | not timed | 572.00 ± 0.2% | | 1.00 | 1.04 | 1085.13 |
| 14-quadratic/1x | 100 | 29.65 ± 0.5% | not timed | not timed | 13.52 ± 0.3% | 1.26 ± 2.7% | not timed | not timed | 29.57 ± 0.1% | | 1.00 | 2.19 | 23.51 |
| 14-quadratic/2x | 200 | 22.91 ± 0.5% | not timed | not timed | 6.61 ± 0.2% | 0.70 ± 0.4% | not timed | not timed | 22.82 ± 0.4% | | 1.00 | 3.47 | 32.86 |
| 14-quadratic/10x | 1000 | 7.13 ± 0.5% | not timed | not timed | 1.29 ± 0.2% | 0.15 ± 0.8% | not timed | not timed | 7.12 ± 1.2% | | 1.00 | 5.51 | 46.86 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.70 ± 1.5% | not timed | not timed | 0.45 ± 0.4% | 0.67 ± 1.5% | not timed | not timed | 1.68 ± 1.0% | | 1.01 | 3.76 | 2.55 |
| 04-ruff-noqa/compile-real | 1 | 126.54 ± 0.1% | not timed | not timed | 16.06 ± 0.5% | 175.86 ± 1.5% | not timed | not timed | 125.53 ± 1.0% | | 1.01 | 7.88 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 19.99 ± 0.6% | not timed | not timed | 3.06 ± 0.8% | 7.82 ± 1.8% | not timed | not timed | 19.88 ± 0.3% | | 1.01 | 6.54 | 2.56 |
| 07-unicode-character-data/compile | 1 | 75.95 ± 0.3% | not timed | not timed | 32.72 ± 0.3% | 43.92 ± 1.8% | not timed | not timed | 75.23 ± 1.4% | | 1.01 | 2.32 | 1.73 |
| 09-aws-keys/compile-full | 1 | 51.06 ± 0.4% | not timed | not timed | 9.02 ± 0.4% | 28.18 ± 1.5% | not timed | not timed | 50.64 ± 1.1% | | 1.01 | 5.66 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 233.50 ± 0.2% | not timed | not timed | 59.64 ± 0.2% | 166.08 ± 4.3% | not timed | not timed | 231.14 ± 0.4% | | 1.01 | 3.92 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 15.14 ± 0.5% | not timed | not timed | 14.49 ± 0.4% | 20.74 ± 2.6% | not timed | not timed | 15.12 ± 0.4% | | 1.00 | 1.04 | 0.73 |
| 10-bounded-repeat/compile-capitals | 1 | 96.98 ± 0.7% | not timed | not timed | 10.94 ± 0.2% | 29.46 ± 1.7% | not timed | not timed | 95.70 ± 1.3% | | 1.01 | 8.87 | 3.29 |
| 11-unstructured-to-json/compile | 1 | 114.73 ± 0.6% | not timed | not timed | 50.39 ± 1.2% | 83.40 ± 2.6% | not timed | not timed | 113.43 ± 1.1% | | 1.01 | 2.28 | 1.38 |
| 12-dictionary/compile-single | 1 | 0.37 ± 0.2% | not timed | not timed | 0.08 ± 0.5% | 0.12 ± 8.0% | not timed | not timed | 0.37 ± 0.3% | | 1.00 | 4.59 | 3.22 |

