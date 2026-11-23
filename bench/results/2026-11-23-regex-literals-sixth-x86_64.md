# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243483671 |
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
| literal: a word | 217 | 40092.05 ± 3.1% | 3351.17 ± 0.2% | 20.08 ± 0.5% | 31275.68 ± 0.6% | 9004.57 ± 8.4% | 10.92 ± 0.5% | 76.26 ± 0.8% | 38980.22 ± 1.6% | 11.96 | 1.03 | 1.28 | 4.45 |
| literal: a word that is not there | 0 | 53647.23 ± 1.3% | 3241.84 ± 0.2% | 20.01 ± 1.0% | 40013.02 ± 0.8% | 30029.71 ± 1.7% | 10.85 ± 0.2% | 72.35 ± 1.3% | 53281.39 ± 1.0% | 16.55 | 1.01 | 1.34 | 1.79 |
| literal: one of four words | 661 | 11563.46 ± 4.3% | 1391.69 ± 1.6% | 11.06 ± 0.9% | 9108.13 ± 2.9% | 18.93 ± 13.4% | 3.94 ± 1.2% | 6.02 ± 5.6% | 11551.82 ± 13.4% | 8.31 | 1.00 | 1.27 | 610.86 |
| literal: a word in any case | 217 | 30271.24 ± 0.6% | 1490.87 ± 0.4% | 15.50 ± 5.2% | 9267.36 ± 0.3% | 37.19 ± 5.7% | refused | differs | 30302.56 ± 1.4% | 20.30 | 1.00 | 3.27 | 814.05 |
| literal: an href attribute | 33 | 29301.44 ± 4.6% | 539.30 ± 0.2% | 18.78 ± 0.4% | 27532.94 ± 0.3% | 2050.12 ± 4.5% | 8.34 ± 0.2% | 63.21 ± 0.3% | 29400.68 ± 3.8% | 54.33 | 1.00 | 1.06 | 14.29 |
| literal: a word, second text | 123 | 37847.76 ± 0.6% | 2377.14 ± 4.1% | 19.98 ± 0.4% | 32182.30 ± 0.9% | 7330.78 ± 5.4% | 11.98 ± 0.1% | 65.74 ± 9.3% | 37842.55 ± 6.2% | 15.92 | 1.00 | 1.18 | 5.16 |
| class: two capitalized words | 1331 | 763.93 ± 2.3% | 526.73 ± 0.2% | 18.87 ± 0.5% | 504.93 ± 0.3% | 34.15 ± 2.4% | 9.46 ± 0.5% | 57.36 ± 0.2% | 764.86 ± 0.3% | 1.45 | 1.00 | 1.51 | 22.37 |
| class: a word that ends in ing | 3399 | 499.34 ± 0.7% | 498.04 ± 1.4% | 12.94 ± 0.3% | 472.93 ± 0.6% | 25.27 ± 1.9% | 5.32 ± 0.2% | 16.50 ± 1.0% | 499.72 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.76 |
| class: a word in capitals | 2332 | 942.11 ± 0.2% | 530.04 ± 0.2% | 19.79 ± 7.9% | 497.73 ± 0.4% | 36.47 ± 13.4% | 10.49 ± 0.5% | 77.67 ± 0.2% | 941.91 ± 0.2% | 1.78 | 1.00 | 1.89 | 25.83 |
| class: a number | 8288 | 1445.27 ± 3.5% | 700.08 ± 0.3% | 19.67 ± 0.4% | 1479.98 ± 2.1% | 37.18 ± 9.8% | 0.34 ± 0.5% | 55.50 ± 1.2% | 1443.92 ± 0.3% | 2.06 | 1.00 | 0.98 | 38.87 |
| class: two capitalized words, second text | 5359 | 443.11 ± 0.2% | 449.73 ± 0.3% | 16.97 ± 4.8% | 416.75 ± 1.1% | 28.81 ± 11.5% | 10.61 ± 0.8% | 52.77 ± 0.5% | 443.62 ± 0.5% | 0.99 | 1.00 | 1.06 | 15.38 |
| other: a word between two words | 6104 | 709.93 ± 0.3% | 511.31 ± 0.3% | 16.93 ± 0.2% | 698.13 ± 0.5% | 96.35 ± 6.4% | 7.33 ± 0.1% | 58.17 ± 0.9% | 711.85 ± 0.1% | 1.39 | 1.00 | 1.02 | 7.37 |
| other: a number before a unit, second text | 1481 | 7262.90 ± 0.7% | 857.62 ± 3.7% | 18.82 ± 0.5% | 6299.07 ± 0.8% | 34.85 ± 0.3% | 11.02 ± 0.3% | 56.20 ± 2.0% | 7264.45 ± 0.8% | 8.47 | 1.00 | 1.15 | 208.39 |
| other: a heading's start tag | 110 | 19693.34 ± 2.1% | 653.51 ± 1.4% | 19.54 ± 2.3% | 1964.95 ± 2.8% | 1397.37 ± 12.2% | 10.07 ± 1.2% | 74.25 ± 2.1% | 19625.73 ± 9.6% | 30.13 | 1.00 | 10.02 | 14.09 |
| other: a whole word | 217 | 23593.71 ± 1.9% | 531.89 ± 0.2% | 20.44 ± 10.0% | 22836.68 ± 0.4% | 39.34 ± 0.5% | 9.57 ± 0.8% | 46.65 ± 1.1% | 23511.41 ± 0.9% | 44.36 | 1.00 | 1.03 | 599.81 |
| other: a line's first word, second text | 3716 | 1997.72 ± 4.6% | 513.90 ± 0.3% | 24.22 ± 0.4% | 1730.44 ± 2.8% | 52.23 ± 13.4% | refused | refused | 1988.87 ± 3.3% | 3.89 | 1.00 | 1.15 | 38.25 |
| other: fourteen octets before an x | 87 | 27007.16 ± 0.7% | 209.13 ± 1.3% | 5.42 ± 2.4% | 2956.58 ± 0.7% | 8.74 ± 2.1% | differs | 14.87 ± 6.6% | 27008.06 ± 0.6% | 129.14 | 1.00 | 9.13 | 3088.42 |
| other: a Greek word | 21815 | 382.74 ± 3.6% | 332.65 ± 3.3% | 24.06 ± 0.4% | 265.09 ± 0.3% | 44.03 ± 6.4% | differs | refused | 382.42 ± 0.4% | 1.15 | 1.00 | 1.44 | 8.69 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.84 ± 6.6% | 16.98 ± 0.4% | 0.76 ± 8.9% | 17.03 ± 4.1% | 2.33 ± 0.7% | differs | 3.62 ± 0.2% | 16.99 ± 0.5% | 0.99 | 0.99 | 0.99 | 7.23 |
| a UUID | 32895 | 18.43 ± 0.5% | 18.48 ± 0.8% | 0.54 ± 2.0% | 12.88 ± 0.2% | 2.49 ± 2.1% | 0.43 ± 0.1% | 3.04 ± 1.7% | 18.44 ± 0.5% | 1.00 | 1.00 | 1.43 | 7.39 |
| an IPv4 address | 33176 | 30.54 ± 2.4% | 30.13 ± 2.3% | 1.76 ± 0.3% | 24.27 ± 0.5% | 5.33 ± 1.1% | differs | 3.41 ± 0.7% | 30.46 ± 2.6% | 1.01 | 1.00 | 1.26 | 5.73 |
| a date and time | 32954 | 27.28 ± 0.8% | 27.36 ± 0.6% | 1.24 ± 1.8% | 18.08 ± 0.3% | 6.61 ± 0.7% | 0.75 ± 0.7% | 6.05 ± 1.2% | 27.08 ± 0.6% | 1.00 | 1.01 | 1.51 | 4.13 |
| a field path | 32606 | 19.92 ± 0.7% | 19.94 ± 0.9% | 0.77 ± 0.5% | 19.63 ± 1.6% | 2.88 ± 2.8% | differs | 2.44 ± 0.4% | 19.92 ± 0.4% | 1.00 | 1.00 | 1.02 | 6.92 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.77 ± 0.3% | 8.77 ± 0.5% | 8.78 ± 0.3% | 10.64 ± 0.2% | 4.73 ± 2.3% | 0.62 ± 0.3% | none | 8.77 ± 17.7% | 1.00 | 1.00 | 0.82 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 188.53 ± 0.9% | 189.42 ± 0.9% | 216.75 ± 0.5% | 80.47 ± 6.2% | 186.32 ± 2.4% | 538.76 ± 2.8% | 3540.72 ± 4.4% | 189.04 ± 0.2% | 1.00 | 1.00 | 2.34 | 1.01 |
| a UUID | 62 | 122.75 ± 0.6% | 122.93 ± 1.1% | 135.28 ± 0.6% | 46.40 ± 1.6% | 90.14 ± 0.6% | 200.80 ± 1.8% | 3856.75 ± 0.2% | 122.62 ± 0.5% | 1.00 | 1.00 | 2.65 | 1.36 |
| an IPv4 address | 29 | 381.21 ± 0.9% | 384.78 ± 0.3% | 517.93 ± 1.1% | 71.28 ± 0.9% | 114.02 ± 1.5% | 326.56 ± 3.4% | 6565.16 ± 0.7% | 383.10 ± 1.5% | 0.99 | 1.00 | 5.35 | 3.34 |
| a date and time | 56 | 277.87 ± 1.1% | 279.86 ± 0.3% | 342.78 ± 0.3% | 68.17 ± 0.5% | 123.13 ± 2.4% | 372.89 ± 2.8% | 3864.64 ± 2.3% | 278.06 ± 0.9% | 0.99 | 1.00 | 4.08 | 2.26 |
| a field path | 39 | 185.08 ± 6.5% | 185.87 ± 0.4% | 213.07 ± 5.0% | 76.51 ± 5.7% | 173.17 ± 4.0% | 621.97 ± 9.4% | 4432.98 ± 3.1% | 185.24 ± 0.4% | 1.00 | 1.00 | 2.42 | 1.07 |
| literal: a word | 7 | 589.14 ± 0.9% | 633.54 ± 0.4% | 1073.71 ± 0.1% | 491.94 ± 0.5% | 587.21 ± 1.7% | 1263.73 ± 0.8% | 24608.54 ± 1.4% | 587.39 ± 0.6% | 0.93 | 1.00 | 1.20 | 1.00 |
| literal: a word that is not there | 8 | 564.06 ± 0.3% | 614.29 ± 0.5% | 1010.73 ± 0.3% | 453.08 ± 1.0% | 557.87 ± 2.3% | 1185.90 ± 1.2% | 23397.83 ± 1.1% | 562.66 ± 1.4% | 0.92 | 1.00 | 1.24 | 1.01 |
| literal: one of four words | 26 | 217.64 ± 1.2% | 362.02 ± 0.7% | 475.79 ± 9.9% | 41.90 ± 1.5% | 218.51 ± 2.8% | 445.57 ± 3.1% | 9888.63 ± 2.3% | 217.84 ± 8.5% | 0.60 | 1.00 | 5.19 | 1.00 |
| literal: a word in any case | 11 | 398.13 ± 2.4% | 420.31 ± 2.4% | 579.83 ± 1.9% | 14.76 ± 5.3% | 619.37 ± 5.1% | refused | 18815.52 ± 14.6% | 397.60 ± 2.0% | 0.95 | 1.00 | 26.97 | 0.64 |
| literal: an href attribute | 12 | 319.30 ± 1.6% | 329.64 ± 0.4% | 426.59 ± 3.2% | 37.29 ± 16.9% | 435.50 ± 1.4% | 954.78 ± 1.1% | 17618.93 ± 1.2% | 318.86 ± 10.3% | 0.97 | 1.00 | 8.56 | 0.73 |
| literal: a word, second text | 10 | 520.51 ± 0.5% | 573.71 ± 0.4% | 903.57 ± 0.1% | 413.61 ± 0.8% | 491.69 ± 1.2% | 1006.63 ± 1.0% | 19939.33 ± 0.3% | 521.51 ± 0.2% | 0.91 | 1.00 | 1.26 | 1.06 |
| class: two capitalized words | 23 | 418.16 ± 8.1% | 450.41 ± 2.8% | 638.00 ± 4.0% | 95.90 ± 0.4% | 449.90 ± 1.5% | 938.72 ± 1.3% | 6128.31 ± 0.3% | 419.32 ± 1.5% | 0.93 | 1.00 | 4.36 | 0.93 |
| class: a word that ends in ing | 9 | 510.03 ± 0.4% | 585.81 ± 1.4% | 991.77 ± 0.7% | 116.47 ± 0.2% | 637.02 ± 1.7% | 1387.77 ± 11.3% | 14816.89 ± 14.0% | 510.04 ± 0.3% | 0.87 | 1.00 | 4.38 | 0.80 |
| class: a word in capitals | 16 | 444.63 ± 0.3% | 481.68 ± 1.1% | 766.39 ± 0.2% | 123.57 ± 1.6% | 650.68 ± 3.4% | 1316.24 ± 1.0% | 8225.89 ± 0.7% | 445.37 ± 0.4% | 0.92 | 1.00 | 3.60 | 0.68 |
| class: a number | 6 | 576.09 ± 1.8% | 638.29 ± 0.5% | 1183.10 ± 0.4% | 36.82 ± 0.8% | 1166.97 ± 5.0% | 2200.72 ± 1.7% | 20209.82 ± 0.2% | 576.54 ± 0.2% | 0.90 | 1.00 | 15.65 | 0.49 |
| class: two capitalized words, second text | 23 | 418.88 ± 0.9% | 451.33 ± 0.3% | 636.27 ± 0.5% | 95.34 ± 2.1% | 458.15 ± 2.4% | 966.98 ± 0.5% | 6121.75 ± 12.2% | 419.25 ± 0.4% | 0.93 | 1.00 | 4.39 | 0.91 |
| other: a word between two words | 13 | 503.64 ± 0.7% | 524.78 ± 0.3% | 799.75 ± 2.4% | 123.82 ± 10.5% | 443.32 ± 2.2% | 1032.47 ± 0.3% | 12594.13 ± 3.4% | 503.86 ± 0.3% | 0.96 | 1.00 | 4.07 | 1.14 |
| other: a number before a unit, second text | 15 | 357.31 ± 0.5% | 400.84 ± 7.0% | 543.78 ± 0.2% | 33.75 ± 1.5% | 550.94 ± 12.2% | 1075.65 ± 11.8% | 12853.49 ± 0.4% | 358.01 ± 6.6% | 0.89 | 1.00 | 10.59 | 0.65 |
| other: a heading's start tag | 13 | 327.53 ± 4.1% | 335.41 ± 5.1% | 434.15 ± 8.7% | 35.70 ± 0.6% | 538.59 ± 3.0% | 1015.16 ± 0.8% | 15368.85 ± 4.0% | 327.98 ± 13.1% | 0.98 | 1.00 | 9.17 | 0.61 |
| other: a whole word | 11 | 500.90 ± 1.3% | 534.24 ± 0.9% | 813.31 ± 0.7% | 111.29 ± 1.6% | 514.34 ± 10.6% | 1073.15 ± 8.6% | 19172.25 ± 9.4% | 500.32 ± 0.2% | 0.94 | 1.00 | 4.50 | 0.97 |
| other: a line's first word, second text | 17 | 481.45 ± 0.6% | 510.80 ± 1.3% | 796.16 ± 0.2% | 116.89 ± 0.8% | 606.58 ± 1.7% | refused | refused | 480.92 ± 1.2% | 0.94 | 1.00 | 4.12 | 0.79 |
| other: fourteen octets before an x | 16 | 87.49 ± 0.5% | 124.40 ± 1.1% | 140.57 ± 0.6% | 14.13 ± 1.8% | 403.24 ± 16.8% | 437.13 ± 2.9% | 11747.37 ± 0.3% | 87.42 ± 1.0% | 0.70 | 1.00 | 6.19 | 0.22 |
| other: a Greek word | 8 | 387.78 ± 0.7% | 537.21 ± 1.8% | 882.43 ± 0.1% | 46.83 ± 0.5% | 1199.57 ± 1.8% | 2137.81 ± 0.6% | refused | 387.28 ± 0.2% | 0.72 | 1.00 | 8.28 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27267.91 ± 4.3% | not timed | not timed | 26917.11 ± 0.8% | 2004.17 ± 8.0% | not timed | not timed | 27209.57 ± 2.0% | | 1.00 | 1.01 | 13.61 |
| 01-literal/sherlock-casei-en | 522 | 7993.73 ± 1.1% | not timed | not timed | 7033.70 ± 0.7% | 23.51 ± 0.5% | not timed | not timed | 7965.12 ± 1.6% | | 1.00 | 1.14 | 340.02 |
| 01-literal/sherlock-ru | 724 | 28507.23 ± 1.8% | not timed | not timed | 27739.90 ± 0.4% | 1080.31 ± 4.4% | not timed | not timed | 28183.46 ± 11.4% | | 1.01 | 1.03 | 26.39 |
| 01-literal/sherlock-casei-ru | 746 | 9685.53 ± 0.7% | not timed | not timed | 5367.23 ± 0.4% | 29.81 ± 3.5% | not timed | not timed | 9660.52 ± 7.3% | | 1.00 | 1.80 | 324.88 |
| 01-literal/sherlock-zh | 30 | 47127.03 ± 1.4% | not timed | not timed | 36802.86 ± 0.3% | 1262.49 ± 0.9% | not timed | not timed | 46851.17 ± 0.7% | | 1.01 | 1.28 | 37.33 |
| 02-literal-alternate/sherlock-en | 714 | 10014.85 ± 1.3% | not timed | not timed | 8882.31 ± 1.3% | 14.82 ± 30.6% | not timed | not timed | 10050.68 ± 0.3% | | 1.00 | 1.13 | 675.87 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2030.14 ± 1.5% | not timed | not timed | 1812.79 ± 0.9% | 8.92 ± 0.2% | not timed | not timed | 2040.16 ± 1.4% | | 1.00 | 1.12 | 227.70 |
| 02-literal-alternate/sherlock-ru | 899 | 8153.45 ± 0.4% | not timed | not timed | 4260.05 ± 0.4% | 19.36 ± 0.8% | not timed | not timed | 8185.70 ± 1.0% | | 1.00 | 1.91 | 421.11 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2095.94 ± 0.6% | not timed | not timed | 1046.34 ± 0.2% | 8.45 ± 1.7% | not timed | not timed | 2097.19 ± 0.7% | | 1.00 | 2.00 | 248.12 |
| 02-literal-alternate/sherlock-zh | 207 | 14474.14 ± 0.7% | not timed | not timed | 10437.00 ± 0.8% | 27.79 ± 1.7% | not timed | not timed | 14481.24 ± 0.2% | | 1.00 | 1.39 | 520.78 |
| 03-date/ascii | 111817 | 96.66 ± 1.6% | not timed | not timed | 84.83 ± 2.4% | 0.18 ± 3.4% | not timed | not timed | 96.45 ± 0.2% | | 1.00 | 1.14 | 544.46 |
| 04-ruff-noqa/real | 84 | 410.87 ± 1.1% | not timed | not timed | 426.07 ± 0.5% | 15.97 ± 1.5% | not timed | not timed | 410.65 ± 0.1% | | 1.00 | 0.96 | 25.72 |
| 04-ruff-noqa/tweaked | 44 | 513.17 ± 14.2% | not timed | not timed | 420.20 ± 9.8% | 293.60 ± 0.5% | not timed | not timed | 496.47 ± 0.3% | | 1.03 | 1.22 | 1.75 |
| 05-lexer-veryl/single | 124800 | 3.48 ± 2.5% | not timed | not timed | 4.08 ± 0.5% | 0.21 ± 2.7% | not timed | not timed | 3.44 ± 1.0% | | 1.01 | 0.85 | 16.74 |
| 06-cloud-flare-redos/original | 107 | 348.29 ± 0.6% | not timed | not timed | 191.92 ± 0.4% | 20.70 ± 0.2% | not timed | not timed | 349.15 ± 0.2% | | 1.00 | 1.81 | 16.83 |
| 06-cloud-flare-redos/simplified-short | 102 | 329.36 ± 0.8% | not timed | not timed | 192.29 ± 0.1% | 21.97 ± 7.8% | not timed | not timed | 330.92 ± 0.7% | | 1.00 | 1.71 | 14.99 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.86 ± 0.2% | not timed | not timed | 211.69 ± 0.3% | 24.09 ± 0.9% | not timed | not timed | 465.31 ± 0.1% | | 1.00 | 2.20 | 19.29 |
| 07-unicode-character-data/parse-line | 558784 | 204.77 ± 0.5% | not timed | not timed | 161.10 ± 0.3% | 36.97 ± 5.4% | not timed | not timed | 202.25 ± 2.4% | | 1.01 | 1.27 | 5.54 |
| 08-words/all-english | 56691 | 96.43 ± 4.0% | not timed | not timed | 73.97 ± 0.5% | 10.27 ± 16.5% | not timed | not timed | 96.13 ± 8.5% | | 1.00 | 1.30 | 9.39 |
| 08-words/long-english | 839 | 536.15 ± 0.2% | not timed | not timed | 513.43 ± 0.2% | 26.25 ± 1.0% | not timed | not timed | 536.05 ± 1.1% | | 1.00 | 1.04 | 20.43 |
| 09-aws-keys/full | 0 | 416.15 ± 2.9% | not timed | not timed | 444.25 ± 0.2% | 53.89 ± 6.8% | not timed | not timed | 416.13 ± 5.6% | | 1.00 | 0.94 | 7.72 |
| 09-aws-keys/quick | 0 | 916.19 ± 9.2% | not timed | not timed | 803.67 ± 0.2% | 331.09 ± 2.1% | not timed | not timed | 914.84 ± 0.4% | | 1.00 | 1.14 | 2.77 |
| 10-bounded-repeat/letters-en | 1833 | 479.91 ± 0.9% | not timed | not timed | 431.21 ± 0.5% | 16.93 ± 2.4% | not timed | not timed | 483.19 ± 0.4% | | 0.99 | 1.11 | 28.35 |
| 10-bounded-repeat/letters-ru | 3475 | 427.85 ± 3.2% | not timed | not timed | 408.33 ± 0.3% | 19.60 ± 12.6% | not timed | not timed | 428.50 ± 0.7% | | 1.00 | 1.05 | 21.83 |
| 10-bounded-repeat/context | 53 | 65.55 ± 3.8% | not timed | not timed | 56.13 ± 6.4% | 16.97 ± 5.6% | not timed | not timed | 65.08 ± 3.0% | | 1.01 | 1.17 | 3.86 |
| 10-bounded-repeat/capitals | 11 | 557.07 ± 7.9% | not timed | not timed | 531.77 ± 0.4% | 31.01 ± 0.2% | not timed | not timed | 553.32 ± 7.7% | | 1.01 | 1.05 | 17.96 |
| 11-unstructured-to-json/extract | 600 | 56.38 ± 5.2% | not timed | not timed | 62.41 ± 1.3% | 40.68 ± 0.5% | not timed | not timed | 57.18 ± 2.1% | | 0.99 | 0.90 | 1.39 |
| 12-dictionary/single | 1 | 458.88 ± 0.2% | not timed | not timed | 437.89 ± 1.2% | 0.32 ± 0.5% | not timed | not timed | 460.96 ± 1.0% | | 1.00 | 1.05 | 1450.84 |
| 14-quadratic/1x | 100 | 21.19 ± 0.5% | not timed | not timed | 9.08 ± 0.5% | 0.81 ± 1.7% | not timed | not timed | 20.96 ± 0.8% | | 1.01 | 2.33 | 26.29 |
| 14-quadratic/2x | 200 | 16.19 ± 1.2% | not timed | not timed | 4.92 ± 0.2% | 0.43 ± 2.7% | not timed | not timed | 16.22 ± 0.6% | | 1.00 | 3.29 | 37.64 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.2% | not timed | not timed | 1.05 ± 0.5% | 0.09 ± 1.5% | not timed | not timed | 5.63 ± 0.4% | | 1.00 | 5.35 | 60.65 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.12 ± 0.6% | not timed | not timed | 0.39 ± 0.9% | 0.49 ± 3.1% | not timed | not timed | 1.12 ± 0.4% | | 1.00 | 2.90 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 77.94 ± 0.4% | not timed | not timed | 13.01 ± 0.4% | 127.58 ± 3.6% | not timed | not timed | 78.95 ± 1.4% | | 0.99 | 5.99 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 12.09 ± 0.9% | not timed | not timed | 2.39 ± 2.0% | 5.89 ± 2.7% | not timed | not timed | 12.32 ± 0.4% | | 0.98 | 5.06 | 2.05 |
| 07-unicode-character-data/compile | 1 | 48.09 ± 0.4% | not timed | not timed | 24.38 ± 0.4% | 33.33 ± 1.7% | not timed | not timed | 48.95 ± 1.0% | | 0.98 | 1.97 | 1.44 |
| 09-aws-keys/compile-full | 1 | 33.35 ± 1.0% | not timed | not timed | 7.44 ± 0.6% | 20.72 ± 4.5% | not timed | not timed | 33.72 ± 1.0% | | 0.99 | 4.48 | 1.61 |
| 09-aws-keys/compile-quick | 1 | 154.79 ± 0.4% | not timed | not timed | 45.03 ± 3.4% | 118.87 ± 4.4% | not timed | not timed | 155.27 ± 1.5% | | 1.00 | 3.44 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 10.49 ± 18.6% | not timed | not timed | 11.75 ± 0.3% | 15.28 ± 0.9% | not timed | not timed | 10.54 ± 0.3% | | 1.00 | 0.89 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 71.79 ± 2.0% | not timed | not timed | 8.90 ± 1.8% | 22.56 ± 2.4% | not timed | not timed | 72.04 ± 0.3% | | 1.00 | 8.07 | 3.18 |
| 11-unstructured-to-json/compile | 1 | 71.45 ± 1.6% | not timed | not timed | 37.39 ± 0.6% | 61.64 ± 2.3% | not timed | not timed | 73.39 ± 0.6% | | 0.97 | 1.91 | 1.16 |
| 12-dictionary/compile-single | 1 | 0.28 ± 0.5% | not timed | not timed | 0.07 ± 0.5% | 0.09 ± 15.9% | not timed | not timed | 0.28 ± 2.0% | | 1.01 | 4.14 | 3.25 |

