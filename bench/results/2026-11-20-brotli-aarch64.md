# bench-brotli

| Field | Value |
|---|---|
| Commit | 0dd2e97 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261111.184.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1019-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44677316498 |
| Date | 2026-11-20 |
| Google | 1.2.0 |

## Decoding, quality 11, window 22

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 417.3 ±0.8% | 547.7 ±1.4% | 1.31 |
| silesia/mozilla | 51220480 | 27.5 | 348.1 ±0.4% | 447.5 ±0.4% | 1.29 |
| silesia/mr | 9970564 | 28.3 | 306.5 ±0.8% | 411.3 ±0.4% | 1.34 |
| silesia/nci | 33553445 | 4.8 | 1555.8 ±1.2% | 1884.0 ±4.5% | 1.21 |
| silesia/ooffice | 6152192 | 40.3 | 237.8 ±1.3% | 290.0 ±1.0% | 1.22 |
| silesia/osdb | 10085684 | 28.0 | 367.7 ±1.3% | 536.3 ±1.2% | 1.46 |
| silesia/reymont | 6627202 | 20.2 | 570.4 ±0.4% | 763.8 ±0.6% | 1.34 |
| silesia/samba | 21606400 | 17.7 | 621.9 ±0.6% | 851.0 ±0.8% | 1.37 |
| silesia/sao | 7251944 | 63.3 | 189.8 ±1.2% | 285.6 ±0.9% | 1.50 |
| silesia/webster | 41458703 | 21.2 | 513.3 ±0.6% | 643.3 ±1.0% | 1.25 |
| silesia/x-ray | 8474240 | 55.3 | 156.7 ±1.6% | 191.0 ±0.4% | 1.22 |
| silesia/xml | 5345280 | 8.1 | 1289.8 ±0.6% | 1864.5 ±0.5% | 1.45 |
| canterbury/alice29.txt | 152089 | 30.6 | 378.1 ±0.1% | 560.9 ±0.6% | 1.48 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 327.1 ±0.1% | 481.8 ±0.6% | 1.47 |
| canterbury/cp.html | 24603 | 28.0 | 364.6 ±0.7% | 586.1 ±3.5% | 1.61 |
| canterbury/fields.c | 11150 | 24.4 | 481.6 ±0.9% | 698.8 ±0.3% | 1.45 |
| canterbury/grammar.lsp | 3721 | 30.2 | 341.0 ±0.5% | 471.7 ±0.3% | 1.38 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 617.4 ±0.5% | 886.2 ±0.4% | 1.44 |
| canterbury/lcet10.txt | 426754 | 26.6 | 438.3 ±0.3% | 648.4 ±0.3% | 1.48 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 368.6 ±0.2% | 540.5 ±0.5% | 1.47 |
| canterbury/ptt5 | 513216 | 8.0 | 791.4 ±0.4% | 1439.4 ±0.6% | 1.82 |
| canterbury/sum | 38240 | 26.5 | 313.0 ±0.4% | 414.1 ±0.9% | 1.32 |
| canterbury/xargs.1 | 4227 | 34.6 | 306.9 ±0.6% | 397.4 ±0.1% | 1.30 |
| canterbury-large/E.coli | 4638690 | 24.5 | 402.7 ±0.5% | 494.7 ±0.3% | 1.23 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 581.5 ±0.5% | 819.7 ±0.5% | 1.41 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 564.1 ±0.8% | 758.5 ±0.2% | 1.34 |
| http/html-1kx1024 | 1048576 | 30.3 | 188.0 ±0.1% | 218.1 ±0.2% | 1.16 |
| http/html-16kx64 | 1048576 | 16.8 | 497.1 ±0.3% | 657.7 ±0.1% | 1.32 |
| http/html-1m | 1048576 | 13.0 | 832.4 ±0.4% | 1175.5 ±0.2% | 1.41 |
| http/json-1kx1024 | 1048576 | 18.2 | 233.6 ±0.1% | 257.1 ±0.2% | 1.10 |
| http/json-16kx64 | 1048576 | 8.9 | 759.5 ±0.2% | 1003.0 ±0.3% | 1.32 |
| http/json-1m | 1048576 | 7.7 | 990.4 ±0.3% | 1375.5 ±0.3% | 1.39 |
| http/js-1kx1024 | 1048576 | 35.1 | 170.0 ±0.1% | 203.6 ±0.2% | 1.20 |
| http/js-16kx64 | 1048576 | 20.7 | 418.2 ±0.2% | 561.6 ±0.4% | 1.34 |
| http/js-1m | 1048576 | 14.0 | 775.3 ±0.2% | 1061.1 ±0.9% | 1.37 |
| http/css-1kx1024 | 1048576 | 22.5 | 218.7 ±0.1% | 240.8 ±0.1% | 1.10 |
| http/css-16kx64 | 1048576 | 11.7 | 679.1 ±0.1% | 884.1 ±0.1% | 1.30 |
| http/css-1m | 1048576 | 2.4 | 1383.1 ±0.3% | 4640.7 ±0.8% | 3.36 |
| shuffled/dickens-1m | 1048576 | 56.8 | 331.8 ±0.6% | 384.3 ±0.4% | 1.16 |

