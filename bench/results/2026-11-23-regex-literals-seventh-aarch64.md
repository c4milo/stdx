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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243495094 |
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
| literal: a word | 217 | 19108.62 ± 1.1% | 4986.45 ± 0.2% | 28.34 ± 0.3% | 18098.17 ± 3.1% | 9220.33 ± 7.0% | 17.30 ± 0.2% | 84.10 ± 0.4% | 19004.28 ± 2.6% | 3.83 | 1.01 | 1.06 | 2.07 |
| literal: a word that is not there | 0 | 20758.52 ± 2.4% | 4872.25 ± 0.6% | 28.37 ± 0.3% | 19474.55 ± 1.8% | 27139.95 ± 3.4% | 17.11 ± 0.3% | 79.39 ± 0.4% | 20857.29 ± 4.9% | 4.26 | 1.00 | 1.07 | 0.76 |
| literal: one of four words | 661 | 6356.26 ± 3.5% | 1934.26 ± 0.3% | 14.38 ± 0.8% | 3945.11 ± 0.3% | 21.88 ± 0.1% | 5.34 ± 0.2% | 6.85 ± 0.6% | 6333.54 ± 0.6% | 3.29 | 1.00 | 1.61 | 290.57 |
| literal: a word in any case | 217 | 15061.62 ± 1.0% | 2077.36 ± 0.1% | 21.49 ± 0.3% | 3971.76 ± 0.3% | 38.08 ± 0.2% | refused | differs | 15012.62 ± 1.3% | 7.25 | 1.00 | 3.79 | 395.48 |
| literal: an href attribute | 33 | 16863.49 ± 1.3% | 609.21 ± 0.7% | 27.41 ± 0.5% | 16947.14 ± 2.8% | 2260.41 ± 0.6% | 13.13 ± 0.1% | 73.77 ± 0.9% | 16872.00 ± 1.2% | 27.68 | 1.00 | 1.00 | 7.46 |
| literal: a word, second text | 123 | 19393.02 ± 1.8% | 3358.91 ± 0.3% | 27.99 ± 0.5% | 17852.57 ± 2.1% | 7573.64 ± 4.6% | 20.16 ± 0.3% | 69.88 ± 0.8% | 19652.08 ± 3.3% | 5.77 | 0.99 | 1.09 | 2.56 |
| class: two capitalized words | 1331 | 1057.41 ± 0.4% | 599.67 ± 0.5% | 25.98 ± 0.2% | 585.38 ± 0.1% | 40.64 ± 9.9% | 14.72 ± 0.2% | 67.34 ± 0.2% | 1056.42 ± 0.3% | 1.76 | 1.00 | 1.81 | 26.02 |
| class: a word that ends in ing | 3399 | 572.86 ± 0.4% | 572.51 ± 0.6% | 18.02 ± 0.1% | 547.73 ± 0.2% | 29.62 ± 3.3% | 8.13 ± 0.1% | 18.25 ± 0.2% | 572.08 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.34 |
| class: a word in capitals | 2332 | 1370.43 ± 0.5% | 602.90 ± 0.4% | 27.67 ± 0.4% | 572.72 ± 0.0% | 43.56 ± 2.5% | 17.22 ± 0.1% | 82.44 ± 0.3% | 1371.65 ± 0.2% | 2.27 | 1.00 | 2.39 | 31.46 |
| class: a number | 8288 | 1959.80 ± 0.5% | 825.28 ± 0.3% | 27.71 ± 0.5% | 1713.43 ± 0.1% | 40.72 ± 16.1% | 0.54 ± 0.1% | 57.25 ± 0.9% | 1959.43 ± 0.2% | 2.37 | 1.00 | 1.14 | 48.13 |
| class: two capitalized words, second text | 5359 | 516.77 ± 0.3% | 523.81 ± 0.3% | 23.35 ± 0.3% | 485.22 ± 0.1% | 35.14 ± 6.9% | 17.13 ± 0.2% | 62.54 ± 0.6% | 516.11 ± 0.3% | 0.99 | 1.00 | 1.07 | 14.70 |
| other: a word between two words | 6104 | 792.88 ± 0.1% | 589.47 ± 0.2% | 23.54 ± 0.3% | 739.16 ± 0.2% | 110.32 ± 10.5% | 11.17 ± 0.1% | 68.06 ± 0.4% | 792.46 ± 0.2% | 1.35 | 1.00 | 1.07 | 7.19 |
| other: a number before a unit, second text | 1481 | 5983.62 ± 1.6% | 1120.63 ± 0.3% | 26.08 ± 0.1% | 5670.22 ± 0.5% | 40.74 ± 5.1% | 18.20 ± 0.3% | 65.40 ± 0.9% | 5949.45 ± 1.3% | 5.34 | 1.01 | 1.06 | 146.86 |
| other: a heading's start tag | 110 | 14016.36 ± 1.1% | 742.55 ± 0.1% | 27.37 ± 0.7% | 1711.74 ± 0.3% | 1586.08 ± 2.2% | 15.99 ± 0.7% | 86.10 ± 0.5% | 13990.49 ± 1.3% | 18.88 | 1.00 | 8.19 | 8.84 |
| other: a whole word | 217 | 15674.71 ± 0.9% | 599.47 ± 1.1% | 29.25 ± 0.1% | 14309.28 ± 0.9% | 49.39 ± 0.8% | 13.26 ± 0.1% | 55.02 ± 0.6% | 15690.08 ± 1.0% | 26.15 | 1.00 | 1.10 | 317.34 |
| other: a line's first word, second text | 3716 | 2045.45 ± 0.8% | 588.25 ± 0.3% | 30.97 ± 0.2% | 1725.95 ± 0.4% | 61.09 ± 10.3% | refused | refused | 2045.32 ± 0.6% | 3.48 | 1.00 | 1.19 | 33.48 |
| other: fourteen octets before an x | 87 | 23877.53 ± 2.3% | 244.98 ± 0.7% | 6.55 ± 0.1% | 3931.70 ± 1.0% | 10.65 ± 0.3% | differs | 17.67 ± 0.1% | 23848.30 ± 0.6% | 97.47 | 1.00 | 6.07 | 2241.55 |
| other: a Greek word | 21815 | 488.64 ± 0.5% | 408.07 ± 0.2% | 30.86 ± 0.3% | 289.36 ± 0.4% | 43.92 ± 9.7% | differs | refused | 483.82 ± 0.4% | 1.20 | 1.01 | 1.69 | 11.13 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.47 ± 0.1% | 18.53 ± 0.2% | 0.86 ± 0.4% | 19.76 ± 0.1% | 2.74 ± 0.6% | differs | 4.00 ± 0.1% | 18.53 ± 0.2% | 1.00 | 1.00 | 0.93 | 6.75 |
| a UUID | 32895 | 20.08 ± 0.3% | 20.10 ± 0.1% | 0.64 ± 0.1% | 15.06 ± 0.5% | 3.11 ± 0.1% | 0.73 ± 0.1% | 3.63 ± 0.6% | 19.94 ± 0.2% | 1.00 | 1.01 | 1.33 | 6.45 |
| an IPv4 address | 33176 | 33.66 ± 0.2% | 33.68 ± 0.1% | 2.09 ± 0.2% | 29.34 ± 0.4% | 6.63 ± 0.1% | differs | 4.16 ± 0.1% | 33.70 ± 0.2% | 1.00 | 1.00 | 1.15 | 5.08 |
| a date and time | 32954 | 28.85 ± 0.2% | 28.92 ± 0.2% | 1.45 ± 0.2% | 21.47 ± 0.5% | 7.05 ± 0.1% | 1.26 ± 0.2% | 7.16 ± 0.3% | 28.93 ± 0.2% | 1.00 | 1.00 | 1.34 | 4.09 |
| a field path | 32606 | 21.77 ± 0.1% | 21.78 ± 0.1% | 1.02 ± 0.3% | 23.16 ± 0.2% | 3.49 ± 0.9% | differs | 2.94 ± 0.3% | 21.78 ± 0.1% | 1.00 | 1.00 | 0.94 | 6.24 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.11 ± 0.3% | 11.09 ± 0.3% | 11.12 ± 0.4% | 11.53 ± 0.1% | 4.95 ± 1.6% | 0.94 ± 0.5% | none | 11.07 ± 0.4% | 1.00 | 1.00 | 0.96 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.20 ± 0.2% | 230.23 ± 0.2% | 269.45 ± 0.2% | 86.38 ± 0.6% | 221.85 ± 1.6% | 481.02 ± 1.2% | 3828.48 ± 3.4% | 229.18 ± 0.2% | 1.00 | 1.00 | 2.65 | 1.03 |
| a UUID | 62 | 148.15 ± 0.4% | 148.41 ± 0.3% | 164.41 ± 0.4% | 46.34 ± 0.6% | 99.27 ± 0.7% | 189.69 ± 2.8% | 4291.29 ± 0.5% | 148.06 ± 0.1% | 1.00 | 1.00 | 3.20 | 1.49 |
| an IPv4 address | 29 | 424.86 ± 0.5% | 428.62 ± 0.2% | 589.04 ± 0.4% | 76.73 ± 0.3% | 131.82 ± 0.6% | 303.12 ± 2.1% | 7636.74 ± 0.4% | 424.77 ± 0.5% | 0.99 | 1.00 | 5.54 | 3.22 |
| a date and time | 56 | 305.58 ± 0.2% | 306.57 ± 0.4% | 381.17 ± 0.3% | 72.46 ± 0.3% | 138.34 ± 2.0% | 324.31 ± 0.7% | 4970.31 ± 0.2% | 305.47 ± 0.1% | 1.00 | 1.00 | 4.22 | 2.21 |
| a field path | 39 | 220.76 ± 0.4% | 222.00 ± 0.1% | 258.23 ± 0.2% | 80.41 ± 1.0% | 207.10 ± 1.4% | 500.26 ± 2.6% | 4876.82 ± 0.4% | 221.13 ± 0.1% | 0.99 | 1.00 | 2.75 | 1.07 |
| literal: a word | 7 | 641.90 ± 0.6% | 694.22 ± 1.1% | 1230.81 ± 0.5% | 515.11 ± 0.6% | 635.55 ± 1.2% | 958.82 ± 0.6% | 30753.38 ± 0.3% | 641.39 ± 0.6% | 0.92 | 1.00 | 1.25 | 1.01 |
| literal: a word that is not there | 8 | 614.90 ± 0.2% | 671.00 ± 0.3% | 1159.28 ± 0.1% | 473.97 ± 0.1% | 606.32 ± 2.7% | 909.09 ± 0.5% | 29631.74 ± 0.1% | 614.45 ± 0.2% | 0.92 | 1.00 | 1.30 | 1.01 |
| literal: one of four words | 26 | 248.78 ± 0.2% | 403.79 ± 0.2% | 542.07 ± 0.6% | 49.59 ± 0.9% | 243.41 ± 1.5% | 370.53 ± 1.9% | 16118.20 ± 0.1% | 248.85 ± 0.1% | 0.62 | 1.00 | 5.02 | 1.02 |
| literal: a word in any case | 11 | 448.95 ± 0.1% | 481.37 ± 0.1% | 693.51 ± 0.2% | 15.81 ± 1.6% | 666.39 ± 4.9% | refused | 23849.17 ± 0.3% | 448.18 ± 0.5% | 0.93 | 1.00 | 28.40 | 0.67 |
| literal: an href attribute | 12 | 349.32 ± 0.4% | 363.56 ± 0.4% | 473.69 ± 0.4% | 44.11 ± 0.3% | 507.12 ± 1.5% | 773.47 ± 0.8% | 22193.79 ± 0.3% | 349.86 ± 0.6% | 0.96 | 1.00 | 7.92 | 0.69 |
| literal: a word, second text | 10 | 572.89 ± 0.8% | 633.42 ± 0.9% | 1049.43 ± 0.7% | 394.99 ± 0.1% | 543.02 ± 1.3% | 802.90 ± 0.6% | 27633.68 ± 0.2% | 572.92 ± 0.7% | 0.90 | 1.00 | 1.45 | 1.06 |
| class: two capitalized words | 23 | 443.05 ± 0.6% | 473.35 ± 0.6% | 678.09 ± 0.7% | 99.28 ± 0.1% | 506.29 ± 2.0% | 740.38 ± 0.3% | 6502.85 ± 0.4% | 443.34 ± 0.7% | 0.94 | 1.00 | 4.46 | 0.88 |
| class: a word that ends in ing | 9 | 576.62 ± 0.3% | 645.34 ± 0.3% | 1119.06 ± 0.2% | 131.31 ± 1.7% | 769.32 ± 0.3% | 1102.88 ± 0.7% | 16089.79 ± 0.4% | 576.58 ± 0.2% | 0.89 | 1.00 | 4.39 | 0.75 |
| class: a word in capitals | 16 | 505.58 ± 0.3% | 544.53 ± 0.2% | 862.53 ± 0.2% | 134.52 ± 0.5% | 757.71 ± 1.0% | 1022.66 ± 0.6% | 8576.95 ± 0.3% | 505.39 ± 0.1% | 0.93 | 1.00 | 3.76 | 0.67 |
| class: a number | 6 | 643.85 ± 0.5% | 708.49 ± 0.4% | 1316.21 ± 0.1% | 41.66 ± 0.5% | 1421.38 ± 1.3% | 1858.22 ± 1.1% | 23112.04 ± 0.2% | 643.38 ± 0.5% | 0.91 | 1.00 | 15.45 | 0.45 |
| class: two capitalized words, second text | 23 | 443.82 ± 0.4% | 473.64 ± 0.7% | 678.53 ± 0.4% | 100.56 ± 0.4% | 506.70 ± 2.5% | 761.74 ± 0.5% | 6501.13 ± 0.7% | 443.52 ± 0.6% | 0.94 | 1.00 | 4.41 | 0.88 |
| other: a word between two words | 13 | 555.63 ± 0.1% | 579.38 ± 0.4% | 914.76 ± 0.1% | 132.98 ± 0.9% | 506.60 ± 0.6% | 813.95 ± 1.0% | 14865.35 ± 0.4% | 555.26 ± 0.4% | 0.96 | 1.00 | 4.18 | 1.10 |
| other: a number before a unit, second text | 15 | 399.94 ± 0.6% | 437.85 ± 0.7% | 606.24 ± 0.7% | 39.40 ± 0.5% | 642.80 ± 1.3% | 891.50 ± 1.3% | 15298.96 ± 0.3% | 400.29 ± 0.6% | 0.91 | 1.00 | 10.15 | 0.62 |
| other: a heading's start tag | 13 | 359.86 ± 0.2% | 367.53 ± 0.4% | 480.85 ± 0.2% | 43.70 ± 0.7% | 636.03 ± 1.4% | 874.49 ± 0.5% | 18454.02 ± 0.3% | 359.29 ± 0.8% | 0.98 | 1.00 | 8.23 | 0.57 |
| other: a whole word | 11 | 585.15 ± 0.8% | 626.67 ± 0.1% | 1039.33 ± 0.3% | 117.34 ± 0.6% | 572.12 ± 0.8% | 837.29 ± 0.7% | 27289.29 ± 0.2% | 585.23 ± 1.2% | 0.93 | 1.00 | 4.99 | 1.02 |
| other: a line's first word, second text | 17 | 535.70 ± 0.5% | 559.86 ± 0.8% | 887.18 ± 0.5% | 128.28 ± 0.1% | 710.46 ± 2.3% | refused | refused | 534.48 ± 0.6% | 0.96 | 1.00 | 4.18 | 0.75 |
| other: fourteen octets before an x | 16 | 107.85 ± 0.2% | 154.11 ± 0.6% | 174.64 ± 0.6% | 14.96 ± 0.4% | 456.76 ± 1.4% | 411.80 ± 0.3% | 13001.91 ± 0.4% | 107.83 ± 0.2% | 0.70 | 1.00 | 7.21 | 0.24 |
| other: a Greek word | 8 | 462.08 ± 0.2% | 617.01 ± 0.3% | 1038.70 ± 0.1% | 58.92 ± 0.2% | 1404.81 ± 1.7% | 1795.62 ± 0.6% | refused | 461.84 ± 0.2% | 0.75 | 1.00 | 7.84 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15642.37 ± 1.0% | not timed | not timed | 16182.91 ± 0.4% | 2079.01 ± 21.7% | not timed | not timed | 15552.44 ± 1.3% | | 1.01 | 0.97 | 7.52 |
| 01-literal/sherlock-casei-en | 522 | 5160.88 ± 1.2% | not timed | not timed | 3560.16 ± 0.1% | 32.58 ± 0.4% | not timed | not timed | 5162.38 ± 0.4% | | 1.00 | 1.45 | 158.42 |
| 01-literal/sherlock-ru | 724 | 17142.05 ± 0.7% | not timed | not timed | 17295.07 ± 0.3% | 1354.30 ± 10.5% | not timed | not timed | 17084.91 ± 0.4% | | 1.00 | 0.99 | 12.66 |
| 01-literal/sherlock-casei-ru | 746 | 6186.64 ± 0.2% | not timed | not timed | 3287.00 ± 0.1% | 31.07 ± 0.3% | not timed | not timed | 6170.73 ± 0.2% | | 1.00 | 1.88 | 199.14 |
| 01-literal/sherlock-zh | 30 | 19376.62 ± 1.1% | not timed | not timed | 18307.93 ± 1.9% | 2664.34 ± 11.9% | not timed | not timed | 19371.99 ± 0.4% | | 1.00 | 1.06 | 7.27 |
| 02-literal-alternate/sherlock-en | 714 | 6039.70 ± 0.2% | not timed | not timed | 3937.51 ± 0.1% | 16.60 ± 0.1% | not timed | not timed | 6042.82 ± 0.3% | | 1.00 | 1.53 | 363.80 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1930.97 ± 1.7% | not timed | not timed | 689.78 ± 0.2% | 11.10 ± 12.4% | not timed | not timed | 1932.52 ± 1.5% | | 1.00 | 2.80 | 173.93 |
| 02-literal-alternate/sherlock-ru | 899 | 5571.41 ± 0.0% | not timed | not timed | 3247.55 ± 0.3% | 22.59 ± 0.1% | not timed | not timed | 5568.20 ± 0.1% | | 1.00 | 1.72 | 246.67 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.28 ± 0.6% | not timed | not timed | 1189.98 ± 0.4% | 9.06 ± 0.1% | not timed | not timed | 2053.02 ± 0.2% | | 1.00 | 1.73 | 226.92 |
| 02-literal-alternate/sherlock-zh | 207 | 7277.40 ± 0.5% | not timed | not timed | 4163.71 ± 0.2% | 31.46 ± 0.1% | not timed | not timed | 7278.29 ± 0.3% | | 1.00 | 1.75 | 231.30 |
| 03-date/ascii | 111817 | 123.64 ± 0.6% | not timed | not timed | 96.35 ± 0.1% | 0.21 ± 6.8% | not timed | not timed | 123.06 ± 0.9% | | 1.00 | 1.28 | 602.53 |
| 04-ruff-noqa/real | 84 | 402.23 ± 0.1% | not timed | not timed | 477.50 ± 0.1% | 19.74 ± 1.2% | not timed | not timed | 402.29 ± 0.1% | | 1.00 | 0.84 | 20.38 |
| 04-ruff-noqa/tweaked | 44 | 559.36 ± 0.1% | not timed | not timed | 465.23 ± 0.1% | 366.70 ± 0.2% | not timed | not timed | 559.76 ± 0.2% | | 1.00 | 1.20 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.2% | not timed | not timed | 5.23 ± 0.1% | 0.21 ± 3.0% | not timed | not timed | 5.33 ± 3.2% | | 1.00 | 1.02 | 25.94 |
| 06-cloud-flare-redos/original | 107 | 415.64 ± 0.1% | not timed | not timed | 217.21 ± 0.4% | 24.90 ± 6.5% | not timed | not timed | 415.33 ± 2.1% | | 1.00 | 1.91 | 16.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.29 ± 1.7% | not timed | not timed | 226.92 ± 0.4% | 26.66 ± 5.0% | not timed | not timed | 411.63 ± 12.2% | | 1.00 | 1.81 | 15.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.76 ± 0.2% | not timed | not timed | 254.63 ± 0.3% | 28.84 ± 0.0% | not timed | not timed | 583.42 ± 0.1% | | 1.00 | 2.29 | 20.24 |
| 07-unicode-character-data/parse-line | 558784 | 231.95 ± 0.3% | not timed | not timed | 180.42 ± 0.1% | 43.36 ± 0.4% | not timed | not timed | 232.01 ± 0.2% | | 1.00 | 1.29 | 5.35 |
| 08-words/all-english | 56691 | 116.56 ± 0.5% | not timed | not timed | 83.38 ± 0.1% | 13.01 ± 12.1% | not timed | not timed | 116.34 ± 0.2% | | 1.00 | 1.40 | 8.96 |
| 08-words/long-english | 839 | 614.11 ± 0.2% | not timed | not timed | 596.39 ± 0.1% | 32.62 ± 0.2% | not timed | not timed | 615.57 ± 0.5% | | 1.00 | 1.03 | 18.82 |
| 09-aws-keys/full | 0 | 407.70 ± 0.1% | not timed | not timed | 491.47 ± 0.1% | 64.48 ± 3.5% | not timed | not timed | 408.03 ± 0.1% | | 1.00 | 0.83 | 6.32 |
| 09-aws-keys/quick | 0 | 948.64 ± 0.2% | not timed | not timed | 1001.21 ± 0.2% | 420.57 ± 1.0% | not timed | not timed | 948.10 ± 0.1% | | 1.00 | 0.95 | 2.26 |
| 10-bounded-repeat/letters-en | 1833 | 577.45 ± 2.9% | not timed | not timed | 517.07 ± 0.3% | 19.60 ± 0.4% | not timed | not timed | 580.03 ± 1.3% | | 1.00 | 1.12 | 29.46 |
| 10-bounded-repeat/letters-ru | 3475 | 510.96 ± 0.6% | not timed | not timed | 478.90 ± 0.2% | 21.98 ± 8.0% | not timed | not timed | 507.85 ± 0.5% | | 1.01 | 1.07 | 23.24 |
| 10-bounded-repeat/context | 53 | 77.39 ± 0.3% | not timed | not timed | 66.15 ± 0.5% | 19.85 ± 0.3% | not timed | not timed | 77.08 ± 0.6% | | 1.00 | 1.17 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.89 ± 8.3% | not timed | not timed | 615.78 ± 0.3% | 36.48 ± 0.1% | not timed | not timed | 634.57 ± 8.5% | | 1.00 | 1.03 | 17.43 |
| 11-unstructured-to-json/extract | 600 | 79.62 ± 0.1% | not timed | not timed | 76.28 ± 0.4% | 48.89 ± 0.6% | not timed | not timed | 82.59 ± 0.6% | | 0.96 | 1.04 | 1.63 |
| 12-dictionary/single | 1 | 560.58 ± 0.1% | not timed | not timed | 555.76 ± 0.4% | 0.40 ± 0.1% | not timed | not timed | 560.35 ± 0.1% | | 1.00 | 1.01 | 1403.34 |
| 14-quadratic/1x | 100 | 21.35 ± 1.7% | not timed | not timed | 10.06 ± 0.3% | 0.98 ± 3.3% | not timed | not timed | 21.28 ± 1.4% | | 1.00 | 2.12 | 21.77 |
| 14-quadratic/2x | 200 | 17.53 ± 0.7% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.9% | not timed | not timed | 17.42 ± 0.8% | | 1.01 | 3.16 | 32.84 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.68 ± 0.3% | | 1.00 | 6.34 | 66.81 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 0.1% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 2.8% | not timed | not timed | 1.28 ± 1.8% | | 1.00 | 3.74 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 90.42 ± 0.1% | not timed | not timed | 13.79 ± 0.3% | 139.84 ± 1.8% | not timed | not timed | 89.85 ± 1.0% | | 1.01 | 6.55 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.94 ± 0.1% | not timed | not timed | 2.53 ± 0.5% | 6.42 ± 2.2% | not timed | not timed | 13.89 ± 1.7% | | 1.00 | 5.51 | 2.17 |
| 07-unicode-character-data/compile | 1 | 55.46 ± 0.2% | not timed | not timed | 26.06 ± 0.2% | 36.13 ± 2.4% | not timed | not timed | 55.27 ± 1.2% | | 1.00 | 2.13 | 1.53 |
| 09-aws-keys/compile-full | 1 | 41.82 ± 0.2% | not timed | not timed | 8.21 ± 0.3% | 23.32 ± 1.0% | not timed | not timed | 41.45 ± 2.2% | | 1.01 | 5.09 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 186.96 ± 0.4% | not timed | not timed | 47.27 ± 0.2% | 133.54 ± 1.8% | not timed | not timed | 185.04 ± 1.1% | | 1.01 | 3.95 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 13.68 ± 0.7% | not timed | not timed | 11.11 ± 0.1% | 16.06 ± 2.5% | not timed | not timed | 13.63 ± 1.5% | | 1.00 | 1.23 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 82.58 ± 0.4% | not timed | not timed | 8.07 ± 0.1% | 23.89 ± 2.4% | not timed | not timed | 82.58 ± 0.1% | | 1.00 | 10.23 | 3.46 |
| 11-unstructured-to-json/compile | 1 | 86.79 ± 0.2% | not timed | not timed | 41.13 ± 0.7% | 67.79 ± 2.0% | not timed | not timed | 86.39 ± 0.6% | | 1.00 | 2.11 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.0% | not timed | not timed | 0.07 ± 0.7% | 0.10 ± 13.4% | not timed | not timed | 0.35 ± 1.9% | | 1.00 | 5.11 | 3.65 |

