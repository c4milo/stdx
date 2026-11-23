# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215380058 |
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
| literal: a word | 217 | 15754.09 ± 1.0% | 4982.72 ± 0.2% | 27.89 ± 0.6% | 17726.46 ± 3.4% | 8971.36 ± 9.2% | 16.73 ± 0.2% | 83.80 ± 0.4% | 15899.93 ± 2.8% | 3.16 | 0.99 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18256.10 ± 3.8% | 4879.67 ± 0.3% | 28.01 ± 0.2% | 19074.93 ± 4.7% | 28071.08 ± 3.3% | 16.46 ± 0.3% | 79.12 ± 1.8% | 18575.10 ± 3.1% | 3.74 | 0.98 | 0.96 | 0.65 |
| literal: one of four words | 661 | 6074.93 ± 0.9% | 1930.96 ± 0.2% | 14.27 ± 0.2% | 3938.09 ± 0.2% | 21.89 ± 0.1% | 5.16 ± 0.2% | 6.92 ± 0.3% | 6057.33 ± 0.3% | 3.15 | 1.00 | 1.54 | 277.46 |
| literal: a word in any case | 217 | 12541.23 ± 0.5% | 2072.13 ± 0.2% | 21.37 ± 1.9% | 3961.81 ± 0.2% | 36.82 ± 0.2% | refused | differs | 12510.51 ± 0.7% | 6.05 | 1.00 | 3.17 | 340.62 |
| literal: an href attribute | 33 | 13556.60 ± 0.7% | 615.58 ± 0.1% | 27.04 ± 0.1% | 16872.91 ± 1.7% | 2243.89 ± 7.0% | 12.56 ± 0.1% | 73.13 ± 1.1% | 13574.84 ± 2.8% | 22.02 | 1.00 | 0.80 | 6.04 |
| literal: a word, second text | 123 | 16116.45 ± 0.7% | 3343.28 ± 0.3% | 27.79 ± 0.1% | 17834.97 ± 3.2% | 7461.48 ± 4.5% | 19.84 ± 0.4% | 69.74 ± 1.3% | 16218.52 ± 1.4% | 4.82 | 0.99 | 0.90 | 2.16 |
| class: two capitalized words | 1331 | 1063.86 ± 0.3% | 603.45 ± 0.1% | 25.76 ± 0.3% | 583.37 ± 0.3% | 40.46 ± 8.9% | 14.19 ± 0.3% | 66.91 ± 0.5% | 1060.37 ± 0.4% | 1.76 | 1.00 | 1.82 | 26.30 |
| class: a word that ends in ing | 3399 | 579.86 ± 0.1% | 578.52 ± 0.2% | 17.86 ± 0.5% | 547.39 ± 0.1% | 29.58 ± 10.9% | 7.91 ± 0.2% | 18.41 ± 0.4% | 579.26 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.60 |
| class: a word in capitals | 2332 | 1373.97 ± 0.5% | 614.94 ± 0.1% | 27.25 ± 0.3% | 572.07 ± 0.1% | 43.05 ± 0.8% | 16.70 ± 0.2% | 82.42 ± 0.2% | 1371.59 ± 0.3% | 2.23 | 1.00 | 2.40 | 31.92 |
| class: a number | 8288 | 2002.92 ± 0.3% | 833.16 ± 0.2% | 27.49 ± 0.2% | 1724.17 ± 0.1% | 39.37 ± 14.4% | 0.52 ± 0.1% | 57.53 ± 1.5% | 1994.77 ± 0.5% | 2.40 | 1.00 | 1.16 | 50.88 |
| class: two capitalized words, second text | 5359 | 521.18 ± 0.3% | 528.00 ± 0.2% | 23.09 ± 0.3% | 484.90 ± 0.1% | 33.95 ± 10.0% | 16.85 ± 0.2% | 62.79 ± 0.7% | 520.61 ± 0.2% | 0.99 | 1.00 | 1.07 | 15.35 |
| other: a word between two words | 6104 | 740.96 ± 0.2% | 598.09 ± 0.1% | 23.32 ± 0.4% | 734.77 ± 0.2% | 109.27 ± 13.5% | 10.75 ± 0.3% | 67.40 ± 1.7% | 740.37 ± 0.1% | 1.24 | 1.00 | 1.01 | 6.78 |
| other: a number before a unit, second text | 1481 | 5301.50 ± 0.7% | 1106.22 ± 0.1% | 25.85 ± 0.1% | 5645.88 ± 0.6% | 40.66 ± 1.5% | 17.94 ± 0.3% | 65.62 ± 0.7% | 5295.12 ± 0.6% | 4.79 | 1.00 | 0.94 | 130.39 |
| other: a heading's start tag | 110 | 12361.05 ± 1.3% | 750.18 ± 0.1% | 27.10 ± 0.1% | 1707.36 ± 0.8% | 1571.51 ± 6.1% | 15.42 ± 0.1% | 85.76 ± 0.8% | 12397.00 ± 1.9% | 16.48 | 1.00 | 7.24 | 7.87 |
| other: a whole word | 217 | 13847.64 ± 1.4% | 607.44 ± 0.2% | 29.16 ± 0.6% | 14446.19 ± 0.8% | 47.63 ± 0.2% | 12.40 ± 0.2% | 54.83 ± 0.5% | 13757.44 ± 1.3% | 22.80 | 1.01 | 0.96 | 290.74 |
| other: a line's first word, second text | 3716 | 1947.44 ± 0.5% | 594.22 ± 0.2% | 30.93 ± 0.3% | 1723.39 ± 0.4% | 61.53 ± 6.7% | refused | refused | 1940.90 ± 0.6% | 3.28 | 1.00 | 1.13 | 31.65 |
| other: fourteen octets before an x | 87 | 19320.75 ± 2.8% | 234.03 ± 0.9% | 6.30 ± 0.2% | 3976.12 ± 0.9% | 10.59 ± 0.3% | differs | 17.73 ± 0.1% | 19334.67 ± 2.0% | 82.56 | 1.00 | 4.86 | 1823.97 |
| other: a Greek word | 21815 | 501.93 ± 0.6% | 412.17 ± 0.2% | 30.71 ± 0.1% | 289.52 ± 0.1% | 44.64 ± 9.1% | differs | refused | 496.13 ± 0.8% | 1.22 | 1.01 | 1.73 | 11.24 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.87 ± 0.3% | 19.90 ± 0.2% | 0.84 ± 0.2% | 19.78 ± 0.5% | 2.77 ± 0.6% | differs | 4.07 ± 0.2% | 19.89 ± 0.2% | 1.00 | 1.00 | 1.00 | 7.18 |
| a UUID | 32895 | 21.31 ± 0.2% | 21.38 ± 0.2% | 0.64 ± 0.1% | 15.08 ± 0.3% | 3.10 ± 0.4% | 0.73 ± 0.2% | 3.65 ± 1.1% | 21.36 ± 0.2% | 1.00 | 1.00 | 1.41 | 6.88 |
| an IPv4 address | 33176 | 36.81 ± 0.2% | 36.83 ± 0.3% | 2.05 ± 0.1% | 29.33 ± 0.2% | 6.66 ± 0.1% | differs | 4.16 ± 0.1% | 36.84 ± 0.3% | 1.00 | 1.00 | 1.26 | 5.53 |
| a date and time | 32954 | 31.21 ± 0.1% | 31.38 ± 0.2% | 1.41 ± 0.2% | 21.36 ± 0.4% | 7.02 ± 0.4% | 1.25 ± 0.2% | 7.19 ± 0.4% | 31.29 ± 0.3% | 0.99 | 1.00 | 1.46 | 4.44 |
| a field path | 32606 | 23.48 ± 0.1% | 23.56 ± 0.1% | 1.00 ± 0.1% | 23.27 ± 0.2% | 3.50 ± 0.9% | differs | 2.97 ± 0.3% | 23.50 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.70 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.2% | 11.11 ± 0.6% | 11.07 ± 0.2% | 11.42 ± 0.2% | 4.87 ± 1.6% | 0.94 ± 0.2% | none | 11.12 ± 0.1% | 1.00 | 1.00 | 0.97 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.75 ± 1.1% | 231.75 ± 0.2% | 277.23 ± 0.4% | 86.03 ± 0.7% | 212.51 ± 2.2% | 479.29 ± 1.1% | 3778.75 ± 3.7% | 230.78 ± 0.3% | 1.00 | 1.00 | 2.68 | 1.09 |
| a UUID | 62 | 151.53 ± 0.3% | 152.05 ± 0.3% | 171.17 ± 0.4% | 46.22 ± 0.7% | 94.95 ± 3.5% | 190.12 ± 2.8% | 4194.77 ± 0.9% | 151.61 ± 0.3% | 1.00 | 1.00 | 3.28 | 1.60 |
| an IPv4 address | 29 | 416.08 ± 2.5% | 421.11 ± 0.7% | 603.37 ± 0.7% | 76.14 ± 0.2% | 124.97 ± 14.3% | 298.64 ± 3.1% | 7454.88 ± 0.4% | 415.79 ± 0.5% | 0.99 | 1.00 | 5.46 | 3.33 |
| a date and time | 56 | 300.92 ± 0.3% | 302.81 ± 0.3% | 383.89 ± 0.2% | 72.37 ± 0.3% | 131.37 ± 4.0% | 323.33 ± 1.1% | 4870.74 ± 0.2% | 300.58 ± 0.3% | 0.99 | 1.00 | 4.16 | 2.29 |
| a field path | 39 | 226.24 ± 0.4% | 226.89 ± 0.3% | 269.05 ± 0.4% | 80.15 ± 1.3% | 196.80 ± 2.2% | 499.94 ± 3.1% | 4829.38 ± 0.4% | 225.95 ± 0.4% | 1.00 | 1.00 | 2.82 | 1.15 |
| literal: a word | 7 | 627.53 ± 0.5% | 675.86 ± 0.5% | 1244.95 ± 0.1% | 513.09 ± 0.2% | 611.15 ± 5.7% | 959.58 ± 0.5% | 29248.71 ± 0.4% | 626.78 ± 0.4% | 0.93 | 1.00 | 1.22 | 1.03 |
| literal: a word that is not there | 8 | 606.28 ± 0.3% | 654.66 ± 0.9% | 1171.30 ± 1.6% | 470.64 ± 0.3% | 590.26 ± 6.2% | 904.98 ± 0.6% | 27824.45 ± 0.2% | 605.34 ± 0.5% | 0.93 | 1.00 | 1.29 | 1.03 |
| literal: one of four words | 26 | 239.32 ± 0.4% | 398.65 ± 0.4% | 548.99 ± 0.3% | 49.92 ± 1.2% | 235.74 ± 2.0% | 373.51 ± 1.1% | 15864.01 ± 0.1% | 238.96 ± 0.4% | 0.60 | 1.00 | 4.79 | 1.02 |
| literal: a word in any case | 11 | 445.03 ± 0.4% | 473.62 ± 0.4% | 705.46 ± 0.3% | 15.75 ± 1.6% | 633.03 ± 1.5% | refused | 22965.88 ± 0.6% | 445.13 ± 0.2% | 0.94 | 1.00 | 28.26 | 0.70 |
| literal: an href attribute | 12 | 343.15 ± 0.6% | 356.01 ± 0.3% | 475.96 ± 0.4% | 45.08 ± 0.3% | 484.50 ± 2.3% | 772.54 ± 1.2% | 21278.53 ± 0.3% | 343.28 ± 0.5% | 0.96 | 1.00 | 7.61 | 0.71 |
| literal: a word, second text | 10 | 560.92 ± 0.9% | 615.56 ± 1.0% | 1055.77 ± 1.3% | 394.47 ± 0.4% | 523.92 ± 1.2% | 801.57 ± 0.4% | 25886.12 ± 0.5% | 559.88 ± 0.7% | 0.91 | 1.00 | 1.42 | 1.07 |
| class: two capitalized words | 23 | 428.00 ± 0.9% | 461.82 ± 0.8% | 685.33 ± 1.1% | 99.10 ± 0.1% | 493.20 ± 1.8% | 742.27 ± 0.5% | 6400.76 ± 0.6% | 428.41 ± 0.5% | 0.93 | 1.00 | 4.32 | 0.87 |
| class: a word that ends in ing | 9 | 550.04 ± 0.2% | 625.57 ± 0.4% | 1131.50 ± 0.4% | 131.25 ± 1.9% | 741.59 ± 1.9% | 1107.41 ± 0.3% | 15649.70 ± 0.3% | 547.98 ± 0.2% | 0.88 | 1.00 | 4.19 | 0.74 |
| class: a word in capitals | 16 | 481.39 ± 0.2% | 525.63 ± 0.3% | 880.27 ± 0.1% | 133.99 ± 0.5% | 739.33 ± 1.4% | 1019.87 ± 0.9% | 8365.46 ± 0.7% | 481.41 ± 0.3% | 0.92 | 1.00 | 3.59 | 0.65 |
| class: a number | 6 | 606.99 ± 0.2% | 676.89 ± 0.7% | 1351.01 ± 0.2% | 41.58 ± 0.5% | 1381.85 ± 0.7% | 1853.47 ± 1.2% | 22024.30 ± 0.1% | 606.85 ± 0.4% | 0.90 | 1.00 | 14.60 | 0.44 |
| class: two capitalized words, second text | 23 | 427.47 ± 0.7% | 462.29 ± 0.5% | 685.67 ± 0.8% | 100.35 ± 0.4% | 488.66 ± 2.0% | 762.70 ± 0.5% | 6398.80 ± 0.4% | 427.75 ± 0.6% | 0.92 | 1.00 | 4.26 | 0.87 |
| other: a word between two words | 13 | 541.90 ± 0.5% | 559.88 ± 0.7% | 921.10 ± 0.6% | 131.87 ± 0.7% | 486.45 ± 3.5% | 814.24 ± 0.6% | 14549.49 ± 0.2% | 540.27 ± 0.5% | 0.97 | 1.00 | 4.11 | 1.11 |
| other: a number before a unit, second text | 15 | 394.75 ± 0.7% | 437.37 ± 0.4% | 624.49 ± 0.1% | 39.26 ± 0.2% | 618.50 ± 2.9% | 889.51 ± 0.9% | 14894.95 ± 0.5% | 394.28 ± 0.4% | 0.90 | 1.00 | 10.06 | 0.64 |
| other: a heading's start tag | 13 | 354.49 ± 0.6% | 359.47 ± 0.5% | 483.99 ± 0.5% | 43.61 ± 0.4% | 614.04 ± 4.2% | 879.54 ± 0.6% | 17802.35 ± 0.2% | 353.86 ± 0.6% | 0.99 | 1.00 | 8.13 | 0.58 |
| other: a whole word | 11 | 574.41 ± 0.5% | 607.26 ± 0.3% | 1037.75 ± 0.3% | 117.01 ± 0.5% | 555.05 ± 1.2% | 836.52 ± 0.5% | 26663.34 ± 0.4% | 575.19 ± 0.3% | 0.95 | 1.00 | 4.91 | 1.03 |
| other: a line's first word, second text | 17 | 522.88 ± 0.4% | 542.51 ± 0.3% | 891.26 ± 0.8% | 127.39 ± 0.1% | 697.29 ± 2.5% | refused | refused | 520.69 ± 1.1% | 0.96 | 1.00 | 4.10 | 0.75 |
| other: fourteen octets before an x | 16 | 107.48 ± 0.4% | 154.89 ± 0.5% | 180.66 ± 0.5% | 15.00 ± 0.5% | 442.18 ± 4.9% | 412.01 ± 0.7% | 12646.46 ± 0.5% | 107.48 ± 0.2% | 0.69 | 1.00 | 7.16 | 0.24 |
| other: a Greek word | 8 | 422.51 ± 0.4% | 584.76 ± 0.5% | 1046.22 ± 0.5% | 58.66 ± 0.4% | 1358.40 ± 0.7% | 1795.95 ± 0.3% | refused | 423.18 ± 0.5% | 0.72 | 1.00 | 7.20 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12558.20 ± 1.2% | not timed | not timed | 15901.52 ± 2.7% | 1882.11 ± 28.9% | not timed | not timed | 12524.18 ± 1.2% | | 1.00 | 0.79 | 6.67 |
| 01-literal/sherlock-casei-en | 522 | 4949.90 ± 1.3% | not timed | not timed | 3579.39 ± 3.0% | 32.08 ± 0.3% | not timed | not timed | 4942.88 ± 0.9% | | 1.00 | 1.38 | 154.32 |
| 01-literal/sherlock-ru | 724 | 13400.58 ± 0.3% | not timed | not timed | 17051.78 ± 1.2% | 1483.20 ± 19.1% | not timed | not timed | 13358.35 ± 0.9% | | 1.00 | 0.79 | 9.03 |
| 01-literal/sherlock-casei-ru | 746 | 5949.05 ± 0.4% | not timed | not timed | 3324.36 ± 0.2% | 31.56 ± 1.3% | not timed | not timed | 5939.50 ± 0.5% | | 1.00 | 1.79 | 188.49 |
| 01-literal/sherlock-zh | 30 | 16572.46 ± 5.3% | not timed | not timed | 18046.90 ± 2.1% | 2594.27 ± 10.3% | not timed | not timed | 16577.96 ± 0.7% | | 1.00 | 0.92 | 6.39 |
| 02-literal-alternate/sherlock-en | 714 | 5758.73 ± 0.7% | not timed | not timed | 3934.89 ± 0.7% | 16.65 ± 0.1% | not timed | not timed | 5751.11 ± 0.4% | | 1.00 | 1.46 | 345.90 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1799.23 ± 1.3% | not timed | not timed | 695.65 ± 0.3% | 11.05 ± 0.1% | not timed | not timed | 1789.70 ± 0.3% | | 1.01 | 2.59 | 162.85 |
| 02-literal-alternate/sherlock-ru | 899 | 5327.94 ± 0.4% | not timed | not timed | 3261.29 ± 0.3% | 22.62 ± 3.9% | not timed | not timed | 5328.47 ± 0.5% | | 1.00 | 1.63 | 235.55 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1918.43 ± 0.7% | not timed | not timed | 1231.99 ± 0.1% | 9.15 ± 0.2% | not timed | not timed | 1913.39 ± 0.1% | | 1.00 | 1.56 | 209.77 |
| 02-literal-alternate/sherlock-zh | 207 | 6988.69 ± 0.9% | not timed | not timed | 4162.58 ± 0.2% | 31.47 ± 0.0% | not timed | not timed | 7019.90 ± 0.8% | | 1.00 | 1.68 | 222.05 |
| 03-date/ascii | 111817 | 126.54 ± 0.2% | not timed | not timed | 96.05 ± 0.2% | 0.20 ± 3.9% | not timed | not timed | 125.53 ± 0.9% | | 1.01 | 1.32 | 622.55 |
| 04-ruff-noqa/real | 84 | 409.27 ± 0.1% | not timed | not timed | 474.07 ± 0.3% | 19.49 ± 1.3% | not timed | not timed | 408.01 ± 0.1% | | 1.00 | 0.86 | 20.99 |
| 04-ruff-noqa/tweaked | 44 | 549.78 ± 0.3% | not timed | not timed | 469.62 ± 0.1% | 363.46 ± 0.6% | not timed | not timed | 549.28 ± 0.2% | | 1.00 | 1.17 | 1.51 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.3% | not timed | not timed | 5.23 ± 0.2% | 0.20 ± 4.6% | not timed | not timed | 5.35 ± 0.8% | | 1.00 | 1.02 | 26.58 |
| 06-cloud-flare-redos/original | 107 | 415.44 ± 0.2% | not timed | not timed | 216.86 ± 0.0% | 24.85 ± 0.2% | not timed | not timed | 414.44 ± 0.3% | | 1.00 | 1.92 | 16.72 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.15 ± 0.1% | not timed | not timed | 226.72 ± 0.6% | 26.78 ± 0.2% | not timed | not timed | 411.10 ± 0.1% | | 1.00 | 1.81 | 15.31 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.48 ± 0.2% | not timed | not timed | 254.97 ± 0.6% | 28.80 ± 0.2% | not timed | not timed | 587.01 ± 0.1% | | 1.00 | 2.30 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 230.97 ± 2.5% | not timed | not timed | 176.98 ± 1.5% | 42.16 ± 5.9% | not timed | not timed | 230.62 ± 1.3% | | 1.00 | 1.31 | 5.48 |
| 08-words/all-english | 56691 | 116.54 ± 0.4% | not timed | not timed | 83.13 ± 0.1% | 11.56 ± 10.2% | not timed | not timed | 116.14 ± 0.6% | | 1.00 | 1.40 | 10.08 |
| 08-words/long-english | 839 | 620.56 ± 0.3% | not timed | not timed | 596.31 ± 0.0% | 32.17 ± 0.3% | not timed | not timed | 620.55 ± 0.2% | | 1.00 | 1.04 | 19.29 |
| 09-aws-keys/full | 0 | 415.31 ± 0.2% | not timed | not timed | 492.73 ± 0.2% | 64.72 ± 3.4% | not timed | not timed | 414.64 ± 0.1% | | 1.00 | 0.84 | 6.42 |
| 09-aws-keys/quick | 0 | 732.03 ± 0.2% | not timed | not timed | 978.47 ± 0.5% | 419.38 ± 0.6% | not timed | not timed | 729.25 ± 0.1% | | 1.00 | 0.75 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 582.12 ± 2.2% | not timed | not timed | 511.56 ± 0.1% | 19.49 ± 0.1% | not timed | not timed | 580.34 ± 1.4% | | 1.00 | 1.14 | 29.86 |
| 10-bounded-repeat/letters-ru | 3475 | 508.23 ± 1.1% | not timed | not timed | 479.18 ± 0.1% | 22.09 ± 17.8% | not timed | not timed | 506.26 ± 0.6% | | 1.00 | 1.06 | 23.01 |
| 10-bounded-repeat/context | 53 | 77.31 ± 0.5% | not timed | not timed | 65.46 ± 0.7% | 19.79 ± 0.2% | not timed | not timed | 77.28 ± 0.7% | | 1.00 | 1.18 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 631.32 ± 8.3% | not timed | not timed | 616.49 ± 0.1% | 36.06 ± 0.1% | not timed | not timed | 629.70 ± 8.5% | | 1.00 | 1.02 | 17.51 |
| 11-unstructured-to-json/extract | 600 | 79.53 ± 0.3% | not timed | not timed | 77.24 ± 0.2% | 48.88 ± 1.5% | not timed | not timed | 81.25 ± 0.4% | | 0.98 | 1.03 | 1.63 |
| 12-dictionary/single | 1 | 560.59 ± 0.4% | not timed | not timed | 558.14 ± 0.2% | 0.41 ± 0.4% | not timed | not timed | 557.97 ± 0.4% | | 1.00 | 1.00 | 1374.64 |
| 14-quadratic/1x | 100 | 21.49 ± 0.9% | not timed | not timed | 10.02 ± 0.3% | 0.96 ± 3.7% | not timed | not timed | 21.39 ± 1.1% | | 1.00 | 2.14 | 22.33 |
| 14-quadratic/2x | 200 | 17.67 ± 0.7% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 17.62 ± 0.4% | | 1.00 | 3.19 | 33.44 |
| 14-quadratic/10x | 1000 | 7.71 ± 2.0% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.8% | not timed | not timed | 7.66 ± 1.2% | | 1.01 | 6.36 | 67.01 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.3% | not timed | not timed | 0.34 ± 0.6% | 0.53 ± 6.9% | not timed | not timed | 1.26 ± 3.2% | | 1.02 | 3.81 | 2.44 |
| 04-ruff-noqa/compile-real | 1 | 91.37 ± 1.7% | not timed | not timed | 13.74 ± 0.3% | 134.00 ± 4.3% | not timed | not timed | 91.22 ± 0.9% | | 1.00 | 6.65 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 13.96 ± 1.5% | not timed | not timed | 2.53 ± 0.8% | 6.13 ± 3.2% | not timed | not timed | 13.89 ± 1.4% | | 1.01 | 5.53 | 2.28 |
| 07-unicode-character-data/compile | 1 | 55.54 ± 0.2% | not timed | not timed | 25.77 ± 0.3% | 34.43 ± 3.3% | not timed | not timed | 55.26 ± 0.5% | | 1.01 | 2.16 | 1.61 |
| 09-aws-keys/compile-full | 1 | 42.18 ± 0.3% | not timed | not timed | 8.24 ± 0.1% | 21.49 ± 23.7% | not timed | not timed | 41.78 ± 1.3% | | 1.01 | 5.12 | 1.96 |
| 09-aws-keys/compile-quick | 1 | 182.30 ± 0.3% | not timed | not timed | 47.06 ± 0.1% | 129.45 ± 2.2% | not timed | not timed | 181.03 ± 1.0% | | 1.01 | 3.87 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 13.86 ± 0.5% | not timed | not timed | 11.13 ± 0.4% | 15.45 ± 1.4% | not timed | not timed | 13.83 ± 1.9% | | 1.00 | 1.25 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 82.70 ± 0.3% | not timed | not timed | 7.89 ± 0.1% | 22.46 ± 4.3% | not timed | not timed | 82.53 ± 2.4% | | 1.00 | 10.48 | 3.68 |
| 11-unstructured-to-json/compile | 1 | 86.52 ± 0.4% | not timed | not timed | 41.17 ± 0.8% | 65.74 ± 12.8% | not timed | not timed | 86.04 ± 0.8% | | 1.01 | 2.10 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.3% | not timed | not timed | 0.07 ± 2.0% | 0.09 ± 18.7% | not timed | not timed | 0.34 ± 0.9% | | 1.00 | 5.08 | 3.70 |