## stdx's fast path against its checked path

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 108.7 ±1.2% | 547.0 ±0.8% | 5.03 |
| silesia/mozilla | 51220480 | 27.5 | 109.8 ±0.2% | 445.5 ±1.2% | 4.06 |
| silesia/mr | 9970564 | 28.3 | 106.3 ±0.5% | 414.7 ±1.1% | 3.90 |
| silesia/nci | 33553445 | 4.8 | 211.0 ±0.5% | 1889.4 ±2.6% | 8.95 |
| silesia/ooffice | 6152192 | 40.3 | 82.2 ±1.5% | 293.8 ±0.9% | 3.57 |
| silesia/osdb | 10085684 | 28.0 | 120.2 ±2.2% | 541.3 ±2.0% | 4.50 |
| silesia/reymont | 6627202 | 20.2 | 135.7 ±0.9% | 771.5 ±1.2% | 5.69 |
| silesia/samba | 21606400 | 17.7 | 151.4 ±0.4% | 855.4 ±1.2% | 5.65 |
| silesia/sao | 7251944 | 63.3 | 78.5 ±0.9% | 287.6 ±2.0% | 3.67 |
| silesia/webster | 41458703 | 21.2 | 125.1 ±1.3% | 650.1 ±2.4% | 5.19 |
| silesia/x-ray | 8474240 | 55.3 | 68.2 ±0.6% | 194.1 ±1.7% | 2.85 |
| silesia/xml | 5345280 | 8.1 | 197.1 ±0.2% | 1874.3 ±0.5% | 9.51 |
| canterbury/alice29.txt | 152089 | 30.6 | 109.6 ±0.1% | 563.4 ±0.5% | 5.14 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 100.6 ±0.1% | 482.8 ±0.6% | 4.80 |
| canterbury/cp.html | 24603 | 28.0 | 112.7 ±0.2% | 602.2 ±2.4% | 5.34 |
| canterbury/fields.c | 11150 | 24.4 | 116.7 ±0.2% | 696.1 ±0.2% | 5.96 |
| canterbury/grammar.lsp | 3721 | 30.2 | 100.2 ±0.4% | 470.0 ±0.3% | 4.69 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 130.9 ±0.1% | 886.1 ±0.3% | 6.77 |
| canterbury/lcet10.txt | 426754 | 26.6 | 120.9 ±0.4% | 652.5 ±0.3% | 5.40 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 107.2 ±0.1% | 551.6 ±0.3% | 5.15 |
| canterbury/ptt5 | 513216 | 8.0 | 188.1 ±0.0% | 1448.7 ±0.3% | 7.70 |
| canterbury/sum | 38240 | 26.5 | 97.4 ±0.1% | 421.4 ±0.8% | 4.33 |
| canterbury/xargs.1 | 4227 | 34.6 | 91.6 ±0.2% | 397.9 ±0.2% | 4.34 |
| canterbury-large/E.coli | 4638690 | 24.5 | 109.4 ±0.0% | 493.9 ±0.2% | 4.51 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 135.8 ±1.2% | 823.1 ±0.6% | 6.06 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 141.6 ±0.8% | 769.0 ±0.3% | 5.43 |
| http/html-1kx1024 | 1048576 | 30.3 | 84.7 ±0.1% | 218.3 ±0.2% | 2.58 |
| http/html-16kx64 | 1048576 | 16.8 | 139.3 ±0.2% | 659.0 ±0.2% | 4.73 |
| http/html-1m | 1048576 | 13.0 | 165.0 ±0.4% | 1182.6 ±0.3% | 7.17 |
| http/json-1kx1024 | 1048576 | 18.2 | 99.0 ±0.2% | 257.6 ±0.1% | 2.60 |
| http/json-16kx64 | 1048576 | 8.9 | 163.4 ±0.1% | 1003.4 ±0.2% | 6.14 |
| http/json-1m | 1048576 | 7.7 | 175.4 ±0.1% | 1377.6 ±0.7% | 7.86 |
| http/js-1kx1024 | 1048576 | 35.1 | 78.0 ±0.1% | 203.7 ±0.1% | 2.61 |
| http/js-16kx64 | 1048576 | 20.7 | 124.8 ±0.1% | 561.1 ±0.2% | 4.49 |
| http/js-1m | 1048576 | 14.0 | 160.2 ±0.1% | 1068.0 ±0.4% | 6.67 |
| http/css-1kx1024 | 1048576 | 22.5 | 94.3 ±0.1% | 242.5 ±0.1% | 2.57 |
| http/css-16kx64 | 1048576 | 11.7 | 154.9 ±0.2% | 878.6 ±0.2% | 5.67 |
| http/css-1m | 1048576 | 2.4 | 244.8 ±0.2% | 4572.6 ±0.5% | 18.68 |
| shuffled/dickens-1m | 1048576 | 56.8 | 92.1 ±0.1% | 387.3 ±0.3% | 4.20 |

