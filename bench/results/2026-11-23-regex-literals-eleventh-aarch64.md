# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243514938 |
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
| literal: a word | 217 | 19375.75 ± 2.0% | 4988.04 ± 0.4% | 27.74 ± 0.4% | 18263.61 ± 1.3% | 9159.90 ± 9.6% | 17.59 ± 0.3% | 84.11 ± 0.6% | 19362.69 ± 2.6% | 3.88 | 1.00 | 1.06 | 2.12 |
| literal: a word that is not there | 0 | 21709.82 ± 2.7% | 4879.33 ± 0.3% | 27.82 ± 0.2% | 19587.99 ± 3.8% | 29119.30 ± 2.2% | 17.40 ± 0.2% | 79.66 ± 0.9% | 21855.88 ± 2.2% | 4.45 | 0.99 | 1.11 | 0.75 |
| literal: one of four words | 661 | 6355.17 ± 0.5% | 1933.20 ± 0.3% | 14.25 ± 0.4% | 3948.58 ± 0.3% | 21.88 ± 0.1% | 5.31 ± 0.2% | 6.86 ± 1.1% | 6359.67 ± 0.4% | 3.29 | 1.00 | 1.61 | 290.41 |
| literal: a word in any case | 217 | 15131.87 ± 0.8% | 2076.48 ± 0.0% | 21.11 ± 0.3% | 3967.80 ± 0.2% | 38.10 ± 0.6% | refused | differs | 15105.39 ± 0.8% | 7.29 | 1.00 | 3.81 | 397.20 |
| literal: an href attribute | 33 | 16955.17 ± 1.7% | 609.75 ± 0.3% | 26.64 ± 0.5% | 17165.38 ± 2.1% | 2255.04 ± 0.1% | 13.46 ± 0.2% | 74.05 ± 0.9% | 16882.72 ± 1.1% | 27.81 | 1.00 | 0.99 | 7.52 |
| literal: a word, second text | 123 | 20073.14 ± 0.9% | 3359.96 ± 0.2% | 27.37 ± 0.2% | 18522.10 ± 0.3% | 7584.73 ± 5.5% | 19.58 ± 0.2% | 70.16 ± 0.4% | 20122.33 ± 0.4% | 5.97 | 1.00 | 1.08 | 2.65 |
| class: two capitalized words | 1331 | 1056.72 ± 0.5% | 600.49 ± 0.2% | 25.37 ± 0.2% | 582.34 ± 0.1% | 40.54 ± 1.5% | 15.06 ± 0.3% | 67.26 ± 0.6% | 1056.29 ± 1.0% | 1.76 | 1.00 | 1.81 | 26.06 |
| class: a word that ends in ing | 3399 | 573.31 ± 0.2% | 573.55 ± 0.1% | 17.71 ± 0.3% | 545.04 ± 0.1% | 29.63 ± 2.5% | 8.21 ± 0.1% | 18.23 ± 0.2% | 571.75 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.35 |
| class: a word in capitals | 2332 | 1370.26 ± 0.3% | 601.89 ± 0.1% | 27.02 ± 0.2% | 572.78 ± 0.0% | 43.50 ± 13.6% | 17.29 ± 0.4% | 82.63 ± 0.6% | 1367.77 ± 0.2% | 2.28 | 1.00 | 2.39 | 31.50 |
| class: a number | 8288 | 1957.32 ± 0.7% | 827.30 ± 0.1% | 27.25 ± 0.2% | 1711.05 ± 0.3% | 39.13 ± 15.7% | 0.57 ± 0.2% | 57.54 ± 0.3% | 1954.31 ± 0.4% | 2.37 | 1.00 | 1.14 | 50.02 |
| class: two capitalized words, second text | 5359 | 515.43 ± 0.2% | 523.34 ± 0.3% | 22.81 ± 0.2% | 485.97 ± 0.1% | 34.16 ± 14.2% | 16.98 ± 0.2% | 62.60 ± 0.5% | 515.60 ± 0.2% | 0.98 | 1.00 | 1.06 | 15.09 |
| other: a word between two words | 6104 | 796.95 ± 0.1% | 594.03 ± 0.4% | 23.08 ± 0.2% | 736.31 ± 0.1% | 102.08 ± 19.2% | 11.46 ± 0.3% | 68.00 ± 2.2% | 788.50 ± 0.1% | 1.34 | 1.01 | 1.08 | 7.81 |
| other: a number before a unit, second text | 1481 | 5993.00 ± 1.1% | 1120.32 ± 0.5% | 25.49 ± 0.2% | 5704.00 ± 0.3% | 40.85 ± 15.2% | 17.98 ± 0.2% | 65.45 ± 0.5% | 5931.69 ± 0.5% | 5.35 | 1.01 | 1.05 | 146.70 |
| other: a heading's start tag | 110 | 14127.29 ± 0.7% | 742.62 ± 0.3% | 26.83 ± 0.4% | 1715.11 ± 0.5% | 1585.69 ± 6.1% | 16.39 ± 0.5% | 86.06 ± 0.3% | 14110.43 ± 0.7% | 19.02 | 1.00 | 8.24 | 8.91 |
| other: a whole word | 217 | 15947.39 ± 0.6% | 603.82 ± 0.6% | 28.66 ± 0.2% | 14554.62 ± 0.4% | 49.40 ± 0.2% | 13.92 ± 0.2% | 54.82 ± 0.4% | 15888.23 ± 0.9% | 26.41 | 1.00 | 1.10 | 322.85 |
| other: a line's first word, second text | 3716 | 2042.75 ± 0.8% | 588.21 ± 0.2% | 29.98 ± 0.3% | 1728.28 ± 0.4% | 61.81 ± 7.9% | refused | refused | 2036.51 ± 0.8% | 3.47 | 1.00 | 1.18 | 33.05 |
| other: fourteen octets before an x | 87 | 23624.95 ± 3.2% | 243.48 ± 0.6% | 6.51 ± 0.1% | 4015.97 ± 0.5% | 10.65 ± 0.2% | differs | 17.70 ± 0.1% | 23806.53 ± 1.3% | 97.03 | 0.99 | 5.88 | 2218.12 |
| other: a Greek word | 21815 | 486.75 ± 0.2% | 408.87 ± 0.2% | 30.51 ± 0.5% | 289.29 ± 0.1% | 44.15 ± 10.8% | differs | refused | 482.90 ± 0.7% | 1.19 | 1.01 | 1.68 | 11.03 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.44 ± 0.2% | 18.47 ± 0.3% | 0.85 ± 0.3% | 19.51 ± 0.4% | 2.76 ± 0.5% | differs | 3.99 ± 0.2% | 18.47 ± 0.3% | 1.00 | 1.00 | 0.95 | 6.67 |
| a UUID | 32895 | 20.09 ± 0.1% | 20.13 ± 0.1% | 0.64 ± 0.1% | 15.11 ± 0.4% | 3.10 ± 0.1% | 0.72 ± 0.5% | 3.63 ± 0.8% | 20.13 ± 0.1% | 1.00 | 1.00 | 1.33 | 6.49 |
| an IPv4 address | 33176 | 33.59 ± 0.2% | 33.65 ± 0.2% | 2.07 ± 0.3% | 28.96 ± 0.7% | 6.62 ± 0.4% | differs | 4.14 ± 0.1% | 33.65 ± 0.2% | 1.00 | 1.00 | 1.16 | 5.07 |
| a date and time | 32954 | 28.71 ± 0.2% | 28.88 ± 0.1% | 1.44 ± 0.2% | 21.40 ± 0.2% | 7.04 ± 0.1% | 1.19 ± 0.3% | 7.10 ± 0.4% | 28.85 ± 0.3% | 0.99 | 1.00 | 1.34 | 4.08 |
| a field path | 32606 | 21.72 ± 0.2% | 21.75 ± 0.1% | 1.02 ± 0.2% | 23.09 ± 0.3% | 3.48 ± 0.4% | differs | 2.93 ± 0.4% | 21.76 ± 0.5% | 1.00 | 1.00 | 0.94 | 6.24 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.3% | 11.10 ± 0.2% | 11.08 ± 0.2% | 11.51 ± 0.1% | 4.98 ± 1.1% | 0.91 ± 0.1% | none | 11.11 ± 0.2% | 1.00 | 1.00 | 0.96 | 2.23 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.90 ± 0.4% | 221.85 ± 0.3% | 263.94 ± 0.3% | 87.31 ± 0.2% | 222.09 ± 4.0% | 479.02 ± 0.9% | 3805.57 ± 3.3% | 221.01 ± 0.3% | 1.00 | 1.00 | 2.53 | 0.99 |
| a UUID | 62 | 143.55 ± 0.4% | 143.84 ± 0.2% | 161.30 ± 0.1% | 46.45 ± 0.5% | 98.63 ± 1.4% | 181.97 ± 1.9% | 4272.81 ± 0.4% | 143.44 ± 0.2% | 1.00 | 1.00 | 3.09 | 1.46 |
| an IPv4 address | 29 | 412.91 ± 0.1% | 417.14 ± 0.3% | 597.55 ± 0.4% | 77.25 ± 1.2% | 132.15 ± 0.7% | 292.22 ± 0.8% | 7541.64 ± 0.4% | 412.39 ± 0.3% | 0.99 | 1.00 | 5.35 | 3.12 |
| a date and time | 56 | 295.42 ± 0.4% | 297.16 ± 0.1% | 376.11 ± 0.3% | 73.09 ± 0.6% | 137.89 ± 1.1% | 315.68 ± 0.8% | 4925.46 ± 0.5% | 294.91 ± 0.5% | 0.99 | 1.00 | 4.04 | 2.14 |
| a field path | 39 | 213.59 ± 0.3% | 214.13 ± 0.2% | 252.47 ± 0.3% | 80.88 ± 0.3% | 206.49 ± 2.3% | 504.01 ± 2.0% | 4842.81 ± 0.2% | 213.49 ± 0.1% | 1.00 | 1.00 | 2.64 | 1.03 |
| literal: a word | 7 | 611.15 ± 0.4% | 665.87 ± 0.2% | 1224.91 ± 0.1% | 518.76 ± 0.2% | 633.84 ± 1.6% | 941.33 ± 0.5% | 29698.60 ± 0.3% | 611.20 ± 0.2% | 0.92 | 1.00 | 1.18 | 0.96 |
| literal: a word that is not there | 8 | 593.70 ± 0.1% | 645.28 ± 0.3% | 1155.30 ± 0.2% | 469.01 ± 0.1% | 606.43 ± 1.5% | 891.48 ± 0.3% | 28570.75 ± 0.1% | 593.29 ± 0.3% | 0.92 | 1.00 | 1.27 | 0.98 |
| literal: one of four words | 26 | 237.59 ± 0.7% | 394.00 ± 0.4% | 544.87 ± 0.3% | 49.21 ± 0.4% | 242.85 ± 3.8% | 361.18 ± 2.1% | 15710.61 ± 0.2% | 237.67 ± 0.4% | 0.60 | 1.00 | 4.83 | 0.98 |
| literal: a word in any case | 11 | 433.99 ± 0.3% | 464.79 ± 0.3% | 691.11 ± 0.4% | 15.72 ± 0.3% | 654.74 ± 3.4% | refused | 23359.64 ± 0.4% | 433.73 ± 0.1% | 0.93 | 1.00 | 27.60 | 0.66 |
| literal: an href attribute | 12 | 332.85 ± 0.3% | 346.20 ± 0.3% | 460.55 ± 0.4% | 45.69 ± 0.9% | 504.98 ± 2.7% | 776.62 ± 0.8% | 21315.84 ± 0.6% | 332.84 ± 0.4% | 0.96 | 1.00 | 7.28 | 0.66 |
| literal: a word, second text | 10 | 548.11 ± 0.2% | 605.67 ± 0.3% | 1041.22 ± 0.3% | 421.38 ± 0.4% | 540.25 ± 1.1% | 803.23 ± 0.4% | 26407.31 ± 0.2% | 547.17 ± 0.7% | 0.90 | 1.00 | 1.30 | 1.01 |
| class: two capitalized words | 23 | 419.68 ± 0.5% | 454.51 ± 0.5% | 672.50 ± 0.7% | 100.89 ± 0.2% | 506.56 ± 0.9% | 740.24 ± 0.4% | 6445.21 ± 0.4% | 420.81 ± 0.4% | 0.92 | 1.00 | 4.16 | 0.83 |
| class: a word that ends in ing | 9 | 540.19 ± 0.3% | 611.50 ± 0.6% | 1104.49 ± 0.1% | 132.21 ± 1.1% | 765.99 ± 0.7% | 1096.12 ± 1.9% | 15771.13 ± 0.1% | 539.84 ± 0.1% | 0.88 | 1.00 | 4.09 | 0.71 |
| class: a word in capitals | 16 | 473.23 ± 0.5% | 520.40 ± 0.4% | 868.05 ± 0.2% | 136.00 ± 0.6% | 759.28 ± 1.0% | 1013.93 ± 0.2% | 8498.99 ± 0.5% | 472.91 ± 0.5% | 0.91 | 1.00 | 3.48 | 0.62 |
| class: a number | 6 | 596.68 ± 0.3% | 671.34 ± 0.9% | 1324.25 ± 0.1% | 41.86 ± 0.6% | 1420.10 ± 0.6% | 1918.49 ± 1.4% | 22277.09 ± 0.1% | 596.71 ± 0.2% | 0.89 | 1.00 | 14.25 | 0.42 |
| class: two capitalized words, second text | 23 | 420.12 ± 0.3% | 454.75 ± 0.2% | 672.47 ± 0.4% | 103.89 ± 0.3% | 505.08 ± 1.1% | 727.73 ± 0.6% | 6442.05 ± 0.2% | 420.56 ± 0.2% | 0.92 | 1.00 | 4.04 | 0.83 |
| other: a word between two words | 13 | 529.08 ± 0.2% | 550.85 ± 0.2% | 903.47 ± 0.4% | 135.31 ± 1.1% | 505.43 ± 0.7% | 807.67 ± 0.9% | 14656.34 ± 0.2% | 528.65 ± 0.3% | 0.96 | 1.00 | 3.91 | 1.05 |
| other: a number before a unit, second text | 15 | 381.03 ± 0.5% | 422.38 ± 0.4% | 599.17 ± 0.4% | 39.38 ± 0.2% | 643.45 ± 1.8% | 885.30 ± 0.3% | 14937.82 ± 0.3% | 381.36 ± 0.2% | 0.90 | 1.00 | 9.68 | 0.59 |
| other: a heading's start tag | 13 | 342.38 ± 0.5% | 350.47 ± 0.2% | 469.30 ± 0.4% | 44.68 ± 0.3% | 635.87 ± 0.5% | 864.78 ± 0.2% | 17670.99 ± 0.2% | 342.28 ± 0.3% | 0.98 | 1.00 | 7.66 | 0.54 |
| other: a whole word | 11 | 566.50 ± 0.2% | 605.98 ± 0.1% | 1037.18 ± 0.4% | 122.10 ± 0.8% | 570.50 ± 2.1% | 815.01 ± 0.8% | 26614.45 ± 0.3% | 565.43 ± 0.5% | 0.93 | 1.00 | 4.64 | 0.99 |
| other: a line's first word, second text | 17 | 519.04 ± 0.2% | 543.34 ± 0.4% | 893.38 ± 0.1% | 130.22 ± 0.1% | 714.81 ± 0.9% | refused | refused | 518.00 ± 0.6% | 0.96 | 1.00 | 3.99 | 0.73 |
| other: fourteen octets before an x | 16 | 105.62 ± 0.4% | 151.23 ± 0.3% | 175.83 ± 0.3% | 15.21 ± 0.2% | 456.58 ± 2.2% | 404.76 ± 0.6% | 12657.85 ± 0.5% | 105.68 ± 0.5% | 0.70 | 1.00 | 6.94 | 0.23 |
| other: a Greek word | 8 | 412.00 ± 0.3% | 568.45 ± 0.5% | 990.17 ± 0.2% | 59.28 ± 0.4% | 1402.10 ± 0.8% | 1837.05 ± 0.7% | refused | 411.30 ± 0.1% | 0.72 | 1.00 | 6.95 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15826.06 ± 0.7% | not timed | not timed | 16502.50 ± 0.9% | 2090.23 ± 10.1% | not timed | not timed | 15836.83 ± 1.1% | | 1.00 | 0.96 | 7.57 |
| 01-literal/sherlock-casei-en | 522 | 5163.93 ± 1.0% | not timed | not timed | 3595.65 ± 0.1% | 32.51 ± 1.2% | not timed | not timed | 5148.27 ± 1.0% | | 1.00 | 1.44 | 158.86 |
| 01-literal/sherlock-ru | 724 | 17144.18 ± 0.7% | not timed | not timed | 17328.87 ± 0.2% | 1440.83 ± 19.2% | not timed | not timed | 17111.61 ± 0.3% | | 1.00 | 0.99 | 11.90 |
| 01-literal/sherlock-casei-ru | 746 | 6171.53 ± 0.4% | not timed | not timed | 3322.30 ± 0.1% | 31.04 ± 0.3% | not timed | not timed | 6172.36 ± 0.1% | | 1.00 | 1.86 | 198.84 |
| 01-literal/sherlock-zh | 30 | 19915.03 ± 0.3% | not timed | not timed | 18880.67 ± 0.4% | 2533.91 ± 11.2% | not timed | not timed | 19848.50 ± 0.2% | | 1.00 | 1.05 | 7.86 |
| 02-literal-alternate/sherlock-en | 714 | 6061.21 ± 0.6% | not timed | not timed | 3936.51 ± 0.1% | 16.60 ± 0.3% | not timed | not timed | 6057.08 ± 0.3% | | 1.00 | 1.54 | 365.12 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1935.80 ± 1.4% | not timed | not timed | 695.58 ± 0.3% | 11.11 ± 0.1% | not timed | not timed | 1929.75 ± 0.6% | | 1.00 | 2.78 | 174.25 |
| 02-literal-alternate/sherlock-ru | 899 | 5568.36 ± 0.1% | not timed | not timed | 3258.91 ± 0.1% | 22.59 ± 0.1% | not timed | not timed | 5562.49 ± 0.1% | | 1.00 | 1.71 | 246.50 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2059.87 ± 0.5% | not timed | not timed | 1232.29 ± 0.2% | 9.07 ± 0.3% | not timed | not timed | 2051.16 ± 0.3% | | 1.00 | 1.67 | 227.00 |
| 02-literal-alternate/sherlock-zh | 207 | 7291.08 ± 0.5% | not timed | not timed | 4167.00 ± 0.2% | 31.49 ± 0.0% | not timed | not timed | 7281.18 ± 0.3% | | 1.00 | 1.75 | 231.56 |
| 03-date/ascii | 111817 | 123.88 ± 0.6% | not timed | not timed | 96.14 ± 0.1% | 0.20 ± 2.0% | not timed | not timed | 123.39 ± 0.3% | | 1.00 | 1.29 | 611.72 |
| 04-ruff-noqa/real | 84 | 401.88 ± 0.1% | not timed | not timed | 462.90 ± 0.1% | 19.64 ± 1.1% | not timed | not timed | 401.43 ± 0.1% | | 1.00 | 0.87 | 20.47 |
| 04-ruff-noqa/tweaked | 44 | 561.53 ± 0.2% | not timed | not timed | 458.97 ± 0.1% | 366.53 ± 0.1% | not timed | not timed | 561.66 ± 0.1% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.14 ± 0.2% | not timed | not timed | 5.06 ± 0.2% | 0.20 ± 5.5% | not timed | not timed | 5.04 ± 3.6% | | 1.02 | 1.01 | 25.43 |
| 06-cloud-flare-redos/original | 107 | 414.82 ± 0.1% | not timed | not timed | 214.21 ± 0.2% | 24.84 ± 0.3% | not timed | not timed | 414.97 ± 0.1% | | 1.00 | 1.94 | 16.70 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.27 ± 0.2% | not timed | not timed | 226.83 ± 0.0% | 26.59 ± 0.1% | not timed | not timed | 411.47 ± 0.2% | | 1.00 | 1.81 | 15.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.83 ± 0.4% | not timed | not timed | 253.27 ± 0.2% | 28.74 ± 0.1% | not timed | not timed | 583.12 ± 0.2% | | 1.00 | 2.31 | 20.31 |
| 07-unicode-character-data/parse-line | 558784 | 235.13 ± 0.2% | not timed | not timed | 171.85 ± 0.1% | 42.47 ± 6.8% | not timed | not timed | 234.69 ± 1.7% | | 1.00 | 1.37 | 5.54 |
| 08-words/all-english | 56691 | 116.64 ± 0.3% | not timed | not timed | 83.36 ± 0.1% | 11.82 ± 13.4% | not timed | not timed | 116.85 ± 0.5% | | 1.00 | 1.40 | 9.87 |
| 08-words/long-english | 839 | 614.11 ± 0.7% | not timed | not timed | 597.65 ± 0.1% | 32.45 ± 0.4% | not timed | not timed | 614.28 ± 0.2% | | 1.00 | 1.03 | 18.93 |
| 09-aws-keys/full | 0 | 408.34 ± 0.1% | not timed | not timed | 461.26 ± 0.2% | 64.61 ± 3.6% | not timed | not timed | 408.02 ± 0.1% | | 1.00 | 0.89 | 6.32 |
| 09-aws-keys/quick | 0 | 942.07 ± 0.3% | not timed | not timed | 992.62 ± 0.2% | 416.05 ± 3.4% | not timed | not timed | 941.65 ± 0.2% | | 1.00 | 0.95 | 2.26 |
| 10-bounded-repeat/letters-en | 1833 | 580.46 ± 1.3% | not timed | not timed | 518.17 ± 0.4% | 19.56 ± 0.5% | not timed | not timed | 576.57 ± 0.6% | | 1.01 | 1.12 | 29.68 |
| 10-bounded-repeat/letters-ru | 3475 | 509.33 ± 0.7% | not timed | not timed | 477.87 ± 0.1% | 21.82 ± 9.5% | not timed | not timed | 507.09 ± 0.8% | | 1.00 | 1.07 | 23.34 |
| 10-bounded-repeat/context | 53 | 77.42 ± 0.5% | not timed | not timed | 65.96 ± 0.4% | 19.84 ± 0.2% | not timed | not timed | 77.24 ± 0.5% | | 1.00 | 1.17 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.46 ± 8.3% | not timed | not timed | 618.47 ± 0.1% | 36.37 ± 0.2% | not timed | not timed | 634.59 ± 8.6% | | 1.00 | 1.03 | 17.47 |
| 11-unstructured-to-json/extract | 600 | 82.94 ± 0.2% | not timed | not timed | 77.74 ± 0.5% | 48.91 ± 0.3% | not timed | not timed | 82.67 ± 1.1% | | 1.00 | 1.07 | 1.70 |
| 12-dictionary/single | 1 | 559.81 ± 0.2% | not timed | not timed | 562.22 ± 0.0% | 0.40 ± 0.2% | not timed | not timed | 558.95 ± 0.3% | | 1.00 | 1.00 | 1395.11 |
| 14-quadratic/1x | 100 | 21.13 ± 1.4% | not timed | not timed | 9.99 ± 0.3% | 0.96 ± 2.8% | not timed | not timed | 21.22 ± 1.4% | | 1.00 | 2.11 | 21.96 |
| 14-quadratic/2x | 200 | 17.50 ± 0.7% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.1% | not timed | not timed | 17.43 ± 0.8% | | 1.00 | 3.16 | 32.72 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.68 ± 0.3% | | 1.00 | 6.36 | 66.59 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.5% | not timed | not timed | 0.34 ± 0.8% | 0.54 ± 3.4% | not timed | not timed | 1.26 ± 0.6% | | 1.00 | 3.68 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 88.26 ± 0.1% | not timed | not timed | 13.83 ± 0.3% | 139.36 ± 2.2% | not timed | not timed | 87.69 ± 1.1% | | 1.01 | 6.38 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 13.83 ± 0.3% | not timed | not timed | 2.55 ± 0.9% | 6.41 ± 2.1% | not timed | not timed | 13.77 ± 1.1% | | 1.00 | 5.42 | 2.16 |
| 07-unicode-character-data/compile | 1 | 53.40 ± 0.1% | not timed | not timed | 25.94 ± 0.1% | 36.17 ± 2.6% | not timed | not timed | 52.86 ± 0.8% | | 1.01 | 2.06 | 1.48 |
| 09-aws-keys/compile-full | 1 | 40.91 ± 0.2% | not timed | not timed | 8.25 ± 0.3% | 23.49 ± 1.4% | not timed | not timed | 40.29 ± 1.2% | | 1.02 | 4.96 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 178.78 ± 0.2% | not timed | not timed | 46.63 ± 0.2% | 133.73 ± 2.3% | not timed | not timed | 177.27 ± 1.1% | | 1.01 | 3.83 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 13.52 ± 0.9% | not timed | not timed | 11.11 ± 0.3% | 16.14 ± 3.2% | not timed | not timed | 13.46 ± 1.0% | | 1.00 | 1.22 | 0.84 |
| 10-bounded-repeat/compile-capitals | 1 | 80.63 ± 0.7% | not timed | not timed | 8.07 ± 0.1% | 23.71 ± 8.7% | not timed | not timed | 79.25 ± 2.3% | | 1.02 | 9.99 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 83.64 ± 0.2% | not timed | not timed | 41.29 ± 0.2% | 68.52 ± 1.6% | not timed | not timed | 81.72 ± 2.5% | | 1.02 | 2.03 | 1.22 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 15.5% | 0.09 ± 17.2% | not timed | not timed | 0.35 ± 2.0% | | 1.01 | 5.07 | 3.76 |

