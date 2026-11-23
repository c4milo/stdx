# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148127709 |
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
| literal: a word | 217 | 15966.81 ± 1.0% | 1040.16 ± 0.2% | 28.59 ± 0.2% | 18040.00 ± 2.9% | 9091.10 ± 8.2% | 17.54 ± 0.3% | 86.86 ± 0.2% | 15952.54 ± 1.0% | 15.35 | 1.00 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18331.16 ± 1.6% | 1048.37 ± 0.1% | 28.63 ± 0.4% | 19327.75 ± 2.3% | 27652.21 ± 3.5% | 17.34 ± 0.2% | 82.70 ± 0.2% | 18452.11 ± 2.0% | 17.49 | 0.99 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6053.86 ± 0.5% | 1023.81 ± 0.0% | 14.36 ± 0.3% | 3949.30 ± 0.2% | 21.86 ± 0.1% | 5.29 ± 0.2% | 6.93 ± 0.3% | 6014.68 ± 0.4% | 5.91 | 1.01 | 1.53 | 276.90 |
| literal: a word in any case | 217 | 12616.35 ± 0.8% | 1040.95 ± 0.1% | 21.52 ± 2.3% | 3963.14 ± 0.4% | 37.96 ± 0.6% | refused | differs | 12601.20 ± 0.3% | 12.12 | 1.00 | 3.18 | 332.37 |
| literal: an href attribute | 33 | 13691.32 ± 2.0% | 1047.74 ± 0.2% | 27.33 ± 0.2% | 16953.24 ± 2.9% | 2268.26 ± 0.6% | 13.39 ± 0.2% | 75.68 ± 0.3% | 13747.04 ± 2.3% | 13.07 | 1.00 | 0.81 | 6.04 |
| literal: a word, second text | 123 | 16246.49 ± 1.0% | 1044.84 ± 0.2% | 28.32 ± 0.2% | 18069.79 ± 1.9% | 7575.92 ± 6.5% | 19.73 ± 1.3% | 69.70 ± 0.9% | 16412.03 ± 1.8% | 15.55 | 0.99 | 0.90 | 2.14 |
| class: two capitalized words | 1331 | 1105.34 ± 0.4% | 978.30 ± 0.1% | 26.18 ± 0.1% | 585.25 ± 0.1% | 40.54 ± 2.7% | 14.90 ± 0.3% | 68.84 ± 0.4% | 1103.82 ± 0.5% | 1.13 | 1.00 | 1.89 | 27.27 |
| class: a word that ends in ing | 3399 | 895.67 ± 0.1% | 895.43 ± 0.1% | 18.06 ± 0.3% | 548.21 ± 0.3% | 29.55 ± 2.5% | 8.22 ± 0.1% | 18.43 ± 0.4% | 894.75 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.31 |
| class: a word in capitals | 2332 | 1455.31 ± 0.7% | 950.39 ± 0.1% | 27.93 ± 0.2% | 572.61 ± 0.0% | 43.45 ± 9.5% | 17.19 ± 0.3% | 83.17 ± 0.5% | 1455.46 ± 0.4% | 1.53 | 1.00 | 2.54 | 33.49 |
| class: a number | 8288 | 1993.36 ± 0.2% | 836.75 ± 0.1% | 28.09 ± 0.2% | 1724.09 ± 0.2% | 39.92 ± 14.6% | 0.56 ± 0.2% | 56.67 ± 0.5% | 1991.53 ± 0.0% | 2.38 | 1.00 | 1.16 | 49.93 |
| class: two capitalized words, second text | 5359 | 744.07 ± 0.2% | 744.44 ± 0.1% | 23.42 ± 0.2% | 483.88 ± 0.1% | 34.04 ± 9.7% | 16.77 ± 0.1% | 63.87 ± 0.4% | 742.84 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.86 |
| other: a word between two words | 6104 | 748.05 ± 0.2% | 765.04 ± 0.0% | 23.60 ± 0.2% | 738.18 ± 0.1% | 109.61 ± 13.6% | 11.30 ± 0.2% | 69.87 ± 0.2% | 748.44 ± 0.1% | 0.98 | 1.00 | 1.01 | 6.82 |
| other: a number before a unit, second text | 1481 | 5452.36 ± 0.5% | 985.42 ± 0.1% | 26.05 ± 0.1% | 5642.32 ± 0.7% | 40.76 ± 11.2% | 17.83 ± 0.1% | 66.99 ± 0.4% | 5442.45 ± 0.3% | 5.53 | 1.00 | 0.97 | 133.76 |
| other: a heading's start tag | 110 | 12544.09 ± 0.9% | 1036.69 ± 0.2% | 27.59 ± 0.3% | 1716.20 ± 0.2% | 1586.67 ± 6.3% | 16.24 ± 0.2% | 89.10 ± 0.4% | 12586.63 ± 1.5% | 12.10 | 1.00 | 7.31 | 7.91 |
| other: a whole word | 217 | 13924.10 ± 1.1% | 1038.75 ± 0.1% | 29.73 ± 0.3% | 14333.12 ± 2.0% | 49.43 ± 0.2% | 13.67 ± 0.1% | 55.95 ± 0.1% | 13952.15 ± 1.3% | 13.40 | 1.00 | 0.97 | 281.69 |
| other: a line's first word, second text | 3716 | 1979.83 ± 0.4% | 877.30 ± 0.2% | 31.09 ± 0.1% | 1725.95 ± 0.4% | 61.64 ± 6.9% | refused | refused | 1969.14 ± 0.7% | 2.26 | 1.01 | 1.15 | 32.12 |
| other: fourteen octets before an x | 87 | 19645.03 ± 1.3% | 229.96 ± 0.2% | 6.59 ± 0.1% | 4017.91 ± 0.4% | 10.65 ± 0.1% | differs | 17.73 ± 0.2% | 19793.20 ± 0.9% | 85.43 | 0.99 | 4.89 | 1844.80 |
| other: a Greek word | 21815 | 514.56 ± 0.7% | 413.34 ± 0.2% | 31.22 ± 0.2% | 289.14 ± 0.2% | 44.61 ± 9.5% | differs | refused | 514.22 ± 0.4% | 1.24 | 1.00 | 1.78 | 11.54 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.82 ± 0.1% | 25.78 ± 0.1% | 0.87 ± 0.3% | 19.74 ± 0.5% | 2.77 ± 0.7% | differs | 4.00 ± 0.2% | 25.83 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.31 |
| a UUID | 32895 | 21.02 ± 0.2% | 21.14 ± 0.1% | 0.65 ± 0.2% | 15.10 ± 0.6% | 3.09 ± 0.8% | 0.73 ± 0.2% | 3.59 ± 0.4% | 21.15 ± 0.2% | 0.99 | 0.99 | 1.39 | 6.81 |
| an IPv4 address | 33176 | 36.86 ± 0.3% | 36.80 ± 0.3% | 2.10 ± 0.3% | 29.11 ± 0.4% | 6.66 ± 0.3% | differs | 4.17 ± 0.1% | 36.87 ± 0.0% | 1.00 | 1.00 | 1.27 | 5.53 |
| a date and time | 32954 | 31.16 ± 0.1% | 31.20 ± 0.2% | 1.47 ± 0.4% | 21.40 ± 0.7% | 7.04 ± 0.1% | 1.19 ± 0.3% | 7.12 ± 1.1% | 31.15 ± 0.3% | 1.00 | 1.00 | 1.46 | 4.43 |
| a field path | 32606 | 29.44 ± 0.2% | 29.35 ± 0.3% | 1.03 ± 0.1% | 23.10 ± 0.5% | 3.50 ± 0.3% | differs | 2.91 ± 0.3% | 29.40 ± 0.1% | 1.00 | 1.00 | 1.27 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.46 ± 0.1% | 11.41 ± 0.3% | 11.43 ± 0.4% | 11.39 ± 0.2% | 4.98 ± 1.6% | 0.91 ± 0.5% | none | 11.49 ± 0.3% | 1.00 | 1.00 | 1.01 | 2.30 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.27 ± 0.3% | 217.14 ± 0.4% | 251.51 ± 0.4% | 86.94 ± 0.7% | 221.87 ± 0.5% | 481.60 ± 0.5% | 3888.68 ± 1.3% | 216.16 ± 0.3% | 1.00 | 1.00 | 2.49 | 0.97 |
| a UUID | 62 | 142.08 ± 0.2% | 142.52 ± 0.1% | 156.91 ± 0.3% | 45.52 ± 1.0% | 100.08 ± 1.0% | 185.83 ± 1.7% | 4428.51 ± 2.2% | 142.07 ± 0.2% | 1.00 | 1.00 | 3.12 | 1.42 |
| an IPv4 address | 29 | 436.41 ± 0.4% | 439.83 ± 0.5% | 610.80 ± 0.4% | 77.53 ± 0.3% | 131.83 ± 2.1% | 296.56 ± 0.9% | 7676.68 ± 0.1% | 435.97 ± 0.4% | 0.99 | 1.00 | 5.63 | 3.31 |
| a date and time | 56 | 318.22 ± 0.4% | 319.47 ± 0.4% | 400.51 ± 0.1% | 72.83 ± 1.2% | 138.50 ± 1.8% | 329.11 ± 1.0% | 4942.97 ± 0.3% | 317.93 ± 0.5% | 1.00 | 1.00 | 4.37 | 2.30 |
| a field path | 39 | 202.45 ± 0.3% | 203.24 ± 0.1% | 233.04 ± 0.3% | 80.24 ± 0.7% | 206.17 ± 0.9% | 527.25 ± 5.4% | 4944.86 ± 1.7% | 202.47 ± 0.2% | 1.00 | 1.00 | 2.52 | 0.98 |
| literal: a word | 7 | 659.20 ± 0.2% | 712.58 ± 0.3% | 1273.11 ± 0.0% | 501.03 ± 0.2% | 634.33 ± 1.0% | 956.16 ± 0.6% | 31227.75 ± 0.2% | 659.43 ± 0.1% | 0.93 | 1.00 | 1.32 | 1.04 |
| literal: a word that is not there | 8 | 630.51 ± 0.2% | 687.53 ± 0.3% | 1201.50 ± 0.1% | 453.88 ± 0.3% | 607.15 ± 1.5% | 899.61 ± 0.5% | 29462.27 ± 0.1% | 630.44 ± 0.3% | 0.92 | 1.00 | 1.39 | 1.04 |
| literal: one of four words | 26 | 253.91 ± 0.3% | 417.84 ± 0.3% | 564.18 ± 0.2% | 50.30 ± 1.1% | 246.03 ± 1.4% | 374.28 ± 0.6% | 15852.26 ± 0.2% | 254.00 ± 0.1% | 0.61 | 1.00 | 5.05 | 1.03 |
| literal: a word in any case | 11 | 516.80 ± 0.5% | 558.69 ± 0.2% | 862.00 ± 0.1% | 15.52 ± 0.3% | 664.86 ± 2.1% | refused | 23653.45 ± 0.3% | 516.43 ± 0.6% | 0.93 | 1.00 | 33.30 | 0.78 |
| literal: an href attribute | 12 | 348.63 ± 0.7% | 360.22 ± 0.6% | 470.58 ± 0.4% | 45.44 ± 0.6% | 505.76 ± 1.0% | 772.59 ± 0.3% | 22212.61 ± 0.2% | 348.41 ± 0.6% | 0.97 | 1.00 | 7.67 | 0.69 |
| literal: a word, second text | 10 | 586.87 ± 0.4% | 648.35 ± 0.4% | 1086.36 ± 0.1% | 403.47 ± 0.4% | 541.61 ± 1.2% | 802.29 ± 0.5% | 27425.31 ± 0.3% | 587.37 ± 0.6% | 0.91 | 1.00 | 1.45 | 1.08 |
| class: two capitalized words | 23 | 456.86 ± 0.3% | 486.35 ± 0.3% | 702.87 ± 0.3% | 98.56 ± 0.3% | 508.98 ± 1.2% | 746.43 ± 0.5% | 6621.14 ± 0.2% | 457.00 ± 0.4% | 0.94 | 1.00 | 4.64 | 0.90 |
| class: a word that ends in ing | 9 | 592.37 ± 0.2% | 659.95 ± 0.3% | 1155.89 ± 0.6% | 130.95 ± 1.0% | 768.84 ± 0.9% | 1105.03 ± 0.2% | 16297.31 ± 0.5% | 592.05 ± 0.5% | 0.90 | 1.00 | 4.52 | 0.77 |
| class: a word in capitals | 16 | 516.65 ± 0.3% | 555.15 ± 0.4% | 879.75 ± 0.4% | 134.69 ± 1.2% | 761.39 ± 0.8% | 1022.74 ± 0.5% | 8701.52 ± 0.3% | 516.66 ± 0.5% | 0.93 | 1.00 | 3.84 | 0.68 |
| class: a number | 6 | 649.05 ± 0.4% | 711.49 ± 0.6% | 1323.47 ± 0.1% | 41.88 ± 0.6% | 1414.65 ± 1.5% | 1851.66 ± 1.3% | 23059.75 ± 0.4% | 649.00 ± 0.7% | 0.91 | 1.00 | 15.50 | 0.46 |
| class: two capitalized words, second text | 23 | 456.91 ± 0.5% | 486.12 ± 0.4% | 703.06 ± 0.7% | 100.19 ± 0.2% | 505.75 ± 1.0% | 734.95 ± 4.2% | 6622.84 ± 0.1% | 457.12 ± 0.3% | 0.94 | 1.00 | 4.56 | 0.90 |
| other: a word between two words | 13 | 575.40 ± 0.4% | 595.04 ± 0.5% | 947.16 ± 0.3% | 132.89 ± 0.6% | 506.39 ± 2.0% | 808.56 ± 1.2% | 15109.49 ± 0.1% | 575.83 ± 0.6% | 0.97 | 1.00 | 4.33 | 1.14 |
| other: a number before a unit, second text | 15 | 398.41 ± 0.4% | 432.86 ± 0.4% | 594.85 ± 0.5% | 39.47 ± 0.3% | 638.90 ± 1.2% | 886.51 ± 0.1% | 15383.84 ± 0.4% | 399.03 ± 0.6% | 0.92 | 1.00 | 10.09 | 0.62 |
| other: a heading's start tag | 13 | 357.94 ± 0.5% | 362.50 ± 0.2% | 472.53 ± 0.4% | 44.25 ± 0.2% | 632.43 ± 1.5% | 875.87 ± 1.4% | 18477.43 ± 0.7% | 357.90 ± 0.5% | 0.99 | 1.00 | 8.09 | 0.57 |
| other: a whole word | 11 | 609.17 ± 0.5% | 647.99 ± 0.5% | 1084.07 ± 0.6% | 118.83 ± 0.7% | 571.38 ± 4.4% | 836.88 ± 0.4% | 27197.07 ± 0.9% | 609.59 ± 1.0% | 0.94 | 1.00 | 5.13 | 1.07 |
| other: a line's first word, second text | 17 | 551.93 ± 0.3% | 573.37 ± 0.5% | 915.64 ± 0.1% | 128.79 ± 0.2% | 718.73 ± 0.9% | refused | refused | 551.29 ± 0.6% | 0.96 | 1.00 | 4.29 | 0.77 |
| other: fourteen octets before an x | 16 | 112.52 ± 0.1% | 162.42 ± 0.3% | 185.59 ± 0.3% | 15.20 ± 0.5% | 457.83 ± 0.7% | 417.99 ± 0.6% | 12819.33 ± 0.6% | 112.50 ± 0.3% | 0.69 | 1.00 | 7.40 | 0.25 |
| other: a Greek word | 8 | 446.00 ± 0.2% | 585.15 ± 0.4% | 950.42 ± 0.1% | 59.16 ± 0.5% | 1387.29 ± 1.0% | 1776.69 ± 0.6% | refused | 446.39 ± 0.3% | 0.76 | 1.00 | 7.54 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12834.20 ± 0.4% | not timed | not timed | 16265.17 ± 1.2% | 1965.49 ± 12.3% | not timed | not timed | 12814.95 ± 0.5% | | 1.00 | 0.79 | 6.53 |
| 01-literal/sherlock-casei-en | 522 | 4494.59 ± 0.8% | not timed | not timed | 3583.82 ± 0.2% | 32.58 ± 0.1% | not timed | not timed | 4487.30 ± 0.6% | | 1.00 | 1.25 | 137.97 |
| 01-literal/sherlock-ru | 724 | 13549.98 ± 0.5% | not timed | not timed | 17375.09 ± 0.6% | 1523.35 ± 24.1% | not timed | not timed | 13530.76 ± 0.2% | | 1.00 | 0.78 | 8.89 |
| 01-literal/sherlock-casei-ru | 746 | 5294.45 ± 0.2% | not timed | not timed | 3335.22 ± 0.2% | 31.64 ± 1.4% | not timed | not timed | 5292.80 ± 0.1% | | 1.00 | 1.59 | 167.33 |
| 01-literal/sherlock-zh | 30 | 16973.95 ± 0.7% | not timed | not timed | 18663.73 ± 0.4% | 2564.70 ± 5.4% | not timed | not timed | 16968.32 ± 0.6% | | 1.00 | 0.91 | 6.62 |
| 02-literal-alternate/sherlock-en | 714 | 5765.59 ± 0.3% | not timed | not timed | 3936.74 ± 0.4% | 16.63 ± 0.4% | not timed | not timed | 5765.67 ± 0.3% | | 1.00 | 1.46 | 346.69 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.81 ± 1.3% | not timed | not timed | 697.52 ± 0.2% | 11.13 ± 0.1% | not timed | not timed | 1703.81 ± 0.4% | | 1.01 | 2.46 | 153.92 |
| 02-literal-alternate/sherlock-ru | 899 | 4656.85 ± 0.2% | not timed | not timed | 3254.37 ± 0.1% | 22.62 ± 0.1% | not timed | not timed | 4663.13 ± 0.1% | | 1.00 | 1.43 | 205.87 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1813.52 ± 0.6% | not timed | not timed | 1228.27 ± 0.2% | 9.13 ± 2.7% | not timed | not timed | 1805.68 ± 0.4% | | 1.00 | 1.48 | 198.70 |
| 02-literal-alternate/sherlock-zh | 207 | 7037.46 ± 0.4% | not timed | not timed | 4166.37 ± 0.2% | 31.54 ± 0.2% | not timed | not timed | 7041.37 ± 0.3% | | 1.00 | 1.69 | 223.12 |
| 03-date/ascii | 111817 | 127.38 ± 0.9% | not timed | not timed | 95.49 ± 0.1% | 0.21 ± 4.5% | not timed | not timed | 126.92 ± 1.1% | | 1.00 | 1.33 | 604.48 |
| 04-ruff-noqa/real | 84 | 553.63 ± 0.1% | not timed | not timed | 459.32 ± 0.1% | 19.53 ± 0.1% | not timed | not timed | 553.38 ± 0.0% | | 1.00 | 1.21 | 28.35 |
| 04-ruff-noqa/tweaked | 44 | 550.00 ± 0.2% | not timed | not timed | 460.27 ± 0.2% | 369.45 ± 0.6% | not timed | not timed | 548.23 ± 0.3% | | 1.00 | 1.19 | 1.49 |
| 05-lexer-veryl/single | 124800 | 3.96 ± 0.4% | not timed | not timed | 4.92 ± 0.3% | 0.21 ± 1.6% | not timed | not timed | 4.08 ± 0.4% | | 0.97 | 0.81 | 19.32 |
| 06-cloud-flare-redos/original | 107 | 263.84 ± 0.2% | not timed | not timed | 215.76 ± 0.2% | 24.76 ± 0.2% | not timed | not timed | 263.85 ± 0.3% | | 1.00 | 1.22 | 10.66 |
| 06-cloud-flare-redos/simplified-short | 102 | 258.93 ± 0.4% | not timed | not timed | 228.06 ± 0.1% | 26.65 ± 2.4% | not timed | not timed | 259.17 ± 8.9% | | 1.00 | 1.14 | 9.72 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.06 ± 1.9% | not timed | not timed | 254.98 ± 0.2% | 28.73 ± 1.1% | not timed | not timed | 286.03 ± 10.9% | | 1.00 | 1.12 | 9.96 |
| 07-unicode-character-data/parse-line | 558784 | 238.87 ± 0.5% | not timed | not timed | 169.85 ± 0.1% | 43.53 ± 1.5% | not timed | not timed | 239.06 ± 0.3% | | 1.00 | 1.41 | 5.49 |
| 08-words/all-english | 56691 | 121.30 ± 0.5% | not timed | not timed | 83.37 ± 0.3% | 11.99 ± 3.7% | not timed | not timed | 121.07 ± 0.2% | | 1.00 | 1.46 | 10.11 |
| 08-words/long-english | 839 | 1006.86 ± 0.1% | not timed | not timed | 595.59 ± 0.1% | 32.37 ± 9.5% | not timed | not timed | 1006.38 ± 0.2% | | 1.00 | 1.69 | 31.11 |
| 09-aws-keys/full | 0 | 409.03 ± 0.2% | not timed | not timed | 463.83 ± 0.2% | 64.61 ± 0.5% | not timed | not timed | 408.45 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 735.82 ± 0.2% | not timed | not timed | 983.52 ± 0.3% | 424.04 ± 0.6% | not timed | not timed | 731.47 ± 0.1% | | 1.01 | 0.75 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 639.03 ± 0.3% | not timed | not timed | 517.77 ± 0.5% | 19.48 ± 0.4% | not timed | not timed | 637.75 ± 0.1% | | 1.00 | 1.23 | 32.80 |
| 10-bounded-repeat/letters-ru | 3475 | 385.92 ± 0.2% | not timed | not timed | 475.43 ± 0.1% | 23.63 ± 4.1% | not timed | not timed | 385.07 ± 0.5% | | 1.00 | 0.81 | 16.33 |
| 10-bounded-repeat/context | 53 | 79.36 ± 1.1% | not timed | not timed | 65.84 ± 0.4% | 19.85 ± 0.2% | not timed | not timed | 79.32 ± 1.0% | | 1.00 | 1.21 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1042.82 ± 0.2% | not timed | not timed | 618.13 ± 0.3% | 36.50 ± 0.1% | not timed | not timed | 1042.29 ± 0.2% | | 1.00 | 1.69 | 28.57 |
| 11-unstructured-to-json/extract | 600 | 49.81 ± 0.1% | not timed | not timed | 77.71 ± 0.4% | 49.19 ± 3.5% | not timed | not timed | 49.55 ± 1.2% | | 1.01 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 566.60 ± 0.2% | not timed | not timed | 555.54 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 568.38 ± 0.3% | | 1.00 | 1.02 | 1401.63 |
| 14-quadratic/1x | 100 | 9.67 ± 0.4% | not timed | not timed | 10.02 ± 0.2% | 0.97 ± 3.0% | not timed | not timed | 9.67 ± 1.1% | | 1.00 | 0.97 | 9.97 |
| 14-quadratic/2x | 200 | 5.57 ± 0.5% | not timed | not timed | 5.52 ± 0.3% | 0.53 ± 1.7% | not timed | not timed | 5.57 ± 1.0% | | 1.00 | 1.01 | 10.42 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.1% | not timed | not timed | 1.26 ± 0.5% | | 1.00 | 1.04 | 10.91 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.35 ± 0.7% | 0.55 ± 1.7% | not timed | not timed | 1.53 ± 0.5% | | 1.00 | 4.44 | 2.77 |
| 04-ruff-noqa/compile-real | 1 | 85.39 ± 0.2% | not timed | not timed | 13.67 ± 0.6% | 144.11 ± 14.5% | not timed | not timed | 85.22 ± 0.9% | | 1.00 | 6.25 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 14.53 ± 1.7% | not timed | not timed | 2.55 ± 0.8% | 6.48 ± 2.1% | not timed | not timed | 14.49 ± 0.2% | | 1.00 | 5.70 | 2.24 |
| 07-unicode-character-data/compile | 1 | 55.05 ± 0.1% | not timed | not timed | 25.51 ± 0.3% | 36.61 ± 3.3% | not timed | not timed | 54.53 ± 1.1% | | 1.01 | 2.16 | 1.50 |
| 09-aws-keys/compile-full | 1 | 42.27 ± 0.3% | not timed | not timed | 8.26 ± 0.6% | 23.75 ± 2.4% | not timed | not timed | 42.00 ± 1.0% | | 1.01 | 5.12 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 188.62 ± 0.2% | not timed | not timed | 46.48 ± 0.3% | 135.46 ± 2.4% | not timed | not timed | 188.38 ± 0.7% | | 1.00 | 4.06 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 1.0% | not timed | not timed | 11.18 ± 0.3% | 16.31 ± 3.0% | not timed | not timed | 14.57 ± 1.0% | | 1.00 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.28 ± 1.1% | not timed | not timed | 8.10 ± 0.1% | 23.97 ± 1.0% | not timed | not timed | 84.67 ± 1.0% | | 1.01 | 10.53 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 86.30 ± 0.5% | not timed | not timed | 40.78 ± 0.4% | 69.07 ± 2.0% | not timed | not timed | 85.53 ± 0.9% | | 1.01 | 2.12 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.9% | not timed | not timed | 0.07 ± 14.1% | 0.10 ± 14.5% | not timed | not timed | 0.36 ± 1.4% | | 1.01 | 5.20 | 3.64 |

