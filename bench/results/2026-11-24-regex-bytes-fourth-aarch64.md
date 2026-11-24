# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391491482 |
| Date | 2026-11-24 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 19024.40 ± 1.0% | 5013.75 ± 0.5% | 28.03 ± 0.3% | 17992.21 ± 1.5% | 9042.27 ± 9.0% | 17.41 ± 0.5% | 84.04 ± 0.8% | 19125.62 ± 1.0% | 3.79 | 0.99 | 1.06 | 2.10 |
| literal: a word that is not there | 0 | 21211.24 ± 3.7% | 4902.06 ± 0.3% | 28.17 ± 0.4% | 19687.64 ± 2.5% | 28929.64 ± 3.3% | 17.24 ± 0.2% | 79.63 ± 0.4% | 21253.89 ± 3.8% | 4.33 | 1.00 | 1.08 | 0.73 |
| literal: one of four words | 661 | 6318.77 ± 0.7% | 1942.35 ± 0.3% | 14.24 ± 0.6% | 3936.60 ± 0.9% | 21.87 ± 0.1% | 5.24 ± 0.2% | 6.86 ± 0.9% | 6337.38 ± 0.6% | 3.25 | 1.00 | 1.61 | 288.98 |
| literal: a word in any case | 217 | 15009.04 ± 1.2% | 2083.24 ± 0.3% | 21.21 ± 0.2% | 3958.23 ± 0.4% | 37.94 ± 0.4% | refused | differs | 14965.81 ± 1.2% | 7.20 | 1.00 | 3.79 | 395.59 |
| literal: an href attribute | 33 | 16489.43 ± 3.6% | 607.36 ± 0.4% | 26.77 ± 0.2% | 16816.01 ± 1.1% | 2250.98 ± 0.5% | 13.30 ± 0.4% | 73.79 ± 0.9% | 16771.42 ± 1.9% | 27.15 | 0.98 | 0.98 | 7.33 |
| literal: a word, second text | 123 | 19739.13 ± 2.4% | 3381.22 ± 0.2% | 27.62 ± 0.2% | 18349.04 ± 0.4% | 7759.05 ± 5.1% | 19.58 ± 0.5% | 70.25 ± 0.3% | 19968.83 ± 1.5% | 5.84 | 0.99 | 1.08 | 2.54 |
| class: two capitalized words | 1331 | 1068.78 ± 0.4% | 597.19 ± 0.2% | 25.71 ± 0.4% | 584.05 ± 1.2% | 40.56 ± 9.0% | 14.79 ± 0.2% | 67.42 ± 0.5% | 1068.25 ± 0.3% | 1.79 | 1.00 | 1.83 | 26.35 |
| class: a word that ends in ing | 3399 | 571.84 ± 0.5% | 571.83 ± 0.5% | 17.77 ± 0.3% | 546.79 ± 0.1% | 29.53 ± 5.9% | 8.15 ± 0.3% | 18.36 ± 0.8% | 572.59 ± 0.5% | 1.00 | 1.00 | 1.05 | 19.36 |
| class: a word in capitals | 2332 | 1375.26 ± 0.4% | 603.62 ± 0.1% | 27.18 ± 0.6% | 571.65 ± 0.1% | 43.48 ± 17.3% | 17.15 ± 0.5% | 82.24 ± 0.3% | 1378.14 ± 0.5% | 2.28 | 1.00 | 2.41 | 31.63 |
| class: a number | 8288 | 1995.76 ± 0.3% | 826.84 ± 0.2% | 27.46 ± 0.3% | 1730.90 ± 0.6% | 43.32 ± 16.4% | 0.56 ± 0.1% | 57.41 ± 0.1% | 1993.89 ± 0.5% | 2.41 | 1.00 | 1.15 | 46.07 |
| class: two capitalized words, second text | 5359 | 514.86 ± 0.4% | 522.66 ± 0.2% | 23.03 ± 0.1% | 484.73 ± 0.1% | 35.34 ± 12.3% | 16.62 ± 0.4% | 62.80 ± 0.3% | 514.79 ± 0.7% | 0.99 | 1.00 | 1.06 | 14.57 |
| other: a word between two words | 6104 | 768.72 ± 0.7% | 591.46 ± 0.2% | 23.23 ± 0.3% | 735.21 ± 0.3% | 110.12 ± 13.9% | 11.27 ± 0.3% | 68.23 ± 1.5% | 789.68 ± 0.7% | 1.30 | 0.97 | 1.05 | 6.98 |
| other: a number before a unit, second text | 1481 | 5949.75 ± 1.3% | 1117.96 ± 1.5% | 25.81 ± 0.4% | 5629.47 ± 0.5% | 40.72 ± 0.2% | 17.77 ± 0.4% | 65.75 ± 0.6% | 5940.76 ± 1.5% | 5.32 | 1.00 | 1.06 | 146.12 |
| other: a heading's start tag | 110 | 13923.73 ± 0.6% | 741.90 ± 1.0% | 27.12 ± 0.5% | 1708.82 ± 0.5% | 1566.07 ± 3.1% | 16.20 ± 0.3% | 86.11 ± 0.3% | 13988.93 ± 1.5% | 18.77 | 1.00 | 8.15 | 8.89 |
| other: a whole word | 217 | 15683.42 ± 1.1% | 599.76 ± 0.4% | 28.88 ± 0.8% | 14423.62 ± 1.0% | 49.32 ± 0.5% | 13.57 ± 0.6% | 54.86 ± 0.3% | 15681.09 ± 0.7% | 26.15 | 1.00 | 1.09 | 318.01 |
| other: a line's first word, second text | 3716 | 2034.50 ± 0.2% | 586.42 ± 0.5% | 30.43 ± 1.0% | 1711.97 ± 0.7% | 61.80 ± 8.9% | refused | refused | 2039.60 ± 0.8% | 3.47 | 1.00 | 1.19 | 32.92 |
| other: fourteen octets before an x | 87 | 23228.35 ± 1.3% | 234.54 ± 1.0% | 6.28 ± 0.1% | 3999.16 ± 0.9% | 10.62 ± 0.3% | differs | 17.74 ± 0.3% | 23153.91 ± 5.6% | 99.04 | 1.00 | 5.81 | 2186.81 |
| other: a Greek word | 21815 | 498.94 ± 0.4% | 412.96 ± 0.2% | 30.58 ± 0.3% | 288.92 ± 0.8% | 49.31 ± 15.5% | differs | refused | 500.67 ± 0.7% | 1.21 | 1.00 | 1.73 | 10.12 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.49 ± 0.2% | 19.46 ± 0.3% | 0.84 ± 0.4% | 19.69 ± 0.2% | 2.77 ± 1.3% | differs | 4.04 ± 0.1% | 19.44 ± 0.3% | 1.00 | 1.00 | 0.99 | 7.05 |
| a UUID | 32895 | 20.99 ± 0.3% | 21.00 ± 0.3% | 0.63 ± 0.3% | 15.12 ± 0.7% | 3.09 ± 0.3% | 0.72 ± 0.5% | 3.64 ± 0.8% | 21.00 ± 0.5% | 1.00 | 1.00 | 1.39 | 6.80 |
| an IPv4 address | 33176 | 35.83 ± 0.5% | 35.81 ± 0.4% | 2.04 ± 0.3% | 28.82 ± 0.4% | 6.65 ± 0.3% | differs | 4.15 ± 0.2% | 35.81 ± 0.4% | 1.00 | 1.00 | 1.24 | 5.39 |
| a date and time | 32954 | 30.47 ± 0.4% | 30.96 ± 0.2% | 1.43 ± 0.2% | 21.05 ± 0.3% | 7.01 ± 0.5% | 1.19 ± 0.2% | 7.12 ± 0.4% | 30.94 ± 0.9% | 0.98 | 0.98 | 1.45 | 4.35 |
| a field path | 32606 | 23.11 ± 0.3% | 23.05 ± 0.5% | 1.00 ± 0.5% | 22.97 ± 0.6% | 3.45 ± 1.5% | differs | 2.96 ± 0.6% | 23.06 ± 1.3% | 1.00 | 1.00 | 1.01 | 6.71 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.17 ± 0.5% | 11.17 ± 0.7% | 11.17 ± 0.9% | 11.41 ± 0.1% | 4.91 ± 1.5% | 0.90 ± 0.4% | none | 11.14 ± 2.1% | 1.00 | 1.00 | 0.98 | 2.28 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.03 ± 0.2% | 218.44 ± 0.3% | 260.97 ± 0.4% | 86.12 ± 0.6% | 216.30 ± 1.0% | 482.82 ± 0.5% | 3782.82 ± 0.8% | 217.07 ± 0.2% | 0.99 | 1.00 | 2.52 | 1.00 |
| a UUID | 62 | 142.77 ± 0.1% | 143.51 ± 0.5% | 161.63 ± 0.5% | 45.58 ± 1.0% | 96.89 ± 3.0% | 187.40 ± 2.4% | 4154.13 ± 0.4% | 142.83 ± 0.6% | 0.99 | 1.00 | 3.13 | 1.47 |
| an IPv4 address | 29 | 407.06 ± 0.5% | 412.67 ± 0.3% | 592.45 ± 0.4% | 77.16 ± 0.9% | 128.39 ± 2.1% | 291.25 ± 1.1% | 7475.86 ± 0.7% | 406.43 ± 0.4% | 0.99 | 1.00 | 5.28 | 3.17 |
| a date and time | 56 | 294.59 ± 0.5% | 297.59 ± 0.3% | 381.55 ± 0.2% | 72.02 ± 0.4% | 133.42 ± 2.4% | 325.85 ± 2.2% | 4790.10 ± 0.7% | 294.68 ± 0.3% | 0.99 | 1.00 | 4.09 | 2.21 |
| a field path | 39 | 209.02 ± 0.4% | 210.12 ± 0.2% | 249.22 ± 0.2% | 79.07 ± 2.2% | 199.98 ± 1.6% | 512.48 ± 3.3% | 4831.44 ± 2.7% | 209.40 ± 0.6% | 0.99 | 1.00 | 2.64 | 1.05 |
| literal: a word | 7 | 600.97 ± 0.4% | 648.24 ± 0.5% | 1221.38 ± 0.2% | 498.79 ± 0.2% | 609.14 ± 1.8% | 961.70 ± 0.4% | 30464.13 ± 0.5% | 602.06 ± 0.5% | 0.93 | 1.00 | 1.20 | 0.99 |
| literal: a word that is not there | 8 | 577.81 ± 0.5% | 629.13 ± 0.3% | 1138.62 ± 0.5% | 455.86 ± 0.3% | 592.27 ± 1.5% | 909.10 ± 0.4% | 29284.75 ± 0.2% | 578.25 ± 0.7% | 0.92 | 1.00 | 1.27 | 0.98 |
| literal: one of four words | 26 | 234.98 ± 0.9% | 383.58 ± 0.3% | 537.34 ± 0.3% | 49.31 ± 0.8% | 236.57 ± 1.0% | 372.39 ± 0.7% | 15932.84 ± 0.1% | 235.35 ± 0.3% | 0.61 | 1.00 | 4.77 | 0.99 |
| literal: a word in any case | 11 | 437.22 ± 0.5% | 465.87 ± 0.5% | 711.38 ± 0.5% | 15.44 ± 0.5% | 629.81 ± 2.5% | refused | 23742.68 ± 0.4% | 436.99 ± 0.4% | 0.94 | 1.00 | 28.33 | 0.69 |
| literal: an href attribute | 12 | 328.17 ± 0.6% | 340.00 ± 0.3% | 458.67 ± 0.3% | 11.87 ± 10.3% | 489.15 ± 9.1% | 770.58 ± 0.9% | 21633.23 ± 0.6% | 328.21 ± 0.4% | 0.97 | 1.00 | 27.65 | 0.67 |
| literal: a word, second text | 10 | 535.87 ± 0.4% | 590.41 ± 0.7% | 1028.08 ± 0.7% | 409.71 ± 2.5% | 531.28 ± 1.5% | 795.28 ± 0.4% | 27241.52 ± 0.2% | 536.44 ± 0.6% | 0.91 | 1.00 | 1.31 | 1.01 |
| class: two capitalized words | 23 | 420.86 ± 1.4% | 451.41 ± 0.6% | 672.64 ± 0.8% | 99.44 ± 0.9% | 491.75 ± 1.7% | 742.09 ± 0.4% | 6436.13 ± 0.4% | 421.58 ± 0.3% | 0.93 | 1.00 | 4.23 | 0.86 |
| class: a word that ends in ing | 9 | 530.42 ± 0.5% | 594.97 ± 1.2% | 1081.78 ± 0.4% | 132.99 ± 1.5% | 738.90 ± 1.3% | 1123.97 ± 0.8% | 15898.59 ± 1.5% | 531.23 ± 1.0% | 0.89 | 1.00 | 3.99 | 0.72 |
| class: a word in capitals | 16 | 470.51 ± 0.1% | 512.69 ± 0.4% | 843.65 ± 0.2% | 136.44 ± 0.9% | 729.08 ± 1.1% | 1043.52 ± 1.4% | 8488.13 ± 0.7% | 470.46 ± 0.5% | 0.92 | 1.00 | 3.45 | 0.65 |
| class: a number | 6 | 594.52 ± 0.4% | 661.17 ± 0.1% | 1302.02 ± 0.2% | 41.77 ± 1.0% | 1376.73 ± 0.9% | 1853.31 ± 2.1% | 22881.69 ± 0.1% | 594.93 ± 0.4% | 0.90 | 1.00 | 14.23 | 0.43 |
| class: two capitalized words, second text | 23 | 421.87 ± 0.8% | 451.74 ± 0.8% | 673.93 ± 0.6% | 101.25 ± 0.3% | 488.79 ± 1.7% | 765.70 ± 0.8% | 6421.97 ± 0.7% | 421.50 ± 0.6% | 0.93 | 1.00 | 4.17 | 0.86 |
| other: a word between two words | 13 | 517.84 ± 0.5% | 536.66 ± 0.5% | 892.15 ± 0.5% | 132.82 ± 1.5% | 489.32 ± 10.6% | 814.14 ± 0.9% | 14578.02 ± 0.8% | 517.10 ± 0.4% | 0.96 | 1.00 | 3.90 | 1.06 |
| other: a number before a unit, second text | 15 | 374.05 ± 0.3% | 411.15 ± 0.4% | 591.45 ± 0.3% | 39.32 ± 1.1% | 610.55 ± 1.9% | 891.21 ± 0.5% | 15178.43 ± 0.6% | 374.26 ± 0.3% | 0.91 | 1.00 | 9.51 | 0.61 |
| other: a heading's start tag | 13 | 342.32 ± 0.2% | 349.40 ± 0.4% | 470.33 ± 0.2% | 12.18 ± 3.9% | 610.90 ± 1.7% | 867.66 ± 0.1% | 17959.96 ± 0.7% | 342.18 ± 0.1% | 0.98 | 1.00 | 28.11 | 0.56 |
| other: a whole word | 11 | 555.49 ± 0.4% | 593.21 ± 0.7% | 1029.01 ± 0.2% | 119.30 ± 0.6% | 549.56 ± 0.3% | 833.29 ± 1.1% | 27146.46 ± 0.5% | 555.87 ± 0.5% | 0.94 | 1.00 | 4.66 | 1.01 |
| other: a line's first word, second text | 17 | 502.34 ± 1.0% | 526.35 ± 0.4% | 879.06 ± 0.5% | 127.95 ± 0.7% | 692.54 ± 1.4% | refused | refused | 503.46 ± 0.3% | 0.95 | 1.00 | 3.93 | 0.73 |
| other: fourteen octets before an x | 16 | 107.23 ± 0.7% | 152.82 ± 0.9% | 178.67 ± 1.1% | 7.29 ± 14.7% | 442.05 ± 1.1% | 407.03 ± 0.5% | 12780.58 ± 0.3% | 107.23 ± 0.5% | 0.70 | 1.00 | 14.71 | 0.24 |
| other: a Greek word | 8 | 411.08 ± 1.0% | 559.25 ± 0.7% | 969.66 ± 0.3% | 14.00 ± 15.3% | 1352.63 ± 1.6% | 1816.63 ± 0.4% | refused | 411.26 ± 0.2% | 0.74 | 1.00 | 29.37 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15419.88 ± 1.4% | not timed | not timed | 15932.80 ± 1.0% | 2032.56 ± 21.7% | not timed | not timed | 15425.63 ± 0.5% | | 1.00 | 0.97 | 7.59 |
| 01-literal/sherlock-casei-en | 522 | 10966.01 ± 3.7% | not timed | not timed | 3582.84 ± 0.7% | 32.49 ± 0.4% | not timed | not timed | 10990.75 ± 2.6% | | 1.00 | 3.06 | 337.54 |
| 01-literal/sherlock-ru | 724 | 17023.62 ± 0.6% | not timed | not timed | 17162.21 ± 0.4% | 1505.50 ± 10.0% | not timed | not timed | 17099.76 ± 0.4% | | 1.00 | 0.99 | 11.31 |
| 01-literal/sherlock-casei-ru | 746 | 6166.26 ± 0.3% | not timed | not timed | 3316.98 ± 0.5% | 30.67 ± 0.2% | not timed | not timed | 6178.94 ± 0.4% | | 1.00 | 1.86 | 201.04 |
| 01-literal/sherlock-zh | 30 | 19338.67 ± 1.2% | not timed | not timed | 18328.58 ± 1.3% | 2701.05 ± 10.4% | not timed | not timed | 19319.51 ± 0.6% | | 1.00 | 1.06 | 7.16 |
| 02-literal-alternate/sherlock-en | 714 | 6039.96 ± 0.4% | not timed | not timed | 3933.87 ± 0.2% | 16.58 ± 0.2% | not timed | not timed | 5998.65 ± 0.4% | | 1.01 | 1.54 | 364.19 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1975.89 ± 1.6% | not timed | not timed | 695.78 ± 0.2% | 11.09 ± 0.2% | not timed | not timed | 1973.02 ± 1.0% | | 1.00 | 2.84 | 178.12 |
| 02-literal-alternate/sherlock-ru | 899 | 5547.14 ± 0.1% | not timed | not timed | 3255.72 ± 0.3% | 22.58 ± 0.0% | not timed | not timed | 5537.53 ± 0.2% | | 1.00 | 1.70 | 245.70 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2052.52 ± 0.6% | not timed | not timed | 1231.14 ± 0.2% | 9.09 ± 0.3% | not timed | not timed | 2049.56 ± 0.4% | | 1.00 | 1.67 | 225.82 |
| 02-literal-alternate/sherlock-zh | 207 | 7285.95 ± 0.3% | not timed | not timed | 4145.22 ± 0.4% | 31.36 ± 0.3% | not timed | not timed | 7265.45 ± 0.3% | | 1.00 | 1.76 | 232.32 |
| 03-date/ascii | 111817 | 124.04 ± 1.0% | not timed | not timed | 95.88 ± 0.3% | 0.20 ± 3.2% | not timed | not timed | 124.05 ± 0.8% | | 1.00 | 1.29 | 622.33 |
| 04-ruff-noqa/real | 84 | 402.16 ± 0.1% | not timed | not timed | 461.31 ± 0.1% | 19.78 ± 1.3% | not timed | not timed | 401.25 ± 0.1% | | 1.00 | 0.87 | 20.33 |
| 04-ruff-noqa/tweaked | 44 | 554.83 ± 0.4% | not timed | not timed | 457.41 ± 0.0% | 365.45 ± 0.7% | not timed | not timed | 554.94 ± 0.4% | | 1.00 | 1.21 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.23 ± 0.4% | not timed | not timed | 5.06 ± 0.3% | 0.20 ± 1.9% | not timed | not timed | 5.18 ± 8.2% | | 1.01 | 1.03 | 25.69 |
| 06-cloud-flare-redos/original | 107 | 413.74 ± 0.1% | not timed | not timed | 216.20 ± 0.2% | 24.73 ± 1.0% | not timed | not timed | 414.57 ± 0.1% | | 1.00 | 1.91 | 16.73 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.15 ± 0.5% | not timed | not timed | 227.71 ± 0.2% | 26.50 ± 5.7% | not timed | not timed | 408.68 ± 2.9% | | 1.02 | 1.82 | 15.66 |
| 06-cloud-flare-redos/simplified-long | 10000 | 586.44 ± 2.3% | not timed | not timed | 253.42 ± 0.0% | 28.76 ± 1.4% | not timed | not timed | 576.73 ± 1.7% | | 1.02 | 2.31 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 238.46 ± 1.0% | not timed | not timed | 172.69 ± 0.8% | 42.50 ± 1.0% | not timed | not timed | 242.01 ± 0.7% | | 0.99 | 1.38 | 5.61 |
| 08-words/all-english | 56691 | 116.19 ± 0.7% | not timed | not timed | 82.82 ± 0.3% | 11.74 ± 1.8% | not timed | not timed | 116.48 ± 0.3% | | 1.00 | 1.40 | 9.90 |
| 08-words/long-english | 839 | 611.27 ± 0.7% | not timed | not timed | 594.08 ± 0.1% | 32.44 ± 0.4% | not timed | not timed | 612.35 ± 0.4% | | 1.00 | 1.03 | 18.84 |
| 09-aws-keys/full | 0 | 406.94 ± 0.2% | not timed | not timed | 461.14 ± 0.3% | 66.59 ± 4.3% | not timed | not timed | 407.56 ± 0.1% | | 1.00 | 0.88 | 6.11 |
| 09-aws-keys/quick | 0 | 868.52 ± 0.2% | not timed | not timed | 985.47 ± 0.7% | 417.02 ± 0.9% | not timed | not timed | 869.31 ± 0.3% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 583.42 ± 1.4% | not timed | not timed | 516.31 ± 0.6% | 19.52 ± 0.6% | not timed | not timed | 580.31 ± 1.9% | | 1.01 | 1.13 | 29.89 |
| 10-bounded-repeat/letters-ru | 3475 | 507.11 ± 1.7% | not timed | not timed | 477.20 ± 0.3% | 21.57 ± 17.4% | not timed | not timed | 508.27 ± 0.7% | | 1.00 | 1.06 | 23.51 |
| 10-bounded-repeat/context | 53 | 84.52 ± 2.1% | not timed | not timed | 65.70 ± 0.4% | 19.78 ± 0.3% | not timed | not timed | 84.34 ± 1.5% | | 1.00 | 1.29 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 640.65 ± 7.5% | not timed | not timed | 615.87 ± 1.1% | 36.50 ± 0.5% | not timed | not timed | 640.39 ± 6.5% | | 1.00 | 1.04 | 17.55 |
| 11-unstructured-to-json/extract | 600 | 56.63 ± 1.1% | not timed | not timed | 77.22 ± 0.9% | 48.79 ± 0.8% | not timed | not timed | 56.76 ± 0.5% | | 1.00 | 0.73 | 1.16 |
| 12-dictionary/single | 1 | 565.60 ± 0.6% | not timed | not timed | 558.56 ± 0.2% | 0.41 ± 0.0% | not timed | not timed | 567.52 ± 0.2% | | 1.00 | 1.01 | 1383.07 |
| 14-quadratic/1x | 100 | 21.13 ± 1.4% | not timed | not timed | 9.97 ± 0.7% | 0.97 ± 8.0% | not timed | not timed | 21.18 ± 1.7% | | 1.00 | 2.12 | 21.69 |
| 14-quadratic/2x | 200 | 17.41 ± 0.7% | not timed | not timed | 5.51 ± 0.2% | 0.53 ± 1.1% | not timed | not timed | 17.39 ± 1.6% | | 1.00 | 3.16 | 32.56 |
| 14-quadratic/10x | 1000 | 7.67 ± 0.5% | not timed | not timed | 1.21 ± 0.4% | 0.11 ± 1.7% | not timed | not timed | 7.68 ± 0.3% | | 1.00 | 6.36 | 67.09 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 1.3% | not timed | not timed | 0.34 ± 0.7% | 0.53 ± 4.4% | not timed | not timed | 1.20 ± 1.0% | | 1.00 | 3.54 | 2.28 |
| 04-ruff-noqa/compile-real | 1 | 104.56 ± 1.3% | not timed | not timed | 13.73 ± 0.5% | 135.48 ± 3.3% | not timed | not timed | 104.74 ± 1.2% | | 1.00 | 7.61 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 13.90 ± 1.7% | not timed | not timed | 2.49 ± 0.5% | 6.20 ± 2.7% | not timed | not timed | 13.92 ± 1.3% | | 1.00 | 5.57 | 2.24 |
| 07-unicode-character-data/compile | 1 | 106.49 ± 1.4% | not timed | not timed | 25.92 ± 1.0% | 34.82 ± 3.3% | not timed | not timed | 107.24 ± 0.6% | | 0.99 | 4.11 | 3.06 |
| 09-aws-keys/compile-full | 1 | 52.75 ± 0.4% | not timed | not timed | 8.30 ± 0.6% | 22.55 ± 1.7% | not timed | not timed | 52.88 ± 0.4% | | 1.00 | 6.36 | 2.34 |
| 09-aws-keys/compile-quick | 1 | 182.89 ± 0.8% | not timed | not timed | 47.95 ± 0.4% | 128.00 ± 2.2% | not timed | not timed | 183.07 ± 0.8% | | 1.00 | 3.81 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 71.13 ± 2.2% | not timed | not timed | 11.19 ± 0.3% | 15.33 ± 2.6% | not timed | not timed | 71.68 ± 1.4% | | 0.99 | 6.36 | 4.64 |
| 10-bounded-repeat/compile-capitals | 1 | 84.33 ± 0.5% | not timed | not timed | 8.02 ± 0.4% | 22.53 ± 3.2% | not timed | not timed | 84.02 ± 0.9% | | 1.00 | 10.52 | 3.74 |
| 11-unstructured-to-json/compile | 1 | 168.78 ± 0.7% | not timed | not timed | 40.63 ± 0.7% | 65.61 ± 3.2% | not timed | not timed | 169.42 ± 1.0% | | 1.00 | 4.15 | 2.57 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.8% | not timed | not timed | 0.07 ± 15.4% | 0.10 ± 16.5% | not timed | not timed | 0.34 ± 2.9% | | 1.00 | 5.06 | 3.56 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.52 ± 5.5% | not timed | not timed | 6.47 ± 0.2% | 0.55 ± 18.8% | not timed | not timed | 7.51 ± 1.2% | | 1.00 | 1.16 | 13.60 |
| dictionary/search/english-10 | 690 | 1.04 ± 1.6% | not timed | not timed | 164.67 ± 1.2% | 0.00 ± 0.2% | not timed | not timed | 1.04 ± 0.7% | | 1.00 | 0.0063 | 419.90 |
| dictionary/search/english-15 | 15 | 558.21 ± 0.4% | not timed | not timed | 561.13 ± 0.2% | 0.37 ± 0.2% | not timed | not timed | 559.96 ± 0.3% | | 1.00 | 0.99 | 1523.20 |
| folly/awyer-inn-busted | 1 | 5580.31 ± 0.7% | not timed | not timed | 142.64 ± 0.6% | 43.79 ± 0.5% | not timed | not timed | 5565.79 ± 0.2% | | 1.00 | 39.12 | 127.42 |
| folly/literal-never-match-rare | 0 | 21039.54 ± 0.3% | not timed | not timed | 19832.39 ± 0.4% | 40724.81 ± 0.3% | not timed | not timed | 21052.63 ± 0.1% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12499.55 ± 0.9% | not timed | not timed | 19786.38 ± 0.4% | 2189.79 ± 0.9% | not timed | not timed | 12500.96 ± 0.3% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3248.04 ± 0.3% | not timed | not timed | 4348.45 ± 1.2% | 2996.76 ± 2.2% | not timed | not timed | 3244.68 ± 0.5% | | 1.00 | 0.75 | 1.08 |
| grep/every-line | 239963 | 1300.25 ± 0.6% | not timed | not timed | 927.35 ± 0.6% | 377.12 ± 20.1% | not timed | not timed | 1306.18 ± 1.5% | | 1.00 | 1.40 | 3.45 |
| grep/long-words-ascii | 5073 | 457.97 ± 0.3% | not timed | not timed | 467.81 ± 0.1% | 46.16 ± 8.4% | not timed | not timed | 458.79 ± 0.4% | | 1.00 | 0.98 | 9.92 |
| imported/leipzig/twain | 811 | 20560.50 ± 4.5% | not timed | not timed | 19459.89 ± 0.8% | 11790.57 ± 11.6% | not timed | not timed | 20595.00 ± 0.5% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9018.88 ± 1.2% | not timed | not timed | 4239.59 ± 0.1% | 37.71 ± 0.1% | not timed | not timed | 9085.51 ± 1.2% | | 0.99 | 2.13 | 239.17 |
| imported/leipzig/shing | 1540 | 628.74 ± 0.4% | not timed | not timed | 13190.48 ± 17.6% | 34.00 ± 0.1% | not timed | not timed | 630.95 ± 0.3% | | 1.00 | 0.0477 | 18.49 |
| imported/leipzig/huck-saw | 262 | 8221.50 ± 3.0% | not timed | not timed | 5576.96 ± 0.7% | 31.75 ± 0.1% | not timed | not timed | 8347.93 ± 2.7% | | 0.98 | 1.47 | 258.96 |
| imported/leipzig/word-ending-nn | 262 | 607.63 ± 0.3% | not timed | not timed | 614.40 ± 0.3% | 24.62 ± 0.6% | not timed | not timed | 609.99 ± 0.2% | | 1.00 | 0.99 | 24.68 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10984.35 ± 1.0% | not timed | not timed | 4481.49 ± 0.8% | 11.49 ± 0.2% | not timed | not timed | 11042.64 ± 3.6% | | 0.99 | 2.45 | 955.95 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7790.29 ± 2.3% | not timed | not timed | 5474.09 ± 0.2% | 16.86 ± 0.1% | not timed | not timed | 7879.21 ± 3.2% | | 0.99 | 1.42 | 462.04 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4170.09 ± 1.5% | not timed | not timed | 417.97 ± 1.5% | 11.08 ± 0.1% | not timed | not timed | 4168.90 ± 1.2% | | 1.00 | 9.98 | 376.27 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 608.23 ± 1.1% | not timed | not timed | 613.58 ± 0.3% | 11.11 ± 0.1% | not timed | not timed | 608.65 ± 0.4% | | 1.00 | 0.99 | 54.77 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.53 ± 0.2% | not timed | not timed | 614.10 ± 0.2% | 9.68 ± 0.1% | not timed | not timed | 608.95 ± 0.1% | | 1.00 | 0.99 | 62.89 |
| imported/leipzig/tom-river | 2 | 6480.20 ± 2.2% | not timed | not timed | 5140.30 ± 0.7% | 31.04 ± 0.2% | not timed | not timed | 6574.93 ± 2.6% | | 0.99 | 1.26 | 208.77 |
| imported/leipzig/ing | 78424 | 607.29 ± 0.6% | not timed | not timed | 569.46 ± 0.2% | 28.16 ± 3.4% | not timed | not timed | 605.53 ± 0.6% | | 1.00 | 1.07 | 21.57 |
| imported/leipzig/ing-whitespace | 55248 | 755.80 ± 1.2% | not timed | not timed | 2067.05 ± 0.6% | 20.52 ± 2.9% | not timed | not timed | 754.87 ± 1.1% | | 1.00 | 0.37 | 36.84 |
| imported/leipzig/awyer-inn | 209 | 772.93 ± 1.6% | not timed | not timed | 4237.60 ± 0.9% | 22.68 ± 0.1% | not timed | not timed | 773.45 ± 1.4% | | 1.00 | 0.18 | 34.07 |
| imported/leipzig/quotes-bounded | 8886 | 2110.74 ± 0.5% | not timed | not timed | 2966.06 ± 1.1% | 38.20 ± 0.2% | not timed | not timed | 2109.31 ± 0.6% | | 1.00 | 0.71 | 55.26 |
| imported/leipzig/non-ascii-alternate | 2 | 12736.16 ± 2.1% | not timed | not timed | 5641.69 ± 0.8% | 50.69 ± 0.1% | not timed | not timed | 12943.99 ± 3.0% | | 0.98 | 2.26 | 251.26 |
| imported/leipzig/math-symbols | 69 | 1970.12 ± 0.6% | not timed | not timed | 617.67 ± 0.1% | 36.39 ± 0.3% | not timed | not timed | 1970.10 ± 0.3% | | 1.00 | 3.19 | 54.13 |
| imported/leipzig/bounded-strings-ending-z | 0 | 593.19 ± 0.3% | not timed | not timed | 617.08 ± 0.2% | 22.49 ± 0.1% | not timed | not timed | 591.37 ± 0.4% | | 1.00 | 0.96 | 26.37 |
| imported/lh3lh3-reb/uri | 17549 | 630.29 ± 0.2% | not timed | not timed | 1068.20 ± 0.3% | 28.22 ± 2.3% | not timed | not timed | 631.93 ± 0.1% | | 1.00 | 0.59 | 22.34 |
| imported/lh3lh3-reb/email | 15057 | 665.74 ± 0.3% | not timed | not timed | 1163.34 ± 0.2% | 31.00 ± 0.8% | not timed | not timed | 667.30 ± 0.1% | | 1.00 | 0.57 | 21.47 |
| imported/lh3lh3-reb/date | 668 | 863.52 ± 0.8% | not timed | not timed | 1032.83 ± 0.2% | 51.12 ± 3.7% | not timed | not timed | 862.32 ± 1.1% | | 1.00 | 0.84 | 16.89 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 640.01 ± 0.5% | not timed | not timed | 419.76 ± 0.1% | 15.80 ± 1.2% | not timed | not timed | 640.93 ± 0.2% | | 1.00 | 1.52 | 40.49 |
| imported/mariomka/email | 92 | 704.43 ± 0.1% | not timed | not timed | 29286.65 ± 0.6% | 32.78 ± 0.1% | not timed | not timed | 704.44 ± 0.3% | | 1.00 | 0.0241 | 21.49 |
| imported/mariomka/uri | 5301 | 607.59 ± 0.1% | not timed | not timed | 6037.47 ± 0.5% | 32.59 ± 0.4% | not timed | not timed | 604.60 ± 0.1% | | 1.00 | 0.10 | 18.65 |
| imported/mariomka/ip | 5 | 2145.17 ± 2.2% | not timed | not timed | 2958.28 ± 0.4% | 21.04 ± 0.3% | not timed | not timed | 2146.62 ± 2.3% | | 1.00 | 0.73 | 101.97 |
| imported/rsc/no-exponential | 0 | 562.49 ± 0.4% | not timed | not timed | 323.07 ± 0.5% | 23.79 ± 0.6% | not timed | not timed | 562.44 ± 0.2% | | 1.00 | 1.74 | 23.65 |
| imported/rsc/literal | 1 | 743.31 ± 9.3% | not timed | not timed | 1637.87 ± 1.9% | 183.93 ± 17.0% | not timed | not timed | 742.94 ± 5.3% | | 1.00 | 0.45 | 4.04 |
| imported/rsc/not-literal | 2 | 707.36 ± 1.5% | not timed | not timed | 726.07 ± 0.6% | 46.26 ± 8.4% | not timed | not timed | 706.03 ± 0.1% | | 1.00 | 0.97 | 15.29 |
| imported/rsc/match-class | 1 | 1308.20 ± 0.3% | not timed | not timed | 1613.52 ± 0.3% | 58.58 ± 13.8% | not timed | not timed | 1300.07 ± 2.0% | | 1.01 | 0.81 | 22.33 |
| imported/rsc/match-class-in-range | 1 | 1300.70 ± 8.2% | not timed | not timed | 2284.65 ± 2.9% | 59.99 ± 1.5% | not timed | not timed | 1312.43 ± 0.8% | | 0.99 | 0.57 | 21.68 |
| imported/rsc/match-class-unicode | 1 | 524.87 ± 6.8% | not timed | not timed | 510.72 ± 0.2% | 72.53 ± 2.2% | not timed | not timed | 523.86 ± 0.1% | | 1.00 | 1.03 | 7.24 |
| imported/rsc/anchored-literal-short-non-match | 0 | 534.50 ± 0.9% | not timed | not timed | 952.49 ± 0.3% | 226.81 ± 0.6% | not timed | not timed | 533.18 ± 0.6% | | 1.00 | 0.56 | 2.36 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7956.88 ± 0.8% | not timed | not timed | 14380.98 ± 0.5% | 3404.31 ± 0.8% | not timed | not timed | 7949.40 ± 0.5% | | 1.00 | 0.55 | 2.34 |
| imported/rsc/anchored-literal-short-match | 4 | 420.31 ± 1.9% | not timed | not timed | 488.73 ± 0.2% | 84.12 ± 10.1% | not timed | not timed | 421.30 ± 2.5% | | 1.00 | 0.86 | 5.00 |
| imported/rsc/anchored-literal-long-match | 4 | 2955.86 ± 2.3% | not timed | not timed | 7314.42 ± 0.2% | 1233.63 ± 1.8% | not timed | not timed | 3016.77 ± 2.5% | | 0.98 | 0.40 | 2.40 |
| imported/rsc/one-pass-short | 17 | 310.95 ± 1.9% | not timed | not timed | 216.89 ± 0.4% | 30.78 ± 11.0% | not timed | not timed | 310.25 ± 9.2% | | 1.00 | 1.43 | 10.10 |
| imported/rsc/one-pass-short-not | 17 | 218.75 ± 5.9% | not timed | not timed | 226.03 ± 0.2% | 30.48 ± 10.7% | not timed | not timed | 218.70 ± 2.0% | | 1.00 | 0.97 | 7.18 |
| imported/rsc/one-pass-long-prefix | 26 | 237.51 ± 8.0% | not timed | not timed | 280.62 ± 0.2% | 95.79 ± 12.6% | not timed | not timed | 234.58 ± 2.1% | | 1.01 | 0.85 | 2.48 |
| imported/rsc/one-pass-long-prefix-not | 26 | 314.34 ± 1.7% | not timed | not timed | 281.33 ± 0.2% | 65.59 ± 18.5% | not timed | not timed | 311.74 ± 1.7% | | 1.01 | 1.12 | 4.79 |
| imported/rsc/long-needle1 | 31 | 21867.93 ± 0.4% | not timed | not timed | 20125.27 ± 0.6% | 3.75 ± 0.2% | not timed | not timed | 21901.58 ± 0.9% | | 1.00 | 1.09 | 5823.69 |
| imported/rsc/long-needle2 | 31 | 22058.22 ± 0.2% | not timed | not timed | 216.01 ± 0.2% | 3.75 ± 0.2% | not timed | not timed | 22060.38 ± 0.3% | | 1.00 | 102.12 | 5879.20 |
| imported/rsc/easy0-32 | 26 | 1061.17 ± 2.6% | not timed | not timed | 1609.62 ± 1.3% | 146.11 ± 12.2% | not timed | not timed | 1060.25 ± 2.4% | | 1.00 | 0.66 | 7.26 |
| imported/rsc/easy0-1k | 26 | 14900.54 ± 2.1% | not timed | not timed | 12643.41 ± 0.2% | 2286.42 ± 13.5% | not timed | not timed | 14933.46 ± 1.8% | | 1.00 | 1.18 | 6.52 |
| imported/rsc/easy0-32k | 26 | 22916.64 ± 0.1% | not timed | not timed | 20373.84 ± 0.2% | 18816.27 ± 26.8% | not timed | not timed | 22901.98 ± 1.7% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21555.04 ± 4.8% | not timed | not timed | 19525.35 ± 2.6% | 37339.46 ± 4.7% | not timed | not timed | 21575.98 ± 3.4% | | 1.00 | 1.10 | 0.58 |
| imported/rsc/easy1-32 | 19 | 359.64 ± 1.8% | not timed | not timed | 645.29 ± 0.3% | 130.08 ± 14.0% | not timed | not timed | 360.11 ± 2.2% | | 1.00 | 0.56 | 2.76 |
| imported/rsc/easy1-1k | 19 | 583.80 ± 0.4% | not timed | not timed | 12824.01 ± 0.5% | 2463.28 ± 15.4% | not timed | not timed | 580.28 ± 2.8% | | 1.01 | 0.0455 | 0.24 |
| imported/rsc/easy1-32k | 19 | 602.53 ± 3.0% | not timed | not timed | 410403.70 ± 0.3% | 20392.03 ± 18.0% | not timed | not timed | 599.89 ± 0.7% | | 1.00 | 0.0015 | 0.0295 |
| imported/rsc/easy1-1mb | 19 | 602.45 ± 0.3% | not timed | not timed | 13102361.40 ± 0.3% | 38044.01 ± 2.4% | not timed | not timed | 600.35 ± 0.4% | | 1.00 | 0.0000 | 0.0158 |
| imported/rsc/medium-32 | 27 | 425.19 ± 1.2% | not timed | not timed | 635.10 ± 0.1% | 69.49 ± 13.7% | not timed | not timed | 426.01 ± 2.0% | | 1.00 | 0.67 | 6.12 |
| imported/rsc/medium-1k | 27 | 6743.33 ± 0.4% | not timed | not timed | 11387.05 ± 0.7% | 72.26 ± 0.2% | not timed | not timed | 6759.53 ± 0.3% | | 1.00 | 0.59 | 93.32 |
| imported/rsc/medium-32k | 27 | 21518.13 ± 0.2% | not timed | not timed | 357540.19 ± 0.3% | 48.56 ± 0.9% | not timed | not timed | 21540.69 ± 0.3% | | 1.00 | 0.0602 | 443.10 |
| imported/rsc/medium-1mb | 27 | 20921.43 ± 2.3% | not timed | not timed | 11426636.81 ± 0.7% | 46.95 ± 0.1% | not timed | not timed | 20952.60 ± 2.1% | | 1.00 | 0.0018 | 445.57 |
| imported/rsc/hard-32 | 58 | 255.06 ± 0.2% | not timed | not timed | 366.42 ± 0.4% | 49.33 ± 9.9% | not timed | not timed | 255.36 ± 2.9% | | 1.00 | 0.70 | 5.17 |
| imported/rsc/hard-1k | 27 | 576.92 ± 0.3% | not timed | not timed | 11586.10 ± 0.2% | 40.74 ± 0.3% | not timed | not timed | 574.87 ± 0.1% | | 1.00 | 0.0498 | 14.16 |
| imported/rsc/hard-32k | 27 | 601.62 ± 0.3% | not timed | not timed | 364541.52 ± 0.4% | 29.29 ± 0.2% | not timed | not timed | 598.87 ± 0.4% | | 1.00 | 0.0017 | 20.54 |
| imported/rsc/hard-1mb | 51 | 602.75 ± 0.3% | not timed | not timed | 7194225.70 ± 0.2% | 29.35 ± 0.2% | not timed | not timed | 599.63 ± 0.4% | | 1.01 | 0.0001 | 20.54 |
| imported/rsc/reallyhard0-32 | 58 | 253.59 ± 10.0% | not timed | not timed | 219.46 ± 0.2% | 49.57 ± 16.3% | not timed | not timed | 254.45 ± 0.2% | | 1.00 | 1.16 | 5.12 |
| imported/rsc/reallyhard0-1k | 27 | 575.71 ± 0.3% | not timed | not timed | 579.47 ± 0.1% | 40.65 ± 0.3% | not timed | not timed | 579.27 ± 0.3% | | 0.99 | 0.99 | 14.16 |
| imported/rsc/reallyhard0-32k | 27 | 600.64 ± 0.2% | not timed | not timed | 616.28 ± 0.1% | 29.32 ± 0.3% | not timed | not timed | 603.19 ± 0.5% | | 1.00 | 0.97 | 20.49 |
| imported/rsc/reallyhard0-1mb | 51 | 593.94 ± 1.1% | not timed | not timed | 616.71 ± 0.3% | 29.35 ± 0.1% | not timed | not timed | 593.04 ± 1.2% | | 1.00 | 0.96 | 20.24 |
| imported/rsc/reallyreallyhard0-32 | 47 | 273.37 ± 11.4% | not timed | not timed | 195.44 ± 0.7% | 60.77 ± 7.7% | not timed | not timed | 273.61 ± 0.1% | | 1.00 | 1.40 | 4.50 |
| imported/rsc/reallyreallyhard0-1k | 16 | 868.74 ± 4.8% | not timed | not timed | 5960.59 ± 0.2% | 34.29 ± 1.0% | not timed | not timed | 856.25 ± 4.9% | | 1.01 | 0.15 | 25.34 |
| imported/rsc/reallyreallyhard0-32k | 16 | 623.53 ± 3.4% | not timed | not timed | 19274.89 ± 0.2% | 24.93 ± 1.3% | not timed | not timed | 619.90 ± 4.8% | | 1.01 | 0.0323 | 25.01 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 592.25 ± 0.4% | not timed | not timed | 20040.29 ± 2.6% | 25.14 ± 0.7% | not timed | not timed | 588.99 ± 0.2% | | 1.01 | 0.0296 | 23.56 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 268.38 ± 0.2% | not timed | not timed | 211.64 ± 0.1% | 60.40 ± 12.3% | not timed | not timed | 268.22 ± 3.3% | | 1.00 | 1.27 | 4.44 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 840.83 ± 2.8% | not timed | not timed | 5793.47 ± 0.1% | 34.26 ± 0.2% | not timed | not timed | 841.69 ± 2.7% | | 1.00 | 0.15 | 24.54 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 622.52 ± 5.2% | not timed | not timed | 19125.71 ± 0.2% | 24.69 ± 1.9% | not timed | not timed | 629.13 ± 4.6% | | 0.99 | 0.0325 | 25.21 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 588.61 ± 0.3% | not timed | not timed | 19334.63 ± 3.1% | 24.73 ± 3.0% | not timed | not timed | 592.61 ± 0.6% | | 0.99 | 0.0304 | 23.80 |
| imported/sherlock/name-sherlock | 776 | 19986.32 ± 2.4% | not timed | not timed | 18697.59 ± 0.2% | 9998.33 ± 30.2% | not timed | not timed | 19986.36 ± 2.3% | | 1.00 | 1.07 | 2.00 |
| imported/sherlock/name-holmes | 2766 | 15155.66 ± 1.8% | not timed | not timed | 15555.02 ± 0.5% | 3236.68 ± 9.0% | not timed | not timed | 15356.85 ± 1.7% | | 0.99 | 0.97 | 4.68 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19946.63 ± 2.2% | not timed | not timed | 18675.84 ± 0.4% | 7950.83 ± 24.2% | not timed | not timed | 20037.54 ± 4.0% | | 1.00 | 1.07 | 2.51 |
| imported/sherlock/name-sherlock-casei | 816 | 15759.49 ± 0.6% | not timed | not timed | 4009.00 ± 0.2% | 32.49 ± 0.6% | not timed | not timed | 15775.94 ± 0.3% | | 1.00 | 3.93 | 485.01 |
| imported/sherlock/name-holmes-casei | 2802 | 9412.71 ± 4.8% | not timed | not timed | 3318.02 ± 0.4% | 37.54 ± 0.4% | not timed | not timed | 9346.92 ± 4.1% | | 1.01 | 2.84 | 250.77 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13019.25 ± 3.9% | not timed | not timed | 3938.63 ± 0.1% | 32.46 ± 0.5% | not timed | not timed | 13045.56 ± 1.4% | | 1.00 | 3.31 | 401.03 |
| imported/sherlock/name-whitespace | 1461 | 15237.36 ± 0.3% | not timed | not timed | 14556.07 ± 0.4% | 7315.70 ± 25.7% | not timed | not timed | 15151.11 ± 2.7% | | 1.01 | 1.05 | 2.08 |
| imported/sherlock/name-alt1 | 1142 | 11460.62 ± 3.0% | not timed | not timed | 16583.17 ± 1.1% | 4109.21 ± 44.6% | not timed | not timed | 11446.71 ± 0.3% | | 1.00 | 0.69 | 2.79 |
| imported/sherlock/name-alt2 | 3542 | 8609.23 ± 0.4% | not timed | not timed | 3820.95 ± 0.4% | 31.17 ± 0.2% | not timed | not timed | 8566.95 ± 0.3% | | 1.00 | 2.25 | 276.25 |
| imported/sherlock/name-alt3 | 4507 | 5437.19 ± 0.4% | not timed | not timed | 3620.00 ± 0.3% | 9.94 ± 4.8% | not timed | not timed | 5421.15 ± 0.3% | | 1.00 | 1.50 | 547.19 |
| imported/sherlock/name-alt3-casei | 4593 | 1505.67 ± 2.2% | not timed | not timed | 284.99 ± 0.3% | 6.46 ± 0.1% | not timed | not timed | 1507.29 ± 1.1% | | 1.00 | 5.28 | 233.14 |
| imported/sherlock/name-alt4 | 3686 | 6173.94 ± 0.2% | not timed | not timed | 3785.86 ± 0.3% | 31.20 ± 0.1% | not timed | not timed | 6159.04 ± 0.2% | | 1.00 | 1.63 | 197.86 |
| imported/sherlock/name-alt4-casei | 4254 | 2741.00 ± 4.1% | not timed | not timed | 2591.10 ± 0.3% | 19.83 ± 20.1% | not timed | not timed | 2749.54 ± 1.1% | | 1.00 | 1.06 | 138.19 |
| imported/sherlock/name-alt5 | 4028 | 6225.32 ± 0.5% | not timed | not timed | 3736.10 ± 0.2% | 21.69 ± 0.1% | not timed | not timed | 6202.48 ± 0.5% | | 1.00 | 1.67 | 287.02 |
| imported/sherlock/name-alt5-casei | 4104 | 3434.44 ± 2.2% | not timed | not timed | 2227.52 ± 0.3% | 14.36 ± 0.1% | not timed | not timed | 3443.67 ± 1.2% | | 1.00 | 1.54 | 239.09 |
| imported/sherlock/no-match-uncommon | 0 | 21888.59 ± 0.2% | not timed | not timed | 19807.53 ± 0.2% | 37334.77 ± 1.7% | not timed | not timed | 21842.50 ± 0.4% | | 1.00 | 1.11 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21689.93 ± 0.5% | not timed | not timed | 19765.37 ± 0.4% | 1273.10 ± 1.4% | not timed | not timed | 21709.88 ± 0.2% | | 1.00 | 1.10 | 17.04 |
| imported/sherlock/no-match-really-common | 0 | 16305.94 ± 2.2% | not timed | not timed | 18896.95 ± 0.8% | 1272.89 ± 0.8% | not timed | not timed | 16407.70 ± 3.2% | | 0.99 | 0.86 | 12.81 |
| imported/sherlock/the-lower | 21654 | 2309.77 ± 1.4% | not timed | not timed | 2332.44 ± 0.5% | 238.33 ± 18.4% | not timed | not timed | 2320.66 ± 1.1% | | 1.00 | 0.99 | 9.69 |
| imported/sherlock/the-upper | 2223 | 12683.82 ± 2.3% | not timed | not timed | 13608.15 ± 0.5% | 2631.88 ± 18.5% | not timed | not timed | 12838.13 ± 2.4% | | 0.99 | 0.93 | 4.82 |
| imported/sherlock/the-casei | 23961 | 2014.55 ± 0.4% | not timed | not timed | 1315.50 ± 0.5% | 34.94 ± 38.7% | not timed | not timed | 2012.13 ± 1.1% | | 1.00 | 1.53 | 57.66 |
| imported/sherlock/everything-greedy | 581881 | 270.29 ± 0.9% | not timed | not timed | 164.33 ± 0.1% | 28.87 ± 29.8% | not timed | not timed | 270.72 ± 0.2% | | 1.00 | 1.64 | 9.36 |
| imported/sherlock/everything-greedy-nl | 594933 | 460.99 ± 0.4% | not timed | not timed | 212.72 ± 0.2% | 32.89 ± 0.1% | not timed | not timed | 462.44 ± 0.2% | | 1.00 | 2.17 | 14.01 |
| imported/sherlock/letters | 447175 | 54.34 ± 0.5% | not timed | not timed | 32.96 ± 0.8% | 6.62 ± 2.5% | not timed | not timed | 54.23 ± 1.2% | | 1.00 | 1.65 | 8.21 |
| imported/sherlock/letters-upper | 14180 | 433.07 ± 1.5% | not timed | not timed | 370.76 ± 0.2% | 29.30 ± 22.5% | not timed | not timed | 434.10 ± 0.2% | | 1.00 | 1.17 | 14.78 |
| imported/sherlock/letters-lower | 432995 | 55.30 ± 0.7% | not timed | not timed | 33.78 ± 0.1% | 5.20 ± 34.7% | not timed | not timed | 55.37 ± 0.9% | | 1.00 | 1.64 | 10.63 |
| imported/sherlock/words | 447639 | 106.48 ± 1.5% | not timed | not timed | 83.08 ± 0.6% | 13.55 ± 1.6% | not timed | not timed | 106.97 ± 0.8% | | 1.00 | 1.28 | 7.86 |
| imported/sherlock/before-holmes | 4073 | 598.61 ± 0.5% | not timed | not timed | 8472.20 ± 0.2% | 23.98 ± 0.9% | not timed | not timed | 595.60 ± 0.2% | | 1.01 | 0.0707 | 24.96 |
| imported/sherlock/before-after-holmes | 2593 | 596.31 ± 0.2% | not timed | not timed | 9547.42 ± 0.6% | 23.64 ± 1.9% | not timed | not timed | 596.96 ± 0.2% | | 1.00 | 0.0625 | 25.23 |
| imported/sherlock/holmes-cochar-watson | 150 | 5208.81 ± 0.3% | not timed | not timed | 3418.86 ± 0.3% | 31.01 ± 0.2% | not timed | not timed | 5192.59 ± 0.2% | | 1.00 | 1.52 | 167.97 |
| imported/sherlock/holmes-coword-watson | 14309 | 1256.45 ± 0.6% | not timed | not timed | 1122.37 ± 0.4% | 6.77 ± 0.0% | not timed | not timed | 1258.53 ± 0.8% | | 1.00 | 1.12 | 185.65 |
| imported/sherlock/quotes | 14437 | 1413.05 ± 0.5% | not timed | not timed | 1716.25 ± 0.5% | 35.02 ± 0.3% | not timed | not timed | 1397.73 ± 0.3% | | 1.01 | 0.82 | 40.35 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 600.27 ± 0.4% | not timed | not timed | 16230.80 ± 0.1% | 36.73 ± 0.3% | not timed | not timed | 600.79 ± 0.9% | | 1.00 | 0.0370 | 16.34 |
| imported/sherlock/word-ending-n | 35297 | 468.12 ± 1.0% | not timed | not timed | 407.59 ± 1.2% | 23.51 ± 20.4% | not timed | not timed | 467.02 ± 1.2% | | 1.00 | 1.15 | 19.91 |
| imported/sherlock/repeated-class-negation | 2130 | 14685.29 ± 0.7% | not timed | not timed | 10829.32 ± 0.8% | 11.55 ± 0.4% | not timed | not timed | 14696.04 ± 0.4% | | 1.00 | 1.36 | 1271.15 |
| imported/sherlock/ing-suffix | 20547 | 552.90 ± 0.5% | not timed | not timed | 515.56 ± 0.2% | 28.84 ± 0.3% | not timed | not timed | 552.95 ± 0.2% | | 1.00 | 1.07 | 19.17 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 593.82 ± 0.2% | not timed | not timed | 2098.64 ± 0.7% | 19.98 ± 0.3% | not timed | not timed | 592.86 ± 0.4% | | 1.00 | 0.28 | 29.72 |
| opt/accelerate/whole-line | 239963 | 457.02 ± 0.4% | not timed | not timed | 372.22 ± 0.2% | 92.23 ± 17.8% | not timed | not timed | 457.78 ± 0.1% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 412.72 ± 1.0% | not timed | not timed | 397.75 ± 0.2% | 29.39 ± 21.2% | not timed | not timed | 410.41 ± 0.9% | | 1.01 | 1.04 | 14.05 |
| opt/backtrack/words-english | 40536 | 136.78 ± 0.2% | not timed | not timed | 94.56 ± 0.7% | 19.89 ± 6.0% | not timed | not timed | 136.69 ± 6.9% | | 1.00 | 1.45 | 6.88 |
| opt/fixed-length/too-small-ascii | 0 | 311.71 ± 0.2% | not timed | not timed | 708.76 ± 0.8% | 79.35 ± 1.2% | not timed | not timed | 315.56 ± 0.2% | | 0.99 | 0.44 | 3.93 |
| opt/fixed-length/too-big-ascii | 0 | 646.83 ± 0.5% | not timed | not timed | 5802.78 ± 0.3% | 111.89 ± 9.1% | not timed | not timed | 650.14 ± 1.0% | | 0.99 | 0.11 | 5.78 |
| opt/fixed-length/go33484-1 | 0 | 45.38 ± 0.3% | not timed | not timed | 1117465.65 ± 0.3% | 61236.97 ± 0.6% | not timed | not timed | 45.45 ± 0.1% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5522.07 ± 0.4% | not timed | not timed | 1101348.43 ± 0.4% | 32267.05 ± 1.4% | not timed | not timed | 5511.39 ± 0.3% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1778.39 ± 0.3% | not timed | not timed | 111919.87 ± 0.6% | 761.19 ± 0.3% | not timed | not timed | 1779.74 ± 1.8% | | 1.00 | 0.0159 | 2.34 |
| opt/literal-alt/one-pattern | 1 | 550.07 ± 0.2% | not timed | not timed | 539.07 ± 0.3% | 0.39 ± 0.3% | not timed | not timed | 555.02 ± 0.3% | | 0.99 | 1.02 | 1409.35 |
| opt/onepass/fn-predicate | 916 | 367.12 ± 1.4% | not timed | not timed | 330.78 ± 0.2% | 199.23 ± 18.3% | not timed | not timed | 368.13 ± 0.5% | | 1.00 | 1.11 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 149.59 ± 8.6% | not timed | not timed | 200.43 ± 0.4% | 81.32 ± 16.0% | not timed | not timed | 149.36 ± 2.0% | | 1.00 | 0.75 | 1.84 |
| opt/prefilter/literal-english | 1 | 20956.84 ± 0.3% | not timed | not timed | 20154.60 ± 0.3% | 17690.21 ± 0.6% | not timed | not timed | 20986.81 ± 0.3% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14558.41 ± 0.5% | not timed | not timed | 4299.61 ± 0.3% | 32.76 ± 0.3% | not timed | not timed | 14572.94 ± 0.5% | | 1.00 | 3.39 | 444.46 |
| opt/prefilter/literal-russian | 1 | 21185.67 ± 0.5% | not timed | not timed | 19716.90 ± 0.6% | 3311.42 ± 0.3% | not timed | not timed | 21160.59 ± 0.7% | | 1.00 | 1.07 | 6.40 |
| opt/prefilter/literal-casei-russian | 1 | 8550.98 ± 0.5% | not timed | not timed | 3881.02 ± 0.3% | 30.89 ± 0.6% | not timed | not timed | 8560.85 ± 0.2% | | 1.00 | 2.20 | 276.84 |
| opt/prefilter/rust-functions | 948 | 6790.99 ± 0.6% | not timed | not timed | 8930.53 ± 0.3% | 1870.10 ± 0.1% | not timed | not timed | 6791.86 ± 0.6% | | 1.00 | 0.76 | 3.63 |
| opt/reverse-anchored/word-end | 1 | 5575.25 ± 0.5% | not timed | not timed | 21548642.85 ± 1.1% | 50.41 ± 0.3% | not timed | not timed | 5576.84 ± 0.3% | | 1.00 | 0.0003 | 110.60 |
| opt/reverse-inner/holmes | 2593 | 594.91 ± 0.4% | not timed | not timed | 9533.46 ± 0.4% | 23.93 ± 0.3% | not timed | not timed | 596.87 ± 0.2% | | 1.00 | 0.0624 | 24.86 |
| opt/reverse-inner/email | 47 | 1043.67 ± 0.2% | not timed | not timed | 44243.74 ± 1.0% | 32.39 ± 0.2% | not timed | not timed | 1042.23 ± 0.1% | | 1.00 | 0.0236 | 32.22 |
| opt/reverse-inner/factored-prefix | 3542 | 590.67 ± 0.3% | not timed | not timed | 594.09 ± 0.2% | 12.54 ± 0.2% | not timed | not timed | 591.31 ± 0.3% | | 1.00 | 0.99 | 47.11 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5501.17 ± 0.1% | not timed | not timed | 615.19 ± 0.5% | 75.08 ± 0.3% | not timed | not timed | 5511.99 ± 0.1% | | 1.00 | 8.94 | 73.27 |
| opt/reverse-inner/no-quadratic-forward | 0 | 714.20 ± 7.4% | not timed | not timed | 288.07 ± 0.2% | 24.79 ± 0.1% | not timed | not timed | 736.38 ± 5.6% | | 0.97 | 2.48 | 28.81 |
| opt/reverse-suffix/holmes | 4073 | 596.81 ± 0.9% | not timed | not timed | 8481.34 ± 0.2% | 23.88 ± 1.3% | not timed | not timed | 596.02 ± 0.3% | | 1.00 | 0.0704 | 24.99 |
| opt/reverse-suffix/no-quadratic | 0 | 5509.76 ± 0.3% | not timed | not timed | 613.61 ± 0.2% | 74.96 ± 0.1% | not timed | not timed | 5497.56 ± 0.1% | | 1.00 | 8.98 | 73.50 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.08 ± 2.8% | not timed | not timed | 131.65 ± 0.2% | 13.17 ± 15.9% | not timed | not timed | 120.79 ± 2.9% | | 0.99 | 0.91 | 9.12 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 118.92 ± 1.9% | not timed | not timed | 131.52 ± 0.1% | 13.12 ± 15.3% | not timed | not timed | 120.56 ± 0.5% | | 0.99 | 0.90 | 9.06 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.22 ± 0.4% | not timed | not timed | 0.55 ± 0.3% | 110.00 ± 2.2% | not timed | not timed | 0.22 ± 0.3% | | 1.00 | 0.40 | 0.0020 |
| reported/i1095-word-repetition/ascii-search | 256 | 315.73 ± 0.1% | not timed | not timed | 294.38 ± 0.1% | 103.28 ± 8.9% | not timed | not timed | 308.90 ± 3.3% | | 1.02 | 1.07 | 3.06 |
| reported/i13-subset-regex/original-ascii | 4094 | 11029.68 ± 1.4% | not timed | not timed | 4484.44 ± 0.9% | 11.49 ± 0.2% | not timed | not timed | 11039.12 ± 0.8% | | 1.00 | 2.46 | 959.95 |
| reported/i13-subset-regex/original-unicode | 4094 | 10907.05 ± 1.2% | not timed | not timed | 250.59 ± 3.3% | 11.50 ± 0.1% | not timed | not timed | 11040.64 ± 1.5% | | 0.99 | 43.53 | 948.68 |
| reported/i13-subset-regex/big-ascii | 1955 | 10639.28 ± 0.7% | not timed | not timed | 68.07 ± 3.6% | 9.85 ± 0.1% | not timed | not timed | 10709.33 ± 1.5% | | 0.99 | 156.31 | 1080.63 |
| reported/i13-subset-regex/big-unicode | 1955 | 10542.17 ± 1.3% | not timed | not timed | 12.27 ± 55.0% | 9.85 ± 0.1% | not timed | not timed | 10663.59 ± 1.2% | | 0.99 | 858.87 | 1070.35 |
| reported/i13-subset-regex/huge-ascii | 55 | 10075.32 ± 2.8% | not timed | not timed | 11.03 ± 0.1% | 8.74 ± 0.1% | not timed | not timed | 10053.73 ± 2.7% | | 1.00 | 913.75 | 1152.38 |
| reported/i13-subset-regex/huge-unicode | 55 | 10044.02 ± 3.1% | not timed | not timed | 10.99 ± 0.4% | 8.75 ± 0.1% | not timed | not timed | 9804.73 ± 3.6% | | 1.02 | 914.11 | 1147.55 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.00 ± 0.2% | 8.75 ± 0.4% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.02 ± 0.0% | not timed | not timed | 10.98 ± 0.5% | 8.73 ± 1.1% | not timed | not timed | 5.01 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 468.53 ± 0.6% | not timed | not timed | 104.64 ± 0.3% | 6.30 ± 0.6% | not timed | not timed | 466.21 ± 0.6% | | 1.00 | 4.48 | 74.32 |
| reported/i787-keywords/opt-ascii | 5674 | 470.66 ± 0.3% | not timed | not timed | 270.75 ± 0.5% | 10.25 ± 0.4% | not timed | not timed | 469.40 ± 0.5% | | 1.00 | 1.74 | 45.93 |
| slow/quadratic-regex-1x | 100 | 6.95 ± 0.2% | not timed | not timed | 4.93 ± 0.5% | 0.05 ± 0.3% | not timed | not timed | 6.94 ± 0.4% | | 1.00 | 1.41 | 141.26 |
| slow/quadratic-regex-2x | 199 | 3.39 ± 0.1% | not timed | not timed | 2.75 ± 0.1% | 0.01 ± 0.3% | not timed | not timed | 3.40 ± 0.1% | | 1.00 | 1.23 | 266.83 |
| slow/quadratic-haystack-1x | 100 | 21.19 ± 6.2% | not timed | not timed | 10.00 ± 1.2% | 1.01 ± 14.5% | not timed | not timed | 21.15 ± 1.9% | | 1.00 | 2.12 | 21.03 |
| slow/quadratic-haystack-2x | 200 | 17.38 ± 1.0% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 1.5% | not timed | not timed | 17.33 ± 13.2% | | 1.00 | 3.14 | 31.92 |
| unicode/codepoints/any-one | 1112064 | 284.49 ± 1.2% | not timed | not timed | 174.81 ± 0.7% | 18.16 ± 5.5% | not timed | not timed | 285.75 ± 0.7% | | 1.00 | 1.63 | 15.67 |
| unicode/codepoints/any-all | 4382592 | 288.08 ± 0.3% | not timed | not timed | 246.88 ± 0.2% | 113.34 ± 0.2% | not timed | not timed | 288.06 ± 0.2% | | 1.00 | 1.17 | 2.54 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 0.9% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 608.49 ± 0.3% | not timed | not timed | 613.79 ± 0.3% | 132.68 ± 0.3% | not timed | not timed | 609.42 ± 0.2% | | 1.00 | 0.99 | 4.59 |
| unicode/overlapping-words/ascii | 6156 | 31.67 ± 0.4% | not timed | not timed | 38.82 ± 0.5% | 3.91 ± 1.6% | not timed | not timed | 31.79 ± 0.7% | | 1.00 | 0.82 | 8.09 |
| unicode/overlapping-words/english | 6156 | 1.31 ± 0.4% | not timed | not timed | 4.46 ± 0.2% | 2.34 ± 0.2% | not timed | not timed | 1.32 ± 0.2% | | 0.99 | 0.29 | 0.56 |
| unicode/overlapping-words/russian | 5710 | 1.14 ± 9.6% | not timed | not timed | 4.08 ± 0.3% | 6.17 ± 9.9% | not timed | not timed | 1.12 ± 0.3% | | 1.02 | 0.28 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 116.14 ± 7.3% | not timed | not timed | 80.97 ± 0.4% | 11.74 ± 16.4% | not timed | not timed | 116.58 ± 0.5% | | 1.00 | 1.43 | 9.89 |
| unicode/word/boundary-long-english | 3466 | 605.35 ± 0.2% | not timed | not timed | 603.55 ± 0.2% | 32.55 ± 0.9% | not timed | not timed | 510.06 ± 0.9% | | 1.19 | 1.00 | 18.60 |
| unicode/word/around-holmes-english | 27 | 600.79 ± 0.5% | not timed | not timed | 19732.96 ± 0.3% | 22.03 ± 1.2% | not timed | not timed | 602.22 ± 0.5% | | 1.00 | 0.0304 | 27.27 |
| wild/bibleref/long | 874 | 560.27 ± 2.3% | not timed | not timed | 581.14 ± 0.6% | 6.79 ± 0.1% | not timed | not timed | 562.73 ± 0.4% | | 1.00 | 0.96 | 82.53 |
| wild/bibleref/short | 30 | 23.57 ± 3.3% | not timed | not timed | 30.44 ± 0.4% | 13.79 ± 12.8% | not timed | not timed | 24.08 ± 4.2% | | 0.98 | 0.77 | 1.71 |
| wild/bibleref/line | 874 | 357.19 ± 0.2% | not timed | not timed | 211.10 ± 0.3% | 9.21 ± 0.5% | not timed | not timed | 357.52 ± 0.2% | | 1.00 | 1.69 | 38.78 |
| wild/caddy/caddy | 6 | 413.83 ± 2.7% | not timed | not timed | 248.39 ± 0.2% | 65.87 ± 14.2% | not timed | not timed | 415.89 ± 0.4% | | 1.00 | 1.67 | 6.28 |
| wild/dot-star-capture/rust-src-tools | 6 | 1052.60 ± 0.4% | not timed | not timed | 343.79 ± 0.3% | 13.45 ± 0.1% | not timed | not timed | 1052.01 ± 0.7% | | 1.00 | 3.06 | 78.24 |
| wild/ruff/noqa | 84 | 403.10 ± 0.1% | not timed | not timed | 455.26 ± 0.3% | 19.51 ± 4.1% | not timed | not timed | 401.47 ± 0.8% | | 1.00 | 0.89 | 20.66 |
| wild/ruff/unnecessary-coding-comment | 16 | 487.72 ± 0.7% | not timed | not timed | 701.63 ± 0.1% | 134.60 ± 11.0% | not timed | not timed | 486.82 ± 0.6% | | 1.00 | 0.70 | 3.62 |
| wild/ruff/string-quote-prefix | 2972 | 405.77 ± 0.7% | not timed | not timed | 407.46 ± 0.2% | 314.61 ± 25.5% | not timed | not timed | 406.04 ± 0.7% | | 1.00 | 1.00 | 1.29 |
| wild/ruff/space-around-operator | 1224378 | 217.13 ± 1.9% | not timed | not timed | 186.22 ± 0.2% | 18.47 ± 1.8% | not timed | not timed | 217.10 ± 1.9% | | 1.00 | 1.17 | 11.76 |
| wild/ruff/shebang | 282 | 400.39 ± 0.6% | not timed | not timed | 327.61 ± 0.1% | 111.17 ± 12.8% | not timed | not timed | 400.08 ± 0.6% | | 1.00 | 1.22 | 3.60 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13755.83 ± 1.5% | not timed | not timed | 13770.67 ± 0.4% | 6904.26 ± 0.4% | not timed | not timed | 13788.73 ± 0.6% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12768.53 ± 0.2% | not timed | not timed | 13352.63 ± 0.8% | 6346.68 ± 1.1% | not timed | not timed | 12773.34 ± 0.8% | | 1.00 | 0.96 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13101.42 ± 0.5% | not timed | not timed | 13502.71 ± 0.6% | 6574.98 ± 0.8% | not timed | not timed | 13134.28 ± 0.6% | | 1.00 | 0.97 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9523.39 ± 0.4% | not timed | not timed | 13425.40 ± 0.6% | 6633.20 ± 0.9% | not timed | not timed | 9533.99 ± 0.2% | | 1.00 | 0.71 | 1.44 |
| wild/url/search | 234965 | 120.39 ± 12.8% | not timed | not timed | 64.70 ± 0.5% | 2.21 ± 0.6% | not timed | not timed | 121.03 ± 12.8% | | 0.99 | 1.86 | 54.54 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.7% | not timed | not timed | 0.01 ± 0.8% | 0.01 ± 29.3% | not timed | not timed | 0.03 ± 44.1% | | 1.00 | 3.09 | 4.14 |
| dictionary/compile/english-15 | 1 | 0.34 ± 4.7% | not timed | not timed | 0.07 ± 2.3% | 0.10 ± 23.6% | not timed | not timed | 0.34 ± 2.6% | | 1.01 | 4.95 | 3.43 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 17.7% | not timed | not timed | 0.02 ± 0.6% | 34.81 ± 3.7% | not timed | not timed | 0.24 ± 4.1% | | 1.01 | 13.22 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.66 ± 20.3% | not timed | not timed | 11.53 ± 0.3% | 58.17 ± 18.5% | not timed | not timed | 46.79 ± 22.3% | | 1.00 | 4.05 | 0.80 |
| reported/i787-keywords/compile | 1 | 35.02 ± 5.1% | not timed | not timed | 2.12 ± 1.1% | 16.11 ± 37.7% | not timed | not timed | 35.16 ± 16.6% | | 1.00 | 16.52 | 2.17 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 346.20 ± 11.9% | not timed | not timed | 122.66 ± 0.9% | 562.37 ± 26.7% | not timed | not timed | 349.55 ± 2.1% | | 0.99 | 2.82 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.04 ± 2.1% | not timed | not timed | 4.12 ± 1.0% | 43.15 ± 6.3% | not timed | not timed | 47.38 ± 2.6% | | 0.99 | 11.41 | 1.09 |
| unicode/compile/one-letter | 53 | 6.54 ± 13.7% | not timed | not timed | 4.54 ± 0.5% | 63.15 ± 7.9% | not timed | not timed | 6.66 ± 10.5% | | 0.98 | 1.44 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.03 ± 11.1% | not timed | not timed | 0.10 ± 1.2% | 62.89 ± 15.7% | not timed | not timed | 1.05 ± 18.8% | | 0.99 | 10.44 | 0.0164 |
| unicode/compile/fifty-letters-ascii | 1 | 216.56 ± 3.8% | not timed | not timed | 51.37 ± 0.2% | 196.93 ± 27.7% | not timed | not timed | 217.16 ± 4.7% | | 1.00 | 4.22 | 1.10 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 370.13 ± 28.3% | not timed | not timed | 46.94 ± 1.6% | 697.25 ± 17.8% | not timed | not timed | 374.91 ± 19.9% | | 0.99 | 7.89 | 0.53 |
| unicode/compile/match-every-line-ascii | 4 | 588.49 ± 3.0% | not timed | not timed | 145.10 ± 0.2% | 628.32 ± 15.0% | not timed | not timed | 602.87 ± 14.3% | | 0.98 | 4.06 | 0.94 |
| unicode/compile/negated-class-matches-codepoint | 1 | 299.76 ± 4.7% | not timed | not timed | 50.79 ± 0.5% | 1230.34 ± 6.3% | not timed | not timed | 313.26 ± 4.8% | | 0.96 | 5.90 | 0.24 |
| wild/bibleref/compile | 3 | 5.56 ± 21.7% | not timed | not timed | 1.92 ± 1.9% | 31.13 ± 15.3% | not timed | not timed | 5.87 ± 6.6% | | 0.95 | 2.90 | 0.18 |
| wild/url/compile | 1 | 0.62 ± 16.6% | not timed | not timed | 0.14 ± 3.7% | 0.42 ± 19.3% | not timed | not timed | 0.62 ± 19.1% | | 0.99 | 4.31 | 1.49 |

