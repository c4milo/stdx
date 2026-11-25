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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506974679 |
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
| literal: a word | 217 | 18940.66 ± 0.8% | 5069.49 ± 0.2% | 28.27 ± 0.3% | 17685.17 ± 1.1% | 9019.39 ± 8.3% | 16.72 ± 0.2% | 86.12 ± 0.5% | 19049.71 ± 0.4% | 3.74 | 0.99 | 1.07 | 2.10 |
| literal: a word that is not there | 0 | 21147.93 ± 4.8% | 4929.85 ± 0.3% | 28.35 ± 0.3% | 19169.09 ± 2.6% | 28186.56 ± 2.2% | 16.45 ± 0.1% | 82.08 ± 0.4% | 21101.08 ± 4.6% | 4.29 | 1.00 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6424.60 ± 0.3% | 1972.49 ± 0.3% | 14.33 ± 0.2% | 3942.08 ± 0.2% | 21.88 ± 0.1% | 5.18 ± 0.1% | 6.78 ± 0.3% | 6408.55 ± 0.5% | 3.26 | 1.00 | 1.63 | 293.59 |
| literal: a word in any case | 217 | 15047.08 ± 1.1% | 2097.77 ± 0.5% | 21.40 ± 0.5% | 3966.61 ± 0.2% | 38.00 ± 0.8% | refused | differs | 14976.85 ± 0.8% | 7.17 | 1.00 | 3.79 | 396.01 |
| literal: an href attribute | 33 | 16573.22 ± 2.3% | 617.44 ± 0.1% | 27.33 ± 0.2% | 16971.55 ± 1.0% | 2258.43 ± 0.4% | 12.57 ± 0.2% | 75.20 ± 0.2% | 16765.56 ± 1.4% | 26.84 | 0.99 | 0.98 | 7.34 |
| literal: a word, second text | 123 | 19588.58 ± 4.3% | 3423.69 ± 0.4% | 28.03 ± 0.3% | 17736.93 ± 2.4% | 7594.79 ± 6.7% | 19.80 ± 0.2% | 69.78 ± 0.3% | 19444.93 ± 3.5% | 5.72 | 1.01 | 1.10 | 2.58 |
| class: two capitalized words | 1331 | 1065.26 ± 1.2% | 609.12 ± 0.1% | 26.04 ± 0.2% | 585.32 ± 0.1% | 40.61 ± 7.0% | 14.20 ± 0.3% | 68.33 ± 0.2% | 1063.51 ± 0.4% | 1.75 | 1.00 | 1.82 | 26.23 |
| class: a word that ends in ing | 3399 | 583.09 ± 0.1% | 582.56 ± 0.3% | 17.99 ± 0.3% | 547.76 ± 0.1% | 29.64 ± 2.9% | 7.96 ± 0.2% | 18.25 ± 0.3% | 583.44 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.67 |
| class: a word in capitals | 2332 | 1391.85 ± 0.6% | 614.49 ± 0.1% | 27.55 ± 0.3% | 571.28 ± 0.2% | 43.54 ± 4.7% | 16.68 ± 0.2% | 83.09 ± 0.4% | 1391.77 ± 1.0% | 2.27 | 1.00 | 2.44 | 31.97 |
| class: a number | 8288 | 2124.23 ± 0.4% | 852.48 ± 0.2% | 27.78 ± 0.4% | 1720.66 ± 0.1% | 41.03 ± 9.5% | 0.52 ± 0.1% | 57.08 ± 0.3% | 2128.70 ± 0.3% | 2.49 | 1.00 | 1.23 | 51.77 |
| class: two capitalized words, second text | 5359 | 525.41 ± 0.2% | 534.89 ± 0.2% | 23.34 ± 0.1% | 483.83 ± 0.1% | 33.85 ± 7.9% | 16.85 ± 0.2% | 63.42 ± 0.4% | 525.73 ± 0.2% | 0.98 | 1.00 | 1.09 | 15.52 |
| other: a word between two words | 6104 | 808.19 ± 0.2% | 609.31 ± 0.2% | 23.53 ± 0.3% | 739.02 ± 0.9% | 109.77 ± 11.4% | 10.74 ± 0.2% | 69.32 ± 0.3% | 794.93 ± 0.1% | 1.33 | 1.02 | 1.09 | 7.36 |
| other: a number before a unit, second text | 1481 | 6149.26 ± 1.0% | 1130.24 ± 0.2% | 25.93 ± 0.3% | 5635.50 ± 0.5% | 40.79 ± 11.3% | 17.87 ± 0.3% | 66.88 ± 0.2% | 6178.71 ± 0.9% | 5.44 | 1.00 | 1.09 | 150.74 |
| other: a heading's start tag | 110 | 13936.33 ± 2.2% | 750.40 ± 0.1% | 27.33 ± 0.3% | 1708.65 ± 0.5% | 1582.25 ± 6.2% | 15.40 ± 0.3% | 88.35 ± 0.4% | 13959.12 ± 1.0% | 18.57 | 1.00 | 8.16 | 8.81 |
| other: a whole word | 217 | 15924.96 ± 1.3% | 608.46 ± 0.2% | 29.33 ± 0.5% | 14472.80 ± 1.3% | 48.10 ± 0.2% | 12.36 ± 0.1% | 55.85 ± 0.6% | 15994.10 ± 2.4% | 26.17 | 1.00 | 1.10 | 331.11 |
| other: a line's first word, second text | 3716 | 2107.86 ± 0.4% | 599.44 ± 0.1% | 30.74 ± 0.6% | 1720.50 ± 0.5% | 62.04 ± 7.2% | refused | refused | 2109.92 ± 0.3% | 3.52 | 1.00 | 1.23 | 33.97 |
| other: fourteen octets before an x | 87 | 23221.23 ± 2.8% | 230.03 ± 0.5% | 6.54 ± 0.1% | 3966.38 ± 1.0% | 10.63 ± 0.3% | differs | 17.55 ± 0.1% | 23268.10 ± 6.6% | 100.95 | 1.00 | 5.85 | 2184.84 |
| other: a Greek word | 21815 | 521.52 ± 0.6% | 424.04 ± 0.3% | 30.74 ± 0.5% | 289.62 ± 0.4% | 48.04 ± 2.2% | differs | refused | 521.44 ± 0.6% | 1.23 | 1.00 | 1.80 | 10.86 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.28 ± 0.5% | 29.19 ± 0.2% | 0.86 ± 0.2% | 19.86 ± 0.2% | 2.78 ± 1.1% | differs | 4.02 ± 0.4% | 29.28 ± 0.4% | 1.00 | 1.00 | 1.47 | 10.54 |
| a UUID | 32895 | 24.71 ± 0.1% | 24.67 ± 0.1% | 0.64 ± 0.1% | 15.11 ± 0.3% | 3.10 ± 0.3% | 0.73 ± 0.2% | 3.62 ± 0.4% | 24.71 ± 0.1% | 1.00 | 1.00 | 1.64 | 7.96 |
| an IPv4 address | 33176 | 38.45 ± 0.2% | 38.48 ± 0.1% | 2.07 ± 0.2% | 29.48 ± 0.5% | 6.64 ± 0.3% | differs | 4.17 ± 0.1% | 38.48 ± 0.4% | 1.00 | 1.00 | 1.30 | 5.79 |
| a date and time | 32954 | 34.39 ± 0.2% | 34.19 ± 0.2% | 1.45 ± 0.2% | 21.53 ± 0.3% | 7.05 ± 0.2% | 1.25 ± 0.2% | 7.14 ± 0.1% | 34.28 ± 0.3% | 1.01 | 1.00 | 1.60 | 4.88 |
| a field path | 32606 | 32.55 ± 0.4% | 32.58 ± 0.4% | 1.01 ± 0.4% | 23.25 ± 0.2% | 3.48 ± 1.0% | differs | 2.94 ± 0.2% | 32.54 ± 0.4% | 1.00 | 1.00 | 1.40 | 9.34 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.11 ± 0.2% | 11.12 ± 0.4% | 11.11 ± 0.4% | 11.78 ± 0.3% | 4.94 ± 3.0% | 0.94 ± 0.2% | none | 11.13 ± 0.2% | 1.00 | 1.00 | 0.94 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 228.84 ± 0.1% | 229.11 ± 0.1% | 271.60 ± 0.3% | 86.35 ± 0.7% | 217.70 ± 0.9% | 478.03 ± 1.1% | 3726.53 ± 2.1% | 228.81 ± 0.2% | 1.00 | 1.00 | 2.65 | 1.05 |
| a UUID | 62 | 150.10 ± 0.3% | 150.30 ± 0.1% | 167.93 ± 0.2% | 46.05 ± 0.9% | 96.70 ± 26.9% | 190.66 ± 2.8% | 4442.83 ± 0.4% | 150.04 ± 0.2% | 1.00 | 1.00 | 3.26 | 1.55 |
| an IPv4 address | 29 | 417.80 ± 0.7% | 418.04 ± 0.6% | 586.81 ± 0.6% | 77.36 ± 0.8% | 127.65 ± 5.3% | 294.02 ± 0.8% | 7558.57 ± 0.2% | 417.71 ± 0.6% | 1.00 | 1.00 | 5.40 | 3.27 |
| a date and time | 56 | 301.51 ± 0.2% | 301.50 ± 0.2% | 380.39 ± 0.2% | 72.44 ± 0.2% | 134.71 ± 3.1% | 327.44 ± 2.7% | 4917.72 ± 0.6% | 301.38 ± 0.3% | 1.00 | 1.00 | 4.16 | 2.24 |
| a field path | 39 | 222.93 ± 0.5% | 222.87 ± 0.3% | 262.93 ± 0.4% | 79.54 ± 2.3% | 202.18 ± 2.9% | 507.36 ± 3.3% | 4825.70 ± 2.8% | 222.67 ± 0.2% | 1.00 | 1.00 | 2.80 | 1.10 |
| literal: a word | 7 | 606.96 ± 0.4% | 659.55 ± 0.3% | 1186.47 ± 0.5% | 498.26 ± 0.4% | 615.11 ± 2.0% | 964.19 ± 0.6% | 29107.48 ± 0.3% | 608.35 ± 0.4% | 0.92 | 1.00 | 1.22 | 0.99 |
| literal: a word that is not there | 8 | 585.90 ± 0.5% | 636.90 ± 0.4% | 1124.22 ± 0.6% | 455.29 ± 0.4% | 594.26 ± 1.4% | 907.82 ± 0.8% | 27798.16 ± 0.1% | 586.27 ± 0.4% | 0.92 | 1.00 | 1.29 | 0.99 |
| literal: one of four words | 26 | 239.43 ± 0.4% | 388.72 ± 0.2% | 533.33 ± 0.3% | 49.61 ± 0.8% | 236.28 ± 2.7% | 366.40 ± 0.8% | 15525.68 ± 0.1% | 239.41 ± 0.2% | 0.62 | 1.00 | 4.83 | 1.01 |
| literal: a word in any case | 11 | 442.75 ± 0.3% | 473.41 ± 0.3% | 700.17 ± 0.1% | 15.53 ± 0.3% | 636.11 ± 2.0% | refused | 22792.61 ± 0.3% | 442.28 ± 0.2% | 0.94 | 1.00 | 28.50 | 0.70 |
| literal: an href attribute | 12 | 336.43 ± 0.7% | 350.05 ± 0.5% | 460.37 ± 0.4% | 36.25 ± 2.6% | 487.61 ± 6.3% | 774.58 ± 0.4% | 21455.17 ± 0.3% | 337.17 ± 0.4% | 0.96 | 1.00 | 9.28 | 0.69 |
| literal: a word, second text | 10 | 542.71 ± 0.8% | 600.51 ± 0.7% | 1007.71 ± 0.5% | 417.23 ± 2.0% | 527.82 ± 1.5% | 789.92 ± 0.6% | 25909.24 ± 0.2% | 542.53 ± 0.6% | 0.90 | 1.00 | 1.30 | 1.03 |
| class: two capitalized words | 23 | 428.13 ± 0.2% | 457.70 ± 0.2% | 662.72 ± 0.2% | 100.03 ± 0.2% | 492.08 ± 0.9% | 740.36 ± 0.7% | 6310.07 ± 0.3% | 427.19 ± 0.3% | 0.94 | 1.00 | 4.28 | 0.87 |
| class: a word that ends in ing | 9 | 543.67 ± 0.1% | 615.09 ± 0.4% | 1079.88 ± 0.4% | 132.96 ± 1.4% | 746.55 ± 1.5% | 1144.61 ± 0.4% | 15533.49 ± 0.1% | 543.55 ± 0.3% | 0.88 | 1.00 | 4.09 | 0.73 |
| class: a word in capitals | 16 | 486.01 ± 0.2% | 524.29 ± 0.3% | 832.22 ± 0.2% | 136.58 ± 0.3% | 743.56 ± 2.0% | 1051.20 ± 0.8% | 8278.32 ± 0.2% | 486.06 ± 0.4% | 0.93 | 1.00 | 3.56 | 0.65 |
| class: a number | 6 | 615.95 ± 0.5% | 674.21 ± 0.4% | 1255.22 ± 0.3% | 42.09 ± 0.9% | 1387.44 ± 2.1% | 1887.76 ± 1.1% | 22070.04 ± 0.3% | 615.51 ± 0.6% | 0.91 | 1.00 | 14.63 | 0.44 |
| class: two capitalized words, second text | 23 | 428.57 ± 0.7% | 458.62 ± 0.7% | 662.13 ± 0.2% | 101.68 ± 1.3% | 494.76 ± 2.8% | 763.01 ± 1.1% | 6311.99 ± 0.1% | 427.60 ± 0.3% | 0.93 | 1.00 | 4.21 | 0.87 |
| other: a word between two words | 13 | 528.36 ± 0.4% | 551.07 ± 0.6% | 880.08 ± 0.1% | 132.70 ± 1.4% | 489.56 ± 7.6% | 812.81 ± 1.9% | 14419.10 ± 0.1% | 528.12 ± 0.5% | 0.96 | 1.00 | 3.98 | 1.08 |
| other: a number before a unit, second text | 15 | 389.71 ± 0.7% | 433.83 ± 0.7% | 612.39 ± 0.1% | 39.53 ± 0.7% | 629.85 ± 1.1% | 892.37 ± 2.8% | 15045.54 ± 0.1% | 389.97 ± 0.6% | 0.90 | 1.00 | 9.86 | 0.62 |
| other: a heading's start tag | 13 | 348.45 ± 0.5% | 357.13 ± 0.4% | 470.76 ± 0.2% | 36.95 ± 0.9% | 622.01 ± 0.9% | 885.06 ± 0.7% | 17920.19 ± 0.1% | 348.55 ± 0.4% | 0.98 | 1.00 | 9.43 | 0.56 |
| other: a whole word | 11 | 562.83 ± 0.7% | 601.25 ± 0.4% | 1016.50 ± 0.3% | 119.61 ± 0.3% | 560.20 ± 1.3% | 844.81 ± 0.5% | 26355.34 ± 0.9% | 562.67 ± 0.2% | 0.94 | 1.00 | 4.71 | 1.00 |
| other: a line's first word, second text | 17 | 509.74 ± 0.6% | 542.22 ± 0.3% | 872.48 ± 0.3% | 127.35 ± 1.1% | 696.68 ± 9.5% | refused | refused | 509.77 ± 0.3% | 0.94 | 1.00 | 4.00 | 0.73 |
| other: fourteen octets before an x | 16 | 106.77 ± 1.1% | 151.82 ± 1.4% | 175.31 ± 0.8% | 13.73 ± 0.4% | 449.44 ± 1.4% | 417.89 ± 0.6% | 12542.94 ± 0.3% | 106.76 ± 1.7% | 0.70 | 1.00 | 7.77 | 0.24 |
| other: a Greek word | 8 | 426.69 ± 0.2% | 584.31 ± 0.7% | 989.29 ± 0.1% | 49.30 ± 1.9% | 1373.98 ± 1.2% | 1803.34 ± 0.5% | refused | 427.05 ± 0.2% | 0.73 | 1.00 | 8.65 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15425.44 ± 0.9% | not timed | not timed | 15905.34 ± 1.2% | 2031.95 ± 28.7% | not timed | not timed | 15418.29 ± 0.8% | | 1.00 | 0.97 | 7.59 |
| 01-literal/sherlock-casei-en | 522 | 11107.33 ± 7.5% | not timed | not timed | 3589.69 ± 0.2% | 31.53 ± 1.1% | not timed | not timed | 11072.74 ± 2.6% | | 1.00 | 3.09 | 352.24 |
| 01-literal/sherlock-ru | 724 | 17175.73 ± 0.6% | not timed | not timed | 17274.84 ± 0.5% | 1432.70 ± 18.1% | not timed | not timed | 17223.18 ± 0.3% | | 1.00 | 0.99 | 11.99 |
| 01-literal/sherlock-casei-ru | 746 | 6148.88 ± 0.2% | not timed | not timed | 3333.37 ± 0.2% | 31.35 ± 0.7% | not timed | not timed | 6147.91 ± 0.3% | | 1.00 | 1.84 | 196.14 |
| 01-literal/sherlock-zh | 30 | 19255.77 ± 0.9% | not timed | not timed | 18159.41 ± 1.9% | 2723.39 ± 10.2% | not timed | not timed | 19255.43 ± 0.8% | | 1.00 | 1.06 | 7.07 |
| 02-literal-alternate/sherlock-en | 714 | 6154.90 ± 0.5% | not timed | not timed | 3936.84 ± 0.2% | 15.99 ± 0.2% | not timed | not timed | 6149.90 ± 0.5% | | 1.00 | 1.56 | 384.94 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1970.26 ± 1.1% | not timed | not timed | 697.85 ± 0.2% | 10.73 ± 0.6% | not timed | not timed | 1973.20 ± 0.9% | | 1.00 | 2.82 | 183.64 |
| 02-literal-alternate/sherlock-ru | 899 | 5544.12 ± 0.3% | not timed | not timed | 3245.42 ± 0.1% | 21.91 ± 0.3% | not timed | not timed | 5534.67 ± 0.1% | | 1.00 | 1.71 | 253.07 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.25 ± 0.4% | not timed | not timed | 1231.11 ± 0.6% | 9.02 ± 0.1% | not timed | not timed | 2054.76 ± 0.4% | | 1.00 | 1.67 | 227.96 |
| 02-literal-alternate/sherlock-zh | 207 | 7329.06 ± 0.9% | not timed | not timed | 4158.25 ± 0.2% | 30.42 ± 7.5% | not timed | not timed | 7318.62 ± 0.7% | | 1.00 | 1.76 | 240.92 |
| 03-date/ascii | 111817 | 133.51 ± 0.7% | not timed | not timed | 95.76 ± 0.2% | 0.20 ± 5.6% | not timed | not timed | 134.13 ± 0.6% | | 1.00 | 1.39 | 662.09 |
| 04-ruff-noqa/real | 84 | 435.44 ± 0.1% | not timed | not timed | 467.61 ± 0.1% | 19.80 ± 1.3% | not timed | not timed | 435.96 ± 0.1% | | 1.00 | 0.93 | 21.99 |
| 04-ruff-noqa/tweaked | 44 | 590.06 ± 0.6% | not timed | not timed | 457.18 ± 0.1% | 363.75 ± 0.3% | not timed | not timed | 592.75 ± 0.2% | | 1.00 | 1.29 | 1.62 |
| 05-lexer-veryl/single | 124800 | 5.19 ± 4.5% | not timed | not timed | 5.18 ± 0.4% | 0.20 ± 4.9% | not timed | not timed | 5.21 ± 2.4% | | 0.99 | 1.00 | 25.43 |
| 06-cloud-flare-redos/original | 107 | 425.79 ± 0.1% | not timed | not timed | 213.41 ± 0.1% | 24.85 ± 0.1% | not timed | not timed | 431.28 ± 0.1% | | 0.99 | 2.00 | 17.13 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.33 ± 0.2% | not timed | not timed | 228.71 ± 0.1% | 26.68 ± 0.5% | not timed | not timed | 430.68 ± 0.1% | | 1.00 | 1.89 | 16.16 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.54 ± 0.1% | not timed | not timed | 256.89 ± 0.0% | 28.84 ± 0.2% | not timed | not timed | 588.68 ± 0.2% | | 1.00 | 2.29 | 20.41 |
| 07-unicode-character-data/parse-line | 558784 | 238.59 ± 1.1% | not timed | not timed | 179.14 ± 0.1% | 42.26 ± 6.1% | not timed | not timed | 239.76 ± 2.2% | | 1.00 | 1.33 | 5.65 |
| 08-words/all-english | 56691 | 127.59 ± 0.5% | not timed | not timed | 82.95 ± 0.3% | 11.73 ± 11.5% | not timed | not timed | 127.52 ± 0.6% | | 1.00 | 1.54 | 10.88 |
| 08-words/long-english | 839 | 623.10 ± 0.2% | not timed | not timed | 596.86 ± 0.3% | 32.28 ± 1.5% | not timed | not timed | 623.69 ± 0.4% | | 1.00 | 1.04 | 19.30 |
| 09-aws-keys/full | 0 | 440.90 ± 0.1% | not timed | not timed | 491.33 ± 0.1% | 64.60 ± 0.2% | not timed | not timed | 439.19 ± 0.1% | | 1.00 | 0.90 | 6.82 |
| 09-aws-keys/quick | 0 | 876.95 ± 0.3% | not timed | not timed | 976.78 ± 0.1% | 420.31 ± 0.9% | not timed | not timed | 876.50 ± 0.2% | | 1.00 | 0.90 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 585.65 ± 2.2% | not timed | not timed | 517.52 ± 0.1% | 19.54 ± 0.5% | not timed | not timed | 583.10 ± 2.8% | | 1.00 | 1.13 | 29.97 |
| 10-bounded-repeat/letters-ru | 3475 | 505.57 ± 1.2% | not timed | not timed | 478.46 ± 0.1% | 21.92 ± 17.7% | not timed | not timed | 506.49 ± 2.8% | | 1.00 | 1.06 | 23.07 |
| 10-bounded-repeat/context | 53 | 84.82 ± 1.9% | not timed | not timed | 65.96 ± 0.4% | 19.80 ± 0.1% | not timed | not timed | 84.85 ± 1.8% | | 1.00 | 1.29 | 4.28 |
| 10-bounded-repeat/capitals | 11 | 632.97 ± 8.5% | not timed | not timed | 618.13 ± 0.4% | 36.58 ± 0.1% | not timed | not timed | 632.49 ± 8.2% | | 1.00 | 1.02 | 17.30 |
| 11-unstructured-to-json/extract | 600 | 57.24 ± 0.3% | not timed | not timed | 76.38 ± 0.2% | 46.05 ± 0.3% | not timed | not timed | 57.28 ± 0.5% | | 1.00 | 0.75 | 1.24 |
| 12-dictionary/single | 1 | 559.62 ± 1.5% | not timed | not timed | 559.53 ± 0.1% | 0.41 ± 0.3% | not timed | not timed | 561.38 ± 1.1% | | 1.00 | 1.00 | 1377.93 |
| 14-quadratic/1x | 100 | 21.26 ± 0.9% | not timed | not timed | 10.05 ± 0.3% | 0.97 ± 3.2% | not timed | not timed | 21.37 ± 0.7% | | 1.00 | 2.11 | 21.97 |
| 14-quadratic/2x | 200 | 17.68 ± 1.6% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 0.9% | not timed | not timed | 17.83 ± 1.3% | | 0.99 | 3.18 | 33.10 |
| 14-quadratic/10x | 1000 | 7.76 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.77 ± 0.4% | | 1.00 | 6.41 | 67.39 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 0.8% | not timed | not timed | 0.34 ± 1.4% | 0.53 ± 3.5% | not timed | not timed | 1.25 ± 0.9% | | 1.00 | 3.66 | 2.35 |
| 04-ruff-noqa/compile-real | 1 | 102.02 ± 0.6% | not timed | not timed | 13.66 ± 0.3% | 136.30 ± 2.3% | not timed | not timed | 101.68 ± 0.5% | | 1.00 | 7.47 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.04 ± 0.3% | not timed | not timed | 2.52 ± 0.8% | 6.42 ± 1.9% | not timed | not timed | 14.01 ± 1.0% | | 1.00 | 5.57 | 2.19 |
| 07-unicode-character-data/compile | 1 | 107.33 ± 0.4% | not timed | not timed | 25.48 ± 0.4% | 35.63 ± 3.1% | not timed | not timed | 107.09 ± 1.3% | | 1.00 | 4.21 | 3.01 |
| 09-aws-keys/compile-full | 1 | 51.93 ± 0.5% | not timed | not timed | 8.21 ± 0.5% | 22.64 ± 3.0% | not timed | not timed | 52.09 ± 0.3% | | 1.00 | 6.32 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 180.19 ± 0.5% | not timed | not timed | 47.05 ± 0.2% | 132.34 ± 5.5% | not timed | not timed | 179.56 ± 0.3% | | 1.00 | 3.83 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 69.43 ± 1.5% | not timed | not timed | 11.02 ± 0.2% | 16.01 ± 4.0% | not timed | not timed | 69.35 ± 0.6% | | 1.00 | 6.30 | 4.34 |
| 10-bounded-repeat/compile-capitals | 1 | 81.38 ± 1.8% | not timed | not timed | 8.01 ± 0.2% | 23.67 ± 1.8% | not timed | not timed | 81.54 ± 0.6% | | 1.00 | 10.16 | 3.44 |
| 11-unstructured-to-json/compile | 1 | 169.15 ± 1.2% | not timed | not timed | 40.71 ± 0.7% | 67.43 ± 3.3% | not timed | not timed | 167.96 ± 1.1% | | 1.01 | 4.16 | 2.51 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.6% | not timed | not timed | 0.07 ± 12.8% | 0.09 ± 20.7% | not timed | not timed | 0.35 ± 0.9% | | 1.00 | 5.01 | 3.68 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.31 ± 0.3% | not timed | not timed | 6.57 ± 0.3% | 0.54 ± 3.0% | not timed | not timed | 7.31 ± 0.5% | | 1.00 | 1.11 | 13.45 |
| dictionary/search/english-10 | 690 | 1.16 ± 2.7% | not timed | not timed | 165.35 ± 0.8% | 0.00 ± 0.4% | not timed | not timed | 1.16 ± 0.4% | | 1.00 | 0.0070 | 455.90 |
| dictionary/search/english-15 | 15 | 564.98 ± 0.9% | not timed | not timed | 559.03 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 567.54 ± 1.1% | | 1.00 | 1.01 | 1543.27 |
| folly/awyer-inn-busted | 1 | 5593.20 ± 0.1% | not timed | not timed | 142.93 ± 0.1% | 44.00 ± 0.4% | not timed | not timed | 5615.55 ± 0.0% | | 1.00 | 39.13 | 127.11 |
| folly/literal-never-match-rare | 0 | 21041.94 ± 1.1% | not timed | not timed | 19799.26 ± 0.7% | 40619.60 ± 0.7% | not timed | not timed | 20903.47 ± 1.5% | | 1.01 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12461.74 ± 1.5% | not timed | not timed | 19806.84 ± 0.6% | 2193.41 ± 1.2% | not timed | not timed | 12508.50 ± 1.3% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3231.45 ± 0.2% | not timed | not timed | 4399.98 ± 0.2% | 3054.99 ± 0.8% | not timed | not timed | 3241.32 ± 0.4% | | 1.00 | 0.73 | 1.06 |
| grep/every-line | 239963 | 1313.88 ± 0.6% | not timed | not timed | 954.36 ± 0.4% | 384.18 ± 17.3% | not timed | not timed | 1322.24 ± 0.5% | | 0.99 | 1.38 | 3.42 |
| grep/long-words-ascii | 5073 | 458.46 ± 0.1% | not timed | not timed | 472.05 ± 0.1% | 46.29 ± 7.7% | not timed | not timed | 458.82 ± 0.2% | | 1.00 | 0.97 | 9.90 |
| imported/leipzig/twain | 811 | 20718.36 ± 1.5% | not timed | not timed | 19580.63 ± 0.5% | 11900.68 ± 9.7% | not timed | not timed | 20738.70 ± 0.9% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9037.57 ± 0.5% | not timed | not timed | 4241.89 ± 1.3% | 37.49 ± 0.2% | not timed | not timed | 9044.22 ± 1.1% | | 1.00 | 2.13 | 241.07 |
| imported/leipzig/shing | 1540 | 15248.93 ± 2.1% | not timed | not timed | 13559.34 ± 2.5% | 34.03 ± 0.0% | not timed | not timed | 15142.04 ± 6.1% | | 1.01 | 1.12 | 448.14 |
| imported/leipzig/huck-saw | 262 | 8260.06 ± 2.9% | not timed | not timed | 5604.77 ± 0.1% | 31.82 ± 0.1% | not timed | not timed | 8453.29 ± 2.7% | | 0.98 | 1.47 | 259.56 |
| imported/leipzig/word-ending-nn | 262 | 604.86 ± 0.2% | not timed | not timed | 616.97 ± 0.2% | 24.73 ± 0.2% | not timed | not timed | 606.23 ± 0.3% | | 1.00 | 0.98 | 24.46 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11206.34 ± 0.6% | not timed | not timed | 4501.80 ± 0.8% | 11.51 ± 0.1% | not timed | not timed | 11218.01 ± 0.8% | | 1.00 | 2.49 | 973.62 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7877.49 ± 1.8% | not timed | not timed | 5492.99 ± 0.1% | 16.89 ± 0.1% | not timed | not timed | 7931.17 ± 2.8% | | 0.99 | 1.43 | 466.50 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4195.10 ± 0.9% | not timed | not timed | 408.76 ± 2.7% | 11.11 ± 0.2% | not timed | not timed | 4195.06 ± 0.8% | | 1.00 | 10.26 | 377.60 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 603.62 ± 0.3% | not timed | not timed | 615.44 ± 0.0% | 11.15 ± 0.2% | not timed | not timed | 603.52 ± 0.3% | | 1.00 | 0.98 | 54.13 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 602.31 ± 0.4% | not timed | not timed | 615.91 ± 0.1% | 9.70 ± 0.1% | not timed | not timed | 602.84 ± 0.4% | | 1.00 | 0.98 | 62.11 |
| imported/leipzig/tom-river | 2 | 6522.69 ± 1.5% | not timed | not timed | 5147.83 ± 0.1% | 30.97 ± 0.0% | not timed | not timed | 6611.42 ± 1.5% | | 0.99 | 1.27 | 210.59 |
| imported/leipzig/ing | 78424 | 601.77 ± 0.7% | not timed | not timed | 571.46 ± 0.1% | 28.08 ± 3.3% | not timed | not timed | 601.95 ± 0.7% | | 1.00 | 1.05 | 21.43 |
| imported/leipzig/ing-whitespace | 55248 | 751.98 ± 1.1% | not timed | not timed | 2084.44 ± 0.9% | 20.59 ± 2.9% | not timed | not timed | 753.55 ± 0.5% | | 1.00 | 0.36 | 36.53 |
| imported/leipzig/awyer-inn | 209 | 767.88 ± 1.4% | not timed | not timed | 4269.59 ± 0.6% | 22.60 ± 0.1% | not timed | not timed | 767.87 ± 1.7% | | 1.00 | 0.18 | 33.97 |
| imported/leipzig/quotes-bounded | 8886 | 2120.08 ± 0.4% | not timed | not timed | 3012.01 ± 0.6% | 38.24 ± 0.1% | not timed | not timed | 2128.87 ± 0.3% | | 1.00 | 0.70 | 55.45 |
| imported/leipzig/non-ascii-alternate | 2 | 12838.54 ± 2.0% | not timed | not timed | 5668.03 ± 0.2% | 50.52 ± 0.0% | not timed | not timed | 13074.18 ± 2.0% | | 0.98 | 2.27 | 254.12 |
| imported/leipzig/math-symbols | 69 | 1976.22 ± 0.4% | not timed | not timed | 618.53 ± 0.0% | 36.48 ± 0.0% | not timed | not timed | 1978.96 ± 0.4% | | 1.00 | 3.20 | 54.17 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.05 ± 1.3% | not timed | not timed | 618.03 ± 0.0% | 22.49 ± 0.1% | not timed | not timed | 585.84 ± 1.4% | | 1.00 | 0.95 | 26.06 |
| imported/lh3lh3-reb/uri | 17549 | 679.18 ± 0.1% | not timed | not timed | 1064.78 ± 0.3% | 27.41 ± 5.8% | not timed | not timed | 678.00 ± 0.3% | | 1.00 | 0.64 | 24.78 |
| imported/lh3lh3-reb/email | 15057 | 674.26 ± 0.1% | not timed | not timed | 1169.98 ± 0.3% | 30.91 ± 2.4% | not timed | not timed | 673.60 ± 0.1% | | 1.00 | 0.58 | 21.81 |
| imported/lh3lh3-reb/date | 668 | 859.65 ± 0.1% | not timed | not timed | 1036.70 ± 0.3% | 51.46 ± 3.9% | not timed | not timed | 860.07 ± 0.2% | | 1.00 | 0.83 | 16.71 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.72 ± 0.1% | not timed | not timed | 423.22 ± 0.3% | 15.85 ± 1.2% | not timed | not timed | 645.77 ± 0.1% | | 1.00 | 1.53 | 40.75 |
| imported/mariomka/email | 92 | 24328.64 ± 1.6% | not timed | not timed | 29561.81 ± 0.8% | 32.84 ± 0.1% | not timed | not timed | 24434.48 ± 1.1% | | 1.00 | 0.82 | 740.92 |
| imported/mariomka/uri | 5301 | 5341.02 ± 0.8% | not timed | not timed | 6131.47 ± 0.3% | 32.72 ± 0.6% | not timed | not timed | 5370.16 ± 0.8% | | 0.99 | 0.87 | 163.23 |
| imported/mariomka/ip | 5 | 2162.26 ± 1.9% | not timed | not timed | 2954.69 ± 0.1% | 21.10 ± 0.2% | not timed | not timed | 2158.44 ± 2.3% | | 1.00 | 0.73 | 102.46 |
| imported/rsc/no-exponential | 0 | 604.45 ± 0.2% | not timed | not timed | 321.84 ± 0.3% | 23.83 ± 0.5% | not timed | not timed | 601.34 ± 0.2% | | 1.01 | 1.88 | 25.36 |
| imported/rsc/literal | 1 | 762.70 ± 5.9% | not timed | not timed | 1585.37 ± 8.8% | 191.28 ± 16.6% | not timed | not timed | 762.19 ± 7.9% | | 1.00 | 0.48 | 3.99 |
| imported/rsc/not-literal | 2 | 779.69 ± 2.1% | not timed | not timed | 712.30 ± 0.3% | 46.38 ± 9.5% | not timed | not timed | 783.41 ± 0.2% | | 1.00 | 1.09 | 16.81 |
| imported/rsc/match-class | 1 | 1442.43 ± 1.2% | not timed | not timed | 1640.63 ± 0.4% | 58.63 ± 7.1% | not timed | not timed | 1438.81 ± 2.3% | | 1.00 | 0.88 | 24.60 |
| imported/rsc/match-class-in-range | 1 | 1446.09 ± 0.5% | not timed | not timed | 2363.74 ± 5.3% | 59.99 ± 6.4% | not timed | not timed | 1440.32 ± 1.9% | | 1.00 | 0.61 | 24.11 |
| imported/rsc/match-class-unicode | 1 | 548.31 ± 0.2% | not timed | not timed | 518.22 ± 0.0% | 72.35 ± 0.1% | not timed | not timed | 549.75 ± 0.1% | | 1.00 | 1.06 | 7.58 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1440.27 ± 0.3% | not timed | not timed | 942.94 ± 0.2% | 228.05 ± 0.6% | not timed | not timed | 1441.28 ± 0.1% | | 1.00 | 1.53 | 6.32 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21607.91 ± 0.2% | not timed | not timed | 14260.20 ± 0.1% | 3422.49 ± 0.3% | not timed | not timed | 21569.20 ± 0.1% | | 1.00 | 1.52 | 6.31 |
| imported/rsc/anchored-literal-short-match | 4 | 708.66 ± 1.9% | not timed | not timed | 491.44 ± 0.3% | 81.26 ± 13.1% | not timed | not timed | 713.33 ± 1.7% | | 0.99 | 1.44 | 8.72 |
| imported/rsc/anchored-literal-long-match | 4 | 10468.03 ± 2.4% | not timed | not timed | 7312.80 ± 0.2% | 1237.55 ± 7.2% | not timed | not timed | 10675.35 ± 2.6% | | 0.98 | 1.43 | 8.46 |
| imported/rsc/one-pass-short | 17 | 371.06 ± 0.8% | not timed | not timed | 215.91 ± 0.2% | 32.72 ± 14.0% | not timed | not timed | 369.51 ± 11.3% | | 1.00 | 1.72 | 11.34 |
| imported/rsc/one-pass-short-not | 17 | 278.86 ± 1.5% | not timed | not timed | 225.04 ± 0.1% | 29.40 ± 10.6% | not timed | not timed | 280.07 ± 2.6% | | 1.00 | 1.24 | 9.49 |
| imported/rsc/one-pass-long-prefix | 26 | 363.09 ± 2.2% | not timed | not timed | 283.40 ± 0.3% | 95.82 ± 18.7% | not timed | not timed | 364.30 ± 2.0% | | 1.00 | 1.28 | 3.79 |
| imported/rsc/one-pass-long-prefix-not | 26 | 360.07 ± 1.4% | not timed | not timed | 281.27 ± 0.4% | 69.92 ± 14.0% | not timed | not timed | 362.80 ± 7.8% | | 0.99 | 1.28 | 5.15 |
| imported/rsc/long-needle1 | 31 | 22181.92 ± 0.3% | not timed | not timed | 20150.80 ± 0.1% | 3.76 ± 0.5% | not timed | not timed | 22200.96 ± 0.1% | | 1.00 | 1.10 | 5895.53 |
| imported/rsc/long-needle2 | 31 | 22332.67 ± 0.1% | not timed | not timed | 216.55 ± 0.2% | 3.76 ± 0.1% | not timed | not timed | 22333.20 ± 0.1% | | 1.00 | 103.13 | 5933.44 |
| imported/rsc/easy0-32 | 26 | 1083.58 ± 2.9% | not timed | not timed | 1585.71 ± 3.4% | 149.34 ± 18.4% | not timed | not timed | 1082.10 ± 0.1% | | 1.00 | 0.68 | 7.26 |
| imported/rsc/easy0-1k | 26 | 14954.22 ± 0.2% | not timed | not timed | 12479.22 ± 0.9% | 2310.39 ± 16.3% | not timed | not timed | 14936.56 ± 2.6% | | 1.00 | 1.20 | 6.47 |
| imported/rsc/easy0-32k | 26 | 22981.81 ± 0.4% | not timed | not timed | 20315.11 ± 0.0% | 18766.43 ± 15.1% | not timed | not timed | 23137.97 ± 8.6% | | 0.99 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21527.78 ± 1.4% | not timed | not timed | 19529.70 ± 1.9% | 35599.92 ± 3.8% | not timed | not timed | 21398.84 ± 1.4% | | 1.01 | 1.10 | 0.60 |
| imported/rsc/easy1-32 | 19 | 805.75 ± 1.9% | not timed | not timed | 634.51 ± 0.3% | 139.06 ± 20.0% | not timed | not timed | 806.26 ± 8.5% | | 1.00 | 1.27 | 5.79 |
| imported/rsc/easy1-1k | 19 | 16491.07 ± 2.8% | not timed | not timed | 12882.18 ± 0.2% | 2459.43 ± 15.3% | not timed | not timed | 16501.92 ± 0.4% | | 1.00 | 1.28 | 6.71 |
| imported/rsc/easy1-32k | 19 | 518122.76 ± 0.2% | not timed | not timed | 404111.77 ± 0.2% | 20539.53 ± 0.2% | not timed | not timed | 517578.23 ± 0.2% | | 1.00 | 1.28 | 25.23 |
| imported/rsc/easy1-1mb | 19 | 16637845.72 ± 0.1% | not timed | not timed | 13052606.93 ± 0.4% | 38330.81 ± 3.0% | not timed | not timed | 16588040.51 ± 0.2% | | 1.00 | 1.27 | 434.06 |
| imported/rsc/medium-32 | 27 | 773.99 ± 1.8% | not timed | not timed | 630.80 ± 0.2% | 70.06 ± 12.7% | not timed | not timed | 775.70 ± 0.4% | | 1.00 | 1.23 | 11.05 |
| imported/rsc/medium-1k | 27 | 13726.82 ± 0.2% | not timed | not timed | 11277.44 ± 0.6% | 72.31 ± 0.1% | not timed | not timed | 13811.32 ± 0.7% | | 0.99 | 1.22 | 189.84 |
| imported/rsc/medium-32k | 27 | 427936.53 ± 0.3% | not timed | not timed | 348464.64 ± 0.3% | 48.74 ± 0.1% | not timed | not timed | 430861.29 ± 0.4% | | 0.99 | 1.23 | 8780.35 |
| imported/rsc/medium-1mb | 27 | 13702236.89 ± 0.5% | not timed | not timed | 11392894.04 ± 0.2% | 48.66 ± 0.3% | not timed | not timed | 13777937.31 ± 0.8% | | 0.99 | 1.20 | 281606.03 |
| imported/rsc/hard-32 | 58 | 422.88 ± 1.9% | not timed | not timed | 367.77 ± 0.1% | 49.68 ± 7.3% | not timed | not timed | 421.09 ± 0.1% | | 1.00 | 1.15 | 8.51 |
| imported/rsc/hard-1k | 27 | 13430.99 ± 0.4% | not timed | not timed | 11636.56 ± 0.1% | 40.64 ± 0.1% | not timed | not timed | 13417.63 ± 0.3% | | 1.00 | 1.15 | 330.51 |
| imported/rsc/hard-32k | 27 | 419174.72 ± 0.2% | not timed | not timed | 360678.43 ± 0.2% | 29.40 ± 0.1% | not timed | not timed | 419623.77 ± 0.1% | | 1.00 | 1.16 | 14255.38 |
| imported/rsc/hard-1mb | 51 | 8427398.14 ± 0.1% | not timed | not timed | 7301634.66 ± 0.3% | 29.44 ± 0.1% | not timed | not timed | 8388952.45 ± 0.2% | | 1.00 | 1.15 | 286302.73 |
| imported/rsc/reallyhard0-32 | 58 | 267.67 ± 0.2% | not timed | not timed | 220.99 ± 0.1% | 49.85 ± 8.1% | not timed | not timed | 266.91 ± 2.6% | | 1.00 | 1.21 | 5.37 |
| imported/rsc/reallyhard0-1k | 27 | 591.45 ± 0.7% | not timed | not timed | 585.55 ± 0.2% | 40.87 ± 0.1% | not timed | not timed | 589.99 ± 0.2% | | 1.00 | 1.01 | 14.47 |
| imported/rsc/reallyhard0-32k | 27 | 610.59 ± 0.3% | not timed | not timed | 615.88 ± 0.1% | 29.41 ± 0.1% | not timed | not timed | 610.77 ± 0.2% | | 1.00 | 0.99 | 20.76 |
| imported/rsc/reallyhard0-1mb | 51 | 589.04 ± 0.8% | not timed | not timed | 617.60 ± 0.7% | 29.40 ± 0.2% | not timed | not timed | 587.58 ± 0.7% | | 1.00 | 0.95 | 20.03 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.04 ± 1.7% | not timed | not timed | 197.05 ± 5.3% | 61.25 ± 11.8% | not timed | not timed | 288.15 ± 5.3% | | 1.00 | 1.46 | 4.70 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6883.25 ± 0.0% | not timed | not timed | 5955.89 ± 0.2% | 33.07 ± 4.4% | not timed | not timed | 6894.05 ± 0.1% | | 1.00 | 1.16 | 208.14 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21506.79 ± 0.1% | not timed | not timed | 19266.36 ± 0.1% | 24.87 ± 0.1% | not timed | not timed | 21514.19 ± 0.0% | | 1.00 | 1.12 | 864.79 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21580.80 ± 2.3% | not timed | not timed | 19706.30 ± 1.3% | 25.20 ± 0.0% | not timed | not timed | 21638.08 ± 2.6% | | 1.00 | 1.10 | 856.49 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.48 ± 1.6% | not timed | not timed | 213.27 ± 0.4% | 60.91 ± 10.3% | not timed | not timed | 281.30 ± 1.4% | | 1.00 | 1.32 | 4.64 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5899.30 ± 0.2% | not timed | not timed | 6189.50 ± 0.2% | 34.55 ± 2.8% | not timed | not timed | 5888.94 ± 0.1% | | 1.00 | 0.95 | 170.75 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21433.62 ± 0.1% | not timed | not timed | 19268.69 ± 0.1% | 24.58 ± 1.5% | not timed | not timed | 21441.45 ± 0.0% | | 1.00 | 1.11 | 872.01 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20671.93 ± 2.8% | not timed | not timed | 19140.08 ± 1.7% | 24.89 ± 1.4% | not timed | not timed | 20556.65 ± 1.8% | | 1.01 | 1.08 | 830.37 |
| imported/sherlock/name-sherlock | 776 | 19507.63 ± 3.1% | not timed | not timed | 18221.52 ± 0.9% | 8626.57 ± 23.6% | not timed | not timed | 19531.76 ± 2.4% | | 1.00 | 1.07 | 2.26 |
| imported/sherlock/name-holmes | 2766 | 14573.10 ± 4.5% | not timed | not timed | 15360.93 ± 0.6% | 3288.38 ± 4.9% | not timed | not timed | 15084.37 ± 5.7% | | 0.97 | 0.95 | 4.43 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19498.73 ± 1.5% | not timed | not timed | 18232.69 ± 0.8% | 8024.53 ± 14.5% | not timed | not timed | 19538.51 ± 0.9% | | 1.00 | 1.07 | 2.43 |
| imported/sherlock/name-sherlock-casei | 816 | 15602.35 ± 1.1% | not timed | not timed | 4017.20 ± 0.2% | 32.57 ± 0.5% | not timed | not timed | 15613.49 ± 0.7% | | 1.00 | 3.88 | 479.01 |
| imported/sherlock/name-holmes-casei | 2802 | 9434.81 ± 8.1% | not timed | not timed | 3295.32 ± 0.2% | 38.28 ± 13.4% | not timed | not timed | 9419.57 ± 5.9% | | 1.00 | 2.86 | 246.49 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13013.59 ± 5.4% | not timed | not timed | 3948.37 ± 0.2% | 32.54 ± 0.6% | not timed | not timed | 13005.40 ± 1.4% | | 1.00 | 3.30 | 399.97 |
| imported/sherlock/name-whitespace | 1461 | 15201.72 ± 0.2% | not timed | not timed | 14354.21 ± 0.7% | 7370.49 ± 31.9% | not timed | not timed | 15214.91 ± 5.6% | | 1.00 | 1.06 | 2.06 |
| imported/sherlock/name-alt1 | 1142 | 11631.16 ± 2.6% | not timed | not timed | 16244.52 ± 1.6% | 4107.62 ± 14.3% | not timed | not timed | 11653.52 ± 0.3% | | 1.00 | 0.72 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8962.88 ± 0.4% | not timed | not timed | 3827.75 ± 0.1% | 31.34 ± 0.1% | not timed | not timed | 8954.93 ± 0.4% | | 1.00 | 2.34 | 286.00 |
| imported/sherlock/name-alt3 | 4507 | 5584.37 ± 0.5% | not timed | not timed | 3631.46 ± 0.2% | 9.85 ± 4.2% | not timed | not timed | 5580.31 ± 0.6% | | 1.00 | 1.54 | 566.83 |
| imported/sherlock/name-alt3-casei | 4593 | 1527.48 ± 1.7% | not timed | not timed | 285.59 ± 0.3% | 6.49 ± 0.1% | not timed | not timed | 1532.34 ± 1.2% | | 1.00 | 5.35 | 235.28 |
| imported/sherlock/name-alt4 | 3686 | 6360.51 ± 0.3% | not timed | not timed | 3762.49 ± 0.2% | 31.26 ± 0.2% | not timed | not timed | 6352.65 ± 0.9% | | 1.00 | 1.69 | 203.47 |
| imported/sherlock/name-alt4-casei | 4254 | 2802.92 ± 2.0% | not timed | not timed | 2566.88 ± 0.2% | 19.87 ± 0.1% | not timed | not timed | 2802.27 ± 1.0% | | 1.00 | 1.09 | 141.07 |
| imported/sherlock/name-alt5 | 4028 | 6443.27 ± 0.3% | not timed | not timed | 3745.04 ± 0.2% | 21.72 ± 0.0% | not timed | not timed | 6441.98 ± 0.3% | | 1.00 | 1.72 | 296.62 |
| imported/sherlock/name-alt5-casei | 4104 | 3501.88 ± 2.0% | not timed | not timed | 2212.50 ± 0.3% | 14.35 ± 0.1% | not timed | not timed | 3513.76 ± 0.7% | | 1.00 | 1.58 | 244.08 |
| imported/sherlock/no-match-uncommon | 0 | 21298.04 ± 0.6% | not timed | not timed | 19132.52 ± 1.1% | 34682.55 ± 0.3% | not timed | not timed | 21283.90 ± 0.6% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21065.62 ± 0.2% | not timed | not timed | 19144.26 ± 0.5% | 1282.19 ± 0.7% | not timed | not timed | 21074.14 ± 0.3% | | 1.00 | 1.10 | 16.43 |
| imported/sherlock/no-match-really-common | 0 | 15779.94 ± 2.6% | not timed | not timed | 18377.85 ± 0.7% | 1292.94 ± 0.2% | not timed | not timed | 15819.31 ± 1.1% | | 1.00 | 0.86 | 12.20 |
| imported/sherlock/the-lower | 21654 | 2307.70 ± 2.9% | not timed | not timed | 2324.71 ± 0.3% | 242.04 ± 18.4% | not timed | not timed | 2326.28 ± 0.7% | | 0.99 | 0.99 | 9.53 |
| imported/sherlock/the-upper | 2223 | 12667.47 ± 1.0% | not timed | not timed | 13399.58 ± 1.2% | 2684.36 ± 23.7% | not timed | not timed | 12689.40 ± 8.1% | | 1.00 | 0.95 | 4.72 |
| imported/sherlock/the-casei | 23961 | 2008.25 ± 1.3% | not timed | not timed | 1317.20 ± 0.3% | 34.97 ± 34.7% | not timed | not timed | 2012.23 ± 0.3% | | 1.00 | 1.52 | 57.43 |
| imported/sherlock/everything-greedy | 581881 | 282.38 ± 0.7% | not timed | not timed | 165.98 ± 0.1% | 28.77 ± 23.7% | not timed | not timed | 283.26 ± 0.2% | | 1.00 | 1.70 | 9.81 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.67 ± 0.1% | not timed | not timed | 212.78 ± 0.2% | 32.97 ± 0.2% | not timed | not timed | 462.51 ± 0.2% | | 1.00 | 2.17 | 14.03 |
| imported/sherlock/letters | 447175 | 61.39 ± 8.0% | not timed | not timed | 32.58 ± 0.1% | 5.35 ± 25.0% | not timed | not timed | 62.42 ± 0.4% | | 0.98 | 1.88 | 11.47 |
| imported/sherlock/letters-upper | 14180 | 453.64 ± 1.3% | not timed | not timed | 371.38 ± 0.1% | 29.12 ± 26.3% | not timed | not timed | 453.00 ± 0.6% | | 1.00 | 1.22 | 15.58 |
| imported/sherlock/letters-lower | 432995 | 63.59 ± 0.2% | not timed | not timed | 33.48 ± 0.1% | 5.84 ± 9.9% | not timed | not timed | 63.68 ± 0.3% | | 1.00 | 1.90 | 10.89 |
| imported/sherlock/words | 447639 | 114.95 ± 0.4% | not timed | not timed | 81.77 ± 0.2% | 14.00 ± 2.1% | not timed | not timed | 114.92 ± 0.8% | | 1.00 | 1.41 | 8.21 |
| imported/sherlock/before-holmes | 4073 | 10260.64 ± 0.3% | not timed | not timed | 8344.54 ± 0.4% | 24.10 ± 1.8% | not timed | not timed | 10279.42 ± 0.4% | | 1.00 | 1.23 | 425.84 |
| imported/sherlock/before-after-holmes | 2593 | 9843.07 ± 0.4% | not timed | not timed | 9420.74 ± 0.5% | 23.99 ± 0.8% | not timed | not timed | 9835.61 ± 0.7% | | 1.00 | 1.04 | 410.29 |
| imported/sherlock/holmes-cochar-watson | 150 | 5184.92 ± 0.2% | not timed | not timed | 3425.98 ± 0.2% | 31.03 ± 0.1% | not timed | not timed | 5188.84 ± 0.2% | | 1.00 | 1.51 | 167.10 |
| imported/sherlock/holmes-coword-watson | 14309 | 1190.38 ± 0.6% | not timed | not timed | 1121.37 ± 0.3% | 6.78 ± 0.3% | not timed | not timed | 1192.86 ± 1.1% | | 1.00 | 1.06 | 175.48 |
| imported/sherlock/quotes | 14437 | 1400.84 ± 0.5% | not timed | not timed | 1753.46 ± 0.8% | 35.14 ± 0.3% | not timed | not timed | 1400.10 ± 0.5% | | 1.00 | 0.80 | 39.87 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.60 ± 0.3% | not timed | not timed | 15852.11 ± 0.4% | 36.76 ± 0.3% | not timed | not timed | 609.67 ± 0.2% | | 1.00 | 0.0385 | 16.58 |
| imported/sherlock/word-ending-n | 35297 | 480.74 ± 0.5% | not timed | not timed | 409.58 ± 0.1% | 23.50 ± 0.7% | not timed | not timed | 481.64 ± 0.3% | | 1.00 | 1.17 | 20.46 |
| imported/sherlock/repeated-class-negation | 2130 | 14651.33 ± 1.0% | not timed | not timed | 10941.53 ± 0.6% | 11.58 ± 0.1% | not timed | not timed | 14670.24 ± 0.5% | | 1.00 | 1.34 | 1265.64 |
| imported/sherlock/ing-suffix | 20547 | 566.41 ± 0.2% | not timed | not timed | 517.10 ± 0.2% | 28.91 ± 31.2% | not timed | not timed | 566.39 ± 1.3% | | 1.00 | 1.10 | 19.59 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.45 ± 0.3% | not timed | not timed | 2101.58 ± 0.3% | 20.50 ± 0.1% | not timed | not timed | 607.12 ± 0.9% | | 1.00 | 0.29 | 29.63 |
| opt/accelerate/whole-line | 239963 | 458.26 ± 0.1% | not timed | not timed | 376.92 ± 0.1% | 92.32 ± 16.4% | not timed | not timed | 458.03 ± 0.3% | | 1.00 | 1.22 | 4.96 |
| opt/accelerate/non-dna | 16745 | 425.51 ± 0.7% | not timed | not timed | 401.54 ± 0.1% | 28.92 ± 19.4% | not timed | not timed | 427.86 ± 0.8% | | 0.99 | 1.06 | 14.71 |
| opt/backtrack/words-english | 40536 | 136.42 ± 1.0% | not timed | not timed | 94.65 ± 0.1% | 19.79 ± 8.0% | not timed | not timed | 136.55 ± 2.0% | | 1.00 | 1.44 | 6.89 |
| opt/fixed-length/too-small-ascii | 0 | 311.98 ± 0.3% | not timed | not timed | 694.34 ± 4.2% | 80.02 ± 0.9% | not timed | not timed | 306.34 ± 0.3% | | 1.02 | 0.45 | 3.90 |
| opt/fixed-length/too-big-ascii | 0 | 3485.10 ± 0.1% | not timed | not timed | 5789.38 ± 0.7% | 126.95 ± 0.4% | not timed | not timed | 3457.93 ± 0.2% | | 1.01 | 0.60 | 27.45 |
| opt/fixed-length/go33484-1 | 0 | 670138.86 ± 0.2% | not timed | not timed | 1115931.43 ± 0.6% | 61477.02 ± 0.5% | not timed | not timed | 663939.60 ± 0.3% | | 1.01 | 0.60 | 10.90 |
| opt/fixed-length/go33484-2 | 0 | 670599.85 ± 0.2% | not timed | not timed | 1125735.59 ± 0.8% | 32677.04 ± 1.2% | not timed | not timed | 664352.53 ± 0.1% | | 1.01 | 0.60 | 20.52 |
| opt/fixed-length/go33484-3 | 0 | 2434.77 ± 3.0% | not timed | not timed | 112023.41 ± 0.3% | 761.63 ± 0.4% | not timed | not timed | 2489.89 ± 2.7% | | 0.98 | 0.0217 | 3.20 |
| opt/literal-alt/one-pattern | 1 | 549.76 ± 3.3% | not timed | not timed | 545.44 ± 0.5% | 0.39 ± 0.2% | not timed | not timed | 550.02 ± 1.7% | | 1.00 | 1.01 | 1408.61 |
| opt/onepass/fn-predicate | 916 | 370.53 ± 0.4% | not timed | not timed | 329.38 ± 0.3% | 198.81 ± 15.2% | not timed | not timed | 370.83 ± 0.8% | | 1.00 | 1.12 | 1.86 |
| opt/onepass/first-three-words-english | 35128 | 173.19 ± 8.6% | not timed | not timed | 200.41 ± 0.1% | 80.24 ± 14.5% | not timed | not timed | 176.87 ± 2.3% | | 0.98 | 0.86 | 2.16 |
| opt/prefilter/literal-english | 1 | 20349.72 ± 0.3% | not timed | not timed | 19514.82 ± 0.2% | 17277.95 ± 0.5% | not timed | not timed | 20348.46 ± 0.5% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14269.91 ± 1.1% | not timed | not timed | 4312.18 ± 0.1% | 32.76 ± 0.2% | not timed | not timed | 14273.81 ± 0.5% | | 1.00 | 3.31 | 435.65 |
| opt/prefilter/literal-russian | 1 | 21119.71 ± 0.5% | not timed | not timed | 19715.68 ± 0.7% | 3325.73 ± 0.1% | not timed | not timed | 21091.28 ± 0.7% | | 1.00 | 1.07 | 6.35 |
| opt/prefilter/literal-casei-russian | 1 | 8570.23 ± 0.3% | not timed | not timed | 3885.34 ± 0.2% | 31.74 ± 0.4% | not timed | not timed | 8576.82 ± 0.3% | | 1.00 | 2.21 | 269.99 |
| opt/prefilter/rust-functions | 948 | 6818.64 ± 0.2% | not timed | not timed | 8922.88 ± 0.4% | 1841.43 ± 0.7% | not timed | not timed | 6827.68 ± 0.3% | | 1.00 | 0.76 | 3.70 |
| opt/reverse-anchored/word-end | 1 | 29982620.89 ± 0.5% | not timed | not timed | 21037926.67 ± 0.2% | 48.50 ± 0.3% | not timed | not timed | 29909920.48 ± 0.3% | | 1.00 | 1.43 | 618244.90 |
| opt/reverse-inner/holmes | 2593 | 9871.90 ± 0.5% | not timed | not timed | 9419.46 ± 0.4% | 23.99 ± 1.8% | not timed | not timed | 9858.42 ± 0.5% | | 1.00 | 1.05 | 411.47 |
| opt/reverse-inner/email | 47 | 36216.54 ± 1.7% | not timed | not timed | 44942.67 ± 0.6% | 31.53 ± 0.1% | not timed | not timed | 36850.53 ± 2.4% | | 0.98 | 0.81 | 1148.55 |
| opt/reverse-inner/factored-prefix | 3542 | 601.18 ± 0.2% | not timed | not timed | 595.27 ± 0.1% | 12.45 ± 0.3% | not timed | not timed | 600.68 ± 0.2% | | 1.00 | 1.01 | 48.30 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5556.88 ± 0.1% | not timed | not timed | 619.31 ± 0.1% | 75.05 ± 0.2% | not timed | not timed | 5532.94 ± 0.1% | | 1.00 | 8.97 | 74.04 |
| opt/reverse-inner/no-quadratic-forward | 0 | 688.05 ± 1.7% | not timed | not timed | 288.13 ± 0.5% | 24.83 ± 0.1% | not timed | not timed | 687.80 ± 2.0% | | 1.00 | 2.39 | 27.71 |
| opt/reverse-suffix/holmes | 4073 | 10260.14 ± 0.4% | not timed | not timed | 8363.60 ± 0.2% | 23.71 ± 1.0% | not timed | not timed | 10297.94 ± 0.4% | | 1.00 | 1.23 | 432.79 |
| opt/reverse-suffix/no-quadratic | 0 | 5532.25 ± 0.1% | not timed | not timed | 616.34 ± 0.2% | 75.19 ± 0.1% | not timed | not timed | 5559.93 ± 0.0% | | 1.00 | 8.98 | 73.58 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 122.15 ± 8.0% | not timed | not timed | 135.09 ± 0.2% | 13.38 ± 16.2% | not timed | not timed | 122.23 ± 2.2% | | 1.00 | 0.90 | 9.13 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.54 ± 2.2% | not timed | not timed | 134.68 ± 0.9% | 13.35 ± 12.1% | not timed | not timed | 122.86 ± 0.6% | | 0.98 | 0.89 | 9.03 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.3% | 110.50 ± 1.1% | not timed | not timed | 0.28 ± 0.3% | | 1.00 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.82 ± 3.0% | not timed | not timed | 294.30 ± 0.1% | 104.33 ± 8.2% | not timed | not timed | 312.81 ± 0.2% | | 1.02 | 1.08 | 3.05 |
| reported/i13-subset-regex/original-ascii | 4094 | 11167.60 ± 0.7% | not timed | not timed | 4540.32 ± 0.5% | 11.47 ± 0.1% | not timed | not timed | 11240.26 ± 0.8% | | 0.99 | 2.46 | 973.72 |
| reported/i13-subset-regex/original-unicode | 4094 | 11054.97 ± 0.9% | not timed | not timed | 251.54 ± 3.5% | 11.45 ± 0.2% | not timed | not timed | 11249.64 ± 0.7% | | 0.98 | 43.95 | 965.75 |
| reported/i13-subset-regex/big-ascii | 1955 | 10696.36 ± 0.8% | not timed | not timed | 68.07 ± 3.7% | 9.84 ± 0.1% | not timed | not timed | 10744.07 ± 1.0% | | 1.00 | 157.13 | 1086.69 |
| reported/i13-subset-regex/big-unicode | 1955 | 10636.18 ± 1.2% | not timed | not timed | 12.22 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10741.31 ± 0.7% | | 0.99 | 870.13 | 1079.35 |
| reported/i13-subset-regex/huge-ascii | 55 | 10134.33 ± 1.2% | not timed | not timed | 11.04 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 10085.48 ± 2.7% | | 1.00 | 918.33 | 1155.12 |
| reported/i13-subset-regex/huge-unicode | 55 | 10054.45 ± 2.6% | not timed | not timed | 10.99 ± 0.3% | 8.79 ± 0.1% | not timed | not timed | 9914.06 ± 2.2% | | 1.01 | 914.55 | 1144.14 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 10.98 ± 0.1% | 8.78 ± 0.1% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.04 ± 0.0% | not timed | not timed | 10.97 ± 0.4% | 8.77 ± 1.4% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 487.78 ± 0.3% | not timed | not timed | 103.85 ± 0.1% | 6.64 ± 0.1% | not timed | not timed | 487.86 ± 0.3% | | 1.00 | 4.70 | 73.44 |
| reported/i787-keywords/opt-ascii | 5674 | 488.42 ± 0.3% | not timed | not timed | 271.93 ± 0.2% | 10.29 ± 0.0% | not timed | not timed | 488.98 ± 0.4% | | 1.00 | 1.80 | 47.45 |
| slow/quadratic-regex-1x | 100 | 7.14 ± 0.1% | not timed | not timed | 5.00 ± 0.4% | 0.05 ± 0.4% | not timed | not timed | 7.15 ± 0.3% | | 1.00 | 1.43 | 144.43 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.2% | not timed | not timed | 2.77 ± 0.3% | 0.01 ± 0.4% | not timed | not timed | 3.43 ± 0.1% | | 1.00 | 1.24 | 268.39 |
| slow/quadratic-haystack-1x | 100 | 21.24 ± 6.0% | not timed | not timed | 10.07 ± 0.3% | 1.01 ± 15.2% | not timed | not timed | 21.34 ± 1.7% | | 1.00 | 2.11 | 20.94 |
| slow/quadratic-haystack-2x | 200 | 17.81 ± 1.4% | not timed | not timed | 5.56 ± 0.1% | 0.54 ± 1.5% | not timed | not timed | 17.82 ± 12.3% | | 1.00 | 3.21 | 32.70 |
| unicode/codepoints/any-one | 1112064 | 291.49 ± 0.6% | not timed | not timed | 176.66 ± 0.1% | 18.08 ± 4.0% | not timed | not timed | 291.57 ± 0.3% | | 1.00 | 1.65 | 16.12 |
| unicode/codepoints/any-all | 4382592 | 270.15 ± 0.5% | not timed | not timed | 247.15 ± 0.2% | 113.72 ± 0.2% | not timed | not timed | 270.56 ± 0.3% | | 1.00 | 1.09 | 2.38 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.79 ± 0.9% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.06 ± 0.7% | not timed | not timed | 616.47 ± 0.2% | 135.43 ± 0.5% | not timed | not timed | 603.22 ± 0.4% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 32.01 ± 0.3% | not timed | not timed | 39.00 ± 0.2% | 3.95 ± 0.4% | not timed | not timed | 32.05 ± 0.4% | | 1.00 | 0.82 | 8.10 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.1% | not timed | not timed | 3.40 ± 0.2% | 2.34 ± 0.1% | not timed | not timed | 1.45 ± 0.2% | | 1.00 | 0.43 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.6% | not timed | not timed | 2.85 ± 0.2% | 6.20 ± 9.5% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.45 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 127.66 ± 4.8% | not timed | not timed | 82.82 ± 0.1% | 11.75 ± 12.2% | not timed | not timed | 128.69 ± 0.5% | | 0.99 | 1.54 | 10.86 |
| unicode/word/boundary-long-english | 3466 | 615.54 ± 0.1% | not timed | not timed | 603.84 ± 0.1% | 32.34 ± 0.8% | not timed | not timed | 615.59 ± 0.1% | | 1.00 | 1.02 | 19.03 |
| unicode/word/around-holmes-english | 27 | 19342.56 ± 0.5% | not timed | not timed | 19273.05 ± 0.3% | 21.95 ± 1.4% | not timed | not timed | 19341.43 ± 0.9% | | 1.00 | 1.00 | 881.16 |
| wild/bibleref/long | 874 | 561.70 ± 0.2% | not timed | not timed | 584.32 ± 0.1% | 6.81 ± 0.3% | not timed | not timed | 561.87 ± 0.1% | | 1.00 | 0.96 | 82.43 |
| wild/bibleref/short | 30 | 23.53 ± 1.5% | not timed | not timed | 30.84 ± 0.4% | 14.02 ± 7.5% | not timed | not timed | 24.00 ± 6.6% | | 0.98 | 0.76 | 1.68 |
| wild/bibleref/line | 874 | 394.64 ± 0.2% | not timed | not timed | 218.80 ± 0.2% | 9.11 ± 0.2% | not timed | not timed | 394.81 ± 0.2% | | 1.00 | 1.80 | 43.30 |
| wild/caddy/caddy | 6 | 416.01 ± 7.1% | not timed | not timed | 243.16 ± 0.2% | 66.46 ± 11.3% | not timed | not timed | 417.82 ± 2.2% | | 1.00 | 1.71 | 6.26 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.27 ± 0.5% | not timed | not timed | 344.91 ± 0.2% | 13.52 ± 0.1% | not timed | not timed | 1072.52 ± 0.4% | | 1.00 | 3.10 | 79.19 |
| wild/ruff/noqa | 84 | 436.29 ± 0.0% | not timed | not timed | 463.92 ± 0.1% | 19.51 ± 2.2% | not timed | not timed | 434.38 ± 0.1% | | 1.00 | 0.94 | 22.37 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.64 ± 0.4% | not timed | not timed | 705.59 ± 0.1% | 135.92 ± 11.2% | not timed | not timed | 959.94 ± 0.5% | | 1.00 | 1.36 | 7.05 |
| wild/ruff/string-quote-prefix | 2972 | 1348.41 ± 0.7% | not timed | not timed | 443.84 ± 0.1% | 315.09 ± 27.4% | not timed | not timed | 1348.60 ± 0.7% | | 1.00 | 3.04 | 4.28 |
| wild/ruff/space-around-operator | 1224378 | 220.64 ± 2.3% | not timed | not timed | 187.62 ± 0.0% | 18.46 ± 1.6% | not timed | not timed | 221.10 ± 1.8% | | 1.00 | 1.18 | 11.95 |
| wild/ruff/shebang | 282 | 979.69 ± 0.4% | not timed | not timed | 331.78 ± 0.1% | 111.12 ± 9.6% | not timed | not timed | 985.86 ± 0.5% | | 0.99 | 2.95 | 8.82 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13794.22 ± 1.1% | not timed | not timed | 13788.03 ± 1.6% | 6933.40 ± 1.7% | not timed | not timed | 13772.86 ± 1.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12830.35 ± 0.5% | not timed | not timed | 13463.81 ± 0.4% | 6387.90 ± 0.4% | not timed | not timed | 12817.82 ± 0.6% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13181.19 ± 0.4% | not timed | not timed | 13712.90 ± 0.3% | 6623.80 ± 0.7% | not timed | not timed | 13180.24 ± 0.5% | | 1.00 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9549.02 ± 0.2% | not timed | not timed | 13652.93 ± 0.3% | 6767.56 ± 1.1% | not timed | not timed | 9568.72 ± 0.2% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 121.40 ± 14.5% | not timed | not timed | 65.48 ± 0.6% | 2.25 ± 0.7% | not timed | not timed | 121.46 ± 14.1% | | 1.00 | 1.85 | 54.04 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 63.3% | not timed | not timed | 0.01 ± 6.2% | 0.01 ± 20.4% | not timed | not timed | 0.03 ± 6.0% | | 0.99 | 3.05 | 3.78 |
| dictionary/compile/english-15 | 1 | 0.35 ± 32.9% | not timed | not timed | 0.07 ± 0.4% | 0.10 ± 9.6% | not timed | not timed | 0.35 ± 0.9% | | 1.00 | 4.99 | 3.45 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 14.0% | not timed | not timed | 0.02 ± 0.7% | 34.94 ± 13.8% | not timed | not timed | 0.24 ± 3.1% | | 0.98 | 12.32 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.50 ± 3.9% | not timed | not timed | 11.48 ± 0.5% | 61.17 ± 18.7% | not timed | not timed | 45.84 ± 17.9% | | 0.99 | 3.96 | 0.74 |
| reported/i787-keywords/compile | 1 | 35.42 ± 2.0% | not timed | not timed | 2.12 ± 0.7% | 17.03 ± 35.0% | not timed | not timed | 35.41 ± 4.8% | | 1.00 | 16.71 | 2.08 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 338.70 ± 9.2% | not timed | not timed | 120.26 ± 0.2% | 562.38 ± 34.2% | not timed | not timed | 336.17 ± 6.5% | | 1.01 | 2.82 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.95 ± 2.8% | not timed | not timed | 4.06 ± 1.0% | 42.82 ± 7.4% | not timed | not timed | 47.44 ± 2.3% | | 0.99 | 11.58 | 1.10 |
| unicode/compile/one-letter | 53 | 6.64 ± 13.8% | not timed | not timed | 4.56 ± 0.2% | 65.19 ± 2.7% | not timed | not timed | 6.72 ± 13.5% | | 0.99 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.00 ± 10.2% | not timed | not timed | 0.10 ± 0.5% | 66.85 ± 9.6% | not timed | not timed | 1.05 ± 18.5% | | 0.95 | 10.18 | 0.0150 |
| unicode/compile/fifty-letters-ascii | 1 | 205.49 ± 4.3% | not timed | not timed | 52.75 ± 0.3% | 187.58 ± 15.6% | not timed | not timed | 207.88 ± 3.6% | | 0.99 | 3.90 | 1.10 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 379.72 ± 21.1% | not timed | not timed | 47.24 ± 0.8% | 679.42 ± 9.6% | not timed | not timed | 377.95 ± 27.2% | | 1.00 | 8.04 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 593.18 ± 3.6% | not timed | not timed | 145.48 ± 0.1% | 665.80 ± 29.8% | not timed | not timed | 587.59 ± 12.0% | | 1.01 | 4.08 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 304.12 ± 4.1% | not timed | not timed | 51.32 ± 0.3% | 1226.34 ± 2.3% | not timed | not timed | 312.08 ± 3.8% | | 0.97 | 5.93 | 0.25 |
| wild/bibleref/compile | 3 | 5.80 ± 3.3% | not timed | not timed | 1.94 ± 1.1% | 30.66 ± 4.6% | not timed | not timed | 5.90 ± 3.9% | | 0.98 | 2.99 | 0.19 |
| wild/url/compile | 1 | 0.65 ± 15.4% | not timed | not timed | 0.14 ± 0.6% | 0.41 ± 16.2% | not timed | not timed | 0.65 ± 7.9% | | 1.00 | 4.53 | 1.60 |