## The claims, each off against the fast path with all on

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | S1 word refill off | S4 chunk copies off | S5 window once off | unchecked loop off |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 548.8 ±1.4% | 0.56 ±2.9% | 0.54 ±2.8% | 0.97 ±0.8% | 0.54 ±1.2% |
| silesia/mozilla | 51220480 | 27.5 | 444.7 ±0.7% | 0.67 ±0.6% | 0.65 ±0.6% | 0.98 ±1.1% | 0.67 ±0.8% |
| silesia/mr | 9970564 | 28.3 | 419.5 ±1.7% | 0.64 ±2.3% | 0.63 ±1.7% | 0.98 ±1.6% | 0.63 ±1.0% |
| silesia/nci | 33553445 | 4.8 | 1904.9 ±1.9% | 0.65 ±4.7% | 0.50 ±1.4% | 0.93 ±1.7% | 0.63 ±1.9% |
| silesia/ooffice | 6152192 | 40.3 | 293.4 ±0.5% | 0.67 ±1.2% | 0.66 ±0.7% | 0.99 ±0.8% | 0.66 ±0.9% |
| silesia/osdb | 10085684 | 28.0 | 536.4 ±1.8% | 0.65 ±1.9% | 0.62 ±2.2% | 0.99 ±1.2% | 0.65 ±1.8% |
| silesia/reymont | 6627202 | 20.2 | 770.6 ±0.4% | 0.55 ±0.9% | 0.50 ±1.4% | 0.97 ±1.1% | 0.54 ±0.3% |
| silesia/samba | 21606400 | 17.7 | 859.9 ±0.9% | 0.63 ±1.5% | 0.58 ±0.7% | 0.96 ±1.0% | 0.63 ±1.0% |
| silesia/sao | 7251944 | 63.3 | 286.7 ±2.2% | 0.66 ±1.8% | 0.71 ±0.7% | 0.99 ±1.6% | 0.66 ±2.1% |
| silesia/webster | 41458703 | 21.2 | 651.0 ±2.0% | 0.55 ±2.7% | 0.52 ±2.6% | 0.97 ±2.2% | 0.54 ±1.2% |
| silesia/x-ray | 8474240 | 55.3 | 194.8 ±0.6% | 0.69 ±1.2% | 0.78 ±1.6% | 0.99 ±1.3% | 0.67 ±1.0% |
| silesia/xml | 5345280 | 8.1 | 1877.2 ±0.6% | 0.59 ±0.2% | 0.47 ±0.6% | 0.94 ±0.6% | 0.57 ±0.2% |
| canterbury/alice29.txt | 152089 | 30.6 | 562.5 ±1.3% | 0.59 ±0.1% | 0.55 ±0.2% | 0.99 ±0.5% | 0.57 ±0.0% |
| canterbury/asyoulik.txt | 125179 | 34.1 | 486.3 ±0.9% | 0.60 ±0.4% | 0.56 ±0.1% | 0.99 ±0.4% | 0.58 ±0.1% |
| canterbury/cp.html | 24603 | 28.0 | 607.7 ±0.9% | 0.58 ±1.0% | 0.56 ±0.8% | 0.98 ±0.7% | 0.55 ±0.2% |
| canterbury/fields.c | 11150 | 24.4 | 698.7 ±0.4% | 0.58 ±1.1% | 0.57 ±0.9% | 0.98 ±0.4% | 0.51 ±0.7% |
| canterbury/grammar.lsp | 3721 | 30.2 | 469.1 ±0.2% | 0.70 ±0.7% | 0.69 ±1.1% | 0.99 ±0.2% | 0.60 ±0.7% |
| canterbury/kennedy.xls | 1029744 | 6.0 | 881.6 ±0.5% | 0.58 ±0.6% | 0.53 ±0.3% | 0.97 ±0.3% | 0.51 ±0.2% |
| canterbury/lcet10.txt | 426754 | 26.6 | 654.1 ±0.5% | 0.60 ±0.1% | 0.54 ±0.2% | 0.97 ±0.6% | 0.58 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 33.9 | 551.9 ±0.3% | 0.57 ±0.2% | 0.54 ±0.4% | 0.98 ±0.4% | 0.56 ±0.1% |
| canterbury/ptt5 | 513216 | 8.0 | 1448.7 ±0.2% | 0.67 ±0.2% | 0.47 ±0.2% | 0.95 ±0.2% | 0.66 ±0.1% |
| canterbury/sum | 38240 | 26.5 | 421.8 ±2.6% | 0.64 ±0.4% | 0.63 ±0.5% | 1.00 ±2.5% | 0.63 ±0.6% |
| canterbury/xargs.1 | 4227 | 34.6 | 396.7 ±0.2% | 0.71 ±0.6% | 0.71 ±0.9% | 0.98 ±0.2% | 0.62 ±0.3% |
| canterbury-large/E.coli | 4638690 | 24.5 | 494.0 ±0.5% | 0.88 ±0.1% | 0.91 ±0.7% | 0.98 ±0.3% | 0.87 ±0.2% |
| canterbury-large/bible.txt | 4047392 | 22.0 | 823.1 ±0.4% | 0.55 ±0.6% | 0.50 ±0.7% | 0.97 ±0.8% | 0.54 ±0.8% |
| canterbury-large/world192.txt | 2473400 | 19.2 | 766.3 ±0.7% | 0.62 ±0.7% | 0.57 ±0.7% | 0.95 ±1.0% | 0.60 ±0.6% |
| http/html-1kx1024 | 1048576 | 30.3 | 217.7 ±0.1% | 0.80 ±0.1% | 0.81 ±0.3% | 0.99 ±0.1% | 0.80 ±0.1% |
| http/html-16kx64 | 1048576 | 16.8 | 657.8 ±0.1% | 0.68 ±0.1% | 0.63 ±0.1% | 0.98 ±0.2% | 0.66 ±0.1% |
| http/html-1m | 1048576 | 13.0 | 1180.4 ±0.3% | 0.59 ±0.2% | 0.51 ±0.4% | 0.96 ±0.3% | 0.57 ±0.1% |
| http/json-1kx1024 | 1048576 | 18.2 | 257.3 ±0.0% | 0.84 ±0.1% | 0.83 ±0.1% | 0.97 ±0.1% | 0.83 ±0.1% |
| http/json-16kx64 | 1048576 | 8.9 | 1002.7 ±0.1% | 0.66 ±0.1% | 0.59 ±0.1% | 0.97 ±0.1% | 0.62 ±0.5% |
| http/json-1m | 1048576 | 7.7 | 1373.9 ±0.5% | 0.60 ±0.2% | 0.52 ±0.1% | 0.96 ±0.6% | 0.56 ±0.5% |
| http/js-1kx1024 | 1048576 | 35.1 | 203.5 ±0.1% | 0.79 ±0.2% | 0.79 ±0.1% | 0.99 ±0.2% | 0.78 ±0.1% |
| http/js-16kx64 | 1048576 | 20.7 | 558.7 ±0.1% | 0.67 ±0.1% | 0.63 ±0.1% | 0.99 ±0.2% | 0.65 ±0.1% |
| http/js-1m | 1048576 | 14.0 | 1061.8 ±0.5% | 0.59 ±0.5% | 0.52 ±0.4% | 0.96 ±0.3% | 0.57 ±0.5% |
| http/css-1kx1024 | 1048576 | 22.5 | 242.8 ±0.1% | 0.82 ±0.1% | 0.80 ±0.1% | 0.97 ±0.2% | 0.81 ±0.2% |
| http/css-16kx64 | 1048576 | 11.7 | 880.2 ±0.1% | 0.65 ±0.1% | 0.57 ±0.4% | 0.98 ±0.1% | 0.64 ±0.2% |
| http/css-1m | 1048576 | 2.4 | 4674.0 ±0.7% | 0.63 ±0.5% | 0.35 ±0.5% | 0.85 ±0.8% | 0.57 ±0.7% |
| shuffled/dickens-1m | 1048576 | 56.8 | 385.9 ±0.5% | 0.88 ±0.2% | 0.95 ±0.2% | 0.98 ±0.5% | 0.87 ±0.6% |

