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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159297919 |
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
| literal: a word | 217 | 33078.78 ± 80.2% | 897.11 ± 3.2% | 20.04 ± 0.2% | 30948.99 ± 1.2% | 8942.69 ± 9.9% | 10.87 ± 0.2% | 76.72 ± 2.1% | 32362.25 ± 2.3% | 36.87 | 1.02 | 1.07 | 3.70 |
| literal: a word that is not there | 0 | 49558.53 ± 6.1% | 905.44 ± 1.4% | 20.03 ± 1.9% | 39333.15 ± 2.7% | 30092.09 ± 2.2% | 10.78 ± 1.3% | 72.23 ± 15.6% | 48708.13 ± 2.8% | 54.73 | 1.02 | 1.26 | 1.65 |
| literal: one of four words | 661 | 11077.13 ± 1.1% | 876.02 ± 0.5% | 11.23 ± 0.7% | 9108.62 ± 3.0% | 19.24 ± 1.8% | 3.95 ± 0.1% | 6.52 ± 0.3% | 11066.48 ± 0.7% | 12.64 | 1.00 | 1.22 | 575.62 |
| literal: a word in any case | 217 | 26129.72 ± 1.9% | 896.28 ± 0.1% | 15.77 ± 1.3% | 9259.49 ± 0.2% | 37.20 ± 5.8% | refused | differs | 25781.60 ± 0.6% | 29.15 | 1.01 | 2.82 | 702.49 |
| literal: an href attribute | 33 | 26558.87 ± 2.3% | 901.98 ± 0.0% | 18.88 ± 0.4% | 27260.70 ± 0.4% | 2044.36 ± 4.3% | 8.28 ± 0.1% | 67.43 ± 3.7% | 26233.20 ± 5.3% | 29.44 | 1.01 | 0.97 | 12.99 |
| literal: a word, second text | 123 | 33891.03 ± 3.7% | 900.44 ± 0.4% | 19.82 ± 0.4% | 31962.60 ± 28.1% | 7167.66 ± 14.4% | 11.93 ± 0.2% | 65.94 ± 2.0% | 33455.97 ± 0.4% | 37.64 | 1.01 | 1.06 | 4.73 |
| class: two capitalized words | 1331 | 776.66 ± 1.2% | 827.32 ± 0.2% | 18.87 ± 0.2% | 506.32 ± 0.7% | 34.35 ± 7.8% | 9.45 ± 0.9% | 59.22 ± 0.8% | 776.27 ± 0.1% | 0.94 | 1.00 | 1.53 | 22.61 |
| class: a word that ends in ing | 3399 | 756.70 ± 0.3% | 756.56 ± 0.5% | 13.52 ± 0.8% | 473.08 ± 0.6% | 25.70 ± 9.6% | 5.40 ± 0.5% | 16.94 ± 0.4% | 756.02 ± 0.2% | 1.00 | 1.00 | 1.60 | 29.44 |
| class: a word in capitals | 2332 | 977.56 ± 1.7% | 805.29 ± 0.2% | 19.74 ± 5.7% | 497.72 ± 1.1% | 36.71 ± 7.5% | 10.59 ± 0.2% | 77.02 ± 0.4% | 976.26 ± 0.6% | 1.21 | 1.00 | 1.96 | 26.63 |
| class: a number | 8288 | 1359.40 ± 0.2% | 689.58 ± 2.0% | 19.44 ± 0.4% | 1464.75 ± 0.4% | 34.50 ± 11.4% | 0.34 ± 0.9% | 56.50 ± 0.6% | 1339.03 ± 0.2% | 1.97 | 1.02 | 0.93 | 39.41 |
| class: two capitalized words, second text | 5359 | 618.10 ± 0.4% | 619.15 ± 0.3% | 17.39 ± 0.3% | 418.19 ± 0.3% | 29.16 ± 6.8% | 10.58 ± 0.2% | 54.57 ± 1.4% | 617.65 ± 0.2% | 1.00 | 1.00 | 1.48 | 21.20 |
| other: a word between two words | 6104 | 686.53 ± 3.7% | 646.75 ± 1.6% | 17.12 ± 2.4% | 693.99 ± 3.5% | 96.43 ± 12.9% | 7.31 ± 1.6% | 60.71 ± 6.5% | 689.35 ± 2.0% | 1.06 | 1.00 | 0.99 | 7.12 |
| other: a number before a unit, second text | 1481 | 7009.40 ± 1.4% | 841.71 ± 0.3% | 18.78 ± 7.3% | 6415.51 ± 3.4% | 35.10 ± 3.3% | 11.12 ± 0.6% | 58.62 ± 1.6% | 6959.13 ± 0.6% | 8.33 | 1.01 | 1.09 | 199.67 |
| other: a heading's start tag | 110 | 18952.91 ± 3.0% | 894.76 ± 1.5% | 19.57 ± 0.4% | 2004.12 ± 5.0% | 1475.20 ± 3.9% | 10.10 ± 0.4% | 78.45 ± 9.3% | 18316.10 ± 0.6% | 21.18 | 1.03 | 9.46 | 12.85 |
| other: a whole word | 217 | 22676.44 ± 6.7% | 896.19 ± 0.1% | 20.74 ± 1.4% | 22622.06 ± 0.2% | 41.36 ± 0.2% | 9.56 ± 0.3% | 46.23 ± 0.5% | 22060.08 ± 4.3% | 25.30 | 1.03 | 1.00 | 548.29 |
| other: a line's first word, second text | 3716 | 1914.62 ± 1.0% | 744.09 ± 0.3% | 24.30 ± 0.7% | 1670.50 ± 4.5% | 53.32 ± 3.7% | refused | refused | 1902.93 ± 0.2% | 2.57 | 1.01 | 1.15 | 35.91 |
| other: fourteen octets before an x | 87 | 25649.16 ± 1.5% | 193.36 ± 0.5% | 5.62 ± 3.4% | 2743.22 ± 7.2% | 8.99 ± 0.7% | differs | 17.00 ± 11.2% | 25318.48 ± 1.6% | 132.65 | 1.01 | 9.35 | 2853.44 |
| other: a Greek word | 21815 | 397.52 ± 1.2% | 335.41 ± 0.2% | 24.32 ± 0.6% | 265.34 ± 0.5% | 45.71 ± 7.3% | differs | refused | 396.19 ± 0.2% | 1.19 | 1.00 | 1.50 | 8.70 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.39 ± 1.1% | 24.28 ± 0.6% | 0.80 ± 10.3% | 17.00 ± 0.2% | 2.33 ± 0.4% | differs | 3.55 ± 2.5% | 24.55 ± 1.8% | 1.00 | 0.99 | 1.44 | 10.48 |
| a UUID | 32895 | 20.45 ± 0.1% | 20.43 ± 0.2% | 0.56 ± 0.6% | 12.89 ± 0.3% | 2.51 ± 8.0% | 0.43 ± 0.1% | 3.14 ± 9.6% | 20.44 ± 0.6% | 1.00 | 1.00 | 1.59 | 8.16 |
| an IPv4 address | 33176 | 33.79 ± 1.3% | 33.43 ± 0.4% | 1.80 ± 0.6% | 24.34 ± 1.0% | 5.80 ± 0.3% | differs | 3.40 ± 1.7% | 34.16 ± 1.3% | 1.01 | 0.99 | 1.39 | 5.83 |
| a date and time | 32954 | 30.13 ± 0.2% | 30.07 ± 0.8% | 1.23 ± 2.0% | 17.99 ± 1.0% | 6.68 ± 1.4% | 0.75 ± 1.7% | 6.06 ± 1.8% | 30.06 ± 0.3% | 1.00 | 1.00 | 1.67 | 4.51 |
| a field path | 32606 | 27.11 ± 0.8% | 27.11 ± 0.5% | 0.92 ± 0.2% | 19.65 ± 2.2% | 2.94 ± 0.7% | differs | 2.32 ± 5.2% | 27.14 ± 0.2% | 1.00 | 1.00 | 1.38 | 9.21 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.28 ± 0.3% | 8.28 ± 2.7% | 8.20 ± 3.4% | 10.64 ± 0.4% | 4.69 ± 1.9% | 0.62 ± 3.1% | none | 8.28 ± 0.5% | 1.00 | 1.00 | 0.78 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 189.76 ± 1.0% | 190.65 ± 1.1% | 223.72 ± 0.6% | 80.81 ± 3.5% | 182.15 ± 4.5% | 530.95 ± 3.7% | 3897.62 ± 0.7% | 189.33 ± 0.9% | 1.00 | 1.00 | 2.35 | 1.04 |
| a UUID | 62 | 123.05 ± 0.2% | 123.56 ± 0.3% | 137.57 ± 0.5% | 46.66 ± 1.9% | 87.87 ± 2.3% | 199.25 ± 1.3% | 4021.13 ± 0.9% | 123.02 ± 0.6% | 1.00 | 1.00 | 2.64 | 1.40 |
| an IPv4 address | 29 | 373.93 ± 0.8% | 378.33 ± 0.5% | 532.08 ± 12.0% | 71.25 ± 0.6% | 112.72 ± 2.8% | 317.35 ± 14.2% | 6886.18 ± 0.4% | 374.64 ± 0.8% | 0.99 | 1.00 | 5.25 | 3.32 |
| a date and time | 56 | 273.80 ± 1.4% | 275.89 ± 11.7% | 348.14 ± 0.2% | 69.38 ± 0.7% | 122.39 ± 1.6% | 368.74 ± 2.6% | 4168.62 ± 1.4% | 273.62 ± 10.7% | 0.99 | 1.00 | 3.95 | 2.24 |
| a field path | 39 | 186.46 ± 0.6% | 187.24 ± 0.2% | 219.03 ± 1.0% | 74.74 ± 0.8% | 169.97 ± 2.5% | 575.44 ± 1.0% | 4748.85 ± 1.0% | 186.54 ± 1.0% | 1.00 | 1.00 | 2.49 | 1.10 |
| literal: a word | 7 | 549.93 ± 3.0% | 585.53 ± 2.3% | 1039.00 ± 2.8% | 491.09 ± 8.3% | 573.28 ± 8.8% | 1255.19 ± 2.9% | 24605.81 ± 10.0% | 536.86 ± 4.5% | 0.94 | 1.02 | 1.12 | 0.96 |
| literal: a word that is not there | 8 | 527.13 ± 3.3% | 567.89 ± 2.3% | 986.07 ± 3.3% | 460.75 ± 0.7% | 546.75 ± 24.3% | 1167.60 ± 1.7% | 23968.88 ± 6.1% | 526.12 ± 0.4% | 0.93 | 1.00 | 1.14 | 0.96 |
| literal: one of four words | 26 | 211.31 ± 1.0% | 345.23 ± 1.9% | 467.30 ± 2.3% | 41.95 ± 1.7% | 220.61 ± 5.6% | 452.04 ± 0.8% | 12832.22 ± 0.4% | 211.18 ± 0.8% | 0.61 | 1.00 | 5.04 | 0.96 |
| literal: a word in any case | 11 | 426.74 ± 0.5% | 454.13 ± 0.9% | 691.75 ± 1.0% | 14.58 ± 0.4% | 608.86 ± 2.1% | refused | 19747.69 ± 1.4% | 424.36 ± 0.6% | 0.94 | 1.01 | 29.27 | 0.70 |
| literal: an href attribute | 12 | 304.98 ± 1.2% | 315.46 ± 0.4% | 421.51 ± 0.2% | 36.80 ± 9.1% | 418.11 ± 5.3% | 967.32 ± 6.8% | 17921.97 ± 0.7% | 305.07 ± 0.2% | 0.97 | 1.00 | 8.29 | 0.73 |
| literal: a word, second text | 10 | 490.95 ± 1.7% | 535.09 ± 2.1% | 891.13 ± 3.0% | 418.52 ± 1.5% | 475.09 ± 5.4% | 1024.52 ± 0.4% | 21857.69 ± 2.1% | 490.04 ± 1.0% | 0.92 | 1.00 | 1.17 | 1.03 |
| class: two capitalized words | 23 | 402.97 ± 8.6% | 431.12 ± 1.9% | 640.68 ± 1.9% | 95.26 ± 0.8% | 449.16 ± 2.1% | 904.92 ± 10.4% | 6291.59 ± 0.1% | 402.70 ± 0.2% | 0.93 | 1.00 | 4.23 | 0.90 |
| class: a word that ends in ing | 9 | 479.82 ± 0.7% | 537.83 ± 0.3% | 964.71 ± 0.3% | 115.28 ± 1.3% | 630.90 ± 1.8% | 1383.90 ± 16.2% | 15155.62 ± 13.8% | 478.74 ± 0.4% | 0.89 | 1.00 | 4.16 | 0.76 |
| class: a word in capitals | 16 | 421.69 ± 0.5% | 454.67 ± 1.0% | 768.59 ± 0.5% | 122.34 ± 0.8% | 662.58 ± 4.4% | 1218.52 ± 0.8% | 8265.08 ± 5.4% | 421.78 ± 5.9% | 0.93 | 1.00 | 3.45 | 0.64 |
| class: a number | 6 | 531.33 ± 11.1% | 584.83 ± 1.0% | 1161.75 ± 14.1% | 36.69 ± 1.6% | 1194.94 ± 2.5% | 2313.26 ± 4.0% | 20646.37 ± 0.8% | 530.31 ± 0.4% | 0.91 | 1.00 | 14.48 | 0.44 |
| class: two capitalized words, second text | 23 | 403.32 ± 0.1% | 431.18 ± 0.8% | 640.92 ± 2.3% | 95.44 ± 1.4% | 454.69 ± 14.7% | 914.36 ± 0.8% | 6290.41 ± 10.7% | 402.73 ± 0.3% | 0.94 | 1.00 | 4.23 | 0.89 |
| other: a word between two words | 13 | 474.67 ± 0.5% | 491.63 ± 1.0% | 777.93 ± 0.9% | 123.19 ± 1.2% | 439.21 ± 3.6% | 999.83 ± 1.7% | 14115.50 ± 1.5% | 473.93 ± 0.7% | 0.97 | 1.00 | 3.85 | 1.08 |
| other: a number before a unit, second text | 15 | 346.68 ± 0.5% | 384.61 ± 1.0% | 537.63 ± 1.4% | 33.95 ± 1.5% | 531.79 ± 42.9% | 1117.91 ± 0.3% | 12577.60 ± 1.0% | 347.12 ± 0.1% | 0.90 | 1.00 | 10.21 | 0.65 |
| other: a heading's start tag | 13 | 324.95 ± 0.5% | 330.27 ± 0.6% | 448.41 ± 1.3% | 35.60 ± 1.5% | 517.44 ± 1.5% | 1096.39 ± 13.6% | 15004.77 ± 0.3% | 325.58 ± 0.4% | 0.98 | 1.00 | 9.13 | 0.63 |
| other: a whole word | 11 | 487.89 ± 0.3% | 514.47 ± 11.6% | 838.31 ± 0.5% | 112.45 ± 11.6% | 505.79 ± 7.8% | 1047.65 ± 8.2% | 21935.85 ± 1.5% | 487.69 ± 0.4% | 0.95 | 1.00 | 4.34 | 0.96 |
| other: a line's first word, second text | 17 | 463.53 ± 0.6% | 481.75 ± 2.8% | 797.49 ± 0.4% | 116.54 ± 1.1% | 603.20 ± 1.5% | refused | refused | 462.70 ± 0.6% | 0.96 | 1.00 | 3.98 | 0.77 |
| other: fourteen octets before an x | 16 | 86.66 ± 1.5% | 122.85 ± 0.4% | 143.79 ± 0.1% | 14.15 ± 10.3% | 392.31 ± 2.0% | 448.16 ± 7.1% | 11482.88 ± 19.0% | 86.84 ± 1.3% | 0.71 | 1.00 | 6.12 | 0.22 |
| other: a Greek word | 8 | 360.44 ± 0.4% | 502.27 ± 0.8% | 867.71 ± 0.4% | 46.92 ± 0.8% | 1160.44 ± 9.9% | 2250.22 ± 3.1% | refused | 360.36 ± 0.6% | 0.72 | 1.00 | 7.68 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22092.37 ± 2.3% | not timed | not timed | 26825.66 ± 1.4% | 1977.48 ± 19.9% | not timed | not timed | 21891.01 ± 2.1% | | 1.01 | 0.82 | 11.17 |
| 01-literal/sherlock-casei-en | 522 | 6280.41 ± 0.9% | not timed | not timed | 6632.70 ± 0.2% | 28.74 ± 0.9% | not timed | not timed | 6201.71 ± 8.9% | | 1.01 | 0.95 | 218.49 |
| 01-literal/sherlock-ru | 724 | 23838.35 ± 0.4% | not timed | not timed | 27691.21 ± 1.7% | 1054.95 ± 5.7% | not timed | not timed | 23685.12 ± 1.4% | | 1.01 | 0.86 | 22.60 |
| 01-literal/sherlock-casei-ru | 746 | 7391.21 ± 0.2% | not timed | not timed | 5545.30 ± 0.5% | 30.54 ± 1.5% | not timed | not timed | 7355.01 ± 1.6% | | 1.00 | 1.33 | 242.01 |
| 01-literal/sherlock-zh | 30 | 42214.65 ± 1.7% | not timed | not timed | 36737.78 ± 1.0% | 1261.87 ± 0.4% | not timed | not timed | 42197.52 ± 1.8% | | 1.00 | 1.15 | 33.45 |
| 02-literal-alternate/sherlock-en | 714 | 9714.34 ± 1.1% | not timed | not timed | 8905.40 ± 0.5% | 14.17 ± 4.2% | not timed | not timed | 9724.20 ± 0.8% | | 1.00 | 1.09 | 685.68 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1821.68 ± 0.3% | not timed | not timed | 1818.45 ± 1.3% | 9.53 ± 1.0% | not timed | not timed | 1812.71 ± 0.4% | | 1.00 | 1.00 | 191.07 |
| 02-literal-alternate/sherlock-ru | 899 | 5420.51 ± 2.4% | not timed | not timed | 4269.53 ± 2.8% | 19.43 ± 3.5% | not timed | not timed | 5966.81 ± 2.7% | | 0.91 | 1.27 | 279.04 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1873.38 ± 6.4% | not timed | not timed | 1047.16 ± 1.7% | 8.55 ± 1.7% | not timed | not timed | 1874.10 ± 1.1% | | 1.00 | 1.79 | 219.17 |
| 02-literal-alternate/sherlock-zh | 207 | 14041.85 ± 16.5% | not timed | not timed | 10444.81 ± 0.4% | 25.96 ± 12.3% | not timed | not timed | 14024.71 ± 1.2% | | 1.00 | 1.34 | 540.92 |
| 03-date/ascii | 111817 | 99.52 ± 0.8% | not timed | not timed | 85.05 ± 0.5% | 0.18 ± 4.0% | not timed | not timed | 99.66 ± 0.8% | | 1.00 | 1.17 | 560.53 |
| 04-ruff-noqa/real | 84 | 568.15 ± 0.5% | not timed | not timed | 435.54 ± 0.7% | 16.25 ± 2.2% | not timed | not timed | 567.88 ± 0.3% | | 1.00 | 1.30 | 34.96 |
| 04-ruff-noqa/tweaked | 44 | 482.14 ± 0.1% | not timed | not timed | 432.35 ± 0.8% | 294.51 ± 0.4% | not timed | not timed | 481.53 ± 0.6% | | 1.00 | 1.12 | 1.64 |
| 05-lexer-veryl/single | 124800 | 3.06 ± 1.5% | not timed | not timed | 4.15 ± 2.1% | 0.21 ± 6.1% | not timed | not timed | 3.06 ± 0.4% | | 1.00 | 0.74 | 14.44 |
| 06-cloud-flare-redos/original | 107 | 220.55 ± 0.4% | not timed | not timed | 192.37 ± 2.7% | 20.90 ± 0.4% | not timed | not timed | 221.14 ± 0.8% | | 1.00 | 1.15 | 10.55 |
| 06-cloud-flare-redos/simplified-short | 102 | 213.75 ± 1.1% | not timed | not timed | 192.19 ± 0.2% | 22.02 ± 0.5% | not timed | not timed | 214.18 ± 0.5% | | 1.00 | 1.11 | 9.71 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.87 ± 0.2% | not timed | not timed | 211.64 ± 0.4% | 24.07 ± 20.6% | not timed | not timed | 245.76 ± 0.8% | | 1.00 | 1.17 | 10.26 |
| 07-unicode-character-data/parse-line | 558784 | 189.63 ± 1.6% | not timed | not timed | 160.39 ± 0.4% | 35.91 ± 4.4% | not timed | not timed | 186.68 ± 2.1% | | 1.02 | 1.18 | 5.28 |
| 08-words/all-english | 56691 | 95.19 ± 1.1% | not timed | not timed | 73.81 ± 0.6% | 10.21 ± 3.7% | not timed | not timed | 95.00 ± 0.8% | | 1.00 | 1.29 | 9.33 |
| 08-words/long-english | 839 | 858.94 ± 1.9% | not timed | not timed | 513.76 ± 0.6% | 26.75 ± 0.3% | not timed | not timed | 859.01 ± 0.5% | | 1.00 | 1.67 | 32.12 |
| 09-aws-keys/full | 0 | 428.84 ± 0.7% | not timed | not timed | 450.42 ± 0.7% | 54.56 ± 0.2% | not timed | not timed | 429.26 ± 0.4% | | 1.00 | 0.95 | 7.86 |
| 09-aws-keys/quick | 0 | 816.89 ± 0.5% | not timed | not timed | 776.45 ± 0.7% | 326.66 ± 0.7% | not timed | not timed | 823.83 ± 0.4% | | 0.99 | 1.05 | 2.50 |
| 10-bounded-repeat/letters-en | 1833 | 493.68 ± 1.6% | not timed | not timed | 426.48 ± 2.6% | 16.63 ± 2.4% | not timed | not timed | 494.48 ± 1.5% | | 1.00 | 1.16 | 29.68 |
| 10-bounded-repeat/letters-ru | 3475 | 317.10 ± 2.3% | not timed | not timed | 407.79 ± 4.1% | 19.69 ± 11.9% | not timed | not timed | 317.01 ± 0.3% | | 1.00 | 0.78 | 16.10 |
| 10-bounded-repeat/context | 53 | 65.07 ± 1.1% | not timed | not timed | 56.26 ± 5.2% | 16.86 ± 0.9% | not timed | not timed | 65.11 ± 3.1% | | 1.00 | 1.16 | 3.86 |
| 10-bounded-repeat/capitals | 11 | 897.99 ± 0.8% | not timed | not timed | 532.44 ± 0.4% | 31.05 ± 0.3% | not timed | not timed | 896.98 ± 0.3% | | 1.00 | 1.69 | 28.92 |
| 11-unstructured-to-json/extract | 600 | 37.15 ± 0.2% | not timed | not timed | 62.31 ± 0.9% | 40.63 ± 1.2% | not timed | not timed | 37.27 ± 0.6% | | 1.00 | 0.60 | 0.91 |
| 12-dictionary/single | 1 | 459.75 ± 1.8% | not timed | not timed | 442.20 ± 0.2% | 0.31 ± 0.2% | not timed | not timed | 464.01 ± 0.2% | | 0.99 | 1.04 | 1484.05 |
| 14-quadratic/1x | 100 | 10.08 ± 1.4% | not timed | not timed | 9.09 ± 0.7% | 0.82 ± 7.1% | not timed | not timed | 10.01 ± 2.0% | | 1.01 | 1.11 | 12.28 |
| 14-quadratic/2x | 200 | 6.43 ± 0.5% | not timed | not timed | 4.91 ± 0.3% | 0.44 ± 2.8% | not timed | not timed | 6.44 ± 0.5% | | 1.00 | 1.31 | 14.77 |
| 14-quadratic/10x | 1000 | 1.57 ± 4.8% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 3.8% | not timed | not timed | 1.57 ± 0.4% | | 1.00 | 1.49 | 16.62 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.33 ± 0.5% | not timed | not timed | 0.39 ± 0.8% | 0.47 ± 5.1% | not timed | not timed | 1.32 ± 1.5% | | 1.01 | 3.43 | 2.82 |
| 04-ruff-noqa/compile-real | 1 | 81.33 ± 0.1% | not timed | not timed | 13.05 ± 13.9% | 125.50 ± 2.3% | not timed | not timed | 81.11 ± 1.2% | | 1.00 | 6.23 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 12.66 ± 0.9% | not timed | not timed | 2.38 ± 1.1% | 5.91 ± 2.1% | not timed | not timed | 12.66 ± 0.5% | | 1.00 | 5.31 | 2.14 |
| 07-unicode-character-data/compile | 1 | 51.34 ± 3.1% | not timed | not timed | 24.39 ± 9.4% | 32.87 ± 16.1% | not timed | not timed | 51.28 ± 0.4% | | 1.00 | 2.11 | 1.56 |
| 09-aws-keys/compile-full | 1 | 35.05 ± 0.2% | not timed | not timed | 7.48 ± 0.7% | 20.20 ± 1.2% | not timed | not timed | 34.93 ± 1.3% | | 1.00 | 4.68 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 157.82 ± 0.3% | not timed | not timed | 46.16 ± 0.7% | 118.51 ± 4.1% | not timed | not timed | 156.99 ± 1.7% | | 1.01 | 3.42 | 1.33 |
| 10-bounded-repeat/compile-context | 1 | 10.51 ± 4.7% | not timed | not timed | 11.71 ± 5.5% | 15.13 ± 1.6% | not timed | not timed | 10.52 ± 0.7% | | 1.00 | 0.90 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 72.76 ± 1.7% | not timed | not timed | 8.89 ± 8.6% | 22.09 ± 2.2% | not timed | not timed | 71.30 ± 1.3% | | 1.02 | 8.18 | 3.29 |
| 11-unstructured-to-json/compile | 1 | 77.98 ± 1.7% | not timed | not timed | 37.59 ± 0.7% | 60.30 ± 1.5% | not timed | not timed | 77.38 ± 1.1% | | 1.01 | 2.07 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.3% | not timed | not timed | 0.07 ± 18.9% | 0.09 ± 16.4% | not timed | not timed | 0.29 ± 2.8% | | 1.02 | 4.20 | 3.25 |

