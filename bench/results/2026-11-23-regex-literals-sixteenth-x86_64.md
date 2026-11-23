# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243547755 |
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
| literal: a word | 217 | 31206.45 ± 0.3% | 3489.00 ± 0.4% | 27.82 ± 0.9% | 25793.25 ± 0.8% | 8575.64 ± 4.9% | 12.25 ± 0.7% | 88.66 ± 4.0% | 31157.00 ± 0.9% | 8.94 | 1.00 | 1.21 | 3.64 |
| literal: a word that is not there | 0 | 36979.68 ± 0.3% | 3427.74 ± 0.2% | 27.82 ± 0.4% | 28861.59 ± 0.4% | 23428.25 ± 0.8% | 11.84 ± 1.5% | 84.12 ± 0.8% | 36830.34 ± 0.6% | 10.79 | 1.00 | 1.28 | 1.58 |
| literal: one of four words | 661 | 11100.55 ± 4.0% | 1612.50 ± 0.6% | 14.60 ± 0.3% | 7861.41 ± 2.0% | 21.23 ± 0.3% | 3.78 ± 3.3% | 5.91 ± 2.4% | 10844.41 ± 3.5% | 6.88 | 1.02 | 1.41 | 522.97 |
| literal: a word in any case | 217 | 26477.95 ± 1.2% | 1729.95 ± 0.4% | 20.53 ± 1.4% | 8214.08 ± 0.7% | 40.91 ± 0.6% | refused | differs | 26089.84 ± 4.2% | 15.31 | 1.01 | 3.22 | 647.16 |
| literal: an href attribute | 33 | 26110.77 ± 2.1% | 582.26 ± 0.1% | 24.86 ± 1.0% | 23670.96 ± 1.2% | 1899.93 ± 0.5% | 8.88 ± 0.4% | 77.63 ± 0.4% | 26018.33 ± 0.6% | 44.84 | 1.00 | 1.10 | 13.74 |
| literal: a word, second text | 123 | 32820.66 ± 0.7% | 2596.83 ± 1.4% | 27.71 ± 0.4% | 25646.98 ± 0.8% | 6683.12 ± 6.3% | 15.03 ± 0.3% | 75.80 ± 1.1% | 32763.45 ± 1.0% | 12.64 | 1.00 | 1.28 | 4.91 |
| class: two capitalized words | 1331 | 857.31 ± 0.4% | 565.60 ± 0.9% | 25.36 ± 1.0% | 545.71 ± 0.4% | 36.63 ± 5.4% | 10.54 ± 0.3% | 65.71 ± 0.8% | 857.20 ± 0.7% | 1.52 | 1.00 | 1.57 | 23.41 |
| class: a word that ends in ing | 3399 | 534.43 ± 0.1% | 534.99 ± 0.3% | 16.84 ± 0.2% | 504.68 ± 0.6% | 27.20 ± 4.3% | 5.84 ± 0.1% | 18.74 ± 1.4% | 532.99 ± 1.1% | 1.00 | 1.00 | 1.06 | 19.65 |
| class: a word in capitals | 2332 | 1121.74 ± 0.6% | 567.70 ± 0.2% | 25.57 ± 3.3% | 535.02 ± 0.3% | 39.18 ± 15.6% | 12.41 ± 0.6% | 81.98 ± 0.7% | 1085.40 ± 0.4% | 1.98 | 1.03 | 2.10 | 28.63 |
| class: a number | 8288 | 1678.13 ± 0.9% | 698.72 ± 1.6% | 27.13 ± 0.2% | 1594.60 ± 0.5% | 37.31 ± 11.7% | 0.36 ± 0.4% | 59.31 ± 1.9% | 1676.34 ± 0.8% | 2.40 | 1.00 | 1.05 | 44.98 |
| class: two capitalized words, second text | 5359 | 470.81 ± 0.3% | 474.34 ± 0.2% | 22.98 ± 0.5% | 443.19 ± 0.3% | 29.71 ± 10.5% | 13.07 ± 1.2% | 60.49 ± 2.3% | 470.29 ± 0.2% | 0.99 | 1.00 | 1.06 | 15.85 |
| other: a word between two words | 6104 | 759.12 ± 0.5% | 531.77 ± 0.6% | 22.61 ± 0.2% | 731.97 ± 0.6% | 101.87 ± 12.6% | 8.01 ± 0.9% | 69.46 ± 1.1% | 756.10 ± 1.8% | 1.43 | 1.00 | 1.04 | 7.45 |
| other: a number before a unit, second text | 1481 | 7253.47 ± 3.9% | 955.32 ± 0.6% | 26.11 ± 0.7% | 6864.35 ± 0.2% | 36.98 ± 7.0% | 13.79 ± 3.1% | 63.98 ± 3.1% | 7095.89 ± 3.1% | 7.59 | 1.02 | 1.06 | 196.14 |
| other: a heading's start tag | 110 | 19130.28 ± 0.2% | 679.55 ± 0.2% | 26.85 ± 0.6% | 2032.06 ± 0.5% | 1371.24 ± 2.5% | 10.80 ± 4.3% | 89.76 ± 0.4% | 19143.45 ± 0.4% | 28.15 | 1.00 | 9.41 | 13.95 |
| other: a whole word | 217 | 22676.25 ± 0.0% | 575.23 ± 0.6% | 29.16 ± 0.3% | 19872.41 ± 0.4% | 46.24 ± 0.4% | 10.54 ± 2.8% | 52.11 ± 7.1% | 22666.50 ± 0.4% | 39.42 | 1.00 | 1.14 | 490.42 |
| other: a line's first word, second text | 3716 | 2099.65 ± 1.4% | 542.31 ± 1.1% | 30.49 ± 2.1% | 1880.46 ± 4.6% | 60.33 ± 7.1% | refused | refused | 2063.77 ± 0.6% | 3.87 | 1.02 | 1.12 | 34.80 |
| other: fourteen octets before an x | 87 | 33181.84 ± 2.5% | 284.03 ± 0.5% | 6.04 ± 0.1% | 3510.07 ± 0.2% | 9.26 ± 0.2% | differs | 16.35 ± 0.3% | 32733.14 ± 0.8% | 116.82 | 1.01 | 9.45 | 3584.92 |
| other: a Greek word | 21815 | 424.41 ± 0.5% | 339.01 ± 0.5% | 29.68 ± 1.0% | 262.73 ± 0.9% | 46.05 ± 8.3% | differs | refused | 426.70 ± 0.4% | 1.25 | 0.99 | 1.62 | 9.22 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.38 ± 0.7% | 18.43 ± 0.6% | 0.87 ± 0.4% | 18.67 ± 0.3% | 2.45 ± 0.3% | differs | 4.17 ± 0.5% | 18.15 ± 0.6% | 1.00 | 1.01 | 0.98 | 7.50 |
| a UUID | 32895 | 19.17 ± 0.2% | 19.39 ± 0.3% | 0.59 ± 0.2% | 14.25 ± 0.4% | 2.48 ± 0.3% | 0.53 ± 0.1% | 3.08 ± 0.4% | 19.21 ± 0.9% | 0.99 | 1.00 | 1.35 | 7.72 |
| an IPv4 address | 33176 | 29.33 ± 0.9% | 29.61 ± 1.1% | 1.92 ± 0.6% | 26.33 ± 0.3% | 5.95 ± 0.3% | differs | 3.92 ± 0.3% | 29.52 ± 0.4% | 0.99 | 0.99 | 1.11 | 4.93 |
| a date and time | 32954 | 27.08 ± 0.8% | 26.76 ± 0.4% | 1.37 ± 10.6% | 19.01 ± 0.2% | 7.20 ± 0.7% | 0.93 ± 0.9% | 7.26 ± 0.3% | 27.13 ± 0.5% | 1.01 | 1.00 | 1.42 | 3.76 |
| a field path | 32606 | 20.73 ± 0.8% | 20.71 ± 0.5% | 0.94 ± 0.4% | 21.25 ± 0.3% | 2.84 ± 0.3% | differs | 2.60 ± 0.4% | 20.58 ± 0.2% | 1.00 | 1.01 | 0.98 | 7.30 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.43 ± 0.2% | 8.71 ± 0.9% | 8.61 ± 6.2% | 11.06 ± 1.9% | 4.69 ± 1.0% | 0.75 ± 0.5% | none | 8.48 ± 1.4% | 0.97 | 0.99 | 0.76 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.90 ± 0.9% | 240.02 ± 7.4% | 285.17 ± 0.8% | 85.30 ± 3.5% | 184.20 ± 1.9% | 540.05 ± 2.1% | 3326.43 ± 1.2% | 238.55 ± 0.9% | 1.00 | 1.00 | 2.80 | 1.30 |
| a UUID | 62 | 155.88 ± 0.5% | 156.48 ± 3.3% | 175.89 ± 0.6% | 47.16 ± 0.7% | 87.95 ± 2.5% | 190.85 ± 1.9% | 3886.90 ± 1.5% | 156.29 ± 0.6% | 1.00 | 1.00 | 3.31 | 1.77 |
| an IPv4 address | 29 | 432.63 ± 0.1% | 436.84 ± 0.3% | 617.63 ± 0.6% | 74.63 ± 1.4% | 111.72 ± 2.6% | 329.06 ± 1.8% | 6800.27 ± 1.5% | 432.52 ± 0.2% | 0.99 | 1.00 | 5.80 | 3.87 |
| a date and time | 56 | 331.79 ± 0.2% | 333.48 ± 0.3% | 427.79 ± 1.0% | 71.13 ± 0.5% | 118.95 ± 3.3% | 348.45 ± 3.2% | 4140.68 ± 1.4% | 332.12 ± 0.2% | 0.99 | 1.00 | 4.66 | 2.79 |
| a field path | 39 | 244.79 ± 0.4% | 245.84 ± 0.3% | 292.85 ± 1.0% | 77.47 ± 1.3% | 172.50 ± 2.0% | 548.73 ± 0.4% | 4153.20 ± 1.4% | 244.68 ± 0.4% | 1.00 | 1.00 | 3.16 | 1.42 |
| literal: a word | 7 | 680.39 ± 0.4% | 731.73 ± 0.2% | 1272.29 ± 1.2% | 493.98 ± 0.9% | 541.59 ± 2.5% | 1153.21 ± 4.6% | 27898.75 ± 3.2% | 680.88 ± 0.2% | 0.93 | 1.00 | 1.38 | 1.26 |
| literal: a word that is not there | 8 | 649.93 ± 0.3% | 702.08 ± 0.8% | 1192.03 ± 1.8% | 459.45 ± 6.7% | 512.13 ± 25.3% | 1081.11 ± 1.2% | 26523.16 ± 1.7% | 650.94 ± 0.3% | 0.93 | 1.00 | 1.41 | 1.27 |
| literal: one of four words | 26 | 249.71 ± 7.6% | 412.17 ± 4.2% | 548.62 ± 3.6% | 40.41 ± 0.5% | 207.05 ± 10.2% | 426.07 ± 3.1% | 13174.58 ± 10.4% | 249.66 ± 0.2% | 0.61 | 1.00 | 6.18 | 1.21 |
| literal: a word in any case | 11 | 485.96 ± 0.2% | 523.44 ± 0.6% | 759.32 ± 0.3% | 13.73 ± 3.0% | 566.81 ± 2.4% | refused | 20602.98 ± 2.1% | 486.37 ± 0.5% | 0.93 | 1.00 | 35.40 | 0.86 |
| literal: an href attribute | 12 | 338.23 ± 2.4% | 350.81 ± 5.4% | 460.93 ± 3.7% | 37.28 ± 4.9% | 414.40 ± 4.9% | 923.99 ± 0.8% | 19298.58 ± 1.4% | 338.52 ± 0.4% | 0.96 | 1.00 | 9.07 | 0.82 |
| literal: a word, second text | 10 | 599.27 ± 2.7% | 659.88 ± 0.5% | 1076.96 ± 1.0% | 412.62 ± 1.2% | 446.15 ± 12.5% | 964.39 ± 7.8% | 23979.79 ± 2.2% | 599.41 ± 10.8% | 0.91 | 1.00 | 1.45 | 1.34 |
| class: two capitalized words | 23 | 477.62 ± 0.3% | 512.66 ± 0.3% | 768.93 ± 0.1% | 100.27 ± 1.7% | 426.69 ± 2.8% | 881.26 ± 1.2% | 6027.00 ± 0.5% | 478.17 ± 0.1% | 0.93 | 1.00 | 4.76 | 1.12 |
| class: a word that ends in ing | 9 | 588.19 ± 0.2% | 685.13 ± 0.2% | 1231.15 ± 0.3% | 127.57 ± 1.1% | 618.61 ± 2.0% | 1303.47 ± 1.6% | 14731.79 ± 0.4% | 587.94 ± 0.2% | 0.86 | 1.00 | 4.61 | 0.95 |
| class: a word in capitals | 16 | 545.68 ± 0.1% | 590.84 ± 0.7% | 1011.99 ± 2.3% | 133.81 ± 3.7% | 620.59 ± 9.0% | 1175.78 ± 9.3% | 7992.28 ± 0.4% | 544.86 ± 0.3% | 0.92 | 1.00 | 4.08 | 0.88 |
| class: a number | 6 | 677.86 ± 5.5% | 757.88 ± 0.2% | 1481.38 ± 6.8% | 35.28 ± 0.5% | 1148.33 ± 1.5% | 2217.84 ± 1.7% | 20297.03 ± 13.3% | 677.26 ± 0.2% | 0.89 | 1.00 | 19.21 | 0.59 |
| class: two capitalized words, second text | 23 | 478.15 ± 0.5% | 512.66 ± 8.4% | 769.34 ± 0.3% | 100.51 ± 5.5% | 428.81 ± 12.0% | 905.56 ± 1.3% | 6039.95 ± 6.6% | 477.59 ± 0.3% | 0.93 | 1.00 | 4.76 | 1.12 |
| other: a word between two words | 13 | 578.97 ± 0.2% | 604.35 ± 0.7% | 975.05 ± 0.4% | 135.20 ± 1.1% | 422.04 ± 2.1% | 966.43 ± 0.3% | 13287.56 ± 1.5% | 578.12 ± 0.3% | 0.96 | 1.00 | 4.28 | 1.37 |
| other: a number before a unit, second text | 15 | 431.18 ± 2.0% | 493.09 ± 0.8% | 720.52 ± 13.0% | 33.25 ± 0.8% | 521.36 ± 10.8% | 1072.05 ± 0.8% | 13060.41 ± 0.4% | 432.13 ± 1.1% | 0.87 | 1.00 | 12.97 | 0.83 |
| other: a heading's start tag | 13 | 354.14 ± 0.2% | 362.95 ± 0.7% | 479.33 ± 0.4% | 36.11 ± 1.0% | 520.60 ± 16.5% | 1016.96 ± 0.8% | 16016.46 ± 1.1% | 353.65 ± 0.3% | 0.98 | 1.00 | 9.81 | 0.68 |
| other: a whole word | 11 | 598.10 ± 1.2% | 641.83 ± 0.4% | 1043.57 ± 0.4% | 119.08 ± 0.4% | 475.74 ± 1.8% | 983.39 ± 1.4% | 23757.82 ± 2.8% | 598.46 ± 2.8% | 0.93 | 1.00 | 5.02 | 1.26 |
| other: a line's first word, second text | 17 | 557.97 ± 6.5% | 599.31 ± 0.3% | 987.99 ± 0.5% | 128.40 ± 0.2% | 580.58 ± 5.5% | refused | refused | 555.54 ± 2.5% | 0.93 | 1.00 | 4.35 | 0.96 |
| other: fourteen octets before an x | 16 | 91.58 ± 0.5% | 142.93 ± 0.3% | 165.38 ± 1.2% | 15.08 ± 0.5% | 375.14 ± 1.7% | 455.13 ± 0.8% | 12045.93 ± 0.3% | 91.36 ± 5.6% | 0.64 | 1.00 | 6.07 | 0.24 |
| other: a Greek word | 8 | 443.53 ± 6.8% | 623.83 ± 2.4% | 1043.90 ± 6.8% | 45.54 ± 4.0% | 1124.14 ± 1.5% | 2152.61 ± 1.0% | refused | 443.65 ± 0.6% | 0.71 | 1.00 | 9.74 | 0.39 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 24920.48 ± 0.7% | not timed | not timed | 22282.62 ± 9.2% | 2009.72 ± 12.6% | not timed | not timed | 24153.35 ± 0.4% | | 1.03 | 1.12 | 12.40 |
| 01-literal/sherlock-casei-en | 522 | 8301.27 ± 2.8% | not timed | not timed | 6713.98 ± 7.6% | 29.07 ± 12.8% | not timed | not timed | 8164.50 ± 1.7% | | 1.02 | 1.24 | 285.60 |
| 01-literal/sherlock-ru | 724 | 22952.45 ± 0.7% | not timed | not timed | 20948.82 ± 0.7% | 1163.47 ± 9.6% | not timed | not timed | 22550.38 ± 0.4% | | 1.02 | 1.10 | 19.73 |
| 01-literal/sherlock-casei-ru | 746 | 9494.52 ± 0.8% | not timed | not timed | 5507.35 ± 0.8% | 32.08 ± 3.2% | not timed | not timed | 9385.78 ± 0.4% | | 1.01 | 1.72 | 295.92 |
| 01-literal/sherlock-zh | 30 | 36237.26 ± 0.2% | not timed | not timed | 27852.87 ± 0.2% | 1101.21 ± 0.2% | not timed | not timed | 36171.64 ± 0.9% | | 1.00 | 1.30 | 32.91 |
| 02-literal-alternate/sherlock-en | 714 | 10188.04 ± 0.8% | not timed | not timed | 7702.79 ± 0.4% | 16.21 ± 0.7% | not timed | not timed | 10087.49 ± 1.4% | | 1.01 | 1.32 | 628.35 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1934.96 ± 0.5% | not timed | not timed | 2061.43 ± 0.2% | 9.87 ± 0.3% | not timed | not timed | 1930.70 ± 0.7% | | 1.00 | 0.94 | 196.00 |
| 02-literal-alternate/sherlock-ru | 899 | 8217.57 ± 7.3% | not timed | not timed | 4416.79 ± 2.5% | 21.62 ± 9.0% | not timed | not timed | 8105.95 ± 0.5% | | 1.01 | 1.86 | 380.16 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2086.16 ± 0.5% | not timed | not timed | 1077.97 ± 0.3% | 8.79 ± 0.3% | not timed | not timed | 2064.06 ± 0.9% | | 1.01 | 1.94 | 237.22 |
| 02-literal-alternate/sherlock-zh | 207 | 14092.52 ± 0.1% | not timed | not timed | 8865.26 ± 0.7% | 30.57 ± 0.8% | not timed | not timed | 14041.98 ± 0.4% | | 1.00 | 1.59 | 460.95 |
| 03-date/ascii | 111817 | 106.45 ± 0.2% | not timed | not timed | 90.91 ± 0.4% | 0.17 ± 2.2% | not timed | not timed | 104.02 ± 1.3% | | 1.02 | 1.17 | 626.66 |
| 04-ruff-noqa/real | 84 | 464.04 ± 0.7% | not timed | not timed | 445.42 ± 0.4% | 17.33 ± 0.5% | not timed | not timed | 454.46 ± 0.6% | | 1.02 | 1.04 | 26.78 |
| 04-ruff-noqa/tweaked | 44 | 516.92 ± 0.3% | not timed | not timed | 444.09 ± 0.3% | 301.71 ± 11.4% | not timed | not timed | 517.39 ± 0.9% | | 1.00 | 1.16 | 1.71 |
| 05-lexer-veryl/single | 124800 | 4.57 ± 2.6% | not timed | not timed | 4.57 ± 0.2% | 0.20 ± 1.6% | not timed | not timed | 4.43 ± 3.3% | | 1.03 | 1.00 | 22.32 |
| 06-cloud-flare-redos/original | 107 | 371.50 ± 0.8% | not timed | not timed | 198.21 ± 0.7% | 21.28 ± 1.1% | not timed | not timed | 370.92 ± 0.5% | | 1.00 | 1.87 | 17.46 |
| 06-cloud-flare-redos/simplified-short | 102 | 359.70 ± 0.3% | not timed | not timed | 208.02 ± 0.6% | 23.92 ± 0.7% | not timed | not timed | 358.75 ± 0.4% | | 1.00 | 1.73 | 15.03 |
| 06-cloud-flare-redos/simplified-long | 10000 | 484.04 ± 0.2% | not timed | not timed | 229.96 ± 0.5% | 27.72 ± 0.3% | not timed | not timed | 483.80 ± 0.3% | | 1.00 | 2.10 | 17.46 |
| 07-unicode-character-data/parse-line | 558784 | 201.30 ± 27.1% | not timed | not timed | 160.32 ± 0.6% | 36.88 ± 8.5% | not timed | not timed | 198.35 ± 2.1% | | 1.01 | 1.26 | 5.46 |
| 08-words/all-english | 56691 | 97.56 ± 9.2% | not timed | not timed | 74.35 ± 1.1% | 10.51 ± 16.1% | not timed | not timed | 96.10 ± 9.8% | | 1.02 | 1.31 | 9.29 |
| 08-words/long-english | 839 | 579.12 ± 0.2% | not timed | not timed | 553.57 ± 0.6% | 28.54 ± 14.2% | not timed | not timed | 578.14 ± 0.3% | | 1.00 | 1.05 | 20.29 |
| 09-aws-keys/full | 0 | 481.84 ± 0.7% | not timed | not timed | 457.92 ± 0.5% | 55.34 ± 1.8% | not timed | not timed | 475.73 ± 0.9% | | 1.01 | 1.05 | 8.71 |
| 09-aws-keys/quick | 0 | 940.99 ± 0.9% | not timed | not timed | 799.56 ± 1.1% | 337.72 ± 13.5% | not timed | not timed | 925.23 ± 0.5% | | 1.02 | 1.18 | 2.79 |
| 10-bounded-repeat/letters-en | 1833 | 556.06 ± 1.3% | not timed | not timed | 479.59 ± 0.4% | 18.70 ± 0.6% | not timed | not timed | 550.21 ± 1.7% | | 1.01 | 1.16 | 29.73 |
| 10-bounded-repeat/letters-ru | 3475 | 484.37 ± 3.9% | not timed | not timed | 433.06 ± 0.7% | 20.23 ± 17.7% | not timed | not timed | 481.19 ± 0.4% | | 1.01 | 1.12 | 23.94 |
| 10-bounded-repeat/context | 53 | 69.15 ± 2.4% | not timed | not timed | 59.68 ± 6.2% | 18.42 ± 2.3% | not timed | not timed | 70.66 ± 6.5% | | 0.98 | 1.16 | 3.75 |
| 10-bounded-repeat/capitals | 11 | 600.35 ± 6.9% | not timed | not timed | 576.27 ± 0.1% | 33.34 ± 0.4% | not timed | not timed | 600.18 ± 6.9% | | 1.00 | 1.04 | 18.01 |
| 11-unstructured-to-json/extract | 600 | 61.41 ± 0.3% | not timed | not timed | 69.78 ± 0.4% | 44.76 ± 1.8% | not timed | not timed | 60.74 ± 1.1% | | 1.01 | 0.88 | 1.37 |
| 12-dictionary/single | 1 | 524.34 ± 0.5% | not timed | not timed | 503.79 ± 0.3% | 0.27 ± 0.8% | not timed | not timed | 524.55 ± 0.2% | | 1.00 | 1.04 | 1968.37 |
| 14-quadratic/1x | 100 | 20.75 ± 7.7% | not timed | not timed | 11.83 ± 0.2% | 0.88 ± 18.9% | not timed | not timed | 20.69 ± 4.1% | | 1.00 | 1.75 | 23.48 |
| 14-quadratic/2x | 200 | 16.36 ± 0.3% | not timed | not timed | 5.92 ± 0.3% | 0.49 ± 0.5% | not timed | not timed | 16.32 ± 0.6% | | 1.00 | 2.76 | 33.22 |
| 14-quadratic/10x | 1000 | 5.77 ± 0.5% | not timed | not timed | 1.16 ± 0.4% | 0.11 ± 2.0% | not timed | not timed | 5.77 ± 0.5% | | 1.00 | 4.96 | 52.47 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.23 ± 0.4% | not timed | not timed | 0.35 ± 0.4% | 0.49 ± 5.4% | not timed | not timed | 1.22 ± 2.5% | | 1.01 | 3.58 | 2.50 |
| 04-ruff-noqa/compile-real | 1 | 100.75 ± 0.4% | not timed | not timed | 12.22 ± 0.8% | 123.11 ± 2.1% | not timed | not timed | 101.76 ± 1.0% | | 0.99 | 8.25 | 0.82 |
| 05-lexer-veryl/compile-single | 1 | 14.12 ± 0.9% | not timed | not timed | 2.40 ± 1.9% | 5.84 ± 2.5% | not timed | not timed | 14.11 ± 1.0% | | 1.00 | 5.89 | 2.42 |
| 07-unicode-character-data/compile | 1 | 56.35 ± 0.6% | not timed | not timed | 25.20 ± 1.1% | 32.36 ± 0.7% | not timed | not timed | 56.23 ± 0.9% | | 1.00 | 2.24 | 1.74 |
| 09-aws-keys/compile-full | 1 | 36.45 ± 0.5% | not timed | not timed | 7.21 ± 0.8% | 20.24 ± 3.5% | not timed | not timed | 36.34 ± 1.6% | | 1.00 | 5.06 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 170.10 ± 0.3% | not timed | not timed | 46.74 ± 0.4% | 116.35 ± 2.4% | not timed | not timed | 173.15 ± 8.1% | | 0.98 | 3.64 | 1.46 |
| 10-bounded-repeat/compile-context | 1 | 11.76 ± 0.2% | not timed | not timed | 11.34 ± 0.4% | 14.46 ± 1.8% | not timed | not timed | 11.72 ± 1.3% | | 1.00 | 1.04 | 0.81 |
| 10-bounded-repeat/compile-capitals | 1 | 70.62 ± 0.2% | not timed | not timed | 8.48 ± 0.7% | 21.40 ± 1.5% | not timed | not timed | 70.34 ± 1.8% | | 1.00 | 8.33 | 3.30 |
| 11-unstructured-to-json/compile | 1 | 84.32 ± 0.3% | not timed | not timed | 36.97 ± 1.6% | 61.22 ± 4.5% | not timed | not timed | 84.23 ± 1.0% | | 1.00 | 2.28 | 1.38 |
| 12-dictionary/compile-single | 1 | 0.29 ± 2.3% | not timed | not timed | 0.06 ± 28.4% | 0.08 ± 25.3% | not timed | not timed | 0.28 ± 2.7% | | 1.00 | 4.48 | 3.44 |

