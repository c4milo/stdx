# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391485948 |
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
| literal: a word | 217 | 66006.32 ± 1.8% | 6405.53 ± 12.4% | 46.25 ± 8.7% | 53583.18 ± 7.1% | 15935.99 ± 7.2% | 16.60 ± 1.5% | 153.39 ± 5.4% | 66059.58 ± 6.0% | 10.30 | 1.00 | 1.23 | 4.14 |
| literal: a word that is not there | 0 | 86470.88 ± 5.5% | 6076.92 ± 5.8% | 47.05 ± 6.8% | 68277.69 ± 12.4% | 57607.91 ± 8.0% | 15.79 ± 6.0% | 146.30 ± 6.1% | 85574.80 ± 6.6% | 14.23 | 1.01 | 1.27 | 1.50 |
| literal: one of four words | 661 | 20436.65 ± 5.6% | 2398.77 ± 7.4% | 25.35 ± 41.6% | 14734.45 ± 66.4% | 39.91 ± 17.0% | 5.23 ± 5.0% | 13.26 ± 7.8% | 20327.29 ± 6.2% | 8.52 | 1.01 | 1.39 | 512.03 |
| literal: a word in any case | 217 | 58766.80 ± 3.0% | 2481.34 ± 26.6% | 31.35 ± 6.8% | 14103.57 ± 0.3% | 72.09 ± 2.3% | refused | differs | 59314.50 ± 3.9% | 23.68 | 0.99 | 4.17 | 815.20 |
| literal: an href attribute | 33 | 50544.42 ± 2.8% | 709.08 ± 2.3% | 35.88 ± 1.3% | 44829.20 ± 1.7% | 3403.53 ± 1.1% | 11.01 ± 1.2% | 123.01 ± 3.5% | 50219.98 ± 2.1% | 71.28 | 1.01 | 1.13 | 14.85 |
| literal: a word, second text | 123 | 64431.25 ± 2.5% | 4314.64 ± 0.8% | 42.86 ± 1.3% | 47763.81 ± 2.9% | 14667.09 ± 7.7% | 20.19 ± 1.1% | 121.76 ± 1.0% | 64104.13 ± 2.7% | 14.93 | 1.01 | 1.35 | 4.39 |
| class: two capitalized words | 1331 | 1074.52 ± 4.0% | 703.25 ± 13.6% | 39.77 ± 2.7% | 666.77 ± 5.0% | 59.68 ± 6.6% | 13.32 ± 4.7% | 101.01 ± 5.1% | 1065.83 ± 1.7% | 1.53 | 1.01 | 1.61 | 18.00 |
| class: a word that ends in ing | 3399 | 673.35 ± 2.0% | 672.02 ± 6.4% | 26.70 ± 10.1% | 641.72 ± 6.4% | 45.00 ± 22.0% | 7.94 ± 6.6% | 29.14 ± 2.5% | 680.41 ± 8.7% | 1.00 | 0.99 | 1.05 | 14.96 |
| class: a word in capitals | 2332 | 1609.09 ± 7.4% | 729.04 ± 5.9% | 42.25 ± 7.3% | 695.28 ± 8.4% | 65.50 ± 9.5% | 16.77 ± 6.5% | 133.69 ± 5.8% | 1651.25 ± 9.6% | 2.21 | 0.97 | 2.31 | 24.57 |
| class: a number | 8288 | 2712.11 ± 5.3% | 990.29 ± 5.9% | 45.14 ± 6.3% | 2431.41 ± 5.9% | 59.07 ± 23.1% | 0.45 ± 3.7% | 96.26 ± 5.3% | 2624.21 ± 5.7% | 2.74 | 1.03 | 1.12 | 45.91 |
| class: two capitalized words, second text | 5359 | 621.85 ± 5.3% | 621.24 ± 5.3% | 36.92 ± 4.5% | 573.06 ± 4.2% | 48.55 ± 20.3% | 17.85 ± 1.7% | 95.90 ± 3.6% | 596.26 ± 6.5% | 1.00 | 1.04 | 1.09 | 12.81 |
| other: a word between two words | 6104 | 1106.05 ± 63.1% | 711.51 ± 4.6% | 36.69 ± 5.5% | 987.80 ± 3.8% | 171.81 ± 7.0% | 10.65 ± 3.8% | 111.73 ± 12.3% | 1131.99 ± 1.4% | 1.55 | 0.98 | 1.12 | 6.44 |
| other: a number before a unit, second text | 1481 | 12645.35 ± 8.0% | 1401.57 ± 7.2% | 39.43 ± 6.7% | 10693.60 ± 8.6% | 58.11 ± 5.9% | 18.10 ± 8.5% | 100.82 ± 9.0% | 12628.22 ± 7.7% | 9.02 | 1.00 | 1.18 | 217.62 |
| other: a heading's start tag | 110 | 31779.12 ± 59.0% | 911.38 ± 14.3% | 42.50 ± 33.1% | 3419.81 ± 6.8% | 2566.92 ± 7.6% | 14.10 ± 5.7% | 155.83 ± 11.2% | 32480.26 ± 95.1% | 34.87 | 0.98 | 9.29 | 12.38 |
| other: a whole word | 217 | 40717.30 ± 4.8% | 717.56 ± 4.9% | 44.72 ± 4.0% | 36095.55 ± 6.1% | 73.58 ± 47.7% | 13.20 ± 31.8% | 84.42 ± 18.4% | 40847.27 ± 6.2% | 56.74 | 1.00 | 1.13 | 553.35 |
| other: a line's first word, second text | 3716 | 3509.46 ± 8.3% | 729.73 ± 7.9% | 49.16 ± 5.8% | 3561.74 ± 3.9% | 103.16 ± 6.4% | refused | refused | 3587.39 ± 5.1% | 4.81 | 0.98 | 0.99 | 34.02 |
| other: fourteen octets before an x | 87 | 51017.32 ± 9.8% | 343.70 ± 8.3% | 9.07 ± 7.2% | 4764.18 ± 8.5% | 14.08 ± 6.7% | differs | 25.12 ± 9.7% | 51447.72 ± 4.2% | 148.44 | 0.99 | 10.71 | 3623.20 |
| other: a Greek word | 21815 | 622.77 ± 2.8% | 491.41 ± 4.5% | 50.16 ± 8.6% | 375.72 ± 3.4% | 61.84 ± 6.8% | differs | refused | 621.88 ± 1.1% | 1.27 | 1.00 | 1.66 | 10.07 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.75 ± 6.6% | 26.73 ± 4.8% | 1.53 ± 3.8% | 23.48 ± 3.8% | 3.62 ± 5.4% | differs | 5.73 ± 6.0% | 26.69 ± 5.9% | 1.00 | 1.00 | 1.14 | 7.38 |
| a UUID | 32895 | 28.61 ± 1.3% | 29.34 ± 4.3% | 1.01 ± 6.5% | 18.32 ± 1.4% | 3.54 ± 2.3% | 0.73 ± 2.4% | 4.48 ± 3.4% | 29.03 ± 19.0% | 0.98 | 0.99 | 1.56 | 8.08 |
| an IPv4 address | 33176 | 46.56 ± 21.3% | 46.68 ± 18.1% | 3.20 ± 2.3% | 34.85 ± 6.6% | 9.00 ± 4.0% | differs | 5.78 ± 5.5% | 46.39 ± 1.8% | 1.00 | 1.00 | 1.34 | 5.18 |
| a date and time | 32954 | 43.57 ± 6.4% | 43.95 ± 10.1% | 2.41 ± 39.4% | 26.47 ± 7.5% | 10.73 ± 6.3% | 1.31 ± 11.4% | 10.88 ± 3.2% | 46.17 ± 7.7% | 0.99 | 0.94 | 1.65 | 4.06 |
| a field path | 32606 | 30.30 ± 4.0% | 30.17 ± 11.8% | 1.69 ± 55.9% | 27.22 ± 45.7% | 4.62 ± 4.7% | differs | 4.09 ± 3.1% | 30.40 ± 3.8% | 1.00 | 1.00 | 1.11 | 6.55 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.15 ± 7.0% | 15.40 ± 8.4% | 15.47 ± 7.0% | 17.21 ± 9.1% | 7.51 ± 6.3% | 1.02 ± 9.3% | none | 14.91 ± 7.3% | 0.98 | 1.02 | 0.88 | 2.02 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 349.15 ± 13.3% | 350.74 ± 6.8% | 409.82 ± 5.9% | 129.64 ± 5.9% | 318.74 ± 7.5% | 842.95 ± 7.0% | 5316.15 ± 7.5% | 347.67 ± 12.5% | 1.00 | 1.00 | 2.69 | 1.10 |
| a UUID | 62 | 235.66 ± 1.8% | 235.47 ± 4.7% | 258.82 ± 2.6% | 74.84 ± 2.4% | 158.52 ± 4.0% | 303.88 ± 2.5% | 7014.56 ± 2.1% | 231.62 ± 5.8% | 1.00 | 1.02 | 3.15 | 1.49 |
| an IPv4 address | 29 | 693.68 ± 2.5% | 707.20 ± 2.9% | 945.49 ± 2.5% | 119.60 ± 3.5% | 205.46 ± 1.6% | 562.00 ± 7.0% | 12915.91 ± 14.0% | 693.86 ± 5.2% | 0.98 | 1.00 | 5.80 | 3.38 |
| a date and time | 56 | 509.26 ± 8.6% | 513.77 ± 19.5% | 631.05 ± 9.7% | 115.36 ± 2.9% | 231.15 ± 10.2% | 579.21 ± 9.1% | 8099.78 ± 11.0% | 497.79 ± 9.3% | 0.99 | 1.02 | 4.41 | 2.20 |
| a field path | 39 | 363.46 ± 3.3% | 362.61 ± 19.3% | 411.20 ± 22.0% | 124.72 ± 9.5% | 303.29 ± 4.9% | 894.52 ± 6.6% | 7266.19 ± 9.3% | 378.18 ± 7.8% | 1.00 | 0.96 | 2.91 | 1.20 |
| literal: a word | 7 | 1070.56 ± 7.3% | 1169.93 ± 6.4% | 2050.93 ± 9.3% | 863.65 ± 7.5% | 1025.29 ± 9.0% | 1784.77 ± 5.6% | 46705.96 ± 4.9% | 1056.83 ± 5.2% | 0.92 | 1.01 | 1.24 | 1.04 |
| literal: a word that is not there | 8 | 1010.16 ± 4.2% | 1098.74 ± 2.0% | 1822.33 ± 3.5% | 781.41 ± 2.9% | 961.47 ± 6.9% | 1704.83 ± 3.1% | 45690.34 ± 6.9% | 1008.45 ± 3.2% | 0.92 | 1.00 | 1.29 | 1.05 |
| literal: one of four words | 26 | 395.58 ± 4.7% | 628.32 ± 4.2% | 809.99 ± 2.5% | 65.63 ± 1.5% | 382.23 ± 1.3% | 654.02 ± 5.0% | 23254.38 ± 58.8% | 394.68 ± 3.7% | 0.63 | 1.00 | 6.03 | 1.03 |
| literal: a word in any case | 11 | 741.67 ± 3.6% | 785.28 ± 3.3% | 1116.48 ± 1.9% | 22.61 ± 6.0% | 1064.55 ± 2.1% | refused | 36955.05 ± 4.0% | 738.75 ± 2.6% | 0.94 | 1.00 | 32.80 | 0.70 |
| literal: an href attribute | 12 | 548.36 ± 4.3% | 572.97 ± 7.5% | 739.06 ± 3.0% | 60.76 ± 1.1% | 745.54 ± 18.0% | 1443.84 ± 2.5% | 33698.73 ± 1.0% | 549.88 ± 2.7% | 0.96 | 1.00 | 9.02 | 0.74 |
| literal: a word, second text | 10 | 942.50 ± 2.7% | 1035.24 ± 1.6% | 1646.36 ± 4.5% | 714.27 ± 10.0% | 864.15 ± 3.7% | 1513.32 ± 35.8% | 45097.80 ± 29.0% | 931.38 ± 2.2% | 0.91 | 1.01 | 1.32 | 1.09 |
| class: two capitalized words | 23 | 754.32 ± 6.2% | 820.42 ± 4.9% | 1166.15 ± 5.2% | 159.31 ± 5.2% | 794.17 ± 10.5% | 1404.53 ± 5.5% | 9423.01 ± 5.8% | 757.26 ± 5.5% | 0.92 | 1.00 | 4.73 | 0.95 |
| class: a word that ends in ing | 9 | 930.20 ± 6.5% | 1060.59 ± 17.9% | 1837.94 ± 61.3% | 203.23 ± 68.8% | 1090.88 ± 6.9% | 2136.17 ± 60.0% | 24367.97 ± 7.9% | 941.03 ± 29.9% | 0.88 | 0.99 | 4.58 | 0.85 |
| class: a word in capitals | 16 | 873.93 ± 1.5% | 955.93 ± 7.2% | 1497.34 ± 3.2% | 219.40 ± 4.0% | 1221.26 ± 5.2% | 2020.15 ± 4.7% | 12397.56 ± 9.0% | 879.39 ± 3.9% | 0.91 | 0.99 | 3.98 | 0.72 |
| class: a number | 6 | 1092.96 ± 11.0% | 1216.00 ± 6.3% | 2206.01 ± 4.2% | 60.10 ± 5.1% | 2250.67 ± 6.1% | 3769.14 ± 1.5% | 35705.97 ± 3.4% | 1067.78 ± 5.0% | 0.90 | 1.02 | 18.19 | 0.49 |
| class: two capitalized words, second text | 23 | 745.70 ± 4.8% | 806.47 ± 11.6% | 1142.39 ± 9.8% | 157.48 ± 7.2% | 792.81 ± 5.1% | 1326.44 ± 6.5% | 9297.66 ± 5.4% | 744.65 ± 6.3% | 0.92 | 1.00 | 4.74 | 0.94 |
| other: a word between two words | 13 | 893.80 ± 1.7% | 940.79 ± 1.7% | 1418.49 ± 3.3% | 206.46 ± 5.5% | 757.97 ± 29.3% | 1520.59 ± 6.2% | 21801.69 ± 1.5% | 893.68 ± 2.8% | 0.95 | 1.00 | 4.33 | 1.18 |
| other: a number before a unit, second text | 15 | 653.17 ± 4.3% | 722.19 ± 27.6% | 1010.93 ± 2.5% | 54.97 ± 4.3% | 940.72 ± 6.9% | 1635.62 ± 3.4% | 24326.15 ± 3.8% | 646.63 ± 2.6% | 0.90 | 1.01 | 11.88 | 0.69 |
| other: a heading's start tag | 13 | 568.97 ± 2.8% | 582.40 ± 4.1% | 764.15 ± 2.0% | 57.18 ± 2.7% | 915.07 ± 2.9% | 1576.34 ± 3.3% | 28738.79 ± 2.0% | 573.48 ± 3.5% | 0.98 | 0.99 | 9.95 | 0.62 |
| other: a whole word | 11 | 941.61 ± 3.0% | 1010.35 ± 5.1% | 1594.82 ± 5.5% | 187.73 ± 9.6% | 885.19 ± 21.0% | 1578.20 ± 8.8% | 42746.40 ± 2.5% | 945.82 ± 4.9% | 0.93 | 1.00 | 5.02 | 1.06 |
| other: a line's first word, second text | 17 | 929.59 ± 3.3% | 994.42 ± 2.0% | 1523.83 ± 9.0% | 206.59 ± 4.9% | 1017.10 ± 16.5% | refused | refused | 921.45 ± 7.3% | 0.93 | 1.01 | 4.50 | 0.91 |
| other: fourteen octets before an x | 16 | 185.25 ± 4.8% | 254.94 ± 16.1% | 281.66 ± 34.8% | 22.98 ± 35.9% | 714.88 ± 49.3% | 779.71 ± 0.9% | 21639.42 ± 2.3% | 181.59 ± 4.3% | 0.73 | 1.02 | 8.06 | 0.26 |
| other: a Greek word | 8 | 724.74 ± 3.8% | 976.03 ± 4.6% | 1608.34 ± 5.8% | 77.18 ± 2.1% | 2186.68 ± 5.3% | 3521.76 ± 3.9% | refused | 734.69 ± 4.0% | 0.74 | 0.99 | 9.39 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 46533.92 ± 5.5% | not timed | not timed | 45515.05 ± 4.2% | 3662.31 ± 13.5% | not timed | not timed | 46618.12 ± 1.8% | | 1.00 | 1.02 | 12.71 |
| 01-literal/sherlock-casei-en | 522 | 42322.09 ± 3.8% | not timed | not timed | 11776.78 ± 4.6% | 52.98 ± 7.4% | not timed | not timed | 41894.29 ± 3.8% | | 1.01 | 3.59 | 798.85 |
| 01-literal/sherlock-ru | 724 | 47985.60 ± 1.6% | not timed | not timed | 44781.11 ± 5.4% | 2457.05 ± 4.4% | not timed | not timed | 47803.22 ± 1.5% | | 1.00 | 1.07 | 19.53 |
| 01-literal/sherlock-casei-ru | 746 | 15367.65 ± 6.3% | not timed | not timed | 9536.82 ± 5.2% | 58.61 ± 2.0% | not timed | not timed | 14961.13 ± 55.5% | | 1.03 | 1.61 | 262.19 |
| 01-literal/sherlock-zh | 30 | 83034.38 ± 0.7% | not timed | not timed | 61377.15 ± 3.1% | 2188.03 ± 2.8% | not timed | not timed | 83103.46 ± 1.4% | | 1.00 | 1.35 | 37.95 |
| 02-literal-alternate/sherlock-en | 714 | 17016.88 ± 5.2% | not timed | not timed | 13839.04 ± 10.3% | 28.76 ± 2.8% | not timed | not timed | 17131.80 ± 1.9% | | 0.99 | 1.23 | 591.58 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3067.65 ± 11.3% | not timed | not timed | 3038.63 ± 7.5% | 18.61 ± 5.6% | not timed | not timed | 3169.91 ± 5.5% | | 0.97 | 1.01 | 164.81 |
| 02-literal-alternate/sherlock-ru | 899 | 13002.44 ± 6.3% | not timed | not timed | 7391.05 ± 4.6% | 37.46 ± 7.3% | not timed | not timed | 13043.17 ± 0.7% | | 1.00 | 1.76 | 347.10 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2860.06 ± 2.7% | not timed | not timed | 1466.66 ± 2.4% | 16.18 ± 33.7% | not timed | not timed | 2835.98 ± 23.2% | | 1.01 | 1.95 | 176.72 |
| 02-literal-alternate/sherlock-zh | 207 | 24319.86 ± 3.1% | not timed | not timed | 16363.93 ± 6.4% | 54.61 ± 12.4% | not timed | not timed | 24358.60 ± 7.7% | | 1.00 | 1.49 | 445.35 |
| 03-date/ascii | 111817 | 160.27 ± 2.5% | not timed | not timed | 130.14 ± 2.5% | 0.31 ± 3.1% | not timed | not timed | 161.12 ± 4.1% | | 0.99 | 1.23 | 518.57 |
| 04-ruff-noqa/real | 84 | 637.24 ± 5.3% | not timed | not timed | 653.66 ± 7.2% | 22.93 ± 9.7% | not timed | not timed | 638.71 ± 8.3% | | 1.00 | 0.97 | 27.80 |
| 04-ruff-noqa/tweaked | 44 | 815.77 ± 2.1% | not timed | not timed | 665.53 ± 3.9% | 457.96 ± 12.6% | not timed | not timed | 823.73 ± 1.8% | | 0.99 | 1.23 | 1.78 |
| 05-lexer-veryl/single | 124800 | 7.06 ± 14.3% | not timed | not timed | 7.65 ± 6.8% | 0.35 ± 8.5% | not timed | not timed | 7.29 ± 13.6% | | 0.97 | 0.92 | 20.24 |
| 06-cloud-flare-redos/original | 107 | 551.57 ± 6.9% | not timed | not timed | 295.29 ± 8.1% | 40.34 ± 5.5% | not timed | not timed | 553.72 ± 5.9% | | 1.00 | 1.87 | 13.67 |
| 06-cloud-flare-redos/simplified-short | 102 | 560.18 ± 0.4% | not timed | not timed | 312.49 ± 4.1% | 43.58 ± 5.0% | not timed | not timed | 560.61 ± 1.0% | | 1.00 | 1.79 | 12.86 |
| 06-cloud-flare-redos/simplified-long | 10000 | 675.53 ± 5.6% | not timed | not timed | 335.37 ± 5.1% | 47.48 ± 3.5% | not timed | not timed | 676.88 ± 5.2% | | 1.00 | 2.01 | 14.23 |
| 07-unicode-character-data/parse-line | 558784 | 346.81 ± 6.4% | not timed | not timed | 266.76 ± 1.4% | 66.70 ± 5.4% | not timed | not timed | 353.78 ± 3.2% | | 0.98 | 1.30 | 5.20 |
| 08-words/all-english | 56691 | 141.20 ± 3.7% | not timed | not timed | 108.19 ± 12.7% | 18.60 ± 19.5% | not timed | not timed | 140.97 ± 0.7% | | 1.00 | 1.31 | 7.59 |
| 08-words/long-english | 839 | 734.90 ± 5.0% | not timed | not timed | 701.80 ± 38.1% | 45.43 ± 9.3% | not timed | not timed | 729.09 ± 9.7% | | 1.01 | 1.05 | 16.18 |
| 09-aws-keys/full | 0 | 673.84 ± 4.4% | not timed | not timed | 677.02 ± 4.2% | 93.53 ± 0.9% | not timed | not timed | 678.59 ± 3.6% | | 0.99 | 1.00 | 7.20 |
| 09-aws-keys/quick | 0 | 1468.03 ± 4.4% | not timed | not timed | 1228.75 ± 3.8% | 535.55 ± 15.7% | not timed | not timed | 1465.80 ± 12.7% | | 1.00 | 1.19 | 2.74 |
| 10-bounded-repeat/letters-en | 1833 | 835.70 ± 3.4% | not timed | not timed | 729.26 ± 8.4% | 29.07 ± 18.5% | not timed | not timed | 830.94 ± 5.2% | | 1.01 | 1.15 | 28.74 |
| 10-bounded-repeat/letters-ru | 3475 | 708.87 ± 2.6% | not timed | not timed | 647.68 ± 1.5% | 28.58 ± 5.8% | not timed | not timed | 707.79 ± 1.3% | | 1.00 | 1.09 | 24.80 |
| 10-bounded-repeat/context | 53 | 122.78 ± 4.8% | not timed | not timed | 94.24 ± 5.5% | 29.85 ± 5.6% | not timed | not timed | 121.05 ± 4.9% | | 1.01 | 1.30 | 4.11 |
| 10-bounded-repeat/capitals | 11 | 788.25 ± 7.7% | not timed | not timed | 738.62 ± 4.2% | 53.06 ± 4.0% | not timed | not timed | 781.47 ± 12.6% | | 1.01 | 1.07 | 14.86 |
| 11-unstructured-to-json/extract | 600 | 78.18 ± 1.7% | not timed | not timed | 108.80 ± 1.2% | 77.59 ± 2.0% | not timed | not timed | 78.15 ± 2.6% | | 1.00 | 0.72 | 1.01 |
| 12-dictionary/single | 1 | 656.28 ± 3.1% | not timed | not timed | 620.04 ± 17.0% | 0.65 ± 5.8% | not timed | not timed | 647.13 ± 13.0% | | 1.01 | 1.06 | 1015.71 |
| 14-quadratic/1x | 100 | 40.02 ± 25.1% | not timed | not timed | 16.87 ± 55.2% | 1.43 ± 65.6% | not timed | not timed | 39.63 ± 73.2% | | 1.01 | 2.37 | 27.99 |
| 14-quadratic/2x | 200 | 31.85 ± 5.9% | not timed | not timed | 8.12 ± 6.9% | 0.78 ± 6.2% | not timed | not timed | 32.15 ± 4.4% | | 0.99 | 3.92 | 40.94 |
| 14-quadratic/10x | 1000 | 10.83 ± 11.2% | not timed | not timed | 1.47 ± 3.6% | 0.17 ± 5.4% | not timed | not timed | 11.02 ± 42.4% | | 0.98 | 7.37 | 62.75 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.92 ± 4.1% | not timed | not timed | 0.54 ± 5.7% | 0.83 ± 4.2% | not timed | not timed | 1.94 ± 4.1% | | 0.99 | 3.58 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 185.87 ± 5.5% | not timed | not timed | 20.86 ± 2.7% | 221.06 ± 4.4% | not timed | not timed | 179.26 ± 7.3% | | 1.04 | 8.91 | 0.84 |
| 05-lexer-veryl/compile-single | 1 | 22.27 ± 9.9% | not timed | not timed | 3.81 ± 1.4% | 10.41 ± 6.5% | not timed | not timed | 22.36 ± 2.2% | | 1.00 | 5.84 | 2.14 |
| 07-unicode-character-data/compile | 1 | 172.53 ± 3.3% | not timed | not timed | 38.00 ± 2.6% | 55.65 ± 4.2% | not timed | not timed | 172.54 ± 3.2% | | 1.00 | 4.54 | 3.10 |
| 09-aws-keys/compile-full | 1 | 73.86 ± 1.9% | not timed | not timed | 12.27 ± 0.9% | 34.50 ± 4.5% | not timed | not timed | 74.10 ± 32.4% | | 1.00 | 6.02 | 2.14 |
| 09-aws-keys/compile-quick | 1 | 278.34 ± 1.4% | not timed | not timed | 76.02 ± 3.3% | 202.13 ± 3.5% | not timed | not timed | 281.62 ± 4.8% | | 0.99 | 3.66 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 85.38 ± 5.1% | not timed | not timed | 17.30 ± 5.6% | 24.82 ± 19.6% | not timed | not timed | 84.32 ± 4.0% | | 1.01 | 4.93 | 3.44 |
| 10-bounded-repeat/compile-capitals | 1 | 123.71 ± 59.9% | not timed | not timed | 12.35 ± 9.5% | 36.05 ± 3.8% | not timed | not timed | 126.47 ± 5.7% | | 0.98 | 10.01 | 3.43 |
| 11-unstructured-to-json/compile | 1 | 272.62 ± 2.0% | not timed | not timed | 62.00 ± 2.9% | 105.23 ± 7.8% | not timed | not timed | 274.57 ± 3.4% | | 0.99 | 4.40 | 2.59 |
| 12-dictionary/compile-single | 1 | 0.44 ± 4.4% | not timed | not timed | 0.09 ± 53.6% | 0.14 ± 16.9% | not timed | not timed | 0.45 ± 4.8% | | 0.99 | 4.93 | 3.24 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.75 ± 8.8% | not timed | not timed | 9.77 ± 3.8% | 0.86 ± 27.4% | not timed | not timed | 10.73 ± 5.8% | | 1.00 | 1.10 | 12.56 |
| dictionary/search/english-10 | 690 | 1.76 ± 6.1% | not timed | not timed | 229.32 ± 9.2% | 0.01 ± 1.5% | not timed | not timed | 1.82 ± 7.6% | | 0.97 | 0.0077 | 176.50 |
| dictionary/search/english-15 | 15 | 649.60 ± 4.2% | not timed | not timed | 625.76 ± 4.6% | 0.58 ± 6.7% | not timed | not timed | 662.47 ± 3.4% | | 0.98 | 1.04 | 1122.83 |
| folly/awyer-inn-busted | 1 | 6977.48 ± 16.1% | not timed | not timed | 163.63 ± 2.0% | 70.25 ± 4.1% | not timed | not timed | 6919.57 ± 6.0% | | 1.01 | 42.64 | 99.32 |
| folly/literal-never-match-rare | 0 | 88034.76 ± 5.3% | not timed | not timed | 67540.01 ± 4.1% | 92623.02 ± 16.8% | not timed | not timed | 86818.73 ± 6.0% | | 1.01 | 1.30 | 0.95 |
| folly/literal-never-match-frequent | 0 | 39219.28 ± 25.0% | not timed | not timed | 67784.95 ± 8.8% | 2987.77 ± 6.2% | not timed | not timed | 40588.59 ± 6.3% | | 0.97 | 0.58 | 13.13 |
| folly/literal-never-match-tricksy | 1 | 5285.64 ± 3.8% | not timed | not timed | 8400.33 ± 13.6% | 3842.38 ± 4.0% | not timed | not timed | 5342.83 ± 1.1% | | 0.99 | 0.63 | 1.38 |
| grep/every-line | 239963 | 1774.57 ± 3.2% | not timed | not timed | 1267.61 ± 2.8% | 502.21 ± 15.8% | not timed | not timed | 1781.84 ± 1.3% | | 1.00 | 1.40 | 3.53 |
| grep/long-words-ascii | 5073 | 673.40 ± 2.8% | not timed | not timed | 629.88 ± 1.3% | 68.11 ± 18.7% | not timed | not timed | 680.99 ± 4.1% | | 0.99 | 1.07 | 9.89 |
| imported/leipzig/twain | 811 | 70890.68 ± 13.5% | not timed | not timed | 59097.49 ± 18.7% | 15381.82 ± 12.5% | not timed | not timed | 69636.40 ± 10.1% | | 1.02 | 1.20 | 4.61 |
| imported/leipzig/twain-insensitive | 965 | 18802.02 ± 2.2% | not timed | not timed | 17204.32 ± 4.8% | 63.95 ± 6.9% | not timed | not timed | 18896.68 ± 3.9% | | 0.99 | 1.09 | 294.01 |
| imported/leipzig/shing | 1540 | 764.49 ± 7.1% | not timed | not timed | 28858.28 ± 3.7% | 53.28 ± 4.2% | not timed | not timed | 769.95 ± 33.2% | | 0.99 | 0.0265 | 14.35 |
| imported/leipzig/huck-saw | 262 | 34038.18 ± 4.9% | not timed | not timed | 22963.09 ± 52.2% | 53.42 ± 7.3% | not timed | not timed | 33969.69 ± 4.9% | | 1.00 | 1.48 | 637.17 |
| imported/leipzig/word-ending-nn | 262 | 743.66 ± 5.7% | not timed | not timed | 742.85 ± 4.9% | 40.99 ± 3.7% | not timed | not timed | 741.16 ± 5.7% | | 1.00 | 1.00 | 18.14 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 15678.99 ± 2.5% | not timed | not timed | 5597.59 ± 15.8% | 15.84 ± 9.0% | not timed | not timed | 15675.90 ± 3.7% | | 1.00 | 2.80 | 990.03 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 28383.74 ± 6.5% | not timed | not timed | 21825.38 ± 4.1% | 29.00 ± 3.4% | not timed | not timed | 28063.85 ± 3.7% | | 1.01 | 1.30 | 978.89 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6826.23 ± 4.3% | not timed | not timed | 1176.50 ± 4.8% | 18.00 ± 3.3% | not timed | not timed | 6787.43 ± 10.9% | | 1.01 | 5.80 | 379.25 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 715.92 ± 75.5% | not timed | not timed | 706.63 ± 27.9% | 18.57 ± 3.2% | not timed | not timed | 714.36 ± 2.8% | | 1.00 | 1.01 | 38.56 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 731.39 ± 6.1% | not timed | not timed | 715.31 ± 7.6% | 15.87 ± 4.1% | not timed | not timed | 736.94 ± 5.8% | | 0.99 | 1.02 | 46.07 |
| imported/leipzig/tom-river | 2 | 15973.46 ± 14.5% | not timed | not timed | 16703.56 ± 19.2% | 51.81 ± 14.4% | not timed | not timed | 15932.50 ± 12.1% | | 1.00 | 0.96 | 308.32 |
| imported/leipzig/ing | 78424 | 717.27 ± 5.3% | not timed | not timed | 683.30 ± 3.6% | 43.48 ± 7.4% | not timed | not timed | 722.37 ± 4.0% | | 0.99 | 1.05 | 16.50 |
| imported/leipzig/ing-whitespace | 55248 | 908.11 ± 3.7% | not timed | not timed | 2874.76 ± 5.7% | 32.41 ± 7.0% | not timed | not timed | 903.28 ± 11.3% | | 1.01 | 0.32 | 28.02 |
| imported/leipzig/awyer-inn | 209 | 901.82 ± 5.4% | not timed | not timed | 17143.85 ± 3.8% | 32.97 ± 9.3% | not timed | not timed | 909.15 ± 3.5% | | 0.99 | 0.0526 | 27.35 |
| imported/leipzig/quotes-bounded | 8886 | 2449.02 ± 4.7% | not timed | not timed | 3837.08 ± 10.8% | 57.27 ± 8.2% | not timed | not timed | 2480.89 ± 5.4% | | 0.99 | 0.64 | 42.76 |
| imported/leipzig/non-ascii-alternate | 2 | 56226.60 ± 6.3% | not timed | not timed | 24069.46 ± 1.3% | 80.80 ± 3.0% | not timed | not timed | 56708.21 ± 7.1% | | 0.99 | 2.34 | 695.83 |
| imported/leipzig/math-symbols | 69 | 4124.04 ± 4.3% | not timed | not timed | 729.24 ± 4.1% | 55.16 ± 1.0% | not timed | not timed | 4233.48 ± 3.5% | | 0.97 | 5.66 | 74.76 |
| imported/leipzig/bounded-strings-ending-z | 0 | 711.19 ± 1.7% | not timed | not timed | 711.75 ± 3.8% | 36.93 ± 1.0% | not timed | not timed | 709.93 ± 2.2% | | 1.00 | 1.00 | 19.26 |
| imported/lh3lh3-reb/uri | 17549 | 898.52 ± 2.2% | not timed | not timed | 1496.66 ± 3.9% | 40.75 ± 5.4% | not timed | not timed | 896.72 ± 5.5% | | 1.00 | 0.60 | 22.05 |
| imported/lh3lh3-reb/email | 15057 | 973.62 ± 4.2% | not timed | not timed | 1437.55 ± 6.9% | 43.55 ± 6.3% | not timed | not timed | 998.00 ± 2.7% | | 0.98 | 0.68 | 22.36 |
| imported/lh3lh3-reb/date | 668 | 1143.87 ± 3.6% | not timed | not timed | 1339.38 ± 4.8% | 72.48 ± 5.9% | not timed | not timed | 1132.96 ± 4.3% | | 1.01 | 0.85 | 15.78 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 962.80 ± 8.5% | not timed | not timed | 553.95 ± 1.8% | 21.89 ± 9.9% | not timed | not timed | 937.36 ± 2.0% | | 1.03 | 1.74 | 43.99 |
| imported/mariomka/email | 92 | 841.86 ± 4.8% | not timed | not timed | 74848.21 ± 5.1% | 50.09 ± 5.4% | not timed | not timed | 865.37 ± 4.9% | | 0.97 | 0.0112 | 16.81 |
| imported/mariomka/uri | 5301 | 744.87 ± 2.3% | not timed | not timed | 9706.74 ± 2.1% | 52.47 ± 2.3% | not timed | not timed | 740.74 ± 2.2% | | 1.01 | 0.0767 | 14.20 |
| imported/mariomka/ip | 5 | 2442.86 ± 6.4% | not timed | not timed | 2875.07 ± 3.5% | 34.00 ± 3.0% | not timed | not timed | 2442.43 ± 5.5% | | 1.00 | 0.85 | 71.85 |
| imported/rsc/no-exponential | 0 | 1087.36 ± 21.7% | not timed | not timed | 611.90 ± 3.8% | 33.57 ± 5.1% | not timed | not timed | 1090.28 ± 49.3% | | 1.00 | 1.78 | 32.39 |
| imported/rsc/literal | 1 | 1397.57 ± 10.3% | not timed | not timed | 3063.56 ± 5.9% | 330.93 ± 42.0% | not timed | not timed | 1416.24 ± 6.1% | | 0.99 | 0.46 | 4.22 |
| imported/rsc/not-literal | 2 | 1319.67 ± 4.9% | not timed | not timed | 1388.98 ± 5.9% | 78.26 ± 3.4% | not timed | not timed | 1338.94 ± 8.0% | | 0.99 | 0.95 | 16.86 |
| imported/rsc/match-class | 1 | 2318.97 ± 5.4% | not timed | not timed | 3191.45 ± 13.1% | 101.91 ± 5.7% | not timed | not timed | 2331.89 ± 5.0% | | 0.99 | 0.73 | 22.76 |
| imported/rsc/match-class-in-range | 1 | 2362.74 ± 4.5% | not timed | not timed | 4967.06 ± 3.1% | 103.10 ± 2.0% | not timed | not timed | 2304.06 ± 7.9% | | 1.03 | 0.48 | 22.92 |
| imported/rsc/match-class-unicode | 1 | 686.41 ± 10.6% | not timed | not timed | 684.79 ± 0.5% | 122.69 ± 4.5% | not timed | not timed | 696.39 ± 1.7% | | 0.99 | 1.00 | 5.59 |
| imported/rsc/anchored-literal-short-non-match | 0 | 942.83 ± 11.4% | not timed | not timed | 1736.34 ± 13.8% | 448.11 ± 4.7% | not timed | not timed | 911.84 ± 4.8% | | 1.03 | 0.54 | 2.10 |
| imported/rsc/anchored-literal-long-non-match | 0 | 15332.19 ± 4.7% | not timed | not timed | 26886.31 ± 30.9% | 6924.40 ± 7.7% | not timed | not timed | 15568.82 ± 4.9% | | 0.98 | 0.57 | 2.21 |
| imported/rsc/anchored-literal-short-match | 4 | 685.45 ± 2.8% | not timed | not timed | 984.71 ± 6.9% | 150.72 ± 9.0% | not timed | not timed | 662.50 ± 7.4% | | 1.03 | 0.70 | 4.55 |
| imported/rsc/anchored-literal-long-match | 4 | 4343.54 ± 39.4% | not timed | not timed | 14703.90 ± 2.0% | 2177.33 ± 37.7% | not timed | not timed | 4528.40 ± 31.4% | | 0.96 | 0.30 | 1.99 |
| imported/rsc/one-pass-short | 17 | 563.00 ± 5.5% | not timed | not timed | 473.54 ± 5.8% | 51.83 ± 12.5% | not timed | not timed | 547.96 ± 11.4% | | 1.03 | 1.19 | 10.86 |
| imported/rsc/one-pass-short-not | 17 | 353.83 ± 29.8% | not timed | not timed | 465.31 ± 80.2% | 43.07 ± 11.0% | not timed | not timed | 360.63 ± 3.6% | | 0.98 | 0.76 | 8.21 |
| imported/rsc/one-pass-long-prefix | 26 | 365.09 ± 39.6% | not timed | not timed | 538.82 ± 54.3% | 177.47 ± 13.2% | not timed | not timed | 362.22 ± 6.3% | | 1.01 | 0.68 | 2.06 |
| imported/rsc/one-pass-long-prefix-not | 26 | 493.73 ± 8.2% | not timed | not timed | 483.01 ± 36.7% | 112.76 ± 9.8% | not timed | not timed | 495.72 ± 45.9% | | 1.00 | 1.02 | 4.38 |
| imported/rsc/long-needle1 | 31 | 87367.83 ± 5.5% | not timed | not timed | 67082.27 ± 3.5% | 5.99 ± 6.4% | not timed | not timed | 90618.36 ± 4.6% | | 0.96 | 1.30 | 14593.12 |
| imported/rsc/long-needle2 | 31 | 87099.97 ± 50.9% | not timed | not timed | 353.90 ± 46.8% | 5.99 ± 8.7% | not timed | not timed | 91205.59 ± 3.0% | | 0.95 | 246.11 | 14529.32 |
| imported/rsc/easy0-32 | 26 | 2048.61 ± 7.2% | not timed | not timed | 2676.07 ± 5.4% | 229.07 ± 13.8% | not timed | not timed | 2033.04 ± 7.6% | | 1.01 | 0.77 | 8.94 |
| imported/rsc/easy0-1k | 26 | 31349.05 ± 7.1% | not timed | not timed | 31215.02 ± 6.1% | 3505.02 ± 15.1% | not timed | not timed | 30809.18 ± 6.6% | | 1.02 | 1.00 | 8.94 |
| imported/rsc/easy0-32k | 26 | 85370.14 ± 1.8% | not timed | not timed | 65396.21 ± 5.7% | 40092.42 ± 27.8% | not timed | not timed | 86693.00 ± 5.2% | | 0.98 | 1.31 | 2.13 |
| imported/rsc/easy0-1mb | 26 | 86756.71 ± 3.1% | not timed | not timed | 69599.38 ± 3.4% | 100811.73 ± 2.6% | not timed | not timed | 84833.88 ± 3.7% | | 1.02 | 1.25 | 0.86 |
| imported/rsc/easy1-32 | 19 | 532.73 ± 6.7% | not timed | not timed | 1323.50 ± 4.2% | 217.11 ± 11.1% | not timed | not timed | 533.12 ± 15.4% | | 1.00 | 0.40 | 2.45 |
| imported/rsc/easy1-1k | 19 | 711.10 ± 6.6% | not timed | not timed | 25976.79 ± 4.8% | 3868.19 ± 7.7% | not timed | not timed | 720.86 ± 7.9% | | 0.99 | 0.0274 | 0.18 |
| imported/rsc/easy1-32k | 19 | 735.58 ± 4.7% | not timed | not timed | 834747.19 ± 2.0% | 43331.81 ± 23.8% | not timed | not timed | 733.55 ± 3.4% | | 1.00 | 0.0009 | 0.0170 |
| imported/rsc/easy1-1mb | 19 | 736.26 ± 7.2% | not timed | not timed | 24294857.28 ± 3.4% | 95812.28 ± 10.7% | not timed | not timed | 744.88 ± 4.2% | | 0.99 | 0.0000 | 0.0077 |
| imported/rsc/medium-32 | 27 | 721.18 ± 11.3% | not timed | not timed | 1132.61 ± 56.8% | 113.75 ± 116.7% | not timed | not timed | 710.51 ± 1.5% | | 1.02 | 0.64 | 6.34 |
| imported/rsc/medium-1k | 27 | 10898.37 ± 2.8% | not timed | not timed | 20490.77 ± 3.0% | 117.80 ± 5.8% | not timed | not timed | 10942.78 ± 5.6% | | 1.00 | 0.53 | 92.52 |
| imported/rsc/medium-32k | 27 | 75531.61 ± 21.5% | not timed | not timed | 574277.71 ± 5.1% | 81.47 ± 3.3% | not timed | not timed | 76490.96 ± 3.5% | | 0.99 | 0.13 | 927.09 |
| imported/rsc/medium-1mb | 27 | 86729.85 ± 4.3% | not timed | not timed | 21846819.51 ± 1.3% | 82.19 ± 4.8% | not timed | not timed | 84344.59 ± 7.6% | | 1.03 | 0.0040 | 1055.27 |
| imported/rsc/hard-32 | 58 | 363.50 ± 3.3% | not timed | not timed | 528.22 ± 5.5% | 77.32 ± 8.7% | not timed | not timed | 362.20 ± 5.7% | | 1.00 | 0.69 | 4.70 |
| imported/rsc/hard-1k | 27 | 693.57 ± 5.0% | not timed | not timed | 20520.40 ± 18.1% | 59.60 ± 4.7% | not timed | not timed | 687.87 ± 1.6% | | 1.01 | 0.0338 | 11.64 |
| imported/rsc/hard-32k | 27 | 717.63 ± 3.2% | not timed | not timed | 639658.89 ± 8.4% | 46.98 ± 5.4% | not timed | not timed | 731.87 ± 6.3% | | 0.98 | 0.0011 | 15.28 |
| imported/rsc/hard-1mb | 51 | 742.45 ± 3.8% | not timed | not timed | 10911516.86 ± 1.9% | 47.89 ± 13.0% | not timed | not timed | 747.59 ± 4.3% | | 0.99 | 0.0001 | 15.50 |
| imported/rsc/reallyhard0-32 | 58 | 365.70 ± 20.3% | not timed | not timed | 319.46 ± 56.6% | 79.31 ± 9.1% | not timed | not timed | 360.05 ± 5.2% | | 1.02 | 1.14 | 4.61 |
| imported/rsc/reallyhard0-1k | 27 | 683.26 ± 8.0% | not timed | not timed | 687.46 ± 3.6% | 59.95 ± 4.5% | not timed | not timed | 684.24 ± 4.4% | | 1.00 | 0.99 | 11.40 |
| imported/rsc/reallyhard0-32k | 27 | 746.00 ± 5.8% | not timed | not timed | 726.49 ± 4.4% | 50.78 ± 8.8% | not timed | not timed | 735.16 ± 3.9% | | 1.01 | 1.03 | 14.69 |
| imported/rsc/reallyhard0-1mb | 51 | 745.48 ± 5.4% | not timed | not timed | 720.71 ± 4.3% | 48.59 ± 10.3% | not timed | not timed | 747.53 ± 4.7% | | 1.00 | 1.03 | 15.34 |
| imported/rsc/reallyreallyhard0-32 | 47 | 409.68 ± 16.0% | not timed | not timed | 275.27 ± 26.0% | 92.19 ± 76.4% | not timed | not timed | 406.92 ± 3.3% | | 1.01 | 1.49 | 4.44 |
| imported/rsc/reallyreallyhard0-1k | 16 | 1042.46 ± 19.8% | not timed | not timed | 11260.99 ± 17.8% | 51.62 ± 18.8% | not timed | not timed | 1075.07 ± 13.7% | | 0.97 | 0.0926 | 20.19 |
| imported/rsc/reallyreallyhard0-32k | 16 | 756.36 ± 3.7% | not timed | not timed | 57932.56 ± 5.8% | 39.49 ± 36.0% | not timed | not timed | 748.56 ± 29.6% | | 1.01 | 0.0131 | 19.15 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 748.46 ± 6.3% | not timed | not timed | 68906.86 ± 7.0% | 40.62 ± 17.2% | not timed | not timed | 742.30 ± 5.2% | | 1.01 | 0.0109 | 18.43 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 415.58 ± 6.1% | not timed | not timed | 291.55 ± 5.0% | 94.90 ± 7.1% | not timed | not timed | 411.87 ± 7.1% | | 1.01 | 1.43 | 4.38 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 1015.85 ± 2.6% | not timed | not timed | 10798.90 ± 5.8% | 50.11 ± 8.6% | not timed | not timed | 1008.26 ± 5.9% | | 1.01 | 0.0941 | 20.27 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 767.81 ± 4.5% | not timed | not timed | 59171.37 ± 2.1% | 40.40 ± 6.9% | not timed | not timed | 772.59 ± 8.2% | | 0.99 | 0.0130 | 19.01 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 707.91 ± 15.8% | not timed | not timed | 65203.50 ± 3.1% | 39.74 ± 3.5% | not timed | not timed | 716.45 ± 4.8% | | 0.99 | 0.0109 | 17.82 |
| imported/sherlock/name-sherlock | 776 | 63788.56 ± 10.5% | not timed | not timed | 51109.83 ± 3.2% | 15744.48 ± 14.0% | not timed | not timed | 64218.33 ± 7.3% | | 0.99 | 1.25 | 4.05 |
| imported/sherlock/name-holmes | 2766 | 37112.09 ± 28.5% | not timed | not timed | 35904.12 ± 73.5% | 5150.57 ± 15.7% | not timed | not timed | 37616.47 ± 4.7% | | 0.99 | 1.03 | 7.21 |
| imported/sherlock/name-sherlock-holmes | 1365 | 65202.88 ± 4.6% | not timed | not timed | 50513.95 ± 3.0% | 12284.56 ± 13.1% | not timed | not timed | 65986.80 ± 7.9% | | 0.99 | 1.29 | 5.31 |
| imported/sherlock/name-sherlock-casei | 816 | 64598.90 ± 1.7% | not timed | not timed | 14533.93 ± 5.9% | 51.75 ± 63.0% | not timed | not timed | 64017.12 ± 33.8% | | 1.01 | 4.44 | 1248.24 |
| imported/sherlock/name-holmes-casei | 2802 | 31496.03 ± 70.0% | not timed | not timed | 9116.00 ± 5.1% | 64.35 ± 13.4% | not timed | not timed | 31737.09 ± 5.7% | | 0.99 | 3.46 | 489.47 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 53172.91 ± 6.4% | not timed | not timed | 14747.67 ± 5.6% | 53.82 ± 12.6% | not timed | not timed | 52960.91 ± 14.0% | | 1.00 | 3.61 | 987.93 |
| imported/sherlock/name-whitespace | 1461 | 36155.72 ± 15.4% | not timed | not timed | 37468.65 ± 5.4% | 11706.70 ± 43.6% | not timed | not timed | 35862.53 ± 63.7% | | 1.01 | 0.96 | 3.09 |
| imported/sherlock/name-alt1 | 1142 | 40518.31 ± 2.3% | not timed | not timed | 44019.83 ± 13.4% | 6511.30 ± 23.5% | not timed | not timed | 39899.96 ± 4.7% | | 1.02 | 0.92 | 6.22 |
| imported/sherlock/name-alt2 | 3542 | 22228.47 ± 45.2% | not timed | not timed | 11965.83 ± 2.7% | 53.89 ± 0.7% | not timed | not timed | 22151.50 ± 28.9% | | 1.00 | 1.86 | 412.49 |
| imported/sherlock/name-alt3 | 4507 | 14068.18 ± 6.9% | not timed | not timed | 11063.67 ± 1.9% | 16.68 ± 4.2% | not timed | not timed | 14219.07 ± 0.3% | | 0.99 | 1.27 | 843.22 |
| imported/sherlock/name-alt3-casei | 4593 | 2343.69 ± 15.1% | not timed | not timed | 1639.62 ± 2.5% | 10.57 ± 2.6% | not timed | not timed | 2375.34 ± 6.6% | | 0.99 | 1.43 | 221.65 |
| imported/sherlock/name-alt4 | 3686 | 11369.63 ± 13.2% | not timed | not timed | 9415.02 ± 4.5% | 53.15 ± 1.5% | not timed | not timed | 11472.13 ± 4.7% | | 0.99 | 1.21 | 213.92 |
| imported/sherlock/name-alt4-casei | 4254 | 6672.61 ± 4.6% | not timed | not timed | 5124.96 ± 3.8% | 31.85 ± 31.9% | not timed | not timed | 6646.42 ± 4.6% | | 1.00 | 1.30 | 209.50 |
| imported/sherlock/name-alt5 | 4028 | 18582.64 ± 3.5% | not timed | not timed | 11898.63 ± 5.5% | 38.61 ± 14.9% | not timed | not timed | 18668.96 ± 5.3% | | 1.00 | 1.56 | 481.34 |
| imported/sherlock/name-alt5-casei | 4104 | 8611.42 ± 6.3% | not timed | not timed | 3837.20 ± 8.5% | 23.60 ± 5.2% | not timed | not timed | 8546.07 ± 5.6% | | 1.01 | 2.24 | 364.93 |
| imported/sherlock/no-match-uncommon | 0 | 90684.54 ± 4.7% | not timed | not timed | 92935.80 ± 5.3% | 79606.20 ± 23.3% | not timed | not timed | 93177.47 ± 5.6% | | 0.97 | 0.98 | 1.14 |
| imported/sherlock/no-match-common | 0 | 90168.72 ± 4.9% | not timed | not timed | 93194.10 ± 5.5% | 2444.24 ± 5.8% | not timed | not timed | 90547.04 ± 3.7% | | 1.00 | 0.97 | 36.89 |
| imported/sherlock/no-match-really-common | 0 | 60320.37 ± 2.9% | not timed | not timed | 66727.47 ± 5.3% | 2357.95 ± 10.9% | not timed | not timed | 61032.62 ± 2.8% | | 0.99 | 0.90 | 25.58 |
| imported/sherlock/the-lower | 21654 | 4011.54 ± 4.9% | not timed | not timed | 3986.66 ± 2.9% | 366.92 ± 19.2% | not timed | not timed | 3964.31 ± 5.7% | | 1.01 | 1.01 | 10.93 |
| imported/sherlock/the-upper | 2223 | 26693.13 ± 3.0% | not timed | not timed | 34122.81 ± 8.3% | 4160.92 ± 16.0% | not timed | not timed | 27129.35 ± 13.3% | | 0.98 | 0.78 | 6.42 |
| imported/sherlock/the-casei | 23961 | 3625.24 ± 6.2% | not timed | not timed | 1654.76 ± 6.9% | 58.42 ± 21.6% | not timed | not timed | 3577.47 ± 3.8% | | 1.01 | 2.19 | 62.06 |
| imported/sherlock/everything-greedy | 581881 | 338.30 ± 5.0% | not timed | not timed | 221.43 ± 7.3% | 46.54 ± 57.2% | not timed | not timed | 340.96 ± 5.6% | | 0.99 | 1.53 | 7.27 |
| imported/sherlock/everything-greedy-nl | 594933 | 565.58 ± 4.9% | not timed | not timed | 302.74 ± 10.7% | 54.69 ± 5.4% | not timed | not timed | 580.61 ± 4.4% | | 0.97 | 1.87 | 10.34 |
| imported/sherlock/letters | 447175 | 74.85 ± 6.1% | not timed | not timed | 46.11 ± 5.9% | 8.29 ± 41.4% | not timed | not timed | 75.69 ± 5.5% | | 0.99 | 1.62 | 9.03 |
| imported/sherlock/letters-upper | 14180 | 519.64 ± 27.9% | not timed | not timed | 464.49 ± 62.6% | 40.54 ± 41.8% | not timed | not timed | 505.43 ± 6.3% | | 1.03 | 1.12 | 12.82 |
| imported/sherlock/letters-lower | 432995 | 73.84 ± 31.4% | not timed | not timed | 48.05 ± 72.6% | 9.21 ± 48.0% | not timed | not timed | 77.75 ± 4.8% | | 0.95 | 1.54 | 8.02 |
| imported/sherlock/words | 447639 | 127.67 ± 6.1% | not timed | not timed | 102.06 ± 4.6% | 19.67 ± 12.3% | not timed | not timed | 130.30 ± 6.3% | | 0.98 | 1.25 | 6.49 |
| imported/sherlock/before-holmes | 4073 | 713.74 ± 4.6% | not timed | not timed | 16546.42 ± 6.5% | 37.30 ± 4.4% | not timed | not timed | 730.54 ± 5.0% | | 0.98 | 0.0431 | 19.13 |
| imported/sherlock/before-after-holmes | 2593 | 738.94 ± 1.9% | not timed | not timed | 20152.14 ± 13.8% | 38.29 ± 3.4% | not timed | not timed | 739.13 ± 3.0% | | 1.00 | 0.0367 | 19.30 |
| imported/sherlock/holmes-cochar-watson | 150 | 12410.06 ± 14.7% | not timed | not timed | 10214.80 ± 1.9% | 54.51 ± 4.3% | not timed | not timed | 12425.38 ± 37.3% | | 1.00 | 1.21 | 227.66 |
| imported/sherlock/holmes-coword-watson | 14309 | 1582.16 ± 29.3% | not timed | not timed | 1560.99 ± 15.0% | 11.62 ± 7.3% | not timed | not timed | 1553.03 ± 56.6% | | 1.02 | 1.01 | 136.19 |
| imported/sherlock/quotes | 14437 | 1611.75 ± 4.5% | not timed | not timed | 2834.08 ± 7.1% | 52.20 ± 14.9% | not timed | not timed | 1608.47 ± 6.8% | | 1.00 | 0.57 | 30.88 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 747.53 ± 6.9% | not timed | not timed | 39294.66 ± 21.3% | 61.22 ± 28.3% | not timed | not timed | 747.74 ± 7.3% | | 1.00 | 0.0190 | 12.21 |
| imported/sherlock/word-ending-n | 35297 | 564.94 ± 6.6% | not timed | not timed | 501.30 ± 6.0% | 36.78 ± 36.4% | not timed | not timed | 562.60 ± 3.3% | | 1.00 | 1.13 | 15.36 |
| imported/sherlock/repeated-class-negation | 2130 | 24717.78 ± 4.9% | not timed | not timed | 23652.25 ± 2.5% | 15.83 ± 4.4% | not timed | not timed | 24126.89 ± 6.0% | | 1.02 | 1.05 | 1561.07 |
| imported/sherlock/ing-suffix | 20547 | 697.35 ± 2.5% | not timed | not timed | 638.12 ± 0.4% | 45.38 ± 21.0% | not timed | not timed | 696.66 ± 2.6% | | 1.00 | 1.09 | 15.37 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 732.78 ± 8.2% | not timed | not timed | 3670.86 ± 7.2% | 32.84 ± 30.5% | not timed | not timed | 729.70 ± 6.4% | | 1.00 | 0.20 | 22.32 |
| opt/accelerate/whole-line | 239963 | 641.99 ± 87.7% | not timed | not timed | 502.80 ± 18.9% | 121.66 ± 33.4% | not timed | not timed | 649.51 ± 6.2% | | 0.99 | 1.28 | 5.28 |
| opt/accelerate/non-dna | 16745 | 547.84 ± 3.7% | not timed | not timed | 555.96 ± 2.3% | 47.11 ± 21.2% | not timed | not timed | 545.11 ± 1.5% | | 1.00 | 0.99 | 11.63 |
| opt/backtrack/words-english | 40536 | 194.34 ± 8.3% | not timed | not timed | 146.31 ± 5.0% | 30.85 ± 9.0% | not timed | not timed | 197.75 ± 6.3% | | 0.98 | 1.33 | 6.30 |
| opt/fixed-length/too-small-ascii | 0 | 537.59 ± 6.7% | not timed | not timed | 1111.08 ± 5.8% | 159.12 ± 5.6% | not timed | not timed | 541.34 ± 39.7% | | 0.99 | 0.48 | 3.38 |
| opt/fixed-length/too-big-ascii | 0 | 1095.89 ± 6.9% | not timed | not timed | 8784.90 ± 22.0% | 212.46 ± 5.1% | not timed | not timed | 1110.82 ± 16.0% | | 0.99 | 0.12 | 5.16 |
| opt/fixed-length/go33484-1 | 0 | 92.99 ± 2.8% | not timed | not timed | 1724221.23 ± 4.1% | 127485.57 ± 2.1% | not timed | not timed | 93.24 ± 1.4% | | 1.00 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 6823.31 ± 29.0% | not timed | not timed | 1693150.25 ± 6.3% | 45165.18 ± 7.5% | not timed | not timed | 6758.20 ± 4.7% | | 1.01 | 0.0040 | 0.15 |
| opt/fixed-length/go33484-3 | 0 | 2222.61 ± 6.4% | not timed | not timed | 170588.22 ± 5.4% | 1310.51 ± 2.7% | not timed | not timed | 2219.11 ± 4.0% | | 1.00 | 0.0130 | 1.70 |
| opt/literal-alt/one-pattern | 1 | 735.92 ± 5.9% | not timed | not timed | 726.37 ± 5.3% | 0.66 ± 2.0% | not timed | not timed | 745.44 ± 6.5% | | 0.99 | 1.01 | 1114.95 |
| opt/onepass/fn-predicate | 916 | 623.30 ± 2.6% | not timed | not timed | 533.95 ± 0.2% | 299.90 ± 13.6% | not timed | not timed | 621.87 ± 6.5% | | 1.00 | 1.17 | 2.08 |
| opt/onepass/first-three-words-english | 35128 | 219.83 ± 70.2% | not timed | not timed | 310.80 ± 4.0% | 117.41 ± 12.6% | not timed | not timed | 213.35 ± 39.9% | | 1.03 | 0.71 | 1.87 |
| opt/prefilter/literal-english | 1 | 93743.77 ± 3.4% | not timed | not timed | 69523.03 ± 51.9% | 35138.84 ± 19.2% | not timed | not timed | 92725.79 ± 4.6% | | 1.01 | 1.35 | 2.67 |
| opt/prefilter/literal-casei-english | 1 | 71302.32 ± 2.5% | not timed | not timed | 19022.76 ± 4.3% | 54.84 ± 2.0% | not timed | not timed | 71470.19 ± 2.9% | | 1.00 | 3.75 | 1300.25 |
| opt/prefilter/literal-russian | 1 | 91881.54 ± 5.0% | not timed | not timed | 69047.39 ± 5.3% | 4277.86 ± 4.9% | not timed | not timed | 93420.87 ± 1.9% | | 0.98 | 1.33 | 21.48 |
| opt/prefilter/literal-casei-russian | 1 | 38133.63 ± 3.9% | not timed | not timed | 13532.76 ± 3.8% | 57.55 ± 14.9% | not timed | not timed | 36851.26 ± 5.1% | | 1.03 | 2.82 | 662.63 |
| opt/prefilter/rust-functions | 948 | 20956.12 ± 4.9% | not timed | not timed | 17074.78 ± 7.3% | 2517.34 ± 16.0% | not timed | not timed | 20905.52 ± 5.5% | | 1.00 | 1.23 | 8.32 |
| opt/reverse-anchored/word-end | 1 | 7254.64 ± 0.6% | not timed | not timed | 38174522.69 ± 1.6% | 85.91 ± 3.2% | not timed | not timed | 7247.69 ± 4.4% | | 1.00 | 0.0002 | 84.44 |
| opt/reverse-inner/holmes | 2593 | 714.31 ± 5.5% | not timed | not timed | 19409.99 ± 6.4% | 37.84 ± 10.5% | not timed | not timed | 725.08 ± 5.0% | | 0.99 | 0.0368 | 18.88 |
| opt/reverse-inner/email | 47 | 1269.15 ± 0.9% | not timed | not timed | 110899.64 ± 64.8% | 51.17 ± 2.9% | not timed | not timed | 1245.42 ± 15.8% | | 1.02 | 0.0114 | 24.80 |
| opt/reverse-inner/factored-prefix | 3542 | 733.95 ± 43.5% | not timed | not timed | 727.36 ± 7.4% | 20.31 ± 39.7% | not timed | not timed | 734.61 ± 5.3% | | 1.00 | 1.01 | 36.13 |
| opt/reverse-inner/no-quadratic-backward | 0 | 7020.33 ± 3.2% | not timed | not timed | 738.55 ± 6.6% | 127.47 ± 3.6% | not timed | not timed | 7051.55 ± 4.8% | | 1.00 | 9.51 | 55.07 |
| opt/reverse-inner/no-quadratic-forward | 0 | 859.37 ± 53.9% | not timed | not timed | 344.87 ± 14.2% | 40.45 ± 89.2% | not timed | not timed | 869.83 ± 1.7% | | 0.99 | 2.49 | 21.24 |
| opt/reverse-suffix/holmes | 4073 | 738.17 ± 4.3% | not timed | not timed | 17219.49 ± 4.6% | 38.81 ± 4.9% | not timed | not timed | 738.60 ± 3.5% | | 1.00 | 0.0429 | 19.02 |
| opt/reverse-suffix/no-quadratic | 0 | 7044.42 ± 5.3% | not timed | not timed | 745.80 ± 5.6% | 123.58 ± 5.0% | not timed | not timed | 7023.48 ± 4.4% | | 1.00 | 9.45 | 57.00 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 222.13 ± 5.3% | not timed | not timed | 268.20 ± 4.8% | 23.64 ± 30.6% | not timed | not timed | 215.67 ± 16.0% | | 1.03 | 0.83 | 9.40 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 218.77 ± 4.9% | not timed | not timed | 284.29 ± 5.3% | 24.87 ± 10.4% | not timed | not timed | 222.12 ± 4.2% | | 0.98 | 0.77 | 8.80 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.48 ± 8.8% | not timed | not timed | 0.81 ± 6.8% | 166.75 ± 30.2% | not timed | not timed | 0.48 ± 4.3% | | 1.01 | 0.60 | 0.0029 |
| reported/i1095-word-repetition/ascii-search | 256 | 362.48 ± 14.6% | not timed | not timed | 360.34 ± 2.1% | 155.97 ± 3.1% | not timed | not timed | 374.72 ± 4.5% | | 0.97 | 1.01 | 2.32 |
| reported/i13-subset-regex/original-ascii | 4094 | 14847.72 ± 4.4% | not timed | not timed | 5346.04 ± 3.3% | 14.86 ± 2.7% | not timed | not timed | 14658.91 ± 65.4% | | 1.01 | 2.78 | 998.90 |
| reported/i13-subset-regex/original-unicode | 4094 | 14493.47 ± 12.9% | not timed | not timed | 280.84 ± 54.4% | 14.82 ± 2.2% | not timed | not timed | 14686.87 ± 2.7% | | 0.99 | 51.61 | 977.77 |
| reported/i13-subset-regex/big-ascii | 1955 | 13688.28 ± 5.3% | not timed | not timed | 77.37 ± 4.4% | 12.98 ± 5.4% | not timed | not timed | 13696.43 ± 1.1% | | 1.00 | 176.92 | 1054.50 |
| reported/i13-subset-regex/big-unicode | 1955 | 13747.30 ± 1.6% | not timed | not timed | 13.67 ± 56.6% | 12.98 ± 1.2% | not timed | not timed | 13789.41 ± 1.5% | | 1.00 | 1005.84 | 1059.51 |
| reported/i13-subset-regex/huge-ascii | 55 | 12710.13 ± 6.9% | not timed | not timed | 13.04 ± 6.7% | 12.19 ± 9.8% | not timed | not timed | 12735.19 ± 7.2% | | 1.00 | 974.52 | 1042.79 |
| reported/i13-subset-regex/huge-unicode | 55 | 12779.72 ± 4.0% | not timed | not timed | 12.60 ± 2.6% | 12.07 ± 3.2% | not timed | not timed | 12764.02 ± 2.4% | | 1.00 | 1014.55 | 1058.47 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.70 ± 4.6% | not timed | not timed | 12.62 ± 5.1% | 12.33 ± 9.1% | not timed | not timed | 5.74 ± 6.4% | | 0.99 | 0.45 | 0.46 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.37 ± 5.2% | not timed | not timed | 13.06 ± 7.7% | 12.22 ± 2.1% | not timed | not timed | 7.38 ± 4.7% | | 1.00 | 0.56 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 573.33 ± 3.1% | not timed | not timed | 207.80 ± 6.9% | 10.16 ± 16.3% | not timed | not timed | 578.77 ± 2.6% | | 0.99 | 2.76 | 56.42 |
| reported/i787-keywords/opt-ascii | 5674 | 580.95 ± 3.4% | not timed | not timed | 343.71 ± 6.5% | 17.04 ± 12.5% | not timed | not timed | 578.61 ± 2.3% | | 1.00 | 1.69 | 34.08 |
| slow/quadratic-regex-1x | 100 | 10.43 ± 3.0% | not timed | not timed | 7.55 ± 2.7% | 0.08 ± 3.3% | not timed | not timed | 10.47 ± 1.7% | | 1.00 | 1.38 | 136.54 |
| slow/quadratic-regex-2x | 199 | 4.50 ± 0.5% | not timed | not timed | 3.93 ± 2.5% | 0.02 ± 2.6% | not timed | not timed | 4.47 ± 1.0% | | 1.01 | 1.14 | 225.59 |
| slow/quadratic-haystack-1x | 100 | 37.80 ± 6.6% | not timed | not timed | 16.53 ± 4.2% | 1.41 ± 4.0% | not timed | not timed | 38.73 ± 5.8% | | 0.98 | 2.29 | 26.82 |
| slow/quadratic-haystack-2x | 200 | 30.50 ± 3.4% | not timed | not timed | 7.86 ± 0.9% | 0.77 ± 9.9% | not timed | not timed | 31.16 ± 1.8% | | 0.98 | 3.88 | 39.62 |
| unicode/codepoints/any-one | 1112064 | 496.01 ± 3.4% | not timed | not timed | 365.47 ± 1.5% | 27.92 ± 12.9% | not timed | not timed | 497.57 ± 6.0% | | 1.00 | 1.36 | 17.77 |
| unicode/codepoints/any-all | 4382592 | 334.02 ± 12.6% | not timed | not timed | 329.95 ± 3.3% | 188.24 ± 2.5% | not timed | not timed | 336.25 ± 2.1% | | 0.99 | 1.01 | 1.77 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.47 ± 10.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 699.65 ± 4.9% | not timed | not timed | 695.42 ± 3.8% | 219.00 ± 1.5% | not timed | not timed | 701.68 ± 1.4% | | 1.00 | 1.01 | 3.19 |
| unicode/overlapping-words/ascii | 6156 | 44.93 ± 1.3% | not timed | not timed | 55.49 ± 4.3% | 5.96 ± 4.7% | not timed | not timed | 44.73 ± 1.1% | | 1.00 | 0.81 | 7.54 |
| unicode/overlapping-words/english | 6156 | 2.14 ± 1.9% | not timed | not timed | 5.06 ± 2.5% | 3.67 ± 6.9% | not timed | not timed | 2.13 ± 47.1% | | 1.01 | 0.42 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.91 ± 3.6% | not timed | not timed | 4.81 ± 3.8% | 8.99 ± 11.6% | not timed | not timed | 1.93 ± 4.3% | | 0.99 | 0.40 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 134.63 ± 1.4% | not timed | not timed | 105.70 ± 1.5% | 17.90 ± 11.3% | not timed | not timed | 135.27 ± 1.6% | | 1.00 | 1.27 | 7.52 |
| unicode/word/boundary-long-english | 3466 | 709.06 ± 1.4% | not timed | not timed | 695.20 ± 1.5% | 49.03 ± 1.2% | not timed | not timed | 710.03 ± 0.5% | | 1.00 | 1.02 | 14.46 |
| unicode/word/around-holmes-english | 27 | 709.30 ± 1.2% | not timed | not timed | 63354.51 ± 3.7% | 34.55 ± 4.2% | not timed | not timed | 710.91 ± 0.4% | | 1.00 | 0.0112 | 20.53 |
| wild/bibleref/long | 874 | 672.83 ± 0.2% | not timed | not timed | 680.00 ± 0.6% | 11.01 ± 3.8% | not timed | not timed | 672.81 ± 0.7% | | 1.00 | 0.99 | 61.08 |
| wild/bibleref/short | 30 | 34.81 ± 2.1% | not timed | not timed | 45.47 ± 0.5% | 22.49 ± 10.4% | not timed | not timed | 35.34 ± 3.2% | | 0.98 | 0.77 | 1.55 |
| wild/bibleref/line | 874 | 661.83 ± 10.2% | not timed | not timed | 334.08 ± 1.5% | 13.10 ± 9.4% | not timed | not timed | 667.63 ± 1.9% | | 0.99 | 1.98 | 50.54 |
| wild/caddy/caddy | 6 | 618.30 ± 2.5% | not timed | not timed | 347.97 ± 2.5% | 103.50 ± 9.7% | not timed | not timed | 621.00 ± 4.9% | | 1.00 | 1.78 | 5.97 |
| wild/dot-star-capture/rust-src-tools | 6 | 2062.22 ± 3.7% | not timed | not timed | 464.70 ± 7.6% | 22.92 ± 4.3% | not timed | not timed | 2061.12 ± 2.9% | | 1.00 | 4.44 | 89.99 |
| wild/ruff/noqa | 84 | 634.61 ± 5.1% | not timed | not timed | 644.64 ± 34.9% | 28.57 ± 1.7% | not timed | not timed | 635.86 ± 6.5% | | 1.00 | 0.98 | 22.22 |
| wild/ruff/unnecessary-coding-comment | 16 | 719.27 ± 1.1% | not timed | not timed | 871.14 ± 3.0% | 192.93 ± 11.5% | not timed | not timed | 719.77 ± 1.0% | | 1.00 | 0.83 | 3.73 |
| wild/ruff/string-quote-prefix | 2972 | 650.23 ± 1.6% | not timed | not timed | 670.12 ± 1.8% | 431.87 ± 26.6% | not timed | not timed | 660.48 ± 6.8% | | 0.98 | 0.97 | 1.51 |
| wild/ruff/space-around-operator | 1224378 | 316.10 ± 3.0% | not timed | not timed | 278.55 ± 1.5% | 26.28 ± 4.9% | not timed | not timed | 309.24 ± 2.1% | | 1.02 | 1.13 | 12.03 |
| wild/ruff/shebang | 282 | 643.25 ± 9.5% | not timed | not timed | 527.28 ± 8.4% | 160.02 ± 12.1% | not timed | not timed | 655.16 ± 4.9% | | 0.98 | 1.22 | 4.02 |
| wild/rustsec-cargo-audit/original-unix | 471 | 29033.80 ± 3.0% | not timed | not timed | 32267.88 ± 1.0% | 12102.12 ± 4.1% | not timed | not timed | 29154.03 ± 1.2% | | 1.00 | 0.90 | 2.40 |
| wild/rustsec-cargo-audit/original-windows | 462 | 27255.25 ± 2.0% | not timed | not timed | 30362.45 ± 3.3% | 11102.49 ± 2.2% | not timed | not timed | 27086.70 ± 27.9% | | 1.01 | 0.90 | 2.45 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 30117.31 ± 2.0% | not timed | not timed | 31637.67 ± 1.0% | 11525.68 ± 3.1% | not timed | not timed | 30286.00 ± 1.8% | | 0.99 | 0.95 | 2.61 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 25579.07 ± 22.1% | not timed | not timed | 31890.51 ± 5.1% | 11814.94 ± 30.6% | not timed | not timed | 25637.63 ± 0.8% | | 1.00 | 0.80 | 2.16 |
| wild/url/search | 234965 | 165.10 ± 7.4% | not timed | not timed | 80.17 ± 5.4% | 3.48 ± 2.6% | not timed | not timed | 165.42 ± 6.9% | | 1.00 | 2.06 | 47.47 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 82.4% | not timed | not timed | 0.01 ± 1.2% | 0.01 ± 16.0% | not timed | not timed | 0.04 ± 11.7% | | 0.99 | 3.00 | 5.41 |
| dictionary/compile/english-15 | 1 | 0.44 ± 2.1% | not timed | not timed | 0.10 ± 10.2% | 0.14 ± 27.9% | not timed | not timed | 0.44 ± 10.4% | | 1.00 | 4.41 | 3.21 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.39 ± 9.5% | not timed | not timed | 0.03 ± 72.0% | 40.54 ± 86.1% | not timed | not timed | 0.39 ± 72.2% | | 1.01 | 13.88 | 0.0097 |
| reported/i1095-word-repetition/ascii-compile | 1 | 56.61 ± 11.9% | not timed | not timed | 18.79 ± 1.9% | 72.70 ± 17.4% | not timed | not timed | 57.18 ± 48.6% | | 0.99 | 3.01 | 0.78 |
| reported/i787-keywords/compile | 1 | 52.19 ± 12.1% | not timed | not timed | 3.07 ± 4.2% | 23.91 ± 13.9% | not timed | not timed | 53.51 ± 2.5% | | 0.98 | 17.02 | 2.18 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 569.59 ± 5.5% | not timed | not timed | 186.31 ± 0.8% | 753.67 ± 6.5% | not timed | not timed | 583.68 ± 13.0% | | 0.98 | 3.06 | 0.76 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 72.84 ± 12.9% | not timed | not timed | 6.99 ± 2.1% | 59.73 ± 15.6% | not timed | not timed | 76.09 ± 14.6% | | 0.96 | 10.43 | 1.22 |
| unicode/compile/one-letter | 53 | 10.03 ± 3.3% | not timed | not timed | 7.61 ± 13.3% | 80.33 ± 10.4% | not timed | not timed | 10.12 ± 11.5% | | 0.99 | 1.32 | 0.12 |
| unicode/compile/fifty-letters | 1 | 1.73 ± 12.9% | not timed | not timed | 0.16 ± 7.8% | 80.44 ± 20.7% | not timed | not timed | 1.80 ± 12.2% | | 0.96 | 10.59 | 0.0215 |
| unicode/compile/fifty-letters-ascii | 1 | 290.47 ± 18.4% | not timed | not timed | 80.24 ± 2.0% | 245.81 ± 10.6% | not timed | not timed | 299.62 ± 1.2% | | 0.97 | 3.62 | 1.18 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 626.19 ± 11.2% | not timed | not timed | 59.98 ± 3.3% | 800.19 ± 19.6% | not timed | not timed | 643.98 ± 12.8% | | 0.97 | 10.44 | 0.78 |
| unicode/compile/match-every-line-ascii | 4 | 1022.86 ± 14.8% | not timed | not timed | 217.87 ± 1.6% | 901.39 ± 7.1% | not timed | not timed | 1064.43 ± 5.1% | | 0.96 | 4.69 | 1.13 |
| unicode/compile/negated-class-matches-codepoint | 1 | 517.94 ± 8.0% | not timed | not timed | 63.82 ± 2.7% | 1710.10 ± 3.2% | not timed | not timed | 533.66 ± 23.9% | | 0.97 | 8.12 | 0.30 |
| wild/bibleref/compile | 3 | 8.93 ± 13.6% | not timed | not timed | 3.10 ± 1.8% | 41.00 ± 12.4% | not timed | not timed | 8.96 ± 9.9% | | 1.00 | 2.88 | 0.22 |
| wild/url/compile | 1 | 0.98 ± 8.5% | not timed | not timed | 0.22 ± 1.6% | 0.58 ± 29.3% | not timed | not timed | 1.00 ± 10.7% | | 0.98 | 4.43 | 1.68 |

