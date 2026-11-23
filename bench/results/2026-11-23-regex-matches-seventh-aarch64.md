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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127345398 |
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
| literal: a word | 217 | 16037.53 ± 2.2% | 1038.95 ± 0.2% | 28.66 ± 0.4% | 18119.89 ± 2.7% | 9183.85 ± 6.7% | 17.36 ± 0.4% | 86.13 ± 0.2% | 16074.51 ± 2.2% | 15.44 | 1.00 | 0.89 | 1.75 |
| literal: a word that is not there | 0 | 18663.71 ± 2.6% | 1047.06 ± 0.3% | 28.73 ± 0.9% | 19410.00 ± 4.0% | 28619.28 ± 2.4% | 17.19 ± 0.0% | 82.17 ± 0.2% | 18770.62 ± 1.6% | 17.82 | 0.99 | 0.96 | 0.65 |
| literal: one of four words | 661 | 6055.09 ± 0.4% | 1019.62 ± 0.1% | 14.73 ± 0.2% | 3937.15 ± 0.4% | 21.86 ± 0.0% | 5.26 ± 0.1% | 6.73 ± 0.2% | 6040.12 ± 0.6% | 5.94 | 1.00 | 1.54 | 277.04 |
| literal: a word in any case | 217 | 12551.89 ± 0.6% | 1038.69 ± 0.1% | 21.58 ± 2.1% | 3962.73 ± 0.1% | 38.05 ± 0.2% | refused | differs | 12539.34 ± 0.3% | 12.08 | 1.00 | 3.17 | 329.87 |
| literal: an href attribute | 33 | 13665.18 ± 1.0% | 1046.28 ± 0.1% | 27.50 ± 0.2% | 17026.41 ± 1.2% | 2257.36 ± 0.4% | 12.93 ± 1.3% | 75.60 ± 0.2% | 13596.21 ± 0.9% | 13.06 | 1.01 | 0.80 | 6.05 |
| literal: a word, second text | 123 | 16238.06 ± 1.8% | 1043.00 ± 0.2% | 28.31 ± 0.1% | 18158.90 ± 1.5% | 7740.96 ± 5.5% | 19.28 ± 0.6% | 69.75 ± 0.9% | 16424.96 ± 2.5% | 15.57 | 0.99 | 0.89 | 2.10 |
| class: two capitalized words | 1331 | 1125.99 ± 0.3% | 976.83 ± 0.2% | 26.16 ± 0.2% | 581.88 ± 0.1% | 40.54 ± 0.1% | 14.92 ± 0.4% | 68.48 ± 0.7% | 1125.96 ± 0.2% | 1.15 | 1.00 | 1.94 | 27.78 |
| class: a word that ends in ing | 3399 | 890.61 ± 0.0% | 890.25 ± 0.1% | 18.26 ± 0.2% | 545.81 ± 0.1% | 29.61 ± 12.8% | 8.14 ± 0.1% | 18.20 ± 0.4% | 889.20 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.08 |
| class: a word in capitals | 2332 | 1450.65 ± 0.3% | 950.20 ± 0.1% | 27.84 ± 0.3% | 572.57 ± 0.1% | 43.47 ± 3.5% | 17.17 ± 0.3% | 82.96 ± 0.8% | 1452.24 ± 0.3% | 1.53 | 1.00 | 2.53 | 33.37 |
| class: a number | 8288 | 1997.61 ± 0.1% | 828.23 ± 0.1% | 28.03 ± 0.1% | 1724.47 ± 0.1% | 38.61 ± 16.3% | 0.57 ± 0.1% | 56.67 ± 0.1% | 1990.70 ± 0.1% | 2.41 | 1.00 | 1.16 | 51.73 |
| class: two capitalized words, second text | 5359 | 737.24 ± 0.2% | 736.70 ± 0.1% | 23.45 ± 0.1% | 486.00 ± 0.1% | 35.32 ± 6.8% | 16.93 ± 0.3% | 63.60 ± 1.4% | 736.87 ± 0.1% | 1.00 | 1.00 | 1.52 | 20.87 |
| other: a word between two words | 6104 | 759.34 ± 0.2% | 763.46 ± 0.4% | 23.66 ± 0.1% | 738.46 ± 0.2% | 108.26 ± 15.1% | 11.35 ± 0.1% | 69.36 ± 0.3% | 756.44 ± 0.2% | 0.99 | 1.00 | 1.03 | 7.01 |
| other: a number before a unit, second text | 1481 | 5544.83 ± 0.8% | 982.97 ± 0.1% | 26.02 ± 0.1% | 5621.08 ± 0.1% | 40.80 ± 0.1% | 17.89 ± 0.2% | 66.74 ± 0.3% | 5523.75 ± 0.5% | 5.64 | 1.00 | 0.99 | 135.92 |
| other: a heading's start tag | 110 | 12489.94 ± 1.7% | 1036.41 ± 0.1% | 27.62 ± 0.1% | 1716.15 ± 0.2% | 1581.93 ± 6.4% | 16.21 ± 0.3% | 87.46 ± 2.4% | 12526.85 ± 2.0% | 12.05 | 1.00 | 7.28 | 7.90 |
| other: a whole word | 217 | 13851.20 ± 1.7% | 1037.73 ± 0.1% | 29.87 ± 0.3% | 14449.57 ± 0.7% | 49.40 ± 0.1% | 13.45 ± 0.2% | 55.44 ± 1.2% | 13833.81 ± 2.1% | 13.35 | 1.00 | 0.96 | 280.41 |
| other: a line's first word, second text | 3716 | 1960.54 ± 0.2% | 873.64 ± 0.2% | 31.30 ± 0.2% | 1737.66 ± 0.3% | 62.02 ± 5.0% | refused | refused | 1950.80 ± 0.4% | 2.24 | 1.00 | 1.13 | 31.61 |
| other: fourteen octets before an x | 87 | 19652.65 ± 2.8% | 228.91 ± 0.5% | 6.14 ± 0.2% | 3943.77 ± 0.4% | 10.64 ± 0.3% | differs | 17.68 ± 0.4% | 19668.19 ± 1.9% | 85.85 | 1.00 | 4.98 | 1846.83 |
| other: a Greek word | 21815 | 470.02 ± 0.8% | 358.05 ± 0.2% | 31.12 ± 0.1% | 288.28 ± 0.3% | 43.34 ± 10.3% | differs | refused | 466.69 ± 0.5% | 1.31 | 1.01 | 1.63 | 10.84 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.2% | 25.89 ± 0.3% | 0.82 ± 0.2% | 19.46 ± 0.3% | 2.77 ± 0.4% | differs | 4.01 ± 0.2% | 25.86 ± 0.2% | 1.00 | 1.00 | 1.33 | 9.32 |
| a UUID | 32895 | 21.08 ± 0.3% | 21.13 ± 0.2% | 0.65 ± 0.1% | 15.13 ± 0.4% | 3.09 ± 0.9% | 0.71 ± 0.4% | 3.61 ± 0.7% | 21.16 ± 0.5% | 1.00 | 1.00 | 1.39 | 6.82 |
| an IPv4 address | 33176 | 36.95 ± 0.4% | 36.88 ± 0.4% | 2.09 ± 0.3% | 28.81 ± 0.3% | 6.63 ± 0.1% | differs | 4.15 ± 0.2% | 36.66 ± 0.2% | 1.00 | 1.01 | 1.28 | 5.58 |
| a date and time | 32954 | 30.90 ± 0.5% | 31.06 ± 0.5% | 1.42 ± 0.2% | 21.30 ± 0.4% | 7.03 ± 0.1% | 1.19 ± 0.2% | 7.06 ± 0.3% | 31.00 ± 0.4% | 0.99 | 1.00 | 1.45 | 4.39 |
| a field path | 32606 | 29.48 ± 0.1% | 29.42 ± 0.1% | 1.01 ± 0.6% | 23.02 ± 0.2% | 3.49 ± 0.9% | differs | 2.92 ± 0.2% | 29.48 ± 0.3% | 1.00 | 1.00 | 1.28 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.44 ± 0.1% | 11.47 ± 0.4% | 11.50 ± 0.4% | 11.29 ± 0.1% | 4.92 ± 0.8% | 0.90 ± 0.3% | none | 11.53 ± 0.2% | 1.00 | 0.99 | 1.01 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.73 ± 1.0% | 222.40 ± 0.3% | 259.25 ± 0.3% | 87.51 ± 0.1% | 215.13 ± 2.2% | 481.93 ± 1.0% | 3753.56 ± 2.5% | 221.65 ± 0.2% | 1.00 | 1.00 | 2.53 | 1.03 |
| a UUID | 62 | 145.88 ± 0.2% | 146.09 ± 0.3% | 161.24 ± 0.2% | 46.68 ± 0.4% | 97.16 ± 1.7% | 186.39 ± 2.6% | 4472.40 ± 1.0% | 145.85 ± 0.1% | 1.00 | 1.00 | 3.13 | 1.50 |
| an IPv4 address | 29 | 439.42 ± 0.5% | 443.23 ± 0.5% | 612.80 ± 0.4% | 77.36 ± 0.6% | 127.73 ± 6.2% | 295.53 ± 1.3% | 7718.02 ± 0.7% | 439.14 ± 0.4% | 0.99 | 1.00 | 5.68 | 3.44 |
| a date and time | 56 | 319.11 ± 0.3% | 320.51 ± 0.4% | 400.91 ± 0.3% | 73.40 ± 0.6% | 133.52 ± 2.1% | 318.98 ± 0.8% | 4977.81 ± 0.6% | 319.03 ± 0.3% | 1.00 | 1.00 | 4.35 | 2.39 |
| a field path | 39 | 209.09 ± 0.2% | 209.73 ± 0.2% | 241.68 ± 0.3% | 81.04 ± 0.5% | 201.78 ± 26.3% | 502.85 ± 2.1% | 4858.60 ± 0.1% | 208.81 ± 0.5% | 1.00 | 1.00 | 2.58 | 1.04 |
| literal: a word | 7 | 667.05 ± 0.6% | 715.51 ± 0.2% | 1278.14 ± 0.6% | 523.96 ± 0.2% | 616.13 ± 1.5% | 941.31 ± 0.6% | 30436.44 ± 0.4% | 667.00 ± 0.7% | 0.93 | 1.00 | 1.27 | 1.08 |
| literal: a word that is not there | 8 | 638.75 ± 0.3% | 692.26 ± 0.7% | 1202.79 ± 0.1% | 471.86 ± 0.2% | 590.16 ± 1.2% | 893.38 ± 0.7% | 29556.05 ± 0.2% | 638.38 ± 0.2% | 0.92 | 1.00 | 1.35 | 1.08 |
| literal: one of four words | 26 | 255.76 ± 0.2% | 419.76 ± 0.3% | 565.97 ± 0.4% | 49.47 ± 0.5% | 238.48 ± 2.2% | 360.29 ± 2.1% | 15797.52 ± 0.4% | 255.93 ± 0.4% | 0.61 | 1.00 | 5.17 | 1.07 |
| literal: a word in any case | 11 | 523.46 ± 0.2% | 565.60 ± 0.4% | 867.75 ± 0.2% | 15.78 ± 0.3% | 636.19 ± 2.5% | refused | 23846.79 ± 0.6% | 523.17 ± 0.1% | 0.93 | 1.00 | 33.16 | 0.82 |
| literal: an href attribute | 12 | 351.81 ± 0.4% | 363.56 ± 0.4% | 472.02 ± 0.4% | 45.57 ± 1.3% | 491.64 ± 3.4% | 779.11 ± 0.5% | 22422.09 ± 0.1% | 351.56 ± 0.2% | 0.97 | 1.00 | 7.72 | 0.72 |
| literal: a word, second text | 10 | 593.94 ± 0.1% | 654.56 ± 0.4% | 1091.45 ± 0.0% | 428.50 ± 0.7% | 523.82 ± 1.6% | 805.21 ± 0.6% | 27455.40 ± 0.9% | 593.28 ± 0.2% | 0.91 | 1.00 | 1.39 | 1.13 |
| class: two capitalized words | 23 | 461.96 ± 0.8% | 492.01 ± 0.5% | 709.84 ± 0.4% | 101.25 ± 0.1% | 493.27 ± 1.0% | 745.65 ± 0.7% | 6392.44 ± 0.1% | 461.18 ± 0.4% | 0.94 | 1.00 | 4.56 | 0.94 |
| class: a word that ends in ing | 9 | 599.78 ± 0.6% | 666.16 ± 0.2% | 1170.07 ± 0.1% | 132.00 ± 1.2% | 746.94 ± 0.8% | 1110.27 ± 1.9% | 15987.86 ± 0.1% | 599.25 ± 0.3% | 0.90 | 1.00 | 4.54 | 0.80 |
| class: a word in capitals | 16 | 525.99 ± 0.3% | 566.44 ± 0.4% | 903.53 ± 0.1% | 136.32 ± 0.5% | 738.72 ± 1.6% | 1010.79 ± 0.5% | 8402.88 ± 0.4% | 526.53 ± 0.1% | 0.93 | 1.00 | 3.86 | 0.71 |
| class: a number | 6 | 667.70 ± 0.5% | 729.46 ± 0.6% | 1361.52 ± 0.1% | 41.92 ± 0.5% | 1371.83 ± 10.9% | 1894.02 ± 1.8% | 23176.42 ± 0.1% | 667.62 ± 0.3% | 0.92 | 1.00 | 15.93 | 0.49 |
| class: two capitalized words, second text | 23 | 462.32 ± 0.4% | 491.91 ± 0.2% | 708.77 ± 0.2% | 104.00 ± 0.5% | 494.01 ± 1.8% | 734.61 ± 0.3% | 6392.01 ± 0.1% | 461.81 ± 0.3% | 0.94 | 1.00 | 4.45 | 0.94 |
| other: a word between two words | 13 | 581.19 ± 0.2% | 601.26 ± 0.3% | 956.61 ± 0.3% | 135.09 ± 1.0% | 490.96 ± 0.9% | 808.05 ± 0.8% | 14752.35 ± 0.1% | 580.89 ± 0.2% | 0.97 | 1.00 | 4.30 | 1.18 |
| other: a number before a unit, second text | 15 | 405.72 ± 0.6% | 441.74 ± 0.2% | 609.46 ± 0.2% | 39.44 ± 0.4% | 622.53 ± 0.8% | 889.81 ± 0.2% | 15374.00 ± 0.3% | 405.41 ± 0.5% | 0.92 | 1.00 | 10.29 | 0.65 |
| other: a heading's start tag | 13 | 362.82 ± 0.2% | 367.92 ± 0.1% | 479.95 ± 0.3% | 44.62 ± 0.4% | 617.98 ± 0.4% | 864.83 ± 0.2% | 18578.80 ± 0.1% | 363.11 ± 0.4% | 0.99 | 1.00 | 8.13 | 0.59 |
| other: a whole word | 11 | 615.07 ± 0.2% | 653.46 ± 0.4% | 1084.14 ± 0.1% | 122.28 ± 0.6% | 558.95 ± 1.8% | 818.47 ± 1.1% | 26579.70 ± 1.7% | 614.88 ± 0.4% | 0.94 | 1.00 | 5.03 | 1.10 |
| other: a line's first word, second text | 17 | 559.35 ± 0.5% | 581.00 ± 0.3% | 933.24 ± 0.3% | 129.99 ± 0.2% | 701.68 ± 1.5% | refused | refused | 556.96 ± 0.9% | 0.96 | 1.00 | 4.30 | 0.80 |
| other: fourteen octets before an x | 16 | 113.02 ± 1.1% | 163.03 ± 0.5% | 186.27 ± 0.6% | 15.23 ± 0.4% | 447.01 ± 2.0% | 413.44 ± 0.5% | 13051.60 ± 0.2% | 112.65 ± 0.6% | 0.69 | 1.00 | 7.42 | 0.25 |
| other: a Greek word | 8 | 449.49 ± 0.2% | 591.14 ± 0.4% | 961.57 ± 0.2% | 59.34 ± 0.3% | 1362.44 ± 1.2% | 1780.99 ± 0.8% | refused | 449.26 ± 0.1% | 0.76 | 1.00 | 7.57 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12698.45 ± 0.6% | not timed | not timed | 15834.42 ± 1.3% | 2037.49 ± 17.0% | not timed | not timed | 12748.26 ± 0.9% | | 1.00 | 0.80 | 6.23 |
| 01-literal/sherlock-casei-en | 522 | 3877.02 ± 0.6% | not timed | not timed | 3591.98 ± 0.2% | 32.51 ± 0.2% | not timed | not timed | 3869.64 ± 0.2% | | 1.00 | 1.08 | 119.25 |
| 01-literal/sherlock-ru | 724 | 13594.29 ± 0.7% | not timed | not timed | 17312.19 ± 1.5% | 1536.98 ± 21.0% | not timed | not timed | 13571.05 ± 0.8% | | 1.00 | 0.79 | 8.84 |
| 01-literal/sherlock-casei-ru | 746 | 5231.89 ± 0.3% | not timed | not timed | 3329.94 ± 0.1% | 31.61 ± 4.3% | not timed | not timed | 5240.31 ± 0.3% | | 1.00 | 1.57 | 165.54 |
| 01-literal/sherlock-zh | 30 | 16833.72 ± 0.5% | not timed | not timed | 18242.72 ± 1.0% | 2670.05 ± 9.4% | not timed | not timed | 16763.77 ± 0.4% | | 1.00 | 0.92 | 6.30 |
| 02-literal-alternate/sherlock-en | 714 | 5815.28 ± 1.0% | not timed | not timed | 3941.95 ± 0.1% | 16.60 ± 0.3% | not timed | not timed | 5824.17 ± 0.2% | | 1.00 | 1.48 | 350.42 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1667.01 ± 0.9% | not timed | not timed | 696.33 ± 0.5% | 11.12 ± 0.1% | not timed | not timed | 1662.65 ± 0.1% | | 1.00 | 2.39 | 149.85 |
| 02-literal-alternate/sherlock-ru | 899 | 4645.24 ± 0.1% | not timed | not timed | 3259.68 ± 0.1% | 22.64 ± 0.1% | not timed | not timed | 4636.55 ± 0.1% | | 1.00 | 1.43 | 205.20 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1778.08 ± 0.3% | not timed | not timed | 1228.87 ± 0.1% | 9.16 ± 0.2% | not timed | not timed | 1774.03 ± 0.2% | | 1.00 | 1.45 | 194.10 |
| 02-literal-alternate/sherlock-zh | 207 | 7069.06 ± 0.4% | not timed | not timed | 4160.62 ± 0.6% | 31.42 ± 0.2% | not timed | not timed | 7066.41 ± 0.1% | | 1.00 | 1.70 | 224.99 |
| 03-date/ascii | 111817 | 124.72 ± 0.6% | not timed | not timed | 95.97 ± 0.1% | 0.20 ± 4.0% | not timed | not timed | 123.95 ± 0.2% | | 1.01 | 1.30 | 616.61 |
| 04-ruff-noqa/real | 84 | 555.08 ± 0.1% | not timed | not timed | 461.56 ± 0.1% | 19.65 ± 1.1% | not timed | not timed | 555.39 ± 0.2% | | 1.00 | 1.20 | 28.25 |
| 04-ruff-noqa/tweaked | 44 | 545.11 ± 0.6% | not timed | not timed | 459.52 ± 0.1% | 363.15 ± 0.3% | not timed | not timed | 543.76 ± 0.3% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.65 ± 0.4% | not timed | not timed | 5.05 ± 0.3% | 0.20 ± 4.1% | not timed | not timed | 3.69 ± 0.2% | | 0.99 | 0.72 | 17.96 |
| 06-cloud-flare-redos/original | 107 | 270.42 ± 0.3% | not timed | not timed | 212.47 ± 0.1% | 24.77 ± 0.2% | not timed | not timed | 269.53 ± 0.2% | | 1.00 | 1.27 | 10.92 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.67 ± 0.6% | not timed | not timed | 226.44 ± 0.1% | 26.67 ± 0.3% | not timed | not timed | 264.41 ± 0.5% | | 1.00 | 1.17 | 9.92 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.05 ± 0.1% | not timed | not timed | 253.37 ± 0.0% | 28.82 ± 0.1% | not timed | not timed | 293.86 ± 0.3% | | 1.00 | 1.16 | 10.20 |
| 07-unicode-character-data/parse-line | 558784 | 239.58 ± 0.9% | not timed | not timed | 167.98 ± 0.1% | 42.38 ± 4.2% | not timed | not timed | 239.60 ± 1.0% | | 1.00 | 1.43 | 5.65 |
| 08-words/all-english | 56691 | 119.62 ± 0.4% | not timed | not timed | 82.21 ± 0.1% | 12.74 ± 3.8% | not timed | not timed | 119.42 ± 0.5% | | 1.00 | 1.46 | 9.39 |
| 08-words/long-english | 839 | 1005.83 ± 0.1% | not timed | not timed | 597.76 ± 0.0% | 32.44 ± 0.2% | not timed | not timed | 1004.81 ± 0.1% | | 1.00 | 1.68 | 31.01 |
| 09-aws-keys/full | 0 | 412.97 ± 0.0% | not timed | not timed | 458.74 ± 0.1% | 64.52 ± 0.5% | not timed | not timed | 413.01 ± 0.1% | | 1.00 | 0.90 | 6.40 |
| 09-aws-keys/quick | 0 | 737.05 ± 0.1% | not timed | not timed | 993.22 ± 0.1% | 418.49 ± 0.2% | not timed | not timed | 735.23 ± 0.1% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 634.49 ± 0.5% | not timed | not timed | 517.77 ± 0.6% | 19.45 ± 0.6% | not timed | not timed | 634.43 ± 0.3% | | 1.00 | 1.23 | 32.62 |
| 10-bounded-repeat/letters-ru | 3475 | 380.13 ± 0.3% | not timed | not timed | 477.39 ± 0.2% | 21.73 ± 9.5% | not timed | not timed | 378.24 ± 0.6% | | 1.01 | 0.80 | 17.49 |
| 10-bounded-repeat/context | 53 | 78.72 ± 2.2% | not timed | not timed | 65.38 ± 3.5% | 19.80 ± 0.2% | not timed | not timed | 78.69 ± 1.8% | | 1.00 | 1.20 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 1044.87 ± 0.4% | not timed | not timed | 618.58 ± 0.1% | 36.57 ± 0.1% | not timed | not timed | 1044.78 ± 0.1% | | 1.00 | 1.69 | 28.57 |
| 11-unstructured-to-json/extract | 600 | 47.73 ± 0.1% | not timed | not timed | 77.47 ± 0.5% | 48.64 ± 0.3% | not timed | not timed | 47.05 ± 0.2% | | 1.01 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 572.75 ± 0.2% | not timed | not timed | 559.78 ± 0.3% | 0.40 ± 0.1% | not timed | not timed | 572.49 ± 0.2% | | 1.00 | 1.02 | 1416.95 |
| 14-quadratic/1x | 100 | 13.04 ± 0.5% | not timed | not timed | 10.05 ± 0.2% | 0.96 ± 3.1% | not timed | not timed | 13.04 ± 0.4% | | 1.00 | 1.30 | 13.63 |
| 14-quadratic/2x | 200 | 7.99 ± 0.3% | not timed | not timed | 5.53 ± 0.1% | 0.53 ± 0.6% | not timed | not timed | 7.96 ± 1.5% | | 1.00 | 1.44 | 14.98 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 1.86 ± 0.4% | | 1.00 | 1.53 | 16.09 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.2% | not timed | not timed | 0.34 ± 0.6% | 0.53 ± 3.1% | not timed | not timed | 1.54 ± 1.0% | | 1.01 | 4.55 | 2.91 |
| 04-ruff-noqa/compile-real | 1 | 87.16 ± 0.3% | not timed | not timed | 13.84 ± 0.2% | 136.36 ± 2.0% | not timed | not timed | 86.29 ± 1.0% | | 1.01 | 6.30 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 14.32 ± 0.2% | not timed | not timed | 2.52 ± 1.6% | 6.33 ± 2.2% | not timed | not timed | 14.25 ± 0.5% | | 1.01 | 5.69 | 2.26 |
| 07-unicode-character-data/compile | 1 | 55.29 ± 0.2% | not timed | not timed | 26.01 ± 0.1% | 35.16 ± 1.5% | not timed | not timed | 55.21 ± 0.7% | | 1.00 | 2.13 | 1.57 |
| 09-aws-keys/compile-full | 1 | 42.35 ± 0.3% | not timed | not timed | 8.29 ± 0.3% | 22.84 ± 13.2% | not timed | not timed | 42.23 ± 0.3% | | 1.00 | 5.11 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 190.52 ± 0.2% | not timed | not timed | 47.45 ± 0.1% | 129.43 ± 2.6% | not timed | not timed | 190.81 ± 1.0% | | 1.00 | 4.02 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 14.61 ± 0.5% | not timed | not timed | 11.20 ± 0.1% | 15.52 ± 5.4% | not timed | not timed | 14.50 ± 1.7% | | 1.01 | 1.30 | 0.94 |
| 10-bounded-repeat/compile-capitals | 1 | 85.04 ± 0.7% | not timed | not timed | 8.06 ± 0.1% | 23.18 ± 2.8% | not timed | not timed | 84.88 ± 1.4% | | 1.00 | 10.55 | 3.67 |
| 11-unstructured-to-json/compile | 1 | 86.72 ± 0.4% | not timed | not timed | 40.51 ± 0.8% | 65.46 ± 3.3% | not timed | not timed | 86.44 ± 0.2% | | 1.00 | 2.14 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 7.3% | 0.09 ± 19.1% | not timed | not timed | 0.35 ± 3.2% | | 1.01 | 5.30 | 3.84 |