## Encoding speed, level 1 at WBITS 18

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Google q1, MB/s | stdx 1, MB/s | stdx 1 checked, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 199.4 ± 0.6% | 172.7 ± 0.2% | 173.0 ± 0.2% | 0.87 |
| silesia/mozilla | 51220480 | 269.0 ± 0.4% | 272.7 ± 0.2% | 272.7 ± 0.1% | 1.01 |
| silesia/mr | 9970564 | 270.7 ± 0.3% | 245.3 ± 0.2% | 244.7 ± 0.3% | 0.91 |
| silesia/nci | 33553445 | 678.1 ± 0.5% | 553.0 ± 0.4% | 553.9 ± 0.6% | 0.82 |
| silesia/ooffice | 6152192 | 204.6 ± 0.4% | 199.6 ± 0.2% | 199.5 ± 0.2% | 0.98 |
| silesia/osdb | 10085684 | 291.0 ± 0.1% | 287.0 ± 0.2% | 287.2 ± 0.3% | 0.99 |
| silesia/reymont | 6627202 | 236.3 ± 0.4% | 232.6 ± 0.4% | 232.7 ± 0.2% | 0.98 |
| silesia/samba | 21606400 | 361.6 ± 0.4% | 338.4 ± 0.5% | 338.3 ± 0.4% | 0.94 |
| silesia/sao | 7251944 | 174.1 ± 0.4% | 179.1 ± 0.2% | 179.4 ± 0.4% | 1.03 |
| silesia/webster | 41458703 | 248.2 ± 0.3% | 219.9 ± 0.2% | 220.1 ± 0.3% | 0.89 |
| silesia/x-ray | 8474240 | 245.8 ± 0.4% | 256.0 ± 0.3% | 256.1 ± 0.5% | 1.04 |
| silesia/xml | 5345280 | 511.3 ± 0.2% | 457.3 ± 0.4% | 457.1 ± 0.8% | 0.89 |
| canterbury/alice29.txt | 152089 | 212.0 ± 0.2% | 184.6 ± 0.1% | 185.4 ± 0.1% | 0.87 |
| canterbury/asyoulik.txt | 125179 | 199.9 ± 0.5% | 168.6 ± 0.2% | 168.9 ± 0.2% | 0.84 |
| canterbury/cp.html | 24603 | 269.1 ± 1.7% | 234.2 ± 0.7% | 242.9 ± 0.4% | 0.87 |
| canterbury/fields.c | 11150 | 288.8 ± 0.4% | 329.5 ± 0.5% | 334.0 ± 0.7% | 1.14 |
| canterbury/grammar.lsp | 3721 | 237.4 ± 0.4% | 254.9 ± 0.9% | 254.8 ± 0.7% | 1.07 |
| canterbury/kennedy.xls | 1029744 | 352.8 ± 0.3% | 432.8 ± 0.2% | 433.5 ± 0.3% | 1.23 |
| canterbury/lcet10.txt | 426754 | 223.8 ± 0.5% | 200.8 ± 0.2% | 200.9 ± 0.3% | 0.90 |
| canterbury/plrabn12.txt | 481861 | 189.5 ± 0.3% | 161.9 ± 0.2% | 162.2 ± 0.2% | 0.85 |
| canterbury/ptt5 | 513216 | 714.3 ± 0.3% | 509.0 ± 0.5% | 505.4 ± 0.3% | 0.71 |
| canterbury/sum | 38240 | 274.3 ± 0.3% | 220.8 ± 0.3% | 223.0 ± 0.2% | 0.81 |
| canterbury/xargs.1 | 4227 | 211.8 ± 0.4% | 232.2 ± 0.7% | 233.3 ± 0.5% | 1.10 |
| canterbury-large/E.coli | 4638690 | 265.0 ± 0.3% | 598.3 ± 0.7% | 602.7 ± 0.7% | 2.26 |
| canterbury-large/bible.txt | 4047392 | 246.8 ± 0.3% | 219.7 ± 0.3% | 220.4 ± 0.3% | 0.89 |
| canterbury-large/world192.txt | 2473400 | 265.4 ± 0.7% | 245.2 ± 0.7% | 245.7 ± 0.4% | 0.92 |
| http/html-1kx1024 | 1048576 | 105.8 ± 0.4% | 123.6 ± 0.3% | 124.4 ± 0.2% | 1.17 |
| http/html-16kx64 | 1048576 | 305.4 ± 0.1% | 295.0 ± 0.1% | 296.1 ± 0.2% | 0.97 |
| http/html-1m | 1048576 | 402.2 ± 0.2% | 349.9 ± 0.3% | 350.7 ± 0.5% | 0.87 |
| http/json-1kx1024 | 1048576 | 138.4 ± 0.2% | 161.9 ± 0.2% | 162.3 ± 0.2% | 1.17 |
| http/json-16kx64 | 1048576 | 457.5 ± 0.1% | 481.3 ± 0.2% | 480.9 ± 0.2% | 1.05 |
| http/json-1m | 1048576 | 568.3 ± 0.5% | 506.4 ± 0.5% | 507.5 ± 0.2% | 0.89 |
| http/js-1kx1024 | 1048576 | 97.8 ± 0.2% | 111.5 ± 0.4% | 111.8 ± 0.2% | 1.14 |
| http/js-16kx64 | 1048576 | 262.4 ± 0.3% | 253.9 ± 0.1% | 254.4 ± 0.2% | 0.97 |
| http/js-1m | 1048576 | 369.1 ± 0.5% | 332.7 ± 0.2% | 333.2 ± 0.2% | 0.90 |
| http/css-1kx1024 | 1048576 | 123.3 ± 0.3% | 143.8 ± 0.4% | 144.3 ± 0.2% | 1.17 |
| http/css-16kx64 | 1048576 | 386.9 ± 0.2% | 400.0 ± 0.1% | 399.7 ± 0.3% | 1.03 |
| http/css-1m | 1048576 | 596.3 ± 0.2% | 621.0 ± 0.2% | 620.7 ± 0.3% | 1.04 |
| shuffled/dickens-1m | 1048576 | 297.4 ± 0.6% | 631.7 ± 0.3% | 634.1 ± 0.3% | 2.12 |

