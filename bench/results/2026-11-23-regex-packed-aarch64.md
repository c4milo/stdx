# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102054128 |
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
| literal: a word | 217 | 16104.96 ± 0.9% | 1042.65 ± 0.3% | 28.07 ± 0.5% | 18320.96 ± 1.6% | 9168.43 ± 8.5% | 17.32 ± 0.5% | 86.60 ± 0.2% | 16130.54 ± 0.5% | 15.45 | 1.00 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18786.69 ± 1.0% | 1045.61 ± 0.5% | 28.17 ± 0.6% | 19739.30 ± 2.4% | 27863.38 ± 5.8% | 17.08 ± 0.5% | 82.63 ± 0.3% | 18943.14 ± 1.2% | 17.97 | 0.99 | 0.95 | 0.67 |
| literal: one of four words | 661 | 6162.18 ± 0.2% | 1021.15 ± 0.3% | 14.36 ± 0.2% | 3947.84 ± 0.3% | 21.88 ± 0.1% | 5.43 ± 0.2% | 6.96 ± 0.6% | 6142.10 ± 0.4% | 6.03 | 1.00 | 1.56 | 281.68 |
| literal: a word in any case | 217 | 12536.53 ± 0.5% | 1039.68 ± 0.3% | 20.91 ± 2.1% | 3971.25 ± 0.1% | 38.05 ± 0.3% | refused | differs | 12531.75 ± 0.2% | 12.06 | 1.00 | 3.16 | 329.51 |
| literal: an href attribute | 33 | 13835.74 ± 0.7% | 1046.89 ± 0.3% | 26.93 ± 0.0% | 17133.05 ± 1.1% | 2268.73 ± 0.4% | 12.83 ± 0.2% | 75.69 ± 0.1% | 13841.07 ± 0.3% | 13.22 | 1.00 | 0.81 | 6.10 |
| literal: a word, second text | 123 | 16500.36 ± 0.6% | 1048.69 ± 0.4% | 27.75 ± 0.4% | 18421.86 ± 1.3% | 7781.04 ± 3.1% | 19.85 ± 0.3% | 70.87 ± 0.4% | 16545.10 ± 0.9% | 15.73 | 1.00 | 0.90 | 2.12 |
| class: two capitalized words | 1331 | 1105.37 ± 0.3% | 959.08 ± 0.1% | 25.76 ± 0.3% | 581.97 ± 0.1% | 40.77 ± 4.3% | 14.77 ± 0.3% | 69.04 ± 0.2% | 1104.29 ± 0.3% | 1.15 | 1.00 | 1.90 | 27.12 |
| class: a word that ends in ing | 3399 | 880.44 ± 0.1% | 881.81 ± 0.2% | 17.82 ± 0.4% | 544.46 ± 0.1% | 29.67 ± 0.6% | 8.18 ± 0.1% | 18.42 ± 0.2% | 879.88 ± 0.2% | 1.00 | 1.00 | 1.62 | 29.68 |
| class: a word in capitals | 2332 | 1469.66 ± 0.6% | 945.82 ± 0.6% | 27.42 ± 0.2% | 572.41 ± 0.1% | 43.54 ± 8.1% | 17.02 ± 0.3% | 83.37 ± 0.3% | 1471.61 ± 0.4% | 1.55 | 1.00 | 2.57 | 33.75 |
| class: a number | 8288 | 2064.04 ± 0.2% | 792.93 ± 0.3% | 27.49 ± 0.1% | 1719.86 ± 0.1% | 41.36 ± 13.8% | 0.56 ± 0.1% | 56.85 ± 0.5% | 2065.04 ± 0.2% | 2.60 | 1.00 | 1.20 | 49.90 |
| class: two capitalized words, second text | 5359 | 690.24 ± 0.2% | 687.70 ± 0.0% | 23.08 ± 0.1% | 486.85 ± 0.1% | 34.15 ± 15.2% | 17.25 ± 0.6% | 64.14 ± 0.2% | 690.31 ± 0.2% | 1.00 | 1.00 | 1.42 | 20.21 |
| other: a word between two words | 6104 | 775.68 ± 0.2% | 743.65 ± 0.4% | 23.25 ± 0.3% | 735.78 ± 0.1% | 107.92 ± 19.9% | 11.26 ± 0.2% | 69.91 ± 0.2% | 779.90 ± 0.1% | 1.04 | 0.99 | 1.05 | 7.19 |
| other: a number before a unit, second text | 1481 | 5461.82 ± 0.3% | 979.86 ± 0.1% | 25.62 ± 0.2% | 5651.32 ± 0.4% | 40.90 ± 0.1% | 18.22 ± 0.2% | 67.07 ± 0.1% | 5472.08 ± 0.3% | 5.57 | 1.00 | 0.97 | 133.55 |
| other: a heading's start tag | 110 | 12765.67 ± 0.7% | 1031.34 ± 0.1% | 26.99 ± 0.1% | 1707.36 ± 0.1% | 1584.06 ± 1.9% | 16.08 ± 0.4% | 89.19 ± 0.3% | 12768.26 ± 0.6% | 12.38 | 1.00 | 7.48 | 8.06 |
| other: a whole word | 217 | 14094.68 ± 0.6% | 1040.32 ± 0.3% | 28.86 ± 1.0% | 14698.97 ± 0.7% | 49.43 ± 0.4% | 13.14 ± 0.2% | 56.37 ± 0.2% | 14092.24 ± 0.9% | 13.55 | 1.00 | 0.96 | 285.12 |
| other: a line's first word, second text | 3716 | 1953.04 ± 0.2% | 856.69 ± 0.2% | 30.42 ± 0.1% | 1728.96 ± 0.5% | 62.23 ± 6.3% | refused | refused | 1946.12 ± 0.3% | 2.28 | 1.00 | 1.13 | 31.39 |
| other: fourteen octets before an x | 87 | 19275.70 ± 1.7% | 239.01 ± 0.7% | 5.30 ± 0.1% | 4041.78 ± 0.5% | 10.64 ± 0.1% | differs | 17.81 ± 0.2% | 19447.54 ± 3.3% | 80.65 | 0.99 | 4.77 | 1811.66 |
| other: a Greek word | 21815 | 472.42 ± 0.7% | 316.32 ± 0.3% | 30.35 ± 0.2% | 290.06 ± 0.3% | 49.40 ± 10.1% | differs | refused | 472.15 ± 0.9% | 1.49 | 1.00 | 1.63 | 9.56 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.05 ± 0.2% | 26.04 ± 0.4% | 0.82 ± 0.3% | 19.60 ± 1.1% | 2.78 ± 0.5% | differs | 4.01 ± 0.2% | 26.07 ± 0.2% | 1.00 | 1.00 | 1.33 | 9.39 |
| a UUID | 32895 | 21.24 ± 0.1% | 21.32 ± 0.2% | 0.64 ± 0.3% | 15.10 ± 0.6% | 3.10 ± 0.5% | 0.73 ± 0.2% | 3.58 ± 0.3% | 21.35 ± 0.1% | 1.00 | 0.99 | 1.41 | 6.84 |
| an IPv4 address | 33176 | 36.97 ± 0.3% | 36.88 ± 0.1% | 2.08 ± 0.1% | 29.23 ± 0.9% | 6.63 ± 0.3% | differs | 4.13 ± 0.1% | 36.99 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.58 |
| a date and time | 32954 | 31.20 ± 0.3% | 31.23 ± 0.3% | 1.45 ± 0.1% | 21.60 ± 0.9% | 7.04 ± 0.9% | 1.25 ± 0.0% | 7.15 ± 0.9% | 31.21 ± 0.2% | 1.00 | 1.00 | 1.44 | 4.43 |
| a field path | 32606 | 29.61 ± 0.1% | 29.54 ± 0.2% | 0.97 ± 0.2% | 23.34 ± 0.8% | 3.50 ± 1.0% | differs | 2.96 ± 0.3% | 29.57 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.02 ± 0.2% | 9.03 ± 0.2% | 9.01 ± 0.3% | 11.83 ± 0.3% | 5.01 ± 2.6% | 0.93 ± 0.2% | none | 9.03 ± 0.3% | 1.00 | 1.00 | 0.76 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.69 ± 0.7% | 238.85 ± 0.4% | 289.18 ± 0.4% | 87.46 ± 0.1% | 224.82 ± 0.5% | 482.15 ± 0.7% | 3881.24 ± 1.6% | 236.87 ± 0.3% | 0.99 | 1.00 | 2.71 | 1.05 |
| a UUID | 62 | 158.19 ± 0.3% | 158.68 ± 0.2% | 179.38 ± 0.2% | 46.54 ± 0.3% | 100.57 ± 0.9% | 185.29 ± 2.4% | 4246.22 ± 1.1% | 158.31 ± 0.3% | 1.00 | 1.00 | 3.40 | 1.57 |
| an IPv4 address | 29 | 424.40 ± 0.4% | 428.73 ± 0.4% | 618.79 ± 0.7% | 77.43 ± 0.5% | 133.41 ± 1.9% | 294.33 ± 0.8% | 7594.86 ± 0.2% | 423.95 ± 0.5% | 0.99 | 1.00 | 5.48 | 3.18 |
| a date and time | 56 | 306.72 ± 0.5% | 308.86 ± 0.2% | 395.63 ± 0.4% | 73.29 ± 0.5% | 139.01 ± 2.7% | 320.13 ± 1.1% | 4863.84 ± 0.5% | 306.60 ± 0.2% | 0.99 | 1.00 | 4.19 | 2.21 |
| a field path | 39 | 228.37 ± 0.4% | 229.79 ± 0.1% | 275.51 ± 0.4% | 80.84 ± 0.6% | 208.10 ± 1.6% | 505.87 ± 1.5% | 4944.34 ± 3.1% | 228.42 ± 0.2% | 0.99 | 1.00 | 2.83 | 1.10 |
| literal: a word | 7 | 637.32 ± 0.5% | 684.49 ± 0.5% | 1289.06 ± 1.3% | 513.74 ± 0.4% | 641.67 ± 3.7% | 944.01 ± 0.8% | 30458.43 ± 0.1% | 637.65 ± 0.5% | 0.93 | 1.00 | 1.24 | 0.99 |
| literal: a word that is not there | 8 | 610.04 ± 0.4% | 661.00 ± 0.6% | 1218.74 ± 1.3% | 463.92 ± 0.0% | 616.13 ± 2.1% | 896.25 ± 0.5% | 29110.97 ± 0.1% | 609.55 ± 0.6% | 0.92 | 1.00 | 1.31 | 0.99 |
| literal: one of four words | 26 | 243.61 ± 0.3% | 406.40 ± 0.5% | 569.93 ± 0.4% | 49.32 ± 0.5% | 245.68 ± 1.6% | 366.84 ± 2.3% | 15619.92 ± 0.2% | 243.83 ± 0.4% | 0.60 | 1.00 | 4.94 | 0.99 |
| literal: a word in any case | 11 | 491.00 ± 0.5% | 525.28 ± 0.5% | 848.99 ± 0.5% | 15.71 ± 0.2% | 669.40 ± 1.0% | refused | 23736.06 ± 0.4% | 491.86 ± 0.4% | 0.93 | 1.00 | 31.25 | 0.73 |
| literal: an href attribute | 12 | 354.99 ± 0.5% | 366.19 ± 0.2% | 499.23 ± 0.4% | 45.68 ± 0.7% | 511.42 ± 0.8% | 777.93 ± 0.7% | 21661.82 ± 0.5% | 354.42 ± 0.5% | 0.97 | 1.00 | 7.77 | 0.69 |
| literal: a word, second text | 10 | 569.62 ± 0.9% | 628.78 ± 0.6% | 1096.94 ± 0.6% | 419.51 ± 0.9% | 545.40 ± 1.3% | 811.00 ± 0.5% | 27102.60 ± 0.1% | 570.98 ± 0.7% | 0.91 | 1.00 | 1.36 | 1.04 |
| class: two capitalized words | 23 | 441.24 ± 0.5% | 470.53 ± 0.7% | 705.39 ± 0.5% | 101.15 ± 0.3% | 513.24 ± 0.7% | 753.16 ± 0.6% | 6574.28 ± 0.2% | 441.42 ± 0.3% | 0.94 | 1.00 | 4.36 | 0.86 |
| class: a word that ends in ing | 9 | 571.47 ± 0.4% | 640.84 ± 1.0% | 1178.24 ± 0.2% | 131.79 ± 1.3% | 773.03 ± 5.7% | 1111.57 ± 2.1% | 16132.91 ± 0.4% | 571.43 ± 0.6% | 0.89 | 1.00 | 4.34 | 0.74 |
| class: a word in capitals | 16 | 506.64 ± 0.4% | 542.98 ± 0.7% | 908.61 ± 0.3% | 136.32 ± 0.3% | 763.17 ± 1.8% | 1024.87 ± 0.6% | 8694.83 ± 0.2% | 506.10 ± 0.3% | 0.93 | 1.00 | 3.72 | 0.66 |
| class: a number | 6 | 636.05 ± 1.1% | 701.27 ± 1.2% | 1389.83 ± 2.0% | 41.93 ± 0.7% | 1431.37 ± 1.6% | 1919.22 ± 1.4% | 22881.11 ± 0.0% | 635.60 ± 0.9% | 0.91 | 1.00 | 15.17 | 0.44 |
| class: two capitalized words, second text | 23 | 441.69 ± 0.4% | 470.33 ± 0.4% | 707.50 ± 0.8% | 104.27 ± 0.3% | 510.18 ± 6.0% | 736.79 ± 0.6% | 6573.94 ± 0.2% | 441.58 ± 0.5% | 0.94 | 1.00 | 4.24 | 0.87 |
| other: a word between two words | 13 | 559.99 ± 0.2% | 578.33 ± 0.4% | 963.86 ± 0.6% | 134.62 ± 1.1% | 507.74 ± 1.7% | 815.10 ± 0.9% | 14882.58 ± 0.3% | 559.87 ± 0.4% | 0.97 | 1.00 | 4.16 | 1.10 |
| other: a number before a unit, second text | 15 | 411.11 ± 0.3% | 449.75 ± 0.3% | 655.11 ± 0.4% | 39.42 ± 0.3% | 646.07 ± 0.8% | 893.73 ± 0.2% | 15178.97 ± 1.1% | 411.18 ± 0.3% | 0.91 | 1.00 | 10.43 | 0.64 |
| other: a heading's start tag | 13 | 361.84 ± 0.3% | 367.16 ± 0.3% | 499.38 ± 0.4% | 44.50 ± 0.5% | 637.45 ± 1.3% | 870.35 ± 0.4% | 18121.05 ± 0.2% | 361.52 ± 0.4% | 0.99 | 1.00 | 8.13 | 0.57 |
| other: a whole word | 11 | 593.93 ± 0.7% | 631.77 ± 0.7% | 1105.23 ± 1.0% | 121.22 ± 0.6% | 576.66 ± 1.9% | 818.06 ± 0.8% | 26950.04 ± 0.2% | 592.72 ± 0.6% | 0.94 | 1.00 | 4.90 | 1.03 |
| other: a line's first word, second text | 17 | 541.90 ± 0.5% | 561.07 ± 0.4% | 946.13 ± 0.6% | 129.48 ± 0.2% | 719.35 ± 0.6% | refused | refused | 540.16 ± 0.7% | 0.97 | 1.00 | 4.19 | 0.75 |
| other: fourteen octets before an x | 16 | 112.35 ± 0.7% | 161.54 ± 0.8% | 189.51 ± 1.2% | 15.18 ± 0.3% | 459.17 ± 1.9% | 407.10 ± 0.4% | 12582.97 ± 0.7% | 112.24 ± 0.5% | 0.70 | 1.00 | 7.40 | 0.24 |
| other: a Greek word | 8 | 434.87 ± 0.2% | 600.48 ± 1.3% | 1061.59 ± 1.2% | 59.17 ± 0.8% | 1413.84 ± 1.4% | 1844.28 ± 1.2% | refused | 434.76 ± 0.5% | 0.72 | 1.00 | 7.35 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12933.59 ± 0.2% | not timed | not timed | 16601.77 ± 1.6% | 2017.48 ± 25.6% | not timed | not timed | 12920.34 ± 0.6% | | 1.00 | 0.78 | 6.41 |
| 01-literal/sherlock-casei-en | 522 | 3950.25 ± 0.6% | not timed | not timed | 3597.58 ± 0.2% | 32.49 ± 0.2% | not timed | not timed | 3941.73 ± 0.5% | | 1.00 | 1.10 | 121.60 |
| 01-literal/sherlock-ru | 724 | 13587.02 ± 0.5% | not timed | not timed | 17266.14 ± 0.6% | 1491.50 ± 11.3% | not timed | not timed | 13571.39 ± 0.9% | | 1.00 | 0.79 | 9.11 |
| 01-literal/sherlock-casei-ru | 746 | 5398.35 ± 0.1% | not timed | not timed | 3335.16 ± 0.2% | 30.79 ± 0.4% | not timed | not timed | 5403.98 ± 0.2% | | 1.00 | 1.62 | 175.34 |
| 01-literal/sherlock-zh | 30 | 17225.40 ± 1.3% | not timed | not timed | 18846.84 ± 0.5% | 2508.81 ± 7.9% | not timed | not timed | 17199.56 ± 1.0% | | 1.00 | 0.91 | 6.87 |
| 02-literal-alternate/sherlock-en | 714 | 5913.11 ± 0.5% | not timed | not timed | 3944.65 ± 0.1% | 16.65 ± 0.1% | not timed | not timed | 5912.47 ± 0.2% | | 1.00 | 1.50 | 355.08 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1709.27 ± 0.9% | not timed | not timed | 696.42 ± 0.3% | 11.06 ± 0.1% | not timed | not timed | 1698.83 ± 0.4% | | 1.01 | 2.45 | 154.56 |
| 02-literal-alternate/sherlock-ru | 899 | 4808.46 ± 0.3% | not timed | not timed | 3258.45 ± 0.2% | 22.66 ± 0.2% | not timed | not timed | 4813.60 ± 0.2% | | 1.00 | 1.48 | 212.18 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1826.09 ± 0.7% | not timed | not timed | 1234.20 ± 0.1% | 9.10 ± 0.1% | not timed | not timed | 1814.39 ± 0.2% | | 1.01 | 1.48 | 200.59 |
| 02-literal-alternate/sherlock-zh | 207 | 7103.37 ± 0.3% | not timed | not timed | 4169.70 ± 0.1% | 31.54 ± 0.1% | not timed | not timed | 7114.96 ± 0.4% | | 1.00 | 1.70 | 225.24 |
| 03-date/ascii | 111817 | 123.97 ± 0.6% | not timed | not timed | 96.12 ± 0.1% | 0.20 ± 6.6% | not timed | not timed | 123.64 ± 0.9% | | 1.00 | 1.29 | 611.49 |
| 04-ruff-noqa/real | 84 | 552.57 ± 0.2% | not timed | not timed | 475.69 ± 0.1% | 19.75 ± 1.3% | not timed | not timed | 553.65 ± 0.1% | | 1.00 | 1.16 | 27.98 |
| 04-ruff-noqa/tweaked | 44 | 553.43 ± 0.4% | not timed | not timed | 461.87 ± 0.1% | 365.52 ± 0.4% | not timed | not timed | 554.07 ± 0.4% | | 1.00 | 1.20 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.3% | not timed | not timed | 5.24 ± 0.3% | 0.21 ± 2.7% | not timed | not timed | 3.68 ± 1.7% | | 0.96 | 0.67 | 17.02 |
| 06-cloud-flare-redos/original | 107 | 183.52 ± 0.4% | not timed | not timed | 215.79 ± 0.0% | 24.77 ± 0.4% | not timed | not timed | 183.08 ± 0.4% | | 1.00 | 0.85 | 7.41 |
| 06-cloud-flare-redos/simplified-short | 102 | 147.00 ± 1.8% | not timed | not timed | 226.92 ± 0.1% | 26.83 ± 0.1% | not timed | not timed | 146.95 ± 1.9% | | 1.00 | 0.65 | 5.48 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.80 ± 2.1% | not timed | not timed | 253.72 ± 0.2% | 28.82 ± 0.1% | not timed | not timed | 156.45 ± 1.7% | | 1.00 | 0.62 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 39.98 ± 0.2% | not timed | not timed | 179.87 ± 0.1% | 43.27 ± 3.8% | not timed | not timed | 39.98 ± 0.8% | | 1.00 | 0.22 | 0.92 |
| 08-words/all-english | 56691 | 102.94 ± 0.2% | not timed | not timed | 83.25 ± 0.2% | 12.11 ± 11.1% | not timed | not timed | 102.64 ± 0.5% | | 1.00 | 1.24 | 8.50 |
| 08-words/long-english | 839 | 997.96 ± 0.1% | not timed | not timed | 597.88 ± 0.0% | 32.68 ± 0.1% | not timed | not timed | 997.84 ± 0.1% | | 1.00 | 1.67 | 30.54 |
| 09-aws-keys/full | 0 | 422.23 ± 0.0% | not timed | not timed | 496.12 ± 0.1% | 64.75 ± 3.4% | not timed | not timed | 422.19 ± 0.1% | | 1.00 | 0.85 | 6.52 |
| 09-aws-keys/quick | 0 | 410.10 ± 0.1% | not timed | not timed | 997.20 ± 0.7% | 422.54 ± 0.8% | not timed | not timed | 410.38 ± 0.1% | | 1.00 | 0.41 | 0.97 |
| 10-bounded-repeat/letters-en | 1833 | 571.89 ± 0.2% | not timed | not timed | 518.01 ± 0.4% | 19.60 ± 0.5% | not timed | not timed | 587.34 ± 0.2% | | 0.97 | 1.10 | 29.18 |
| 10-bounded-repeat/letters-ru | 3475 | 403.95 ± 0.1% | not timed | not timed | 469.50 ± 0.2% | 21.71 ± 11.9% | not timed | not timed | 403.22 ± 0.6% | | 1.00 | 0.86 | 18.61 |
| 10-bounded-repeat/context | 53 | 73.36 ± 1.1% | not timed | not timed | 66.35 ± 0.6% | 19.83 ± 0.2% | not timed | not timed | 73.20 ± 1.2% | | 1.00 | 1.11 | 3.70 |
| 10-bounded-repeat/capitals | 11 | 1040.46 ± 0.2% | not timed | not timed | 618.26 ± 0.0% | 36.39 ± 0.1% | not timed | not timed | 1039.66 ± 0.2% | | 1.00 | 1.68 | 28.59 |
| 11-unstructured-to-json/extract | 600 | 24.58 ± 0.1% | not timed | not timed | 76.92 ± 0.3% | 49.31 ± 0.8% | not timed | not timed | 24.42 ± 0.9% | | 1.01 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 601.34 ± 0.5% | not timed | not timed | 554.68 ± 0.3% | 0.41 ± 0.1% | not timed | not timed | 602.01 ± 0.1% | | 1.00 | 1.08 | 1456.53 |
| 14-quadratic/1x | 100 | 12.60 ± 0.6% | not timed | not timed | 10.07 ± 0.7% | 0.98 ± 3.4% | not timed | not timed | 12.50 ± 1.5% | | 1.01 | 1.25 | 12.84 |
| 14-quadratic/2x | 200 | 7.78 ± 0.6% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 1.7% | not timed | not timed | 7.77 ± 0.5% | | 1.00 | 1.40 | 14.59 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.83 ± 0.6% | | 1.00 | 1.51 | 15.86 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.3% | not timed | not timed | 0.35 ± 0.4% | 0.56 ± 0.7% | not timed | not timed | 1.44 ± 1.1% | | 1.01 | 4.18 | 2.60 |
| 04-ruff-noqa/compile-real | 1 | 92.66 ± 0.2% | not timed | not timed | 13.90 ± 0.2% | 141.73 ± 0.9% | not timed | not timed | 92.67 ± 1.1% | | 1.00 | 6.66 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.70 ± 0.5% | not timed | not timed | 2.55 ± 0.9% | 6.57 ± 2.0% | not timed | not timed | 14.68 ± 1.0% | | 1.00 | 5.77 | 2.24 |
| 07-unicode-character-data/compile | 1 | 58.39 ± 0.1% | not timed | not timed | 26.09 ± 0.1% | 36.87 ± 2.4% | not timed | not timed | 58.57 ± 1.0% | | 1.00 | 2.24 | 1.58 |
| 09-aws-keys/compile-full | 1 | 43.63 ± 0.3% | not timed | not timed | 8.33 ± 0.3% | 23.81 ± 0.6% | not timed | not timed | 43.50 ± 0.7% | | 1.00 | 5.24 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 188.27 ± 0.1% | not timed | not timed | 48.17 ± 0.1% | 136.84 ± 3.7% | not timed | not timed | 189.93 ± 1.0% | | 0.99 | 3.91 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.70 ± 0.4% | not timed | not timed | 11.19 ± 0.1% | 16.48 ± 3.8% | not timed | not timed | 14.64 ± 1.8% | | 1.00 | 1.31 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 85.94 ± 0.5% | not timed | not timed | 8.04 ± 0.3% | 24.43 ± 2.6% | not timed | not timed | 85.53 ± 1.1% | | 1.00 | 10.69 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 91.15 ± 0.1% | not timed | not timed | 40.85 ± 0.2% | 70.19 ± 2.1% | not timed | not timed | 90.21 ± 1.2% | | 1.01 | 2.23 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 0.4% | 0.10 ± 20.2% | not timed | not timed | 0.35 ± 2.6% | | 1.01 | 5.09 | 3.72 |

