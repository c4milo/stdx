# bench-regex

| Field | Value |
|---|---|
| Commit | c65ceab |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44943142279 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache, `stdx, no skip` the same with claim R1 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed.

The patterns of the search table:

- prose: a word, in canterbury-large/bible.txt: `Pharaoh`
- prose: a word that is not there, in canterbury-large/bible.txt: `Sherlock`
- prose: one of four words, in canterbury-large/bible.txt: `Abraham|Isaac|Jacob|Joseph`
- prose: a word in any case, in canterbury-large/bible.txt: `(?i)pharaoh`
- prose: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- prose: two capitalized words, in canterbury-large/bible.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- prose: a word that ends in ing, in canterbury-large/bible.txt: `[a-z]+ing`
- prose: a word in capitals, in canterbury-large/bible.txt: `[A-Z][A-Z][A-Z]+`
- markup: an href attribute, in http/html-1m: `href="[^"]*"`
- markup: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- markup: a number, in http/html-1m: `[0-9]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| prose: a word | 217 | 5205.63 ± 0.7% | 561.64 ± 0.3% | 28.80 ± 0.1% | 18594.91 ± 2.2% | 9268.69 ± 5.8% | 16.48 ± 0.2% | 86.19 ± 1.1% | 9.27 | 0.28 | 0.56 |
| prose: a word that is not there | 0 | 5375.29 ± 1.2% | 562.03 ± 0.4% | 29.07 ± 0.9% | 19899.53 ± 1.5% | 29551.40 ± 2.8% | 16.24 ± 0.1% | 82.20 ± 0.4% | 9.56 | 0.27 | 0.18 |
| prose: one of four words | 661 | 2428.06 ± 0.9% | 555.90 ± 0.3% | 15.18 ± 0.4% | 3986.31 ± 0.2% | 21.89 ± 0.1% | 4.91 ± 0.2% | 6.92 ± 0.3% | 4.37 | 0.61 | 110.90 |
| prose: a word in any case | 217 | 2678.96 ± 1.2% | 563.60 ± 0.3% | 22.03 ± 0.2% | 4074.27 ± 0.1% | 38.01 ± 0.3% | refused | differs | 4.75 | 0.66 | 70.48 |
| prose: a word between two words | 6104 | 464.40 ± 0.9% | 463.49 ± 0.4% | 23.90 ± 0.3% | 908.26 ± 0.4% | 106.51 ± 14.5% | 10.65 ± 0.1% | 69.71 ± 0.3% | 1.00 | 0.51 | 4.36 |
| prose: two capitalized words | 1331 | 1098.75 ± 0.2% | 540.58 ± 0.8% | 26.76 ± 0.4% | 599.96 ± 0.1% | 40.61 ± 16.3% | 14.11 ± 0.2% | 68.87 ± 0.3% | 2.03 | 1.83 | 27.06 |
| prose: a word that ends in ing | 3399 | 506.03 ± 1.0% | 506.01 ± 1.0% | 18.55 ± 0.2% | 586.77 ± 0.1% | 29.55 ± 5.8% | 7.76 ± 0.2% | 18.40 ± 0.6% | 1.00 | 0.86 | 17.13 |
| prose: a word in capitals | 2332 | 1417.79 ± 0.4% | 533.70 ± 1.0% | 28.26 ± 0.2% | 597.48 ± 0.2% | 43.56 ± 0.1% | 16.75 ± 0.2% | 83.15 ± 0.2% | 2.66 | 2.37 | 32.55 |
| markup: an href attribute | 33 | 1607.00 ± 0.4% | 561.47 ± 0.7% | 27.87 ± 0.5% | 17901.83 ± 0.2% | 2263.06 ± 4.2% | 12.26 ± 0.2% | 75.18 ± 0.1% | 2.86 | 0.09 | 0.71 |
| markup: a heading's start tag | 110 | 1410.42 ± 0.3% | 560.97 ± 0.4% | 27.81 ± 0.2% | 1744.15 ± 0.3% | 1573.70 ± 4.0% | 15.07 ± 0.4% | 89.04 ± 0.3% | 2.51 | 0.81 | 0.90 |
| markup: a number | 8288 | 1776.80 ± 0.1% | 470.63 ± 0.1% | 28.45 ± 0.5% | 2441.81 ± 0.2% | 42.25 ± 13.7% | 0.51 ± 0.2% | 56.60 ± 0.5% | 3.78 | 0.73 | 42.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 16.34 ± 0.6% | 16.35 ± 0.6% | 0.49 ± 0.4% | 18.65 ± 1.2% | 2.71 ± 0.6% | differs | 3.87 ± 0.1% | 1.00 | 0.88 | 6.04 |
| a UUID | 512 | 11.95 ± 0.6% | 11.92 ± 0.6% | 0.66 ± 0.1% | 13.76 ± 0.1% | 2.99 ± 0.1% | 0.73 ± 0.3% | 3.47 ± 0.2% | 1.00 | 0.87 | 4.00 |
| an IPv4 address | 512 | 30.21 ± 0.4% | 30.18 ± 9.0% | 2.17 ± 0.3% | 32.05 ± 0.8% | 6.38 ± 0.1% | differs | 4.04 ± 0.1% | 1.00 | 0.94 | 4.74 |
| a date and time | 512 | 18.79 ± 2.3% | 18.77 ± 2.5% | 1.48 ± 0.8% | 20.97 ± 0.1% | 6.66 ± 0.1% | 1.23 ± 0.2% | 6.83 ± 0.2% | 1.00 | 0.90 | 2.82 |
| a field path | 512 | 19.26 ± 0.7% | 19.27 ± 0.2% | 0.83 ± 0.3% | 23.73 ± 1.2% | 3.42 ± 0.9% | differs | 2.89 ± 0.1% | 1.00 | 0.81 | 5.64 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.46 ± 0.9% | 2.44 ± 0.9% | 1.14 ± 0.2% | 10.40 ± 0.4% | 4.76 ± 3.5% | 0.91 ± 0.8% | none | 1.01 | 0.24 | 0.52 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 241.77 ± 0.3% | 241.86 ± 0.4% | 350.53 ± 0.1% | 87.56 ± 0.5% | 221.20 ± 1.6% | 480.03 ± 3.9% | 3849.37 ± 2.4% | 1.00 | 2.76 | 1.09 |
| a UUID | 62 | 189.75 ± 0.3% | 190.23 ± 0.1% | 253.61 ± 0.2% | 46.76 ± 1.5% | 99.75 ± 1.5% | 192.51 ± 1.8% | 4467.58 ± 0.2% | 1.00 | 4.06 | 1.90 |
| an IPv4 address | 29 | 361.44 ± 0.7% | 361.68 ± 0.7% | 605.41 ± 0.2% | 78.38 ± 0.3% | 130.18 ± 25.7% | 291.01 ± 1.7% | 7645.92 ± 0.2% | 1.00 | 4.61 | 2.78 |
| a date and time | 56 | 242.24 ± 0.3% | 242.38 ± 0.4% | 358.95 ± 0.3% | 73.19 ± 0.5% | 136.50 ± 1.4% | 329.57 ± 3.5% | 4955.09 ± 0.5% | 1.00 | 3.31 | 1.77 |
| a field path | 39 | 246.71 ± 0.4% | 246.65 ± 0.2% | 408.30 ± 0.2% | 80.95 ± 1.6% | 205.06 ± 1.1% | 508.74 ± 5.5% | 4927.07 ± 3.3% | 1.00 | 3.05 | 1.20 |
| prose: a word | 7 | 549.59 ± 0.7% | 549.92 ± 1.2% | 1397.96 ± 0.6% | 524.26 ± 0.2% | 620.00 ± 1.6% | 944.14 ± 0.5% | 29906.97 ± 0.1% | 1.00 | 1.05 | 0.89 |
| prose: a word that is not there | 8 | 565.81 ± 2.1% | 564.72 ± 1.3% | 1319.35 ± 1.1% | 471.57 ± 0.2% | 599.34 ± 1.3% | 890.13 ± 0.7% | 28845.91 ± 0.4% | 1.00 | 1.20 | 0.94 |
| prose: one of four words | 26 | 347.64 ± 0.4% | 348.27 ± 0.3% | 604.51 ± 0.6% | 50.22 ± 0.6% | 241.23 ± 2.0% | 366.76 ± 1.5% | 15542.07 ± 0.2% | 1.00 | 6.92 | 1.44 |
| prose: a word in any case | 11 | 465.43 ± 0.3% | 465.42 ± 0.3% | 1139.43 ± 0.3% | 15.51 ± 0.3% | 651.79 ± 1.6% | refused | 23521.56 ± 0.3% | 1.00 | 30.00 | 0.71 |
| prose: a word between two words | 13 | 411.14 ± 0.2% | 411.84 ± 0.4% | 963.83 ± 0.5% | 135.67 ± 1.0% | 499.11 ± 1.5% | 804.48 ± 1.0% | 14756.49 ± 0.3% | 1.00 | 3.03 | 0.82 |
| prose: two capitalized words | 23 | 322.27 ± 0.3% | 322.35 ± 0.6% | 614.77 ± 0.5% | 100.74 ± 0.1% | 499.36 ± 6.1% | 781.99 ± 0.2% | 6494.02 ± 0.9% | 1.00 | 3.20 | 0.65 |
| prose: a word that ends in ing | 9 | 448.30 ± 0.9% | 449.50 ± 0.6% | 1166.57 ± 0.5% | 135.03 ± 0.4% | 749.74 ± 0.9% | 1148.51 ± 0.4% | 15898.17 ± 0.1% | 1.00 | 3.32 | 0.60 |
| prose: a word in capitals | 16 | 340.69 ± 0.9% | 340.48 ± 0.2% | 796.13 ± 0.1% | 139.26 ± 1.1% | 749.07 ± 1.0% | 1050.12 ± 0.3% | 8507.41 ± 0.4% | 1.00 | 2.45 | 0.45 |
| markup: an href attribute | 12 | 345.58 ± 0.2% | 346.60 ± 0.4% | 545.14 ± 0.4% | 43.13 ± 0.4% | 499.40 ± 0.8% | 770.04 ± 0.4% | 21510.21 ± 0.1% | 1.00 | 8.01 | 0.69 |
| markup: a heading's start tag | 13 | 330.36 ± 0.4% | 330.42 ± 0.2% | 522.49 ± 0.6% | 39.31 ± 0.5% | 630.77 ± 1.5% | 867.91 ± 0.3% | 18046.04 ± 0.1% | 1.00 | 8.40 | 0.52 |
| markup: a number | 6 | 421.01 ± 0.6% | 420.86 ± 1.0% | 1375.02 ± 0.1% | 41.67 ± 1.0% | 1385.12 ± 6.6% | 1869.13 ± 1.6% | 22726.49 ± 0.1% | 1.00 | 10.10 | 0.30 |