## Encoding ratio, level 1 at WBITS 18

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Google q1, ratio | stdx 1, ratio | stdx 1 checked, ratio | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 2.434 | 2.550 | 2.550 | 1.047 |
| silesia/mozilla | 51220480 | 2.465 | 2.660 | 2.660 | 1.079 |
| silesia/mr | 9970564 | 2.625 | 2.783 | 2.783 | 1.060 |
| silesia/nci | 33553445 | 9.253 | 10.255 | 10.255 | 1.108 |
| silesia/ooffice | 6152192 | 1.734 | 1.872 | 1.872 | 1.080 |
| silesia/osdb | 10085684 | 2.631 | 2.832 | 2.832 | 1.076 |
| silesia/reymont | 6627202 | 2.988 | 3.245 | 3.245 | 1.086 |
| silesia/samba | 21606400 | 3.745 | 4.052 | 4.052 | 1.082 |
| silesia/sao | 7251944 | 1.200 | 1.245 | 1.245 | 1.038 |
| silesia/webster | 41458703 | 2.991 | 3.206 | 3.206 | 1.072 |
| silesia/x-ray | 8474240 | 1.252 | 1.301 | 1.301 | 1.039 |
| silesia/xml | 5345280 | 6.493 | 7.377 | 7.377 | 1.136 |
| canterbury/alice29.txt | 152089 | 2.523 | 2.648 | 2.648 | 1.050 |
| canterbury/asyoulik.txt | 125179 | 2.344 | 2.436 | 2.436 | 1.039 |
| canterbury/cp.html | 24603 | 2.682 | 2.909 | 2.909 | 1.085 |
| canterbury/fields.c | 11150 | 2.965 | 3.315 | 3.315 | 1.118 |
| canterbury/grammar.lsp | 3721 | 2.665 | 2.871 | 2.871 | 1.077 |
| canterbury/kennedy.xls | 1029744 | 5.958 | 8.725 | 8.725 | 1.465 |
| canterbury/lcet10.txt | 426754 | 2.693 | 2.858 | 2.858 | 1.061 |
| canterbury/plrabn12.txt | 481861 | 2.298 | 2.366 | 2.366 | 1.030 |
| canterbury/ptt5 | 513216 | 8.738 | 9.019 | 9.019 | 1.032 |
| canterbury/sum | 38240 | 2.673 | 2.835 | 2.835 | 1.060 |
| canterbury/xargs.1 | 4227 | 2.178 | 2.305 | 2.305 | 1.058 |
| canterbury-large/E.coli | 4638690 | 3.275 | 3.989 | 3.989 | 1.218 |
| canterbury-large/bible.txt | 4047392 | 3.037 | 3.280 | 3.280 | 1.080 |
| canterbury-large/world192.txt | 2473400 | 3.090 | 3.401 | 3.401 | 1.101 |
| http/html-1kx1024 | 1048576 | 2.436 | 2.648 | 2.648 | 1.087 |
| http/html-16kx64 | 1048576 | 4.129 | 4.562 | 4.562 | 1.105 |
| http/html-1m | 1048576 | 5.017 | 5.453 | 5.453 | 1.087 |
| http/json-1kx1024 | 1048576 | 4.117 | 4.820 | 4.820 | 1.171 |
| http/json-16kx64 | 1048576 | 6.727 | 7.702 | 7.702 | 1.145 |
| http/json-1m | 1048576 | 7.602 | 7.833 | 7.833 | 1.030 |
| http/js-1kx1024 | 1048576 | 2.143 | 2.332 | 2.332 | 1.088 |
| http/js-16kx64 | 1048576 | 3.416 | 3.844 | 3.844 | 1.125 |
| http/js-1m | 1048576 | 4.521 | 5.045 | 5.045 | 1.116 |
| http/css-1kx1024 | 1048576 | 3.229 | 3.609 | 3.609 | 1.118 |
| http/css-16kx64 | 1048576 | 5.368 | 6.005 | 6.005 | 1.119 |
| http/css-1m | 1048576 | 7.511 | 10.397 | 10.397 | 1.384 |
| shuffled/dickens-1m | 1048576 | 1.760 | 1.759 | 1.759 | 1.000 |

