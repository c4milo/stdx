# bench-regex

| Field | Value |
|---|---|
| Commit | 4354b93 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44945332342 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

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

| Pattern | Matches | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| prose: a word | 217 | 574.27 ± 0.4% | 28.42 ± 0.7% | 18504.47 ± 4.0% | 9135.43 ± 8.2% | 17.40 ± 0.1% | 86.15 ± 0.3% | 0.03 | 0.06 |
| prose: a word that is not there | 0 | 575.62 ± 0.5% | 28.73 ± 0.4% | 19969.56 ± 3.3% | 29491.39 ± 5.4% | 17.17 ± 0.1% | 83.18 ± 0.3% | 0.03 | 0.02 |
| prose: one of four words | 661 | 568.46 ± 0.3% | 14.89 ± 1.5% | 3980.65 ± 0.4% | 21.85 ± 0.2% | 5.40 ± 0.2% | 6.72 ± 0.5% | 0.14 | 26.02 |
| prose: a word in any case | 217 | 572.73 ± 0.1% | 21.98 ± 0.3% | 4071.04 ± 0.3% | 38.00 ± 2.4% | refused | differs | 0.14 | 15.07 |
| prose: a word between two words | 6104 | 482.81 ± 0.1% | 23.94 ± 0.3% | 909.97 ± 0.4% | 110.35 ± 13.9% | 11.34 ± 0.2% | 70.06 ± 0.2% | 0.53 | 4.38 |
| prose: two capitalized words | 1331 | 552.44 ± 0.3% | 26.43 ± 0.2% | 600.63 ± 0.2% | 40.72 ± 0.2% | 14.79 ± 0.2% | 69.23 ± 0.2% | 0.92 | 13.57 |
| prose: a word that ends in ing | 3399 | 524.51 ± 0.1% | 18.62 ± 0.3% | 586.29 ± 0.1% | 29.54 ± 3.7% | 8.20 ± 0.2% | 18.44 ± 0.6% | 0.89 | 17.76 |
| prose: a word in capitals | 2332 | 550.78 ± 0.2% | 28.04 ± 0.1% | 597.46 ± 0.2% | 43.56 ± 3.1% | 17.08 ± 0.2% | 83.85 ± 0.4% | 0.92 | 12.64 |
| markup: an href attribute | 33 | 575.64 ± 0.4% | 27.85 ± 0.5% | 17729.63 ± 1.0% | 2254.09 ± 0.6% | 13.19 ± 0.2% | 75.98 ± 0.3% | 0.03 | 0.26 |
| markup: a heading's start tag | 110 | 572.56 ± 0.1% | 27.58 ± 0.7% | 1746.35 ± 0.6% | 1576.34 ± 6.3% | 16.10 ± 0.3% | 89.86 ± 0.4% | 0.33 | 0.36 |
| markup: a number | 8288 | 505.22 ± 0.2% | 28.12 ± 0.2% | 2439.12 ± 0.2% | 41.08 ± 16.0% | 0.55 ± 0.5% | 57.50 ± 0.3% | 0.21 | 12.30 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 21.75 ± 0.3% | 0.49 ± 0.2% | 18.61 ± 0.6% | 2.70 ± 0.3% | differs | 3.90 ± 0.1% | 1.17 | 8.06 |
| a UUID | 512 | 14.70 ± 0.3% | 0.66 ± 0.1% | 13.71 ± 0.2% | 3.00 ± 0.3% | 0.71 ± 0.4% | 3.49 ± 0.4% | 1.07 | 4.91 |
| an IPv4 address | 512 | 38.25 ± 0.2% | 2.17 ± 0.4% | 32.55 ± 0.9% | 6.38 ± 0.6% | differs | 4.06 ± 0.4% | 1.18 | 6.00 |
| a date and time | 512 | 25.57 ± 0.3% | 1.51 ± 0.1% | 20.81 ± 0.2% | 6.69 ± 0.3% | 1.18 ± 0.4% | 6.61 ± 0.2% | 1.23 | 3.82 |
| a field path | 512 | 27.19 ± 0.5% | 0.83 ± 0.1% | 23.62 ± 0.8% | 3.39 ± 0.6% | differs | 2.93 ± 0.5% | 1.15 | 8.01 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.54 ± 0.5% | 1.13 ± 0.7% | 10.17 ± 0.3% | 4.78 ± 4.0% | 0.90 ± 2.7% | none | 0.25 | 0.53 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 257.28 ± 0.4% | 335.16 ± 0.2% | 87.10 ± 0.8% | 217.27 ± 3.0% | 469.40 ± 4.7% | 3817.32 ± 0.7% | 2.95 | 1.18 |
| a UUID | 62 | 195.04 ± 0.3% | 243.66 ± 0.6% | 46.74 ± 1.5% | 98.45 ± 0.8% | 189.52 ± 1.6% | 4341.41 ± 0.9% | 4.17 | 1.98 |
| an IPv4 address | 29 | 361.71 ± 1.5% | 569.62 ± 0.6% | 78.01 ± 0.8% | 130.50 ± 1.1% | 296.15 ± 0.9% | 7656.80 ± 0.6% | 4.64 | 2.77 |
| a date and time | 56 | 257.61 ± 1.3% | 336.99 ± 0.4% | 73.27 ± 0.2% | 135.94 ± 2.3% | 323.38 ± 2.0% | 4830.38 ± 2.9% | 3.52 | 1.90 |
| a field path | 39 | 277.47 ± 6.5% | 385.75 ± 1.3% | 80.54 ± 0.9% | 204.70 ± 21.9% | 498.27 ± 2.4% | 4904.76 ± 2.0% | 3.45 | 1.36 |
| prose: a word | 7 | 565.73 ± 0.4% | 1369.25 ± 0.8% | 528.68 ± 0.5% | 617.39 ± 2.1% | 959.04 ± 2.8% | 29363.13 ± 0.1% | 1.07 | 0.92 |
| prose: a word that is not there | 8 | 586.78 ± 0.3% | 1296.94 ± 0.2% | 474.50 ± 0.2% | 597.18 ± 2.6% | 904.04 ± 0.5% | 28155.41 ± 0.3% | 1.24 | 0.98 |
| prose: one of four words | 26 | 397.91 ± 0.5% | 600.47 ± 0.5% | 50.47 ± 1.0% | 238.65 ± 1.8% | 376.84 ± 0.7% | 15661.68 ± 0.5% | 7.88 | 1.67 |
| prose: a word in any case | 11 | 562.65 ± 0.2% | 1115.06 ± 0.2% | 15.40 ± 0.5% | 637.71 ± 0.7% | refused | 23219.23 ± 0.4% | 36.54 | 0.88 |
| prose: a word between two words | 13 | 482.93 ± 0.4% | 913.92 ± 1.8% | 136.55 ± 3.9% | 495.12 ± 1.8% | 786.06 ± 5.6% | 14605.12 ± 0.6% | 3.54 | 0.98 |
| prose: two capitalized words | 23 | 343.10 ± 0.2% | 571.26 ± 0.5% | 100.79 ± 0.6% | 491.29 ± 1.4% | 762.84 ± 0.8% | 6442.28 ± 1.4% | 3.40 | 0.70 |
| prose: a word that ends in ing | 9 | 498.94 ± 0.7% | 1096.44 ± 0.3% | 135.26 ± 0.6% | 741.30 ± 0.9% | 1117.22 ± 2.2% | 15801.10 ± 0.2% | 3.69 | 0.67 |
| prose: a word in capitals | 16 | 376.05 ± 0.1% | 739.34 ± 0.2% | 139.66 ± 0.7% | 725.59 ± 1.1% | 1047.97 ± 2.2% | 8521.78 ± 0.7% | 2.69 | 0.52 |
| markup: an href attribute | 12 | 363.18 ± 0.4% | 522.33 ± 0.4% | 43.38 ± 0.4% | 494.23 ± 2.9% | 767.99 ± 0.7% | 21194.48 ± 0.2% | 8.37 | 0.73 |
| markup: a heading's start tag | 13 | 346.82 ± 0.5% | 500.15 ± 0.4% | 41.85 ± 0.4% | 614.34 ± 1.8% | 844.75 ± 0.5% | 17764.93 ± 0.3% | 8.29 | 0.56 |
| markup: a number | 6 | 478.49 ± 0.4% | 1274.37 ± 0.1% | 41.61 ± 1.5% | 1358.47 ± 3.3% | 1879.25 ± 1.1% | 22454.88 ± 0.1% | 11.50 | 0.35 |

