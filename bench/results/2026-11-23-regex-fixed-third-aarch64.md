# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159251544 |
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
| literal: a word | 217 | 15665.55 ± 0.9% | 1048.21 ± 0.2% | 28.72 ± 0.7% | 17617.46 ± 4.4% | 9056.48 ± 7.9% | 17.30 ± 0.3% | 86.98 ± 0.3% | 15649.08 ± 1.5% | 14.95 | 1.00 | 0.89 | 1.73 |
| literal: a word that is not there | 0 | 18284.34 ± 1.6% | 1056.60 ± 0.2% | 28.82 ± 0.4% | 18893.14 ± 3.6% | 25874.49 ± 3.4% | 17.08 ± 0.2% | 82.97 ± 0.1% | 18482.75 ± 2.8% | 17.30 | 0.99 | 0.97 | 0.71 |
| literal: one of four words | 661 | 6060.06 ± 0.6% | 1031.24 ± 0.1% | 14.68 ± 0.4% | 3943.24 ± 0.3% | 21.91 ± 0.0% | 5.42 ± 0.1% | 6.94 ± 0.3% | 6053.56 ± 0.4% | 5.88 | 1.00 | 1.54 | 276.64 |
| literal: a word in any case | 217 | 12501.73 ± 0.8% | 1047.23 ± 0.3% | 21.88 ± 0.9% | 3969.07 ± 0.6% | 38.07 ± 0.2% | refused | differs | 12503.45 ± 0.8% | 11.94 | 1.00 | 3.15 | 328.36 |
| literal: an href attribute | 33 | 13423.64 ± 5.1% | 1054.92 ± 0.3% | 27.34 ± 0.4% | 16896.18 ± 2.7% | 2253.13 ± 1.0% | 13.04 ± 0.2% | 75.76 ± 0.2% | 13438.53 ± 0.2% | 12.72 | 1.00 | 0.79 | 5.96 |
| literal: a word, second text | 123 | 16359.21 ± 3.1% | 1050.98 ± 0.4% | 28.21 ± 0.4% | 18149.99 ± 5.5% | 7683.36 ± 9.4% | 20.08 ± 0.3% | 71.15 ± 0.3% | 16412.93 ± 0.8% | 15.57 | 1.00 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1123.75 ± 0.6% | 980.47 ± 0.2% | 26.02 ± 0.2% | 585.33 ± 0.2% | 40.59 ± 7.4% | 14.70 ± 0.2% | 69.02 ± 0.1% | 1122.15 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.69 |
| class: a word that ends in ing | 3399 | 901.69 ± 0.3% | 902.16 ± 0.1% | 18.21 ± 0.1% | 545.31 ± 0.2% | 29.66 ± 3.4% | 8.21 ± 0.2% | 18.43 ± 0.8% | 900.45 ± 0.2% | 1.00 | 1.00 | 1.65 | 30.40 |
| class: a word in capitals | 2332 | 1460.94 ± 0.4% | 955.70 ± 0.0% | 27.75 ± 0.4% | 572.52 ± 0.0% | 43.53 ± 3.2% | 17.07 ± 0.2% | 83.29 ± 0.5% | 1460.75 ± 0.4% | 1.53 | 1.00 | 2.55 | 33.56 |
| class: a number | 8288 | 2004.16 ± 0.4% | 839.46 ± 0.1% | 27.90 ± 0.7% | 1685.15 ± 0.1% | 41.02 ± 16.2% | 0.52 ± 0.6% | 56.86 ± 0.7% | 1998.28 ± 0.2% | 2.39 | 1.00 | 1.19 | 48.86 |
| class: two capitalized words, second text | 5359 | 743.23 ± 0.2% | 745.44 ± 0.2% | 23.35 ± 0.5% | 485.06 ± 0.1% | 32.74 ± 10.4% | 17.03 ± 0.2% | 64.11 ± 0.2% | 744.73 ± 0.2% | 1.00 | 1.00 | 1.53 | 22.70 |
| other: a word between two words | 6104 | 753.30 ± 0.2% | 780.61 ± 0.0% | 23.56 ± 0.4% | 737.63 ± 0.5% | 107.49 ± 11.1% | 11.15 ± 0.1% | 69.92 ± 0.1% | 751.02 ± 0.2% | 0.97 | 1.00 | 1.02 | 7.01 |
| other: a number before a unit, second text | 1481 | 5385.00 ± 0.6% | 991.56 ± 0.1% | 26.06 ± 0.6% | 5636.98 ± 0.8% | 40.66 ± 11.2% | 18.21 ± 0.2% | 67.08 ± 0.4% | 5392.58 ± 0.5% | 5.43 | 1.00 | 0.96 | 132.43 |
| other: a heading's start tag | 110 | 12422.16 ± 1.0% | 1045.22 ± 0.2% | 27.52 ± 0.3% | 1711.84 ± 0.6% | 1582.41 ± 5.7% | 15.94 ± 0.2% | 88.98 ± 0.5% | 12421.75 ± 1.0% | 11.88 | 1.00 | 7.26 | 7.85 |
| other: a whole word | 217 | 13414.09 ± 1.3% | 1045.69 ± 0.2% | 29.46 ± 0.6% | 14129.37 ± 3.2% | 49.40 ± 0.3% | 13.19 ± 0.2% | 56.33 ± 0.3% | 13779.85 ± 0.9% | 12.83 | 0.97 | 0.95 | 271.53 |
| other: a line's first word, second text | 3716 | 1965.38 ± 0.2% | 878.60 ± 0.2% | 31.20 ± 0.2% | 1719.55 ± 0.3% | 61.65 ± 6.8% | refused | refused | 1951.42 ± 0.5% | 2.24 | 1.01 | 1.14 | 31.88 |
| other: fourteen octets before an x | 87 | 18959.30 ± 2.6% | 226.78 ± 1.0% | 6.64 ± 0.1% | 3975.79 ± 0.7% | 10.66 ± 0.3% | differs | 17.84 ± 0.2% | 18868.69 ± 3.0% | 83.60 | 1.00 | 4.77 | 1778.44 |
| other: a Greek word | 21815 | 512.19 ± 0.5% | 413.67 ± 0.1% | 31.29 ± 1.2% | 289.39 ± 0.2% | 44.51 ± 9.4% | differs | refused | 510.04 ± 0.3% | 1.24 | 1.00 | 1.77 | 11.51 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.82 ± 0.1% | 25.73 ± 0.1% | 0.87 ± 0.1% | 19.86 ± 0.2% | 2.56 ± 9.7% | differs | 4.03 ± 0.2% | 25.87 ± 0.1% | 1.00 | 1.00 | 1.30 | 10.08 |
| a UUID | 32895 | 21.05 ± 0.1% | 21.17 ± 0.2% | 0.65 ± 0.1% | 15.16 ± 0.4% | 3.09 ± 0.1% | 0.70 ± 0.1% | 3.60 ± 0.7% | 21.12 ± 0.5% | 0.99 | 1.00 | 1.39 | 6.81 |
| an IPv4 address | 33176 | 36.91 ± 0.4% | 36.83 ± 0.3% | 2.12 ± 0.4% | 29.39 ± 0.2% | 6.64 ± 0.2% | differs | 4.15 ± 0.6% | 36.94 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.56 |
| a date and time | 32954 | 30.99 ± 0.2% | 31.03 ± 0.2% | 1.47 ± 0.3% | 21.44 ± 0.6% | 7.02 ± 0.4% | 1.18 ± 0.3% | 7.19 ± 0.7% | 31.02 ± 0.2% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 29.50 ± 0.3% | 29.45 ± 0.1% | 1.04 ± 0.3% | 23.25 ± 0.2% | 3.51 ± 0.3% | differs | 2.97 ± 0.2% | 29.52 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.53 ± 0.6% | 11.52 ± 0.5% | 11.54 ± 0.4% | 11.83 ± 0.1% | 4.98 ± 1.5% | 0.90 ± 0.6% | none | 11.53 ± 0.4% | 1.00 | 1.00 | 0.98 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.65 ± 0.1% | 237.21 ± 0.4% | 287.79 ± 0.2% | 86.62 ± 0.6% | 220.79 ± 3.8% | 484.18 ± 0.6% | 3855.12 ± 3.8% | 235.63 ± 0.2% | 0.99 | 1.00 | 2.72 | 1.07 |
| a UUID | 62 | 158.10 ± 0.2% | 158.52 ± 0.1% | 179.74 ± 0.2% | 46.60 ± 0.6% | 98.01 ± 1.8% | 189.14 ± 2.7% | 4423.19 ± 1.6% | 158.15 ± 0.1% | 1.00 | 1.00 | 3.39 | 1.61 |
| an IPv4 address | 29 | 423.06 ± 0.4% | 427.81 ± 0.6% | 614.54 ± 0.3% | 77.38 ± 1.1% | 130.74 ± 25.3% | 298.95 ± 1.5% | 7607.57 ± 0.2% | 422.73 ± 0.4% | 0.99 | 1.00 | 5.47 | 3.24 |
| a date and time | 56 | 307.64 ± 0.3% | 310.93 ± 0.4% | 397.42 ± 0.1% | 73.17 ± 0.2% | 136.63 ± 1.8% | 328.81 ± 1.3% | 4898.36 ± 0.2% | 307.34 ± 0.4% | 0.99 | 1.00 | 4.20 | 2.25 |
| a field path | 39 | 227.48 ± 0.4% | 229.17 ± 0.1% | 274.85 ± 0.2% | 81.53 ± 1.0% | 204.31 ± 0.7% | 530.99 ± 6.5% | 4935.88 ± 1.8% | 227.74 ± 0.1% | 0.99 | 1.00 | 2.79 | 1.11 |
| literal: a word | 7 | 631.02 ± 0.5% | 675.23 ± 0.4% | 1256.54 ± 0.1% | 513.86 ± 1.8% | 616.38 ± 1.4% | 973.91 ± 0.5% | 29765.41 ± 0.4% | 630.98 ± 0.3% | 0.93 | 1.00 | 1.23 | 1.02 |
| literal: a word that is not there | 8 | 605.45 ± 0.3% | 654.67 ± 0.4% | 1176.25 ± 0.5% | 462.54 ± 0.3% | 594.89 ± 4.5% | 924.28 ± 0.5% | 28649.95 ± 0.3% | 604.78 ± 0.4% | 0.92 | 1.00 | 1.31 | 1.02 |
| literal: one of four words | 26 | 242.54 ± 0.3% | 403.95 ± 0.1% | 565.42 ± 0.5% | 50.41 ± 0.9% | 241.57 ± 1.4% | 385.51 ± 3.0% | 15512.27 ± 0.1% | 242.64 ± 0.3% | 0.60 | 1.00 | 4.81 | 1.00 |
| literal: a word in any case | 11 | 487.22 ± 0.3% | 521.54 ± 0.3% | 840.78 ± 0.4% | 15.76 ± 0.2% | 642.67 ± 2.9% | refused | 23366.87 ± 0.2% | 487.46 ± 0.6% | 0.93 | 1.00 | 30.92 | 0.76 |
| literal: an href attribute | 12 | 351.40 ± 0.3% | 364.64 ± 0.4% | 491.87 ± 0.7% | 45.59 ± 0.7% | 496.57 ± 1.8% | 793.99 ± 0.7% | 21294.35 ± 0.2% | 351.61 ± 0.3% | 0.96 | 1.00 | 7.71 | 0.71 |
| literal: a word, second text | 10 | 567.44 ± 0.4% | 621.96 ± 0.5% | 1073.67 ± 0.1% | 404.25 ± 0.1% | 534.62 ± 2.3% | 819.72 ± 0.3% | 26558.36 ± 0.6% | 567.37 ± 0.2% | 0.91 | 1.00 | 1.40 | 1.06 |
| class: two capitalized words | 23 | 439.52 ± 0.3% | 468.17 ± 0.3% | 701.45 ± 0.5% | 100.12 ± 0.3% | 496.30 ± 2.7% | 761.75 ± 0.4% | 6580.49 ± 0.2% | 439.22 ± 0.2% | 0.94 | 1.00 | 4.39 | 0.89 |
| class: a word that ends in ing | 9 | 568.19 ± 0.2% | 635.71 ± 0.2% | 1163.45 ± 0.2% | 133.34 ± 0.7% | 752.96 ± 1.2% | 1086.24 ± 1.0% | 15919.95 ± 0.2% | 567.04 ± 0.4% | 0.89 | 1.00 | 4.26 | 0.75 |
| class: a word in capitals | 16 | 502.38 ± 0.4% | 540.30 ± 0.4% | 900.78 ± 0.2% | 135.60 ± 0.6% | 744.81 ± 0.9% | 1034.03 ± 1.7% | 8634.32 ± 0.3% | 503.21 ± 0.2% | 0.93 | 1.00 | 3.70 | 0.67 |
| class: a number | 6 | 628.98 ± 0.4% | 695.36 ± 0.3% | 1364.88 ± 0.1% | 42.21 ± 0.9% | 1394.48 ± 2.0% | 1870.84 ± 0.7% | 22583.79 ± 0.1% | 628.18 ± 0.4% | 0.90 | 1.00 | 14.90 | 0.45 |
| class: two capitalized words, second text | 23 | 438.69 ± 0.3% | 467.80 ± 0.2% | 701.61 ± 0.3% | 100.26 ± 1.3% | 493.20 ± 3.3% | 745.21 ± 4.2% | 6583.61 ± 0.2% | 439.46 ± 0.2% | 0.94 | 1.00 | 4.38 | 0.89 |
| other: a word between two words | 13 | 551.46 ± 0.3% | 569.28 ± 0.3% | 938.74 ± 0.2% | 133.90 ± 0.9% | 493.71 ± 3.5% | 809.88 ± 0.9% | 14803.07 ± 0.1% | 551.15 ± 0.4% | 0.97 | 1.00 | 4.12 | 1.12 |
| other: a number before a unit, second text | 15 | 407.80 ± 0.3% | 447.46 ± 0.3% | 649.88 ± 0.1% | 39.60 ± 0.6% | 638.41 ± 0.7% | 893.88 ± 1.5% | 15022.57 ± 0.1% | 408.07 ± 0.2% | 0.91 | 1.00 | 10.30 | 0.64 |
| other: a heading's start tag | 13 | 362.06 ± 0.4% | 367.16 ± 0.4% | 497.97 ± 0.8% | 44.04 ± 0.4% | 628.33 ± 1.3% | 884.95 ± 1.2% | 17834.23 ± 0.2% | 362.24 ± 0.3% | 0.99 | 1.00 | 8.22 | 0.58 |
| other: a whole word | 11 | 588.38 ± 0.4% | 624.26 ± 0.5% | 1083.03 ± 0.1% | 118.97 ± 0.3% | 560.69 ± 2.2% | 836.99 ± 1.0% | 26511.70 ± 0.2% | 588.14 ± 0.5% | 0.94 | 1.00 | 4.95 | 1.05 |
| other: a line's first word, second text | 17 | 539.51 ± 0.4% | 558.71 ± 0.3% | 942.64 ± 0.2% | 130.93 ± 0.1% | 705.36 ± 1.5% | refused | refused | 538.33 ± 0.8% | 0.97 | 1.00 | 4.12 | 0.76 |
| other: fourteen octets before an x | 16 | 111.98 ± 0.5% | 162.73 ± 0.5% | 190.14 ± 0.8% | 15.16 ± 0.6% | 447.23 ± 2.6% | 409.84 ± 0.7% | 12564.98 ± 0.4% | 112.02 ± 0.8% | 0.69 | 1.00 | 7.39 | 0.25 |
| other: a Greek word | 8 | 432.41 ± 0.1% | 591.95 ± 0.6% | 1043.43 ± 0.2% | 59.11 ± 0.5% | 1370.92 ± 1.9% | 1840.88 ± 0.6% | refused | 432.45 ± 0.3% | 0.73 | 1.00 | 7.32 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12657.42 ± 0.7% | not timed | not timed | 15935.62 ± 1.3% | 2057.43 ± 15.3% | not timed | not timed | 12665.22 ± 0.5% | | 1.00 | 0.79 | 6.15 |
| 01-literal/sherlock-casei-en | 522 | 4470.41 ± 1.4% | not timed | not timed | 3592.52 ± 0.1% | 32.50 ± 0.2% | not timed | not timed | 4474.97 ± 0.3% | | 1.00 | 1.24 | 137.56 |
| 01-literal/sherlock-ru | 724 | 13530.46 ± 0.6% | not timed | not timed | 17381.99 ± 0.7% | 1345.46 ± 12.7% | not timed | not timed | 13490.12 ± 0.7% | | 1.00 | 0.78 | 10.06 |
| 01-literal/sherlock-casei-ru | 746 | 5280.51 ± 0.4% | not timed | not timed | 3328.14 ± 0.2% | 31.77 ± 0.4% | not timed | not timed | 5283.31 ± 0.8% | | 1.00 | 1.59 | 166.20 |
| 01-literal/sherlock-zh | 30 | 16729.38 ± 0.4% | not timed | not timed | 18258.72 ± 1.5% | 2731.35 ± 7.0% | not timed | not timed | 16671.94 ± 0.7% | | 1.00 | 0.92 | 6.12 |
| 02-literal-alternate/sherlock-en | 714 | 5738.07 ± 0.5% | not timed | not timed | 3939.94 ± 0.1% | 16.60 ± 0.1% | not timed | not timed | 5755.53 ± 0.7% | | 1.00 | 1.46 | 345.66 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.73 ± 1.0% | not timed | not timed | 697.36 ± 0.3% | 11.14 ± 0.1% | not timed | not timed | 1705.02 ± 0.4% | | 1.00 | 2.46 | 153.77 |
| 02-literal-alternate/sherlock-ru | 899 | 4651.33 ± 0.2% | not timed | not timed | 3251.05 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 4657.29 ± 0.1% | | 1.00 | 1.43 | 205.80 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1813.23 ± 0.5% | not timed | not timed | 1230.11 ± 0.7% | 9.15 ± 0.3% | not timed | not timed | 1803.72 ± 0.3% | | 1.01 | 1.47 | 198.22 |
| 02-literal-alternate/sherlock-zh | 207 | 7054.33 ± 1.1% | not timed | not timed | 4160.98 ± 0.4% | 31.45 ± 1.7% | not timed | not timed | 7041.96 ± 1.3% | | 1.00 | 1.70 | 224.31 |
| 03-date/ascii | 111817 | 126.72 ± 0.5% | not timed | not timed | 96.52 ± 0.1% | 0.21 ± 6.2% | not timed | not timed | 125.90 ± 1.1% | | 1.01 | 1.31 | 613.85 |
| 04-ruff-noqa/real | 84 | 555.57 ± 0.1% | not timed | not timed | 475.36 ± 0.0% | 19.55 ± 0.1% | not timed | not timed | 555.85 ± 0.1% | | 1.00 | 1.17 | 28.42 |
| 04-ruff-noqa/tweaked | 44 | 543.22 ± 0.2% | not timed | not timed | 465.54 ± 0.1% | 370.57 ± 0.6% | not timed | not timed | 542.37 ± 0.2% | | 1.00 | 1.17 | 1.47 |
| 05-lexer-veryl/single | 124800 | 4.26 ± 0.6% | not timed | not timed | 5.17 ± 0.4% | 0.20 ± 4.4% | not timed | not timed | 4.27 ± 0.6% | | 1.00 | 0.82 | 20.95 |
| 06-cloud-flare-redos/original | 107 | 260.64 ± 0.3% | not timed | not timed | 217.85 ± 0.1% | 24.89 ± 0.3% | not timed | not timed | 260.16 ± 0.1% | | 1.00 | 1.20 | 10.47 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.24 ± 0.1% | not timed | not timed | 228.34 ± 0.1% | 26.78 ± 0.5% | not timed | not timed | 254.59 ± 0.1% | | 1.00 | 1.12 | 9.53 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.80 ± 0.3% | not timed | not timed | 253.47 ± 0.1% | 28.84 ± 0.1% | not timed | not timed | 291.93 ± 0.3% | | 1.00 | 1.15 | 10.12 |
| 07-unicode-character-data/parse-line | 558784 | 234.58 ± 0.4% | not timed | not timed | 180.99 ± 0.1% | 40.33 ± 12.4% | not timed | not timed | 229.25 ± 2.3% | | 1.02 | 1.30 | 5.82 |
| 08-words/all-english | 56691 | 121.81 ± 0.7% | not timed | not timed | 83.28 ± 0.2% | 12.62 ± 10.4% | not timed | not timed | 121.21 ± 0.8% | | 1.00 | 1.46 | 9.66 |
| 08-words/long-english | 839 | 1012.89 ± 0.3% | not timed | not timed | 597.70 ± 0.2% | 32.49 ± 0.5% | not timed | not timed | 1011.94 ± 0.3% | | 1.00 | 1.69 | 31.17 |
| 09-aws-keys/full | 0 | 408.84 ± 0.2% | not timed | not timed | 494.70 ± 0.4% | 64.50 ± 3.4% | not timed | not timed | 408.27 ± 0.2% | | 1.00 | 0.83 | 6.34 |
| 09-aws-keys/quick | 0 | 744.23 ± 0.3% | not timed | not timed | 1000.00 ± 0.2% | 414.69 ± 1.3% | not timed | not timed | 742.40 ± 0.2% | | 1.00 | 0.74 | 1.79 |
| 10-bounded-repeat/letters-en | 1833 | 635.33 ± 0.6% | not timed | not timed | 518.14 ± 1.3% | 19.55 ± 0.6% | not timed | not timed | 634.58 ± 0.3% | | 1.00 | 1.23 | 32.49 |
| 10-bounded-repeat/letters-ru | 3475 | 382.29 ± 0.2% | not timed | not timed | 478.48 ± 0.1% | 21.88 ± 11.1% | not timed | not timed | 379.49 ± 0.5% | | 1.01 | 0.80 | 17.47 |
| 10-bounded-repeat/context | 53 | 80.01 ± 1.0% | not timed | not timed | 65.85 ± 0.6% | 19.81 ± 0.2% | not timed | not timed | 79.71 ± 1.0% | | 1.00 | 1.22 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 1055.05 ± 0.2% | not timed | not timed | 615.76 ± 0.0% | 36.51 ± 0.1% | not timed | not timed | 1055.39 ± 0.2% | | 1.00 | 1.71 | 28.90 |
| 11-unstructured-to-json/extract | 600 | 49.38 ± 0.2% | not timed | not timed | 76.77 ± 0.4% | 48.98 ± 0.7% | not timed | not timed | 48.39 ± 0.8% | | 1.02 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 567.39 ± 0.7% | not timed | not timed | 560.94 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 568.84 ± 0.5% | | 1.00 | 1.01 | 1410.03 |
| 14-quadratic/1x | 100 | 12.82 ± 0.3% | not timed | not timed | 10.06 ± 0.5% | 0.98 ± 4.6% | not timed | not timed | 12.72 ± 1.7% | | 1.01 | 1.27 | 13.07 |
| 14-quadratic/2x | 200 | 7.96 ± 0.2% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 0.5% | not timed | not timed | 7.89 ± 1.2% | | 1.01 | 1.43 | 14.89 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.1% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.5% | not timed | not timed | 1.88 ± 0.3% | | 1.00 | 1.55 | 16.31 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 1.0% | not timed | not timed | 1.44 ± 0.7% | | 1.00 | 4.24 | 2.65 |
| 04-ruff-noqa/compile-real | 1 | 92.72 ± 0.1% | not timed | not timed | 13.91 ± 0.2% | 140.16 ± 1.3% | not timed | not timed | 92.56 ± 0.8% | | 1.00 | 6.67 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.66 ± 0.1% | not timed | not timed | 2.50 ± 1.1% | 6.43 ± 3.1% | not timed | not timed | 14.64 ± 1.2% | | 1.00 | 5.86 | 2.28 |
| 07-unicode-character-data/compile | 1 | 58.36 ± 0.2% | not timed | not timed | 25.99 ± 0.4% | 36.08 ± 2.0% | not timed | not timed | 58.37 ± 0.2% | | 1.00 | 2.25 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.70 ± 0.3% | not timed | not timed | 8.26 ± 0.3% | 23.31 ± 1.4% | not timed | not timed | 43.58 ± 0.6% | | 1.00 | 5.29 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 187.82 ± 0.2% | not timed | not timed | 48.01 ± 0.2% | 135.47 ± 2.8% | not timed | not timed | 189.70 ± 0.6% | | 0.99 | 3.91 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.71 ± 0.4% | not timed | not timed | 11.12 ± 0.3% | 15.97 ± 3.1% | not timed | not timed | 14.67 ± 0.6% | | 1.00 | 1.32 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 86.04 ± 0.3% | not timed | not timed | 8.12 ± 0.1% | 23.50 ± 1.9% | not timed | not timed | 85.93 ± 0.3% | | 1.00 | 10.59 | 3.66 |
| 11-unstructured-to-json/compile | 1 | 90.83 ± 0.2% | not timed | not timed | 41.10 ± 0.7% | 68.09 ± 2.9% | not timed | not timed | 90.52 ± 0.8% | | 1.00 | 2.21 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 8.9% | 0.09 ± 22.5% | not timed | not timed | 0.36 ± 1.0% | | 1.00 | 5.22 | 3.79 |

