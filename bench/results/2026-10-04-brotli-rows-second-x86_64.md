# bench-brotli

| Field | Value |
|---|---|
| Commit | 62875f6 |
| Runner label | ubuntu-24.04 |
| Image version | 20260927.320.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37233768758 |
| Date | 2026-10-04 |

## Decoding, quality 11, window 22

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 465.9 ±0.7% | 638.0 ±2.8% | 1.37 |
| silesia/mozilla | 51220480 | 27.5 | 299.1 ±0.3% | 382.3 ±0.2% | 1.28 |
| silesia/mr | 9970564 | 28.3 | 302.3 ±0.2% | 423.0 ±0.4% | 1.40 |
| silesia/nci | 33553445 | 4.8 | 1406.1 ±0.7% | 1739.9 ±4.0% | 1.24 |
| silesia/ooffice | 6152192 | 40.3 | 209.8 ±5.0% | 252.8 ±1.4% | 1.20 |
| silesia/osdb | 10085684 | 28.0 | 366.5 ±0.4% | 536.9 ±0.3% | 1.47 |
| silesia/reymont | 6627202 | 20.2 | 622.2 ±0.4% | 848.2 ±1.8% | 1.36 |
| silesia/samba | 21606400 | 17.7 | 550.6 ±1.2% | 732.7 ±0.7% | 1.33 |
| silesia/sao | 7251944 | 63.3 | 172.0 ±0.8% | 249.5 ±0.5% | 1.45 |
| silesia/webster | 41458703 | 21.2 | 547.1 ±2.0% | 782.8 ±0.3% | 1.43 |
| silesia/x-ray | 8474240 | 55.3 | 163.2 ±0.6% | 202.1 ±0.5% | 1.24 |
| silesia/xml | 5345280 | 8.1 | 1117.7 ±0.5% | 1419.8 ±0.7% | 1.27 |
| canterbury/alice29.txt | 152089 | 30.6 | 329.4 ±0.6% | 428.3 ±0.3% | 1.30 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 277.4 ±0.1% | 367.6 ±2.0% | 1.33 |
| canterbury/cp.html | 24603 | 28.0 | 391.6 ±0.6% | 506.9 ±0.4% | 1.29 |
| canterbury/fields.c | 11150 | 24.4 | 437.7 ±0.0% | 544.3 ±0.4% | 1.24 |
| canterbury/grammar.lsp | 3721 | 30.2 | 300.9 ±0.2% | 368.4 ±0.4% | 1.22 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 581.6 ±0.2% | 672.7 ±1.0% | 1.16 |
| canterbury/lcet10.txt | 426754 | 26.6 | 372.5 ±0.2% | 504.8 ±1.0% | 1.36 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 325.4 ±0.3% | 419.9 ±0.4% | 1.29 |
| canterbury/ptt5 | 513216 | 8.0 | 655.6 ±0.1% | 1106.6 ±0.5% | 1.69 |
| canterbury/sum | 38240 | 26.5 | 298.4 ±1.0% | 387.4 ±4.7% | 1.30 |
| canterbury/xargs.1 | 4227 | 34.6 | 269.4 ±0.3% | 314.1 ±0.7% | 1.17 |
| canterbury-large/E.coli | 4638690 | 24.5 | 342.9 ±0.6% | 425.4 ±0.2% | 1.24 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 592.1 ±0.5% | 784.4 ±0.5% | 1.32 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 527.0 ±0.4% | 682.7 ±0.4% | 1.30 |
| http/html-1kx1024 | 1048576 | 30.3 | 147.3 ±0.2% | 162.7 ±0.4% | 1.10 |
| http/html-16kx64 | 1048576 | 16.8 | 402.0 ±0.4% | 492.5 ±0.5% | 1.22 |
| http/html-1m | 1048576 | 13.0 | 698.8 ±0.4% | 917.2 ±0.2% | 1.31 |
| http/json-1kx1024 | 1048576 | 18.2 | 186.8 ±0.3% | 189.8 ±2.1% | 1.02 |
| http/json-16kx64 | 1048576 | 8.9 | 630.8 ±0.1% | 742.2 ±0.5% | 1.18 |
| http/json-1m | 1048576 | 7.7 | 826.1 ±0.3% | 1034.1 ±0.3% | 1.25 |
| http/js-1kx1024 | 1048576 | 35.1 | 133.1 ±0.4% | 150.8 ±0.3% | 1.13 |
| http/js-16kx64 | 1048576 | 20.7 | 343.4 ±0.3% | 417.6 ±0.3% | 1.22 |
| http/js-1m | 1048576 | 14.0 | 660.3 ±0.2% | 832.9 ±0.4% | 1.26 |
| http/css-1kx1024 | 1048576 | 22.5 | 172.8 ±1.8% | 178.2 ±0.1% | 1.03 |
| http/css-16kx64 | 1048576 | 11.7 | 556.3 ±2.5% | 654.0 ±0.3% | 1.18 |
| http/css-1m | 1048576 | 2.4 | 1172.3 ±0.2% | 3837.8 ±0.5% | 3.27 |
| shuffled/dickens-1m | 1048576 | 56.8 | 254.4 ±0.1% | 325.9 ±0.2% | 1.28 |

