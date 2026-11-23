# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243532636 |
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
| literal: a word | 217 | 19545.32 ± 2.4% | 4990.56 ± 0.3% | 27.73 ± 0.3% | 18098.71 ± 1.9% | 9007.11 ± 7.8% | 17.37 ± 0.5% | 84.36 ± 0.7% | 19538.08 ± 3.2% | 3.92 | 1.00 | 1.08 | 2.17 |
| literal: a word that is not there | 0 | 21205.08 ± 0.9% | 4873.77 ± 0.2% | 27.78 ± 0.4% | 19595.78 ± 0.6% | 28653.42 ± 0.7% | 17.23 ± 0.1% | 79.81 ± 0.3% | 21375.00 ± 0.8% | 4.35 | 0.99 | 1.08 | 0.74 |
| literal: one of four words | 661 | 6369.87 ± 0.3% | 1934.30 ± 0.2% | 14.24 ± 0.5% | 3948.17 ± 0.5% | 21.90 ± 0.1% | 5.30 ± 0.3% | 6.67 ± 0.5% | 6349.07 ± 0.2% | 3.29 | 1.00 | 1.61 | 290.87 |
| literal: a word in any case | 217 | 15068.21 ± 0.8% | 2074.04 ± 0.3% | 21.12 ± 0.2% | 3964.27 ± 0.3% | 38.07 ± 0.3% | refused | differs | 15011.83 ± 0.4% | 7.27 | 1.00 | 3.80 | 395.77 |
| literal: an href attribute | 33 | 16682.39 ± 2.3% | 609.64 ± 0.3% | 26.64 ± 0.4% | 16933.42 ± 2.4% | 2256.50 ± 0.5% | 13.39 ± 0.1% | 74.08 ± 0.4% | 16821.06 ± 2.5% | 27.36 | 0.99 | 0.99 | 7.39 |
| literal: a word, second text | 123 | 19340.66 ± 2.0% | 3351.39 ± 0.2% | 27.34 ± 0.2% | 17824.52 ± 2.1% | 7772.35 ± 3.5% | 18.94 ± 0.9% | 70.27 ± 0.3% | 19317.51 ± 1.8% | 5.77 | 1.00 | 1.09 | 2.49 |
| class: two capitalized words | 1331 | 1055.58 ± 0.3% | 600.27 ± 0.3% | 25.37 ± 0.2% | 582.04 ± 0.1% | 40.63 ± 11.9% | 14.93 ± 0.3% | 67.10 ± 0.4% | 1055.59 ± 0.4% | 1.76 | 1.00 | 1.81 | 25.98 |
| class: a word that ends in ing | 3399 | 573.23 ± 0.4% | 572.36 ± 0.2% | 17.70 ± 0.3% | 545.06 ± 0.1% | 29.56 ± 8.4% | 8.12 ± 0.2% | 18.25 ± 0.5% | 573.23 ± 0.6% | 1.00 | 1.00 | 1.05 | 19.39 |
| class: a word in capitals | 2332 | 1370.63 ± 0.3% | 603.17 ± 0.2% | 26.91 ± 0.3% | 572.64 ± 0.0% | 43.51 ± 5.3% | 16.92 ± 0.3% | 82.59 ± 0.3% | 1370.22 ± 0.1% | 2.27 | 1.00 | 2.39 | 31.50 |
| class: a number | 8288 | 1955.60 ± 0.3% | 827.00 ± 0.1% | 27.20 ± 0.3% | 1711.24 ± 0.0% | 43.01 ± 17.0% | 0.57 ± 0.1% | 57.56 ± 0.3% | 1955.25 ± 0.4% | 2.36 | 1.00 | 1.14 | 45.47 |
| class: two capitalized words, second text | 5359 | 516.03 ± 0.6% | 524.55 ± 0.3% | 22.74 ± 0.3% | 486.02 ± 0.1% | 35.45 ± 14.5% | 16.58 ± 0.2% | 62.13 ± 1.7% | 515.37 ± 0.2% | 0.98 | 1.00 | 1.06 | 14.56 |
| other: a word between two words | 6104 | 796.50 ± 0.2% | 593.85 ± 0.2% | 23.01 ± 0.1% | 735.55 ± 0.2% | 111.61 ± 22.3% | 11.40 ± 0.2% | 67.74 ± 1.2% | 796.67 ± 0.1% | 1.34 | 1.00 | 1.08 | 7.14 |
| other: a number before a unit, second text | 1481 | 5939.47 ± 1.6% | 1121.47 ± 0.4% | 25.48 ± 0.1% | 5662.13 ± 0.6% | 40.32 ± 0.1% | 17.55 ± 0.2% | 65.73 ± 0.6% | 5872.52 ± 0.6% | 5.30 | 1.01 | 1.05 | 147.29 |
| other: a heading's start tag | 110 | 13993.01 ± 0.9% | 741.79 ± 0.2% | 26.82 ± 0.3% | 1715.28 ± 0.3% | 1584.30 ± 4.6% | 16.27 ± 0.6% | 86.17 ± 0.6% | 14024.99 ± 0.6% | 18.86 | 1.00 | 8.16 | 8.83 |
| other: a whole word | 217 | 15849.81 ± 2.2% | 604.11 ± 0.2% | 28.69 ± 0.3% | 14427.65 ± 1.0% | 49.37 ± 0.2% | 13.82 ± 0.3% | 54.85 ± 0.2% | 15848.89 ± 1.8% | 26.24 | 1.00 | 1.10 | 321.04 |
| other: a line's first word, second text | 3716 | 2044.93 ± 0.7% | 587.39 ± 0.2% | 29.89 ± 0.5% | 1730.58 ± 0.6% | 62.85 ± 8.0% | refused | refused | 2034.61 ± 0.6% | 3.48 | 1.01 | 1.18 | 32.54 |
| other: fourteen octets before an x | 87 | 23728.25 ± 2.3% | 236.94 ± 0.3% | 6.51 ± 0.0% | 4010.78 ± 0.3% | 10.63 ± 0.1% | differs | 17.70 ± 0.1% | 23700.85 ± 0.6% | 100.14 | 1.00 | 5.92 | 2231.47 |
| other: a Greek word | 21815 | 486.74 ± 1.0% | 408.36 ± 0.2% | 30.14 ± 0.9% | 289.54 ± 0.1% | 47.35 ± 13.9% | differs | refused | 484.41 ± 0.3% | 1.19 | 1.00 | 1.68 | 10.28 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.50 ± 0.4% | 18.51 ± 0.4% | 0.86 ± 0.3% | 19.51 ± 0.4% | 2.77 ± 0.3% | differs | 3.99 ± 0.1% | 18.49 ± 0.3% | 1.00 | 1.00 | 0.95 | 6.67 |
| a UUID | 32895 | 20.10 ± 0.1% | 20.12 ± 0.2% | 0.64 ± 0.4% | 15.10 ± 0.5% | 3.12 ± 0.1% | 0.72 ± 0.3% | 3.62 ± 0.5% | 19.95 ± 0.2% | 1.00 | 1.01 | 1.33 | 6.45 |
| an IPv4 address | 33176 | 33.55 ± 0.3% | 33.63 ± 0.2% | 2.08 ± 0.8% | 28.98 ± 0.4% | 6.62 ± 0.1% | differs | 4.14 ± 0.1% | 33.63 ± 0.0% | 1.00 | 1.00 | 1.16 | 5.07 |
| a date and time | 32954 | 28.69 ± 0.3% | 28.81 ± 0.3% | 1.44 ± 0.4% | 21.32 ± 0.5% | 7.06 ± 0.2% | 1.19 ± 0.1% | 7.13 ± 0.6% | 28.84 ± 0.1% | 1.00 | 0.99 | 1.35 | 4.07 |
| a field path | 32606 | 21.74 ± 0.2% | 21.77 ± 0.3% | 1.02 ± 0.1% | 23.07 ± 0.2% | 3.48 ± 1.3% | differs | 2.93 ± 0.1% | 21.78 ± 0.2% | 1.00 | 1.00 | 0.94 | 6.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.4% | 11.10 ± 0.6% | 11.08 ± 0.5% | 11.54 ± 0.2% | 4.90 ± 2.4% | 0.91 ± 0.6% | none | 11.10 ± 0.1% | 1.00 | 1.00 | 0.96 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.33 ± 0.3% | 222.10 ± 0.3% | 264.08 ± 0.2% | 87.18 ± 0.4% | 218.62 ± 3.2% | 479.02 ± 0.5% | 3804.80 ± 0.2% | 221.16 ± 0.2% | 1.00 | 1.00 | 2.54 | 1.01 |
| a UUID | 62 | 143.45 ± 0.2% | 143.85 ± 0.2% | 161.16 ± 0.1% | 46.46 ± 0.4% | 98.17 ± 0.5% | 182.93 ± 1.6% | 4270.77 ± 0.3% | 143.38 ± 0.2% | 1.00 | 1.00 | 3.09 | 1.46 |
| an IPv4 address | 29 | 412.22 ± 0.3% | 416.32 ± 0.3% | 596.08 ± 0.4% | 77.14 ± 0.5% | 130.89 ± 1.5% | 292.04 ± 1.2% | 7554.62 ± 0.4% | 411.28 ± 0.3% | 0.99 | 1.00 | 5.34 | 3.15 |
| a date and time | 56 | 295.04 ± 0.4% | 296.83 ± 0.3% | 375.90 ± 0.1% | 73.17 ± 0.5% | 134.90 ± 1.5% | 315.64 ± 1.2% | 4924.01 ± 0.6% | 295.13 ± 0.4% | 0.99 | 1.00 | 4.03 | 2.19 |
| a field path | 39 | 213.25 ± 0.4% | 214.06 ± 0.3% | 252.09 ± 0.4% | 80.92 ± 0.4% | 202.02 ± 0.7% | 502.59 ± 2.3% | 4844.17 ± 0.4% | 213.14 ± 0.1% | 1.00 | 1.00 | 2.64 | 1.06 |
| literal: a word | 7 | 610.10 ± 0.4% | 664.20 ± 0.4% | 1223.82 ± 0.1% | 520.47 ± 0.5% | 625.23 ± 2.5% | 941.43 ± 0.3% | 29635.45 ± 0.3% | 610.18 ± 0.4% | 0.92 | 1.00 | 1.17 | 0.98 |
| literal: a word that is not there | 8 | 593.34 ± 0.2% | 645.02 ± 0.4% | 1155.11 ± 0.2% | 469.64 ± 0.1% | 592.62 ± 1.6% | 891.32 ± 0.5% | 28588.85 ± 0.3% | 592.57 ± 0.1% | 0.92 | 1.00 | 1.26 | 1.00 |
| literal: one of four words | 26 | 237.15 ± 0.3% | 393.92 ± 0.3% | 545.28 ± 0.4% | 49.31 ± 0.5% | 240.25 ± 1.7% | 361.49 ± 2.0% | 15720.28 ± 0.1% | 237.25 ± 0.2% | 0.60 | 1.00 | 4.81 | 0.99 |
| literal: a word in any case | 11 | 434.32 ± 0.6% | 465.46 ± 0.5% | 691.48 ± 0.2% | 15.75 ± 0.3% | 645.08 ± 4.3% | refused | 23438.84 ± 0.4% | 434.21 ± 0.2% | 0.93 | 1.00 | 27.58 | 0.67 |
| literal: an href attribute | 12 | 332.86 ± 0.5% | 346.04 ± 0.2% | 460.08 ± 0.2% | 45.78 ± 0.8% | 495.98 ± 1.8% | 776.10 ± 0.5% | 21274.26 ± 0.8% | 332.74 ± 0.3% | 0.96 | 1.00 | 7.27 | 0.67 |
| literal: a word, second text | 10 | 547.16 ± 0.2% | 604.38 ± 0.6% | 1039.56 ± 0.2% | 423.18 ± 0.4% | 538.61 ± 1.3% | 804.71 ± 0.4% | 26397.95 ± 0.2% | 546.63 ± 0.1% | 0.91 | 1.00 | 1.29 | 1.02 |
| class: two capitalized words | 23 | 420.41 ± 0.3% | 455.17 ± 0.5% | 672.47 ± 0.5% | 101.11 ± 0.1% | 498.06 ± 0.5% | 740.34 ± 0.3% | 6436.81 ± 0.4% | 420.60 ± 0.4% | 0.92 | 1.00 | 4.16 | 0.84 |
| class: a word that ends in ing | 9 | 539.10 ± 0.2% | 611.53 ± 0.4% | 1102.98 ± 0.1% | 132.28 ± 1.2% | 757.13 ± 1.5% | 1098.55 ± 1.9% | 15761.37 ± 0.2% | 538.47 ± 0.2% | 0.88 | 1.00 | 4.08 | 0.71 |
| class: a word in capitals | 16 | 473.24 ± 0.2% | 519.70 ± 0.5% | 867.32 ± 0.1% | 136.05 ± 0.6% | 752.33 ± 1.1% | 1015.15 ± 1.2% | 8486.67 ± 0.3% | 473.30 ± 0.1% | 0.91 | 1.00 | 3.48 | 0.63 |
| class: a number | 6 | 596.78 ± 0.2% | 669.89 ± 0.1% | 1323.46 ± 0.0% | 41.93 ± 0.5% | 1396.75 ± 1.0% | 1917.91 ± 1.6% | 22268.97 ± 0.1% | 596.82 ± 0.1% | 0.89 | 1.00 | 14.23 | 0.43 |
| class: two capitalized words, second text | 23 | 420.15 ± 0.4% | 453.83 ± 0.2% | 672.80 ± 0.5% | 104.04 ± 0.4% | 497.56 ± 1.0% | 727.30 ± 0.4% | 6440.06 ± 0.4% | 419.92 ± 0.3% | 0.93 | 1.00 | 4.04 | 0.84 |
| other: a word between two words | 13 | 528.04 ± 0.3% | 549.23 ± 0.5% | 902.62 ± 0.4% | 135.77 ± 1.0% | 502.99 ± 1.4% | 809.22 ± 0.8% | 14659.60 ± 0.1% | 528.52 ± 0.4% | 0.96 | 1.00 | 3.89 | 1.05 |
| other: a number before a unit, second text | 15 | 379.86 ± 0.4% | 419.67 ± 1.6% | 592.67 ± 0.9% | 39.48 ± 0.7% | 636.20 ± 0.5% | 888.79 ± 0.2% | 14938.51 ± 0.1% | 380.08 ± 0.1% | 0.91 | 1.00 | 9.62 | 0.60 |
| other: a heading's start tag | 13 | 342.68 ± 0.7% | 349.65 ± 0.4% | 468.26 ± 0.5% | 44.42 ± 0.3% | 625.93 ± 0.9% | 865.25 ± 0.4% | 17671.57 ± 0.3% | 342.67 ± 0.2% | 0.98 | 1.00 | 7.71 | 0.55 |
| other: a whole word | 11 | 565.79 ± 0.3% | 604.97 ± 0.5% | 1034.69 ± 0.3% | 122.18 ± 0.7% | 564.03 ± 3.0% | 813.92 ± 0.8% | 26644.62 ± 0.3% | 565.12 ± 0.2% | 0.94 | 1.00 | 4.63 | 1.00 |
| other: a line's first word, second text | 17 | 519.21 ± 0.4% | 542.83 ± 0.5% | 894.39 ± 0.1% | 130.35 ± 0.1% | 709.32 ± 0.8% | refused | refused | 517.44 ± 0.8% | 0.96 | 1.00 | 3.98 | 0.73 |
| other: fourteen octets before an x | 16 | 105.61 ± 0.2% | 150.77 ± 0.5% | 175.44 ± 0.7% | 15.05 ± 0.2% | 453.15 ± 2.5% | 403.02 ± 0.6% | 12659.63 ± 0.5% | 105.46 ± 0.6% | 0.70 | 1.00 | 7.02 | 0.23 |
| other: a Greek word | 8 | 410.83 ± 0.4% | 566.91 ± 0.5% | 987.43 ± 0.5% | 59.23 ± 0.3% | 1385.82 ± 1.8% | 1839.92 ± 0.7% | refused | 411.03 ± 0.1% | 0.72 | 1.00 | 6.94 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15619.24 ± 0.7% | not timed | not timed | 16190.49 ± 1.2% | 2135.38 ± 13.7% | not timed | not timed | 15595.92 ± 0.5% | | 1.00 | 0.96 | 7.31 |
| 01-literal/sherlock-casei-en | 522 | 5167.79 ± 1.3% | not timed | not timed | 3590.39 ± 0.5% | 32.54 ± 0.3% | not timed | not timed | 5153.39 ± 0.6% | | 1.00 | 1.44 | 158.82 |
| 01-literal/sherlock-ru | 724 | 17112.72 ± 0.5% | not timed | not timed | 17280.98 ± 0.4% | 1495.23 ± 21.9% | not timed | not timed | 17094.67 ± 0.2% | | 1.00 | 0.99 | 11.44 |
| 01-literal/sherlock-casei-ru | 746 | 6175.13 ± 0.4% | not timed | not timed | 3321.12 ± 0.2% | 30.77 ± 0.3% | not timed | not timed | 6161.93 ± 0.1% | | 1.00 | 1.86 | 200.71 |
| 01-literal/sherlock-zh | 30 | 19420.12 ± 0.9% | not timed | not timed | 18421.70 ± 0.7% | 2758.80 ± 8.3% | not timed | not timed | 19339.38 ± 0.4% | | 1.00 | 1.05 | 7.04 |
| 02-literal-alternate/sherlock-en | 714 | 6061.46 ± 0.3% | not timed | not timed | 3936.72 ± 0.2% | 16.63 ± 0.2% | not timed | not timed | 6068.80 ± 0.2% | | 1.00 | 1.54 | 364.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1940.29 ± 1.6% | not timed | not timed | 695.56 ± 0.3% | 11.02 ± 0.3% | not timed | not timed | 1925.33 ± 0.6% | | 1.01 | 2.79 | 176.09 |
| 02-literal-alternate/sherlock-ru | 899 | 5565.54 ± 0.0% | not timed | not timed | 3255.01 ± 0.1% | 22.54 ± 0.3% | not timed | not timed | 5544.92 ± 0.2% | | 1.00 | 1.71 | 246.89 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2059.90 ± 0.6% | not timed | not timed | 1229.94 ± 0.4% | 9.08 ± 0.2% | not timed | not timed | 2043.84 ± 0.2% | | 1.01 | 1.67 | 226.94 |
| 02-literal-alternate/sherlock-zh | 207 | 7289.71 ± 0.8% | not timed | not timed | 4161.41 ± 0.1% | 31.42 ± 0.3% | not timed | not timed | 7299.32 ± 0.2% | | 1.00 | 1.75 | 231.99 |
| 03-date/ascii | 111817 | 124.00 ± 0.6% | not timed | not timed | 96.33 ± 0.2% | 0.20 ± 4.6% | not timed | not timed | 123.26 ± 0.4% | | 1.01 | 1.29 | 612.65 |
| 04-ruff-noqa/real | 84 | 401.87 ± 0.0% | not timed | not timed | 462.77 ± 0.1% | 19.67 ± 1.2% | not timed | not timed | 400.47 ± 0.2% | | 1.00 | 0.87 | 20.43 |
| 04-ruff-noqa/tweaked | 44 | 561.29 ± 0.1% | not timed | not timed | 458.91 ± 0.1% | 366.61 ± 0.6% | not timed | not timed | 553.66 ± 0.4% | | 1.01 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.14 ± 0.2% | not timed | not timed | 5.06 ± 0.2% | 0.21 ± 2.8% | not timed | not timed | 5.05 ± 2.6% | | 1.02 | 1.02 | 24.94 |
| 06-cloud-flare-redos/original | 107 | 415.20 ± 0.2% | not timed | not timed | 214.25 ± 0.1% | 24.81 ± 0.4% | not timed | not timed | 414.10 ± 0.2% | | 1.00 | 1.94 | 16.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.16 ± 0.1% | not timed | not timed | 226.88 ± 0.0% | 26.56 ± 0.5% | not timed | not timed | 409.62 ± 0.2% | | 1.00 | 1.81 | 15.48 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.80 ± 0.3% | not timed | not timed | 253.33 ± 0.4% | 28.76 ± 0.1% | not timed | not timed | 583.09 ± 0.1% | | 1.00 | 2.30 | 20.30 |
| 07-unicode-character-data/parse-line | 558784 | 235.19 ± 2.0% | not timed | not timed | 170.28 ± 0.1% | 42.79 ± 5.5% | not timed | not timed | 235.41 ± 0.6% | | 1.00 | 1.38 | 5.50 |
| 08-words/all-english | 56691 | 116.75 ± 0.4% | not timed | not timed | 83.36 ± 0.2% | 12.85 ± 13.3% | not timed | not timed | 116.54 ± 0.4% | | 1.00 | 1.40 | 9.09 |
| 08-words/long-english | 839 | 613.21 ± 0.3% | not timed | not timed | 597.57 ± 0.1% | 32.62 ± 0.1% | not timed | not timed | 613.41 ± 0.3% | | 1.00 | 1.03 | 18.80 |
| 09-aws-keys/full | 0 | 408.27 ± 0.2% | not timed | not timed | 461.59 ± 0.1% | 64.39 ± 0.2% | not timed | not timed | 406.98 ± 0.2% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 942.52 ± 0.1% | not timed | not timed | 992.79 ± 0.1% | 420.58 ± 1.0% | not timed | not timed | 941.98 ± 0.2% | | 1.00 | 0.95 | 2.24 |
| 10-bounded-repeat/letters-en | 1833 | 582.25 ± 3.1% | not timed | not timed | 517.91 ± 0.3% | 19.58 ± 0.2% | not timed | not timed | 577.82 ± 1.1% | | 1.01 | 1.12 | 29.74 |
| 10-bounded-repeat/letters-ru | 3475 | 498.96 ± 0.9% | not timed | not timed | 477.66 ± 0.1% | 21.96 ± 8.1% | not timed | not timed | 505.69 ± 1.1% | | 0.99 | 1.04 | 22.72 |
| 10-bounded-repeat/context | 53 | 77.32 ± 0.4% | not timed | not timed | 65.82 ± 0.3% | 19.86 ± 0.2% | not timed | not timed | 76.91 ± 0.4% | | 1.01 | 1.17 | 3.89 |
| 10-bounded-repeat/capitals | 11 | 635.29 ± 8.3% | not timed | not timed | 618.59 ± 0.0% | 36.64 ± 0.1% | not timed | not timed | 634.89 ± 8.3% | | 1.00 | 1.03 | 17.34 |
| 11-unstructured-to-json/extract | 600 | 82.83 ± 0.1% | not timed | not timed | 77.58 ± 0.4% | 48.97 ± 0.3% | not timed | not timed | 82.50 ± 0.1% | | 1.00 | 1.07 | 1.69 |
| 12-dictionary/single | 1 | 560.26 ± 0.2% | not timed | not timed | 558.24 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 560.47 ± 0.1% | | 1.00 | 1.00 | 1389.83 |
| 14-quadratic/1x | 100 | 21.19 ± 0.8% | not timed | not timed | 9.99 ± 0.3% | 0.96 ± 2.4% | not timed | not timed | 21.14 ± 1.1% | | 1.00 | 2.12 | 22.14 |
| 14-quadratic/2x | 200 | 17.55 ± 0.3% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 0.7% | not timed | not timed | 17.49 ± 1.0% | | 1.00 | 3.17 | 32.90 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.68 ± 0.5% | | 1.00 | 6.33 | 66.40 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.3% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 3.2% | not timed | not timed | 1.26 ± 1.7% | | 1.00 | 3.74 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 88.25 ± 0.1% | not timed | not timed | 13.75 ± 0.3% | 139.36 ± 2.0% | not timed | not timed | 87.97 ± 1.4% | | 1.00 | 6.42 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 13.90 ± 1.3% | not timed | not timed | 2.50 ± 0.6% | 6.47 ± 1.8% | not timed | not timed | 13.74 ± 1.3% | | 1.01 | 5.56 | 2.15 |
| 07-unicode-character-data/compile | 1 | 53.67 ± 0.1% | not timed | not timed | 25.83 ± 0.3% | 35.97 ± 1.7% | not timed | not timed | 52.91 ± 1.2% | | 1.01 | 2.08 | 1.49 |
| 09-aws-keys/compile-full | 1 | 41.03 ± 0.4% | not timed | not timed | 8.22 ± 0.2% | 23.16 ± 0.4% | not timed | not timed | 40.60 ± 1.1% | | 1.01 | 4.99 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 178.98 ± 0.3% | not timed | not timed | 47.10 ± 0.3% | 133.21 ± 1.9% | not timed | not timed | 178.83 ± 0.3% | | 1.00 | 3.80 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 13.53 ± 0.4% | not timed | not timed | 11.16 ± 0.2% | 15.99 ± 1.5% | not timed | not timed | 13.51 ± 1.3% | | 1.00 | 1.21 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 80.70 ± 0.4% | not timed | not timed | 8.09 ± 0.1% | 23.73 ± 0.8% | not timed | not timed | 80.38 ± 1.7% | | 1.00 | 9.97 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 84.04 ± 0.3% | not timed | not timed | 40.58 ± 0.3% | 68.43 ± 3.0% | not timed | not timed | 83.54 ± 2.3% | | 1.01 | 2.07 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 35.4% | 0.10 ± 14.6% | not timed | not timed | 0.35 ± 0.2% | | 1.01 | 5.09 | 3.58 |

