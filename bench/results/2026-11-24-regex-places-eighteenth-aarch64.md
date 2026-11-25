# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
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
| literal: a word | 217 | 19480.59 ± 0.6% | 5064.45 ± 0.2% | 27.68 ± 0.4% | 18000.35 ± 1.9% | 9038.93 ± 7.4% | 17.20 ± 0.5% | 85.72 ± 0.3% | 19489.95 ± 1.5% | 3.85 | 1.00 | 1.08 | 2.16 |
| literal: a word that is not there | 0 | 21349.22 ± 1.9% | 4927.32 ± 0.2% | 27.65 ± 0.3% | 19625.49 ± 1.6% | 28957.54 ± 1.8% | 17.09 ± 0.3% | 81.64 ± 0.1% | 21247.53 ± 3.3% | 4.33 | 1.00 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6392.22 ± 0.8% | 1970.50 ± 0.3% | 14.25 ± 0.2% | 3932.72 ± 0.2% | 21.84 ± 0.1% | 5.36 ± 0.1% | 6.74 ± 0.2% | 6414.40 ± 0.4% | 3.24 | 1.00 | 1.63 | 292.64 |
| literal: a word in any case | 217 | 15121.89 ± 0.6% | 2098.41 ± 0.0% | 21.19 ± 0.4% | 3962.78 ± 0.1% | 37.95 ± 0.3% | refused | differs | 15107.50 ± 0.5% | 7.21 | 1.00 | 3.82 | 398.42 |
| literal: an href attribute | 33 | 16917.65 ± 0.8% | 616.21 ± 0.1% | 26.79 ± 0.2% | 16911.33 ± 1.8% | 2248.39 ± 0.4% | 13.13 ± 0.1% | 74.86 ± 0.2% | 16919.46 ± 1.2% | 27.45 | 1.00 | 1.00 | 7.52 |
| literal: a word, second text | 123 | 19781.60 ± 1.0% | 3416.36 ± 0.1% | 27.47 ± 0.3% | 18342.95 ± 1.2% | 7660.71 ± 5.1% | 20.04 ± 0.6% | 68.19 ± 0.3% | 19858.46 ± 1.5% | 5.79 | 1.00 | 1.08 | 2.58 |
| class: two capitalized words | 1331 | 1064.38 ± 0.6% | 607.85 ± 0.2% | 25.60 ± 0.2% | 583.65 ± 0.1% | 40.47 ± 7.2% | 14.75 ± 0.3% | 68.01 ± 0.1% | 1061.38 ± 0.4% | 1.75 | 1.00 | 1.82 | 26.30 |
| class: a word that ends in ing | 3399 | 581.92 ± 0.1% | 581.53 ± 0.2% | 17.80 ± 0.9% | 546.74 ± 0.1% | 29.54 ± 6.0% | 8.13 ± 0.2% | 18.23 ± 0.2% | 582.40 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.70 |
| class: a word in capitals | 2332 | 1386.62 ± 0.4% | 613.11 ± 0.1% | 27.11 ± 0.1% | 571.63 ± 0.1% | 43.37 ± 17.3% | 17.17 ± 0.2% | 82.56 ± 1.1% | 1386.47 ± 0.1% | 2.26 | 1.00 | 2.43 | 31.97 |
| class: a number | 8288 | 2120.83 ± 0.5% | 850.87 ± 0.1% | 27.24 ± 0.2% | 1716.08 ± 0.2% | 40.87 ± 12.9% | 0.55 ± 0.1% | 56.54 ± 0.3% | 2125.39 ± 0.8% | 2.49 | 1.00 | 1.24 | 51.89 |
| class: two capitalized words, second text | 5359 | 524.07 ± 0.9% | 533.13 ± 0.3% | 23.04 ± 0.2% | 483.38 ± 0.1% | 35.21 ± 8.2% | 17.06 ± 0.4% | 63.19 ± 0.5% | 524.70 ± 0.2% | 0.98 | 1.00 | 1.08 | 14.88 |
| other: a word between two words | 6104 | 804.92 ± 0.3% | 607.54 ± 0.2% | 23.27 ± 0.2% | 737.91 ± 0.2% | 108.39 ± 18.2% | 11.16 ± 0.1% | 68.91 ± 0.3% | 805.98 ± 0.2% | 1.32 | 1.00 | 1.09 | 7.43 |
| other: a number before a unit, second text | 1481 | 6164.08 ± 0.6% | 1129.37 ± 0.4% | 25.51 ± 0.2% | 5208.29 ± 1.0% | 40.66 ± 0.1% | 18.13 ± 0.4% | 66.60 ± 0.2% | 6145.99 ± 1.5% | 5.46 | 1.00 | 1.18 | 151.61 |
| other: a heading's start tag | 110 | 14137.45 ± 0.5% | 749.25 ± 0.1% | 26.84 ± 0.1% | 1704.12 ± 0.2% | 1573.07 ± 2.9% | 16.00 ± 0.3% | 88.35 ± 0.2% | 14157.61 ± 0.6% | 18.87 | 1.00 | 8.30 | 8.99 |
| other: a whole word | 217 | 16269.15 ± 0.8% | 607.28 ± 0.1% | 28.66 ± 0.3% | 14572.34 ± 1.3% | 47.90 ± 0.5% | 13.17 ± 0.1% | 55.23 ± 0.4% | 16290.36 ± 0.9% | 26.79 | 1.00 | 1.12 | 339.61 |
| other: a line's first word, second text | 3716 | 2104.71 ± 0.4% | 598.61 ± 0.1% | 30.12 ± 0.3% | 1559.66 ± 0.3% | 62.06 ± 7.7% | refused | refused | 2111.62 ± 0.7% | 3.52 | 1.00 | 1.35 | 33.92 |
| other: fourteen octets before an x | 87 | 24155.06 ± 0.8% | 237.92 ± 1.0% | 6.51 ± 0.1% | 3938.33 ± 1.2% | 10.62 ± 0.3% | differs | 17.46 ± 0.0% | 24303.84 ± 2.6% | 101.53 | 0.99 | 6.13 | 2274.75 |
| other: a Greek word | 21815 | 519.08 ± 0.3% | 424.27 ± 0.1% | 30.43 ± 0.2% | 289.40 ± 0.3% | 48.94 ± 9.6% | differs | refused | 520.20 ± 0.3% | 1.22 | 1.00 | 1.79 | 10.61 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.19 ± 0.1% | 29.15 ± 0.1% | 0.86 ± 0.2% | 19.76 ± 0.2% | 2.75 ± 0.3% | differs | 4.02 ± 0.4% | 29.17 ± 0.2% | 1.00 | 1.00 | 1.48 | 10.61 |
| a UUID | 32895 | 24.58 ± 0.2% | 24.58 ± 0.2% | 0.64 ± 0.4% | 15.02 ± 0.3% | 3.09 ± 0.6% | 0.73 ± 0.5% | 3.60 ± 0.5% | 24.66 ± 0.2% | 1.00 | 1.00 | 1.64 | 7.96 |
| an IPv4 address | 33176 | 38.38 ± 0.2% | 38.31 ± 0.4% | 2.08 ± 0.2% | 29.28 ± 0.3% | 6.63 ± 0.3% | differs | 4.16 ± 0.2% | 38.35 ± 0.3% | 1.00 | 1.00 | 1.31 | 5.79 |
| a date and time | 32954 | 34.29 ± 0.3% | 34.03 ± 0.2% | 1.45 ± 0.7% | 21.42 ± 0.5% | 7.00 ± 0.3% | 1.25 ± 0.2% | 7.11 ± 0.2% | 34.16 ± 0.3% | 1.01 | 1.00 | 1.60 | 4.90 |
| a field path | 32606 | 32.48 ± 0.1% | 32.46 ± 0.2% | 1.02 ± 0.3% | 23.10 ± 0.3% | 3.49 ± 1.3% | differs | 2.92 ± 0.3% | 32.48 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.32 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.2% | 11.06 ± 0.2% | 11.10 ± 0.4% | 11.43 ± 0.1% | 4.86 ± 1.2% | 0.94 ± 0.6% | none | 11.05 ± 0.2% | 1.00 | 1.01 | 0.97 | 2.28 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.62 ± 0.3% | 222.11 ± 0.1% | 264.53 ± 0.4% | 86.55 ± 0.3% | 214.36 ± 2.3% | 485.88 ± 0.2% | 3738.98 ± 0.7% | 221.69 ± 0.3% | 1.00 | 1.00 | 2.56 | 1.03 |
| a UUID | 62 | 145.00 ± 0.3% | 145.23 ± 0.2% | 162.91 ± 0.2% | 45.69 ± 0.9% | 94.71 ± 1.7% | 181.94 ± 1.7% | 4465.99 ± 0.4% | 145.11 ± 0.2% | 1.00 | 1.00 | 3.17 | 1.53 |
| an IPv4 address | 29 | 410.81 ± 0.3% | 411.24 ± 0.5% | 585.23 ± 0.8% | 75.77 ± 0.9% | 125.02 ± 2.6% | 291.07 ± 0.6% | 7650.26 ± 0.2% | 410.50 ± 0.3% | 1.00 | 1.00 | 5.42 | 3.29 |
| a date and time | 56 | 299.42 ± 0.3% | 299.77 ± 0.2% | 382.57 ± 0.1% | 72.09 ± 1.3% | 130.65 ± 2.4% | 321.51 ± 2.2% | 4961.40 ± 0.2% | 299.43 ± 0.1% | 1.00 | 1.00 | 4.15 | 2.29 |
| a field path | 39 | 213.60 ± 0.4% | 213.85 ± 0.3% | 253.10 ± 0.1% | 78.87 ± 0.2% | 195.70 ± 1.7% | 484.32 ± 1.4% | 4841.68 ± 0.4% | 213.63 ± 0.1% | 1.00 | 1.00 | 2.71 | 1.09 |
| literal: a word | 7 | 595.20 ± 0.6% | 642.74 ± 0.7% | 1189.13 ± 0.6% | 495.36 ± 1.3% | 601.29 ± 2.1% | 916.13 ± 0.6% | 30480.39 ± 0.2% | 596.60 ± 0.5% | 0.93 | 1.00 | 1.20 | 0.99 |
| literal: a word that is not there | 8 | 571.55 ± 0.7% | 623.02 ± 0.7% | 1122.27 ± 0.7% | 455.44 ± 0.3% | 573.80 ± 2.4% | 866.50 ± 0.8% | 29510.67 ± 1.7% | 572.35 ± 0.5% | 0.92 | 1.00 | 1.25 | 1.00 |
| literal: one of four words | 26 | 235.81 ± 0.3% | 384.23 ± 0.3% | 533.93 ± 0.3% | 49.24 ± 0.2% | 230.81 ± 2.5% | 354.59 ± 0.7% | 15774.79 ± 0.1% | 235.92 ± 0.3% | 0.61 | 1.00 | 4.79 | 1.02 |
| literal: a word in any case | 11 | 435.57 ± 0.4% | 465.95 ± 0.3% | 701.49 ± 0.1% | 15.61 ± 1.2% | 632.13 ± 7.1% | refused | 23775.95 ± 0.2% | 436.46 ± 0.4% | 0.93 | 1.00 | 27.91 | 0.69 |
| literal: an href attribute | 12 | 333.86 ± 0.4% | 347.93 ± 0.4% | 463.16 ± 0.4% | 9.96 ± 6.1% | 484.00 ± 3.5% | 752.45 ± 1.1% | 22373.47 ± 0.2% | 333.75 ± 0.4% | 0.96 | 1.00 | 33.52 | 0.69 |
| literal: a word, second text | 10 | 530.07 ± 0.3% | 584.36 ± 0.4% | 1005.73 ± 0.6% | 410.03 ± 0.4% | 516.83 ± 2.2% | 780.93 ± 0.6% | 27404.84 ± 0.2% | 530.57 ± 0.5% | 0.91 | 1.00 | 1.29 | 1.03 |
| class: two capitalized words | 23 | 418.72 ± 0.8% | 449.82 ± 0.5% | 660.51 ± 0.9% | 99.64 ± 1.2% | 469.59 ± 4.1% | 755.90 ± 1.3% | 6373.11 ± 0.2% | 417.55 ± 0.3% | 0.93 | 1.00 | 4.20 | 0.89 |
| class: a word that ends in ing | 9 | 524.56 ± 0.3% | 594.19 ± 0.1% | 1073.21 ± 0.2% | 131.27 ± 0.9% | 715.25 ± 2.3% | 1077.59 ± 3.9% | 15938.96 ± 0.3% | 524.34 ± 0.1% | 0.88 | 1.00 | 4.00 | 0.73 |
| class: a word in capitals | 16 | 467.51 ± 0.3% | 507.96 ± 0.4% | 834.04 ± 0.2% | 133.75 ± 0.9% | 707.56 ± 2.5% | 992.66 ± 0.7% | 8377.33 ± 0.1% | 467.59 ± 0.2% | 0.92 | 1.00 | 3.50 | 0.66 |
| class: a number | 6 | 589.96 ± 0.2% | 652.88 ± 0.5% | 1265.50 ± 0.1% | 41.92 ± 0.6% | 1330.27 ± 2.1% | 1892.52 ± 0.5% | 23100.11 ± 0.2% | 589.67 ± 0.4% | 0.90 | 1.00 | 14.07 | 0.44 |
| class: two capitalized words, second text | 23 | 419.35 ± 0.3% | 449.69 ± 0.4% | 659.92 ± 0.4% | 99.78 ± 1.5% | 477.33 ± 1.6% | 754.40 ± 0.6% | 6375.38 ± 0.1% | 418.75 ± 0.3% | 0.93 | 1.00 | 4.20 | 0.88 |
| other: a word between two words | 13 | 519.09 ± 0.3% | 541.08 ± 0.4% | 882.91 ± 0.3% | 133.50 ± 0.4% | 480.27 ± 5.0% | 821.53 ± 1.1% | 14748.16 ± 0.1% | 520.07 ± 0.4% | 0.96 | 1.00 | 3.89 | 1.08 |
| other: a number before a unit, second text | 15 | 378.62 ± 0.1% | 419.73 ± 0.2% | 598.80 ± 0.2% | 39.34 ± 0.3% | 603.41 ± 2.0% | 891.23 ± 0.3% | 15385.15 ± 0.1% | 378.79 ± 0.1% | 0.90 | 1.00 | 9.62 | 0.63 |
| other: a heading's start tag | 13 | 345.61 ± 0.6% | 353.56 ± 0.5% | 473.23 ± 0.6% | 10.46 ± 5.5% | 599.31 ± 4.3% | 860.29 ± 0.4% | 18499.18 ± 0.1% | 345.67 ± 0.5% | 0.98 | 1.00 | 33.04 | 0.58 |
| other: a whole word | 11 | 549.83 ± 0.2% | 586.96 ± 0.5% | 1012.19 ± 0.5% | 119.68 ± 0.4% | 543.83 ± 1.9% | 817.67 ± 0.8% | 26952.82 ± 1.2% | 550.23 ± 0.5% | 0.94 | 1.00 | 4.59 | 1.01 |
| other: a line's first word, second text | 17 | 497.01 ± 0.5% | 527.70 ± 0.3% | 872.33 ± 0.5% | 128.11 ± 0.3% | 683.68 ± 2.8% | refused | refused | 498.41 ± 0.7% | 0.94 | 1.00 | 3.88 | 0.73 |
| other: fourteen octets before an x | 16 | 105.91 ± 0.9% | 151.20 ± 0.5% | 177.04 ± 0.5% | 6.56 ± 16.9% | 429.02 ± 2.5% | 414.83 ± 1.1% | 12796.35 ± 0.3% | 105.87 ± 0.5% | 0.70 | 1.00 | 16.15 | 0.25 |
| other: a Greek word | 8 | 412.25 ± 0.1% | 566.46 ± 0.5% | 988.10 ± 0.1% | 12.84 ± 23.7% | 1294.88 ± 5.3% | 1782.96 ± 0.4% | refused | 411.98 ± 0.3% | 0.73 | 1.00 | 32.10 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15686.29 ± 0.6% | not timed | not timed | 16253.08 ± 1.2% | 2086.20 ± 22.3% | not timed | not timed | 15625.95 ± 0.9% | | 1.00 | 0.97 | 7.52 |
| 01-literal/sherlock-casei-en | 522 | 10989.61 ± 4.9% | not timed | not timed | 3580.12 ± 0.2% | 32.45 ± 5.0% | not timed | not timed | 11010.97 ± 3.2% | | 1.00 | 3.07 | 338.70 |
| 01-literal/sherlock-ru | 724 | 17064.61 ± 0.8% | not timed | not timed | 17220.45 ± 0.9% | 1453.62 ± 19.9% | not timed | not timed | 17089.89 ± 0.6% | | 1.00 | 0.99 | 11.74 |
| 01-literal/sherlock-casei-ru | 746 | 6128.67 ± 0.5% | not timed | not timed | 3311.46 ± 0.4% | 31.68 ± 1.0% | not timed | not timed | 6126.92 ± 0.5% | | 1.00 | 1.85 | 193.48 |
| 01-literal/sherlock-zh | 30 | 19664.98 ± 0.5% | not timed | not timed | 18671.94 ± 0.7% | 2645.41 ± 10.1% | not timed | not timed | 19670.79 ± 0.3% | | 1.00 | 1.05 | 7.43 |
| 02-literal-alternate/sherlock-en | 714 | 6120.41 ± 0.4% | not timed | not timed | 3926.58 ± 0.3% | 16.58 ± 0.1% | not timed | not timed | 6117.37 ± 0.5% | | 1.00 | 1.56 | 369.17 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1957.58 ± 1.3% | not timed | not timed | 696.39 ± 0.2% | 11.08 ± 0.3% | not timed | not timed | 1967.76 ± 1.1% | | 0.99 | 2.81 | 176.61 |
| 02-literal-alternate/sherlock-ru | 899 | 5516.30 ± 0.4% | not timed | not timed | 3241.02 ± 0.0% | 22.17 ± 0.1% | not timed | not timed | 5513.86 ± 0.2% | | 1.00 | 1.70 | 248.86 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.88 ± 0.4% | not timed | not timed | 1230.47 ± 0.1% | 8.99 ± 2.3% | not timed | not timed | 2050.43 ± 0.5% | | 1.00 | 1.67 | 228.02 |
| 02-literal-alternate/sherlock-zh | 207 | 7310.54 ± 0.4% | not timed | not timed | 4141.58 ± 0.1% | 31.38 ± 0.3% | not timed | not timed | 7316.72 ± 0.4% | | 1.00 | 1.77 | 232.95 |
| 03-date/ascii | 111817 | 133.21 ± 0.9% | not timed | not timed | 95.37 ± 0.1% | 0.20 ± 4.7% | not timed | not timed | 134.04 ± 0.5% | | 0.99 | 1.40 | 663.69 |
| 04-ruff-noqa/real | 84 | 437.82 ± 0.1% | not timed | not timed | 468.07 ± 0.1% | 19.62 ± 1.2% | not timed | not timed | 437.35 ± 0.5% | | 1.00 | 0.94 | 22.31 |
| 04-ruff-noqa/tweaked | 44 | 592.44 ± 0.3% | not timed | not timed | 460.67 ± 0.2% | 361.08 ± 0.6% | not timed | not timed | 593.26 ± 0.3% | | 1.00 | 1.29 | 1.64 |
| 05-lexer-veryl/single | 124800 | 5.26 ± 4.4% | not timed | not timed | 5.14 ± 0.3% | 0.21 ± 2.1% | not timed | not timed | 5.25 ± 3.2% | | 1.00 | 1.02 | 25.58 |
| 06-cloud-flare-redos/original | 107 | 426.84 ± 0.2% | not timed | not timed | 216.45 ± 0.1% | 24.92 ± 0.3% | not timed | not timed | 430.87 ± 0.2% | | 0.99 | 1.97 | 17.13 |
| 06-cloud-flare-redos/simplified-short | 102 | 429.45 ± 0.2% | not timed | not timed | 227.10 ± 0.2% | 26.58 ± 0.2% | not timed | not timed | 428.59 ± 0.1% | | 1.00 | 1.89 | 16.16 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.74 ± 0.2% | not timed | not timed | 256.71 ± 0.1% | 28.70 ± 0.1% | not timed | not timed | 588.08 ± 0.1% | | 1.00 | 2.29 | 20.48 |
| 07-unicode-character-data/parse-line | 558784 | 238.27 ± 1.5% | not timed | not timed | 178.09 ± 0.3% | 41.34 ± 8.0% | not timed | not timed | 238.68 ± 1.7% | | 1.00 | 1.34 | 5.76 |
| 08-words/all-english | 56691 | 127.24 ± 0.9% | not timed | not timed | 82.90 ± 0.1% | 11.64 ± 2.7% | not timed | not timed | 127.06 ± 0.4% | | 1.00 | 1.53 | 10.93 |
| 08-words/long-english | 839 | 621.94 ± 0.2% | not timed | not timed | 596.47 ± 0.1% | 32.10 ± 0.4% | not timed | not timed | 622.76 ± 0.1% | | 1.00 | 1.04 | 19.37 |
| 09-aws-keys/full | 0 | 442.93 ± 0.1% | not timed | not timed | 474.90 ± 0.1% | 64.20 ± 3.6% | not timed | not timed | 441.49 ± 0.1% | | 1.00 | 0.93 | 6.90 |
| 09-aws-keys/quick | 0 | 873.83 ± 0.2% | not timed | not timed | 997.64 ± 0.3% | 415.93 ± 1.0% | not timed | not timed | 873.93 ± 0.4% | | 1.00 | 0.88 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 585.02 ± 3.2% | not timed | not timed | 515.98 ± 0.4% | 19.45 ± 0.4% | not timed | not timed | 582.77 ± 2.3% | | 1.00 | 1.13 | 30.08 |
| 10-bounded-repeat/letters-ru | 3475 | 502.81 ± 1.4% | not timed | not timed | 477.67 ± 0.1% | 21.45 ± 11.7% | not timed | not timed | 505.41 ± 1.5% | | 0.99 | 1.05 | 23.44 |
| 10-bounded-repeat/context | 53 | 84.52 ± 2.0% | not timed | not timed | 65.23 ± 1.1% | 19.77 ± 0.2% | not timed | not timed | 84.29 ± 1.8% | | 1.00 | 1.30 | 4.28 |
| 10-bounded-repeat/capitals | 11 | 631.86 ± 6.9% | not timed | not timed | 615.56 ± 0.1% | 36.46 ± 0.0% | not timed | not timed | 633.21 ± 8.1% | | 1.00 | 1.03 | 17.33 |
| 11-unstructured-to-json/extract | 600 | 57.04 ± 1.4% | not timed | not timed | 76.66 ± 0.2% | 48.91 ± 0.8% | not timed | not timed | 57.15 ± 0.8% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 560.37 ± 1.5% | not timed | not timed | 559.15 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 561.20 ± 1.0% | | 1.00 | 1.00 | 1380.12 |
| 14-quadratic/1x | 100 | 21.34 ± 0.8% | not timed | not timed | 9.95 ± 0.1% | 0.98 ± 3.5% | not timed | not timed | 21.38 ± 1.6% | | 1.00 | 2.15 | 21.87 |
| 14-quadratic/2x | 200 | 17.63 ± 1.4% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 0.6% | not timed | not timed | 17.78 ± 0.9% | | 0.99 | 3.18 | 33.27 |
| 14-quadratic/10x | 1000 | 7.76 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.77 ± 0.2% | | 1.00 | 6.41 | 67.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 2.4% | not timed | not timed | 0.34 ± 0.3% | 0.52 ± 2.2% | not timed | not timed | 1.26 ± 0.6% | | 0.99 | 3.65 | 2.39 |
| 04-ruff-noqa/compile-real | 1 | 105.21 ± 1.3% | not timed | not timed | 13.89 ± 0.5% | 132.79 ± 2.5% | not timed | not timed | 104.79 ± 1.7% | | 1.00 | 7.58 | 0.79 |
| 05-lexer-veryl/compile-single | 1 | 14.05 ± 1.3% | not timed | not timed | 2.52 ± 0.3% | 6.22 ± 2.2% | not timed | not timed | 14.06 ± 1.2% | | 1.00 | 5.57 | 2.26 |
| 07-unicode-character-data/compile | 1 | 108.41 ± 1.9% | not timed | not timed | 26.13 ± 0.4% | 35.43 ± 6.0% | not timed | not timed | 108.32 ± 1.7% | | 1.00 | 4.15 | 3.06 |
| 09-aws-keys/compile-full | 1 | 52.42 ± 1.7% | not timed | not timed | 8.25 ± 0.6% | 22.43 ± 3.3% | not timed | not timed | 52.63 ± 0.8% | | 1.00 | 6.35 | 2.34 |
| 09-aws-keys/compile-quick | 1 | 182.72 ± 0.6% | not timed | not timed | 47.58 ± 0.3% | 129.72 ± 4.3% | not timed | not timed | 181.63 ± 1.5% | | 1.01 | 3.84 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 70.90 ± 2.3% | not timed | not timed | 11.14 ± 0.2% | 15.57 ± 3.5% | not timed | not timed | 71.02 ± 1.2% | | 1.00 | 6.37 | 4.55 |
| 10-bounded-repeat/compile-capitals | 1 | 81.79 ± 1.8% | not timed | not timed | 8.06 ± 0.3% | 23.11 ± 3.0% | not timed | not timed | 81.89 ± 2.4% | | 1.00 | 10.14 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 171.26 ± 1.3% | not timed | not timed | 41.07 ± 0.5% | 66.08 ± 7.2% | not timed | not timed | 170.81 ± 1.1% | | 1.00 | 4.17 | 2.59 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.3% | not timed | not timed | 0.07 ± 15.1% | 0.09 ± 23.1% | not timed | not timed | 0.35 ± 1.3% | | 0.99 | 5.22 | 3.93 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.30 ± 0.4% | not timed | not timed | 6.56 ± 0.2% | 0.51 ± 18.4% | not timed | not timed | 7.30 ± 5.4% | | 1.00 | 1.11 | 14.37 |
| dictionary/search/english-10 | 690 | 1.15 ± 0.3% | not timed | not timed | 164.11 ± 0.8% | 0.00 ± 0.8% | not timed | not timed | 1.15 ± 0.5% | | 1.00 | 0.0070 | 413.28 |
| dictionary/search/english-15 | 15 | 565.04 ± 1.0% | not timed | not timed | 560.11 ± 0.1% | 0.36 ± 0.2% | not timed | not timed | 566.52 ± 1.1% | | 1.00 | 1.01 | 1549.72 |
| folly/awyer-inn-busted | 1 | 5586.28 ± 0.1% | not timed | not timed | 143.19 ± 0.1% | 43.74 ± 6.0% | not timed | not timed | 5605.04 ± 0.1% | | 1.00 | 39.01 | 127.72 |
| folly/literal-never-match-rare | 0 | 20978.46 ± 0.5% | not timed | not timed | 19772.55 ± 0.6% | 40545.48 ± 0.8% | not timed | not timed | 20980.37 ± 0.6% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12395.29 ± 1.0% | not timed | not timed | 19738.85 ± 14.8% | 2171.91 ± 1.7% | not timed | not timed | 12441.13 ± 2.5% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3231.04 ± 0.3% | not timed | not timed | 4401.03 ± 0.1% | 3042.04 ± 1.7% | not timed | not timed | 3239.28 ± 0.3% | | 1.00 | 0.73 | 1.06 |
| grep/every-line | 239963 | 1309.68 ± 1.2% | not timed | not timed | 947.04 ± 0.6% | 365.60 ± 19.7% | not timed | not timed | 1309.15 ± 0.6% | | 1.00 | 1.38 | 3.58 |
| grep/long-words-ascii | 5073 | 458.17 ± 0.3% | not timed | not timed | 468.43 ± 0.1% | 46.13 ± 6.2% | not timed | not timed | 457.44 ± 0.2% | | 1.00 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20342.82 ± 2.4% | not timed | not timed | 19102.14 ± 2.5% | 11696.90 ± 13.4% | not timed | not timed | 20337.98 ± 1.8% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 8991.78 ± 0.7% | not timed | not timed | 4215.28 ± 1.1% | 37.73 ± 0.1% | not timed | not timed | 9009.13 ± 1.0% | | 1.00 | 2.13 | 238.35 |
| imported/leipzig/shing | 1540 | 15136.03 ± 3.2% | not timed | not timed | 13331.87 ± 3.2% | 33.93 ± 0.2% | not timed | not timed | 15232.25 ± 4.5% | | 0.99 | 1.14 | 446.11 |
| imported/leipzig/huck-saw | 262 | 8086.26 ± 21.7% | not timed | not timed | 5473.90 ± 4.7% | 31.80 ± 0.2% | not timed | not timed | 8142.20 ± 18.2% | | 0.99 | 1.48 | 254.28 |
| imported/leipzig/word-ending-nn | 262 | 603.11 ± 0.6% | not timed | not timed | 615.75 ± 0.2% | 24.75 ± 0.2% | not timed | not timed | 604.10 ± 0.2% | | 1.00 | 0.98 | 24.36 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11082.11 ± 1.1% | not timed | not timed | 4415.52 ± 2.3% | 11.47 ± 0.1% | not timed | not timed | 11110.57 ± 1.5% | | 1.00 | 2.51 | 965.98 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7737.78 ± 1.4% | not timed | not timed | 5456.91 ± 0.3% | 16.79 ± 2.5% | not timed | not timed | 7782.80 ± 1.9% | | 0.99 | 1.42 | 460.78 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4156.87 ± 1.1% | not timed | not timed | 410.12 ± 2.4% | 11.08 ± 0.1% | not timed | not timed | 4140.71 ± 1.7% | | 1.00 | 10.14 | 375.27 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 600.76 ± 0.2% | not timed | not timed | 614.24 ± 0.1% | 11.12 ± 0.2% | not timed | not timed | 597.96 ± 0.5% | | 1.00 | 0.98 | 54.01 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 601.39 ± 0.5% | not timed | not timed | 614.17 ± 0.2% | 9.36 ± 0.1% | not timed | not timed | 601.93 ± 0.3% | | 1.00 | 0.98 | 64.22 |
| imported/leipzig/tom-river | 2 | 6352.16 ± 0.6% | not timed | not timed | 5036.96 ± 1.1% | 30.82 ± 0.1% | not timed | not timed | 6406.63 ± 0.6% | | 0.99 | 1.26 | 206.07 |
| imported/leipzig/ing | 78424 | 599.78 ± 1.0% | not timed | not timed | 570.04 ± 0.1% | 28.24 ± 4.3% | not timed | not timed | 600.88 ± 0.8% | | 1.00 | 1.05 | 21.24 |
| imported/leipzig/ing-whitespace | 55248 | 749.53 ± 0.8% | not timed | not timed | 2049.69 ± 0.6% | 20.54 ± 2.9% | not timed | not timed | 751.63 ± 0.7% | | 1.00 | 0.37 | 36.50 |
| imported/leipzig/awyer-inn | 209 | 766.55 ± 1.5% | not timed | not timed | 4224.47 ± 1.0% | 22.57 ± 0.1% | not timed | not timed | 766.82 ± 1.6% | | 1.00 | 0.18 | 33.96 |
| imported/leipzig/quotes-bounded | 8886 | 2105.66 ± 0.1% | not timed | not timed | 2919.13 ± 0.4% | 38.18 ± 0.1% | not timed | not timed | 2109.86 ± 0.2% | | 1.00 | 0.72 | 55.16 |
| imported/leipzig/non-ascii-alternate | 2 | 12666.40 ± 0.7% | not timed | not timed | 5606.76 ± 1.0% | 50.52 ± 0.6% | not timed | not timed | 12660.16 ± 2.3% | | 1.00 | 2.26 | 250.72 |
| imported/leipzig/math-symbols | 69 | 1979.70 ± 0.5% | not timed | not timed | 618.07 ± 0.1% | 36.42 ± 0.4% | not timed | not timed | 1982.45 ± 0.4% | | 1.00 | 3.20 | 54.35 |
| imported/leipzig/bounded-strings-ending-z | 0 | 584.29 ± 1.7% | not timed | not timed | 616.73 ± 0.1% | 22.55 ± 0.1% | not timed | not timed | 585.40 ± 1.1% | | 1.00 | 0.95 | 25.91 |
| imported/lh3lh3-reb/uri | 17549 | 678.88 ± 0.2% | not timed | not timed | 1070.58 ± 0.2% | 27.82 ± 2.2% | not timed | not timed | 678.51 ± 0.2% | | 1.00 | 0.63 | 24.40 |
| imported/lh3lh3-reb/email | 15057 | 672.95 ± 0.1% | not timed | not timed | 1164.24 ± 0.3% | 30.95 ± 2.4% | not timed | not timed | 672.49 ± 0.2% | | 1.00 | 0.58 | 21.74 |
| imported/lh3lh3-reb/date | 668 | 859.54 ± 0.2% | not timed | not timed | 1037.02 ± 0.2% | 51.28 ± 4.0% | not timed | not timed | 858.74 ± 0.3% | | 1.00 | 0.83 | 16.76 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.06 ± 0.1% | not timed | not timed | 422.98 ± 0.1% | 15.81 ± 1.3% | not timed | not timed | 644.25 ± 0.3% | | 1.00 | 1.53 | 40.81 |
| imported/mariomka/email | 92 | 24203.19 ± 1.3% | not timed | not timed | 29041.02 ± 1.5% | 32.73 ± 0.1% | not timed | not timed | 24187.35 ± 1.4% | | 1.00 | 0.83 | 739.59 |
| imported/mariomka/uri | 5301 | 5263.00 ± 1.4% | not timed | not timed | 6063.84 ± 0.6% | 32.71 ± 0.4% | not timed | not timed | 5297.18 ± 1.1% | | 0.99 | 0.87 | 160.91 |
| imported/mariomka/ip | 5 | 2151.13 ± 2.1% | not timed | not timed | 2937.36 ± 0.7% | 21.07 ± 0.2% | not timed | not timed | 2147.15 ± 2.2% | | 1.00 | 0.73 | 102.07 |
| imported/rsc/no-exponential | 0 | 604.00 ± 0.3% | not timed | not timed | 321.67 ± 0.1% | 23.83 ± 0.1% | not timed | not timed | 601.08 ± 0.1% | | 1.00 | 1.88 | 25.34 |
| imported/rsc/literal | 1 | 769.89 ± 8.5% | not timed | not timed | 1611.80 ± 5.0% | 188.44 ± 17.7% | not timed | not timed | 771.50 ± 8.8% | | 1.00 | 0.48 | 4.09 |
| imported/rsc/not-literal | 2 | 778.34 ± 2.0% | not timed | not timed | 725.02 ± 0.2% | 46.24 ± 9.8% | not timed | not timed | 781.48 ± 0.2% | | 1.00 | 1.07 | 16.83 |
| imported/rsc/match-class | 1 | 1437.35 ± 0.9% | not timed | not timed | 1661.81 ± 0.2% | 58.66 ± 6.8% | not timed | not timed | 1437.13 ± 2.6% | | 1.00 | 0.86 | 24.50 |
| imported/rsc/match-class-in-range | 1 | 1441.68 ± 2.3% | not timed | not timed | 2422.68 ± 5.0% | 60.10 ± 6.2% | not timed | not timed | 1437.40 ± 0.4% | | 1.00 | 0.60 | 23.99 |
| imported/rsc/match-class-unicode | 1 | 546.45 ± 1.8% | not timed | not timed | 510.64 ± 0.1% | 72.45 ± 7.3% | not timed | not timed | 547.69 ± 0.3% | | 1.00 | 1.07 | 7.54 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1441.99 ± 0.1% | not timed | not timed | 939.25 ± 0.1% | 227.46 ± 0.6% | not timed | not timed | 1443.27 ± 0.1% | | 1.00 | 1.54 | 6.34 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21642.39 ± 0.1% | not timed | not timed | 14189.93 ± 0.3% | 3409.25 ± 0.7% | not timed | not timed | 21629.20 ± 0.2% | | 1.00 | 1.53 | 6.35 |
| imported/rsc/anchored-literal-short-match | 4 | 711.43 ± 1.7% | not timed | not timed | 480.53 ± 0.2% | 84.43 ± 6.7% | not timed | not timed | 714.55 ± 0.8% | | 1.00 | 1.48 | 8.43 |
| imported/rsc/anchored-literal-long-match | 4 | 10651.81 ± 0.7% | not timed | not timed | 7314.12 ± 0.6% | 1219.41 ± 2.5% | not timed | not timed | 10671.47 ± 0.7% | | 1.00 | 1.46 | 8.74 |
| imported/rsc/one-pass-short | 17 | 372.08 ± 12.1% | not timed | not timed | 215.23 ± 0.1% | 31.45 ± 12.7% | not timed | not timed | 370.83 ± 1.8% | | 1.00 | 1.73 | 11.83 |
| imported/rsc/one-pass-short-not | 17 | 279.36 ± 4.7% | not timed | not timed | 224.74 ± 0.1% | 29.76 ± 9.6% | not timed | not timed | 281.47 ± 1.6% | | 0.99 | 1.24 | 9.39 |
| imported/rsc/one-pass-long-prefix | 26 | 363.19 ± 2.5% | not timed | not timed | 283.12 ± 0.1% | 107.70 ± 18.4% | not timed | not timed | 365.04 ± 8.2% | | 0.99 | 1.28 | 3.37 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.23 ± 4.5% | not timed | not timed | 283.60 ± 0.2% | 67.64 ± 20.3% | not timed | not timed | 362.41 ± 1.8% | | 0.99 | 1.27 | 5.31 |
| imported/rsc/long-needle1 | 31 | 22168.77 ± 0.1% | not timed | not timed | 20119.16 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 22167.47 ± 0.1% | | 1.00 | 1.10 | 5902.50 |
| imported/rsc/long-needle2 | 31 | 22290.82 ± 0.2% | not timed | not timed | 215.97 ± 0.1% | 3.75 ± 0.1% | not timed | not timed | 22302.35 ± 0.1% | | 1.00 | 103.21 | 5939.08 |
| imported/rsc/easy0-32 | 26 | 1089.16 ± 0.3% | not timed | not timed | 1512.61 ± 0.2% | 148.23 ± 24.1% | not timed | not timed | 1089.50 ± 2.9% | | 1.00 | 0.72 | 7.35 |
| imported/rsc/easy0-1k | 26 | 14910.61 ± 0.4% | not timed | not timed | 12408.44 ± 0.3% | 2303.22 ± 17.6% | not timed | not timed | 14905.52 ± 2.0% | | 1.00 | 1.20 | 6.47 |
| imported/rsc/easy0-32k | 26 | 22974.39 ± 1.4% | not timed | not timed | 20283.85 ± 0.2% | 18753.56 ± 20.4% | not timed | not timed | 22989.42 ± 0.3% | | 1.00 | 1.13 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 21988.44 ± 1.5% | not timed | not timed | 20051.55 ± 0.8% | 37334.80 ± 3.2% | not timed | not timed | 21955.69 ± 3.0% | | 1.00 | 1.10 | 0.59 |
| imported/rsc/easy1-32 | 19 | 793.17 ± 2.6% | not timed | not timed | 620.74 ± 0.2% | 129.66 ± 15.3% | not timed | not timed | 804.26 ± 0.2% | | 0.99 | 1.28 | 6.12 |
| imported/rsc/easy1-1k | 19 | 16460.90 ± 2.2% | not timed | not timed | 12901.13 ± 0.5% | 2471.27 ± 18.9% | not timed | not timed | 16476.27 ± 0.1% | | 1.00 | 1.28 | 6.66 |
| imported/rsc/easy1-32k | 19 | 516756.49 ± 0.2% | not timed | not timed | 398859.05 ± 0.2% | 20359.00 ± 21.6% | not timed | not timed | 516834.30 ± 0.2% | | 1.00 | 1.30 | 25.38 |
| imported/rsc/easy1-1mb | 19 | 16594475.81 ± 0.3% | not timed | not timed | 12892801.99 ± 0.3% | 36670.09 ± 2.8% | not timed | not timed | 16581011.57 ± 0.4% | | 1.00 | 1.29 | 452.53 |
| imported/rsc/medium-32 | 27 | 772.76 ± 2.6% | not timed | not timed | 628.78 ± 0.5% | 69.73 ± 12.7% | not timed | not timed | 773.29 ± 0.2% | | 1.00 | 1.23 | 11.08 |
| imported/rsc/medium-1k | 27 | 13684.87 ± 0.5% | not timed | not timed | 11098.06 ± 0.1% | 72.31 ± 0.1% | not timed | not timed | 13754.63 ± 0.5% | | 0.99 | 1.23 | 189.24 |
| imported/rsc/medium-32k | 27 | 427024.74 ± 0.7% | not timed | not timed | 344816.85 ± 0.1% | 48.39 ± 0.1% | not timed | not timed | 429696.58 ± 0.2% | | 0.99 | 1.24 | 8825.23 |
| imported/rsc/medium-1mb | 27 | 13661382.75 ± 0.6% | not timed | not timed | 11150976.59 ± 0.1% | 48.13 ± 0.2% | not timed | not timed | 13753654.46 ± 0.5% | | 0.99 | 1.23 | 283821.03 |
| imported/rsc/hard-32 | 58 | 419.15 ± 1.9% | not timed | not timed | 366.14 ± 0.1% | 49.61 ± 8.6% | not timed | not timed | 417.20 ± 0.2% | | 1.00 | 1.14 | 8.45 |
| imported/rsc/hard-1k | 27 | 13389.95 ± 0.6% | not timed | not timed | 11567.78 ± 0.4% | 40.70 ± 0.1% | not timed | not timed | 13304.97 ± 0.5% | | 1.01 | 1.16 | 328.95 |
| imported/rsc/hard-32k | 27 | 417189.42 ± 1.0% | not timed | not timed | 360921.63 ± 0.2% | 29.31 ± 0.1% | not timed | not timed | 415005.81 ± 0.8% | | 1.01 | 1.16 | 14235.31 |
| imported/rsc/hard-1mb | 51 | 8373420.41 ± 0.3% | not timed | not timed | 7164308.26 ± 0.1% | 29.33 ± 0.0% | not timed | not timed | 8304353.48 ± 0.1% | | 1.01 | 1.17 | 285521.23 |
| imported/rsc/reallyhard0-32 | 58 | 266.82 ± 2.5% | not timed | not timed | 222.04 ± 0.1% | 49.54 ± 8.6% | not timed | not timed | 266.95 ± 0.3% | | 1.00 | 1.20 | 5.39 |
| imported/rsc/reallyhard0-1k | 27 | 590.35 ± 0.2% | not timed | not timed | 582.13 ± 0.6% | 40.60 ± 0.2% | not timed | not timed | 589.86 ± 1.9% | | 1.00 | 1.01 | 14.54 |
| imported/rsc/reallyhard0-32k | 27 | 609.32 ± 0.2% | not timed | not timed | 617.00 ± 0.2% | 29.32 ± 0.1% | not timed | not timed | 609.45 ± 0.3% | | 1.00 | 0.99 | 20.78 |
| imported/rsc/reallyhard0-1mb | 51 | 589.24 ± 0.4% | not timed | not timed | 616.65 ± 0.2% | 29.32 ± 0.1% | not timed | not timed | 588.87 ± 0.3% | | 1.00 | 0.96 | 20.09 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.73 ± 1.8% | not timed | not timed | 196.92 ± 0.8% | 61.26 ± 11.4% | not timed | not timed | 288.41 ± 1.6% | | 1.00 | 1.47 | 4.71 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6874.62 ± 0.1% | not timed | not timed | 5917.24 ± 0.1% | 33.89 ± 5.3% | not timed | not timed | 6871.49 ± 0.1% | | 1.00 | 1.16 | 202.88 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21489.03 ± 0.2% | not timed | not timed | 19259.51 ± 0.1% | 24.06 ± 0.9% | not timed | not timed | 21480.83 ± 0.1% | | 1.00 | 1.12 | 893.05 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21866.07 ± 0.8% | not timed | not timed | 19956.75 ± 0.9% | 24.80 ± 1.5% | not timed | not timed | 21875.05 ± 0.8% | | 1.00 | 1.10 | 881.57 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.09 ± 1.6% | not timed | not timed | 211.80 ± 0.2% | 60.48 ± 13.2% | not timed | not timed | 282.59 ± 1.3% | | 1.00 | 1.33 | 4.66 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5883.36 ± 0.0% | not timed | not timed | 6164.83 ± 0.1% | 34.34 ± 0.3% | not timed | not timed | 5875.81 ± 0.1% | | 1.00 | 0.95 | 171.31 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21403.97 ± 0.1% | not timed | not timed | 19137.74 ± 0.1% | 24.97 ± 0.6% | not timed | not timed | 21367.14 ± 0.1% | | 1.00 | 1.12 | 857.22 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21065.22 ± 1.1% | not timed | not timed | 19549.63 ± 1.2% | 25.10 ± 0.4% | not timed | not timed | 21175.16 ± 0.3% | | 0.99 | 1.08 | 839.15 |
| imported/sherlock/name-sherlock | 776 | 19176.80 ± 2.6% | not timed | not timed | 18161.01 ± 0.8% | 9864.03 ± 27.2% | not timed | not timed | 19333.14 ± 1.7% | | 0.99 | 1.06 | 1.94 |
| imported/sherlock/name-holmes | 2766 | 14825.23 ± 1.7% | not timed | not timed | 15239.97 ± 0.7% | 3049.74 ± 14.9% | not timed | not timed | 14959.39 ± 2.1% | | 0.99 | 0.97 | 4.86 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19261.74 ± 2.2% | not timed | not timed | 18199.48 ± 1.6% | 7941.03 ± 21.7% | not timed | not timed | 19312.19 ± 2.3% | | 1.00 | 1.06 | 2.43 |
| imported/sherlock/name-sherlock-casei | 816 | 15487.84 ± 0.7% | not timed | not timed | 4001.12 ± 0.1% | 32.50 ± 0.3% | not timed | not timed | 15491.43 ± 0.7% | | 1.00 | 3.87 | 476.49 |
| imported/sherlock/name-holmes-casei | 2802 | 9372.14 ± 5.3% | not timed | not timed | 3295.76 ± 0.1% | 37.56 ± 1.2% | not timed | not timed | 9387.97 ± 3.1% | | 1.00 | 2.84 | 249.52 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13028.72 ± 7.6% | not timed | not timed | 3935.01 ± 0.2% | 32.48 ± 0.2% | not timed | not timed | 13042.72 ± 1.1% | | 1.00 | 3.31 | 401.12 |
| imported/sherlock/name-whitespace | 1461 | 14969.26 ± 7.5% | not timed | not timed | 14285.55 ± 0.5% | 6964.91 ± 42.2% | not timed | not timed | 15050.24 ± 2.1% | | 0.99 | 1.05 | 2.15 |
| imported/sherlock/name-alt1 | 1142 | 11605.90 ± 0.8% | not timed | not timed | 15964.27 ± 1.4% | 4075.62 ± 17.7% | not timed | not timed | 11622.09 ± 3.4% | | 1.00 | 0.73 | 2.85 |
| imported/sherlock/name-alt2 | 3542 | 8935.63 ± 0.9% | not timed | not timed | 3818.43 ± 0.2% | 31.36 ± 0.1% | not timed | not timed | 8934.04 ± 0.4% | | 1.00 | 2.34 | 284.95 |
| imported/sherlock/name-alt3 | 4507 | 5540.23 ± 0.6% | not timed | not timed | 3619.00 ± 0.1% | 9.90 ± 2.1% | not timed | not timed | 5552.94 ± 0.7% | | 1.00 | 1.53 | 559.90 |
| imported/sherlock/name-alt3-casei | 4593 | 1518.72 ± 2.5% | not timed | not timed | 284.27 ± 0.3% | 6.45 ± 0.1% | not timed | not timed | 1524.85 ± 1.5% | | 1.00 | 5.34 | 235.53 |
| imported/sherlock/name-alt4 | 3686 | 6377.33 ± 0.4% | not timed | not timed | 3765.51 ± 0.2% | 31.32 ± 0.1% | not timed | not timed | 6375.36 ± 0.4% | | 1.00 | 1.69 | 203.60 |
| imported/sherlock/name-alt4-casei | 4254 | 2802.15 ± 2.2% | not timed | not timed | 2554.98 ± 0.1% | 19.85 ± 0.3% | not timed | not timed | 2811.44 ± 1.1% | | 1.00 | 1.10 | 141.16 |
| imported/sherlock/name-alt5 | 4028 | 6425.76 ± 0.6% | not timed | not timed | 3736.86 ± 0.1% | 21.75 ± 0.1% | not timed | not timed | 6424.10 ± 0.4% | | 1.00 | 1.72 | 295.39 |
| imported/sherlock/name-alt5-casei | 4104 | 3505.90 ± 2.0% | not timed | not timed | 2214.89 ± 0.1% | 14.22 ± 0.1% | not timed | not timed | 3513.53 ± 1.1% | | 1.00 | 1.58 | 246.55 |
| imported/sherlock/no-match-uncommon | 0 | 20959.84 ± 1.0% | not timed | not timed | 19106.20 ± 0.3% | 33334.38 ± 0.9% | not timed | not timed | 20873.78 ± 0.5% | | 1.00 | 1.10 | 0.63 |
| imported/sherlock/no-match-common | 0 | 20666.47 ± 0.6% | not timed | not timed | 19033.50 ± 0.8% | 1274.30 ± 0.2% | not timed | not timed | 20707.59 ± 0.8% | | 1.00 | 1.09 | 16.22 |
| imported/sherlock/no-match-really-common | 0 | 15621.82 ± 3.1% | not timed | not timed | 18257.35 ± 1.0% | 1278.35 ± 1.2% | not timed | not timed | 15629.47 ± 2.1% | | 1.00 | 0.86 | 12.22 |
| imported/sherlock/the-lower | 21654 | 2296.75 ± 1.2% | not timed | not timed | 2316.51 ± 1.4% | 236.46 ± 16.1% | not timed | not timed | 2312.25 ± 1.9% | | 0.99 | 0.99 | 9.71 |
| imported/sherlock/the-upper | 2223 | 12512.55 ± 1.2% | not timed | not timed | 13334.06 ± 0.5% | 2650.66 ± 1.4% | not timed | not timed | 12543.74 ± 1.5% | | 1.00 | 0.94 | 4.72 |
| imported/sherlock/the-casei | 23961 | 1997.10 ± 0.7% | not timed | not timed | 1314.84 ± 0.2% | 34.25 ± 34.3% | not timed | not timed | 1999.70 ± 0.5% | | 1.00 | 1.52 | 58.31 |
| imported/sherlock/everything-greedy | 581881 | 282.30 ± 0.3% | not timed | not timed | 165.68 ± 0.5% | 28.58 ± 21.8% | not timed | not timed | 283.11 ± 1.5% | | 1.00 | 1.70 | 9.88 |
| imported/sherlock/everything-greedy-nl | 594933 | 461.03 ± 0.1% | not timed | not timed | 211.61 ± 0.3% | 32.77 ± 0.2% | not timed | not timed | 461.07 ± 0.1% | | 1.00 | 2.18 | 14.07 |
| imported/sherlock/letters | 447175 | 62.27 ± 1.3% | not timed | not timed | 32.97 ± 0.1% | 6.13 ± 23.4% | not timed | not timed | 62.32 ± 0.8% | | 1.00 | 1.89 | 10.16 |
| imported/sherlock/letters-upper | 14180 | 452.43 ± 1.2% | not timed | not timed | 369.77 ± 0.3% | 29.42 ± 27.7% | not timed | not timed | 452.25 ± 0.3% | | 1.00 | 1.22 | 15.38 |
| imported/sherlock/letters-lower | 432995 | 62.96 ± 1.1% | not timed | not timed | 33.50 ± 0.2% | 5.77 ± 42.2% | not timed | not timed | 63.56 ± 1.0% | | 0.99 | 1.88 | 10.91 |
| imported/sherlock/words | 447639 | 115.59 ± 0.8% | not timed | not timed | 74.06 ± 0.1% | 13.82 ± 9.0% | not timed | not timed | 115.52 ± 6.6% | | 1.00 | 1.56 | 8.37 |
| imported/sherlock/before-holmes | 4073 | 10215.29 ± 0.5% | not timed | not timed | 8372.78 ± 0.3% | 24.00 ± 1.1% | not timed | not timed | 10250.15 ± 0.4% | | 1.00 | 1.22 | 425.58 |
| imported/sherlock/before-after-holmes | 2593 | 9803.53 ± 1.2% | not timed | not timed | 9434.50 ± 0.3% | 24.06 ± 1.6% | not timed | not timed | 9805.61 ± 0.6% | | 1.00 | 1.04 | 407.46 |
| imported/sherlock/holmes-cochar-watson | 150 | 5177.25 ± 0.4% | not timed | not timed | 3414.26 ± 0.1% | 30.94 ± 0.3% | not timed | not timed | 5175.14 ± 0.4% | | 1.00 | 1.52 | 167.36 |
| imported/sherlock/holmes-coword-watson | 14309 | 1181.53 ± 0.6% | not timed | not timed | 1118.04 ± 0.1% | 6.71 ± 0.1% | not timed | not timed | 1181.94 ± 0.4% | | 1.00 | 1.06 | 176.11 |
| imported/sherlock/quotes | 14437 | 1397.48 ± 0.4% | not timed | not timed | 1751.25 ± 0.7% | 34.96 ± 0.2% | not timed | not timed | 1387.75 ± 0.5% | | 1.01 | 0.80 | 39.97 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 608.36 ± 0.1% | not timed | not timed | 15865.59 ± 0.4% | 36.61 ± 0.1% | not timed | not timed | 608.28 ± 0.6% | | 1.00 | 0.0383 | 16.62 |
| imported/sherlock/word-ending-n | 35297 | 478.91 ± 1.2% | not timed | not timed | 407.70 ± 0.1% | 23.35 ± 21.4% | not timed | not timed | 480.48 ± 0.4% | | 1.00 | 1.17 | 20.51 |
| imported/sherlock/repeated-class-negation | 2130 | 14398.61 ± 1.2% | not timed | not timed | 10865.90 ± 1.9% | 11.55 ± 0.2% | not timed | not timed | 14400.75 ± 1.2% | | 1.00 | 1.33 | 1246.98 |
| imported/sherlock/ing-suffix | 20547 | 564.67 ± 0.3% | not timed | not timed | 516.16 ± 0.2% | 28.80 ± 0.1% | not timed | not timed | 565.47 ± 0.4% | | 1.00 | 1.09 | 19.61 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 605.94 ± 0.6% | not timed | not timed | 2101.79 ± 0.4% | 20.51 ± 0.2% | not timed | not timed | 606.43 ± 0.3% | | 1.00 | 0.29 | 29.55 |
| opt/accelerate/whole-line | 239963 | 457.63 ± 0.2% | not timed | not timed | 372.30 ± 0.1% | 92.57 ± 17.2% | not timed | not timed | 457.08 ± 0.4% | | 1.00 | 1.23 | 4.94 |
| opt/accelerate/non-dna | 16745 | 425.10 ± 0.9% | not timed | not timed | 398.07 ± 0.1% | 29.47 ± 19.0% | not timed | not timed | 427.39 ± 0.3% | | 0.99 | 1.07 | 14.43 |
| opt/backtrack/words-english | 40536 | 136.32 ± 0.3% | not timed | not timed | 94.45 ± 0.2% | 19.93 ± 6.0% | not timed | not timed | 136.12 ± 8.3% | | 1.00 | 1.44 | 6.84 |
| opt/fixed-length/too-small-ascii | 0 | 309.63 ± 0.6% | not timed | not timed | 700.98 ± 4.7% | 79.91 ± 0.8% | not timed | not timed | 315.45 ± 0.3% | | 0.98 | 0.44 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3442.25 ± 0.2% | not timed | not timed | 5840.50 ± 0.3% | 126.49 ± 0.4% | not timed | not timed | 3435.05 ± 0.2% | | 1.00 | 0.59 | 27.21 |
| opt/fixed-length/go33484-1 | 0 | 661822.74 ± 0.2% | not timed | not timed | 1110419.01 ± 0.5% | 61243.90 ± 0.2% | not timed | not timed | 659899.36 ± 0.1% | | 1.00 | 0.60 | 10.81 |
| opt/fixed-length/go33484-2 | 0 | 662359.32 ± 0.1% | not timed | not timed | 1117546.90 ± 0.8% | 32426.39 ± 0.7% | not timed | not timed | 659948.28 ± 0.2% | | 1.00 | 0.59 | 20.43 |
| opt/fixed-length/go33484-3 | 0 | 2413.71 ± 1.7% | not timed | not timed | 111214.29 ± 0.3% | 759.42 ± 0.3% | not timed | not timed | 2400.96 ± 3.5% | | 1.01 | 0.0217 | 3.18 |
| opt/literal-alt/one-pattern | 1 | 545.24 ± 1.5% | not timed | not timed | 536.58 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 547.02 ± 1.2% | | 1.00 | 1.02 | 1364.37 |
| opt/onepass/fn-predicate | 916 | 364.74 ± 0.8% | not timed | not timed | 336.64 ± 0.1% | 197.19 ± 16.8% | not timed | not timed | 367.32 ± 0.4% | | 0.99 | 1.08 | 1.85 |
| opt/onepass/first-three-words-english | 35128 | 176.15 ± 2.9% | not timed | not timed | 198.87 ± 0.3% | 73.53 ± 13.1% | not timed | not timed | 176.39 ± 2.8% | | 1.00 | 0.89 | 2.40 |
| opt/prefilter/literal-english | 1 | 20311.29 ± 0.8% | not timed | not timed | 19594.19 ± 0.3% | 17379.84 ± 0.4% | not timed | not timed | 20330.83 ± 0.7% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14318.32 ± 0.4% | not timed | not timed | 4308.11 ± 0.1% | 32.69 ± 0.4% | not timed | not timed | 14342.75 ± 0.1% | | 1.00 | 3.32 | 438.04 |
| opt/prefilter/literal-russian | 1 | 21075.55 ± 0.7% | not timed | not timed | 19843.79 ± 1.0% | 3308.20 ± 0.1% | not timed | not timed | 21074.02 ± 0.4% | | 1.00 | 1.06 | 6.37 |
| opt/prefilter/literal-casei-russian | 1 | 8558.88 ± 0.2% | not timed | not timed | 3881.37 ± 0.1% | 31.71 ± 0.2% | not timed | not timed | 8560.74 ± 0.2% | | 1.00 | 2.21 | 269.89 |
| opt/prefilter/rust-functions | 948 | 6663.16 ± 19.7% | not timed | not timed | 8847.08 ± 16.4% | 1856.07 ± 2.3% | not timed | not timed | 6681.54 ± 19.7% | | 1.00 | 0.75 | 3.59 |
| opt/reverse-anchored/word-end | 1 | 29943334.23 ± 0.1% | not timed | not timed | 21007049.48 ± 0.1% | 50.44 ± 0.1% | not timed | not timed | 29971065.77 ± 0.3% | | 1.00 | 1.43 | 593646.43 |
| opt/reverse-inner/holmes | 2593 | 9814.05 ± 0.8% | not timed | not timed | 9460.36 ± 0.5% | 23.90 ± 0.9% | not timed | not timed | 9800.88 ± 0.9% | | 1.00 | 1.04 | 410.64 |
| opt/reverse-inner/email | 47 | 35880.44 ± 2.2% | not timed | not timed | 44348.67 ± 1.3% | 32.40 ± 0.1% | not timed | not timed | 36140.02 ± 2.0% | | 0.99 | 0.81 | 1107.38 |
| opt/reverse-inner/factored-prefix | 3542 | 599.30 ± 0.2% | not timed | not timed | 593.90 ± 0.1% | 12.46 ± 0.3% | not timed | not timed | 598.45 ± 0.1% | | 1.00 | 1.01 | 48.10 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5550.90 ± 0.1% | not timed | not timed | 610.22 ± 0.3% | 74.98 ± 0.1% | not timed | not timed | 5525.94 ± 0.1% | | 1.00 | 9.10 | 74.03 |
| opt/reverse-inner/no-quadratic-forward | 0 | 696.59 ± 6.2% | not timed | not timed | 288.76 ± 0.2% | 24.81 ± 0.0% | not timed | not timed | 734.12 ± 10.0% | | 0.95 | 2.41 | 28.07 |
| opt/reverse-suffix/holmes | 4073 | 10220.86 ± 0.6% | not timed | not timed | 8419.67 ± 0.8% | 23.82 ± 1.7% | not timed | not timed | 10242.14 ± 0.6% | | 1.00 | 1.21 | 429.16 |
| opt/reverse-suffix/no-quadratic | 0 | 5525.51 ± 0.1% | not timed | not timed | 613.36 ± 0.3% | 74.99 ± 0.1% | not timed | not timed | 5555.12 ± 0.2% | | 0.99 | 9.01 | 73.68 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.33 ± 2.4% | not timed | not timed | 131.69 ± 0.2% | 13.32 ± 15.6% | not timed | not timed | 120.93 ± 2.3% | | 1.00 | 0.92 | 9.11 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.23 ± 2.4% | not timed | not timed | 132.95 ± 0.2% | 13.29 ± 14.7% | not timed | not timed | 121.20 ± 3.1% | | 1.01 | 0.92 | 9.20 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.1% | 112.17 ± 1.3% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.01 ± 0.3% | not timed | not timed | 293.73 ± 0.2% | 103.41 ± 8.4% | not timed | not timed | 315.70 ± 3.6% | | 1.00 | 1.08 | 3.07 |
| reported/i13-subset-regex/original-ascii | 4094 | 11087.84 ± 1.0% | not timed | not timed | 4400.70 ± 0.4% | 11.49 ± 0.2% | not timed | not timed | 11080.85 ± 2.1% | | 1.00 | 2.52 | 964.62 |
| reported/i13-subset-regex/original-unicode | 4094 | 10914.87 ± 2.6% | not timed | not timed | 248.87 ± 3.2% | 11.49 ± 0.1% | not timed | not timed | 11069.51 ± 2.0% | | 0.99 | 43.86 | 950.26 |
| reported/i13-subset-regex/big-ascii | 1955 | 10498.67 ± 2.0% | not timed | not timed | 68.01 ± 3.7% | 9.84 ± 0.1% | not timed | not timed | 10642.37 ± 1.6% | | 0.99 | 154.38 | 1066.92 |
| reported/i13-subset-regex/big-unicode | 1955 | 10369.90 ± 1.7% | not timed | not timed | 12.19 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10597.25 ± 2.2% | | 0.98 | 850.54 | 1053.03 |
| reported/i13-subset-regex/huge-ascii | 55 | 9823.86 ± 2.1% | not timed | not timed | 11.01 ± 0.1% | 8.76 ± 0.2% | not timed | not timed | 9801.17 ± 3.4% | | 1.00 | 892.44 | 1121.25 |
| reported/i13-subset-regex/huge-unicode | 55 | 9673.14 ± 3.3% | not timed | not timed | 11.00 ± 0.4% | 8.77 ± 0.3% | not timed | not timed | 9689.68 ± 4.4% | | 1.00 | 879.27 | 1103.08 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.55 ± 0.0% | not timed | not timed | 11.01 ± 0.1% | 8.77 ± 0.4% | not timed | not timed | 3.55 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.02 ± 0.2% | not timed | not timed | 11.01 ± 0.4% | 8.75 ± 1.3% | not timed | not timed | 5.02 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 486.22 ± 0.3% | not timed | not timed | 104.16 ± 0.1% | 6.61 ± 0.0% | not timed | not timed | 487.22 ± 0.6% | | 1.00 | 4.67 | 73.51 |
| reported/i787-keywords/opt-ascii | 5674 | 487.05 ± 0.3% | not timed | not timed | 275.51 ± 0.2% | 10.22 ± 0.2% | not timed | not timed | 487.59 ± 0.4% | | 1.00 | 1.77 | 47.65 |
| slow/quadratic-regex-1x | 100 | 7.12 ± 0.2% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 0.3% | not timed | not timed | 7.14 ± 0.3% | | 1.00 | 1.44 | 144.66 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.2% | not timed | not timed | 2.76 ± 0.4% | 0.01 ± 0.5% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 269.15 |
| slow/quadratic-haystack-1x | 100 | 21.26 ± 6.3% | not timed | not timed | 10.03 ± 0.1% | 1.00 ± 13.6% | not timed | not timed | 21.38 ± 1.3% | | 0.99 | 2.12 | 21.17 |
| slow/quadratic-haystack-2x | 200 | 17.75 ± 1.5% | not timed | not timed | 5.54 ± 0.1% | 0.54 ± 0.3% | not timed | not timed | 17.79 ± 14.1% | | 1.00 | 3.21 | 32.61 |
| unicode/codepoints/any-one | 1112064 | 290.58 ± 0.2% | not timed | not timed | 174.68 ± 0.1% | 18.26 ± 4.2% | not timed | not timed | 290.71 ± 0.3% | | 1.00 | 1.66 | 15.91 |
| unicode/codepoints/any-all | 4382592 | 268.90 ± 0.3% | not timed | not timed | 245.83 ± 0.3% | 117.03 ± 0.2% | not timed | not timed | 269.36 ± 0.2% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.75 ± 1.4% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 602.44 ± 0.7% | not timed | not timed | 614.98 ± 0.2% | 135.17 ± 0.1% | not timed | not timed | 600.76 ± 1.0% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.97 ± 0.5% | not timed | not timed | 38.82 ± 0.1% | 3.90 ± 1.1% | not timed | not timed | 31.97 ± 0.3% | | 1.00 | 0.82 | 8.19 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.2% | not timed | not timed | 3.22 ± 1.7% | 2.35 ± 1.0% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.45 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.27 ± 10.7% | not timed | not timed | 3.57 ± 0.3% | 6.27 ± 9.9% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.36 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 124.34 ± 9.4% | not timed | not timed | 82.54 ± 0.1% | 11.41 ± 20.0% | not timed | not timed | 128.20 ± 1.6% | | 0.97 | 1.51 | 10.89 |
| unicode/word/boundary-long-english | 3466 | 613.88 ± 0.3% | not timed | not timed | 602.14 ± 0.1% | 32.41 ± 0.3% | not timed | not timed | 614.26 ± 0.6% | | 1.00 | 1.02 | 18.94 |
| unicode/word/around-holmes-english | 27 | 19454.93 ± 0.2% | not timed | not timed | 19295.50 ± 0.6% | 22.18 ± 1.2% | not timed | not timed | 19420.17 ± 0.5% | | 1.00 | 1.01 | 877.01 |
| wild/bibleref/long | 874 | 561.82 ± 0.2% | not timed | not timed | 583.14 ± 0.2% | 6.80 ± 0.1% | not timed | not timed | 561.06 ± 0.2% | | 1.00 | 0.96 | 82.58 |
| wild/bibleref/short | 30 | 24.65 ± 3.8% | not timed | not timed | 30.84 ± 0.4% | 13.91 ± 11.3% | not timed | not timed | 24.53 ± 4.4% | | 1.00 | 0.80 | 1.77 |
| wild/bibleref/line | 874 | 396.22 ± 0.1% | not timed | not timed | 216.92 ± 0.2% | 9.15 ± 0.3% | not timed | not timed | 395.58 ± 0.2% | | 1.00 | 1.83 | 43.31 |
| wild/caddy/caddy | 6 | 416.90 ± 3.0% | not timed | not timed | 242.09 ± 0.1% | 68.26 ± 13.5% | not timed | not timed | 416.25 ± 0.2% | | 1.00 | 1.72 | 6.11 |
| wild/dot-star-capture/rust-src-tools | 6 | 1067.40 ± 0.3% | not timed | not timed | 349.38 ± 0.3% | 13.45 ± 0.0% | not timed | not timed | 1066.07 ± 0.2% | | 1.00 | 3.06 | 79.37 |
| wild/ruff/noqa | 84 | 438.14 ± 0.1% | not timed | not timed | 478.63 ± 0.3% | 19.51 ± 2.3% | not timed | not timed | 436.32 ± 0.1% | | 1.00 | 0.92 | 22.46 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.66 ± 0.6% | not timed | not timed | 702.28 ± 0.2% | 135.41 ± 10.9% | not timed | not timed | 958.29 ± 0.6% | | 1.00 | 1.36 | 7.07 |
| wild/ruff/string-quote-prefix | 2972 | 1353.81 ± 0.7% | not timed | not timed | 443.40 ± 0.1% | 314.70 ± 25.0% | not timed | not timed | 1350.68 ± 0.8% | | 1.00 | 3.05 | 4.30 |
| wild/ruff/space-around-operator | 1224378 | 220.31 ± 2.0% | not timed | not timed | 186.76 ± 0.1% | 18.38 ± 1.7% | not timed | not timed | 221.15 ± 2.0% | | 1.00 | 1.18 | 11.99 |
| wild/ruff/shebang | 282 | 981.78 ± 0.5% | not timed | not timed | 327.98 ± 0.1% | 117.61 ± 9.5% | not timed | not timed | 981.82 ± 0.5% | | 1.00 | 2.99 | 8.35 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13701.36 ± 0.3% | not timed | not timed | 13689.61 ± 0.9% | 6853.00 ± 1.5% | not timed | not timed | 13689.92 ± 0.4% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12711.20 ± 0.8% | not timed | not timed | 13333.71 ± 0.8% | 6326.18 ± 0.7% | not timed | not timed | 12702.47 ± 0.4% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13086.08 ± 0.6% | not timed | not timed | 13497.95 ± 0.6% | 6548.27 ± 0.6% | not timed | not timed | 13079.28 ± 0.5% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9466.99 ± 0.1% | not timed | not timed | 13421.80 ± 0.4% | 6624.98 ± 1.7% | not timed | not timed | 9466.90 ± 0.7% | | 1.00 | 0.71 | 1.43 |
| wild/url/search | 234965 | 121.33 ± 13.5% | not timed | not timed | 65.01 ± 0.2% | 2.19 ± 0.7% | not timed | not timed | 122.08 ± 13.7% | | 0.99 | 1.87 | 55.33 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.0% | not timed | not timed | 0.01 ± 1.1% | 0.01 ± 19.6% | not timed | not timed | 0.03 ± 6.5% | | 0.98 | 3.04 | 4.05 |
| dictionary/compile/english-15 | 1 | 0.35 ± 20.7% | not timed | not timed | 0.07 ± 1.4% | 0.10 ± 14.5% | not timed | not timed | 0.35 ± 2.7% | | 0.99 | 5.17 | 3.31 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 1.8% | not timed | not timed | 0.02 ± 28.0% | 34.73 ± 3.4% | not timed | not timed | 0.23 ± 1.4% | | 0.98 | 12.65 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.71 ± 2.4% | not timed | not timed | 11.50 ± 0.4% | 51.46 ± 19.1% | not timed | not timed | 46.08 ± 2.5% | | 0.99 | 3.97 | 0.89 |
| reported/i787-keywords/compile | 1 | 35.13 ± 5.2% | not timed | not timed | 2.13 ± 1.0% | 16.78 ± 36.7% | not timed | not timed | 35.10 ± 5.5% | | 1.00 | 16.50 | 2.09 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 350.13 ± 11.5% | not timed | not timed | 121.18 ± 0.3% | 574.02 ± 29.4% | not timed | not timed | 347.77 ± 6.7% | | 1.01 | 2.89 | 0.61 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.43 ± 3.1% | not timed | not timed | 4.09 ± 0.6% | 40.32 ± 10.2% | not timed | not timed | 48.36 ± 2.8% | | 0.98 | 11.61 | 1.18 |
| unicode/compile/one-letter | 53 | 6.61 ± 14.3% | not timed | not timed | 4.54 ± 0.4% | 63.91 ± 8.2% | not timed | not timed | 6.76 ± 10.3% | | 0.98 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.00 ± 17.9% | not timed | not timed | 0.10 ± 0.7% | 64.93 ± 8.2% | not timed | not timed | 1.03 ± 12.1% | | 0.98 | 10.33 | 0.0154 |
| unicode/compile/fifty-letters-ascii | 1 | 210.17 ± 3.7% | not timed | not timed | 52.93 ± 0.2% | 172.18 ± 17.8% | not timed | not timed | 211.80 ± 3.5% | | 0.99 | 3.97 | 1.22 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 377.65 ± 21.0% | not timed | not timed | 47.04 ± 0.2% | 667.56 ± 28.6% | not timed | not timed | 378.91 ± 1.9% | | 1.00 | 8.03 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 596.36 ± 14.9% | not timed | not timed | 144.75 ± 0.1% | 656.97 ± 23.5% | not timed | not timed | 600.19 ± 4.1% | | 0.99 | 4.12 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 310.78 ± 6.9% | not timed | not timed | 50.45 ± 0.4% | 1254.75 ± 27.4% | not timed | not timed | 315.08 ± 2.3% | | 0.99 | 6.16 | 0.25 |
| wild/bibleref/compile | 3 | 5.78 ± 4.0% | not timed | not timed | 1.93 ± 0.5% | 31.96 ± 17.8% | not timed | not timed | 5.94 ± 25.8% | | 0.97 | 3.00 | 0.18 |
| wild/url/compile | 1 | 0.64 ± 19.8% | not timed | not timed | 0.14 ± 0.3% | 0.45 ± 32.5% | not timed | not timed | 0.64 ± 16.8% | | 0.99 | 4.45 | 1.42 |

