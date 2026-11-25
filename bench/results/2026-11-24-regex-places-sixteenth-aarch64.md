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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507050846 |
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
| literal: a word | 217 | 19310.10 ± 2.4% | 5073.06 ± 0.5% | 27.74 ± 0.3% | 17894.55 ± 1.9% | 9250.24 ± 6.6% | 17.36 ± 0.3% | 85.84 ± 0.2% | 19286.42 ± 4.9% | 3.81 | 1.00 | 1.08 | 2.09 |
| literal: a word that is not there | 0 | 21029.01 ± 2.6% | 4930.58 ± 0.2% | 27.73 ± 0.3% | 19500.55 ± 1.1% | 26716.55 ± 6.7% | 17.23 ± 0.3% | 81.74 ± 0.2% | 21081.05 ± 2.8% | 4.27 | 1.00 | 1.08 | 0.79 |
| literal: one of four words | 661 | 6385.08 ± 0.6% | 1972.31 ± 0.1% | 14.25 ± 0.1% | 3933.86 ± 0.2% | 21.87 ± 0.1% | 5.36 ± 0.1% | 6.74 ± 0.4% | 6409.89 ± 0.2% | 3.24 | 1.00 | 1.62 | 291.97 |
| literal: a word in any case | 217 | 14997.03 ± 0.8% | 2100.39 ± 0.3% | 21.23 ± 0.3% | 3964.21 ± 0.5% | 38.01 ± 0.4% | refused | differs | 15086.81 ± 0.6% | 7.14 | 0.99 | 3.78 | 394.58 |
| literal: an href attribute | 33 | 16918.67 ± 0.9% | 617.41 ± 0.1% | 26.81 ± 0.3% | 16872.89 ± 3.0% | 2258.35 ± 0.6% | 13.27 ± 0.1% | 74.89 ± 0.2% | 17007.46 ± 1.2% | 27.40 | 0.99 | 1.00 | 7.49 |
| literal: a word, second text | 123 | 19400.46 ± 4.2% | 3419.35 ± 1.6% | 27.54 ± 0.4% | 18134.68 ± 2.5% | 7549.07 ± 4.8% | 20.05 ± 0.4% | 68.40 ± 0.3% | 19355.73 ± 6.3% | 5.67 | 1.00 | 1.07 | 2.57 |
| class: two capitalized words | 1331 | 1066.30 ± 1.2% | 608.59 ± 0.2% | 25.63 ± 0.1% | 584.73 ± 0.1% | 40.58 ± 0.3% | 14.82 ± 0.2% | 68.13 ± 0.7% | 1062.02 ± 1.2% | 1.75 | 1.00 | 1.82 | 26.27 |
| class: a word that ends in ing | 3399 | 581.96 ± 0.1% | 582.14 ± 0.2% | 17.84 ± 0.3% | 547.23 ± 0.1% | 29.53 ± 0.8% | 8.09 ± 0.1% | 18.20 ± 0.3% | 583.17 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.71 |
| class: a word in capitals | 2332 | 1388.24 ± 0.3% | 613.85 ± 0.1% | 27.13 ± 0.4% | 571.77 ± 0.3% | 43.44 ± 7.4% | 17.22 ± 0.2% | 82.79 ± 0.4% | 1387.38 ± 0.7% | 2.26 | 1.00 | 2.43 | 31.95 |
| class: a number | 8288 | 2127.18 ± 0.3% | 852.15 ± 0.2% | 27.31 ± 0.4% | 1720.66 ± 0.3% | 41.01 ± 12.8% | 0.55 ± 0.5% | 56.59 ± 0.3% | 2128.90 ± 0.5% | 2.50 | 1.00 | 1.24 | 51.87 |
| class: two capitalized words, second text | 5359 | 525.26 ± 0.2% | 534.57 ± 0.1% | 23.08 ± 0.2% | 483.37 ± 0.1% | 35.28 ± 3.9% | 17.06 ± 0.3% | 63.44 ± 0.2% | 524.80 ± 0.2% | 0.98 | 1.00 | 1.09 | 14.89 |
| other: a word between two words | 6104 | 805.74 ± 0.2% | 608.35 ± 0.2% | 23.31 ± 0.3% | 738.70 ± 0.3% | 106.84 ± 10.0% | 11.24 ± 0.2% | 68.97 ± 0.5% | 806.94 ± 0.5% | 1.32 | 1.00 | 1.09 | 7.54 |
| other: a number before a unit, second text | 1481 | 6159.99 ± 0.9% | 1129.24 ± 0.2% | 25.57 ± 0.3% | 5642.84 ± 0.8% | 40.68 ± 9.7% | 18.13 ± 0.3% | 66.59 ± 0.2% | 6141.57 ± 1.3% | 5.45 | 1.00 | 1.09 | 151.43 |
| other: a heading's start tag | 110 | 14186.80 ± 1.5% | 750.03 ± 1.8% | 26.91 ± 0.5% | 1709.16 ± 0.3% | 1580.02 ± 6.3% | 16.07 ± 0.5% | 88.43 ± 0.3% | 14302.39 ± 2.9% | 18.91 | 0.99 | 8.30 | 8.98 |
| other: a whole word | 217 | 16311.38 ± 1.4% | 606.15 ± 0.8% | 28.80 ± 0.3% | 14644.36 ± 1.8% | 47.89 ± 0.4% | 13.07 ± 0.2% | 55.28 ± 0.3% | 16401.33 ± 1.6% | 26.91 | 0.99 | 1.11 | 340.60 |
| other: a line's first word, second text | 3716 | 2096.31 ± 0.5% | 598.35 ± 0.2% | 30.14 ± 0.4% | 1720.96 ± 0.3% | 62.75 ± 6.8% | refused | refused | 2108.38 ± 1.2% | 3.50 | 0.99 | 1.22 | 33.41 |
| other: fourteen octets before an x | 87 | 24231.59 ± 1.5% | 239.05 ± 0.4% | 6.52 ± 0.1% | 3868.21 ± 0.8% | 10.63 ± 0.1% | differs | 17.43 ± 0.1% | 24479.72 ± 7.4% | 101.37 | 0.99 | 6.26 | 2278.77 |
| other: a Greek word | 21815 | 520.35 ± 0.2% | 424.60 ± 0.1% | 30.47 ± 0.3% | 289.33 ± 0.3% | 51.43 ± 8.1% | differs | refused | 521.79 ± 0.6% | 1.23 | 1.00 | 1.80 | 10.12 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.15 ± 0.1% | 29.24 ± 0.2% | 0.86 ± 0.4% | 19.75 ± 0.5% | 2.77 ± 1.6% | differs | 4.02 ± 0.2% | 29.26 ± 0.3% | 1.00 | 1.00 | 1.48 | 10.51 |
| a UUID | 32895 | 24.45 ± 0.3% | 24.59 ± 0.4% | 0.64 ± 0.1% | 15.17 ± 0.6% | 3.08 ± 0.6% | 0.73 ± 0.2% | 3.60 ± 0.4% | 24.70 ± 0.3% | 0.99 | 0.99 | 1.61 | 7.92 |
| an IPv4 address | 33176 | 38.32 ± 0.2% | 38.32 ± 0.3% | 2.08 ± 0.2% | 28.89 ± 0.5% | 6.64 ± 0.2% | differs | 4.16 ± 0.1% | 38.31 ± 0.3% | 1.00 | 1.00 | 1.33 | 5.77 |
| a date and time | 32954 | 34.41 ± 0.4% | 34.08 ± 0.2% | 1.45 ± 0.2% | 21.41 ± 0.2% | 7.02 ± 0.2% | 1.25 ± 0.2% | 7.12 ± 0.3% | 34.26 ± 0.4% | 1.01 | 1.00 | 1.61 | 4.90 |
| a field path | 32606 | 32.51 ± 0.2% | 32.48 ± 0.5% | 1.02 ± 1.1% | 23.15 ± 0.7% | 3.48 ± 0.6% | differs | 2.90 ± 0.1% | 32.46 ± 0.4% | 1.00 | 1.00 | 1.40 | 9.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.4% | 11.09 ± 0.0% | 11.13 ± 0.3% | 11.39 ± 0.1% | 4.94 ± 1.7% | 0.94 ± 0.5% | none | 11.06 ± 0.2% | 1.00 | 1.01 | 0.98 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.34 ± 0.6% | 223.26 ± 0.4% | 265.44 ± 0.4% | 86.44 ± 0.9% | 219.38 ± 15.1% | 479.73 ± 0.6% | 3740.49 ± 0.7% | 222.64 ± 0.4% | 1.00 | 1.00 | 2.57 | 1.01 |
| a UUID | 62 | 144.30 ± 0.7% | 144.82 ± 0.4% | 162.92 ± 0.2% | 45.78 ± 0.8% | 98.34 ± 1.2% | 186.48 ± 2.1% | 4468.38 ± 0.4% | 144.71 ± 0.5% | 1.00 | 1.00 | 3.15 | 1.47 |
| an IPv4 address | 29 | 407.85 ± 0.3% | 408.63 ± 0.4% | 580.34 ± 0.3% | 78.70 ± 1.5% | 129.72 ± 1.3% | 308.00 ± 1.9% | 7656.85 ± 0.1% | 407.82 ± 0.2% | 1.00 | 1.00 | 5.18 | 3.14 |
| a date and time | 56 | 298.73 ± 0.5% | 299.57 ± 0.7% | 382.47 ± 0.4% | 74.00 ± 0.4% | 134.88 ± 1.1% | 329.27 ± 1.0% | 4956.23 ± 1.0% | 298.97 ± 0.3% | 1.00 | 1.00 | 4.04 | 2.21 |
| a field path | 39 | 214.83 ± 0.5% | 215.00 ± 0.4% | 255.13 ± 0.1% | 78.61 ± 1.1% | 203.56 ± 0.6% | 500.66 ± 4.2% | 4846.43 ± 0.2% | 214.71 ± 0.3% | 1.00 | 1.00 | 2.73 | 1.06 |
| literal: a word | 7 | 594.70 ± 0.8% | 645.41 ± 1.0% | 1191.30 ± 0.1% | 496.66 ± 0.4% | 622.73 ± 1.4% | 956.60 ± 0.5% | 30546.04 ± 0.1% | 596.01 ± 0.4% | 0.92 | 1.00 | 1.20 | 0.95 |
| literal: a word that is not there | 8 | 573.36 ± 0.5% | 621.89 ± 0.9% | 1124.81 ± 0.9% | 457.87 ± 0.2% | 601.38 ± 2.3% | 901.45 ± 0.3% | 29552.69 ± 0.3% | 573.89 ± 1.0% | 0.92 | 1.00 | 1.25 | 0.95 |
| literal: one of four words | 26 | 235.64 ± 0.4% | 383.80 ± 0.4% | 535.35 ± 0.9% | 50.69 ± 1.0% | 240.90 ± 2.4% | 368.31 ± 0.4% | 15773.57 ± 0.1% | 235.92 ± 0.3% | 0.61 | 1.00 | 4.65 | 0.98 |
| literal: a word in any case | 11 | 436.17 ± 0.2% | 466.01 ± 0.4% | 701.48 ± 0.1% | 15.70 ± 0.3% | 654.97 ± 5.5% | refused | 23795.09 ± 0.4% | 435.58 ± 0.5% | 0.94 | 1.00 | 27.79 | 0.67 |
| literal: an href attribute | 12 | 334.12 ± 0.2% | 347.46 ± 0.5% | 463.50 ± 0.5% | 44.78 ± 0.3% | 496.66 ± 1.2% | 763.22 ± 0.5% | 22422.77 ± 0.5% | 334.14 ± 0.3% | 0.96 | 1.00 | 7.46 | 0.67 |
| literal: a word, second text | 10 | 529.24 ± 0.6% | 583.73 ± 2.6% | 1003.91 ± 1.0% | 405.07 ± 0.4% | 536.95 ± 1.2% | 793.83 ± 0.6% | 27465.72 ± 0.2% | 531.19 ± 0.4% | 0.91 | 1.00 | 1.31 | 0.99 |
| class: two capitalized words | 23 | 419.39 ± 0.9% | 447.87 ± 0.7% | 659.84 ± 0.7% | 101.75 ± 1.5% | 501.93 ± 1.6% | 736.73 ± 0.7% | 6379.04 ± 0.0% | 418.78 ± 0.7% | 0.94 | 1.00 | 4.12 | 0.84 |
| class: a word that ends in ing | 9 | 524.02 ± 0.3% | 594.23 ± 0.2% | 1072.91 ± 0.5% | 132.54 ± 0.4% | 755.54 ± 1.2% | 1102.31 ± 2.3% | 15942.48 ± 0.1% | 523.01 ± 0.4% | 0.88 | 1.00 | 3.95 | 0.69 |
| class: a word in capitals | 16 | 467.45 ± 0.2% | 506.72 ± 0.4% | 833.46 ± 0.2% | 134.57 ± 1.2% | 746.95 ± 1.6% | 1014.91 ± 1.9% | 8389.35 ± 0.1% | 466.99 ± 0.4% | 0.92 | 1.00 | 3.47 | 0.63 |
| class: a number | 6 | 590.10 ± 0.4% | 652.53 ± 0.4% | 1263.93 ± 0.3% | 41.91 ± 0.8% | 1397.28 ± 1.0% | 1833.69 ± 3.6% | 23129.42 ± 0.1% | 590.08 ± 0.5% | 0.90 | 1.00 | 14.08 | 0.42 |
| class: two capitalized words, second text | 23 | 419.89 ± 1.1% | 448.87 ± 0.9% | 660.40 ± 1.4% | 101.57 ± 2.4% | 500.55 ± 1.4% | 736.30 ± 0.4% | 6380.43 ± 0.1% | 418.45 ± 0.6% | 0.94 | 1.00 | 4.13 | 0.84 |
| other: a word between two words | 13 | 518.27 ± 0.7% | 540.13 ± 0.4% | 883.03 ± 0.3% | 133.05 ± 0.4% | 500.99 ± 1.0% | 804.08 ± 1.1% | 14756.57 ± 0.1% | 519.58 ± 0.2% | 0.96 | 1.00 | 3.90 | 1.03 |
| other: a number before a unit, second text | 15 | 378.67 ± 0.3% | 420.22 ± 0.3% | 600.46 ± 0.6% | 39.34 ± 0.3% | 628.93 ± 1.7% | 885.76 ± 0.4% | 15403.47 ± 0.1% | 378.55 ± 0.4% | 0.90 | 1.00 | 9.63 | 0.60 |
| other: a heading's start tag | 13 | 346.09 ± 0.4% | 353.94 ± 0.5% | 472.68 ± 0.5% | 43.89 ± 0.6% | 626.20 ± 0.3% | 872.58 ± 0.4% | 18514.21 ± 0.0% | 346.32 ± 0.4% | 0.98 | 1.00 | 7.89 | 0.55 |
| other: a whole word | 11 | 550.48 ± 0.2% | 587.12 ± 0.4% | 1012.39 ± 0.4% | 118.45 ± 0.3% | 561.64 ± 2.1% | 831.79 ± 0.4% | 26932.21 ± 0.2% | 549.84 ± 0.3% | 0.94 | 1.00 | 4.65 | 0.98 |
| other: a line's first word, second text | 17 | 496.13 ± 0.5% | 526.51 ± 0.4% | 870.97 ± 0.1% | 129.59 ± 0.2% | 709.96 ± 0.5% | refused | refused | 497.51 ± 0.5% | 0.94 | 1.00 | 3.83 | 0.70 |
| other: fourteen octets before an x | 16 | 105.97 ± 0.7% | 151.03 ± 0.8% | 176.89 ± 1.1% | 14.83 ± 0.3% | 450.66 ± 1.6% | 415.62 ± 0.4% | 12780.51 ± 0.3% | 106.13 ± 0.7% | 0.70 | 1.00 | 7.15 | 0.24 |
| other: a Greek word | 8 | 412.04 ± 0.6% | 565.28 ± 0.3% | 987.09 ± 0.3% | 58.74 ± 0.6% | 1378.35 ± 1.0% | 1804.80 ± 0.3% | refused | 412.12 ± 0.6% | 0.73 | 1.00 | 7.01 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15529.19 ± 0.8% | not timed | not timed | 16063.37 ± 0.8% | 2137.58 ± 13.3% | not timed | not timed | 15516.19 ± 0.7% | | 1.00 | 0.97 | 7.26 |
| 01-literal/sherlock-casei-en | 522 | 10920.47 ± 5.7% | not timed | not timed | 3587.77 ± 0.3% | 32.33 ± 4.6% | not timed | not timed | 10926.20 ± 3.3% | | 1.00 | 3.04 | 337.78 |
| 01-literal/sherlock-ru | 724 | 17113.77 ± 0.4% | not timed | not timed | 17080.96 ± 1.6% | 1471.54 ± 11.4% | not timed | not timed | 17154.94 ± 0.2% | | 1.00 | 1.00 | 11.63 |
| 01-literal/sherlock-casei-ru | 746 | 6115.25 ± 0.7% | not timed | not timed | 3320.81 ± 0.3% | 31.39 ± 9.7% | not timed | not timed | 6137.82 ± 0.3% | | 1.00 | 1.84 | 194.84 |
| 01-literal/sherlock-zh | 30 | 19806.23 ± 1.1% | not timed | not timed | 18724.14 ± 0.9% | 2500.99 ± 15.5% | not timed | not timed | 19785.37 ± 0.8% | | 1.00 | 1.06 | 7.92 |
| 02-literal-alternate/sherlock-en | 714 | 6128.45 ± 0.3% | not timed | not timed | 3925.04 ± 0.1% | 16.22 ± 5.2% | not timed | not timed | 6133.65 ± 1.0% | | 1.00 | 1.56 | 377.94 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1963.81 ± 1.4% | not timed | not timed | 696.59 ± 0.3% | 10.94 ± 0.2% | not timed | not timed | 1970.99 ± 1.4% | | 1.00 | 2.82 | 179.57 |
| 02-literal-alternate/sherlock-ru | 899 | 5527.63 ± 0.4% | not timed | not timed | 3248.61 ± 0.2% | 21.78 ± 0.1% | not timed | not timed | 5519.71 ± 0.1% | | 1.00 | 1.70 | 253.83 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2052.58 ± 0.3% | not timed | not timed | 1230.02 ± 0.7% | 9.07 ± 2.5% | not timed | not timed | 2052.19 ± 0.5% | | 1.00 | 1.67 | 226.26 |
| 02-literal-alternate/sherlock-zh | 207 | 7297.52 ± 0.5% | not timed | not timed | 4150.11 ± 0.1% | 30.77 ± 0.2% | not timed | not timed | 7283.62 ± 0.5% | | 1.00 | 1.76 | 237.15 |
| 03-date/ascii | 111817 | 133.15 ± 0.7% | not timed | not timed | 95.74 ± 0.1% | 0.20 ± 3.6% | not timed | not timed | 134.11 ± 0.6% | | 0.99 | 1.39 | 657.86 |
| 04-ruff-noqa/real | 84 | 437.93 ± 0.1% | not timed | not timed | 478.39 ± 0.1% | 19.60 ± 0.1% | not timed | not timed | 437.76 ± 0.2% | | 1.00 | 0.92 | 22.34 |
| 04-ruff-noqa/tweaked | 44 | 592.78 ± 0.4% | not timed | not timed | 459.63 ± 0.1% | 364.49 ± 0.6% | not timed | not timed | 593.30 ± 0.3% | | 1.00 | 1.29 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.27 ± 0.3% | not timed | not timed | 5.12 ± 0.2% | 0.20 ± 3.3% | not timed | not timed | 5.26 ± 0.3% | | 1.00 | 1.03 | 26.02 |
| 06-cloud-flare-redos/original | 107 | 426.56 ± 0.4% | not timed | not timed | 214.45 ± 0.1% | 24.81 ± 0.1% | not timed | not timed | 430.91 ± 0.2% | | 0.99 | 1.99 | 17.19 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.13 ± 0.1% | not timed | not timed | 228.19 ± 0.1% | 26.61 ± 0.2% | not timed | not timed | 429.39 ± 0.2% | | 1.00 | 1.89 | 16.20 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.02 ± 0.1% | not timed | not timed | 256.75 ± 0.0% | 28.65 ± 0.2% | not timed | not timed | 588.11 ± 0.1% | | 1.00 | 2.29 | 20.53 |
| 07-unicode-character-data/parse-line | 558784 | 237.54 ± 1.1% | not timed | not timed | 178.71 ± 0.2% | 42.68 ± 5.6% | not timed | not timed | 238.75 ± 0.8% | | 0.99 | 1.33 | 5.56 |
| 08-words/all-english | 56691 | 127.71 ± 0.8% | not timed | not timed | 81.27 ± 0.1% | 11.70 ± 2.2% | not timed | not timed | 127.31 ± 0.6% | | 1.00 | 1.57 | 10.92 |
| 08-words/long-english | 839 | 622.88 ± 0.2% | not timed | not timed | 595.47 ± 0.2% | 32.17 ± 0.4% | not timed | not timed | 623.21 ± 0.2% | | 1.00 | 1.05 | 19.36 |
| 09-aws-keys/full | 0 | 443.05 ± 0.2% | not timed | not timed | 473.67 ± 0.1% | 64.26 ± 3.4% | not timed | not timed | 441.58 ± 0.1% | | 1.00 | 0.94 | 6.89 |
| 09-aws-keys/quick | 0 | 874.32 ± 0.2% | not timed | not timed | 1000.45 ± 0.3% | 418.44 ± 1.0% | not timed | not timed | 873.95 ± 0.2% | | 1.00 | 0.87 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 580.10 ± 2.8% | not timed | not timed | 517.03 ± 0.3% | 19.47 ± 0.3% | not timed | not timed | 581.44 ± 2.2% | | 1.00 | 1.12 | 29.79 |
| 10-bounded-repeat/letters-ru | 3475 | 501.98 ± 1.4% | not timed | not timed | 477.25 ± 0.1% | 23.01 ± 9.5% | not timed | not timed | 504.41 ± 3.1% | | 1.00 | 1.05 | 21.81 |
| 10-bounded-repeat/context | 53 | 85.09 ± 1.7% | not timed | not timed | 65.92 ± 0.4% | 19.78 ± 0.1% | not timed | not timed | 85.16 ± 1.5% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 633.04 ± 8.3% | not timed | not timed | 617.95 ± 0.1% | 35.39 ± 0.2% | not timed | not timed | 633.25 ± 8.4% | | 1.00 | 1.02 | 17.89 |
| 11-unstructured-to-json/extract | 600 | 57.24 ± 1.2% | not timed | not timed | 76.82 ± 0.1% | 49.25 ± 1.5% | not timed | not timed | 57.22 ± 0.7% | | 1.00 | 0.75 | 1.16 |
| 12-dictionary/single | 1 | 559.99 ± 0.8% | not timed | not timed | 560.56 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 561.42 ± 1.5% | | 1.00 | 1.00 | 1407.56 |
| 14-quadratic/1x | 100 | 21.39 ± 1.4% | not timed | not timed | 9.99 ± 0.1% | 0.97 ± 3.0% | not timed | not timed | 21.41 ± 1.5% | | 1.00 | 2.14 | 22.16 |
| 14-quadratic/2x | 200 | 17.74 ± 1.1% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.8% | not timed | not timed | 17.80 ± 1.2% | | 1.00 | 3.20 | 33.52 |
| 14-quadratic/10x | 1000 | 7.75 ± 1.5% | not timed | not timed | 1.20 ± 0.2% | 0.12 ± 0.5% | not timed | not timed | 7.78 ± 0.3% | | 1.00 | 6.43 | 67.15 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 1.7% | not timed | not timed | 0.34 ± 2.1% | 0.55 ± 2.4% | not timed | not timed | 1.25 ± 0.5% | | 1.00 | 3.64 | 2.26 |
| 04-ruff-noqa/compile-real | 1 | 105.07 ± 1.2% | not timed | not timed | 13.78 ± 0.5% | 138.64 ± 1.6% | not timed | not timed | 104.63 ± 1.0% | | 1.00 | 7.63 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 13.97 ± 1.3% | not timed | not timed | 2.53 ± 0.4% | 6.40 ± 2.4% | not timed | not timed | 14.07 ± 0.3% | | 0.99 | 5.52 | 2.18 |
| 07-unicode-character-data/compile | 1 | 108.75 ± 0.6% | not timed | not timed | 25.67 ± 0.5% | 35.86 ± 2.4% | not timed | not timed | 108.40 ± 0.7% | | 1.00 | 4.24 | 3.03 |
| 09-aws-keys/compile-full | 1 | 52.66 ± 0.4% | not timed | not timed | 8.24 ± 0.5% | 23.19 ± 1.0% | not timed | not timed | 52.56 ± 0.4% | | 1.00 | 6.39 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 182.50 ± 1.1% | not timed | not timed | 47.08 ± 0.3% | 134.43 ± 2.1% | not timed | not timed | 181.66 ± 0.3% | | 1.00 | 3.88 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 71.02 ± 1.9% | not timed | not timed | 11.15 ± 0.3% | 16.00 ± 2.6% | not timed | not timed | 71.00 ± 0.6% | | 1.00 | 6.37 | 4.44 |
| 10-bounded-repeat/compile-capitals | 1 | 81.97 ± 2.1% | not timed | not timed | 8.04 ± 1.0% | 23.87 ± 1.6% | not timed | not timed | 81.77 ± 0.4% | | 1.00 | 10.20 | 3.43 |
| 11-unstructured-to-json/compile | 1 | 172.14 ± 1.2% | not timed | not timed | 40.58 ± 0.9% | 67.56 ± 2.8% | not timed | not timed | 170.66 ± 1.1% | | 1.01 | 4.24 | 2.55 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.6% | not timed | not timed | 0.07 ± 0.2% | 0.10 ± 30.1% | not timed | not timed | 0.35 ± 0.4% | | 1.00 | 5.07 | 3.59 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.24 ± 2.7% | not timed | not timed | 6.54 ± 0.2% | 0.59 ± 19.2% | not timed | not timed | 7.29 ± 3.2% | | 0.99 | 1.11 | 12.29 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.8% | not timed | not timed | 164.20 ± 0.2% | 0.00 ± 0.6% | not timed | not timed | 1.16 ± 0.8% | | 1.00 | 0.0070 | 413.40 |
| dictionary/search/english-15 | 15 | 565.56 ± 1.1% | not timed | not timed | 559.69 ± 0.1% | 0.37 ± 0.4% | not timed | not timed | 566.91 ± 1.1% | | 1.00 | 1.01 | 1548.82 |
| folly/awyer-inn-busted | 1 | 5586.05 ± 0.1% | not timed | not timed | 143.27 ± 0.1% | 43.72 ± 0.2% | not timed | not timed | 5608.86 ± 0.1% | | 1.00 | 38.99 | 127.77 |
| folly/literal-never-match-rare | 0 | 21084.47 ± 0.4% | not timed | not timed | 19905.52 ± 0.6% | 40848.28 ± 2.1% | not timed | not timed | 21076.27 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12478.97 ± 1.5% | not timed | not timed | 19852.03 ± 0.2% | 2196.34 ± 1.2% | not timed | not timed | 12506.12 ± 1.3% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3236.94 ± 0.4% | not timed | not timed | 4410.38 ± 0.3% | 2988.02 ± 3.1% | not timed | not timed | 3242.81 ± 0.2% | | 1.00 | 0.73 | 1.08 |
| grep/every-line | 239963 | 1313.81 ± 2.2% | not timed | not timed | 950.98 ± 0.6% | 373.22 ± 16.8% | not timed | not timed | 1316.76 ± 0.9% | | 1.00 | 1.38 | 3.52 |
| grep/long-words-ascii | 5073 | 458.42 ± 0.1% | not timed | not timed | 469.35 ± 0.1% | 46.18 ± 8.2% | not timed | not timed | 457.17 ± 0.4% | | 1.00 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20618.03 ± 1.3% | not timed | not timed | 19498.70 ± 0.5% | 11882.00 ± 9.5% | not timed | not timed | 20612.96 ± 1.0% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9036.32 ± 0.7% | not timed | not timed | 4244.32 ± 0.2% | 37.72 ± 0.1% | not timed | not timed | 9059.05 ± 0.9% | | 1.00 | 2.13 | 239.57 |
| imported/leipzig/shing | 1540 | 15196.77 ± 2.0% | not timed | not timed | 13506.67 ± 0.6% | 33.95 ± 0.1% | not timed | not timed | 15447.12 ± 2.6% | | 0.98 | 1.13 | 447.57 |
| imported/leipzig/huck-saw | 262 | 8219.78 ± 3.0% | not timed | not timed | 5590.79 ± 0.2% | 31.71 ± 0.2% | not timed | not timed | 8326.65 ± 3.4% | | 0.99 | 1.47 | 259.18 |
| imported/leipzig/word-ending-nn | 262 | 602.25 ± 0.7% | not timed | not timed | 617.06 ± 0.1% | 24.68 ± 1.5% | not timed | not timed | 603.00 ± 0.9% | | 1.00 | 0.98 | 24.40 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11190.53 ± 0.8% | not timed | not timed | 4352.01 ± 1.3% | 11.50 ± 0.1% | not timed | not timed | 11228.91 ± 1.0% | | 1.00 | 2.57 | 972.75 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7792.00 ± 1.7% | not timed | not timed | 5477.10 ± 0.1% | 16.87 ± 0.0% | not timed | not timed | 7918.67 ± 2.1% | | 0.98 | 1.42 | 461.93 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4172.06 ± 0.8% | not timed | not timed | 417.96 ± 0.7% | 11.10 ± 0.1% | not timed | not timed | 4196.11 ± 0.6% | | 0.99 | 9.98 | 375.95 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.13 ± 0.7% | not timed | not timed | 614.70 ± 0.1% | 11.12 ± 0.1% | not timed | not timed | 601.25 ± 1.0% | | 1.00 | 0.98 | 54.17 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 601.97 ± 0.7% | not timed | not timed | 614.73 ± 0.2% | 9.36 ± 0.0% | not timed | not timed | 602.40 ± 0.4% | | 1.00 | 0.98 | 64.33 |
| imported/leipzig/tom-river | 2 | 6436.15 ± 3.8% | not timed | not timed | 5126.45 ± 0.3% | 30.98 ± 0.1% | not timed | not timed | 6495.67 ± 2.0% | | 0.99 | 1.26 | 207.79 |
| imported/leipzig/ing | 78424 | 599.59 ± 0.5% | not timed | not timed | 571.41 ± 0.1% | 28.05 ± 3.3% | not timed | not timed | 600.30 ± 0.8% | | 1.00 | 1.05 | 21.37 |
| imported/leipzig/ing-whitespace | 55248 | 750.41 ± 0.9% | not timed | not timed | 2061.49 ± 1.0% | 20.55 ± 2.9% | not timed | not timed | 751.73 ± 0.3% | | 1.00 | 0.36 | 36.52 |
| imported/leipzig/awyer-inn | 209 | 765.95 ± 1.7% | not timed | not timed | 4177.21 ± 3.0% | 22.61 ± 0.1% | not timed | not timed | 767.03 ± 1.4% | | 1.00 | 0.18 | 33.87 |
| imported/leipzig/quotes-bounded | 8886 | 2101.15 ± 0.7% | not timed | not timed | 2964.98 ± 1.5% | 38.23 ± 0.1% | not timed | not timed | 2111.78 ± 0.6% | | 0.99 | 0.71 | 54.96 |
| imported/leipzig/non-ascii-alternate | 2 | 12734.79 ± 1.5% | not timed | not timed | 5649.63 ± 0.3% | 50.54 ± 0.1% | not timed | not timed | 12848.20 ± 2.0% | | 0.99 | 2.25 | 251.95 |
| imported/leipzig/math-symbols | 69 | 1974.36 ± 1.2% | not timed | not timed | 617.79 ± 0.0% | 36.42 ± 0.1% | not timed | not timed | 1982.15 ± 1.2% | | 1.00 | 3.20 | 54.20 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.94 ± 0.8% | not timed | not timed | 617.56 ± 0.1% | 22.53 ± 0.0% | not timed | not timed | 586.01 ± 1.1% | | 1.00 | 0.95 | 26.05 |
| imported/lh3lh3-reb/uri | 17549 | 678.92 ± 0.1% | not timed | not timed | 1077.82 ± 0.1% | 27.88 ± 2.1% | not timed | not timed | 678.25 ± 0.3% | | 1.00 | 0.63 | 24.35 |
| imported/lh3lh3-reb/email | 15057 | 673.76 ± 0.2% | not timed | not timed | 1168.41 ± 0.1% | 30.98 ± 2.3% | not timed | not timed | 672.94 ± 0.2% | | 1.00 | 0.58 | 21.75 |
| imported/lh3lh3-reb/date | 668 | 860.36 ± 0.3% | not timed | not timed | 1039.05 ± 0.1% | 51.44 ± 3.8% | not timed | not timed | 859.24 ± 0.2% | | 1.00 | 0.83 | 16.72 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.24 ± 0.1% | not timed | not timed | 423.38 ± 0.1% | 15.82 ± 1.4% | not timed | not timed | 644.46 ± 0.1% | | 1.00 | 1.52 | 40.80 |
| imported/mariomka/email | 92 | 24229.45 ± 0.7% | not timed | not timed | 29381.48 ± 0.7% | 31.82 ± 0.4% | not timed | not timed | 24227.25 ± 1.2% | | 1.00 | 0.82 | 761.40 |
| imported/mariomka/uri | 5301 | 5327.67 ± 0.7% | not timed | not timed | 6064.89 ± 0.2% | 31.97 ± 0.6% | not timed | not timed | 5358.95 ± 0.7% | | 0.99 | 0.88 | 166.65 |
| imported/mariomka/ip | 5 | 2149.84 ± 2.1% | not timed | not timed | 2961.91 ± 0.1% | 20.53 ± 0.6% | not timed | not timed | 2150.58 ± 2.4% | | 1.00 | 0.73 | 104.71 |
| imported/rsc/no-exponential | 0 | 604.20 ± 0.1% | not timed | not timed | 320.38 ± 0.2% | 23.76 ± 0.2% | not timed | not timed | 600.59 ± 0.4% | | 1.01 | 1.89 | 25.42 |
| imported/rsc/literal | 1 | 770.15 ± 2.2% | not timed | not timed | 1658.03 ± 0.8% | 185.16 ± 16.7% | not timed | not timed | 757.64 ± 5.7% | | 1.02 | 0.46 | 4.16 |
| imported/rsc/not-literal | 2 | 780.12 ± 0.4% | not timed | not timed | 731.19 ± 0.4% | 45.82 ± 8.7% | not timed | not timed | 781.84 ± 2.2% | | 1.00 | 1.07 | 17.02 |
| imported/rsc/match-class | 1 | 1438.23 ± 9.5% | not timed | not timed | 1670.87 ± 0.1% | 58.37 ± 2.0% | not timed | not timed | 1440.01 ± 0.2% | | 1.00 | 0.86 | 24.64 |
| imported/rsc/match-class-in-range | 1 | 1440.48 ± 2.7% | not timed | not timed | 2340.95 ± 5.1% | 59.67 ± 7.0% | not timed | not timed | 1438.52 ± 0.4% | | 1.00 | 0.62 | 24.14 |
| imported/rsc/match-class-unicode | 1 | 547.03 ± 7.7% | not timed | not timed | 514.09 ± 0.1% | 72.38 ± 0.6% | not timed | not timed | 547.83 ± 0.2% | | 1.00 | 1.06 | 7.56 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1443.86 ± 0.3% | not timed | not timed | 942.34 ± 0.1% | 224.08 ± 0.6% | not timed | not timed | 1444.02 ± 0.2% | | 1.00 | 1.53 | 6.44 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21646.06 ± 0.1% | not timed | not timed | 14159.01 ± 0.1% | 3366.48 ± 1.0% | not timed | not timed | 21624.98 ± 0.2% | | 1.00 | 1.53 | 6.43 |
| imported/rsc/anchored-literal-short-match | 4 | 708.74 ± 2.7% | not timed | not timed | 484.39 ± 0.2% | 82.96 ± 13.9% | not timed | not timed | 714.70 ± 1.7% | | 0.99 | 1.46 | 8.54 |
| imported/rsc/anchored-literal-long-match | 4 | 10527.48 ± 2.3% | not timed | not timed | 7328.47 ± 0.3% | 1231.45 ± 4.3% | not timed | not timed | 10679.08 ± 2.6% | | 0.99 | 1.44 | 8.55 |
| imported/rsc/one-pass-short | 17 | 372.90 ± 1.6% | not timed | not timed | 214.19 ± 0.1% | 30.57 ± 11.3% | not timed | not timed | 371.64 ± 10.3% | | 1.00 | 1.74 | 12.20 |
| imported/rsc/one-pass-short-not | 17 | 279.74 ± 0.4% | not timed | not timed | 225.10 ± 0.1% | 28.72 ± 13.2% | not timed | not timed | 281.34 ± 2.4% | | 0.99 | 1.24 | 9.74 |
| imported/rsc/one-pass-long-prefix | 26 | 363.57 ± 6.7% | not timed | not timed | 281.91 ± 0.1% | 94.36 ± 16.2% | not timed | not timed | 364.70 ± 1.7% | | 1.00 | 1.29 | 3.85 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.16 ± 7.9% | not timed | not timed | 280.43 ± 0.1% | 68.57 ± 12.8% | not timed | not timed | 362.32 ± 8.4% | | 0.99 | 1.28 | 5.24 |
| imported/rsc/long-needle1 | 31 | 22182.64 ± 0.1% | not timed | not timed | 20170.69 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 22194.35 ± 0.1% | | 1.00 | 1.10 | 5900.90 |
| imported/rsc/long-needle2 | 31 | 22309.59 ± 0.0% | not timed | not timed | 216.02 ± 0.2% | 3.76 ± 0.1% | not timed | not timed | 22313.84 ± 0.2% | | 1.00 | 103.27 | 5937.27 |
| imported/rsc/easy0-32 | 26 | 1089.83 ± 2.3% | not timed | not timed | 1546.08 ± 0.3% | 146.43 ± 16.7% | not timed | not timed | 1090.40 ± 0.4% | | 1.00 | 0.70 | 7.44 |
| imported/rsc/easy0-1k | 26 | 14966.06 ± 0.2% | not timed | not timed | 12469.70 ± 0.4% | 2281.38 ± 16.0% | not timed | not timed | 14962.14 ± 2.2% | | 1.00 | 1.20 | 6.56 |
| imported/rsc/easy0-32k | 26 | 23033.55 ± 1.7% | not timed | not timed | 20307.54 ± 0.0% | 18739.47 ± 19.4% | not timed | not timed | 23035.98 ± 0.2% | | 1.00 | 1.13 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 21803.35 ± 1.7% | not timed | not timed | 19733.26 ± 1.7% | 36843.55 ± 5.8% | not timed | not timed | 21545.28 ± 1.3% | | 1.01 | 1.10 | 0.59 |
| imported/rsc/easy1-32 | 19 | 806.20 ± 2.0% | not timed | not timed | 626.83 ± 0.1% | 126.52 ± 19.3% | not timed | not timed | 804.72 ± 3.0% | | 1.00 | 1.29 | 6.37 |
| imported/rsc/easy1-1k | 19 | 16457.12 ± 2.8% | not timed | not timed | 12700.16 ± 0.7% | 2454.67 ± 14.7% | not timed | not timed | 16516.42 ± 0.3% | | 1.00 | 1.30 | 6.70 |
| imported/rsc/easy1-32k | 19 | 516334.95 ± 0.2% | not timed | not timed | 401785.89 ± 0.2% | 20509.16 ± 0.7% | not timed | not timed | 516739.47 ± 0.6% | | 1.00 | 1.29 | 25.18 |
| imported/rsc/easy1-1mb | 19 | 16576544.51 ± 0.5% | not timed | not timed | 12941244.50 ± 0.1% | 35681.67 ± 2.1% | not timed | not timed | 16590476.35 ± 0.2% | | 1.00 | 1.28 | 464.57 |
| imported/rsc/medium-32 | 27 | 770.33 ± 2.2% | not timed | not timed | 624.70 ± 0.2% | 69.50 ± 11.9% | not timed | not timed | 773.67 ± 0.5% | | 1.00 | 1.23 | 11.08 |
| imported/rsc/medium-1k | 27 | 13659.19 ± 0.3% | not timed | not timed | 11137.90 ± 0.1% | 72.01 ± 0.3% | not timed | not timed | 13785.13 ± 0.2% | | 0.99 | 1.23 | 189.69 |
| imported/rsc/medium-32k | 27 | 426734.26 ± 0.2% | not timed | not timed | 348273.47 ± 0.0% | 48.42 ± 0.1% | not timed | not timed | 430033.93 ± 0.8% | | 0.99 | 1.23 | 8813.91 |
| imported/rsc/medium-1mb | 27 | 13636303.26 ± 0.2% | not timed | not timed | 11118593.15 ± 0.1% | 48.56 ± 0.2% | not timed | not timed | 13750172.08 ± 0.6% | | 0.99 | 1.23 | 280786.22 |
| imported/rsc/hard-32 | 58 | 419.11 ± 2.0% | not timed | not timed | 364.00 ± 0.1% | 49.48 ± 8.7% | not timed | not timed | 417.44 ± 0.2% | | 1.00 | 1.15 | 8.47 |
| imported/rsc/hard-1k | 27 | 13347.34 ± 0.2% | not timed | not timed | 11505.85 ± 0.1% | 40.58 ± 0.2% | not timed | not timed | 13316.99 ± 0.5% | | 1.00 | 1.16 | 328.95 |
| imported/rsc/hard-32k | 27 | 416603.70 ± 0.3% | not timed | not timed | 356688.70 ± 0.1% | 29.32 ± 0.2% | not timed | not timed | 416254.23 ± 0.2% | | 1.00 | 1.17 | 14209.57 |
| imported/rsc/hard-1mb | 51 | 8356429.80 ± 0.2% | not timed | not timed | 7207374.83 ± 0.1% | 29.38 ± 0.2% | not timed | not timed | 8321138.69 ± 0.5% | | 1.00 | 1.16 | 284467.64 |
| imported/rsc/reallyhard0-32 | 58 | 267.26 ± 2.3% | not timed | not timed | 222.26 ± 0.1% | 49.28 ± 8.4% | not timed | not timed | 266.57 ± 0.2% | | 1.00 | 1.20 | 5.42 |
| imported/rsc/reallyhard0-1k | 27 | 591.04 ± 0.2% | not timed | not timed | 582.07 ± 0.1% | 40.69 ± 0.1% | not timed | not timed | 588.36 ± 0.2% | | 1.00 | 1.02 | 14.53 |
| imported/rsc/reallyhard0-32k | 27 | 610.56 ± 0.2% | not timed | not timed | 616.64 ± 0.1% | 29.37 ± 0.2% | not timed | not timed | 610.27 ± 0.1% | | 1.00 | 0.99 | 20.79 |
| imported/rsc/reallyhard0-1mb | 51 | 591.28 ± 0.6% | not timed | not timed | 615.55 ± 0.2% | 29.36 ± 0.1% | not timed | not timed | 591.17 ± 0.8% | | 1.00 | 0.96 | 20.14 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.67 ± 1.8% | not timed | not timed | 196.79 ± 1.4% | 60.88 ± 11.7% | not timed | not timed | 288.57 ± 1.9% | | 1.00 | 1.47 | 4.74 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6879.31 ± 0.1% | not timed | not timed | 5941.02 ± 0.3% | 34.37 ± 1.3% | not timed | not timed | 6874.48 ± 0.1% | | 1.00 | 1.16 | 200.17 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21477.54 ± 0.1% | not timed | not timed | 19455.80 ± 0.6% | 24.90 ± 1.3% | not timed | not timed | 21499.03 ± 0.0% | | 1.00 | 1.10 | 862.69 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21662.51 ± 1.0% | not timed | not timed | 19821.12 ± 2.4% | 24.86 ± 0.3% | not timed | not timed | 21527.12 ± 2.0% | | 1.01 | 1.09 | 871.44 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.23 ± 1.6% | not timed | not timed | 213.20 ± 0.1% | 60.77 ± 9.8% | not timed | not timed | 282.69 ± 1.3% | | 1.00 | 1.32 | 4.64 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5896.70 ± 0.1% | not timed | not timed | 6210.07 ± 1.5% | 34.41 ± 0.4% | not timed | not timed | 5890.27 ± 0.1% | | 1.00 | 0.95 | 171.35 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21397.32 ± 0.2% | not timed | not timed | 19419.30 ± 0.1% | 25.05 ± 0.5% | not timed | not timed | 21416.84 ± 0.1% | | 1.00 | 1.10 | 854.25 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21405.73 ± 1.4% | not timed | not timed | 19877.05 ± 1.1% | 24.95 ± 2.8% | not timed | not timed | 21468.66 ± 1.5% | | 1.00 | 1.08 | 857.84 |
| imported/sherlock/name-sherlock | 776 | 19539.22 ± 5.0% | not timed | not timed | 18365.19 ± 0.9% | 8519.21 ± 20.4% | not timed | not timed | 19585.91 ± 2.1% | | 1.00 | 1.06 | 2.29 |
| imported/sherlock/name-holmes | 2766 | 14645.84 ± 5.0% | not timed | not timed | 15437.80 ± 1.0% | 3223.21 ± 7.0% | not timed | not timed | 15093.26 ± 5.9% | | 0.97 | 0.95 | 4.54 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19630.44 ± 2.3% | not timed | not timed | 18290.80 ± 1.0% | 7934.51 ± 13.9% | not timed | not timed | 19607.45 ± 0.5% | | 1.00 | 1.07 | 2.47 |
| imported/sherlock/name-sherlock-casei | 816 | 15583.65 ± 0.7% | not timed | not timed | 3999.68 ± 0.1% | 32.53 ± 0.7% | not timed | not timed | 15610.77 ± 0.5% | | 1.00 | 3.90 | 479.02 |
| imported/sherlock/name-holmes-casei | 2802 | 9291.73 ± 11.0% | not timed | not timed | 3297.38 ± 0.1% | 37.59 ± 0.1% | not timed | not timed | 9342.80 ± 7.1% | | 0.99 | 2.82 | 247.20 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12984.70 ± 7.8% | not timed | not timed | 3935.16 ± 0.4% | 32.48 ± 0.4% | not timed | not timed | 13076.35 ± 1.0% | | 0.99 | 3.30 | 399.82 |
| imported/sherlock/name-whitespace | 1461 | 15243.32 ± 0.3% | not timed | not timed | 14343.52 ± 0.2% | 7262.59 ± 28.9% | not timed | not timed | 15240.10 ± 2.1% | | 1.00 | 1.06 | 2.10 |
| imported/sherlock/name-alt1 | 1142 | 11541.24 ± 2.3% | not timed | not timed | 16153.99 ± 1.4% | 4064.39 ± 36.9% | not timed | not timed | 11534.94 ± 0.7% | | 1.00 | 0.71 | 2.84 |
| imported/sherlock/name-alt2 | 3542 | 8873.40 ± 0.4% | not timed | not timed | 3818.15 ± 0.2% | 31.18 ± 0.1% | not timed | not timed | 8874.19 ± 0.5% | | 1.00 | 2.32 | 284.60 |
| imported/sherlock/name-alt3 | 4507 | 5523.31 ± 0.4% | not timed | not timed | 3622.53 ± 0.2% | 9.87 ± 0.1% | not timed | not timed | 5520.35 ± 0.2% | | 1.00 | 1.52 | 559.80 |
| imported/sherlock/name-alt3-casei | 4593 | 1518.36 ± 1.8% | not timed | not timed | 285.11 ± 0.2% | 6.48 ± 0.1% | not timed | not timed | 1523.66 ± 1.3% | | 1.00 | 5.33 | 234.37 |
| imported/sherlock/name-alt4 | 3686 | 6365.37 ± 1.6% | not timed | not timed | 3764.58 ± 0.1% | 31.33 ± 0.2% | not timed | not timed | 6362.56 ± 0.3% | | 1.00 | 1.69 | 203.16 |
| imported/sherlock/name-alt4-casei | 4254 | 2797.54 ± 2.5% | not timed | not timed | 2566.45 ± 0.2% | 19.86 ± 0.1% | not timed | not timed | 2803.48 ± 1.1% | | 1.00 | 1.09 | 140.89 |
| imported/sherlock/name-alt5 | 4028 | 6399.20 ± 0.6% | not timed | not timed | 3734.00 ± 0.2% | 21.67 ± 0.2% | not timed | not timed | 6401.34 ± 0.6% | | 1.00 | 1.71 | 295.31 |
| imported/sherlock/name-alt5-casei | 4104 | 3481.74 ± 1.8% | not timed | not timed | 2212.79 ± 0.4% | 14.34 ± 0.1% | not timed | not timed | 3492.98 ± 0.4% | | 1.00 | 1.57 | 242.85 |
| imported/sherlock/no-match-uncommon | 0 | 21414.60 ± 0.8% | not timed | not timed | 19177.38 ± 0.6% | 34457.36 ± 0.6% | not timed | not timed | 21373.61 ± 0.5% | | 1.00 | 1.12 | 0.62 |
| imported/sherlock/no-match-common | 0 | 21064.59 ± 0.4% | not timed | not timed | 19216.40 ± 1.5% | 1275.75 ± 0.6% | not timed | not timed | 21045.26 ± 0.7% | | 1.00 | 1.10 | 16.51 |
| imported/sherlock/no-match-really-common | 0 | 15825.52 ± 1.6% | not timed | not timed | 18444.10 ± 0.7% | 1270.22 ± 0.9% | not timed | not timed | 15843.23 ± 3.7% | | 1.00 | 0.86 | 12.46 |
| imported/sherlock/the-lower | 21654 | 2306.43 ± 1.5% | not timed | not timed | 2323.57 ± 0.3% | 240.74 ± 21.7% | not timed | not timed | 2317.75 ± 1.1% | | 1.00 | 0.99 | 9.58 |
| imported/sherlock/the-upper | 2223 | 12602.07 ± 1.3% | not timed | not timed | 13412.82 ± 0.6% | 2619.87 ± 17.6% | not timed | not timed | 12681.43 ± 1.1% | | 0.99 | 0.94 | 4.81 |
| imported/sherlock/the-casei | 23961 | 2007.54 ± 0.5% | not timed | not timed | 1317.79 ± 0.5% | 34.66 ± 30.0% | not timed | not timed | 2005.30 ± 1.0% | | 1.00 | 1.52 | 57.92 |
| imported/sherlock/everything-greedy | 581881 | 282.36 ± 1.0% | not timed | not timed | 164.30 ± 0.1% | 28.68 ± 29.7% | not timed | not timed | 283.46 ± 0.3% | | 1.00 | 1.72 | 9.84 |
| imported/sherlock/everything-greedy-nl | 594933 | 461.57 ± 0.1% | not timed | not timed | 213.63 ± 0.5% | 32.93 ± 0.2% | not timed | not timed | 461.27 ± 0.1% | | 1.00 | 2.16 | 14.02 |
| imported/sherlock/letters | 447175 | 62.27 ± 10.8% | not timed | not timed | 33.01 ± 0.2% | 5.18 ± 20.0% | not timed | not timed | 62.39 ± 8.7% | | 1.00 | 1.89 | 12.01 |
| imported/sherlock/letters-upper | 14180 | 452.62 ± 0.3% | not timed | not timed | 367.28 ± 0.1% | 29.63 ± 0.7% | not timed | not timed | 452.48 ± 0.3% | | 1.00 | 1.23 | 15.27 |
| imported/sherlock/letters-lower | 432995 | 63.49 ± 1.2% | not timed | not timed | 33.48 ± 0.3% | 5.34 ± 31.9% | not timed | not timed | 63.60 ± 0.8% | | 1.00 | 1.90 | 11.89 |
| imported/sherlock/words | 447639 | 115.48 ± 1.0% | not timed | not timed | 82.50 ± 0.2% | 13.92 ± 23.2% | not timed | not timed | 115.61 ± 1.7% | | 1.00 | 1.40 | 8.30 |
| imported/sherlock/before-holmes | 4073 | 10247.18 ± 0.9% | not timed | not timed | 8398.20 ± 0.3% | 24.11 ± 0.3% | not timed | not timed | 10279.49 ± 0.6% | | 1.00 | 1.22 | 425.03 |
| imported/sherlock/before-after-holmes | 2593 | 9840.40 ± 0.8% | not timed | not timed | 9457.32 ± 0.6% | 24.14 ± 0.7% | not timed | not timed | 9813.48 ± 0.7% | | 1.00 | 1.04 | 407.57 |
| imported/sherlock/holmes-cochar-watson | 150 | 5165.85 ± 0.3% | not timed | not timed | 3413.79 ± 0.3% | 30.91 ± 0.3% | not timed | not timed | 5176.35 ± 0.3% | | 1.00 | 1.51 | 167.15 |
| imported/sherlock/holmes-coword-watson | 14309 | 1183.66 ± 0.6% | not timed | not timed | 1121.20 ± 0.2% | 6.74 ± 0.3% | not timed | not timed | 1181.69 ± 0.3% | | 1.00 | 1.06 | 175.50 |
| imported/sherlock/quotes | 14437 | 1389.94 ± 0.5% | not timed | not timed | 1762.51 ± 1.1% | 35.04 ± 0.2% | not timed | not timed | 1386.78 ± 0.3% | | 1.00 | 0.79 | 39.67 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 608.54 ± 0.1% | not timed | not timed | 15882.93 ± 0.6% | 36.72 ± 0.1% | not timed | not timed | 608.55 ± 0.1% | | 1.00 | 0.0383 | 16.57 |
| imported/sherlock/word-ending-n | 35297 | 478.71 ± 1.3% | not timed | not timed | 407.78 ± 0.2% | 23.41 ± 22.8% | not timed | not timed | 480.46 ± 0.3% | | 1.00 | 1.17 | 20.45 |
| imported/sherlock/repeated-class-negation | 2130 | 14630.58 ± 1.1% | not timed | not timed | 10900.51 ± 0.5% | 11.55 ± 0.3% | not timed | not timed | 14628.76 ± 1.0% | | 1.00 | 1.34 | 1266.79 |
| imported/sherlock/ing-suffix | 20547 | 564.65 ± 0.3% | not timed | not timed | 515.62 ± 0.3% | 28.85 ± 0.1% | not timed | not timed | 566.04 ± 0.3% | | 1.00 | 1.10 | 19.57 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 606.20 ± 0.3% | not timed | not timed | 2096.96 ± 0.4% | 20.48 ± 0.1% | not timed | not timed | 606.92 ± 0.2% | | 1.00 | 0.29 | 29.60 |
| opt/accelerate/whole-line | 239963 | 457.48 ± 0.4% | not timed | not timed | 375.31 ± 0.2% | 92.41 ± 14.6% | not timed | not timed | 457.26 ± 1.2% | | 1.00 | 1.22 | 4.95 |
| opt/accelerate/non-dna | 16745 | 425.72 ± 0.2% | not timed | not timed | 399.16 ± 0.1% | 29.32 ± 20.9% | not timed | not timed | 427.76 ± 1.0% | | 1.00 | 1.07 | 14.52 |
| opt/backtrack/words-english | 40536 | 136.39 ± 7.7% | not timed | not timed | 94.55 ± 0.1% | 19.44 ± 7.3% | not timed | not timed | 136.26 ± 0.6% | | 1.00 | 1.44 | 7.02 |
| opt/fixed-length/too-small-ascii | 0 | 309.56 ± 0.1% | not timed | not timed | 685.43 ± 2.7% | 77.95 ± 0.4% | not timed | not timed | 315.62 ± 0.3% | | 0.98 | 0.45 | 3.97 |
| opt/fixed-length/too-big-ascii | 0 | 3442.71 ± 0.2% | not timed | not timed | 5767.68 ± 0.3% | 125.31 ± 0.1% | not timed | not timed | 3436.95 ± 0.2% | | 1.00 | 0.60 | 27.47 |
| opt/fixed-length/go33484-1 | 0 | 662643.16 ± 0.1% | not timed | not timed | 1106654.34 ± 0.3% | 60487.77 ± 0.4% | not timed | not timed | 660254.98 ± 0.1% | | 1.00 | 0.60 | 10.95 |
| opt/fixed-length/go33484-2 | 0 | 662439.30 ± 0.1% | not timed | not timed | 1096154.87 ± 0.2% | 31931.11 ± 1.0% | not timed | not timed | 660261.47 ± 0.3% | | 1.00 | 0.60 | 20.75 |
| opt/fixed-length/go33484-3 | 0 | 2428.92 ± 1.6% | not timed | not timed | 110378.89 ± 0.2% | 759.82 ± 0.2% | not timed | not timed | 2411.91 ± 4.4% | | 1.01 | 0.0220 | 3.20 |
| opt/literal-alt/one-pattern | 1 | 549.47 ± 1.1% | not timed | not timed | 543.10 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 550.40 ± 1.4% | | 1.00 | 1.01 | 1374.61 |
| opt/onepass/fn-predicate | 916 | 365.00 ± 0.8% | not timed | not timed | 333.97 ± 0.2% | 199.82 ± 13.2% | not timed | not timed | 367.76 ± 0.1% | | 0.99 | 1.09 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 173.97 ± 10.7% | not timed | not timed | 199.77 ± 0.1% | 81.46 ± 12.2% | not timed | not timed | 176.36 ± 2.0% | | 0.99 | 0.87 | 2.14 |
| opt/prefilter/literal-english | 1 | 20979.22 ± 0.4% | not timed | not timed | 20220.83 ± 0.3% | 17408.68 ± 0.4% | not timed | not timed | 20952.18 ± 0.4% | | 1.00 | 1.04 | 1.21 |
| opt/prefilter/literal-casei-english | 1 | 14588.39 ± 0.7% | not timed | not timed | 4294.31 ± 0.2% | 32.61 ± 0.2% | not timed | not timed | 14589.43 ± 0.3% | | 1.00 | 3.40 | 447.40 |
| opt/prefilter/literal-russian | 1 | 20833.47 ± 0.7% | not timed | not timed | 19665.05 ± 0.7% | 3310.76 ± 0.3% | not timed | not timed | 20830.35 ± 0.7% | | 1.00 | 1.06 | 6.29 |
| opt/prefilter/literal-casei-russian | 1 | 8540.64 ± 0.5% | not timed | not timed | 3877.41 ± 0.2% | 31.73 ± 0.4% | not timed | not timed | 8530.90 ± 0.8% | | 1.00 | 2.20 | 269.16 |
| opt/prefilter/rust-functions | 948 | 6796.83 ± 0.2% | not timed | not timed | 8936.34 ± 0.3% | 1863.95 ± 0.3% | not timed | not timed | 6799.83 ± 0.3% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29965739.20 ± 0.1% | not timed | not timed | 21203334.95 ± 0.3% | 50.01 ± 0.1% | not timed | not timed | 29968215.96 ± 0.1% | | 1.00 | 1.41 | 599197.44 |
| opt/reverse-inner/holmes | 2593 | 9832.94 ± 0.9% | not timed | not timed | 9436.93 ± 0.4% | 23.87 ± 1.7% | not timed | not timed | 9817.05 ± 0.6% | | 1.00 | 1.04 | 411.93 |
| opt/reverse-inner/email | 47 | 36231.29 ± 1.5% | not timed | not timed | 44835.05 ± 0.8% | 32.37 ± 0.2% | not timed | not timed | 36812.98 ± 1.7% | | 0.98 | 0.81 | 1119.26 |
| opt/reverse-inner/factored-prefix | 3542 | 599.43 ± 0.1% | not timed | not timed | 593.90 ± 0.1% | 12.50 ± 1.0% | not timed | not timed | 598.76 ± 0.2% | | 1.00 | 1.01 | 47.94 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5551.24 ± 0.1% | not timed | not timed | 616.69 ± 0.3% | 75.06 ± 0.2% | not timed | not timed | 5528.32 ± 0.1% | | 1.00 | 9.00 | 73.96 |
| opt/reverse-inner/no-quadratic-forward | 0 | 686.31 ± 1.6% | not timed | not timed | 288.74 ± 0.3% | 24.78 ± 0.1% | not timed | not timed | 687.26 ± 1.9% | | 1.00 | 2.38 | 27.70 |
| opt/reverse-suffix/holmes | 4073 | 10240.42 ± 0.7% | not timed | not timed | 8410.24 ± 0.2% | 24.01 ± 1.2% | not timed | not timed | 10257.65 ± 0.4% | | 1.00 | 1.22 | 426.46 |
| opt/reverse-suffix/no-quadratic | 0 | 5528.61 ± 0.1% | not timed | not timed | 615.85 ± 0.1% | 75.02 ± 0.2% | not timed | not timed | 5557.34 ± 0.0% | | 0.99 | 8.98 | 73.70 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.85 ± 9.6% | not timed | not timed | 132.65 ± 0.3% | 13.47 ± 15.0% | not timed | not timed | 121.45 ± 2.8% | | 1.00 | 0.92 | 9.05 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.51 ± 2.5% | not timed | not timed | 130.57 ± 0.2% | 12.79 ± 14.4% | not timed | not timed | 121.46 ± 0.9% | | 0.99 | 0.92 | 9.42 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.27 ± 0.2% | not timed | not timed | 0.55 ± 0.5% | 112.73 ± 0.2% | not timed | not timed | 0.28 ± 0.3% | | 0.99 | 0.50 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.18 ± 0.3% | not timed | not timed | 293.99 ± 0.1% | 103.99 ± 8.0% | not timed | not timed | 316.22 ± 3.3% | | 1.00 | 1.08 | 3.05 |
| reported/i13-subset-regex/original-ascii | 4094 | 11133.33 ± 0.9% | not timed | not timed | 4488.15 ± 0.5% | 11.46 ± 0.1% | not timed | not timed | 11197.88 ± 1.0% | | 0.99 | 2.48 | 971.63 |
| reported/i13-subset-regex/original-unicode | 4094 | 11010.31 ± 1.2% | not timed | not timed | 251.06 ± 5.3% | 11.48 ± 0.1% | not timed | not timed | 11123.61 ± 1.1% | | 0.99 | 43.85 | 959.42 |
| reported/i13-subset-regex/big-ascii | 1955 | 10649.88 ± 1.2% | not timed | not timed | 68.09 ± 3.7% | 9.83 ± 0.1% | not timed | not timed | 10701.25 ± 1.1% | | 1.00 | 156.40 | 1083.79 |
| reported/i13-subset-regex/big-unicode | 1955 | 10554.22 ± 1.2% | not timed | not timed | 12.20 ± 54.9% | 9.84 ± 0.3% | not timed | not timed | 10688.74 ± 1.4% | | 0.99 | 864.91 | 1073.01 |
| reported/i13-subset-regex/huge-ascii | 55 | 9922.98 ± 2.8% | not timed | not timed | 11.02 ± 0.0% | 8.73 ± 0.1% | not timed | not timed | 9880.62 ± 2.9% | | 1.00 | 900.75 | 1137.12 |
| reported/i13-subset-regex/huge-unicode | 55 | 9867.32 ± 3.0% | not timed | not timed | 10.94 ± 0.3% | 8.74 ± 0.1% | not timed | not timed | 9810.36 ± 3.3% | | 1.01 | 901.56 | 1129.55 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.55 ± 0.0% | not timed | not timed | 11.06 ± 0.1% | 8.75 ± 0.1% | not timed | not timed | 3.55 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 10.95 ± 0.3% | 8.75 ± 1.1% | not timed | not timed | 5.02 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 486.84 ± 0.3% | not timed | not timed | 104.19 ± 0.2% | 6.63 ± 0.2% | not timed | not timed | 487.22 ± 0.5% | | 1.00 | 4.67 | 73.42 |
| reported/i787-keywords/opt-ascii | 5674 | 487.89 ± 0.3% | not timed | not timed | 270.31 ± 0.2% | 10.25 ± 0.1% | not timed | not timed | 488.85 ± 0.3% | | 1.00 | 1.80 | 47.60 |
| slow/quadratic-regex-1x | 100 | 7.11 ± 0.2% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 2.3% | not timed | not timed | 7.14 ± 0.3% | | 1.00 | 1.43 | 143.96 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.2% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.1% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 268.38 |
| slow/quadratic-haystack-1x | 100 | 21.37 ± 6.7% | not timed | not timed | 10.03 ± 0.2% | 1.01 ± 12.9% | not timed | not timed | 21.37 ± 1.8% | | 1.00 | 2.13 | 21.09 |
| slow/quadratic-haystack-2x | 200 | 17.70 ± 3.7% | not timed | not timed | 5.54 ± 0.1% | 0.55 ± 12.0% | not timed | not timed | 17.79 ± 1.2% | | 0.99 | 3.20 | 32.45 |
| unicode/codepoints/any-one | 1112064 | 290.64 ± 0.3% | not timed | not timed | 175.61 ± 0.1% | 18.29 ± 2.8% | not timed | not timed | 289.82 ± 0.4% | | 1.00 | 1.66 | 15.89 |
| unicode/codepoints/any-all | 4382592 | 268.99 ± 0.5% | not timed | not timed | 247.01 ± 0.1% | 117.24 ± 0.2% | not timed | not timed | 269.49 ± 0.1% | | 1.00 | 1.09 | 2.29 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.84 ± 0.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.35 ± 0.8% | not timed | not timed | 616.02 ± 0.1% | 135.24 ± 0.2% | not timed | not timed | 601.19 ± 0.5% | | 1.01 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 31.96 ± 0.2% | not timed | not timed | 38.80 ± 0.4% | 3.94 ± 0.6% | not timed | not timed | 31.97 ± 0.3% | | 1.00 | 0.82 | 8.11 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.1% | not timed | not timed | 3.26 ± 0.6% | 2.34 ± 0.4% | not timed | not timed | 1.45 ± 0.2% | | 1.00 | 0.44 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.5% | not timed | not timed | 3.58 ± 0.3% | 6.20 ± 10.0% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.36 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 126.92 ± 3.2% | not timed | not timed | 82.51 ± 0.7% | 11.47 ± 15.4% | not timed | not timed | 128.30 ± 0.5% | | 0.99 | 1.54 | 11.07 |
| unicode/word/boundary-long-english | 3466 | 613.74 ± 0.3% | not timed | not timed | 602.47 ± 0.2% | 32.31 ± 1.5% | not timed | not timed | 614.53 ± 0.2% | | 1.00 | 1.02 | 18.99 |
| unicode/word/around-holmes-english | 27 | 20164.28 ± 0.4% | not timed | not timed | 19842.09 ± 0.3% | 22.16 ± 3.3% | not timed | not timed | 19986.72 ± 0.4% | | 1.01 | 1.02 | 909.89 |
| wild/bibleref/long | 874 | 561.75 ± 0.1% | not timed | not timed | 582.89 ± 0.1% | 6.71 ± 0.1% | not timed | not timed | 561.31 ± 0.2% | | 1.00 | 0.96 | 83.78 |
| wild/bibleref/short | 30 | 24.37 ± 2.1% | not timed | not timed | 31.49 ± 0.3% | 14.26 ± 11.0% | not timed | not timed | 24.62 ± 4.2% | | 0.99 | 0.77 | 1.71 |
| wild/bibleref/line | 874 | 395.71 ± 0.2% | not timed | not timed | 218.67 ± 0.1% | 9.07 ± 8.4% | not timed | not timed | 394.57 ± 1.5% | | 1.00 | 1.81 | 43.64 |
| wild/caddy/caddy | 6 | 416.15 ± 4.7% | not timed | not timed | 243.75 ± 0.2% | 67.42 ± 10.5% | not timed | not timed | 416.66 ± 0.2% | | 1.00 | 1.71 | 6.17 |
| wild/dot-star-capture/rust-src-tools | 6 | 1066.48 ± 0.3% | not timed | not timed | 348.21 ± 0.3% | 13.46 ± 0.5% | not timed | not timed | 1065.49 ± 0.5% | | 1.00 | 3.06 | 79.23 |
| wild/ruff/noqa | 84 | 438.68 ± 0.3% | not timed | not timed | 469.26 ± 0.1% | 19.60 ± 2.3% | not timed | not timed | 436.90 ± 0.2% | | 1.00 | 0.93 | 22.38 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.27 ± 0.9% | not timed | not timed | 702.86 ± 0.4% | 133.41 ± 11.7% | not timed | not timed | 959.35 ± 1.3% | | 1.00 | 1.36 | 7.18 |
| wild/ruff/string-quote-prefix | 2972 | 1355.02 ± 0.9% | not timed | not timed | 442.66 ± 0.3% | 313.47 ± 25.7% | not timed | not timed | 1352.24 ± 0.6% | | 1.00 | 3.06 | 4.32 |
| wild/ruff/space-around-operator | 1224378 | 220.57 ± 2.0% | not timed | not timed | 186.33 ± 0.1% | 18.22 ± 1.7% | not timed | not timed | 221.28 ± 1.3% | | 1.00 | 1.18 | 12.10 |
| wild/ruff/shebang | 282 | 983.32 ± 0.5% | not timed | not timed | 329.75 ± 0.2% | 120.48 ± 9.9% | not timed | not timed | 982.65 ± 0.5% | | 1.00 | 2.98 | 8.16 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13776.04 ± 0.1% | not timed | not timed | 13788.20 ± 0.7% | 6914.38 ± 0.4% | not timed | not timed | 13815.63 ± 0.5% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12809.75 ± 0.4% | not timed | not timed | 13422.11 ± 0.7% | 6392.81 ± 0.6% | not timed | not timed | 12803.34 ± 0.5% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13140.82 ± 0.7% | not timed | not timed | 13594.03 ± 1.0% | 6634.15 ± 36.0% | not timed | not timed | 13144.50 ± 4.2% | | 1.00 | 0.97 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9535.49 ± 0.6% | not timed | not timed | 13578.08 ± 0.5% | 6758.08 ± 0.5% | not timed | not timed | 9540.95 ± 0.2% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 122.16 ± 14.7% | not timed | not timed | 65.64 ± 0.5% | 2.23 ± 0.6% | not timed | not timed | 122.53 ± 14.7% | | 1.00 | 1.86 | 54.78 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 36.3% | not timed | not timed | 0.01 ± 2.2% | 0.01 ± 19.8% | not timed | not timed | 0.03 ± 3.0% | | 0.99 | 3.04 | 3.67 |
| dictionary/compile/english-15 | 1 | 0.34 ± 26.5% | not timed | not timed | 0.07 ± 0.4% | 0.11 ± 24.4% | not timed | not timed | 0.35 ± 1.2% | | 0.99 | 4.94 | 3.26 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 1.5% | not timed | not timed | 0.02 ± 1.4% | 35.81 ± 2.4% | not timed | not timed | 0.24 ± 2.3% | | 1.00 | 12.56 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.63 ± 2.0% | not timed | not timed | 11.46 ± 0.3% | 53.02 ± 19.8% | not timed | not timed | 46.25 ± 2.2% | | 0.99 | 3.98 | 0.86 |
| reported/i787-keywords/compile | 1 | 35.04 ± 4.2% | not timed | not timed | 2.11 ± 0.9% | 17.64 ± 38.5% | not timed | not timed | 35.09 ± 4.8% | | 1.00 | 16.58 | 1.99 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 347.69 ± 8.0% | not timed | not timed | 123.77 ± 0.2% | 585.71 ± 31.0% | not timed | not timed | 343.22 ± 5.6% | | 1.01 | 2.81 | 0.59 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.58 ± 2.7% | not timed | not timed | 4.08 ± 0.8% | 43.47 ± 8.9% | not timed | not timed | 48.36 ± 2.2% | | 0.98 | 11.66 | 1.09 |
| unicode/compile/one-letter | 53 | 6.71 ± 12.4% | not timed | not timed | 4.52 ± 0.9% | 66.76 ± 2.6% | not timed | not timed | 6.75 ± 14.3% | | 0.99 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.00 ± 16.9% | not timed | not timed | 0.10 ± 0.5% | 67.38 ± 9.9% | not timed | not timed | 1.04 ± 16.6% | | 0.96 | 10.07 | 0.0148 |
| unicode/compile/fifty-letters-ascii | 1 | 208.21 ± 6.4% | not timed | not timed | 52.78 ± 0.2% | 192.75 ± 14.2% | not timed | not timed | 211.54 ± 2.5% | | 0.98 | 3.95 | 1.08 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 386.57 ± 8.8% | not timed | not timed | 46.03 ± 0.4% | 677.45 ± 21.8% | not timed | not timed | 379.62 ± 2.6% | | 1.02 | 8.40 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 595.43 ± 13.4% | not timed | not timed | 146.08 ± 0.1% | 670.95 ± 25.1% | not timed | not timed | 598.65 ± 3.4% | | 0.99 | 4.08 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 314.89 ± 3.5% | not timed | not timed | 50.37 ± 0.4% | 1256.38 ± 15.6% | not timed | not timed | 314.51 ± 3.1% | | 1.00 | 6.25 | 0.25 |
| wild/bibleref/compile | 3 | 5.95 ± 2.5% | not timed | not timed | 1.93 ± 1.2% | 31.81 ± 7.8% | not timed | not timed | 5.95 ± 2.6% | | 1.00 | 3.09 | 0.19 |
| wild/url/compile | 1 | 0.57 ± 14.9% | not timed | not timed | 0.14 ± 0.9% | 0.46 ± 18.4% | not timed | not timed | 0.64 ± 15.6% | | 0.88 | 3.92 | 1.22 |