## stdx's fast path against its checked path

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 116.1 ±1.3% | 636.8 ±5.5% | 5.48 |
| silesia/mozilla | 51220480 | 27.5 | 102.6 ±1.3% | 381.7 ±0.7% | 3.72 |
| silesia/mr | 9970564 | 28.3 | 108.4 ±1.0% | 424.4 ±1.0% | 3.92 |
| silesia/nci | 33553445 | 4.8 | 224.2 ±0.6% | 1748.5 ±0.6% | 7.80 |
| silesia/ooffice | 6152192 | 40.3 | 75.3 ±1.9% | 251.7 ±1.1% | 3.34 |
| silesia/osdb | 10085684 | 28.0 | 125.3 ±1.5% | 533.6 ±1.7% | 4.26 |
| silesia/reymont | 6627202 | 20.2 | 141.7 ±2.8% | 859.4 ±0.4% | 6.06 |
| silesia/samba | 21606400 | 17.7 | 148.3 ±0.6% | 734.5 ±1.9% | 4.95 |
| silesia/sao | 7251944 | 63.3 | 74.3 ±0.8% | 251.4 ±0.4% | 3.38 |
| silesia/webster | 41458703 | 21.2 | 135.1 ±3.4% | 788.2 ±0.8% | 5.83 |
| silesia/x-ray | 8474240 | 55.3 | 68.3 ±1.5% | 202.9 ±1.1% | 2.97 |
| silesia/xml | 5345280 | 8.1 | 201.3 ±1.2% | 1419.0 ±0.3% | 7.05 |
| canterbury/alice29.txt | 152089 | 30.6 | 96.7 ±0.3% | 427.3 ±0.3% | 4.42 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 88.6 ±0.2% | 367.8 ±0.2% | 4.15 |
| canterbury/cp.html | 24603 | 28.0 | 101.1 ±0.2% | 499.0 ±0.4% | 4.93 |
| canterbury/fields.c | 11150 | 24.4 | 109.2 ±2.6% | 535.9 ±0.6% | 4.91 |
| canterbury/grammar.lsp | 3721 | 30.2 | 98.1 ±0.8% | 358.9 ±2.2% | 3.66 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 122.6 ±0.2% | 678.1 ±0.3% | 5.53 |
| canterbury/lcet10.txt | 426754 | 26.6 | 108.4 ±2.9% | 504.3 ±1.0% | 4.65 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 94.6 ±0.2% | 418.7 ±0.4% | 4.43 |
| canterbury/ptt5 | 513216 | 8.0 | 183.7 ±0.1% | 1110.2 ±0.5% | 6.04 |
| canterbury/sum | 38240 | 26.5 | 85.6 ±0.5% | 382.1 ±1.4% | 4.46 |
| canterbury/xargs.1 | 4227 | 34.6 | 88.8 ±0.3% | 313.1 ±0.7% | 3.53 |
| canterbury-large/E.coli | 4638690 | 24.5 | 89.1 ±1.7% | 425.6 ±0.1% | 4.78 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 130.8 ±2.3% | 782.3 ±2.3% | 5.98 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 136.5 ±0.5% | 682.0 ±0.4% | 5.00 |
| http/html-1kx1024 | 1048576 | 30.3 | 71.3 ±0.3% | 161.9 ±0.3% | 2.27 |
| http/html-16kx64 | 1048576 | 16.8 | 124.2 ±0.7% | 492.3 ±0.2% | 3.96 |
| http/html-1m | 1048576 | 13.0 | 159.9 ±0.3% | 918.8 ±0.2% | 5.75 |
| http/json-1kx1024 | 1048576 | 18.2 | 85.4 ±4.9% | 189.7 ±0.5% | 2.22 |
| http/json-16kx64 | 1048576 | 8.9 | 153.4 ±0.4% | 738.1 ±0.4% | 4.81 |
| http/json-1m | 1048576 | 7.7 | 171.0 ±0.6% | 1040.7 ±2.8% | 6.09 |
| http/js-1kx1024 | 1048576 | 35.1 | 65.3 ±0.4% | 150.4 ±0.3% | 2.30 |
| http/js-16kx64 | 1048576 | 20.7 | 109.1 ±0.5% | 416.3 ±0.2% | 3.81 |
| http/js-1m | 1048576 | 14.0 | 150.8 ±1.8% | 831.9 ±0.1% | 5.52 |
| http/css-1kx1024 | 1048576 | 22.5 | 79.2 ±0.6% | 178.1 ±0.2% | 2.25 |
| http/css-16kx64 | 1048576 | 11.7 | 139.1 ±0.6% | 659.2 ±0.3% | 4.74 |
| http/css-1m | 1048576 | 2.4 | 261.4 ±0.8% | 3916.5 ±0.6% | 14.98 |
| shuffled/dickens-1m | 1048576 | 56.8 | 77.9 ±0.4% | 325.8 ±0.9% | 4.18 |

