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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243547755 |
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
| literal: a word | 217 | 19312.70 ± 1.2% | 4994.21 ± 0.2% | 28.20 ± 0.8% | 18125.92 ± 0.8% | 9008.45 ± 9.9% | 17.47 ± 0.2% | 84.13 ± 0.6% | 19407.65 ± 2.0% | 3.87 | 1.00 | 1.07 | 2.14 |
| literal: a word that is not there | 0 | 21119.84 ± 1.2% | 4872.06 ± 0.5% | 28.28 ± 0.5% | 19671.39 ± 2.5% | 28050.10 ± 4.0% | 17.28 ± 0.3% | 79.69 ± 0.6% | 21351.27 ± 1.1% | 4.33 | 0.99 | 1.07 | 0.75 |
| literal: one of four words | 661 | 6346.27 ± 3.0% | 1928.55 ± 0.6% | 14.37 ± 0.1% | 3942.78 ± 0.2% | 21.90 ± 0.1% | 5.25 ± 0.1% | 6.65 ± 0.6% | 6335.33 ± 0.9% | 3.29 | 1.00 | 1.61 | 289.74 |
| literal: a word in any case | 217 | 15104.85 ± 0.8% | 2070.48 ± 0.2% | 21.38 ± 0.7% | 3969.34 ± 0.5% | 38.03 ± 0.2% | refused | differs | 15078.36 ± 0.5% | 7.30 | 1.00 | 3.81 | 397.20 |
| literal: an href attribute | 33 | 16779.14 ± 1.1% | 608.10 ± 0.6% | 27.08 ± 0.3% | 17078.64 ± 0.8% | 2257.88 ± 0.3% | 13.24 ± 0.4% | 74.09 ± 0.3% | 16810.36 ± 0.6% | 27.59 | 1.00 | 0.98 | 7.43 |
| literal: a word, second text | 123 | 19691.68 ± 1.8% | 3349.24 ± 0.2% | 27.93 ± 0.3% | 18229.26 ± 1.5% | 7579.16 ± 9.4% | 19.59 ± 0.2% | 70.45 ± 0.7% | 19898.81 ± 1.7% | 5.88 | 0.99 | 1.08 | 2.60 |
| class: two capitalized words | 1331 | 1054.88 ± 0.3% | 598.25 ± 0.3% | 25.87 ± 0.4% | 585.67 ± 0.3% | 40.64 ± 8.9% | 14.79 ± 0.3% | 67.02 ± 2.4% | 1055.84 ± 0.2% | 1.76 | 1.00 | 1.80 | 25.96 |
| class: a word that ends in ing | 3399 | 572.90 ± 0.5% | 572.45 ± 0.4% | 17.89 ± 0.2% | 547.54 ± 0.1% | 29.63 ± 6.5% | 8.17 ± 0.3% | 18.21 ± 0.4% | 572.34 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.34 |
| class: a word in capitals | 2332 | 1368.24 ± 0.3% | 603.69 ± 0.1% | 27.49 ± 0.3% | 572.46 ± 0.2% | 43.55 ± 6.9% | 17.18 ± 0.5% | 82.32 ± 0.6% | 1367.86 ± 0.5% | 2.27 | 1.00 | 2.39 | 31.42 |
| class: a number | 8288 | 1958.52 ± 0.3% | 827.19 ± 0.1% | 27.86 ± 0.6% | 1715.40 ± 0.3% | 40.19 ± 15.9% | 0.56 ± 0.3% | 57.22 ± 0.8% | 1954.54 ± 0.5% | 2.37 | 1.00 | 1.14 | 48.73 |
| class: two capitalized words, second text | 5359 | 516.13 ± 0.3% | 523.59 ± 0.1% | 23.13 ± 0.3% | 485.02 ± 0.1% | 34.17 ± 10.4% | 16.66 ± 0.2% | 62.68 ± 0.6% | 515.69 ± 0.3% | 0.99 | 1.00 | 1.06 | 15.11 |
| other: a word between two words | 6104 | 794.92 ± 0.4% | 594.18 ± 0.3% | 23.37 ± 0.1% | 739.32 ± 0.1% | 108.45 ± 14.1% | 11.30 ± 0.1% | 68.20 ± 0.4% | 794.94 ± 0.4% | 1.34 | 1.00 | 1.08 | 7.33 |
| other: a number before a unit, second text | 1481 | 5963.91 ± 1.8% | 1120.30 ± 0.2% | 25.99 ± 0.1% | 5664.25 ± 0.4% | 40.77 ± 11.6% | 17.81 ± 0.2% | 65.64 ± 0.9% | 5942.10 ± 0.9% | 5.32 | 1.00 | 1.05 | 146.29 |
| other: a heading's start tag | 110 | 14065.03 ± 0.8% | 742.32 ± 0.2% | 27.43 ± 0.3% | 1719.40 ± 0.4% | 1584.03 ± 6.2% | 16.25 ± 0.3% | 86.04 ± 0.3% | 14049.51 ± 1.0% | 18.95 | 1.00 | 8.18 | 8.88 |
| other: a whole word | 217 | 15857.25 ± 1.2% | 602.50 ± 0.3% | 29.06 ± 0.4% | 14646.59 ± 0.4% | 49.48 ± 0.1% | 13.62 ± 0.1% | 54.92 ± 0.9% | 15834.83 ± 0.5% | 26.32 | 1.00 | 1.08 | 320.45 |
| other: a line's first word, second text | 3716 | 2034.19 ± 3.1% | 585.36 ± 0.9% | 30.54 ± 0.4% | 1715.83 ± 0.4% | 61.68 ± 6.8% | refused | refused | 2029.62 ± 0.2% | 3.48 | 1.00 | 1.19 | 32.98 |
| other: fourteen octets before an x | 87 | 23821.74 ± 0.8% | 248.81 ± 0.7% | 6.53 ± 0.1% | 3960.31 ± 0.7% | 10.66 ± 0.1% | differs | 17.69 ± 0.2% | 23670.46 ± 0.9% | 95.74 | 1.01 | 6.02 | 2234.20 |
| other: a Greek word | 21815 | 485.67 ± 0.7% | 408.89 ± 0.1% | 30.79 ± 0.2% | 289.16 ± 0.3% | 44.49 ± 10.8% | differs | refused | 482.24 ± 0.7% | 1.19 | 1.01 | 1.68 | 10.92 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.41 ± 0.1% | 18.47 ± 0.4% | 0.86 ± 0.5% | 19.79 ± 0.5% | 2.78 ± 1.0% | differs | 3.99 ± 0.1% | 18.47 ± 0.4% | 1.00 | 1.00 | 0.93 | 6.62 |
| a UUID | 32895 | 20.13 ± 0.2% | 20.09 ± 0.1% | 0.64 ± 0.4% | 15.13 ± 0.5% | 3.10 ± 0.2% | 0.72 ± 0.3% | 3.62 ± 0.7% | 19.86 ± 0.2% | 1.00 | 1.01 | 1.33 | 6.50 |
| an IPv4 address | 33176 | 33.68 ± 0.3% | 33.63 ± 0.4% | 2.06 ± 0.6% | 28.93 ± 0.4% | 6.63 ± 0.1% | differs | 4.15 ± 0.2% | 33.64 ± 0.2% | 1.00 | 1.00 | 1.16 | 5.08 |
| a date and time | 32954 | 28.87 ± 0.1% | 28.81 ± 0.4% | 1.43 ± 0.3% | 21.11 ± 0.4% | 7.05 ± 0.2% | 1.20 ± 0.3% | 7.13 ± 0.4% | 28.79 ± 0.2% | 1.00 | 1.00 | 1.37 | 4.10 |
| a field path | 32606 | 21.78 ± 0.3% | 21.72 ± 0.2% | 1.02 ± 0.3% | 23.02 ± 0.3% | 3.50 ± 0.6% | differs | 2.93 ± 0.1% | 21.72 ± 0.1% | 1.00 | 1.00 | 0.95 | 6.22 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.1% | 11.11 ± 0.2% | 11.13 ± 0.2% | 11.45 ± 0.1% | 4.96 ± 1.1% | 0.91 ± 0.6% | none | 11.11 ± 0.2% | 1.00 | 1.00 | 0.97 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.73 ± 0.6% | 231.88 ± 0.4% | 276.70 ± 0.4% | 86.36 ± 0.8% | 223.39 ± 0.9% | 485.96 ± 1.4% | 3799.16 ± 3.0% | 229.79 ± 0.9% | 1.00 | 1.00 | 2.67 | 1.03 |
| a UUID | 62 | 149.41 ± 0.3% | 149.51 ± 0.3% | 167.61 ± 0.3% | 46.19 ± 0.6% | 99.39 ± 0.9% | 188.81 ± 3.4% | 4269.19 ± 0.8% | 148.95 ± 0.7% | 1.00 | 1.00 | 3.24 | 1.50 |
| an IPv4 address | 29 | 417.42 ± 0.3% | 420.68 ± 0.4% | 594.65 ± 0.1% | 76.45 ± 0.2% | 132.20 ± 0.9% | 299.58 ± 1.8% | 7589.06 ± 0.4% | 417.04 ± 0.6% | 0.99 | 1.00 | 5.46 | 3.16 |
| a date and time | 56 | 297.05 ± 0.5% | 298.17 ± 0.3% | 373.53 ± 0.2% | 72.34 ± 0.0% | 137.36 ± 1.0% | 329.09 ± 0.9% | 4927.54 ± 0.5% | 297.11 ± 0.3% | 1.00 | 1.00 | 4.11 | 2.16 |
| a field path | 39 | 223.88 ± 1.0% | 224.49 ± 1.1% | 264.70 ± 0.3% | 80.43 ± 0.8% | 205.84 ± 1.4% | 506.69 ± 5.2% | 4848.80 ± 3.1% | 223.73 ± 1.0% | 1.00 | 1.00 | 2.78 | 1.09 |
| literal: a word | 7 | 618.00 ± 0.8% | 670.43 ± 0.5% | 1195.57 ± 0.7% | 506.35 ± 0.1% | 633.20 ± 2.1% | 962.96 ± 0.7% | 30429.72 ± 0.1% | 616.84 ± 0.7% | 0.92 | 1.00 | 1.22 | 0.98 |
| literal: a word that is not there | 8 | 595.53 ± 0.2% | 648.38 ± 0.1% | 1134.66 ± 0.2% | 456.67 ± 0.5% | 605.03 ± 1.6% | 912.65 ± 0.5% | 29185.14 ± 0.1% | 595.18 ± 0.3% | 0.92 | 1.00 | 1.30 | 0.98 |
| literal: one of four words | 26 | 239.45 ± 0.5% | 396.72 ± 1.0% | 541.79 ± 0.5% | 50.43 ± 0.8% | 243.86 ± 1.6% | 386.10 ± 1.4% | 15908.53 ± 0.1% | 239.73 ± 0.4% | 0.60 | 1.00 | 4.75 | 0.98 |
| literal: a word in any case | 11 | 442.99 ± 0.5% | 473.97 ± 0.3% | 695.51 ± 0.5% | 15.76 ± 1.4% | 666.30 ± 2.7% | refused | 23749.61 ± 0.3% | 442.36 ± 0.4% | 0.93 | 1.00 | 28.11 | 0.66 |
| literal: an href attribute | 12 | 339.52 ± 0.3% | 352.32 ± 0.5% | 464.76 ± 0.4% | 44.55 ± 0.4% | 505.00 ± 1.2% | 782.45 ± 0.9% | 21475.07 ± 0.1% | 339.37 ± 0.7% | 0.96 | 1.00 | 7.62 | 0.67 |
| literal: a word, second text | 10 | 555.18 ± 0.4% | 614.19 ± 0.2% | 1032.19 ± 0.3% | 389.43 ± 0.1% | 542.79 ± 1.1% | 813.44 ± 0.4% | 27096.24 ± 0.1% | 555.31 ± 0.1% | 0.90 | 1.00 | 1.43 | 1.02 |
| class: two capitalized words | 23 | 430.98 ± 0.4% | 459.63 ± 0.3% | 668.99 ± 0.4% | 99.62 ± 0.3% | 496.69 ± 5.3% | 753.52 ± 0.5% | 6456.99 ± 1.9% | 431.48 ± 0.5% | 0.94 | 1.00 | 4.33 | 0.87 |
| class: a word that ends in ing | 9 | 558.41 ± 0.4% | 624.79 ± 0.4% | 1095.31 ± 0.1% | 130.23 ± 1.2% | 762.80 ± 1.0% | 1119.34 ± 0.8% | 15839.55 ± 0.3% | 557.02 ± 0.1% | 0.89 | 1.00 | 4.29 | 0.73 |
| class: a word in capitals | 16 | 492.49 ± 0.7% | 534.56 ± 0.6% | 862.92 ± 0.2% | 135.08 ± 1.1% | 754.09 ± 1.3% | 1041.93 ± 1.8% | 8544.78 ± 0.4% | 493.45 ± 0.6% | 0.92 | 1.00 | 3.65 | 0.65 |
| class: a number | 6 | 624.01 ± 0.3% | 688.88 ± 0.8% | 1309.21 ± 0.1% | 41.44 ± 0.9% | 1394.75 ± 1.6% | 1873.75 ± 1.0% | 22704.72 ± 0.1% | 624.73 ± 0.4% | 0.91 | 1.00 | 15.06 | 0.45 |
| class: two capitalized words, second text | 23 | 430.30 ± 0.8% | 458.95 ± 0.4% | 668.71 ± 0.3% | 101.11 ± 0.6% | 497.87 ± 1.3% | 768.45 ± 1.6% | 6469.21 ± 0.2% | 430.85 ± 0.5% | 0.94 | 1.00 | 4.26 | 0.86 |
| other: a word between two words | 13 | 534.44 ± 0.4% | 554.05 ± 0.6% | 892.06 ± 0.4% | 132.80 ± 0.6% | 506.96 ± 1.5% | 814.45 ± 0.4% | 14767.77 ± 0.1% | 535.15 ± 0.8% | 0.96 | 1.00 | 4.02 | 1.05 |
| other: a number before a unit, second text | 15 | 395.76 ± 0.9% | 432.32 ± 0.8% | 612.20 ± 0.7% | 39.05 ± 0.3% | 634.45 ± 0.6% | 904.94 ± 0.8% | 15085.08 ± 0.2% | 395.27 ± 0.5% | 0.92 | 1.00 | 10.13 | 0.62 |
| other: a heading's start tag | 13 | 349.31 ± 0.4% | 356.87 ± 0.4% | 473.14 ± 0.4% | 43.73 ± 0.5% | 629.11 ± 0.8% | 864.94 ± 0.5% | 17887.40 ± 0.3% | 348.48 ± 0.4% | 0.98 | 1.00 | 7.99 | 0.56 |
| other: a whole word | 11 | 576.21 ± 0.4% | 614.94 ± 0.5% | 1032.19 ± 0.6% | 117.14 ± 0.3% | 566.77 ± 2.0% | 831.36 ± 0.5% | 26918.95 ± 0.2% | 575.74 ± 0.4% | 0.94 | 1.00 | 4.92 | 1.02 |
| other: a line's first word, second text | 17 | 528.12 ± 0.3% | 552.55 ± 0.4% | 886.14 ± 0.2% | 129.48 ± 0.4% | 707.84 ± 0.8% | refused | refused | 526.46 ± 0.3% | 0.96 | 1.00 | 4.08 | 0.75 |
| other: fourteen octets before an x | 16 | 107.24 ± 0.5% | 153.16 ± 0.4% | 176.20 ± 0.3% | 15.00 ± 0.6% | 455.64 ± 1.2% | 416.91 ± 1.3% | 12756.07 ± 0.3% | 107.19 ± 0.3% | 0.70 | 1.00 | 7.15 | 0.24 |
| other: a Greek word | 8 | 429.32 ± 0.3% | 589.59 ± 0.7% | 1014.04 ± 0.3% | 58.87 ± 0.9% | 1394.50 ± 1.2% | 1811.17 ± 0.8% | refused | 429.22 ± 0.6% | 0.73 | 1.00 | 7.29 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15573.26 ± 0.6% | not timed | not timed | 16085.91 ± 0.9% | 2059.44 ± 16.7% | not timed | not timed | 15625.02 ± 0.7% | | 1.00 | 0.97 | 7.56 |
| 01-literal/sherlock-casei-en | 522 | 5151.41 ± 1.0% | not timed | not timed | 3590.06 ± 0.3% | 32.57 ± 0.2% | not timed | not timed | 5111.41 ± 0.8% | | 1.01 | 1.43 | 158.17 |
| 01-literal/sherlock-ru | 724 | 17128.03 ± 0.3% | not timed | not timed | 17314.42 ± 0.6% | 1334.24 ± 17.0% | not timed | not timed | 17106.32 ± 0.2% | | 1.00 | 0.99 | 12.84 |
| 01-literal/sherlock-casei-ru | 746 | 6181.67 ± 0.3% | not timed | not timed | 3322.34 ± 0.3% | 30.79 ± 0.4% | not timed | not timed | 6183.63 ± 0.2% | | 1.00 | 1.86 | 200.74 |
| 01-literal/sherlock-zh | 30 | 19973.30 ± 0.5% | not timed | not timed | 18778.70 ± 1.3% | 2640.32 ± 15.8% | not timed | not timed | 19822.87 ± 0.5% | | 1.01 | 1.06 | 7.56 |
| 02-literal-alternate/sherlock-en | 714 | 6049.52 ± 0.3% | not timed | not timed | 3937.52 ± 0.1% | 16.62 ± 0.0% | not timed | not timed | 6039.57 ± 0.3% | | 1.00 | 1.54 | 364.07 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1934.87 ± 1.4% | not timed | not timed | 697.36 ± 0.3% | 11.12 ± 0.1% | not timed | not timed | 1927.45 ± 0.4% | | 1.00 | 2.77 | 173.97 |
| 02-literal-alternate/sherlock-ru | 899 | 5569.11 ± 0.2% | not timed | not timed | 3257.07 ± 0.8% | 22.59 ± 0.2% | not timed | not timed | 5568.46 ± 0.2% | | 1.00 | 1.71 | 246.51 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.87 ± 0.5% | not timed | not timed | 1230.31 ± 0.2% | 9.07 ± 0.8% | not timed | not timed | 2051.29 ± 0.2% | | 1.00 | 1.67 | 226.88 |
| 02-literal-alternate/sherlock-zh | 207 | 7304.68 ± 0.2% | not timed | not timed | 4165.49 ± 0.0% | 31.44 ± 0.2% | not timed | not timed | 7294.39 ± 0.4% | | 1.00 | 1.75 | 232.33 |
| 03-date/ascii | 111817 | 124.09 ± 0.4% | not timed | not timed | 96.02 ± 0.1% | 0.20 ± 2.5% | not timed | not timed | 123.50 ± 0.3% | | 1.00 | 1.29 | 614.54 |
| 04-ruff-noqa/real | 84 | 403.08 ± 0.1% | not timed | not timed | 457.38 ± 0.2% | 19.59 ± 1.2% | not timed | not timed | 403.16 ± 0.1% | | 1.00 | 0.88 | 20.58 |
| 04-ruff-noqa/tweaked | 44 | 561.56 ± 0.2% | not timed | not timed | 459.01 ± 0.1% | 367.71 ± 0.6% | not timed | not timed | 561.65 ± 0.1% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.23 ± 0.3% | not timed | not timed | 5.03 ± 0.4% | 0.20 ± 6.2% | not timed | not timed | 5.06 ± 3.2% | | 1.03 | 1.04 | 25.74 |
| 06-cloud-flare-redos/original | 107 | 415.96 ± 0.4% | not timed | not timed | 214.87 ± 0.1% | 24.92 ± 0.4% | not timed | not timed | 415.46 ± 0.2% | | 1.00 | 1.94 | 16.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.79 ± 0.1% | not timed | not timed | 226.67 ± 0.0% | 26.80 ± 0.1% | not timed | not timed | 411.36 ± 0.2% | | 1.00 | 1.82 | 15.37 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.58 ± 0.6% | not timed | not timed | 255.62 ± 0.1% | 28.87 ± 0.1% | not timed | not timed | 583.44 ± 0.5% | | 1.00 | 2.28 | 20.22 |
| 07-unicode-character-data/parse-line | 558784 | 235.59 ± 1.8% | not timed | not timed | 172.88 ± 0.3% | 42.84 ± 6.0% | not timed | not timed | 236.02 ± 2.1% | | 1.00 | 1.36 | 5.50 |
| 08-words/all-english | 56691 | 116.98 ± 0.7% | not timed | not timed | 83.20 ± 0.3% | 12.03 ± 12.5% | not timed | not timed | 116.09 ± 0.3% | | 1.01 | 1.41 | 9.72 |
| 08-words/long-english | 839 | 614.26 ± 0.5% | not timed | not timed | 597.73 ± 0.1% | 32.41 ± 0.7% | not timed | not timed | 614.43 ± 1.3% | | 1.00 | 1.03 | 18.95 |
| 09-aws-keys/full | 0 | 409.33 ± 0.2% | not timed | not timed | 465.27 ± 0.2% | 64.56 ± 0.0% | not timed | not timed | 409.65 ± 0.0% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 946.59 ± 0.4% | not timed | not timed | 989.08 ± 0.1% | 420.60 ± 1.9% | not timed | not timed | 946.35 ± 0.1% | | 1.00 | 0.96 | 2.25 |
| 10-bounded-repeat/letters-en | 1833 | 545.77 ± 0.9% | not timed | not timed | 517.36 ± 0.3% | 19.54 ± 0.3% | not timed | not timed | 579.33 ± 1.0% | | 0.94 | 1.05 | 27.93 |
| 10-bounded-repeat/letters-ru | 3475 | 508.64 ± 1.0% | not timed | not timed | 478.33 ± 0.3% | 22.68 ± 7.6% | not timed | not timed | 505.03 ± 2.4% | | 1.01 | 1.06 | 22.43 |
| 10-bounded-repeat/context | 53 | 77.28 ± 0.5% | not timed | not timed | 66.01 ± 0.6% | 19.78 ± 0.3% | not timed | not timed | 77.36 ± 0.4% | | 1.00 | 1.17 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 634.80 ± 8.3% | not timed | not timed | 615.76 ± 0.0% | 36.57 ± 0.2% | not timed | not timed | 634.01 ± 8.5% | | 1.00 | 1.03 | 17.36 |
| 11-unstructured-to-json/extract | 600 | 82.78 ± 0.1% | not timed | not timed | 77.57 ± 0.2% | 48.72 ± 0.4% | not timed | not timed | 82.66 ± 0.1% | | 1.00 | 1.07 | 1.70 |
| 12-dictionary/single | 1 | 559.85 ± 0.3% | not timed | not timed | 559.13 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 560.46 ± 0.2% | | 1.00 | 1.00 | 1383.26 |
| 14-quadratic/1x | 100 | 21.17 ± 0.8% | not timed | not timed | 10.03 ± 0.4% | 0.96 ± 2.6% | not timed | not timed | 21.21 ± 1.7% | | 1.00 | 2.11 | 22.00 |
| 14-quadratic/2x | 200 | 17.51 ± 0.4% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 1.5% | not timed | not timed | 17.48 ± 0.6% | | 1.00 | 3.16 | 32.97 |
| 14-quadratic/10x | 1000 | 7.64 ± 0.4% | not timed | not timed | 1.20 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.63 ± 0.3% | | 1.00 | 6.38 | 66.18 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.2% | not timed | not timed | 0.34 ± 1.0% | 0.55 ± 9.2% | not timed | not timed | 1.25 ± 1.3% | | 1.00 | 3.65 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 91.43 ± 0.1% | not timed | not timed | 13.79 ± 0.4% | 141.47 ± 1.3% | not timed | not timed | 90.87 ± 1.3% | | 1.01 | 6.63 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.78 ± 0.2% | not timed | not timed | 2.53 ± 0.9% | 6.50 ± 2.2% | not timed | not timed | 13.68 ± 1.5% | | 1.01 | 5.44 | 2.12 |
| 07-unicode-character-data/compile | 1 | 55.01 ± 0.4% | not timed | not timed | 25.68 ± 0.3% | 36.29 ± 4.5% | not timed | not timed | 54.60 ± 1.1% | | 1.01 | 2.14 | 1.52 |
| 09-aws-keys/compile-full | 1 | 41.53 ± 0.6% | not timed | not timed | 8.28 ± 3.8% | 23.42 ± 0.4% | not timed | not timed | 41.12 ± 0.4% | | 1.01 | 5.01 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 182.43 ± 0.3% | not timed | not timed | 47.16 ± 0.2% | 134.98 ± 2.1% | not timed | not timed | 181.73 ± 1.0% | | 1.00 | 3.87 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 13.57 ± 0.5% | not timed | not timed | 11.20 ± 0.3% | 16.23 ± 3.7% | not timed | not timed | 13.53 ± 2.0% | | 1.00 | 1.21 | 0.84 |
| 10-bounded-repeat/compile-capitals | 1 | 81.12 ± 0.2% | not timed | not timed | 8.09 ± 0.2% | 24.14 ± 1.3% | not timed | not timed | 81.13 ± 2.1% | | 1.00 | 10.03 | 3.36 |
| 11-unstructured-to-json/compile | 1 | 85.80 ± 0.3% | not timed | not timed | 40.72 ± 0.3% | 68.24 ± 4.0% | not timed | not timed | 85.09 ± 1.0% | | 1.01 | 2.11 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 1.2% | 0.09 ± 13.9% | not timed | not timed | 0.35 ± 2.0% | | 1.00 | 5.10 | 3.81 |

