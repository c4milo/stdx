# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159288212 |
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
| literal: a word | 217 | 31375.88 ± 30.4% | 897.18 ± 0.2% | 20.06 ± 0.7% | 30817.06 ± 1.1% | 8858.51 ± 10.5% | 10.85 ± 0.4% | 76.85 ± 0.5% | 31871.55 ± 2.2% | 34.97 | 0.98 | 1.02 | 3.54 |
| literal: a word that is not there | 0 | 47167.35 ± 1.3% | 905.93 ± 0.2% | 20.08 ± 0.3% | 39270.21 ± 6.3% | 29520.34 ± 0.4% | 10.78 ± 0.6% | 72.54 ± 1.2% | 46527.75 ± 1.2% | 52.07 | 1.01 | 1.20 | 1.60 |
| literal: one of four words | 661 | 11174.55 ± 1.0% | 876.81 ± 0.1% | 11.22 ± 3.6% | 9069.42 ± 3.4% | 19.26 ± 8.9% | 3.95 ± 0.7% | 6.51 ± 22.8% | 11176.04 ± 14.3% | 12.74 | 1.00 | 1.23 | 580.13 |
| literal: a word in any case | 217 | 25530.20 ± 1.7% | 895.79 ± 0.1% | 15.74 ± 5.7% | 9179.07 ± 0.7% | 37.23 ± 0.3% | refused | differs | 25448.61 ± 1.0% | 28.50 | 1.00 | 2.78 | 685.76 |
| literal: an href attribute | 33 | 26566.83 ± 1.5% | 902.09 ± 0.6% | 18.87 ± 0.3% | 27142.13 ± 0.7% | 2055.87 ± 0.8% | 8.29 ± 0.6% | 67.42 ± 0.8% | 26462.68 ± 1.7% | 29.45 | 1.00 | 0.98 | 12.92 |
| literal: a word, second text | 123 | 32472.53 ± 3.0% | 899.70 ± 1.1% | 19.87 ± 0.2% | 31660.24 ± 1.5% | 7198.70 ± 7.4% | 11.89 ± 0.2% | 66.02 ± 5.4% | 32237.75 ± 1.6% | 36.09 | 1.01 | 1.03 | 4.51 |
| class: two capitalized words | 1331 | 777.07 ± 0.3% | 828.42 ± 0.5% | 18.85 ± 4.4% | 506.21 ± 0.1% | 34.18 ± 7.0% | 9.40 ± 0.4% | 59.41 ± 0.9% | 777.43 ± 1.4% | 0.94 | 1.00 | 1.54 | 22.73 |
| class: a word that ends in ing | 3399 | 759.10 ± 0.3% | 758.89 ± 1.4% | 13.54 ± 0.3% | 472.18 ± 1.0% | 25.66 ± 6.1% | 5.34 ± 0.4% | 16.98 ± 6.9% | 758.78 ± 1.6% | 1.00 | 1.00 | 1.61 | 29.59 |
| class: a word in capitals | 2332 | 978.25 ± 0.3% | 804.61 ± 1.1% | 19.74 ± 2.6% | 496.70 ± 0.3% | 35.83 ± 7.1% | 10.53 ± 1.3% | 77.12 ± 0.6% | 979.70 ± 0.2% | 1.22 | 1.00 | 1.97 | 27.30 |
| class: a number | 8288 | 1374.96 ± 2.5% | 695.09 ± 0.2% | 19.43 ± 0.5% | 1483.68 ± 0.4% | 34.46 ± 12.9% | 0.34 ± 0.4% | 56.42 ± 0.5% | 1376.59 ± 0.1% | 1.98 | 1.00 | 0.93 | 39.90 |
| class: two capitalized words, second text | 5359 | 621.98 ± 0.4% | 619.50 ± 0.4% | 17.38 ± 1.0% | 417.51 ± 0.3% | 30.09 ± 13.1% | 10.64 ± 0.3% | 54.86 ± 2.1% | 620.80 ± 0.5% | 1.00 | 1.00 | 1.49 | 20.67 |
| other: a word between two words | 6104 | 694.26 ± 2.1% | 649.35 ± 1.5% | 16.84 ± 1.8% | 686.67 ± 5.8% | 96.29 ± 12.9% | 7.29 ± 1.4% | 60.94 ± 6.0% | 682.71 ± 9.8% | 1.07 | 1.02 | 1.01 | 7.21 |
| other: a number before a unit, second text | 1481 | 7023.37 ± 5.9% | 842.40 ± 0.1% | 18.78 ± 0.5% | 6424.07 ± 6.1% | 35.09 ± 0.4% | 11.07 ± 0.5% | 58.42 ± 1.2% | 7040.60 ± 0.9% | 8.34 | 1.00 | 1.09 | 200.18 |
| other: a heading's start tag | 110 | 18732.54 ± 0.7% | 894.74 ± 0.2% | 19.57 ± 0.4% | 2001.83 ± 0.3% | 1473.72 ± 4.2% | 10.10 ± 0.4% | 78.65 ± 6.1% | 18586.98 ± 1.9% | 20.94 | 1.01 | 9.36 | 12.71 |
| other: a whole word | 217 | 22285.22 ± 5.5% | 895.77 ± 0.2% | 20.87 ± 1.0% | 22590.14 ± 0.9% | 41.22 ± 0.3% | 9.52 ± 0.4% | 46.26 ± 0.7% | 22027.35 ± 3.9% | 24.88 | 1.01 | 0.99 | 540.66 |
| other: a line's first word, second text | 3716 | 1910.91 ± 1.7% | 746.41 ± 0.1% | 24.39 ± 0.3% | 1735.36 ± 3.5% | 53.19 ± 5.4% | refused | refused | 1908.43 ± 0.4% | 2.56 | 1.00 | 1.10 | 35.92 |
| other: fourteen octets before an x | 87 | 25015.79 ± 2.7% | 199.65 ± 2.8% | 5.57 ± 4.0% | 2888.52 ± 0.9% | 8.98 ± 6.6% | differs | 17.07 ± 10.5% | 24996.23 ± 1.7% | 125.30 | 1.00 | 8.66 | 2785.77 |
| other: a Greek word | 21815 | 401.94 ± 0.4% | 338.07 ± 0.2% | 24.26 ± 5.4% | 253.70 ± 6.2% | 38.46 ± 3.6% | differs | refused | 400.30 ± 0.4% | 1.19 | 1.00 | 1.58 | 10.45 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.23 ± 1.8% | 24.29 ± 4.2% | 0.80 ± 10.1% | 16.79 ± 4.3% | 2.34 ± 1.8% | differs | 3.47 ± 10.8% | 24.39 ± 1.9% | 1.00 | 0.99 | 1.44 | 10.36 |
| a UUID | 32895 | 20.43 ± 0.2% | 20.39 ± 1.1% | 0.55 ± 0.5% | 12.83 ± 0.4% | 2.53 ± 3.6% | 0.43 ± 0.2% | 3.19 ± 12.5% | 20.43 ± 0.1% | 1.00 | 1.00 | 1.59 | 8.08 |
| an IPv4 address | 33176 | 33.57 ± 0.7% | 33.52 ± 0.6% | 1.80 ± 0.6% | 23.94 ± 4.0% | 5.80 ± 4.4% | differs | 3.44 ± 2.6% | 32.20 ± 0.3% | 1.00 | 1.04 | 1.40 | 5.79 |
| a date and time | 32954 | 30.12 ± 0.6% | 29.97 ± 0.7% | 1.27 ± 0.4% | 18.00 ± 0.3% | 6.69 ± 0.2% | 0.75 ± 1.6% | 6.04 ± 1.4% | 29.81 ± 0.5% | 1.01 | 1.01 | 1.67 | 4.50 |
| a field path | 32606 | 27.18 ± 0.4% | 27.16 ± 0.7% | 0.90 ± 1.7% | 19.40 ± 1.5% | 2.92 ± 24.3% | differs | 2.32 ± 2.1% | 27.11 ± 1.2% | 1.00 | 1.00 | 1.40 | 9.30 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.28 ± 16.6% | 8.27 ± 0.5% | 8.25 ± 0.5% | 10.64 ± 0.2% | 4.70 ± 1.8% | 0.62 ± 0.2% | none | 8.28 ± 17.4% | 1.00 | 1.00 | 0.78 | 1.76 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 189.51 ± 7.8% | 190.70 ± 0.5% | 224.67 ± 0.5% | 79.95 ± 18.2% | 180.97 ± 1.9% | 523.57 ± 9.8% | 3903.06 ± 7.2% | 189.76 ± 0.4% | 0.99 | 1.00 | 2.37 | 1.05 |
| a UUID | 62 | 123.80 ± 0.5% | 124.16 ± 0.6% | 139.00 ± 0.9% | 46.43 ± 1.5% | 89.66 ± 2.9% | 195.91 ± 8.4% | 3929.05 ± 0.4% | 123.62 ± 0.3% | 1.00 | 1.00 | 2.67 | 1.38 |
| an IPv4 address | 29 | 380.99 ± 0.9% | 383.46 ± 0.9% | 545.77 ± 2.3% | 70.13 ± 7.2% | 111.89 ± 2.7% | 309.56 ± 14.1% | 6874.66 ± 1.4% | 382.45 ± 0.7% | 0.99 | 1.00 | 5.43 | 3.40 |
| a date and time | 56 | 278.58 ± 0.9% | 281.26 ± 0.3% | 357.46 ± 0.7% | 68.91 ± 0.5% | 122.22 ± 2.4% | 363.72 ± 0.8% | 3690.94 ± 2.5% | 278.75 ± 0.5% | 0.99 | 1.00 | 4.04 | 2.28 |
| a field path | 39 | 187.55 ± 0.2% | 188.30 ± 0.7% | 220.63 ± 7.3% | 74.02 ± 1.2% | 170.40 ± 8.8% | 571.36 ± 1.5% | 4746.29 ± 3.9% | 187.16 ± 0.5% | 1.00 | 1.00 | 2.53 | 1.10 |
| literal: a word | 7 | 556.63 ± 13.4% | 606.59 ± 9.3% | 1115.94 ± 2.6% | 485.50 ± 3.1% | 562.52 ± 4.2% | 1235.51 ± 1.9% | 24409.78 ± 2.9% | 567.63 ± 2.8% | 0.92 | 0.98 | 1.15 | 0.99 |
| literal: a word that is not there | 8 | 545.32 ± 13.2% | 591.48 ± 5.9% | 1056.97 ± 0.2% | 454.77 ± 0.9% | 545.76 ± 2.1% | 1180.17 ± 0.9% | 23763.24 ± 1.7% | 546.42 ± 0.5% | 0.92 | 1.00 | 1.20 | 1.00 |
| literal: one of four words | 26 | 214.68 ± 2.0% | 359.84 ± 1.2% | 493.46 ± 0.5% | 41.88 ± 0.6% | 218.94 ± 2.8% | 450.71 ± 0.8% | 12833.42 ± 1.2% | 214.94 ± 0.2% | 0.60 | 1.00 | 5.13 | 0.98 |
| literal: a word in any case | 11 | 438.59 ± 0.7% | 468.96 ± 0.9% | 732.68 ± 0.9% | 14.62 ± 1.4% | 604.03 ± 0.8% | refused | 19757.25 ± 1.0% | 438.05 ± 2.0% | 0.94 | 1.00 | 30.00 | 0.73 |
| literal: an href attribute | 12 | 314.15 ± 9.7% | 324.23 ± 6.4% | 440.12 ± 0.8% | 36.99 ± 0.8% | 416.13 ± 1.8% | 964.95 ± 0.5% | 17398.96 ± 2.4% | 314.47 ± 0.4% | 0.97 | 1.00 | 8.49 | 0.75 |
| literal: a word, second text | 10 | 507.46 ± 1.2% | 556.74 ± 15.2% | 953.65 ± 3.1% | 410.34 ± 0.3% | 480.22 ± 0.9% | 1022.76 ± 2.7% | 21419.31 ± 12.1% | 506.85 ± 11.6% | 0.91 | 1.00 | 1.24 | 1.06 |
| class: two capitalized words | 23 | 407.64 ± 8.5% | 437.76 ± 0.6% | 655.41 ± 3.0% | 94.57 ± 2.0% | 443.32 ± 3.2% | 894.67 ± 19.3% | 6291.57 ± 21.8% | 407.79 ± 0.2% | 0.93 | 1.00 | 4.31 | 0.92 |
| class: a word that ends in ing | 9 | 491.00 ± 0.6% | 549.73 ± 1.1% | 1017.00 ± 12.9% | 115.85 ± 11.4% | 618.19 ± 10.3% | 1404.23 ± 0.5% | 15409.72 ± 0.7% | 490.74 ± 0.4% | 0.89 | 1.00 | 4.24 | 0.79 |
| class: a word in capitals | 16 | 422.44 ± 8.3% | 456.72 ± 0.4% | 778.63 ± 0.3% | 121.41 ± 0.5% | 636.53 ± 3.2% | 1291.71 ± 1.2% | 8272.54 ± 13.6% | 422.73 ± 8.4% | 0.92 | 1.00 | 3.48 | 0.66 |
| class: a number | 6 | 527.45 ± 0.5% | 582.71 ± 3.3% | 1160.39 ± 1.6% | 36.38 ± 0.7% | 1159.77 ± 2.4% | 2194.52 ± 5.7% | 20703.88 ± 0.8% | 525.62 ± 1.0% | 0.91 | 1.00 | 14.50 | 0.45 |
| class: two capitalized words, second text | 23 | 407.82 ± 1.5% | 436.78 ± 2.2% | 637.59 ± 10.7% | 94.82 ± 3.3% | 445.28 ± 5.2% | 949.35 ± 4.7% | 6289.23 ± 0.5% | 406.98 ± 0.7% | 0.93 | 1.00 | 4.30 | 0.92 |
| other: a word between two words | 13 | 487.95 ± 0.3% | 506.06 ± 0.5% | 820.91 ± 0.9% | 122.78 ± 0.8% | 433.26 ± 1.1% | 1006.89 ± 12.1% | 14175.01 ± 1.4% | 486.81 ± 12.9% | 0.96 | 1.00 | 3.97 | 1.13 |
| other: a number before a unit, second text | 15 | 353.58 ± 0.4% | 393.22 ± 0.6% | 555.76 ± 0.4% | 33.63 ± 11.1% | 534.14 ± 1.3% | 1133.73 ± 2.6% | 12595.93 ± 1.3% | 353.65 ± 0.5% | 0.90 | 1.00 | 10.51 | 0.66 |
| other: a heading's start tag | 13 | 326.19 ± 1.2% | 330.23 ± 1.4% | 455.40 ± 0.8% | 35.11 ± 1.6% | 510.84 ± 3.1% | 1074.21 ± 1.3% | 15191.09 ± 13.6% | 324.94 ± 0.4% | 0.99 | 1.00 | 9.29 | 0.64 |
| other: a whole word | 11 | 498.56 ± 0.7% | 526.54 ± 0.6% | 871.13 ± 0.8% | 110.15 ± 10.4% | 499.49 ± 4.9% | 1042.98 ± 3.7% | 21850.28 ± 12.0% | 498.14 ± 0.8% | 0.95 | 1.00 | 4.53 | 1.00 |
| other: a line's first word, second text | 17 | 473.20 ± 7.4% | 492.13 ± 0.7% | 832.95 ± 0.3% | 115.87 ± 1.9% | 585.94 ± 1.9% | refused | refused | 473.97 ± 0.3% | 0.96 | 1.00 | 4.08 | 0.81 |
| other: fourteen octets before an x | 16 | 87.00 ± 0.5% | 123.52 ± 1.6% | 144.84 ± 0.4% | 14.13 ± 0.9% | 388.28 ± 1.1% | 460.12 ± 20.1% | 11753.86 ± 0.6% | 87.15 ± 0.3% | 0.70 | 1.00 | 6.16 | 0.22 |
| other: a Greek word | 8 | 354.68 ± 0.8% | 498.94 ± 0.8% | 859.18 ± 0.4% | 46.79 ± 0.6% | 1144.31 ± 2.6% | 2141.87 ± 0.8% | refused | 355.23 ± 0.8% | 0.71 | 1.00 | 7.58 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21664.76 ± 1.6% | not timed | not timed | 26630.22 ± 0.3% | 1898.42 ± 24.8% | not timed | not timed | 21583.15 ± 11.7% | | 1.00 | 0.81 | 11.41 |
| 01-literal/sherlock-casei-en | 522 | 6284.87 ± 9.0% | not timed | not timed | 7033.72 ± 7.1% | 28.48 ± 1.0% | not timed | not timed | 6268.37 ± 0.8% | | 1.00 | 0.89 | 220.66 |
| 01-literal/sherlock-ru | 724 | 23257.34 ± 1.8% | not timed | not timed | 27551.75 ± 1.0% | 1041.68 ± 10.2% | not timed | not timed | 23108.87 ± 14.0% | | 1.01 | 0.84 | 22.33 |
| 01-literal/sherlock-casei-ru | 746 | 7350.73 ± 0.6% | not timed | not timed | 5514.33 ± 6.0% | 30.35 ± 1.4% | not timed | not timed | 7319.26 ± 0.3% | | 1.00 | 1.33 | 242.24 |
| 01-literal/sherlock-zh | 30 | 41021.17 ± 2.2% | not timed | not timed | 36550.08 ± 12.6% | 1259.43 ± 0.8% | not timed | not timed | 41031.21 ± 2.5% | | 1.00 | 1.12 | 32.57 |
| 02-literal-alternate/sherlock-en | 714 | 9691.04 ± 1.4% | not timed | not timed | 8860.74 ± 1.0% | 13.66 ± 16.7% | not timed | not timed | 9703.39 ± 0.5% | | 1.00 | 1.09 | 709.28 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1833.78 ± 0.4% | not timed | not timed | 1816.37 ± 11.6% | 9.24 ± 0.4% | not timed | not timed | 1811.96 ± 0.6% | | 1.01 | 1.01 | 198.45 |
| 02-literal-alternate/sherlock-ru | 899 | 5934.76 ± 0.8% | not timed | not timed | 4247.91 ± 3.6% | 16.42 ± 8.0% | not timed | not timed | 5953.33 ± 2.0% | | 1.00 | 1.40 | 361.38 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1853.38 ± 2.7% | not timed | not timed | 1045.71 ± 8.5% | 8.40 ± 2.8% | not timed | not timed | 1872.02 ± 4.0% | | 0.99 | 1.77 | 220.75 |
| 02-literal-alternate/sherlock-zh | 207 | 13967.70 ± 1.6% | not timed | not timed | 10365.25 ± 1.0% | 26.35 ± 15.2% | not timed | not timed | 13970.15 ± 0.7% | | 1.00 | 1.35 | 529.99 |
| 03-date/ascii | 111817 | 98.83 ± 0.3% | not timed | not timed | 84.13 ± 0.7% | 0.17 ± 1.5% | not timed | not timed | 99.13 ± 0.6% | | 1.00 | 1.17 | 577.37 |
| 04-ruff-noqa/real | 84 | 566.89 ± 1.0% | not timed | not timed | 436.21 ± 0.3% | 15.39 ± 1.9% | not timed | not timed | 566.67 ± 0.6% | | 1.00 | 1.30 | 36.83 |
| 04-ruff-noqa/tweaked | 44 | 482.26 ± 0.7% | not timed | not timed | 414.65 ± 0.5% | 287.53 ± 5.2% | not timed | not timed | 478.14 ± 1.1% | | 1.01 | 1.16 | 1.68 |
| 05-lexer-veryl/single | 124800 | 3.08 ± 0.5% | not timed | not timed | 4.24 ± 1.1% | 0.21 ± 3.9% | not timed | not timed | 3.06 ± 4.1% | | 1.00 | 0.72 | 14.79 |
| 06-cloud-flare-redos/original | 107 | 221.65 ± 0.5% | not timed | not timed | 189.62 ± 0.8% | 20.53 ± 0.4% | not timed | not timed | 221.01 ± 0.9% | | 1.00 | 1.17 | 10.80 |
| 06-cloud-flare-redos/simplified-short | 102 | 214.50 ± 1.2% | not timed | not timed | 191.90 ± 0.4% | 21.82 ± 0.8% | not timed | not timed | 213.95 ± 0.8% | | 1.00 | 1.12 | 9.83 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.52 ± 2.8% | not timed | not timed | 211.43 ± 0.7% | 24.04 ± 0.2% | not timed | not timed | 245.86 ± 0.5% | | 1.00 | 1.17 | 10.25 |
| 07-unicode-character-data/parse-line | 558784 | 188.90 ± 0.4% | not timed | not timed | 162.31 ± 0.3% | 35.87 ± 28.0% | not timed | not timed | 186.74 ± 2.0% | | 1.01 | 1.16 | 5.27 |
| 08-words/all-english | 56691 | 93.26 ± 1.3% | not timed | not timed | 73.67 ± 0.3% | 10.28 ± 4.5% | not timed | not timed | 94.22 ± 2.1% | | 0.99 | 1.27 | 9.07 |
| 08-words/long-english | 839 | 855.70 ± 0.4% | not timed | not timed | 514.47 ± 0.1% | 26.58 ± 23.1% | not timed | not timed | 856.34 ± 0.4% | | 1.00 | 1.66 | 32.19 |
| 09-aws-keys/full | 0 | 424.64 ± 1.3% | not timed | not timed | 448.02 ± 0.9% | 54.44 ± 2.8% | not timed | not timed | 429.63 ± 0.2% | | 0.99 | 0.95 | 7.80 |
| 09-aws-keys/quick | 0 | 818.17 ± 10.1% | not timed | not timed | 802.82 ± 2.3% | 330.74 ± 5.6% | not timed | not timed | 806.03 ± 0.2% | | 1.02 | 1.02 | 2.47 |
| 10-bounded-repeat/letters-en | 1833 | 494.17 ± 1.9% | not timed | not timed | 426.59 ± 1.7% | 16.46 ± 3.6% | not timed | not timed | 494.32 ± 1.9% | | 1.00 | 1.16 | 30.02 |
| 10-bounded-repeat/letters-ru | 3475 | 314.64 ± 0.3% | not timed | not timed | 407.38 ± 2.0% | 19.37 ± 13.3% | not timed | not timed | 317.93 ± 0.3% | | 0.99 | 0.77 | 16.25 |
| 10-bounded-repeat/context | 53 | 65.17 ± 1.2% | not timed | not timed | 56.24 ± 0.9% | 17.00 ± 0.6% | not timed | not timed | 64.06 ± 0.6% | | 1.02 | 1.16 | 3.83 |
| 10-bounded-repeat/capitals | 11 | 894.49 ± 0.7% | not timed | not timed | 531.80 ± 0.6% | 30.97 ± 0.4% | not timed | not timed | 896.12 ± 0.7% | | 1.00 | 1.68 | 28.89 |
| 11-unstructured-to-json/extract | 600 | 37.16 ± 1.0% | not timed | not timed | 60.54 ± 1.4% | 40.76 ± 0.7% | not timed | not timed | 37.00 ± 1.1% | | 1.00 | 0.61 | 0.91 |
| 12-dictionary/single | 1 | 460.96 ± 1.2% | not timed | not timed | 442.22 ± 1.4% | 0.32 ± 0.2% | not timed | not timed | 463.74 ± 0.3% | | 0.99 | 1.04 | 1426.68 |
| 14-quadratic/1x | 100 | 10.10 ± 0.6% | not timed | not timed | 9.12 ± 0.4% | 0.81 ± 3.5% | not timed | not timed | 10.11 ± 12.2% | | 1.00 | 1.11 | 12.48 |
| 14-quadratic/2x | 200 | 6.43 ± 0.7% | not timed | not timed | 4.92 ± 0.3% | 0.42 ± 0.8% | not timed | not timed | 6.46 ± 1.2% | | 1.00 | 1.31 | 15.16 |
| 14-quadratic/10x | 1000 | 1.57 ± 0.5% | not timed | not timed | 1.05 ± 1.3% | 0.09 ± 0.6% | not timed | not timed | 1.57 ± 3.4% | | 1.00 | 1.49 | 16.71 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.7% | not timed | not timed | 0.39 ± 0.3% | 0.48 ± 2.1% | not timed | not timed | 1.28 ± 1.0% | | 1.00 | 3.32 | 2.68 |
| 04-ruff-noqa/compile-real | 1 | 81.11 ± 0.7% | not timed | not timed | 13.02 ± 0.4% | 122.10 ± 3.6% | not timed | not timed | 80.66 ± 2.0% | | 1.01 | 6.23 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 12.65 ± 0.7% | not timed | not timed | 2.38 ± 1.3% | 5.83 ± 1.8% | not timed | not timed | 12.69 ± 1.4% | | 1.00 | 5.32 | 2.17 |
| 07-unicode-character-data/compile | 1 | 51.14 ± 0.7% | not timed | not timed | 24.44 ± 0.6% | 32.63 ± 2.8% | not timed | not timed | 51.09 ± 0.6% | | 1.00 | 2.09 | 1.57 |
| 09-aws-keys/compile-full | 1 | 34.95 ± 13.2% | not timed | not timed | 7.42 ± 7.6% | 20.02 ± 11.8% | not timed | not timed | 34.89 ± 6.4% | | 1.00 | 4.71 | 1.75 |
| 09-aws-keys/compile-quick | 1 | 156.41 ± 0.7% | not timed | not timed | 45.63 ± 2.7% | 116.42 ± 1.9% | not timed | not timed | 155.91 ± 1.0% | | 1.00 | 3.43 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 10.49 ± 0.6% | not timed | not timed | 11.69 ± 0.2% | 14.96 ± 15.1% | not timed | not timed | 10.40 ± 3.4% | | 1.01 | 0.90 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 72.20 ± 0.5% | not timed | not timed | 8.87 ± 0.6% | 22.22 ± 2.0% | not timed | not timed | 71.86 ± 0.7% | | 1.00 | 8.14 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 76.61 ± 0.6% | not timed | not timed | 37.29 ± 0.9% | 59.35 ± 3.0% | not timed | not timed | 75.82 ± 2.2% | | 1.01 | 2.05 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.7% | not timed | not timed | 0.07 ± 18.6% | 0.09 ± 20.1% | not timed | not timed | 0.29 ± 0.4% | | 1.00 | 4.28 | 3.09 |

