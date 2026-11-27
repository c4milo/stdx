# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261122.195.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
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
| literal: a word | 217 | 19496.27 ± 2.2% | 10854.95 ± 0.4% | 28.20 ± 0.5% | 18178.00 ± 1.2% | 9086.23 ± 8.9% | 17.59 ± 0.1% | 86.68 ± 0.4% | 19579.17 ± 1.6% | 1.80 | 1.00 | 1.07 | 2.15 |
| literal: a word that is not there | 0 | 21633.68 ± 2.1% | 9875.51 ± 0.6% | 28.38 ± 0.2% | 19898.68 ± 2.3% | 28506.20 ± 2.4% | 17.36 ± 0.2% | 80.70 ± 0.4% | 21681.84 ± 2.7% | 2.19 | 1.00 | 1.09 | 0.76 |
| literal: one of four words | 661 | 6434.37 ± 0.4% | 1793.53 ± 0.2% | 14.42 ± 0.2% | 3946.01 ± 0.2% | 21.80 ± 0.2% | 5.31 ± 0.3% | 6.94 ± 0.3% | 6439.62 ± 0.5% | 3.59 | 1.00 | 1.63 | 295.14 |
| literal: a word in any case | 217 | 15210.62 ± 0.7% | 1920.07 ± 0.1% | 21.55 ± 0.3% | 3962.18 ± 0.3% | 38.03 ± 1.7% | refused | differs | 15208.41 ± 0.6% | 7.92 | 1.00 | 3.84 | 399.93 |
| literal: an href attribute | 33 | 16790.50 ± 2.2% | 609.06 ± 0.5% | 27.31 ± 0.4% | 17039.92 ± 1.3% | 2247.41 ± 1.0% | 13.43 ± 0.2% | 75.20 ± 0.7% | 16912.68 ± 1.1% | 27.57 | 0.99 | 0.99 | 7.47 |
| literal: a word, second text | 123 | 19967.50 ± 5.3% | 4589.38 ± 0.4% | 27.95 ± 0.3% | 18171.08 ± 1.8% | 7833.25 ± 6.6% | 19.77 ± 0.2% | 70.42 ± 0.2% | 19862.75 ± 2.6% | 4.35 | 1.01 | 1.10 | 2.55 |
| class: two capitalized words | 1331 | 1177.76 ± 0.5% | 598.20 ± 0.3% | 25.97 ± 0.2% | 586.38 ± 0.4% | 40.73 ± 8.2% | 14.95 ± 0.2% | 67.77 ± 0.3% | 1176.78 ± 0.3% | 1.97 | 1.00 | 2.01 | 28.92 |
| class: a word that ends in ing | 3399 | 574.33 ± 0.4% | 574.41 ± 0.3% | 17.85 ± 0.3% | 548.04 ± 0.2% | 29.64 ± 7.5% | 8.20 ± 0.3% | 18.41 ± 0.3% | 574.98 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.38 |
| class: a word in capitals | 2332 | 1538.86 ± 0.3% | 608.45 ± 0.2% | 27.61 ± 0.4% | 573.12 ± 0.3% | 43.56 ± 16.9% | 17.19 ± 0.5% | 83.45 ± 0.6% | 1536.35 ± 0.4% | 2.53 | 1.00 | 2.69 | 35.32 |
| class: a number | 8288 | 2674.11 ± 1.4% | 841.38 ± 0.2% | 27.62 ± 0.3% | 1708.25 ± 0.1% | 42.10 ± 16.9% | 0.57 ± 0.2% | 57.33 ± 0.3% | 2673.64 ± 0.9% | 3.18 | 1.00 | 1.57 | 63.52 |
| class: two capitalized words, second text | 5359 | 521.69 ± 0.2% | 528.37 ± 0.2% | 23.23 ± 0.1% | 483.80 ± 0.1% | 35.42 ± 10.1% | 16.71 ± 0.3% | 63.16 ± 0.2% | 521.79 ± 0.3% | 0.99 | 1.00 | 1.08 | 14.73 |
| other: a word between two words | 6104 | 810.15 ± 0.1% | 602.51 ± 0.1% | 23.44 ± 0.3% | 737.06 ± 0.4% | 110.60 ± 7.8% | 11.37 ± 0.2% | 69.29 ± 0.3% | 811.52 ± 0.2% | 1.34 | 1.00 | 1.10 | 7.32 |
| other: a number before a unit, second text | 1481 | 6273.56 ± 1.6% | 1144.20 ± 0.3% | 25.92 ± 0.3% | 5637.18 ± 0.3% | 40.79 ± 0.3% | 17.79 ± 0.1% | 65.72 ± 0.1% | 6261.57 ± 2.2% | 5.48 | 1.00 | 1.11 | 153.82 |
| other: a heading's start tag | 110 | 14120.79 ± 1.3% | 740.32 ± 0.2% | 27.29 ± 0.3% | 1708.43 ± 0.6% | 1576.99 ± 4.7% | 16.37 ± 0.5% | 88.01 ± 0.6% | 14144.08 ± 0.7% | 19.07 | 1.00 | 8.27 | 8.95 |
| other: a whole word | 217 | 16364.52 ± 1.0% | 601.75 ± 0.7% | 28.80 ± 0.3% | 14484.30 ± 1.4% | 49.41 ± 0.1% | 13.81 ± 0.1% | 55.05 ± 0.1% | 16373.93 ± 0.8% | 27.19 | 1.00 | 1.13 | 331.18 |
| other: a line's first word, second text | 3716 | 2099.06 ± 0.8% | 591.93 ± 0.1% | 30.82 ± 0.3% | 1727.94 ± 0.9% | 63.43 ± 6.9% | refused | refused | 2107.84 ± 0.8% | 3.55 | 1.00 | 1.21 | 33.09 |
| other: fourteen octets before an x | 87 | 24185.44 ± 3.6% | 236.50 ± 0.7% | 6.47 ± 0.2% | 4018.08 ± 1.1% | 10.65 ± 0.1% | differs | 17.89 ± 0.4% | 23942.83 ± 7.6% | 102.27 | 1.01 | 6.02 | 2271.93 |
| other: a Greek word | 21815 | 528.97 ± 0.7% | 424.28 ± 0.1% | 30.46 ± 0.1% | 289.83 ± 0.3% | 49.66 ± 11.9% | differs | refused | 530.22 ± 0.4% | 1.25 | 1.00 | 1.83 | 10.65 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.68 ± 0.2% | 29.68 ± 0.2% | 0.86 ± 0.1% | 19.71 ± 0.4% | 2.76 ± 0.7% | differs | 4.05 ± 0.1% | 29.58 ± 0.6% | 1.00 | 1.00 | 1.51 | 10.75 |
| a UUID | 32895 | 24.78 ± 0.7% | 24.77 ± 0.2% | 0.64 ± 0.1% | 15.17 ± 0.1% | 3.12 ± 0.3% | 0.72 ± 0.2% | 3.60 ± 0.5% | 24.83 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.95 |
| an IPv4 address | 33176 | 38.79 ± 0.3% | 38.77 ± 0.4% | 2.07 ± 0.2% | 29.36 ± 0.4% | 6.66 ± 0.1% | differs | 4.21 ± 0.2% | 38.69 ± 0.1% | 1.00 | 1.00 | 1.32 | 5.82 |
| a date and time | 32954 | 34.13 ± 0.3% | 34.21 ± 0.3% | 1.44 ± 0.1% | 21.37 ± 0.7% | 7.04 ± 0.2% | 1.20 ± 0.0% | 7.09 ± 0.2% | 34.25 ± 0.2% | 1.00 | 1.00 | 1.60 | 4.85 |
| a field path | 32606 | 32.76 ± 0.3% | 32.82 ± 0.4% | 1.01 ± 0.1% | 23.19 ± 0.6% | 3.48 ± 0.6% | differs | 2.96 ± 0.1% | 32.76 ± 0.3% | 1.00 | 1.00 | 1.41 | 9.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.20 ± 0.2% | 11.15 ± 0.4% | 11.20 ± 0.4% | 11.47 ± 0.6% | 4.94 ± 1.8% | 0.91 ± 0.8% | none | 11.20 ± 0.4% | 1.00 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 224.26 ± 0.8% | 224.19 ± 0.2% | 264.02 ± 0.1% | 86.51 ± 0.6% | 222.91 ± 1.6% | 445.53 ± 0.8% | 3727.27 ± 2.3% | 224.53 ± 0.1% | 1.00 | 1.00 | 2.59 | 1.01 |
| a UUID | 62 | 148.36 ± 0.4% | 148.39 ± 0.1% | 164.83 ± 0.3% | 46.19 ± 0.5% | 100.05 ± 0.9% | 174.29 ± 1.3% | 4363.59 ± 0.2% | 148.31 ± 0.2% | 1.00 | 1.00 | 3.21 | 1.48 |
| an IPv4 address | 29 | 421.65 ± 0.5% | 421.57 ± 0.5% | 588.49 ± 0.5% | 76.99 ± 0.8% | 131.54 ± 9.7% | 273.65 ± 0.9% | 7522.57 ± 0.7% | 421.39 ± 0.6% | 1.00 | 1.00 | 5.48 | 3.21 |
| a date and time | 56 | 303.89 ± 0.2% | 303.15 ± 0.2% | 380.76 ± 0.2% | 72.09 ± 1.6% | 137.26 ± 6.9% | 302.18 ± 1.4% | 4931.99 ± 0.8% | 303.81 ± 0.2% | 1.00 | 1.00 | 4.22 | 2.21 |
| a field path | 39 | 218.21 ± 0.2% | 217.98 ± 0.6% | 255.06 ± 0.3% | 80.86 ± 1.4% | 205.77 ± 1.8% | 456.46 ± 1.7% | 4723.44 ± 2.6% | 218.21 ± 0.1% | 1.00 | 1.00 | 2.70 | 1.06 |
| literal: a word | 7 | 604.12 ± 0.2% | 650.46 ± 0.3% | 1129.99 ± 0.2% | 511.12 ± 0.4% | 630.71 ± 1.8% | 843.62 ± 0.6% | 29608.08 ± 0.1% | 604.85 ± 0.4% | 0.93 | 1.00 | 1.18 | 0.96 |
| literal: a word that is not there | 8 | 587.28 ± 0.2% | 635.74 ± 0.7% | 1091.98 ± 0.6% | 467.20 ± 0.2% | 607.46 ± 1.3% | 804.26 ± 0.4% | 28571.70 ± 0.6% | 586.85 ± 0.5% | 0.92 | 1.00 | 1.26 | 0.97 |
| literal: one of four words | 26 | 245.92 ± 0.1% | 391.94 ± 0.5% | 532.37 ± 0.5% | 49.78 ± 1.1% | 242.23 ± 3.3% | 331.25 ± 0.5% | 15483.29 ± 0.3% | 245.91 ± 0.4% | 0.63 | 1.00 | 4.94 | 1.02 |
| literal: a word in any case | 11 | 440.23 ± 0.2% | 468.53 ± 0.5% | 683.45 ± 0.3% | 15.82 ± 0.3% | 648.82 ± 1.2% | refused | 23453.78 ± 0.4% | 439.84 ± 0.3% | 0.94 | 1.00 | 27.82 | 0.68 |
| literal: an href attribute | 12 | 340.86 ± 0.2% | 352.67 ± 0.3% | 461.02 ± 0.5% | 45.81 ± 0.7% | 498.04 ± 4.2% | 718.05 ± 1.5% | 21518.87 ± 0.3% | 341.01 ± 0.2% | 0.97 | 1.00 | 7.44 | 0.68 |
| literal: a word, second text | 10 | 537.99 ± 0.1% | 589.35 ± 0.1% | 970.15 ± 0.2% | 425.09 ± 0.7% | 537.77 ± 1.7% | 742.19 ± 0.4% | 26526.70 ± 0.1% | 537.77 ± 0.3% | 0.91 | 1.00 | 1.27 | 1.00 |
| class: two capitalized words | 23 | 432.24 ± 0.4% | 459.59 ± 0.3% | 659.75 ± 0.8% | 101.86 ± 2.7% | 503.55 ± 1.0% | 692.97 ± 0.3% | 6276.95 ± 0.3% | 431.79 ± 0.7% | 0.94 | 1.00 | 4.24 | 0.86 |
| class: a word that ends in ing | 9 | 550.92 ± 0.5% | 614.79 ± 0.3% | 1060.47 ± 0.3% | 134.09 ± 0.4% | 762.46 ± 0.6% | 1037.24 ± 0.6% | 15618.99 ± 0.2% | 550.55 ± 0.3% | 0.90 | 1.00 | 4.11 | 0.72 |
| class: a word in capitals | 16 | 493.39 ± 0.3% | 528.66 ± 0.8% | 833.26 ± 0.2% | 136.71 ± 1.0% | 753.69 ± 1.1% | 971.59 ± 0.9% | 8235.21 ± 0.1% | 492.81 ± 0.2% | 0.93 | 1.00 | 3.61 | 0.65 |
| class: a number | 6 | 622.05 ± 0.4% | 678.03 ± 0.6% | 1251.67 ± 0.3% | 42.12 ± 1.1% | 1408.83 ± 4.5% | 1697.82 ± 0.5% | 22260.44 ± 0.1% | 621.86 ± 0.3% | 0.92 | 1.00 | 14.77 | 0.44 |
| class: two capitalized words, second text | 23 | 432.51 ± 0.2% | 459.45 ± 0.2% | 660.07 ± 0.3% | 102.99 ± 1.9% | 503.09 ± 2.2% | 704.66 ± 2.3% | 6278.41 ± 0.2% | 432.49 ± 0.2% | 0.94 | 1.00 | 4.20 | 0.86 |
| other: a word between two words | 13 | 531.18 ± 0.4% | 551.78 ± 0.3% | 872.75 ± 0.1% | 135.99 ± 0.5% | 502.51 ± 6.7% | 732.74 ± 0.5% | 14444.10 ± 0.2% | 531.57 ± 0.3% | 0.96 | 1.00 | 3.91 | 1.06 |
| other: a number before a unit, second text | 15 | 386.47 ± 0.2% | 423.97 ± 0.3% | 589.48 ± 0.2% | 39.92 ± 0.3% | 639.36 ± 6.3% | 821.02 ± 0.5% | 15022.88 ± 0.2% | 386.24 ± 0.2% | 0.91 | 1.00 | 9.68 | 0.60 |
| other: a heading's start tag | 13 | 351.29 ± 0.2% | 357.55 ± 0.3% | 469.96 ± 0.4% | 44.56 ± 0.8% | 633.79 ± 0.8% | 809.35 ± 0.3% | 17797.05 ± 0.2% | 351.82 ± 0.4% | 0.98 | 1.00 | 7.88 | 0.55 |
| other: a whole word | 11 | 561.54 ± 0.4% | 601.56 ± 0.8% | 990.84 ± 0.9% | 121.22 ± 0.5% | 562.65 ± 2.0% | 752.20 ± 0.5% | 26657.74 ± 0.1% | 563.49 ± 1.0% | 0.93 | 1.00 | 4.63 | 1.00 |
| other: a line's first word, second text | 17 | 511.51 ± 0.5% | 546.83 ± 0.2% | 868.94 ± 0.1% | 130.17 ± 0.1% | 703.59 ± 1.1% | refused | refused | 512.32 ± 0.5% | 0.94 | 1.00 | 3.93 | 0.73 |
| other: fourteen octets before an x | 16 | 109.56 ± 0.5% | 156.98 ± 0.7% | 179.70 ± 0.4% | 15.25 ± 0.5% | 450.82 ± 1.1% | 388.01 ± 0.4% | 12697.15 ± 0.3% | 109.74 ± 0.5% | 0.70 | 1.00 | 7.18 | 0.24 |
| other: a Greek word | 8 | 449.23 ± 0.2% | 589.88 ± 0.3% | 986.48 ± 0.5% | 58.94 ± 0.7% | 1395.69 ± 1.8% | 1660.95 ± 0.8% | refused | 448.91 ± 0.4% | 0.76 | 1.00 | 7.62 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15615.81 ± 0.5% | not timed | not timed | 16258.43 ± 1.1% | 1993.89 ± 22.5% | not timed | not timed | 15629.86 ± 0.4% | | 1.00 | 0.96 | 7.83 |
| 01-literal/sherlock-casei-en | 522 | 10899.41 ± 4.1% | not timed | not timed | 3598.62 ± 0.2% | 32.47 ± 4.8% | not timed | not timed | 10896.66 ± 2.2% | | 1.00 | 3.03 | 335.70 |
| 01-literal/sherlock-ru | 724 | 17074.61 ± 0.7% | not timed | not timed | 17336.54 ± 0.4% | 1534.74 ± 5.1% | not timed | not timed | 17132.51 ± 0.2% | | 1.00 | 0.98 | 11.13 |
| 01-literal/sherlock-casei-ru | 746 | 6127.03 ± 0.3% | not timed | not timed | 3333.55 ± 0.2% | 31.32 ± 0.8% | not timed | not timed | 6126.18 ± 0.3% | | 1.00 | 1.84 | 195.61 |
| 01-literal/sherlock-zh | 30 | 19846.80 ± 0.8% | not timed | not timed | 18549.72 ± 0.5% | 2542.50 ± 12.1% | not timed | not timed | 19822.31 ± 1.0% | | 1.00 | 1.07 | 7.81 |
| 02-literal-alternate/sherlock-en | 714 | 6154.42 ± 0.3% | not timed | not timed | 3940.35 ± 0.2% | 16.58 ± 0.2% | not timed | not timed | 6149.01 ± 0.4% | | 1.00 | 1.56 | 371.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1968.44 ± 1.1% | not timed | not timed | 693.92 ± 0.2% | 11.04 ± 0.2% | not timed | not timed | 1968.17 ± 0.8% | | 1.00 | 2.84 | 178.30 |
| 02-literal-alternate/sherlock-ru | 899 | 5496.73 ± 0.2% | not timed | not timed | 3255.70 ± 0.3% | 22.67 ± 0.2% | not timed | not timed | 5505.93 ± 0.2% | | 1.00 | 1.69 | 242.51 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2047.49 ± 0.4% | not timed | not timed | 1226.23 ± 0.1% | 9.01 ± 0.1% | not timed | not timed | 2048.30 ± 0.5% | | 1.00 | 1.67 | 227.20 |
| 02-literal-alternate/sherlock-zh | 207 | 7327.36 ± 0.6% | not timed | not timed | 4155.19 ± 0.3% | 31.49 ± 0.5% | not timed | not timed | 7320.42 ± 0.4% | | 1.00 | 1.76 | 232.67 |
| 03-date/ascii | 111817 | 134.16 ± 0.8% | not timed | not timed | 94.49 ± 0.1% | 0.20 ± 2.5% | not timed | not timed | 134.36 ± 0.8% | | 1.00 | 1.42 | 662.70 |
| 04-ruff-noqa/real | 84 | 438.98 ± 0.3% | not timed | not timed | 462.11 ± 0.3% | 19.47 ± 1.6% | not timed | not timed | 437.67 ± 0.1% | | 1.00 | 0.95 | 22.55 |
| 04-ruff-noqa/tweaked | 44 | 846.75 ± 0.2% | not timed | not timed | 462.27 ± 0.1% | 364.11 ± 0.3% | not timed | not timed | 846.92 ± 0.2% | | 1.00 | 1.83 | 2.33 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.5% | not timed | not timed | 4.98 ± 0.1% | 0.20 ± 5.0% | not timed | not timed | 5.34 ± 0.3% | | 1.00 | 1.07 | 26.18 |
| 06-cloud-flare-redos/original | 107 | 440.69 ± 0.1% | not timed | not timed | 216.28 ± 0.2% | 24.86 ± 0.2% | not timed | not timed | 439.67 ± 0.2% | | 1.00 | 2.04 | 17.73 |
| 06-cloud-flare-redos/simplified-short | 102 | 439.05 ± 0.3% | not timed | not timed | 229.43 ± 0.1% | 26.65 ± 0.2% | not timed | not timed | 438.98 ± 0.4% | | 1.00 | 1.91 | 16.47 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.94 ± 0.1% | not timed | not timed | 253.84 ± 0.1% | 28.82 ± 0.1% | not timed | not timed | 629.47 ± 0.0% | | 1.00 | 2.48 | 21.83 |
| 07-unicode-character-data/parse-line | 558784 | 242.74 ± 0.5% | not timed | not timed | 169.69 ± 0.2% | 42.78 ± 6.1% | not timed | not timed | 240.92 ± 2.3% | | 1.01 | 1.43 | 5.67 |
| 08-words/all-english | 56691 | 128.97 ± 0.6% | not timed | not timed | 81.37 ± 0.2% | 12.86 ± 5.2% | not timed | not timed | 129.22 ± 0.4% | | 1.00 | 1.58 | 10.03 |
| 08-words/long-english | 839 | 615.53 ± 0.8% | not timed | not timed | 597.55 ± 0.1% | 32.56 ± 0.6% | not timed | not timed | 617.30 ± 0.3% | | 1.00 | 1.03 | 18.90 |
| 09-aws-keys/full | 0 | 443.15 ± 0.2% | not timed | not timed | 463.87 ± 0.3% | 64.34 ± 3.5% | not timed | not timed | 443.66 ± 0.2% | | 1.00 | 0.96 | 6.89 |
| 09-aws-keys/quick | 0 | 875.61 ± 0.2% | not timed | not timed | 990.62 ± 0.1% | 420.92 ± 1.0% | not timed | not timed | 875.61 ± 0.3% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 579.89 ± 3.2% | not timed | not timed | 515.81 ± 0.5% | 19.59 ± 0.5% | not timed | not timed | 579.50 ± 1.9% | | 1.00 | 1.12 | 29.60 |
| 10-bounded-repeat/letters-ru | 3475 | 504.51 ± 1.8% | not timed | not timed | 477.84 ± 0.1% | 21.88 ± 9.1% | not timed | not timed | 506.75 ± 1.4% | | 1.00 | 1.06 | 23.06 |
| 10-bounded-repeat/context | 53 | 85.12 ± 2.2% | not timed | not timed | 66.10 ± 0.9% | 19.79 ± 0.3% | not timed | not timed | 85.40 ± 1.7% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 635.87 ± 8.0% | not timed | not timed | 618.77 ± 0.2% | 36.70 ± 0.1% | not timed | not timed | 639.41 ± 8.6% | | 0.99 | 1.03 | 17.33 |
| 11-unstructured-to-json/extract | 600 | 57.83 ± 1.0% | not timed | not timed | 77.57 ± 0.2% | 48.99 ± 0.3% | not timed | not timed | 57.91 ± 0.2% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 561.03 ± 1.4% | not timed | not timed | 562.77 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 561.25 ± 1.3% | | 1.00 | 1.00 | 1380.63 |
| 14-quadratic/1x | 100 | 22.00 ± 1.1% | not timed | not timed | 10.00 ± 0.3% | 0.98 ± 3.9% | not timed | not timed | 22.09 ± 0.5% | | 1.00 | 2.20 | 22.54 |
| 14-quadratic/2x | 200 | 19.69 ± 1.4% | not timed | not timed | 5.54 ± 0.4% | 0.53 ± 1.6% | not timed | not timed | 19.86 ± 0.3% | | 0.99 | 3.55 | 37.20 |
| 14-quadratic/10x | 1000 | 12.32 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 12.33 ± 0.9% | | 1.00 | 10.16 | 106.78 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 1.4% | not timed | not timed | 0.35 ± 0.7% | 0.55 ± 2.4% | not timed | not timed | 1.28 ± 0.4% | | 1.00 | 3.69 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 107.17 ± 1.0% | not timed | not timed | 13.97 ± 0.3% | 141.31 ± 2.3% | not timed | not timed | 107.10 ± 0.2% | | 1.00 | 7.67 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 14.18 ± 1.0% | not timed | not timed | 2.54 ± 0.9% | 6.54 ± 1.9% | not timed | not timed | 14.20 ± 1.7% | | 1.00 | 5.58 | 2.17 |
| 07-unicode-character-data/compile | 1 | 110.23 ± 1.2% | not timed | not timed | 26.15 ± 0.5% | 36.55 ± 2.3% | not timed | not timed | 110.16 ± 1.3% | | 1.00 | 4.22 | 3.02 |
| 09-aws-keys/compile-full | 1 | 53.67 ± 1.5% | not timed | not timed | 8.34 ± 0.7% | 23.47 ± 1.3% | not timed | not timed | 53.64 ± 0.3% | | 1.00 | 6.44 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 188.77 ± 0.1% | not timed | not timed | 47.40 ± 0.4% | 135.29 ± 2.5% | not timed | not timed | 189.26 ± 0.2% | | 1.00 | 3.98 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 72.74 ± 1.5% | not timed | not timed | 11.31 ± 0.3% | 16.40 ± 0.7% | not timed | not timed | 72.81 ± 1.6% | | 1.00 | 6.43 | 4.43 |
| 10-bounded-repeat/compile-capitals | 1 | 85.93 ± 1.3% | not timed | not timed | 8.17 ± 0.3% | 24.08 ± 1.7% | not timed | not timed | 85.92 ± 0.9% | | 1.00 | 10.52 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 173.88 ± 1.2% | not timed | not timed | 40.52 ± 0.5% | 69.26 ± 1.5% | not timed | not timed | 174.91 ± 0.9% | | 0.99 | 4.29 | 2.51 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.7% | not timed | not timed | 0.07 ± 16.5% | 0.10 ± 12.7% | not timed | not timed | 0.35 ± 0.3% | | 1.00 | 5.06 | 3.55 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.35 ± 4.5% | not timed | not timed | 6.47 ± 0.2% | 0.60 ± 20.1% | not timed | not timed | 7.45 ± 2.5% | | 0.99 | 1.14 | 12.34 |
| dictionary/search/english-10 | 690 | 209.62 ± 1.6% | not timed | not timed | 166.16 ± 1.0% | 0.00 ± 0.6% | not timed | not timed | 208.96 ± 2.2% | | 1.00 | 1.26 | 69858.76 |
| dictionary/search/english-15 | 15 | 561.11 ± 1.6% | not timed | not timed | 560.46 ± 0.1% | 0.37 ± 0.5% | not timed | not timed | 563.04 ± 1.6% | | 1.00 | 1.00 | 1529.93 |
| folly/awyer-inn-busted | 1 | 21498.24 ± 0.1% | not timed | not timed | 141.60 ± 0.6% | 43.83 ± 0.3% | not timed | not timed | 21556.72 ± 0.1% | | 1.00 | 151.83 | 490.52 |
| folly/literal-never-match-rare | 0 | 21137.42 ± 0.4% | not timed | not timed | 19940.58 ± 0.3% | 40800.27 ± 0.5% | not timed | not timed | 21141.40 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12522.32 ± 1.8% | not timed | not timed | 19881.29 ± 0.2% | 2189.80 ± 0.8% | not timed | not timed | 12556.23 ± 1.4% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3253.23 ± 0.1% | not timed | not timed | 4408.74 ± 0.2% | 3050.37 ± 1.5% | not timed | not timed | 3253.72 ± 0.2% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1304.48 ± 0.5% | not timed | not timed | 953.45 ± 0.4% | 384.38 ± 17.3% | not timed | not timed | 1311.02 ± 0.4% | | 1.00 | 1.37 | 3.39 |
| grep/long-words-ascii | 5073 | 460.05 ± 0.1% | not timed | not timed | 468.35 ± 0.3% | 46.17 ± 8.0% | not timed | not timed | 458.82 ± 0.3% | | 1.00 | 0.98 | 9.96 |
| imported/leipzig/twain | 811 | 20743.23 ± 1.3% | not timed | not timed | 19626.56 ± 0.3% | 11970.51 ± 10.0% | not timed | not timed | 20776.26 ± 0.4% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9060.48 ± 1.2% | not timed | not timed | 4250.80 ± 0.1% | 38.39 ± 1.7% | not timed | not timed | 9090.78 ± 0.9% | | 1.00 | 2.13 | 236.01 |
| imported/leipzig/shing | 1540 | 15299.45 ± 2.1% | not timed | not timed | 13553.24 ± 0.2% | 34.03 ± 0.1% | not timed | not timed | 15579.11 ± 2.1% | | 0.98 | 1.13 | 449.61 |
| imported/leipzig/huck-saw | 262 | 8285.51 ± 2.7% | not timed | not timed | 5602.13 ± 0.1% | 31.82 ± 0.1% | not timed | not timed | 8469.31 ± 3.3% | | 0.98 | 1.48 | 260.42 |
| imported/leipzig/word-ending-nn | 262 | 603.60 ± 0.6% | not timed | not timed | 615.53 ± 0.1% | 24.93 ± 0.3% | not timed | not timed | 604.48 ± 0.7% | | 1.00 | 0.98 | 24.21 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11237.54 ± 0.5% | not timed | not timed | 4566.99 ± 0.6% | 11.51 ± 0.1% | not timed | not timed | 11280.03 ± 1.1% | | 1.00 | 2.46 | 976.28 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7821.58 ± 1.8% | not timed | not timed | 5491.08 ± 0.3% | 16.92 ± 0.0% | not timed | not timed | 7938.07 ± 1.8% | | 0.99 | 1.42 | 462.25 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4170.75 ± 0.3% | not timed | not timed | 418.22 ± 0.7% | 11.09 ± 0.0% | not timed | not timed | 4163.09 ± 1.5% | | 1.00 | 9.97 | 376.02 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7371.32 ± 1.5% | not timed | not timed | 615.31 ± 0.2% | 11.15 ± 0.1% | not timed | not timed | 7402.82 ± 2.0% | | 1.00 | 11.98 | 661.18 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7141.46 ± 3.5% | not timed | not timed | 615.54 ± 0.2% | 9.72 ± 0.0% | not timed | not timed | 7282.70 ± 2.9% | | 0.98 | 11.60 | 734.44 |
| imported/leipzig/tom-river | 2 | 6475.72 ± 16.7% | not timed | not timed | 5149.36 ± 10.1% | 30.98 ± 0.1% | not timed | not timed | 6569.08 ± 1.9% | | 0.99 | 1.26 | 209.00 |
| imported/leipzig/ing | 78424 | 603.88 ± 0.7% | not timed | not timed | 572.12 ± 0.2% | 28.17 ± 3.3% | not timed | not timed | 603.19 ± 1.0% | | 1.00 | 1.06 | 21.44 |
| imported/leipzig/ing-whitespace | 55248 | 1921.05 ± 1.4% | not timed | not timed | 2081.46 ± 0.9% | 20.54 ± 2.9% | not timed | not timed | 1935.32 ± 1.1% | | 0.99 | 0.92 | 93.53 |
| imported/leipzig/awyer-inn | 209 | 6375.46 ± 1.3% | not timed | not timed | 4283.49 ± 0.1% | 22.43 ± 0.1% | not timed | not timed | 6411.53 ± 1.2% | | 0.99 | 1.49 | 284.24 |
| imported/leipzig/quotes-bounded | 8886 | 2480.26 ± 1.4% | not timed | not timed | 3007.41 ± 0.5% | 38.26 ± 0.1% | not timed | not timed | 2482.09 ± 1.7% | | 1.00 | 0.82 | 64.82 |
| imported/leipzig/non-ascii-alternate | 2 | 12904.22 ± 1.5% | not timed | not timed | 5661.44 ± 0.2% | 50.54 ± 0.1% | not timed | not timed | 13002.31 ± 2.5% | | 0.99 | 2.28 | 255.34 |
| imported/leipzig/math-symbols | 69 | 1982.20 ± 0.7% | not timed | not timed | 613.66 ± 0.1% | 36.49 ± 0.1% | not timed | not timed | 1977.88 ± 0.6% | | 1.00 | 3.23 | 54.33 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.48 ± 1.0% | not timed | not timed | 617.90 ± 0.1% | 22.48 ± 0.1% | not timed | not timed | 632.49 ± 2.0% | | 1.00 | 1.02 | 28.13 |
| imported/lh3lh3-reb/uri | 17549 | 679.09 ± 0.1% | not timed | not timed | 1064.65 ± 0.1% | 28.34 ± 2.2% | not timed | not timed | 680.25 ± 0.1% | | 1.00 | 0.64 | 23.96 |
| imported/lh3lh3-reb/email | 15057 | 675.44 ± 0.1% | not timed | not timed | 1151.13 ± 0.6% | 29.56 ± 2.4% | not timed | not timed | 677.53 ± 0.2% | | 1.00 | 0.59 | 22.85 |
| imported/lh3lh3-reb/date | 668 | 891.50 ± 0.2% | not timed | not timed | 1027.53 ± 0.1% | 47.29 ± 3.7% | not timed | not timed | 893.53 ± 0.2% | | 1.00 | 0.87 | 18.85 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.79 ± 0.2% | not timed | not timed | 422.17 ± 0.1% | 15.09 ± 1.4% | not timed | not timed | 635.86 ± 0.2% | | 1.02 | 1.53 | 42.80 |
| imported/mariomka/email | 92 | 24209.94 ± 1.0% | not timed | not timed | 29718.02 ± 0.6% | 32.85 ± 0.3% | not timed | not timed | 24386.47 ± 1.3% | | 0.99 | 0.81 | 737.02 |
| imported/mariomka/uri | 5301 | 5547.32 ± 0.6% | not timed | not timed | 6117.08 ± 0.2% | 32.75 ± 0.4% | not timed | not timed | 5586.90 ± 1.0% | | 0.99 | 0.91 | 169.39 |
| imported/mariomka/ip | 5 | 2594.29 ± 2.9% | not timed | not timed | 2967.48 ± 0.2% | 21.08 ± 0.2% | not timed | not timed | 2597.69 ± 2.9% | | 1.00 | 0.87 | 123.06 |
| imported/rsc/no-exponential | 0 | 609.02 ± 0.3% | not timed | not timed | 321.70 ± 0.1% | 23.51 ± 0.1% | not timed | not timed | 607.36 ± 0.3% | | 1.00 | 1.89 | 25.91 |
| imported/rsc/literal | 1 | 1496.52 ± 4.8% | not timed | not timed | 1645.41 ± 2.0% | 184.22 ± 14.5% | not timed | not timed | 1501.40 ± 5.4% | | 1.00 | 0.91 | 8.12 |
| imported/rsc/not-literal | 2 | 777.76 ± 0.7% | not timed | not timed | 740.74 ± 0.2% | 45.14 ± 8.8% | not timed | not timed | 778.32 ± 2.6% | | 1.00 | 1.05 | 17.23 |
| imported/rsc/match-class | 1 | 1470.74 ± 0.5% | not timed | not timed | 1604.62 ± 0.4% | 56.31 ± 13.3% | not timed | not timed | 1473.61 ± 2.9% | | 1.00 | 0.92 | 26.12 |
| imported/rsc/match-class-in-range | 1 | 1472.58 ± 0.5% | not timed | not timed | 2325.91 ± 2.2% | 57.76 ± 12.0% | not timed | not timed | 1474.64 ± 2.6% | | 1.00 | 0.63 | 25.49 |
| imported/rsc/match-class-unicode | 1 | 541.44 ± 0.2% | not timed | not timed | 511.41 ± 0.1% | 69.04 ± 0.3% | not timed | not timed | 541.04 ± 0.2% | | 1.00 | 1.06 | 7.84 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1459.16 ± 0.2% | not timed | not timed | 942.51 ± 0.1% | 228.96 ± 0.9% | not timed | not timed | 1458.29 ± 0.2% | | 1.00 | 1.55 | 6.37 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21878.95 ± 0.4% | not timed | not timed | 14232.42 ± 0.2% | 3435.03 ± 1.0% | not timed | not timed | 21866.03 ± 0.3% | | 1.00 | 1.54 | 6.37 |
| imported/rsc/anchored-literal-short-match | 4 | 722.18 ± 2.1% | not timed | not timed | 496.72 ± 0.3% | 85.73 ± 6.8% | not timed | not timed | 724.64 ± 5.5% | | 1.00 | 1.45 | 8.42 |
| imported/rsc/anchored-literal-long-match | 4 | 10830.29 ± 3.6% | not timed | not timed | 7422.32 ± 0.2% | 1251.70 ± 11.8% | not timed | not timed | 10874.00 ± 1.8% | | 1.00 | 1.46 | 8.65 |
| imported/rsc/one-pass-short | 17 | 368.09 ± 1.4% | not timed | not timed | 221.61 ± 0.4% | 29.75 ± 12.9% | not timed | not timed | 372.03 ± 1.2% | | 0.99 | 1.66 | 12.37 |
| imported/rsc/one-pass-short-not | 17 | 268.12 ± 2.8% | not timed | not timed | 227.63 ± 0.3% | 29.84 ± 12.4% | not timed | not timed | 268.52 ± 2.5% | | 1.00 | 1.18 | 8.99 |
| imported/rsc/one-pass-long-prefix | 26 | 358.72 ± 2.1% | not timed | not timed | 288.46 ± 0.2% | 95.27 ± 17.6% | not timed | not timed | 362.82 ± 1.3% | | 0.99 | 1.24 | 3.77 |
| imported/rsc/one-pass-long-prefix-not | 26 | 357.98 ± 3.9% | not timed | not timed | 287.87 ± 0.2% | 65.89 ± 22.1% | not timed | not timed | 364.41 ± 2.4% | | 0.98 | 1.24 | 5.43 |
| imported/rsc/long-needle1 | 31 | 21935.55 ± 0.1% | not timed | not timed | 20178.46 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 21939.80 ± 0.0% | | 1.00 | 1.09 | 5839.38 |
| imported/rsc/long-needle2 | 31 | 22089.41 ± 0.1% | not timed | not timed | 215.87 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 22096.38 ± 0.1% | | 1.00 | 102.33 | 5881.83 |
| imported/rsc/easy0-32 | 26 | 1543.66 ± 1.8% | not timed | not timed | 1626.19 ± 1.6% | 148.73 ± 20.6% | not timed | not timed | 1545.79 ± 0.3% | | 1.00 | 0.95 | 10.38 |
| imported/rsc/easy0-1k | 26 | 13496.25 ± 0.1% | not timed | not timed | 12621.68 ± 1.1% | 2308.78 ± 16.6% | not timed | not timed | 13548.56 ± 2.0% | | 1.00 | 1.07 | 5.85 |
| imported/rsc/easy0-32k | 26 | 22765.00 ± 1.8% | not timed | not timed | 20424.46 ± 0.0% | 18669.65 ± 24.5% | not timed | not timed | 22810.04 ± 0.4% | | 1.00 | 1.11 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21598.53 ± 1.7% | not timed | not timed | 19782.92 ± 0.6% | 35277.64 ± 1.9% | not timed | not timed | 21470.27 ± 1.2% | | 1.01 | 1.09 | 0.61 |
| imported/rsc/easy1-32 | 19 | 761.61 ± 2.6% | not timed | not timed | 641.56 ± 0.6% | 129.30 ± 15.2% | not timed | not timed | 770.31 ± 0.4% | | 0.99 | 1.19 | 5.89 |
| imported/rsc/easy1-1k | 19 | 15856.83 ± 2.6% | not timed | not timed | 12937.14 ± 0.2% | 2468.32 ± 14.3% | not timed | not timed | 15783.81 ± 0.3% | | 1.00 | 1.23 | 6.42 |
| imported/rsc/easy1-32k | 19 | 496206.08 ± 0.1% | not timed | not timed | 411357.97 ± 0.2% | 20426.43 ± 0.1% | not timed | not timed | 494394.00 ± 0.1% | | 1.00 | 1.21 | 24.29 |
| imported/rsc/easy1-1mb | 19 | 15952386.20 ± 0.5% | not timed | not timed | 13028269.55 ± 0.1% | 38293.48 ± 2.6% | not timed | not timed | 15853530.96 ± 0.2% | | 1.01 | 1.22 | 416.58 |
| imported/rsc/medium-32 | 27 | 734.46 ± 2.0% | not timed | not timed | 639.27 ± 0.2% | 69.80 ± 12.8% | not timed | not timed | 738.03 ± 0.5% | | 1.00 | 1.15 | 10.52 |
| imported/rsc/medium-1k | 27 | 13077.80 ± 0.4% | not timed | not timed | 11455.93 ± 0.4% | 72.25 ± 0.1% | not timed | not timed | 13074.82 ± 0.2% | | 1.00 | 1.14 | 181.01 |
| imported/rsc/medium-32k | 27 | 407772.42 ± 0.3% | not timed | not timed | 352731.87 ± 0.1% | 48.86 ± 0.1% | not timed | not timed | 407752.96 ± 0.4% | | 1.00 | 1.16 | 8345.97 |
| imported/rsc/medium-1mb | 27 | 13055299.34 ± 0.3% | not timed | not timed | 11368847.95 ± 1.0% | 48.92 ± 0.3% | not timed | not timed | 12992265.41 ± 0.5% | | 1.00 | 1.15 | 266843.74 |
| imported/rsc/hard-32 | 58 | 423.75 ± 2.2% | not timed | not timed | 366.51 ± 0.1% | 49.62 ± 8.3% | not timed | not timed | 421.08 ± 0.3% | | 1.01 | 1.16 | 8.54 |
| imported/rsc/hard-1k | 27 | 12939.14 ± 0.3% | not timed | not timed | 11536.19 ± 0.2% | 40.58 ± 0.1% | not timed | not timed | 12825.77 ± 0.4% | | 1.01 | 1.12 | 318.87 |
| imported/rsc/hard-32k | 27 | 403629.03 ± 0.9% | not timed | not timed | 362680.95 ± 0.1% | 29.36 ± 0.2% | not timed | not timed | 400310.88 ± 0.4% | | 1.01 | 1.11 | 13746.12 |
| imported/rsc/hard-1mb | 51 | 8399275.51 ± 0.2% | not timed | not timed | 7248324.63 ± 0.1% | 29.45 ± 0.1% | not timed | not timed | 8380964.46 ± 0.2% | | 1.00 | 1.16 | 285216.04 |
| imported/rsc/reallyhard0-32 | 58 | 264.40 ± 2.5% | not timed | not timed | 223.12 ± 0.1% | 49.64 ± 9.0% | not timed | not timed | 264.28 ± 0.4% | | 1.00 | 1.19 | 5.33 |
| imported/rsc/reallyhard0-1k | 27 | 583.44 ± 0.4% | not timed | not timed | 585.42 ± 0.2% | 40.77 ± 0.1% | not timed | not timed | 582.43 ± 0.3% | | 1.00 | 1.00 | 14.31 |
| imported/rsc/reallyhard0-32k | 27 | 603.90 ± 0.3% | not timed | not timed | 617.52 ± 0.2% | 29.34 ± 0.0% | not timed | not timed | 602.31 ± 0.2% | | 1.00 | 0.98 | 20.58 |
| imported/rsc/reallyhard0-1mb | 51 | 628.08 ± 0.9% | not timed | not timed | 616.73 ± 0.2% | 29.37 ± 0.1% | not timed | not timed | 624.64 ± 0.9% | | 1.01 | 1.02 | 21.38 |
| imported/rsc/reallyreallyhard0-32 | 47 | 285.11 ± 1.7% | not timed | not timed | 195.77 ± 0.1% | 59.30 ± 11.5% | not timed | not timed | 286.72 ± 1.7% | | 0.99 | 1.46 | 4.81 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6999.16 ± 0.1% | not timed | not timed | 5940.72 ± 0.1% | 33.68 ± 1.9% | not timed | not timed | 7002.68 ± 0.3% | | 1.00 | 1.18 | 207.79 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21443.20 ± 0.1% | not timed | not timed | 19382.20 ± 0.1% | 25.07 ± 0.2% | not timed | not timed | 21442.77 ± 0.2% | | 1.00 | 1.11 | 855.17 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21631.90 ± 3.3% | not timed | not timed | 19796.23 ± 1.1% | 25.09 ± 1.7% | not timed | not timed | 21606.52 ± 1.0% | | 1.00 | 1.09 | 862.22 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.61 ± 11.5% | not timed | not timed | 213.95 ± 0.3% | 61.10 ± 2.6% | not timed | not timed | 282.57 ± 1.6% | | 1.00 | 1.32 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5928.72 ± 0.1% | not timed | not timed | 6240.10 ± 0.2% | 34.38 ± 0.9% | not timed | not timed | 5931.27 ± 0.1% | | 1.00 | 0.95 | 172.42 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21367.77 ± 0.1% | not timed | not timed | 19382.67 ± 0.1% | 24.50 ± 2.2% | not timed | not timed | 21301.49 ± 0.0% | | 1.00 | 1.10 | 872.29 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21256.48 ± 3.1% | not timed | not timed | 19595.18 ± 1.8% | 24.64 ± 0.8% | not timed | not timed | 21569.62 ± 2.4% | | 0.99 | 1.08 | 862.75 |
| imported/sherlock/name-sherlock | 776 | 19745.55 ± 6.5% | not timed | not timed | 18359.92 ± 0.6% | 10126.35 ± 16.2% | not timed | not timed | 19733.95 ± 2.2% | | 1.00 | 1.08 | 1.95 |
| imported/sherlock/name-holmes | 2766 | 15169.79 ± 1.5% | not timed | not timed | 15447.80 ± 0.3% | 3192.19 ± 11.4% | not timed | not timed | 15308.85 ± 1.4% | | 0.99 | 0.98 | 4.75 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19756.52 ± 1.7% | not timed | not timed | 18336.61 ± 0.3% | 8090.20 ± 50.8% | not timed | not timed | 19772.39 ± 2.3% | | 1.00 | 1.08 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15642.37 ± 0.3% | not timed | not timed | 4000.79 ± 0.2% | 32.51 ± 0.5% | not timed | not timed | 15650.91 ± 0.2% | | 1.00 | 3.91 | 481.16 |
| imported/sherlock/name-holmes-casei | 2802 | 9353.71 ± 5.8% | not timed | not timed | 3287.61 ± 0.2% | 37.43 ± 0.2% | not timed | not timed | 9370.15 ± 5.1% | | 1.00 | 2.85 | 249.93 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12949.22 ± 7.4% | not timed | not timed | 3949.06 ± 0.2% | 32.48 ± 0.1% | not timed | not timed | 12962.43 ± 1.0% | | 1.00 | 3.28 | 398.68 |
| imported/sherlock/name-whitespace | 1461 | 15367.14 ± 1.7% | not timed | not timed | 14461.67 ± 0.1% | 6430.83 ± 19.9% | not timed | not timed | 15381.64 ± 1.4% | | 1.00 | 1.06 | 2.39 |
| imported/sherlock/name-alt1 | 1142 | 11663.69 ± 0.8% | not timed | not timed | 16275.29 ± 0.4% | 4118.63 ± 22.0% | not timed | not timed | 11601.76 ± 2.6% | | 1.01 | 0.72 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8987.60 ± 0.6% | not timed | not timed | 3826.22 ± 0.1% | 31.34 ± 0.2% | not timed | not timed | 8964.86 ± 0.6% | | 1.00 | 2.35 | 286.81 |
| imported/sherlock/name-alt3 | 4507 | 5554.40 ± 0.6% | not timed | not timed | 3632.58 ± 0.1% | 9.94 ± 0.3% | not timed | not timed | 5538.64 ± 0.5% | | 1.00 | 1.53 | 559.00 |
| imported/sherlock/name-alt3-casei | 4593 | 1523.77 ± 2.3% | not timed | not timed | 279.60 ± 0.2% | 6.44 ± 0.2% | not timed | not timed | 1520.37 ± 1.4% | | 1.00 | 5.45 | 236.64 |
| imported/sherlock/name-alt4 | 3686 | 6418.63 ± 0.7% | not timed | not timed | 3768.78 ± 0.2% | 31.39 ± 0.2% | not timed | not timed | 6427.52 ± 0.6% | | 1.00 | 1.70 | 204.48 |
| imported/sherlock/name-alt4-casei | 4254 | 2810.19 ± 2.2% | not timed | not timed | 2576.18 ± 0.2% | 19.83 ± 0.2% | not timed | not timed | 2812.35 ± 1.0% | | 1.00 | 1.09 | 141.70 |
| imported/sherlock/name-alt5 | 4028 | 6412.77 ± 0.5% | not timed | not timed | 3744.86 ± 0.2% | 21.85 ± 0.2% | not timed | not timed | 6409.15 ± 0.4% | | 1.00 | 1.71 | 293.54 |
| imported/sherlock/name-alt5-casei | 4104 | 3480.43 ± 2.1% | not timed | not timed | 2216.45 ± 0.1% | 14.33 ± 0.2% | not timed | not timed | 3486.25 ± 0.7% | | 1.00 | 1.57 | 242.93 |
| imported/sherlock/no-match-uncommon | 0 | 21551.29 ± 0.6% | not timed | not timed | 19483.08 ± 0.8% | 35472.70 ± 1.0% | not timed | not timed | 21526.97 ± 0.4% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21384.58 ± 0.5% | not timed | not timed | 19430.82 ± 0.6% | 1276.22 ± 1.2% | not timed | not timed | 21386.22 ± 0.5% | | 1.00 | 1.10 | 16.76 |
| imported/sherlock/no-match-really-common | 0 | 15982.42 ± 2.9% | not timed | not timed | 18606.10 ± 0.5% | 1279.42 ± 1.2% | not timed | not timed | 16121.33 ± 2.9% | | 0.99 | 0.86 | 12.49 |
| imported/sherlock/the-lower | 21654 | 2305.45 ± 0.8% | not timed | not timed | 2338.55 ± 0.5% | 239.42 ± 15.5% | not timed | not timed | 2318.32 ± 2.1% | | 0.99 | 0.99 | 9.63 |
| imported/sherlock/the-upper | 2223 | 12750.15 ± 1.1% | not timed | not timed | 13566.31 ± 0.6% | 2682.68 ± 2.1% | not timed | not timed | 12796.17 ± 1.2% | | 1.00 | 0.94 | 4.75 |
| imported/sherlock/the-casei | 23961 | 1999.98 ± 1.4% | not timed | not timed | 1315.49 ± 0.2% | 34.90 ± 30.5% | not timed | not timed | 2003.11 ± 0.4% | | 1.00 | 1.52 | 57.30 |
| imported/sherlock/everything-greedy | 581881 | 282.45 ± 0.2% | not timed | not timed | 164.30 ± 0.2% | 28.77 ± 23.0% | not timed | not timed | 281.60 ± 0.7% | | 1.00 | 1.72 | 9.82 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.99 ± 0.1% | not timed | not timed | 213.09 ± 0.4% | 33.01 ± 0.1% | not timed | not timed | 490.11 ± 0.1% | | 1.00 | 2.30 | 14.87 |
| imported/sherlock/letters | 447175 | 61.78 ± 1.2% | not timed | not timed | 32.14 ± 0.2% | 6.55 ± 19.6% | not timed | not timed | 61.95 ± 0.3% | | 1.00 | 1.92 | 9.44 |
| imported/sherlock/letters-upper | 14180 | 447.81 ± 2.3% | not timed | not timed | 367.56 ± 0.2% | 29.64 ± 22.4% | not timed | not timed | 446.53 ± 0.4% | | 1.00 | 1.22 | 15.11 |
| imported/sherlock/letters-lower | 432995 | 62.69 ± 0.7% | not timed | not timed | 33.05 ± 0.2% | 5.29 ± 41.5% | not timed | not timed | 62.81 ± 0.6% | | 1.00 | 1.90 | 11.86 |
| imported/sherlock/words | 447639 | 112.68 ± 1.0% | not timed | not timed | 81.29 ± 0.2% | 14.37 ± 4.0% | not timed | not timed | 113.60 ± 0.8% | | 0.99 | 1.39 | 7.84 |
| imported/sherlock/before-holmes | 4073 | 10291.03 ± 0.6% | not timed | not timed | 8462.76 ± 0.2% | 24.20 ± 1.6% | not timed | not timed | 10283.14 ± 0.6% | | 1.00 | 1.22 | 425.33 |
| imported/sherlock/before-after-holmes | 2593 | 9978.80 ± 0.8% | not timed | not timed | 9522.10 ± 0.8% | 24.06 ± 1.7% | not timed | not timed | 9964.76 ± 0.5% | | 1.00 | 1.05 | 414.75 |
| imported/sherlock/holmes-cochar-watson | 150 | 5202.16 ± 0.2% | not timed | not timed | 3429.59 ± 0.1% | 31.07 ± 0.1% | not timed | not timed | 5207.31 ± 0.3% | | 1.00 | 1.52 | 167.41 |
| imported/sherlock/holmes-coword-watson | 14309 | 1151.74 ± 0.3% | not timed | not timed | 1122.69 ± 0.2% | 6.77 ± 0.2% | not timed | not timed | 1149.84 ± 0.3% | | 1.00 | 1.03 | 170.04 |
| imported/sherlock/quotes | 14437 | 1574.40 ± 0.2% | not timed | not timed | 1751.03 ± 0.3% | 35.12 ± 0.3% | not timed | not timed | 1574.64 ± 0.3% | | 1.00 | 0.90 | 44.83 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17419.62 ± 0.3% | not timed | not timed | 16010.52 ± 0.3% | 36.74 ± 0.2% | not timed | not timed | 17402.97 ± 0.5% | | 1.00 | 1.09 | 474.12 |
| imported/sherlock/word-ending-n | 35297 | 481.31 ± 0.3% | not timed | not timed | 407.13 ± 0.1% | 23.58 ± 0.6% | not timed | not timed | 480.07 ± 0.1% | | 1.00 | 1.18 | 20.41 |
| imported/sherlock/repeated-class-negation | 2130 | 14739.26 ± 0.7% | not timed | not timed | 10978.74 ± 0.1% | 11.59 ± 0.3% | not timed | not timed | 14739.37 ± 0.5% | | 1.00 | 1.34 | 1272.01 |
| imported/sherlock/ing-suffix | 20547 | 559.55 ± 1.5% | not timed | not timed | 516.32 ± 0.1% | 28.76 ± 23.4% | not timed | not timed | 558.61 ± 0.3% | | 1.00 | 1.08 | 19.45 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1673.08 ± 0.7% | not timed | not timed | 2104.75 ± 1.3% | 20.53 ± 0.1% | not timed | not timed | 1671.90 ± 0.9% | | 1.00 | 0.79 | 81.49 |
| opt/accelerate/whole-line | 239963 | 458.05 ± 0.1% | not timed | not timed | 372.49 ± 0.3% | 91.90 ± 17.4% | not timed | not timed | 457.77 ± 0.4% | | 1.00 | 1.23 | 4.98 |
| opt/accelerate/non-dna | 16745 | 433.70 ± 0.7% | not timed | not timed | 392.89 ± 0.1% | 29.14 ± 20.0% | not timed | not timed | 432.25 ± 0.9% | | 1.00 | 1.10 | 14.89 |
| opt/backtrack/words-english | 40536 | 141.75 ± 7.5% | not timed | not timed | 94.28 ± 0.2% | 19.73 ± 8.8% | not timed | not timed | 141.81 ± 1.3% | | 1.00 | 1.50 | 7.18 |
| opt/fixed-length/too-small-ascii | 0 | 316.00 ± 0.3% | not timed | not timed | 701.30 ± 2.2% | 80.64 ± 0.6% | not timed | not timed | 317.00 ± 0.3% | | 1.00 | 0.45 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3435.11 ± 0.1% | not timed | not timed | 5755.66 ± 0.1% | 122.11 ± 0.6% | not timed | not timed | 3424.35 ± 0.1% | | 1.00 | 0.60 | 28.13 |
| opt/fixed-length/go33484-1 | 0 | 659756.25 ± 0.1% | not timed | not timed | 1106821.48 ± 0.2% | 61460.99 ± 0.4% | not timed | not timed | 659850.83 ± 0.1% | | 1.00 | 0.60 | 10.73 |
| opt/fixed-length/go33484-2 | 0 | 659027.09 ± 0.1% | not timed | not timed | 1113589.59 ± 0.3% | 32184.92 ± 0.5% | not timed | not timed | 659396.08 ± 0.1% | | 1.00 | 0.59 | 20.48 |
| opt/fixed-length/go33484-3 | 0 | 65939.92 ± 0.7% | not timed | not timed | 110871.38 ± 0.5% | 768.57 ± 0.2% | not timed | not timed | 65974.42 ± 0.5% | | 1.00 | 0.59 | 85.80 |
| opt/literal-alt/one-pattern | 1 | 549.37 ± 1.4% | not timed | not timed | 543.29 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 549.81 ± 1.8% | | 1.00 | 1.01 | 1376.65 |
| opt/onepass/fn-predicate | 916 | 369.75 ± 1.3% | not timed | not timed | 337.60 ± 0.3% | 201.47 ± 13.0% | not timed | not timed | 371.09 ± 0.6% | | 1.00 | 1.10 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 175.42 ± 6.7% | not timed | not timed | 202.16 ± 0.3% | 79.79 ± 10.6% | not timed | not timed | 182.21 ± 1.9% | | 0.96 | 0.87 | 2.20 |
| opt/prefilter/literal-english | 1 | 20501.90 ± 0.5% | not timed | not timed | 19717.48 ± 0.5% | 17191.36 ± 0.4% | not timed | not timed | 20500.24 ± 0.4% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14490.50 ± 0.6% | not timed | not timed | 4308.54 ± 0.1% | 32.70 ± 0.1% | not timed | not timed | 14499.85 ± 0.3% | | 1.00 | 3.36 | 443.16 |
| opt/prefilter/literal-russian | 1 | 20932.45 ± 0.4% | not timed | not timed | 19731.08 ± 0.8% | 3324.13 ± 0.1% | not timed | not timed | 20963.71 ± 0.3% | | 1.00 | 1.06 | 6.30 |
| opt/prefilter/literal-casei-russian | 1 | 8578.45 ± 0.6% | not timed | not timed | 3893.63 ± 0.1% | 31.70 ± 0.7% | not timed | not timed | 8578.96 ± 0.7% | | 1.00 | 2.20 | 270.65 |
| opt/prefilter/rust-functions | 948 | 6815.17 ± 0.1% | not timed | not timed | 8962.96 ± 0.5% | 1870.27 ± 0.4% | not timed | not timed | 6816.36 ± 0.5% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29557043.81 ± 0.1% | not timed | not timed | 21713790.41 ± 0.3% | 50.60 ± 0.1% | not timed | not timed | 29596137.99 ± 0.1% | | 1.00 | 1.36 | 584147.87 |
| opt/reverse-inner/holmes | 2593 | 9939.89 ± 1.0% | not timed | not timed | 9530.36 ± 0.6% | 24.26 ± 0.3% | not timed | not timed | 9971.34 ± 0.6% | | 1.00 | 1.04 | 409.79 |
| opt/reverse-inner/email | 47 | 36413.45 ± 1.4% | not timed | not timed | 44963.46 ± 0.2% | 32.32 ± 0.3% | not timed | not timed | 36891.21 ± 3.1% | | 0.99 | 0.81 | 1126.69 |
| opt/reverse-inner/factored-prefix | 3542 | 592.85 ± 0.4% | not timed | not timed | 597.09 ± 0.0% | 12.57 ± 0.2% | not timed | not timed | 592.76 ± 0.3% | | 1.00 | 0.99 | 47.16 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20996.12 ± 0.3% | not timed | not timed | 616.49 ± 0.2% | 75.03 ± 0.1% | not timed | not timed | 21164.94 ± 0.1% | | 0.99 | 34.06 | 279.83 |
| opt/reverse-inner/no-quadratic-forward | 0 | 726.86 ± 1.6% | not timed | not timed | 288.15 ± 0.1% | 24.69 ± 0.1% | not timed | not timed | 732.91 ± 1.7% | | 0.99 | 2.52 | 29.44 |
| opt/reverse-suffix/holmes | 4073 | 10263.62 ± 0.7% | not timed | not timed | 8486.26 ± 0.6% | 24.18 ± 1.2% | not timed | not timed | 10275.17 ± 0.3% | | 1.00 | 1.21 | 424.38 |
| opt/reverse-suffix/no-quadratic | 0 | 21075.59 ± 0.1% | not timed | not timed | 610.84 ± 0.5% | 75.18 ± 0.1% | not timed | not timed | 21148.09 ± 0.1% | | 1.00 | 34.50 | 280.32 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.62 ± 2.3% | not timed | not timed | 131.97 ± 0.4% | 13.54 ± 15.9% | not timed | not timed | 120.21 ± 2.1% | | 1.00 | 0.91 | 8.91 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 119.33 ± 2.5% | not timed | not timed | 130.60 ± 0.1% | 13.44 ± 16.2% | not timed | not timed | 120.89 ± 0.7% | | 0.99 | 0.91 | 8.88 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.5% | not timed | not timed | 0.55 ± 0.3% | 112.22 ± 0.5% | not timed | not timed | 0.28 ± 0.4% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 320.65 ± 0.5% | not timed | not timed | 294.87 ± 0.1% | 102.34 ± 9.5% | not timed | not timed | 322.70 ± 3.6% | | 0.99 | 1.09 | 3.13 |
| reported/i13-subset-regex/original-ascii | 4094 | 11238.51 ± 0.9% | not timed | not timed | 4558.01 ± 0.7% | 11.52 ± 0.2% | not timed | not timed | 11227.29 ± 3.8% | | 1.00 | 2.47 | 975.92 |
| reported/i13-subset-regex/original-unicode | 4094 | 11106.33 ± 0.6% | not timed | not timed | 253.33 ± 3.1% | 11.51 ± 0.1% | not timed | not timed | 11266.88 ± 0.9% | | 0.99 | 43.84 | 964.95 |
| reported/i13-subset-regex/big-ascii | 1955 | 10722.78 ± 1.0% | not timed | not timed | 68.08 ± 3.5% | 9.87 ± 0.1% | not timed | not timed | 10761.18 ± 4.9% | | 1.00 | 157.50 | 1086.15 |
| reported/i13-subset-regex/big-unicode | 1955 | 10625.52 ± 0.6% | not timed | not timed | 12.27 ± 54.9% | 9.84 ± 0.1% | not timed | not timed | 10764.66 ± 7.4% | | 0.99 | 866.28 | 1080.28 |
| reported/i13-subset-regex/huge-ascii | 55 | 10114.12 ± 1.1% | not timed | not timed | 10.96 ± 0.2% | 8.79 ± 0.2% | not timed | not timed | 10087.74 ± 1.2% | | 1.00 | 922.88 | 1150.21 |
| reported/i13-subset-regex/huge-unicode | 55 | 10074.61 ± 2.7% | not timed | not timed | 11.00 ± 0.4% | 8.79 ± 0.2% | not timed | not timed | 9901.56 ± 2.6% | | 1.02 | 916.26 | 1146.74 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.0% | not timed | not timed | 11.07 ± 0.1% | 8.78 ± 0.1% | not timed | not timed | 3.52 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.96 ± 0.1% | not timed | not timed | 10.90 ± 0.3% | 8.78 ± 1.0% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.24 ± 0.5% | not timed | not timed | 102.28 ± 0.1% | 6.64 ± 0.2% | not timed | not timed | 484.86 ± 0.3% | | 1.00 | 4.72 | 72.75 |
| reported/i787-keywords/opt-ascii | 5674 | 485.18 ± 0.3% | not timed | not timed | 267.79 ± 0.2% | 10.27 ± 0.1% | not timed | not timed | 484.18 ± 0.3% | | 1.00 | 1.81 | 47.24 |
| slow/quadratic-regex-1x | 100 | 7.07 ± 0.2% | not timed | not timed | 4.95 ± 0.1% | 0.05 ± 0.5% | not timed | not timed | 7.12 ± 0.4% | | 0.99 | 1.43 | 143.03 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.3% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.3% | not timed | not timed | 3.43 ± 0.1% | | 0.99 | 1.24 | 269.21 |
| slow/quadratic-haystack-1x | 100 | 22.05 ± 6.4% | not timed | not timed | 10.01 ± 0.4% | 1.01 ± 12.8% | not timed | not timed | 22.08 ± 2.0% | | 1.00 | 2.20 | 21.75 |
| slow/quadratic-haystack-2x | 200 | 19.64 ± 1.3% | not timed | not timed | 5.56 ± 0.5% | 0.55 ± 11.8% | not timed | not timed | 19.65 ± 1.0% | | 1.00 | 3.53 | 36.02 |
| unicode/codepoints/any-one | 1112064 | 280.71 ± 0.2% | not timed | not timed | 175.58 ± 0.1% | 18.29 ± 14.1% | not timed | not timed | 280.38 ± 2.9% | | 1.00 | 1.60 | 15.35 |
| unicode/codepoints/any-all | 4382592 | 281.74 ± 1.1% | not timed | not timed | 247.25 ± 0.3% | 117.58 ± 0.1% | not timed | not timed | 282.38 ± 1.5% | | 1.00 | 1.14 | 2.40 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 1.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 601.31 ± 1.0% | not timed | not timed | 616.57 ± 0.3% | 135.37 ± 0.3% | not timed | not timed | 601.98 ± 0.8% | | 1.00 | 0.98 | 4.44 |
| unicode/overlapping-words/ascii | 6156 | 32.28 ± 0.4% | not timed | not timed | 38.87 ± 0.2% | 3.94 ± 0.5% | not timed | not timed | 32.33 ± 0.2% | | 1.00 | 0.83 | 8.20 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.0% | not timed | not timed | 4.11 ± 0.2% | 2.34 ± 0.4% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.35 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.4% | not timed | not timed | 4.11 ± 0.1% | 6.24 ± 10.1% | not timed | not timed | 1.27 ± 0.2% | | 1.01 | 0.31 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 129.03 ± 7.9% | not timed | not timed | 80.94 ± 0.1% | 11.71 ± 21.3% | not timed | not timed | 129.65 ± 0.4% | | 1.00 | 1.59 | 11.02 |
| unicode/word/boundary-long-english | 3466 | 608.45 ± 0.7% | not timed | not timed | 602.74 ± 0.2% | 32.41 ± 0.9% | not timed | not timed | 606.27 ± 1.2% | | 1.00 | 1.01 | 18.78 |
| unicode/word/around-holmes-english | 27 | 19588.58 ± 0.3% | not timed | not timed | 19358.59 ± 0.7% | 22.07 ± 0.9% | not timed | not timed | 19599.99 ± 0.4% | | 1.00 | 1.01 | 887.47 |
| wild/bibleref/long | 874 | 565.13 ± 0.3% | not timed | not timed | 582.08 ± 0.2% | 6.75 ± 0.1% | not timed | not timed | 566.95 ± 0.5% | | 1.00 | 0.97 | 83.72 |
| wild/bibleref/short | 30 | 25.20 ± 2.1% | not timed | not timed | 30.72 ± 0.6% | 14.18 ± 14.9% | not timed | not timed | 25.04 ± 3.4% | | 1.01 | 0.82 | 1.78 |
| wild/bibleref/line | 874 | 398.51 ± 0.2% | not timed | not timed | 214.03 ± 0.2% | 9.16 ± 8.4% | not timed | not timed | 400.07 ± 1.6% | | 1.00 | 1.86 | 43.51 |
| wild/caddy/caddy | 6 | 419.97 ± 4.5% | not timed | not timed | 248.76 ± 0.2% | 68.43 ± 11.7% | not timed | not timed | 421.80 ± 0.8% | | 1.00 | 1.69 | 6.14 |
| wild/dot-star-capture/rust-src-tools | 6 | 1065.60 ± 0.6% | not timed | not timed | 348.43 ± 0.3% | 13.52 ± 0.3% | not timed | not timed | 1061.58 ± 0.4% | | 1.00 | 3.06 | 78.83 |
| wild/ruff/noqa | 84 | 439.39 ± 0.1% | not timed | not timed | 465.00 ± 0.2% | 19.55 ± 2.0% | not timed | not timed | 439.33 ± 1.9% | | 1.00 | 0.94 | 22.47 |
| wild/ruff/unnecessary-coding-comment | 16 | 961.64 ± 0.4% | not timed | not timed | 702.00 ± 0.1% | 136.50 ± 11.1% | not timed | not timed | 961.06 ± 0.7% | | 1.00 | 1.37 | 7.04 |
| wild/ruff/string-quote-prefix | 2972 | 1370.60 ± 0.5% | not timed | not timed | 439.26 ± 0.1% | 316.88 ± 25.9% | not timed | not timed | 1371.43 ± 0.5% | | 1.00 | 3.12 | 4.33 |
| wild/ruff/space-around-operator | 1224378 | 223.18 ± 1.8% | not timed | not timed | 186.62 ± 0.1% | 18.13 ± 1.6% | not timed | not timed | 224.06 ± 1.4% | | 1.00 | 1.20 | 12.31 |
| wild/ruff/shebang | 282 | 970.66 ± 0.5% | not timed | not timed | 328.71 ± 0.1% | 114.40 ± 13.6% | not timed | not timed | 979.94 ± 0.3% | | 0.99 | 2.95 | 8.48 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13843.96 ± 0.2% | not timed | not timed | 13903.03 ± 0.2% | 6955.24 ± 0.9% | not timed | not timed | 13867.72 ± 0.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12875.61 ± 0.1% | not timed | not timed | 13584.76 ± 0.4% | 6421.81 ± 0.6% | not timed | not timed | 12883.83 ± 0.4% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13244.05 ± 0.6% | not timed | not timed | 13737.43 ± 0.3% | 6710.01 ± 36.5% | not timed | not timed | 13252.14 ± 5.9% | | 1.00 | 0.96 | 1.97 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9573.44 ± 0.3% | not timed | not timed | 13641.56 ± 0.2% | 6784.13 ± 0.6% | not timed | not timed | 9584.43 ± 0.3% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 121.12 ± 13.9% | not timed | not timed | 65.97 ± 0.6% | 2.24 ± 0.6% | not timed | not timed | 121.84 ± 14.2% | | 0.99 | 1.84 | 54.04 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 57.9% | not timed | not timed | 0.01 ± 1.8% | 0.01 ± 22.2% | not timed | not timed | 0.03 ± 67.9% | | 0.99 | 3.08 | 3.90 |
| dictionary/compile/english-15 | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 13.0% | not timed | not timed | 0.35 ± 22.8% | | 1.00 | 4.98 | 3.41 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 1.7% | not timed | not timed | 0.02 ± 0.4% | 36.01 ± 4.4% | not timed | not timed | 0.25 ± 2.5% | | 1.01 | 13.11 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.83 ± 2.6% | not timed | not timed | 11.56 ± 0.2% | 52.09 ± 19.2% | not timed | not timed | 47.99 ± 2.1% | | 1.00 | 4.14 | 0.92 |
| reported/i787-keywords/compile | 1 | 35.43 ± 12.8% | not timed | not timed | 2.14 ± 0.6% | 17.41 ± 26.3% | not timed | not timed | 35.47 ± 2.7% | | 1.00 | 16.53 | 2.04 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 366.27 ± 3.1% | not timed | not timed | 119.83 ± 0.3% | 590.37 ± 25.7% | not timed | not timed | 370.48 ± 1.2% | | 0.99 | 3.06 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 49.05 ± 5.6% | not timed | not timed | 4.09 ± 0.9% | 43.73 ± 12.8% | not timed | not timed | 49.40 ± 2.9% | | 0.99 | 11.99 | 1.12 |
| unicode/compile/one-letter | 53 | 6.78 ± 12.0% | not timed | not timed | 4.57 ± 0.1% | 66.35 ± 2.5% | not timed | not timed | 6.85 ± 14.3% | | 0.99 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 16.8% | not timed | not timed | 0.10 ± 0.7% | 68.34 ± 6.6% | not timed | not timed | 1.11 ± 1.8% | | 0.97 | 10.70 | 0.0158 |
| unicode/compile/fifty-letters-ascii | 1 | 220.03 ± 12.3% | not timed | not timed | 53.17 ± 0.2% | 193.01 ± 19.5% | not timed | not timed | 225.45 ± 7.3% | | 0.98 | 4.14 | 1.14 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 384.35 ± 8.6% | not timed | not timed | 47.18 ± 0.4% | 687.33 ± 19.6% | not timed | not timed | 385.59 ± 2.1% | | 1.00 | 8.15 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 610.27 ± 4.0% | not timed | not timed | 146.34 ± 0.3% | 675.52 ± 24.4% | not timed | not timed | 614.41 ± 11.9% | | 0.99 | 4.17 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 319.28 ± 4.5% | not timed | not timed | 50.83 ± 0.2% | 1254.78 ± 1.6% | not timed | not timed | 330.69 ± 4.5% | | 0.97 | 6.28 | 0.25 |
| wild/bibleref/compile | 3 | 5.95 ± 4.1% | not timed | not timed | 1.93 ± 1.4% | 31.59 ± 10.1% | not timed | not timed | 6.02 ± 3.9% | | 0.99 | 3.09 | 0.19 |
| wild/url/compile | 1 | 0.65 ± 15.5% | not timed | not timed | 0.15 ± 0.8% | 0.44 ± 26.8% | not timed | not timed | 0.66 ± 28.6% | | 0.99 | 4.47 | 1.49 |

