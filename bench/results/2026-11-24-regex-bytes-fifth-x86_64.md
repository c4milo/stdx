# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391496695 |
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
| literal: a word | 217 | 48651.01 ± 5.0% | 3919.23 ± 4.1% | 29.62 ± 2.0% | 38804.85 ± 0.4% | 12368.52 ± 2.4% | 12.89 ± 0.2% | 104.48 ± 1.2% | 48562.50 ± 1.6% | 12.41 | 1.00 | 1.25 | 3.93 |
| literal: a word that is not there | 0 | 63615.48 ± 0.3% | 3867.42 ± 0.6% | 30.14 ± 5.1% | 45893.18 ± 0.2% | 43735.58 ± 2.6% | 12.78 ± 0.6% | 98.71 ± 0.9% | 63735.84 ± 0.3% | 16.45 | 1.00 | 1.39 | 1.45 |
| literal: one of four words | 661 | 15190.28 ± 0.5% | 1672.02 ± 0.8% | 15.86 ± 0.8% | 11191.05 ± 0.3% | 24.97 ± 0.8% | 4.46 ± 0.2% | 8.27 ± 0.4% | 15218.11 ± 0.2% | 9.08 | 1.00 | 1.36 | 608.38 |
| literal: a word in any case | 217 | 42651.23 ± 3.2% | 1785.48 ± 2.4% | 22.39 ± 0.7% | 11339.99 ± 3.4% | 46.82 ± 1.6% | refused | differs | 42678.31 ± 0.8% | 23.89 | 1.00 | 3.76 | 910.94 |
| literal: an href attribute | 33 | 40578.36 ± 1.1% | 616.32 ± 0.1% | 28.90 ± 0.3% | 35092.06 ± 0.3% | 3051.68 ± 2.4% | 9.68 ± 0.3% | 91.36 ± 0.5% | 40622.68 ± 0.4% | 65.84 | 1.00 | 1.16 | 13.30 |
| literal: a word, second text | 123 | 51062.03 ± 0.2% | 3096.55 ± 0.8% | 29.82 ± 0.5% | 39750.20 ± 1.6% | 11245.55 ± 6.7% | 14.44 ± 0.2% | 87.71 ± 1.6% | 51251.52 ± 0.2% | 16.49 | 1.00 | 1.28 | 4.54 |
| class: two capitalized words | 1331 | 906.13 ± 0.1% | 605.23 ± 0.7% | 27.83 ± 0.2% | 576.38 ± 0.2% | 44.24 ± 17.0% | 11.07 ± 0.4% | 79.73 ± 0.3% | 906.61 ± 1.1% | 1.50 | 1.00 | 1.57 | 20.48 |
| class: a word that ends in ing | 3399 | 575.65 ± 0.3% | 576.32 ± 0.3% | 19.67 ± 0.4% | 541.13 ± 0.2% | 32.88 ± 19.5% | 6.24 ± 0.5% | 20.20 ± 0.2% | 575.68 ± 0.5% | 1.00 | 1.00 | 1.06 | 17.51 |
| class: a word in capitals | 2332 | 1144.74 ± 0.3% | 610.35 ± 0.4% | 29.38 ± 0.3% | 566.73 ± 1.5% | 47.07 ± 3.9% | 12.48 ± 0.4% | 100.85 ± 0.8% | 1145.22 ± 0.5% | 1.88 | 1.00 | 2.02 | 24.32 |
| class: a number | 8288 | 1820.57 ± 0.6% | 815.83 ± 1.9% | 29.99 ± 0.9% | 1788.19 ± 0.3% | 48.35 ± 12.8% | 0.39 ± 0.5% | 72.48 ± 0.9% | 1815.32 ± 0.5% | 2.23 | 1.00 | 1.02 | 37.65 |
| class: two capitalized words, second text | 5359 | 512.33 ± 1.5% | 519.89 ± 0.2% | 25.28 ± 6.2% | 478.92 ± 0.1% | 38.73 ± 11.2% | 12.71 ± 0.1% | 73.86 ± 6.7% | 512.33 ± 0.9% | 0.99 | 1.00 | 1.07 | 13.23 |
| other: a word between two words | 6104 | 855.95 ± 0.4% | 585.27 ± 0.4% | 24.98 ± 5.7% | 815.21 ± 0.4% | 127.01 ± 13.9% | 8.49 ± 0.2% | 81.38 ± 1.8% | 839.83 ± 0.2% | 1.46 | 1.02 | 1.05 | 6.74 |
| other: a number before a unit, second text | 1481 | 10429.86 ± 5.3% | 1057.73 ± 4.5% | 28.05 ± 0.4% | 8272.01 ± 6.7% | 44.92 ± 11.1% | 13.26 ± 0.5% | 78.40 ± 0.5% | 10419.79 ± 1.0% | 9.86 | 1.00 | 1.26 | 232.21 |
| other: a heading's start tag | 110 | 25499.28 ± 4.3% | 747.48 ± 0.3% | 29.86 ± 0.2% | 2525.47 ± 4.6% | 2025.58 ± 12.4% | 11.80 ± 0.6% | 107.05 ± 2.0% | 25466.64 ± 0.5% | 34.11 | 1.00 | 10.10 | 12.59 |
| other: a whole word | 217 | 31591.45 ± 0.3% | 608.01 ± 0.1% | 30.12 ± 0.4% | 28141.76 ± 0.9% | 54.16 ± 1.0% | 11.20 ± 0.4% | 62.74 ± 0.9% | 31599.45 ± 0.3% | 51.96 | 1.00 | 1.12 | 583.28 |
| other: a line's first word, second text | 3716 | 2606.83 ± 2.0% | 589.18 ± 0.6% | 32.00 ± 8.5% | 2339.10 ± 0.7% | 70.25 ± 4.9% | refused | refused | 2637.16 ± 2.4% | 4.42 | 0.99 | 1.11 | 37.11 |
| other: fourteen octets before an x | 87 | 38056.37 ± 0.8% | 257.59 ± 2.4% | 7.34 ± 4.9% | 3552.42 ± 1.7% | 11.60 ± 0.9% | differs | 20.44 ± 0.8% | 37585.13 ± 0.9% | 147.74 | 1.01 | 10.71 | 3279.77 |
| other: a Greek word | 21815 | 462.61 ± 0.5% | 394.07 ± 0.2% | 33.12 ± 1.2% | 305.06 ± 0.4% | 57.84 ± 12.0% | differs | refused | 463.59 ± 0.4% | 1.17 | 1.00 | 1.52 | 8.00 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 21.41 ± 0.6% | 21.44 ± 0.1% | 1.03 ± 1.0% | 19.91 ± 2.6% | 2.68 ± 0.6% | differs | 4.19 ± 0.6% | 21.58 ± 0.1% | 1.00 | 0.99 | 1.08 | 7.99 |
| a UUID | 32895 | 24.13 ± 0.3% | 24.22 ± 6.3% | 0.72 ± 0.3% | 15.13 ± 0.3% | 3.03 ± 3.8% | 0.48 ± 1.1% | 3.75 ± 11.1% | 24.21 ± 0.8% | 1.00 | 1.00 | 1.59 | 7.96 |
| an IPv4 address | 33176 | 39.79 ± 1.1% | 39.91 ± 1.0% | 2.32 ± 0.9% | 28.52 ± 0.2% | 6.81 ± 2.3% | differs | 4.08 ± 1.0% | 39.90 ± 0.6% | 1.00 | 1.00 | 1.40 | 5.85 |
| a date and time | 32954 | 35.94 ± 0.4% | 35.83 ± 0.8% | 1.72 ± 0.1% | 21.29 ± 0.5% | 7.98 ± 3.1% | 0.91 ± 0.1% | 7.27 ± 3.2% | 36.05 ± 10.2% | 1.00 | 1.00 | 1.69 | 4.51 |
| a field path | 32606 | 25.24 ± 6.4% | 25.24 ± 6.3% | 0.92 ± 0.7% | 22.78 ± 0.2% | 3.47 ± 12.8% | differs | 2.96 ± 1.5% | 25.26 ± 0.3% | 1.00 | 1.00 | 1.11 | 7.28 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.03 ± 0.4% | 11.07 ± 0.3% | 11.07 ± 0.3% | 13.39 ± 3.1% | 5.75 ± 1.4% | 0.76 ± 2.9% | none | 11.02 ± 0.5% | 1.00 | 1.00 | 0.82 | 1.92 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.67 ± 0.2% | 232.59 ± 6.9% | 275.86 ± 0.2% | 101.07 ± 1.6% | 244.55 ± 2.2% | 703.25 ± 4.1% | 4900.08 ± 0.4% | 230.81 ± 0.3% | 0.99 | 1.00 | 2.28 | 0.94 |
| a UUID | 62 | 150.87 ± 0.6% | 151.61 ± 0.6% | 169.91 ± 0.2% | 58.57 ± 1.3% | 118.88 ± 1.4% | 248.13 ± 1.4% | 5401.44 ± 0.6% | 151.25 ± 1.2% | 1.00 | 1.00 | 2.58 | 1.27 |
| an IPv4 address | 29 | 470.00 ± 0.4% | 473.86 ± 0.5% | 696.84 ± 0.4% | 87.69 ± 0.9% | 148.66 ± 1.4% | 413.85 ± 0.6% | 9026.60 ± 0.4% | 469.87 ± 0.4% | 0.99 | 1.00 | 5.36 | 3.16 |
| a date and time | 56 | 341.73 ± 7.0% | 344.27 ± 0.9% | 446.15 ± 0.8% | 85.19 ± 1.0% | 157.42 ± 19.0% | 472.71 ± 15.2% | 5529.97 ± 16.9% | 341.44 ± 0.4% | 0.99 | 1.00 | 4.01 | 2.17 |
| a field path | 39 | 221.99 ± 1.4% | 223.92 ± 0.6% | 263.22 ± 0.2% | 95.04 ± 1.4% | 220.93 ± 39.3% | 743.18 ± 3.1% | 5936.58 ± 0.4% | 222.70 ± 0.3% | 0.99 | 1.00 | 2.34 | 1.00 |
| literal: a word | 7 | 684.40 ± 7.3% | 731.24 ± 0.3% | 1394.93 ± 0.6% | 647.42 ± 0.3% | 793.35 ± 13.1% | 1583.50 ± 0.6% | 34222.92 ± 0.6% | 685.50 ± 0.6% | 0.94 | 1.00 | 1.06 | 0.86 |
| literal: a word that is not there | 8 | 667.33 ± 0.6% | 713.51 ± 0.5% | 1318.03 ± 1.9% | 593.99 ± 1.0% | 756.87 ± 2.9% | 1496.69 ± 0.5% | 33494.41 ± 0.8% | 667.66 ± 0.1% | 0.94 | 1.00 | 1.12 | 0.88 |
| literal: one of four words | 26 | 262.30 ± 0.3% | 432.79 ± 5.5% | 606.98 ± 1.7% | 53.37 ± 1.8% | 289.20 ± 2.1% | 586.80 ± 0.9% | 17446.04 ± 7.6% | 261.96 ± 5.3% | 0.61 | 1.00 | 4.91 | 0.91 |
| literal: a word in any case | 11 | 466.69 ± 1.0% | 494.00 ± 0.2% | 736.83 ± 0.4% | 18.89 ± 0.5% | 821.37 ± 1.0% | refused | 26530.50 ± 0.5% | 466.08 ± 0.6% | 0.94 | 1.00 | 24.71 | 0.57 |
| literal: an href attribute | 12 | 380.25 ± 0.4% | 393.42 ± 0.5% | 537.59 ± 2.4% | 50.66 ± 1.3% | 569.44 ± 2.3% | 1222.49 ± 3.4% | 24749.38 ± 1.0% | 380.05 ± 0.4% | 0.97 | 1.00 | 7.51 | 0.67 |
| literal: a word, second text | 10 | 619.84 ± 0.3% | 667.10 ± 0.7% | 1181.89 ± 0.5% | 546.49 ± 1.0% | 664.79 ± 3.2% | 1279.09 ± 0.4% | 32149.53 ± 0.9% | 618.92 ± 0.6% | 0.93 | 1.00 | 1.13 | 0.93 |
| class: two capitalized words | 23 | 480.46 ± 0.2% | 523.71 ± 0.7% | 791.67 ± 1.1% | 121.16 ± 3.2% | 604.23 ± 0.4% | 1223.25 ± 0.5% | 7933.16 ± 1.4% | 480.64 ± 0.3% | 0.92 | 1.00 | 3.97 | 0.80 |
| class: a word that ends in ing | 9 | 589.72 ± 0.3% | 680.91 ± 0.3% | 1272.24 ± 0.3% | 150.68 ± 0.8% | 866.48 ± 1.8% | 1806.86 ± 1.0% | 19395.98 ± 0.2% | 590.48 ± 0.4% | 0.87 | 1.00 | 3.91 | 0.68 |
| class: a word in capitals | 16 | 525.60 ± 1.8% | 581.58 ± 0.2% | 1002.41 ± 1.2% | 155.60 ± 1.1% | 893.93 ± 2.0% | 1712.74 ± 2.0% | 10585.86 ± 0.4% | 525.64 ± 0.4% | 0.90 | 1.00 | 3.38 | 0.59 |
| class: a number | 6 | 646.67 ± 0.4% | 736.02 ± 0.2% | 1508.52 ± 0.5% | 47.44 ± 1.5% | 1622.73 ± 11.9% | 2727.01 ± 4.1% | 26020.81 ± 0.4% | 646.31 ± 0.4% | 0.88 | 1.00 | 13.63 | 0.40 |
| class: two capitalized words, second text | 23 | 480.25 ± 0.3% | 524.58 ± 0.7% | 791.25 ± 0.3% | 121.22 ± 0.5% | 597.29 ± 3.2% | 1210.94 ± 0.8% | 7949.51 ± 1.3% | 479.56 ± 0.6% | 0.92 | 1.00 | 3.96 | 0.80 |
| other: a word between two words | 13 | 598.06 ± 13.4% | 620.02 ± 1.2% | 1036.60 ± 0.8% | 157.87 ± 2.8% | 585.13 ± 2.2% | 1312.17 ± 2.4% | 17865.28 ± 8.3% | 597.60 ± 0.1% | 0.96 | 1.00 | 3.79 | 1.02 |
| other: a number before a unit, second text | 15 | 411.66 ± 0.1% | 462.08 ± 0.2% | 665.94 ± 2.3% | 44.12 ± 2.1% | 721.65 ± 2.0% | 1408.15 ± 3.2% | 17737.18 ± 0.4% | 411.50 ± 0.5% | 0.89 | 1.00 | 9.33 | 0.57 |
| other: a heading's start tag | 13 | 388.89 ± 0.3% | 396.66 ± 0.8% | 542.74 ± 0.6% | 48.79 ± 0.9% | 714.29 ± 2.5% | 1338.57 ± 9.0% | 20633.51 ± 0.5% | 389.12 ± 0.2% | 0.98 | 1.00 | 7.97 | 0.54 |
| other: a whole word | 11 | 617.46 ± 0.5% | 651.99 ± 1.5% | 1135.13 ± 0.4% | 141.72 ± 1.0% | 682.80 ± 2.4% | 1319.19 ± 0.9% | 31386.09 ± 1.1% | 615.45 ± 0.6% | 0.95 | 1.00 | 4.36 | 0.90 |
| other: a line's first word, second text | 17 | 567.07 ± 2.8% | 593.71 ± 0.4% | 1017.90 ± 0.9% | 147.62 ± 1.0% | 812.89 ± 1.0% | refused | refused | 567.51 ± 0.7% | 0.96 | 1.00 | 3.84 | 0.70 |
| other: fourteen octets before an x | 16 | 114.62 ± 3.1% | 168.51 ± 0.6% | 202.49 ± 0.8% | 18.26 ± 0.4% | 524.98 ± 14.7% | 565.65 ± 1.4% | 15777.91 ± 0.5% | 114.29 ± 0.6% | 0.68 | 1.00 | 6.28 | 0.22 |
| other: a Greek word | 8 | 430.28 ± 0.4% | 606.79 ± 0.9% | 1064.73 ± 1.3% | 63.36 ± 0.4% | 1613.02 ± 11.5% | 2516.21 ± 0.6% | refused | 429.25 ± 1.4% | 0.71 | 1.00 | 6.79 | 0.27 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37236.10 ± 1.1% | not timed | not timed | 33677.94 ± 0.4% | 2444.28 ± 27.2% | not timed | not timed | 37322.97 ± 0.4% | | 1.00 | 1.11 | 15.23 |
| 01-literal/sherlock-casei-en | 522 | 29623.61 ± 0.2% | not timed | not timed | 9021.23 ± 0.4% | 32.64 ± 0.7% | not timed | not timed | 29590.74 ± 16.2% | | 1.00 | 3.28 | 907.67 |
| 01-literal/sherlock-ru | 724 | 39082.36 ± 0.4% | not timed | not timed | 34488.47 ± 1.8% | 1238.63 ± 4.6% | not timed | not timed | 39087.14 ± 8.5% | | 1.00 | 1.13 | 31.55 |
| 01-literal/sherlock-casei-ru | 746 | 12480.84 ± 0.3% | not timed | not timed | 7811.44 ± 0.6% | 37.36 ± 0.6% | not timed | not timed | 12474.63 ± 0.5% | | 1.00 | 1.60 | 334.10 |
| 01-literal/sherlock-zh | 30 | 60045.20 ± 0.9% | not timed | not timed | 43014.36 ± 1.0% | 1630.63 ± 3.8% | not timed | not timed | 60031.27 ± 0.5% | | 1.00 | 1.40 | 36.82 |
| 02-literal-alternate/sherlock-en | 714 | 13743.65 ± 0.3% | not timed | not timed | 10885.27 ± 0.2% | 16.59 ± 18.0% | not timed | not timed | 13738.50 ± 0.2% | | 1.00 | 1.26 | 828.34 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5170.04 ± 12.7% | not timed | not timed | 2299.33 ± 0.2% | 11.26 ± 2.7% | not timed | not timed | 5173.70 ± 5.0% | | 1.00 | 2.25 | 459.06 |
| 02-literal-alternate/sherlock-ru | 899 | 10863.57 ± 0.7% | not timed | not timed | 9777.85 ± 9.1% | 22.53 ± 1.3% | not timed | not timed | 10906.51 ± 0.6% | | 1.00 | 1.11 | 482.12 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2531.71 ± 4.0% | not timed | not timed | 1195.00 ± 0.3% | 10.20 ± 6.7% | not timed | not timed | 2532.52 ± 3.3% | | 1.00 | 2.12 | 248.23 |
| 02-literal-alternate/sherlock-zh | 207 | 19594.78 ± 0.4% | not timed | not timed | 12665.75 ± 0.2% | 30.67 ± 11.5% | not timed | not timed | 19634.06 ± 11.4% | | 1.00 | 1.55 | 638.88 |
| 03-date/ascii | 111817 | 127.08 ± 1.9% | not timed | not timed | 100.74 ± 8.1% | 0.23 ± 5.2% | not timed | not timed | 127.36 ± 1.2% | | 1.00 | 1.26 | 561.01 |
| 04-ruff-noqa/real | 84 | 491.01 ± 0.3% | not timed | not timed | 508.43 ± 8.3% | 20.89 ± 0.8% | not timed | not timed | 490.41 ± 0.3% | | 1.00 | 0.97 | 23.51 |
| 04-ruff-noqa/tweaked | 44 | 621.48 ± 0.4% | not timed | not timed | 514.85 ± 0.4% | 367.53 ± 0.6% | not timed | not timed | 622.57 ± 0.6% | | 1.00 | 1.21 | 1.69 |
| 05-lexer-veryl/single | 124800 | 5.02 ± 1.8% | not timed | not timed | 5.31 ± 1.6% | 0.26 ± 5.6% | not timed | not timed | 5.01 ± 0.7% | | 1.00 | 0.95 | 19.44 |
| 06-cloud-flare-redos/original | 107 | 403.31 ± 0.5% | not timed | not timed | 226.36 ± 6.1% | 25.86 ± 0.5% | not timed | not timed | 402.69 ± 0.6% | | 1.00 | 1.78 | 15.60 |
| 06-cloud-flare-redos/simplified-short | 102 | 396.10 ± 0.8% | not timed | not timed | 235.22 ± 0.3% | 27.72 ± 0.3% | not timed | not timed | 395.79 ± 0.5% | | 1.00 | 1.68 | 14.29 |
| 06-cloud-flare-redos/simplified-long | 10000 | 503.57 ± 0.1% | not timed | not timed | 259.82 ± 0.3% | 29.84 ± 0.9% | not timed | not timed | 502.28 ± 0.1% | | 1.00 | 1.94 | 16.88 |
| 07-unicode-character-data/parse-line | 558784 | 252.77 ± 2.0% | not timed | not timed | 198.77 ± 0.8% | 46.96 ± 4.0% | not timed | not timed | 253.47 ± 2.6% | | 1.00 | 1.27 | 5.38 |
| 08-words/all-english | 56691 | 110.81 ± 1.6% | not timed | not timed | 84.77 ± 0.3% | 14.23 ± 11.4% | not timed | not timed | 112.03 ± 1.0% | | 0.99 | 1.31 | 7.79 |
| 08-words/long-english | 839 | 615.08 ± 0.9% | not timed | not timed | 584.64 ± 0.3% | 35.31 ± 1.2% | not timed | not timed | 614.86 ± 0.2% | | 1.00 | 1.05 | 17.42 |
| 09-aws-keys/full | 0 | 496.87 ± 0.2% | not timed | not timed | 549.41 ± 1.2% | 67.34 ± 0.2% | not timed | not timed | 489.03 ± 0.3% | | 1.02 | 0.90 | 7.38 |
| 09-aws-keys/quick | 0 | 1151.69 ± 0.3% | not timed | not timed | 960.59 ± 0.4% | 409.44 ± 0.6% | not timed | not timed | 1152.02 ± 0.2% | | 1.00 | 1.20 | 2.81 |
| 10-bounded-repeat/letters-en | 1833 | 680.26 ± 0.4% | not timed | not timed | 557.72 ± 0.3% | 22.85 ± 0.7% | not timed | not timed | 680.37 ± 2.3% | | 1.00 | 1.22 | 29.77 |
| 10-bounded-repeat/letters-ru | 3475 | 527.28 ± 1.0% | not timed | not timed | 484.07 ± 0.6% | 25.20 ± 11.4% | not timed | not timed | 527.13 ± 4.6% | | 1.00 | 1.09 | 20.92 |
| 10-bounded-repeat/context | 53 | 90.53 ± 2.3% | not timed | not timed | 70.27 ± 0.9% | 22.20 ± 3.8% | not timed | not timed | 90.81 ± 1.5% | | 1.00 | 1.29 | 4.08 |
| 10-bounded-repeat/capitals | 11 | 641.68 ± 8.2% | not timed | not timed | 604.87 ± 0.3% | 40.37 ± 0.7% | not timed | not timed | 640.64 ± 8.2% | | 1.00 | 1.06 | 15.90 |
| 11-unstructured-to-json/extract | 600 | 48.94 ± 0.5% | not timed | not timed | 80.16 ± 2.6% | 51.92 ± 1.9% | not timed | not timed | 48.65 ± 0.7% | | 1.01 | 0.61 | 0.94 |
| 12-dictionary/single | 1 | 514.52 ± 0.2% | not timed | not timed | 480.89 ± 0.3% | 0.39 ± 2.4% | not timed | not timed | 515.12 ± 0.3% | | 1.00 | 1.07 | 1311.68 |
| 14-quadratic/1x | 100 | 26.16 ± 1.2% | not timed | not timed | 12.18 ± 0.5% | 1.00 ± 3.2% | not timed | not timed | 26.20 ± 0.5% | | 1.00 | 2.15 | 26.04 |
| 14-quadratic/2x | 200 | 19.81 ± 4.3% | not timed | not timed | 6.12 ± 4.8% | 0.54 ± 14.7% | not timed | not timed | 19.86 ± 2.6% | | 1.00 | 3.24 | 36.49 |
| 14-quadratic/10x | 1000 | 6.86 ± 4.3% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 1.5% | not timed | not timed | 6.87 ± 5.2% | | 1.00 | 5.64 | 59.38 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.38 ± 0.5% | not timed | not timed | 0.48 ± 0.3% | 0.64 ± 10.4% | not timed | not timed | 1.39 ± 0.8% | | 1.00 | 2.90 | 2.16 |
| 04-ruff-noqa/compile-real | 1 | 124.26 ± 1.1% | not timed | not timed | 17.42 ± 1.8% | 169.64 ± 6.4% | not timed | not timed | 124.25 ± 0.4% | | 1.00 | 7.13 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 16.61 ± 0.3% | not timed | not timed | 3.00 ± 0.4% | 7.85 ± 1.6% | not timed | not timed | 16.63 ± 0.5% | | 1.00 | 5.54 | 2.12 |
| 07-unicode-character-data/compile | 1 | 124.87 ± 0.8% | not timed | not timed | 30.55 ± 1.0% | 44.11 ± 2.5% | not timed | not timed | 125.04 ± 0.6% | | 1.00 | 4.09 | 2.83 |
| 09-aws-keys/compile-full | 1 | 54.91 ± 1.1% | not timed | not timed | 10.03 ± 0.7% | 27.96 ± 0.6% | not timed | not timed | 55.43 ± 0.3% | | 0.99 | 5.48 | 1.96 |
| 09-aws-keys/compile-quick | 1 | 196.10 ± 1.5% | not timed | not timed | 58.77 ± 1.7% | 156.91 ± 3.6% | not timed | not timed | 196.01 ± 0.5% | | 1.00 | 3.34 | 1.25 |
| 10-bounded-repeat/compile-context | 1 | 59.58 ± 1.2% | not timed | not timed | 14.51 ± 0.9% | 19.84 ± 4.9% | not timed | not timed | 60.16 ± 0.3% | | 0.99 | 4.11 | 3.00 |
| 10-bounded-repeat/compile-capitals | 1 | 92.04 ± 1.4% | not timed | not timed | 10.62 ± 0.5% | 29.60 ± 1.2% | not timed | not timed | 93.39 ± 0.7% | | 0.99 | 8.67 | 3.11 |
| 11-unstructured-to-json/compile | 1 | 190.39 ± 0.3% | not timed | not timed | 48.43 ± 0.4% | 80.37 ± 2.2% | not timed | not timed | 190.53 ± 0.6% | | 1.00 | 3.93 | 2.37 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.6% | not timed | not timed | 0.09 ± 49.1% | 0.11 ± 18.3% | not timed | not timed | 0.35 ± 11.7% | | 1.00 | 4.03 | 3.10 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.16 ± 0.6% | not timed | not timed | 6.96 ± 0.6% | 0.59 ± 9.9% | not timed | not timed | 7.18 ± 0.7% | | 1.00 | 1.03 | 12.12 |
| dictionary/search/english-10 | 690 | 1.31 ± 0.5% | not timed | not timed | 153.13 ± 4.7% | 0.01 ± 0.3% | not timed | not timed | 1.31 ± 1.0% | | 1.00 | 0.0085 | 191.51 |
| dictionary/search/english-15 | 15 | 513.75 ± 0.3% | not timed | not timed | 481.57 ± 0.2% | 0.37 ± 0.8% | not timed | not timed | 513.39 ± 0.4% | | 1.00 | 1.07 | 1383.05 |
| folly/awyer-inn-busted | 1 | 4250.00 ± 0.3% | not timed | not timed | 130.64 ± 0.3% | 48.19 ± 2.3% | not timed | not timed | 4246.71 ± 1.6% | | 1.00 | 32.53 | 88.18 |
| folly/literal-never-match-rare | 0 | 67609.27 ± 1.3% | not timed | not timed | 46381.93 ± 0.5% | 69180.29 ± 0.6% | not timed | not timed | 67663.41 ± 0.6% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 26427.32 ± 5.7% | not timed | not timed | 46081.67 ± 0.3% | 2590.03 ± 0.4% | not timed | not timed | 26892.07 ± 6.1% | | 0.98 | 0.57 | 10.20 |
| folly/literal-never-match-tricksy | 1 | 3986.21 ± 2.5% | not timed | not timed | 6139.11 ± 0.6% | 1723.56 ± 0.2% | not timed | not timed | 3983.36 ± 0.2% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1429.76 ± 14.5% | not timed | not timed | 973.84 ± 1.1% | 380.11 ± 21.5% | not timed | not timed | 1435.06 ± 2.1% | | 1.00 | 1.47 | 3.76 |
| grep/long-words-ascii | 5073 | 504.33 ± 0.3% | not timed | not timed | 497.65 ± 0.3% | 52.06 ± 7.1% | not timed | not timed | 504.60 ± 0.2% | | 1.00 | 1.01 | 9.69 |
| imported/leipzig/twain | 811 | 57924.86 ± 4.3% | not timed | not timed | 43547.44 ± 0.8% | 12978.30 ± 10.9% | not timed | not timed | 57815.43 ± 2.1% | | 1.00 | 1.33 | 4.46 |
| imported/leipzig/twain-insensitive | 965 | 15532.77 ± 0.4% | not timed | not timed | 13497.64 ± 0.2% | 42.69 ± 2.9% | not timed | not timed | 15547.85 ± 0.5% | | 1.00 | 1.15 | 363.85 |
| imported/leipzig/shing | 1540 | 630.15 ± 0.1% | not timed | not timed | 22203.34 ± 1.0% | 36.07 ± 0.7% | not timed | not timed | 630.20 ± 0.6% | | 1.00 | 0.0284 | 17.47 |
| imported/leipzig/huck-saw | 262 | 24956.71 ± 0.3% | not timed | not timed | 18760.95 ± 0.9% | 35.57 ± 1.4% | not timed | not timed | 24952.31 ± 0.5% | | 1.00 | 1.33 | 701.61 |
| imported/leipzig/word-ending-nn | 262 | 609.92 ± 0.2% | not timed | not timed | 603.58 ± 0.5% | 24.99 ± 0.2% | not timed | not timed | 609.56 ± 0.3% | | 1.00 | 1.01 | 24.40 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11914.83 ± 5.6% | not timed | not timed | 3957.43 ± 0.7% | 11.70 ± 1.3% | not timed | not timed | 11908.57 ± 0.6% | | 1.00 | 3.01 | 1018.12 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 21255.45 ± 21.3% | not timed | not timed | 17632.27 ± 0.5% | 19.06 ± 1.7% | not timed | not timed | 21237.80 ± 24.8% | | 1.00 | 1.21 | 1115.18 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5553.15 ± 0.3% | not timed | not timed | 792.20 ± 0.3% | 11.50 ± 0.5% | not timed | not timed | 5551.85 ± 0.2% | | 1.00 | 7.01 | 482.88 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 608.02 ± 0.3% | not timed | not timed | 602.44 ± 0.1% | 8.95 ± 0.7% | not timed | not timed | 608.32 ± 0.2% | | 1.00 | 1.01 | 67.93 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.26 ± 0.3% | not timed | not timed | 602.72 ± 0.2% | 7.95 ± 1.5% | not timed | not timed | 608.62 ± 0.1% | | 1.00 | 1.01 | 76.54 |
| imported/leipzig/tom-river | 2 | 12892.06 ± 0.6% | not timed | not timed | 13442.14 ± 0.4% | 34.85 ± 2.2% | not timed | not timed | 12923.80 ± 0.7% | | 1.00 | 0.96 | 369.93 |
| imported/leipzig/ing | 78424 | 599.39 ± 0.4% | not timed | not timed | 561.36 ± 0.2% | 28.76 ± 5.5% | not timed | not timed | 599.20 ± 0.6% | | 1.00 | 1.07 | 20.84 |
| imported/leipzig/ing-whitespace | 55248 | 734.86 ± 0.8% | not timed | not timed | 2127.95 ± 0.1% | 21.13 ± 2.3% | not timed | not timed | 740.56 ± 0.3% | | 0.99 | 0.35 | 34.77 |
| imported/leipzig/awyer-inn | 209 | 770.84 ± 1.4% | not timed | not timed | 13726.49 ± 0.7% | 22.10 ± 0.3% | not timed | not timed | 771.40 ± 1.2% | | 1.00 | 0.0562 | 34.88 |
| imported/leipzig/quotes-bounded | 8886 | 1849.52 ± 0.2% | not timed | not timed | 3288.55 ± 0.3% | 40.81 ± 3.5% | not timed | not timed | 1850.26 ± 0.2% | | 1.00 | 0.56 | 45.33 |
| imported/leipzig/non-ascii-alternate | 2 | 40635.75 ± 0.5% | not timed | not timed | 19590.18 ± 1.0% | 56.43 ± 2.2% | not timed | not timed | 40666.94 ± 0.3% | | 1.00 | 2.07 | 720.10 |
| imported/leipzig/math-symbols | 69 | 2430.20 ± 0.2% | not timed | not timed | 604.54 ± 0.3% | 39.34 ± 3.3% | not timed | not timed | 2431.06 ± 13.3% | | 1.00 | 4.02 | 61.77 |
| imported/leipzig/bounded-strings-ending-z | 0 | 609.39 ± 1.1% | not timed | not timed | 605.21 ± 0.3% | 18.96 ± 0.2% | not timed | not timed | 609.90 ± 0.9% | | 1.00 | 1.01 | 32.14 |
| imported/lh3lh3-reb/uri | 17549 | 726.52 ± 1.9% | not timed | not timed | 1126.19 ± 8.9% | 31.05 ± 2.9% | not timed | not timed | 723.64 ± 0.8% | | 1.00 | 0.65 | 23.40 |
| imported/lh3lh3-reb/email | 15057 | 800.22 ± 0.5% | not timed | not timed | 1122.98 ± 0.8% | 33.37 ± 2.9% | not timed | not timed | 801.56 ± 1.9% | | 1.00 | 0.71 | 23.98 |
| imported/lh3lh3-reb/date | 668 | 930.83 ± 0.3% | not timed | not timed | 1011.01 ± 0.7% | 52.24 ± 6.7% | not timed | not timed | 930.00 ± 0.5% | | 1.00 | 0.92 | 17.82 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 746.24 ± 0.3% | not timed | not timed | 443.36 ± 0.5% | 16.69 ± 1.8% | not timed | not timed | 745.92 ± 0.8% | | 1.00 | 1.68 | 44.71 |
| imported/mariomka/email | 92 | 704.33 ± 0.2% | not timed | not timed | 60074.25 ± 1.2% | 35.79 ± 0.6% | not timed | not timed | 704.62 ± 0.2% | | 1.00 | 0.0117 | 19.68 |
| imported/mariomka/uri | 5301 | 602.72 ± 0.1% | not timed | not timed | 7911.49 ± 0.9% | 35.74 ± 0.4% | not timed | not timed | 602.82 ± 0.4% | | 1.00 | 0.0762 | 16.86 |
| imported/mariomka/ip | 5 | 1813.24 ± 3.6% | not timed | not timed | 2334.11 ± 0.7% | 22.98 ± 0.4% | not timed | not timed | 1816.83 ± 3.6% | | 1.00 | 0.78 | 78.92 |
| imported/rsc/no-exponential | 0 | 827.86 ± 1.0% | not timed | not timed | 378.28 ± 1.4% | 26.16 ± 1.2% | not timed | not timed | 829.42 ± 0.6% | | 1.00 | 2.19 | 31.64 |
| imported/rsc/literal | 1 | 874.90 ± 2.8% | not timed | not timed | 2235.52 ± 0.3% | 244.99 ± 11.4% | not timed | not timed | 879.79 ± 5.8% | | 0.99 | 0.39 | 3.57 |
| imported/rsc/not-literal | 2 | 809.17 ± 7.7% | not timed | not timed | 847.14 ± 0.6% | 54.14 ± 2.1% | not timed | not timed | 810.57 ± 0.6% | | 1.00 | 0.96 | 14.95 |
| imported/rsc/match-class | 1 | 1440.61 ± 0.6% | not timed | not timed | 1821.68 ± 0.7% | 68.20 ± 7.2% | not timed | not timed | 1420.33 ± 2.3% | | 1.01 | 0.79 | 21.12 |
| imported/rsc/match-class-in-range | 1 | 1434.47 ± 1.3% | not timed | not timed | 3421.97 ± 1.3% | 70.43 ± 6.5% | not timed | not timed | 1430.15 ± 1.8% | | 1.00 | 0.42 | 20.37 |
| imported/rsc/match-class-unicode | 1 | 539.73 ± 0.8% | not timed | not timed | 498.56 ± 0.1% | 82.59 ± 0.2% | not timed | not timed | 542.89 ± 0.5% | | 0.99 | 1.08 | 6.54 |
| imported/rsc/anchored-literal-short-non-match | 0 | 637.96 ± 1.0% | not timed | not timed | 1148.06 ± 0.4% | 343.99 ± 1.1% | not timed | not timed | 637.35 ± 0.5% | | 1.00 | 0.56 | 1.85 |
| imported/rsc/anchored-literal-long-non-match | 0 | 10273.20 ± 1.1% | not timed | not timed | 17128.92 ± 0.2% | 5181.34 ± 2.1% | not timed | not timed | 10246.25 ± 0.9% | | 1.00 | 0.60 | 1.98 |
| imported/rsc/anchored-literal-short-match | 4 | 518.21 ± 6.4% | not timed | not timed | 573.99 ± 0.8% | 105.44 ± 10.6% | not timed | not timed | 521.23 ± 0.3% | | 0.99 | 0.90 | 4.91 |
| imported/rsc/anchored-literal-long-match | 4 | 2781.94 ± 2.2% | not timed | not timed | 8512.81 ± 0.5% | 1614.99 ± 5.1% | not timed | not timed | 2789.46 ± 1.9% | | 1.00 | 0.33 | 1.72 |
| imported/rsc/one-pass-short | 17 | 361.77 ± 11.6% | not timed | not timed | 260.80 ± 1.4% | 37.82 ± 18.2% | not timed | not timed | 365.64 ± 1.4% | | 0.99 | 1.39 | 9.56 |
| imported/rsc/one-pass-short-not | 17 | 247.30 ± 3.1% | not timed | not timed | 270.42 ± 0.5% | 35.35 ± 12.1% | not timed | not timed | 246.95 ± 5.0% | | 1.00 | 0.91 | 7.00 |
| imported/rsc/one-pass-long-prefix | 26 | 252.37 ± 1.7% | not timed | not timed | 320.74 ± 1.1% | 127.28 ± 17.2% | not timed | not timed | 249.22 ± 2.5% | | 1.01 | 0.79 | 1.98 |
| imported/rsc/one-pass-long-prefix-not | 26 | 367.30 ± 10.7% | not timed | not timed | 322.78 ± 0.3% | 82.23 ± 12.7% | not timed | not timed | 375.38 ± 1.9% | | 0.98 | 1.14 | 4.47 |
| imported/rsc/long-needle1 | 31 | 68303.48 ± 0.3% | not timed | not timed | 45848.30 ± 0.5% | 4.06 ± 0.5% | not timed | not timed | 68199.00 ± 0.3% | | 1.00 | 1.49 | 16836.70 |
| imported/rsc/long-needle2 | 31 | 67152.62 ± 0.3% | not timed | not timed | 227.23 ± 0.2% | 4.05 ± 2.2% | not timed | not timed | 67086.98 ± 1.3% | | 1.00 | 295.53 | 16589.51 |
| imported/rsc/easy0-32 | 26 | 1257.02 ± 1.3% | not timed | not timed | 1917.62 ± 0.6% | 163.91 ± 18.1% | not timed | not timed | 1272.54 ± 1.2% | | 0.99 | 0.66 | 7.67 |
| imported/rsc/easy0-1k | 26 | 21441.73 ± 1.2% | not timed | not timed | 20394.79 ± 0.5% | 2494.00 ± 12.4% | not timed | not timed | 21405.30 ± 2.7% | | 1.00 | 1.05 | 8.60 |
| imported/rsc/easy0-32k | 26 | 64693.02 ± 1.7% | not timed | not timed | 43757.62 ± 14.9% | 23476.89 ± 14.6% | not timed | not timed | 64732.15 ± 1.2% | | 1.00 | 1.48 | 2.76 |
| imported/rsc/easy0-1mb | 26 | 65438.13 ± 0.7% | not timed | not timed | 45970.90 ± 0.3% | 67490.97 ± 1.6% | not timed | not timed | 65384.67 ± 0.6% | | 1.00 | 1.42 | 0.97 |
| imported/rsc/easy1-32 | 19 | 380.91 ± 2.3% | not timed | not timed | 764.91 ± 0.8% | 147.43 ± 23.1% | not timed | not timed | 386.53 ± 1.2% | | 0.99 | 0.50 | 2.58 |
| imported/rsc/easy1-1k | 19 | 582.64 ± 2.7% | not timed | not timed | 15599.78 ± 3.7% | 2621.26 ± 9.7% | not timed | not timed | 589.32 ± 2.2% | | 0.99 | 0.0373 | 0.22 |
| imported/rsc/easy1-32k | 19 | 608.53 ± 0.3% | not timed | not timed | 481789.17 ± 8.0% | 29456.87 ± 22.0% | not timed | not timed | 608.47 ± 2.3% | | 1.00 | 0.0013 | 0.0207 |
| imported/rsc/easy1-1mb | 19 | 609.58 ± 0.7% | not timed | not timed | 15726641.99 ± 0.4% | 68456.89 ± 0.3% | not timed | not timed | 609.67 ± 0.1% | | 1.00 | 0.0000 | 0.0089 |
| imported/rsc/medium-32 | 27 | 478.15 ± 0.3% | not timed | not timed | 740.62 ± 1.2% | 75.13 ± 29.2% | not timed | not timed | 474.27 ± 10.9% | | 1.01 | 0.65 | 6.36 |
| imported/rsc/medium-1k | 27 | 7825.11 ± 10.4% | not timed | not timed | 13220.69 ± 0.8% | 82.18 ± 1.1% | not timed | not timed | 7836.33 ± 0.8% | | 1.00 | 0.59 | 95.22 |
| imported/rsc/medium-32k | 27 | 53111.81 ± 11.9% | not timed | not timed | 390467.40 ± 1.3% | 53.61 ± 1.5% | not timed | not timed | 46235.86 ± 0.4% | | 1.15 | 0.14 | 990.76 |
| imported/rsc/medium-1mb | 27 | 64684.45 ± 1.1% | not timed | not timed | 13238275.53 ± 0.7% | 54.22 ± 1.6% | not timed | not timed | 64656.93 ± 0.4% | | 1.00 | 0.0049 | 1193.04 |
| imported/rsc/hard-32 | 58 | 268.89 ± 2.0% | not timed | not timed | 391.66 ± 1.5% | 53.31 ± 6.1% | not timed | not timed | 268.88 ± 0.7% | | 1.00 | 0.69 | 5.04 |
| imported/rsc/hard-1k | 27 | 588.61 ± 0.3% | not timed | not timed | 13063.63 ± 0.4% | 45.00 ± 0.9% | not timed | not timed | 589.13 ± 0.1% | | 1.00 | 0.0451 | 13.08 |
| imported/rsc/hard-32k | 27 | 608.66 ± 0.2% | not timed | not timed | 410254.18 ± 0.3% | 33.03 ± 0.4% | not timed | not timed | 608.88 ± 0.5% | | 1.00 | 0.0015 | 18.43 |
| imported/rsc/hard-1mb | 51 | 609.32 ± 0.1% | not timed | not timed | 7850850.24 ± 0.4% | 33.19 ± 7.8% | not timed | not timed | 609.65 ± 0.1% | | 1.00 | 0.0001 | 18.36 |
| imported/rsc/reallyhard0-32 | 58 | 270.40 ± 0.3% | not timed | not timed | 245.91 ± 0.6% | 53.20 ± 18.4% | not timed | not timed | 267.08 ± 0.5% | | 1.01 | 1.10 | 5.08 |
| imported/rsc/reallyhard0-1k | 27 | 588.57 ± 0.2% | not timed | not timed | 581.06 ± 1.0% | 45.04 ± 0.6% | not timed | not timed | 588.87 ± 0.2% | | 1.00 | 1.01 | 13.07 |
| imported/rsc/reallyhard0-32k | 27 | 608.40 ± 0.2% | not timed | not timed | 602.26 ± 0.6% | 32.75 ± 0.9% | not timed | not timed | 608.33 ± 0.1% | | 1.00 | 1.01 | 18.58 |
| imported/rsc/reallyhard0-1mb | 51 | 609.80 ± 0.2% | not timed | not timed | 604.06 ± 0.4% | 33.20 ± 0.4% | not timed | not timed | 610.18 ± 0.2% | | 1.00 | 1.01 | 18.37 |
| imported/rsc/reallyreallyhard0-32 | 47 | 309.54 ± 1.4% | not timed | not timed | 209.06 ± 0.5% | 59.57 ± 14.8% | not timed | not timed | 310.85 ± 0.3% | | 1.00 | 1.48 | 5.20 |
| imported/rsc/reallyreallyhard0-1k | 16 | 871.92 ± 0.9% | not timed | not timed | 7736.19 ± 0.4% | 36.99 ± 0.3% | not timed | not timed | 873.50 ± 0.9% | | 1.00 | 0.11 | 23.57 |
| imported/rsc/reallyreallyhard0-32k | 16 | 635.16 ± 4.9% | not timed | not timed | 36624.60 ± 0.5% | 26.76 ± 0.2% | not timed | not timed | 637.69 ± 5.1% | | 1.00 | 0.0173 | 23.73 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 609.55 ± 0.5% | not timed | not timed | 45451.39 ± 1.9% | 27.16 ± 0.2% | not timed | not timed | 609.91 ± 0.1% | | 1.00 | 0.0134 | 22.44 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 301.14 ± 4.0% | not timed | not timed | 216.91 ± 11.7% | 66.02 ± 7.8% | not timed | not timed | 303.43 ± 2.1% | | 0.99 | 1.39 | 4.56 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 849.31 ± 2.1% | not timed | not timed | 7526.31 ± 0.4% | 37.01 ± 0.5% | not timed | not timed | 850.49 ± 0.8% | | 1.00 | 0.11 | 22.95 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 636.70 ± 4.9% | not timed | not timed | 37191.97 ± 0.7% | 27.10 ± 0.3% | not timed | not timed | 636.92 ± 4.9% | | 1.00 | 0.0171 | 23.49 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 610.18 ± 0.2% | not timed | not timed | 45711.64 ± 0.9% | 27.23 ± 2.4% | not timed | not timed | 610.03 ± 0.1% | | 1.00 | 0.0133 | 22.41 |
| imported/sherlock/name-sherlock | 776 | 50705.01 ± 9.2% | not timed | not timed | 39893.85 ± 16.8% | 12776.96 ± 27.7% | not timed | not timed | 51083.94 ± 1.0% | | 0.99 | 1.27 | 3.97 |
| imported/sherlock/name-holmes | 2766 | 27985.67 ± 1.0% | not timed | not timed | 29852.71 ± 0.8% | 4188.39 ± 24.2% | not timed | not timed | 28077.22 ± 1.3% | | 1.00 | 0.94 | 6.68 |
| imported/sherlock/name-sherlock-holmes | 1365 | 51508.79 ± 1.2% | not timed | not timed | 40117.11 ± 2.4% | 10221.14 ± 22.3% | not timed | not timed | 51460.23 ± 16.7% | | 1.00 | 1.28 | 5.04 |
| imported/sherlock/name-sherlock-casei | 816 | 46631.75 ± 21.3% | not timed | not timed | 11561.82 ± 1.5% | 33.78 ± 1.0% | not timed | not timed | 46578.17 ± 0.2% | | 1.00 | 4.03 | 1380.47 |
| imported/sherlock/name-holmes-casei | 2802 | 22715.87 ± 0.4% | not timed | not timed | 7621.39 ± 0.1% | 44.52 ± 0.9% | not timed | not timed | 22744.17 ± 0.4% | | 1.00 | 2.98 | 510.22 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36811.13 ± 1.2% | not timed | not timed | 11206.80 ± 0.2% | 33.89 ± 0.8% | not timed | not timed | 36781.45 ± 0.2% | | 1.00 | 3.28 | 1086.27 |
| imported/sherlock/name-whitespace | 1461 | 28278.29 ± 1.2% | not timed | not timed | 27851.97 ± 0.6% | 8065.50 ± 51.2% | not timed | not timed | 28441.21 ± 1.4% | | 0.99 | 1.02 | 3.51 |
| imported/sherlock/name-alt1 | 1142 | 28381.63 ± 0.2% | not timed | not timed | 29318.25 ± 0.5% | 5725.32 ± 32.0% | not timed | not timed | 28406.45 ± 1.3% | | 1.00 | 0.97 | 4.96 |
| imported/sherlock/name-alt2 | 3542 | 17010.12 ± 0.3% | not timed | not timed | 10106.98 ± 0.4% | 36.08 ± 1.1% | not timed | not timed | 17044.78 ± 17.8% | | 1.00 | 1.68 | 471.46 |
| imported/sherlock/name-alt3 | 4507 | 11311.12 ± 0.5% | not timed | not timed | 9209.49 ± 13.3% | 10.68 ± 0.7% | not timed | not timed | 11344.78 ± 0.5% | | 1.00 | 1.23 | 1059.02 |
| imported/sherlock/name-alt3-casei | 4593 | 3431.07 ± 2.8% | not timed | not timed | 1309.44 ± 8.1% | 7.27 ± 0.9% | not timed | not timed | 3440.39 ± 7.9% | | 1.00 | 2.62 | 472.09 |
| imported/sherlock/name-alt4 | 3686 | 9222.25 ± 0.3% | not timed | not timed | 8168.36 ± 0.5% | 36.02 ± 0.6% | not timed | not timed | 9233.71 ± 0.7% | | 1.00 | 1.13 | 256.01 |
| imported/sherlock/name-alt4-casei | 4254 | 5163.67 ± 1.1% | not timed | not timed | 4478.81 ± 0.9% | 20.82 ± 0.5% | not timed | not timed | 5178.41 ± 1.1% | | 1.00 | 1.15 | 247.99 |
| imported/sherlock/name-alt5 | 4028 | 14198.54 ± 5.9% | not timed | not timed | 9688.68 ± 0.4% | 24.82 ± 0.9% | not timed | not timed | 14233.85 ± 0.5% | | 1.00 | 1.47 | 571.97 |
| imported/sherlock/name-alt5-casei | 4104 | 6643.10 ± 0.6% | not timed | not timed | 2998.51 ± 2.4% | 15.48 ± 37.8% | not timed | not timed | 6655.15 ± 0.5% | | 1.00 | 2.22 | 429.19 |
| imported/sherlock/no-match-uncommon | 0 | 68455.11 ± 0.3% | not timed | not timed | 57929.25 ± 0.8% | 57630.90 ± 20.6% | not timed | not timed | 68410.21 ± 15.0% | | 1.00 | 1.18 | 1.19 |
| imported/sherlock/no-match-common | 0 | 66912.85 ± 7.1% | not timed | not timed | 57828.40 ± 9.6% | 2144.53 ± 0.3% | not timed | not timed | 66965.94 ± 0.2% | | 1.00 | 1.16 | 31.20 |
| imported/sherlock/no-match-really-common | 0 | 43008.38 ± 22.5% | not timed | not timed | 49714.54 ± 0.1% | 2145.25 ± 3.8% | not timed | not timed | 43056.15 ± 0.5% | | 1.00 | 0.87 | 20.05 |
| imported/sherlock/the-lower | 21654 | 3971.02 ± 2.8% | not timed | not timed | 4535.84 ± 15.7% | 276.09 ± 21.4% | not timed | not timed | 3981.17 ± 5.6% | | 1.00 | 0.88 | 14.38 |
| imported/sherlock/the-upper | 2223 | 20821.90 ± 2.0% | not timed | not timed | 29154.27 ± 0.2% | 3112.56 ± 15.8% | not timed | not timed | 21022.61 ± 1.0% | | 0.99 | 0.71 | 6.69 |
| imported/sherlock/the-casei | 23961 | 3484.50 ± 5.8% | not timed | not timed | 1371.55 ± 4.9% | 36.23 ± 38.6% | not timed | not timed | 3517.29 ± 19.9% | | 0.99 | 2.54 | 96.19 |
| imported/sherlock/everything-greedy | 581881 | 269.46 ± 1.9% | not timed | not timed | 172.65 ± 14.8% | 31.02 ± 24.8% | not timed | not timed | 274.14 ± 0.5% | | 0.98 | 1.56 | 8.69 |
| imported/sherlock/everything-greedy-nl | 594933 | 464.72 ± 0.3% | not timed | not timed | 224.36 ± 0.6% | 34.73 ± 1.9% | not timed | not timed | 464.73 ± 0.2% | | 1.00 | 2.07 | 13.38 |
| imported/sherlock/letters | 447175 | 55.92 ± 7.4% | not timed | not timed | 33.84 ± 0.7% | 6.49 ± 34.3% | not timed | not timed | 56.62 ± 7.3% | | 0.99 | 1.65 | 8.61 |
| imported/sherlock/letters-upper | 14180 | 431.01 ± 1.1% | not timed | not timed | 370.85 ± 0.3% | 31.14 ± 20.0% | not timed | not timed | 431.50 ± 8.2% | | 1.00 | 1.16 | 13.84 |
| imported/sherlock/letters-lower | 432995 | 53.04 ± 0.9% | not timed | not timed | 34.76 ± 2.7% | 6.79 ± 36.6% | not timed | not timed | 57.53 ± 1.6% | | 0.92 | 1.53 | 7.81 |
| imported/sherlock/words | 447639 | 106.28 ± 1.5% | not timed | not timed | 83.90 ± 0.3% | 14.93 ± 9.0% | not timed | not timed | 106.23 ± 0.8% | | 1.00 | 1.27 | 7.12 |
| imported/sherlock/before-holmes | 4073 | 601.05 ± 0.1% | not timed | not timed | 13294.94 ± 0.4% | 25.70 ± 0.3% | not timed | not timed | 600.83 ± 0.7% | | 1.00 | 0.0452 | 23.38 |
| imported/sherlock/before-after-holmes | 2593 | 604.81 ± 0.2% | not timed | not timed | 14965.58 ± 0.5% | 25.89 ± 1.2% | not timed | not timed | 604.26 ± 0.3% | | 1.00 | 0.0404 | 23.36 |
| imported/sherlock/holmes-cochar-watson | 150 | 9999.86 ± 0.4% | not timed | not timed | 7702.95 ± 0.3% | 35.17 ± 2.5% | not timed | not timed | 10053.45 ± 0.5% | | 0.99 | 1.30 | 284.37 |
| imported/sherlock/holmes-coword-watson | 14309 | 1265.19 ± 1.8% | not timed | not timed | 1231.98 ± 1.0% | 7.67 ± 0.4% | not timed | not timed | 1271.55 ± 7.4% | | 0.99 | 1.03 | 164.87 |
| imported/sherlock/quotes | 14437 | 1339.86 ± 0.3% | not timed | not timed | 2269.14 ± 2.5% | 37.72 ± 14.0% | not timed | not timed | 1340.75 ± 0.7% | | 1.00 | 0.59 | 35.52 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 607.91 ± 0.2% | not timed | not timed | 31312.32 ± 2.4% | 40.30 ± 1.0% | not timed | not timed | 607.73 ± 1.7% | | 1.00 | 0.0194 | 15.08 |
| imported/sherlock/word-ending-n | 35297 | 457.02 ± 0.7% | not timed | not timed | 405.05 ± 0.2% | 26.23 ± 29.9% | not timed | not timed | 459.11 ± 1.2% | | 1.00 | 1.13 | 17.42 |
| imported/sherlock/repeated-class-negation | 2130 | 18678.85 ± 7.9% | not timed | not timed | 16555.98 ± 0.3% | 12.46 ± 1.2% | not timed | not timed | 18608.04 ± 0.7% | | 1.00 | 1.13 | 1499.49 |
| imported/sherlock/ing-suffix | 20547 | 559.68 ± 1.0% | not timed | not timed | 511.45 ± 2.6% | 30.99 ± 31.9% | not timed | not timed | 560.47 ± 0.2% | | 1.00 | 1.09 | 18.06 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 586.77 ± 0.3% | not timed | not timed | 2830.55 ± 3.3% | 22.97 ± 0.3% | not timed | not timed | 592.48 ± 0.5% | | 0.99 | 0.21 | 25.54 |
| opt/accelerate/whole-line | 239963 | 504.45 ± 0.4% | not timed | not timed | 414.86 ± 0.3% | 83.90 ± 14.8% | not timed | not timed | 504.00 ± 0.5% | | 1.00 | 1.22 | 6.01 |
| opt/accelerate/non-dna | 16745 | 423.19 ± 1.1% | not timed | not timed | 439.68 ± 0.8% | 25.80 ± 14.9% | not timed | not timed | 424.53 ± 0.3% | | 1.00 | 0.96 | 16.41 |
| opt/backtrack/words-english | 40536 | 144.16 ± 2.5% | not timed | not timed | 110.43 ± 2.4% | 21.71 ± 8.8% | not timed | not timed | 143.92 ± 11.7% | | 1.00 | 1.31 | 6.64 |
| opt/fixed-length/too-small-ascii | 0 | 390.40 ± 17.2% | not timed | not timed | 708.56 ± 0.4% | 122.97 ± 3.4% | not timed | not timed | 390.53 ± 1.9% | | 1.00 | 0.55 | 3.17 |
| opt/fixed-length/too-big-ascii | 0 | 817.96 ± 0.4% | not timed | not timed | 6328.37 ± 0.9% | 151.56 ± 0.1% | not timed | not timed | 821.09 ± 0.6% | | 1.00 | 0.13 | 5.40 |
| opt/fixed-length/go33484-1 | 0 | 65.50 ± 0.2% | not timed | not timed | 1216351.52 ± 1.1% | 89815.77 ± 2.1% | not timed | not timed | 65.43 ± 0.2% | | 1.00 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 4244.15 ± 0.1% | not timed | not timed | 1216942.46 ± 0.4% | 29741.78 ± 0.2% | not timed | not timed | 4244.22 ± 0.2% | | 1.00 | 0.0035 | 0.14 |
| opt/fixed-length/go33484-3 | 0 | 1658.46 ± 0.1% | not timed | not timed | 121442.50 ± 0.4% | 894.72 ± 0.3% | not timed | not timed | 1649.10 ± 6.4% | | 1.01 | 0.0137 | 1.85 |
| opt/literal-alt/one-pattern | 1 | 581.58 ± 3.8% | not timed | not timed | 571.06 ± 0.6% | 0.39 ± 10.7% | not timed | not timed | 571.18 ± 0.3% | | 1.02 | 1.02 | 1489.78 |
| opt/onepass/fn-predicate | 916 | 432.45 ± 1.2% | not timed | not timed | 394.70 ± 0.4% | 205.15 ± 14.5% | not timed | not timed | 430.40 ± 1.2% | | 1.00 | 1.10 | 2.11 |
| opt/onepass/first-three-words-english | 35128 | 158.02 ± 2.1% | not timed | not timed | 215.92 ± 0.5% | 87.23 ± 14.0% | not timed | not timed | 157.37 ± 2.2% | | 1.00 | 0.73 | 1.81 |
| opt/prefilter/literal-english | 1 | 67960.10 ± 0.4% | not timed | not timed | 46383.07 ± 1.3% | 26676.43 ± 0.9% | not timed | not timed | 67940.73 ± 0.4% | | 1.00 | 1.47 | 2.55 |
| opt/prefilter/literal-casei-english | 1 | 47408.60 ± 0.4% | not timed | not timed | 14321.78 ± 0.2% | 34.16 ± 1.6% | not timed | not timed | 47227.73 ± 27.2% | | 1.00 | 3.31 | 1387.64 |
| opt/prefilter/literal-russian | 1 | 68717.63 ± 0.4% | not timed | not timed | 46405.50 ± 0.2% | 1809.48 ± 0.5% | not timed | not timed | 68781.75 ± 0.2% | | 1.00 | 1.48 | 37.98 |
| opt/prefilter/literal-casei-russian | 1 | 26119.71 ± 0.3% | not timed | not timed | 10987.61 ± 0.6% | 37.79 ± 0.5% | not timed | not timed | 26085.74 ± 1.6% | | 1.00 | 2.38 | 691.15 |
| opt/prefilter/rust-functions | 948 | 14712.34 ± 1.6% | not timed | not timed | 12901.94 ± 1.4% | 1961.61 ± 0.1% | not timed | not timed | 14764.98 ± 1.1% | | 1.00 | 1.14 | 7.50 |
| opt/reverse-anchored/word-end | 1 | 4299.00 ± 0.4% | not timed | not timed | 27282694.21 ± 0.6% | 55.95 ± 1.1% | not timed | not timed | 4298.44 ± 1.0% | | 1.00 | 0.0002 | 76.83 |
| opt/reverse-inner/holmes | 2593 | 604.73 ± 0.2% | not timed | not timed | 14870.48 ± 1.8% | 25.66 ± 0.3% | not timed | not timed | 604.91 ± 0.1% | | 1.00 | 0.0407 | 23.57 |
| opt/reverse-inner/email | 47 | 1039.23 ± 0.1% | not timed | not timed | 92139.50 ± 0.2% | 35.50 ± 0.5% | not timed | not timed | 1038.69 ± 0.7% | | 1.00 | 0.0113 | 29.28 |
| opt/reverse-inner/factored-prefix | 3542 | 596.10 ± 0.2% | not timed | not timed | 586.32 ± 0.2% | 13.71 ± 15.7% | not timed | not timed | 596.52 ± 1.6% | | 1.00 | 1.02 | 43.46 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4169.97 ± 4.0% | not timed | not timed | 603.98 ± 2.3% | 85.28 ± 7.2% | not timed | not timed | 4175.37 ± 2.1% | | 1.00 | 6.90 | 48.90 |
| opt/reverse-inner/no-quadratic-forward | 0 | 708.80 ± 3.5% | not timed | not timed | 280.22 ± 0.2% | 26.55 ± 1.1% | not timed | not timed | 698.00 ± 5.9% | | 1.02 | 2.53 | 26.70 |
| opt/reverse-suffix/holmes | 4073 | 601.30 ± 0.2% | not timed | not timed | 13307.55 ± 16.1% | 25.61 ± 0.3% | not timed | not timed | 601.92 ± 0.5% | | 1.00 | 0.0452 | 23.48 |
| opt/reverse-suffix/no-quadratic | 0 | 4173.29 ± 0.7% | not timed | not timed | 603.80 ± 0.6% | 84.74 ± 1.3% | not timed | not timed | 4178.58 ± 0.1% | | 1.00 | 6.91 | 49.25 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 142.31 ± 2.7% | not timed | not timed | 178.81 ± 0.0% | 16.82 ± 14.6% | not timed | not timed | 141.84 ± 8.9% | | 1.00 | 0.80 | 8.46 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 139.51 ± 3.1% | not timed | not timed | 182.04 ± 0.6% | 16.77 ± 17.8% | not timed | not timed | 142.65 ± 0.5% | | 0.98 | 0.77 | 8.32 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.31 ± 1.3% | not timed | not timed | 0.48 ± 0.6% | 120.83 ± 0.1% | not timed | not timed | 0.31 ± 0.6% | | 1.00 | 0.66 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 293.42 ± 0.3% | not timed | not timed | 281.96 ± 0.1% | 109.27 ± 1.9% | not timed | not timed | 279.77 ± 9.8% | | 1.05 | 1.04 | 2.69 |
| reported/i13-subset-regex/original-ascii | 4094 | 11920.98 ± 0.1% | not timed | not timed | 3963.09 ± 0.4% | 12.21 ± 1.0% | not timed | not timed | 11899.01 ± 0.9% | | 1.00 | 3.01 | 976.58 |
| reported/i13-subset-regex/original-unicode | 4094 | 11883.91 ± 0.4% | not timed | not timed | 210.56 ± 1.4% | 12.19 ± 1.1% | not timed | not timed | 11867.33 ± 0.4% | | 1.00 | 56.44 | 974.86 |
| reported/i13-subset-regex/big-ascii | 1955 | 11172.54 ± 0.4% | not timed | not timed | 54.33 ± 1.8% | 10.55 ± 2.9% | not timed | not timed | 11149.88 ± 0.3% | | 1.00 | 205.65 | 1058.58 |
| reported/i13-subset-regex/big-unicode | 1955 | 11106.16 ± 0.4% | not timed | not timed | 9.49 ± 55.6% | 10.55 ± 2.1% | not timed | not timed | 11084.59 ± 0.9% | | 1.00 | 1170.07 | 1053.00 |
| reported/i13-subset-regex/huge-ascii | 55 | 10305.41 ± 0.4% | not timed | not timed | 9.07 ± 0.6% | 9.54 ± 1.7% | not timed | not timed | 10278.55 ± 0.4% | | 1.00 | 1135.90 | 1080.17 |
| reported/i13-subset-regex/huge-unicode | 55 | 10211.71 ± 1.2% | not timed | not timed | 8.79 ± 0.5% | 9.52 ± 2.0% | not timed | not timed | 10092.42 ± 1.4% | | 1.01 | 1161.48 | 1072.13 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.16 ± 0.9% | not timed | not timed | 8.99 ± 0.4% | 9.49 ± 1.1% | not timed | not timed | 4.17 ± 0.9% | | 1.00 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.81 ± 0.8% | not timed | not timed | 8.94 ± 0.8% | 9.50 ± 1.0% | not timed | not timed | 5.79 ± 0.7% | | 1.00 | 0.65 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 488.31 ± 0.5% | not timed | not timed | 171.00 ± 0.9% | 7.25 ± 1.6% | not timed | not timed | 496.56 ± 0.4% | | 0.98 | 2.86 | 67.34 |
| reported/i787-keywords/opt-ascii | 5674 | 492.95 ± 0.3% | not timed | not timed | 275.10 ± 1.5% | 12.17 ± 0.4% | not timed | not timed | 496.68 ± 0.4% | | 0.99 | 1.79 | 40.51 |
| slow/quadratic-regex-1x | 100 | 8.23 ± 0.1% | not timed | not timed | 6.02 ± 0.3% | 0.05 ± 0.9% | not timed | not timed | 8.24 ± 0.2% | | 1.00 | 1.37 | 158.29 |
| slow/quadratic-regex-2x | 199 | 3.69 ± 0.3% | not timed | not timed | 3.05 ± 0.2% | 0.01 ± 31.0% | not timed | not timed | 3.69 ± 0.8% | | 1.00 | 1.21 | 278.23 |
| slow/quadratic-haystack-1x | 100 | 26.20 ± 9.1% | not timed | not timed | 12.14 ± 11.2% | 1.00 ± 11.5% | not timed | not timed | 26.19 ± 1.4% | | 1.00 | 2.16 | 26.31 |
| slow/quadratic-haystack-2x | 200 | 19.91 ± 5.3% | not timed | not timed | 6.11 ± 4.5% | 0.55 ± 16.8% | not timed | not timed | 19.96 ± 7.0% | | 1.00 | 3.26 | 35.90 |
| unicode/codepoints/any-one | 1112064 | 338.27 ± 0.3% | not timed | not timed | 240.08 ± 0.4% | 21.25 ± 15.3% | not timed | not timed | 338.58 ± 7.1% | | 1.00 | 1.41 | 15.92 |
| unicode/codepoints/any-all | 4382592 | 265.33 ± 3.4% | not timed | not timed | 260.14 ± 2.3% | 125.85 ± 0.9% | not timed | not timed | 262.44 ± 0.6% | | 1.01 | 1.02 | 2.11 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.92 ± 0.2% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.99 ± 0.1% | not timed | not timed | 603.87 ± 0.2% | 153.23 ± 0.7% | not timed | not timed | 610.22 ± 0.2% | | 1.00 | 1.01 | 3.98 |
| unicode/overlapping-words/ascii | 6156 | 28.44 ± 15.6% | not timed | not timed | 43.30 ± 0.5% | 4.24 ± 7.6% | not timed | not timed | 28.45 ± 7.0% | | 1.00 | 0.66 | 6.71 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 8.8% | not timed | not timed | 3.50 ± 0.4% | 2.94 ± 4.6% | not timed | not timed | 1.49 ± 7.6% | | 0.97 | 0.41 | 0.49 |
| unicode/overlapping-words/russian | 5710 | 1.32 ± 0.9% | not timed | not timed | 3.30 ± 0.2% | 7.26 ± 9.6% | not timed | not timed | 1.34 ± 12.5% | | 0.99 | 0.40 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 113.97 ± 1.3% | not timed | not timed | 75.72 ± 2.0% | 14.31 ± 21.9% | not timed | not timed | 114.58 ± 1.6% | | 0.99 | 1.51 | 7.96 |
| unicode/word/boundary-long-english | 3466 | 610.22 ± 0.4% | not timed | not timed | 593.47 ± 0.1% | 35.40 ± 0.3% | not timed | not timed | 610.65 ± 0.8% | | 1.00 | 1.03 | 17.24 |
| unicode/word/around-holmes-english | 27 | 609.23 ± 0.8% | not timed | not timed | 44842.07 ± 0.7% | 23.86 ± 12.4% | not timed | not timed | 609.58 ± 0.1% | | 1.00 | 0.0136 | 25.54 |
| wild/bibleref/long | 874 | 569.88 ± 0.2% | not timed | not timed | 574.16 ± 0.2% | 7.94 ± 0.6% | not timed | not timed | 570.87 ± 2.7% | | 1.00 | 0.99 | 71.76 |
| wild/bibleref/short | 30 | 22.52 ± 9.6% | not timed | not timed | 32.81 ± 0.3% | 15.34 ± 22.9% | not timed | not timed | 23.26 ± 1.2% | | 0.97 | 0.69 | 1.47 |
| wild/bibleref/line | 874 | 481.27 ± 7.0% | not timed | not timed | 281.22 ± 0.3% | 9.94 ± 0.4% | not timed | not timed | 485.98 ± 6.8% | | 0.99 | 1.71 | 48.40 |
| wild/caddy/caddy | 6 | 456.27 ± 2.4% | not timed | not timed | 292.94 ± 0.6% | 75.88 ± 14.8% | not timed | not timed | 455.64 ± 7.4% | | 1.00 | 1.56 | 6.01 |
| wild/dot-star-capture/rust-src-tools | 6 | 1447.16 ± 1.2% | not timed | not timed | 404.61 ± 0.2% | 15.75 ± 3.1% | not timed | not timed | 1457.08 ± 0.3% | | 0.99 | 3.58 | 91.90 |
| wild/ruff/noqa | 84 | 490.87 ± 0.3% | not timed | not timed | 513.94 ± 1.0% | 21.57 ± 2.9% | not timed | not timed | 491.12 ± 0.4% | | 1.00 | 0.96 | 22.76 |
| wild/ruff/unnecessary-coding-comment | 16 | 535.54 ± 5.4% | not timed | not timed | 724.10 ± 6.7% | 137.94 ± 13.0% | not timed | not timed | 535.98 ± 0.7% | | 1.00 | 0.74 | 3.88 |
| wild/ruff/string-quote-prefix | 2972 | 493.56 ± 2.2% | not timed | not timed | 493.60 ± 2.0% | 321.16 ± 29.2% | not timed | not timed | 494.42 ± 13.4% | | 1.00 | 1.00 | 1.54 |
| wild/ruff/space-around-operator | 1224378 | 237.10 ± 1.8% | not timed | not timed | 226.98 ± 0.0% | 19.19 ± 2.9% | not timed | not timed | 236.57 ± 1.5% | | 1.00 | 1.04 | 12.35 |
| wild/ruff/shebang | 282 | 486.80 ± 1.5% | not timed | not timed | 395.10 ± 0.2% | 114.57 ± 12.3% | not timed | not timed | 487.90 ± 0.7% | | 1.00 | 1.23 | 4.25 |
| wild/rustsec-cargo-audit/original-unix | 471 | 21691.75 ± 1.0% | not timed | not timed | 23829.75 ± 0.4% | 8588.74 ± 3.7% | not timed | not timed | 21843.86 ± 19.7% | | 0.99 | 0.91 | 2.53 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20028.96 ± 0.7% | not timed | not timed | 22399.03 ± 29.5% | 8417.25 ± 2.3% | not timed | not timed | 20094.35 ± 0.5% | | 1.00 | 0.89 | 2.38 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22832.22 ± 21.8% | not timed | not timed | 23223.51 ± 0.2% | 8671.02 ± 2.3% | not timed | not timed | 22905.28 ± 1.8% | | 1.00 | 0.98 | 2.63 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 17707.72 ± 2.6% | not timed | not timed | 23339.84 ± 0.6% | 8492.41 ± 24.4% | not timed | not timed | 17823.27 ± 1.8% | | 0.99 | 0.76 | 2.09 |
| wild/url/search | 234965 | 128.64 ± 12.6% | not timed | not timed | 61.11 ± 2.5% | 2.46 ± 1.5% | not timed | not timed | 128.97 ± 11.7% | | 1.00 | 2.11 | 52.27 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 69.6% | not timed | not timed | 0.01 ± 2.7% | 0.01 ± 19.2% | not timed | not timed | 0.03 ± 12.6% | | 1.01 | 2.52 | 4.13 |
| dictionary/compile/english-15 | 1 | 0.34 ± 1.8% | not timed | not timed | 0.10 ± 4.0% | 0.11 ± 25.8% | not timed | not timed | 0.35 ± 0.8% | | 0.99 | 3.61 | 3.02 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.29 ± 1.4% | not timed | not timed | 0.02 ± 3.2% | 37.01 ± 5.2% | not timed | not timed | 0.30 ± 1.3% | | 1.00 | 12.88 | 0.0080 |
| reported/i1095-word-repetition/ascii-compile | 1 | 42.63 ± 9.4% | not timed | not timed | 16.81 ± 1.0% | 57.36 ± 17.9% | not timed | not timed | 42.31 ± 1.3% | | 1.01 | 2.54 | 0.74 |
| reported/i787-keywords/compile | 1 | 39.76 ± 18.4% | not timed | not timed | 2.38 ± 1.3% | 20.63 ± 26.1% | not timed | not timed | 40.68 ± 24.2% | | 0.98 | 16.74 | 1.93 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 381.21 ± 3.2% | not timed | not timed | 147.15 ± 0.6% | 659.99 ± 26.0% | not timed | not timed | 385.61 ± 3.7% | | 0.99 | 2.59 | 0.58 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.13 ± 3.4% | not timed | not timed | 5.53 ± 3.0% | 48.55 ± 5.9% | not timed | not timed | 55.01 ± 10.2% | | 0.97 | 9.61 | 1.09 |
| unicode/compile/one-letter | 53 | 7.03 ± 13.5% | not timed | not timed | 5.85 ± 1.4% | 64.26 ± 3.8% | not timed | not timed | 7.00 ± 14.9% | | 1.00 | 1.20 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.19 ± 18.0% | not timed | not timed | 0.13 ± 1.4% | 66.09 ± 7.5% | not timed | not timed | 1.24 ± 14.0% | | 0.96 | 9.52 | 0.0181 |
| unicode/compile/fifty-letters-ascii | 1 | 202.88 ± 11.2% | not timed | not timed | 70.32 ± 0.5% | 212.74 ± 15.4% | not timed | not timed | 203.18 ± 8.8% | | 1.00 | 2.89 | 0.95 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 452.52 ± 4.3% | not timed | not timed | 51.39 ± 1.4% | 746.12 ± 14.9% | not timed | not timed | 450.23 ± 13.5% | | 1.01 | 8.80 | 0.61 |
| unicode/compile/match-every-line-ascii | 4 | 696.53 ± 10.0% | not timed | not timed | 167.10 ± 2.9% | 739.07 ± 15.8% | not timed | not timed | 712.40 ± 12.2% | | 0.98 | 4.17 | 0.94 |
| unicode/compile/negated-class-matches-codepoint | 1 | 365.02 ± 2.0% | not timed | not timed | 56.31 ± 1.1% | 1380.80 ± 6.8% | not timed | not timed | 372.69 ± 2.9% | | 0.98 | 6.48 | 0.26 |
| wild/bibleref/compile | 3 | 6.24 ± 4.5% | not timed | not timed | 2.45 ± 0.4% | 33.59 ± 8.0% | not timed | not timed | 6.28 ± 3.5% | | 0.99 | 2.55 | 0.19 |
| wild/url/compile | 1 | 0.72 ± 19.3% | not timed | not timed | 0.21 ± 0.9% | 0.47 ± 26.9% | not timed | not timed | 0.72 ± 1.1% | | 1.00 | 3.53 | 1.53 |

