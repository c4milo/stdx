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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159262992 |
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
| literal: a word | 217 | 15935.06 ± 1.2% | 1049.61 ± 0.5% | 27.92 ± 0.2% | 17916.32 ± 1.7% | 8742.90 ± 70.3% | 16.98 ± 1.2% | 87.10 ± 0.3% | 15954.91 ± 0.9% | 15.18 | 1.00 | 0.89 | 1.82 |
| literal: a word that is not there | 0 | 18575.82 ± 1.9% | 1056.18 ± 0.3% | 27.77 ± 0.3% | 19789.15 ± 1.2% | 28463.36 ± 4.4% | 16.79 ± 0.1% | 83.01 ± 0.1% | 18726.47 ± 1.1% | 17.59 | 0.99 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6071.44 ± 0.5% | 1031.07 ± 0.2% | 14.57 ± 0.1% | 3943.57 ± 0.3% | 21.91 ± 0.1% | 5.10 ± 0.4% | 6.91 ± 0.4% | 6036.62 ± 0.8% | 5.89 | 1.01 | 1.54 | 277.15 |
| literal: a word in any case | 217 | 12488.44 ± 1.6% | 1047.81 ± 0.4% | 21.49 ± 0.1% | 3965.57 ± 0.7% | 38.02 ± 0.2% | refused | differs | 12475.74 ± 0.6% | 11.92 | 1.00 | 3.15 | 328.51 |
| literal: an href attribute | 33 | 13568.31 ± 1.6% | 1055.54 ± 0.2% | 26.90 ± 0.3% | 16866.77 ± 1.7% | 2250.22 ± 5.8% | 12.91 ± 0.3% | 75.93 ± 1.2% | 13582.51 ± 1.0% | 12.85 | 1.00 | 0.80 | 6.03 |
| literal: a word, second text | 123 | 16230.92 ± 0.6% | 1050.37 ± 0.2% | 27.64 ± 0.3% | 18161.36 ± 1.1% | 7645.90 ± 4.6% | 18.52 ± 0.9% | 71.26 ± 0.9% | 16223.84 ± 1.8% | 15.45 | 1.00 | 0.89 | 2.12 |
| class: two capitalized words | 1331 | 1121.68 ± 0.4% | 979.45 ± 0.4% | 25.69 ± 0.3% | 585.54 ± 0.1% | 40.61 ± 7.6% | 14.34 ± 0.4% | 68.72 ± 0.6% | 1120.17 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.62 |
| class: a word that ends in ing | 3399 | 901.17 ± 0.4% | 901.55 ± 0.3% | 17.90 ± 0.3% | 547.92 ± 0.1% | 29.61 ± 0.7% | 7.97 ± 0.2% | 18.29 ± 1.2% | 899.34 ± 0.4% | 1.00 | 1.00 | 1.64 | 30.44 |
| class: a word in capitals | 2332 | 1458.38 ± 1.4% | 954.15 ± 0.5% | 27.31 ± 0.2% | 572.43 ± 0.1% | 43.66 ± 0.2% | 16.71 ± 0.4% | 82.60 ± 1.4% | 1461.57 ± 0.4% | 1.53 | 1.00 | 2.55 | 33.40 |
| class: a number | 8288 | 2014.69 ± 0.3% | 839.82 ± 0.1% | 27.38 ± 0.3% | 1723.13 ± 0.2% | 41.25 ± 16.7% | 0.54 ± 0.2% | 56.38 ± 0.8% | 2010.71 ± 0.3% | 2.40 | 1.00 | 1.17 | 48.84 |
| class: two capitalized words, second text | 5359 | 744.24 ± 0.2% | 744.63 ± 0.2% | 23.04 ± 0.1% | 485.30 ± 0.1% | 33.14 ± 14.7% | 15.36 ± 0.3% | 64.04 ± 0.3% | 743.20 ± 0.1% | 1.00 | 1.00 | 1.53 | 22.46 |
| other: a word between two words | 6104 | 752.04 ± 0.4% | 781.12 ± 0.1% | 23.21 ± 0.3% | 737.91 ± 0.2% | 108.89 ± 12.0% | 10.90 ± 0.2% | 70.22 ± 0.1% | 753.20 ± 0.1% | 0.96 | 1.00 | 1.02 | 6.91 |
| other: a number before a unit, second text | 1481 | 5395.52 ± 0.4% | 990.83 ± 0.3% | 25.59 ± 0.3% | 5549.30 ± 0.4% | 40.64 ± 9.9% | 16.64 ± 0.2% | 67.10 ± 0.1% | 5372.14 ± 0.6% | 5.45 | 1.00 | 0.97 | 132.77 |
| other: a heading's start tag | 110 | 12574.74 ± 0.8% | 1045.34 ± 0.1% | 27.08 ± 0.2% | 1711.92 ± 0.2% | 1577.04 ± 5.5% | 15.67 ± 0.4% | 88.87 ± 0.2% | 12559.22 ± 0.9% | 12.03 | 1.00 | 7.35 | 7.97 |
| other: a whole word | 217 | 13986.49 ± 0.7% | 1047.57 ± 0.2% | 28.96 ± 0.2% | 14499.91 ± 0.8% | 49.37 ± 0.2% | 13.13 ± 0.3% | 56.03 ± 0.3% | 13990.84 ± 0.7% | 13.35 | 1.00 | 0.96 | 283.30 |
| other: a line's first word, second text | 3716 | 1959.28 ± 0.7% | 877.78 ± 0.2% | 30.37 ± 0.2% | 1713.07 ± 1.2% | 62.49 ± 7.0% | refused | refused | 1948.55 ± 1.0% | 2.23 | 1.01 | 1.14 | 31.35 |
| other: fourteen octets before an x | 87 | 19939.98 ± 1.2% | 240.17 ± 0.7% | 6.63 ± 0.1% | 4005.66 ± 0.5% | 10.64 ± 0.1% | differs | 17.57 ± 0.2% | 19933.28 ± 0.4% | 83.03 | 1.00 | 4.98 | 1874.43 |
| other: a Greek word | 21815 | 512.27 ± 0.7% | 410.88 ± 0.4% | 31.01 ± 0.9% | 288.70 ± 0.2% | 48.29 ± 8.5% | differs | refused | 510.42 ± 0.4% | 1.25 | 1.00 | 1.77 | 10.61 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.85 ± 0.2% | 25.89 ± 0.2% | 0.88 ± 0.1% | 19.70 ± 0.7% | 2.76 ± 1.1% | differs | 4.00 ± 0.4% | 25.86 ± 0.4% | 1.00 | 1.00 | 1.31 | 9.36 |
| a UUID | 32895 | 21.12 ± 0.2% | 21.17 ± 0.2% | 0.65 ± 0.1% | 15.18 ± 0.3% | 3.11 ± 0.1% | 0.71 ± 0.2% | 3.59 ± 0.8% | 21.19 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.80 |
| an IPv4 address | 33176 | 36.85 ± 0.2% | 36.80 ± 0.2% | 2.11 ± 0.3% | 29.00 ± 0.2% | 6.65 ± 0.3% | differs | 4.11 ± 0.3% | 36.89 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.54 |
| a date and time | 32954 | 30.97 ± 0.4% | 31.10 ± 0.5% | 1.47 ± 0.5% | 21.12 ± 0.5% | 7.02 ± 0.1% | 1.20 ± 0.1% | 7.10 ± 0.3% | 31.03 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.46 ± 0.1% | 29.41 ± 0.2% | 1.04 ± 0.5% | 22.98 ± 0.2% | 3.48 ± 3.4% | differs | 2.96 ± 0.4% | 29.43 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.5% | 11.55 ± 0.6% | 11.56 ± 0.5% | 11.38 ± 0.1% | 4.98 ± 1.2% | 0.91 ± 0.3% | none | 11.54 ± 0.4% | 1.00 | 1.00 | 1.01 | 2.31 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.14 ± 0.5% | 221.64 ± 0.2% | 257.82 ± 0.2% | 87.23 ± 0.3% | 221.32 ± 4.1% | 487.11 ± 0.4% | 3896.43 ± 0.9% | 221.03 ± 0.4% | 1.00 | 1.00 | 2.54 | 1.00 |
| a UUID | 62 | 145.16 ± 0.1% | 145.51 ± 0.3% | 160.61 ± 0.3% | 45.73 ± 0.2% | 97.20 ± 3.8% | 184.27 ± 1.1% | 4474.69 ± 2.2% | 145.19 ± 0.1% | 1.00 | 1.00 | 3.17 | 1.49 |
| an IPv4 address | 29 | 436.50 ± 0.7% | 439.98 ± 0.7% | 609.52 ± 1.0% | 77.23 ± 0.9% | 129.55 ± 0.7% | 293.09 ± 1.0% | 7662.78 ± 0.2% | 436.57 ± 0.7% | 0.99 | 1.00 | 5.65 | 3.37 |
| a date and time | 56 | 318.72 ± 0.6% | 320.29 ± 0.1% | 401.18 ± 0.3% | 72.76 ± 0.2% | 134.57 ± 11.8% | 321.37 ± 1.3% | 4939.62 ± 0.4% | 318.48 ± 0.4% | 1.00 | 1.00 | 4.38 | 2.37 |
| a field path | 39 | 208.48 ± 0.1% | 209.13 ± 0.2% | 240.92 ± 0.3% | 80.39 ± 0.7% | 205.50 ± 1.4% | 485.25 ± 0.5% | 4977.82 ± 1.2% | 208.52 ± 0.2% | 1.00 | 1.00 | 2.59 | 1.01 |
| literal: a word | 7 | 660.48 ± 0.3% | 709.93 ± 0.3% | 1253.66 ± 0.1% | 521.67 ± 1.6% | 627.58 ± 42.6% | 923.95 ± 0.7% | 30879.30 ± 0.2% | 659.61 ± 0.4% | 0.93 | 1.00 | 1.27 | 1.05 |
| literal: a word that is not there | 8 | 633.77 ± 0.2% | 684.00 ± 0.3% | 1172.03 ± 0.6% | 476.43 ± 0.1% | 597.50 ± 8.5% | 877.86 ± 1.9% | 29695.25 ± 0.2% | 633.01 ± 0.3% | 0.93 | 1.00 | 1.33 | 1.06 |
| literal: one of four words | 26 | 253.27 ± 0.3% | 415.81 ± 0.5% | 559.60 ± 0.6% | 49.72 ± 0.3% | 241.59 ± 1.9% | 354.76 ± 1.8% | 15879.46 ± 0.1% | 253.33 ± 0.4% | 0.61 | 1.00 | 5.09 | 1.05 |
| literal: a word in any case | 11 | 517.67 ± 0.4% | 558.48 ± 0.7% | 857.42 ± 0.5% | 15.80 ± 1.0% | 648.13 ± 1.2% | refused | 23864.48 ± 0.5% | 518.54 ± 0.3% | 0.93 | 1.00 | 32.76 | 0.80 |
| literal: an href attribute | 12 | 347.42 ± 0.3% | 358.32 ± 0.4% | 463.80 ± 0.8% | 45.32 ± 0.4% | 497.87 ± 1.2% | 772.39 ± 2.4% | 22496.77 ± 0.2% | 347.89 ± 0.1% | 0.97 | 1.00 | 7.67 | 0.70 |
| literal: a word, second text | 10 | 587.24 ± 0.3% | 646.20 ± 0.8% | 1070.90 ± 0.1% | 424.12 ± 0.5% | 527.97 ± 2.7% | 801.96 ± 0.4% | 27767.86 ± 0.2% | 587.18 ± 0.2% | 0.91 | 1.00 | 1.38 | 1.11 |
| class: two capitalized words | 23 | 456.78 ± 0.4% | 485.65 ± 0.8% | 700.12 ± 0.4% | 102.42 ± 0.2% | 504.60 ± 1.0% | 741.37 ± 1.1% | 6650.34 ± 0.2% | 457.00 ± 0.3% | 0.94 | 1.00 | 4.46 | 0.91 |
| class: a word that ends in ing | 9 | 592.10 ± 0.4% | 656.74 ± 0.5% | 1147.05 ± 0.2% | 134.41 ± 1.1% | 757.85 ± 0.6% | 1093.73 ± 1.7% | 16326.58 ± 0.2% | 592.24 ± 0.2% | 0.90 | 1.00 | 4.41 | 0.78 |
| class: a word in capitals | 16 | 519.97 ± 0.2% | 559.06 ± 0.6% | 890.36 ± 0.4% | 136.86 ± 1.1% | 754.63 ± 2.3% | 1011.26 ± 0.9% | 8731.66 ± 0.2% | 519.87 ± 0.2% | 0.93 | 1.00 | 3.80 | 0.69 |
| class: a number | 6 | 654.51 ± 0.3% | 716.60 ± 0.3% | 1330.47 ± 0.1% | 42.14 ± 0.6% | 1398.45 ± 1.4% | 1908.31 ± 0.6% | 23352.30 ± 0.1% | 654.46 ± 0.2% | 0.91 | 1.00 | 15.53 | 0.47 |
| class: two capitalized words, second text | 23 | 457.32 ± 0.5% | 485.31 ± 0.4% | 699.99 ± 0.2% | 103.89 ± 0.3% | 501.05 ± 1.9% | 746.66 ± 0.8% | 6652.19 ± 0.2% | 457.56 ± 0.4% | 0.94 | 1.00 | 4.40 | 0.91 |
| other: a word between two words | 13 | 570.64 ± 0.3% | 587.74 ± 0.0% | 928.69 ± 0.4% | 137.54 ± 0.4% | 503.06 ± 5.9% | 811.35 ± 0.4% | 15110.01 ± 0.2% | 570.51 ± 0.4% | 0.97 | 1.00 | 4.15 | 1.13 |
| other: a number before a unit, second text | 15 | 400.24 ± 0.3% | 435.29 ± 0.3% | 599.34 ± 0.2% | 39.49 ± 0.2% | 635.77 ± 1.1% | 892.95 ± 0.6% | 15405.95 ± 0.2% | 400.02 ± 0.2% | 0.92 | 1.00 | 10.14 | 0.63 |
| other: a heading's start tag | 13 | 359.64 ± 0.2% | 363.60 ± 0.7% | 472.98 ± 0.6% | 43.66 ± 0.3% | 626.06 ± 1.2% | 859.16 ± 0.1% | 18600.22 ± 0.3% | 359.67 ± 0.2% | 0.99 | 1.00 | 8.24 | 0.57 |
| other: a whole word | 11 | 605.27 ± 0.8% | 641.25 ± 0.4% | 1062.43 ± 0.2% | 121.78 ± 0.5% | 560.25 ± 5.2% | 826.91 ± 0.8% | 27265.76 ± 1.4% | 604.82 ± 1.0% | 0.94 | 1.00 | 4.97 | 1.08 |
| other: a line's first word, second text | 17 | 550.38 ± 0.5% | 572.27 ± 0.4% | 917.22 ± 0.4% | 129.86 ± 0.2% | 696.18 ± 2.6% | refused | refused | 547.01 ± 3.2% | 0.96 | 1.01 | 4.24 | 0.79 |
| other: fourteen octets before an x | 16 | 112.52 ± 0.2% | 163.08 ± 0.5% | 186.24 ± 0.7% | 15.13 ± 0.7% | 450.67 ± 2.1% | 427.88 ± 0.5% | 12908.45 ± 0.3% | 112.35 ± 1.0% | 0.69 | 1.00 | 7.44 | 0.25 |
| other: a Greek word | 8 | 445.35 ± 0.2% | 584.81 ± 0.3% | 945.58 ± 0.0% | 58.95 ± 0.2% | 1391.76 ± 0.7% | 1793.06 ± 0.6% | refused | 445.36 ± 0.6% | 0.76 | 1.00 | 7.55 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12835.38 ± 0.4% | not timed | not timed | 16191.44 ± 1.2% | 2086.20 ± 17.0% | not timed | not timed | 12861.83 ± 0.8% | | 1.00 | 0.79 | 6.15 |
| 01-literal/sherlock-casei-en | 522 | 4472.11 ± 1.1% | not timed | not timed | 3590.57 ± 0.2% | 32.55 ± 0.2% | not timed | not timed | 4472.94 ± 0.4% | | 1.00 | 1.25 | 137.39 |
| 01-literal/sherlock-ru | 724 | 13523.77 ± 0.5% | not timed | not timed | 17346.20 ± 0.2% | 1414.49 ± 13.4% | not timed | not timed | 13522.34 ± 0.4% | | 1.00 | 0.78 | 9.56 |
| 01-literal/sherlock-casei-ru | 746 | 5264.03 ± 0.6% | not timed | not timed | 3328.41 ± 0.2% | 31.65 ± 0.4% | not timed | not timed | 5289.02 ± 0.4% | | 1.00 | 1.58 | 166.32 |
| 01-literal/sherlock-zh | 30 | 17216.41 ± 0.7% | not timed | not timed | 18917.89 ± 0.8% | 2695.96 ± 10.2% | not timed | not timed | 17215.01 ± 0.4% | | 1.00 | 0.91 | 6.39 |
| 02-literal-alternate/sherlock-en | 714 | 5745.21 ± 0.3% | not timed | not timed | 3937.03 ± 0.4% | 16.59 ± 5.9% | not timed | not timed | 5751.14 ± 0.5% | | 1.00 | 1.46 | 346.20 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1705.19 ± 0.9% | not timed | not timed | 695.41 ± 0.3% | 11.09 ± 0.1% | not timed | not timed | 1699.83 ± 0.3% | | 1.00 | 2.45 | 153.70 |
| 02-literal-alternate/sherlock-ru | 899 | 4619.18 ± 0.2% | not timed | not timed | 3253.85 ± 0.2% | 22.62 ± 0.1% | not timed | not timed | 4648.40 ± 0.1% | | 0.99 | 1.42 | 204.18 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1800.11 ± 0.6% | not timed | not timed | 1231.47 ± 0.2% | 9.13 ± 0.1% | not timed | not timed | 1797.81 ± 0.3% | | 1.00 | 1.46 | 197.13 |
| 02-literal-alternate/sherlock-zh | 207 | 7067.84 ± 0.4% | not timed | not timed | 4155.98 ± 0.9% | 31.44 ± 0.1% | not timed | not timed | 7068.54 ± 0.2% | | 1.00 | 1.70 | 224.80 |
| 03-date/ascii | 111817 | 125.38 ± 0.6% | not timed | not timed | 96.31 ± 0.1% | 0.20 ± 1.6% | not timed | not timed | 125.84 ± 1.0% | | 1.00 | 1.30 | 618.68 |
| 04-ruff-noqa/real | 84 | 547.49 ± 0.1% | not timed | not timed | 462.89 ± 0.4% | 19.66 ± 1.2% | not timed | not timed | 556.08 ± 0.2% | | 0.98 | 1.18 | 27.84 |
| 04-ruff-noqa/tweaked | 44 | 540.94 ± 0.1% | not timed | not timed | 459.45 ± 0.1% | 366.10 ± 0.9% | not timed | not timed | 539.33 ± 0.1% | | 1.00 | 1.18 | 1.48 |
| 05-lexer-veryl/single | 124800 | 3.98 ± 0.2% | not timed | not timed | 5.08 ± 0.2% | 0.20 ± 2.1% | not timed | not timed | 4.18 ± 2.6% | | 0.95 | 0.78 | 19.47 |
| 06-cloud-flare-redos/original | 107 | 260.20 ± 0.2% | not timed | not timed | 218.05 ± 0.2% | 24.92 ± 0.3% | not timed | not timed | 259.95 ± 0.1% | | 1.00 | 1.19 | 10.44 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.14 ± 0.4% | not timed | not timed | 228.52 ± 0.1% | 26.72 ± 0.1% | not timed | not timed | 255.01 ± 0.7% | | 1.00 | 1.11 | 9.51 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.16 ± 0.1% | not timed | not timed | 254.91 ± 0.4% | 28.81 ± 0.2% | not timed | not timed | 292.14 ± 0.1% | | 1.00 | 1.15 | 10.14 |
| 07-unicode-character-data/parse-line | 558784 | 239.74 ± 6.3% | not timed | not timed | 171.44 ± 0.2% | 42.53 ± 6.2% | not timed | not timed | 241.01 ± 2.1% | | 0.99 | 1.40 | 5.64 |
| 08-words/all-english | 56691 | 121.29 ± 0.8% | not timed | not timed | 83.35 ± 0.2% | 12.67 ± 11.7% | not timed | not timed | 121.09 ± 0.3% | | 1.00 | 1.46 | 9.58 |
| 08-words/long-english | 839 | 1012.85 ± 0.1% | not timed | not timed | 595.50 ± 0.1% | 32.55 ± 0.4% | not timed | not timed | 1012.10 ± 0.8% | | 1.00 | 1.70 | 31.12 |
| 09-aws-keys/full | 0 | 404.42 ± 0.1% | not timed | not timed | 461.57 ± 0.1% | 64.52 ± 0.2% | not timed | not timed | 409.05 ± 0.1% | | 0.99 | 0.88 | 6.27 |
| 09-aws-keys/quick | 0 | 739.71 ± 0.2% | not timed | not timed | 989.95 ± 0.4% | 416.39 ± 0.6% | not timed | not timed | 735.80 ± 0.3% | | 1.01 | 0.75 | 1.78 |
| 10-bounded-repeat/letters-en | 1833 | 636.36 ± 0.4% | not timed | not timed | 516.55 ± 1.3% | 19.48 ± 0.7% | not timed | not timed | 635.96 ± 0.4% | | 1.00 | 1.23 | 32.66 |
| 10-bounded-repeat/letters-ru | 3475 | 383.01 ± 0.2% | not timed | not timed | 477.69 ± 0.2% | 21.91 ± 7.9% | not timed | not timed | 381.40 ± 0.6% | | 1.00 | 0.80 | 17.48 |
| 10-bounded-repeat/context | 53 | 79.17 ± 1.0% | not timed | not timed | 65.99 ± 0.6% | 19.82 ± 0.2% | not timed | not timed | 79.87 ± 1.1% | | 0.99 | 1.20 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1055.13 ± 0.2% | not timed | not timed | 616.53 ± 0.1% | 36.57 ± 0.2% | not timed | not timed | 1055.38 ± 0.2% | | 1.00 | 1.71 | 28.85 |
| 11-unstructured-to-json/extract | 600 | 49.82 ± 0.3% | not timed | not timed | 77.45 ± 0.4% | 48.94 ± 0.3% | not timed | not timed | 49.64 ± 1.1% | | 1.00 | 0.64 | 1.02 |
| 12-dictionary/single | 1 | 568.01 ± 0.3% | not timed | not timed | 561.67 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 568.12 ± 0.3% | | 1.00 | 1.01 | 1398.57 |
| 14-quadratic/1x | 100 | 12.66 ± 0.4% | not timed | not timed | 10.06 ± 0.6% | 0.96 ± 3.4% | not timed | not timed | 12.78 ± 1.6% | | 0.99 | 1.26 | 13.12 |
| 14-quadratic/2x | 200 | 7.90 ± 0.2% | not timed | not timed | 5.51 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 7.92 ± 1.8% | | 1.00 | 1.43 | 14.83 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 2.3% | not timed | not timed | 1.88 ± 0.6% | | 1.00 | 1.55 | 16.31 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.3% | not timed | not timed | 0.34 ± 0.9% | 0.54 ± 4.1% | not timed | not timed | 1.54 ± 1.0% | | 1.01 | 4.49 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 87.02 ± 0.2% | not timed | not timed | 13.74 ± 0.4% | 134.51 ± 13.3% | not timed | not timed | 86.74 ± 2.4% | | 1.00 | 6.33 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.30 ± 3.0% | not timed | not timed | 2.52 ± 0.9% | 6.31 ± 3.9% | not timed | not timed | 14.24 ± 1.7% | | 1.00 | 5.67 | 2.27 |
| 07-unicode-character-data/compile | 1 | 55.30 ± 0.1% | not timed | not timed | 25.87 ± 0.4% | 35.37 ± 5.4% | not timed | not timed | 55.06 ± 3.4% | | 1.00 | 2.14 | 1.56 |
| 09-aws-keys/compile-full | 1 | 42.31 ± 0.2% | not timed | not timed | 8.30 ± 0.4% | 22.38 ± 3.5% | not timed | not timed | 42.11 ± 4.3% | | 1.00 | 5.10 | 1.89 |
| 09-aws-keys/compile-quick | 1 | 189.46 ± 0.3% | not timed | not timed | 47.44 ± 0.2% | 124.69 ± 21.9% | not timed | not timed | 183.98 ± 6.0% | | 1.03 | 3.99 | 1.52 |
| 10-bounded-repeat/compile-context | 1 | 14.69 ± 3.5% | not timed | not timed | 11.21 ± 0.2% | 14.08 ± 8.0% | not timed | not timed | 14.59 ± 1.0% | | 1.01 | 1.31 | 1.04 |
| 10-bounded-repeat/compile-capitals | 1 | 85.05 ± 0.3% | not timed | not timed | 8.12 ± 0.6% | 20.08 ± 20.4% | not timed | not timed | 81.66 ± 4.3% | | 1.04 | 10.48 | 4.24 |
| 11-unstructured-to-json/compile | 1 | 86.68 ± 0.2% | not timed | not timed | 40.91 ± 0.5% | 57.16 ± 8.8% | not timed | not timed | 86.24 ± 0.6% | | 1.01 | 2.12 | 1.52 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.06 ± 4.3% | 0.09 ± 286.7% | not timed | not timed | 0.34 ± 2.0% | | 1.03 | 5.62 | 3.87 |