## The claims, each off against the fast path with all on

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | S1 word refill off | S4 chunk copies off | S5 window once off | unchecked loop off |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 632.6 ±1.6% | 0.59 ±1.3% | 0.48 ±0.4% | 0.98 ±0.3% | 0.58 ±2.5% |
| silesia/mozilla | 51220480 | 27.5 | 380.8 ±1.1% | 0.69 ±1.4% | 0.64 ±0.3% | 0.98 ±0.3% | 0.72 ±0.3% |
| silesia/mr | 9970564 | 28.3 | 423.7 ±0.5% | 0.69 ±0.3% | 0.62 ±0.7% | 0.96 ±0.6% | 0.71 ±0.5% |
| silesia/nci | 33553445 | 4.8 | 1736.5 ±0.8% | 0.69 ±0.6% | 0.55 ±0.1% | 0.92 ±0.9% | 0.70 ±0.2% |
| silesia/ooffice | 6152192 | 40.3 | 252.6 ±0.2% | 0.67 ±1.3% | 0.62 ±0.8% | 0.99 ±1.5% | 0.70 ±0.4% |
| silesia/osdb | 10085684 | 28.0 | 539.5 ±0.5% | 0.67 ±0.4% | 0.66 ±2.2% | 0.98 ±0.5% | 0.72 ±0.2% |
| silesia/reymont | 6627202 | 20.2 | 849.1 ±0.5% | 0.59 ±0.5% | 0.46 ±0.6% | 0.97 ±0.5% | 0.60 ±0.3% |
| silesia/samba | 21606400 | 17.7 | 734.5 ±0.5% | 0.68 ±0.2% | 0.58 ±0.6% | 0.96 ±0.6% | 0.70 ±0.1% |
| silesia/sao | 7251944 | 63.3 | 252.5 ±1.0% | 0.69 ±0.1% | 0.70 ±0.3% | 0.98 ±0.4% | 0.71 ±0.4% |
| silesia/webster | 41458703 | 21.2 | 782.6 ±0.8% | 0.58 ±0.4% | 0.47 ±0.2% | 0.96 ±1.8% | 0.61 ±0.6% |
| silesia/x-ray | 8474240 | 55.3 | 203.4 ±0.6% | 0.69 ±1.7% | 0.73 ±0.8% | 0.99 ±0.8% | 0.73 ±1.0% |
| silesia/xml | 5345280 | 8.1 | 1425.3 ±0.3% | 0.66 ±0.1% | 0.51 ±0.4% | 0.95 ±0.5% | 0.67 ±0.6% |
| canterbury/alice29.txt | 152089 | 30.6 | 424.8 ±0.6% | 0.65 ±0.4% | 0.55 ±0.4% | 1.00 ±0.4% | 0.66 ±2.6% |
| canterbury/asyoulik.txt | 125179 | 34.1 | 368.0 ±0.2% | 0.65 ±0.8% | 0.57 ±0.3% | 0.99 ±2.2% | 0.66 ±0.2% |
| canterbury/cp.html | 24603 | 28.0 | 506.4 ±0.2% | 0.71 ±1.8% | 0.67 ±1.9% | 0.99 ±0.4% | 0.64 ±1.6% |
| canterbury/fields.c | 11150 | 24.4 | 538.7 ±0.3% | 0.70 ±0.6% | 0.65 ±0.4% | 1.00 ±0.2% | 0.63 ±0.5% |
| canterbury/grammar.lsp | 3721 | 30.2 | 368.6 ±1.9% | 0.76 ±0.1% | 0.72 ±0.4% | 0.99 ±0.2% | 0.69 ±5.2% |
| canterbury/kennedy.xls | 1029744 | 6.0 | 677.6 ±0.7% | 0.59 ±2.5% | 0.54 ±0.5% | 0.98 ±0.5% | 0.57 ±0.3% |
| canterbury/lcet10.txt | 426754 | 26.6 | 498.0 ±0.6% | 0.64 ±0.3% | 0.55 ±0.3% | 0.99 ±0.4% | 0.67 ±0.4% |
| canterbury/plrabn12.txt | 481861 | 33.9 | 414.5 ±0.2% | 0.64 ±0.4% | 0.56 ±0.3% | 0.99 ±2.3% | 0.65 ±0.2% |
| canterbury/ptt5 | 513216 | 8.0 | 1112.6 ±0.4% | 0.67 ±0.1% | 0.48 ±0.2% | 0.96 ±0.3% | 0.70 ±0.2% |
| canterbury/sum | 38240 | 26.5 | 386.1 ±0.8% | 0.59 ±1.0% | 0.56 ±1.0% | 0.98 ±4.5% | 0.61 ±4.0% |
| canterbury/xargs.1 | 4227 | 34.6 | 315.3 ±2.2% | 0.77 ±0.6% | 0.74 ±0.1% | 0.99 ±0.3% | 0.69 ±0.9% |
| canterbury-large/E.coli | 4638690 | 24.5 | 425.1 ±0.1% | 0.84 ±0.3% | 0.85 ±0.2% | 0.98 ±0.1% | 0.81 ±0.3% |
| canterbury-large/bible.txt | 4047392 | 22.0 | 780.6 ±0.4% | 0.57 ±0.9% | 0.46 ±0.3% | 0.97 ±0.7% | 0.58 ±0.5% |
| canterbury-large/world192.txt | 2473400 | 19.2 | 681.8 ±0.7% | 0.65 ±0.4% | 0.53 ±0.4% | 0.96 ±3.5% | 0.66 ±0.5% |
| http/html-1kx1024 | 1048576 | 30.3 | 160.3 ±0.2% | 0.83 ±0.3% | 0.81 ±0.2% | 1.00 ±0.2% | 0.82 ±0.5% |
| http/html-16kx64 | 1048576 | 16.8 | 488.5 ±0.3% | 0.73 ±0.6% | 0.64 ±3.0% | 0.99 ±0.3% | 0.74 ±0.1% |
| http/html-1m | 1048576 | 13.0 | 918.1 ±0.5% | 0.63 ±0.2% | 0.51 ±0.4% | 0.96 ±0.2% | 0.65 ±0.5% |
| http/json-1kx1024 | 1048576 | 18.2 | 189.6 ±1.9% | 0.85 ±1.1% | 0.84 ±2.0% | 0.98 ±1.1% | 0.85 ±0.3% |
| http/json-16kx64 | 1048576 | 8.9 | 737.4 ±0.3% | 0.68 ±0.4% | 0.62 ±0.8% | 0.98 ±0.4% | 0.69 ±0.2% |
| http/json-1m | 1048576 | 7.7 | 1038.1 ±0.8% | 0.62 ±0.2% | 0.55 ±0.7% | 0.94 ±0.2% | 0.63 ±0.4% |
| http/js-1kx1024 | 1048576 | 35.1 | 150.6 ±0.3% | 0.81 ±0.1% | 0.78 ±0.3% | 0.99 ±0.3% | 0.80 ±0.3% |
| http/js-16kx64 | 1048576 | 20.7 | 417.2 ±1.2% | 0.71 ±0.5% | 0.62 ±0.2% | 0.99 ±0.3% | 0.72 ±0.9% |
| http/js-1m | 1048576 | 14.0 | 832.2 ±0.4% | 0.63 ±0.3% | 0.51 ±0.1% | 0.96 ±1.4% | 0.66 ±0.3% |
| http/css-1kx1024 | 1048576 | 22.5 | 178.0 ±2.3% | 0.84 ±0.4% | 0.79 ±0.2% | 0.98 ±0.4% | 0.82 ±0.6% |
| http/css-16kx64 | 1048576 | 11.7 | 651.7 ±0.2% | 0.69 ±0.2% | 0.58 ±0.3% | 0.98 ±0.2% | 0.71 ±7.2% |
| http/css-1m | 1048576 | 2.4 | 3919.4 ±0.5% | 0.64 ±0.6% | 0.39 ±0.2% | 0.83 ±0.8% | 0.60 ±0.4% |
| shuffled/dickens-1m | 1048576 | 56.8 | 326.0 ±0.2% | 0.81 ±0.2% | 0.85 ±0.1% | 0.98 ±0.7% | 0.83 ±0.1% |

