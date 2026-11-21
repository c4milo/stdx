# bench-regex

| Field | Value |
|---|---|
| Commit | 4354b93 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44939231333 |
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
| prose: a word | 217 | 528.46 ± 0.4% | 20.20 ± 1.7% | 33749.90 ± 1.6% | 8731.00 ± 7.8% | 10.74 ± 0.9% | 75.86 ± 3.6% | 0.02 | 0.06 |
| prose: a word that is not there | 0 | 531.77 ± 0.1% | 19.86 ± 1.7% | 39745.54 ± 18.7% | 30052.01 ± 1.2% | 10.69 ± 0.1% | 71.72 ± 1.0% | 0.01 | 0.02 |
| prose: one of four words | 661 | 521.72 ± 0.4% | 11.35 ± 1.2% | 9541.99 ± 0.8% | 18.76 ± 1.7% | 4.00 ± 0.1% | 6.08 ± 2.5% | 0.05 | 27.82 |
| prose: a word in any case | 217 | 528.39 ± 0.3% | 15.45 ± 4.8% | 9898.89 ± 0.6% | 36.47 ± 3.3% | refused | differs | 0.05 | 14.49 |
| prose: a word between two words | 6104 | 433.12 ± 0.7% | 17.74 ± 1.5% | 878.52 ± 0.5% | 95.29 ± 10.5% | 7.24 ± 0.1% | 56.64 ± 0.3% | 0.49 | 4.55 |
| prose: two capitalized words | 1331 | 507.59 ± 0.1% | 19.22 ± 7.0% | 516.32 ± 0.3% | 33.79 ± 8.2% | 9.27 ± 0.4% | 55.72 ± 0.4% | 0.98 | 15.02 |
| prose: a word that ends in ing | 3399 | 477.17 ± 0.2% | 13.80 ± 1.0% | 489.76 ± 1.1% | 24.87 ± 8.4% | 5.32 ± 0.3% | 17.20 ± 3.7% | 0.97 | 19.18 |
| prose: a word in capitals | 2332 | 502.43 ± 0.0% | 20.31 ± 7.7% | 499.39 ± 1.0% | 35.00 ± 10.9% | 10.32 ± 0.4% | 76.56 ± 0.2% | 1.01 | 14.35 |
| markup: an href attribute | 33 | 530.67 ± 0.2% | 18.56 ± 2.6% | 26838.02 ± 0.8% | 2036.27 ± 1.0% | 8.21 ± 0.2% | 61.41 ± 0.7% | 0.02 | 0.26 |
| markup: a heading's start tag | 110 | 527.59 ± 0.4% | 19.58 ± 5.2% | 2221.94 ± 0.6% | 1444.37 ± 1.6% | 9.98 ± 0.2% | 72.70 ± 3.4% | 0.24 | 0.37 |
| markup: a number | 8288 | 451.91 ± 0.2% | 19.92 ± 4.2% | 2112.21 ± 0.3% | 34.48 ± 11.1% | 0.33 ± 0.5% | 55.84 ± 8.2% | 0.21 | 13.11 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 22.06 ± 2.5% | 0.47 ± 0.4% | 16.88 ± 0.3% | 2.08 ± 4.2% | differs | 3.54 ± 1.5% | 1.31 | 10.62 |
| a UUID | 512 | 14.89 ± 0.6% | 0.58 ± 0.4% | 12.06 ± 0.2% | 2.45 ± 1.7% | 0.43 ± 0.3% | 3.05 ± 0.6% | 1.23 | 6.08 |
| an IPv4 address | 512 | 37.67 ± 0.2% | 1.88 ± 2.0% | 29.23 ± 1.7% | 5.79 ± 0.7% | differs | 3.22 ± 0.4% | 1.29 | 6.50 |
| a date and time | 512 | 27.24 ± 3.6% | 1.33 ± 6.5% | 19.40 ± 5.2% | 6.33 ± 0.4% | 0.75 ± 1.2% | 6.10 ± 0.2% | 1.40 | 4.30 |
| a field path | 512 | 25.60 ± 3.8% | 0.75 ± 0.5% | 21.95 ± 0.9% | 2.91 ± 3.4% | differs | 2.48 ± 1.4% | 1.17 | 8.79 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.02 ± 4.9% | 0.92 ± 0.8% | 9.84 ± 1.2% | 4.38 ± 5.2% | 0.63 ± 0.3% | none | 0.21 | 0.46 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 202.16 ± 2.2% | 300.05 ± 0.5% | 82.75 ± 2.7% | 182.56 ± 2.0% | 557.29 ± 1.3% | 3566.79 ± 1.5% | 2.44 | 1.11 |
| a UUID | 62 | 148.89 ± 0.5% | 206.06 ± 0.2% | 47.91 ± 2.2% | 89.63 ± 3.4% | 203.03 ± 4.1% | 3936.29 ± 0.5% | 3.11 | 1.66 |
| an IPv4 address | 29 | 269.46 ± 0.4% | 537.70 ± 0.5% | 72.10 ± 0.9% | 111.71 ± 2.4% | 316.31 ± 1.1% | 6737.03 ± 0.9% | 3.74 | 2.41 |
| a date and time | 56 | 204.47 ± 0.1% | 311.29 ± 3.1% | 69.79 ± 1.1% | 122.77 ± 2.2% | 365.87 ± 0.9% | 3919.97 ± 0.3% | 2.93 | 1.67 |
| a field path | 39 | 213.97 ± 2.6% | 354.69 ± 0.2% | 75.87 ± 2.2% | 170.94 ± 5.2% | 592.75 ± 2.1% | 4454.02 ± 0.3% | 2.82 | 1.25 |
| prose: a word | 7 | 371.67 ± 0.5% | 1287.17 ± 0.5% | 529.32 ± 1.2% | 581.43 ± 3.2% | 1224.43 ± 0.5% | 24636.28 ± 0.3% | 0.70 | 0.64 |
| prose: a word that is not there | 8 | 417.24 ± 0.2% | 1205.84 ± 0.7% | 486.61 ± 1.3% | 556.23 ± 0.8% | 1122.21 ± 0.7% | 23491.76 ± 2.5% | 0.86 | 0.75 |
| prose: one of four words | 26 | 293.72 ± 0.3% | 547.48 ± 0.8% | 45.32 ± 1.4% | 220.15 ± 2.2% | 448.62 ± 0.9% | 9852.54 ± 0.9% | 6.48 | 1.33 |
| prose: a word in any case | 11 | 394.66 ± 0.4% | 1049.59 ± 0.8% | 14.84 ± 0.9% | 599.53 ± 1.6% | refused | 18581.96 ± 6.9% | 26.59 | 0.66 |
| prose: a word between two words | 13 | 341.27 ± 1.6% | 864.33 ± 0.5% | 125.34 ± 4.4% | 438.16 ± 2.6% | 1022.17 ± 0.5% | 12662.54 ± 0.8% | 2.72 | 0.78 |
| prose: two capitalized words | 23 | 247.20 ± 0.4% | 534.00 ± 0.6% | 94.25 ± 0.4% | 447.36 ± 1.6% | 942.85 ± 0.2% | 6138.39 ± 0.9% | 2.62 | 0.55 |
| prose: a word that ends in ing | 9 | 335.18 ± 1.9% | 1066.77 ± 0.5% | 117.43 ± 4.4% | 611.51 ± 3.3% | 1439.95 ± 1.9% | 14900.31 ± 2.6% | 2.85 | 0.55 |
| prose: a word in capitals | 16 | 251.94 ± 0.8% | 678.79 ± 1.1% | 123.37 ± 0.8% | 640.18 ± 1.6% | 1319.99 ± 2.4% | 8247.91 ± 0.3% | 2.04 | 0.39 |
| markup: an href attribute | 12 | 278.00 ± 0.5% | 501.19 ± 0.3% | 37.55 ± 1.6% | 423.39 ± 2.3% | 975.56 ± 1.2% | 17324.99 ± 0.3% | 7.40 | 0.66 |
| markup: a heading's start tag | 13 | 266.75 ± 0.5% | 482.62 ± 4.4% | 35.43 ± 0.4% | 517.28 ± 4.0% | 1045.37 ± 0.7% | 15386.61 ± 4.0% | 7.53 | 0.52 |
| markup: a number | 6 | 301.76 ± 0.4% | 1214.00 ± 0.3% | 37.58 ± 1.7% | 1144.67 ± 1.3% | 2262.03 ± 8.4% | 20182.44 ± 0.3% | 8.03 | 0.26 |

