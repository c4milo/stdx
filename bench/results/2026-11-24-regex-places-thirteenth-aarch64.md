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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507035927 |
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
| literal: a word | 217 | 19576.41 ± 0.6% | 5079.97 ± 0.2% | 28.36 ± 0.4% | 18216.77 ± 1.9% | 9215.86 ± 9.3% | 17.41 ± 0.2% | 86.22 ± 0.1% | 19612.80 ± 2.2% | 3.85 | 1.00 | 1.07 | 2.12 |
| literal: a word that is not there | 0 | 21741.67 ± 0.6% | 4942.37 ± 0.3% | 28.32 ± 1.1% | 19857.22 ± 1.6% | 29349.11 ± 0.5% | 17.22 ± 0.4% | 81.90 ± 0.2% | 21560.51 ± 0.6% | 4.40 | 1.01 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6434.17 ± 0.8% | 1974.26 ± 0.4% | 14.42 ± 0.1% | 3941.42 ± 0.2% | 21.90 ± 0.1% | 5.24 ± 0.1% | 6.76 ± 0.2% | 6437.45 ± 0.4% | 3.26 | 1.00 | 1.63 | 293.73 |
| literal: a word in any case | 217 | 15153.49 ± 0.6% | 2101.76 ± 0.2% | 21.50 ± 0.5% | 3973.82 ± 0.1% | 38.05 ± 0.7% | refused | differs | 15191.61 ± 0.3% | 7.21 | 1.00 | 3.81 | 398.27 |
| literal: an href attribute | 33 | 16983.22 ± 1.1% | 617.88 ± 0.5% | 27.25 ± 0.2% | 17198.55 ± 1.5% | 2258.31 ± 5.1% | 12.87 ± 7.9% | 75.41 ± 0.1% | 17049.90 ± 1.0% | 27.49 | 1.00 | 0.99 | 7.52 |
| literal: a word, second text | 123 | 20006.02 ± 1.8% | 3425.45 ± 0.3% | 27.99 ± 0.1% | 18563.51 ± 1.4% | 7628.43 ± 3.8% | 19.44 ± 0.4% | 69.80 ± 0.3% | 19928.34 ± 1.3% | 5.84 | 1.00 | 1.08 | 2.62 |
| class: two capitalized words | 1331 | 1066.90 ± 0.2% | 609.49 ± 0.1% | 26.01 ± 0.4% | 582.31 ± 0.1% | 40.62 ± 3.3% | 14.94 ± 0.5% | 68.41 ± 0.7% | 1064.31 ± 0.7% | 1.75 | 1.00 | 1.83 | 26.26 |
| class: a word that ends in ing | 3399 | 582.97 ± 0.1% | 582.63 ± 0.2% | 17.96 ± 0.3% | 545.07 ± 0.1% | 29.64 ± 12.6% | 8.16 ± 0.1% | 18.20 ± 0.1% | 583.56 ± 0.2% | 1.00 | 1.00 | 1.07 | 19.67 |
| class: a word in capitals | 2332 | 1392.39 ± 0.5% | 614.58 ± 0.2% | 27.57 ± 0.2% | 572.81 ± 0.3% | 43.55 ± 0.1% | 17.10 ± 0.2% | 82.69 ± 0.4% | 1389.04 ± 0.5% | 2.27 | 1.00 | 2.43 | 31.97 |
| class: a number | 8288 | 2130.24 ± 0.4% | 853.47 ± 0.4% | 27.76 ± 0.3% | 1729.76 ± 0.2% | 41.41 ± 7.6% | 0.57 ± 0.2% | 56.56 ± 0.5% | 2129.78 ± 0.2% | 2.50 | 1.00 | 1.23 | 51.44 |
| class: two capitalized words, second text | 5359 | 525.55 ± 0.1% | 534.85 ± 0.1% | 23.33 ± 0.1% | 486.07 ± 0.1% | 31.07 ± 12.3% | 16.86 ± 0.3% | 63.56 ± 0.2% | 525.93 ± 0.2% | 0.98 | 1.00 | 1.08 | 16.91 |
| other: a word between two words | 6104 | 809.56 ± 0.1% | 609.94 ± 0.2% | 23.56 ± 0.2% | 739.14 ± 0.3% | 102.52 ± 15.6% | 11.35 ± 0.2% | 69.47 ± 0.1% | 811.36 ± 0.1% | 1.33 | 1.00 | 1.10 | 7.90 |
| other: a number before a unit, second text | 1481 | 6171.59 ± 1.7% | 1133.33 ± 0.3% | 25.98 ± 0.3% | 5647.97 ± 0.9% | 40.76 ± 10.9% | 17.80 ± 0.4% | 66.84 ± 0.4% | 6174.91 ± 0.9% | 5.45 | 1.00 | 1.09 | 151.43 |
| other: a heading's start tag | 110 | 14229.59 ± 0.9% | 750.24 ± 0.1% | 27.35 ± 0.3% | 1710.16 ± 0.2% | 1586.26 ± 1.0% | 16.19 ± 0.5% | 88.46 ± 0.3% | 14297.53 ± 0.8% | 18.97 | 1.00 | 8.32 | 8.97 |
| other: a whole word | 217 | 16366.89 ± 0.5% | 608.58 ± 0.1% | 29.24 ± 0.3% | 14714.81 ± 1.4% | 47.93 ± 9.0% | 13.46 ± 0.3% | 55.64 ± 0.3% | 16376.43 ± 1.0% | 26.89 | 1.00 | 1.11 | 341.51 |
| other: a line's first word, second text | 3716 | 2101.86 ± 0.4% | 600.28 ± 0.1% | 30.98 ± 0.3% | 1736.23 ± 0.3% | 62.74 ± 5.0% | refused | refused | 2099.32 ± 0.5% | 3.50 | 1.00 | 1.21 | 33.50 |
| other: fourteen octets before an x | 87 | 24061.54 ± 2.1% | 239.66 ± 0.7% | 6.55 ± 0.1% | 4064.92 ± 0.8% | 10.62 ± 0.1% | differs | 17.47 ± 0.3% | 24332.26 ± 6.3% | 100.40 | 0.99 | 5.92 | 2265.01 |
| other: a Greek word | 21815 | 519.17 ± 0.3% | 425.90 ± 0.2% | 30.87 ± 0.3% | 290.38 ± 0.3% | 49.69 ± 12.6% | differs | refused | 522.28 ± 0.3% | 1.22 | 0.99 | 1.79 | 10.45 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.31 ± 0.3% | 29.26 ± 0.2% | 0.86 ± 0.3% | 19.52 ± 0.4% | 2.75 ± 10.6% | differs | 4.01 ± 0.3% | 29.23 ± 0.2% | 1.00 | 1.00 | 1.50 | 10.65 |
| a UUID | 32895 | 24.65 ± 0.0% | 24.62 ± 0.1% | 0.64 ± 0.1% | 15.09 ± 0.4% | 3.11 ± 0.1% | 0.71 ± 0.2% | 3.60 ± 0.4% | 24.77 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.92 |
| an IPv4 address | 33176 | 38.46 ± 0.3% | 38.42 ± 0.2% | 2.08 ± 0.1% | 28.85 ± 0.3% | 6.66 ± 0.2% | differs | 4.15 ± 0.1% | 38.46 ± 0.2% | 1.00 | 1.00 | 1.33 | 5.77 |
| a date and time | 32954 | 34.34 ± 0.1% | 34.12 ± 0.2% | 1.45 ± 0.2% | 21.30 ± 0.3% | 7.05 ± 0.2% | 1.19 ± 0.2% | 7.07 ± 0.1% | 34.26 ± 0.1% | 1.01 | 1.00 | 1.61 | 4.87 |
| a field path | 32606 | 32.53 ± 0.2% | 32.51 ± 0.0% | 1.02 ± 0.2% | 23.06 ± 0.3% | 3.54 ± 0.4% | differs | 2.92 ± 0.2% | 32.50 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.19 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.09 ± 0.5% | 11.05 ± 0.1% | 11.13 ± 0.2% | 11.30 ± 0.1% | 4.95 ± 2.0% | 0.90 ± 0.9% | none | 11.08 ± 0.3% | 1.00 | 1.00 | 0.98 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.98 ± 0.4% | 232.03 ± 0.2% | 273.18 ± 0.3% | 87.30 ± 0.2% | 220.73 ± 1.6% | 485.13 ± 0.7% | 3729.01 ± 2.1% | 231.52 ± 0.5% | 1.00 | 1.00 | 2.66 | 1.05 |
| a UUID | 62 | 149.82 ± 0.4% | 149.91 ± 0.4% | 166.75 ± 0.2% | 46.11 ± 0.5% | 99.68 ± 1.4% | 183.10 ± 0.8% | 4454.62 ± 1.0% | 150.00 ± 0.4% | 1.00 | 1.00 | 3.25 | 1.50 |
| an IPv4 address | 29 | 420.90 ± 0.2% | 421.60 ± 0.3% | 583.20 ± 0.3% | 77.13 ± 1.3% | 131.43 ± 2.1% | 293.37 ± 0.6% | 7626.14 ± 0.5% | 421.04 ± 0.3% | 1.00 | 1.00 | 5.46 | 3.20 |
| a date and time | 56 | 302.64 ± 0.3% | 302.48 ± 0.4% | 376.32 ± 0.2% | 72.61 ± 0.6% | 136.01 ± 1.3% | 320.24 ± 1.9% | 4939.13 ± 0.7% | 302.35 ± 0.3% | 1.00 | 1.00 | 4.17 | 2.23 |
| a field path | 39 | 224.14 ± 0.3% | 224.26 ± 0.6% | 262.38 ± 0.4% | 79.59 ± 0.1% | 203.91 ± 1.4% | 495.77 ± 1.5% | 4843.08 ± 0.5% | 223.93 ± 0.3% | 1.00 | 1.00 | 2.82 | 1.10 |
| literal: a word | 7 | 617.36 ± 0.3% | 665.55 ± 0.6% | 1175.49 ± 0.4% | 521.21 ± 0.1% | 630.55 ± 2.1% | 923.87 ± 0.5% | 30281.80 ± 0.3% | 617.39 ± 0.7% | 0.93 | 1.00 | 1.18 | 0.98 |
| literal: a word that is not there | 8 | 595.66 ± 0.6% | 650.93 ± 0.6% | 1113.43 ± 0.6% | 468.21 ± 0.4% | 601.41 ± 0.8% | 876.03 ± 0.2% | 29172.04 ± 0.1% | 595.81 ± 0.2% | 0.92 | 1.00 | 1.27 | 0.99 |
| literal: one of four words | 26 | 246.29 ± 0.4% | 395.51 ± 0.5% | 534.60 ± 0.2% | 49.49 ± 1.5% | 242.40 ± 2.4% | 359.98 ± 2.4% | 15558.81 ± 0.1% | 246.75 ± 0.2% | 0.62 | 1.00 | 4.98 | 1.02 |
| literal: a word in any case | 11 | 447.36 ± 0.3% | 477.94 ± 0.4% | 696.43 ± 0.1% | 15.67 ± 0.4% | 652.71 ± 1.2% | refused | 23635.65 ± 0.5% | 447.77 ± 0.2% | 0.94 | 1.00 | 28.55 | 0.69 |
| literal: an href attribute | 12 | 340.57 ± 0.4% | 352.28 ± 0.3% | 458.00 ± 0.3% | 45.17 ± 1.4% | 500.74 ± 1.0% | 777.35 ± 0.5% | 21649.90 ± 0.3% | 340.74 ± 0.3% | 0.97 | 1.00 | 7.54 | 0.68 |
| literal: a word, second text | 10 | 551.90 ± 0.5% | 610.45 ± 0.4% | 1003.06 ± 0.5% | 412.53 ± 4.1% | 537.43 ± 1.0% | 800.35 ± 0.6% | 26978.64 ± 0.1% | 552.53 ± 0.4% | 0.90 | 1.00 | 1.34 | 1.03 |
| class: two capitalized words | 23 | 435.28 ± 0.8% | 463.24 ± 1.0% | 661.93 ± 1.0% | 101.56 ± 0.1% | 505.03 ± 0.8% | 740.68 ± 1.0% | 6355.48 ± 0.1% | 434.98 ± 0.2% | 0.94 | 1.00 | 4.29 | 0.86 |
| class: a word that ends in ing | 9 | 549.40 ± 0.4% | 617.91 ± 0.3% | 1059.67 ± 0.1% | 133.09 ± 0.6% | 760.36 ± 0.9% | 1108.38 ± 1.1% | 15782.38 ± 0.1% | 549.11 ± 0.2% | 0.89 | 1.00 | 4.13 | 0.72 |
| class: a word in capitals | 16 | 490.84 ± 0.3% | 530.24 ± 0.2% | 830.17 ± 0.4% | 137.14 ± 1.3% | 754.43 ± 0.2% | 1027.34 ± 0.8% | 8363.29 ± 0.1% | 490.99 ± 0.3% | 0.93 | 1.00 | 3.58 | 0.65 |
| class: a number | 6 | 628.04 ± 0.2% | 687.04 ± 0.3% | 1263.03 ± 0.2% | 41.88 ± 1.1% | 1409.01 ± 1.2% | 1879.18 ± 1.0% | 22798.12 ± 0.0% | 627.98 ± 0.3% | 0.91 | 1.00 | 14.99 | 0.45 |
| class: two capitalized words, second text | 23 | 435.02 ± 0.1% | 463.29 ± 0.3% | 661.77 ± 0.5% | 101.06 ± 2.0% | 505.88 ± 0.8% | 768.40 ± 0.8% | 6356.29 ± 0.1% | 434.74 ± 1.0% | 0.94 | 1.00 | 4.30 | 0.86 |
| other: a word between two words | 13 | 533.13 ± 0.5% | 553.48 ± 0.2% | 868.40 ± 0.1% | 135.88 ± 0.2% | 500.68 ± 6.5% | 818.16 ± 1.7% | 14652.31 ± 0.1% | 533.08 ± 0.2% | 0.96 | 1.00 | 3.92 | 1.06 |
| other: a number before a unit, second text | 15 | 392.38 ± 0.2% | 434.40 ± 0.3% | 605.05 ± 0.4% | 39.52 ± 1.0% | 631.11 ± 0.9% | 887.67 ± 0.6% | 15234.01 ± 0.1% | 392.76 ± 0.1% | 0.90 | 1.00 | 9.93 | 0.62 |
| other: a heading's start tag | 13 | 350.84 ± 0.5% | 358.08 ± 0.4% | 468.10 ± 0.3% | 43.25 ± 0.5% | 630.17 ± 10.7% | 860.97 ± 0.4% | 18056.13 ± 0.1% | 350.35 ± 0.3% | 0.98 | 1.00 | 8.11 | 0.56 |
| other: a whole word | 11 | 574.78 ± 0.4% | 616.38 ± 0.5% | 1012.25 ± 0.1% | 120.46 ± 1.1% | 562.44 ± 1.9% | 831.55 ± 0.5% | 26661.97 ± 0.2% | 574.63 ± 0.3% | 0.93 | 1.00 | 4.77 | 1.02 |
| other: a line's first word, second text | 17 | 515.53 ± 0.3% | 545.23 ± 0.2% | 863.05 ± 0.5% | 129.44 ± 0.6% | 710.56 ± 0.5% | refused | refused | 515.37 ± 0.9% | 0.95 | 1.00 | 3.98 | 0.73 |
| other: fourteen octets before an x | 16 | 107.85 ± 0.4% | 154.13 ± 0.5% | 175.38 ± 0.6% | 15.22 ± 0.3% | 453.96 ± 1.4% | 413.18 ± 0.5% | 12675.82 ± 0.2% | 108.05 ± 0.4% | 0.70 | 1.00 | 7.09 | 0.24 |
| other: a Greek word | 8 | 448.11 ± 0.3% | 588.14 ± 0.1% | 974.18 ± 0.2% | 59.16 ± 0.5% | 1389.17 ± 0.7% | 1839.39 ± 0.4% | refused | 448.47 ± 0.2% | 0.76 | 1.00 | 7.57 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15922.60 ± 0.7% | not timed | not timed | 16281.55 ± 0.9% | 1938.08 ± 16.5% | not timed | not timed | 15866.70 ± 0.7% | | 1.00 | 0.98 | 8.22 |
| 01-literal/sherlock-casei-en | 522 | 11157.86 ± 5.4% | not timed | not timed | 3594.46 ± 0.1% | 32.51 ± 0.3% | not timed | not timed | 11148.53 ± 3.3% | | 1.00 | 3.10 | 343.19 |
| 01-literal/sherlock-ru | 724 | 17214.20 ± 0.7% | not timed | not timed | 17323.67 ± 0.4% | 1480.46 ± 11.9% | not timed | not timed | 17233.24 ± 1.1% | | 1.00 | 0.99 | 11.63 |
| 01-literal/sherlock-casei-ru | 746 | 6143.17 ± 0.4% | not timed | not timed | 3323.67 ± 0.1% | 31.23 ± 0.3% | not timed | not timed | 6139.05 ± 0.4% | | 1.00 | 1.85 | 196.71 |
| 01-literal/sherlock-zh | 30 | 19827.88 ± 0.7% | not timed | not timed | 18657.51 ± 0.6% | 2868.02 ± 16.1% | not timed | not timed | 19832.62 ± 0.3% | | 1.00 | 1.06 | 6.91 |
| 02-literal-alternate/sherlock-en | 714 | 6169.38 ± 0.3% | not timed | not timed | 3939.95 ± 0.2% | 16.40 ± 0.3% | not timed | not timed | 6164.39 ± 0.2% | | 1.00 | 1.57 | 376.18 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1969.48 ± 1.2% | not timed | not timed | 698.48 ± 0.4% | 10.80 ± 0.2% | not timed | not timed | 1975.86 ± 0.8% | | 1.00 | 2.82 | 182.36 |
| 02-literal-alternate/sherlock-ru | 899 | 5545.49 ± 0.3% | not timed | not timed | 3253.85 ± 0.2% | 22.63 ± 21.8% | not timed | not timed | 5533.84 ± 0.2% | | 1.00 | 1.70 | 245.08 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.50 ± 0.5% | not timed | not timed | 1231.61 ± 0.6% | 9.14 ± 0.3% | not timed | not timed | 2056.92 ± 0.5% | | 1.00 | 1.67 | 225.09 |
| 02-literal-alternate/sherlock-zh | 207 | 7337.83 ± 0.3% | not timed | not timed | 4168.01 ± 0.1% | 31.45 ± 0.3% | not timed | not timed | 7341.16 ± 0.4% | | 1.00 | 1.76 | 233.31 |
| 03-date/ascii | 111817 | 133.54 ± 1.3% | not timed | not timed | 95.74 ± 0.1% | 0.20 ± 4.5% | not timed | not timed | 134.52 ± 1.2% | | 0.99 | 1.39 | 658.63 |
| 04-ruff-noqa/real | 84 | 435.64 ± 0.1% | not timed | not timed | 461.20 ± 0.1% | 19.65 ± 0.1% | not timed | not timed | 435.27 ± 0.1% | | 1.00 | 0.94 | 22.17 |
| 04-ruff-noqa/tweaked | 44 | 594.96 ± 0.3% | not timed | not timed | 457.52 ± 0.1% | 363.88 ± 0.4% | not timed | not timed | 594.83 ± 0.2% | | 1.00 | 1.30 | 1.64 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.2% | not timed | not timed | 5.10 ± 0.1% | 0.20 ± 3.3% | not timed | not timed | 5.50 ± 0.9% | | 0.97 | 1.05 | 26.15 |
| 06-cloud-flare-redos/original | 107 | 426.69 ± 0.1% | not timed | not timed | 213.68 ± 0.1% | 24.85 ± 0.6% | not timed | not timed | 430.88 ± 0.1% | | 0.99 | 2.00 | 17.17 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.06 ± 0.1% | not timed | not timed | 228.02 ± 0.1% | 26.71 ± 0.1% | not timed | not timed | 431.22 ± 0.1% | | 1.00 | 1.89 | 16.14 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.69 ± 0.1% | not timed | not timed | 254.43 ± 0.1% | 28.72 ± 0.1% | not timed | not timed | 588.74 ± 0.1% | | 1.00 | 2.31 | 20.50 |
| 07-unicode-character-data/parse-line | 558784 | 234.17 ± 2.4% | not timed | not timed | 172.51 ± 0.1% | 43.07 ± 4.4% | not timed | not timed | 235.22 ± 1.9% | | 1.00 | 1.36 | 5.44 |
| 08-words/all-english | 56691 | 127.72 ± 0.9% | not timed | not timed | 82.90 ± 0.1% | 12.49 ± 10.3% | not timed | not timed | 127.80 ± 0.7% | | 1.00 | 1.54 | 10.22 |
| 08-words/long-english | 839 | 622.86 ± 0.0% | not timed | not timed | 595.48 ± 0.1% | 32.34 ± 0.3% | not timed | not timed | 623.57 ± 0.2% | | 1.00 | 1.05 | 19.26 |
| 09-aws-keys/full | 0 | 441.00 ± 0.1% | not timed | not timed | 451.80 ± 0.1% | 64.01 ± 0.2% | not timed | not timed | 438.62 ± 0.1% | | 1.01 | 0.98 | 6.89 |
| 09-aws-keys/quick | 0 | 875.05 ± 0.3% | not timed | not timed | 990.56 ± 0.4% | 419.19 ± 0.3% | not timed | not timed | 875.34 ± 0.3% | | 1.00 | 0.88 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 586.78 ± 2.4% | not timed | not timed | 517.21 ± 0.3% | 19.54 ± 0.3% | not timed | not timed | 584.54 ± 2.8% | | 1.00 | 1.13 | 30.03 |
| 10-bounded-repeat/letters-ru | 3475 | 505.85 ± 1.1% | not timed | not timed | 478.84 ± 0.2% | 22.19 ± 11.2% | not timed | not timed | 508.03 ± 1.5% | | 1.00 | 1.06 | 22.79 |
| 10-bounded-repeat/context | 53 | 85.07 ± 1.6% | not timed | not timed | 66.40 ± 0.5% | 19.82 ± 0.2% | not timed | not timed | 85.41 ± 1.4% | | 1.00 | 1.28 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 632.33 ± 8.1% | not timed | not timed | 618.80 ± 0.0% | 36.54 ± 0.1% | not timed | not timed | 634.50 ± 8.1% | | 1.00 | 1.02 | 17.30 |
| 11-unstructured-to-json/extract | 600 | 57.24 ± 1.4% | not timed | not timed | 77.45 ± 0.5% | 49.04 ± 0.7% | not timed | not timed | 56.95 ± 0.1% | | 1.01 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 560.42 ± 1.3% | not timed | not timed | 560.58 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 561.79 ± 1.2% | | 1.00 | 1.00 | 1383.12 |
| 14-quadratic/1x | 100 | 21.23 ± 1.3% | not timed | not timed | 9.99 ± 0.1% | 0.98 ± 3.6% | not timed | not timed | 21.24 ± 1.6% | | 1.00 | 2.13 | 21.59 |
| 14-quadratic/2x | 200 | 17.71 ± 1.3% | not timed | not timed | 5.55 ± 0.1% | 0.54 ± 0.9% | not timed | not timed | 17.75 ± 0.8% | | 1.00 | 3.19 | 33.09 |
| 14-quadratic/10x | 1000 | 7.78 ± 1.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 0.5% | not timed | not timed | 7.78 ± 0.2% | | 1.00 | 6.41 | 67.36 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.20 ± 0.7% | not timed | not timed | 0.35 ± 0.1% | 0.55 ± 5.4% | not timed | not timed | 1.21 ± 1.7% | | 1.00 | 3.48 | 2.18 |
| 04-ruff-noqa/compile-real | 1 | 106.09 ± 0.6% | not timed | not timed | 13.88 ± 0.5% | 137.70 ± 2.6% | not timed | not timed | 106.36 ± 0.6% | | 1.00 | 7.64 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 14.01 ± 0.9% | not timed | not timed | 2.55 ± 0.8% | 6.44 ± 2.2% | not timed | not timed | 14.00 ± 0.4% | | 1.00 | 5.50 | 2.18 |
| 07-unicode-character-data/compile | 1 | 108.11 ± 0.6% | not timed | not timed | 25.83 ± 0.2% | 35.95 ± 3.4% | not timed | not timed | 108.10 ± 0.3% | | 1.00 | 4.19 | 3.01 |
| 09-aws-keys/compile-full | 1 | 53.25 ± 0.1% | not timed | not timed | 8.29 ± 1.0% | 23.42 ± 2.4% | not timed | not timed | 53.20 ± 1.6% | | 1.00 | 6.42 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 187.77 ± 1.1% | not timed | not timed | 47.49 ± 0.2% | 132.23 ± 3.4% | not timed | not timed | 187.75 ± 0.5% | | 1.00 | 3.95 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 72.08 ± 1.7% | not timed | not timed | 11.14 ± 0.3% | 16.27 ± 3.9% | not timed | not timed | 72.09 ± 1.9% | | 1.00 | 6.47 | 4.43 |
| 10-bounded-repeat/compile-capitals | 1 | 84.54 ± 1.5% | not timed | not timed | 8.09 ± 0.1% | 24.01 ± 0.4% | not timed | not timed | 84.92 ± 0.3% | | 1.00 | 10.45 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 169.95 ± 1.3% | not timed | not timed | 41.52 ± 0.4% | 68.41 ± 2.3% | not timed | not timed | 170.64 ± 1.2% | | 1.00 | 4.09 | 2.48 |
| 12-dictionary/compile-single | 1 | 0.34 ± 2.4% | not timed | not timed | 0.07 ± 0.3% | 0.09 ± 10.6% | not timed | not timed | 0.34 ± 3.9% | | 1.00 | 4.92 | 3.70 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.35 ± 0.9% | not timed | not timed | 6.47 ± 0.3% | 0.51 ± 26.5% | not timed | not timed | 7.36 ± 1.6% | | 1.00 | 1.14 | 14.28 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.2% | not timed | not timed | 164.37 ± 0.2% | 0.00 ± 0.4% | not timed | not timed | 1.17 ± 0.2% | | 1.00 | 0.0071 | 395.69 |
| dictionary/search/english-15 | 15 | 566.41 ± 1.0% | not timed | not timed | 558.72 ± 0.2% | 0.37 ± 0.2% | not timed | not timed | 567.48 ± 0.9% | | 1.00 | 1.01 | 1543.96 |
| folly/awyer-inn-busted | 1 | 5593.41 ± 0.1% | not timed | not timed | 143.32 ± 0.0% | 43.85 ± 0.2% | not timed | not timed | 5614.48 ± 0.1% | | 1.00 | 39.03 | 127.57 |
| folly/literal-never-match-rare | 0 | 21196.23 ± 0.5% | not timed | not timed | 19945.35 ± 0.2% | 41054.60 ± 0.2% | not timed | not timed | 21207.99 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12507.11 ± 1.7% | not timed | not timed | 19899.55 ± 0.2% | 2202.39 ± 1.0% | not timed | not timed | 12531.92 ± 0.9% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3240.98 ± 0.3% | not timed | not timed | 4392.24 ± 0.3% | 3054.97 ± 0.1% | not timed | not timed | 3239.08 ± 0.4% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1315.03 ± 0.5% | not timed | not timed | 950.06 ± 0.2% | 368.97 ± 16.5% | not timed | not timed | 1322.70 ± 0.6% | | 0.99 | 1.38 | 3.56 |
| grep/long-words-ascii | 5073 | 458.58 ± 0.3% | not timed | not timed | 470.47 ± 0.2% | 46.36 ± 6.1% | not timed | not timed | 458.18 ± 0.2% | | 1.00 | 0.97 | 9.89 |
| imported/leipzig/twain | 811 | 20707.35 ± 0.8% | not timed | not timed | 19584.62 ± 0.4% | 12035.37 ± 9.6% | not timed | not timed | 20729.26 ± 0.6% | | 1.00 | 1.06 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 9067.50 ± 0.9% | not timed | not timed | 4251.40 ± 0.1% | 37.77 ± 0.2% | not timed | not timed | 9120.64 ± 0.9% | | 0.99 | 2.13 | 240.10 |
| imported/leipzig/shing | 1540 | 15280.01 ± 1.7% | not timed | not timed | 13559.45 ± 0.6% | 34.00 ± 0.1% | not timed | not timed | 15514.72 ± 2.3% | | 0.98 | 1.13 | 449.44 |
| imported/leipzig/huck-saw | 262 | 8248.45 ± 3.1% | not timed | not timed | 5606.88 ± 0.3% | 31.84 ± 0.2% | not timed | not timed | 8446.22 ± 2.8% | | 0.98 | 1.47 | 259.09 |
| imported/leipzig/word-ending-nn | 262 | 605.08 ± 0.5% | not timed | not timed | 615.15 ± 0.3% | 24.66 ± 0.3% | not timed | not timed | 605.07 ± 0.6% | | 1.00 | 0.98 | 24.53 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11185.44 ± 0.7% | not timed | not timed | 4547.37 ± 0.9% | 11.49 ± 1.1% | not timed | not timed | 11230.90 ± 1.9% | | 1.00 | 2.46 | 973.12 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7831.37 ± 1.6% | not timed | not timed | 5487.15 ± 0.1% | 16.89 ± 0.0% | not timed | not timed | 7917.02 ± 2.1% | | 0.99 | 1.43 | 463.58 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4176.03 ± 0.9% | not timed | not timed | 411.18 ± 0.7% | 11.12 ± 0.0% | not timed | not timed | 4178.14 ± 0.7% | | 1.00 | 10.16 | 375.68 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.84 ± 0.3% | not timed | not timed | 615.60 ± 0.0% | 11.15 ± 0.0% | not timed | not timed | 602.76 ± 0.3% | | 1.00 | 0.98 | 54.07 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 602.09 ± 0.3% | not timed | not timed | 615.64 ± 0.0% | 9.74 ± 0.0% | not timed | not timed | 602.01 ± 0.5% | | 1.00 | 0.98 | 61.79 |
| imported/leipzig/tom-river | 2 | 6483.13 ± 2.1% | not timed | not timed | 5154.46 ± 0.2% | 31.08 ± 0.1% | not timed | not timed | 6598.88 ± 2.1% | | 0.98 | 1.26 | 208.58 |
| imported/leipzig/ing | 78424 | 600.07 ± 0.7% | not timed | not timed | 570.71 ± 0.1% | 28.27 ± 4.2% | not timed | not timed | 600.32 ± 0.7% | | 1.00 | 1.05 | 21.22 |
| imported/leipzig/ing-whitespace | 55248 | 751.75 ± 0.6% | not timed | not timed | 2083.26 ± 0.4% | 20.45 ± 2.6% | not timed | not timed | 754.67 ± 1.1% | | 1.00 | 0.36 | 36.75 |
| imported/leipzig/awyer-inn | 209 | 769.13 ± 1.5% | not timed | not timed | 4276.02 ± 0.7% | 22.56 ± 0.1% | not timed | not timed | 768.44 ± 1.5% | | 1.00 | 0.18 | 34.09 |
| imported/leipzig/quotes-bounded | 8886 | 2118.40 ± 0.6% | not timed | not timed | 3019.59 ± 0.7% | 38.18 ± 0.2% | not timed | not timed | 2127.54 ± 0.5% | | 1.00 | 0.70 | 55.48 |
| imported/leipzig/non-ascii-alternate | 2 | 12847.51 ± 2.3% | not timed | not timed | 5668.55 ± 0.1% | 50.81 ± 0.1% | not timed | not timed | 13024.39 ± 2.3% | | 0.99 | 2.27 | 252.88 |
| imported/leipzig/math-symbols | 69 | 1986.14 ± 0.6% | not timed | not timed | 614.62 ± 0.1% | 36.47 ± 0.0% | not timed | not timed | 1987.74 ± 0.8% | | 1.00 | 3.23 | 54.46 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.45 ± 0.7% | not timed | not timed | 616.39 ± 0.2% | 22.49 ± 0.1% | not timed | not timed | 587.53 ± 0.2% | | 1.00 | 0.95 | 26.07 |
| imported/lh3lh3-reb/uri | 17549 | 678.89 ± 0.1% | not timed | not timed | 1071.73 ± 0.2% | 28.09 ± 2.5% | not timed | not timed | 678.78 ± 0.2% | | 1.00 | 0.63 | 24.17 |
| imported/lh3lh3-reb/email | 15057 | 673.26 ± 0.1% | not timed | not timed | 1167.48 ± 0.1% | 31.07 ± 2.4% | not timed | not timed | 673.98 ± 0.1% | | 1.00 | 0.58 | 21.67 |
| imported/lh3lh3-reb/date | 668 | 858.43 ± 0.1% | not timed | not timed | 1033.68 ± 0.1% | 51.20 ± 3.8% | not timed | not timed | 859.70 ± 0.2% | | 1.00 | 0.83 | 16.77 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.48 ± 0.1% | not timed | not timed | 423.10 ± 0.1% | 15.81 ± 1.4% | not timed | not timed | 645.18 ± 0.2% | | 1.00 | 1.53 | 40.82 |
| imported/mariomka/email | 92 | 24330.16 ± 3.7% | not timed | not timed | 29821.15 ± 0.4% | 32.81 ± 0.1% | not timed | not timed | 24502.46 ± 1.3% | | 0.99 | 0.82 | 741.56 |
| imported/mariomka/uri | 5301 | 5344.97 ± 0.8% | not timed | not timed | 6085.87 ± 0.2% | 32.78 ± 1.4% | not timed | not timed | 5387.65 ± 0.7% | | 0.99 | 0.88 | 163.05 |
| imported/mariomka/ip | 5 | 2152.52 ± 2.2% | not timed | not timed | 2970.24 ± 0.1% | 21.06 ± 0.2% | not timed | not timed | 2155.16 ± 2.5% | | 1.00 | 0.72 | 102.21 |
| imported/rsc/no-exponential | 0 | 604.60 ± 0.2% | not timed | not timed | 322.66 ± 0.1% | 23.84 ± 0.1% | not timed | not timed | 601.00 ± 0.1% | | 1.01 | 1.87 | 25.36 |
| imported/rsc/literal | 1 | 764.58 ± 2.2% | not timed | not timed | 1606.90 ± 5.1% | 187.11 ± 13.8% | not timed | not timed | 761.19 ± 3.0% | | 1.00 | 0.48 | 4.09 |
| imported/rsc/not-literal | 2 | 781.37 ± 0.4% | not timed | not timed | 726.99 ± 0.2% | 46.52 ± 2.9% | not timed | not timed | 784.49 ± 8.7% | | 1.00 | 1.07 | 16.80 |
| imported/rsc/match-class | 1 | 1439.72 ± 0.3% | not timed | not timed | 1622.63 ± 0.3% | 58.79 ± 15.1% | not timed | not timed | 1441.50 ± 2.2% | | 1.00 | 0.89 | 24.49 |
| imported/rsc/match-class-in-range | 1 | 1446.25 ± 0.5% | not timed | not timed | 2348.76 ± 4.3% | 59.48 ± 12.2% | not timed | not timed | 1442.85 ± 3.3% | | 1.00 | 0.62 | 24.32 |
| imported/rsc/match-class-unicode | 1 | 547.78 ± 0.2% | not timed | not timed | 516.21 ± 0.0% | 72.22 ± 1.2% | not timed | not timed | 548.39 ± 0.1% | | 1.00 | 1.06 | 7.58 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1436.40 ± 0.2% | not timed | not timed | 956.53 ± 0.1% | 228.49 ± 0.5% | not timed | not timed | 1440.89 ± 0.2% | | 1.00 | 1.50 | 6.29 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21597.62 ± 0.1% | not timed | not timed | 14312.63 ± 0.2% | 3435.64 ± 0.4% | not timed | not timed | 21615.90 ± 0.2% | | 1.00 | 1.51 | 6.29 |
| imported/rsc/anchored-literal-short-match | 4 | 711.56 ± 0.8% | not timed | not timed | 484.78 ± 0.1% | 82.06 ± 1.3% | not timed | not timed | 717.72 ± 0.6% | | 0.99 | 1.47 | 8.67 |
| imported/rsc/anchored-literal-long-match | 4 | 10645.30 ± 0.7% | not timed | not timed | 7408.46 ± 0.2% | 1230.00 ± 1.4% | not timed | not timed | 10712.63 ± 0.6% | | 0.99 | 1.44 | 8.65 |
| imported/rsc/one-pass-short | 17 | 372.96 ± 9.6% | not timed | not timed | 215.60 ± 0.3% | 30.90 ± 11.1% | not timed | not timed | 373.45 ± 1.5% | | 1.00 | 1.73 | 12.07 |
| imported/rsc/one-pass-short-not | 17 | 280.74 ± 3.5% | not timed | not timed | 226.58 ± 0.2% | 29.81 ± 10.0% | not timed | not timed | 281.88 ± 1.9% | | 1.00 | 1.24 | 9.42 |
| imported/rsc/one-pass-long-prefix | 26 | 364.24 ± 2.0% | not timed | not timed | 282.17 ± 0.0% | 105.97 ± 16.2% | not timed | not timed | 365.55 ± 7.7% | | 1.00 | 1.29 | 3.44 |
| imported/rsc/one-pass-long-prefix-not | 26 | 354.91 ± 1.8% | not timed | not timed | 282.75 ± 0.4% | 65.98 ± 19.4% | not timed | not timed | 363.47 ± 1.5% | | 0.98 | 1.26 | 5.38 |
| imported/rsc/long-needle1 | 31 | 22194.65 ± 0.3% | not timed | not timed | 20163.31 ± 0.0% | 3.76 ± 0.3% | not timed | not timed | 22200.96 ± 0.0% | | 1.00 | 1.10 | 5902.06 |
| imported/rsc/long-needle2 | 31 | 22330.55 ± 0.1% | not timed | not timed | 216.12 ± 0.2% | 3.76 ± 0.2% | not timed | not timed | 22340.04 ± 0.0% | | 1.00 | 103.33 | 5943.36 |
| imported/rsc/easy0-32 | 26 | 1078.21 ± 2.8% | not timed | not timed | 1548.39 ± 1.9% | 148.91 ± 20.4% | not timed | not timed | 1077.81 ± 0.6% | | 1.00 | 0.70 | 7.24 |
| imported/rsc/easy0-1k | 26 | 14975.48 ± 0.1% | not timed | not timed | 12705.26 ± 0.6% | 2313.22 ± 15.7% | not timed | not timed | 15000.27 ± 2.3% | | 1.00 | 1.18 | 6.47 |
| imported/rsc/easy0-32k | 26 | 22988.89 ± 1.4% | not timed | not timed | 20320.82 ± 0.4% | 18770.13 ± 22.9% | not timed | not timed | 22988.73 ± 0.1% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21983.66 ± 1.6% | not timed | not timed | 19895.89 ± 2.3% | 38269.24 ± 4.2% | not timed | not timed | 21949.35 ± 3.4% | | 1.00 | 1.10 | 0.57 |
| imported/rsc/easy1-32 | 19 | 808.36 ± 2.5% | not timed | not timed | 642.38 ± 0.4% | 128.54 ± 17.1% | not timed | not timed | 809.75 ± 2.2% | | 1.00 | 1.26 | 6.29 |
| imported/rsc/easy1-1k | 19 | 16576.52 ± 2.4% | not timed | not timed | 13111.73 ± 0.5% | 2489.51 ± 16.8% | not timed | not timed | 16601.29 ± 0.2% | | 1.00 | 1.26 | 6.66 |
| imported/rsc/easy1-32k | 19 | 518972.47 ± 0.1% | not timed | not timed | 409809.33 ± 0.4% | 20393.01 ± 0.5% | not timed | not timed | 519734.51 ± 0.3% | | 1.00 | 1.27 | 25.45 |
| imported/rsc/easy1-1mb | 19 | 16687876.18 ± 0.1% | not timed | not timed | 13148846.98 ± 0.2% | 38795.51 ± 0.8% | not timed | not timed | 16678604.07 ± 0.4% | | 1.00 | 1.27 | 430.15 |
| imported/rsc/medium-32 | 27 | 772.81 ± 1.9% | not timed | not timed | 645.52 ± 0.2% | 70.11 ± 12.0% | not timed | not timed | 780.16 ± 0.2% | | 0.99 | 1.20 | 11.02 |
| imported/rsc/medium-1k | 27 | 13755.82 ± 0.1% | not timed | not timed | 11367.07 ± 0.6% | 72.18 ± 0.1% | not timed | not timed | 13849.63 ± 0.4% | | 0.99 | 1.21 | 190.58 |
| imported/rsc/medium-32k | 27 | 428312.16 ± 0.4% | not timed | not timed | 354601.19 ± 0.3% | 48.37 ± 0.1% | not timed | not timed | 432177.98 ± 0.5% | | 0.99 | 1.21 | 8854.43 |
| imported/rsc/medium-1mb | 27 | 13718299.80 ± 0.2% | not timed | not timed | 11411076.86 ± 0.6% | 48.42 ± 0.2% | not timed | not timed | 13808783.39 ± 0.5% | | 0.99 | 1.20 | 283315.62 |
| imported/rsc/hard-32 | 58 | 421.18 ± 2.1% | not timed | not timed | 370.25 ± 0.1% | 49.56 ± 8.7% | not timed | not timed | 421.83 ± 0.1% | | 1.00 | 1.14 | 8.50 |
| imported/rsc/hard-1k | 27 | 13390.76 ± 0.3% | not timed | not timed | 11644.85 ± 0.5% | 40.85 ± 0.1% | not timed | not timed | 13486.74 ± 0.1% | | 0.99 | 1.15 | 327.83 |
| imported/rsc/hard-32k | 27 | 417855.87 ± 0.2% | not timed | not timed | 362356.00 ± 0.3% | 28.85 ± 0.2% | not timed | not timed | 421621.98 ± 0.3% | | 0.99 | 1.15 | 14481.29 |
| imported/rsc/hard-1mb | 51 | 8385838.93 ± 0.3% | not timed | not timed | 7255684.71 ± 0.2% | 29.45 ± 0.1% | not timed | not timed | 8395145.55 ± 0.1% | | 1.00 | 1.16 | 284771.87 |
| imported/rsc/reallyhard0-32 | 58 | 267.80 ± 2.6% | not timed | not timed | 225.27 ± 0.1% | 49.86 ± 8.1% | not timed | not timed | 267.31 ± 0.2% | | 1.00 | 1.19 | 5.37 |
| imported/rsc/reallyhard0-1k | 27 | 592.21 ± 0.3% | not timed | not timed | 586.43 ± 0.1% | 40.83 ± 0.1% | not timed | not timed | 590.61 ± 0.1% | | 1.00 | 1.01 | 14.51 |
| imported/rsc/reallyhard0-32k | 27 | 611.33 ± 0.2% | not timed | not timed | 618.03 ± 0.1% | 29.45 ± 0.1% | not timed | not timed | 611.20 ± 0.3% | | 1.00 | 0.99 | 20.76 |
| imported/rsc/reallyhard0-1mb | 51 | 595.14 ± 0.5% | not timed | not timed | 618.06 ± 0.1% | 29.45 ± 0.1% | not timed | not timed | 594.46 ± 0.3% | | 1.00 | 0.96 | 20.21 |
| imported/rsc/reallyreallyhard0-32 | 47 | 285.63 ± 1.7% | not timed | not timed | 197.70 ± 0.1% | 61.12 ± 15.2% | not timed | not timed | 288.29 ± 1.6% | | 0.99 | 1.44 | 4.67 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6798.34 ± 0.1% | not timed | not timed | 5991.51 ± 0.1% | 34.15 ± 0.6% | not timed | not timed | 6783.14 ± 0.1% | | 1.00 | 1.13 | 199.07 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21495.43 ± 0.0% | not timed | not timed | 19203.43 ± 0.4% | 24.92 ± 4.5% | not timed | not timed | 21509.97 ± 0.1% | | 1.00 | 1.12 | 862.44 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 22078.08 ± 0.9% | not timed | not timed | 20065.63 ± 0.8% | 24.95 ± 1.4% | not timed | not timed | 22119.59 ± 0.8% | | 1.00 | 1.10 | 884.78 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.44 ± 2.0% | not timed | not timed | 211.78 ± 0.4% | 61.30 ± 12.0% | not timed | not timed | 282.60 ± 1.5% | | 1.00 | 1.33 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5895.10 ± 0.1% | not timed | not timed | 6197.47 ± 0.1% | 34.42 ± 0.4% | not timed | not timed | 5881.44 ± 0.1% | | 1.00 | 0.95 | 171.27 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21421.26 ± 0.6% | not timed | not timed | 19191.32 ± 0.2% | 25.07 ± 0.1% | not timed | not timed | 21434.97 ± 0.1% | | 1.00 | 1.12 | 854.32 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21405.48 ± 0.5% | not timed | not timed | 19734.33 ± 0.9% | 25.11 ± 0.1% | not timed | not timed | 21395.14 ± 0.2% | | 1.00 | 1.08 | 852.52 |
| imported/sherlock/name-sherlock | 776 | 19754.50 ± 6.3% | not timed | not timed | 18560.06 ± 1.0% | 10045.04 ± 17.7% | not timed | not timed | 19823.30 ± 2.5% | | 1.00 | 1.06 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15115.18 ± 1.4% | not timed | not timed | 15597.38 ± 0.8% | 3243.01 ± 13.1% | not timed | not timed | 15263.85 ± 1.5% | | 0.99 | 0.97 | 4.66 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19795.27 ± 2.6% | not timed | not timed | 18558.61 ± 0.9% | 8040.26 ± 48.2% | not timed | not timed | 19785.96 ± 2.3% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15546.99 ± 0.6% | not timed | not timed | 4012.00 ± 0.1% | 32.56 ± 0.3% | not timed | not timed | 15569.66 ± 0.4% | | 1.00 | 3.88 | 477.42 |
| imported/sherlock/name-holmes-casei | 2802 | 9363.97 ± 5.0% | not timed | not timed | 3327.25 ± 0.1% | 37.66 ± 0.2% | not timed | not timed | 9387.00 ± 1.6% | | 1.00 | 2.81 | 248.66 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13040.35 ± 2.8% | not timed | not timed | 3953.53 ± 0.2% | 32.58 ± 0.1% | not timed | not timed | 13068.94 ± 2.2% | | 1.00 | 3.30 | 400.31 |
| imported/sherlock/name-whitespace | 1461 | 15332.34 ± 1.7% | not timed | not timed | 14321.79 ± 0.7% | 7300.71 ± 22.6% | not timed | not timed | 15335.60 ± 1.6% | | 1.00 | 1.07 | 2.10 |
| imported/sherlock/name-alt1 | 1142 | 11625.97 ± 0.4% | not timed | not timed | 16098.13 ± 1.1% | 4093.35 ± 16.6% | not timed | not timed | 11618.44 ± 2.8% | | 1.00 | 0.72 | 2.84 |
| imported/sherlock/name-alt2 | 3542 | 8955.08 ± 0.4% | not timed | not timed | 3828.28 ± 0.1% | 31.53 ± 0.1% | not timed | not timed | 8952.18 ± 0.3% | | 1.00 | 2.34 | 283.98 |
| imported/sherlock/name-alt3 | 4507 | 5575.04 ± 0.5% | not timed | not timed | 3637.72 ± 0.1% | 9.94 ± 0.0% | not timed | not timed | 5565.19 ± 0.5% | | 1.00 | 1.53 | 560.86 |
| imported/sherlock/name-alt3-casei | 4593 | 1531.63 ± 1.9% | not timed | not timed | 285.56 ± 0.1% | 6.48 ± 0.5% | not timed | not timed | 1530.54 ± 1.0% | | 1.00 | 5.36 | 236.46 |
| imported/sherlock/name-alt4 | 3686 | 6399.97 ± 0.1% | not timed | not timed | 3779.14 ± 0.2% | 31.32 ± 0.1% | not timed | not timed | 6395.51 ± 0.1% | | 1.00 | 1.69 | 204.37 |
| imported/sherlock/name-alt4-casei | 4254 | 2809.92 ± 2.2% | not timed | not timed | 2582.77 ± 0.2% | 19.89 ± 0.2% | not timed | not timed | 2807.91 ± 1.3% | | 1.00 | 1.09 | 141.30 |
| imported/sherlock/name-alt5 | 4028 | 6428.71 ± 0.3% | not timed | not timed | 3749.79 ± 0.1% | 21.69 ± 0.1% | not timed | not timed | 6429.60 ± 0.2% | | 1.00 | 1.71 | 296.32 |
| imported/sherlock/name-alt5-casei | 4104 | 3510.80 ± 1.8% | not timed | not timed | 2215.38 ± 0.0% | 14.41 ± 0.1% | not timed | not timed | 3513.46 ± 0.6% | | 1.00 | 1.58 | 243.69 |
| imported/sherlock/no-match-uncommon | 0 | 21456.77 ± 0.7% | not timed | not timed | 19547.79 ± 0.6% | 35444.76 ± 0.7% | not timed | not timed | 21522.39 ± 0.6% | | 1.00 | 1.10 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21342.78 ± 0.2% | not timed | not timed | 19483.21 ± 0.7% | 1277.77 ± 0.5% | not timed | not timed | 21331.32 ± 0.4% | | 1.00 | 1.10 | 16.70 |
| imported/sherlock/no-match-really-common | 0 | 15981.62 ± 2.7% | not timed | not timed | 18713.71 ± 0.5% | 1275.42 ± 0.1% | not timed | not timed | 16056.82 ± 1.4% | | 1.00 | 0.85 | 12.53 |
| imported/sherlock/the-lower | 21654 | 2320.50 ± 1.2% | not timed | not timed | 2331.13 ± 0.7% | 240.14 ± 16.7% | not timed | not timed | 2331.34 ± 1.2% | | 1.00 | 1.00 | 9.66 |
| imported/sherlock/the-upper | 2223 | 12684.37 ± 1.3% | not timed | not timed | 13569.88 ± 0.7% | 2740.70 ± 4.7% | not timed | not timed | 12787.60 ± 1.0% | | 0.99 | 0.93 | 4.63 |
| imported/sherlock/the-casei | 23961 | 2020.93 ± 1.2% | not timed | not timed | 1322.26 ± 0.2% | 35.19 ± 19.6% | not timed | not timed | 2017.56 ± 0.3% | | 1.00 | 1.53 | 57.42 |
| imported/sherlock/everything-greedy | 581881 | 283.37 ± 0.7% | not timed | not timed | 165.97 ± 0.1% | 28.90 ± 35.0% | not timed | not timed | 283.32 ± 0.3% | | 1.00 | 1.71 | 9.81 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.64 ± 0.1% | not timed | not timed | 213.11 ± 0.2% | 32.92 ± 0.5% | not timed | not timed | 462.46 ± 0.1% | | 1.00 | 2.17 | 14.05 |
| imported/sherlock/letters | 447175 | 62.47 ± 0.9% | not timed | not timed | 32.95 ± 0.4% | 6.46 ± 31.0% | not timed | not timed | 62.63 ± 0.5% | | 1.00 | 1.90 | 9.67 |
| imported/sherlock/letters-upper | 14180 | 453.55 ± 1.3% | not timed | not timed | 371.56 ± 0.1% | 29.64 ± 21.9% | not timed | not timed | 453.21 ± 0.1% | | 1.00 | 1.22 | 15.30 |
| imported/sherlock/letters-lower | 432995 | 63.66 ± 0.4% | not timed | not timed | 33.91 ± 0.1% | 5.70 ± 9.3% | not timed | not timed | 63.78 ± 1.2% | | 1.00 | 1.88 | 11.17 |
| imported/sherlock/words | 447639 | 115.21 ± 2.9% | not timed | not timed | 83.03 ± 0.1% | 14.41 ± 1.5% | not timed | not timed | 115.35 ± 0.7% | | 1.00 | 1.39 | 8.00 |
| imported/sherlock/before-holmes | 4073 | 10314.63 ± 0.4% | not timed | not timed | 8427.12 ± 0.3% | 23.86 ± 0.4% | not timed | not timed | 10315.26 ± 0.4% | | 1.00 | 1.22 | 432.32 |
| imported/sherlock/before-after-holmes | 2593 | 9933.88 ± 0.7% | not timed | not timed | 9511.10 ± 0.3% | 24.24 ± 1.3% | not timed | not timed | 9938.22 ± 0.5% | | 1.00 | 1.04 | 409.77 |
| imported/sherlock/holmes-cochar-watson | 150 | 5197.85 ± 0.6% | not timed | not timed | 3427.00 ± 0.1% | 30.29 ± 0.1% | not timed | not timed | 5197.45 ± 0.1% | | 1.00 | 1.52 | 171.57 |
| imported/sherlock/holmes-coword-watson | 14309 | 1188.08 ± 0.7% | not timed | not timed | 1123.12 ± 0.3% | 6.80 ± 0.0% | not timed | not timed | 1190.29 ± 0.7% | | 1.00 | 1.06 | 174.84 |
| imported/sherlock/quotes | 14437 | 1388.36 ± 0.3% | not timed | not timed | 1763.46 ± 1.4% | 35.17 ± 0.1% | not timed | not timed | 1399.30 ± 0.6% | | 0.99 | 0.79 | 39.47 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.97 ± 0.2% | not timed | not timed | 15784.59 ± 0.3% | 36.59 ± 0.5% | not timed | not timed | 609.91 ± 0.1% | | 1.00 | 0.0386 | 16.67 |
| imported/sherlock/word-ending-n | 35297 | 481.55 ± 0.4% | not timed | not timed | 409.49 ± 0.1% | 23.44 ± 1.0% | not timed | not timed | 482.59 ± 0.2% | | 1.00 | 1.18 | 20.54 |
| imported/sherlock/repeated-class-negation | 2130 | 14697.73 ± 1.1% | not timed | not timed | 11045.99 ± 0.3% | 11.60 ± 0.0% | not timed | not timed | 14664.17 ± 0.9% | | 1.00 | 1.33 | 1267.35 |
| imported/sherlock/ing-suffix | 20547 | 566.26 ± 1.4% | not timed | not timed | 517.40 ± 0.1% | 28.81 ± 28.7% | not timed | not timed | 567.43 ± 0.2% | | 1.00 | 1.09 | 19.66 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 609.06 ± 0.4% | not timed | not timed | 2099.34 ± 0.3% | 20.54 ± 0.2% | not timed | not timed | 608.28 ± 0.2% | | 1.00 | 0.29 | 29.66 |
| opt/accelerate/whole-line | 239963 | 457.35 ± 0.1% | not timed | not timed | 374.21 ± 0.3% | 92.62 ± 16.6% | not timed | not timed | 457.98 ± 0.4% | | 1.00 | 1.22 | 4.94 |
| opt/accelerate/non-dna | 16745 | 425.66 ± 0.9% | not timed | not timed | 400.40 ± 0.1% | 29.56 ± 62.6% | not timed | not timed | 427.13 ± 0.2% | | 1.00 | 1.06 | 14.40 |
| opt/backtrack/words-english | 40536 | 136.13 ± 0.2% | not timed | not timed | 94.73 ± 0.2% | 19.91 ± 5.4% | not timed | not timed | 136.58 ± 7.5% | | 1.00 | 1.44 | 6.84 |
| opt/fixed-length/too-small-ascii | 0 | 318.85 ± 0.2% | not timed | not timed | 707.70 ± 1.0% | 80.03 ± 0.5% | not timed | not timed | 318.75 ± 0.1% | | 1.00 | 0.45 | 3.98 |
| opt/fixed-length/too-big-ascii | 0 | 3483.77 ± 0.2% | not timed | not timed | 5818.19 ± 0.7% | 124.89 ± 1.5% | not timed | not timed | 3470.44 ± 0.1% | | 1.00 | 0.60 | 27.89 |
| opt/fixed-length/go33484-1 | 0 | 668928.78 ± 0.2% | not timed | not timed | 1120809.04 ± 0.5% | 61347.76 ± 0.1% | not timed | not timed | 668097.03 ± 0.1% | | 1.00 | 0.60 | 10.90 |
| opt/fixed-length/go33484-2 | 0 | 668852.83 ± 0.2% | not timed | not timed | 1122278.90 ± 0.7% | 32436.72 ± 0.6% | not timed | not timed | 668023.06 ± 0.1% | | 1.00 | 0.60 | 20.62 |
| opt/fixed-length/go33484-3 | 0 | 2465.64 ± 1.7% | not timed | not timed | 112418.55 ± 0.5% | 767.58 ± 0.2% | not timed | not timed | 2287.94 ± 0.6% | | 1.08 | 0.0219 | 3.21 |
| opt/literal-alt/one-pattern | 1 | 546.64 ± 1.2% | not timed | not timed | 542.54 ± 0.0% | 0.39 ± 0.3% | not timed | not timed | 548.99 ± 1.1% | | 1.00 | 1.01 | 1386.22 |
| opt/onepass/fn-predicate | 916 | 355.64 ± 1.3% | not timed | not timed | 334.27 ± 0.4% | 201.23 ± 14.5% | not timed | not timed | 372.30 ± 0.8% | | 0.96 | 1.06 | 1.77 |
| opt/onepass/first-three-words-english | 35128 | 175.73 ± 1.7% | not timed | not timed | 200.43 ± 0.1% | 77.88 ± 14.6% | not timed | not timed | 176.48 ± 1.6% | | 1.00 | 0.88 | 2.26 |
| opt/prefilter/literal-english | 1 | 20096.60 ± 0.5% | not timed | not timed | 19416.28 ± 0.1% | 17383.37 ± 0.3% | not timed | not timed | 20109.10 ± 0.4% | | 1.00 | 1.04 | 1.16 |
| opt/prefilter/literal-casei-english | 1 | 14442.39 ± 0.1% | not timed | not timed | 4315.38 ± 0.2% | 32.72 ± 0.6% | not timed | not timed | 14455.70 ± 0.3% | | 1.00 | 3.35 | 441.45 |
| opt/prefilter/literal-russian | 1 | 21872.56 ± 0.3% | not timed | not timed | 20204.58 ± 0.2% | 3327.41 ± 0.4% | not timed | not timed | 21896.07 ± 0.1% | | 1.00 | 1.08 | 6.57 |
| opt/prefilter/literal-casei-russian | 1 | 8600.64 ± 0.1% | not timed | not timed | 3895.26 ± 0.1% | 31.70 ± 0.3% | not timed | not timed | 8602.92 ± 0.2% | | 1.00 | 2.21 | 271.34 |
| opt/prefilter/rust-functions | 948 | 6829.98 ± 0.3% | not timed | not timed | 8981.95 ± 0.3% | 1868.93 ± 15.6% | not timed | not timed | 6833.04 ± 6.3% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 30054859.33 ± 0.1% | not timed | not timed | 21609558.15 ± 0.4% | 50.40 ± 0.1% | not timed | not timed | 30142672.77 ± 0.1% | | 1.00 | 1.39 | 596356.53 |
| opt/reverse-inner/holmes | 2593 | 9921.35 ± 0.6% | not timed | not timed | 9330.61 ± 0.4% | 23.77 ± 2.7% | not timed | not timed | 9919.36 ± 0.7% | | 1.00 | 1.06 | 417.31 |
| opt/reverse-inner/email | 47 | 36376.10 ± 2.0% | not timed | not timed | 45201.82 ± 0.3% | 32.48 ± 0.1% | not timed | not timed | 36979.99 ± 1.9% | | 0.98 | 0.80 | 1119.92 |
| opt/reverse-inner/factored-prefix | 3542 | 601.40 ± 0.1% | not timed | not timed | 595.60 ± 0.2% | 12.56 ± 0.2% | not timed | not timed | 600.92 ± 0.1% | | 1.00 | 1.01 | 47.89 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5556.58 ± 0.1% | not timed | not timed | 613.80 ± 0.2% | 75.22 ± 0.1% | not timed | not timed | 5532.00 ± 0.1% | | 1.00 | 9.05 | 73.87 |
| opt/reverse-inner/no-quadratic-forward | 0 | 689.32 ± 1.6% | not timed | not timed | 287.94 ± 0.2% | 24.74 ± 0.0% | not timed | not timed | 687.02 ± 1.9% | | 1.00 | 2.39 | 27.87 |
| opt/reverse-suffix/holmes | 4073 | 10276.74 ± 0.4% | not timed | not timed | 8467.28 ± 0.3% | 23.94 ± 1.5% | not timed | not timed | 10299.27 ± 0.6% | | 1.00 | 1.21 | 429.27 |
| opt/reverse-suffix/no-quadratic | 0 | 5533.91 ± 0.1% | not timed | not timed | 613.66 ± 0.6% | 75.17 ± 0.1% | not timed | not timed | 5561.39 ± 0.0% | | 1.00 | 9.02 | 73.62 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.97 ± 2.1% | not timed | not timed | 130.85 ± 0.1% | 14.32 ± 14.5% | not timed | not timed | 122.04 ± 6.7% | | 1.00 | 0.93 | 8.52 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.93 ± 2.6% | not timed | not timed | 131.66 ± 0.1% | 13.08 ± 14.0% | not timed | not timed | 122.07 ± 1.8% | | 1.00 | 0.93 | 9.32 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.9% | not timed | not timed | 0.55 ± 0.1% | 112.65 ± 0.5% | not timed | not timed | 0.28 ± 0.3% | | 0.99 | 0.50 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 312.32 ± 0.2% | not timed | not timed | 285.31 ± 0.1% | 104.08 ± 0.1% | not timed | not timed | 312.79 ± 0.2% | | 1.00 | 1.09 | 3.00 |
| reported/i13-subset-regex/original-ascii | 4094 | 11154.15 ± 0.7% | not timed | not timed | 4556.85 ± 0.8% | 11.50 ± 0.1% | not timed | not timed | 11218.62 ± 0.8% | | 0.99 | 2.45 | 970.34 |
| reported/i13-subset-regex/original-unicode | 4094 | 11041.81 ± 2.9% | not timed | not timed | 251.21 ± 2.9% | 11.49 ± 1.0% | not timed | not timed | 11164.86 ± 0.9% | | 0.99 | 43.95 | 960.83 |
| reported/i13-subset-regex/big-ascii | 1955 | 10693.21 ± 1.1% | not timed | not timed | 67.90 ± 3.6% | 9.85 ± 0.1% | not timed | not timed | 10728.22 ± 1.0% | | 1.00 | 157.47 | 1085.64 |
| reported/i13-subset-regex/big-unicode | 1955 | 10633.92 ± 1.2% | not timed | not timed | 12.22 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10743.52 ± 0.9% | | 0.99 | 870.20 | 1079.27 |
| reported/i13-subset-regex/huge-ascii | 55 | 10109.96 ± 1.2% | not timed | not timed | 10.98 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 10108.27 ± 2.9% | | 1.00 | 920.68 | 1153.51 |
| reported/i13-subset-regex/huge-unicode | 55 | 10062.02 ± 3.5% | not timed | not timed | 10.94 ± 0.3% | 8.77 ± 0.0% | not timed | not timed | 9814.33 ± 3.0% | | 1.03 | 919.80 | 1147.39 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 11.04 ± 0.1% | 8.78 ± 1.3% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.2% | not timed | not timed | 10.98 ± 0.3% | 8.76 ± 0.0% | not timed | not timed | 5.04 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 486.31 ± 0.3% | not timed | not timed | 104.25 ± 0.1% | 6.66 ± 0.1% | not timed | not timed | 488.03 ± 0.4% | | 1.00 | 4.66 | 73.00 |
| reported/i787-keywords/opt-ascii | 5674 | 489.18 ± 0.2% | not timed | not timed | 273.44 ± 0.1% | 10.31 ± 0.3% | not timed | not timed | 489.16 ± 0.3% | | 1.00 | 1.79 | 47.45 |
| slow/quadratic-regex-1x | 100 | 7.13 ± 0.1% | not timed | not timed | 4.94 ± 0.4% | 0.05 ± 0.3% | not timed | not timed | 7.12 ± 0.2% | | 1.00 | 1.44 | 144.53 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.2% | not timed | not timed | 2.77 ± 0.2% | 0.01 ± 0.2% | not timed | not timed | 3.44 ± 0.3% | | 1.00 | 1.24 | 269.87 |
| slow/quadratic-haystack-1x | 100 | 21.27 ± 7.5% | not timed | not timed | 10.02 ± 0.2% | 1.02 ± 5.5% | not timed | not timed | 21.33 ± 6.7% | | 1.00 | 2.12 | 20.88 |
| slow/quadratic-haystack-2x | 200 | 17.74 ± 12.2% | not timed | not timed | 5.55 ± 0.1% | 0.55 ± 1.8% | not timed | not timed | 17.85 ± 0.8% | | 0.99 | 3.20 | 32.44 |
| unicode/codepoints/any-one | 1112064 | 291.42 ± 0.5% | not timed | not timed | 176.54 ± 0.1% | 18.49 ± 0.4% | not timed | not timed | 291.35 ± 0.2% | | 1.00 | 1.65 | 15.76 |
| unicode/codepoints/any-all | 4382592 | 269.46 ± 0.5% | not timed | not timed | 246.23 ± 0.3% | 117.44 ± 0.1% | not timed | not timed | 270.04 ± 0.3% | | 1.00 | 1.09 | 2.29 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 1.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 605.01 ± 0.4% | not timed | not timed | 616.27 ± 0.3% | 135.33 ± 0.3% | not timed | not timed | 603.53 ± 0.4% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 31.54 ± 0.2% | not timed | not timed | 38.25 ± 0.1% | 3.95 ± 1.3% | not timed | not timed | 31.64 ± 0.2% | | 1.00 | 0.82 | 7.99 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.2% | not timed | not timed | 4.12 ± 0.1% | 2.35 ± 0.2% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.35 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.7% | not timed | not timed | 4.12 ± 0.2% | 6.26 ± 10.4% | not timed | not timed | 1.29 ± 0.1% | | 1.00 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 126.63 ± 7.7% | not timed | not timed | 82.85 ± 0.2% | 11.69 ± 18.7% | not timed | not timed | 128.60 ± 0.5% | | 0.98 | 1.53 | 10.83 |
| unicode/word/boundary-long-english | 3466 | 615.69 ± 0.2% | not timed | not timed | 605.73 ± 0.3% | 32.36 ± 1.1% | not timed | not timed | 616.05 ± 0.1% | | 1.00 | 1.02 | 19.03 |
| unicode/word/around-holmes-english | 27 | 19363.60 ± 0.3% | not timed | not timed | 19224.52 ± 0.4% | 22.19 ± 0.9% | not timed | not timed | 19386.51 ± 0.2% | | 1.00 | 1.01 | 872.73 |
| wild/bibleref/long | 874 | 564.10 ± 0.1% | not timed | not timed | 584.73 ± 0.1% | 6.56 ± 0.2% | not timed | not timed | 563.96 ± 0.1% | | 1.00 | 0.96 | 86.00 |
| wild/bibleref/short | 30 | 24.94 ± 3.7% | not timed | not timed | 30.95 ± 0.1% | 13.95 ± 10.3% | not timed | not timed | 25.66 ± 3.0% | | 0.97 | 0.81 | 1.79 |
| wild/bibleref/line | 874 | 393.66 ± 0.2% | not timed | not timed | 211.60 ± 0.2% | 9.14 ± 0.1% | not timed | not timed | 393.01 ± 0.2% | | 1.00 | 1.86 | 43.09 |
| wild/caddy/caddy | 6 | 417.99 ± 11.3% | not timed | not timed | 247.94 ± 0.2% | 68.33 ± 14.4% | not timed | not timed | 418.43 ± 0.2% | | 1.00 | 1.69 | 6.12 |
| wild/dot-star-capture/rust-src-tools | 6 | 1071.52 ± 0.2% | not timed | not timed | 348.13 ± 0.2% | 13.60 ± 0.1% | not timed | not timed | 1070.99 ± 0.2% | | 1.00 | 3.08 | 78.81 |
| wild/ruff/noqa | 84 | 435.89 ± 0.4% | not timed | not timed | 448.91 ± 0.0% | 19.55 ± 2.1% | not timed | not timed | 434.19 ± 3.6% | | 1.00 | 0.97 | 22.30 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.49 ± 0.5% | not timed | not timed | 702.10 ± 0.1% | 136.71 ± 11.2% | not timed | not timed | 955.85 ± 0.5% | | 1.00 | 1.37 | 7.01 |
| wild/ruff/string-quote-prefix | 2972 | 1361.71 ± 0.8% | not timed | not timed | 406.58 ± 0.4% | 376.01 ± 30.2% | not timed | not timed | 1360.16 ± 0.9% | | 1.00 | 3.35 | 3.62 |
| wild/ruff/space-around-operator | 1224378 | 219.93 ± 1.7% | not timed | not timed | 186.63 ± 0.0% | 18.51 ± 1.7% | not timed | not timed | 220.48 ± 1.8% | | 1.00 | 1.18 | 11.88 |
| wild/ruff/shebang | 282 | 986.54 ± 0.5% | not timed | not timed | 331.96 ± 0.1% | 119.13 ± 13.3% | not timed | not timed | 988.04 ± 0.4% | | 1.00 | 2.97 | 8.28 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13845.23 ± 0.3% | not timed | not timed | 13884.74 ± 0.3% | 6930.05 ± 0.6% | not timed | not timed | 13836.48 ± 0.1% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12863.63 ± 0.4% | not timed | not timed | 13506.20 ± 0.5% | 6427.11 ± 0.7% | not timed | not timed | 12860.72 ± 0.3% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13222.42 ± 0.4% | not timed | not timed | 13747.40 ± 0.5% | 6664.46 ± 1.2% | not timed | not timed | 13235.60 ± 0.2% | | 1.00 | 0.96 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9579.43 ± 2.0% | not timed | not timed | 13653.10 ± 0.3% | 6755.16 ± 0.7% | not timed | not timed | 9576.87 ± 1.6% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 122.47 ± 14.0% | not timed | not timed | 65.83 ± 0.6% | 2.20 ± 0.7% | not timed | not timed | 122.59 ± 14.6% | | 1.00 | 1.86 | 55.57 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.1% | not timed | not timed | 0.01 ± 1.7% | 0.01 ± 18.2% | not timed | not timed | 0.03 ± 42.2% | | 0.99 | 3.06 | 3.80 |
| dictionary/compile/english-15 | 1 | 0.34 ± 0.5% | not timed | not timed | 0.07 ± 1.1% | 0.10 ± 13.1% | not timed | not timed | 0.34 ± 32.7% | | 0.99 | 4.89 | 3.41 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 8.1% | not timed | not timed | 0.02 ± 0.7% | 36.05 ± 10.5% | not timed | not timed | 0.25 ± 3.5% | | 0.97 | 12.37 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.29 ± 20.6% | not timed | not timed | 11.60 ± 0.3% | 62.16 ± 26.9% | not timed | not timed | 47.52 ± 2.2% | | 1.00 | 4.08 | 0.76 |
| reported/i787-keywords/compile | 1 | 35.32 ± 18.6% | not timed | not timed | 2.13 ± 0.5% | 16.41 ± 15.6% | not timed | not timed | 35.37 ± 1.7% | | 1.00 | 16.62 | 2.15 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 366.92 ± 4.8% | not timed | not timed | 124.20 ± 0.3% | 571.07 ± 29.4% | not timed | not timed | 368.43 ± 3.4% | | 1.00 | 2.95 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.43 ± 2.1% | not timed | not timed | 4.12 ± 0.8% | 44.79 ± 14.8% | not timed | not timed | 47.80 ± 3.0% | | 0.99 | 11.51 | 1.06 |
| unicode/compile/one-letter | 53 | 6.73 ± 12.0% | not timed | not timed | 4.58 ± 0.5% | 65.38 ± 4.9% | not timed | not timed | 6.72 ± 14.5% | | 1.00 | 1.47 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 3.3% | not timed | not timed | 0.10 ± 2.9% | 63.26 ± 12.0% | not timed | not timed | 1.09 ± 14.4% | | 0.99 | 10.92 | 0.0171 |
| unicode/compile/fifty-letters-ascii | 1 | 220.12 ± 3.9% | not timed | not timed | 53.41 ± 0.2% | 177.54 ± 16.7% | not timed | not timed | 222.04 ± 3.3% | | 0.99 | 4.12 | 1.24 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 380.01 ± 23.2% | not timed | not timed | 47.57 ± 0.6% | 670.83 ± 25.4% | not timed | not timed | 384.20 ± 3.0% | | 0.99 | 7.99 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 597.95 ± 10.1% | not timed | not timed | 144.93 ± 0.5% | 649.39 ± 23.2% | not timed | not timed | 625.50 ± 3.3% | | 0.96 | 4.13 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 324.04 ± 1.8% | not timed | not timed | 51.23 ± 0.2% | 1244.97 ± 28.1% | not timed | not timed | 328.62 ± 7.2% | | 0.99 | 6.32 | 0.26 |
| wild/bibleref/compile | 3 | 5.86 ± 1.7% | not timed | not timed | 1.96 ± 0.9% | 30.87 ± 7.4% | not timed | not timed | 5.90 ± 1.6% | | 0.99 | 2.99 | 0.19 |
| wild/url/compile | 1 | 0.53 ± 16.2% | not timed | not timed | 0.15 ± 4.3% | 0.46 ± 61.8% | not timed | not timed | 0.61 ± 15.3% | | 0.86 | 3.63 | 1.15 |

