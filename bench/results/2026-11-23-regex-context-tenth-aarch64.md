# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117674709 |
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
| literal: a word | 217 | 16042.57 ± 0.5% | 1037.12 ± 0.1% | 28.61 ± 0.2% | 17934.84 ± 3.2% | 9217.35 ± 5.7% | 17.50 ± 0.3% | 86.57 ± 0.3% | 16028.23 ± 1.9% | 15.47 | 1.00 | 0.89 | 1.74 |
| literal: a word that is not there | 0 | 18339.15 ± 2.4% | 1048.01 ± 0.1% | 28.57 ± 0.2% | 19455.94 ± 1.8% | 28750.06 ± 3.6% | 17.33 ± 0.1% | 82.44 ± 0.2% | 18399.96 ± 3.2% | 17.50 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6077.03 ± 0.5% | 1014.30 ± 0.1% | 14.56 ± 0.3% | 3942.74 ± 0.4% | 21.83 ± 0.4% | 5.28 ± 0.1% | 6.91 ± 0.4% | 6063.62 ± 0.4% | 5.99 | 1.00 | 1.54 | 278.38 |
| literal: a word in any case | 217 | 12535.87 ± 0.4% | 1037.64 ± 0.1% | 21.58 ± 2.6% | 3966.70 ± 0.1% | 38.07 ± 0.2% | refused | differs | 12526.65 ± 0.7% | 12.08 | 1.00 | 3.16 | 329.32 |
| literal: an href attribute | 33 | 13751.43 ± 0.5% | 1046.46 ± 0.2% | 27.17 ± 0.2% | 16802.51 ± 2.7% | 2248.11 ± 0.3% | 13.34 ± 0.1% | 75.59 ± 0.4% | 13762.38 ± 1.3% | 13.14 | 1.00 | 0.82 | 6.12 |
| literal: a word, second text | 123 | 16349.69 ± 0.9% | 1042.03 ± 0.1% | 27.96 ± 0.3% | 18199.48 ± 1.8% | 7663.93 ± 8.7% | 19.75 ± 0.4% | 69.88 ± 0.8% | 16364.55 ± 0.3% | 15.69 | 1.00 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1124.16 ± 0.7% | 953.96 ± 0.1% | 25.94 ± 0.5% | 585.45 ± 0.1% | 40.71 ± 7.7% | 14.90 ± 0.2% | 68.89 ± 0.4% | 1123.48 ± 0.7% | 1.18 | 1.00 | 1.92 | 27.61 |
| class: a word that ends in ing | 3399 | 876.38 ± 0.1% | 876.82 ± 0.1% | 18.03 ± 0.3% | 547.67 ± 0.6% | 29.67 ± 6.1% | 8.22 ± 0.2% | 18.39 ± 0.5% | 875.28 ± 0.1% | 1.00 | 1.00 | 1.60 | 29.54 |
| class: a word in capitals | 2332 | 1475.00 ± 1.8% | 938.56 ± 0.1% | 27.52 ± 0.5% | 572.81 ± 0.1% | 43.57 ± 16.8% | 17.18 ± 0.3% | 83.38 ± 0.3% | 1478.60 ± 1.6% | 1.57 | 1.00 | 2.58 | 33.85 |
| class: a number | 8288 | 1992.41 ± 0.3% | 785.97 ± 0.1% | 27.76 ± 0.4% | 1732.02 ± 0.2% | 41.72 ± 16.1% | 0.56 ± 0.1% | 56.77 ± 0.5% | 1992.49 ± 0.1% | 2.53 | 1.00 | 1.15 | 47.76 |
| class: two capitalized words, second text | 5359 | 682.32 ± 0.3% | 678.57 ± 0.5% | 23.27 ± 0.2% | 483.95 ± 0.2% | 35.47 ± 15.0% | 16.71 ± 0.2% | 64.03 ± 0.3% | 682.28 ± 0.2% | 1.01 | 1.00 | 1.41 | 19.23 |
| other: a word between two words | 6104 | 766.92 ± 0.2% | 738.39 ± 0.1% | 23.41 ± 0.2% | 734.87 ± 0.1% | 108.15 ± 14.2% | 11.29 ± 0.1% | 69.76 ± 0.2% | 767.52 ± 0.1% | 1.04 | 1.00 | 1.04 | 7.09 |
| other: a number before a unit, second text | 1481 | 5553.63 ± 0.3% | 972.70 ± 0.1% | 25.84 ± 0.3% | 5664.34 ± 0.6% | 40.82 ± 0.2% | 17.80 ± 0.7% | 66.96 ± 0.4% | 5553.25 ± 0.5% | 5.71 | 1.00 | 0.98 | 136.04 |
| other: a heading's start tag | 110 | 12617.35 ± 1.1% | 1035.41 ± 0.1% | 27.39 ± 0.2% | 1710.18 ± 0.7% | 1563.37 ± 3.4% | 16.30 ± 0.5% | 88.99 ± 0.3% | 12637.13 ± 0.9% | 12.19 | 1.00 | 7.38 | 8.07 |
| other: a whole word | 217 | 13890.24 ± 1.0% | 1036.42 ± 0.1% | 29.32 ± 0.3% | 14333.90 ± 2.9% | 49.46 ± 0.2% | 13.67 ± 0.1% | 55.90 ± 0.3% | 13909.02 ± 0.8% | 13.40 | 1.00 | 0.97 | 280.85 |
| other: a line's first word, second text | 3716 | 1984.21 ± 0.3% | 855.71 ± 0.1% | 31.10 ± 0.1% | 1724.19 ± 1.0% | 62.17 ± 9.4% | refused | refused | 1967.46 ± 0.8% | 2.32 | 1.01 | 1.15 | 31.92 |
| other: fourteen octets before an x | 87 | 19336.75 ± 0.7% | 238.56 ± 0.2% | 6.12 ± 0.1% | 4018.60 ± 0.9% | 10.62 ± 0.0% | differs | 17.74 ± 0.2% | 19350.50 ± 1.4% | 81.06 | 1.00 | 4.81 | 1820.75 |
| other: a Greek word | 21815 | 485.98 ± 0.3% | 308.26 ± 0.3% | 30.98 ± 0.4% | 290.25 ± 0.1% | 47.43 ± 9.5% | differs | refused | 485.15 ± 0.4% | 1.58 | 1.00 | 1.67 | 10.25 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.81 ± 0.3% | 25.85 ± 0.1% | 0.82 ± 0.2% | 19.82 ± 0.1% | 2.77 ± 0.2% | differs | 4.00 ± 0.0% | 25.85 ± 0.3% | 1.00 | 1.00 | 1.30 | 9.32 |
| a UUID | 32895 | 21.13 ± 0.1% | 21.15 ± 0.1% | 0.64 ± 0.2% | 15.13 ± 0.2% | 3.12 ± 0.1% | 0.72 ± 0.2% | 3.57 ± 0.8% | 21.19 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.76 |
| an IPv4 address | 33176 | 36.81 ± 0.2% | 36.76 ± 0.4% | 2.09 ± 0.3% | 28.97 ± 0.6% | 6.66 ± 0.0% | differs | 4.11 ± 0.1% | 36.86 ± 0.4% | 1.00 | 1.00 | 1.27 | 5.53 |
| a date and time | 32954 | 31.05 ± 0.3% | 31.10 ± 0.2% | 1.46 ± 0.4% | 21.19 ± 0.1% | 7.07 ± 0.4% | 1.19 ± 0.3% | 7.02 ± 0.3% | 31.11 ± 0.2% | 1.00 | 1.00 | 1.46 | 4.39 |
| a field path | 32606 | 29.41 ± 0.1% | 29.31 ± 0.2% | 1.00 ± 0.1% | 23.02 ± 0.3% | 3.49 ± 0.7% | differs | 2.96 ± 0.1% | 29.39 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 1.4% | 11.52 ± 2.1% | 11.34 ± 1.8% | 11.48 ± 0.1% | 4.96 ± 2.7% | 0.91 ± 0.2% | none | 11.50 ± 0.4% | 1.00 | 1.00 | 1.00 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.21 ± 0.2% | 217.65 ± 0.3% | 252.07 ± 0.3% | 86.39 ± 0.6% | 220.09 ± 1.3% | 480.20 ± 1.4% | 3888.22 ± 1.8% | 217.04 ± 0.2% | 1.00 | 1.00 | 2.51 | 0.99 |
| a UUID | 62 | 142.88 ± 0.2% | 143.26 ± 0.1% | 157.82 ± 0.2% | 46.27 ± 0.6% | 99.06 ± 0.9% | 190.02 ± 2.9% | 4410.59 ± 1.4% | 142.66 ± 0.4% | 1.00 | 1.00 | 3.09 | 1.44 |
| an IPv4 address | 29 | 439.91 ± 0.4% | 443.16 ± 0.3% | 615.47 ± 0.1% | 76.44 ± 0.4% | 131.07 ± 0.8% | 301.49 ± 1.4% | 7654.69 ± 0.4% | 439.96 ± 0.2% | 0.99 | 1.00 | 5.76 | 3.36 |
| a date and time | 56 | 319.02 ± 0.6% | 320.47 ± 0.4% | 402.78 ± 0.3% | 72.36 ± 0.5% | 136.25 ± 2.2% | 323.99 ± 1.0% | 4922.00 ± 0.7% | 319.27 ± 0.3% | 1.00 | 1.00 | 4.41 | 2.34 |
| a field path | 39 | 202.53 ± 0.1% | 203.10 ± 0.2% | 233.11 ± 0.3% | 80.24 ± 1.1% | 205.67 ± 1.4% | 499.88 ± 2.9% | 4909.76 ± 1.2% | 202.43 ± 0.3% | 1.00 | 1.00 | 2.52 | 0.98 |
| literal: a word | 7 | 667.20 ± 0.5% | 718.97 ± 0.5% | 1289.90 ± 0.4% | 514.67 ± 0.2% | 630.07 ± 1.7% | 953.07 ± 0.5% | 31165.58 ± 0.1% | 666.57 ± 0.4% | 0.93 | 1.00 | 1.30 | 1.06 |
| literal: a word that is not there | 8 | 636.05 ± 0.5% | 690.43 ± 0.4% | 1209.85 ± 0.1% | 472.18 ± 0.6% | 601.44 ± 1.0% | 904.13 ± 0.3% | 29526.93 ± 0.1% | 635.98 ± 0.3% | 0.92 | 1.00 | 1.35 | 1.06 |
| literal: one of four words | 26 | 255.83 ± 0.3% | 420.66 ± 0.5% | 569.39 ± 0.2% | 49.89 ± 1.2% | 242.03 ± 1.3% | 373.78 ± 1.4% | 15807.54 ± 0.4% | 255.66 ± 0.4% | 0.61 | 1.00 | 5.13 | 1.06 |
| literal: a word in any case | 11 | 519.23 ± 0.1% | 560.62 ± 0.5% | 861.58 ± 0.2% | 15.49 ± 1.4% | 647.22 ± 1.2% | refused | 23711.44 ± 0.5% | 519.20 ± 0.2% | 0.93 | 1.00 | 33.52 | 0.80 |
| literal: an href attribute | 12 | 347.53 ± 0.3% | 359.26 ± 0.3% | 466.41 ± 0.3% | 43.69 ± 0.4% | 504.81 ± 1.4% | 772.24 ± 1.2% | 22309.55 ± 0.1% | 347.63 ± 0.3% | 0.97 | 1.00 | 7.95 | 0.69 |
| literal: a word, second text | 10 | 592.39 ± 0.3% | 653.84 ± 0.5% | 1094.79 ± 0.6% | 395.65 ± 0.2% | 534.45 ± 1.4% | 798.57 ± 0.5% | 27513.72 ± 0.4% | 590.45 ± 0.5% | 0.91 | 1.00 | 1.50 | 1.11 |
| class: two capitalized words | 23 | 460.63 ± 0.5% | 490.07 ± 0.2% | 711.82 ± 0.2% | 99.33 ± 0.1% | 504.93 ± 1.6% | 736.76 ± 0.4% | 6630.59 ± 1.8% | 460.20 ± 0.2% | 0.94 | 1.00 | 4.64 | 0.91 |
| class: a word that ends in ing | 9 | 598.23 ± 0.3% | 666.07 ± 0.3% | 1174.68 ± 0.1% | 131.79 ± 2.0% | 759.58 ± 1.1% | 1090.03 ± 0.7% | 16281.84 ± 0.1% | 598.45 ± 0.4% | 0.90 | 1.00 | 4.54 | 0.79 |
| class: a word in capitals | 16 | 522.22 ± 0.4% | 561.30 ± 0.5% | 888.24 ± 0.3% | 134.82 ± 0.6% | 747.07 ± 1.4% | 1018.22 ± 0.7% | 8705.27 ± 0.3% | 522.20 ± 0.9% | 0.93 | 1.00 | 3.87 | 0.70 |
| class: a number | 6 | 661.60 ± 0.5% | 724.11 ± 0.4% | 1340.91 ± 0.1% | 41.60 ± 0.5% | 1412.19 ± 6.9% | 1854.70 ± 1.3% | 22961.97 ± 0.9% | 662.33 ± 0.3% | 0.91 | 1.00 | 15.90 | 0.47 |
| class: two capitalized words, second text | 23 | 460.81 ± 0.4% | 490.38 ± 0.1% | 711.96 ± 0.2% | 100.52 ± 0.3% | 501.97 ± 1.5% | 758.73 ± 0.5% | 6626.67 ± 0.2% | 460.85 ± 0.1% | 0.94 | 1.00 | 4.58 | 0.92 |
| other: a word between two words | 13 | 583.39 ± 0.3% | 603.13 ± 0.4% | 962.04 ± 0.1% | 132.48 ± 0.6% | 500.53 ± 1.3% | 810.96 ± 0.5% | 15099.73 ± 0.1% | 583.07 ± 0.3% | 0.97 | 1.00 | 4.40 | 1.17 |
| other: a number before a unit, second text | 15 | 401.49 ± 0.5% | 435.93 ± 0.6% | 597.69 ± 0.2% | 39.32 ± 0.4% | 634.69 ± 1.3% | 885.42 ± 1.1% | 15364.73 ± 0.4% | 402.28 ± 0.3% | 0.92 | 1.00 | 10.21 | 0.63 |
| other: a heading's start tag | 13 | 358.29 ± 0.4% | 362.85 ± 0.2% | 472.37 ± 0.6% | 43.43 ± 0.9% | 629.56 ± 1.6% | 875.66 ± 0.8% | 18500.18 ± 0.4% | 357.95 ± 0.2% | 0.99 | 1.00 | 8.25 | 0.57 |
| other: a whole word | 11 | 616.70 ± 0.3% | 656.63 ± 0.3% | 1093.68 ± 0.2% | 116.88 ± 0.6% | 562.58 ± 2.2% | 838.42 ± 0.6% | 27199.78 ± 1.0% | 616.52 ± 0.3% | 0.94 | 1.00 | 5.28 | 1.10 |
| other: a line's first word, second text | 17 | 556.81 ± 0.9% | 578.89 ± 0.6% | 924.82 ± 0.5% | 128.31 ± 0.1% | 707.96 ± 2.3% | refused | refused | 554.67 ± 0.8% | 0.96 | 1.00 | 4.34 | 0.79 |
| other: fourteen octets before an x | 16 | 112.02 ± 0.5% | 161.65 ± 0.8% | 184.81 ± 1.1% | 14.95 ± 0.8% | 450.68 ± 0.7% | 413.48 ± 0.4% | 12783.94 ± 2.0% | 111.94 ± 0.4% | 0.69 | 1.00 | 7.49 | 0.25 |
| other: a Greek word | 8 | 448.63 ± 0.2% | 590.79 ± 0.4% | 962.99 ± 0.2% | 58.80 ± 0.1% | 1387.36 ± 1.7% | 1798.05 ± 0.5% | refused | 449.03 ± 0.3% | 0.76 | 1.00 | 7.63 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12841.60 ± 0.6% | not timed | not timed | 16115.71 ± 1.0% | 1998.21 ± 15.2% | not timed | not timed | 12862.89 ± 0.5% | | 1.00 | 0.80 | 6.43 |
| 01-literal/sherlock-casei-en | 522 | 3888.44 ± 0.6% | not timed | not timed | 3593.20 ± 0.2% | 32.36 ± 0.1% | not timed | not timed | 3884.53 ± 0.4% | | 1.00 | 1.08 | 120.16 |
| 01-literal/sherlock-ru | 724 | 13658.02 ± 0.3% | not timed | not timed | 17295.79 ± 0.3% | 1471.95 ± 12.8% | not timed | not timed | 13630.80 ± 0.3% | | 1.00 | 0.79 | 9.28 |
| 01-literal/sherlock-casei-ru | 746 | 5287.72 ± 0.4% | not timed | not timed | 3333.32 ± 0.1% | 30.55 ± 0.3% | not timed | not timed | 5291.47 ± 0.3% | | 1.00 | 1.59 | 173.06 |
| 01-literal/sherlock-zh | 30 | 16804.48 ± 0.4% | not timed | not timed | 18252.09 ± 0.4% | 2628.69 ± 13.2% | not timed | not timed | 16770.50 ± 1.3% | | 1.00 | 0.92 | 6.39 |
| 02-literal-alternate/sherlock-en | 714 | 5807.14 ± 0.1% | not timed | not timed | 3937.13 ± 0.4% | 16.65 ± 0.2% | not timed | not timed | 5814.75 ± 0.5% | | 1.00 | 1.47 | 348.78 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1669.30 ± 0.7% | not timed | not timed | 695.90 ± 0.5% | 11.04 ± 0.3% | not timed | not timed | 1664.37 ± 0.4% | | 1.00 | 2.40 | 151.27 |
| 02-literal-alternate/sherlock-ru | 899 | 4691.79 ± 0.2% | not timed | not timed | 3253.17 ± 0.1% | 22.66 ± 0.3% | not timed | not timed | 4693.16 ± 0.2% | | 1.00 | 1.44 | 207.05 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1783.50 ± 0.8% | not timed | not timed | 1231.19 ± 0.2% | 9.07 ± 0.2% | not timed | not timed | 1779.96 ± 0.3% | | 1.00 | 1.45 | 196.65 |
| 02-literal-alternate/sherlock-zh | 207 | 7031.04 ± 0.8% | not timed | not timed | 4159.91 ± 0.2% | 31.57 ± 0.0% | not timed | not timed | 7038.74 ± 0.8% | | 1.00 | 1.69 | 222.73 |
| 03-date/ascii | 111817 | 124.03 ± 0.5% | not timed | not timed | 95.93 ± 0.1% | 0.20 ± 3.9% | not timed | not timed | 123.66 ± 1.3% | | 1.00 | 1.29 | 616.63 |
| 04-ruff-noqa/real | 84 | 555.45 ± 0.0% | not timed | not timed | 465.96 ± 0.1% | 19.47 ± 0.3% | not timed | not timed | 554.90 ± 0.2% | | 1.00 | 1.19 | 28.53 |
| 04-ruff-noqa/tweaked | 44 | 558.69 ± 0.1% | not timed | not timed | 462.85 ± 0.1% | 366.75 ± 2.0% | not timed | not timed | 558.98 ± 0.1% | | 1.00 | 1.21 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.69 ± 0.6% | not timed | not timed | 4.99 ± 0.1% | 0.20 ± 4.2% | not timed | not timed | 3.65 ± 2.7% | | 1.01 | 0.74 | 18.03 |
| 06-cloud-flare-redos/original | 107 | 182.85 ± 0.8% | not timed | not timed | 217.65 ± 0.2% | 24.89 ± 0.3% | not timed | not timed | 183.72 ± 0.4% | | 1.00 | 0.84 | 7.35 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.14 ± 0.0% | not timed | not timed | 228.37 ± 0.1% | 26.78 ± 0.2% | not timed | not timed | 144.81 ± 0.2% | | 1.00 | 0.64 | 5.42 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.88 ± 2.5% | not timed | not timed | 255.96 ± 0.3% | 28.85 ± 0.3% | not timed | not timed | 154.62 ± 2.4% | | 1.00 | 0.61 | 5.37 |
| 07-unicode-character-data/parse-line | 558784 | 242.40 ± 0.3% | not timed | not timed | 170.60 ± 0.2% | 43.01 ± 4.9% | not timed | not timed | 240.69 ± 2.4% | | 1.01 | 1.42 | 5.64 |
| 08-words/all-english | 56691 | 102.96 ± 0.2% | not timed | not timed | 83.00 ± 0.3% | 12.90 ± 6.3% | not timed | not timed | 102.30 ± 0.4% | | 1.01 | 1.24 | 7.98 |
| 08-words/long-english | 839 | 999.27 ± 0.1% | not timed | not timed | 596.16 ± 0.1% | 32.46 ± 0.3% | not timed | not timed | 998.16 ± 0.1% | | 1.00 | 1.68 | 30.79 |
| 09-aws-keys/full | 0 | 424.04 ± 0.1% | not timed | not timed | 461.89 ± 0.1% | 64.62 ± 3.4% | not timed | not timed | 423.85 ± 0.5% | | 1.00 | 0.92 | 6.56 |
| 09-aws-keys/quick | 0 | 737.34 ± 0.1% | not timed | not timed | 969.37 ± 0.2% | 422.55 ± 0.9% | not timed | not timed | 733.02 ± 0.1% | | 1.01 | 0.76 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 585.32 ± 0.3% | not timed | not timed | 516.80 ± 0.2% | 19.53 ± 0.3% | not timed | not timed | 584.91 ± 0.2% | | 1.00 | 1.13 | 29.97 |
| 10-bounded-repeat/letters-ru | 3475 | 400.72 ± 0.2% | not timed | not timed | 480.83 ± 0.2% | 22.35 ± 10.2% | not timed | not timed | 400.30 ± 1.6% | | 1.00 | 0.83 | 17.93 |
| 10-bounded-repeat/context | 53 | 79.73 ± 1.0% | not timed | not timed | 65.78 ± 0.6% | 19.80 ± 0.2% | not timed | not timed | 79.71 ± 1.0% | | 1.00 | 1.21 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 1046.89 ± 0.2% | not timed | not timed | 618.63 ± 0.1% | 36.65 ± 0.2% | not timed | not timed | 1046.97 ± 0.1% | | 1.00 | 1.69 | 28.56 |
| 11-unstructured-to-json/extract | 600 | 48.26 ± 0.2% | not timed | not timed | 77.70 ± 0.4% | 48.83 ± 0.5% | not timed | not timed | 47.00 ± 1.1% | | 1.03 | 0.62 | 0.99 |
| 12-dictionary/single | 1 | 605.12 ± 0.5% | not timed | not timed | 561.92 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 604.50 ± 0.3% | | 1.00 | 1.08 | 1483.74 |
| 14-quadratic/1x | 100 | 12.57 ± 0.2% | not timed | not timed | 10.05 ± 0.3% | 0.98 ± 3.3% | not timed | not timed | 12.56 ± 0.6% | | 1.00 | 1.25 | 12.86 |
| 14-quadratic/2x | 200 | 7.82 ± 0.4% | not timed | not timed | 5.56 ± 0.3% | 0.53 ± 1.6% | not timed | not timed | 7.79 ± 1.3% | | 1.00 | 1.41 | 14.68 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.86 ± 0.5% | | 1.00 | 1.54 | 16.11 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.4% | not timed | not timed | 0.34 ± 0.9% | 0.55 ± 1.9% | not timed | not timed | 1.53 ± 1.0% | | 1.00 | 4.50 | 2.79 |
| 04-ruff-noqa/compile-real | 1 | 84.96 ± 0.1% | not timed | not timed | 13.63 ± 0.1% | 139.49 ± 2.7% | not timed | not timed | 84.72 ± 0.4% | | 1.00 | 6.24 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.47 ± 1.4% | not timed | not timed | 2.52 ± 0.6% | 6.46 ± 1.5% | not timed | not timed | 14.40 ± 0.7% | | 1.00 | 5.75 | 2.24 |
| 07-unicode-character-data/compile | 1 | 54.94 ± 0.1% | not timed | not timed | 25.80 ± 0.2% | 36.15 ± 9.0% | not timed | not timed | 54.81 ± 1.5% | | 1.00 | 2.13 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.02 ± 0.3% | not timed | not timed | 8.21 ± 0.4% | 23.25 ± 2.0% | not timed | not timed | 42.03 ± 0.2% | | 1.00 | 5.12 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 187.94 ± 0.1% | not timed | not timed | 47.30 ± 0.1% | 133.98 ± 2.4% | not timed | not timed | 187.83 ± 1.3% | | 1.00 | 3.97 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.48 ± 1.4% | not timed | not timed | 11.12 ± 0.2% | 15.82 ± 3.6% | not timed | not timed | 14.35 ± 2.0% | | 1.01 | 1.30 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 84.93 ± 1.6% | not timed | not timed | 8.01 ± 0.3% | 23.66 ± 1.7% | not timed | not timed | 84.53 ± 1.7% | | 1.00 | 10.60 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 85.96 ± 0.3% | not timed | not timed | 40.73 ± 0.2% | 67.93 ± 2.9% | not timed | not timed | 86.06 ± 0.8% | | 1.00 | 2.11 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 38.0% | 0.09 ± 10.8% | not timed | not timed | 0.35 ± 2.2% | | 1.02 | 5.23 | 3.82 |

