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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102081656 |
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
| literal: a word | 217 | 16133.85 ± 1.1% | 1042.64 ± 0.3% | 28.61 ± 0.1% | 18129.18 ± 1.7% | 9203.04 ± 7.3% | 17.53 ± 0.5% | 86.68 ± 0.3% | 16169.75 ± 1.1% | 15.47 | 1.00 | 0.89 | 1.75 |
| literal: a word that is not there | 0 | 18742.19 ± 1.4% | 1045.89 ± 0.1% | 28.53 ± 0.3% | 19685.03 ± 1.3% | 28857.90 ± 2.1% | 17.34 ± 0.1% | 81.54 ± 0.4% | 18760.90 ± 0.9% | 17.92 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6146.49 ± 0.5% | 1020.72 ± 0.5% | 14.55 ± 0.1% | 3943.59 ± 0.3% | 21.87 ± 0.2% | 5.29 ± 0.1% | 6.91 ± 0.3% | 6141.22 ± 0.2% | 6.02 | 1.00 | 1.56 | 281.03 |
| literal: a word in any case | 217 | 12540.85 ± 0.4% | 1040.87 ± 0.1% | 21.26 ± 2.1% | 3965.41 ± 0.2% | 37.99 ± 0.2% | refused | differs | 12529.47 ± 0.2% | 12.05 | 1.00 | 3.16 | 330.13 |
| literal: an href attribute | 33 | 13872.34 ± 1.1% | 1047.97 ± 0.4% | 27.14 ± 0.2% | 17082.34 ± 2.2% | 2269.40 ± 0.2% | 13.40 ± 0.3% | 75.48 ± 0.2% | 13909.19 ± 0.8% | 13.24 | 1.00 | 0.81 | 6.11 |
| literal: a word, second text | 123 | 16460.12 ± 1.2% | 1047.49 ± 0.3% | 27.90 ± 0.2% | 18336.98 ± 1.2% | 7638.33 ± 5.9% | 19.60 ± 0.3% | 69.77 ± 0.6% | 16469.67 ± 1.1% | 15.71 | 1.00 | 0.90 | 2.15 |
| class: two capitalized words | 1331 | 1104.69 ± 0.2% | 957.21 ± 0.1% | 25.91 ± 0.5% | 584.80 ± 0.1% | 40.73 ± 8.6% | 14.88 ± 0.4% | 68.88 ± 0.3% | 1103.16 ± 0.1% | 1.15 | 1.00 | 1.89 | 27.12 |
| class: a word that ends in ing | 3399 | 879.63 ± 0.0% | 881.42 ± 0.1% | 17.94 ± 0.1% | 547.10 ± 0.1% | 29.66 ± 6.5% | 8.19 ± 0.2% | 18.42 ± 1.0% | 879.14 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.66 |
| class: a word in capitals | 2332 | 1468.51 ± 0.5% | 945.90 ± 0.2% | 27.56 ± 0.2% | 572.34 ± 0.1% | 43.49 ± 6.7% | 17.14 ± 0.3% | 83.44 ± 0.3% | 1465.44 ± 0.2% | 1.55 | 1.00 | 2.57 | 33.77 |
| class: a number | 8288 | 2058.98 ± 0.3% | 793.21 ± 0.1% | 27.78 ± 0.2% | 1724.77 ± 0.1% | 40.35 ± 16.7% | 0.56 ± 0.2% | 56.65 ± 0.6% | 2052.61 ± 0.3% | 2.60 | 1.00 | 1.19 | 51.03 |
| class: two capitalized words, second text | 5359 | 689.48 ± 0.2% | 687.09 ± 0.1% | 23.15 ± 0.1% | 484.29 ± 0.1% | 34.18 ± 10.5% | 16.74 ± 0.3% | 64.00 ± 0.1% | 689.33 ± 0.1% | 1.00 | 1.00 | 1.42 | 20.17 |
| other: a word between two words | 6104 | 776.25 ± 0.2% | 744.22 ± 0.3% | 23.36 ± 0.4% | 732.12 ± 0.2% | 99.90 ± 15.5% | 11.24 ± 0.0% | 69.74 ± 1.0% | 774.75 ± 0.1% | 1.04 | 1.00 | 1.06 | 7.77 |
| other: a number before a unit, second text | 1481 | 5459.10 ± 0.4% | 978.72 ± 0.1% | 25.81 ± 0.1% | 5645.30 ± 0.7% | 40.79 ± 11.1% | 17.77 ± 0.7% | 66.80 ± 0.5% | 5444.43 ± 0.4% | 5.58 | 1.00 | 0.97 | 133.83 |
| other: a heading's start tag | 110 | 12731.70 ± 0.8% | 1031.54 ± 0.1% | 27.22 ± 0.2% | 1707.23 ± 0.3% | 1585.19 ± 6.0% | 16.31 ± 0.3% | 88.83 ± 0.3% | 12769.29 ± 0.6% | 12.34 | 1.00 | 7.46 | 8.03 |
| other: a whole word | 217 | 13876.35 ± 0.5% | 1040.82 ± 0.1% | 29.46 ± 0.4% | 14370.38 ± 1.2% | 49.36 ± 0.5% | 13.64 ± 0.2% | 55.88 ± 0.3% | 13939.81 ± 0.8% | 13.33 | 1.00 | 0.97 | 281.11 |
| other: a line's first word, second text | 3716 | 1951.58 ± 0.4% | 855.76 ± 0.3% | 31.10 ± 0.1% | 1724.11 ± 0.6% | 61.61 ± 6.6% | refused | refused | 1942.28 ± 0.5% | 2.28 | 1.00 | 1.13 | 31.68 |
| other: fourteen octets before an x | 87 | 19513.19 ± 1.1% | 246.50 ± 0.3% | 5.31 ± 0.1% | 4056.63 ± 0.9% | 10.65 ± 0.3% | differs | 17.74 ± 0.1% | 19573.88 ± 0.7% | 79.16 | 1.00 | 4.81 | 1832.83 |
| other: a Greek word | 21815 | 469.32 ± 0.3% | 316.37 ± 0.2% | 30.68 ± 0.1% | 289.31 ± 0.2% | 44.63 ± 8.5% | differs | refused | 467.89 ± 0.4% | 1.48 | 1.00 | 1.62 | 10.52 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.00 ± 0.2% | 25.98 ± 0.2% | 0.82 ± 0.2% | 19.74 ± 0.3% | 2.78 ± 0.3% | differs | 3.98 ± 0.2% | 25.96 ± 0.1% | 1.00 | 1.00 | 1.32 | 9.36 |
| a UUID | 32895 | 21.23 ± 0.2% | 21.34 ± 0.2% | 0.64 ± 0.1% | 15.16 ± 0.4% | 3.11 ± 0.6% | 0.72 ± 0.5% | 3.57 ± 0.7% | 21.32 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.84 |
| an IPv4 address | 33176 | 36.75 ± 0.2% | 36.73 ± 0.3% | 2.06 ± 0.5% | 28.91 ± 0.2% | 6.67 ± 0.2% | differs | 4.10 ± 0.2% | 36.81 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.51 |
| a date and time | 32954 | 31.14 ± 0.2% | 31.22 ± 0.1% | 1.44 ± 0.3% | 21.16 ± 0.2% | 7.05 ± 0.2% | 1.20 ± 0.3% | 7.06 ± 0.2% | 31.16 ± 0.1% | 1.00 | 1.00 | 1.47 | 4.42 |
| a field path | 32606 | 29.54 ± 0.2% | 29.44 ± 0.2% | 0.97 ± 0.1% | 22.98 ± 0.3% | 3.51 ± 0.5% | differs | 2.95 ± 0.1% | 29.49 ± 0.2% | 1.00 | 1.00 | 1.29 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.82 ± 0.3% | 8.87 ± 0.3% | 8.83 ± 0.3% | 11.50 ± 0.1% | 4.95 ± 1.3% | 0.91 ± 0.2% | none | 8.88 ± 0.3% | 1.00 | 0.99 | 0.77 | 1.78 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.37 ± 0.4% | 218.02 ± 0.3% | 252.62 ± 0.3% | 86.14 ± 0.5% | 222.25 ± 0.7% | 480.58 ± 1.4% | 3877.22 ± 1.8% | 217.48 ± 0.2% | 1.00 | 1.00 | 2.52 | 0.98 |
| a UUID | 62 | 142.58 ± 0.3% | 142.94 ± 0.3% | 157.55 ± 0.2% | 46.18 ± 0.6% | 99.35 ± 1.4% | 189.69 ± 3.2% | 4253.74 ± 0.3% | 142.60 ± 0.5% | 1.00 | 1.00 | 3.09 | 1.44 |
| an IPv4 address | 29 | 437.64 ± 0.2% | 441.60 ± 0.6% | 615.56 ± 0.7% | 76.21 ± 0.3% | 131.01 ± 2.8% | 302.68 ± 1.6% | 7622.43 ± 0.2% | 437.58 ± 0.4% | 0.99 | 1.00 | 5.74 | 3.34 |
| a date and time | 56 | 318.78 ± 0.2% | 320.04 ± 0.1% | 403.04 ± 0.3% | 72.34 ± 0.4% | 137.46 ± 2.1% | 325.02 ± 1.1% | 4884.86 ± 0.5% | 318.88 ± 0.3% | 1.00 | 1.00 | 4.41 | 2.32 |
| a field path | 39 | 202.72 ± 0.5% | 203.07 ± 0.1% | 233.35 ± 0.2% | 79.88 ± 1.1% | 205.81 ± 1.5% | 499.86 ± 2.9% | 4952.14 ± 0.8% | 202.60 ± 0.2% | 1.00 | 1.00 | 2.54 | 0.99 |
| literal: a word | 7 | 666.12 ± 0.5% | 721.17 ± 0.2% | 1293.55 ± 0.3% | 508.80 ± 0.2% | 638.24 ± 2.4% | 953.96 ± 0.6% | 31123.41 ± 0.7% | 664.97 ± 0.6% | 0.92 | 1.00 | 1.31 | 1.04 |
| literal: a word that is not there | 8 | 633.53 ± 0.4% | 689.77 ± 0.4% | 1213.30 ± 0.7% | 467.29 ± 0.1% | 613.54 ± 2.3% | 903.92 ± 0.7% | 29525.44 ± 0.1% | 633.23 ± 0.2% | 0.92 | 1.00 | 1.36 | 1.03 |
| literal: one of four words | 26 | 256.03 ± 0.5% | 421.28 ± 0.3% | 571.39 ± 0.7% | 49.82 ± 1.2% | 245.26 ± 1.3% | 372.69 ± 1.0% | 15800.83 ± 0.1% | 256.45 ± 0.1% | 0.61 | 1.00 | 5.14 | 1.04 |
| literal: a word in any case | 11 | 519.77 ± 0.2% | 558.62 ± 0.6% | 864.55 ± 0.1% | 15.87 ± 1.7% | 654.96 ± 2.4% | refused | 23713.80 ± 0.3% | 519.86 ± 0.3% | 0.93 | 1.00 | 32.76 | 0.79 |
| literal: an href attribute | 12 | 350.81 ± 0.5% | 361.73 ± 0.6% | 474.34 ± 0.8% | 43.27 ± 0.7% | 506.66 ± 1.2% | 771.45 ± 1.1% | 22294.96 ± 0.1% | 350.74 ± 0.3% | 0.97 | 1.00 | 8.11 | 0.69 |
| literal: a word, second text | 10 | 590.32 ± 0.2% | 653.37 ± 0.6% | 1096.43 ± 0.5% | 390.99 ± 0.2% | 540.89 ± 1.1% | 799.72 ± 0.9% | 27519.94 ± 0.2% | 590.94 ± 0.4% | 0.90 | 1.00 | 1.51 | 1.09 |
| class: two capitalized words | 23 | 458.84 ± 0.7% | 488.42 ± 0.5% | 710.98 ± 0.5% | 98.76 ± 0.1% | 508.78 ± 2.0% | 741.69 ± 0.5% | 6609.22 ± 0.3% | 458.90 ± 0.6% | 0.94 | 1.00 | 4.65 | 0.90 |
| class: a word that ends in ing | 9 | 597.08 ± 0.4% | 667.54 ± 0.3% | 1180.48 ± 0.3% | 130.46 ± 1.9% | 768.84 ± 0.9% | 1105.63 ± 0.5% | 16295.40 ± 0.1% | 597.06 ± 0.5% | 0.89 | 1.00 | 4.58 | 0.78 |
| class: a word in capitals | 16 | 520.91 ± 0.3% | 557.48 ± 0.3% | 884.71 ± 0.4% | 134.09 ± 0.4% | 762.93 ± 1.3% | 1020.63 ± 1.7% | 8721.65 ± 0.7% | 520.67 ± 0.5% | 0.93 | 1.00 | 3.88 | 0.68 |
| class: a number | 6 | 658.33 ± 0.3% | 721.82 ± 1.3% | 1341.39 ± 1.8% | 41.57 ± 0.7% | 1425.62 ± 1.2% | 1848.64 ± 1.5% | 23084.11 ± 0.5% | 658.97 ± 0.3% | 0.91 | 1.00 | 15.83 | 0.46 |
| class: two capitalized words, second text | 23 | 458.65 ± 0.3% | 489.24 ± 0.3% | 710.42 ± 0.5% | 100.10 ± 0.4% | 511.67 ± 1.0% | 760.62 ± 0.4% | 6616.33 ± 0.2% | 458.35 ± 0.3% | 0.94 | 1.00 | 4.58 | 0.90 |
| other: a word between two words | 13 | 581.28 ± 0.3% | 602.89 ± 0.6% | 965.14 ± 0.3% | 131.23 ± 0.7% | 508.47 ± 0.8% | 813.35 ± 0.4% | 15034.64 ± 0.4% | 581.53 ± 0.3% | 0.96 | 1.00 | 4.43 | 1.14 |
| other: a number before a unit, second text | 15 | 400.85 ± 0.4% | 435.17 ± 0.4% | 599.40 ± 0.4% | 39.25 ± 0.5% | 637.56 ± 1.1% | 887.67 ± 0.9% | 15320.57 ± 0.5% | 400.64 ± 0.3% | 0.92 | 1.00 | 10.21 | 0.63 |
| other: a heading's start tag | 13 | 362.12 ± 0.2% | 366.83 ± 0.1% | 478.61 ± 0.2% | 43.51 ± 0.3% | 633.50 ± 1.1% | 878.82 ± 0.6% | 18526.22 ± 0.4% | 361.42 ± 0.3% | 0.99 | 1.00 | 8.32 | 0.57 |
| other: a whole word | 11 | 615.54 ± 0.6% | 654.93 ± 1.1% | 1098.94 ± 0.5% | 116.24 ± 0.3% | 572.53 ± 1.3% | 836.87 ± 0.5% | 27200.63 ± 0.4% | 615.08 ± 0.1% | 0.94 | 1.00 | 5.30 | 1.08 |
| other: a line's first word, second text | 17 | 556.61 ± 0.2% | 576.68 ± 0.1% | 928.09 ± 0.2% | 126.96 ± 0.1% | 716.42 ± 0.6% | refused | refused | 555.13 ± 0.7% | 0.97 | 1.00 | 4.38 | 0.78 |
| other: fourteen octets before an x | 16 | 112.47 ± 0.8% | 161.60 ± 1.0% | 184.84 ± 1.0% | 15.07 ± 0.7% | 456.34 ± 1.3% | 412.50 ± 0.4% | 12716.01 ± 1.2% | 112.58 ± 0.8% | 0.70 | 1.00 | 7.46 | 0.25 |
| other: a Greek word | 8 | 451.32 ± 0.9% | 594.92 ± 0.9% | 973.05 ± 1.4% | 58.77 ± 0.3% | 1406.04 ± 0.5% | 1793.83 ± 0.3% | refused | 452.28 ± 0.3% | 0.76 | 1.00 | 7.68 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12943.35 ± 0.5% | not timed | not timed | 16365.51 ± 1.1% | 2103.65 ± 12.7% | not timed | not timed | 12948.42 ± 0.7% | | 1.00 | 0.79 | 6.15 |
| 01-literal/sherlock-casei-en | 522 | 3938.81 ± 0.5% | not timed | not timed | 3597.22 ± 0.3% | 32.45 ± 0.5% | not timed | not timed | 3933.06 ± 0.3% | | 1.00 | 1.09 | 121.40 |
| 01-literal/sherlock-ru | 724 | 13647.44 ± 0.2% | not timed | not timed | 17239.65 ± 0.3% | 1480.65 ± 5.1% | not timed | not timed | 13621.67 ± 0.5% | | 1.00 | 0.79 | 9.22 |
| 01-literal/sherlock-casei-ru | 746 | 5402.83 ± 0.1% | not timed | not timed | 3333.89 ± 0.1% | 30.69 ± 0.3% | not timed | not timed | 5401.43 ± 0.1% | | 1.00 | 1.62 | 176.06 |
| 01-literal/sherlock-zh | 30 | 17052.02 ± 0.2% | not timed | not timed | 18553.41 ± 1.1% | 2764.03 ± 13.5% | not timed | not timed | 17021.63 ± 0.3% | | 1.00 | 0.92 | 6.17 |
| 02-literal-alternate/sherlock-en | 714 | 5899.50 ± 0.5% | not timed | not timed | 3931.41 ± 0.3% | 16.64 ± 0.1% | not timed | not timed | 5909.83 ± 0.3% | | 1.00 | 1.50 | 354.64 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1704.79 ± 1.2% | not timed | not timed | 696.90 ± 0.4% | 11.05 ± 0.2% | not timed | not timed | 1696.83 ± 0.4% | | 1.00 | 2.45 | 154.28 |
| 02-literal-alternate/sherlock-ru | 899 | 4805.31 ± 0.2% | not timed | not timed | 3259.15 ± 0.1% | 22.67 ± 0.2% | not timed | not timed | 4802.97 ± 0.1% | | 1.00 | 1.47 | 212.00 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1820.81 ± 0.5% | not timed | not timed | 1233.62 ± 0.2% | 9.09 ± 5.2% | not timed | not timed | 1810.62 ± 0.5% | | 1.01 | 1.48 | 200.22 |
| 02-literal-alternate/sherlock-zh | 207 | 7109.61 ± 0.8% | not timed | not timed | 4162.30 ± 0.2% | 31.47 ± 0.2% | not timed | not timed | 7109.27 ± 0.4% | | 1.00 | 1.71 | 225.93 |
| 03-date/ascii | 111817 | 124.22 ± 0.6% | not timed | not timed | 96.36 ± 0.3% | 0.20 ± 0.9% | not timed | not timed | 123.70 ± 0.8% | | 1.00 | 1.29 | 613.09 |
| 04-ruff-noqa/real | 84 | 551.10 ± 0.1% | not timed | not timed | 461.15 ± 0.3% | 19.46 ± 1.2% | not timed | not timed | 552.52 ± 0.2% | | 1.00 | 1.20 | 28.32 |
| 04-ruff-noqa/tweaked | 44 | 553.73 ± 0.4% | not timed | not timed | 454.53 ± 0.1% | 365.75 ± 0.4% | not timed | not timed | 553.08 ± 0.3% | | 1.00 | 1.22 | 1.51 |
| 05-lexer-veryl/single | 124800 | 3.71 ± 0.1% | not timed | not timed | 4.97 ± 0.1% | 0.21 ± 3.0% | not timed | not timed | 3.74 ± 2.0% | | 0.99 | 0.75 | 18.07 |
| 06-cloud-flare-redos/original | 107 | 184.17 ± 0.6% | not timed | not timed | 215.07 ± 0.5% | 24.83 ± 0.2% | not timed | not timed | 183.57 ± 0.8% | | 1.00 | 0.86 | 7.42 |
| 06-cloud-flare-redos/simplified-short | 102 | 147.18 ± 0.2% | not timed | not timed | 228.33 ± 0.5% | 26.64 ± 0.1% | not timed | not timed | 146.98 ± 0.4% | | 1.00 | 0.64 | 5.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.85 ± 2.0% | not timed | not timed | 256.03 ± 0.2% | 28.88 ± 0.1% | not timed | not timed | 156.84 ± 1.9% | | 1.00 | 0.61 | 5.43 |
| 07-unicode-character-data/parse-line | 558784 | 40.00 ± 0.2% | not timed | not timed | 172.48 ± 0.1% | 42.73 ± 3.5% | not timed | not timed | 39.83 ± 0.1% | | 1.00 | 0.23 | 0.94 |
| 08-words/all-english | 56691 | 103.79 ± 0.3% | not timed | not timed | 82.83 ± 0.1% | 13.03 ± 12.6% | not timed | not timed | 103.22 ± 0.3% | | 1.01 | 1.25 | 7.97 |
| 08-words/long-english | 839 | 997.67 ± 0.2% | not timed | not timed | 597.69 ± 0.1% | 32.62 ± 0.5% | not timed | not timed | 997.71 ± 0.2% | | 1.00 | 1.67 | 30.58 |
| 09-aws-keys/full | 0 | 422.09 ± 0.1% | not timed | not timed | 466.32 ± 0.1% | 64.77 ± 3.6% | not timed | not timed | 422.28 ± 0.0% | | 1.00 | 0.91 | 6.52 |
| 09-aws-keys/quick | 0 | 398.86 ± 0.1% | not timed | not timed | 983.60 ± 0.5% | 419.45 ± 0.7% | not timed | not timed | 398.90 ± 0.1% | | 1.00 | 0.41 | 0.95 |
| 10-bounded-repeat/letters-en | 1833 | 592.32 ± 0.4% | not timed | not timed | 515.44 ± 0.4% | 19.58 ± 0.7% | not timed | not timed | 592.45 ± 0.2% | | 1.00 | 1.15 | 30.24 |
| 10-bounded-repeat/letters-ru | 3475 | 404.37 ± 0.3% | not timed | not timed | 478.50 ± 0.2% | 22.01 ± 9.1% | not timed | not timed | 402.79 ± 0.6% | | 1.00 | 0.85 | 18.37 |
| 10-bounded-repeat/context | 53 | 72.85 ± 1.0% | not timed | not timed | 65.80 ± 0.4% | 19.83 ± 0.2% | not timed | not timed | 72.75 ± 1.1% | | 1.00 | 1.11 | 3.67 |
| 10-bounded-repeat/capitals | 11 | 1039.85 ± 0.2% | not timed | not timed | 618.76 ± 0.0% | 35.65 ± 0.1% | not timed | not timed | 1039.54 ± 0.7% | | 1.00 | 1.68 | 29.17 |
| 11-unstructured-to-json/extract | 600 | 24.43 ± 0.2% | not timed | not timed | 77.18 ± 0.3% | 48.91 ± 0.4% | not timed | not timed | 24.23 ± 0.1% | | 1.01 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 603.63 ± 0.2% | not timed | not timed | 560.44 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 602.11 ± 0.8% | | 1.00 | 1.08 | 1477.01 |
| 14-quadratic/1x | 100 | 12.65 ± 0.2% | not timed | not timed | 10.02 ± 0.6% | 0.96 ± 2.9% | not timed | not timed | 12.53 ± 1.2% | | 1.01 | 1.26 | 13.14 |
| 14-quadratic/2x | 200 | 7.78 ± 0.5% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 1.8% | not timed | not timed | 7.72 ± 0.7% | | 1.01 | 1.40 | 14.65 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.8% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 1.83 ± 0.9% | | 1.00 | 1.51 | 15.84 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 0.8% | not timed | not timed | 0.34 ± 0.8% | 0.55 ± 3.3% | not timed | not timed | 1.52 ± 0.5% | | 1.01 | 4.44 | 2.77 |
| 04-ruff-noqa/compile-real | 1 | 84.51 ± 0.2% | not timed | not timed | 13.80 ± 0.5% | 140.88 ± 1.7% | not timed | not timed | 84.31 ± 0.9% | | 1.00 | 6.12 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 14.51 ± 1.7% | not timed | not timed | 2.53 ± 0.6% | 6.52 ± 1.9% | not timed | not timed | 14.33 ± 1.4% | | 1.01 | 5.74 | 2.23 |
| 07-unicode-character-data/compile | 1 | 54.94 ± 0.2% | not timed | not timed | 25.81 ± 0.2% | 36.16 ± 3.8% | not timed | not timed | 54.93 ± 0.4% | | 1.00 | 2.13 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.04 ± 0.3% | not timed | not timed | 8.31 ± 0.3% | 23.47 ± 2.0% | not timed | not timed | 41.97 ± 1.0% | | 1.00 | 5.06 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 189.16 ± 0.2% | not timed | not timed | 47.76 ± 0.5% | 134.70 ± 3.6% | not timed | not timed | 189.07 ± 0.7% | | 1.00 | 3.96 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.58 ± 0.8% | not timed | not timed | 11.16 ± 0.1% | 16.25 ± 1.7% | not timed | not timed | 14.42 ± 1.7% | | 1.01 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 84.84 ± 0.4% | not timed | not timed | 8.07 ± 0.2% | 24.15 ± 2.1% | not timed | not timed | 84.48 ± 0.6% | | 1.00 | 10.52 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 86.52 ± 0.4% | not timed | not timed | 40.49 ± 0.7% | 69.54 ± 2.3% | not timed | not timed | 86.17 ± 1.3% | | 1.00 | 2.14 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 0.6% | 0.09 ± 12.5% | not timed | not timed | 0.36 ± 0.8% | | 1.00 | 5.18 | 3.79 |

