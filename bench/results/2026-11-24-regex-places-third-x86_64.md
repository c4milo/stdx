# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506979120 |
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
| literal: a word | 217 | 63354.87 ± 5.4% | 6335.98 ± 3.5% | 46.09 ± 0.9% | 52249.32 ± 3.8% | 16275.62 ± 2.9% | 15.49 ± 11.3% | 159.24 ± 4.7% | 63587.78 ± 4.5% | 10.00 | 1.00 | 1.21 | 3.89 |
| literal: a word that is not there | 0 | 83004.67 ± 4.5% | 6085.59 ± 0.5% | 45.40 ± 1.3% | 63913.48 ± 1.1% | 55475.98 ± 1.3% | 15.22 ± 1.6% | 147.08 ± 1.0% | 83056.56 ± 1.3% | 13.64 | 1.00 | 1.30 | 1.50 |
| literal: one of four words | 661 | 21705.51 ± 1.6% | 2330.44 ± 6.9% | 24.57 ± 2.4% | 14175.82 ± 1.8% | 37.90 ± 3.6% | 5.01 ± 12.9% | 12.99 ± 2.2% | 21635.50 ± 5.3% | 9.31 | 1.00 | 1.53 | 572.69 |
| literal: a word in any case | 217 | 57521.93 ± 4.6% | 2536.12 ± 2.6% | 32.91 ± 3.1% | 14131.13 ± 8.4% | 71.69 ± 5.1% | refused | differs | 58324.60 ± 2.8% | 22.68 | 0.99 | 4.07 | 802.34 |
| literal: an href attribute | 33 | 50936.93 ± 1.3% | 716.53 ± 3.5% | 38.41 ± 1.6% | 45641.63 ± 4.0% | 3463.16 ± 2.4% | 10.83 ± 0.9% | 131.11 ± 1.8% | 51318.24 ± 1.7% | 71.09 | 0.99 | 1.12 | 14.71 |
| literal: a word, second text | 123 | 63204.64 ± 4.9% | 4346.04 ± 6.5% | 43.17 ± 2.7% | 46375.41 ± 6.3% | 14620.00 ± 5.3% | 20.18 ± 4.0% | 112.21 ± 10.4% | 63227.33 ± 4.2% | 14.54 | 1.00 | 1.36 | 4.32 |
| class: two capitalized words | 1331 | 1105.31 ± 1.4% | 722.61 ± 1.6% | 40.79 ± 1.0% | 680.09 ± 1.2% | 59.24 ± 24.7% | 13.47 ± 0.4% | 105.73 ± 4.9% | 1109.21 ± 1.0% | 1.53 | 1.00 | 1.63 | 18.66 |
| class: a word that ends in ing | 3399 | 686.11 ± 9.4% | 671.94 ± 7.4% | 26.27 ± 29.6% | 630.66 ± 51.1% | 44.95 ± 4.3% | 7.80 ± 5.8% | 31.24 ± 11.0% | 688.36 ± 9.3% | 1.02 | 1.00 | 1.09 | 15.26 |
| class: a word in capitals | 2332 | 1524.37 ± 6.4% | 682.35 ± 7.0% | 40.24 ± 4.2% | 622.06 ± 2.8% | 61.32 ± 3.6% | 15.33 ± 3.8% | 128.51 ± 2.2% | 1530.75 ± 3.4% | 2.23 | 1.00 | 2.45 | 24.86 |
| class: a number | 8288 | 2811.63 ± 2.4% | 980.36 ± 4.2% | 39.29 ± 14.5% | 2201.84 ± 38.0% | 56.22 ± 17.3% | 0.42 ± 3.4% | 92.80 ± 1.8% | 2781.42 ± 1.8% | 2.87 | 1.01 | 1.28 | 50.01 |
| class: two capitalized words, second text | 5359 | 589.73 ± 5.1% | 592.94 ± 3.7% | 35.23 ± 5.2% | 546.32 ± 3.6% | 46.93 ± 19.2% | 17.46 ± 7.0% | 93.34 ± 4.0% | 589.40 ± 5.2% | 0.99 | 1.00 | 1.08 | 12.57 |
| other: a word between two words | 6104 | 1123.20 ± 1.9% | 687.06 ± 2.7% | 34.16 ± 1.7% | 923.62 ± 3.3% | 163.97 ± 9.1% | 9.67 ± 2.4% | 108.47 ± 5.0% | 1104.15 ± 4.4% | 1.63 | 1.02 | 1.22 | 6.85 |
| other: a number before a unit, second text | 1481 | 12766.79 ± 3.1% | 1376.03 ± 2.6% | 39.44 ± 8.8% | 10454.57 ± 9.7% | 57.58 ± 2.5% | 17.81 ± 1.9% | 103.42 ± 2.8% | 12716.68 ± 3.0% | 9.28 | 1.00 | 1.22 | 221.71 |
| other: a heading's start tag | 110 | 29931.96 ± 10.5% | 828.37 ± 4.3% | 39.30 ± 3.4% | 3164.51 ± 3.6% | 2418.92 ± 8.5% | 13.04 ± 3.8% | 151.33 ± 6.1% | 29926.40 ± 5.1% | 36.13 | 1.00 | 9.46 | 12.37 |
| other: a whole word | 217 | 40232.82 ± 6.1% | 682.58 ± 6.0% | 43.05 ± 7.8% | 34040.76 ± 6.0% | 70.74 ± 6.1% | 12.92 ± 6.0% | 80.98 ± 5.5% | 39940.10 ± 3.3% | 58.94 | 1.01 | 1.18 | 568.74 |
| other: a line's first word, second text | 3716 | 3318.47 ± 3.5% | 675.15 ± 2.1% | 46.59 ± 2.6% | 3318.68 ± 1.8% | 95.28 ± 6.8% | refused | refused | 3314.67 ± 1.6% | 4.92 | 1.00 | 1.00 | 34.83 |
| other: fourteen octets before an x | 87 | 48633.59 ± 4.3% | 326.70 ± 4.8% | 9.06 ± 3.2% | 4513.40 ± 4.1% | 13.86 ± 7.7% | differs | 24.94 ± 33.5% | 49722.89 ± 11.2% | 148.87 | 0.98 | 10.78 | 3508.53 |
| other: a Greek word | 21815 | 635.40 ± 2.5% | 526.97 ± 2.4% | 46.49 ± 4.0% | 341.79 ± 2.2% | 57.16 ± 4.4% | differs | refused | 638.15 ± 2.3% | 1.21 | 1.00 | 1.86 | 11.12 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 36.29 ± 3.8% | 35.92 ± 4.9% | 1.44 ± 3.6% | 22.40 ± 1.6% | 3.41 ± 1.7% | differs | 5.73 ± 15.1% | 35.84 ± 3.7% | 1.01 | 1.01 | 1.62 | 10.64 |
| a UUID | 32895 | 32.39 ± 1.4% | 32.11 ± 1.7% | 0.96 ± 1.3% | 17.20 ± 1.6% | 3.39 ± 1.6% | 0.69 ± 1.1% | 4.48 ± 3.7% | 32.14 ± 0.6% | 1.01 | 1.01 | 1.88 | 9.54 |
| an IPv4 address | 33176 | 43.30 ± 1.3% | 44.08 ± 2.9% | 2.96 ± 3.7% | 32.29 ± 1.0% | 8.59 ± 11.1% | differs | 5.44 ± 2.4% | 44.44 ± 2.5% | 0.98 | 0.97 | 1.34 | 5.04 |
| a date and time | 32954 | 44.31 ± 4.9% | 44.15 ± 4.2% | 2.28 ± 5.9% | 24.84 ± 4.4% | 10.41 ± 3.3% | 1.24 ± 4.5% | 11.22 ± 7.3% | 44.87 ± 4.2% | 1.00 | 0.99 | 1.78 | 4.26 |
| a field path | 32606 | 38.23 ± 6.6% | 37.98 ± 1.6% | 1.54 ± 0.6% | 25.92 ± 1.1% | 4.41 ± 1.1% | differs | 3.88 ± 2.3% | 38.51 ± 3.0% | 1.01 | 0.99 | 1.47 | 8.67 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.15 ± 4.7% | 14.70 ± 4.1% | 15.05 ± 4.3% | 16.95 ± 3.5% | 7.55 ± 5.1% | 1.04 ± 5.5% | none | 14.60 ± 3.0% | 1.03 | 1.04 | 0.89 | 2.01 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 351.46 ± 6.9% | 350.99 ± 1.8% | 409.89 ± 1.7% | 130.40 ± 3.8% | 320.05 ± 2.9% | 858.69 ± 4.4% | 5466.31 ± 3.8% | 352.03 ± 0.9% | 1.00 | 1.00 | 2.70 | 1.10 |
| a UUID | 62 | 232.79 ± 3.2% | 231.01 ± 6.6% | 253.14 ± 3.7% | 72.22 ± 3.4% | 154.11 ± 6.5% | 305.79 ± 4.8% | 6960.44 ± 7.3% | 233.61 ± 1.9% | 1.01 | 1.00 | 3.22 | 1.51 |
| an IPv4 address | 29 | 671.65 ± 4.2% | 671.54 ± 1.9% | 928.37 ± 1.9% | 115.63 ± 1.4% | 199.53 ± 4.1% | 547.46 ± 2.3% | 12103.42 ± 1.2% | 673.46 ± 4.4% | 1.00 | 1.00 | 5.81 | 3.37 |
| a date and time | 56 | 493.80 ± 2.1% | 493.81 ± 2.9% | 614.25 ± 1.7% | 110.23 ± 2.1% | 216.63 ± 6.8% | 557.71 ± 4.1% | 7616.41 ± 4.4% | 489.55 ± 2.0% | 1.00 | 1.01 | 4.48 | 2.28 |
| a field path | 39 | 350.35 ± 3.9% | 350.83 ± 4.7% | 410.84 ± 6.2% | 123.20 ± 9.3% | 302.71 ± 1.9% | 901.66 ± 1.9% | 7254.35 ± 0.9% | 351.20 ± 1.5% | 1.00 | 1.00 | 2.84 | 1.16 |
| literal: a word | 7 | 1050.00 ± 2.0% | 1127.32 ± 7.7% | 1944.03 ± 3.2% | 807.46 ± 8.2% | 990.24 ± 3.3% | 1782.00 ± 1.1% | 45484.01 ± 8.0% | 1050.48 ± 11.5% | 0.93 | 1.00 | 1.30 | 1.06 |
| literal: a word that is not there | 8 | 990.58 ± 7.6% | 1067.98 ± 3.0% | 1796.63 ± 2.5% | 757.63 ± 1.2% | 945.06 ± 5.6% | 1693.47 ± 0.9% | 45705.02 ± 1.3% | 988.50 ± 5.8% | 0.93 | 1.00 | 1.31 | 1.05 |
| literal: one of four words | 26 | 398.50 ± 5.3% | 635.44 ± 6.4% | 824.95 ± 5.8% | 65.29 ± 3.6% | 378.39 ± 4.4% | 652.90 ± 3.9% | 26847.82 ± 6.1% | 383.45 ± 5.8% | 0.63 | 1.04 | 6.10 | 1.05 |
| literal: a word in any case | 11 | 736.69 ± 4.0% | 782.08 ± 4.5% | 1097.15 ± 3.7% | 22.09 ± 3.9% | 1021.30 ± 13.2% | refused | 38418.71 ± 2.5% | 727.98 ± 3.8% | 0.94 | 1.01 | 33.35 | 0.72 |
| literal: an href attribute | 12 | 558.70 ± 2.1% | 586.77 ± 2.6% | 754.78 ± 2.6% | 59.84 ± 2.6% | 735.94 ± 2.0% | 1479.82 ± 2.7% | 34931.22 ± 2.4% | 563.22 ± 0.9% | 0.95 | 0.99 | 9.34 | 0.76 |
| literal: a word, second text | 10 | 917.38 ± 7.3% | 1012.44 ± 8.1% | 1624.25 ± 3.3% | 699.97 ± 2.3% | 813.30 ± 14.2% | 1495.62 ± 2.1% | 44074.16 ± 3.2% | 923.97 ± 1.6% | 0.91 | 0.99 | 1.31 | 1.13 |
| class: two capitalized words | 23 | 725.97 ± 2.9% | 785.06 ± 2.7% | 1131.37 ± 8.9% | 154.22 ± 4.7% | 767.24 ± 7.0% | 1400.46 ± 2.7% | 9288.10 ± 2.8% | 725.98 ± 3.2% | 0.92 | 1.00 | 4.71 | 0.95 |
| class: a word that ends in ing | 9 | 898.31 ± 3.1% | 1023.02 ± 4.7% | 1745.98 ± 7.6% | 198.27 ± 2.3% | 1063.38 ± 3.9% | 2118.62 ± 2.0% | 23934.65 ± 1.6% | 903.59 ± 2.1% | 0.88 | 0.99 | 4.53 | 0.84 |
| class: a word in capitals | 16 | 807.75 ± 7.6% | 865.23 ± 11.8% | 1395.08 ± 8.6% | 199.17 ± 7.7% | 1105.03 ± 2.8% | 1945.05 ± 5.6% | 11918.68 ± 2.0% | 814.18 ± 8.3% | 0.93 | 0.99 | 4.06 | 0.73 |
| class: a number | 6 | 992.25 ± 4.5% | 1105.79 ± 2.7% | 2037.82 ± 3.1% | 56.15 ± 4.0% | 1969.29 ± 8.8% | 3537.03 ± 3.8% | 33308.46 ± 13.5% | 992.48 ± 3.5% | 0.90 | 1.00 | 17.67 | 0.50 |
| class: two capitalized words, second text | 23 | 714.53 ± 7.7% | 754.55 ± 6.2% | 1102.57 ± 9.9% | 152.74 ± 8.5% | 755.34 ± 5.0% | 1402.56 ± 3.7% | 9116.40 ± 4.6% | 697.84 ± 6.1% | 0.95 | 1.02 | 4.68 | 0.95 |
| other: a word between two words | 13 | 861.44 ± 4.4% | 906.10 ± 8.3% | 1404.46 ± 4.8% | 202.50 ± 2.0% | 735.34 ± 4.1% | 1487.81 ± 4.9% | 22021.11 ± 4.3% | 864.60 ± 3.3% | 0.95 | 1.00 | 4.25 | 1.17 |
| other: a number before a unit, second text | 15 | 626.57 ± 46.2% | 714.97 ± 2.6% | 980.59 ± 3.0% | 53.74 ± 3.2% | 909.22 ± 7.1% | 1626.38 ± 7.6% | 23330.79 ± 13.6% | 621.17 ± 13.5% | 0.88 | 1.01 | 11.66 | 0.69 |
| other: a heading's start tag | 13 | 571.77 ± 1.7% | 575.19 ± 4.9% | 751.82 ± 2.4% | 56.11 ± 2.0% | 885.63 ± 1.6% | 1591.11 ± 2.1% | 27052.14 ± 12.7% | 572.80 ± 1.9% | 0.99 | 1.00 | 10.19 | 0.65 |
| other: a whole word | 11 | 909.55 ± 2.9% | 974.79 ± 3.9% | 1543.66 ± 2.1% | 176.16 ± 6.8% | 845.08 ± 6.0% | 1515.46 ± 4.2% | 41935.16 ± 7.5% | 903.92 ± 3.6% | 0.93 | 1.01 | 5.16 | 1.08 |
| other: a line's first word, second text | 17 | 832.80 ± 3.8% | 887.24 ± 2.3% | 1420.01 ± 4.7% | 182.09 ± 3.3% | 955.13 ± 4.3% | refused | refused | 834.92 ± 2.1% | 0.94 | 1.00 | 4.57 | 0.87 |
| other: fourteen octets before an x | 16 | 172.38 ± 2.7% | 243.02 ± 4.3% | 280.99 ± 2.9% | 21.07 ± 4.5% | 633.66 ± 17.6% | 705.57 ± 3.3% | 19714.59 ± 4.7% | 170.40 ± 5.8% | 0.71 | 1.01 | 8.18 | 0.27 |
| other: a Greek word | 8 | 665.57 ± 34.1% | 917.60 ± 16.9% | 1460.74 ± 3.8% | 70.51 ± 3.2% | 1917.58 ± 7.8% | 3186.43 ± 10.6% | refused | 681.58 ± 5.0% | 0.73 | 0.98 | 9.44 | 0.35 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 42700.03 ± 2.5% | not timed | not timed | 42675.42 ± 13.4% | 3736.22 ± 43.3% | not timed | not timed | 43166.57 ± 4.3% | | 0.99 | 1.00 | 11.43 |
| 01-literal/sherlock-casei-en | 522 | 39002.35 ± 3.5% | not timed | not timed | 11074.65 ± 1.6% | 50.50 ± 3.3% | not timed | not timed | 38922.20 ± 2.8% | | 1.00 | 3.52 | 772.31 |
| 01-literal/sherlock-ru | 724 | 43921.38 ± 1.4% | not timed | not timed | 40818.58 ± 5.1% | 2347.41 ± 4.5% | not timed | not timed | 43644.25 ± 16.0% | | 1.01 | 1.08 | 18.71 |
| 01-literal/sherlock-casei-ru | 746 | 14024.74 ± 3.4% | not timed | not timed | 8922.12 ± 1.9% | 54.60 ± 4.3% | not timed | not timed | 13997.82 ± 2.9% | | 1.00 | 1.57 | 256.86 |
| 01-literal/sherlock-zh | 30 | 76263.08 ± 1.7% | not timed | not timed | 56093.48 ± 18.0% | 1964.10 ± 4.9% | not timed | not timed | 76554.46 ± 3.1% | | 1.00 | 1.36 | 38.83 |
| 02-literal-alternate/sherlock-en | 714 | 17755.03 ± 4.3% | not timed | not timed | 12686.25 ± 3.7% | 28.06 ± 4.5% | not timed | not timed | 17285.81 ± 5.7% | | 1.03 | 1.40 | 632.75 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2910.08 ± 6.7% | not timed | not timed | 2810.01 ± 4.0% | 17.02 ± 2.6% | not timed | not timed | 2914.26 ± 9.9% | | 1.00 | 1.04 | 170.93 |
| 02-literal-alternate/sherlock-ru | 899 | 11906.55 ± 7.5% | not timed | not timed | 7055.99 ± 4.5% | 36.59 ± 12.5% | not timed | not timed | 11893.32 ± 3.9% | | 1.00 | 1.69 | 325.44 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2689.79 ± 4.1% | not timed | not timed | 1371.84 ± 3.2% | 15.45 ± 3.6% | not timed | not timed | 2661.22 ± 37.7% | | 1.01 | 1.96 | 174.09 |
| 02-literal-alternate/sherlock-zh | 207 | 24995.09 ± 5.6% | not timed | not timed | 15632.75 ± 7.5% | 52.73 ± 16.9% | not timed | not timed | 24734.47 ± 8.7% | | 1.01 | 1.60 | 474.01 |
| 03-date/ascii | 111817 | 177.59 ± 3.3% | not timed | not timed | 112.64 ± 1.2% | 0.30 ± 4.3% | not timed | not timed | 180.50 ± 3.6% | | 0.98 | 1.58 | 590.36 |
| 04-ruff-noqa/real | 84 | 636.47 ± 31.8% | not timed | not timed | 664.09 ± 2.5% | 30.17 ± 5.6% | not timed | not timed | 631.58 ± 3.6% | | 1.01 | 0.96 | 21.10 |
| 04-ruff-noqa/tweaked | 44 | 811.93 ± 9.2% | not timed | not timed | 670.59 ± 4.8% | 469.32 ± 53.6% | not timed | not timed | 827.95 ± 33.3% | | 0.98 | 1.21 | 1.73 |
| 05-lexer-veryl/single | 124800 | 7.20 ± 7.5% | not timed | not timed | 7.69 ± 4.7% | 0.35 ± 4.9% | not timed | not timed | 7.14 ± 4.6% | | 1.01 | 0.94 | 20.52 |
| 06-cloud-flare-redos/original | 107 | 554.93 ± 15.6% | not timed | not timed | 285.94 ± 49.6% | 38.24 ± 9.6% | not timed | not timed | 548.15 ± 25.8% | | 1.01 | 1.94 | 14.51 |
| 06-cloud-flare-redos/simplified-short | 102 | 548.83 ± 19.9% | not timed | not timed | 289.79 ± 52.7% | 41.64 ± 41.1% | not timed | not timed | 565.99 ± 10.5% | | 0.97 | 1.89 | 13.18 |
| 06-cloud-flare-redos/simplified-long | 10000 | 631.82 ± 5.3% | not timed | not timed | 311.60 ± 4.8% | 43.96 ± 1.4% | not timed | not timed | 628.34 ± 3.0% | | 1.01 | 2.03 | 14.37 |
| 07-unicode-character-data/parse-line | 558784 | 341.93 ± 8.7% | not timed | not timed | 245.64 ± 20.3% | 63.69 ± 8.6% | not timed | not timed | 344.12 ± 3.0% | | 0.99 | 1.39 | 5.37 |
| 08-words/all-english | 56691 | 172.74 ± 11.9% | not timed | not timed | 107.02 ± 6.3% | 20.54 ± 13.0% | not timed | not timed | 181.84 ± 6.0% | | 0.95 | 1.61 | 8.41 |
| 08-words/long-english | 839 | 753.17 ± 4.0% | not timed | not timed | 691.03 ± 4.8% | 50.65 ± 4.8% | not timed | not timed | 747.51 ± 6.1% | | 1.01 | 1.09 | 14.87 |
| 09-aws-keys/full | 0 | 672.98 ± 10.7% | not timed | not timed | 722.93 ± 3.0% | 90.86 ± 5.4% | not timed | not timed | 674.38 ± 4.3% | | 1.00 | 0.93 | 7.41 |
| 09-aws-keys/quick | 0 | 1531.23 ± 4.9% | not timed | not timed | 1277.70 ± 11.8% | 555.31 ± 17.7% | not timed | not timed | 1523.91 ± 4.9% | | 1.00 | 1.20 | 2.76 |
| 10-bounded-repeat/letters-en | 1833 | 840.42 ± 4.7% | not timed | not timed | 748.56 ± 5.1% | 30.98 ± 8.3% | not timed | not timed | 855.68 ± 6.2% | | 0.98 | 1.12 | 27.13 |
| 10-bounded-repeat/letters-ru | 3475 | 739.15 ± 1.7% | not timed | not timed | 667.69 ± 1.6% | 33.95 ± 9.6% | not timed | not timed | 732.08 ± 3.6% | | 1.01 | 1.11 | 21.77 |
| 10-bounded-repeat/context | 53 | 120.92 ± 9.0% | not timed | not timed | 94.97 ± 7.1% | 30.11 ± 5.1% | not timed | not timed | 121.97 ± 6.5% | | 0.99 | 1.27 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 789.09 ± 13.4% | not timed | not timed | 750.85 ± 4.6% | 55.28 ± 3.5% | not timed | not timed | 788.47 ± 10.6% | | 1.00 | 1.05 | 14.27 |
| 11-unstructured-to-json/extract | 600 | 73.00 ± 9.2% | not timed | not timed | 101.93 ± 7.5% | 73.65 ± 4.4% | not timed | not timed | 73.08 ± 5.1% | | 1.00 | 0.72 | 0.99 |
| 12-dictionary/single | 1 | 627.18 ± 2.8% | not timed | not timed | 604.42 ± 1.9% | 0.64 ± 8.8% | not timed | not timed | 627.09 ± 2.2% | | 1.00 | 1.04 | 986.32 |
| 14-quadratic/1x | 100 | 38.79 ± 6.4% | not timed | not timed | 16.50 ± 12.2% | 1.40 ± 3.1% | not timed | not timed | 38.68 ± 18.0% | | 1.00 | 2.35 | 27.68 |
| 14-quadratic/2x | 200 | 30.81 ± 68.1% | not timed | not timed | 7.76 ± 45.0% | 0.77 ± 126.7% | not timed | not timed | 31.06 ± 12.7% | | 0.99 | 3.97 | 40.00 |
| 14-quadratic/10x | 1000 | 10.49 ± 8.6% | not timed | not timed | 1.41 ± 4.9% | 0.17 ± 28.8% | not timed | not timed | 10.41 ± 1.5% | | 1.01 | 7.45 | 63.50 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.85 ± 12.1% | not timed | not timed | 0.51 ± 6.0% | 0.80 ± 173.2% | not timed | not timed | 1.85 ± 0.7% | | 1.00 | 3.62 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 176.33 ± 4.2% | not timed | not timed | 20.22 ± 3.9% | 216.57 ± 5.7% | not timed | not timed | 176.41 ± 5.0% | | 1.00 | 8.72 | 0.81 |
| 05-lexer-veryl/compile-single | 1 | 21.85 ± 6.4% | not timed | not timed | 3.75 ± 3.0% | 10.53 ± 9.1% | not timed | not timed | 21.68 ± 1.9% | | 1.01 | 5.82 | 2.08 |
| 07-unicode-character-data/compile | 1 | 171.52 ± 1.1% | not timed | not timed | 37.59 ± 5.1% | 58.77 ± 2.6% | not timed | not timed | 171.57 ± 3.9% | | 1.00 | 4.56 | 2.92 |
| 09-aws-keys/compile-full | 1 | 72.50 ± 2.4% | not timed | not timed | 11.94 ± 4.0% | 36.01 ± 2.9% | not timed | not timed | 73.24 ± 2.4% | | 0.99 | 6.07 | 2.01 |
| 09-aws-keys/compile-quick | 1 | 282.44 ± 8.6% | not timed | not timed | 75.44 ± 3.9% | 211.33 ± 17.4% | not timed | not timed | 283.79 ± 4.1% | | 1.00 | 3.74 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 83.90 ± 4.5% | not timed | not timed | 17.19 ± 2.2% | 26.40 ± 3.2% | not timed | not timed | 85.03 ± 5.5% | | 0.99 | 4.88 | 3.18 |
| 10-bounded-repeat/compile-capitals | 1 | 130.12 ± 1.3% | not timed | not timed | 12.59 ± 3.4% | 37.83 ± 5.1% | not timed | not timed | 131.24 ± 3.4% | | 0.99 | 10.33 | 3.44 |
| 11-unstructured-to-json/compile | 1 | 273.56 ± 5.2% | not timed | not timed | 62.24 ± 3.6% | 108.42 ± 16.5% | not timed | not timed | 272.21 ± 4.2% | | 1.00 | 4.40 | 2.52 |
| 12-dictionary/compile-single | 1 | 0.44 ± 5.2% | not timed | not timed | 0.09 ± 1.8% | 0.14 ± 16.2% | not timed | not timed | 0.44 ± 3.2% | | 1.00 | 4.73 | 3.23 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.12 ± 2.7% | not timed | not timed | 9.28 ± 1.0% | 0.82 ± 26.0% | not timed | not timed | 9.98 ± 7.5% | | 1.01 | 1.09 | 12.35 |
| dictionary/search/english-10 | 690 | 1.84 ± 2.7% | not timed | not timed | 225.49 ± 4.1% | 0.01 ± 2.0% | not timed | not timed | 1.84 ± 2.5% | | 1.00 | 0.0082 | 170.14 |
| dictionary/search/english-15 | 15 | 641.79 ± 0.8% | not timed | not timed | 612.22 ± 3.0% | 0.60 ± 3.6% | not timed | not timed | 640.15 ± 1.0% | | 1.00 | 1.05 | 1076.57 |
| folly/awyer-inn-busted | 1 | 6993.32 ± 5.3% | not timed | not timed | 165.22 ± 8.9% | 70.89 ± 3.8% | not timed | not timed | 6966.78 ± 10.1% | | 1.00 | 42.33 | 98.64 |
| folly/literal-never-match-rare | 0 | 84639.53 ± 1.2% | not timed | not timed | 67293.32 ± 2.9% | 89200.41 ± 0.8% | not timed | not timed | 84957.96 ± 1.3% | | 1.00 | 1.26 | 0.95 |
| folly/literal-never-match-frequent | 0 | 37167.80 ± 12.0% | not timed | not timed | 65067.16 ± 3.5% | 2988.11 ± 0.6% | not timed | not timed | 38543.09 ± 8.6% | | 0.96 | 0.57 | 12.44 |
| folly/literal-never-match-tricksy | 1 | 5486.46 ± 5.4% | not timed | not timed | 8579.45 ± 8.9% | 3769.92 ± 27.0% | not timed | not timed | 5486.70 ± 14.4% | | 1.00 | 0.64 | 1.46 |
| grep/every-line | 239963 | 1810.62 ± 0.7% | not timed | not timed | 1276.59 ± 1.9% | 507.16 ± 14.1% | not timed | not timed | 1810.54 ± 12.1% | | 1.00 | 1.42 | 3.57 |
| grep/long-words-ascii | 5073 | 658.32 ± 0.6% | not timed | not timed | 602.97 ± 0.4% | 65.10 ± 5.1% | not timed | not timed | 656.32 ± 1.0% | | 1.00 | 1.09 | 10.11 |
| imported/leipzig/twain | 811 | 70655.22 ± 2.2% | not timed | not timed | 58500.82 ± 3.8% | 14944.40 ± 7.6% | not timed | not timed | 70958.09 ± 1.7% | | 1.00 | 1.21 | 4.73 |
| imported/leipzig/twain-insensitive | 965 | 19125.91 ± 3.3% | not timed | not timed | 17193.70 ± 5.0% | 63.70 ± 1.7% | not timed | not timed | 19067.66 ± 3.8% | | 1.00 | 1.11 | 300.23 |
| imported/leipzig/shing | 1540 | 41484.36 ± 4.5% | not timed | not timed | 27760.99 ± 2.9% | 52.64 ± 2.2% | not timed | not timed | 41785.40 ± 2.7% | | 0.99 | 1.49 | 788.07 |
| imported/leipzig/huck-saw | 262 | 33588.93 ± 11.4% | not timed | not timed | 23331.48 ± 3.8% | 51.36 ± 4.2% | not timed | not timed | 33664.50 ± 1.8% | | 1.00 | 1.44 | 653.98 |
| imported/leipzig/word-ending-nn | 262 | 696.85 ± 2.7% | not timed | not timed | 704.20 ± 1.9% | 39.65 ± 1.2% | not timed | not timed | 702.54 ± 3.7% | | 0.99 | 0.99 | 17.57 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 15203.05 ± 3.1% | not timed | not timed | 5425.06 ± 3.1% | 15.48 ± 5.6% | not timed | not timed | 15147.59 ± 5.0% | | 1.00 | 2.80 | 981.93 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 28877.48 ± 1.8% | not timed | not timed | 22015.36 ± 4.0% | 29.56 ± 3.7% | not timed | not timed | 28911.31 ± 4.5% | | 1.00 | 1.31 | 976.98 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6453.97 ± 1.1% | not timed | not timed | 1120.91 ± 3.8% | 17.73 ± 3.9% | not timed | not timed | 6429.74 ± 4.6% | | 1.00 | 5.76 | 364.02 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 706.73 ± 0.9% | not timed | not timed | 708.10 ± 2.4% | 18.33 ± 1.5% | not timed | not timed | 712.35 ± 1.2% | | 0.99 | 1.00 | 38.55 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 677.48 ± 5.8% | not timed | not timed | 675.18 ± 7.7% | 15.21 ± 2.3% | not timed | not timed | 673.25 ± 2.5% | | 1.01 | 1.00 | 44.55 |
| imported/leipzig/tom-river | 2 | 15768.59 ± 1.4% | not timed | not timed | 16242.38 ± 1.4% | 49.19 ± 1.4% | not timed | not timed | 15731.83 ± 2.8% | | 1.00 | 0.97 | 320.59 |
| imported/leipzig/ing | 78424 | 671.01 ± 2.1% | not timed | not timed | 633.06 ± 2.0% | 41.83 ± 4.4% | not timed | not timed | 672.73 ± 4.8% | | 1.00 | 1.06 | 16.04 |
| imported/leipzig/ing-whitespace | 55248 | 847.12 ± 5.2% | not timed | not timed | 2655.90 ± 2.0% | 31.48 ± 4.2% | not timed | not timed | 859.89 ± 1.2% | | 0.99 | 0.32 | 26.91 |
| imported/leipzig/awyer-inn | 209 | 854.36 ± 7.2% | not timed | not timed | 16508.95 ± 4.8% | 33.74 ± 5.8% | not timed | not timed | 854.92 ± 4.7% | | 1.00 | 0.0518 | 25.32 |
| imported/leipzig/quotes-bounded | 8886 | 2325.50 ± 1.8% | not timed | not timed | 3664.60 ± 2.4% | 54.40 ± 2.0% | not timed | not timed | 2340.99 ± 1.7% | | 0.99 | 0.63 | 42.75 |
| imported/leipzig/non-ascii-alternate | 2 | 61121.02 ± 2.8% | not timed | not timed | 23944.06 ± 3.3% | 81.64 ± 3.8% | not timed | not timed | 61044.65 ± 3.7% | | 1.00 | 2.55 | 748.65 |
| imported/leipzig/math-symbols | 69 | 4100.20 ± 1.6% | not timed | not timed | 686.40 ± 16.8% | 53.84 ± 4.4% | not timed | not timed | 4058.60 ± 1.6% | | 1.01 | 5.97 | 76.16 |
| imported/leipzig/bounded-strings-ending-z | 0 | 677.19 ± 8.0% | not timed | not timed | 674.70 ± 9.1% | 35.17 ± 4.4% | not timed | not timed | 660.87 ± 6.8% | | 1.02 | 1.00 | 19.25 |
| imported/lh3lh3-reb/uri | 17549 | 973.97 ± 2.0% | not timed | not timed | 1443.84 ± 2.9% | 38.41 ± 4.0% | not timed | not timed | 953.61 ± 0.8% | | 1.02 | 0.67 | 25.36 |
| imported/lh3lh3-reb/email | 15057 | 969.45 ± 3.5% | not timed | not timed | 1404.46 ± 4.6% | 40.82 ± 7.8% | not timed | not timed | 952.41 ± 2.9% | | 1.02 | 0.69 | 23.75 |
| imported/lh3lh3-reb/date | 668 | 1107.38 ± 1.9% | not timed | not timed | 1253.91 ± 3.8% | 68.37 ± 10.0% | not timed | not timed | 1104.30 ± 4.4% | | 1.00 | 0.88 | 16.20 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 905.58 ± 9.8% | not timed | not timed | 515.54 ± 6.3% | 21.74 ± 1.7% | not timed | not timed | 901.58 ± 2.9% | | 1.00 | 1.76 | 41.66 |
| imported/mariomka/email | 92 | 51263.08 ± 4.8% | not timed | not timed | 68370.29 ± 25.7% | 48.49 ± 4.8% | not timed | not timed | 50394.35 ± 63.6% | | 1.02 | 0.75 | 1057.12 |
| imported/mariomka/uri | 5301 | 8585.46 ± 2.1% | not timed | not timed | 9050.60 ± 10.3% | 48.66 ± 3.8% | not timed | not timed | 8578.84 ± 3.7% | | 1.00 | 0.95 | 176.46 |
| imported/mariomka/ip | 5 | 2356.82 ± 5.8% | not timed | not timed | 2712.09 ± 3.0% | 32.64 ± 2.7% | not timed | not timed | 2374.27 ± 2.1% | | 0.99 | 0.87 | 72.21 |
| imported/rsc/no-exponential | 0 | 1102.09 ± 6.1% | not timed | not timed | 699.42 ± 4.2% | 34.05 ± 6.4% | not timed | not timed | 1104.57 ± 8.7% | | 1.00 | 1.58 | 32.37 |
| imported/rsc/literal | 1 | 1312.29 ± 9.6% | not timed | not timed | 3011.09 ± 7.9% | 300.21 ± 7.1% | not timed | not timed | 1244.00 ± 23.2% | | 1.05 | 0.44 | 4.37 |
| imported/rsc/not-literal | 2 | 1425.12 ± 9.2% | not timed | not timed | 1356.79 ± 2.4% | 71.81 ± 13.2% | not timed | not timed | 1446.84 ± 5.6% | | 0.98 | 1.05 | 19.85 |
| imported/rsc/match-class | 1 | 2563.12 ± 4.5% | not timed | not timed | 3088.44 ± 7.1% | 89.79 ± 11.2% | not timed | not timed | 2539.31 ± 3.1% | | 1.01 | 0.83 | 28.55 |
| imported/rsc/match-class-in-range | 1 | 2569.25 ± 7.4% | not timed | not timed | 4737.82 ± 4.6% | 97.39 ± 3.7% | not timed | not timed | 2578.10 ± 6.0% | | 1.00 | 0.54 | 26.38 |
| imported/rsc/match-class-unicode | 1 | 667.75 ± 3.3% | not timed | not timed | 638.24 ± 6.5% | 113.28 ± 12.2% | not timed | not timed | 670.80 ± 3.0% | | 1.00 | 1.05 | 5.89 |
| imported/rsc/anchored-literal-short-non-match | 0 | 2474.73 ± 9.7% | not timed | not timed | 1734.03 ± 3.9% | 440.68 ± 3.2% | not timed | not timed | 2482.79 ± 22.3% | | 1.00 | 1.43 | 5.62 |
| imported/rsc/anchored-literal-long-non-match | 0 | 37398.07 ± 1.9% | not timed | not timed | 25294.28 ± 1.0% | 6693.07 ± 6.4% | not timed | not timed | 37306.97 ± 1.9% | | 1.00 | 1.48 | 5.59 |
| imported/rsc/anchored-literal-short-match | 4 | 1256.19 ± 11.2% | not timed | not timed | 934.22 ± 2.6% | 136.08 ± 45.1% | not timed | not timed | 1263.91 ± 59.1% | | 0.99 | 1.34 | 9.23 |
| imported/rsc/anchored-literal-long-match | 4 | 19033.71 ± 5.8% | not timed | not timed | 14204.62 ± 3.2% | 1999.19 ± 8.0% | not timed | not timed | 18878.48 ± 4.5% | | 1.01 | 1.34 | 9.52 |
| imported/rsc/one-pass-short | 17 | 708.56 ± 1.9% | not timed | not timed | 407.43 ± 0.8% | 47.96 ± 37.0% | not timed | not timed | 710.95 ± 2.0% | | 1.00 | 1.74 | 14.77 |
| imported/rsc/one-pass-short-not | 17 | 445.55 ± 4.7% | not timed | not timed | 383.91 ± 3.3% | 43.00 ± 3.9% | not timed | not timed | 448.19 ± 4.2% | | 0.99 | 1.16 | 10.36 |
| imported/rsc/one-pass-long-prefix | 26 | 570.78 ± 15.0% | not timed | not timed | 509.45 ± 3.3% | 162.11 ± 5.7% | not timed | not timed | 565.90 ± 7.8% | | 1.01 | 1.12 | 3.52 |
| imported/rsc/one-pass-long-prefix-not | 26 | 532.99 ± 10.7% | not timed | not timed | 508.75 ± 4.0% | 109.17 ± 12.7% | not timed | not timed | 571.06 ± 8.0% | | 0.93 | 1.05 | 4.88 |
| imported/rsc/long-needle1 | 31 | 84872.38 ± 6.3% | not timed | not timed | 65275.23 ± 3.5% | 5.72 ± 4.1% | not timed | not timed | 84726.23 ± 4.0% | | 1.00 | 1.30 | 14827.67 |
| imported/rsc/long-needle2 | 31 | 84905.60 ± 3.4% | not timed | not timed | 344.96 ± 4.4% | 5.55 ± 7.6% | not timed | not timed | 82990.17 ± 4.8% | | 1.02 | 246.13 | 15286.78 |
| imported/rsc/easy0-32 | 26 | 1855.33 ± 4.2% | not timed | not timed | 2760.85 ± 3.9% | 207.25 ± 11.7% | not timed | not timed | 1895.69 ± 4.0% | | 0.98 | 0.67 | 8.95 |
| imported/rsc/easy0-1k | 26 | 29535.90 ± 6.6% | not timed | not timed | 29883.08 ± 1.4% | 3143.07 ± 12.0% | not timed | not timed | 29986.14 ± 3.4% | | 0.98 | 0.99 | 9.40 |
| imported/rsc/easy0-32k | 26 | 80033.23 ± 3.9% | not timed | not timed | 62257.66 ± 1.5% | 37221.75 ± 20.1% | not timed | not timed | 80507.01 ± 1.1% | | 0.99 | 1.29 | 2.15 |
| imported/rsc/easy0-1mb | 26 | 80867.34 ± 1.6% | not timed | not timed | 65125.95 ± 1.0% | 95884.39 ± 3.4% | not timed | not timed | 81024.16 ± 2.4% | | 1.00 | 1.24 | 0.84 |
| imported/rsc/easy1-32 | 19 | 1242.13 ± 6.3% | not timed | not timed | 1191.43 ± 4.0% | 193.62 ± 13.6% | not timed | not timed | 1213.25 ± 3.7% | | 1.02 | 1.04 | 6.42 |
| imported/rsc/easy1-1k | 19 | 25692.82 ± 4.6% | not timed | not timed | 26119.46 ± 1.0% | 3424.62 ± 12.8% | not timed | not timed | 24799.24 ± 19.5% | | 1.04 | 0.98 | 7.50 |
| imported/rsc/easy1-32k | 19 | 820789.44 ± 4.0% | not timed | not timed | 789337.04 ± 4.7% | 40201.10 ± 24.3% | not timed | not timed | 795658.01 ± 3.2% | | 1.03 | 1.04 | 20.42 |
| imported/rsc/easy1-1mb | 19 | 26645002.63 ± 2.5% | not timed | not timed | 26143190.53 ± 3.2% | 95576.84 ± 3.8% | not timed | not timed | 25263296.12 ± 3.5% | | 1.05 | 1.02 | 278.78 |
| imported/rsc/medium-32 | 27 | 1146.60 ± 2.7% | not timed | not timed | 1061.46 ± 4.2% | 107.17 ± 7.2% | not timed | not timed | 1107.46 ± 10.2% | | 1.04 | 1.08 | 10.70 |
| imported/rsc/medium-1k | 27 | 20723.10 ± 1.9% | not timed | not timed | 19916.26 ± 0.9% | 112.74 ± 1.5% | not timed | not timed | 19967.21 ± 1.9% | | 1.04 | 1.04 | 183.81 |
| imported/rsc/medium-32k | 27 | 643481.02 ± 3.8% | not timed | not timed | 636995.02 ± 3.8% | 76.53 ± 30.9% | not timed | not timed | 618702.39 ± 3.3% | | 1.04 | 1.01 | 8408.62 |
| imported/rsc/medium-1mb | 27 | 20691836.60 ± 2.5% | not timed | not timed | 20289631.41 ± 4.3% | 76.40 ± 1.9% | not timed | not timed | 19988019.44 ± 3.2% | | 1.04 | 1.02 | 270821.14 |
| imported/rsc/hard-32 | 58 | 552.92 ± 1.8% | not timed | not timed | 469.30 ± 1.7% | 73.28 ± 6.0% | not timed | not timed | 539.52 ± 7.3% | | 1.02 | 1.18 | 7.55 |
| imported/rsc/hard-1k | 27 | 19459.72 ± 1.8% | not timed | not timed | 18895.06 ± 6.2% | 59.11 ± 17.1% | not timed | not timed | 18368.91 ± 2.8% | | 1.06 | 1.03 | 329.22 |
| imported/rsc/hard-32k | 27 | 606938.22 ± 4.2% | not timed | not timed | 637209.30 ± 2.9% | 47.50 ± 3.5% | not timed | not timed | 583278.80 ± 3.6% | | 1.04 | 0.95 | 12776.72 |
| imported/rsc/hard-1mb | 51 | 11264940.68 ± 2.8% | not timed | not timed | 10634673.83 ± 3.3% | 48.07 ± 3.5% | not timed | not timed | 10934208.53 ± 1.3% | | 1.03 | 1.06 | 234364.51 |
| imported/rsc/reallyhard0-32 | 58 | 363.16 ± 0.8% | not timed | not timed | 324.80 ± 3.5% | 72.89 ± 10.2% | not timed | not timed | 364.10 ± 5.2% | | 1.00 | 1.12 | 4.98 |
| imported/rsc/reallyhard0-1k | 27 | 687.25 ± 1.7% | not timed | not timed | 675.17 ± 3.4% | 60.18 ± 0.7% | not timed | not timed | 689.55 ± 4.7% | | 1.00 | 1.02 | 11.42 |
| imported/rsc/reallyhard0-32k | 27 | 692.93 ± 2.5% | not timed | not timed | 692.50 ± 2.3% | 46.96 ± 4.5% | not timed | not timed | 689.96 ± 2.0% | | 1.00 | 1.00 | 14.76 |
| imported/rsc/reallyhard0-1mb | 51 | 693.06 ± 1.6% | not timed | not timed | 689.47 ± 1.7% | 47.30 ± 4.6% | not timed | not timed | 693.15 ± 2.8% | | 1.00 | 1.01 | 14.65 |
| imported/rsc/reallyreallyhard0-32 | 47 | 415.41 ± 4.2% | not timed | not timed | 260.35 ± 0.6% | 88.74 ± 9.1% | not timed | not timed | 423.92 ± 4.0% | | 0.98 | 1.60 | 4.68 |
| imported/rsc/reallyreallyhard0-1k | 16 | 11342.27 ± 5.8% | not timed | not timed | 10572.13 ± 4.4% | 49.51 ± 2.3% | not timed | not timed | 10885.30 ± 13.8% | | 1.04 | 1.07 | 229.08 |
| imported/rsc/reallyreallyhard0-32k | 16 | 73378.29 ± 6.7% | not timed | not timed | 56772.55 ± 5.5% | 38.74 ± 1.3% | not timed | not timed | 72849.54 ± 4.2% | | 1.01 | 1.29 | 1894.08 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 97493.40 ± 22.2% | not timed | not timed | 65411.59 ± 2.4% | 39.19 ± 1.4% | not timed | not timed | 96968.32 ± 1.7% | | 1.01 | 1.49 | 2487.63 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 406.77 ± 2.6% | not timed | not timed | 268.29 ± 6.1% | 84.19 ± 7.5% | not timed | not timed | 399.85 ± 3.6% | | 1.02 | 1.52 | 4.83 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 9072.85 ± 12.2% | not timed | not timed | 10310.94 ± 1.5% | 49.21 ± 2.5% | not timed | not timed | 9167.42 ± 1.9% | | 0.99 | 0.88 | 184.37 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 68497.00 ± 1.7% | not timed | not timed | 55479.04 ± 3.9% | 39.02 ± 1.0% | not timed | not timed | 68574.23 ± 3.4% | | 1.00 | 1.23 | 1755.42 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 81406.02 ± 4.1% | not timed | not timed | 65222.15 ± 8.4% | 38.86 ± 6.2% | not timed | not timed | 80905.57 ± 11.0% | | 1.01 | 1.25 | 2094.78 |
| imported/sherlock/name-sherlock | 776 | 63459.26 ± 2.3% | not timed | not timed | 50604.01 ± 2.4% | 16220.10 ± 10.1% | not timed | not timed | 63530.94 ± 2.5% | | 1.00 | 1.25 | 3.91 |
| imported/sherlock/name-holmes | 2766 | 36669.95 ± 0.9% | not timed | not timed | 35425.60 ± 3.9% | 4945.26 ± 3.1% | not timed | not timed | 37079.46 ± 2.0% | | 0.99 | 1.04 | 7.42 |
| imported/sherlock/name-sherlock-holmes | 1365 | 64541.69 ± 6.0% | not timed | not timed | 51648.46 ± 29.5% | 12661.63 ± 6.2% | not timed | not timed | 64961.53 ± 1.0% | | 0.99 | 1.25 | 5.10 |
| imported/sherlock/name-sherlock-casei | 816 | 63758.10 ± 13.8% | not timed | not timed | 14197.86 ± 1.5% | 50.79 ± 20.6% | not timed | not timed | 64665.28 ± 8.3% | | 0.99 | 4.49 | 1255.29 |
| imported/sherlock/name-holmes-casei | 2802 | 30955.14 ± 2.7% | not timed | not timed | 8746.74 ± 4.2% | 61.69 ± 3.9% | not timed | not timed | 30930.38 ± 1.5% | | 1.00 | 3.54 | 501.81 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 51727.30 ± 7.1% | not timed | not timed | 13777.59 ± 1.5% | 50.56 ± 6.0% | not timed | not timed | 51512.79 ± 2.9% | | 1.00 | 3.75 | 1023.05 |
| imported/sherlock/name-whitespace | 1461 | 37016.20 ± 1.7% | not timed | not timed | 35591.63 ± 1.7% | 11381.95 ± 15.3% | not timed | not timed | 37185.27 ± 6.3% | | 1.00 | 1.04 | 3.25 |
| imported/sherlock/name-alt1 | 1142 | 42848.18 ± 9.5% | not timed | not timed | 43564.49 ± 2.9% | 6529.97 ± 19.0% | not timed | not timed | 42686.67 ± 11.9% | | 1.00 | 0.98 | 6.56 |
| imported/sherlock/name-alt2 | 3542 | 27568.27 ± 81.0% | not timed | not timed | 11687.89 ± 23.0% | 50.53 ± 121.1% | not timed | not timed | 27428.29 ± 30.8% | | 1.01 | 2.36 | 545.58 |
| imported/sherlock/name-alt3 | 4507 | 16427.33 ± 46.4% | not timed | not timed | 10693.76 ± 4.1% | 16.17 ± 62.8% | not timed | not timed | 16491.22 ± 2.9% | | 1.00 | 1.54 | 1015.71 |
| imported/sherlock/name-alt3-casei | 4593 | 2413.08 ± 34.6% | not timed | not timed | 1571.47 ± 12.4% | 10.42 ± 4.5% | not timed | not timed | 2399.17 ± 19.6% | | 1.01 | 1.54 | 231.63 |
| imported/sherlock/name-alt4 | 3686 | 12264.30 ± 53.8% | not timed | not timed | 9041.41 ± 10.4% | 51.30 ± 39.1% | not timed | not timed | 12195.60 ± 18.0% | | 1.01 | 1.36 | 239.07 |
| imported/sherlock/name-alt4-casei | 4254 | 6689.94 ± 11.7% | not timed | not timed | 4784.19 ± 1.5% | 30.31 ± 20.4% | not timed | not timed | 6868.48 ± 3.8% | | 0.97 | 1.40 | 220.74 |
| imported/sherlock/name-alt5 | 4028 | 21484.29 ± 7.0% | not timed | not timed | 10969.02 ± 7.0% | 35.21 ± 15.7% | not timed | not timed | 21368.71 ± 17.7% | | 1.01 | 1.96 | 610.18 |
| imported/sherlock/name-alt5-casei | 4104 | 9143.94 ± 2.2% | not timed | not timed | 3652.61 ± 2.4% | 22.34 ± 23.0% | not timed | not timed | 9042.61 ± 2.9% | | 1.01 | 2.50 | 409.30 |
| imported/sherlock/no-match-uncommon | 0 | 87704.99 ± 1.2% | not timed | not timed | 87560.53 ± 0.7% | 77139.19 ± 5.4% | not timed | not timed | 87327.21 ± 2.2% | | 1.00 | 1.00 | 1.14 |
| imported/sherlock/no-match-common | 0 | 85366.66 ± 2.3% | not timed | not timed | 86946.11 ± 3.3% | 2288.06 ± 1.7% | not timed | not timed | 85074.57 ± 1.8% | | 1.00 | 0.98 | 37.31 |
| imported/sherlock/no-match-really-common | 0 | 59489.46 ± 6.0% | not timed | not timed | 64140.05 ± 5.0% | 2287.01 ± 3.1% | not timed | not timed | 59082.58 ± 1.6% | | 1.01 | 0.93 | 26.01 |
| imported/sherlock/the-lower | 21654 | 3803.48 ± 8.2% | not timed | not timed | 3841.91 ± 3.7% | 339.46 ± 16.1% | not timed | not timed | 3838.37 ± 0.9% | | 0.99 | 0.99 | 11.20 |
| imported/sherlock/the-upper | 2223 | 25332.08 ± 7.4% | not timed | not timed | 32865.55 ± 1.7% | 3985.45 ± 21.1% | not timed | not timed | 25312.23 ± 3.1% | | 1.00 | 0.77 | 6.36 |
| imported/sherlock/the-casei | 23961 | 3489.08 ± 0.6% | not timed | not timed | 1638.32 ± 1.7% | 55.53 ± 25.1% | not timed | not timed | 3484.27 ± 1.0% | | 1.00 | 2.13 | 62.83 |
| imported/sherlock/everything-greedy | 581881 | 354.42 ± 2.1% | not timed | not timed | 207.93 ± 3.1% | 45.18 ± 49.0% | not timed | not timed | 345.58 ± 3.2% | | 1.03 | 1.70 | 7.84 |
| imported/sherlock/everything-greedy-nl | 594933 | 529.62 ± 6.5% | not timed | not timed | 276.51 ± 4.6% | 51.15 ± 1.0% | not timed | not timed | 532.82 ± 1.6% | | 0.99 | 1.92 | 10.35 |
| imported/sherlock/letters | 447175 | 91.33 ± 19.4% | not timed | not timed | 41.31 ± 3.1% | 7.52 ± 29.7% | not timed | not timed | 92.67 ± 14.3% | | 0.99 | 2.21 | 12.15 |
| imported/sherlock/letters-upper | 14180 | 516.95 ± 1.0% | not timed | not timed | 411.92 ± 1.2% | 41.34 ± 34.6% | not timed | not timed | 515.53 ± 4.2% | | 1.00 | 1.25 | 12.50 |
| imported/sherlock/letters-lower | 432995 | 92.77 ± 48.5% | not timed | not timed | 40.09 ± 1.9% | 7.91 ± 40.0% | not timed | not timed | 90.81 ± 2.7% | | 1.02 | 2.31 | 11.73 |
| imported/sherlock/words | 447639 | 148.20 ± 2.9% | not timed | not timed | 100.26 ± 1.3% | 19.24 ± 15.7% | not timed | not timed | 148.55 ± 2.0% | | 1.00 | 1.48 | 7.70 |
| imported/sherlock/before-holmes | 4073 | 18108.54 ± 3.5% | not timed | not timed | 15701.99 ± 1.7% | 35.25 ± 3.0% | not timed | not timed | 18267.88 ± 1.3% | | 0.99 | 1.15 | 513.66 |
| imported/sherlock/before-after-holmes | 2593 | 18308.87 ± 5.4% | not timed | not timed | 18218.36 ± 7.9% | 34.90 ± 2.0% | not timed | not timed | 18269.66 ± 1.6% | | 1.00 | 1.00 | 524.67 |
| imported/sherlock/holmes-cochar-watson | 150 | 11429.66 ± 12.6% | not timed | not timed | 9281.60 ± 0.5% | 50.10 ± 2.4% | not timed | not timed | 11518.62 ± 0.6% | | 0.99 | 1.23 | 228.13 |
| imported/sherlock/holmes-coword-watson | 14309 | 1442.49 ± 0.5% | not timed | not timed | 1416.22 ± 0.5% | 10.63 ± 1.1% | not timed | not timed | 1445.04 ± 0.5% | | 1.00 | 1.02 | 135.64 |
| imported/sherlock/quotes | 14437 | 1603.86 ± 6.5% | not timed | not timed | 2673.86 ± 11.2% | 50.76 ± 12.8% | not timed | not timed | 1605.56 ± 3.1% | | 1.00 | 0.60 | 31.59 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 687.88 ± 3.1% | not timed | not timed | 37923.75 ± 4.2% | 57.92 ± 1.2% | not timed | not timed | 681.18 ± 2.2% | | 1.01 | 0.0181 | 11.88 |
| imported/sherlock/word-ending-n | 35297 | 535.85 ± 1.4% | not timed | not timed | 461.60 ± 0.6% | 35.67 ± 39.2% | not timed | not timed | 539.09 ± 3.7% | | 0.99 | 1.16 | 15.02 |
| imported/sherlock/repeated-class-negation | 2130 | 23313.06 ± 1.6% | not timed | not timed | 22118.23 ± 11.0% | 14.98 ± 1.2% | not timed | not timed | 23215.09 ± 6.8% | | 1.00 | 1.05 | 1556.13 |
| imported/sherlock/ing-suffix | 20547 | 665.48 ± 1.7% | not timed | not timed | 584.60 ± 2.9% | 41.87 ± 34.3% | not timed | not timed | 666.98 ± 3.4% | | 1.00 | 1.14 | 15.90 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 703.03 ± 4.0% | not timed | not timed | 3518.80 ± 1.6% | 31.26 ± 3.6% | not timed | not timed | 706.56 ± 0.5% | | 0.99 | 0.20 | 22.49 |
| opt/accelerate/whole-line | 239963 | 636.22 ± 2.6% | not timed | not timed | 481.60 ± 3.6% | 122.85 ± 16.1% | not timed | not timed | 632.08 ± 2.2% | | 1.01 | 1.32 | 5.18 |
| opt/accelerate/non-dna | 16745 | 561.56 ± 2.1% | not timed | not timed | 523.72 ± 3.1% | 45.69 ± 27.9% | not timed | not timed | 563.38 ± 11.2% | | 1.00 | 1.07 | 12.29 |
| opt/backtrack/words-english | 40536 | 174.56 ± 4.1% | not timed | not timed | 132.40 ± 3.4% | 29.97 ± 9.1% | not timed | not timed | 173.99 ± 3.9% | | 1.00 | 1.32 | 5.82 |
| opt/fixed-length/too-small-ascii | 0 | 545.86 ± 3.0% | not timed | not timed | 1065.07 ± 3.2% | 151.78 ± 2.9% | not timed | not timed | 545.15 ± 2.7% | | 1.00 | 0.51 | 3.60 |
| opt/fixed-length/too-big-ascii | 0 | 6141.49 ± 4.1% | not timed | not timed | 8487.29 ± 1.0% | 203.64 ± 3.5% | not timed | not timed | 6199.35 ± 3.1% | | 0.99 | 0.72 | 30.16 |
| opt/fixed-length/go33484-1 | 0 | 1175655.67 ± 2.9% | not timed | not timed | 1633736.57 ± 1.5% | 116659.85 ± 2.0% | not timed | not timed | 1181090.42 ± 3.3% | | 1.00 | 0.72 | 10.08 |
| opt/fixed-length/go33484-2 | 0 | 1196375.16 ± 7.0% | not timed | not timed | 1636839.28 ± 3.8% | 41220.80 ± 6.6% | not timed | not timed | 1186701.86 ± 1.2% | | 1.01 | 0.73 | 29.02 |
| opt/fixed-length/go33484-3 | 0 | 2872.97 ± 3.5% | not timed | not timed | 163833.06 ± 1.3% | 1235.62 ± 1.7% | not timed | not timed | 2871.13 ± 1.2% | | 1.00 | 0.0175 | 2.33 |
| opt/literal-alt/one-pattern | 1 | 685.61 ± 2.3% | not timed | not timed | 680.36 ± 1.7% | 0.60 ± 1.6% | not timed | not timed | 682.31 ± 1.6% | | 1.00 | 1.01 | 1133.46 |
| opt/onepass/fn-predicate | 916 | 566.85 ± 2.1% | not timed | not timed | 488.35 ± 4.0% | 271.22 ± 13.0% | not timed | not timed | 570.35 ± 5.7% | | 0.99 | 1.16 | 2.09 |
| opt/onepass/first-three-words-english | 35128 | 231.98 ± 4.3% | not timed | not timed | 287.61 ± 3.3% | 108.71 ± 8.0% | not timed | not timed | 228.11 ± 6.4% | | 1.02 | 0.81 | 2.13 |
| opt/prefilter/literal-english | 1 | 86742.40 ± 2.3% | not timed | not timed | 65725.54 ± 8.0% | 33921.40 ± 7.9% | not timed | not timed | 86709.72 ± 6.6% | | 1.00 | 1.32 | 2.56 |
| opt/prefilter/literal-casei-english | 1 | 66514.98 ± 7.6% | not timed | not timed | 17794.97 ± 3.9% | 50.83 ± 1.8% | not timed | not timed | 66812.62 ± 2.5% | | 1.00 | 3.74 | 1308.51 |
| opt/prefilter/literal-russian | 1 | 88009.16 ± 1.1% | not timed | not timed | 66263.19 ± 4.8% | 4060.55 ± 5.0% | not timed | not timed | 88313.30 ± 1.1% | | 1.00 | 1.33 | 21.67 |
| opt/prefilter/literal-casei-russian | 1 | 35661.96 ± 0.5% | not timed | not timed | 12746.14 ± 1.0% | 55.37 ± 3.7% | not timed | not timed | 35720.00 ± 0.9% | | 1.00 | 2.80 | 644.07 |
| opt/prefilter/rust-functions | 948 | 19611.10 ± 7.5% | not timed | not timed | 15873.03 ± 0.4% | 2383.85 ± 1.6% | not timed | not timed | 19677.37 ± 3.4% | | 1.00 | 1.24 | 8.23 |
| opt/reverse-anchored/word-end | 1 | 50161216.06 ± 1.9% | not timed | not timed | 35405974.10 ± 3.6% | 80.20 ± 3.0% | not timed | not timed | 50015523.40 ± 1.6% | | 1.00 | 1.42 | 625414.99 |
| opt/reverse-inner/holmes | 2593 | 18777.29 ± 0.8% | not timed | not timed | 18638.89 ± 0.9% | 35.39 ± 2.8% | not timed | not timed | 18831.32 ± 0.4% | | 1.00 | 1.01 | 530.52 |
| opt/reverse-inner/email | 47 | 88927.03 ± 1.7% | not timed | not timed | 93746.59 ± 3.9% | 47.28 ± 2.0% | not timed | not timed | 88469.79 ± 5.0% | | 1.01 | 0.95 | 1880.96 |
| opt/reverse-inner/factored-prefix | 3542 | 677.89 ± 2.7% | not timed | not timed | 663.08 ± 1.7% | 19.05 ± 1.1% | not timed | not timed | 677.13 ± 2.4% | | 1.00 | 1.02 | 35.58 |
| opt/reverse-inner/no-quadratic-backward | 0 | 6543.67 ± 7.1% | not timed | not timed | 687.63 ± 5.4% | 115.42 ± 10.4% | not timed | not timed | 6594.20 ± 5.0% | | 0.99 | 9.52 | 56.70 |
| opt/reverse-inner/no-quadratic-forward | 0 | 795.35 ± 5.4% | not timed | not timed | 321.76 ± 4.9% | 37.60 ± 8.7% | not timed | not timed | 809.07 ± 2.4% | | 0.98 | 2.47 | 21.15 |
| opt/reverse-suffix/holmes | 4073 | 18606.59 ± 4.0% | not timed | not timed | 15975.66 ± 2.9% | 34.74 ± 8.6% | not timed | not timed | 18496.83 ± 5.5% | | 1.01 | 1.16 | 535.56 |
| opt/reverse-suffix/no-quadratic | 0 | 6566.95 ± 1.6% | not timed | not timed | 690.52 ± 5.8% | 116.66 ± 0.9% | not timed | not timed | 6560.51 ± 3.5% | | 1.00 | 9.51 | 56.29 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 205.67 ± 1.1% | not timed | not timed | 255.11 ± 0.8% | 20.57 ± 15.0% | not timed | not timed | 207.80 ± 2.1% | | 0.99 | 0.81 | 10.00 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 207.02 ± 4.6% | not timed | not timed | 256.05 ± 3.1% | 21.62 ± 8.2% | not timed | not timed | 207.15 ± 1.9% | | 1.00 | 0.81 | 9.58 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.46 ± 3.8% | not timed | not timed | 0.78 ± 1.2% | 163.23 ± 2.6% | not timed | not timed | 0.46 ± 1.5% | | 0.99 | 0.58 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 366.23 ± 0.8% | not timed | not timed | 350.65 ± 0.6% | 151.03 ± 2.3% | not timed | not timed | 365.41 ± 10.2% | | 1.00 | 1.04 | 2.42 |
| reported/i13-subset-regex/original-ascii | 4094 | 14510.87 ± 3.3% | not timed | not timed | 5378.00 ± 1.2% | 14.82 ± 2.4% | not timed | not timed | 14574.18 ± 2.3% | | 1.00 | 2.70 | 978.98 |
| reported/i13-subset-regex/original-unicode | 4094 | 14480.67 ± 4.0% | not timed | not timed | 282.04 ± 3.8% | 14.85 ± 4.7% | not timed | not timed | 14578.18 ± 2.1% | | 0.99 | 51.34 | 974.80 |
| reported/i13-subset-regex/big-ascii | 1955 | 13451.01 ± 1.5% | not timed | not timed | 74.86 ± 4.4% | 12.91 ± 2.1% | not timed | not timed | 13402.87 ± 2.4% | | 1.00 | 179.68 | 1041.82 |
| reported/i13-subset-regex/big-unicode | 1955 | 13538.40 ± 7.6% | not timed | not timed | 13.08 ± 56.7% | 12.72 ± 10.3% | not timed | not timed | 13486.17 ± 1.8% | | 1.00 | 1034.66 | 1064.41 |
| reported/i13-subset-regex/huge-ascii | 55 | 12440.38 ± 2.8% | not timed | not timed | 12.93 ± 2.7% | 12.02 ± 1.2% | not timed | not timed | 12501.59 ± 1.1% | | 1.00 | 962.46 | 1035.12 |
| reported/i13-subset-regex/huge-unicode | 55 | 12423.75 ± 2.3% | not timed | not timed | 13.10 ± 1.1% | 12.01 ± 1.5% | not timed | not timed | 12362.10 ± 6.9% | | 1.00 | 948.11 | 1034.32 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.35 ± 0.6% | not timed | not timed | 12.04 ± 1.7% | 11.80 ± 8.7% | not timed | not timed | 5.59 ± 1.5% | | 0.96 | 0.44 | 0.45 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.14 ± 1.4% | not timed | not timed | 13.11 ± 1.4% | 11.97 ± 4.8% | not timed | not timed | 7.35 ± 1.2% | | 0.97 | 0.54 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 655.18 ± 5.5% | not timed | not timed | 191.19 ± 4.6% | 9.90 ± 3.1% | not timed | not timed | 661.31 ± 1.8% | | 0.99 | 3.43 | 66.18 |
| reported/i787-keywords/opt-ascii | 5674 | 659.48 ± 1.6% | not timed | not timed | 329.43 ± 1.6% | 16.04 ± 41.3% | not timed | not timed | 659.45 ± 1.5% | | 1.00 | 2.00 | 41.10 |
| slow/quadratic-regex-1x | 100 | 10.27 ± 1.7% | not timed | not timed | 8.22 ± 1.6% | 0.08 ± 1.4% | not timed | not timed | 10.34 ± 6.6% | | 0.99 | 1.25 | 135.35 |
| slow/quadratic-regex-2x | 199 | 4.44 ± 1.4% | not timed | not timed | 3.85 ± 0.6% | 0.02 ± 0.3% | not timed | not timed | 4.44 ± 2.3% | | 1.00 | 1.15 | 224.81 |
| slow/quadratic-haystack-1x | 100 | 38.65 ± 2.3% | not timed | not timed | 16.59 ± 1.8% | 1.44 ± 9.0% | not timed | not timed | 38.75 ± 4.8% | | 1.00 | 2.33 | 26.91 |
| slow/quadratic-haystack-2x | 200 | 30.77 ± 3.9% | not timed | not timed | 7.71 ± 4.2% | 0.78 ± 4.8% | not timed | not timed | 30.58 ± 8.4% | | 1.01 | 3.99 | 39.61 |
| unicode/codepoints/any-one | 1112064 | 496.88 ± 4.3% | not timed | not timed | 325.68 ± 3.1% | 27.64 ± 21.9% | not timed | not timed | 494.45 ± 3.7% | | 1.00 | 1.53 | 17.98 |
| unicode/codepoints/any-all | 4382592 | 328.41 ± 2.4% | not timed | not timed | 330.01 ± 4.8% | 168.16 ± 3.5% | not timed | not timed | 328.88 ± 1.6% | | 1.00 | 1.00 | 1.95 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.38 ± 2.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 695.38 ± 0.8% | not timed | not timed | 692.78 ± 2.4% | 206.57 ± 2.1% | not timed | not timed | 691.95 ± 1.6% | | 1.00 | 1.00 | 3.37 |
| unicode/overlapping-words/ascii | 6156 | 41.85 ± 4.0% | not timed | not timed | 54.83 ± 2.8% | 6.00 ± 1.8% | not timed | not timed | 41.58 ± 1.7% | | 1.01 | 0.76 | 6.98 |
| unicode/overlapping-words/english | 6156 | 2.04 ± 1.7% | not timed | not timed | 5.00 ± 1.7% | 3.58 ± 3.3% | not timed | not timed | 2.11 ± 2.4% | | 0.97 | 0.41 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.86 ± 7.4% | not timed | not timed | 4.86 ± 1.6% | 8.74 ± 12.9% | not timed | not timed | 1.90 ± 1.2% | | 0.98 | 0.38 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 169.51 ± 2.4% | not timed | not timed | 92.04 ± 2.5% | 18.51 ± 8.7% | not timed | not timed | 170.49 ± 6.9% | | 0.99 | 1.84 | 9.16 |
| unicode/word/boundary-long-english | 3466 | 696.85 ± 2.5% | not timed | not timed | 681.27 ± 3.0% | 48.09 ± 2.5% | not timed | not timed | 700.26 ± 1.9% | | 1.00 | 1.02 | 14.49 |
| unicode/word/around-holmes-english | 27 | 79306.96 ± 1.8% | not timed | not timed | 62624.77 ± 2.6% | 33.47 ± 32.3% | not timed | not timed | 79201.44 ± 1.2% | | 1.00 | 1.27 | 2369.62 |
| wild/bibleref/long | 874 | 648.74 ± 4.0% | not timed | not timed | 658.36 ± 2.8% | 10.75 ± 0.8% | not timed | not timed | 649.71 ± 0.9% | | 1.00 | 0.99 | 60.33 |
| wild/bibleref/short | 30 | 32.20 ± 5.9% | not timed | not timed | 43.73 ± 5.8% | 22.02 ± 12.8% | not timed | not timed | 32.40 ± 2.3% | | 0.99 | 0.74 | 1.46 |
| wild/bibleref/line | 874 | 650.72 ± 7.7% | not timed | not timed | 316.46 ± 2.5% | 12.20 ± 9.0% | not timed | not timed | 650.82 ± 2.4% | | 1.00 | 2.06 | 53.35 |
| wild/caddy/caddy | 6 | 621.30 ± 6.2% | not timed | not timed | 339.02 ± 1.6% | 102.29 ± 10.8% | not timed | not timed | 620.13 ± 7.2% | | 1.00 | 1.83 | 6.07 |
| wild/dot-star-capture/rust-src-tools | 6 | 2048.36 ± 0.9% | not timed | not timed | 459.84 ± 1.6% | 22.66 ± 6.9% | not timed | not timed | 2032.39 ± 1.1% | | 1.01 | 4.45 | 90.41 |
| wild/ruff/noqa | 84 | 647.79 ± 2.0% | not timed | not timed | 664.42 ± 4.0% | 30.80 ± 2.8% | not timed | not timed | 645.85 ± 2.7% | | 1.00 | 0.97 | 21.04 |
| wild/ruff/unnecessary-coding-comment | 16 | 1306.91 ± 9.8% | not timed | not timed | 871.86 ± 1.7% | 195.42 ± 13.5% | not timed | not timed | 1311.04 ± 2.6% | | 1.00 | 1.50 | 6.69 |
| wild/ruff/string-quote-prefix | 2972 | 1973.49 ± 23.3% | not timed | not timed | 658.10 ± 2.5% | 408.44 ± 31.0% | not timed | not timed | 1979.41 ± 1.9% | | 1.00 | 3.00 | 4.83 |
| wild/ruff/space-around-operator | 1224378 | 302.35 ± 2.4% | not timed | not timed | 275.62 ± 21.3% | 27.15 ± 2.8% | not timed | not timed | 302.41 ± 2.9% | | 1.00 | 1.10 | 11.14 |
| wild/ruff/shebang | 282 | 1395.42 ± 6.7% | not timed | not timed | 519.48 ± 0.9% | 169.65 ± 11.4% | not timed | not timed | 1399.23 ± 0.6% | | 1.00 | 2.69 | 8.23 |
| wild/rustsec-cargo-audit/original-unix | 471 | 28893.06 ± 1.4% | not timed | not timed | 31808.01 ± 10.0% | 12043.40 ± 4.4% | not timed | not timed | 28779.02 ± 3.4% | | 1.00 | 0.91 | 2.40 |
| wild/rustsec-cargo-audit/original-windows | 462 | 27154.50 ± 1.8% | not timed | not timed | 30068.50 ± 1.5% | 11100.39 ± 1.2% | not timed | not timed | 27024.51 ± 2.2% | | 1.00 | 0.90 | 2.45 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 29424.36 ± 1.7% | not timed | not timed | 31443.34 ± 0.5% | 11628.20 ± 27.3% | not timed | not timed | 29644.35 ± 1.2% | | 0.99 | 0.94 | 2.53 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 25570.17 ± 19.0% | not timed | not timed | 31541.19 ± 1.3% | 11810.49 ± 20.8% | not timed | not timed | 25511.21 ± 4.6% | | 1.00 | 0.81 | 2.17 |
| wild/url/search | 234965 | 173.19 ± 27.9% | not timed | not timed | 83.37 ± 5.2% | 3.48 ± 3.0% | not timed | not timed | 174.09 ± 7.8% | | 0.99 | 2.08 | 49.78 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 2.0% | not timed | not timed | 0.01 ± 14.7% | 0.01 ± 27.0% | not timed | not timed | 0.04 ± 40.3% | | 0.99 | 2.90 | 4.38 |
| dictionary/compile/english-15 | 1 | 0.44 ± 8.7% | not timed | not timed | 0.11 ± 12.4% | 0.15 ± 28.1% | not timed | not timed | 0.44 ± 3.8% | | 1.00 | 4.17 | 2.89 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.41 ± 10.3% | not timed | not timed | 0.03 ± 7.3% | 48.03 ± 10.1% | not timed | not timed | 0.42 ± 3.7% | | 0.98 | 13.04 | 0.0086 |
| reported/i1095-word-repetition/ascii-compile | 1 | 58.39 ± 1.9% | not timed | not timed | 18.72 ± 0.4% | 83.51 ± 12.7% | not timed | not timed | 59.54 ± 7.1% | | 0.98 | 3.12 | 0.70 |
| reported/i787-keywords/compile | 1 | 52.22 ± 3.3% | not timed | not timed | 3.08 ± 1.3% | 25.28 ± 2.9% | not timed | not timed | 51.46 ± 8.8% | | 1.01 | 16.96 | 2.07 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 560.51 ± 5.9% | not timed | not timed | 180.67 ± 0.9% | 779.99 ± 10.6% | not timed | not timed | 584.60 ± 9.8% | | 0.96 | 3.10 | 0.72 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 74.37 ± 4.2% | not timed | not timed | 7.01 ± 1.3% | 63.76 ± 3.5% | not timed | not timed | 76.50 ± 3.7% | | 0.97 | 10.60 | 1.17 |
| unicode/compile/one-letter | 53 | 9.93 ± 9.0% | not timed | not timed | 7.58 ± 0.8% | 92.51 ± 9.7% | not timed | not timed | 10.18 ± 1.2% | | 0.98 | 1.31 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.86 ± 8.3% | not timed | not timed | 0.16 ± 1.4% | 83.67 ± 13.4% | not timed | not timed | 1.85 ± 2.5% | | 1.00 | 11.32 | 0.0222 |
| unicode/compile/fifty-letters-ascii | 1 | 293.43 ± 14.5% | not timed | not timed | 81.69 ± 35.7% | 251.11 ± 146.0% | not timed | not timed | 299.27 ± 118.7% | | 0.98 | 3.59 | 1.17 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 658.86 ± 4.8% | not timed | not timed | 60.40 ± 1.3% | 973.76 ± 11.7% | not timed | not timed | 655.20 ± 17.0% | | 1.01 | 10.91 | 0.68 |
| unicode/compile/match-every-line-ascii | 4 | 1039.76 ± 4.6% | not timed | not timed | 215.34 ± 45.8% | 893.97 ± 74.9% | not timed | not timed | 1029.88 ± 11.5% | | 1.01 | 4.83 | 1.16 |
| unicode/compile/negated-class-matches-codepoint | 1 | 534.06 ± 13.9% | not timed | not timed | 64.69 ± 2.7% | 1772.86 ± 8.6% | not timed | not timed | 542.86 ± 14.9% | | 0.98 | 8.26 | 0.30 |
| wild/bibleref/compile | 3 | 9.03 ± 8.8% | not timed | not timed | 3.16 ± 2.8% | 44.25 ± 17.3% | not timed | not timed | 8.78 ± 19.8% | | 1.03 | 2.85 | 0.20 |
| wild/url/compile | 1 | 0.99 ± 8.6% | not timed | not timed | 0.22 ± 1.5% | 0.62 ± 29.5% | not timed | not timed | 0.99 ± 8.9% | | 0.99 | 4.49 | 1.59 |

