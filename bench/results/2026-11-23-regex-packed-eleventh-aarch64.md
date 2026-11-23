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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102087012 |
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
| literal: a word | 217 | 16018.60 ± 1.2% | 1041.52 ± 0.2% | 28.65 ± 0.2% | 18003.95 ± 2.0% | 9020.73 ± 8.1% | 17.35 ± 0.4% | 86.90 ± 0.4% | 16149.02 ± 0.8% | 15.38 | 0.99 | 0.89 | 1.78 |
| literal: a word that is not there | 0 | 18679.97 ± 0.8% | 1048.47 ± 0.5% | 28.60 ± 0.1% | 19695.12 ± 4.0% | 28448.32 ± 1.9% | 17.17 ± 0.2% | 82.75 ± 0.2% | 18682.57 ± 0.1% | 17.82 | 1.00 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6167.42 ± 0.5% | 1021.77 ± 0.2% | 14.55 ± 0.2% | 3953.40 ± 1.0% | 21.90 ± 0.1% | 5.24 ± 0.2% | 6.72 ± 0.4% | 6146.85 ± 0.2% | 6.04 | 1.00 | 1.56 | 281.57 |
| literal: a word in any case | 217 | 12516.21 ± 0.5% | 1041.94 ± 0.1% | 21.43 ± 2.5% | 3975.80 ± 0.7% | 38.05 ± 0.5% | refused | differs | 12467.63 ± 0.6% | 12.01 | 1.00 | 3.15 | 328.93 |
| literal: an href attribute | 33 | 13608.03 ± 1.1% | 1047.07 ± 0.4% | 27.14 ± 0.1% | 16798.65 ± 0.4% | 2267.22 ± 0.4% | 13.31 ± 0.2% | 75.87 ± 0.1% | 13569.92 ± 1.1% | 13.00 | 1.00 | 0.81 | 6.00 |
| literal: a word, second text | 123 | 16180.53 ± 1.2% | 1047.69 ± 0.3% | 27.95 ± 0.2% | 18003.80 ± 2.9% | 7672.47 ± 5.6% | 19.33 ± 1.3% | 70.89 ± 0.6% | 16268.10 ± 1.2% | 15.44 | 0.99 | 0.90 | 2.11 |
| class: two capitalized words | 1331 | 1103.21 ± 0.3% | 959.23 ± 0.1% | 25.87 ± 0.1% | 582.34 ± 0.0% | 40.68 ± 12.8% | 14.87 ± 0.2% | 68.95 ± 0.3% | 1102.94 ± 0.2% | 1.15 | 1.00 | 1.89 | 27.12 |
| class: a word that ends in ing | 3399 | 881.45 ± 0.2% | 882.39 ± 0.1% | 17.92 ± 0.1% | 545.27 ± 0.1% | 29.64 ± 3.1% | 8.15 ± 0.1% | 18.44 ± 0.5% | 880.09 ± 0.1% | 1.00 | 1.00 | 1.62 | 29.74 |
| class: a word in capitals | 2332 | 1463.10 ± 0.6% | 946.06 ± 0.2% | 27.44 ± 0.2% | 572.84 ± 0.2% | 43.56 ± 6.9% | 17.07 ± 0.3% | 83.06 ± 0.2% | 1464.05 ± 0.5% | 1.55 | 1.00 | 2.55 | 33.59 |
| class: a number | 8288 | 2058.04 ± 0.3% | 791.96 ± 0.2% | 27.82 ± 0.2% | 1728.47 ± 0.3% | 39.06 ± 15.1% | 0.56 ± 0.2% | 56.70 ± 0.3% | 2052.53 ± 0.2% | 2.60 | 1.00 | 1.19 | 52.69 |
| class: two capitalized words, second text | 5359 | 688.95 ± 0.2% | 687.77 ± 0.1% | 23.14 ± 0.1% | 486.59 ± 0.1% | 34.04 ± 10.8% | 16.96 ± 0.2% | 64.03 ± 0.2% | 688.90 ± 0.2% | 1.00 | 1.00 | 1.42 | 20.24 |
| other: a word between two words | 6104 | 776.72 ± 0.3% | 743.92 ± 0.2% | 23.35 ± 0.2% | 735.38 ± 0.3% | 109.04 ± 11.5% | 11.34 ± 0.1% | 69.94 ± 0.4% | 777.45 ± 0.1% | 1.04 | 1.00 | 1.06 | 7.12 |
| other: a number before a unit, second text | 1481 | 5451.44 ± 1.1% | 978.44 ± 0.4% | 25.73 ± 0.1% | 5651.23 ± 0.4% | 40.80 ± 8.6% | 17.91 ± 0.3% | 66.95 ± 0.3% | 5444.85 ± 0.7% | 5.57 | 1.00 | 0.96 | 133.62 |
| other: a heading's start tag | 110 | 12511.19 ± 5.7% | 1030.57 ± 0.3% | 27.19 ± 0.1% | 1703.98 ± 0.2% | 1578.10 ± 6.1% | 16.18 ± 0.2% | 88.77 ± 0.6% | 12531.39 ± 1.0% | 12.14 | 1.00 | 7.34 | 7.93 |
| other: a whole word | 217 | 13748.20 ± 0.4% | 1039.54 ± 0.3% | 29.50 ± 0.2% | 14596.58 ± 0.9% | 49.34 ± 0.3% | 13.41 ± 0.1% | 56.06 ± 0.7% | 13817.11 ± 0.9% | 13.23 | 1.00 | 0.94 | 278.63 |
| other: a line's first word, second text | 3716 | 1949.64 ± 0.4% | 854.85 ± 0.2% | 31.12 ± 0.1% | 1731.86 ± 0.4% | 62.36 ± 5.3% | refused | refused | 1935.51 ± 0.5% | 2.28 | 1.01 | 1.13 | 31.26 |
| other: fourteen octets before an x | 87 | 19426.20 ± 1.6% | 230.02 ± 0.3% | 5.31 ± 0.2% | 3964.30 ± 0.5% | 10.66 ± 0.3% | differs | 17.80 ± 0.2% | 19416.61 ± 1.9% | 84.45 | 1.00 | 4.90 | 1821.90 |
| other: a Greek word | 21815 | 470.83 ± 0.6% | 316.39 ± 0.2% | 30.65 ± 0.1% | 289.87 ± 0.8% | 46.55 ± 13.9% | differs | refused | 469.37 ± 0.6% | 1.49 | 1.00 | 1.62 | 10.11 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.91 ± 0.3% | 25.95 ± 0.2% | 0.82 ± 0.1% | 19.50 ± 0.3% | 2.77 ± 0.5% | differs | 3.98 ± 0.2% | 25.95 ± 0.1% | 1.00 | 1.00 | 1.33 | 9.37 |
| a UUID | 32895 | 21.16 ± 0.2% | 21.26 ± 0.3% | 0.64 ± 0.2% | 15.12 ± 0.4% | 3.12 ± 0.1% | 0.71 ± 0.2% | 3.59 ± 0.7% | 21.33 ± 0.2% | 1.00 | 0.99 | 1.40 | 6.77 |
| an IPv4 address | 33176 | 36.74 ± 0.3% | 36.70 ± 0.3% | 2.09 ± 0.1% | 28.88 ± 0.4% | 6.68 ± 0.1% | differs | 4.11 ± 0.3% | 36.82 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.50 |
| a date and time | 32954 | 31.05 ± 0.4% | 31.18 ± 0.6% | 1.45 ± 0.2% | 21.30 ± 0.1% | 7.04 ± 0.2% | 1.19 ± 0.1% | 7.11 ± 0.1% | 31.04 ± 0.6% | 1.00 | 1.00 | 1.46 | 4.41 |
| a field path | 32606 | 29.49 ± 0.4% | 29.38 ± 0.4% | 0.97 ± 0.2% | 23.04 ± 0.9% | 3.51 ± 0.7% | differs | 2.96 ± 0.2% | 29.51 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.89 ± 0.1% | 8.93 ± 0.2% | 8.89 ± 0.3% | 11.34 ± 0.1% | 4.94 ± 1.7% | 0.90 ± 0.5% | none | 8.95 ± 0.1% | 0.99 | 0.99 | 0.78 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.02 ± 0.3% | 222.58 ± 0.3% | 259.17 ± 0.1% | 87.23 ± 0.2% | 220.96 ± 1.4% | 480.90 ± 0.9% | 3869.96 ± 1.2% | 222.09 ± 0.1% | 1.00 | 1.00 | 2.55 | 1.00 |
| a UUID | 62 | 145.66 ± 0.3% | 145.99 ± 0.1% | 161.27 ± 0.1% | 46.59 ± 0.2% | 98.05 ± 0.3% | 186.06 ± 2.8% | 4247.60 ± 1.0% | 145.68 ± 0.2% | 1.00 | 1.00 | 3.13 | 1.49 |
| an IPv4 address | 29 | 439.80 ± 0.6% | 443.83 ± 0.8% | 616.22 ± 0.9% | 77.30 ± 0.5% | 129.73 ± 2.6% | 296.83 ± 0.6% | 7589.86 ± 0.3% | 440.55 ± 0.7% | 0.99 | 1.00 | 5.69 | 3.39 |
| a date and time | 56 | 318.70 ± 0.3% | 319.52 ± 0.3% | 400.88 ± 0.3% | 73.42 ± 0.7% | 136.19 ± 0.7% | 318.64 ± 0.8% | 4869.56 ± 0.7% | 318.75 ± 0.1% | 1.00 | 1.00 | 4.34 | 2.34 |
| a field path | 39 | 209.14 ± 0.2% | 209.42 ± 0.1% | 241.43 ± 0.1% | 80.91 ± 0.4% | 206.14 ± 1.8% | 505.03 ± 1.8% | 4940.86 ± 4.4% | 209.14 ± 0.0% | 1.00 | 1.00 | 2.58 | 1.01 |
| literal: a word | 7 | 668.73 ± 0.2% | 720.47 ± 0.3% | 1289.57 ± 0.1% | 526.49 ± 0.2% | 634.01 ± 2.0% | 944.69 ± 0.4% | 30632.99 ± 0.5% | 668.43 ± 0.4% | 0.93 | 1.00 | 1.27 | 1.05 |
| literal: a word that is not there | 8 | 639.29 ± 0.5% | 695.50 ± 0.1% | 1213.16 ± 0.2% | 474.13 ± 0.2% | 604.89 ± 2.0% | 895.55 ± 0.7% | 29505.15 ± 0.2% | 639.66 ± 0.5% | 0.92 | 1.00 | 1.35 | 1.06 |
| literal: one of four words | 26 | 254.27 ± 0.2% | 416.94 ± 0.6% | 563.70 ± 0.3% | 49.36 ± 0.6% | 242.15 ± 0.9% | 361.51 ± 1.7% | 15844.59 ± 0.2% | 254.39 ± 0.3% | 0.61 | 1.00 | 5.15 | 1.05 |
| literal: a word in any case | 11 | 520.36 ± 1.0% | 558.90 ± 0.8% | 873.16 ± 1.0% | 15.77 ± 0.3% | 643.32 ± 1.7% | refused | 23813.97 ± 0.5% | 520.32 ± 0.2% | 0.93 | 1.00 | 33.00 | 0.81 |
| literal: an href attribute | 12 | 352.74 ± 0.8% | 363.61 ± 0.4% | 475.14 ± 0.4% | 45.32 ± 1.4% | 494.92 ± 2.9% | 778.74 ± 0.7% | 22286.79 ± 0.1% | 353.12 ± 0.5% | 0.97 | 1.00 | 7.78 | 0.71 |
| literal: a word, second text | 10 | 592.79 ± 1.0% | 654.39 ± 0.9% | 1096.21 ± 0.9% | 428.47 ± 0.7% | 535.60 ± 2.0% | 807.00 ± 0.3% | 27527.56 ± 0.1% | 594.28 ± 1.1% | 0.91 | 1.00 | 1.38 | 1.11 |
| class: two capitalized words | 23 | 461.86 ± 0.7% | 492.02 ± 0.7% | 712.89 ± 1.0% | 101.14 ± 0.2% | 498.11 ± 1.6% | 744.31 ± 0.5% | 6627.88 ± 0.1% | 462.59 ± 0.6% | 0.94 | 1.00 | 4.57 | 0.93 |
| class: a word that ends in ing | 9 | 601.07 ± 0.2% | 668.89 ± 0.3% | 1177.56 ± 0.6% | 131.81 ± 1.2% | 757.87 ± 2.0% | 1109.23 ± 1.9% | 16310.02 ± 0.2% | 600.01 ± 0.3% | 0.90 | 1.00 | 4.56 | 0.79 |
| class: a word in capitals | 16 | 527.37 ± 0.5% | 567.91 ± 0.7% | 916.97 ± 1.0% | 135.91 ± 0.3% | 749.84 ± 0.3% | 1012.14 ± 0.4% | 8720.46 ± 0.2% | 528.52 ± 0.4% | 0.93 | 1.00 | 3.88 | 0.70 |
| class: a number | 6 | 665.30 ± 0.9% | 728.64 ± 1.3% | 1372.15 ± 1.9% | 41.94 ± 0.6% | 1403.98 ± 1.4% | 1889.87 ± 0.7% | 23304.83 ± 0.4% | 666.50 ± 0.3% | 0.91 | 1.00 | 15.86 | 0.47 |
| class: two capitalized words, second text | 23 | 460.98 ± 0.6% | 491.63 ± 0.3% | 712.93 ± 0.6% | 104.20 ± 0.3% | 498.17 ± 2.5% | 731.25 ± 0.3% | 6628.20 ± 0.1% | 462.16 ± 0.4% | 0.94 | 1.00 | 4.42 | 0.93 |
| other: a word between two words | 13 | 578.61 ± 0.7% | 599.06 ± 0.5% | 958.08 ± 0.8% | 134.72 ± 1.2% | 499.94 ± 1.2% | 808.07 ± 1.6% | 15014.52 ± 0.3% | 578.60 ± 0.9% | 0.97 | 1.00 | 4.30 | 1.16 |
| other: a number before a unit, second text | 15 | 404.89 ± 0.7% | 441.00 ± 0.7% | 609.14 ± 0.9% | 39.43 ± 0.4% | 632.00 ± 1.2% | 885.52 ± 0.2% | 15405.23 ± 0.3% | 405.24 ± 0.4% | 0.92 | 1.00 | 10.27 | 0.64 |
| other: a heading's start tag | 13 | 363.38 ± 0.3% | 367.34 ± 0.5% | 481.17 ± 0.4% | 44.52 ± 0.3% | 626.91 ± 1.4% | 865.08 ± 0.4% | 18619.75 ± 0.5% | 363.22 ± 0.3% | 0.99 | 1.00 | 8.16 | 0.58 |
| other: a whole word | 11 | 614.47 ± 0.4% | 653.70 ± 0.4% | 1092.09 ± 0.3% | 121.61 ± 0.7% | 563.02 ± 2.4% | 818.83 ± 1.0% | 27197.17 ± 0.2% | 612.88 ± 0.4% | 0.94 | 1.00 | 5.05 | 1.09 |
| other: a line's first word, second text | 17 | 561.76 ± 0.5% | 581.52 ± 0.3% | 937.08 ± 0.1% | 129.24 ± 0.2% | 701.10 ± 1.1% | refused | refused | 560.01 ± 0.3% | 0.97 | 1.00 | 4.35 | 0.80 |
| other: fourteen octets before an x | 16 | 113.13 ± 0.4% | 162.76 ± 0.5% | 186.20 ± 0.4% | 15.16 ± 0.1% | 447.59 ± 7.7% | 412.14 ± 1.3% | 12765.05 ± 0.6% | 112.91 ± 0.3% | 0.70 | 1.00 | 7.46 | 0.25 |
| other: a Greek word | 8 | 449.30 ± 0.5% | 596.33 ± 0.6% | 972.16 ± 0.8% | 59.23 ± 0.2% | 1374.39 ± 1.4% | 1791.93 ± 0.6% | refused | 449.30 ± 0.7% | 0.75 | 1.00 | 7.59 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12623.42 ± 1.3% | not timed | not timed | 15605.39 ± 2.4% | 1894.61 ± 25.8% | not timed | not timed | 12670.01 ± 1.2% | | 1.00 | 0.81 | 6.66 |
| 01-literal/sherlock-casei-en | 522 | 3927.42 ± 0.7% | not timed | not timed | 3590.87 ± 0.2% | 32.49 ± 0.3% | not timed | not timed | 3925.69 ± 0.2% | | 1.00 | 1.09 | 120.90 |
| 01-literal/sherlock-ru | 724 | 13595.53 ± 0.8% | not timed | not timed | 17219.61 ± 0.5% | 1614.94 ± 14.9% | not timed | not timed | 13565.69 ± 0.9% | | 1.00 | 0.79 | 8.42 |
| 01-literal/sherlock-casei-ru | 746 | 5387.29 ± 0.3% | not timed | not timed | 3333.17 ± 0.1% | 30.68 ± 0.8% | not timed | not timed | 5365.96 ± 0.3% | | 1.00 | 1.62 | 175.62 |
| 01-literal/sherlock-zh | 30 | 16655.01 ± 0.9% | not timed | not timed | 18025.24 ± 2.3% | 2657.37 ± 16.9% | not timed | not timed | 16688.72 ± 0.8% | | 1.00 | 0.92 | 6.27 |
| 02-literal-alternate/sherlock-en | 714 | 5836.08 ± 0.7% | not timed | not timed | 3936.25 ± 0.4% | 16.63 ± 0.1% | not timed | not timed | 5882.28 ± 0.3% | | 0.99 | 1.48 | 350.97 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1702.44 ± 0.8% | not timed | not timed | 696.63 ± 0.2% | 11.06 ± 0.1% | not timed | not timed | 1697.65 ± 0.3% | | 1.00 | 2.44 | 153.99 |
| 02-literal-alternate/sherlock-ru | 899 | 4794.92 ± 0.2% | not timed | not timed | 3256.09 ± 0.1% | 22.70 ± 0.2% | not timed | not timed | 4799.75 ± 0.5% | | 1.00 | 1.47 | 211.20 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1818.18 ± 0.6% | not timed | not timed | 1232.57 ± 0.4% | 9.11 ± 5.2% | not timed | not timed | 1808.92 ± 0.4% | | 1.01 | 1.48 | 199.64 |
| 02-literal-alternate/sherlock-zh | 207 | 7085.43 ± 0.6% | not timed | not timed | 4164.82 ± 0.3% | 31.52 ± 0.2% | not timed | not timed | 7105.36 ± 0.5% | | 1.00 | 1.70 | 224.81 |
| 03-date/ascii | 111817 | 124.57 ± 0.2% | not timed | not timed | 96.01 ± 0.1% | 0.20 ± 3.9% | not timed | not timed | 123.67 ± 0.4% | | 1.01 | 1.30 | 623.77 |
| 04-ruff-noqa/real | 84 | 550.72 ± 0.1% | not timed | not timed | 463.16 ± 0.1% | 19.52 ± 1.4% | not timed | not timed | 551.25 ± 0.2% | | 1.00 | 1.19 | 28.22 |
| 04-ruff-noqa/tweaked | 44 | 554.24 ± 0.2% | not timed | not timed | 460.32 ± 0.1% | 365.30 ± 0.4% | not timed | not timed | 553.10 ± 0.2% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.71 ± 0.1% | not timed | not timed | 5.07 ± 0.1% | 0.20 ± 3.6% | not timed | not timed | 3.73 ± 3.0% | | 1.00 | 0.73 | 18.31 |
| 06-cloud-flare-redos/original | 107 | 183.66 ± 0.3% | not timed | not timed | 215.71 ± 0.3% | 24.84 ± 6.9% | not timed | not timed | 182.82 ± 2.2% | | 1.00 | 0.85 | 7.39 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.78 ± 3.2% | not timed | not timed | 227.33 ± 0.1% | 26.69 ± 5.6% | not timed | not timed | 146.08 ± 1.7% | | 1.00 | 0.64 | 5.46 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.78 ± 1.3% | not timed | not timed | 253.65 ± 0.2% | 28.85 ± 0.1% | not timed | not timed | 156.77 ± 2.0% | | 1.00 | 0.62 | 5.43 |
| 07-unicode-character-data/parse-line | 558784 | 40.04 ± 0.1% | not timed | not timed | 170.88 ± 0.2% | 42.51 ± 1.5% | not timed | not timed | 39.87 ± 0.2% | | 1.00 | 0.23 | 0.94 |
| 08-words/all-english | 56691 | 103.02 ± 0.1% | not timed | not timed | 82.14 ± 0.1% | 11.84 ± 7.6% | not timed | not timed | 103.17 ± 0.2% | | 1.00 | 1.25 | 8.70 |
| 08-words/long-english | 839 | 997.31 ± 0.1% | not timed | not timed | 597.77 ± 0.0% | 32.72 ± 0.3% | not timed | not timed | 998.14 ± 0.1% | | 1.00 | 1.67 | 30.48 |
| 09-aws-keys/full | 0 | 420.24 ± 0.1% | not timed | not timed | 461.76 ± 0.1% | 64.77 ± 3.4% | not timed | not timed | 420.98 ± 0.1% | | 1.00 | 0.91 | 6.49 |
| 09-aws-keys/quick | 0 | 396.89 ± 0.0% | not timed | not timed | 988.54 ± 0.7% | 420.57 ± 0.5% | not timed | not timed | 400.50 ± 0.1% | | 0.99 | 0.40 | 0.94 |
| 10-bounded-repeat/letters-en | 1833 | 573.87 ± 0.2% | not timed | not timed | 514.99 ± 0.3% | 19.60 ± 0.4% | not timed | not timed | 592.25 ± 0.2% | | 0.97 | 1.11 | 29.29 |
| 10-bounded-repeat/letters-ru | 3475 | 403.72 ± 0.1% | not timed | not timed | 478.03 ± 0.1% | 21.76 ± 16.6% | not timed | not timed | 402.40 ± 0.4% | | 1.00 | 0.84 | 18.55 |
| 10-bounded-repeat/context | 53 | 73.49 ± 1.0% | not timed | not timed | 65.55 ± 0.4% | 19.82 ± 0.2% | not timed | not timed | 73.38 ± 1.1% | | 1.00 | 1.12 | 3.71 |
| 10-bounded-repeat/capitals | 11 | 1038.95 ± 0.2% | not timed | not timed | 618.34 ± 0.1% | 36.59 ± 0.1% | not timed | not timed | 1039.00 ± 0.1% | | 1.00 | 1.68 | 28.39 |
| 11-unstructured-to-json/extract | 600 | 24.55 ± 0.1% | not timed | not timed | 77.47 ± 0.2% | 49.27 ± 1.3% | not timed | not timed | 24.07 ± 0.9% | | 1.02 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 603.27 ± 0.2% | not timed | not timed | 558.11 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 601.99 ± 0.2% | | 1.00 | 1.08 | 1480.92 |
| 14-quadratic/1x | 100 | 12.60 ± 0.6% | not timed | not timed | 10.03 ± 0.1% | 0.96 ± 2.8% | not timed | not timed | 12.58 ± 1.3% | | 1.00 | 1.26 | 13.10 |
| 14-quadratic/2x | 200 | 7.81 ± 0.6% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.8% | not timed | not timed | 7.71 ± 1.7% | | 1.01 | 1.41 | 14.66 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.9% | not timed | not timed | 1.21 ± 0.0% | 0.11 ± 1.7% | not timed | not timed | 1.83 ± 1.0% | | 1.00 | 1.51 | 15.96 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 0.4% | not timed | not timed | 0.34 ± 0.5% | 0.54 ± 4.9% | not timed | not timed | 1.53 ± 0.3% | | 1.00 | 4.48 | 2.83 |
| 04-ruff-noqa/compile-real | 1 | 86.98 ± 0.1% | not timed | not timed | 13.79 ± 0.3% | 138.08 ± 2.4% | not timed | not timed | 86.44 ± 0.9% | | 1.01 | 6.31 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 14.36 ± 0.2% | not timed | not timed | 2.51 ± 0.2% | 6.50 ± 2.3% | not timed | not timed | 14.32 ± 1.5% | | 1.00 | 5.73 | 2.21 |
| 07-unicode-character-data/compile | 1 | 55.52 ± 0.3% | not timed | not timed | 25.99 ± 0.3% | 36.00 ± 2.9% | not timed | not timed | 55.32 ± 0.9% | | 1.00 | 2.14 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.39 ± 0.2% | not timed | not timed | 8.29 ± 0.1% | 23.18 ± 0.9% | not timed | not timed | 42.19 ± 0.6% | | 1.00 | 5.11 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 190.81 ± 0.2% | not timed | not timed | 47.11 ± 0.1% | 133.71 ± 2.0% | not timed | not timed | 190.80 ± 1.1% | | 1.00 | 4.05 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.59 ± 2.0% | not timed | not timed | 11.19 ± 0.4% | 15.81 ± 2.7% | not timed | not timed | 14.48 ± 1.5% | | 1.01 | 1.30 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.05 ± 0.6% | not timed | not timed | 8.06 ± 0.2% | 23.35 ± 1.4% | not timed | not timed | 84.39 ± 0.8% | | 1.01 | 10.55 | 3.64 |
| 11-unstructured-to-json/compile | 1 | 87.13 ± 0.1% | not timed | not timed | 40.90 ± 0.6% | 68.00 ± 2.0% | not timed | not timed | 87.00 ± 0.6% | | 1.00 | 2.13 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 0.4% | 0.09 ± 16.4% | not timed | not timed | 0.35 ± 2.1% | | 1.00 | 5.09 | 3.79 |

