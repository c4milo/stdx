# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148046818 |
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
| literal: a word | 217 | 15823.68 ± 1.3% | 1039.40 ± 0.2% | 28.11 ± 0.2% | 17863.86 ± 33.1% | 8858.21 ± 27.3% | 17.31 ± 0.5% | 87.15 ± 0.2% | 15834.46 ± 1.3% | 15.22 | 1.00 | 0.89 | 1.79 |
| literal: a word that is not there | 0 | 18195.97 ± 2.3% | 1047.45 ± 0.1% | 28.05 ± 0.3% | 19272.30 ± 2.5% | 28417.57 ± 3.4% | 17.15 ± 0.2% | 82.94 ± 0.3% | 18507.74 ± 1.4% | 17.37 | 0.98 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6051.97 ± 0.4% | 1022.46 ± 0.2% | 14.56 ± 0.2% | 3944.65 ± 0.2% | 21.87 ± 0.1% | 5.25 ± 0.1% | 6.92 ± 0.5% | 6029.50 ± 0.2% | 5.92 | 1.00 | 1.53 | 276.70 |
| literal: a word in any case | 217 | 12543.62 ± 0.6% | 1039.66 ± 0.1% | 21.09 ± 2.5% | 3969.51 ± 0.1% | 38.03 ± 0.3% | refused | differs | 12529.74 ± 0.9% | 12.07 | 1.00 | 3.16 | 329.81 |
| literal: an href attribute | 33 | 13660.01 ± 1.0% | 1046.03 ± 0.1% | 27.04 ± 0.2% | 16922.57 ± 1.3% | 2254.30 ± 6.5% | 13.22 ± 0.4% | 76.10 ± 0.2% | 13615.13 ± 0.8% | 13.06 | 1.00 | 0.81 | 6.06 |
| literal: a word, second text | 123 | 16199.05 ± 0.6% | 1043.12 ± 0.1% | 27.80 ± 0.1% | 18020.65 ± 1.3% | 7596.37 ± 3.1% | 19.69 ± 0.6% | 71.36 ± 0.6% | 16265.22 ± 1.0% | 15.53 | 1.00 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1104.26 ± 0.2% | 976.95 ± 0.1% | 25.80 ± 0.2% | 585.32 ± 0.1% | 40.52 ± 13.3% | 14.68 ± 0.4% | 68.85 ± 0.2% | 1105.34 ± 0.4% | 1.13 | 1.00 | 1.89 | 27.25 |
| class: a word that ends in ing | 3399 | 894.97 ± 0.1% | 894.15 ± 0.2% | 17.94 ± 0.4% | 547.89 ± 0.1% | 29.59 ± 4.8% | 8.16 ± 0.1% | 18.40 ± 0.3% | 893.56 ± 0.2% | 1.00 | 1.00 | 1.63 | 30.24 |
| class: a word in capitals | 2332 | 1453.37 ± 0.3% | 948.98 ± 0.2% | 27.48 ± 0.3% | 572.19 ± 0.1% | 43.47 ± 0.2% | 17.05 ± 0.1% | 83.11 ± 0.3% | 1454.77 ± 0.2% | 1.53 | 1.00 | 2.54 | 33.43 |
| class: a number | 8288 | 1997.53 ± 0.4% | 836.35 ± 0.1% | 27.59 ± 0.2% | 1724.24 ± 1.0% | 40.22 ± 15.4% | 0.55 ± 0.2% | 56.38 ± 0.4% | 1992.41 ± 0.3% | 2.39 | 1.00 | 1.16 | 49.66 |
| class: two capitalized words, second text | 5359 | 743.19 ± 0.2% | 743.40 ± 0.1% | 23.15 ± 0.2% | 484.24 ± 0.3% | 34.09 ± 9.9% | 16.62 ± 0.7% | 63.90 ± 0.2% | 742.59 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.80 |
| other: a word between two words | 6104 | 752.56 ± 0.2% | 776.42 ± 0.1% | 23.37 ± 0.3% | 740.14 ± 0.2% | 109.10 ± 14.6% | 11.20 ± 0.1% | 70.10 ± 0.2% | 752.98 ± 0.1% | 0.97 | 1.00 | 1.02 | 6.90 |
| other: a number before a unit, second text | 1481 | 5447.80 ± 0.2% | 984.19 ± 0.1% | 25.70 ± 0.1% | 5589.42 ± 0.3% | 40.70 ± 9.5% | 17.81 ± 0.2% | 66.97 ± 0.2% | 5427.55 ± 0.5% | 5.54 | 1.00 | 0.97 | 133.86 |
| other: a heading's start tag | 110 | 12452.80 ± 0.3% | 1035.83 ± 0.0% | 27.17 ± 0.3% | 1709.88 ± 0.1% | 1580.96 ± 6.0% | 16.05 ± 0.3% | 88.94 ± 0.2% | 12424.93 ± 1.0% | 12.02 | 1.00 | 7.28 | 7.88 |
| other: a whole word | 217 | 13866.25 ± 1.1% | 1037.82 ± 0.3% | 29.18 ± 0.2% | 14415.96 ± 1.6% | 49.46 ± 0.3% | 13.37 ± 0.1% | 56.02 ± 0.4% | 13842.58 ± 0.9% | 13.36 | 1.00 | 0.96 | 280.35 |
| other: a line's first word, second text | 3716 | 1971.64 ± 0.5% | 876.21 ± 0.1% | 30.44 ± 0.4% | 1719.64 ± 0.6% | 61.61 ± 7.2% | refused | refused | 1964.74 ± 0.9% | 2.25 | 1.00 | 1.15 | 32.00 |
| other: fourteen octets before an x | 87 | 19219.03 ± 1.9% | 236.98 ± 0.5% | 6.58 ± 0.2% | 3908.09 ± 0.3% | 10.66 ± 0.1% | differs | 17.76 ± 0.2% | 19230.51 ± 0.6% | 81.10 | 1.00 | 4.92 | 1802.74 |
| other: a Greek word | 21815 | 513.23 ± 0.6% | 414.33 ± 0.5% | 30.99 ± 0.2% | 289.23 ± 0.1% | 47.88 ± 9.8% | differs | refused | 511.29 ± 0.1% | 1.24 | 1.00 | 1.77 | 10.72 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.3% | 25.83 ± 0.2% | 0.87 ± 0.4% | 19.78 ± 0.2% | 2.77 ± 10.3% | differs | 3.96 ± 0.2% | 25.76 ± 0.3% | 1.00 | 1.00 | 1.31 | 9.32 |
| a UUID | 32895 | 21.06 ± 0.3% | 21.13 ± 0.2% | 0.65 ± 0.2% | 15.20 ± 0.3% | 3.11 ± 0.5% | 0.71 ± 0.2% | 3.58 ± 0.5% | 21.14 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.77 |
| an IPv4 address | 33176 | 36.93 ± 0.4% | 36.81 ± 0.1% | 2.11 ± 0.4% | 28.97 ± 0.5% | 6.68 ± 0.2% | differs | 4.18 ± 0.3% | 36.89 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.53 |
| a date and time | 32954 | 30.96 ± 0.1% | 31.21 ± 0.2% | 1.47 ± 0.6% | 21.19 ± 0.2% | 7.06 ± 0.1% | 1.20 ± 0.4% | 7.10 ± 0.2% | 31.15 ± 0.2% | 0.99 | 0.99 | 1.46 | 4.39 |
| a field path | 32606 | 29.41 ± 0.2% | 29.37 ± 0.2% | 1.03 ± 0.2% | 23.06 ± 0.3% | 3.49 ± 0.9% | differs | 2.91 ± 0.2% | 29.37 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.44 ± 0.4% | 11.50 ± 0.2% | 11.50 ± 0.2% | 11.36 ± 0.1% | 4.90 ± 2.0% | 0.90 ± 0.8% | none | 11.49 ± 0.3% | 0.99 | 0.99 | 1.01 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.91 ± 0.2% | 221.56 ± 0.2% | 257.38 ± 0.1% | 86.84 ± 0.1% | 220.74 ± 1.1% | 484.37 ± 0.3% | 3885.14 ± 1.1% | 220.66 ± 0.3% | 1.00 | 1.00 | 2.54 | 1.00 |
| a UUID | 62 | 145.08 ± 0.4% | 145.44 ± 0.1% | 160.52 ± 0.3% | 45.44 ± 0.1% | 98.19 ± 0.5% | 183.29 ± 1.4% | 4441.11 ± 0.5% | 144.95 ± 0.2% | 1.00 | 1.00 | 3.19 | 1.48 |
| an IPv4 address | 29 | 435.76 ± 0.3% | 440.67 ± 0.5% | 608.82 ± 0.3% | 76.18 ± 0.9% | 129.98 ± 1.6% | 294.13 ± 0.8% | 7650.86 ± 0.3% | 435.36 ± 0.9% | 0.99 | 1.00 | 5.72 | 3.35 |
| a date and time | 56 | 317.66 ± 0.5% | 319.19 ± 0.2% | 398.73 ± 0.5% | 71.94 ± 0.1% | 137.18 ± 0.8% | 320.23 ± 0.8% | 4953.60 ± 0.3% | 317.69 ± 0.5% | 1.00 | 1.00 | 4.42 | 2.32 |
| a field path | 39 | 208.58 ± 0.8% | 209.11 ± 0.2% | 240.84 ± 0.2% | 79.52 ± 0.4% | 203.35 ± 6.1% | 485.43 ± 0.9% | 4962.05 ± 3.3% | 208.60 ± 0.2% | 1.00 | 1.00 | 2.62 | 1.03 |
| literal: a word | 7 | 659.27 ± 0.6% | 709.69 ± 0.7% | 1261.03 ± 0.7% | 508.62 ± 1.6% | 625.77 ± 2.4% | 921.91 ± 0.9% | 30813.13 ± 0.4% | 659.52 ± 0.6% | 0.93 | 1.00 | 1.30 | 1.05 |
| literal: a word that is not there | 8 | 631.70 ± 0.3% | 685.27 ± 0.4% | 1186.20 ± 0.2% | 464.19 ± 0.2% | 605.61 ± 1.9% | 875.47 ± 0.5% | 29706.91 ± 0.2% | 631.76 ± 0.2% | 0.92 | 1.00 | 1.36 | 1.04 |
| literal: one of four words | 26 | 250.74 ± 0.3% | 412.12 ± 0.5% | 552.75 ± 0.6% | 49.37 ± 0.3% | 243.62 ± 1.0% | 354.77 ± 0.5% | 15892.66 ± 0.2% | 250.72 ± 0.4% | 0.61 | 1.00 | 5.08 | 1.03 |
| literal: a word in any case | 11 | 518.11 ± 0.1% | 558.36 ± 0.5% | 859.09 ± 0.2% | 15.77 ± 1.0% | 653.70 ± 2.4% | refused | 23911.14 ± 0.2% | 518.24 ± 0.2% | 0.93 | 1.00 | 32.85 | 0.79 |
| literal: an href attribute | 12 | 350.82 ± 0.9% | 361.85 ± 0.8% | 472.20 ± 0.9% | 9.39 ± 37.3% | 497.47 ± 1.5% | 756.62 ± 4.6% | 22497.79 ± 0.1% | 351.11 ± 0.7% | 0.97 | 1.00 | 37.36 | 0.71 |
| literal: a word, second text | 10 | 587.21 ± 0.5% | 646.37 ± 0.7% | 1076.99 ± 0.7% | 418.03 ± 0.2% | 533.32 ± 2.0% | 814.01 ± 0.9% | 27798.04 ± 0.6% | 586.87 ± 0.3% | 0.91 | 1.00 | 1.40 | 1.10 |
| class: two capitalized words | 23 | 450.51 ± 0.4% | 478.32 ± 0.6% | 686.03 ± 0.8% | 100.24 ± 0.1% | 494.48 ± 2.6% | 748.84 ± 0.7% | 6646.90 ± 0.4% | 451.47 ± 0.6% | 0.94 | 1.00 | 4.49 | 0.91 |
| class: a word that ends in ing | 9 | 593.50 ± 0.8% | 660.06 ± 0.9% | 1154.14 ± 0.2% | 132.37 ± 0.8% | 752.02 ± 1.0% | 1099.88 ± 2.1% | 16318.84 ± 0.1% | 594.87 ± 0.6% | 0.90 | 1.00 | 4.48 | 0.79 |
| class: a word in capitals | 16 | 514.76 ± 0.3% | 553.32 ± 0.6% | 875.76 ± 0.4% | 134.57 ± 1.4% | 754.43 ± 0.8% | 1025.29 ± 2.6% | 8737.25 ± 1.1% | 514.98 ± 0.7% | 0.93 | 1.00 | 3.83 | 0.68 |
| class: a number | 6 | 657.30 ± 0.3% | 717.46 ± 0.6% | 1335.87 ± 0.1% | 41.78 ± 0.6% | 1412.81 ± 5.0% | 1892.45 ± 2.3% | 23320.52 ± 0.2% | 658.03 ± 0.1% | 0.92 | 1.00 | 15.73 | 0.47 |
| class: two capitalized words, second text | 23 | 451.10 ± 0.5% | 479.68 ± 0.2% | 686.92 ± 0.3% | 102.21 ± 0.4% | 491.68 ± 3.5% | 730.59 ± 0.2% | 6648.89 ± 0.8% | 451.01 ± 0.3% | 0.94 | 1.00 | 4.41 | 0.92 |
| other: a word between two words | 13 | 574.23 ± 0.2% | 592.99 ± 0.3% | 939.83 ± 0.4% | 134.91 ± 0.7% | 497.36 ± 1.5% | 806.79 ± 0.8% | 15103.29 ± 0.1% | 573.64 ± 0.4% | 0.97 | 1.00 | 4.26 | 1.15 |
| other: a number before a unit, second text | 15 | 402.23 ± 0.5% | 435.73 ± 0.3% | 600.29 ± 0.3% | 39.41 ± 0.4% | 629.63 ± 10.5% | 884.83 ± 0.2% | 15416.01 ± 0.2% | 402.19 ± 0.4% | 0.92 | 1.00 | 10.21 | 0.64 |
| other: a heading's start tag | 13 | 360.32 ± 0.6% | 365.06 ± 0.7% | 476.37 ± 0.4% | 9.31 ± 10.3% | 620.13 ± 1.1% | 877.42 ± 1.1% | 18575.18 ± 0.4% | 360.11 ± 0.4% | 0.99 | 1.00 | 38.68 | 0.58 |
| other: a whole word | 11 | 607.96 ± 0.2% | 643.83 ± 0.5% | 1073.68 ± 0.6% | 119.30 ± 0.3% | 556.17 ± 1.6% | 834.50 ± 0.5% | 27300.75 ± 0.3% | 608.41 ± 0.5% | 0.94 | 1.00 | 5.10 | 1.09 |
| other: a line's first word, second text | 17 | 553.13 ± 0.5% | 574.29 ± 0.5% | 921.27 ± 0.3% | 128.16 ± 0.2% | 698.25 ± 1.2% | refused | refused | 551.54 ± 1.3% | 0.96 | 1.00 | 4.32 | 0.79 |
| other: fourteen octets before an x | 16 | 112.86 ± 0.7% | 162.75 ± 1.1% | 186.06 ± 1.5% | 6.61 ± 12.5% | 445.39 ± 9.6% | 416.72 ± 0.5% | 12836.72 ± 0.9% | 112.82 ± 0.3% | 0.69 | 1.00 | 17.08 | 0.25 |
| other: a Greek word | 8 | 447.18 ± 0.2% | 587.47 ± 0.4% | 953.30 ± 0.1% | 10.73 ± 28.7% | 1375.67 ± 1.3% | 1808.10 ± 0.6% | refused | 446.92 ± 0.2% | 0.76 | 1.00 | 41.68 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12682.01 ± 0.8% | not timed | not timed | 16095.18 ± 2.5% | 1970.88 ± 16.7% | not timed | not timed | 12671.75 ± 0.6% | | 1.00 | 0.79 | 6.43 |
| 01-literal/sherlock-casei-en | 522 | 4481.68 ± 0.9% | not timed | not timed | 3577.06 ± 0.2% | 32.50 ± 0.2% | not timed | not timed | 4471.27 ± 0.6% | | 1.00 | 1.25 | 137.89 |
| 01-literal/sherlock-ru | 724 | 13504.93 ± 0.7% | not timed | not timed | 17269.64 ± 0.8% | 1518.96 ± 16.8% | not timed | not timed | 13500.93 ± 0.3% | | 1.00 | 0.78 | 8.89 |
| 01-literal/sherlock-casei-ru | 746 | 5285.68 ± 0.6% | not timed | not timed | 3327.30 ± 0.1% | 31.30 ± 1.2% | not timed | not timed | 5274.14 ± 0.3% | | 1.00 | 1.59 | 168.88 |
| 01-literal/sherlock-zh | 30 | 16593.24 ± 0.7% | not timed | not timed | 18278.60 ± 0.5% | 2584.46 ± 16.7% | not timed | not timed | 16564.50 ± 0.8% | | 1.00 | 0.91 | 6.42 |
| 02-literal-alternate/sherlock-en | 714 | 5737.83 ± 0.7% | not timed | not timed | 3936.69 ± 0.4% | 16.60 ± 0.1% | not timed | not timed | 5740.60 ± 0.2% | | 1.00 | 1.46 | 345.61 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.76 ± 1.1% | not timed | not timed | 694.43 ± 0.2% | 11.12 ± 12.5% | not timed | not timed | 1706.52 ± 1.0% | | 1.00 | 2.47 | 154.01 |
| 02-literal-alternate/sherlock-ru | 899 | 4635.41 ± 0.1% | not timed | not timed | 3250.95 ± 0.3% | 22.59 ± 0.1% | not timed | not timed | 4633.16 ± 0.4% | | 1.00 | 1.43 | 205.18 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1810.09 ± 0.5% | not timed | not timed | 1230.19 ± 0.1% | 8.91 ± 0.4% | not timed | not timed | 1801.24 ± 0.7% | | 1.00 | 1.47 | 203.08 |
| 02-literal-alternate/sherlock-zh | 207 | 7031.32 ± 0.3% | not timed | not timed | 4169.88 ± 0.2% | 31.49 ± 0.2% | not timed | not timed | 7040.27 ± 0.3% | | 1.00 | 1.69 | 223.25 |
| 03-date/ascii | 111817 | 127.51 ± 0.8% | not timed | not timed | 96.23 ± 0.1% | 0.20 ± 3.0% | not timed | not timed | 126.67 ± 0.5% | | 1.01 | 1.33 | 635.29 |
| 04-ruff-noqa/real | 84 | 553.38 ± 0.0% | not timed | not timed | 462.93 ± 0.1% | 19.53 ± 0.1% | not timed | not timed | 553.25 ± 0.1% | | 1.00 | 1.20 | 28.34 |
| 04-ruff-noqa/tweaked | 44 | 546.63 ± 0.2% | not timed | not timed | 462.52 ± 0.0% | 365.21 ± 0.8% | not timed | not timed | 545.08 ± 0.2% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.97 ± 0.2% | not timed | not timed | 5.08 ± 0.1% | 0.20 ± 3.5% | not timed | not timed | 4.16 ± 3.1% | | 0.95 | 0.78 | 19.46 |
| 06-cloud-flare-redos/original | 107 | 264.05 ± 0.2% | not timed | not timed | 215.45 ± 0.3% | 24.89 ± 0.1% | not timed | not timed | 263.34 ± 0.1% | | 1.00 | 1.23 | 10.61 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.05 ± 0.3% | not timed | not timed | 228.53 ± 0.2% | 26.66 ± 0.2% | not timed | not timed | 259.20 ± 0.3% | | 1.00 | 1.13 | 9.72 |
| 06-cloud-flare-redos/simplified-long | 10000 | 285.51 ± 0.2% | not timed | not timed | 253.32 ± 0.3% | 28.72 ± 0.1% | not timed | not timed | 286.35 ± 0.3% | | 1.00 | 1.13 | 9.94 |
| 07-unicode-character-data/parse-line | 558784 | 239.95 ± 0.4% | not timed | not timed | 171.61 ± 0.4% | 40.40 ± 20.3% | not timed | not timed | 239.08 ± 2.7% | | 1.00 | 1.40 | 5.94 |
| 08-words/all-english | 56691 | 121.22 ± 0.4% | not timed | not timed | 82.88 ± 0.1% | 11.66 ± 4.3% | not timed | not timed | 120.71 ± 0.7% | | 1.00 | 1.46 | 10.40 |
| 08-words/long-english | 839 | 1007.10 ± 0.2% | not timed | not timed | 596.53 ± 0.1% | 32.40 ± 0.7% | not timed | not timed | 1006.66 ± 0.3% | | 1.00 | 1.69 | 31.08 |
| 09-aws-keys/full | 0 | 409.63 ± 0.1% | not timed | not timed | 460.25 ± 0.0% | 64.35 ± 0.1% | not timed | not timed | 409.22 ± 0.1% | | 1.00 | 0.89 | 6.37 |
| 09-aws-keys/quick | 0 | 735.39 ± 0.2% | not timed | not timed | 972.10 ± 0.2% | 414.81 ± 0.7% | not timed | not timed | 732.46 ± 0.4% | | 1.00 | 0.76 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 640.44 ± 0.5% | not timed | not timed | 514.98 ± 0.6% | 19.47 ± 0.4% | not timed | not timed | 638.18 ± 0.1% | | 1.00 | 1.24 | 32.90 |
| 10-bounded-repeat/letters-ru | 3475 | 384.61 ± 0.1% | not timed | not timed | 478.26 ± 0.1% | 22.56 ± 16.9% | not timed | not timed | 383.36 ± 0.5% | | 1.00 | 0.80 | 17.05 |
| 10-bounded-repeat/context | 53 | 78.50 ± 0.9% | not timed | not timed | 65.54 ± 0.6% | 19.13 ± 0.2% | not timed | not timed | 78.55 ± 1.2% | | 1.00 | 1.20 | 4.10 |
| 10-bounded-repeat/capitals | 11 | 1041.27 ± 0.2% | not timed | not timed | 618.24 ± 0.0% | 36.59 ± 0.1% | not timed | not timed | 1041.18 ± 0.1% | | 1.00 | 1.68 | 28.46 |
| 11-unstructured-to-json/extract | 600 | 49.74 ± 0.1% | not timed | not timed | 77.41 ± 0.2% | 49.02 ± 0.5% | not timed | not timed | 49.50 ± 1.0% | | 1.00 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 566.88 ± 0.3% | not timed | not timed | 560.24 ± 0.0% | 0.40 ± 0.1% | not timed | not timed | 566.67 ± 0.2% | | 1.00 | 1.01 | 1405.41 |
| 14-quadratic/1x | 100 | 9.36 ± 0.9% | not timed | not timed | 10.00 ± 0.2% | 0.96 ± 2.5% | not timed | not timed | 9.35 ± 1.4% | | 1.00 | 0.94 | 9.72 |
| 14-quadratic/2x | 200 | 5.57 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.5% | not timed | not timed | 5.57 ± 1.0% | | 1.00 | 1.00 | 10.47 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.26 ± 0.6% | | 1.00 | 1.04 | 10.93 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.2% | not timed | not timed | 0.34 ± 0.9% | 0.54 ± 1.8% | not timed | not timed | 1.54 ± 1.9% | | 1.01 | 4.54 | 2.86 |
| 04-ruff-noqa/compile-real | 1 | 86.93 ± 0.2% | not timed | not timed | 13.83 ± 0.3% | 138.80 ± 3.0% | not timed | not timed | 86.83 ± 0.7% | | 1.00 | 6.29 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 14.32 ± 1.1% | not timed | not timed | 2.52 ± 0.4% | 6.34 ± 2.0% | not timed | not timed | 14.28 ± 0.3% | | 1.00 | 5.68 | 2.26 |
| 07-unicode-character-data/compile | 1 | 55.44 ± 0.3% | not timed | not timed | 25.80 ± 0.3% | 35.56 ± 4.1% | not timed | not timed | 55.34 ± 1.0% | | 1.00 | 2.15 | 1.56 |
| 09-aws-keys/compile-full | 1 | 42.37 ± 0.2% | not timed | not timed | 8.25 ± 0.1% | 23.20 ± 1.8% | not timed | not timed | 42.33 ± 0.9% | | 1.00 | 5.14 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 189.13 ± 0.3% | not timed | not timed | 47.43 ± 0.3% | 132.50 ± 1.6% | not timed | not timed | 188.06 ± 1.2% | | 1.01 | 3.99 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.73 ± 0.5% | not timed | not timed | 11.16 ± 0.4% | 15.70 ± 10.7% | not timed | not timed | 14.57 ± 1.5% | | 1.01 | 1.32 | 0.94 |
| 10-bounded-repeat/compile-capitals | 1 | 85.08 ± 1.2% | not timed | not timed | 8.14 ± 0.3% | 23.62 ± 1.6% | not timed | not timed | 83.96 ± 1.6% | | 1.01 | 10.45 | 3.60 |
| 11-unstructured-to-json/compile | 1 | 86.77 ± 0.4% | not timed | not timed | 40.41 ± 0.7% | 67.17 ± 2.9% | not timed | not timed | 86.21 ± 0.8% | | 1.01 | 2.15 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 8.5% | 0.09 ± 18.3% | not timed | not timed | 0.35 ± 2.4% | | 1.02 | 5.19 | 3.76 |

