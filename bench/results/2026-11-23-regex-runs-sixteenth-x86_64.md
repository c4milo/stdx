# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148127709 |
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
| literal: a word | 217 | 39933.00 ± 3.9% | 1023.04 ± 3.7% | 29.74 ± 3.7% | 38936.96 ± 2.1% | 11971.04 ± 3.7% | 12.88 ± 2.9% | 103.72 ± 4.4% | 40268.78 ± 7.3% | 39.03 | 0.99 | 1.03 | 3.34 |
| literal: a word that is not there | 0 | 57668.08 ± 1.6% | 1043.50 ± 1.7% | 29.81 ± 2.8% | 45739.90 ± 1.0% | 42472.34 ± 3.2% | 12.73 ± 0.4% | 98.10 ± 0.9% | 57579.10 ± 8.9% | 55.26 | 1.00 | 1.26 | 1.36 |
| literal: one of four words | 661 | 14298.95 ± 0.3% | 1014.04 ± 0.1% | 16.95 ± 0.6% | 11166.43 ± 0.8% | 24.33 ± 1.6% | 4.45 ± 0.1% | 8.22 ± 10.5% | 14236.63 ± 3.8% | 14.10 | 1.00 | 1.28 | 587.68 |
| literal: a word in any case | 217 | 36655.45 ± 0.8% | 1033.64 ± 0.2% | 22.88 ± 0.2% | 11372.68 ± 0.3% | 47.07 ± 0.8% | refused | differs | 36743.52 ± 1.1% | 35.46 | 1.00 | 3.22 | 778.78 |
| literal: an href attribute | 33 | 35415.87 ± 0.3% | 1040.85 ± 0.1% | 28.98 ± 1.1% | 35165.57 ± 0.2% | 2930.39 ± 2.5% | 9.67 ± 0.2% | 87.36 ± 0.8% | 35372.55 ± 1.8% | 34.03 | 1.00 | 1.01 | 12.09 |
| literal: a word, second text | 123 | 44384.32 ± 5.8% | 1035.52 ± 2.3% | 29.73 ± 0.6% | 39475.77 ± 0.4% | 11460.25 ± 9.6% | 14.53 ± 0.6% | 87.51 ± 2.6% | 44405.20 ± 5.9% | 42.86 | 1.00 | 1.12 | 3.87 |
| class: two capitalized words | 1331 | 919.52 ± 0.2% | 964.35 ± 0.1% | 28.09 ± 0.4% | 575.60 ± 0.4% | 44.24 ± 11.9% | 11.08 ± 0.2% | 79.95 ± 0.5% | 919.72 ± 0.2% | 0.95 | 1.00 | 1.60 | 20.78 |
| class: a word that ends in ing | 3399 | 885.80 ± 0.3% | 886.91 ± 0.3% | 19.24 ± 0.3% | 540.27 ± 0.2% | 32.88 ± 6.1% | 6.24 ± 0.3% | 20.25 ± 0.8% | 885.32 ± 0.2% | 1.00 | 1.00 | 1.64 | 26.94 |
| class: a word in capitals | 2332 | 1159.96 ± 0.5% | 941.82 ± 0.3% | 29.28 ± 0.1% | 566.39 ± 0.2% | 47.55 ± 0.6% | 12.52 ± 0.3% | 100.79 ± 2.5% | 1159.68 ± 0.6% | 1.23 | 1.00 | 2.05 | 24.40 |
| class: a number | 8288 | 1721.88 ± 0.5% | 816.30 ± 0.2% | 29.69 ± 0.5% | 1797.76 ± 2.2% | 46.18 ± 11.5% | 0.39 ± 0.4% | 72.56 ± 0.2% | 1720.69 ± 0.3% | 2.11 | 1.00 | 0.96 | 37.28 |
| class: two capitalized words, second text | 5359 | 724.98 ± 0.3% | 724.20 ± 0.2% | 25.75 ± 0.8% | 478.18 ± 0.1% | 36.73 ± 11.4% | 12.78 ± 0.4% | 74.01 ± 0.9% | 724.89 ± 0.9% | 1.00 | 1.00 | 1.52 | 19.74 |
| other: a word between two words | 6104 | 842.02 ± 0.4% | 754.61 ± 0.0% | 25.36 ± 1.0% | 816.17 ± 0.3% | 118.63 ± 14.5% | 8.57 ± 0.4% | 81.52 ± 0.3% | 839.56 ± 0.4% | 1.12 | 1.00 | 1.03 | 7.10 |
| other: a number before a unit, second text | 1481 | 9905.97 ± 0.9% | 991.12 ± 0.3% | 28.01 ± 1.2% | 8289.20 ± 0.2% | 44.99 ± 1.9% | 13.36 ± 0.3% | 77.58 ± 1.6% | 9893.71 ± 0.2% | 9.99 | 1.00 | 1.20 | 220.17 |
| other: a heading's start tag | 110 | 24466.90 ± 0.2% | 1030.96 ± 0.1% | 29.79 ± 1.5% | 2569.32 ± 0.4% | 2023.68 ± 8.6% | 11.87 ± 0.5% | 107.27 ± 0.4% | 24387.10 ± 0.6% | 23.73 | 1.00 | 9.52 | 12.09 |
| other: a whole word | 217 | 29372.05 ± 0.1% | 1033.85 ± 0.0% | 30.15 ± 0.6% | 28264.31 ± 1.0% | 53.92 ± 1.4% | 11.22 ± 0.3% | 63.09 ± 1.8% | 29296.42 ± 0.4% | 28.41 | 1.00 | 1.04 | 544.76 |
| other: a line's first word, second text | 3716 | 2596.59 ± 1.5% | 863.39 ± 0.2% | 32.20 ± 7.0% | 2324.59 ± 2.1% | 70.63 ± 4.2% | refused | refused | 2567.96 ± 1.3% | 3.01 | 1.01 | 1.12 | 36.77 |
| other: fourteen octets before an x | 87 | 36371.21 ± 1.2% | 251.96 ± 1.1% | 7.67 ± 5.4% | 3537.35 ± 0.1% | 11.59 ± 2.8% | differs | 20.68 ± 4.0% | 36452.56 ± 6.0% | 144.35 | 1.00 | 10.28 | 3137.28 |
| other: a Greek word | 21815 | 482.33 ± 0.3% | 404.12 ± 0.1% | 33.74 ± 0.3% | 303.33 ± 6.2% | 53.20 ± 14.6% | differs | refused | 481.01 ± 1.0% | 1.19 | 1.00 | 1.59 | 9.07 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.82 ± 0.7% | 28.77 ± 7.1% | 1.04 ± 0.8% | 19.84 ± 0.2% | 2.69 ± 0.2% | differs | 4.28 ± 2.5% | 28.80 ± 0.4% | 1.00 | 1.00 | 1.45 | 10.72 |
| a UUID | 32895 | 23.98 ± 0.1% | 23.87 ± 0.1% | 0.73 ± 0.9% | 15.14 ± 0.2% | 3.06 ± 0.9% | 0.52 ± 0.8% | 3.90 ± 3.0% | 23.78 ± 4.7% | 1.00 | 1.01 | 1.58 | 7.85 |
| an IPv4 address | 33176 | 39.42 ± 0.6% | 39.30 ± 0.5% | 2.15 ± 0.9% | 28.41 ± 0.2% | 6.95 ± 11.7% | differs | 4.18 ± 0.8% | 39.45 ± 0.6% | 1.00 | 1.00 | 1.39 | 5.67 |
| a date and time | 32954 | 35.34 ± 0.5% | 35.61 ± 0.2% | 1.73 ± 0.4% | 21.68 ± 0.7% | 8.23 ± 4.4% | 0.88 ± 1.6% | 7.74 ± 2.0% | 35.47 ± 0.2% | 0.99 | 1.00 | 1.63 | 4.29 |
| a field path | 32606 | 32.07 ± 0.5% | 32.02 ± 0.5% | 1.15 ± 1.2% | 22.94 ± 0.5% | 3.51 ± 2.1% | differs | 3.01 ± 2.6% | 32.09 ± 8.4% | 1.00 | 1.00 | 1.40 | 9.15 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.91 ± 0.5% | 10.88 ± 7.3% | 10.81 ± 1.9% | 13.22 ± 0.3% | 5.89 ± 2.0% | 0.76 ± 1.4% | none | 10.75 ± 0.2% | 1.00 | 1.01 | 0.83 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 239.62 ± 0.2% | 241.47 ± 0.3% | 283.84 ± 7.0% | 101.19 ± 2.7% | 245.97 ± 11.9% | 693.51 ± 8.0% | 4797.11 ± 1.3% | 239.72 ± 0.5% | 0.99 | 1.00 | 2.37 | 0.97 |
| a UUID | 62 | 154.97 ± 0.4% | 155.38 ± 0.5% | 173.54 ± 1.2% | 57.90 ± 2.4% | 118.53 ± 12.7% | 253.81 ± 1.5% | 5397.35 ± 12.2% | 154.75 ± 4.1% | 1.00 | 1.00 | 2.68 | 1.31 |
| an IPv4 address | 29 | 495.00 ± 1.0% | 501.30 ± 2.2% | 739.08 ± 0.3% | 88.61 ± 0.8% | 149.03 ± 9.7% | 403.04 ± 1.8% | 9019.59 ± 0.4% | 494.70 ± 1.7% | 0.99 | 1.00 | 5.59 | 3.32 |
| a date and time | 56 | 370.33 ± 0.2% | 371.37 ± 6.2% | 482.24 ± 1.8% | 87.24 ± 2.0% | 163.62 ± 3.9% | 476.88 ± 2.6% | 5528.99 ± 0.4% | 369.92 ± 0.5% | 1.00 | 1.00 | 4.25 | 2.26 |
| a field path | 39 | 229.14 ± 0.1% | 230.00 ± 0.6% | 268.77 ± 0.2% | 96.46 ± 3.0% | 229.94 ± 0.7% | 738.46 ± 1.5% | 5599.29 ± 18.6% | 228.91 ± 0.8% | 1.00 | 1.00 | 2.38 | 1.00 |
| literal: a word | 7 | 741.86 ± 3.2% | 784.16 ± 0.2% | 1504.09 ± 1.1% | 655.29 ± 0.4% | 790.81 ± 24.3% | 1622.69 ± 1.2% | 34129.02 ± 0.7% | 738.69 ± 18.2% | 0.95 | 1.00 | 1.13 | 0.94 |
| literal: a word that is not there | 8 | 708.55 ± 3.6% | 757.34 ± 2.3% | 1416.51 ± 1.7% | 605.78 ± 5.1% | 746.95 ± 14.5% | 1506.17 ± 1.9% | 33294.66 ± 0.6% | 707.41 ± 1.8% | 0.94 | 1.00 | 1.17 | 0.95 |
| literal: one of four words | 26 | 275.43 ± 2.4% | 454.82 ± 3.3% | 643.46 ± 1.1% | 53.58 ± 0.8% | 291.71 ± 1.6% | 588.87 ± 1.0% | 18288.28 ± 2.6% | 277.24 ± 2.0% | 0.61 | 0.99 | 5.14 | 0.94 |
| literal: a word in any case | 11 | 578.95 ± 1.2% | 616.39 ± 0.6% | 964.21 ± 11.8% | 18.75 ± 13.3% | 818.80 ± 3.0% | refused | 24721.36 ± 1.0% | 581.99 ± 1.4% | 0.94 | 0.99 | 30.88 | 0.71 |
| literal: an href attribute | 12 | 400.59 ± 1.5% | 413.51 ± 0.1% | 564.89 ± 1.2% | 50.80 ± 0.6% | 574.27 ± 20.1% | 1274.66 ± 1.0% | 24526.97 ± 2.0% | 401.26 ± 0.7% | 0.97 | 1.00 | 7.89 | 0.70 |
| literal: a word, second text | 10 | 663.11 ± 2.5% | 715.13 ± 0.7% | 1270.85 ± 1.6% | 544.77 ± 3.5% | 650.60 ± 10.3% | 1353.04 ± 4.5% | 31762.75 ± 0.8% | 662.80 ± 1.9% | 0.93 | 1.00 | 1.22 | 1.02 |
| class: two capitalized words | 23 | 519.51 ± 1.4% | 561.38 ± 2.2% | 849.63 ± 2.5% | 122.03 ± 3.3% | 592.95 ± 4.1% | 1266.61 ± 3.9% | 7832.13 ± 6.8% | 520.23 ± 2.4% | 0.93 | 1.00 | 4.26 | 0.88 |
| class: a word that ends in ing | 9 | 621.76 ± 4.5% | 703.49 ± 3.4% | 1329.82 ± 4.4% | 151.18 ± 3.3% | 851.72 ± 3.9% | 1868.43 ± 1.7% | 19015.22 ± 20.8% | 620.97 ± 2.0% | 0.88 | 1.00 | 4.11 | 0.73 |
| class: a word in capitals | 16 | 552.87 ± 7.3% | 604.51 ± 7.6% | 1029.31 ± 6.6% | 155.27 ± 5.4% | 845.25 ± 12.0% | 1721.08 ± 4.0% | 10186.73 ± 2.8% | 559.11 ± 3.5% | 0.91 | 0.99 | 3.56 | 0.65 |
| class: a number | 6 | 665.78 ± 5.2% | 744.89 ± 4.4% | 1487.36 ± 3.0% | 45.86 ± 7.5% | 1575.20 ± 4.8% | 2888.76 ± 3.1% | 24767.37 ± 2.4% | 659.10 ± 13.4% | 0.89 | 1.01 | 14.52 | 0.42 |
| class: two capitalized words, second text | 23 | 498.88 ± 2.8% | 537.82 ± 2.9% | 827.32 ± 3.7% | 115.87 ± 3.8% | 581.63 ± 2.6% | 1215.76 ± 4.7% | 7589.01 ± 1.7% | 506.38 ± 10.6% | 0.93 | 0.99 | 4.31 | 0.86 |
| other: a word between two words | 13 | 614.13 ± 2.3% | 640.87 ± 2.8% | 1068.10 ± 2.2% | 151.57 ± 1.8% | 556.37 ± 3.1% | 1303.17 ± 3.2% | 17060.85 ± 2.8% | 614.00 ± 15.9% | 0.96 | 1.00 | 4.05 | 1.10 |
| other: a number before a unit, second text | 15 | 428.34 ± 3.3% | 477.61 ± 2.5% | 670.35 ± 10.8% | 42.91 ± 3.6% | 719.41 ± 4.7% | 1447.75 ± 5.0% | 17347.68 ± 3.0% | 432.15 ± 2.7% | 0.90 | 0.99 | 9.98 | 0.60 |
| other: a heading's start tag | 13 | 407.44 ± 2.1% | 411.23 ± 3.7% | 566.16 ± 3.3% | 47.88 ± 3.4% | 710.08 ± 9.9% | 1363.18 ± 1.3% | 20026.42 ± 2.7% | 409.42 ± 3.8% | 0.99 | 1.00 | 8.51 | 0.57 |
| other: a whole word | 11 | 658.19 ± 4.0% | 694.59 ± 1.2% | 1207.59 ± 13.4% | 144.19 ± 0.9% | 677.43 ± 5.3% | 1368.95 ± 3.9% | 31308.61 ± 1.9% | 650.83 ± 4.6% | 0.95 | 1.01 | 4.56 | 0.97 |
| other: a line's first word, second text | 17 | 614.50 ± 2.4% | 642.46 ± 1.0% | 1102.11 ± 2.3% | 148.57 ± 2.6% | 805.48 ± 1.2% | refused | refused | 611.69 ± 0.5% | 0.96 | 1.00 | 4.14 | 0.76 |
| other: fourteen octets before an x | 16 | 115.74 ± 2.2% | 172.77 ± 0.9% | 206.31 ± 1.3% | 18.07 ± 0.9% | 521.61 ± 2.2% | 584.07 ± 3.0% | 15754.52 ± 2.5% | 116.12 ± 1.0% | 0.67 | 1.00 | 6.41 | 0.22 |
| other: a Greek word | 8 | 431.25 ± 2.9% | 604.79 ± 2.6% | 998.27 ± 3.2% | 62.80 ± 6.2% | 1592.80 ± 4.4% | 2480.69 ± 11.5% | refused | 428.74 ± 2.9% | 0.71 | 1.01 | 6.87 | 0.27 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 28998.91 ± 0.9% | not timed | not timed | 33281.39 ± 20.3% | 2963.90 ± 4.1% | not timed | not timed | 28982.78 ± 3.0% | | 1.00 | 0.87 | 9.78 |
| 01-literal/sherlock-casei-en | 522 | 8469.42 ± 1.0% | not timed | not timed | 9008.73 ± 0.8% | 34.09 ± 1.4% | not timed | not timed | 8457.75 ± 0.2% | | 1.00 | 0.94 | 248.44 |
| 01-literal/sherlock-ru | 724 | 30859.99 ± 2.1% | not timed | not timed | 34403.48 ± 0.6% | 1295.47 ± 4.7% | not timed | not timed | 30800.41 ± 1.1% | | 1.00 | 0.90 | 23.82 |
| 01-literal/sherlock-casei-ru | 746 | 8852.70 ± 0.8% | not timed | not timed | 7783.22 ± 0.9% | 37.67 ± 8.7% | not timed | not timed | 8835.01 ± 0.7% | | 1.00 | 1.14 | 235.03 |
| 01-literal/sherlock-zh | 30 | 52303.32 ± 4.5% | not timed | not timed | 42578.07 ± 17.4% | 1627.59 ± 10.7% | not timed | not timed | 52100.17 ± 1.7% | | 1.00 | 1.23 | 32.14 |
| 02-literal-alternate/sherlock-en | 714 | 12856.65 ± 12.2% | not timed | not timed | 10872.71 ± 1.8% | 19.06 ± 13.4% | not timed | not timed | 12679.04 ± 5.9% | | 1.01 | 1.18 | 674.61 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4182.97 ± 7.7% | not timed | not timed | 2291.68 ± 2.2% | 12.28 ± 1.8% | not timed | not timed | 3848.54 ± 5.6% | | 1.09 | 1.83 | 340.76 |
| 02-literal-alternate/sherlock-ru | 899 | 7476.03 ± 0.4% | not timed | not timed | 9789.88 ± 1.1% | 25.42 ± 0.5% | not timed | not timed | 7471.49 ± 0.7% | | 1.00 | 0.76 | 294.12 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2143.60 ± 3.2% | not timed | not timed | 1188.77 ± 0.4% | 10.56 ± 2.2% | not timed | not timed | 2113.81 ± 0.9% | | 1.01 | 1.80 | 202.93 |
| 02-literal-alternate/sherlock-zh | 207 | 18598.36 ± 0.2% | not timed | not timed | 12605.69 ± 10.4% | 35.63 ± 0.7% | not timed | not timed | 18599.18 ± 0.2% | | 1.00 | 1.48 | 522.01 |
| 03-date/ascii | 111817 | 131.67 ± 0.2% | not timed | not timed | 100.42 ± 5.6% | 0.23 ± 3.2% | not timed | not timed | 131.16 ± 4.7% | | 1.00 | 1.31 | 569.87 |
| 04-ruff-noqa/real | 84 | 696.42 ± 2.9% | not timed | not timed | 503.13 ± 5.7% | 20.47 ± 2.2% | not timed | not timed | 696.65 ± 2.5% | | 1.00 | 1.38 | 34.02 |
| 04-ruff-noqa/tweaked | 44 | 587.35 ± 1.9% | not timed | not timed | 507.04 ± 2.2% | 342.66 ± 8.3% | not timed | not timed | 582.24 ± 1.6% | | 1.01 | 1.16 | 1.71 |
| 05-lexer-veryl/single | 124800 | 3.99 ± 1.3% | not timed | not timed | 5.27 ± 2.5% | 0.26 ± 3.7% | not timed | not timed | 4.00 ± 1.2% | | 1.00 | 0.76 | 15.62 |
| 06-cloud-flare-redos/original | 107 | 269.03 ± 0.2% | not timed | not timed | 228.30 ± 0.4% | 25.84 ± 0.7% | not timed | not timed | 268.66 ± 0.7% | | 1.00 | 1.18 | 10.41 |
| 06-cloud-flare-redos/simplified-short | 102 | 265.49 ± 2.1% | not timed | not timed | 236.61 ± 8.7% | 27.76 ± 0.6% | not timed | not timed | 265.11 ± 5.6% | | 1.00 | 1.12 | 9.57 |
| 06-cloud-flare-redos/simplified-long | 10000 | 281.09 ± 0.2% | not timed | not timed | 259.06 ± 0.3% | 29.88 ± 0.3% | not timed | not timed | 280.95 ± 0.1% | | 1.00 | 1.09 | 9.41 |
| 07-unicode-character-data/parse-line | 558784 | 246.53 ± 2.5% | not timed | not timed | 200.85 ± 0.1% | 47.55 ± 5.0% | not timed | not timed | 245.15 ± 2.3% | | 1.01 | 1.23 | 5.18 |
| 08-words/all-english | 56691 | 112.96 ± 0.4% | not timed | not timed | 83.29 ± 0.4% | 15.20 ± 6.0% | not timed | not timed | 112.92 ± 0.4% | | 1.00 | 1.36 | 7.43 |
| 08-words/long-english | 839 | 988.79 ± 0.2% | not timed | not timed | 583.52 ± 0.4% | 35.12 ± 0.6% | not timed | not timed | 989.06 ± 1.0% | | 1.00 | 1.69 | 28.16 |
| 09-aws-keys/full | 0 | 518.15 ± 1.5% | not timed | not timed | 545.08 ± 0.3% | 65.89 ± 2.6% | not timed | not timed | 510.66 ± 0.2% | | 1.01 | 0.95 | 7.86 |
| 09-aws-keys/quick | 0 | 994.51 ± 0.8% | not timed | not timed | 957.27 ± 1.4% | 414.07 ± 6.7% | not timed | not timed | 962.09 ± 7.4% | | 1.03 | 1.04 | 2.40 |
| 10-bounded-repeat/letters-en | 1833 | 673.93 ± 2.0% | not timed | not timed | 555.16 ± 0.4% | 22.76 ± 0.7% | not timed | not timed | 669.44 ± 0.9% | | 1.01 | 1.21 | 29.61 |
| 10-bounded-repeat/letters-ru | 3475 | 369.51 ± 3.0% | not timed | not timed | 483.31 ± 4.3% | 24.29 ± 8.2% | not timed | not timed | 370.48 ± 0.4% | | 1.00 | 0.76 | 15.21 |
| 10-bounded-repeat/context | 53 | 78.65 ± 1.7% | not timed | not timed | 70.31 ± 7.7% | 22.55 ± 5.1% | not timed | not timed | 78.68 ± 1.6% | | 1.00 | 1.12 | 3.49 |
| 10-bounded-repeat/capitals | 11 | 1033.48 ± 0.3% | not timed | not timed | 604.81 ± 0.8% | 40.07 ± 7.3% | not timed | not timed | 1032.09 ± 0.4% | | 1.00 | 1.71 | 25.79 |
| 11-unstructured-to-json/extract | 600 | 46.39 ± 1.6% | not timed | not timed | 80.07 ± 1.1% | 50.20 ± 1.3% | not timed | not timed | 46.89 ± 0.6% | | 0.99 | 0.58 | 0.92 |
| 12-dictionary/single | 1 | 509.13 ± 0.4% | not timed | not timed | 481.40 ± 0.9% | 0.38 ± 3.0% | not timed | not timed | 512.09 ± 0.3% | | 0.99 | 1.06 | 1329.60 |
| 14-quadratic/1x | 100 | 9.50 ± 0.2% | not timed | not timed | 12.17 ± 0.6% | 1.01 ± 2.8% | not timed | not timed | 9.43 ± 0.4% | | 1.01 | 0.78 | 9.43 |
| 14-quadratic/2x | 200 | 5.34 ± 0.1% | not timed | not timed | 6.12 ± 1.1% | 0.54 ± 2.3% | not timed | not timed | 5.31 ± 1.4% | | 1.01 | 0.87 | 9.88 |
| 14-quadratic/10x | 1000 | 1.19 ± 0.1% | not timed | not timed | 1.22 ± 0.4% | 0.12 ± 1.6% | not timed | not timed | 1.18 ± 0.1% | | 1.00 | 0.98 | 9.97 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.67 ± 0.4% | not timed | not timed | 0.48 ± 0.5% | 0.65 ± 5.8% | not timed | not timed | 1.67 ± 0.8% | | 1.00 | 3.49 | 2.59 |
| 04-ruff-noqa/compile-real | 1 | 102.93 ± 0.7% | not timed | not timed | 17.36 ± 16.3% | 170.03 ± 13.0% | not timed | not timed | 102.44 ± 4.9% | | 1.00 | 5.93 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 17.04 ± 0.3% | not timed | not timed | 3.01 ± 21.2% | 7.88 ± 0.9% | not timed | not timed | 17.00 ± 1.8% | | 1.00 | 5.66 | 2.16 |
| 07-unicode-character-data/compile | 1 | 63.91 ± 13.4% | not timed | not timed | 30.69 ± 0.4% | 44.40 ± 10.4% | not timed | not timed | 63.83 ± 2.0% | | 1.00 | 2.08 | 1.44 |
| 09-aws-keys/compile-full | 1 | 44.70 ± 18.7% | not timed | not timed | 9.95 ± 1.0% | 27.88 ± 2.5% | not timed | not timed | 44.75 ± 0.6% | | 1.00 | 4.49 | 1.60 |
| 09-aws-keys/compile-quick | 1 | 195.30 ± 0.2% | not timed | not timed | 58.13 ± 0.5% | 157.00 ± 4.1% | not timed | not timed | 194.37 ± 0.8% | | 1.00 | 3.36 | 1.24 |
| 10-bounded-repeat/compile-context | 1 | 15.21 ± 1.1% | not timed | not timed | 14.36 ± 0.3% | 20.39 ± 20.1% | not timed | not timed | 15.18 ± 3.8% | | 1.00 | 1.06 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 91.58 ± 2.5% | not timed | not timed | 10.60 ± 1.5% | 29.76 ± 2.2% | not timed | not timed | 90.48 ± 9.0% | | 1.01 | 8.64 | 3.08 |
| 11-unstructured-to-json/compile | 1 | 99.33 ± 2.9% | not timed | not timed | 47.49 ± 6.9% | 80.07 ± 4.3% | not timed | not timed | 98.30 ± 1.0% | | 1.01 | 2.09 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.09 ± 45.5% | 0.12 ± 13.6% | not timed | not timed | 0.35 ± 5.9% | | 1.01 | 4.06 | 2.96 |

