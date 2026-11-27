# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261122.195.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
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
| literal: a word | 217 | 19654.61 ± 2.7% | 10845.40 ± 0.5% | 28.11 ± 0.1% | 18039.84 ± 1.3% | 9033.91 ± 7.7% | 17.42 ± 0.3% | 86.72 ± 0.5% | 19420.25 ± 2.9% | 1.81 | 1.01 | 1.09 | 2.18 |
| literal: a word that is not there | 0 | 21342.12 ± 5.2% | 9849.25 ± 2.0% | 28.32 ± 0.7% | 19194.31 ± 3.2% | 28685.49 ± 1.4% | 17.20 ± 0.2% | 80.92 ± 0.4% | 21264.01 ± 4.1% | 2.17 | 1.00 | 1.11 | 0.74 |
| literal: one of four words | 661 | 6420.60 ± 0.3% | 1793.44 ± 0.4% | 14.41 ± 0.3% | 3945.07 ± 0.2% | 21.86 ± 0.1% | 5.26 ± 0.2% | 6.95 ± 0.2% | 6424.44 ± 0.5% | 3.58 | 1.00 | 1.63 | 293.78 |
| literal: a word in any case | 217 | 15152.42 ± 1.1% | 1918.16 ± 0.3% | 21.53 ± 0.2% | 3962.73 ± 0.2% | 37.98 ± 0.9% | refused | differs | 15125.66 ± 1.0% | 7.90 | 1.00 | 3.82 | 398.97 |
| literal: an href attribute | 33 | 16807.72 ± 2.9% | 608.37 ± 0.6% | 27.22 ± 0.2% | 16948.86 ± 1.7% | 2258.76 ± 3.9% | 13.32 ± 0.3% | 75.56 ± 0.3% | 16854.47 ± 2.4% | 27.63 | 1.00 | 0.99 | 7.44 |
| literal: a word, second text | 123 | 19901.27 ± 3.9% | 4577.15 ± 0.5% | 27.96 ± 0.4% | 18337.46 ± 3.7% | 7675.46 ± 5.2% | 19.66 ± 0.4% | 71.29 ± 0.8% | 19885.93 ± 1.5% | 4.35 | 1.00 | 1.09 | 2.59 |
| class: two capitalized words | 1331 | 1178.62 ± 0.4% | 598.55 ± 0.4% | 25.99 ± 0.4% | 586.33 ± 0.1% | 40.71 ± 5.6% | 14.82 ± 0.5% | 67.93 ± 0.7% | 1177.72 ± 0.5% | 1.97 | 1.00 | 2.01 | 28.95 |
| class: a word that ends in ing | 3399 | 574.13 ± 0.1% | 573.80 ± 0.2% | 17.89 ± 0.3% | 547.93 ± 0.1% | 29.66 ± 12.2% | 8.12 ± 0.4% | 18.39 ± 0.2% | 575.33 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.36 |
| class: a word in capitals | 2332 | 1536.09 ± 0.3% | 607.70 ± 0.4% | 27.64 ± 0.5% | 572.81 ± 0.3% | 43.54 ± 0.2% | 17.22 ± 0.4% | 83.23 ± 0.4% | 1534.73 ± 0.3% | 2.53 | 1.00 | 2.68 | 35.28 |
| class: a number | 8288 | 2662.95 ± 0.6% | 840.94 ± 0.1% | 27.72 ± 0.2% | 1720.18 ± 0.1% | 41.25 ± 16.1% | 0.55 ± 0.6% | 57.26 ± 0.2% | 2667.63 ± 0.6% | 3.17 | 1.00 | 1.55 | 64.55 |
| class: two capitalized words, second text | 5359 | 521.20 ± 0.2% | 528.14 ± 0.1% | 23.22 ± 0.1% | 484.79 ± 0.1% | 33.92 ± 10.0% | 16.67 ± 0.3% | 63.26 ± 0.4% | 521.77 ± 0.4% | 0.99 | 1.00 | 1.08 | 15.36 |
| other: a word between two words | 6104 | 809.63 ± 0.1% | 602.26 ± 0.2% | 23.42 ± 0.2% | 738.37 ± 0.1% | 109.17 ± 13.3% | 11.24 ± 0.2% | 69.38 ± 1.6% | 811.61 ± 0.2% | 1.34 | 1.00 | 1.10 | 7.42 |
| other: a number before a unit, second text | 1481 | 6265.99 ± 1.8% | 1142.21 ± 0.5% | 25.95 ± 0.3% | 5631.23 ± 0.5% | 40.80 ± 3.7% | 17.76 ± 0.3% | 65.82 ± 0.2% | 6231.60 ± 1.9% | 5.49 | 1.01 | 1.11 | 153.57 |
| other: a heading's start tag | 110 | 14034.72 ± 1.1% | 740.38 ± 0.2% | 27.35 ± 0.2% | 1707.53 ± 0.2% | 1584.50 ± 9.2% | 16.27 ± 3.3% | 87.75 ± 0.8% | 14034.32 ± 1.7% | 18.96 | 1.00 | 8.22 | 8.86 |
| other: a whole word | 217 | 16271.34 ± 1.2% | 599.56 ± 0.3% | 28.69 ± 0.4% | 14475.90 ± 0.6% | 49.41 ± 0.3% | 13.50 ± 0.0% | 55.46 ± 0.3% | 16289.54 ± 1.4% | 27.14 | 1.00 | 1.12 | 329.29 |
| other: a line's first word, second text | 3716 | 2104.37 ± 0.5% | 592.77 ± 0.2% | 30.85 ± 0.2% | 1725.85 ± 0.3% | 62.26 ± 7.2% | refused | refused | 2103.52 ± 0.6% | 3.55 | 1.00 | 1.22 | 33.80 |
| other: fourteen octets before an x | 87 | 23488.41 ± 1.9% | 227.71 ± 0.5% | 6.47 ± 0.1% | 3976.62 ± 1.0% | 10.63 ± 0.2% | differs | 17.92 ± 0.1% | 23218.92 ± 7.1% | 103.15 | 1.01 | 5.91 | 2208.94 |
| other: a Greek word | 21815 | 526.53 ± 1.1% | 423.67 ± 0.2% | 30.44 ± 0.1% | 290.55 ± 0.4% | 43.95 ± 9.6% | differs | refused | 528.25 ± 0.6% | 1.24 | 1.00 | 1.81 | 11.98 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.68 ± 0.2% | 29.47 ± 0.2% | 0.86 ± 0.2% | 19.52 ± 0.4% | 2.75 ± 0.7% | differs | 4.04 ± 0.3% | 29.57 ± 0.2% | 1.01 | 1.00 | 1.52 | 10.81 |
| a UUID | 32895 | 24.60 ± 0.1% | 24.74 ± 0.3% | 0.64 ± 0.3% | 15.14 ± 0.5% | 3.11 ± 0.2% | 0.72 ± 0.4% | 3.61 ± 0.6% | 24.72 ± 0.2% | 0.99 | 1.00 | 1.63 | 7.91 |
| an IPv4 address | 33176 | 38.69 ± 0.1% | 38.77 ± 0.3% | 2.09 ± 0.5% | 28.96 ± 0.4% | 6.66 ± 0.1% | differs | 4.21 ± 0.2% | 38.70 ± 0.2% | 1.00 | 1.00 | 1.34 | 5.81 |
| a date and time | 32954 | 34.00 ± 0.1% | 34.16 ± 0.1% | 1.44 ± 0.2% | 21.41 ± 0.4% | 7.02 ± 0.1% | 1.19 ± 0.3% | 7.11 ± 0.1% | 34.15 ± 0.2% | 1.00 | 1.00 | 1.59 | 4.84 |
| a field path | 32606 | 32.71 ± 0.3% | 32.78 ± 0.4% | 1.02 ± 0.1% | 23.09 ± 0.5% | 3.49 ± 1.1% | differs | 2.96 ± 0.1% | 32.77 ± 0.2% | 1.00 | 1.00 | 1.42 | 9.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.23 ± 0.4% | 11.17 ± 0.6% | 11.18 ± 0.4% | 11.41 ± 0.5% | 4.90 ± 1.7% | 0.91 ± 0.2% | none | 11.18 ± 1.0% | 1.01 | 1.00 | 0.98 | 2.29 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.07 ± 1.1% | 228.97 ± 0.3% | 270.04 ± 0.2% | 88.53 ± 4.3% | 219.61 ± 1.9% | 477.65 ± 1.9% | 3743.30 ± 0.3% | 229.00 ± 0.3% | 1.00 | 1.00 | 2.59 | 1.04 |
| a UUID | 62 | 152.03 ± 0.2% | 152.26 ± 0.2% | 169.86 ± 0.2% | 46.50 ± 0.3% | 98.73 ± 1.3% | 182.83 ± 1.8% | 4343.33 ± 0.8% | 152.16 ± 0.2% | 1.00 | 1.00 | 3.27 | 1.54 |
| an IPv4 address | 29 | 422.63 ± 0.3% | 422.15 ± 0.3% | 588.63 ± 0.4% | 77.32 ± 0.2% | 131.88 ± 1.2% | 300.52 ± 0.9% | 7573.53 ± 0.2% | 421.98 ± 1.0% | 1.00 | 1.00 | 5.47 | 3.20 |
| a date and time | 56 | 301.66 ± 0.5% | 301.57 ± 0.2% | 377.69 ± 0.1% | 73.27 ± 0.5% | 137.22 ± 1.3% | 329.24 ± 2.0% | 4947.01 ± 0.5% | 301.81 ± 0.2% | 1.00 | 1.00 | 4.12 | 2.20 |
| a field path | 39 | 224.63 ± 0.3% | 224.63 ± 0.2% | 264.27 ± 0.1% | 80.46 ± 0.5% | 204.61 ± 2.8% | 515.22 ± 0.3% | 4752.19 ± 0.4% | 224.58 ± 0.1% | 1.00 | 1.00 | 2.79 | 1.10 |
| literal: a word | 7 | 594.15 ± 0.4% | 639.44 ± 0.6% | 1098.92 ± 0.3% | 497.95 ± 2.0% | 628.83 ± 2.9% | 977.14 ± 0.4% | 30355.32 ± 0.2% | 595.17 ± 0.7% | 0.93 | 1.00 | 1.19 | 0.94 |
| literal: a word that is not there | 8 | 578.50 ± 0.3% | 623.96 ± 0.6% | 1059.53 ± 0.1% | 456.91 ± 0.7% | 603.25 ± 3.7% | 926.54 ± 0.5% | 29063.31 ± 0.5% | 576.89 ± 0.4% | 0.93 | 1.00 | 1.27 | 0.96 |
| literal: one of four words | 26 | 239.97 ± 0.1% | 376.22 ± 0.3% | 504.30 ± 0.4% | 49.48 ± 1.9% | 237.60 ± 3.2% | 379.50 ± 0.3% | 15580.18 ± 0.1% | 239.82 ± 0.2% | 0.64 | 1.00 | 4.85 | 1.01 |
| literal: a word in any case | 11 | 435.55 ± 0.4% | 463.58 ± 0.5% | 673.45 ± 0.2% | 15.56 ± 0.3% | 647.07 ± 3.9% | refused | 23746.80 ± 0.3% | 435.76 ± 0.3% | 0.94 | 1.00 | 27.99 | 0.67 |
| literal: an href attribute | 12 | 337.51 ± 0.6% | 349.59 ± 0.5% | 456.95 ± 0.7% | 44.81 ± 0.3% | 496.43 ± 4.3% | 753.00 ± 0.4% | 21647.20 ± 0.2% | 338.12 ± 0.1% | 0.97 | 1.00 | 7.53 | 0.68 |
| literal: a word, second text | 10 | 529.89 ± 0.4% | 579.57 ± 0.4% | 942.59 ± 0.2% | 413.26 ± 1.6% | 538.92 ± 1.9% | 784.45 ± 0.4% | 27095.75 ± 0.1% | 530.14 ± 0.5% | 0.91 | 1.00 | 1.28 | 0.98 |
| class: two capitalized words | 23 | 432.30 ± 0.2% | 458.46 ± 0.6% | 658.88 ± 0.7% | 101.19 ± 0.2% | 501.67 ± 3.1% | 751.02 ± 0.8% | 6300.96 ± 0.3% | 432.22 ± 0.5% | 0.94 | 1.00 | 4.27 | 0.86 |
| class: a word that ends in ing | 9 | 550.21 ± 0.5% | 614.99 ± 0.5% | 1056.54 ± 0.4% | 131.77 ± 0.6% | 750.06 ± 2.0% | 1104.82 ± 0.6% | 15732.45 ± 0.2% | 550.22 ± 0.3% | 0.89 | 1.00 | 4.18 | 0.73 |
| class: a word in capitals | 16 | 494.34 ± 0.2% | 529.58 ± 0.3% | 836.14 ± 0.1% | 135.27 ± 0.7% | 749.57 ± 1.5% | 1022.93 ± 0.8% | 8299.26 ± 0.1% | 494.04 ± 0.3% | 0.93 | 1.00 | 3.65 | 0.66 |
| class: a number | 6 | 620.98 ± 0.1% | 677.64 ± 0.2% | 1247.26 ± 0.1% | 41.81 ± 1.1% | 1401.24 ± 2.0% | 1878.31 ± 1.3% | 22772.80 ± 0.2% | 620.38 ± 0.2% | 0.92 | 1.00 | 14.85 | 0.44 |
| class: two capitalized words, second text | 23 | 431.47 ± 0.5% | 459.69 ± 0.2% | 658.25 ± 0.5% | 100.89 ± 0.6% | 502.30 ± 1.5% | 748.20 ± 0.7% | 6298.14 ± 0.1% | 432.49 ± 0.5% | 0.94 | 1.00 | 4.28 | 0.86 |
| other: a word between two words | 13 | 523.65 ± 0.3% | 543.89 ± 0.4% | 853.97 ± 0.1% | 135.26 ± 1.0% | 501.04 ± 2.6% | 809.87 ± 1.3% | 14572.32 ± 0.4% | 523.91 ± 0.6% | 0.96 | 1.00 | 3.87 | 1.05 |
| other: a number before a unit, second text | 15 | 391.13 ± 0.3% | 428.87 ± 0.2% | 599.30 ± 0.2% | 39.67 ± 0.1% | 634.13 ± 1.9% | 885.61 ± 0.5% | 15141.51 ± 0.7% | 391.17 ± 0.2% | 0.91 | 1.00 | 9.86 | 0.62 |
| other: a heading's start tag | 13 | 349.77 ± 0.2% | 356.11 ± 0.5% | 466.90 ± 0.2% | 43.10 ± 0.3% | 625.06 ± 4.2% | 870.59 ± 0.4% | 18004.06 ± 0.2% | 350.31 ± 0.2% | 0.98 | 1.00 | 8.11 | 0.56 |
| other: a whole word | 11 | 553.84 ± 0.6% | 591.39 ± 0.7% | 968.55 ± 0.7% | 119.60 ± 0.4% | 567.94 ± 0.7% | 829.44 ± 0.5% | 27004.95 ± 0.1% | 554.12 ± 0.7% | 0.94 | 1.00 | 4.63 | 0.98 |
| other: a line's first word, second text | 17 | 507.45 ± 0.5% | 542.52 ± 0.2% | 857.74 ± 0.2% | 128.65 ± 0.1% | 705.54 ± 2.2% | refused | refused | 508.82 ± 0.2% | 0.94 | 1.00 | 3.94 | 0.72 |
| other: fourteen octets before an x | 16 | 109.36 ± 0.2% | 156.54 ± 0.7% | 179.22 ± 0.9% | 15.21 ± 0.1% | 453.66 ± 1.3% | 409.19 ± 0.5% | 12757.50 ± 0.5% | 109.37 ± 0.2% | 0.70 | 1.00 | 7.19 | 0.24 |
| other: a Greek word | 8 | 448.80 ± 0.2% | 588.75 ± 0.4% | 983.41 ± 0.6% | 58.85 ± 0.5% | 1391.16 ± 1.1% | 1882.14 ± 0.5% | refused | 448.39 ± 0.3% | 0.76 | 1.00 | 7.63 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15307.55 ± 1.0% | not timed | not timed | 15958.60 ± 0.2% | 2002.88 ± 20.8% | not timed | not timed | 15355.49 ± 0.7% | | 1.00 | 0.96 | 7.64 |
| 01-literal/sherlock-casei-en | 522 | 10850.76 ± 6.9% | not timed | not timed | 3597.07 ± 0.1% | 32.45 ± 0.3% | not timed | not timed | 10895.22 ± 4.8% | | 1.00 | 3.02 | 334.41 |
| 01-literal/sherlock-ru | 724 | 17075.26 ± 0.4% | not timed | not timed | 17146.26 ± 1.0% | 1377.24 ± 17.9% | not timed | not timed | 17069.15 ± 0.5% | | 1.00 | 1.00 | 12.40 |
| 01-literal/sherlock-casei-ru | 746 | 6130.11 ± 0.3% | not timed | not timed | 3328.88 ± 0.1% | 31.75 ± 9.3% | not timed | not timed | 6136.33 ± 0.1% | | 1.00 | 1.84 | 193.09 |
| 01-literal/sherlock-zh | 30 | 19436.84 ± 0.7% | not timed | not timed | 18421.38 ± 0.8% | 2614.24 ± 13.6% | not timed | not timed | 19454.28 ± 0.4% | | 1.00 | 1.06 | 7.43 |
| 02-literal-alternate/sherlock-en | 714 | 6141.35 ± 0.3% | not timed | not timed | 3945.08 ± 0.3% | 16.62 ± 5.3% | not timed | not timed | 6147.23 ± 0.3% | | 1.00 | 1.56 | 369.57 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1965.63 ± 1.2% | not timed | not timed | 696.54 ± 0.2% | 11.03 ± 0.1% | not timed | not timed | 1968.37 ± 0.9% | | 1.00 | 2.82 | 178.25 |
| 02-literal-alternate/sherlock-ru | 899 | 5500.04 ± 0.2% | not timed | not timed | 3250.67 ± 0.1% | 22.66 ± 0.1% | not timed | not timed | 5498.41 ± 0.3% | | 1.00 | 1.69 | 242.67 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2049.93 ± 0.5% | not timed | not timed | 1230.00 ± 0.7% | 9.16 ± 0.4% | not timed | not timed | 2048.70 ± 0.5% | | 1.00 | 1.67 | 223.88 |
| 02-literal-alternate/sherlock-zh | 207 | 7320.34 ± 0.6% | not timed | not timed | 4151.32 ± 0.4% | 31.45 ± 0.1% | not timed | not timed | 7324.16 ± 0.7% | | 1.00 | 1.76 | 232.75 |
| 03-date/ascii | 111817 | 134.27 ± 0.6% | not timed | not timed | 96.29 ± 0.2% | 0.20 ± 4.8% | not timed | not timed | 134.74 ± 1.2% | | 1.00 | 1.39 | 660.67 |
| 04-ruff-noqa/real | 84 | 438.32 ± 0.4% | not timed | not timed | 461.61 ± 0.2% | 19.57 ± 1.3% | not timed | not timed | 437.52 ± 0.1% | | 1.00 | 0.95 | 22.40 |
| 04-ruff-noqa/tweaked | 44 | 846.03 ± 0.2% | not timed | not timed | 454.34 ± 0.2% | 362.63 ± 0.3% | not timed | not timed | 845.11 ± 0.2% | | 1.00 | 1.86 | 2.33 |
| 05-lexer-veryl/single | 124800 | 5.24 ± 4.4% | not timed | not timed | 5.07 ± 0.1% | 0.20 ± 4.0% | not timed | not timed | 5.29 ± 9.2% | | 0.99 | 1.03 | 25.70 |
| 06-cloud-flare-redos/original | 107 | 439.47 ± 3.5% | not timed | not timed | 217.16 ± 0.2% | 24.92 ± 6.9% | not timed | not timed | 438.78 ± 0.1% | | 1.00 | 2.02 | 17.64 |
| 06-cloud-flare-redos/simplified-short | 102 | 437.62 ± 16.6% | not timed | not timed | 229.31 ± 0.3% | 26.62 ± 3.0% | not timed | not timed | 438.75 ± 0.2% | | 1.00 | 1.91 | 16.44 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.88 ± 0.2% | not timed | not timed | 254.90 ± 0.2% | 28.68 ± 0.1% | not timed | not timed | 629.27 ± 0.1% | | 1.00 | 2.47 | 21.93 |
| 07-unicode-character-data/parse-line | 558784 | 241.60 ± 0.3% | not timed | not timed | 172.15 ± 0.1% | 42.35 ± 2.6% | not timed | not timed | 243.36 ± 0.3% | | 0.99 | 1.40 | 5.71 |
| 08-words/all-english | 56691 | 129.06 ± 0.4% | not timed | not timed | 82.41 ± 0.2% | 11.68 ± 9.1% | not timed | not timed | 129.31 ± 0.5% | | 1.00 | 1.57 | 11.05 |
| 08-words/long-english | 839 | 617.16 ± 0.3% | not timed | not timed | 597.27 ± 0.3% | 32.71 ± 0.1% | not timed | not timed | 617.37 ± 0.3% | | 1.00 | 1.03 | 18.86 |
| 09-aws-keys/full | 0 | 443.01 ± 0.2% | not timed | not timed | 461.73 ± 0.2% | 64.42 ± 0.1% | not timed | not timed | 443.06 ± 0.2% | | 1.00 | 0.96 | 6.88 |
| 09-aws-keys/quick | 0 | 874.58 ± 0.3% | not timed | not timed | 995.09 ± 0.1% | 412.09 ± 0.8% | not timed | not timed | 874.81 ± 0.5% | | 1.00 | 0.88 | 2.12 |
| 10-bounded-repeat/letters-en | 1833 | 581.55 ± 3.7% | not timed | not timed | 517.37 ± 0.2% | 19.61 ± 0.2% | not timed | not timed | 581.93 ± 1.0% | | 1.00 | 1.12 | 29.66 |
| 10-bounded-repeat/letters-ru | 3475 | 505.12 ± 1.6% | not timed | not timed | 478.84 ± 0.1% | 22.05 ± 9.4% | not timed | not timed | 505.97 ± 1.4% | | 1.00 | 1.05 | 22.91 |
| 10-bounded-repeat/context | 53 | 85.02 ± 2.4% | not timed | not timed | 65.66 ± 0.4% | 19.80 ± 0.2% | not timed | not timed | 85.07 ± 1.7% | | 1.00 | 1.29 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 636.63 ± 8.7% | not timed | not timed | 616.80 ± 0.1% | 36.64 ± 0.2% | not timed | not timed | 638.88 ± 8.4% | | 1.00 | 1.03 | 17.38 |
| 11-unstructured-to-json/extract | 600 | 57.94 ± 0.1% | not timed | not timed | 77.91 ± 0.1% | 48.87 ± 0.5% | not timed | not timed | 57.86 ± 0.2% | | 1.00 | 0.74 | 1.19 |
| 12-dictionary/single | 1 | 561.12 ± 1.3% | not timed | not timed | 559.99 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 561.07 ± 1.9% | | 1.00 | 1.00 | 1388.34 |
| 14-quadratic/1x | 100 | 22.08 ± 1.0% | not timed | not timed | 9.98 ± 0.1% | 0.96 ± 3.2% | not timed | not timed | 22.16 ± 1.7% | | 1.00 | 2.21 | 22.99 |
| 14-quadratic/2x | 200 | 19.74 ± 0.9% | not timed | not timed | 5.52 ± 0.2% | 0.53 ± 2.1% | not timed | not timed | 19.87 ± 0.9% | | 0.99 | 3.58 | 37.20 |
| 14-quadratic/10x | 1000 | 12.34 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 2.1% | not timed | not timed | 12.33 ± 1.0% | | 1.00 | 10.17 | 107.35 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.6% | not timed | not timed | 0.34 ± 0.8% | 0.53 ± 3.1% | not timed | not timed | 1.26 ± 0.9% | | 1.00 | 3.69 | 2.40 |
| 04-ruff-noqa/compile-real | 1 | 104.59 ± 0.6% | not timed | not timed | 13.78 ± 0.5% | 131.60 ± 4.7% | not timed | not timed | 104.70 ± 0.6% | | 1.00 | 7.59 | 0.79 |
| 05-lexer-veryl/compile-single | 1 | 14.15 ± 0.3% | not timed | not timed | 2.54 ± 1.3% | 6.17 ± 7.5% | not timed | not timed | 14.17 ± 0.6% | | 1.00 | 5.58 | 2.29 |
| 07-unicode-character-data/compile | 1 | 107.52 ± 1.7% | not timed | not timed | 25.83 ± 0.4% | 34.82 ± 5.0% | not timed | not timed | 108.82 ± 1.5% | | 0.99 | 4.16 | 3.09 |
| 09-aws-keys/compile-full | 1 | 53.19 ± 1.0% | not timed | not timed | 8.26 ± 0.7% | 22.49 ± 2.4% | not timed | not timed | 53.07 ± 0.7% | | 1.00 | 6.44 | 2.36 |
| 09-aws-keys/compile-quick | 1 | 187.39 ± 0.2% | not timed | not timed | 47.10 ± 0.3% | 124.01 ± 5.4% | not timed | not timed | 187.69 ± 0.3% | | 1.00 | 3.98 | 1.51 |
| 10-bounded-repeat/compile-context | 1 | 71.31 ± 0.9% | not timed | not timed | 11.17 ± 0.5% | 15.26 ± 4.9% | not timed | not timed | 71.38 ± 0.6% | | 1.00 | 6.38 | 4.67 |
| 10-bounded-repeat/compile-capitals | 1 | 85.95 ± 1.8% | not timed | not timed | 8.14 ± 0.3% | 23.59 ± 6.9% | not timed | not timed | 85.87 ± 1.4% | | 1.00 | 10.56 | 3.64 |
| 11-unstructured-to-json/compile | 1 | 172.62 ± 1.6% | not timed | not timed | 41.17 ± 0.8% | 67.51 ± 3.4% | not timed | not timed | 173.13 ± 0.3% | | 1.00 | 4.19 | 2.56 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.8% | not timed | not timed | 0.07 ± 11.2% | 0.10 ± 23.1% | not timed | not timed | 0.35 ± 1.7% | | 1.00 | 5.14 | 3.62 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.46 ± 0.5% | not timed | not timed | 6.48 ± 0.1% | 0.55 ± 21.7% | not timed | not timed | 7.45 ± 5.4% | | 1.00 | 1.15 | 13.61 |
| dictionary/search/english-10 | 690 | 203.12 ± 4.2% | not timed | not timed | 166.34 ± 0.3% | 0.00 ± 1.0% | not timed | not timed | 202.24 ± 4.8% | | 1.00 | 1.22 | 74528.01 |
| dictionary/search/english-15 | 15 | 559.25 ± 1.5% | not timed | not timed | 558.83 ± 0.2% | 0.37 ± 0.2% | not timed | not timed | 561.94 ± 1.9% | | 1.00 | 1.00 | 1520.18 |
| folly/awyer-inn-busted | 1 | 21491.16 ± 0.2% | not timed | not timed | 143.32 ± 0.0% | 43.70 ± 0.2% | not timed | not timed | 21553.53 ± 0.1% | | 1.00 | 149.95 | 491.83 |
| folly/literal-never-match-rare | 0 | 21123.07 ± 0.5% | not timed | not timed | 19894.60 ± 0.5% | 40810.66 ± 0.3% | not timed | not timed | 21092.91 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12480.32 ± 0.7% | not timed | not timed | 19880.00 ± 0.1% | 2197.71 ± 1.3% | not timed | not timed | 12532.32 ± 0.6% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3256.70 ± 0.4% | not timed | not timed | 4410.73 ± 0.1% | 3040.15 ± 1.9% | not timed | not timed | 3252.46 ± 0.4% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1300.28 ± 0.5% | not timed | not timed | 956.77 ± 0.4% | 367.64 ± 17.1% | not timed | not timed | 1304.43 ± 0.5% | | 1.00 | 1.36 | 3.54 |
| grep/long-words-ascii | 5073 | 458.88 ± 0.3% | not timed | not timed | 470.71 ± 0.1% | 45.69 ± 6.1% | not timed | not timed | 458.95 ± 0.1% | | 1.00 | 0.97 | 10.04 |
| imported/leipzig/twain | 811 | 20656.88 ± 4.0% | not timed | not timed | 19642.47 ± 0.8% | 11980.97 ± 11.9% | not timed | not timed | 20749.49 ± 0.2% | | 1.00 | 1.05 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 8999.39 ± 1.1% | not timed | not timed | 4253.36 ± 0.1% | 37.77 ± 0.4% | not timed | not timed | 9072.81 ± 1.0% | | 0.99 | 2.12 | 238.24 |
| imported/leipzig/shing | 1540 | 15295.80 ± 2.7% | not timed | not timed | 13367.18 ± 0.6% | 34.01 ± 0.1% | not timed | not timed | 15593.75 ± 2.6% | | 0.98 | 1.14 | 449.70 |
| imported/leipzig/huck-saw | 262 | 8096.56 ± 3.9% | not timed | not timed | 5564.50 ± 2.0% | 31.68 ± 0.1% | not timed | not timed | 8252.23 ± 4.8% | | 0.98 | 1.46 | 255.56 |
| imported/leipzig/word-ending-nn | 262 | 602.43 ± 0.5% | not timed | not timed | 617.16 ± 0.3% | 24.77 ± 0.2% | not timed | not timed | 602.27 ± 0.9% | | 1.00 | 0.98 | 24.32 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11221.68 ± 1.0% | not timed | not timed | 4391.79 ± 5.4% | 11.50 ± 0.1% | not timed | not timed | 11254.41 ± 2.3% | | 1.00 | 2.56 | 975.46 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7849.43 ± 3.8% | not timed | not timed | 5484.01 ± 0.5% | 16.73 ± 2.0% | not timed | not timed | 7856.88 ± 5.2% | | 1.00 | 1.43 | 469.15 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4157.24 ± 1.7% | not timed | not timed | 422.91 ± 0.3% | 11.08 ± 0.2% | not timed | not timed | 4169.65 ± 2.8% | | 1.00 | 9.83 | 375.21 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7374.40 ± 5.7% | not timed | not timed | 615.57 ± 0.1% | 11.13 ± 0.1% | not timed | not timed | 7467.24 ± 2.1% | | 0.99 | 11.98 | 662.39 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7203.15 ± 2.1% | not timed | not timed | 615.25 ± 0.1% | 9.74 ± 0.1% | not timed | not timed | 7205.91 ± 2.7% | | 1.00 | 11.71 | 739.64 |
| imported/leipzig/tom-river | 2 | 6516.00 ± 1.7% | not timed | not timed | 5154.23 ± 0.1% | 31.08 ± 0.2% | not timed | not timed | 6595.03 ± 1.4% | | 0.99 | 1.26 | 209.68 |
| imported/leipzig/ing | 78424 | 603.11 ± 0.9% | not timed | not timed | 571.59 ± 0.0% | 28.29 ± 2.7% | not timed | not timed | 602.36 ± 0.9% | | 1.00 | 1.06 | 21.32 |
| imported/leipzig/ing-whitespace | 55248 | 1917.40 ± 1.4% | not timed | not timed | 1971.96 ± 0.7% | 20.51 ± 2.8% | not timed | not timed | 1920.41 ± 1.0% | | 1.00 | 0.97 | 93.47 |
| imported/leipzig/awyer-inn | 209 | 6408.14 ± 0.6% | not timed | not timed | 4281.00 ± 0.5% | 22.57 ± 0.1% | not timed | not timed | 6398.96 ± 1.2% | | 1.00 | 1.50 | 283.88 |
| imported/leipzig/quotes-bounded | 8886 | 2497.12 ± 1.1% | not timed | not timed | 3027.01 ± 1.2% | 38.32 ± 0.1% | not timed | not timed | 2514.81 ± 1.1% | | 0.99 | 0.82 | 65.16 |
| imported/leipzig/non-ascii-alternate | 2 | 12891.07 ± 1.9% | not timed | not timed | 5669.38 ± 0.1% | 50.70 ± 0.0% | not timed | not timed | 13093.97 ± 1.9% | | 0.98 | 2.27 | 254.26 |
| imported/leipzig/math-symbols | 69 | 1980.82 ± 1.8% | not timed | not timed | 614.11 ± 0.1% | 36.57 ± 0.2% | not timed | not timed | 1981.14 ± 0.2% | | 1.00 | 3.23 | 54.17 |
| imported/leipzig/bounded-strings-ending-z | 0 | 630.48 ± 2.9% | not timed | not timed | 616.31 ± 0.1% | 22.45 ± 0.1% | not timed | not timed | 626.32 ± 3.3% | | 1.01 | 1.02 | 28.08 |
| imported/lh3lh3-reb/uri | 17549 | 674.44 ± 0.1% | not timed | not timed | 1075.01 ± 0.3% | 28.17 ± 2.4% | not timed | not timed | 680.22 ± 0.1% | | 0.99 | 0.63 | 23.94 |
| imported/lh3lh3-reb/email | 15057 | 673.85 ± 0.2% | not timed | not timed | 1158.72 ± 0.2% | 30.73 ± 2.5% | not timed | not timed | 676.25 ± 0.2% | | 1.00 | 0.58 | 21.93 |
| imported/lh3lh3-reb/date | 668 | 890.76 ± 0.2% | not timed | not timed | 1034.36 ± 0.2% | 50.71 ± 3.7% | not timed | not timed | 891.48 ± 0.2% | | 1.00 | 0.86 | 17.56 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.95 ± 0.2% | not timed | not timed | 420.58 ± 0.2% | 15.75 ± 1.3% | not timed | not timed | 646.64 ± 0.1% | | 1.00 | 1.53 | 40.95 |
| imported/mariomka/email | 92 | 24004.96 ± 1.6% | not timed | not timed | 29210.37 ± 0.7% | 32.82 ± 0.1% | not timed | not timed | 24293.38 ± 2.1% | | 0.99 | 0.82 | 731.51 |
| imported/mariomka/uri | 5301 | 5406.84 ± 9.8% | not timed | not timed | 5709.52 ± 3.7% | 32.66 ± 0.5% | not timed | not timed | 5490.16 ± 3.1% | | 0.98 | 0.95 | 165.57 |
| imported/mariomka/ip | 5 | 2560.47 ± 4.1% | not timed | not timed | 2898.77 ± 0.5% | 21.02 ± 0.4% | not timed | not timed | 2566.68 ± 4.6% | | 1.00 | 0.88 | 121.83 |
| imported/rsc/no-exponential | 0 | 607.86 ± 0.1% | not timed | not timed | 323.94 ± 0.1% | 23.78 ± 0.1% | not timed | not timed | 608.07 ± 0.1% | | 1.00 | 1.88 | 25.56 |
| imported/rsc/literal | 1 | 1388.51 ± 7.6% | not timed | not timed | 1657.17 ± 3.5% | 213.99 ± 18.1% | not timed | not timed | 1492.94 ± 8.1% | | 0.93 | 0.84 | 6.49 |
| imported/rsc/not-literal | 2 | 776.43 ± 0.1% | not timed | not timed | 753.83 ± 0.6% | 46.21 ± 1.1% | not timed | not timed | 779.46 ± 8.3% | | 1.00 | 1.03 | 16.80 |
| imported/rsc/match-class | 1 | 1469.86 ± 2.7% | not timed | not timed | 1639.23 ± 0.3% | 58.44 ± 13.3% | not timed | not timed | 1472.70 ± 0.6% | | 1.00 | 0.90 | 25.15 |
| imported/rsc/match-class-in-range | 1 | 1473.64 ± 0.4% | not timed | not timed | 2435.91 ± 2.7% | 59.95 ± 0.3% | not timed | not timed | 1472.71 ± 0.7% | | 1.00 | 0.60 | 24.58 |
| imported/rsc/match-class-unicode | 1 | 541.30 ± 0.2% | not timed | not timed | 511.33 ± 0.1% | 72.27 ± 7.3% | not timed | not timed | 541.80 ± 2.3% | | 1.00 | 1.06 | 7.49 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1450.89 ± 0.1% | not timed | not timed | 958.21 ± 0.1% | 229.31 ± 0.7% | not timed | not timed | 1449.50 ± 0.2% | | 1.00 | 1.51 | 6.33 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21770.04 ± 0.1% | not timed | not timed | 14407.56 ± 0.2% | 3418.58 ± 0.8% | not timed | not timed | 21721.29 ± 0.1% | | 1.00 | 1.51 | 6.37 |
| imported/rsc/anchored-literal-short-match | 4 | 723.21 ± 1.9% | not timed | not timed | 486.03 ± 0.2% | 83.46 ± 11.2% | not timed | not timed | 722.29 ± 1.5% | | 1.00 | 1.49 | 8.67 |
| imported/rsc/anchored-literal-long-match | 4 | 10851.90 ± 0.8% | not timed | not timed | 7318.26 ± 0.1% | 1227.56 ± 3.6% | not timed | not timed | 10843.30 ± 0.7% | | 1.00 | 1.48 | 8.84 |
| imported/rsc/one-pass-short | 17 | 367.15 ± 11.3% | not timed | not timed | 217.68 ± 0.3% | 31.20 ± 14.4% | not timed | not timed | 369.90 ± 1.2% | | 0.99 | 1.69 | 11.77 |
| imported/rsc/one-pass-short-not | 17 | 269.66 ± 2.4% | not timed | not timed | 227.45 ± 0.4% | 30.12 ± 10.9% | not timed | not timed | 270.36 ± 1.9% | | 1.00 | 1.19 | 8.95 |
| imported/rsc/one-pass-long-prefix | 26 | 361.52 ± 2.3% | not timed | not timed | 278.90 ± 0.6% | 107.59 ± 19.5% | not timed | not timed | 360.80 ± 7.8% | | 1.00 | 1.30 | 3.36 |
| imported/rsc/one-pass-long-prefix-not | 26 | 353.98 ± 4.5% | not timed | not timed | 282.66 ± 0.3% | 66.53 ± 16.6% | not timed | not timed | 362.74 ± 1.5% | | 0.98 | 1.25 | 5.32 |
| imported/rsc/long-needle1 | 31 | 21971.08 ± 0.1% | not timed | not timed | 20168.31 ± 0.1% | 3.75 ± 0.2% | not timed | not timed | 21983.13 ± 0.4% | | 1.00 | 1.09 | 5860.95 |
| imported/rsc/long-needle2 | 31 | 22063.17 ± 0.1% | not timed | not timed | 216.65 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 22053.75 ± 0.1% | | 1.00 | 101.84 | 5869.12 |
| imported/rsc/easy0-32 | 26 | 1572.82 ± 2.4% | not timed | not timed | 1550.10 ± 0.8% | 148.77 ± 18.5% | not timed | not timed | 1564.40 ± 0.3% | | 1.01 | 1.01 | 10.57 |
| imported/rsc/easy0-1k | 26 | 13635.14 ± 1.9% | not timed | not timed | 12744.22 ± 1.5% | 2322.13 ± 16.6% | not timed | not timed | 13633.66 ± 0.2% | | 1.00 | 1.07 | 5.87 |
| imported/rsc/easy0-32k | 26 | 22753.67 ± 1.7% | not timed | not timed | 20348.68 ± 0.1% | 18735.92 ± 18.6% | not timed | not timed | 22766.34 ± 0.1% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21432.57 ± 2.5% | not timed | not timed | 19183.19 ± 1.7% | 35459.58 ± 5.4% | not timed | not timed | 21035.60 ± 2.7% | | 1.02 | 1.12 | 0.60 |
| imported/rsc/easy1-32 | 19 | 768.34 ± 8.3% | not timed | not timed | 643.39 ± 0.9% | 136.30 ± 19.2% | not timed | not timed | 771.49 ± 2.2% | | 1.00 | 1.19 | 5.64 |
| imported/rsc/easy1-1k | 19 | 15796.19 ± 0.3% | not timed | not timed | 12991.87 ± 0.1% | 2488.62 ± 18.8% | not timed | not timed | 15810.70 ± 2.2% | | 1.00 | 1.22 | 6.35 |
| imported/rsc/easy1-32k | 19 | 494489.09 ± 2.1% | not timed | not timed | 407395.53 ± 0.4% | 20322.12 ± 19.2% | not timed | not timed | 495054.01 ± 0.3% | | 1.00 | 1.21 | 24.33 |
| imported/rsc/easy1-1mb | 19 | 15889624.44 ± 0.2% | not timed | not timed | 13233840.83 ± 0.1% | 37842.64 ± 1.6% | not timed | not timed | 15906427.58 ± 0.3% | | 1.00 | 1.20 | 419.89 |
| imported/rsc/medium-32 | 27 | 739.67 ± 7.1% | not timed | not timed | 636.71 ± 0.1% | 69.78 ± 1.1% | not timed | not timed | 738.22 ± 0.5% | | 1.00 | 1.16 | 10.60 |
| imported/rsc/medium-1k | 27 | 13186.96 ± 0.2% | not timed | not timed | 11322.51 ± 0.1% | 72.33 ± 0.0% | not timed | not timed | 13135.21 ± 0.3% | | 1.00 | 1.16 | 182.33 |
| imported/rsc/medium-32k | 27 | 411414.33 ± 0.1% | not timed | not timed | 358064.85 ± 0.2% | 48.63 ± 0.1% | not timed | not timed | 409174.90 ± 0.1% | | 1.01 | 1.15 | 8459.47 |
| imported/rsc/medium-1mb | 27 | 13164283.93 ± 0.2% | not timed | not timed | 11457576.43 ± 0.3% | 48.49 ± 0.2% | not timed | not timed | 13060724.50 ± 0.2% | | 1.01 | 1.15 | 271505.21 |
| imported/rsc/hard-32 | 58 | 423.27 ± 2.0% | not timed | not timed | 369.57 ± 0.1% | 49.64 ± 8.5% | not timed | not timed | 421.23 ± 0.2% | | 1.00 | 1.15 | 8.53 |
| imported/rsc/hard-1k | 27 | 12883.80 ± 0.2% | not timed | not timed | 11593.72 ± 0.2% | 40.54 ± 0.1% | not timed | not timed | 12829.24 ± 0.2% | | 1.00 | 1.11 | 317.78 |
| imported/rsc/hard-32k | 27 | 402183.19 ± 0.2% | not timed | not timed | 364361.95 ± 0.2% | 29.42 ± 0.1% | not timed | not timed | 400988.95 ± 0.1% | | 1.00 | 1.10 | 13672.28 |
| imported/rsc/hard-1mb | 51 | 8371256.46 ± 0.2% | not timed | not timed | 7266632.32 ± 0.2% | 29.39 ± 0.1% | not timed | not timed | 8346542.95 ± 0.2% | | 1.00 | 1.15 | 284834.93 |
| imported/rsc/reallyhard0-32 | 58 | 263.16 ± 2.7% | not timed | not timed | 223.14 ± 0.1% | 49.51 ± 8.3% | not timed | not timed | 263.44 ± 0.2% | | 1.00 | 1.18 | 5.32 |
| imported/rsc/reallyhard0-1k | 27 | 578.77 ± 0.2% | not timed | not timed | 585.58 ± 0.1% | 40.74 ± 0.1% | not timed | not timed | 582.17 ± 0.4% | | 0.99 | 0.99 | 14.21 |
| imported/rsc/reallyhard0-32k | 27 | 604.31 ± 0.3% | not timed | not timed | 616.36 ± 0.0% | 29.41 ± 0.0% | not timed | not timed | 600.97 ± 0.2% | | 1.01 | 0.98 | 20.55 |
| imported/rsc/reallyhard0-1mb | 51 | 624.58 ± 1.2% | not timed | not timed | 617.82 ± 0.1% | 29.36 ± 0.1% | not timed | not timed | 620.55 ± 0.8% | | 1.01 | 1.01 | 21.27 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.72 ± 1.9% | not timed | not timed | 197.80 ± 0.1% | 60.10 ± 15.3% | not timed | not timed | 285.92 ± 1.4% | | 1.00 | 1.44 | 4.74 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7013.56 ± 0.1% | not timed | not timed | 5954.33 ± 0.2% | 33.85 ± 2.6% | not timed | not timed | 6992.63 ± 0.0% | | 1.00 | 1.18 | 207.18 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21444.58 ± 0.4% | not timed | not timed | 19249.89 ± 0.2% | 24.64 ± 3.5% | not timed | not timed | 21467.46 ± 0.4% | | 1.00 | 1.11 | 870.20 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21546.84 ± 2.4% | not timed | not timed | 19785.69 ± 1.8% | 24.34 ± 0.3% | not timed | not timed | 21414.20 ± 1.6% | | 1.01 | 1.09 | 885.34 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 280.86 ± 12.0% | not timed | not timed | 214.04 ± 0.3% | 60.64 ± 1.5% | not timed | not timed | 281.45 ± 1.3% | | 1.00 | 1.31 | 4.63 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5914.57 ± 0.2% | not timed | not timed | 6209.89 ± 0.1% | 34.33 ± 4.4% | not timed | not timed | 5927.56 ± 0.1% | | 1.00 | 0.95 | 172.27 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21367.39 ± 0.1% | not timed | not timed | 19305.03 ± 0.1% | 24.80 ± 3.8% | not timed | not timed | 21297.92 ± 0.1% | | 1.00 | 1.11 | 861.56 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21182.80 ± 0.8% | not timed | not timed | 19655.10 ± 0.8% | 25.06 ± 0.4% | not timed | not timed | 21181.20 ± 1.2% | | 1.00 | 1.08 | 845.28 |
| imported/sherlock/name-sherlock | 776 | 19904.73 ± 2.2% | not timed | not timed | 18544.73 ± 0.5% | 10065.75 ± 26.9% | not timed | not timed | 19924.72 ± 1.8% | | 1.00 | 1.07 | 1.98 |
| imported/sherlock/name-holmes | 2766 | 15258.65 ± 1.9% | not timed | not timed | 15548.65 ± 0.1% | 3062.41 ± 15.8% | not timed | not timed | 15301.69 ± 1.8% | | 1.00 | 0.98 | 4.98 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19892.19 ± 1.8% | not timed | not timed | 18552.55 ± 0.4% | 8051.67 ± 20.8% | not timed | not timed | 19891.29 ± 2.0% | | 1.00 | 1.07 | 2.47 |
| imported/sherlock/name-sherlock-casei | 816 | 15746.33 ± 0.3% | not timed | not timed | 4010.66 ± 0.2% | 32.28 ± 1.0% | not timed | not timed | 15760.37 ± 0.4% | | 1.00 | 3.93 | 487.80 |
| imported/sherlock/name-holmes-casei | 2802 | 9344.15 ± 6.7% | not timed | not timed | 3325.07 ± 0.1% | 37.34 ± 0.4% | not timed | not timed | 9371.49 ± 1.4% | | 1.00 | 2.81 | 250.26 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12921.43 ± 7.6% | not timed | not timed | 3944.39 ± 0.2% | 32.46 ± 0.2% | not timed | not timed | 12937.26 ± 1.2% | | 1.00 | 3.28 | 398.13 |
| imported/sherlock/name-whitespace | 1461 | 15343.39 ± 7.2% | not timed | not timed | 14510.06 ± 0.4% | 7001.43 ± 34.7% | not timed | not timed | 15345.19 ± 5.5% | | 1.00 | 1.06 | 2.19 |
| imported/sherlock/name-alt1 | 1142 | 11625.29 ± 0.5% | not timed | not timed | 16598.80 ± 0.6% | 4116.37 ± 18.2% | not timed | not timed | 11642.39 ± 2.7% | | 1.00 | 0.70 | 2.82 |
| imported/sherlock/name-alt2 | 3542 | 8960.13 ± 0.2% | not timed | not timed | 3825.85 ± 0.1% | 31.34 ± 0.3% | not timed | not timed | 8963.06 ± 0.7% | | 1.00 | 2.34 | 285.94 |
| imported/sherlock/name-alt3 | 4507 | 5547.86 ± 0.6% | not timed | not timed | 3625.14 ± 0.1% | 9.94 ± 4.7% | not timed | not timed | 5542.37 ± 0.4% | | 1.00 | 1.53 | 558.39 |
| imported/sherlock/name-alt3-casei | 4593 | 1522.72 ± 0.5% | not timed | not timed | 285.04 ± 0.2% | 6.44 ± 0.1% | not timed | not timed | 1525.73 ± 1.4% | | 1.00 | 5.34 | 236.56 |
| imported/sherlock/name-alt4 | 3686 | 6394.62 ± 0.5% | not timed | not timed | 3784.10 ± 0.2% | 31.39 ± 0.1% | not timed | not timed | 6395.96 ± 0.3% | | 1.00 | 1.69 | 203.71 |
| imported/sherlock/name-alt4-casei | 4254 | 2805.59 ± 2.0% | not timed | not timed | 2593.24 ± 0.2% | 19.83 ± 0.3% | not timed | not timed | 2813.22 ± 1.2% | | 1.00 | 1.08 | 141.50 |
| imported/sherlock/name-alt5 | 4028 | 6405.08 ± 0.4% | not timed | not timed | 3745.33 ± 0.2% | 21.90 ± 0.1% | not timed | not timed | 6419.62 ± 0.4% | | 1.00 | 1.71 | 292.45 |
| imported/sherlock/name-alt5-casei | 4104 | 3483.06 ± 1.7% | not timed | not timed | 2229.53 ± 0.1% | 14.34 ± 0.4% | not timed | not timed | 3488.60 ± 0.7% | | 1.00 | 1.56 | 242.92 |
| imported/sherlock/no-match-uncommon | 0 | 21733.32 ± 0.3% | not timed | not timed | 19690.21 ± 0.4% | 35758.91 ± 0.3% | not timed | not timed | 21740.99 ± 0.9% | | 1.00 | 1.10 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21599.39 ± 0.6% | not timed | not timed | 19639.51 ± 0.3% | 1282.38 ± 0.7% | not timed | not timed | 21618.50 ± 0.5% | | 1.00 | 1.10 | 16.84 |
| imported/sherlock/no-match-really-common | 0 | 16076.24 ± 4.1% | not timed | not timed | 18774.18 ± 0.7% | 1277.89 ± 1.2% | not timed | not timed | 16205.40 ± 2.0% | | 0.99 | 0.86 | 12.58 |
| imported/sherlock/the-lower | 21654 | 2293.47 ± 1.3% | not timed | not timed | 2338.17 ± 0.3% | 242.69 ± 16.4% | not timed | not timed | 2304.20 ± 1.7% | | 1.00 | 0.98 | 9.45 |
| imported/sherlock/the-upper | 2223 | 12699.40 ± 1.4% | not timed | not timed | 13600.61 ± 1.0% | 2710.85 ± 4.0% | not timed | not timed | 12793.18 ± 1.5% | | 0.99 | 0.93 | 4.68 |
| imported/sherlock/the-casei | 23961 | 1993.45 ± 1.5% | not timed | not timed | 1321.58 ± 0.5% | 35.11 ± 34.8% | not timed | not timed | 1998.95 ± 0.3% | | 1.00 | 1.51 | 56.78 |
| imported/sherlock/everything-greedy | 581881 | 282.67 ± 8.4% | not timed | not timed | 165.21 ± 0.2% | 28.93 ± 13.3% | not timed | not timed | 281.92 ± 0.1% | | 1.00 | 1.71 | 9.77 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.07 ± 0.2% | not timed | not timed | 213.73 ± 0.4% | 32.96 ± 0.1% | not timed | not timed | 489.98 ± 0.0% | | 1.00 | 2.30 | 14.90 |
| imported/sherlock/letters | 447175 | 61.56 ± 1.0% | not timed | not timed | 32.99 ± 0.1% | 6.41 ± 26.6% | not timed | not timed | 61.87 ± 1.3% | | 1.00 | 1.87 | 9.60 |
| imported/sherlock/letters-upper | 14180 | 448.51 ± 2.1% | not timed | not timed | 371.94 ± 0.1% | 29.63 ± 23.4% | not timed | not timed | 446.37 ± 0.2% | | 1.00 | 1.21 | 15.14 |
| imported/sherlock/letters-lower | 432995 | 62.61 ± 1.2% | not timed | not timed | 33.82 ± 0.1% | 6.94 ± 53.6% | not timed | not timed | 63.04 ± 1.2% | | 0.99 | 1.85 | 9.02 |
| imported/sherlock/words | 447639 | 111.96 ± 1.0% | not timed | not timed | 83.20 ± 0.9% | 13.99 ± 25.2% | not timed | not timed | 113.18 ± 0.5% | | 0.99 | 1.35 | 8.01 |
| imported/sherlock/before-holmes | 4073 | 10291.25 ± 0.8% | not timed | not timed | 8500.57 ± 0.3% | 24.07 ± 0.8% | not timed | not timed | 10270.01 ± 0.2% | | 1.00 | 1.21 | 427.61 |
| imported/sherlock/before-after-holmes | 2593 | 9957.63 ± 0.9% | not timed | not timed | 9544.81 ± 0.4% | 23.84 ± 1.9% | not timed | not timed | 9974.76 ± 0.8% | | 1.00 | 1.04 | 417.69 |
| imported/sherlock/holmes-cochar-watson | 150 | 5190.08 ± 0.2% | not timed | not timed | 3422.74 ± 0.2% | 30.97 ± 0.2% | not timed | not timed | 5194.70 ± 0.1% | | 1.00 | 1.52 | 167.57 |
| imported/sherlock/holmes-coword-watson | 14309 | 1154.28 ± 0.2% | not timed | not timed | 1120.66 ± 0.8% | 6.78 ± 0.3% | not timed | not timed | 1154.21 ± 0.1% | | 1.00 | 1.03 | 170.34 |
| imported/sherlock/quotes | 14437 | 1572.87 ± 1.2% | not timed | not timed | 1757.59 ± 0.8% | 35.11 ± 0.1% | not timed | not timed | 1572.88 ± 0.5% | | 1.00 | 0.89 | 44.80 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17452.59 ± 0.2% | not timed | not timed | 16104.65 ± 0.5% | 36.76 ± 0.3% | not timed | not timed | 17342.90 ± 0.2% | | 1.01 | 1.08 | 474.72 |
| imported/sherlock/word-ending-n | 35297 | 481.37 ± 0.1% | not timed | not timed | 408.82 ± 0.1% | 23.54 ± 1.5% | not timed | not timed | 480.73 ± 0.5% | | 1.00 | 1.18 | 20.44 |
| imported/sherlock/repeated-class-negation | 2130 | 14846.43 ± 0.6% | not timed | not timed | 11054.54 ± 1.0% | 11.58 ± 0.2% | not timed | not timed | 14819.71 ± 0.3% | | 1.00 | 1.34 | 1281.69 |
| imported/sherlock/ing-suffix | 20547 | 559.40 ± 1.5% | not timed | not timed | 518.05 ± 0.2% | 28.85 ± 34.2% | not timed | not timed | 558.54 ± 0.5% | | 1.00 | 1.08 | 19.39 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1665.00 ± 0.8% | not timed | not timed | 2105.42 ± 0.4% | 20.52 ± 0.4% | not timed | not timed | 1661.81 ± 0.7% | | 1.00 | 0.79 | 81.14 |
| opt/accelerate/whole-line | 239963 | 457.32 ± 0.1% | not timed | not timed | 373.89 ± 0.5% | 91.93 ± 17.1% | not timed | not timed | 457.21 ± 0.4% | | 1.00 | 1.22 | 4.97 |
| opt/accelerate/non-dna | 16745 | 431.75 ± 0.8% | not timed | not timed | 397.91 ± 0.1% | 29.28 ± 18.0% | not timed | not timed | 430.60 ± 2.7% | | 1.00 | 1.09 | 14.75 |
| opt/backtrack/words-english | 40536 | 141.54 ± 7.7% | not timed | not timed | 94.29 ± 0.1% | 19.76 ± 8.7% | not timed | not timed | 141.55 ± 1.1% | | 1.00 | 1.50 | 7.16 |
| opt/fixed-length/too-small-ascii | 0 | 311.47 ± 0.3% | not timed | not timed | 709.28 ± 1.5% | 80.36 ± 0.8% | not timed | not timed | 317.42 ± 0.3% | | 0.98 | 0.44 | 3.88 |
| opt/fixed-length/too-big-ascii | 0 | 3468.04 ± 0.2% | not timed | not timed | 5825.76 ± 1.2% | 125.73 ± 0.1% | not timed | not timed | 3458.74 ± 0.2% | | 1.00 | 0.60 | 27.58 |
| opt/fixed-length/go33484-1 | 0 | 665464.40 ± 0.1% | not timed | not timed | 1125431.92 ± 0.9% | 61343.38 ± 0.9% | not timed | not timed | 666029.20 ± 0.2% | | 1.00 | 0.59 | 10.85 |
| opt/fixed-length/go33484-2 | 0 | 665256.08 ± 0.4% | not timed | not timed | 1106917.82 ± 0.7% | 32351.97 ± 2.0% | not timed | not timed | 666158.26 ± 0.2% | | 1.00 | 0.60 | 20.56 |
| opt/fixed-length/go33484-3 | 0 | 66548.43 ± 0.7% | not timed | not timed | 112221.51 ± 0.8% | 768.69 ± 0.2% | not timed | not timed | 66550.39 ± 0.6% | | 1.00 | 0.59 | 86.57 |
| opt/literal-alt/one-pattern | 1 | 549.21 ± 3.1% | not timed | not timed | 544.39 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 550.08 ± 1.5% | | 1.00 | 1.01 | 1372.29 |
| opt/onepass/fn-predicate | 916 | 367.42 ± 0.6% | not timed | not timed | 336.68 ± 0.2% | 202.45 ± 14.6% | not timed | not timed | 370.02 ± 1.0% | | 0.99 | 1.09 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 179.72 ± 7.2% | not timed | not timed | 201.31 ± 0.1% | 79.24 ± 10.1% | not timed | not timed | 182.27 ± 1.8% | | 0.99 | 0.89 | 2.27 |
| opt/prefilter/literal-english | 1 | 21111.98 ± 0.1% | not timed | not timed | 20058.47 ± 0.3% | 17674.93 ± 0.8% | not timed | not timed | 21034.76 ± 0.2% | | 1.00 | 1.05 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14615.92 ± 0.4% | not timed | not timed | 4314.27 ± 0.2% | 32.65 ± 0.2% | not timed | not timed | 14600.61 ± 0.2% | | 1.00 | 3.39 | 447.59 |
| opt/prefilter/literal-russian | 1 | 21820.84 ± 0.2% | not timed | not timed | 20329.92 ± 0.2% | 3333.80 ± 0.2% | not timed | not timed | 21824.40 ± 0.1% | | 1.00 | 1.07 | 6.55 |
| opt/prefilter/literal-casei-russian | 1 | 8613.45 ± 0.2% | not timed | not timed | 3898.34 ± 0.3% | 31.70 ± 0.2% | not timed | not timed | 8605.92 ± 0.2% | | 1.00 | 2.21 | 271.75 |
| opt/prefilter/rust-functions | 948 | 6822.36 ± 0.6% | not timed | not timed | 8906.33 ± 0.4% | 1870.88 ± 0.6% | not timed | not timed | 6825.73 ± 0.4% | | 1.00 | 0.77 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29662890.89 ± 0.1% | not timed | not timed | 21956455.40 ± 0.4% | 50.45 ± 0.1% | not timed | not timed | 29669820.33 ± 0.2% | | 1.00 | 1.35 | 587939.66 |
| opt/reverse-inner/holmes | 2593 | 9964.89 ± 1.0% | not timed | not timed | 9562.93 ± 0.4% | 24.21 ± 0.9% | not timed | not timed | 9977.48 ± 0.7% | | 1.00 | 1.04 | 411.63 |
| opt/reverse-inner/email | 47 | 36422.38 ± 1.3% | not timed | not timed | 45016.35 ± 0.7% | 32.43 ± 0.2% | not timed | not timed | 36787.02 ± 2.3% | | 0.99 | 0.81 | 1123.15 |
| opt/reverse-inner/factored-prefix | 3542 | 593.09 ± 0.4% | not timed | not timed | 596.18 ± 0.1% | 12.57 ± 0.3% | not timed | not timed | 591.91 ± 0.2% | | 1.00 | 0.99 | 47.20 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20961.54 ± 0.1% | not timed | not timed | 616.90 ± 0.0% | 74.97 ± 0.2% | not timed | not timed | 21152.76 ± 0.1% | | 0.99 | 33.98 | 279.60 |
| opt/reverse-inner/no-quadratic-forward | 0 | 727.01 ± 1.2% | not timed | not timed | 287.81 ± 0.2% | 24.69 ± 0.1% | not timed | not timed | 739.77 ± 1.8% | | 0.98 | 2.53 | 29.44 |
| opt/reverse-suffix/holmes | 4073 | 10294.68 ± 0.6% | not timed | not timed | 8463.10 ± 0.4% | 24.03 ± 1.5% | not timed | not timed | 10293.09 ± 0.4% | | 1.00 | 1.22 | 428.33 |
| opt/reverse-suffix/no-quadratic | 0 | 21055.12 ± 0.1% | not timed | not timed | 612.81 ± 0.4% | 75.01 ± 0.1% | not timed | not timed | 21130.12 ± 0.1% | | 1.00 | 34.36 | 280.69 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.48 ± 1.4% | not timed | not timed | 131.82 ± 0.1% | 12.90 ± 14.6% | not timed | not timed | 120.35 ± 3.2% | | 1.00 | 0.91 | 9.34 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.37 ± 3.1% | not timed | not timed | 132.55 ± 0.1% | 13.03 ± 13.5% | not timed | not timed | 120.70 ± 2.5% | | 1.00 | 0.91 | 9.24 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.4% | 112.44 ± 1.0% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 320.78 ± 0.3% | not timed | not timed | 295.07 ± 0.1% | 103.56 ± 0.8% | not timed | not timed | 322.58 ± 0.5% | | 0.99 | 1.09 | 3.10 |
| reported/i13-subset-regex/original-ascii | 4094 | 11198.92 ± 1.4% | not timed | not timed | 4437.00 ± 2.4% | 11.50 ± 0.0% | not timed | not timed | 11270.47 ± 1.6% | | 0.99 | 2.52 | 974.07 |
| reported/i13-subset-regex/original-unicode | 4094 | 10688.35 ± 2.9% | not timed | not timed | 252.76 ± 3.3% | 11.50 ± 1.2% | not timed | not timed | 11244.53 ± 2.8% | | 0.95 | 42.29 | 929.74 |
| reported/i13-subset-regex/big-ascii | 1955 | 10729.63 ± 2.0% | not timed | not timed | 68.21 ± 3.6% | 9.86 ± 0.1% | not timed | not timed | 10745.46 ± 1.7% | | 1.00 | 157.29 | 1088.11 |
| reported/i13-subset-regex/big-unicode | 1955 | 10644.18 ± 1.2% | not timed | not timed | 12.23 ± 54.8% | 9.65 ± 0.0% | not timed | not timed | 10750.44 ± 1.5% | | 0.99 | 870.53 | 1103.01 |
| reported/i13-subset-regex/huge-ascii | 55 | 10093.27 ± 1.7% | not timed | not timed | 11.01 ± 0.1% | 8.72 ± 0.2% | not timed | not timed | 10067.34 ± 1.4% | | 1.00 | 917.14 | 1157.07 |
| reported/i13-subset-regex/huge-unicode | 55 | 9718.07 ± 4.5% | not timed | not timed | 10.92 ± 0.4% | 8.77 ± 0.1% | not timed | not timed | 9736.85 ± 5.7% | | 1.00 | 889.54 | 1107.79 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.1% | not timed | not timed | 11.01 ± 0.2% | 8.77 ± 1.1% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 11.01 ± 0.2% | 8.77 ± 0.1% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.22 ± 0.3% | not timed | not timed | 101.45 ± 0.2% | 6.62 ± 0.3% | not timed | not timed | 484.54 ± 0.4% | | 1.00 | 4.76 | 73.03 |
| reported/i787-keywords/opt-ascii | 5674 | 485.37 ± 0.5% | not timed | not timed | 272.44 ± 0.2% | 10.27 ± 0.5% | not timed | not timed | 483.26 ± 0.3% | | 1.00 | 1.78 | 47.25 |
| slow/quadratic-regex-1x | 100 | 7.06 ± 1.7% | not timed | not timed | 4.95 ± 0.2% | 0.05 ± 7.7% | not timed | not timed | 6.88 ± 0.4% | | 1.03 | 1.43 | 144.02 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.1% | not timed | not timed | 2.75 ± 0.1% | 0.01 ± 0.1% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 269.24 |
| slow/quadratic-haystack-1x | 100 | 22.03 ± 0.7% | not timed | not timed | 10.01 ± 0.1% | 1.01 ± 15.7% | not timed | not timed | 21.95 ± 1.8% | | 1.00 | 2.20 | 21.84 |
| slow/quadratic-haystack-2x | 200 | 19.74 ± 0.7% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 11.7% | not timed | not timed | 19.72 ± 2.0% | | 1.00 | 3.56 | 37.09 |
| unicode/codepoints/any-one | 1112064 | 281.26 ± 0.4% | not timed | not timed | 175.24 ± 0.1% | 18.40 ± 1.3% | not timed | not timed | 281.33 ± 0.1% | | 1.00 | 1.60 | 15.29 |
| unicode/codepoints/any-all | 4382592 | 283.22 ± 1.7% | not timed | not timed | 246.88 ± 0.4% | 117.31 ± 0.1% | not timed | not timed | 281.66 ± 1.6% | | 1.01 | 1.15 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.77 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 602.23 ± 0.7% | not timed | not timed | 616.37 ± 0.2% | 133.38 ± 0.9% | not timed | not timed | 603.12 ± 0.5% | | 1.00 | 0.98 | 4.52 |
| unicode/overlapping-words/ascii | 6156 | 32.25 ± 0.3% | not timed | not timed | 38.86 ± 0.1% | 3.94 ± 1.5% | not timed | not timed | 32.30 ± 0.3% | | 1.00 | 0.83 | 8.17 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.0% | not timed | not timed | 4.46 ± 0.1% | 2.35 ± 0.8% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.32 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.8% | not timed | not timed | 4.11 ± 0.1% | 6.23 ± 11.1% | not timed | not timed | 1.27 ± 0.2% | | 1.00 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.29 ± 8.3% | not timed | not timed | 83.01 ± 0.4% | 11.54 ± 23.6% | not timed | not timed | 129.41 ± 0.8% | | 1.00 | 1.56 | 11.20 |
| unicode/word/boundary-long-english | 3466 | 607.27 ± 0.6% | not timed | not timed | 605.04 ± 0.2% | 32.76 ± 0.3% | not timed | not timed | 606.53 ± 0.7% | | 1.00 | 1.00 | 18.54 |
| unicode/word/around-holmes-english | 27 | 20309.11 ± 0.1% | not timed | not timed | 19756.93 ± 0.1% | 22.32 ± 1.3% | not timed | not timed | 20240.11 ± 1.1% | | 1.00 | 1.03 | 910.06 |
| wild/bibleref/long | 874 | 564.38 ± 0.2% | not timed | not timed | 581.32 ± 0.2% | 6.82 ± 0.1% | not timed | not timed | 566.36 ± 0.1% | | 1.00 | 0.97 | 82.71 |
| wild/bibleref/short | 30 | 24.02 ± 3.8% | not timed | not timed | 30.75 ± 0.8% | 13.66 ± 11.2% | not timed | not timed | 24.54 ± 3.2% | | 0.98 | 0.78 | 1.76 |
| wild/bibleref/line | 874 | 398.40 ± 8.0% | not timed | not timed | 211.12 ± 0.1% | 9.18 ± 11.0% | not timed | not timed | 399.43 ± 0.1% | | 1.00 | 1.89 | 43.39 |
| wild/caddy/caddy | 6 | 420.27 ± 1.9% | not timed | not timed | 249.29 ± 0.2% | 68.15 ± 12.0% | not timed | not timed | 422.61 ± 0.5% | | 0.99 | 1.69 | 6.17 |
| wild/dot-star-capture/rust-src-tools | 6 | 1061.92 ± 0.3% | not timed | not timed | 347.93 ± 0.2% | 13.60 ± 0.2% | not timed | not timed | 1058.22 ± 0.5% | | 1.00 | 3.05 | 78.07 |
| wild/ruff/noqa | 84 | 438.97 ± 0.5% | not timed | not timed | 460.53 ± 0.1% | 19.62 ± 2.2% | not timed | not timed | 438.77 ± 1.5% | | 1.00 | 0.95 | 22.37 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.42 ± 0.5% | not timed | not timed | 699.70 ± 0.3% | 134.68 ± 11.2% | not timed | not timed | 959.00 ± 0.4% | | 1.00 | 1.37 | 7.11 |
| wild/ruff/string-quote-prefix | 2972 | 1364.41 ± 0.8% | not timed | not timed | 405.70 ± 0.3% | 315.48 ± 25.6% | not timed | not timed | 1364.46 ± 0.7% | | 1.00 | 3.36 | 4.32 |
| wild/ruff/space-around-operator | 1224378 | 223.30 ± 1.7% | not timed | not timed | 186.54 ± 0.0% | 18.33 ± 1.7% | not timed | not timed | 223.81 ± 1.8% | | 1.00 | 1.20 | 12.19 |
| wild/ruff/shebang | 282 | 973.22 ± 0.4% | not timed | not timed | 328.29 ± 0.0% | 110.25 ± 12.0% | not timed | not timed | 978.69 ± 0.4% | | 0.99 | 2.96 | 8.83 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13841.12 ± 0.2% | not timed | not timed | 13853.82 ± 0.4% | 6903.83 ± 0.5% | not timed | not timed | 13847.74 ± 0.4% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12848.69 ± 0.5% | not timed | not timed | 13482.80 ± 0.5% | 6403.55 ± 0.8% | not timed | not timed | 12846.46 ± 0.7% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13210.68 ± 0.5% | not timed | not timed | 13657.69 ± 0.4% | 6609.25 ± 0.5% | not timed | not timed | 13259.44 ± 0.3% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9575.26 ± 0.2% | not timed | not timed | 13618.02 ± 0.3% | 6729.85 ± 0.6% | not timed | not timed | 9593.91 ± 0.1% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.41 ± 14.3% | not timed | not timed | 65.41 ± 1.3% | 2.23 ± 1.0% | not timed | not timed | 119.96 ± 14.1% | | 1.01 | 1.86 | 54.43 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 12.4% | not timed | not timed | 0.01 ± 2.5% | 0.01 ± 12.6% | not timed | not timed | 0.03 ± 2.4% | | 0.99 | 3.07 | 4.02 |
| dictionary/compile/english-15 | 1 | 0.35 ± 5.0% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 12.5% | not timed | not timed | 0.35 ± 19.1% | | 0.99 | 4.97 | 3.38 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 4.0% | not timed | not timed | 0.02 ± 1.3% | 35.70 ± 6.9% | not timed | not timed | 0.25 ± 17.0% | | 1.01 | 13.22 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.92 ± 2.1% | not timed | not timed | 11.60 ± 0.4% | 59.83 ± 19.5% | not timed | not timed | 47.82 ± 7.2% | | 1.00 | 4.13 | 0.80 |
| reported/i787-keywords/compile | 1 | 35.08 ± 2.7% | not timed | not timed | 2.13 ± 0.5% | 17.14 ± 25.5% | not timed | not timed | 35.57 ± 16.3% | | 0.99 | 16.48 | 2.05 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 362.54 ± 4.9% | not timed | not timed | 120.84 ± 0.2% | 583.39 ± 31.8% | not timed | not timed | 365.12 ± 2.9% | | 0.99 | 3.00 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.92 ± 3.1% | not timed | not timed | 4.11 ± 0.6% | 43.72 ± 11.3% | not timed | not timed | 48.48 ± 2.6% | | 0.99 | 11.65 | 1.10 |
| unicode/compile/one-letter | 53 | 6.79 ± 8.9% | not timed | not timed | 4.56 ± 0.3% | 67.66 ± 10.9% | not timed | not timed | 6.80 ± 3.0% | | 1.00 | 1.49 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.10 ± 3.1% | not timed | not timed | 0.10 ± 0.5% | 65.93 ± 8.8% | not timed | not timed | 1.12 ± 15.0% | | 0.99 | 10.90 | 0.0167 |
| unicode/compile/fifty-letters-ascii | 1 | 220.96 ± 8.0% | not timed | not timed | 51.64 ± 0.1% | 201.38 ± 6.6% | not timed | not timed | 223.26 ± 12.9% | | 0.99 | 4.28 | 1.10 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 378.64 ± 17.9% | not timed | not timed | 47.28 ± 0.3% | 674.41 ± 19.7% | not timed | not timed | 385.48 ± 2.4% | | 0.98 | 8.01 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 609.90 ± 6.8% | not timed | not timed | 145.83 ± 0.2% | 673.11 ± 28.2% | not timed | not timed | 611.03 ± 3.9% | | 1.00 | 4.18 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 331.16 ± 2.2% | not timed | not timed | 51.25 ± 0.1% | 1218.12 ± 26.4% | not timed | not timed | 331.50 ± 5.6% | | 1.00 | 6.46 | 0.27 |
| wild/bibleref/compile | 3 | 5.94 ± 1.7% | not timed | not timed | 1.95 ± 0.8% | 31.18 ± 4.9% | not timed | not timed | 5.96 ± 2.4% | | 1.00 | 3.05 | 0.19 |
| wild/url/compile | 1 | 0.66 ± 16.4% | not timed | not timed | 0.15 ± 0.4% | 0.42 ± 19.0% | not timed | not timed | 0.66 ± 11.9% | | 1.00 | 4.51 | 1.57 |

