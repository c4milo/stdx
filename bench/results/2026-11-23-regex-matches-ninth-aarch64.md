# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127352497 |
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
| literal: a word | 217 | 15939.83 ± 1.3% | 1038.27 ± 0.2% | 28.66 ± 0.4% | 17690.14 ± 1.8% | 8936.97 ± 9.5% | 16.81 ± 0.4% | 86.13 ± 0.2% | 15947.16 ± 6.2% | 15.35 | 1.00 | 0.90 | 1.78 |
| literal: a word that is not there | 0 | 18453.18 ± 2.7% | 1047.16 ± 0.2% | 28.75 ± 0.4% | 19571.76 ± 3.4% | 28684.09 ± 2.8% | 16.77 ± 0.2% | 82.10 ± 0.3% | 18466.16 ± 2.0% | 17.62 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6057.31 ± 0.7% | 1020.25 ± 0.1% | 14.74 ± 0.3% | 3936.49 ± 0.3% | 21.89 ± 0.1% | 5.23 ± 0.0% | 6.73 ± 0.3% | 6042.49 ± 0.3% | 5.94 | 1.00 | 1.54 | 276.75 |
| literal: a word in any case | 217 | 12574.25 ± 1.0% | 1037.02 ± 0.2% | 21.96 ± 2.2% | 3964.71 ± 0.6% | 38.03 ± 0.5% | refused | differs | 12527.29 ± 0.8% | 12.13 | 1.00 | 3.17 | 330.63 |
| literal: an href attribute | 33 | 13631.62 ± 0.9% | 1045.66 ± 0.2% | 27.48 ± 0.2% | 16646.51 ± 5.3% | 2254.09 ± 3.5% | 13.13 ± 0.3% | 75.60 ± 0.3% | 13643.63 ± 1.7% | 13.04 | 1.00 | 0.82 | 6.05 |
| literal: a word, second text | 123 | 16283.52 ± 2.2% | 1042.75 ± 0.2% | 28.32 ± 0.4% | 18399.81 ± 2.0% | 7633.75 ± 4.1% | 17.99 ± 0.5% | 69.74 ± 0.3% | 16460.38 ± 2.5% | 15.62 | 0.99 | 0.88 | 2.13 |
| class: two capitalized words | 1331 | 1126.62 ± 0.1% | 976.65 ± 0.2% | 26.14 ± 0.2% | 585.11 ± 0.1% | 40.49 ± 2.4% | 14.40 ± 0.4% | 68.58 ± 0.5% | 1125.41 ± 0.6% | 1.15 | 1.00 | 1.93 | 27.82 |
| class: a word that ends in ing | 3399 | 889.77 ± 0.1% | 889.86 ± 0.3% | 18.25 ± 0.2% | 547.65 ± 0.1% | 29.60 ± 9.3% | 7.78 ± 0.2% | 18.21 ± 0.3% | 888.42 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.05 |
| class: a word in capitals | 2332 | 1450.27 ± 0.3% | 949.12 ± 0.1% | 27.86 ± 0.3% | 571.99 ± 0.1% | 43.72 ± 0.2% | 16.34 ± 0.2% | 82.82 ± 0.2% | 1448.09 ± 0.6% | 1.53 | 1.00 | 2.54 | 33.17 |
| class: a number | 8288 | 1977.30 ± 0.5% | 827.96 ± 0.1% | 28.03 ± 0.1% | 1718.59 ± 0.1% | 40.88 ± 15.7% | 0.56 ± 0.0% | 56.64 ± 0.5% | 1991.21 ± 0.2% | 2.39 | 0.99 | 1.15 | 48.37 |
| class: two capitalized words, second text | 5359 | 737.35 ± 0.1% | 736.51 ± 0.2% | 23.43 ± 0.3% | 484.68 ± 0.1% | 32.86 ± 7.9% | 15.50 ± 0.1% | 63.64 ± 0.4% | 736.45 ± 0.1% | 1.00 | 1.00 | 1.52 | 22.44 |
| other: a word between two words | 6104 | 759.00 ± 0.2% | 763.27 ± 0.2% | 23.66 ± 0.2% | 739.48 ± 0.3% | 102.37 ± 16.7% | 11.02 ± 0.1% | 69.54 ± 0.2% | 756.33 ± 0.1% | 0.99 | 1.00 | 1.03 | 7.41 |
| other: a number before a unit, second text | 1481 | 5543.65 ± 0.3% | 982.75 ± 0.1% | 25.96 ± 0.3% | 5643.99 ± 0.4% | 40.72 ± 6.4% | 16.50 ± 0.2% | 66.73 ± 0.4% | 5533.42 ± 0.6% | 5.64 | 1.00 | 0.98 | 136.12 |
| other: a heading's start tag | 110 | 12418.81 ± 1.6% | 1036.40 ± 0.1% | 27.58 ± 0.2% | 1715.14 ± 0.5% | 1581.90 ± 0.7% | 15.89 ± 0.3% | 88.39 ± 0.2% | 12543.83 ± 1.6% | 11.98 | 0.99 | 7.24 | 7.85 |
| other: a whole word | 217 | 13838.87 ± 0.9% | 1038.10 ± 0.1% | 29.77 ± 0.8% | 14296.64 ± 0.8% | 49.43 ± 8.5% | 13.17 ± 0.3% | 55.78 ± 0.2% | 13800.96 ± 1.4% | 13.33 | 1.00 | 0.97 | 280.00 |
| other: a line's first word, second text | 3716 | 1960.47 ± 0.7% | 872.77 ± 0.1% | 31.30 ± 0.2% | 1721.14 ± 0.3% | 62.11 ± 6.0% | refused | refused | 1953.10 ± 0.8% | 2.25 | 1.00 | 1.14 | 31.56 |
| other: fourteen octets before an x | 87 | 19381.98 ± 2.4% | 235.56 ± 0.5% | 6.13 ± 0.1% | 3972.79 ± 0.3% | 10.62 ± 0.4% | differs | 17.66 ± 0.2% | 19463.66 ± 4.1% | 82.28 | 1.00 | 4.88 | 1825.02 |
| other: a Greek word | 21815 | 469.43 ± 0.5% | 357.62 ± 0.2% | 31.11 ± 0.1% | 289.33 ± 0.3% | 47.88 ± 13.6% | differs | refused | 467.85 ± 0.4% | 1.31 | 1.00 | 1.62 | 9.80 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.81 ± 0.2% | 25.82 ± 0.2% | 0.82 ± 0.3% | 19.72 ± 0.4% | 2.75 ± 0.7% | differs | 4.01 ± 0.2% | 25.84 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.37 |
| a UUID | 32895 | 21.08 ± 0.2% | 21.13 ± 0.1% | 0.65 ± 0.2% | 15.18 ± 0.4% | 3.10 ± 0.5% | 0.71 ± 0.3% | 3.61 ± 0.7% | 21.15 ± 0.1% | 1.00 | 1.00 | 1.39 | 6.79 |
| an IPv4 address | 33176 | 37.07 ± 0.2% | 36.76 ± 0.3% | 2.09 ± 0.1% | 28.97 ± 0.1% | 6.67 ± 0.7% | differs | 4.15 ± 0.2% | 37.04 ± 0.2% | 1.01 | 1.00 | 1.28 | 5.56 |
| a date and time | 32954 | 30.97 ± 0.3% | 31.12 ± 0.2% | 1.41 ± 0.3% | 21.15 ± 0.4% | 7.05 ± 0.2% | 1.20 ± 0.2% | 7.06 ± 0.3% | 31.03 ± 0.2% | 1.00 | 1.00 | 1.46 | 4.39 |
| a field path | 32606 | 29.52 ± 0.4% | 29.44 ± 0.5% | 1.01 ± 0.8% | 22.97 ± 0.3% | 3.53 ± 0.8% | differs | 2.92 ± 0.3% | 29.52 ± 0.1% | 1.00 | 1.00 | 1.29 | 8.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.5% | 11.49 ± 0.7% | 11.52 ± 0.8% | 11.35 ± 0.2% | 4.91 ± 1.2% | 0.91 ± 0.8% | none | 11.52 ± 0.3% | 1.00 | 1.00 | 1.01 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.62 ± 0.2% | 223.11 ± 0.2% | 259.39 ± 0.2% | 87.04 ± 0.4% | 218.53 ± 1.3% | 486.43 ± 0.3% | 3756.41 ± 0.4% | 222.58 ± 0.4% | 1.00 | 1.00 | 2.56 | 1.02 |
| a UUID | 62 | 145.86 ± 0.2% | 146.19 ± 0.2% | 161.35 ± 0.2% | 45.71 ± 0.1% | 98.99 ± 0.8% | 184.37 ± 0.8% | 4462.85 ± 1.1% | 145.81 ± 0.1% | 1.00 | 1.00 | 3.19 | 1.47 |
| an IPv4 address | 29 | 439.69 ± 0.2% | 444.06 ± 0.2% | 614.53 ± 0.3% | 76.62 ± 1.1% | 130.34 ± 1.5% | 293.40 ± 0.9% | 7715.47 ± 0.3% | 439.10 ± 0.3% | 0.99 | 1.00 | 5.74 | 3.37 |
| a date and time | 56 | 319.65 ± 0.3% | 320.47 ± 0.3% | 401.12 ± 0.4% | 72.10 ± 0.1% | 135.25 ± 2.1% | 320.93 ± 0.8% | 4981.89 ± 0.3% | 319.40 ± 0.1% | 1.00 | 1.00 | 4.43 | 2.36 |
| a field path | 39 | 208.98 ± 0.5% | 209.92 ± 0.5% | 241.75 ± 0.4% | 79.66 ± 0.3% | 201.70 ± 3.2% | 484.35 ± 0.6% | 4860.93 ± 0.3% | 208.81 ± 0.5% | 1.00 | 1.00 | 2.62 | 1.04 |
| literal: a word | 7 | 667.93 ± 0.2% | 717.18 ± 0.8% | 1279.90 ± 0.6% | 505.69 ± 1.7% | 618.29 ± 1.9% | 923.38 ± 0.9% | 30643.93 ± 0.3% | 667.62 ± 0.3% | 0.93 | 1.00 | 1.32 | 1.08 |
| literal: a word that is not there | 8 | 639.84 ± 0.2% | 693.91 ± 0.3% | 1204.76 ± 0.3% | 463.02 ± 0.2% | 595.14 ± 2.6% | 875.01 ± 0.7% | 29593.98 ± 0.1% | 639.68 ± 0.2% | 0.92 | 1.00 | 1.38 | 1.08 |
| literal: one of four words | 26 | 255.28 ± 0.6% | 420.59 ± 0.3% | 567.30 ± 0.3% | 49.43 ± 0.3% | 239.96 ± 2.5% | 355.17 ± 0.6% | 15768.97 ± 0.2% | 255.68 ± 0.3% | 0.61 | 1.00 | 5.16 | 1.06 |
| literal: a word in any case | 11 | 522.80 ± 0.3% | 564.94 ± 0.3% | 869.99 ± 0.4% | 15.79 ± 0.9% | 635.20 ± 2.1% | refused | 23825.06 ± 0.5% | 523.02 ± 0.2% | 0.93 | 1.00 | 33.12 | 0.82 |
| literal: an href attribute | 12 | 351.19 ± 0.2% | 363.35 ± 0.4% | 473.26 ± 0.5% | 10.09 ± 44.3% | 491.51 ± 1.5% | 764.52 ± 2.3% | 22407.48 ± 0.2% | 350.99 ± 0.4% | 0.97 | 1.00 | 34.82 | 0.71 |
| literal: a word, second text | 10 | 594.09 ± 0.3% | 654.04 ± 0.2% | 1093.83 ± 0.1% | 416.87 ± 0.2% | 530.18 ± 2.2% | 801.92 ± 0.7% | 27519.46 ± 0.2% | 593.62 ± 0.1% | 0.91 | 1.00 | 1.43 | 1.12 |
| class: two capitalized words | 23 | 461.71 ± 0.7% | 491.72 ± 0.3% | 710.49 ± 0.3% | 100.14 ± 0.4% | 500.24 ± 9.6% | 744.44 ± 0.9% | 6389.32 ± 0.1% | 462.06 ± 0.2% | 0.94 | 1.00 | 4.61 | 0.92 |
| class: a word that ends in ing | 9 | 600.24 ± 0.3% | 667.15 ± 0.5% | 1171.70 ± 0.4% | 132.19 ± 0.4% | 748.79 ± 1.3% | 1101.87 ± 1.1% | 15983.47 ± 0.1% | 599.91 ± 0.2% | 0.90 | 1.00 | 4.54 | 0.80 |
| class: a word in capitals | 16 | 525.75 ± 0.4% | 565.57 ± 0.4% | 902.79 ± 0.2% | 135.36 ± 0.3% | 742.06 ± 5.9% | 1015.90 ± 2.9% | 8398.76 ± 0.1% | 526.38 ± 0.7% | 0.93 | 1.00 | 3.88 | 0.71 |
| class: a number | 6 | 667.74 ± 0.7% | 730.59 ± 0.6% | 1364.65 ± 0.1% | 41.97 ± 0.7% | 1380.79 ± 11.7% | 1878.25 ± 0.7% | 23176.26 ± 0.1% | 667.98 ± 0.1% | 0.91 | 1.00 | 15.91 | 0.48 |
| class: two capitalized words, second text | 23 | 461.50 ± 0.4% | 490.72 ± 0.3% | 709.61 ± 0.6% | 101.36 ± 1.0% | 496.20 ± 0.5% | 766.76 ± 1.0% | 6389.01 ± 0.1% | 461.46 ± 0.2% | 0.94 | 1.00 | 4.55 | 0.93 |
| other: a word between two words | 13 | 581.79 ± 0.3% | 600.44 ± 0.5% | 958.39 ± 0.3% | 134.47 ± 0.7% | 493.42 ± 4.4% | 817.19 ± 0.8% | 14758.77 ± 0.1% | 581.32 ± 0.2% | 0.97 | 1.00 | 4.33 | 1.18 |
| other: a number before a unit, second text | 15 | 405.96 ± 0.3% | 441.75 ± 0.3% | 610.21 ± 0.1% | 39.42 ± 0.5% | 621.64 ± 2.1% | 891.97 ± 1.6% | 15359.95 ± 0.2% | 405.86 ± 0.1% | 0.92 | 1.00 | 10.30 | 0.65 |
| other: a heading's start tag | 13 | 363.09 ± 0.2% | 367.88 ± 0.2% | 479.30 ± 0.3% | 9.73 ± 2.8% | 615.97 ± 1.4% | 868.16 ± 0.4% | 18570.84 ± 0.2% | 363.44 ± 0.3% | 0.99 | 1.00 | 37.31 | 0.59 |
| other: a whole word | 11 | 614.63 ± 0.3% | 654.03 ± 0.1% | 1086.28 ± 0.2% | 120.76 ± 0.3% | 557.34 ± 2.7% | 815.83 ± 1.5% | 27005.53 ± 0.2% | 614.58 ± 0.5% | 0.94 | 1.00 | 5.09 | 1.10 |
| other: a line's first word, second text | 17 | 559.49 ± 0.4% | 581.23 ± 0.5% | 932.70 ± 0.2% | 128.57 ± 0.2% | 701.77 ± 0.4% | refused | refused | 558.36 ± 0.4% | 0.96 | 1.00 | 4.35 | 0.80 |
| other: fourteen octets before an x | 16 | 113.18 ± 0.6% | 163.37 ± 0.7% | 186.44 ± 0.9% | 6.50 ± 12.0% | 441.50 ± 1.8% | 428.31 ± 0.6% | 13043.86 ± 0.3% | 113.18 ± 0.7% | 0.69 | 1.00 | 17.41 | 0.26 |
| other: a Greek word | 8 | 449.79 ± 0.3% | 593.00 ± 0.3% | 962.62 ± 0.1% | 10.87 ± 20.0% | 1369.21 ± 2.1% | 1782.82 ± 0.5% | refused | 449.66 ± 0.2% | 0.76 | 1.00 | 41.39 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12764.01 ± 1.3% | not timed | not timed | 15965.36 ± 1.6% | 2135.81 ± 13.8% | not timed | not timed | 12739.52 ± 1.0% | | 1.00 | 0.80 | 5.98 |
| 01-literal/sherlock-casei-en | 522 | 3880.93 ± 0.7% | not timed | not timed | 3578.06 ± 0.1% | 32.53 ± 0.3% | not timed | not timed | 3857.14 ± 0.5% | | 1.01 | 1.08 | 119.29 |
| 01-literal/sherlock-ru | 724 | 13592.35 ± 0.9% | not timed | not timed | 17236.77 ± 0.4% | 1339.69 ± 12.9% | not timed | not timed | 13593.25 ± 0.2% | | 1.00 | 0.79 | 10.15 |
| 01-literal/sherlock-casei-ru | 746 | 5231.31 ± 0.2% | not timed | not timed | 3323.97 ± 0.1% | 31.76 ± 0.3% | not timed | not timed | 5230.69 ± 0.1% | | 1.00 | 1.57 | 164.70 |
| 01-literal/sherlock-zh | 30 | 16839.91 ± 0.5% | not timed | not timed | 18299.43 ± 0.9% | 2584.84 ± 14.0% | not timed | not timed | 16774.74 ± 1.0% | | 1.00 | 0.92 | 6.51 |
| 02-literal-alternate/sherlock-en | 714 | 5816.92 ± 0.6% | not timed | not timed | 3940.57 ± 0.3% | 16.62 ± 0.3% | not timed | not timed | 5829.17 ± 0.2% | | 1.00 | 1.48 | 350.07 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1666.04 ± 0.7% | not timed | not timed | 696.83 ± 0.5% | 10.94 ± 1.4% | not timed | not timed | 1658.04 ± 0.3% | | 1.00 | 2.39 | 152.34 |
| 02-literal-alternate/sherlock-ru | 899 | 4624.16 ± 0.1% | not timed | not timed | 3257.30 ± 0.2% | 22.21 ± 0.1% | not timed | not timed | 4633.55 ± 0.2% | | 1.00 | 1.42 | 208.22 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1778.54 ± 0.8% | not timed | not timed | 1228.91 ± 0.1% | 9.15 ± 0.2% | not timed | not timed | 1771.07 ± 0.2% | | 1.00 | 1.45 | 194.48 |
| 02-literal-alternate/sherlock-zh | 207 | 7053.62 ± 0.6% | not timed | not timed | 4156.54 ± 2.0% | 31.51 ± 12.8% | not timed | not timed | 7049.03 ± 0.5% | | 1.00 | 1.70 | 223.83 |
| 03-date/ascii | 111817 | 124.67 ± 0.8% | not timed | not timed | 96.52 ± 0.1% | 0.20 ± 2.9% | not timed | not timed | 123.26 ± 0.2% | | 1.01 | 1.29 | 625.99 |
| 04-ruff-noqa/real | 84 | 554.93 ± 0.2% | not timed | not timed | 460.61 ± 0.1% | 19.58 ± 1.0% | not timed | not timed | 554.99 ± 0.1% | | 1.00 | 1.20 | 28.34 |
| 04-ruff-noqa/tweaked | 44 | 544.71 ± 0.2% | not timed | not timed | 459.82 ± 0.1% | 363.43 ± 1.0% | not timed | not timed | 543.88 ± 0.4% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.65 ± 0.8% | not timed | not timed | 5.06 ± 0.2% | 0.21 ± 3.7% | not timed | not timed | 3.69 ± 0.9% | | 0.99 | 0.72 | 17.80 |
| 06-cloud-flare-redos/original | 107 | 269.95 ± 0.2% | not timed | not timed | 217.69 ± 0.1% | 24.79 ± 0.2% | not timed | not timed | 269.18 ± 0.1% | | 1.00 | 1.24 | 10.89 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.38 ± 0.5% | not timed | not timed | 228.99 ± 0.4% | 26.62 ± 0.3% | not timed | not timed | 264.02 ± 0.5% | | 1.00 | 1.15 | 9.93 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.32 ± 0.2% | not timed | not timed | 254.66 ± 0.2% | 28.70 ± 0.4% | not timed | not timed | 294.17 ± 0.1% | | 1.00 | 1.16 | 10.25 |
| 07-unicode-character-data/parse-line | 558784 | 239.25 ± 2.0% | not timed | not timed | 166.38 ± 0.2% | 42.78 ± 4.3% | not timed | not timed | 240.25 ± 0.7% | | 1.00 | 1.44 | 5.59 |
| 08-words/all-english | 56691 | 119.55 ± 0.8% | not timed | not timed | 83.18 ± 0.1% | 12.72 ± 11.7% | not timed | not timed | 119.44 ± 0.5% | | 1.00 | 1.44 | 9.40 |
| 08-words/long-english | 839 | 1005.43 ± 0.2% | not timed | not timed | 595.47 ± 0.0% | 32.67 ± 0.3% | not timed | not timed | 1005.32 ± 0.1% | | 1.00 | 1.69 | 30.77 |
| 09-aws-keys/full | 0 | 412.91 ± 0.1% | not timed | not timed | 459.68 ± 0.2% | 64.26 ± 0.2% | not timed | not timed | 412.83 ± 0.1% | | 1.00 | 0.90 | 6.43 |
| 09-aws-keys/quick | 0 | 738.01 ± 0.1% | not timed | not timed | 994.02 ± 0.3% | 417.50 ± 0.6% | not timed | not timed | 733.97 ± 0.1% | | 1.01 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 636.91 ± 0.4% | not timed | not timed | 517.17 ± 1.1% | 19.49 ± 0.6% | not timed | not timed | 635.31 ± 0.4% | | 1.00 | 1.23 | 32.68 |
| 10-bounded-repeat/letters-ru | 3475 | 380.30 ± 0.3% | not timed | not timed | 477.21 ± 0.2% | 21.72 ± 9.6% | not timed | not timed | 379.83 ± 0.5% | | 1.00 | 0.80 | 17.51 |
| 10-bounded-repeat/context | 53 | 78.89 ± 0.9% | not timed | not timed | 65.36 ± 0.8% | 19.80 ± 0.3% | not timed | not timed | 78.93 ± 1.2% | | 1.00 | 1.21 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1044.83 ± 0.6% | not timed | not timed | 616.59 ± 0.0% | 36.61 ± 0.1% | not timed | not timed | 1044.60 ± 0.3% | | 1.00 | 1.69 | 28.54 |
| 11-unstructured-to-json/extract | 600 | 47.71 ± 0.2% | not timed | not timed | 77.58 ± 0.3% | 48.49 ± 1.0% | not timed | not timed | 47.02 ± 1.0% | | 1.01 | 0.61 | 0.98 |
| 12-dictionary/single | 1 | 571.11 ± 0.2% | not timed | not timed | 560.48 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 571.79 ± 0.1% | | 1.00 | 1.02 | 1419.38 |
| 14-quadratic/1x | 100 | 13.05 ± 0.5% | not timed | not timed | 10.00 ± 0.1% | 0.96 ± 3.8% | not timed | not timed | 13.02 ± 0.6% | | 1.00 | 1.30 | 13.54 |
| 14-quadratic/2x | 200 | 7.99 ± 0.2% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.2% | not timed | not timed | 7.96 ± 1.5% | | 1.00 | 1.44 | 15.00 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.54 | 16.13 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.34 ± 0.4% | 0.53 ± 5.1% | not timed | not timed | 1.54 ± 0.7% | | 1.00 | 4.52 | 2.90 |
| 04-ruff-noqa/compile-real | 1 | 87.09 ± 0.1% | not timed | not timed | 13.82 ± 0.1% | 136.81 ± 1.4% | not timed | not timed | 86.98 ± 1.0% | | 1.00 | 6.30 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 14.31 ± 0.1% | not timed | not timed | 2.52 ± 0.7% | 6.29 ± 1.7% | not timed | not timed | 14.27 ± 0.3% | | 1.00 | 5.67 | 2.27 |
| 07-unicode-character-data/compile | 1 | 55.20 ± 0.3% | not timed | not timed | 25.90 ± 0.2% | 35.21 ± 3.4% | not timed | not timed | 54.89 ± 1.4% | | 1.01 | 2.13 | 1.57 |
| 09-aws-keys/compile-full | 1 | 42.30 ± 0.1% | not timed | not timed | 8.28 ± 0.5% | 22.88 ± 1.7% | not timed | not timed | 42.03 ± 0.8% | | 1.01 | 5.11 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 190.20 ± 0.2% | not timed | not timed | 47.08 ± 0.2% | 129.62 ± 2.1% | not timed | not timed | 189.89 ± 1.0% | | 1.00 | 4.04 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 1.3% | not timed | not timed | 11.14 ± 0.7% | 15.82 ± 2.4% | not timed | not timed | 14.39 ± 2.5% | | 1.02 | 1.31 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 84.15 ± 0.3% | not timed | not timed | 8.09 ± 0.1% | 23.44 ± 1.5% | not timed | not timed | 84.91 ± 1.0% | | 0.99 | 10.40 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 86.57 ± 0.3% | not timed | not timed | 40.85 ± 0.4% | 67.04 ± 10.9% | not timed | not timed | 85.96 ± 1.4% | | 1.01 | 2.12 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.3% | not timed | not timed | 0.07 ± 1.3% | 0.09 ± 9.7% | not timed | not timed | 0.35 ± 1.7% | | 1.01 | 5.27 | 3.71 |

