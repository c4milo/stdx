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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507025939 |
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
| literal: a word | 217 | 19446.61 ± 2.8% | 5077.14 ± 0.3% | 28.28 ± 0.3% | 18179.75 ± 1.4% | 9159.83 ± 7.9% | 17.35 ± 0.2% | 86.11 ± 1.1% | 19489.96 ± 1.3% | 3.83 | 1.00 | 1.07 | 2.12 |
| literal: a word that is not there | 0 | 21381.40 ± 2.6% | 4934.04 ± 0.4% | 28.21 ± 0.3% | 19537.89 ± 3.2% | 29038.87 ± 1.1% | 17.11 ± 0.1% | 82.17 ± 0.2% | 21657.67 ± 2.2% | 4.33 | 0.99 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6400.12 ± 0.7% | 1978.04 ± 0.3% | 14.33 ± 0.1% | 3947.03 ± 0.1% | 21.87 ± 0.1% | 5.46 ± 0.2% | 6.78 ± 0.3% | 6416.51 ± 0.4% | 3.24 | 1.00 | 1.62 | 292.66 |
| literal: a word in any case | 217 | 15137.20 ± 0.2% | 2097.90 ± 0.3% | 21.46 ± 0.3% | 3968.64 ± 0.2% | 38.06 ± 0.3% | refused | differs | 15144.07 ± 0.8% | 7.22 | 1.00 | 3.81 | 397.75 |
| literal: an href attribute | 33 | 16679.75 ± 1.5% | 617.56 ± 0.2% | 27.27 ± 0.4% | 16856.56 ± 1.8% | 2256.57 ± 0.3% | 13.11 ± 0.2% | 75.17 ± 0.4% | 16801.47 ± 1.3% | 27.01 | 0.99 | 0.99 | 7.39 |
| literal: a word, second text | 123 | 19543.27 ± 0.7% | 3420.06 ± 0.2% | 28.01 ± 0.4% | 18318.09 ± 2.2% | 7724.39 ± 4.3% | 20.08 ± 0.2% | 69.73 ± 0.3% | 19532.25 ± 1.4% | 5.71 | 1.00 | 1.07 | 2.53 |
| class: two capitalized words | 1331 | 1064.28 ± 0.5% | 609.23 ± 0.1% | 26.01 ± 0.2% | 585.32 ± 0.1% | 40.61 ± 2.2% | 14.76 ± 0.3% | 68.21 ± 0.7% | 1062.51 ± 0.5% | 1.75 | 1.00 | 1.82 | 26.21 |
| class: a word that ends in ing | 3399 | 583.00 ± 0.3% | 582.92 ± 0.2% | 17.97 ± 0.2% | 548.02 ± 0.1% | 29.65 ± 6.2% | 8.21 ± 0.2% | 18.24 ± 0.1% | 583.80 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.66 |
| class: a word in capitals | 2332 | 1388.65 ± 0.4% | 614.32 ± 0.1% | 27.62 ± 0.4% | 572.40 ± 0.1% | 43.54 ± 6.8% | 17.14 ± 0.2% | 82.95 ± 0.5% | 1388.10 ± 0.3% | 2.26 | 1.00 | 2.43 | 31.89 |
| class: a number | 8288 | 2128.26 ± 0.2% | 852.16 ± 0.1% | 27.67 ± 0.5% | 1720.58 ± 0.2% | 42.35 ± 16.6% | 0.55 ± 0.4% | 57.01 ± 0.2% | 2131.27 ± 0.5% | 2.50 | 1.00 | 1.24 | 50.26 |
| class: two capitalized words, second text | 5359 | 525.12 ± 0.1% | 534.61 ± 0.1% | 23.35 ± 0.1% | 483.58 ± 0.1% | 32.69 ± 14.5% | 17.05 ± 0.4% | 63.46 ± 0.7% | 525.19 ± 0.2% | 0.98 | 1.00 | 1.09 | 16.06 |
| other: a word between two words | 6104 | 807.34 ± 0.1% | 609.13 ± 0.2% | 23.50 ± 0.1% | 738.89 ± 0.1% | 108.45 ± 20.4% | 11.15 ± 0.2% | 69.22 ± 0.8% | 807.38 ± 0.1% | 1.33 | 1.00 | 1.09 | 7.44 |
| other: a number before a unit, second text | 1481 | 6171.77 ± 0.9% | 1129.01 ± 0.3% | 25.92 ± 0.2% | 5634.39 ± 0.4% | 40.77 ± 0.1% | 18.11 ± 0.1% | 66.87 ± 0.2% | 6157.60 ± 1.2% | 5.47 | 1.00 | 1.10 | 151.39 |
| other: a heading's start tag | 110 | 14135.18 ± 0.8% | 749.95 ± 0.1% | 27.32 ± 0.4% | 1707.63 ± 0.4% | 1583.09 ± 2.4% | 16.08 ± 0.2% | 88.39 ± 0.2% | 14193.26 ± 0.8% | 18.85 | 1.00 | 8.28 | 8.93 |
| other: a whole word | 217 | 16060.26 ± 0.5% | 608.86 ± 0.2% | 29.36 ± 0.2% | 14446.82 ± 1.3% | 48.03 ± 0.3% | 13.25 ± 0.2% | 55.86 ± 0.1% | 16179.11 ± 0.9% | 26.38 | 0.99 | 1.11 | 334.36 |
| other: a line's first word, second text | 3716 | 2108.67 ± 0.8% | 600.11 ± 0.2% | 30.63 ± 0.4% | 1721.14 ± 0.4% | 62.13 ± 6.8% | refused | refused | 2112.62 ± 1.0% | 3.51 | 1.00 | 1.23 | 33.94 |
| other: fourteen octets before an x | 87 | 23791.65 ± 2.9% | 219.44 ± 0.5% | 6.54 ± 0.1% | 3999.16 ± 0.9% | 10.63 ± 0.3% | differs | 17.56 ± 0.1% | 23743.57 ± 5.8% | 108.42 | 1.00 | 5.95 | 2238.06 |
| other: a Greek word | 21815 | 521.15 ± 0.3% | 425.48 ± 0.1% | 30.74 ± 0.3% | 289.94 ± 0.2% | 49.40 ± 12.5% | differs | refused | 521.53 ± 0.4% | 1.22 | 1.00 | 1.80 | 10.55 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.30 ± 0.2% | 29.22 ± 0.3% | 0.86 ± 0.2% | 19.87 ± 0.4% | 2.78 ± 0.7% | differs | 4.02 ± 0.3% | 29.29 ± 0.3% | 1.00 | 1.00 | 1.48 | 10.55 |
| a UUID | 32895 | 24.70 ± 0.1% | 24.65 ± 0.2% | 0.64 ± 0.4% | 15.17 ± 0.4% | 3.10 ± 0.8% | 0.72 ± 0.3% | 3.62 ± 0.9% | 24.74 ± 0.2% | 1.00 | 1.00 | 1.63 | 7.97 |
| an IPv4 address | 33176 | 38.43 ± 0.7% | 38.52 ± 0.4% | 2.07 ± 0.3% | 29.35 ± 0.3% | 6.67 ± 0.2% | differs | 4.17 ± 0.1% | 38.53 ± 0.2% | 1.00 | 1.00 | 1.31 | 5.76 |
| a date and time | 32954 | 34.44 ± 0.2% | 34.22 ± 0.3% | 1.45 ± 0.1% | 21.58 ± 0.2% | 7.04 ± 0.1% | 1.24 ± 0.2% | 7.14 ± 0.2% | 34.33 ± 0.1% | 1.01 | 1.00 | 1.60 | 4.89 |
| a field path | 32606 | 32.52 ± 0.2% | 32.57 ± 0.2% | 1.01 ± 0.6% | 23.31 ± 0.3% | 3.51 ± 0.5% | differs | 2.93 ± 0.1% | 32.56 ± 0.1% | 1.00 | 1.00 | 1.40 | 9.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.11 ± 0.3% | 11.11 ± 0.3% | 11.10 ± 0.3% | 11.62 ± 0.1% | 4.94 ± 0.9% | 0.93 ± 0.2% | none | 11.12 ± 0.4% | 1.00 | 1.00 | 0.96 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.11 ± 0.6% | 229.47 ± 0.2% | 271.83 ± 0.1% | 86.89 ± 0.7% | 221.20 ± 1.9% | 482.76 ± 0.1% | 3740.11 ± 3.4% | 229.11 ± 0.2% | 1.00 | 1.00 | 2.64 | 1.04 |
| a UUID | 62 | 150.32 ± 0.1% | 150.52 ± 0.2% | 168.32 ± 0.1% | 45.98 ± 0.8% | 98.53 ± 0.5% | 187.82 ± 2.3% | 4484.21 ± 0.4% | 150.36 ± 0.3% | 1.00 | 1.00 | 3.27 | 1.53 |
| an IPv4 address | 29 | 417.81 ± 0.4% | 418.48 ± 0.4% | 585.31 ± 0.3% | 79.55 ± 0.6% | 131.54 ± 1.6% | 307.68 ± 1.1% | 7663.63 ± 0.3% | 417.27 ± 0.2% | 1.00 | 1.00 | 5.25 | 3.18 |
| a date and time | 56 | 301.22 ± 0.2% | 301.40 ± 0.2% | 379.99 ± 0.0% | 73.30 ± 0.2% | 136.38 ± 1.2% | 327.32 ± 2.3% | 4968.35 ± 0.3% | 301.27 ± 0.2% | 1.00 | 1.00 | 4.11 | 2.21 |
| a field path | 39 | 223.20 ± 0.1% | 223.36 ± 0.2% | 264.10 ± 0.3% | 79.46 ± 0.3% | 206.07 ± 1.1% | 496.99 ± 1.9% | 4856.61 ± 0.6% | 223.23 ± 0.2% | 1.00 | 1.00 | 2.81 | 1.08 |
| literal: a word | 7 | 606.31 ± 0.5% | 658.46 ± 0.7% | 1182.74 ± 0.7% | 502.36 ± 0.1% | 623.87 ± 8.0% | 959.11 ± 0.4% | 30834.53 ± 0.2% | 607.04 ± 0.6% | 0.92 | 1.00 | 1.21 | 0.97 |
| literal: a word that is not there | 8 | 584.99 ± 0.4% | 635.54 ± 0.4% | 1119.31 ± 0.7% | 458.61 ± 0.4% | 599.12 ± 2.0% | 905.70 ± 0.4% | 29390.16 ± 0.1% | 584.41 ± 0.5% | 0.92 | 1.00 | 1.28 | 0.98 |
| literal: one of four words | 26 | 238.78 ± 0.3% | 388.28 ± 0.4% | 530.66 ± 0.2% | 50.89 ± 0.2% | 241.41 ± 3.0% | 375.08 ± 0.3% | 15758.75 ± 0.1% | 238.81 ± 0.2% | 0.61 | 1.00 | 4.69 | 0.99 |
| literal: a word in any case | 11 | 440.60 ± 0.3% | 470.87 ± 0.4% | 693.16 ± 0.2% | 15.68 ± 0.4% | 650.27 ± 1.7% | refused | 23587.76 ± 0.6% | 440.91 ± 0.2% | 0.94 | 1.00 | 28.10 | 0.68 |
| literal: an href attribute | 12 | 337.10 ± 0.3% | 350.79 ± 0.5% | 460.78 ± 0.5% | 45.31 ± 0.6% | 491.64 ± 6.5% | 767.34 ± 0.7% | 22228.09 ± 0.4% | 336.56 ± 0.4% | 0.96 | 1.00 | 7.44 | 0.69 |
| literal: a word, second text | 10 | 540.98 ± 0.6% | 598.43 ± 0.6% | 1007.20 ± 0.7% | 405.44 ± 0.4% | 535.65 ± 1.5% | 793.37 ± 0.5% | 27244.48 ± 0.2% | 541.17 ± 0.3% | 0.90 | 1.00 | 1.33 | 1.01 |
| class: two capitalized words | 23 | 428.18 ± 0.5% | 455.93 ± 0.6% | 660.55 ± 1.4% | 101.96 ± 0.3% | 500.83 ± 0.9% | 743.87 ± 0.5% | 6375.12 ± 0.1% | 427.88 ± 0.2% | 0.94 | 1.00 | 4.20 | 0.85 |
| class: a word that ends in ing | 9 | 543.48 ± 0.4% | 614.77 ± 0.4% | 1078.18 ± 0.2% | 133.23 ± 0.2% | 757.40 ± 1.4% | 1101.78 ± 0.6% | 15939.83 ± 0.1% | 543.03 ± 0.2% | 0.88 | 1.00 | 4.08 | 0.72 |
| class: a word in capitals | 16 | 486.52 ± 0.4% | 523.91 ± 0.4% | 830.88 ± 0.2% | 136.14 ± 1.9% | 748.91 ± 0.9% | 1024.97 ± 0.6% | 8383.42 ± 0.1% | 485.27 ± 0.3% | 0.93 | 1.00 | 3.57 | 0.65 |
| class: a number | 6 | 614.36 ± 0.5% | 673.12 ± 0.4% | 1251.52 ± 0.2% | 41.95 ± 0.3% | 1397.34 ± 1.1% | 1857.84 ± 0.7% | 22916.22 ± 0.1% | 613.97 ± 0.4% | 0.91 | 1.00 | 14.65 | 0.44 |
| class: two capitalized words, second text | 23 | 428.96 ± 0.3% | 457.92 ± 0.6% | 661.12 ± 0.5% | 101.35 ± 2.4% | 502.81 ± 1.5% | 759.80 ± 0.5% | 6377.45 ± 0.1% | 427.81 ± 0.4% | 0.94 | 1.00 | 4.23 | 0.85 |
| other: a word between two words | 13 | 527.50 ± 0.6% | 548.91 ± 0.4% | 877.20 ± 0.3% | 132.41 ± 0.4% | 501.87 ± 1.4% | 811.41 ± 0.8% | 14789.04 ± 0.1% | 527.67 ± 0.5% | 0.96 | 1.00 | 3.98 | 1.05 |
| other: a number before a unit, second text | 15 | 390.63 ± 0.4% | 434.39 ± 0.1% | 613.30 ± 0.1% | 39.41 ± 0.6% | 632.80 ± 0.8% | 889.75 ± 0.8% | 15416.22 ± 0.3% | 390.62 ± 0.2% | 0.90 | 1.00 | 9.91 | 0.62 |
| other: a heading's start tag | 13 | 349.11 ± 0.4% | 356.72 ± 0.2% | 470.83 ± 0.4% | 43.93 ± 0.2% | 627.25 ± 0.7% | 859.23 ± 0.0% | 18415.47 ± 0.1% | 349.33 ± 0.5% | 0.98 | 1.00 | 7.95 | 0.56 |
| other: a whole word | 11 | 561.97 ± 0.5% | 599.98 ± 0.7% | 1013.65 ± 0.3% | 118.72 ± 0.4% | 564.63 ± 1.4% | 822.12 ± 0.5% | 26868.79 ± 1.1% | 561.85 ± 0.6% | 0.94 | 1.00 | 4.73 | 1.00 |
| other: a line's first word, second text | 17 | 508.53 ± 0.7% | 541.54 ± 0.5% | 870.62 ± 0.6% | 129.48 ± 0.1% | 706.12 ± 1.1% | refused | refused | 510.26 ± 0.7% | 0.94 | 1.00 | 3.93 | 0.72 |
| other: fourteen octets before an x | 16 | 106.81 ± 2.0% | 152.28 ± 0.7% | 175.79 ± 0.3% | 15.26 ± 0.8% | 451.26 ± 2.0% | 413.88 ± 0.7% | 12798.92 ± 0.3% | 106.62 ± 0.4% | 0.70 | 1.00 | 7.00 | 0.24 |
| other: a Greek word | 8 | 426.24 ± 0.2% | 584.07 ± 0.4% | 987.63 ± 0.2% | 58.93 ± 0.1% | 1388.69 ± 0.7% | 1825.10 ± 0.6% | refused | 426.38 ± 0.2% | 0.73 | 1.00 | 7.23 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15643.82 ± 1.8% | not timed | not timed | 16165.37 ± 2.3% | 2116.31 ± 6.6% | not timed | not timed | 15571.59 ± 1.0% | | 1.00 | 0.97 | 7.39 |
| 01-literal/sherlock-casei-en | 522 | 11010.26 ± 7.7% | not timed | not timed | 3594.07 ± 0.3% | 32.56 ± 0.3% | not timed | not timed | 11012.69 ± 1.9% | | 1.00 | 3.06 | 338.13 |
| 01-literal/sherlock-ru | 724 | 17184.00 ± 1.6% | not timed | not timed | 17274.32 ± 2.0% | 1489.56 ± 7.4% | not timed | not timed | 17207.77 ± 1.2% | | 1.00 | 0.99 | 11.54 |
| 01-literal/sherlock-casei-ru | 746 | 6141.87 ± 0.6% | not timed | not timed | 3327.19 ± 0.1% | 31.64 ± 8.8% | not timed | not timed | 6135.87 ± 0.1% | | 1.00 | 1.85 | 194.10 |
| 01-literal/sherlock-zh | 30 | 19517.13 ± 0.1% | not timed | not timed | 18496.35 ± 1.6% | 2669.92 ± 10.1% | not timed | not timed | 19533.92 ± 0.7% | | 1.00 | 1.06 | 7.31 |
| 02-literal-alternate/sherlock-en | 714 | 6144.02 ± 0.3% | not timed | not timed | 3930.31 ± 0.3% | 16.62 ± 6.3% | not timed | not timed | 6151.91 ± 0.8% | | 1.00 | 1.56 | 369.65 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1970.02 ± 0.8% | not timed | not timed | 696.06 ± 0.4% | 11.12 ± 0.3% | not timed | not timed | 1973.90 ± 0.8% | | 1.00 | 2.83 | 177.16 |
| 02-literal-alternate/sherlock-ru | 899 | 5535.27 ± 0.1% | not timed | not timed | 3249.96 ± 0.2% | 22.33 ± 0.1% | not timed | not timed | 5528.01 ± 0.1% | | 1.00 | 1.70 | 247.89 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.24 ± 0.9% | not timed | not timed | 1226.98 ± 0.3% | 8.94 ± 2.4% | not timed | not timed | 2055.85 ± 0.3% | | 1.00 | 1.68 | 229.98 |
| 02-literal-alternate/sherlock-zh | 207 | 7348.99 ± 0.5% | not timed | not timed | 4160.67 ± 0.1% | 31.45 ± 0.0% | not timed | not timed | 7351.06 ± 0.3% | | 1.00 | 1.77 | 233.65 |
| 03-date/ascii | 111817 | 133.37 ± 0.5% | not timed | not timed | 96.11 ± 0.2% | 0.20 ± 2.5% | not timed | not timed | 134.22 ± 0.7% | | 0.99 | 1.39 | 663.48 |
| 04-ruff-noqa/real | 84 | 435.47 ± 0.1% | not timed | not timed | 464.86 ± 0.1% | 18.63 ± 1.3% | not timed | not timed | 435.70 ± 0.1% | | 1.00 | 0.94 | 23.37 |
| 04-ruff-noqa/tweaked | 44 | 591.13 ± 0.2% | not timed | not timed | 467.36 ± 0.2% | 365.81 ± 0.3% | not timed | not timed | 593.17 ± 0.2% | | 1.00 | 1.26 | 1.62 |
| 05-lexer-veryl/single | 124800 | 5.18 ± 2.9% | not timed | not timed | 5.21 ± 0.5% | 0.20 ± 2.6% | not timed | not timed | 5.21 ± 0.5% | | 0.99 | 0.99 | 25.33 |
| 06-cloud-flare-redos/original | 107 | 425.74 ± 0.4% | not timed | not timed | 215.41 ± 0.1% | 24.95 ± 0.2% | not timed | not timed | 427.07 ± 0.1% | | 1.00 | 1.98 | 17.06 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.45 ± 0.2% | not timed | not timed | 229.57 ± 0.1% | 26.70 ± 0.2% | not timed | not timed | 429.58 ± 0.2% | | 1.00 | 1.88 | 16.16 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.57 ± 0.1% | not timed | not timed | 256.57 ± 0.2% | 28.76 ± 0.1% | not timed | not timed | 588.78 ± 0.1% | | 1.00 | 2.29 | 20.47 |
| 07-unicode-character-data/parse-line | 558784 | 236.56 ± 1.8% | not timed | not timed | 177.76 ± 0.3% | 42.96 ± 5.5% | not timed | not timed | 240.04 ± 2.1% | | 0.99 | 1.33 | 5.51 |
| 08-words/all-english | 56691 | 127.43 ± 0.7% | not timed | not timed | 83.14 ± 0.1% | 11.91 ± 2.8% | not timed | not timed | 127.69 ± 0.6% | | 1.00 | 1.53 | 10.70 |
| 08-words/long-english | 839 | 620.90 ± 0.2% | not timed | not timed | 595.50 ± 0.2% | 32.37 ± 0.4% | not timed | not timed | 623.55 ± 0.1% | | 1.00 | 1.04 | 19.18 |
| 09-aws-keys/full | 0 | 440.96 ± 0.2% | not timed | not timed | 494.07 ± 0.2% | 64.22 ± 0.3% | not timed | not timed | 439.35 ± 0.0% | | 1.00 | 0.89 | 6.87 |
| 09-aws-keys/quick | 0 | 876.09 ± 0.2% | not timed | not timed | 1001.31 ± 0.1% | 418.95 ± 1.6% | not timed | not timed | 876.36 ± 0.4% | | 1.00 | 0.87 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 572.43 ± 3.4% | not timed | not timed | 516.01 ± 0.4% | 19.50 ± 0.5% | not timed | not timed | 579.57 ± 1.2% | | 0.99 | 1.11 | 29.36 |
| 10-bounded-repeat/letters-ru | 3475 | 506.43 ± 0.9% | not timed | not timed | 477.00 ± 0.1% | 22.76 ± 18.8% | not timed | not timed | 507.88 ± 1.0% | | 1.00 | 1.06 | 22.25 |
| 10-bounded-repeat/context | 53 | 84.98 ± 1.7% | not timed | not timed | 66.19 ± 0.5% | 19.66 ± 0.2% | not timed | not timed | 85.21 ± 1.8% | | 1.00 | 1.28 | 4.32 |
| 10-bounded-repeat/capitals | 11 | 632.33 ± 8.3% | not timed | not timed | 615.74 ± 0.1% | 36.40 ± 0.1% | not timed | not timed | 633.91 ± 8.1% | | 1.00 | 1.03 | 17.37 |
| 11-unstructured-to-json/extract | 600 | 57.32 ± 0.5% | not timed | not timed | 76.27 ± 0.3% | 48.71 ± 0.9% | not timed | not timed | 57.25 ± 0.5% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 560.90 ± 1.0% | not timed | not timed | 560.81 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 561.20 ± 0.9% | | 1.00 | 1.00 | 1393.68 |
| 14-quadratic/1x | 100 | 21.10 ± 1.4% | not timed | not timed | 10.08 ± 0.2% | 0.96 ± 2.8% | not timed | not timed | 21.18 ± 2.0% | | 1.00 | 2.09 | 21.89 |
| 14-quadratic/2x | 200 | 17.56 ± 2.6% | not timed | not timed | 5.56 ± 0.2% | 0.53 ± 1.7% | not timed | not timed | 17.81 ± 1.6% | | 0.99 | 3.16 | 33.03 |
| 14-quadratic/10x | 1000 | 7.74 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.1% | not timed | not timed | 7.78 ± 0.5% | | 1.00 | 6.41 | 66.95 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 0.6% | not timed | not timed | 0.34 ± 0.8% | 0.55 ± 4.6% | not timed | not timed | 1.26 ± 0.8% | | 1.00 | 3.64 | 2.29 |
| 04-ruff-noqa/compile-real | 1 | 101.94 ± 1.4% | not timed | not timed | 13.73 ± 0.6% | 139.57 ± 2.1% | not timed | not timed | 101.82 ± 1.1% | | 1.00 | 7.43 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 14.00 ± 1.6% | not timed | not timed | 2.53 ± 0.9% | 6.46 ± 1.6% | not timed | not timed | 14.02 ± 2.2% | | 1.00 | 5.53 | 2.17 |
| 07-unicode-character-data/compile | 1 | 107.25 ± 1.4% | not timed | not timed | 25.81 ± 0.2% | 36.47 ± 2.5% | not timed | not timed | 107.13 ± 1.2% | | 1.00 | 4.16 | 2.94 |
| 09-aws-keys/compile-full | 1 | 51.93 ± 1.8% | not timed | not timed | 8.28 ± 0.5% | 23.42 ± 1.4% | not timed | not timed | 51.99 ± 0.7% | | 1.00 | 6.27 | 2.22 |
| 09-aws-keys/compile-quick | 1 | 180.54 ± 1.1% | not timed | not timed | 47.10 ± 0.3% | 134.38 ± 1.8% | not timed | not timed | 179.56 ± 0.2% | | 1.01 | 3.83 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 69.41 ± 1.8% | not timed | not timed | 11.08 ± 0.3% | 16.09 ± 1.5% | not timed | not timed | 69.61 ± 1.2% | | 1.00 | 6.26 | 4.31 |
| 10-bounded-repeat/compile-capitals | 1 | 81.59 ± 2.2% | not timed | not timed | 8.03 ± 0.2% | 23.99 ± 1.3% | not timed | not timed | 81.63 ± 0.2% | | 1.00 | 10.16 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 169.47 ± 1.2% | not timed | not timed | 41.27 ± 0.2% | 67.42 ± 4.0% | not timed | not timed | 168.47 ± 0.5% | | 1.01 | 4.11 | 2.51 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.5% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 17.2% | not timed | not timed | 0.35 ± 1.0% | | 1.00 | 5.05 | 3.63 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.28 ± 0.9% | not timed | not timed | 6.52 ± 0.4% | 0.54 ± 13.6% | not timed | not timed | 7.29 ± 0.5% | | 1.00 | 1.12 | 13.51 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.6% | not timed | not timed | 164.96 ± 0.8% | 0.00 ± 0.2% | not timed | not timed | 1.16 ± 0.6% | | 1.00 | 0.0070 | 424.63 |
| dictionary/search/english-15 | 15 | 566.79 ± 1.0% | not timed | not timed | 558.97 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 566.80 ± 0.9% | | 1.00 | 1.01 | 1537.58 |
| folly/awyer-inn-busted | 1 | 5585.20 ± 0.2% | not timed | not timed | 143.84 ± 0.2% | 43.99 ± 0.2% | not timed | not timed | 5602.71 ± 0.2% | | 1.00 | 38.83 | 126.97 |
| folly/literal-never-match-rare | 0 | 21145.28 ± 0.9% | not timed | not timed | 19909.23 ± 0.3% | 40995.97 ± 0.2% | not timed | not timed | 21123.47 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12484.67 ± 1.6% | not timed | not timed | 19870.34 ± 0.1% | 2206.71 ± 0.2% | not timed | not timed | 12486.46 ± 1.3% | | 1.00 | 0.63 | 5.66 |
| folly/literal-never-match-tricksy | 1 | 3229.74 ± 0.1% | not timed | not timed | 4411.14 ± 0.2% | 3052.83 ± 0.0% | not timed | not timed | 3241.47 ± 0.3% | | 1.00 | 0.73 | 1.06 |
| grep/every-line | 239963 | 1314.75 ± 0.5% | not timed | not timed | 955.10 ± 0.6% | 385.01 ± 19.6% | not timed | not timed | 1323.01 ± 0.7% | | 0.99 | 1.38 | 3.41 |
| grep/long-words-ascii | 5073 | 458.44 ± 0.1% | not timed | not timed | 470.76 ± 0.1% | 46.18 ± 7.9% | not timed | not timed | 458.72 ± 0.3% | | 1.00 | 0.97 | 9.93 |
| imported/leipzig/twain | 811 | 20656.58 ± 1.4% | not timed | not timed | 19586.63 ± 0.6% | 11991.10 ± 9.9% | not timed | not timed | 20641.92 ± 0.6% | | 1.00 | 1.05 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 9030.30 ± 0.9% | not timed | not timed | 4248.13 ± 0.1% | 37.76 ± 0.7% | not timed | not timed | 9100.93 ± 1.2% | | 0.99 | 2.13 | 239.14 |
| imported/leipzig/shing | 1540 | 15242.35 ± 1.9% | not timed | not timed | 13541.24 ± 0.3% | 33.97 ± 0.1% | not timed | not timed | 15486.52 ± 2.1% | | 0.98 | 1.13 | 448.65 |
| imported/leipzig/huck-saw | 262 | 8273.61 ± 3.1% | not timed | not timed | 5597.05 ± 0.2% | 31.83 ± 0.1% | not timed | not timed | 8447.20 ± 3.4% | | 0.98 | 1.48 | 259.90 |
| imported/leipzig/word-ending-nn | 262 | 604.01 ± 0.5% | not timed | not timed | 616.17 ± 0.2% | 24.73 ± 0.5% | not timed | not timed | 605.12 ± 0.6% | | 1.00 | 0.98 | 24.43 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11192.92 ± 0.7% | not timed | not timed | 4522.77 ± 1.6% | 11.51 ± 0.1% | not timed | not timed | 11230.45 ± 1.6% | | 1.00 | 2.47 | 972.65 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7806.43 ± 1.8% | not timed | not timed | 5479.14 ± 0.4% | 16.86 ± 0.2% | not timed | not timed | 7919.03 ± 24.8% | | 0.99 | 1.42 | 462.95 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4153.61 ± 1.7% | not timed | not timed | 416.93 ± 1.6% | 10.72 ± 0.2% | not timed | not timed | 4197.97 ± 1.5% | | 0.99 | 9.96 | 387.39 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.42 ± 0.8% | not timed | not timed | 615.08 ± 0.2% | 11.14 ± 0.0% | not timed | not timed | 602.28 ± 0.4% | | 1.00 | 0.98 | 54.10 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 602.70 ± 0.3% | not timed | not timed | 615.89 ± 0.3% | 9.75 ± 0.0% | not timed | not timed | 602.18 ± 0.6% | | 1.00 | 0.98 | 61.83 |
| imported/leipzig/tom-river | 2 | 6502.42 ± 1.8% | not timed | not timed | 5144.47 ± 0.2% | 30.90 ± 0.1% | not timed | not timed | 6582.82 ± 1.8% | | 0.99 | 1.26 | 210.46 |
| imported/leipzig/ing | 78424 | 599.41 ± 0.6% | not timed | not timed | 572.22 ± 0.1% | 28.18 ± 3.2% | not timed | not timed | 602.10 ± 0.9% | | 1.00 | 1.05 | 21.27 |
| imported/leipzig/ing-whitespace | 55248 | 748.70 ± 1.3% | not timed | not timed | 2071.92 ± 0.2% | 20.56 ± 3.0% | not timed | not timed | 753.21 ± 0.3% | | 0.99 | 0.36 | 36.41 |
| imported/leipzig/awyer-inn | 209 | 767.08 ± 1.4% | not timed | not timed | 4251.04 ± 1.2% | 22.61 ± 0.1% | not timed | not timed | 767.07 ± 1.3% | | 1.00 | 0.18 | 33.92 |
| imported/leipzig/quotes-bounded | 8886 | 2121.04 ± 0.7% | not timed | not timed | 3012.96 ± 0.2% | 38.21 ± 0.2% | not timed | not timed | 2127.59 ± 1.0% | | 1.00 | 0.70 | 55.50 |
| imported/leipzig/non-ascii-alternate | 2 | 12854.24 ± 2.1% | not timed | not timed | 5664.66 ± 0.3% | 50.41 ± 0.2% | not timed | not timed | 13009.66 ± 2.1% | | 0.99 | 2.27 | 254.97 |
| imported/leipzig/math-symbols | 69 | 1980.90 ± 0.4% | not timed | not timed | 618.28 ± 0.0% | 36.55 ± 0.4% | not timed | not timed | 1980.14 ± 0.4% | | 1.00 | 3.20 | 54.19 |
| imported/leipzig/bounded-strings-ending-z | 0 | 587.41 ± 0.8% | not timed | not timed | 617.92 ± 0.1% | 22.52 ± 0.1% | not timed | not timed | 587.27 ± 0.9% | | 1.00 | 0.95 | 26.08 |
| imported/lh3lh3-reb/uri | 17549 | 679.00 ± 0.1% | not timed | not timed | 1078.39 ± 0.5% | 28.04 ± 2.5% | not timed | not timed | 679.50 ± 0.1% | | 1.00 | 0.63 | 24.21 |
| imported/lh3lh3-reb/email | 15057 | 674.25 ± 0.1% | not timed | not timed | 1171.31 ± 0.1% | 30.68 ± 2.4% | not timed | not timed | 672.85 ± 0.2% | | 1.00 | 0.58 | 21.98 |
| imported/lh3lh3-reb/date | 668 | 859.64 ± 0.2% | not timed | not timed | 1042.01 ± 0.1% | 51.17 ± 4.3% | not timed | not timed | 859.95 ± 0.2% | | 1.00 | 0.82 | 16.80 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.50 ± 0.1% | not timed | not timed | 423.82 ± 0.0% | 15.77 ± 0.8% | not timed | not timed | 644.82 ± 0.2% | | 1.00 | 1.52 | 40.92 |
| imported/mariomka/email | 92 | 24271.17 ± 1.1% | not timed | not timed | 29504.15 ± 0.6% | 32.81 ± 0.1% | not timed | not timed | 24296.25 ± 1.6% | | 1.00 | 0.82 | 739.78 |
| imported/mariomka/uri | 5301 | 5321.89 ± 0.9% | not timed | not timed | 6074.81 ± 0.3% | 32.77 ± 0.2% | not timed | not timed | 5348.18 ± 1.0% | | 1.00 | 0.88 | 162.41 |
| imported/mariomka/ip | 5 | 2156.49 ± 1.9% | not timed | not timed | 2950.53 ± 0.3% | 21.13 ± 0.4% | not timed | not timed | 2155.00 ± 2.3% | | 1.00 | 0.73 | 102.07 |
| imported/rsc/no-exponential | 0 | 604.52 ± 0.2% | not timed | not timed | 320.85 ± 0.1% | 23.86 ± 0.1% | not timed | not timed | 601.58 ± 0.1% | | 1.00 | 1.88 | 25.34 |
| imported/rsc/literal | 1 | 763.92 ± 7.5% | not timed | not timed | 1649.43 ± 2.1% | 191.62 ± 17.7% | not timed | not timed | 759.75 ± 7.1% | | 1.01 | 0.46 | 3.99 |
| imported/rsc/not-literal | 2 | 780.14 ± 1.9% | not timed | not timed | 626.82 ± 0.7% | 46.40 ± 8.8% | not timed | not timed | 782.94 ± 0.2% | | 1.00 | 1.24 | 16.81 |
| imported/rsc/match-class | 1 | 1441.44 ± 0.7% | not timed | not timed | 1661.77 ± 0.2% | 58.69 ± 7.4% | not timed | not timed | 1438.38 ± 2.2% | | 1.00 | 0.87 | 24.56 |
| imported/rsc/match-class-in-range | 1 | 1446.37 ± 9.8% | not timed | not timed | 2373.85 ± 6.3% | 59.95 ± 0.5% | not timed | not timed | 1439.77 ± 0.4% | | 1.00 | 0.61 | 24.12 |
| imported/rsc/match-class-unicode | 1 | 547.66 ± 6.9% | not timed | not timed | 518.54 ± 0.1% | 72.35 ± 1.7% | not timed | not timed | 549.61 ± 0.1% | | 1.00 | 1.06 | 7.57 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1441.15 ± 0.2% | not timed | not timed | 932.27 ± 0.1% | 228.68 ± 0.7% | not timed | not timed | 1442.26 ± 0.1% | | 1.00 | 1.55 | 6.30 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21597.65 ± 0.1% | not timed | not timed | 14205.95 ± 0.2% | 3412.67 ± 0.7% | not timed | not timed | 21584.19 ± 0.2% | | 1.00 | 1.52 | 6.33 |
| imported/rsc/anchored-literal-short-match | 4 | 708.73 ± 1.2% | not timed | not timed | 489.98 ± 0.2% | 86.13 ± 5.8% | not timed | not timed | 713.14 ± 7.0% | | 0.99 | 1.45 | 8.23 |
| imported/rsc/anchored-literal-long-match | 4 | 10642.92 ± 1.2% | not timed | not timed | 7203.78 ± 0.4% | 1241.93 ± 4.7% | not timed | not timed | 10659.06 ± 1.6% | | 1.00 | 1.48 | 8.57 |
| imported/rsc/one-pass-short | 17 | 370.64 ± 10.4% | not timed | not timed | 213.85 ± 0.3% | 29.86 ± 11.8% | not timed | not timed | 360.65 ± 2.9% | | 1.03 | 1.73 | 12.41 |
| imported/rsc/one-pass-short-not | 17 | 278.63 ± 2.5% | not timed | not timed | 226.27 ± 0.1% | 29.88 ± 11.6% | not timed | not timed | 280.16 ± 1.6% | | 0.99 | 1.23 | 9.33 |
| imported/rsc/one-pass-long-prefix | 26 | 362.77 ± 2.0% | not timed | not timed | 283.82 ± 0.2% | 104.69 ± 19.1% | not timed | not timed | 364.11 ± 7.6% | | 1.00 | 1.28 | 3.47 |
| imported/rsc/one-pass-long-prefix-not | 26 | 360.21 ± 1.8% | not timed | not timed | 281.28 ± 0.4% | 64.02 ± 19.2% | not timed | not timed | 362.92 ± 2.1% | | 0.99 | 1.28 | 5.63 |
| imported/rsc/long-needle1 | 31 | 22198.39 ± 0.1% | not timed | not timed | 20158.95 ± 0.1% | 3.75 ± 0.5% | not timed | not timed | 22204.73 ± 0.1% | | 1.00 | 1.10 | 5914.62 |
| imported/rsc/long-needle2 | 31 | 22335.10 ± 0.1% | not timed | not timed | 216.40 ± 0.4% | 3.76 ± 0.1% | not timed | not timed | 22348.29 ± 0.1% | | 1.00 | 103.21 | 5947.50 |
| imported/rsc/easy0-32 | 26 | 1085.11 ± 0.1% | not timed | not timed | 1615.85 ± 1.5% | 148.47 ± 23.8% | not timed | not timed | 1080.79 ± 2.4% | | 1.00 | 0.67 | 7.31 |
| imported/rsc/easy0-1k | 26 | 14948.76 ± 0.3% | not timed | not timed | 12604.59 ± 0.7% | 2312.17 ± 13.0% | not timed | not timed | 14891.48 ± 2.3% | | 1.00 | 1.19 | 6.47 |
| imported/rsc/easy0-32k | 26 | 22992.96 ± 1.4% | not timed | not timed | 20359.40 ± 0.1% | 18800.21 ± 22.5% | not timed | not timed | 23067.28 ± 0.3% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21302.38 ± 2.1% | not timed | not timed | 19572.60 ± 1.7% | 34634.23 ± 3.0% | not timed | not timed | 21263.25 ± 1.3% | | 1.00 | 1.09 | 0.62 |
| imported/rsc/easy1-32 | 19 | 793.41 ± 7.3% | not timed | not timed | 643.28 ± 0.7% | 135.73 ± 20.0% | not timed | not timed | 803.65 ± 0.2% | | 0.99 | 1.23 | 5.85 |
| imported/rsc/easy1-1k | 19 | 16515.49 ± 2.3% | not timed | not timed | 12925.65 ± 0.2% | 2459.03 ± 15.1% | not timed | not timed | 16485.90 ± 0.1% | | 1.00 | 1.28 | 6.72 |
| imported/rsc/easy1-32k | 19 | 516583.70 ± 0.3% | not timed | not timed | 404710.44 ± 0.2% | 20542.21 ± 25.3% | not timed | not timed | 505254.65 ± 2.1% | | 1.02 | 1.28 | 25.15 |
| imported/rsc/easy1-1mb | 19 | 16593186.85 ± 0.3% | not timed | not timed | 13110403.54 ± 0.1% | 37149.59 ± 2.4% | not timed | not timed | 16542730.06 ± 0.2% | | 1.00 | 1.27 | 446.66 |
| imported/rsc/medium-32 | 27 | 767.70 ± 7.5% | not timed | not timed | 626.38 ± 0.0% | 69.93 ± 1.1% | not timed | not timed | 774.31 ± 0.3% | | 0.99 | 1.23 | 10.98 |
| imported/rsc/medium-1k | 27 | 13679.76 ± 0.4% | not timed | not timed | 11455.03 ± 0.2% | 72.33 ± 0.1% | not timed | not timed | 13746.51 ± 0.3% | | 1.00 | 1.19 | 189.13 |
| imported/rsc/medium-32k | 27 | 425837.73 ± 0.6% | not timed | not timed | 351996.89 ± 0.1% | 48.55 ± 0.2% | not timed | not timed | 427969.33 ± 0.4% | | 1.00 | 1.21 | 8770.46 |
| imported/rsc/medium-1mb | 27 | 13589800.96 ± 0.7% | not timed | not timed | 11117778.98 ± 0.2% | 48.56 ± 0.1% | not timed | not timed | 13686055.17 ± 0.6% | | 0.99 | 1.22 | 279855.36 |
| imported/rsc/hard-32 | 58 | 420.56 ± 1.9% | not timed | not timed | 363.65 ± 0.1% | 49.55 ± 8.7% | not timed | not timed | 420.79 ± 0.1% | | 1.00 | 1.16 | 8.49 |
| imported/rsc/hard-1k | 27 | 13408.03 ± 0.4% | not timed | not timed | 11542.08 ± 0.0% | 40.85 ± 0.2% | not timed | not timed | 13420.55 ± 0.2% | | 1.00 | 1.16 | 328.23 |
| imported/rsc/hard-32k | 27 | 415475.32 ± 0.6% | not timed | not timed | 361833.31 ± 0.2% | 29.34 ± 0.1% | not timed | not timed | 419386.63 ± 0.3% | | 0.99 | 1.15 | 14159.98 |
| imported/rsc/hard-1mb | 51 | 8379753.94 ± 0.4% | not timed | not timed | 7243640.90 ± 0.1% | 29.43 ± 0.1% | not timed | not timed | 8392026.91 ± 0.1% | | 1.00 | 1.16 | 284726.47 |
| imported/rsc/reallyhard0-32 | 58 | 267.59 ± 2.2% | not timed | not timed | 225.11 ± 0.1% | 49.47 ± 7.5% | not timed | not timed | 267.32 ± 0.2% | | 1.00 | 1.19 | 5.41 |
| imported/rsc/reallyhard0-1k | 27 | 591.47 ± 0.4% | not timed | not timed | 581.29 ± 0.2% | 40.68 ± 0.2% | not timed | not timed | 589.86 ± 0.1% | | 1.00 | 1.02 | 14.54 |
| imported/rsc/reallyhard0-32k | 27 | 610.71 ± 0.2% | not timed | not timed | 618.40 ± 0.0% | 29.35 ± 0.2% | not timed | not timed | 610.52 ± 0.1% | | 1.00 | 0.99 | 20.81 |
| imported/rsc/reallyhard0-1mb | 51 | 593.86 ± 0.5% | not timed | not timed | 615.86 ± 0.2% | 29.39 ± 0.3% | not timed | not timed | 591.70 ± 0.7% | | 1.00 | 0.96 | 20.21 |
| imported/rsc/reallyreallyhard0-32 | 47 | 287.95 ± 1.7% | not timed | not timed | 192.41 ± 0.1% | 61.37 ± 1.1% | not timed | not timed | 288.08 ± 8.3% | | 1.00 | 1.50 | 4.69 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6877.35 ± 0.2% | not timed | not timed | 5666.66 ± 0.2% | 33.85 ± 2.2% | not timed | not timed | 6888.31 ± 0.1% | | 1.00 | 1.21 | 203.20 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21503.90 ± 0.1% | not timed | not timed | 19153.88 ± 0.1% | 24.77 ± 0.6% | not timed | not timed | 21511.06 ± 0.2% | | 1.00 | 1.12 | 867.99 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21283.39 ± 1.4% | not timed | not timed | 19444.24 ± 1.9% | 23.97 ± 0.3% | not timed | not timed | 21374.38 ± 0.5% | | 1.00 | 1.09 | 887.82 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.05 ± 1.5% | not timed | not timed | 209.74 ± 0.7% | 61.26 ± 12.4% | not timed | not timed | 282.47 ± 1.6% | | 1.00 | 1.34 | 4.60 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5902.47 ± 0.1% | not timed | not timed | 5981.62 ± 0.1% | 34.34 ± 0.8% | not timed | not timed | 5892.21 ± 0.0% | | 1.00 | 0.99 | 171.89 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21414.64 ± 0.1% | not timed | not timed | 19212.01 ± 0.3% | 23.83 ± 4.6% | not timed | not timed | 21428.70 ± 0.1% | | 1.00 | 1.11 | 898.70 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21150.21 ± 1.3% | not timed | not timed | 19620.44 ± 0.8% | 24.30 ± 3.7% | not timed | not timed | 21103.78 ± 0.6% | | 1.00 | 1.08 | 870.36 |
| imported/sherlock/name-sherlock | 776 | 20009.36 ± 5.3% | not timed | not timed | 18615.95 ± 0.1% | 8772.74 ± 25.2% | not timed | not timed | 20085.34 ± 2.3% | | 1.00 | 1.07 | 2.28 |
| imported/sherlock/name-holmes | 2766 | 14849.39 ± 5.1% | not timed | not timed | 15615.55 ± 0.2% | 3328.93 ± 4.4% | not timed | not timed | 15387.73 ± 6.0% | | 0.97 | 0.95 | 4.46 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20055.16 ± 1.6% | not timed | not timed | 18625.19 ± 0.2% | 8004.06 ± 13.4% | not timed | not timed | 20046.96 ± 0.6% | | 1.00 | 1.08 | 2.51 |
| imported/sherlock/name-sherlock-casei | 816 | 15821.48 ± 0.1% | not timed | not timed | 4015.36 ± 0.3% | 32.59 ± 0.8% | not timed | not timed | 15833.89 ± 0.3% | | 1.00 | 3.94 | 485.44 |
| imported/sherlock/name-holmes-casei | 2802 | 9338.87 ± 13.4% | not timed | not timed | 3319.31 ± 0.1% | 37.68 ± 0.2% | not timed | not timed | 9425.95 ± 2.8% | | 0.99 | 2.81 | 247.84 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13122.85 ± 3.1% | not timed | not timed | 3943.46 ± 0.1% | 32.56 ± 0.3% | not timed | not timed | 13113.14 ± 0.8% | | 1.00 | 3.33 | 402.99 |
| imported/sherlock/name-whitespace | 1461 | 15350.61 ± 0.7% | not timed | not timed | 14543.06 ± 0.3% | 7264.50 ± 33.1% | not timed | not timed | 15390.09 ± 6.3% | | 1.00 | 1.06 | 2.11 |
| imported/sherlock/name-alt1 | 1142 | 11651.31 ± 2.4% | not timed | not timed | 16212.52 ± 0.7% | 4073.37 ± 48.8% | not timed | not timed | 11678.39 ± 0.3% | | 1.00 | 0.72 | 2.86 |
| imported/sherlock/name-alt2 | 3542 | 8936.23 ± 0.4% | not timed | not timed | 3824.28 ± 0.1% | 31.44 ± 0.2% | not timed | not timed | 8975.22 ± 0.2% | | 1.00 | 2.34 | 284.19 |
| imported/sherlock/name-alt3 | 4507 | 5586.62 ± 0.7% | not timed | not timed | 3625.57 ± 0.2% | 9.94 ± 4.2% | not timed | not timed | 5584.17 ± 0.3% | | 1.00 | 1.54 | 562.04 |
| imported/sherlock/name-alt3-casei | 4593 | 1515.25 ± 2.7% | not timed | not timed | 285.73 ± 0.2% | 6.49 ± 0.4% | not timed | not timed | 1526.83 ± 1.0% | | 0.99 | 5.30 | 233.50 |
| imported/sherlock/name-alt4 | 3686 | 6370.89 ± 0.3% | not timed | not timed | 3773.12 ± 0.2% | 31.34 ± 0.2% | not timed | not timed | 6383.28 ± 0.3% | | 1.00 | 1.69 | 203.26 |
| imported/sherlock/name-alt4-casei | 4254 | 2790.23 ± 3.3% | not timed | not timed | 2580.15 ± 0.2% | 19.90 ± 16.7% | not timed | not timed | 2803.39 ± 1.2% | | 1.00 | 1.08 | 140.18 |
| imported/sherlock/name-alt5 | 4028 | 6421.33 ± 0.3% | not timed | not timed | 3741.10 ± 0.1% | 21.72 ± 0.2% | not timed | not timed | 6450.93 ± 0.3% | | 1.00 | 1.72 | 295.61 |
| imported/sherlock/name-alt5-casei | 4104 | 3488.80 ± 2.3% | not timed | not timed | 2208.58 ± 0.1% | 14.10 ± 0.1% | not timed | not timed | 3514.06 ± 0.8% | | 0.99 | 1.58 | 247.41 |
| imported/sherlock/no-match-uncommon | 0 | 22028.74 ± 0.2% | not timed | not timed | 19713.65 ± 0.4% | 36259.28 ± 0.6% | not timed | not timed | 22070.42 ± 0.3% | | 1.00 | 1.12 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21699.26 ± 0.4% | not timed | not timed | 19651.60 ± 0.2% | 1290.08 ± 1.5% | not timed | not timed | 21699.46 ± 0.3% | | 1.00 | 1.10 | 16.82 |
| imported/sherlock/no-match-really-common | 0 | 16065.52 ± 1.9% | not timed | not timed | 18802.30 ± 0.4% | 1284.05 ± 1.2% | not timed | not timed | 16211.35 ± 2.0% | | 0.99 | 0.85 | 12.51 |
| imported/sherlock/the-lower | 21654 | 2311.00 ± 1.0% | not timed | not timed | 2311.51 ± 0.5% | 238.39 ± 16.6% | not timed | not timed | 2321.30 ± 1.2% | | 1.00 | 1.00 | 9.69 |
| imported/sherlock/the-upper | 2223 | 12742.02 ± 1.5% | not timed | not timed | 13563.44 ± 0.3% | 2629.48 ± 14.3% | not timed | not timed | 12831.71 ± 1.3% | | 0.99 | 0.94 | 4.85 |
| imported/sherlock/the-casei | 23961 | 2006.99 ± 0.4% | not timed | not timed | 1312.61 ± 0.5% | 34.77 ± 18.7% | not timed | not timed | 2011.44 ± 2.7% | | 1.00 | 1.53 | 57.72 |
| imported/sherlock/everything-greedy | 581881 | 281.44 ± 0.8% | not timed | not timed | 165.10 ± 0.3% | 28.72 ± 29.0% | not timed | not timed | 283.46 ± 0.1% | | 0.99 | 1.70 | 9.80 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.48 ± 0.5% | not timed | not timed | 213.73 ± 0.2% | 32.99 ± 0.1% | not timed | not timed | 462.10 ± 0.1% | | 1.00 | 2.16 | 14.02 |
| imported/sherlock/letters | 447175 | 61.91 ± 9.7% | not timed | not timed | 32.98 ± 0.1% | 5.31 ± 20.5% | not timed | not timed | 62.41 ± 0.5% | | 0.99 | 1.88 | 11.67 |
| imported/sherlock/letters-upper | 14180 | 453.47 ± 1.1% | not timed | not timed | 370.53 ± 0.1% | 29.12 ± 18.4% | not timed | not timed | 453.20 ± 8.2% | | 1.00 | 1.22 | 15.57 |
| imported/sherlock/letters-lower | 432995 | 63.54 ± 1.1% | not timed | not timed | 33.82 ± 0.2% | 6.67 ± 40.3% | not timed | not timed | 63.54 ± 0.7% | | 1.00 | 1.88 | 9.52 |
| imported/sherlock/words | 447639 | 115.28 ± 0.5% | not timed | not timed | 82.89 ± 0.2% | 13.33 ± 25.7% | not timed | not timed | 114.91 ± 0.4% | | 1.00 | 1.39 | 8.65 |
| imported/sherlock/before-holmes | 4073 | 10327.13 ± 0.6% | not timed | not timed | 8106.83 ± 0.3% | 24.07 ± 1.3% | not timed | not timed | 10336.66 ± 0.4% | | 1.00 | 1.27 | 429.03 |
| imported/sherlock/before-after-holmes | 2593 | 9852.11 ± 0.8% | not timed | not timed | 9277.28 ± 0.2% | 24.00 ± 1.4% | not timed | not timed | 9873.91 ± 0.6% | | 1.00 | 1.06 | 410.46 |
| imported/sherlock/holmes-cochar-watson | 150 | 5190.82 ± 0.4% | not timed | not timed | 3426.36 ± 0.2% | 30.98 ± 0.2% | not timed | not timed | 5203.57 ± 0.6% | | 1.00 | 1.51 | 167.53 |
| imported/sherlock/holmes-coword-watson | 14309 | 1187.09 ± 0.6% | not timed | not timed | 1121.26 ± 0.4% | 6.78 ± 0.4% | not timed | not timed | 1186.13 ± 0.6% | | 1.00 | 1.06 | 175.03 |
| imported/sherlock/quotes | 14437 | 1399.44 ± 0.1% | not timed | not timed | 1764.80 ± 0.7% | 35.17 ± 0.2% | not timed | not timed | 1397.85 ± 0.4% | | 1.00 | 0.79 | 39.79 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.88 ± 0.2% | not timed | not timed | 16040.37 ± 0.2% | 36.79 ± 0.4% | not timed | not timed | 609.83 ± 0.1% | | 1.00 | 0.0380 | 16.58 |
| imported/sherlock/word-ending-n | 35297 | 480.38 ± 0.3% | not timed | not timed | 409.04 ± 0.1% | 23.28 ± 21.8% | not timed | not timed | 481.75 ± 1.1% | | 1.00 | 1.17 | 20.63 |
| imported/sherlock/repeated-class-negation | 2130 | 14856.42 ± 0.6% | not timed | not timed | 10383.35 ± 0.6% | 11.57 ± 0.2% | not timed | not timed | 14897.08 ± 0.9% | | 1.00 | 1.43 | 1284.26 |
| imported/sherlock/ing-suffix | 20547 | 565.69 ± 0.4% | not timed | not timed | 516.85 ± 0.1% | 28.88 ± 0.1% | not timed | not timed | 567.42 ± 0.4% | | 1.00 | 1.09 | 19.59 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.21 ± 0.3% | not timed | not timed | 2008.08 ± 0.4% | 20.54 ± 0.3% | not timed | not timed | 607.52 ± 0.3% | | 1.00 | 0.30 | 29.57 |
| opt/accelerate/whole-line | 239963 | 458.07 ± 0.4% | not timed | not timed | 373.10 ± 0.3% | 92.13 ± 17.1% | not timed | not timed | 458.16 ± 0.2% | | 1.00 | 1.23 | 4.97 |
| opt/accelerate/non-dna | 16745 | 425.78 ± 0.6% | not timed | not timed | 400.01 ± 0.9% | 29.31 ± 61.4% | not timed | not timed | 427.79 ± 0.4% | | 1.00 | 1.06 | 14.53 |
| opt/backtrack/words-english | 40536 | 136.41 ± 1.9% | not timed | not timed | 94.22 ± 0.2% | 19.64 ± 7.8% | not timed | not timed | 136.61 ± 2.2% | | 1.00 | 1.45 | 6.95 |
| opt/fixed-length/too-small-ascii | 0 | 312.25 ± 0.2% | not timed | not timed | 716.13 ± 0.8% | 79.49 ± 1.0% | not timed | not timed | 313.52 ± 0.1% | | 1.00 | 0.44 | 3.93 |
| opt/fixed-length/too-big-ascii | 0 | 3484.63 ± 0.1% | not timed | not timed | 5843.48 ± 0.1% | 127.03 ± 0.6% | not timed | not timed | 3460.56 ± 0.2% | | 1.01 | 0.60 | 27.43 |
| opt/fixed-length/go33484-1 | 0 | 670369.51 ± 0.2% | not timed | not timed | 1115876.17 ± 0.1% | 61487.80 ± 0.3% | not timed | not timed | 664455.06 ± 0.1% | | 1.01 | 0.60 | 10.90 |
| opt/fixed-length/go33484-2 | 0 | 670487.32 ± 0.1% | not timed | not timed | 1122352.02 ± 0.2% | 31862.23 ± 0.9% | not timed | not timed | 664701.64 ± 0.1% | | 1.01 | 0.60 | 21.04 |
| opt/fixed-length/go33484-3 | 0 | 2458.86 ± 2.8% | not timed | not timed | 111025.96 ± 0.0% | 768.26 ± 0.7% | not timed | not timed | 2482.26 ± 4.3% | | 0.99 | 0.0221 | 3.20 |
| opt/literal-alt/one-pattern | 1 | 546.07 ± 11.2% | not timed | not timed | 544.99 ± 0.0% | 0.40 ± 0.2% | not timed | not timed | 548.19 ± 1.5% | | 1.00 | 1.00 | 1369.96 |
| opt/onepass/fn-predicate | 916 | 371.41 ± 0.6% | not timed | not timed | 328.05 ± 0.1% | 201.52 ± 16.2% | not timed | not timed | 371.01 ± 1.1% | | 1.00 | 1.13 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 172.42 ± 8.6% | not timed | not timed | 196.64 ± 0.2% | 81.12 ± 8.9% | not timed | not timed | 176.69 ± 1.8% | | 0.98 | 0.88 | 2.13 |
| opt/prefilter/literal-english | 1 | 20497.68 ± 0.6% | not timed | not timed | 19519.45 ± 0.5% | 17340.91 ± 0.9% | not timed | not timed | 20507.43 ± 0.1% | | 1.00 | 1.05 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14470.61 ± 0.5% | not timed | not timed | 4311.15 ± 0.2% | 32.69 ± 0.3% | not timed | not timed | 14474.90 ± 0.2% | | 1.00 | 3.36 | 442.64 |
| opt/prefilter/literal-russian | 1 | 21138.02 ± 1.1% | not timed | not timed | 19705.31 ± 1.1% | 3326.29 ± 0.1% | not timed | not timed | 21103.76 ± 0.7% | | 1.00 | 1.07 | 6.35 |
| opt/prefilter/literal-casei-russian | 1 | 8600.47 ± 0.9% | not timed | not timed | 3891.00 ± 0.2% | 31.63 ± 0.7% | not timed | not timed | 8598.11 ± 0.7% | | 1.00 | 2.21 | 271.94 |
| opt/prefilter/rust-functions | 948 | 6818.42 ± 0.3% | not timed | not timed | 9016.63 ± 0.3% | 1866.55 ± 0.7% | not timed | not timed | 6824.59 ± 0.2% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 30104822.70 ± 0.3% | not timed | not timed | 21031877.32 ± 0.1% | 50.30 ± 0.2% | not timed | not timed | 30028216.40 ± 0.3% | | 1.00 | 1.43 | 598555.41 |
| opt/reverse-inner/holmes | 2593 | 9850.81 ± 0.5% | not timed | not timed | 9245.29 ± 0.2% | 24.12 ± 1.7% | not timed | not timed | 9876.87 ± 0.5% | | 1.00 | 1.07 | 408.43 |
| opt/reverse-inner/email | 47 | 35969.97 ± 2.8% | not timed | not timed | 44480.21 ± 0.6% | 32.36 ± 0.4% | not timed | not timed | 36129.86 ± 2.1% | | 1.00 | 0.81 | 1111.64 |
| opt/reverse-inner/factored-prefix | 3542 | 600.87 ± 0.1% | not timed | not timed | 597.56 ± 0.1% | 12.54 ± 0.3% | not timed | not timed | 599.63 ± 0.1% | | 1.00 | 1.01 | 47.92 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5555.76 ± 0.1% | not timed | not timed | 619.13 ± 0.2% | 75.23 ± 0.4% | not timed | not timed | 5533.33 ± 0.0% | | 1.00 | 8.97 | 73.85 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.48 ± 2.6% | not timed | not timed | 287.22 ± 0.4% | 24.84 ± 0.1% | not timed | not timed | 686.80 ± 2.0% | | 1.00 | 2.39 | 27.67 |
| opt/reverse-suffix/holmes | 4073 | 10301.52 ± 0.4% | not timed | not timed | 8102.80 ± 0.2% | 23.79 ± 0.6% | not timed | not timed | 10321.67 ± 0.3% | | 1.00 | 1.27 | 433.04 |
| opt/reverse-suffix/no-quadratic | 0 | 5533.11 ± 0.1% | not timed | not timed | 610.25 ± 0.2% | 75.02 ± 0.1% | not timed | not timed | 5561.30 ± 0.1% | | 0.99 | 9.07 | 73.75 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 122.02 ± 2.0% | not timed | not timed | 131.88 ± 0.1% | 13.03 ± 15.1% | not timed | not timed | 122.84 ± 2.5% | | 0.99 | 0.93 | 9.37 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.29 ± 8.0% | not timed | not timed | 133.57 ± 0.1% | 12.97 ± 14.4% | not timed | not timed | 122.85 ± 0.2% | | 0.99 | 0.91 | 9.35 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.2% | 113.34 ± 0.4% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.50 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 318.39 ± 0.3% | not timed | not timed | 293.61 ± 0.2% | 104.15 ± 7.0% | not timed | not timed | 315.12 ± 3.1% | | 1.01 | 1.08 | 3.06 |
| reported/i13-subset-regex/original-ascii | 4094 | 11149.34 ± 1.0% | not timed | not timed | 4524.20 ± 0.8% | 11.51 ± 0.1% | not timed | not timed | 11191.24 ± 0.9% | | 1.00 | 2.46 | 968.72 |
| reported/i13-subset-regex/original-unicode | 4094 | 10987.01 ± 1.4% | not timed | not timed | 250.38 ± 3.0% | 11.49 ± 0.1% | not timed | not timed | 11117.21 ± 1.2% | | 0.99 | 43.88 | 956.36 |
| reported/i13-subset-regex/big-ascii | 1955 | 10624.49 ± 1.8% | not timed | not timed | 67.88 ± 3.8% | 9.84 ± 0.2% | not timed | not timed | 10679.06 ± 1.1% | | 0.99 | 156.52 | 1079.99 |
| reported/i13-subset-regex/big-unicode | 1955 | 10550.69 ± 1.7% | not timed | not timed | 12.16 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10689.35 ± 1.1% | | 0.99 | 867.40 | 1070.85 |
| reported/i13-subset-regex/huge-ascii | 55 | 9903.04 ± 3.0% | not timed | not timed | 11.03 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 9915.01 ± 3.7% | | 1.00 | 898.07 | 1130.79 |
| reported/i13-subset-regex/huge-unicode | 55 | 9823.12 ± 2.8% | not timed | not timed | 10.96 ± 0.4% | 8.75 ± 0.1% | not timed | not timed | 9825.81 ± 5.8% | | 1.00 | 896.22 | 1122.38 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 11.03 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.04 ± 0.1% | not timed | not timed | 10.99 ± 0.3% | 8.76 ± 1.0% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 487.75 ± 0.2% | not timed | not timed | 104.11 ± 0.2% | 6.45 ± 0.1% | not timed | not timed | 488.21 ± 0.5% | | 1.00 | 4.68 | 75.64 |
| reported/i787-keywords/opt-ascii | 5674 | 488.76 ± 0.3% | not timed | not timed | 276.04 ± 0.1% | 10.29 ± 0.2% | not timed | not timed | 489.39 ± 0.3% | | 1.00 | 1.77 | 47.48 |
| slow/quadratic-regex-1x | 100 | 7.03 ± 0.3% | not timed | not timed | 4.95 ± 0.0% | 0.05 ± 0.6% | not timed | not timed | 7.14 ± 0.5% | | 0.98 | 1.42 | 142.81 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.76 ± 0.4% | 0.01 ± 0.2% | not timed | not timed | 3.43 ± 0.1% | | 0.99 | 1.23 | 266.10 |
| slow/quadratic-haystack-1x | 100 | 21.08 ± 6.5% | not timed | not timed | 10.05 ± 0.4% | 1.01 ± 14.2% | not timed | not timed | 21.37 ± 1.6% | | 0.99 | 2.10 | 20.78 |
| slow/quadratic-haystack-2x | 200 | 17.60 ± 1.0% | not timed | not timed | 5.55 ± 0.1% | 0.55 ± 0.9% | not timed | not timed | 17.77 ± 12.6% | | 0.99 | 3.17 | 32.16 |
| unicode/codepoints/any-one | 1112064 | 289.94 ± 0.4% | not timed | not timed | 177.03 ± 0.1% | 18.36 ± 5.1% | not timed | not timed | 291.55 ± 0.2% | | 0.99 | 1.64 | 15.80 |
| unicode/codepoints/any-all | 4382592 | 270.00 ± 0.1% | not timed | not timed | 247.10 ± 0.1% | 117.05 ± 0.1% | not timed | not timed | 270.10 ± 0.1% | | 1.00 | 1.09 | 2.31 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.78 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.79 ± 0.4% | not timed | not timed | 616.53 ± 0.1% | 134.95 ± 0.7% | not timed | not timed | 602.75 ± 0.2% | | 1.00 | 0.98 | 4.48 |
| unicode/overlapping-words/ascii | 6156 | 32.02 ± 0.2% | not timed | not timed | 38.95 ± 0.1% | 3.95 ± 1.2% | not timed | not timed | 32.07 ± 0.3% | | 1.00 | 0.82 | 8.11 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.3% | not timed | not timed | 3.40 ± 0.5% | 2.34 ± 0.3% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.43 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.5% | not timed | not timed | 3.18 ± 0.2% | 6.31 ± 9.3% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.40 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 126.63 ± 7.7% | not timed | not timed | 82.89 ± 0.3% | 11.50 ± 21.0% | not timed | not timed | 128.51 ± 0.7% | | 0.99 | 1.53 | 11.01 |
| unicode/word/boundary-long-english | 3466 | 615.36 ± 0.1% | not timed | not timed | 606.93 ± 0.1% | 32.30 ± 0.5% | not timed | not timed | 616.15 ± 0.4% | | 1.00 | 1.01 | 19.05 |
| unicode/word/around-holmes-english | 27 | 19588.64 ± 0.7% | not timed | not timed | 19222.31 ± 0.5% | 21.97 ± 0.8% | not timed | not timed | 19588.50 ± 1.4% | | 1.00 | 1.02 | 891.42 |
| wild/bibleref/long | 874 | 562.05 ± 0.2% | not timed | not timed | 583.96 ± 0.1% | 6.50 ± 0.1% | not timed | not timed | 562.13 ± 0.1% | | 1.00 | 0.96 | 86.48 |
| wild/bibleref/short | 30 | 23.62 ± 3.1% | not timed | not timed | 31.37 ± 0.2% | 13.78 ± 11.4% | not timed | not timed | 24.17 ± 4.0% | | 0.98 | 0.75 | 1.71 |
| wild/bibleref/line | 874 | 394.60 ± 0.4% | not timed | not timed | 217.35 ± 0.1% | 9.08 ± 0.2% | not timed | not timed | 394.75 ± 0.1% | | 1.00 | 1.82 | 43.46 |
| wild/caddy/caddy | 6 | 416.76 ± 5.6% | not timed | not timed | 214.64 ± 0.4% | 67.12 ± 14.7% | not timed | not timed | 417.69 ± 1.8% | | 1.00 | 1.94 | 6.21 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.14 ± 0.2% | not timed | not timed | 347.82 ± 0.4% | 13.49 ± 0.2% | not timed | not timed | 1071.56 ± 0.4% | | 1.00 | 3.08 | 79.35 |
| wild/ruff/noqa | 84 | 436.13 ± 0.1% | not timed | not timed | 478.58 ± 0.1% | 19.59 ± 1.9% | not timed | not timed | 434.07 ± 0.2% | | 1.00 | 0.91 | 22.26 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.75 ± 0.3% | not timed | not timed | 704.36 ± 0.1% | 135.85 ± 11.0% | not timed | not timed | 959.47 ± 0.5% | | 1.00 | 1.36 | 7.05 |
| wild/ruff/string-quote-prefix | 2972 | 1333.66 ± 2.6% | not timed | not timed | 443.06 ± 0.3% | 370.75 ± 33.6% | not timed | not timed | 1333.15 ± 2.1% | | 1.00 | 3.01 | 3.60 |
| wild/ruff/space-around-operator | 1224378 | 220.64 ± 1.7% | not timed | not timed | 187.82 ± 0.0% | 17.81 ± 2.0% | not timed | not timed | 221.08 ± 1.8% | | 1.00 | 1.17 | 12.39 |
| wild/ruff/shebang | 282 | 978.20 ± 0.5% | not timed | not timed | 327.13 ± 0.2% | 118.48 ± 12.6% | not timed | not timed | 985.53 ± 2.0% | | 0.99 | 2.99 | 8.26 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13804.88 ± 0.2% | not timed | not timed | 13837.05 ± 0.3% | 6905.17 ± 0.8% | not timed | not timed | 13827.94 ± 0.2% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12820.81 ± 0.7% | not timed | not timed | 13534.29 ± 0.6% | 6404.42 ± 0.9% | not timed | not timed | 12831.62 ± 0.6% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13198.40 ± 0.3% | not timed | not timed | 13696.78 ± 0.3% | 6663.25 ± 0.6% | not timed | not timed | 13182.58 ± 0.5% | | 1.00 | 0.96 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9541.64 ± 0.6% | not timed | not timed | 13628.78 ± 0.4% | 6709.35 ± 0.5% | not timed | not timed | 9557.41 ± 0.1% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 120.94 ± 14.0% | not timed | not timed | 65.26 ± 0.9% | 2.22 ± 0.7% | not timed | not timed | 122.17 ± 14.4% | | 0.99 | 1.85 | 54.58 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 57.7% | not timed | not timed | 0.01 ± 0.9% | 0.01 ± 28.6% | not timed | not timed | 0.03 ± 2.2% | | 0.98 | 3.05 | 3.81 |
| dictionary/compile/english-15 | 1 | 0.35 ± 1.2% | not timed | not timed | 0.07 ± 0.2% | 0.11 ± 28.5% | not timed | not timed | 0.35 ± 1.8% | | 1.00 | 5.08 | 3.25 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 0.9% | not timed | not timed | 0.02 ± 0.4% | 35.54 ± 3.0% | not timed | not timed | 0.24 ± 1.6% | | 0.98 | 12.47 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.38 ± 2.5% | not timed | not timed | 11.62 ± 0.2% | 51.66 ± 18.6% | not timed | not timed | 45.85 ± 2.3% | | 0.99 | 3.91 | 0.88 |
| reported/i787-keywords/compile | 1 | 35.36 ± 16.7% | not timed | not timed | 2.12 ± 1.1% | 17.43 ± 27.3% | not timed | not timed | 35.44 ± 4.9% | | 1.00 | 16.65 | 2.03 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 336.54 ± 1.4% | not timed | not timed | 126.06 ± 0.2% | 561.72 ± 16.4% | not timed | not timed | 337.55 ± 3.7% | | 1.00 | 2.67 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.70 ± 22.2% | not timed | not timed | 4.06 ± 0.8% | 43.36 ± 15.1% | not timed | not timed | 47.49 ± 1.6% | | 0.98 | 11.49 | 1.08 |
| unicode/compile/one-letter | 53 | 6.66 ± 8.8% | not timed | not timed | 4.58 ± 0.6% | 64.62 ± 7.2% | not timed | not timed | 6.72 ± 14.2% | | 0.99 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.01 ± 15.8% | not timed | not timed | 0.10 ± 0.5% | 65.48 ± 6.7% | not timed | not timed | 1.06 ± 15.8% | | 0.96 | 10.25 | 0.0154 |
| unicode/compile/fifty-letters-ascii | 1 | 207.64 ± 8.2% | not timed | not timed | 51.65 ± 0.3% | 200.97 ± 20.9% | not timed | not timed | 208.29 ± 11.8% | | 1.00 | 4.02 | 1.03 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 376.69 ± 18.3% | not timed | not timed | 47.05 ± 0.2% | 674.86 ± 20.3% | not timed | not timed | 377.28 ± 19.0% | | 1.00 | 8.01 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 589.74 ± 3.4% | not timed | not timed | 133.66 ± 0.2% | 640.21 ± 28.7% | not timed | not timed | 588.51 ± 7.5% | | 1.00 | 4.41 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 304.96 ± 2.9% | not timed | not timed | 51.14 ± 0.7% | 1224.89 ± 3.9% | not timed | not timed | 310.90 ± 2.8% | | 0.98 | 5.96 | 0.25 |
| wild/bibleref/compile | 3 | 5.72 ± 21.2% | not timed | not timed | 1.90 ± 1.0% | 30.64 ± 15.2% | not timed | not timed | 5.92 ± 4.0% | | 0.97 | 3.01 | 0.19 |
| wild/url/compile | 1 | 0.64 ± 19.8% | not timed | not timed | 0.14 ± 0.6% | 0.42 ± 30.2% | not timed | not timed | 0.65 ± 0.5% | | 0.99 | 4.45 | 1.51 |

