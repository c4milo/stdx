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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391571797 |
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
| literal: a word | 217 | 18980.34 ± 1.4% | 5037.64 ± 0.3% | 28.16 ± 0.1% | 17957.55 ± 2.9% | 9218.30 ± 6.7% | 17.35 ± 0.1% | 84.47 ± 1.6% | 19156.73 ± 2.8% | 3.77 | 0.99 | 1.06 | 2.06 |
| literal: a word that is not there | 0 | 21223.95 ± 4.1% | 4923.54 ± 0.4% | 28.21 ± 0.5% | 19071.99 ± 4.1% | 27833.97 ± 4.8% | 17.11 ± 0.3% | 79.73 ± 0.3% | 21034.17 ± 3.6% | 4.31 | 1.01 | 1.11 | 0.76 |
| literal: one of four words | 661 | 6345.50 ± 0.3% | 1947.66 ± 0.3% | 14.37 ± 0.4% | 3948.41 ± 0.1% | 21.88 ± 0.1% | 5.43 ± 0.1% | 6.89 ± 0.6% | 6357.08 ± 0.5% | 3.26 | 1.00 | 1.61 | 290.04 |
| literal: a word in any case | 217 | 15114.46 ± 0.7% | 2087.87 ± 0.2% | 21.35 ± 0.1% | 3971.38 ± 0.1% | 38.03 ± 0.1% | refused | differs | 15075.87 ± 0.3% | 7.24 | 1.00 | 3.81 | 397.43 |
| literal: an href attribute | 33 | 16616.98 ± 1.1% | 609.16 ± 0.4% | 27.28 ± 0.3% | 16859.26 ± 2.3% | 2262.59 ± 0.3% | 13.15 ± 0.2% | 74.09 ± 0.5% | 16689.83 ± 1.7% | 27.28 | 1.00 | 0.99 | 7.34 |
| literal: a word, second text | 123 | 19407.03 ± 1.1% | 3384.26 ± 0.2% | 27.85 ± 0.2% | 18207.34 ± 1.2% | 7622.83 ± 7.4% | 20.15 ± 0.4% | 70.52 ± 0.4% | 19476.17 ± 1.8% | 5.73 | 1.00 | 1.07 | 2.55 |
| class: two capitalized words | 1331 | 1069.58 ± 0.4% | 598.42 ± 0.2% | 26.01 ± 0.2% | 585.05 ± 0.1% | 40.65 ± 0.1% | 14.73 ± 0.2% | 67.54 ± 0.7% | 1070.66 ± 0.3% | 1.79 | 1.00 | 1.83 | 26.31 |
| class: a word that ends in ing | 3399 | 573.62 ± 0.1% | 573.78 ± 0.4% | 17.98 ± 0.1% | 547.58 ± 0.1% | 29.63 ± 13.1% | 8.20 ± 0.3% | 18.41 ± 0.1% | 573.75 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.36 |
| class: a word in capitals | 2332 | 1376.14 ± 0.3% | 603.73 ± 0.7% | 27.51 ± 0.3% | 572.30 ± 0.2% | 43.55 ± 17.6% | 17.19 ± 0.6% | 82.63 ± 0.3% | 1378.70 ± 0.3% | 2.28 | 1.00 | 2.40 | 31.60 |
| class: a number | 8288 | 1995.94 ± 0.3% | 828.87 ± 0.1% | 27.70 ± 0.2% | 1731.71 ± 0.3% | 43.27 ± 17.6% | 0.54 ± 0.6% | 57.79 ± 0.2% | 1996.85 ± 0.8% | 2.41 | 1.00 | 1.15 | 46.13 |
| class: two capitalized words, second text | 5359 | 515.68 ± 0.2% | 523.65 ± 0.2% | 23.30 ± 0.1% | 485.08 ± 0.1% | 35.44 ± 12.3% | 17.12 ± 0.2% | 62.92 ± 0.3% | 515.87 ± 0.2% | 0.98 | 1.00 | 1.06 | 14.55 |
| other: a word between two words | 6104 | 786.02 ± 0.1% | 591.76 ± 0.2% | 23.55 ± 0.2% | 736.47 ± 0.2% | 108.43 ± 8.9% | 11.21 ± 0.2% | 68.36 ± 1.3% | 787.78 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.25 |
| other: a number before a unit, second text | 1481 | 5930.22 ± 1.4% | 1120.10 ± 0.3% | 26.03 ± 0.1% | 5657.44 ± 0.3% | 40.76 ± 0.2% | 18.13 ± 0.2% | 65.85 ± 0.3% | 5900.65 ± 1.4% | 5.29 | 1.01 | 1.05 | 145.48 |
| other: a heading's start tag | 110 | 13985.88 ± 1.4% | 742.59 ± 0.3% | 27.41 ± 0.2% | 1710.25 ± 0.3% | 1574.72 ± 8.9% | 16.09 ± 11.7% | 86.24 ± 0.3% | 14077.73 ± 1.0% | 18.83 | 0.99 | 8.18 | 8.88 |
| other: a whole word | 217 | 15903.95 ± 1.3% | 599.99 ± 0.5% | 29.33 ± 0.2% | 14606.92 ± 0.9% | 49.41 ± 0.5% | 13.32 ± 0.2% | 55.11 ± 0.3% | 15962.33 ± 1.0% | 26.51 | 1.00 | 1.09 | 321.88 |
| other: a line's first word, second text | 3716 | 2044.05 ± 0.4% | 587.82 ± 0.2% | 30.98 ± 0.3% | 1723.32 ± 0.5% | 62.72 ± 6.7% | refused | refused | 2050.52 ± 0.6% | 3.48 | 1.00 | 1.19 | 32.59 |
| other: fourteen octets before an x | 87 | 24051.21 ± 1.9% | 259.37 ± 0.6% | 6.32 ± 0.3% | 3978.14 ± 1.3% | 10.66 ± 0.2% | differs | 17.81 ± 0.1% | 23724.99 ± 6.6% | 92.73 | 1.01 | 6.05 | 2257.24 |
| other: a Greek word | 21815 | 498.13 ± 0.3% | 411.34 ± 0.2% | 30.64 ± 0.1% | 290.13 ± 0.1% | 49.29 ± 10.9% | differs | refused | 499.30 ± 0.4% | 1.21 | 1.00 | 1.72 | 10.11 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.58 ± 0.2% | 19.46 ± 0.2% | 0.85 ± 0.1% | 19.84 ± 0.6% | 2.77 ± 1.1% | differs | 4.07 ± 0.1% | 19.58 ± 0.1% | 1.01 | 1.00 | 0.99 | 7.08 |
| a UUID | 32895 | 21.17 ± 0.1% | 21.13 ± 0.4% | 0.64 ± 0.1% | 15.12 ± 0.8% | 3.10 ± 0.1% | 0.73 ± 0.2% | 3.66 ± 0.1% | 21.11 ± 0.5% | 1.00 | 1.00 | 1.40 | 6.82 |
| an IPv4 address | 33176 | 36.03 ± 0.2% | 36.03 ± 0.1% | 2.05 ± 0.2% | 29.28 ± 0.2% | 6.68 ± 0.1% | differs | 4.18 ± 0.1% | 36.04 ± 0.2% | 1.00 | 1.00 | 1.23 | 5.40 |
| a date and time | 32954 | 31.04 ± 0.3% | 31.11 ± 0.4% | 1.43 ± 0.1% | 21.59 ± 0.5% | 7.05 ± 0.2% | 1.25 ± 0.3% | 7.18 ± 0.2% | 31.00 ± 0.5% | 1.00 | 1.00 | 1.44 | 4.41 |
| a field path | 32606 | 23.22 ± 0.1% | 23.15 ± 0.1% | 1.01 ± 0.2% | 23.34 ± 0.3% | 3.50 ± 1.1% | differs | 2.99 ± 0.1% | 23.15 ± 0.1% | 1.00 | 1.00 | 0.99 | 6.63 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.21 ± 0.3% | 11.20 ± 0.3% | 11.22 ± 0.3% | 11.72 ± 0.1% | 4.99 ± 1.8% | 0.94 ± 0.3% | none | 11.16 ± 3.4% | 1.00 | 1.00 | 0.96 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.29 ± 0.9% | 228.46 ± 0.2% | 268.84 ± 0.3% | 87.02 ± 0.8% | 221.14 ± 1.1% | 478.58 ± 0.3% | 3792.09 ± 4.5% | 227.61 ± 0.1% | 0.99 | 1.00 | 2.61 | 1.03 |
| a UUID | 62 | 149.38 ± 0.5% | 150.04 ± 0.4% | 166.50 ± 0.5% | 46.22 ± 0.5% | 99.48 ± 1.1% | 183.77 ± 2.5% | 4187.46 ± 0.3% | 149.42 ± 0.5% | 1.00 | 1.00 | 3.23 | 1.50 |
| an IPv4 address | 29 | 427.45 ± 0.5% | 431.25 ± 0.2% | 600.16 ± 0.6% | 79.80 ± 0.6% | 131.70 ± 1.3% | 305.88 ± 0.9% | 7485.20 ± 0.8% | 428.15 ± 0.2% | 0.99 | 1.00 | 5.36 | 3.25 |
| a date and time | 56 | 308.79 ± 0.5% | 311.13 ± 0.3% | 389.93 ± 0.1% | 73.52 ± 0.3% | 137.33 ± 8.8% | 327.15 ± 2.5% | 4801.80 ± 0.8% | 308.80 ± 0.2% | 0.99 | 1.00 | 4.20 | 2.25 |
| a field path | 39 | 219.29 ± 0.1% | 220.37 ± 0.2% | 256.74 ± 0.4% | 78.62 ± 2.3% | 206.00 ± 2.0% | 499.14 ± 2.8% | 4865.36 ± 1.1% | 219.20 ± 0.4% | 1.00 | 1.00 | 2.79 | 1.06 |
| literal: a word | 7 | 636.36 ± 0.6% | 688.66 ± 0.3% | 1232.71 ± 0.1% | 500.48 ± 1.0% | 635.05 ± 2.8% | 978.62 ± 0.3% | 31117.19 ± 0.3% | 635.96 ± 0.5% | 0.92 | 1.00 | 1.27 | 1.00 |
| literal: a word that is not there | 8 | 612.80 ± 0.6% | 667.10 ± 0.5% | 1161.73 ± 0.5% | 461.46 ± 0.3% | 609.10 ± 1.6% | 921.80 ± 0.6% | 29469.81 ± 0.1% | 614.71 ± 0.6% | 0.92 | 1.00 | 1.33 | 1.01 |
| literal: one of four words | 26 | 248.59 ± 0.2% | 403.27 ± 0.2% | 548.40 ± 0.4% | 50.76 ± 0.7% | 245.28 ± 3.7% | 372.71 ± 0.3% | 16108.37 ± 0.2% | 248.96 ± 0.4% | 0.62 | 1.00 | 4.90 | 1.01 |
| literal: a word in any case | 11 | 454.28 ± 0.2% | 486.81 ± 0.4% | 716.04 ± 0.2% | 15.68 ± 0.4% | 648.25 ± 1.9% | refused | 23763.79 ± 0.2% | 454.44 ± 0.3% | 0.93 | 1.00 | 28.98 | 0.70 |
| literal: an href attribute | 12 | 349.48 ± 0.1% | 362.03 ± 0.1% | 473.22 ± 0.3% | 45.89 ± 0.5% | 491.01 ± 1.8% | 797.56 ± 0.5% | 22221.43 ± 0.2% | 349.72 ± 0.3% | 0.97 | 1.00 | 7.62 | 0.71 |
| literal: a word, second text | 10 | 562.98 ± 0.4% | 622.62 ± 0.8% | 1039.01 ± 0.6% | 412.68 ± 0.2% | 535.12 ± 1.5% | 828.91 ± 0.6% | 27531.97 ± 0.2% | 563.88 ± 0.5% | 0.90 | 1.00 | 1.36 | 1.05 |
| class: two capitalized words | 23 | 440.11 ± 0.5% | 471.58 ± 0.4% | 676.64 ± 0.8% | 104.43 ± 1.1% | 498.93 ± 1.5% | 783.20 ± 0.2% | 6469.13 ± 0.4% | 440.21 ± 0.4% | 0.93 | 1.00 | 4.21 | 0.88 |
| class: a word that ends in ing | 9 | 571.14 ± 0.4% | 636.99 ± 0.3% | 1106.79 ± 0.4% | 134.86 ± 0.6% | 761.97 ± 1.3% | 1136.26 ± 0.4% | 16077.65 ± 1.0% | 571.60 ± 0.4% | 0.90 | 1.00 | 4.24 | 0.75 |
| class: a word in capitals | 16 | 497.32 ± 0.3% | 542.78 ± 0.3% | 857.93 ± 0.2% | 138.45 ± 1.1% | 757.34 ± 1.0% | 1017.24 ± 2.6% | 8562.50 ± 0.3% | 497.68 ± 0.2% | 0.92 | 1.00 | 3.59 | 0.66 |
| class: a number | 6 | 638.00 ± 0.4% | 704.29 ± 0.4% | 1315.85 ± 0.1% | 41.80 ± 1.7% | 1403.29 ± 1.5% | 1921.67 ± 0.4% | 22976.66 ± 0.1% | 638.23 ± 0.2% | 0.91 | 1.00 | 15.26 | 0.45 |
| class: two capitalized words, second text | 23 | 438.94 ± 0.6% | 472.16 ± 0.4% | 676.22 ± 0.5% | 103.54 ± 1.5% | 502.05 ± 4.3% | 761.31 ± 0.3% | 6458.34 ± 0.3% | 440.69 ± 0.9% | 0.93 | 1.00 | 4.24 | 0.87 |
| other: a word between two words | 13 | 553.01 ± 0.5% | 574.03 ± 0.2% | 912.18 ± 0.2% | 133.96 ± 0.2% | 504.97 ± 0.9% | 820.13 ± 1.4% | 14677.30 ± 0.5% | 552.60 ± 0.4% | 0.96 | 1.00 | 4.13 | 1.10 |
| other: a number before a unit, second text | 15 | 400.02 ± 0.4% | 439.40 ± 0.2% | 611.14 ± 0.3% | 39.40 ± 0.6% | 640.54 ± 1.0% | 891.53 ± 3.3% | 15346.11 ± 0.4% | 400.79 ± 0.3% | 0.91 | 1.00 | 10.15 | 0.62 |
| other: a heading's start tag | 13 | 360.95 ± 0.6% | 369.03 ± 0.4% | 484.40 ± 0.5% | 44.22 ± 0.2% | 632.15 ± 1.7% | 848.49 ± 0.3% | 18353.59 ± 0.6% | 362.03 ± 0.4% | 0.98 | 1.00 | 8.16 | 0.57 |
| other: a whole word | 11 | 583.47 ± 0.4% | 623.97 ± 0.2% | 1038.63 ± 0.2% | 118.33 ± 0.3% | 570.27 ± 1.4% | 832.78 ± 0.9% | 27373.92 ± 0.4% | 584.76 ± 0.6% | 0.94 | 1.00 | 4.93 | 1.02 |
| other: a line's first word, second text | 17 | 533.68 ± 0.7% | 560.82 ± 0.4% | 898.80 ± 0.5% | 130.46 ± 0.1% | 710.58 ± 1.8% | refused | refused | 535.51 ± 0.4% | 0.95 | 1.00 | 4.09 | 0.75 |
| other: fourteen octets before an x | 16 | 110.50 ± 0.9% | 158.58 ± 0.7% | 180.75 ± 0.7% | 15.21 ± 0.4% | 454.00 ± 1.2% | 409.55 ± 0.8% | 12963.09 ± 0.6% | 110.56 ± 0.6% | 0.70 | 1.00 | 7.27 | 0.24 |
| other: a Greek word | 8 | 456.42 ± 0.1% | 607.50 ± 0.3% | 1018.44 ± 0.1% | 58.76 ± 0.9% | 1401.55 ± 1.5% | 1759.53 ± 2.9% | refused | 456.26 ± 0.2% | 0.75 | 1.00 | 7.77 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15565.04 ± 0.7% | not timed | not timed | 16035.95 ± 1.2% | 2204.78 ± 18.1% | not timed | not timed | 15606.54 ± 0.7% | | 1.00 | 0.97 | 7.06 |
| 01-literal/sherlock-casei-en | 522 | 11051.19 ± 7.1% | not timed | not timed | 3589.93 ± 0.1% | 32.47 ± 0.1% | not timed | not timed | 11065.78 ± 1.5% | | 1.00 | 3.08 | 340.39 |
| 01-literal/sherlock-ru | 724 | 17116.51 ± 1.0% | not timed | not timed | 17267.07 ± 0.5% | 1443.49 ± 15.3% | not timed | not timed | 17111.69 ± 0.5% | | 1.00 | 0.99 | 11.86 |
| 01-literal/sherlock-casei-ru | 746 | 6178.98 ± 0.7% | not timed | not timed | 3335.15 ± 0.1% | 30.77 ± 0.3% | not timed | not timed | 6182.04 ± 0.3% | | 1.00 | 1.85 | 200.81 |
| 01-literal/sherlock-zh | 30 | 20120.21 ± 0.8% | not timed | not timed | 18898.20 ± 1.3% | 2687.79 ± 11.1% | not timed | not timed | 20047.62 ± 0.5% | | 1.00 | 1.06 | 7.49 |
| 02-literal-alternate/sherlock-en | 714 | 6050.97 ± 0.4% | not timed | not timed | 3937.21 ± 0.3% | 16.61 ± 0.1% | not timed | not timed | 6056.51 ± 0.2% | | 1.00 | 1.54 | 364.25 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1977.87 ± 1.0% | not timed | not timed | 699.95 ± 0.1% | 11.11 ± 0.1% | not timed | not timed | 1984.88 ± 0.7% | | 1.00 | 2.83 | 177.98 |
| 02-literal-alternate/sherlock-ru | 899 | 5562.47 ± 0.3% | not timed | not timed | 3257.40 ± 0.1% | 22.56 ± 0.2% | not timed | not timed | 5569.82 ± 0.2% | | 1.00 | 1.71 | 246.60 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2060.52 ± 0.6% | not timed | not timed | 1231.13 ± 0.3% | 9.11 ± 0.2% | not timed | not timed | 2061.72 ± 0.5% | | 1.00 | 1.67 | 226.07 |
| 02-literal-alternate/sherlock-zh | 207 | 7288.68 ± 0.3% | not timed | not timed | 4158.51 ± 0.1% | 31.45 ± 0.1% | not timed | not timed | 7283.18 ± 0.2% | | 1.00 | 1.75 | 231.78 |
| 03-date/ascii | 111817 | 123.59 ± 0.6% | not timed | not timed | 96.21 ± 0.1% | 0.20 ± 2.9% | not timed | not timed | 123.86 ± 0.7% | | 1.00 | 1.28 | 610.93 |
| 04-ruff-noqa/real | 84 | 403.51 ± 0.1% | not timed | not timed | 474.71 ± 0.1% | 19.72 ± 1.3% | not timed | not timed | 403.56 ± 0.1% | | 1.00 | 0.85 | 20.46 |
| 04-ruff-noqa/tweaked | 44 | 555.56 ± 0.5% | not timed | not timed | 458.58 ± 0.2% | 367.55 ± 0.6% | not timed | not timed | 556.28 ± 0.3% | | 1.00 | 1.21 | 1.51 |
| 05-lexer-veryl/single | 124800 | 5.52 ± 0.3% | not timed | not timed | 5.17 ± 0.2% | 0.20 ± 2.0% | not timed | not timed | 5.40 ± 0.3% | | 1.02 | 1.07 | 27.00 |
| 06-cloud-flare-redos/original | 107 | 413.26 ± 0.1% | not timed | not timed | 215.30 ± 0.1% | 24.98 ± 0.1% | not timed | not timed | 413.60 ± 0.2% | | 1.00 | 1.92 | 16.55 |
| 06-cloud-flare-redos/simplified-short | 102 | 414.33 ± 0.3% | not timed | not timed | 228.59 ± 0.0% | 26.81 ± 0.1% | not timed | not timed | 409.05 ± 0.1% | | 1.01 | 1.81 | 15.46 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.60 ± 0.1% | not timed | not timed | 255.69 ± 0.3% | 28.83 ± 0.1% | not timed | not timed | 578.16 ± 0.2% | | 1.02 | 2.30 | 20.38 |
| 07-unicode-character-data/parse-line | 558784 | 235.55 ± 2.3% | not timed | not timed | 180.86 ± 0.2% | 40.16 ± 16.6% | not timed | not timed | 238.29 ± 2.2% | | 0.99 | 1.30 | 5.87 |
| 08-words/all-english | 56691 | 115.39 ± 0.8% | not timed | not timed | 82.80 ± 0.2% | 11.64 ± 2.9% | not timed | not timed | 115.86 ± 0.2% | | 1.00 | 1.39 | 9.92 |
| 08-words/long-english | 839 | 612.77 ± 0.4% | not timed | not timed | 593.92 ± 0.1% | 32.55 ± 0.3% | not timed | not timed | 612.78 ± 0.5% | | 1.00 | 1.03 | 18.83 |
| 09-aws-keys/full | 0 | 406.84 ± 0.1% | not timed | not timed | 477.93 ± 0.1% | 61.44 ± 3.3% | not timed | not timed | 408.10 ± 0.2% | | 1.00 | 0.85 | 6.62 |
| 09-aws-keys/quick | 0 | 871.33 ± 0.3% | not timed | not timed | 996.45 ± 0.6% | 418.20 ± 0.6% | not timed | not timed | 871.90 ± 0.1% | | 1.00 | 0.87 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 584.82 ± 1.8% | not timed | not timed | 518.80 ± 0.4% | 19.51 ± 0.7% | not timed | not timed | 578.46 ± 2.9% | | 1.01 | 1.13 | 29.97 |
| 10-bounded-repeat/letters-ru | 3475 | 498.66 ± 1.3% | not timed | not timed | 476.67 ± 0.5% | 21.79 ± 17.4% | not timed | not timed | 508.85 ± 0.4% | | 0.98 | 1.05 | 22.89 |
| 10-bounded-repeat/context | 53 | 84.59 ± 1.3% | not timed | not timed | 66.25 ± 0.4% | 19.83 ± 0.1% | not timed | not timed | 84.97 ± 1.7% | | 1.00 | 1.28 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 641.51 ± 7.9% | not timed | not timed | 616.64 ± 0.0% | 36.54 ± 0.1% | not timed | not timed | 640.59 ± 8.1% | | 1.00 | 1.04 | 17.56 |
| 11-unstructured-to-json/extract | 600 | 56.89 ± 0.9% | not timed | not timed | 76.15 ± 0.2% | 49.03 ± 0.9% | not timed | not timed | 56.86 ± 1.1% | | 1.00 | 0.75 | 1.16 |
| 12-dictionary/single | 1 | 566.24 ± 0.5% | not timed | not timed | 561.34 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 568.66 ± 0.2% | | 1.00 | 1.01 | 1394.93 |
| 14-quadratic/1x | 100 | 21.15 ± 1.6% | not timed | not timed | 10.03 ± 0.1% | 0.97 ± 2.5% | not timed | not timed | 21.11 ± 1.4% | | 1.00 | 2.11 | 21.78 |
| 14-quadratic/2x | 200 | 17.39 ± 1.0% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 1.5% | not timed | not timed | 17.39 ± 0.9% | | 1.00 | 3.14 | 32.88 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.4% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.9% | not timed | not timed | 7.70 ± 0.4% | | 1.00 | 6.37 | 66.46 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 2.0% | not timed | not timed | 0.34 ± 0.9% | 0.54 ± 5.1% | not timed | not timed | 1.26 ± 0.8% | | 1.00 | 3.66 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 103.73 ± 1.9% | not timed | not timed | 13.94 ± 0.4% | 135.63 ± 2.9% | not timed | not timed | 104.07 ± 1.2% | | 1.00 | 7.44 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 14.08 ± 1.0% | not timed | not timed | 2.50 ± 1.1% | 6.43 ± 2.0% | not timed | not timed | 14.13 ± 0.8% | | 1.00 | 5.62 | 2.19 |
| 07-unicode-character-data/compile | 1 | 108.13 ± 1.1% | not timed | not timed | 26.17 ± 0.4% | 35.34 ± 12.3% | not timed | not timed | 108.49 ± 0.6% | | 1.00 | 4.13 | 3.06 |
| 09-aws-keys/compile-full | 1 | 53.08 ± 1.5% | not timed | not timed | 8.26 ± 0.7% | 23.37 ± 1.5% | not timed | not timed | 53.03 ± 0.4% | | 1.00 | 6.43 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 186.90 ± 0.6% | not timed | not timed | 47.98 ± 0.2% | 131.95 ± 4.4% | not timed | not timed | 188.09 ± 0.2% | | 0.99 | 3.90 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 71.28 ± 1.9% | not timed | not timed | 11.04 ± 0.1% | 15.80 ± 2.0% | not timed | not timed | 71.66 ± 1.4% | | 0.99 | 6.46 | 4.51 |
| 10-bounded-repeat/compile-capitals | 1 | 84.30 ± 1.0% | not timed | not timed | 7.97 ± 0.3% | 23.73 ± 2.1% | not timed | not timed | 85.16 ± 0.5% | | 0.99 | 10.57 | 3.55 |
| 11-unstructured-to-json/compile | 1 | 171.41 ± 1.1% | not timed | not timed | 40.90 ± 0.8% | 68.18 ± 3.2% | not timed | not timed | 171.51 ± 0.5% | | 1.00 | 4.19 | 2.51 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 0.7% | 0.09 ± 20.1% | not timed | not timed | 0.35 ± 0.3% | | 1.00 | 5.05 | 3.72 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.48 ± 4.9% | not timed | not timed | 6.60 ± 0.3% | 0.53 ± 21.4% | not timed | not timed | 7.62 ± 2.6% | | 0.98 | 1.13 | 14.18 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.6% | not timed | not timed | 165.56 ± 0.6% | 0.00 ± 0.4% | not timed | not timed | 1.05 ± 0.2% | | 1.00 | 0.0063 | 386.04 |
| dictionary/search/english-15 | 15 | 557.55 ± 0.5% | not timed | not timed | 560.35 ± 0.2% | 0.37 ± 0.3% | not timed | not timed | 560.93 ± 0.4% | | 0.99 | 0.99 | 1514.45 |
| folly/awyer-inn-busted | 1 | 5586.47 ± 0.1% | not timed | not timed | 143.56 ± 0.1% | 44.05 ± 0.3% | not timed | not timed | 5574.45 ± 0.1% | | 1.00 | 38.91 | 126.83 |
| folly/literal-never-match-rare | 0 | 20988.83 ± 0.8% | not timed | not timed | 19736.97 ± 0.5% | 40415.72 ± 1.4% | not timed | not timed | 21035.99 ± 0.9% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12507.18 ± 0.9% | not timed | not timed | 19858.59 ± 0.7% | 2194.17 ± 0.8% | not timed | not timed | 12530.78 ± 0.8% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3237.02 ± 0.5% | not timed | not timed | 4412.48 ± 0.1% | 3051.56 ± 0.4% | not timed | not timed | 3243.48 ± 0.3% | | 1.00 | 0.73 | 1.06 |
| grep/every-line | 239963 | 1305.51 ± 0.4% | not timed | not timed | 963.94 ± 0.4% | 382.58 ± 18.4% | not timed | not timed | 1308.88 ± 0.6% | | 1.00 | 1.35 | 3.41 |
| grep/long-words-ascii | 5073 | 459.55 ± 0.1% | not timed | not timed | 469.11 ± 0.2% | 46.25 ± 8.4% | not timed | not timed | 459.37 ± 0.3% | | 1.00 | 0.98 | 9.94 |
| imported/leipzig/twain | 811 | 20638.35 ± 1.6% | not timed | not timed | 19560.12 ± 0.6% | 11906.84 ± 10.1% | not timed | not timed | 20717.56 ± 0.9% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9056.18 ± 1.3% | not timed | not timed | 4249.69 ± 0.1% | 37.79 ± 0.4% | not timed | not timed | 9082.81 ± 0.8% | | 1.00 | 2.13 | 239.62 |
| imported/leipzig/shing | 1540 | 629.54 ± 0.1% | not timed | not timed | 13252.61 ± 0.8% | 34.06 ± 0.1% | not timed | not timed | 632.18 ± 0.2% | | 1.00 | 0.0475 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8247.59 ± 1.8% | not timed | not timed | 5596.53 ± 0.7% | 31.86 ± 0.1% | not timed | not timed | 8421.30 ± 3.0% | | 0.98 | 1.47 | 258.90 |
| imported/leipzig/word-ending-nn | 262 | 609.08 ± 0.1% | not timed | not timed | 616.94 ± 0.1% | 24.64 ± 0.4% | not timed | not timed | 577.60 ± 1.6% | | 1.05 | 0.99 | 24.72 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11057.21 ± 0.9% | not timed | not timed | 4529.96 ± 0.8% | 11.51 ± 0.2% | not timed | not timed | 11092.44 ± 1.5% | | 1.00 | 2.44 | 960.96 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7773.28 ± 2.3% | not timed | not timed | 5488.39 ± 0.1% | 16.87 ± 0.0% | not timed | not timed | 7895.91 ± 1.8% | | 0.98 | 1.42 | 460.90 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4163.98 ± 1.3% | not timed | not timed | 423.67 ± 1.2% | 11.09 ± 0.1% | not timed | not timed | 4194.93 ± 1.2% | | 0.99 | 9.83 | 375.52 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.48 ± 0.1% | not timed | not timed | 614.94 ± 0.1% | 11.15 ± 0.1% | not timed | not timed | 609.48 ± 0.2% | | 1.00 | 0.99 | 54.66 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.52 ± 0.1% | not timed | not timed | 615.32 ± 0.0% | 9.73 ± 0.1% | not timed | not timed | 609.98 ± 0.3% | | 1.00 | 0.99 | 62.64 |
| imported/leipzig/tom-river | 2 | 6399.78 ± 5.6% | not timed | not timed | 5077.56 ± 0.4% | 31.03 ± 0.1% | not timed | not timed | 6428.46 ± 1.7% | | 1.00 | 1.26 | 206.27 |
| imported/leipzig/ing | 78424 | 608.40 ± 0.5% | not timed | not timed | 572.03 ± 0.1% | 28.17 ± 3.5% | not timed | not timed | 607.21 ± 0.6% | | 1.00 | 1.06 | 21.60 |
| imported/leipzig/ing-whitespace | 55248 | 756.91 ± 1.4% | not timed | not timed | 2074.47 ± 0.4% | 20.53 ± 2.9% | not timed | not timed | 757.55 ± 0.2% | | 1.00 | 0.36 | 36.86 |
| imported/leipzig/awyer-inn | 209 | 773.92 ± 1.6% | not timed | not timed | 4180.28 ± 4.3% | 22.71 ± 0.0% | not timed | not timed | 775.07 ± 1.6% | | 1.00 | 0.19 | 34.07 |
| imported/leipzig/quotes-bounded | 8886 | 2112.29 ± 0.5% | not timed | not timed | 2975.71 ± 2.3% | 38.12 ± 0.1% | not timed | not timed | 2113.83 ± 0.7% | | 1.00 | 0.71 | 55.41 |
| imported/leipzig/non-ascii-alternate | 2 | 12778.86 ± 1.9% | not timed | not timed | 5649.68 ± 0.5% | 51.05 ± 0.1% | not timed | not timed | 12991.38 ± 2.9% | | 0.98 | 2.26 | 250.30 |
| imported/leipzig/math-symbols | 69 | 1972.41 ± 0.7% | not timed | not timed | 619.16 ± 0.1% | 36.50 ± 0.1% | not timed | not timed | 1972.32 ± 0.3% | | 1.00 | 3.19 | 54.04 |
| imported/leipzig/bounded-strings-ending-z | 0 | 593.32 ± 0.5% | not timed | not timed | 617.62 ± 0.1% | 22.56 ± 0.2% | not timed | not timed | 595.10 ± 0.5% | | 1.00 | 0.96 | 26.30 |
| imported/lh3lh3-reb/uri | 17549 | 632.66 ± 0.1% | not timed | not timed | 1078.91 ± 0.1% | 27.94 ± 2.3% | not timed | not timed | 632.39 ± 0.7% | | 1.00 | 0.59 | 22.64 |
| imported/lh3lh3-reb/email | 15057 | 667.38 ± 0.2% | not timed | not timed | 1177.79 ± 0.1% | 31.02 ± 2.5% | not timed | not timed | 668.21 ± 0.1% | | 1.00 | 0.57 | 21.51 |
| imported/lh3lh3-reb/date | 668 | 863.85 ± 0.2% | not timed | not timed | 1048.28 ± 0.2% | 49.87 ± 3.9% | not timed | not timed | 864.66 ± 0.2% | | 1.00 | 0.82 | 17.32 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.08 ± 0.2% | not timed | not timed | 423.48 ± 0.2% | 15.82 ± 1.3% | not timed | not timed | 642.26 ± 0.2% | | 1.00 | 1.52 | 40.60 |
| imported/mariomka/email | 92 | 705.31 ± 0.1% | not timed | not timed | 29201.45 ± 1.7% | 32.77 ± 0.1% | not timed | not timed | 706.06 ± 0.2% | | 1.00 | 0.0242 | 21.52 |
| imported/mariomka/uri | 5301 | 607.90 ± 0.1% | not timed | not timed | 5913.74 ± 2.0% | 32.76 ± 0.3% | not timed | not timed | 605.09 ± 0.2% | | 1.00 | 0.10 | 18.56 |
| imported/mariomka/ip | 5 | 2146.47 ± 2.3% | not timed | not timed | 2923.58 ± 0.6% | 21.07 ± 0.4% | not timed | not timed | 2143.73 ± 2.2% | | 1.00 | 0.73 | 101.87 |
| imported/rsc/no-exponential | 0 | 567.32 ± 0.1% | not timed | not timed | 321.01 ± 0.2% | 23.85 ± 0.1% | not timed | not timed | 566.27 ± 0.1% | | 1.00 | 1.77 | 23.79 |
| imported/rsc/literal | 1 | 690.52 ± 8.6% | not timed | not timed | 1592.63 ± 7.9% | 212.25 ± 14.0% | not timed | not timed | 741.77 ± 8.4% | | 0.93 | 0.43 | 3.25 |
| imported/rsc/not-literal | 2 | 703.92 ± 0.2% | not timed | not timed | 718.24 ± 0.2% | 46.50 ± 0.6% | not timed | not timed | 703.19 ± 7.8% | | 1.00 | 0.98 | 15.14 |
| imported/rsc/match-class | 1 | 1291.39 ± 2.5% | not timed | not timed | 1670.41 ± 0.4% | 58.74 ± 14.3% | not timed | not timed | 1299.19 ± 0.2% | | 0.99 | 0.77 | 21.99 |
| imported/rsc/match-class-in-range | 1 | 1301.09 ± 0.4% | not timed | not timed | 2348.37 ± 5.9% | 60.30 ± 0.2% | not timed | not timed | 1299.68 ± 0.1% | | 1.00 | 0.55 | 21.58 |
| imported/rsc/match-class-unicode | 1 | 524.03 ± 0.2% | not timed | not timed | 514.37 ± 0.1% | 72.82 ± 8.0% | not timed | not timed | 522.87 ± 2.0% | | 1.00 | 1.02 | 7.20 |
| imported/rsc/anchored-literal-short-non-match | 0 | 508.07 ± 0.4% | not timed | not timed | 948.99 ± 0.1% | 227.12 ± 0.8% | not timed | not timed | 507.91 ± 0.5% | | 1.00 | 0.54 | 2.24 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7677.79 ± 0.1% | not timed | not timed | 14085.22 ± 0.2% | 3420.38 ± 0.8% | not timed | not timed | 7687.51 ± 0.1% | | 1.00 | 0.55 | 2.24 |
| imported/rsc/anchored-literal-short-match | 4 | 420.40 ± 2.4% | not timed | not timed | 491.83 ± 0.3% | 82.78 ± 11.8% | not timed | not timed | 417.86 ± 2.2% | | 1.01 | 0.85 | 5.08 |
| imported/rsc/anchored-literal-long-match | 4 | 2971.39 ± 2.4% | not timed | not timed | 7271.62 ± 0.1% | 1228.39 ± 3.0% | not timed | not timed | 3022.70 ± 2.2% | | 0.98 | 0.41 | 2.42 |
| imported/rsc/one-pass-short | 17 | 307.97 ± 1.5% | not timed | not timed | 213.49 ± 0.5% | 30.19 ± 12.5% | not timed | not timed | 305.02 ± 2.9% | | 1.01 | 1.44 | 10.20 |
| imported/rsc/one-pass-short-not | 17 | 216.57 ± 7.3% | not timed | not timed | 222.93 ± 0.2% | 31.05 ± 13.5% | not timed | not timed | 216.86 ± 2.1% | | 1.00 | 0.97 | 6.97 |
| imported/rsc/one-pass-long-prefix | 26 | 215.61 ± 9.4% | not timed | not timed | 277.78 ± 0.3% | 97.67 ± 16.3% | not timed | not timed | 220.32 ± 2.1% | | 0.98 | 0.78 | 2.21 |
| imported/rsc/one-pass-long-prefix-not | 26 | 311.29 ± 1.8% | not timed | not timed | 284.48 ± 0.2% | 62.58 ± 19.2% | not timed | not timed | 309.89 ± 2.0% | | 1.00 | 1.09 | 4.97 |
| imported/rsc/long-needle1 | 31 | 21907.27 ± 0.1% | not timed | not timed | 20149.66 ± 0.3% | 3.68 ± 0.2% | not timed | not timed | 21920.65 ± 0.2% | | 1.00 | 1.09 | 5953.66 |
| imported/rsc/long-needle2 | 31 | 22103.10 ± 0.1% | not timed | not timed | 216.55 ± 0.2% | 3.68 ± 0.2% | not timed | not timed | 22095.57 ± 0.1% | | 1.00 | 102.07 | 6000.27 |
| imported/rsc/easy0-32 | 26 | 1067.20 ± 3.4% | not timed | not timed | 1501.29 ± 4.9% | 148.29 ± 18.4% | not timed | not timed | 1064.59 ± 0.7% | | 1.00 | 0.71 | 7.20 |
| imported/rsc/easy0-1k | 26 | 14909.14 ± 2.2% | not timed | not timed | 12454.98 ± 1.5% | 2303.71 ± 12.2% | not timed | not timed | 14917.61 ± 0.2% | | 1.00 | 1.20 | 6.47 |
| imported/rsc/easy0-32k | 26 | 22890.21 ± 0.2% | not timed | not timed | 20414.30 ± 0.1% | 18823.33 ± 0.1% | not timed | not timed | 22903.90 ± 0.1% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21493.38 ± 0.9% | not timed | not timed | 19834.41 ± 1.7% | 35332.48 ± 3.1% | not timed | not timed | 21497.18 ± 0.9% | | 1.00 | 1.08 | 0.61 |
| imported/rsc/easy1-32 | 19 | 357.63 ± 1.9% | not timed | not timed | 627.76 ± 0.4% | 122.44 ± 16.0% | not timed | not timed | 358.86 ± 2.2% | | 1.00 | 0.57 | 2.92 |
| imported/rsc/easy1-1k | 19 | 583.27 ± 2.7% | not timed | not timed | 12948.09 ± 0.5% | 2489.39 ± 15.9% | not timed | not timed | 579.53 ± 0.3% | | 1.01 | 0.0450 | 0.23 |
| imported/rsc/easy1-32k | 19 | 601.97 ± 0.6% | not timed | not timed | 405949.47 ± 0.3% | 20460.53 ± 0.3% | not timed | not timed | 599.95 ± 0.3% | | 1.00 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 603.62 ± 0.5% | not timed | not timed | 13026095.29 ± 0.2% | 38362.32 ± 2.0% | not timed | not timed | 601.80 ± 0.5% | | 1.00 | 0.0000 | 0.0157 |
| imported/rsc/medium-32 | 27 | 428.80 ± 0.5% | not timed | not timed | 632.83 ± 0.2% | 70.10 ± 14.9% | not timed | not timed | 429.86 ± 0.3% | | 1.00 | 0.68 | 6.12 |
| imported/rsc/medium-1k | 27 | 6814.54 ± 0.1% | not timed | not timed | 11097.58 ± 0.1% | 71.69 ± 0.1% | not timed | not timed | 6818.18 ± 0.1% | | 1.00 | 0.61 | 95.05 |
| imported/rsc/medium-32k | 27 | 21539.88 ± 0.0% | not timed | not timed | 347387.20 ± 0.1% | 48.51 ± 0.1% | not timed | not timed | 21616.55 ± 0.1% | | 1.00 | 0.0620 | 444.01 |
| imported/rsc/medium-1mb | 27 | 20886.28 ± 0.7% | not timed | not timed | 11244380.65 ± 0.2% | 48.48 ± 0.3% | not timed | not timed | 20966.35 ± 1.4% | | 1.00 | 0.0019 | 430.84 |
| imported/rsc/hard-32 | 58 | 254.61 ± 2.3% | not timed | not timed | 363.44 ± 0.1% | 49.76 ± 7.4% | not timed | not timed | 254.89 ± 0.1% | | 1.00 | 0.70 | 5.12 |
| imported/rsc/hard-1k | 27 | 577.87 ± 0.3% | not timed | not timed | 11511.41 ± 0.1% | 40.67 ± 0.2% | not timed | not timed | 574.95 ± 0.2% | | 1.01 | 0.0502 | 14.21 |
| imported/rsc/hard-32k | 27 | 601.12 ± 0.2% | not timed | not timed | 361304.31 ± 0.2% | 29.40 ± 0.1% | not timed | not timed | 599.58 ± 0.2% | | 1.00 | 0.0017 | 20.44 |
| imported/rsc/hard-1mb | 51 | 601.08 ± 0.2% | not timed | not timed | 7263982.66 ± 0.2% | 29.44 ± 0.0% | not timed | not timed | 598.87 ± 0.4% | | 1.00 | 0.0001 | 20.42 |
| imported/rsc/reallyhard0-32 | 58 | 252.71 ± 0.2% | not timed | not timed | 224.45 ± 0.0% | 49.68 ± 8.0% | not timed | not timed | 254.23 ± 2.6% | | 0.99 | 1.13 | 5.09 |
| imported/rsc/reallyhard0-1k | 27 | 576.94 ± 0.3% | not timed | not timed | 586.05 ± 0.1% | 40.82 ± 0.2% | not timed | not timed | 581.57 ± 0.4% | | 0.99 | 0.98 | 14.14 |
| imported/rsc/reallyhard0-32k | 27 | 601.36 ± 0.4% | not timed | not timed | 616.96 ± 0.1% | 29.37 ± 0.1% | not timed | not timed | 603.52 ± 0.4% | | 1.00 | 0.97 | 20.48 |
| imported/rsc/reallyhard0-1mb | 51 | 590.21 ± 0.8% | not timed | not timed | 616.06 ± 0.5% | 29.44 ± 0.1% | not timed | not timed | 594.70 ± 0.6% | | 0.99 | 0.96 | 20.05 |
| imported/rsc/reallyreallyhard0-32 | 47 | 272.49 ± 0.1% | not timed | not timed | 197.06 ± 0.1% | 61.32 ± 12.7% | not timed | not timed | 271.78 ± 4.2% | | 1.00 | 1.38 | 4.44 |
| imported/rsc/reallyreallyhard0-1k | 16 | 854.91 ± 1.3% | not timed | not timed | 5935.71 ± 0.1% | 34.13 ± 1.8% | not timed | not timed | 856.84 ± 2.2% | | 1.00 | 0.14 | 25.05 |
| imported/rsc/reallyreallyhard0-32k | 16 | 627.93 ± 2.3% | not timed | not timed | 19274.68 ± 0.1% | 25.09 ± 0.8% | not timed | not timed | 629.16 ± 5.5% | | 1.00 | 0.0326 | 25.02 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 588.63 ± 0.9% | not timed | not timed | 19966.97 ± 1.3% | 25.17 ± 0.2% | not timed | not timed | 595.47 ± 0.6% | | 0.99 | 0.0295 | 23.38 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 267.49 ± 3.0% | not timed | not timed | 212.27 ± 0.2% | 60.86 ± 10.4% | not timed | not timed | 267.04 ± 0.1% | | 1.00 | 1.26 | 4.40 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 841.98 ± 0.9% | not timed | not timed | 6167.92 ± 0.1% | 34.34 ± 0.4% | not timed | not timed | 842.50 ± 1.0% | | 1.00 | 0.14 | 24.52 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 624.44 ± 3.7% | not timed | not timed | 19272.28 ± 0.1% | 24.79 ± 1.0% | not timed | not timed | 625.24 ± 5.0% | | 1.00 | 0.0324 | 25.19 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 587.96 ± 1.3% | not timed | not timed | 19589.61 ± 0.8% | 24.85 ± 1.2% | not timed | not timed | 587.88 ± 1.2% | | 1.00 | 0.0300 | 23.66 |
| imported/sherlock/name-sherlock | 776 | 20072.09 ± 2.4% | not timed | not timed | 18808.44 ± 0.1% | 8867.43 ± 22.6% | not timed | not timed | 20100.64 ± 2.3% | | 1.00 | 1.07 | 2.26 |
| imported/sherlock/name-holmes | 2766 | 15124.72 ± 5.9% | not timed | not timed | 15620.39 ± 0.4% | 3185.30 ± 9.5% | not timed | not timed | 15416.14 ± 5.0% | | 0.98 | 0.97 | 4.75 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20049.46 ± 2.8% | not timed | not timed | 18624.23 ± 1.0% | 8039.70 ± 37.1% | not timed | not timed | 20063.67 ± 0.5% | | 1.00 | 1.08 | 2.49 |
| imported/sherlock/name-sherlock-casei | 816 | 15819.04 ± 0.4% | not timed | not timed | 4024.49 ± 0.6% | 32.52 ± 0.5% | not timed | not timed | 15820.01 ± 0.5% | | 1.00 | 3.93 | 486.50 |
| imported/sherlock/name-holmes-casei | 2802 | 9464.37 ± 4.4% | not timed | not timed | 3325.26 ± 0.1% | 37.50 ± 0.2% | not timed | not timed | 9470.87 ± 6.5% | | 1.00 | 2.85 | 252.41 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13067.91 ± 3.2% | not timed | not timed | 3956.01 ± 0.1% | 32.52 ± 0.3% | not timed | not timed | 13080.18 ± 0.9% | | 1.00 | 3.30 | 401.87 |
| imported/sherlock/name-whitespace | 1461 | 15226.72 ± 1.7% | not timed | not timed | 14620.67 ± 0.1% | 7389.76 ± 45.8% | not timed | not timed | 15276.06 ± 0.2% | | 1.00 | 1.04 | 2.06 |
| imported/sherlock/name-alt1 | 1142 | 11493.26 ± 2.5% | not timed | not timed | 16433.20 ± 0.8% | 4120.70 ± 15.2% | not timed | not timed | 11520.21 ± 0.6% | | 1.00 | 0.70 | 2.79 |
| imported/sherlock/name-alt2 | 3542 | 8660.68 ± 0.4% | not timed | not timed | 3828.08 ± 0.1% | 31.47 ± 0.2% | not timed | not timed | 8650.11 ± 0.1% | | 1.00 | 2.26 | 275.24 |
| imported/sherlock/name-alt3 | 4507 | 5455.71 ± 0.6% | not timed | not timed | 3632.69 ± 0.1% | 9.95 ± 1.3% | not timed | not timed | 5457.36 ± 0.3% | | 1.00 | 1.50 | 548.05 |
| imported/sherlock/name-alt3-casei | 4593 | 1517.28 ± 1.8% | not timed | not timed | 285.79 ± 0.2% | 6.45 ± 0.2% | not timed | not timed | 1518.04 ± 1.1% | | 1.00 | 5.31 | 235.34 |
| imported/sherlock/name-alt4 | 3686 | 6176.55 ± 0.1% | not timed | not timed | 3782.78 ± 0.2% | 30.02 ± 0.2% | not timed | not timed | 6180.96 ± 0.4% | | 1.00 | 1.63 | 205.75 |
| imported/sherlock/name-alt4-casei | 4254 | 2757.77 ± 2.5% | not timed | not timed | 2602.88 ± 0.1% | 19.66 ± 0.3% | not timed | not timed | 2765.63 ± 1.1% | | 1.00 | 1.06 | 140.28 |
| imported/sherlock/name-alt5 | 4028 | 6239.56 ± 0.3% | not timed | not timed | 3743.38 ± 0.1% | 21.51 ± 0.1% | not timed | not timed | 6242.76 ± 0.2% | | 1.00 | 1.67 | 290.06 |
| imported/sherlock/name-alt5-casei | 4104 | 3449.43 ± 2.1% | not timed | not timed | 2226.48 ± 0.1% | 14.22 ± 0.1% | not timed | not timed | 3457.74 ± 1.1% | | 1.00 | 1.55 | 242.57 |
| imported/sherlock/no-match-uncommon | 0 | 21938.23 ± 0.3% | not timed | not timed | 19837.94 ± 0.3% | 36955.69 ± 0.4% | not timed | not timed | 21968.69 ± 0.1% | | 1.00 | 1.11 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21809.46 ± 0.4% | not timed | not timed | 19821.71 ± 0.2% | 1282.89 ± 1.0% | not timed | not timed | 21840.49 ± 0.8% | | 1.00 | 1.10 | 17.00 |
| imported/sherlock/no-match-really-common | 0 | 16378.99 ± 3.5% | not timed | not timed | 19042.56 ± 0.3% | 1272.72 ± 0.9% | not timed | not timed | 16386.05 ± 1.1% | | 1.00 | 0.86 | 12.87 |
| imported/sherlock/the-lower | 21654 | 2302.17 ± 1.1% | not timed | not timed | 2334.94 ± 0.2% | 238.13 ± 15.3% | not timed | not timed | 2323.08 ± 1.2% | | 0.99 | 0.99 | 9.67 |
| imported/sherlock/the-upper | 2223 | 12732.13 ± 1.6% | not timed | not timed | 13615.26 ± 0.6% | 2704.43 ± 1.4% | not timed | not timed | 12796.55 ± 1.1% | | 0.99 | 0.94 | 4.71 |
| imported/sherlock/the-casei | 23961 | 2010.28 ± 1.0% | not timed | not timed | 1316.95 ± 0.4% | 34.77 ± 28.4% | not timed | not timed | 2013.41 ± 0.4% | | 1.00 | 1.53 | 57.82 |
| imported/sherlock/everything-greedy | 581881 | 270.86 ± 0.1% | not timed | not timed | 164.77 ± 0.1% | 29.00 ± 24.9% | not timed | not timed | 270.34 ± 0.7% | | 1.00 | 1.64 | 9.34 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.52 ± 0.1% | not timed | not timed | 213.86 ± 0.2% | 32.95 ± 0.1% | not timed | not timed | 463.56 ± 0.1% | | 1.00 | 2.16 | 14.04 |
| imported/sherlock/letters | 447175 | 54.24 ± 0.8% | not timed | not timed | 32.79 ± 0.1% | 5.65 ± 33.8% | not timed | not timed | 54.28 ± 0.6% | | 1.00 | 1.65 | 9.61 |
| imported/sherlock/letters-upper | 14180 | 432.90 ± 1.4% | not timed | not timed | 371.51 ± 0.1% | 29.55 ± 23.1% | not timed | not timed | 433.49 ± 0.1% | | 1.00 | 1.17 | 14.65 |
| imported/sherlock/letters-lower | 432995 | 54.83 ± 0.9% | not timed | not timed | 33.82 ± 0.3% | 5.27 ± 38.3% | not timed | not timed | 55.35 ± 0.8% | | 0.99 | 1.62 | 10.41 |
| imported/sherlock/words | 447639 | 104.33 ± 0.9% | not timed | not timed | 82.67 ± 0.2% | 13.92 ± 2.1% | not timed | not timed | 104.95 ± 0.7% | | 0.99 | 1.26 | 7.50 |
| imported/sherlock/before-holmes | 4073 | 598.69 ± 0.8% | not timed | not timed | 8525.21 ± 0.3% | 24.13 ± 2.1% | not timed | not timed | 596.56 ± 0.4% | | 1.00 | 0.0702 | 24.81 |
| imported/sherlock/before-after-holmes | 2593 | 596.12 ± 0.2% | not timed | not timed | 9479.17 ± 0.6% | 23.84 ± 2.1% | not timed | not timed | 597.89 ± 0.3% | | 1.00 | 0.0629 | 25.00 |
| imported/sherlock/holmes-cochar-watson | 150 | 5225.43 ± 0.1% | not timed | not timed | 3427.28 ± 0.1% | 30.47 ± 0.1% | not timed | not timed | 5227.91 ± 0.3% | | 1.00 | 1.52 | 171.51 |
| imported/sherlock/holmes-coword-watson | 14309 | 1263.40 ± 2.0% | not timed | not timed | 1121.49 ± 0.4% | 6.76 ± 0.3% | not timed | not timed | 1261.74 ± 3.0% | | 1.00 | 1.13 | 187.00 |
| imported/sherlock/quotes | 14437 | 1390.23 ± 0.3% | not timed | not timed | 1754.69 ± 0.9% | 34.81 ± 0.4% | not timed | not timed | 1412.07 ± 0.2% | | 0.98 | 0.79 | 39.93 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 602.58 ± 0.6% | not timed | not timed | 16222.34 ± 0.2% | 36.11 ± 0.3% | not timed | not timed | 601.35 ± 0.9% | | 1.00 | 0.0371 | 16.69 |
| imported/sherlock/word-ending-n | 35297 | 467.91 ± 1.2% | not timed | not timed | 409.60 ± 0.1% | 23.46 ± 24.0% | not timed | not timed | 454.87 ± 0.3% | | 1.03 | 1.14 | 19.95 |
| imported/sherlock/repeated-class-negation | 2130 | 14839.73 ± 0.9% | not timed | not timed | 10955.45 ± 0.5% | 11.40 ± 1.7% | not timed | not timed | 14844.45 ± 0.7% | | 1.00 | 1.35 | 1301.90 |
| imported/sherlock/ing-suffix | 20547 | 554.24 ± 0.3% | not timed | not timed | 517.92 ± 0.1% | 28.79 ± 0.1% | not timed | not timed | 553.12 ± 0.2% | | 1.00 | 1.07 | 19.25 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.41 ± 0.2% | not timed | not timed | 2104.30 ± 0.3% | 20.50 ± 0.2% | not timed | not timed | 594.45 ± 0.2% | | 1.00 | 0.28 | 29.00 |
| opt/accelerate/whole-line | 239963 | 458.44 ± 0.1% | not timed | not timed | 374.07 ± 0.3% | 92.04 ± 16.5% | not timed | not timed | 458.44 ± 0.4% | | 1.00 | 1.23 | 4.98 |
| opt/accelerate/non-dna | 16745 | 409.61 ± 1.1% | not timed | not timed | 401.47 ± 0.1% | 29.24 ± 21.3% | not timed | not timed | 408.49 ± 0.6% | | 1.00 | 1.02 | 14.01 |
| opt/backtrack/words-english | 40536 | 136.38 ± 2.1% | not timed | not timed | 94.48 ± 0.3% | 19.91 ± 8.7% | not timed | not timed | 136.92 ± 7.6% | | 1.00 | 1.44 | 6.85 |
| opt/fixed-length/too-small-ascii | 0 | 312.71 ± 0.2% | not timed | not timed | 704.72 ± 4.4% | 79.55 ± 0.7% | not timed | not timed | 309.88 ± 0.1% | | 1.01 | 0.44 | 3.93 |
| opt/fixed-length/too-big-ascii | 0 | 647.42 ± 0.4% | not timed | not timed | 5822.69 ± 0.2% | 126.00 ± 0.5% | not timed | not timed | 655.95 ± 1.1% | | 0.99 | 0.11 | 5.14 |
| opt/fixed-length/go33484-1 | 0 | 44.93 ± 0.1% | not timed | not timed | 1110593.64 ± 0.6% | 61248.63 ± 0.5% | not timed | not timed | 44.90 ± 0.1% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5534.97 ± 0.1% | not timed | not timed | 1115463.37 ± 0.5% | 31953.98 ± 1.8% | not timed | not timed | 5519.63 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1820.59 ± 3.4% | not timed | not timed | 111813.87 ± 0.6% | 763.36 ± 0.4% | not timed | not timed | 1782.87 ± 2.0% | | 1.02 | 0.0163 | 2.38 |
| opt/literal-alt/one-pattern | 1 | 555.75 ± 0.1% | not timed | not timed | 535.63 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 555.24 ± 0.2% | | 1.00 | 1.04 | 1396.92 |
| opt/onepass/fn-predicate | 916 | 364.69 ± 0.9% | not timed | not timed | 328.21 ± 0.1% | 200.51 ± 13.1% | not timed | not timed | 369.66 ± 0.7% | | 0.99 | 1.11 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 145.76 ± 5.6% | not timed | not timed | 201.20 ± 0.1% | 81.12 ± 9.0% | not timed | not timed | 149.11 ± 1.9% | | 0.98 | 0.72 | 1.80 |
| opt/prefilter/literal-english | 1 | 20131.86 ± 0.7% | not timed | not timed | 19341.06 ± 0.4% | 17272.32 ± 0.7% | not timed | not timed | 20103.95 ± 0.8% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14343.47 ± 0.9% | not timed | not timed | 4309.04 ± 0.3% | 32.57 ± 0.6% | not timed | not timed | 14348.35 ± 0.5% | | 1.00 | 3.33 | 440.39 |
| opt/prefilter/literal-russian | 1 | 21180.65 ± 0.6% | not timed | not timed | 19811.15 ± 0.6% | 3321.74 ± 0.3% | not timed | not timed | 21224.09 ± 0.3% | | 1.00 | 1.07 | 6.38 |
| opt/prefilter/literal-casei-russian | 1 | 8553.83 ± 0.4% | not timed | not timed | 3880.14 ± 0.5% | 30.89 ± 0.3% | not timed | not timed | 8554.51 ± 0.4% | | 1.00 | 2.20 | 276.93 |
| opt/prefilter/rust-functions | 948 | 6742.82 ± 2.6% | not timed | not timed | 8954.62 ± 0.5% | 1866.36 ± 0.4% | not timed | not timed | 6776.95 ± 0.7% | | 0.99 | 0.75 | 3.61 |
| opt/reverse-anchored/word-end | 1 | 5573.91 ± 0.3% | not timed | not timed | 20834407.65 ± 0.3% | 50.01 ± 0.2% | not timed | not timed | 5580.47 ± 0.3% | | 1.00 | 0.0003 | 111.46 |
| opt/reverse-inner/holmes | 2593 | 597.13 ± 0.7% | not timed | not timed | 9494.04 ± 0.6% | 23.77 ± 0.2% | not timed | not timed | 597.79 ± 0.2% | | 1.00 | 0.0629 | 25.12 |
| opt/reverse-inner/email | 47 | 1044.89 ± 0.2% | not timed | not timed | 44588.69 ± 0.7% | 32.40 ± 0.2% | not timed | not timed | 1044.43 ± 0.2% | | 1.00 | 0.0234 | 32.25 |
| opt/reverse-inner/factored-prefix | 3542 | 590.68 ± 0.2% | not timed | not timed | 596.09 ± 0.1% | 11.97 ± 0.1% | not timed | not timed | 591.99 ± 0.2% | | 1.00 | 0.99 | 49.34 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5509.95 ± 0.1% | not timed | not timed | 616.54 ± 0.6% | 75.10 ± 0.1% | not timed | not timed | 5520.29 ± 0.1% | | 1.00 | 8.94 | 73.37 |
| opt/reverse-inner/no-quadratic-forward | 0 | 688.54 ± 2.1% | not timed | not timed | 287.40 ± 0.4% | 24.83 ± 0.2% | not timed | not timed | 689.79 ± 2.0% | | 1.00 | 2.40 | 27.73 |
| opt/reverse-suffix/holmes | 4073 | 598.64 ± 0.4% | not timed | not timed | 8508.58 ± 0.1% | 23.93 ± 1.1% | not timed | not timed | 596.88 ± 0.1% | | 1.00 | 0.0704 | 25.02 |
| opt/reverse-suffix/no-quadratic | 0 | 5519.49 ± 0.1% | not timed | not timed | 610.81 ± 0.4% | 74.82 ± 0.1% | not timed | not timed | 5507.21 ± 0.1% | | 1.00 | 9.04 | 73.77 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.57 ± 8.6% | not timed | not timed | 133.66 ± 0.3% | 13.40 ± 16.8% | not timed | not timed | 121.26 ± 1.8% | | 1.00 | 0.91 | 9.07 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.64 ± 1.7% | not timed | not timed | 133.03 ± 1.7% | 13.34 ± 15.2% | not timed | not timed | 114.91 ± 3.0% | | 1.05 | 0.91 | 9.04 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 3.6% | not timed | not timed | 0.55 ± 0.3% | 112.87 ± 7.7% | not timed | not timed | 0.28 ± 0.2% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.27 ± 0.3% | not timed | not timed | 295.32 ± 0.1% | 104.38 ± 0.1% | not timed | not timed | 309.09 ± 0.1% | | 1.02 | 1.07 | 3.03 |
| reported/i13-subset-regex/original-ascii | 4094 | 10978.87 ± 3.0% | not timed | not timed | 4436.85 ± 4.1% | 11.51 ± 0.3% | not timed | not timed | 10871.43 ± 2.9% | | 1.01 | 2.47 | 953.51 |
| reported/i13-subset-regex/original-unicode | 4094 | 10937.44 ± 1.0% | not timed | not timed | 251.00 ± 3.2% | 11.50 ± 0.2% | not timed | not timed | 11003.09 ± 0.9% | | 0.99 | 43.58 | 950.70 |
| reported/i13-subset-regex/big-ascii | 1955 | 10712.91 ± 1.7% | not timed | not timed | 68.08 ± 3.6% | 9.86 ± 1.5% | not timed | not timed | 10725.41 ± 1.0% | | 1.00 | 157.35 | 1086.42 |
| reported/i13-subset-regex/big-unicode | 1955 | 10617.31 ± 4.7% | not timed | not timed | 12.19 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10732.30 ± 3.4% | | 0.99 | 870.68 | 1077.63 |
| reported/i13-subset-regex/huge-ascii | 55 | 9903.26 ± 3.9% | not timed | not timed | 11.01 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 9842.07 ± 4.6% | | 1.01 | 899.70 | 1129.78 |
| reported/i13-subset-regex/huge-unicode | 55 | 9786.29 ± 4.6% | not timed | not timed | 10.96 ± 0.3% | 8.75 ± 0.2% | not timed | not timed | 9885.08 ± 6.5% | | 0.99 | 893.16 | 1118.16 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.1% | not timed | not timed | 10.92 ± 0.1% | 8.75 ± 1.1% | not timed | not timed | 3.54 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.0% | not timed | not timed | 11.00 ± 0.4% | 8.75 ± 0.2% | not timed | not timed | 5.03 ± 0.0% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 467.89 ± 0.1% | not timed | not timed | 104.43 ± 0.2% | 6.48 ± 0.1% | not timed | not timed | 469.37 ± 0.3% | | 1.00 | 4.48 | 72.17 |
| reported/i787-keywords/opt-ascii | 5674 | 468.70 ± 0.2% | not timed | not timed | 266.86 ± 0.3% | 10.22 ± 0.2% | not timed | not timed | 471.31 ± 0.3% | | 0.99 | 1.76 | 45.84 |
| slow/quadratic-regex-1x | 100 | 6.94 ± 0.1% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 0.1% | not timed | not timed | 6.94 ± 0.4% | | 1.00 | 1.40 | 140.41 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.1% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.3% | not timed | not timed | 3.40 ± 0.2% | | 1.00 | 1.23 | 266.36 |
| slow/quadratic-haystack-1x | 100 | 21.17 ± 6.1% | not timed | not timed | 10.09 ± 0.2% | 1.02 ± 13.8% | not timed | not timed | 21.03 ± 1.7% | | 1.01 | 2.10 | 20.82 |
| slow/quadratic-haystack-2x | 200 | 17.42 ± 1.4% | not timed | not timed | 5.54 ± 0.1% | 0.55 ± 0.6% | not timed | not timed | 17.25 ± 13.1% | | 1.01 | 3.14 | 31.91 |
| unicode/codepoints/any-one | 1112064 | 285.66 ± 0.9% | not timed | not timed | 176.56 ± 0.1% | 17.92 ± 23.5% | not timed | not timed | 286.60 ± 0.6% | | 1.00 | 1.62 | 15.94 |
| unicode/codepoints/any-all | 4382592 | 289.36 ± 0.6% | not timed | not timed | 246.63 ± 0.2% | 117.36 ± 0.1% | not timed | not timed | 288.87 ± 0.5% | | 1.00 | 1.17 | 2.47 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.46 ± 0.3% | not timed | not timed | 616.04 ± 0.3% | 135.24 ± 0.1% | not timed | not timed | 610.81 ± 0.2% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.08 ± 0.3% | not timed | not timed | 38.92 ± 0.2% | 3.94 ± 1.6% | not timed | not timed | 31.14 ± 0.3% | | 1.00 | 0.80 | 7.88 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.1% | not timed | not timed | 3.39 ± 0.6% | 2.36 ± 0.4% | not timed | not timed | 1.36 ± 0.2% | | 0.99 | 0.40 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 10.0% | not timed | not timed | 2.88 ± 0.4% | 6.25 ± 10.4% | not timed | not timed | 1.22 ± 0.3% | | 1.00 | 0.42 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 113.44 ± 6.6% | not timed | not timed | 83.28 ± 0.1% | 11.75 ± 13.6% | not timed | not timed | 116.61 ± 0.5% | | 0.97 | 1.36 | 9.66 |
| unicode/word/boundary-long-english | 3466 | 605.94 ± 0.5% | not timed | not timed | 606.53 ± 0.1% | 32.49 ± 0.6% | not timed | not timed | 607.23 ± 0.7% | | 1.00 | 1.00 | 18.65 |
| unicode/word/around-holmes-english | 27 | 602.74 ± 0.4% | not timed | not timed | 19187.82 ± 0.8% | 22.24 ± 1.0% | not timed | not timed | 601.87 ± 0.8% | | 1.00 | 0.0314 | 27.10 |
| wild/bibleref/long | 874 | 564.92 ± 0.1% | not timed | not timed | 584.25 ± 0.1% | 6.70 ± 0.1% | not timed | not timed | 566.44 ± 0.1% | | 1.00 | 0.97 | 84.32 |
| wild/bibleref/short | 30 | 24.64 ± 3.0% | not timed | not timed | 31.36 ± 0.4% | 14.30 ± 9.0% | not timed | not timed | 25.68 ± 4.7% | | 0.96 | 0.79 | 1.72 |
| wild/bibleref/line | 874 | 356.98 ± 0.2% | not timed | not timed | 218.85 ± 0.2% | 9.21 ± 0.2% | not timed | not timed | 357.80 ± 0.3% | | 1.00 | 1.63 | 38.75 |
| wild/caddy/caddy | 6 | 417.90 ± 9.6% | not timed | not timed | 243.74 ± 0.1% | 66.50 ± 10.9% | not timed | not timed | 417.88 ± 2.4% | | 1.00 | 1.71 | 6.28 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.70 ± 0.3% | not timed | not timed | 344.32 ± 0.4% | 13.50 ± 0.3% | not timed | not timed | 1058.38 ± 0.1% | | 1.00 | 3.07 | 78.44 |
| wild/ruff/noqa | 84 | 404.06 ± 0.1% | not timed | not timed | 465.06 ± 0.2% | 19.64 ± 1.7% | not timed | not timed | 403.45 ± 0.1% | | 1.00 | 0.87 | 20.58 |
| wild/ruff/unnecessary-coding-comment | 16 | 489.49 ± 0.7% | not timed | not timed | 704.00 ± 0.1% | 134.39 ± 10.6% | not timed | not timed | 488.88 ± 0.7% | | 1.00 | 0.70 | 3.64 |
| wild/ruff/string-quote-prefix | 2972 | 405.94 ± 0.6% | not timed | not timed | 441.82 ± 0.1% | 376.04 ± 30.3% | not timed | not timed | 406.66 ± 0.7% | | 1.00 | 0.92 | 1.08 |
| wild/ruff/space-around-operator | 1224378 | 217.19 ± 2.0% | not timed | not timed | 186.66 ± 0.2% | 18.40 ± 1.7% | not timed | not timed | 217.52 ± 1.8% | | 1.00 | 1.16 | 11.80 |
| wild/ruff/shebang | 282 | 401.03 ± 0.5% | not timed | not timed | 327.59 ± 0.1% | 112.04 ± 12.2% | not timed | not timed | 400.80 ± 0.5% | | 1.00 | 1.22 | 3.58 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13766.76 ± 0.3% | not timed | not timed | 13840.65 ± 0.3% | 6933.49 ± 0.9% | not timed | not timed | 13840.15 ± 0.2% | | 0.99 | 0.99 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12779.23 ± 0.5% | not timed | not timed | 13452.54 ± 0.5% | 6410.10 ± 1.3% | not timed | not timed | 12833.76 ± 0.4% | | 1.00 | 0.95 | 1.99 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13141.97 ± 0.6% | not timed | not timed | 13725.25 ± 0.4% | 6607.88 ± 1.0% | not timed | not timed | 13223.91 ± 0.4% | | 0.99 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9528.49 ± 0.7% | not timed | not timed | 13641.64 ± 0.1% | 6734.10 ± 0.7% | not timed | not timed | 9561.06 ± 0.6% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 121.92 ± 13.8% | not timed | not timed | 65.23 ± 0.8% | 2.25 ± 0.8% | not timed | not timed | 121.08 ± 14.4% | | 1.01 | 1.87 | 54.28 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 49.5% | not timed | not timed | 0.01 ± 1.7% | 0.01 ± 26.9% | not timed | not timed | 0.03 ± 3.7% | | 1.00 | 3.13 | 4.06 |
| dictionary/compile/english-15 | 1 | 0.35 ± 1.3% | not timed | not timed | 0.07 ± 2.4% | 0.10 ± 11.4% | not timed | not timed | 0.35 ± 28.5% | | 1.00 | 5.07 | 3.38 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 16.7% | not timed | not timed | 0.02 ± 1.9% | 34.29 ± 4.8% | not timed | not timed | 0.25 ± 3.5% | | 0.93 | 12.27 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.24 ± 2.4% | not timed | not timed | 11.52 ± 0.5% | 56.70 ± 18.9% | not timed | not timed | 47.61 ± 8.1% | | 0.99 | 4.10 | 0.83 |
| reported/i787-keywords/compile | 1 | 35.24 ± 18.3% | not timed | not timed | 2.13 ± 0.9% | 16.83 ± 41.3% | not timed | not timed | 35.71 ± 0.7% | | 0.99 | 16.56 | 2.09 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 364.17 ± 1.9% | not timed | not timed | 113.00 ± 0.2% | 571.78 ± 14.5% | not timed | not timed | 370.09 ± 3.9% | | 0.98 | 3.22 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.34 ± 2.7% | not timed | not timed | 4.11 ± 0.7% | 41.85 ± 13.4% | not timed | not timed | 47.85 ± 2.0% | | 0.99 | 11.51 | 1.13 |
| unicode/compile/one-letter | 53 | 6.66 ± 10.8% | not timed | not timed | 4.56 ± 0.2% | 63.63 ± 6.9% | not timed | not timed | 6.78 ± 13.8% | | 0.98 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 10.6% | not timed | not timed | 0.10 ± 2.1% | 65.24 ± 13.1% | not timed | not timed | 1.10 ± 5.4% | | 0.96 | 10.90 | 0.0163 |
| unicode/compile/fifty-letters-ascii | 1 | 221.56 ± 12.8% | not timed | not timed | 54.03 ± 0.2% | 189.84 ± 17.3% | not timed | not timed | 223.32 ± 6.3% | | 0.99 | 4.10 | 1.17 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 386.75 ± 29.3% | not timed | not timed | 47.08 ± 0.2% | 659.94 ± 31.9% | not timed | not timed | 395.44 ± 1.4% | | 0.98 | 8.21 | 0.59 |
| unicode/compile/match-every-line-ascii | 4 | 632.37 ± 8.4% | not timed | not timed | 145.71 ± 0.3% | 672.20 ± 31.0% | not timed | not timed | 634.97 ± 3.5% | | 1.00 | 4.34 | 0.94 |
| unicode/compile/negated-class-matches-codepoint | 1 | 325.92 ± 2.7% | not timed | not timed | 51.00 ± 0.3% | 1274.19 ± 32.2% | not timed | not timed | 338.56 ± 8.3% | | 0.96 | 6.39 | 0.26 |
| wild/bibleref/compile | 3 | 5.92 ± 1.6% | not timed | not timed | 1.93 ± 0.3% | 30.90 ± 7.0% | not timed | not timed | 5.96 ± 2.1% | | 0.99 | 3.06 | 0.19 |
| wild/url/compile | 1 | 0.65 ± 8.9% | not timed | not timed | 0.14 ± 1.5% | 0.38 ± 34.9% | not timed | not timed | 0.66 ± 2.0% | | 1.00 | 4.56 | 1.72 |

