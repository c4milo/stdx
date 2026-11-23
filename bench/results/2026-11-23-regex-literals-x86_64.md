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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243455127 |
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
| literal: a word | 217 | 40114.41 ± 3.2% | 3345.75 ± 0.4% | 20.06 ± 3.3% | 31376.68 ± 3.5% | 9045.44 ± 8.6% | 10.95 ± 0.1% | 76.13 ± 2.5% | 39465.49 ± 1.4% | 11.99 | 1.02 | 1.28 | 4.43 |
| literal: a word that is not there | 0 | 53720.93 ± 3.7% | 3241.07 ± 2.0% | 20.06 ± 0.9% | 39729.33 ± 1.7% | 30075.76 ± 0.5% | 10.87 ± 0.1% | 72.28 ± 1.0% | 53299.62 ± 3.2% | 16.58 | 1.01 | 1.35 | 1.79 |
| literal: one of four words | 661 | 11588.06 ± 0.4% | 1397.67 ± 0.2% | 11.07 ± 3.5% | 9129.57 ± 3.7% | 19.29 ± 1.5% | 3.95 ± 0.3% | 6.01 ± 1.5% | 11651.75 ± 1.4% | 8.29 | 0.99 | 1.27 | 600.61 |
| literal: a word in any case | 217 | 30080.67 ± 0.7% | 1492.87 ± 0.2% | 15.51 ± 0.9% | 9231.24 ± 0.2% | 37.29 ± 0.1% | refused | differs | 30221.82 ± 4.8% | 20.15 | 1.00 | 3.26 | 806.77 |
| literal: an href attribute | 33 | 29675.05 ± 3.0% | 539.29 ± 0.9% | 18.68 ± 4.4% | 27343.25 ± 6.4% | 2048.63 ± 2.7% | 8.35 ± 1.0% | 63.24 ± 9.1% | 29122.51 ± 2.5% | 55.03 | 1.02 | 1.09 | 14.49 |
| literal: a word, second text | 123 | 38628.44 ± 5.3% | 2381.48 ± 0.7% | 19.94 ± 0.5% | 32134.87 ± 7.7% | 7189.21 ± 9.0% | 12.01 ± 0.3% | 65.30 ± 1.9% | 38412.68 ± 2.0% | 16.22 | 1.01 | 1.20 | 5.37 |
| class: two capitalized words | 1331 | 764.95 ± 2.4% | 526.69 ± 0.2% | 18.83 ± 7.1% | 505.85 ± 0.1% | 34.38 ± 6.4% | 9.45 ± 0.4% | 57.36 ± 0.5% | 765.53 ± 2.3% | 1.45 | 1.00 | 1.51 | 22.25 |
| class: a word that ends in ing | 3399 | 499.28 ± 1.1% | 498.56 ± 0.3% | 12.95 ± 1.1% | 472.98 ± 0.3% | 25.76 ± 6.3% | 5.33 ± 0.2% | 16.47 ± 0.7% | 499.79 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.38 |
| class: a word in capitals | 2332 | 943.15 ± 0.2% | 530.77 ± 1.1% | 19.76 ± 0.2% | 496.49 ± 0.8% | 36.70 ± 14.7% | 10.51 ± 0.1% | 77.52 ± 0.9% | 942.55 ± 0.2% | 1.78 | 1.00 | 1.90 | 25.70 |
| class: a number | 8288 | 1448.56 ± 3.5% | 701.48 ± 0.3% | 19.67 ± 1.7% | 1483.72 ± 0.2% | 35.90 ± 13.2% | 0.34 ± 0.5% | 55.47 ± 0.3% | 1448.38 ± 0.4% | 2.07 | 1.00 | 0.98 | 40.35 |
| class: two capitalized words, second text | 5359 | 444.30 ± 0.4% | 450.99 ± 0.5% | 17.16 ± 0.8% | 417.85 ± 0.2% | 28.84 ± 9.4% | 10.62 ± 0.1% | 52.35 ± 1.3% | 443.45 ± 0.2% | 0.99 | 1.00 | 1.06 | 15.41 |
| other: a word between two words | 6104 | 712.51 ± 0.3% | 510.35 ± 1.8% | 16.87 ± 1.2% | 684.16 ± 0.2% | 100.90 ± 9.2% | 7.34 ± 0.3% | 57.97 ± 1.8% | 714.52 ± 1.1% | 1.40 | 1.00 | 1.04 | 7.06 |
| other: a number before a unit, second text | 1481 | 7290.06 ± 0.6% | 860.21 ± 0.6% | 18.81 ± 0.3% | 6452.40 ± 1.0% | 35.16 ± 0.3% | 11.00 ± 0.3% | 56.22 ± 0.8% | 7282.73 ± 0.9% | 8.47 | 1.00 | 1.13 | 207.32 |
| other: a heading's start tag | 110 | 19855.82 ± 0.8% | 654.40 ± 0.1% | 19.56 ± 0.5% | 2009.60 ± 3.3% | 1473.59 ± 15.5% | 10.16 ± 0.3% | 74.32 ± 0.7% | 19873.12 ± 1.8% | 30.34 | 1.00 | 9.88 | 13.47 |
| other: a whole word | 217 | 23825.91 ± 2.4% | 532.16 ± 1.1% | 20.14 ± 4.5% | 22050.18 ± 11.8% | 40.24 ± 2.8% | 9.59 ± 1.7% | 46.83 ± 0.9% | 22865.73 ± 4.6% | 44.77 | 1.04 | 1.08 | 592.05 |
| other: a line's first word, second text | 3716 | 1958.58 ± 8.7% | 513.45 ± 0.1% | 24.08 ± 0.6% | 1715.25 ± 4.4% | 52.87 ± 4.4% | refused | refused | 1988.63 ± 2.8% | 3.81 | 0.98 | 1.14 | 37.05 |
| other: fourteen octets before an x | 87 | 27660.20 ± 5.3% | 208.53 ± 2.3% | 5.39 ± 0.2% | 2769.63 ± 0.3% | 8.98 ± 3.9% | differs | 14.23 ± 3.3% | 27528.08 ± 1.1% | 132.64 | 1.00 | 9.99 | 3079.37 |
| other: a Greek word | 21815 | 384.25 ± 0.5% | 333.35 ± 0.3% | 24.01 ± 4.7% | 264.94 ± 0.8% | 43.99 ± 12.4% | differs | refused | 382.31 ± 1.5% | 1.15 | 1.01 | 1.45 | 8.74 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.89 ± 2.2% | 16.99 ± 0.8% | 0.78 ± 0.9% | 17.03 ± 0.4% | 2.15 ± 0.8% | differs | 3.62 ± 13.1% | 16.99 ± 0.7% | 0.99 | 0.99 | 0.99 | 7.85 |
| a UUID | 32895 | 18.45 ± 0.1% | 18.29 ± 0.2% | 0.54 ± 5.6% | 12.88 ± 1.8% | 2.50 ± 0.5% | 0.43 ± 0.1% | 2.93 ± 13.4% | 18.42 ± 7.0% | 1.01 | 1.00 | 1.43 | 7.37 |
| an IPv4 address | 33176 | 30.63 ± 1.7% | 30.06 ± 0.6% | 1.70 ± 6.8% | 24.28 ± 0.4% | 5.70 ± 2.6% | differs | 3.38 ± 0.8% | 30.59 ± 1.1% | 1.02 | 1.00 | 1.26 | 5.38 |
| a date and time | 32954 | 27.34 ± 9.4% | 27.27 ± 0.2% | 1.25 ± 16.6% | 18.10 ± 0.4% | 6.61 ± 1.4% | 0.75 ± 0.2% | 5.98 ± 1.9% | 27.30 ± 9.4% | 1.00 | 1.00 | 1.51 | 4.14 |
| a field path | 32606 | 19.98 ± 3.2% | 19.90 ± 0.6% | 0.88 ± 1.4% | 19.66 ± 3.0% | 2.90 ± 0.3% | differs | 2.45 ± 0.9% | 19.93 ± 5.4% | 1.00 | 1.00 | 1.02 | 6.88 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.66 ± 0.3% | 8.78 ± 0.6% | 8.73 ± 0.2% | 10.70 ± 6.6% | 4.73 ± 2.5% | 0.62 ± 0.4% | none | 8.77 ± 0.3% | 0.99 | 0.99 | 0.81 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 189.06 ± 0.5% | 189.36 ± 4.8% | 217.91 ± 1.6% | 79.86 ± 3.7% | 186.51 ± 1.1% | 541.68 ± 3.8% | 3535.61 ± 3.3% | 189.02 ± 0.3% | 1.00 | 1.00 | 2.37 | 1.01 |
| a UUID | 62 | 123.28 ± 0.2% | 123.62 ± 0.4% | 135.94 ± 0.8% | 46.40 ± 0.8% | 90.50 ± 1.1% | 195.77 ± 6.5% | 3858.00 ± 0.2% | 123.15 ± 0.5% | 1.00 | 1.00 | 2.66 | 1.36 |
| an IPv4 address | 29 | 384.13 ± 1.3% | 386.96 ± 0.8% | 528.52 ± 0.3% | 70.14 ± 9.6% | 115.10 ± 2.5% | 336.18 ± 5.1% | 6574.51 ± 0.5% | 387.56 ± 0.4% | 0.99 | 0.99 | 5.48 | 3.34 |
| a date and time | 56 | 280.33 ± 1.2% | 281.74 ± 0.2% | 347.02 ± 0.4% | 69.17 ± 0.5% | 123.80 ± 2.1% | 373.52 ± 2.7% | 3854.07 ± 2.9% | 280.43 ± 0.1% | 1.00 | 1.00 | 4.05 | 2.26 |
| a field path | 39 | 186.27 ± 0.3% | 186.77 ± 0.5% | 213.86 ± 0.4% | 76.48 ± 2.2% | 172.29 ± 5.7% | 638.96 ± 7.6% | 4435.15 ± 1.3% | 186.18 ± 0.5% | 1.00 | 1.00 | 2.44 | 1.08 |
| literal: a word | 7 | 595.88 ± 1.0% | 641.14 ± 0.9% | 1094.28 ± 3.9% | 493.32 ± 2.1% | 583.68 ± 3.2% | 1278.62 ± 1.0% | 24680.16 ± 0.9% | 595.64 ± 1.4% | 0.93 | 1.00 | 1.21 | 1.02 |
| literal: a word that is not there | 8 | 570.83 ± 0.6% | 619.80 ± 0.4% | 1021.56 ± 0.6% | 451.43 ± 3.8% | 557.50 ± 2.1% | 1190.39 ± 1.2% | 23440.56 ± 0.8% | 569.88 ± 1.4% | 0.92 | 1.00 | 1.26 | 1.02 |
| literal: one of four words | 26 | 217.99 ± 0.6% | 362.38 ± 16.0% | 479.28 ± 0.3% | 41.77 ± 7.1% | 215.33 ± 16.2% | 429.65 ± 3.3% | 9855.83 ± 6.2% | 217.60 ± 5.3% | 0.60 | 1.00 | 5.22 | 1.01 |
| literal: a word in any case | 11 | 402.78 ± 0.4% | 424.20 ± 0.3% | 588.17 ± 0.8% | 14.37 ± 0.5% | 613.82 ± 18.3% | refused | 18669.53 ± 18.0% | 402.47 ± 7.1% | 0.95 | 1.00 | 28.03 | 0.66 |
| literal: an href attribute | 12 | 321.12 ± 0.2% | 333.11 ± 0.6% | 430.12 ± 0.7% | 37.30 ± 0.9% | 440.20 ± 1.8% | 962.49 ± 10.0% | 17386.89 ± 0.8% | 321.34 ± 0.3% | 0.96 | 1.00 | 8.61 | 0.73 |
| literal: a word, second text | 10 | 521.92 ± 2.2% | 573.83 ± 2.6% | 910.62 ± 2.4% | 412.02 ± 16.5% | 481.71 ± 3.8% | 1014.36 ± 2.2% | 19691.23 ± 5.1% | 522.39 ± 2.5% | 0.91 | 1.00 | 1.27 | 1.08 |
| class: two capitalized words | 23 | 414.88 ± 2.1% | 449.39 ± 0.8% | 638.24 ± 4.0% | 94.65 ± 0.4% | 457.38 ± 2.0% | 936.54 ± 1.6% | 6130.87 ± 0.3% | 415.81 ± 0.7% | 0.92 | 1.00 | 4.38 | 0.91 |
| class: a word that ends in ing | 9 | 512.03 ± 0.4% | 587.19 ± 1.0% | 1007.83 ± 0.3% | 113.44 ± 1.3% | 633.69 ± 2.6% | 1392.18 ± 1.9% | 14768.17 ± 0.7% | 511.40 ± 0.6% | 0.87 | 1.00 | 4.51 | 0.81 |
| class: a word in capitals | 16 | 442.74 ± 2.5% | 479.18 ± 1.1% | 775.41 ± 0.8% | 121.41 ± 1.5% | 651.61 ± 4.1% | 1298.66 ± 0.6% | 8224.33 ± 0.6% | 441.74 ± 7.9% | 0.92 | 1.00 | 3.65 | 0.68 |
| class: a number | 6 | 572.15 ± 11.2% | 633.09 ± 0.5% | 1181.02 ± 0.4% | 36.47 ± 1.7% | 1169.92 ± 2.5% | 2278.22 ± 2.6% | 20153.66 ± 8.4% | 572.65 ± 0.4% | 0.90 | 1.00 | 15.69 | 0.49 |
| class: two capitalized words, second text | 23 | 417.28 ± 2.4% | 437.85 ± 3.7% | 620.50 ± 3.7% | 96.52 ± 0.6% | 459.93 ± 0.8% | 961.61 ± 0.8% | 6097.79 ± 2.3% | 417.39 ± 2.1% | 0.95 | 1.00 | 4.32 | 0.91 |
| other: a word between two words | 13 | 503.51 ± 0.8% | 524.39 ± 1.0% | 807.45 ± 1.0% | 123.94 ± 0.9% | 443.09 ± 2.8% | 1037.69 ± 1.1% | 12709.13 ± 2.2% | 504.01 ± 0.6% | 0.96 | 1.00 | 4.06 | 1.14 |
| other: a number before a unit, second text | 15 | 355.33 ± 0.4% | 401.35 ± 2.0% | 548.92 ± 0.5% | 33.57 ± 1.2% | 540.45 ± 2.1% | 1144.16 ± 2.8% | 12849.27 ± 2.5% | 354.85 ± 1.1% | 0.89 | 1.00 | 10.58 | 0.66 |
| other: a heading's start tag | 13 | 331.20 ± 7.3% | 337.33 ± 0.5% | 439.69 ± 9.5% | 34.92 ± 2.5% | 529.25 ± 0.7% | 1090.36 ± 0.8% | 15176.46 ± 15.1% | 331.00 ± 0.3% | 0.98 | 1.00 | 9.49 | 0.63 |
| other: a whole word | 11 | 503.44 ± 0.6% | 536.19 ± 9.5% | 818.66 ± 0.9% | 111.43 ± 3.6% | 506.85 ± 1.0% | 1078.72 ± 2.7% | 18962.54 ± 4.5% | 503.87 ± 0.6% | 0.94 | 1.00 | 4.52 | 0.99 |
| other: a line's first word, second text | 17 | 488.64 ± 10.7% | 516.07 ± 0.4% | 810.31 ± 0.3% | 115.20 ± 9.9% | 607.23 ± 1.6% | refused | refused | 487.52 ± 0.7% | 0.95 | 1.00 | 4.24 | 0.80 |
| other: fourteen octets before an x | 16 | 87.74 ± 7.5% | 124.46 ± 2.6% | 141.30 ± 0.4% | 14.20 ± 0.8% | 399.11 ± 1.5% | 449.96 ± 6.8% | 11735.84 ± 1.1% | 87.68 ± 2.5% | 0.70 | 1.00 | 6.18 | 0.22 |
| other: a Greek word | 8 | 387.13 ± 4.9% | 536.52 ± 1.0% | 887.07 ± 0.4% | 46.55 ± 0.4% | 1173.02 ± 3.5% | 2191.31 ± 0.6% | refused | 386.33 ± 0.4% | 0.72 | 1.00 | 8.32 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27249.43 ± 1.4% | not timed | not timed | 26854.26 ± 0.8% | 1946.63 ± 29.3% | not timed | not timed | 27152.56 ± 0.4% | | 1.00 | 1.01 | 14.00 |
| 01-literal/sherlock-casei-en | 522 | 8020.82 ± 0.8% | not timed | not timed | 7011.44 ± 4.7% | 23.49 ± 0.3% | not timed | not timed | 7813.11 ± 0.8% | | 1.03 | 1.14 | 341.48 |
| 01-literal/sherlock-ru | 724 | 28725.39 ± 3.7% | not timed | not timed | 27971.64 ± 18.9% | 1077.90 ± 2.6% | not timed | not timed | 28515.28 ± 1.1% | | 1.01 | 1.03 | 26.65 |
| 01-literal/sherlock-casei-ru | 746 | 9708.37 ± 0.9% | not timed | not timed | 5521.10 ± 0.2% | 29.79 ± 6.8% | not timed | not timed | 9544.45 ± 7.1% | | 1.02 | 1.76 | 325.86 |
| 01-literal/sherlock-zh | 30 | 47203.17 ± 1.0% | not timed | not timed | 36832.21 ± 1.0% | 1265.91 ± 0.3% | not timed | not timed | 47124.50 ± 1.5% | | 1.00 | 1.28 | 37.29 |
| 02-literal-alternate/sherlock-en | 714 | 10096.64 ± 0.3% | not timed | not timed | 8902.65 ± 0.3% | 14.75 ± 4.5% | not timed | not timed | 10109.77 ± 1.5% | | 1.00 | 1.13 | 684.60 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2037.88 ± 1.6% | not timed | not timed | 1823.54 ± 0.4% | 8.88 ± 2.0% | not timed | not timed | 2015.37 ± 1.0% | | 1.01 | 1.12 | 229.44 |
| 02-literal-alternate/sherlock-ru | 899 | 8124.08 ± 0.3% | not timed | not timed | 4264.13 ± 0.2% | 19.61 ± 0.9% | not timed | not timed | 7995.97 ± 1.3% | | 1.02 | 1.91 | 414.37 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2099.08 ± 0.7% | not timed | not timed | 1045.88 ± 10.2% | 8.49 ± 6.7% | not timed | not timed | 2080.15 ± 0.4% | | 1.01 | 2.01 | 247.17 |
| 02-literal-alternate/sherlock-zh | 207 | 14425.21 ± 1.8% | not timed | not timed | 10427.29 ± 5.9% | 25.47 ± 1.9% | not timed | not timed | 14450.00 ± 0.3% | | 1.00 | 1.38 | 566.30 |
| 03-date/ascii | 111817 | 96.04 ± 3.8% | not timed | not timed | 85.07 ± 11.6% | 0.18 ± 1.8% | not timed | not timed | 96.38 ± 6.4% | | 1.00 | 1.13 | 541.78 |
| 04-ruff-noqa/real | 84 | 410.70 ± 0.7% | not timed | not timed | 428.82 ± 0.5% | 16.26 ± 1.1% | not timed | not timed | 411.07 ± 1.1% | | 1.00 | 0.96 | 25.26 |
| 04-ruff-noqa/tweaked | 44 | 513.78 ± 0.5% | not timed | not timed | 418.13 ± 0.5% | 294.66 ± 1.1% | not timed | not timed | 513.53 ± 1.0% | | 1.00 | 1.23 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.48 ± 0.7% | not timed | not timed | 4.08 ± 0.7% | 0.22 ± 6.2% | not timed | not timed | 3.42 ± 2.6% | | 1.02 | 0.85 | 16.18 |
| 06-cloud-flare-redos/original | 107 | 349.05 ± 0.3% | not timed | not timed | 190.19 ± 0.5% | 19.59 ± 1.6% | not timed | not timed | 348.70 ± 0.2% | | 1.00 | 1.84 | 17.81 |
| 06-cloud-flare-redos/simplified-short | 102 | 330.65 ± 0.1% | not timed | not timed | 192.24 ± 0.5% | 21.89 ± 0.2% | not timed | not timed | 330.55 ± 2.9% | | 1.00 | 1.72 | 15.11 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.73 ± 0.2% | not timed | not timed | 211.51 ± 15.3% | 24.11 ± 0.6% | not timed | not timed | 465.12 ± 0.1% | | 1.00 | 2.20 | 19.28 |
| 07-unicode-character-data/parse-line | 558784 | 204.57 ± 2.2% | not timed | not timed | 159.83 ± 8.8% | 37.56 ± 2.6% | not timed | not timed | 203.40 ± 1.8% | | 1.01 | 1.28 | 5.45 |
| 08-words/all-english | 56691 | 96.40 ± 0.5% | not timed | not timed | 73.80 ± 0.6% | 10.22 ± 11.3% | not timed | not timed | 95.58 ± 0.8% | | 1.01 | 1.31 | 9.43 |
| 08-words/long-english | 839 | 536.21 ± 0.9% | not timed | not timed | 515.39 ± 0.1% | 26.27 ± 1.2% | not timed | not timed | 535.23 ± 0.3% | | 1.00 | 1.04 | 20.41 |
| 09-aws-keys/full | 0 | 415.90 ± 0.2% | not timed | not timed | 443.73 ± 1.0% | 54.82 ± 5.3% | not timed | not timed | 416.17 ± 1.9% | | 1.00 | 0.94 | 7.59 |
| 09-aws-keys/quick | 0 | 970.88 ± 0.5% | not timed | not timed | 805.70 ± 0.4% | 332.36 ± 1.0% | not timed | not timed | 908.64 ± 0.1% | | 1.07 | 1.21 | 2.92 |
| 10-bounded-repeat/letters-en | 1833 | 482.81 ± 0.4% | not timed | not timed | 431.74 ± 0.1% | 16.15 ± 5.4% | not timed | not timed | 482.43 ± 0.5% | | 1.00 | 1.12 | 29.90 |
| 10-bounded-repeat/letters-ru | 3475 | 429.00 ± 0.4% | not timed | not timed | 407.50 ± 0.4% | 17.38 ± 13.2% | not timed | not timed | 429.10 ± 3.2% | | 1.00 | 1.05 | 24.68 |
| 10-bounded-repeat/context | 53 | 65.02 ± 1.1% | not timed | not timed | 55.94 ± 0.9% | 16.89 ± 0.4% | not timed | not timed | 65.46 ± 1.0% | | 0.99 | 1.16 | 3.85 |
| 10-bounded-repeat/capitals | 11 | 557.52 ± 8.0% | not timed | not timed | 532.29 ± 0.4% | 30.96 ± 0.2% | not timed | not timed | 554.09 ± 8.2% | | 1.01 | 1.05 | 18.01 |
| 11-unstructured-to-json/extract | 600 | 55.98 ± 2.8% | not timed | not timed | 62.40 ± 1.0% | 40.92 ± 0.7% | not timed | not timed | 56.72 ± 1.7% | | 0.99 | 0.90 | 1.37 |
| 12-dictionary/single | 1 | 455.49 ± 2.3% | not timed | not timed | 430.68 ± 4.4% | 0.32 ± 7.0% | not timed | not timed | 456.49 ± 2.3% | | 1.00 | 1.06 | 1439.46 |
| 14-quadratic/1x | 100 | 21.19 ± 1.3% | not timed | not timed | 9.09 ± 0.4% | 0.80 ± 1.6% | not timed | not timed | 21.14 ± 0.4% | | 1.00 | 2.33 | 26.46 |
| 14-quadratic/2x | 200 | 16.16 ± 1.1% | not timed | not timed | 4.91 ± 0.5% | 0.43 ± 1.6% | not timed | not timed | 16.19 ± 0.5% | | 1.00 | 3.29 | 37.29 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.2% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 1.9% | not timed | not timed | 5.61 ± 0.3% | | 1.00 | 5.35 | 60.63 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.12 ± 1.8% | not timed | not timed | 0.39 ± 0.4% | 0.48 ± 3.2% | not timed | not timed | 1.12 ± 2.0% | | 1.01 | 2.90 | 2.33 |
| 04-ruff-noqa/compile-real | 1 | 80.10 ± 0.7% | not timed | not timed | 13.14 ± 2.1% | 127.06 ± 2.0% | not timed | not timed | 78.85 ± 2.4% | | 1.02 | 6.09 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 12.35 ± 0.4% | not timed | not timed | 2.38 ± 0.6% | 5.90 ± 2.8% | not timed | not timed | 12.33 ± 1.4% | | 1.00 | 5.18 | 2.09 |
| 07-unicode-character-data/compile | 1 | 49.58 ± 0.5% | not timed | not timed | 24.41 ± 0.6% | 32.83 ± 3.2% | not timed | not timed | 49.46 ± 0.2% | | 1.00 | 2.03 | 1.51 |
| 09-aws-keys/compile-full | 1 | 34.20 ± 1.0% | not timed | not timed | 7.47 ± 1.0% | 20.70 ± 5.3% | not timed | not timed | 34.09 ± 1.5% | | 1.00 | 4.58 | 1.65 |
| 09-aws-keys/compile-quick | 1 | 154.93 ± 0.4% | not timed | not timed | 45.60 ± 0.8% | 119.82 ± 1.3% | not timed | not timed | 154.11 ± 3.1% | | 1.01 | 3.40 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 10.53 ± 0.2% | not timed | not timed | 11.74 ± 0.6% | 15.31 ± 3.0% | not timed | not timed | 10.54 ± 0.2% | | 1.00 | 0.90 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.78 ± 0.7% | not timed | not timed | 8.85 ± 0.5% | 22.28 ± 1.6% | not timed | not timed | 71.87 ± 2.2% | | 1.01 | 8.22 | 3.27 |
| 11-unstructured-to-json/compile | 1 | 74.72 ± 1.7% | not timed | not timed | 37.72 ± 1.4% | 60.44 ± 2.7% | not timed | not timed | 74.29 ± 1.8% | | 1.01 | 1.98 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.28 ± 0.7% | not timed | not timed | 0.07 ± 0.7% | 0.09 ± 12.6% | not timed | not timed | 0.28 ± 4.8% | | 1.02 | 4.09 | 3.13 |

