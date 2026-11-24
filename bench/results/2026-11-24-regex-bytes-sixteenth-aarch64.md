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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391558797 |
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
| literal: a word | 217 | 19014.62 ± 3.2% | 5030.36 ± 0.1% | 28.19 ± 0.7% | 17610.73 ± 3.6% | 9103.26 ± 9.1% | 17.39 ± 0.3% | 84.41 ± 0.3% | 19027.85 ± 3.0% | 3.78 | 1.00 | 1.08 | 2.09 |
| literal: a word that is not there | 0 | 21290.97 ± 3.1% | 4921.40 ± 0.6% | 28.28 ± 0.3% | 19265.36 ± 2.7% | 28250.41 ± 2.7% | 17.13 ± 0.3% | 79.78 ± 0.1% | 21111.61 ± 2.8% | 4.33 | 1.01 | 1.11 | 0.75 |
| literal: one of four words | 661 | 6350.49 ± 0.2% | 1944.65 ± 0.2% | 14.37 ± 0.2% | 3947.09 ± 0.2% | 21.85 ± 0.1% | 5.41 ± 0.2% | 6.76 ± 0.6% | 6356.85 ± 0.3% | 3.27 | 1.00 | 1.61 | 290.61 |
| literal: a word in any case | 217 | 14972.86 ± 0.4% | 2085.49 ± 0.1% | 21.35 ± 0.3% | 3968.04 ± 0.4% | 37.99 ± 1.1% | refused | differs | 14994.67 ± 0.9% | 7.18 | 1.00 | 3.77 | 394.09 |
| literal: an href attribute | 33 | 16475.84 ± 1.2% | 608.54 ± 0.2% | 27.25 ± 0.1% | 16583.43 ± 1.8% | 2253.54 ± 4.0% | 13.07 ± 8.0% | 74.18 ± 0.2% | 16608.40 ± 3.1% | 27.07 | 0.99 | 0.99 | 7.31 |
| literal: a word, second text | 123 | 19202.86 ± 3.0% | 3384.14 ± 0.1% | 27.86 ± 0.2% | 17891.45 ± 3.2% | 7552.76 ± 4.0% | 20.11 ± 0.4% | 70.58 ± 0.5% | 19431.67 ± 2.7% | 5.67 | 0.99 | 1.07 | 2.54 |
| class: two capitalized words | 1331 | 1069.68 ± 0.4% | 598.80 ± 0.2% | 26.03 ± 0.1% | 584.96 ± 0.2% | 40.63 ± 3.1% | 14.74 ± 0.3% | 67.52 ± 0.4% | 1069.87 ± 0.3% | 1.79 | 1.00 | 1.83 | 26.33 |
| class: a word that ends in ing | 3399 | 573.87 ± 0.3% | 573.17 ± 0.3% | 17.98 ± 0.1% | 546.91 ± 0.1% | 29.65 ± 9.5% | 8.18 ± 0.4% | 18.41 ± 0.3% | 573.52 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.36 |
| class: a word in capitals | 2332 | 1375.20 ± 0.4% | 603.61 ± 0.1% | 27.53 ± 0.2% | 571.60 ± 0.0% | 43.63 ± 0.3% | 17.19 ± 0.5% | 82.71 ± 0.1% | 1378.44 ± 0.4% | 2.28 | 1.00 | 2.41 | 31.52 |
| class: a number | 8288 | 1991.66 ± 0.2% | 828.82 ± 0.1% | 27.71 ± 0.3% | 1700.40 ± 0.2% | 40.82 ± 16.2% | 0.53 ± 0.7% | 57.73 ± 0.1% | 1996.98 ± 0.3% | 2.40 | 1.00 | 1.17 | 48.80 |
| class: two capitalized words, second text | 5359 | 515.93 ± 0.2% | 523.39 ± 0.2% | 23.31 ± 0.1% | 483.82 ± 0.1% | 33.92 ± 10.8% | 17.11 ± 0.2% | 62.99 ± 0.2% | 515.59 ± 0.4% | 0.99 | 1.00 | 1.07 | 15.21 |
| other: a word between two words | 6104 | 786.76 ± 0.2% | 592.46 ± 0.2% | 23.56 ± 0.3% | 733.40 ± 0.1% | 108.98 ± 14.7% | 11.18 ± 0.3% | 68.42 ± 0.3% | 788.18 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.22 |
| other: a number before a unit, second text | 1481 | 5939.64 ± 0.9% | 1118.95 ± 0.4% | 26.00 ± 0.1% | 5627.39 ± 0.3% | 40.73 ± 4.8% | 18.20 ± 0.3% | 65.88 ± 0.3% | 5908.86 ± 1.2% | 5.31 | 1.01 | 1.06 | 145.83 |
| other: a heading's start tag | 110 | 13811.28 ± 0.4% | 743.40 ± 0.3% | 27.42 ± 0.0% | 1709.06 ± 0.2% | 1572.96 ± 9.0% | 16.05 ± 0.3% | 86.28 ± 0.3% | 13890.61 ± 0.5% | 18.58 | 0.99 | 8.08 | 8.78 |
| other: a whole word | 217 | 15649.16 ± 1.5% | 601.22 ± 0.7% | 29.29 ± 0.2% | 14278.70 ± 1.4% | 49.30 ± 0.5% | 13.32 ± 0.2% | 55.11 ± 0.4% | 15614.09 ± 0.7% | 26.03 | 1.00 | 1.10 | 317.44 |
| other: a line's first word, second text | 3716 | 2041.61 ± 0.3% | 587.58 ± 0.1% | 30.97 ± 0.1% | 1722.13 ± 0.5% | 62.31 ± 11.9% | refused | refused | 2044.22 ± 0.6% | 3.47 | 1.00 | 1.19 | 32.77 |
| other: fourteen octets before an x | 87 | 23398.86 ± 1.8% | 242.42 ± 0.9% | 6.32 ± 0.1% | 3962.49 ± 1.3% | 10.64 ± 0.2% | differs | 17.80 ± 0.2% | 23333.81 ± 5.9% | 96.52 | 1.00 | 5.91 | 2199.58 |
| other: a Greek word | 21815 | 498.38 ± 0.3% | 411.86 ± 0.4% | 30.63 ± 0.1% | 288.54 ± 0.2% | 49.60 ± 11.6% | differs | refused | 499.51 ± 0.5% | 1.21 | 1.00 | 1.73 | 10.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.57 ± 0.1% | 16.67 ± 0.2% | 0.85 ± 0.2% | 19.83 ± 0.6% | 2.77 ± 0.6% | differs | 4.06 ± 0.2% | 19.56 ± 0.2% | 1.17 | 1.00 | 0.99 | 7.06 |
| a UUID | 32895 | 21.15 ± 0.1% | 21.11 ± 0.2% | 0.64 ± 0.2% | 15.15 ± 0.5% | 3.11 ± 0.1% | 0.73 ± 0.3% | 3.66 ± 0.7% | 21.09 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.80 |
| an IPv4 address | 33176 | 35.94 ± 0.2% | 35.95 ± 0.2% | 2.05 ± 0.1% | 29.37 ± 0.7% | 6.67 ± 0.2% | differs | 4.18 ± 0.2% | 35.92 ± 0.2% | 1.00 | 1.00 | 1.22 | 5.39 |
| a date and time | 32954 | 31.01 ± 0.5% | 31.00 ± 0.4% | 1.43 ± 0.2% | 21.45 ± 0.4% | 7.03 ± 0.1% | 1.25 ± 0.1% | 7.19 ± 0.2% | 31.01 ± 0.2% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 23.18 ± 0.1% | 23.12 ± 0.4% | 1.01 ± 0.3% | 23.33 ± 0.2% | 3.47 ± 0.5% | differs | 2.99 ± 0.3% | 23.12 ± 0.1% | 1.00 | 1.00 | 0.99 | 6.68 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.19 ± 1.4% | 11.16 ± 1.1% | 11.13 ± 0.8% | 11.80 ± 0.1% | 4.96 ± 1.3% | 0.93 ± 0.5% | none | 11.18 ± 1.6% | 1.00 | 1.00 | 0.95 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.19 ± 0.2% | 228.13 ± 0.2% | 268.52 ± 0.1% | 86.97 ± 0.1% | 221.97 ± 1.9% | 487.71 ± 0.7% | 3800.00 ± 0.5% | 227.44 ± 0.2% | 1.00 | 1.00 | 2.61 | 1.02 |
| a UUID | 62 | 148.92 ± 0.3% | 149.38 ± 0.2% | 165.95 ± 0.2% | 46.10 ± 0.7% | 98.56 ± 1.2% | 183.16 ± 1.0% | 4182.64 ± 1.0% | 148.86 ± 0.2% | 1.00 | 1.00 | 3.23 | 1.51 |
| an IPv4 address | 29 | 428.27 ± 0.7% | 432.05 ± 0.4% | 601.39 ± 0.3% | 76.46 ± 0.7% | 130.65 ± 1.9% | 295.17 ± 0.5% | 7502.72 ± 0.6% | 427.96 ± 0.3% | 0.99 | 1.00 | 5.60 | 3.28 |
| a date and time | 56 | 308.68 ± 0.2% | 310.64 ± 0.3% | 389.76 ± 0.1% | 72.90 ± 1.1% | 137.19 ± 1.5% | 319.36 ± 1.2% | 4806.79 ± 0.7% | 309.05 ± 0.2% | 0.99 | 1.00 | 4.23 | 2.25 |
| a field path | 39 | 219.05 ± 0.1% | 220.16 ± 0.1% | 256.86 ± 0.2% | 79.71 ± 0.4% | 204.50 ± 2.1% | 483.94 ± 1.4% | 4873.96 ± 0.6% | 219.46 ± 0.3% | 0.99 | 1.00 | 2.75 | 1.07 |
| literal: a word | 7 | 636.03 ± 0.3% | 687.14 ± 0.1% | 1232.46 ± 0.2% | 502.85 ± 1.5% | 627.78 ± 1.9% | 919.62 ± 0.5% | 31107.42 ± 0.1% | 635.14 ± 0.3% | 0.93 | 1.00 | 1.26 | 1.01 |
| literal: a word that is not there | 8 | 612.35 ± 0.3% | 666.48 ± 0.3% | 1154.78 ± 0.5% | 462.19 ± 0.7% | 602.94 ± 1.9% | 870.94 ± 0.4% | 29512.09 ± 0.3% | 612.96 ± 0.4% | 0.92 | 1.00 | 1.32 | 1.02 |
| literal: one of four words | 26 | 248.14 ± 0.0% | 405.00 ± 0.2% | 549.13 ± 0.0% | 49.35 ± 0.4% | 241.10 ± 4.1% | 355.27 ± 0.6% | 16102.71 ± 0.1% | 248.46 ± 0.1% | 0.61 | 1.00 | 5.03 | 1.03 |
| literal: a word in any case | 11 | 455.48 ± 0.5% | 487.34 ± 0.2% | 716.90 ± 0.1% | 15.72 ± 0.7% | 645.20 ± 2.1% | refused | 23763.93 ± 0.3% | 455.25 ± 0.3% | 0.93 | 1.00 | 28.98 | 0.71 |
| literal: an href attribute | 12 | 349.39 ± 0.5% | 361.35 ± 0.4% | 473.48 ± 0.3% | 44.81 ± 0.6% | 498.60 ± 1.7% | 751.51 ± 0.9% | 22222.80 ± 0.2% | 349.78 ± 0.3% | 0.97 | 1.00 | 7.80 | 0.70 |
| literal: a word, second text | 10 | 563.36 ± 0.5% | 623.67 ± 0.8% | 1032.50 ± 1.0% | 422.01 ± 0.7% | 535.90 ± 1.4% | 777.20 ± 0.6% | 27549.56 ± 0.2% | 564.20 ± 0.4% | 0.90 | 1.00 | 1.33 | 1.05 |
| class: two capitalized words | 23 | 440.03 ± 1.0% | 470.53 ± 0.5% | 674.31 ± 0.9% | 100.73 ± 1.3% | 496.43 ± 1.4% | 762.97 ± 0.6% | 6469.85 ± 0.4% | 439.46 ± 0.6% | 0.94 | 1.00 | 4.37 | 0.89 |
| class: a word that ends in ing | 9 | 569.99 ± 0.3% | 636.23 ± 0.2% | 1107.21 ± 0.2% | 133.23 ± 0.3% | 751.07 ± 2.6% | 1084.33 ± 0.7% | 15893.73 ± 0.8% | 569.58 ± 0.4% | 0.90 | 1.00 | 4.28 | 0.76 |
| class: a word in capitals | 16 | 496.41 ± 0.2% | 541.01 ± 0.8% | 856.41 ± 0.3% | 134.98 ± 0.3% | 747.44 ± 1.1% | 999.96 ± 0.9% | 8560.02 ± 0.5% | 496.09 ± 0.2% | 0.92 | 1.00 | 3.68 | 0.66 |
| class: a number | 6 | 637.86 ± 0.2% | 702.48 ± 0.4% | 1314.60 ± 0.1% | 42.21 ± 0.9% | 1394.47 ± 0.4% | 1882.16 ± 0.7% | 23029.78 ± 0.1% | 637.92 ± 0.2% | 0.91 | 1.00 | 15.11 | 0.46 |
| class: two capitalized words, second text | 23 | 439.35 ± 0.3% | 471.71 ± 0.3% | 675.81 ± 0.6% | 101.85 ± 3.5% | 498.24 ± 0.6% | 755.60 ± 0.7% | 6456.59 ± 0.8% | 439.68 ± 0.2% | 0.93 | 1.00 | 4.31 | 0.88 |
| other: a word between two words | 13 | 553.39 ± 0.3% | 573.20 ± 0.6% | 911.36 ± 0.2% | 134.92 ± 1.0% | 497.05 ± 1.2% | 819.89 ± 1.1% | 14615.74 ± 0.7% | 553.72 ± 0.2% | 0.97 | 1.00 | 4.10 | 1.11 |
| other: a number before a unit, second text | 15 | 400.08 ± 0.2% | 439.03 ± 0.2% | 610.48 ± 0.4% | 39.51 ± 0.1% | 632.84 ± 0.7% | 894.78 ± 0.3% | 15343.04 ± 0.6% | 399.83 ± 0.2% | 0.91 | 1.00 | 10.13 | 0.63 |
| other: a heading's start tag | 13 | 361.45 ± 0.6% | 368.15 ± 0.5% | 483.77 ± 0.3% | 43.47 ± 0.3% | 620.71 ± 1.5% | 868.87 ± 0.5% | 18385.18 ± 0.4% | 361.23 ± 0.4% | 0.98 | 1.00 | 8.32 | 0.58 |
| other: a whole word | 11 | 584.70 ± 0.4% | 623.30 ± 0.3% | 1037.61 ± 0.5% | 120.93 ± 0.3% | 563.11 ± 3.0% | 831.24 ± 0.5% | 27348.87 ± 1.2% | 584.60 ± 0.9% | 0.94 | 1.00 | 4.84 | 1.04 |
| other: a line's first word, second text | 17 | 530.81 ± 0.8% | 559.40 ± 0.4% | 899.24 ± 0.8% | 129.55 ± 0.8% | 703.77 ± 1.5% | refused | refused | 533.30 ± 0.8% | 0.95 | 1.00 | 4.10 | 0.75 |
| other: fourteen octets before an x | 16 | 110.00 ± 2.0% | 157.92 ± 1.1% | 180.35 ± 0.8% | 15.20 ± 0.4% | 447.73 ± 1.2% | 418.11 ± 0.6% | 12947.71 ± 0.6% | 109.96 ± 1.7% | 0.70 | 1.00 | 7.24 | 0.25 |
| other: a Greek word | 8 | 456.14 ± 0.3% | 603.92 ± 0.4% | 1016.20 ± 0.5% | 59.11 ± 1.2% | 1359.21 ± 2.6% | 1780.62 ± 0.4% | refused | 456.26 ± 0.3% | 0.76 | 1.00 | 7.72 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15376.04 ± 1.2% | not timed | not timed | 15881.26 ± 1.7% | 1989.88 ± 20.9% | not timed | not timed | 15375.27 ± 0.4% | | 1.00 | 0.97 | 7.73 |
| 01-literal/sherlock-casei-en | 522 | 11029.61 ± 4.4% | not timed | not timed | 3599.52 ± 0.3% | 32.51 ± 0.2% | not timed | not timed | 11057.72 ± 3.0% | | 1.00 | 3.06 | 339.26 |
| 01-literal/sherlock-ru | 724 | 17113.18 ± 0.8% | not timed | not timed | 17162.33 ± 1.0% | 1625.13 ± 13.2% | not timed | not timed | 17136.09 ± 0.5% | | 1.00 | 1.00 | 10.53 |
| 01-literal/sherlock-casei-ru | 746 | 6177.34 ± 0.3% | not timed | not timed | 3318.07 ± 0.2% | 30.76 ± 0.2% | not timed | not timed | 6182.40 ± 0.1% | | 1.00 | 1.86 | 200.85 |
| 01-literal/sherlock-zh | 30 | 19354.89 ± 1.6% | not timed | not timed | 18351.20 ± 1.4% | 2830.66 ± 16.6% | not timed | not timed | 19332.35 ± 0.6% | | 1.00 | 1.05 | 6.84 |
| 02-literal-alternate/sherlock-en | 714 | 6049.49 ± 0.5% | not timed | not timed | 3940.95 ± 0.3% | 16.62 ± 0.2% | not timed | not timed | 6050.83 ± 0.3% | | 1.00 | 1.54 | 364.04 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1981.07 ± 1.5% | not timed | not timed | 699.56 ± 0.2% | 11.13 ± 0.2% | not timed | not timed | 1986.84 ± 0.8% | | 1.00 | 2.83 | 178.03 |
| 02-literal-alternate/sherlock-ru | 899 | 5565.54 ± 0.7% | not timed | not timed | 3258.44 ± 0.4% | 22.64 ± 0.1% | not timed | not timed | 5572.51 ± 0.2% | | 1.00 | 1.71 | 245.78 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.41 ± 0.5% | not timed | not timed | 1232.73 ± 0.2% | 9.12 ± 0.2% | not timed | not timed | 2060.92 ± 0.7% | | 1.00 | 1.67 | 225.63 |
| 02-literal-alternate/sherlock-zh | 207 | 7294.07 ± 0.5% | not timed | not timed | 4164.29 ± 0.2% | 31.49 ± 0.1% | not timed | not timed | 7302.13 ± 0.4% | | 1.00 | 1.75 | 231.64 |
| 03-date/ascii | 111817 | 123.95 ± 0.7% | not timed | not timed | 96.08 ± 0.2% | 0.20 ± 2.9% | not timed | not timed | 124.37 ± 0.7% | | 1.00 | 1.29 | 617.58 |
| 04-ruff-noqa/real | 84 | 403.36 ± 0.1% | not timed | not timed | 472.48 ± 0.1% | 19.55 ± 1.2% | not timed | not timed | 403.65 ± 0.1% | | 1.00 | 0.85 | 20.63 |
| 04-ruff-noqa/tweaked | 44 | 556.16 ± 0.4% | not timed | not timed | 458.28 ± 0.1% | 366.18 ± 0.4% | not timed | not timed | 556.27 ± 0.4% | | 1.00 | 1.21 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.53 ± 3.8% | not timed | not timed | 5.18 ± 0.1% | 0.20 ± 4.1% | not timed | not timed | 5.40 ± 3.4% | | 1.02 | 1.07 | 26.99 |
| 06-cloud-flare-redos/original | 107 | 415.58 ± 0.3% | not timed | not timed | 214.50 ± 0.1% | 24.91 ± 0.3% | not timed | not timed | 415.84 ± 0.1% | | 1.00 | 1.94 | 16.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 416.14 ± 0.1% | not timed | not timed | 226.64 ± 0.1% | 26.76 ± 0.1% | not timed | not timed | 411.08 ± 0.1% | | 1.01 | 1.84 | 15.55 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.74 ± 0.2% | not timed | not timed | 254.81 ± 0.1% | 28.82 ± 0.2% | not timed | not timed | 578.27 ± 0.0% | | 1.02 | 2.31 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 235.61 ± 3.1% | not timed | not timed | 180.79 ± 0.1% | 41.47 ± 3.9% | not timed | not timed | 237.85 ± 2.6% | | 0.99 | 1.30 | 5.68 |
| 08-words/all-english | 56691 | 115.67 ± 0.6% | not timed | not timed | 82.82 ± 0.2% | 11.64 ± 18.0% | not timed | not timed | 116.60 ± 0.8% | | 0.99 | 1.40 | 9.93 |
| 08-words/long-english | 839 | 613.42 ± 0.3% | not timed | not timed | 596.33 ± 0.2% | 32.54 ± 0.8% | not timed | not timed | 613.21 ± 0.5% | | 1.00 | 1.03 | 18.85 |
| 09-aws-keys/full | 0 | 407.02 ± 0.0% | not timed | not timed | 479.60 ± 0.1% | 64.41 ± 3.4% | not timed | not timed | 408.18 ± 0.1% | | 1.00 | 0.85 | 6.32 |
| 09-aws-keys/quick | 0 | 870.97 ± 0.2% | not timed | not timed | 998.03 ± 0.5% | 423.64 ± 2.4% | not timed | not timed | 871.70 ± 0.1% | | 1.00 | 0.87 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 580.44 ± 1.9% | not timed | not timed | 517.26 ± 0.5% | 19.49 ± 0.3% | not timed | not timed | 579.58 ± 1.8% | | 1.00 | 1.12 | 29.78 |
| 10-bounded-repeat/letters-ru | 3475 | 507.82 ± 1.4% | not timed | not timed | 479.38 ± 0.1% | 21.91 ± 9.4% | not timed | not timed | 509.72 ± 1.2% | | 1.00 | 1.06 | 23.17 |
| 10-bounded-repeat/context | 53 | 85.11 ± 1.6% | not timed | not timed | 65.90 ± 0.6% | 19.81 ± 0.2% | not timed | not timed | 85.19 ± 1.9% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 641.63 ± 8.0% | not timed | not timed | 616.90 ± 0.1% | 36.46 ± 0.1% | not timed | not timed | 640.50 ± 8.0% | | 1.00 | 1.04 | 17.60 |
| 11-unstructured-to-json/extract | 600 | 56.85 ± 0.2% | not timed | not timed | 76.51 ± 0.6% | 49.06 ± 0.1% | not timed | not timed | 56.80 ± 0.2% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 566.63 ± 0.3% | not timed | not timed | 561.95 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 568.57 ± 0.2% | | 1.00 | 1.01 | 1410.86 |
| 14-quadratic/1x | 100 | 21.13 ± 0.9% | not timed | not timed | 10.02 ± 0.3% | 0.96 ± 3.8% | not timed | not timed | 21.17 ± 0.6% | | 1.00 | 2.11 | 22.08 |
| 14-quadratic/2x | 200 | 17.39 ± 0.7% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 1.1% | not timed | not timed | 17.37 ± 0.5% | | 1.00 | 3.13 | 32.73 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.5% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 2.0% | not timed | not timed | 7.69 ± 0.6% | | 1.00 | 6.36 | 66.43 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 1.6% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 3.0% | not timed | not timed | 1.26 ± 0.7% | | 1.00 | 3.70 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 104.20 ± 1.1% | not timed | not timed | 13.82 ± 0.5% | 138.17 ± 1.6% | not timed | not timed | 104.31 ± 1.3% | | 1.00 | 7.54 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.03 ± 1.4% | not timed | not timed | 2.52 ± 0.3% | 6.42 ± 2.0% | not timed | not timed | 14.11 ± 1.2% | | 0.99 | 5.56 | 2.19 |
| 07-unicode-character-data/compile | 1 | 107.99 ± 1.2% | not timed | not timed | 26.11 ± 0.1% | 35.79 ± 2.3% | not timed | not timed | 108.77 ± 1.8% | | 0.99 | 4.14 | 3.02 |
| 09-aws-keys/compile-full | 1 | 53.13 ± 1.5% | not timed | not timed | 8.31 ± 0.7% | 23.17 ± 3.3% | not timed | not timed | 53.10 ± 0.6% | | 1.00 | 6.40 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 188.55 ± 0.2% | not timed | not timed | 47.28 ± 0.3% | 132.13 ± 3.4% | not timed | not timed | 188.71 ± 1.4% | | 1.00 | 3.99 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 71.21 ± 1.2% | not timed | not timed | 11.10 ± 0.2% | 15.77 ± 3.3% | not timed | not timed | 71.75 ± 0.4% | | 0.99 | 6.42 | 4.52 |
| 10-bounded-repeat/compile-capitals | 1 | 84.52 ± 0.6% | not timed | not timed | 7.94 ± 0.9% | 23.41 ± 8.8% | not timed | not timed | 85.56 ± 1.3% | | 0.99 | 10.64 | 3.61 |
| 11-unstructured-to-json/compile | 1 | 171.62 ± 0.3% | not timed | not timed | 41.50 ± 0.4% | 67.23 ± 3.1% | not timed | not timed | 172.24 ± 0.5% | | 1.00 | 4.14 | 2.55 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.5% | not timed | not timed | 0.07 ± 0.4% | 0.09 ± 21.1% | not timed | not timed | 0.35 ± 2.8% | | 0.99 | 5.08 | 3.82 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.64 ± 0.3% | not timed | not timed | 6.55 ± 0.2% | 0.52 ± 15.7% | not timed | not timed | 7.63 ± 5.7% | | 1.00 | 1.17 | 14.59 |
| dictionary/search/english-10 | 690 | 1.04 ± 0.7% | not timed | not timed | 164.75 ± 0.8% | 0.00 ± 1.0% | not timed | not timed | 1.05 ± 0.6% | | 1.00 | 0.0063 | 406.01 |
| dictionary/search/english-15 | 15 | 559.53 ± 0.5% | not timed | not timed | 561.41 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 561.62 ± 0.3% | | 1.00 | 1.00 | 1515.71 |
| folly/awyer-inn-busted | 1 | 5585.06 ± 0.1% | not timed | not timed | 143.05 ± 0.1% | 42.68 ± 2.4% | not timed | not timed | 5571.44 ± 0.1% | | 1.00 | 39.04 | 130.87 |
| folly/literal-never-match-rare | 0 | 20876.59 ± 0.5% | not timed | not timed | 19728.54 ± 0.6% | 40158.44 ± 1.0% | not timed | not timed | 20933.13 ± 0.6% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12433.61 ± 0.8% | not timed | not timed | 19611.46 ± 1.0% | 2182.49 ± 1.1% | not timed | not timed | 12462.66 ± 1.2% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3241.24 ± 0.3% | not timed | not timed | 4435.33 ± 0.4% | 3048.99 ± 1.2% | not timed | not timed | 3238.06 ± 0.4% | | 1.00 | 0.73 | 1.06 |
| grep/every-line | 239963 | 1305.72 ± 0.6% | not timed | not timed | 962.64 ± 0.1% | 374.56 ± 16.5% | not timed | not timed | 1309.15 ± 0.6% | | 1.00 | 1.36 | 3.49 |
| grep/long-words-ascii | 5073 | 459.32 ± 0.2% | not timed | not timed | 468.50 ± 0.1% | 46.09 ± 6.1% | not timed | not timed | 459.21 ± 0.1% | | 1.00 | 0.98 | 9.97 |
| imported/leipzig/twain | 811 | 20370.21 ± 2.3% | not timed | not timed | 19307.70 ± 1.4% | 11749.02 ± 11.7% | not timed | not timed | 20419.80 ± 2.8% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 8980.79 ± 1.1% | not timed | not timed | 4206.89 ± 1.0% | 37.75 ± 0.0% | not timed | not timed | 8984.86 ± 0.9% | | 1.00 | 2.13 | 237.87 |
| imported/leipzig/shing | 1540 | 629.55 ± 0.1% | not timed | not timed | 12976.22 ± 1.8% | 34.05 ± 0.0% | not timed | not timed | 632.05 ± 0.1% | | 1.00 | 0.0485 | 18.49 |
| imported/leipzig/huck-saw | 262 | 8091.87 ± 2.0% | not timed | not timed | 5559.78 ± 0.9% | 31.69 ± 0.1% | not timed | not timed | 8277.51 ± 2.7% | | 0.98 | 1.46 | 255.35 |
| imported/leipzig/word-ending-nn | 262 | 609.07 ± 0.2% | not timed | not timed | 615.84 ± 0.1% | 24.53 ± 0.9% | not timed | not timed | 611.15 ± 0.3% | | 1.00 | 0.99 | 24.82 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11021.49 ± 1.2% | not timed | not timed | 4490.59 ± 2.1% | 11.50 ± 0.2% | not timed | not timed | 11055.63 ± 1.0% | | 1.00 | 2.45 | 958.12 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7724.44 ± 2.3% | not timed | not timed | 5471.17 ± 0.1% | 16.88 ± 2.2% | not timed | not timed | 7847.67 ± 2.7% | | 0.98 | 1.41 | 457.74 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4180.81 ± 1.2% | not timed | not timed | 415.06 ± 2.9% | 11.10 ± 0.1% | not timed | not timed | 4174.57 ± 1.1% | | 1.00 | 10.07 | 376.78 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.75 ± 0.2% | not timed | not timed | 614.97 ± 0.1% | 11.15 ± 0.0% | not timed | not timed | 609.60 ± 0.2% | | 1.00 | 0.99 | 54.70 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.68 ± 0.2% | not timed | not timed | 615.32 ± 0.4% | 9.74 ± 0.1% | not timed | not timed | 610.06 ± 0.7% | | 1.00 | 0.99 | 62.57 |
| imported/leipzig/tom-river | 2 | 6521.29 ± 2.2% | not timed | not timed | 5143.02 ± 0.3% | 31.07 ± 0.1% | not timed | not timed | 6610.46 ± 2.2% | | 0.99 | 1.27 | 209.91 |
| imported/leipzig/ing | 78424 | 608.89 ± 0.7% | not timed | not timed | 571.22 ± 0.3% | 28.30 ± 2.8% | not timed | not timed | 607.62 ± 0.8% | | 1.00 | 1.07 | 21.52 |
| imported/leipzig/ing-whitespace | 55248 | 757.94 ± 0.9% | not timed | not timed | 2086.56 ± 0.4% | 20.62 ± 2.9% | not timed | not timed | 757.65 ± 1.0% | | 1.00 | 0.36 | 36.76 |
| imported/leipzig/awyer-inn | 209 | 774.54 ± 1.4% | not timed | not timed | 4257.38 ± 0.7% | 22.74 ± 0.1% | not timed | not timed | 774.63 ± 1.4% | | 1.00 | 0.18 | 34.06 |
| imported/leipzig/quotes-bounded | 8886 | 2124.72 ± 0.3% | not timed | not timed | 3023.19 ± 0.8% | 38.28 ± 0.2% | not timed | not timed | 2120.98 ± 0.5% | | 1.00 | 0.70 | 55.51 |
| imported/leipzig/non-ascii-alternate | 2 | 12898.35 ± 1.7% | not timed | not timed | 5662.02 ± 0.4% | 50.99 ± 0.1% | not timed | not timed | 13063.83 ± 2.7% | | 0.99 | 2.28 | 252.96 |
| imported/leipzig/math-symbols | 69 | 1972.87 ± 0.6% | not timed | not timed | 614.47 ± 0.1% | 36.53 ± 0.2% | not timed | not timed | 1967.40 ± 0.5% | | 1.00 | 3.21 | 54.00 |
| imported/leipzig/bounded-strings-ending-z | 0 | 593.57 ± 0.5% | not timed | not timed | 616.20 ± 0.0% | 22.37 ± 0.4% | not timed | not timed | 595.45 ± 0.4% | | 1.00 | 0.96 | 26.53 |
| imported/lh3lh3-reb/uri | 17549 | 633.02 ± 0.1% | not timed | not timed | 1080.02 ± 0.2% | 28.34 ± 2.1% | not timed | not timed | 632.37 ± 0.2% | | 1.00 | 0.59 | 22.34 |
| imported/lh3lh3-reb/email | 15057 | 667.66 ± 0.1% | not timed | not timed | 1179.56 ± 0.1% | 30.99 ± 2.4% | not timed | not timed | 668.50 ± 0.1% | | 1.00 | 0.57 | 21.55 |
| imported/lh3lh3-reb/date | 668 | 863.97 ± 0.3% | not timed | not timed | 1048.11 ± 0.1% | 51.41 ± 3.8% | not timed | not timed | 864.80 ± 0.1% | | 1.00 | 0.82 | 16.80 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.43 ± 0.2% | not timed | not timed | 422.56 ± 0.1% | 15.82 ± 1.3% | not timed | not timed | 642.14 ± 0.1% | | 1.00 | 1.52 | 40.62 |
| imported/mariomka/email | 92 | 705.32 ± 0.3% | not timed | not timed | 29556.15 ± 1.2% | 32.86 ± 0.0% | not timed | not timed | 706.11 ± 0.2% | | 1.00 | 0.0239 | 21.47 |
| imported/mariomka/uri | 5301 | 608.60 ± 0.1% | not timed | not timed | 6097.33 ± 0.5% | 32.76 ± 0.5% | not timed | not timed | 605.94 ± 0.1% | | 1.00 | 0.0998 | 18.58 |
| imported/mariomka/ip | 5 | 2155.22 ± 2.2% | not timed | not timed | 2956.16 ± 0.8% | 20.42 ± 0.3% | not timed | not timed | 2150.46 ± 2.3% | | 1.00 | 0.73 | 105.57 |
| imported/rsc/no-exponential | 0 | 570.38 ± 0.1% | not timed | not timed | 320.00 ± 0.3% | 23.86 ± 0.1% | not timed | not timed | 569.24 ± 0.3% | | 1.00 | 1.78 | 23.90 |
| imported/rsc/literal | 1 | 745.44 ± 2.2% | not timed | not timed | 1619.69 ± 2.9% | 188.31 ± 19.4% | not timed | not timed | 744.69 ± 4.6% | | 1.00 | 0.46 | 3.96 |
| imported/rsc/not-literal | 2 | 708.98 ± 0.1% | not timed | not timed | 728.12 ± 0.3% | 46.14 ± 4.7% | not timed | not timed | 708.62 ± 6.4% | | 1.00 | 0.97 | 15.36 |
| imported/rsc/match-class | 1 | 1297.47 ± 0.1% | not timed | not timed | 1646.16 ± 0.3% | 58.48 ± 13.7% | not timed | not timed | 1305.00 ± 2.4% | | 0.99 | 0.79 | 22.19 |
| imported/rsc/match-class-in-range | 1 | 1303.86 ± 0.1% | not timed | not timed | 2382.54 ± 2.8% | 60.19 ± 7.1% | not timed | not timed | 1306.34 ± 2.4% | | 1.00 | 0.55 | 21.66 |
| imported/rsc/match-class-unicode | 1 | 525.82 ± 0.2% | not timed | not timed | 513.42 ± 0.1% | 72.63 ± 0.6% | not timed | not timed | 524.20 ± 0.1% | | 1.00 | 1.02 | 7.24 |
| imported/rsc/anchored-literal-short-non-match | 0 | 540.66 ± 0.9% | not timed | not timed | 952.58 ± 0.1% | 227.02 ± 0.7% | not timed | not timed | 540.06 ± 0.7% | | 1.00 | 0.57 | 2.38 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8022.30 ± 0.1% | not timed | not timed | 14324.02 ± 0.1% | 3402.77 ± 0.3% | not timed | not timed | 8031.41 ± 0.2% | | 1.00 | 0.56 | 2.36 |
| imported/rsc/anchored-literal-short-match | 4 | 415.67 ± 2.5% | not timed | not timed | 452.87 ± 0.7% | 83.53 ± 6.2% | not timed | not timed | 423.21 ± 5.7% | | 0.98 | 0.92 | 4.98 |
| imported/rsc/anchored-literal-long-match | 4 | 3019.59 ± 0.9% | not timed | not timed | 7286.66 ± 0.1% | 1225.06 ± 4.8% | not timed | not timed | 3028.34 ± 1.8% | | 1.00 | 0.41 | 2.46 |
| imported/rsc/one-pass-short | 17 | 311.45 ± 10.0% | not timed | not timed | 215.70 ± 0.1% | 31.31 ± 11.7% | not timed | not timed | 308.32 ± 2.8% | | 1.01 | 1.44 | 9.95 |
| imported/rsc/one-pass-short-not | 17 | 219.98 ± 2.1% | not timed | not timed | 222.98 ± 0.3% | 30.22 ± 10.7% | not timed | not timed | 220.34 ± 1.4% | | 1.00 | 0.99 | 7.28 |
| imported/rsc/one-pass-long-prefix | 26 | 234.53 ± 9.7% | not timed | not timed | 282.97 ± 0.0% | 98.26 ± 14.8% | not timed | not timed | 239.74 ± 3.0% | | 0.98 | 0.83 | 2.39 |
| imported/rsc/one-pass-long-prefix-not | 26 | 311.18 ± 2.0% | not timed | not timed | 282.19 ± 0.3% | 64.53 ± 19.4% | not timed | not timed | 312.27 ± 0.3% | | 1.00 | 1.10 | 4.82 |
| imported/rsc/long-needle1 | 31 | 21911.73 ± 0.3% | not timed | not timed | 20124.01 ± 0.1% | 3.74 ± 0.1% | not timed | not timed | 21929.62 ± 0.2% | | 1.00 | 1.09 | 5861.60 |
| imported/rsc/long-needle2 | 31 | 22085.17 ± 0.1% | not timed | not timed | 216.23 ± 0.2% | 3.73 ± 0.2% | not timed | not timed | 22097.03 ± 0.2% | | 1.00 | 102.14 | 5924.65 |
| imported/rsc/easy0-32 | 26 | 1066.01 ± 4.0% | not timed | not timed | 1591.81 ± 3.6% | 147.66 ± 17.8% | not timed | not timed | 1062.29 ± 0.7% | | 1.00 | 0.67 | 7.22 |
| imported/rsc/easy0-1k | 26 | 14935.83 ± 2.4% | not timed | not timed | 12594.00 ± 0.9% | 2326.54 ± 16.4% | not timed | not timed | 14932.16 ± 0.5% | | 1.00 | 1.19 | 6.42 |
| imported/rsc/easy0-32k | 26 | 22895.48 ± 1.4% | not timed | not timed | 20353.37 ± 0.1% | 18820.30 ± 18.0% | not timed | not timed | 22910.11 ± 0.4% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21202.27 ± 5.4% | not timed | not timed | 19425.11 ± 3.5% | 34336.33 ± 3.7% | not timed | not timed | 21354.56 ± 2.5% | | 0.99 | 1.09 | 0.62 |
| imported/rsc/easy1-32 | 19 | 359.37 ± 7.6% | not timed | not timed | 642.35 ± 0.1% | 137.82 ± 19.2% | not timed | not timed | 360.36 ± 1.8% | | 1.00 | 0.56 | 2.61 |
| imported/rsc/easy1-1k | 19 | 584.08 ± 0.2% | not timed | not timed | 12876.90 ± 0.3% | 2482.10 ± 19.0% | not timed | not timed | 582.03 ± 2.7% | | 1.00 | 0.0454 | 0.24 |
| imported/rsc/easy1-32k | 19 | 603.20 ± 2.6% | not timed | not timed | 402613.48 ± 0.3% | 20473.94 ± 28.1% | not timed | not timed | 600.94 ± 0.3% | | 1.00 | 0.0015 | 0.0295 |
| imported/rsc/easy1-1mb | 19 | 603.30 ± 0.5% | not timed | not timed | 12947901.38 ± 0.3% | 36445.83 ± 2.5% | not timed | not timed | 601.75 ± 0.5% | | 1.00 | 0.0000 | 0.0166 |
| imported/rsc/medium-32 | 27 | 430.06 ± 0.6% | not timed | not timed | 638.07 ± 0.3% | 70.34 ± 13.6% | not timed | not timed | 429.83 ± 2.3% | | 1.00 | 0.67 | 6.11 |
| imported/rsc/medium-1k | 27 | 6830.45 ± 0.1% | not timed | not timed | 11425.15 ± 0.3% | 72.42 ± 0.1% | not timed | not timed | 6826.92 ± 0.1% | | 1.00 | 0.60 | 94.32 |
| imported/rsc/medium-32k | 27 | 21512.60 ± 0.2% | not timed | not timed | 350833.63 ± 0.1% | 48.72 ± 0.1% | not timed | not timed | 21617.21 ± 0.0% | | 1.00 | 0.0613 | 441.55 |
| imported/rsc/medium-1mb | 27 | 20819.41 ± 1.5% | not timed | not timed | 11245043.84 ± 0.2% | 48.66 ± 0.2% | not timed | not timed | 20760.87 ± 3.4% | | 1.00 | 0.0019 | 427.87 |
| imported/rsc/hard-32 | 58 | 255.71 ± 0.2% | not timed | not timed | 365.85 ± 0.1% | 49.80 ± 6.9% | not timed | not timed | 256.58 ± 2.5% | | 1.00 | 0.70 | 5.13 |
| imported/rsc/hard-1k | 27 | 577.70 ± 0.3% | not timed | not timed | 11631.01 ± 0.3% | 40.71 ± 0.1% | not timed | not timed | 575.60 ± 0.2% | | 1.00 | 0.0497 | 14.19 |
| imported/rsc/hard-32k | 27 | 603.02 ± 0.6% | not timed | not timed | 362056.37 ± 0.3% | 29.41 ± 0.1% | not timed | not timed | 598.11 ± 0.3% | | 1.01 | 0.0017 | 20.50 |
| imported/rsc/hard-1mb | 51 | 602.07 ± 0.6% | not timed | not timed | 7318580.25 ± 0.1% | 29.41 ± 0.4% | not timed | not timed | 599.02 ± 0.6% | | 1.01 | 0.0001 | 20.47 |
| imported/rsc/reallyhard0-32 | 58 | 253.82 ± 2.7% | not timed | not timed | 224.01 ± 0.0% | 49.78 ± 8.1% | not timed | not timed | 254.97 ± 0.2% | | 1.00 | 1.13 | 5.10 |
| imported/rsc/reallyhard0-1k | 27 | 577.44 ± 0.2% | not timed | not timed | 584.52 ± 0.1% | 40.77 ± 10.8% | not timed | not timed | 581.14 ± 0.2% | | 0.99 | 0.99 | 14.16 |
| imported/rsc/reallyhard0-32k | 27 | 600.25 ± 0.3% | not timed | not timed | 617.66 ± 0.0% | 29.40 ± 0.2% | not timed | not timed | 603.16 ± 0.5% | | 1.00 | 0.97 | 20.42 |
| imported/rsc/reallyhard0-1mb | 51 | 592.20 ± 0.4% | not timed | not timed | 617.88 ± 0.1% | 29.43 ± 0.1% | not timed | not timed | 596.73 ± 1.2% | | 0.99 | 0.96 | 20.12 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.37 ± 0.2% | not timed | not timed | 196.45 ± 0.6% | 61.16 ± 13.6% | not timed | not timed | 273.90 ± 1.6% | | 1.00 | 1.40 | 4.49 |
| imported/rsc/reallyreallyhard0-1k | 16 | 882.94 ± 4.4% | not timed | not timed | 5944.81 ± 0.2% | 34.01 ± 1.5% | not timed | not timed | 861.23 ± 3.8% | | 1.03 | 0.15 | 25.96 |
| imported/rsc/reallyreallyhard0-32k | 16 | 620.76 ± 5.0% | not timed | not timed | 19260.96 ± 0.3% | 24.58 ± 0.7% | not timed | not timed | 626.37 ± 4.1% | | 0.99 | 0.0322 | 25.25 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 588.96 ± 0.3% | not timed | not timed | 19846.90 ± 1.5% | 24.79 ± 0.1% | not timed | not timed | 588.24 ± 2.3% | | 1.00 | 0.0297 | 23.76 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.33 ± 0.2% | not timed | not timed | 211.45 ± 1.4% | 60.02 ± 12.0% | not timed | not timed | 268.90 ± 3.2% | | 1.00 | 1.27 | 4.49 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 843.04 ± 0.7% | not timed | not timed | 6193.52 ± 0.2% | 34.15 ± 1.2% | not timed | not timed | 841.90 ± 0.2% | | 1.00 | 0.14 | 24.69 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 634.01 ± 8.0% | not timed | not timed | 19239.89 ± 0.0% | 24.79 ± 1.6% | not timed | not timed | 631.86 ± 6.6% | | 1.00 | 0.0330 | 25.57 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 590.83 ± 0.6% | not timed | not timed | 19329.43 ± 2.0% | 24.67 ± 2.8% | not timed | not timed | 590.56 ± 1.1% | | 1.00 | 0.0306 | 23.95 |
| imported/sherlock/name-sherlock | 776 | 19739.16 ± 2.0% | not timed | not timed | 18543.30 ± 0.8% | 10039.56 ± 24.8% | not timed | not timed | 19747.70 ± 2.3% | | 1.00 | 1.06 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15085.16 ± 1.8% | not timed | not timed | 15516.66 ± 0.3% | 3211.43 ± 8.7% | not timed | not timed | 15281.49 ± 1.5% | | 0.99 | 0.97 | 4.70 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19757.79 ± 2.2% | not timed | not timed | 18505.74 ± 0.7% | 8019.40 ± 25.1% | not timed | not timed | 19776.15 ± 2.8% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15639.15 ± 0.5% | not timed | not timed | 4012.65 ± 0.3% | 32.61 ± 1.2% | not timed | not timed | 15655.22 ± 0.6% | | 1.00 | 3.90 | 479.62 |
| imported/sherlock/name-holmes-casei | 2802 | 9378.13 ± 6.3% | not timed | not timed | 3317.36 ± 0.2% | 38.62 ± 3.1% | not timed | not timed | 9356.13 ± 5.9% | | 1.00 | 2.83 | 242.83 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12993.06 ± 3.4% | not timed | not timed | 3944.29 ± 0.1% | 32.53 ± 0.2% | not timed | not timed | 13005.01 ± 0.8% | | 1.00 | 3.29 | 399.47 |
| imported/sherlock/name-whitespace | 1461 | 14986.99 ± 1.8% | not timed | not timed | 14493.79 ± 0.5% | 6557.75 ± 20.6% | not timed | not timed | 15006.52 ± 1.9% | | 1.00 | 1.03 | 2.29 |
| imported/sherlock/name-alt1 | 1142 | 11464.58 ± 0.2% | not timed | not timed | 16336.42 ± 1.0% | 4119.95 ± 24.2% | not timed | not timed | 11478.03 ± 2.9% | | 1.00 | 0.70 | 2.78 |
| imported/sherlock/name-alt2 | 3542 | 8611.87 ± 0.4% | not timed | not timed | 3822.52 ± 0.2% | 31.30 ± 0.1% | not timed | not timed | 8609.99 ± 0.2% | | 1.00 | 2.25 | 275.12 |
| imported/sherlock/name-alt3 | 4507 | 5433.79 ± 0.2% | not timed | not timed | 3621.19 ± 0.2% | 9.55 ± 4.2% | not timed | not timed | 5436.88 ± 0.4% | | 1.00 | 1.50 | 568.79 |
| imported/sherlock/name-alt3-casei | 4593 | 1503.90 ± 1.4% | not timed | not timed | 284.56 ± 0.4% | 6.44 ± 0.1% | not timed | not timed | 1508.21 ± 0.9% | | 1.00 | 5.28 | 233.35 |
| imported/sherlock/name-alt4 | 3686 | 6159.95 ± 0.4% | not timed | not timed | 3775.38 ± 0.1% | 31.40 ± 0.1% | not timed | not timed | 6164.65 ± 0.3% | | 1.00 | 1.63 | 196.17 |
| imported/sherlock/name-alt4-casei | 4254 | 2760.38 ± 3.0% | not timed | not timed | 2593.18 ± 0.2% | 19.87 ± 0.1% | not timed | not timed | 2768.35 ± 1.1% | | 1.00 | 1.06 | 138.91 |
| imported/sherlock/name-alt5 | 4028 | 6223.76 ± 0.2% | not timed | not timed | 3745.54 ± 0.2% | 21.76 ± 0.2% | not timed | not timed | 6225.37 ± 0.1% | | 1.00 | 1.66 | 286.03 |
| imported/sherlock/name-alt5-casei | 4104 | 3449.25 ± 2.1% | not timed | not timed | 2197.27 ± 0.1% | 14.37 ± 0.1% | not timed | not timed | 3450.34 ± 0.8% | | 1.00 | 1.57 | 239.96 |
| imported/sherlock/no-match-uncommon | 0 | 21547.75 ± 0.7% | not timed | not timed | 19449.18 ± 1.0% | 35584.17 ± 0.5% | not timed | not timed | 21510.10 ± 0.9% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21385.83 ± 0.5% | not timed | not timed | 19424.17 ± 0.7% | 1270.43 ± 0.5% | not timed | not timed | 21301.55 ± 0.5% | | 1.00 | 1.10 | 16.83 |
| imported/sherlock/no-match-really-common | 0 | 16151.61 ± 2.4% | not timed | not timed | 18621.19 ± 0.6% | 1276.87 ± 1.0% | not timed | not timed | 16256.12 ± 1.0% | | 0.99 | 0.87 | 12.65 |
| imported/sherlock/the-lower | 21654 | 2304.25 ± 0.9% | not timed | not timed | 2330.03 ± 0.4% | 239.90 ± 16.6% | not timed | not timed | 2321.40 ± 1.4% | | 0.99 | 0.99 | 9.61 |
| imported/sherlock/the-upper | 2223 | 12630.91 ± 1.3% | not timed | not timed | 13503.89 ± 1.7% | 2679.24 ± 2.1% | not timed | not timed | 12727.72 ± 1.1% | | 0.99 | 0.94 | 4.71 |
| imported/sherlock/the-casei | 23961 | 2006.50 ± 1.1% | not timed | not timed | 1313.09 ± 0.6% | 34.38 ± 30.0% | not timed | not timed | 2011.45 ± 0.5% | | 1.00 | 1.53 | 58.37 |
| imported/sherlock/everything-greedy | 581881 | 270.90 ± 7.7% | not timed | not timed | 164.91 ± 0.0% | 28.96 ± 13.1% | not timed | not timed | 270.40 ± 0.1% | | 1.00 | 1.64 | 9.35 |
| imported/sherlock/everything-greedy-nl | 594933 | 461.50 ± 0.1% | not timed | not timed | 213.83 ± 0.6% | 33.05 ± 0.5% | not timed | not timed | 462.44 ± 0.1% | | 1.00 | 2.16 | 13.96 |
| imported/sherlock/letters | 447175 | 54.39 ± 8.8% | not timed | not timed | 33.08 ± 0.2% | 5.16 ± 12.3% | not timed | not timed | 54.46 ± 0.6% | | 1.00 | 1.64 | 10.54 |
| imported/sherlock/letters-upper | 14180 | 432.60 ± 4.2% | not timed | not timed | 370.18 ± 3.7% | 29.63 ± 20.7% | not timed | not timed | 433.13 ± 0.3% | | 1.00 | 1.17 | 14.60 |
| imported/sherlock/letters-lower | 432995 | 55.19 ± 1.0% | not timed | not timed | 33.55 ± 0.3% | 5.74 ± 28.3% | not timed | not timed | 55.48 ± 0.5% | | 0.99 | 1.64 | 9.61 |
| imported/sherlock/words | 447639 | 106.57 ± 0.5% | not timed | not timed | 83.01 ± 0.1% | 13.96 ± 24.0% | not timed | not timed | 107.05 ± 1.0% | | 1.00 | 1.28 | 7.63 |
| imported/sherlock/before-holmes | 4073 | 597.53 ± 0.1% | not timed | not timed | 8489.23 ± 0.5% | 23.94 ± 1.2% | not timed | not timed | 595.80 ± 0.1% | | 1.00 | 0.0704 | 24.95 |
| imported/sherlock/before-after-holmes | 2593 | 595.89 ± 0.3% | not timed | not timed | 9529.35 ± 0.7% | 24.09 ± 0.9% | not timed | not timed | 597.07 ± 0.3% | | 1.00 | 0.0625 | 24.73 |
| imported/sherlock/holmes-cochar-watson | 150 | 5210.47 ± 0.2% | not timed | not timed | 3424.04 ± 0.3% | 31.00 ± 0.1% | not timed | not timed | 5216.10 ± 0.1% | | 1.00 | 1.52 | 168.11 |
| imported/sherlock/holmes-coword-watson | 14309 | 1262.03 ± 1.6% | not timed | not timed | 1124.54 ± 0.3% | 6.78 ± 0.3% | not timed | not timed | 1260.01 ± 0.6% | | 1.00 | 1.12 | 186.04 |
| imported/sherlock/quotes | 14437 | 1405.66 ± 0.4% | not timed | not timed | 1754.57 ± 1.1% | 35.08 ± 0.2% | not timed | not timed | 1411.64 ± 0.3% | | 1.00 | 0.80 | 40.07 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 600.58 ± 0.2% | not timed | not timed | 15958.03 ± 0.4% | 36.91 ± 0.1% | not timed | not timed | 600.86 ± 0.3% | | 1.00 | 0.0376 | 16.27 |
| imported/sherlock/word-ending-n | 35297 | 467.68 ± 0.9% | not timed | not timed | 408.93 ± 0.2% | 23.60 ± 21.4% | not timed | not timed | 466.80 ± 0.1% | | 1.00 | 1.14 | 19.82 |
| imported/sherlock/repeated-class-negation | 2130 | 14626.18 ± 0.7% | not timed | not timed | 10971.50 ± 0.4% | 11.58 ± 0.5% | not timed | not timed | 14598.44 ± 0.8% | | 1.00 | 1.33 | 1262.74 |
| imported/sherlock/ing-suffix | 20547 | 553.96 ± 0.3% | not timed | not timed | 517.62 ± 0.1% | 28.87 ± 0.2% | not timed | not timed | 553.49 ± 0.2% | | 1.00 | 1.07 | 19.19 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 593.86 ± 0.4% | not timed | not timed | 2104.70 ± 0.6% | 20.54 ± 0.2% | not timed | not timed | 594.20 ± 0.3% | | 1.00 | 0.28 | 28.91 |
| opt/accelerate/whole-line | 239963 | 458.81 ± 0.1% | not timed | not timed | 374.59 ± 0.4% | 92.48 ± 16.1% | not timed | not timed | 458.93 ± 0.3% | | 1.00 | 1.22 | 4.96 |
| opt/accelerate/non-dna | 16745 | 413.62 ± 0.8% | not timed | not timed | 401.29 ± 0.2% | 29.49 ± 20.8% | not timed | not timed | 412.38 ± 0.1% | | 1.00 | 1.03 | 14.03 |
| opt/backtrack/words-english | 40536 | 137.11 ± 0.4% | not timed | not timed | 92.78 ± 0.1% | 19.91 ± 7.3% | not timed | not timed | 137.04 ± 2.0% | | 1.00 | 1.48 | 6.89 |
| opt/fixed-length/too-small-ascii | 0 | 312.12 ± 0.4% | not timed | not timed | 685.38 ± 4.0% | 79.56 ± 0.6% | not timed | not timed | 309.78 ± 0.2% | | 1.01 | 0.46 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 647.31 ± 0.7% | not timed | not timed | 5846.04 ± 2.3% | 126.51 ± 0.4% | not timed | not timed | 655.62 ± 0.9% | | 0.99 | 0.11 | 5.12 |
| opt/fixed-length/go33484-1 | 0 | 44.89 ± 0.2% | not timed | not timed | 1113764.66 ± 0.5% | 61231.49 ± 0.2% | not timed | not timed | 44.83 ± 0.0% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5528.17 ± 0.1% | not timed | not timed | 1115631.79 ± 0.6% | 32402.71 ± 1.4% | not timed | not timed | 5520.64 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1752.54 ± 1.2% | not timed | not timed | 110912.07 ± 0.3% | 763.35 ± 0.3% | not timed | not timed | 1768.85 ± 1.4% | | 0.99 | 0.0158 | 2.30 |
| opt/literal-alt/one-pattern | 1 | 552.18 ± 0.1% | not timed | not timed | 494.09 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 555.76 ± 0.3% | | 0.99 | 1.12 | 1396.99 |
| opt/onepass/fn-predicate | 916 | 367.50 ± 0.6% | not timed | not timed | 334.67 ± 0.3% | 201.06 ± 14.5% | not timed | not timed | 369.73 ± 1.1% | | 0.99 | 1.10 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 149.42 ± 9.4% | not timed | not timed | 201.34 ± 0.2% | 82.94 ± 17.0% | not timed | not timed | 148.95 ± 1.2% | | 1.00 | 0.74 | 1.80 |
| opt/prefilter/literal-english | 1 | 19985.97 ± 0.9% | not timed | not timed | 19296.04 ± 0.7% | 17293.42 ± 0.2% | not timed | not timed | 19956.40 ± 0.7% | | 1.00 | 1.04 | 1.16 |
| opt/prefilter/literal-casei-english | 1 | 14234.93 ± 0.8% | not timed | not timed | 4306.10 ± 0.3% | 32.77 ± 0.2% | not timed | not timed | 14229.38 ± 0.2% | | 1.00 | 3.31 | 434.44 |
| opt/prefilter/literal-russian | 1 | 21193.56 ± 1.0% | not timed | not timed | 19796.44 ± 0.6% | 3322.73 ± 0.5% | not timed | not timed | 21250.11 ± 0.3% | | 1.00 | 1.07 | 6.38 |
| opt/prefilter/literal-casei-russian | 1 | 8557.31 ± 0.4% | not timed | not timed | 3887.21 ± 0.3% | 31.01 ± 0.2% | not timed | not timed | 8555.01 ± 0.1% | | 1.00 | 2.20 | 276.00 |
| opt/prefilter/rust-functions | 948 | 6823.39 ± 1.8% | not timed | not timed | 8931.24 ± 0.4% | 1866.31 ± 23.6% | not timed | not timed | 6827.78 ± 0.3% | | 1.00 | 0.76 | 3.66 |
| opt/reverse-anchored/word-end | 1 | 5575.72 ± 0.5% | not timed | not timed | 21052036.70 ± 0.3% | 50.33 ± 0.1% | not timed | not timed | 5570.07 ± 0.4% | | 1.00 | 0.0003 | 110.78 |
| opt/reverse-inner/holmes | 2593 | 595.68 ± 0.3% | not timed | not timed | 9487.06 ± 0.7% | 23.51 ± 1.4% | not timed | not timed | 597.11 ± 0.2% | | 1.00 | 0.0628 | 25.34 |
| opt/reverse-inner/email | 47 | 1045.57 ± 0.1% | not timed | not timed | 44824.70 ± 1.4% | 32.45 ± 0.4% | not timed | not timed | 1044.81 ± 0.1% | | 1.00 | 0.0233 | 32.22 |
| opt/reverse-inner/factored-prefix | 3542 | 590.49 ± 0.4% | not timed | not timed | 594.75 ± 0.1% | 12.58 ± 0.2% | not timed | not timed | 590.38 ± 0.2% | | 1.00 | 0.99 | 46.94 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5511.36 ± 0.1% | not timed | not timed | 618.69 ± 0.1% | 75.14 ± 0.6% | not timed | not timed | 5520.07 ± 0.1% | | 1.00 | 8.91 | 73.34 |
| opt/reverse-inner/no-quadratic-forward | 0 | 742.15 ± 7.9% | not timed | not timed | 287.88 ± 0.3% | 24.84 ± 0.0% | not timed | not timed | 741.66 ± 8.1% | | 1.00 | 2.58 | 29.88 |
| opt/reverse-suffix/holmes | 4073 | 597.15 ± 0.2% | not timed | not timed | 8452.64 ± 0.3% | 24.16 ± 1.5% | not timed | not timed | 595.00 ± 0.2% | | 1.00 | 0.0706 | 24.72 |
| opt/reverse-suffix/no-quadratic | 0 | 5521.83 ± 0.1% | not timed | not timed | 619.06 ± 0.1% | 75.09 ± 0.2% | not timed | not timed | 5505.63 ± 0.1% | | 1.00 | 8.92 | 73.54 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.60 ± 9.4% | not timed | not timed | 135.44 ± 0.1% | 13.17 ± 17.5% | not timed | not timed | 121.50 ± 2.8% | | 1.00 | 0.90 | 9.23 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 118.91 ± 2.3% | not timed | not timed | 133.64 ± 0.6% | 13.27 ± 15.7% | not timed | not timed | 120.06 ± 0.5% | | 0.99 | 0.89 | 8.96 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.54 ± 0.4% | 110.75 ± 2.7% | not timed | not timed | 0.28 ± 0.6% | | 1.00 | 0.52 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 310.42 ± 12.0% | not timed | not timed | 291.68 ± 0.1% | 104.42 ± 2.3% | not timed | not timed | 306.59 ± 0.2% | | 1.01 | 1.06 | 2.97 |
| reported/i13-subset-regex/original-ascii | 4094 | 11027.52 ± 1.0% | not timed | not timed | 4470.97 ± 1.1% | 11.54 ± 0.1% | not timed | not timed | 10998.81 ± 2.3% | | 1.00 | 2.47 | 955.59 |
| reported/i13-subset-regex/original-unicode | 4094 | 10905.24 ± 1.3% | not timed | not timed | 251.31 ± 3.4% | 11.51 ± 0.2% | not timed | not timed | 11039.11 ± 1.3% | | 0.99 | 43.39 | 947.48 |
| reported/i13-subset-regex/big-ascii | 1955 | 10526.87 ± 5.4% | not timed | not timed | 67.80 ± 3.6% | 9.86 ± 0.2% | not timed | not timed | 10571.67 ± 2.0% | | 1.00 | 155.26 | 1067.48 |
| reported/i13-subset-regex/big-unicode | 1955 | 10497.30 ± 2.0% | not timed | not timed | 12.23 ± 54.9% | 9.86 ± 0.3% | not timed | not timed | 10671.53 ± 3.2% | | 0.98 | 858.24 | 1064.78 |
| reported/i13-subset-regex/huge-ascii | 55 | 10048.59 ± 2.8% | not timed | not timed | 11.03 ± 0.0% | 8.76 ± 0.4% | not timed | not timed | 10051.03 ± 2.4% | | 1.00 | 911.02 | 1146.50 |
| reported/i13-subset-regex/huge-unicode | 55 | 10047.39 ± 2.3% | not timed | not timed | 11.04 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9893.96 ± 2.2% | | 1.02 | 910.33 | 1145.10 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.05 ± 0.1% | 8.76 ± 0.3% | not timed | not timed | 3.54 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.04 ± 0.1% | not timed | not timed | 11.03 ± 0.3% | 8.74 ± 1.0% | not timed | not timed | 5.03 ± 0.0% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 469.86 ± 0.3% | not timed | not timed | 104.66 ± 0.1% | 6.64 ± 0.3% | not timed | not timed | 468.80 ± 0.4% | | 1.00 | 4.49 | 70.79 |
| reported/i787-keywords/opt-ascii | 5674 | 470.67 ± 0.4% | not timed | not timed | 275.19 ± 0.1% | 10.31 ± 0.1% | not timed | not timed | 470.89 ± 0.4% | | 1.00 | 1.71 | 45.65 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.1% | not timed | not timed | 4.95 ± 0.1% | 0.05 ± 0.5% | not timed | not timed | 6.97 ± 0.2% | | 1.00 | 1.41 | 140.79 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.1% | not timed | not timed | 2.78 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.41 ± 0.0% | | 1.00 | 1.23 | 267.43 |
| slow/quadratic-haystack-1x | 100 | 21.21 ± 6.5% | not timed | not timed | 10.04 ± 0.2% | 1.02 ± 14.5% | not timed | not timed | 21.27 ± 1.4% | | 1.00 | 2.11 | 20.89 |
| slow/quadratic-haystack-2x | 200 | 17.40 ± 1.0% | not timed | not timed | 5.55 ± 0.1% | 0.55 ± 12.9% | not timed | not timed | 17.46 ± 1.0% | | 1.00 | 3.14 | 31.87 |
| unicode/codepoints/any-one | 1112064 | 286.20 ± 0.3% | not timed | not timed | 177.99 ± 0.1% | 17.80 ± 15.5% | not timed | not timed | 286.27 ± 0.5% | | 1.00 | 1.61 | 16.08 |
| unicode/codepoints/any-all | 4382592 | 289.68 ± 0.6% | not timed | not timed | 246.77 ± 0.1% | 117.53 ± 0.1% | not timed | not timed | 289.48 ± 0.5% | | 1.00 | 1.17 | 2.46 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 1.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 611.03 ± 0.5% | not timed | not timed | 614.81 ± 0.4% | 135.41 ± 0.2% | not timed | not timed | 610.99 ± 0.5% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 30.99 ± 0.4% | not timed | not timed | 38.90 ± 0.3% | 3.91 ± 1.2% | not timed | not timed | 31.09 ± 0.3% | | 1.00 | 0.80 | 7.93 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.1% | not timed | not timed | 3.00 ± 0.1% | 2.36 ± 0.7% | not timed | not timed | 1.35 ± 0.2% | | 1.00 | 0.45 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.8% | not timed | not timed | 2.87 ± 0.3% | 6.28 ± 9.3% | not timed | not timed | 1.21 ± 0.3% | | 1.00 | 0.42 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 116.44 ± 8.5% | not timed | not timed | 83.04 ± 0.1% | 11.99 ± 21.4% | not timed | not timed | 117.13 ± 0.8% | | 0.99 | 1.40 | 9.71 |
| unicode/word/boundary-long-english | 3466 | 606.49 ± 0.4% | not timed | not timed | 607.01 ± 0.1% | 32.77 ± 0.4% | not timed | not timed | 511.19 ± 2.1% | | 1.19 | 1.00 | 18.50 |
| unicode/word/around-holmes-english | 27 | 601.24 ± 0.4% | not timed | not timed | 19061.27 ± 0.5% | 22.25 ± 0.6% | not timed | not timed | 602.02 ± 0.4% | | 1.00 | 0.0315 | 27.02 |
| wild/bibleref/long | 874 | 564.90 ± 0.1% | not timed | not timed | 584.83 ± 0.1% | 6.80 ± 0.1% | not timed | not timed | 566.15 ± 0.2% | | 1.00 | 0.97 | 83.02 |
| wild/bibleref/short | 30 | 24.87 ± 2.0% | not timed | not timed | 31.29 ± 0.5% | 14.13 ± 11.6% | not timed | not timed | 25.70 ± 3.6% | | 0.97 | 0.79 | 1.76 |
| wild/bibleref/line | 874 | 357.13 ± 0.1% | not timed | not timed | 218.06 ± 0.2% | 9.26 ± 10.0% | not timed | not timed | 357.45 ± 6.6% | | 1.00 | 1.64 | 38.56 |
| wild/caddy/caddy | 6 | 418.95 ± 2.6% | not timed | not timed | 243.66 ± 0.2% | 68.00 ± 14.9% | not timed | not timed | 417.98 ± 0.9% | | 1.00 | 1.72 | 6.16 |
| wild/dot-star-capture/rust-src-tools | 6 | 1060.16 ± 0.3% | not timed | not timed | 344.18 ± 0.4% | 13.58 ± 0.1% | not timed | not timed | 1059.71 ± 0.3% | | 1.00 | 3.08 | 78.09 |
| wild/ruff/noqa | 84 | 404.29 ± 0.2% | not timed | not timed | 472.60 ± 0.0% | 19.84 ± 2.3% | not timed | not timed | 403.74 ± 1.4% | | 1.00 | 0.86 | 20.38 |
| wild/ruff/unnecessary-coding-comment | 16 | 489.16 ± 0.6% | not timed | not timed | 704.09 ± 0.1% | 136.97 ± 11.0% | not timed | not timed | 488.96 ± 0.7% | | 1.00 | 0.69 | 3.57 |
| wild/ruff/string-quote-prefix | 2972 | 405.52 ± 0.6% | not timed | not timed | 443.09 ± 0.1% | 316.33 ± 25.5% | not timed | not timed | 406.85 ± 0.6% | | 1.00 | 0.92 | 1.28 |
| wild/ruff/space-around-operator | 1224378 | 217.30 ± 1.8% | not timed | not timed | 185.97 ± 0.1% | 18.40 ± 1.6% | not timed | not timed | 217.71 ± 1.9% | | 1.00 | 1.17 | 11.81 |
| wild/ruff/shebang | 282 | 400.69 ± 0.5% | not timed | not timed | 329.16 ± 0.1% | 118.45 ± 14.7% | not timed | not timed | 400.95 ± 0.5% | | 1.00 | 1.22 | 3.38 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13820.49 ± 0.4% | not timed | not timed | 13686.37 ± 0.2% | 6913.27 ± 1.2% | not timed | not timed | 13820.71 ± 0.6% | | 1.00 | 1.01 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12793.24 ± 0.4% | not timed | not timed | 13386.23 ± 1.3% | 6388.74 ± 0.9% | not timed | not timed | 12826.70 ± 0.5% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13200.26 ± 0.2% | not timed | not timed | 13572.69 ± 0.9% | 6615.75 ± 1.2% | not timed | not timed | 13221.05 ± 0.3% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9573.19 ± 0.1% | not timed | not timed | 13527.10 ± 0.4% | 6773.24 ± 1.0% | not timed | not timed | 9581.71 ± 0.3% | | 1.00 | 0.71 | 1.41 |
| wild/url/search | 234965 | 121.56 ± 13.8% | not timed | not timed | 65.24 ± 0.8% | 2.20 ± 0.9% | not timed | not timed | 121.86 ± 13.6% | | 1.00 | 1.86 | 55.17 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 43.3% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 10.5% | not timed | not timed | 0.03 ± 2.1% | | 0.98 | 3.08 | 3.85 |
| dictionary/compile/english-15 | 1 | 0.35 ± 2.3% | not timed | not timed | 0.07 ± 4.1% | 0.10 ± 24.4% | not timed | not timed | 0.35 ± 1.1% | | 0.99 | 5.03 | 3.33 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 0.6% | not timed | not timed | 0.02 ± 1.4% | 35.20 ± 3.7% | not timed | not timed | 0.25 ± 1.6% | | 0.96 | 12.86 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.24 ± 2.2% | not timed | not timed | 11.50 ± 0.2% | 52.05 ± 18.9% | not timed | not timed | 47.79 ± 2.5% | | 0.99 | 4.11 | 0.91 |
| reported/i787-keywords/compile | 1 | 35.71 ± 3.3% | not timed | not timed | 2.09 ± 0.5% | 17.06 ± 24.3% | not timed | not timed | 35.68 ± 3.1% | | 1.00 | 17.09 | 2.09 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 366.76 ± 4.4% | not timed | not timed | 120.70 ± 0.3% | 557.48 ± 27.6% | not timed | not timed | 370.51 ± 4.1% | | 0.99 | 3.04 | 0.66 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.08 ± 1.9% | not timed | not timed | 4.04 ± 0.9% | 44.09 ± 4.8% | not timed | not timed | 47.97 ± 2.2% | | 0.98 | 11.65 | 1.07 |
| unicode/compile/one-letter | 53 | 6.57 ± 7.5% | not timed | not timed | 4.53 ± 0.6% | 64.81 ± 9.8% | not timed | not timed | 6.72 ± 2.7% | | 0.98 | 1.45 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 18.8% | not timed | not timed | 0.10 ± 0.6% | 64.85 ± 12.2% | not timed | not timed | 1.10 ± 6.7% | | 0.96 | 10.64 | 0.0163 |
| unicode/compile/fifty-letters-ascii | 1 | 224.33 ± 14.7% | not timed | not timed | 51.43 ± 0.2% | 197.67 ± 8.0% | not timed | not timed | 223.62 ± 7.9% | | 1.00 | 4.36 | 1.13 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 393.75 ± 2.8% | not timed | not timed | 47.20 ± 0.5% | 653.09 ± 27.2% | not timed | not timed | 395.36 ± 4.1% | | 1.00 | 8.34 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 608.42 ± 14.1% | not timed | not timed | 143.23 ± 0.1% | 666.95 ± 30.6% | not timed | not timed | 633.17 ± 1.3% | | 0.96 | 4.25 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 327.58 ± 7.0% | not timed | not timed | 51.20 ± 1.0% | 1248.48 ± 26.0% | not timed | not timed | 337.93 ± 1.3% | | 0.97 | 6.40 | 0.26 |
| wild/bibleref/compile | 3 | 5.71 ± 24.0% | not timed | not timed | 1.90 ± 0.9% | 31.83 ± 20.0% | not timed | not timed | 5.92 ± 4.1% | | 0.97 | 3.01 | 0.18 |
| wild/url/compile | 1 | 0.57 ± 17.8% | not timed | not timed | 0.14 ± 0.7% | 0.46 ± 7.2% | not timed | not timed | 0.66 ± 21.0% | | 0.86 | 3.93 | 1.22 |