## Encoding speed, level 5 at WBITS 22

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Google q5, MB/s | stdx 5, MB/s | stdx / Google |
|---|---|---|---|---|
| silesia/dickens | 10192446 | 31.3 ± 0.8% | 47.2 ± 0.6% | 1.51 |
| silesia/mozilla | 51220480 | 52.7 ± 2.8% | 57.2 ± 0.1% | 1.08 |
| silesia/mr | 9970564 | 39.7 ± 16.4% | 53.9 ± 0.6% | 1.36 |
| silesia/nci | 33553445 | 109.7 ± 0.4% | 126.8 ± 0.6% | 1.16 |
| silesia/ooffice | 6152192 | 36.7 ± 0.8% | 45.1 ± 0.7% | 1.23 |
| silesia/osdb | 10085684 | 47.9 ± 0.3% | 66.9 ± 0.8% | 1.40 |
| silesia/reymont | 6627202 | 41.1 ± 0.5% | 55.7 ± 0.8% | 1.35 |
| silesia/samba | 21606400 | 70.1 ± 10.0% | 81.2 ± 0.5% | 1.16 |
| silesia/sao | 7251944 | 29.2 ± 0.3% | 37.3 ± 1.1% | 1.27 |
| silesia/webster | 41458703 | 43.5 ± 2.3% | 59.3 ± 0.2% | 1.36 |
| silesia/x-ray | 8474240 | 31.5 ± 0.4% | 38.8 ± 0.4% | 1.23 |
| silesia/xml | 5345280 | 104.7 ± 0.8% | 128.7 ± 0.4% | 1.23 |
| canterbury/alice29.txt | 152089 | 42.4 ± 0.9% | 56.4 ± 0.8% | 1.33 |
| canterbury/asyoulik.txt | 125179 | 39.7 ± 0.4% | 51.1 ± 1.0% | 1.29 |
| canterbury/cp.html | 24603 | 54.8 ± 0.5% | 72.2 ± 0.6% | 1.32 |
| canterbury/fields.c | 11150 | 57.9 ± 0.5% | 84.1 ± 0.9% | 1.45 |
| canterbury/grammar.lsp | 3721 | 56.9 ± 0.5% | 86.8 ± 0.8% | 1.53 |
| canterbury/kennedy.xls | 1029744 | 71.7 ± 0.2% | 66.6 ± 1.0% | 0.93 |
| canterbury/lcet10.txt | 426754 | 43.2 ± 0.6% | 58.0 ± 0.8% | 1.34 |
| canterbury/plrabn12.txt | 481861 | 34.8 ± 0.3% | 46.2 ± 0.6% | 1.33 |
| canterbury/ptt5 | 513216 | 122.5 ± 0.5% | 119.5 ± 1.1% | 0.98 |
| canterbury/sum | 38240 | 51.7 ± 0.7% | 59.6 ± 0.6% | 1.15 |
| canterbury/xargs.1 | 4227 | 49.1 ± 0.6% | 76.6 ± 0.8% | 1.56 |
| canterbury-large/E.coli | 4638690 | 37.3 ± 0.8% | 109.9 ± 0.2% | 2.95 |
| canterbury-large/bible.txt | 4047392 | 40.7 ± 0.7% | 57.4 ± 1.4% | 1.41 |
| canterbury-large/world192.txt | 2473400 | 46.5 ± 0.9% | 70.2 ± 0.7% | 1.51 |
| http/html-1kx1024 | 1048576 | 32.2 ± 0.4% | 52.6 ± 0.9% | 1.63 |
| http/html-16kx64 | 1048576 | 73.1 ± 0.5% | 93.7 ± 0.5% | 1.28 |
| http/html-1m | 1048576 | 72.2 ± 0.4% | 99.3 ± 0.7% | 1.38 |
| http/json-1kx1024 | 1048576 | 43.2 ± 0.5% | 71.1 ± 0.6% | 1.65 |
| http/json-16kx64 | 1048576 | 95.4 ± 0.3% | 105.7 ± 0.8% | 1.11 |
| http/json-1m | 1048576 | 92.3 ± 0.6% | 96.2 ± 0.9% | 1.04 |
| http/js-1kx1024 | 1048576 | 29.5 ± 0.3% | 47.7 ± 0.8% | 1.62 |
| http/js-16kx64 | 1048576 | 61.8 ± 0.3% | 80.7 ± 0.7% | 1.31 |
| http/js-1m | 1048576 | 64.2 ± 0.5% | 91.4 ± 0.9% | 1.42 |
| http/css-1kx1024 | 1048576 | 39.7 ± 0.3% | 65.9 ± 0.5% | 1.66 |
| http/css-16kx64 | 1048576 | 91.7 ± 0.3% | 116.4 ± 0.3% | 1.27 |
| http/css-1m | 1048576 | 235.0 ± 0.8% | 287.2 ± 0.7% | 1.22 |
| shuffled/dickens-1m | 1048576 | 32.2 ± 0.8% | 78.2 ± 1.4% | 2.43 |

