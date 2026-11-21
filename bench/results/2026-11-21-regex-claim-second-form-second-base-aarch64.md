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
| Run URL | https://github.com/c4milo/stdx/actions/runs/44945335519 |
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
| prose: a word | 217 | 574.36 ± 0.2% | 28.48 ± 0.2% | 18504.02 ± 2.2% | 9393.92 ± 7.4% | 17.43 ± 0.3% | 86.34 ± 0.2% | 0.03 | 0.06 |
| prose: a word that is not there | 0 | 575.87 ± 0.3% | 28.69 ± 0.3% | 19813.07 ± 1.7% | 29254.01 ± 1.3% | 17.17 ± 0.2% | 83.18 ± 0.3% | 0.03 | 0.02 |
| prose: one of four words | 661 | 568.31 ± 0.9% | 14.87 ± 0.2% | 3989.61 ± 0.5% | 21.89 ± 0.3% | 5.41 ± 0.1% | 6.72 ± 0.3% | 0.14 | 25.96 |
| prose: a word in any case | 217 | 573.48 ± 1.0% | 22.01 ± 0.2% | 4069.85 ± 0.2% | 37.92 ± 0.4% | refused | differs | 0.14 | 15.12 |
| prose: a word between two words | 6104 | 483.14 ± 0.4% | 23.96 ± 0.4% | 911.61 ± 0.3% | 101.82 ± 13.5% | 11.37 ± 0.3% | 70.08 ± 0.2% | 0.53 | 4.74 |
| prose: two capitalized words | 1331 | 552.65 ± 0.1% | 26.43 ± 0.2% | 600.22 ± 0.3% | 40.68 ± 3.4% | 14.80 ± 0.2% | 69.24 ± 0.3% | 0.92 | 13.59 |
| prose: a word that ends in ing | 3399 | 525.46 ± 0.1% | 18.63 ± 0.2% | 586.49 ± 0.2% | 29.53 ± 10.8% | 8.20 ± 0.2% | 18.48 ± 0.4% | 0.90 | 17.79 |
| prose: a word in capitals | 2332 | 551.15 ± 0.1% | 28.04 ± 0.5% | 597.65 ± 0.1% | 43.50 ± 0.1% | 17.08 ± 0.3% | 84.06 ± 0.5% | 0.92 | 12.67 |
| markup: an href attribute | 33 | 576.13 ± 0.2% | 27.84 ± 0.2% | 17983.92 ± 0.7% | 2261.09 ± 0.7% | 13.12 ± 0.4% | 76.06 ± 0.1% | 0.03 | 0.25 |
| markup: a heading's start tag | 110 | 572.97 ± 0.2% | 27.58 ± 0.2% | 1747.23 ± 0.1% | 1582.91 ± 3.5% | 16.09 ± 0.5% | 90.14 ± 0.4% | 0.33 | 0.36 |
| markup: a number | 8288 | 505.71 ± 0.1% | 28.12 ± 0.3% | 2442.03 ± 0.2% | 42.67 ± 13.7% | 0.55 ± 0.1% | 57.71 ± 0.4% | 0.21 | 11.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 21.75 ± 0.4% | 0.49 ± 0.2% | 18.54 ± 0.7% | 2.70 ± 0.6% | differs | 3.90 ± 0.3% | 1.17 | 8.06 |
| a UUID | 512 | 14.67 ± 0.3% | 0.66 ± 0.3% | 13.69 ± 0.4% | 2.99 ± 0.4% | 0.71 ± 0.3% | 3.48 ± 0.5% | 1.07 | 4.90 |
| an IPv4 address | 512 | 38.23 ± 0.2% | 2.17 ± 0.1% | 32.42 ± 0.5% | 6.40 ± 0.2% | differs | 4.07 ± 0.6% | 1.18 | 5.98 |
| a date and time | 512 | 25.67 ± 0.3% | 1.51 ± 0.0% | 20.84 ± 0.1% | 6.66 ± 0.1% | 1.18 ± 0.3% | 6.64 ± 0.4% | 1.23 | 3.85 |
| a field path | 512 | 27.08 ± 0.8% | 0.83 ± 0.1% | 23.78 ± 2.1% | 3.39 ± 1.1% | differs | 2.95 ± 0.2% | 1.14 | 7.99 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.54 ± 0.5% | 1.13 ± 0.2% | 10.13 ± 0.2% | 4.81 ± 3.6% | 0.90 ± 0.6% | none | 0.25 | 0.53 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 258.02 ± 1.4% | 335.37 ± 0.4% | 87.08 ± 0.5% | 222.71 ± 1.1% | 470.40 ± 4.5% | 3822.08 ± 2.8% | 2.96 | 1.16 |
| a UUID | 62 | 195.61 ± 0.2% | 244.05 ± 0.3% | 46.75 ± 1.4% | 99.59 ± 6.4% | 189.71 ± 2.0% | 4325.69 ± 0.6% | 4.18 | 1.96 |
| an IPv4 address | 29 | 362.71 ± 0.7% | 570.25 ± 1.3% | 78.01 ± 0.3% | 130.93 ± 14.8% | 295.33 ± 0.9% | 7679.39 ± 0.4% | 4.65 | 2.77 |
| a date and time | 56 | 257.84 ± 0.3% | 337.97 ± 0.2% | 73.19 ± 0.4% | 136.56 ± 0.9% | 325.01 ± 2.0% | 4840.71 ± 0.5% | 3.52 | 1.89 |
| a field path | 39 | 277.47 ± 0.8% | 386.15 ± 0.6% | 80.58 ± 0.8% | 206.45 ± 1.2% | 495.46 ± 1.8% | 4912.55 ± 0.4% | 3.44 | 1.34 |
| prose: a word | 7 | 565.90 ± 0.3% | 1371.31 ± 0.2% | 529.21 ± 0.4% | 629.25 ± 1.5% | 958.74 ± 1.5% | 29321.09 ± 0.4% | 1.07 | 0.90 |
| prose: a word that is not there | 8 | 588.27 ± 0.3% | 1296.46 ± 0.2% | 475.31 ± 0.1% | 607.88 ± 1.7% | 904.47 ± 0.3% | 28114.22 ± 0.1% | 1.24 | 0.97 |
| prose: one of four words | 26 | 399.08 ± 0.2% | 602.35 ± 0.1% | 50.63 ± 1.0% | 244.24 ± 2.5% | 377.31 ± 0.2% | 15631.87 ± 0.1% | 7.88 | 1.63 |
| prose: a word in any case | 11 | 562.93 ± 0.4% | 1115.46 ± 0.4% | 15.39 ± 0.6% | 651.06 ± 3.5% | refused | 23230.85 ± 0.4% | 36.59 | 0.86 |
| prose: a word between two words | 13 | 482.51 ± 0.3% | 914.26 ± 0.1% | 136.10 ± 0.9% | 505.27 ± 0.8% | 787.10 ± 5.6% | 14596.88 ± 0.2% | 3.55 | 0.95 |
| prose: two capitalized words | 23 | 345.11 ± 0.3% | 571.23 ± 0.9% | 100.80 ± 0.6% | 501.42 ± 1.6% | 766.95 ± 0.7% | 6470.58 ± 0.4% | 3.42 | 0.69 |
| prose: a word that ends in ing | 9 | 500.53 ± 0.6% | 1097.64 ± 1.5% | 134.94 ± 0.5% | 758.04 ± 0.6% | 1112.12 ± 2.0% | 15771.14 ± 0.1% | 3.71 | 0.66 |
| prose: a word in capitals | 16 | 376.47 ± 0.2% | 740.62 ± 0.2% | 139.16 ± 0.9% | 752.45 ± 0.9% | 1048.77 ± 2.4% | 8448.44 ± 1.1% | 2.71 | 0.50 |
| markup: an href attribute | 12 | 362.68 ± 0.7% | 522.74 ± 0.6% | 44.40 ± 0.4% | 505.52 ± 1.5% | 767.66 ± 1.2% | 21198.99 ± 0.3% | 8.17 | 0.72 |
| markup: a heading's start tag | 13 | 347.62 ± 0.5% | 501.73 ± 0.3% | 43.09 ± 0.6% | 635.86 ± 0.5% | 846.43 ± 0.1% | 17735.04 ± 0.2% | 8.07 | 0.55 |
| markup: a number | 6 | 479.55 ± 0.2% | 1274.54 ± 0.1% | 41.63 ± 1.6% | 1389.10 ± 12.6% | 1882.05 ± 1.3% | 22457.25 ± 0.1% | 11.52 | 0.35 |