## stdx built ReleaseFast against Google's brotli, quality 11, window 22 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 471.1 ±0.9% | 637.4 ±0.5% | 1.35 |
| silesia/mozilla | 51220480 | 27.5 | 296.5 ±1.0% | 379.1 ±2.0% | 1.28 |
| silesia/mr | 9970564 | 28.3 | 303.2 ±0.3% | 423.5 ±3.5% | 1.40 |
| silesia/nci | 33553445 | 4.8 | 1397.8 ±2.5% | 1741.5 ±1.2% | 1.25 |
| silesia/ooffice | 6152192 | 40.3 | 209.8 ±0.8% | 253.0 ±2.0% | 1.21 |
| silesia/osdb | 10085684 | 28.0 | 364.7 ±0.3% | 537.3 ±0.5% | 1.47 |
| silesia/reymont | 6627202 | 20.2 | 625.3 ±0.5% | 815.9 ±0.3% | 1.30 |
| silesia/samba | 21606400 | 17.7 | 545.3 ±0.8% | 736.2 ±0.8% | 1.35 |
| silesia/sao | 7251944 | 63.3 | 171.1 ±0.4% | 252.5 ±0.3% | 1.48 |
| silesia/webster | 41458703 | 21.2 | 547.9 ±0.4% | 777.0 ±0.5% | 1.42 |
| silesia/x-ray | 8474240 | 55.3 | 163.7 ±0.5% | 205.5 ±0.2% | 1.26 |
| silesia/xml | 5345280 | 8.1 | 1115.0 ±1.1% | 1436.4 ±0.7% | 1.29 |
| canterbury/alice29.txt | 152089 | 30.6 | 330.9 ±3.5% | 426.7 ±2.5% | 1.29 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 280.0 ±0.1% | 371.0 ±0.3% | 1.32 |
| canterbury/cp.html | 24603 | 28.0 | 385.3 ±1.4% | 488.8 ±0.8% | 1.27 |
| canterbury/fields.c | 11150 | 24.4 | 437.1 ±3.2% | 544.2 ±0.1% | 1.25 |
| canterbury/grammar.lsp | 3721 | 30.2 | 295.4 ±0.3% | 383.2 ±0.5% | 1.30 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 586.6 ±2.7% | 679.6 ±0.6% | 1.16 |
| canterbury/lcet10.txt | 426754 | 26.6 | 374.7 ±0.4% | 501.9 ±0.2% | 1.34 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 328.4 ±0.6% | 422.9 ±1.3% | 1.29 |
| canterbury/ptt5 | 513216 | 8.0 | 652.3 ±0.2% | 1111.3 ±0.2% | 1.70 |
| canterbury/sum | 38240 | 26.5 | 293.2 ±1.2% | 376.2 ±1.2% | 1.28 |
| canterbury/xargs.1 | 4227 | 34.6 | 268.7 ±0.2% | 319.2 ±0.2% | 1.19 |
| canterbury-large/E.coli | 4638690 | 24.5 | 342.1 ±0.3% | 424.3 ±0.2% | 1.24 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 592.5 ±0.2% | 781.4 ±0.1% | 1.32 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 528.4 ±1.9% | 684.3 ±1.0% | 1.29 |
| http/html-1kx1024 | 1048576 | 30.3 | 147.7 ±0.2% | 169.3 ±0.4% | 1.15 |
| http/html-16kx64 | 1048576 | 16.8 | 402.1 ±0.2% | 497.1 ±0.2% | 1.24 |
| http/html-1m | 1048576 | 13.0 | 699.5 ±0.2% | 923.3 ±0.3% | 1.32 |
| http/json-1kx1024 | 1048576 | 18.2 | 185.9 ±0.3% | 202.1 ±0.3% | 1.09 |
| http/json-16kx64 | 1048576 | 8.9 | 628.3 ±1.2% | 754.8 ±0.3% | 1.20 |
| http/json-1m | 1048576 | 7.7 | 823.0 ±0.3% | 1034.9 ±0.4% | 1.26 |
| http/js-1kx1024 | 1048576 | 35.1 | 133.5 ±0.2% | 156.7 ±0.2% | 1.17 |
| http/js-16kx64 | 1048576 | 20.7 | 343.0 ±0.3% | 421.7 ±0.1% | 1.23 |
| http/js-1m | 1048576 | 14.0 | 659.0 ±0.3% | 837.4 ±0.5% | 1.27 |
| http/css-1kx1024 | 1048576 | 22.5 | 172.6 ±0.2% | 188.8 ±0.4% | 1.09 |
| http/css-16kx64 | 1048576 | 11.7 | 553.5 ±0.1% | 658.6 ±0.5% | 1.19 |
| http/css-1m | 1048576 | 2.4 | 1281.0 ±0.4% | 3955.7 ±0.3% | 3.09 |
| shuffled/dickens-1m | 1048576 | 56.8 | 251.3 ±0.2% | 325.5 ±0.4% | 1.30 |