## Encoding ratio, level 5 at WBITS 22

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Google q5, ratio | stdx 5, ratio | stdx / Google |
|---|---|---|---|---|
| silesia/dickens | 10192446 | 3.014 | 2.959 | 0.982 |
| silesia/mozilla | 51220480 | 3.109 | 3.023 | 0.972 |
| silesia/mr | 9970564 | 3.061 | 3.019 | 0.986 |
| silesia/nci | 33553445 | 15.017 | 14.938 | 0.995 |
| silesia/ooffice | 6152192 | 2.158 | 2.117 | 0.981 |
| silesia/osdb | 10085684 | 3.058 | 2.973 | 0.972 |
| silesia/reymont | 6627202 | 3.872 | 3.821 | 0.987 |
| silesia/samba | 21606400 | 4.843 | 4.798 | 0.991 |
| silesia/sao | 7251944 | 1.378 | 1.376 | 0.998 |
| silesia/webster | 41458703 | 3.911 | 3.823 | 0.977 |
| silesia/x-ray | 8474240 | 1.540 | 1.562 | 1.014 |
| silesia/xml | 5345280 | 10.264 | 10.143 | 0.988 |
| canterbury/alice29.txt | 152089 | 2.880 | 2.910 | 1.010 |
| canterbury/asyoulik.txt | 125179 | 2.631 | 2.637 | 1.002 |
| canterbury/cp.html | 24603 | 3.171 | 3.189 | 1.005 |
| canterbury/fields.c | 11150 | 3.702 | 3.714 | 1.003 |
| canterbury/grammar.lsp | 3721 | 3.135 | 3.103 | 0.990 |
| canterbury/kennedy.xls | 1029744 | 14.403 | 15.123 | 1.050 |
| canterbury/lcet10.txt | 426754 | 3.185 | 3.258 | 1.023 |
| canterbury/plrabn12.txt | 481861 | 2.590 | 2.640 | 1.019 |
| canterbury/ptt5 | 513216 | 10.602 | 10.499 | 0.990 |
| canterbury/sum | 38240 | 3.307 | 3.266 | 0.987 |
| canterbury/xargs.1 | 4227 | 2.554 | 2.595 | 1.016 |
| canterbury-large/E.coli | 4638690 | 3.476 | 3.999 | 1.151 |
| canterbury-large/bible.txt | 4047392 | 3.821 | 3.798 | 0.994 |
| canterbury-large/world192.txt | 2473400 | 4.421 | 4.228 | 0.956 |
| http/html-1kx1024 | 1048576 | 3.003 | 2.992 | 0.996 |
| http/html-16kx64 | 1048576 | 5.274 | 5.282 | 1.002 |
| http/html-1m | 1048576 | 6.652 | 6.624 | 0.996 |
| http/json-1kx1024 | 1048576 | 5.358 | 5.197 | 0.970 |
| http/json-16kx64 | 1048576 | 9.313 | 9.299 | 0.999 |
| http/json-1m | 1048576 | 10.074 | 10.137 | 1.006 |
| http/js-1kx1024 | 1048576 | 2.615 | 2.593 | 0.992 |
| http/js-16kx64 | 1048576 | 4.333 | 4.347 | 1.003 |
| http/js-1m | 1048576 | 6.112 | 6.113 | 1.000 |
| http/css-1kx1024 | 1048576 | 4.293 | 4.268 | 0.994 |
| http/css-16kx64 | 1048576 | 7.638 | 7.567 | 0.991 |
| http/css-1m | 1048576 | 34.430 | 33.700 | 0.979 |
| shuffled/dickens-1m | 1048576 | 1.662 | 1.748 | 1.052 |

## Encoding, Google's brotli

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Quality | WBITS | Google, MB/s | Ratio |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 22 | 179.6 ± 0.5% | 2.522 |
| silesia/mozilla | 51220480 | 1 | 22 | 218.9 ± 0.8% | 2.516 |
| silesia/mr | 9970564 | 1 | 22 | 218.8 ± 0.6% | 2.658 |
| silesia/nci | 33553445 | 1 | 22 | 649.7 ± 0.4% | 9.472 |
| silesia/ooffice | 6152192 | 1 | 22 | 161.2 ± 0.3% | 1.770 |
| silesia/osdb | 10085684 | 1 | 22 | 228.7 ± 0.5% | 2.731 |
| silesia/reymont | 6627202 | 1 | 22 | 230.9 ± 0.4% | 3.052 |
| silesia/samba | 21606400 | 1 | 22 | 325.8 ± 0.8% | 3.880 |
| silesia/sao | 7251944 | 1 | 22 | 128.6 ± 0.2% | 1.226 |
| silesia/webster | 41458703 | 1 | 22 | 212.1 ± 0.3% | 3.080 |
| silesia/x-ray | 8474240 | 1 | 22 | 183.0 ± 0.4% | 1.267 |
| silesia/xml | 5345280 | 1 | 22 | 515.4 ± 0.7% | 6.994 |
| canterbury/alice29.txt | 152089 | 1 | 22 | 212.7 ± 0.7% | 2.523 |
| canterbury/asyoulik.txt | 125179 | 1 | 22 | 200.4 ± 0.3% | 2.344 |
| canterbury/cp.html | 24603 | 1 | 22 | 274.7 ± 2.0% | 2.682 |
| canterbury/fields.c | 11150 | 1 | 22 | 289.7 ± 0.4% | 2.965 |
| canterbury/grammar.lsp | 3721 | 1 | 22 | 237.0 ± 0.3% | 2.665 |
| canterbury/kennedy.xls | 1029744 | 1 | 22 | 341.6 ± 0.4% | 6.009 |
| canterbury/lcet10.txt | 426754 | 1 | 22 | 222.7 ± 0.4% | 2.755 |
| canterbury/plrabn12.txt | 481861 | 1 | 22 | 184.8 ± 0.5% | 2.338 |
| canterbury/ptt5 | 513216 | 1 | 22 | 711.0 ± 0.5% | 8.698 |
| canterbury/sum | 38240 | 1 | 22 | 279.0 ± 1.7% | 2.673 |
| canterbury/xargs.1 | 4227 | 1 | 22 | 210.9 ± 0.2% | 2.178 |
| canterbury-large/E.coli | 4638690 | 1 | 22 | 269.8 ± 0.2% | 3.283 |
| canterbury-large/bible.txt | 4047392 | 1 | 22 | 232.0 ± 0.5% | 3.128 |
| canterbury-large/world192.txt | 2473400 | 1 | 22 | 237.1 ± 0.5% | 3.264 |
| http/html-1kx1024 | 1048576 | 1 | 22 | 106.0 ± 0.1% | 2.436 |
| http/html-16kx64 | 1048576 | 1 | 22 | 306.3 ± 0.2% | 4.129 |
| http/html-1m | 1048576 | 1 | 22 | 384.1 ± 0.9% | 5.112 |
| http/json-1kx1024 | 1048576 | 1 | 22 | 138.3 ± 0.2% | 4.117 |
| http/json-16kx64 | 1048576 | 1 | 22 | 458.8 ± 0.2% | 6.727 |
| http/json-1m | 1048576 | 1 | 22 | 555.3 ± 0.4% | 7.629 |
| http/js-1kx1024 | 1048576 | 1 | 22 | 98.1 ± 0.1% | 2.143 |
| http/js-16kx64 | 1048576 | 1 | 22 | 263.2 ± 0.2% | 3.416 |
| http/js-1m | 1048576 | 1 | 22 | 358.5 ± 0.4% | 4.651 |
| http/css-1kx1024 | 1048576 | 1 | 22 | 123.6 ± 0.1% | 3.229 |
| http/css-16kx64 | 1048576 | 1 | 22 | 388.2 ± 0.2% | 5.368 |
| http/css-1m | 1048576 | 1 | 22 | 735.4 ± 0.8% | 9.626 |
| shuffled/dickens-1m | 1048576 | 1 | 22 | 290.2 ± 0.6% | 1.760 |

## stdx built ReleaseFast against Google's brotli, quality 11, window 22 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 414.8 ±0.7% | 533.7 ±2.8% | 1.29 |
| silesia/mozilla | 51220480 | 27.5 | 345.5 ±0.8% | 441.4 ±1.6% | 1.28 |
| silesia/mr | 9970564 | 28.3 | 304.6 ±1.0% | 397.3 ±2.9% | 1.30 |
| silesia/nci | 33553445 | 4.8 | 1547.0 ±0.4% | 1799.1 ±3.2% | 1.16 |
| silesia/ooffice | 6152192 | 40.3 | 234.7 ±1.9% | 288.3 ±1.6% | 1.23 |
| silesia/osdb | 10085684 | 28.0 | 366.6 ±0.3% | 520.3 ±2.4% | 1.42 |
| silesia/reymont | 6627202 | 20.2 | 569.7 ±0.5% | 757.8 ±1.0% | 1.33 |
| silesia/samba | 21606400 | 17.7 | 620.4 ±1.0% | 835.6 ±2.0% | 1.35 |
| silesia/sao | 7251944 | 63.3 | 185.8 ±1.6% | 277.3 ±2.6% | 1.49 |
| silesia/webster | 41458703 | 21.2 | 514.3 ±0.8% | 633.8 ±2.7% | 1.23 |
| silesia/x-ray | 8474240 | 55.3 | 155.4 ±5.9% | 184.5 ±2.9% | 1.19 |
| silesia/xml | 5345280 | 8.1 | 1291.0 ±1.0% | 1874.8 ±0.3% | 1.45 |
| canterbury/alice29.txt | 152089 | 30.6 | 382.7 ±0.2% | 573.6 ±0.2% | 1.50 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 326.5 ±0.2% | 490.7 ±1.0% | 1.50 |
| canterbury/cp.html | 24603 | 28.0 | 377.4 ±1.6% | 615.2 ±5.5% | 1.63 |
| canterbury/fields.c | 11150 | 24.4 | 488.4 ±1.9% | 729.8 ±0.2% | 1.49 |
| canterbury/grammar.lsp | 3721 | 30.2 | 345.5 ±0.2% | 503.1 ±0.1% | 1.46 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 614.5 ±0.4% | 904.7 ±0.3% | 1.47 |
| canterbury/lcet10.txt | 426754 | 26.6 | 437.6 ±0.2% | 660.7 ±0.3% | 1.51 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 373.7 ±0.2% | 553.2 ±0.2% | 1.48 |
| canterbury/ptt5 | 513216 | 8.0 | 793.8 ±0.2% | 1442.4 ±0.4% | 1.82 |
| canterbury/sum | 38240 | 26.5 | 313.9 ±0.4% | 427.2 ±1.2% | 1.36 |
| canterbury/xargs.1 | 4227 | 34.6 | 310.1 ±0.9% | 431.5 ±0.2% | 1.39 |
| canterbury-large/E.coli | 4638690 | 24.5 | 399.8 ±0.9% | 492.7 ±0.4% | 1.23 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 582.2 ±0.6% | 804.7 ±0.8% | 1.38 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 570.8 ±0.4% | 761.3 ±0.1% | 1.33 |
| http/html-1kx1024 | 1048576 | 30.3 | 189.5 ±0.1% | 235.8 ±0.3% | 1.24 |
| http/html-16kx64 | 1048576 | 16.8 | 504.9 ±0.0% | 686.1 ±0.1% | 1.36 |
| http/html-1m | 1048576 | 13.0 | 840.9 ±0.4% | 1188.7 ±0.7% | 1.41 |
| http/json-1kx1024 | 1048576 | 18.2 | 236.6 ±0.1% | 281.6 ±0.1% | 1.19 |
| http/json-16kx64 | 1048576 | 8.9 | 770.0 ±0.1% | 1035.0 ±0.1% | 1.34 |
| http/json-1m | 1048576 | 7.7 | 993.6 ±0.4% | 1390.7 ±0.2% | 1.40 |
| http/js-1kx1024 | 1048576 | 35.1 | 171.5 ±0.1% | 219.4 ±0.2% | 1.28 |
| http/js-16kx64 | 1048576 | 20.7 | 423.6 ±0.1% | 581.3 ±0.2% | 1.37 |
| http/js-1m | 1048576 | 14.0 | 780.0 ±0.5% | 1073.7 ±0.6% | 1.38 |
| http/css-1kx1024 | 1048576 | 22.5 | 221.0 ±0.1% | 263.3 ±0.2% | 1.19 |
| http/css-16kx64 | 1048576 | 11.7 | 688.3 ±0.2% | 922.1 ±0.2% | 1.34 |
| http/css-1m | 1048576 | 2.4 | 1392.8 ±0.5% | 4756.6 ±0.4% | 3.42 |
| shuffled/dickens-1m | 1048576 | 56.8 | 327.9 ±0.7% | 384.6 ±0.6% | 1.17 |
